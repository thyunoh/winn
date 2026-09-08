-- =====================================================================
-- 점검표 결재란 도장 — DDL (2026-09-08)
--   왜 : 사용자 물음 「마우스로 사인 가능한가요 / 아님 스캔 도장」 → 「결재란부터 진행해줘」.
--        점검표에 사인이 들어가는 자리는 셋인데 성격이 다르다 —
--          ① 격자의 점검자 사인 행(SIGN_NO=900) : 날짜 칸마다 이름 한 줄. **날마다 다른 사람**이 이미 된다.
--             칸 폭이 6mm 남짓(31일 격자)이라 도장을 그려도 점처럼 찍힌다 ⇒ 이번 범위에서 뺀다.
--          ② 서식 아래 결재란(FORM.SIGN_LINE) : 「점검자 ____ (인)」 빈 줄로 인쇄 — 손도장 전제.
--          ③ 상단 결재 상자(TBL_QPS_APPR_LINE 단계) : 칸만 그려지고 **누가 결재했는지 저장하지 않았다.**
--        ⇒ ③ 을 「누가 언제 결재했는지 남기고 그 사람 도장을 찍는」 자리로 만든다. 여러 사인은 여기서 자연히 풀린다
--           (점검자·관리자·원장이 각자 제 도장으로 찍고 문서마다 누구인지 남는다).
--   ⚠기존 `TBL_QPS_APPR` 는 **지표분석보고서 전용**이다(키 = INDI_CD × PRD_GB × PRD_KEY, 상신·반려가 도는 결재).
--     점검표 문서 키는 CHK_SEQ 하나라 그 표에 못 얹는다 ⇒ 표를 따로 둔다. 결재 **단계 이름**은
--     `TBL_QPS_APPR_LINE`(병원 행 없으면 공통 '*')을 그대로 쓴다 — 단계 정의가 두 벌이 되면 반드시 어긋난다.
--   더하기만 하는 DDL ⇒ 운영 선적용 안전(옛 WAR 는 두 표를 읽지도 쓰지도 않는다).
--   코드 : Qps_SQL.xml(selectQpsSign·saveQpsSign·deleteQpsSign·selectChkApprList·saveChkAppr·deleteChkAppr) ·
--          QpsMapper·QpsService(Impl)·QpsController(signGet/signSave/signDel/chkApprList/chkApprSave/chkApprDel.do) ·
--          qpsChk.jsp(화면 결재 상자 · [🖋 내 도장] · 인쇄 도장)
--   ⛔자바·매퍼가 함께 바뀐다 → **WAR 재빌드 + 재기동**. BUILD = 20260908-SIGNAPPR
-- =====================================================================

-- ── ① 사람마다 도장 하나 ───────────────────────────────────────────────
--   ★한 사람 = 한 장(HOSP_CD + USER_ID 가 키). 마우스 서명이든 스캔 도장이든 **같은 칸**에 담는다 —
--     쓰는 쪽은 「이 사람의 도장 그림」만 필요하고, 어떻게 만들었는지는 SIGN_GB 로 구분만 해 둔다.
--   ★★**본인 것만 등록·삭제한다**(서버가 로그인 계정으로 강제 — 파라미터 userId 를 믿지 않는다).
--     도장 그림은 도용되면 문서 위조가 되므로 이 규칙을 코드에서 절대 풀지 말 것.
--   ⚠그림은 **BLOB 로 DB 에** 둔다(사진첨부처럼 SFTP 로 빼지 않는다) — 한 사람에 한 장이라 양이 적고,
--     인쇄할 때 결재자 수만큼 한 번에 읽어야 해서 파일 왕복이 되레 번거롭다. 저장·조회는 joinDocs 대표자 도장과
--     같은 방식(FROM_BASE64 / TO_BASE64)이다.
CREATE TABLE IF NOT EXISTS TBL_QPS_SIGN (
  HOSP_CD    VARCHAR(20)  NOT NULL                  COMMENT '병원코드',
  USER_ID    VARCHAR(50)  NOT NULL                  COMMENT '로그인 계정 — 본인 것만',
  USER_NM    VARCHAR(100) NULL                      COMMENT '등록 당시 이름(표시용)',
  SIGN_GB    CHAR(1)      NOT NULL DEFAULT 'S'      COMMENT 'S=마우스 서명, D=스캔 도장',
  SIGN_IMG   LONGBLOB     NULL                      COMMENT '도장·서명 그림(PNG 권장, 배경 투명)',
  SIGN_MIME  VARCHAR(50)  NULL                      COMMENT 'image/png 등',
  USE_YN     CHAR(1)      NOT NULL DEFAULT 'Y'      COMMENT '내림 = N(옛 문서의 도장은 그대로 두고 새로 안 쓰기)',
  REG_USER   VARCHAR(50)  NULL,
  REG_DTTM   DATETIME     NULL DEFAULT CURRENT_TIMESTAMP,
  UPD_USER   VARCHAR(50)  NULL,
  UPD_DTTM   DATETIME     NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (HOSP_CD, USER_ID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='QPS 서명·도장 (사람마다 한 장)';

-- ── ② 점검표 문서의 결재 기록 ─────────────────────────────────────────
--   ★단계마다 한 줄(PK 에 STEP_NO). 같은 단계를 두 사람이 찍을 수 없다 — 종이 결재란과 같다.
--   ★**도장 그림을 여기 복사하지 않는다.** 찍은 사람(USER_ID)만 남기고 그림은 ① 에서 그때그때 읽는다 —
--     도장을 새로 등록하면 예전 문서도 새 도장으로 인쇄된다. 「그때 그 도장 그대로」가 필요하면
--     SIGN_IMG 사본 칸을 여기 더해야 하는데, 그건 위조 시비가 생겼을 때의 이야기라 지금은 넣지 않는다.
--   ⚠문서를 지워도(USE_YN='N') 이 줄은 남는다 — 되살렸을 때 결재가 사라져 있으면 더 곤란하다.
CREATE TABLE IF NOT EXISTS TBL_QPS_CHK_APPR (
  HOSP_CD    VARCHAR(20)  NOT NULL                  COMMENT '병원코드',
  CHK_SEQ    INT          NOT NULL                  COMMENT '점검표 문서(TBL_QPS_CHK_DOC.CHK_SEQ)',
  STEP_NO    INT          NOT NULL                  COMMENT '결재 단계(TBL_QPS_APPR_LINE.STEP_NO)',
  STEP_NM    VARCHAR(50)  NULL                      COMMENT '찍을 당시 단계 이름(뒤에 바뀌어도 종이가 안 흔들리게)',
  USER_ID    VARCHAR(50)  NULL                      COMMENT '찍은 사람 — 도장 그림은 TBL_QPS_SIGN 에서 읽는다',
  USER_NM    VARCHAR(100) NULL                      COMMENT '찍을 당시 이름',
  APPR_DTTM  DATETIME     NULL DEFAULT CURRENT_TIMESTAMP COMMENT '찍은 때',
  USE_YN     CHAR(1)      NOT NULL DEFAULT 'Y'      COMMENT '취소 = N(본인만)',
  REG_USER   VARCHAR(50)  NULL,
  REG_DTTM   DATETIME     NULL DEFAULT CURRENT_TIMESTAMP,
  UPD_USER   VARCHAR(50)  NULL,
  UPD_DTTM   DATETIME     NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (HOSP_CD, CHK_SEQ, STEP_NO),
  KEY IX_QPS_CHK_APPR_DOC (HOSP_CD, CHK_SEQ)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='점검표 문서 결재 기록 (단계마다 한 줄)';

-- ── ③ 보정 — CHK_SEQ 는 BIGINT 여야 한다 (2026-09-08, 만든 직후 실측으로 잡음) ──
--   ⚠처음에 INT 로 적었는데 `TBL_QPS_CHK_DOC.CHK_SEQ` 는 **BIGINT** 다. 지금은 문서 번호가 작아 티가 안 나지만
--     번호가 21억을 넘으면 결재 기록이 **엉뚱한 문서에 붙는다**(조용히 잘려 들어간다).
--   ★이 파일은 **다시 돌려도 안전**하다(CREATE 는 IF NOT EXISTS, 아래 ALTER 는 같은 형이면 그대로).
--   ★규칙 : 남의 표를 가리키는 칸은 **그 표의 형을 그대로 베낀다** — INFORMATION_SCHEMA 로 확인하고 적을 것.
ALTER TABLE TBL_QPS_CHK_APPR
  MODIFY COLUMN CHK_SEQ BIGINT NOT NULL COMMENT '점검표 문서(TBL_QPS_CHK_DOC.CHK_SEQ)';

-- ── 확인 ──────────────────────────────────────────────────────────────
-- SELECT COUNT(*) AS sign_cnt FROM TBL_QPS_SIGN;
-- SELECT COUNT(*) AS appr_cnt FROM TBL_QPS_CHK_APPR;
-- SELECT STEP_NO, STEP_NM FROM TBL_QPS_APPR_LINE WHERE HOSP_CD='*' AND USE_YN='Y' ORDER BY STEP_NO;
