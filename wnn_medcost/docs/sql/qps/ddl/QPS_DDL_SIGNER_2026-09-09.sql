-- =====================================================================
-- 담당자별 사인·도장 관리 — DDL (2026-09-09)
--   왜 : 사용자 「담당자별 사인(작성해서) 및 도장 관리 필요함」 · 「사인은 작성해서 저장 기능」.
--        지금 도장은 **로그인 계정 본인만**(TBL_QPS_SIGN, 결재란용) 등록할 수 있다. 그런데 점검표 사인 칸에
--        이름이 오르는 사람(근무표의 간호사·조무사)은 대개 **계정이 없다** — 그 사람의 사인 그림을 붙일 길이 없었다.
--        근무표의 「사람 고르기」도 같은 뿌리다(계정 없는 병원은 콤보가 빈다).
--
--   ── 설계 : 새 표를 만들지 않고 TBL_QPS_SIGN 을 「담당자 표」로 넓힌다 ─────────────────
--     · 한 줄 = 한 사람 = 사인 그림 한 장. 계정이 있으면 USER_ID = 계정, 없으면 서버가 만든 **P + 12자리**.
--     · ACCT_YN 으로 가른다 — Y = 로그인 계정(결재란에 찍을 수 있다) · N = 이름만 있는 담당자(사인 칸에만 쓰인다).
--     · 격자 사인 칸의 도장은 이미 **이름으로** 찾으므로(selectQpsSignsByNames) 계정 없는 사람도 저절로 붙는다.
--     · 근무표 사람 콤보는 이 표를 읽는다 — USER_ID 를 함께 이어 두면 사인 매치가 이름이 아니라 사람으로 간다.
--   ★결재란(상단 결재 상자·서식 아래 결재란)은 그대로 **로그인 계정 본인만** 찍는다 — 이 표가 넓어져도 그 규칙은 안 바뀐다.
--   ★그림 등록·삭제 권한 = 자료실과 같은 규칙(위너넷 · QPS 담당자 · 담당자가 없으면 병원관리자). 본인 도장은 종전대로 본인이.
--
--   더하기만 하는 DDL ⇒ 운영 선적용 안전(옛 WAR 는 새 칸을 안 읽는다).
--   코드 : Qps_SQL.xml(selectQpsSigners·insertQpsSigner·updateQpsSigner·clearQpsSignImg) · QpsController(signer*.do) ·
--          qpsSigner.jsp(새 화면, 관리(설정) ▸ 담당자 사인·도장) · qpsDuty.jsp(사람 콤보) · ⛔자바·매퍼 → WAR 재빌드 + 재기동
-- =====================================================================

ALTER TABLE TBL_QPS_SIGN
  ADD COLUMN JOB_NM  VARCHAR(50)  NULL              COMMENT '직종·직위(간호사·조무사 등)' AFTER USER_NM,
  ADD COLUMN DEPT_CD VARCHAR(20)  NULL              COMMENT 'QPS 부서 코드(QPS_CHK_DEPT) — 근무표·사인 콤보를 부서로 거른다' AFTER JOB_NM,
  ADD COLUMN ACCT_YN CHAR(1)      NOT NULL DEFAULT 'Y' COMMENT 'Y=로그인 계정(결재 가능) · N=이름만 있는 담당자(사인 칸 전용)' AFTER DEPT_CD,
  ADD COLUMN SORT_NO INT          NOT NULL DEFAULT 0 COMMENT '차례' AFTER ACCT_YN;

-- 기존 행(내 도장으로 등록한 계정)은 전부 Y 로 시작한다 — DEFAULT 'Y' 가 채운다.

-- ── 확인 ──────────────────────────────────────────────────────────────
-- SELECT COLUMN_NAME, COLUMN_TYPE, COLUMN_DEFAULT FROM INFORMATION_SCHEMA.COLUMNS
--  WHERE TABLE_SCHEMA='WNN' AND TABLE_NAME='TBL_QPS_SIGN' ORDER BY ORDINAL_POSITION;
