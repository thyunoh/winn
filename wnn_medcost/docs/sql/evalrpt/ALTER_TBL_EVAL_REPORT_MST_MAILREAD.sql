/* ============================================================================
   월보고서 마스터 — '메일 열람' 컬럼 추가                          (2026-07-29)

   두 가지를 함께 본다.
     READ_*      = 문서열람 : 병원이 WinCheck+ 에서 보고서 화면을 연 기록 (확실)
     MAIL_READ_* = 메일열람 : 보낸 메일을 연 기록 (본문 1×1 추적 이미지, 참고용)

   ※ 메일열람은 추적 이미지가 로드돼야 잡힌다.
      · 수신자가 이미지 표시를 차단하면 열어도 기록되지 않는다(미확인으로 보임)
      · 구글이 이미지를 미리 받아두면 실제보다 빨리 잡힐 수 있다
      → 확실한 확인은 문서열람. 메일 본문의 '보고서 보기' 링크로 들어오면 그쪽에 기록된다.
   ============================================================================ */

ALTER TABLE WNN.TBL_EVAL_REPORT_MST
    ADD COLUMN MAIL_READ_YN         VARCHAR(1) NOT NULL DEFAULT 'N' COMMENT '메일 열람여부(추적이미지)' AFTER READ_USER,
    ADD COLUMN MAIL_READ_FIRST_DTTM DATETIME   NULL COMMENT '메일 최초 열람일시' AFTER MAIL_READ_YN,
    ADD COLUMN MAIL_READ_LAST_DTTM  DATETIME   NULL COMMENT '메일 최근 열람일시' AFTER MAIL_READ_FIRST_DTTM,
    ADD COLUMN MAIL_READ_CNT        INT        NOT NULL DEFAULT 0 COMMENT '메일 열람 횟수' AFTER MAIL_READ_LAST_DTTM;

/* 확인 */
-- SELECT HOSP_CD, EVAL_YM, SEND_DTTM, SEND_CNT,
--        MAIL_READ_YN, MAIL_READ_LAST_DTTM, MAIL_READ_CNT,
--        READ_YN, READ_LAST_DTTM, READ_CNT
--   FROM WNN.TBL_EVAL_REPORT_MST ORDER BY REPORT_SEQ DESC;

/* 되돌리기
ALTER TABLE WNN.TBL_EVAL_REPORT_MST
    DROP COLUMN MAIL_READ_YN, DROP COLUMN MAIL_READ_FIRST_DTTM,
    DROP COLUMN MAIL_READ_LAST_DTTM, DROP COLUMN MAIL_READ_CNT;
*/
