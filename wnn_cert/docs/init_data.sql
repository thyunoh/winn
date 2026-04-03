-- ============================================================
-- wnn_cert 초기 데이터 (MySQL)
-- ============================================================

-- ============================================================
-- 1. TW_USER - 관리자 계정
-- ============================================================
INSERT INTO TW_COMPANY (HOSP_CD, HOSP_NM, COMP_TYPE, OWNER_NM, BED_CNT, USE_YN)
VALUES ('12345678', '위너넷 요양병원', '요양병원', '홍길동', 150, 'Y');

INSERT INTO TW_USER (USER_ID, HOSP_CD, USER_NM, USER_PW, DEPT_NM, ROLE_CD, USE_YN)
VALUES ('admin', '12345678', '관리자', 'admin1234', 'QI팀', 'ADMIN', 'Y');

-- ============================================================
-- 2. TW_TREE - 4주기 요양병원 인증기준 트리
--    HOSP_CD='12345678', TAB_ID='CERT', GRP_CD='STD'
-- ============================================================

-- ----- Level 1 : 영역 (PARENT_ID='00') -----
INSERT INTO TW_TREE (HOSP_CD, TAB_ID, GRP_CD, NODE_ID, PARENT_ID, NODE_NM, SORT_ORD, USE_YN) VALUES
('12345678','CERT','STD','01','00','Ⅰ. 기본가치체계',1,'Y'),
('12345678','CERT','STD','02','00','Ⅱ. 환자진료체계',2,'Y'),
('12345678','CERT','STD','03','00','Ⅲ. 행정관리체계',3,'Y'),
('12345678','CERT','STD','04','00','Ⅳ. 성과관리체계',4,'Y');

-- ----- Level 2 : 12개 장 -----
INSERT INTO TW_TREE (HOSP_CD, TAB_ID, GRP_CD, NODE_ID, PARENT_ID, NODE_NM, SORT_ORD, USE_YN) VALUES
('12345678','CERT','STD','0101','01','1장. 안전보장활동',1,'Y'),
('12345678','CERT','STD','0102','01','2장. 환자권리와 안전',2,'Y'),
('12345678','CERT','STD','0103','01','3장. 감염관리',3,'Y'),
('12345678','CERT','STD','0201','02','4장. 진료전달체계와 평가',1,'Y'),
('12345678','CERT','STD','0202','02','5장. 환자진료',2,'Y'),
('12345678','CERT','STD','0203','02','6장. 수술 및 마취진정관리',3,'Y'),
('12345678','CERT','STD','0204','02','7장. 의약품관리',4,'Y'),
('12345678','CERT','STD','0205','02','8장. 환자권리존중 및 보호',5,'Y'),
('12345678','CERT','STD','0301','03','9장. 경영 및 조직운영',1,'Y'),
('12345678','CERT','STD','0302','03','10장. 인적자원관리',2,'Y'),
('12345678','CERT','STD','0303','03','11장. 시설 및 환경관리',3,'Y'),
('12345678','CERT','STD','0401','04','12장. 질향상 및 환자안전활동',1,'Y');

-- ----- Level 3 : 기준 (각 장별 조사기준) -----

-- 1장. 안전보장활동
INSERT INTO TW_TREE (HOSP_CD, TAB_ID, GRP_CD, NODE_ID, PARENT_ID, NODE_NM, SORT_ORD, USE_YN) VALUES
('12345678','CERT','STD','010101','0101','1.1 환자안전사건 보고체계를 운영한다',1,'Y'),
('12345678','CERT','STD','010102','0101','1.2 직원은 환자안전사건 보고체계에 따라 보고한다',2,'Y'),
('12345678','CERT','STD','010103','0101','1.3 환자안전사건에 대한 분석을 수행한다',3,'Y'),
('12345678','CERT','STD','010104','0101','1.4 낙상 예방활동을 수행한다',4,'Y'),
('12345678','CERT','STD','010105','0101','1.5 욕창 예방활동을 수행한다',5,'Y');

-- 2장. 환자권리와 안전
INSERT INTO TW_TREE (HOSP_CD, TAB_ID, GRP_CD, NODE_ID, PARENT_ID, NODE_NM, SORT_ORD, USE_YN) VALUES
('12345678','CERT','STD','010201','0102','2.1 환자 확인 절차를 준수한다',1,'Y'),
('12345678','CERT','STD','010202','0102','2.2 의사소통 절차를 준수한다',2,'Y'),
('12345678','CERT','STD','010203','0102','2.3 신체보호대 사용을 관리한다',3,'Y'),
('12345678','CERT','STD','010204','0102','2.4 화재안전 관리활동을 수행한다',4,'Y');

-- 3장. 감염관리
INSERT INTO TW_TREE (HOSP_CD, TAB_ID, GRP_CD, NODE_ID, PARENT_ID, NODE_NM, SORT_ORD, USE_YN) VALUES
('12345678','CERT','STD','010301','0103','3.1 감염관리체계를 운영한다',1,'Y'),
('12345678','CERT','STD','010302','0103','3.2 손위생 수행을 관리한다',2,'Y'),
('12345678','CERT','STD','010303','0103','3.3 부서별 감염관리를 수행한다',3,'Y'),
('12345678','CERT','STD','010304','0103','3.4 감염감시를 수행한다',4,'Y'),
('12345678','CERT','STD','010305','0103','3.5 세탁물 및 폐기물을 관리한다',5,'Y');

-- 4장. 진료전달체계와 평가
INSERT INTO TW_TREE (HOSP_CD, TAB_ID, GRP_CD, NODE_ID, PARENT_ID, NODE_NM, SORT_ORD, USE_YN) VALUES
('12345678','CERT','STD','020101','0201','4.1 입원 시 환자평가를 수행한다',1,'Y'),
('12345678','CERT','STD','020102','0201','4.2 진료계획을 수립한다',2,'Y'),
('12345678','CERT','STD','020103','0201','4.3 정기적으로 환자를 재평가한다',3,'Y'),
('12345678','CERT','STD','020104','0201','4.4 퇴원계획을 수립하고 수행한다',4,'Y');

-- 5장. 환자진료
INSERT INTO TW_TREE (HOSP_CD, TAB_ID, GRP_CD, NODE_ID, PARENT_ID, NODE_NM, SORT_ORD, USE_YN) VALUES
('12345678','CERT','STD','020201','0202','5.1 의사의 진료가 적시에 이루어진다',1,'Y'),
('12345678','CERT','STD','020202','0202','5.2 간호사는 간호과정에 따라 간호를 수행한다',2,'Y'),
('12345678','CERT','STD','020203','0202','5.3 영양관리를 수행한다',3,'Y'),
('12345678','CERT','STD','020204','0202','5.4 재활치료를 수행한다',4,'Y');

-- 6장. 수술 및 마취진정관리
INSERT INTO TW_TREE (HOSP_CD, TAB_ID, GRP_CD, NODE_ID, PARENT_ID, NODE_NM, SORT_ORD, USE_YN) VALUES
('12345678','CERT','STD','020301','0203','6.1 수술 전 환자를 평가한다',1,'Y'),
('12345678','CERT','STD','020302','0203','6.2 수술 및 시술의 안전을 보장한다',2,'Y');

-- 7장. 의약품관리
INSERT INTO TW_TREE (HOSP_CD, TAB_ID, GRP_CD, NODE_ID, PARENT_ID, NODE_NM, SORT_ORD, USE_YN) VALUES
('12345678','CERT','STD','020401','0204','7.1 의약품 관리체계를 운영한다',1,'Y'),
('12345678','CERT','STD','020402','0204','7.2 처방 및 조제를 관리한다',2,'Y'),
('12345678','CERT','STD','020403','0204','7.3 투약을 안전하게 수행한다',3,'Y'),
('12345678','CERT','STD','020404','0204','7.4 고위험의약품을 관리한다',4,'Y');

-- 8장. 환자권리존중 및 보호
INSERT INTO TW_TREE (HOSP_CD, TAB_ID, GRP_CD, NODE_ID, PARENT_ID, NODE_NM, SORT_ORD, USE_YN) VALUES
('12345678','CERT','STD','020501','0205','8.1 환자 권리를 존중하고 보호한다',1,'Y'),
('12345678','CERT','STD','020502','0205','8.2 취약환자를 보호한다',2,'Y'),
('12345678','CERT','STD','020503','0205','8.3 동의서를 적절히 받는다',3,'Y');

-- 9장. 경영 및 조직운영
INSERT INTO TW_TREE (HOSP_CD, TAB_ID, GRP_CD, NODE_ID, PARENT_ID, NODE_NM, SORT_ORD, USE_YN) VALUES
('12345678','CERT','STD','030101','0301','9.1 병원 경영체계를 운영한다',1,'Y'),
('12345678','CERT','STD','030102','0301','9.2 윤리경영을 수행한다',2,'Y');

-- 10장. 인적자원관리
INSERT INTO TW_TREE (HOSP_CD, TAB_ID, GRP_CD, NODE_ID, PARENT_ID, NODE_NM, SORT_ORD, USE_YN) VALUES
('12345678','CERT','STD','030201','0302','10.1 인력을 적정하게 배치한다',1,'Y'),
('12345678','CERT','STD','030202','0302','10.2 직원 교육훈련을 수행한다',2,'Y'),
('12345678','CERT','STD','030203','0302','10.3 직원 건강과 안전을 관리한다',3,'Y');

-- 11장. 시설 및 환경관리
INSERT INTO TW_TREE (HOSP_CD, TAB_ID, GRP_CD, NODE_ID, PARENT_ID, NODE_NM, SORT_ORD, USE_YN) VALUES
('12345678','CERT','STD','030301','0303','11.1 시설 및 환경을 안전하게 관리한다',1,'Y'),
('12345678','CERT','STD','030302','0303','11.2 위험물질을 관리한다',2,'Y'),
('12345678','CERT','STD','030303','0303','11.3 의료기기를 관리한다',3,'Y'),
('12345678','CERT','STD','030304','0303','11.4 의무기록을 관리한다',4,'Y');

-- 12장. 질향상 및 환자안전활동
INSERT INTO TW_TREE (HOSP_CD, TAB_ID, GRP_CD, NODE_ID, PARENT_ID, NODE_NM, SORT_ORD, USE_YN) VALUES
('12345678','CERT','STD','040101','0401','12.1 질향상 활동을 수행한다',1,'Y'),
('12345678','CERT','STD','040102','0401','12.2 환자안전 활동을 수행한다',2,'Y'),
('12345678','CERT','STD','040103','0401','12.3 질지표를 관리한다',3,'Y');


-- ============================================================
-- 3. TW_QPS - QPS 지표 분류
-- ============================================================
INSERT INTO TW_QPS (HOSP_CD, QPS_CD, QPS_NM, NOTE, USE_YN, REG_USER) VALUES
('12345678','01','낙상','낙상발생률 모니터링','Y','admin'),
('12345678','02','손위생','손위생 수행률 모니터링','Y','admin'),
('12345678','03','욕창','욕창발생률 모니터링','Y','admin'),
('12345678','04','신체보호대','신체보호대 적용률 모니터링','Y','admin'),
('12345678','05','직원안전','직원 안전사고 발생건수','Y','admin'),
('12345678','06','환자안전','환자안전사건 보고건수','Y','admin'),
('12345678','07','영상TAT','영상검사 보고 소요시간','Y','admin'),
('12345678','08','검체TAT','검체검사 보고 소요시간','Y','admin');


-- ============================================================
-- 4. TW_REF - 레퍼런스 코드
-- ============================================================

-- 평가주기 구분
INSERT INTO TW_REF (HOSP_CD, REF_CD, REF_SEQ, REF_VAL, NOTE, USE_YN, REG_USER) VALUES
('12345678','EVAL_CYCLE',1,'4주기','제4주기 요양병원 인증','Y','admin'),
('12345678','EVAL_CYCLE',2,'3주기','제3주기 요양병원 인증','Y','admin');

-- 평가상태
INSERT INTO TW_REF (HOSP_CD, REF_CD, REF_SEQ, REF_VAL, NOTE, USE_YN, REG_USER) VALUES
('12345678','EVAL_STATUS',1,'준비','평가 준비 단계','Y','admin'),
('12345678','EVAL_STATUS',2,'진행','평가 진행 중','Y','admin'),
('12345678','EVAL_STATUS',3,'완료','평가 완료','Y','admin');

-- 평가결과
INSERT INTO TW_REF (HOSP_CD, REF_CD, REF_SEQ, REF_VAL, NOTE, USE_YN, REG_USER) VALUES
('12345678','EVAL_RESULT',1,'인증','인증 판정','Y','admin'),
('12345678','EVAL_RESULT',2,'조건부인증','조건부 인증 판정','Y','admin'),
('12345678','EVAL_RESULT',3,'불인증','불인증 판정','Y','admin');

-- 평가등급
INSERT INTO TW_REF (HOSP_CD, REF_CD, REF_SEQ, REF_VAL, NOTE, USE_YN, REG_USER) VALUES
('12345678','EVAL_GRADE',1,'상','우수','Y','admin'),
('12345678','EVAL_GRADE',2,'중','보통','Y','admin'),
('12345678','EVAL_GRADE',3,'하','미흡','Y','admin');

-- 보고유형
INSERT INTO TW_REF (HOSP_CD, REF_CD, REF_SEQ, REF_VAL, NOTE, USE_YN, REG_USER) VALUES
('12345678','RPT_TYPE',1,'낙상','낙상 사고보고','Y','admin'),
('12345678','RPT_TYPE',2,'투약','투약 오류보고','Y','admin'),
('12345678','RPT_TYPE',3,'감염','감염 관련 보고','Y','admin'),
('12345678','RPT_TYPE',4,'욕창','욕창 발생보고','Y','admin'),
('12345678','RPT_TYPE',5,'기타','기타 사고보고','Y','admin');

-- 오류등급 (NCC 분류)
INSERT INTO TW_REF (HOSP_CD, REF_CD, REF_SEQ, REF_VAL, NOTE, USE_YN, REG_USER) VALUES
('12345678','ERR_GRADE',1,'A','상황 또는 사건이 오류를 유발할 수 있는 환경','Y','admin'),
('12345678','ERR_GRADE',2,'B','오류가 발생하였으나 환자에게 도달하지 않음','Y','admin'),
('12345678','ERR_GRADE',3,'C','오류가 환자에게 도달하였으나 해를 끼치지 않음','Y','admin'),
('12345678','ERR_GRADE',4,'D','오류가 환자에게 도달, 모니터링 필요','Y','admin'),
('12345678','ERR_GRADE',5,'E','일시적 해를 초래, 중재 필요','Y','admin'),
('12345678','ERR_GRADE',6,'F','일시적 해를 초래, 입원기간 연장','Y','admin'),
('12345678','ERR_GRADE',7,'G','영구적 해를 초래','Y','admin'),
('12345678','ERR_GRADE',8,'H','생명유지를 위한 중재 필요','Y','admin'),
('12345678','ERR_GRADE',9,'I','사망','Y','admin');

-- 재원환자 구분
INSERT INTO TW_REF (HOSP_CD, REF_CD, REF_SEQ, REF_VAL, NOTE, USE_YN, REG_USER) VALUES
('12345678','CNT_TYPE',1,'01','총재원일수','Y','admin'),
('12345678','CNT_TYPE',2,'02','평균환자수','Y','admin');

-- 역할 구분
INSERT INTO TW_REF (HOSP_CD, REF_CD, REF_SEQ, REF_VAL, NOTE, USE_YN, REG_USER) VALUES
('12345678','ROLE_CD',1,'ADMIN','시스템 관리자','Y','admin'),
('12345678','ROLE_CD',2,'EVAL','평가자','Y','admin'),
('12345678','ROLE_CD',3,'USER','일반 사용자','Y','admin');

-- 완결도 섹션 구분
INSERT INTO TW_REF (HOSP_CD, REF_CD, REF_SEQ, REF_VAL, NOTE, USE_YN, REG_USER) VALUES
('12345678','SEC_CD',1,'COL1','섹션1','Y','admin'),
('12345678','SEC_CD',2,'COL2','섹션2','Y','admin'),
('12345678','SEC_CD',3,'COL3','섹션3','Y','admin'),
('12345678','SEC_CD',4,'COL4','섹션4','Y','admin'),
('12345678','SEC_CD',5,'COL5','섹션5','Y','admin'),
('12345678','SEC_CD',6,'COL6','섹션6','Y','admin');

-- 개선활동 상태
INSERT INTO TW_REF (HOSP_CD, REF_CD, REF_SEQ, REF_VAL, NOTE, USE_YN, REG_USER) VALUES
('12345678','IMP_STATUS',1,'계획','개선 계획 단계','Y','admin'),
('12345678','IMP_STATUS',2,'진행','개선 진행 중','Y','admin'),
('12345678','IMP_STATUS',3,'완료','개선 완료','Y','admin');


-- ============================================================
-- 5. TW_FORM_M - 완결도 서식 마스터 (요양병원 공통 서식)
-- ============================================================
INSERT INTO TW_FORM_M (HOSP_CD, FORM_CD, FORM_NM, NOTE, USE_YN) VALUES
('12345678','FORM01','간호기록 완결도','간호기록 완결도 점검 서식','Y'),
('12345678','FORM02','의사기록 완결도','의사기록 완결도 점검 서식','Y'),
('12345678','FORM03','입퇴원기록 완결도','입퇴원기록 완결도 점검 서식','Y'),
('12345678','FORM04','경과기록 완결도','경과기록 완결도 점검 서식','Y'),
('12345678','FORM05','투약기록 완결도','투약기록 완결도 점검 서식','Y'),
('12345678','FORM06','동의서 완결도','동의서 완결도 점검 서식','Y');

-- TW_FORM_D - 서식 항목 (간호기록 완결도)
INSERT INTO TW_FORM_D (HOSP_CD, FORM_CD, SEC_CD, ITEM_SEQ, ITEM_NM, ITEM_DESC, USE_YN) VALUES
('12345678','FORM01','COL1',1,'간호정보조사지','입원 시 간호정보조사지 작성 여부','Y'),
('12345678','FORM01','COL1',2,'간호진단','간호진단 기록 여부','Y'),
('12345678','FORM01','COL1',3,'간호계획','간호계획 수립 여부','Y'),
('12345678','FORM01','COL1',4,'간호수행','간호수행 기록 여부','Y'),
('12345678','FORM01','COL1',5,'간호평가','간호평가 기록 여부','Y'),
('12345678','FORM01','COL2',1,'낙상위험평가','낙상위험 평가도구 기록','Y'),
('12345678','FORM01','COL2',2,'욕창위험평가','욕창위험 평가도구 기록','Y'),
('12345678','FORM01','COL2',3,'영양상태평가','영양상태 평가 기록','Y'),
('12345678','FORM01','COL2',4,'통증평가','통증 평가 기록','Y'),
('12345678','FORM01','COL3',1,'활력징후','활력징후 기록 완결성','Y'),
('12345678','FORM01','COL3',2,'I/O 기록','섭취량/배설량 기록','Y'),
('12345678','FORM01','COL3',3,'투약확인','투약확인 서명','Y');

-- TW_FORM_D - 서식 항목 (의사기록 완결도)
INSERT INTO TW_FORM_D (HOSP_CD, FORM_CD, SEC_CD, ITEM_SEQ, ITEM_NM, ITEM_DESC, USE_YN) VALUES
('12345678','FORM02','COL1',1,'입원기록','입원기록 작성 여부','Y'),
('12345678','FORM02','COL1',2,'경과기록','경과기록 작성 여부','Y'),
('12345678','FORM02','COL1',3,'처방기록','처방기록 작성 여부','Y'),
('12345678','FORM02','COL1',4,'퇴원요약','퇴원요약 작성 여부','Y'),
('12345678','FORM02','COL2',1,'주치의서명','주치의 서명 여부','Y'),
('12345678','FORM02','COL2',2,'진료의뢰서','진료의뢰서 작성 여부','Y'),
('12345678','FORM02','COL2',3,'회신서확인','회신서 확인 여부','Y');

-- ============================================================
-- 7. TW_TREE - Level 4 : 조사항목 (ME - Measurable Element)
--    각 기준(Level3) 하위의 구체적 조사항목
-- ============================================================

-- 010101 환자안전사건 보고체계를 운영한다
INSERT INTO TW_TREE (HOSP_CD, TAB_ID, GRP_CD, NODE_ID, PARENT_ID, NODE_NM, SORT_ORD, USE_YN) VALUES
('12345678','CERT','STD','01010101','010101','환자안전사건 보고 규정이 있다',1,'Y'),
('12345678','CERT','STD','01010102','010101','보고체계(보고경로, 보고방법 등)가 있다',2,'Y'),
('12345678','CERT','STD','01010103','010101','보고된 사건을 분류하여 관리한다',3,'Y');

-- 010102 직원은 환자안전사건 보고체계에 따라 보고한다
INSERT INTO TW_TREE (HOSP_CD, TAB_ID, GRP_CD, NODE_ID, PARENT_ID, NODE_NM, SORT_ORD, USE_YN) VALUES
('12345678','CERT','STD','01010201','010102','직원이 보고체계를 인지하고 있다',1,'Y'),
('12345678','CERT','STD','01010202','010102','환자안전사건 발생 시 보고를 수행한다',2,'Y');

-- 010104 낙상 예방활동을 수행한다
INSERT INTO TW_TREE (HOSP_CD, TAB_ID, GRP_CD, NODE_ID, PARENT_ID, NODE_NM, SORT_ORD, USE_YN) VALUES
('12345678','CERT','STD','01010401','010104','낙상 예방활동 규정이 있다',1,'Y'),
('12345678','CERT','STD','01010402','010104','입원환자에 대해 낙상위험 평가를 수행한다',2,'Y'),
('12345678','CERT','STD','01010403','010104','낙상 고위험환자에 대해 예방활동을 수행한다',3,'Y'),
('12345678','CERT','STD','01010404','010104','낙상 발생 시 대응절차를 수행한다',4,'Y');

-- 010105 욕창 예방활동을 수행한다
INSERT INTO TW_TREE (HOSP_CD, TAB_ID, GRP_CD, NODE_ID, PARENT_ID, NODE_NM, SORT_ORD, USE_YN) VALUES
('12345678','CERT','STD','01010501','010105','욕창 예방활동 규정이 있다',1,'Y'),
('12345678','CERT','STD','01010502','010105','입원환자에 대해 욕창위험 평가를 수행한다',2,'Y'),
('12345678','CERT','STD','01010503','010105','욕창 고위험환자에 대해 예방활동을 수행한다',3,'Y');

-- 010201 환자 확인 절차를 준수한다
INSERT INTO TW_TREE (HOSP_CD, TAB_ID, GRP_CD, NODE_ID, PARENT_ID, NODE_NM, SORT_ORD, USE_YN) VALUES
('12345678','CERT','STD','01020101','010201','환자 확인 규정이 있다',1,'Y'),
('12345678','CERT','STD','01020102','010201','두 가지 이상의 지표로 환자를 확인한다',2,'Y'),
('12345678','CERT','STD','01020103','010201','혈액제제 투여 시 환자확인을 수행한다',3,'Y');

-- 010301 감염관리체계를 운영한다
INSERT INTO TW_TREE (HOSP_CD, TAB_ID, GRP_CD, NODE_ID, PARENT_ID, NODE_NM, SORT_ORD, USE_YN) VALUES
('12345678','CERT','STD','01030101','010301','감염관리 조직과 인력이 있다',1,'Y'),
('12345678','CERT','STD','01030102','010301','감염관리 규정이 있다',2,'Y'),
('12345678','CERT','STD','01030103','010301','감염관리 교육을 수행한다',3,'Y');

-- 010302 손위생 수행을 관리한다
INSERT INTO TW_TREE (HOSP_CD, TAB_ID, GRP_CD, NODE_ID, PARENT_ID, NODE_NM, SORT_ORD, USE_YN) VALUES
('12345678','CERT','STD','01030201','010302','손위생 규정이 있다',1,'Y'),
('12345678','CERT','STD','01030202','010302','손위생 수행률을 모니터링한다',2,'Y'),
('12345678','CERT','STD','01030203','010302','손위생 수행률 결과를 환류한다',3,'Y');

-- 020101 입원 시 환자평가를 수행한다
INSERT INTO TW_TREE (HOSP_CD, TAB_ID, GRP_CD, NODE_ID, PARENT_ID, NODE_NM, SORT_ORD, USE_YN) VALUES
('12345678','CERT','STD','02010101','020101','의학적 초기평가를 수행한다',1,'Y'),
('12345678','CERT','STD','02010102','020101','간호 초기평가를 수행한다',2,'Y'),
('12345678','CERT','STD','02010103','020101','영양 초기평가를 수행한다',3,'Y'),
('12345678','CERT','STD','02010104','020101','기능 초기평가를 수행한다',4,'Y');

-- 020102 진료계획을 수립한다
INSERT INTO TW_TREE (HOSP_CD, TAB_ID, GRP_CD, NODE_ID, PARENT_ID, NODE_NM, SORT_ORD, USE_YN) VALUES
('12345678','CERT','STD','02010201','020102','초기평가에 근거한 진료계획을 수립한다',1,'Y'),
('12345678','CERT','STD','02010202','020102','진료계획에 따라 치료를 수행한다',2,'Y'),
('12345678','CERT','STD','02010203','020102','진료계획의 변경사항을 기록한다',3,'Y');

-- 020401 의약품 관리체계를 운영한다
INSERT INTO TW_TREE (HOSP_CD, TAB_ID, GRP_CD, NODE_ID, PARENT_ID, NODE_NM, SORT_ORD, USE_YN) VALUES
('12345678','CERT','STD','02040101','020401','의약품 관리 규정이 있다',1,'Y'),
('12345678','CERT','STD','02040102','020401','의약품 보관 및 관리를 적절히 수행한다',2,'Y');

-- 020403 투약을 안전하게 수행한다
INSERT INTO TW_TREE (HOSP_CD, TAB_ID, GRP_CD, NODE_ID, PARENT_ID, NODE_NM, SORT_ORD, USE_YN) VALUES
('12345678','CERT','STD','02040301','020403','투약 시 5 Right를 준수한다',1,'Y'),
('12345678','CERT','STD','02040302','020403','고위험약물 투약 시 안전절차를 준수한다',2,'Y');

-- 030201 인력을 적정하게 배치한다
INSERT INTO TW_TREE (HOSP_CD, TAB_ID, GRP_CD, NODE_ID, PARENT_ID, NODE_NM, SORT_ORD, USE_YN) VALUES
('12345678','CERT','STD','03020101','030201','부서별 필요인력을 산정한다',1,'Y'),
('12345678','CERT','STD','03020102','030201','인력배치 기준에 따라 배치한다',2,'Y');

-- 030202 직원 교육훈련을 수행한다
INSERT INTO TW_TREE (HOSP_CD, TAB_ID, GRP_CD, NODE_ID, PARENT_ID, NODE_NM, SORT_ORD, USE_YN) VALUES
('12345678','CERT','STD','03020201','030202','직원 교육훈련 계획이 있다',1,'Y'),
('12345678','CERT','STD','03020202','030202','정기적으로 교육훈련을 수행한다',2,'Y'),
('12345678','CERT','STD','03020203','030202','교육훈련 결과를 평가한다',3,'Y');

-- 040101 질향상 활동을 수행한다
INSERT INTO TW_TREE (HOSP_CD, TAB_ID, GRP_CD, NODE_ID, PARENT_ID, NODE_NM, SORT_ORD, USE_YN) VALUES
('12345678','CERT','STD','04010101','040101','질향상 활동 계획이 있다',1,'Y'),
('12345678','CERT','STD','04010102','040101','질향상 활동을 정기적으로 수행한다',2,'Y'),
('12345678','CERT','STD','04010103','040101','질향상 활동 결과를 환류한다',3,'Y');

-- 040103 질지표를 관리한다
INSERT INTO TW_TREE (HOSP_CD, TAB_ID, GRP_CD, NODE_ID, PARENT_ID, NODE_NM, SORT_ORD, USE_YN) VALUES
('12345678','CERT','STD','04010301','040103','질지표를 선정하여 관리한다',1,'Y'),
('12345678','CERT','STD','04010302','040103','질지표 결과를 분석한다',2,'Y'),
('12345678','CERT','STD','04010303','040103','질지표 결과에 따라 개선활동을 수행한다',3,'Y');


-- ============================================================
-- 추가 공통코드 (각 모듈별)
-- ============================================================

-- 직종
INSERT INTO TW_REF (HOSP_CD, REF_CD, REF_SEQ, REF_VAL, NOTE, USE_YN, REG_USER) VALUES
('12345678','JOB_TYPE',1,'의사','진료','Y','admin'),
('12345678','JOB_TYPE',2,'간호사','간호','Y','admin'),
('12345678','JOB_TYPE',3,'간호조무사','간호보조','Y','admin'),
('12345678','JOB_TYPE',4,'약사','약무','Y','admin'),
('12345678','JOB_TYPE',5,'물리치료사','재활','Y','admin'),
('12345678','JOB_TYPE',6,'작업치료사','재활','Y','admin'),
('12345678','JOB_TYPE',7,'언어치료사','재활','Y','admin'),
('12345678','JOB_TYPE',8,'영양사','영양','Y','admin'),
('12345678','JOB_TYPE',9,'사회복지사','사회복지','Y','admin'),
('12345678','JOB_TYPE',10,'방사선사','진료지원','Y','admin'),
('12345678','JOB_TYPE',11,'임상병리사','진료지원','Y','admin'),
('12345678','JOB_TYPE',12,'행정직','행정','Y','admin'),
('12345678','JOB_TYPE',13,'간병인','간병','Y','admin'),
('12345678','JOB_TYPE',14,'조리원','영양','Y','admin'),
('12345678','JOB_TYPE',15,'시설관리','시설','Y','admin'),
('12345678','JOB_TYPE',16,'환경미화','환경','Y','admin');

-- 성별
INSERT INTO TW_REF (HOSP_CD, REF_CD, REF_SEQ, REF_VAL, NOTE, USE_YN, REG_USER) VALUES
('12345678','GENDER',1,'M','남성','Y','admin'),
('12345678','GENDER',2,'F','여성','Y','admin');

-- 직원상태
INSERT INTO TW_REF (HOSP_CD, REF_CD, REF_SEQ, REF_VAL, NOTE, USE_YN, REG_USER) VALUES
('12345678','STAFF_STATUS',1,'재직','재직중','Y','admin'),
('12345678','STAFF_STATUS',2,'휴직','휴직중','Y','admin'),
('12345678','STAFF_STATUS',3,'퇴직','퇴직','Y','admin');

-- 예방접종 구분
INSERT INTO TW_REF (HOSP_CD, REF_CD, REF_SEQ, REF_VAL, NOTE, USE_YN, REG_USER) VALUES
('12345678','VACCIN_TYPE',1,'독감','인플루엔자','Y','admin'),
('12345678','VACCIN_TYPE',2,'B형간염','B형간염 예방접종','Y','admin'),
('12345678','VACCIN_TYPE',3,'코로나19','COVID-19','Y','admin'),
('12345678','VACCIN_TYPE',4,'폐렴구균','폐렴구균 예방접종','Y','admin'),
('12345678','VACCIN_TYPE',5,'파상풍','Td/Tdap','Y','admin'),
('12345678','VACCIN_TYPE',6,'대상포진','대상포진 예방접종','Y','admin'),
('12345678','VACCIN_TYPE',7,'기타','기타 예방접종','Y','admin');

-- 격리/강박 유형
INSERT INTO TW_REF (HOSP_CD, REF_CD, REF_SEQ, REF_VAL, NOTE, USE_YN, REG_USER) VALUES
('12345678','RESTRAINT_TYPE',1,'격리','감염격리','Y','admin'),
('12345678','RESTRAINT_TYPE',2,'보호격리','보호격리','Y','admin'),
('12345678','RESTRAINT_TYPE',3,'강박','신체강박','Y','admin'),
('12345678','RESTRAINT_TYPE',4,'신체보호대','신체보호대 적용','Y','admin');

-- 소화기 종류
INSERT INTO TW_REF (HOSP_CD, REF_CD, REF_SEQ, REF_VAL, NOTE, USE_YN, REG_USER) VALUES
('12345678','EQUIP_TYPE',1,'ABC분말','ABC분말소화기','Y','admin'),
('12345678','EQUIP_TYPE',2,'CO2','이산화탄소소화기','Y','admin'),
('12345678','EQUIP_TYPE',3,'할론','할론소화기','Y','admin'),
('12345678','EQUIP_TYPE',4,'물소화기','물소화기','Y','admin'),
('12345678','EQUIP_TYPE',5,'자동확산','자동확산소화기','Y','admin');

-- 점검결과
INSERT INTO TW_REF (HOSP_CD, REF_CD, REF_SEQ, REF_VAL, NOTE, USE_YN, REG_USER) VALUES
('12345678','CHK_RESULT',1,'양호','정상','Y','admin'),
('12345678','CHK_RESULT',2,'불량','교체/수리 필요','Y','admin'),
('12345678','CHK_RESULT',3,'미점검','점검 미실시','Y','admin');

-- 교육구분
INSERT INTO TW_REF (HOSP_CD, REF_CD, REF_SEQ, REF_VAL, NOTE, USE_YN, REG_USER) VALUES
('12345678','EDU_TYPE',1,'필수교육','직원 필수교육','Y','admin'),
('12345678','EDU_TYPE',2,'법정의무교육','법정의무교육','Y','admin'),
('12345678','EDU_TYPE',3,'감염관리교육','감염관리 교육','Y','admin'),
('12345678','EDU_TYPE',4,'환자안전교육','환자안전 교육','Y','admin'),
('12345678','EDU_TYPE',5,'CPR교육','심폐소생술 교육','Y','admin'),
('12345678','EDU_TYPE',6,'소방교육','소방안전 교육','Y','admin'),
('12345678','EDU_TYPE',7,'직무교육','직무별 전문교육','Y','admin'),
('12345678','EDU_TYPE',8,'신입직원교육','신입직원 오리엔테이션','Y','admin'),
('12345678','EDU_TYPE',9,'특성화교육','특성화 교육','Y','admin'),
('12345678','EDU_TYPE',10,'기타교육','기타','Y','admin');

-- 교육방법
INSERT INTO TW_REF (HOSP_CD, REF_CD, REF_SEQ, REF_VAL, NOTE, USE_YN, REG_USER) VALUES
('12345678','EDU_METHOD',1,'집합교육','대면 집합교육','Y','admin'),
('12345678','EDU_METHOD',2,'온라인교육','온라인/비대면','Y','admin'),
('12345678','EDU_METHOD',3,'실습교육','실습/시뮬레이션','Y','admin'),
('12345678','EDU_METHOD',4,'자체학습','자체학습(자료배포)','Y','admin'),
('12345678','EDU_METHOD',5,'외부교육','외부 위탁교육','Y','admin');

-- 의료기기 상태
INSERT INTO TW_REF (HOSP_CD, REF_CD, REF_SEQ, REF_VAL, NOTE, USE_YN, REG_USER) VALUES
('12345678','DEVICE_STATUS',1,'정상','정상 사용','Y','admin'),
('12345678','DEVICE_STATUS',2,'수리중','수리/점검 중','Y','admin'),
('12345678','DEVICE_STATUS',3,'폐기','폐기 처리','Y','admin'),
('12345678','DEVICE_STATUS',4,'대기','미사용 대기','Y','admin');

-- 의료기기 점검주기
INSERT INTO TW_REF (HOSP_CD, REF_CD, REF_SEQ, REF_VAL, NOTE, USE_YN, REG_USER) VALUES
('12345678','INSPECT_CYCLE',1,'매일','매일 점검','Y','admin'),
('12345678','INSPECT_CYCLE',2,'매주','주 1회','Y','admin'),
('12345678','INSPECT_CYCLE',3,'매월','월 1회','Y','admin'),
('12345678','INSPECT_CYCLE',4,'분기','분기 1회','Y','admin'),
('12345678','INSPECT_CYCLE',5,'반기','반기 1회','Y','admin'),
('12345678','INSPECT_CYCLE',6,'매년','연 1회','Y','admin');

-- 약품유형
INSERT INTO TW_REF (HOSP_CD, REF_CD, REF_SEQ, REF_VAL, NOTE, USE_YN, REG_USER) VALUES
('12345678','DRUG_TYPE',1,'일반','일반의약품','Y','admin'),
('12345678','DRUG_TYPE',2,'전문','전문의약품','Y','admin'),
('12345678','DRUG_TYPE',3,'마약류','마약류','Y','admin'),
('12345678','DRUG_TYPE',4,'향정신성','향정신성의약품','Y','admin'),
('12345678','DRUG_TYPE',5,'고위험','고위험의약품','Y','admin'),
('12345678','DRUG_TYPE',6,'냉장보관','냉장보관의약품','Y','admin');

-- 보관조건
INSERT INTO TW_REF (HOSP_CD, REF_CD, REF_SEQ, REF_VAL, NOTE, USE_YN, REG_USER) VALUES
('12345678','STORAGE_COND',1,'실온','실온보관(15~25도)','Y','admin'),
('12345678','STORAGE_COND',2,'냉장','냉장보관(2~8도)','Y','admin'),
('12345678','STORAGE_COND',3,'냉동','냉동보관(-20도이하)','Y','admin'),
('12345678','STORAGE_COND',4,'차광','차광보관','Y','admin'),
('12345678','STORAGE_COND',5,'방습','방습보관','Y','admin');

-- 감염유형
INSERT INTO TW_REF (HOSP_CD, REF_CD, REF_SEQ, REF_VAL, NOTE, USE_YN, REG_USER) VALUES
('12345678','INFECT_TYPE',1,'요로감염','UTI','Y','admin'),
('12345678','INFECT_TYPE',2,'폐렴','Pneumonia','Y','admin'),
('12345678','INFECT_TYPE',3,'피부감염','Skin infection','Y','admin'),
('12345678','INFECT_TYPE',4,'MRSA','메티실린내성황색포도알균','Y','admin'),
('12345678','INFECT_TYPE',5,'VRE','반코마이신내성장알균','Y','admin'),
('12345678','INFECT_TYPE',6,'CDI','클로스트리디움디피실','Y','admin'),
('12345678','INFECT_TYPE',7,'결핵','Tuberculosis','Y','admin'),
('12345678','INFECT_TYPE',8,'옴','Scabies','Y','admin'),
('12345678','INFECT_TYPE',9,'노로바이러스','Norovirus','Y','admin'),
('12345678','INFECT_TYPE',10,'기타','기타 감염','Y','admin');

-- 격리유형
INSERT INTO TW_REF (HOSP_CD, REF_CD, REF_SEQ, REF_VAL, NOTE, USE_YN, REG_USER) VALUES
('12345678','ISOLATION_TYPE',1,'접촉격리','접촉주의','Y','admin'),
('12345678','ISOLATION_TYPE',2,'비말격리','비말주의','Y','admin'),
('12345678','ISOLATION_TYPE',3,'공기격리','공기주의','Y','admin'),
('12345678','ISOLATION_TYPE',4,'보호격리','역격리(면역저하)','Y','admin');

-- 손위생 직종
INSERT INTO TW_REF (HOSP_CD, REF_CD, REF_SEQ, REF_VAL, NOTE, USE_YN, REG_USER) VALUES
('12345678','HH_JOB_TYPE',1,'의사','의사','Y','admin'),
('12345678','HH_JOB_TYPE',2,'간호사','간호사','Y','admin'),
('12345678','HH_JOB_TYPE',3,'간호조무사','간호조무사','Y','admin'),
('12345678','HH_JOB_TYPE',4,'간병인','간병인','Y','admin'),
('12345678','HH_JOB_TYPE',5,'치료사','물리/작업/언어치료사','Y','admin'),
('12345678','HH_JOB_TYPE',6,'기타','기타 직종','Y','admin');

-- 통증유형
INSERT INTO TW_REF (HOSP_CD, REF_CD, REF_SEQ, REF_VAL, NOTE, USE_YN, REG_USER) VALUES
('12345678','PAIN_TYPE',1,'급성','급성 통증','Y','admin'),
('12345678','PAIN_TYPE',2,'만성','만성 통증','Y','admin'),
('12345678','PAIN_TYPE',3,'암성','암성 통증','Y','admin'),
('12345678','PAIN_TYPE',4,'신경병증','신경병증성 통증','Y','admin');

-- 식이유형
INSERT INTO TW_REF (HOSP_CD, REF_CD, REF_SEQ, REF_VAL, NOTE, USE_YN, REG_USER) VALUES
('12345678','DIET_TYPE',1,'일반식','일반식이','Y','admin'),
('12345678','DIET_TYPE',2,'죽식','죽','Y','admin'),
('12345678','DIET_TYPE',3,'미음','미음','Y','admin'),
('12345678','DIET_TYPE',4,'유동식','유동식','Y','admin'),
('12345678','DIET_TYPE',5,'당뇨식','당뇨식이','Y','admin'),
('12345678','DIET_TYPE',6,'저염식','저염식이','Y','admin'),
('12345678','DIET_TYPE',7,'신장식','신장질환식이','Y','admin'),
('12345678','DIET_TYPE',8,'연하곤란식','연하곤란식이','Y','admin'),
('12345678','DIET_TYPE',9,'경관급식','경관영양(Tube feeding)','Y','admin'),
('12345678','DIET_TYPE',10,'금식','NPO','Y','admin');

-- 영양선별도구
INSERT INTO TW_REF (HOSP_CD, REF_CD, REF_SEQ, REF_VAL, NOTE, USE_YN, REG_USER) VALUES
('12345678','NUTR_TOOL',1,'MNA','Mini Nutritional Assessment','Y','admin'),
('12345678','NUTR_TOOL',2,'MUST','Malnutrition Universal Screening Tool','Y','admin'),
('12345678','NUTR_TOOL',3,'NRS-2002','Nutritional Risk Screening','Y','admin'),
('12345678','NUTR_TOOL',4,'SGA','Subjective Global Assessment','Y','admin');

-- 영양위험도
INSERT INTO TW_REF (HOSP_CD, REF_CD, REF_SEQ, REF_VAL, NOTE, USE_YN, REG_USER) VALUES
('12345678','NUTR_RISK',1,'정상','영양상태 양호','Y','admin'),
('12345678','NUTR_RISK',2,'저위험','영양불량 위험 낮음','Y','admin'),
('12345678','NUTR_RISK',3,'고위험','영양불량 고위험','Y','admin');

-- 재활유형
INSERT INTO TW_REF (HOSP_CD, REF_CD, REF_SEQ, REF_VAL, NOTE, USE_YN, REG_USER) VALUES
('12345678','REHAB_TYPE',1,'물리치료','Physical Therapy','Y','admin'),
('12345678','REHAB_TYPE',2,'작업치료','Occupational Therapy','Y','admin'),
('12345678','REHAB_TYPE',3,'언어치료','Speech Therapy','Y','admin'),
('12345678','REHAB_TYPE',4,'인지치료','Cognitive Therapy','Y','admin'),
('12345678','REHAB_TYPE',5,'심리치료','Psychotherapy','Y','admin');

-- 동의서유형
INSERT INTO TW_REF (HOSP_CD, REF_CD, REF_SEQ, REF_VAL, NOTE, USE_YN, REG_USER) VALUES
('12345678','CONSENT_TYPE',1,'입원동의서','입원 동의서','Y','admin'),
('12345678','CONSENT_TYPE',2,'수술동의서','수술 동의서','Y','admin'),
('12345678','CONSENT_TYPE',3,'시술동의서','시술 동의서','Y','admin'),
('12345678','CONSENT_TYPE',4,'수혈동의서','수혈 동의서','Y','admin'),
('12345678','CONSENT_TYPE',5,'마취동의서','마취 동의서','Y','admin'),
('12345678','CONSENT_TYPE',6,'DNR동의서','심폐소생술 거부 동의서','Y','admin'),
('12345678','CONSENT_TYPE',7,'신체보호대동의서','신체보호대 적용 동의서','Y','admin'),
('12345678','CONSENT_TYPE',8,'격리동의서','격리 동의서','Y','admin'),
('12345678','CONSENT_TYPE',9,'개인정보동의서','개인정보 수집이용 동의서','Y','admin'),
('12345678','CONSENT_TYPE',10,'퇴원동의서','자의퇴원 동의서','Y','admin');

-- 안전라운딩 유형
INSERT INTO TW_REF (HOSP_CD, REF_CD, REF_SEQ, REF_VAL, NOTE, USE_YN, REG_USER) VALUES
('12345678','ROUND_TYPE',1,'시설환경','시설환경 라운딩','Y','admin'),
('12345678','ROUND_TYPE',2,'감염관리','감염관리 라운딩','Y','admin'),
('12345678','ROUND_TYPE',3,'안전점검','안전 라운딩','Y','admin'),
('12345678','ROUND_TYPE',4,'환자안전','환자안전 라운딩','Y','admin'),
('12345678','ROUND_TYPE',5,'약품관리','약품관리 라운딩','Y','admin');

-- 소독/멸균 방법
INSERT INTO TW_REF (HOSP_CD, REF_CD, REF_SEQ, REF_VAL, NOTE, USE_YN, REG_USER) VALUES
('12345678','STER_METHOD',1,'고압증기','Autoclave','Y','admin'),
('12345678','STER_METHOD',2,'EO가스','Ethylene Oxide','Y','admin'),
('12345678','STER_METHOD',3,'과초산','Peracetic Acid','Y','admin'),
('12345678','STER_METHOD',4,'글루타알데히드','Glutaraldehyde','Y','admin'),
('12345678','STER_METHOD',5,'차아염소산','Hypochlorite','Y','admin'),
('12345678','STER_METHOD',6,'알코올','Alcohol','Y','admin'),
('12345678','STER_METHOD',7,'4급암모늄','Quaternary Ammonium','Y','admin');

-- 폐기물 유형
INSERT INTO TW_REF (HOSP_CD, REF_CD, REF_SEQ, REF_VAL, NOTE, USE_YN, REG_USER) VALUES
('12345678','WASTE_TYPE',1,'일반의료폐기물','일반 의료폐기물','Y','admin'),
('12345678','WASTE_TYPE',2,'위해의료폐기물','위해 의료폐기물','Y','admin'),
('12345678','WASTE_TYPE',3,'격리의료폐기물','감염 격리 폐기물','Y','admin'),
('12345678','WASTE_TYPE',4,'손상성폐기물','주사바늘 등 손상성','Y','admin'),
('12345678','WASTE_TYPE',5,'일반폐기물','생활 폐기물','Y','admin');

-- 퇴원유형
INSERT INTO TW_REF (HOSP_CD, REF_CD, REF_SEQ, REF_VAL, NOTE, USE_YN, REG_USER) VALUES
('12345678','DISCH_TYPE',1,'퇴원','정상 퇴원','Y','admin'),
('12345678','DISCH_TYPE',2,'전원','타병원 전원','Y','admin'),
('12345678','DISCH_TYPE',3,'자의퇴원','자의 퇴원(DAMA)','Y','admin'),
('12345678','DISCH_TYPE',4,'사망','사망','Y','admin');

-- 위원회 유형
INSERT INTO TW_REF (HOSP_CD, REF_CD, REF_SEQ, REF_VAL, NOTE, USE_YN, REG_USER) VALUES
('12345678','COMM_TYPE',1,'감염관리위원회','감염관리위원회','Y','admin'),
('12345678','COMM_TYPE',2,'QI위원회','질향상위원회','Y','admin'),
('12345678','COMM_TYPE',3,'의약품심의위원회','약사위원회','Y','admin'),
('12345678','COMM_TYPE',4,'윤리위원회','윤리위원회','Y','admin'),
('12345678','COMM_TYPE',5,'안전관리위원회','안전관리위원회','Y','admin'),
('12345678','COMM_TYPE',6,'영양위원회','영양위원회','Y','admin'),
('12345678','COMM_TYPE',7,'의무기록위원회','의무기록위원회','Y','admin'),
('12345678','COMM_TYPE',8,'환자안전위원회','환자안전전담위원회','Y','admin');

-- CPR/훈련 유형
INSERT INTO TW_REF (HOSP_CD, REF_CD, REF_SEQ, REF_VAL, NOTE, USE_YN, REG_USER) VALUES
('12345678','DRILL_TYPE',1,'CPR','심폐소생술 훈련','Y','admin'),
('12345678','DRILL_TYPE',2,'소방훈련','소방대피 훈련','Y','admin'),
('12345678','DRILL_TYPE',3,'재난훈련','재난대응 훈련','Y','admin'),
('12345678','DRILL_TYPE',4,'코드블루','코드블루 모의훈련','Y','admin'),
('12345678','DRILL_TYPE',5,'감염대응','감염병 대응훈련','Y','admin');

-- 수질검사 유형
INSERT INTO TW_REF (HOSP_CD, REF_CD, REF_SEQ, REF_VAL, NOTE, USE_YN, REG_USER) VALUES
('12345678','WATER_TYPE',1,'음용수','음용수 수질검사','Y','admin'),
('12345678','WATER_TYPE',2,'냉각탑','냉각탑 수질검사','Y','admin'),
('12345678','WATER_TYPE',3,'저수조','저수조 수질검사','Y','admin');

-- 민원유형
INSERT INTO TW_REF (HOSP_CD, REF_CD, REF_SEQ, REF_VAL, NOTE, USE_YN, REG_USER) VALUES
('12345678','COMP_TYPE',1,'불만','불만 접수','Y','admin'),
('12345678','COMP_TYPE',2,'건의','건의사항','Y','admin'),
('12345678','COMP_TYPE',3,'칭찬','칭찬','Y','admin'),
('12345678','COMP_TYPE',4,'기타','기타','Y','admin');

-- 접수경로
INSERT INTO TW_REF (HOSP_CD, REF_CD, REF_SEQ, REF_VAL, NOTE, USE_YN, REG_USER) VALUES
('12345678','COMP_CHANNEL',1,'대면','대면 접수','Y','admin'),
('12345678','COMP_CHANNEL',2,'전화','전화 접수','Y','admin'),
('12345678','COMP_CHANNEL',3,'서면','서면 접수','Y','admin'),
('12345678','COMP_CHANNEL',4,'온라인','온라인 접수','Y','admin'),
('12345678','COMP_CHANNEL',5,'투서함','투서함','Y','admin');

-- 휴가유형
INSERT INTO TW_REF (HOSP_CD, REF_CD, REF_SEQ, REF_VAL, NOTE, USE_YN, REG_USER) VALUES
('12345678','VAC_TYPE',1,'연차','연차휴가','Y','admin'),
('12345678','VAC_TYPE',2,'병가','병가','Y','admin'),
('12345678','VAC_TYPE',3,'공가','공가','Y','admin'),
('12345678','VAC_TYPE',4,'특별휴가','경조사 등 특별휴가','Y','admin'),
('12345678','VAC_TYPE',5,'반차','반차(오전/오후)','Y','admin');

-- 부서유형
INSERT INTO TW_REF (HOSP_CD, REF_CD, REF_SEQ, REF_VAL, NOTE, USE_YN, REG_USER) VALUES
('12345678','DEPT_TYPE',1,'진료','진료부서','Y','admin'),
('12345678','DEPT_TYPE',2,'간호','간호부서','Y','admin'),
('12345678','DEPT_TYPE',3,'행정','행정부서','Y','admin'),
('12345678','DEPT_TYPE',4,'지원','지원부서','Y','admin');

-- 병동유형
INSERT INTO TW_REF (HOSP_CD, REF_CD, REF_SEQ, REF_VAL, NOTE, USE_YN, REG_USER) VALUES
('12345678','WARD_TYPE',1,'일반병동','일반 요양병동','Y','admin'),
('12345678','WARD_TYPE',2,'치매전담병동','치매전담 병동','Y','admin'),
('12345678','WARD_TYPE',3,'호스피스병동','호스피스 완화의료','Y','admin'),
('12345678','WARD_TYPE',4,'재활병동','재활 병동','Y','admin'),
('12345678','WARD_TYPE',5,'격리병동','감염 격리병동','Y','admin');

-- 팀유형
INSERT INTO TW_REF (HOSP_CD, REF_CD, REF_SEQ, REF_VAL, NOTE, USE_YN, REG_USER) VALUES
('12345678','TEAM_TYPE',1,'인증TFT','인증준비 TFT','Y','admin'),
('12345678','TEAM_TYPE',2,'QI팀','질향상(QI) 팀','Y','admin'),
('12345678','TEAM_TYPE',3,'감염관리팀','감염관리 팀','Y','admin'),
('12345678','TEAM_TYPE',4,'환자안전팀','환자안전 전담팀','Y','admin'),
('12345678','TEAM_TYPE',5,'교육팀','교육 팀','Y','admin');

-- 규정유형
INSERT INTO TW_REF (HOSP_CD, REF_CD, REF_SEQ, REF_VAL, NOTE, USE_YN, REG_USER) VALUES
('12345678','GUIDE_TYPE',1,'규정','규정(Policy)','Y','admin'),
('12345678','GUIDE_TYPE',2,'지침','지침(Guideline)','Y','admin'),
('12345678','GUIDE_TYPE',3,'매뉴얼','매뉴얼(Manual)','Y','admin'),
('12345678','GUIDE_TYPE',4,'프로토콜','프로토콜(Protocol)','Y','admin'),
('12345678','GUIDE_TYPE',5,'절차서','절차서(Procedure)','Y','admin');

-- 검토주기
INSERT INTO TW_REF (HOSP_CD, REF_CD, REF_SEQ, REF_VAL, NOTE, USE_YN, REG_USER) VALUES
('12345678','REVIEW_CYCLE',1,'1년','매년 검토','Y','admin'),
('12345678','REVIEW_CYCLE',2,'2년','2년 주기','Y','admin'),
('12345678','REVIEW_CYCLE',3,'3년','3년 주기','Y','admin');

-- 문서유형 (파일첨부)
INSERT INTO TW_REF (HOSP_CD, REF_CD, REF_SEQ, REF_VAL, NOTE, USE_YN, REG_USER) VALUES
('12345678','FILE_TYPE',1,'규정','규정문서','Y','admin'),
('12345678','FILE_TYPE',2,'지침','지침문서','Y','admin'),
('12345678','FILE_TYPE',3,'서식','서식/양식','Y','admin'),
('12345678','FILE_TYPE',4,'교육자료','교육자료','Y','admin'),
('12345678','FILE_TYPE',5,'회의록','회의록','Y','admin'),
('12345678','FILE_TYPE',6,'보고서','보고서','Y','admin'),
('12345678','FILE_TYPE',7,'기타','기타 문서','Y','admin');

-- 근무유형 (근무표)
INSERT INTO TW_REF (HOSP_CD, REF_CD, REF_SEQ, REF_VAL, NOTE, USE_YN, REG_USER) VALUES
('12345678','DUTY_TYPE',1,'D','주간근무(Day)','Y','admin'),
('12345678','DUTY_TYPE',2,'E','저녁근무(Evening)','Y','admin'),
('12345678','DUTY_TYPE',3,'N','야간근무(Night)','Y','admin'),
('12345678','DUTY_TYPE',4,'OFF','휴무','Y','admin'),
('12345678','DUTY_TYPE',5,'AL','연차','Y','admin'),
('12345678','DUTY_TYPE',6,'교육','교육','Y','admin');

-- 업무계획 유형
INSERT INTO TW_REF (HOSP_CD, REF_CD, REF_SEQ, REF_VAL, NOTE, USE_YN, REG_USER) VALUES
('12345678','PLAN_TYPE',1,'인증준비','인증 준비 업무','Y','admin'),
('12345678','PLAN_TYPE',2,'교육','교육 관련','Y','admin'),
('12345678','PLAN_TYPE',3,'점검','점검/라운딩','Y','admin'),
('12345678','PLAN_TYPE',4,'회의','회의/위원회','Y','admin'),
('12345678','PLAN_TYPE',5,'기타','기타 업무','Y','admin');

-- 우선순위
INSERT INTO TW_REF (HOSP_CD, REF_CD, REF_SEQ, REF_VAL, NOTE, USE_YN, REG_USER) VALUES
('12345678','PRIORITY',1,'상','긴급/중요','Y','admin'),
('12345678','PRIORITY',2,'중','보통','Y','admin'),
('12345678','PRIORITY',3,'하','낮음','Y','admin');

-- 낙상 손상등급
INSERT INTO TW_REF (HOSP_CD, REF_CD, REF_SEQ, REF_VAL, NOTE, USE_YN, REG_USER) VALUES
('12345678','INJURY_GRADE',1,'없음','손상 없음','Y','admin'),
('12345678','INJURY_GRADE',2,'경미','찰과상/타박상','Y','admin'),
('12345678','INJURY_GRADE',3,'중등도','열상/골절 의심','Y','admin'),
('12345678','INJURY_GRADE',4,'심각','골절/두부손상','Y','admin');

-- 욕창 단계
INSERT INTO TW_REF (HOSP_CD, REF_CD, REF_SEQ, REF_VAL, NOTE, USE_YN, REG_USER) VALUES
('12345678','PU_STAGE',1,'1단계','발적(비창백성 홍반)','Y','admin'),
('12345678','PU_STAGE',2,'2단계','부분층 피부손실','Y','admin'),
('12345678','PU_STAGE',3,'3단계','전층 피부손실','Y','admin'),
('12345678','PU_STAGE',4,'4단계','전층 조직손실','Y','admin'),
('12345678','PU_STAGE',5,'미분류','분류불가','Y','admin'),
('12345678','PU_STAGE',6,'DTPI','심부조직손상 의심','Y','admin');

-- 투여경로
INSERT INTO TW_REF (HOSP_CD, REF_CD, REF_SEQ, REF_VAL, NOTE, USE_YN, REG_USER) VALUES
('12345678','DRUG_ROUTE',1,'경구','PO (경구)','Y','admin'),
('12345678','DRUG_ROUTE',2,'정맥주사','IV (정맥)','Y','admin'),
('12345678','DRUG_ROUTE',3,'근육주사','IM (근육)','Y','admin'),
('12345678','DRUG_ROUTE',4,'피하주사','SC (피하)','Y','admin'),
('12345678','DRUG_ROUTE',5,'외용','External (외용)','Y','admin'),
('12345678','DRUG_ROUTE',6,'점안','Eye drop (점안)','Y','admin'),
('12345678','DRUG_ROUTE',7,'흡입','Inhalation (흡입)','Y','admin'),
('12345678','DRUG_ROUTE',8,'직장','PR (직장)','Y','admin');

-- 세탁물 구분
INSERT INTO TW_REF (HOSP_CD, REF_CD, REF_SEQ, REF_VAL, NOTE, USE_YN, REG_USER) VALUES
('12345678','LAUNDRY_TYPE',1,'일반세탁물','일반 세탁물','Y','admin'),
('12345678','LAUNDRY_TYPE',2,'감염세탁물','감염 오염 세탁물','Y','admin');

-- 게시판 유형
INSERT INTO TW_REF (HOSP_CD, REF_CD, REF_SEQ, REF_VAL, NOTE, USE_YN, REG_USER) VALUES
('12345678','BOARD_TYPE',1,'GENERAL','일반 게시판','Y','admin'),
('12345678','BOARD_TYPE',2,'CERT','인증 게시판','Y','admin'),
('12345678','BOARD_TYPE',3,'QPS','QPS 게시판','Y','admin'),
('12345678','BOARD_TYPE',4,'INFECTION','감염관리 게시판','Y','admin');

-- 검체유형
INSERT INTO TW_REF (HOSP_CD, REF_CD, REF_SEQ, REF_VAL, NOTE, USE_YN, REG_USER) VALUES
('12345678','TEST_TYPE',1,'혈액','Blood','Y','admin'),
('12345678','TEST_TYPE',2,'소변','Urine','Y','admin'),
('12345678','TEST_TYPE',3,'미생물','Culture','Y','admin'),
('12345678','TEST_TYPE',4,'조직','Tissue','Y','admin'),
('12345678','TEST_TYPE',5,'객담','Sputum','Y','admin');

-- 차트유형
INSERT INTO TW_REF (HOSP_CD, REF_CD, REF_SEQ, REF_VAL, NOTE, USE_YN, REG_USER) VALUES
('12345678','CHART_TYPE',1,'초기평가','의학적 초기평가','Y','admin'),
('12345678','CHART_TYPE',2,'간호초기평가','간호 초기평가','Y','admin'),
('12345678','CHART_TYPE',3,'경과기록','의사 경과기록','Y','admin'),
('12345678','CHART_TYPE',4,'간호기록','간호 기록','Y','admin'),
('12345678','CHART_TYPE',5,'투약기록','투약 기록','Y','admin'),
('12345678','CHART_TYPE',6,'퇴원요약','퇴원 요약','Y','admin'),
('12345678','CHART_TYPE',7,'재활기록','재활치료 기록','Y','admin'),
('12345678','CHART_TYPE',8,'영양기록','영양 기록','Y','admin');

-- 인증유형
INSERT INTO TW_REF (HOSP_CD, REF_CD, REF_SEQ, REF_VAL, NOTE, USE_YN, REG_USER) VALUES
('12345678','CERT_TYPE',1,'본인증','본인증 조사','Y','admin'),
('12345678','CERT_TYPE',2,'중간자체','중간 자체점검','Y','admin'),
('12345678','CERT_TYPE',3,'갱신','인증 갱신','Y','admin');

-- 병원유형
INSERT INTO TW_REF (HOSP_CD, REF_CD, REF_SEQ, REF_VAL, NOTE, USE_YN, REG_USER) VALUES
('12345678','HOSP_TYPE',1,'요양병원','요양병원','Y','admin'),
('12345678','HOSP_TYPE',2,'정신병원','정신건강의학과 병원','Y','admin'),
('12345678','HOSP_TYPE',3,'재활병원','재활전문병원','Y','admin');
