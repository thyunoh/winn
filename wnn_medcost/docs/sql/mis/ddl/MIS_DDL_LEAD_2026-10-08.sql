-- =====================================================================
-- MIS(경영관리) ④ 신규환자 고객관리 — DDL (2026-10-08)
--   왜 : 신규 요양병원 업무 패키지 ④(제안서) — 상담(전화·방문)에서 입원까지 단계로 관리하고,
--        입원 여부는 병원이 올리는 입퇴원현황(TBL_IPWON_INFO)으로 **자동 확인**한다. EMR(닥터스) 연동 없음.
--   원칙 :
--     · 상담 1건 = TBL_MIS_LEAD 한 줄. 단계(STAGE) : 10 상담 → 20 방문 → 30 입원결정 → 40 입원 → 50 퇴원 후 · 90 종결(취소·타병원).
--     · 자동 매칭 키 = 생년월일 6자리(BIRTH6) + 이름(PAT_NM) — 입퇴원현황의 JUMINNO 앞 6자리·PATNAME(숫자 뗌)과 같은 규칙(장기입원 목록과 같다).
--       매칭되면 STAGE 40 + ADMIT_DT + MATCH_YN='Y', 퇴원일이 생기면 STAGE 50 + DISCH_DT. 사람이 적은 단계는 자동 매칭이 **앞으로만** 옮긴다(되돌리지 않는다).
--     · 주민번호 전체·연락처 외 민감정보는 받지 않는다(이름·생년월일·보호자 연락처만).
--     · 퇴원 환자 안부 연락(TBL_MIS_FOLLOW)은 입퇴원현황의 퇴원 건 단위 — 상담 기록이 없는 퇴원 환자도 대상.
--   더하기만 하는 DDL ⇒ 운영 선적용 안전.
--   코드 : Mis_SQL.xml · MisMapper/Service(Impl)/Controller(lead*·follow*) · misLead.jsp — ⛔자바·매퍼 변경 → WAR 재빌드+재기동
-- =====================================================================

-- ── ① 상담 접수(리드) ────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS TBL_MIS_LEAD (
  LEAD_SEQ     BIGINT       NOT NULL AUTO_INCREMENT,
  HOSP_CD      VARCHAR(10)  NOT NULL,
  PAT_NM       VARCHAR(50)  NOT NULL COMMENT '환자 이름',
  BIRTH6       CHAR(6)      NULL     COMMENT '생년월일 6자리(YYMMDD) — 입퇴원현황 자동 매칭 키',
  GENDER       CHAR(1)      NULL     COMMENT 'M/F',
  GUARD_NM     VARCHAR(50)  NULL     COMMENT '보호자 이름',
  GUARD_REL    VARCHAR(20)  NULL     COMMENT '보호자 관계(아들·딸·배우자…)',
  TEL          VARCHAR(30)  NULL     COMMENT '연락처',
  CONTACT_DT   CHAR(8)      NOT NULL COMMENT '최초 상담일 YYYYMMDD',
  CHANNEL      VARCHAR(10)  NOT NULL DEFAULT 'ETC' COMMENT '유입 경로 : INTRO 지인·환자 소개 / TRANS 타 병원 전원 / WEB 인터넷 / ADS 광고·현수막 / ETC 기타',
  COND_MEMO    VARCHAR(300) NULL     COMMENT '환자 상태·질환·요구사항',
  STAGE        CHAR(2)      NOT NULL DEFAULT '10' COMMENT '10 상담 20 방문 30 입원결정 40 입원 50 퇴원후 90 종결',
  PLAN_DT      CHAR(8)      NULL     COMMENT '방문·입원 예정일',
  NEXT_DT      CHAR(8)      NULL     COMMENT '다음 할 일 날짜(연락·방문 약속)',
  NEXT_MEMO    VARCHAR(200) NULL     COMMENT '다음 할 일',
  ADMIT_DT     CHAR(8)      NULL     COMMENT '입원일(자동 매칭 또는 수기)',
  DISCH_DT     CHAR(8)      NULL     COMMENT '퇴원일',
  MATCH_YN     CHAR(1)      NOT NULL DEFAULT 'N' COMMENT '입퇴원현황으로 확인됨',
  CLOSE_RSN    VARCHAR(100) NULL     COMMENT '종결 사유(타병원 입원·보류·사망 등)',
  USE_YN       CHAR(1)      NOT NULL DEFAULT 'Y',
  REG_DTTM     DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  REG_USER     VARCHAR(50)  NULL,
  UPD_DTTM     DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UPD_USER     VARCHAR(50)  NULL,
  PRIMARY KEY (LEAD_SEQ),
  KEY IX_MIS_LEAD_HOSP (HOSP_CD, USE_YN, STAGE),
  KEY IX_MIS_LEAD_KEY  (HOSP_CD, BIRTH6, PAT_NM)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='MIS 신규환자 상담 접수';

-- ── ② 상담 이력(단계 변경·메모) ──────────────────────────────────────
CREATE TABLE IF NOT EXISTS TBL_MIS_LEAD_LOG (
  LOG_SEQ   BIGINT       NOT NULL AUTO_INCREMENT,
  LEAD_SEQ  BIGINT       NOT NULL,
  HOSP_CD   VARCHAR(10)  NOT NULL,
  LOG_DT    CHAR(8)      NOT NULL,
  STAGE     CHAR(2)      NULL     COMMENT '이때의 단계',
  MEMO      VARCHAR(500) NULL,
  REG_DTTM  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  REG_USER  VARCHAR(50)  NULL,
  PRIMARY KEY (LOG_SEQ),
  KEY IX_MIS_LEAD_LOG (HOSP_CD, LEAD_SEQ, LOG_DT)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='MIS 상담 이력';

-- ── ③ 퇴원 환자 안부 연락 — 입퇴원현황의 퇴원 건 단위 ──────────────────
CREATE TABLE IF NOT EXISTS TBL_MIS_FOLLOW (
  HOSP_CD   VARCHAR(10)  NOT NULL,
  BIRTH6    CHAR(6)      NOT NULL,
  IPWON_DT  CHAR(8)      NOT NULL COMMENT '입원일 — 입퇴원현황 키',
  TEWON_DT  CHAR(8)      NOT NULL COMMENT '퇴원일',
  DONE_YN   CHAR(1)      NOT NULL DEFAULT 'N' COMMENT '연락함',
  DONE_DT   CHAR(8)      NULL,
  RESULT_CD VARCHAR(10)  NULL     COMMENT 'HOME 잘 지냄 / READMIT 재입원 희망 / OTHER 타병원 / NOANS 연락 안 됨 / ETC',
  MEMO      VARCHAR(300) NULL,
  REG_DTTM  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  REG_USER  VARCHAR(50)  NULL,
  UPD_DTTM  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UPD_USER  VARCHAR(50)  NULL,
  PRIMARY KEY (HOSP_CD, BIRTH6, IPWON_DT, TEWON_DT)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='MIS 퇴원 환자 안부 연락';

-- 확인
-- SELECT TABLE_NAME, TABLE_COMMENT FROM information_schema.TABLES WHERE TABLE_SCHEMA='WNN' AND TABLE_NAME LIKE 'TBL_MIS_%';
