/* =====================================================================================
 * ⛔ 보류 — 아직 돌리지 않는다 (2026-08-19 결정)
 *    도장·사인은 **1차 오픈 범위 밖**이다. 가입신청 → 승인 → 계약은 앞 스크립트
 *    (TBL_JOIN_REQ_20260818.sql)만으로 돌아간다. 여기 표는 전부 **새 표**라
 *    나중에 붙여도 기존 스키마를 건드리지 않는다.
 *    단 §4 는 TBL_AGREE_MST 에 ALTER 를 하므로, 그때 함께 돌린다.
 *    1차는 체크 동의 + 본인확인(이메일)으로 받고, 종이 날인이 필요한 병원은
 *    지금처럼 서식을 출력해 받아 둔다.
 * =====================================================================================
 *
 * 가입신청 인영(도장·사인) 등록 + 동의서 연동
 *   2026-08-19 / 선행 : TBL_JOIN_REQ_20260818.sql (DDL 반영 완료)
 *
 * [방식]  병원에서 **도장 이미지를 한 번 받아** 두고, 그 이미지를 동의서에 **연동**한다.
 *
 *   ┌ TBL_JOIN_SEAL ┐   인영 원본 1건 (도장 이미지 / 대표자 사인)
 *   └───────┬───────┘
 *           │ SEAL_SEQ 로 참조
 *   ┌───────┴───────┐
 *   │ TBL_JOIN_SIGN │   동의서마다 "이 인영을 여기에 찍었다" 한 행
 *   └───────────────┘   [서식1] [서식2] [서식3] … 각각 1행
 *
 * [왜 갈랐나]
 *   의뢰서 [서식2] 원격접속·DB접근, [서식3] 개인정보 수집·이용은 **각각** 끝에
 *   「요양기관명 : ___  대표자 : ___ (인)」 이 붙는다. 서명은 동의서마다 필요하다.
 *   그런데 **도장은 하나**다. 이미지를 동의서마다 복사해 넣으면
 *     · 같은 도장이 3벌 중복 저장되고
 *     · 병원이 도장을 바꾸면 3군데를 고쳐야 하고
 *     · 셋 중 하나만 안 바뀌는 사고가 난다.
 *   → 원본은 한 곳(TBL_JOIN_SEAL), 동의서는 그걸 가리키기만 한다(TBL_JOIN_SIGN).
 *
 * [연동 = 좌표에 얹기]
 *   도장 찍히는 자리는 서식마다 고정이다. 그래서 기본좌표는 동의서 마스터가 들고 있고
 *   (TBL_AGREE_MST.SEAL_*), 개별 건에서 옮겼으면 TBL_JOIN_SIGN 의 좌표가 이긴다.
 *   좌표는 **%(문서 폭·높이 대비)** 다. mm/px 로 두면 A4·해상도 바뀔 때 다 틀어진다.
 *
 * [★ 도장 이미지를 서버가 갖는다는 뜻]
 *   한 번 받아두면 시스템이 **언제든 아무 문서에나 찍을 수 있다**. 그래서 규칙을 못박는다.
 *     1) 서버가 임의로 찍지 않는다. 병원이 화면에서 "이 동의서에 날인" 을 누른 건만
 *        TBL_JOIN_SIGN 에 행이 생긴다. 행이 없으면 날인 안 된 것이다.
 *     2) 누를 때마다 누가·언제·어디서(SIGN_DTTM/IP/USER_AGENT)를 남긴다.
 *     3) 승인 후 재사용(TBL_HOSPSEAL_MST 승계)은 REUSE_YN='Y' 를 병원이 직접 체크한
 *        건만. 체크 안 했으면 가입 끝나고 원본을 지운다(§보존기간).
 *     4) 이미지는 웹루트 밖 / 다운로드는 권한 확인 후 컨트롤러 경유. URL 직접노출 금지.
 *
 * [재실행 안전]
 *   CREATE TABLE IF NOT EXISTS / INSERT IGNORE 는 여러 번 돌려도 무해.
 *   ★ 단 §4 ALTER TABLE 은 MySQL 8 이 ADD COLUMN IF NOT EXISTS 를 지원하지 않아
 *     두 번 돌리면 "Duplicate column name" 이 난다. 한 번만 돌린다(에러 나면 이미 된 것).
 *   ★ 앞서 배포한 TBL_JOIN_SIGN(이미지 컬럼을 직접 들고 있던 버전)을 이미 만들었다면,
 *     자료가 없을 때 DROP TABLE TBL_JOIN_SIGN; 하고 이 스크립트를 돌린다.
 * ===================================================================================== */


/* -------------------------------------------------------------------------------------
 * 1. TBL_JOIN_SEAL — 인영 원본 (신청 1건에 보통 1~2개 : 대표자 사인 / 기관 직인)
 * ----------------------------------------------------------------------------------- */
CREATE TABLE IF NOT EXISTS `TBL_JOIN_SEAL` (
  `REQ_NO`      bigint       NOT NULL              COMMENT '신청번호(TBL_JOIN_REQ)',
  `SEAL_SEQ`    int          NOT NULL DEFAULT 1    COMMENT '인영 순번(교체 시 +1, 옛 것은 ACTION_YN=N)',

  `SEAL_GB`     varchar(1)   NOT NULL DEFAULT '2'  COMMENT '1.대표자 사인 2.기관 직인(도장)',
  `SEAL_NM`     varchar(50)  DEFAULT NULL          COMMENT '명칭(대표자명 / 기관 직인명)',
  `IMG_GB`      varchar(1)   DEFAULT '1'           COMMENT '1.업로드(도장 스캔) 2.화면 캔버스 사인',

  `SEAL_IMG`    mediumblob                         COMMENT '인영 이미지 원본 ★배경투명 PNG 권장',
  `SEAL_MIME`   varchar(50)  DEFAULT NULL          COMMENT 'image/png, image/jpeg',
  `SEAL_HASH`   varchar(64)  DEFAULT NULL          COMMENT 'SHA-256(hex) - 바꿔치기 대조용',
  `IMG_W`       int          DEFAULT NULL          COMMENT '원본 가로 px',
  `IMG_H`       int          DEFAULT NULL          COMMENT '원본 세로 px',
  `FILE_NM`     varchar(200) DEFAULT NULL          COMMENT '업로드 원본 파일명',
  `FILE_SIZE`   bigint       DEFAULT NULL          COMMENT '바이트',

  `REUSE_YN`    varchar(1)   DEFAULT 'N'           COMMENT '★승인 후 병원 인영으로 보관·재사용 동의(병원이 직접 체크)',
  `DEL_DT`      varchar(8)   DEFAULT NULL          COMMENT '원본 파기 예정일(재사용 미동의 건)',

  `CHK_YN`      varchar(1)   DEFAULT 'N'           COMMENT '위너넷 육안확인(흐림·잘림·배경 안 지워짐 걸러내기)',
  `CHK_USER`    varchar(50)  DEFAULT NULL          COMMENT '확인자',
  `CHK_DTTM`    datetime     DEFAULT NULL          COMMENT '확인일시',
  `CHK_MEMO`    varchar(300) DEFAULT NULL          COMMENT '보완요청 사유',

  `UP_DTTM`     datetime     DEFAULT CURRENT_TIMESTAMP COMMENT '업로드일시',
  `UP_IP`       varchar(50)  DEFAULT NULL          COMMENT '업로드 IP',
  `ACTION_YN`   varchar(1)   DEFAULT 'Y'           COMMENT 'Y.유효 N.교체되어 무효',
  `REG_DTTM`    datetime     DEFAULT CURRENT_TIMESTAMP                             COMMENT '등록일시',
  `REG_USER`    varchar(50)  DEFAULT NULL                                          COMMENT '등록자',
  `REG_IP`      varchar(50)  DEFAULT NULL                                          COMMENT '등록 IP',
  `UPD_DTTM`    datetime     DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '최종변경일시',
  `UPD_USER`    varchar(50)  DEFAULT NULL                                          COMMENT '최종변경자',
  `UPD_IP`      varchar(50)  DEFAULT NULL                                          COMMENT '최종변경 IP',
  PRIMARY KEY (`REQ_NO`,`SEAL_SEQ`),
  KEY `IX_JOIN_SEAL_01` (`REQ_NO`,`ACTION_YN`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='가입신청 인영(도장·사인) 원본';


/* -------------------------------------------------------------------------------------
 * 2. TBL_JOIN_SIGN — 동의서 연동(날인) 내역 : 어느 동의서에 어느 인영을 어디에 찍었나
 *    ★ 여기 행이 있어야 날인된 것이다. 이미지가 있다고 날인이 아니다.
 * ----------------------------------------------------------------------------------- */
CREATE TABLE IF NOT EXISTS `TBL_JOIN_SIGN` (
  `REQ_NO`      bigint       NOT NULL              COMMENT '신청번호',
  `AGREE_CD`    varchar(20)  NOT NULL              COMMENT '동의서코드(TBL_AGREE_MST) - 동의서마다 1행',
  `SIGN_SEQ`    int          NOT NULL DEFAULT 1    COMMENT '재날인 순번(다시 찍으면 +1, 이전 행은 남긴다)',

  `SEAL_SEQ`    int          DEFAULT NULL          COMMENT '★연동한 인영(TBL_JOIN_SEAL.SEAL_SEQ). SIGN_TYPE=3,4 면 NULL',
  `SIGN_TYPE`   varchar(1)   NOT NULL DEFAULT '2'  COMMENT '1.전자서명(사인) 2.도장이미지 연동 3.스캔본업로드 4.본인확인으로 갈음',
  `SIGNER_GB`   varchar(1)   DEFAULT '1'           COMMENT '날인주체 1.대표자 2.위임담당자',
  `SIGNER_NM`   varchar(50)  DEFAULT NULL          COMMENT '대표자 성명(문서에 인쇄될 이름)',
  `HOSP_NM`     varchar(100) DEFAULT NULL          COMMENT '날인 시점의 요양기관명(문서에 찍힌 그대로)',
  `HOSP_ADDR`   varchar(300) DEFAULT NULL          COMMENT '날인 시점의 주소(문서 하단 기재)',
  `SIGN_DT`     varchar(8)   DEFAULT NULL          COMMENT '문서상 날짜(YYYYMMDD) - "2026년 O월 O일"',

  /* -- 찍힌 자리. NULL 이면 TBL_AGREE_MST 의 기본좌표를 쓴다 ------- */
  `PAGE_NO`     int          DEFAULT NULL          COMMENT '페이지(1부터)',
  `POS_X`       decimal(5,2) DEFAULT NULL          COMMENT '가로 위치 % (문서 폭 대비, 인영 중심)',
  `POS_Y`       decimal(5,2) DEFAULT NULL          COMMENT '세로 위치 % (문서 높이 대비, 인영 중심)',
  `POS_W`       decimal(5,2) DEFAULT NULL          COMMENT '인영 폭 % (세로는 원본 비율대로)',
  `ROTATE`      int          DEFAULT 0             COMMENT '회전각(도) - 스캔 도장이 기울었을 때',

  /* -- 스캔본 업로드(SIGN_TYPE=3) 전용 ---------------------------- */
  `FILE_NM`     varchar(200) DEFAULT NULL          COMMENT '스캔본 파일명',
  `FILE_PATH`   varchar(300) DEFAULT NULL          COMMENT '스캔본 경로 ★웹루트 밖',
  `FILE_SIZE`   bigint       DEFAULT NULL          COMMENT '바이트',
  `FILE_HASH`   varchar(64)  DEFAULT NULL          COMMENT '스캔본 SHA-256(hex)',

  /* -- 증적 ------------------------------------------------------ */
  `VER_NO`      int          DEFAULT 1             COMMENT '날인한 본문 버전(TBL_JOIN_AGREE 와 같아야 한다)',
  `DOC_HASH`    varchar(64)  DEFAULT NULL          COMMENT '동의본문 SHA-256(hex) - 문구 위변조 대조용',
  `SIGN_DTTM`   datetime     DEFAULT CURRENT_TIMESTAMP COMMENT '날인일시(서버시각)',
  `SIGN_IP`     varchar(50)  DEFAULT NULL          COMMENT '날인 IP',
  `USER_AGENT`  varchar(300) DEFAULT NULL          COMMENT '브라우저 UA - 기기 증적',
  `SIGN_USER`   varchar(100) DEFAULT NULL          COMMENT '날인 버튼을 누른 계정(신청 이메일)',

  /* -- 본인확인(SIGN_TYPE=4 이거나 1~3 보강) ---------------------- */
  `VERIFY_GB`   varchar(1)   DEFAULT NULL          COMMENT '1.휴대폰인증 2.사업자등록증첨부 3.이메일인증 4.내방확인 9.기타',
  `VERIFY_KEY`  varchar(100) DEFAULT NULL          COMMENT '인증 거래번호/확인근거',
  `VERIFY_DTTM` datetime     DEFAULT NULL          COMMENT '본인확인 일시',

  `ACTION_YN`   varchar(1)   DEFAULT 'Y'           COMMENT 'Y.유효 N.재날인으로 무효',
  `REG_DTTM`    datetime     DEFAULT CURRENT_TIMESTAMP                             COMMENT '등록일시',
  `REG_USER`    varchar(50)  DEFAULT NULL                                          COMMENT '등록자',
  `REG_IP`      varchar(50)  DEFAULT NULL                                          COMMENT '등록 IP',
  `UPD_DTTM`    datetime     DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '최종변경일시',
  `UPD_USER`    varchar(50)  DEFAULT NULL                                          COMMENT '최종변경자',
  `UPD_IP`      varchar(50)  DEFAULT NULL                                          COMMENT '최종변경 IP',
  PRIMARY KEY (`REQ_NO`,`AGREE_CD`,`SIGN_SEQ`),
  KEY `IX_JOIN_SIGN_01` (`REQ_NO`,`ACTION_YN`),
  KEY `IX_JOIN_SIGN_02` (`REQ_NO`,`SEAL_SEQ`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='동의서 인영 연동(날인) 내역';


/* -------------------------------------------------------------------------------------
 * 3. TBL_HOSPSEAL_MST — 승인 후 병원 인영 보관 (REUSE_YN='Y' 인 건만 승계)
 *    계약·재동의 때마다 도장을 다시 받지 않기 위한 것. 재사용은 그때도 병원이 눌러야 한다.
 * ----------------------------------------------------------------------------------- */
CREATE TABLE IF NOT EXISTS `TBL_HOSPSEAL_MST` (
  `HOSP_CD`     varchar(10)  NOT NULL              COMMENT '요양기관번호',
  `SEAL_GB`     varchar(1)   NOT NULL DEFAULT '2'  COMMENT '1.대표자 사인 2.기관 직인',
  `JOB_SEQ`     int          NOT NULL DEFAULT 1    COMMENT '순번(교체 시 +1)',
  `SEAL_NM`     varchar(50)  DEFAULT NULL          COMMENT '명칭',
  `SEAL_IMG`    mediumblob                         COMMENT '이미지 원본',
  `SEAL_MIME`   varchar(50)  DEFAULT NULL          COMMENT 'MIME',
  `SEAL_HASH`   varchar(64)  DEFAULT NULL          COMMENT 'SHA-256(hex)',
  `IMG_W`       int          DEFAULT NULL          COMMENT '원본 가로 px',
  `IMG_H`       int          DEFAULT NULL          COMMENT '원본 세로 px',
  `SRC_REQ_NO`  bigint       DEFAULT NULL          COMMENT '어느 가입신청에서 받은 것인지(추적)',
  `START_DT`    varchar(8)   DEFAULT NULL          COMMENT '적용시작일자',
  `END_DT`      varchar(8)   DEFAULT NULL          COMMENT '적용종료일자',
  `USE_YN`      varchar(1)   DEFAULT 'Y'           COMMENT '사용여부',
  `ACTION_YN`   varchar(1)   DEFAULT 'Y'           COMMENT 'Y.활성 N.비활성',
  `REG_DTTM`    datetime     DEFAULT CURRENT_TIMESTAMP                             COMMENT '등록일시',
  `REG_USER`    varchar(50)  DEFAULT NULL                                          COMMENT '등록자',
  `REG_IP`      varchar(50)  DEFAULT NULL                                          COMMENT '등록 IP',
  `UPD_DTTM`    datetime     DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '최종변경일시',
  `UPD_USER`    varchar(50)  DEFAULT NULL                                          COMMENT '최종변경자',
  `UPD_IP`      varchar(50)  DEFAULT NULL                                          COMMENT '최종변경 IP',
  PRIMARY KEY (`HOSP_CD`,`SEAL_GB`,`JOB_SEQ`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='병원 인영(도장·사인) 보관';


/* -------------------------------------------------------------------------------------
 * 3-1. TBL_SEAL_LOG — 인영 사용·열람 로그
 *   도장 이미지를 서버가 들고 있는 이상, **언제 누가 꺼내 썼는지**가 남아야 한다.
 *   "우리 도장이 왜 저 문서에 찍혀 있냐" 는 질문에 답할 수 있는 유일한 수단이다.
 * ----------------------------------------------------------------------------------- */
CREATE TABLE IF NOT EXISTS `TBL_SEAL_LOG` (
  `LOG_SEQ`     bigint       NOT NULL AUTO_INCREMENT COMMENT '로그순번',
  `SEAL_GB`     varchar(1)   DEFAULT NULL          COMMENT '1.사인 2.직인',
  `REQ_NO`      bigint       DEFAULT NULL          COMMENT '가입신청 인영일 때',
  `SEAL_SEQ`    int          DEFAULT NULL          COMMENT '가입신청 인영 순번',
  `HOSP_CD`     varchar(10)  DEFAULT NULL          COMMENT '병원 보관 인영일 때',
  `JOB_SEQ`     int          DEFAULT NULL          COMMENT '병원 보관 인영 순번',
  `ACT_GB`      varchar(1)   NOT NULL              COMMENT '1.업로드 2.열람 3.날인적용 4.해제 5.승계 6.파기',
  `ACT_TARGET`  varchar(100) DEFAULT NULL          COMMENT '대상(동의서코드·문서명 등)',
  `ACT_USER`    varchar(100) DEFAULT NULL          COMMENT '수행자',
  `ACT_IP`      varchar(50)  DEFAULT NULL          COMMENT 'IP',
  `ACT_DTTM`    datetime     DEFAULT CURRENT_TIMESTAMP COMMENT '수행일시',
  `ACT_MEMO`    varchar(300) DEFAULT NULL          COMMENT '비고',
  PRIMARY KEY (`LOG_SEQ`),
  KEY `IX_SEAL_LOG_01` (`REQ_NO`,`SEAL_SEQ`),
  KEY `IX_SEAL_LOG_02` (`HOSP_CD`,`ACT_DTTM` DESC)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='인영 사용·열람 로그';


/* -------------------------------------------------------------------------------------
 * 4. TBL_AGREE_MST 확장 — 서식별 도장 기본좌표
 *    도장 자리는 서식마다 고정이라 마스터가 들고 있는 게 맞다.
 *    개별 건에서 옮겼으면 TBL_JOIN_SIGN 의 좌표가 이긴다.
 *    ★ ADD COLUMN IF NOT EXISTS 가 MySQL 8 에 없다. 한 번만 돌린다.
 * ----------------------------------------------------------------------------------- */
ALTER TABLE `TBL_AGREE_MST`
  ADD COLUMN `SEAL_NEED_YN` varchar(1)   DEFAULT 'N' COMMENT '날인 필요여부(체크동의만으로 끝나는 약관은 N)' AFTER `ESS_YN`,
  ADD COLUMN `SEAL_PAGE`    int          DEFAULT 1   COMMENT '도장 기본 페이지'      AFTER `SEAL_NEED_YN`,
  ADD COLUMN `SEAL_X`       decimal(5,2) DEFAULT NULL COMMENT '도장 기본 가로 % (중심)' AFTER `SEAL_PAGE`,
  ADD COLUMN `SEAL_Y`       decimal(5,2) DEFAULT NULL COMMENT '도장 기본 세로 % (중심)' AFTER `SEAL_X`,
  ADD COLUMN `SEAL_W`       decimal(5,2) DEFAULT NULL COMMENT '도장 기본 폭 %'         AFTER `SEAL_Y`;

/* 서식별 기본값 — [서식2]·[서식3] 만 날인 대상, [서식1] 의뢰서와 나머지 약관은 체크동의로 끝
 *   좌표는 실제 서식 미리보기 보면서 화면에서 맞춘 뒤 이 값을 고칠 것(지금은 눈대중 초기값) */
UPDATE `TBL_AGREE_MST` SET `SEAL_NEED_YN`='Y', `SEAL_PAGE`=1, `SEAL_X`=62.00, `SEAL_Y`=86.00, `SEAL_W`=11.00
 WHERE `AGREE_CD` IN ('REMOTE_DB','PRIV_INFO') AND `VER_NO`=1;

UPDATE `TBL_AGREE_MST` SET `SEAL_NEED_YN`='N'
 WHERE `AGREE_CD` IN ('CONSULT_REQ','PER_USE','PER_PRO') AND `VER_NO`=1;


/* -------------------------------------------------------------------------------------
 * 5. 공통코드
 * ----------------------------------------------------------------------------------- */
INSERT IGNORE INTO `TBL_CODE_MST` (`CODE_CD`,`JOB_SEQ`,`CODE_NM`,`START_DT`,`END_DT`,`USE_YN`,`SORT`,`REG_USER`)
VALUES ('SIGN_TYPE',1,'날인방식'    ,'20260101','29991231','Y',4,'SYSTEM'),
       ('VERIFY_GB',1,'본인확인수단','20260101','29991231','Y',5,'SYSTEM'),
       ('SEAL_GB'  ,1,'인영구분'    ,'20260101','29991231','Y',6,'SYSTEM'),
       ('SEAL_ACT' ,1,'인영 사용행위','20260101','29991231','Y',7,'SYSTEM');

INSERT IGNORE INTO `TBL_CODE_DTL` (`CODE_GB`,`CODE_CD`,`SUB_CODE`,`JOB_SEQ`,`SUB_CODE_NM`,`START_DT`,`END_DT`,`USE_YN`,`SORT`,`REG_USER`)
VALUES ('Z','SIGN_TYPE','1',1,'전자서명(화면 사인)' ,'20260101','29991231','Y',1,'SYSTEM'),
       ('Z','SIGN_TYPE','2',1,'도장이미지 연동'     ,'20260101','29991231','Y',2,'SYSTEM'),
       ('Z','SIGN_TYPE','3',1,'스캔본 업로드'       ,'20260101','29991231','Y',3,'SYSTEM'),
       ('Z','SIGN_TYPE','4',1,'본인확인으로 갈음'   ,'20260101','29991231','Y',4,'SYSTEM'),
       ('Z','VERIFY_GB','1',1,'휴대폰 본인인증'     ,'20260101','29991231','Y',1,'SYSTEM'),
       ('Z','VERIFY_GB','2',1,'사업자등록증 첨부'   ,'20260101','29991231','Y',2,'SYSTEM'),
       ('Z','VERIFY_GB','3',1,'이메일 인증'         ,'20260101','29991231','Y',3,'SYSTEM'),
       ('Z','VERIFY_GB','4',1,'담당자 내방확인'     ,'20260101','29991231','Y',4,'SYSTEM'),
       ('Z','VERIFY_GB','9',1,'기타'               ,'20260101','29991231','Y',9,'SYSTEM'),
       ('Z','SEAL_GB'  ,'1',1,'대표자 사인'         ,'20260101','29991231','Y',1,'SYSTEM'),
       ('Z','SEAL_GB'  ,'2',1,'기관 직인(도장)'     ,'20260101','29991231','Y',2,'SYSTEM'),
       ('Z','SEAL_ACT' ,'1',1,'업로드'             ,'20260101','29991231','Y',1,'SYSTEM'),
       ('Z','SEAL_ACT' ,'2',1,'열람'               ,'20260101','29991231','Y',2,'SYSTEM'),
       ('Z','SEAL_ACT' ,'3',1,'날인적용'           ,'20260101','29991231','Y',3,'SYSTEM'),
       ('Z','SEAL_ACT' ,'4',1,'날인해제'           ,'20260101','29991231','Y',4,'SYSTEM'),
       ('Z','SEAL_ACT' ,'5',1,'병원 승계'          ,'20260101','29991231','Y',5,'SYSTEM'),
       ('Z','SEAL_ACT' ,'6',1,'파기'               ,'20260101','29991231','Y',6,'SYSTEM');


/* -------------------------------------------------------------------------------------
 * 6. TBL_JOIN_DOC — 날인까지 합성한 동의서 완성본(PDF) : **위너넷 보관본**
 *    분쟁이 나면 결국 **이 PDF 한 장**이 증거다. 표에 흩어진 값이 아니라.
 *    기존 파일 관례대로 경로 저장. ★ 웹루트 밖.
 *
 *    [★ 계약서가 아니라 동의서다]
 *      계약서는 쌍방이 각 1부씩 나눠 갖고 서로에게 의무가 생긴다. 동의서는 다르다.
 *      병원이 위너넷에게 **일방으로 주는 의사표시**이고, "동의를 받았다" 를 입증할
 *      책임은 **받은 쪽(위너넷)** 에 있다. 그래서
 *        · 위너넷 보관 = 이 표(FILE_PATH). **이게 본체다.**
 *        · 병원 제공  = 사본(TBL_JOIN_DOC_SEND). 의무가 아니라 신뢰 차원이지만,
 *                      "그런 동의 한 적 없다" 는 말을 미리 막아 주니 보내는 게 낫다.
 *      계약(TBL_HOSPCONT_MST)과 섞지 말 것. 계약은 승인 뒤 따로 걸고, 동의는
 *      **계약이 끝나도 철회 전까지 유효**하며 반대로 **계약 중에도 철회될 수 있다**.
 * ----------------------------------------------------------------------------------- */
CREATE TABLE IF NOT EXISTS `TBL_JOIN_DOC` (
  `REQ_NO`      bigint       NOT NULL              COMMENT '신청번호',
  `AGREE_CD`    varchar(20)  NOT NULL              COMMENT '동의서코드(3종 묶음 1파일이면 ALL)',
  `DOC_SEQ`     int          NOT NULL DEFAULT 1    COMMENT '순번(재생성 시 +1, 옛 것은 ACTION_YN=N)',
  `DOC_GB`      varchar(1)   DEFAULT '1'           COMMENT '1.동의서 2.컨설팅 의뢰서 3.전체묶음',
  `DOC_NM`      varchar(200) DEFAULT NULL          COMMENT '문서명',
  `HOSP_CD`     varchar(10)  DEFAULT NULL          COMMENT '승인 후 채움 - 병원이 자기 문서를 찾는 키',
  `FILE_PATH`   varchar(300) DEFAULT NULL          COMMENT '저장경로 ★웹루트 밖',
  `FILE_SIZE`   bigint       DEFAULT NULL          COMMENT '바이트',
  `DOC_HASH`    varchar(64)  DEFAULT NULL          COMMENT 'PDF SHA-256(hex) - 위변조 대조',
  `PAGE_CNT`    int          DEFAULT NULL          COMMENT '쪽수',
  `MAKE_DTTM`   datetime     DEFAULT CURRENT_TIMESTAMP COMMENT '생성일시',
  `MAKE_USER`   varchar(100) DEFAULT NULL          COMMENT '생성 주체(신청계정/배치)',
  `SEND_YN`     varchar(1)   DEFAULT 'N'           COMMENT '병원 사본제공 여부(발송·다운로드 1회 이상)',
  `SEND_DTTM`   datetime     DEFAULT NULL          COMMENT '최초 제공일시',
  `KEEP_DT`     varchar(8)   DEFAULT NULL          COMMENT '보존만료 예정일 - 동의 목적 달성 또는 철회 시 기준(계약기간 아님)',
  `ACTION_YN`   varchar(1)   DEFAULT 'Y'           COMMENT 'Y.활성 N.비활성',
  `REG_DTTM`    datetime     DEFAULT CURRENT_TIMESTAMP                             COMMENT '등록일시',
  `REG_USER`    varchar(50)  DEFAULT NULL                                          COMMENT '등록자',
  `UPD_DTTM`    datetime     DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '최종변경일시',
  `UPD_USER`    varchar(50)  DEFAULT NULL                                          COMMENT '최종변경자',
  PRIMARY KEY (`REQ_NO`,`AGREE_CD`,`DOC_SEQ`),
  KEY `IX_JOIN_DOC_01` (`HOSP_CD`,`ACTION_YN`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='동의서 완성본(PDF) - 위너넷 보관';


/* -------------------------------------------------------------------------------------
 * 6-1. TBL_JOIN_DOC_SEND — 병원 사본 제공 이력
 *    메일로 보냈는지, 병원이 화면에서 받아갔는지.
 *    계약서 교부처럼 **의무는 아니다.** 다만 보낸 기록이 있으면 나중에 다툴 일이 줄고,
 *    병원이 자기 동의 내용을 다시 확인할 수 있어야 철회권도 실질적으로 쓸 수 있다.
 * ----------------------------------------------------------------------------------- */
CREATE TABLE IF NOT EXISTS `TBL_JOIN_DOC_SEND` (
  `REQ_NO`      bigint       NOT NULL              COMMENT '신청번호',
  `AGREE_CD`    varchar(20)  NOT NULL              COMMENT '동의서코드',
  `DOC_SEQ`     int          NOT NULL DEFAULT 1    COMMENT '문서 순번',
  `SEND_SEQ`    int          NOT NULL DEFAULT 1    COMMENT '교부 순번(재발송 시 +1)',
  `SEND_GB`     varchar(1)   NOT NULL              COMMENT '1.메일발송 2.화면 다운로드 3.우편/직접전달',
  `TO_EMAIL`    varchar(200) DEFAULT NULL          COMMENT '수신 이메일',
  `TO_NM`       varchar(50)  DEFAULT NULL          COMMENT '수신자명',
  `SEND_DTTM`   datetime     DEFAULT CURRENT_TIMESTAMP COMMENT '발송/다운로드 일시',
  `SEND_USER`   varchar(100) DEFAULT NULL          COMMENT '수행자(위너넷 담당자 또는 병원계정)',
  `SEND_IP`     varchar(50)  DEFAULT NULL          COMMENT 'IP',
  `RESULT_GB`   varchar(1)   DEFAULT '1'           COMMENT '1.성공 2.실패 3.반송',
  `RESULT_MSG`  varchar(300) DEFAULT NULL          COMMENT '실패·반송 사유',
  `REG_DTTM`    datetime     DEFAULT CURRENT_TIMESTAMP COMMENT '등록일시',
  PRIMARY KEY (`REQ_NO`,`AGREE_CD`,`DOC_SEQ`,`SEND_SEQ`),
  KEY `IX_JOIN_DOCSEND_01` (`REQ_NO`,`SEND_DTTM` DESC)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='동의서 완성본 거래처 교부이력';


/* -------------------------------------------------------------------------------------
 * 7. TBL_AGREE_HIS — 동의 상태 이력 (동의 · 철회 · 재동의)
 *
 *    ★ 여기가 계약서와 갈리는 지점이다.
 *      계약은 기간이 끝나면 끝나지만, **동의는 병원이 언제든 철회할 수 있고**
 *      본문이 개정되면 **다시 받아야** 한다. 그 변화를 시점별로 남기는 표다.
 *
 *    TBL_JOIN_AGREE 는 "가입 신청할 때 이랬다" 한 장면만 들고 있고,
 *    TBL_HOSPSIGN_MST 는 "지금 상태" 만 들고 있다. 그 사이의 변화는 여기에만 남는다.
 *    철회 요청이 들어왔을 때 "언제 동의했고 언제 철회했나" 를 답할 수 있는 유일한 곳.
 *
 *    신청 단계는 REQ_NO 로, 승인 후는 HOSP_CD 로 쌓인다(둘 중 하나는 채워진다).
 * ----------------------------------------------------------------------------------- */
CREATE TABLE IF NOT EXISTS `TBL_AGREE_HIS` (
  `HIS_SEQ`     bigint       NOT NULL AUTO_INCREMENT COMMENT '이력순번',
  `HOSP_CD`     varchar(10)  DEFAULT NULL          COMMENT '요양기관번호(승인 후)',
  `REQ_NO`      bigint       DEFAULT NULL          COMMENT '신청번호(승인 전)',
  `AGREE_CD`    varchar(20)  NOT NULL              COMMENT '동의서코드',
  `VER_NO`      int          DEFAULT 1             COMMENT '대상 본문 버전',
  `ACT_GB`      varchar(1)   NOT NULL              COMMENT '1.동의 2.철회 3.재동의(본문개정) 4.만료 5.대표자변경 재징구',
  `ACT_DTTM`    datetime     DEFAULT CURRENT_TIMESTAMP COMMENT '처리일시',
  `ACT_USER`    varchar(100) DEFAULT NULL          COMMENT '처리자(병원계정 또는 위너넷 담당자)',
  `ACT_IP`      varchar(50)  DEFAULT NULL          COMMENT 'IP',
  `ACT_RSN`     varchar(500) DEFAULT NULL          COMMENT '사유(철회 사유·개정 내용 등)',
  `RCV_GB`      varchar(1)   DEFAULT NULL          COMMENT '접수경로 1.화면 2.전화 3.공문/메일 4.방문',
  `AFTER_MEMO`  varchar(500) DEFAULT NULL          COMMENT '후속조치(원격접속 차단·자료 파기 안내 등)',
  `REG_DTTM`    datetime     DEFAULT CURRENT_TIMESTAMP COMMENT '등록일시',
  PRIMARY KEY (`HIS_SEQ`),
  KEY `IX_AGREE_HIS_01` (`HOSP_CD`,`AGREE_CD`,`ACT_DTTM` DESC),
  KEY `IX_AGREE_HIS_02` (`REQ_NO`,`AGREE_CD`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='동의 상태 이력(동의·철회·재동의)';

INSERT IGNORE INTO `TBL_CODE_MST` (`CODE_CD`,`JOB_SEQ`,`CODE_NM`,`START_DT`,`END_DT`,`USE_YN`,`SORT`,`REG_USER`)
VALUES ('AGREE_ACT',1,'동의 상태변화','20260101','29991231','Y',8,'SYSTEM');

INSERT IGNORE INTO `TBL_CODE_DTL` (`CODE_GB`,`CODE_CD`,`SUB_CODE`,`JOB_SEQ`,`SUB_CODE_NM`,`START_DT`,`END_DT`,`USE_YN`,`SORT`,`REG_USER`)
VALUES ('Z','AGREE_ACT','1',1,'동의'              ,'20260101','29991231','Y',1,'SYSTEM'),
       ('Z','AGREE_ACT','2',1,'철회'              ,'20260101','29991231','Y',2,'SYSTEM'),
       ('Z','AGREE_ACT','3',1,'재동의(본문개정)'   ,'20260101','29991231','Y',3,'SYSTEM'),
       ('Z','AGREE_ACT','4',1,'만료'              ,'20260101','29991231','Y',4,'SYSTEM'),
       ('Z','AGREE_ACT','5',1,'대표자변경 재징구'  ,'20260101','29991231','Y',5,'SYSTEM');


/* =====================================================================================
 * 참고 쿼리 (주석 — 실행되지 않는다)
 * =====================================================================================

 (가) 동의서 미리보기·PDF 생성 — 본문 + 인영 + 좌표를 한 번에 뽑는다
      COALESCE 로 "개별 좌표 > 서식 기본좌표" 순서를 준다

 SELECT M.AGREE_CD, M.AGREE_NM, M.FORM_NO, M.AGREE_TEXT,
        S.SIGNER_NM, S.HOSP_NM, S.HOSP_ADDR, S.SIGN_DT,
        COALESCE(S.PAGE_NO, M.SEAL_PAGE) AS PAGE_NO,
        COALESCE(S.POS_X,   M.SEAL_X)    AS POS_X,
        COALESCE(S.POS_Y,   M.SEAL_Y)    AS POS_Y,
        COALESCE(S.POS_W,   M.SEAL_W)    AS POS_W,
        S.ROTATE, L.SEAL_MIME, L.SEAL_IMG
   FROM TBL_AGREE_MST  M
   JOIN TBL_JOIN_SIGN  S ON S.AGREE_CD = M.AGREE_CD AND S.VER_NO = M.VER_NO
                        AND S.REQ_NO   = @REQ_NO   AND S.ACTION_YN = 'Y'
   LEFT JOIN TBL_JOIN_SEAL L ON L.REQ_NO = S.REQ_NO AND L.SEAL_SEQ = S.SEAL_SEQ
                            AND L.ACTION_YN = 'Y'
  WHERE M.USE_YN = 'Y'
  ORDER BY M.SORT;

 (나) 승인 가능 여부 — 필수 동의인데 동의 또는 날인이 빠진 건수. 0 이어야 승인
      날인이 필요없는 약관(SEAL_NEED_YN='N')은 서명 없이 동의만 보면 된다

 SELECT COUNT(*) AS LACK_CNT
   FROM TBL_AGREE_MST M
   LEFT JOIN TBL_JOIN_AGREE A ON A.AGREE_CD = M.AGREE_CD AND A.REQ_NO = @REQ_NO
   LEFT JOIN TBL_JOIN_SIGN  S ON S.AGREE_CD = M.AGREE_CD AND S.REQ_NO = @REQ_NO
                             AND S.ACTION_YN = 'Y'
  WHERE M.USE_YN = 'Y' AND M.ACTION_YN = 'Y' AND M.ESS_YN = 'Y'
    AND ( IFNULL(A.AGREE_YN,'N') <> 'Y'
       OR (M.SEAL_NEED_YN = 'Y' AND S.REQ_NO IS NULL) );

 (다) 도장 교체 — 원본을 갈면 그 도장으로 찍힌 날인도 같이 무효가 되어야 한다.
      안 그러면 "옛 도장으로 찍힌 동의서" 가 유효한 척 남는다

 UPDATE TBL_JOIN_SEAL SET ACTION_YN='N', UPD_DTTM=NOW(), UPD_USER=@USER
  WHERE REQ_NO=@REQ_NO AND SEAL_SEQ=@SEAL_SEQ;

 UPDATE TBL_JOIN_SIGN SET ACTION_YN='N', UPD_DTTM=NOW(), UPD_USER=@USER
  WHERE REQ_NO=@REQ_NO AND SEAL_SEQ=@SEAL_SEQ AND ACTION_YN='Y';

 (라) 승인 시 인영 승계 — REUSE_YN='Y' 를 병원이 체크한 건만

 INSERT INTO TBL_HOSPSEAL_MST (HOSP_CD, SEAL_GB, JOB_SEQ, SEAL_NM, SEAL_IMG, SEAL_MIME,
                               SEAL_HASH, IMG_W, IMG_H, SRC_REQ_NO,
                               START_DT, END_DT, USE_YN, REG_USER)
 SELECT R.HOSP_CD, L.SEAL_GB, 1, L.SEAL_NM, L.SEAL_IMG, L.SEAL_MIME,
        L.SEAL_HASH, L.IMG_W, L.IMG_H, L.REQ_NO,
        DATE_FORMAT(NOW(),'%Y%m%d'), '29991231', 'Y', @CFM_USER
   FROM TBL_JOIN_SEAL L
   JOIN TBL_JOIN_REQ  R ON R.REQ_NO = L.REQ_NO
  WHERE L.REQ_NO = @REQ_NO AND L.ACTION_YN = 'Y' AND L.REUSE_YN = 'Y';

 (마) 재사용 미동의 건 원본 파기 — 배치로 돌린다.
      날인 사실(TBL_JOIN_SIGN)과 완성본 PDF 는 그대로 두고 **원본 이미지만** 지운다

 UPDATE TBL_JOIN_SEAL
    SET SEAL_IMG = NULL, ACTION_YN = 'N', UPD_DTTM = NOW(), UPD_USER = 'BATCH'
  WHERE REUSE_YN = 'N' AND SEAL_IMG IS NOT NULL
    AND DEL_DT IS NOT NULL AND DEL_DT <= DATE_FORMAT(NOW(),'%Y%m%d');

 (바) 교부 처리 — 메일 보냈거나 병원이 받아가면 이력 남기고 문서에 표시

 INSERT INTO TBL_JOIN_DOC_SEND (REQ_NO, AGREE_CD, DOC_SEQ, SEND_SEQ, SEND_GB,
                                TO_EMAIL, TO_NM, SEND_USER, SEND_IP, RESULT_GB)
 SELECT @REQ_NO, @AGREE_CD, @DOC_SEQ,
        (SELECT IFNULL(MAX(X.SEND_SEQ),0)+1 FROM TBL_JOIN_DOC_SEND X
          WHERE X.REQ_NO=@REQ_NO AND X.AGREE_CD=@AGREE_CD AND X.DOC_SEQ=@DOC_SEQ),
        '1', R.EMAIL, R.MBR_NM, @SEND_USER, @SEND_IP, '1'
   FROM TBL_JOIN_REQ R WHERE R.REQ_NO = @REQ_NO;

 UPDATE TBL_JOIN_DOC
    SET SEND_YN = 'Y', SEND_DTTM = IFNULL(SEND_DTTM, NOW()), UPD_DTTM = NOW()
  WHERE REQ_NO=@REQ_NO AND AGREE_CD=@AGREE_CD AND DOC_SEQ=@DOC_SEQ;

 (사) 사본 미제공 확인 — 승인 났는데 병원에 안 보낸 문서(의무는 아니고 운영 점검용)

 SELECT D.REQ_NO, D.AGREE_CD, D.DOC_NM, R.HOSP_NM, R.EMAIL, D.MAKE_DTTM
   FROM TBL_JOIN_DOC D
   JOIN TBL_JOIN_REQ R ON R.REQ_NO = D.REQ_NO
  WHERE D.ACTION_YN = 'Y' AND D.SEND_YN = 'N' AND R.REQ_STAT = '30'
  ORDER BY D.MAKE_DTTM;

 (아) 병원 「내 동의서」 화면 — 승인 후 병원이 자기 문서를 다시 받는다

 SELECT D.REQ_NO, D.AGREE_CD, D.DOC_NM, D.PAGE_CNT, D.MAKE_DTTM, D.SEND_DTTM
   FROM TBL_JOIN_DOC D
  WHERE D.HOSP_CD = #{hospCd} AND D.ACTION_YN = 'Y'
  ORDER BY D.MAKE_DTTM DESC;

 (자) 승인 시 문서에 HOSP_CD 채우기 — 이걸 빼먹으면 병원 화면에서 안 보인다

 UPDATE TBL_JOIN_DOC D
   JOIN TBL_JOIN_REQ R ON R.REQ_NO = D.REQ_NO
    SET D.HOSP_CD = R.HOSP_CD, D.UPD_DTTM = NOW(), D.UPD_USER = @CFM_USER
  WHERE D.REQ_NO = @REQ_NO;

 ===================================================================================== */
