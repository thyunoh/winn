-- =====================================================================
-- MIS(경영고객관리) EMR 엑셀 연계 — DDL (2026-10-11)
--   왜 : 닥터스(Doctors) EMR 과 직접 연계가 안 된다. 병원이 EMR 에서 엑셀로 내려받아 올리면
--        수납·연락처·입퇴원·인력 자료가 MIS 화면들에 이어지게 한다. 견본 양식이 없어
--        «올릴 때 엑셀 머리글 ↔ 필드를 사람이 맞추고(자동 추천), 그 맞춤을 병원·자료별로 기억»한다.
--   원칙 :
--     · 자료 구분(DATA_GB) : PAY 수납·진료비(수납대장) / ACT 행위별 통계 / CONTACT 환자·보호자 연락처 / IPWON 입퇴원현황 / STAFF 직원·근무
--     · IPWON 은 새 표를 만들지 않는다 — 기존 입퇴원현황(TBL_IPWON_INFO)에 기존 업로드(/main/saveExcelDatas.do)와 똑같이 들어간다
--       (적정성평가·자동 매칭이 이미 그 표를 본다). 여기서는 맞춤(MAP)과 올린 이력(UPLOAD)만 남긴다.
--     · PAY·ACT·STAFF = 연월 단위로 «지우고 다시 넣기»(같은 달을 다시 올리면 대체) · CONTACT = 병원 단위 최신본(올릴 때마다 통째 대체).
--     · 주민번호 전체는 받지 않는다 — 생년월일 6자리(BIRTH6)만(입퇴원 자동 매칭 키와 같은 규칙).
--   더하기만 하는 DDL(CREATE IF NOT EXISTS) ⇒ 운영 선적용 안전. ⛔이 DDL 을 먼저 → WAR 재빌드·재기동
--   (신규환자 고객관리의 퇴원 안부 목록이 TBL_MIS_EMR_CONTACT 를 읽는다 — 표가 없으면 그 목록이 오류).
--   코드 : Mis_SQL.xml(emr*) · MisMapper/Service(Impl)/Controller(emr*) · misEmr.jsp
-- =====================================================================

-- ── ① 엑셀 머리글 맞춤(병원 × 자료 구분 하나) ──────────────────────────────
CREATE TABLE IF NOT EXISTS TBL_MIS_EMR_MAP (
  HOSP_CD   VARCHAR(10)  NOT NULL,
  DATA_GB   VARCHAR(10)  NOT NULL COMMENT 'PAY/CONTACT/IPWON/STAFF',
  MAP_JSON  TEXT         NULL     COMMENT '{필드키: 엑셀 머리글} — 화면이 그대로 저장·복원',
  HDR_ROW   INT          NULL     COMMENT '머리글 줄 번호(1부터) — 위에 제목 줄이 있는 엑셀',
  REG_DTTM  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UPD_DTTM  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UPD_USER  VARCHAR(50)  NULL,
  PRIMARY KEY (HOSP_CD, DATA_GB)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='MIS EMR 엑셀 머리글 맞춤';

-- ── ② 올린 이력 ───────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS TBL_MIS_EMR_UPLOAD (
  UP_SEQ    BIGINT       NOT NULL AUTO_INCREMENT,
  HOSP_CD   VARCHAR(10)  NOT NULL,
  DATA_GB   VARCHAR(10)  NOT NULL,
  YYYYMM    CHAR(6)      NULL     COMMENT '대상 연월(CONTACT 는 비움)',
  FILE_NM   VARCHAR(200) NULL,
  ROW_CNT   INT          NOT NULL DEFAULT 0 COMMENT '저장한 줄',
  SKIP_CNT  INT          NOT NULL DEFAULT 0 COMMENT '합계·빈 줄 등 뺀 줄',
  DEL_CNT   INT          NOT NULL DEFAULT 0 COMMENT '대체되어 지운 옛 줄',
  REG_DTTM  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  REG_USER  VARCHAR(50)  NULL,
  PRIMARY KEY (UP_SEQ),
  KEY IX_MIS_EMR_UP (HOSP_CD, DATA_GB, REG_DTTM)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='MIS EMR 엑셀 올린 이력';

-- ── ③ 수납·진료비 내역(연월 단위 대체) ─────────────────────────────────
CREATE TABLE IF NOT EXISTS TBL_MIS_EMR_PAY (
  HOSP_CD     VARCHAR(10)   NOT NULL,
  YYYYMM      CHAR(6)       NOT NULL,
  SEQ_NUM     INT           NOT NULL,
  PAY_DT      CHAR(8)       NULL     COMMENT '수납일 YYYYMMDD',
  CHARTNO     VARCHAR(30)   NULL,
  PAT_NM      VARCHAR(50)   NULL,
  BIRTH6      CHAR(6)       NULL,
  INOUT_GB    VARCHAR(20)   NULL     COMMENT '입원/외래 (엑셀 글자 그대로)',
  INSUR_NM    VARCHAR(30)   NULL     COMMENT '보험 유형',
  DEPT_NM     VARCHAR(30)   NULL,
  TOT_AMT     BIGINT        NULL     COMMENT '총진료비',
  INS_AMT     BIGINT        NULL     COMMENT '공단(청구) 부담',
  SELF_AMT    BIGINT        NULL     COMMENT '본인부담(급여)',
  NONPAY_AMT  BIGINT        NULL     COMMENT '비급여',
  PAID_AMT    BIGINT        NULL     COMMENT '수납액',
  UNPAID_AMT  BIGINT        NULL     COMMENT '미수액',
  PAY_METHOD  VARCHAR(30)   NULL     COMMENT '수납 방법(현금·카드…)',
  MEMO        VARCHAR(200)  NULL,
  REG_DTTM    DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
  REG_USER    VARCHAR(50)   NULL,
  PRIMARY KEY (HOSP_CD, YYYYMM, SEQ_NUM),
  KEY IX_MIS_EMR_PAY_KEY (HOSP_CD, BIRTH6, PAT_NM)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='MIS EMR 수납·진료비 내역';

-- ── ③-2 행위별 통계(연월 단위 대체) — 수납대장과 별개로 EMR 의 「행위별 통계」 엑셀. 한 줄 = 행위 분류 하나(수가코드·명칭은 받지 않는다 — 2026-10-11 사용자) ──
CREATE TABLE IF NOT EXISTS TBL_MIS_EMR_ACT (
  HOSP_CD     VARCHAR(10)    NOT NULL,
  YYYYMM      CHAR(6)        NOT NULL,
  SEQ_NUM     INT            NOT NULL,
  ACT_GB      VARCHAR(50)    NOT NULL COMMENT '행위 분류(진찰료·입원료·처치·검사·투약·주사·재활…, 엑셀 글자 그대로)',
  PAY_GB      VARCHAR(20)    NULL     COMMENT '급여 구분(급여·비급여·100/100…)',
  INOUT_GB    VARCHAR(20)    NULL     COMMENT '입원/외래',
  DEPT_NM     VARCHAR(30)    NULL,
  UNIT_PRICE  BIGINT         NULL     COMMENT '단가',
  ACT_CNT     DECIMAL(12,1)  NULL     COMMENT '횟수(수량×일수)',
  PAT_CNT     INT            NULL     COMMENT '환자 수(실인원)',
  TOT_AMT     BIGINT         NULL     COMMENT '금액',
  INS_AMT     BIGINT         NULL     COMMENT '공단(청구) 부담',
  SELF_AMT    BIGINT         NULL     COMMENT '본인부담',
  MEMO        VARCHAR(200)   NULL,
  REG_DTTM    DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
  REG_USER    VARCHAR(50)    NULL,
  PRIMARY KEY (HOSP_CD, YYYYMM, SEQ_NUM),
  KEY IX_MIS_EMR_ACT_GB (HOSP_CD, ACT_GB, YYYYMM)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='MIS EMR 행위별 통계';

-- ── ④ 환자·보호자 연락처(병원 단위 최신본) ──────────────────────────────
CREATE TABLE IF NOT EXISTS TBL_MIS_EMR_CONTACT (
  HOSP_CD    VARCHAR(10)   NOT NULL,
  SEQ_NUM    INT           NOT NULL,
  CHARTNO    VARCHAR(30)   NULL,
  PAT_NM     VARCHAR(50)   NULL,
  BIRTH6     CHAR(6)       NULL,
  GENDER     VARCHAR(5)    NULL,
  TEL        VARCHAR(30)   NULL     COMMENT '환자 연락처',
  GUARD_NM   VARCHAR(50)   NULL,
  GUARD_REL  VARCHAR(20)   NULL,
  GUARD_TEL  VARCHAR(30)   NULL,
  ADDR       VARCHAR(200)  NULL,
  MEMO       VARCHAR(200)  NULL,
  REG_DTTM   DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
  REG_USER   VARCHAR(50)   NULL,
  PRIMARY KEY (HOSP_CD, SEQ_NUM),
  KEY IX_MIS_EMR_CT_KEY (HOSP_CD, BIRTH6, PAT_NM),
  KEY IX_MIS_EMR_CT_CHART (HOSP_CD, CHARTNO)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='MIS EMR 환자·보호자 연락처';

-- ── ⑤ 직원·근무 현황(연월 단위 대체) ───────────────────────────────────
CREATE TABLE IF NOT EXISTS TBL_MIS_EMR_STAFF (
  HOSP_CD     VARCHAR(10)   NOT NULL,
  YYYYMM      CHAR(6)       NOT NULL,
  SEQ_NUM     INT           NOT NULL,
  EMP_NO      VARCHAR(30)   NULL     COMMENT '사번',
  EMP_NM      VARCHAR(50)   NULL,
  JOB_NM      VARCHAR(30)   NULL     COMMENT '직종(의사·간호사·간호조무사·물리치료사…)',
  DEPT_NM     VARCHAR(30)   NULL     COMMENT '부서·병동',
  WORK_GB     VARCHAR(20)   NULL     COMMENT '근무 형태(정규·계약·시간제…)',
  JOIN_DT     CHAR(8)       NULL,
  RETIRE_DT   CHAR(8)       NULL,
  WORK_DAYS   DECIMAL(6,1)  NULL     COMMENT '근무일수',
  WORK_HOURS  DECIMAL(7,1)  NULL     COMMENT '근무시간',
  NIGHT_CNT   DECIMAL(5,1)  NULL     COMMENT '야간 근무 횟수',
  PAY_AMT     BIGINT        NULL     COMMENT '급여(인건비)',
  MEMO        VARCHAR(200)  NULL,
  REG_DTTM    DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
  REG_USER    VARCHAR(50)   NULL,
  PRIMARY KEY (HOSP_CD, YYYYMM, SEQ_NUM)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='MIS EMR 직원·근무 현황';
