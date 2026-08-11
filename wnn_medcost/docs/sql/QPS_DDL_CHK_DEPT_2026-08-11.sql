-- ═══════════════════════════════════════════════════════════════════════════
-- 점검표 — 부서 축(DEPT_CD) 추가 · 2026-08-11
--
-- ★왜 (사용자 지적 2026-08-11 : "QPS·QI·감염 이미 했으니 간호/병동, 약국, 영양실, 시설 비슷할 듯")
--   2차 네 모듈이 전부 점검표 계열이다. 엔진 하나로 다 받는다.
--   ⇒ 그러면 서식이 한 통에 섞인다. **부서로 갈라야** 목록이 쓸 만해진다.
--
-- ★분류(CATE_CD)와 부서(DEPT_CD)는 다른 축이다 — 섞지 않는다.
--   CATE = 무엇을 점검하나 (의료기기 / 멸균·소독 / 환경·시설 / 약품 / 안전·감염)
--   DEPT = 누가 쓰나       (간호·병동 / 약국 / 영양 / 시설 / 진단검사 / 공통)
--   같은 「냉장고 온도 점검표」가 병동에도 약국에도 영양실에도 있다 — 부서가 없으면 구분이 안 된다.
-- ═══════════════════════════════════════════════════════════════════════════

ALTER TABLE TBL_QPS_CHK_FORM
  ADD COLUMN DEPT_CD VARCHAR(20) NULL COMMENT '부서 QPS_CHK_DEPT' AFTER CATE_CD;

DELETE FROM TBL_CODE_DTL WHERE CODE_CD='QPS_CHK_DEPT';
INSERT INTO TBL_CODE_DTL
 (CODE_GB, CODE_CD, SUB_CODE, JOB_SEQ, SUB_CODE_NM, START_DT, END_DT, USE_YN, SORT, ACTION_YN, REG_USER) VALUES
 ('Q','QPS_CHK_DEPT','NURSE' ,1,'간호·병동','20000101','99991231','Y',1,'Y','system'),
 ('Q','QPS_CHK_DEPT','PHARM' ,1,'약국'     ,'20000101','99991231','Y',2,'Y','system'),
 ('Q','QPS_CHK_DEPT','NUTRI' ,1,'영양'     ,'20000101','99991231','Y',3,'Y','system'),
 ('Q','QPS_CHK_DEPT','FACIL' ,1,'시설'     ,'20000101','99991231','Y',4,'Y','system'),
 ('Q','QPS_CHK_DEPT','LAB'   ,1,'진단검사' ,'20000101','99991231','Y',5,'Y','system'),
 ('Q','QPS_CHK_DEPT','INFECT',1,'감염관리' ,'20000101','99991231','Y',6,'Y','system'),
 ('Q','QPS_CHK_DEPT','COMMON',1,'공통'     ,'20000101','99991231','Y',9,'Y','system');

-- 기존 시드 12종은 전부 간호/병동에서 나온 것이다
UPDATE TBL_QPS_CHK_FORM SET DEPT_CD='NURSE' WHERE HOSP_CD='*' AND DEPT_CD IS NULL;

SELECT '부서코드' AS chk, COUNT(*) FROM TBL_CODE_DTL WHERE CODE_CD='QPS_CHK_DEPT';
SELECT '서식부서' AS chk, DEPT_CD, COUNT(*) AS n FROM TBL_QPS_CHK_FORM GROUP BY DEPT_CD;
