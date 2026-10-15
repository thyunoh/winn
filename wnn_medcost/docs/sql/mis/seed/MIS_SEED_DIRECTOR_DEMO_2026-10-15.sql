-- =====================================================================
-- MIS 병원장 조회 · 간호사 관리 — 시연 샘플 (2026-10-15)
--   대상 : 위너넷 테스트 병원 w1234567 (입원 자료가 있어 원무 환자고객 화면도 함께 보인다)
--   표식 : MEMO = '샘플' → 아래 맨 아래 줄로 한 번에 지운다.
--   ※ DDL(MIS_DDL_DIRECTOR_2026-10-15.sql)을 먼저 실행할 것.
-- =====================================================================

-- 1) 직원 명단 — 2026년 10월 분(간호사 6 · 간호조무사 2 · 원무 1). 간호사 6명이 1인당 환자수 계산에 쓰인다.
DELETE FROM TBL_MIS_EMR_STAFF WHERE HOSP_CD = 'w1234567' AND YYYYMM = '202610' AND MEMO = '샘플';
INSERT INTO TBL_MIS_EMR_STAFF (HOSP_CD, YYYYMM, SEQ_NUM, EMP_NO, EMP_NM, JOB_NM, DEPT_NM, WORK_GB, JOIN_DT, RETIRE_DT, WORK_DAYS, WORK_HOURS, NIGHT_CNT, PAY_AMT, MEMO, REG_USER)
VALUES
 ('w1234567','202610', 901,'N001','김수연','간호사','A1병동','정규','20190302',NULL,22,176,4,3200000,'샘플','admin'),
 ('w1234567','202610', 902,'N002','이정아','간호사','A1병동','정규','20200115',NULL,22,176,4,3350000,'샘플','admin'),
 ('w1234567','202610', 903,'N003','박미경','간호사','A2병동','정규','20160701',NULL,22,176,3,3800000,'샘플','admin'),
 ('w1234567','202610', 904,'N004','최지원','간호사','A2병동','계약','20250901',NULL,20,160,2,2900000,'샘플','admin'),
 ('w1234567','202610', 905,'N005','정하늘','간호사','B1병동','정규','20230210',NULL,22,176,4,3100000,'샘플','admin'),
 ('w1234567','202610', 906,'N006','강민서','간호사','B1병동','정규','20210305',NULL,22,176,3,3250000,'샘플','admin'),
 ('w1234567','202610', 907,'C001','윤보람','간호조무사','A1병동','정규','20210801',NULL,22,176,4,2600000,'샘플','admin'),
 ('w1234567','202610', 908,'C002','한소희','간호조무사','B1병동','계약','20240601',NULL,20,160,2,2300000,'샘플','admin'),
 ('w1234567','202610', 909,'A001','오세진','원무','원무과','정규','20180102',NULL,22,176,0,3000000,'샘플','admin');

-- 2) 인력 변동 기록 — 입사 · 퇴사 · 이동(최근 몇 달)
DELETE FROM TBL_MIS_STAFF_CHG WHERE HOSP_CD = 'w1234567' AND MEMO = '샘플';
INSERT INTO TBL_MIS_STAFF_CHG (HOSP_CD, CHG_DT, STAFF_NM, JOB_NM, WARD_NM, CHG_GB, MEMO, REG_USER)
VALUES
 ('w1234567','20260815','송지아','간호사','A2병동','IN','샘플 — 신규 입사(야간 충원 목적)','admin'),
 ('w1234567','20260901','임태윤','간호사','B1병동','OUT','샘플 — 개인 사정으로 퇴사','admin'),
 ('w1234567','20260915','박미경','간호사','B1병동','MOVE','샘플 — A2 → B1 병동 이동','admin'),
 ('w1234567','20260920','권나윤','간호조무사','A1병동','OUT','샘플 — 계약 만료','admin'),
 ('w1234567','20261005','장도윤','간호사','A1병동','IN','샘플 — 경력직 입사','admin');

-- 확인
SELECT JOB_NM, COUNT(*) AS cnt FROM TBL_MIS_EMR_STAFF WHERE HOSP_CD = 'w1234567' AND YYYYMM = '202610' AND MEMO = '샘플' GROUP BY JOB_NM;
SELECT CHG_DT, STAFF_NM, CHG_GB FROM TBL_MIS_STAFF_CHG WHERE HOSP_CD = 'w1234567' AND MEMO LIKE '샘플%' ORDER BY CHG_DT;

-- 지우기(시연 끝나면 주석을 풀어 실행)
-- DELETE FROM TBL_MIS_EMR_STAFF WHERE HOSP_CD = 'w1234567' AND YYYYMM = '202610' AND MEMO = '샘플';
-- DELETE FROM TBL_MIS_STAFF_CHG WHERE HOSP_CD = 'w1234567' AND MEMO LIKE '샘플%';
