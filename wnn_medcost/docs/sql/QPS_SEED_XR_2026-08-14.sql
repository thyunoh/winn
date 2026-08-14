-- ═══════════════════════════════════════════════════════════════════════════
-- 방사선사(RADIO) 시드 — 점검표 21종 (2026-08-14)
--   판독 정본 : docs/proposals/QPS_서식판독_기타모듈_2026-08-14.md §XR_판독 (XR01~XR25)
--   전제 : QPS_DDL_CHK_GRPPRD(주기 복합) 적용 후. 부서 코드 RADIO 는 아래 ①에서 신설.
--   이 부서는 **의료기기 점검 격자가 절반 이상**이라 점검표 엔진에 가장 잘 맞는다.
--
-- ═══ ⛔등록 금지·보류 4종 ═══
--   XR25 직원 교육 결과 보고서 — `EDURPT` 로 등록됨(공용판 9곳째). **중복 금지**
--   XR07 납가운 관리대장(3쪽) — LIST + 평가기준 정형문 + **사진 2쪽(보호구 종류별 증빙사진)**.
--       점검표 엔진에는 사진칸이 없다(safeRpt 쪽에만 있다) ⇒ **사진 조각을 점검표로 넓힐지** 결정 후
--   XR18 방사선실 TAT 관리대장 — 추가/삭제/**엑셀 저장·불러오기** 버튼이 달린 데이터 그리드.
--       서식이라기보다 기능 화면(원무총무 w21 신판과 같은 성격) ⇒ 「엑셀 연동」 방침 확인 후
--   XR23 개인 피폭선량 측정부 — **개인별 연 단위**(성명·생년월일 머리 + 분기×심부/표층).
--       문서 키가 「사람 1명」이라 기존 키 설계(병원+년+월)에 없다. XR08(TLD)과 데이터도 겹친다 ⇒ 보류
--
-- ═══ 대조 결과 — **같은 판이지만 따로 넣는 것** ═══
--   XR04(CR 3303W/Direct View CR 950) ↔ XR12(DR MobiRAD50) : 판은 같고 **열 1개**(IP cassette↔Detector)와
--   **모델명**이 다르다. 모델명이 서식에 고정 기재돼 있어 한 벌로 묶으면 병원이 어느 장비 것인지 못 가른다 ⇒ **2벌**
--   XR14(고주파온열암 EHY-2000 Plus) ↔ XR16(고압산소 MEDICHAMBER O2 PLUS) : 같은 이유로 **2벌**
--   XR03(X-RAY 설비 점검표) ↔ XR10(진단용 X선발생장치) ↔ XR22(정도관리) : 항목이 겹치나 **구성이 달라 3벌**
--     (트리 이름은 03·10 이 같지만 **문서 제목이 다르다** — 문서 제목 기준)
--
-- ═══ 원본 오타 — 그대로 옮긴다 ═══
--   「Aaging」 · 「Gnadll shield」 · 「Carivelation」 · 「Monitor rightness/contrast contr0」 · 「Gird Moving」
--   XR11 「대기 의자」 2행 중복 · XR16 「인터폰작동은 잘되는지?」 2그룹 중복 — 원본이 그렇다
-- 재실행 안전(DELETE 후 INSERT · ON DUPLICATE KEY).
-- ═══════════════════════════════════════════════════════════════════════════

INSERT INTO TBL_CODE_DTL
 (CODE_GB, CODE_CD, SUB_CODE, JOB_SEQ, SUB_CODE_NM, START_DT, END_DT, USE_YN, SORT, ACTION_YN, REG_USER) VALUES
 ('Q','QPS_CHK_DEPT','RADIO',1,'방사선','20000101','99991231','Y',120,'Y','system')
ON DUPLICATE KEY UPDATE SUB_CODE_NM=VALUES(SUB_CODE_NM), SORT=VALUES(SORT), USE_YN='Y', ACTION_YN='Y';

DELETE FROM TBL_QPS_CHK_ITEM WHERE HOSP_CD='*' AND FORM_ID LIKE 'RAD%';
DELETE FROM TBL_QPS_CHK_FORM WHERE HOSP_CD='*' AND FORM_ID LIKE 'RAD%';

-- ═══ ② ITEM_DAY 8종 (항목 행 × 1~31일) ════════════════════════════════════
INSERT INTO TBL_QPS_CHK_FORM
 (FORM_ID, HOSP_CD, FORM_NM, CATE_CD, DEPT_CD, AXIS_GB, PRD_GB, PRD_KIND, GRP_PRD, HEAD_NMS,
  GUIDE_TXT, SIGNER_YN, NOTE_YN, FIX_YN, FOOT_TXT, SORT_NO, USE_YN, REG_USER) VALUES
 ('RAD001','*','낙상 예방점검표(방사선)','SAFE','RADIO','ITEM_DAY','M','D',NULL,NULL,
  '적합 : o, 부적합 : x','Y','Y','N',NULL,1950,'Y','system'),
 ('RAD002','*','X-RAY 설비 점검표','EQUIP','RADIO','ITEM_DAY','M','D',NULL,NULL,
  '적합 o, 부적합 x','Y','Y','N',NULL,1960,'Y','system'),
 ('RAD003','*','X-RAY Portable 점검표','EQUIP','RADIO','ITEM_DAY','M','D',NULL,NULL,
  '상태 : 양호(O), 정비요(△), 불량(X)','Y','N','N',NULL,1970,'Y','system'),
 ('RAD004','*','투시장치 (C-arm) 점검표','EQUIP','RADIO','ITEM_DAY','M','D',NULL,NULL,
  '적합 o, 부적합 x','Y','Y','N',NULL,1980,'Y','system'),
 ('RAD005','*','유방 촬영 장치 점검표(MAMMO)','EQUIP','RADIO','ITEM_DAY','M','D',NULL,NULL,
  '적합 o, 부적합 x','Y','Y','N',NULL,1990,'Y','system'),
 ('RAD006','*','진단용 X선발생장치 장비점검표','EQUIP','RADIO','ITEM_DAY','M','D',NULL,NULL,
  'o : 이상 없음, x : 이상 있음 · 점검주기 D : 일일점검(담당자), M : 월간점검(부서장)','Y','Y','Y',NULL,2000,'Y','system'),
 ('RAD007','*','초음파 영상진단기 일일점검표','EQUIP','RADIO','ITEM_DAY','M','D',NULL,NULL,
  '적합 o, 부적합 x','Y','Y','N',
  '※ 정상은 V 표시하고, 이상이 있으면 사용을 중지한 뒤 원무부(T.500)로 수리를 의뢰한다.  ※ 수리 의뢰 시 비고란에 「수리」로 표기하고, 당일 완료되면 빨간색 동그라미로 표시한다.  ※ 수리 중에는 사선으로 표기한다.',
  2010,'Y','system'),
 ('RAD008','*','방사선 보호구 일일점검표','EQUIP','RADIO','ITEM_DAY','M','D',NULL,NULL,
  '적합 o, 부적합 x','Y','Y','N',NULL,2020,'Y','system'),
 -- 주기 복합 2종
 ('RAD009','*','청소·소독 점검표(방사선)','ENV','RADIO','ITEM_DAY','M','D','매일>D,주 1회>N',NULL,
  '업무 종료 후 청소 시행 후 점검결과를 ○ ×(○ 양호, X 불량)로 표기한다. 단, 감염환자 사용 시 즉시 청소·소독 한다.',
  'Y','Y','N',NULL,2030,'Y','system'),
 ('RAD010','*','방사선과 정도관리','EQUIP','RADIO','ITEM_DAY','M','D',NULL,NULL,
  '적합 o, 부적합 x','Y','Y','N',NULL,2040,'Y','system');

INSERT INTO TBL_QPS_CHK_ITEM (FORM_ID,HOSP_CD,SORT,ITEM_NM,GRP_NM,DESC_TXT,INPUT_GB,CARRY_YN,USE_YN) VALUES
 -- RAD001 · XR02 낙상예방(방사선)
 ('RAD001','*',1,'낙상예방 지침 게시물 점검 (내용, 부착위치 및 상태)'    ,NULL,NULL,'CHECK','N','Y'),
 ('RAD001','*',2,'낙상주의 표시판 확인 (게시물, 스티커 부착)'            ,NULL,NULL,'CHECK','N','Y'),
 ('RAD001','*',3,'X-Ray촬영대 부속물 점검 (도움발판, 바퀴잠금장치 작동여부)',NULL,NULL,'CHECK','N','Y'),
 ('RAD001','*',4,'촬영대 주변 정리확인 (부속기구, 전기코드)'             ,NULL,NULL,'CHECK','N','Y'),
 ('RAD001','*',5,'바닥 점검(복도포함) (물기제거, 미끄러짐 요소 제거)'    ,NULL,NULL,'CHECK','N','Y'),
 ('RAD001','*',6,'조명확인'                                              ,NULL,NULL,'CHECK','N','Y'),
 ('RAD001','*',7,'낙상 고위험 환자 확인 (전산공유, 환자인식 밴드)'       ,NULL,NULL,'CHECK','N','Y'),
 -- RAD002 · XR03 X-RAY 설비
 ('RAD002','*',1,'origin 위치'      ,NULL,'X,Y,Z 정위치 될 것'        ,'CHECK','N','Y'),
 ('RAD002','*',2,'가동부'           ,NULL,'가동시 이상음이 없을것'    ,'CHECK','N','Y'),
 ('RAD002','*',3,'조별 청소 확인'   ,NULL,'설비내,외부의 청소상태 확인','CHECK','N','Y'),
 ('RAD002','*',4,'JOG SWITCH'       ,NULL,'파손 및 오작동 없을 것'    ,'CHECK','N','Y'),
 ('RAD002','*',5,'X-Ray AGING 시간' ,NULL,'15분이내 Aaging 될 것'     ,'CHECK','N','Y'),
 ('RAD002','*',6,'Laser pointer'    ,NULL,'Laser 조사, 고정상태 확인' ,'CHECK','N','Y'),
 ('RAD002','*',7,'납유리 Door'      ,NULL,'파손, 고정상태 확인'       ,'CHECK','N','Y'),
 ('RAD002','*',8,'FAN'              ,NULL,'소음, 막힘 확인'           ,'CHECK','N','Y'),
 -- RAD003 · XR05 Portable (3그룹)
 ('RAD003','*', 1,'Apron'                   ,'보호장비'       ,NULL,'CHECK','N','Y'),
 ('RAD003','*', 2,'Lead Glove'              ,'보호장비'       ,NULL,'CHECK','N','Y'),
 ('RAD003','*', 3,'Thyroid protector'       ,'보호장비'       ,NULL,'CHECK','N','Y'),
 ('RAD003','*', 4,'Gnadll shield'           ,'보호장비'       ,NULL,'CHECK','N','Y'),
 ('RAD003','*',11,'Power On/Off'            ,'장비'           ,NULL,'CHECK','N','Y'),
 ('RAD003','*',12,'Angulation'              ,'장비'           ,NULL,'CHECK','N','Y'),
 ('RAD003','*',13,'응급중단 스위치동작'     ,'장비'           ,NULL,'CHECK','N','Y'),
 ('RAD003','*',14,'기판 이상 유무'          ,'장비'           ,NULL,'CHECK','N','Y'),
 ('RAD003','*',15,'Cable 연결상태'          ,'장비'           ,NULL,'CHECK','N','Y'),
 ('RAD003','*',16,'외관 및 청결상태'        ,'장비'           ,NULL,'CHECK','N','Y'),
 ('RAD003','*',17,'Carivelation'            ,'장비'           ,NULL,'CHECK','N','Y'),
 ('RAD003','*',18,'외형상 파손 유무'        ,'장비'           ,NULL,'CHECK','N','Y'),
 ('RAD003','*',19,'Cable 피복 상태'         ,'장비'           ,NULL,'CHECK','N','Y'),
 ('RAD003','*',21,'외관 및 청결상태'        ,'I.I/Image chain',NULL,'CHECK','N','Y'),
 ('RAD003','*',22,'Monitor rightness/contrast contr0','I.I/Image chain',NULL,'CHECK','N','Y'),
 ('RAD003','*',23,'S-distortion 현상유무'   ,'I.I/Image chain',NULL,'CHECK','N','Y'),
 ('RAD003','*',24,'Ion spot 유무'           ,'I.I/Image chain',NULL,'CHECK','N','Y'),
 ('RAD003','*',25,'Flash(섬광) 유,무'       ,'I.I/Image chain',NULL,'CHECK','N','Y'),
 ('RAD003','*',26,'Foreign body 유,무'      ,'I.I/Image chain',NULL,'CHECK','N','Y'),
 -- RAD004 · XR06 C-arm
 ('RAD004','*',1,'외관상태점검 (Tube, Cable 등)',NULL,NULL,'CHECK','N','Y'),
 ('RAD004','*',2,'각종계기 및 표시장치 점검'   ,NULL,NULL,'CHECK','N','Y'),
 ('RAD004','*',3,'Tube 이동, 회전상태'         ,NULL,NULL,'CHECK','N','Y'),
 ('RAD004','*',4,'각종 조임상태'               ,NULL,NULL,'CHECK','N','Y'),
 ('RAD004','*',5,'조사야 및 램프상태'          ,NULL,NULL,'CHECK','N','Y'),
 ('RAD004','*',6,'Exp 스위치 점검'             ,NULL,NULL,'CHECK','N','Y'),
 ('RAD004','*',7,'Consol 점검'                 ,NULL,NULL,'CHECK','N','Y'),
 ('RAD004','*',8,'Bucky 점검'                  ,NULL,NULL,'CHECK','N','Y'),
 -- RAD005 · XR09 MAMMO
 ('RAD005','*',1,'Laser Printer 관리'      ,NULL,NULL,'CHECK','N','Y'),
 ('RAD005','*',2,'모니터 청소'             ,NULL,NULL,'CHECK','N','Y'),
 ('RAD005','*',3,'Flat Field Calibration'  ,NULL,NULL,'CHECK','N','Y'),
 ('RAD005','*',4,'판독실 환경'             ,NULL,NULL,'CHECK','N','Y'),
 -- RAD006 · XR10 진단용 X선발생장치 (구분 그룹 + 주기)
 ('RAD006','*', 1,'외관상태점검 (Tube, Cable 등)'   ,'촬영실','D','CHECK','N','Y'),
 ('RAD006','*', 2,'각종계기 및 표시장치 점검'       ,'촬영실','D','CHECK','N','Y'),
 ('RAD006','*', 3,'tube 이동, 회전상태'             ,'촬영실','D','CHECK','N','Y'),
 ('RAD006','*', 4,'각종 조임상태'                   ,'촬영실','D','CHECK','N','Y'),
 ('RAD006','*', 5,'조사야 및 램프상태'              ,'촬영실','D','CHECK','N','Y'),
 ('RAD006','*', 6,'Exp스위치 점검'                  ,'촬영실','D','CHECK','N','Y'),
 ('RAD006','*', 7,'Consol 점검'                     ,'촬영실','D','CHECK','N','Y'),
 ('RAD006','*', 8,'Bucky 점검'                      ,'촬영실','D','CHECK','N','Y'),
 ('RAD006','*',11,'전원공급'                        ,'DR'    ,'D','CHECK','N','Y'),
 ('RAD006','*',12,'외관손상'                        ,'DR'    ,'D','CHECK','N','Y'),
 ('RAD006','*',13,'기계 소음 및 잡음'               ,'DR'    ,'D','CHECK','N','Y'),
 ('RAD006','*',14,'서버와 장비 연결 문제 점검'      ,'DR'    ,'D','CHECK','N','Y'),
 ('RAD006','*',21,'Apron 및 기타 방어구점검'        ,'기구'  ,'D','CHECK','N','Y'),
 ('RAD006','*',22,'IP 카세트 파손'                  ,'기구'  ,'D','CHECK','N','Y'),
 ('RAD006','*',31,'청소 및 정리정돈'                ,'청소'  ,'D','CHECK','N','Y'),
 -- RAD007 · XR13 초음파
 ('RAD007','*',1,'전원스위치 확인'                       ,NULL,NULL,'CHECK','N','Y'),
 ('RAD007','*',2,'콘센트, 전원플러그 안전한 접합 점검'   ,NULL,NULL,'CHECK','N','Y'),
 ('RAD007','*',3,'Probe 상태점검'                        ,NULL,NULL,'CHECK','N','Y'),
 ('RAD007','*',4,'PACS 연결상태점검'                     ,NULL,NULL,'CHECK','N','Y'),
 -- RAD008 · XR20 보호구
 ('RAD008','*',1,'Apron(1)' ,NULL,NULL,'CHECK','N','Y'),
 ('RAD008','*',2,'Apron(2)' ,NULL,NULL,'CHECK','N','Y'),
 ('RAD008','*',3,'Thyroid'  ,NULL,NULL,'CHECK','N','Y'),
 ('RAD008','*',4,'Gonad'    ,NULL,NULL,'CHECK','N','Y'),
 -- RAD009 · XR11 청소·소독 (매일 8 + 주1회 2. ★「대기 의자」 2행은 원본 중복 그대로)
 ('RAD009','*', 1,'바닥 청소'              ,'매일'  ,NULL,'CHECK','N','Y'),
 ('RAD009','*', 2,'기구 및 문손잡이'       ,'매일'  ,NULL,'CHECK','N','Y'),
 ('RAD009','*', 3,'책상 및 PC표면'         ,'매일'  ,NULL,'CHECK','N','Y'),
 ('RAD009','*', 4,'촬영 장비 표면'         ,'매일'  ,NULL,'CHECK','N','Y'),
 ('RAD009','*', 5,'촬영 침대 표면'         ,'매일'  ,NULL,'CHECK','N','Y'),
 ('RAD009','*', 6,'조정기 표면'            ,'매일'  ,NULL,'CHECK','N','Y'),
 ('RAD009','*', 7,'대기 의자'              ,'매일'  ,NULL,'CHECK','N','Y'),
 ('RAD009','*', 8,'대기 의자'              ,'매일'  ,NULL,'CHECK','N','Y'),
 ('RAD009','*',11,'창틀'                   ,'주 1회',NULL,'CHECK','N','Y'),
 ('RAD009','*',12,'약·물품 보관장 내부'    ,'주 1회',NULL,'CHECK','N','Y'),
 -- RAD010 · XR22 정도관리
 ('RAD010','*', 1,'외관상태 점검 (Tube, 고압케이블)','진단용 X-RAY 장치','매일','CHECK','N','Y'),
 ('RAD010','*', 2,'각종 계기 및 표시장치'           ,'진단용 X-RAY 장치','매일','CHECK','N','Y'),
 ('RAD010','*', 3,'Tube 이동, 회전 상태'            ,'진단용 X-RAY 장치','매일','CHECK','N','Y'),
 ('RAD010','*', 4,'각종 조임 상태'                  ,'진단용 X-RAY 장치','매일','CHECK','N','Y'),
 ('RAD010','*', 5,'조사야 및 램프 점검'             ,'진단용 X-RAY 장치','매일','CHECK','N','Y'),
 ('RAD010','*', 6,'Gird Moving 상태 점검'           ,'진단용 X-RAY 장치','매일','CHECK','N','Y'),
 ('RAD010','*', 7,'Exposure 스위치 점검'            ,'진단용 X-RAY 장치','매일','CHECK','N','Y'),
 ('RAD010','*', 8,'Table 점검'                      ,'진단용 X-RAY 장치','매일','CHECK','N','Y'),
 ('RAD010','*',11,'전원 공급 상태'                  ,'CR'    ,'매일','CHECK','N','Y'),
 ('RAD010','*',12,'외관 상태'                       ,'CR'    ,'매일','CHECK','N','Y'),
 ('RAD010','*',13,'IP Cassette Moving 상태'         ,'CR'    ,'매일','CHECK','N','Y'),
 ('RAD010','*',14,'증감지 청소 및 인공물 확인'      ,'CR'    ,'매일','CHECK','N','Y'),
 ('RAD010','*',15,'IP Cassette 외관확인 및 청소'    ,'CR'    ,'매일','CHECK','N','Y'),
 ('RAD010','*',21,'Apron 및 기타 방어용구'          ,'방어용','매일','CHECK','N','Y'),
 ('RAD010','*',31,'청소 및 정리정돈'                ,'검사실','매일','CHECK','N','Y');

-- ═══ ③ DAY_ITEM 5종 (일 1~31 행 × 항목 열) ════════════════════════════════
--   ★모델명이 서식에 고정 기재된 4종은 머리 자유칸(HEAD_NMS)으로 함께 담는다.
INSERT INTO TBL_QPS_CHK_FORM
 (FORM_ID, HOSP_CD, FORM_NM, CATE_CD, DEPT_CD, AXIS_GB, PRD_GB, PRD_KIND, HEAD_NMS,
  GUIDE_TXT, SIGNER_YN, NOTE_YN, FIX_YN, SORT_NO, USE_YN, REG_USER) VALUES
 ('RAD011','*','일상점검일지 - CR장치','EQUIP','RADIO','DAY_ITEM','M','D','모델명,사용부서,점검주기',
  '양호(O), 불량 및 정비필요(X) · 모델 3303W / Direct View CR 950 · 영상의학과 · 매일 1회','N','Y','N',2050,'Y','system'),
 ('RAD012','*','일상점검일지 - DR장치','EQUIP','RADIO','DAY_ITEM','M','D','모델명,사용부서,점검주기',
  '양호(O), 불량 및 정비필요(X) · 모델 MobiRAD50 · 영상검사실 · 매일 1회','N','Y','N',2060,'Y','system'),
 ('RAD013','*','의료기기 일일점검표 - 고주파온열암치료기','EQUIP','RADIO','DAY_ITEM','M','D','제품,모델',
  '적합 : O, 부적합 : X · 의료용고주파온열암치료기 · EHY-2000 Plus','N','Y','N',2070,'Y','system'),
 ('RAD014','*','의료기기 일일점검표 - 고압산소치료기','EQUIP','RADIO','DAY_ITEM','M','D','제품,모델',
  '적합 : O, 부적합 : X · 의료용 고압산소치료기 · MEDICHAMBER O2 PLUS','N','Y','N',2080,'Y','system'),
 ('RAD015','*','방사선과 일일 점검표 (일반촬영장치)','EQUIP','RADIO','DAY_ITEM','M','D',NULL,
  '※ 매일 점검 원칙 · 점검 실시 유무를 O, X로 표시','N','Y','N',2090,'Y','system');

INSERT INTO TBL_QPS_CHK_ITEM (FORM_ID,HOSP_CD,SORT,ITEM_NM,GRP_NM,INPUT_GB,CARRY_YN,USE_YN) VALUES
 -- RAD011 · XR04 CR
 ('RAD011','*',1,'검사 전 청소상태'   ,NULL,'CHECK','N','Y'),
 ('RAD011','*',2,'System on/off'      ,NULL,'CHECK','N','Y'),
 ('RAD011','*',3,'Worklist·iView 연결',NULL,'CHECK','N','Y'),
 ('RAD011','*',4,'Preview 확인'       ,NULL,'CHECK','N','Y'),
 ('RAD011','*',5,'Image 전송'         ,NULL,'CHECK','N','Y'),
 ('RAD011','*',6,'IP cassette'        ,NULL,'CHECK','N','Y'),
 ('RAD011','*',7,'점검자'             ,NULL,'TEXT' ,'N','Y'),
 -- RAD012 · XR12 DR (열 1개만 다르다 — Detector)
 ('RAD012','*',1,'검사 전 청소상태'   ,NULL,'CHECK','N','Y'),
 ('RAD012','*',2,'System on/off'      ,NULL,'CHECK','N','Y'),
 ('RAD012','*',3,'Worklist·iView 연결',NULL,'CHECK','N','Y'),
 ('RAD012','*',4,'Preview 확인'       ,NULL,'CHECK','N','Y'),
 ('RAD012','*',5,'Image 전송'         ,NULL,'CHECK','N','Y'),
 ('RAD012','*',6,'Detector'           ,NULL,'CHECK','N','Y'),
 ('RAD012','*',7,'점검자'             ,NULL,'TEXT' ,'N','Y'),
 -- RAD013 · XR14 고주파온열암
 ('RAD013','*', 1,'실내온도는 적절한가? (15~23℃)'                      ,'치료실 환경','CHECK','N','Y'),
 ('RAD013','*', 2,'실내습도는 적절한가? (20~60%)'                       ,'치료실 환경','CHECK','N','Y'),
 ('RAD013','*', 3,'실내 청결 및 정리정돈 적절한가?'                     ,'치료실 환경','CHECK','N','Y'),
 ('RAD013','*', 4,'환기 및 통풍 상태는 적절한가?'                       ,'치료실 환경','CHECK','N','Y'),
 ('RAD013','*',11,'기기 전원올리면 Self Test 후 GOOD이 표시되는가?'     ,'의료기기 상태','CHECK','N','Y'),
 ('RAD013','*',12,'타워 Display OPT. MODEM 램프에 점등이되어 있는가?'   ,'의료기기 상태','CHECK','N','Y'),
 ('RAD013','*',13,'Electrode 종류수양은 적절한가?'                      ,'의료기기 상태','CHECK','N','Y'),
 ('RAD013','*',14,'워터베드 냉각수양은 적절한가?'                       ,'의료기기 상태','CHECK','N','Y'),
 ('RAD013','*',15,'워터베드 Display는 정상적으로 작동 되는가?'          ,'의료기기 상태','CHECK','N','Y'),
 ('RAD013','*',16,'워터베드 온도는 적절한가? (30℃내외)'                 ,'의료기기 상태','CHECK','N','Y'),
 ('RAD013','*',21,'점검자'                                              ,NULL,'TEXT','N','Y'),
 -- RAD014 · XR16 고압산소 (★「인터폰작동」 2그룹 중복은 원본 그대로)
 ('RAD014','*', 1,'기기실내,외 청결 및 정리정돈은 적절한가?'            ,'치료실 환경','CHECK','N','Y'),
 ('RAD014','*', 2,'환기 및 통풍상태는 적절한가?'                        ,'치료실 환경','CHECK','N','Y'),
 ('RAD014','*', 3,'인터폰작동은 잘되는지?'                              ,'치료실 환경','CHECK','N','Y'),
 ('RAD014','*', 4,'에어콘물받이 비어있는지유무?'                        ,'치료실 환경','CHECK','N','Y'),
 ('RAD014','*',11,'인터폰작동은 잘되는지?'                              ,'의료기기 상태','CHECK','N','Y'),
 ('RAD014','*',12,'압력계기판의 display는 정상적으로 작동되는가?'       ,'의료기기 상태','CHECK','N','Y'),
 ('RAD014','*',13,'타임설정에 display는 정상적으로 들어오는지?'         ,'의료기기 상태','CHECK','N','Y'),
 ('RAD014','*',14,'디스플레이 패널 녹물올2개가기록유무'                 ,'의료기기 상태','CHECK','N','Y'),
 ('RAD014','*',15,'출입구의 작동이 잘되는지?'                           ,'의료기기 상태','CHECK','N','Y'),
 ('RAD014','*',21,'점검자'                                              ,NULL,'TEXT','N','Y'),
 -- RAD015 · XR21 일반촬영장치
 ('RAD015','*',1,'전원공급장치'    ,NULL,'CHECK','N','Y'),
 ('RAD015','*',2,'EX BT'           ,NULL,'CHECK','N','Y'),
 ('RAD015','*',3,'X-선관 작동'     ,NULL,'CHECK','N','Y'),
 ('RAD015','*',4,'Table 작동'      ,NULL,'CHECK','N','Y'),
 ('RAD015','*',5,'조리개 조절장치' ,NULL,'CHECK','N','Y'),
 ('RAD015','*',6,'ST-Bucky 작동'   ,NULL,'CHECK','N','Y'),
 ('RAD015','*',7,'Table Bucky'     ,NULL,'CHECK','N','Y'),
 ('RAD015','*',8,'점검자'          ,NULL,'TEXT' ,'N','Y');

-- ═══ ④ EQUIP_DAY 1 · ITEM_MONTH 1 · LIST 4 ════════════════════════════════
INSERT INTO TBL_QPS_CHK_FORM
 (FORM_ID, HOSP_CD, FORM_NM, CATE_CD, DEPT_CD, AXIS_GB, PRD_GB, PRD_KIND, EQUIP_CNT,
  SIGNER_YN, NOTE_YN, FIX_YN, SORT_NO, USE_YN, REG_USER) VALUES
 ('RAD016','*','일상점검표 - 의료기기-ALL(방사선)','EQUIP','RADIO','EQUIP_DAY','M','D',10,'Y','N','Y',2100,'Y','system'),
 ('RAD017','*','영상TAT 월별 결과보고서'          ,'ETC'  ,'RADIO','ITEM_MONTH','Y',NULL,10,'N','N','N',2110,'Y','system'),
 ('RAD018','*','영상검사실 TAT 판독 관리대장 - 외부의뢰용','ETC','RADIO','LIST','M',NULL,30,'N','N','N',2120,'Y','system'),
 ('RAD019','*','영상검사 CVR 결과 관리대장'       ,'ETC'  ,'RADIO','LIST','M',NULL,20,'N','N','N',2130,'Y','system'),
 ('RAD020','*','방사선과 장비 수리 대장'          ,'EQUIP','RADIO','LIST','Y',NULL,10,'N','N','N',2140,'Y','system'),
 ('RAD021','*','TLD 관리대장'                     ,'SAFE' ,'RADIO','ITEM_COL','Y',NULL,10,'N','N','N',2150,'Y','system');

INSERT INTO TBL_QPS_CHK_ITEM (FORM_ID,HOSP_CD,SORT,ITEM_NM,GRP_NM,INPUT_GB,CARRY_YN,USE_YN) VALUES
 -- RAD016 · XR17 (항목 6개 = 타 부서 「일상점검표-의료기기」와 같은 세트)
 ('RAD016','*',1,'전원 결합 여부'      ,NULL,'CHECK','N','Y'),
 ('RAD016','*',2,'청결 상태'           ,NULL,'CHECK','N','Y'),
 ('RAD016','*',3,'가동 이상 여부'      ,NULL,'CHECK','N','Y'),
 ('RAD016','*',4,'보관 상태'           ,NULL,'CHECK','N','Y'),
 ('RAD016','*',5,'저장 장소 비치 여부' ,NULL,'CHECK','N','Y'),
 ('RAD016','*',6,'청소/소독 상태 점검' ,NULL,'CHECK','N','Y'),
 -- RAD017 · XR01 월별 통계
 ('RAD017','*',1,'총 촬영 건수'  ,NULL,'NUM','N','Y'),
 ('RAD017','*',2,'충족 촬영 건수',NULL,'NUM','N','Y'),
 ('RAD017','*',3,'미비율'        ,NULL,'NUM','N','Y'),
 ('RAD017','*',4,'완결율'        ,NULL,'NUM','N','Y'),
 -- RAD018 · XR15
 ('RAD018','*',1,'등록번호',NULL,'TEXT','N','Y'),
 ('RAD018','*',2,'환자성명',NULL,'TEXT','N','Y'),
 ('RAD018','*',3,'병동'    ,NULL,'TEXT','N','Y'),
 ('RAD018','*',4,'촬영명'  ,NULL,'TEXT','N','Y'),
 ('RAD018','*',5,'의뢰일'  ,NULL,'TEXT','N','Y'),
 ('RAD018','*',6,'완료일'  ,NULL,'TEXT','N','Y'),
 ('RAD018','*',7,'TAT충족' ,NULL,'TEXT','N','Y'),
 ('RAD018','*',8,'비고'    ,NULL,'TEXT','N','Y'),
 -- RAD019 · XR19 CVR
 ('RAD019','*',1,'날짜'            ,NULL,'TEXT','N','Y'),
 ('RAD019','*',2,'등록번호'        ,NULL,'TEXT','N','Y'),
 ('RAD019','*',3,'환자명'          ,NULL,'TEXT','N','Y'),
 ('RAD019','*',4,'병실'            ,NULL,'TEXT','N','Y'),
 ('RAD019','*',5,'검사항목 및 결과',NULL,'TEXT','N','Y'),
 ('RAD019','*',6,'보고시간'        ,NULL,'TEXT','N','Y'),
 ('RAD019','*',7,'보고자'          ,NULL,'TEXT','N','Y'),
 ('RAD019','*',8,'담당의'          ,NULL,'TEXT','N','Y'),
 -- RAD020 · XR24 수리대장
 ('RAD020','*',1,'수리일자'   ,NULL,'TEXT','N','Y'),
 ('RAD020','*',2,'수리 부품명',NULL,'TEXT','N','Y'),
 ('RAD020','*',3,'수리결과'   ,NULL,'TEXT','N','Y'),
 ('RAD020','*',4,'동작상태'   ,NULL,'TEXT','N','Y'),
 ('RAD020','*',5,'비고'       ,NULL,'TEXT','N','Y'),
 -- RAD021 · XR08 TLD (분기 4열 = ITEM_COL 고정 열)
 ('RAD021','*',1,'도착일'      ,NULL,'TEXT','N','Y'),
 ('RAD021','*',2,'회송일'      ,NULL,'TEXT','N','Y'),
 ('RAD021','*',3,'착용 시작일' ,NULL,'TEXT','N','Y'),
 ('RAD021','*',4,'착용 종료일' ,NULL,'TEXT','N','Y'),
 ('RAD021','*',5,'심부'        ,'피폭량','TEXT','N','Y'),
 ('RAD021','*',6,'표층'        ,'피폭량','TEXT','N','Y'),
 ('RAD021','*',7,'담당자 서명' ,NULL,'TEXT','N','Y');

UPDATE TBL_QPS_CHK_FORM SET COL_NMS='1월~3월,4월~6월,7월~9월,10월~12월'
 WHERE HOSP_CD='*' AND FORM_ID='RAD021';

-- ── 확인 ────────────────────────────────────────────────────────────────────
SELECT AXIS_GB, COUNT(*) n FROM TBL_QPS_CHK_FORM WHERE HOSP_CD='*' AND FORM_ID LIKE 'RAD%' GROUP BY AXIS_GB;
SELECT FORM_ID, FORM_NM, AXIS_GB, IFNULL(GRP_PRD,'-') grp, IFNULL(COL_NMS,'-') cols,
       (SELECT COUNT(*) FROM TBL_QPS_CHK_ITEM i WHERE i.FORM_ID=f.FORM_ID AND i.HOSP_CD='*') items
  FROM TBL_QPS_CHK_FORM f WHERE f.HOSP_CD='*' AND FORM_ID LIKE 'RAD%' ORDER BY FORM_ID;
