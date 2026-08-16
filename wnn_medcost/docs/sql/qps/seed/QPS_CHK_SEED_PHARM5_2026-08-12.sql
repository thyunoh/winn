-- ═══════════════════════════════════════════════════════════════════════════
-- 점검표 표준 서식 시드 — 약국 **5차** : 병동 비치 약물 목록 (8탭) 2026-08-12
--   원본 캡처 : SUNWOO HCMS ▸ 약국 ▸ 약국서식 ▸ 병동 비치 약물 목록
--
-- ★★***탭 여덟이 서식 여덟이다.***
--   `확인` 탭 하나는 **모양이 아주 다르고**(체크 목록), 나머지 일곱은 약물 갈래별 **같은 표**다.
--   원본에서 탭을 바꾸면 약품 목록이 통째로 바뀐다 — 한 서식에 담으면 섞인다.
--
-- ⚠**정직하게 적어 둔다 — 본 것은 두 탭뿐이다.**
--   캡처에 열려 있던 것은 `확인` 과 `응급약물` 두 탭이다.
--   나머지 여섯(고위험고주의 · 향정신성 · 일반 1~4)은 ***열이 같다고 보았다.***
--   같은 화면의 갈래 탭이라 그럴 가능성이 높지만 ***본 것은 아니다.***
--   ⇒ 다르면 **그 탭 서식만** 고치면 된다(서식이 갈려 있으니 다른 탭에 영향이 없다).
--   ***같은 판단을 PHA016~019(의약품 관리대장 PO만 봄)·PHA025~028(월별비치 주사제만 봄)에도 했다.***
-- ═══════════════════════════════════════════════════════════════════════════

-- ═══════════════════════════════════════════════════════════════════════════
-- PHA029 · 병동 비치 약물 목록 - 확인                      [ITEM_COL · 월]
-- ═══════════════════════════════════════════════════════════════════════════
--   ★일곱 갈래에 체크 하나씩. 다른 일곱 탭의 **표지 역할**이다.
--   ★상단 「병동」은 우리 화면에 이미 있다(WARD_NM).

DELETE FROM TBL_QPS_CHK_ITEM WHERE FORM_ID='PHA029' AND HOSP_CD='*';
DELETE FROM TBL_QPS_CHK_FORM WHERE FORM_ID='PHA029' AND HOSP_CD='*';

INSERT INTO TBL_QPS_CHK_FORM
 (FORM_ID, HOSP_CD, FORM_NM, CATE_CD, DEPT_CD, AXIS_GB, PRD_GB, EQUIP_CNT,
  COL_NMS, COL_SRC, GUIDE_TXT, HEAD_NMS, SIGNER_YN, NOTE_YN, FIX_YN, SIGN_LINE, FOOT_TXT,
  SORT_NO, USE_YN, REG_USER)
VALUES
 ('PHA029','*','병동 비치 약물 목록 - 확인','DRUG','PHARM','ITEM_COL','M',10,
  '확인','F',NULL,NULL,'N','N','N',NULL,NULL,220,'Y','system');

INSERT INTO TBL_QPS_CHK_ITEM (FORM_ID, HOSP_CD, SORT, ITEM_NM, GRP_NM, INPUT_GB, UNIT_NM, USE_YN) VALUES
 ('PHA029','*',1,'응급약물'         ,NULL,'CHECK',NULL,'Y'),
 ('PHA029','*',2,'고위험 고주의 약물',NULL,'CHECK',NULL,'Y'),
 ('PHA029','*',3,'향정신성의약품'    ,NULL,'CHECK',NULL,'Y'),
 ('PHA029','*',4,'일반의약품 1'      ,NULL,'CHECK',NULL,'Y'),
 ('PHA029','*',5,'일반의약품 2'      ,NULL,'CHECK',NULL,'Y'),
 ('PHA029','*',6,'일반의약품 3'      ,NULL,'CHECK',NULL,'Y'),
 ('PHA029','*',7,'일반의약품 4'      ,NULL,'CHECK',NULL,'Y');

-- ═══════════════════════════════════════════════════════════════════════════
-- PHA030~036 · 병동 비치 약물 목록 — 약물 갈래 7탭            [LIST · 월]
-- ═══════════════════════════════════════════════════════════════════════════
--   ★열은 `응급약물` 탭에서 본 그대로다 :
--     번호 · 약품명 · 제형 · 보유수량 · 유효기간 · 개봉일자 ·
--     보관방법(냉장/차광/습기주의) · 라벨링 · 필요시 경고문 · 물량 및 파손여부
--     (번호는 우리 대장의 「번호」 칸이므로 항목으로 넣지 않는다)
--   ★하단 「확인인자(년/월/일)」 + 「점검자」 ⇒ 점검자 사인 줄로 담는다.
--   ★「보관방법」 머리글의 괄호 설명을 **그대로 붙여 둔다** — 빼면 무엇을 적는 칸인지 흐려진다.

DELETE FROM TBL_QPS_CHK_ITEM WHERE FORM_ID IN ('PHA030','PHA031','PHA032','PHA033','PHA034','PHA035','PHA036') AND HOSP_CD='*';
DELETE FROM TBL_QPS_CHK_FORM WHERE FORM_ID IN ('PHA030','PHA031','PHA032','PHA033','PHA034','PHA035','PHA036') AND HOSP_CD='*';

INSERT INTO TBL_QPS_CHK_FORM
 (FORM_ID, HOSP_CD, FORM_NM, CATE_CD, DEPT_CD, AXIS_GB, PRD_GB, EQUIP_CNT,
  GUIDE_TXT, HEAD_NMS, SIGNER_YN, NOTE_YN, FIX_YN, SIGN_LINE, FOOT_TXT, SORT_NO, USE_YN, REG_USER)
VALUES
 ('PHA030','*','병동 비치 약물 목록 - 응급약물'                ,'DRUG','PHARM','LIST','M',25,NULL,NULL,'Y','N','N',NULL,NULL,221,'Y','system'),
 ('PHA031','*','병동 비치 약물 목록 - 고위험고주의약물'         ,'DRUG','PHARM','LIST','M',25,NULL,NULL,'Y','N','N',NULL,NULL,222,'Y','system'),
 ('PHA032','*','병동 비치 약물 목록 - 향정신성의약품'           ,'DRUG','PHARM','LIST','M',25,NULL,NULL,'Y','N','N',NULL,NULL,223,'Y','system'),
 ('PHA033','*','병동 비치 약물 목록 - 일반의약품 1 PRN(경구)'    ,'DRUG','PHARM','LIST','M',25,NULL,NULL,'Y','N','N',NULL,NULL,224,'Y','system'),
 ('PHA034','*','병동 비치 약물 목록 - 일반의약품 2 구두처방(경구)','DRUG','PHARM','LIST','M',25,NULL,NULL,'Y','N','N',NULL,NULL,225,'Y','system'),
 ('PHA035','*','병동 비치 약물 목록 - 일반의약품 3 구두처방(주사제)','DRUG','PHARM','LIST','M',25,NULL,NULL,'Y','N','N',NULL,NULL,226,'Y','system'),
 ('PHA036','*','병동 비치 약물 목록 - 일반의약품 4 구두처방(외용약)','DRUG','PHARM','LIST','M',25,NULL,NULL,'Y','N','N',NULL,NULL,227,'Y','system');

INSERT INTO TBL_QPS_CHK_ITEM (FORM_ID, HOSP_CD, SORT, ITEM_NM, GRP_NM, INPUT_GB, UNIT_NM, USE_YN)
SELECT f.FORM_ID, '*', x.SORT, x.ITEM_NM, NULL, x.INPUT_GB, NULL, 'Y'
  FROM (SELECT 'PHA030' AS FORM_ID UNION ALL SELECT 'PHA031' UNION ALL SELECT 'PHA032'
        UNION ALL SELECT 'PHA033' UNION ALL SELECT 'PHA034' UNION ALL SELECT 'PHA035'
        UNION ALL SELECT 'PHA036') f
  JOIN (SELECT 1 AS SORT,'약품명' AS ITEM_NM,'TEXT' AS INPUT_GB
        UNION ALL SELECT 2,'제형'                  ,'TEXT'
        UNION ALL SELECT 3,'보유수량'              ,'TEXT'
        UNION ALL SELECT 4,'유효기간'              ,'TEXT'
        UNION ALL SELECT 5,'개봉일자'              ,'TEXT'
        UNION ALL SELECT 6,'보관방법 (냉장/차광/습기주의)','TEXT'
        UNION ALL SELECT 7,'라벨링'                ,'CHECK'
        UNION ALL SELECT 8,'필요시 경고문'          ,'TEXT'
        UNION ALL SELECT 9,'물량 및 파손여부'       ,'TEXT') x;

-- ── 확인 ────────────────────────────────────────────────────────────────────
SELECT f.FORM_ID, f.FORM_NM, f.AXIS_GB, COUNT(i.SORT) AS 항목수
  FROM TBL_QPS_CHK_FORM f
  LEFT JOIN TBL_QPS_CHK_ITEM i ON i.FORM_ID=f.FORM_ID AND i.HOSP_CD=f.HOSP_CD
 WHERE f.FORM_ID BETWEEN 'PHA029' AND 'PHA036' AND f.HOSP_CD='*'
 GROUP BY f.FORM_ID, f.FORM_NM, f.AXIS_GB ORDER BY f.FORM_ID;
SELECT DEPT_CD, COUNT(*) AS 서식수 FROM TBL_QPS_CHK_FORM WHERE HOSP_CD='*' GROUP BY DEPT_CD;
