-- ═══════════════════════════════════════════════════════════════════════════
-- safeRpt 확장 — 반복행 표 · 서명란 · 정형문구 (2026-08-14)
--   설계 : docs/proposals/QPS_safeRpt_반복행서명_설계_2026-08-14.md
--
--   왜 : 시설 판정 §4★★ 와 간호/병동 판독 §373 이 「사고·고장 보고 계열을 safeRpt 에
--        유형 추가로 흡수하라」고 남겼다. 항목표 구조를 확인해 보니 전제는 맞았고,
--        ***엔진에 없는 것이 3가지***였다 — 반복행 표 · 하단 서명란 · 정형문구.
--        그 중 **저장이 필요한 것은 반복행 표뿐**이다(나머지 둘은 인쇄 전용 —
--        점검표 엔진 qpsChk.jsp:1353-1357 이 이미 그렇게 찍는다).
--
--   ★이름은 점검표 엔진(TBL_QPS_CHK_FORM)의 것을 그대로 가져왔다 —
--     SUB_NM · SUB_COLS · SIGN_LINE · FOOT_TXT. 두 엔진이 같은 것을 다른 이름으로
--     부르면 다음 사람이 반드시 헷갈린다.
--
--   ⚠**더하기만 하는 DDL** — 새 표 2개뿐이고 기존 표는 건드리지 않는다.
--     옛 코드는 이 표들을 읽지도 쓰지도 않으므로 **운영 선적용 안전**(08-12·08-13 과 같은 판단).
--   ⚠기존 시드(QPS_DDL_SAFERPT_2026-08-11.sql 등)는 ***절대 다시 돌리지 말 것*** —
--     병원이 고친 항목표가 되돌아간다.
--
--   재실행 안전 (CREATE TABLE IF NOT EXISTS).
-- ═══════════════════════════════════════════════════════════════════════════

-- ── 1. 유형별 설정 ──────────────────────────────────────────────────────────
--   행이 없으면 지금과 똑같이 동작한다(전부 null = 표도 서명도 문구도 없음).
--   ★그래서 기존 9유형은 넣지 않는다 — 전부 null 인 행은 표만 지저분하게 한다.
--     필요한 유형이 생길 때 그 유형만 INSERT 한다.
--   ★HOSP_CD 를 두지 않는다 — 형제 표(_DEF·_USE)가 전부 병원 구분이 없다.
--     safeRpt 안에서 일관되게 간다(점검표 엔진의 HOSP_CD='*' 는 그쪽 관례).
CREATE TABLE IF NOT EXISTS TBL_QPS_SAFERPT_FORM (
  RPT_GB    VARCHAR(20)  NOT NULL COMMENT '유형 QPS_SAFERPT_GB',
  SUB_NM    VARCHAR(60)  NULL COMMENT "반복행 표의 왼쪽 이름 칸(예 '반납 품목'). 비면 이름 칸 없음",
  SUB_COLS  VARCHAR(300) NULL COMMENT '반복행 표의 열 이름들(쉼표). ★값이 있어야 표를 그린다',
  SIGN_LINE VARCHAR(200) NULL COMMENT "하단 서명란(쉼표) 예 '보고자,부서장,약 사' — 인쇄 전용, 값 저장 안 함",
  FOOT_TXT  VARCHAR(300) NULL COMMENT "정형 문구 예 '위와 같이 의약품 ( )을 보고합니다.' — 인쇄 전용",
  USE_YN    CHAR(1)      NOT NULL DEFAULT 'Y',
  REG_USER  VARCHAR(50)  NULL,
  REG_DTTM  DATETIME     NULL DEFAULT CURRENT_TIMESTAMP,
  UPD_USER  VARCHAR(50)  NULL,
  UPD_DTTM  DATETIME     NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (RPT_GB)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='사고 보고서 — 유형별 설정(반복행 표·서명란·정형문구)';


-- ── 2. 반복행 값 ────────────────────────────────────────────────────────────
--   서식이 열 이름을 정하고(SUB_COLS), 행은 문서가 늘린다 — 점검표 엔진 SUB_COLS 와 같은 규칙.
--   ★9000 예약대를 쓰지 않는다. 점검표 엔진이 9000+i 를 쓰는 이유는 격자 값과 한 표
--     (TBL_QPS_CHK_VAL)를 공유해 번호가 겹치면 안 되기 때문이다. 여기는 전용 표라
--     ROW_NO 가 1부터인 것이 자연스럽고, 이유 없이 9000을 흉내 내면 다음 사람이
--     "어디서 9000이 나왔나"를 찾게 된다.
--   ★열 수는 SUB_COLS 를 쉼표로 가른 개수다. 정규화하지 않는다(SUB_COLS 규칙과 동일).
CREATE TABLE IF NOT EXISTS TBL_QPS_SAFERPT_ROW (
  SRP_SEQ BIGINT       NOT NULL COMMENT 'TBL_QPS_SAFERPT.SRP_SEQ',
  ROW_NO  INT          NOT NULL COMMENT '행 번호 1..n — 문서가 늘린다',
  COL_NO  INT          NOT NULL COMMENT '열 번호 1..(SUB_COLS 열 수)',
  VAL     VARCHAR(500) NULL,
  PRIMARY KEY (SRP_SEQ, ROW_NO, COL_NO)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='사고 보고서 — 반복행 표 값';


-- ── 확인 ────────────────────────────────────────────────────────────────────
SELECT '설정' AS chk, COUNT(*) AS n FROM TBL_QPS_SAFERPT_FORM;
SELECT '반복행' AS chk, COUNT(*) AS n FROM TBL_QPS_SAFERPT_ROW;
