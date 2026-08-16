-- ═══════════════════════════════════════════════════════════════════════════
-- 점검표 표준 서식 시드 — **간호/병동 3차** (2026-08-13) : NUR043~NUR066
--   판독 정본 : docs/proposals/QPS_서식판독_간호병동_2026-08-13.md · 공통 규칙은 1차 파일 머리말
--   ⛔NUR057(구급차 의료장비 및 응급약품 관리대장)은 **2·3쪽 재캡처 전엔 안 넣는다** — 반쪽 등록 금지.
-- ═══════════════════════════════════════════════════════════════════════════

DELETE FROM TBL_QPS_CHK_ITEM WHERE HOSP_CD='*' AND FORM_ID IN
 ('NUR043','NUR044','NUR045','NUR046','NUR047','NUR048','NUR049','NUR050','NUR051','NUR052',
  'NUR053','NUR054','NUR055','NUR056','NUR058','NUR059','NUR060','NUR061','NUR062','NUR063',
  'NUR064','NUR065','NUR066');
DELETE FROM TBL_QPS_CHK_FORM WHERE HOSP_CD='*' AND FORM_ID IN
 ('NUR043','NUR044','NUR045','NUR046','NUR047','NUR048','NUR049','NUR050','NUR051','NUR052',
  'NUR053','NUR054','NUR055','NUR056','NUR058','NUR059','NUR060','NUR061','NUR062','NUR063',
  'NUR064','NUR065','NUR066');

-- ═══════════════════════════════════════════════════════════════════════════
-- NUR043 · 병동 안전사고 예방점검일지(시설물, 환경) [cap269]  [ITEM_DAY · NOTE_NM]
-- ═══════════════════════════════════════════════════════════════════════════
INSERT INTO TBL_QPS_CHK_FORM
 (FORM_ID, HOSP_CD, FORM_NM, CATE_CD, DEPT_CD, AXIS_GB, PRD_GB, PRD_KIND,
  SIGNER_YN, NOTE_YN, NOTE_NM, FIX_YN, SORT_NO, USE_YN, REG_USER)
VALUES
 ('NUR043','*','병동 안전사고 예방점검일지(시설물, 환경)','SAFE','NURSE','ITEM_DAY','M','D',
  'Y','Y','비고 (매일10AM 확인)','N',930,'Y','system');
INSERT INTO TBL_QPS_CHK_ITEM (FORM_ID,HOSP_CD,SORT,ITEM_NM,INPUT_GB,CARRY_YN,USE_YN) VALUES
 ('NUR043','*', 1,'문잠금장치','CHECK','N','Y'),
 ('NUR043','*', 2,'비상벨','CHECK','N','Y'),
 ('NUR043','*', 3,'방범창','CHECK','N','Y'),
 ('NUR043','*', 4,'쇼파','CHECK','N','Y'),
 ('NUR043','*', 5,'마스터키','CHECK','N','Y'),
 ('NUR043','*', 6,'샤워실','CHECK','N','Y'),
 ('NUR043','*', 7,'사물함','CHECK','N','Y'),
 ('NUR043','*', 8,'전선노출','CHECK','N','Y'),
 ('NUR043','*', 9,'전화기','CHECK','N','Y'),
 ('NUR043','*',10,'TV','CHECK','N','Y'),
 ('NUR043','*',11,'간호사실','CHECK','N','Y'),
 ('NUR043','*',12,'병실','CHECK','N','Y'),
 ('NUR043','*',13,'소화기','CHECK','N','Y'),
 ('NUR043','*',14,'CCTV모니터','CHECK','N','Y'),
 ('NUR043','*',15,'복도/계단','CHECK','N','Y'),
 ('NUR043','*',16,'화장실','CHECK','N','Y'),
 ('NUR043','*',17,'위해물품 수거','CHECK','N','Y');

-- ═══════════════════════════════════════════════════════════════════════════
-- NUR044 · 반입제한 물품관리대장 [cap271]   [LIST · 연 단위 · 위해도구 형제 3]
-- NUR045 · 식품 Allergy 환자 리스트(간호) [cap272]   [LIST]
-- ═══════════════════════════════════════════════════════════════════════════
--   ★NUR044 는 NUR033·034 와 안내문이 같고 `환자 서명` 열이 하나 더 있다.
--   ★NUR045 는 약국판과 마지막 열이 다르다(판정 확인) — 별개 서식.
INSERT INTO TBL_QPS_CHK_FORM
 (FORM_ID, HOSP_CD, FORM_NM, CATE_CD, DEPT_CD, AXIS_GB, PRD_GB, EQUIP_CNT,
  SIGNER_YN, NOTE_YN, FIX_YN, FOOT_TXT, SORT_NO, USE_YN, REG_USER)
VALUES
 ('NUR044','*','반입제한 물품관리대장','SAFE','NURSE','LIST','Y',15,'N','N','N',
  '<반입금지 물품> 1) 긴 끈 종류(긴 수건, 목도리, 보자기, 스타킹 등) 2) 유리로 된 물건(반찬 그릇, 거울, 화장품, 음료 등) 3) 화재 위험성이 있는 물건(라이터, 성냥 등) 4) 면도기, 칼, 가위 등 날카로운 물건 5) 끈이 달려있는 운동화와 구두, 하의 중 허리끈이 있는 것 6) 개인 온열 기구 7) 화학 물질 8) 이외, 치료팀에서 위해물건으로 판단되는 물품은 소지 할 수 없음.',
  940,'Y','system'),
 ('NUR045','*','식품 Allergy 환자 리스트(간호)','SAFE','NURSE','LIST','M',20,'N','N','N',NULL,950,'Y','system');
INSERT INTO TBL_QPS_CHK_ITEM (FORM_ID,HOSP_CD,SORT,ITEM_NM,INPUT_GB,CARRY_YN,USE_YN) VALUES
 ('NUR044','*',1,'검사일자'  ,'TEXT','N','Y'),
 ('NUR044','*',2,'환자명'    ,'TEXT','N','Y'),
 ('NUR044','*',3,'수거물품'  ,'TEXT','N','Y'),
 ('NUR044','*',4,'처리방법'  ,'TEXT','N','Y'),
 ('NUR044','*',5,'환자 서명' ,'TEXT','N','Y'),
 ('NUR044','*',6,'치료진 서명','TEXT','N','Y'),
 ('NUR044','*',7,'비고'      ,'TEXT','N','Y'),
 ('NUR045','*',1,'작성일자'  ,'TEXT','N','Y'),
 ('NUR045','*',2,'환자성명'  ,'TEXT','N','Y'),
 ('NUR045','*',3,'등록번호'  ,'TEXT','N','Y'),
 ('NUR045','*',4,'성별/나이' ,'TEXT','N','Y'),
 ('NUR045','*',5,'진료과/병동','TEXT','N','Y'),
 ('NUR045','*',6,'알러지 및 과민반응 식품','TEXT','N','Y');

-- ═══════════════════════════════════════════════════════════════════════════
-- NUR046 · 냉장고 온도관리 기록지 [cap275]  [DAY_ITEM · 냉장고 2대 × 시각 3]
-- ═══════════════════════════════════════════════════════════════════════════
--   ★NUR010·013 냉장고 계열의 확장판 — 묶음 이름에 냉장고+시각을 합쳐 편다(묶음 1단 한계).
--   ⚠머리의 냉장약품목록(란투스·아티반 등)은 병원 자료 — 상단 자유칸 하나로 받아 둔다.
INSERT INTO TBL_QPS_CHK_FORM
 (FORM_ID, HOSP_CD, FORM_NM, CATE_CD, DEPT_CD, AXIS_GB, PRD_GB, PRD_KIND,
  GUIDE_TXT, HEAD_NMS, SIGNER_YN, NOTE_YN, FIX_YN, SORT_NO, USE_YN, REG_USER)
VALUES
 ('NUR046','*','냉장고 온도관리 기록지','EQUIP','NURSE','DAY_ITEM','M','D',
  '*온도허용범위 : 2~8℃','냉장약품목록','N','N','N',960,'Y','system');
INSERT INTO TBL_QPS_CHK_ITEM (FORM_ID,HOSP_CD,SORT,ITEM_NM,GRP_NM,INPUT_GB,UNIT_NM,USE_YN) VALUES
 ('NUR046','*', 1,'냉장고 온도','고위험 주사제 2PM','NUM','℃','Y'),
 ('NUR046','*', 2,'점검자'    ,'고위험 주사제 2PM','TEXT',NULL,'Y'),
 ('NUR046','*', 3,'냉장고 온도','고위험 주사제 9PM','NUM','℃','Y'),
 ('NUR046','*', 4,'점검자'    ,'고위험 주사제 9PM','TEXT',NULL,'Y'),
 ('NUR046','*', 5,'냉장고 온도','고위험 주사제 5AM','NUM','℃','Y'),
 ('NUR046','*', 6,'점검자'    ,'고위험 주사제 5AM','TEXT',NULL,'Y'),
 ('NUR046','*', 7,'냉장고 온도','향정신성의약품 2PM','NUM','℃','Y'),
 ('NUR046','*', 8,'점검자'    ,'향정신성의약품 2PM','TEXT',NULL,'Y'),
 ('NUR046','*', 9,'냉장고 온도','향정신성의약품 9PM','NUM','℃','Y'),
 ('NUR046','*',10,'점검자'    ,'향정신성의약품 9PM','TEXT',NULL,'Y'),
 ('NUR046','*',11,'냉장고 온도','향정신성의약품 5AM','NUM','℃','Y'),
 ('NUR046','*',12,'점검자'    ,'향정신성의약품 5AM','TEXT',NULL,'Y');

-- ═══════════════════════════════════════════════════════════════════════════
-- NUR047 · 병동 위해도구 관리 대장 [cap276]   [ITEM_COL · 일 · 묶음>열]
-- ═══════════════════════════════════════════════════════════════════════════
--   ⚠하단 「점 검 일」 날짜는 문서 단위(일)가 그것이다 — 따로 안 받는다. 예비 빈 행 4는 안 넣는다.
INSERT INTO TBL_QPS_CHK_FORM
 (FORM_ID, HOSP_CD, FORM_NM, CATE_CD, DEPT_CD, AXIS_GB, PRD_GB,
  COL_NMS, SIGN_LINE, SIGNER_YN, NOTE_YN, FIX_YN, SORT_NO, USE_YN, REG_USER)
VALUES
 ('NUR047','*','병동 위해도구 관리 대장','SAFE','NURSE','ITEM_COL','D',
  '보관수>병동,보관수>개인,추가수>병동,추가수>개인,총 수>병동,총 수>개인,비고',
  '점검자,병동책임자 확인','N','N','N',970,'Y','system');
INSERT INTO TBL_QPS_CHK_ITEM (FORM_ID,HOSP_CD,SORT,ITEM_NM,INPUT_GB,CARRY_YN,USE_YN) VALUES
 ('NUR047','*', 1,'MP3(라디오) 충전줄','TEXT','N','Y'),
 ('NUR047','*', 2,'휴대폰 충전줄 (병동·충전기/선)','TEXT','N','Y'),
 ('NUR047','*', 3,'면도기 충전줄','TEXT','N','Y'),
 ('NUR047','*', 4,'노트북(패드) 충전줄','TEXT','N','Y'),
 ('NUR047','*', 5,'손톱깎이','TEXT','N','Y'),
 ('NUR047','*', 6,'면도기','TEXT','N','Y'),
 ('NUR047','*', 7,'족집게','TEXT','N','Y'),
 ('NUR047','*', 8,'눈썹칼','TEXT','N','Y'),
 ('NUR047','*', 9,'코털가위','TEXT','N','Y'),
 ('NUR047','*',10,'유리화장품','TEXT','N','Y'),
 ('NUR047','*',11,'라이타(옥상)','TEXT','N','Y');

-- ═══════════════════════════════════════════════════════════════════════════
-- NUR048 · 응급약품 및 기구관리 대장 [cap277]
--                    [EQUIP_DAY · 주차 5 · ─머리글 · 앞뒤 열 · 서명란 3]
-- ═══════════════════════════════════════════════════════════════════════════
--   ⚠원본 사인 행 3(확인간호사·병동책임자·약사)은 주차별인데 우리 서명란은 문서별 — 병원 확인 항목.
--   ⚠전월복사(행 이름 35줄)는 EQUIP_DAY 라 못 켠다 — 엔진 확장 후보(근거 4종, 판독 §NUR048).
INSERT INTO TBL_QPS_CHK_FORM
 (FORM_ID, HOSP_CD, FORM_NM, CATE_CD, DEPT_CD, AXIS_GB, PRD_GB, PRD_KIND, EQUIP_CNT,
  PRD_HEAD_YN, PRE_COLS, POST_COLS, SIGN_LINE, SIGNER_YN, NOTE_YN, FIX_YN, SORT_NO, USE_YN, REG_USER)
VALUES
 ('NUR048','*','응급약품 및 기구관리 대장','DRUG','NURSE','EQUIP_DAY','M','N',35,
  'Y','수량','유통기한,유통기한 변경','확인간호사 서명,병동책임자 서명,약사 서명','N','Y','N',980,'Y','system');

-- ═══════════════════════════════════════════════════════════════════════════
-- NUR049 · 세탁물 보관장소, 세탁물 운반차 소독대장 [cap278]   [DAY_ITEM]
-- ═══════════════════════════════════════════════════════════════════════════
--   ⚠원본 머리글 2단(장소/서명)을 한 줄로 합쳤다(글자 보존). 서식명의 쉼표는 FORM_NM 이라 안전.
INSERT INTO TBL_QPS_CHK_FORM
 (FORM_ID, HOSP_CD, FORM_NM, CATE_CD, DEPT_CD, AXIS_GB, PRD_GB, PRD_KIND,
  SIGNER_YN, NOTE_YN, FIX_YN, FOOT_TXT, SORT_NO, USE_YN, REG_USER)
VALUES
 ('NUR049','*','세탁물 보관장소, 세탁물 운반차 소독대장','ENV','NURSE','DAY_ITEM','M','D',
  'N','N','N',
  '▶ 세탁물보관장소,세탁물반출운반차-주2회 (화요일-3병동/목요일-5병동) ▶ 세탁물반입운반차-주2회 (월요일-3병동/금요일-5병동) ▶ 살균소독제 이용',
  990,'Y','system');
INSERT INTO TBL_QPS_CHK_ITEM (FORM_ID,HOSP_CD,SORT,ITEM_NM,INPUT_GB,CARRY_YN,USE_YN) VALUES
 ('NUR049','*',1,'세탁물 보관장소 서명','TEXT','N','Y'),
 ('NUR049','*',2,'세탁물 반출 운반차 서명','TEXT','N','Y'),
 ('NUR049','*',3,'세탁물 반입 운반차 서명','TEXT','N','Y'),
 ('NUR049','*',4,'비고','TEXT','N','Y');

-- ═══════════════════════════════════════════════════════════════════════════
-- NUR050 · 신체보호대 사용 환자 간호활동(모니터링) 기록지 [cap279]
--                                [ITEM_DAY · 환자 단위 · 시간 행 12 · D,E,N 사인]
-- ═══════════════════════════════════════════════════════════════════════════
--   ★상단 칸 9개를 8칸에 접었다(성별/나이·병실 한 칸) — HEAD 는 8칸까지.
--     체크들(목적·부위·해지사유)은 칸 이름에 원본 문구를 담고 글로 받는다.
--   ★신체보호대 지표(MONITOR) 대기 중 — 지표 개방 때 이 서식을 다시 본다.
INSERT INTO TBL_QPS_CHK_FORM
 (FORM_ID, HOSP_CD, FORM_NM, CATE_CD, DEPT_CD, AXIS_GB, PRD_GB, PRD_KIND,
  GUIDE_TXT, HEAD_NMS, SIGNER_YN, NOTE_YN, FIX_YN, FOOT_TXT, SORT_NO, USE_YN, REG_USER)
VALUES
 ('NUR050','*','신체보호대 사용 환자 간호활동(모니터링) 기록지','SAFE','NURSE','ITEM_DAY','M','D',
  '간호활동 시행후 작성 [ 시행: V표시 / 미시행: 공란 ]',
  '등록번호,성명,성별/나이·병실,시작일시,설명 및 동의서(확인/미확인),목적(낙상예방/발관위험/불안정상태/자해 및 타해위험),부위(상지 좌·우·양쪽 / 하지 좌·우·양쪽 / 흉부억제),해지사유(낙상위험요인 없음/발관위험 없음/환자안정 상태/자해 및 타해위험 없음/사망 또는 퇴원)',
  'Y','N','N',
  '사지 말단부위 맥박, 체온, 피부색 및 감각 등 혈액 순환 상태, 피부손상, 통증, 운동 범위 확인한다 / 2시간마다 15분동안 제거 및 재적용 실시한다 ( 부작용 발생 위험성이 크다고 판단되는 경우 수시 관찰 필요) / 영양 제공 및 배설 및 수분 섭취 요구 확인한다 / 흉부 억제의 경우는 호흡에 지장이 없는지 확인한다 / 보호대 제거 또는 감소에 대한 평가한다',
  1000,'Y','system');
INSERT INTO TBL_QPS_CHK_ITEM (FORM_ID,HOSP_CD,SORT,ITEM_NM,INPUT_GB,CARRY_YN,USE_YN) VALUES
 ('NUR050','*', 1,'08:00','CHECK','N','Y'),
 ('NUR050','*', 2,'10:00','CHECK','N','Y'),
 ('NUR050','*', 3,'12:00','CHECK','N','Y'),
 ('NUR050','*', 4,'14:00','CHECK','N','Y'),
 ('NUR050','*', 5,'16:00','CHECK','N','Y'),
 ('NUR050','*', 6,'18:00','CHECK','N','Y'),
 ('NUR050','*', 7,'20:00','CHECK','N','Y'),
 ('NUR050','*', 8,'22:00','CHECK','N','Y'),
 ('NUR050','*', 9,'00:00','CHECK','N','Y'),
 ('NUR050','*',10,'02:00','CHECK','N','Y'),
 ('NUR050','*',11,'04:00','CHECK','N','Y'),
 ('NUR050','*',12,'06:00','CHECK','N','Y');

-- ═══════════════════════════════════════════════════════════════════════════
-- NUR051 · 병동 환경 위생 관리 점검표 [cap280]
--                       [ITEM_DAY · 주차 5 · 점검날짜 머리글 · ★상/중/하 쪼개기]
-- ═══════════════════════════════════════════════════════════════════════════
--   ★PRD_SUB='상,중,하' — 주차 칸이 점검결과 3칸으로 갈린다. 화면 검증 대상.
--   ⚠연도가 2022 로 굳은 서식 — 아직 쓰는지 병원 확인 항목. 빈 행 4는 안 넣는다.
INSERT INTO TBL_QPS_CHK_FORM
 (FORM_ID, HOSP_CD, FORM_NM, CATE_CD, DEPT_CD, AXIS_GB, PRD_GB, PRD_KIND, PRD_SUB,
  PRD_HEAD_YN, PRD_HEAD_NM, SIGNER_YN, NOTE_YN, FIX_YN, SORT_NO, USE_YN, REG_USER)
VALUES
 ('NUR051','*','병동 환경 위생 관리 점검표','ENV','NURSE','ITEM_DAY','M','N','상,중,하',
  'Y','점검날짜','Y','Y','N',1010,'Y','system');
INSERT INTO TBL_QPS_CHK_ITEM (FORM_ID,HOSP_CD,SORT,ITEM_NM,INPUT_GB,CARRY_YN,USE_YN) VALUES
 ('NUR051','*', 1,'침대 및 침구류','CHECK','N','Y'),
 ('NUR051','*', 2,'환자 사물함','CHECK','N','Y'),
 ('NUR051','*', 3,'병실바닥 및 복도','CHECK','N','Y'),
 ('NUR051','*', 4,'창문','CHECK','N','Y'),
 ('NUR051','*', 5,'병실 냉장고','CHECK','N','Y'),
 ('NUR051','*', 6,'공중전화/환자수신기','CHECK','N','Y'),
 ('NUR051','*', 7,'식판 보관함','CHECK','N','Y'),
 ('NUR051','*', 8,'분리 수거함','CHECK','N','Y'),
 ('NUR051','*', 9,'청소 용구함','CHECK','N','Y'),
 ('NUR051','*',10,'전자레인지','CHECK','N','Y'),
 ('NUR051','*',11,'환자 사복 보관장','CHECK','N','Y'),
 ('NUR051','*',12,'냉,난방기','CHECK','N','Y'),
 ('NUR051','*',13,'정수기','CHECK','N','Y'),
 ('NUR051','*',14,'세탁물 수거함','CHECK','N','Y'),
 ('NUR051','*',15,'프로그램실 및 휴게실','CHECK','N','Y'),
 ('NUR051','*',16,'보호실 1,2','CHECK','N','Y'),
 ('NUR051','*',17,'계단','CHECK','N','Y'),
 ('NUR051','*',18,'화장실','CHECK','N','Y'),
 ('NUR051','*',19,'샤워실','CHECK','N','Y'),
 ('NUR051','*',20,'세면대','CHECK','N','Y'),
 ('NUR051','*',21,'면담실','CHECK','N','Y'),
 ('NUR051','*',22,'구조대','CHECK','N','Y');

-- ═══════════════════════════════════════════════════════════════════════════
-- NUR052 · 일회용 소독 물품 점검대장 [cap282]
--                       [EQUIP_DAY · 연·월 열 · 앞 열 2 · ★사인 행 둘 → 890 우회]
-- ═══════════════════════════════════════════════════════════════════════════
--   ★사인 행이 둘(점검자·병동책임자) — 점검자는 900, 병동책임자는 PRD_HEAD(890)로 받는다.
--     자리가 위/아래만 다르고 글자·칸 수는 같다. 화면 검증 + 병원 확인 항목.
--   ⚠미리 찍힌 물품 6종은 병원 자료. 전월복사는 EQUIP_DAY 라 못 켠다(엔진 확장 후보).
INSERT INTO TBL_QPS_CHK_FORM
 (FORM_ID, HOSP_CD, FORM_NM, CATE_CD, DEPT_CD, AXIS_GB, PRD_GB, PRD_KIND, EQUIP_CNT,
  PRD_HEAD_YN, PRD_HEAD_NM, PRE_COLS, GUIDE_TXT, SIGNER_YN, NOTE_YN, FIX_YN, SORT_NO, USE_YN, REG_USER)
VALUES
 ('NUR052','*','일회용 소독 물품 점검대장','STERIL','NURSE','EQUIP_DAY','Y','M',12,
  'Y','병동책임자 확인','유효기간,수량','*매월 4일 야간에 점검','Y','Y','N',1020,'Y','system');

-- ═══════════════════════════════════════════════════════════════════════════
-- NUR053 · 혈당측정기 점검대장 [cap283]   [ITEM_DAY · 기기 점검대장 계열]
-- NUR054 · O2탱크 점검대장 [cap284]       [ITEM_DAY · 같은 틀]
-- NUR055 · iSyncWave 점검대장 [cap285]    [ITEM_DAY · 같은 틀 + 부속물 안내]
-- ═══════════════════════════════════════════════════════════════════════════
--   ★사인 행 둘(점검자 900 · 병동책임자 890) — NUR052 와 같은 우회. 3종째라 「둘째 사인 행」
--     엔진 칸은 v3 조합 목록에 올렸다(판독 §NUR053).
--   ⚠NUR055 의 비고 미리 찍힌 부속물 목록은 서식에 못 박아 FOOT 으로 옮겼다(글자 보존).
INSERT INTO TBL_QPS_CHK_FORM
 (FORM_ID, HOSP_CD, FORM_NM, CATE_CD, DEPT_CD, AXIS_GB, PRD_GB, PRD_KIND,
  PRD_HEAD_YN, PRD_HEAD_NM, SIGNER_YN, NOTE_YN, FIX_YN, FOOT_TXT, SORT_NO, USE_YN, REG_USER)
VALUES
 ('NUR053','*','혈당측정기 점검대장','EQUIP','NURSE','ITEM_DAY','M','D',
  'Y','병동책임자','Y','Y','N',NULL,1030,'Y','system'),
 ('NUR054','*','O2탱크 점검대장','EQUIP','NURSE','ITEM_DAY','M','D',
  'Y','병동책임자','Y','Y','N',NULL,1040,'Y','system'),
 ('NUR055','*','iSyncWave 점검대장','EQUIP','NURSE','ITEM_DAY','M','D',
  'Y','병동책임자','Y','Y','N',
  '▶ 부속물 : iSW, 갤럭시S6 Table, Nuprep gel or 물티슈, 전극세척솔, 전극 높이 조정도구, C-type 충전기(2개), 의자세트, 목베게',
  1050,'Y','system');
INSERT INTO TBL_QPS_CHK_ITEM (FORM_ID,HOSP_CD,SORT,ITEM_NM,INPUT_GB,CARRY_YN,USE_YN) VALUES
 ('NUR053','*',1,'건전지','CHECK','N','Y'),
 ('NUR053','*',2,'작동','CHECK','N','Y'),
 ('NUR053','*',3,'청소','CHECK','N','Y'),
 ('NUR054','*',1,'부속물','CHECK','N','Y'),
 ('NUR054','*',2,'충전','CHECK','N','Y'),
 ('NUR054','*',3,'작동','CHECK','N','Y'),
 ('NUR054','*',4,'청소','CHECK','N','Y'),
 ('NUR055','*',1,'부속물','CHECK','N','Y'),
 ('NUR055','*',2,'충전','CHECK','N','Y'),
 ('NUR055','*',3,'작동','CHECK','N','Y'),
 ('NUR055','*',4,'청소','CHECK','N','Y'),
 ('NUR055','*',5,'검사실 환경','CHECK','N','Y');

-- ═══════════════════════════════════════════════════════════════════════════
-- NUR056 · 고위험군 체위 변경표 [cap288]   [ITEM_DAY · 환자 단위 · ★체위 설명 열]
-- ═══════════════════════════════════════════════════════════════════════════
--   ★DESC 열 이름 `체위` 는 우리가 붙였다(원본 머리글 없음) — 병원 확인 항목.
--   ⚠오른쪽 위 체위변경 그림(시계 도식)·행 색(근무조)은 못 담는다. 글자는 다 산다.
INSERT INTO TBL_QPS_CHK_FORM
 (FORM_ID, HOSP_CD, FORM_NM, CATE_CD, DEPT_CD, AXIS_GB, PRD_GB, PRD_KIND,
  GUIDE_TXT, HEAD_NMS, DESC_NM, SIGNER_YN, NOTE_YN, FIX_YN, SORT_NO, USE_YN, REG_USER)
VALUES
 ('NUR056','*','고위험군 체위 변경표','SAFE','NURSE','ITEM_DAY','M','D',
  '반듯하게 : Su / 오른쪽 : Rt / 왼쪽 : Lt','등록번호,성 명,성별 / 나이,병실','체위',
  'N','N','N',1060,'Y','system');
INSERT INTO TBL_QPS_CHK_ITEM (FORM_ID,HOSP_CD,SORT,ITEM_NM,DESC_TXT,INPUT_GB,CARRY_YN,USE_YN) VALUES
 ('NUR056','*', 1,'00:00~02:00','Su.','CHECK','N','Y'),
 ('NUR056','*', 2,'02:00~04:00','Rt.','CHECK','N','Y'),
 ('NUR056','*', 3,'04:00~06:00','Lt.','CHECK','N','Y'),
 ('NUR056','*', 4,'06:00~08:00','Su.','CHECK','N','Y'),
 ('NUR056','*', 5,'08:00~10:00','Rt.','CHECK','N','Y'),
 ('NUR056','*', 6,'10:00~12:00','Lt.','CHECK','N','Y'),
 ('NUR056','*', 7,'12:00~14:00','Su.','CHECK','N','Y'),
 ('NUR056','*', 8,'14:00~16:00','Rt.','CHECK','N','Y'),
 ('NUR056','*', 9,'16:00~18:00','Lt.','CHECK','N','Y'),
 ('NUR056','*',10,'18:00~20:00','Su.','CHECK','N','Y'),
 ('NUR056','*',11,'20:00~22:00','Rt.','CHECK','N','Y'),
 ('NUR056','*',12,'22:00~24:00','Lt.','CHECK','N','Y');

-- ═══════════════════════════════════════════════════════════════════════════
-- NUR058 · PRN 처방 목록 [cap291]   [LIST · 용법 묶음 · ★전월복사]
-- ═══════════════════════════════════════════════════════════════════════════
--   ⚠상단에 년월 표시가 안 보인다 — 문서 단위 M 로 두고 병원 확인 항목.
INSERT INTO TBL_QPS_CHK_FORM
 (FORM_ID, HOSP_CD, FORM_NM, CATE_CD, DEPT_CD, AXIS_GB, PRD_GB, EQUIP_CNT,
  SIGNER_YN, NOTE_YN, FIX_YN, SORT_NO, USE_YN, REG_USER)
VALUES
 ('NUR058','*','PRN 처방 목록','DRUG','NURSE','LIST','M',10,'N','N','N',1080,'Y','system');
INSERT INTO TBL_QPS_CHK_ITEM (FORM_ID,HOSP_CD,SORT,ITEM_NM,GRP_NM,INPUT_GB,CARRY_YN,USE_YN) VALUES
 ('NUR058','*',1,'약품명'      ,NULL  ,'TEXT','Y','Y'),
 ('NUR058','*',2,'성분'        ,NULL  ,'TEXT','Y','Y'),
 ('NUR058','*',3,'실시기준'    ,NULL  ,'TEXT','Y','Y'),
 ('NUR058','*',4,'1회 용량'    ,'용법','TEXT','Y','Y'),
 ('NUR058','*',5,'1일 최대용량','용법','TEXT','Y','Y'),
 ('NUR058','*',6,'투여간격'    ,'용법','TEXT','Y','Y'),
 ('NUR058','*',7,'투여 경로'   ,'용법','TEXT','Y','Y'),
 ('NUR058','*',8,'적용중'      ,NULL  ,'TEXT','N','Y');

-- ═══════════════════════════════════════════════════════════════════════════
-- NUR059 · 비치의약품 관리 점검부 [cap294]   [ITEM_DAY]
-- ═══════════════════════════════════════════════════════════════════════════
INSERT INTO TBL_QPS_CHK_FORM
 (FORM_ID, HOSP_CD, FORM_NM, CATE_CD, DEPT_CD, AXIS_GB, PRD_GB, PRD_KIND,
  SIGNER_YN, NOTE_YN, FIX_YN, SORT_NO, USE_YN, REG_USER)
VALUES
 ('NUR059','*','비치의약품 관리 점검부','DRUG','NURSE','ITEM_DAY','M','D',
  'Y','Y','N',1090,'Y','system');
INSERT INTO TBL_QPS_CHK_ITEM (FORM_ID,HOSP_CD,SORT,ITEM_NM,INPUT_GB,CARRY_YN,USE_YN) VALUES
 ('NUR059','*',1,'약품을 적절한 온도, 습도로 유지 보관하고 있는지?','CHECK','N','Y'),
 ('NUR059','*',2,'냉장 보관해야 하는 약품을 냉장 보관하고 있는지?','CHECK','N','Y'),
 ('NUR059','*',3,'위생상 유해가 없고 의약품의 효능이 떨어지지 않도록 보관하고 있는가?','CHECK','N','Y'),
 ('NUR059','*',4,'의약품 냉장고에 의약품의 다른 물품이 보관 되지 않는가?','CHECK','N','Y'),
 ('NUR059','*',5,'덕용약품의 소분 사용 시 조제일자, 폐기일자 표기하고 있는가?','CHECK','N','Y'),
 ('NUR059','*',6,'고위험 약품을 분리 보관하고 있는가?','CHECK','N','Y'),
 ('NUR059','*',7,'응급 약품을 봉인하여 보관하고 있는가?','CHECK','N','Y'),
 ('NUR059','*',8,'유효기간을 점검하여 약품의 유효성을 확립하고 있는가?','CHECK','N','Y');

-- ═══════════════════════════════════════════════════════════════════════════
-- NUR060 · 유효기간 임박 약물목록 [cap297]   [LIST · ★전월복사]
-- ═══════════════════════════════════════════════════════════════════════════
--   ⚠트리에 같은 이름이 두 번 — 껍데기(cap200 전례)일 수 있다. 재캡처 목록에서 대조.
INSERT INTO TBL_QPS_CHK_FORM
 (FORM_ID, HOSP_CD, FORM_NM, CATE_CD, DEPT_CD, AXIS_GB, PRD_GB, EQUIP_CNT,
  SIGNER_YN, NOTE_YN, FIX_YN, SORT_NO, USE_YN, REG_USER)
VALUES
 ('NUR060','*','유효기간 임박 약물목록','DRUG','NURSE','LIST','M',31,'N','N','N',1100,'Y','system');
INSERT INTO TBL_QPS_CHK_ITEM (FORM_ID,HOSP_CD,SORT,ITEM_NM,INPUT_GB,CARRY_YN,USE_YN) VALUES
 ('NUR060','*',1,'약품명'      ,'TEXT','Y','Y'),
 ('NUR060','*',2,'수량'        ,'TEXT','Y','Y'),
 ('NUR060','*',3,'유효기간일자','TEXT','Y','Y'),
 ('NUR060','*',4,'비고'        ,'TEXT','N','Y'),
 ('NUR060','*',5,'점검자'      ,'TEXT','N','Y'),
 ('NUR060','*',6,'관리자'      ,'TEXT','N','Y');

-- ═══════════════════════════════════════════════════════════════════════════
-- NUR061 · 외래, 주사실 낙상예방시설 점검부 [cap299]   [ITEM_DAY · 부서 셀렉트]
-- ═══════════════════════════════════════════════════════════════════════════
--   ⚠2번 겹닫는괄호 · 4번 `파송`·`호함` — 원본 오타 그대로. 빈 행 1은 안 넣는다.
INSERT INTO TBL_QPS_CHK_FORM
 (FORM_ID, HOSP_CD, FORM_NM, CATE_CD, DEPT_CD, AXIS_GB, PRD_GB, PRD_KIND,
  GUIDE_TXT, HEAD_NMS, SIGNER_YN, NOTE_YN, FIX_YN, FOOT_TXT, SORT_NO, USE_YN, REG_USER)
VALUES
 ('NUR061','*','외래, 주사실 낙상예방시설 점검부','SAFE','NURSE','ITEM_DAY','M','D',
  '(매일시행)','부서','Y','N','N',
  '* 점검결과 (O:양호, X:미비)   * 점검시기: 매일시행   * 점검양식에따라 미비사항은 즉시 보완 시정함.',
  1110,'Y','system');
INSERT INTO TBL_QPS_CHK_ITEM (FORM_ID,HOSP_CD,SORT,ITEM_NM,INPUT_GB,CARRY_YN,USE_YN) VALUES
 ('NUR061','*',1,'대기 의자는 바닥에 잘 고정되어 있는가 ?','CHECK','N','Y'),
 ('NUR061','*',2,'안전바(복도, 화장실 등)은 고정되어 있는가?(파손 여부 포함))','CHECK','N','Y'),
 ('NUR061','*',3,'낙상 주의 문구는 잘 부착되어 있는가? (휠체어, 복도벽면, 화장실, 체중계)','CHECK','N','Y'),
 ('NUR061','*',4,'주사실 침상 바퀴는 잘 고정 되어 있는가 ? (난간 파송 여부 호함)','CHECK','N','Y'),
 ('NUR061','*',5,'외래 휠체어 바퀴는 고장이 없는가?','CHECK','N','Y'),
 ('NUR061','*',6,'환자 이동 통로에 물기나 턱, 홈 파인곳 등은 없는가?','CHECK','N','Y');

-- ═══════════════════════════════════════════════════════════════════════════
-- NUR062 · 외래 비치약품 점검 기록부 [cap300]
--                    [EQUIP_DAY · 앞 열 3 · ★간호사(매일)/약사(반기) 서명 2주기]
-- ═══════════════════════════════════════════════════════════════════════════
--   ★간호사 서명(매일)=900 · 약사(반기)=890 우회(NUR052 와 같다). 병원 확인 항목.
--   ⚠미리 찍힌 약품 12종은 병원 자료. 라벨링(유/무)·타 의약품 혼재(유/무) 두 줄도 문서 행으로 적는다.
INSERT INTO TBL_QPS_CHK_FORM
 (FORM_ID, HOSP_CD, FORM_NM, CATE_CD, DEPT_CD, AXIS_GB, PRD_GB, PRD_KIND, EQUIP_CNT,
  PRD_HEAD_YN, PRD_HEAD_NM, PRE_COLS, SIGNER_YN, NOTE_YN, FIX_YN, SORT_NO, USE_YN, REG_USER)
VALUES
 ('NUR062','*','외래 비치약품 점검 기록부','DRUG','NURSE','EQUIP_DAY','M','D',15,
  'Y','약사 (반기 점검)','유효기간,보관상태 (실온),수량','Y','N','N',1120,'Y','system');

-- ═══════════════════════════════════════════════════════════════════════════
-- NUR063 · 오물처리실 청소 점검표 [cap304]   [ITEM_DAY · 부서 셀렉트]
-- NUR064 · 세탁물보관실점검표 [cap305]       [ITEM_DAY · 반달 접기]
-- ═══════════════════════════════════════════════════════════════════════════
--   ★NUR064 좌측에 「주말서명 삭제」 버튼 — 주말 자동서명 질문 4종째(병원 확인 목록 합산).
INSERT INTO TBL_QPS_CHK_FORM
 (FORM_ID, HOSP_CD, FORM_NM, CATE_CD, DEPT_CD, AXIS_GB, PRD_GB, PRD_KIND,
  SPLIT_N, SPLIT_DIR, GUIDE_TXT, HEAD_NMS, SIGNER_YN, NOTE_YN, FIX_YN, SORT_NO, USE_YN, REG_USER)
VALUES
 ('NUR063','*','오물처리실 청소 점검표','ENV','NURSE','ITEM_DAY','M','D',
  NULL,NULL,NULL,'부서','Y','N','N',1130,'Y','system'),
 ('NUR064','*','세탁물보관실점검표','ENV','NURSE','ITEM_DAY','M','D',
  15,'C','(평가 : 적합 O, 부적합 X)',NULL,'Y','N','N',1140,'Y','system');
INSERT INTO TBL_QPS_CHK_ITEM (FORM_ID,HOSP_CD,SORT,ITEM_NM,INPUT_GB,CARRY_YN,USE_YN) VALUES
 ('NUR063','*', 1,'세척 배수 상태 여부','CHECK','N','Y'),
 ('NUR063','*', 2,'세척용 브러시 도구 상태','CHECK','N','Y'),
 ('NUR063','*', 3,'소독제 농도 및 유효기간','CHECK','N','Y'),
 ('NUR063','*', 4,'의료폐기물 전용용기 적정사용','CHECK','N','Y'),
 ('NUR063','*', 5,'의료폐기물 유효기간 확인','CHECK','N','Y'),
 ('NUR063','*', 6,'개인보호구 비치 여부','CHECK','N','Y'),
 ('NUR063','*', 7,'감염성과 비감염 오물구분','CHECK','N','Y'),
 ('NUR063','*', 8,'표준지침준수 여부','CHECK','N','Y'),
 ('NUR063','*', 9,'안전관리 여부 확인','CHECK','N','Y'),
 ('NUR063','*',10,'청소, 청결상태 여부','CHECK','N','Y'),
 ('NUR064','*',1,'손소독을 시행하였습니까?','CHECK','N','Y'),
 ('NUR064','*',2,'보호구 착용 하였습니까?','CHECK','N','Y'),
 ('NUR064','*',3,'바닥은 소독액(중간수준소독제) 청소하였습니까?','CHECK','N','Y'),
 ('NUR064','*',4,'세탁물 종류(기타/오염)가 구분되어 있습니까?','CHECK','N','Y'),
 ('NUR064','*',5,'주변 소독은 (중간수준소독제) 하였습니까?','CHECK','N','Y'),
 ('NUR064','*',6,'청소도구의 관리와 정리는 잘 되어 있습니까?','CHECK','N','Y');

-- ═══════════════════════════════════════════════════════════════════════════
-- NUR065 · 병동 시설/환자 안전 점검 일지 [cap209·210]
--                              [ITEM_COL · 일 · D/E/N 열 · ★점검사항 설명 열]
-- ═══════════════════════════════════════════════════════════════════════════
--   ⚠2쪽(인계사항·병실 순회 기록)은 「행 반복 × 묶음」이라 못 담았다 — v3 조합 대기(판독 §NUR065).
--     ***1쪽만 등록한다. 담은 척하지 않는다.***
INSERT INTO TBL_QPS_CHK_FORM
 (FORM_ID, HOSP_CD, FORM_NM, CATE_CD, DEPT_CD, AXIS_GB, PRD_GB,
  COL_NMS, DESC_NM, SIGNER_YN, NOTE_YN, NOTE_NM, FIX_YN, SORT_NO, USE_YN, REG_USER)
VALUES
 ('NUR065','*','병동 시설/환자 안전 점검 일지','SAFE','NURSE','ITEM_COL','D',
  'D,E,N','점 검 사 항','N','Y','수리 및 기타 건의사항','N',1150,'Y','system');
INSERT INTO TBL_QPS_CHK_ITEM (FORM_ID,HOSP_CD,SORT,ITEM_NM,DESC_TXT,INPUT_GB,CARRY_YN,USE_YN) VALUES
 ('NUR065','*', 1,'화장실/샤워실','창틀, 구조물, 청결 및 미끄럼상태, 청소도구(수거)','CHECK','N','Y'),
 ('NUR065','*', 2,'옥상/휴게공간','재떨이, 의자, 운동기구, 그 외 구조물, 청결 및 미끄럼상태','CHECK','N','Y'),
 ('NUR065','*', 3,'병실','창틀, 침대, 상두대, 조명시설, 냉장고, 기타 구조물, 방충망','CHECK','N','Y'),
 ('NUR065','*', 4,'복도','조명시설, 안전바, 청결 및 미끄럼상태, 부착물 훼손여부','CHECK','N','Y'),
 ('NUR065','*', 5,'출입문/상담실','잠금 및 손상여부, 비상구, 구조변경 유무, 내부물품확인','CHECK','N','Y'),
 ('NUR065','*', 6,'안정실','잠금장치, 유리보호필름, 창틀, 그 외 구조물','CHECK','N','Y'),
 ('NUR065','*', 7,'간호사실(외)','각종 구조물, 도구, 휠체어 및 Pole 상태점검, 응급벨','CHECK','N','Y'),
 ('NUR065','*', 8,'로비 및 지하','운동기구, 노래방, 정수기, 전화기, 비상구, 계단(난간), PC방','CHECK','N','Y'),
 ('NUR065','*', 9,'프로그램실','의자, 탁자, 창틀, 형광등, 기타 구조물','CHECK','N','Y'),
 ('NUR065','*',10,'소방시설','소화기수량 및 위치, 소화전/비상구 표시등 작동, 구조대 시설 잠금 및 적치물확인','CHECK','N','Y');

-- ═══════════════════════════════════════════════════════════════════════════
-- NUR066 · 고압증기멸균기 CI 작업일지 [cap270]   [DAY_ITEM · 7일×5쪽 · 멸균품 묶음]
-- ═══════════════════════════════════════════════════════════════════════════
--   ★원본 `멸균품 내역` 한 칸의 이름 붙은 입력 4벌(D-set·Can / Gauze / Forcep jar / Long forcep)을
--     열 5개로 폈다(묶음 `멸균품 내역`). 글자는 다 산다.
--   ⚠`Internall`(l 두 번)은 원본 오타 그대로. 날짜 밑 요일은 날짜에서 나온다.
INSERT INTO TBL_QPS_CHK_FORM
 (FORM_ID, HOSP_CD, FORM_NM, CATE_CD, DEPT_CD, AXIS_GB, PRD_GB, PRD_KIND,
  SPLIT_N, SPLIT_DIR, HEAD_NMS, SIGNER_YN, NOTE_YN, FIX_YN, SORT_NO, USE_YN, REG_USER)
VALUES
 ('NUR066','*','고압증기멸균기 CI 작업일지','STERIL','NURSE','DAY_ITEM','M','D',
  7,'C','고압증기 멸균기','N','N','N',1160,'Y','system');
INSERT INTO TBL_QPS_CHK_ITEM (FORM_ID,HOSP_CD,SORT,ITEM_NM,GRP_NM,INPUT_GB,UNIT_NM,USE_YN) VALUES
 ('NUR066','*',1,'작동시간'          ,NULL         ,'TEXT',NULL,'Y'),
 ('NUR066','*',2,'D-set'             ,'멸균품 내역','NUM' ,NULL,'Y'),
 ('NUR066','*',3,'Can'               ,'멸균품 내역','NUM' ,NULL,'Y'),
 ('NUR066','*',4,'Gauze'             ,'멸균품 내역','NUM' ,NULL,'Y'),
 ('NUR066','*',5,'Forcep jar'        ,'멸균품 내역','NUM' ,NULL,'Y'),
 ('NUR066','*',6,'Long forcep'       ,'멸균품 내역','NUM' ,NULL,'Y'),
 ('NUR066','*',7,'External Indicator',NULL         ,'TEXT',NULL,'Y'),
 ('NUR066','*',8,'Internall Indicator',NULL        ,'TEXT',NULL,'Y'),
 ('NUR066','*',9,'작동자'            ,NULL         ,'TEXT',NULL,'Y');

-- 확인 --------------------------------------------------------------------
SELECT 'NUR3 서식' AS chk, COUNT(*) AS n FROM TBL_QPS_CHK_FORM WHERE HOSP_CD='*' AND FORM_ID BETWEEN 'NUR043' AND 'NUR066';
SELECT 'NUR 전체' AS chk, COUNT(*) AS n FROM TBL_QPS_CHK_FORM WHERE HOSP_CD='*' AND FORM_ID LIKE 'NUR%';
SELECT 'NUR 항목' AS chk, f.FORM_ID, f.FORM_NM, f.AXIS_GB, COUNT(i.SORT) AS 항목수
  FROM TBL_QPS_CHK_FORM f LEFT JOIN TBL_QPS_CHK_ITEM i ON i.FORM_ID=f.FORM_ID AND i.HOSP_CD=f.HOSP_CD
 WHERE f.HOSP_CD='*' AND f.FORM_ID LIKE 'NUR%'
 GROUP BY f.FORM_ID, f.FORM_NM, f.AXIS_GB ORDER BY f.SORT_NO;
