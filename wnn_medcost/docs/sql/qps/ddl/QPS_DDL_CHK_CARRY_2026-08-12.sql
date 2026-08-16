-- ═══════════════════════════════════════════════════════════════════════════
-- 점검표 엔진 — **전월복사에서 가져올 열** `ITEM.CARRY_YN` (2026-08-12 밤)
--
-- ★★이 파일은 **새 WAR 를 올리기 전에** 실행한다. (더하기만 하는 ALTER)
--
-- ★왜 — ***대장(LIST)은 전월복사 없이는 못 쓴다.***
--   냉/난방기 점검표(FAC031)는 행이 **60줄**(지하 전체·201·202…식당·주방·옥상환기구)이고
--   소화기 관리 대장(FAC033)도 자산이 수십 줄이다. 자유행이라 **매달 다시 친다** —
--   원본 화면에 「전월복사」 버튼이 바로 이 서식들에 붙어 있는 이유다(판정 §3 ★②, 근거 5종).
--
-- ★★그런데 ***무엇을 가져오느냐가 이 기능의 전부다.***
--   지난달 점검 결과(O)가 남아 있으면 화면은 **「점검했다」로 보인다.** 아무도 안 한 점검이 기록이 된다.
--   ⇒ **자산 목록만** 가져오고 **점검 결과는 비운다.** 어느 열이 자산인지는 **서식이 정한다.**
--     예) 소화기 관리 대장 — 층·번호·위치/장소·종류·규격·제조일자 = `Y`
--                            점검일자·점검결과·비고                = `N`(비워서 온다)
--
-- ★값 : CARRY_YN 'Y' = 전월복사 때 이 열의 값을 가져온다 / 'N'(기본) = 비운다.
--   ⚠**`LIST`(자유행 대장) 축만 뜻이 있다.** 다른 축은 격자 칸이 「그 달의 점검 결과」뿐이라
--     가져올 자산이 없다 — 기기명(`TBL_QPS_CHK_ROW`)·열이름(`TBL_QPS_CHK_COL`)은 **이미 가져온다.**
--   ⚠기본이 'N' 이라 ***켜지 않으면 지금까지와 똑같이 동작한다.*** 옛 서식 12종은 손대지 않는다.
--
-- ★안전장치(코드) : 가져온 값은 **비어 있는 칸에만** 채운다.
--   적다 말고 [전월복사]를 눌렀을 때 이미 친 글자를 덮으면 안 된다 — 되돌릴 길이 없다.
--
-- ★함께 바뀐 코드 : Qps_SQL.xml(selectChkItems·insertChkItems) ·
--   QpsServiceImpl(saveChkForm 정규화 · selectChkPrevSeed 에 vals 추가) ·
--   qpsChk.jsp(ckPrevSeed 병합) · qpsChkForm.jsp(항목표 「전월복사」 칸 · 시드 SQL)
-- ═══════════════════════════════════════════════════════════════════════════

ALTER TABLE TBL_QPS_CHK_ITEM
  ADD COLUMN CARRY_YN CHAR(1) NOT NULL DEFAULT 'N'
      COMMENT "전월복사 때 이 열의 값을 가져오나(자산 목록). LIST 축만. 'N'=비워서 온다"
      AFTER UNIT_NM;

-- ── 확인 ────────────────────────────────────────────────────────────────────
SELECT COLUMN_NAME, COLUMN_TYPE, COLUMN_DEFAULT, IS_NULLABLE
  FROM INFORMATION_SCHEMA.COLUMNS
 WHERE TABLE_SCHEMA='WNN' AND TABLE_NAME='TBL_QPS_CHK_ITEM'
   AND COLUMN_NAME IN ('BLK_NM','SPAN_TXT','CARRY_YN')
 ORDER BY ORDINAL_POSITION;
-- 켜 둔 서식이 하나도 없어야 정상이다(이제 만들었으므로)
SELECT FORM_ID, COUNT(*) AS carry_cols
  FROM TBL_QPS_CHK_ITEM WHERE CARRY_YN='Y' GROUP BY FORM_ID;
