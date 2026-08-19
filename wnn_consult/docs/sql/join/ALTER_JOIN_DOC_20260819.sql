/* =====================================================================================
 * 신규병원 가입 — 승인 후 "동의서 원본 제출" 단계 추가                     2026-08-19
 *
 *   승인(30) 만으로는 프로그램을 쓸 수 없다. 병원이 서명·날인한 동의서 원본(PDF/사진)을
 *   올려야(40) 비로소 화면이 열린다. 위너넷이 계약까지 넣으면 메뉴가 열린다.
 *
 *   10 접수 → 20 검토중 → 30 승인 → 40 동의서제출 → (계약등록) → 사용
 *                                  ↘ 90 반려
 *
 *   ※ 운영 DB(WNN)에 반영합니다. 실행 전 백업 권장.
 * =================================================================================== */

/* 1. 제출 상태 컬럼 --------------------------------------------------------------- */
ALTER TABLE `TBL_JOIN_REQ`
  ADD COLUMN `DOC_YN`      char(1)      NOT NULL DEFAULT 'N' COMMENT '동의서 원본 제출여부' AFTER `REQ_STAT`,
  ADD COLUMN `DOC_DTTM`    datetime     DEFAULT NULL         COMMENT '동의서 제출일시'     AFTER `DOC_YN`,
  ADD COLUMN `DOC_FILE_NM` varchar(300) DEFAULT NULL         COMMENT '제출 파일명'         AFTER `DOC_DTTM`;

/* 2. 상태코드 '40' 추가 ------------------------------------------------------------ */
INSERT IGNORE INTO `TBL_CODE_DTL`
       (`CODE_GB`,`CODE_CD`,`SUB_CODE`,`JOB_SEQ`,`SUB_CODE_NM`,`START_DT`,`END_DT`,`USE_YN`,`SORT`,`REG_USER`)
VALUES ('Z','REQ_STAT','40',1,'동의서제출','20260101','29991231','Y',5,'SYSTEM');

/* 3. 상태 주석 갱신 ---------------------------------------------------------------- */
ALTER TABLE `TBL_JOIN_REQ`
  MODIFY COLUMN `REQ_STAT` varchar(2) NOT NULL DEFAULT '10'
  COMMENT '처리상태 10.접수 20.검토중 30.승인 40.동의서제출 90.반려';

/* 4. 확인 -------------------------------------------------------------------------- */
-- SELECT REQ_NO, HOSP_CD, HOSP_NM, REQ_STAT, DOC_YN, DOC_DTTM, DOC_FILE_NM FROM TBL_JOIN_REQ;
