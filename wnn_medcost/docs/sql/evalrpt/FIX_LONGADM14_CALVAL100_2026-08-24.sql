/* ============================================================================
   [과거 자료 보정] 장기입원 환자분율(14) — 181일 이상 0명인데 현황값 100%
   2026-08-24
   ----------------------------------------------------------------------------
   대상 : TBL_PAT_INDI  CATE_CD='14' AND DTORVAL>0 AND NTORVAL=0 AND CAL_VAL=100.00
          = 26건 · 10개 병원 · 202407~202612 (2026-08-24 기준)
          예) 평택삼성요양병원 202509·202510·202511·202512·202606·202607·202608 …

   바꾸는 것은 CAL_VAL(현황값) 100.00 → 0.00  <한 컬럼뿐>.
   S_SCORE(5) · WEIGVAL(=STDWEIG) · MAX_VAL(5) 은 이미 맞다(26건 전부 확인).
   14 의 5점 구간이 0.00~19.99 이므로 0% 도 그대로 5점 — 점수 변동 없음.

   ★프로시저·함수를 먼저 적용할 것. 안 그러면 자료 재생성 때 100 으로 되돌아간다.
     · docs/sql/proc/SP_EVALUATION_INDICATORS_REGISTER_2026-08-24.sql
     · docs/sql/proc/FN_EVALUATION_INDICATORS_VALUE_2026-08-24.sql
   ============================================================================ */

/* 0) 변경 전 확인 ---------------------------------------------------------- */
SELECT HOSP_CD, JOBYYMM, STRYYMM, ENDYYMM, DTORVAL, NTORVAL, CAL_VAL, S_SCORE, STDWEIG, WEIGVAL
  FROM TBL_PAT_INDI
 WHERE CATE_CD = '14' AND DTORVAL > 0 AND NTORVAL = 0 AND CAL_VAL = 100.00
 ORDER BY HOSP_CD, JOBYYMM;

/* 1) 원본 백업 (되돌리려면 이 표에서 CAL_VAL 을 다시 써 넣으면 된다) ------- */
DROP TABLE IF EXISTS TBL_PAT_INDI_BAK_LONGADM14_20260824;
CREATE TABLE TBL_PAT_INDI_BAK_LONGADM14_20260824 AS
SELECT *
  FROM TBL_PAT_INDI
 WHERE CATE_CD = '14' AND DTORVAL > 0 AND NTORVAL = 0 AND CAL_VAL = 100.00;

SELECT COUNT(*) AS backup_cnt FROM TBL_PAT_INDI_BAK_LONGADM14_20260824;   -- 26 이어야 한다

/* 2) 보정 ------------------------------------------------------------------ */
UPDATE TBL_PAT_INDI
   SET CAL_VAL  = 0.00
     , UPD_USER = 'fix20260824'
 WHERE CATE_CD = '14' AND DTORVAL > 0 AND NTORVAL = 0 AND CAL_VAL = 100.00;

/* 3) 검증 ------------------------------------------------------------------ */
--  잔여 0건 이어야 한다
SELECT COUNT(*) AS remain
  FROM TBL_PAT_INDI
 WHERE CATE_CD = '14' AND DTORVAL > 0 AND NTORVAL = 0 AND CAL_VAL = 100.00;

--  보정된 행 — CAL_VAL 0.00 · S_SCORE 5 · WEIGVAL=STDWEIG 유지
SELECT HOSP_CD, JOBYYMM, DTORVAL, NTORVAL, CAL_VAL, S_SCORE, STDWEIG, WEIGVAL
  FROM TBL_PAT_INDI
 WHERE UPD_USER = 'fix20260824' AND CATE_CD = '14'
 ORDER BY HOSP_CD, JOBYYMM;

/* 4) 원복이 필요하면 — 아래 블록의 주석을 풀고 실행 (PK = HOSP_CD, JOBYYMM, CATE_CD) */
/*
UPDATE TBL_PAT_INDI p
  JOIN TBL_PAT_INDI_BAK_LONGADM14_20260824 b
    ON b.HOSP_CD = p.HOSP_CD AND b.JOBYYMM = p.JOBYYMM AND b.CATE_CD = p.CATE_CD
   SET p.CAL_VAL = b.CAL_VAL, p.UPD_USER = b.UPD_USER;
*/
