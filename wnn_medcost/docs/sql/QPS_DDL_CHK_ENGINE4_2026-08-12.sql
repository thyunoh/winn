-- ═══════════════════════════════════════════════════════════════════════════
-- 점검표 엔진 — 시설 판독이 확정한 숙제 4건 (2026-08-12 밤)
--
-- ★★이 파일은 **새 WAR(클래스·매퍼)를 올리기 전에** 실행한다.
--   더하기만 하는 ALTER 라 지금 돌아가는 옛 WAR 에는 영향이 없다 —
--   그러나 새 매퍼는 이 컬럼들을 SELECT 하므로, 안 돌리고 WAR 만 올리면
--   「Unknown column」 으로 **서식 화면이 통째로 죽는다**(COL_NMS 때 겪은 그대로).
-- ★로컬·운영이 **같은 DB**(WNN)를 본다 — 한 번 돌리면 둘 다 끝난다.
--
-- 근거(전부 3종 이상, 시설 판독 문서 「엔진 숙제」 표):
--   ① ITEM.BLK_NM    — 블록 두 단계(가로 띠 + 세로 묶음).
--        혼합형 공기조화설비(FAC025) · 시설물정기점검 2종 · 세탁물관리 = 4종.
--        띠는 항목이 이어 가진 BLK_NM 으로 그린다. GRP_NM(세로 칸)은 그대로 남는다.
--        ⚠기존 ROW_BLK_GB='B'(GRP_NM 을 띠로) · ROW_BLKS(LIST 전용)는 그대로 둔다 — 옛 서식 불변.
--   ② ITEM.SPAN_TXT + FORM.SPAN_ALL_YN — 격자를 대신하는 「고정 띠」.
--        연간 시설물계획(FAC003) · 연간 소방계획(FAC026) · 소방시설 월 점검표(FAC027) = 3종.
--        값이 있으면 그 행의 격자가 입력칸이 아니라 그 글 한 칸이 된다 —
--        ***「매월 1회 실시」라고 못 박은 것을 병원이 매달 O 찍는 칸으로 바꾸면 뜻이 바뀐다.***
--        SPAN_ALL_YN='Y' 면 띠가 뒤 칸(POST_COLS)까지 덮는다(FAC027만 'Y' — 근거가 정확히 둘로 갈렸다).
--   ③ FORM.PRD_HEAD_YN·PRD_HEAD_NM — 기간 열마다 **문서가 값을 적는** 머리글 한 줄.
--        CCTV(FAC029) · 가스보일러(FAC030)의 주차 밑 「-」 칸, 소화기 연대장(FAC034)의 월별 점검자 = 3종.
--        값은 셀로 저장한다 — **예약 행 890**(사인 900 바로 앞). 서식이 정하는 것은 켜기와 줄 이름뿐.
--        ⚠ITEM_DAY·ITEM_MONTH 만(서버가 막는다) — EQUIP_DAY 는 근거가 없고 allCheck 정규화가 값을 깨뜨린다.
--   ④ FORM.NOTE_NM — 표 아래 칸(특이사항)의 이름을 서식이 정한다.
--        FAC027(조치사항) · FAC032(특이사항 및 조치사항) · FAC037(※ 조치가 필요한 사항) ·
--        FAC038(기타 이상내용) = 4종. 비면 지금까지처럼 「특이사항」.
--
-- ★함께 바뀐 코드(이 DDL 뒤에 WAR 재빌드·재기동해야 화면에 나타난다):
--   Qps_SQL.xml(selectChkForm·selectChkItems·saveChkForm·insertChkItems·selectChkExtract)
--   QpsController.chkFormSave · QpsServiceImpl.copyChkForm(복제 누락 방지 줄)
--   qpsChk.jsp(renderGrid·특이사항 제목·인쇄) · qpsChkForm.jsp(서식 관리 UI·미리보기·시드 SQL)
-- ═══════════════════════════════════════════════════════════════════════════

ALTER TABLE TBL_QPS_CHK_FORM
  ADD COLUMN SPAN_ALL_YN CHAR(1)     NOT NULL DEFAULT 'N'
      COMMENT "고정 띠(ITEM.SPAN_TXT)가 뒤 칸(POST_COLS)까지 덮나. 소방시설 월 점검표만 'Y'"
      AFTER POST_COLS,
  ADD COLUMN PRD_HEAD_YN CHAR(1)     NOT NULL DEFAULT 'N'
      COMMENT "기간 열마다 문서가 적는 머리글 한 줄(예약 행 890). ITEM_DAY·ITEM_MONTH 만"
      AFTER SPAN_ALL_YN,
  ADD COLUMN PRD_HEAD_NM VARCHAR(60)     NULL
      COMMENT "그 줄의 이름(예 '점검자'). 비면 이름 없는 칸(CCTV 의 '-')"
      AFTER PRD_HEAD_YN,
  ADD COLUMN NOTE_NM     VARCHAR(60)     NULL
      COMMENT "표 아래 칸의 이름(조치사항·기타 이상내용). 비면 '특이사항'"
      AFTER PRD_HEAD_NM;

ALTER TABLE TBL_QPS_CHK_ITEM
  ADD COLUMN BLK_NM   VARCHAR(100) NULL
      COMMENT "블록(가로 띠) 이름 — 묶음(GRP_NM) 위의 한 단. 이어지는 같은 이름이 한 띠. 항목이 행인 축만"
      AFTER GRP_NM,
  ADD COLUMN SPAN_TXT VARCHAR(100) NULL
      COMMENT "격자를 대신하는 고정 문구('매월 1회 실시'). 값이 있으면 그 행은 입력 불가"
      AFTER DESC_TXT;

-- ── 확인 ────────────────────────────────────────────────────────────────────
SELECT COLUMN_NAME, COLUMN_TYPE, COLUMN_DEFAULT FROM INFORMATION_SCHEMA.COLUMNS
 WHERE TABLE_SCHEMA='WNN' AND TABLE_NAME='TBL_QPS_CHK_FORM'
   AND COLUMN_NAME IN ('SPAN_ALL_YN','PRD_HEAD_YN','PRD_HEAD_NM','NOTE_NM')
 ORDER BY ORDINAL_POSITION;
SELECT COLUMN_NAME, COLUMN_TYPE FROM INFORMATION_SCHEMA.COLUMNS
 WHERE TABLE_SCHEMA='WNN' AND TABLE_NAME='TBL_QPS_CHK_ITEM'
   AND COLUMN_NAME IN ('BLK_NM','SPAN_TXT')
 ORDER BY ORDINAL_POSITION;
