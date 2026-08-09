-- =====================================================================
-- QPS 지표 마스터 — 사고보고형(INCIDENT) 5종 정의 채우기 (2026-08-09)
--   대상: PTSAFE(환자안전사고) · MEDICATION(투약오류) · ABUSE(학대·폭력)
--         SUICIDE(자살·자해) · STAFFSAFE(직원안전사고)
--
--   ★등급 기준(사용자 확정 2026-08-09): **낙상만 MIN_LEVEL=2(Level 2 이상), 나머지는 전건.**
--     MIN_LEVEL 을 NULL 로 두면 매퍼의 등급 조건이 꺼져 전건이 집계된다 — 그래서 아래 UPDATE 는
--     MIN_LEVEL 을 건드리지 않는다(현재 전부 NULL = 전건). 나중에 병원이 "Level 2 이상만" 을
--     원하면 **이 컬럼에 2 만 넣으면 되고 코드는 안 고친다.**
--     ※근접오류까지 세는 환자안전사고의 정의상 전건이 맞고, 투약오류·학대폭력·자살자해도
--       보고된 전건을 세는 것이 일반적이다.
--
--   분자·분모 문구는 이미 채록돼 있어(산식채록 문서) 건드리지 않는다 — 비어 있던
--   정의문·자료원·조사방법·담당만 채운다. 재실행 안전(UPDATE only).
-- =====================================================================

UPDATE TBL_QPS_INDI_MST
   SET DEFINITION = '환자 1,000 재원일당 환자안전사고(근접오류·위해사건·적신호사건) 보고 건수의 비율',
       SOURCE_NM  = '환자안전사고보고서',
       METHOD_NM  = '사고보고 자동집계',
       OWNER_NM   = 'QPS담당자'
 WHERE INDI_CD = 'PTSAFE' AND HOSP_CD = '*';

UPDATE TBL_QPS_INDI_MST
   SET DEFINITION = '환자 1,000 재원일당 투약오류 보고 건수의 비율',
       SOURCE_NM  = '환자안전사고보고서(투약)',
       METHOD_NM  = '사고보고 자동집계',
       OWNER_NM   = '약제담당자'
 WHERE INDI_CD = 'MEDICATION' AND HOSP_CD = '*';

UPDATE TBL_QPS_INDI_MST
   SET DEFINITION = '환자 1,000 재원일당 학대 및 폭력사건 보고 건수의 비율',
       SOURCE_NM  = '환자안전사고보고서(학대·폭력)',
       METHOD_NM  = '사고보고 자동집계',
       OWNER_NM   = 'QPS담당자'
 WHERE INDI_CD = 'ABUSE' AND HOSP_CD = '*';

UPDATE TBL_QPS_INDI_MST
   SET DEFINITION = '환자 1,000 재원일당 자살·자해 발생 보고 건수의 비율',
       SOURCE_NM  = '환자안전사고보고서(자살·자해)',
       METHOD_NM  = '사고보고 자동집계',
       OWNER_NM   = 'QPS담당자'
 WHERE INDI_CD = 'SUICIDE' AND HOSP_CD = '*';

UPDATE TBL_QPS_INDI_MST
   SET DEFINITION = '재직 직원 100명당 직원안전사고 발생 건수의 비율',
       SOURCE_NM  = '직원안전사고보고서',
       METHOD_NM  = '사고보고 자동집계',
       OWNER_NM   = '안전보건담당자'
 WHERE INDI_CD = 'STAFFSAFE' AND HOSP_CD = '*';

-- 확인
-- SELECT INDI_CD, INDI_NM, DEFINITION, IFNULL(MIN_LEVEL,'전건') LV, DENOM_GB, MULTIPLIER, UNIT
--   FROM TBL_QPS_INDI_MST WHERE NUMER_SRC = 'INCIDENT' ORDER BY SORT_NO;
