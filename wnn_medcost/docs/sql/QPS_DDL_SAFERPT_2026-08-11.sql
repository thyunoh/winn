-- =====================================================================
-- 보고서 폴더 — 사고 유형별 보고서 (2026-08-11)
--
--   원본 트리 10종(+정신 별도). 실측 8종으로 확인된 것 :
--   ***골격은 같고 「체크박스 묶음」만 통째로 다르다.***
--     공통 = 결재란 + 대상정보 + (체크 묶음들) + 서술칸
--   ⇒ 감염종합보고처럼 「한 서식」으로 묶을 수는 없지만(묶음이 서식마다 다름),
--     ***지표 18종을 화면 하나로 처리한 방식***이 그대로 먹힌다 :
--       **공통 골격은 화면 하나, 체크박스 묶음은 데이터(항목표)로.**
--     감염 우선순위 사정 도구의 기본항목표(TBL_QPS_INFRISK_DEF)와 같은 구조다.
--
--   ★★사고 원천은 TBL_QPS_INCIDENT 를 재사용한다. 새로 입력받지 않는다 —
--     ***같은 사고를 지표용·보고서용으로 두 번 입력하게 만들면 지표를 자동산출로 바꾼 의미가 없다.***
--     보고서는 사고 건을 고르고 <상세 칸과 체크>만 더한다.
--
--   ★근접오류는 만들지 않는다 — 원본도 "준비중인 메뉴"다(2026-08-10 확인).
--   ★환자안전관리 라운딩 점검표는 이미 만든 서식 3호다.
--   ★정신 폴더(6종)는 병원별 on/off 장치가 필요해 별도 과제.
--
--   재실행 안전(CREATE TABLE IF NOT EXISTS + ON DUPLICATE KEY).
-- =====================================================================

-- ── 1. 유형 ─────────────────────────────────────────────────────────
INSERT INTO TBL_CODE_MST (CODE_CD, JOB_SEQ, CODE_NM, START_DT, END_DT, USE_YN, ACTION_YN, REG_USER) VALUES
 ('QPS_SAFERPT_GB',1,'사고 보고서 유형','20000101','99991231','Y','Y','system')
ON DUPLICATE KEY UPDATE CODE_NM=VALUES(CODE_NM), USE_YN='Y', ACTION_YN='Y';

INSERT INTO TBL_CODE_DTL (CODE_GB, CODE_CD, SUB_CODE, JOB_SEQ, SUB_CODE_NM, START_DT, END_DT, USE_YN, SORT, ACTION_YN, REG_USER) VALUES
 ('Q','QPS_SAFERPT_GB','PTSAFE' ,1,'환자안전사고 보고서'      ,'20000101','99991231','Y',1,'Y','system'),
 ('Q','QPS_SAFERPT_GB','BEDSORE',1,'욕창발생 보고서'          ,'20000101','99991231','Y',2,'Y','system'),
 ('Q','QPS_SAFERPT_GB','STAFF'  ,1,'직원안전 사고 보고서'      ,'20000101','99991231','Y',3,'Y','system'),
 ('Q','QPS_SAFERPT_GB','INFEXP' ,1,'직원 감염노출 사고 보고서' ,'20000101','99991231','Y',4,'Y','system'),
 ('Q','QPS_SAFERPT_GB','INFDIS' ,1,'감염성 질환 발생 보고서'   ,'20000101','99991231','Y',5,'Y','system'),
 ('Q','QPS_SAFERPT_GB','HAZMAT' ,1,'유해물질 노출 보고서'      ,'20000101','99991231','Y',6,'Y','system'),
 ('Q','QPS_SAFERPT_GB','SECU'   ,1,'보안안전 사고 보고서'      ,'20000101','99991231','Y',7,'Y','system'),
 ('Q','QPS_SAFERPT_GB','ABUSE'  ,1,'환자 학대 및 폭력 발생 신고서','20000101','99991231','Y',8,'Y','system'),
 ('Q','QPS_SAFERPT_GB','HARASS' ,1,'직원간 폭행/성희롱 사건 보고서','20000101','99991231','Y',9,'Y','system')
ON DUPLICATE KEY UPDATE SUB_CODE_NM=VALUES(SUB_CODE_NM), SORT=VALUES(SORT), USE_YN='Y', ACTION_YN='Y';


-- ── 2. 보고서 머리 ──────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS TBL_QPS_SAFERPT (
  SRP_SEQ    BIGINT       NOT NULL AUTO_INCREMENT,
  HOSP_CD    VARCHAR(20)  NOT NULL,
  IN_YEAR    CHAR(4)      NOT NULL,
  RPT_GB     VARCHAR(20)  NOT NULL COMMENT '유형 QPS_SAFERPT_GB',
  -- ★사고 연결 — 있으면 그 사고의 환자·일시·장소를 가져다 쓴다(두 번 입력 금지)
  INCID_SEQ  BIGINT       NULL COMMENT 'TBL_QPS_INCIDENT 연결(없으면 직접 입력)',
  OCCUR_DT   VARCHAR(8)   NULL COMMENT '발생일',
  OCCUR_TM   VARCHAR(5)   NULL COMMENT '발생시각 HH:MM',
  RPT_DT     VARCHAR(8)   NULL COMMENT '보고일',
  PLACE      VARCHAR(200) NULL COMMENT '발생장소',
  -- 대상 : 환자 서식이면 환자, 직원 서식이면 직원. 칸을 나누지 않고 이름으로 쓴다.
  TARGET_NM  VARCHAR(60)  NULL COMMENT '대상 성명(환자 또는 직원)',
  TARGET_NO  VARCHAR(40)  NULL COMMENT '등록번호 또는 사번',
  DEPT_NM    VARCHAR(60)  NULL COMMENT '부서',
  POSITION_NM VARCHAR(60) NULL COMMENT '직위',
  ADMIT_DT   VARCHAR(8)   NULL COMMENT '입원일(환자 서식)',
  DIAG_NM    VARCHAR(200) NULL COMMENT '진단명(환자 서식)',
  -- 육하원칙 사건개요 — 직원안전·유해물질이 쓰는 공유 블록
  W_WHEN  VARCHAR(300) NULL, W_WHO VARCHAR(300) NULL, W_WHAT VARCHAR(500) NULL,
  W_HOW   VARCHAR(500) NULL, W_WHY VARCHAR(500) NULL, W_WHERE VARCHAR(300) NULL,
  -- 서술 (서식마다 쓰는 것이 다르다. 안 쓰는 칸은 비워 둔다 — 표를 늘리지 않는다)
  SUMMARY    TEXT NULL COMMENT '사건경위 / 사고경위',
  VITAL_TXT  TEXT NULL COMMENT '활력징후',
  INJURY_TXT TEXT NULL COMMENT '신체손상정도 / 결과',
  TREAT_TXT  TEXT NULL COMMENT '치료내용 / 진료내역',
  CAUSE_TXT  TEXT NULL COMMENT '문제원인 / 발생원인',
  PLAN_TXT   TEXT NULL COMMENT '개선방안 / 사고 후 조치 / 처리결과',
  NOTE       TEXT NULL COMMENT '비고',
  USE_YN     CHAR(1)     NOT NULL DEFAULT 'Y',
  REG_USER   VARCHAR(50) NULL,
  REG_DTTM   DATETIME    NULL DEFAULT CURRENT_TIMESTAMP,
  UPD_USER   VARCHAR(50) NULL,
  UPD_DTTM   DATETIME    NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (SRP_SEQ),
  KEY IX_QPS_SAFERPT (HOSP_CD, IN_YEAR, RPT_GB, USE_YN),
  KEY IX_QPS_SAFERPT2 (INCID_SEQ)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='사고 유형별 보고서(한 서식 + 유형)';

-- 체크 결과 — 무엇을 골랐는가. 항목표(DEF)의 그룹·항목을 그대로 적는다.
--   ★코드가 아니라 <그룹코드 + 항목명>을 저장한다. 항목표를 고쳐도 옛 보고서의 내용이 남는다
--     (공통코드에서 SUB_CODE=저장값으로 간 것과 같은 판단 — 이원화하면 옛 자료가 '미상'이 된다).
CREATE TABLE IF NOT EXISTS TBL_QPS_SAFERPT_CHK (
  SRP_SEQ  BIGINT       NOT NULL,
  GRP_CD   VARCHAR(30)  NOT NULL COMMENT '묶음 코드(DEF.GRP_CD)',
  ITEM_NM  VARCHAR(200) NOT NULL COMMENT '고른 항목명',
  ETC_TXT  VARCHAR(300) NULL COMMENT '「기타( )」 처럼 괄호에 적는 값',
  PRIMARY KEY (SRP_SEQ, GRP_CD, ITEM_NM)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='사고 보고서 — 체크 결과';

-- ── 3. ★유형별 항목표 — 이 표가 이 서식의 핵심이다 ─────────────────
--   서식마다 화면을 짜는 게 아니라 **묶음을 정의하고 서식은 「어떤 묶음을 쓰는가」만 정한다.**
--   서식이 늘어도 여기 행을 넣으면 끝난다.
--   RPT_GB='*' = 여러 서식이 함께 쓰는 공유 묶음(직종·의식상태·활동상태·환자관련요인 …)
CREATE TABLE IF NOT EXISTS TBL_QPS_SAFERPT_DEF (
  RPT_GB   VARCHAR(20)  NOT NULL COMMENT "유형('*'=공유 묶음)",
  GRP_CD   VARCHAR(30)  NOT NULL COMMENT '묶음 코드',
  GRP_NM   VARCHAR(100) NOT NULL COMMENT '묶음 이름(화면 라벨)',
  ITEM_NM  VARCHAR(200) NOT NULL COMMENT '항목',
  MULTI_YN CHAR(1)      NOT NULL DEFAULT 'Y' COMMENT '중복선택 Y=체크박스 N=라디오',
  ETC_YN   CHAR(1)      NOT NULL DEFAULT 'N' COMMENT '「기타( )」 처럼 글자를 받는 항목',
  SORT     INT          NOT NULL DEFAULT 0,
  USE_YN   CHAR(1)      NOT NULL DEFAULT 'Y',
  PRIMARY KEY (RPT_GB, GRP_CD, ITEM_NM)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='사고 보고서 — 유형별 체크 항목표';

-- 어떤 서식이 어떤 묶음을 쓰는가 (순서 포함)
CREATE TABLE IF NOT EXISTS TBL_QPS_SAFERPT_USE (
  RPT_GB VARCHAR(20) NOT NULL,
  GRP_CD VARCHAR(30) NOT NULL,
  SORT   INT         NOT NULL DEFAULT 0,
  USE_YN CHAR(1)     NOT NULL DEFAULT 'Y',
  PRIMARY KEY (RPT_GB, GRP_CD)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='사고 보고서 — 서식이 쓰는 묶음';


-- ═══ 항목 채록 (2026-08-10 실물 8종) ════════════════════════════════
-- ── 공유 묶음 ('*') ─────────────────────────────────────────────────
INSERT INTO TBL_QPS_SAFERPT_DEF (RPT_GB,GRP_CD,GRP_NM,ITEM_NM,MULTI_YN,ETC_YN,SORT,USE_YN) VALUES
 ('*','JOB','직종','의사','N','N',1,'Y'),('*','JOB','직종','간호사','N','N',2,'Y'),
 ('*','JOB','직종','간호조무사','N','N',3,'Y'),('*','JOB','직종','요양보호사','N','N',4,'Y'),
 ('*','JOB','직종','조리사','N','N',5,'Y'),('*','JOB','직종','의료기사','N','N',6,'Y'),
 ('*','JOB','직종','기타','N','Y',99,'Y'),
 ('*','CONSC','의식상태','명료','N','N',1,'Y'),('*','CONSC','의식상태','졸음','N','N',2,'Y'),
 ('*','CONSC','의식상태','혼미','N','N',3,'Y'),('*','CONSC','의식상태','반혼수','N','N',4,'Y'),
 ('*','CONSC','의식상태','혼수','N','N',5,'Y'),
 ('*','ACTIV','활동상태','독립적','N','N',1,'Y'),('*','ACTIV','활동상태','부분도움','N','N',2,'Y'),
 ('*','ACTIV','활동상태','항상 도움필요','N','N',3,'Y'),('*','ACTIV','활동상태','침상안정','N','N',4,'Y'),
 ('*','PTFACT','환자관련 요인','어지러움','Y','N',1,'Y'),('*','PTFACT','환자관련 요인','흥분','Y','N',2,'Y'),
 ('*','PTFACT','환자관련 요인','전신쇠약','Y','N',3,'Y'),('*','PTFACT','환자관련 요인','마비','Y','N',4,'Y'),
 ('*','PTFACT','환자관련 요인','시력장애','Y','N',5,'Y'),('*','PTFACT','환자관련 요인','체위성저혈압','Y','N',6,'Y'),
 ('*','PTFACT','환자관련 요인','평형장애','Y','N',7,'Y'),('*','PTFACT','환자관련 요인','보행장애','Y','N',8,'Y'),
 ('*','PTFACT','환자관련 요인','수면장애','Y','N',9,'Y'),('*','PTFACT','환자관련 요인','낙상경력','Y','N',10,'Y'),
 ('*','TREAT','진료내역 — 처방','관찰','Y','N',1,'Y'),('*','TREAT','진료내역 — 처방','봉합','Y','N',2,'Y'),
 ('*','TREAT','진료내역 — 처방','통증중재','Y','N',3,'Y'),('*','TREAT','진료내역 — 처방','항생제 처방','Y','N',4,'Y'),
 ('*','TREAT','진료내역 — 처방','타병원진료','Y','N',5,'Y'),('*','TREAT','진료내역 — 처방','기타','Y','Y',99,'Y')
ON DUPLICATE KEY UPDATE GRP_NM=VALUES(GRP_NM), MULTI_YN=VALUES(MULTI_YN), ETC_YN=VALUES(ETC_YN), SORT=VALUES(SORT), USE_YN='Y';

-- ── 환자안전사고 보고서 ─────────────────────────────────────────────
INSERT INTO TBL_QPS_SAFERPT_DEF (RPT_GB,GRP_CD,GRP_NM,ITEM_NM,MULTI_YN,ETC_YN,SORT,USE_YN) VALUES
 ('PTSAFE','ERRGB','오류구분','낙상','N','N',1,'Y'),('PTSAFE','ERRGB','오류구분','투약','N','N',2,'Y'),
 ('PTSAFE','ERRGB','오류구분','기타','N','N',3,'Y'),
 ('PTSAFE','LEVEL','오류등급','Level 0','N','N',0,'Y'),('PTSAFE','LEVEL','오류등급','Level 1','N','N',1,'Y'),
 ('PTSAFE','LEVEL','오류등급','Level 2','N','N',2,'Y'),('PTSAFE','LEVEL','오류등급','Level 3','N','N',3,'Y'),
 ('PTSAFE','LEVEL','오류등급','Level 4','N','N',4,'Y'),
 ('PTSAFE','DAMAGE','손상종류','없음','N','N',1,'Y'),('PTSAFE','DAMAGE','손상종류','찰과상','N','N',2,'Y'),
 ('PTSAFE','DAMAGE','손상종류','열상','N','N',3,'Y'),('PTSAFE','DAMAGE','손상종류','골절','N','N',4,'Y'),
 ('PTSAFE','DAMAGE','손상종류','뇌손상','N','N',5,'Y'),('PTSAFE','DAMAGE','손상종류','기타','N','Y',99,'Y'),
 ('PTSAFE','FALLDRUG','낙상 유발약물','수면제','Y','N',1,'Y'),('PTSAFE','FALLDRUG','낙상 유발약물','진정제','Y','N',2,'Y'),
 ('PTSAFE','FALLDRUG','낙상 유발약물','이뇨제','Y','N',3,'Y'),('PTSAFE','FALLDRUG','낙상 유발약물','항고혈압제','Y','N',4,'Y'),
 ('PTSAFE','FALLDRUG','낙상 유발약물','마약성진통제','Y','N',5,'Y'),('PTSAFE','FALLDRUG','낙상 유발약물','기타','Y','Y',99,'Y'),
 ('PTSAFE','FALLTYPE','낙상 유형','침대에서','N','N',1,'Y'),('PTSAFE','FALLTYPE','낙상 유형','휠체어에서','N','N',2,'Y'),
 ('PTSAFE','FALLTYPE','낙상 유형','보행 중','N','N',3,'Y'),('PTSAFE','FALLTYPE','낙상 유형','화장실에서','N','N',4,'Y'),
 ('PTSAFE','FALLTYPE','낙상 유형','기타','N','Y',99,'Y'),
 ('PTSAFE','MEDERR','투약오류','처방오류','N','N',1,'Y'),('PTSAFE','MEDERR','투약오류','조제오류','N','N',2,'Y'),
 ('PTSAFE','MEDERR','투약오류','투여오류','N','N',3,'Y'),('PTSAFE','MEDERR','투약오류','모니터링오류','N','N',4,'Y'),
 ('PTSAFE','ETCERR','기타오류','검사관련','Y','N',1,'Y'),('PTSAFE','ETCERR','기타오류','과정오류','Y','N',2,'Y'),
 ('PTSAFE','ETCERR','기타오류','결과오류','Y','N',3,'Y'),('PTSAFE','ETCERR','기타오류','검사지연','Y','N',4,'Y'),
 ('PTSAFE','ETCERR','기타오류','학대및폭력','Y','N',5,'Y'),('PTSAFE','ETCERR','기타오류','자살및자해','Y','N',6,'Y'),
 ('PTSAFE','ETCERR','기타오류','타해','Y','N',7,'Y'),('PTSAFE','ETCERR','기타오류','진료재료오염','Y','N',8,'Y'),
 ('PTSAFE','ETCERR','기타오류','화상','Y','N',9,'Y'),('PTSAFE','ETCERR','기타오류','시술관련','Y','N',10,'Y'),
 ('PTSAFE','ETCERR','기타오류','의료장비','Y','N',11,'Y'),('PTSAFE','ETCERR','기타오류','시설관련','Y','N',12,'Y'),
 ('PTSAFE','ETCERR','기타오류','질식사고','Y','N',13,'Y'),('PTSAFE','ETCERR','기타오류','위험물품소지','Y','N',14,'Y'),
 ('PTSAFE','ETCERR','기타오류','탈원','Y','N',15,'Y')
ON DUPLICATE KEY UPDATE GRP_NM=VALUES(GRP_NM), MULTI_YN=VALUES(MULTI_YN), ETC_YN=VALUES(ETC_YN), SORT=VALUES(SORT), USE_YN='Y';

-- ── 욕창발생 · 직원안전 · 유해물질 · 직원감염노출 · 학대폭력 ─────────
INSERT INTO TBL_QPS_SAFERPT_DEF (RPT_GB,GRP_CD,GRP_NM,ITEM_NM,MULTI_YN,ETC_YN,SORT,USE_YN) VALUES
 ('BEDSORE','SITE','발생부위','천골','N','N',1,'Y'),('BEDSORE','SITE','발생부위','미골','N','N',2,'Y'),
 ('BEDSORE','SITE','발생부위','대전자','N','N',3,'Y'),('BEDSORE','SITE','발생부위','발뒤꿈치','N','N',4,'Y'),
 ('BEDSORE','SITE','발생부위','견갑골','N','N',5,'Y'),('BEDSORE','SITE','발생부위','기타','N','Y',99,'Y'),
 ('BEDSORE','STAGE','단계','1단계','N','N',1,'Y'),('BEDSORE','STAGE','단계','2단계','N','N',2,'Y'),
 ('BEDSORE','STAGE','단계','3단계','N','N',3,'Y'),('BEDSORE','STAGE','단계','4단계','N','N',4,'Y'),
 ('BEDSORE','STAGE','단계','미분류','N','N',5,'Y'),('BEDSORE','STAGE','단계','심부조직손상','N','N',6,'Y'),
 ('BEDSORE','PREV','예방간호','체위변경','Y','N',1,'Y'),('BEDSORE','PREV','예방간호','에어매트리스','Y','N',2,'Y'),
 ('BEDSORE','PREV','예방간호','피부 사정','Y','N',3,'Y'),('BEDSORE','PREV','예방간호','영양지원','Y','N',4,'Y'),
 ('BEDSORE','PREV','예방간호','실금 관리','Y','N',5,'Y'),('BEDSORE','PREV','예방간호','기타','Y','Y',99,'Y'),
 ('STAFF','ACCTYPE','사고유형','주사침 자상','N','N',1,'Y'),('STAFF','ACCTYPE','사고유형','베임·찔림','N','N',2,'Y'),
 ('STAFF','ACCTYPE','사고유형','낙상','N','N',3,'Y'),('STAFF','ACCTYPE','사고유형','근골격계','N','N',4,'Y'),
 ('STAFF','ACCTYPE','사고유형','폭행·폭언','N','N',5,'Y'),('STAFF','ACCTYPE','사고유형','화학물질','N','N',6,'Y'),
 ('STAFF','ACCTYPE','사고유형','기타','N','Y',99,'Y'),
 ('HAZMAT','HZTYPE','사고종류','유출','N','N',1,'Y'),('HAZMAT','HZTYPE','사고종류','흡입','N','N',2,'Y'),
 ('HAZMAT','HZTYPE','사고종류','피부접촉','N','N',3,'Y'),('HAZMAT','HZTYPE','사고종류','안구접촉','N','N',4,'Y'),
 ('HAZMAT','HZTYPE','사고종류','기타','N','Y',99,'Y'),
 ('HAZMAT','HZLEVEL','노출정도','경미','N','N',1,'Y'),('HAZMAT','HZLEVEL','노출정도','중등도','N','N',2,'Y'),
 ('HAZMAT','HZLEVEL','노출정도','중증','N','N',3,'Y'),
 ('HAZMAT','HZACT','조치사항','세척','Y','N',1,'Y'),('HAZMAT','HZACT','조치사항','환기','Y','N',2,'Y'),
 ('HAZMAT','HZACT','조치사항','Spill kit 사용','Y','N',3,'Y'),('HAZMAT','HZACT','조치사항','보호구 착용','Y','N',4,'Y'),
 ('HAZMAT','HZACT','조치사항','진료 의뢰','Y','N',5,'Y'),('HAZMAT','HZACT','조치사항','기타','Y','Y',99,'Y'),
 ('INFEXP','PATHOGEN','위험원인체','HBs Ag','Y','N',1,'Y'),('INFEXP','PATHOGEN','위험원인체','HBc Ag','Y','N',2,'Y'),
 ('INFEXP','PATHOGEN','위험원인체','HBe Ag','Y','N',3,'Y'),('INFEXP','PATHOGEN','위험원인체','Anti-HCV','Y','N',4,'Y'),
 ('INFEXP','PATHOGEN','위험원인체','HIV','Y','N',5,'Y'),('INFEXP','PATHOGEN','위험원인체','VDRL','Y','N',6,'Y'),
 ('INFEXP','PATHOGEN','위험원인체','COVID-19','Y','N',7,'Y'),
 ('INFEXP','ROUTE','노출경로','주사침','N','N',1,'Y'),('INFEXP','ROUTE','노출경로','점막','N','N',2,'Y'),
 ('INFEXP','ROUTE','노출경로','손상된 피부','N','N',3,'Y'),('INFEXP','ROUTE','노출경로','비말·공기','N','N',4,'Y'),
 ('INFEXP','ROUTE','노출경로','기타','N','Y',99,'Y'),
 ('ABUSE','ABTYPE','사건유형','학대','N','N',1,'Y'),('ABUSE','ABTYPE','사건유형','폭력','N','N',2,'Y'),
 ('ABUSE','ABTYPE','사건유형','성폭력','N','N',3,'Y'),('ABUSE','ABTYPE','사건유형','방임','N','N',4,'Y'),
 ('HARASS','HRTYPE','사건유형','폭행','N','N',1,'Y'),('HARASS','HRTYPE','사건유형','폭언','N','N',2,'Y'),
 ('HARASS','HRTYPE','사건유형','성희롱','N','N',3,'Y'),('HARASS','HRTYPE','사건유형','성추행','N','N',4,'Y'),
 ('HARASS','HRTYPE','사건유형','기타','N','Y',99,'Y')
ON DUPLICATE KEY UPDATE GRP_NM=VALUES(GRP_NM), MULTI_YN=VALUES(MULTI_YN), ETC_YN=VALUES(ETC_YN), SORT=VALUES(SORT), USE_YN='Y';

-- ── 서식이 쓰는 묶음 (실측 8종의 블록 조합) ─────────────────────────
INSERT INTO TBL_QPS_SAFERPT_USE (RPT_GB,GRP_CD,SORT,USE_YN) VALUES
 ('PTSAFE','ERRGB',1,'Y'),('PTSAFE','LEVEL',2,'Y'),('PTSAFE','DAMAGE',3,'Y'),
 ('PTSAFE','CONSC',4,'Y'),('PTSAFE','ACTIV',5,'Y'),('PTSAFE','PTFACT',6,'Y'),
 ('PTSAFE','FALLDRUG',7,'Y'),('PTSAFE','FALLTYPE',8,'Y'),('PTSAFE','MEDERR',9,'Y'),('PTSAFE','ETCERR',10,'Y'),
 ('BEDSORE','SITE',1,'Y'),('BEDSORE','STAGE',2,'Y'),('BEDSORE','PREV',3,'Y'),
 ('STAFF','JOB',1,'Y'),('STAFF','ACCTYPE',2,'Y'),('STAFF','TREAT',3,'Y'),
 ('INFEXP','JOB',1,'Y'),('INFEXP','PATHOGEN',2,'Y'),('INFEXP','ROUTE',3,'Y'),('INFEXP','TREAT',4,'Y'),
 ('INFDIS','CONSC',1,'Y'),('INFDIS','ACTIV',2,'Y'),('INFDIS','PTFACT',3,'Y'),
 ('HAZMAT','JOB',1,'Y'),('HAZMAT','HZTYPE',2,'Y'),('HAZMAT','HZLEVEL',3,'Y'),
 ('HAZMAT','HZACT',4,'Y'),('HAZMAT','TREAT',5,'Y'),
 ('ABUSE','ABTYPE',1,'Y'),
 ('HARASS','HRTYPE',1,'Y')
ON DUPLICATE KEY UPDATE SORT=VALUES(SORT), USE_YN='Y';
-- ★보안안전(SECU)은 묶음이 없다 — 원본도 체크박스가 없는 최소 조합(결재란+대상+육하원칙+결과+조치).

SELECT '유형' AS chk, COUNT(*) FROM TBL_CODE_DTL WHERE CODE_CD='QPS_SAFERPT_GB';
SELECT '항목' AS chk, RPT_GB, COUNT(*) AS n FROM TBL_QPS_SAFERPT_DEF GROUP BY RPT_GB ORDER BY RPT_GB;
SELECT '묶음사용' AS chk, RPT_GB, COUNT(*) AS n FROM TBL_QPS_SAFERPT_USE GROUP BY RPT_GB ORDER BY RPT_GB;
