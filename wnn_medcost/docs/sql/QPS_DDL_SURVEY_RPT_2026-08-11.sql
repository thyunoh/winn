-- =====================================================================
-- 만족도 보고서 서술칸 (2026-08-11) — 조사결과 보고서(12p)·지표분석 보고서(10p) 인쇄용
--   보고서에서 사람이 쓰는 칸만 저장한다(집계 9면은 전부 조회 시 계산 — 저장 금지 원칙).
--   · IMPR_TXT     : 개선사항 표 — 한 줄 = "구분|문제점|처리결과" (양쪽 보고서 공용.
--                    지표분석 10p 의 「사진」 컬럼은 공통 첨부 과제로 미룸 — 3열만)
--   · STRATEGY_TXT : 개선 전략 및 실행 (지표분석 8p)
--   · CONCL_TXT    : 결론 및 제언 (지표분석 9p)
--   · NEXTACT_TXT  : 증진활동 평가 및 추후 활동계획 (지표분석 9p)
--   ※ '조사의 내용'(구분|관련 문항) 표는 문항표(TBL_QPS_SRV_DEF)에서 자동 생성 — 저장 안 함.
-- =====================================================================

ALTER TABLE TBL_QPS_SURVEY
  ADD COLUMN IMPR_TXT     TEXT NULL COMMENT '개선사항(줄당 구분|문제점|처리결과)' AFTER USE_PLAN,
  ADD COLUMN STRATEGY_TXT TEXT NULL COMMENT '개선 전략 및 실행'                   AFTER IMPR_TXT,
  ADD COLUMN CONCL_TXT    TEXT NULL COMMENT '결론 및 제언'                        AFTER STRATEGY_TXT,
  ADD COLUMN NEXTACT_TXT  TEXT NULL COMMENT '증진활동 평가 및 추후 활동계획'      AFTER CONCL_TXT;
