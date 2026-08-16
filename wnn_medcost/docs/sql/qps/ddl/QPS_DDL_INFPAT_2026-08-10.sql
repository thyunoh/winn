-- =====================================================================
-- 감염병환자 월별 리스트 + 감염관리 전담자 3종 (2026-08-10) — 원본 캡처 채록
--
--   ① 감염병환자 월별 리스트 : 병원+년월 1부. 표 + 하단 발생자 통계 3칸.
--      ★환자 칸(등록번호·이름·성별·연령)은 TBL_IPWON_INFO 에서 [찾기]로 끌어온다
--        — 낙상 화면과 같은 환자검색을 재사용한다. QPS 는 환자를 따로 등록하지 않는다.
--      ★주민번호는 담지 않는다. 성별·연령은 검색 시점에 계산된 값만 받는다(낙상과 동일 원칙).
--
--   ② 감염관리 전담자 : 임명장 / 자격 및 경력 / 직무기술서.
--      원본은 문서 3개지만 <같은 사람의 서류 한 벌>이다 — 한 행에 담고 인쇄만 3장으로 나눈다.
--      ★직무기술서의 단위업무 5개(감염관리 계획수립 및 평가 / 감염관리 / 감염관리 교육 /
--        지표관리 / 직원감염관리)는 원본 고정값이라 행으로 둔다(병원이 내용을 채운다).
--      ★교육이수 표(교육주관·과정명·교육일·교육기간)도 행. 수료증 파일은 공통 첨부로.
--
--   재실행 안전(CREATE IF NOT EXISTS).
-- =====================================================================

-- ── ① 감염병환자 월별 리스트 ────────────────────────────────────────
CREATE TABLE IF NOT EXISTS TBL_QPS_INFPAT (
  IPAT_SEQ   BIGINT      NOT NULL AUTO_INCREMENT,
  HOSP_CD    VARCHAR(20) NOT NULL,
  IPAT_YM    VARCHAR(6)  NOT NULL COMMENT '작성 년월(YYYYMM)',
  ST_BLOOD   VARCHAR(200) NULL COMMENT '발생자 통계 — 혈액매개주의',
  ST_MDRO    VARCHAR(200) NULL COMMENT '발생자 통계 — 다제내성균',
  ST_TB      VARCHAR(200) NULL COMMENT '발생자 통계 — 결핵',
  USE_YN     CHAR(1)     DEFAULT 'Y',
  REG_USER   VARCHAR(50) NULL,
  REG_DTTM   DATETIME    DEFAULT CURRENT_TIMESTAMP,
  UPD_USER   VARCHAR(50) NULL,
  UPD_DTTM   DATETIME    NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (IPAT_SEQ),
  UNIQUE KEY UK_QPS_INFPAT (HOSP_CD, IPAT_YM)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='감염병환자 월별 리스트(머리)';

CREATE TABLE IF NOT EXISTS TBL_QPS_INFPAT_ITEM (
  IPAT_SEQ  BIGINT      NOT NULL,
  SORT      INT         NOT NULL,
  IN_DT     VARCHAR(8)  NULL COMMENT '입원일',
  CHK_DT    VARCHAR(8)  NULL COMMENT '확인일',
  DISEASE   VARCHAR(200) NULL COMMENT '감염성질환 유형',
  PAT_NO    VARCHAR(30) NULL COMMENT '등록번호',
  PAT_NM    VARCHAR(50) NULL COMMENT '이름',
  SEX_NM    VARCHAR(10) NULL COMMENT '성별',
  AGE_VAL   VARCHAR(10) NULL COMMENT '연령',
  IN_HOSP   VARCHAR(10) NULL COMMENT '원내발생 여부',
  ACT_TXT   VARCHAR(500) NULL COMMENT '조치결과',
  PRIMARY KEY (IPAT_SEQ, SORT)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='감염병환자 월별 리스트(행)';

-- ── ② 감염관리 전담자 ───────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS TBL_QPS_INFSTAFF (
  STF_SEQ    BIGINT      NOT NULL AUTO_INCREMENT,
  HOSP_CD    VARCHAR(20) NOT NULL,
  STF_NM     VARCHAR(50) NOT NULL COMMENT '성명',
  -- 임명장
  DEPT_NM    VARCHAR(60)  NULL COMMENT '소속',
  POSITION   VARCHAR(60)  NULL COMMENT '직위',
  APPT_DT    VARCHAR(8)   NULL COMMENT '임명일',
  -- 자격 및 경력
  JOB_KIND   VARCHAR(60)  NULL COMMENT '직종',
  CAREER_TXT TEXT         NULL COMMENT '경력 사항',
  -- 직무기술서
  JOIN_DT    VARCHAR(8)   NULL COMMENT '입사일',
  RANK_NM    VARCHAR(60)  NULL COMMENT '직급',
  DEPT_DT    VARCHAR(8)   NULL COMMENT '현 부서 배치일',
  DUTY_DT    VARCHAR(8)   NULL COMMENT '현 직무 시작일',
  WRITE_DT   VARCHAR(8)   NULL COMMENT '작성일자',
  EDU_LEVEL  VARCHAR(200) NULL COMMENT '학력수준 — 필수/권장/전문분야',
  MAJOR_TXT  VARCHAR(200) NULL COMMENT '전공학과 — 무관/1순위/2순위',
  LICENSE_TXT VARCHAR(200) NULL COMMENT '면허 및 자격 — 필수/권장',
  CAREER_REQ VARCHAR(200) NULL COMMENT '경력요건 — 필수/권장',
  USE_YN     CHAR(1)     DEFAULT 'Y',
  REG_USER   VARCHAR(50) NULL,
  REG_DTTM   DATETIME    DEFAULT CURRENT_TIMESTAMP,
  UPD_USER   VARCHAR(50) NULL,
  UPD_DTTM   DATETIME    NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (STF_SEQ),
  KEY IX_QPS_INFSTAFF (HOSP_CD, USE_YN)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='감염관리 전담자(임명장·자격경력·직무기술서 한 벌)';

CREATE TABLE IF NOT EXISTS TBL_QPS_INFSTAFF_EDU (
  STF_SEQ  BIGINT      NOT NULL,
  SORT     INT         NOT NULL,
  ORG_NM   VARCHAR(100) NULL COMMENT '교육 주관',
  CRS_NM   VARCHAR(200) NULL COMMENT '과정명',
  EDU_DT   VARCHAR(30)  NULL COMMENT '교육일',
  EDU_TERM VARCHAR(30)  NULL COMMENT '교육기간',
  PRIMARY KEY (STF_SEQ, SORT)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='전담자 교육이수';

CREATE TABLE IF NOT EXISTS TBL_QPS_INFSTAFF_DUTY (
  STF_SEQ  BIGINT      NOT NULL,
  SORT     INT         NOT NULL,
  DUTY_NM  VARCHAR(60)  NULL COMMENT '단위 업무명(원본 고정 5종)',
  DUTY_TXT TEXT         NULL COMMENT '주요 업무내용',
  DUTY_CYC VARCHAR(40)  NULL COMMENT '업무 주기',
  PRIMARY KEY (STF_SEQ, SORT)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='전담자 직무기술 — 단위업무';
