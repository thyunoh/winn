-- =====================================================================
-- 점검표 「직원 이름 칸」 시드 — INPUT_GB='NAME' (2026-09-09)
--   왜 : 어제 사인 칸(SIGN_NO=900)에 인사 등록 명단을 붙였는데(§7-⑱), **격자 안에도 직원 이름을 적는 열**이 있다
--        (직원 교육 현황표 성명 · 검진 명부 이름 · 서명대장 성함 …). 손으로 치면 「홍길동」·「홍 길동」처럼 갈려
--        나중에 사람으로 세기 어렵고, 사인 칸과 달리 고를 수도 없었다.
--
--   ── 어떻게 ───────────────────────────────────────────────────────────
--     · **새 표·새 칸 없음** — 입력 종류(INPUT_GB)에 값 하나(NAME)를 더했다(SEL 을 더한 2026-09-02 전례와 같은 결).
--       서버는 INPUT_GB 를 그대로 흘려보내고 CHECK 일 때만 O/X 로 맞추므로(ChkNorm) 자바·매퍼 변경이 없다.
--     · 화면(qpsChk.jsp)은 그 열 입력칸에 `.nmpick` 를 붙이고 사인 칸과 **같은 datalist**(signerPicks.do)를 단다.
--     · **글자 칸(TEXT)과 똑같이 동작한다** — 아래 15열은 지금 전부 TEXT 라 이 UPDATE 로 값·정렬·O/X 규칙이 바뀌지 않는다.
--       되돌리려면 맨 아래 원복 UPDATE 한 줄이면 된다.
--
--   ★★**이름 열이라고 다 켜면 안 된다** — 같은 「이름」이라도 갈린다(그래서 자동 규칙을 쓰지 않았다) :
--       · 직원 : HLT002~011 검진 명부 「이름·직원명」 · ADM014 「성명」 · ADM010 「성함」 · NUT006/008/015
--       · 환자 : LAB002·NUR018 「이름」 · LAB021·LAB028·MRC001·NUR012 「환자명」 · NUR011 「성명」 · PHA003 「환자명」 …
--       · 가족 : (safeRpt) 인사기록카드 HRCARD 「가족사항 - 성명」
--     ⇒ 아래 15열만 켠다. 확인자·점검자 같은 서명류 열은 **일부러 안 켰다**(병원이 서식 관리에서 켜면 된다 —
--        서식마다 그 칸이 우리 직원인지 외부 업체인지 갈리므로 공통 시드로 정하지 않는다).
--
--   대상 = 공통 서식(HOSP_CD='*')만. 병원 복제본은 0건임을 확인했다(2026-09-09).
--   코드 : qpsChk.jsp(isNameGb·ltxtCls·noxCls·ckSignPickSync) · qpsChkForm.jsp(입력 종류 「직원 이름」) — **JSP 만, 재빌드 불필요**
-- =====================================================================

-- ── 넣기 전 확인 : 15줄이 나오고 ig 가 전부 TEXT 여야 한다 ────────────
-- SELECT FORM_ID, SORT, ITEM_NM, INPUT_GB FROM TBL_QPS_CHK_ITEM
--  WHERE HOSP_CD='*' AND USE_YN='Y' AND ( … 아래 WHERE 와 같은 조건 … ) ORDER BY FORM_ID;

UPDATE TBL_QPS_CHK_ITEM SET INPUT_GB = 'NAME'
 WHERE HOSP_CD = '*' AND USE_YN = 'Y'
   AND (    (FORM_ID = 'ADM010' AND ITEM_NM = '성함')                    -- 서명대장
         OR (FORM_ID = 'ADM014' AND ITEM_NM = '성명')                    -- 직원 교육 현황표
         OR (FORM_ID IN ('HLT002','HLT003','HLT004','HLT005','HLT006','HLT007','HLT008','HLT011')
                                 AND ITEM_NM = '이름')                    -- 직원 검진·접종 명부 7종 + 유소견자 관리대장
         OR (FORM_ID IN ('HLT009','HLT010') AND ITEM_NM = '직원명')       -- 직원·신규직원 건강검진 결과표
         OR (FORM_ID = 'NUT006' AND ITEM_NM = '이름')                    -- 개인위생 확인 기록지
         OR (FORM_ID = 'NUT008' AND ITEM_NM = '조리원 성명')             -- 개인위생 점검일지
         OR (FORM_ID = 'NUT015' AND ITEM_NM = '성명')                    -- 건강관리 현황표
       );
-- 기대 : 15 rows

-- ── 확인 ──────────────────────────────────────────────────────────────
-- SELECT FORM_ID, SORT, ITEM_NM FROM TBL_QPS_CHK_ITEM
--  WHERE HOSP_CD='*' AND USE_YN='Y' AND INPUT_GB='NAME' ORDER BY FORM_ID;   -- 15줄

-- ── 되돌리기(원복) ────────────────────────────────────────────────────
-- UPDATE TBL_QPS_CHK_ITEM SET INPUT_GB='TEXT' WHERE HOSP_CD='*' AND INPUT_GB='NAME';
