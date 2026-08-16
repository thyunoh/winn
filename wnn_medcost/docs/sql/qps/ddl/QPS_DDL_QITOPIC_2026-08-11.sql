-- =====================================================================
-- QI 주제선정 기준표 + 우선순위 집계표 · 활동 자원지원 내역 — 2026-08-11
--
-- ── 1. 주제선정 기준표 / 우선순위 집계표 ─────────────────────────────
--   원본은 4개로 보이지만 ***실질 서식은 2종, 화면은 1개***다.
--     우선순위집계표(전년도)/(당해년도) · 주제선정기준표(전년도)/(당해년도)
--     → 전년도·당해년도는 **평가 시점(연도)** 일 뿐이다. 연도 셀렉트로 덮인다.
--       (이름으로 갈라 둔 것을 그대로 베끼면 화면이 4개가 된다 — 만족도 (원무)/(원무2) 와 같은 함정)
--
--   ★★결정적 발견 — 기준표에 「평가위원」이 **한 명**이다.
--     ⇒ ***평가위원 1명 = 기준표 1장.***
--       집계표 우측의 「번호」 칸들은 **평가위원별 총점**이고,
--       [생성] 버튼은 그 해 기준표를 전부 모아 주제별로 합산해 순위를 매기는 것이다.
--     ⇒ 집계표는 저장하지 않는다. **기준표에서 조회 시 계산한다.**
--
--   ★기준 6개가 우리 연간 활동계획서의 주제선정 섹션과 **정확히 같다**(각 10점, 총점 60점) :
--     병원미션정책과의 연관성 · 고객에게 미치는 영향 · 환자안전 관련성 ·
--     고위험 다빈도 문제가능 · 개선활동 용이성 · 국내·외 평가지표
--     ⇒ 화면은 감염 우선순위 사정 도구와 같은 **[기준표] + [집계표] 두 탭**으로 간다.
--
-- ── 2. 활동 자원지원 내역 ───────────────────────────────────────────
--   연 1부. 표 = 활동 | 총지원비 | 세부항목 | 금액. ***활동 하나에 세부항목 여러 줄***(세로 병합).
--   총지원비는 세부항목 합 — 저장하되 화면이 자동 계산한다(연간계획서 예산안과 같은 방식).
--   3면 「영수증 1~4」는 **공통 첨부**로 대체한다(REF_GB='QIFUND').
--
--   재실행 안전(CREATE TABLE IF NOT EXISTS).
-- =====================================================================

-- ── 주제선정 기준표 : 평가위원 1명당 1장 ────────────────────────────
CREATE TABLE IF NOT EXISTS TBL_QPS_QITOPIC (
  QIT_SEQ   BIGINT       NOT NULL AUTO_INCREMENT,
  HOSP_CD   VARCHAR(20)  NOT NULL,
  IN_YEAR   CHAR(4)      NOT NULL COMMENT '평가 연도 — 원본의 (전년도)/(당해년도)가 이것이다',
  EVAL_DT   VARCHAR(8)   NULL COMMENT '평가일시',
  EVALUATOR VARCHAR(60)  NOT NULL DEFAULT '' COMMENT '평가위원 (★1명 = 1장)',
  USE_YN    CHAR(1)      NOT NULL DEFAULT 'Y',
  REG_USER  VARCHAR(50)  NULL,
  REG_DTTM  DATETIME     NULL DEFAULT CURRENT_TIMESTAMP,
  UPD_USER  VARCHAR(50)  NULL,
  UPD_DTTM  DATETIME     NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (QIT_SEQ),
  KEY IX_QPS_QITOPIC (HOSP_CD, IN_YEAR, USE_YN)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='QI 주제선정 기준표(평가위원별)';

-- 주제 행 × 6기준 점수. ★S1~S6 은 연간 활동계획서 TOPIC 섹션과 같은 순서다.
CREATE TABLE IF NOT EXISTS TBL_QPS_QITOPIC_ITEM (
  QIT_SEQ  BIGINT       NOT NULL,
  SORT     INT          NOT NULL COMMENT '번호(1~10)',
  DEPT_NM  VARCHAR(60)  NULL COMMENT '부서',
  TOPIC_NM VARCHAR(300) NULL COMMENT '주제',
  S1 INT NULL COMMENT '병원미션정책과의 연관성 (10점)',
  S2 INT NULL COMMENT '고객에게 미치는 영향 (10점)',
  S3 INT NULL COMMENT '환자안전 관련성 (10점)',
  S4 INT NULL COMMENT '고위험 다빈도 문제가능 (10점)',
  S5 INT NULL COMMENT '개선활동 용이성 (10점)',
  S6 INT NULL COMMENT '국내·외 평가지표 (10점)',
  -- 총점은 S1~S6 합이지만 저장한다 — 집계표가 SQL 합산으로 끝나고, 그때 기준의 스냅샷이 된다
  -- (감염 우선순위 사정 도구에서 위험점수를 저장한 것과 같은 판단)
  TOT_SCORE INT NULL COMMENT '총점 (60점 만점)',
  PRIMARY KEY (QIT_SEQ, SORT)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='QI 주제선정 기준표 — 주제별 점수';


-- ── 활동 자원지원 내역 : 연 1부 ─────────────────────────────────────
CREATE TABLE IF NOT EXISTS TBL_QPS_QIFUND (
  QIF_SEQ  BIGINT      NOT NULL AUTO_INCREMENT,
  HOSP_CD  VARCHAR(20) NOT NULL,
  IN_YEAR  CHAR(4)     NOT NULL,
  TOT_AMT  BIGINT      NULL COMMENT '총지원비 합계(만원) — 세부항목 합. 화면이 자동 계산한다',
  USE_YN   CHAR(1)     NOT NULL DEFAULT 'Y',
  REG_USER VARCHAR(50) NULL,
  REG_DTTM DATETIME    NULL DEFAULT CURRENT_TIMESTAMP,
  UPD_USER VARCHAR(50) NULL,
  UPD_DTTM DATETIME    NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (QIF_SEQ),
  UNIQUE KEY UK_QPS_QIFUND (HOSP_CD, IN_YEAR)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='QI 활동 자원지원 내역(연 1부)';

-- 활동 1개 : 세부항목 N개 (원본은 활동 칸이 세로 병합된 2단 표)
--   ACT_NO 로 활동을 묶는다 — 같은 ACT_NO 끼리 인쇄에서 rowspan 으로 합쳐진다.
CREATE TABLE IF NOT EXISTS TBL_QPS_QIFUND_ITEM (
  QIF_SEQ  BIGINT       NOT NULL,
  SORT     INT          NOT NULL,
  ACT_NO   INT          NOT NULL DEFAULT 1 COMMENT '활동 묶음 번호(같은 값 = 같은 활동)',
  ACT_NM   VARCHAR(200) NULL COMMENT '활동 (묶음의 첫 줄에만 적는다)',
  DETAIL_NM VARCHAR(300) NULL COMMENT '세부항목',
  AMT      BIGINT       NULL COMMENT '금액(만원)',
  PRIMARY KEY (QIF_SEQ, SORT)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='QI 활동 자원지원 내역 — 활동·세부항목';
