/* ============================================================================
   월보고서 마스터(TBL_EVAL_REPORT_MST) — 메일발송 / 열람(읽음) 정보 추가  (2026-07-29)

   [A] MST 컬럼 = '현재 상태' 요약 — 목록·상세에서 한 줄로 보여주는 값
   [B] 이력 테이블 = '언제 누구에게 몇 번' 상세 — 재발송·재열람이 쌓이는 값

   ※ A 만 적용해도 동작하고, 상세 추적이 필요해질 때 B 를 나중에 추가해도 된다.
   ※ 이 프로젝트에는 메일 발송 코드가 없다(javax.mail/JavaMailSender 없음).
      발송 컬럼은 ①발송 기능을 붙이거나 ②담당자가 보낸 사실을 기록하는 용도.
   ============================================================================ */

/* ── [A] 마스터 컬럼 ─────────────────────────────────────────────────────── */
ALTER TABLE WNN.TBL_EVAL_REPORT_MST
    /* 메일 발송 — 최종 1회분 요약 */
    ADD COLUMN SEND_EMAIL     VARCHAR(300) NULL     COMMENT '최종 발송 수신자(여러 명이면 콤마)'      AFTER PDF_PATH,
    ADD COLUMN SEND_DTTM      DATETIME     NULL     COMMENT '최종 발송일시'                          AFTER SEND_EMAIL,
    ADD COLUMN SEND_USER      VARCHAR(50)  NULL     COMMENT '최종 발송자(위너넷 담당자 ID)'          AFTER SEND_DTTM,
    ADD COLUMN SEND_CNT       INT          NOT NULL DEFAULT 0 COMMENT '발송 횟수(재발송 누적)'       AFTER SEND_USER,
    /* 열람(읽음) — 병원이 실제로 봤는지 */
    ADD COLUMN READ_YN        VARCHAR(1)   NOT NULL DEFAULT 'N' COMMENT '병원 열람여부 Y/N'          AFTER SEND_CNT,
    ADD COLUMN READ_FIRST_DTTM DATETIME    NULL     COMMENT '최초 열람일시'                          AFTER READ_YN,
    ADD COLUMN READ_LAST_DTTM  DATETIME    NULL     COMMENT '최근 열람일시'                          AFTER READ_FIRST_DTTM,
    ADD COLUMN READ_CNT        INT         NOT NULL DEFAULT 0 COMMENT '열람 횟수'                    AFTER READ_LAST_DTTM,
    ADD COLUMN READ_USER       VARCHAR(50) NULL     COMMENT '최근 열람자(병원 계정 ID)'              AFTER READ_CNT;

/* 확인 */
-- SELECT REPORT_SEQ, HOSP_CD, EVAL_YM, STATUS, SEND_EMAIL, SEND_DTTM, SEND_CNT,
--        READ_YN, READ_FIRST_DTTM, READ_LAST_DTTM, READ_CNT
--   FROM WNN.TBL_EVAL_REPORT_MST ORDER BY REPORT_SEQ DESC LIMIT 20;

/* 되돌리기
ALTER TABLE WNN.TBL_EVAL_REPORT_MST
    DROP COLUMN SEND_EMAIL, DROP COLUMN SEND_DTTM, DROP COLUMN SEND_USER, DROP COLUMN SEND_CNT,
    DROP COLUMN READ_YN, DROP COLUMN READ_FIRST_DTTM, DROP COLUMN READ_LAST_DTTM,
    DROP COLUMN READ_CNT, DROP COLUMN READ_USER;
*/


/* ── [B] 발송·열람 이력 (선택) ────────────────────────────────────────────
   한 보고서의 발송/열람이 여러 번 일어나므로, '누가 언제 무엇을' 추적하려면 이 테이블을 쓴다.
   MST 의 요약 컬럼은 이 이력의 마지막 값을 그대로 반영하면 된다.                       */
CREATE TABLE IF NOT EXISTS WNN.TBL_EVAL_REPORT_LOG (
    LOG_SEQ    BIGINT       NOT NULL AUTO_INCREMENT,
    REPORT_SEQ BIGINT       NOT NULL                   COMMENT 'TBL_EVAL_REPORT_MST.REPORT_SEQ',
    HOSP_CD    VARCHAR(20)  NOT NULL                   COMMENT '요양기관기호(조회 편의용 중복 보관)',
    EVAL_YM    VARCHAR(6)   NOT NULL                   COMMENT '평가년월 YYYYMM',
    LOG_TYPE   VARCHAR(10)  NOT NULL                   COMMENT 'SEND=메일발송, READ=열람, DOWN=PDF다운로드',
    EMAIL      VARCHAR(300) NULL                       COMMENT 'SEND 일 때 수신자',
    ACT_USER   VARCHAR(50)  NULL                       COMMENT '행위자(발송=담당자, 열람=병원 계정)',
    ACT_IP     VARCHAR(45)  NULL                       COMMENT '접속 IP',
    RESULT_MSG VARCHAR(300) NULL                       COMMENT '발송 결과/오류 메시지',
    REG_DTTM   DATETIME     NULL DEFAULT (CURRENT_TIMESTAMP),
    PRIMARY KEY (LOG_SEQ),
    KEY IX_EVAL_REPORT_LOG_1 (REPORT_SEQ, LOG_TYPE, REG_DTTM),
    KEY IX_EVAL_REPORT_LOG_2 (HOSP_CD, EVAL_YM)
) ENGINE=InnoDB COLLATE='utf8mb4_0900_ai_ci'
  COMMENT='월보고서 발송·열람 이력';
