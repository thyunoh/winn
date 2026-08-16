-- ═══════════════════════════════════════════════════════════════════════════
-- 물리재활(REHAB) · 진료(CLINIC) · 사회복지(SOCIAL) 시드 — 마지막 3모듈 (2026-08-14)
--   판독 정본 : docs/proposals/QPS_서식판독_기타모듈_2026-08-14.md §PT·DR·SW
--   전제 : QPS_DDL_SAFERPT_PHOTO / _LBL / GRPPRD 적용 후. 부서 코드 3건은 아래 ①에서 신설.
--   ★이로써 SUNWOO 18개 모듈 중 **서식이 있는 모듈 전체의 시드가 끝난다.**
--
-- ═══ 물리재활 — 트리 16항목이지만 실서식은 5종이다 ═══
--   같은 서식이 **3벌씩 등록된 계열이 5개**다(의료기기·낙상·환경관리·청소소독·치료도구).
--   차이는 **부서 프리셋 유무 · 쪽수(60/30/20기기) · 제목 오타(「치료실치료실」) · 일일/일상 표기**뿐 —
--   ***같은 판이므로 한 벌만 넣는다.*** 쪽수는 기기 수(EQUIP_CNT)로 흡수한다(60기기판을 취한다).
--   PT16 직원 교육 결과 보고서 = `EDURPT` 중복 ⇒ 제외.
--
-- ═══ 진료 — 3종 중 2종만 ═══
--   DR01 의사당직일지 = 원무총무 `DUTYDOC` 과 **같은 판**(트리 이름·문서 제목·시간대 3택까지 동일) ⇒ **제외**.
--   DR02·DR03(영양상담 의뢰서·기록지)만 넣는다. ⚠기존 영양(NUTRI) 등록분과 이름이 겹치지 않음을 확인했다.
--
-- ═══ 사회복지 — 45항목 중 15종 ═══
--   ⛔**제외 12**: 19 재택복귀율 관리대장(엑셀 그리드 기능화면) · 35 평가 결과보고서(설문 집계·차트) ·
--     36~41 중독연구소 PDF 보관함 6종 · 25 참고 게시물 · 2 사업 지침(8쪽 혼합 문서) · 24 = `EDURPT`
--   ⛔**보류 7**: 설문·척도 계열(31·32·34+33 · 42 · 43 K-MHI · 44 SRI · 45) —
--     ***만족도 조사 엔진(TBL_QPS_SURVEY)이 이미 있다.*** 점검표·safeRpt 가 아니라 **그쪽 시드로 가야 한다**
--     (문항·5점 척도·집계가 그 엔진의 몫). 여기서 반쪽으로 넣지 않는다.
--   ⚠**오연결 2건**(트리 12 → 열면 「사회복지 후원 신청서」 · 트리 33 → 「단계별 치료 프로그램(생활변화)」)
--     — **문서 제목 기준**으로 등록한다(12=후원 신청서). 33 은 설문이라 보류.
--   ⚠**타 병원 실명 잔존**(설문 「온사랑병원」 · 자원봉사 서약 「예성요양병원」) — ***시드에 넣지 않는다.***
--   SW18 낙상예방점검표 = 물리재활 판과 같은 판(부서 접미사만 차이) ⇒ 부서 공유로 쓰고 **제외**.
-- 재실행 안전(DELETE 후 INSERT · ON DUPLICATE KEY).
-- ═══════════════════════════════════════════════════════════════════════════

INSERT INTO TBL_CODE_DTL
 (CODE_GB, CODE_CD, SUB_CODE, JOB_SEQ, SUB_CODE_NM, START_DT, END_DT, USE_YN, SORT, ACTION_YN, REG_USER) VALUES
 ('Q','QPS_CHK_DEPT','REHAB' ,1,'물리재활' ,'20000101','99991231','Y',130,'Y','system'),
 ('Q','QPS_CHK_DEPT','CLINIC',1,'진료'     ,'20000101','99991231','Y',140,'Y','system'),
 ('Q','QPS_CHK_DEPT','SOCIAL',1,'사회복지' ,'20000101','99991231','Y',150,'Y','system')
ON DUPLICATE KEY UPDATE SUB_CODE_NM=VALUES(SUB_CODE_NM), SORT=VALUES(SORT), USE_YN='Y', ACTION_YN='Y';

DELETE FROM TBL_QPS_CHK_ITEM WHERE HOSP_CD='*' AND (FORM_ID LIKE 'REH%' OR FORM_ID LIKE 'SOC%');
DELETE FROM TBL_QPS_CHK_FORM WHERE HOSP_CD='*' AND (FORM_ID LIKE 'REH%' OR FORM_ID LIKE 'SOC%');

-- ═══ ② 물리재활 5종 ════════════════════════════════════════════════════════
INSERT INTO TBL_QPS_CHK_FORM
 (FORM_ID, HOSP_CD, FORM_NM, CATE_CD, DEPT_CD, AXIS_GB, PRD_GB, PRD_KIND, GRP_PRD, EQUIP_CNT,
  GUIDE_TXT, SIGNER_YN, NOTE_YN, FIX_YN, SORT_NO, USE_YN, REG_USER) VALUES
 ('REH001','*','의료기기 일상점검표(치료실)','EQUIP','REHAB','EQUIP_DAY','M','D',NULL,60,
  NULL,'Y','N','Y',2210,'Y','system'),
 ('REH002','*','치료도구 일상점검일지(치료실)','EQUIP','REHAB','EQUIP_DAY','M','D',NULL,60,
  NULL,'Y','N','Y',2220,'Y','system'),
 ('REH003','*','낙상예방점검표(치료실)','SAFE','REHAB','ITEM_DAY','M','D',NULL,10,
  '적합 : o, 부적합 : x','Y','Y','N',2230,'Y','system'),
 ('REH004','*','환경관리 일일 점검 대장 - 치료실','ENV','REHAB','ITEM_DAY','M','D',NULL,10,
  '상태 : 양호(O), 정비요(△), 불량(X)','Y','Y','N',2240,'Y','system'),
 ('REH005','*','청소·소독 점검표(치료실)','ENV','REHAB','ITEM_DAY','M','D','매일>D,주 1회>N',10,
  '▶ 매일 점검 후 점검결과 ○ ×(○ 양호, X 불량)로 표기한다.','Y','Y','N',2250,'Y','system');

INSERT INTO TBL_QPS_CHK_ITEM (FORM_ID,HOSP_CD,SORT,ITEM_NM,GRP_NM,INPUT_GB,CARRY_YN,USE_YN) VALUES
 -- REH001 · PT01 (항목 6개 = 타 부서 「일상점검표-의료기기」와 같은 세트)
 ('REH001','*',1,'전원 결함 여부'      ,NULL,'CHECK','N','Y'),
 ('REH001','*',2,'청결 상태'           ,NULL,'CHECK','N','Y'),
 ('REH001','*',3,'가동 이상 여부'      ,NULL,'CHECK','N','Y'),
 ('REH001','*',4,'보관 상태'           ,NULL,'CHECK','N','Y'),
 ('REH001','*',5,'저장 장소 비치 여부' ,NULL,'CHECK','N','Y'),
 ('REH001','*',6,'청소/소독 상태 점검' ,NULL,'CHECK','N','Y'),
 -- REH002 · PT13 치료도구
 ('REH002','*',1,'정상 작동(부품구성) 여부'  ,NULL,'CHECK','N','Y'),
 ('REH002','*',2,'외관 상 파손이나 오염'     ,NULL,'CHECK','N','Y'),
 ('REH002','*',3,'보관상태 여부'             ,NULL,'CHECK','N','Y'),
 ('REH002','*',4,'가동 이상 여부'            ,NULL,'CHECK','N','Y'),
 ('REH002','*',5,'청결 상태'                 ,NULL,'CHECK','N','Y'),
 ('REH002','*',6,'기타 문제점 발생 여부'     ,NULL,'CHECK','N','Y'),
 -- REH003 · PT02 낙상(치료실)
 ('REH003','*',1,'낙상예방 지침 게시물 점검 (내용, 부착위치 및 상태)'          ,NULL,'CHECK','N','Y'),
 ('REH003','*',2,'낙상주의 표시판 확인 (게시물, 스티커 부착)'                  ,NULL,'CHECK','N','Y'),
 ('REH003','*',3,'침대 부속물 점검 (SIDE RAIL 작동여부, 바퀴잠금장치 작동여부)',NULL,'CHECK','N','Y'),
 ('REH003','*',4,'침대 주변 정리확인 (부속기구, 전기코드)'                     ,NULL,'CHECK','N','Y'),
 ('REH003','*',5,'바닥 점검(복도포함) (물기제거, 미끄러짐 요소 제거)'          ,NULL,'CHECK','N','Y'),
 ('REH003','*',6,'조명확인'                                                    ,NULL,'CHECK','N','Y'),
 ('REH003','*',7,'낙상 고위험 환자 확인 (전산공유, 환자인식 밴드)'             ,NULL,'CHECK','N','Y'),
 -- REH004 · PT05 환경관리(치료실)
 ('REH004','*', 1,'바닥 청소(중간수준 소독제)'    ,'환자치료영역','CHECK','N','Y'),
 ('REH004','*', 2,'로비 의자, 대기 장소 등'       ,'환자치료영역','CHECK','N','Y'),
 ('REH004','*', 3,'각종 보관장 청결 관리'         ,'환자치료영역','CHECK','N','Y'),
 ('REH004','*', 4,'휴지통 관리'                   ,'환자치료영역','CHECK','N','Y'),
 ('REH004','*', 5,'각종 치료기구의 표면관리'      ,'환자치료영역','CHECK','N','Y'),
 ('REH004','*', 6,'각종 작업치료 도구의 소독관리' ,'환자치료영역','CHECK','N','Y'),
 ('REH004','*',11,'물의 탁도 (이물질, 변색)'      ,'음용수'      ,'CHECK','N','Y'),
 ('REH004','*',12,'냄새나 맛 이상 여부'           ,'음용수'      ,'CHECK','N','Y'),
 ('REH004','*',13,'정수기의 위생 상태'            ,'음용수'      ,'CHECK','N','Y'),
 ('REH004','*',21,'청소도구의 구분 (화장실, 그 외)','기타'       ,'CHECK','N','Y'),
 ('REH004','*',22,'각종 보호구의 상태확인'        ,'기타'        ,'CHECK','N','Y'),
 -- REH005 · PT07 청소·소독(치료실) — 매일 12 + 주1회 2
 ('REH005','*', 1,'치료실 바닥 청소'    ,'매일'  ,'CHECK','N','Y'),
 ('REH005','*', 2,'기구 및 문손잡이'    ,'매일'  ,'CHECK','N','Y'),
 ('REH005','*', 3,'책상 및 PC표면'      ,'매일'  ,'CHECK','N','Y'),
 ('REH005','*', 4,'카트 표면'           ,'매일'  ,'CHECK','N','Y'),
 ('REH005','*', 5,'싱크대'              ,'매일'  ,'CHECK','N','Y'),
 ('REH005','*', 6,'침대 표면'           ,'매일'  ,'CHECK','N','Y'),
 ('REH005','*', 7,'베개'                ,'매일'  ,'CHECK','N','Y'),
 ('REH005','*', 8,'정수기 물받이/표면'  ,'매일'  ,'CHECK','N','Y'),
 ('REH005','*', 9,'전기치료기 표면'     ,'매일'  ,'CHECK','N','Y'),
 ('REH005','*',10,'치료용 장비'         ,'매일'  ,'CHECK','N','Y'),
 ('REH005','*',11,'이동용 보조기구'     ,'매일'  ,'CHECK','N','Y'),
 ('REH005','*',12,'대기의자'            ,'매일'  ,'CHECK','N','Y'),
 ('REH005','*',21,'창틀'                ,'주 1회','CHECK','N','Y'),
 ('REH005','*',22,'보관장 내부'         ,'주 1회','CHECK','N','Y');

-- ═══ ③ 사회복지 점검표 6종 ══════════════════════════════════════════════════
INSERT INTO TBL_QPS_CHK_FORM
 (FORM_ID, HOSP_CD, FORM_NM, CATE_CD, DEPT_CD, AXIS_GB, PRD_GB, PRD_KIND, EQUIP_CNT,
  HEAD_NMS, GUIDE_TXT, NOTE_NM, SIGNER_YN, NOTE_YN, FIX_YN, SORT_NO, USE_YN, REG_USER) VALUES
 ('SOC001','*','사회복지 연간 계획표'      ,'ETC' ,'SOCIAL','ITEM_MONTH','Y',NULL,10,NULL,NULL,NULL,'N','N','N',2310,'Y','system'),
 ('SOC002','*','치료프로그램 연간계획서'   ,'ETC' ,'SOCIAL','ITEM_MONTH','Y',NULL,10,NULL,NULL,NULL,'N','N','N',2320,'Y','system'),
 ('SOC003','*','사회사업 상담접수대장'     ,'ETC' ,'SOCIAL','LIST','Y',NULL,20,NULL,NULL,NULL,'N','N','N',2330,'Y','system'),
 ('SOC004','*','지역사회연계 기관 목록표'  ,'ETC' ,'SOCIAL','LIST','Y',NULL,15,NULL,NULL,NULL,'N','N','N',2340,'Y','system'),
 ('SOC005','*','자원봉사 관리대장'         ,'ETC' ,'SOCIAL','LIST','Y',NULL,20,NULL,NULL,NULL,'N','N','N',2350,'Y','system'),
 ('SOC006','*','프로그램 참여 명단'        ,'ETC' ,'SOCIAL','LIST','M',NULL,20,
  '프로그램,기준일,적용기간,작성자',NULL,NULL,'N','N','N',2360,'Y','system'),
 ('SOC007','*','치료프로그램 미참여자 및 참여 제외 대상 지원관리','ETC','SOCIAL','LIST','M',NULL,16,
  '병동,시행기간,정신건강전문요원,정신건강의학과 전문의',NULL,NULL,'N','N','N',2370,'Y','system'),
 ('SOC008','*','불만고충 일일 수거 대장(고객의 소리함)','ETC','SOCIAL','DAY_ITEM','M','D',10,
  NULL,NULL,'특이사항','N','Y','N',2380,'Y','system'),
 ('SOC009','*','음용수 관리 일일점검표'    ,'ENV' ,'SOCIAL','ITEM_DAY','M','D',10,NULL,
  'O 양호, △ 보통, X 불량','문제 발생 시 (발생일자 · 관리번호 · 문제 발생 내용 · 처리 결과 보고)','Y','Y','N',2390,'Y','system');

INSERT INTO TBL_QPS_CHK_ITEM (FORM_ID,HOSP_CD,SORT,ITEM_NM,GRP_NM,INPUT_GB,CARRY_YN,USE_YN) VALUES
 -- SOC001 · SW01 연간계획표 (항목 × 1~12월 + 예산·비고)
 ('SOC001','*',1,'개인면담'              ,NULL,'CHECK','N','Y'),
 ('SOC001','*',2,'자원봉사'              ,NULL,'CHECK','N','Y'),
 ('SOC001','*',3,'이미용 봉사'           ,NULL,'CHECK','N','Y'),
 ('SOC001','*',4,'실버체조'              ,NULL,'CHECK','N','Y'),
 ('SOC001','*',5,'음악활동'              ,NULL,'CHECK','N','Y'),
 ('SOC001','*',6,'미술활동'              ,NULL,'CHECK','N','Y'),
 ('SOC001','*',7,'프로그램 요구도 조사'  ,NULL,'CHECK','N','Y'),
 -- SOC002 · SW26 치료프로그램 연간계획서
 ('SOC002','*', 1,'회복준비'        ,'전문화된 프로그램','CHECK','N','Y'),
 ('SOC002','*', 2,'변화동기'        ,'전문화된 프로그램','CHECK','N','Y'),
 ('SOC002','*', 3,'생활변화'        ,'전문화된 프로그램','CHECK','N','Y'),
 ('SOC002','*', 4,'두드림'          ,'전문화된 프로그램','CHECK','N','Y'),
 ('SOC002','*', 5,'동행'            ,'전문화된 프로그램','CHECK','N','Y'),
 ('SOC002','*',11,'알코올강의'      ,'전문의 강의'      ,'CHECK','N','Y'),
 ('SOC002','*',21,'재발예방'        ,'공통 프로그램'    ,'CHECK','N','Y'),
 ('SOC002','*',22,'마음챙김명상'    ,'공통 프로그램'    ,'CHECK','N','Y'),
 ('SOC002','*',23,'시청각교육'      ,'공통 프로그램'    ,'CHECK','N','Y'),
 ('SOC002','*',24,'좋은생각'        ,'공통 프로그램'    ,'CHECK','N','Y'),
 ('SOC002','*',25,'음악감상'        ,'공통 프로그램'    ,'CHECK','N','Y'),
 ('SOC002','*',26,'꽃내음'          ,'공통 프로그램'    ,'CHECK','N','Y'),
 ('SOC002','*',31,'생각다스리기'    ,'선정 프로그램'    ,'CHECK','N','Y'),
 ('SOC002','*',32,'12단계'          ,'선정 프로그램'    ,'CHECK','N','Y'),
 ('SOC002','*',33,'12단계(심화)'    ,'선정 프로그램'    ,'CHECK','N','Y'),
 ('SOC002','*',34,'심리극'          ,'선정 프로그램'    ,'CHECK','N','Y'),
 -- SOC003 · SW06 상담접수대장
 ('SOC003','*',1,'날짜'      ,NULL,'TEXT','N','Y'),
 ('SOC003','*',2,'환자성명'  ,NULL,'TEXT','N','Y'),
 ('SOC003','*',3,'진료과'    ,NULL,'TEXT','N','Y'),
 ('SOC003','*',4,'병실'      ,NULL,'TEXT','N','Y'),
 ('SOC003','*',5,'사회복지사',NULL,'TEXT','N','Y'),
 ('SOC003','*',6,'서명'      ,NULL,'TEXT','N','Y'),
 -- SOC004 · SW10 지역사회연계
 ('SOC004','*',1,'지역사회자원',NULL,'TEXT','N','Y'),
 ('SOC004','*',2,'전화번호'    ,NULL,'TEXT','N','Y'),
 ('SOC004','*',3,'비고'        ,NULL,'TEXT','N','Y'),
 -- SOC005 · SW15 자원봉사 관리대장
 ('SOC005','*',1,'이름'      ,NULL,'TEXT','N','Y'),
 ('SOC005','*',2,'연락처'    ,NULL,'TEXT','N','Y'),
 ('SOC005','*',3,'활동내용'  ,NULL,'TEXT','N','Y'),
 ('SOC005','*',4,'활동기간'  ,NULL,'TEXT','N','Y'),
 ('SOC005','*',5,'비고'      ,NULL,'TEXT','N','Y'),
 -- SOC006 · SW27~30·33 프로그램 참여 명단 (★한 판 공유 — 프로그램은 머리 칸)
 ('SOC006','*',1,'병동'      ,NULL,'TEXT','N','Y'),
 ('SOC006','*',2,'선정대상'  ,NULL,'TEXT','N','Y'),
 ('SOC006','*',3,'주치의'    ,NULL,'TEXT','N','Y'),
 ('SOC006','*',4,'선정이유'  ,NULL,'TEXT','N','Y'),
 ('SOC006','*',5,'비고'      ,NULL,'TEXT','N','Y'),
 -- SOC007 · SW21
 ('SOC007','*',1,'날짜'      ,NULL,'TEXT','N','Y'),
 ('SOC007','*',2,'이름'      ,NULL,'TEXT','N','Y'),
 ('SOC007','*',3,'구분 (미참여자/제외대상)',NULL,'TEXT','N','Y'),
 ('SOC007','*',4,'관리내용'  ,NULL,'TEXT','N','Y'),
 ('SOC007','*',5,'주치의'    ,NULL,'TEXT','N','Y'),
 -- SOC008 · SW20 고객의 소리함 (위치 열 × 일)
 ('SOC008','*',1,'1층'  ,NULL,'TEXT','N','Y'),
 ('SOC008','*',2,'2병동',NULL,'TEXT','N','Y'),
 ('SOC008','*',3,'3병동',NULL,'TEXT','N','Y'),
 ('SOC008','*',4,'5병동',NULL,'TEXT','N','Y'),
 ('SOC008','*',5,'6병동',NULL,'TEXT','N','Y'),
 ('SOC008','*',6,'비고' ,NULL,'TEXT','N','Y'),
 ('SOC008','*',7,'확인자',NULL,'TEXT','N','Y'),
 -- SOC009 · SW22 음용수
 ('SOC009','*',1,'냉온수 정상작동'   ,NULL,'CHECK','N','Y'),
 ('SOC009','*',2,'이상 소음'         ,NULL,'CHECK','N','Y'),
 ('SOC009','*',3,'정수기 위생'       ,NULL,'CHECK','N','Y'),
 ('SOC009','*',4,'바닥 물튐 청소'    ,NULL,'CHECK','N','Y'),
 ('SOC009','*',5,'종이컵 재고'       ,NULL,'CHECK','N','Y'),
 ('SOC009','*',6,'물받이 위생'       ,NULL,'CHECK','N','Y');

-- ═══ ④ safeRpt 유형 12종 (진료 2 · 사회복지 10) ═══════════════════════════
INSERT INTO TBL_CODE_DTL
 (CODE_GB, CODE_CD, SUB_CODE, JOB_SEQ, SUB_CODE_NM, START_DT, END_DT, USE_YN, SORT, ACTION_YN, REG_USER) VALUES
 ('Q','QPS_SAFERPT_GB','NUTREQ' ,1,'영양상담 의뢰서'      ,'20000101','99991231','Y',71,'Y','system'),
 ('Q','QPS_SAFERPT_GB','NUTREC' ,1,'영양상담 기록지'      ,'20000101','99991231','Y',72,'Y','system'),
 ('Q','QPS_SAFERPT_GB','SWNEED' ,1,'프로그램 요구도 조사 기록지','20000101','99991231','Y',73,'Y','system'),
 ('Q','QPS_SAFERPT_GB','SWPLAN' ,1,'프로그램 세부계획서'  ,'20000101','99991231','Y',74,'Y','system'),
 ('Q','QPS_SAFERPT_GB','SWDIARY',1,'프로그램 일지'        ,'20000101','99991231','Y',75,'Y','system'),
 ('Q','QPS_SAFERPT_GB','SWINTAKE',1,'사회사업 초기면접기록지','20000101','99991231','Y',76,'Y','system'),
 ('Q','QPS_SAFERPT_GB','SWPROG' ,1,'사회사업 경과기록지'  ,'20000101','99991231','Y',77,'Y','system'),
 ('Q','QPS_SAFERPT_GB','SWCLOSE',1,'사회사업 종결기록지'  ,'20000101','99991231','Y',78,'Y','system'),
 ('Q','QPS_SAFERPT_GB','SWDONAT',1,'사회공헌활동 보고서'  ,'20000101','99991231','Y',79,'Y','system'),
 ('Q','QPS_SAFERPT_GB','SWSPONS',1,'사회복지 후원 신청서' ,'20000101','99991231','Y',80,'Y','system'),
 ('Q','QPS_SAFERPT_GB','SWSPRPT',1,'후원대상자 최종보고서','20000101','99991231','Y',81,'Y','system'),
 ('Q','QPS_SAFERPT_GB','SWVULN' ,1,'취약환자 상담일지'    ,'20000101','99991231','Y',82,'Y','system'),
 ('Q','QPS_SAFERPT_GB','SWVOL'  ,1,'자원봉사 신청서'      ,'20000101','99991231','Y',83,'Y','system'),
 ('Q','QPS_SAFERPT_GB','SWVOLCF',1,'자원봉사활동 확인서'  ,'20000101','99991231','Y',84,'Y','system'),
 ('Q','QPS_SAFERPT_GB','SWVISIT',1,'가정방문 일지'        ,'20000101','99991231','Y',85,'Y','system')
ON DUPLICATE KEY UPDATE SUB_CODE_NM=VALUES(SUB_CODE_NM), SORT=VALUES(SORT), USE_YN='Y', ACTION_YN='Y';

INSERT INTO TBL_QPS_SAFERPT_FORM
 (RPT_GB, SUB_NM, SUB_COLS, SIGN_LINE, FOOT_TXT, PHOTO_YN, LBL_JSON, USE_YN, REG_USER) VALUES
 -- DR02 영양상담 의뢰서 (의뢰 + 회신 2부)
 ('NUTREQ',NULL,NULL,'담당의,담당 영양사',NULL,NULL,
  '{"occurDt":"의뢰일","occurTm":"-","rptDt":"상담일(회신)","place":"-","targetNm":"이름","targetNo":"등록번호","deptNm":"-","positionNm":"-","admitDt":"생년월일","diagNm":"병명","wWhen":"-","wWho":"-","wWhere":"-","wWhat":"지시영양량(Kcal)","wHow":"신장 · 체중","wWhy":"-","summary":"상태 (영양초기 평가 시 영양불량 판정되어 영양 상담 의뢰합니다.)","vitalTxt":"식습관, 식생활력, 기호 및 운동 휴양상황","injuryTxt":"영양소 섭취현황","treatTxt":"식생활 및 영양평가","causeTxt":"지도내용","planTxt":"-","note":"-"}','Y','system'),
 -- DR03 영양상담 기록지
 ('NUTREC',NULL,NULL,NULL,NULL,NULL,
  '{"occurDt":"작성일","occurTm":"-","rptDt":"재상담일자","place":"병실호수","targetNm":"이름","targetNo":"등록번호","deptNm":"-","positionNm":"-","admitDt":"-","diagNm":"-","wWhen":"연령","wWho":"성별","wWhere":"-","wWhat":"신장(cm) · 현재 체중(kg)","wHow":"표준체중(kg) · BMI(체질량질수)","wWhy":"-","summary":"1. 상담 내용","vitalTxt":"2. 치료 계획","injuryTxt":"3. 기타","treatTxt":"-","causeTxt":"-","planTxt":"-","note":"비고"}','Y','system'),
 -- SW03 요구도 조사 / SW04 세부계획서 / SW05 일지(사진)
 ('SWNEED',NULL,NULL,NULL,NULL,NULL,
  '{"occurDt":"작성일자","occurTm":"-","rptDt":"-","place":"-","targetNm":"대상자명","targetNo":"-","deptNm":"-","positionNm":"-","admitDt":"생년월일","diagNm":"-","wWhen":"성별","wWho":"-","wWhere":"-","wWhat":"-","wHow":"-","wWhy":"-","summary":"NEED","vitalTxt":"ASSESSMENT","injuryTxt":"PLAN (개요 · 주요내용)","treatTxt":"-","causeTxt":"-","planTxt":"-","note":"비고"}','Y','system'),
 ('SWPLAN',NULL,NULL,NULL,NULL,NULL,
  '{"occurDt":"일시","occurTm":"-","rptDt":"-","place":"-","targetNm":"-","targetNo":"-","deptNm":"-","positionNm":"-","admitDt":"-","diagNm":"프로그램명","wWhen":"주제","wWho":"-","wWhere":"-","wWhat":"준비물","wHow":"방법","wWhy":"목적","summary":"내용","vitalTxt":"목표","injuryTxt":"진행","treatTxt":"예산","causeTxt":"평가","planTxt":"-","note":"-"}','Y','system'),
 ('SWDIARY',NULL,NULL,NULL,NULL,'Y',
  '{"occurDt":"실시일시","occurTm":"시각","rptDt":"-","place":"장소","targetNm":"담당자","targetNo":"참여인원","deptNm":"보조담당자","positionNm":"-","admitDt":"-","diagNm":"프로그램명","wWhen":"-","wWho":"참석자현황","wWhere":"-","wWhat":"준비물","wHow":"-","wWhy":"목적","summary":"진행내용","vitalTxt":"-","injuryTxt":"-","treatTxt":"-","causeTxt":"평가 및 개선점","planTxt":"-","note":"비고"}','Y','system'),
 -- SW07 초기면접 / SW08 경과 / SW09 종결
 ('SWINTAKE',NULL,NULL,'사회복지사',NULL,NULL,
  '{"occurDt":"면접일","occurTm":"-","rptDt":"의뢰일","place":"주소","targetNm":"성명","targetNo":"등록번호","deptNm":"진료과","positionNm":"병실","admitDt":"-","diagNm":"진단명","wWhen":"연령 · 성별","wWho":"피면접자 · 의뢰자","wWhere":"연락처","wWhat":"의뢰문제","wHow":"결혼·주거·학력·직업·경제상태·의료보장","wWhy":"-","summary":"초기상담 반응 및 면담 태도","vitalTxt":"가족사항","injuryTxt":"병력","treatTxt":"주치의","causeTxt":"-","planTxt":"-","note":"-"}','Y','system'),
 ('SWPROG',NULL,NULL,'사회복지사',NULL,NULL,
  '{"occurDt":"등록일","occurTm":"-","rptDt":"-","place":"-","targetNm":"성명","targetNo":"등록번호","deptNm":"-","positionNm":"-","admitDt":"-","diagNm":"-","wWhen":"연령 · 성별","wWho":"-","wWhere":"-","wWhat":"-","wHow":"-","wWhy":"-","summary":"Personal history","vitalTxt":"문제사정 (심리·사회적 평가)","injuryTxt":"문제사정 (경제적 평가)","treatTxt":"개입계획","causeTxt":"사회복지사 소견","planTxt":"-","note":"-"}','Y','system'),
 ('SWCLOSE',NULL,'접촉구분,회수','환자면접,보호자면접,전화상담,사례협의',NULL,NULL,
  '{"occurDt":"종결일","occurTm":"-","rptDt":"퇴원일","place":"-","targetNm":"성명","targetNo":"등록번호","deptNm":"진료과","positionNm":"주치의","admitDt":"입원일","diagNm":"진단명","wWhen":"-","wWho":"-","wWhere":"-","wWhat":"문제영역 (의뢰시/문제사정시/개입)","wHow":"진료비 지원금액","wWhy":"종결사유","summary":"종결 후 계획","vitalTxt":"사회복지사 평가","injuryTxt":"-","treatTxt":"-","causeTxt":"-","planTxt":"-","note":"-"}','Y','system'),
 -- SW11 사회공헌 / SW12(오연결=후원신청서) / SW13 최종보고서
 ('SWDONAT','후원활동 경비내역','품목,수량,단가,합계','담당자',NULL,NULL,
  '{"occurDt":"작성일","occurTm":"-","rptDt":"-","place":"주소","targetNm":"인수자명","targetNo":"접수번호","deptNm":"인수기관명","positionNm":"직책","admitDt":"-","diagNm":"-","wWhen":"-","wWho":"대상","wWhere":"연락처","wWhat":"대상인원","wHow":"후원금액","wWhy":"-","summary":"-","vitalTxt":"-","injuryTxt":"-","treatTxt":"-","causeTxt":"-","planTxt":"-","note":"첨부서류"}','Y','system'),
 ('SWSPONS',NULL,NULL,'신청인,추천(승인)권자',NULL,NULL,
  '{"occurDt":"신청일","occurTm":"-","rptDt":"-","place":"주소","targetNm":"환자 성명","targetNo":"전화","deptNm":"보호자 성명","positionNm":"보호자 관계 · 직업","admitDt":"생년월일","diagNm":"병명","wWhen":"성별","wWho":"-","wWhere":"보호자 주소 · 전화","wWhat":"의료보장","wHow":"-","wWhy":"-","summary":"환자상태","vitalTxt":"가족사항","injuryTxt":"-","treatTxt":"-","causeTxt":"-","planTxt":"-","note":"-"}','Y','system'),
 ('SWSPRPT',NULL,NULL,'담당자',NULL,NULL,
  '{"occurDt":"작성일","occurTm":"-","rptDt":"-","place":"주소","targetNm":"대상자명","targetNo":"연락처","deptNm":"-","positionNm":"-","admitDt":"생년월일","diagNm":"후원유형","wWhen":"성별 · 연령","wWho":"-","wWhere":"-","wWhat":"후원금액","wHow":"-","wWhy":"-","summary":"후원 내역","vitalTxt":"후원 후의 변화 및 현재 상태","injuryTxt":"향후 후원 계획 및 담당자 소견","treatTxt":"-","causeTxt":"-","planTxt":"-","note":"첨부서류"}','Y','system'),
 -- SW14 취약환자 상담일지
 ('SWVULN',NULL,NULL,NULL,NULL,NULL,
  '{"occurDt":"상담일시","occurTm":"시각","rptDt":"접수일시","place":"상담형태 (장소)","targetNm":"대상자","targetNo":"등록번호","deptNm":"병실","positionNm":"신고접수자","admitDt":"-","diagNm":"-","wWhen":"나이 · 성별","wWho":"신고자 관계","wWhere":"-","wWhat":"-","wHow":"-","wWhy":"-","summary":"상담내용","vitalTxt":"개입계획 및 의견","injuryTxt":"-","treatTxt":"-","causeTxt":"-","planTxt":"-","note":"-"}','Y','system'),
 -- SW16 자원봉사 신청서 / SW17 확인서(사진탭) / SW23 가정방문 일지
 ('SWVOL',NULL,NULL,'신청인,접수자',NULL,NULL,
  '{"occurDt":"접수일","occurTm":"-","rptDt":"활동기간","place":"주소","targetNm":"신청자명","targetNo":"주민번호 앞자리","deptNm":"소속","positionNm":"학교·학과","admitDt":"-","diagNm":"-","wWhen":"신청시간 (총시간)","wWho":"성별","wWhere":"연락처","wWhat":"참여경로","wHow":"-","wWhy":"-","summary":"활동내용","vitalTxt":"-","injuryTxt":"-","treatTxt":"-","causeTxt":"-","planTxt":"-","note":"-"}','Y','system'),
 ('SWVOLCF','봉사자 명단','성명,생년월일,연락처,봉사시간',NULL,NULL,'Y',
  '{"occurDt":"봉사일시","occurTm":"시각","rptDt":"-","place":"장소","targetNm":"성명","targetNo":"연락처","deptNm":"-","positionNm":"-","admitDt":"생년월일","diagNm":"-","wWhen":"총시간","wWho":"-","wWhere":"-","wWhat":"-","wHow":"-","wWhy":"-","summary":"내용","vitalTxt":"-","injuryTxt":"-","treatTxt":"-","causeTxt":"-","planTxt":"-","note":"-"}','Y','system'),
 ('SWVISIT',NULL,NULL,'사회복지사',NULL,'Y',
  '{"occurDt":"가정방문 일자","occurTm":"방문(상담)일시","rptDt":"퇴원일자","place":"방문 장소","targetNm":"성명","targetNo":"전화","deptNm":"-","positionNm":"최종학력 · 직업","admitDt":"입원일자","diagNm":"진단명","wWhen":"성별 · 나이","wWho":"결혼여부 · 종교 · 종별","wWhere":"주소","wWhat":"-","wHow":"-","wWhy":"-","summary":"욕구사정 (1.신체상태 2.질병 3.인지 상태 4.의사소통 5.영양 상태 6.가족 및 환경)","vitalTxt":"종합","injuryTxt":"보호자 상담 (전화상담)","treatTxt":"-","causeTxt":"-","planTxt":"-","note":"-"}','Y','system')
ON DUPLICATE KEY UPDATE SUB_NM=VALUES(SUB_NM), SUB_COLS=VALUES(SUB_COLS), SIGN_LINE=VALUES(SIGN_LINE),
  FOOT_TXT=VALUES(FOOT_TXT), PHOTO_YN=VALUES(PHOTO_YN), LBL_JSON=VALUES(LBL_JSON), USE_YN='Y';

-- ═══ ⑤ 체크 묶음 ═══════════════════════════════════════════════════════════
DELETE FROM TBL_QPS_SAFERPT_USE WHERE RPT_GB IN ('NUTREC','SWVULN','SWVOL','SWCLOSE');
DELETE FROM TBL_QPS_SAFERPT_DEF WHERE RPT_GB IN ('NUTREC','SWVULN','SWVOL','SWCLOSE');

INSERT INTO TBL_QPS_SAFERPT_DEF (RPT_GB,GRP_CD,GRP_NM,ITEM_NM,MULTI_YN,ETC_YN,SORT,USE_YN) VALUES
 -- DR03 영양상담 기록지 (신체증후·임상정보·식사·저작·연하·건강·속도·활동도)
 ('NUTREC','SIGN' ,'신체증후','매우 여윔','Y','N',1,'Y'),('NUTREC','SIGN','신체증후','여윔','Y','N',2,'Y'),
 ('NUTREC','SIGN' ,'신체증후','비만','Y','N',3,'Y'),('NUTREC','SIGN','신체증후','복수','Y','N',4,'Y'),
 ('NUTREC','SIGN' ,'신체증후','기타','Y','Y',5,'Y'),
 ('NUTREC','HIST' ,'임상정보 (보유병력)','고혈압','Y','N',1,'Y'),('NUTREC','HIST','임상정보 (보유병력)','당뇨','Y','N',2,'Y'),
 ('NUTREC','HIST' ,'임상정보 (보유병력)','비만','Y','N',3,'Y'),('NUTREC','HIST','임상정보 (보유병력)','저혈압','Y','N',4,'Y'),
 ('NUTREC','HIST' ,'임상정보 (보유병력)','변비','Y','N',5,'Y'),('NUTREC','HIST','임상정보 (보유병력)','기타','Y','Y',6,'Y'),
 ('NUTREC','INTAKE','식사섭취상태','양호','N','N',1,'Y'),('NUTREC','INTAKE','식사섭취상태','불량','N','N',2,'Y'),
 ('NUTREC','INTAKE','식사섭취상태','심한불량','N','N',3,'Y'),
 ('NUTREC','HEALTH','건강상태','소화불량','Y','N',1,'Y'),('NUTREC','HEALTH','건강상태','식욕저하','Y','N',2,'Y'),
 ('NUTREC','HEALTH','건강상태','우울증','Y','N',3,'Y'),('NUTREC','HEALTH','건강상태','변비','Y','N',4,'Y'),
 ('NUTREC','HEALTH','건강상태','설사','Y','N',5,'Y'),('NUTREC','HEALTH','건강상태','구토','Y','N',6,'Y'),
 ('NUTREC','HEALTH','건강상태','공복감','Y','N',7,'Y'),('NUTREC','HEALTH','건강상태','불규칙한 식사','Y','N',8,'Y'),
 ('NUTREC','HEALTH','건강상태','편식','Y','N',9,'Y'),
 ('NUTREC','SPEED','식사속도','보통','N','N',1,'Y'),('NUTREC','SPEED','식사속도','빠름','N','N',2,'Y'),
 ('NUTREC','SPEED','식사속도','느림','N','N',3,'Y'),
 ('NUTREC','ACT'  ,'활동도','가벼운 운동','N','N',1,'Y'),('NUTREC','ACT','활동도','보통 활동','N','N',2,'Y'),
 ('NUTREC','ACT'  ,'활동도','심한 활동','N','N',3,'Y'),
 -- SW14 취약환자 의뢰사유
 ('SWVULN','RSN','의뢰사유','정서적 학대','Y','N',1,'Y'),('SWVULN','RSN','의뢰사유','신체적 학대','Y','N',2,'Y'),
 ('SWVULN','RSN','의뢰사유','경제적 학대','Y','N',3,'Y'),('SWVULN','RSN','의뢰사유','방임','Y','N',4,'Y'),
 ('SWVULN','RSN','의뢰사유','장애','Y','N',5,'Y'),('SWVULN','RSN','의뢰사유','성폭력·희롱','Y','N',6,'Y'),
 ('SWVULN','RES','결과','사례 종결','N','N',1,'Y'),('SWVULN','RES','결과','평가','N','N',2,'Y'),
 ('SWVULN','RES','결과','사후 관리','N','N',3,'Y'),
 -- SW16 자원봉사 희망분야
 ('SWVOL','FIELD','희망분야','행사도우미','Y','N',1,'Y'),('SWVOL','FIELD','희망분야','프로그램 진행','Y','N',2,'Y'),
 ('SWVOL','FIELD','희망분야','병원 환경미화','Y','N',3,'Y'),('SWVOL','FIELD','희망분야','어르신 말벗','Y','N',4,'Y'),
 ('SWVOL','FIELD','희망분야','식사보조','Y','N',5,'Y'),('SWVOL','FIELD','희망분야','기타','Y','Y',6,'Y');

INSERT INTO TBL_QPS_SAFERPT_USE (RPT_GB,GRP_CD,SORT,USE_YN) VALUES
 ('NUTREC','SIGN',1,'Y'),('NUTREC','HIST',2,'Y'),('NUTREC','INTAKE',3,'Y'),
 ('NUTREC','HEALTH',4,'Y'),('NUTREC','SPEED',5,'Y'),('NUTREC','ACT',6,'Y'),
 ('SWVULN','RSN',1,'Y'),('SWVULN','RES',2,'Y'),
 ('SWVOL','FIELD',1,'Y');

-- ── 확인 ────────────────────────────────────────────────────────────────────
SELECT DEPT_CD, COUNT(*) n FROM TBL_QPS_CHK_FORM WHERE HOSP_CD='*' AND DEPT_CD IN ('REHAB','SOCIAL') GROUP BY DEPT_CD;
SELECT COUNT(*) AS saferpt_total FROM TBL_CODE_DTL WHERE CODE_CD='QPS_SAFERPT_GB' AND USE_YN='Y';
SELECT COUNT(*) AS lbl_ok FROM TBL_QPS_SAFERPT_FORM WHERE JSON_VALID(LBL_JSON)=1;
SELECT COUNT(*) AS chk_total FROM TBL_QPS_CHK_FORM WHERE HOSP_CD='*';
