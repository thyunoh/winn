-- =====================================================================================
-- 부산은빛요양병원(21281238) 2026-10 환자평가표에 섞인 «다른 병원(목포더좋은요양병원 36283231) 자료» 204건 삭제
-- 작성 2026-10-28 · ⛔실행은 사용자가 운영 DB 에서 직접 (①→②→③→④ 차례로, 각 단계 결과 확인)
--
-- 실측(운영 읽기) : 21281238 의 10월 평가표 387건이 전부 작업-KEY 20261027143135 하나에 묶여 있다.
--   · 2026-10-27 15:58:42 등록 204건 = 목포더좋은요양병원 환자 — 204건 모두 36283231 에 같은 환자·입원일·요양개시일 행이 있고,
--     21281238 의 9월 평가표·입퇴원 기록에는 한 명도 없다.
--     (같은 시각 15:58 에 admin 이 목포 파일 36283231_202610.L01(204건)을 올렸고, 15:59:14 에 목포 병원으로 다시 올림)
--   · 2026-10-27 15:58:56 등록 183건 = 부산은빛 본래 자료(9월 평가표에 175명 있음) — 이건 그대로 둔다.
-- 목록에서 L02 를 지워도 안 빠진 이유 : 섞인 204건이 L02(20261027112354)가 아니라 L05 의 작업-KEY(20261027143135)를 달고 있어서다.
--   L05 를 지우면 부산은빛 183건까지 함께 지워진다 → 등록 시각으로 204건만 골라 지운다.
-- 딸린 자료 : 평가표를 가리키는 표 없음. ⚠삭제 뒤 21281238 2026-10 「월 자료생성」을 했었다면 다시 돌려야 지표(TBL_PAT_INDI)에 반영된다.
-- =====================================================================================

-- ① 확인 : A204 = 204 · B183 = 183 이어야 한다
SELECT CASE WHEN p.REG_DTTM = '2026-10-27 15:58:42' THEN 'A204 목포(지울 것)' ELSE 'B183 부산은빛(남길 것)' END AS grp,
       COUNT(*) AS n,
       SUM(EXISTS(SELECT 1 FROM TBL_PATVAL_MST o
                   WHERE o.HOSP_CD = '36283231' AND o.PAT_ID = p.PAT_ID
                     AND o.ADMIT_DT = p.ADMIT_DT AND o.MED_START = p.MED_START)) AS in_mokpo
  FROM TBL_PATVAL_MST p
 WHERE p.HOSP_CD = '21281238' AND p.CHUNGSEQ = '20261027143135'
 GROUP BY 1;

-- ② 백업 (되돌리기용) — LIKE + INSERT
CREATE TABLE TBL_PATVAL_MST_BAK_20261028_BSEB LIKE TBL_PATVAL_MST;
INSERT INTO TBL_PATVAL_MST_BAK_20261028_BSEB
SELECT p.* FROM TBL_PATVAL_MST p
 WHERE p.HOSP_CD = '21281238' AND p.CHUNGSEQ = '20261027143135'
   AND p.REG_DTTM = '2026-10-27 15:58:42'
   AND EXISTS (SELECT 1 FROM TBL_PATVAL_MST o
                WHERE o.HOSP_CD = '36283231' AND o.PAT_ID = p.PAT_ID
                  AND o.ADMIT_DT = p.ADMIT_DT AND o.MED_START = p.MED_START);

SELECT COUNT(*) AS backup_rows FROM TBL_PATVAL_MST_BAK_20261028_BSEB;   -- 204 이어야 한다

-- ③ 삭제 — 백업 표에 있는 줄만(기본키 5개로 맞춤). 영향 행 수 204 확인.
DELETE p FROM TBL_PATVAL_MST p
  JOIN TBL_PATVAL_MST_BAK_20261028_BSEB b
    ON b.HOSP_CD = p.HOSP_CD AND b.CLFORM_VER = p.CLFORM_VER AND b.PAT_ID = p.PAT_ID
   AND b.ADMIT_DT = p.ADMIT_DT AND b.MED_START = p.MED_START
 WHERE p.HOSP_CD = '21281238';

-- ④ 결과 확인 — 21281238 10월 = 183건 · 목포(36283231) 10월 = 204건 그대로
SELECT HOSP_CD, CHUNGSEQ, COUNT(*) AS n
  FROM TBL_PATVAL_MST
 WHERE HOSP_CD IN ('21281238','36283231') AND MED_START LIKE '202610%'
 GROUP BY HOSP_CD, CHUNGSEQ;

-- 되돌리기 (필요할 때만)
-- INSERT INTO TBL_PATVAL_MST SELECT * FROM TBL_PATVAL_MST_BAK_20261028_BSEB;
-- 확인이 끝나면 : DROP TABLE TBL_PATVAL_MST_BAK_20261028_BSEB;
