-- =====================================================================
-- QPS(질향상·환자안전) 위너넷 이식 — 1단계 DDL
--   근거: saynice.co.kr MSSQL SUNWOO DB 실측 (docs/proposals/QPS_*.md)
--   대상: WNN (MySQL). CHARSET 미지정 → DB 기본값 상속(기존 테이블과 일치)
--   ★적용은 사용자가 직접 (여기서는 실행하지 않음)
--
--   ★적용 대상 DB (2026-08-08 확정) : WNN @ 114.108.153.178:3306  (계정 winner)
--     — 별도 스키마/서버로 빼지 않고 기존 WNN 안에 둔다(사용자 결정).
--     — 대신 QPS 자료는 **전부 `TBL_QPS_` 접두어**로 시작해 기존 70개 테이블과 한눈에 구분된다.
--       기존 테이블과의 이름 충돌 0건 확인(2026-08-08 실측: TBL_EVAL_REPORT_*, TBL_REPORT_MST,
--       TBL_PAT_INDI 등과 겹치지 않음).
--     — 병원·사용자 정보는 **새로 만들지 않는다**(위너넷 것을 HOSP_CD 로 참조 — 중복 금지, 사용자 지시).
--
--   설계 원칙
--   · 병원 구분은 HOSP_CD (SUNWOO 의 COMPANY 를 대체 — 사용자·거래처는 위너넷 기반, 확정)
--   · 지표의 '정의·산식'은 코드가 아니라 데이터(TBL_QPS_INDI_MST)
--   · 분기/월 보고서의 수치는 저장이 아니라 산출 (TBL_EVAL_REPORT 와 같은 사상)
-- =====================================================================

-- ① 지표 마스터 — 화면 [지표정의서] 가 이 표의 편집 화면이 된다
--    SUNWOO 지표정의서 14종(B000019~B000098)에 대응. 정의문구는 채록되는 대로 UPDATE.
CREATE TABLE IF NOT EXISTS TBL_QPS_INDI_MST (
  INDI_SEQ     BIGINT       NOT NULL AUTO_INCREMENT,
  HOSP_CD      VARCHAR(20)  NOT NULL,                  -- 요양기관기호 (공통정의는 '*' 로 둔다)
  INDI_CD      VARCHAR(20)  NOT NULL,                  -- FALL, BEDSORE, HANDWASH, RESTRAINT ...
  INDI_NM      VARCHAR(100) NOT NULL,                  -- 낙상 발생 보고율
  DEFINITION   VARCHAR(500) NULL,                      -- 환자 1,000 재원일당 낙상 발생 건수의 비율
  NUMER_DESC   VARCHAR(300) NULL,                      -- 분자 설명: 낙상 발생 보고 건수(Level 2 이상)
  DENOM_DESC   VARCHAR(300) NULL,                      -- 분모 설명: 재원환자 연인원수
  DENOM_GB     VARCHAR(20)  NULL,                      -- 분모 원천: INDAYS(총재원일수)/PATCNT/STAFF/SURVEY/ORDER
  NUMER_SRC    VARCHAR(20)  NULL DEFAULT 'INCIDENT',   -- 분자 원천: INCIDENT(사고보고) / MONITOR(관찰) / MANUAL(수기)
  INCID_GB     VARCHAR(20)  NULL,                      -- NUMER_SRC='INCIDENT' 일 때 셀 대상 (TBL_QPS_INCIDENT.INCID_GB)
  MIN_LEVEL    TINYINT      NULL,                      -- 분자 포함 최소 위해등급 (낙상=2 → 'Level 2 이상'). NULL=전건
  MULTIPLIER   INT          NULL DEFAULT 1000,         -- 상수 (1000 → ‰, 100 → %)
  UNIT         VARCHAR(10)  NULL DEFAULT '‰',
  DECIMALS     TINYINT      NULL DEFAULT 2,            -- 표시 소수자리
  CYCLE_GB     VARCHAR(10)  NULL DEFAULT 'Q',          -- M(월)/Q(분기)/H(반기)/Y(년)
  SOURCE_NM    VARCHAR(100) NULL,                      -- 자료원: 환자안전사고보고서
  METHOD_NM    VARCHAR(100) NULL,                      -- 집계방법: 통계집계프로그램
  OWNER_NM     VARCHAR(50)  NULL,                      -- 담당: QPS담당자
  TARGET_VAL   DECIMAL(10,3) NULL,                     -- 목표값(있으면)
  SORT_NO      INT          NULL DEFAULT 0,
  USE_YN       CHAR(1)      NOT NULL DEFAULT 'Y',
  REG_USER     VARCHAR(50)  NULL,
  REG_DTTM     DATETIME     NULL DEFAULT CURRENT_TIMESTAMP,
  UPD_USER     VARCHAR(50)  NULL,
  UPD_DTTM     DATETIME     NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (INDI_SEQ),
  UNIQUE KEY UK_QPS_INDI (HOSP_CD, INDI_CD)
);

-- ② 분모 마스터 — SUNWOO T_PATIENTCNT(GUBUN, IN_YEAR, M01~M12) 구조 그대로
--    월별 총재원일수·직원수. 모든 지표의 분모가 여기서 나온다.
CREATE TABLE IF NOT EXISTS TBL_QPS_CENSUS (
  CENSUS_SEQ  BIGINT      NOT NULL AUTO_INCREMENT,
  HOSP_CD     VARCHAR(20) NOT NULL,
  CENSUS_GB   VARCHAR(20) NOT NULL,                    -- INDAYS(총재원일수) / STAFF(월별직원수) / PATCNT(재원환자수)
  IN_YEAR     VARCHAR(4)  NOT NULL,
  M01 INT NULL, M02 INT NULL, M03 INT NULL, M04 INT NULL,
  M05 INT NULL, M06 INT NULL, M07 INT NULL, M08 INT NULL,
  M09 INT NULL, M10 INT NULL, M11 INT NULL, M12 INT NULL,
  NOTE        VARCHAR(255) NULL,
  USE_YN      CHAR(1)     NOT NULL DEFAULT 'Y',
  REG_USER    VARCHAR(50) NULL,
  REG_DTTM    DATETIME    NULL DEFAULT CURRENT_TIMESTAMP,
  UPD_USER    VARCHAR(50) NULL,
  UPD_DTTM    DATETIME    NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (CENSUS_SEQ),
  UNIQUE KEY UK_QPS_CENSUS (HOSP_CD, CENSUS_GB, IN_YEAR)
);

-- ③ 사고 건별 — SUNWOO 「04 보고서」 8종의 입력이 전부 여기로 들어온다(INCID_GB 로 구분)
--    분류 축(연령·장소·시간·유형·손상·부서)은 지표분석보고서의 집계 축과 1:1
CREATE TABLE IF NOT EXISTS TBL_QPS_INCIDENT (
  INCID_SEQ    BIGINT       NOT NULL AUTO_INCREMENT,
  HOSP_CD      VARCHAR(20)  NOT NULL,
  INCID_GB     VARCHAR(20)  NOT NULL,                  -- FALL/BEDSORE/PTSAFE/STAFFSAFE/ABUSE/SECURITY/HAZMAT/INFEXP
  OCCUR_DT     VARCHAR(8)   NOT NULL,                  -- YYYYMMDD (위너넷 관용구)
  OCCUR_TM     VARCHAR(4)   NULL,                      -- HHMM
  WARD_CD      VARCHAR(20)  NULL,                      -- 병동/부서
  RPT_DEPT     VARCHAR(50)  NULL,                      -- 보고부서
  PT_NO        VARCHAR(30)  NULL,                      -- 환자등록번호(최소식별)
  PT_SEX       CHAR(1)      NULL,
  PT_AGE       INT          NULL,
  LEVEL_CD     VARCHAR(10)  NULL,                      -- 위해정도(Level 1~) ※낙상 분자 = Level 2 이상
  TYPE_CD      VARCHAR(20)  NULL,                      -- 사고유형
  SUBTYPE_CD   VARCHAR(20)  NULL,                      -- 세부유형(낙상유형 등)
  PLACE_CD     VARCHAR(20)  NULL,                      -- 발생장소
  DAMAGE_CD    VARCHAR(20)  NULL,                      -- 손상유형
  CAUSE_TXT    VARCHAR(1000) NULL,
  ACTION_TXT   VARCHAR(1000) NULL,
  RPT_USER     VARCHAR(50)  NULL,                      -- 보고자
  STATUS       VARCHAR(10)  NOT NULL DEFAULT 'DRAFT',  -- DRAFT/SUBMIT/CONFIRM
  CONFIRM_USER VARCHAR(50)  NULL,
  CONFIRM_DTTM DATETIME     NULL,
  USE_YN       CHAR(1)      NOT NULL DEFAULT 'Y',      -- 소프트삭제
  REG_USER     VARCHAR(50)  NULL,
  REG_DTTM     DATETIME     NULL DEFAULT CURRENT_TIMESTAMP,
  UPD_USER     VARCHAR(50)  NULL,
  UPD_DTTM     DATETIME     NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (INCID_SEQ),
  KEY IX_QPS_INCID (HOSP_CD, INCID_GB, OCCUR_DT)
);

-- ④ 관찰·조사형 지표 — 손위생 모니터링, 라운딩 점검 등 (분자/분모가 둘 다 관찰건수)
CREATE TABLE IF NOT EXISTS TBL_QPS_MONITOR (
  MON_SEQ     BIGINT      NOT NULL AUTO_INCREMENT,
  HOSP_CD     VARCHAR(20) NOT NULL,
  INDI_CD     VARCHAR(20) NOT NULL,                    -- HANDWASH, ROUNDING ...
  OBS_DT      VARCHAR(8)  NOT NULL,
  WARD_CD     VARCHAR(20) NULL,
  JOB_GB      VARCHAR(20) NULL,                        -- 직군(의사/간호사/기타)
  MOMENT_CD   VARCHAR(20) NULL,                        -- 손위생 5 moments 등
  OBS_CNT     INT         NOT NULL DEFAULT 0,          -- 관찰건수(분모)
  PASS_CNT    INT         NOT NULL DEFAULT 0,          -- 수행건수(분자)
  OBSERVER    VARCHAR(50) NULL,
  NOTE        VARCHAR(500) NULL,
  USE_YN      CHAR(1)     NOT NULL DEFAULT 'Y',
  REG_USER    VARCHAR(50) NULL,
  REG_DTTM    DATETIME    NULL DEFAULT CURRENT_TIMESTAMP,
  UPD_USER    VARCHAR(50) NULL,
  UPD_DTTM    DATETIME    NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (MON_SEQ),
  KEY IX_QPS_MON (HOSP_CD, INDI_CD, OBS_DT)
);

-- ⑤ 지표 집계 스냅샷 — 확정(마감)된 기간만 저장. 미확정 기간은 실시간 산출.
CREATE TABLE IF NOT EXISTS TBL_QPS_STAT (
  STAT_SEQ   BIGINT        NOT NULL AUTO_INCREMENT,
  HOSP_CD    VARCHAR(20)   NOT NULL,
  INDI_CD    VARCHAR(20)   NOT NULL,
  PRD_GB     VARCHAR(10)   NOT NULL,                   -- M/Q/H/Y
  PRD_KEY    VARCHAR(10)   NOT NULL,                   -- 202601 / 2026Q1 / 2026H1 / 2026
  NUMER      DECIMAL(14,3) NULL,                       -- 분자
  DENOM      DECIMAL(14,3) NULL,                       -- 분모
  RATE       DECIMAL(14,3) NULL,                       -- 분자/분모*상수
  CONFIRM_YN CHAR(1)       NOT NULL DEFAULT 'N',       -- 확정(마감)
  CONFIRM_USER VARCHAR(50) NULL,
  CONFIRM_DTTM DATETIME    NULL,
  REG_DTTM   DATETIME      NULL DEFAULT CURRENT_TIMESTAMP,
  UPD_DTTM   DATETIME      NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (STAT_SEQ),
  UNIQUE KEY UK_QPS_STAT (HOSP_CD, INDI_CD, PRD_GB, PRD_KEY)
);

-- ⑥ 지표분석보고서 — 수치는 ⑤에서 오고, 여기에는 서술·상태·서명만 (TBL_EVAL_REPORT 와 같은 사상)
CREATE TABLE IF NOT EXISTS TBL_QPS_REPORT (
  RPT_SEQ    BIGINT       NOT NULL AUTO_INCREMENT,
  HOSP_CD    VARCHAR(20)  NOT NULL,
  INDI_CD    VARCHAR(20)  NOT NULL,
  PRD_GB     VARCHAR(10)  NOT NULL,
  PRD_KEY    VARCHAR(10)  NOT NULL,
  TITLE      VARCHAR(200) NULL,
  ANALYSIS_TXT LONGTEXT   NULL,                        -- 분석(SUNWOO cxMemo1)
  PLAN_TXT     LONGTEXT   NULL,                        -- 개선계획(cxMemo2)
  ACT1_TXT VARCHAR(200) NULL, ACT2_TXT VARCHAR(200) NULL,
  ACT3_TXT VARCHAR(200) NULL, ACT4_TXT VARCHAR(200) NULL,   -- 개선활동 4칸
  STATUS     VARCHAR(10)  NOT NULL DEFAULT 'DRAFT',    -- DRAFT/SUBMIT/CONFIRM
  SIGN1_USER VARCHAR(50)  NULL, SIGN1_DTTM DATETIME NULL,   -- 담당 (SUNWOO img_A)
  SIGN2_USER VARCHAR(50)  NULL, SIGN2_DTTM DATETIME NULL,   -- 팀장 (img_B)
  SNAPSHOT_JSON LONGTEXT  NULL,                        -- 확정 시 수치 동결
  REG_USER   VARCHAR(50)  NULL,
  REG_DTTM   DATETIME     NULL DEFAULT CURRENT_TIMESTAMP,
  UPD_USER   VARCHAR(50)  NULL,
  UPD_DTTM   DATETIME     NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (RPT_SEQ),
  UNIQUE KEY UK_QPS_REPORT (HOSP_CD, INDI_CD, PRD_GB, PRD_KEY)
);

-- =====================================================================
-- 시드: 지표 18종
--   ★근거 = T_MENU 회사별 비교(2026-08-08). 「지표정의서」(9종)보다 「지표분석보고서」(16계열)가
--     넓다 — 정의서가 없는 지표(환자안전·자살자해·격리지침·강박지침·요로감염)가 분석보고서에는 있다.
--     → 지표 집합은 **두 트리의 합집합**으로 잡는다.
--   ★회사별 차이: 0001(SRC)만 정의서에 투약·학대폭력·직원감염노출·재택복귀율·요로감염이 더 있고,
--     0000/1000/2000 은 같은 자리를 '의료서비스'(=0001 의 '환자만족도')로 쓴다. → HOSP_CD 별 덮어쓰기로 흡수.
--   ★낙상만 정의·분자·분모 확정(DB 실측·검산 완료). 나머지는 이름만 — 채록되는 대로 UPDATE.
--   HOSP_CD='*' = 공통정의(병원별로 다르면 그 병원 행을 추가해 덮어쓴다)
--   RPT_CYCLE : Q4=분기 4회만 / Q4MF=분기 4회 + 중간 + 최종  (SUNWOO 트리의 실제 구성)
-- =====================================================================
INSERT INTO TBL_QPS_INDI_MST
 (HOSP_CD, INDI_CD, INDI_NM, DEFINITION, NUMER_DESC, DENOM_DESC, DENOM_GB, MULTIPLIER, UNIT, CYCLE_GB, SOURCE_NM, METHOD_NM, OWNER_NM, SORT_NO,
  NUMER_SRC, INCID_GB, MIN_LEVEL)
VALUES
 -- ✅확정 (실측·검산 완료) — 이 한 행이 낙상 파일럿의 산식 전부다
 ('*','FALL','낙상 발생 보고율',
  '환자 1,000 재원일당 낙상 발생 건수의 비율',
  '낙상 발생 보고 건수(Level 2 이상)',
  '재원환자 연인원수(해당 기간 일일 재원환자 수의 합)',
  'INDAYS', 1000, '‰', 'Q', '환자안전사고보고서', '통계집계프로그램', 'QPS담당자', 1,
  'INCIDENT', 'FALL', 2),
 -- ⬜미채록 (아래 MULTIPLIER/UNIT/DENOM_GB 는 전부 **잠정값** — 지표정의서 채록 후 UPDATE)
 ('*','HANDWASH'  ,'손위생 수행률'        ,NULL,NULL,NULL,NULL    , 100,'%','Q',NULL,NULL,NULL, 2,'MONITOR',NULL,NULL),  -- 정의서○ 분석○(중간·최종)
 ('*','BEDSORE'   ,'욕창 발생률'          ,NULL,NULL,NULL,'INDAYS',1000,'‰','Q',NULL,NULL,NULL, 3,'INCIDENT','BEDSORE'  ,NULL),  -- 정의서○ 분석○(중간·최종)
 ('*','RESTRAINT' ,'신체보호대 사용률'    ,NULL,NULL,NULL,'INDAYS',1000,'‰','Q',NULL,NULL,NULL, 4,'MANUAL'  ,NULL       ,NULL),  -- 정의서○ 분석○(4분기)
 ('*','STAFFSAFE' ,'직원안전사고 발생률'  ,NULL,NULL,NULL,'STAFF' , 100,'%','Q',NULL,NULL,NULL, 5,'INCIDENT','STAFFSAFE',NULL),  -- 정의서○ 분석○(4분기)
 ('*','PTSAFE'    ,'환자안전사고 발생률'  ,NULL,NULL,NULL,'INDAYS',1000,'‰','Q',NULL,NULL,NULL, 6,'INCIDENT','PTSAFE'   ,NULL),  -- 정의서✕ 분석○(중간·최종)
 ('*','TATIMG'    ,'영상 TAT 충족률'      ,NULL,NULL,NULL,NULL    , 100,'%','Q',NULL,NULL,NULL, 7,'MANUAL'  ,NULL       ,NULL),  -- 정의서○ 분석○(4분기)
 ('*','TATLAB'    ,'검체 TAT 충족률'      ,NULL,NULL,NULL,NULL    , 100,'%','Q',NULL,NULL,NULL, 8,'MANUAL'  ,NULL       ,NULL),  -- 정의서○ 분석○(4분기)
 ('*','MEDICATION','투약오류 발생률'      ,NULL,NULL,NULL,NULL    ,1000,'‰','Q',NULL,NULL,NULL, 9,'INCIDENT','MEDICATION',NULL), -- 정의서△(0001만) 분석○(중간·최종)
 ('*','ABUSE'     ,'학대 및 폭력 발생률'  ,NULL,NULL,NULL,'INDAYS',1000,'‰','Q',NULL,NULL,NULL,10,'INCIDENT','ABUSE'    ,NULL),  -- 정의서△ 분석○(4분기)
 ('*','HOMERET'   ,'재택 복귀율'          ,NULL,NULL,NULL,NULL    , 100,'%','Q',NULL,NULL,NULL,11,'MANUAL'  ,NULL       ,NULL),  -- 정의서△ 분석○(4분기)
 ('*','SUICIDE'   ,'자살·자해 발생률'     ,NULL,NULL,NULL,'INDAYS',1000,'‰','Q',NULL,NULL,NULL,12,'INCIDENT','SUICIDE'  ,NULL),  -- 정의서✕ 분석○(중간·최종)
 ('*','ISOLATION' ,'격리지침 준수율'      ,NULL,NULL,NULL,NULL    , 100,'%','Q',NULL,NULL,NULL,13,'MONITOR' ,NULL       ,NULL),  -- 정의서✕ 분석○(중간·최종)
 ('*','SECLUSION' ,'강박지침 준수율'      ,NULL,NULL,NULL,NULL    , 100,'%','Q',NULL,NULL,NULL,14,'MONITOR' ,NULL       ,NULL),  -- 정의서✕ 분석○(중간·최종)
 ('*','UTI'       ,'요로감염 발생률'      ,NULL,NULL,NULL,'INDAYS',1000,'‰','Q',NULL,NULL,NULL,15,'INCIDENT','UTI'      ,NULL),  -- 정의서△ 분석○(4분기)
 ('*','INFEXP'    ,'직원 감염노출 발생률' ,NULL,NULL,NULL,'STAFF' , 100,'%','Q',NULL,NULL,NULL,16,'INCIDENT','INFEXP'   ,NULL),  -- 정의서△ 분석○(감염 트리, 중간·최종)
 ('*','CLAIM'     ,'불만고충 처리율'      ,NULL,NULL,NULL,NULL    , 100,'%','H',NULL,NULL,NULL,17,'MANUAL'  ,NULL       ,NULL),  -- 정의서○ 분석○(상·하반기)
 ('*','SATISFY'   ,'환자만족도(의료서비스)',NULL,NULL,NULL,NULL   , 100,'%','Y',NULL,NULL,NULL,18,'MANUAL'  ,NULL       ,NULL);  -- 정의서○ 분석○(연 1회+점수판)
-- 범례: 정의서 ○=전 회사 / △=0001(SRC)만 / ✕=정의서 없음(분석보고서만 존재)
