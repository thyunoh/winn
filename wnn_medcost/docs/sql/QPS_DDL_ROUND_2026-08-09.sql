-- =====================================================================
-- QPS 서식 3호 — 환자안전 관리 라운딩 점검표 (월 1부, 2026-08-09)
--   원본: 년/월 + 점검자 + [구분 × 점검항목 × 점검내용 × 평가(양호/불량) × 불량내용·개선사항]
--         + [전월복사](매달 같은 항목을 재점검) + 사진첨부 2쪽(→ 공통 파일첨부 과제로).
--   (병원, 년월) UNIQUE. 항목행은 저장 때 통째 교체 — 계획서(서식 2호)와 같은 방식.
-- =====================================================================

CREATE TABLE IF NOT EXISTS TBL_QPS_ROUND (
  RND_SEQ   BIGINT      NOT NULL AUTO_INCREMENT,
  HOSP_CD   VARCHAR(20) NOT NULL,
  ROUND_YM  VARCHAR(6)  NOT NULL,                  -- YYYYMM
  CHECKER   VARCHAR(50) NULL,                      -- 점검자
  USE_YN    CHAR(1)     NOT NULL DEFAULT 'Y',
  REG_USER  VARCHAR(50) NULL,
  REG_DTTM  DATETIME    NULL DEFAULT CURRENT_TIMESTAMP,
  UPD_USER  VARCHAR(50) NULL,
  UPD_DTTM  DATETIME    NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (RND_SEQ),
  UNIQUE KEY UK_QPS_ROUND (HOSP_CD, ROUND_YM)
);

CREATE TABLE IF NOT EXISTS TBL_QPS_ROUND_ITEM (
  IT_SEQ   BIGINT       NOT NULL AUTO_INCREMENT,
  RND_SEQ  BIGINT       NOT NULL,
  SORT     INT          NOT NULL DEFAULT 0,
  GRP      VARCHAR(50)  NULL,                      -- 구분(의료기기 관리 …)
  C1       VARCHAR(300) NULL,                      -- 점검 항목
  C2       VARCHAR(500) NULL,                      -- 점검 내용
  EVAL_GB  CHAR(1)      NULL,                      -- G=양호 / B=불량 / NULL=미점검
  C3       VARCHAR(500) NULL,                      -- 불량 내용 및 개선사항
  PRIMARY KEY (IT_SEQ),
  KEY IX_QPS_ROUND_ITEM (RND_SEQ, SORT)
);
