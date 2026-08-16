-- ═══════════════════════════════════════════════════════════════════════════
-- RN25 병동비치약품점검표 — **두 서식으로 쪼개서** 등록 (2026-08-15 작성)
--   근거 캡처 : D:\위너넷\caps\RN_2026-08-14\RN25.png (인공신장 모듈)
--   판정      : docs/proposals/QPS_보류서식_최종판정_2026-08-15.md §1 ③ · §5
--
-- ⛔⛔ ***아직 돌리지 말 것 — 병원확인 #43 답을 받고 실행한다.***
--
--   물음 : 「종이 한 장을 **화면 둘**로 나눠도 되는가」
--     원본 한 장에 표가 둘인데 ***행 축이 서로 다르다*** —
--       위 = **약품**(경구·주사·수액·기타·설하정) × (약품명·수량) 3쌍
--       아래 = **점검항목 3개** × 일(1~31) + 점검자 확인란 + 문제발생 자유행 표
--     엔진은 한 서식에 축을 둘 담지 못한다(축이 곧 격자의 행이다).
--   · 「예」  → 이 파일 그대로 실행. 두 서식 모두 **기존 축**이라 새 조각이 필요 없다.
--   · 「아니오」(한 장이어야 한다) → **개별 화면** 후보로 돌린다(RN08~10 과 같은 취급).
--
--   ★쪼개도 병원이 매달 다시 치지 않는다 —
--     위 목록은 `LIST` 축이고 항목마다 `CARRY_YN='Y'` 를 켜 두었으므로 **[전월복사]로 딸려 온다**
--     (carryVals 의 LIST 경로. 원본에도 [전월복사] 단추가 있다).
--
--   ⚠부서 = `RENAL`(캡처가 인공신장 모듈). 간호·병동에도 같은 종이가 있으면
--     **부서 공유(COMMON)** 로 올릴지 병원확인 #35~37 계열로 함께 묻는다.
--   ⚠약품 프리셋(아세트아미노펜500mg·니트로글리세린·라식스주…)은 **넣지 않는다** —
--     병동마다 비치약이 다르다. 첫 달에 적고 그 뒤로는 전월복사가 나른다.
-- 재실행 안전(DELETE 후 INSERT).
-- ═══════════════════════════════════════════════════════════════════════════

DELETE FROM TBL_QPS_CHK_ITEM WHERE HOSP_CD='*' AND FORM_ID IN ('RNL028','RNL029');
DELETE FROM TBL_QPS_CHK_FORM WHERE HOSP_CD='*' AND FORM_ID IN ('RNL028','RNL029');

-- ── ① 비치 약물 목록 및 수량 — LIST + 블록 5 ────────────────────────────────
--   원본 왼쪽 세로 병합(경구/주사/수액/기타/설하정) = **행 블록**.
--   한 행에 (약품명·수량) 쌍이 셋이라 열은 6 — 원본 종이 폭을 그대로 따른다.
--   행 수는 원본 칸 수대로(경구 6 · 주사 6 · 수액 4 · 기타 1 · 설하정 1).
INSERT INTO TBL_QPS_CHK_FORM
 (FORM_ID, HOSP_CD, FORM_NM, CATE_CD, DEPT_CD, AXIS_GB, PRD_GB,
  ROW_BLKS, SIGNER_YN, NOTE_YN, FIX_YN, GUIDE_TXT, SORT_NO, USE_YN, REG_USER) VALUES
 ('RNL028','*','병동 비치 약물 목록 및 수량','EQUIP','RENAL','LIST','M',
  '경구>6,주사>6,수액>4,기타>1,설하정>1','N','N','N',
  '병동에 비치한 약과 수량을 적는다. 다음 달에는 [전월복사]로 그대로 가져온다.',
  1580,'Y','system');

-- ★CARRY_YN='Y' — 이 열들이 전월복사로 딸려 온다(매달 다시 치지 않게)
-- ⚠GRP_NM 은 비운다 — 넣으면 **원본에 없는 2단 머리**(「1」「2」「3」)가 생긴다.
--   원본 상단 표는 머리글 줄이 아예 없다. 열 이름만 여섯 번 서는 편이 원본에 가깝다.
INSERT INTO TBL_QPS_CHK_ITEM (FORM_ID,HOSP_CD,SORT,ITEM_NM,INPUT_GB,CARRY_YN,USE_YN) VALUES
 ('RNL028','*',1,'약품명','TEXT','Y','Y'),
 ('RNL028','*',2,'수량'  ,'TEXT','Y','Y'),
 ('RNL028','*',3,'약품명','TEXT','Y','Y'),
 ('RNL028','*',4,'수량'  ,'TEXT','Y','Y'),
 ('RNL028','*',5,'약품명','TEXT','Y','Y'),
 ('RNL028','*',6,'수량'  ,'TEXT','Y','Y');

-- ── ② 비치약품 점검표 — ITEM_DAY 3항목 + 사인 행 + 문제발생 자유행 표 ───────
--   원본 머리말 : 「D 또는 E 근무자가 점검 ( O 또는 X 로 표기 )」
--   하단 자유행 표 = 문제발생 날짜 · 문제점 및 문제 해결 상황 · 문제발생 날짜
--     ⚠원본은 「문제발생 날짜」가 **양 끝에 두 번** 나온다(왼쪽=발생, 오른쪽=해결).
--       글자를 원본 그대로 두되 오른쪽은 「문제해결 날짜」로 적는다 —
--       같은 이름 두 열은 화면에서 어느 칸인지 못 가른다(원본도 사람이 헷갈리는 자리다).
--       ***이 한 줄만 원본과 글자가 다르다*** — 병원확인 때 함께 확인.
INSERT INTO TBL_QPS_CHK_FORM
 (FORM_ID, HOSP_CD, FORM_NM, CATE_CD, DEPT_CD, AXIS_GB, PRD_GB, PRD_KIND,
  GUIDE_TXT, SIGNER_YN, NOTE_YN, FIX_YN, SUB_NM, SUB_COLS, SORT_NO, USE_YN, REG_USER) VALUES
 ('RNL029','*','병동 비치약품 점검표','EQUIP','RENAL','ITEM_DAY','M','D',
  'D 또는 E 근무자가 점검 ( O 또는 X 로 표기 )','Y','N','N',
  '문제 발생 시','문제발생 날짜,문제점 및 문제 해결 상황,문제해결 날짜',
  1590,'Y','system');

INSERT INTO TBL_QPS_CHK_ITEM (FORM_ID,HOSP_CD,SORT,ITEM_NM,INPUT_GB,CARRY_YN,USE_YN) VALUES
 ('RNL029','*',1,'유효기간이 경과한 약이 없다','CHECK','N','Y'),
 ('RNL029','*',2,'정해진 수량을 보유하고 있다','CHECK','N','Y'),
 ('RNL029','*',3,'보관상태가 양호하다'        ,'CHECK','N','Y');

-- ── 확인 ────────────────────────────────────────────────────────────────────
SELECT FORM_ID, FORM_NM, AXIS_GB, IFNULL(ROW_BLKS,'') blks, IFNULL(SUB_COLS,'') subcols,
       (SELECT COUNT(*) FROM TBL_QPS_CHK_ITEM i WHERE i.FORM_ID=f.FORM_ID AND i.HOSP_CD='*') 항목,
       (SELECT COUNT(*) FROM TBL_QPS_CHK_ITEM i WHERE i.FORM_ID=f.FORM_ID AND i.HOSP_CD='*' AND i.CARRY_YN='Y') 전월복사열
  FROM TBL_QPS_CHK_FORM f WHERE f.HOSP_CD='*' AND f.FORM_ID IN ('RNL028','RNL029');
