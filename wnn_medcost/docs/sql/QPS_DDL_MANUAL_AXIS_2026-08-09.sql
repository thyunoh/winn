-- =====================================================================
-- QPS 수기입력 — 축(AXIS) 컬럼 추가 (2026-08-09) : 검체/영상 TAT 정규·응급 분리
--
--   ★설계: 지표 산출은 **총계 행(AXIS_CD='')** 만 읽는다 — 집계 로직은 안 바뀐다.
--     정규/응급은 상세 행(AXIS_CD='정규'/'응급')으로 따로 적고, 분석 탭의 축별 집계표에만 쓴다.
--     이전 시스템의 검체 TAT 보고서가 정규/응급을 나눠 실었던 것을 그대로 옮기는 것.
--   ★기존 행은 AXIS_CD='' (DEFAULT) 로 남아 총계 행이 된다 — 자료 이관 불필요.
--   ★UNIQUE 키에 AXIS_CD 를 넣어야 한다 — 안 넣으면 정규 행 upsert 가 총계 행을 덮는다.
-- =====================================================================

ALTER TABLE TBL_QPS_MANUAL
  ADD COLUMN AXIS_CD VARCHAR(20) NOT NULL DEFAULT '' COMMENT '축(정규/응급 등, 빈값=총계)' AFTER VAL_GB;

ALTER TABLE TBL_QPS_MANUAL
  DROP INDEX UK_QPS_MANUAL,
  ADD UNIQUE KEY UK_QPS_MANUAL (HOSP_CD, INDI_CD, IN_YEAR, VAL_GB, AXIS_CD);

-- 확인
-- SHOW INDEX FROM TBL_QPS_MANUAL WHERE Key_name='UK_QPS_MANUAL';
