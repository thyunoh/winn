-- =====================================================================
-- QPS 서식 1호 — 위원회 회의록 (2026-08-09)
--
--   ★위치: 서술형 서식 203종의 **첫 실물 파일럿**. 서식빌더로 갈지 개별로 갈지 결정하기 전에
--     대표 1종(사용 빈도 최고·구조 정형)을 만들어 보여준다 — 진행 방식 확정("우리가 만들고 보여주고 고친다").
--   ★v1 은 전자결재 없이 간다 — 인쇄물에 결재란(빈칸)만 싣는다(지표정의서와 같은 방식).
--     회의록 전자결재가 필요해지면 그때 TBL_QPS_APPR 확장을 논의한다.
-- =====================================================================

CREATE TABLE IF NOT EXISTS TBL_QPS_MINUTES (
  MIN_SEQ   BIGINT       NOT NULL AUTO_INCREMENT,
  HOSP_CD   VARCHAR(20)  NOT NULL,
  MEET_DT   VARCHAR(8)   NOT NULL,                 -- 회의일(YYYYMMDD)
  TITLE     VARCHAR(200) NOT NULL,                 -- 회의명 (예: 2026년 2차 QPS위원회)
  PLACE     VARCHAR(100) NULL,                     -- 장소
  ATTENDEES VARCHAR(1000) NULL,                    -- 참석자 (쉼표 구분 자유기재)
  AGENDA    TEXT         NULL,                     -- 안건
  CONTENT   TEXT         NULL,                     -- 논의 내용
  DECISION  TEXT         NULL,                     -- 결정 사항
  NEXT_TXT  VARCHAR(500) NULL,                     -- 차기 일정·과제
  USE_YN    CHAR(1)      NOT NULL DEFAULT 'Y',
  REG_USER  VARCHAR(50)  NULL,
  REG_DTTM  DATETIME     NULL DEFAULT CURRENT_TIMESTAMP,
  UPD_USER  VARCHAR(50)  NULL,
  UPD_DTTM  DATETIME     NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (MIN_SEQ),
  KEY IX_QPS_MINUTES (HOSP_CD, MEET_DT)
);
