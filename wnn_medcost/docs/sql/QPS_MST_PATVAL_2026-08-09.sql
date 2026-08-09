-- =====================================================================
-- QPS 지표 마스터 — 마지막 2종 연결 (2026-08-09) : 요로감염 · 직원 감염노출
--   이걸로 18종이 전부 가동된다.
--
--   ★요로감염(UTI) = 환자평가표 직결(PATVAL). 다만 욕창과 셈법이 다르다 —
--     평가표의 UTI 는 발생일이 없고 '현재 요로감염 있음'을 뜻하는 **유병 플래그**라
--     매달 평가표마다 다시 켜진다(실측 2,228행 = 725명). 그대로 세면 발생률이 아니라 유병 연인원이 된다.
--     → 매퍼 selectMonthlyNumerPatvalUti 가 **환자별 최초 평가표의 달**에 1건으로 센다.
--     원천 구분은 INCID_GB='UTI' 로 한다(BEDSORE 와 같은 PATVAL 안에서 갈라짐).
--
--   ★직원 감염노출(INFEXP) = 사고보고형. 분모는 직원수(STAFF) — 직원안전사고와 같다.
-- =====================================================================

UPDATE TBL_QPS_INDI_MST
   SET NUMER_SRC  = 'PATVAL',
       INCID_GB   = 'UTI',
       DENOM_GB   = 'INDAYS',
       DEFINITION = '환자 1,000 재원일당 신규 요로감염 발생 건수의 비율',
       NUMER_DESC = '신규 요로감염 발생 환자 수(환자평가표 요로감염 항목 최초 확인 기준)',
       DENOM_DESC = '재원환자 연인원수(해당 기간 일일 재원환자 수의 합)',
       SOURCE_NM  = '환자평가표(자동 집계)',
       METHOD_NM  = '평가표 항목 자동집계',
       OWNER_NM   = '감염관리담당자'
 WHERE INDI_CD = 'UTI' AND HOSP_CD = '*';

UPDATE TBL_QPS_INDI_MST
   SET DEFINITION = '재직 직원 100명당 감염노출(주사침 자상·혈액체액 노출 등) 발생 건수의 비율',
       NUMER_DESC = '직원 감염노출 발생 건수',
       DENOM_DESC = '재직 직원 수',
       SOURCE_NM  = '직원 감염노출 보고서',
       METHOD_NM  = '사고보고 자동집계',
       OWNER_NM   = '감염관리담당자'
 WHERE INDI_CD = 'INFEXP' AND HOSP_CD = '*';

-- 확인 — 18종 전부 정의문이 채워져야 한다(빈 곳 0)
-- SELECT COUNT(*) AS no_def FROM TBL_QPS_INDI_MST WHERE DEFINITION IS NULL;
