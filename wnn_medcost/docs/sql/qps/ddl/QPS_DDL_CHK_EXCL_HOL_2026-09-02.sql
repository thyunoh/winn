-- =====================================================================
-- 점검표 엔진 — 행 배타 체크(EXCL_YN) · 공휴일 표(TBL_QPS_HOLIDAY) — DDL (2026-09-02)
--   왜 : SUNWOO 델파이 원본 소스 대조([QPS_델파이소스대조_2026-09-02.md])에서 나온 「놓친 기능」 둘.
--        ① 행 배타 체크 — SUNWOO 175종 폼이 「같은 Hint 묶음의 체크박스는 하나만」(cxCheckBox Click 이
--           같은 Hint 의 다른 체크를 푼다). 평가표(상/중/하 · 적합/부적합 · 예/아니오)에서 한 항목에
--           O 가 둘 찍히는 것을 막는다. ⇒ 서식 옵션 EXCL_YN. 고정 열(ITEM_COL)에서만 뜻이 있다.
--        ② 공휴일 — SUNWOO t_holiday. 일괄 서명·전체 O 에서 휴일 칸을 건너뛰고 머리글에 색을 준다.
--           SUNWOO 소스에는 표 정의(T_HOLIDAY.sql)만 있고 자료는 없어 **2025~2027 공휴일을 직접 넣었다.**
--           ✅2026-09-02 웹 대조 완료 — 2025 time.is · 2026/2027 publicholidays.co.kr 와 전부 일치.
--             일부러 안 넣은 것 : 제헌절(7/17 — 국경일이지만 2008년부터 공휴일 아님) · 2027 현충일 대체휴일(현충일은 대체공휴일 대상 아님).
--             ⚠임시공휴일은 해마다 국무회의로 생긴다 — 생기면 [QPS ▸ 공통 ▸ 기준코드 ▸ 공휴일 관리]에서 넣는다.
--   더하기만 하는 DDL ⇒ 운영 선적용 안전(옛 WAR 는 EXCL_YN 을 읽지도 쓰지도 않는다).
--   코드 : Qps_SQL.xml(selectChkForm·saveChkForm·selectHolidays·saveHoliday·deleteHoliday) ·
--          QpsController(chkFormSave exclYn · holidayList/Save/Del.do) · qpsChkForm.jsp(f_exclYn) ·
--          qpsChk.jsp(배타 · 공휴일 색/제외 · [공휴일 관리] 위너넷 전용)
-- =====================================================================

-- ── ① 행 배타 체크 ─────────────────────────────────────────────────────
ALTER TABLE TBL_QPS_CHK_FORM
  ADD COLUMN EXCL_YN CHAR(1) NOT NULL DEFAULT 'N'
      COMMENT '한 줄에 O 하나(평가표). Y 면 O 를 찍을 때 그 줄의 다른 O 를 지운다. ITEM_COL 만' AFTER SPAN_ALL_YN;

-- 근거 : SUNWOO 원본 폼이 배타 체크(cxCheckBox Click 의 Hint 묶음)를 쓰는 서식 중 우리 ITEM_COL 11종
--   (docs/tools/dfm대조 compare.tsv 의 유닛 ↔ CHT/*.pas 175종 대조, 2026-09-02)
UPDATE TBL_QPS_CHK_FORM SET EXCL_YN='Y'
 WHERE HOSP_CD='*' AND AXIS_GB='ITEM_COL'
   AND FORM_ID IN ('FAC005','FAC019','FAC048','PHA023','NUR020','ADM016','INF001','INF002','CLI001','NUR069','NUT017');

-- ── ② 공휴일 ───────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS TBL_QPS_HOLIDAY (
  HOL_DT    CHAR(8)     NOT NULL COMMENT '날짜 YYYYMMDD',
  HOL_NM    VARCHAR(50) NOT NULL COMMENT '이름(설날·추석·대체공휴일 등)',
  USE_YN    CHAR(1)     NOT NULL DEFAULT 'Y',
  REG_USER  VARCHAR(50) NULL,
  REG_DTTM  DATETIME    NULL DEFAULT CURRENT_TIMESTAMP,
  UPD_USER  VARCHAR(50) NULL,
  UPD_DTTM  DATETIME    NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (HOL_DT)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
  COMMENT='공휴일(전 병원 공용) — 점검표 일괄 서명·전체 O 의 휴일 제외, 머리글 색. SUNWOO t_holiday 대응';

-- 토·일은 넣지 않는다(화면이 날짜로 안다). 두 번 돌려도 같은 결과.
INSERT INTO TBL_QPS_HOLIDAY (HOL_DT, HOL_NM, REG_USER) VALUES
 -- 2025
 ('20250101','신정','system'),('20250127','임시공휴일','system'),('20250128','설날 연휴','system'),('20250129','설날','system'),('20250130','설날 연휴','system'),
 ('20250301','삼일절','system'),('20250303','대체공휴일(삼일절)','system'),
 ('20250505','어린이날·부처님오신날','system'),('20250506','대체공휴일','system'),
 ('20250603','대통령선거일','system'),('20250606','현충일','system'),('20250815','광복절','system'),
 ('20251003','개천절','system'),('20251005','추석 연휴','system'),('20251006','추석','system'),('20251007','추석 연휴','system'),('20251008','대체공휴일(추석)','system'),
 ('20251009','한글날','system'),('20251225','성탄절','system'),
 -- 2026
 ('20260101','신정','system'),('20260216','설날 연휴','system'),('20260217','설날','system'),('20260218','설날 연휴','system'),
 ('20260301','삼일절','system'),('20260302','대체공휴일(삼일절)','system'),
 ('20260505','어린이날','system'),('20260524','부처님오신날','system'),('20260525','대체공휴일(부처님오신날)','system'),
 ('20260603','지방선거일','system'),('20260606','현충일','system'),('20260815','광복절','system'),('20260817','대체공휴일(광복절)','system'),
 ('20260924','추석 연휴','system'),('20260925','추석','system'),('20260926','추석 연휴','system'),
 ('20261003','개천절','system'),('20261005','대체공휴일(개천절)','system'),('20261009','한글날','system'),('20261225','성탄절','system'),
 -- 2027
 ('20270101','신정','system'),('20270206','설날 연휴','system'),('20270207','설날','system'),('20270208','설날 연휴','system'),('20270209','대체공휴일(설날)','system'),
 ('20270301','삼일절','system'),('20270505','어린이날','system'),('20270513','부처님오신날','system'),('20270606','현충일','system'),
 ('20270815','광복절','system'),('20270816','대체공휴일(광복절)','system'),
 ('20270914','추석 연휴','system'),('20270915','추석','system'),('20270916','추석 연휴','system'),
 ('20271003','개천절','system'),('20271004','대체공휴일(개천절)','system'),('20271009','한글날','system'),('20271011','대체공휴일(한글날)','system'),
 ('20271225','성탄절','system'),('20271227','대체공휴일(성탄절)','system')
ON DUPLICATE KEY UPDATE HOL_NM=VALUES(HOL_NM), USE_YN='Y';

SELECT COUNT(*) AS 공휴일수, MIN(HOL_DT) AS 처음, MAX(HOL_DT) AS 끝 FROM TBL_QPS_HOLIDAY WHERE USE_YN='Y';
SELECT FORM_ID, FORM_NM FROM TBL_QPS_CHK_FORM WHERE HOSP_CD='*' AND EXCL_YN='Y' ORDER BY FORM_ID;
