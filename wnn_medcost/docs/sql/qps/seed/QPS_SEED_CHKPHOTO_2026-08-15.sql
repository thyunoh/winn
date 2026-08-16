-- ═══════════════════════════════════════════════════════════════════════════
-- 점검표 사진칸으로 풀리는 서식 (2026-08-15)
--   전제 : QPS_DDL_CHK_PHOTO_2026-08-15.sql + 새 WAR(build 20260815-SRSUBS 이후)
--
--   ① RAD022 납가운 관리대장(XR07, 3쪽) — 보류를 푼다 :
--      p1 = LIST(반복행 7열) + 평가기준 정형문 → 기존 축 그대로
--      p2·p3 = 증빙사진 → **PHOTO_NMS 5칸**(사진-1·사진-2·납/갑상선/생식선 보호구)
--   ② PHA024 응급 약품 점검 기록부 — 인공신장판(RN27)의 p2 「봉인스티커 점검 사진판」을
--      **PHOTO_NMS 12칸(1~12월)** 로 흡수(RN27=PHA024 부서 공유 판정 그대로 — 서식은 한 벌)
-- 재실행 안전.
-- ═══════════════════════════════════════════════════════════════════════════

DELETE FROM TBL_QPS_CHK_ITEM WHERE HOSP_CD='*' AND FORM_ID='RAD022';
DELETE FROM TBL_QPS_CHK_FORM WHERE HOSP_CD='*' AND FORM_ID='RAD022';

INSERT INTO TBL_QPS_CHK_FORM
 (FORM_ID, HOSP_CD, FORM_NM, CATE_CD, DEPT_CD, AXIS_GB, PRD_GB, EQUIP_CNT,
  SIGNER_YN, NOTE_YN, FIX_YN, FOOT_TXT, PHOTO_NMS, SORT_NO, USE_YN, REG_USER) VALUES
 ('RAD022','*','납가운 관리대장','SAFE','RADIO','LIST','Y',15,'N','N','N',
  '차폐기구 평가 기준 (상·중·하 — 「하」는 폐기·교체, 1년 1회 이상 실시)  1) 성능검사 : 상 = 납 찢어진 부위·방사선 투과 부위 전혀 없음 · 중 = 2cm 미만 · 하 = 2cm 이상  2) 외관검사 : 상·중·하 = 어깨끈·허리벨트 터짐/끊어짐·오물 20% 기준',
  '사진-1,사진-2,납 보호구,갑상선 보호구,생식선 보호구',2160,'Y','system');

INSERT INTO TBL_QPS_CHK_ITEM (FORM_ID,HOSP_CD,SORT,ITEM_NM,GRP_NM,INPUT_GB,CARRY_YN,USE_YN) VALUES
 ('RAD022','*',1,'월·일'    ,NULL          ,'TEXT','N','Y'),
 ('RAD022','*',2,'품명'     ,NULL          ,'TEXT','N','Y'),
 ('RAD022','*',3,'단위'     ,NULL          ,'TEXT','N','Y'),
 ('RAD022','*',4,'수량'     ,NULL          ,'TEXT','N','Y'),
 ('RAD022','*',5,'성능검사' ,'차폐기구 평가','TEXT','N','Y'),
 ('RAD022','*',6,'외관검사' ,'차폐기구 평가','TEXT','N','Y'),
 ('RAD022','*',7,'비고'     ,NULL          ,'TEXT','N','Y');

-- 봉인스티커 사진판 — 약국 원본 판(PHA024)에 사진칸을 켠다(월별 12칸)
UPDATE TBL_QPS_CHK_FORM SET PHOTO_NMS='1월,2월,3월,4월,5월,6월,7월,8월,9월,10월,11월,12월'
 WHERE HOSP_CD='*' AND FORM_ID='PHA024';

-- ── 확인 ────────────────────────────────────────────────────────────────────
SELECT FORM_ID, FORM_NM, AXIS_GB, PHOTO_NMS,
       (SELECT COUNT(*) FROM TBL_QPS_CHK_ITEM i WHERE i.FORM_ID=f.FORM_ID AND i.HOSP_CD='*') items
  FROM TBL_QPS_CHK_FORM f WHERE f.HOSP_CD='*' AND FORM_ID IN ('RAD022','PHA024');
