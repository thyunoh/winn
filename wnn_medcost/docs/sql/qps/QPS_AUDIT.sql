-- ═══════════════════════════════════════════════════════════════════════════
-- QPS 서식 데이터 점검 (2026-08-15 신설) — ***조회만 한다. 고치지 않는다.***
--   서식이 300종을 넘으면서 눈으로는 어긋남을 못 찾는다. 시드를 새로 넣은 뒤 이걸 돌린다.
--   ⚠결과가 비어 있어야 정상인 항목과, **비어 있으면 안 되는** 항목이 섞여 있다 — 각 절 머리말 참조.
-- ═══════════════════════════════════════════════════════════════════════════

-- ── ① 부서별 점검표 수 — ★0 인 부서는 **사이드바에 링크를 걸면 안 된다** ────────
--   ⚠아래 숫자는 **그 부서 소속만** 센다. 화면은 「그 부서 + 공통(COMMON)」을 보여주므로
--     0 인 부서를 눌러도 빈 화면이 아니라 ***공통 서식만*** 뜬다(2026-08-15 실측 : MSDS 2종).
--     담당자가 「우리 부서 점검표는 이것뿐인가」로 잘못 읽으므로 링크를 걸지 않는다.
--     2026-08-15 에 감염관리·진료가 그래서 빠졌다.
--   ***여기서 0 이 아니게 된 부서가 생기면 sidebar.jsp 「부서별 점검표」에 줄을 더한다.***
SELECT '① 부서별' 구분, c.SUB_CODE 부서, c.SUB_CODE_NM 이름, IFNULL(f.n,0) 점검표수,
       CASE WHEN IFNULL(f.n,0)=0 THEN '⚠메뉴 링크 금지' ELSE '' END 비고
  FROM TBL_CODE_DTL c
  LEFT JOIN (SELECT DEPT_CD, COUNT(*) n FROM TBL_QPS_CHK_FORM
              WHERE HOSP_CD='*' AND USE_YN='Y' GROUP BY DEPT_CD) f ON f.DEPT_CD=c.SUB_CODE
 WHERE c.CODE_CD='QPS_CHK_DEPT' AND c.USE_YN='Y'
 ORDER BY IFNULL(f.n,0), c.SORT;

-- ── ② 항목이 0개인 서식 — 축마다 뜻이 다르다 ────────────────────────────────
--   · ITEM_DAY/ITEM_MONTH/ITEM_COL/DAY_ITEM/LIST → **결함**(격자 축이 비었다)
--   · EQUIP_DAY → 정상일 수 있다. 이 축은 항목이 격자 축이 아니라 **머리 범례**다
--     (기기명은 문서가 적는다). 점검항목이 없는 서식(물품 Count 등)도 실재한다.
SELECT '② 항목0' 구분, f.FORM_ID, f.FORM_NM, f.AXIS_GB,
       CASE WHEN f.AXIS_GB='EQUIP_DAY' THEN '범례 없음(정상일 수 있음)' ELSE '⚠결함' END 판정
  FROM TBL_QPS_CHK_FORM f
 WHERE f.HOSP_CD='*' AND f.USE_YN='Y'
   AND NOT EXISTS (SELECT 1 FROM TBL_QPS_CHK_ITEM i
                    WHERE i.FORM_ID=f.FORM_ID AND i.HOSP_CD='*' AND i.USE_YN='Y')
 ORDER BY f.AXIS_GB, f.FORM_ID;

-- ── ③ ITEM_COL 인데 열이 없다 — ★COL_SRC='D' 면 정상 ───────────────────────
--   열 이름을 **문서가 정하는** 서식이 있다(MSDS 물질명 · 소방 층/병동). 그때는 COL_NMS 가 빈다.
SELECT '③ 열없음' 구분, FORM_ID, FORM_NM, IFNULL(COL_SRC,'F') COL_SRC,
       CASE WHEN COL_SRC='D' THEN '문서가 정함(정상)' ELSE '⚠결함' END 판정
  FROM TBL_QPS_CHK_FORM
 WHERE HOSP_CD='*' AND USE_YN='Y' AND AXIS_GB='ITEM_COL' AND (COL_NMS IS NULL OR COL_NMS='');

-- ── ④ 코드 테이블에 없는 부서 (비어야 정상) ─────────────────────────────────
SELECT '④ 미등록부서' 구분, f.FORM_ID, f.DEPT_CD FROM TBL_QPS_CHK_FORM f
 WHERE f.HOSP_CD='*' AND f.USE_YN='Y' AND IFNULL(f.DEPT_CD,'')<>''
   AND NOT EXISTS (SELECT 1 FROM TBL_CODE_DTL c
                    WHERE c.CODE_CD='QPS_CHK_DEPT' AND c.SUB_CODE=f.DEPT_CD AND c.USE_YN='Y');

-- ── ⑤ 사진칸 12개 초과 (비어야 정상 — 업로드 엔드포인트가 1~12 만 받는다) ──
SELECT '⑤ 사진칸초과' 구분, FORM_ID, PHOTO_NMS FROM TBL_QPS_CHK_FORM
 WHERE HOSP_CD='*' AND PHOTO_NMS IS NOT NULL
   AND (CHAR_LENGTH(PHOTO_NMS)-CHAR_LENGTH(REPLACE(PHOTO_NMS,',','')))>11;

-- ── ⑥ safeRpt 유형 SORT 중복 (비어야 정상 — 계열 묶음이 흔들린다) ───────────
--   ★SORT 대역 = 계열 : 1~9 사고 · 10~19 의약품/혈액 · 20~30 보건 · 31~50 인사총무 ·
--     51~70 의무기록 · 71~72 영양 · 73~90 사회복지 · 91~ 검진 (qpsSafeRpt.jsp BANDS)
SELECT '⑥ SORT중복' 구분, SORT, COUNT(*) n, GROUP_CONCAT(SUB_CODE ORDER BY SUB_CODE) 유형
  FROM TBL_CODE_DTL WHERE CODE_CD='QPS_SAFERPT_GB' AND USE_YN='Y'
 GROUP BY SORT HAVING n>1;

-- ── ⑦ 대역 밖 SORT (비어야 정상 — 셀렉트에서 묶음 없이 맨 아래로 떨어진다) ──
SELECT '⑦ 대역밖' 구분, SUB_CODE, SUB_CODE_NM, SORT FROM TBL_CODE_DTL
 WHERE CODE_CD='QPS_SAFERPT_GB' AND USE_YN='Y' AND (SORT IS NULL OR SORT>99);

-- ── ⑧ LBL_JSON 이 깨졌다 (비어야 정상 — 라벨이 통째로 무시된다) ─────────────
SELECT '⑧ JSON깨짐' 구분, RPT_GB FROM TBL_QPS_SAFERPT_FORM
 WHERE LBL_JSON IS NOT NULL AND JSON_VALID(LBL_JSON)=0;

-- ── ⑨ 쓰는 묶음(USE)에 항목(DEF)이 없다 — ★공용 '*' 정의면 정상 ────────────
--   매퍼가 `d.RPT_GB IN (u.RPT_GB,'*')` 로 조인한다. 아래는 **공용도 없는 것**만 잡는다.
SELECT '⑨ 빈묶음' 구분, u.RPT_GB, u.GRP_CD FROM TBL_QPS_SAFERPT_USE u
 WHERE u.USE_YN='Y'
   AND NOT EXISTS (SELECT 1 FROM TBL_QPS_SAFERPT_DEF d
                    WHERE d.GRP_CD=u.GRP_CD AND d.USE_YN='Y' AND d.RPT_GB IN (u.RPT_GB,'*'));

-- ── ⑩ 유형은 있는데 코드가 없다 / 코드는 있는데… ────────────────────────────
--   ★코드만 있고 FORM 행이 없는 것은 **정상**이다(설정이 없는 유형이 대부분 — 화면이 {} 로 돈다).
--   반대(FORM 은 있는데 코드가 없다)는 셀렉트에 안 나오므로 결함.
SELECT '⑩ 코드없는FORM' 구분, f.RPT_GB FROM TBL_QPS_SAFERPT_FORM f
 WHERE f.USE_YN='Y'
   AND NOT EXISTS (SELECT 1 FROM TBL_CODE_DTL c
                    WHERE c.CODE_CD='QPS_SAFERPT_GB' AND c.SUB_CODE=f.RPT_GB AND c.USE_YN='Y');

-- ── ⑫ 병원 마스터에 없는 병원 코드의 QPS 자료 (비어야 정상 — 2026-09-02 신설) ──
--   08-15 검증용 가짜병원(99999998)의 서식·사용세트가 남아 있던 것을 09-02 에야 찾았다(문서·값만 지웠었다).
--   '*' 는 공용이라 뺀다. 여기 나오면 QPS_CLEAN_TESTHOSP_2026-09-02.sql 처럼 지운다.
SELECT '⑫ 미등록병원' 구분, t.표, t.HOSP_CD, t.n FROM (
  SELECT 'CHK_FORM' 표, HOSP_CD, COUNT(*) n FROM TBL_QPS_CHK_FORM WHERE HOSP_CD<>'*' GROUP BY HOSP_CD
  UNION ALL SELECT 'CHK_USE',  HOSP_CD, COUNT(*) FROM TBL_QPS_CHK_USE  WHERE HOSP_CD<>'*' GROUP BY HOSP_CD
  UNION ALL SELECT 'CHK_DOC',  HOSP_CD, COUNT(*) FROM TBL_QPS_CHK_DOC  GROUP BY HOSP_CD
  UNION ALL SELECT 'SAFERPT',  HOSP_CD, COUNT(*) FROM TBL_QPS_SAFERPT  GROUP BY HOSP_CD
  UNION ALL SELECT 'MINUTES',  HOSP_CD, COUNT(*) FROM TBL_QPS_MINUTES  GROUP BY HOSP_CD
  UNION ALL SELECT 'SECLOG',   HOSP_CD, COUNT(*) FROM TBL_QPS_SECLOG   GROUP BY HOSP_CD
) t
 WHERE NOT EXISTS (SELECT 1 FROM TBL_HOSP_MST h WHERE h.HOSP_CD = t.HOSP_CD);

-- ── ⑪ 총계 ─────────────────────────────────────────────────────────────────
SELECT '⑪ 총계' 구분,
  (SELECT COUNT(*) FROM TBL_QPS_CHK_FORM WHERE HOSP_CD='*' AND USE_YN='Y') 점검표,
  (SELECT COUNT(*) FROM TBL_CODE_DTL WHERE CODE_CD='QPS_SAFERPT_GB' AND USE_YN='Y') safeRpt유형,
  (SELECT COUNT(*) FROM TBL_CODE_DTL WHERE CODE_CD='QPS_CHK_DEPT' AND USE_YN='Y') 부서;
