/* ============================================================================
   06.배뇨관리 실시 환자분율 — 지표 생성 프로시저의 해당 블록 교체본

   프로시저 안의
       /* 06.배뇨관리 실시 환자분율 start */ ~ /* 06.배뇨관리 실시 환자분율 end */
   구간을 아래 내용으로 통째로 교체한다.

   ---------------------------------------------------------------------------
   해결하는 문제
   ---------------------------------------------------------------------------
   청구서(명세서)를 아직 안 돌린 달에는 분모만 나오고 분자가 0 이 된다.
   분모는 평가표(TBL_PATVAL_MST)만 보는데, 분자 서브쿼리(sb)는
       TBL_MYOUNG_MST · TBL_CHUNG_MST · TBL_JINORD_MST · TBL_DISEASE_MST
   4개를 INNER JOIN 으로 걸어서, 청구자료가 없으면 대상자가 전원 탈락하기 때문이다.
   주진단(DIAG_TYPE='1') 행이 없는 환자도 같은 이유로 사라진다.

   ---------------------------------------------------------------------------
   바꾼 것 (2가지)
   ---------------------------------------------------------------------------
   1) 청구 4개 테이블 INNER JOIN 제거 → 분자는 평가표만으로 판정한다.

      ※ LEFT JOIN 으로 바꾸는 것만으로는 해결되지 않는다.
         mm 이 NULL 이 되면
             AND EXISTS (SELECT 1 FROM TBL_JINORD_MST jsm
                          WHERE jsm.HOSP_CD = mm.HOSP_CD ...)
         이 항상 거짓이 되어 같은 환자가 또 떨어진다.
         그래서 조인을 걷어내고, 청구 기반 조건을 상관 서브쿼리로 옮겼다.
         해당 월 청구자료가 없으면 그 조건이 자동으로 참이 되어 "무시" 된다.
         청구서를 올리고 나면 예전과 동일하게 다시 적용된다.

   2) 분자 집계 기준을 sb.BILL_SEQ → sb.PAT_ID 로 변경.
      조인을 없애면서 sb 가 더 이상 BILL_SEQ 를 갖지 않는다.
      (원래도 COUNT(DISTINCT pm.PAT_ID) 라 환자 수 기준이었으므로 결과는 동일)

   ---------------------------------------------------------------------------
   그대로 둔 것
   ---------------------------------------------------------------------------
   - 분자 조건 ①② 의 `배뇨일지 3일 이상` (DIARY_DAYS >= 3)
     → 일정배뇨(UR_PLAN='1') 에 체크가 있어도 배뇨일지 작성일수가 비어 있으면
       여전히 분자에 들어가지 않는다. 확인은 diag_cate06_numerator.sql 의 [B] 블록.
   - URINE_MGMT 의 NULL 안전 비교 (이미 적용된 상태)
   - 최고도(PAT_CLASS='A') · URINE_MGMT · 요로전환술 제외

   ---------------------------------------------------------------------------
   추가 변경 (2026-07-13) — 치매+BPSD+향정신약 처리를 매퍼(select_CategoryList06)와 일치
   ---------------------------------------------------------------------------
   기존: 치매+BPSD+향정신약을 관리여부와 무관하게 분모·분자 모두에서 제외 →
         '관리하는' 치매케이스가 인정 안 됨(매퍼는 'Y'로 관리 인정).
   변경:
     1) 분자(sb) 의 치매 제외 조건 삭제 → '관리하는' 치매케이스를 분자로 인정.
     2) 분모/분자 집계를 매퍼 manageYn 3분류(Y/공란/제외)로 통일 →
        SELECT 의 CASE 로 판정: 'Y'(sb매칭)·''(분모-비관리)·'제외'(최고도·치매비관리).
        분모 = COUNT(DISTINCT CASE WHEN 제외아님 THEN PAT_ID) , 분자 = COUNT(DISTINCT CASE WHEN sb매칭 THEN PAT_ID).
        바깥 WHERE 의 치매 제외 블록은 삭제(판정을 CASE 로 일원화).
   결과: 매퍼 표시와 동일 — 치매 관리='Y'(분모·분자), 치매 비관리='제외'(둘 다 제외).
   ============================================================================ */

		/* 06.배뇨관리 실시 환자분율 start */
		IF EXISTS (
		    SELECT 1
		      FROM TBL_WEVALUE_MST
		     WHERE CATE_CODE = '06'
		       AND CONCAT(str_month, '01') BETWEEN START_DT AND END_DT
		) THEN
			  /* 분모/분자 판정을 매퍼(select_CategoryList06)의 manageYn 3분류와 동일하게:
			       'Y'(분자=sb매칭) / ''(분모-비관리) / '제외'(최고도·치매비관리)
			     분모 = '제외' 아닌 것(= Y + 공란), 분자 = 'Y'(sb매칭). */
			  SELECT COUNT(DISTINCT CASE
			                 WHEN sb.PAT_ID IS NOT NULL THEN pm.PAT_ID                          -- 'Y' 분자(관리) → 분모 포함
			                 WHEN LEFT(COALESCE(pm.PAT_CLASS,'E'),1) NOT IN ('A')               -- '' 분모-비관리
			                      AND NOT ( LEFT(COALESCE(pm.PAT_CLASS,'E'),1) IN ('B','C')
			                                AND pm.DEMENTIA = '1'
			                                AND ( pm.DELUSION IN('2','3') OR pm.HALLUCIN IN('2','3') OR pm.AGITATION IN('2','3')
			                                   OR pm.DISINHIB IN('2','3') OR pm.CARE_RESIST IN('2','3') OR pm.WANDER IN('2','3') )
			                                AND pm.PSYCH_DRUG = '1' )
			                    THEN pm.PAT_ID
			                 ELSE NULL                                                          -- '제외'(최고도·치매비관리) → 분모 제외
			               END)
			       , COUNT(DISTINCT CASE WHEN sb.PAT_ID IS NOT NULL THEN pm.PAT_ID END)          -- 'Y' 분자
			      INTO dtorvalue, ntorvalue
			  FROM TBL_PATVAL_MST pm FORCE INDEX (INDEX01)
			  LEFT JOIN (
			      /* ---- 분자 대상자 : 평가표(TBL_PATVAL_MST) 만으로 판정 ---- */
			      SELECT DISTINCT
			             pat.HOSP_CD
			           , pat.PAT_ID
			        FROM TBL_PATVAL_MST pat FORCE INDEX (INDEX01)
			       WHERE pat.HOSP_CD = hosp_cd
			         AND pat.MED_START LIKE CONCAT(job_month, '%')
			         AND pat.URINE_CTL IN ('2','3')   -- 2.자주실금함, 3.조절못함
			         /*  분자: ① ∨ ② ∨ ③ 중 하나 이상 */
			         AND (
			              /* ① 일정하게 짜여진 배뇨계획 + 배뇨일지 3일이상 */
			              ( pat.UR_PLAN        = '1'
			            /*    AND pat.DIARY_CREATED = '1' */
			                AND CAST(NULLIF(pat.DIARY_DAYS,'') AS UNSIGNED) >= 3 )
			              /* ② 방광훈련프로그램 + 배뇨일지 3일이상 */
			           OR ( pat.BLAD_TRAIN     = '1'
			           /*    AND pat.DIARY_CREATED = '1'  */
			                AND CAST(NULLIF(pat.DIARY_DAYS,'') AS UNSIGNED) >= 3 )
			              /* ③ 규칙적 도뇨 (배뇨일지 요건 없음) */
			           OR ( pat.REG_CATH       = '1' )
			             )
			         /* 제외 대상 */
			         AND LEFT(COALESCE(pat.PAT_CLASS, 'E'), 1) NOT IN ('A')   -- 의료최고도
			         /* 치매+BPSD+향정신약은 분자(sb)에서 필터하지 않는다 — 매퍼(select_CategoryList06)와 동일.
			            '관리하는' 치매케이스는 분자로 인정하고, '관리 안 하는' 치매케이스만
			            아래 분모 WHERE 에서 제외한다. */
			         AND COALESCE(pat.URINE_MGMT, '') <> '1'                  -- 배뇨관련 루 관리 제외
			         AND IFNULL(pat.EVAL_TYPE,'') IN ('1','2')

			         /* ------------------------------------------------------------------
			            [청구 기반 제외 ①] 요로전환술 주진단(Z935/Z936/T830) 제외.
			            해당 월 청구자료가 없으면 NOT EXISTS 가 참 → 그대로 통과(조건 무시).
			            ------------------------------------------------------------------ */
			         AND NOT EXISTS (
			                 SELECT 1
			                   FROM TBL_MYOUNG_MST  mm
			                   JOIN TBL_CHUNG_MST   cm ON cm.HOSP_CD  = mm.HOSP_CD
			                                          AND cm.CLAIM_NO = mm.CLAIM_NO
			                   JOIN TBL_DISEASE_MST dm ON dm.HOSP_CD  = mm.HOSP_CD
			                                          AND dm.CLAIM_NO = mm.CLAIM_NO
			                                          AND dm.BILL_SEQ = mm.BILL_SEQ
			                                          AND dm.DIAG_TYPE = '1'
			                  WHERE mm.HOSP_CD = pat.HOSP_CD
			                    AND mm.PAT_ID  = pat.PAT_ID
			                    AND cm.DATE_YM = job_month
			                    AND COALESCE(mm.DELYN, '') = ''
			                    AND SUBSTRING(dm.DIAG_CODE, 1, 4) IN ('Z935','Z936','T830'))

			         /* ------------------------------------------------------------------
			            [청구 기반 제외 ②] JS008 특정내역 / 진료내역(ITEM_NO<>'L') 요건.
			            첫 항: 해당 월 유효 명세서가 하나도 없으면 참 → 조건을 건너뛴다.
			            둘째 항: 명세서가 있으면 예전과 동일하게
			                     "JS008 이 붙지 않은 진료내역이 있고,
			                      L 이 아닌 진료내역이 있는" 명세서가 하나라도 있어야 한다.
			            ------------------------------------------------------------------ */
			         AND ( NOT EXISTS (
			                   SELECT 1
			                     FROM TBL_MYOUNG_MST mm2
			                     JOIN TBL_CHUNG_MST  cm2 ON cm2.HOSP_CD  = mm2.HOSP_CD
			                                            AND cm2.CLAIM_NO = mm2.CLAIM_NO
			                    WHERE mm2.HOSP_CD = pat.HOSP_CD
			                      AND mm2.PAT_ID  = pat.PAT_ID
			                      AND cm2.DATE_YM = job_month
			                      AND COALESCE(mm2.DELYN, '') = '')
			               OR EXISTS (
			                   SELECT 1
			                     FROM TBL_MYOUNG_MST mm
			                     JOIN TBL_CHUNG_MST  cm ON cm.HOSP_CD  = mm.HOSP_CD
			                                           AND cm.CLAIM_NO = mm.CLAIM_NO
			                     JOIN TBL_JINORD_MST jm ON jm.HOSP_CD  = mm.HOSP_CD
			                                           AND jm.CLAIM_NO = mm.CLAIM_NO
			                                           AND jm.BILL_SEQ = mm.BILL_SEQ
			                    WHERE mm.HOSP_CD = pat.HOSP_CD
			                      AND mm.PAT_ID  = pat.PAT_ID
			                      AND cm.DATE_YM = job_month
			                      AND COALESCE(mm.DELYN, '') = ''
			                      AND NOT EXISTS (SELECT 1
			                                        FROM TBL_SPECODE_MST tsm
			                                       WHERE tsm.HOSP_CD   = mm.HOSP_CD
			                                         AND tsm.CLAIM_NO  = mm.CLAIM_NO
			                                         AND tsm.BILL_SEQ  = mm.BILL_SEQ
			                                         AND tsm.ROW_NO    = jm.ROW_NO
			                                         AND tsm.SPEC_TYPE = 'JS008')
			                      AND EXISTS (SELECT 1
			                                    FROM TBL_JINORD_MST jsm
			                                   WHERE jsm.HOSP_CD  = mm.HOSP_CD
			                                     AND jsm.CLAIM_NO = mm.CLAIM_NO
			                                     AND jsm.BILL_SEQ = mm.BILL_SEQ
			                                     AND jsm.ITEM_NO <> 'L')) )
			     ) sb ON sb.HOSP_CD = pm.HOSP_CD
			          AND sb.PAT_ID  = pm.PAT_ID
			 WHERE pm.HOSP_CD = hosp_cd
			   AND pm.MED_START LIKE CONCAT(job_month, '%')
			   AND pm.URINE_CTL IN ('2','3')
			   AND LEFT(COALESCE(pm.PAT_CLASS, 'E'), 1) NOT IN ('A')      -- 의료최고도는 분모에서도 제외
	         AND IFNULL(pm.EVAL_TYPE,'') IN ('1','2')
			   ;
			   -- 최고도(위 WHERE) + 치매(비관리) '제외' 판정은 위 SELECT 의 manageYn CASE 가 처리 → 분모/분자에서 빠짐
			SET cate_gory = '06';
			SET cate_flag = '21';
			CALL SP_EVALUATION_INDICATORS_REGISTER(
			            hosp_cd, str_month, str_month, job_month,
			            cate_gory, cate_flag, dtorvalue, ntorvalue, user_id);

		END IF;
		/* 06.배뇨관리 실시 환자분율  end  */
