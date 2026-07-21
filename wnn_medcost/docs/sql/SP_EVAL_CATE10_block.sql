/* ============================================================================
   10.욕창이 새로생긴 환자분율 — 지표 생성 프로시저의 해당 블록 교체본

   프로시저 안의 10번 산정 구간
       WITH current_month AS (...) previousmonth AS (...) SELECT ... INTO dtorvalue, ntorvalue ...
       SET cate_gory = '10'; SET cate_flag = '22'; CALL SP_EVALUATION_INDICATORS_REGISTER(...);
   을 아래 내용으로 통째로 교체한다.

   ---------------------------------------------------------------------------
   해결하는 문제 (보기 그리드보다 분모·분자가 각각 1 작게 나옴)
   ---------------------------------------------------------------------------
   보기 그리드(MagamMapper.select_CategoryList10)와 이 산정 SP가
   '당월 대상(current_month)'을 서로 다르게 정의하고 있었다.
       · 산정 SP  : EVAL_TYPE = '2' 만
       · 보기 그리드: EVAL_TYPE = '2'  OR  (EVAL_TYPE='3' + 개시일 1일 + 작성일 7~10 + 전월 동일 작성일 없음)

   previousmonth(전월 MAX(ADMIT_DT))·조인 조건(patId + admitDt)·고위험군 조건(dangerYn='Y')·
   발생 판정(전월 2~4단계 합 = 0 AND 당월 2~4단계 합 > 0)·COUNT(DISTINCT patId) 는 양쪽이 완전히 동일하다.

   따라서 '월초 개시 + 7~10일 작성'인 초기평가(EVAL_TYPE='3') 환자가
   보기 그리드에는 대상(및 발생)으로 잡히지만 산정에서는 빠진다.
   실측 예) 그리드 총 129건 / SP 분모 128,  그리드 발생 2건 / SP 분자 1  → 정확히 1명 차이.

   ---------------------------------------------------------------------------
   바꾼 것 (딱 1군데)
   ---------------------------------------------------------------------------
   current_month 의 WHERE 절
       AND IFNULL(a.EVAL_TYPE,'') = '2'
   →  보기 그리드(select_CategoryList10)와 100% 동일한 EVAL_TYPE 분기로 교체
       AND ( a.EVAL_TYPE = '2'
             OR ( a.EVAL_TYPE = '3'
                  AND DAY(STR_TO_DATE(a.MED_START,'%Y%m%d')) = 1
                  AND DAY(STR_TO_DATE(a.DOC_DT,'%Y%m%d')) BETWEEN 7 AND 10
                  AND NOT EXISTS ( ... 전월 동일 PAT_ID·동일 DOC_DT 없음 ... ) ) )
   ※ current_month SELECT 에 DOC_DT 를 추가로 뽑지 않아도 된다(WHERE 에서 a.DOC_DT 직접 참조 가능).

   ---------------------------------------------------------------------------
   그대로 둔 것
   ---------------------------------------------------------------------------
   - previousmonth (전월 MAX(ADMIT_DT) 레코드)
   - 조인 조건 : cm.patId = pm.patId AND cm.admitDt = pm.admitDt
   - 대상 조건 : pm.dangerYn = 'Y' AND cm.dangerYn = 'Y' (전월·당월 모두 고위험군)
   - 발생 판정 : 전월(2+3+4)=0 AND 당월(2+3+4)>0
   - 분모 = COUNT(DISTINCT cm.patId), 분자 = COUNT(DISTINCT CASE WHEN 발생 THEN cm.patId END)
   - FORCE INDEX (INDEX01)

   ---------------------------------------------------------------------------
   ⚠ 주의
   ---------------------------------------------------------------------------
   1) 공식 지표값이 바뀐다(분모·분자 증가 → 발생률 상승).
      "이 지표가 초일입원 초기평가(EVAL_TYPE='3')를 대상에 포함하는가"라는
      평가 정의(심평원 기준)에 부합하는지 확인한 뒤 반영할 것.
      - 포함이 맞으면: 아래 교체본 적용(그리드와 일치)
      - '2'만이 맞으면: 반대로 보기 그리드에서 '3' 행을 제외해야 한다.
   2) 동일 원인이 11.욕창개선환자분율에도 있다 → docs/sql/SP_EVAL_CATE11_block.sql
      다른 지표(12.ADL 등)도 매퍼가 같은 '3' 분기를 쓰는지 함께 점검 권장.
   ============================================================================ */

		WITH current_month AS (
			SELECT a.PAT_ID                      AS patId
			     , a.ADMIT_DT                    AS admitDt
			     , CAST(a.PR_ULCER1 AS UNSIGNED) AS curtStep1
		         , CAST(a.PR_ULCER2 AS UNSIGNED) AS curtStep2
		         , CAST(a.PR_ULCER3 AS UNSIGNED) AS curtStep3
		         , CAST(a.PR_ULCER4 AS UNSIGNED) AS curtStep4
			     , CASE WHEN a.MOVE_POS >= '3' OR a.SIT_UP >= '3' OR a.TRANSFER >= '3' OR a.EXIT_ROOM >= '3'
			              OR a.MOVE_POS  = '8' OR a.SIT_UP  = '8' OR a.TRANSFER  = '8' OR a.EXIT_ROOM  = '8'
			            THEN 'Y' ELSE 'N' END    AS dangerYn
			  FROM TBL_PATVAL_MST a
			  FORCE INDEX (INDEX01) /* 20260303 */
			 WHERE a.HOSP_CD = hosp_cd
			   AND a.MED_START LIKE CONCAT(job_month,'%')
			   /* ★ 변경: 보기 그리드(select_CategoryList10)와 동일 — 정기평가('2') + 월초 초기평가('3') */
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
			     , b.ADMIT_DT                    AS admitDt
			     , CAST(b.PR_ULCER1 AS UNSIGNED) AS prevStep1
		         , CAST(b.PR_ULCER2 AS UNSIGNED) AS prevStep2
		         , CAST(b.PR_ULCER3 AS UNSIGNED) AS prevStep3
		         , CAST(b.PR_ULCER4 AS UNSIGNED) AS prevStep4
			     , CASE WHEN b.MOVE_POS >= '3' OR b.SIT_UP >= '3' OR b.TRANSFER >= '3' OR b.EXIT_ROOM >= '3'
			              OR b.MOVE_POS  = '8' OR b.SIT_UP  = '8' OR b.TRANSFER  = '8' OR b.EXIT_ROOM  = '8'
			            THEN 'Y' ELSE 'N' END    AS dangerYn
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
		)
		SELECT COUNT(DISTINCT cm.patId)
			 , COUNT(DISTINCT CASE WHEN COALESCE(pm.prevStep2, 0) + COALESCE(pm.prevStep3, 0) + COALESCE(pm.prevStep4, 0) = 0
			                        AND COALESCE(cm.curtStep2, 0) + COALESCE(cm.curtStep3, 0) + COALESCE(cm.curtStep4, 0) > 0 THEN cm.patId END)
		  INTO dtorvalue, ntorvalue
		  FROM current_month cm
		  JOIN previousmonth pm ON cm.patId = pm.patId AND cm.admitDt = pm.admitDt
		 WHERE pm.dangerYn = 'Y'
		   AND cm.dangerYn = 'Y' ;

		SET cate_gory = '10';
		SET cate_flag = '22';
		CALL SP_EVALUATION_INDICATORS_REGISTER(hosp_cd, str_month, str_month, job_month, cate_gory, cate_flag, dtorvalue, ntorvalue, user_id);
