-- ═══════════════════════════════════════════════════════════════════════════
-- 회의록 — **소방안전관리위원회의 하단 조치표** 4칸 (2026-08-12)
--
-- ★★이 파일은 **새 WAR 를 올리기 전에** 실행한다. (더하기만 하는 ALTER · 전부 NULL 허용)
--
-- ★왜 — 위원회 회의록은 **화면 하나**로 간다(`TBL_QPS_MINUTES` + `FORM_GB`).
--   약사(약국 판정 §3-2)·영양관리(영양 판정 §1-4) 회의록은 우리 화면과 **판박이**라
--   ***코드값 하나와 사이드바 링크 하나면 끝난다.***
--   그런데 **소방안전관리위원회 회의록**[cap186]에만 회의내용 아래에 표가 하나 더 있다 :
--
--       | 회의구분 | 조치책임부서 | 조치기한 | 사 업 비 |
--       |          |              |          |          |   ← **한 줄뿐이다**
--
--   시설 판정 §5 가 「`TBL_QPS_MINUTES` 에 그 칸이 있는지 확인해야 한다. 없으면
--   `FORM_GB` 추가만으로는 안 된다」고 미뤄 둔 자리 — **확인 결과 없었다.** 그래서 만든다.
--
-- ★한 줄뿐이라 **자식 표를 만들지 않는다.** 칸 넷을 본문에 붙인다 —
--   ***여러 줄이었으면 표를 따로 뒀을 것이다.*** (원본이 한 줄이면 우리도 한 줄이다)
--
-- ⚠**`ACT_GB` 는 위쪽 `MEET_GB` 와 다른 칸이다.**
--   · `MEET_GB` = 머리의 체크박스 「정례회의(년1회) / 임시회의」
--   · `ACT_GB`  = 하단 표 첫 칸. ***원본이 이것도 「회의구분」이라 불러 이름이 겹친다***
--     (`조치사항`·`안건`의 오기로 보이지만 ***고치지 않는다*** — 원본 글자를 화면에 그대로 쓴다)
--   ⇒ 둘을 같은 칸으로 합치면 안 된다. 머리 체크와 표 값이 서로를 덮어쓴다.
--
-- ★이 표는 **`FORM_GB='S'`(소방안전관리) 일 때만** 화면에 나온다 —
--   다른 위원회 원본에는 없는 표다. ***원본에 없던 칸을 만들지 않는다***(시드에서 지켜 온 규칙 그대로).
--
-- ★함께 바뀐 코드 : Qps_SQL.xml(selectMinutes·saveMinutes) · QpsController.minutesSave ·
--   qpsMinutes.jsp(위원회 3값 추가 · 조치표 · 인쇄) · sidebar.jsp(링크 3개)
-- ═══════════════════════════════════════════════════════════════════════════

ALTER TABLE TBL_QPS_MINUTES
  ADD COLUMN ACT_GB   VARCHAR(100) NULL COMMENT "하단 조치표 '회의구분'(원본 글자 그대로. 머리의 MEET_GB 와 다른 칸)" AFTER DECISION,
  ADD COLUMN ACT_DEPT VARCHAR(100) NULL COMMENT '하단 조치표 조치책임부서' AFTER ACT_GB,
  ADD COLUMN ACT_DUE  VARCHAR(50)  NULL COMMENT '하단 조치표 조치기한(자유글 — 원본이 날짜 형식을 안 박았다)' AFTER ACT_DEPT,
  ADD COLUMN ACT_COST VARCHAR(50)  NULL COMMENT '하단 조치표 사업비(자유글 — 단위·통화가 원본에 없다)' AFTER ACT_DUE;

-- ── 확인 ────────────────────────────────────────────────────────────────────
SELECT COLUMN_NAME, COLUMN_TYPE, IS_NULLABLE FROM INFORMATION_SCHEMA.COLUMNS
 WHERE TABLE_SCHEMA='WNN' AND TABLE_NAME='TBL_QPS_MINUTES'
   AND COLUMN_NAME IN ('MEET_GB','DECISION','ACT_GB','ACT_DEPT','ACT_DUE','ACT_COST')
 ORDER BY ORDINAL_POSITION;
-- 지금 쓰는 위원회 구분 — 새 값 P·N·S 는 아직 0 이어야 정상이다
SELECT FORM_GB, COUNT(*) AS n FROM TBL_QPS_MINUTES WHERE USE_YN='Y' GROUP BY FORM_GB ORDER BY FORM_GB;
