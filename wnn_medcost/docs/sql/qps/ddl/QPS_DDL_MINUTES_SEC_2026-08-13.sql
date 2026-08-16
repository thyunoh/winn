-- ═══════════════════════════════════════════════════════════════════════════
-- 회의록 「격리 및 강박 시행시간」 칸 (2026-08-13)
--   원본 : 간호/병동 캡처 292 「다학제 평가팀 개최에 따른 회의록」(FORM_GB='K') 에만 있는 칸.
--   ★MINUTES_ACT(조치표 넷)와 같은 이유로 만든다 — 원본에 있는 칸을 못 담으면 서식이 반쪽이 된다.
--     원본이 한 줄(`- - : ~ - - :`)이라 자유글 VARCHAR(50) — 날짜 형식을 원본이 안 박았다.
--   ⚠더하기만 하는 ALTER — 옛 SQL 은 이 칸을 읽지도 쓰지도 않는다(운영 선적용 안전).
-- ═══════════════════════════════════════════════════════════════════════════
ALTER TABLE TBL_QPS_MINUTES
  ADD COLUMN SEC_TIME VARCHAR(50) NULL
      COMMENT "격리 및 강박 시행시간 — 다학제 개최에 따른 회의록(FORM_GB='K') 전용. 자유글" AFTER ACT_COST;

SELECT COLUMN_NAME, COLUMN_TYPE, COLUMN_COMMENT FROM INFORMATION_SCHEMA.COLUMNS
 WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='TBL_QPS_MINUTES' AND COLUMN_NAME='SEC_TIME';
