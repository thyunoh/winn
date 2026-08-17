/* ======================================================================
   약사 재직일수율(04) — **차등제 미신고 분기에 1.1점이 붙은 과거 자료** 보정
   (2026-08-17. 원인·수정은 docs/sql/proc/SP_INDICATORS_STRUCTURE_ZONE_2026-08-17.sql)

   ⛔⛔ 이 스크립트는 **과거 월의 점수를 내리는 변경**이다(1.1점 → 0점).
        이미 병원에 나간 월간보고서의 종합점수와 달라지므로 ***돌리기 전에 확인이 필요***하다.
        프로시저 수정만으로는 **이미 쌓인 값이 안 고쳐진다** — 해당 월을 다시
        「적정성평가 월 자료생성」 하거나 이 스크립트를 돌려야 한다.

   [대상] TBL_PAT_INDI 의 CATE_CD='04' 행 중
            · 분모>0 · 분자=0 · 가중치점수>0   (= 0% 로 1구간 1.1점이 붙은 것)
            · 그 달이 속한 분기의 TBL_GRADE_MST 신고 행이 **없음**
          ★신고했는데 약사재직일수만 0 인 달은 **건드리지 않는다**(0%는 사실값 → 1구간이 맞다).

   [실측 2026-08-17] 182건 · 66개 병원 · 202401~202612 · 잘못 부여된 점수 합 200.20
   ====================================================================== */

/* ── ① 먼저 무엇이 바뀌는지 본다(조회 전용) ───────────────────────────── */
SELECT P.HOSP_CD, P.JOBYYMM, P.DTORVAL, P.NTORVAL, P.WEIGVAL, P.S_SCORE
  FROM TBL_PAT_INDI P
 WHERE P.CATE_CD='04' AND P.DTORVAL>0 AND P.NTORVAL=0 AND P.WEIGVAL>0
   AND NOT EXISTS (SELECT 1 FROM TBL_GRADE_MST G
                    WHERE G.HOSP_CD=P.HOSP_CD AND G.START_YY=LEFT(P.JOBYYMM,4)
                      AND G.ACTION_YN='Y'
                      AND G.QTER_FLAG = CASE WHEN RIGHT(P.JOBYYMM,2) IN ('01','02','03') THEN '1'
                                             WHEN RIGHT(P.JOBYYMM,2) IN ('04','05','06') THEN '2'
                                             WHEN RIGHT(P.JOBYYMM,2) IN ('07','08','09') THEN '3'
                                             ELSE '4' END)
 ORDER BY P.HOSP_CD, P.JOBYYMM;

/* ── ② 보정 — ①의 결과를 확인한 뒤에만 실행 ──────────────────────────
      다른 구조영역 지표(01~03)의 미신고 상태와 똑같은 모양으로 맞춘다. */
UPDATE TBL_PAT_INDI P
   SET P.DTORVAL = 0, P.NTORVAL = 0, P.CAL_VAL = 0, P.WEIGVAL = 0, P.S_SCORE = 0,
       P.UPD_USER = 'fix20260817'
 WHERE P.CATE_CD='04' AND P.DTORVAL>0 AND P.NTORVAL=0 AND P.WEIGVAL>0
   AND NOT EXISTS (SELECT 1 FROM TBL_GRADE_MST G
                    WHERE G.HOSP_CD=P.HOSP_CD AND G.START_YY=LEFT(P.JOBYYMM,4)
                      AND G.ACTION_YN='Y'
                      AND G.QTER_FLAG = CASE WHEN RIGHT(P.JOBYYMM,2) IN ('01','02','03') THEN '1'
                                             WHEN RIGHT(P.JOBYYMM,2) IN ('04','05','06') THEN '2'
                                             WHEN RIGHT(P.JOBYYMM,2) IN ('07','08','09') THEN '3'
                                             ELSE '4' END);

/* ── ③ 남은 게 없는지 확인 ──────────────────────────────────────────── */
SELECT COUNT(*) AS 남은건수
  FROM TBL_PAT_INDI P
 WHERE P.CATE_CD='04' AND P.DTORVAL>0 AND P.NTORVAL=0 AND P.WEIGVAL>0
   AND NOT EXISTS (SELECT 1 FROM TBL_GRADE_MST G
                    WHERE G.HOSP_CD=P.HOSP_CD AND G.START_YY=LEFT(P.JOBYYMM,4)
                      AND G.ACTION_YN='Y'
                      AND G.QTER_FLAG = CASE WHEN RIGHT(P.JOBYYMM,2) IN ('01','02','03') THEN '1'
                                             WHEN RIGHT(P.JOBYYMM,2) IN ('04','05','06') THEN '2'
                                             WHEN RIGHT(P.JOBYYMM,2) IN ('07','08','09') THEN '3'
                                             ELSE '4' END);
