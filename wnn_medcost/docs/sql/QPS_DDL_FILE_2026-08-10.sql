-- =====================================================================
-- QPS 공통 파일첨부 (2026-08-10)
--   ★한 테이블로 모든 문서의 첨부를 담는다 — REF_GB(문서종류) + REF_KEY(그 문서의 키).
--     회의록·연간계획서·라운딩 점검표의 사진/파일 첨부 + 조직도·내규 자료실을 한 번에.
--   ★실제 파일은 SFTP 파일서버(월보고서 PDF 와 같은 인프라)에 두고, 여기엔 메타만.
--     다운로드는 기존 /sftp/download.do?filePath= 재사용(로컬우선+SFTP폴백+경로탈출차단).
--   대상: WNN(MySQL). ★적용은 사용자가 직접.
-- =====================================================================
CREATE TABLE IF NOT EXISTS TBL_QPS_FILE (
  FILE_SEQ   BIGINT       NOT NULL AUTO_INCREMENT,
  HOSP_CD    VARCHAR(20)  NOT NULL,
  REF_GB     VARCHAR(20)  NOT NULL,   -- MINUTES(회의록)/PLAN(계획서)/ROUND(라운딩)/LIBRARY(자료실:조직도·내규 등)
  REF_KEY    VARCHAR(60)  NOT NULL,   -- 그 문서의 키: 회의록 SEQ / 계획서 년도 / 라운딩 년월 / 자료실 분류코드
  FILE_NM    VARCHAR(255) NOT NULL,   -- 사용자에게 보일 원본 파일명
  FILE_PATH  VARCHAR(300) NOT NULL,   -- SFTP 저장 경로 (다운로드 filePath)
  FILE_SIZE  BIGINT       NULL,       -- byte
  SORT_NO    INT          NULL DEFAULT 0,
  USE_YN     CHAR(1)      NOT NULL DEFAULT 'Y',   -- 소프트삭제
  REG_USER   VARCHAR(50)  NULL,
  REG_DTTM   DATETIME     NULL DEFAULT CURRENT_TIMESTAMP,
  UPD_USER   VARCHAR(50)  NULL,
  UPD_DTTM   DATETIME     NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (FILE_SEQ),
  KEY IX_QPS_FILE (HOSP_CD, REF_GB, REF_KEY, USE_YN)
);
