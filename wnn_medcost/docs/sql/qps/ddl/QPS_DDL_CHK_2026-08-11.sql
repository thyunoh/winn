-- ═══════════════════════════════════════════════════════════════════════════
-- 점검표 엔진 (TBL_QPS_CHK_*) — 2026-08-11
--
-- ★★왜 엔진인가
--   간호/병동 메뉴 150여 개 중 실물이 있는 것은 20종뿐이고, 나머지 130여 종은 이름만 있다.
--   그런데 그 이름이 대부분 `…점검표 / 점검대장 / 점검일지 / 관리대장 / 기록부` 다.
--   실물 20종에서 확인한 **같은 격자**들이다.
--   ⇒ 서식을 130개 만들 일이 아니라 「서식정의 + 기록」 한 벌이면 된다.
--     병원이 항목만 등록하면 새 점검표가 생긴다.
--
-- ★축(AXIS_GB) 4가지 — 실물에서 실제로 관찰된 것만 넣었다. 추측으로 늘리지 않는다.
--   EQUIP_DAY  기기 N행 × 1~31일   (원심분리기·인퓨전펌프·EKG모니터)
--              → 점검항목은 표 위 안내박스로만 나온다. 셀은 기기별 일별 표시.
--   ITEM_DAY   점검항목 행 × 1~31일 (EKG 일일·E.O gas 일상·네블라이저)
--   DAY_ITEM   1~31일 행 × 점검항목 열 (Biological Dry Incubator·E.O gas 소독실·의료기기일일 2종)
--   ITEM_MONTH 점검항목 행 × 1~12월  (낙상환경,시설관리일지)
--
-- ★셀 값은 (행,열,값) 하나로만 담는다. 축이 바뀌어도 저장구조는 그대로다.
--   축마다 표를 따로 만들면 축이 늘 때마다 DDL 을 고쳐야 한다.
--
-- ⚠격자가 아닌 서식(수혈 동의서·진료의뢰서·안내문·서약서·감염성 질환 발생 보고서 …)은
--   이 엔진에 넣지 않는다. 억지로 넣으면 둘 다 이상해진다.
-- ═══════════════════════════════════════════════════════════════════════════

-- ── 1) 서식 정의 ────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS TBL_QPS_CHK_FORM (
  FORM_ID    VARCHAR(30)  NOT NULL COMMENT '서식코드',
  HOSP_CD    VARCHAR(20)  NOT NULL DEFAULT '*' COMMENT "'*'=공통 기본서식 / 병원코드=그 병원 전용",
  FORM_NM    VARCHAR(200) NOT NULL COMMENT '서식명(원본 문서명 그대로)',
  CATE_CD    VARCHAR(20)      NULL COMMENT '분류 QPS_CHK_CATE',
  AXIS_GB    VARCHAR(20)  NOT NULL DEFAULT 'ITEM_DAY'
             COMMENT 'EQUIP_DAY / ITEM_DAY / DAY_ITEM / ITEM_MONTH',
  PRD_GB     CHAR(1)      NOT NULL DEFAULT 'M' COMMENT 'M=월단위(1~31일) / Y=연단위(1~12월)',
  EQUIP_CNT  INT          NOT NULL DEFAULT 10  COMMENT 'EQUIP_DAY 의 기기 행 수',
  GUIDE_TXT  VARCHAR(200)     NULL COMMENT "표 위 안내 (예 '정상 : O 비정상 : X')",
  HEAD_NMS   VARCHAR(300)     NULL COMMENT '상단 자유칸 이름들(쉼표) 예 장비명,모델명,사용부서,점검주기',
  SIGNER_YN  CHAR(1)      NOT NULL DEFAULT 'Y' COMMENT '점검자 사인 행 사용',
  NOTE_YN    CHAR(1)      NOT NULL DEFAULT 'Y' COMMENT '특이사항 칸 사용',
  FIX_YN     CHAR(1)      NOT NULL DEFAULT 'N' COMMENT '수리날짜·고장내용 칸 사용(기기형)',
  SIGN_LINE  VARCHAR(200)     NULL COMMENT '하단 서명란(쉼표) 예 부서장,원무과장',
  FOOT_TXT   VARCHAR(500)     NULL COMMENT '하단 ※ 문구',
  SORT_NO    INT          NOT NULL DEFAULT 0,
  USE_YN     CHAR(1)      NOT NULL DEFAULT 'Y',
  REG_USER   VARCHAR(50)      NULL,
  REG_DTTM   DATETIME         NULL DEFAULT CURRENT_TIMESTAMP,
  UPD_USER   VARCHAR(50)      NULL,
  UPD_DTTM   DATETIME         NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (FORM_ID, HOSP_CD),
  KEY IX_CHK_FORM (HOSP_CD, USE_YN, SORT_NO)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='점검표 서식 정의';

-- ── 2) 서식의 점검항목 ──────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS TBL_QPS_CHK_ITEM (
  FORM_ID   VARCHAR(30)  NOT NULL,
  HOSP_CD   VARCHAR(20)  NOT NULL DEFAULT '*',
  SORT      INT          NOT NULL COMMENT '항목 순번 = 격자의 행(또는 열) 번호',
  ITEM_NM   VARCHAR(300) NOT NULL COMMENT '점검항목 문구',
  GRP_NM    VARCHAR(100)     NULL COMMENT "열 묶음(DAY_ITEM 의 2단 머리글) 예 '치료실 환경'",
  INPUT_GB  VARCHAR(10)  NOT NULL DEFAULT 'CHECK' COMMENT 'CHECK=O/X · TEXT=글 · NUM=숫자',
  UNIT_NM   VARCHAR(10)      NULL COMMENT "숫자 칸 단위 예 '℃','%'",
  USE_YN    CHAR(1)      NOT NULL DEFAULT 'Y',
  PRIMARY KEY (FORM_ID, HOSP_CD, SORT)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='점검표 항목';

-- ── 3) 작성 문서 ────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS TBL_QPS_CHK_DOC (
  CHK_SEQ   BIGINT       NOT NULL AUTO_INCREMENT,
  HOSP_CD   VARCHAR(20)  NOT NULL,
  FORM_ID   VARCHAR(30)  NOT NULL,
  IN_YEAR   CHAR(4)      NOT NULL,
  IN_MM     CHAR(2)          NULL COMMENT '월단위 서식만. 연단위(ITEM_MONTH)는 NULL',
  WARD_NM   VARCHAR(100)     NULL COMMENT '병동 — 원본 모든 서식 상단에 있다',
  HEAD1     VARCHAR(200)     NULL, HEAD2 VARCHAR(200) NULL,
  HEAD3     VARCHAR(200)     NULL, HEAD4 VARCHAR(200) NULL,
  NOTE_TXT  TEXT             NULL COMMENT '특이사항',
  FIX_TXT   TEXT             NULL COMMENT '수리날짜 및 고장 발생 내용',
  USE_YN    CHAR(1)      NOT NULL DEFAULT 'Y',
  REG_USER  VARCHAR(50)      NULL,
  REG_DTTM  DATETIME         NULL DEFAULT CURRENT_TIMESTAMP,
  UPD_USER  VARCHAR(50)      NULL,
  UPD_DTTM  DATETIME         NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (CHK_SEQ),
  KEY IX_CHK_DOC (HOSP_CD, FORM_ID, IN_YEAR, IN_MM, USE_YN)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='점검표 작성 문서';

-- ── 4) 셀 값 — ★축이 바뀌어도 이 표는 그대로다 ──────────────────────────────
--   ROW_NO / COL_NO 의 뜻은 축이 정한다 :
--     EQUIP_DAY   ROW=기기번호(1~N)   COL=일(1~31)
--     ITEM_DAY    ROW=항목SORT        COL=일(1~31)
--     DAY_ITEM    ROW=일(1~31)        COL=항목SORT
--     ITEM_MONTH  ROW=항목SORT        COL=월(1~12)
--   ★예약 ROW_NO 900 = 점검자 사인 행(EQUIP_DAY·ITEM_DAY). COL 은 일.
--     예약 COL_NO 900 = 점검자 사인 열(DAY_ITEM). ROW 는 일.
CREATE TABLE IF NOT EXISTS TBL_QPS_CHK_VAL (
  CHK_SEQ BIGINT       NOT NULL,
  ROW_NO  INT          NOT NULL,
  COL_NO  INT          NOT NULL,
  VAL     VARCHAR(200)     NULL,
  PRIMARY KEY (CHK_SEQ, ROW_NO, COL_NO)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='점검표 셀 값';

-- ── 5) 기기명 행 (EQUIP_DAY 전용) ───────────────────────────────────────────
--   ★기기 이름은 문서마다 다르다(병동마다 장비가 다르다) — 서식이 아니라 문서에 붙는다.
CREATE TABLE IF NOT EXISTS TBL_QPS_CHK_ROW (
  CHK_SEQ BIGINT       NOT NULL,
  ROW_NO  INT          NOT NULL,
  ROW_NM  VARCHAR(200)     NULL,
  PRIMARY KEY (CHK_SEQ, ROW_NO)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='점검표 기기행 이름';

-- ── 공통코드 : 분류 ─────────────────────────────────────────────────────────
--   ★TBL_CODE_DTL 의 실제 컬럼은 (CODE_GB, CODE_CD, SUB_CODE, JOB_SEQ, SUB_CODE_NM, …) 이다.
--     CODE_GB='Q' 가 QPS 몫. 다른 이름(CODE_DTL 등)으로 쓰면 조용히 0건이 된다(2026-08-11 실제로 겪음).
DELETE FROM TBL_CODE_DTL WHERE CODE_CD='QPS_CHK_CATE';
INSERT INTO TBL_CODE_DTL
 (CODE_GB, CODE_CD, SUB_CODE, JOB_SEQ, SUB_CODE_NM, START_DT, END_DT, USE_YN, SORT, ACTION_YN, REG_USER) VALUES
 ('Q','QPS_CHK_CATE','EQUIP' ,1,'의료기기 점검','20000101','99991231','Y',1,'Y','system'),
 ('Q','QPS_CHK_CATE','STERIL',1,'멸균·소독'   ,'20000101','99991231','Y',2,'Y','system'),
 ('Q','QPS_CHK_CATE','ENV'   ,1,'환경·시설'   ,'20000101','99991231','Y',3,'Y','system'),
 ('Q','QPS_CHK_CATE','DRUG'  ,1,'약품·마약'   ,'20000101','99991231','Y',4,'Y','system'),
 ('Q','QPS_CHK_CATE','SAFE'  ,1,'안전·감염'   ,'20000101','99991231','Y',5,'Y','system'),
 ('Q','QPS_CHK_CATE','ETC'   ,1,'기타'        ,'20000101','99991231','Y',9,'Y','system');

-- ═══════════════════════════════════════════════════════════════════════════
-- 기본 서식 시드 — ★실물 캡처로 확인한 것만 넣는다(2026-08-11).
--   준비중이던 메뉴는 넣지 않는다 — 항목을 지어내면 병원이 그걸 진짜인 줄 안다.
-- ═══════════════════════════════════════════════════════════════════════════
DELETE FROM TBL_QPS_CHK_ITEM WHERE HOSP_CD='*';
DELETE FROM TBL_QPS_CHK_FORM WHERE HOSP_CD='*';

INSERT INTO TBL_QPS_CHK_FORM
 (FORM_ID,HOSP_CD,FORM_NM,CATE_CD,AXIS_GB,PRD_GB,EQUIP_CNT,GUIDE_TXT,HEAD_NMS,
  SIGNER_YN,NOTE_YN,FIX_YN,SIGN_LINE,FOOT_TXT,SORT_NO,USE_YN,REG_USER) VALUES
 -- EQUIP_DAY 3종 — 기기 10대 × 31일
 ('CENTRI','*','일상점검표 - 원심 분리기','EQUIP','EQUIP_DAY','M',10,NULL,NULL,
  'Y','N','Y',NULL,NULL,11,'Y','system'),
 ('INFPUMP','*','일상점검표 - 인퓨전 펌프','EQUIP','EQUIP_DAY','M',10,NULL,NULL,
  'Y','N','Y',NULL,NULL,12,'Y','system'),
 ('EKGMON','*','EKG모니터 일상점검표','EQUIP','EQUIP_DAY','M',10,NULL,NULL,
  'Y','N','Y',NULL,NULL,13,'Y','system'),
 -- ITEM_DAY 3종 — 점검항목 × 31일
 ('EKGDAY','*','EKG 일일점검표','EQUIP','ITEM_DAY','M',0,'정상 : O 비정상 : X','모델 / 시리얼',
  'Y','Y','N',NULL,NULL,21,'Y','system'),
 ('NEBUL','*','일일점검표 - 네블라이저','EQUIP','ITEM_DAY','M',0,'정상 : O 비정상 : X',NULL,
  'Y','Y','N',NULL,NULL,22,'Y','system'),
 ('EOGASD','*','E.O Gas Sterilizer 일상점검표','STERIL','ITEM_DAY','M',0,NULL,'장 비 명,모 델 명',
  'Y','Y','N','부 서 장,원 무 과 장',
  '※ 점검 후 양호 이외의 결과 시 → 부서장에게 보고 후 → 의료기기 수리의뢰서를 작성하여 의료기기담당자에게 보고한다.',
  23,'Y','system'),
 -- DAY_ITEM 4종 — 1~31일 × 점검항목
 ('BIODRY','*','Biological Dry Incubator 점검일지','STERIL','DAY_ITEM','M',0,
  '* 양호(○), 불량 및 정비필요(X)로 구분하여 표시','모델명,배양기,사용부서,점검주기',
  'N','N','N',NULL,NULL,31,'Y','system'),
 ('EOGROOM','*','EO gas 소독실 관리대장','STERIL','DAY_ITEM','M',0,NULL,NULL,
  'N','N','N',NULL,NULL,32,'Y','system'),
 ('MDHBO','*','의료기기일일점검표 - 고압산소치료기','EQUIP','DAY_ITEM','M',0,
  '표시 [적합 : O / 부적합 : X]','제품,모델',
  'N','Y','N',NULL,NULL,33,'Y','system'),
 ('MDRF','*','의료기기일일점검표 - 고주파온열암치료기','EQUIP','DAY_ITEM','M',0,
  '표시 [적합 : O / 부적합 : X]','제품,모델',
  'N','Y','N',NULL,NULL,34,'Y','system'),
 -- ITEM_MONTH 1종 — 점검항목 × 1~12월
 ('FALLENV','*','낙상 시설, 환경 관리일지','ENV','ITEM_MONTH','Y',0,NULL,NULL,
  'N','Y','N',NULL,NULL,41,'Y','system'),
 -- 날짜 2벌 배치형(린넨실) — 항목이 하나(점검자)뿐인 ITEM_DAY 로 담는다
 ('LINEN','*','린넨실 청소,소독 체크리스트','STERIL','ITEM_DAY','M',0,
  '<매일> 락스 500PPM 희석액을 이용하여 청소하고 린넨별로 정리 정돈한다.',NULL,
  'N','N','N',NULL,NULL,42,'Y','system');

-- 항목 --------------------------------------------------------------------
-- EQUIP_DAY : 항목은 표 위 안내박스로만 나온다(셀은 기기×일)
INSERT INTO TBL_QPS_CHK_ITEM (FORM_ID,HOSP_CD,SORT,ITEM_NM,GRP_NM,INPUT_GB,UNIT_NM,USE_YN) VALUES
 ('CENTRI','*',1,'장비외관 손상여부 확인',NULL,'CHECK',NULL,'Y'),
 ('CENTRI','*',2,'전원 스위치 확인',NULL,'CHECK',NULL,'Y'),
 ('CENTRI','*',3,'콘센트 전원 플러그의 안전한 접합 점검',NULL,'CHECK',NULL,'Y'),
 ('CENTRI','*',4,'액체로 인한 누전 점검',NULL,'CHECK',NULL,'Y'),
 ('CENTRI','*',5,'기기 청결 확인',NULL,'CHECK',NULL,'Y'),
 ('CENTRI','*',6,'RPM 작동여부 확인',NULL,'CHECK',NULL,'Y'),
 ('CENTRI','*',7,'타이머 작동여부 확인',NULL,'CHECK',NULL,'Y');

INSERT INTO TBL_QPS_CHK_ITEM (FORM_ID,HOSP_CD,SORT,ITEM_NM,GRP_NM,INPUT_GB,UNIT_NM,USE_YN) VALUES
 ('INFPUMP','*',1,'ON/OFF 확인',NULL,'CHECK',NULL,'Y'),
 ('INFPUMP','*',2,'외관파손 유무 및 청결상태',NULL,'CHECK',NULL,'Y'),
 ('INFPUMP','*',3,'고정 및 지지대 안전상태',NULL,'CHECK',NULL,'Y'),
 ('INFPUMP','*',4,'Cable 및 약세사리 점검',NULL,'CHECK',NULL,'Y'),
 ('INFPUMP','*',5,'성능 및 동작 상태',NULL,'CHECK',NULL,'Y'),
 ('INFPUMP','*',6,'기능선택 Setting 상태',NULL,'CHECK',NULL,'Y'),
 ('INFPUMP','*',7,'기타',NULL,'CHECK',NULL,'Y');

INSERT INTO TBL_QPS_CHK_ITEM (FORM_ID,HOSP_CD,SORT,ITEM_NM,GRP_NM,INPUT_GB,UNIT_NM,USE_YN) VALUES
 ('EKGMON','*',1,'심전도케이블(환자용)이 연결되어 있는가?',NULL,'CHECK',NULL,'Y'),
 ('EKGMON','*',2,'NIBP 케이블이 연결되어 있는가?',NULL,'CHECK',NULL,'Y'),
 ('EKGMON','*',3,'SPO2 케이블이 연결되어 있는가?',NULL,'CHECK',NULL,'Y'),
 ('EKGMON','*',4,'Electrode가 있는가?',NULL,'CHECK',NULL,'Y'),
 ('EKGMON','*',5,'기기의 전원은 정상적으로 공급되는가?',NULL,'CHECK',NULL,'Y'),
 ('EKGMON','*',6,'전원ON시 프로그램 정상 Booting 여부?',NULL,'CHECK',NULL,'Y'),
 ('EKGMON','*',7,'디스플레이 표시는 정상인가?',NULL,'CHECK',NULL,'Y'),
 ('EKGMON','*',8,'High,Low Limit 설정치의 Alam 정상작동?',NULL,'CHECK',NULL,'Y'),
 ('EKGMON','*',9,'동작 중 Error 발생은 없는가?',NULL,'CHECK',NULL,'Y');

-- ITEM_DAY : 항목이 곧 행
INSERT INTO TBL_QPS_CHK_ITEM (FORM_ID,HOSP_CD,SORT,ITEM_NM,GRP_NM,INPUT_GB,UNIT_NM,USE_YN) VALUES
 ('EKGDAY','*',1,'장비외관 손상여부',NULL,'CHECK',NULL,'Y'),
 ('EKGDAY','*',2,'콘센트 전원플러그의 안전한 접합 점검',NULL,'CHECK',NULL,'Y'),
 ('EKGDAY','*',3,'Paper 이상유무 확인',NULL,'CHECK',NULL,'Y'),
 ('EKGDAY','*',4,'전원스위치 작동 여부 확인',NULL,'CHECK',NULL,'Y'),
 ('EKGDAY','*',5,'기기 청소 상태 확인',NULL,'CHECK',NULL,'Y'),
 ('EKGDAY','*',6,'흉부, 사지 전극 점검',NULL,'CHECK',NULL,'Y'),
 ('EKGDAY','*',7,'키보드 동작상태 확인',NULL,'CHECK',NULL,'Y'),
 ('EKGDAY','*',8,'Cable 상태 확인',NULL,'CHECK',NULL,'Y');

INSERT INTO TBL_QPS_CHK_ITEM (FORM_ID,HOSP_CD,SORT,ITEM_NM,GRP_NM,INPUT_GB,UNIT_NM,USE_YN) VALUES
 ('NEBUL','*',1,'전원 결합여부',NULL,'CHECK',NULL,'Y'),
 ('NEBUL','*',2,'청결 상태',NULL,'CHECK',NULL,'Y'),
 ('NEBUL','*',3,'가동 이상여부',NULL,'CHECK',NULL,'Y'),
 ('NEBUL','*',4,'보관 상태',NULL,'CHECK',NULL,'Y'),
 ('NEBUL','*',5,'저장 장소 비치 여부',NULL,'CHECK',NULL,'Y');

INSERT INTO TBL_QPS_CHK_ITEM (FORM_ID,HOSP_CD,SORT,ITEM_NM,GRP_NM,INPUT_GB,UNIT_NM,USE_YN) VALUES
 ('EOGASD','*',1,'전원 상태',NULL,'CHECK',NULL,'Y'),
 ('EOGASD','*',2,'외관 및 내부청결 상태 점검',NULL,'CHECK',NULL,'Y'),
 ('EOGASD','*',3,'Gas Bottle Leakage 상태 점검',NULL,'CHECK',NULL,'Y'),
 ('EOGASD','*',4,'Gas 정화기능 점검',NULL,'CHECK',NULL,'Y'),
 ('EOGASD','*',5,'환기상태',NULL,'CHECK',NULL,'Y'),
 ('EOGASD','*',6,'보호장구 구비',NULL,'CHECK',NULL,'Y'),
 ('EOGASD','*',7,'온도 조절기 상태 점검',NULL,'CHECK',NULL,'Y');

INSERT INTO TBL_QPS_CHK_ITEM (FORM_ID,HOSP_CD,SORT,ITEM_NM,GRP_NM,INPUT_GB,UNIT_NM,USE_YN) VALUES
 ('LINEN','*',1,'점검자',NULL,'TEXT',NULL,'Y');

-- DAY_ITEM : 항목이 곧 열
INSERT INTO TBL_QPS_CHK_ITEM (FORM_ID,HOSP_CD,SORT,ITEM_NM,GRP_NM,INPUT_GB,UNIT_NM,USE_YN) VALUES
 ('BIODRY','*',1,'전원 On/Off',NULL,'CHECK',NULL,'Y'),
 ('BIODRY','*',2,'정격전압 콘센트 확인',NULL,'CHECK',NULL,'Y'),
 ('BIODRY','*',3,'LCD 모니터 표시',NULL,'CHECK',NULL,'Y'),
 ('BIODRY','*',4,'온도조절 버튼 확인',NULL,'CHECK',NULL,'Y'),
 ('BIODRY','*',5,'온도 확인(세팅)',NULL,'CHECK',NULL,'Y'),
 ('BIODRY','*',6,'작동램프',NULL,'CHECK',NULL,'Y'),
 ('BIODRY','*',7,'청소상태',NULL,'CHECK',NULL,'Y'),
 ('BIODRY','*',8,'점검자',NULL,'TEXT',NULL,'Y');

INSERT INTO TBL_QPS_CHK_ITEM (FORM_ID,HOSP_CD,SORT,ITEM_NM,GRP_NM,INPUT_GB,UNIT_NM,USE_YN) VALUES
 ('EOGROOM','*',1,'온도',NULL,'NUM','℃','Y'),
 ('EOGROOM','*',2,'습도',NULL,'NUM','%','Y'),
 ('EOGROOM','*',3,'보호장구 비치여부',NULL,'CHECK',NULL,'Y'),
 ('EOGROOM','*',4,'청소상태',NULL,'CHECK',NULL,'Y'),
 ('EOGROOM','*',5,'서명',NULL,'TEXT',NULL,'Y');

-- ★2단 머리글(GRP_NM) — 원본이 열을 '치료실 환경 / 의료기기 상태'로 묶는다
INSERT INTO TBL_QPS_CHK_ITEM (FORM_ID,HOSP_CD,SORT,ITEM_NM,GRP_NM,INPUT_GB,UNIT_NM,USE_YN) VALUES
 ('MDHBO','*',1,'기기실내,외 청결 및 정리정돈은 적절한가?','치료실 환경','CHECK',NULL,'Y'),
 ('MDHBO','*',2,'환기 및 통풍상태는 적절한가?','치료실 환경','CHECK',NULL,'Y'),
 ('MDHBO','*',3,'인터폰작동은 잘되는지?','치료실 환경','CHECK',NULL,'Y'),
 ('MDHBO','*',4,'에어콘물받이 비어있는지유무?','치료실 환경','CHECK',NULL,'Y'),
 ('MDHBO','*',5,'인터폰작동은 잘되는지?','의료기기 상태','CHECK',NULL,'Y'),
 ('MDHBO','*',6,'압력계기판의display는 정상적으로 작동되는가?','의료기기 상태','CHECK',NULL,'Y'),
 ('MDHBO','*',7,'타임설정에 display는 정상적으로 들어오는지?','의료기기 상태','CHECK',NULL,'Y'),
 ('MDHBO','*',8,'디스플레이 패널 녹록불2개가기록유무','의료기기 상태','CHECK',NULL,'Y'),
 ('MDHBO','*',9,'출입구의 작동이 잘되는지?','의료기기 상태','CHECK',NULL,'Y'),
 ('MDHBO','*',10,'점검자',NULL,'TEXT',NULL,'Y');

INSERT INTO TBL_QPS_CHK_ITEM (FORM_ID,HOSP_CD,SORT,ITEM_NM,GRP_NM,INPUT_GB,UNIT_NM,USE_YN) VALUES
 ('MDRF','*',1,'실내온도는 적절한가? (15~23℃)','치료실 환경','CHECK',NULL,'Y'),
 ('MDRF','*',2,'실내습도는 적절한가? (20~60%)','치료실 환경','CHECK',NULL,'Y'),
 ('MDRF','*',3,'실내 청결 및 정리정돈 적절한가?','치료실 환경','CHECK',NULL,'Y'),
 ('MDRF','*',4,'환기 및 통풍 상태는 적절한가?','치료실 환경','CHECK',NULL,'Y'),
 ('MDRF','*',5,'기기 전원을켜면 Self Test 후 GOOD이 표시되는가?','의료기기 상태','CHECK',NULL,'Y'),
 ('MDRF','*',6,'타워 Display OPT. MODEM 펌프에 점등이되어 있는가?','의료기기 상태','CHECK',NULL,'Y'),
 ('MDRF','*',7,'Electrode 증류수양은 적절한가?','의료기기 상태','CHECK',NULL,'Y'),
 ('MDRF','*',8,'워터베드 냉각수양은 적절한가?','의료기기 상태','CHECK',NULL,'Y'),
 ('MDRF','*',9,'워터베드 Display는 정상적으로 작동 되는가?','의료기기 상태','CHECK',NULL,'Y'),
 ('MDRF','*',10,'워터베드 온도는 적절한가? (30℃내외)','의료기기 상태','CHECK',NULL,'Y'),
 ('MDRF','*',11,'점검자',NULL,'TEXT',NULL,'Y');

-- ITEM_MONTH
INSERT INTO TBL_QPS_CHK_ITEM (FORM_ID,HOSP_CD,SORT,ITEM_NM,GRP_NM,INPUT_GB,UNIT_NM,USE_YN) VALUES
 ('FALLENV','*',1,'침대바퀴,잠금장치,siderail 작동 확인',NULL,'CHECK',NULL,'Y'),
 ('FALLENV','*',2,'휠체어 바퀴,잠금장치 확인',NULL,'CHECK',NULL,'Y'),
 ('FALLENV','*',3,'이동침대 바퀴,잠금 확인',NULL,'CHECK',NULL,'Y'),
 ('FALLENV','*',4,'보행보조기구부속물점검(바퀴,팔걸이,고무패킹)',NULL,'CHECK',NULL,'Y'),
 ('FALLENV','*',5,'호출벨 부착,작동여부 확인',NULL,'CHECK',NULL,'Y'),
 ('FALLENV','*',6,'환자경로 바닥면 확인',NULL,'CHECK',NULL,'Y'),
 ('FALLENV','*',7,'침상 주변 정리 여부확인 (부속기구,전기코드나 환자의 부착물등)',NULL,'CHECK',NULL,'Y'),
 ('FALLENV','*',8,'미끄럼 방지 테이프 부착 여부 확인',NULL,'CHECK',NULL,'Y'),
 ('FALLENV','*',9,'낙상주의 표지판 부착 여부 확인',NULL,'CHECK',NULL,'Y'),
 ('FALLENV','*',10,'통로 물필요한 환경 위험요소 물건 제거',NULL,'CHECK',NULL,'Y'),
 ('FALLENV','*',11,'바닥 물기, 미끄러운용액 있는지 확인',NULL,'CHECK',NULL,'Y'),
 ('FALLENV','*',12,'조명밝기확인 (낮:밝게/야간:어둡지않게)',NULL,'CHECK',NULL,'Y'),
 ('FALLENV','*',13,'화장실과 샤워실 점검 (조명,미끄러질 위험이 있는 물질 즉시 처리)',NULL,'CHECK',NULL,'Y'),
 ('FALLENV','*',14,'복도 및 계단 안전바 점검',NULL,'CHECK',NULL,'Y'),
 ('FALLENV','*',15,'담당자서명(간호)',NULL,'TEXT',NULL,'Y'),
 ('FALLENV','*',16,'담당자서명(원무)',NULL,'TEXT',NULL,'Y');

-- 확인 --------------------------------------------------------------------
SELECT '서식' AS chk, AXIS_GB, COUNT(*) AS n FROM TBL_QPS_CHK_FORM WHERE HOSP_CD='*' GROUP BY AXIS_GB;
SELECT '항목' AS chk, f.FORM_ID, f.FORM_NM, f.AXIS_GB, COUNT(i.SORT) AS 항목수
  FROM TBL_QPS_CHK_FORM f LEFT JOIN TBL_QPS_CHK_ITEM i ON i.FORM_ID=f.FORM_ID AND i.HOSP_CD=f.HOSP_CD
 WHERE f.HOSP_CD='*' GROUP BY f.FORM_ID, f.FORM_NM, f.AXIS_GB ORDER BY f.SORT_NO;
SELECT '분류' AS chk, COUNT(*) FROM TBL_CODE_DTL WHERE CODE_CD='QPS_CHK_CATE';
