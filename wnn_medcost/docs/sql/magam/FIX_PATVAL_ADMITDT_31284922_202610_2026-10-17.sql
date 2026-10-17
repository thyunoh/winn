-- =====================================================================================
-- ⏸ 대기 — 병원(인천사랑요양병원 31284922)이 정정을 요청하면 그때 실행 (2026-10-17 작성)
-- 곽삼덕(2905252031511) 2026-10 환자평가표 입원일자 정정 : 20260209 → 20260907
-- ⛔실행은 사용자가 운영 DB 에서 직접 (①→②→③→④ 차례로, 각 단계 결과 확인)
--
-- 배경 : 10월 평가표(요양개시 20261001 · 작성 20261007 · 정기평가) 입원일자가 20260209 로 올라왔다.
--        병원 입퇴원 기록(TBL_IPWON_INFO 202609·202610)은 둘 다 입원 2026-09-07, 9월 평가표(초기평가)도 20260907.
--        입원일자가 달라 PATIENT_CATHETER_CHECK 가 9월 평가표를 직전으로 못 찾고 시작일을 전월 1일(09-01)로 잡아
--        09-01~09-20 = 19일 → 「14일 초과」로 잘못 집계됐다. 정정하면 09-14~09-20(6일) · 10-04~10-07(3일) → 해당 아님.
-- ⚠ 입원일자는 기본키(HOSP_CD+CLFORM_VER+PAT_ID+ADMIT_DT+MED_START)의 일부다 — 정정 뒤 병원이 «틀린 파일»을 다시 올리면
--   20260209 행이 따로 되살아나 두 줄이 된다. 병원 프로그램 쪽 입원일자도 함께 고쳐 달라고 안내할 것.
-- ⚠ 정정 뒤 인천사랑 10월 「월 자료생성」을 다시 돌려야 지표(TBL_PAT_INDI)에 반영된다(목록의 「14일초과」 표시는 바로 바뀐다).
-- 딸린 자료 없음 : PAT_ID+ADMIT_DT 를 함께 가진 표는 TBL_PATVAL_MST 하나뿐(2026-10-17 information_schema 확인).
-- =====================================================================================

-- ① 확인 : 정정 대상 1행 + 바꿀 키가 비어 있는지(dup = 0)
SELECT HOSP_CD, CLFORM_VER, PAT_ID, PAT_NM, ADMIT_DT, MED_START, EVAL_TYPE, DOC_DT, CHUNGSEQ,
       PATIENT_CATHETER_CHECK(HOSP_CD, CLFORM_VER, PAT_ID, ADMIT_DT, MED_START, EVAL_TYPE, INDWELL_CATH, PAT_CLASS) AS chk   -- 지금 'Y'
  FROM TBL_PATVAL_MST
 WHERE HOSP_CD = '31284922' AND CLFORM_VER = '092' AND PAT_ID = '2905252031511'
   AND ADMIT_DT = '20260209' AND MED_START = '20261001';

SELECT COUNT(*) AS dup
  FROM TBL_PATVAL_MST
 WHERE HOSP_CD = '31284922' AND CLFORM_VER = '092' AND PAT_ID = '2905252031511'
   AND ADMIT_DT = '20260907' AND MED_START = '20261001';          -- 0 이어야 한다

-- ② 백업 (되돌리기용) — LIKE + INSERT
CREATE TABLE TBL_PATVAL_MST_BAK_20261017_KSD LIKE TBL_PATVAL_MST;
INSERT INTO TBL_PATVAL_MST_BAK_20261017_KSD
SELECT * FROM TBL_PATVAL_MST
 WHERE HOSP_CD = '31284922' AND CLFORM_VER = '092' AND PAT_ID = '2905252031511'
   AND ADMIT_DT = '20260209' AND MED_START = '20261001';

SELECT COUNT(*) AS backup_rows FROM TBL_PATVAL_MST_BAK_20261017_KSD;   -- 1 이어야 한다

-- ③ 정정 — 기본키 5개 전부 + 작업-KEY 로 묶는다. 영향 행 수 1 확인.
UPDATE TBL_PATVAL_MST
   SET ADMIT_DT = '20260907'
 WHERE HOSP_CD = '31284922' AND CLFORM_VER = '092' AND PAT_ID = '2905252031511'
   AND ADMIT_DT = '20260209' AND MED_START = '20261001'
   AND CHUNGSEQ = '20261016095912';

-- ④ 결과 확인 — 10월 행 입원일자 20260907 · chk 'N' (9월 평가표와 이어져 시작일 09-14)
SELECT ADMIT_DT, MED_START, EVAL_TYPE, DOC_DT, CAT_IN_1, CAT_OUT_1, CAT_IN_2,
       PATIENT_CATHETER_CHECK(HOSP_CD, CLFORM_VER, PAT_ID, ADMIT_DT, MED_START, EVAL_TYPE, INDWELL_CATH, PAT_CLASS) AS chk
  FROM TBL_PATVAL_MST
 WHERE HOSP_CD = '31284922' AND PAT_ID = '2905252031511' AND MED_START >= '20260901'
 ORDER BY MED_START;
-- → 그다음 화면에서 인천사랑 2026-10 「월 자료생성」 재실행.

-- 되돌리기 (필요할 때만)
-- UPDATE TBL_PATVAL_MST SET ADMIT_DT = '20260209'
--  WHERE HOSP_CD = '31284922' AND CLFORM_VER = '092' AND PAT_ID = '2905252031511'
--    AND ADMIT_DT = '20260907' AND MED_START = '20261001' AND CHUNGSEQ = '20261016095912';
-- 백업 표는 확인이 끝나면 지운다 : DROP TABLE TBL_PATVAL_MST_BAK_20261017_KSD;
