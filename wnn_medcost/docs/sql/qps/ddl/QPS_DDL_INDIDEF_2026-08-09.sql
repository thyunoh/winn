-- =====================================================================
-- QPS 지표정의서 — 마스터에 양식 항목 보강 (2026-08-09)
--
--   ★근거: 정의서 실물 캡처(산식채록 §0.1). 정의서는 산식이 인쇄된 문서가 아니라
--     **병원이 채우는 빈 양식**이다 — 해당영역·주관부서·담당자·선정배경·지표명·지표정의·
--     분자/분모(+상수)·포함기준·제외기준·목표값·이전값·목표값근거·자료출처·자료분석·
--     산출주기·보고주기·보고범위·성과공유·비고·결재.
--     우리 마스터가 그 양식의 그릇이므로, 아직 없던 칸만 추가한다.
--
--   ★병원별 덮어쓰기 구조는 그대로다 — HOSP_CD='*' 가 공통 기본값이고,
--     병원이 편집하면 **그 병원 행이 새로 생겨** 공통값을 덮는다(다른 병원에 영향 없음).
-- =====================================================================

ALTER TABLE TBL_QPS_INDI_MST
  ADD COLUMN DEPT_NM     VARCHAR(50)   NULL COMMENT '주관부서'        AFTER OWNER_NM,
  ADD COLUMN BACKGROUND  VARCHAR(1000) NULL COMMENT '선정배경'        AFTER DEPT_NM,
  ADD COLUMN INCLUDE_TXT VARCHAR(1000) NULL COMMENT '포함기준'        AFTER BACKGROUND,
  ADD COLUMN EXCLUDE_TXT VARCHAR(1000) NULL COMMENT '제외기준'        AFTER INCLUDE_TXT,
  ADD COLUMN PREV_VAL    DECIMAL(10,3) NULL COMMENT '이전값'          AFTER TARGET_VAL,
  ADD COLUMN TARGET_BASE VARCHAR(100)  NULL COMMENT '목표값 근거'     AFTER PREV_VAL,
  ADD COLUMN RPT_CYCLE   VARCHAR(20)   NULL COMMENT '보고주기'        AFTER TARGET_BASE,
  ADD COLUMN RPT_SCOPE   VARCHAR(100)  NULL COMMENT '보고범위'        AFTER RPT_CYCLE,
  ADD COLUMN SHARE_TXT   VARCHAR(300)  NULL COMMENT '성과공유 대상·방법' AFTER RPT_SCOPE,
  ADD COLUMN NOTE        VARCHAR(1000) NULL COMMENT '비고'            AFTER SHARE_TXT;

-- 공통 기본값 — 병원이 지우고 자기 것으로 채울 수 있는 '출발점'만 넣는다.
UPDATE TBL_QPS_INDI_MST
   SET RPT_CYCLE = CASE CYCLE_GB WHEN 'Q' THEN '분기' WHEN 'H' THEN '반기' WHEN 'Y' THEN '연' ELSE '분기' END,
       RPT_SCOPE = 'QPS위원회',
       DEPT_NM   = CASE
                     WHEN AREA_NM = '감염관리' THEN '감염관리실'
                     WHEN AREA_NM = '직원안전' THEN '안전보건팀'
                     ELSE 'QPS팀'
                   END
 WHERE HOSP_CD = '*';

-- 확인
-- SELECT INDI_CD, DEPT_NM, RPT_CYCLE, RPT_SCOPE FROM TBL_QPS_INDI_MST WHERE HOSP_CD='*' ORDER BY SORT_NO;
