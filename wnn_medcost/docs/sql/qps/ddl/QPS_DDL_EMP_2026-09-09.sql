-- =====================================================================
-- 인사 등록 — DDL (2026-09-09, QPS_DDL_SIGNER 바로 뒤에 실행)
--   왜 : 사용자 「인사등록도 필요함」. 담당자 표(TBL_QPS_SIGN)가 「한 사람 한 줄」이 되었으니 SUNWOO 의 사원등록(w35 :
--        사용자코드·사용자명·부서·직책/직급·입사일 + 엑셀 불러오기)을 **같은 표**에 얹는다. 직원 표를 따로 만들면
--        「사람」이 두 표에 갈려 근무표·사인·결재가 서로 다른 사람을 가리키게 된다(이 저장소가 여러 번 겪은 함정).
--   ── 더한 칸 ─────────────────────────────────────────────────────────
--     · EMP_NO    사번(병원 사원번호, 자유 글자)               · POS_NM  직책/직급(수간호사·팀장 …) — 직종(JOB_NM)과 다르다
--     · JOIN_DT   입사일 YYYYMMDD                              · RETIRE_DT 퇴사일 YYYYMMDD — 있고 오늘 이전이면 **퇴직자**
--     · REMARK    비고
--   ★퇴직자는 근무표 사람 콤보(selectQpsSignerNames)에서 빠지고, 인사 화면은 「퇴사자 포함」을 켜야 보인다.
--     찍힌 문서의 사인 그림(selectQpsSignsByNames)은 그대로 찾는다 — 옛 종이의 도장이 사라지면 안 된다.
--   ★주민번호·연락처·주소는 넣지 않는다(개인정보 최소화 — HRCARD 인사기록카드와 같은 원칙).
--
--   더하기만 하는 DDL ⇒ 운영 선적용 안전. 코드 : Qps_SQL.xml(selectQpsSigners·SignerNames·insert/updateQpsSigner) ·
--   QpsServiceImpl.saveQpsSigner · QpsController(signerList/Save) · qpsSigner.jsp(인사 등록 화면) · ⛔자바·매퍼 → WAR 재빌드 + 재기동
-- =====================================================================

ALTER TABLE TBL_QPS_SIGN
  ADD COLUMN EMP_NO    VARCHAR(20)  NULL COMMENT '사번'                                   AFTER USER_NM,
  ADD COLUMN POS_NM    VARCHAR(50)  NULL COMMENT '직책/직급(수간호사·팀장 …)'              AFTER JOB_NM,
  ADD COLUMN JOIN_DT   CHAR(8)      NULL COMMENT '입사일 YYYYMMDD'                         AFTER SORT_NO,
  ADD COLUMN RETIRE_DT CHAR(8)      NULL COMMENT '퇴사일 YYYYMMDD — 오늘 이전이면 퇴직자'  AFTER JOIN_DT,
  ADD COLUMN REMARK    VARCHAR(200) NULL COMMENT '비고'                                   AFTER RETIRE_DT;

-- ── 확인 ──────────────────────────────────────────────────────────────
-- SELECT COLUMN_NAME, COLUMN_TYPE FROM INFORMATION_SCHEMA.COLUMNS
--  WHERE TABLE_SCHEMA='WNN' AND TABLE_NAME='TBL_QPS_SIGN' ORDER BY ORDINAL_POSITION;
