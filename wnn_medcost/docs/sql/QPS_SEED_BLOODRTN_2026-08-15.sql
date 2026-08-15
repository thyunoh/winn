-- ═══════════════════════════════════════════════════════════════════════════
-- 혈액 반납/ 폐기 신청서 — safeRpt 유형 BLOODRTN (2026-08-15)
--   ★3부서 공용 확인 서식 — 간호/병동 [201] · 진단검사 11 · 인공신장 RN37 이 같은 종이다
--     (진단검사 판독 §4-3 대조 그대로). 한 벌만 등록한다.
--   원문 확보 : RN37.png 를 구역별 Crop→Read 재판독(h19 와 같은 기법) —
--     판독 채록에서 잘렸던 주의문 전문과, 「서명 4칸이 별도 서명란이 아니라 **표의 열**」임을 확인.
--   구성 : 인적 5칸(라벨) + 폐기/반납 2택 + 반복행 표 8열(제제명~혈액은행담당자) +
--          주의문(FOOT_TXT) + 사유 체크 7(복수 — 원문 「□에 V표시 하시오」) + 상세 사유 큰 칸.
--   ⚠원본 표 머리는 「성명/sign」 2단 묶음이나 반복행 표는 묶음 머리가 없어 폈다(자료 동일).
-- 재실행 안전(DELETE 후 INSERT · ON DUPLICATE KEY).
-- ═══════════════════════════════════════════════════════════════════════════

INSERT INTO TBL_CODE_DTL
 (CODE_GB, CODE_CD, SUB_CODE, JOB_SEQ, SUB_CODE_NM, START_DT, END_DT, USE_YN, SORT, ACTION_YN, REG_USER) VALUES
 ('Q','QPS_SAFERPT_GB','BLOODRTN',1,'혈액 반납/ 폐기 신청서','20000101','99991231','Y',26,'Y','system')
ON DUPLICATE KEY UPDATE SUB_CODE_NM=VALUES(SUB_CODE_NM), SORT=VALUES(SORT), USE_YN='Y', ACTION_YN='Y';

INSERT INTO TBL_QPS_SAFERPT_FORM
 (RPT_GB, SUB_NM, SUB_COLS, SIGN_LINE, FOOT_TXT, PHOTO_YN, LBL_JSON, USE_YN, REG_USER) VALUES
 ('BLOODRTN', NULL, NULL, NULL,
  '* 혈액 반납시에는 불출 된 후 30분 이내로 반납하고 혈액에 이상이 없어야 한다.', NULL,
  '{"occurDt":"작성일","occurTm":"-","rptDt":"-","place":"-","targetNm":"성 명","targetNo":"등록번호","deptNm":"병실/과","positionNm":"담당의사","admitDt":"-","diagNm":"-","wWhen":"성별/나이","wWho":"-","wWhere":"-","wWhat":"-","wHow":"-","wWhy":"-","summary":"혈액 반납 / 폐기 사유를 자세히 기록하여 주십시오.","vitalTxt":"-","injuryTxt":"-","treatTxt":"-","causeTxt":"-","planTxt":"-","note":"-"}','Y','system')
ON DUPLICATE KEY UPDATE FOOT_TXT=VALUES(FOOT_TXT), LBL_JSON=VALUES(LBL_JSON), USE_YN='Y';

DELETE FROM TBL_QPS_SAFERPT_SUB WHERE RPT_GB='BLOODRTN';
INSERT INTO TBL_QPS_SAFERPT_SUB (RPT_GB, SUB_NO, SUB_NM, SUB_COLS, USE_YN, REG_USER) VALUES
 ('BLOODRTN',1,NULL,
  '혈액 제제명,혈액번호,불출시간(년월일시분),폐기의뢰시간(년월일시분),수(책임)간호사,담당간호사,담당의사,혈액은행담당자','Y','system');

DELETE FROM TBL_QPS_SAFERPT_USE WHERE RPT_GB='BLOODRTN';
DELETE FROM TBL_QPS_SAFERPT_DEF WHERE RPT_GB='BLOODRTN';
INSERT INTO TBL_QPS_SAFERPT_DEF (RPT_GB,GRP_CD,GRP_NM,ITEM_NM,MULTI_YN,ETC_YN,SORT,USE_YN) VALUES
 ('BLOODRTN','RTNGB','구분','혈액폐기','N','N',1,'Y'),
 ('BLOODRTN','RTNGB','구분','혈액반납','N','N',2,'Y'),
 ('BLOODRTN','RTNRSN','혈액 반납/폐기사유 (□에 V표시 하시오)','예상 출혈량보다 적거나 빨리 멈춘 경우','Y','N',1,'Y'),
 ('BLOODRTN','RTNRSN','혈액 반납/폐기사유 (□에 V표시 하시오)','출혈 호전 외 다른 임상증상의 호전','Y','N',2,'Y'),
 ('BLOODRTN','RTNRSN','혈액 반납/폐기사유 (□에 V표시 하시오)','환자의 사망','Y','N',3,'Y'),
 ('BLOODRTN','RTNRSN','혈액 반납/폐기사유 (□에 V표시 하시오)','환자의 퇴원','Y','N',4,'Y'),
 ('BLOODRTN','RTNRSN','혈액 반납/폐기사유 (□에 V표시 하시오)','보호자의 거부','Y','N',5,'Y'),
 ('BLOODRTN','RTNRSN','혈액 반납/폐기사유 (□에 V표시 하시오)','수혈 부작용','Y','N',6,'Y'),
 ('BLOODRTN','RTNRSN','혈액 반납/폐기사유 (□에 V표시 하시오)','기타','Y','Y',7,'Y');

INSERT INTO TBL_QPS_SAFERPT_USE (RPT_GB,GRP_CD,SORT,USE_YN) VALUES
 ('BLOODRTN','RTNGB',1,'Y'), ('BLOODRTN','RTNRSN',2,'Y');

-- ── 확인 ────────────────────────────────────────────────────────────────────
SELECT RPT_GB, JSON_VALID(LBL_JSON) ok FROM TBL_QPS_SAFERPT_FORM WHERE RPT_GB='BLOODRTN';
SELECT SUB_NO, SUB_COLS FROM TBL_QPS_SAFERPT_SUB WHERE RPT_GB='BLOODRTN';
SELECT GRP_CD, COUNT(*) n FROM TBL_QPS_SAFERPT_DEF WHERE RPT_GB='BLOODRTN' GROUP BY GRP_CD;
SELECT COUNT(*) AS saferpt_total FROM TBL_CODE_DTL WHERE CODE_CD='QPS_SAFERPT_GB' AND USE_YN='Y';
