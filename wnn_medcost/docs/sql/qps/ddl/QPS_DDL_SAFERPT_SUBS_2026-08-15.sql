-- =====================================================================
-- safeRpt 반복행 표 「여러 벌」 — DDL (2026-08-15)
--   왜 : 지금은 유형당 반복행 표가 1벌(TBL_QPS_SAFERPT_FORM.SUB_NM/SUB_COLS)이다.
--        인사기록카드(w13, 9벌)·완결도 조사(MR14, 2벌)·보고서 h01/h02(집계표 2~3벌)가
--        이 한계로 보류/축약됐다 — 벌 정의를 데이터로 늘린다.
--   값 자리 : 새 표 없이 기존 TBL_QPS_SAFERPT_ROW 를 그대로 쓴다 —
--        ***ROW_NO = 벌번호×1000 + 행번호***(1001·1002·…·2001…).
--        점검표 LIST 의 블록 규칙(블록×1000)과 같은 발상이다. 단벌(기존 FORM.SUB_COLS)
--        유형은 종전대로 1~999 라 **기존 데이터·유형 무변경**.
--   우선순위 : SUB 표에 벌이 있으면 그것이 이기고, 없으면 FORM 의 단벌 정의를 쓴다.
--   더하기만 하는 DDL ⇒ 운영 선적용 안전.
-- =====================================================================

CREATE TABLE TBL_QPS_SAFERPT_SUB (
  RPT_GB    VARCHAR(20)  NOT NULL COMMENT '유형(QPS_SAFERPT_GB)',
  SUB_NO    INT          NOT NULL COMMENT '벌 번호(1~9) — 값은 ROW_NO=벌x1000+행',
  SUB_NM    VARCHAR(60)  NULL     COMMENT '표 이름(왼쪽 세로 칸/머리띠)',
  SUB_COLS  VARCHAR(300) NOT NULL COMMENT '열 이름(쉼표)',
  USE_YN    CHAR(1)      NOT NULL DEFAULT 'Y',
  REG_USER  VARCHAR(50)  NULL,
  REG_DTTM  DATETIME     NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (RPT_GB, SUB_NO)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
  COMMENT='사고 보고서 반복행 표 여러 벌(벌 정의)';
