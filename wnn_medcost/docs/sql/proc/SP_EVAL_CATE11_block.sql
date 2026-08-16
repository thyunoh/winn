/* ============================================================================
   11.욕창개선환자분율 — 지표 생성 프로시저의 해당 블록 교체본

   프로시저 안의 11번(욕창개선환자분율) 산정 구간
       WITH current_month AS (...) previousmonth AS (...) SELECT ... INTO dtorvalue, ntorvalue ...
       SET cate_gory = '11'; SET cate_flag = '22'; CALL SP_EVALUATION_INDICATORS_REGISTER(...);
   을 아래 내용으로 통째로 교체한다.

   ---------------------------------------------------------------------------
   해결하는 문제 (분자가 보기 그리드보다 1 작게 나오는 원인)
   ---------------------------------------------------------------------------
   보기 그리드(MagamMapper.select_CategoryList11)와 이 산정 SP가 '당월 대상(current_month)'을
   서로 다르게 정의하고 있었다.
       · 산정 SP  : current_month = EVAL_TYPE = '2' 만
       · 보기 그리드: current_month = EVAL_TYPE = '2'  OR  (EVAL_TYPE='3' + 초일입원 + 작성일 7~10 + 전월 동일 작성일 없음)
   전월 대상(previousmonth)·개선 판정 로직·COUNT(DISTINCT patId) 는 양쪽이 완전히 동일하다.
   따라서 '월초 개시 + 7~10일 작성'인 초기평가(EVAL_TYPE='3') 개선 환자가
   보기 그리드에는 '개선'으로 잡히지만 산정 분자에서는 빠져,
   예) 개선 8명(그리드) vs 분자 7명(SP) 처럼 딱 1 차이가 났다.

   ---------------------------------------------------------------------------
   바꾼 것 (딱 1군데)
   ---------------------------------------------------------------------------
   current_month 의 WHERE 절
       AND IFNULL(a.EVAL_TYPE,'') = '2'
   →  보기 그리드(select_CategoryList11)와 100% 동일한 EVAL_TYPE 분기로 교체
       AND ( a.EVAL_TYPE = '2'
             OR ( a.EVAL_TYPE = '3'
                  AND DAY(STR_TO_DATE(a.MED_START,'%Y%m%d')) = 1
                  AND DAY(STR_TO_DATE(a.DOC_DT,'%Y%m%d')) BETWEEN 7 AND 10
                  AND NOT EXISTS ( ... 전월 동일 PAT_ID·동일 DOC_DT 없음 ... ) ) )
   ※ current_month SELECT 에 DOC_DT 를 추가로 뽑지 않아도 된다(WHERE 에서 a.DOC_DT 직접 참조 가능).

   ---------------------------------------------------------------------------
   그대로 둔 것
   ---------------------------------------------------------------------------
   - previousmonth (전월 MAX(ADMIT_DT) + 전월 2단계 이상 욕창 보유)
   - 개선 판정 CASE (step2·3·4 합/최고단계 비교, 악화 아님)
   - 분모 = COUNT(DISTINCT pm.patId), 분자 = COUNT(DISTINCT CASE WHEN 개선 THEN pm.patId END)
   - current_month / previousmonth 의 FORCE INDEX (INDEX01)

   ---------------------------------------------------------------------------
   ⚠ 주의
   ---------------------------------------------------------------------------
   1) 이 교체는 '공식 지표값'을 바꾼다(초기평가 개선 환자가 분자에 추가 → 분자 증가, 획득률·결과 상승).
      "욕창개선환자분율이 초일입원 초기평가(EVAL_TYPE='3')를 대상에 포함하는가"라는
      평가 정의(심평원 기준)에 부합하는지 확인한 뒤 반영할 것.
      - 포함이 맞으면: 아래 교체본 적용(그리드와 일치).
      - '2'만이 맞으면: 반대로 보기 그리드(select_CategoryList11)에서 '3' 개선을 집계·표시에서 빼야 한다.
   2) 같은 초기평가 분기를 쓰는 다른 지표(예: 12.ADL select_CategoryList12 등)도
      해당 산정 SP 가 EVAL_TYPE='2' 만 쓰는지 동일 점검 권장(같은 누락 가능성).
   ============================================================================ */

		WITH current_month AS (
		    SELECT a.PAT_ID AS patId
		         , CAST(a.PR_ULCER1 AS UNSIGNED) AS curtStep1
		         , CAST(a.PR_ULCER2 AS UNSIGNED) AS curtStep2
		         , CAST(a.PR_ULCER3 AS UNSIGNED) AS curtStep3
		         , CAST(a.PR_ULCER4 AS UNSIGNED) AS curtStep4
		      FROM TBL_PATVAL_MST a
		      FORCE INDEX (INDEX01) /* 20260303 */
		     WHERE a.HOSP_CD = hosp_cd
			   AND a.MED_START LIKE CONCAT(job_month,'%')
			   /* ★ 변경: 보기 그리드(select_CategoryList11)와 동일 — 정기평가('2') + 월초 초기평가('3') */
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
		    SELECT b.PAT_ID AS patId
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
			   AND CAST(b.PR_ULCER2 AS UNSIGNED) +
		           CAST(b.PR_ULCER3 AS UNSIGNED) +
		           CAST(b.PR_ULCER4 AS UNSIGNED) > 0
		)
		SELECT COUNT(DISTINCT pm.patId)
             , COUNT(DISTINCT CASE WHEN
					            ((pm.prevStep2 + pm.prevStep3 + pm.prevStep4) > (cm.curtStep2 + cm.curtStep3 + cm.curtStep4)
					             OR
					             CASE
					                 WHEN pm.prevStep4 > 0 THEN 4
					                 WHEN pm.prevStep3 > 0 THEN 3
					                 WHEN pm.prevStep2 > 0 THEN 2
					                 ELSE 0
					             END
					             >
					             CASE
					                 WHEN cm.curtStep4 > 0 THEN 4
					                 WHEN cm.curtStep3 > 0 THEN 3
					                 WHEN cm.curtStep2 > 0 THEN 2
					                 ELSE 0
					             END
					            )
					            AND NOT (
					                (pm.prevStep2 + pm.prevStep3 + pm.prevStep4) < (cm.curtStep2 + cm.curtStep3 + cm.curtStep4)
					                OR
					                CASE
					                    WHEN pm.prevStep4 > 0 THEN 4
					                    WHEN pm.prevStep3 > 0 THEN 3
					                    WHEN pm.prevStep2 > 0 THEN 2
					                    ELSE 0
					                END
					                <
					                CASE
					                    WHEN cm.curtStep4 > 0 THEN 4
					                    WHEN cm.curtStep3 > 0 THEN 3
					                    WHEN cm.curtStep2 > 0 THEN 2
					                    ELSE 0
					                END
					            )
						      OR
						      ((pm.prevStep2 + pm.prevStep3 + pm.prevStep4) > (cm.curtStep2 + cm.curtStep3 + cm.curtStep4)
				               AND
				              (pm.prevStep4 >= cm.curtStep4)
				               AND
				              (pm.prevStep3 >= cm.curtStep3)
				               AND
				              (pm.prevStep2 >= cm.curtStep2)
				              ) THEN pm.patId END)
		  INTO dtorvalue, ntorvalue
		  FROM current_month cm
		  JOIN previousmonth pm ON cm.patId = pm.patId;

        SET cate_gory = '11';
        SET cate_flag = '22';
        CALL SP_EVALUATION_INDICATORS_REGISTER(hosp_cd, str_month, str_month, job_month, cate_gory, cate_flag, dtorvalue, ntorvalue, user_id);
