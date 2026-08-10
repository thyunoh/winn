-- ═══════════════════════════════════════════════════════════════════
--  QPS 환자만족도 조사 — 설문 응답 저장구조 (3단)
--  2026-08-10
--
--  ★이 폴더에서 「저장 단위가 다른」 유일한 서식이 설문지다.
--    다른 서식은 전부 「병원 1건」인데 설문지는 ***응답자 1인 = 1건***이라
--    한 조사에 수십~수백 건이 쌓인다. 그래서 3단으로 나눈다.
--
--      TBL_QPS_SURVEY      조사 회차   (병원·연도·차수)   1
--        └ TBL_QPS_SURVEY_ANS   응답     (응답자 1인)      N
--            └ TBL_QPS_SURVEY_ITEM  문항점수 (문항 1개)    N
--
--    조사결과 보고서(12면 중 9면)와 지표분석 보고서는 저장하는 게 아니라
--    ***이 3단을 조회 시점에 집계***해서 그린다.
--
--  ★산식 (원본 「지표분석 보고서(점수)」에서 확정)
--      점수합    = Σ( 인원 × 배점 )        배점 5,4,3,2,1
--      총점      = 응답수 × 5
--      백분율(%) = 점수합 / 총점 × 100
--      평균(점)  = 점수합 / 응답수
--    ⇒ 배점을 SCORE 에 그대로 저장하므로 SUM(SCORE) 하나로 점수합이 나온다.
--
--  ※ 재실행 안전
-- ═══════════════════════════════════════════════════════════════════

-- ── 0. 누락 코드 보충 : 설문 성별 ───────────────────────────────────
--    설문지 표기가 「□1. 남  □2. 여」라 번호를 그대로 코드로 쓴다.
INSERT INTO TBL_CODE_MST (CODE_CD, JOB_SEQ, CODE_NM, START_DT, END_DT, USE_YN, ACTION_YN, REG_USER) VALUES
 ('QPS_SRV_SEX',1,'만족도 설문 성별','20000101','99991231','Y','Y','system')
ON DUPLICATE KEY UPDATE CODE_NM=VALUES(CODE_NM), USE_YN='Y', ACTION_YN='Y';

INSERT INTO TBL_CODE_DTL (CODE_GB, CODE_CD, SUB_CODE, JOB_SEQ, SUB_CODE_NM, START_DT, END_DT, USE_YN, SORT, ACTION_YN, REG_USER) VALUES
 ('Q','QPS_SRV_SEX','1',1,'남','20000101','99991231','Y',1,'Y','system'),
 ('Q','QPS_SRV_SEX','2',1,'여','20000101','99991231','Y',2,'Y','system')
ON DUPLICATE KEY UPDATE SUB_CODE_NM=VALUES(SUB_CODE_NM), SORT=VALUES(SORT), USE_YN='Y', ACTION_YN='Y';


-- ── 1. 조사 회차 ────────────────────────────────────────────────────
--   조사개요(2p)는 회차의 속성이므로 여기 둔다. 계획서·결과보고서가 같이 참조한다.
CREATE TABLE IF NOT EXISTS TBL_QPS_SURVEY (
  SURVEY_ID   BIGINT       NOT NULL AUTO_INCREMENT,
  HOSP_CD     VARCHAR(20)  NOT NULL,
  IN_YEAR     CHAR(4)      NOT NULL COMMENT '조사년도',
  SEQ         INT          NOT NULL DEFAULT 1 COMMENT '연내 차수(연 1회면 1)',
  SURVEY_NM   VARCHAR(200) NULL COMMENT '조사명 (예: 입원환자 의료서비스 만족도)',
  -- 조사개요 (조사결과 보고서 2p)
  PURPOSE     TEXT         NULL COMMENT '조사의 목적',
  GOAL        TEXT         NULL COMMENT '조사의 목표',
  FR_DT       CHAR(8)      NULL COMMENT '조사기간 시작 YYYYMMDD',
  TO_DT       CHAR(8)      NULL COMMENT '조사기간 종료',
  TARGET      VARCHAR(300) NULL COMMENT '조사대상 및 인원',
  METHOD      VARCHAR(300) NULL COMMENT '조사방법',
  STAFF       VARCHAR(300) NULL COMMENT '조사요원',
  STAT_METHOD VARCHAR(300) NULL COMMENT '통계방법',
  USE_PLAN    TEXT         NULL COMMENT '조사의 활용 (3p)',
  CLOSE_YN    CHAR(1)      NOT NULL DEFAULT 'N' COMMENT '마감(마감 후 응답 입력 차단)',
  REG_USER    VARCHAR(40)  NULL,
  REG_DT      DATETIME     NULL DEFAULT CURRENT_TIMESTAMP,
  UPD_USER    VARCHAR(40)  NULL,
  UPD_DT      DATETIME     NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (SURVEY_ID),
  UNIQUE KEY UK_QPS_SURVEY (HOSP_CD, IN_YEAR, SEQ)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='만족도 조사 회차';


-- ── 2. 응답 (응답자 1인 = 1건) ──────────────────────────────────────
CREATE TABLE IF NOT EXISTS TBL_QPS_SURVEY_ANS (
  ANS_ID    BIGINT      NOT NULL AUTO_INCREMENT,
  SURVEY_ID BIGINT      NOT NULL,
  HOSP_CD   VARCHAR(20) NOT NULL COMMENT '조회 편의용 비정규화',
  ANS_NO    INT         NULL COMMENT '설문지 일련번호(수기 관리용, 선택)',
  WRITER_CD CHAR(1)     NULL COMMENT 'QPS_SRV_WRITER 1=환자본인 2=보호자',
  SEX_CD    CHAR(1)     NULL COMMENT 'QPS_SRV_SEX 1=남 2=여',
  AGE_CD    CHAR(1)     NULL COMMENT 'QPS_SRV_AGE 1=20대 … 6=70대이상',
  ETC_OPN   TEXT        NULL COMMENT '기타의견 및 건의사항',
  REG_USER  VARCHAR(40) NULL,
  REG_DT    DATETIME    NULL DEFAULT CURRENT_TIMESTAMP,
  UPD_DT    DATETIME    NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (ANS_ID),
  KEY IX_QPS_SRV_ANS (SURVEY_ID),
  KEY IX_QPS_SRV_ANS2 (HOSP_CD, SURVEY_ID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='만족도 설문 응답(1인 1건)';


-- ── 3. 문항별 점수 ──────────────────────────────────────────────────
--   ★SCORE 에 「배점」을 그대로 넣는다(5=매우만족 … 1=매우불만족).
--     보기 번호(1~5)를 넣으면 안 된다 — 원본의 표시번호와 배점은 역순이다.
CREATE TABLE IF NOT EXISTS TBL_QPS_SURVEY_ITEM (
  ANS_ID  BIGINT  NOT NULL,
  Q_SORT  INT     NOT NULL COMMENT 'TBL_QPS_SRV_DEF.SORT (문항 고유번호)',
  SCORE   TINYINT NULL     COMMENT '배점 5~1 (무응답이면 NULL)',
  PRIMARY KEY (ANS_ID, Q_SORT),
  KEY IX_QPS_SRV_ITEM (Q_SORT)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='만족도 설문 문항별 점수';


-- ═══ 집계 검증용 참고 쿼리 ═════════════════════════════════════════
--  ※ 화면/매퍼에서 쓸 집계의 원형. 여기서 검증하고 매퍼로 옮긴다.
--
--  [문항별 집계] — 조사결과·지표분석 보고서의 반복 블록
--   SELECT i.Q_SORT,
--          SUM(i.SCORE=5) N5, SUM(i.SCORE=4) N4, SUM(i.SCORE=3) N3,
--          SUM(i.SCORE=2) N2, SUM(i.SCORE=1) N1,
--          COUNT(i.SCORE)            CNT,        -- 응답수
--          SUM(i.SCORE)              SUM_SCORE,  -- 점수합
--          COUNT(i.SCORE)*5          TOT_SCORE,  -- 총점
--          ROUND(SUM(i.SCORE)/(COUNT(i.SCORE)*5)*100,1) PCT,  -- 백분율
--          ROUND(SUM(i.SCORE)/COUNT(i.SCORE),1)         AVG_P -- 평균(점)
--     FROM TBL_QPS_SURVEY_ITEM i
--     JOIN TBL_QPS_SURVEY_ANS  a ON a.ANS_ID = i.ANS_ID
--    WHERE a.SURVEY_ID = ?
--    GROUP BY i.Q_SORT;
--
--  [영역별 평균] — 지표분석 보고서 1p 요약표(환경및시설/친절성/서비스/의료만족)
--   위 결과를 TBL_QPS_SRV_DEF.AREA_CD 로 묶어 다시 평균.
--
--  [성별/연령 분포] — 조사결과 보고서 3~4p
--   SELECT SEX_CD, COUNT(*) FROM TBL_QPS_SURVEY_ANS WHERE SURVEY_ID=? GROUP BY SEX_CD;
--   SELECT AGE_CD, COUNT(*) FROM TBL_QPS_SURVEY_ANS WHERE SURVEY_ID=? GROUP BY AGE_CD;
--
--  ★응답 0건이면 원본은 NAN / 0.0 을 찍는다(서식마다 다름). 우리는 '-' 로 통일한다.
