-- ═══════════════════════════════════════════════════════════════════════════
-- 반복행 표 「여러 벌」 조각으로 풀리는 서식 시드 (2026-08-15)
--   전제 : QPS_DDL_SAFERPT_SUBS_2026-08-15.sql + 새 WAR(build 20260815-SRSUBS)
--   ★값 자리 = ROW_NO = 벌번호×1000 + 행번호. 단벌 유형(1~999)은 무변경.
--
-- ═══ 넣는 것 ═══
--   ① HRCARD  w13 인사 기록 카드      — **9벌**(학력·경력·가족·면허·근무평점·교육훈련·포상·징계·발령) + 사진
--   ② MRCOMPL MR14 완결도 조사        — **2벌**(의사별/병동별 완결도율)
--   ③ RPTBHEP/RPTCHK 집계표 원형 복원 — 어제 열 접두어로 합쳤던 것을 **표 2벌/3벌로 분리**
--     (병원확인 #41 의 「합침」 절반이 해소된다 — 남는 것은 배치(내용 앞) 차이뿐)
--
-- ═══ 원본과 다르게 담은 것 ═══
--   ⓐ w13 의 **주민등록번호 칸은 뺐다** — 민감정보 저장 최소화 원칙(문서전산화 계획과 동일).
--      생년월일·연락처로 갈음한다. 필요 여부는 병원확인목록 #42
--   ⓑ w13 근무평점의 「(실시기간·평점)×2쌍」 은 열 4개(실시기간,평점,실시기간,평점)로 폈다
--   ⓒ MR14 의 총계 자동합산·「2021년 6월」 하드코딩 문구는 담지 않는다(값·문서 사정)
--   ⛔ h19 업무일지는 계속 보류 — 체크 문항 ~50개의 **전문이 판독에 없다**(캡처 재판독 필요)
-- 재실행 안전(DELETE 후 INSERT · ON DUPLICATE KEY).
-- ═══════════════════════════════════════════════════════════════════════════

INSERT INTO TBL_CODE_DTL
 (CODE_GB, CODE_CD, SUB_CODE, JOB_SEQ, SUB_CODE_NM, START_DT, END_DT, USE_YN, SORT, ACTION_YN, REG_USER) VALUES
 ('Q','QPS_SAFERPT_GB','HRCARD' ,1,'인사 기록 카드'              ,'20000101','99991231','Y',48,'Y','system'),
 ('Q','QPS_SAFERPT_GB','MRCOMPL',1,'퇴원환자 의무기록 완결도 조사','20000101','99991231','Y',66,'Y','system')
ON DUPLICATE KEY UPDATE SUB_CODE_NM=VALUES(SUB_CODE_NM), SORT=VALUES(SORT), USE_YN='Y', ACTION_YN='Y';

INSERT INTO TBL_QPS_SAFERPT_FORM
 (RPT_GB, SUB_NM, SUB_COLS, SIGN_LINE, FOOT_TXT, PHOTO_YN, LBL_JSON, USE_YN, REG_USER) VALUES
 -- w13 인사 기록 카드 — 사진칸(좌상단 증명사진 = 사진 격자 1칸 사용)
 ('HRCARD', NULL, NULL, NULL, NULL, 'Y',
  '{"occurDt":"작성일","occurTm":"-","rptDt":"입사일","place":"주소","targetNm":"성 명","targetNo":"-","deptNm":"근무부서","positionNm":"직급","admitDt":"생년월일","diagNm":"연락처","wWhen":"퇴사일","wWho":"병역 (구분·군별·병과)","wWhere":"입대연월·제대연월·계급","wWhat":"면제사유","wHow":"개인사항 (신장·체중·혈액형·시력)","wWhy":"-","summary":"특이사항","vitalTxt":"-","injuryTxt":"-","treatTxt":"-","causeTxt":"-","planTxt":"-","note":"-"}','Y','system'),
 -- MR14 완결도 조사
 ('MRCOMPL', NULL, NULL, NULL, NULL, NULL,
  '{"occurDt":"보고일","occurTm":"-","rptDt":"-","place":"-","targetNm":"-","targetNo":"-","deptNm":"-","positionNm":"-","admitDt":"-","diagNm":"-","wWhen":"-","wWho":"-","wWhere":"-","wWhat":"-","wHow":"-","wWhy":"-","summary":"보고 내용","vitalTxt":"-","injuryTxt":"-","treatTxt":"-","causeTxt":"-","planTxt":"-","note":"비 고"}','Y','system')
ON DUPLICATE KEY UPDATE PHOTO_YN=VALUES(PHOTO_YN), LBL_JSON=VALUES(LBL_JSON), USE_YN='Y';

-- w13 성별 2택
DELETE FROM TBL_QPS_SAFERPT_USE WHERE RPT_GB='HRCARD';
DELETE FROM TBL_QPS_SAFERPT_DEF WHERE RPT_GB='HRCARD';
INSERT INTO TBL_QPS_SAFERPT_DEF (RPT_GB,GRP_CD,GRP_NM,ITEM_NM,MULTI_YN,ETC_YN,SORT,USE_YN) VALUES
 ('HRCARD','SEXGB','성별','남','N','N',1,'Y'),
 ('HRCARD','SEXGB','성별','여','N','N',2,'Y'),
 ('HRCARD','MILGB','병역구분','필'  ,'N','N',1,'Y'),
 ('HRCARD','MILGB','병역구분','미필','N','N',2,'Y'),
 ('HRCARD','MILGB','병역구분','면제','N','N',3,'Y');
INSERT INTO TBL_QPS_SAFERPT_USE (RPT_GB,GRP_CD,SORT,USE_YN) VALUES
 ('HRCARD','SEXGB',1,'Y'), ('HRCARD','MILGB',2,'Y');

-- ═══ 벌 정의 ═══════════════════════════════════════════════════════════════
DELETE FROM TBL_QPS_SAFERPT_SUB WHERE RPT_GB IN ('HRCARD','MRCOMPL','RPTBHEP','RPTCHK');

INSERT INTO TBL_QPS_SAFERPT_SUB (RPT_GB, SUB_NO, SUB_NM, SUB_COLS, USE_YN, REG_USER) VALUES
 -- HRCARD 9벌 (p1 다섯 + p2 네 벌 — 판독 w13 그대로)
 ('HRCARD',1,'학력사항'       ,'구분,출신교,졸업연월,학력구분,전공과,학위'      ,'Y','system'),
 ('HRCARD',2,'경력사항'       ,'근무처,부서,직위,근무기간'                      ,'Y','system'),
 ('HRCARD',3,'가족사항'       ,'관계,성명,생년월일,학력,직업,동거여부'          ,'Y','system'),
 ('HRCARD',4,'면허·자격증사항','명칭,인가번호,인가연월,인가관청,비고'           ,'Y','system'),
 ('HRCARD',5,'근무평점'       ,'실시기간,평점,실시기간,평점,비고'               ,'Y','system'),
 ('HRCARD',6,'교육·훈련'      ,'교육일자,내용,비고'                             ,'Y','system'),
 ('HRCARD',7,'포상'           ,'포상일자,공적내용,포상권자'                     ,'Y','system'),
 ('HRCARD',8,'징계'           ,'징계일자,징계내용,비고'                         ,'Y','system'),
 ('HRCARD',9,'인사발령'       ,'발령일자,발령구분,소속,직급,연봉,비고'          ,'Y','system'),
 -- MRCOMPL 2벌
 ('MRCOMPL',1,'의사별 의무기록 완결도율','담당의사,퇴원환자 수,완결도 율,전월완결도,담당의사 확인','Y','system'),
 ('MRCOMPL',2,'병동별 의무기록 완결도율','병동,퇴원환자 수,완결도 율,전월완결도,확인'            ,'Y','system'),
 -- RPTBHEP 원형 복원 — 표 2벌 (h01 : 검사 5열 + 백신접종 3열)
 ('RPTBHEP',1,'검진 결과'  ,'원내검사,원외검사,항체 양성,항체 음성,항원 양성','Y','system'),
 ('RPTBHEP',2,'백신접종'   ,'1차 백신접종,2차 백신접종,3차 백신접종'         ,'Y','system'),
 -- RPTCHK 원형 복원 — 표 3벌 (h02 : 5열 + 특수검진 2열 + 채용검진 2열)
 ('RPTCHK',1,'건강검진'    ,'직장 건강검진,기타(외부),기타(내부),유소견자,2차검진 대상자','Y','system'),
 ('RPTCHK',2,'특수검진'    ,'정 상,유소견자','Y','system'),
 ('RPTCHK',3,'채용검진'    ,'정 상,유소견자','Y','system');

-- 합쳐 뒀던 단벌 정의는 비운다 — SUBS 가 이기지만 두 정의가 남으면 다음 사람이 헷갈린다
UPDATE TBL_QPS_SAFERPT_FORM SET SUB_NM=NULL, SUB_COLS=NULL WHERE RPT_GB IN ('RPTBHEP','RPTCHK');

-- ── 확인 ────────────────────────────────────────────────────────────────────
SELECT RPT_GB, COUNT(*) subs, GROUP_CONCAT(SUB_NM ORDER BY SUB_NO SEPARATOR ' · ') nms
  FROM TBL_QPS_SAFERPT_SUB GROUP BY RPT_GB;
SELECT RPT_GB, JSON_VALID(LBL_JSON) ok, IFNULL(PHOTO_YN,'-') ph FROM TBL_QPS_SAFERPT_FORM
 WHERE RPT_GB IN ('HRCARD','MRCOMPL');
