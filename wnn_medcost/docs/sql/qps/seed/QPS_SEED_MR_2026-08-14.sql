-- ═══════════════════════════════════════════════════════════════════════════
-- 의무기록(MEDREC) 시드 — 점검표 11종 + safeRpt 유형 15종 (2026-08-14)
--   판독 정본 : docs/proposals/QPS_서식판독_기타모듈_2026-08-14.md §MR_판독 (MR01~MR30)
--   전제 : QPS_DDL_SAFERPT_PHOTO / _LBL 적용 후. 부서 코드 MEDREC 은 아래 ①에서 신설.
--
--   이 부서는 **신청서·동의서·대장**이 주류다 — 점검표 격자는 2종(MR17·18)뿐.
--   법정 양식 3종(MR01 의료법 시행규칙 별지 제9호의3 · MR25·26 개인정보보호법)이 포함된다.
--
-- ═══ ⛔등록 금지·제외 3종 ═══
--   MR29 직원 교육 결과 보고서 — **껍데기**(「준비중인 메뉴 입니다!」 팝업만, 문서 없음). SUNWOO 쪽 미연결
--   MR30 사내교육보고서       — 열면 「직원 교육 결과 보고서」가 뜬다(오연결). 내용 = `EDURPT` 와 같은 판 ⇒ **중복**
--   MR13 퇴원환자 의무기록 현황 — **기능성 조사 화면**(환자 1~10 열 × 인증기준 ME 항목 행 + [퇴원환자관리] 버튼).
--       ⚠트리는 「-요양」인데 문서 제목은 「-정신」이다(서식정보 6 = 변형 존재 시사) ⇒ **요양판 확인 후**.
--       구조도 「항목 × 날짜 아닌 고정 열」 계열이라 그 조각 설계에 합산(WM w20/21·RN16 과 같은 갈래)
--
-- ═══ ⛔보류 1종 ═══
--   MR14 퇴원환자의무기록 완결도 조사 — 결재란 + **의사별/병동별 통계표 2벌**(총계 자동 합산).
--       반복행 표가 한 문서에 2벌이라 현 safeRpt 확장(1벌)으로 안 담긴다(w13 인사기록카드와 같은 한계)
--
-- ═══ 원본 그대로 옮긴 것 ═══
--   MR14 「2021년 6월」 하드코딩 · MR16/MR24 기본값 2022-12-31 — **시드에 넣지 않는다**(문서 값이지 서식이 아니다)
-- 재실행 안전(DELETE 후 INSERT · ON DUPLICATE KEY).
-- ═══════════════════════════════════════════════════════════════════════════

INSERT INTO TBL_CODE_DTL
 (CODE_GB, CODE_CD, SUB_CODE, JOB_SEQ, SUB_CODE_NM, START_DT, END_DT, USE_YN, SORT, ACTION_YN, REG_USER) VALUES
 ('Q','QPS_CHK_DEPT','MEDREC',1,'의무기록','20000101','99991231','Y',110,'Y','system')
ON DUPLICATE KEY UPDATE SUB_CODE_NM=VALUES(SUB_CODE_NM), SORT=VALUES(SORT), USE_YN='Y', ACTION_YN='Y';

DELETE FROM TBL_QPS_CHK_ITEM WHERE HOSP_CD='*' AND FORM_ID LIKE 'MRC%';
DELETE FROM TBL_QPS_CHK_FORM WHERE HOSP_CD='*' AND FORM_ID LIKE 'MRC%';

-- ═══ ② 점검표 11종 (LIST 7 · DAY_ITEM 2 · ITEM_MONTH 2) ════════════════════
INSERT INTO TBL_QPS_CHK_FORM
 (FORM_ID, HOSP_CD, FORM_NM, CATE_CD, DEPT_CD, AXIS_GB, PRD_GB, PRD_KIND, EQUIP_CNT,
  NOTE_NM, SIGNER_YN, NOTE_YN, FIX_YN, SORT_NO, USE_YN, REG_USER) VALUES
 -- LIST 7종
 ('MRC001','*','의무기록 열람·대출 대장(종이)','ETC','MEDREC','LIST','M',NULL,30,NULL,'N','N','N',1810,'Y','system'),
 ('MRC002','*','의무기록 폐기관리대장'        ,'ETC','MEDREC','LIST','M',NULL,20,NULL,'N','N','N',1820,'Y','system'),
 ('MRC003','*','의무기록 금기약어 수정관리대장','ETC','MEDREC','LIST','Y',NULL,20,NULL,'N','N','N',1830,'Y','system'),
 ('MRC004','*','정보시스템 접속기록 모니터링 대장(월별)','ETC','MEDREC','LIST','M',NULL,15,
  '점검자 의견 (필요시 기재)','N','Y','N',1840,'Y','system'),
 ('MRC005','*','의무기록 접근권한 모니터링 대장(분기)','ETC','MEDREC','LIST','Q',NULL,10,
  '점검자 의견','N','Y','N',1850,'Y','system'),
 ('MRC006','*','의무기록 파기관리대장'        ,'ETC','MEDREC','LIST','M',NULL,30,NULL,'N','N','N',1860,'Y','system'),
 ('MRC007','*','의무기록 사본발급대장'        ,'ETC','MEDREC','LIST','M',NULL,30,NULL,'N','N','N',1870,'Y','system'),
 -- DAY_ITEM 2종 (일 1~31 행)
 ('MRC008','*','의무기록실 온·습도 점검일지'  ,'ENV','MEDREC','DAY_ITEM','M','D',10,NULL,'N','N','N',1880,'Y','system'),
 ('MRC009','*','통제구역 출입자 관리대장(의무기록)','SAFE','MEDREC','DAY_ITEM','M','D',10,NULL,'N','N','N',1890,'Y','system'),
 -- ITEM_MONTH 2종 (1~12월 · 연 문서)
 ('MRC010','*','의무기록 열람·대출 통계'      ,'ETC','MEDREC','ITEM_MONTH','Y',NULL,10,NULL,'N','N','N',1900,'Y','system'),
 ('MRC011','*','금기약어 및 기호 사용 모니터링 대장(월1회)','ETC','MEDREC','ITEM_MONTH','Y',NULL,10,
  '점검자 의견','N','Y','N',1910,'Y','system');

INSERT INTO TBL_QPS_CHK_ITEM (FORM_ID,HOSP_CD,SORT,ITEM_NM,GRP_NM,INPUT_GB,CARRY_YN,USE_YN) VALUES
 -- MRC001 · MR08
 ('MRC001','*',1,'등록번호'            ,NULL,'TEXT','N','Y'),
 ('MRC001','*',2,'환자명'              ,NULL,'TEXT','N','Y'),
 ('MRC001','*',3,'일자'                ,NULL,'TEXT','N','Y'),
 ('MRC001','*',4,'종류'                ,NULL,'TEXT','N','Y'),
 ('MRC001','*',5,'열람 및 대출 사유'   ,NULL,'TEXT','N','Y'),
 ('MRC001','*',6,'신청인'              ,NULL,'TEXT','N','Y'),
 ('MRC001','*',7,'반납일자'            ,NULL,'TEXT','N','Y'),
 ('MRC001','*',8,'확인'                ,NULL,'TEXT','N','Y'),
 ('MRC001','*',9,'비고'                ,NULL,'TEXT','N','Y'),
 -- MRC002 · MR09
 ('MRC002','*',1,'종류'    ,NULL,'TEXT','N','Y'),
 ('MRC002','*',2,'폐기 사유',NULL,'TEXT','N','Y'),
 ('MRC002','*',3,'폐기일자',NULL,'TEXT','N','Y'),
 ('MRC002','*',4,'신청자'  ,NULL,'TEXT','N','Y'),
 ('MRC002','*',5,'비고'    ,NULL,'TEXT','N','Y'),
 -- MRC003 · MR15 (수정 전/후 = 2단 열 묶음)
 ('MRC003','*',1,'날짜'            ,NULL      ,'TEXT','N','Y'),
 ('MRC003','*',2,'사용부서·사용직원',NULL      ,'TEXT','N','Y'),
 ('MRC003','*',3,'수정 전'         ,'수정사항','TEXT','N','Y'),
 ('MRC003','*',4,'수정 후'         ,'수정사항','TEXT','N','Y'),
 ('MRC003','*',5,'작성자 서명'     ,NULL      ,'TEXT','N','Y'),
 ('MRC003','*',6,'확인자 서명'     ,NULL      ,'TEXT','N','Y'),
 ('MRC003','*',7,'비고'            ,NULL      ,'TEXT','N','Y'),
 -- MRC004 · MR19
 ('MRC004','*',1,'부서 (총 건수)'                          ,NULL,'TEXT','N','Y'),
 ('MRC004','*',2,'비인가자의 정보시스템 접속여부'          ,NULL,'TEXT','N','Y'),
 ('MRC004','*',3,'개인정보의 쓰기·수정·삭제·출력(권한 및 절차)',NULL,'TEXT','N','Y'),
 ('MRC004','*',4,'비정상적 많은 데이터 다운로드'           ,NULL,'TEXT','N','Y'),
 ('MRC004','*',5,'비정상적 접속기록'                       ,NULL,'TEXT','N','Y'),
 -- MRC005 · MR20
 ('MRC005','*',1,'점검일자'      ,NULL          ,'TEXT','N','Y'),
 ('MRC005','*',2,'부서'          ,'점검대상인원','TEXT','N','Y'),
 ('MRC005','*',3,'직종'          ,'점검대상인원','TEXT','N','Y'),
 ('MRC005','*',4,'인원수'        ,'점검대상인원','TEXT','N','Y'),
 ('MRC005','*',5,'접근권한표와 대조(이상없음/이상발견)',NULL,'TEXT','N','Y'),
 ('MRC005','*',6,'이상 내용'     ,'이상발견 시 조치사항','TEXT','N','Y'),
 ('MRC005','*',7,'조치사항'      ,'이상발견 시 조치사항','TEXT','N','Y'),
 -- MRC006 · MR22
 ('MRC006','*',1,'등록번호'      ,NULL,'TEXT','N','Y'),
 ('MRC006','*',2,'환자명'        ,NULL,'TEXT','N','Y'),
 ('MRC006','*',3,'의무기록구분'  ,NULL,'TEXT','N','Y'),
 ('MRC006','*',4,'파기사유'      ,NULL,'TEXT','N','Y'),
 ('MRC006','*',5,'파기일'        ,NULL,'TEXT','N','Y'),
 ('MRC006','*',6,'확인자'        ,NULL,'TEXT','N','Y'),
 -- MRC007 · MR23
 ('MRC007','*',1,'신청일자'      ,NULL,'TEXT','N','Y'),
 ('MRC007','*',2,'환자번호'      ,NULL,'TEXT','N','Y'),
 ('MRC007','*',3,'환자성명'      ,NULL,'TEXT','N','Y'),
 ('MRC007','*',4,'신청자'        ,NULL,'TEXT','N','Y'),
 ('MRC007','*',5,'환자와의관계'  ,NULL,'TEXT','N','Y'),
 ('MRC007','*',6,'서식명'        ,NULL,'TEXT','N','Y'),
 ('MRC007','*',7,'발급부수'      ,NULL,'TEXT','N','Y'),
 -- MRC008 · MR17
 ('MRC008','*',1,'온도'  ,NULL,'NUM' ,'N','Y'),
 ('MRC008','*',2,'습도'  ,NULL,'NUM' ,'N','Y'),
 ('MRC008','*',3,'점검자',NULL,'TEXT','N','Y'),
 -- MRC009 · MR18
 ('MRC009','*',1,'출입자 소속',NULL,'TEXT','N','Y'),
 ('MRC009','*',2,'직급'      ,NULL,'TEXT','N','Y'),
 ('MRC009','*',3,'성명'      ,NULL,'TEXT','N','Y'),
 ('MRC009','*',4,'용무'      ,NULL,'TEXT','N','Y'),
 ('MRC009','*',5,'출입시간 시작',NULL,'TEXT','N','Y'),
 ('MRC009','*',6,'출입시간 종료',NULL,'TEXT','N','Y'),
 ('MRC009','*',7,'결재'      ,NULL,'TEXT','N','Y'),
 -- MRC010 · MR07
 ('MRC010','*',1,'발생건수',NULL,'NUM' ,'N','Y'),
 ('MRC010','*',2,'비고'    ,NULL,'TEXT','N','Y'),
 -- MRC011 · MR21
 ('MRC011','*',1,'건수'            ,'점검대상인원','TEXT','N','Y'),
 ('MRC011','*',2,'차트번호·환자명' ,'점검대상인원','TEXT','N','Y'),
 ('MRC011','*',3,'서식명'          ,'점검대상인원','TEXT','N','Y'),
 ('MRC011','*',4,'사용일자'        ,'점검대상인원','TEXT','N','Y'),
 ('MRC011','*',5,'약어·기호'       ,'점검대상인원','TEXT','N','Y'),
 ('MRC011','*',6,'점검자'          ,'수정 확인'  ,'TEXT','N','Y'),
 ('MRC011','*',7,'담당자'          ,'수정 확인'  ,'TEXT','N','Y');

-- ═══ ③ safeRpt 유형 15종 ═══════════════════════════════════════════════════
INSERT INTO TBL_CODE_DTL
 (CODE_GB, CODE_CD, SUB_CODE, JOB_SEQ, SUB_CODE_NM, START_DT, END_DT, USE_YN, SORT, ACTION_YN, REG_USER) VALUES
 ('Q','QPS_SAFERPT_GB','MRPROXY',1,'진료기록 열람 및 사본 발급 위임장','20000101','99991231','Y',51,'Y','system'),
 ('Q','QPS_SAFERPT_GB','IDREQ'  ,1,'신규 ID발급 신청서'      ,'20000101','99991231','Y',52,'Y','system'),
 ('Q','QPS_SAFERPT_GB','ABBRRPT',1,'금기약어, 금기기호 목록 보고서','20000101','99991231','Y',53,'Y','system'),
 ('Q','QPS_SAFERPT_GB','SECOATH',1,'보안서약서'              ,'20000101','99991231','Y',54,'Y','system'),
 ('Q','QPS_SAFERPT_GB','MRCOPY' ,1,'의무기록 사본발급(열람) 신청서(환자 및 보호자용)','20000101','99991231','Y',55,'Y','system'),
 ('Q','QPS_SAFERPT_GB','MRLOAN' ,1,'의무기록 사본발급(열람) 신청서(직원용)','20000101','99991231','Y',56,'Y','system'),
 ('Q','QPS_SAFERPT_GB','MRDISP' ,1,'의무기록 폐기신청서'     ,'20000101','99991231','Y',57,'Y','system'),
 ('Q','QPS_SAFERPT_GB','MRDMG'  ,1,'의무기록 훼손·분실(경위) 보고서','20000101','99991231','Y',58,'Y','system'),
 ('Q','QPS_SAFERPT_GB','MRAGREE',1,'진료기록 열람 및 사본발급 동의서','20000101','99991231','Y',59,'Y','system'),
 ('Q','QPS_SAFERPT_GB','MRLOST' ,1,'의무기록 분실보고서'     ,'20000101','99991231','Y',60,'Y','system'),
 ('Q','QPS_SAFERPT_GB','MRFIX'  ,1,'의무기록 정정 신청서'    ,'20000101','99991231','Y',61,'Y','system'),
 ('Q','QPS_SAFERPT_GB','PIILEAK',1,'개인정보 유출신고(보고)서','20000101','99991231','Y',62,'Y','system'),
 ('Q','QPS_SAFERPT_GB','PIINOTI',1,'개인정보 유출 통지서'    ,'20000101','99991231','Y',63,'Y','system'),
 ('Q','QPS_SAFERPT_GB','SYSAUTH',1,'정보시스템 사용 권한 신청서','20000101','99991231','Y',64,'Y','system'),
 ('Q','QPS_SAFERPT_GB','CCTVREQ',1,'CCTV 녹화검색 및 동영상 사본 신청서','20000101','99991231','Y',65,'Y','system')
ON DUPLICATE KEY UPDATE SUB_CODE_NM=VALUES(SUB_CODE_NM), SORT=VALUES(SORT), USE_YN='Y', ACTION_YN='Y';

INSERT INTO TBL_QPS_SAFERPT_FORM
 (RPT_GB, SUB_NM, SUB_COLS, SIGN_LINE, FOOT_TXT, PHOTO_YN, LBL_JSON, USE_YN, REG_USER) VALUES
 -- MR01 위임장(법정 — 의료법 시행규칙 별지 제9호의3)
 ('MRPROXY',NULL,NULL,'위임인',
  '「의료법」 제21조제3항 및 같은 법 시행규칙 제13조의3에 따라 위와 같이 위임합니다.',NULL,
  '{"occurDt":"작성일","occurTm":"-","rptDt":"-","place":"수임인 주소","targetNm":"수임인 성명","targetNo":"수임인 생년월일(외국인등록번호)","deptNm":"위임인과의 관계","positionNm":"수임인 전화번호","admitDt":"-","diagNm":"-","wWhen":"-","wWho":"위임인 성명","wWhere":"위임인 주소","wWhat":"위임인 생년월일(외국인등록번호)","wHow":"위임인 전화번호","wWhy":"-","summary":"위임 범위","vitalTxt":"-","injuryTxt":"-","treatTxt":"-","causeTxt":"-","planTxt":"-","note":"-"}','Y','system'),
 -- MR02 신규 ID발급 신청서
 ('IDREQ',NULL,NULL,'신청자,관리책임자',NULL,NULL,
  '{"occurDt":"신청일","occurTm":"-","rptDt":"-","place":"이용장소","targetNm":"성명","targetNo":"생년월일","deptNm":"근무부서","positionNm":"직위","admitDt":"-","diagNm":"신청계정(이용자 ID)","wWhen":"이용기간","wWho":"휴대폰번호","wWhere":"주소","wWhat":"담당업무","wHow":"면허번호","wWhy":"-","summary":"필독사항 확인 내용","vitalTxt":"-","injuryTxt":"-","treatTxt":"-","causeTxt":"-","planTxt":"-","note":"-"}','Y','system'),
 -- MR03 금기약어 보고서 — 반복행 4열
 ('ABBRRPT','금기약어, 기호 목록','약어,영문명,금지 사유,권장 용어',NULL,
  '1. 금기약어·기호 목록은 운영위원회에서 지정한다.  2. 1년마다 재검토하여 결정한다.  3. 컴퓨터 부착 등 임의 사용을 금지한다.  4. 지속적으로 관리한다.',NULL,
  '{"occurDt":"보고일","occurTm":"-","rptDt":"-","place":"-","targetNm":"-","targetNo":"-","deptNm":"-","positionNm":"-","admitDt":"-","diagNm":"-","wWhen":"-","wWho":"-","wWhere":"-","wWhat":"-","wHow":"-","wWhy":"-","summary":"-","vitalTxt":"-","injuryTxt":"-","treatTxt":"-","causeTxt":"-","planTxt":"-","note":"비고"}','Y','system'),
 -- MR04 보안서약서
 ('SECOATH',NULL,NULL,'서약인',NULL,NULL,
  '{"occurDt":"서약일","occurTm":"-","rptDt":"-","place":"-","targetNm":"성명","targetNo":"주민등록번호","deptNm":"부서","positionNm":"-","admitDt":"-","diagNm":"-","wWhen":"-","wWho":"-","wWhere":"-","wWhat":"-","wHow":"-","wWhy":"-","summary":"서약 내용","vitalTxt":"-","injuryTxt":"-","treatTxt":"-","causeTxt":"-","planTxt":"-","note":"-"}','Y','system'),
 -- MR05 사본발급 신청서(환자·보호자용)
 ('MRCOPY',NULL,NULL,'신청인',NULL,NULL,
  '{"occurDt":"신청일","occurTm":"-","rptDt":"-","place":"-","targetNm":"환자이름","targetNo":"등록번호","deptNm":"진료과","positionNm":"환자와의 관계","admitDt":"-","diagNm":"주치의","wWhen":"-","wWho":"신청인","wWhere":"연락처","wWhat":"사본발급 부분","wHow":"-","wWhy":"신청목적","summary":"제출서류 확인","vitalTxt":"-","injuryTxt":"-","treatTxt":"-","causeTxt":"-","planTxt":"-","note":"-"}','Y','system'),
 -- MR06 사본발급 신청서(직원용)
 ('MRLOAN',NULL,NULL,'신청인,확인자(보건의료정보관리사)',NULL,NULL,
  '{"occurDt":"신청일","occurTm":"-","rptDt":"대출·열람기한","place":"-","targetNm":"환자 성명","targetNo":"등록번호","deptNm":"신청인 부서","positionNm":"신청인 성명","admitDt":"-","diagNm":"-","wWhen":"기간","wWho":"연락처","wWhere":"-","wWhat":"구분","wHow":"-","wWhy":"-","summary":"대출·열람 사유 및 용도","vitalTxt":"-","injuryTxt":"-","treatTxt":"-","causeTxt":"-","planTxt":"-","note":"-"}','Y','system'),
 -- MR10 폐기신청서
 ('MRDISP',NULL,NULL,'신청인',NULL,NULL,
  '{"occurDt":"신청일","occurTm":"-","rptDt":"-","place":"-","targetNm":"신청자 성명","targetNo":"-","deptNm":"부서","positionNm":"-","admitDt":"-","diagNm":"-","wWhen":"기간","wWho":"-","wWhere":"-","wWhat":"-","wHow":"-","wWhy":"폐기 사유","summary":"-","vitalTxt":"-","injuryTxt":"-","treatTxt":"-","causeTxt":"-","planTxt":"-","note":"-"}','Y','system'),
 -- MR11 훼손·분실 보고서
 ('MRDMG',NULL,NULL,'신청인',NULL,NULL,
  '{"occurDt":"보고일","occurTm":"-","rptDt":"대출일자","place":"-","targetNm":"환자이름","targetNo":"등록번호","deptNm":"-","positionNm":"-","admitDt":"생년월일(성별)","diagNm":"-","wWhen":"진료기간","wWho":"-","wWhere":"-","wWhat":"범위","wHow":"대출목적","wWhy":"-","summary":"사유","vitalTxt":"-","injuryTxt":"-","treatTxt":"-","causeTxt":"-","planTxt":"-","note":"-"}','Y','system'),
 -- MR12 열람·사본발급 동의서(법정)
 ('MRAGREE',NULL,NULL,'신청인',
  '「의료법」 제21조제2항에 따라 위와 같이 동의합니다.',NULL,
  '{"occurDt":"작성일","occurTm":"-","rptDt":"-","place":"환자 주소","targetNm":"환자 성명","targetNo":"환자 주민등록번호(외국인등록번호)","deptNm":"환자와의 관계","positionNm":"환자 연락처","admitDt":"-","diagNm":"-","wWhen":"-","wWho":"신청인 성명","wWhere":"신청인 주소","wWhat":"신청인 주민등록번호","wHow":"신청인 연락처","wWhy":"-","summary":"열람 내용 및 사유","vitalTxt":"사본발급 내용 및 사유","injuryTxt":"-","treatTxt":"-","causeTxt":"-","planTxt":"-","note":"비고 (만14세 미만은 법정대리인이 작성)"}','Y','system'),
 -- MR16 분실보고서
 ('MRLOST',NULL,NULL,'보고자',NULL,NULL,
  '{"occurDt":"발생일시","occurTm":"-","rptDt":"보고일","place":"발생장소","targetNm":"성명","targetNo":"주민번호","deptNm":"부서","positionNm":"직위","admitDt":"-","diagNm":"-","wWhen":"-","wWho":"-","wWhere":"-","wWhat":"나이·성별","wHow":"-","wWhy":"-","summary":"의무기록 분실경위","vitalTxt":"-","injuryTxt":"-","treatTxt":"-","causeTxt":"-","planTxt":"결과 (종결/미결)","note":"-"}','Y','system'),
 -- MR24 정정 신청서 (2쪽 = 신청부 + 병원 작성부. 반복행 = 정정내용)
 ('MRFIX','정정내용','서식명,작성날짜,현재 내용,정정할 내용','신청인',
  '※ 의무기록의 정정은 작성자 본인만 할 수 있습니다.',NULL,
  '{"occurDt":"신청일","occurTm":"-","rptDt":"의무기록 정정일","place":"신청자 주소","targetNm":"환자명","targetNo":"등록번호","deptNm":"신청자 구분(환자본인/대리인)","positionNm":"신청자 성명","admitDt":"생년월일","diagNm":"-","wWhen":"-","wWho":"연락처","wWhere":"-","wWhat":"입증문서 첨부 여부","wHow":"-","wWhy":"정정사유","summary":"정정요구 승낙/거절","vitalTxt":"함께 정정할 의무기록지","injuryTxt":"거절사유","treatTxt":"의료인 설명","causeTxt":"-","planTxt":"-","note":"-"}','Y','system'),
 -- MR25 유출신고(보고)서 / MR26 유출 통지서 (법정)
 ('PIILEAK',NULL,NULL,NULL,NULL,NULL,
  '{"occurDt":"작성일","occurTm":"-","rptDt":"-","place":"-","targetNm":"기관명","targetNo":"-","deptNm":"담당부서","positionNm":"담당자 및 연락처","admitDt":"-","diagNm":"-","wWhen":"유출된 시점과 그 경위","wWho":"정보주체의 통지여부","wWhere":"유출신고(보고) 접수기관","wWhat":"유출된 개인정보의 항목 및 규모","wHow":"-","wWhy":"-","summary":"유출피해 최소화 대책·조치 및 결과","vitalTxt":"정보주체가 할 수 있는 피해 최소화 방법 및 구제 절차","injuryTxt":"-","treatTxt":"-","causeTxt":"-","planTxt":"-","note":"-"}','Y','system'),
 ('PIINOTI',NULL,NULL,NULL,
  '「개인정보 보호법」 제34조제1항에 따라 위와 같이 통지합니다.',NULL,
  '{"occurDt":"통지일","occurTm":"-","rptDt":"-","place":"-","targetNm":"정보주체 성명","targetNo":"-","deptNm":"-","positionNm":"-","admitDt":"생년월일","diagNm":"-","wWhen":"② 유출시점과 경위","wWho":"-","wWhere":"⑤ 피해발생 시 신고","wWhat":"① 유출 개인정보 항목","wHow":"③ 피해 최소화 방법","wWhy":"-","summary":"④ 병원의 대응조치 및 구제절차","vitalTxt":"-","injuryTxt":"-","treatTxt":"-","causeTxt":"-","planTxt":"-","note":"-"}','Y','system'),
 -- MR27 권한 신청서 / MR28 CCTV 신청서
 ('SYSAUTH',NULL,NULL,'신청자,부서장',
  '※ 열람범위는 업무상 필요한 최소한으로 제한되며 접속기록은 모니터링됩니다. ID 유효기간은 최대 3개월입니다.',NULL,
  '{"occurDt":"신청일","occurTm":"-","rptDt":"-","place":"-","targetNm":"이름","targetNo":"사번","deptNm":"소속","positionNm":"직종","admitDt":"-","diagNm":"신청구분 (신규/연장)","wWhen":"-","wWho":"연락처","wWhere":"-","wWhat":"권한 요청사항 (작성/조회/기타)","wHow":"-","wWhy":"-","summary":"서약 내용","vitalTxt":"-","injuryTxt":"-","treatTxt":"-","causeTxt":"-","planTxt":"-","note":"-"}','Y','system'),
 ('CCTVREQ',NULL,NULL,'신청자',NULL,NULL,
  '{"occurDt":"신청일","occurTm":"-","rptDt":"-","place":"검색장소 (카메라번호)","targetNm":"신청자 성명","targetNo":"-","deptNm":"소속","positionNm":"-","admitDt":"-","diagNm":"구분 (녹화검색/동영상 사본)","wWhen":"검색요청기간","wWho":"연락처","wWhere":"주소","wWhat":"USB 사용유무","wHow":"-","wWhy":"신청사유","summary":"직원 확인","vitalTxt":"-","injuryTxt":"-","treatTxt":"-","causeTxt":"-","planTxt":"-","note":"-"}','Y','system')
ON DUPLICATE KEY UPDATE SUB_NM=VALUES(SUB_NM), SUB_COLS=VALUES(SUB_COLS), SIGN_LINE=VALUES(SIGN_LINE),
  FOOT_TXT=VALUES(FOOT_TXT), PHOTO_YN=VALUES(PHOTO_YN), LBL_JSON=VALUES(LBL_JSON), USE_YN='Y';

-- ═══ ④ 체크 묶음 ═══════════════════════════════════════════════════════════
DELETE FROM TBL_QPS_SAFERPT_USE WHERE RPT_GB IN ('MRLOAN','MRDISP','MRDMG','MRFIX','CCTVREQ','SYSAUTH','MRCOPY');
DELETE FROM TBL_QPS_SAFERPT_DEF WHERE RPT_GB IN ('MRLOAN','MRDISP','MRDMG','MRFIX','CCTVREQ','SYSAUTH','MRCOPY');

INSERT INTO TBL_QPS_SAFERPT_DEF (RPT_GB,GRP_CD,GRP_NM,ITEM_NM,MULTI_YN,ETC_YN,SORT,USE_YN) VALUES
 -- MR05 신청인 구분
 ('MRCOPY','APPGB','신청인 구분','환자 본인 자필 서명','N','N',1,'Y'),
 ('MRCOPY','APPGB','신청인 구분','친족 혹은 대리인'   ,'N','N',2,'Y'),
 -- MR06 대출·열람 사유 5택
 ('MRLOAN','LOANRSN','대출·열람 사유 및 용도','환자진료용'        ,'N','N',1,'Y'),
 ('MRLOAN','LOANRSN','대출·열람 사유 및 용도','진료비 청구시 참고용','N','N',2,'Y'),
 ('MRLOAN','LOANRSN','대출·열람 사유 및 용도','증명서 발급'       ,'N','N',3,'Y'),
 ('MRLOAN','LOANRSN','대출·열람 사유 및 용도','교육 및 연구용'    ,'N','N',4,'Y'),
 ('MRLOAN','LOANRSN','대출·열람 사유 및 용도','미비 기록'         ,'N','N',5,'Y'),
 -- MR10 폐기 종류 8택(복수)
 ('MRDISP','DISPGB','폐기 종류','환자명부'              ,'Y','N',1,'Y'),
 ('MRDISP','DISPGB','폐기 종류','진료기록부'            ,'Y','N',2,'Y'),
 ('MRDISP','DISPGB','폐기 종류','처방전'                ,'Y','N',3,'Y'),
 ('MRDISP','DISPGB','폐기 종류','검사소견기록'          ,'Y','N',4,'Y'),
 ('MRDISP','DISPGB','폐기 종류','방사선 사진 및 그 소견서','Y','N',5,'Y'),
 ('MRDISP','DISPGB','폐기 종류','간호기록부'            ,'Y','N',6,'Y'),
 ('MRDISP','DISPGB','폐기 종류','진단서 등의 부본'      ,'Y','N',7,'Y'),
 ('MRDISP','DISPGB','폐기 종류','기타'                  ,'Y','Y',8,'Y'),
 -- MR11 내용 3택
 ('MRDMG','MRGB','내용','외래의무기록','N','N',1,'Y'),
 ('MRDMG','MRGB','내용','입원의무기록','N','N',2,'Y'),
 ('MRDMG','MRGB','내용','기타'        ,'N','Y',3,'Y'),
 -- MR24 신청자 구분 · 입증문서
 ('MRFIX','FIXBY','신청자 구분','환자본인','N','N',1,'Y'),
 ('MRFIX','FIXBY','신청자 구분','대리인'  ,'N','Y',2,'Y'),
 ('MRFIX','FIXDOC','입증문서 첨부 여부','있음','N','N',1,'Y'),
 ('MRFIX','FIXDOC','입증문서 첨부 여부','없음','N','N',2,'Y'),
 -- MR27 직종 4택
 ('SYSAUTH','JOBGB','직종','의사'    ,'N','N',1,'Y'),
 ('SYSAUTH','JOBGB','직종','간호사'  ,'N','N',2,'Y'),
 ('SYSAUTH','JOBGB','직종','의료기사','N','N',3,'Y'),
 ('SYSAUTH','JOBGB','직종','기타'    ,'N','Y',4,'Y'),
 -- MR28 구분 2택
 ('CCTVREQ','CCTVGB','구분','CCTV녹화검색 신청','N','N',1,'Y'),
 ('CCTVREQ','CCTVGB','구분','동영상 사본 신청' ,'N','N',2,'Y');

INSERT INTO TBL_QPS_SAFERPT_USE (RPT_GB,GRP_CD,SORT,USE_YN) VALUES
 ('MRCOPY','APPGB',1,'Y'), ('MRLOAN','LOANRSN',1,'Y'), ('MRDISP','DISPGB',1,'Y'),
 ('MRDMG','MRGB',1,'Y'), ('MRFIX','FIXBY',1,'Y'), ('MRFIX','FIXDOC',2,'Y'),
 ('SYSAUTH','JOBGB',1,'Y'), ('CCTVREQ','CCTVGB',1,'Y');

-- ── 확인 ────────────────────────────────────────────────────────────────────
SELECT AXIS_GB, COUNT(*) n FROM TBL_QPS_CHK_FORM WHERE HOSP_CD='*' AND FORM_ID LIKE 'MRC%' GROUP BY AXIS_GB;
SELECT COUNT(*) AS saferpt_total FROM TBL_CODE_DTL WHERE CODE_CD='QPS_SAFERPT_GB' AND USE_YN='Y';
SELECT RPT_GB, JSON_VALID(LBL_JSON) ok, IFNULL(SUB_COLS,'-') cols FROM TBL_QPS_SAFERPT_FORM
 WHERE RPT_GB IN ('MRPROXY','IDREQ','ABBRRPT','SECOATH','MRCOPY','MRLOAN','MRDISP','MRDMG','MRAGREE',
                  'MRLOST','MRFIX','PIILEAK','PIINOTI','SYSAUTH','CCTVREQ') ORDER BY RPT_GB;
