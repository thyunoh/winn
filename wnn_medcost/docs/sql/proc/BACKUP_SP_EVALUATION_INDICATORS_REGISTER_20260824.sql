-- 원본 백업 (2026-08-24 수정 전). 그대로 실행하면 원복된다.
DROP PROCEDURE IF EXISTS SP_EVALUATION_INDICATORS_REGISTER;

DELIMITER $$

CREATE DEFINER=`winner`@`%` PROCEDURE `SP_EVALUATION_INDICATORS_REGISTER`(
	IN `in_hosp_cd` VARCHAR(10),
	IN `in_str_month` VARCHAR(10),
	IN `in_end_month` VARCHAR(10),
	IN `in_job_month` VARCHAR(10),
	IN `in_cate_gory` VARCHAR(10),
	IN `in_cate_flag` VARCHAR(10),
	IN `in_dtorvalue` DECIMAL(10,2),
	IN `in_ntorvalue` DECIMAL(10,2),
	IN `in_reg_user` VARCHAR(50)
)
BEGIN

    DECLARE l_calcvalue DECIMAL(10,2) DEFAULT 0.00;
    DECLARE l_max_score INT           DEFAULT 0;
    DECLARE l_weightval DECIMAL(10,2) DEFAULT 0.00;
    DECLARE l_std_score DECIMAL(10,2) DEFAULT 0.00;
    DECLARE l_stdweight DECIMAL(10,2) DEFAULT 0.00;
    DECLARE l_calc_flag VARCHAR(10)   DEFAULT '2';

    DECLARE l_iuds_sqls VARCHAR(1000) DEFAULT '';
    
    DECLARE l_samfileyn VARCHAR(1)    DEFAULT 'N';

    SET in_dtorvalue = IFNULL(in_dtorvalue,0);
    SET in_ntorvalue = IFNULL(in_ntorvalue,0);

    SET in_reg_user = IFNULL(NULLIF(TRIM(in_reg_user),''), 'SYSTEM');
    
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


		IF in_cate_gory IN ('07') AND in_ntorvalue = 0 THEN
		   
		   SET l_samfileyn = 'N';
		   
		   SELECT 'Y'
		     INTO l_samfileyn
			 FROM TBL_CHUNG_MST a
		    WHERE a.HOSP_CD  = in_hosp_cd
		      AND a.DATE_YM  = in_job_month
		      AND a.CFORM_NO IN ('H010','H011')			 
		    LIMIT 1 ;
		     
		   IF  l_samfileyn = 'N' THEN 
			   SET l_calcvalue = 30.00;
			   SET l_std_score =  3.00;
           END IF;
           
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


		END IF;

	END IF;


    SET l_iuds_sqls = CONCAT("INSERT INTO TBL_PAT_INDI (HOSP_CD, STRYYMM, ENDYYMM, JOBYYMM, CATE_CD,
                                                        CATE_FG, DTORVAL, NTORVAL, CAL_VAL, MAX_VAL,
                                                        STDWEIG, WEIGVAL, S_SCORE, REG_USER,UPD_USER) VALUES ('",
                              in_hosp_cd,                 "','"
                            , in_str_month,               "','"
                            , in_end_month,               "','"
                            , in_job_month,               "','"
                            , in_cate_gory,               "','"
                            , in_cate_flag,               "','"
                            , IFNULL(in_dtorvalue, 0.00), "','"
                            , IFNULL(in_ntorvalue, 0.00), "','"
                            , IFNULL(l_calcvalue,  0.00), "','"
                            , IFNULL(l_max_score,  0),    "','"
                            , IFNULL(l_stdweight,  0.00), "','"
                            , IFNULL(l_weightval,  0.00), "','"
                            , IFNULL(l_std_score,  0),    "','"
                            , in_reg_user,                "','"
                            , in_reg_user,                "')\n",
                            " ON DUPLICATE KEY UPDATE          ",
                            "    CATE_FG  = VALUES(CATE_FG),   ",
                            "    DTORVAL  = VALUES(DTORVAL),   ",
                            "    NTORVAL  = VALUES(NTORVAL),   ",
                            "    CAL_VAL  = VALUES(CAL_VAL),   ",
                            "    MAX_VAL  = VALUES(MAX_VAL),   ",
                            "    STDWEIG  = VALUES(STDWEIG),   ",
                            "    WEIGVAL  = VALUES(WEIGVAL),   ",
                            "    S_SCORE  = VALUES(S_SCORE),   ",
                            "    REG_USER = VALUES(REG_USER),  ",
                            "    UPD_USER = VALUES(UPD_USER);");

    CALL SP_EXECUTE_DYNAMIC_SQL(l_iuds_sqls);

END$$

DELIMITER ;
