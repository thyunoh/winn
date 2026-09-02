-- ═══════════════════════════════════════════════════════════════════════════
-- 점검표 「선택 칸」(INPUT_GB='SEL') 도입 시드 — 델파이 dfm 입력 종류 대조 (2026-09-02 밤)
--   왜 : 원본 dfm 의 TcxCheckBox 수 ↔ 우리 시드 INPUT_GB 를 172종 전부 맞춰 보니, 원본이 **라디오 묶음**(정해진 몇 개 중 하나)인데
--        우리는 **글자 칸**(TEXT)인 서식이 3종 있었다. 글자로 「유」「무」를 치는 대신 고르게 한다.
--        (그 밖의 「구분·사용여부·이상수치」 TEXT 항목 8종은 원본도 글자 칸 — 그대로 둔다.)
--   어떻게 : INPUT_GB='SEL' + CELL_TXTS 에 선택지(쉼표). 코드 = qpsChk.jsp(그리기·저장·인쇄) · qpsChkForm.jsp(서식 관리) — 자바·DDL 변경 없음.
--   ★값은 고른 글자 그대로 저장된다 — 이미 글자로 적힌 문서(작성분 0건, 09-02 확인)가 있어도 그대로 보인다.
--   재실행 안전(UPDATE). 대상은 공용 서식(HOSP_CD='*')뿐.
-- ═══════════════════════════════════════════════════════════════════════════

-- ① FAC047 개인영상정보 관리대장 (FAC_Chart_063) — 「구분」이 이용/제공/열람/파기 라디오
UPDATE TBL_QPS_CHK_ITEM SET INPUT_GB='SEL', CELL_TXTS='이용,제공,열람,파기'
 WHERE FORM_ID='FAC047' AND HOSP_CD='*' AND SORT=1 AND ITEM_NM='구분';

-- ② NUR022 의료용마약류저장시설점검부 (Pharm_Chart_004_A) — 법정 서식 「점검내용」 밑에 저장시설/재고량/그 밖의 이상 유무가 각각 유/무.
--    ★우리 시드는 「점검내용」을 **별도 글자 열**로 넣었었다 — 원본·법정 서식에서 그것은 세 열을 덮는 **묶음 머리**다.
--      ⇒ 세 열에 GRP_NM='점검내용' 을 주고(대장은 열 묶음을 2단 머리로 그린다) 「점검내용」 열은 내린다.
UPDATE TBL_QPS_CHK_ITEM SET INPUT_GB='SEL', CELL_TXTS='유,무', GRP_NM='점검내용'
 WHERE FORM_ID='NUR022' AND HOSP_CD='*' AND SORT IN (3,4,5);
UPDATE TBL_QPS_CHK_ITEM SET USE_YN='N'
 WHERE FORM_ID='NUR022' AND HOSP_CD='*' AND SORT=2 AND ITEM_NM='점검내용';

-- ③ LAB001 검체 검사관리 및 TAT 관리대장 (PAT_Chart_001) — 「지연」이 유/무/응급 라디오(31일 × 3)
UPDATE TBL_QPS_CHK_ITEM SET INPUT_GB='SEL', CELL_TXTS='유,무,응급'
 WHERE FORM_ID='LAB001' AND HOSP_CD='*' AND SORT=21;

-- ④ 열 설명 갱신(문서용 — 동작 무관)
ALTER TABLE TBL_QPS_CHK_ITEM MODIFY INPUT_GB VARCHAR(10) NOT NULL DEFAULT 'CHECK'
  COMMENT 'CHECK=O/X · TEXT=글 · NUM=숫자 · SEL=선택(선택지는 CELL_TXTS 쉼표)';

-- 확인 : SEL 3서식 5항목 · NUR022 점검내용 열 내려감
SELECT FORM_ID, SORT, ITEM_NM, GRP_NM, INPUT_GB, CELL_TXTS, USE_YN
  FROM TBL_QPS_CHK_ITEM
 WHERE HOSP_CD='*' AND (INPUT_GB='SEL' OR (FORM_ID='NUR022' AND SORT=2))
 ORDER BY FORM_ID, SORT;
