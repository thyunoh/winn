-- =====================================================================================
-- ⛔⛔ 실행 금지 (2026-09-15) — 사용자 확인 결과 「두 개가 맞음」: 08-01(작성 08-07)·08-07(작성 08-13) 은 둘 다 정상 평가표다.
--        옛 행이 아니므로 지우지 않는다. 업로드 목록의 「1 건(199)」 가 정확한 표시다. (파일은 판단 기록으로 남겨 둠)
-- 남서울(11282991) 김풍자(440419) 2026-08 환자평가표 중 옛 행(요양개시일 20260807) 1건 삭제
-- 작성 2026-09-15 · ⛔실행은 사용자가 운영 DB 에서 직접 (①→②→③→④ 차례로, 각 단계 결과 확인)
--
-- 배경 : 평가표 업로드 키 = HOSP_CD + CLFORM_VER + PAT_ID + ADMIT_DT + MED_START.
--        199건 파일(작업-KEY 20260829085125)의 08-07 행과 155건 파일(20260915134708)의 08-01 행이
--        요양개시일이 달라 둘 다 남았다(다솜 이태영 07-03 과 같은 경우).
--        그래서 업로드 목록에 199건 파일이 「1 건(199)」 로 보였다. 지우면 「0 건(199)」.
-- ⚠ 두 행은 작성일도 다르다(08-01 행 작성 08-07 · 08-07 행 작성 08-13). 병원이 날짜만 고친 것이 맞는지 확인하고 돌린다.
-- ⚠ 삭제 뒤 8월 적정성평가 「월 자료생성」을 다시 돌려야 지표(TBL_PAT_INDI)에 반영된다.
-- ⚠ 병원 파일에 08-07 줄이 아직 있으면 그 파일을 다시 올릴 때 이 행이 되살아난다.
-- 딸린 자료 없음 : 삭제 트리거 없음 · 평가표를 가리키는 표 없음(TBL_MYOUNG_MST 는 청구 명세서라 무관).
-- =====================================================================================

-- ① 확인 : 정확히 1행이 나와야 한다 (요양개시일 20260807 · 작업-KEY 20260829085125)
SELECT HOSP_CD, CLFORM_VER, PAT_ID, PAT_NM, ADMIT_DT, MED_START, EVAL_TYPE, DOC_DT, CHUNGSEQ
  FROM TBL_PATVAL_MST
 WHERE HOSP_CD = '11282991' AND CLFORM_VER = '092' AND PAT_ID = '4404192260132'
   AND ADMIT_DT = '20260423' AND MED_START = '20260807';

-- ② 백업 (되돌리기용) — CREATE TABLE … AS SELECT 는 GTID 설정에 따라 거부될 수 있어 LIKE + INSERT 로 한다
CREATE TABLE TBL_PATVAL_MST_BAK_20260915_KPJ LIKE TBL_PATVAL_MST;
INSERT INTO TBL_PATVAL_MST_BAK_20260915_KPJ
SELECT * FROM TBL_PATVAL_MST
 WHERE HOSP_CD = '11282991' AND CLFORM_VER = '092' AND PAT_ID = '4404192260132'
   AND ADMIT_DT = '20260423' AND MED_START = '20260807';

SELECT COUNT(*) AS backup_rows FROM TBL_PATVAL_MST_BAK_20260915_KPJ;   -- 1 이어야 한다

-- ③ 삭제 — 기본키 5개 전부 + 작업-KEY 로 묶는다(08-01 행은 건드리지 않는다). 영향 행 수 1 확인.
DELETE FROM TBL_PATVAL_MST
 WHERE HOSP_CD = '11282991' AND CLFORM_VER = '092' AND PAT_ID = '4404192260132'
   AND ADMIT_DT = '20260423' AND MED_START = '20260807'
   AND CHUNGSEQ = '20260829085125';

-- ④ 결과 확인
--    김풍자 8월 = 08-01(작업-KEY 20260915134708) 한 건만 남아야 한다
SELECT MED_START, EVAL_TYPE, DOC_DT, CHUNGSEQ
  FROM TBL_PATVAL_MST
 WHERE HOSP_CD = '11282991' AND PAT_ID = '4404192260132' AND MED_START LIKE '202608%';
--    199건 파일(20260829085125)이 가진 행 = 0 이어야 한다 (업로드 목록 「0 건(199)」)
SELECT COUNT(*) AS batch_rows FROM TBL_PATVAL_MST WHERE HOSP_CD = '11282991' AND CHUNGSEQ = '20260829085125';

-- ⑤ 되돌리기 (필요할 때만)
-- INSERT INTO TBL_PATVAL_MST SELECT * FROM TBL_PATVAL_MST_BAK_20260915_KPJ;

-- ⑥ 확인이 끝나면 백업 표 정리 (선택)
-- DROP TABLE TBL_PATVAL_MST_BAK_20260915_KPJ;
