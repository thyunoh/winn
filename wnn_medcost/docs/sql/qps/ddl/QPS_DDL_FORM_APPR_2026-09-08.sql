-- =====================================================================
-- 점검표 서식마다 결재란 켜고 끄기 — DDL (2026-09-08, 결재란 도장 후속)
--   왜 : 사용자 「사인 하다 보니 **서식마다 결재란 관리**가 필요함 — 담당자 하는 것이 있고, 결재란이 있는 것이 있고」.
--        지금까지 결재 상자는 **결재선이 있으면 전 서식에** 그려졌다(공통 '*' 4단계라 사실상 모든 서식).
--        그런데 실물은 둘로 갈린다 —
--          ① **담당자만** : 격자의 점검자 사인 행으로 끝나는 서식(일상점검표 다수). 결재란이 없다.
--          ② **결재란 있음** : 담당·팀장·원장 칸이 종이에 그려진 서식.
--        ⇒ **서식이 정하게** 한다. 화면(결재 상자)과 인쇄(결재표)가 같은 칸을 본다.
--   ★기본값 = **'Y'(현행 유지)** — 지금 종이에 결재 상자가 나가고 있으므로 기본을 'N' 으로 뒤집으면
--     그날부터 **전 서식의 종이 모양이 바뀐다.** 끄는 것은 서식 관리에서 한 종씩(또는 아래 §3 일괄 SQL).
--   ★단계 이름을 서식이 따로 정할 수도 있다(APPR_STEPS) — 비면 **병원 결재선**(TBL_QPS_APPR_LINE)을 그대로 쓴다.
--     ⚠단계 이름을 서식마다 적어 두면 결재선을 고쳐도 그 서식은 안 따라간다 — **다를 때만** 적을 것.
--   더하기만 하는 DDL ⇒ 운영 선적용 안전(옛 WAR 는 두 칸을 읽지도 쓰지도 않는다).
--   코드 : Qps_SQL.xml(selectChkForm·saveChkForm) · QpsController(chkFormSave) ·
--          qpsChkForm.jsp(f_apprYn·f_apprSteps) · qpsChk.jsp(결재 상자·인쇄 결재표 게이트)
--   ⛔자바·매퍼가 함께 바뀐다 → **WAR 재빌드 + 재기동**.
-- =====================================================================

ALTER TABLE TBL_QPS_CHK_FORM
  ADD COLUMN APPR_YN CHAR(1) NOT NULL DEFAULT 'Y'
      COMMENT '결재란을 쓰는 서식인가. N 이면 화면 결재 상자·인쇄 결재표가 안 나온다(담당자 사인만 쓰는 서식)'
      AFTER SIGN_LINE,
  ADD COLUMN APPR_STEPS VARCHAR(200) NULL
      COMMENT '이 서식만의 결재 단계(쉼표). 비면 병원 결재선(TBL_QPS_APPR_LINE)을 따른다'
      AFTER APPR_YN;

-- ── 확인 ──────────────────────────────────────────────────────────────
-- SELECT APPR_YN, COUNT(*) FROM TBL_QPS_CHK_FORM GROUP BY APPR_YN;

-- ── §3 일괄로 끄고 싶을 때(참고 — 실행은 판단 뒤에) ─────────────────────
--   ⚠**되돌리기 어렵다** — 어느 서식이 원래 'Y' 였는지 알 수 없게 된다. 끄기 전에 SELECT 로 대상을 먼저 볼 것.
-- SELECT FORM_ID, FORM_NM, DEPT_CD FROM TBL_QPS_CHK_FORM WHERE HOSP_CD='*' AND SIGNER_YN='Y' ORDER BY DEPT_CD, FORM_ID;
--   예) 「점검자 사인 행이 있는 서식은 결재란을 안 쓴다」로 정했다면 :
-- UPDATE TBL_QPS_CHK_FORM SET APPR_YN='N', UPD_USER='apprset20260908'
--  WHERE HOSP_CD='*' AND SIGNER_YN='Y';
--   되돌리기 : UPDATE TBL_QPS_CHK_FORM SET APPR_YN='Y' WHERE UPD_USER='apprset20260908';
