-- =====================================================================
-- QPS 공통코드 묶음 이름(TBL_CODE_MST) 채우기 (2026-09-02)
--   왜 : 시드는 세부코드(TBL_CODE_DTL)만 넣어 묶음 31개 중 21개에 이름(MST)이 없다.
--        새 화면 「기준코드 › 공통코드」(qpsCode.jsp)와 기존 공통코드 화면이 묶음 이름으로 보여 준다.
--   더하기만(ON DUPLICATE KEY UPDATE 는 이름만). 두 번 돌려도 같은 결과.
-- =====================================================================
INSERT INTO TBL_CODE_MST (CODE_CD, JOB_SEQ, CODE_NM, START_DT, END_DT, USE_YN, ACTION_YN, REG_USER) VALUES
 ('QPS_CHK_DEPT',      1,'점검표 부서',                 '20000101','99991231','Y','Y','system'),
 ('QPS_CHK_CATE',      1,'점검표 분류',                 '20000101','99991231','Y','Y','system'),
 ('QPS_CMPL_TYPE',     1,'불만고충 유형',               '20000101','99991231','Y','Y','system'),
 ('QPS_CMPL_PERSON',   1,'불만고충 제기자',             '20000101','99991231','Y','Y','system'),
 ('QPS_CMPL_RECV',     1,'불만고충 접수경로',           '20000101','99991231','Y','Y','system'),
 ('QPS_CMPL_REPLY',    1,'불만고충 회신방법',           '20000101','99991231','Y','Y','system'),
 ('QPS_CMPL_TERM',     1,'불만고충 처리기간',           '20000101','99991231','Y','Y','system'),
 ('QPS_DAMAGE',        1,'사고 손상 종류',              '20000101','99991231','Y','Y','system'),
 ('QPS_IMPR_TYPE',     1,'개선활동 유형',               '20000101','99991231','Y','Y','system'),
 ('QPS_JOB',           1,'직종',                        '20000101','99991231','Y','Y','system'),
 ('QPS_LEVEL',         1,'위해 수준(Level)',            '20000101','99991231','Y','Y','system'),
 ('QPS_MOMENT',        1,'손위생 순간(Moment)',         '20000101','99991231','Y','Y','system'),
 ('QPS_PLACE',         1,'사고 발생 장소',              '20000101','99991231','Y','Y','system'),
 ('QPS_SRV_AGE',       1,'만족도 설문 연령대',          '20000101','99991231','Y','Y','system'),
 ('QPS_SRV_AREA',      1,'만족도 조사 영역',            '20000101','99991231','Y','Y','system'),
 ('QPS_SRV_SCALE',     1,'만족도 척도',                 '20000101','99991231','Y','Y','system'),
 ('QPS_SRV_WRITER',    1,'만족도 설문 작성자',          '20000101','99991231','Y','Y','system'),
 ('QPS_SUB_ABUSE',     1,'학대·폭력 세부유형',          '20000101','99991231','Y','Y','system'),
 ('QPS_SUB_FALL',      1,'낙상 세부유형',               '20000101','99991231','Y','Y','system'),
 ('QPS_SUB_PTSAFE',    1,'환자안전사고 세부유형',       '20000101','99991231','Y','Y','system'),
 ('QPS_SUB_STAFFSAFE', 1,'직원안전사고 세부유형',       '20000101','99991231','Y','Y','system'),
 ('QPS_SUB_SUICIDE',   1,'자살·자해 세부유형',          '20000101','99991231','Y','Y','system')
ON DUPLICATE KEY UPDATE CODE_NM = VALUES(CODE_NM), USE_YN = 'Y', ACTION_YN = 'Y';

-- 확인 : 이름 없는 QPS 묶음이 남았나(0 이어야)
SELECT d.CODE_CD FROM TBL_CODE_DTL d
 WHERE d.CODE_GB='Q' AND d.CODE_CD LIKE 'QPS\_%' AND d.ACTION_YN='Y'
   AND NOT EXISTS (SELECT 1 FROM TBL_CODE_MST m WHERE m.CODE_CD=d.CODE_CD AND m.ACTION_YN='Y')
 GROUP BY d.CODE_CD;
