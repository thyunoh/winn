-- ═══════════════════════════════════════════════════════════════════════════
-- 인공신장(RENAL) 시드 — 점검표 25종 (2026-08-14)
--   판독 정본 : docs/proposals/QPS_서식판독_기타모듈_2026-08-14.md §RN_판독 (RN01~RN42)
--   전제 : QPS_DDL_CHK_GRPPRD(주기 복합) 적용 후. 부서 코드 RENAL 은 아래 ①에서 신설.
--
-- ═══ ⛔등록 금지 7종 — **DB 항목 문자열로 대조 확정**(이름이 아니라 항목으로 봤다) ═══
--   RN38 린넨실 청소·소독  = `LINEN`   (간호)   — 항목 「점검자」 하나까지 같다
--   RN40 AED 일상점검표    = `NUR014`  (간호)   — 8열 겹공백(`배터리 상 태`)까지 같다
--   RN41 학대·폭력 예방    = `NUR025`  (간호)   — 5항목 전부 글자까지 같다
--   RN26 월별비치의약품    = `PHA025~028`(약국) — 제형별 4벌이 이미 등록돼 있다(주사/경구/시럽/수액)
--   RN27 응급약품점검기록부 = `PHA024`  (약국)   — 수량(5)/유효기간/파손유무 × 1~12월 동일
--   RN33 혈액 관리 대장    = `NUR011`  (간호)   — 13열 동일(수령자 서명 2칸 포함)
--   RN34 혈액냉장고 불출대장 = `NUR012` (간호)   — 9열 동일
--   ⇒ 부서만 다른 같은 종이다. **부서 공유**로 쓴다(보고서 폴더·AED 전례). 병원확인 #36 계열.
--
-- ═══ ⛔보류 10종 (조각·대조가 먼저 — 반쪽 등록 금지) ═══
--   RN08·09·10 검사결과 문서형(미생물/내독소/미세물질) — 인적 헤더 + 참고치 표 + 의의 문단.
--       격자도 safeRpt 도 아니다(검사 성적서). ⚠RN08↔09 는 사실상 같은 판(제목만 다름)
--   RN16 인공신장기 예방점검표 — 「장비행 × 체크항목 + 결과 2단행」, 일자 1회. 원무총무 w43~45 와 같은 계열
--       ⇒ 「항목×날짜아닌 고정열」 조각 설계 때 함께(WM 보류 8종과 근거 합산)
--   RN25 병동비치약품점검표 — 약품 목록(LIST) + 일31 3점검이 **한 문서**에 붙은 복합. 약국 PHA020 과 대조도 남음
--   RN28 의약품부작용보고서 · RN29 의약품 불량·파손보고서 — safeRpt 쪽이나 **약국 동명 서식과 대조 후**
--   RN37 혈액 반납/폐기 신청서 — 간호 [201]·진단검사 11 과 같은 종이(진단검사 판독 §4-3). safeRpt 몫이나
--       DRUGRTN 확인 2건과 함께 처리(인수인계 §7)
--   RN42 직원 교육 결과 보고서 — **`EDURPT` 로 이미 등록**(공용판 9곳째). 중복 금지
--   RN31 응급키트 물품점검대장 — 물품 21행 프리셋 + 상단 2행(봉인/Laryngoscope) + 유효기간 열이 섞여
--       ITEM_DAY 로 넣으면 유효기간 열이 사라진다. 앞/뒤 열은 ITEM_DAY 에 없다(sideOk 는 ITEM_DAY 포함이나
--       원본은 **행마다 다른 유효기간** = 문서 값) ⇒ 「항목 앞/뒤 열」 조각 확인 후
--
-- ═══ 원본 그대로 옮긴 오타 (병원이 쓰던 종이와 글자가 달라지면 안 된다) ═══
--   「썩 션 기」 · 「습고 기록지」(습도) · 「키보트」 · 「Alam」 · 「Poper」
-- 재실행 안전(DELETE 후 INSERT · 코드 ON DUPLICATE KEY).
-- ═══════════════════════════════════════════════════════════════════════════

-- ── ① 부서 코드 ─────────────────────────────────────────────────────────────
INSERT INTO TBL_CODE_DTL
 (CODE_GB, CODE_CD, SUB_CODE, JOB_SEQ, SUB_CODE_NM, START_DT, END_DT, USE_YN, SORT, ACTION_YN, REG_USER) VALUES
 ('Q','QPS_CHK_DEPT','RENAL',1,'인공신장','20000101','99991231','Y',100,'Y','system')
ON DUPLICATE KEY UPDATE SUB_CODE_NM=VALUES(SUB_CODE_NM), SORT=VALUES(SORT), USE_YN='Y', ACTION_YN='Y';

DELETE FROM TBL_QPS_CHK_ITEM WHERE HOSP_CD='*' AND FORM_ID LIKE 'RNL%';
DELETE FROM TBL_QPS_CHK_FORM WHERE HOSP_CD='*' AND FORM_ID LIKE 'RNL%';

-- ═══ ② EQUIP_DAY 5종 — 기기 행(문서가 이름 적음) × 1~31일 ══════════════════
--   점검항목은 머리에 가로로 나열된다(EQUIP_DAY 의 기본 모양). 하단 = 점검자 확인란 + 수리내용.
INSERT INTO TBL_QPS_CHK_FORM
 (FORM_ID, HOSP_CD, FORM_NM, CATE_CD, DEPT_CD, AXIS_GB, PRD_GB, PRD_KIND, EQUIP_CNT,
  SIGNER_YN, NOTE_YN, FIX_YN, SORT_NO, USE_YN, REG_USER) VALUES
 ('RNL001','*','의료기기 일상점검표(인공신장)','EQUIP','RENAL','EQUIP_DAY','M','D',30,'Y','N','Y',1510,'Y','system'),
 ('RNL002','*','의료기기 일상점검표(투석기)'  ,'EQUIP','RENAL','EQUIP_DAY','M','D',30,'Y','N','Y',1520,'Y','system'),
 ('RNL003','*','의료기기 일상점검표 - E K G'  ,'EQUIP','RENAL','EQUIP_DAY','M','D',10,'Y','N','Y',1530,'Y','system'),
 ('RNL004','*','EKG모니터 일일 점검표'        ,'EQUIP','RENAL','EQUIP_DAY','M','D',10,'Y','N','Y',1540,'Y','system'),
 ('RNL005','*','의료기기 일상점검표 - 썩 션 기','EQUIP','RENAL','EQUIP_DAY','M','D',10,'Y','N','Y',1550,'Y','system');
INSERT INTO TBL_QPS_CHK_ITEM (FORM_ID,HOSP_CD,SORT,ITEM_NM,INPUT_GB,CARRY_YN,USE_YN) VALUES
 ('RNL001','*',1,'전원 결합 여부','CHECK','N','Y'),('RNL001','*',2,'청결 상태','CHECK','N','Y'),
 ('RNL001','*',3,'가동 이상 여부','CHECK','N','Y'),('RNL001','*',4,'보관 상태','CHECK','N','Y'),
 ('RNL001','*',5,'저장 장소 비치 여부','CHECK','N','Y'),('RNL001','*',6,'청소/소독 상태 점검','CHECK','N','Y'),
 ('RNL002','*',1,'외관','CHECK','N','Y'),('RNL002','*',2,'콘센트·전원','CHECK','N','Y'),
 ('RNL002','*',3,'Error Message','CHECK','N','Y'),('RNL002','*',4,'투석농도(135~145)','CHECK','N','Y'),
 ('RNL002','*',5,'투석온도(35~36.5)','CHECK','N','Y'),('RNL002','*',6,'투석액 Flow(500~800ml/min)','CHECK','N','Y'),
 ('RNL003','*',1,'장비외관 손상','CHECK','N','Y'),('RNL003','*',2,'콘센트 접합','CHECK','N','Y'),
 ('RNL003','*',3,'Poper 이상유무','CHECK','N','Y'),('RNL003','*',4,'전원스위치','CHECK','N','Y'),
 ('RNL003','*',5,'기기 청소','CHECK','N','Y'),('RNL003','*',6,'흉부·사지 전극','CHECK','N','Y'),
 ('RNL003','*',7,'키보트 동작','CHECK','N','Y'),('RNL003','*',8,'Cable 상태','CHECK','N','Y'),
 ('RNL004','*',1,'심전도케이블','CHECK','N','Y'),('RNL004','*',2,'NIBP','CHECK','N','Y'),
 ('RNL004','*',3,'SPO2','CHECK','N','Y'),('RNL004','*',4,'Electrode','CHECK','N','Y'),
 ('RNL004','*',5,'전원공급','CHECK','N','Y'),('RNL004','*',6,'Booting','CHECK','N','Y'),
 ('RNL004','*',7,'디스플레이','CHECK','N','Y'),('RNL004','*',8,'High,Low Limit Alam','CHECK','N','Y'),
 ('RNL004','*',9,'동작중 Error','CHECK','N','Y'),
 ('RNL005','*',1,'전원공급','CHECK','N','Y'),('RNL005','*',2,'배액통 마개','CHECK','N','Y'),
 ('RNL005','*',3,'연결관 막을 때 압력','CHECK','N','Y'),('RNL005','*',4,'새는 곳','CHECK','N','Y'),
 ('RNL005','*',5,'동작중 Error','CHECK','N','Y'),('RNL005','*',6,'배수줄 상태','CHECK','N','Y');

-- ═══ ③ ITEM_DAY 6종 (주기 복합 3 포함) ══════════════════════════════════════
--   ★RN21·23·24 는 「매일 / 주1회 / 분기 / 년1회」 주기가 한 장에 있다 ⇒ GRP_PRD.
--     묶음 이름은 항목의 GRP_NM 과 **글자가 같아야** 그 구간이 그려진다(LAB 시드 전례).
INSERT INTO TBL_QPS_CHK_FORM
 (FORM_ID, HOSP_CD, FORM_NM, CATE_CD, DEPT_CD, AXIS_GB, PRD_GB, PRD_KIND, GRP_PRD,
  GUIDE_TXT, SIGNER_YN, NOTE_YN, FIX_YN, SORT_NO, USE_YN, REG_USER) VALUES
 ('RNL006','*','낙상예방점검표(인공신장)','SAFE','RENAL','ITEM_DAY','M','D',NULL,
  '적합 : O, 부적합 : X','Y','Y','N',1560,'Y','system'),
 ('RNL007','*','R/O 일일점검표','EQUIP','RENAL','ITEM_DAY','M','D','매일>D,미생물검사>1',
  NULL,'Y','Y','N',1570,'Y','system'),
 ('RNL008','*','병동환경관리점검일지(인공신장)','ENV','RENAL','ITEM_DAY','M','D',
  '매일 1회>D,주 1회>N,분기별>1,년 1회>1,즉시>1','양호 ○, 불량 X · 매일 오전 10시','Y','Y','N',1580,'Y','system'),
 ('RNL009','*','병동청결상태점검표(인공신장)','ENV','RENAL','ITEM_DAY','M','D',NULL,
  '양호 ○, 불량 X','Y','Y','N',1590,'Y','system'),
 ('RNL010','*','인공신장실 청소·소독 점검표','ENV','RENAL','ITEM_DAY','M','D','매일>D,주 1회>N',
  '매일 Day번 책임간호사 ○ ×','Y','Y','N',1600,'Y','system'),
 ('RNL011','*','멸균 물품장 관리대장(인공신장)','STERIL','RENAL','ITEM_DAY','M','D','매일>D,주 1회>N',
  '온도 24℃ 이하 · 습도 70% 이하 · 매일 1회 10시 · 예 O 아니오 X','Y','Y','N',1610,'Y','system'),
 ('RNL012','*','감염관리리스트(인공신장)','SAFE','RENAL','ITEM_DAY','M','D',NULL,
  '양호 ○, 불량 X · 매일 10시','Y','Y','N',1620,'Y','system');
INSERT INTO TBL_QPS_CHK_ITEM (FORM_ID,HOSP_CD,SORT,ITEM_NM,GRP_NM,INPUT_GB,CARRY_YN,USE_YN) VALUES
 -- RN02 낙상예방
 ('RNL006','*',1,'낙상예방 지침 게시물',NULL,'CHECK','N','Y'),
 ('RNL006','*',2,'낙상주의 표시판',NULL,'CHECK','N','Y'),
 ('RNL006','*',3,'침대 부속물(SIDE RAIL, 바퀴잠금장치)',NULL,'CHECK','N','Y'),
 ('RNL006','*',4,'침대 주변 정리',NULL,'CHECK','N','Y'),
 ('RNL006','*',5,'바닥 점검(복도포함)',NULL,'CHECK','N','Y'),
 ('RNL006','*',6,'조명확인',NULL,'CHECK','N','Y'),
 ('RNL006','*',7,'낙상 고위험 환자 확인(전산공유, 환자인식 밴드)',NULL,'CHECK','N','Y'),
 -- RN14 R/O 일일점검 (+ 미생물검사 2행 = 다른 주기)
 ('RNL007','*', 1,'water inlet(3이상)','매일','CHECK','N','Y'),
 ('RNL007','*', 2,'multi filter(3-6)','매일','CHECK','N','Y'),
 ('RNL007','*', 3,'softener','매일','CHECK','N','Y'),
 ('RNL007','*', 4,'carbon filter','매일','CHECK','N','Y'),
 ('RNL007','*', 5,'5μ filter','매일','CHECK','N','Y'),
 ('RNL007','*', 6,'R/O(TDS) cond.out(1-10)','매일','CHECK','N','Y'),
 ('RNL007','*', 7,'R/O(TDS) cond.in(200정도)','매일','CHECK','N','Y'),
 ('RNL007','*', 8,'환경 바닥청결','매일','CHECK','N','Y'),
 ('RNL007','*',11,'투석액 박테리아(매월)','미생물검사','CHECK','N','Y'),
 ('RNL007','*',12,'투석액 내독소(분기)','미생물검사','CHECK','N','Y'),
 -- RN21 병동환경관리점검일지 (주기 5구간)
 ('RNL008','*', 1,'처치카트','매일 1회','CHECK','N','Y'),
 ('RNL008','*', 2,'청진기·체온계·혈압기','매일 1회','CHECK','N','Y'),
 ('RNL008','*', 3,'컴퓨터·주변기기','매일 1회','CHECK','N','Y'),
 ('RNL008','*', 4,'화장실·샤워실','매일 1회','CHECK','N','Y'),
 ('RNL008','*', 5,'바닥청소','매일 1회','CHECK','N','Y'),
 ('RNL008','*', 6,'세면대','매일 1회','CHECK','N','Y'),
 ('RNL008','*', 7,'상두대·전화기','매일 1회','CHECK','N','Y'),
 ('RNL008','*', 8,'환자침대·호출벨','매일 1회','CHECK','N','Y'),
 ('RNL008','*', 9,'병실 문손잡이','매일 1회','CHECK','N','Y'),
 ('RNL008','*',10,'음용수 관리','매일 1회','CHECK','N','Y'),
 ('RNL008','*',11,'휠체어·워커','주 1회','CHECK','N','Y'),
 ('RNL008','*',12,'이동침대·폴대','주 1회','CHECK','N','Y'),
 ('RNL008','*',13,'냉장고(병실·검체·약품)','주 1회','CHECK','N','Y'),
 ('RNL008','*',21,'침상커튼','분기별','CHECK','N','Y'),
 ('RNL008','*',22,'부서 대청소','분기별','CHECK','N','Y'),
 ('RNL008','*',31,'에어컨·선풍기','년 1회','CHECK','N','Y'),
 ('RNL008','*',41,'응급(혈액오염)','즉시','CHECK','N','Y'),
 -- RN22 병동청결상태
 ('RNL009','*',1,'병실'      ,NULL,'CHECK','N','Y'),
 ('RNL009','*',2,'처치실'    ,NULL,'CHECK','N','Y'),
 ('RNL009','*',3,'간호사실'  ,NULL,'CHECK','N','Y'),
 ('RNL009','*',4,'공용복도'  ,NULL,'CHECK','N','Y'),
 ('RNL009','*',5,'로비'      ,NULL,'CHECK','N','Y'),
 ('RNL009','*',6,'창문·커튼' ,NULL,'CHECK','N','Y'),
 ('RNL009','*',7,'화장실'    ,NULL,'CHECK','N','Y'),
 ('RNL009','*',8,'샤워실'    ,NULL,'CHECK','N','Y'),
 -- RN23 청소·소독 (매일 10 + 주1회 4)
 ('RNL010','*', 1,'간호사실 바닥'          ,'매일','CHECK','N','Y'),
 ('RNL010','*', 2,'보관장 표면·문손잡이'   ,'매일','CHECK','N','Y'),
 ('RNL010','*', 3,'Station·컴퓨터 표면'    ,'매일','CHECK','N','Y'),
 ('RNL010','*', 4,'장비·보관용기'          ,'매일','CHECK','N','Y'),
 ('RNL010','*', 5,'Tray·카트'              ,'매일','CHECK','N','Y'),
 ('RNL010','*', 6,'수전·싱크대'            ,'매일','CHECK','N','Y'),
 ('RNL010','*', 7,'정수기 물받이·표면'     ,'매일','CHECK','N','Y'),
 ('RNL010','*', 8,'전자레인지 내부·표면'   ,'매일','CHECK','N','Y'),
 ('RNL010','*', 9,'냉장고 표면'            ,'매일','CHECK','N','Y'),
 ('RNL010','*',10,'약물 이동 용기'         ,'매일','CHECK','N','Y'),
 ('RNL010','*',11,'창틀'                   ,'주 1회','CHECK','N','Y'),
 ('RNL010','*',12,'약·물품 보관장 내부'    ,'주 1회','CHECK','N','Y'),
 ('RNL010','*',13,'냉장고 선반·내부'       ,'주 1회','CHECK','N','Y'),
 ('RNL010','*',14,'청결 린넨장'            ,'주 1회','CHECK','N','Y'),
 -- RN24 멸균물품장 관리대장 (★NUR008 과 항목이 달라 별건 — 대조 확인함)
 ('RNL011','*', 1,'포장 구멍'              ,'매일','CHECK','N','Y'),
 ('RNL011','*', 2,'멸균포장 열림'          ,'매일','CHECK','N','Y'),
 ('RNL011','*', 3,'물방울·젖음'            ,'매일','CHECK','N','Y'),
 ('RNL011','*', 4,'바닥에 떨어짐'          ,'매일','CHECK','N','Y'),
 ('RNL011','*', 5,'멸균테이프 떨어짐'      ,'매일','CHECK','N','Y'),
 ('RNL011','*', 6,'유효기간 불분명'        ,'매일','CHECK','N','Y'),
 ('RNL011','*', 7,'멸균여부 의심'          ,'매일','CHECK','N','Y'),
 ('RNL011','*', 8,'온도(℃)'                ,'매일','NUM'  ,'N','Y'),
 ('RNL011','*', 9,'습도(%)'                ,'매일','NUM'  ,'N','Y'),
 ('RNL011','*',11,'소독여부 확인(희석 락스 500ppm)','주 1회','CHECK','N','Y'),
 -- RN39 감염관리리스트
 ('RNL012','*', 1,'손위생 순회점검(교차감염 예방·습관화유도)'      ,'매일','CHECK','N','Y'),
 ('RNL012','*', 2,'흡인 관련 감염 관리(손씻기·카테터·식염수·폐기물)','매일','CHECK','N','Y'),
 ('RNL012','*', 3,'소독물품 관리(확인체계)'                        ,'매일','CHECK','N','Y'),
 ('RNL012','*', 4,'멸균물품장 관리(선입선출)'                      ,'매일','CHECK','N','Y'),
 ('RNL012','*', 5,'1회용품 관리'                                   ,'매일','CHECK','N','Y'),
 ('RNL012','*', 6,'의료 폐기물 관리'                               ,'매일','CHECK','N','Y'),
 ('RNL012','*', 7,'손상성 폐기물 관리'                             ,'매일','CHECK','N','Y'),
 ('RNL012','*',11,'중심 정맥관'                                    ,'카테터 감염관리','CHECK','N','Y'),
 ('RNL012','*',12,'유치도뇨관'                                     ,'카테터 감염관리','CHECK','N','Y'),
 ('RNL012','*',13,'인공호흡기 관리'                                ,'카테터 감염관리','CHECK','N','Y');

-- ═══ ④ DAY_ITEM 6종 — 일 1~31 행 × 항목 열 ═════════════════════════════════
--   ★냉장고 4종은 기존 등록분(LAB003·004 등)과 **같은 구조·다른 부서**다 —
--     「부서마다 다른 판을 쓰는가」는 병원확인 #36 과 같은 사안이라 일단 부서 서식으로 넣는다.
INSERT INTO TBL_QPS_CHK_FORM
 (FORM_ID, HOSP_CD, FORM_NM, CATE_CD, DEPT_CD, AXIS_GB, PRD_GB, PRD_KIND, PRD_SUB,
  GUIDE_TXT, SIGNER_YN, NOTE_YN, FIX_YN, SORT_NO, USE_YN, REG_USER) VALUES
 ('RNL013','*','약품냉장고관리(인공신장)'  ,'DRUG'  ,'RENAL','DAY_ITEM','M','D','9am,6pm'    ,'적정온도 2~8℃','N','N','N',1630,'Y','system'),
 ('RNL014','*','약품냉장고 점검대장(인공신장)','DRUG','RENAL','DAY_ITEM','M','D','9am,5pm,2am','적정온도 2~8℃','N','N','N',1640,'Y','system'),
 ('RNL015','*','혈액냉장고관리(인공신장)'  ,'SAFE'  ,'RENAL','DAY_ITEM','M','D','9am,6pm'    ,'적정온도 2~8℃','N','N','N',1650,'Y','system'),
 ('RNL016','*','혈액냉장고 점검대장(인공신장)','SAFE','RENAL','DAY_ITEM','M','D','9am,5pm,2am','적정온도 2~8℃','N','N','N',1660,'Y','system'),
 ('RNL017','*','멸균물품 보관장소 온도, 습고 기록지','STERIL','RENAL','DAY_ITEM','M','D',NULL,NULL,'N','N','N',1670,'Y','system'),
 ('RNL018','*','응급카트 봉인 점검표 관리대장','SAFE','RENAL','DAY_ITEM','M','D',NULL,NULL,'N','N','N',1680,'Y','system');
INSERT INTO TBL_QPS_CHK_ITEM (FORM_ID,HOSP_CD,SORT,ITEM_NM,INPUT_GB,UNIT_NM,CARRY_YN,USE_YN) VALUES
 ('RNL013','*',1,'냉장고 온도','NUM','℃','N','Y'),('RNL013','*',2,'점검자','TEXT',NULL,'N','Y'),
 ('RNL014','*',1,'냉장고 온도','NUM','℃','N','Y'),('RNL014','*',2,'점검자','TEXT',NULL,'N','Y'),
 ('RNL015','*',1,'냉장고 온도','NUM','℃','N','Y'),('RNL015','*',2,'점검자','TEXT',NULL,'N','Y'),
 ('RNL016','*',1,'냉장고 온도','NUM','℃','N','Y'),('RNL016','*',2,'점검자','TEXT',NULL,'N','Y'),
 ('RNL017','*',1,'온도','NUM','℃','N','Y'),('RNL017','*',2,'습도','NUM','%','N','Y'),
 ('RNL017','*',3,'점검자','TEXT',NULL,'N','Y'),
 ('RNL018','*',1,'D 점검자','TEXT',NULL,'N','Y'),('RNL018','*',2,'E 점검자','TEXT',NULL,'N','Y'),
 ('RNL018','*',3,'N 점검자','TEXT',NULL,'N','Y'),('RNL018','*',4,'봉인지번호','TEXT',NULL,'N','Y');

-- ═══ ⑤ ITEM_MONTH 4종 — 항목 행 × 1~12월 (연 문서) ═════════════════════════
INSERT INTO TBL_QPS_CHK_FORM
 (FORM_ID, HOSP_CD, FORM_NM, CATE_CD, DEPT_CD, AXIS_GB, PRD_GB, POST_COLS, DESC_NM,
  GUIDE_TXT, SIGNER_YN, NOTE_YN, FIX_YN, FOOT_TXT, SORT_NO, USE_YN, REG_USER) VALUES
 ('RNL019','*','낙상 시설, 환경 관리일지(인공신장)','SAFE','RENAL','ITEM_MONTH','Y','비고',NULL,
  NULL,'N','N','N',NULL,1690,'Y','system'),
 ('RNL020','*','응급카트(키트) 의약품 관리대장(AKU)','DRUG','RENAL','ITEM_MONTH','Y','유효기간,용량,수량',NULL,
  NULL,'N','N','N','병동 월 1회 · 약제과 분기 1회 점검 / 사용 후 반드시 채워 넣을 것 / 유효기간·수량·봉인 상태를 확인할 것',1700,'Y','system'),
 ('RNL021','*','응급키트 물품 점검대장(인공신장)','DRUG','RENAL','ITEM_MONTH','Y','수량',NULL,
  NULL,'N','N','N',NULL,1710,'Y','system'),
 ('RNL022','*','인공신장실 투석액 수관 미생물 배양 검사','EQUIP','RENAL','ITEM_MONTH','Y',NULL,'검사 종류',
  'AAMI 허용기준 — 배양 <100CFU/ml · 내독소 <0.25EU/ml','N','N','N',
  '배양 월 1회 · 내독소 3개월 1회 · 미세물질 년 1회',1720,'Y','system');
INSERT INTO TBL_QPS_CHK_ITEM (FORM_ID,HOSP_CD,SORT,ITEM_NM,GRP_NM,DESC_TXT,INPUT_GB,CARRY_YN,USE_YN) VALUES
 -- RN03 낙상 시설·환경 관리일지 (15항목)
 ('RNL019','*', 1,'복도·계단 손잡이 상태'      ,NULL,NULL,'CHECK','N','Y'),
 ('RNL019','*', 2,'바닥 미끄럼 방지 상태'      ,NULL,NULL,'CHECK','N','Y'),
 ('RNL019','*', 3,'조명 밝기 확인'             ,NULL,NULL,'CHECK','N','Y'),
 ('RNL019','*', 4,'침대 바퀴 잠금장치'         ,NULL,NULL,'CHECK','N','Y'),
 ('RNL019','*', 5,'침대 SIDE RAIL 상태'        ,NULL,NULL,'CHECK','N','Y'),
 ('RNL019','*', 6,'화장실 손잡이·비상벨'       ,NULL,NULL,'CHECK','N','Y'),
 ('RNL019','*', 7,'샤워실 미끄럼 방지 매트'    ,NULL,NULL,'CHECK','N','Y'),
 ('RNL019','*', 8,'휠체어·이동기구 상태'       ,NULL,NULL,'CHECK','N','Y'),
 ('RNL019','*', 9,'문턱·단차 표시'             ,NULL,NULL,'CHECK','N','Y'),
 ('RNL019','*',10,'낙상주의 표시판 부착'       ,NULL,NULL,'CHECK','N','Y'),
 ('RNL019','*',11,'복도 장애물 정리'           ,NULL,NULL,'CHECK','N','Y'),
 ('RNL019','*',12,'환자 이동 통로 확보'        ,NULL,NULL,'CHECK','N','Y'),
 ('RNL019','*',13,'투석 의자·베드 고정 상태'   ,NULL,NULL,'CHECK','N','Y'),
 ('RNL019','*',14,'응급 호출벨 작동'           ,NULL,NULL,'CHECK','N','Y'),
 ('RNL019','*',15,'낙상 예방 게시물 비치'      ,NULL,NULL,'CHECK','N','Y'),
 -- RN06 응급카트 의약품 (프리셋 14 — 용량·수량은 문서 값)
 ('RNL020','*', 1,'Epinephrine'      ,'경구/주사',NULL,'CHECK','N','Y'),
 ('RNL020','*', 2,'Atrohine'         ,'경구/주사',NULL,'CHECK','N','Y'),
 ('RNL020','*', 3,'Dopamin'          ,'경구/주사',NULL,'CHECK','N','Y'),
 ('RNL020','*', 4,'코다론'           ,'경구/주사',NULL,'CHECK','N','Y'),
 ('RNL020','*', 5,'N/S'              ,'수액'    ,NULL,'CHECK','N','Y'),
 ('RNL020','*', 6,'5% D/W'           ,'수액'    ,NULL,'CHECK','N','Y'),
 ('RNL020','*', 7,'50% D/W'          ,'수액'    ,NULL,'CHECK','N','Y'),
 ('RNL020','*', 8,'N/S(관류용)'      ,'수액'    ,NULL,'CHECK','N','Y'),
 ('RNL020','*', 9,'증류수'           ,'수액'    ,NULL,'CHECK','N','Y'),
 -- RN07 응급키트 물품(빈 행 — 병원이 적는다)
 ('RNL021','*',1,'Emergency cart 물품','','','TEXT','N','Y'),
 -- RN11 투석액 수관 미생물 배양 (기기 15~28호기는 문서가 늘린다 · 행 = 검사 2종)
 ('RNL022','*',1,'내독소','','','TEXT','N','Y'),
 ('RNL022','*',2,'배양'  ,'','','TEXT','N','Y');

-- ═══ ⑥ 주기 복합 2종 (RN12 월1회 · RN13 격주) ═══════════════════════════════
INSERT INTO TBL_QPS_CHK_FORM
 (FORM_ID, HOSP_CD, FORM_NM, CATE_CD, DEPT_CD, AXIS_GB, PRD_GB, PRD_KIND,
  SIGNER_YN, NOTE_YN, FIX_YN, SORT_NO, USE_YN, REG_USER) VALUES
 ('RNL023','*','Monthly Check List(인공신장)'  ,'EQUIP','RENAL','ITEM_MONTH','Y',NULL ,'Y','N','N',1730,'Y','system'),
 ('RNL024','*','Two weeks Check List(인공신장)','EQUIP','RENAL','ITEM_DAY'  ,'M','N'   ,'Y','N','N',1740,'Y','system');
INSERT INTO TBL_QPS_CHK_ITEM (FORM_ID,HOSP_CD,SORT,ITEM_NM,INPUT_GB,CARRY_YN,USE_YN) VALUES
 ('RNL023','*',1,'Main Pump Pressure Check (정상 10-15Kgf/㎠)','CHECK','N','Y'),
 ('RNL023','*',2,'Conductivity(10μ) Pure Water 일정한지'      ,'CHECK','N','Y'),
 ('RNL023','*',3,'Membrane 생산량 확인'                        ,'CHECK','N','Y'),
 ('RNL024','*',1,'Filter(10μm)'                                ,'CHECK','N','Y'),
 ('RNL024','*',2,'Softner'                                     ,'CHECK','N','Y'),
 ('RNL024','*',3,'Carbon 압력게이지 (정상 2.0~5.0Kg/㎠)'       ,'CHECK','N','Y'),
 ('RNL024','*',4,'소금Tank 소금물유무'                          ,'CHECK','N','Y'),
 ('RNL024','*',5,'Pre-Filter(5μm) 상태'                        ,'CHECK','N','Y'),
 ('RNL024','*',6,'Water return loop (1.0~2.0Kg/㎠)'            ,'CHECK','N','Y');

-- ═══ ⑦ LIST 1종 (RN15 정수실 점검 List) ════════════════════════════════════
INSERT INTO TBL_QPS_CHK_FORM
 (FORM_ID, HOSP_CD, FORM_NM, CATE_CD, DEPT_CD, AXIS_GB, PRD_GB, EQUIP_CNT,
  SIGNER_YN, NOTE_YN, FIX_YN, SORT_NO, USE_YN, REG_USER) VALUES
 ('RNL025','*','정수실 점검 List','EQUIP','RENAL','LIST','M',25,'N','Y','N',1750,'Y','system');
INSERT INTO TBL_QPS_CHK_ITEM (FORM_ID,HOSP_CD,SORT,ITEM_NM,INPUT_GB,CARRY_YN,USE_YN) VALUES
 ('RNL025','*',1,'명목'  ,'TEXT','N','Y'),
 ('RNL025','*',2,'기준'  ,'TEXT','N','Y'),
 ('RNL025','*',3,'결과'  ,'TEXT','N','Y'),
 ('RNL025','*',4,'확인자','TEXT','N','Y');

-- ── 확인 ────────────────────────────────────────────────────────────────────
SELECT AXIS_GB, COUNT(*) n FROM TBL_QPS_CHK_FORM WHERE HOSP_CD='*' AND FORM_ID LIKE 'RNL%' GROUP BY AXIS_GB;
SELECT FORM_ID, FORM_NM, AXIS_GB, PRD_GB, IFNULL(PRD_KIND,'-') k, IFNULL(GRP_PRD,'-') grp,
       (SELECT COUNT(*) FROM TBL_QPS_CHK_ITEM i WHERE i.FORM_ID=f.FORM_ID AND i.HOSP_CD='*') items
  FROM TBL_QPS_CHK_FORM f WHERE f.HOSP_CD='*' AND FORM_ID LIKE 'RNL%' ORDER BY FORM_ID;
