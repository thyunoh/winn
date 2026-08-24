-- 원본 백업 (2026-08-24 수정 전). 그대로 실행하면 원복된다.
DROP FUNCTION IF EXISTS EVALUATION_INDICATORS_VALUE;

DELIMITER $$

CREATE DEFINER=`winner`@`%` FUNCTION `EVALUATION_INDICATORS_VALUE`(
    inreturnflag VARCHAR(1),
    in_cate_gory VARCHAR(10),
    in_job_month VARCHAR(8),
    in_dtorvalue DECIMAL(10,2),
    in_ntorvalue DECIMAL(10,2)
) RETURNS decimal(10,2)
    DETERMINISTIC
BEGIN

	DECLARE RETURNVALUE DECIMAL(10,2) DEFAULT 0.00;
	
	
    DECLARE l_calcvalue DECIMAL(10,2) DEFAULT 0.00;
    DECLARE l_max_score INT           DEFAULT 0;
    DECLARE l_weightval DECIMAL(10,2) DEFAULT 0.00;
    DECLARE l_std_score DECIMAL(10,2) DEFAULT 0.00;
    DECLARE l_stdweight DECIMAL(10,2) DEFAULT 0.00;
    DECLARE l_calc_flag VARCHAR(10)   DEFAULT '2';

	DECLARE l_samfileyn VARCHAR(1)    DEFAULT 'N';

    SET in_dtorvalue = IFNULL(in_dtorvalue,0);
    SET in_ntorvalue = IFNULL(in_ntorvalue,0);

/*
IF  in_cate_gory = '07' THEN
    INSERT INTO data_log (log_message) VALUES (CONCAT('등록 시작 1',' - ',in_cate_gory, ' - 분모 : ', in_dtorvalue, ' - 분자 : ', in_ntorvalue));
END IF;
*/
	IF  in_cate_gory IN ('01','02','03') THEN
		SET l_calc_flag = '1';
    END IF;

	IF in_dtorvalue = 0 THEN
	   SET l_calcvalue = 0.00;
	   SET l_stdweight = 0.00;


	   SELECT MAX(IFNULL(STD_SCORE,0))
	        , MAX(IFNULL(WE_VALUE, 0))
	     INTO l_max_score, l_stdweight
	     FROM TBL_WEVALUE_MST
	    WHERE CATE_CODE = in_cate_gory
	      AND CONCAT(in_job_month,'01') BETWEEN START_DT AND END_DT
	      AND ACTION_YN = 'Y'
	    LIMIT 1;


       IF  in_cate_gory IN ('07') AND in_ntorvalue = 0 THEN
		   SET l_calcvalue = 30.00;
		   SET l_std_score = 3.00;

		   SELECT TRUNCATE(((STD_SCORE / l_max_score) * WE_VALUE),2)
			 INTO l_weightval
			 FROM TBL_WEVALUE_MST
			WHERE CATE_CODE = in_cate_gory
			  AND CONCAT(in_job_month,'01') BETWEEN START_DT AND END_DT
			  AND STD_SCORE = l_std_score
			  AND ACTION_YN = 'Y'
			LIMIT 1;

       END IF;

       IF  in_cate_gory IN ('08') AND in_ntorvalue = 0 THEN
		   SET l_calcvalue = 100.00;
		   SET l_std_score = 5.00;

		   SELECT TRUNCATE(((STD_SCORE / l_max_score) * WE_VALUE),2)
			 INTO l_weightval
			 FROM TBL_WEVALUE_MST
			WHERE CATE_CODE = in_cate_gory
			  AND CONCAT(in_job_month,'01') BETWEEN START_DT AND END_DT
			  AND STD_SCORE = l_std_score
			  AND ACTION_YN = 'Y'
			LIMIT 1;
       END IF;

	   IF  in_cate_gory IN ('15') AND in_ntorvalue = 0 THEN
		   SET l_calcvalue = 50.00;
		   SET l_std_score = 3.00;
		   SET l_weightval = 3.00;
		   /*
		   SELECT TRUNCATE(((STD_SCORE / l_max_score) * WE_VALUE),2)
			 INTO l_weightval
			 FROM TBL_WEVALUE_MST
			WHERE CATE_CODE = in_cate_gory
			  AND CONCAT(in_job_month,'01') BETWEEN START_DT   AND END_DT
			  AND STD_SCORE = l_std_score
			  AND ACTION_YN = 'Y'
			LIMIT 1;
			*/
       END IF;

	ELSE

	   SELECT MAX(IFNULL(STD_SCORE,0))
	        , MAX(IFNULL(WE_VALUE, 0))
	        , MAX(CASE WHEN IFNULL(CAL_GUBUN,'2') = '2' THEN (in_ntorvalue / in_dtorvalue) * 100
	                   ELSE                                  (in_ntorvalue / in_dtorvalue) END )
	     INTO l_max_score, l_stdweight, l_calcvalue
	     FROM TBL_WEVALUE_MST
	    WHERE CATE_CODE = in_cate_gory
	      AND CONCAT(in_job_month,'01') BETWEEN START_DT AND END_DT
	      AND ACTION_YN = 'Y'
	    LIMIT 1;
/*
IF  in_cate_gory = '07' THEN
    INSERT INTO data_log (log_message) VALUES (CONCAT('등록 시작 2',' - ',l_max_score, ' - 가중치 : ', l_stdweight, ' - 산출값 : ', l_calcvalue));
END IF;
*/

		IF in_cate_gory IN ('07') AND in_ntorvalue = 0 THEN
		   
		   SET l_calcvalue = 30.00;
		   SET l_std_score =  3.00;

		   SELECT TRUNCATE(((STD_SCORE / l_max_score) * WE_VALUE),2)
			 INTO l_weightval
			 FROM TBL_WEVALUE_MST
			WHERE CATE_CODE = in_cate_gory
			  AND CONCAT(in_job_month,'01') BETWEEN START_DT AND END_DT
			  AND STD_SCORE = l_std_score
			  AND ACTION_YN = 'Y'
			LIMIT 1;
        END IF;
      

        IF  l_calcvalue = 0.00 AND in_cate_gory IN ('08','14') THEN
            SET l_weightval = l_stdweight;
            SET l_std_score = l_max_score;
            SET l_calcvalue = 100.00;

/*
IF  in_cate_gory = '07' THEN
	INSERT INTO data_log (log_message) VALUES (CONCAT('등록 시작 3',' - ',l_std_score, ' - 현황값 : ', l_weightval, ' - 산출값 : ', l_calcvalue));
END IF;
*/

        ELSE
			IF  in_cate_gory NOT IN ('M1','M2','M3') THEN
			    SELECT TRUNCATE(((STD_SCORE / l_max_score) * WE_VALUE),2), STD_SCORE
			      INTO l_weightval, l_std_score
			      FROM TBL_WEVALUE_MST
			     WHERE CATE_CODE = in_cate_gory
			       AND CONCAT(in_job_month,'01') BETWEEN START_DT   AND END_DT
			       AND l_calcvalue               BETWEEN START_INDI AND END_INDI
			       AND ACTION_YN = 'Y'
			     LIMIT 1;
			END IF;
/*
IF  in_cate_gory = '07' THEN
	INSERT INTO data_log (log_message) VALUES (CONCAT('등록 시작 4',' - ',l_std_score, ' - 현황값 : ', l_weightval, ' - 산출값 : ', l_calcvalue));
END IF;
*/

		END IF;

	END IF;

/*
IF  in_cate_gory = '07' THEN
	INSERT INTO data_log (log_message) VALUES (CONCAT('등록 종료  ',' - ',in_cate_gory,
                                              ' - 산출 : ', l_calcvalue,
                                              ' - 현황 : ', l_weightval,
                                              ' - 구간 : ', l_std_score));
END IF;
*/
    
	IF     inreturnflag = '1' THEN 
		SET RETURNVALUE = l_calcvalue;
	ELSEIF inreturnflag = '2' THEN
		SET RETURNVALUE = l_weightval;
	END IF;    
	            

	RETURN RETURNVALUE;
END$$

DELIMITER ;
