/* ============================================================================
   월보고서 메일 수신자 — 병원별 주소록                            (2026-07-29)

   병원마다 받는 사람이 여러 명이라 매번 수기 입력하면 누락·오타가 난다.
   발송창에서 체크로 고르고, 새 주소는 그 자리에서 추가한다(별도 관리 메뉴 없음).

   · 삭제는 USE_YN='N' (소프트 삭제) — 과거 발송 이력과 대조할 수 있게 남긴다.
   · 같은 병원에 같은 주소를 두 번 넣지 못하게 UNIQUE.
   ============================================================================ */

CREATE TABLE IF NOT EXISTS WNN.TBL_EVAL_MAIL_ADDR (
    ADDR_SEQ  BIGINT       NOT NULL AUTO_INCREMENT,
    HOSP_CD   VARCHAR(20)  NOT NULL                COMMENT '요양기관기호',
    EMAIL     VARCHAR(200) NOT NULL                COMMENT '수신 이메일',
    ADDR_NM   VARCHAR(100) NULL                    COMMENT '받는 사람 이름/직책 (예: 김간호 팀장)',
    MEMO      VARCHAR(200) NULL                    COMMENT '비고',
    USE_YN    VARCHAR(1)   NOT NULL DEFAULT 'Y'    COMMENT '사용여부(N=삭제)',
    SORT_NO   INT          NULL                    COMMENT '표시 순서',
    REG_USER  VARCHAR(50)  NULL,
    REG_DTTM  DATETIME     NULL DEFAULT (CURRENT_TIMESTAMP),
    UPD_USER  VARCHAR(50)  NULL,
    UPD_DTTM  DATETIME     NULL DEFAULT (CURRENT_TIMESTAMP) ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (ADDR_SEQ),
    UNIQUE KEY UK_EVAL_MAIL_ADDR (HOSP_CD, EMAIL),
    KEY IX_EVAL_MAIL_ADDR_1 (HOSP_CD, USE_YN)
) ENGINE=InnoDB COLLATE='utf8mb4_0900_ai_ci'
  COMMENT='월보고서 메일 수신자(병원별)';

/* 확인 */
-- SELECT * FROM WNN.TBL_EVAL_MAIL_ADDR ORDER BY HOSP_CD, IFNULL(SORT_NO,999), ADDR_SEQ;

/* 되돌리기
   DROP TABLE WNN.TBL_EVAL_MAIL_ADDR;
*/
