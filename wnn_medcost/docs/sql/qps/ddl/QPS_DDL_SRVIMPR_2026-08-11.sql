-- =====================================================================
-- 만족도 개선활동 결과보고서 (만족도 사이클 #6) — 2026-08-11
--
--   원본은 `(원무)` `(원무2)` `(간호)` `(영양)` 4종이 따로 있으나 **서식은 하나다.**
--   실측(2026-08-10)으로 확인된 것 :
--     · (원무)  = 본판 1p 와 완전히 같다 — 유형 `병원 의료 관련`
--     · (원무2) = 같은 부서인데 유형이 `시설 및 환경`
--     · (간호)  = 유형 `간병 서비스 관련`
--     · (영양)  = ***유형 칸이 비어 있고*** 표 위에 자유 입력줄이 하나 더 있다
--   ⇒ 이름 뒤 숫자(원무2)는 연번이 아니라 **유형이 다르다는 표시**다.
--     그래서 저장 단위는 (병원, 연도, 부서, 유형) — 부서 하나에 유형이 여럿 붙는다.
--     ***연번으로 오해하면 키 설계가 통째로 틀어진다.***
--
--   ★유형은 코드값으로 고정하지 않는다(VARCHAR).
--     설문 4개 영역(환경·친절성·서비스·의료만족)에 딱 맞지 않는 부서는 비워 두고 자유 문구를 쓴다((영양) 사례).
--     화면은 「선택 + 직접입력」 둘 다 허용한다.
--
--   ★개선사진 = 공통 첨부 재사용. REF_GB='SRVIMPR', REF_KEY = IMPR_SEQ.
--     원본은 표의 마지막 칸이 사진이지만 v1 은 **문서 단위 첨부**로 둔다
--     (행 단위 이미지는 위젯을 행마다 띄워야 해서 비용이 크다 — 필요해지면 그때).
--
--   재실행 안전(CREATE IF NOT EXISTS).
-- =====================================================================

CREATE TABLE IF NOT EXISTS TBL_QPS_SRVIMPR (
  IMPR_SEQ  BIGINT       NOT NULL AUTO_INCREMENT,
  HOSP_CD   VARCHAR(20)  NOT NULL COMMENT '병원코드',
  IN_YEAR   CHAR(4)      NOT NULL COMMENT '연도',
  DEPT_NM   VARCHAR(60)  NOT NULL DEFAULT '' COMMENT '부서명 (원무·간호·영양 …)',
  TYPE_NM   VARCHAR(100) NOT NULL DEFAULT '' COMMENT '유형 (병원 의료 관련·시설 및 환경·간병 서비스 관련 / 비워 둘 수 있음)',
  TOPIC     VARCHAR(300) NULL COMMENT '주제 (영양 버전의 표 위 자유 입력줄도 여기)',
  PROBLEM   TEXT         NULL COMMENT '문제진술',
  ANALYSIS  TEXT         NULL COMMENT '현상파악 및 원인분석',
  PLAN_TXT  TEXT         NULL COMMENT '개선 대책안',
  IMPR_DT   VARCHAR(8)   NULL COMMENT '개선일시 (개선방안 적용·Action·개선지속)',
  RPT_DT    VARCHAR(8)   NULL COMMENT '보고일',
  USE_YN    CHAR(1)      NOT NULL DEFAULT 'Y',
  REG_USER  VARCHAR(50)  NULL,
  REG_DTTM  DATETIME     NULL DEFAULT CURRENT_TIMESTAMP,
  UPD_USER  VARCHAR(50)  NULL,
  UPD_DTTM  DATETIME     NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (IMPR_SEQ),
  -- ★유니크를 걸지 않는다. 같은 부서·유형으로 두 장을 쓰는 병원이 있을 수 있고,
  --   막았다가 저장이 조용히 실패하는 쪽이 더 나쁘다(계획서·라운딩에서 겪은 문제의 반대편).
  KEY IX_QPS_SRVIMPR (HOSP_CD, IN_YEAR, USE_YN)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='만족도 개선활동 결과보고서';

-- 표 : 유형 | 의료서비스만족도 문제점 | 개선활동
--   머리의 TYPE_NM 이 기본값이고, 행마다 다르게 적을 수도 있게 행에도 유형 칸을 둔다.
CREATE TABLE IF NOT EXISTS TBL_QPS_SRVIMPR_ITEM (
  IMPR_SEQ  BIGINT       NOT NULL,
  SORT      INT          NOT NULL,
  TYPE_NM   VARCHAR(100) NULL COMMENT '유형(비우면 머리의 유형)',
  PROBLEM   TEXT         NULL COMMENT '의료서비스만족도 문제점',
  ACTION_TXT TEXT        NULL COMMENT '개선활동',
  PRIMARY KEY (IMPR_SEQ, SORT)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='만족도 개선활동 결과보고서 — 문제점·개선활동 표';


-- ── 유형 공통코드 ───────────────────────────────────────────────────
--   설문지의 4개 영역과 대응한다. ★고정 목록이 아니다 — 화면은 「선택 + 직접입력」이고
--   여기 없는 문구를 적어도 그대로 저장된다((영양) 버전이 그렇다).
INSERT INTO TBL_CODE_MST (CODE_CD, JOB_SEQ, CODE_NM, START_DT, END_DT, USE_YN, ACTION_YN, REG_USER) VALUES
 ('QPS_SRVIMPR_TYPE',1,'만족도 개선활동 유형','20000101','99991231','Y','Y','system')
ON DUPLICATE KEY UPDATE CODE_NM=VALUES(CODE_NM), USE_YN='Y', ACTION_YN='Y';

INSERT INTO TBL_CODE_DTL (CODE_GB, CODE_CD, SUB_CODE, JOB_SEQ, SUB_CODE_NM, START_DT, END_DT, USE_YN, SORT, ACTION_YN, REG_USER) VALUES
 ('Q','QPS_SRVIMPR_TYPE','병원 의료 관련'  ,1,'병원 의료 관련'  ,'20000101','99991231','Y',1,'Y','system'),
 ('Q','QPS_SRVIMPR_TYPE','시설 및 환경'    ,1,'시설 및 환경'    ,'20000101','99991231','Y',2,'Y','system'),
 ('Q','QPS_SRVIMPR_TYPE','직원 친절성'     ,1,'직원 친절성'     ,'20000101','99991231','Y',3,'Y','system'),
 ('Q','QPS_SRVIMPR_TYPE','간병 서비스 관련',1,'간병 서비스 관련','20000101','99991231','Y',4,'Y','system')
ON DUPLICATE KEY UPDATE SUB_CODE_NM=VALUES(SUB_CODE_NM), SORT=VALUES(SORT), USE_YN='Y', ACTION_YN='Y';
