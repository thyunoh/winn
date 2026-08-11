-- =====================================================================
-- RCA 근본원인 분석 보고서 (2026-08-11)
--
--   원본 「환자 안전사고 근본원인 분석 보고서」 1면 실측 —
--   ***FMEA 보다 훨씬 단순하다. 표 하나에 5단계, 계산이 없다.***
--     머리   : 호실 · 이름 · 등록번호 · 성별/나이
--     1단계  문제 확인       : 발생일시 · 발생장소 · 문제요약
--     2단계  현황 파악       : 과정(Process)분석 및 문제 확인
--     3단계  관련요인 분석   : 인적자원(개인·교육) / 시스템(과정·장비·환경·의사소통·기타)
--     4단계  개선활동        : 인적자원 · 시스템 · 기타
--     5단계  결과평가
--
--   ★항목이 **고정**이라 항목표(DEF)가 필요 없다 — 사고 보고서와 다른 점이다.
--     칸을 표에 그대로 두는 것이 맞다(비는 칸이 없다).
--   ★원본 좌측의 라디오 1~4 는 「한 해에 여러 건」이라는 뜻일 뿐이다.
--     ***4건 제한을 옮기지 않는다*** — 목록으로 풀고 건수를 막지 않는다
--     (불만고충 처리결과서의 「1~14」 와 같은 판단).
--   ★환자 정보는 사고(TBL_QPS_INCIDENT)에서 가져온다 — 두 번 입력하지 않는다.
--
--   ★RCA 회의록은 여기 없다 — 1차·2차가 같고 QI 회의록과 골격이 같아
--     **서식 1호(회의록)에 FORM_GB='R' 로 흡수**했다.
--
--   재실행 안전(CREATE TABLE IF NOT EXISTS).
-- =====================================================================

CREATE TABLE IF NOT EXISTS TBL_QPS_RCA (
  RCA_SEQ   BIGINT       NOT NULL AUTO_INCREMENT,
  HOSP_CD   VARCHAR(20)  NOT NULL,
  IN_YEAR   CHAR(4)      NOT NULL,
  INCID_SEQ BIGINT       NULL COMMENT 'TBL_QPS_INCIDENT 연결(없으면 직접 입력)',
  -- 머리 (환자)
  ROOM_NM   VARCHAR(40)  NULL COMMENT '호실',
  PAT_NM    VARCHAR(60)  NULL COMMENT '이름',
  PAT_NO    VARCHAR(40)  NULL COMMENT '등록번호',
  SEX_AGE   VARCHAR(40)  NULL COMMENT '성별/나이',
  -- 1단계 문제 확인
  OCCUR_DT  VARCHAR(8)   NULL COMMENT '발생일시(일자)',
  OCCUR_TM  VARCHAR(5)   NULL COMMENT '발생일시(시각)',
  OCCUR_PL  VARCHAR(200) NULL COMMENT '발생장소',
  PROBLEM   TEXT         NULL COMMENT '문제요약',
  -- 2단계 현황 파악
  PROCESS_TXT TEXT NULL COMMENT '과정(Process)분석 및 문제 확인',
  -- 3단계 관련요인 분석 — 인적자원 / 시스템
  HR_PERSON TEXT NULL COMMENT '인적자원 — 개인',
  HR_EDU    TEXT NULL COMMENT '인적자원 — 교육',
  SY_PROC   TEXT NULL COMMENT '시스템 — 과정(Process)',
  SY_EQUIP  TEXT NULL COMMENT '시스템 — 장비',
  SY_ENV    TEXT NULL COMMENT '시스템 — 환경',
  SY_COMM   TEXT NULL COMMENT '시스템 — 의사소통',
  SY_ETC    TEXT NULL COMMENT '시스템 — 기타',
  -- 4단계 개선활동
  ACT_HR    TEXT NULL COMMENT '개선활동 — 인적자원',
  ACT_SY    TEXT NULL COMMENT '개선활동 — 시스템(System)',
  ACT_ETC   TEXT NULL COMMENT '개선활동 — 기타',
  -- 5단계 결과평가
  RESULT_TXT TEXT NULL COMMENT '결과평가',
  WRITE_DT  VARCHAR(8)  NULL COMMENT '작성일',
  WRITER_NM VARCHAR(60) NULL COMMENT '작성자',
  USE_YN    CHAR(1)     NOT NULL DEFAULT 'Y',
  REG_USER  VARCHAR(50) NULL,
  REG_DTTM  DATETIME    NULL DEFAULT CURRENT_TIMESTAMP,
  UPD_USER  VARCHAR(50) NULL,
  UPD_DTTM  DATETIME    NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (RCA_SEQ),
  KEY IX_QPS_RCA (HOSP_CD, IN_YEAR, USE_YN)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='RCA 근본원인 분석 보고서';
