-- =====================================================================
-- QPS 자료실 분류 코드 (2026-08-10) — 화면 qpsLib.do 의 왼쪽 분류 목록
--
--   ★왜 코드로 두는가: 자료실 분류는 병원마다 부르는 이름이 다르다("내규"/"규정"/"지침").
--     JSP 에 박아두면 요구가 올 때마다 배포가 필요해 2026-08-09 공통코드화 방침을 그대로 따른다.
--   ★SUB_CODE 가 곧 첨부의 문서키(TBL_QPS_FILE.REF_KEY, REF_GB='LIBRARY') 다.
--     → **한 번 쓰기 시작한 SUB_CODE 는 바꾸지 말 것**(바꾸면 그 분류에 올린 파일이 미아가 된다).
--       이름만 바꿀 때는 SUB_CODE_NM 만 고친다. 분류를 없앨 때도 USE_YN='N' 로 감추고 행은 남긴다.
--   ★CODE_GB='Q', CODE_CD LIKE 'QPS\_%' — 화면이 /qps/codeList.do 로 한 번에 읽어가는 규칙.
--   재실행 안전(ON DUPLICATE KEY UPDATE).
-- =====================================================================

INSERT INTO TBL_CODE_MST (CODE_CD, JOB_SEQ, CODE_NM, START_DT, END_DT, USE_YN, ACTION_YN, REG_USER) VALUES
 ('QPS_LIB',1,'QPS 자료실 분류','20000101','99991231','Y','Y','system')
ON DUPLICATE KEY UPDATE CODE_NM=VALUES(CODE_NM), USE_YN='Y', ACTION_YN='Y';

INSERT INTO TBL_CODE_DTL (CODE_GB, CODE_CD, SUB_CODE, JOB_SEQ, SUB_CODE_NM, START_DT, END_DT, USE_YN, SORT, ACTION_YN, REG_USER) VALUES
 ('Q','QPS_LIB','ORG' ,1,'조직도·위원회 구성' ,'20000101','99991231','Y',1,'Y','system'),
 ('Q','QPS_LIB','RULE',1,'규정·지침(내규)'    ,'20000101','99991231','Y',2,'Y','system'),
 ('Q','QPS_LIB','CERT',1,'인증 관련 자료'     ,'20000101','99991231','Y',3,'Y','system'),
 ('Q','QPS_LIB','EDU' ,1,'교육자료'           ,'20000101','99991231','Y',4,'Y','system'),
 ('Q','QPS_LIB','ETC' ,1,'기타'               ,'20000101','99991231','Y',9,'Y','system')
ON DUPLICATE KEY UPDATE SUB_CODE_NM=VALUES(SUB_CODE_NM), SORT=VALUES(SORT), USE_YN='Y', ACTION_YN='Y';
