-- =====================================================================
-- QPS 지표 마스터 — 관찰형(MONITOR) 3종 정의 채우기 (2026-08-09)
--   대상: HANDWASH(손위생) · ISOLATION(격리지침) · SECLUSION(강박지침)
--
--   ★성격: 지표정의서의 분자·분모 문구는 원래 **병원이 채우는 칸**이다(§0.1 채록문서).
--     여기 넣는 값은 '표준 산식 시딩' — 병원이 정의서 화면에서 고치면 그 값이 이긴다
--     (HOSP_CD='*' 공통행이므로 병원 전용행을 추가하면 자동으로 덮인다).
--   ★근거: 손위생 정의서 캡처(단위 %, 상수 ×100) · 격리/강박은 분석보고서 분자·분모 라벨
--     ("수행건수 ÷ 전체 시행 건수"). docs/proposals/QPS_지표정의서_산식채록_2026-08-08.md
--
--   재실행해도 안전(UPDATE only). 적용 후 화면 [지표 정의] 박스에 그대로 나온다.
-- =====================================================================

UPDATE TBL_QPS_INDI_MST
   SET INDI_NM    = '손위생 수행률',
       DEFINITION = '손위생 수행이 필요한 상황(관찰 기회) 중 실제로 손위생을 수행한 비율',
       NUMER_DESC = '손위생 수행 건수(관찰 결과 수행으로 판정된 건수)',
       DENOM_DESC = '손위생 관찰 건수(손위생 수행이 필요한 상황의 관찰 기회 총합)',
       SOURCE_NM  = '손위생 모니터링 점검표',
       METHOD_NM  = '직접관찰법(WHO 손위생 5 moments)',
       OWNER_NM   = '감염관리담당자',
       DECIMALS   = 1
 WHERE INDI_CD = 'HANDWASH' AND HOSP_CD = '*';

UPDATE TBL_QPS_INDI_MST
   SET DEFINITION = '격리가 필요한 환자에 대해 격리지침을 준수하여 시행한 비율',
       NUMER_DESC = '격리지침 수행 건수',
       DENOM_DESC = '격리 시행 건수(전체)',
       SOURCE_NM  = '격리 모니터링 점검표',
       METHOD_NM  = '직접관찰·기록점검',
       OWNER_NM   = '감염관리담당자',
       DECIMALS   = 1
 WHERE INDI_CD = 'ISOLATION' AND HOSP_CD = '*';

UPDATE TBL_QPS_INDI_MST
   SET DEFINITION = '강박(신체억제) 시행 시 강박지침을 준수하여 시행한 비율',
       NUMER_DESC = '강박지침 수행 건수',
       DENOM_DESC = '강박 시행 건수(전체)',
       SOURCE_NM  = '강박 모니터링 점검표',
       METHOD_NM  = '직접관찰·기록점검',
       OWNER_NM   = 'QPS담당자',
       DECIMALS   = 1
 WHERE INDI_CD = 'SECLUSION' AND HOSP_CD = '*';

-- 확인
-- SELECT INDI_CD, INDI_NM, NUMER_SRC, MULTIPLIER, UNIT, DECIMALS, NUMER_DESC, DENOM_DESC
--   FROM TBL_QPS_INDI_MST WHERE NUMER_SRC = 'MONITOR';
