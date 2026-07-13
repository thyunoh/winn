/* ============================================================================
   06.배뇨관리 실시 환자분율 — 분자가 0으로 나오는 원인 추적 (조회 전용, 변경 없음)

   기준: 2026-07-10 수정본
         · mapper  select_CategoryList06  (manageYn CASE 교정 + URINE_MGMT NULL 안전화)
         · 프로시저 SP_EVAL_CATE06_block.sql
         두 곳의 판정이 동일하므로, 아래 STEP 이 곧 양쪽의 계산 과정이다.

   사용법: 아래 두 변수만 채우고 통째로 실행.
     @hosp_cd   : 요양기관코드
     @job_month : 평가년월 6자리 (예: '202607')

   읽는 법: STEP 이 갑자기 0(또는 급감)이 되는 지점이 범인.
     STEP 1 에서 0        → 배뇨일지(DIARY_DAYS) 미기재가 원인
     STEP 2 에서 0        → 배뇨관련 루 관리(URINE_MGMT) 값 문제
     STEP 3 에서 0        → 해당 월 청구자료 없음
     STEP 4 에서 0        → 주진단(DIAG_TYPE='1') 행이 없는 환자들
     STEP 5 에서 0        → JS008 특정내역 / 진료내역(ITEM_NO) 조건
   ============================================================================ */
SET @hosp_cd   = '여기에_요양기관코드';
SET @job_month = '202607';


/* ---------------------------------------------------------------------------
   [A] 단계별 깔때기 — 분모에서 시작해 분자 조건을 하나씩 얹는다
   --------------------------------------------------------------------------- */
SELECT '0. 분모 (수정본 기준)' AS step, COUNT(DISTINCT pm.PAT_ID) AS cnt
  FROM TBL_PATVAL_MST pm
 WHERE pm.HOSP_CD = @hosp_cd
   AND pm.MED_START LIKE CONCAT(@job_month, '%')
   AND COALESCE(pm.URINE_CTL, '') IN ('2','3')
   AND LEFT(COALESCE(pm.PAT_CLASS,'E'),1) <> 'A'
   AND IFNULL(pm.EVAL_TYPE,'') IN ('1','2')
   AND NOT ( LEFT(COALESCE(pm.PAT_CLASS,'E'),1) IN ('B','C')
             AND COALESCE(pm.DEMENTIA,'') = '1'
             AND ( COALESCE(pm.DELUSION,'')    IN ('2','3')
                OR COALESCE(pm.HALLUCIN,'')    IN ('2','3')
                OR COALESCE(pm.AGITATION,'')   IN ('2','3')
                OR COALESCE(pm.DISINHIB,'')    IN ('2','3')
                OR COALESCE(pm.CARE_RESIST,'') IN ('2','3')
                OR COALESCE(pm.WANDER,'')      IN ('2','3') )
             AND COALESCE(pm.PSYCH_DRUG,'') = '1' )

UNION ALL
/* 분자조건 ①∨②∨③ — 평가표만 본다. 여기서 0 이면 DIARY_DAYS 가 원인 */
SELECT '1. + 분자조건(배뇨계획/방광훈련/규칙적도뇨)', COUNT(DISTINCT pat.PAT_ID)
  FROM TBL_PATVAL_MST pat
 WHERE pat.HOSP_CD = @hosp_cd
   AND pat.MED_START LIKE CONCAT(@job_month, '%')
   AND pat.URINE_CTL IN ('2','3')
   AND LEFT(COALESCE(pat.PAT_CLASS,'E'),1) NOT IN ('A')
   AND IFNULL(pat.EVAL_TYPE,'') IN ('1','2')
   AND ( ( pat.UR_PLAN    = '1' AND CAST(NULLIF(pat.DIARY_DAYS,'') AS UNSIGNED) >= 3 )
      OR ( pat.BLAD_TRAIN = '1' AND CAST(NULLIF(pat.DIARY_DAYS,'') AS UNSIGNED) >= 3 )
      OR ( pat.REG_CATH   = '1' ) )

UNION ALL
/* 수정본의 URINE_MGMT 조건 (NULL 안전) */
SELECT '2. + URINE_MGMT <> 1  [수정본]', COUNT(DISTINCT pat.PAT_ID)
  FROM TBL_PATVAL_MST pat
 WHERE pat.HOSP_CD = @hosp_cd
   AND pat.MED_START LIKE CONCAT(@job_month, '%')
   AND pat.URINE_CTL IN ('2','3')
   AND LEFT(COALESCE(pat.PAT_CLASS,'E'),1) NOT IN ('A')
   AND IFNULL(pat.EVAL_TYPE,'') IN ('1','2')
   AND ( ( pat.UR_PLAN    = '1' AND CAST(NULLIF(pat.DIARY_DAYS,'') AS UNSIGNED) >= 3 )
      OR ( pat.BLAD_TRAIN = '1' AND CAST(NULLIF(pat.DIARY_DAYS,'') AS UNSIGNED) >= 3 )
      OR ( pat.REG_CATH   = '1' ) )
   AND COALESCE(pat.URINE_MGMT,'') <> '1'

UNION ALL
/* 명세서·청구서 조인. 여기서 0 이면 해당 월 청구자료가 없다는 뜻 */
SELECT '3. + 명세서·청구서 조인 (cm.DATE_YM)', COUNT(DISTINCT pat.PAT_ID)
  FROM TBL_PATVAL_MST pat
  JOIN TBL_MYOUNG_MST mm ON mm.HOSP_CD = pat.HOSP_CD AND mm.PAT_ID = pat.PAT_ID
  JOIN TBL_CHUNG_MST  cm ON cm.HOSP_CD = mm.HOSP_CD  AND cm.CLAIM_NO = mm.CLAIM_NO
 WHERE pat.HOSP_CD = @hosp_cd
   AND pat.MED_START LIKE CONCAT(@job_month, '%')
   AND pat.URINE_CTL IN ('2','3')
   AND LEFT(COALESCE(pat.PAT_CLASS,'E'),1) NOT IN ('A')
   AND IFNULL(pat.EVAL_TYPE,'') IN ('1','2')
   AND ( ( pat.UR_PLAN    = '1' AND CAST(NULLIF(pat.DIARY_DAYS,'') AS UNSIGNED) >= 3 )
      OR ( pat.BLAD_TRAIN = '1' AND CAST(NULLIF(pat.DIARY_DAYS,'') AS UNSIGNED) >= 3 )
      OR ( pat.REG_CATH   = '1' ) )
   AND COALESCE(pat.URINE_MGMT,'') <> '1'
   AND cm.DATE_YM = @job_month
   AND COALESCE(mm.DELYN,'') = ''

UNION ALL
/* 주진단 INNER JOIN + 요로전환술 진단 제외 */
SELECT '4. + 상병 조인(DIAG_TYPE=1) & 진단제외', COUNT(DISTINCT pat.PAT_ID)
  FROM TBL_PATVAL_MST pat
  JOIN TBL_MYOUNG_MST  mm ON mm.HOSP_CD = pat.HOSP_CD AND mm.PAT_ID = pat.PAT_ID
  JOIN TBL_CHUNG_MST   cm ON cm.HOSP_CD = mm.HOSP_CD  AND cm.CLAIM_NO = mm.CLAIM_NO
  JOIN TBL_DISEASE_MST dm ON dm.HOSP_CD = mm.HOSP_CD  AND dm.CLAIM_NO = mm.CLAIM_NO
                         AND dm.BILL_SEQ = mm.BILL_SEQ AND dm.DIAG_TYPE = '1'
 WHERE pat.HOSP_CD = @hosp_cd
   AND pat.MED_START LIKE CONCAT(@job_month, '%')
   AND pat.URINE_CTL IN ('2','3')
   AND LEFT(COALESCE(pat.PAT_CLASS,'E'),1) NOT IN ('A')
   AND IFNULL(pat.EVAL_TYPE,'') IN ('1','2')
   AND ( ( pat.UR_PLAN    = '1' AND CAST(NULLIF(pat.DIARY_DAYS,'') AS UNSIGNED) >= 3 )
      OR ( pat.BLAD_TRAIN = '1' AND CAST(NULLIF(pat.DIARY_DAYS,'') AS UNSIGNED) >= 3 )
      OR ( pat.REG_CATH   = '1' ) )
   AND COALESCE(pat.URINE_MGMT,'') <> '1'
   AND cm.DATE_YM = @job_month
   AND COALESCE(mm.DELYN,'') = ''
   AND SUBSTRING(dm.DIAG_CODE,1,4) NOT IN ('Z935','Z936','T830')

UNION ALL
/* 최종 = 수정본 프로시저의 분자와 같아야 한다 */
SELECT '5. + JS008 제외 & 진료내역(ITEM_NO<>L)  [= 최종 분자]', COUNT(DISTINCT pat.PAT_ID)
  FROM TBL_PATVAL_MST pat
  JOIN TBL_MYOUNG_MST  mm ON mm.HOSP_CD = pat.HOSP_CD AND mm.PAT_ID = pat.PAT_ID
  JOIN TBL_CHUNG_MST   cm ON cm.HOSP_CD = mm.HOSP_CD  AND cm.CLAIM_NO = mm.CLAIM_NO
  JOIN TBL_JINORD_MST  jm ON jm.HOSP_CD = mm.HOSP_CD  AND jm.CLAIM_NO = mm.CLAIM_NO
                         AND jm.BILL_SEQ = mm.BILL_SEQ
  JOIN TBL_DISEASE_MST dm ON dm.HOSP_CD = mm.HOSP_CD  AND dm.CLAIM_NO = mm.CLAIM_NO
                         AND dm.BILL_SEQ = mm.BILL_SEQ AND dm.DIAG_TYPE = '1'
 WHERE pat.HOSP_CD = @hosp_cd
   AND pat.MED_START LIKE CONCAT(@job_month, '%')
   AND pat.URINE_CTL IN ('2','3')
   AND LEFT(COALESCE(pat.PAT_CLASS,'E'),1) NOT IN ('A')
   AND IFNULL(pat.EVAL_TYPE,'') IN ('1','2')
   AND ( ( pat.UR_PLAN    = '1' AND CAST(NULLIF(pat.DIARY_DAYS,'') AS UNSIGNED) >= 3 )
      OR ( pat.BLAD_TRAIN = '1' AND CAST(NULLIF(pat.DIARY_DAYS,'') AS UNSIGNED) >= 3 )
      OR ( pat.REG_CATH   = '1' ) )
   AND COALESCE(pat.URINE_MGMT,'') <> '1'
   AND cm.DATE_YM = @job_month
   AND COALESCE(mm.DELYN,'') = ''
   AND SUBSTRING(dm.DIAG_CODE,1,4) NOT IN ('Z935','Z936','T830')
   AND NOT EXISTS (SELECT 1 FROM TBL_SPECODE_MST tsm
                    WHERE tsm.HOSP_CD  = mm.HOSP_CD AND tsm.CLAIM_NO = mm.CLAIM_NO
                      AND tsm.BILL_SEQ = mm.BILL_SEQ AND tsm.ROW_NO  = jm.ROW_NO
                      AND tsm.SPEC_TYPE = 'JS008')
   AND EXISTS (SELECT 1 FROM TBL_JINORD_MST jsm
                WHERE jsm.HOSP_CD  = mm.HOSP_CD AND jsm.CLAIM_NO = mm.CLAIM_NO
                  AND jsm.BILL_SEQ = mm.BILL_SEQ AND jsm.ITEM_NO <> 'L');


/* ---------------------------------------------------------------------------
   [B] 분자 조건 컬럼의 실제 분포 — DIARY_DAYS 가 범인인지 한 방에 확인
       UR_PLAN_1 은 많은데 DIARY_DAYS_3일이상 이 0 이면 배뇨일지 미기재가 원인.
   --------------------------------------------------------------------------- */
SELECT COUNT(*)                                                AS 분모후보
     , SUM(pm.UR_PLAN    = '1')                                AS UR_PLAN_1
     , SUM(pm.BLAD_TRAIN = '1')                                AS BLAD_TRAIN_1
     , SUM(pm.REG_CATH   = '1')                                AS REG_CATH_1
     , SUM(pm.DIARY_DAYS IS NULL)                              AS DIARY_DAYS_NULL
     , SUM(COALESCE(pm.DIARY_DAYS,'') = '')                    AS DIARY_DAYS_빈값
     , SUM(CAST(NULLIF(pm.DIARY_DAYS,'') AS UNSIGNED) >= 3)    AS DIARY_DAYS_3일이상
     , SUM(pm.URINE_MGMT IS NULL)                              AS URINE_MGMT_NULL
     , SUM(pm.URINE_MGMT = '1')                                AS URINE_MGMT_1
  FROM TBL_PATVAL_MST pm
 WHERE pm.HOSP_CD = @hosp_cd
   AND pm.MED_START LIKE CONCAT(@job_month, '%')
   AND pm.URINE_CTL IN ('2','3')
   AND IFNULL(pm.EVAL_TYPE,'') IN ('1','2');


/* ---------------------------------------------------------------------------
   [C] 이번 수정(URINE_MGMT NULL 안전화)으로 몇 명이 되살아나는지
       두 숫자가 다르면 NULL 함정이 실제로 환자를 삼키고 있었다는 증거.
   --------------------------------------------------------------------------- */
SELECT SUM(구코드) AS 기존_NOT_IN_통과, SUM(신코드) AS 수정_COALESCE_통과
  FROM (
        SELECT (pm.URINE_MGMT NOT IN ('1'))            AS 구코드   -- NULL 이면 NULL → 집계 제외
             , (COALESCE(pm.URINE_MGMT,'') <> '1')     AS 신코드
          FROM TBL_PATVAL_MST pm
         WHERE pm.HOSP_CD = @hosp_cd
           AND pm.MED_START LIKE CONCAT(@job_month, '%')
           AND pm.URINE_CTL IN ('2','3')
           AND IFNULL(pm.EVAL_TYPE,'') IN ('1','2')
       ) t;


/* ---------------------------------------------------------------------------
   [D] 해당 월 청구자료 존재 여부 — 0 이면 STEP 3 이 0 인 이유
   --------------------------------------------------------------------------- */
SELECT (SELECT COUNT(*) FROM TBL_CHUNG_MST
         WHERE HOSP_CD = @hosp_cd AND DATE_YM = @job_month)                        AS 청구서_건수
     , (SELECT COUNT(*) FROM TBL_MYOUNG_MST mm
          JOIN TBL_CHUNG_MST cm ON cm.HOSP_CD = mm.HOSP_CD AND cm.CLAIM_NO = mm.CLAIM_NO
         WHERE mm.HOSP_CD = @hosp_cd AND cm.DATE_YM = @job_month)                  AS 명세서_건수;
