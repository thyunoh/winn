-- ═══════════════════════════════════════════════════════════════════════════
-- 점검표 엔진 v3 — **문서가 정하는 열 이름** `TBL_QPS_CHK_COL` (2026-08-12, v3 순서 8)
--
-- ★★이 파일은 **새 WAR 를 올리기 전에** 실행한다. (더하기 · 새 표만)
--
-- ★근거 2종 — 둘 다 **열 이름을 병원이 정한다**
--   | 서식 | 열 | 왜 서식이 못 정하나 |
--   |---|---|---|
--   | MSDS 관리대장 (시설)      | **물질명** | 병원마다 쓰는 물질이 다르고, 해마다 바뀐다 |
--   | 소방시설 월점검표 (시설)   | **층 · 병동** | 층 수가 병원마다 다르다.<br>***원본에 빈 칸 2개가 그려져 있는 것이 증거다*** — 손으로 적으라는 뜻 |
--
-- ★★***이미 있는 것의 대칭이다.*** `EQUIP_DAY` 의 기기명이 그렇다 —
--   기기 이름을 서식이 정할 수 없어 `TBL_QPS_CHK_ROW` (문서 × 행번호 → 이름) 를 두었다.
--   열도 똑같은 일이 벌어졌을 뿐이므로 **표 하나를 뒤집어 만든다.**
--   ⇒ 새 장치가 아니라 ***이미 판단이 끝난 것을 한 번 더 쓰는 것***이라 값싸다.
--
-- ★어느 축인가 — `ITEM_COL`(항목 행 × 날짜 아닌 열) 하나뿐이다.
--   그 축은 열을 `COL_NMS`(서식)가 정했는데, 여기에 **「문서가 정한다」를 하나 더** 둔다 :
--     `COL_SRC='F'` (비면 이것) 서식이 정함 — 지금까지 그대로
--     `COL_SRC='D'`             **문서가 정함** — 작성 화면 머리글에 이름 칸이 생긴다
--   몇 칸을 깔지는 `EQUIP_CNT` 를 쓴다.
--   ⚠`EQUIP_CNT` 는 이미 축마다 뜻이 갈린다 — EQUIP_DAY=기기 행 수 · LIST=기본 행 수 ·
--     여기서는 **기본 열 수**. ***화면 라벨을 축에 맞춰 바꿔 줘야 한다*** (안 바꾸면 「기기 행 수」로 보인다).
--
-- ⚠**열 번호는 1~n 그대로다.** 앞/뒤 열(1000·2000 대)과 겹치지 않는다 —
--   격자 안의 열이라 예약 번호가 필요 없다. (인수인계 문서의 「예약 번호」 표 참고)
-- ═══════════════════════════════════════════════════════════════════════════

CREATE TABLE IF NOT EXISTS TBL_QPS_CHK_COL (
  CHK_SEQ BIGINT       NOT NULL COMMENT '작성 문서',
  COL_NO  INT          NOT NULL COMMENT '격자의 열 번호(1부터)',
  COL_NM  VARCHAR(200)     NULL COMMENT '그 열의 이름 — 물질명 · 층 · 병동',
  PRIMARY KEY (CHK_SEQ, COL_NO)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='점검표 열 이름 (CHK_ROW 의 대칭)';

ALTER TABLE TBL_QPS_CHK_FORM
  ADD COLUMN COL_SRC CHAR(1) NULL
      COMMENT "열 이름을 누가 정하나. NULL·'F'=서식(COL_NMS) / 'D'=문서(TBL_QPS_CHK_COL)"
      AFTER COL_NMS;

-- ── 확인 ────────────────────────────────────────────────────────────────────
SELECT COLUMN_NAME, COLUMN_TYPE FROM INFORMATION_SCHEMA.COLUMNS
 WHERE TABLE_SCHEMA='WNN' AND TABLE_NAME='TBL_QPS_CHK_COL' ORDER BY ORDINAL_POSITION;
SELECT COLUMN_NAME, COLUMN_TYPE, COLUMN_COMMENT FROM INFORMATION_SCHEMA.COLUMNS
 WHERE TABLE_SCHEMA='WNN' AND TABLE_NAME='TBL_QPS_CHK_FORM' AND COLUMN_NAME='COL_SRC';
SELECT AXIS_GB, IFNULL(COL_SRC,'-') AS COL_SRC, COUNT(*) AS cnt
  FROM TBL_QPS_CHK_FORM GROUP BY AXIS_GB, COL_SRC ORDER BY AXIS_GB;
