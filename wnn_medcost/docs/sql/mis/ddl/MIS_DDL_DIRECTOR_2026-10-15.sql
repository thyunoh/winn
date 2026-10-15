-- =====================================================================
-- MIS 병원장 조회 · 원무 환자고객 · 간호사 관리 (2026-10-15)
--   새 표는 인력 변동 기록 1개뿐이다. 나머지는 기존 표를 읽는다:
--     원무 환자고객 = TBL_IPWON_INFO(입퇴원현황) + TBL_MIS_EMR_CONTACT(보호자) + TBL_MIS_LEAD(상담)
--     간호사 관리   = TBL_MIS_EMR_STAFF(직원 명단, EMR 연계) + TBL_WEVALUE_MST(간호사 구간)
--     병원장 조회   = 청구 통계 · 상담 현황 · 업무 알림(기존 조회 재사용)
--   ※ 한 번만 실행. 다시 실행해도 안전(IF NOT EXISTS).
-- =====================================================================
CREATE TABLE IF NOT EXISTS TBL_MIS_STAFF_CHG (
  CHG_SEQ     BIGINT        NOT NULL AUTO_INCREMENT,
  HOSP_CD     VARCHAR(10)   NOT NULL,
  CHG_DT      CHAR(8)       NOT NULL COMMENT '변동일 YYYYMMDD',
  STAFF_NM    VARCHAR(50)   NOT NULL COMMENT '성명',
  JOB_NM      VARCHAR(30)   NULL     COMMENT '직종(간호사·간호조무사·요양보호사·기타)',
  WARD_NM     VARCHAR(30)   NULL     COMMENT '병동·부서',
  CHG_GB      VARCHAR(10)   NOT NULL COMMENT 'IN 입사 · OUT 퇴사 · MOVE 이동',
  MEMO        VARCHAR(200)  NULL,
  USE_YN      CHAR(1)       NOT NULL DEFAULT 'Y' COMMENT '지움 표식(N = 지운 것, 기록은 남긴다)',
  REG_DTTM    DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
  REG_USER    VARCHAR(50)   NULL,
  UPD_DTTM    DATETIME      NULL,
  UPD_USER    VARCHAR(50)   NULL,
  PRIMARY KEY (CHG_SEQ),
  KEY IX_MIS_STAFF_CHG (HOSP_CD, CHG_DT)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='MIS 간호사 관리 — 인력 변동 기록(입사·퇴사·이동)';
