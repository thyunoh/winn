-- =====================================================================
-- MIS(경영관리) 1단계 — 경영통계 · 고정경비 관리 — DDL (2026-10-08)
--   왜 : 신규 요양병원 업무 패키지(docs/proposals/신규요양병원_업무패키지_제안_2026-10-08.html) 1단계.
--        경영통계는 이미 올라오는 자료(청구 샘파일·입퇴원현황·환자평가표)로 산출하므로 표가 필요 없다.
--        병원이 새로 적는 것만 표로 둔다 : ①병원 설정(병상 수·변동비) ②고정비 항목 ③월별 금액.
--   원칙 :
--     · 금액은 **원 단위 정수**(BIGINT). 화면이 억·만으로 바꿔 보여 준다 — 소수 저장은 합계가 어긋난다.
--     · 항목(TBL_MIS_COST_CAT)은 공통('*') 한 벌 + 병원 추가분. 공통 항목은 병원이 못 지우고 끄기(USE_YN)만 한다.
--       (QPS 서식의 「공통 '*' + 병원 전용」 규칙과 같다.)
--     · 월 금액은 (병원·연월·항목) 한 줄. 없는 달은 화면이 **직전 달 값을 보여 주되 저장하지 않는다** — 「처음 1회 등록, 바뀐 것만」.
--   더하기만 하는 DDL ⇒ 운영 선적용 안전(옛 WAR 는 이 표들을 읽지 않는다).
--   코드 : Mis_SQL.xml · MisMapper/Service(Impl)/Controller · misStat.jsp(경영통계) · misCost.jsp(고정경비)
--   ⛔자바·매퍼가 함께 생긴다 → **WAR 재빌드 + 재기동**.
-- =====================================================================

-- ── ① 병원 설정 — 병원마다 한 줄 ────────────────────────────────────────
CREATE TABLE IF NOT EXISTS TBL_MIS_CFG (
  HOSP_CD       VARCHAR(10)  NOT NULL COMMENT '요양기관기호',
  BED_CNT       INT          NULL     COMMENT '허가 병상 수 (가동률 계산)',
  VAR_COST_DAY  INT          NULL     COMMENT '환자 1인 1일 변동비(원) — 식재료·소모품 등. 비면 기본값 25,000',
  NOTE          VARCHAR(200) NULL     COMMENT '비고',
  REG_DTTM      DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  REG_USER      VARCHAR(50)  NULL,
  UPD_DTTM      DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UPD_USER      VARCHAR(50)  NULL,
  PRIMARY KEY (HOSP_CD)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='MIS 병원 설정(병상 수·변동비)';

-- ── ② 비용·수익 항목 — 공통('*') + 병원 추가 ─────────────────────────────
CREATE TABLE IF NOT EXISTS TBL_MIS_COST_CAT (
  HOSP_CD   VARCHAR(10)  NOT NULL COMMENT '''*'' = 공통, 그 밖은 병원 전용',
  CAT_CD    VARCHAR(20)  NOT NULL COMMENT '항목 코드',
  CAT_NM    VARCHAR(60)  NOT NULL COMMENT '항목 이름',
  CAT_GB    CHAR(1)      NOT NULL DEFAULT 'C' COMMENT 'C=고정비 · R=추가수익(비급여 등, 샘파일에 없는 수익)',
  SORT_NO   INT          NOT NULL DEFAULT 0,
  USE_YN    CHAR(1)      NOT NULL DEFAULT 'Y',
  REG_DTTM  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  REG_USER  VARCHAR(50)  NULL,
  UPD_DTTM  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UPD_USER  VARCHAR(50)  NULL,
  PRIMARY KEY (HOSP_CD, CAT_CD)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='MIS 비용·수익 항목';

-- 공통 항목 씨앗 — 제안서 ② 고정경비 화면의 5항목 + 기타 + 추가수익 1
INSERT IGNORE INTO TBL_MIS_COST_CAT (HOSP_CD, CAT_CD, CAT_NM, CAT_GB, SORT_NO, REG_USER) VALUES
 ('*', 'LABOR',  '인건비 (의사·간호·간병·행정)',  'C', 10, 'seed'),
 ('*', 'RENT',   '임대료·관리비',               'C', 20, 'seed'),
 ('*', 'OUTS',   '급식·세탁·청소 위탁',          'C', 30, 'seed'),
 ('*', 'UTIL',   '공과금 (전기·가스·수도)',      'C', 40, 'seed'),
 ('*', 'INSL',   '보험·장비 리스·소모품',        'C', 50, 'seed'),
 ('*', 'ETC',    '기타 고정비',                 'C', 90, 'seed'),
 ('*', 'NONCOV', '비급여 수익 (월 합계)',        'R', 10, 'seed');

-- ── ③ 월별 금액 — (병원·연월·항목) 한 줄 ─────────────────────────────────
CREATE TABLE IF NOT EXISTS TBL_MIS_COST (
  HOSP_CD   VARCHAR(10)  NOT NULL,
  YYYYMM    CHAR(6)      NOT NULL COMMENT '연월',
  CAT_CD    VARCHAR(20)  NOT NULL COMMENT 'TBL_MIS_COST_CAT.CAT_CD (공통·병원 어느 쪽이든)',
  AMT       BIGINT       NOT NULL DEFAULT 0 COMMENT '금액(원)',
  MEMO      VARCHAR(200) NULL,
  REG_DTTM  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  REG_USER  VARCHAR(50)  NULL,
  UPD_DTTM  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UPD_USER  VARCHAR(50)  NULL,
  PRIMARY KEY (HOSP_CD, YYYYMM, CAT_CD),
  KEY IX_MIS_COST_YM (HOSP_CD, YYYYMM)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='MIS 월별 고정비·추가수익';

-- 확인
-- SELECT * FROM TBL_MIS_COST_CAT ORDER BY HOSP_CD, CAT_GB, SORT_NO;
