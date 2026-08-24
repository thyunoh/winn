/* ============================================================================
   09.욕창 처치를 실시한 환자분율 — 지표 생성 프로시저의 해당 블록 교체본

   프로시저 안의 09번 산정 구간
       WITH current_month AS (...) previousmonth AS (...) SELECT ... INTO dtorvalue, ntorvalue ...
       SET cate_gory = '09'; SET cate_flag = '21'; CALL SP_EVALUATION_INDICATORS_REGISTER(...);
   을 아래 내용으로 통째로 교체한다.

   ---------------------------------------------------------------------------
   [이번 교체 내용 2026-08-24] — ★ 기존 충족(분자) 조건은 전부 그대로 유지
   ---------------------------------------------------------------------------
   1) current_month 의 EVAL_TYPE 을 보기 그리드(select_CategoryList09)와 동일하게 확장.
      - 종전 : AND IFNULL(a.EVAL_TYPE,'') = '2'  (정기평가만)
      - 교체 : EVAL_TYPE='2' OR (EVAL_TYPE='3' + 개시일 1일 + 작성일 7~10 + 전월 동일 작성일 없음)
      - 10번(SP_EVAL_CATE10_block)·11번(SP_EVAL_CATE11_block)과 완전히 같은 보정.
        그리드에는 잡히는 월초 초기평가('3') 환자가 SP 분모·분자에서 빠져
        분모/분자가 그리드 행 수와 어긋나던 경우의 수 제거.

   2) 분자 CASE 정리 — 판정 로직 무변경.
      - 기존 충족 조건 6개 블록은 글자 그대로 유지.
      - 주석 처리돼 있던 옛 초안(처치 조건 없는 hasPrev AND (0000 OR 1000))은 삭제.
      - 추가 블록(2026-07-11 심평원 산식 보정과 짝) 정식 반영 :
            전월 욕창 있음(1~4단계 합>0)
            AND 당월 '0000'(치유) 또는 '1000'(1단계 1부위로 호전)
            AND 압력완화(a)+체위변경(b)+영양공급(c) = 3   ← 드레싱(d) 제외
        = 그리드 dressingYn CASE 의 [심평원 산식 보정 2026-07-11] 블록과 동일 조건.
        (전월 3·4단계 → 당월 1단계 호전 케이스가 '미처치'로 떨어지던 것 보정)

   ---------------------------------------------------------------------------
   그대로 둔 것
   ---------------------------------------------------------------------------
   - 분모 = COUNT(DISTINCT pm.patId)  (JOIN 전체 — 09번에는 '제외' 개념 없음)
   - previousmonth : 전월 MAX(ADMIT_DT) + 전월 욕창 1~4단계 합 > 0
     (※ 11번과 달리 1단계도 포함 — 그리드와 동일하므로 손대지 말 것)
   - 기존 분자 조건 6개 블록 전부
   - FORCE INDEX (INDEX01)

   ---------------------------------------------------------------------------
   ⚠ 주의
   ---------------------------------------------------------------------------
   1) EVAL_TYPE 확장으로 분모·분자가 함께 늘 수 있다(월초 초기평가 환자 편입).
      그리드 화면과의 대조 : 분모 = 전월단계 값이 있는 행 수,
      분자 = '해당' 표시 행 수와 일치해야 한다.
   2) [미해결·별건] 화면(assessment.jsp L3586~) JS 의 '2'+condMet '해당' 오버라이드는
      curtStep1 === '1' 만 보고 당월 2~4단계 0 여부를 확인하지 않는다.
      예) 당월 (1,1,0,0) + a·b·c 실시 → 화면은 '해당', SP·그리드 SQL 은 미충족.
      이 케이스가 실제로 나오면 화면 JS 를 SQL 과 같은 '1000' 판정으로 맞출지 결정 필요.
   ============================================================================ */

 		WITH current_month AS (
		    SELECT a.PAT_ID                      AS patId
		         , CAST(a.PR_ULCER1 AS UNSIGNED) AS curtStep1
		         , CAST(a.PR_ULCER2 AS UNSIGNED) AS curtStep2
		         , CAST(a.PR_ULCER3 AS UNSIGNED) AS curtStep3
		         , CAST(a.PR_ULCER4 AS UNSIGNED) AS curtStep4
		         , IFNULL(a.PRESS_REL_DEV,0)     AS preRelDev
		         , IFNULL(a.POS_CHANGE,0)        AS posChange
		         , IFNULL(a.NUTR_SKIN,0)         AS nutSupply
		         , IFNULL(a.SKIN_ULC_DRES,0)     AS skinDress
		      FROM TBL_PATVAL_MST a
		      FORCE INDEX (INDEX01) /* 20260303 */
		     WHERE a.HOSP_CD = hosp_cd
		       AND a.MED_START LIKE CONCAT(job_month,'%')
		       /* ★ 변경: 보기 그리드(select_CategoryList09)와 동일 — 정기평가('2') + 월초 초기평가('3') */
		       AND (
		             a.EVAL_TYPE = '2'
		             OR (
		                  a.EVAL_TYPE = '3'
		                  AND DAY(STR_TO_DATE(a.MED_START, '%Y%m%d')) = 1
		                  AND DAY(STR_TO_DATE(a.DOC_DT,   '%Y%m%d')) BETWEEN 7 AND 10
		                  AND NOT EXISTS (
		                          SELECT 1
		                            FROM TBL_PATVAL_MST b
		                           WHERE b.HOSP_CD            = a.HOSP_CD
		                             AND b.PAT_ID             = a.PAT_ID
		                             AND LEFT(b.MED_START, 6) = DATE_FORMAT(DATE_SUB(STR_TO_DATE(a.MED_START, '%Y%m%d'), INTERVAL 1 MONTH), '%Y%m')
		                             AND b.DOC_DT             = a.DOC_DT )
		                )
		           )
		),
		previousmonth AS (
		    SELECT b.PAT_ID                      AS patId
		         , CAST(b.PR_ULCER1 AS UNSIGNED) AS prevStep1
		         , CAST(b.PR_ULCER2 AS UNSIGNED) AS prevStep2
		         , CAST(b.PR_ULCER3 AS UNSIGNED) AS prevStep3
		         , CAST(b.PR_ULCER4 AS UNSIGNED) AS prevStep4
		      FROM TBL_PATVAL_MST b
		      FORCE INDEX (INDEX01) /* 20260303 */
		     WHERE b.HOSP_CD = hosp_cd
		       AND b.MED_START LIKE CONCAT(pre_month,'%')
		       AND b.ADMIT_DT = (SELECT MAX(c.ADMIT_DT)
		                           FROM TBL_PATVAL_MST c
		                           FORCE INDEX (INDEX01) /* 20260303 */
		                          WHERE c.HOSP_CD   = b.HOSP_CD
		                            AND c.PAT_ID    = b.PAT_ID
		                            AND c.MED_START LIKE CONCAT(pre_month,'%'))
		       AND CAST(b.PR_ULCER1 AS UNSIGNED) +
		           CAST(b.PR_ULCER2 AS UNSIGNED) +
		           CAST(b.PR_ULCER3 AS UNSIGNED) +
		           CAST(b.PR_ULCER4 AS UNSIGNED) > 0
		)
		SELECT COUNT(DISTINCT pm.patId)
		     , COUNT(DISTINCT CASE WHEN
		           /* 기존 조건들 — 무변경 */
		           (COALESCE(pm.prevStep1,0) + COALESCE(pm.prevStep2,0) + COALESCE(pm.prevStep3,0) + COALESCE(pm.prevStep4,0) > 0 AND
		            COALESCE(cm.curtStep1,0) + COALESCE(cm.curtStep2,0) + COALESCE(cm.curtStep3,0) + COALESCE(cm.curtStep4,0) > 0 AND
		            COALESCE(cm.preRelDev,0) + COALESCE(cm.posChange,0) + COALESCE(cm.nutSupply,0) + COALESCE(cm.skinDress,0) = 4)
		           OR
		           (COALESCE(pm.prevStep1,0) + COALESCE(pm.prevStep2,0) + COALESCE(pm.prevStep3,0) + COALESCE(pm.prevStep4,0) > 0 AND
		            COALESCE(cm.curtStep1,0) + COALESCE(cm.curtStep2,0) + COALESCE(cm.curtStep3,0) + COALESCE(cm.curtStep4,0) = 0 AND
		            COALESCE(cm.preRelDev,0) + COALESCE(cm.posChange,0) + COALESCE(cm.nutSupply,0) = 3)
		           OR
		           (((pm.prevStep1 > 0) AND CONCAT(pm.prevStep2, pm.prevStep3, pm.prevStep4) = '000') AND
		            ((cm.curtStep1 > 0) AND CONCAT(cm.curtStep2, cm.curtStep3, cm.curtStep4) = '000') AND
		             (COALESCE(cm.preRelDev,0) + COALESCE(cm.posChange,0) + COALESCE(cm.nutSupply,0)) = 3)
		           OR
		           (((pm.prevStep2 > 0) AND CONCAT(pm.prevStep3, pm.prevStep4) = '00') AND
		            ((cm.curtStep1 > 0) AND CONCAT(cm.curtStep2, cm.curtStep3, cm.curtStep4) = '000') AND
		             (COALESCE(cm.preRelDev,0) + COALESCE(cm.posChange,0) + COALESCE(cm.nutSupply,0)) = 3)
		           OR
		           ((COALESCE(pm.prevStep1,0) + COALESCE(pm.prevStep2,0) +
		             COALESCE(pm.prevStep3,0) + COALESCE(pm.prevStep4,0) > 0) AND
		            (CONCAT(cm.curtStep1, cm.curtStep2, cm.curtStep3, cm.curtStep4) = '0000') AND
		            (COALESCE(cm.preRelDev,0) + COALESCE(cm.posChange,0) + COALESCE(cm.nutSupply,0)) = 3)
		           OR
		           (COALESCE(cm.curtStep2,0) + COALESCE(cm.curtStep3,0) + COALESCE(cm.curtStep4,0) > 0 AND
		            COALESCE(cm.preRelDev,0) + COALESCE(cm.posChange,0) + COALESCE(cm.nutSupply,0) + COALESCE(cm.skinDress,0) = 4)
		           OR
		           /* 추가: 전월 욕창 있음 → 당월 치유('0000') 또는 1단계('1000') 호전
		              — 단, 처치 a+b+c(압력·체위·영양) 실시한 경우만 (드레싱 d 제외)
              — 그리드 select_CategoryList09 의 [심평원 산식 보정 2026-07-11] 블록과 동일 */
		           (COALESCE(pm.prevStep1,0) + COALESCE(pm.prevStep2,0) +
		            COALESCE(pm.prevStep3,0) + COALESCE(pm.prevStep4,0) > 0
		            AND (
		                  CONCAT(cm.curtStep1, cm.curtStep2, cm.curtStep3, cm.curtStep4) = '0000'
		                  OR
		                  CONCAT(cm.curtStep1, cm.curtStep2, cm.curtStep3, cm.curtStep4) = '1000'
		            )
		            AND (COALESCE(cm.preRelDev,0) + COALESCE(cm.posChange,0) + COALESCE(cm.nutSupply,0)) = 3
		           )
		       THEN cm.patId END)
		  INTO dtorvalue, ntorvalue
		  FROM current_month cm
		  JOIN previousmonth pm ON cm.patId = pm.patId;

		SET cate_gory = '09';
		SET cate_flag = '21';
        CALL SP_EVALUATION_INDICATORS_REGISTER(hosp_cd, str_month, str_month, job_month, cate_gory, cate_flag, dtorvalue, ntorvalue, user_id);
