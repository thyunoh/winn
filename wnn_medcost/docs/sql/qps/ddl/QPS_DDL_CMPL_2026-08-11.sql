-- =====================================================================
-- 불만고충 폴더 (2026-08-11) — 처리대장 · 건별 처리결과 · 지표분석보고서
--
--   원본 구성 : 처리계획서 · 처리대장 → 지표분석보고서 → 개선활동 처리결과서
--
--   ★계획서는 여기 없다.
--     연간 활동계획서가 쓰는 TBL_QPS_PLAN 의 FORM_GB 에 'C'(불만고충)를 얹어 해결했다
--     (Q=질향상 / I=감염관리 / S=만족도 / C=불만고충). 항목표가 SECT_CD 로 갈리는
--     범용 표라 팀구성·간트·개요가 전부 들어간다 — 새 표가 필요 없다.
--
--   ★이 폴더의 급소는 처리대장이다.
--     지표분석보고서의 모든 수치(월별·유형별·접수유형·처리기간·회신방법·미회신사유)가
--     ***대장 한 곳에서 집계***된다. 그래서 대장의 유형·접수유형·회신방법·미회신사유는
--     자유입력이 아니라 코드값이어야 한다 — 공통코드 6군은 2026-08-10 에 이미 적재됐다
--     (QPS_CMPL_TYPE/RECV/REPLY/NOREPLY/TERM/PERSON, docs/sql/qps/seed/QPS_CODE_CMPL_SRV_2026-08-10.sql).
--
--   재실행 안전(CREATE TABLE IF NOT EXISTS).
-- =====================================================================


-- ── 1. 처리대장 (건별) ──────────────────────────────────────────────
--   원본 컬럼 12개를 그대로 담는다 :
--     번호·접수월·접수일·접수유형·민원인·처리기간·불만고충유형·불만고충내용·
--     처리결과·회신날짜·회신방법·미회신사유
CREATE TABLE IF NOT EXISTS TBL_QPS_CMPL (
  CMPL_SEQ   BIGINT      NOT NULL AUTO_INCREMENT,
  HOSP_CD    VARCHAR(20) NOT NULL COMMENT '병원코드',
  IN_YEAR    CHAR(4)     NOT NULL COMMENT '연도 (대장은 연 단위)',
  -- ★원본은 접수「월」과 접수「일」이 따로 있다. 월이 보고서 모든 월별 집계의 축이라 컬럼으로 둔다.
  --   우리 화면은 접수일을 넣으면 월을 자동으로 채운다(비었을 때만) — 둘이 어긋나지 않게.
  RECV_MM    CHAR(2)     NULL COMMENT '접수월 01~12 (월별 집계 축)',
  RECV_DT    VARCHAR(8)  NULL COMMENT '접수일 YYYYMMDD',
  RECV_CD    VARCHAR(10) NULL COMMENT '접수유형 QPS_CMPL_RECV',
  PERSON_NM  VARCHAR(60) NULL COMMENT '민원인 성명',
  PERSON_CD  VARCHAR(10) NULL COMMENT '민원인 구분 QPS_CMPL_PERSON (원본 대장엔 없으나 처리결과서에 있어 여기서 받는다)',
  TERM_DAYS  INT         NULL COMMENT '처리기간(일). ★보고서에서 1~3 / 4~7 / 7일 이후 구간으로 묶인다',
  TYPE_CD    VARCHAR(10) NULL COMMENT '불만고충유형 QPS_CMPL_TYPE',
  CONTENT    TEXT        NULL COMMENT '불만고충내용',
  RESULT_TXT TEXT        NULL COMMENT '처리결과',
  -- ★회신날짜가 비면 미회신사유를 받는다. 이 대장의 관리 포인트이자 처리율의 분자다.
  REPLY_DT   VARCHAR(8)  NULL COMMENT '회신날짜 YYYYMMDD (있으면 = 처리 완료)',
  REPLY_CD   VARCHAR(10) NULL COMMENT '회신방법 QPS_CMPL_REPLY',
  NOREPLY_CD VARCHAR(10) NULL COMMENT '미회신사유 QPS_CMPL_NOREPLY',
  USE_YN     CHAR(1)     NOT NULL DEFAULT 'Y',
  REG_USER   VARCHAR(50) NULL,
  REG_DTTM   DATETIME    NULL DEFAULT CURRENT_TIMESTAMP,
  UPD_USER   VARCHAR(50) NULL,
  UPD_DTTM   DATETIME    NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (CMPL_SEQ),
  KEY IX_QPS_CMPL  (HOSP_CD, IN_YEAR, USE_YN),
  KEY IX_QPS_CMPL2 (HOSP_CD, IN_YEAR, RECV_MM)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='불만고충 처리대장(건별)';


-- ── 2. 개선활동 처리결과 보고서 (대장 1건의 상세, 1:1) ──────────────
--   원본은 좌측에 「1~14」 라디오를 두고 한 화면에서 건을 넘겨 본다.
--   ***14 는 종이의 물리적 한계일 뿐 의미 있는 수가 아니다 — 건수 제한을 두지 않는다.***
--   우리는 대장을 목록으로, 이 표를 그 건의 상세로 쓴다(대장 행을 고르면 열린다).
--
--   ★접수방법·민원인·불만고충내용·고객통보(회신방법)는 ***대장에 이미 있다.***
--     여기에 또 두면 같은 것을 두 번 입력하게 된다 — 두지 않는다.
CREATE TABLE IF NOT EXISTS TBL_QPS_CMPL_ACT (
  CMPL_SEQ  BIGINT       NOT NULL COMMENT '대장 건 (1:1)',
  RPT_DT    VARCHAR(8)   NULL COMMENT '보고날짜',
  DEPT_NM   VARCHAR(60)  NULL COMMENT '부서명',
  IMPR_DT   VARCHAR(8)   NULL COMMENT '개선날짜',
  PLACE     VARCHAR(200) NULL COMMENT '민원발생장소',
  PROBLEM   TEXT         NULL COMMENT '문제진술',
  ANALYSIS  TEXT         NULL COMMENT '현상파악 및 원인분석',
  PLAN_TXT  TEXT         NULL COMMENT '개선 대책안',
  -- 개선방안 적용·Action·개선지속 표 — 줄당 "유형|불만고충 문제점|개선활동"
  -- (만족도 보고서의 개선사항 칸과 같은 방식. 표 하나를 위해 자식 테이블을 또 만들지 않는다)
  ACT_TXT   TEXT         NULL COMMENT '개선활동 표(줄당 유형|문제점|개선활동)',
  CAUSE     TEXT         NULL COMMENT '원인',
  ANSWER    TEXT         NULL COMMENT '조치 및 답변',
  PREVENT   TEXT         NULL COMMENT '재발방지대책',
  REG_USER  VARCHAR(50)  NULL,
  REG_DTTM  DATETIME     NULL DEFAULT CURRENT_TIMESTAMP,
  UPD_USER  VARCHAR(50)  NULL,
  UPD_DTTM  DATETIME     NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (CMPL_SEQ)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='불만고충 개선활동 처리결과(대장 건별 상세)';


-- ── 3. 지표분석보고서 — 사람이 쓰는 칸만 ────────────────────────────
--   ★원본 3종(무제·전반기·후반기)은 <한 화면 + 반기 구분>으로 전부 덮인다.
--     기본형(무제)은 구버전이다 — 번호 오타(1,2,2,4,5)에 코드값도 옛것이라
--     ***전반기형을 정본으로 삼는다***(2026-08-10 판단).
--   ★수치(월별·유형별·접수유형·처리기간·회신방법·미회신사유)는 여기 저장하지 않는다.
--     ***전부 처리대장에서 조회 시 집계한다*** — 만족도 보고서와 같은 원칙.
--   ★지표정의·목표·모니터링은 지표정의서(TBL_QPS_INDI_MST, INDI_CD='CLAIM')를 재사용한다.
CREATE TABLE IF NOT EXISTS TBL_QPS_CMPL_RPT (
  RPT_SEQ      BIGINT      NOT NULL AUTO_INCREMENT,
  HOSP_CD      VARCHAR(20) NOT NULL,
  IN_YEAR      CHAR(4)     NOT NULL,
  HALF_GB      CHAR(1)     NOT NULL COMMENT '반기 1=전반기(1~6월) 2=후반기(7~12월)',
  SUBMIT_DT    VARCHAR(8)  NULL COMMENT '제출일',
  GOAL_VAL     VARCHAR(30) NULL COMMENT '목표 (불만 및 고충처리 처리율 __%)',
  STRATEGY_TXT TEXT        NULL COMMENT '개선 전략 및 실행',
  CONCL_TXT    TEXT        NULL COMMENT '결론 및 제언',
  IMPR_TXT     TEXT        NULL COMMENT '개선활동 표(줄당 유형|문제점|개선활동) — 원본 4p, 사진 컬럼 없음',
  USE_YN       CHAR(1)     NOT NULL DEFAULT 'Y',
  REG_USER     VARCHAR(50) NULL,
  REG_DTTM     DATETIME    NULL DEFAULT CURRENT_TIMESTAMP,
  UPD_USER     VARCHAR(50) NULL,
  UPD_DTTM     DATETIME    NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (RPT_SEQ),
  UNIQUE KEY UK_QPS_CMPL_RPT (HOSP_CD, IN_YEAR, HALF_GB)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='불만고충 지표분석보고서(서술칸)';


-- ═══ 집계 검증용 참고 쿼리 ═══════════════════════════════════════════
--  ※ 보고서가 쓰는 집계의 원형. 전부 대장 한 곳에서 나온다.
--
--  [월별] 고충건수 / 처리건수 / 처리율   ← 1p [지표분석] (1)반기 표
--   SELECT RECV_MM, COUNT(*) AS TOT, SUM(REPLY_DT IS NOT NULL AND REPLY_DT<>'') AS DONE
--     FROM TBL_QPS_CMPL WHERE HOSP_CD=? AND IN_YEAR=? AND USE_YN='Y'
--      AND RECV_MM BETWEEN ? AND ? GROUP BY RECV_MM;
--
--  [유형별]        GROUP BY TYPE_CD            ← 2p 2)
--  [월 × 유형]     GROUP BY RECV_MM, TYPE_CD   ← 2p 교차표
--  [접수유형]      GROUP BY RECV_CD            ← 2p 4)
--  [회신방법]      GROUP BY REPLY_CD           ← 3p 6)
--  [미회신 사유]   GROUP BY NOREPLY_CD (회신날짜 없는 건만) ← 3p 7)
--  [처리기간 구간] TERM_DAYS 를 1~3 / 4~7 / 7일 초과로 묶는다 ← 2p 5)
--
--  ★처리 = 회신날짜가 있는 건. 처리율 = 처리건수 / 고충건수 × 100.
--  ★응답 0건이면 '-' 로 표시한다(만족도와 같은 규칙 — 원본의 NAN/0.0 혼용을 따르지 않는다).
