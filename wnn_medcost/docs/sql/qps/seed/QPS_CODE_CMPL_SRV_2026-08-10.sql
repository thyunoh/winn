-- ═══════════════════════════════════════════════════════════════════
--  QPS 공통코드 — 불만고충 · 환자만족도 조사
--  2026-08-10
--
--  ※ 원본(기존 프로그램) 서식 조사 결과를 코드화한 것.
--    조사 내역과 판단 근거는 docs/proposals/QPS_세션요약_2026-08-08.md 참조.
--
--  ★불만고충 코드값은 원본 서식마다 달랐다(기본형 '처치' vs 전반기형 '관리' 등).
--    ⇒ 번호가 정상이고 항목이 더 완전한 「전반기/후반기형」을 정본으로 채택했다.
--
--  ※ 재실행 안전 (ON DUPLICATE KEY UPDATE / CREATE IF NOT EXISTS)
-- ═══════════════════════════════════════════════════════════════════

-- ── 1. 코드 마스터 ──────────────────────────────────────────────────
INSERT INTO TBL_CODE_MST (CODE_CD, JOB_SEQ, CODE_NM, START_DT, END_DT, USE_YN, ACTION_YN, REG_USER) VALUES
 ('QPS_CMPL_TYPE'   ,1,'불만고충 유형'      ,'20000101','99991231','Y','Y','system'),
 ('QPS_CMPL_RECV'   ,1,'불만고충 접수유형'  ,'20000101','99991231','Y','Y','system'),
 ('QPS_CMPL_REPLY'  ,1,'불만고충 회신방법'  ,'20000101','99991231','Y','Y','system'),
 ('QPS_CMPL_NOREPLY',1,'불만고충 미회신사유','20000101','99991231','Y','Y','system'),
 ('QPS_CMPL_TERM'   ,1,'불만고충 처리기간구간','20000101','99991231','Y','Y','system'),
 ('QPS_CMPL_PERSON' ,1,'불만고충 민원인구분','20000101','99991231','Y','Y','system'),
 ('QPS_SRV_AREA'    ,1,'만족도 조사영역'    ,'20000101','99991231','Y','Y','system'),
 ('QPS_SRV_SCALE'   ,1,'만족도 척도'        ,'20000101','99991231','Y','Y','system'),
 ('QPS_SRV_WRITER'  ,1,'만족도 설문 작성자' ,'20000101','99991231','Y','Y','system'),
 ('QPS_SRV_AGE'     ,1,'만족도 설문 연령대' ,'20000101','99991231','Y','Y','system'),
 ('QPS_IMPR_TYPE'   ,1,'개선활동 유형'      ,'20000101','99991231','Y','Y','system')
ON DUPLICATE KEY UPDATE CODE_NM=VALUES(CODE_NM), USE_YN='Y', ACTION_YN='Y';


-- ── 2. 불만고충 유형 ────────────────────────────────────────────────
--   ★전반기/후반기형 기준. 기본형(구버전)의 '처치'는 채택하지 않고 '관리'를 쓴다.
--     병원별로 달라질 수 있으므로 이 코드는 화면에서 관리 가능해야 한다(고정 배열 금지).
INSERT INTO TBL_CODE_DTL (CODE_GB, CODE_CD, SUB_CODE, JOB_SEQ, SUB_CODE_NM, START_DT, END_DT, USE_YN, SORT, ACTION_YN, REG_USER) VALUES
 ('Q','QPS_CMPL_TYPE','01',1,'시설 및 환경','20000101','99991231','Y',1,'Y','system'),
 ('Q','QPS_CMPL_TYPE','02',1,'친절'        ,'20000101','99991231','Y',2,'Y','system'),
 ('Q','QPS_CMPL_TYPE','03',1,'식사'        ,'20000101','99991231','Y',3,'Y','system'),
 ('Q','QPS_CMPL_TYPE','04',1,'관리'        ,'20000101','99991231','Y',4,'Y','system'),
 ('Q','QPS_CMPL_TYPE','05',1,'진료'        ,'20000101','99991231','Y',5,'Y','system'),
 ('Q','QPS_CMPL_TYPE','06',1,'간병사관련'  ,'20000101','99991231','Y',6,'Y','system'),
 ('Q','QPS_CMPL_TYPE','99',1,'기타'        ,'20000101','99991231','Y',99,'Y','system')
ON DUPLICATE KEY UPDATE SUB_CODE_NM=VALUES(SUB_CODE_NM), SORT=VALUES(SORT), USE_YN='Y', ACTION_YN='Y';

-- ── 3. 접수유형 ─────────────────────────────────────────────────────
INSERT INTO TBL_CODE_DTL (CODE_GB, CODE_CD, SUB_CODE, JOB_SEQ, SUB_CODE_NM, START_DT, END_DT, USE_YN, SORT, ACTION_YN, REG_USER) VALUES
 ('Q','QPS_CMPL_RECV','01',1,'직접방문'    ,'20000101','99991231','Y',1,'Y','system'),
 ('Q','QPS_CMPL_RECV','02',1,'전화'        ,'20000101','99991231','Y',2,'Y','system'),
 ('Q','QPS_CMPL_RECV','03',1,'고객의소리함','20000101','99991231','Y',3,'Y','system'),
 ('Q','QPS_CMPL_RECV','99',1,'기타'        ,'20000101','99991231','Y',99,'Y','system')
ON DUPLICATE KEY UPDATE SUB_CODE_NM=VALUES(SUB_CODE_NM), SORT=VALUES(SORT), USE_YN='Y', ACTION_YN='Y';

-- ── 4. 회신방법 ─────────────────────────────────────────────────────
--   ★'구두'는 전반기/후반기형에만 있다. 실제 운용에 맞으므로 채택.
INSERT INTO TBL_CODE_DTL (CODE_GB, CODE_CD, SUB_CODE, JOB_SEQ, SUB_CODE_NM, START_DT, END_DT, USE_YN, SORT, ACTION_YN, REG_USER) VALUES
 ('Q','QPS_CMPL_REPLY','01',1,'구두'    ,'20000101','99991231','Y',1,'Y','system'),
 ('Q','QPS_CMPL_REPLY','02',1,'직접방문','20000101','99991231','Y',2,'Y','system'),
 ('Q','QPS_CMPL_REPLY','03',1,'전화'    ,'20000101','99991231','Y',3,'Y','system'),
 ('Q','QPS_CMPL_REPLY','04',1,'E-mail'  ,'20000101','99991231','Y',4,'Y','system'),
 ('Q','QPS_CMPL_REPLY','99',1,'기타'    ,'20000101','99991231','Y',99,'Y','system')
ON DUPLICATE KEY UPDATE SUB_CODE_NM=VALUES(SUB_CODE_NM), SORT=VALUES(SORT), USE_YN='Y', ACTION_YN='Y';

-- ── 5. 미회신 사유 ──────────────────────────────────────────────────
INSERT INTO TBL_CODE_DTL (CODE_GB, CODE_CD, SUB_CODE, JOB_SEQ, SUB_CODE_NM, START_DT, END_DT, USE_YN, SORT, ACTION_YN, REG_USER) VALUES
 ('Q','QPS_CMPL_NOREPLY','01',1,'성함, 연락처 미기재','20000101','99991231','Y',1,'Y','system'),
 ('Q','QPS_CMPL_NOREPLY','02',1,'전화, 메일 주소오류','20000101','99991231','Y',2,'Y','system'),
 ('Q','QPS_CMPL_NOREPLY','99',1,'기타'               ,'20000101','99991231','Y',99,'Y','system')
ON DUPLICATE KEY UPDATE SUB_CODE_NM=VALUES(SUB_CODE_NM), SORT=VALUES(SORT), USE_YN='Y', ACTION_YN='Y';

-- ── 6. 처리기간 구간 ────────────────────────────────────────────────
--   ★대장에는 「일수」가 들어가고, 보고서에서 이 구간으로 묶어 집계한다.
--     경계값은 서버 집계 로직에서 처리 : 1~3 / 4~7 / 8 이상
INSERT INTO TBL_CODE_DTL (CODE_GB, CODE_CD, SUB_CODE, JOB_SEQ, SUB_CODE_NM, START_DT, END_DT, USE_YN, SORT, ACTION_YN, REG_USER) VALUES
 ('Q','QPS_CMPL_TERM','01',1,'1일~3일' ,'20000101','99991231','Y',1,'Y','system'),
 ('Q','QPS_CMPL_TERM','02',1,'4일~7일' ,'20000101','99991231','Y',2,'Y','system'),
 ('Q','QPS_CMPL_TERM','03',1,'7일 이후','20000101','99991231','Y',3,'Y','system')
ON DUPLICATE KEY UPDATE SUB_CODE_NM=VALUES(SUB_CODE_NM), SORT=VALUES(SORT), USE_YN='Y', ACTION_YN='Y';

-- ── 7. 민원인 구분 ──────────────────────────────────────────────────
--   ★처리결과 보고서에만 있는 구분(대장엔 없음). '내원객'이 별도로 있다.
INSERT INTO TBL_CODE_DTL (CODE_GB, CODE_CD, SUB_CODE, JOB_SEQ, SUB_CODE_NM, START_DT, END_DT, USE_YN, SORT, ACTION_YN, REG_USER) VALUES
 ('Q','QPS_CMPL_PERSON','01',1,'입원환자','20000101','99991231','Y',1,'Y','system'),
 ('Q','QPS_CMPL_PERSON','02',1,'보호자'  ,'20000101','99991231','Y',2,'Y','system'),
 ('Q','QPS_CMPL_PERSON','03',1,'내원객'  ,'20000101','99991231','Y',3,'Y','system'),
 ('Q','QPS_CMPL_PERSON','99',1,'기타'    ,'20000101','99991231','Y',99,'Y','system')
ON DUPLICATE KEY UPDATE SUB_CODE_NM=VALUES(SUB_CODE_NM), SORT=VALUES(SORT), USE_YN='Y', ACTION_YN='Y';


-- ═══ 환자만족도 조사 ═══════════════════════════════════════════════

-- ── 8. 조사영역 (설문지 4개 영역) ───────────────────────────────────
--   SUB_CODE_NM = 설문지 표기, 지표분석 보고서의 요약표는 짧은 이름을 쓴다(주석 참고).
INSERT INTO TBL_CODE_DTL (CODE_GB, CODE_CD, SUB_CODE, JOB_SEQ, SUB_CODE_NM, START_DT, END_DT, USE_YN, SORT, ACTION_YN, REG_USER) VALUES
 ('Q','QPS_SRV_AREA','1',1,'전반적인 환경 시설에 대한 만족도'       ,'20000101','99991231','Y',1,'Y','system'), -- 요약표: 환경및시설
 ('Q','QPS_SRV_AREA','2',1,'직원의 친절성과 성의에 대한 만족도'     ,'20000101','99991231','Y',2,'Y','system'), -- 요약표: 친절성
 ('Q','QPS_SRV_AREA','3',1,'환자에 대한 관심과 서비스에 대한 만족도','20000101','99991231','Y',3,'Y','system'), -- 요약표: 서비스
 ('Q','QPS_SRV_AREA','4',1,'병원 의료에 대한 전반적인 만족도'       ,'20000101','99991231','Y',4,'Y','system')  -- 요약표: 의료만족
ON DUPLICATE KEY UPDATE SUB_CODE_NM=VALUES(SUB_CODE_NM), SORT=VALUES(SORT), USE_YN='Y', ACTION_YN='Y';

-- ── 9. 만족도 척도 ★★배점 주의 ─────────────────────────────────────
--   ★★설문지의 보기 번호는 1→5 순서이지만, 배점은 5→1 이다.
--     (원본 「만족지수 산출기준」표: 매우만족1=5점 … 매우불만족5=1점)
--     ⇒ SUB_CODE = 배점 그 자체로 둔다. 표시 순서는 SORT 가 담당한다.
--       이렇게 해야 집계 시 SUM(SUB_CODE * 인원) 으로 바로 점수합이 나온다.
INSERT INTO TBL_CODE_DTL (CODE_GB, CODE_CD, SUB_CODE, JOB_SEQ, SUB_CODE_NM, START_DT, END_DT, USE_YN, SORT, ACTION_YN, REG_USER) VALUES
 ('Q','QPS_SRV_SCALE','5',1,'매우만족'  ,'20000101','99991231','Y',1,'Y','system'),
 ('Q','QPS_SRV_SCALE','4',1,'만족'      ,'20000101','99991231','Y',2,'Y','system'),
 ('Q','QPS_SRV_SCALE','3',1,'보통'      ,'20000101','99991231','Y',3,'Y','system'),
 ('Q','QPS_SRV_SCALE','2',1,'불만족'    ,'20000101','99991231','Y',4,'Y','system'),
 ('Q','QPS_SRV_SCALE','1',1,'매우불만족','20000101','99991231','Y',5,'Y','system')
ON DUPLICATE KEY UPDATE SUB_CODE_NM=VALUES(SUB_CODE_NM), SORT=VALUES(SORT), USE_YN='Y', ACTION_YN='Y';

-- ── 10. 설문 작성자 ─────────────────────────────────────────────────
INSERT INTO TBL_CODE_DTL (CODE_GB, CODE_CD, SUB_CODE, JOB_SEQ, SUB_CODE_NM, START_DT, END_DT, USE_YN, SORT, ACTION_YN, REG_USER) VALUES
 ('Q','QPS_SRV_WRITER','1',1,'환자본인','20000101','99991231','Y',1,'Y','system'),
 ('Q','QPS_SRV_WRITER','2',1,'보호자'  ,'20000101','99991231','Y',2,'Y','system')
ON DUPLICATE KEY UPDATE SUB_CODE_NM=VALUES(SUB_CODE_NM), SORT=VALUES(SORT), USE_YN='Y', ACTION_YN='Y';

-- ── 11. 연령대 ──────────────────────────────────────────────────────
INSERT INTO TBL_CODE_DTL (CODE_GB, CODE_CD, SUB_CODE, JOB_SEQ, SUB_CODE_NM, START_DT, END_DT, USE_YN, SORT, ACTION_YN, REG_USER) VALUES
 ('Q','QPS_SRV_AGE','1',1,'20대'    ,'20000101','99991231','Y',1,'Y','system'),
 ('Q','QPS_SRV_AGE','2',1,'30대'    ,'20000101','99991231','Y',2,'Y','system'),
 ('Q','QPS_SRV_AGE','3',1,'40대'    ,'20000101','99991231','Y',3,'Y','system'),
 ('Q','QPS_SRV_AGE','4',1,'50대'    ,'20000101','99991231','Y',4,'Y','system'),
 ('Q','QPS_SRV_AGE','5',1,'60대'    ,'20000101','99991231','Y',5,'Y','system'),
 ('Q','QPS_SRV_AGE','6',1,'70대이상','20000101','99991231','Y',6,'Y','system')
ON DUPLICATE KEY UPDATE SUB_CODE_NM=VALUES(SUB_CODE_NM), SORT=VALUES(SORT), USE_YN='Y', ACTION_YN='Y';

-- ── 12. 개선활동 유형 ───────────────────────────────────────────────
--   ★(영양) 서식은 유형이 비어 있고 자유 문구를 쓴다.
--     ⇒ 화면에서 「선택 + 직접입력」 둘 다 허용할 것. 이 코드는 선택지일 뿐 강제가 아니다.
INSERT INTO TBL_CODE_DTL (CODE_GB, CODE_CD, SUB_CODE, JOB_SEQ, SUB_CODE_NM, START_DT, END_DT, USE_YN, SORT, ACTION_YN, REG_USER) VALUES
 ('Q','QPS_IMPR_TYPE','01',1,'병원 의료 관련'  ,'20000101','99991231','Y',1,'Y','system'),
 ('Q','QPS_IMPR_TYPE','02',1,'시설 및 환경'    ,'20000101','99991231','Y',2,'Y','system'),
 ('Q','QPS_IMPR_TYPE','03',1,'간병 서비스 관련','20000101','99991231','Y',3,'Y','system')
ON DUPLICATE KEY UPDATE SUB_CODE_NM=VALUES(SUB_CODE_NM), SORT=VALUES(SORT), USE_YN='Y', ACTION_YN='Y';


-- ═══ 13. 만족도 설문 문항 기본표 ═══════════════════════════════════
--   ★문항은 코드가 아니라 「기본항목표」로 둔다(감염 위험항목표 TBL_QPS_INFRISK_DEF 와 같은 방식).
--     이유 : ①영역·정렬 속성이 붙고 ②병원이 문항을 늘리거나 뺄 수 있어야 하며
--            ③조사결과·지표분석 보고서가 이 표를 순회해서 그려지기 때문이다.
--     ⇒ 화면에 문항 20개를 하드코딩하지 말 것.
CREATE TABLE IF NOT EXISTS TBL_QPS_SRV_DEF (
  SORT     INT          NOT NULL COMMENT '전체 정렬(=문항 고유번호)',
  AREA_CD  VARCHAR(2)   NOT NULL COMMENT '조사영역 QPS_SRV_AREA',
  Q_NO     INT          NOT NULL COMMENT '영역 내 문항번호',
  Q_NM     VARCHAR(300) NOT NULL COMMENT '문항',
  USE_YN   CHAR(1) DEFAULT 'Y',
  PRIMARY KEY (SORT),
  KEY IX_QPS_SRV_DEF (AREA_CD, Q_NO)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='만족도 설문 문항 기본표';

INSERT INTO TBL_QPS_SRV_DEF (SORT, AREA_CD, Q_NO, Q_NM) VALUES
 -- 1. 전반적인 환경 시설에 대한 만족도 (5)
 ( 1,'1',1,'병실내부(TV, 냉장고, 개인사물함, 커튼 등) 편의시설이 잘 되어있다.'),
 ( 2,'1',2,'안전시설(야간비상등, 복도손잡이, 미끄럼방지, 비상벨 등)이 잘 되어있다.'),
 ( 3,'1',3,'병실의 환기 상태나 냉, 난방 상태는 양호하다.'),
 ( 4,'1',4,'환자복 및 침구를 잘 교환해준다.'),
 ( 5,'1',5,'병원의 주차시설은 이용하기 편리하다.'),
 -- 2. 직원의 친절성과 성의에 대한 만족도 (5)
 ( 6,'2',1,'담당 의사는 친절하다.'),
 ( 7,'2',2,'담당 간호사는 친절하다.'),
 ( 8,'2',3,'방사선사는 친절하다.'),
 ( 9,'2',4,'물리치료사는 친절하다.'),
 (10,'2',5,'원무과 직원은 친절하다.'),
 -- 3. 환자에 대한 관심과 서비스에 대한 만족도 (8)
 (11,'3',1,'입원 수속 시 절차가 편리하다.'),
 (12,'3',2,'입원 결정이 난 후 입원할 때까지 대기시간은 적당하다.'),
 (13,'3',3,'입원생활안내 및 낙상예방활동에 대한 설명을 들었다.'),
 (14,'3',4,'의료진은 치료의 필요성과 그 결과, 주의 사항에 대해 설명한다.'),
 (15,'3',5,'담당 의사는 귀하의 궁금증이나 질문에 성의있게 응답한다.'),
 (16,'3',6,'투약에 대한 설명이 충분하다.'),
 (17,'3',7,'식사의 맛, 양, 질, 제공시간에 전반적으로 만족한다.'),
 (18,'3',8,'간병서비스에 전반적으로 만족한다.'),
 -- 4. 병원 의료에 대한 전반적인 만족도 (2)
 (19,'4',1,'병원에서 제공받은 서비스 전반에 대해 만족하는 편이다.'),
 (20,'4',2,'우리병원을 지인에게 권유할 의향이 있다.')
ON DUPLICATE KEY UPDATE AREA_CD=VALUES(AREA_CD), Q_NO=VALUES(Q_NO), Q_NM=VALUES(Q_NM), USE_YN='Y';


-- ═══ 검증 ═════════════════════════════════════════════════════════
-- SELECT CODE_CD, COUNT(*) FROM TBL_CODE_DTL
--  WHERE CODE_CD LIKE 'QPS_CMPL%' OR CODE_CD LIKE 'QPS_SRV%' OR CODE_CD='QPS_IMPR_TYPE'
--  GROUP BY CODE_CD ORDER BY CODE_CD;
--   기대 : CMPL_NOREPLY 3, CMPL_PERSON 4, CMPL_RECV 4, CMPL_REPLY 5,
--          CMPL_TERM 3, CMPL_TYPE 7, IMPR_TYPE 3, SRV_AGE 6, SRV_AREA 4,
--          SRV_SCALE 5, SRV_WRITER 2
-- SELECT AREA_CD, COUNT(*) FROM TBL_QPS_SRV_DEF GROUP BY AREA_CD;
--   기대 : 1→5, 2→5, 3→8, 4→2  (합 20)
