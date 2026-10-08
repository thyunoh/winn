-- [2026-10-08] PATIENT_CATHETER_CHECK — 전월 평가표 작성일이 말일(31일 등)이면 「월 자료생성」 전체가 실패하던 것
--   증상(관리자 박혜련) : 강동우리들요양병원(11281847) 2026-09 적정성평가 자료생성을 누르면 바로 실패(오류 90000, 메시지 없음).
--     원인 메시지(dry-run) = Incorrect datetime value: '20260732' for function str_to_date
--   원인 : 분기 2(전월 유치도뇨관 0·일자 전부 공란 → 당월 삽입 1·첫 삽입일 공란)에서
--          SET In_Date_01 = PmDoc_Date + 1;  ← 글자 '20260731' 에 1 을 더해 20260732 (날짜가 아니라 숫자 덧셈)
--          그 값을 뒤에서 STR_TO_DATE 로 읽다 죽는다. 다른 분기 3~6 은 DATE_ADD(... INTERVAL 1 DAY) 로 되어 있었다.
--          트리거 = 문수예(3402162011616) 8월 평가표 작성일 20260731. 전월 작성일이 말일(…31, 30일 달의 30, 2월 28)인 환자가 있는 달만 걸린다.
--   고침 : 그 한 줄을 DATE_FORMAT(DATE_ADD(STR_TO_DATE(PmDoc_Date,'%Y%m%d'), INTERVAL 1 DAY), '%Y%m%d') 로. 나머지는 운영 원본(2026-10-01 판) 그대로.
--   검증 : 임시 이름(ZZ_PCC_TEST)으로 만들어 CREATE2 사본(ROLLBACK) 에 물려 11281847/202609 끝까지 실행 → errcode 0.
--   적용 뒤 강동우리들 9월 「자료생성」을 다시 누르면 된다. 앱 변경·재기동 없음.
--   원복 : BACKUP_PATIENT_CATHETER_CHECK_20261008.sql
DROP FUNCTION IF EXISTS PATIENT_CATHETER_CHECK;
DELIMITER $$
CREATE DEFINER=`winner`@`%` FUNCTION `PATIENT_CATHETER_CHECK`(
	`p_hostcd` VARCHAR(10),
	`p_clform` VARCHAR(10),
	`p_pat_id` VARCHAR(20),
	`p_adm_dt` VARCHAR(10),
	`p_med_dt` VARCHAR(10),
	`p_evalfg` VARCHAR(10),
	`p_cathfg` VARCHAR(10),
	`p_pclass` VARCHAR(10)
) RETURNS varchar(1) CHARSET utf8mb4
    DETERMINISTIC
BEGIN

    DECLARE Return_Val VARCHAR(1) DEFAULT 'N';

    DECLARE PmCathFlag VARCHAR(1) DEFAULT '0';
    DECLARE PmNullFlag VARCHAR(1) DEFAULT 'N';
    DECLARE PmLastFlag VARCHAR(1) DEFAULT '0';
    DECLARE PmLastDate VARCHAR(8) DEFAULT '00000000';
    DECLARE PmLastInsD VARCHAR(8) DEFAULT '00000000';
    DECLARE PmLastOutD VARCHAR(8) DEFAULT '00000000';
    DECLARE PmDoc_Date VARCHAR(8) DEFAULT '00000000';

    DECLARE CmCathFlag VARCHAR(1) DEFAULT '0';
    DECLARE CmNullFlag VARCHAR(1) DEFAULT 'N';
    DECLARE CmLastFlag VARCHAR(1) DEFAULT '0';
    DECLARE CmLastDate VARCHAR(8) DEFAULT '00000000';
    DECLARE CmLastInsD VARCHAR(8) DEFAULT '00000000';
    DECLARE CmLastOutD VARCHAR(8) DEFAULT '00000000';
    DECLARE CmDoc_Date VARCHAR(8) DEFAULT '00000000';

    DECLARE In_Date_01 VARCHAR(8) DEFAULT '00000000';
    DECLARE In_Date_02 VARCHAR(8) DEFAULT '00000000';
    DECLARE In_Date_03 VARCHAR(8) DEFAULT '00000000';
    DECLARE In_Date_04 VARCHAR(8) DEFAULT '00000000';
    DECLARE In_Date_05 VARCHAR(8) DEFAULT '00000000';
    DECLARE In_Date_06 VARCHAR(8) DEFAULT '00000000';
    DECLARE In_Date_07 VARCHAR(8) DEFAULT '00000000';
    DECLARE In_Date_08 VARCHAR(8) DEFAULT '00000000';
    DECLARE In_Date_09 VARCHAR(8) DEFAULT '00000000';
    DECLARE In_Date_10 VARCHAR(8) DEFAULT '00000000';

    DECLARE OutDate_01 VARCHAR(8) DEFAULT '00000000';
    DECLARE OutDate_02 VARCHAR(8) DEFAULT '00000000';
    DECLARE OutDate_03 VARCHAR(8) DEFAULT '00000000';
    DECLARE OutDate_04 VARCHAR(8) DEFAULT '00000000';
    DECLARE OutDate_05 VARCHAR(8) DEFAULT '00000000';
    DECLARE OutDate_06 VARCHAR(8) DEFAULT '00000000';
    DECLARE OutDate_07 VARCHAR(8) DEFAULT '00000000';
    DECLARE OutDate_08 VARCHAR(8) DEFAULT '00000000';
    DECLARE OutDate_09 VARCHAR(8) DEFAULT '00000000';
    DECLARE OutDate_10 VARCHAR(8) DEFAULT '00000000';

    DECLARE PatnoClass VARCHAR(10) DEFAULT NULL;

	DECLARE Select_Cnt INT DEFAULT 0;


	DECLARE in_dates   VARCHAR(8);
   DECLARE out_date   VARCHAR(8);
   DECLARE cur_ins_dt DATE;
   DECLARE cur_out_dt DATE;
   DECLARE next_ins_dt DATE;
   DECLARE day_diff   INT;

   DECLARE i INT DEFAULT 1;
   DECLARE finished INT DEFAULT 0;

	DECLARE CONTINUE HANDLER FOR NOT FOUND SET Select_Cnt = 0;


    SET PatnoClass = p_pclass;


	IF IFNULL(p_cathfg,'0') = '0' OR LEFT(PatnoClass,1) = 'A' OR p_evalfg NOT IN ('2') THEN

	   SET Return_Val = 'N';

	ELSE

		SET Select_Cnt = 0;



	    -- 전월 : 유치도뇨관, 공란여부, 마지막(삽입 또는 제거), 마지막일자, 작성일자
	    SELECT
		     -- 유치도뇨관
		       ppm.INDWELL_CATH
		     -- 공란여부
		     , CASE WHEN REPLACE(CONCAT(ppm.CAT_IN_1, ppm.CAT_OUT_1, ppm.CAT_IN_2, ppm.CAT_OUT_2, ppm.CAT_IN_3, ppm.CAT_OUT_3, ppm.CAT_IN_4, ppm.CAT_OUT_4,
		                                ppm.CAT_IN_5, ppm.CAT_OUT_5, ppm.CAT_IN_6, ppm.CAT_OUT_6, ppm.CAT_IN_7, ppm.CAT_OUT_7, ppm.CAT_IN_8, ppm.CAT_OUT_8,
		                                ppm.CAT_IN_9, ppm.CAT_OUT_9, ppm.CAT_IN_10,ppm.CAT_OUT_10),'0','' ) = '' THEN 'Y' ELSE 'N' END
		     -- 마지막 삽입,제거 구분
		     , CASE WHEN ppm.CAT_OUT_10 != '00000000' THEN '2'
		            WHEN ppm.CAT_IN_10  != '00000000' THEN '1'
		            WHEN ppm.CAT_OUT_9  != '00000000' THEN '2'
		            WHEN ppm.CAT_IN_9   != '00000000' THEN '1'
		            WHEN ppm.CAT_OUT_8  != '00000000' THEN '2'
		            WHEN ppm.CAT_IN_8   != '00000000' THEN '1'
		            WHEN ppm.CAT_OUT_7  != '00000000' THEN '2'
		            WHEN ppm.CAT_IN_7   != '00000000' THEN '1'
		            WHEN ppm.CAT_OUT_6  != '00000000' THEN '2'
		            WHEN ppm.CAT_IN_6   != '00000000' THEN '1'
		            WHEN ppm.CAT_OUT_5  != '00000000' THEN '2'
		            WHEN ppm.CAT_IN_5   != '00000000' THEN '1'
		            WHEN ppm.CAT_OUT_4  != '00000000' THEN '2'
		            WHEN ppm.CAT_IN_4   != '00000000' THEN '1'
		            WHEN ppm.CAT_OUT_3  != '00000000' THEN '2'
		            WHEN ppm.CAT_IN_3   != '00000000' THEN '1'
		            WHEN ppm.CAT_OUT_2  != '00000000' THEN '2'
		            WHEN ppm.CAT_IN_2   != '00000000' THEN '1'
		            WHEN ppm.CAT_OUT_1  != '00000000' THEN '2'
		            WHEN ppm.CAT_IN_1   != '00000000' THEN '1' ELSE '0' END
		     -- 마지막 삽입,제거일자
		     , CASE WHEN ppm.CAT_OUT_10 != '00000000' THEN ppm.CAT_OUT_10
		            WHEN ppm.CAT_IN_10  != '00000000' THEN ppm.CAT_IN_10
		            WHEN ppm.CAT_OUT_9  != '00000000' THEN ppm.CAT_OUT_9
		            WHEN ppm.CAT_IN_9   != '00000000' THEN ppm.CAT_IN_9
		            WHEN ppm.CAT_OUT_8  != '00000000' THEN ppm.CAT_OUT_8
		            WHEN ppm.CAT_IN_8   != '00000000' THEN ppm.CAT_IN_8
		            WHEN ppm.CAT_OUT_7  != '00000000' THEN ppm.CAT_OUT_7
		            WHEN ppm.CAT_IN_7   != '00000000' THEN ppm.CAT_IN_7
		            WHEN ppm.CAT_OUT_6  != '00000000' THEN ppm.CAT_OUT_6
		            WHEN ppm.CAT_IN_6   != '00000000' THEN ppm.CAT_IN_6
		            WHEN ppm.CAT_OUT_5  != '00000000' THEN ppm.CAT_OUT_5
		            WHEN ppm.CAT_IN_5   != '00000000' THEN ppm.CAT_IN_5
		            WHEN ppm.CAT_OUT_4  != '00000000' THEN ppm.CAT_OUT_4
		            WHEN ppm.CAT_IN_4   != '00000000' THEN ppm.CAT_IN_4
		            WHEN ppm.CAT_OUT_3  != '00000000' THEN ppm.CAT_OUT_3
		            WHEN ppm.CAT_IN_3   != '00000000' THEN ppm.CAT_IN_3
		            WHEN ppm.CAT_OUT_2  != '00000000' THEN ppm.CAT_OUT_2
		            WHEN ppm.CAT_IN_2   != '00000000' THEN ppm.CAT_IN_2
		            WHEN ppm.CAT_OUT_1  != '00000000' THEN ppm.CAT_OUT_1
		            WHEN ppm.CAT_IN_1   != '00000000' THEN ppm.CAT_IN_1 ELSE '00000000' END
		     -- 마지막 삽입일자 (★ 삽입만 있고 제거 없으면 MED_START + 1일)
		     , CASE WHEN REPLACE(CONCAT(ppm.CAT_IN_1, ppm.CAT_IN_2, ppm.CAT_IN_3, ppm.CAT_IN_4, ppm.CAT_IN_5,
		                                ppm.CAT_IN_6, ppm.CAT_IN_7, ppm.CAT_IN_8, ppm.CAT_IN_9, ppm.CAT_IN_10),'0','') <> ''
		                 AND REPLACE(CONCAT(ppm.CAT_OUT_1, ppm.CAT_OUT_2, ppm.CAT_OUT_3, ppm.CAT_OUT_4, ppm.CAT_OUT_5,
		                                    ppm.CAT_OUT_6, ppm.CAT_OUT_7, ppm.CAT_OUT_8, ppm.CAT_OUT_9, ppm.CAT_OUT_10),'0','') = ''
					        AND EXISTS ( SELECT 1
					                              FROM TBL_PATVAL_MST cur
					                             WHERE cur.HOSP_CD    = p_hostcd
					                               AND cur.CLFORM_VER = p_clform
					                               AND cur.PAT_ID     = p_pat_id
					                               AND cur.ADMIT_DT   = p_adm_dt
					                               AND cur.MED_START  = p_med_dt
					                               AND REPLACE(CONCAT(cur.CAT_OUT_1, cur.CAT_OUT_2, cur.CAT_OUT_3, cur.CAT_OUT_4, cur.CAT_OUT_5,
					                                                  cur.CAT_OUT_6, cur.CAT_OUT_7, cur.CAT_OUT_8, cur.CAT_OUT_9, cur.CAT_OUT_10),'0','') <> ''
					                               AND REPLACE(CONCAT(cur.CAT_IN_1,  cur.CAT_IN_2,  cur.CAT_IN_3,  cur.CAT_IN_4,  cur.CAT_IN_5,
					                                                  cur.CAT_IN_6,  cur.CAT_IN_7,  cur.CAT_IN_8,  cur.CAT_IN_9,  cur.CAT_IN_10),'0','') = '' )
		            THEN DATE_FORMAT(DATE_ADD(STR_TO_DATE(ppm.MED_START, '%Y%m%d'), INTERVAL 1 DAY), '%Y%m%d')
		            WHEN ppm.CAT_IN_10  != '00000000' THEN ppm.CAT_IN_10
		            WHEN ppm.CAT_IN_9   != '00000000' THEN ppm.CAT_IN_9
		            WHEN ppm.CAT_IN_8   != '00000000' THEN ppm.CAT_IN_8
		            WHEN ppm.CAT_IN_7   != '00000000' THEN ppm.CAT_IN_7
		            WHEN ppm.CAT_IN_6   != '00000000' THEN ppm.CAT_IN_6
		            WHEN ppm.CAT_IN_5   != '00000000' THEN ppm.CAT_IN_5
		            WHEN ppm.CAT_IN_4   != '00000000' THEN ppm.CAT_IN_4
		            WHEN ppm.CAT_IN_3   != '00000000' THEN ppm.CAT_IN_3
		            WHEN ppm.CAT_IN_2   != '00000000' THEN ppm.CAT_IN_2
		            WHEN ppm.CAT_IN_1   != '00000000' THEN ppm.CAT_IN_1 ELSE '00000000' END
		     -- 마지막 제거일자
		     , CASE WHEN ppm.CAT_OUT_10 != '00000000' THEN ppm.CAT_OUT_10
		            WHEN ppm.CAT_OUT_9  != '00000000' THEN ppm.CAT_OUT_9
		            WHEN ppm.CAT_OUT_8  != '00000000' THEN ppm.CAT_OUT_8
		            WHEN ppm.CAT_OUT_7  != '00000000' THEN ppm.CAT_OUT_7
		            WHEN ppm.CAT_OUT_6  != '00000000' THEN ppm.CAT_OUT_6
		            WHEN ppm.CAT_OUT_5  != '00000000' THEN ppm.CAT_OUT_5
		            WHEN ppm.CAT_OUT_4  != '00000000' THEN ppm.CAT_OUT_4
		            WHEN ppm.CAT_OUT_3  != '00000000' THEN ppm.CAT_OUT_3
		            WHEN ppm.CAT_OUT_2  != '00000000' THEN ppm.CAT_OUT_2
		            WHEN ppm.CAT_OUT_1  != '00000000' THEN ppm.CAT_OUT_1 ELSE '00000000' END
		     -- 작성일자
		     , ppm.DOC_DT
		     , 1
	      INTO PmCathFlag
	         , PmNullFlag
	         , PmLastFlag
	         , PmLastDate
	         , PmLastInsD
	         , PmLastOutD
	         , PmDoc_Date
	         , Select_Cnt
		  FROM TBL_PATVAL_MST ppm
		 WHERE ppm.HOSP_CD    = p_hostcd
		   AND ppm.CLFORM_VER = p_clform
		   AND ppm.PAT_ID     = p_pat_id
		   AND ppm.ADMIT_DT   = p_adm_dt
-- 		   AND ppm.MED_START  LIKE CONCAT(DATE_FORMAT(DATE_SUB(CONCAT(LEFT(p_med_dt,6), '01'), INTERVAL 1 MONTH), '%Y%m'),'%')
-- 		   AND ppm.DOC_DT = ( SELECT MAX(c.DOC_DT)
-- 	                             FROM TBL_PATVAL_MST c
-- 	                            WHERE c.HOSP_CD    = ppm.HOSP_CD
-- 	                              AND c.CLFORM_VER = ppm.CLFORM_VER
-- 	                              AND c.MED_START  = ppm.MED_START
-- 	                              AND c.PAT_ID     = ppm.PAT_ID )
--          LIMIT 1;
		   /* [2026-10-01] 전월 평가표 → <직전 평가표> : 같은 입원에서 이 평가표 바로 앞에 작성된 것.
		        (전월 1일 ~ 이 평가표 요양개시일 전) 가운데 가장 늦은 것 — 당월에 평가표가 여러 번이면 당월 앞 평가표가 잡힌다.
		      종전에는 당월 2차 평가표도 전월 평가표와 바로 이어서, 당월 1차 평가표에 적힌 제거일이 무시됐다
		        (이푸른 차명옥 : 8월 삽입 08-06 → 9월 1차에 제거 08-19 기재 → 9월 2차(09-07~09-18)가 8월 삽입과 이어져 14일 초과로 잡힘).
		      전월에 평가표가 여러 번일 때도 종전에는 순서 없이 한 건(LIMIT 1)이었다 — 이제 마지막 것. */
			AND ppm.MED_START >= CONCAT(DATE_FORMAT(DATE_SUB(CONCAT(LEFT(p_med_dt,6), '01'), INTERVAL 1 MONTH), '%Y%m'),'01')
			AND ppm.MED_START <  p_med_dt
			AND NOT (ppm.MED_START >= CONCAT(LEFT(p_med_dt,6),'01') AND ppm.DOC_DT = (SELECT cx.DOC_DT
			                     FROM TBL_PATVAL_MST cx
			                    WHERE cx.HOSP_CD    = p_hostcd
			                      AND cx.CLFORM_VER = p_clform
			                      AND cx.PAT_ID     = p_pat_id
			                      AND cx.ADMIT_DT   = p_adm_dt
			                      AND cx.MED_START  = p_med_dt))
			ORDER BY ppm.MED_START DESC, ppm.DOC_DT DESC
			LIMIT 1;

	    -- 당월 : 공란여부, 마지막(삽입 또는 제거), 마지막일자, 작성일자, 삽입10개, 제거10개
	    SELECT
	         -- 유치도뇨관
	           cpm.INDWELL_CATH
	         -- 공란여부
	         , CASE WHEN REPLACE(CONCAT(cpm.CAT_IN_1, cpm.CAT_OUT_1, cpm.CAT_IN_2, cpm.CAT_OUT_2, cpm.CAT_IN_3, cpm.CAT_OUT_3, cpm.CAT_IN_4, cpm.CAT_OUT_4,
								        cpm.CAT_IN_5, cpm.CAT_OUT_5, cpm.CAT_IN_6, cpm.CAT_OUT_6, cpm.CAT_IN_7, cpm.CAT_OUT_7, cpm.CAT_IN_8, cpm.CAT_OUT_8,
								        cpm.CAT_IN_9, cpm.CAT_OUT_9, cpm.CAT_IN_10,cpm.CAT_OUT_10),'0','' ) = '' THEN 'Y' ELSE 'N' END
			 -- 마지막 삽입,제거 구분
			 , CASE WHEN cpm.CAT_OUT_10 != '00000000' THEN '2'
			        WHEN cpm.CAT_IN_10  != '00000000' THEN '1'
			        WHEN cpm.CAT_OUT_9  != '00000000' THEN '2'
			        WHEN cpm.CAT_IN_9   != '00000000' THEN '1'
			        WHEN cpm.CAT_OUT_8  != '00000000' THEN '2'
			        WHEN cpm.CAT_IN_8   != '00000000' THEN '1'
			        WHEN cpm.CAT_OUT_7  != '00000000' THEN '2'
			        WHEN cpm.CAT_IN_7   != '00000000' THEN '1'
			        WHEN cpm.CAT_OUT_6  != '00000000' THEN '2'
			        WHEN cpm.CAT_IN_6   != '00000000' THEN '1'
			        WHEN cpm.CAT_OUT_5  != '00000000' THEN '2'
			        WHEN cpm.CAT_IN_5   != '00000000' THEN '1'
			        WHEN cpm.CAT_OUT_4  != '00000000' THEN '2'
			        WHEN cpm.CAT_IN_4   != '00000000' THEN '1'
			        WHEN cpm.CAT_OUT_3  != '00000000' THEN '2'
			        WHEN cpm.CAT_IN_3   != '00000000' THEN '1'
			        WHEN cpm.CAT_OUT_2  != '00000000' THEN '2'
			        WHEN cpm.CAT_IN_2   != '00000000' THEN '1'
			        WHEN cpm.CAT_OUT_1  != '00000000' THEN '2'
			        WHEN cpm.CAT_IN_1   != '00000000' THEN '1' ELSE '0' END
			 -- 마지막 삽입,제거일자
			 , CASE WHEN cpm.CAT_OUT_10 != '00000000' THEN cpm.CAT_OUT_10
			        WHEN cpm.CAT_IN_10  != '00000000' THEN cpm.CAT_IN_10
			        WHEN cpm.CAT_OUT_9  != '00000000' THEN cpm.CAT_OUT_9
			        WHEN cpm.CAT_IN_9   != '00000000' THEN cpm.CAT_IN_9
			        WHEN cpm.CAT_OUT_8  != '00000000' THEN cpm.CAT_OUT_8
			        WHEN cpm.CAT_IN_8   != '00000000' THEN cpm.CAT_IN_8
			        WHEN cpm.CAT_OUT_7  != '00000000' THEN cpm.CAT_OUT_7
			        WHEN cpm.CAT_IN_7   != '00000000' THEN cpm.CAT_IN_7
			        WHEN cpm.CAT_OUT_6  != '00000000' THEN cpm.CAT_OUT_6
			        WHEN cpm.CAT_IN_6   != '00000000' THEN cpm.CAT_IN_6
			        WHEN cpm.CAT_OUT_5  != '00000000' THEN cpm.CAT_OUT_5
			        WHEN cpm.CAT_IN_5   != '00000000' THEN cpm.CAT_IN_5
			        WHEN cpm.CAT_OUT_4  != '00000000' THEN cpm.CAT_OUT_4
			        WHEN cpm.CAT_IN_4   != '00000000' THEN cpm.CAT_IN_4
			        WHEN cpm.CAT_OUT_3  != '00000000' THEN cpm.CAT_OUT_3
			        WHEN cpm.CAT_IN_3   != '00000000' THEN cpm.CAT_IN_3
			        WHEN cpm.CAT_OUT_2  != '00000000' THEN cpm.CAT_OUT_2
			        WHEN cpm.CAT_IN_2   != '00000000' THEN cpm.CAT_IN_2
			        WHEN cpm.CAT_OUT_1  != '00000000' THEN cpm.CAT_OUT_1
			        WHEN cpm.CAT_IN_1   != '00000000' THEN cpm.CAT_IN_1 ELSE '00000000' END
			 -- 마지막 삽입일자
			 , CASE WHEN cpm.CAT_IN_10  != '00000000' THEN cpm.CAT_IN_10
			        WHEN cpm.CAT_IN_9   != '00000000' THEN cpm.CAT_IN_9
			        WHEN cpm.CAT_IN_8   != '00000000' THEN cpm.CAT_IN_8
			        WHEN cpm.CAT_IN_7   != '00000000' THEN cpm.CAT_IN_7
			        WHEN cpm.CAT_IN_6   != '00000000' THEN cpm.CAT_IN_6
			        WHEN cpm.CAT_IN_5   != '00000000' THEN cpm.CAT_IN_5
			        WHEN cpm.CAT_IN_4   != '00000000' THEN cpm.CAT_IN_4
			        WHEN cpm.CAT_IN_3   != '00000000' THEN cpm.CAT_IN_3
			        WHEN cpm.CAT_IN_2   != '00000000' THEN cpm.CAT_IN_2
			        WHEN cpm.CAT_IN_1   != '00000000' THEN cpm.CAT_IN_1 ELSE '00000000' END
			 -- 마지막 제거일자
			 , CASE WHEN cpm.CAT_OUT_10 != '00000000' THEN cpm.CAT_OUT_10
			        WHEN cpm.CAT_OUT_9  != '00000000' THEN cpm.CAT_OUT_9
			        WHEN cpm.CAT_OUT_8  != '00000000' THEN cpm.CAT_OUT_8
			        WHEN cpm.CAT_OUT_7  != '00000000' THEN cpm.CAT_OUT_7
			        WHEN cpm.CAT_OUT_6  != '00000000' THEN cpm.CAT_OUT_6
			        WHEN cpm.CAT_OUT_5  != '00000000' THEN cpm.CAT_OUT_5
			        WHEN cpm.CAT_OUT_4  != '00000000' THEN cpm.CAT_OUT_4
			        WHEN cpm.CAT_OUT_3  != '00000000' THEN cpm.CAT_OUT_3
			        WHEN cpm.CAT_OUT_2  != '00000000' THEN cpm.CAT_OUT_2
			        WHEN cpm.CAT_OUT_1  != '00000000' THEN cpm.CAT_OUT_1 ELSE '00000000' END
	 	     -- 작성일자
	         , cpm.DOC_DT

	         -- 삽입,제거일자 10개 모두
	         , cpm.CAT_IN_1
	         , cpm.CAT_IN_2
	         , cpm.CAT_IN_3
	         , cpm.CAT_IN_4
	         , cpm.CAT_IN_5
	         , cpm.CAT_IN_6
	         , cpm.CAT_IN_7
	         , cpm.CAT_IN_8
	         , cpm.CAT_IN_9

	         , cpm.CAT_IN_10
	         , cpm.CAT_OUT_1
	         , cpm.CAT_OUT_2
	         , cpm.CAT_OUT_3
	         , cpm.CAT_OUT_4
	         , cpm.CAT_OUT_5
	         , cpm.CAT_OUT_6
	         , cpm.CAT_OUT_7
	         , cpm.CAT_OUT_8
	         , cpm.CAT_OUT_9
	         , cpm.CAT_OUT_10
	      INTO CmCathFlag
	         , CmNullFlag
	         , CmLastFlag
	         , CmLastDate
	         , CmLastInsD
	         , CmLastOutD
	         , CmDoc_Date

	         , In_Date_01
	         , In_Date_02
	         , In_Date_03
	         , In_Date_04
	         , In_Date_05
	         , In_Date_06
	         , In_Date_07
	         , In_Date_08
	         , In_Date_09
	         , In_Date_10

	         , OutDate_01
	         , OutDate_02
	         , OutDate_03
	         , OutDate_04
	         , OutDate_05
	         , OutDate_06
	         , OutDate_07
	         , OutDate_08
	         , OutDate_09
	         , OutDate_10
		  FROM TBL_PATVAL_MST cpm
		 WHERE cpm.HOSP_CD    = p_hostcd
		   AND cpm.CLFORM_VER = p_clform
		   AND cpm.PAT_ID     = p_pat_id
		   AND cpm.ADMIT_DT   = p_adm_dt
		   AND cpm.MED_START  = p_med_dt;



		SET Return_Val = 'N';

        --	1. 전월평가표에 유치도뇨관 삽입 in (0,1) 이고, 전월평가표에 삽입.제거가 모두 공란
        --     당월평가표에 유치도뇨관 삽입     = 1  이고, 당월평가표에 삽입.제거가 모두 공란
        --     **** 무조건 가져옴 (대상)
		IF  PmCathFlag IN ('0','1') AND PmNullFlag = 'Y' AND CmCathFlag = '1' AND CmNullFlag = 'Y' THEN
	        SET Return_Val = 'Y';
	    ELSE

--	        INSERT INTO data_log (log_message) VALUES (CONCAT('Select_Cnt : ',Select_Cnt, ' - ','CmLastFlag : ',CmLastFlag));

			-- 전월 Data가 없고, 당월 마지막이 제거일 경우 입원일자가 전월 1일 보다 크면 입원일자 아니면 전월 1일
			IF Select_Cnt = 0 THEN
			   -- 20250717 박혜련선임 요청 (라온힐 요양병원 서후석 환자 CASE 당월에 첫번째 삽입일자가 있으면 첫번째 삽입일자로 한다. )	
			   IF  In_Date_01 = '00000000' THEN 
			       /*  			
				   IF  p_adm_dt > CONCAT(DATE_FORMAT(DATE_SUB(CONCAT(LEFT(p_med_dt,6), '01'), INTERVAL 1 MONTH), '%Y%m'),'01') THEN
				       -- 당월 시작일자를 입원일자로 한다.
				       SET In_Date_01 = p_adm_dt;
				   ELSE
				       -- 당월 시작일자를 전월 1일로 한다.
				       SET In_Date_01 = CONCAT(DATE_FORMAT(DATE_SUB(CONCAT(LEFT(p_med_dt,6), '01'), INTERVAL 1 MONTH), '%Y%m'),'01');
				   END IF;
				   */
				   -- 20251121 박혜련선임 요청으로 위 내용 막음 ( IF ELSE END )
				   -- 20251121 박혜련선임 요청 당월 시작일자를 전월 1일로 한다.
				   SET In_Date_01 = CONCAT(DATE_FORMAT(DATE_SUB(CONCAT(LEFT(p_med_dt,6), '01'), INTERVAL 1 MONTH), '%Y%m'),'01');
				   
			   END IF;
			--  2. 전월평가표에 유치도뇨관 삽입 = 0, 전월평가표에 삽입.제거가 모두 공란
			--     당월평가표에 유치도뇨관 삽입 = 1
			--     당월평가표 첫번째 삽입일자는 공란이면 당월평가표 첫 시작일자 변경
	        ELSEIF PmCathFlag = '0' AND PmNullFlag = 'Y' AND CmCathFlag = '1' AND CmNullFlag = 'N' AND In_Date_01 = '00000000' THEN
                   -- 당월 시작일자를 전월 작성일자 + 1 로 한다.
                   -- 20261008 : 「PmDoc_Date + 1」 은 글자를 숫자로 더해 31일 다음이 32일이 된다(20260731 → 20260732) → STR_TO_DATE 가 죽어
                   --            자료생성 전체가 실패했다(강동우리들 9월 · 문수예). 아래 분기 3~6 과 같은 날짜 덧셈으로 바꿈.
                   SET In_Date_01 = DATE_FORMAT(DATE_ADD(STR_TO_DATE(PmDoc_Date,'%Y%m%d'), INTERVAL 1 DAY), '%Y%m%d'); -- 20251121일 박혜련선임 요청 (전월평가표 작성일자 + 1로 변경)
            --  3. 전월평가표에 유치도뇨관 삽입 = 1
		    --     당월평가표에 유치도뇨관 삽입 = 1
		    --     전월평가표에 마지막이 삽입일자의 값을 가질때 당월평가표 첫 시작일자 변경
	        ELSEIF PmCathFlag = '1' AND PmNullFlag = 'N' AND CmCathFlag = '1' AND CmNullFlag = 'N' AND PmLastFlag = '1' THEN
	               -- 당월 시작일자를 전월 마지막 삽입일자를 시작일자로 한다.
	               SET In_Date_01 = DATE_FORMAT(DATE_ADD(STR_TO_DATE(PmDoc_Date,'%Y%m%d'), INTERVAL 1 DAY), '%Y%m%d');
	        --  4. 전월평가표에 유치도뇨관 삽입 = 1
		    --     당월평가표에 유치도뇨관 삽입 = 1
		    --     전월평가표에 마지막이 제거일자의 값을 가질때 당월평가표 첫 시작일자 변경
	        ELSEIF PmCathFlag = '1' AND PmNullFlag = 'N' AND CmCathFlag = '1' AND CmNullFlag = 'N' AND PmLastFlag = '2' AND In_Date_01 = '00000000' THEN
	               -- 당월 시작일자를 전월 마지막 삽입일자를 시작일자로 한다.
	               SET In_Date_01 = DATE_FORMAT(DATE_ADD(STR_TO_DATE(PmDoc_Date,'%Y%m%d'), INTERVAL 1 DAY), '%Y%m%d');
	        ELSEIF PmCathFlag = '1' AND PmNullFlag = 'N' AND PmLastFlag = '1' AND PmLastInsD != '00000000' AND CmCathFlag = '1' AND CmNullFlag = 'Y'  THEN
	               -- 당월 시작일자를 전월 마지막 삽입일자를 시작일자로 한다.
	               SET In_Date_01 = DATE_FORMAT(DATE_ADD(STR_TO_DATE(PmDoc_Date,'%Y%m%d'), INTERVAL 1 DAY), '%Y%m%d');
	        ELSEIF PmCathFlag = '1' AND PmNullFlag = 'N' AND PmLastFlag = '1' AND PmLastInsD != '00000000' AND CmCathFlag = '1' AND CmNullFlag = 'N'  THEN
	               -- 당월 시작일자를 전월 마지막 삽입일자를 시작일자로 한다.
	               SET In_Date_01 = DATE_FORMAT(DATE_ADD(STR_TO_DATE(PmDoc_Date,'%Y%m%d'), INTERVAL 1 DAY), '%Y%m%d');
	        END IF;

			-- 연속여부 CHECK
			-- 두번째 제거일자에서 삽입일자가 1일 이면 연속일자로
			-- 제거일자에서 삽입일자가 2일 이면 연속일자로 보지않는다.

			IF  OutDate_01 = '00000000' THEN
			    SET OutDate_01 = CmDoc_Date;
			END IF;


			-- 첫 삽입일을 찾기
		    SET i = 1;
		    WHILE i <= 10 DO
		        SET in_dates = CASE i
		            WHEN 1 THEN In_Date_01
		            WHEN 2 THEN In_Date_02
		            WHEN 3 THEN In_Date_03
		            WHEN 4 THEN In_Date_04
		            WHEN 5 THEN In_Date_05
		            WHEN 6 THEN In_Date_06
		            WHEN 7 THEN In_Date_07
		            WHEN 8 THEN In_Date_08
		            WHEN 9 THEN In_Date_09
		            WHEN 10 THEN In_Date_10
		        END;

		        IF in_dates != '00000000' THEN
		            SET cur_ins_dt = STR_TO_DATE(in_dates, '%Y%m%d');
		            SET i = 10;
		        END IF;

		        SET i = i + 1;

		    END WHILE;
          --   시작일(첫 삽입일)이 입원일자보다 이르면 입원일자로 올린다.
          IF cur_ins_dt IS NOT NULL
             AND IFNULL(p_adm_dt,'') <> '' AND p_adm_dt <> '00000000'
             AND cur_ins_dt < STR_TO_DATE(p_adm_dt, '%Y%m%d') THEN
             SET cur_ins_dt = STR_TO_DATE(p_adm_dt, '%Y%m%d');
          END IF;
         
		    SET i = 1;
		    -- 제거일자 루프
		    WHILE i <= 10 DO

		        SET out_date = CASE i
		            WHEN 1  THEN CASE WHEN in_dates != '00000000' AND OutDate_01 = '00000000' THEN CmDoc_Date ELSE OutDate_01 END
		            WHEN 2  THEN CASE WHEN in_dates != '00000000' AND OutDate_02 = '00000000' THEN CmDoc_Date ELSE OutDate_02 END
		            WHEN 3  THEN CASE WHEN in_dates != '00000000' AND OutDate_03 = '00000000' THEN CmDoc_Date ELSE OutDate_03 END
		            WHEN 4  THEN CASE WHEN in_dates != '00000000' AND OutDate_04 = '00000000' THEN CmDoc_Date ELSE OutDate_04 END
		            WHEN 5  THEN CASE WHEN in_dates != '00000000' AND OutDate_05 = '00000000' THEN CmDoc_Date ELSE OutDate_05 END
		            WHEN 6  THEN CASE WHEN in_dates != '00000000' AND OutDate_06 = '00000000' THEN CmDoc_Date ELSE OutDate_06 END
		            WHEN 7  THEN CASE WHEN in_dates != '00000000' AND OutDate_07 = '00000000' THEN CmDoc_Date ELSE OutDate_07 END
		            WHEN 8  THEN CASE WHEN in_dates != '00000000' AND OutDate_08 = '00000000' THEN CmDoc_Date ELSE OutDate_08 END
		            WHEN 9  THEN CASE WHEN in_dates != '00000000' AND OutDate_09 = '00000000' THEN CmDoc_Date ELSE OutDate_09 END
		            WHEN 10 THEN CASE WHEN in_dates != '00000000' AND OutDate_10 = '00000000' THEN CmDoc_Date ELSE OutDate_10 END
		        END;

		        IF out_date != '00000000' THEN
		            SET cur_out_dt = STR_TO_DATE(out_date, '%Y%m%d');
		            SET day_diff = DATEDIFF(cur_out_dt, cur_ins_dt);

		            IF day_diff >= 14 THEN
		                SET Return_Val = 'Y';
		                SET i = 10;
		            END IF;

		        END IF;

		        -- 다음 삽입일자
		        SET in_dates = CASE i + 1
		            WHEN 1  THEN In_Date_01
		            WHEN 2  THEN In_Date_02
		            WHEN 3  THEN In_Date_03
		            WHEN 4  THEN In_Date_04
		            WHEN 5  THEN In_Date_05
		            WHEN 6  THEN In_Date_06
		            WHEN 7  THEN In_Date_07
		            WHEN 8  THEN In_Date_08
		            WHEN 9  THEN In_Date_09
		            WHEN 10 THEN In_Date_10
		            WHEN 11 THEN In_Date_10
		        END;

		        IF in_dates != '00000000' THEN

		            SET next_ins_dt = STR_TO_DATE(in_dates, '%Y%m%d');

		            IF DATEDIFF(next_ins_dt, cur_out_dt) > 1 THEN
		                SET cur_ins_dt = next_ins_dt;
		            END IF;
		        END IF;

		        SET i = i + 1;

		    END WHILE;


		END IF;

    END IF;

    RETURN Return_Val;

END
$$
DELIMITER ;
