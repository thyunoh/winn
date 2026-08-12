-- ═══════════════════════════════════════════════════════════════════════════
-- 점검표 표준 서식 시드 — 약국 **4차** : 탭 서식 · 병동 비치 (2026-08-12)
--   원본 캡처 : SUNWOO HCMS ▸ 약국 ▸ 약국서식
-- ═══════════════════════════════════════════════════════════════════════════

-- ═══════════════════════════════════════════════════════════════════════════
-- PHA016~019 · 의약품 관리대장 — **4탭 → 4서식** (PO / 외용제 / ING / 수액)
-- ═══════════════════════════════════════════════════════════════════════════
--   ★탭을 바꾸면 약품 목록이 통째로 바뀐다 ⇒ **한 서식에 담으면 섞인다.**
--     월별비치의약품(PHA025~028)을 넷으로 나눈 것과 같은 판단이다.
--   ★열 묶음 「사용기한 / 재고」 — 원본의 2단 머리글 그대로.
--   ★「약품상태」는 `□양호 □불량` 두 칸이 한 열 안에 있다. 표시 칸이므로 CHECK 로 둔다.
--     ⚠***「양호/불량」은 O/X 가 아니다.*** 정규화가 한 글자만 건드리므로 저장은 그대로 남지만,
--       이행 요약의 O/X 건수에서는 「기타」로 빠진다 — 「유/무」와 같은 문제다(결정 대기 ②).

DELETE FROM TBL_QPS_CHK_ITEM WHERE FORM_ID IN ('PHA016','PHA017','PHA018','PHA019') AND HOSP_CD='*';
DELETE FROM TBL_QPS_CHK_FORM WHERE FORM_ID IN ('PHA016','PHA017','PHA018','PHA019') AND HOSP_CD='*';

INSERT INTO TBL_QPS_CHK_FORM
 (FORM_ID, HOSP_CD, FORM_NM, CATE_CD, DEPT_CD, AXIS_GB, PRD_GB, EQUIP_CNT,
  GUIDE_TXT, HEAD_NMS, SIGNER_YN, NOTE_YN, FIX_YN, SIGN_LINE, FOOT_TXT, SORT_NO, USE_YN, REG_USER)
VALUES
 ('PHA016','*','의약품 관리대장 - PO'   ,'DRUG','PHARM','LIST','M',20,NULL,NULL,'N','N','N',NULL,NULL,200,'Y','system'),
 ('PHA017','*','의약품 관리대장 - 외용제','DRUG','PHARM','LIST','M',20,NULL,NULL,'N','N','N',NULL,NULL,201,'Y','system'),
 ('PHA018','*','의약품 관리대장 - ING'  ,'DRUG','PHARM','LIST','M',20,NULL,NULL,'N','N','N',NULL,NULL,202,'Y','system'),
 ('PHA019','*','의약품 관리대장 - 수액'  ,'DRUG','PHARM','LIST','M',20,NULL,NULL,'N','N','N',NULL,NULL,203,'Y','system');

INSERT INTO TBL_QPS_CHK_ITEM (FORM_ID, HOSP_CD, SORT, ITEM_NM, GRP_NM, INPUT_GB, UNIT_NM, USE_YN) VALUES
 ('PHA016','*',1,'약품명'  ,NULL             ,'TEXT' ,NULL,'Y'),
 ('PHA016','*',2,'약품상태',NULL             ,'CHECK',NULL,'Y'),
 ('PHA016','*',3,'사용기한','사용기한 / 재고','TEXT' ,NULL,'Y'),
 ('PHA016','*',4,'재고'    ,'사용기한 / 재고','TEXT' ,NULL,'Y'),
 ('PHA016','*',5,'비고'    ,NULL             ,'TEXT' ,NULL,'Y'),
 ('PHA017','*',1,'약품명'  ,NULL             ,'TEXT' ,NULL,'Y'),
 ('PHA017','*',2,'약품상태',NULL             ,'CHECK',NULL,'Y'),
 ('PHA017','*',3,'사용기한','사용기한 / 재고','TEXT' ,NULL,'Y'),
 ('PHA017','*',4,'재고'    ,'사용기한 / 재고','TEXT' ,NULL,'Y'),
 ('PHA017','*',5,'비고'    ,NULL             ,'TEXT' ,NULL,'Y'),
 ('PHA018','*',1,'약품명'  ,NULL             ,'TEXT' ,NULL,'Y'),
 ('PHA018','*',2,'약품상태',NULL             ,'CHECK',NULL,'Y'),
 ('PHA018','*',3,'사용기한','사용기한 / 재고','TEXT' ,NULL,'Y'),
 ('PHA018','*',4,'재고'    ,'사용기한 / 재고','TEXT' ,NULL,'Y'),
 ('PHA018','*',5,'비고'    ,NULL             ,'TEXT' ,NULL,'Y'),
 ('PHA019','*',1,'약품명'  ,NULL             ,'TEXT' ,NULL,'Y'),
 ('PHA019','*',2,'약품상태',NULL             ,'CHECK',NULL,'Y'),
 ('PHA019','*',3,'사용기한','사용기한 / 재고','TEXT' ,NULL,'Y'),
 ('PHA019','*',4,'재고'    ,'사용기한 / 재고','TEXT' ,NULL,'Y'),
 ('PHA019','*',5,'비고'    ,NULL             ,'TEXT' ,NULL,'Y');

-- ═══════════════════════════════════════════════════════════════════════════
-- PHA020 · 병동 비치 약물 관리 대장                            [LIST · 연단위]
-- ═══════════════════════════════════════════════════════════════════════════
--   ★원본 머리글이 두 단이다 :
--       확인사항 = `응급약물 / 고위험 고주의 약물 / 향정신성의약품 / 일반의약품`  (한 칸에 넷을 나열)
--       그 아래 = `확인일자` + `확인자 서명` **넷**
--     ⇒ 서명 칸 넷이 **이름이 다 같다.** 그대로 두면 추출에서 어느 약물의 서명인지 사라진다.
--       ***열 묶음으로 네 이름을 세워 뜻을 지킨다*** — PHA021(10시/19시)과 같은 처방이다.
--   ⚠**「병동 비치 약물 목록」과 다른 서식이다**(목록 ≠ 관리 대장). 이름이 닮았다고 합치지 않는다.

DELETE FROM TBL_QPS_CHK_ITEM WHERE FORM_ID='PHA020' AND HOSP_CD='*';
DELETE FROM TBL_QPS_CHK_FORM WHERE FORM_ID='PHA020' AND HOSP_CD='*';

INSERT INTO TBL_QPS_CHK_FORM
 (FORM_ID, HOSP_CD, FORM_NM, CATE_CD, DEPT_CD, AXIS_GB, PRD_GB, EQUIP_CNT,
  GUIDE_TXT, HEAD_NMS, SIGNER_YN, NOTE_YN, FIX_YN, SIGN_LINE, FOOT_TXT, SORT_NO, USE_YN, REG_USER)
VALUES
 ('PHA020', '*', '병동 비치 약물 관리 대장', 'DRUG', 'PHARM',
  'LIST', 'Y', 15, NULL, NULL, 'N', 'N', 'N', NULL, NULL, 210, 'Y', 'system');

INSERT INTO TBL_QPS_CHK_ITEM (FORM_ID, HOSP_CD, SORT, ITEM_NM, GRP_NM, INPUT_GB, UNIT_NM, USE_YN) VALUES
 ('PHA020','*',1,'확인일자'   ,NULL                ,'TEXT',NULL,'Y'),
 ('PHA020','*',2,'확인자 서명','응급약물'          ,'TEXT',NULL,'Y'),
 ('PHA020','*',3,'확인자 서명','고위험 고주의 약물','TEXT',NULL,'Y'),
 ('PHA020','*',4,'확인자 서명','향정신성의약품'    ,'TEXT',NULL,'Y'),
 ('PHA020','*',5,'확인자 서명','일반의약품'        ,'TEXT',NULL,'Y');

-- ── 확인 ────────────────────────────────────────────────────────────────────
SELECT f.FORM_ID, f.FORM_NM, f.AXIS_GB, f.PRD_GB, COUNT(i.SORT) AS 항목수
  FROM TBL_QPS_CHK_FORM f
  LEFT JOIN TBL_QPS_CHK_ITEM i ON i.FORM_ID=f.FORM_ID AND i.HOSP_CD=f.HOSP_CD
 WHERE f.FORM_ID IN ('PHA016','PHA017','PHA018','PHA019','PHA020') AND f.HOSP_CD='*'
 GROUP BY f.FORM_ID, f.FORM_NM, f.AXIS_GB, f.PRD_GB ORDER BY f.FORM_ID;
SELECT DEPT_CD, COUNT(*) AS 서식수 FROM TBL_QPS_CHK_FORM WHERE HOSP_CD='*' GROUP BY DEPT_CD;
