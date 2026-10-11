-- =====================================================================
-- MIS(경영고객관리) 병원자료엑셀연계 — 삭감 자료 추가 DDL (2026-10-11)
--   왜 : 사용자 「청구 및 삭감자료 업로드 추가」 → 「샘파일 청구서 기능은 있으니 삭감자료 매칭자료만 있으면 됨」.
--        청구는 기존 청구 샘파일(TBL_CHUNG_MST·TBL_MYOUNG_MST)이 이미 갖고 있다 ⇒ 청구 엑셀 표는 만들지 않는다.
--        EMR(닥터스)에서 내려받은 심사 삭감(조정) 내역 엑셀만 올리고, 화면이 그 달 샘파일 명세서와 **매칭**한다
--        (청구번호+명세서번호 → 생년월일+이름 → 이름만(그 달 샘파일에 그 이름이 한 사람일 때)). 매칭은 저장하지 않고 볼 때마다 센다.
--   원칙 :
--     · 대상 연월 = 진료(청구) 연월 — 샘파일 청구서의 진료년월(TBL_CHUNG_MST.DATE_YM)과 같은 달끼리 맞춘다. 그 달 통째 대체.
--     · 주민번호 전체는 받지 않는다(생년월일 6자리만). 삭감 항목 코드·명칭은 엑셀에 있으면 받는다(없어도 된다).
--   먼저 실행한 MIS_DDL_EMR_2026-10-11.sql(맞춤·이력·5종 표) 위에 더하기만 한다 ⇒ 운영 선적용 안전.
--   ⛔이 DDL 을 먼저 → WAR 재빌드·재기동 (화면을 열면 요약 조회가 이 표를 읽는다 — 표 없이 새 WAR 면 화면 전체가 오류).
-- =====================================================================

-- ── ⑥ 삭감(심사 조정) 내역(연월 단위 대체) — 한 줄 = 삭감 항목 하나 ─────────
CREATE TABLE IF NOT EXISTS TBL_MIS_EMR_CUT (
  HOSP_CD      VARCHAR(10)    NOT NULL,
  YYYYMM       CHAR(6)        NOT NULL COMMENT '진료(청구) 연월',
  SEQ_NUM      INT            NOT NULL,
  CLAIM_NO     VARCHAR(30)    NULL     COMMENT '청구번호(접수번호) — 샘파일 CLAIM_NO / CLAIM_RCP_NO 와 매칭',
  BILL_NO      VARCHAR(30)    NULL     COMMENT '명세서 일련번호 — 샘파일 BILL_SEQ 와 숫자로 매칭',
  RESULT_DT    CHAR(8)        NULL     COMMENT '심사결과 통보일',
  CHARTNO      VARCHAR(30)    NULL,
  PAT_NM       VARCHAR(50)    NULL,
  BIRTH6       CHAR(6)        NULL     COMMENT '생년월일 6자리 — 샘파일 PAT_ID 앞 6자리와 매칭',
  INOUT_GB     VARCHAR(20)    NULL,
  ITEM_CD      VARCHAR(30)    NULL     COMMENT '삭감 항목 코드(엑셀에 있으면)',
  ITEM_NM      VARCHAR(100)   NULL     COMMENT '삭감 항목명',
  CUT_RSN_CD   VARCHAR(20)    NULL     COMMENT '조정(삭감) 사유 코드',
  CUT_RSN      VARCHAR(200)   NULL     COMMENT '조정(삭감) 사유',
  CUT_QTY      DECIMAL(12,1)  NULL     COMMENT '삭감 수량',
  CLAIM_AMT    BIGINT         NULL     COMMENT '그 항목 청구액',
  CUT_AMT      BIGINT         NULL     COMMENT '삭감액',
  OBJ_GB       VARCHAR(30)    NULL     COMMENT '이의신청 여부·결과(엑셀 글자)',
  MEMO         VARCHAR(200)   NULL,
  REG_DTTM     DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
  REG_USER     VARCHAR(50)    NULL,
  PRIMARY KEY (HOSP_CD, YYYYMM, SEQ_NUM),
  KEY IX_MIS_EMR_CUT_RSN (HOSP_CD, YYYYMM, CUT_RSN_CD)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='MIS EMR 삭감(심사 조정) 내역';
