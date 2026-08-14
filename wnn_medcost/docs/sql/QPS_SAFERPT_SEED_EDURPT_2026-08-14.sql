-- ═══════════════════════════════════════════════════════════════════════════
-- safeRpt 유형 추가 — 직원 교육 결과 보고서 (EDURPT, 부서 공통 1벌) 2026-08-14
--   근거 : **9곳에서 확인된 공용판** — 시설 196 · 영양 · 진단검사 39 · 보건관리자 h33 ·
--          원무총무 w24/w54 등(기타모듈 판독 요약표). 부서 셀렉트가 없는 같은 서식이다.
--   판독 : QPS_서식판독_보건관리자_2026-08-14.md §6(h33) —
--          라벨-값 폼 + 결재란 4칸 + 사진첨부 2×2 + 교육내용 큰 칸.
--   전제 : QPS_DDL_SAFERPT_PHOTO / QPS_DDL_SAFERPT_LBL (2026-08-14) 적용 후.
--   ⚠새 WAR(build 20260814-SRPHOTO)라야 사진칸·라벨이 산다 — 옛 WAR 에서는
--     유형만 뜨고 사고 라벨 그대로 보인다(이식 단계라 병원 노출 없음, 재배포로 해소).
--   재실행 안전(ON DUPLICATE KEY).
--
--   본문 칸 대응(코드 무변경 — LBL_JSON 이 이름만 바꾼다) :
--     교육일시→OCCUR_DT(+OCCUR_TM) · 교육장소→PLACE · 교육자→TARGET_NM ·
--     교육대상자→DEPT_NM · 교육방법→POSITION_NM · 교육주제→DIAG_NM ·
--     교육내용(큰 칸)→SUMMARY · 첨부자료→NOTE · 사진첨부→PHOTO_YN(2×2)
--     ※원본의 「교육내용 1줄」은 큰 칸 하나로 합쳤다(같은 이름 두 칸은 원본 지면 사정).
--     ※결재란 4칸(담당·팀장·부서장·이사장)은 병원 결재선(APPR_LINE)이 그대로 찍는다.
-- ═══════════════════════════════════════════════════════════════════════════

-- ── 1. 유형 ─────────────────────────────────────────────────────────────────
INSERT INTO TBL_CODE_DTL
 (CODE_GB, CODE_CD, SUB_CODE, JOB_SEQ, SUB_CODE_NM, START_DT, END_DT, USE_YN, SORT, ACTION_YN, REG_USER) VALUES
 ('Q','QPS_SAFERPT_GB','EDURPT',1,'직원 교육 결과 보고서','20000101','99991231','Y',20,'Y','system')
ON DUPLICATE KEY UPDATE SUB_CODE_NM=VALUES(SUB_CODE_NM), SORT=VALUES(SORT), USE_YN='Y', ACTION_YN='Y';

-- ── 2. 유형별 설정 — 사진칸 + 라벨 오버라이드 ───────────────────────────────
--   반복행 표·서명란·정형문구는 없다(결재란·사진이 이 서식의 전부다).
INSERT INTO TBL_QPS_SAFERPT_FORM
 (RPT_GB, SUB_NM, SUB_COLS, SIGN_LINE, FOOT_TXT, PHOTO_YN, LBL_JSON, USE_YN, REG_USER) VALUES
 ('EDURPT', NULL, NULL, NULL, NULL, 'Y',
  '{"occurDt":"교육일시","occurTm":"시각","rptDt":"-","place":"교육장소","targetNm":"교육자","targetNo":"-","deptNm":"교육대상자","positionNm":"교육방법","admitDt":"-","diagNm":"교육주제","wWhen":"-","wWho":"-","wWhere":"-","wWhat":"-","wHow":"-","wWhy":"-","summary":"교육내용","vitalTxt":"-","injuryTxt":"-","treatTxt":"-","causeTxt":"-","planTxt":"-","note":"첨부자료"}',
  'Y', 'system')
ON DUPLICATE KEY UPDATE PHOTO_YN=VALUES(PHOTO_YN), LBL_JSON=VALUES(LBL_JSON), USE_YN='Y';

-- ── 확인 ────────────────────────────────────────────────────────────────────
SELECT '유형' AS chk, SUB_CODE_NM FROM TBL_CODE_DTL WHERE CODE_CD='QPS_SAFERPT_GB' AND SUB_CODE='EDURPT';
SELECT '설정' AS chk, PHOTO_YN, CHAR_LENGTH(LBL_JSON) AS lbl_len FROM TBL_QPS_SAFERPT_FORM WHERE RPT_GB='EDURPT';
