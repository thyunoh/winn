-- ═══════════════════════════════════════════════════════════════════════════
-- 점검표 엔진 v3 — **항목 앞/뒤 열** : 격자 옆에 붙는 칸 (2026-08-12, v3 순서 7)
--
-- ★★이 파일은 **새 WAR 를 올리기 전에** 실행한다. (더하기만 하는 ALTER)
--
-- ★근거 — 네 부서에서 앞 7 · 뒤 3
--   | 서식 | 자리 | 칸 |
--   |---|---|---|
--   | 청소계획표 (영양)             | 앞 | 청소방법 |
--   | 연간시설물안전관리계획 (시설)  | 앞·뒤 | 항목 설명 / **예산** |
--   | 연간소방안전관리계획 (시설)    | 앞·뒤 | 항목 설명 / **예산** |
--   | 소화기 관리대장 (약국·시설)    | 앞 | 설치 위치 · 종류 |
--   | U.P.S 점검 일지 (시설)        | 뒤 | **조치사항** |
--   | 구급차 점검표 (간호)           | 앞 | 수량 |
--   | 외래 비치약품 (간호)           | 앞 | 3칸 |
--   | 고위험군 체위 변경표 (간호)    | 앞 | Su / Rt / Lt |
--
-- ★★***그런데 둘로 갈린다. 뭉치면 안 된다.***
--
--   ⓐ **항목마다 늘 같은 글** — 청소방법 · 항목 설명 · 설치 위치 · 종류
--      달이 바뀌어도 같은 값이다. 문서가 적는 칸으로 만들면 ***병원이 매달 다시 친다.***
--      ⇒ **항목의 속성**이다 : `TBL_QPS_CHK_ITEM.DESC_TXT`
--        그 열의 머리글 이름은 서식이 정한다 : `TBL_QPS_CHK_FORM.DESC_NM`
--        (`DESC_NM` 이 비면 그 열은 아예 없다 — 지금까지의 서식이 그대로 그려진다.)
--
--   ⓑ **문서가 적는 값** — 예산 · 조치사항 · 수량 · Su/Rt/Lt
--      해마다·달마다 다르다. ⇒ 값은 `TBL_QPS_CHK_VAL` 에, 열 이름은 서식에 :
--        `PRE_COLS`  격자 **앞**에 붙는 열들 (쉼표)
--        `POST_COLS` 격자 **뒤**에 붙는 열들 (쉼표)
--
-- ★★열 번호를 **1000 단위로 띄운다** — 행 블록과 같은 규칙이다(2026-08-12).
--     앞 열 j → `COL_NO = 1000 + j`      뒤 열 j → `COL_NO = 2000 + j`
--   ⚠***일(1~31)·월(1~12) 뒤에 이어 붙이면 안 된다.*** 2월(28칸)과 3월(31칸)의
--     「29번 열」이 서로 다른 것을 뜻하게 되어 **달을 바꾸는 순간 값이 옆으로 옮겨 간다.**
--     띄워 두면 격자 칸 수가 달라져도 앞/뒤 열은 제자리다.
--   · 예약 900(점검자 사인)과 겹치지 않는다.
--
-- ⚠**앞/뒤 열은 항목이 행인 세 축만** — `ITEM_DAY`·`ITEM_MONTH`·`ITEM_COL`.
--   · `DAY_ITEM`·`LIST` 는 항목이 **열**이라, 칸이 필요하면 항목을 하나 더 넣으면 된다.
--   · `EQUIP_DAY` 는 행이 항목이 아니라 **기기**다 — 항목의 설명을 걸 자리가 없다.
--     기기별 규격 칸은 ***실물 근거가 없어 열지 않았다.*** (근거가 나오면 그때 넓힌다)
-- ═══════════════════════════════════════════════════════════════════════════

ALTER TABLE TBL_QPS_CHK_FORM
  ADD COLUMN DESC_NM VARCHAR(60) NULL
      COMMENT "항목 설명 열의 머리글(예 '청소방법','설치 위치'). 비면 그 열 없음. 값은 ITEM.DESC_TXT"
      AFTER ROW_BLKS,
  ADD COLUMN PRE_COLS VARCHAR(300) NULL
      COMMENT '격자 앞에 붙는 입력 열 이름(쉼표). 값은 CHK_VAL 의 COL_NO=1000+j'
      AFTER DESC_NM,
  ADD COLUMN POST_COLS VARCHAR(300) NULL
      COMMENT '격자 뒤에 붙는 입력 열 이름(쉼표). 값은 CHK_VAL 의 COL_NO=2000+j'
      AFTER PRE_COLS;

ALTER TABLE TBL_QPS_CHK_ITEM
  ADD COLUMN DESC_TXT VARCHAR(300) NULL
      COMMENT "항목마다 늘 같은 설명(청소방법·설치 위치 등). 머리글은 FORM.DESC_NM"
      AFTER GRP_NM;

-- ── 확인 ────────────────────────────────────────────────────────────────────
SELECT COLUMN_NAME, COLUMN_TYPE FROM INFORMATION_SCHEMA.COLUMNS
 WHERE TABLE_SCHEMA='WNN' AND TABLE_NAME='TBL_QPS_CHK_FORM'
   AND COLUMN_NAME IN ('ROW_BLKS','DESC_NM','PRE_COLS','POST_COLS')
 ORDER BY ORDINAL_POSITION;
SELECT COLUMN_NAME, COLUMN_TYPE FROM INFORMATION_SCHEMA.COLUMNS
 WHERE TABLE_SCHEMA='WNN' AND TABLE_NAME='TBL_QPS_CHK_ITEM'
   AND COLUMN_NAME IN ('GRP_NM','DESC_TXT','INPUT_GB')
 ORDER BY ORDINAL_POSITION;
-- ★이미 쌓인 값 중 1000 이상인 열 번호가 있으면 안 된다(있으면 예약 규칙이 깨진 것)
SELECT COUNT(*) AS 예약열_충돌 FROM TBL_QPS_CHK_VAL WHERE COL_NO >= 1000;
