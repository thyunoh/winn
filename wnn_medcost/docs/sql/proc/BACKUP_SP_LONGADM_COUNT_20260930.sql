-- 백업 : SP_LONGADM_COUNT 운영 원본 (2026-09-30 조회). 그대로 실행하면 원복.
DROP PROCEDURE IF EXISTS SP_LONGADM_COUNT;
DELIMITER $$
CREATE DEFINER=`winner`@`%` PROCEDURE `SP_LONGADM_COUNT`(
	IN `p_hosp_cd` VARCHAR(20),
	IN `p_start_month` VARCHAR(6),
	IN `p_end_month` VARCHAR(6),
	OUT `p_dtorvalue` INT,
	OUT `p_ntorvalue` INT
)
    COMMENT '입원환자 180이상입원대상 중중 한번이럳ㅎ 있으면 제외체크  '
BEGIN
    DECLARE v_mm          VARCHAR(6);
    DECLARE v_range_start VARCHAR(6);
    DECLARE v_month_cnt   INT;
    DECLARE v_idx         INT DEFAULT 0;

    SET v_month_cnt = PERIOD_DIFF(p_end_month, p_start_month);

    /* ★ 임시테이블: 월별 결과 누적 */
    DROP TEMPORARY TABLE IF EXISTS TMP_HALF_RESULT;
    CREATE TEMPORARY TABLE TMP_HALF_RESULT (
        patId    VARCHAR(6),
        admitDt  VARCHAR(8),
        longAdm  VARCHAR(1)
    );

    /* ★ 시작월 ~ 종료월 루프 */
    WHILE v_idx <= v_month_cnt DO
        SET v_mm = DATE_FORMAT(DATE_ADD(STR_TO_DATE(CONCAT(p_start_month,'01'),'%Y%m%d'), INTERVAL v_idx MONTH),'%Y%m');
        SET v_range_start = CASE WHEN CAST(SUBSTRING(v_mm,5,2) AS UNSIGNED) <= 6
                                 THEN v_mm
                                 ELSE CONCAT(SUBSTRING(v_mm,1,4),'07')
                            END;

        INSERT INTO TMP_HALF_RESULT (patId, admitDt, longAdm)
        SELECT DISTINCT
               LEFT(pm2.PAT_ID,6) AS patId
             , pm2.ADMIT_DT       AS admitDt
             , CASE
                   WHEN LEFT(IFNULL(pm2.PAT_CLASS, PATIENT_CLASSIFICATION(pm2.HOSP_CD, pm2.PAT_ID, pm2.CHUNGSEQ, pm2.CLFORM_VER, pm2.ADMIT_DT, pm2.MED_START)),1) IN ('D','E')
                    AND (
                        DATEDIFF(COALESCE(ii.TEWONDT, DATE_FORMAT(pm2.DOC_DT,'%Y%m%d')), DATE_FORMAT(pm2.ADMIT_DT,'%Y%m%d')) + 1 >= 181
                        OR EXISTS (
                            SELECT 1 FROM TBL_IPWON_INFO prev_ii
                             WHERE prev_ii.HOSP_CD = pm2.HOSP_CD
                               AND LEFT(prev_ii.JUMINNO,6) = LEFT(pm2.PAT_ID,6)
                               AND prev_ii.PATNAME = REGEXP_REPLACE(pm2.PAT_NM,'[0-9]','')
                               AND COALESCE(prev_ii.TEWONDT,'') != ''
                               AND REPLACE(prev_ii.TEWONDT,'-','') < REPLACE(pm2.ADMIT_DT,'-','')
                               AND DATEDIFF(
                                       STR_TO_DATE(REPLACE(COALESCE(ii.TEWONDT, DATE_FORMAT(pm2.DOC_DT,'%Y%m%d')),'-',''),'%Y%m%d'),
                                       CASE WHEN LEFT(REPLACE(prev_ii.IPWONDT,'-',''),4) < LEFT(pm2.ADMIT_DT,4)
                                            THEN STR_TO_DATE(CONCAT(LEFT(pm2.ADMIT_DT,4),'0101'),'%Y%m%d')
                                            ELSE STR_TO_DATE(REPLACE(prev_ii.IPWONDT,'-',''),'%Y%m%d')
                                       END) + 1 >= 181
                        )
                        /* ★ (추가) 장기입원 입원료: TBL_JINORD_MST ITEM_NO=02, EDI_CODE 6~8자리 IN(300,400,500) — 해당월(v_mm) 청구 */
                        OR EXISTS (
                            SELECT 1
                              FROM TBL_MYOUNG_MST  mm
                              JOIN TBL_CHUNG_MST   cm ON cm.HOSP_CD = mm.HOSP_CD AND cm.CLAIM_NO = mm.CLAIM_NO
                              JOIN TBL_JINORD_MST  jm ON jm.HOSP_CD = mm.HOSP_CD AND jm.CLAIM_NO = mm.CLAIM_NO AND jm.BILL_SEQ = mm.BILL_SEQ
                             WHERE mm.HOSP_CD = pm2.HOSP_CD
                               AND mm.PAT_ID  = pm2.PAT_ID
                               AND COALESCE(mm.DELYN,'') = ''
                               AND cm.DATE_YM = v_mm
                               AND jm.ITEM_NO = '02'
                               AND SUBSTRING(jm.EDI_CODE,6,3) IN ('300','400','500')
                        )
                    )
                   THEN 'Y' ELSE ''
               END AS longAdm
          FROM TBL_PATVAL_MST pm2
          LEFT JOIN TBL_IPWON_INFO ii
                 ON ii.HOSP_CD  = pm2.HOSP_CD
                AND ii.JOBYYMM BETWEEN v_range_start AND v_mm
                AND LEFT(ii.JUMINNO,6)         = LEFT(pm2.PAT_ID,6)
                AND REPLACE(ii.IPWONDT,'-','') = pm2.ADMIT_DT
                AND COALESCE(ii.TEWONDT,'')   != ''
                AND v_mm >= LEFT(REPLACE(ii.TEWONDT,'-',''),6)
                AND pm2.PAT_NM = REGEXP_REPLACE(ii.PATNAME,'[0-9]','')
         WHERE pm2.HOSP_CD = p_hosp_cd
           AND pm2.MED_START BETWEEN CONCAT(v_range_start,'01') AND CONCAT(v_mm,'31')
           AND IFNULL(pm2.PAT_CLASS, PATIENT_CLASSIFICATION(pm2.HOSP_CD, pm2.PAT_ID, pm2.CHUNGSEQ, pm2.CLFORM_VER, pm2.ADMIT_DT, pm2.MED_START)) != 'A31'
           AND pm2.PAT_ID IN (
                   SELECT pm1.PAT_ID
                     FROM TBL_PATVAL_MST pm1
                    WHERE pm1.HOSP_CD = p_hosp_cd
                      AND pm1.MED_START BETWEEN CONCAT(v_range_start,'01') AND CONCAT(v_mm,'31')
                    GROUP BY pm1.PAT_ID
                   HAVING SUM(CASE WHEN LEFT(IFNULL(pm1.PAT_CLASS, PATIENT_CLASSIFICATION(pm1.HOSP_CD, pm1.PAT_ID, pm1.CHUNGSEQ, pm1.CLFORM_VER, pm1.ADMIT_DT, pm1.MED_START)),1) NOT IN ('D','E') THEN 1 ELSE 0 END) = 0
                      AND SUM(CASE WHEN IFNULL(pm1.PAT_CLASS, PATIENT_CLASSIFICATION(pm1.HOSP_CD, pm1.PAT_ID, pm1.CHUNGSEQ, pm1.CLFORM_VER, pm1.ADMIT_DT, pm1.MED_START)) = 'A31' THEN 1 ELSE 0 END) = 0
               )
           /* ★ A01/A02/A03 환자 제외 */
           AND NOT EXISTS (
               SELECT 1 FROM TBL_PATVAL_MST excl
                WHERE excl.HOSP_CD        = p_hosp_cd
                  AND LEFT(excl.PAT_ID,6) = LEFT(pm2.PAT_ID,6)
                  AND excl.PAT_NM         = pm2.PAT_NM
                  AND excl.MED_START BETWEEN CONCAT(p_start_month,'01') AND CONCAT(p_end_month,'31')
                  AND (excl.PAT_CLASS LIKE 'A%' OR excl.PAT_CLASS LIKE 'B%' OR excl.PAT_CLASS LIKE 'C%')
           );

        SET v_idx = v_idx + 1;
    END WHILE;

    /* ★ 최종 집계 */
    SELECT COUNT(*)
         , SUM(CASE WHEN longAdm = 'Y' THEN 1 ELSE 0 END)
      INTO p_dtorvalue
         , p_ntorvalue
      FROM (
        SELECT patId
             , admitDt
             , MAX(longAdm) AS longAdm
          FROM TMP_HALF_RESULT
         GROUP BY patId, admitDt
      ) d;

    DROP TEMPORARY TABLE IF EXISTS TMP_HALF_RESULT;
END$$
DELIMITER ;
