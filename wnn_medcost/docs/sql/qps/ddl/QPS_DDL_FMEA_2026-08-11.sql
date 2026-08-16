-- =====================================================================
-- FMEA (2026-08-11) — 계획서 · 보고서
--
--   실측 : 계획서 1면 / 회의록 1~4차 / 낙상보고서 12면 / 투약보고서 5면
--
--   ★★보고서가 계획서를 포함한다.
--     보고서 2·3면(고위험 프로세스 선정 · 팀 구성 · 활동일정 · 핵심지표)이 계획서 내용 그대로다.
--     ⇒ **한 표 + 문서구분(DOC_GB : P=계획서 / R=보고서)**. 보고서면 뒤 섹션이 더 열린다.
--       (QI 중간·최종을 한 서식으로 묶은 것과 같은 방식)
--
--   ★투약보고서(5면)는 낙상(12면)의 축약판이다 — 같은 서식에서 ***섹션을 비우면*** 된다.
--     비운 섹션은 인쇄에서 빠진다. 주제마다 화면을 만들지 않는다.
--
--   ★FMEA 회의록은 여기 없다 — 공통 골격(회의일시·장소·제목·주관부서·안건·참여위원)이
--     서식 1호와 같아 **FORM_GB='F' 로 흡수**했다. 차수는 회의명에 적는다("1차" 등).
--     ***차수마다 다른 「회의결과」 구조는 회의내용 칸에 적는다*** — QI 회의록에서 확인된 대로
--     원본도 본문에 표를 타이핑해 넣는다. 구조화가 필요해지면 그때 칸을 늘린다.
--
--   ★★산식 (원본 인쇄물에 박혀 있다)
--       위험도점수 = 발생가능성 × 심각성            ← 주제 고르기(2면). 척도 1~5
--       RPN        = 심각도 × 발생가능성 × 발견가능성  ← Work Sheet. 척도 아래 표
--   ⚠**CI 는 산식이 인쇄돼 있지 않다.** 화면은 `심각성 × 발생가능성` 으로 계산하되
--     ***「추정 산식」이라고 표시***한다. 원본(델파이 소스)에서 확인되면 여기 한 줄만 고친다.
--     ***조용히 틀린 값을 내는 것이 가장 나쁘다 — 그래서 화면에 드러낸다.***
--
--   재실행 안전.
-- =====================================================================

INSERT INTO TBL_CODE_MST (CODE_CD, JOB_SEQ, CODE_NM, START_DT, END_DT, USE_YN, ACTION_YN, REG_USER) VALUES
 ('QPS_FMEA_GB',1,'FMEA 문서구분','20000101','99991231','Y','Y','system')
ON DUPLICATE KEY UPDATE CODE_NM=VALUES(CODE_NM), USE_YN='Y', ACTION_YN='Y';

INSERT INTO TBL_CODE_DTL (CODE_GB, CODE_CD, SUB_CODE, JOB_SEQ, SUB_CODE_NM, START_DT, END_DT, USE_YN, SORT, ACTION_YN, REG_USER) VALUES
 ('Q','QPS_FMEA_GB','P',1,'FMEA 계획서','20000101','99991231','Y',1,'Y','system'),
 ('Q','QPS_FMEA_GB','R',1,'FMEA 보고서','20000101','99991231','Y',2,'Y','system')
ON DUPLICATE KEY UPDATE SUB_CODE_NM=VALUES(SUB_CODE_NM), SORT=VALUES(SORT), USE_YN='Y', ACTION_YN='Y';


CREATE TABLE IF NOT EXISTS TBL_QPS_FMEA (
  FME_SEQ   BIGINT       NOT NULL AUTO_INCREMENT,
  HOSP_CD   VARCHAR(20)  NOT NULL,
  IN_YEAR   CHAR(4)      NOT NULL,
  DOC_GB    CHAR(1)      NOT NULL DEFAULT 'P' COMMENT 'P=계획서 R=보고서',
  INDI_CD   VARCHAR(30)  NULL COMMENT '주제로 고른 지표(자유 주제면 NULL)',
  TOPIC_NM  VARCHAR(200) NULL COMMENT '주제 (낙상예방활동 등)',
  WRITE_DT  VARCHAR(8)   NULL COMMENT '작성날짜',
  WRITER_NM VARCHAR(60)  NULL COMMENT 'QPS전담자 / 작성자',
  PURPOSE   TEXT         NULL COMMENT '목적 (계획서)',
  -- 활동일정의 기간 열은 가변이다(원본 「7~8월 / 9월 / 10월」). 열 이름을 그대로 담는다.
  PRD_HEAD  VARCHAR(200) NULL COMMENT '활동일정 기간 열 이름들 — 쉼표 구분(예: 7~8월,9월,10월)',
  -- 보고서 전용 서술
  STEP_TXT     TEXT NULL COMMENT 'FMEA 진행 단계 (2면 표)',
  RCA_DIFF     TEXT NULL COMMENT '「RCA와 다른점」',
  HIRISK_TXT   TEXT NULL COMMENT '1. 고위험 프로세스 선정',
  GOAL_TXT     TEXT NULL COMMENT '라. 핵심지표 및 활동 목표',
  PROCMAP_TXT  TEXT NULL COMMENT '2. 프로세스 맵 (단계 흐름을 글로)',
  ROOT_STEP    TEXT NULL COMMENT '5. 근본원인 분석을 시행할 단계 결정',
  ROOT_HR      TEXT NULL COMMENT '근본원인 — 인적요인',
  ROOT_ENV     TEXT NULL COMMENT '근본원인 — 시설 및 환경요인',
  ROOT_SYS     TEXT NULL COMMENT '근본원인 — 시스템요인',
  FISHBONE_TXT TEXT NULL COMMENT '다. fishbone (그림은 첨부, 여기는 설명)',
  IMPR_TXT     TEXT NULL COMMENT '라. 개선계획 정리 및 구체적 방안',
  VERIFY_TXT   TEXT NULL COMMENT '7. 새로운 프로세스의 분석과 검증',
  CONCL_TXT    TEXT NULL COMMENT '9. 결론',
  NEXT_TXT     TEXT NULL COMMENT '9. 추후 관리계획',
  SHARE_TXT    TEXT NULL COMMENT '10. 결과의 전달 및 공유',
  USE_YN    CHAR(1)     NOT NULL DEFAULT 'Y',
  REG_USER  VARCHAR(50) NULL,
  REG_DTTM  DATETIME    NULL DEFAULT CURRENT_TIMESTAMP,
  UPD_USER  VARCHAR(50) NULL,
  UPD_DTTM  DATETIME    NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (FME_SEQ),
  KEY IX_QPS_FMEA (HOSP_CD, IN_YEAR, DOC_GB, USE_YN)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='FMEA 계획서·보고서';

-- 팀구성 · 활동일정 · 위험도평가 · 개선계획 — 한 표에(SECT_CD 로 구분)
--   TEAM  : GRP=구분(팀장·간사·팀원), C1=성명
--   SCHED : C1=활동, M01~M08=기간 열 체크(열 이름은 머리의 PRD_HEAD), C2=세부내용
--   RISK  : C1=FMEA 주제, N1=사건보고건수, N2=발생가능성, N3=영향/심각성, N4=위험도점수(N2×N3), C2=선정결과
--   IMPR  : C1=개선내용, C2=비고
CREATE TABLE IF NOT EXISTS TBL_QPS_FMEA_ITEM (
  FME_SEQ BIGINT       NOT NULL,
  SECT_CD VARCHAR(10)  NOT NULL,
  SORT    INT          NOT NULL,
  GRP     VARCHAR(60)  NULL,
  C1      VARCHAR(500) NULL,
  C2      VARCHAR(500) NULL,
  N1 INT NULL, N2 INT NULL, N3 INT NULL, N4 INT NULL,
  M01 CHAR(1) NULL, M02 CHAR(1) NULL, M03 CHAR(1) NULL, M04 CHAR(1) NULL,
  M05 CHAR(1) NULL, M06 CHAR(1) NULL, M07 CHAR(1) NULL, M08 CHAR(1) NULL,
  PRIMARY KEY (FME_SEQ, SECT_CD, SORT)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='FMEA — 팀구성·활동일정·위험도평가·개선계획';

-- ★FMEA Work Sheet — 이 서식의 핵심.
--   사전(개선 전)과 사후(개선 후) 점수를 **한 행에** 담는다.
--   그래야 10면 「RPN 재산정」과 11면 「개선 전/후 비교」가 같은 행에서 나온다.
CREATE TABLE IF NOT EXISTS TBL_QPS_FMEA_SHEET (
  FME_SEQ  BIGINT       NOT NULL,
  SORT     INT          NOT NULL,
  STEP_NM  VARCHAR(200) NULL COMMENT 'Process(단계)',
  MODE_NM  VARCHAR(500) NULL COMMENT '가능한 고장유형(Potential Failure Mode)',
  CAUSE_NM VARCHAR(500) NULL COMMENT '가능한 원인(Potential causes for Failure)',
  EFFECT_NM VARCHAR(500) NULL COMMENT '잠재적인 영향(Potential Effects of Failure)',
  -- 사전 점수
  A_OCCUR INT NULL COMMENT '발생가능성', A_SEVER INT NULL COMMENT '심각성', A_DETECT INT NULL COMMENT '발견가능성',
  A_RPN   INT NULL COMMENT 'RPN = 심각성 × 발생가능성 × 발견가능성',
  A_CI    INT NULL COMMENT 'CI (★산식 미확인 — 화면은 심각성×발생가능성으로 셈하고 「추정」이라 표시)',
  A_RANK  INT NULL COMMENT '순위',
  -- 사후 점수 (개선 후)
  B_OCCUR INT NULL, B_SEVER INT NULL, B_DETECT INT NULL,
  B_RPN   INT NULL, B_CI INT NULL,
  PRIMARY KEY (FME_SEQ, SORT)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='FMEA Work Sheet(사전·사후 한 행)';

-- ── 척도표 — 화면 안내와 인쇄물에 그대로 낸다 (6면 실측) ────────────
CREATE TABLE IF NOT EXISTS TBL_QPS_FMEA_SCALE (
  SCALE_GB VARCHAR(10)  NOT NULL COMMENT 'SEVER=심각도 OCCUR=발생가능성 DETECT=발견가능성 RISK=위험도점수',
  SCORE    INT          NOT NULL,
  DESC_TXT VARCHAR(200) NOT NULL,
  SORT     INT          NOT NULL DEFAULT 0,
  USE_YN   CHAR(1)      NOT NULL DEFAULT 'Y',
  PRIMARY KEY (SCALE_GB, SCORE)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='FMEA 점수 척도';

INSERT INTO TBL_QPS_FMEA_SCALE (SCALE_GB,SCORE,DESC_TXT,SORT,USE_YN) VALUES
 ('SEVER', 1,'영향이 없음',1,'Y'),
 ('SEVER', 3,'거의 영향이 없으나, 시간을 두고 필요한 경우',2,'Y'),
 ('SEVER', 5,'간단한 처치 및 치료가 필요한 경우',3,'Y'),
 ('SEVER', 6,'일반 병동 care가 필요한 경우',4,'Y'),
 ('SEVER', 8,'ICU care가 필요한 경우',5,'Y'),
 ('SEVER',10,'영구적 손상이나 사망',6,'Y'),
 ('OCCUR', 1,'희박한 가능성(10%미만)',1,'Y'),
 ('OCCUR', 3,'낮은 가능성(10%~39%)',2,'Y'),
 ('OCCUR', 5,'중간 가능성(40%~59%)',3,'Y'),
 ('OCCUR', 7,'높은 가능성(60%~79%)',4,'Y'),
 ('OCCUR', 9,'일정하게 발생하는 것(100%이상)',5,'Y'),
 ('DETECT',1,'확실히 발견됨(9%이상)',1,'Y'),
 ('DETECT',3,'높은 가능성(65%~89%)',2,'Y'),
 ('DETECT',5,'중간 가능성(35%~64%)',3,'Y'),
 ('DETECT',7,'낮은 가능성(10%~34%)',4,'Y'),
 ('DETECT',9,'대부분 발견되지 못함(10%미만)',5,'Y')
ON DUPLICATE KEY UPDATE DESC_TXT=VALUES(DESC_TXT), SORT=VALUES(SORT), USE_YN='Y';

SELECT '척도' AS chk, SCALE_GB, COUNT(*) AS n FROM TBL_QPS_FMEA_SCALE GROUP BY SCALE_GB;
