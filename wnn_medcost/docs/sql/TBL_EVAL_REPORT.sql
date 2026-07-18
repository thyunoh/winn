-- =====================================================================
-- 적정성평가 컨설팅 월보고서 (위너넷 편집·승인 → 거래처 열람·인쇄)
--   · 지표 수치는 저장하지 않고 select_Eval_Indi 로 재계산해 화면에서 채움
--   · 여기서는 편집 문구(override) + 상태/승인/스냅샷만 저장
--   · 기존 TBL_REPORT_MST(마감 통계)와 이름이 겹치지 않도록 TBL_EVAL_REPORT_* 사용
--   · CHARSET 미지정 → WNN DB 기본값 상속(기존 테이블과 일치). 필요시 SHOW CREATE TABLE 로 확인.
-- =====================================================================

-- ① 보고서 마스터 : 병원 + 평가월 = 1건
CREATE TABLE IF NOT EXISTS TBL_EVAL_REPORT_MST (
  REPORT_SEQ    BIGINT       NOT NULL AUTO_INCREMENT,
  HOSP_CD       VARCHAR(20)  NOT NULL,                 -- 요양기관기호
  EVAL_YM       VARCHAR(6)   NOT NULL,                 -- 평가월 (예: 202606)
  TITLE         VARCHAR(200) NULL,
  GOAL_GRADE    VARCHAR(10)  NULL,                     -- 목표등급 (예: 3등급)
  GOAL_SCORE    DECIMAL(5,1) NULL,                     -- 목표점수 (예: 78.0)
  STRUCT_SCORE  DECIMAL(5,1) NULL,                     -- 구조영역 점수
  CARE_SCORE    DECIMAL(5,1) NULL,                     -- 진료영역 점수
  TOTAL_SCORE   DECIMAL(5,1) NULL,                     -- 종합점수
  STATUS        VARCHAR(10)  NOT NULL DEFAULT 'DRAFT', -- DRAFT(작성중) / APPROVED(승인)
  PDF_PATH      VARCHAR(300) NULL,                     -- 아래한글 완성본 PDF (SFTP 경로, 있으면 거래처에 우선 제공)
  SNAPSHOT_JSON LONGTEXT     NULL,                     -- 승인 시 수치 동결(JSON)
  APPROVE_USER  VARCHAR(50)  NULL,
  APPROVE_DTTM  DATETIME     NULL,
  REG_USER      VARCHAR(50)  NULL,
  REG_DTTM      DATETIME     NULL DEFAULT CURRENT_TIMESTAMP,
  UPD_USER      VARCHAR(50)  NULL,
  UPD_DTTM      DATETIME     NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (REPORT_SEQ),
  UNIQUE KEY UK_EVAL_REPORT_MST (HOSP_CD, EVAL_YM)     -- 병원·월 1건 보장
);

-- [이미 테이블을 만든 경우] PDF_PATH 컬럼만 추가:
-- ALTER TABLE TBL_EVAL_REPORT_MST ADD COLUMN PDF_PATH VARCHAR(300) NULL COMMENT '아래한글 완성본 PDF (SFTP 경로)' AFTER STATUS;

-- ② 병원별 편집 문구 override (섹션·지표별 key-value) — SECT_KEY 는 report.jsp data-key 와 1:1
CREATE TABLE IF NOT EXISTS TBL_EVAL_REPORT_TEXT (
  TEXT_SEQ    BIGINT      NOT NULL AUTO_INCREMENT,
  REPORT_SEQ  BIGINT      NOT NULL,                    -- FK → TBL_EVAL_REPORT_MST
  SECT_KEY    VARCHAR(60) NOT NULL,                    -- 편집영역 키 (예: diag_core, plan_11, recdir_09)
  CONTENT     LONGTEXT    NULL,                        -- 수정된 문구(HTML)
  UPD_USER    VARCHAR(50) NULL,
  UPD_DTTM    DATETIME    NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (TEXT_SEQ),
  UNIQUE KEY UK_EVAL_REPORT_TEXT (REPORT_SEQ, SECT_KEY)
);

-- ④ 저장·PDF 변경 이력 (2026-07-18 추가) — 덮어쓰기 직전 상태를 스냅샷으로 보존
--   · TEXT : 문구 저장 직전의 병원별 override 전체를 JSON 으로 보존
--   · PDF  : 첨부 교체·해제 직전의 PDF 경로 보존 (파일 자체는 업로드 시 타임스탬프 파일명이라 안 덮어써짐)
CREATE TABLE IF NOT EXISTS TBL_EVAL_REPORT_HST (
  HST_SEQ    BIGINT       NOT NULL AUTO_INCREMENT,
  REPORT_SEQ BIGINT       NOT NULL,                    -- FK → TBL_EVAL_REPORT_MST
  HST_TYPE   VARCHAR(10)  NOT NULL,                    -- TEXT(문구 저장) / PDF(첨부 교체·해제)
  TEXTS_JSON LONGTEXT     NULL,                        -- TEXT: 직전 문구 전체 [{"sectkey":..,"content":..},...]
  PDF_PATH   VARCHAR(300) NULL,                        -- PDF: 직전 첨부 경로
  REG_USER   VARCHAR(50)  NULL,
  REG_DTTM   DATETIME     NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (HST_SEQ),
  KEY IX_EVAL_REPORT_HST (REPORT_SEQ, REG_DTTM)
);

-- ③ 표준양식 문구 템플릿 (전 병원 공통 · 위너넷 전역 편집) — 2단계에서 연동 예정
CREATE TABLE IF NOT EXISTS TBL_EVAL_REPORT_TPL (
  SECT_KEY    VARCHAR(60)  NOT NULL,
  TITLE       VARCHAR(200) NULL,
  TPL_CONTENT LONGTEXT     NULL,                        -- {지표}{현황}{구간} 자리표시자
  SORT_NO     INT          NULL,
  USE_YN      CHAR(1)      NOT NULL DEFAULT 'Y',
  UPD_USER    VARCHAR(50)  NULL,
  UPD_DTTM    DATETIME     NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (SECT_KEY)
);
