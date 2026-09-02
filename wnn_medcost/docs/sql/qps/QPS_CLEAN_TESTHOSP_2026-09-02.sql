-- ═══════════════════════════════════════════════════════════════════════════
-- 검증용 가짜병원(99999998) 잔재 정리 — 2026-09-02 밤 운영 조회로 찾음
--   ✅**2026-09-02 밤 사용자 실행 완료** — 운영 확인 : QPS 표 71개 전부 잔재 0 (서식 315 · 공용 사용세트 314 그대로). 아래 DELETE 는 기록용으로 남긴다.
--   08-15 권한·격리 검증 때 만든 가짜병원 자료를 「전부 삭제」했다고 적었으나, 문서·값만 지웠고 아래가 남아 있다 :
--     TBL_QPS_CHK_FORM 5 (서식 복제) · TBL_QPS_CHK_ITEM 90 · TBL_QPS_CHK_USE 311 (사용 서식 세트) · TBL_QPS_MINUTES 1 · TBL_QPS_SECLOG 1
--   병원 코드가 달라 실동작엔 무해하다(모든 조회가 HOSP_CD 로 거른다). 다만 감사·집계 SQL 에 섞여 나온다.
--   ⚠지우기 전 확인 : 이 코드가 진짜 병원이 아닌지(TBL_HOSP… 에 없음) — 아래 첫 SELECT 로 본다.
-- ═══════════════════════════════════════════════════════════════════════════

-- 0. 확인 — 병원 마스터에 없어야 한다(0행)
SELECT COUNT(*) AS 병원마스터_행 FROM TBL_HOSP_MST WHERE HOSP_CD = '99999998';

-- 1. 잔재 수 (지우기 전)
SELECT 'CHK_FORM' t, COUNT(*) n FROM TBL_QPS_CHK_FORM  WHERE HOSP_CD='99999998'
UNION ALL SELECT 'CHK_ITEM', COUNT(*) FROM TBL_QPS_CHK_ITEM  WHERE HOSP_CD='99999998'
UNION ALL SELECT 'CHK_USE',  COUNT(*) FROM TBL_QPS_CHK_USE   WHERE HOSP_CD='99999998'
UNION ALL SELECT 'MINUTES',  COUNT(*) FROM TBL_QPS_MINUTES   WHERE HOSP_CD='99999998'
UNION ALL SELECT 'SECLOG',   COUNT(*) FROM TBL_QPS_SECLOG    WHERE HOSP_CD='99999998';

-- 2. 지우기 (실행할 때 주석을 푼다)
-- DELETE FROM TBL_QPS_CHK_ITEM WHERE HOSP_CD='99999998';
-- DELETE FROM TBL_QPS_CHK_FORM WHERE HOSP_CD='99999998';
-- DELETE FROM TBL_QPS_CHK_USE  WHERE HOSP_CD='99999998';
-- DELETE FROM TBL_QPS_MINUTES  WHERE HOSP_CD='99999998';
-- DELETE FROM TBL_QPS_SECLOG   WHERE HOSP_CD='99999998';

-- 3. 확인 — 전부 0
-- (1 을 다시 돌린다)
