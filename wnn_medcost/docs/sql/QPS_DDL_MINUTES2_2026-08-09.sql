-- =====================================================================
-- 서식 1호(회의록) 보강 — 원본 「QPS위원회 회의록」 실물 3장 대조 (2026-08-09)
--   빠져 있던 칸: 회의 구분(정기/임시) · 인원 · 첨부자료 · 참석자 명단(직책별) · 특이사항.
--   원본 결재란은 담당/팀장/부서장/이사장 4단 = 우리 결재선 기본값과 동일 → 인쇄는 결재선(apprLine)을 그대로 쓴다.
--   MEMBERS 는 "직책: 이름" 한 줄씩(줄바꿈 구분) — 직책 구성이 병원마다 달라 고정 칸으로 만들지 않는다.
-- =====================================================================

ALTER TABLE TBL_QPS_MINUTES
  ADD COLUMN MEET_GB     CHAR(1)      NULL COMMENT '회의구분 R=정기, T=임시' AFTER TITLE,
  ADD COLUMN PERSONNEL   VARCHAR(30)  NULL COMMENT '인원'                    AFTER PLACE,
  ADD COLUMN MEMBERS     TEXT         NULL COMMENT '참석자 명단(직책: 이름, 줄바꿈 구분)' AFTER ATTENDEES,
  ADD COLUMN ATTACH_TXT  VARCHAR(500) NULL COMMENT '첨부자료'                AFTER NEXT_TXT,
  ADD COLUMN SPECIAL_TXT VARCHAR(500) NULL COMMENT '특이사항(참석자 명단)'   AFTER ATTACH_TXT;
