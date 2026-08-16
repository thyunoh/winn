-- =====================================================================
-- QPS 지표 마스터 — 영역(AREA) 부여 (2026-08-09)
--   왜: 사이드바에 지표 18개를 평면으로 나열하면 화면을 다 먹고, 앞으로 붙을
--       지표정의서·분석보고서·서식이 들어갈 자리가 없다. 지표는 [지표 현황] 화면 하나로 모으고
--       그 안에서 **영역별로 묶어** 보여준다. 그 묶음 기준이 이 컬럼이다.
--   ★인증 정의서 양식의 '해당영역' 칸과 같은 개념(환자안전/질환/진료/관리)을 실제 지표 구성에 맞춰 5개로.
-- =====================================================================

ALTER TABLE TBL_QPS_INDI_MST
  ADD COLUMN AREA_NM VARCHAR(30) NULL COMMENT '지표 영역(화면 묶음)' AFTER INDI_NM,
  ADD COLUMN AREA_NO INT NULL     COMMENT '영역 정렬순서'            AFTER AREA_NM;

UPDATE TBL_QPS_INDI_MST SET AREA_NM='환자안전',      AREA_NO=1
 WHERE INDI_CD IN ('FALL','BEDSORE','PTSAFE','MEDICATION','ABUSE','SUICIDE','RESTRAINT');

UPDATE TBL_QPS_INDI_MST SET AREA_NM='감염관리',      AREA_NO=2
 WHERE INDI_CD IN ('HANDWASH','UTI','INFEXP');

UPDATE TBL_QPS_INDI_MST SET AREA_NM='인권·행동제한', AREA_NO=3
 WHERE INDI_CD IN ('ISOLATION','SECLUSION');

UPDATE TBL_QPS_INDI_MST SET AREA_NM='진료지원·서비스', AREA_NO=4
 WHERE INDI_CD IN ('TATIMG','TATLAB','HOMERET','CLAIM','SATISFY');

UPDATE TBL_QPS_INDI_MST SET AREA_NM='직원안전',      AREA_NO=5
 WHERE INDI_CD IN ('STAFFSAFE');

-- 확인 — 영역 미배정이 0 이어야 한다
-- SELECT AREA_NO, AREA_NM, COUNT(*) FROM TBL_QPS_INDI_MST GROUP BY AREA_NO, AREA_NM ORDER BY AREA_NO;
