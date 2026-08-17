/* ======================================================================
   SP_INDICATORS_STRUCTURE_ZONE — 변경 전 원본 백업 (2026-08-17)
   되돌릴 때 : 이 파일을 DELIMITER 로 감싸 그대로 실행하면 원상복구된다.
   ====================================================================== */
DROP PROCEDURE IF EXISTS SP_INDICATORS_STRUCTURE_ZONE;
DELIMITER $$
CREATE PROCEDURE SP_INDICATORS_STRUCTURE_ZONE(
    IN hosp_cd   VARCHAR(10),
    IN job_month VARCHAR(10),
    IN str_month VARCHAR(10),
    IN end_month VARCHAR(10),
    IN user_id   VARCHAR(50)
)
BEGIN

	DECLARE while_cnt  INT DEFAULT 0;
	
    DECLARE dtorvalue  DECIMAL(10,2) DEFAULT 0;
    DECLARE ntorvalue  DECIMAL(10,2) DEFAULT 0;

    DECLARE pat_count  DECIMAL(10,2) DEFAULT 0;
    DECLARE doc_count  DECIMAL(10,2) DEFAULT 0;
    DECLARE nur_count  DECIMAL(10,2) DEFAULT 0;
    DECLARE nurscount  DECIMAL(10,2) DEFAULT 0;
    DECLARE pham_days  DECIMAL(10,2) DEFAULT 0;
    DECLARE total_day  DECIMAL(10,2) DEFAULT 0;
    DECLARE cate_gory  VARCHAR(2)    DEFAULT '01';
    DECLARE cate_flag  VARCHAR(2)    DEFAULT '10';
    
    
    WHILE while_cnt <= (CAST(end_month AS UNSIGNED) - CAST(str_month AS UNSIGNED)) DO

        SET while_cnt = while_cnt + 1;
        

        SELECT COALESCE(gm.PAT_COUNT,0)
		     , COALESCE(gm.DOC_COUNT,0)
		     , COALESCE(gm.NUR_COUNT,0)
		     , COALESCE(gm.NUR_S_CNT,0)
		     , COALESCE(gm.PHAM_DAYS,0)
		  INTO pat_count
		     , doc_count
		     , nur_count
		     , nurscount
		     , pham_days
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
		
		SET ntorvalue = pat_count;
		
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

		SET job_month = DATE_FORMAT(DATE_ADD(CONCAT(job_month, '01'), INTERVAL 1 MONTH), '%Y%m');
		
	END WHILE;		


END$$
DELIMITER ;
