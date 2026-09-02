-- ═════════════════════════════════════════════════════════════════════════
-- 델파이 원본 대조 A·B 4종 판정 반영 — 운영 DB 보정 (2026-09-02)
--   근거 : docs/proposals/QPS_시드_dfm_대조_2026-09-02.md §5 (dfm 라벨 ↔ 시드 항목 사람 판독)
--   시드 파일도 같은 내용으로 고쳤다(NUR1 · RN · FAC2). 두 번 돌려도 같은 결과.
--
--   NUR003 낙상예방 시설환경 점검표  = 원본 WARD_Chart_107 과 24항목 글자 그대로 일치 → **오타 2건만** 보정
--   RNL019 낙상 시설,환경 관리일지(인공신장) = 원본 KIDNEY_Chart_003 의 14항목과 **문장이 전부 달랐다**(지어 넣은 것)
--                                          → 항목 통째로 교체 + 사인 행 켬(원본 담당자서명 2줄)
--   ADM003 직원건강 및 안전관리 연간 활동계획 = 원본 Employee_Chart_020 과 17항목·7묶음 일치 → 손댈 것 없음
--   FAC032 방화 보안·순찰 일지  = 원본 FAC_Chart_037 은 17줄 고정 + 층마다 빈 줄. 캡처의 5줄(강당·현금입출금기·
--                                알람밸브실·탕비실·누수)은 병원이 빈 줄에 적은 **병원 자료** → 공통 서식에서 뺌
--   ⚠이미 적힌 작성분 : 지운 항목 행(FAC032 SORT 8·10·12·21·22, RNL019 전부)의 셀 값은 화면에 안 나오고 남는다(무해).
--     RNL019 는 08-14 등록 뒤 작성분이 있으면 뜻이 바뀌므로 아래 확인 SELECT 로 먼저 센다.
-- ═════════════════════════════════════════════════════════════════════════

-- 0. 작성분 확인(있으면 병원과 상의 후 진행)
SELECT d.FORM_ID, COUNT(*) AS 문서수 FROM TBL_QPS_CHK_DOC d WHERE d.FORM_ID IN ('RNL019','FAC032') GROUP BY d.FORM_ID;

-- 1. NUR003 오타 2건
UPDATE TBL_QPS_CHK_ITEM SET ITEM_NM='바닥: 턱 / 홈 파인 곳 확인'
 WHERE HOSP_CD='*' AND FORM_ID='NUR003' AND SORT=2;
UPDATE TBL_QPS_CHK_ITEM SET ITEM_NM='바퀴점검:  휠체어, 이동폴대, 이동침대, 워커'
 WHERE HOSP_CD='*' AND FORM_ID='NUR003' AND SORT=11;

-- 2. RNL019 항목 교체(원본 14항목) + 사인 행
DELETE FROM TBL_QPS_CHK_ITEM WHERE HOSP_CD='*' AND FORM_ID='RNL019';
INSERT INTO TBL_QPS_CHK_ITEM (FORM_ID,HOSP_CD,SORT,ITEM_NM,GRP_NM,DESC_TXT,INPUT_GB,CARRY_YN,USE_YN) VALUES
 ('RNL019','*', 1,'침대바퀴,잠금장치,siderail  작동 확인'            ,'시설 점검',NULL,'CHECK','N','Y'),
 ('RNL019','*', 2,'휠체어 바퀴,잠금장치 확인'                        ,'시설 점검',NULL,'CHECK','N','Y'),
 ('RNL019','*', 3,'이동침대 바퀴,잠금 확인'                          ,'시설 점검',NULL,'CHECK','N','Y'),
 ('RNL019','*', 4,'위험요소 제거'                                    ,'시설 점검',NULL,'CHECK','N','Y'),
 ('RNL019','*', 5,'호출벨 부착,작동여부 확인'                        ,'시설 점검',NULL,'CHECK','N','Y'),
 ('RNL019','*', 6,'환자경로 바닥턱 확인'                             ,'시설 점검',NULL,'CHECK','N','Y'),
 ('RNL019','*', 7,'침상 주변 정리 여부확인 (부속기구,전기코드나 환자의 부착물등)','시설 점검',NULL,'CHECK','N','Y'),
 ('RNL019','*', 8,'미끄럼 방지 테이프 부착 여부 확인'                ,'시설 점검',NULL,'CHECK','N','Y'),
 ('RNL019','*', 9,'낙상주의 표지판 부착 여부 확인'                   ,'시설 점검',NULL,'CHECK','N','Y'),
 ('RNL019','*',10,'휠체어 방향 전환 안내 표지판 부착 여부 확인'      ,'시설 점검',NULL,'CHECK','N','Y'),
 ('RNL019','*',11,'통로 불필요한 환경 위험요소 물건 제거'            ,'시설 점검',NULL,'CHECK','N','Y'),
 ('RNL019','*',12,'바닥 물기, 미끄러운용액 있는지 확인'              ,'시설 점검',NULL,'CHECK','N','Y'),
 ('RNL019','*',13,'조명밝기확인 (낮:밝게/야간:어둡지않게)'           ,'시설 점검',NULL,'CHECK','N','Y'),
 ('RNL019','*',14,'복도 및 계단 안전바 점검'                         ,'시설 점검',NULL,'CHECK','N','Y');
UPDATE TBL_QPS_CHK_FORM SET SIGNER_YN='Y' WHERE HOSP_CD='*' AND FORM_ID='RNL019';

-- 3. FAC032 병원 자료 5줄 제거(SORT 는 그대로 — 남은 줄의 번호를 안 바꿔야 작성분이 안 어긋난다)
DELETE FROM TBL_QPS_CHK_ITEM WHERE HOSP_CD='*' AND FORM_ID='FAC032' AND SORT IN (8,10,12,21,22);

-- 4. D 묶음 — 원본과 글자가 다른 항목·묶음 이름 9건 (같은 날 저녁, 대조 §5 D)
UPDATE TBL_QPS_CHK_ITEM SET GRP_NM='맛'                 WHERE HOSP_CD='*' AND FORM_ID='FAC021' AND SORT=16;          -- 「8 맛」(문항 번호 제거 규칙)
UPDATE TBL_QPS_CHK_ITEM SET ITEM_NM='바닥 물튐 청소'     WHERE HOSP_CD='*' AND FORM_ID='NUR027' AND SORT=4;           -- 「물팀」
UPDATE TBL_QPS_CHK_ITEM SET ITEM_NM='냉장 ＆ 냉동고'     WHERE HOSP_CD='*' AND FORM_ID='NUT004' AND SORT=4;           -- 전각 ＆ 보존
UPDATE TBL_QPS_CHK_ITEM SET GRP_NM='1주일'              WHERE HOSP_CD='*' AND FORM_ID='NUT004' AND GRP_NM='1주 1일';   -- 9줄
UPDATE TBL_QPS_CHK_ITEM SET ITEM_NM='이중금고'           WHERE HOSP_CD='*' AND FORM_ID='PHA023' AND SORT=1;           -- 「이중잠금」
UPDATE TBL_QPS_CHK_ITEM SET ITEM_NM='전원 결합 여부'     WHERE HOSP_CD='*' AND FORM_ID='REH001' AND SORT=1;           -- 원본 오타 보존(원본이 「결합」)
UPDATE TBL_QPS_CHK_ITEM SET ITEM_NM='정상작동 여부'      WHERE HOSP_CD='*' AND FORM_ID='ADM016' AND SORT=12;          -- 「정상동작」
UPDATE TBL_QPS_CHK_ITEM SET ITEM_NM='제품의 수평 상태'   WHERE HOSP_CD='*' AND FORM_ID='ADM016' AND SORT=26;          -- 「수령」
UPDATE TBL_QPS_CHK_ITEM SET ITEM_NM='침대 부속물 점검 (SIDE RAIL 작동여부, 바퀴잠금장치 작동여부)'
                                                        WHERE HOSP_CD='*' AND FORM_ID='RNL006' AND SORT=3;           -- 두 줄 라벨 그대로
-- 손대지 않은 것 : FAC028·PHA009 의 묶음 이름(우리 GRP_NM 이 원본의 머리글 표현과 다를 뿐 뜻이 같음) ·
--                 NUR066 「D-set」「Can」(원본 dfm 어느 변형에도 없음 — 캡처의 문서 값으로 보임, 병원 확인 뒤)

-- 5. 확인
SELECT FORM_ID, COUNT(*) AS 항목수 FROM TBL_QPS_CHK_ITEM WHERE HOSP_CD='*' AND FORM_ID IN ('NUR003','RNL019','FAC032') GROUP BY FORM_ID;
-- 기대 : NUR003 24 · RNL019 14 · FAC032 17
SELECT FORM_ID, SORT, ITEM_NM, GRP_NM FROM TBL_QPS_CHK_ITEM WHERE HOSP_CD='*'
   AND ((FORM_ID='NUR003' AND SORT IN (2,11)) OR (FORM_ID='FAC021' AND SORT=16) OR (FORM_ID='NUR027' AND SORT=4)
     OR (FORM_ID='NUT004' AND SORT IN (4,13)) OR (FORM_ID='PHA023' AND SORT=1) OR (FORM_ID='REH001' AND SORT=1)
     OR (FORM_ID='ADM016' AND SORT IN (12,26)) OR (FORM_ID='RNL006' AND SORT=3))
 ORDER BY FORM_ID, SORT;
