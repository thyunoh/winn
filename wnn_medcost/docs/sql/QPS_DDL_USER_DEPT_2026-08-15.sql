-- ═══════════════════════════════════════════════════════════════════════════
-- 사용자 ↔ 담당 부서 매핑 (2026-08-15) — 「사용자마다 프로그램 사용등록」 요청의 1단계
--   담당자가 **제 부서 점검표만** 보게 한다. 부서가 15개라 전부 보이면 제 것을 못 찾는다.
--
--   ★한 사람이 **여러 부서**를 맡을 수 있다(겸직이 흔하다) ⇒ 행이 여러 개.
--   ★★***등록이 없으면 「전 부서」다*** — 이 표가 비어 있으면 지금과 똑같이 동작한다.
--     「등록 안 했으니 아무것도 못 본다」로 만들면 **도입하는 날 업무가 멈춘다.**
--     즉 이 기능은 **막는 장치가 아니라 좁혀 주는 장치**다.
--   ★위너넷 담당자(s_wnn_yn='Y')는 여러 병원을 지원하므로 **언제나 전 부서**다.
--
--   ⚠기존 `TBL_USERAUTH_MST`(업무별 CRUD 권한)와 **다른 축**이다 — 그쪽은 「무엇을 할 수 있나」,
--     이쪽은 「어느 부서 것을 보나」. 섞지 않는다(그 표의 `PGM_URL` 은 지금도 비어 있다).
-- 재실행 안전.
-- ═══════════════════════════════════════════════════════════════════════════

CREATE TABLE IF NOT EXISTS TBL_QPS_USER_DEPT (
  HOSP_CD   VARCHAR(10)  NOT NULL              COMMENT '병원코드',
  USER_ID   VARCHAR(50)  NOT NULL              COMMENT '사용자 ID (TBL_USER_MST)',
  DEPT_CD   VARCHAR(20)  NOT NULL              COMMENT '담당 부서 (QPS_CHK_DEPT 공통코드)',
  USE_YN    VARCHAR(1)   NULL DEFAULT 'Y'      COMMENT '사용여부',
  REG_DTTM  DATETIME     NULL DEFAULT CURRENT_TIMESTAMP,
  REG_USER  VARCHAR(50)  NULL,
  PRIMARY KEY (HOSP_CD, USER_ID, DEPT_CD),
  KEY IX_QPS_USER_DEPT_1 (HOSP_CD, USER_ID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
  COMMENT='QPS 사용자별 담당 부서 — 없으면 전 부서(막는 장치가 아니라 좁혀 주는 장치)';

-- ── 확인 ────────────────────────────────────────────────────────────────────
SELECT COUNT(*) AS 매핑건수 FROM TBL_QPS_USER_DEPT;
SHOW CREATE TABLE TBL_QPS_USER_DEPT\G
