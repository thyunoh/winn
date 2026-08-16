-- =====================================================================
--  PATIENT_CATHETER_CHECK 재생성 (실행용) — 2026-07-14 branch 3 수정 반영
--
--  내용 : 2026-07-14 사용자 제공 현행 소스 전체 + branch 3 만 교체
--         (배경/사례/검증쿼리는 PATIENT_CATHETER_CHECK_fix_20260714.sql 참조)
--
--  ★실행 전 백업(필수): 아래 결과를 파일로 저장해 둘 것 (원복용)
--      SHOW CREATE FUNCTION PATIENT_CATHETER_CHECK\G
--
--  ★실행 후(필수):
--    ① 주원* 461119 확인 — 우측 오류점검 그리드 '14일초과' 해당 → 사라져야 함
--    ② "적정성평가 월 자료생성" 재실행 (좌측 05번 분모/분자 저장값 갱신)
--
--  ※ 파라미터 선언 타입은 넉넉한 VARCHAR 로 재선언 — 백업의 SHOW CREATE 와
--    타입이 다르면 백업 쪽 선언을 그대로 쓰고 본문만 교체해도 됨.
-- =====================================================================

DROP FUNCTION IF EXISTS PATIENT_CATHETER_CHECK;

DELIMITER $$

CREATE FUNCTION PATIENT_CATHETER_CHECK(
    p_hostcd VARCHAR(20),
    p_clform VARCHAR(20),
    p_pat_id VARCHAR(50),
    p_adm_dt VARCHAR(8),
    p_med_dt VARCHAR(8),
    p_evalfg VARCHAR(2),
    p_cathfg VARCHAR(2),
    p_pclass VARCHAR(10)
) RETURNS VARCHAR(1)
READS SQL DATA
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
           AND ppm.MED_START  LIKE CONCAT(DATE_FORMAT(DATE_SUB(CONCAT(LEFT(p_med_dt,6), '01'), INTERVAL 1 MONTH), '%Y%m'),'%')
           AND ppm.DOC_DT = ( SELECT MAX(c.DOC_DT)
                                FROM TBL_PATVAL_MST c
                               WHERE c.HOSP_CD    = ppm.HOSP_CD
                                 AND c.CLFORM_VER = ppm.CLFORM_VER
                                 AND c.MED_START  = ppm.MED_START
                                 AND c.PAT_ID     = ppm.PAT_ID )
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

        --  1. 전월평가표에 유치도뇨관 삽입 in (0,1) 이고, 전월평가표에 삽입.제거가 모두 공란
        --     당월평가표에 유치도뇨관 삽입     = 1  이고, 당월평가표에 삽입.제거가 모두 공란
        --     **** 무조건 가져옴 (대상)
        IF  PmCathFlag IN ('0','1') AND PmNullFlag = 'Y' AND CmCathFlag = '1' AND CmNullFlag = 'Y' THEN
            SET Return_Val = 'Y';
        ELSE

            -- 전월 Data가 없고, 당월 마지막이 제거일 경우 입원일자가 전월 1일 보다 크면 입원일자 아니면 전월 1일
            IF Select_Cnt = 0 THEN
               -- 20250717 박혜련선임 요청 (라온힐 요양병원 서후석 환자 CASE 당월에 첫번째 삽입일자가 있으면 첫번째 삽입일자로 한다. )
               IF  In_Date_01 = '00000000' THEN
                   -- 20251121 박혜련선임 요청 당월 시작일자를 전월 1일로 한다.
                   SET In_Date_01 = CONCAT(DATE_FORMAT(DATE_SUB(CONCAT(LEFT(p_med_dt,6), '01'), INTERVAL 1 MONTH), '%Y%m'),'01');
               END IF;
            --  2. 전월평가표에 유치도뇨관 삽입 = 0, 전월평가표에 삽입.제거가 모두 공란
            --     당월평가표에 유치도뇨관 삽입 = 1
            --     당월평가표 첫번째 삽입일자는 공란이면 당월평가표 첫 시작일자 변경
            ELSEIF PmCathFlag = '0' AND PmNullFlag = 'Y' AND CmCathFlag = '1' AND CmNullFlag = 'N' AND In_Date_01 = '00000000' THEN
                   -- 당월 시작일자를 전월 작성일자로 한다.
                   SET In_Date_01 = PmDoc_Date + 1; -- 20251121일 박혜련선임 요청 (전월평가표 작성일자 + 1로 변경)
            --  3. 전월평가표에 유치도뇨관 삽입 = 1
            --     당월평가표에 유치도뇨관 삽입 = 1
            --     전월평가표에 마지막이 삽입일자의 값을 가질때 당월평가표 첫 시작일자 변경
            --     [수정 2026-07-14] 이월 기산 하한 = 전월 작성일+1 을 '덮어쓰기'가 아니라 'GREATEST(하한)'으로 적용.
            --       - 당월 첫 삽입일 공란 → 전월작성일+1 (7/11 패치 의도 그대로)
            --       - 기재일 > 전월작성일+1 (신규 재삽입, 주원* 6/21) → 기재일 유지
            --       - 기재일 < 전월작성일+1 (이월 삽입일 재기재, 정양* 5/26 류) → 하한 적용(더블카운트 차단)
            ELSEIF PmCathFlag = '1' AND PmNullFlag = 'N' AND CmCathFlag = '1' AND CmNullFlag = 'N' AND PmLastFlag = '1' THEN
                   IF In_Date_01 = '00000000' THEN
                       SET In_Date_01 = DATE_FORMAT(DATE_ADD(STR_TO_DATE(PmDoc_Date,'%Y%m%d'), INTERVAL 1 DAY), '%Y%m%d');
                   ELSE
                       SET In_Date_01 = GREATEST(In_Date_01,
                                        DATE_FORMAT(DATE_ADD(STR_TO_DATE(PmDoc_Date,'%Y%m%d'), INTERVAL 1 DAY), '%Y%m%d'));
                   END IF;
            --  4. 전월평가표에 유치도뇨관 삽입 = 1
            --     당월평가표에 유치도뇨관 삽입 = 1
            --     전월평가표에 마지막이 제거일자의 값을 가질때 당월평가표 첫 시작일자 변경
            ELSEIF PmCathFlag = '1' AND PmNullFlag = 'N' AND CmCathFlag = '1' AND CmNullFlag = 'N' AND PmLastFlag = '2' AND In_Date_01 = '00000000' THEN
                   SET In_Date_01 = DATE_FORMAT(DATE_ADD(STR_TO_DATE(PmDoc_Date,'%Y%m%d'), INTERVAL 1 DAY), '%Y%m%d');
            ELSEIF PmCathFlag = '1' AND PmNullFlag = 'N' AND PmLastFlag = '1' AND PmLastInsD != '00000000' AND CmCathFlag = '1' AND CmNullFlag = 'Y'  THEN
                   SET In_Date_01 = DATE_FORMAT(DATE_ADD(STR_TO_DATE(PmDoc_Date,'%Y%m%d'), INTERVAL 1 DAY), '%Y%m%d');
            ELSEIF PmCathFlag = '1' AND PmNullFlag = 'N' AND PmLastFlag = '1' AND PmLastInsD != '00000000' AND CmCathFlag = '1' AND CmNullFlag = 'N'  THEN
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

END$$

DELIMITER ;


-- =====================================================================
-- [적용 후 확인]
-- ① 주원* 461119 즉시 확인 (우측 그리드와 동일한 호출):
--
-- SELECT PATIENT_CATHETER_CHECK(c.HOSP_CD, c.CLFORM_VER, c.PAT_ID, c.ADMIT_DT,
--                               c.MED_START, c.EVAL_TYPE, c.INDWELL_CATH, c.PAT_CLASS) AS chk
--   FROM TBL_PATVAL_MST c
--  WHERE c.HOSP_CD = '해당병원'
--    AND c.PAT_ID LIKE '461119%'
--    AND c.ADMIT_DT = '20230728'
--    AND c.MED_START = '20260701';
--   → 기대값 'N'
--
-- ② "적정성평가 월 자료생성" 재실행 → 좌측 05번 지표 분자 갱신 확인
-- =====================================================================
