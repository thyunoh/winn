-- =====================================================================
-- ⛔⛔ 이 파일보다 **DDL 을 먼저** 돌려야 한다 ⇒ docs/sql/qps/ddl/QPS_DDL_SRPT_NAMECOL_2026-09-09.sql
--     (안 돌리면 여기서 `SQL 오류 (1054): Unknown column 'NAME_COLS' in 'field list'` 가 난다 — 2026-09-09 실제로 겪었다.
--      그 오류가 났어도 **자료는 하나도 안 바뀐다** — DDL 을 돌린 뒤 이 파일을 그대로 다시 실행하면 된다.)
-- =====================================================================
-- 보고서(safeRpt) 반복행 「직원 이름 열」 시드 — NAME_COLS (2026-09-09)
--   값 = **열 번호**(SUB_COLS 를 쉼표로 나눈 차례, 1부터) 목록. 그 칸에만 작성 화면이 인사 등록 명단을 붙인다.
--
--   ★★**켠 것 — 우리 직원이 확실한 열만** :
--     · BLOODRTN(혈액 반납·폐기 신청서) 벌1 : 5·6·7·8 = 수(책임)간호사 · 담당간호사 · 담당의사 · 혈액은행담당자
--     · MRCOMPL(의무기록 완결도) 벌1        : 1·5 = 담당의사 · 담당의사 확인
--     · HLTDIARY(보건관리 업무일지) 벌4     : 1   = 상담 근로자(우리 직원이 상담을 받는다)
--
--   ⛔**일부러 안 켠 것 — 「이름 열」이지만 우리 직원이 아니거나 켤 자리가 아니다** :
--     · HRCARD 벌3 「성명」        = **가족사항**이다(직원 본인이 아니다).
--     · SWVOLCF 「성명」(단벌)     = **자원봉사자**다 — 외부인이라 인사 명단에 없다.
--     · HARASS 「성명」(단벌)      = 직장 내 괴롭힘·성희롱 보고서의 당사자다. 우리 직원이 맞지만
--                                    **민감한 서식이라 이름 목록을 굳이 펼쳐 주지 않는다**(그대로 쳐서 적는다).
--     · MRCOMPL 벌2 「확인」       = 병동별 표의 확인 칸이라 사람 이름인지 분명하지 않다 — 병원이 필요하면 켠다.
--     ⇒ 이 판단이 이 시드의 핵심이다. **열 이름만 보고 자동으로 켜면 환자·가족·외부인 칸에 직원 명단이 뜬다.**
--
--   되돌리기 : 맨 아래 UPDATE 한 줄(전부 NULL 로).
--   코드 : Qps_SQL.xml(selectSafeRptForm·selectSafeRptSub) · qpsSafeRpt.jsp — ⛔**매퍼 변경 → WAR 재빌드+재기동**
-- =====================================================================

-- ── 넣기 전 확인 : 열 차례가 맞는지 눈으로 본다 ───────────────────────
-- SELECT RPT_GB, SUB_NO, SUB_NM, SUB_COLS FROM TBL_QPS_SAFERPT_SUB
--  WHERE RPT_GB IN ('BLOODRTN','MRCOMPL','HLTDIARY') AND USE_YN='Y' ORDER BY RPT_GB, SUB_NO;

-- 혈액 제제명(1) · 혈액번호(2) · 불출시간(3) · 폐기의뢰시간(4) · 수(책임)간호사(5) · 담당간호사(6) · 담당의사(7) · 혈액은행담당자(8)
UPDATE TBL_QPS_SAFERPT_SUB SET NAME_COLS = '5,6,7,8'
 WHERE RPT_GB = 'BLOODRTN' AND SUB_NO = 1;

-- 담당의사(1) · 퇴원환자 수(2) · 완결도 율(3) · 전월완결도(4) · 담당의사 확인(5)
UPDATE TBL_QPS_SAFERPT_SUB SET NAME_COLS = '1,5'
 WHERE RPT_GB = 'MRCOMPL' AND SUB_NO = 1;

-- 상담 근로자(1) · 성 별(2) · 연 령(3) · 상담내용(4) · 상담후 조치(5)
UPDATE TBL_QPS_SAFERPT_SUB SET NAME_COLS = '1'
 WHERE RPT_GB = 'HLTDIARY' AND SUB_NO = 4;
-- 기대 : 3 rows (한 줄씩)

-- ── 확인 ──────────────────────────────────────────────────────────────
-- SELECT RPT_GB, SUB_NO, NAME_COLS, SUB_COLS FROM TBL_QPS_SAFERPT_SUB
--  WHERE IFNULL(NAME_COLS,'') != '' ORDER BY RPT_GB, SUB_NO;      -- 3줄

-- ── 되돌리기(원복) ────────────────────────────────────────────────────
-- UPDATE TBL_QPS_SAFERPT_SUB SET NAME_COLS = NULL WHERE IFNULL(NAME_COLS,'') != '';
