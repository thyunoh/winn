-- =====================================================================
-- QPS 범위 확대 — 감염관리 포함 (2026-08-10)
--
--   ★배경: 2026-08-09 에 "감염 폴더는 QPS 1차 제외"로 확정했으나, 2026-08-10 사용자 요청으로
--     **전체 적용(감염관리 포함)** 으로 방침이 바뀌었다.
--
--   ★왜 이 DDL 이 먼저인가 — 서식 2·3호(계획서·라운딩)는 지금
--       UK_QPS_PLAN  (HOSP_CD, IN_YEAR)
--       UK_QPS_ROUND (HOSP_CD, ROUND_YM)
--     로 <병원당 1년 1건 / 1월 1건>이 강제된다. 감염관리계획서·감염라운딩을 얹으면
--     **QPS 것과 같은 키가 되어 저장이 막힌다.** 그래서 구분값(FORM_GB)을 키에 넣는다.
--     회의록도 같은 이유로 구분을 넣는다(아래 6번) — MEET_GB(정기/임시)는 <회의 성격>이라
--     "어느 위원회냐"를 담지 못한다. 구분이 없으면 목록에 QPS 회의와 감염 회의가 섞인다.
--
--   ★FORM_GB : 'Q' = 질향상·환자안전(기존), 'I' = 감염관리
--     기존 행은 전부 'Q' 로 채운다(DEFAULT 'Q' + 기존 행 UPDATE).
--
--   ★첨부(TBL_QPS_FILE)와의 관계 — 계획서 REF_KEY 는 '년도', 라운딩은 '년월' 이었다.
--     구분이 생기면 키가 겹치므로 화면에서 REF_KEY 를 '년도|Q' / '년월|I' 처럼 만든다.
--     ★기존 첨부는 구분 없이 저장돼 있어, 아래에서 '|Q' 를 붙여 옮긴다(1회성).
--
--   재실행 안전 — 컬럼·인덱스 존재 여부를 보고 움직인다.
-- =====================================================================

-- ── 1. 계획서 : 구분 컬럼 + 유니크 키 교체 ─────────────────────────
SET @c := (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
            WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='TBL_QPS_PLAN' AND COLUMN_NAME='FORM_GB');
SET @s := IF(@c=0, 'ALTER TABLE TBL_QPS_PLAN ADD COLUMN FORM_GB CHAR(1) NOT NULL DEFAULT ''Q'' COMMENT ''서식구분 Q=질향상 I=감염관리'' AFTER HOSP_CD', 'DO 0');
PREPARE st FROM @s; EXECUTE st; DEALLOCATE PREPARE st;

UPDATE TBL_QPS_PLAN SET FORM_GB='Q' WHERE FORM_GB IS NULL OR FORM_GB='';

SET @i := (SELECT COUNT(*) FROM INFORMATION_SCHEMA.STATISTICS
            WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='TBL_QPS_PLAN' AND INDEX_NAME='UK_QPS_PLAN');
SET @s := IF(@i>0, 'ALTER TABLE TBL_QPS_PLAN DROP INDEX UK_QPS_PLAN', 'DO 0');
PREPARE st FROM @s; EXECUTE st; DEALLOCATE PREPARE st;

SET @i := (SELECT COUNT(*) FROM INFORMATION_SCHEMA.STATISTICS
            WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='TBL_QPS_PLAN' AND INDEX_NAME='UK_QPS_PLAN2');
SET @s := IF(@i=0, 'ALTER TABLE TBL_QPS_PLAN ADD UNIQUE KEY UK_QPS_PLAN2 (HOSP_CD, FORM_GB, IN_YEAR)', 'DO 0');
PREPARE st FROM @s; EXECUTE st; DEALLOCATE PREPARE st;

-- ── 2. 라운딩 : 동일 ────────────────────────────────────────────────
SET @c := (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
            WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='TBL_QPS_ROUND' AND COLUMN_NAME='FORM_GB');
SET @s := IF(@c=0, 'ALTER TABLE TBL_QPS_ROUND ADD COLUMN FORM_GB CHAR(1) NOT NULL DEFAULT ''Q'' COMMENT ''서식구분 Q=질향상 I=감염관리'' AFTER HOSP_CD', 'DO 0');
PREPARE st FROM @s; EXECUTE st; DEALLOCATE PREPARE st;

UPDATE TBL_QPS_ROUND SET FORM_GB='Q' WHERE FORM_GB IS NULL OR FORM_GB='';

SET @i := (SELECT COUNT(*) FROM INFORMATION_SCHEMA.STATISTICS
            WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='TBL_QPS_ROUND' AND INDEX_NAME='UK_QPS_ROUND');
SET @s := IF(@i>0, 'ALTER TABLE TBL_QPS_ROUND DROP INDEX UK_QPS_ROUND', 'DO 0');
PREPARE st FROM @s; EXECUTE st; DEALLOCATE PREPARE st;

SET @i := (SELECT COUNT(*) FROM INFORMATION_SCHEMA.STATISTICS
            WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='TBL_QPS_ROUND' AND INDEX_NAME='UK_QPS_ROUND2');
SET @s := IF(@i=0, 'ALTER TABLE TBL_QPS_ROUND ADD UNIQUE KEY UK_QPS_ROUND2 (HOSP_CD, FORM_GB, ROUND_YM)', 'DO 0');
PREPARE st FROM @s; EXECUTE st; DEALLOCATE PREPARE st;

-- ── 3. 서식구분 공통코드 ────────────────────────────────────────────
INSERT INTO TBL_CODE_MST (CODE_CD, JOB_SEQ, CODE_NM, START_DT, END_DT, USE_YN, ACTION_YN, REG_USER) VALUES
 ('QPS_FORM_GB',1,'QPS 서식구분(질향상/감염관리)','20000101','99991231','Y','Y','system')
ON DUPLICATE KEY UPDATE CODE_NM=VALUES(CODE_NM), USE_YN='Y', ACTION_YN='Y';

INSERT INTO TBL_CODE_DTL (CODE_GB, CODE_CD, SUB_CODE, JOB_SEQ, SUB_CODE_NM, START_DT, END_DT, USE_YN, SORT, ACTION_YN, REG_USER) VALUES
 ('Q','QPS_FORM_GB','Q',1,'질향상·환자안전','20000101','99991231','Y',1,'Y','system'),
 ('Q','QPS_FORM_GB','I',1,'감염관리'        ,'20000101','99991231','Y',2,'Y','system')
ON DUPLICATE KEY UPDATE SUB_CODE_NM=VALUES(SUB_CODE_NM), SORT=VALUES(SORT), USE_YN='Y', ACTION_YN='Y';

-- ── 4. 자료실 분류에 감염관리 추가 ──────────────────────────────────
INSERT INTO TBL_CODE_DTL (CODE_GB, CODE_CD, SUB_CODE, JOB_SEQ, SUB_CODE_NM, START_DT, END_DT, USE_YN, SORT, ACTION_YN, REG_USER) VALUES
 ('Q','QPS_LIB','INF',1,'감염관리 자료','20000101','99991231','Y',5,'Y','system')
ON DUPLICATE KEY UPDATE SUB_CODE_NM=VALUES(SUB_CODE_NM), SORT=VALUES(SORT), USE_YN='Y', ACTION_YN='Y';

-- ── 5. 기존 첨부 REF_KEY 에 구분 붙이기 (1회성) ─────────────────────
--     계획서 '2026' → '2026|Q', 라운딩 '202608' → '202608|Q'
--     ★이미 '|' 가 붙은 행은 건드리지 않는다(재실행 안전).
UPDATE TBL_QPS_FILE SET REF_KEY = CONCAT(REF_KEY,'|Q')
 WHERE REF_GB IN ('PLAN','ROUND') AND REF_KEY NOT LIKE '%|%';

-- ── 6. 회의록에도 서식구분 (2026-08-10 추가 요청) ───────────────────
--    회의록은 MEET_GB(정기/임시)가 이미 있으나 그건 <회의 성격>이고,
--    여기서 넣는 FORM_GB 는 <어느 위원회냐>(질향상 / 감염관리)다. 둘은 다른 축이다.
--    목록이 한 곳에 섞이지 않도록 조회에도 구분을 태운다.
SET @c := (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
            WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='TBL_QPS_MINUTES' AND COLUMN_NAME='FORM_GB');
SET @s := IF(@c=0, 'ALTER TABLE TBL_QPS_MINUTES ADD COLUMN FORM_GB CHAR(1) NOT NULL DEFAULT ''Q'' COMMENT ''서식구분 Q=질향상 I=감염관리'' AFTER HOSP_CD', 'DO 0');
PREPARE st FROM @s; EXECUTE st; DEALLOCATE PREPARE st;

UPDATE TBL_QPS_MINUTES SET FORM_GB='Q' WHERE FORM_GB IS NULL OR FORM_GB='';

SET @i := (SELECT COUNT(*) FROM INFORMATION_SCHEMA.STATISTICS
            WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='TBL_QPS_MINUTES' AND INDEX_NAME='IX_QPS_MINUTES2');
SET @s := IF(@i=0, 'ALTER TABLE TBL_QPS_MINUTES ADD KEY IX_QPS_MINUTES2 (HOSP_CD, FORM_GB, MEET_DT)', 'DO 0');
PREPARE st FROM @s; EXECUTE st; DEALLOCATE PREPARE st;
