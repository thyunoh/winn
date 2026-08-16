-- ═══════════════════════════════════════════════════════════════════════════
-- 보건관리자(HEALTH) 시드 — 점검표 LIST 10종 + safeRpt 유형 4종 (2026-08-14)
--   판독 정본 : docs/proposals/QPS_서식판독_보건관리자_2026-08-14.md (h01~h33)
--   전제 : QPS_DDL_SAFERPT_PHOTO / QPS_DDL_SAFERPT_LBL / QPS_CHK_SEED_YEARGRID(부서코드 HEALTH) 적용 후.
--
-- ═══ 넣는 것 ═══
--   점검표 LIST 10종 : HLT002~HLT011 (h04~h08·h10 명부 6 + h12·h20·h21·h22)
--   safeRpt 유형 4종 : CONSULT(검진 이상자 상담일지 — h14~16·h18·h23~28 **한 판 공유**) ·
--                      CONSULTB(B형 간염 상담일지 h13) · CONSULTF(유소견자 상담일지 h31) ·
--                      HLTRPT(직원 건강유지 및 안전 관리활동 결과보고서 h32)
--   (h30 연간계획서 = HLT001 · h33 = EDURPT — 앞선 시드에서 등록 완료)
--
-- ═══ ⛔안 넣는 것 6종과 이유 (반쪽 등록 금지 — 다음 사람이 여기부터) ═══
--   h01·h02·h03·h09·h11 (보고서 5종) ⛔ 본문 「문단 사이 N열×1행 집계표」(h01 은 2개, h02 는 3개)가
--       SUB_COLS(표 1개)로 담기는지 **화면 검증 대기**(판독 §결론 2). 표가 여러 개라 우겨 넣으면 원본과 달라진다
--   h17 잠복결핵감염 치료 안내문   ⛔ 본문 전체가 2쪽 고정 안내문(표 2 + 알약 사진) — FOOT_TXT(500자) 밖.
--       입력값이 날짜·서명 2개뿐이라 **자료실/안내문 계열** 후보
--   h19 보건관리 업무일지          ⛔ 판독이 「판정 보류」 — 체크 문항 ~50 + 통계 소표 3벌(기존 조각 없음)
--   h29 직원건강검진관리대장       ⛔ **3단 다단 머리 26열** — LIST 열 묶음은 2단(GRP_NM)까지다(qpsChk 실측)
--
-- ═══ 원본과 다르게 담은 것 (한계 — 병원확인 대상) ═══
--   ⓐ 명부 6종(h04~h10)의 **결재란 4칸**은 점검표 엔진 인쇄에 없다(엔진 밖 요소)
--   ⓑ h20 부서 블록(1층직원·영양·2병동·3병동·5병동)은 **캡처 병원의 구성** — 병원별로 다르면
--      그 병원 서식(HOSP_CD 행)으로 ROW_BLKS 만 덮어쓴다
--   ⓒ h22 첫 구간의 띠 이름 「검사 대상자」는 원본에 없다(원본은 무제) — 블록 장치가 이름을 요구해 붙였다
--   ⓓ 상담일지의 **질환별 기본 문구**(6형제의 유일한 차이)는 입력칸 기본값 장치가 없어 못 담았다 —
--      병원이 직접 쓴다. 질환 구분은 사진첨부(교육자료) 내용으로 가른다(판독 §1 결론 그대로)
-- 재실행 안전(DELETE 후 INSERT · ON DUPLICATE KEY).
-- ═══════════════════════════════════════════════════════════════════════════

DELETE FROM TBL_QPS_CHK_ITEM WHERE HOSP_CD='*' AND FORM_ID BETWEEN 'HLT002' AND 'HLT011';
DELETE FROM TBL_QPS_CHK_FORM WHERE HOSP_CD='*' AND FORM_ID BETWEEN 'HLT002' AND 'HLT011';

-- ═══ ① 명부 LIST 10종 ═══════════════════════════════════════════════════════
--   번호 열은 넣지 않는다 — LIST 가 행 번호를 자동으로 그린다.
INSERT INTO TBL_QPS_CHK_FORM
 (FORM_ID, HOSP_CD, FORM_NM, CATE_CD, DEPT_CD, AXIS_GB, PRD_GB, EQUIP_CNT,
  HEAD_NMS, ROW_BLKS, SIGNER_YN, NOTE_YN, FIX_YN, SORT_NO, USE_YN, REG_USER) VALUES
 -- 년 단위 명부(문서 키 = 년)
 ('HLT002','*','B형 간염 검사 결과 명부'      ,'SAFE','HEALTH','LIST','Y',30,NULL,NULL,'N','N','N',110,'Y','system'),
 ('HLT003','*','신규 채용 검진 결과 명부'     ,'SAFE','HEALTH','LIST','Y',30,NULL,NULL,'N','N','N',120,'Y','system'),
 ('HLT004','*','잠복결핵 검진 결과 명부'      ,'SAFE','HEALTH','LIST','Y',30,NULL,NULL,'N','N','N',130,'Y','system'),
 ('HLT006','*','특수 건강검진 결과 명부'      ,'SAFE','HEALTH','LIST','Y',30,NULL,NULL,'N','N','N',150,'Y','system'),
 ('HLT007','*','직원 독감 예방 접종 결과 명단','SAFE','HEALTH','LIST','Y',30,NULL,NULL,'N','N','N',160,'Y','system'),
 ('HLT008','*','직원코로나 예방접종결과명단'  ,'SAFE','HEALTH','LIST','Y',30,'차수',NULL,'N','N','N',170,'Y','system'),
 -- 일 단위 명부(문서 키 = 년월일)
 ('HLT005','*','직원 건강검진 결과 명부'      ,'SAFE','HEALTH','LIST','D',30,NULL,NULL,'N','N','N',140,'Y','system'),
 ('HLT009','*','직원 건강검진 결과표'         ,'SAFE','HEALTH','LIST','D',20,NULL,
  '1층직원>20,영양>20,2병동>20,3병동>20,5병동>20','N','N','N',180,'Y','system'),
 ('HLT010','*','신규직원 건강검진 결과표'     ,'SAFE','HEALTH','LIST','D',30,NULL,NULL,'N','N','N',190,'Y','system'),
 ('HLT011','*','유소견자 관리대장'            ,'SAFE','HEALTH','LIST','D',13,
  '관리 질환명,검사일시,검사진행 대상자','검사 대상자>13,추가관리 대상자>5','N','N','N',200,'Y','system');

INSERT INTO TBL_QPS_CHK_ITEM (FORM_ID,HOSP_CD,SORT,ITEM_NM,GRP_NM,INPUT_GB,CARRY_YN,USE_YN) VALUES
 -- HLT002 · h04 (열 1단)
 ('HLT002','*',1,'부서'    ,NULL,'TEXT','N','Y'),
 ('HLT002','*',2,'이름'    ,NULL,'TEXT','N','Y'),
 ('HLT002','*',3,'Ag'      ,NULL,'TEXT','N','Y'),
 ('HLT002','*',4,'Ab'      ,NULL,'TEXT','N','Y'),
 ('HLT002','*',5,'1차'     ,NULL,'TEXT','N','Y'),
 ('HLT002','*',6,'2차'     ,NULL,'TEXT','N','Y'),
 ('HLT002','*',7,'3차'     ,NULL,'TEXT','N','Y'),
 ('HLT002','*',8,'재검'    ,NULL,'TEXT','N','Y'),
 ('HLT002','*',9,'비고'    ,NULL,'TEXT','N','Y'),
 -- HLT003 · h05
 ('HLT003','*',1,'부서'    ,NULL,'TEXT','N','Y'),
 ('HLT003','*',2,'이름'    ,NULL,'TEXT','N','Y'),
 ('HLT003','*',3,'입사일자',NULL,'TEXT','N','Y'),
 ('HLT003','*',4,'채용검진',NULL,'TEXT','N','Y'),
 ('HLT003','*',5,'유소견'  ,NULL,'TEXT','N','Y'),
 ('HLT003','*',6,'비고'    ,NULL,'TEXT','N','Y'),
 -- HLT004 · h06 (★명부 6종 중 유일한 2단 머리 — 「잠복결핵 결과」 묶음)
 ('HLT004','*',1,'부서'          ,NULL          ,'TEXT','N','Y'),
 ('HLT004','*',2,'이름'          ,NULL          ,'TEXT','N','Y'),
 ('HLT004','*',3,'음성'          ,'잠복결핵 결과','TEXT','N','Y'),
 ('HLT004','*',4,'양성'          ,'잠복결핵 결과','TEXT','N','Y'),
 ('HLT004','*',5,'결과상담(원내)',NULL          ,'TEXT','N','Y'),
 ('HLT004','*',6,'외부진료'      ,NULL          ,'TEXT','N','Y'),
 ('HLT004','*',7,'약물복용'      ,NULL          ,'TEXT','N','Y'),
 ('HLT004','*',8,'F/U'           ,NULL          ,'TEXT','N','Y'),
 ('HLT004','*',9,'비고'          ,NULL          ,'TEXT','N','Y'),
 -- HLT005 · h07
 ('HLT005','*',1,'부서'      ,NULL,'TEXT','N','Y'),
 ('HLT005','*',2,'이름'      ,NULL,'TEXT','N','Y'),
 ('HLT005','*',3,'건강검진일',NULL,'TEXT','N','Y'),
 ('HLT005','*',4,'유소견'    ,NULL,'TEXT','N','Y'),
 ('HLT005','*',5,'비고'      ,NULL,'TEXT','N','Y'),
 -- HLT006 · h08
 ('HLT006','*',1,'부서'    ,NULL,'TEXT','N','Y'),
 ('HLT006','*',2,'이름'    ,NULL,'TEXT','N','Y'),
 ('HLT006','*',3,'입사일자',NULL,'TEXT','N','Y'),
 ('HLT006','*',4,'배치전'  ,NULL,'TEXT','N','Y'),
 ('HLT006','*',5,'6개월'   ,NULL,'TEXT','N','Y'),
 ('HLT006','*',6,'1년'     ,NULL,'TEXT','N','Y'),
 ('HLT006','*',7,'유소견'  ,NULL,'TEXT','N','Y'),
 ('HLT006','*',8,'비고'    ,NULL,'TEXT','N','Y'),
 -- HLT007 · h10 (열이 「부서」가 아니라 「직종」 — 원본 그대로)
 ('HLT007','*',1,'직종'     ,NULL,'TEXT','N','Y'),
 ('HLT007','*',2,'이름'     ,NULL,'TEXT','N','Y'),
 ('HLT007','*',3,'접종일자' ,NULL,'TEXT','N','Y'),
 ('HLT007','*',4,'원내/원외',NULL,'TEXT','N','Y'),
 ('HLT007','*',5,'약품명'   ,NULL,'TEXT','N','Y'),
 ('HLT007','*',6,'비고'     ,NULL,'TEXT','N','Y'),
 -- HLT008 · h12 (독감 명단과 같은 열 — 독감↔코로나 복제 쌍. 차수는 상단 자유칸)
 ('HLT008','*',1,'직종'     ,NULL,'TEXT','N','Y'),
 ('HLT008','*',2,'이름'     ,NULL,'TEXT','N','Y'),
 ('HLT008','*',3,'접종일자' ,NULL,'TEXT','N','Y'),
 ('HLT008','*',4,'원내/원외',NULL,'TEXT','N','Y'),
 ('HLT008','*',5,'약품명'   ,NULL,'TEXT','N','Y'),
 ('HLT008','*',6,'비고'     ,NULL,'TEXT','N','Y'),
 -- HLT009 · h20 (2단 머리 2묶음 + 부서 블록 반복)
 ('HLT009','*', 1,'직원명'  ,NULL      ,'TEXT','N','Y'),
 ('HLT009','*', 2,'입사일자',NULL      ,'TEXT','N','Y'),
 ('HLT009','*', 3,'생년월일',NULL      ,'TEXT','N','Y'),
 ('HLT009','*', 4,'부서명'  ,NULL      ,'TEXT','N','Y'),
 ('HLT009','*', 5,'특수검진','건강검진','TEXT','N','Y'),
 ('HLT009','*', 6,'일반검진','건강검진','TEXT','N','Y'),
 ('HLT009','*', 7,'비고'    ,'건강검진','TEXT','N','Y'),
 ('HLT009','*', 8,'잠복결핵',NULL      ,'TEXT','N','Y'),
 ('HLT009','*', 9,'인플루엔자',NULL    ,'TEXT','N','Y'),
 ('HLT009','*',10,'유'      ,'B형간염항체 유(O),무(X)','TEXT','N','Y'),
 ('HLT009','*',11,'무'      ,'B형간염항체 유(O),무(X)','TEXT','N','Y'),
 ('HLT009','*',12,'권고'    ,'B형간염항체 유(O),무(X)','TEXT','N','Y'),
 -- HLT010 · h21 (h20 과 건강검진 하위열이 달라 별개 서식 — 판독 확정)
 ('HLT010','*', 1,'직원명'  ,NULL      ,'TEXT','N','Y'),
 ('HLT010','*', 2,'입사일자',NULL      ,'TEXT','N','Y'),
 ('HLT010','*', 3,'생년월일',NULL      ,'TEXT','N','Y'),
 ('HLT010','*', 4,'부서명'  ,NULL      ,'TEXT','N','Y'),
 ('HLT010','*', 5,'채용검진','건강검진','TEXT','N','Y'),
 ('HLT010','*', 6,'배치전'  ,'건강검진','TEXT','N','Y'),
 ('HLT010','*', 7,'배치후'  ,'건강검진','TEXT','N','Y'),
 ('HLT010','*', 8,'비고'    ,'건강검진','TEXT','N','Y'),
 ('HLT010','*', 9,'잠복결핵',NULL      ,'TEXT','N','Y'),
 ('HLT010','*',10,'인플루엔자',NULL    ,'TEXT','N','Y'),
 ('HLT010','*',11,'유'      ,'B형간염항체 유(O),무(X)','TEXT','N','Y'),
 ('HLT010','*',12,'무'      ,'B형간염항체 유(O),무(X)','TEXT','N','Y'),
 ('HLT010','*',13,'권고'    ,'B형간염항체 유(O),무(X)','TEXT','N','Y'),
 -- HLT011 · h22 (상단 통칸 3 = HEAD_NMS · 「추가관리 대상자」 = 둘째 블록)
 ('HLT011','*', 1,'이름'                ,NULL,'TEXT','N','Y'),
 ('HLT011','*', 2,'부서'                ,NULL,'TEXT','N','Y'),
 ('HLT011','*', 3,'직위'                ,NULL,'TEXT','N','Y'),
 ('HLT011','*', 4,'최초상담일'          ,NULL,'TEXT','N','Y'),
 ('HLT011','*', 5,'과거력'              ,NULL,'TEXT','N','Y'),
 ('HLT011','*', 6,'가족력'              ,NULL,'TEXT','N','Y'),
 ('HLT011','*', 7,'치료/종결여부'       ,NULL,'TEXT','N','Y'),
 ('HLT011','*', 8,'추가진단명 복용약물' ,NULL,'TEXT','N','Y'),
 ('HLT011','*', 9,'추가검사 및 치료의사',NULL,'TEXT','N','Y'),
 ('HLT011','*',10,'기타'                ,NULL,'TEXT','N','Y');

-- ═══ ② safeRpt 유형 4종 ═════════════════════════════════════════════════════
INSERT INTO TBL_CODE_DTL
 (CODE_GB, CODE_CD, SUB_CODE, JOB_SEQ, SUB_CODE_NM, START_DT, END_DT, USE_YN, SORT, ACTION_YN, REG_USER) VALUES
 ('Q','QPS_SAFERPT_GB','CONSULT' ,1,'검진 이상자 상담일지'  ,'20000101','99991231','Y',21,'Y','system'),
 ('Q','QPS_SAFERPT_GB','CONSULTB',1,'B형 간염 상담일지'     ,'20000101','99991231','Y',22,'Y','system'),
 ('Q','QPS_SAFERPT_GB','CONSULTF',1,'유소견자 상담일지'     ,'20000101','99991231','Y',23,'Y','system'),
 ('Q','QPS_SAFERPT_GB','HLTRPT'  ,1,'직원 건강유지 및 안전 관리활동 결과보고서','20000101','99991231','Y',24,'Y','system')
ON DUPLICATE KEY UPDATE SUB_CODE_NM=VALUES(SUB_CODE_NM), SORT=VALUES(SORT), USE_YN='Y', ACTION_YN='Y';

-- 상담일지 2종(CONSULT·CONSULTB) = 같은 구조 + 사진첨부(교육자료 2×2)
INSERT INTO TBL_QPS_SAFERPT_FORM
 (RPT_GB, SUB_NM, SUB_COLS, SIGN_LINE, FOOT_TXT, PHOTO_YN, LBL_JSON, USE_YN, REG_USER) VALUES
 ('CONSULT', NULL, NULL, NULL, NULL, 'Y',
  '{"occurDt":"상담일자","occurTm":"-","rptDt":"-","place":"-","targetNm":"성 명","targetNo":"-","deptNm":"소속/직위","positionNm":"상담자","admitDt":"-","diagNm":"-","wWhen":"-","wWho":"-","wWhere":"-","wWhat":"-","wHow":"-","wWhy":"-","summary":"상담내용","vitalTxt":"-","injuryTxt":"-","treatTxt":"-","causeTxt":"-","planTxt":"처리과정 및 결과","note":"첨부자료"}',
  'Y','system'),
 ('CONSULTB', NULL, NULL, NULL, NULL, 'Y',
  '{"occurDt":"상담일자","occurTm":"-","rptDt":"-","place":"-","targetNm":"성 명","targetNo":"-","deptNm":"소속/직위","positionNm":"상담자","admitDt":"-","diagNm":"-","wWhen":"-","wWho":"-","wWhere":"-","wWhat":"-","wHow":"-","wWhy":"-","summary":"상담내용","vitalTxt":"-","injuryTxt":"-","treatTxt":"-","causeTxt":"-","planTxt":"처리과정 및 결과","note":"첨부자료"}',
  'Y','system'),
 -- 유소견자 상담일지 — 차수 있음 · 첨부자료 없음 · 비고 있음(판독 h31 : 재검자판과 이 세 가지가 다르다)
 ('CONSULTF', NULL, NULL, NULL, NULL, NULL,
  '{"occurDt":"상담일자","occurTm":"-","rptDt":"-","place":"-","targetNm":"성 명","targetNo":"차수","deptNm":"소속/직위","positionNm":"상담자","admitDt":"-","diagNm":"-","wWhen":"-","wWho":"-","wWhere":"-","wWhat":"-","wHow":"-","wWhy":"-","summary":"상담내용","vitalTxt":"-","injuryTxt":"-","treatTxt":"-","causeTxt":"-","planTxt":"처리과정 및 결과","note":"비 고"}',
  'Y','system'),
 -- 결과보고서(h32) — 보고일자·보고담당자·제목·내용·결과·비고, 사진 없음
 ('HLTRPT', NULL, NULL, NULL, NULL, NULL,
  '{"occurDt":"보고일자","occurTm":"-","rptDt":"-","place":"-","targetNm":"보고담당자","targetNo":"-","deptNm":"-","positionNm":"-","admitDt":"-","diagNm":"제 목","wWhen":"-","wWho":"-","wWhere":"-","wWhat":"-","wHow":"-","wWhy":"-","summary":"내용","vitalTxt":"-","injuryTxt":"-","treatTxt":"-","causeTxt":"-","planTxt":"결과","note":"비 고"}',
  'Y','system')
ON DUPLICATE KEY UPDATE PHOTO_YN=VALUES(PHOTO_YN), LBL_JSON=VALUES(LBL_JSON), USE_YN='Y';

-- ── 확인 ────────────────────────────────────────────────────────────────────
SELECT FORM_ID, FORM_NM, PRD_GB, IFNULL(ROW_BLKS,'') blks,
       (SELECT COUNT(*) FROM TBL_QPS_CHK_ITEM i WHERE i.FORM_ID=f.FORM_ID AND i.HOSP_CD='*') cols
  FROM TBL_QPS_CHK_FORM f WHERE f.HOSP_CD='*' AND FORM_ID BETWEEN 'HLT002' AND 'HLT011' ORDER BY FORM_ID;
SELECT RPT_GB, PHOTO_YN, JSON_VALID(LBL_JSON) ok FROM TBL_QPS_SAFERPT_FORM
 WHERE RPT_GB IN ('CONSULT','CONSULTB','CONSULTF','HLTRPT');
