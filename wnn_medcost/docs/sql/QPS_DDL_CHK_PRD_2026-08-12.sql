-- ═══════════════════════════════════════════════════════════════════════════
-- 점검표 엔진 v3 — 문서 단위 일반화 (2026-08-12)
--
-- ★★이 파일은 **새 WAR 를 올리기 전에** 실행한다.
--   새 코드가 PRD_GB/PRD_NO 를 읽으므로 컬럼이 없으면 작성 화면이 통째로 죽는다.
--   순서 : ① 이 SQL  ② WAR 교체  ③ 톰캣 재기동
--
-- ★왜 — ***실물에 여섯 단위가 나왔다.*** 지금은 연(IN_YEAR)+월(IN_MM) 뿐이다.
--   | 단위 | 근거 실물 |
--   |---|---|
--   | 연   | 방역 일지 · 조제 전/후 감사대장 · 응급약물 봉인 해제 대장 … |
--   | 반기 | 유해화학물질 적정 취급상태 모니터링 (시설) — `( )년 ( 하 )반기` |
--   | 분기 | 건축물 안전 점검 일지 (시설) — 3·6·9·12월 |
--   | 월   | 대부분 |
--   | 주   | 온도관리기록지 · 소독일지 3형제 · CCTV · 전기시설주간 · 세탁물관리 … (6종) |
--   | 일   | 폐기 의약품 대장 · 발전기 운전 점검일지 · 고위험 병실 순회 · 병동 순회일지 (3종+) |
--
-- ★★칸을 낱개로 늘리지 않는다 — ***주차 칸 하나를 더하면 반기·분기가 나올 때 또 더해야 한다.***
--   `PRD_GB`(주기 종류) + `PRD_NO`(그 번호) **한 쌍**이면 여섯이 다 담기고,
--   다음에 새 주기가 나와도 코드를 안 고친다.
--
-- ★IN_MM 은 그대로 쓴다. 주·일은 「연 + 월 + 번호」다 :
--     Y : IN_YEAR
--     H : IN_YEAR + PRD_NO(1~2)
--     Q : IN_YEAR + PRD_NO(1~4)
--     M : IN_YEAR + IN_MM                 ← 지금까지의 문서. **PRD_GB 를 'M' 으로 채운다**
--     W : IN_YEAR + IN_MM + PRD_NO(1~5)
--     D : IN_YEAR + IN_MM + PRD_NO(1~31)
--   ⇒ 기존 문서는 손대지 않아도 되고(기본값 'M'), 목록·추출의 연·월 조건이 그대로 산다.
-- ═══════════════════════════════════════════════════════════════════════════

-- ── 1) 작성 문서에 주기 칸 ──────────────────────────────────────────────────
ALTER TABLE TBL_QPS_CHK_DOC
  ADD COLUMN PRD_GB CHAR(1) NOT NULL DEFAULT 'M'
      COMMENT '문서 단위 Y연 H반기 Q분기 M월 W주 D일' AFTER IN_MM,
  ADD COLUMN PRD_NO INT NULL
      COMMENT '그 단위의 번호 — H:1~2 Q:1~4 W:1~5 D:1~31 (Y·M 은 안 씀)' AFTER PRD_GB;

-- ★목록·조회가 (병원,서식,연,월)로 도는데 주 단위는 같은 달에 5장이 생긴다.
--   번호가 인덱스에 없으면 5장을 다 읽어 골라야 한다.
CREATE INDEX IX_CHK_DOC_PRD ON TBL_QPS_CHK_DOC (HOSP_CD, FORM_ID, IN_YEAR, IN_MM, PRD_NO);

-- ── 2) 서식의 주기 칸을 넓힌다 ──────────────────────────────────────────────
-- 지금 PRD_GB 는 CHAR(1) 로 'M'/'Y' 만 쓰고 있다. 값만 늘리면 되므로 형 변경은 없다.
-- ★주석만 갱신해 다음 사람이 값을 안다.
ALTER TABLE TBL_QPS_CHK_FORM
  MODIFY COLUMN PRD_GB CHAR(1) NOT NULL DEFAULT 'M'
    COMMENT '문서 단위 Y연 H반기 Q분기 M월 W주 D일 — 날짜 격자축은 축이 정하고, LIST/ITEM_COL 만 고른다';

-- ── 확인 ────────────────────────────────────────────────────────────────────
SELECT COLUMN_NAME, COLUMN_TYPE, COLUMN_DEFAULT FROM INFORMATION_SCHEMA.COLUMNS
 WHERE TABLE_SCHEMA='WNN' AND TABLE_NAME='TBL_QPS_CHK_DOC'
   AND COLUMN_NAME IN ('IN_YEAR','IN_MM','PRD_GB','PRD_NO')
 ORDER BY ORDINAL_POSITION;
SELECT PRD_GB, COUNT(*) AS cnt FROM TBL_QPS_CHK_FORM GROUP BY PRD_GB;
