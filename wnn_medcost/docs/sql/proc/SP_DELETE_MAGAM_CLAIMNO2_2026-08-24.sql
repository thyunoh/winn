/* ============================================================================
   마감업로드 — 환자평가표 배치 삭제가 다른 배치의 환자까지 지우던 문제
   2026-08-24
   ----------------------------------------------------------------------------
   [증상]  같은 달 평가표(.L01)를 나눠 올린 뒤 한 배치를 삭제하면 다른 배치 건수도
           사라짐(더행복 202607 실측: 앞 배치들은 소유 행 0 = "자료없음", 뒤 배치
           삭제 시 겹친 환자 통째 소실). 삭제 후 재업로드 흐름에서 재현.
   [원인]  평가표는 UPSERT 라 겹치는 환자의 CHUNGSEQ 가 마지막 업로드로 넘어가는데,
           삭제는 CHUNGSEQ=그 배치 인 행을 전부 지운다.
   [조치]  같은 달에 다른 평가표 배치가 남아 있으면 삭제 대신 CHUNGSEQ 를 남은
           최신 배치로 이관. 마지막 배치 삭제일 때만 실제 DELETE (기존 동작).
   [영향]  청구(8)·입원현황(Z) 분기는 그대로. 목록(TBL_MAGAM_CHUNG)·이력은 그대로.
   ============================================================================ */
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
		/* ★2026-08-24 — 평가표 삭제가 <다른 배치의 환자까지> 지우던 문제.
		   평가표 업로드는 UPSERT 라 같은 달 파일을 나눠 올리면 겹치는 환자 행의
		   CHUNGSEQ(배치키)가 마지막 업로드로 넘어간다(2026-07-30 수정으로 반드시 넘어감).
		   그 상태에서 어떤 배치를 지우면 그 배치가 <현재 소유한> 행을 통째로 지우므로,
		   다른 파일에서 온 환자까지 함께 사라졌다(더행복 202607 실측: 67건·70건 상호 소실).
		   ⇒ 같은 달에 다른 평가표 배치가 남아 있으면 <삭제하지 않고 소유권만 이관>하고,
		     마지막 배치를 지울 때만 실제 삭제한다(그때는 그 달 평가표를 비우는 게 맞다). */
		SET @remain := ( SELECT MAX(LEFT(b.CLAIM_NO,14))
		                   FROM TBL_MAGAM_CHUNG b
		                  WHERE b.HOSP_CD  = hosp_cd
		                    AND b.MG_YEAR  = mg_year
		                    AND b.MGMONTH  = mgmonth
		                    AND b.MG_FLAG  = '9'
		                    AND b.CLAIM_NO <> claimno );
		IF @remain IS NOT NULL THEN
			UPDATE TBL_PATVAL_MST a
			   SET a.CHUNGSEQ = @remain
			 WHERE a.HOSP_CD  = hosp_cd
		       AND a.CHUNGSEQ = LEFT(claimno,14);
		ELSE
			DELETE FROM TBL_PATVAL_MST a
			 WHERE a.HOSP_CD  = hosp_cd
		       AND a.CHUNGSEQ = LEFT(claimno,14);
		END IF;
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
    
END
$$

DELIMITER ;
