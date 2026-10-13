-- =====================================================================
-- MIS 병원 내규 (2026-10-12) — 경영고객관리 › 병원 내규·안내문
--   병원이 직접 올린 내규·지침 본문. AI 내규 조회가 이 본문만 근거로 답한다.
--   삭제는 USE_YN='N' (소프트 삭제 — 과거 질문 기록과 맞물리지 않게 행은 남긴다).
--   ※ 이 파일은 사용자가 실행한다(표 생성만, 데이터 없음 · 여러 번 돌려도 안전).
-- =====================================================================
CREATE TABLE IF NOT EXISTS TBL_MIS_RULE (
  RULE_SEQ  BIGINT       NOT NULL AUTO_INCREMENT,
  HOSP_CD   VARCHAR(20)  NOT NULL,
  TITLE     VARCHAR(200) NOT NULL,                 -- 예) 경조사비 지급 규정
  BODY      LONGTEXT     NULL,                     -- 내규 본문(줄바꿈 그대로)
  USE_YN    CHAR(1)      NOT NULL DEFAULT 'Y',
  REG_USER  VARCHAR(50)  NULL,
  REG_DTTM  DATETIME     NULL DEFAULT CURRENT_TIMESTAMP,
  UPD_USER  VARCHAR(50)  NULL,
  UPD_DTTM  DATETIME     NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (RULE_SEQ),
  KEY IX_MIS_RULE (HOSP_CD, USE_YN, UPD_DTTM)
);
