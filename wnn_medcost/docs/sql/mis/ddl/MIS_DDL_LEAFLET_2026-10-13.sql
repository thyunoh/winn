-- =====================================================================
-- MIS 안내문 저장 (2026-10-13) — 경영고객관리 › 병원 내규·안내문 › 안내문 초안
--   초안 옆 [저장]으로 보관한 안내문. 목록에서 다시 열어 고치고 지운다(삭제는 USE_YN='N').
--   ※ 사용자가 실행한다(표 생성만, 데이터 없음 · 여러 번 돌려도 안전).
-- =====================================================================
CREATE TABLE IF NOT EXISTS TBL_MIS_LEAFLET (
  LEAF_SEQ  BIGINT       NOT NULL AUTO_INCREMENT,
  HOSP_CD   VARCHAR(20)  NOT NULL,
  TITLE     VARCHAR(200) NOT NULL,                 -- 저장할 때 붙인 이름
  AUDIENCE  VARCHAR(30)  NULL,                     -- 대상 (신규 입원 환자 등)
  TOPIC     VARCHAR(60)  NULL,                     -- 주제 (입원 안내 등)
  BODY      LONGTEXT     NULL,                     -- 안내문 본문(줄바꿈 그대로)
  USE_YN    CHAR(1)      NOT NULL DEFAULT 'Y',
  REG_USER  VARCHAR(50)  NULL,
  REG_DTTM  DATETIME     NULL DEFAULT CURRENT_TIMESTAMP,
  UPD_USER  VARCHAR(50)  NULL,
  UPD_DTTM  DATETIME     NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (LEAF_SEQ),
  KEY IX_MIS_LEAFLET (HOSP_CD, USE_YN, UPD_DTTM)
);
