-- =====================================================================
-- MIS 시연 자료 정리 (2026-10-08 시연·검증으로 운영 DB 에 남긴 것) — 회의가 끝난 뒤 돌린다.
--   ★먼저 SELECT 로 보고, 지울 블록만 주석을 풀어 실행. 전부 MIS 표만 건드린다(청구·평가표·입퇴원현황·계정 표는 무관).
--   실행 전 개수(2026-10-08 16시) : 고정비 6 · 설정 1 · 부산은빛 상담 1(삭제 상태) · 위너넷 상담 7(사용 6 + 삭제 1) · 받는 사람 1 · 이력 2
-- =====================================================================

-- ── 0. 지금 무엇이 있나 ──────────────────────────────────────────────
SELECT 'COST' AS t, HOSP_CD, YYYYMM, COUNT(*) n FROM TBL_MIS_COST GROUP BY HOSP_CD, YYYYMM;
SELECT 'CFG' AS t, HOSP_CD, BED_CNT, VAR_COST_DAY FROM TBL_MIS_CFG;
SELECT 'CAT(병원 추가·사본)' AS t, HOSP_CD, CAT_CD, CAT_NM, USE_YN FROM TBL_MIS_COST_CAT WHERE HOSP_CD <> '*';
SELECT 'LEAD' AS t, HOSP_CD, LEAD_SEQ, PAT_NM, STAGE, USE_YN FROM TBL_MIS_LEAD ORDER BY HOSP_CD, LEAD_SEQ;
SELECT 'NOTI_USER' AS t, HOSP_CD, NOTI_SEQ, NAME, EMAIL, TEL FROM TBL_MIS_NOTI_USER;
SELECT 'NOTI_LOG' AS t, HOSP_CD, CHANNEL, RESULT, TO_NAME, SENT_DTTM FROM TBL_MIS_NOTI_LOG ORDER BY LOG_SEQ;

-- ── 1. 부산은빛(21281238) — 시연용 고정비·설정 (제안서·경영통계 시안에 쓴 값) ──
-- DELETE FROM TBL_MIS_COST WHERE HOSP_CD = '21281238' AND YYYYMM = '202609' AND MEMO = '시연 예시';
-- DELETE FROM TBL_MIS_CFG  WHERE HOSP_CD = '21281238';
-- DELETE FROM TBL_MIS_NOTI_LOG WHERE HOSP_CD = '21281238';                         -- 시험 발송 이력(문자 건너뜀 등)
-- DELETE FROM TBL_MIS_LEAD_LOG WHERE HOSP_CD = '21281238' AND LEAD_SEQ IN (SELECT LEAD_SEQ FROM (SELECT LEAD_SEQ FROM TBL_MIS_LEAD WHERE HOSP_CD='21281238' AND USE_YN='N') x);
-- DELETE FROM TBL_MIS_LEAD WHERE HOSP_CD = '21281238' AND USE_YN = 'N';            -- 시연 뒤 삭제 표시만 된 상담(박영순)

-- ── 2. 위너넷(w1234567) — 관리판 시연 상담 6건 + 받는 사람 + 공유 이력 ──
--    (회의에서 계속 보여 줄 거면 남겨 둔다)
-- DELETE FROM TBL_MIS_LEAD_LOG WHERE HOSP_CD = 'w1234567';
-- DELETE FROM TBL_MIS_LEAD     WHERE HOSP_CD = 'w1234567';
-- DELETE FROM TBL_MIS_NOTI_LOG WHERE HOSP_CD = 'w1234567';
-- DELETE FROM TBL_MIS_NOTI_USER WHERE HOSP_CD = 'w1234567';
-- DELETE FROM TBL_MIS_COST_CAT WHERE HOSP_CD = 'w1234567';                           -- 항목 끄기/추가 시험으로 생긴 병원 사본

-- ── 3. 다른 병원에서 눌러 본 흔적 (예: 31284922 항목 사본 1건) — 그 병원이 실제로 쓰기 시작했으면 두고, 시험이면 지운다 ──
-- DELETE FROM TBL_MIS_COST_CAT WHERE HOSP_CD = '31284922';

-- ── 4. 확인 ──
-- SELECT (SELECT COUNT(*) FROM TBL_MIS_COST) cost, (SELECT COUNT(*) FROM TBL_MIS_CFG) cfg, (SELECT COUNT(*) FROM TBL_MIS_LEAD) lead_, (SELECT COUNT(*) FROM TBL_MIS_NOTI_USER) nuser, (SELECT COUNT(*) FROM TBL_MIS_NOTI_LOG) nlog;
