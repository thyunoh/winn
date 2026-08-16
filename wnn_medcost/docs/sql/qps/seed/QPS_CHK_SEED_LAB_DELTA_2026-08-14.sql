-- ═══════════════════════════════════════════════════════════════════════════
-- 진단검사 시드 **보정** — 타 부서 대조 결과 반영 (2026-08-14)
--   대조 정본 : docs/proposals/QPS_서식판독_진단검사_2026-08-14.md §4-3
--   ★본 시드(QPS_CHK_SEED_LAB_2026-08-14.sql)는 **이미 반영해 두었다** —
--     이 파일은 *먼저 적재한 DB* 를 같은 상태로 맞추는 보정분이다. 새 DB 면 본 시드만 돌리면 된다.
-- ═══════════════════════════════════════════════════════════════════════════

-- ── ① LAB008 제거 — NUR012 와 **같은 종이다** ────────────────────────────────
--   LAB008 '혈액 냉장고 불출 대장'  열 9개
--   NUR012 '혈액입출고대장'         열 9개
--   → 환자명·등록번호·생년월일·혈액번호·수령일·불출일·불출간호사·수령간호사·불출시간
--     ***글자까지 완전히 같다.*** 간호/병동 판독 cap199 도 같은 열을 적어 두었다.
--   ⇒ 이름만 다른 중복이다. **나중에 넣은 LAB008 을 뺀다**(NUR012 가 먼저 있었다).
DELETE FROM TBL_QPS_CHK_ITEM WHERE HOSP_CD='*' AND FORM_ID='LAB008';
DELETE FROM TBL_QPS_CHK_FORM WHERE HOSP_CD='*' AND FORM_ID='LAB008';

-- ── ② LAB029 추가 — 낙상은 **별건이었다** ───────────────────────────────────
--   등록된 낙상 5종(FALLENV·NUR003·NUR004·NUR024·NUR061) 과 **항목이 하나도 안 겹친다.**
--   FALLENV 는 침대/휠체어 바퀴·서명 주체가 다르고, NUR003 은 장소별(병실/복도/계단/화장실/샤워실)
--   24항목이며, NUR024 는 환자팔찌·사이드레일 중심이다.
--   ⇒ 임상병리 판은 **게시물·표지판·전산공유** 축이라 별개 서식으로 등록한다.
INSERT INTO TBL_QPS_CHK_FORM
 (FORM_ID, HOSP_CD, FORM_NM, CATE_CD, DEPT_CD, AXIS_GB, PRD_GB, PRD_KIND,
  GUIDE_TXT, SIGNER_YN, NOTE_YN, NOTE_NM, FIX_YN, SORT_NO, USE_YN, REG_USER)
VALUES
 ('LAB029','*','낙상예방점검표(임상병리)','SAFE','LAB','ITEM_DAY','M','D',
  '적합 : o    부적합 : x','Y','Y','조치 및 개선 필요사항','N',1390,'Y','system');
INSERT INTO TBL_QPS_CHK_ITEM (FORM_ID,HOSP_CD,SORT,ITEM_NM,INPUT_GB,CARRY_YN,USE_YN) VALUES
 ('LAB029','*',1,'낙상예방 지침 게시물 점검 (내용. 부착위치 및 상태)','CHECK','N','Y'),
 ('LAB029','*',2,'낙상주의 표시판 확인 (게시물, 스티커 부착)','CHECK','N','Y'),
 ('LAB029','*',3,'침대 부속물 점검 (SIDE RAIL 작동여부, 바퀴잠금장치 작동여부)','CHECK','N','Y'),
 ('LAB029','*',4,'침대 주변 정리확인 (부속기구, 전기코드)','CHECK','N','Y'),
 ('LAB029','*',5,'바닥 점검(복도포함) (물기제거, 미끄러짐 요소 제거)','CHECK','N','Y'),
 ('LAB029','*',6,'조명확인','CHECK','N','Y'),
 ('LAB029','*',7,'낙상 고위험 환자 확인 (전산공유, 환자인식 밴드)','CHECK','N','Y');

-- ── 확인 ────────────────────────────────────────────────────────────────────
SELECT COUNT(*) AS lab_forms FROM TBL_QPS_CHK_FORM WHERE HOSP_CD='*' AND DEPT_CD='LAB';
SELECT FORM_ID, FORM_NM FROM TBL_QPS_CHK_FORM WHERE HOSP_CD='*' AND FORM_ID IN ('LAB008','LAB029');
-- 중복이 정말 사라졌는가 — 열 구성이 같은 LIST 가 둘 이상이면 여기 잡힌다
SELECT GROUP_CONCAT(f.FORM_ID ORDER BY f.FORM_ID) AS forms, COUNT(*) AS n,
       GROUP_CONCAT(DISTINCT f.FORM_NM ORDER BY f.FORM_NM SEPARATOR ' / ') AS names
  FROM TBL_QPS_CHK_FORM f
  JOIN (SELECT FORM_ID, GROUP_CONCAT(ITEM_NM ORDER BY SORT SEPARATOR '|') AS sig
          FROM TBL_QPS_CHK_ITEM WHERE HOSP_CD='*' AND USE_YN='Y' GROUP BY FORM_ID) s
    ON s.FORM_ID=f.FORM_ID
 WHERE f.HOSP_CD='*' AND f.USE_YN='Y'
 GROUP BY f.AXIS_GB, s.sig HAVING COUNT(*) > 1;
