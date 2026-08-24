/* ============================================================================
   11.욕창개선환자분율 — 지표 생성 프로시저의 해당 블록 교체본

   프로시저 안의 11번(욕창개선환자분율) 산정 구간
       WITH current_month AS (...) previousmonth AS (...) SELECT ... INTO dtorvalue, ntorvalue ...
       SET cate_gory = '11'; SET cate_flag = '22'; CALL SP_EVALUATION_INDICATORS_REGISTER(...);
   을 아래 내용으로 통째로 교체한다.

   ---------------------------------------------------------------------------
   [변경이력]
   ---------------------------------------------------------------------------
   1) 2026-08-17 : current_month 를 보기 그리드(select_CategoryList11)와 동일하게
      EVAL_TYPE='2' + 월초 초기평가('3', 개시일 1일·작성일 7~10·전월 동일 작성일 없음)로 확장.
      (분자가 그리드보다 1 작게 나오던 문제 — 반영 완료, 이 파일에도 유지되어 있음)

   2) 2026-08-24 (이번 교체) : ★ '제외' 혼합 케이스를 분모에서 뺀다.
      - 증상 : 보기 그리드가 '제외'(improveYn='2')로 표시하는 환자가
               SP 분모에는 그대로 남아 미개선과 똑같이 분율을 깎았다.
               실측 예) 2026-08 강남수요양병원 — 전월 3단계 1부위 → 당월 2단계 2부위 환자:
               그리드 '제외' 표시인데 분모 6에 포함되어 5/6=83.33%.
               분모에서 빼면 5/5=100%.
      - '제외' 판정(그리드 improveYn='2'와 100% 동일 조건) :
            악화 조건(부위합 증가 OR 최고단계 상승) 과
            개선 조건(부위합 감소 OR 최고단계 하강) 이 동시에 참인 혼합 케이스.
            (예: 최고단계는 3→2로 낮아졌는데 부위 수는 1→2로 늘어난 경우)
      - 바꾼 곳 : 분모 COUNT(DISTINCT pm.patId)
                → COUNT(DISTINCT CASE WHEN NOT(혼합 케이스) THEN pm.patId END)
      - 분자는 무변경. 분자 조건(개선 AND NOT 악화 / 부위합 감소+전 단계 비증가)은
        혼합 케이스와 절대 겹치지 않으므로 분자 ⊆ 분모 가 항상 성립한다(분율 100% 초과 불가).

   ---------------------------------------------------------------------------
   그대로 둔 것
   ---------------------------------------------------------------------------
   - current_month 의 EVAL_TYPE 분기(2026-08-17 반영분)
   - previousmonth (전월 MAX(ADMIT_DT) + 전월 2단계 이상 욕창 보유)
   - 개선 판정 CASE (step2·3·4 합/최고단계 비교, 악화 아님) = 분자
   - current_month / previousmonth 의 FORCE INDEX (INDEX01)

   ---------------------------------------------------------------------------
   ⚠ 주의
   ---------------------------------------------------------------------------
   1) 이 교체는 '공식 지표값'을 바꾼다(혼합 케이스가 분모에서 빠짐 → 분모 감소, 결과 상승).
      "혼합 케이스는 산정에서 제외"가 심평원 기준에 부합한다는 사용자 확정(2026-08-24)에 따른 것.
   2) 보기 그리드(select_CategoryList11)는 손대지 않는다 — 그리드는 이미 '제외'로 표시만 하고
      분모/분자를 계산하지 않는다(좌측 지표 그리드의 분모/분자는 이 SP 결과).
      그리드 '제외' 표시 건수 = 이번에 분모에서 빠지는 건수 — 화면으로 그대로 검증 가능:
      분모 = 전월단계 값이 있는 행 수 − '제외' 행 수, 분자 = '개선' 행 수.
   3) 같은 혼합 케이스 개념이 없는 10번(신규발생)은 해당 없음.
      12.ADL 등 다른 지표는 '제외' 판정 자체가 없는지 별도 확인.
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
			   /* 보기 그리드(select_CategoryList11)와 동일 — 정기평가('2') + 월초 초기평가('3') */
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
		SELECT /* ★ 분모 : '제외' 혼합 케이스(악화·개선 동시 충족)를 뺀다
		         — 보기 그리드 select_CategoryList11 의 improveYn='2' 판정과 동일 조건 */
		       COUNT(DISTINCT CASE WHEN NOT (
					            /* 악화 조건 (부위합 증가 OR 최고단계 상승) */
					            ((pm.prevStep2 + pm.prevStep3 + pm.prevStep4) < (cm.curtStep2 + cm.curtStep3 + cm.curtStep4)
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
					            AND
					            /* 개선 조건 (부위합 감소 OR 최고단계 하강) */
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
					       ) THEN pm.patId END)
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
