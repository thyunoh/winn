-- =====================================================================
-- 점검표 결재 권한 — 부서 × 단계 × 사람 (2026-09-08)
--   왜 : 사용자 「결재는 **권한 관리**로 — 서식별 해당 권한 있는 내용 보여주고 결재하게」.
--        지금은 로그인한 사람이면 **빈 단계 아무 데나** 찍을 수 있다. 종이 결재란은 그렇지 않다.
--   ★단위 = **부서**(사용자 확정). 서식이 300종이라 서식마다 4단계를 사람이 채울 수 없다 —
--     서식은 제 부서(TBL_QPS_CHK_FORM.DEPT_CD)의 지정을 따른다.
--     ⇒ 「방사선 : 담당=김기사 · 팀장=박실장 · 원장=원장님」 한 번이면 그 부서 서식 전부가 정해진다.
--   ★**서식별 예외**도 같은 표로 푼다 — FORM_ID 를 적은 줄이 있으면 그 서식은 그 줄이 이긴다.
--     (부서 줄은 FORM_ID='*'. 두 줄이 다 있으면 서식 줄 우선 — 조회에서 정렬로 가른다.)
--   ★한 단계에 **여러 사람**을 넣을 수 있다(대리·교대). PK 에 USER_ID 가 들어간다.
--   ⚠**지정이 하나도 없으면 종전처럼 누구나** 찍을 수 있다 — 도입하는 날 결재가 멈추면 안 된다.
--     `qpsUserDept`(사용자별 담당 부서)에서 얻은 원칙과 같다 : **막는 장치가 아니라 좁혀 주는 장치.**
--   더하기만 하는 DDL ⇒ 운영 선적용 안전(옛 WAR 는 이 표를 읽지 않는다).
--   ⛔자바·매퍼가 함께 바뀐다 → **WAR 재빌드 + 재기동**.
-- =====================================================================

CREATE TABLE IF NOT EXISTS TBL_QPS_APPR_AUTH (
  HOSP_CD   VARCHAR(20) NOT NULL                COMMENT '병원코드',
  DEPT_CD   VARCHAR(20) NOT NULL                COMMENT 'QPS 부서 코드(TBL_QPS_CHK_FORM.DEPT_CD)',
  FORM_ID   VARCHAR(30) NOT NULL DEFAULT '*'    COMMENT '서식별 예외. * = 그 부서 전체',
  STEP_NO   INT         NOT NULL                COMMENT '결재 단계(TBL_QPS_APPR_LINE.STEP_NO)',
  USER_ID   VARCHAR(50) NOT NULL                COMMENT '그 단계를 결재할 수 있는 사람',
  USER_NM   VARCHAR(100) NULL                   COMMENT '등록 당시 이름(화면 표시용)',
  USE_YN    CHAR(1)     NOT NULL DEFAULT 'Y'    COMMENT '내림 = N',
  REG_USER  VARCHAR(50) NULL,
  REG_DTTM  DATETIME    NULL DEFAULT CURRENT_TIMESTAMP,
  UPD_USER  VARCHAR(50) NULL,
  UPD_DTTM  DATETIME    NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (HOSP_CD, DEPT_CD, FORM_ID, STEP_NO, USER_ID),
  KEY IX_QPS_APPR_AUTH_DEPT (HOSP_CD, DEPT_CD, FORM_ID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='QPS 결재 권한 (부서×단계×사람, 서식 예외 가능)';

-- ── 확인 ──────────────────────────────────────────────────────────────
-- SELECT DEPT_CD, FORM_ID, STEP_NO, USER_ID, USER_NM FROM TBL_QPS_APPR_AUTH ORDER BY DEPT_CD, FORM_ID, STEP_NO;
