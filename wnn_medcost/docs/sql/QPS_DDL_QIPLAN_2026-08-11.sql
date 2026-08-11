-- =====================================================================
-- QI 활동 계획서 (QI 폴더 #1) — 2026-08-11
--
--   원본 실물 10장 대조(낙상·손위생·신체보호대·욕창·불만고충·영양실·근접오류·
--   투약오류·학대및폭력·재택복귀율) 결과 : ***서식은 하나이고 주제별로 한 장씩***이다.
--   → 저장 단위 = (병원, 연도, 주제).
--
--   ★★가장 큰 발견 — 「핵심지표」 블록이 우리 지표정의서와 1:1 로 대응한다.
--       지표명 = INDI_NM · 분자 = NUMER_DESC · 분모 = DENOM_DESC ·
--       제외기준 = EXCLUDE_TXT · 포함기준 = INCLUDE_TXT · 목표값 = TARGET_VAL ·
--       「X 1000」/「X 100」 = MULTIPLIER
--     실제로 10장의 배수가 우리 마스터와 전부 일치했다(낙상 ×1000 · 손위생 ×100 …).
--     ⇒ ***주제로 지표를 고르면 이 블록이 자동으로 채워진다.*** 원본은 손으로 적던 칸이다.
--
--   ★그런데 값을 저장한다(스냅샷). 조회할 때마다 정의서를 다시 읽지 않는다 —
--     계획서는 결재가 찍히는 문서라, 나중에 정의서를 고쳐도 ***그때 결재한 내용이 남아야 한다.***
--     (지표 확정 시 수치를 동결하는 것과 같은 원칙)
--
--   ★주제는 코드 고정이 아니다 — 10장 중 「영양실」·「근접오류」는 지표 마스터에 없다.
--     지표 선택 + 직접입력 둘 다 받는다(만족도 개선활동 유형과 같은 방식).
--
--   재실행 안전(CREATE TABLE IF NOT EXISTS).
-- =====================================================================

CREATE TABLE IF NOT EXISTS TBL_QPS_QIPLAN (
  QIP_SEQ    BIGINT       NOT NULL AUTO_INCREMENT,
  HOSP_CD    VARCHAR(20)  NOT NULL,
  IN_YEAR    CHAR(4)      NOT NULL,
  -- 주제 : 지표에서 고르면 INDI_CD 가 차고, 자유 주제(영양실 등)면 비고 TOPIC_NM 만 쓴다
  INDI_CD    VARCHAR(30)  NULL COMMENT '주제로 고른 지표코드(자유 주제면 NULL)',
  TOPIC_NM   VARCHAR(200) NULL COMMENT '주제명',
  DEPT_NM    VARCHAR(60)  NULL COMMENT '제출부서',
  SUBMIT_DT  VARCHAR(8)   NULL COMMENT '제출일',
  BACKGROUND TEXT         NULL COMMENT '주제선정 배경',
  -- 핵심지표 (지표정의서에서 자동으로 채우되 이 문서의 스냅샷으로 저장한다)
  INDI_NM    VARCHAR(200) NULL COMMENT '지표명',
  NUMER_DESC VARCHAR(500) NULL COMMENT '분자',
  DENOM_DESC VARCHAR(500) NULL COMMENT '분모',
  INCLUDE_TXT TEXT        NULL COMMENT '포함기준 (학대및폭력 등 일부 서식에만 있다)',
  EXCLUDE_TXT TEXT        NULL COMMENT '제외기준',
  TARGET_VAL VARCHAR(60)  NULL COMMENT '목표값',
  MULTIPLIER INT          NULL COMMENT '배수 1000 / 100 — 인쇄물의 「X 1000」 칸',
  UNIT       VARCHAR(10)  NULL COMMENT '단위 ‰ / %',
  -- 서술
  SRC_TXT      TEXT NULL COMMENT '자료수집',
  STRATEGY_TXT TEXT NULL COMMENT '개선전략 / 개선활동평가관리',
  EXPECT_TXT   TEXT NULL COMMENT '기대효과 및 기타',
  USE_YN     CHAR(1)     NOT NULL DEFAULT 'Y',
  REG_USER   VARCHAR(50) NULL,
  REG_DTTM   DATETIME    NULL DEFAULT CURRENT_TIMESTAMP,
  UPD_USER   VARCHAR(50) NULL,
  UPD_DTTM   DATETIME    NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (QIP_SEQ),
  -- ★유니크를 걸지 않는다. 같은 주제로 두 장을 쓰는 병원이 있을 수 있고,
  --   막았다가 저장이 조용히 실패하는 쪽이 더 나쁘다(불만고충 대장과 같은 판단).
  KEY IX_QPS_QIPLAN (HOSP_CD, IN_YEAR, USE_YN)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='QI 활동 계획서';

-- 팀구성(구분|성명) + 활동일정(PDCA × 12개월) 을 한 표에 담는다 — 연간계획서와 같은 방식.
--   SECT_CD='TEAM'  : GRP=구분(팀장·간사·팀원), C1=성명
--   SECT_CD='SCHED' : GRP=PDCA 단계(P/D/C/A), C1=활동명, M01~M12 체크
CREATE TABLE IF NOT EXISTS TBL_QPS_QIPLAN_ITEM (
  QIP_SEQ BIGINT       NOT NULL,
  SECT_CD VARCHAR(10)  NOT NULL,
  SORT    INT          NOT NULL,
  GRP     VARCHAR(60)  NULL,
  C1      VARCHAR(300) NULL,
  M01 CHAR(1) NULL, M02 CHAR(1) NULL, M03 CHAR(1) NULL, M04 CHAR(1) NULL,
  M05 CHAR(1) NULL, M06 CHAR(1) NULL, M07 CHAR(1) NULL, M08 CHAR(1) NULL,
  M09 CHAR(1) NULL, M10 CHAR(1) NULL, M11 CHAR(1) NULL, M12 CHAR(1) NULL,
  PRIMARY KEY (QIP_SEQ, SECT_CD, SORT)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='QI 활동 계획서 — 팀구성·활동일정';
