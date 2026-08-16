-- =====================================================================
-- QPS 담당자 지정 (2026-08-10) — 자료실(조직도·내규) 수정 권한
--
--   ★왜: 자료실은 규정·내규가 들어가는 곳이라 "아무나 지우면 안 된다"(2026-08-10 요청).
--     보기·내려받기는 병원 전원, **올리기·지우기는 담당자만**.
--   ★왜 MAIN_GU 만으로 안 되나: MAIN_GU(3=병원관리자)는 병원 전산 담당이지 QPS 담당자가 아니다.
--     간호부의 QPS 담당자가 4(병원사용자)인 경우가 흔해 별도 지정이 필요하다.
--   ★락아웃 방지: 이 표에 **한 명도 없으면** 병원관리자(MAIN_GU 1·2·3)가 수정할 수 있다.
--     한 명이라도 지정되면 그때부터 지정된 사람만(+위너넷 계정은 지원 목적으로 항상 가능).
--     → 신규 병원이 "아무도 못 고치는" 상태로 시작하지 않게 하려는 것.
--   재실행 안전(CREATE IF NOT EXISTS).
-- =====================================================================

CREATE TABLE IF NOT EXISTS TBL_QPS_MGR (
  HOSP_CD   VARCHAR(20)  NOT NULL COMMENT '병원코드',
  USER_ID   VARCHAR(50)  NOT NULL COMMENT '사용자ID(TBL_USER_MST)',
  USE_YN    CHAR(1)      DEFAULT 'Y' COMMENT '사용여부',
  REG_USER  VARCHAR(50)  NULL COMMENT '등록자',
  REG_DTTM  DATETIME     DEFAULT CURRENT_TIMESTAMP COMMENT '등록일시',
  UPD_USER  VARCHAR(50)  NULL COMMENT '수정자',
  UPD_DTTM  DATETIME     NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일시',
  PRIMARY KEY (HOSP_CD, USER_ID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='QPS 담당자(자료실 수정 권한)';
