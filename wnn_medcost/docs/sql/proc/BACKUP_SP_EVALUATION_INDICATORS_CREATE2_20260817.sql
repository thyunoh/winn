/* ======================================================================
   SP_EVALUATION_INDICATORS_CREATE2 — 변경 전 원본 백업 (2026-08-17)
   되돌릴 때 : 이 파일을 그대로 실행하면 원상복구된다.
   ====================================================================== */
DROP PROCEDURE IF EXISTS SP_EVALUATION_INDICATORS_CREATE2;
DELIMITER $$
CREATE PROCEDURE SP_EVALUATION_INDICATORS_CREATE2(
    IN  hosp_cd VARCHAR(10),
    IN  jobyymm VARCHAR(6),
    IN  user_id VARCHAR(50),
    OUT errcode VARCHAR(5),
    OUT errmess VARCHAR(1000)
)
BEGIN
    DECLARE while_cnt  INT DEFAULT 0;
    DECLARE dtorvalue  DECIMAL(10,2) DEFAULT 0;
    DECLARE ntorvalue  DECIMAL(10,2) DEFAULT 0;

    DECLARE dtorvalue1 DECIMAL(10,2) DEFAULT 0;
    DECLARE ntorvalue1 DECIMAL(10,2) DEFAULT 0;
    DECLARE dtorvalue2 DECIMAL(10,2) DEFAULT 0;
    DECLARE ntorvalue2 DECIMAL(10,2) DEFAULT 0;

    DECLARE pat_count  DECIMAL(10,2) DEFAULT 0;
    DECLARE doc_count  DECIMAL(10,2) DEFAULT 0;
    DECLARE nur_count  DECIMAL(10,2) DEFAULT 0;
    DECLARE nurscount  DECIMAL(10,2) DEFAULT 0;
    DECLARE pham_days  DECIMAL(10,2) DEFAULT 0;
    DECLARE total_day  DECIMAL(10,2) DEFAULT 0;

    DECLARE job_month  VARCHAR(6) DEFAULT '202401';
    DECLARE pre_month  VARCHAR(6) DEFAULT '202401';
    DECLARE str_month  VARCHAR(6) DEFAULT '202401';
    DECLARE end_month  VARCHAR(6) DEFAULT '202401';
    DECLARE cate_gory  VARCHAR(2) DEFAULT '01';
    DECLARE cate_flag  VARCHAR(2) DEFAULT '10';

    DECLARE error_message TEXT;
    DECLARE error_state VARCHAR(10);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET errcode = '90000';
		GET DIAGNOSTICS CONDITION 1 error_message = MESSAGE_TEXT, error_state = RETURNED_SQLSTATE;
		SET errmess = CONCAT('SQLSTATE=', error_state, ', MESSAGE=', error_message);

        ROLLBACK;

    END;

    START TRANSACTION;

	SET str_month = jobyymm; -- DATE_FORMAT(DATE_SUB(CONCAT(jobyymm,'01'), INTERVAL 5 MONTH), '%Y%m');
	SET end_month = jobyymm;
    SET job_month = jobyymm;

    WHILE while_cnt <= (CAST(end_month AS UNSIGNED) - CAST(str_month AS UNSIGNED)) DO


        SET while_cnt = while_cnt + 1;
        SET pre_month = DATE_FORMAT(DATE_SUB(CONCAT(job_month,'01'), INTERVAL 1 MONTH), '%Y%m');

IF  hosp_cd = '34280588' THEN
    INSERT INTO data_log (log_message) VALUES (CONCAT('시작 0',' 작업일시 - ',job_month));
END IF;


	    DELETE FROM TBL_PAT_INDI a
	     WHERE a.HOSP_CD = hosp_cd
	       AND a.JOBYYMM = job_month;
	       
IF  hosp_cd = '34280588' THEN
    INSERT INTO data_log (log_message) VALUES (CONCAT('시작 1',' 작업일시 - ',job_month));
END IF;

		UPDATE TBL_PATVAL_MST a
		FORCE INDEX (INDEX01) /*20260303 */
		   SET PAT_CLASS  = PATIENT_CLASSIFICATION(a.HOSP_CD, a.PAT_ID, a.CHUNGSEQ, a.CLFORM_VER, a.ADMIT_DT, a.MED_START)
		 WHERE a.HOSP_CD  = hosp_cd
           AND a.MED_START LIKE CONCAT(job_month,'%');



IF  hosp_cd = '34280588' THEN
    INSERT INTO data_log (log_message) VALUES (CONCAT('시작 2',' 작업일시 - ',job_month));
END IF;


		SET ntorvalue = 0;


		SELECT COALESCE(gm.PAT_COUNT,0)
		     , COALESCE(gm.DOC_COUNT,0)
		     , COALESCE(gm.NUR_COUNT,0)
		     , COALESCE(gm.NUR_S_CNT,0)
		     , COALESCE(gm.PHAM_DAYS,0)
		     , COALESCE(gm.TOTAL_DAY,0)
		  INTO pat_count
		     , doc_count
		     , nur_count
		     , nurscount
		     , pham_days
		     , total_day
	  	  FROM TBL_GRADE_MST gm
	     WHERE gm.HOSP_CD  = hosp_cd
	       AND gm.START_YY = LEFT(job_month,4)
	       AND (
	       		  (RIGHT(job_month, 2) IN ('01','02','03') AND gm.QTER_FLAG = '1')
	           OR (RIGHT(job_month, 2) IN ('04','05','06') AND gm.QTER_FLAG = '2')
		       OR (RIGHT(job_month, 2) IN ('07','08','09') AND gm.QTER_FLAG = '3')
		       OR (RIGHT(job_month, 2) IN ('10','11','12') AND gm.QTER_FLAG = '4')
		       )
	       AND gm.ACTION_YN = 'Y';

		-- IF  COALESCE(ntorvalue,0) = 0 THEN
		    SET ntorvalue = pat_count;
		-- END IF;

		SET dtorvalue = doc_count;
		SET cate_gory = '01';
		SET cate_flag = '10';

        CALL SP_EVALUATION_INDICATORS_REGISTER(hosp_cd, str_month, str_month, job_month, cate_gory, cate_flag, dtorvalue, ntorvalue, user_id);

        SET dtorvalue = nur_count;
		SET cate_gory = '02';
		SET cate_flag = '10';
        CALL SP_EVALUATION_INDICATORS_REGISTER(hosp_cd, str_month, str_month, job_month, cate_gory, cate_flag, dtorvalue, ntorvalue, user_id);

        SET dtorvalue = nurscount;
		SET cate_gory = '03';
		SET cate_flag = '10';
        CALL SP_EVALUATION_INDICATORS_REGISTER(hosp_cd, str_month, str_month, job_month, cate_gory, cate_flag, dtorvalue, ntorvalue, user_id);

		SET ntorvalue = pham_days;
		-- SET dtorvalue = total_day; -- DAY(LAST_DAY(CONCAT(job_month, '01')));

		SET dtorvalue = CASE WHEN RIGHT(job_month , 2) IN ('01','02','03') THEN DATEDIFF(STR_TO_DATE(CONCAT(LEFT(job_month, 4)-1, '1214'), '%Y%m%d'),
				                                                                         STR_TO_DATE(CONCAT(LEFT(job_month, 4)-1, '0915'), '%Y%m%d')) + 1
				             WHEN RIGHT(job_month , 2) IN ('04','05','06') THEN DATEDIFF(STR_TO_DATE(CONCAT(LEFT(job_month, 4),   '0314'), '%Y%m%d'),
				                                                                         STR_TO_DATE(CONCAT(LEFT(job_month, 4)-1, '1215'), '%Y%m%d')) + 1
				             WHEN RIGHT(job_month , 2) IN ('07','08','09') THEN DATEDIFF(STR_TO_DATE(CONCAT(LEFT(job_month, 4),   '0614'), '%Y%m%d'),
				                                                                         STR_TO_DATE(CONCAT(LEFT(job_month, 4),   '0315'), '%Y%m%d')) + 1
							 WHEN RIGHT(job_month , 2) IN ('10','11','12') THEN DATEDIFF(STR_TO_DATE(CONCAT(LEFT(job_month, 4),   '0914'), '%Y%m%d'),
				                                                                         STR_TO_DATE(CONCAT(LEFT(job_month, 4),   '0615'), '%Y%m%d')) + 1 END;
		IF ntorvalue > dtorvalue THEN
	    	SET ntorvalue = dtorvalue;
	    END IF;

		SET cate_gory = '04';
		SET cate_flag = '10';
        CALL SP_EVALUATION_INDICATORS_REGISTER(hosp_cd, str_month, str_month, job_month, cate_gory, cate_flag, dtorvalue, ntorvalue, user_id);

   /* 05. 유치도뇨관이 있는 환자분율 start */   
		SELECT COUNT(DISTINCT sub.patId)
          , SUM(CASE WHEN  sub.yesFg = 'Y' THEN 1 ELSE 0 END)
       INTO dtorvalue, ntorvalue
       FROM (SELECT DISTINCT a.PAT_ID                                                             AS patId
                 , PATIENT_CATHETER_CHECK(a.HOSP_CD,   a.CLFORM_VER, a.PAT_ID,       a.ADMIT_DT,
                                          a.MED_START, a.EVAL_TYPE,  a.INDWELL_CATH, a.PAT_CLASS) AS yesFg
	          FROM TBL_PATVAL_MST a
	          FORCE INDEX (INDEX01) 
	         WHERE a.HOSP_CD = hosp_cd
                AND a.MED_START LIKE CONCAT(job_month,'%')
	           AND IFNULL(a.PAT_CLASS,'') NOT LIKE 'A%'
	           AND IFNULL(a.EVAL_TYPE,'') = '2'  
              AND  NOT (a.COMA = 1       AND  a.DRESSING  >= 4 AND a.WASHING    >= 4  AND a.BRUSHING  >= 4 AND  
	                     a.BATHING  >= 4  AND  a.EATING    >= 4 AND a.MOVE_POS   >= 4  AND a.SIT_UP    >= 4 AND 
	                     a.TRANSFER >= 4  AND  a.EXIT_ROOM >= 4 AND a.TOILET_USE >= 4  AND a.BEDRIDDEN >= 4 
	                 AND a.MED_START >= '20260101'   -- 2026년 이후 개시 환자만 제외기준 적용 고위험군 대상자
	                ) 
           ) sub ;


		SET cate_gory = '05';
		SET cate_flag = '21';
      CALL SP_EVALUATION_INDICATORS_REGISTER(hosp_cd, str_month, str_month, job_month, cate_gory, cate_flag, dtorvalue, ntorvalue, user_id);

 /* 05. 유치도뇨관이 있는 환자분율 end */   
 
		  

		/* 06.배뇨관리 실시 환자분율 start */
		IF EXISTS (
		    SELECT 1
		      FROM TBL_WEVALUE_MST
		     WHERE CATE_CODE = '06'
		       AND CONCAT(str_month, '01') BETWEEN START_DT AND END_DT
		) THEN
			  SELECT COUNT(DISTINCT pm.PAT_ID)
			       , COUNT(DISTINCT CASE WHEN sb.PAT_ID IS NOT NULL THEN pm.PAT_ID END)
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
			         AND NOT (
			              LEFT(COALESCE(pat.PAT_CLASS, 'E'), 1) IN ('B', 'C')    -- 'B' 의료고도 ,'C' 의료중도 , 'D' 의료경도
			              AND pat.DEMENTIA = '1'                          -- 치매
			              AND ( pat.DELUSION    IN ('2','3')   -- 망상 2.자주 3.매우자주
			                 OR pat.HALLUCIN    IN ('2','3')   -- 환각
			                 OR pat.AGITATION   IN ('2','3')   -- 초조·공격성
			                 OR pat.DISINHIB    IN ('2','3')   -- 탈억제
			                 OR pat.CARE_RESIST IN ('2','3')   -- 케어저항
			                 OR pat.WANDER      IN ('2','3') ) -- 배회
			              AND pat.PSYCH_DRUG = '1'                             -- 약물치료
			             )
			         AND pat.URINE_MGMT NOT IN ('1')                                  -- 배뇨관련 루 관리 제외 
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
	         AND pm.URINE_MGMT NOT IN ('1')                                  -- 배뇨관련 루 관리 제외 
			   AND NOT (                                                  -- ★추가: 치매+BPSD+향정신약 분모 제외
			        LEFT(COALESCE(pm.PAT_CLASS, 'E'), 1) IN ('B', 'C')    -- 의료고도/중도
			        AND pm.DEMENTIA = '1'                                 -- 치매
			        AND ( pm.DELUSION    IN ('2','3')   -- 망상
			           OR pm.HALLUCIN    IN ('2','3')   -- 환각
			           OR pm.AGITATION   IN ('2','3')   -- 초조·공격성
			           OR pm.DISINHIB    IN ('2','3')   -- 탈억제
			           OR pm.CARE_RESIST IN ('2','3')   -- 케어저항
			           OR pm.WANDER      IN ('2','3') ) -- 배회
			        AND pm.PSYCH_DRUG = '1'                               -- 향정신약 치료
			      );
			SET cate_gory = '06';
			SET cate_flag = '21';
			CALL SP_EVALUATION_INDICATORS_REGISTER(
			            hosp_cd, str_month, str_month, job_month,
			            cate_gory, cate_flag, dtorvalue, ntorvalue, user_id);

		END IF;
		/* 06.배뇨관리 실시 환자분율  end  */
				
		/*향정신성 start  */
		SELECT COUNT(DISTINCT pm.PAT_ID)
		     , COUNT(DISTINCT CASE WHEN sb.EDI_CODE IS NOT NULL THEN pm.PAT_ID END)
		  INTO dtorvalue, ntorvalue
		  FROM TBL_PATVAL_MST pm FORCE INDEX (INDEX01)
		  LEFT JOIN (SELECT STRAIGHT_JOIN DISTINCT
		                    mm.HOSP_CD
		                  , mm.PAT_ID
		                  , jm.EDI_CODE
		               FROM TBL_PATVAL_MST  pat FORCE INDEX (INDEX01)
		               JOIN TBL_MYOUNG_MST  mm  FORCE INDEX (INDEX01)
		                                     ON mm.HOSP_CD = pat.HOSP_CD
		                                    AND mm.PAT_ID  = pat.PAT_ID
		               JOIN TBL_CHUNG_MST   cm  ON cm.HOSP_CD  = mm.HOSP_CD
		                                       AND cm.CLAIM_NO = mm.CLAIM_NO

--                      JOIN TBL_JINORD_MST  jm  ON jm.HOSP_CD  = mm.HOSP_CD
-- 		                                       AND jm.CLAIM_NO = mm.CLAIM_NO
-- 		                                       AND jm.BILL_SEQ = mm.BILL_SEQ
-- 		               JOIN TBL_DRUG_MST    td  ON td.EDI_CODE = jm.EDI_CODE
-- 		                                       AND td.CODEFLAG = 'A'
		                                       
		               JOIN TBL_DRUG_MST    tm  ON tm.CODEFLAG = 'A'
		               JOIN TBL_JINORD_MST  jm  ON jm.EDI_CODE = tm.EDI_CODE
							                        AND jm.HOSP_CD  = mm.HOSP_CD
		                                       AND jm.CLAIM_NO = mm.CLAIM_NO
		                                       AND jm.BILL_SEQ = mm.BILL_SEQ
		              WHERE pat.HOSP_CD = hosp_cd
		                AND pat.MED_START LIKE CONCAT(job_month,'%')
		/*                AND IFNULL(pat.EVAL_TYPE,'') IN ('1','2')    */
		                AND cm.DATE_YM = job_month
		                AND COALESCE(mm.DELYN,'') = ''
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
		                               AND jsm.ITEM_NO <> 'L')
		            ) sb ON sb.HOSP_CD = pm.HOSP_CD
		                AND sb.PAT_ID  = pm.PAT_ID
		 WHERE pm.HOSP_CD = hosp_cd
		   AND pm.MED_START LIKE CONCAT(job_month,'%') ;
	 /*    AND IFNULL(pm.EVAL_TYPE,'') IN ('1','2');    */          

		SET cate_gory = '07';
		SET cate_flag = '21';
		CALL SP_EVALUATION_INDICATORS_REGISTER(hosp_cd, str_month, str_month, job_month, cate_gory, cate_flag, dtorvalue, ntorvalue, user_id);
	/*향정신성 end  */

		SET cate_gory = '08';
		SET cate_flag = '21';
		SET dtorvalue = 0;
		SET ntorvalue = 0;
        CALL SP_EVALUATION_INDICATORS_REGISTER(hosp_cd, str_month, str_month, job_month, cate_gory, cate_flag, dtorvalue, ntorvalue, user_id);
   /* 욕창실시 환자율 분자 start */
	 
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
		       AND IFNULL(a.EVAL_TYPE,'') = '2'
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
		           /* 기존 조건들 */
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
-- 		           /* 추가: hasPrev AND (allCurtZero OR curtStep1Is1) */
-- 		           (COALESCE(pm.prevStep1,0) + COALESCE(pm.prevStep2,0) +
-- 		            COALESCE(pm.prevStep3,0) + COALESCE(pm.prevStep4,0) > 0
-- 		            AND (
-- 		                  CONCAT(cm.curtStep1, cm.curtStep2, cm.curtStep3, cm.curtStep4) = '0000'
-- 		                  OR
-- 		                  CONCAT(cm.curtStep1, cm.curtStep2, cm.curtStep3, cm.curtStep4) = '1000'
-- 		            ))
-- 		       THEN cm.patId END)

             /* 추가: hasPrev AND (allCurtZero OR 1단계) — 단, 처치 a+b+c(압력·체위·영양) 실시한 경우만 (드레싱 d 제외) */
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
 /* 욕창실시 환자율 분자 end */

/*   */
		SET cate_gory = '09';
		SET cate_flag = '21';
        CALL SP_EVALUATION_INDICATORS_REGISTER(hosp_cd, str_month, str_month, job_month, cate_gory, cate_flag, dtorvalue, ntorvalue, user_id);


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



		WITH
		current_month AS (
		SELECT d.PAT_ID                      AS patId
		     , ADL_SCORE_CHECK(d.DRESSING,d.WASHING,d.BRUSHING,d.BATHING,d.EATING,d.MOVE_POS,d.SIT_UP,d.TRANSFER,d.EXIT_ROOM,d.TOILET_USE, '1') AS cAdlScore
		  	 , CASE WHEN IFNULL(d.PAT_CLASS,'') = '' THEN LEFT(PATIENT_CLASSIFICATION(d.HOSP_CD, d.PAT_ID, d.CHUNGSEQ, d.CLFORM_VER, d.ADMIT_DT, d.MED_START),1)
		  	 		ELSE LEFT(d.PAT_CLASS,1) END AS cPatClass
		  FROM TBL_PATVAL_MST d
		 FORCE INDEX (INDEX01)
		 WHERE d.HOSP_CD = hosp_cd
		   AND d.MED_START LIKE CONCAT(job_month,'%')
		   AND IFNULL(d.EVAL_TYPE,'') = '2'
		),
		previous_month AS (
		SELECT d.PAT_ID AS patId
		     , d.PAT_NM
		  	 , ADL_SCORE_CHECK(d.DRESSING,d.WASHING,d.BRUSHING,d.BATHING,d.EATING,d.MOVE_POS,d.SIT_UP,d.TRANSFER,d.EXIT_ROOM,d.TOILET_USE, '1') AS pAdlScore
		  	 , ADL_SCORE_CHECK(d.DRESSING,d.WASHING,d.BRUSHING,d.BATHING,d.EATING,d.MOVE_POS,d.SIT_UP,d.TRANSFER,d.EXIT_ROOM,d.TOILET_USE, '2') AS pAdl10Val
		  	 , CASE WHEN IFNULL(d.PAT_CLASS,'') = '' THEN LEFT(PATIENT_CLASSIFICATION(d.HOSP_CD, d.PAT_ID, d.CHUNGSEQ, d.CLFORM_VER, d.ADMIT_DT, d.MED_START),1)
		  	 		ELSE LEFT(d.PAT_CLASS,1) END AS pPatClass
		  FROM TBL_PATVAL_MST d
		 FORCE INDEX (INDEX01)
		 WHERE d.HOSP_CD = hosp_cd
		   AND d.MED_START LIKE CONCAT(pre_month,'%')
		)
		SELECT COUNT(DISTINCT cm.patId)
			 , COUNT(DISTINCT CASE WHEN pm.pAdlScore > cm.cAdlScore + 1 THEN cm.patId END)
		  INTO dtorvalue, ntorvalue
		  FROM current_month cm
		  LEFT JOIN previous_month pm ON cm.patId = pm.patId
		 WHERE pm.pAdl10Val = 0
		  AND (cm.cPatClass IN ('B', 'C','D')
 		       OR
 		       pm.pPatClass IN ('B', 'C','D'));

		SET cate_gory = '12';
		SET cate_flag = '22';
        CALL SP_EVALUATION_INDICATORS_REGISTER(hosp_cd, str_month, str_month, job_month, cate_gory, cate_flag, dtorvalue, ntorvalue, user_id);


		WITH patient_data AS (
		  SELECT e.PAT_ID                            AS patId
		       , e.HBA1C_VALUE / 10                  AS eResult
		       , STR_TO_DATE(e.TEST_DATE,  '%Y%m%d') AS examiDt
		       , STR_TO_DATE(e.DOC_DT,     '%Y%m%d') AS docDt
		       , STR_TO_DATE(e.ADMIT_DT,   '%Y%m%d') AS admitDt
		    FROM TBL_PATVAL_MST e
		    FORCE INDEX (INDEX01) /* 20260303 */ 
		   WHERE e.HOSP_CD = hosp_cd
			 AND e.MED_START LIKE CONCAT(job_month, '%')
			 AND IFNULL(e.EVAL_TYPE,'') = '2'
			 AND IFNULL(e.DIABETES, '') = '1'
		     AND STR_TO_DATE(e.DOC_DT, '%Y%m%d') >= DATE_ADD(STR_TO_DATE(e.ADMIT_DT, '%Y%m%d'), INTERVAL 3 MONTH)
		)
		SELECT COUNT(DISTINCT pd.patId) AS 대상자수
		     , COUNT(DISTINCT CASE WHEN pd.examiDt IS NOT NULL AND pd.eResult >= 4 AND pd.eResult < 8.5 AND pd.examiDt <= pd.docDt
						            -- 제외 조건 (조건 1~7 충족 시 제외)
						            AND NOT (pd.docDt < DATE_ADD(pd.admitDt, INTERVAL 3 MONTH)   -- 조건1
							            OR   pd.examiDt > pd.docDt                               -- 조건2
							            OR   pd.docDt > DATE_ADD(pd.examiDt, INTERVAL 3 MONTH)   -- 조건3
							            OR   pd.docDt < pd.examiDt                               -- 조건4
							            OR   pd.eResult >= 8.5                                   -- 조건5
							            OR   pd.eResult < 4                                      -- 조건6
							            OR   pd.eResult = 0)                                     -- 조건7
						           THEN pd.patId END)
		  INTO dtorvalue, ntorvalue
		  FROM patient_data pd;

		SET cate_gory = '13';
		SET cate_flag = '22';
      CALL SP_EVALUATION_INDICATORS_REGISTER(hosp_cd, str_month, str_month, job_month, cate_gory, cate_flag, dtorvalue, ntorvalue, user_id);
     
	  /*장기입원환자 현화*/
			WITH filtered_pat AS (
			    SELECT pm1.PAT_ID
			      FROM TBL_PATVAL_MST pm1
			     WHERE pm1.HOSP_CD = hosp_cd
			       AND pm1.MED_START BETWEEN CONCAT(CASE WHEN CAST(SUBSTRING(job_month,5,2) AS UNSIGNED) <= 6
			                                             THEN job_month
			                                             ELSE CONCAT(SUBSTRING(job_month,1,4),'07')
			                                        END, '01')
			                             AND CONCAT(job_month, '31')
			     GROUP BY pm1.PAT_ID
			    HAVING SUM(CASE WHEN LEFT(IFNULL(pm1.PAT_CLASS,
			                                     PATIENT_CLASSIFICATION(pm1.HOSP_CD,
			                                                            pm1.PAT_ID,
			                                                            pm1.CHUNGSEQ,
			                                                            pm1.CLFORM_VER,
			                                                            pm1.ADMIT_DT,
			                                                            pm1.MED_START)),1)
			                              NOT IN ('D','E')
			                    THEN 1
			                    ELSE 0
			               END) = 0
			       /* A31(중도입원) 이력 있는 환자 전체 제외 */
			       AND SUM(CASE WHEN IFNULL(pm1.PAT_CLASS,
			                                PATIENT_CLASSIFICATION(pm1.HOSP_CD,
			                                                       pm1.PAT_ID,
			                                                       pm1.CHUNGSEQ,
			                                                       pm1.CLFORM_VER,
			                                                       pm1.ADMIT_DT,
			                                                       pm1.MED_START)) = 'A31'
			                    THEN 1
			                    ELSE 0
			               END) = 0
			),
			base AS (
			    SELECT DISTINCT
			           LEFT(pm2.PAT_ID,6) AS patId
			         , pm2.ADMIT_DT       AS admitDt
			         , CASE
			               WHEN LEFT(IFNULL(pm2.PAT_CLASS,
			                                PATIENT_CLASSIFICATION(pm2.HOSP_CD,
			                                                       pm2.PAT_ID,
			                                                       pm2.CHUNGSEQ,
			                                                       pm2.CLFORM_VER,
			                                                       pm2.ADMIT_DT,
			                                                       pm2.MED_START)),1) IN ('D','E')
			                AND (
			                    /* 현재 입원 기간 180일 이상 */
			                    DATEDIFF(COALESCE(ii.TEWONDT,
			                                     DATE_FORMAT(pm2.DOC_DT,'%Y%m%d')),
			                             DATE_FORMAT(pm2.ADMIT_DT,'%Y%m%d')) + 1 >= 181
			                    OR
			                    /* 이전 입원 내역 있을 때 년도 기준 누적 180일 이상 */
			                    EXISTS (
			                        SELECT 1
			                          FROM TBL_IPWON_INFO prev_ii
			                         WHERE prev_ii.HOSP_CD = pm2.HOSP_CD
			                           AND LEFT(prev_ii.JUMINNO,6) = LEFT(pm2.PAT_ID,6)
			                           AND prev_ii.PATNAME = REGEXP_REPLACE(pm2.PAT_NM,'[0-9]','')
			                           AND COALESCE(prev_ii.TEWONDT,'') != ''
			                           AND REPLACE(prev_ii.TEWONDT,'-','') < REPLACE(pm2.ADMIT_DT,'-','')
			                           AND DATEDIFF(
			                                   STR_TO_DATE(REPLACE(COALESCE(ii.TEWONDT,
			                                                                DATE_FORMAT(pm2.DOC_DT,'%Y%m%d')),'-',''),'%Y%m%d'),
			                                   CASE WHEN LEFT(REPLACE(prev_ii.IPWONDT,'-',''),4) < LEFT(pm2.ADMIT_DT,4)
			                                        THEN STR_TO_DATE(CONCAT(LEFT(pm2.ADMIT_DT,4),'0101'),'%Y%m%d')
			                                        ELSE STR_TO_DATE(REPLACE(prev_ii.IPWONDT,'-',''),'%Y%m%d')
			                                   END
			                               ) + 1 >= 181
			                    )
			                    OR 
                             /* (추가) 장기입원 입원료: TBL_JINORD_MST ITEM_NO=02, EDI_CODE 6~8자리 IN(300,400,500) — 해당월 청구 */
			                    EXISTS (
			                        SELECT 1
			                          FROM TBL_MYOUNG_MST  mm
			                          JOIN TBL_CHUNG_MST   cm ON cm.HOSP_CD = mm.HOSP_CD AND cm.CLAIM_NO = mm.CLAIM_NO
			                          JOIN TBL_JINORD_MST  jm ON jm.HOSP_CD = mm.HOSP_CD AND jm.CLAIM_NO = mm.CLAIM_NO AND jm.BILL_SEQ = mm.BILL_SEQ
			                         WHERE mm.HOSP_CD = pm2.HOSP_CD
			                           AND mm.PAT_ID  = pm2.PAT_ID
			                           AND COALESCE(mm.DELYN,'') = ''
			                           AND cm.DATE_YM = job_month
			                           AND jm.ITEM_NO = '02'
			                           AND SUBSTRING(jm.EDI_CODE,6,3) IN ('300','400','500')
			                    )
			                )
			               THEN 'Y'
			               ELSE ''
			           END AS longAdm
			      FROM TBL_PATVAL_MST pm2
			      LEFT JOIN TBL_IPWON_INFO ii
			             ON ii.HOSP_CD = pm2.HOSP_CD
			            AND ii.JOBYYMM BETWEEN CASE WHEN CAST(SUBSTRING(job_month,5,2) AS UNSIGNED) <= 6
			                                        THEN job_month
			                                        ELSE CONCAT(SUBSTRING(job_month,1,4), '07')
			                                   END
			                               AND job_month
			            AND LEFT(ii.JUMINNO,6) = LEFT(pm2.PAT_ID,6)
			            AND REPLACE(ii.IPWONDT,'-','') = pm2.ADMIT_DT
			            AND COALESCE(ii.TEWONDT,'') != ''
			            AND job_month >= LEFT(REPLACE(ii.TEWONDT,'-',''),6)
			            AND pm2.PAT_NM = REGEXP_REPLACE(ii.PATNAME, '[0-9]', '')
			     WHERE pm2.HOSP_CD = hosp_cd
			       AND pm2.PAT_ID IN (SELECT fp.PAT_ID FROM filtered_pat fp)
			       /* A31 입원건 자체도 명단에서 제외 */
			       AND IFNULL(pm2.PAT_CLASS,
			                  PATIENT_CLASSIFICATION(pm2.HOSP_CD,
			                                         pm2.PAT_ID,
			                                         pm2.CHUNGSEQ,
			                                         pm2.CLFORM_VER,
			                                         pm2.ADMIT_DT,
			                                         pm2.MED_START)) != 'A31'
			       AND pm2.MED_START BETWEEN CONCAT(CASE WHEN CAST(SUBSTRING(job_month,5,2) AS UNSIGNED) <= 6
			                                             THEN job_month
			                                             ELSE CONCAT(SUBSTRING(job_month,1,4), '07')
			                                        END, '01')
			                             AND CONCAT(job_month, '31')
			),
			dedup AS (
			    SELECT patId
			         , admitDt
			         , MAX(longAdm) AS longAdm
			      FROM base
			     GROUP BY patId
			            , admitDt
			)
			SELECT COUNT(*)                                         AS tcnt
			     , SUM(CASE WHEN longAdm = 'Y' THEN 1 ELSE 0 END)  AS  lant
			    INTO dtorvalue, ntorvalue
			  FROM dedup;



	    SET cate_gory = '14';
	    SET cate_flag = '22';
	    CALL SP_EVALUATION_INDICATORS_REGISTER(hosp_cd, str_month, str_month, job_month, cate_gory, cate_flag, dtorvalue, ntorvalue, user_id);

	  /*장기입원환자 현화*/

		SET dtorvalue = 0;
		SET ntorvalue = 0;


		SET cate_gory = '15';
		SET cate_flag = '22';
      CALL SP_EVALUATION_INDICATORS_REGISTER(hosp_cd, str_month, str_month, job_month, cate_gory, cate_flag, dtorvalue, ntorvalue, user_id);

		WITH
		current_patient AS (
		  SELECT DISTINCT pm.PAT_ID
		    FROM TBL_PATVAL_MST pm FORCE INDEX (INDEX01)
		   WHERE pm.HOSP_CD = hosp_cd
		     AND pm.MED_START LIKE CONCAT(job_month,'%')
		),
		psyorderpatient AS (
		  SELECT STRAIGHT_JOIN DISTINCT mm.PAT_ID
		    FROM TBL_PATVAL_MST  pat FORCE INDEX (INDEX01)
		    JOIN TBL_MYOUNG_MST  mm  FORCE INDEX (INDEX01)
		                          ON mm.HOSP_CD = pat.HOSP_CD
		                         AND mm.PAT_ID  = pat.PAT_ID
		    JOIN TBL_CHUNG_MST   cm  ON cm.HOSP_CD  = mm.HOSP_CD
		                            AND cm.CLAIM_NO = mm.CLAIM_NO
-- 		    JOIN TBL_DRUG_MST    tm  ON tm.EDI_CODE = jm.EDI_CODE
-- 		                            AND tm.CODEFLAG = 'B'
-- 		    JOIN TBL_JINORD_MST  jm  ON jm.HOSP_CD  = mm.HOSP_CD
-- 		                            AND jm.CLAIM_NO = mm.CLAIM_NO
-- 		                            AND jm.BILL_SEQ = mm.BILL_SEQ

		    JOIN TBL_DRUG_MST    tm  ON tm.CODEFLAG = 'B'
		    JOIN TBL_JINORD_MST  jm  ON jm.EDI_CODE = tm.EDI_CODE
			                         AND jm.HOSP_CD  = mm.HOSP_CD
		                            AND jm.CLAIM_NO = mm.CLAIM_NO
		                            AND jm.BILL_SEQ = mm.BILL_SEQ
		                            
		   WHERE pat.HOSP_CD = hosp_cd
		     AND pat.MED_START LIKE CONCAT(job_month,'%')
		     AND cm.DATE_YM = job_month
		     AND COALESCE(mm.DELYN,'') = ''
		     AND NOT EXISTS (SELECT 1
		                       FROM TBL_SPECODE_MST tsm1
		                      WHERE tsm1.HOSP_CD   = mm.HOSP_CD
		                        AND tsm1.CLAIM_NO  = mm.CLAIM_NO
		                        AND tsm1.BILL_SEQ  = mm.BILL_SEQ
		                        AND tsm1.SPEC_TYPE = 'JS008')
		     AND EXISTS (SELECT 1
		                   FROM TBL_JINORD_MST jsm
		                  WHERE jsm.HOSP_CD  = mm.HOSP_CD
		                    AND jsm.CLAIM_NO = mm.CLAIM_NO
		                    AND jsm.BILL_SEQ = mm.BILL_SEQ
		                    AND jsm.ITEM_NO <> 'L')
		)
		SELECT COUNT(DISTINCT cp.PAT_ID)
		
		     , COUNT(DISTINCT pp.PAT_ID)
		  INTO dtorvalue, ntorvalue
		  FROM current_patient cp
		  LEFT JOIN psyorderpatient pp ON cp.PAT_ID = pp.PAT_ID;

		SET cate_gory = 'M1';
		SET cate_flag = '30';
        CALL SP_EVALUATION_INDICATORS_REGISTER(hosp_cd, str_month, str_month, job_month, cate_gory, cate_flag, dtorvalue, ntorvalue, user_id);

        SELECT COUNT(CASE WHEN f.UTI = '1' THEN 1 END)
             , COUNT(f.PAT_ID)
          INTO ntorvalue, dtorvalue
          FROM TBL_PATVAL_MST f
         FORCE INDEX (INDEX01)
         WHERE f.HOSP_CD = hosp_cd
           AND f.MED_START LIKE CONCAT(job_month,'%')
           AND IFNULL(f.INDWELL_CATH,'') = '1';

        SET cate_gory = 'M3';
        SET cate_flag = '30';
        CALL SP_EVALUATION_INDICATORS_REGISTER(hosp_cd, str_month, str_month, job_month, cate_gory, cate_flag, dtorvalue, ntorvalue, user_id);


		WITH
	    current_month AS (
	    SELECT g.PAT_ID                        AS patient_id
	         , MAX(IFNULL(g.PAIN_FREQ   ,'0')) AS PAIN_FREQ
	         , MAX(IFNULL(g.PAIN_VIS_SC ,'0')) AS PAIN_VIS_SC
	         , MAX(IFNULL(g.PAIN_NUM_SC ,'0')) AS PAIN_NUM_SC
	         , MAX(IFNULL(g.PAIN_FACE_SC,'0')) AS PAIN_FACE_SC
	      FROM TBL_PATVAL_MST g
	     FORCE INDEX (INDEX01)
	     WHERE g.HOSP_CD = hosp_cd
           AND g.MED_START LIKE CONCAT(job_month,'%')
		 GROUP BY g.PAT_ID
	    ),
	    previousmonth AS (
	    SELECT g.PAT_ID                        AS patient_id
	         , MAX(IFNULL(g.PAIN_FREQ   ,'0')) AS PAIN_FREQ
	         , MAX(IFNULL(g.PAIN_VIS_SC ,'0')) AS PAIN_VIS_SC
	         , MAX(IFNULL(g.PAIN_NUM_SC ,'0')) AS PAIN_NUM_SC
	         , MAX(IFNULL(g.PAIN_FACE_SC,'0')) AS PAIN_FACE_SC
	      FROM TBL_PATVAL_MST g
	     FORCE INDEX (INDEX01)
	     WHERE g.HOSP_CD = hosp_cd
           AND g.MED_START LIKE CONCAT(pre_month,'%')
		 GROUP BY g.PAT_ID
	    )

		SELECT COUNT(CASE WHEN cm.PAIN_FREQ = '2' AND (cm.PAIN_VIS_SC >= 4 OR cm.PAIN_NUM_SC >= 4 OR cm.PAIN_FACE_SC >= 3)
		                  THEN 1 END)
    		 , COUNT(CASE WHEN cm.PAIN_FREQ = '2' AND (cm.PAIN_VIS_SC >= 4 OR cm.PAIN_NUM_SC >= 4 OR cm.PAIN_FACE_SC >= 3)
					       AND (
						           (cm.PAIN_VIS_SC  < pm.PAIN_VIS_SC)  OR
						           (cm.PAIN_NUM_SC  < pm.PAIN_NUM_SC)  OR
						           (cm.PAIN_FACE_SC < pm.PAIN_FACE_SC) OR
						           (cm.PAIN_FREQ    < pm.PAIN_FREQ))
					       AND
					       NOT (
						           (cm.PAIN_VIS_SC  > pm.PAIN_VIS_SC)  OR
						           (cm.PAIN_NUM_SC  > pm.PAIN_NUM_SC)  OR
						           (cm.PAIN_FACE_SC > pm.PAIN_FACE_SC) OR
						           (cm.PAIN_FREQ    > pm.PAIN_FREQ))
					      THEN 1 END)
		  INTO dtorvalue, ntorvalue
		  FROM current_month cm
          JOIN previousmonth pm ON cm.patient_id = pm.patient_id;

		SET cate_gory = 'M4';
		SET cate_flag = '30';
        CALL SP_EVALUATION_INDICATORS_REGISTER(hosp_cd, str_month, str_month, job_month, cate_gory, cate_flag, dtorvalue, ntorvalue, user_id);

        SET job_month = DATE_FORMAT(DATE_ADD(CONCAT(job_month, '01'), INTERVAL 1 MONTH), '%Y%m');

    END WHILE;


    SET errcode = '0';
    SET errmess = 'Success';
    COMMIT;

END$$
DELIMITER ;
