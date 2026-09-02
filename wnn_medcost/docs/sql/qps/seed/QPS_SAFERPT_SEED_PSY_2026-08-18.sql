-- ═══════════════════════════════════════════════════════════════════════════
-- safeRpt 유형 추가 — 2026-08-18 신규분 3종 → **2종 + 기존 유형 설정 1건** (2026-09-02 정정)
--   ① ~~STAFFVIO~~ → **HARASS** 직원간 폭행/성희롱 사건 보고서 — ★같은 서식이 이미 HARASS(SORT 9)로 있었다(델파이 원본도 한 폼 RPT_Chart_047).
--      유형은 새로 만들지 않고 HARASS 의 설정(LBL_JSON·정형문구)만 넣는다. 09-02 밤 운영 확인 : 이 파일은 아직 운영에 안 돌았고
--      HARASS 작성분 0 — 그래서 이름만 바꿔도 안전하다. (STAFFVIO 로 먼저 들어간 체크 묶음은 SEED_CHK 파일 머리가 지운다.)
--   ② PSYIMPR  환자안전사건 개선활동 보고서     (보고서 ▸ 정신)
--   ③ PSYVISIT 방문객 안전사고보고서            (보고서 ▸ 정신)
--
--   근거 : 캡처 D:\위너넷\caps\QPS_2026-08-18\ RD05 · PS02 · PS06
--          판독 QPS_서식판독_신규분_2026-08-18.md §3-2 · §3-3
--   전제 : QPS_DDL_SAFERPT_LBL / _PHOTO (2026-08-14) 적용 후. EDURPT 와 같은 방식이다.
--   재실행 안전(ON DUPLICATE KEY).
--
--   ⚠**체크 선택지는 LBL_JSON 으로 못 넣는다** — 이름만 바꾸는 장치다.
--     원본의 체크 묶음은 EDURPT 전례대로 **글자 칸으로 흡수**했다(아래 각 항 ※).
--   ★[2026-09-02 정정] 선택지 장치(TBL_QPS_SAFERPT_DEF/USE)가 이미 있었다 — 코드 변경 없이 시드로 넣었다 :
--     QPS_SAFERPT_SEED_CHK_2026-09-02.sql (PSYVISIT 방문사유·사고종류·성폭력 종류·사고결과 · STAFFVIO 피해자 요구사항 등 9유형).
--     아래 ※의 「글자 칸에 적는다」는 그 시드 뒤로는 체크 묶음이 대신한다(글자 칸 라벨은 그대로 두었다 — 옛 작성분 표시용).
--   ⚠SORT 는 **96~97**(정정 전 96~98). 기존 최대가 95(…91~95 사용중)라 그 뒤에 붙였다.
--     ***51~53 은 이미 MRPROXY·IDREQ·ABBRRPT 가 쓰고 있다*** — 처음에 그리 잡았다가 고쳤다.
-- ═══════════════════════════════════════════════════════════════════════════

-- ── 1. 유형 ─────────────────────────────────────────────────────────────────
INSERT INTO TBL_CODE_DTL
 (CODE_GB, CODE_CD, SUB_CODE, JOB_SEQ, SUB_CODE_NM, START_DT, END_DT, USE_YN, SORT, ACTION_YN, REG_USER) VALUES
 ('Q','QPS_SAFERPT_GB','PSYIMPR',1,'환자안전사건 개선활동 보고서','20000101','99991231','Y',96,'Y','system'),
 ('Q','QPS_SAFERPT_GB','PSYVISIT',1,'방문객 안전사고보고서','20000101','99991231','Y',97,'Y','system')
ON DUPLICATE KEY UPDATE SUB_CODE_NM=VALUES(SUB_CODE_NM), SORT=VALUES(SORT), USE_YN='Y', ACTION_YN='Y';

-- ── 2. 유형별 설정 ──────────────────────────────────────────────────────────

-- ① 직원간 폭행/성희롱 사건 보고서 (RD05) — 기존 유형 HARASS 의 설정
--    본문 : 피해자·가해자 2행 표(성명·부서·직위) + 1.신고내용(6하원칙) + 2.피해자 요구사항
--           + 3.결과 및 개선방안 + 정형문구 + 보고자
--    ※「2. 피해자 요구사항」의 체크(공개사과·징계조치·법적조치·해고·기타요구)는
--      요구사항 글자 칸에 함께 적는다(선택지 미구현). → 09-02 SEED_CHK 가 HARASS 「피해자 요구사항」 체크 묶음으로 넣었다.
INSERT INTO TBL_QPS_SAFERPT_FORM
 (RPT_GB, SUB_NM, SUB_COLS, SIGN_LINE, FOOT_TXT, PHOTO_YN, LBL_JSON, USE_YN, REG_USER) VALUES
 ('HARASS', '구분', '구분,성명,부서,직위', NULL,
  '직장 내 성희롱(폭행) 사건을 위와 같이 보고 합니다.', 'N',
  '{"occurDt":"보고일자","occurTm":"-","rptDt":"-","place":"-","targetNm":"보고자","targetNo":"-","deptNm":"-","positionNm":"-","admitDt":"-","diagNm":"-","wWhen":"-","wWho":"-","wWhere":"-","wWhat":"-","wHow":"-","wWhy":"-","summary":"1. 신고내용 (6하 원칙에 의거)","vitalTxt":"-","injuryTxt":"-","treatTxt":"2. 피해자 요구사항","causeTxt":"-","planTxt":"3. 결과 및 개선방안","note":"-"}',
  'Y', 'system')
ON DUPLICATE KEY UPDATE SUB_NM=VALUES(SUB_NM), SUB_COLS=VALUES(SUB_COLS),
  FOOT_TXT=VALUES(FOOT_TXT), PHOTO_YN=VALUES(PHOTO_YN), LBL_JSON=VALUES(LBL_JSON), USE_YN='Y';

-- ② 환자안전사건 개선활동 보고서 (PS02)
--    본문 : 분석단계(환자안전사건 / 사건에 따른 개선활동) × 항목질문 × 내용 조사 결과
--    반복행 표·사진·정형문구 없음. 결재란 4칸은 병원 결재선이 찍는다.
INSERT INTO TBL_QPS_SAFERPT_FORM
 (RPT_GB, SUB_NM, SUB_COLS, SIGN_LINE, FOOT_TXT, PHOTO_YN, LBL_JSON, USE_YN, REG_USER) VALUES
 ('PSYIMPR', NULL, NULL, NULL, NULL, 'N',
  '{"occurDt":"발생일시","occurTm":"시간","rptDt":"-","place":"발생장소","targetNm":"-","targetNo":"-","deptNm":"-","positionNm":"-","admitDt":"-","diagNm":"-","wWhen":"-","wWho":"-","wWhere":"-","wWhat":"-","wHow":"-","wWhy":"-","summary":"문제 요약","vitalTxt":"-","injuryTxt":"-","treatTxt":"-","causeTxt":"-","planTxt":"개선활동 요약","note":"-"}',
  'Y', 'system')
ON DUPLICATE KEY UPDATE SUB_NM=VALUES(SUB_NM), SUB_COLS=VALUES(SUB_COLS),
  FOOT_TXT=VALUES(FOOT_TXT), PHOTO_YN=VALUES(PHOTO_YN), LBL_JSON=VALUES(LBL_JSON), USE_YN='Y';

-- ③ 방문객 안전사고보고서 (PS06)
--    ※「방문사유」(보호자·실습생·기타) · 「사고종류」(시설 및 환경안전사고·폭언·폭행·
--      성폭력(성희롱/성추행/성폭행)·기타) · 「사고결과」(지속적인 치료가 필요·치료 후
--      후유증 없이 치료됨·특별한 이상 없음·추후 관찰 필요·기타)는 각 글자 칸에 적는다.
INSERT INTO TBL_QPS_SAFERPT_FORM
 (RPT_GB, SUB_NM, SUB_COLS, SIGN_LINE, FOOT_TXT, PHOTO_YN, LBL_JSON, USE_YN, REG_USER) VALUES
 ('PSYVISIT', NULL, NULL, NULL,
  '방문객 안전사고에 대해 위와 같이 보고 합니다.', 'N',
  '{"occurDt":"발생일시","occurTm":"시각","rptDt":"-","place":"발생장소","targetNm":"성함","targetNo":"-","deptNm":"-","positionNm":"방문사유","admitDt":"-","diagNm":"사고종류","wWhen":"-","wWho":"-","wWhere":"-","wWhat":"-","wHow":"-","wWhy":"-","summary":"사고경위","vitalTxt":"-","injuryTxt":"사고결과","treatTxt":"사고처리 및 조치사항","causeTxt":"발생원인","planTxt":"개선계획","note":"작성자"}',
  'Y', 'system')
ON DUPLICATE KEY UPDATE SUB_NM=VALUES(SUB_NM), SUB_COLS=VALUES(SUB_COLS),
  FOOT_TXT=VALUES(FOOT_TXT), PHOTO_YN=VALUES(PHOTO_YN), LBL_JSON=VALUES(LBL_JSON), USE_YN='Y';

-- ── 확인 ────────────────────────────────────────────────────────────────────
SELECT '유형' AS chk, SUB_CODE, SUB_CODE_NM, SORT
  FROM TBL_CODE_DTL
 WHERE CODE_CD='QPS_SAFERPT_GB' AND SUB_CODE IN ('HARASS','PSYIMPR','PSYVISIT')
 ORDER BY SORT;

SELECT '설정' AS chk, RPT_GB, SUB_NM, SUB_COLS, PHOTO_YN, CHAR_LENGTH(LBL_JSON) AS lbl_len
  FROM TBL_QPS_SAFERPT_FORM
 WHERE RPT_GB IN ('HARASS','PSYIMPR','PSYVISIT');
