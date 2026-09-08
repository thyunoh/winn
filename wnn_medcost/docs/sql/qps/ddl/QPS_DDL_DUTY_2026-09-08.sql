-- =====================================================================
-- 근무표(듀티) + 근무표에 따른 사인 매치 — DDL (2026-09-08)
--   왜 : 사용자 「근무표에 따른 사인도 매치가 되어야 하고」 · 「근무표는 SUNWOO 에도 있었음」 · 「더 효율적으로」.
--        지금 일괄 사인은 **내 이름**으로 빈 칸을 채운다. 종이 점검표의 사인 칸은 **그날 근무한 사람**이다.
--
--   ── SUNWOO 원본 대조 (D:\SUNWOO\SUNWOO) ─────────────────────────────
--     · `ProgramMain/DutyControl.pas` — 근무표 본체. 저장은 **`t_duty`(company_cd, user_id, work_dt, work_cd, work_tm, note, status)**
--       = **사람 × 하루 한 줄**, work_cd = 근무 기호, work_tm = 시간(정수). 저장은 그 사람·그 날짜를 DELETE 후 INSERT.
--     · `t_duty_group`(company_cd, work_m, duty_grp, user_id) — **그 달에 어느 근무조(병동)에 누가 속하는가**. duty_grp 는 자유 글자('3병동','진료부').
--     · `SmartChart/HLP/HLP_DutySign.pas` — ★**사인 매치의 원본**. 한 달치를 날짜마다 한 사람으로 추린다 :
--         `ROW_NUMBER() OVER (PARTITION BY work_dt ORDER BY user_id DESC) = 1`, `SUBSTRING(work_cd,1,1) LIKE :work_cd`(기호 첫 글자),
--         선택한 duty_grp 의 사람만, 그리고 `t_signature_user.sign_img`(서명 그림)를 함께 읽는다.
--       ⇒ 우리 것과 짝이 맞는다 — 도장은 이미 `TBL_QPS_SIGN` 에 있고, 점검표 사인 칸은 `data-c` 가 곧 **일자**다.
--
--   ── 원본보다 낫게 한 것(사용자 「더 효율적으로」) ─────────────────────
--     ① **표를 둘로 줄였다.** 원본은 근무표(t_duty) + 근무조 명단(t_duty_group) 둘인데, 우리는 **근무표의 사람 줄이 곧 명단**이다.
--        따로 관리하면 두 곳이 어긋난다(원본도 work_m 마다 명단을 다시 넣어야 한다).
--     ② **기호를 코드에 박지 않는다.** 원본은 사인 매치 SQL 에 `duty_grp IN ('3병동','5병동','7병동','진료부')` 가 **박혀 있다**(그 병원 전용).
--        우리는 기호를 공통코드 `QPS_DUTY_SHIFT` 로 두고 병동은 자료로 받는다 — 병원이 늘어도 코드를 안 고친다.
--     ③ **날짜마다 한 사람을 아이디 역순으로 고르지 않는다.** 원본의 `ORDER BY user_id DESC` 는 우연에 맡기는 것이다.
--        우리는 **근무표에 적은 줄 차례(SORT_NO)** 로 고른다 — 담당자가 보는 순서와 종이에 찍히는 순서가 같아진다.
--     ④ 값은 **사람 × 날짜 한 칸**(DAY_NO 1~31)으로 둔다 — 한 달 격자를 한 번에 저장·조회한다(원본은 하루씩 지웠다 넣는다).
--
--   더하기만 하는 DDL ⇒ 운영 선적용 안전(옛 WAR 는 이 표들을 읽지 않는다).
--   코드 : Qps_SQL.xml · QpsMapper/Service(Impl)/Controller(dutyGet·dutySave·dutyDayNames.do) ·
--          qpsDuty.jsp(근무표 작성) · qpsChk.jsp(일괄 사인 「그날 근무자로」)
--   ⛔자바·매퍼가 함께 바뀐다 → **WAR 재빌드 + 재기동**.
-- =====================================================================

-- ── ① 근무표 머리 — 부서·병동 × 연월 한 장 ─────────────────────────────
CREATE TABLE IF NOT EXISTS TBL_QPS_DUTY (
  DUTY_SEQ  BIGINT      NOT NULL AUTO_INCREMENT COMMENT '근무표 번호',
  HOSP_CD   VARCHAR(20) NOT NULL                COMMENT '병원코드',
  DEPT_CD   VARCHAR(20) NOT NULL                COMMENT 'QPS 부서 코드',
  WARD_NM   VARCHAR(50) NOT NULL DEFAULT ''     COMMENT '병동·근무조 이름(자유 글자). 안 나누면 빈 값',
  DUTY_YM   VARCHAR(7)  NOT NULL                COMMENT '연월 yyyy-MM',
  NOTE_TXT  VARCHAR(500) NULL                   COMMENT '비고',
  LOCK_YN   CHAR(1)     NOT NULL DEFAULT 'N'     COMMENT '마감. Y 면 값이 안 바뀐다(원본 t_duty_group.status=C 와 같은 뜻)',
  LOCK_USER VARCHAR(50) NULL                     COMMENT '마감한 사람',
  LOCK_DTTM DATETIME    NULL                     COMMENT '마감한 때',
  USE_YN    CHAR(1)     NOT NULL DEFAULT 'Y',
  REG_USER  VARCHAR(50) NULL,
  REG_DTTM  DATETIME    NULL DEFAULT CURRENT_TIMESTAMP,
  UPD_USER  VARCHAR(50) NULL,
  UPD_DTTM  DATETIME    NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (DUTY_SEQ),
  UNIQUE KEY UX_QPS_DUTY (HOSP_CD, DEPT_CD, WARD_NM, DUTY_YM)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='QPS 근무표 (부서·병동 × 연월 한 장)';

-- ── ② 사람 줄 — 이 표가 곧 그 달의 근무조 명단이다 ─────────────────────
--   ★USER_ID 는 **비어 있어도 된다** — 계정 없는 직원도 근무표에 오른다(이름이 곧 사인 글자다).
--     계정을 이어 두면 그 사람의 **도장**(TBL_QPS_SIGN)이 결재란·사인에 함께 쓰인다.
CREATE TABLE IF NOT EXISTS TBL_QPS_DUTY_ROW (
  DUTY_SEQ  BIGINT      NOT NULL,
  ROW_NO    INT         NOT NULL                COMMENT '줄 번호',
  USER_ID   VARCHAR(50) NULL                    COMMENT '계정(있으면 도장까지 이어진다)',
  USER_NM   VARCHAR(100) NOT NULL               COMMENT '이름 — 사인 칸에 들어갈 글자',
  JOB_NM    VARCHAR(50) NULL                    COMMENT '직종·직위(간호사·조무사 등)',
  SORT_NO   INT         NOT NULL DEFAULT 0      COMMENT '차례 — ★날짜마다 여럿이면 이 순서로 고른다',
  PRIMARY KEY (DUTY_SEQ, ROW_NO)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='QPS 근무표 사람 줄 (= 그 달 근무조 명단)';

-- ── ③ 날짜 값 — 사람 × 날짜 한 칸 ──────────────────────────────────────
CREATE TABLE IF NOT EXISTS TBL_QPS_DUTY_VAL (
  DUTY_SEQ  BIGINT      NOT NULL,
  ROW_NO    INT         NOT NULL,
  DAY_NO    INT         NOT NULL                COMMENT '일 1~31',
  SHIFT_CD  VARCHAR(10) NOT NULL                COMMENT '근무 기호(QPS_DUTY_SHIFT). 빈 칸은 줄을 안 만든다',
  PRIMARY KEY (DUTY_SEQ, ROW_NO, DAY_NO),
  KEY IX_QPS_DUTY_VAL_DAY (DUTY_SEQ, DAY_NO, SHIFT_CD)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='QPS 근무표 값 (사람 × 날짜 = 근무 기호)';

-- ── ④ 근무 기호 — 공통코드로 둔다(새 관리 화면을 만들지 않는다) ─────────
--   ★[QPS ▸ 관리(설정) ▸ 기준코드 ▸ 공통코드] 화면에서 늘리고 줄인다 — 병원마다 기호가 다르면 거기서 고친다.
--   ★첫 글자로 고르는 원본 방식을 살려 **기호를 한 글자로** 두었다(D·E·N·O…). 두 글자 이상도 되지만 격자가 좁아진다.
INSERT INTO TBL_CODE_DTL (CODE_GB, CODE_CD, SUB_CODE, JOB_SEQ, SUB_CODE_NM, START_DT, END_DT, USE_YN, SORT, ACTION_YN, REG_USER)
SELECT * FROM (
  SELECT 'Q' CODE_GB,'QPS_DUTY_SHIFT' CODE_CD,'D' SUB_CODE,1 JOB_SEQ,'주간' SUB_CODE_NM,'20000101' START_DT,'99991231' END_DT,'Y' USE_YN,1 SORT,'Y' ACTION_YN,'system' REG_USER
  UNION ALL SELECT 'Q','QPS_DUTY_SHIFT','E',1,'오후','20000101','99991231','Y',2,'Y','system'
  UNION ALL SELECT 'Q','QPS_DUTY_SHIFT','N',1,'야간','20000101','99991231','Y',3,'Y','system'
  UNION ALL SELECT 'Q','QPS_DUTY_SHIFT','O',1,'휴무','20000101','99991231','Y',4,'Y','system'
  UNION ALL SELECT 'Q','QPS_DUTY_SHIFT','V',1,'휴가','20000101','99991231','Y',5,'Y','system'
  UNION ALL SELECT 'Q','QPS_DUTY_SHIFT','DE',1,'주간·오후','20000101','99991231','Y',6,'Y','system'
  UNION ALL SELECT 'Q','QPS_DUTY_SHIFT','EN',1,'오후·야간','20000101','99991231','Y',7,'Y','system'
  UNION ALL SELECT 'Q','QPS_DUTY_SHIFT','ND',1,'야간·주간','20000101','99991231','Y',8,'Y','system'
  UNION ALL SELECT 'Q','QPS_DUTY_SHIFT','M',1,'미드','20000101','99991231','Y',9,'Y','system'
  UNION ALL SELECT 'Q','QPS_DUTY_SHIFT','A',1,'24시간','20000101','99991231','Y',10,'Y','system'
  UNION ALL SELECT 'Q','QPS_DUTY_SHIFT','H',1,'반일(연차아님)','20000101','99991231','Y',11,'Y','system'
  UNION ALL SELECT 'Q','QPS_DUTY_SHIFT','R',1,'대체휴무','20000101','99991231','Y',12,'Y','system'
) x
WHERE NOT EXISTS ( SELECT 1 FROM TBL_CODE_DTL y
                    WHERE y.CODE_CD = 'QPS_DUTY_SHIFT' AND y.SUB_CODE = x.SUB_CODE );

-- ── 확인 ──────────────────────────────────────────────────────────────
-- SELECT SUB_CODE, SUB_CODE_NM, SORT FROM TBL_CODE_DTL WHERE CODE_CD='QPS_DUTY_SHIFT' ORDER BY SORT;
-- SELECT COUNT(*) FROM TBL_QPS_DUTY; SELECT COUNT(*) FROM TBL_QPS_DUTY_ROW; SELECT COUNT(*) FROM TBL_QPS_DUTY_VAL;
