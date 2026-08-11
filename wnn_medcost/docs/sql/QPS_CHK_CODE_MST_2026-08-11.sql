-- ═══════════════════════════════════════════════════════════════════════════
-- 점검표 코드군을 공통코드 화면에 등록 · 2026-08-11
--
-- ★왜 (사용자 지적 2026-08-11 : "여기에 해당되는 공통코드는 이것에서 관리하는 것이 좋을듯")
--   점검표의 [부서]·[분류] 셀렉트 값을 DDL 로만 넣어 두면 **항목을 늘릴 때마다 개발자를 불러야 한다.**
--   기존 QPS 코드군 30 종은 이미 공통코드 화면(/base/commcd.do)에서 관리되고 있는데,
--   `QPS_CHK_CATE`·`QPS_CHK_DEPT` 둘만 **코드군 마스터 등록을 빠뜨려** 화면 목록에 안 떴다.
--
-- ★공통코드는 표가 둘이다 — 둘 다 넣어야 화면에 보인다.
--     TBL_CODE_MST  코드군(무엇에 쓰는 코드인가)  ← 이번에 빠졌던 것
--     TBL_CODE_DTL  코드값(항목들)                ← 이미 넣었다
--   ***한쪽만 넣으면 값은 있는데 화면에 안 뜬다.*** 이번이 정확히 그 경우였다.
-- ═══════════════════════════════════════════════════════════════════════════

INSERT INTO TBL_CODE_MST (CODE_CD, JOB_SEQ, CODE_NM, START_DT, END_DT, USE_YN, ACTION_YN, REG_USER)
SELECT 'QPS_CHK_DEPT', 1, '점검표 부서', '20000101', '99991231', 'Y', 'Y', 'system'
 WHERE NOT EXISTS (SELECT 1 FROM TBL_CODE_MST x WHERE x.CODE_CD='QPS_CHK_DEPT' AND x.ACTION_YN='Y');

INSERT INTO TBL_CODE_MST (CODE_CD, JOB_SEQ, CODE_NM, START_DT, END_DT, USE_YN, ACTION_YN, REG_USER)
SELECT 'QPS_CHK_CATE', 1, '점검표 분류', '20000101', '99991231', 'Y', 'Y', 'system'
 WHERE NOT EXISTS (SELECT 1 FROM TBL_CODE_MST x WHERE x.CODE_CD='QPS_CHK_CATE' AND x.ACTION_YN='Y');

-- 확인 --------------------------------------------------------------------
SELECT '코드군' AS chk, CODE_CD, CODE_NM, USE_YN, ACTION_YN
  FROM TBL_CODE_MST WHERE CODE_CD IN ('QPS_CHK_DEPT','QPS_CHK_CATE');

SELECT '코드값' AS chk, CODE_CD, COUNT(*) AS n
  FROM TBL_CODE_DTL WHERE CODE_CD IN ('QPS_CHK_DEPT','QPS_CHK_CATE') GROUP BY CODE_CD;

-- ── 구분코드 'Q' 이름표 (사용자 요청 2026-08-11, 적용) ─────────────────────
--   TBL_CODE_DTL 에는 CODE_GB(구분) 컬럼이 있어 코드군을 업무 영역별로 묶는다 —
--     Z=공통 · O/D/H=의과/치과/한방 · C/S/Y=자보/산재/요양병원 …
--   QPS 코드군 32 종이 전부 CODE_GB='Q' 인데 **'Q' 가 무슨 뜻인지 적어 둔 데이터가 없어**
--   공통코드 화면의 「구분」 칸이 빈칸으로 나왔다. 그 이름표를 넣는다.
--
--   ★부작용 확인 완료 : 이 목록(CODE_CD='CODE_GB')을 쓰는 화면은 **공통코드 화면 하나뿐**이다
--     (commcd.jsp 의 list_code=['CODE_GB']). 다른 곳의 codeGbList 는
--     「어느 구분을 가져올까」 필터라 이 목록과 무관하다.
--     ⇒ 처음에 「수가 화면 셀렉트와 공용」이라고 적었던 우려는 사실이 아니었다.
INSERT INTO TBL_CODE_DTL (CODE_GB, CODE_CD, SUB_CODE, JOB_SEQ, SUB_CODE_NM,
                          START_DT, END_DT, USE_YN, SORT, ACTION_YN, REG_USER)
SELECT 'Z','CODE_GB','Q',1,'Q:QPS','20000101','99991231','Y',99,'Y','system'
 WHERE NOT EXISTS (SELECT 1 FROM TBL_CODE_DTL x WHERE x.CODE_CD='CODE_GB' AND x.SUB_CODE='Q');

SELECT '구분코드' AS chk, SUB_CODE, SUB_CODE_NM, USE_YN, ACTION_YN
  FROM TBL_CODE_DTL WHERE CODE_CD='CODE_GB' ORDER BY SORT, SUB_CODE;

-- 이제 QPS 코드군의 「구분」 칸에 이름이 뜬다
SELECT 'QPS코드군' AS chk, COUNT(*) AS n FROM TBL_CODE_DTL WHERE CODE_GB='Q';
