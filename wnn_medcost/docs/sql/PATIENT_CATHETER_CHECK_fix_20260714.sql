-- =====================================================================
--  PATIENT_CATHETER_CHECK  14일 초과 판정 수정 (branch 3 덮어쓰기 회귀)
--  작성일: 2026-07-14
--
--  ★핵심 사유 (주원* 461119, 위너넷요양병원 2026-07 사례로 확정):
--    2026-07-11 패치([패치0])가 branch 3/5/6 의 이월 기산을
--    '전월 작성일+1' 로 통일하면서, branch 3 에 In_Date_01 공란 가드 없이
--    무조건 SET 하여 — 당월 평가표에 기재된 "진짜 신규 재삽입일"까지
--    전월 작성일+1 로 덮어쓰는 회귀 발생.
--
--  ★사례 데이터 (환자ID 461119 · 입원일 20230728):
--    이전월: 진료일 20260601 작성일 20260607, 회차1 삽입 20260518 제거 없음
--            → PmCathFlag='1', PmNullFlag='N', PmLastFlag='1', PmDoc_Date=20260607
--    해당월: 진료일 20260701 작성일 20260707,
--            회차1 삽입 20260621 제거 20260703 / 회차2 삽입 20260706 제거 없음
--            → In_Date_01=20260621, OutDate_01=20260703, In_Date_02=20260706
--    기존(오탐): branch 3 이 In_Date_01 을 20260608(전월작성일+1)로 덮어씀
--                → 06-08 ~ 07-03 = 25일 ≥ 14 → 'Y' (해당, 오탐)
--    올바른 계산: 기재된 재삽입일 06-21 그대로
--                → 06-21 ~ 07-03 = 12일 / (3일 공백 후 새 구간) 07-06 ~ 07-07 = 1일 → 'N'
--
--  ★수정 원칙: '전월 작성일+1' 은 덮어쓰기가 아니라 "하한(GREATEST)" 으로 적용.
--    - 당월 첫 삽입일 공란            → 전월작성일+1 (7/11 패치 의도 그대로)
--    - 기재일 > 전월작성일+1 (신규 재삽입, 본 사례 6/21) → 기재일 유지
--    - 기재일 < 전월작성일+1 (이월 삽입일 재기재, 정양* 5/26 류) → 하한 적용(더블카운트 차단)
--    → 7/11 패치의 검증 케이스(정양* 290725, 서울대림)도 그대로 'N' 유지됨.
--
--  적용  : 아래 [패치] 의 branch 3 블록만 교체하여 DROP + CREATE 재생성.
--  주의  : 교체 후 "적정성평가 월 자료생성" 재실행(좌측 분모/분자 저장값 갱신).
--          우측 오류점검 그리드(overdayYn)는 함수 라이브 호출이라 즉시 반영됨.
--  참고  : branch 5(CmNullFlag='Y')는 당월 삽입칸이 전부 공란이라 현행 유지 무해.
--          branch 6 은 branch 3 이 항상 먼저 걸려 도달 불가(죽은 코드) — 정리만 대상.
-- =====================================================================


-- ─────────────────────────────────────────────────────────────────────
-- [패치] branch 3 교체
--
-- ▷ 기존 (2026-07-11 패치본):
--
--	        ELSEIF PmCathFlag = '1' AND PmNullFlag = 'N' AND CmCathFlag = '1' AND CmNullFlag = 'N' AND PmLastFlag = '1' THEN
--	               -- 당월 시작일자를 전월 마지막 삽입일자를 시작일자로 한다.
--	               SET In_Date_01 = DATE_FORMAT(DATE_ADD(STR_TO_DATE(PmDoc_Date,'%Y%m%d'), INTERVAL 1 DAY), '%Y%m%d');
--
-- ▷ 변경:

	        ELSEIF PmCathFlag = '1' AND PmNullFlag = 'N' AND CmCathFlag = '1' AND CmNullFlag = 'N' AND PmLastFlag = '1' THEN
	               -- 이월 기산 하한 = 전월 작성일+1.
	               -- 당월 첫 삽입일이 공란이면 하한을 그대로 쓰고,
	               -- 기재돼 있으면 GREATEST(기재일, 하한) — 신규 재삽입(예: 6/21)은 기재일 유지,
	               -- 이월 삽입일 재기재(전월 작성일 이전 날짜)만 하한으로 끌어올려 더블카운트 차단.
	               IF In_Date_01 = '00000000' THEN
	                   SET In_Date_01 = DATE_FORMAT(DATE_ADD(STR_TO_DATE(PmDoc_Date,'%Y%m%d'), INTERVAL 1 DAY), '%Y%m%d');
	               ELSE
	                   SET In_Date_01 = GREATEST(In_Date_01,
	                                    DATE_FORMAT(DATE_ADD(STR_TO_DATE(PmDoc_Date,'%Y%m%d'), INTERVAL 1 DAY), '%Y%m%d'));
	               END IF;


-- ─────────────────────────────────────────────────────────────────────
-- [검증 1] 사례 데이터 확인 (전월 작성일 20260607 재확인)
--
-- SELECT MED_START, DOC_DT, INDWELL_CATH,
--        CAT_IN_1, CAT_OUT_1, CAT_IN_2, CAT_OUT_2
--   FROM TBL_PATVAL_MST
--  WHERE HOSP_CD = '해당병원'
--    AND PAT_ID LIKE '461119%'
--    AND ADMIT_DT = '20230728'
--    AND MED_START LIKE '202606%'
--  ORDER BY DOC_DT DESC;


-- ─────────────────────────────────────────────────────────────────────
-- [검증 2] 수정 전/후 비교 (7/11 패치 방식과 동일하게 _TEST 로 먼저 생성 권장)
--
--  ① 수정본을 PATIENT_CATHETER_CHECK_TEST 로 생성
--  ② 기존 vs 수정 비교:
--
-- SELECT c.PAT_ID, c.ADMIT_DT, c.MED_START,
--        PATIENT_CATHETER_CHECK     (c.HOSP_CD,c.CLFORM_VER,c.PAT_ID,c.ADMIT_DT,c.MED_START,c.EVAL_TYPE,c.INDWELL_CATH,c.PAT_CLASS) AS old_val,
--        PATIENT_CATHETER_CHECK_TEST(c.HOSP_CD,c.CLFORM_VER,c.PAT_ID,c.ADMIT_DT,c.MED_START,c.EVAL_TYPE,c.INDWELL_CATH,c.PAT_CLASS) AS new_val
--   FROM TBL_PATVAL_MST c
--  WHERE c.HOSP_CD  = '해당병원'
--    AND c.MED_START LIKE '202607%'
--    AND c.INDWELL_CATH = '1'
--  HAVING old_val != new_val OR c.PAT_ID LIKE '461119%';
--
--  기대 결과:
--    · 주원* 461119 : old='Y' → new='N'   (이번 수정 대상)
--    · 정양* 290725 : old='N' → new='N'   (7/11 패치 케이스 유지 — 서울대림 11283190, 2026-07)
--
--  ③ 확인 후 본 함수 교체(DROP+CREATE), _TEST 삭제
--  ④ "적정성평가 월 자료생성" 재실행 → 좌측 05번 분자 갱신 확인
