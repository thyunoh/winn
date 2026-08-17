/* ======================================================================
   SP_INDICATORS_STRUCTURE_ZONE — 수정 (2026-08-17)
   차등제 등록 화면에서 구조영역을 다시 계산할 때 쓰는 프로시저.

   [증상] 차등제를 **신고하지 않은 분기**인데 「약사 재직일수율(04)」에만 결과 1.1점이 붙는다
          (분모 92 · 분자 0 · 현황값 0%).
   [원인] 약사만 ***분모를 신고값이 아니라 날짜 계산식***으로 만든다(4분기 = 6/15~9/14 = 92일,
          신고 여부와 무관하게 항상). 분자(PHAM_DAYS)는 신고가 없으면 `SELECT ... INTO` 가
          아무 것도 못 넣어 0 ⇒ 0/92 = 0% → 표준화 1구간 → 5.5÷5 = **1.1점**.
          01~03(의사·간호사·간호인력)은 분모가 신고값이라 미신고 시 0 → **미산정 0점**이라 티가 안 났다.
   [고침] **약사 블록 한 곳만** 손댄다 — 그 분기 신고 행 수를 센 뒤(`v_has`) 없으면 분모·분자 0.
          ★***01~03 은 건드리지 않는다***(사용자 지시 「약사만 오류이니까」). 다른 지표 로직 무변경.
          ★신고했는데 약사재직일수만 0 인 달은 **그대로 1구간(1.1점)** — 「약사가 없다」는 사실값이다.
   ⚠원본 백업 : BACKUP_SP_INDICATORS_STRUCTURE_ZONE_20260817.sql (그대로 실행하면 원복)
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
    DECLARE v_has      INT            DEFAULT 0;   -- ★그 분기 차등제 신고 행 수(2026-08-17)
    
    
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
		
		/* ★[2026-08-17] **그 분기 차등제 신고 행이 있는지** 센다 — 위 SELECT ... INTO 는 행이 없으면
		     변수를 그대로 두므로(0) 「신고 없음」과 「신고했으나 0」을 구별할 수 없다.
		   ※구조영역 01~03 은 분모가 신고값이라 미신고 시 저절로 0(미산정)이 된다 — **약사만** 손댄다. */
		SELECT COUNT(*) INTO v_has
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

		SET ntorvalue = pham_days;
		
		SET dtorvalue = CASE WHEN RIGHT(job_month , 2) IN ('01','02','03') THEN DATEDIFF(STR_TO_DATE(CONCAT(LEFT(job_month, 4)-1, '1214'), '%Y%m%d'),
				                                                                         STR_TO_DATE(CONCAT(LEFT(job_month, 4)-1, '0915'), '%Y%m%d')) + 1 
				             WHEN RIGHT(job_month , 2) IN ('04','05','06') THEN DATEDIFF(STR_TO_DATE(CONCAT(LEFT(job_month, 4),   '0314'), '%Y%m%d'),
				                                                                         STR_TO_DATE(CONCAT(LEFT(job_month, 4)-1, '1215'), '%Y%m%d')) + 1
				             WHEN RIGHT(job_month , 2) IN ('07','08','09') THEN DATEDIFF(STR_TO_DATE(CONCAT(LEFT(job_month, 4),   '0614'), '%Y%m%d'),
				                                                                         STR_TO_DATE(CONCAT(LEFT(job_month, 4),   '0315'), '%Y%m%d')) + 1                                                                         
							 WHEN RIGHT(job_month , 2) IN ('10','11','12') THEN DATEDIFF(STR_TO_DATE(CONCAT(LEFT(job_month, 4),   '0914'), '%Y%m%d'),
				                                                                         STR_TO_DATE(CONCAT(LEFT(job_month, 4),   '0615'), '%Y%m%d')) + 1 END;

	    /* ★[2026-08-17] **미신고면 분모도 0** — 이 한 곳이 「1.1점」의 진짜 출처다. */
	    IF v_has = 0 THEN
	        SET dtorvalue = 0;
	        SET ntorvalue = 0;
	    END IF;

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
