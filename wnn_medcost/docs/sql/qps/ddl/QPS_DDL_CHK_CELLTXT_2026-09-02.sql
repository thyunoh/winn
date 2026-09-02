-- =====================================================================
-- 점검표 엔진 — 셀 고정문(CELL_TXTS) + w15 인사고과 평가표 등록 — DDL·시드 (2026-09-02)
--   왜 : 보류 서식 w15 인사고과평가표를 막던 마지막 조각. 설계는 QPS_보류서식_최종판정_2026-08-15.md §3 그대로 —
--        「10행 × 5열 = 50칸이 저마다 다른 글자」를 TBL_QPS_CHK_ITEM.CELL_TXTS(열마다 쉼표) 한 칸으로 푼다.
--        같은 날 오전에 넣은 행 배타 체크(EXCL_YN)가 나머지 절반이다(원본 폼은 「같은 Hint 묶음에서 하나만」 + 10행 「(하나만 표시)」).
--   근거 : 델파이 원본 Employee_Chart_011.dfm 에서 라벨 50개·체크박스 50개(Hint 묶음 10)·머리 5칸을 직접 뽑았다.
--   화면 : ITEM_COL 격자에서 문구가 있는 칸은 「글 + 그 아래 입력칸」. 글자를 더블클릭해도 토글. 인쇄는 격자 복사라 그대로.
--          비면 종전과 완전히 같다 — 등록된 309종 무영향. 더하기만 하는 DDL ⇒ 운영 선적용 안전.
--   코드 : Qps_SQL.xml(selectChkItems·insertChkItems) · qpsChkForm.jsp(항목표 「셀 고정문」 칸) · qpsChk.jsp(격자·더블클릭).
--          자바 변경 없음(항목 맵 그대로 흐른다) — 매퍼 XML 이 바뀌어 **재기동은 필요**.
--   ⚠사람 축은 없다(XR23 #44 와 같은 한계) — 문서 단위 「일」로 두어 평가일자마다 한 장. 같은 날 여러 명이면 날짜를 나눈다.
--     머리 칸에 소속·성명·직급·사번·입사일자가 있어 누구의 평가인지는 문서에 남는다.
-- =====================================================================

ALTER TABLE TBL_QPS_CHK_ITEM
  ADD COLUMN CELL_TXTS VARCHAR(1000) NULL
      COMMENT '셀 고정문 — 열마다 미리 찍힌 글(쉼표로 열 수만큼, 빈 자리는 보통 칸). ITEM_COL 전용. 예) 특출남 매우 조직적임,평균 이상임 최소의 지도 필요,…'
      AFTER SPAN_TXT;

-- ── w15 인사고과 평가표 (원무총무, 원본 Employee_Chart_011) ─────────────────────
DELETE FROM TBL_QPS_CHK_ITEM WHERE FORM_ID='ADM019' AND HOSP_CD='*';
DELETE FROM TBL_QPS_CHK_FORM WHERE FORM_ID='ADM019' AND HOSP_CD='*';

INSERT INTO TBL_QPS_CHK_FORM
 (FORM_ID, HOSP_CD, FORM_NM, CATE_CD, DEPT_CD, AXIS_GB, PRD_GB, COL_NMS, HEAD_NMS, EXCL_YN,
  SIGNER_YN, NOTE_YN, NOTE_NM, FIX_YN, SORT_NO, USE_YN, REG_USER) VALUES
 ('ADM019','*','인사 고과 평가표','ETC','ADMIN','ITEM_COL','D',
  '5점,4점,3점,2점,1점',                                   -- 원본 체크박스 캡션 5·4·3·2·1
  '소속,성명,직급,사번,입사일자,지각,징계,기타',            -- 고과대상자 5칸 + 아래 「지각·징계·기타」 3칸 = HEAD 8
  'Y',                                                    -- 한 줄에 O 하나(원본 「(하나만 표시)」, Hint 묶음 배타)
  'Y','Y','평가자의 의견','N',350,'Y','system');            -- 사인 행 = 평가자 · 표 아래 칸 = ■평가자의 의견 · SORT 350 = ADM018(340) 다음

INSERT INTO TBL_QPS_CHK_ITEM (FORM_ID,HOSP_CD,SORT,ITEM_NM,GRP_NM,CELL_TXTS,INPUT_GB,CARRY_YN,USE_YN) VALUES
 ('ADM019','*', 1,'필수적인 업무 지식 및 기술',NULL,'특출남 매우 조직적임,평균 이상임 최소의 지도 필요,적당함 일상적인 지도필요,평균 이상의 지도필요,부적당함 세심한 지도필요','CHECK','N','Y'),
 ('ADM019','*', 2,'업무의 정확성과 철저함',NULL,'상황과 관계없이 뛰어남,높은 수준 거의 검토 필요 없음,양호함. 기준과 일관성 있으며 일상적 검토필요,평균 이상의 지도필요,낮은 수준임','CHECK','N','Y'),
 ('ADM019','*', 3,'업무량',NULL,'성적이며 생산성이 높음,보통 요구량보다 많이 함,좋음 평균적임,단지 요구되는 최소한은 함,불충분함 자극필요','CHECK','N','Y'),
 ('ADM019','*', 4,'창의성',NULL,'보다 책임있고 기략있는 행동을 함,건설적인 사고 개선안을 제시함,보통 업무 수행 때때로 좋은 생각을 해냄,단지 명령대로 실시함,변화나 새로운 생각에 저항적임','CHECK','N','Y'),
 ('ADM019','*', 5,'협동능력',NULL,'즐거워하고 의욕적이며 사고성이 뛰어남,정중하고 구성원에게 도움을 줌,보통 다른 사람들과 잘 어울림,비협조적인 경향이 있음,불만족스러움 갈등이 자주 있음','CHECK','N','Y'),
 ('ADM019','*', 6,'정신적 주의력',NULL,'뛰어남. 즉시 새로운 생각이나 임무를 포착함,빨리 습득함 거의 지도가 필요 없음,새로운 방법을 배움 보통 능력을 가짐,상세한 지도가 계속 필요함,이해를 못함 가끔 혼동함','CHECK','N','Y'),
 ('ADM019','*', 7,'지시에 대한 복종성',NULL,'쉽게 따르며 건설적인 충고로 이득을 줌,쉽게 지시를 받아들임 재환기 시킬 필요는 거의 없음,지시를 보통 따르며 약간의 반복 필요,반항적이며 반복필요,지시를 무시. 실수를 인정하지 않고 다른 사람을 꾸짖음','CHECK','N','Y'),
 ('ADM019','*', 8,'단정한 외모와 친절도',NULL,'외모 항상 단정하며 누구에게나 항상 친절하다,외모와 친절도 거의 지도가 필요없음,외모와 친절도 만족스러움,어느정도의 지도 필요,세심한 지도 필요','CHECK','N','Y'),
 ('ADM019','*', 9,'출근 및 징계사항',NULL,'모범적이며 해당없음,거의 지각 및 무단외출과 징계에 해당되지 않음,보통은 정시에 출근함,자주 지각하며 결근함,믿을 수 없음','CHECK','N','Y'),
 ('ADM019','*',10,'승진의 능력 (하나만 표시)',NULL,'매우 유망함,현재 업무 이상의 취급 가능,경험을 얻으면 적절함,현재 업무에 제한됨,부정적임','CHECK','N','Y');
-- ※원본 3행 「성적이며 생산성이 높음」은 원본 표기 그대로(「정력적이며」의 오타로 보이나 글자를 바꾸지 않는다 — 원본 오타 보존 규칙)

-- ── 사용 서식 세트에 넣기 ─────────────────────────────────────────────────────
-- ★작성 화면은 「그 병원이 켠 서식」만 보인다(TBL_QPS_CHK_USE — 병원 세트가 있으면 그것, 없으면 '*' 기본 세트, 둘 다 없으면 전부).
--   새로 시드한 서식은 세트에 없어 **작성 화면에 안 나온다**(부서별 양식·서식 관리에는 나온다). 실제로 09-02 밤에 겪었다.
--   ⇒ 기본 세트('*')가 있으면 거기에 넣는다. 병원이 제 세트를 정해 둔 곳은 [우리 병원 사용 서식]에서 병원이 켠다.
INSERT INTO TBL_QPS_CHK_USE (HOSP_CD, FORM_ID, USE_YN, REG_USER)
SELECT '*', 'ADM019', 'Y', 'system' FROM DUAL
 WHERE EXISTS (SELECT 1 FROM TBL_QPS_CHK_USE WHERE HOSP_CD = '*')
ON DUPLICATE KEY UPDATE USE_YN = 'Y';

-- ── 확인 ────────────────────────────────────────────────────────────────────
SELECT COLUMN_NAME, COLUMN_TYPE FROM INFORMATION_SCHEMA.COLUMNS
 WHERE TABLE_SCHEMA='WNN' AND TABLE_NAME='TBL_QPS_CHK_ITEM' AND COLUMN_NAME='CELL_TXTS';
SELECT SORT, ITEM_NM, LENGTH(CELL_TXTS) - LENGTH(REPLACE(CELL_TXTS, ',', '')) + 1 AS 칸수 FROM TBL_QPS_CHK_ITEM
 WHERE HOSP_CD='*' AND FORM_ID='ADM019' ORDER BY SORT;   -- 전부 5 여야 한다
