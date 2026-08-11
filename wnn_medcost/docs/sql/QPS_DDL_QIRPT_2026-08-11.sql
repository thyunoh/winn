-- =====================================================================
-- QI 중간보고서 · 최종보고서 (QI 폴더 #3·#4) — 2026-08-11
--
--   원본 실물 대조(중간 3장: 낙상·손위생·투약 / 최종 3장) 결과 —
--   ***최종보고서가 중간보고서의 상위집합이다.*** 좌측에 붙은 P·D·C·A 마크가 결정적이었다.
--     P 1면 : 주제 · 주제선정배경 · 팀 구성 · 자료수집및문제분석(조사대상/기간/방법/결과분석 그래프)
--             · 현황파악 및 원인분석 · 목표 · 개선활동계획      ← 중간·최종 동일
--     D 2면 : 개선활동(+사진)                                    ← 중간은 계획/실행/비고
--     C 3면 : 활동효과 — 분기별 지표표 + 위해등급 + 사고분류      ← ***최종만***
--     A 3면 : 결론 및 제언                                        ← ***최종만***
--   ⇒ 화면을 둘로 만들지 않는다. **한 서식 + 종류 구분(RPT_GB)** 으로 가고
--     최종일 때만 C·A 카드를 보여준다(감염종합보고 3종을 한 서식으로 묶은 것과 같은 방식).
--
--   ★★활동효과 표(3면)는 회의록 7차에 박혀 있던 그 표와 같다 —
--     분기별 발생보고율/보고건수 · level 3·4 건수 · 근접오류/위해사건/적신호사건 · 목표값 달성여부.
--     ***전부 지표 집계에서 나온다. 저장하지 않고 조회 시 계산한다***(불만고충 보고서와 같은 원칙).
--     그래서 이 표의 칸은 이 DDL 에 없다.
--
--   ★결과분석 그래프의 축은 지표 유형에 따라 다르다(실측) —
--     관찰형(손위생)=분기별 %, 사고형(투약)=월별 건수. 사용자가 고르게 하지 않고
--     NUMER_SRC 로 화면이 정한다.
--
--   ★2면의 「개선내용|일정」 표는 낙상 버전에만 있었다(손위생·투약엔 없음)
--     ⇒ 그 문서에 타이핑한 내용물이지 서식 필드가 아니다. 회의록에서와 같은 판단.
--     다만 최종보고서 1면에는 <서식 필드로> 있어서 그건 항목표에 담는다.
--
--   재실행 안전(CREATE TABLE IF NOT EXISTS).
-- =====================================================================

CREATE TABLE IF NOT EXISTS TBL_QPS_QIRPT (
  QIR_SEQ    BIGINT       NOT NULL AUTO_INCREMENT,
  HOSP_CD    VARCHAR(20)  NOT NULL,
  IN_YEAR    CHAR(4)      NOT NULL,
  RPT_GB     CHAR(1)      NOT NULL DEFAULT 'M' COMMENT 'M=중간보고서 F=최종보고서',
  -- 주제 : 계획서와 같은 방식(지표 선택 + 자유 주제)
  INDI_CD    VARCHAR(30)  NULL COMMENT '주제로 고른 지표코드(자유 주제면 NULL)',
  TOPIC_NM   VARCHAR(200) NULL COMMENT '주제',
  DEPT_NM    VARCHAR(60)  NULL COMMENT '부서',
  SUBMIT_DT  VARCHAR(8)   NULL COMMENT '제출일자',
  BACKGROUND TEXT         NULL COMMENT '주제선정 배경',
  -- 자료수집 및 문제분석
  SURVEY_TARGET VARCHAR(300) NULL COMMENT '조사대상',
  SURVEY_FR_MM  CHAR(2)      NULL COMMENT '조사기간 시작월',
  SURVEY_TO_MM  CHAR(2)      NULL COMMENT '조사기간 종료월',
  SURVEY_METHOD VARCHAR(300) NULL COMMENT '조사방법',
  -- ※ 결과분석 그래프는 저장하지 않는다 — 지표에서 계산한다
  ANALYSIS   TEXT NULL COMMENT '현황파악 및 원인분석',
  GOAL_TXT   TEXT NULL COMMENT '목표 (여러 줄)',
  -- D
  ACT_TXT    TEXT NULL COMMENT '개선활동 (최종) / 실행 (중간)',
  PLAN_TXT   TEXT NULL COMMENT '개선활동계획 서술 (중간 2면)',
  NOTE       TEXT NULL COMMENT '비고 (중간 2면)',
  -- C·A — 최종보고서만 쓴다. 표의 수치는 저장하지 않고 서술만 담는다.
  EFFECT_TXT TEXT NULL COMMENT '활동효과 서술 (최종)',
  CONCL_TXT  TEXT NULL COMMENT '결론 및 제언 (최종)',
  USE_YN     CHAR(1)     NOT NULL DEFAULT 'Y',
  REG_USER   VARCHAR(50) NULL,
  REG_DTTM   DATETIME    NULL DEFAULT CURRENT_TIMESTAMP,
  UPD_USER   VARCHAR(50) NULL,
  UPD_DTTM   DATETIME    NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (QIR_SEQ),
  -- 유니크를 걸지 않는다(같은 주제로 두 장을 쓸 수 있다 — 대장·계획서와 같은 판단)
  KEY IX_QPS_QIRPT (HOSP_CD, IN_YEAR, RPT_GB, USE_YN)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='QI 중간·최종보고서';

-- 팀 구성 + 개선활동계획(개선내용|일정) 을 한 표에
--   SECT_CD='TEAM'  : GRP=구분(팀장·간사·팀원), C1=성명
--   SECT_CD='IMPR'  : C1=개선내용, C2=일정
CREATE TABLE IF NOT EXISTS TBL_QPS_QIRPT_ITEM (
  QIR_SEQ BIGINT       NOT NULL,
  SECT_CD VARCHAR(10)  NOT NULL,
  SORT    INT          NOT NULL,
  GRP     VARCHAR(60)  NULL,
  C1      VARCHAR(500) NULL,
  C2      VARCHAR(200) NULL,
  PRIMARY KEY (QIR_SEQ, SECT_CD, SORT)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='QI 중간·최종보고서 — 팀구성·개선활동계획';

-- 종류 공통코드
INSERT INTO TBL_CODE_MST (CODE_CD, JOB_SEQ, CODE_NM, START_DT, END_DT, USE_YN, ACTION_YN, REG_USER) VALUES
 ('QPS_QIRPT_GB',1,'QI 보고서 종류','20000101','99991231','Y','Y','system')
ON DUPLICATE KEY UPDATE CODE_NM=VALUES(CODE_NM), USE_YN='Y', ACTION_YN='Y';

INSERT INTO TBL_CODE_DTL (CODE_GB, CODE_CD, SUB_CODE, JOB_SEQ, SUB_CODE_NM, START_DT, END_DT, USE_YN, SORT, ACTION_YN, REG_USER) VALUES
 ('Q','QPS_QIRPT_GB','M',1,'QI활동 중간보고서','20000101','99991231','Y',1,'Y','system'),
 ('Q','QPS_QIRPT_GB','F',1,'QI활동 최종보고서','20000101','99991231','Y',2,'Y','system')
ON DUPLICATE KEY UPDATE SUB_CODE_NM=VALUES(SUB_CODE_NM), SORT=VALUES(SORT), USE_YN='Y', ACTION_YN='Y';
