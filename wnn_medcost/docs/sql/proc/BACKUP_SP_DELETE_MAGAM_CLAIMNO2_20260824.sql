-- 원본 백업 (2026-08-24 수정 전). 그대로 실행하면 원복된다.
DROP PROCEDURE IF EXISTS SP_DELETE_MAGAM_CLAIMNO2;

DELIMITER $$

CREATE DEFINER=`winner`@`%` PROCEDURE `SP_DELETE_MAGAM_CLAIMNO2`(
    IN hosp_cd  VARCHAR(8),

    IN mg_year  VARCHAR(4),
    IN mgmonth  VARCHAR(2),
    IN mg_flag  VARCHAR(1),

    IN claimno  VARCHAR(50),
    IN user_id  VARCHAR(50),
    
   OUT errcode  VARCHAR(5),
   OUT errmess  VARCHAR(1000)
)
BEGIN

	DECLARE data_rows INT DEFAULT 0;

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        DECLARE errstat VARCHAR(5);
	    DECLARE errtext VARCHAR(1000);

	    GET DIAGNOSTICS CONDITION 1
	        errcode = RETURNED_SQLSTATE,
	        errmess = MESSAGE_TEXT;

	    SET errcode = IFNULL(errstat,'45000');
	    SET errmess = CONCAT(IFNULL(errstat, 'SQLSTATE 없음'), ' - ', IFNULL(errtext, 'MESSAGE 없음'));

	    ROLLBACK;
    END;

    START TRANSACTION;
	/*
	INSERT INTO data_log (log_message) VALUES (CONCAT('111 - '
	                                                 ,hosp_cd,'-'
	                                                 ,mg_year,'-'
	                                                 ,mgmonth,'-'
	                                                 ,mg_flag,'-'
	                                                 ,claimno));
	*/                                                

	IF     mg_flag = '8' THEN
		-- 청구서
		DELETE FROM TBL_CHUNG_MST a
		 WHERE a.HOSP_CD  = hosp_cd
	       AND a.CLAIM_NO = claimno;
	    -- 명세서
		DELETE FROM TBL_MYOUNG_MST b
		 WHERE b.HOSP_CD  = hosp_cd
	       AND b.CLAIM_NO = claimno;
	    -- 진단
	    DELETE FROM TBL_DISEASE_MST c
	     WHERE c.HOSP_CD  = hosp_cd
	       AND c.CLAIM_NO = claimno;
		-- 진료비
	    DELETE FROM TBL_JINORD_MST d
	     WHERE d.HOSP_CD  = hosp_cd
	       AND d.CLAIM_NO = claimno;
		-- 특정내역
	    DELETE FROM TBL_SPECODE_MST e
	     WHERE e.HOSP_CD  = hosp_cd
	       AND e.CLAIM_NO = claimno;
	    -- 원외처방전
	    DELETE FROM TBL_JINOUT_MST f
	     WHERE f.HOSP_CD  = hosp_cd
	       AND f.CLAIM_NO = claimno;
		-- 열외군
	    DELETE FROM TBL_JINORDOTR_MST g
	     WHERE g.HOSP_CD  = hosp_cd
	       AND g.CLAIM_NO = claimno;
	ELSEIF mg_flag = '9' THEN
		-- 평가표 삭제
		DELETE FROM TBL_PATVAL_MST a
		 WHERE a.HOSP_CD  = hosp_cd
	       AND a.CHUNGSEQ = LEFT(claimno,14);
	ELSEIF mg_flag = 'Z' THEN
		-- 입원현황 삭제
		DELETE FROM TBL_IPWON_INFO a
		 WHERE a.HOSP_CD = hosp_cd
	       AND a.JOBYYMM = CONCAT(mg_year,mgmonth);
	       
	END IF;

	DELETE FROM TBL_MAGAM_CHUNG a
	 WHERE a.HOSP_CD  = hosp_cd
	   AND a.MG_YEAR  = mg_year
	   AND a.MGMONTH  = mgmonth
	   AND a.MG_FLAG  = mg_flag
	   AND a.CLAIM_NO = claimno;

	DELETE FROM TBL_MAGAM_INFO c
     WHERE c.HOSP_CD = hosp_cd
       AND c.MG_YEAR = mg_year
       AND c.MGMONTH = mgmonth
       AND c.MG_FLAG = mg_flag
       AND NOT EXISTS ( SELECT 1
                          FROM TBL_MAGAM_CHUNG b
                         WHERE b.HOSP_CD = c.HOSP_CD
                           AND b.MG_YEAR = c.MG_YEAR
                           AND b.MGMONTH = c.MGMONTH
                           AND b.MG_FLAG = c.MG_FLAG
                      );
       
	                                     
	INSERT INTO TBL_MAGAM_DEL_HIS
    (HOSP_CD, MG_YEAR, MGMONTH, MG_FLAG, CLAIM_NO, DEL_DTTM, DEL_USER)
	VALUES
    (hosp_cd, mg_year, mgmonth, mg_flag, claimno, NOW(), user_id);	                      
    
                   
	COMMIT;

    SET errcode = '0';
    SET errmess = '성공';
    
END$$

DELIMITER ;
