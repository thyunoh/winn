-- ═══════════════════════════════════════════════════════════════════════════
-- 점검표 엔진 — **문서가 정하는 행 묶음** `ROW_SRC` (2026-08-12)
--   = 판정 문서가 `EQUIP_MONTH` 라고 부르던 것. ***축을 만들지 않고 조각 하나로 푼다.***
--
-- ★★이 파일은 **새 WAR 를 올리기 전에** 실행한다. (더하기만 하는 ALTER)
--
-- ★근거 3종 — 기준(3종)을 넘겼다
--   | 서식 | 부서 | 모양 |
--   |---|---|---|
--   | 소화기 관리대장(연단위)          | 약국·시설 | 소화기 자유행 × 1~12월 |
--   | 월별비치의약품보관상태점검기록부  | 약국 | 의약품 자유행 × 1~12월 |
--   | **응급 약품 점검 기록부**        | 약국 | 약품 자유행 × **하위 3항목** × 1~12월 |
--
-- ★★***그런데 새 축이 아니다.*** 응급 약품 점검 기록부를 뜯어 보면 :
--     행 = 약품(**문서가 정한다**) × 수량·유효기간·파손유무(**서식이 정한다**)
--     열 = 1~12월                                        → `ITEM_MONTH` 에 이미 있다
--     하위 3항목                                          → **행 그룹**(GRP_NM)에 이미 있다
--   ⇒ ***없는 것은 「행 묶음의 이름을 문서가 정한다」 하나뿐이다.***
--     그 장치는 이미 두 번 만들었다 — `TBL_QPS_CHK_ROW`(기기명) · `TBL_QPS_CHK_COL`(열 이름).
--     ***세 번째로 같은 것을 뒤집어 쓴다.*** (순서 8 이 그랬듯 값싸다)
--
-- ★값
--     ROW_SRC : 행 묶음을 누가 정하나. NULL·'F' = 서식(`ITEM.GRP_NM`, 지금 그대로)
--                                      'D'      = **문서**(`TBL_QPS_CHK_ROW`)
--   · 몇 묶음을 깔지는 `EQUIP_CNT` 가 정한다.
--     ⚠이 칸은 이제 축마다 뜻이 넷이다 — EQUIP_DAY=기기 행 수 · LIST=기본 행 수 ·
--       ITEM_COL+COL_SRC='D'=기본 열 수 · 여기서는 **기본 묶음 수**.
--       ***화면 라벨을 축에 맞춰 바꿔 주지 않으면 아무도 못 찾는다.***
--
-- ★★행 번호는 **이미 있는 규칙을 그대로 쓴다** — `묶음 b 의 s 번째 항목 = b*1000 + s`.
--   `LIST` 의 행 블록과 **똑같은 셈법**이다. 한 서식이 둘을 동시에 쓸 일이 없으므로 겹치지 않는다.
--   ⇒ 예약 번호 표에 줄을 더하지 않는다. ***규칙이 하나면 기억할 것도 하나다.***
--   · 묶음 이름은 `TBL_QPS_CHK_ROW.ROW_NO = b`(묶음 번호) 에 담는다.
--
-- ⚠**항목이 행인 세 축만**(`ITEM_DAY`·`ITEM_MONTH`·`ITEM_COL`) — 앞/뒤 열과 같은 범위다.
--   `DAY_ITEM`·`LIST` 는 항목이 열이고, `EQUIP_DAY` 는 행이 이미 문서 것이다.
-- ═══════════════════════════════════════════════════════════════════════════

ALTER TABLE TBL_QPS_CHK_FORM
  ADD COLUMN ROW_SRC CHAR(1) NULL
      COMMENT "행 묶음을 누가 정하나. NULL·'F'=서식(GRP_NM) / 'D'=문서(TBL_QPS_CHK_ROW)"
      AFTER ROW_BLKS;

-- ── 확인 ────────────────────────────────────────────────────────────────────
SELECT COLUMN_NAME, COLUMN_TYPE, COLUMN_COMMENT FROM INFORMATION_SCHEMA.COLUMNS
 WHERE TABLE_SCHEMA='WNN' AND TABLE_NAME='TBL_QPS_CHK_FORM'
   AND COLUMN_NAME IN ('ROW_BLKS','ROW_SRC','COL_SRC')
 ORDER BY ORDINAL_POSITION;
SELECT AXIS_GB, IFNULL(ROW_SRC,'-') AS ROW_SRC, COUNT(*) AS cnt
  FROM TBL_QPS_CHK_FORM GROUP BY AXIS_GB, ROW_SRC ORDER BY AXIS_GB;
