-- =====================================================================
-- MIS(경영고객관리) 병원자료엑셀연계 — 삭감 자료 DDL (2026-10-11)
--   왜 : 사용자 「청구 및 삭감자료 업로드 추가」 → 「샘파일 청구서 기능은 있으니 삭감자료 매칭자료만 있으면 됨」
--        → 「청구삭감내역은 환자별 개별까지는 아니고 지급처별 구분 — SWCHMISU 참조로 구성」.
--        청구는 기존 청구 샘파일(TBL_CHUNG_MST·TBL_MYOUNG_MST)이 갖고 있다 ⇒ 청구 엑셀 표는 만들지 않는다.
--   구조(SWCHMISU D:\swchmisu docs/sql/CHM_DDL.sql 의 CHM_RECV·미수 줄 키와 같은 결) :
--     · 한 줄 = 진료(청구) 연월 × 종별 × 지급처 [× 청구번호] 의 삭감·불능·조정 금액. 환자 단위가 아니다.
--     · 종별 = 샘파일 청구서 보험자종별(INSUR_TYPE : 4 건강보험 · 1/2 의료급여 · 7 보훈 · 8 자동차보험 · 9 산재)
--       지급처 = 샘파일 명세서 보장기관기호(INSUR_CODE — 의료급여는 시군구, 건강보험은 빈 값 = 공단).
--     · 매칭은 저장하지 않고 볼 때마다 센다 : 청구번호 → 종별+지급처 → 종별.
--   운영 DB : ①CREATE 는 10:50 이미 적용됨(0건). ②칸 추가 블록은 재실행 안전(없을 때만 ADD).
--   ⛔이 DDL(②) 을 먼저 → WAR 재빌드·재기동 (저장·요약이 새 칸을 읽고 쓴다).
-- =====================================================================

-- ── ① 삭감(심사 조정) 내역(연월 단위 대체) ─────────────────────────────
CREATE TABLE IF NOT EXISTS TBL_MIS_EMR_CUT (
  HOSP_CD      VARCHAR(10)    NOT NULL,
  YYYYMM       CHAR(6)        NOT NULL COMMENT '진료(청구) 연월',
  SEQ_NUM      INT            NOT NULL,
  CLAIM_NO     VARCHAR(30)    NULL     COMMENT '청구번호(접수번호) — 샘파일 청구서 CLAIM_NO 와 매칭',
  BILL_NO      VARCHAR(30)    NULL     COMMENT '(쓰지 않음 — 환자 단위 판의 흔적)',
  RESULT_DT    CHAR(8)        NULL     COMMENT '심결(심사결과) 통보일',
  CHARTNO      VARCHAR(30)    NULL     COMMENT '(쓰지 않음)',
  PAT_NM       VARCHAR(50)    NULL     COMMENT '(쓰지 않음)',
  BIRTH6       CHAR(6)        NULL     COMMENT '(쓰지 않음)',
  INOUT_GB     VARCHAR(20)    NULL     COMMENT '입원/외래',
  ITEM_CD      VARCHAR(30)    NULL     COMMENT '(쓰지 않음)',
  ITEM_NM      VARCHAR(100)   NULL     COMMENT '(쓰지 않음)',
  CUT_RSN_CD   VARCHAR(20)    NULL     COMMENT '조정(삭감) 사유 코드',
  CUT_RSN      VARCHAR(200)   NULL     COMMENT '조정(삭감) 사유',
  CUT_QTY      DECIMAL(12,1)  NULL     COMMENT '(쓰지 않음)',
  CLAIM_AMT    BIGINT         NULL     COMMENT '그 줄 청구액(엑셀에 있으면)',
  CUT_AMT      BIGINT         NULL     COMMENT '삭감(불능·조정) 금액',
  OBJ_GB       VARCHAR(30)    NULL     COMMENT '이의신청 여부·결과(엑셀 글자)',
  MEMO         VARCHAR(200)   NULL,
  REG_DTTM     DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
  REG_USER     VARCHAR(50)    NULL,
  PRIMARY KEY (HOSP_CD, YYYYMM, SEQ_NUM),
  KEY IX_MIS_EMR_CUT_RSN (HOSP_CD, YYYYMM, CUT_RSN_CD)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='MIS EMR 삭감(심사 조정) 내역 — 종별·지급처 단위';

-- ── ② 종별·지급처·구분 칸 (2026-10-11 「지급처별 구분」) — 없을 때만 더한다(재실행 안전) ──
SET @t = 'TBL_MIS_EMR_CUT';
SET @s = (SELECT IF(COUNT(*) = 0, 'ALTER TABLE TBL_MIS_EMR_CUT ADD COLUMN JONG_NM VARCHAR(50) NULL COMMENT ''종별(엑셀 글자 — 건강보험·의료급여·서식코드 등)'' AFTER RESULT_DT', 'SELECT 1')
            FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = @t AND COLUMN_NAME = 'JONG_NM');
PREPARE st FROM @s; EXECUTE st; DEALLOCATE PREPARE st;
SET @s = (SELECT IF(COUNT(*) = 0, 'ALTER TABLE TBL_MIS_EMR_CUT ADD COLUMN ASS_CD VARCHAR(30) NULL COMMENT ''지급처 코드(보장기관기호 등) — 샘파일 명세서 INSUR_CODE 와 매칭'' AFTER JONG_NM', 'SELECT 1')
            FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = @t AND COLUMN_NAME = 'ASS_CD');
PREPARE st FROM @s; EXECUTE st; DEALLOCATE PREPARE st;
SET @s = (SELECT IF(COUNT(*) = 0, 'ALTER TABLE TBL_MIS_EMR_CUT ADD COLUMN ASS_NM VARCHAR(100) NULL COMMENT ''지급처명(시군구·보험사 등)'' AFTER ASS_CD', 'SELECT 1')
            FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = @t AND COLUMN_NAME = 'ASS_NM');
PREPARE st FROM @s; EXECUTE st; DEALLOCATE PREPARE st;
SET @s = (SELECT IF(COUNT(*) = 0, 'ALTER TABLE TBL_MIS_EMR_CUT ADD COLUMN CUT_GB VARCHAR(20) NULL COMMENT ''구분(삭감·불능·조정 — 엑셀 글자, 비면 삭감)'' AFTER ASS_NM', 'SELECT 1')
            FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = @t AND COLUMN_NAME = 'CUT_GB');
PREPARE st FROM @s; EXECUTE st; DEALLOCATE PREPARE st;
