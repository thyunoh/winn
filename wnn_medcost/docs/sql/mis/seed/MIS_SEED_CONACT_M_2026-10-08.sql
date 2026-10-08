-- =====================================================================
-- MIS(경영관리) — 계약 구분 코드 'M' 추가 (2026-10-08, 사용자 결정 「계약 구분에 MIS 추가」)
--   공통코드 Z / CONACT_GB 에 '1' 진료비경영분석 · '2' 적정성평가 가 있다. 여기에 'M' 경영관리(MIS) 한 줄.
--   표 구조 변경 없음. 이 코드로 계약(TBL_HOSPCONT_MST, CONACT_GB='M')을 등록한 병원에만 사이드바 「경영관리(MIS)」 메뉴가 보이고 화면이 열린다.
--   계약관리·가입신청 계약 입력창의 구분 목록은 이 코드를 읽으므로 따로 손댈 것 없음.
--   ⚠로그인 쿠키 s_conact_gb(A/1/2 — 진료비·적정성 메뉴 분기)는 건드리지 않는다. MIS 는 별도 조회(/mis/menuChk.do)로 가른다.
--   다시 돌려도 안전(있으면 넣지 않음).
-- =====================================================================
INSERT INTO TBL_CODE_DTL (CODE_GB, CODE_CD, SUB_CODE, SUB_CODE_NM, START_DT, JOB_SEQ, END_DT, USE_YN, SORT, ACTION_YN, REG_DTTM, REG_USER)
SELECT 'Z', 'CONACT_GB', 'M', '경영관리(MIS)', '20261008', 1, '99991231', 'Y', 3, 'Y', NOW(), 'admin'
 WHERE NOT EXISTS (SELECT 1 FROM TBL_CODE_DTL WHERE CODE_GB = 'Z' AND CODE_CD = 'CONACT_GB' AND SUB_CODE = 'M');

-- 확인
SELECT CODE_GB, CODE_CD, SUB_CODE, SUB_CODE_NM, USE_YN, SORT FROM TBL_CODE_DTL WHERE CODE_GB = 'Z' AND CODE_CD = 'CONACT_GB' ORDER BY SUB_CODE;

-- (참고) 어느 병원에 MIS 를 열려면 계약관리 화면에서 구분 「경영관리(MIS)」 계약을 등록하면 된다. 급하면 SQL 로 :
-- INSERT INTO TBL_HOSPCONT_MST (HOSP_CD, START_DT, END_DT, CONACT_GB, JOB_SEQ, USE_YN, HOSP_UUID, ACTION_YN, REG_DTTM, REG_USER)
-- SELECT HOSP_CD, '20261008', '20991231', 'M', 1, 'Y', HOSP_UUID, 'Y', NOW(), 'admin' FROM TBL_HOSP_MST WHERE HOSP_CD = '21281238';
