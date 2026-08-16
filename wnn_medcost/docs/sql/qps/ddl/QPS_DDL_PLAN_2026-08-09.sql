-- =====================================================================
-- QPS 서식 2호 — 질향상및 환자안전 활동계획서 (연간, 2026-08-09)
--
--   ★원본(이전 시스템 실물 캡처 9장) 구조:
--     표지(작성·검토·승인 3단 결재란) / ①주제선정 점수표(부서·주제 × 6기준×10점=60점)
--     / ②개요 6항목(3번은 추진체계 흐름도 — v1 은 글로 적는다) / ③주요업무 사업계획(그룹×세부·비고·일정)
--     / ④QPS 활동 평가지표(그룹×세부·사업지표·목표치·평가) / ⑤연간 활동 계획표(항목×월 1~12 체크·예산·비고)
--     / ⑥사업 예산안(관련사업·예산과목·내역·비용+총예산) / 첨부사진(v1 제외)
--   ★연 1부 문서 → (병원, 년도) UNIQUE. 항목행은 저장 때 통째 교체(삭제 후 재삽입)라 개별 키 불필요.
--   ★항목 테이블은 **한 벌로 전 섹션을 담는다**(SECT_CD 로 구분, C1~C4·S1~S6·M01~M12·AMT 겸용) —
--     섹션마다 테이블을 만들면 서식이 늘 때마다 DDL 이 필요해진다.
-- =====================================================================

CREATE TABLE IF NOT EXISTS TBL_QPS_PLAN (
  PLAN_SEQ  BIGINT      NOT NULL AUTO_INCREMENT,
  HOSP_CD   VARCHAR(20) NOT NULL,
  IN_YEAR   VARCHAR(4)  NOT NULL,
  SUBMIT_DT VARCHAR(8)  NULL,                      -- 제출일(표지)
  USE_YN    CHAR(1)     NOT NULL DEFAULT 'Y',
  REG_USER  VARCHAR(50) NULL,
  REG_DTTM  DATETIME    NULL DEFAULT CURRENT_TIMESTAMP,
  UPD_USER  VARCHAR(50) NULL,
  UPD_DTTM  DATETIME    NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (PLAN_SEQ),
  UNIQUE KEY UK_QPS_PLAN (HOSP_CD, IN_YEAR)
);

CREATE TABLE IF NOT EXISTS TBL_QPS_PLAN_ITEM (
  IT_SEQ   BIGINT       NOT NULL AUTO_INCREMENT,
  PLAN_SEQ BIGINT       NOT NULL,
  SECT_CD  VARCHAR(10)  NOT NULL,   -- INTRO(개요)/TOPIC(주제선정)/BIZ(사업계획)/EVAL(평가지표)/SCHED(연간표)/BUDGET(예산)
  SORT     INT          NOT NULL DEFAULT 0,
  GRP      VARCHAR(100) NULL,       -- 주요사업·구분(그룹 라벨)
  C1       VARCHAR(500) NULL,       -- 섹션별 첫 칸(부서/항목명/세부내용/예산과목 …)
  C2       TEXT         NULL,       -- 둘째 칸(주제/내용/사업지표/내역 …)
  C3       VARCHAR(300) NULL,
  C4       VARCHAR(300) NULL,
  S1 INT NULL, S2 INT NULL, S3 INT NULL, S4 INT NULL, S5 INT NULL, S6 INT NULL,  -- 주제선정 점수 6기준
  M01 CHAR(1) NULL, M02 CHAR(1) NULL, M03 CHAR(1) NULL, M04 CHAR(1) NULL,
  M05 CHAR(1) NULL, M06 CHAR(1) NULL, M07 CHAR(1) NULL, M08 CHAR(1) NULL,
  M09 CHAR(1) NULL, M10 CHAR(1) NULL, M11 CHAR(1) NULL, M12 CHAR(1) NULL,        -- 연간표 월 체크('Y')
  AMT  BIGINT NULL,                  -- 예산(원)
  PRIMARY KEY (IT_SEQ),
  KEY IX_QPS_PLAN_ITEM (PLAN_SEQ, SECT_CD, SORT)
);
