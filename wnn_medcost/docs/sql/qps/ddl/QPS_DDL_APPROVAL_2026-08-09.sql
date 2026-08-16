-- =====================================================================
-- QPS 결재선 (2026-08-09)
--   인증 심사에 실제로 제출하려면 지표분석보고서에 결재가 찍혀 있어야 한다.
--   이전 시스템은 담당·팀장·부서장·이사장 4단계였다.
--
--   ★설계 원칙(2026-08-09 확정): **단계 수를 코드에 박지 않는다.**
--     병원마다 조직이 다르고 "2단계로 줄여 달라"가 언제든 나온다. 결재선을 데이터로 두면
--     그때 행만 지우면 되고 코드는 안 고친다. HOSP_CD='*' 가 공통 기본(4단계)이고,
--     병원 행이 있으면 그 병원은 자기 결재선을 쓴다(지표 마스터와 같은 방식).
--
--   ★권한에 대하여(솔직히): 지금 시스템에는 병원 내 직위·역할 정보가 없다(로그인 = s_userid 뿐).
--     그래서 v1 은 **'누가 언제 결재했는지를 남기는 전자서명'** 이다 — 종이 결재를 그대로 옮긴 것.
--     결재자 지정·대결·알림은 사용자 마스터에 직위가 생긴 뒤에 붙인다.
-- =====================================================================

-- ① 결재선 설정 — 병원별 단계 정의
CREATE TABLE IF NOT EXISTS TBL_QPS_APPR_LINE (
  LINE_SEQ  BIGINT      NOT NULL AUTO_INCREMENT,
  HOSP_CD   VARCHAR(20) NOT NULL,                  -- '*' = 공통 기본
  STEP_NO   INT         NOT NULL,                  -- 1,2,3,4 …
  STEP_NM   VARCHAR(30) NOT NULL,                  -- 담당 / 팀장 / 부서장 / 이사장
  USE_YN    CHAR(1)     NOT NULL DEFAULT 'Y',
  REG_USER  VARCHAR(50) NULL,
  REG_DTTM  DATETIME    NULL DEFAULT CURRENT_TIMESTAMP,
  UPD_USER  VARCHAR(50) NULL,
  UPD_DTTM  DATETIME    NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (LINE_SEQ),
  UNIQUE KEY UK_QPS_APPR_LINE (HOSP_CD, STEP_NO)
);

-- ② 결재 이력 — 문서(지표·기간) 단위로 누가 무엇을 했는지
CREATE TABLE IF NOT EXISTS TBL_QPS_APPR (
  APPR_SEQ  BIGINT      NOT NULL AUTO_INCREMENT,
  HOSP_CD   VARCHAR(20) NOT NULL,
  INDI_CD   VARCHAR(20) NOT NULL,
  PRD_GB    VARCHAR(10) NOT NULL,                  -- Q/H/Y
  PRD_KEY   VARCHAR(10) NOT NULL,                  -- 2026Q1 …
  STEP_NO   INT         NULL,                      -- 승인·반려한 단계(상신은 0)
  STEP_NM   VARCHAR(30) NULL,
  ACT_GB    VARCHAR(10) NOT NULL,                  -- SUBMIT/APPROVE/REJECT/CANCEL
  ACT_USER  VARCHAR(50) NULL,
  ACT_NM    VARCHAR(50) NULL,
  ACT_DTTM  DATETIME    NULL DEFAULT CURRENT_TIMESTAMP,
  NOTE      VARCHAR(500) NULL,                     -- 반려 사유 등
  USE_YN    CHAR(1)     NOT NULL DEFAULT 'Y',
  PRIMARY KEY (APPR_SEQ),
  KEY IX_QPS_APPR (HOSP_CD, INDI_CD, PRD_GB, PRD_KEY, APPR_SEQ)
);

-- ③ 보고서에 현재 결재 단계 — 어디까지 승인됐는지
ALTER TABLE TBL_QPS_REPORT
  ADD COLUMN CUR_STEP INT NOT NULL DEFAULT 0 COMMENT '승인 완료된 마지막 단계(0=결재 전)' AFTER STATUS;

-- 공통 기본 결재선 = 4단계(이전 시스템과 동일). 병원이 줄이면 그 병원 행을 따로 넣는다.
INSERT INTO TBL_QPS_APPR_LINE (HOSP_CD, STEP_NO, STEP_NM, USE_YN, REG_USER) VALUES
 ('*', 1, '담당',   'Y', 'system'),
 ('*', 2, '팀장',   'Y', 'system'),
 ('*', 3, '부서장', 'Y', 'system'),
 ('*', 4, '이사장', 'Y', 'system')
ON DUPLICATE KEY UPDATE STEP_NM=VALUES(STEP_NM), USE_YN='Y';

-- 확인
-- SELECT * FROM TBL_QPS_APPR_LINE ORDER BY HOSP_CD, STEP_NO;
