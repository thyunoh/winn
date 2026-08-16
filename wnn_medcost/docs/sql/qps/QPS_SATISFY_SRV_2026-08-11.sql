-- ═══════════════════════════════════════════════════════════════════════════
-- 지표 SATISFY(환자만족도) — 수기입력(MANUAL) → 설문 자동집계(SRV) 전환
--   2026-08-11 · CLAIM 을 처리대장 자동집계로 돌린 것과 같은 방식이다.
--
-- 왜 :
--   설문 응답이 이미 TBL_QPS_SURVEY_ANS / _ITEM 에 들어 있는데,
--   병원이 그 결과를 보고 지표 화면에 월별로 **또** 적고 있었다. 같은 것을 두 번 적는다.
--   숫자가 갈리면 어느 쪽이 맞는지도 알 수 없다.
--
-- 산식 (조사결과·지표분석 보고서의 selectSrvStatTotal 과 **같은 식**) :
--   분자 = SUM(SCORE)            점수합
--   분모 = COUNT(SCORE) * 5      만점합 (무응답은 COUNT 에서 빠지므로 분모에도 안 들어간다)
--   MULTIPLIER=100 이라 그대로 만족도(%)
--
-- ★어느 달에 넣는가 = **조사 종료월(TO_DT)**.
--   만족도는 연 1~2회다. 시작월에 넣으면 아직 나오지도 않은 값을 그 달에 세우게 된다.
--   조사가 없는 달은 분모 0 → 지표 '-' (0% 가 아니다 — 조사를 안 한 것과 만족도 0 은 다르다).
--
-- ★분기·연 누계는 점수합 ÷ 만점합이다. 조사가 두 번이면 응답이 많은 쪽이 더 무겁게 반영된다.
--   보고서의 「전체 평균」과 같은 셈법이라 두 화면이 어긋날 수 없다.
--
-- ⚠되돌리려면 : NUMER_SRC 를 'MANUAL' 로 되돌리면 끝이다(아래 [원복] 절).
--   TBL_QPS_MANUAL 의 SATISFY 행은 건드리지 않으므로 옛 수기값이 있으면 그대로 살아난다.
-- ═══════════════════════════════════════════════════════════════════════════

UPDATE TBL_QPS_INDI_MST
   SET NUMER_SRC  = 'SRV',
       NUMER_DESC = '설문 문항 응답점수 합계',
       DENOM_DESC = '설문 문항 응답수 × 5(만점)',
       SOURCE_NM  = '환자만족도 조사(설문 응답)',
       METHOD_NM  = '조사 종료월 기준 자동집계',
       UPD_USER   = 'system'
 WHERE INDI_CD = 'SATISFY';

-- 확인 --------------------------------------------------------------------
SELECT '지표' AS chk, HOSP_CD, INDI_CD, INDI_NM, NUMER_SRC, DENOM_GB, MULTIPLIER, UNIT
  FROM TBL_QPS_INDI_MST WHERE INDI_CD IN ('SATISFY','CLAIM') ORDER BY INDI_CD;

-- 조사별 집계(지표에 들어갈 값) — 종료월이 비어 있으면 여기서도 빠진다
SELECT '조사' AS chk, s.SURVEY_ID, s.IN_YEAR, s.SURVEY_NM, s.FR_DT, s.TO_DT,
       SUBSTR(s.TO_DT,5,2) AS 반영월,
       COUNT(DISTINCT a.ANS_ID) AS 응답자,
       SUM(i.SCORE)     AS 점수합,
       COUNT(i.SCORE)*5 AS 만점합,
       ROUND(SUM(i.SCORE)/(COUNT(i.SCORE)*5)*100,2) AS 만족도
  FROM TBL_QPS_SURVEY      s
  JOIN TBL_QPS_SURVEY_ANS  a ON a.SURVEY_ID = s.SURVEY_ID
  JOIN TBL_QPS_SURVEY_ITEM i ON i.ANS_ID    = a.ANS_ID
 GROUP BY s.SURVEY_ID, s.IN_YEAR, s.SURVEY_NM, s.FR_DT, s.TO_DT
 ORDER BY s.SURVEY_ID;

-- 종료일이 비어 지표에서 빠지는 조사 (있으면 화면에서 종료일을 채워야 한다)
SELECT '종료일없음' AS chk, SURVEY_ID, IN_YEAR, SURVEY_NM, FR_DT, TO_DT
  FROM TBL_QPS_SURVEY
 WHERE TO_DT IS NULL OR LENGTH(IFNULL(TO_DT,'')) <> 8;

-- [원복] -------------------------------------------------------------------
-- UPDATE TBL_QPS_INDI_MST SET NUMER_SRC='MANUAL' WHERE INDI_CD='SATISFY';
