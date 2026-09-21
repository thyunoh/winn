/* ======================================================================
   SP_INDICATORS_STRUCTURE_ZONE — 수정 (2026-09-21)
   [요청] 울산효원요양병원 「구조영역 차등제 신고값 반영 오류 확인 요청」
          2026년 4분기 차등제를 신고하면 7·8·9월 구조영역이 4분기 값으로 다시 계산되어야 하는데
          3분기 값 그대로 남는다(작년까지는 바뀌었다).
   [원인] 달→분기가 <고정>이었다 : 7·8·9월은 언제나 같은 해 3분기 행만 읽는다.
          (작년까지는 차등제 저장 때 직전 분기에 값을 복사하고 재계산하던 코드가 있었는데
           2026-07-03 「한 번 저장 = 한 분기」 요청으로 빠졌다.)
   [고침] ① 그 달에 쓸 신고 분기를 고른다 — 다음 분기 신고가 있으면 그것, 없으면 같은 분기.
             · 7·8·9월 → 4분기(없으면 3분기) · 10·11·12월 → 이듬해 1분기(없으면 4분기)
             · 1·2·3월 → 2분기(없으면 1분기) · 4·5·6월 → 3분기(없으면 2분기)
             ★2026년 1월 이후 달만(2025년 이전은 종전 그대로).
          ② 약사 재직일수 분모 기간도 <고른 분기>를 따른다(4분기 = 6/15~9/14 = 92일).
          ③ 차등제 행이 중복이어도 최신 1건만 읽는다(SELECT … INTO 의 1172 오류 방지).
          ④ 달마다 값 변수를 0 으로 초기화한다(여러 달을 도는 재계산에서 앞달 값이 남던 것).
   ⚠원복 : BACKUP_SP_INDICATORS_STRUCTURE_ZONE_20260921.sql 을 그대로 실행하면 된다.
   ====================================================================== */
DROP PROCEDURE IF EXISTS SP_INDICATORS_STRUCTURE_ZONE;
DELIMITER $$
CREATE PROCEDURE SP_INDICATORS_STRUCTURE_ZONE(IN hosp_cd VARCHAR(10), IN job_month VARCHAR(10), IN str_month VARCHAR(10), IN end_month VARCHAR(10), IN user_id VARCHAR(50))
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
    /* [2026-09-21] 그 달에 쓸 차등제 신고 분기 (울산효원요양병원 요청) */
    DECLARE v_cyy CHAR(4) DEFAULT '';   -- 그 달이 속한 분기의 연도
    DECLARE v_cqt CHAR(1) DEFAULT '';   -- 그 달이 속한 분기
    DECLARE v_nyy CHAR(4) DEFAULT '';   -- 다음 분기 연도(4분기 다음은 이듬해 1분기)
    DECLARE v_nqt CHAR(1) DEFAULT '';   -- 다음 분기
    DECLARE v_gyy CHAR(4) DEFAULT '';   -- ★실제로 쓸 신고 연도
    DECLARE v_gqt CHAR(1) DEFAULT '';   -- ★실제로 쓸 신고 분기
    
    
    WHILE while_cnt <= (CAST(end_month AS UNSIGNED) - CAST(str_month AS UNSIGNED)) DO

        SET while_cnt = while_cnt + 1;
        

		/* ── [2026-09-21] 그 달에 쓸 차등제 신고 분기 고르기 ───────────────────────────
		     규칙(울산효원요양병원 확인 요청) : N분기 신고값은 <직전 분기 석 달>에 적용한다.
		       · 7·8·9월   : 4분기 신고가 있으면 4분기, 없으면 3분기
		       · 10·11·12월: 이듬해 1분기가 있으면 그것, 없으면 4분기
		       · 1·2·3월   : 2분기 → 없으면 1분기   · 4·5·6월 : 3분기 → 없으면 2분기
		     ★2026년 1월 이후 달에만 적용한다(2025년 이전 자료는 종전 그대로 — 사용자 「2026년도부터 변경」).
		     ★종전에는 달→분기가 고정이라(7·8·9월=3분기) 다음 분기를 신고해도 지난달 구조영역이 안 바뀌었다. */
		SET v_cyy = LEFT(job_month, 4);
		SET v_cqt = CAST(CEIL(CAST(RIGHT(job_month, 2) AS UNSIGNED) / 3) AS CHAR);
		SET v_nqt = CASE WHEN v_cqt = '4' THEN '1' ELSE CAST(CAST(v_cqt AS UNSIGNED) + 1 AS CHAR) END;
		SET v_nyy = CASE WHEN v_cqt = '4' THEN CAST(CAST(v_cyy AS UNSIGNED) + 1 AS CHAR) ELSE v_cyy END;
		SET v_gyy = v_cyy;
		SET v_gqt = v_cqt;

		IF job_month >= '202601' THEN
			SELECT gm.START_YY, gm.QTER_FLAG
			  INTO v_gyy, v_gqt
			  FROM TBL_GRADE_MST gm
			 WHERE gm.HOSP_CD   = hosp_cd
			   AND gm.START_YY  = v_nyy
			   AND gm.QTER_FLAG = v_nqt
			   AND gm.ACTION_YN = 'Y'
			 ORDER BY gm.UPD_DTTM DESC
			 LIMIT 1;
		END IF;

		/* 달마다 다시 읽는다 — 앞달 값이 남아 넘어가지 않게 0 으로 초기화 */
		SET pat_count = 0; SET doc_count = 0; SET nur_count = 0; SET nurscount = 0; SET pham_days = 0;

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
		 WHERE gm.HOSP_CD   = hosp_cd
		   AND gm.START_YY  = v_gyy
		   AND gm.QTER_FLAG = v_gqt
		   AND gm.ACTION_YN = 'Y'
		 ORDER BY gm.UPD_DTTM DESC
		 LIMIT 1;
		
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
		 WHERE gm.HOSP_CD   = hosp_cd
		   AND gm.START_YY  = v_gyy
		   AND gm.QTER_FLAG = v_gqt
		   AND gm.ACTION_YN = 'Y';

		SET ntorvalue = pham_days;
		
		/* [2026-09-21] 약사 재직일수 분모 = <실제로 쓴 신고 분기>의 기간 (4분기면 6/15~9/14 = 92일) */
		SET dtorvalue = CASE v_gqt
		                  WHEN '1' THEN DATEDIFF(STR_TO_DATE(CONCAT(CAST(v_gyy AS UNSIGNED)-1, '1214'), '%Y%m%d'),
		                                         STR_TO_DATE(CONCAT(CAST(v_gyy AS UNSIGNED)-1, '0915'), '%Y%m%d')) + 1
		                  WHEN '2' THEN DATEDIFF(STR_TO_DATE(CONCAT(v_gyy,                     '0314'), '%Y%m%d'),
		                                         STR_TO_DATE(CONCAT(CAST(v_gyy AS UNSIGNED)-1, '1215'), '%Y%m%d')) + 1
		                  WHEN '3' THEN DATEDIFF(STR_TO_DATE(CONCAT(v_gyy,                     '0614'), '%Y%m%d'),
		                                         STR_TO_DATE(CONCAT(v_gyy,                     '0315'), '%Y%m%d')) + 1
		                  WHEN '4' THEN DATEDIFF(STR_TO_DATE(CONCAT(v_gyy,                     '0914'), '%Y%m%d'),
		                                         STR_TO_DATE(CONCAT(v_gyy,                     '0615'), '%Y%m%d')) + 1 END;

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
