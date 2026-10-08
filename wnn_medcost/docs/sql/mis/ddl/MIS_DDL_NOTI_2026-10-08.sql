-- =====================================================================
-- MIS(경영관리) ③-2 업무 알림 — 문자·메일 발송 DDL (2026-10-08)
--   왜 : 업무 알림(misAlert)은 로그인해야 보인다. 담당자가 들어오지 않는 날도 「급함·할 일」이 메일·문자로 가야 알림이 된다(제안서 ③ 업무 자동화 2차).
--   원칙 :
--     · 받는 사람은 병원이 직접 등록(TBL_MIS_NOTI_USER) — 계정 표(TBL_USER_MST)의 메일·전화는 「가져오기」 후보로만 쓴다(그 표를 고치지 않는다).
--     · 한 사람마다 채널(메일/문자) · 자동 발송 주기(매일/매주 월요일/수동만) · 받을 단계(급함만/급함+할 일)를 따로 둔다.
--     · 보낸 것은 전부 TBL_MIS_NOTI_LOG 에 남긴다(누구에게·무엇을·결과). 실패·건너뜀도 남긴다 — 「왜 안 왔나」의 답.
--     · 자동 발송은 하루 한 번만 돌아야 한다. 운영 톰캣에 같은 앱이 두 벌(ROOT·wnn_medcost-1.0.0) 올라가 있어 **TBL_MIS_NOTI_RUN(RUN_DT PK) 에 INSERT IGNORE 로 선점**한 쪽만 보낸다.
--   더하기만 하는 DDL ⇒ 운영 선적용 안전.
--   코드 : Mis_SQL.xml · MisMapper/Service(Impl)/Controller(noti*) · MisNotiScheduler · egovframework.util.SmsUtil · misAlert.jsp · context-common.xml(task) — ⛔WAR 재빌드+재기동
--   설정 : mail.properties 에 noti.auto.enabled=true(운영만) · 문자는 sms.* (mail.properties.sample 참조). 없으면 메일만 / 문자는 「설정 없음」으로 건너뛴다.
-- =====================================================================

-- ── ① 받는 사람 ──────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS TBL_MIS_NOTI_USER (
  NOTI_SEQ    BIGINT       NOT NULL AUTO_INCREMENT,
  HOSP_CD     VARCHAR(10)  NOT NULL,
  NAME        VARCHAR(50)  NOT NULL COMMENT '이름',
  ROLE_NM     VARCHAR(50)  NULL     COMMENT '역할(행정실장·심사과·원장…)',
  EMAIL       VARCHAR(100) NULL,
  TEL         VARCHAR(30)  NULL     COMMENT '휴대폰(문자)',
  MAIL_YN     CHAR(1)      NOT NULL DEFAULT 'Y',
  SMS_YN      CHAR(1)      NOT NULL DEFAULT 'N',
  AUTO_GB     CHAR(1)      NOT NULL DEFAULT 'W' COMMENT '자동 발송 : D 매일(평일) · W 매주 월요일 · N 수동만',
  MIN_LEVEL   VARCHAR(4)   NOT NULL DEFAULT 'warn' COMMENT '받을 단계 : bad 급함만 · warn 급함+할 일',
  USE_YN      CHAR(1)      NOT NULL DEFAULT 'Y',
  REG_DTTM    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  REG_USER    VARCHAR(50)  NULL,
  UPD_DTTM    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UPD_USER    VARCHAR(50)  NULL,
  PRIMARY KEY (NOTI_SEQ),
  KEY IX_MIS_NOTI_USER (HOSP_CD, USE_YN)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='MIS 업무 알림 받는 사람';

-- ── ② 발송 이력 ──────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS TBL_MIS_NOTI_LOG (
  LOG_SEQ     BIGINT       NOT NULL AUTO_INCREMENT,
  HOSP_CD     VARCHAR(10)  NOT NULL,
  CHANNEL     VARCHAR(5)   NOT NULL COMMENT 'MAIL / SMS',
  TO_ADDR     VARCHAR(100) NULL     COMMENT '받는 주소(메일) 또는 번호(문자)',
  TO_NAME     VARCHAR(50)  NULL,
  SUBJECT     VARCHAR(200) NULL,
  BODY        TEXT         NULL     COMMENT '보낸 본문(메일 HTML / 문자 글)',
  RESULT      VARCHAR(5)   NOT NULL COMMENT 'OK / FAIL / SKIP',
  ERR_MSG     VARCHAR(500) NULL,
  SENT_BY     VARCHAR(50)  NULL     COMMENT 'auto 또는 보낸 사용자 ID',
  LEVEL_CNT   VARCHAR(30)  NULL     COMMENT '급함/할 일 건수 (예: bad 1 · warn 2)',
  SENT_DTTM   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (LOG_SEQ),
  KEY IX_MIS_NOTI_LOG (HOSP_CD, LOG_SEQ)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='MIS 업무 알림 발송 이력';

-- ── ③ 자동 발송 선점 (하루 한 번) ────────────────────────────────────
CREATE TABLE IF NOT EXISTS TBL_MIS_NOTI_RUN (
  RUN_DT      CHAR(8)      NOT NULL COMMENT 'YYYYMMDD',
  RUN_HOST    VARCHAR(100) NULL     COMMENT '선점한 서버·컨텍스트',
  RUN_DTTM    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (RUN_DT)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='MIS 업무 알림 자동 발송 선점(하루 1회)';

-- 확인
-- SELECT * FROM TBL_MIS_NOTI_USER; SELECT * FROM TBL_MIS_NOTI_LOG ORDER BY LOG_SEQ DESC LIMIT 20; SELECT * FROM TBL_MIS_NOTI_RUN ORDER BY RUN_DT DESC LIMIT 5;
