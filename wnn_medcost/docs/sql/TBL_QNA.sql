-- ============================================================================
-- 적정성평가 Q&A 챗봇 지식베이스 (2026-08-04)
--   · 기존: qnaChat.jsp 안의 JS 배열(WQA_KB) 하드코딩 44건
--   · 변경: DB 보관 → 화면은 조회만. 지식 추가/수정이 JSP 배포 없이 가능해진다.
--   · 원문: 「2022 요양병원 수가 실무교육자료」(건강보험심사평가원) 전문을
--            장(대분류) · 절(중분류) · 항목(질문) 단위로 나눠 적재.
--
-- 실행순서 : ① 이 파일(DDL)  ② TBL_QNA_seed.sql(카테고리·지식 데이터)
-- 문자셋   : DB 기본 utf8mb4 (MySQL 8.0) — 한글 검색을 위해 ngram 전문색인 사용
-- ============================================================================

-- ── 1. 카테고리 (대분류 = P_CAT_ID IS NULL, 중분류 = P_CAT_ID 있음) ──────────
CREATE TABLE IF NOT EXISTS TBL_QNA_CAT (
  CAT_ID    VARCHAR(24)  NOT NULL              COMMENT '카테고리ID (예 PDF_PVAL, PDF_PVAL_05)',
  P_CAT_ID  VARCHAR(24)      NULL              COMMENT '상위 카테고리ID — NULL이면 대분류',
  CAT_NM    VARCHAR(120) NOT NULL              COMMENT '카테고리명(화면 표시)',
  CAT_DESC  VARCHAR(300)     NULL              COMMENT '어떤 내용이 들어있는지 한 줄 안내',
  SRC_TYPE  VARCHAR(10)  NOT NULL DEFAULT 'IN' COMMENT 'IN=위너넷 확정지식 / PDF=심평원 원문',
  SORT_NO   INT          NOT NULL DEFAULT 0    COMMENT '정렬순서',
  USE_YN    CHAR(1)      NOT NULL DEFAULT 'Y'  COMMENT '사용여부',
  REG_DTTM  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UPD_DTTM  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (CAT_ID),
  KEY IX_QNA_CAT_P (P_CAT_ID, SORT_NO)
) ENGINE=InnoDB COMMENT='적정성평가 Q&A 카테고리(대·중분류)';

-- ── 2. 지식(질문 한 건 = 한 행) ────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS TBL_QNA_KB (
  KB_ID       INT          NOT NULL AUTO_INCREMENT,
  KB_CODE     VARCHAR(40)  NOT NULL              COMMENT '고유코드 (사내카드는 기존 id, 원문은 pdf-NNNN)',
  CAT_ID      VARCHAR(24)  NOT NULL              COMMENT '대분류',
  SUB_ID      VARCHAR(24)      NULL              COMMENT '중분류(없으면 NULL)',
  SRC_TYPE    VARCHAR(10)  NOT NULL              COMMENT 'IN=위너넷 확정 / PDF=심평원 원문',
  KIND        VARCHAR(10)  NOT NULL              COMMENT 'CARD=사내카드 QA=질의응답 ITEM=항목해설 RAW=원문(표)',
  TITLE       VARCHAR(400) NOT NULL              COMMENT '질문(항목명)',
  SHORT_TITLE VARCHAR(160)     NULL              COMMENT '목록에 뿌릴 짧은 제목',
  KEYWORDS    VARCHAR(600)     NULL              COMMENT '검색용 동의어·낱말(공백 구분)',
  BODY        MEDIUMTEXT   NOT NULL              COMMENT '답변 본문 (사내카드=줄당 HTML, 원문=평문·줄바꿈 보존)',
  GO_JSON     VARCHAR(600)     NULL              COMMENT '관련화면 이동 버튼 [{n,u,s}] JSON',
  REL_IDS     VARCHAR(300)     NULL              COMMENT '연관 질문 KB_CODE 목록(콤마)',
  SRC_NM      VARCHAR(300)     NULL              COMMENT '근거 표기(화면 하단 "근거 ·")',
  DOC_PAGE    INT          NOT NULL DEFAULT 0    COMMENT '원문 쪽번호(인쇄본 기준, 0=해당없음)',
  WEIGHT      INT          NOT NULL DEFAULT 5    COMMENT '검색 가중치 — 사내카드 20, 원문 3~10',
  HIT_CNT     INT          NOT NULL DEFAULT 0    COMMENT '조회수(자주하는 질문 순위 산출)',
  USE_YN      CHAR(1)      NOT NULL DEFAULT 'Y',
  REG_DTTM    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UPD_DTTM    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  SORT_NO     INT          NOT NULL DEFAULT 0,
  PRIMARY KEY (KB_ID),
  UNIQUE KEY UX_QNA_KB_CODE (KB_CODE),
  KEY IX_QNA_KB_CAT (CAT_ID, SUB_ID, SORT_NO),
  KEY IX_QNA_KB_HIT (USE_YN, HIT_CNT DESC),
  FULLTEXT KEY FX_QNA_KB (TITLE, KEYWORDS, BODY) WITH PARSER ngram
) ENGINE=InnoDB COMMENT='적정성평가 Q&A 지식베이스';

-- ── 3. 질문 로그 (자주하는 질문 순위 + 답 못 찾은 질문 수집) ─────────────────
--    ★ 못 찾은 질문(MATCH_YN='N')이 곧 다음에 채워 넣어야 할 지식 목록이다.
CREATE TABLE IF NOT EXISTS TBL_QNA_LOG (
  LOG_ID    BIGINT       NOT NULL AUTO_INCREMENT,
  HOSP_CD   VARCHAR(20)      NULL              COMMENT '요양기관기호',
  USER_ID   VARCHAR(50)      NULL,
  Q_TEXT    VARCHAR(500) NOT NULL              COMMENT '사용자가 실제로 친 질문',
  KB_ID     INT              NULL              COMMENT '답으로 준 지식',
  MATCH_YN  CHAR(1)      NOT NULL DEFAULT 'N'  COMMENT 'Y=답을 찾음 / N=못 찾음',
  ASK_TYPE  VARCHAR(10)  NOT NULL DEFAULT 'TYPE' COMMENT 'TYPE=직접입력 PICK=목록선택 REL=연관질문',
  REG_DTTM  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (LOG_ID),
  KEY IX_QNA_LOG_DT (REG_DTTM),
  KEY IX_QNA_LOG_KB (KB_ID),
  KEY IX_QNA_LOG_MATCH (MATCH_YN, REG_DTTM)
) ENGINE=InnoDB COMMENT='적정성평가 Q&A 질문 로그';
