-- ═══════════════════════════════════════════════════════════════════════════
-- 원무·총무(ADMIN) 시드 — 회의록 1 + LIST 6 + ITEM_DAY 1 + EQUIP_DAY 1 + safeRpt 유형 14 (2026-08-14)
--   판독 정본 : docs/proposals/QPS_서식판독_원무총무_2026-08-14.md (w01~w59, 부서 중 최대 59종)
--   전제 : QPS_DDL_SAFERPT_PHOTO / _LBL / QPS_CHK_SEED_YEARGRID(부서코드 ADMIN) 적용 후.
--   ★연간 월12 격자 4종(w19·w23·w25·w55)은 YEARGRID 시드에서 이미 등록(ADM001~004).
--
-- ═══ ★회의록 — 새 화면·새 표가 아니라 `QPS_FORM_GB` 코드 한 줄이다 ═══
--   기존 회의록 화면(qpsMinutes)이 FORM_GB 로 위원회를 가르고, 표(TBL_QPS_MINUTES)에는
--   `MEET_GB`(정기/임시) · `CLERK_NM`(간사) · `AGENDA`(의안) · `DECISION`(의결사항) ·
--   `MEMBERS`(참석자 서명 명단) · `ATTACH_TXT`(첨부자료)가 **이미 다 있다**(실측).
--   ⇒ w01~w06(6종이 한 판) · w28 · w57 을 위원회 코드 3개로 받는다. **엔진·화면 변경 0.**
--   ※w01~w06 의 월(1·4·7·10월)은 회의 일시가 이미 담으므로 서식을 나누지 않는다(판독 결론).
--
-- ═══ ⛔등록 금지 3종 (판독 확정 — 다시 넣지 말 것) ═══
--   w36 낙상예방점검표 = `LAB029` (7항목 오타까지 동일) · w53 AED = `NUR014`(8열 겹공백까지 동일)
--   · w59 U.P.S = `FAC004`. 부서만 다른 같은 종이라 **부서 공유**로 쓴다(보고서 폴더 전례).
--
-- ═══ ⛔이식 제외 4종 ═══
--   w07 내규·w08 조직도 = **자료실**(자유 전문/그림 — 간호 244·245 와 같은 판정) ·
--   w35 사원등록·w48 의료기기목록 = **마스터 관리 화면**(문서 캔버스가 아님)
--
-- ═══ ⛔보류 8종 (조각이 없다 — 반쪽 등록 금지) ═══
--   w12 연간인력계획서·w15 인사고과평가표·w20/21 직원교육현황표·w29 위탁업체 평가표
--     ⇒ 「항목 행 × <날짜 아닌> 고정 열」 계열. ITEM_COL 이 가깝지만 **셀 타입이 갈린다**
--        (w12 수치·w15 5택1·w20 체크·w29 점수+열별 합계행) — 근거를 모아 조각 설계 후 등록
--   w13 인사기록카드 ⇒ **반복행 표 7벌 + 사진칸**(현 확장은 문서당 1벌) · w42 자체정기점검(5쪽 결과보고)
--   w43~45 기기 예방점검표 3종 ⇒ 건별 체크리스트(날짜축 없음) — 셋이 서로 다른 판이라 묶을 수도 없다
--   w46·w47 라벨 ⇒ 인쇄 라벨(문서 아님)
--
-- ═══ 원본과 다르게 담은 것 ═══
--   ⓐ w30·w31 기안서의 **SRC 재활병원 로고**는 캡처 병원 고유라 넣지 않는다
--   ⓑ w17 변경사항제출서의 고정 4행(핸드폰/집주소/이메일/기타)은 반복행 표의 **첫 열 값**으로 넣지 못한다
--      (행 라벨 고정 장치가 없다) — 첫 열을 `구분` 으로 두고 병원이 적는다
--   ⓒ w09 규정입안서의 「개정 전|후」 2열 비교 칸 = 반복행 표(SUB_COLS 2열)로 받는다
-- 재실행 안전(DELETE 후 INSERT · ON DUPLICATE KEY).
-- ═══════════════════════════════════════════════════════════════════════════

DELETE FROM TBL_QPS_CHK_ITEM WHERE HOSP_CD='*' AND FORM_ID BETWEEN 'ADM005' AND 'ADM012';
DELETE FROM TBL_QPS_CHK_FORM WHERE HOSP_CD='*' AND FORM_ID BETWEEN 'ADM005' AND 'ADM012';

-- ═══ ① 회의록 위원회 코드 3건 (엔진 변경 없음) ══════════════════════════════
INSERT INTO TBL_CODE_DTL
 (CODE_GB, CODE_CD, SUB_CODE, JOB_SEQ, SUB_CODE_NM, START_DT, END_DT, USE_YN, SORT, ACTION_YN, REG_USER) VALUES
 ('Q','QPS_FORM_GB','W',1,'운영위원회'      ,'20000101','99991231','Y',3,'Y','system'),
 ('Q','QPS_FORM_GB','C',1,'중독연구소 운영위원회','20000101','99991231','Y',4,'Y','system'),
 ('Q','QPS_FORM_GB','P',1,'인사위원회'      ,'20000101','99991231','Y',5,'Y','system')
ON DUPLICATE KEY UPDATE SUB_CODE_NM=VALUES(SUB_CODE_NM), SORT=VALUES(SORT), USE_YN='Y', ACTION_YN='Y';

-- ═══ ② 점검표 8종 (LIST 6 · ITEM_DAY 1 · EQUIP_DAY 1) ═══════════════════════
INSERT INTO TBL_QPS_CHK_FORM
 (FORM_ID, HOSP_CD, FORM_NM, CATE_CD, DEPT_CD, AXIS_GB, PRD_GB, PRD_KIND, EQUIP_CNT,
  HEAD_NMS, GUIDE_TXT, SPLIT_N, SPLIT_DIR, SIGNER_YN, NOTE_YN, FIX_YN, FOOT_TXT, SORT_NO, USE_YN, REG_USER) VALUES
 -- LIST 6종
 ('ADM005','*','규정관리 대장'        ,'ETC'  ,'ADMIN','LIST','Y',NULL,18,NULL,NULL,NULL,NULL,'N','N','N',NULL,210,'Y','system'),
 ('ADM006','*','교육활동 계획표'      ,'ETC'  ,'ADMIN','LIST','Y',NULL,20,NULL,NULL,NULL,NULL,'N','N','N',NULL,220,'Y','system'),
 ('ADM007','*','의료기기 이력카드'    ,'EQUIP','ADMIN','LIST','Y',NULL,10,
  '기기명,모델명,제조사,규격,구입일자,구입금액,설치장소,S/N',NULL,NULL,NULL,'N','N','N',NULL,230,'Y','system'),
 ('ADM008','*','의료기기 폐기관리 대장','EQUIP','ADMIN','LIST','Y',NULL,15,NULL,NULL,NULL,NULL,'N','N','N',NULL,240,'Y','system'),
 ('ADM009','*','의료기기 관리대장'    ,'EQUIP','ADMIN','LIST','Y',NULL,20,NULL,NULL,NULL,NULL,'N','N','N',NULL,250,'Y','system'),
 ('ADM010','*','서명대장'             ,'ETC'  ,'ADMIN','LIST','D',NULL,60,NULL,NULL,30,'R','N','N','N',NULL,260,'Y','system'),
 -- ITEM_DAY 1종 (w26)
 ('ADM011','*','환경관리 일일 점검 대장 - 원무부서, 로비 등','ENV','ADMIN','ITEM_DAY','M','D',10,
  NULL,'상태 : 양호(O), 정비요(△), 불량(X)',NULL,NULL,'Y','N','N',NULL,270,'Y','system'),
 -- EQUIP_DAY 1종 (w49) — 기기 이름은 문서가 적는다(항목은 머리 나열 6개)
 ('ADM012','*','일상점검표 - 의료기기','EQUIP','ADMIN','EQUIP_DAY','M','D',10,
  NULL,NULL,NULL,NULL,'Y','N','Y',NULL,280,'Y','system');

INSERT INTO TBL_QPS_CHK_ITEM (FORM_ID,HOSP_CD,SORT,ITEM_NM,GRP_NM,INPUT_GB,CARRY_YN,USE_YN) VALUES
 -- ADM005 · w10 규정관리대장
 ('ADM005','*',1,'일자'                ,NULL,'TEXT','N','Y'),
 ('ADM005','*',2,'규정번호'            ,NULL,'TEXT','N','Y'),
 ('ADM005','*',3,'내용 요약'           ,NULL,'TEXT','N','Y'),
 ('ADM005','*',4,'분류 (제정/개정/삭제)',NULL,'TEXT','N','Y'),
 -- ADM006 · w22 교육활동 계획표 (구분 2단은 GRP_NM 으로 — 행이 고정 항목이라 LIST 로도 담긴다)
 ('ADM006','*',1,'구분'            ,NULL,'TEXT','N','Y'),
 ('ADM006','*',2,'교육내용'        ,NULL,'TEXT','N','Y'),
 ('ADM006','*',3,'교육주기'        ,NULL,'TEXT','N','Y'),
 ('ADM006','*',4,'계획수립 및 시행',NULL,'TEXT','N','Y'),
 ('ADM006','*',5,'비고'            ,NULL,'TEXT','N','Y'),
 -- ADM007 · w37 의료기기 이력카드 (★문서 키가 「기기 1대」 — 머리 8칸이 기기 정보, 행은 수리내역)
 ('ADM007','*',1,'수리일자'  ,NULL,'TEXT','N','Y'),
 ('ADM007','*',2,'고장내용'  ,NULL,'TEXT','N','Y'),
 ('ADM007','*',3,'수리내용'  ,NULL,'TEXT','N','Y'),
 ('ADM007','*',4,'수리업체'  ,NULL,'TEXT','N','Y'),
 ('ADM007','*',5,'비용'      ,NULL,'TEXT','N','Y'),
 -- ADM008 · w38 폐기관리 대장
 ('ADM008','*',1,'폐기일자'    ,NULL,'TEXT','N','Y'),
 ('ADM008','*',2,'의료기기명'  ,NULL,'TEXT','N','Y'),
 ('ADM008','*',3,'모델명'      ,NULL,'TEXT','N','Y'),
 ('ADM008','*',4,'수량'        ,NULL,'TEXT','N','Y'),
 ('ADM008','*',5,'폐기사유'    ,NULL,'TEXT','N','Y'),
 ('ADM008','*',6,'처리방법'    ,NULL,'TEXT','N','Y'),
 -- ADM009 · w51 관리대장
 ('ADM009','*',1,'날짜'              ,NULL,'TEXT','N','Y'),
 ('ADM009','*',2,'의료기기명'        ,NULL,'TEXT','N','Y'),
 ('ADM009','*',3,'구입/수리/회수내역',NULL,'TEXT','N','Y'),
 ('ADM009','*',4,'수리업체'          ,NULL,'TEXT','N','Y'),
 ('ADM009','*',5,'수리완료'          ,NULL,'TEXT','N','Y'),
 ('ADM009','*',6,'비고'              ,NULL,'TEXT','N','Y'),
 -- ADM010 · w56 서명대장 (원본은 좌우 2단 30행 — 60행 + 인쇄 30줄씩 나누기로 같은 모양)
 ('ADM010','*',1,'성함',NULL,'TEXT','N','Y'),
 ('ADM010','*',2,'서명',NULL,'TEXT','N','Y'),
 -- ADM011 · w26 환경관리 일일점검대장 (구역 그룹 rowspan)
 ('ADM011','*', 1,'바닥 청소(중간수준 소독제)'    ,'환자치료영역','CHECK','N','Y'),
 ('ADM011','*', 2,'로비 의자, 대기 장소 등'       ,'환자치료영역','CHECK','N','Y'),
 ('ADM011','*', 3,'각종 보관장 청결 관리'         ,'환자치료영역','CHECK','N','Y'),
 ('ADM011','*', 4,'휴지통 관리'                   ,'환자치료영역','CHECK','N','Y'),
 ('ADM011','*', 5,'화장실 청소 상태'              ,'공용구역'    ,'CHECK','N','Y'),
 ('ADM011','*', 6,'화장실 휴지통 관리'            ,'공용구역'    ,'CHECK','N','Y'),
 ('ADM011','*', 7,'창문, 창틀, 창턱 청결 (주1회 이상)','공용구역' ,'CHECK','N','Y'),
 ('ADM011','*', 8,'복도, 계단의 청결 상태'        ,'공용구역'    ,'CHECK','N','Y'),
 ('ADM011','*', 9,'물의 탁도 (이물질, 변색)'      ,'음용수'      ,'CHECK','N','Y'),
 ('ADM011','*',10,'냄새나 맛 이상 여부'           ,'음용수'      ,'CHECK','N','Y'),
 ('ADM011','*',11,'정수기의 위생 상태'            ,'음용수'      ,'CHECK','N','Y'),
 ('ADM011','*',12,'데스크 표면소독'               ,'행정구역'    ,'CHECK','N','Y'),
 ('ADM011','*',13,'각종 물품 선반의 표면 소독'    ,'행정구역'    ,'CHECK','N','Y'),
 ('ADM011','*',14,'청소도구의 구분 (화장실, 그 외)','기타'       ,'CHECK','N','Y'),
 ('ADM011','*',15,'각종 보호구의 상태확인'        ,'기타'        ,'CHECK','N','Y'),
 -- ADM012 · w49 일상점검표(의료기기) — 항목 6개가 머리에 나열되고 행은 기기 1~10
 ('ADM012','*',1,'전원 결합 여부'          ,NULL,'CHECK','N','Y'),
 ('ADM012','*',2,'청결 상태'               ,NULL,'CHECK','N','Y'),
 ('ADM012','*',3,'가동 이상 여부'          ,NULL,'CHECK','N','Y'),
 ('ADM012','*',4,'보관 상태'               ,NULL,'CHECK','N','Y'),
 ('ADM012','*',5,'저장 장소 비치 여부'     ,NULL,'CHECK','N','Y'),
 ('ADM012','*',6,'청소/소독 상태 점검'     ,NULL,'CHECK','N','Y');

-- ═══ ③ safeRpt 유형 14종 ════════════════════════════════════════════════════
INSERT INTO TBL_CODE_DTL
 (CODE_GB, CODE_CD, SUB_CODE, JOB_SEQ, SUB_CODE_NM, START_DT, END_DT, USE_YN, SORT, ACTION_YN, REG_USER) VALUES
 ('Q','QPS_SAFERPT_GB','RULEDRF',1,'규정 입안서'          ,'20000101','99991231','Y',31,'Y','system'),
 ('Q','QPS_SAFERPT_GB','HIREREQ',1,'신규 채용 상신서'     ,'20000101','99991231','Y',32,'Y','system'),
 ('Q','QPS_SAFERPT_GB','MANREQ' ,1,'인력 충원 요청서'     ,'20000101','99991231','Y',33,'Y','system'),
 ('Q','QPS_SAFERPT_GB','INFONOTI',1,'직원정보 변경 공고문','20000101','99991231','Y',34,'Y','system'),
 ('Q','QPS_SAFERPT_GB','INFOCHG',1,'직원 정보 변경 사항 제출서','20000101','99991231','Y',35,'Y','system'),
 ('Q','QPS_SAFERPT_GB','DUTYDOC',1,'당직의 근무일지'      ,'20000101','99991231','Y',36,'Y','system'),
 ('Q','QPS_SAFERPT_GB','HLTACT' ,1,'직원 건강증진활동 결과보고서','20000101','99991231','Y',37,'Y','system'),
 ('Q','QPS_SAFERPT_GB','EMPCERT',1,'재직증명서'           ,'20000101','99991231','Y',38,'Y','system'),
 ('Q','QPS_SAFERPT_GB','DRAFT'  ,1,'기안서(품의 및 보고)' ,'20000101','99991231','Y',39,'Y','system'),
 ('Q','QPS_SAFERPT_GB','DRAFTHR',1,'기안서 - 인사'        ,'20000101','99991231','Y',40,'Y','system'),
 ('Q','QPS_SAFERPT_GB','PRIVACY',1,'사생활보호신청서'     ,'20000101','99991231','Y',41,'Y','system'),
 ('Q','QPS_SAFERPT_GB','SELFDIS',1,'자의 퇴원서약서'      ,'20000101','99991231','Y',42,'Y','system'),
 ('Q','QPS_SAFERPT_GB','MDDISP' ,1,'의료기기 폐기 확인서' ,'20000101','99991231','Y',43,'Y','system'),
 ('Q','QPS_SAFERPT_GB','MDAS'   ,1,'의료기기 A/S 신청서'  ,'20000101','99991231','Y',44,'Y','system'),
 ('Q','QPS_SAFERPT_GB','CONSENT',1,'개인정보 수집 및 이용 동의서','20000101','99991231','Y',45,'Y','system'),
 ('Q','QPS_SAFERPT_GB','INJURY' ,1,'공상승인신청서'       ,'20000101','99991231','Y',46,'Y','system'),
 ('Q','QPS_SAFERPT_GB','MISSION',1,'미션을 이행하기 위한 활동','20000101','99991231','Y',47,'Y','system')
ON DUPLICATE KEY UPDATE SUB_CODE_NM=VALUES(SUB_CODE_NM), SORT=VALUES(SORT), USE_YN='Y', ACTION_YN='Y';

INSERT INTO TBL_QPS_SAFERPT_FORM
 (RPT_GB, SUB_NM, SUB_COLS, SIGN_LINE, FOOT_TXT, PHOTO_YN, LBL_JSON, USE_YN, REG_USER) VALUES
 -- w09 규정입안서 — 「개정 전|후」 = 반복행 2열
 ('RULEDRF','개정 전후 요약','개정 전,개정 후','제출자',NULL,NULL,
  '{"occurDt":"제출일자","occurTm":"-","rptDt":"-","place":"-","targetNm":"-","targetNo":"-","deptNm":"1. 부서명","positionNm":"-","admitDt":"-","diagNm":"2. 규정명","wWhen":"-","wWho":"-","wWhere":"-","wWhat":"-","wHow":"-","wWhy":"-","summary":"4. 입안이유 및 주요골자","vitalTxt":"-","injuryTxt":"-","treatTxt":"-","causeTxt":"-","planTxt":"-","note":"6. 비고"}','Y','system'),
 -- w11 신규채용상신서
 ('HIREREQ',NULL,NULL,'면접관',
  '채용조건 : 1.급여조건 :   2.담당업무 :   3.4대보험사항 :   4.수습여부 :   5.기타 :' ,NULL,
  '{"occurDt":"면접날짜","occurTm":"-","rptDt":"입사 년월일","place":"주소","targetNm":"성명","targetNo":"연락처","deptNm":"부서","positionNm":"담당업무","admitDt":"생년월일","diagNm":"학력 / 자격증","wWhen":"-","wWho":"-","wWhere":"-","wWhat":"경력","wHow":"-","wWhy":"-","summary":"면접 내용","vitalTxt":"-","injuryTxt":"-","treatTxt":"-","causeTxt":"평가","planTxt":"-","note":"첨부서류 : ▶이력서 ▶주민등록등본 ▶면허 및 자격증 ▶경력증명서(필요시) ▶채용검진/배치"}','Y','system'),
 -- w14 인력충원요청서 — 반복행(직급·인원·배치)
 ('MANREQ','충원 인력','직급,인원,배치',NULL,'제출처 : 총무부',NULL,
  '{"occurDt":"작성일","occurTm":"-","rptDt":"채용희망일자","place":"-","targetNm":"신청(작성)자 성명","targetNo":"연간충원인력수","deptNm":"소속","positionNm":"직위","admitDt":"-","diagNm":"-","wWhen":"-","wWho":"-","wWhere":"-","wWhat":"-","wHow":"-","wWhy":"-","summary":"현인원","vitalTxt":"담당업무","injuryTxt":"자격사항(전공·경력·필수자격증·우대사항·필요역량)","treatTxt":"-","causeTxt":"충원사유 및 충원 후 기대효과","planTxt":"-","note":"비고"}','Y','system'),
 -- w16 공고문 / w17 제출서
 ('INFONOTI',NULL,NULL,NULL,
  '인사정보 관리 규정에 따라 직원 정보 변경 제출서를 아래 기한까지 제출바랍니다.',NULL,
  '{"occurDt":"작성일","occurTm":"-","rptDt":"제출기한","place":"제출처","targetNm":"-","targetNo":"-","deptNm":"-","positionNm":"-","admitDt":"-","diagNm":"제목","wWhen":"-","wWho":"-","wWhere":"-","wWhat":"-","wHow":"-","wWhy":"-","summary":"본문","vitalTxt":"-","injuryTxt":"-","treatTxt":"-","causeTxt":"-","planTxt":"-","note":"-"}','Y','system'),
 ('INFOCHG','변경 사항','구분,변경전,변경후,비고',NULL,
  '※ 작성 후 원무부장에게 제출 부탁드립니다.',NULL,
  '{"occurDt":"작성일","occurTm":"-","rptDt":"-","place":"-","targetNm":"3. 성명","targetNo":"-","deptNm":"1. 소속","positionNm":"2. 직책","admitDt":"-","diagNm":"-","wWhen":"-","wWho":"-","wWhere":"-","wWhat":"-","wHow":"-","wWhy":"-","summary":"4. 변경사항","vitalTxt":"-","injuryTxt":"-","treatTxt":"-","causeTxt":"-","planTxt":"-","note":"-"}','Y','system'),
 -- w18 의사당직일지 (일 단위 · 시간대 3택은 체크 묶음)
 ('DUTYDOC',NULL,NULL,'당직의사',NULL,NULL,
  '{"occurDt":"근무일자","occurTm":"-","rptDt":"-","place":"-","targetNm":"당직의사","targetNo":"-","deptNm":"-","positionNm":"-","admitDt":"-","diagNm":"-","wWhen":"-","wWho":"-","wWhere":"-","wWhat":"-","wHow":"-","wWhy":"-","summary":"처치내용 1","vitalTxt":"처치내용 2","injuryTxt":"처치내용 3","treatTxt":"처치내용 4","causeTxt":"-","planTxt":"-","note":"특이사항"}','Y','system'),
 -- w24 직원 건강증진활동 결과보고서 — ★사진첨부
 ('HLTACT',NULL,NULL,NULL,NULL,'Y',
  '{"occurDt":"일 시","occurTm":"시 간","rptDt":"-","place":"장 소","targetNm":"-","targetNo":"참석인원","deptNm":"대 상","positionNm":"-","admitDt":"-","diagNm":"활동명","wWhen":"-","wWho":"-","wWhere":"-","wWhat":"-","wHow":"-","wWhy":"-","summary":"활동내용","vitalTxt":"-","injuryTxt":"-","treatTxt":"-","causeTxt":"-","planTxt":"결 과","note":"-"}','Y','system'),
 -- w27 재직증명서
 ('EMPCERT',NULL,NULL,'대표자',
  '상기와 같이 재직하고 있음을 증명합니다.',NULL,
  '{"occurDt":"발급일자","occurTm":"-","rptDt":"입 사 일 자","place":"주 소","targetNm":"성 명","targetNo":"연 락 처","deptNm":"담 당","positionNm":"직 책","admitDt":"생년월일","diagNm":"용 도","wWhen":"-","wWho":"-","wWhere":"-","wWhat":"-","wHow":"-","wWhy":"-","summary":"-","vitalTxt":"-","injuryTxt":"-","treatTxt":"-","causeTxt":"-","planTxt":"-","note":"-"}','Y','system'),
 -- w30 기안서 / w31 기안서-인사 (머리 공유, 본문만 다름)
 ('DRAFT',NULL,NULL,NULL,'아래와 같이 기안서(품의 및 보고)를 제출합니다.',NULL,
  '{"occurDt":"기안일자","occurTm":"-","rptDt":"발송일자","place":"-","targetNm":"기 안 자","targetNo":"문서번호","deptNm":"기안부서","positionNm":"협조부서","admitDt":"-","diagNm":"제 목","wWhen":"-","wWho":"수 신","wWhere":"참 조","wWhat":"-","wHow":"-","wWhy":"-","summary":"본문","vitalTxt":"-","injuryTxt":"-","treatTxt":"-","causeTxt":"-","planTxt":"-","note":"-"}','Y','system'),
 ('DRAFTHR','인력운영계획','구분,현직종,현재원,필요직종,필요인원',NULL,
  '아래와 같이 기안서(품의 및 보고)를 제출합니다.',NULL,
  '{"occurDt":"기안일자","occurTm":"-","rptDt":"희망근무개시일","place":"근무부서(실근무지)","targetNm":"기 안 자","targetNo":"문서번호","deptNm":"기안부서","positionNm":"직종","admitDt":"-","diagNm":"제 목","wWhen":"-","wWho":"수 신","wWhere":"참 조","wWhat":"-","wHow":"-","wWhy":"-","summary":"채용사유 상세내용","vitalTxt":"-","injuryTxt":"-","treatTxt":"-","causeTxt":"-","planTxt":"-","note":"첨 부"}','Y','system'),
 -- w32 사생활보호신청서 / w33 자의 퇴원서약서
 ('PRIVACY',NULL,NULL,'환자 또는 보호자',NULL,NULL,
  '{"occurDt":"신청일자","occurTm":"-","rptDt":"-","place":"-","targetNm":"환자성명","targetNo":"등록번호","deptNm":"-","positionNm":"-","admitDt":"-","diagNm":"-","wWhen":"-","wWho":"-","wWhere":"-","wWhat":"-","wHow":"-","wWhy":"-","summary":"요청 내용","vitalTxt":"-","injuryTxt":"-","treatTxt":"-","causeTxt":"-","planTxt":"-","note":"-"}','Y','system'),
 ('SELFDIS',NULL,NULL,'환자,보호자,담당의사',NULL,NULL,
  '{"occurDt":"작성일자","occurTm":"-","rptDt":"-","place":"-","targetNm":"환자성명","targetNo":"등록번호","deptNm":"-","positionNm":"-","admitDt":"입원일","diagNm":"진단명","wWhen":"-","wWho":"-","wWhere":"-","wWhat":"-","wHow":"-","wWhy":"-","summary":"퇴원 사유","vitalTxt":"-","injuryTxt":"-","treatTxt":"-","causeTxt":"-","planTxt":"-","note":"-"}','Y','system'),
 -- w39 폐기 확인서 / w40 A/S 신청서
 ('MDDISP',NULL,NULL,'확인자',NULL,NULL,
  '{"occurDt":"폐기일자","occurTm":"-","rptDt":"-","place":"설치장소","targetNm":"의료기기명","targetNo":"모델명 / S/N","deptNm":"사용부서","positionNm":"-","admitDt":"구입일자","diagNm":"제조사","wWhen":"-","wWho":"-","wWhere":"-","wWhat":"-","wHow":"-","wWhy":"-","summary":"폐기 사유","vitalTxt":"-","injuryTxt":"-","treatTxt":"처리 방법","causeTxt":"-","planTxt":"-","note":"비고"}','Y','system'),
 ('MDAS',NULL,NULL,'신청자',NULL,NULL,
  '{"occurDt":"신청일자","occurTm":"-","rptDt":"-","place":"설치장소","targetNm":"의료기기명","targetNo":"모델명 / S/N","deptNm":"사용부서","positionNm":"-","admitDt":"-","diagNm":"제조사","wWhen":"-","wWho":"-","wWhere":"-","wWhat":"-","wHow":"-","wWhy":"-","summary":"고장 내용","vitalTxt":"-","injuryTxt":"-","treatTxt":"조치 내용","causeTxt":"-","planTxt":"-","note":"비고"}','Y','system'),
 -- w50 개인정보 동의서 / w52 공상승인신청서 / w58 미션 활동(사진)
 ('CONSENT',NULL,NULL,'성 명',NULL,NULL,
  '{"occurDt":"동의일자","occurTm":"-","rptDt":"-","place":"-","targetNm":"성 명","targetNo":"생년월일","deptNm":"-","positionNm":"-","admitDt":"-","diagNm":"-","wWhen":"-","wWho":"-","wWhere":"-","wWhat":"-","wHow":"-","wWhy":"-","summary":"수집·이용 목적 및 항목","vitalTxt":"보유·이용 기간","injuryTxt":"-","treatTxt":"-","causeTxt":"-","planTxt":"-","note":"-"}','Y','system'),
 ('INJURY',NULL,NULL,'신청인,부서장',
  '상기와 같이 공상 처리를 요청하오니 승인하여 주시기 바랍니다.',NULL,
  '{"occurDt":"신청일자","occurTm":"-","rptDt":"-","place":"-","targetNm":"1. 성명","targetNo":"-","deptNm":"1. 부서","positionNm":"1. 직위","admitDt":"-","diagNm":"-","wWhen":"-","wWho":"-","wWhere":"-","wWhat":"-","wHow":"-","wWhy":"-","summary":"2. 공상내용(육하원칙에 의거 기술)","vitalTxt":"3-가. 진료비 감면(현재까지의 진료비)","injuryTxt":"3-나. 요양 기간 중 공가 처리","treatTxt":"-","causeTxt":"-","planTxt":"-","note":"-"}','Y','system'),
 ('MISSION',NULL,NULL,NULL,NULL,'Y',
  '{"occurDt":"일 시","occurTm":"-","rptDt":"-","place":"장 소","targetNm":"-","targetNo":"참석인원","deptNm":"대 상","positionNm":"-","admitDt":"-","diagNm":"활동명","wWhen":"-","wWho":"-","wWhere":"-","wWhat":"-","wHow":"-","wWhy":"-","summary":"활동내용","vitalTxt":"-","injuryTxt":"-","treatTxt":"-","causeTxt":"-","planTxt":"결 과","note":"-"}','Y','system')
ON DUPLICATE KEY UPDATE SUB_NM=VALUES(SUB_NM), SUB_COLS=VALUES(SUB_COLS), SIGN_LINE=VALUES(SIGN_LINE),
  FOOT_TXT=VALUES(FOOT_TXT), PHOTO_YN=VALUES(PHOTO_YN), LBL_JSON=VALUES(LBL_JSON), USE_YN='Y';

-- ═══ ④ 체크 묶음 — 유형이 요구하는 것만 ═════════════════════════════════════
DELETE FROM TBL_QPS_SAFERPT_USE WHERE RPT_GB IN ('RULEDRF','MANREQ','DUTYDOC','PRIVACY','SELFDIS','DRAFTHR');
DELETE FROM TBL_QPS_SAFERPT_DEF WHERE RPT_GB IN ('RULEDRF','MANREQ','DUTYDOC','PRIVACY','SELFDIS','DRAFTHR');

INSERT INTO TBL_QPS_SAFERPT_DEF (RPT_GB,GRP_CD,GRP_NM,ITEM_NM,MULTI_YN,ETC_YN,SORT,USE_YN) VALUES
 -- w09 입안형태 3택
 ('RULEDRF','DRFGB','3. 입안형태','제정','N','N',1,'Y'),
 ('RULEDRF','DRFGB','3. 입안형태','개정','N','N',2,'Y'),
 ('RULEDRF','DRFGB','3. 입안형태','폐지','N','N',3,'Y'),
 -- w14 채용유형 3택(기타 부기) · 채용구분 2택
 ('MANREQ','HIREGB','채용유형','증원'      ,'N','Y',1,'Y'),
 ('MANREQ','HIREGB','채용유형','퇴사자후임','N','Y',2,'Y'),
 ('MANREQ','HIREGB','채용유형','기타'      ,'N','Y',3,'Y'),
 ('MANREQ','EMPGB' ,'채용구분','정규직'  ,'N','N',1,'Y'),
 ('MANREQ','EMPGB' ,'채용구분','비정규직','N','N',2,'Y'),
 -- w18 당직 시간대 3택
 ('DUTYDOC','DUTYTM','일 시','평일 18:00~익일 09:00'        ,'N','N',1,'Y'),
 ('DUTYDOC','DUTYTM','일 시','토요일 13:00~익일 09:00'      ,'N','N',2,'Y'),
 ('DUTYDOC','DUTYTM','일 시','일요일 및 공휴일 09:00~익일 09:00','N','N',3,'Y'),
 -- w32 요청항목(복수) + 설명확인 2택
 ('PRIVACY','REQIT','요청항목','병실 및 입원 사실 비공개','Y','N',1,'Y'),
 ('PRIVACY','REQIT','요청항목','진료비 관련 문의 제한'   ,'Y','N',2,'Y'),
 ('PRIVACY','REQIT','요청항목','환자 상태 문의 제한'     ,'Y','N',3,'Y'),
 ('PRIVACY','REQIT','요청항목','면회 제한'               ,'Y','N',4,'Y'),
 ('PRIVACY','REQIT','요청항목','기타'                    ,'Y','Y',5,'Y'),
 ('PRIVACY','SIGNBY','신청인 구분','본인(환자)','N','N',1,'Y'),
 ('PRIVACY','SIGNBY','신청인 구분','보호자'     ,'N','N',2,'Y'),
 -- w33 퇴원 사유 4택
 ('SELFDIS','DISRSN','퇴원 사유','치료 거부'      ,'N','N',1,'Y'),
 ('SELFDIS','DISRSN','퇴원 사유','타 병원 전원'   ,'N','N',2,'Y'),
 ('SELFDIS','DISRSN','퇴원 사유','경제적 사유'    ,'N','N',3,'Y'),
 ('SELFDIS','DISRSN','퇴원 사유','기타'           ,'N','Y',4,'Y'),
 -- w31 기안서-인사 : 근무형태 5 · 고용형태 3 · 채용정보 3 · 채용사유 4
 ('DRAFTHR','WORKGB','근무형태','Day'  ,'N','N',1,'Y'),
 ('DRAFTHR','WORKGB','근무형태','2교대','N','N',2,'Y'),
 ('DRAFTHR','WORKGB','근무형태','3교대','N','N',3,'Y'),
 ('DRAFTHR','WORKGB','근무형태','Night','N','N',4,'Y'),
 ('DRAFTHR','WORKGB','근무형태','기타' ,'N','Y',5,'Y'),
 ('DRAFTHR','EMPGB2','고용형태','정규직','N','N',1,'Y'),
 ('DRAFTHR','EMPGB2','고용형태','계약직','N','N',2,'Y'),
 ('DRAFTHR','EMPGB2','고용형태','임시직','N','N',3,'Y'),
 ('DRAFTHR','HIREINFO','채용정보','채용광고(온라인,신문등)','N','N',1,'Y'),
 ('DRAFTHR','HIREINFO','채용정보','지인소개','N','N',2,'Y'),
 ('DRAFTHR','HIREINFO','채용정보','기타'    ,'N','Y',3,'Y'),
 ('DRAFTHR','HIRERSN','채용사유','전임자 퇴사'            ,'N','N',1,'Y'),
 ('DRAFTHR','HIRERSN','채용사유','업무량증가에 따른 충원' ,'N','N',2,'Y'),
 ('DRAFTHR','HIRERSN','채용사유','신규업무에 따른 충원'   ,'N','N',3,'Y'),
 ('DRAFTHR','HIRERSN','채용사유','기타사유'               ,'N','N',4,'Y');

INSERT INTO TBL_QPS_SAFERPT_USE (RPT_GB,GRP_CD,SORT,USE_YN) VALUES
 ('RULEDRF','DRFGB',1,'Y'),
 ('MANREQ','HIREGB',1,'Y'), ('MANREQ','EMPGB',2,'Y'),
 ('DUTYDOC','DUTYTM',1,'Y'),
 ('PRIVACY','REQIT',1,'Y'), ('PRIVACY','SIGNBY',2,'Y'),
 ('SELFDIS','DISRSN',1,'Y'),
 ('DRAFTHR','WORKGB',1,'Y'), ('DRAFTHR','EMPGB2',2,'Y'),
 ('DRAFTHR','HIREINFO',3,'Y'), ('DRAFTHR','HIRERSN',4,'Y');

-- ── 확인 ────────────────────────────────────────────────────────────────────
SELECT FORM_ID, FORM_NM, AXIS_GB, PRD_GB,
       (SELECT COUNT(*) FROM TBL_QPS_CHK_ITEM i WHERE i.FORM_ID=f.FORM_ID AND i.HOSP_CD='*') items
  FROM TBL_QPS_CHK_FORM f WHERE f.HOSP_CD='*' AND FORM_ID BETWEEN 'ADM005' AND 'ADM012' ORDER BY FORM_ID;
SELECT COUNT(*) AS saferpt_types FROM TBL_CODE_DTL WHERE CODE_CD='QPS_SAFERPT_GB' AND USE_YN='Y';
SELECT RPT_GB, JSON_VALID(LBL_JSON) ok, IFNULL(PHOTO_YN,'-') ph, IFNULL(SUB_COLS,'-') cols
  FROM TBL_QPS_SAFERPT_FORM WHERE RPT_GB IN
  ('RULEDRF','HIREREQ','MANREQ','INFONOTI','INFOCHG','DUTYDOC','HLTACT','EMPCERT','DRAFT','DRAFTHR',
   'PRIVACY','SELFDIS','MDDISP','MDAS','CONSENT','INJURY','MISSION') ORDER BY RPT_GB;
SELECT RPT_GB, COUNT(DISTINCT GRP_CD) grps, COUNT(*) items FROM TBL_QPS_SAFERPT_DEF
 WHERE RPT_GB IN ('RULEDRF','MANREQ','DUTYDOC','PRIVACY','SELFDIS','DRAFTHR') GROUP BY RPT_GB;
