-- ═══════════════════════════════════════════════════════════════════════════
-- 점검표 엔진 v3 — 상단 자유칸을 4 → 8 로 (2026-08-12)
--
-- ★★이 파일은 **새 WAR 를 올리기 전에** 실행한다.
--   새 코드의 문서 조회가 HEAD5~HEAD8 을 읽으므로, 컬럼이 없으면
--   「Unknown column 'HEAD5'」 로 **작성 화면이 통째로 죽는다.**
--   순서 : ① 이 SQL  ② WAR 교체  ③ 톰캣 재기동
--
-- ★왜 늘리나 — ***네 부서 캡처에서 9종이 오직 이 칸 때문에 밀려났다.***
--   ⚠막힌 것이 표가 아니라 **상단 칸**이었다. 표는 전부 엔진으로 그려진다.
--
--   | 서식 | 필요 칸 | 가운데 표 |
--   |---|---|---|
--   | 회수확인서 [별지 제64호] (약국)      | 6 | 회수제품 명세 = LIST |
--   | 지참약 식별 의뢰서 및 확인서 (약국)  | 7 | 의약품 목록 = LIST |
--   | Allergy 환자 내역 (약국)             | 6 | (표 없음) |
--   | 냉장고온도관리기록지 (약국)          | 8 | DAY_ITEM + 열 묶음 — ***순수 점검 격자인데 이것만 걸렸다*** |
--   | 안전 교육 일지 (영양)                | 7 | 참석자 명단 = LIST |
--   | 위생 교육 일지 (영양)                | 7 | 〃 (안전 교육 일지와 글자 하나 다르지 않다) |
--   | 일상점검일지-냉각탑 (시설)           | 6 | 상단 3 + 하단 3(청소일자·레지오넬라·약품투입) |
--   | 소방안전관리자 업무 수행 기록표 (시설)| 9 | ITEM_COL |
--   | 지참약 마약 관리대장 (간호/병동)     | 5 | LIST |
--   | 신규직원/직원교육 일지 (간호/병동)   | 7 | 서명 명단 = LIST |
--
--   ***★기준(3종)의 세 배다. 그리고 네 부서 전부에서 나왔다.***
--
-- ⚠**「칸을 8개까지 늘린다」가 「서식 전부를 상단 칸으로 푼다」는 뜻은 아니다.**
--   회수확인서·지참약 의뢰서처럼 **칸 위치까지 원본을 따라가야 하는 법정·의뢰 서식**은
--   칸이 들어가도 여전히 개별 화면이다. 상단 칸은 **줄지어 늘어놓는 것**밖에 못 한다.
--
-- ★격자·추출·인쇄는 손대지 않는다. 더하기만 하는 ALTER 라 기존 문서는 하나도 안 바뀐다.
-- ═══════════════════════════════════════════════════════════════════════════

-- ── 상단 자유칸 4칸 추가 ────────────────────────────────────────────────────
-- ★두 번 돌리면 Duplicate column name 으로 실패한다. 있는지 먼저 보려면 :
--   SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS
--    WHERE TABLE_SCHEMA='WNN' AND TABLE_NAME='TBL_QPS_CHK_DOC' AND COLUMN_NAME LIKE 'HEAD%';

ALTER TABLE TBL_QPS_CHK_DOC
  ADD COLUMN HEAD5 VARCHAR(200) NULL COMMENT '상단 자유칸 5' AFTER HEAD4,
  ADD COLUMN HEAD6 VARCHAR(200) NULL COMMENT '상단 자유칸 6' AFTER HEAD5,
  ADD COLUMN HEAD7 VARCHAR(200) NULL COMMENT '상단 자유칸 7' AFTER HEAD6,
  ADD COLUMN HEAD8 VARCHAR(200) NULL COMMENT '상단 자유칸 8' AFTER HEAD7;

-- ── 칸 이름 목록도 넓힌다 ───────────────────────────────────────────────────
-- HEAD_NMS 는 쉼표로 이어 붙인 칸 이름이다. 4개일 때 300 이면 넉넉했지만
-- 8개가 되면 「취급자 상호,취급자 소재지,취급자 성명,전자우편주소,전화번호,팩스번호,…」 처럼 길어진다.
ALTER TABLE TBL_QPS_CHK_FORM
  MODIFY COLUMN HEAD_NMS VARCHAR(600) NULL
    COMMENT '상단 자유칸 이름들(쉼표) 최대 8개 — 예 장비명,모델명,사용부서,점검주기';

-- ── 확인 ────────────────────────────────────────────────────────────────────
SELECT COLUMN_NAME, COLUMN_TYPE FROM INFORMATION_SCHEMA.COLUMNS
 WHERE TABLE_SCHEMA='WNN' AND TABLE_NAME='TBL_QPS_CHK_DOC' AND COLUMN_NAME LIKE 'HEAD%'
 ORDER BY ORDINAL_POSITION;
