-- ═══════════════════════════════════════════════════════════════════════════
-- 점검표 표준 서식 시드 — **간호/병동 1차** (2026-08-13) : NUR001~NUR020
--   원본 : SUNWOO HCMS ▸ 간호/병동 (사용자 캡처 cap197~306)
--   판독 정본 : docs/proposals/QPS_서식판독_간호병동_2026-08-13.md
--
-- ★★**새 DDL 이 필요 없다** — 전부 있는 칸으로 담았다(판독 §다음 차례).
--   단, 시설 때의 DDL(ENGINE4·CARRY·PRDSUB·SIDECOL·ITEMCOL·SPLIT·ROWBLK·PRDKIND 등)이
--   이미 적용된 DB 여야 한다. 운영 WNN 은 2026-08-12 에 전부 적용됐다.
--
-- ★공통 규칙(시설 1차 머리말 그대로) — 원본 오타·겹공백 보존 · 문항 번호 제거 ·
--   빈 행 안 넣음 · 병원 자료(미리 찍힌 품목·약품)는 서식('*')에 안 넣음 ·
--   쉼표로 갈리는 칸 = COL_NMS·HEAD_NMS·PRE_COLS·POST_COLS·SIGN_LINE·ROW_BLKS·PRD_SUB
--
-- ★LIST 축의 「열」은 TBL_QPS_CHK_ITEM 행으로 넣는다(FAC031·PHA013 전례).
--   CARRY_YN(전월복사)은 LIST 축의 열에만 건다.
-- ★SORT_NO : 간호/병동 = 500번대부터 (NUR번호×10 + 500)
-- ═══════════════════════════════════════════════════════════════════════════

DELETE FROM TBL_QPS_CHK_ITEM WHERE HOSP_CD='*' AND FORM_ID IN
 ('NUR001','NUR002','NUR003','NUR004','NUR005','NUR006','NUR007','NUR008','NUR009','NUR010',
  'NUR011','NUR012','NUR013','NUR014','NUR015','NUR016','NUR017','NUR018','NUR019','NUR020');
DELETE FROM TBL_QPS_CHK_FORM WHERE HOSP_CD='*' AND FORM_ID IN
 ('NUR001','NUR002','NUR003','NUR004','NUR005','NUR006','NUR007','NUR008','NUR009','NUR010',
  'NUR011','NUR012','NUR013','NUR014','NUR015','NUR016','NUR017','NUR018','NUR019','NUR020');

-- ═══════════════════════════════════════════════════════════════════════════
-- NUR001 · EO GAS 멸균기 일일점검표 [cap212]      [ITEM_DAY · 멸균기 계열 틀]
-- NUR002 · 고압증기멸균기 일일점검표 [cap215]     [ITEM_DAY · 같은 틀 · 다른 기기]
-- ═══════════════════════════════════════════════════════════════════════════
--   ★둘은 틀이 같다 — 다른 것은 항목 문구뿐(판독 §멸균기 계열).
--   ⚠HEAD `장비명` 의 미리 찍힌 값 `HE-420` 은 병원 자료 — 안 넣는다.
--   ⚠격자 아래 「문제 발생시」 표(발생일자·관리번호·문제 발생 내용·처리 결과 보고)는
--     `SUB_COLS`(격자 아래 자유행 표) 장치가 생기면 켠다. ***담은 척하지 않는다.***
INSERT INTO TBL_QPS_CHK_FORM
 (FORM_ID, HOSP_CD, FORM_NM, CATE_CD, DEPT_CD, AXIS_GB, PRD_GB, PRD_KIND,
  GUIDE_TXT, HEAD_NMS, SIGNER_YN, NOTE_YN, FIX_YN, SORT_NO, USE_YN, REG_USER)
VALUES
 ('NUR001','*','EO GAS 멸균기 일일점검표','STERIL','NURSE','ITEM_DAY','M','D',
  '정상 : O 비정상 : X','장비명','Y','N','N',510,'Y','system'),
 ('NUR002','*','고압증기멸균기 일일점검표','STERIL','NURSE','ITEM_DAY','M','D',
  '정상 : O 비정상 : X','장비명','Y','N','N',520,'Y','system');
INSERT INTO TBL_QPS_CHK_ITEM (FORM_ID,HOSP_CD,SORT,ITEM_NM,INPUT_GB,CARRY_YN,USE_YN) VALUES
 ('NUR001','*',1,'주위의 환기','CHECK','N','Y'),
 ('NUR001','*',2,'실린더와 본체의 연결 부위를 거품으로(거즈품등) 기포 발생 여부 - 주1회','CHECK','N','Y'),
 ('NUR001','*',3,'가스 배기 호스의 실외 장치 여부','CHECK','N','Y'),
 ('NUR001','*',4,'가스 실린더 잔류','CHECK','N','Y'),
 ('NUR001','*',5,'개폐 시 게이지 지침의 상태 확인','CHECK','N','Y'),
 ('NUR001','*',6,'프로그램 명령에 따른 진행 여부','CHECK','N','Y'),
 ('NUR001','*',7,'전원 연결 상태','CHECK','N','Y'),
 ('NUR001','*',8,'외관상 파손 여부','CHECK','N','Y');
-- ⚠NUR001 2번 `거품으로(거즈품등)` 은 원본 그대로(거즈 오기로 보이나 안 고친다)
INSERT INTO TBL_QPS_CHK_ITEM (FORM_ID,HOSP_CD,SORT,ITEM_NM,INPUT_GB,CARRY_YN,USE_YN) VALUES
 ('NUR002','*',1,'판넬 디스플레이 및 스위치 상태','CHECK','N','Y'),
 ('NUR002','*',2,'전원 연결 상태','CHECK','N','Y'),
 ('NUR002','*',3,'도어 잠금 상태','CHECK','N','Y'),
 ('NUR002','*',4,'프로그램 명령에 따라 진행 상태','CHECK','N','Y'),
 ('NUR002','*',5,'작동 시 에러 코드 발생 여부 상태','CHECK','N','Y'),
 ('NUR002','*',6,'챔버, 트레이 청결 상태','CHECK','N','Y'),
 ('NUR002','*',7,'스팀 누수 현상','CHECK','N','Y'),
 ('NUR002','*',8,'외관상 파손 여부 상태','CHECK','N','Y');

-- ═══════════════════════════════════════════════════════════════════════════
-- NUR003 · 낙상예방 시설환경 점검표 [cap265]   [ITEM_MONTH · 행 그룹 5 · 24항목]
-- ═══════════════════════════════════════════════════════════════════════════
--   ★트리 이름은 `낙상시설,환경 관리일지` 인데 **쉼표가 든 트리 이름**이라 표 제목(캡처 본문)을 썼다.
--     (FORM_NM 은 쉼표 안전하지만, 같은 계열 FALLENV 와 혼동을 피해 본문 제목으로 갈랐다)
--   ⚠GUIDE `양호: 0`(숫자 0)·FOOT `물필요한` — 원본 오타 그대로.
--   ★원본 행 머리글 3단의 맨 왼쪽 `매월 마지막주 금요일` 은 GUIDE 로 올렸다(글자 보존).
--   ⚠병실 묶음의 빈 행 1개는 안 넣는다.
INSERT INTO TBL_QPS_CHK_FORM
 (FORM_ID, HOSP_CD, FORM_NM, CATE_CD, DEPT_CD, AXIS_GB, PRD_GB,
  GUIDE_TXT, SIGN_LINE, SIGNER_YN, NOTE_YN, FIX_YN, FOOT_TXT, SORT_NO, USE_YN, REG_USER)
VALUES
 ('NUR003','*','낙상예방 시설환경 점검표','SAFE','NURSE','ITEM_MONTH','Y',
  '양호: 0/ 불량 x   ※매월 마지막주 금요일 점검','확 인 자,담당자 ( 수간호사 )','N','Y','N',
  '관리기준  1. 환자가 이동하는 통로에 물필요한 물건이 나와 있지 않도록 한다.  2. 정기적으로 원내 환경위험 요소를 제거한다.  3. 매월 1회( 매월 마지막 주 금요일 ) 점검하고 점검표는 병동에서 보관한다.',
  530,'Y','system');
INSERT INTO TBL_QPS_CHK_ITEM (FORM_ID,HOSP_CD,SORT,ITEM_NM,GRP_NM,INPUT_GB,CARRY_YN,USE_YN) VALUES
 ('NUR003','*', 1,'콜벨 : 위치 / 작동확인','병 실','CHECK','N','Y'),
 ('NUR003','*', 2,'바닥: 턱 / 홀 파인 곳 확인','병 실','CHECK','N','Y'),
 ('NUR003','*', 3,'낙상 및 미끄럼주의표지판','병 실','CHECK','N','Y'),
 ('NUR003','*', 4,'조명','병 실','CHECK','N','Y'),
 ('NUR003','*', 5,'바퀴점검: 침대, 휠체어, 워커','병 실','CHECK','N','Y'),
 ('NUR003','*', 6,'바닥의 물','병 실','CHECK','N','Y'),
 ('NUR003','*', 7,'미끄럼방지표지판(정수기 앞)','복 도','CHECK','N','Y'),
 ('NUR003','*', 8,'보행장애물건 확인 및 제거','복 도','CHECK','N','Y'),
 ('NUR003','*', 9,'낙상주의 표시: 바퀴 있는 물건들 확인','복 도','CHECK','N','Y'),
 ('NUR003','*',10,'조명','복 도','CHECK','N','Y'),
 ('NUR003','*',11,'바퀴점검:  휠체어, 이동볼대, 이동침대, 워커','복 도','CHECK','N','Y'),
 ('NUR003','*',12,'바닥의 물','복 도','CHECK','N','Y'),
 ('NUR003','*',13,'안전바','복 도','CHECK','N','Y'),
 ('NUR003','*',14,'바닥의 물','계 단','CHECK','N','Y'),
 ('NUR003','*',15,'낙상 및 미끄럼주의 표지판','계 단','CHECK','N','Y'),
 ('NUR003','*',16,'미끄럼방지시설','계 단','CHECK','N','Y'),
 ('NUR003','*',17,'낙상 및 미끄럼주의 표지판','화장실','CHECK','N','Y'),
 ('NUR003','*',18,'안전바','화장실','CHECK','N','Y'),
 ('NUR003','*',19,'조명','화장실','CHECK','N','Y'),
 ('NUR003','*',20,'바닥의 물','화장실','CHECK','N','Y'),
 ('NUR003','*',21,'미끄럼방지시설','화장실','CHECK','N','Y'),
 ('NUR003','*',22,'낙상 및 미끄럼주의 표지판','샤워실','CHECK','N','Y'),
 ('NUR003','*',23,'바닥의 물','샤워실','CHECK','N','Y'),
 ('NUR003','*',24,'안전바','샤워실','CHECK','N','Y');

-- ═══════════════════════════════════════════════════════════════════════════
-- NUR004 · 낙상 예방을 위한 환경 및 시설물 점검대장 [cap281]   [ITEM_MONTH]
-- ═══════════════════════════════════════════════════════════════════════════
--   ★NUR003 과 「누가 언제」가 다르다(매월 1일 병동책임자) — 다른 서식. 둘 다 쓰는지는 병원 확인.
--   ⚠원본 번호 칸 12줄 중 10~12 빈 줄은 안 넣는다.
INSERT INTO TBL_QPS_CHK_FORM
 (FORM_ID, HOSP_CD, FORM_NM, CATE_CD, DEPT_CD, AXIS_GB, PRD_GB,
  GUIDE_TXT, SIGN_LINE, SIGNER_YN, NOTE_YN, FIX_YN, SORT_NO, USE_YN, REG_USER)
VALUES
 ('NUR004','*','낙상 예방을 위한 환경 및 시설물 점검대장','SAFE','NURSE','ITEM_MONTH','Y',
  '*매월 1일 병동책임자 점검','병동책임자 확인,관리팀장 확인','N','Y','N',540,'Y','system');
INSERT INTO TBL_QPS_CHK_ITEM (FORM_ID,HOSP_CD,SORT,ITEM_NM,INPUT_GB,CARRY_YN,USE_YN) VALUES
 ('NUR004','*',1,'계단 미끄럼 방지 카페트 손상 여부 확인','CHECK','N','Y'),
 ('NUR004','*',2,'계단 및 병동 내 손잡이 고정 확인','CHECK','N','Y'),
 ('NUR004','*',3,'워커, 휠체어, 침상 고정 및 바퀴 안전점검','CHECK','N','Y'),
 ('NUR004','*',4,'야간 취침 등 조명 확인','CHECK','N','Y'),
 ('NUR004','*',5,'병실, 복도 바닥 경사진 곳과 파손 여부 확인','CHECK','N','Y'),
 ('NUR004','*',6,'표지판 부착 점검','CHECK','N','Y'),
 ('NUR004','*',7,'침대 난간 손상 여부','CHECK','N','Y'),
 ('NUR004','*',8,'호출벨(응급벨)확인','CHECK','N','Y'),
 ('NUR004','*',9,'미끄럼 방지 매트 손상 여부 확인','CHECK','N','Y');

-- ═══════════════════════════════════════════════════════════════════════════
-- NUR005 · 세탁물집하장 운반용기 소독 점검표 [cap301]  [ITEM_DAY · 주차 · ─머리글]
-- NUR006 · 세탁물 집하장 소독 점검표 [cap302]          [ITEM_DAY · 1~31일]
-- ═══════════════════════════════════════════════════════════════════════════
--   ★짝 대조 완료 — 대상(용기↔집하장)·격자(주차↔일)·서명이 달라 **둘 다** 넣는다.
--   ⚠NUR006 FOOT 의 `회석액`(2회)·`1:00` 은 원본 오타 그대로.
INSERT INTO TBL_QPS_CHK_FORM
 (FORM_ID, HOSP_CD, FORM_NM, CATE_CD, DEPT_CD, AXIS_GB, PRD_GB, PRD_KIND,
  PRD_HEAD_YN, HEAD_NMS, SIGNER_YN, NOTE_YN, FIX_YN, FOOT_TXT, SORT_NO, USE_YN, REG_USER)
VALUES
 ('NUR005','*','세탁물집하장 운반용기 소독 점검표','ENV','NURSE','ITEM_DAY','M','N',
  'Y',NULL,'N','N','N',
  '1. 주 1회 소독  2. 소독 : 환경소독제(1:80희석액) 사용  3. 환경소독제 유효기간: 24시간  4. 점검자 : 업무담당자',
  550,'Y','system'),
 ('NUR006','*','세탁물 집하장 소독 점검표','ENV','NURSE','ITEM_DAY','M','D',
  'N','부서','Y','N','N',
  '바닥소독 - 소독제(락스 1:100 회석액 : 물 1L + 락스 10ml) 에 적신 걸레(마포)로 닦는다. - 적절한 보호구착용(일회용장갑, 마스크)한다. / 기타 환경소독 -소독제(락스 1:00 회석액)로 닦는다 -기타 : 문, 각종 손잡이 / 청소장비 보관 -걸레 : 사용 후 세척하여 환경소독제 담근 후 건조 보관 - 방수앞치마 : 사용 후 환경 소독제 뿌리고 건조 - 장갑, 마스크 : 일회용, 사용 후 폐기',
  560,'Y','system');
INSERT INTO TBL_QPS_CHK_ITEM (FORM_ID,HOSP_CD,SORT,ITEM_NM,INPUT_GB,CARRY_YN,USE_YN) VALUES
 ('NUR005','*',1,'보호구는 준비되어 있는가? (마스크, 장갑, 방수앞치마)','CHECK','N','Y'),
 ('NUR005','*',2,'소독용품(환경소독제)는 준비되어 있는가?','CHECK','N','Y'),
 ('NUR005','*',3,'손 소독제는 비치되어있는가?','CHECK','N','Y'),
 ('NUR005','*',4,'운반용기 소독','CHECK','N','Y'),
 ('NUR006','*',1,'손소독 시행여부','CHECK','N','Y'),
 ('NUR006','*',2,'보호구 착용여부','CHECK','N','Y'),
 ('NUR006','*',3,'바닥소독액 청소여부','CHECK','N','Y'),
 ('NUR006','*',4,'세탁물 종류구분','CHECK','N','Y'),
 ('NUR006','*',5,'주변소독 여부','CHECK','N','Y'),
 ('NUR006','*',6,'청소도구의 관리/정리','CHECK','N','Y'),
 ('NUR006','*',7,'주2회소독','CHECK','N','Y');

-- ═══════════════════════════════════════════════════════════════════════════
-- NUR007 · 욕창예방활동 및 관리 Checklist [cap238~242]
--                                [ITEM_DAY · D,E,N · 7일×5쪽 · 환자 단위]
-- ═══════════════════════════════════════════════════════════════════════════
--   ★원본이 7일씩 5쪽 — SPLIT_N=7. 「빈 화면 4장」의 정체가 2~5쪽이었다.
--   ★환자 단위(등록번호·성명·병실) — 상단 자유칸으로 받는다.
--   ★★사인 행(900)도 D·E·N 으로 갈리는지 시드 뒤 화면 검증 1순위.
INSERT INTO TBL_QPS_CHK_FORM
 (FORM_ID, HOSP_CD, FORM_NM, CATE_CD, DEPT_CD, AXIS_GB, PRD_GB, PRD_KIND, PRD_SUB,
  SPLIT_N, SPLIT_DIR, HEAD_NMS, SIGNER_YN, NOTE_YN, FIX_YN, SORT_NO, USE_YN, REG_USER)
VALUES
 ('NUR007','*','욕창예방활동 및 관리 Checklist','SAFE','NURSE','ITEM_DAY','M','D','D,E,N',
  7,'C','등록번호,성명,성별/나이,병실','Y','N','N',570,'Y','system');
INSERT INTO TBL_QPS_CHK_ITEM (FORM_ID,HOSP_CD,SORT,ITEM_NM,INPUT_GB,CARRY_YN,USE_YN) VALUES
 ('NUR007','*',1,'2시간마다 체위 변경 및 시트 주름 제거','CHECK','N','Y'),
 ('NUR007','*',2,'뼈 돌출부위 눌리지 않도록 베개 등으로 지지','CHECK','N','Y'),
 ('NUR007','*',3,'Air 매트 사용과 기능점검','CHECK','N','Y'),
 ('NUR007','*',4,'환자 옮길 시 끌지 말고 들기','CHECK','N','Y'),
 ('NUR007','*',5,'피부상태 확인','CHECK','N','Y'),
 ('NUR007','*',6,'균형 있는 음식섭취 권장','CHECK','N','Y'),
 ('NUR007','*',7,'실금 또는 실변, 설사 시 즉시 청결 유지','CHECK','N','Y'),
 ('NUR007','*',8,'피부를 건조한 상태로 유지시키고, 침구나 환의가 젖을 경우 즉시 교환','CHECK','N','Y'),
 ('NUR007','*',9,'반창고 자국 마찰로 인한 찰과상, 타박상 생기지 않도록 주의','CHECK','N','Y');

-- ═══════════════════════════════════════════════════════════════════════════
-- NUR008 · 멸균물품보관장 일일점검표 [cap213]   [ITEM_DAY · 기기명 머리 계열]
-- NUR009 · 청소 점검일지 [cap214]               [ITEM_DAY · 같은 틀]
-- ═══════════════════════════════════════════════════════════════════════════
--   ★「기기명 머리 + 항목 행」 계열 — 기기명은 상단 자유칸으로(미리 찍힌 값은 병원 자료).
--   ⚠원본 항목 앞 번호 칸은 우리 행 번호가 대신한다.
--   ⚠NUR008 `지난것은`·물음표 앞 공백, NUR009 7번의 빈 괄호 — 원본 그대로.
INSERT INTO TBL_QPS_CHK_FORM
 (FORM_ID, HOSP_CD, FORM_NM, CATE_CD, DEPT_CD, AXIS_GB, PRD_GB, PRD_KIND,
  HEAD_NMS, SIGNER_YN, NOTE_YN, FIX_YN, SORT_NO, USE_YN, REG_USER)
VALUES
 ('NUR008','*','멸균물품보관장 일일점검표','STERIL','NURSE','ITEM_DAY','M','D',
  '기기명','Y','Y','N',580,'Y','system'),
 ('NUR009','*','청소 점검일지','ENV','NURSE','ITEM_DAY','M','D',
  '기기명','Y','Y','N',590,'Y','system');
INSERT INTO TBL_QPS_CHK_ITEM (FORM_ID,HOSP_CD,SORT,ITEM_NM,INPUT_GB,CARRY_YN,USE_YN) VALUES
 ('NUR008','*',1,'멸균 물품 선입선출은 올바르게 유지되는가 ?','CHECK','N','Y'),
 ('NUR008','*',2,'포장이 벗겨지거나 물기가 보이는 것은 없는가 ?','CHECK','N','Y'),
 ('NUR008','*',3,'CI 미부착된 것은 없는가 ?','CHECK','N','Y'),
 ('NUR008','*',4,'멸균 기간이 지난것은 없는가 ?','CHECK','N','Y'),
 ('NUR008','*',5,'적절한 온도와 습도가 유지되는가 ?','CHECK','N','Y'),
 ('NUR008','*',6,'내부 정결 상태는 양호한가 ?','CHECK','N','Y'),
 ('NUR008','*',7,'주 1회 물품 보관장 소독은 하는가 ?','CHECK','N','Y'),
 ('NUR009','*',1,'청소 및 정리정돈 확인 청결구역 -> 오염구역 (청소순서 준수)','CHECK','N','Y'),
 ('NUR009','*',2,'바닥에 물이 고여 있는지 확인','CHECK','N','Y'),
 ('NUR009','*',3,'장비 사용 후 소독 확인','CHECK','N','Y'),
 ('NUR009','*',4,'선반, 벽, 배기관, 부착물 청소 확인','CHECK','N','Y'),
 ('NUR009','*',5,'소독시 청소 / 환기 상태 확인','CHECK','N','Y'),
 ('NUR009','*',6,'소독기 내부 소독 확인 (매주 금요일 시행)','CHECK','N','Y'),
 ('NUR009','*',7,'멸균 물품 보관장 소독 확인 - 주 1회이상 (소독제:            )','CHECK','N','Y');

-- ═══════════════════════════════════════════════════════════════════════════
-- NUR010 · 검체 냉장고 온도 점검표 [cap216]   [DAY_ITEM · 열 묶음 10am/10pm]
-- NUR013 · 혈액 냉장고 온도 점검표 [cap202]   [DAY_ITEM · 같은 꼴 · 1~6℃]
-- ═══════════════════════════════════════════════════════════════════════════
--   ★시설 FAC044 와 같은 「온도+점검자가 시각마다 한 벌」 — 열 묶음 확정 규칙(근거 3종).
--   ⚠원본 머리글은 거꾸로 쌓였다(값 위·시각 아래) — 글자는 다 있고 위아래만 바뀐다.
--   ⚠cap200 「혈액 냉장고 온도 점검표」는 `WARD_Chart_051 내용 동일` 껍데기 — 서식이 아니다.
--   ⚠NUR013 좌측 도구판의 `Duty 사용` 체크는 병원 확인 항목.
INSERT INTO TBL_QPS_CHK_FORM
 (FORM_ID, HOSP_CD, FORM_NM, CATE_CD, DEPT_CD, AXIS_GB, PRD_GB, PRD_KIND,
  GUIDE_TXT, SIGNER_YN, NOTE_YN, FIX_YN, SORT_NO, USE_YN, REG_USER)
VALUES
 ('NUR010','*','검체 냉장고 온도 점검표','EQUIP','NURSE','DAY_ITEM','M','D',
  '냉장고 적정온도 : 2~8 ℃','N','N','N',600,'Y','system'),
 ('NUR013','*','혈액 냉장고 온도 점검표','EQUIP','NURSE','DAY_ITEM','M','D',
  '냉장고 적정온도 : 1~6 ℃','N','N','N',630,'Y','system');
INSERT INTO TBL_QPS_CHK_ITEM (FORM_ID,HOSP_CD,SORT,ITEM_NM,GRP_NM,INPUT_GB,UNIT_NM,USE_YN) VALUES
 ('NUR010','*',1,'냉장고 온도','10am','NUM','℃','Y'),
 ('NUR010','*',2,'점검자'    ,'10am','TEXT',NULL,'Y'),
 ('NUR010','*',3,'냉장고 온도','10pm','NUM','℃','Y'),
 ('NUR010','*',4,'점검자'    ,'10pm','TEXT',NULL,'Y'),
 ('NUR013','*',1,'냉장고 온도','10AM','NUM','℃','Y'),
 ('NUR013','*',2,'점검자'    ,'10AM','TEXT',NULL,'Y'),
 ('NUR013','*',3,'냉장고 온도','10PM','NUM','℃','Y'),
 ('NUR013','*',4,'점검자'    ,'10PM','TEXT',NULL,'Y');

-- ═══════════════════════════════════════════════════════════════════════════
-- NUR011 · 혈액 관리 대장 [cap198]                       [LIST · 도착시간 묶음]
-- NUR012 · 혈액입출고대장 [cap199]                       [LIST]
-- ═══════════════════════════════════════════════════════════════════════════
--   ★NUR011 원본은 도착시간 묶음 아래가 2단(시각 한 칸 / 수령자 서명 두 칸) —
--     격자 한 칸을 위아래로 쪼개는 장치가 없어 **3열로 편다**(글자 보존).
--   ⚠`수령자 서명` 이 왜 둘인지 모른다 — 병원 확인 항목. 답이 오면 이름을 가른다.
--   ⚠분류에 「혈액」이 없다 — 혈액 계열은 SAFE(안전·감염)에 둔다(판독 §NUR011).
INSERT INTO TBL_QPS_CHK_FORM
 (FORM_ID, HOSP_CD, FORM_NM, CATE_CD, DEPT_CD, AXIS_GB, PRD_GB, EQUIP_CNT,
  SIGNER_YN, NOTE_YN, FIX_YN, SORT_NO, USE_YN, REG_USER)
VALUES
 ('NUR011','*','혈액 관리 대장','SAFE','NURSE','LIST','M',20,'N','N','N',610,'Y','system'),
 ('NUR012','*','혈액입출고대장','SAFE','NURSE','LIST','M',15,'N','N','N',620,'Y','system');
INSERT INTO TBL_QPS_CHK_ITEM (FORM_ID,HOSP_CD,SORT,ITEM_NM,GRP_NM,INPUT_GB,CARRY_YN,USE_YN) VALUES
 ('NUR011','*', 1,'날짜'          ,NULL      ,'TEXT','N','Y'),
 ('NUR011','*', 2,'등록번호'      ,NULL      ,'TEXT','N','Y'),
 ('NUR011','*', 3,'성명'          ,NULL      ,'TEXT','N','Y'),
 ('NUR011','*', 4,'성별/나이'     ,NULL      ,'TEXT','N','Y'),
 ('NUR011','*', 5,'용량'          ,NULL      ,'TEXT','N','Y'),
 ('NUR011','*', 6,'혈액종류 및 번호',NULL    ,'TEXT','N','Y'),
 ('NUR011','*', 7,'유효기간'      ,NULL      ,'TEXT','N','Y'),
 ('NUR011','*', 8,'혈액수량'      ,NULL      ,'TEXT','N','Y'),
 ('NUR011','*', 9,'혈액형'        ,NULL      ,'TEXT','N','Y'),
 ('NUR011','*',10,'도착시간'      ,'도착시간','TEXT','N','Y'),
 ('NUR011','*',11,'수령자 서명'   ,'도착시간','TEXT','N','Y'),
 ('NUR011','*',12,'수령자 서명'   ,'도착시간','TEXT','N','Y'),
 ('NUR011','*',13,'인수자 서명'   ,NULL      ,'TEXT','N','Y'),
 ('NUR012','*', 1,'환자명'    ,NULL,'TEXT','N','Y'),
 ('NUR012','*', 2,'등록번호'  ,NULL,'TEXT','N','Y'),
 ('NUR012','*', 3,'생년월일'  ,NULL,'TEXT','N','Y'),
 ('NUR012','*', 4,'혈액번호'  ,NULL,'TEXT','N','Y'),
 ('NUR012','*', 5,'수령일'    ,NULL,'TEXT','N','Y'),
 ('NUR012','*', 6,'불출일'    ,NULL,'TEXT','N','Y'),
 ('NUR012','*', 7,'불출간호사',NULL,'TEXT','N','Y'),
 ('NUR012','*', 8,'수령간호사',NULL,'TEXT','N','Y'),
 ('NUR012','*', 9,'불출시간'  ,NULL,'TEXT','N','Y');

-- ═══════════════════════════════════════════════════════════════════════════
-- NUR014 · AED 일상점검표 [cap207]              [DAY_ITEM · 상단 자유칸 4]
-- NUR015 · 고압증기멸균기일상점검 [cap208]      [DAY_ITEM · NUR002 와 축이 다르다]
-- ═══════════════════════════════════════════════════════════════════════════
--   ★NUR015 는 NUR002(ITEM_DAY)와 이름이 닮았지만 **축이 다르다** — 둘 다 넣는다.
--   ⚠NUR014 HEAD 의 미리 찍힌 값(자동 심장 충격기(AED)·매일 1회)은 문서 값 — 서식에 못 박는다.
--   ⚠`배터리 상 태`·`청결 상태`·`내•외부` 겹공백·가운뎃점 — 원본 그대로.
--   ★NUR015 4번 항목의 쉼표는 ITEM_NM 이라 안전하다(축이 다르면 위험도 다르다).
INSERT INTO TBL_QPS_CHK_FORM
 (FORM_ID, HOSP_CD, FORM_NM, CATE_CD, DEPT_CD, AXIS_GB, PRD_GB, PRD_KIND,
  GUIDE_TXT, HEAD_NMS, SIGNER_YN, NOTE_YN, FIX_YN, FOOT_TXT, SORT_NO, USE_YN, REG_USER)
VALUES
 ('NUR014','*','AED 일상점검표','EQUIP','NURSE','DAY_ITEM','M','D',
  '* 양호(○), 불량 및 정비필요(X)로 표시','기기명,모델명,점검주기,S/N','N','N','N',NULL,640,'Y','system'),
 ('NUR015','*','고압증기멸균기일상점검','STERIL','NURSE','DAY_ITEM','M','D',
  '*양호(○) 불량 및 정비필요 (X)','기기명,모델명','N','N','N',
  '점검 후 양호 이외의 결과시→감염관리담당자에게 보고 후→의료기기 수리의뢰서를 작성하여 의료기기담당자에게 보고',
  650,'Y','system');
INSERT INTO TBL_QPS_CHK_ITEM (FORM_ID,HOSP_CD,SORT,ITEM_NM,INPUT_GB,CARRY_YN,USE_YN) VALUES
 ('NUR014','*',1,'전원 On/Off','CHECK','N','Y'),
 ('NUR014','*',2,'배터리 상 태','CHECK','N','Y'),
 ('NUR014','*',3,'배터리(유효기간)','CHECK','N','Y'),
 ('NUR014','*',4,'AED 패드(유효기간확인)','CHECK','N','Y'),
 ('NUR014','*',5,'AED와패드 연결상태','CHECK','N','Y'),
 ('NUR014','*',6,'장비작동정상 소리확인','CHECK','N','Y'),
 ('NUR014','*',7,'청결 상태','CHECK','N','Y'),
 ('NUR014','*',8,'점검자','TEXT','N','Y'),
 ('NUR015','*',1,'내•외부 청결여부','CHECK','N','Y'),
 ('NUR015','*',2,'Door 고무패킹 상태확인','CHECK','N','Y'),
 ('NUR015','*',3,'전원작동 ON/OFF','CHECK','N','Y'),
 ('NUR015','*',4,'온도멸균드라이 압력, 램프표시','CHECK','N','Y'),
 ('NUR015','*',5,'저수통FULL 보충여부확인','CHECK','N','Y'),
 ('NUR015','*',6,'멸균기 챔버내 배수거름망 이물질확인','CHECK','N','Y'),
 ('NUR015','*',7,'사용 후 전원 OFF','CHECK','N','Y'),
 ('NUR015','*',8,'점검자','TEXT','N','Y');

-- ═══════════════════════════════════════════════════════════════════════════
-- NUR016 · 지참약 마약 관리대장 [cap211]        [LIST · 환자 단위]
-- ═══════════════════════════════════════════════════════════════════════════
--   ★환자 단위(한 환자에 한 장) — 상단 자유칸 5(벌린 자간은 원본 그대로).
--   ⚠원본 `재고량` 이 0 으로 미리 찍혀 있다 — 자동 누계인지 손입력인지 못 가른다.
--     우리는 적는 칸(NUM)으로 둔다. 병원 확인 항목.
INSERT INTO TBL_QPS_CHK_FORM
 (FORM_ID, HOSP_CD, FORM_NM, CATE_CD, DEPT_CD, AXIS_GB, PRD_GB, EQUIP_CNT,
  HEAD_NMS, SIGNER_YN, NOTE_YN, FIX_YN, SORT_NO, USE_YN, REG_USER)
VALUES
 ('NUR016','*','지참약 마약 관리대장','DRUG','NURSE','LIST','M',31,
  '등 록 번 호,병 실,환 자 이 름,성별 / 나이,약품명','N','N','N',660,'Y','system');
INSERT INTO TBL_QPS_CHK_ITEM (FORM_ID,HOSP_CD,SORT,ITEM_NM,INPUT_GB,CARRY_YN,USE_YN) VALUES
 ('NUR016','*',1,'날짜'      ,'TEXT','N','Y'),
 ('NUR016','*',2,'입고량'    ,'NUM' ,'N','Y'),
 ('NUR016','*',3,'출고량'    ,'NUM' ,'N','Y'),
 ('NUR016','*',4,'재고량'    ,'NUM' ,'N','Y'),
 ('NUR016','*',5,'간호사확인','TEXT','N','Y'),
 ('NUR016','*',6,'비고'      ,'TEXT','N','Y');

-- ═══════════════════════════════════════════════════════════════════════════
-- NUR017 · 격리실환경관리점검부 [cap217]        [DAY_ITEM · 안내는 FOOT 으로]
-- ═══════════════════════════════════════════════════════════════════════════
--   ⚠원본 안내 상자는 표 「위 오른쪽」인데 GUIDE(200자)에 안 들어가 FOOT 으로 내렸다(글자 보존).
--   ★`수리-△` 세 번째 결과는 걱정거리가 아니다 — CHECK 칸은 글 칸이라 △도 들어간다(판독 §코드 확인).
INSERT INTO TBL_QPS_CHK_FORM
 (FORM_ID, HOSP_CD, FORM_NM, CATE_CD, DEPT_CD, AXIS_GB, PRD_GB, PRD_KIND,
  SIGNER_YN, NOTE_YN, FIX_YN, FOOT_TXT, SORT_NO, USE_YN, REG_USER)
VALUES
 ('NUR017','*','격리실환경관리점검부','SAFE','NURSE','DAY_ITEM','M','D',
  'N','N','N',
  '[점검항목별 세부내용] 1. 병실 문 점검 (병실 폐문, 격리 표식지 안내문) 2. 보호구 비치 여부 (보호장구, 알콜젤) 3. 병실 안 구비 물품 (알콜젤, 격리 폐기물 전용용기, 환자 개인사용 물품) 4. 접촉격리실 기구, 사용한 개인 물품 (높은 수준의 소독 또는 멸균) 5. 오염세탁물구분배출, 격리 의료 폐기물 구분 배출 6. 격리실 환경 소독 및 정리정돈 (중간정도 소독제 사용) 각 점검항목을 확인하고, 점검결과를 기록한다. (점검결과 : 양호-O, 불량-X, 수리-△)',
  670,'Y','system');
INSERT INTO TBL_QPS_CHK_ITEM (FORM_ID,HOSP_CD,SORT,ITEM_NM,INPUT_GB,CARRY_YN,USE_YN) VALUES
 ('NUR017','*',1,'병실 문 점검','CHECK','N','Y'),
 ('NUR017','*',2,'보호구 비치','CHECK','N','Y'),
 ('NUR017','*',3,'병실 안 구비물품점검','CHECK','N','Y'),
 ('NUR017','*',4,'기구 및 개인물품관리','CHECK','N','Y'),
 ('NUR017','*',5,'폐기물 및 세탁물 배출','CHECK','N','Y'),
 ('NUR017','*',6,'격리실 환경 소독','CHECK','N','Y'),
 ('NUR017','*',7,'점검자','TEXT','N','Y'),
 ('NUR017','*',8,'서명','TEXT','N','Y');

-- ═══════════════════════════════════════════════════════════════════════════
-- NUR018 · 이상 검사결과 CVR 관리대장 - 임상병리 [cap218]   [LIST]
-- ═══════════════════════════════════════════════════════════════════════════
--   ★꼬리표 `- 임상병리` 는 소관 부서 표시 — 병동 트리·병동 셀렉트라 DEPT 는 NURSE.
INSERT INTO TBL_QPS_CHK_FORM
 (FORM_ID, HOSP_CD, FORM_NM, CATE_CD, DEPT_CD, AXIS_GB, PRD_GB, EQUIP_CNT,
  SIGNER_YN, NOTE_YN, FIX_YN, SORT_NO, USE_YN, REG_USER)
VALUES
 ('NUR018','*','이상 검사결과 CVR 관리대장 - 임상병리','SAFE','NURSE','LIST','M',20,
  'N','N','N',680,'Y','system');
INSERT INTO TBL_QPS_CHK_ITEM (FORM_ID,HOSP_CD,SORT,ITEM_NM,INPUT_GB,CARRY_YN,USE_YN) VALUES
 ('NUR018','*',1,'날짜'    ,'TEXT','N','Y'),
 ('NUR018','*',2,'등록번호','TEXT','N','Y'),
 ('NUR018','*',3,'이름'    ,'TEXT','N','Y'),
 ('NUR018','*',4,'병실'    ,'TEXT','N','Y'),
 ('NUR018','*',5,'검사명'  ,'TEXT','N','Y'),
 ('NUR018','*',6,'이상수치','TEXT','N','Y'),
 ('NUR018','*',7,'보고자'  ,'TEXT','N','Y'),
 ('NUR018','*',8,'확인자'  ,'TEXT','N','Y'),
 ('NUR018','*',9,'보고시간','TEXT','N','Y');

-- ═══════════════════════════════════════════════════════════════════════════
-- NUR019 · 비치약재고점검대장 [cap219]          [LIST · ★전월복사]
-- ═══════════════════════════════════════════════════════════════════════════
--   ★품명·단위는 매달 같은 목록 — CARRY_YN='Y'. 재고·유효기간은 매달 바뀌는 값이라 새로.
INSERT INTO TBL_QPS_CHK_FORM
 (FORM_ID, HOSP_CD, FORM_NM, CATE_CD, DEPT_CD, AXIS_GB, PRD_GB, EQUIP_CNT,
  SIGNER_YN, NOTE_YN, FIX_YN, SORT_NO, USE_YN, REG_USER)
VALUES
 ('NUR019','*','비치약재고점검대장','DRUG','NURSE','LIST','M',31,
  'N','N','N',690,'Y','system');
INSERT INTO TBL_QPS_CHK_ITEM (FORM_ID,HOSP_CD,SORT,ITEM_NM,INPUT_GB,CARRY_YN,USE_YN) VALUES
 ('NUR019','*',1,'품명'      ,'TEXT','Y','Y'),
 ('NUR019','*',2,'단위(용량)','TEXT','Y','Y'),
 ('NUR019','*',3,'재고'      ,'TEXT','N','Y'),
 ('NUR019','*',4,'유효기간'  ,'TEXT','N','Y');

-- ═══════════════════════════════════════════════════════════════════════════
-- NUR020 · 비치의약품 보관상태 점검대장(병동용) [cap221·222]
--                                   [ITEM_COL · 일 · ★약국 PHA023 과 판박이]
-- ═══════════════════════════════════════════════════════════════════════════
--   ★PHA023 을 베끼고 셋만 다르다 — 1번 `이중금고` · 8·9번 묶음 `고주의약물` · 서명 `수간호사,약 사`.
--   ⚠약국판이 못 담은 둘이 여기서도 같다(비고 열의 미리 찍힌 안내 · 표 아래 유효기간점검/차광보관 빈 칸).
--     「항목마다 다른 안내」 근거 2종째 — 또 나오면 장치를 만든다. ***담은 척하지 않는다.***
INSERT INTO TBL_QPS_CHK_FORM
 (FORM_ID, HOSP_CD, FORM_NM, CATE_CD, DEPT_CD, AXIS_GB, PRD_GB, EQUIP_CNT,
  COL_NMS, COL_SRC, GUIDE_TXT, HEAD_NMS,
  SIGNER_YN, NOTE_YN, FIX_YN, SIGN_LINE, FOOT_TXT, SORT_NO, USE_YN, REG_USER)
VALUES
 ('NUR020','*','비치의약품 보관상태 점검대장(병동용)','DRUG','NURSE','ITEM_COL','D',10,
  'Y,N,비고','F',NULL,NULL,
  'N','Y','N','수간호사,약 사',
  '조치사항 : 사용 중단된 의약품 비치, 의약품의 개봉, 파손 등 — 특이사항 칸에 적습니다.',
  700,'Y','system');
INSERT INTO TBL_QPS_CHK_ITEM (FORM_ID,HOSP_CD,SORT,ITEM_NM,GRP_NM,INPUT_GB,UNIT_NM,USE_YN) VALUES
 ('NUR020','*', 1,'이중금고'           ,'마약류'    ,'CHECK',NULL,'Y'),
 ('NUR020','*', 2,'출납대장 보유'      ,'마약류'    ,'CHECK',NULL,'Y'),
 ('NUR020','*', 3,'마약장 관리자 표시' ,'마약류'    ,'CHECK',NULL,'Y'),
 ('NUR020','*', 4,'잔량 반납 적절성'   ,'마약류'    ,'CHECK',NULL,'Y'),
 ('NUR020','*', 5,'분리보관여부'       ,'고위험약물','CHECK',NULL,'Y'),
 ('NUR020','*', 6,'고농축전해질류'     ,'고위험약물','CHECK',NULL,'Y'),
 ('NUR020','*', 7,'고위험의약품 리스트','고위험약물','CHECK',NULL,'Y'),
 ('NUR020','*', 8,'표시여부'           ,'고주의약물','CHECK',NULL,'Y'),
 ('NUR020','*', 9,'고주의약물 리스트'  ,'고주의약물','CHECK',NULL,'Y'),
 ('NUR020','*',10,'정확한 약품/수량'   ,'응급비치약','CHECK',NULL,'Y'),
 ('NUR020','*',11,'봉인여부'           ,'응급비치약','CHECK',NULL,'Y'),
 ('NUR020','*',12,'정확한 의약품/수량' ,'일반비치약','CHECK',NULL,'Y'),
 ('NUR020','*',13,'냉장보관 적절성'    ,'냉장보관'  ,'CHECK',NULL,'Y'),
 ('NUR020','*',14,'냉장,차광약품 리스트','냉장보관' ,'CHECK',NULL,'Y'),
 ('NUR020','*',15,'차광보관 적절성'    ,'차광보관'  ,'CHECK',NULL,'Y');

-- 확인 --------------------------------------------------------------------
SELECT 'NUR1 서식' AS chk, COUNT(*) AS n FROM TBL_QPS_CHK_FORM WHERE HOSP_CD='*' AND FORM_ID LIKE 'NUR0%' AND FORM_ID <= 'NUR020';
SELECT 'NUR1 항목' AS chk, f.FORM_ID, f.FORM_NM, f.AXIS_GB, COUNT(i.SORT) AS 항목수
  FROM TBL_QPS_CHK_FORM f LEFT JOIN TBL_QPS_CHK_ITEM i ON i.FORM_ID=f.FORM_ID AND i.HOSP_CD=f.HOSP_CD
 WHERE f.HOSP_CD='*' AND f.FORM_ID LIKE 'NUR0%' AND f.FORM_ID <= 'NUR020'
 GROUP BY f.FORM_ID, f.FORM_NM, f.AXIS_GB ORDER BY f.SORT_NO;
