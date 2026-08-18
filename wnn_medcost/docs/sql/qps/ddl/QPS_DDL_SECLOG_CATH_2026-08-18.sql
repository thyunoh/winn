-- =====================================================================
-- 격리·강박 시행일지 + 유치도뇨관 월별 기록지 — DDL (2026-08-18)
--
--   근거 : 캡처 D:\위너넷\caps\QPS_2026-08-18\ PS03 · UT05
--          판독 QPS_서식판독_신규분_2026-08-18.md §2-2 · §3-3
--
--   ★왜 이 둘을 먼저 만드나 — ***지표의 원천 자료다.***
--     · 격리·강박 시행일지 → 지표 ISOLATION/SECLUSION 의 분자·분모
--     · 유치도뇨관 월별 기록지 → 지표 UTI 의 분모(유치도뇨관 일수)
--     보고서 서식(지표분석 3쪽/4쪽)은 이 자료가 없으면 빈 표만 나온다.
--
--   ★설계 원칙 — ***기존 집계 테이블에 물린다.*** 새 분자원천을 만들지 않는다.
--     · 시행일지 저장 → TBL_QPS_MONITOR 에 월별 집계행 반영
--       (OBS_CNT = 전체 시행 건수 = 분모 · PASS_CNT = 지침준수 건수 = 분자)
--       ⇒ NUMER_SRC='MONITOR' 인 ISOLATION/SECLUSION 이 **코드 변경 없이** 그대로 돈다.
--     · 유치도뇨관 기록지 저장 → TBL_QPS_CENSUS 에 CENSUS_GB='CATHDAYS' 로 월 합계 반영
--       ⇒ 분모 마스터(M01~M12) 구조에 그대로 들어간다.
--
--   ★환자 칸은 TBL_IPWON_INFO 에서 [찾기]로 끌어온다 — QPS 는 환자를 따로 등록하지 않는다.
--     ***주민번호는 담지 않는다***(낙상·감염병환자와 같은 원칙). 성인구분만 받는다.
--
--   더하기만 하는 DDL ⇒ 운영 선적용 안전. 재실행 안전(CREATE IF NOT EXISTS).
-- =====================================================================

-- ═══ ① 격리 · 강박 시행일지 (PS03) — 병원 + 년월 1부 ═══════════════════════
--   원본 : 보고서 ▸ 정신 ▸ 격리강박 시행일지. 결재란 4칸 + 행 표 + 하단 집계 3칸.
--   ★하단 집계(격리 n건 / 강박 n건 / 합계)는 **저장하지 않는다** — 행에서 센다.
--     사람이 적는 값이 아니라 계산값이다(감염병환자의 통계 3칸과 다르다).
CREATE TABLE IF NOT EXISTS TBL_QPS_SECLOG (
  LOG_SEQ    BIGINT      NOT NULL AUTO_INCREMENT,
  HOSP_CD    VARCHAR(20) NOT NULL,
  LOG_YM     VARCHAR(6)  NOT NULL COMMENT '작성 년월(YYYYMM)',
  USE_YN     CHAR(1)     DEFAULT 'Y',
  REG_USER   VARCHAR(50) NULL,
  REG_DTTM   DATETIME    DEFAULT CURRENT_TIMESTAMP,
  UPD_USER   VARCHAR(50) NULL,
  UPD_DTTM   DATETIME    NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (LOG_SEQ),
  UNIQUE KEY UK_QPS_SECLOG (HOSP_CD, LOG_YM)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='격리·강박 시행일지(머리) — 월 1부';

CREATE TABLE IF NOT EXISTS TBL_QPS_SECLOG_ITEM (
  LOG_SEQ    BIGINT      NOT NULL,
  SORT       INT         NOT NULL COMMENT '원본 「번호」 칸',
  EXEC_DT    VARCHAR(8)  NULL COMMENT '시행일자',
  SEC_GB     VARCHAR(10) NULL COMMENT '구분 — ISOL(격리) / RSTR(강박). 하단 집계가 이 값으로 갈린다',
  ORDER_NM   VARCHAR(50) NULL COMMENT '지시자',
  WRITER_NM  VARCHAR(50) NULL COMMENT '작성자',
  PAT_NO     VARCHAR(30) NULL COMMENT '등록번호 — TBL_IPWON_INFO 에서 찾아 넣는다',
  PAT_NM     VARCHAR(50) NULL COMMENT '환자성명',
  ADULT_GB   VARCHAR(10) NULL COMMENT '성인구분 — ADULT(19세이상) / MINOR(19세미만). ★지표분석 1쪽 「19세이상/미만」 분포가 이 값이다',
  INSUR_GB   VARCHAR(20) NULL COMMENT '보험구분',
  REL_ORDER  VARCHAR(50) NULL COMMENT '주치의 / 해제지시자',
  JOIN_NM    VARCHAR(200) NULL COMMENT '참여자',
  ST_DT      VARCHAR(8)  NULL COMMENT '시작일',
  ST_TM      VARCHAR(5)  NULL COMMENT '시작시간(HH:MM)',
  ED_DT      VARCHAR(8)  NULL COMMENT '종료일',
  ED_TM      VARCHAR(5)  NULL COMMENT '종료시간(HH:MM)',
  GUIDE_YN   CHAR(1)     NULL COMMENT '지침준수 Y/N — ★지표 분자(PASS_CNT)가 이 칸이다',
  PRIMARY KEY (LOG_SEQ, SORT),
  KEY IX_QPS_SECLOG_ITEM (LOG_SEQ, SEC_GB)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='격리·강박 시행일지(행)';

--   ★소요시간은 **담지 않는다** — 시작(ST_DT+ST_TM)과 종료(ED_DT+ED_TM)로 계산한다.
--     지표분석 2쪽의 시간대별 분포가 이 계산값으로 나온다.
--     ⚠구간이 서로 다르다 : ***격리 13구간***(1시간·1~2…11~12·12시간이상) /
--       ***강박 5구간***(1시간·1~2·2~3·3~4·4시간이상). 한 표로 합치면 안 된다.

-- ═══ ② 유치도뇨관 월별 기록지 (UT05) — 병원 + 년월 1부 ═════════════════════
--   원본 : 감염 ▸ 요로감염 ▸ 유치도뇨관기구 ▸ 유치도뇨관 월별 기록지.
--   표 = 날짜 1~31 + Total (행) × 입원환자수 · 재원환자수 · 재원환자중 유치도뇨관 보유 환자 수 (열)
CREATE TABLE IF NOT EXISTS TBL_QPS_CATHDAY (
  CATH_SEQ   BIGINT      NOT NULL AUTO_INCREMENT,
  HOSP_CD    VARCHAR(20) NOT NULL,
  CATH_YM    VARCHAR(6)  NOT NULL COMMENT '작성 년월(YYYYMM)',
  USE_YN     CHAR(1)     DEFAULT 'Y',
  REG_USER   VARCHAR(50) NULL,
  REG_DTTM   DATETIME    DEFAULT CURRENT_TIMESTAMP,
  UPD_USER   VARCHAR(50) NULL,
  UPD_DTTM   DATETIME    NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (CATH_SEQ),
  UNIQUE KEY UK_QPS_CATHDAY (HOSP_CD, CATH_YM)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='유치도뇨관 월별 기록지(머리) — 월 1부';

CREATE TABLE IF NOT EXISTS TBL_QPS_CATHDAY_ITEM (
  CATH_SEQ   BIGINT      NOT NULL,
  DAY_NO     TINYINT     NOT NULL COMMENT '날짜 1~31 (원본 행). Total 행은 저장하지 않는다 — 합계는 센다',
  IN_CNT     INT         NULL COMMENT '입원환자수',
  STAY_CNT   INT         NULL COMMENT '재원환자수',
  CATH_CNT   INT         NULL COMMENT '재원환자중 유치도뇨관 보유 환자 수 — ★지표 UTI 의 분모(device-day)',
  PRIMARY KEY (CATH_SEQ, DAY_NO)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='유치도뇨관 월별 기록지(일자 행)';

-- ═══ ③ 지표 연결 ═══════════════════════════════════════════════════════════
--   저장할 때 서버가 아래로 반영한다(화면 개발 시 함께 붙인다).
--
--   ①  시행일지 → TBL_QPS_MONITOR  (INDI_CD = ISOLATION / SECLUSION)
--       OBS_DT   = LOG_YM + '01'          (월 대표일)
--       OBS_CNT  = 그 달 그 구분의 전체 건수            ← 분모(전체 시행 건수)
--       PASS_CNT = 그중 GUIDE_YN='Y' 건수               ← 분자(지침 수행건수)
--       ⇒ 기존 관찰형 집계가 그대로 돈다. **코드·지표 마스터 무변경.**
--
--   ②  유치도뇨관 기록지 → TBL_QPS_CENSUS (CENSUS_GB='CATHDAYS')
--       IN_YEAR = 년, M01~M12 = 그 달 CATH_CNT 합계     ← 분모(유치도뇨관 일수)
--
-- ── ⚠결정 대기 : UTI 지표의 분모 ──────────────────────────────────────────
--   지금 마스터는 `DENOM_GB='INDAYS'`(총재원일수)다(QPS_DDL_2026-08-08 SORT 15).
--   그런데 ***원본 기록지가 유치도뇨관 보유 환자 수를 따로 세고 있다*** —
--   CAUTI 표준 분모는 재원일수가 아니라 **유치도뇨관 일수**다.
--   ⇒ 아래 UPDATE 는 **일부러 주석으로 둔다.** 분모를 바꾸면 이미 산출된 값이 달라진다 —
--     병원 확인 후 실행할 것. (원본 기록지가 이 칸을 세는 이유가 바로 이 분모다.)
--
-- UPDATE TBL_QPS_INDI_MST
--    SET DENOM_GB   = 'CATHDAYS',
--        DENOM_DESC = '유치도뇨관 일수(재원환자 중 유치도뇨관 보유 환자 수의 기간 합)'
--  WHERE INDI_CD = 'UTI' AND HOSP_CD = '*';

-- ── 확인 ────────────────────────────────────────────────────────────────────
SELECT TABLE_NAME, TABLE_COMMENT
  FROM information_schema.TABLES
 WHERE TABLE_SCHEMA = DATABASE()
   AND TABLE_NAME IN ('TBL_QPS_SECLOG','TBL_QPS_SECLOG_ITEM','TBL_QPS_CATHDAY','TBL_QPS_CATHDAY_ITEM')
 ORDER BY TABLE_NAME;
