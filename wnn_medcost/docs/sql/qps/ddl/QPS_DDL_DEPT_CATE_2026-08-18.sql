-- ═══════════════════════════════════════════════════════════════════════════
-- 부서별 「쓰는 분류」 마스터 (2026-08-18) — 사용자 결정
--   「부서별로 어느 분류 서식을 쓸지 정하고 관리해야 할 듯 (기본은 설정하고)」
--
--   왜 : 서식 1건에는 **부서 1개 + 분류 1개**가 붙는데, 실제로 쓰이는 조합은
--        부서 14 × 분류 6 = 84칸 중 **42칸뿐**이다(2026-08-18 실측, 서식 311종).
--        나머지 절반은 「고르면 0종이 되는」 헛 조합이다. 그것을 사람이 정해 두는 표다.
--
--   ★★***등록이 없는 부서는 「전 분류」다*** — TBL_QPS_USER_DEPT 와 같은 규칙이다.
--     빈 표는 지금과 똑같이 동작한다. **막는 장치가 아니라 좁혀 주는 장치**다.
--     ⇒ 체크를 전부 끄고 저장하면 그 부서는 **전 분류로 되돌아간다**(해제 기능이 따로 필요 없다).
--
--   ★적용 지점은 **서식 등록 화면 하나뿐**이다(사용자 결정) — 위너넷이 새 서식을 만들 때
--     그 부서에 정해진 분류만 셀렉트에 남는다. ***보는 화면(사용 서식·점검표 작성)은 손대지 않는다.***
--     보는 쪽까지 막으면 규칙과 자료가 어긋나는 날 **서식이 목록에서 사라진다.**
--
--   ★병원 구분이 없다 — 서식 자체가 공통('*')이라 이 규칙도 공통이다.
-- 재실행 안전.
-- ═══════════════════════════════════════════════════════════════════════════

CREATE TABLE IF NOT EXISTS TBL_QPS_DEPT_CATE (
  DEPT_CD   VARCHAR(20)  NOT NULL              COMMENT '부서 (QPS_CHK_DEPT 공통코드)',
  CATE_CD   VARCHAR(20)  NOT NULL              COMMENT '분류 (QPS_CHK_CATE 공통코드)',
  USE_YN    VARCHAR(1)   NULL DEFAULT 'Y'      COMMENT '사용여부 — 저장은 지우고 다시 넣는 방식이라 늘 Y',
  REG_DTTM  DATETIME     NULL DEFAULT CURRENT_TIMESTAMP,
  REG_USER  VARCHAR(50)  NULL,
  PRIMARY KEY (DEPT_CD, CATE_CD)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
  COMMENT='QPS 부서별 쓰는 분류 — 없는 부서는 전 분류(좁혀 주는 장치)';

-- ── 기본값 : ★지금 등록된 서식에서 그대로 뽑는다 ───────────────────────────
--   손으로 42줄을 적지 않는다. 서식이 늘어난 뒤 다시 돌려도 **안전**하다(있는 것만 채운다).
--   ⚠이미 정해 둔 것을 이 문장이 지우지는 않는다 — 넣기만 한다.
--     사람이 「이 부서는 이 분류를 안 쓴다」로 지운 칸을 되살리고 싶지 않다면 **다시 돌리지 말 것.**
INSERT INTO TBL_QPS_DEPT_CATE (DEPT_CD, CATE_CD, USE_YN, REG_USER)
SELECT f.DEPT_CD, f.CATE_CD, 'Y', 'SEED-20260818'
  FROM TBL_QPS_CHK_FORM f
 WHERE f.USE_YN = 'Y'
   AND f.DEPT_CD IS NOT NULL AND f.DEPT_CD <> ''
   AND f.CATE_CD IS NOT NULL AND f.CATE_CD <> ''
 GROUP BY f.DEPT_CD, f.CATE_CD
ON DUPLICATE KEY UPDATE USE_YN = 'Y';

-- ── 확인 ────────────────────────────────────────────────────────────────────
-- ① 몇 칸이 정해졌나 (2026-08-18 기준 42)
SELECT COUNT(*) AS 정해진칸수, COUNT(DISTINCT DEPT_CD) AS 부서수 FROM TBL_QPS_DEPT_CATE;

-- ② 부서별로 무엇을 쓰나
SELECT dc.DEPT_CD AS 부서,
       GROUP_CONCAT(dc.CATE_CD ORDER BY dc.CATE_CD SEPARATOR ',') AS 쓰는분류,
       COUNT(*) AS 분류수
  FROM TBL_QPS_DEPT_CATE dc
 GROUP BY dc.DEPT_CD
 ORDER BY 분류수 DESC;

-- ③ ★규칙과 자료가 어긋난 서식은 없는가 — 있으면 등록 화면에서 그 값이 안 보이게 된다
--    (그래도 서식은 목록에서 사라지지 않는다 — 보는 화면은 이 표를 안 쓴다)
SELECT f.FORM_ID, f.FORM_NM, f.DEPT_CD, f.CATE_CD
  FROM TBL_QPS_CHK_FORM f
 WHERE f.USE_YN = 'Y'
   AND f.DEPT_CD <> '' AND f.CATE_CD <> ''
   AND EXISTS (SELECT 1 FROM TBL_QPS_DEPT_CATE d WHERE d.DEPT_CD = f.DEPT_CD)
   AND NOT EXISTS (SELECT 1 FROM TBL_QPS_DEPT_CATE d
                    WHERE d.DEPT_CD = f.DEPT_CD AND d.CATE_CD = f.CATE_CD)
 ORDER BY f.DEPT_CD, f.CATE_CD;
