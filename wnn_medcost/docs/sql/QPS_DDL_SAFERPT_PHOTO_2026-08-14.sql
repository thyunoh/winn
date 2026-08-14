-- =====================================================================
-- safeRpt 사진첨부 — DDL (2026-08-14)
--   설계 정본 : docs/proposals/QPS_사진첨부_연간격자_설계_2026-08-14.md §①
--   근거 서식 8장 : 상담일지 계열 h13~16·18·h23~28 + w24·w54(직원 교육 결과 보고서)·w58
--   ★더하기만 하는 DDL — 옛 코드는 이 칸·표를 읽지도 쓰지도 않는다 ⇒ 운영 선적용 안전
--     (08-12 GRP_PRD · 08-14 SAFERPT_ROWSIGN 과 같은 판단).
--   ★파일 실체는 기존 sftp 파일서버(/home/winner/upload/QPS/{병원}/SAFERPT_PHOTO/{문서}/)
--     — 월보고서 PDF·QPS 공통첨부와 같은 장치. 새 저장소를 만들지 않는다.
-- =====================================================================

-- 1) 유형 설정에 사진칸 사용 여부 한 칸 — 비면(NULL) 지금과 동일(기존 유형 무영향)
ALTER TABLE TBL_QPS_SAFERPT_FORM
  ADD COLUMN PHOTO_YN CHAR(1) NULL DEFAULT NULL
      COMMENT '사진첨부 칸 사용(Y=2x2 사진 격자 표시·인쇄)' AFTER FOOT_TXT;

-- 2) 사진 값 표 — 칸(1~4)이 고정 자리라 (문서, 칸) 이 곧 키다
CREATE TABLE TBL_QPS_SAFERPT_FILE (
  SRP_SEQ    BIGINT       NOT NULL COMMENT '보고서 번호(TBL_QPS_SAFERPT.SRP_SEQ)',
  FILE_SEQ   INT          NOT NULL COMMENT '사진 칸 번호(1~4) — 2x2 격자의 고정 자리',
  FILE_PATH  VARCHAR(300) NOT NULL COMMENT '파일서버 경로(/sftp/download.do?filePath= 로 내려받음)',
  ORG_NM     VARCHAR(200) NULL     COMMENT '원본 파일명(표시용)',
  REG_USER   VARCHAR(50)  NULL,
  REG_DTTM   DATETIME     NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (SRP_SEQ, FILE_SEQ)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
  COMMENT='사고 보고서 사진첨부(칸 1~4, 같은 칸 재업로드=교체)';
