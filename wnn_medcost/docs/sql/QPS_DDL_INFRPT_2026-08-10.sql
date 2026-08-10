-- =====================================================================
-- 감염종합보고 (2026-08-10) — 원본 3종을 한 서식으로 묶는다(사용자 확정)
--
--   원본 3종은 골격이 같다 : 기안서 + 내용 + 참석자·서명 명단 + 첨부.
--     P = 감염관리 개선활동 계획 수립   (기안서 / 첨부)
--     D = 감염관리 개선활동 수행        (기안서 / 교육결과 / 참석자 명단 / 첨부)
--     E = 손위생 교육 결과 보고서        (결재+교육결과 / 참여위원 서명 / 첨부)
--   → 따로 3벌 만들면 기안서·명단·첨부를 세 번 만들게 된다. RPT_GB 하나로 가른다.
--
--   ★기안서 칸은 원본 그대로 담는다(문서분류·문서번호·기안일자·기안부서(위원장/실장)·
--     협조부서·수신·참조·발송일자·제목). 결재란은 인쇄물에서 담당/과장/부장/원장 4칸.
--   ★교육 칸(교육일시·교육자·교육대상자·주제)은 D·E 에서만 쓴다. P 는 비워 둔다.
--     서식마다 테이블을 나누지 않는다 — 칸이 비는 것이 표를 늘리는 것보다 낫다.
--   ★명단은 행 수가 서식마다 달라(수행=위원장·부위원장·간사·위원 다수 / 교육=소속·성명 다수)
--     역할·소속·성명 세 칸짜리 한 표로 통일한다.
--   ★첨부는 공통 첨부 재사용 — REF_GB='INFRPT', REF_KEY = RPT_SEQ.
--
--   재실행 안전(CREATE IF NOT EXISTS).
-- =====================================================================

CREATE TABLE IF NOT EXISTS TBL_QPS_INFRPT (
  RPT_SEQ    BIGINT      NOT NULL AUTO_INCREMENT,
  HOSP_CD    VARCHAR(20) NOT NULL COMMENT '병원코드',
  RPT_GB     CHAR(1)     NOT NULL COMMENT 'P=개선활동 계획수립 D=개선활동 수행 E=손위생 교육결과',
  RPT_DT     VARCHAR(8)  NOT NULL COMMENT '작성일(YYYYMMDD)',
  TITLE      VARCHAR(200) NULL    COMMENT '제목',
  -- 기안서
  DOC_CLS    VARCHAR(60)  NULL COMMENT '문서분류',
  DOC_NO     VARCHAR(60)  NULL COMMENT '문서번호',
  DRAFT_DT   VARCHAR(8)   NULL COMMENT '기안일자',
  DRAFTER    VARCHAR(50)  NULL COMMENT '기안자',
  DEPT_NM    VARCHAR(60)  NULL COMMENT '부서',
  CHAIR_NM   VARCHAR(50)  NULL COMMENT '기안부서 위원장',
  ROOM_NM    VARCHAR(50)  NULL COMMENT '기안부서 실장',
  COOP_NM    VARCHAR(100) NULL COMMENT '협조부서',
  RECV_NM    VARCHAR(100) NULL COMMENT '수신',
  REF_NM     VARCHAR(100) NULL COMMENT '참조',
  SEND_DT    VARCHAR(8)   NULL COMMENT '발송일자',
  BODY       TEXT         NULL COMMENT '본문',
  -- 교육 (D·E 전용)
  EDU_DT     VARCHAR(60)  NULL COMMENT '교육일시(자유 표기)',
  EDU_TEACHER VARCHAR(60) NULL COMMENT '교육자',
  EDU_TARGET VARCHAR(200) NULL COMMENT '교육대상자',
  EDU_TOPIC  VARCHAR(200) NULL COMMENT '주제',
  EDU_BODY   TEXT         NULL COMMENT '교육 결과 본문',
  NOTE       TEXT         NULL COMMENT '비고',
  USE_YN     CHAR(1)     DEFAULT 'Y',
  REG_USER   VARCHAR(50) NULL,
  REG_DTTM   DATETIME    DEFAULT CURRENT_TIMESTAMP,
  UPD_USER   VARCHAR(50) NULL,
  UPD_DTTM   DATETIME    NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (RPT_SEQ),
  KEY IX_QPS_INFRPT (HOSP_CD, RPT_GB, RPT_DT, USE_YN)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='감염종합보고(3종 통합)';

CREATE TABLE IF NOT EXISTS TBL_QPS_INFRPT_MEM (
  RPT_SEQ  BIGINT      NOT NULL,
  SORT     INT         NOT NULL,
  ROLE_NM  VARCHAR(40) NULL COMMENT '역할 — 위원장/부위원장/간사/위원 (교육서식은 비움)',
  DEPT_NM  VARCHAR(60) NULL COMMENT '소속',
  MEM_NM   VARCHAR(50) NULL COMMENT '성명',
  PRIMARY KEY (RPT_SEQ, SORT)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='감염종합보고 참석자·서명 명단';

-- 서식 종류 공통코드
INSERT INTO TBL_CODE_MST (CODE_CD, JOB_SEQ, CODE_NM, START_DT, END_DT, USE_YN, ACTION_YN, REG_USER) VALUES
 ('QPS_INFRPT_GB',1,'감염종합보고 종류','20000101','99991231','Y','Y','system')
ON DUPLICATE KEY UPDATE CODE_NM=VALUES(CODE_NM), USE_YN='Y', ACTION_YN='Y';

INSERT INTO TBL_CODE_DTL (CODE_GB, CODE_CD, SUB_CODE, JOB_SEQ, SUB_CODE_NM, START_DT, END_DT, USE_YN, SORT, ACTION_YN, REG_USER) VALUES
 ('Q','QPS_INFRPT_GB','P',1,'감염관리 개선활동 계획 수립','20000101','99991231','Y',1,'Y','system'),
 ('Q','QPS_INFRPT_GB','D',1,'감염관리 개선활동 수행'    ,'20000101','99991231','Y',2,'Y','system'),
 ('Q','QPS_INFRPT_GB','E',1,'손위생 교육 결과 보고서'    ,'20000101','99991231','Y',3,'Y','system')
ON DUPLICATE KEY UPDATE SUB_CODE_NM=VALUES(SUB_CODE_NM), SORT=VALUES(SORT), USE_YN='Y', ACTION_YN='Y';
