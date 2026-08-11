-- ═══════════════════════════════════════════════════════════════════════════
-- 점검표 — 병원별 사용 서식 (TBL_QPS_CHK_USE) · 2026-08-11
--
-- ★왜 필요한가 (사용자 지적 2026-08-11 : "병원마다 양식이 틀릴텐데")
--   표준 서식이 130종이 되면 **모든 병원에 130개를 다 보여줄 수 없다.**
--   병원마다 쓰는 것이 다르고, 안 쓰는 서식이 목록에 섞이면 못 쓴다.
--   ⇒ 「그 병원이 쓰는 서식」만 켠다.
--
-- ★이 장치 하나로 「정신 폴더 on/off」 요구도 함께 풀린다 —
--   정신과를 운영하지 않는 병원에는 그 세트를 안 켜면 된다.
--
-- ★행이 하나도 없는 병원은 **전부 보여준다**(기본 열림).
--   안 그러면 새 병원이 들어올 때마다 아무것도 안 보여 「고장났다」가 된다.
--   한 번이라도 지정하면 그때부터 지정한 것만 보인다.
-- ═══════════════════════════════════════════════════════════════════════════

CREATE TABLE IF NOT EXISTS TBL_QPS_CHK_USE (
  HOSP_CD  VARCHAR(20) NOT NULL,
  FORM_ID  VARCHAR(30) NOT NULL,
  USE_YN   CHAR(1)     NOT NULL DEFAULT 'Y',
  SORT_NO  INT         NOT NULL DEFAULT 0,
  REG_USER VARCHAR(50)     NULL,
  REG_DTTM DATETIME        NULL DEFAULT CURRENT_TIMESTAMP,
  UPD_USER VARCHAR(50)     NULL,
  UPD_DTTM DATETIME        NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (HOSP_CD, FORM_ID),
  KEY IX_CHK_USE (HOSP_CD, USE_YN)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='병원별 사용 점검표';

SELECT '사용지정' AS chk, COUNT(*) AS n FROM TBL_QPS_CHK_USE;
SELECT '지정한병원' AS chk, HOSP_CD, COUNT(*) AS n, SUM(USE_YN='Y') AS 켠것
  FROM TBL_QPS_CHK_USE GROUP BY HOSP_CD;
