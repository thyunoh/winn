-- ═══════════════════════════════════════════════════════════════════════════
-- 지표 목표방향(GOAL_DIR) 신설 — 지표분석보고서 「목표 충족 / 미충족」 판정용
--   2026-08-11
--
-- 왜 컬럼을 새로 만드나 :
--   목표값(TARGET_VAL)만으로는 충족 여부를 셈할 수 없다. 낙상 발생률은 **목표 이하**여야 충족이고,
--   손위생 수행률은 **목표 이상**이어야 충족이다. 방향이 없으면 절반이 거꾸로 판정된다.
--   ★단위(‰/%)나 지표명으로 때려 맞히지 않는다 — 같은 % 안에 발생률(직원감염노출)과
--     수행률(손위생)이 함께 있다. 추측이 틀리면 보고서에 「미충족」이 거짓으로 찍힌다.
--
--   'L' = 낮을수록 좋다 (실적 <= 목표 → 충족)
--   'H' = 높을수록 좋다 (실적 >= 목표 → 충족)
--
-- ★목표값이 비어 있으면 판정 자체를 하지 않는다('-'). 방향만 있고 목표가 없으면 셈할 게 없다.
-- ★병원이 정의서 화면에서 바꿀 수 있다 — 낙상 '발생 보고율' 처럼 병원에 따라
--   보고를 장려하려고 'H' 로 두는 곳이 있을 수 있다.
-- ═══════════════════════════════════════════════════════════════════════════

-- 1) 컬럼 (이미 있으면 이 문장만 건너뛰면 된다)
ALTER TABLE TBL_QPS_INDI_MST
  ADD COLUMN GOAL_DIR CHAR(1) NULL DEFAULT 'L'
      COMMENT '목표방향 L=낮을수록좋음(이하 충족) / H=높을수록좋음(이상 충족)'
      AFTER TARGET_BASE;

-- 2) 기본값 — 전부 'L' 로 깔고, 높을수록 좋은 것만 'H' 로 올린다
UPDATE TBL_QPS_INDI_MST SET GOAL_DIR = 'L' WHERE GOAL_DIR IS NULL OR GOAL_DIR = '';

UPDATE TBL_QPS_INDI_MST SET GOAL_DIR = 'H'
 WHERE INDI_CD IN (
   'HANDWASH',    -- 손위생 수행률
   'ISOLATION',   -- 격리지침 수행률
   'SECLUSION',   -- 강박지침 수행률
   'TATIMG',      -- 영상 TAT 충족 비율
   'TATLAB',      -- 검체 TAT 충족 비율
   'HOMERET',     -- 재택 복귀율
   'CLAIM',       -- 불만·고충 처리율
   'SATISFY'      -- 환자만족도
 );

-- 확인 --------------------------------------------------------------------
SELECT GOAL_DIR AS 방향, COUNT(*) AS 지표수
  FROM TBL_QPS_INDI_MST WHERE HOSP_CD='*' AND USE_YN='Y' GROUP BY GOAL_DIR;

SELECT INDI_CD, INDI_NM, UNIT, TARGET_VAL, GOAL_DIR
  FROM TBL_QPS_INDI_MST WHERE HOSP_CD='*' AND USE_YN='Y' ORDER BY GOAL_DIR DESC, AREA_NO, SORT_NO;
