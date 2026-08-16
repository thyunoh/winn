-- =====================================================================
-- 회의록에 QI 구분 + 간사 칸 (2026-08-11)
--
--   원본 「질향상활동(QI) 회의록」 실물 6장(낙상 기본·1~5차) 대조 결과 —
--   ***차수는 문서 이름일 뿐이고 서식은 하나다.*** 1~5차가 전부 같은 3면 구성이었다.
--     1p 결재란 + 회의명|장소 / 일시|간사 / 의안 / 회의내용 / 의결사항
--     2p 참석자(구분|직책|성명|서명 × 2벌)   3p 첨부
--   ★1차 문서의 회의내용 칸에 팀구성표·PDCA 표가 들어 있었지만 그건 **그 문서에 타이핑한
--     내용물**이지 서식 필드가 아니다(2~5차엔 없다). 서식을 늘릴 이유가 없다.
--
--   ⇒ 문서에 이미 확정된 방침 그대로 **서식 1호(회의록) 하나로 흡수**한다.
--     「규정입안회의록·첫 회의록·임시회의록은 별도 서식이 아니다 — 회의명으로 구분한다」
--     FORM_GB 에 'J'(QI 활동)를 더한다 : Q=질향상위원회 / I=감염관리위원회 / J=QI 활동
--     주제·차수는 회의명에 적는다(예: "낙상 3차").
--
--   ★간사(CLERK_NM)만 새 칸이다 — 우리 회의록엔 없었다.
--     참석자 표의 「서명」 칸은 인쇄물에서 빈칸으로 낸다(종이 결재와 같은 방식, 저장 안 함).
--
--   재실행 안전(컬럼이 이미 있으면 건너뛴다).
-- =====================================================================

SET @c := (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
            WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='TBL_QPS_MINUTES' AND COLUMN_NAME='CLERK_NM');
SET @s := IF(@c=0,
  'ALTER TABLE TBL_QPS_MINUTES ADD COLUMN CLERK_NM VARCHAR(50) NULL COMMENT ''간사'' AFTER PLACE',
  'DO 0');
PREPARE st FROM @s; EXECUTE st; DEALLOCATE PREPARE st;

SELECT '확인' AS chk, COLUMN_NAME, COLUMN_TYPE, COLUMN_COMMENT
  FROM INFORMATION_SCHEMA.COLUMNS
 WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='TBL_QPS_MINUTES'
   AND COLUMN_NAME IN ('FORM_GB','CLERK_NM');
