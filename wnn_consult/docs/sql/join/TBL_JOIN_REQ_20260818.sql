/* =====================================================================================
 * 신규병원 회원가입(가입신청 → 승인) 테이블
 *   2026-08-18 / 근거문서 : D:\위너넷\위너넷 적정성 컨설팅 의뢰서+원격연결(2026년).hwp
 *
 * [왜 만드나]
 *   지금 회원가입(TBL_MEMBER_MST)은 **TBL_HOSP_MST 에 이미 등록된 병원**만 가능하다.
 *   신규병원은 위너넷이 병원을 먼저 넣어줘야 가입할 수 있어서 순서가 거꾸로다.
 *   → 신규병원이 스스로 "가입신청 + 3가지 동의" 를 하고,
 *      위너넷이 승인하면서 병원(TBL_HOSP_MST)을 만들고 계약(TBL_HOSPCONT_MST)을 걸면
 *      그때부터 쓸 수 있게 한다.
 *
 * [프로세스]
 *   ① 신청  : TBL_JOIN_REQ (+ _MGR 담당자, + _AGREE 동의내역)   REQ_STAT='10'
 *   ② 검토  : 위너넷 담당자 확인                                  REQ_STAT='20'
 *   ③ 승인  : TBL_HOSP_MST **신규 생성(INSERT)**                  REQ_STAT='30'
 *             TBL_USER_MST **연계(사용자 등록 + CFM_* 로 키 보관)**
 *             TBL_HOSPSIGN_MST 로 동의 확정본 이관
 *             TBL_MEMBER_MST 회원행 생성
 *   ④ 계약  : 위너넷이 TBL_HOSPCONT_MST 등록(기존 화면) → 로그인 시 CONACT_GB 판정됨
 *   ⑤ 반려  : REQ_STAT='90' + RJT_RSN
 *
 * [기존 동의와의 중복 정리]  ★ 의뢰 시 지적된 "중복될 수도 있다" 부분
 *   TBL_MEMBER_MST 에 이미 3쌍(PER_USE / PER_INFO / PER_PRO)이 컬럼으로 박혀 있다.
 *   의뢰서의 3종은 [서식1]컨설팅 의뢰서 · [서식2]원격접속·DB접근 · [서식3]개인정보 수집·이용 이고,
 *   이 중 [서식3] 은 기존 PER_INFO 와 **같은 동의**다.
 *   → 동의를 컬럼이 아니라 **행(TBL_AGREE_MST + TBL_JOIN_AGREE)** 으로 바꾸고,
 *     TBL_AGREE_MST.LEGACY_COL 에 기존 컬럼명을 적어 매핑한다.
 *     기존 컬럼은 그대로 두고(화면 호환), 신규 가입건은 행 기준으로 읽는다.
 *
 * [재실행 안전]
 *   DDL 은 CREATE TABLE IF NOT EXISTS, 시드는 INSERT IGNORE / ON DUPLICATE KEY UPDATE.
 *   → 여러 번 돌려도 무해하다. 단 §7 승인 DML 은 **템플릿(주석)** 이며 그대로 돌리면 안 된다.
 *
 * [기존 테이블 변경 없음]
 *   TBL_HOSP_MST / TBL_USER_MST / TBL_MEMBER_MST 는 ALTER 하지 않는다.
 *   연계키는 전부 TBL_JOIN_REQ.CFM_* 쪽에서 들고 있는다.
 * ===================================================================================== */

/* -------------------------------------------------------------------------------------
 * 1. TBL_AGREE_MST — 동의서(약관) 마스터 : 본문·버전 관리
 *    동의 본문이 바뀌면 VER_NO 를 올려 새 행을 넣는다. 과거 동의건은 옛 버전을 그대로 가리킨다.
 * ----------------------------------------------------------------------------------- */
CREATE TABLE IF NOT EXISTS `TBL_AGREE_MST` (
  `AGREE_CD`    varchar(20)  NOT NULL                COMMENT '동의서코드(CONSULT_REQ/REMOTE_DB/PRIV_INFO/PER_USE/PER_PRO)',
  `VER_NO`      int          NOT NULL DEFAULT 1      COMMENT '버전 - 본문이 바뀌면 +1',
  `AGREE_NM`    varchar(200) DEFAULT NULL            COMMENT '동의서명',
  `FORM_NO`     varchar(20)  DEFAULT NULL            COMMENT '서식번호([서식1]/[서식2]/[서식3])',
  `ESS_YN`      varchar(1)   DEFAULT 'Y'             COMMENT '필수여부 Y.필수 N.선택',
  `SIGN_GB`     varchar(20)  DEFAULT NULL            COMMENT '승인 시 TBL_HOSPSIGN_MST.SIGN_GB 로 옮길 값',
  `LEGACY_COL`  varchar(50)  DEFAULT NULL            COMMENT '기존 TBL_MEMBER_MST 대응 컬럼 접두어(PER_USE/PER_INFO/PER_PRO) - 중복동의 매핑용',
  `AGREE_TEXT`  mediumtext                           COMMENT '동의서 전문(화면 노출용)',
  `START_DT`    varchar(8)   DEFAULT NULL            COMMENT '적용시작일자',
  `END_DT`      varchar(8)   DEFAULT NULL            COMMENT '적용종료일자',
  `SORT`        int          DEFAULT NULL            COMMENT '화면 정렬순서',
  `USE_YN`      varchar(1)   DEFAULT 'Y'             COMMENT '사용여부',
  `ACTION_YN`   varchar(1)   DEFAULT 'Y'             COMMENT 'Y.활성 N.비활성',
  `REG_DTTM`    datetime     DEFAULT CURRENT_TIMESTAMP                             COMMENT '등록일시',
  `REG_USER`    varchar(50)  DEFAULT NULL                                          COMMENT '등록자',
  `REG_IP`      varchar(20)  DEFAULT NULL                                          COMMENT '등록 IP',
  `UPD_DTTM`    datetime     DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '최종변경일시',
  `UPD_USER`    varchar(50)  DEFAULT NULL                                          COMMENT '최종변경자',
  `UPD_IP`      varchar(20)  DEFAULT NULL                                          COMMENT '최종변경 IP',
  PRIMARY KEY (`AGREE_CD`,`VER_NO`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='동의서(약관) 마스터';


/* -------------------------------------------------------------------------------------
 * 2. TBL_JOIN_REQ — 신규병원 가입신청
 *    승인 전이므로 HOSP_CD 는 **신청값**일 뿐 TBL_HOSP_MST 에 없다(FK 걸지 않는다).
 *    의뢰서 [서식1] 의 기재항목을 그대로 담는다.
 * ----------------------------------------------------------------------------------- */
CREATE TABLE IF NOT EXISTS `TBL_JOIN_REQ` (
  `REQ_NO`        bigint       NOT NULL AUTO_INCREMENT COMMENT '신청번호',
  `REQ_STAT`      varchar(2)   NOT NULL DEFAULT '10'   COMMENT '처리상태 10.접수 20.검토중 30.승인 90.반려',
  `REQ_DTTM`      datetime     DEFAULT CURRENT_TIMESTAMP COMMENT '신청일시',

  /* ── 요양기관 (의뢰서 상단) ───────────────────────────── */
  `HOSP_CD`       varchar(10)  NOT NULL               COMMENT '요양기관기호(신청값)',
  `HOSP_NM`       varchar(100) DEFAULT NULL           COMMENT '병원명',
  `HOSP_CEO`      varchar(20)  DEFAULT NULL           COMMENT '대표자',
  `BUSI_NUM`      varchar(20)  DEFAULT NULL           COMMENT '사업자등록번호',
  `ZIP_CD`        varchar(20)  DEFAULT NULL           COMMENT '우편번호',
  `HOSP_ADDR`     varchar(200) DEFAULT NULL           COMMENT '주소',
  `HOSP_EXTRADR`  varchar(200) DEFAULT NULL           COMMENT '상세주소',
  `HOSP_TEL`      varchar(20)  DEFAULT NULL           COMMENT '전화번호',
  `HOSP_FAX`      varchar(20)  DEFAULT NULL           COMMENT 'FAX',
  `WARDCNT`       int          DEFAULT NULL           COMMENT '병상수',

  /* ── 전산프로그램 정보(MASTER) : 승인 시 TBL_HOSPCONT_MST 로 이관 ── */
  `OCS_COMPANY`   varchar(100) DEFAULT NULL           COMMENT '프로그램명',
  `OCS_USER_ID`   varchar(20)  DEFAULT NULL           COMMENT '프로그램 ID',
  `OCS_USER_PW`   varbinary(500) DEFAULT NULL         COMMENT '프로그램 PW(암호화)',
  `HIRA_CERT_PW`  varbinary(500) DEFAULT NULL         COMMENT '심평원 인증서암호(암호화) ★민감',

  /* ── PC 사용여부 / 일정 ─────────────────────────────── */
  `PC_USE_GB`     varchar(1)   DEFAULT NULL           COMMENT 'PC사용 1.단독사용가능 2.단독불가 3.사용시작일지정',
  `PC_USE_TIME`   varchar(50)  DEFAULT NULL           COMMENT '단독불가 시 가능시간',
  `PC_USE_STDT`   varchar(8)   DEFAULT NULL           COMMENT 'PC사용 시작일',
  `ASQ_DAY`       varchar(2)   DEFAULT NULL           COMMENT '환자평가표 작성완료일(매월 N일)',
  `ASQ_BIGO`      varchar(100) DEFAULT NULL           COMMENT '환자평가표 작성 비고',
  `EVAL_GOAL`     varchar(100) DEFAULT NULL           COMMENT '적정성평가 목표점수 및 등급',
  `CONACT_GB`     varchar(10)  DEFAULT NULL           COMMENT '희망 계약구분 1.진료비분석 2.적정성평가 (TBL_CODE_DTL CONACT_GB)',

  /* ── 신청 계정(=총 관리자, 로그인 ID 는 이메일) ────────── */
  `EMAIL`         varchar(100) NOT NULL               COMMENT '이메일 = 로그인 ID',
  `PASS_WD`       varbinary(500) DEFAULT NULL         COMMENT '비밀번호(암호화)',
  `MBR_NM`        varchar(50)  DEFAULT NULL           COMMENT '신청자명',
  `JOB_NM`        varchar(50)  DEFAULT NULL           COMMENT '직위명',
  `MBR_TEL`       varchar(50)  DEFAULT NULL           COMMENT '신청자 전화번호',
  `BIGO`          varchar(500) DEFAULT NULL           COMMENT '비고(위너넷에 전달할 내용)',

  /* ── 승인 결과 · 기존 테이블 연계키 ─────────────────────
   *   TBL_HOSP_MST 는 승인 시 새로 만들고(CFM_HOSP_CD/CFM_JOB_SEQ),
   *   TBL_USER_MST 는 여기 4개 컬럼으로 **연계**한다(TBL_USER_MST PK 그대로).  */
  `CFM_HOSP_CD`   varchar(10)  DEFAULT NULL           COMMENT '[연계] 생성된 TBL_HOSP_MST.HOSP_CD',
  `CFM_HOSP_SEQ`  int          DEFAULT NULL           COMMENT '[연계] 생성된 TBL_HOSP_MST.JOB_SEQ',
  `HOSP_UUID`     varchar(200) DEFAULT NULL           COMMENT '[연계] 병원 UUID',
  `CFM_USER_ID`   varchar(50)  DEFAULT NULL           COMMENT '[연계] TBL_USER_MST.USER_ID',
  `CFM_USER_SEQ`  int          DEFAULT NULL           COMMENT '[연계] TBL_USER_MST.JOB_SEQ',
  `CFM_START_DT`  varchar(8)   DEFAULT NULL           COMMENT '[연계] TBL_USER_MST.START_DT',
  `CFM_DTTM`      datetime     DEFAULT NULL           COMMENT '승인일시',
  `CFM_USER`      varchar(50)  DEFAULT NULL           COMMENT '승인자',
  `RJT_RSN`       varchar(500) DEFAULT NULL           COMMENT '반려사유',

  `ACTION_YN`     varchar(1)   DEFAULT 'Y'            COMMENT 'Y.활성 N.비활성',
  `REG_DTTM`      datetime     DEFAULT CURRENT_TIMESTAMP                             COMMENT '등록일시',
  `REG_USER`      varchar(50)  DEFAULT NULL                                          COMMENT '등록자',
  `REG_IP`        varchar(50)  DEFAULT NULL                                          COMMENT '등록 IP',
  `UPD_DTTM`      datetime     DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '최종변경일시',
  `UPD_USER`      varchar(50)  DEFAULT NULL                                          COMMENT '최종변경자',
  `UPD_IP`        varchar(50)  DEFAULT NULL                                          COMMENT '최종변경 IP',
  PRIMARY KEY (`REQ_NO`),
  KEY `IX_JOIN_REQ_01` (`REQ_STAT`,`REQ_DTTM` DESC),
  KEY `IX_JOIN_REQ_02` (`HOSP_CD`,`EMAIL`),
  KEY `IX_JOIN_REQ_03` (`EMAIL`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='신규병원 가입신청';


/* -------------------------------------------------------------------------------------
 * 3. TBL_JOIN_MGR — 신청 담당자 (의뢰서 : 총 관리자 / 간호과 / 심사과 / 전산담당)
 * ----------------------------------------------------------------------------------- */
CREATE TABLE IF NOT EXISTS `TBL_JOIN_MGR` (
  `REQ_NO`     bigint      NOT NULL              COMMENT '신청번호',
  `MGR_GB`     varchar(10) NOT NULL              COMMENT '담당구분 1.총관리자 2.간호과 3.심사과 4.전산담당 9.기타',
  `MGR_SEQ`    int         NOT NULL DEFAULT 1    COMMENT '같은 구분 내 순번',
  `DEPT_NM`    varchar(50) DEFAULT NULL          COMMENT '부서',
  `JOB_NM`     varchar(50) DEFAULT NULL          COMMENT '직책',
  `MGR_NM`     varchar(50) DEFAULT NULL          COMMENT '성명',
  `MGR_TEL`    varchar(50) DEFAULT NULL          COMMENT '전화번호',
  `EMAIL`      varchar(100) DEFAULT NULL         COMMENT '이메일 주소',
  `USER_YN`    varchar(1)  DEFAULT 'N'           COMMENT '승인 시 TBL_USER_MST 사용자로 함께 만들지 여부',
  `ACTION_YN`  varchar(1)  DEFAULT 'Y'           COMMENT 'Y.활성 N.비활성',
  `REG_DTTM`   datetime    DEFAULT CURRENT_TIMESTAMP                             COMMENT '등록일시',
  `REG_USER`   varchar(50) DEFAULT NULL                                          COMMENT '등록자',
  `REG_IP`     varchar(50) DEFAULT NULL                                          COMMENT '등록 IP',
  `UPD_DTTM`   datetime    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '최종변경일시',
  `UPD_USER`   varchar(50) DEFAULT NULL                                          COMMENT '최종변경자',
  `UPD_IP`     varchar(50) DEFAULT NULL                                          COMMENT '최종변경 IP',
  PRIMARY KEY (`REQ_NO`,`MGR_GB`,`MGR_SEQ`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='가입신청 담당자';


/* -------------------------------------------------------------------------------------
 * 4. TBL_JOIN_AGREE — 신청별 동의내역 (3가지 동의가 여기 행으로 쌓인다)
 *    동의 시점의 VER_NO·IP·일시를 남겨야 나중에 "무엇에 동의했는지" 증빙이 된다.
 * ----------------------------------------------------------------------------------- */
CREATE TABLE IF NOT EXISTS `TBL_JOIN_AGREE` (
  `REQ_NO`      bigint      NOT NULL             COMMENT '신청번호',
  `AGREE_CD`    varchar(20) NOT NULL             COMMENT '동의서코드(TBL_AGREE_MST)',
  `VER_NO`      int         NOT NULL DEFAULT 1   COMMENT '동의한 본문 버전',
  `AGREE_YN`    varchar(1)  NOT NULL DEFAULT 'N' COMMENT '동의여부 Y/N',
  `READ_YN`     varchar(1)  DEFAULT 'N'          COMMENT '세부내용 열람여부(기존 PER_*_RED 대응)',
  `AGREE_DTTM`  datetime    DEFAULT CURRENT_TIMESTAMP COMMENT '동의일시',
  `AGREE_IP`    varchar(50) DEFAULT NULL         COMMENT '동의 IP',
  `AGREE_NM`    varchar(50) DEFAULT NULL         COMMENT '동의자명(날인자)',
  `REG_DTTM`    datetime    DEFAULT CURRENT_TIMESTAMP                             COMMENT '등록일시',
  `REG_USER`    varchar(50) DEFAULT NULL                                          COMMENT '등록자',
  `UPD_DTTM`    datetime    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '최종변경일시',
  `UPD_USER`    varchar(50) DEFAULT NULL                                          COMMENT '최종변경자',
  PRIMARY KEY (`REQ_NO`,`AGREE_CD`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='가입신청 동의내역';


/* -------------------------------------------------------------------------------------
 * 5. TBL_JOIN_HIS — 처리이력 (접수→검토→승인/반려)
 * ----------------------------------------------------------------------------------- */
CREATE TABLE IF NOT EXISTS `TBL_JOIN_HIS` (
  `REQ_NO`     bigint      NOT NULL              COMMENT '신청번호',
  `HIS_SEQ`    int         NOT NULL              COMMENT '이력순번',
  `BEF_STAT`   varchar(2)  DEFAULT NULL          COMMENT '이전상태',
  `AFT_STAT`   varchar(2)  DEFAULT NULL          COMMENT '변경상태',
  `HIS_MEMO`   varchar(500) DEFAULT NULL         COMMENT '처리메모/반려사유',
  `REG_DTTM`   datetime    DEFAULT CURRENT_TIMESTAMP COMMENT '처리일시',
  `REG_USER`   varchar(50) DEFAULT NULL          COMMENT '처리자',
  `REG_IP`     varchar(50) DEFAULT NULL          COMMENT '처리 IP',
  PRIMARY KEY (`REQ_NO`,`HIS_SEQ`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='가입신청 처리이력';


/* =====================================================================================
 * 6. 시드 — 동의서 5종 + 공통코드
 *    ON DUPLICATE KEY UPDATE 라 다시 돌려도 안전하나, 본문을 화면에서 고쳤다면
 *    다시 돌리는 순간 되돌아간다. AGREE_TEXT 는 요약만 넣어두고 정본은 화면/파일로 관리할 것.
 * ===================================================================================== */

/* 6-1. 동의서 마스터 — 앞 3건이 의뢰서의 "세 가지", 뒤 2건은 기존 회원가입 약관 */
INSERT INTO `TBL_AGREE_MST`
      (`AGREE_CD`,`VER_NO`,`AGREE_NM`,`FORM_NO`,`ESS_YN`,`SIGN_GB`,`LEGACY_COL`,`START_DT`,`SORT`,`USE_YN`,`REG_USER`)
VALUES
      ('CONSULT_REQ',1,'컨설팅 의뢰서'                 ,'[서식1]','Y','CONSULT_REQ',NULL          ,'20260101',1,'Y','SYSTEM'),
      ('REMOTE_DB'  ,1,'원격접속 및 DB접근에 관한 동의서','[서식2]','Y','REMOTE_DB'  ,NULL          ,'20260101',2,'Y','SYSTEM'),
      ('PRIV_INFO'  ,1,'개인정보 수집 및 이용에 관한 동의서','[서식3]','Y','PRIV_INFO','PER_INFO'   ,'20260101',3,'Y','SYSTEM'),
      ('PER_USE'    ,1,'이용약관'                      ,NULL    ,'Y','PER_USE'    ,'PER_USE'     ,'20260101',4,'Y','SYSTEM'),
      ('PER_PRO'    ,1,'개인정보 처리위탁 동의'          ,NULL    ,'N','PER_PRO'    ,'PER_PRO'     ,'20260101',5,'Y','SYSTEM')
ON DUPLICATE KEY UPDATE
      `AGREE_NM`   = VALUES(`AGREE_NM`),
      `FORM_NO`    = VALUES(`FORM_NO`),
      `ESS_YN`     = VALUES(`ESS_YN`),
      `SIGN_GB`    = VALUES(`SIGN_GB`),
      `LEGACY_COL` = VALUES(`LEGACY_COL`),
      `SORT`       = VALUES(`SORT`),
      `USE_YN`     = VALUES(`USE_YN`);

/* 6-2. 공통코드 대표 */
INSERT IGNORE INTO `TBL_CODE_MST` (`CODE_CD`,`JOB_SEQ`,`CODE_NM`,`START_DT`,`END_DT`,`USE_YN`,`SORT`,`REG_USER`)
VALUES ('REQ_STAT' ,1,'가입신청 처리상태','20260101','29991231','Y',1,'SYSTEM'),
       ('MGR_GB'   ,1,'가입신청 담당구분','20260101','29991231','Y',2,'SYSTEM'),
       ('PC_USE_GB',1,'PC 사용여부'      ,'20260101','29991231','Y',3,'SYSTEM');

/* 6-3. 공통코드 상세 (CODE_GB='Z' 는 기존 관례) */
INSERT IGNORE INTO `TBL_CODE_DTL` (`CODE_GB`,`CODE_CD`,`SUB_CODE`,`JOB_SEQ`,`SUB_CODE_NM`,`START_DT`,`END_DT`,`USE_YN`,`SORT`,`REG_USER`)
VALUES ('Z','REQ_STAT' ,'10',1,'접수'            ,'20260101','29991231','Y',1,'SYSTEM'),
       ('Z','REQ_STAT' ,'20',1,'검토중'          ,'20260101','29991231','Y',2,'SYSTEM'),
       ('Z','REQ_STAT' ,'30',1,'승인'            ,'20260101','29991231','Y',3,'SYSTEM'),
       ('Z','REQ_STAT' ,'90',1,'반려'            ,'20260101','29991231','Y',4,'SYSTEM'),
       ('Z','MGR_GB'   ,'1' ,1,'총 관리자'        ,'20260101','29991231','Y',1,'SYSTEM'),
       ('Z','MGR_GB'   ,'2' ,1,'간호과'          ,'20260101','29991231','Y',2,'SYSTEM'),
       ('Z','MGR_GB'   ,'3' ,1,'심사과'          ,'20260101','29991231','Y',3,'SYSTEM'),
       ('Z','MGR_GB'   ,'4' ,1,'전산담당'         ,'20260101','29991231','Y',4,'SYSTEM'),
       ('Z','MGR_GB'   ,'9' ,1,'기타'            ,'20260101','29991231','Y',9,'SYSTEM'),
       ('Z','PC_USE_GB','1' ,1,'단독사용가능'      ,'20260101','29991231','Y',1,'SYSTEM'),
       ('Z','PC_USE_GB','2' ,1,'단독불가'         ,'20260101','29991231','Y',2,'SYSTEM'),
       ('Z','PC_USE_GB','3' ,1,'PC사용 시작일 지정','20260101','29991231','Y',3,'SYSTEM');


/* =====================================================================================
 * 7. 승인 처리 템플릿  ★ 참고용 — 여기서 그대로 실행하지 말 것
 *    실제로는 서비스 계층에서 한 트랜잭션으로 묶는다.
 *    핵심 : TBL_HOSP_MST 는 **만들고**, TBL_USER_MST 는 **연계한다**.
 * =====================================================================================

SET @REQ_NO   = 1;               -- 승인할 신청번호
SET @CFM_USER = 'wnnadmin';      -- 승인자
SET @TODAY    = DATE_FORMAT(NOW(),'%Y%m%d');

START TRANSACTION;

-- (1) 병원 생성 : TBL_HOSP_MST INSERT  ─ 이미 있으면 승인 막고 기존 병원에 사용자만 붙일 것
INSERT INTO TBL_HOSP_MST
     ( HOSP_CD, JOB_SEQ, HOSP_NM, HOSP_ADDR, HOSP_EXTRADR, HOSP_CEO, BUSI_NUM,
       ZIP_CD, HOSP_TEL, HOSP_FAX, START_DT, END_DT, JOIN_DT, ACCEPT_DT,
       USE_YN, ACTION_YN, WARDCNT, HOSP_UUID, WINNER_YN, REG_DTTM, REG_USER )
SELECT R.HOSP_CD, 1, R.HOSP_NM, R.HOSP_ADDR, R.HOSP_EXTRADR, R.HOSP_CEO, R.BUSI_NUM,
       R.ZIP_CD, R.HOSP_TEL, R.HOSP_FAX, @TODAY, '20991231', @TODAY, @TODAY,
       'Y','Y', R.WARDCNT, IFNULL(R.HOSP_UUID, UUID()), 'N', NOW(), @CFM_USER
  FROM TBL_JOIN_REQ R
 WHERE R.REQ_NO = @REQ_NO
   AND NOT EXISTS (SELECT 1 FROM TBL_HOSP_MST H WHERE H.HOSP_CD = R.HOSP_CD AND H.ACTION_YN='Y');

-- (2) 사용자 연계 : TBL_USER_MST 등록 (MAIN_GU='3' 병원관리자, MBR_JOIN='Y')
INSERT INTO TBL_USER_MST
     ( HOSP_CD, USER_ID, JOB_SEQ, USER_NM, START_DT, END_DT, MAIN_GU, PASS_WD, PASS_CDT,
       EMAIL, USER_TEL, USE_YN, MBR_JOIN, HOSP_UUID, ACTION_YN, REG_DTTM, REG_USER )
SELECT R.HOSP_CD, R.EMAIL,
       (SELECT IFNULL(MAX(U.JOB_SEQ),0)+1 FROM TBL_USER_MST U
         WHERE U.HOSP_CD = R.HOSP_CD AND U.USER_ID = R.EMAIL),
       R.MBR_NM, @TODAY, '20991231', '3', R.PASS_WD, CURDATE(),
       R.EMAIL, R.MBR_TEL, 'Y', 'Y', H.HOSP_UUID, 'Y', NOW(), @CFM_USER
  FROM TBL_JOIN_REQ R
  JOIN TBL_HOSP_MST H ON H.HOSP_CD = R.HOSP_CD AND H.ACTION_YN='Y'
 WHERE R.REQ_NO = @REQ_NO;

-- (3) 회원행 생성 : TBL_MEMBER_MST — 동의는 행(TBL_JOIN_AGREE)이 정본, 여기는 화면 호환용 요약
INSERT INTO TBL_MEMBER_MST
     ( HOSP_CD, EMAIL, HOSP_NM, PASS_WD, MBR_NM, JOB_NM, MBR_TEL, USER_ID, USE_YN,
       PER_USE_CD,  PER_USE_YN,  PER_INFO_CD, PER_INFO_YN, PER_PRO_CD, PER_PRO_YN,
       HOSP_UUID, JOIN_DT, REG_DTTM, REG_USER )
SELECT R.HOSP_CD, R.EMAIL, R.HOSP_NM, R.PASS_WD, R.MBR_NM, R.JOB_NM, R.MBR_TEL, R.EMAIL, 'Y',
       'PER_USE'  , IFNULL((SELECT A.AGREE_YN FROM TBL_JOIN_AGREE A WHERE A.REQ_NO=R.REQ_NO AND A.AGREE_CD='PER_USE'  ),'N'),
       'PER_INFO' , IFNULL((SELECT A.AGREE_YN FROM TBL_JOIN_AGREE A WHERE A.REQ_NO=R.REQ_NO AND A.AGREE_CD='PRIV_INFO'),'N'),
       'PER_PRO'  , IFNULL((SELECT A.AGREE_YN FROM TBL_JOIN_AGREE A WHERE A.REQ_NO=R.REQ_NO AND A.AGREE_CD='PER_PRO'  ),'N'),
       H.HOSP_UUID, @TODAY, NOW(), @CFM_USER
  FROM TBL_JOIN_REQ R
  JOIN TBL_HOSP_MST H ON H.HOSP_CD = R.HOSP_CD AND H.ACTION_YN='Y'
 WHERE R.REQ_NO = @REQ_NO;

-- (4) 동의 확정본 이관 : 기존 TBL_HOSPSIGN_MST(병원단위 동의)로 복사
INSERT INTO TBL_HOSPSIGN_MST (HOSP_CD, SIGN_GB, SIGN_YN, SIGN_USER_ID, REG_DTTM, REG_USER)
SELECT R.HOSP_CD, M.SIGN_GB, A.AGREE_YN, R.EMAIL, NOW(), @CFM_USER
  FROM TBL_JOIN_AGREE A
  JOIN TBL_JOIN_REQ   R ON R.REQ_NO   = A.REQ_NO
  JOIN TBL_AGREE_MST  M ON M.AGREE_CD = A.AGREE_CD AND M.VER_NO = A.VER_NO
 WHERE A.REQ_NO = @REQ_NO
ON DUPLICATE KEY UPDATE SIGN_YN = VALUES(SIGN_YN), UPD_DTTM = NOW(), UPD_USER = @CFM_USER;

-- (5) 신청 상태 갱신 + 연계키 보관
UPDATE TBL_JOIN_REQ R
   JOIN TBL_HOSP_MST H ON H.HOSP_CD = R.HOSP_CD AND H.ACTION_YN='Y'
   JOIN TBL_USER_MST U ON U.HOSP_CD = R.HOSP_CD AND U.USER_ID = R.EMAIL AND U.ACTION_YN='Y'
    SET R.REQ_STAT     = '30',
        R.CFM_HOSP_CD  = H.HOSP_CD,
        R.CFM_HOSP_SEQ = H.JOB_SEQ,
        R.HOSP_UUID    = H.HOSP_UUID,
        R.CFM_USER_ID  = U.USER_ID,
        R.CFM_USER_SEQ = U.JOB_SEQ,
        R.CFM_START_DT = U.START_DT,
        R.CFM_DTTM     = NOW(),
        R.CFM_USER     = @CFM_USER
  WHERE R.REQ_NO = @REQ_NO;

-- (6) 이력
INSERT INTO TBL_JOIN_HIS (REQ_NO, HIS_SEQ, BEF_STAT, AFT_STAT, HIS_MEMO, REG_USER)
SELECT @REQ_NO, IFNULL(MAX(HIS_SEQ),0)+1, '20', '30', '승인 - 병원/사용자 생성', @CFM_USER
  FROM TBL_JOIN_HIS WHERE REQ_NO = @REQ_NO;

COMMIT;

-- (7) 계약은 승인 뒤 위너넷이 기존 화면에서 TBL_HOSPCONT_MST 에 등록한다.
--     이때 프로그램 정보(OCS_*)는 신청건에서 가져다 쓴다.
--     계약이 없으면 로그인은 되지만 CONACT_GB='N' 이라 메뉴가 열리지 않는다.

===================================================================================== */
