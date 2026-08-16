-- =====================================================================
-- CLAIM(불만 및 고충처리 처리율) — 수기입력 → 처리대장 자동집계 전환 (2026-08-11)
--
--   전환 전 : NUMER_SRC='MANUAL'  → 병원이 대장에 적고 [월별 입력] 탭에 또 적었다.
--   전환 후 : NUMER_SRC='CMPL'    → TBL_QPS_CMPL(처리대장)에서 바로 집계한다.
--       분자 = 회신날짜가 있는 건(처리 완료)
--       분모 = 접수 건 전체
--       월 축 = RECV_MM(접수월)
--   ***같은 사고를 두 번 입력하게 만들지 않는다*** — 욕창을 PATVAL 로 돌린 것과 같은 이유다.
--
--   ★서비스(QpsServiceImpl.calcIndicator)의 CMPL 갈래는 지표분석보고서와 **같은 쿼리**
--     (selectCmplStatMonth)를 쓴다. 그래서 지표 화면과 보고서의 숫자가 어긋날 수 없다.
--
--   ★적용 전 확인 완료(2026-08-11 운영 DB):
--     · CLAIM 마스터는 공통('*') 행 하나뿐 — 병원 전용 행 없음
--     · TBL_QPS_MANUAL 에 CLAIM 자료 0건 — ***버려지는 입력값이 없다***
--     병원이 이미 수기로 적어 둔 곳이 있으면 이 UPDATE 로 그 값이 무시되므로
--     전환 전에 위 두 가지를 반드시 다시 확인할 것.
--
--   ★병원 전용 행도 함께 바꾼다 — 정의서를 편집한 병원은 자기 행에 산식 컬럼을
--     복사해 갖고 있어(문서 「지표정의서」 절), 공통 행만 고치면 그 병원은 안 바뀐다.
--
--   재실행 안전(같은 값으로 다시 써도 무해).
-- =====================================================================

-- 적용 전 상태
SELECT '전' AS gb, HOSP_CD, NUMER_SRC, DENOM_GB, NUMER_DESC, DENOM_DESC, SOURCE_NM
  FROM TBL_QPS_INDI_MST WHERE INDI_CD = 'CLAIM';

UPDATE TBL_QPS_INDI_MST
   SET NUMER_SRC = 'CMPL',
       -- 분모는 대장의 접수건수다. DENOM_GB(재원일수·직원수)를 쓰면 안 된다.
       DENOM_GB   = NULL,
       NUMER_DESC = '불만 및 고충 처리건수 (처리대장에서 회신날짜가 있는 건)',
       DENOM_DESC = '불만 및 고충 접수건수 (처리대장 접수 전체)',
       SOURCE_NM  = '불만고충 처리대장 (전산 자동집계)',
       METHOD_NM  = '전수조사 — 처리대장 접수월 기준 집계'
 WHERE INDI_CD = 'CLAIM';

-- 적용 후 상태
SELECT '후' AS gb, HOSP_CD, NUMER_SRC, DENOM_GB, NUMER_DESC, DENOM_DESC, SOURCE_NM
  FROM TBL_QPS_INDI_MST WHERE INDI_CD = 'CLAIM';

-- 버려지는 수기 입력값이 있는지(0 이어야 한다)
SELECT '남은 수기자료' AS chk, COUNT(*) AS cnt FROM TBL_QPS_MANUAL WHERE INDI_CD = 'CLAIM';
