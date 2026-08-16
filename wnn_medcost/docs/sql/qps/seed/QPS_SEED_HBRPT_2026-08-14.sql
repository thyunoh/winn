-- ═══════════════════════════════════════════════════════════════════════════
-- 보건관리자 보고서 5종 — safeRpt 유형 (2026-08-14 재판정)
--   판독 : QPS_서식판독_보건관리자_2026-08-14.md §A (h01·h02·h03·h09·h11)
--   보류를 풀었다 : 「집계표 여러 개」가 걸림돌이었는데 다시 세어 보니 —
--     h03·h09·h11 = **표 1개** ⇒ 반복행 표(SUB_COLS 1행 집계)로 그대로 담긴다
--     h01(표 2)·h02(표 3) = 열에 **접두어를 붙여 한 표로 합쳤다**(자료 손실 없음, 묶음 머리만 소실)
--
-- ═══ 원본과 다르게 담은 것 (한계 — 병원확인 #41) ═══
--   ⓐ 원본은 「내용」 큰 칸 **안에** 문단→표→문단 순서로 집계표가 낀다.
--      우리 화면·인쇄는 집계표가 **내용 문단 앞**에 온다(반복행 카드 위치 고정). 자료는 전부 보존
--   ⓑ 내용·결과의 **정형문구 기본값**(「1. B형 간염 항원·항체 검사 00명 검사 결과 …」)은
--      입력칸 기본값 장치가 없어 못 담았다 — 병원이 쓴다(상담일지 계열과 같은 한계)
--   ⓒ h09·h11 의 「첨부자료」 칸 정형문은 FOOT_TXT 로 (원본도 고정 인쇄문이다)
--   결재란 4칸(담당·팀장·부서장·이사장)은 병원 결재선(APPR_LINE)이 찍는다.
-- 재실행 안전(ON DUPLICATE KEY).
-- ═══════════════════════════════════════════════════════════════════════════

INSERT INTO TBL_CODE_DTL
 (CODE_GB, CODE_CD, SUB_CODE, JOB_SEQ, SUB_CODE_NM, START_DT, END_DT, USE_YN, SORT, ACTION_YN, REG_USER) VALUES
 ('Q','QPS_SAFERPT_GB','RPTBHEP',1,'B형 간염 검진 결과보고서'  ,'20000101','99991231','Y',91,'Y','system'),
 ('Q','QPS_SAFERPT_GB','RPTCHK' ,1,'건강검진대상자 결과보고서' ,'20000101','99991231','Y',92,'Y','system'),
 ('Q','QPS_SAFERPT_GB','RPTTBC' ,1,'잠복결핵 결과보고서'       ,'20000101','99991231','Y',93,'Y','system'),
 ('Q','QPS_SAFERPT_GB','RPTFLU' ,1,'독감 예방접종 보고서'      ,'20000101','99991231','Y',94,'Y','system'),
 ('Q','QPS_SAFERPT_GB','RPTCOV' ,1,'코로나 예방접종 결과보고서','20000101','99991231','Y',95,'Y','system')
ON DUPLICATE KEY UPDATE SUB_CODE_NM=VALUES(SUB_CODE_NM), SORT=VALUES(SORT), USE_YN='Y', ACTION_YN='Y';

-- 공통 라벨 : 보고일자→OCCUR_DT · 보고담당자→TARGET_NM · 내용→SUMMARY · 결과→PLAN_TXT
INSERT INTO TBL_QPS_SAFERPT_FORM
 (RPT_GB, SUB_NM, SUB_COLS, SIGN_LINE, FOOT_TXT, PHOTO_YN, LBL_JSON, USE_YN, REG_USER) VALUES
 ('RPTBHEP','검진 결과 집계',
  '원내검사,원외검사,항체 양성,항체 음성,항원 양성,1차 백신접종,2차 백신접종,3차 백신접종',NULL,NULL,NULL,
  '{"occurDt":"보고일자","occurTm":"-","rptDt":"-","place":"-","targetNm":"보고담당자","targetNo":"-","deptNm":"-","positionNm":"-","admitDt":"-","diagNm":"-","wWhen":"-","wWho":"-","wWhere":"-","wWhat":"-","wHow":"-","wWhy":"-","summary":"내용","vitalTxt":"-","injuryTxt":"-","treatTxt":"-","causeTxt":"-","planTxt":"결과","note":"-"}','Y','system'),
 ('RPTCHK','검진 결과 집계',
  '직장 건강검진,기타(외부),기타(내부),유소견자,2차검진 대상자,특수검진 정상,특수검진 유소견자,채용검진 정상,채용검진 유소견자',NULL,NULL,NULL,
  '{"occurDt":"보고일자","occurTm":"-","rptDt":"-","place":"-","targetNm":"보고담당자","targetNo":"-","deptNm":"-","positionNm":"-","admitDt":"-","diagNm":"-","wWhen":"-","wWho":"-","wWhere":"-","wWhat":"-","wHow":"-","wWhy":"-","summary":"내용","vitalTxt":"-","injuryTxt":"-","treatTxt":"-","causeTxt":"-","planTxt":"결과","note":"-"}','Y','system'),
 ('RPTTBC','검진 결과 집계','원내,외부,내부,Positive,Negative',NULL,NULL,NULL,
  '{"occurDt":"보고일자","occurTm":"-","rptDt":"-","place":"-","targetNm":"보고담당자","targetNo":"-","deptNm":"-","positionNm":"-","admitDt":"-","diagNm":"-","wWhen":"-","wWho":"-","wWhere":"-","wWhat":"-","wHow":"-","wWhy":"-","summary":"내용","vitalTxt":"-","injuryTxt":"-","treatTxt":"-","causeTxt":"-","planTxt":"결과","note":"-"}','Y','system'),
 ('RPTFLU','접종 결과 집계','원내접종,타병원접종,알러지,백신거부',NULL,
  '첨부자료 : 1. 예방접종 예진표',NULL,
  '{"occurDt":"보고일자","occurTm":"-","rptDt":"-","place":"-","targetNm":"보고담당자","targetNo":"-","deptNm":"-","positionNm":"-","admitDt":"-","diagNm":"-","wWhen":"-","wWho":"-","wWhere":"-","wWhat":"-","wHow":"-","wWhy":"-","summary":"내용","vitalTxt":"-","injuryTxt":"-","treatTxt":"-","causeTxt":"-","planTxt":"결과","note":"비 고"}','Y','system'),
 ('RPTCOV','접종 결과 집계','원내접종,타병원접종,백신거부,기타',NULL,
  '첨부자료 : 1. 예방접종 예진표',NULL,
  '{"occurDt":"보고일자","occurTm":"-","rptDt":"-","place":"-","targetNm":"보고담당자","targetNo":"-","deptNm":"-","positionNm":"-","admitDt":"-","diagNm":"-","wWhen":"-","wWho":"-","wWhere":"-","wWhat":"-","wHow":"-","wWhy":"-","summary":"내용","vitalTxt":"-","injuryTxt":"-","treatTxt":"-","causeTxt":"-","planTxt":"결과","note":"비 고"}','Y','system')
ON DUPLICATE KEY UPDATE SUB_NM=VALUES(SUB_NM), SUB_COLS=VALUES(SUB_COLS),
  FOOT_TXT=VALUES(FOOT_TXT), LBL_JSON=VALUES(LBL_JSON), USE_YN='Y';

-- ── 확인 ────────────────────────────────────────────────────────────────────
SELECT RPT_GB, SUB_NM, SUB_COLS, JSON_VALID(LBL_JSON) ok FROM TBL_QPS_SAFERPT_FORM
 WHERE RPT_GB IN ('RPTBHEP','RPTCHK','RPTTBC','RPTFLU','RPTCOV');
SELECT COUNT(*) AS saferpt_total FROM TBL_CODE_DTL WHERE CODE_CD='QPS_SAFERPT_GB' AND USE_YN='Y';
