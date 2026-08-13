-- ═══════════════════════════════════════════════════════════════════════════
-- 격자 아래 자유행 표 (2026-08-13) — 서식이 열 이름을 정하고, 행은 문서가 늘린다
--   근거 6종 : 멸균기 2(NUR001·002 「문제 발생시」) · U.P.S(FAC004 경보조치사항) ·
--             학대폭력(NUR025) · 음용수(NUR027) · 병동 안전점검 일지(NUR065 근무시간별 업무사항)
--   ★값 자리 = TBL_QPS_CHK_VAL 의 **행 9000+i / 열 j** — 9000대는 이 표의 예약대다
--     (LIST 행 블록이 블록×1000+항목이라 멀리 떨어뜨렸다).
--   ★전월복사는 이 표를 **안 가져온다** — 그 달에 일어난 일이다.
--   ⚠더하기만 하는 ALTER — 옛 SQL 은 이 칸을 읽지도 쓰지도 않는다(운영 선적용 안전).
-- ═══════════════════════════════════════════════════════════════════════════
ALTER TABLE TBL_QPS_CHK_FORM
  ADD COLUMN SUB_NM   VARCHAR(60)  NULL
      COMMENT "격자 아래 자유행 표의 왼쪽 이름 칸(예 '문제 발생시'). 비면 이름 칸 없음" AFTER NOTE_NM,
  ADD COLUMN SUB_COLS VARCHAR(300) NULL
      COMMENT "격자 아래 자유행 표의 열 이름들(쉼표). 값이 있으면 표를 그린다. 값 자리=행 9000+i/열 j" AFTER SUB_NM;

-- ── 근거 6종에 켠다 ──────────────────────────────────────────────────────────
-- ⚠NUR065·FAC004 는 원본에서 표 **제목 띠**였다 — 우리 표는 왼쪽 이름 칸이라 자리만 다르다(글자 보존).
UPDATE TBL_QPS_CHK_FORM SET SUB_NM=NULL, SUB_COLS='발생일자,관리번호,문제 발생 내용,처리 결과 보고'
 WHERE HOSP_CD='*' AND FORM_ID IN ('NUR001','NUR002');
UPDATE TBL_QPS_CHK_FORM SET SUB_NM='문제 발생시', SUB_COLS='발생일자,관리번호,문제 발생 내용,처리 결과 보고'
 WHERE HOSP_CD='*' AND FORM_ID='NUR027';
UPDATE TBL_QPS_CHK_FORM SET SUB_NM='문제 발생 시', SUB_COLS='발생 일시,문제 사항,조치 사항'
 WHERE HOSP_CD='*' AND FORM_ID='NUR025';
UPDATE TBL_QPS_CHK_FORM SET SUB_NM='근무시간별 업무사항', SUB_COLS='시 간,주 간,확 인'
 WHERE HOSP_CD='*' AND FORM_ID='NUR065';
UPDATE TBL_QPS_CHK_FORM SET SUB_NM='원격경보장치 경보조치사항', SUB_COLS='경보일자,원인,조치결과,확인자'
 WHERE HOSP_CD='*' AND FORM_ID='FAC004';

SELECT FORM_ID, SUB_NM, SUB_COLS FROM TBL_QPS_CHK_FORM
 WHERE HOSP_CD='*' AND SUB_COLS IS NOT NULL ORDER BY FORM_ID;
