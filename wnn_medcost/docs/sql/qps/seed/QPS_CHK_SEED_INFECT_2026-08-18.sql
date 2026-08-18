-- ═══════════════════════════════════════════════════════════════════════════
-- 점검표 서식 시드 — 감염(요로감염) 2026-08-18
--   ① INF001 유치도뇨관 유지상태 체크리스트   (11문항)
--   ② INF002 유치도뇨관 삽입 체크리스트       (6문항)
--
--   근거 : 캡처 D:\위너넷\caps\QPS_2026-08-18\UT07.png · UT06.png
--          판독 QPS_서식판독_신규분_2026-08-18.md §2-3 · §2-4
--
--   ★대장 §2 절차대로 ***손으로 쓰지 않고*** 서식 관리 화면에서 만들어
--     [시드 SQL 내보내기]로 뽑았다. 가짜 병원(99999998)에서 만들고 `'*'`(공통)으로 넣는다.
--   ★입력종류는 전부 CHECK(O/X) — 열이 「예 / 아니오 / 미관찰」 **3택**이라 이것이 맞다.
--     ⚠글자·숫자 칸을 CHECK 로 두면 서버가 한 글자를 O/X 로 바꾼다(대장 §2 경고). 여기선 해당 없음.
--   ★상단 자유칸(HEAD_NMS) = 병원·환자이름·등록번호·관찰장소·관찰자·관찰일시 — 원본 머리표 그대로.
--     ⚠원본의 관찰장소(집중치료실/병동)·관찰자(감염관리간호사/기타) **체크 선택지는 담기지 않는다** —
--       자유칸이라 글자로 적는다. 선택지를 살리려면 엔진 변경이 필요하다.
--
--   ⚠내보내기가 넣은 `EQUIP_CNT=10` 은 기기축(EQUIP_DAY)용 기본값이다.
--     ITEM_COL 에서는 쓰이지 않으므로 내보낸 그대로 두었다.
--   ⚠내보내기 머리글의 「— undefined」 는 **내보내기 기능의 표시 버그**다(부서명이 안 찍힌다).
--     시드 내용에는 영향이 없다 — DEPT_CD='INFECT' 로 제대로 들어간다.
-- ═══════════════════════════════════════════════════════════════════════════

DELETE FROM TBL_QPS_CHK_ITEM WHERE FORM_ID='INF001' AND HOSP_CD='*';
DELETE FROM TBL_QPS_CHK_FORM WHERE FORM_ID='INF001' AND HOSP_CD='*';
INSERT INTO TBL_QPS_CHK_FORM
 (FORM_ID,HOSP_CD,FORM_NM,CATE_CD,DEPT_CD,AXIS_GB,PRD_GB,PRD_KIND,PRD_SUB,GRP_PRD,EQUIP_CNT,HALF_YN,SPLIT_N,SPLIT_DIR,GUIDE_TXT,HEAD_NMS,COL_NMS,COL_SRC,ROW_BLK_GB,ROW_BLKS,ROW_SRC,DESC_NM,PRE_COLS,POST_COLS,
  SPAN_ALL_YN,PRD_HEAD_YN,PRD_HEAD_NM,NOTE_NM,
  SIGNER_YN,NOTE_YN,FIX_YN,SIGN_LINE,FOOT_TXT,SORT_NO,USE_YN,REG_USER) VALUES
 ('INF001','*','유치도뇨관 유지상태 체크리스트','SAFE','INFECT','ITEM_COL','M',NULL,NULL,NULL,10,'N',NULL,NULL,'*유치도뇨관 유지관리 점검사항 (항목별 예, 아니오, 미관찰 선택)','병원,환자이름,등록번호,관찰장소,관찰자,관찰일시','예,아니오,미관찰','F',NULL,NULL,'F',NULL,NULL,NULL,
  'N','N',NULL,NULL,
  'Y','Y','N',NULL,'* 입력확정여부 :  □ 최종   □ 임시',0,'Y','system');
INSERT INTO TBL_QPS_CHK_ITEM (FORM_ID,HOSP_CD,SORT,ITEM_NM,GRP_NM,BLK_NM,DESC_TXT,SPAN_TXT,INPUT_GB,UNIT_NM,CARRY_YN,USE_YN) VALUES
 ('INF001','*',1,'유치도뇨관 접촉 전 손위생을 준수 하였습니까 ?',NULL,NULL,NULL,NULL,'CHECK',NULL,'N','Y'),
 ('INF001','*',2,'유치도뇨관 접촉 후 손위생을 준수 하였습니까 ?',NULL,NULL,NULL,NULL,'CHECK',NULL,'N','Y'),
 ('INF001','*',3,'유치도뇨관은 움직이지 않게 고정되어 있습니까 ?',NULL,NULL,NULL,NULL,'CHECK',NULL,'N','Y'),
 ('INF001','*',4,'폐쇄적인 배액체계가 유지되어 있습니까 ?',NULL,NULL,NULL,NULL,'CHECK',NULL,'N','Y'),
 ('INF001','*',5,'유치도뇨관이 꼬임없이 유지되어 있습니까 ?',NULL,NULL,NULL,NULL,'CHECK',NULL,'N','Y'),
 ('INF001','*',6,'소변백은 방광보다 아래에 유지되어 있습니까 ?',NULL,NULL,NULL,NULL,'CHECK',NULL,'N','Y'),
 ('INF001','*',7,'소변백은 바닥에 닿지 않았습니까 ?',NULL,NULL,NULL,NULL,'CHECK',NULL,'N','Y'),
 ('INF001','*',8,'검체 채취시 채취 부위(port)를 소독 후 멸균주사기로 흡인하였습니까 ?',NULL,NULL,NULL,NULL,'CHECK',NULL,'N','Y'),
 ('INF001','*',9,'소변백을 비운 후 배액 tip 소독을 하였습니까 ?',NULL,NULL,NULL,NULL,'CHECK',NULL,'N','Y'),
 ('INF001','*',10,'소변백의 배액 tip을 제 위치 시켰습니까 ?',NULL,NULL,NULL,NULL,'CHECK',NULL,'N','Y'),
 ('INF001','*',11,'환자별 수집용기를 사용하였습니까 ?',NULL,NULL,NULL,NULL,'CHECK',NULL,'N','Y');

-- ═══ ② INF002 유치도뇨관 삽입 체크리스트 ═══════════════════════════════════
--   ⚠상단 자유칸을 **8칸 꽉 채웠다**(엔진 최대). 마지막 「삽입기준」은 원본에서
--     6개 선택지(중증환자 소변량 측정 / 부동자세 장기간 / 요실금+개방창상 /
--     유치도뇨관 시술이 필요한 수술 / 급성 요정체·방광 출구 폐쇄 / 기타)를 **하나 이상 고르는 칸**이다.
--     ***선택지는 담기지 않는다*** — 자유칸이라 글자로 적는다. 살리려면 엔진 변경이 필요하다.
DELETE FROM TBL_QPS_CHK_ITEM WHERE FORM_ID='INF002' AND HOSP_CD='*';
DELETE FROM TBL_QPS_CHK_FORM WHERE FORM_ID='INF002' AND HOSP_CD='*';
INSERT INTO TBL_QPS_CHK_FORM
 (FORM_ID,HOSP_CD,FORM_NM,CATE_CD,DEPT_CD,AXIS_GB,PRD_GB,PRD_KIND,PRD_SUB,GRP_PRD,EQUIP_CNT,HALF_YN,SPLIT_N,SPLIT_DIR,GUIDE_TXT,HEAD_NMS,COL_NMS,COL_SRC,ROW_BLK_GB,ROW_BLKS,ROW_SRC,DESC_NM,PRE_COLS,POST_COLS,
  SPAN_ALL_YN,PRD_HEAD_YN,PRD_HEAD_NM,NOTE_NM,
  SIGNER_YN,NOTE_YN,FIX_YN,SIGN_LINE,FOOT_TXT,SORT_NO,USE_YN,REG_USER) VALUES
 ('INF002','*','유치도뇨관 삽입 체크리스트','SAFE','INFECT','ITEM_COL','M',NULL,NULL,NULL,10,'N',NULL,NULL,'*유치도뇨관 삽입 시술 중 점검사항 (항목별 예, 아니오, 미관찰 선택)','병원,환자이름,등록번호,시술자,관찰자,삽입일시,삽입장소,삽입기준','예,아니오,미관찰','F',NULL,NULL,'F',NULL,NULL,NULL,
  'N','N',NULL,NULL,
  'Y','Y','N',NULL,'* 입력확정여부 :  □ 최종   □ 임시',0,'Y','system');
INSERT INTO TBL_QPS_CHK_ITEM (FORM_ID,HOSP_CD,SORT,ITEM_NM,GRP_NM,BLK_NM,DESC_TXT,SPAN_TXT,INPUT_GB,UNIT_NM,CARRY_YN,USE_YN) VALUES
 ('INF002','*',1,'손위생을 준수 하였습니까 ?',NULL,NULL,NULL,NULL,'CHECK',NULL,'N','Y'),
 ('INF002','*',2,'유치도뇨관 삽입 시 멸균장갑을 착용하였습니까 ?',NULL,NULL,NULL,NULL,'CHECK',NULL,'N','Y'),
 ('INF002','*',3,'멸균세트, 멸균포를 사용하였습니까 ?',NULL,NULL,NULL,NULL,'CHECK',NULL,'N','Y'),
 ('INF002','*',4,'윤활제를 사용하였습니까 ?',NULL,NULL,NULL,NULL,'CHECK',NULL,'N','Y'),
 ('INF002','*',5,'삽입 후 유치도뇨관을 고정하였습니까 ?',NULL,NULL,NULL,NULL,'CHECK',NULL,'N','Y'),
 ('INF002','*',6,'삽입 전 소독제(또는 멸균생리식염수)로 소독하였습니까 ?',NULL,NULL,NULL,NULL,'CHECK',NULL,'N','Y');

-- ── 확인 ────────────────────────────────────────────────────────────────────
SELECT FORM_ID, FORM_NM, DEPT_CD, AXIS_GB, COL_NMS FROM TBL_QPS_CHK_FORM
 WHERE FORM_ID IN ('INF001','INF002') AND HOSP_CD='*' ORDER BY FORM_ID;
SELECT FORM_ID, COUNT(*) AS 항목수 FROM TBL_QPS_CHK_ITEM
 WHERE FORM_ID IN ('INF001','INF002') AND HOSP_CD='*' GROUP BY FORM_ID;
