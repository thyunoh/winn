-- ═══════════════════════════════════════════════════════════════════════════
-- 환자안전관리 점검표 3종 (SUNWOO `RD02`·`RD03`·`RD04`) — 2026-08-18
--   외래 `CLI001`(27항목) · 병동 `NUR069`(27항목) · 영양 `NUT017`(19항목) = 73항목
--
--   원본 = SUNWOO 「환자안전관리 점검표 - 외래/병동/영양」 2쪽짜리(1쪽 표지, 2쪽 본표).
--   판독 = docs/proposals/판독/QPS_서식판독_신규분_2026-08-18.md §3-2
--          ★외래 항목 문구는 판독 문서에 없어 **캡처에서 직접 읽었다**
--            (`D:\위너넷\caps\QPS_2026-08-18\RD02_p2.png`).
--
--   ★만든 절차 = 서식 관리 화면 → 일괄 붙여넣기 → 저장 → [시드 SQL 내보내기]
--     (대장 §2 「손으로 SQL 을 쓰지 않는다」. 손으로 쓰면 입력종류가 어긋나 숫자 1 이 O 로 바뀐다.)
--
--   ★★***화면에서 만든 서식은 「그 병원 것」이라 이 파일을 돌려야 공통 서식이 된다.***
--     (2026-08-18 `INF001`·`INF002` 로 실제로 겪었다 — 만든 사람 눈에만 보였다.)
--
--   구조 — 원본의 왼쪽 두 칸을 이렇게 옮겼다 :
--     · 「구분」    → `BLK_NM` (블록 띠 · 표를 가로지르는 머리 행)
--     · 「점검항목」→ `GRP_NM` (왼쪽 세로 묶음)
--     · 「점검 내용」→ `ITEM_NM`
--     · 「상 태(양호/불량)」+「조치내용(불량 시)」 → `COL_NMS='상태>양호,상태>불량,조치내용(불량 시)'`
--       (`묶음>열` 2단 머리글을 엔진이 푼다)
--     · 맨 아래 「특 이 사 항」 → `NOTE_YN='Y'` · `NOTE_NM='특 이 사 항'`
--   ⚠원본은 「구분」도 **세로 칸**이지만 엔진의 바깥 단은 **가로 띠**다 — 정보는 그대로, 모양만 다르다.
--
--   ⚠***`소화기 정 위치` 행만 `INPUT_GB='NUM'`*** — 「( )개(투척소화기포함)」 개수를 적는 칸이다.
--     `CHECK` 로 두면 ***숫자 「1」이 「O」로 바뀐다***(오류가 안 나서 티도 안 난다).
--
-- 재실행 안전(각 서식마다 DELETE 후 INSERT).
-- ═══════════════════════════════════════════════════════════════════════════

-- ── ① 외래 (CLI001) — 27항목 ───────────────────────────────────────────────
DELETE FROM TBL_QPS_CHK_ITEM WHERE FORM_ID='CLI001' AND HOSP_CD='*';
DELETE FROM TBL_QPS_CHK_FORM WHERE FORM_ID='CLI001' AND HOSP_CD='*';
INSERT INTO TBL_QPS_CHK_FORM
 (FORM_ID,HOSP_CD,FORM_NM,CATE_CD,DEPT_CD,AXIS_GB,PRD_GB,PRD_KIND,PRD_SUB,GRP_PRD,EQUIP_CNT,HALF_YN,SPLIT_N,SPLIT_DIR,GUIDE_TXT,HEAD_NMS,COL_NMS,COL_SRC,ROW_BLK_GB,ROW_BLKS,ROW_SRC,DESC_NM,PRE_COLS,POST_COLS,
  SPAN_ALL_YN,PRD_HEAD_YN,PRD_HEAD_NM,NOTE_NM,
  SIGNER_YN,NOTE_YN,FIX_YN,SIGN_LINE,FOOT_TXT,SORT_NO,USE_YN,REG_USER) VALUES
 ('CLI001','*','환자안전관리 점검표 - 외래','ENV','CLINIC','ITEM_COL','M',NULL,NULL,NULL,10,'N',NULL,NULL,NULL,NULL,'상태>양호,상태>불량,조치내용(불량 시)','F',NULL,NULL,'F',NULL,NULL,NULL,
  'N','N',NULL,'특 이 사 항',
  'Y','Y','N',NULL,NULL,0,'Y','system');
INSERT INTO TBL_QPS_CHK_ITEM (FORM_ID,HOSP_CD,SORT,ITEM_NM,GRP_NM,BLK_NM,DESC_TXT,SPAN_TXT,INPUT_GB,UNIT_NM,CARRY_YN,USE_YN) VALUES
 ('CLI001','*',1,'의료기기 기능점검 및 청결상태','영상의학실','의료기기관리',NULL,NULL,'CHECK',NULL,'N','Y'),
 ('CLI001','*',2,'의료기기 기능점검 상태','영상의학실','의료기기관리',NULL,NULL,'CHECK',NULL,'N','Y'),
 ('CLI001','*',3,'바퀴부착 및 구름 상태','IV pole','의료용구관리',NULL,NULL,'CHECK',NULL,'N','Y'),
 ('CLI001','*',4,'높이조절 손잡이 조임 상태','IV pole','의료용구관리',NULL,NULL,'CHECK',NULL,'N','Y'),
 ('CLI001','*',5,'손소독제 및 물품 유효기간 확인','물품관리','의료용구관리',NULL,NULL,'CHECK',NULL,'N','Y'),
 ('CLI001','*',6,'물품 정리 및 청결 상태','물품관리','의료용구관리',NULL,NULL,'CHECK',NULL,'N','Y'),
 ('CLI001','*',7,'전체 청소상태 (화장실 포함)','환경관리','환경 및 시설관리',NULL,NULL,'CHECK',NULL,'N','Y'),
 ('CLI001','*',8,'냉·난방 시설관리','환경관리','환경 및 시설관리',NULL,NULL,'CHECK',NULL,'N','Y'),
 ('CLI001','*',9,'복도 주위 안전 상태(보행장애 물건 확인)','환경관리','환경 및 시설관리',NULL,NULL,'CHECK',NULL,'N','Y'),
 ('CLI001','*',10,'응급 call bell 작동상태','시설관리','환경 및 시설관리',NULL,NULL,'CHECK',NULL,'N','Y'),
 ('CLI001','*',11,'전등 상태','시설관리','환경 및 시설관리',NULL,NULL,'CHECK',NULL,'N','Y'),
 ('CLI001','*',12,'벽체, 천정, 바닥 파손여부 및 상태','시설관리','환경 및 시설관리',NULL,NULL,'CHECK',NULL,'N','Y'),
 ('CLI001','*',13,'콘센트 등 전기 안전 상태','시설관리','환경 및 시설관리',NULL,NULL,'CHECK',NULL,'N','Y'),
 ('CLI001','*',14,'정수기 관리 상태','시설관리','환경 및 시설관리',NULL,NULL,'CHECK',NULL,'N','Y'),
 ('CLI001','*',15,'소화기 정 위치','외래전체','각실관리',NULL,NULL,'NUM','개(투척소화기포함)','N','Y'),
 ('CLI001','*',16,'약 조제기(ATDPS) 청결 관리','약국','각실관리',NULL,NULL,'CHECK',NULL,'N','Y'),
 ('CLI001','*',17,'주사실 청결 상태','주사실','각실관리',NULL,NULL,'CHECK',NULL,'N','Y'),
 ('CLI001','*',18,'낙상주의 표지판 부착','주사실','각실관리',NULL,NULL,'CHECK',NULL,'N','Y'),
 ('CLI001','*',19,'의료폐기물 뚜껑여부 및 이행 실태','주사실','각실관리',NULL,NULL,'CHECK',NULL,'N','Y'),
 ('CLI001','*',20,'영상의학실 청결상태','영상의학실','각실관리',NULL,NULL,'CHECK',NULL,'N','Y'),
 ('CLI001','*',21,'낙상예방지침서 및 환자안전수칙 부착','영상의학실','각실관리',NULL,NULL,'CHECK',NULL,'N','Y'),
 ('CLI001','*',22,'소독기 관리 상태 및 점검일지확인','소독실','각실관리',NULL,NULL,'CHECK',NULL,'N','Y'),
 ('CLI001','*',23,'점검 기록 일지 관리 상태','구급차','각실관리',NULL,NULL,'CHECK',NULL,'N','Y'),
 ('CLI001','*',24,'환자운반카(S-car) 작동 상태','구급차','각실관리',NULL,NULL,'CHECK',NULL,'N','Y'),
 ('CLI001','*',25,'응급kit 관리','구급차','각실관리',NULL,NULL,'CHECK',NULL,'N','Y'),
 ('CLI001','*',26,'자동제세동기 (AED) 작동 상태','구급차','각실관리',NULL,NULL,'CHECK',NULL,'N','Y'),
 ('CLI001','*',27,'자동제세동기 (AED) 배터리 잔량 확인','구급차','각실관리',NULL,NULL,'CHECK',NULL,'N','Y');

-- ── ② 병동 (NUR069) — 27항목 ───────────────────────────────────────────────
DELETE FROM TBL_QPS_CHK_ITEM WHERE FORM_ID='NUR069' AND HOSP_CD='*';
DELETE FROM TBL_QPS_CHK_FORM WHERE FORM_ID='NUR069' AND HOSP_CD='*';
INSERT INTO TBL_QPS_CHK_FORM
 (FORM_ID,HOSP_CD,FORM_NM,CATE_CD,DEPT_CD,AXIS_GB,PRD_GB,PRD_KIND,PRD_SUB,GRP_PRD,EQUIP_CNT,HALF_YN,SPLIT_N,SPLIT_DIR,GUIDE_TXT,HEAD_NMS,COL_NMS,COL_SRC,ROW_BLK_GB,ROW_BLKS,ROW_SRC,DESC_NM,PRE_COLS,POST_COLS,
  SPAN_ALL_YN,PRD_HEAD_YN,PRD_HEAD_NM,NOTE_NM,
  SIGNER_YN,NOTE_YN,FIX_YN,SIGN_LINE,FOOT_TXT,SORT_NO,USE_YN,REG_USER) VALUES
 ('NUR069','*','환자안전관리 점검표 - 병동','ENV','NURSE','ITEM_COL','M',NULL,NULL,NULL,10,'N',NULL,NULL,NULL,NULL,'상태>양호,상태>불량,조치내용(불량 시)','F',NULL,NULL,'F',NULL,NULL,NULL,
  'N','N',NULL,'특 이 사 항',
  'Y','Y','N',NULL,NULL,0,'Y','system');
INSERT INTO TBL_QPS_CHK_ITEM (FORM_ID,HOSP_CD,SORT,ITEM_NM,GRP_NM,BLK_NM,DESC_TXT,SPAN_TXT,INPUT_GB,UNIT_NM,CARRY_YN,USE_YN) VALUES
 ('NUR069','*',1,'작동 및 잠금 상태 이상','산소기(O2 tank)','의료기기관리',NULL,NULL,'CHECK',NULL,'N','Y'),
 ('NUR069','*',2,'O2 gas 충전 여부','산소기(O2 tank)','의료기기관리',NULL,NULL,'CHECK',NULL,'N','Y'),
 ('NUR069','*',3,'압력 유지 및 작동상태','흡입기(suction기)','의료기기관리',NULL,NULL,'CHECK',NULL,'N','Y'),
 ('NUR069','*',4,'EKG Monitor 작동상태','환자감시장치(EKG Monitor)','의료기기관리',NULL,NULL,'CHECK',NULL,'N','Y'),
 ('NUR069','*',5,'바퀴작동 상태 및 구름상태','휠체어IV pole','의료용구관리',NULL,NULL,'CHECK',NULL,'N','Y'),
 ('NUR069','*',6,'BST 환자 확인 작동 및 배터리 상태','BST 기계','의료용구관리',NULL,NULL,'CHECK',NULL,'N','Y'),
 ('NUR069','*',7,'응급약품 및 소독물품 유효기간확인','물품관리','응급kit',NULL,NULL,'CHECK',NULL,'N','Y'),
 ('NUR069','*',8,'intubation-set상태(I-gel,ambubag)','물품관리','응급kit',NULL,NULL,'CHECK',NULL,'N','Y'),
 ('NUR069','*',9,'자동제세동기 (AED) 작동 상태','물품관리','응급kit',NULL,NULL,'CHECK',NULL,'N','Y'),
 ('NUR069','*',10,'자동제세동기 (AED) 배터리 잔량 확인','물품관리','응급kit',NULL,NULL,'CHECK',NULL,'N','Y'),
 ('NUR069','*',11,'상두대 주위 안전 상태(가습기, 화분, 칼, 가위 등 제거)','병 실','병실관리',NULL,NULL,'CHECK',NULL,'N','Y'),
 ('NUR069','*',12,'침상 난간 상태','병 실','병실관리',NULL,NULL,'CHECK',NULL,'N','Y'),
 ('NUR069','*',13,'창문 고시 상태','병 실','병실관리',NULL,NULL,'CHECK',NULL,'N','Y'),
 ('NUR069','*',14,'call bell 작동상태','병 실','병실관리',NULL,NULL,'CHECK',NULL,'N','Y'),
 ('NUR069','*',15,'낙상주의 표지판 부착','병 실','병실관리',NULL,NULL,'CHECK',NULL,'N','Y'),
 ('NUR069','*',16,'화장실 옆 문 개폐장치 상태','화장실','병실관리',NULL,NULL,'CHECK',NULL,'N','Y'),
 ('NUR069','*',17,'문 자동 개폐장치 상태','병실 전체 및 복도, 계단','시설관리',NULL,NULL,'CHECK',NULL,'N','Y'),
 ('NUR069','*',18,'벽체, 천정, 바닥 파손여부 및 상태','병실 전체 및 복도, 계단','시설관리',NULL,NULL,'CHECK',NULL,'N','Y'),
 ('NUR069','*',19,'전등 상태','병실 전체 및 복도, 계단','시설관리',NULL,NULL,'CHECK',NULL,'N','Y'),
 ('NUR069','*',20,'정수기 관리 상태','병실 전체 및 복도, 계단','시설관리',NULL,NULL,'CHECK',NULL,'N','Y'),
 ('NUR069','*',21,'콘센트 등 전기 안전 상태','병실 전체 및 복도, 계단','시설관리',NULL,NULL,'CHECK',NULL,'N','Y'),
 ('NUR069','*',22,'소화기 정 위치','병실 전체 및 복도, 계단','시설관리',NULL,NULL,'NUM','개(투척소화기포함)','N','Y'),
 ('NUR069','*',23,'의료폐기물 뚜껑 여부 및 이행 실태','폐기물 및 세탁관리','기타관리',NULL,NULL,'CHECK',NULL,'N','Y'),
 ('NUR069','*',24,'일반쓰레기 분리수거 이행 실태','폐기물 및 세탁관리','기타관리',NULL,NULL,'CHECK',NULL,'N','Y'),
 ('NUR069','*',25,'오물처리 상태','폐기물 및 세탁관리','기타관리',NULL,NULL,'CHECK',NULL,'N','Y'),
 ('NUR069','*',26,'오염과 기타세탁물 분리상태','폐기물 및 세탁관리','기타관리',NULL,NULL,'CHECK',NULL,'N','Y'),
 ('NUR069','*',27,'미끄럼방지 매트 부착 상태','샤워실','기타관리',NULL,NULL,'CHECK',NULL,'N','Y');

-- ── ③ 영양 (NUT017) — 19항목 ───────────────────────────────────────────────
DELETE FROM TBL_QPS_CHK_ITEM WHERE FORM_ID='NUT017' AND HOSP_CD='*';
DELETE FROM TBL_QPS_CHK_FORM WHERE FORM_ID='NUT017' AND HOSP_CD='*';
INSERT INTO TBL_QPS_CHK_FORM
 (FORM_ID,HOSP_CD,FORM_NM,CATE_CD,DEPT_CD,AXIS_GB,PRD_GB,PRD_KIND,PRD_SUB,GRP_PRD,EQUIP_CNT,HALF_YN,SPLIT_N,SPLIT_DIR,GUIDE_TXT,HEAD_NMS,COL_NMS,COL_SRC,ROW_BLK_GB,ROW_BLKS,ROW_SRC,DESC_NM,PRE_COLS,POST_COLS,
  SPAN_ALL_YN,PRD_HEAD_YN,PRD_HEAD_NM,NOTE_NM,
  SIGNER_YN,NOTE_YN,FIX_YN,SIGN_LINE,FOOT_TXT,SORT_NO,USE_YN,REG_USER) VALUES
 ('NUT017','*','환자안전관리 점검표 - 영양','ENV','NUTRI','ITEM_COL','M',NULL,NULL,NULL,10,'N',NULL,NULL,NULL,NULL,'상태>양호,상태>불량,조치내용(불량 시)','F',NULL,NULL,'F',NULL,NULL,NULL,
  'N','N',NULL,'특 이 사 항',
  'Y','Y','N',NULL,NULL,0,'Y','system');
INSERT INTO TBL_QPS_CHK_ITEM (FORM_ID,HOSP_CD,SORT,ITEM_NM,GRP_NM,BLK_NM,DESC_TXT,SPAN_TXT,INPUT_GB,UNIT_NM,CARRY_YN,USE_YN) VALUES
 ('NUT017','*',1,'식재료 보관 창고 청결 상태','식재료','보관 및 관리',NULL,NULL,'CHECK',NULL,'N','Y'),
 ('NUT017','*',2,'식재료보관창고 온습도관리상태(온도15~25℃ 습도 50~60%)','식재료','보관 및 관리',NULL,NULL,'CHECK',NULL,'N','Y'),
 ('NUT017','*',3,'냉장고 청결 및 보관 상태','냉장고','보관 및 관리',NULL,NULL,'CHECK',NULL,'N','Y'),
 ('NUT017','*',4,'냉장고 온도 관리 상태 (냉장 0~5℃, 냉동 –18℃이하)','냉장고','보관 및 관리',NULL,NULL,'CHECK',NULL,'N','Y'),
 ('NUT017','*',5,'보존식 보관 상태 (냉동 –18℃이하, 144hr보관)','보존식','보관 및 관리',NULL,NULL,'CHECK',NULL,'N','Y'),
 ('NUT017','*',6,'전체 청소 상태','환경관리','환경 및 시설관리',NULL,NULL,'CHECK',NULL,'N','Y'),
 ('NUT017','*',7,'냉·난방 시설관리','환경관리','환경 및 시설관리',NULL,NULL,'CHECK',NULL,'N','Y'),
 ('NUT017','*',8,'화장실 청결 상태','환경관리','환경 및 시설관리',NULL,NULL,'CHECK',NULL,'N','Y'),
 ('NUT017','*',9,'전등 상태','시설관리','환경 및 시설관리',NULL,NULL,'CHECK',NULL,'N','Y'),
 ('NUT017','*',10,'벽체, 천정, 바닥 파손여부 및 상태','시설관리','환경 및 시설관리',NULL,NULL,'CHECK',NULL,'N','Y'),
 ('NUT017','*',11,'콘센트 등 전기 안전 상태','시설관리','환경 및 시설관리',NULL,NULL,'CHECK',NULL,'N','Y'),
 ('NUT017','*',12,'정수기 관리 상태','시설관리','환경 및 시설관리',NULL,NULL,'CHECK',NULL,'N','Y'),
 ('NUT017','*',13,'배식차 청결 및 관리 상태','영양과','각실',NULL,NULL,'CHECK',NULL,'N','Y'),
 ('NUT017','*',14,'조리장 환경 구획 구분','영양과','각실',NULL,NULL,'CHECK',NULL,'N','Y'),
 ('NUT017','*',15,'식기보관 및 청결상태','영양과','각실',NULL,NULL,'CHECK',NULL,'N','Y'),
 ('NUT017','*',16,'음식물 쓰레기 관리','영양과','각실',NULL,NULL,'CHECK',NULL,'N','Y'),
 ('NUT017','*',17,'손위생 및 개인위생 복장 관리','영양과','각실',NULL,NULL,'CHECK',NULL,'N','Y'),
 ('NUT017','*',18,'소화기 정 위치 및 주변적재 금지','영양과','각실',NULL,NULL,'NUM','개(투척소화기포함)','N','Y'),
 ('NUT017','*',19,'일반쓰레기 분리수거 이행 실태','영양과','각실',NULL,NULL,'CHECK',NULL,'N','Y');

-- ── 확인 ────────────────────────────────────────────────────────────────────
SELECT f.FORM_ID AS 서식, f.FORM_NM AS 이름, f.DEPT_CD AS 부서, f.CATE_CD AS 분류,
       (SELECT COUNT(*) FROM TBL_QPS_CHK_ITEM i
         WHERE i.FORM_ID=f.FORM_ID AND i.HOSP_CD='*' AND i.USE_YN='Y') AS 항목수
  FROM TBL_QPS_CHK_FORM f
 WHERE f.FORM_ID IN ('CLI001','NUR069','NUT017') AND f.HOSP_CD='*';
-- 기대값 : CLI001 27 · NUR069 27 · NUT017 19

-- ★NUM 으로 둔 소화기 행이 셋 다 있는가(하나라도 CHECK 면 숫자가 O 로 바뀐다)
SELECT FORM_ID, ITEM_NM, INPUT_GB, UNIT_NM
  FROM TBL_QPS_CHK_ITEM
 WHERE HOSP_CD='*' AND FORM_ID IN ('CLI001','NUR069','NUT017') AND INPUT_GB='NUM';
-- 기대값 : 3행
