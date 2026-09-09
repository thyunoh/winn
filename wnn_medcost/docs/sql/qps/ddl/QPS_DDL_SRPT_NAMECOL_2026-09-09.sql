-- =====================================================================
-- 보고서(safeRpt) 반복행 표의 「직원 이름 열」 — DDL (2026-09-09)
--   왜 : 사용자 「safeRpt 이름 칸도 진행해줘」. 오늘 점검표 격자에는 직원 이름 열을 붙였는데(INPUT_GB='NAME'),
--        보고서의 **반복행 표**에도 직원 이름을 적는 열이 있다 —
--          · 혈액 반납/폐기 신청서(BLOODRTN) : 수(책임)간호사 · 담당간호사 · 담당의사 · 혈액은행담당자
--          · 의무기록 완결도(MRCOMPL)        : 담당의사 · 담당의사 확인
--          · 보건관리 업무일지(HLTDIARY)     : 상담 근로자
--        손으로 치면 이름이 갈려 나중에 사람으로 셀 수 없다 ⇒ 인사 등록 명단을 골라 넣게 한다.
--
--   ── 왜 새 칸이 필요한가 ───────────────────────────────────────────────
--     점검표는 항목마다 한 줄(TBL_QPS_CHK_ITEM)이라 그 줄의 INPUT_GB 를 쓰면 됐다.
--     보고서 반복행은 **열 이름이 `SUB_COLS` 쉼표 한 줄**이라 열마다 표시를 달 자리가 없다.
--     ⇒ 이름 열의 **번호 목록**을 담는 칸을 하나 더한다(1부터 셈, 쉼표. 예 BLOODRTN = '5,6,7,8').
--     ⛔열 이름에 표식을 박는 방법(「담당의사#」)은 쓰지 않았다 — 화면·인쇄에서 벗겨내야 하고
--       병원이 서식을 고칠 때 그 규약을 알아야 한다. 값 자리는 열 **번호**라 이름을 바꿔도 작성분은 안전하지만,
--       뜻을 이름 문자열에 섞으면 나중에 반드시 헷갈린다.
--
--   ★★**이름 열이라고 다 켜면 안 된다**(점검표에서 실증한 것과 같다) — 같은 「성명」이라도
--       인사기록카드(HRCARD)의 3번 벌은 **가족사항**이다. 환자·가족 열에 직원 명단이 뜨면 안 된다.
--       ⇒ 시드로 켜는 것은 아래 3유형 7열뿐이다([QPS_SEED_SRPT_NAMECOL_2026-09-09.sql](../seed/QPS_SEED_SRPT_NAMECOL_2026-09-09.sql)).
--
--   더하기만 하는 DDL ⇒ 운영 선적용 안전(옛 WAR 는 새 칸을 안 읽는다).
--   코드 : Qps_SQL.xml(selectSafeRptForm·selectSafeRptSub 조회 2문) · qpsSafeRpt.jsp
--          ⛔**매퍼 변경 → WAR 재빌드 + 재기동 필요**(자바는 Map 을 그대로 흘려 손댈 것이 없다)
-- =====================================================================

ALTER TABLE TBL_QPS_SAFERPT_FORM
  ADD COLUMN NAME_COLS VARCHAR(100) NULL COMMENT '직원 이름 열 번호(1부터, 쉼표) — 작성 화면에서 인사 등록 명단을 골라 넣는다' AFTER SUB_COLS;

ALTER TABLE TBL_QPS_SAFERPT_SUB
  ADD COLUMN NAME_COLS VARCHAR(100) NULL COMMENT '직원 이름 열 번호(1부터, 쉼표) — 벌마다 따로' AFTER SUB_COLS;

-- ── 확인 ──────────────────────────────────────────────────────────────
-- SELECT TABLE_NAME, COLUMN_NAME, COLUMN_TYPE FROM INFORMATION_SCHEMA.COLUMNS
--  WHERE TABLE_SCHEMA='WNN' AND TABLE_NAME IN ('TBL_QPS_SAFERPT_FORM','TBL_QPS_SAFERPT_SUB')
--    AND COLUMN_NAME='NAME_COLS';
