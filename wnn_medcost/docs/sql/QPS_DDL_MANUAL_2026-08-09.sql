-- =====================================================================
-- QPS 수기입력형(MANUAL) 지표 — 월별 분자·분모 입력 테이블 (2026-08-09)
--
--   ★왜 필요한가: 지표 18종 중 6종은 원천이 위너넷 안에 없다.
--     신체보호대(사용대장) · 영상/검체 TAT(관리대장) · 재택복귀(퇴원자료) ·
--     불만고충(처리대장) · 환자만족도(설문) — 병원이 대장을 보고 월별 숫자를 옮겨 적는 지표다.
--     지금까지는 NUMER_SRC='MANUAL' 에 서버 분기가 없어 사고 테이블을 뒤져 **0건**이 나왔다.
--
--   ★구조: TBL_QPS_CENSUS(분모 마스터)와 같은 12칸 모양. 다만 지표별로 분자·분모를 따로 담아야 해서
--     (INDI_CD, VAL_GB) 를 키에 넣었다.
--       VAL_GB = 'NUMER'(분자) / 'DENOM'(분모)
--     분모가 재원일수·직원수인 지표(예: 신체보호대 = 적용건수 ÷ 재원일수)는 DENOM 행을 안 쓰고
--     마스터의 DENOM_GB(INDAYS/STAFF)를 따라 기존 TBL_QPS_CENSUS 를 그대로 쓴다.
--
--   ★UNIQUE 키가 반드시 있어야 한다 — 저장이 ON DUPLICATE KEY UPDATE 라서,
--     키가 없으면 저장할 때마다 행이 쌓이고 조회는 그 중 아무거나 집는다
--     (차등제 TBL_GRADE_MST 에서 실제로 겪은 사고. CLAUDE.md 2026-07-03 참조).
-- =====================================================================

CREATE TABLE IF NOT EXISTS TBL_QPS_MANUAL (
  MAN_SEQ   BIGINT      NOT NULL AUTO_INCREMENT,
  HOSP_CD   VARCHAR(20) NOT NULL,
  INDI_CD   VARCHAR(20) NOT NULL,                 -- RESTRAINT, TATIMG, TATLAB, HOMERET, CLAIM, SATISFY ...
  IN_YEAR   VARCHAR(4)  NOT NULL,
  VAL_GB    VARCHAR(10) NOT NULL,                 -- NUMER(분자) / DENOM(분모)
  M01 INT NULL, M02 INT NULL, M03 INT NULL, M04 INT NULL,
  M05 INT NULL, M06 INT NULL, M07 INT NULL, M08 INT NULL,
  M09 INT NULL, M10 INT NULL, M11 INT NULL, M12 INT NULL,
  NOTE      VARCHAR(500) NULL,
  USE_YN    CHAR(1)     NOT NULL DEFAULT 'Y',
  REG_USER  VARCHAR(50) NULL,
  REG_DTTM  DATETIME    NULL DEFAULT CURRENT_TIMESTAMP,
  UPD_USER  VARCHAR(50) NULL,
  UPD_DTTM  DATETIME    NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (MAN_SEQ),
  UNIQUE KEY UK_QPS_MANUAL (HOSP_CD, INDI_CD, IN_YEAR, VAL_GB)
);

-- ── 마스터 정리 — MANUAL 6종의 분모 출처와 정의문 ──────────────────────────
--   DENOM_GB 가 비어 있으면(NULL) 분모도 수기입력(TBL_QPS_MANUAL 의 DENOM 행)을 쓴다.
--   신체보호대만 분모가 재원일수라 'INDAYS' 로 둔다.

UPDATE TBL_QPS_INDI_MST
   SET DEFINITION = '환자 1,000 재원일당 신체보호대 적용 건수의 비율',
       NUMER_DESC = '신체보호대 적용 건수', DENOM_DESC = '재원환자 연인원수(해당 기간 일일 재원환자 수의 합)',
       DENOM_GB   = 'INDAYS',
       SOURCE_NM  = '신체보호대 사용대장', METHOD_NM = '대장 기준 월별 집계', OWNER_NM = '간호부'
 WHERE INDI_CD = 'RESTRAINT' AND HOSP_CD = '*';

UPDATE TBL_QPS_INDI_MST
   SET DEFINITION = '영상검사 중 목표시간(TAT) 안에 판독이 완료된 건의 비율',
       NUMER_DESC = 'TAT 목표시간 충족 건수', DENOM_DESC = '영상검사 전체 건수',
       DENOM_GB   = NULL,
       SOURCE_NM  = '영상의학과 TAT 관리대장', METHOD_NM = '대장 기준 월별 집계', OWNER_NM = '영상의학과'
 WHERE INDI_CD = 'TATIMG' AND HOSP_CD = '*';

UPDATE TBL_QPS_INDI_MST
   SET DEFINITION = '검체검사 중 목표시간(TAT) 안에 결과가 보고된 건의 비율',
       NUMER_DESC = 'TAT 목표시간 충족 건수', DENOM_DESC = '검체검사 전체 건수(정규·응급)',
       DENOM_GB   = NULL,
       SOURCE_NM  = 'TAT 관리대장', METHOD_NM = '대장 기준 월별 집계', OWNER_NM = '진단검사의학과'
 WHERE INDI_CD = 'TATLAB' AND HOSP_CD = '*';

UPDATE TBL_QPS_INDI_MST
   SET DEFINITION = '회복기 재활치료 후 퇴원한 환자 중 가정으로 복귀한 환자의 비율',
       NUMER_DESC = '재택(가정)으로 복귀한 환자 수', DENOM_DESC = '회복기 재활치료 후 퇴원환자 수',
       DENOM_GB   = NULL,
       SOURCE_NM  = '퇴원환자 자료', METHOD_NM = '퇴원자료 기준 월별 집계', OWNER_NM = '사회사업팀'
 WHERE INDI_CD = 'HOMERET' AND HOSP_CD = '*';

UPDATE TBL_QPS_INDI_MST
   SET DEFINITION = '접수된 불만 및 고충 중 기한 내 처리 완료된 건의 비율',
       NUMER_DESC = '불만 및 고충 처리건수', DENOM_DESC = '불만 및 고충 접수건수',
       DENOM_GB   = NULL,
       SOURCE_NM  = '불만·고충 처리대장', METHOD_NM = '대장 기준 월별 집계', OWNER_NM = '원무팀'
 WHERE INDI_CD = 'CLAIM' AND HOSP_CD = '*';

UPDATE TBL_QPS_INDI_MST
   SET DEFINITION = '환자만족도 조사에서 만족(긍정) 응답이 차지하는 비율',
       NUMER_DESC = '만족(긍정) 응답 수', DENOM_DESC = '전체 응답 수',
       DENOM_GB   = NULL,
       SOURCE_NM  = '환자만족도 설문', METHOD_NM = '설문 결과 집계', OWNER_NM = '적정진료관리실'
 WHERE INDI_CD = 'SATISFY' AND HOSP_CD = '*';

-- 확인
-- SELECT INDI_CD, INDI_NM, NUMER_SRC, IFNULL(DENOM_GB,'(수기)') DENOM_GB, MULTIPLIER, UNIT, CYCLE_GB
--   FROM TBL_QPS_INDI_MST WHERE NUMER_SRC='MANUAL' ORDER BY SORT_NO;
