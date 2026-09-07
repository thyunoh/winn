-- ============================================================================
--  서식별 작성 주기 (2026-09-07 사용자 요청 「주기 설정 표로 빼줘」)
--
--  왜 : 일괄 출력이 「이 기간에 몇 건이어야 하는가」를 알려면 서식마다 주기가 있어야 한다.
--       종전에는 화면(qpsPrintAll.jsp)에 상수로 박아 두었는데, 주기는 **병원마다 다르다**
--       (회의록을 분기로 여는 곳도, 매월 여는 곳도 있다). 그래서 표로 뺀다.
--
--  주기 코드 : 이미 쓰던 것을 그대로 쓴다 — 점검표 서식 TBL_QPS_CHK_FORM.PRD_GB,
--             지표 마스터 TBL_QPS_INDI_MST.CYCLE_GB 가 D·W·M·Q·H·Y 를 쓴다.
--               D 매일 · W 매주 · M 매월 · Q 분기 · H 반기 · Y 연 1회 · S 그때그때(사건이 나면)
--
--  병원별 : HOSP_CD 로 나눈다. 값이 없는 병원은 화면의 기본값(아래 seed 와 같은 값)으로 돈다.
-- ============================================================================

CREATE TABLE IF NOT EXISTS TBL_QPS_FORM_CYC (
  HOSP_CD   VARCHAR(20) NOT NULL COMMENT '병원코드',
  FORM_KEY  VARCHAR(30) NOT NULL COMMENT '서식 열쇠 — 일괄 출력 화면의 key (minutes·round·rca …)',
  FORM_NM   VARCHAR(60) NULL     COMMENT '서식 이름(보기용 · 화면 이름이 정본)',
  CYC_GB    CHAR(1)     NOT NULL COMMENT '주기 D일 W주 M월 Q분기 H반기 Y연 S그때그때',
  USE_YN    CHAR(1)     NOT NULL DEFAULT 'Y' COMMENT '일괄 출력 목록에 보일지',
  SORT_NO   INT         NULL     COMMENT '보이는 차례(비면 화면 차례)',
  REG_USER  VARCHAR(50) NULL,
  REG_DTTM  DATETIME    NULL DEFAULT CURRENT_TIMESTAMP,
  UPD_USER  VARCHAR(50) NULL,
  UPD_DTTM  DATETIME    NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (HOSP_CD, FORM_KEY)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
  COMMENT='서식별 작성 주기 — 일괄 출력의 「기간 안에 몇 건이어야 하는가」 판정에 쓴다(2026-09-07)';

-- ── 초기값 ─────────────────────────────────────────────────────────────────
--  ★일반적인 선에서 넣은 값이다. 병원 사정에 맞게 화면에서 고치면 된다.
--  ★아래 'w1234567' 자리에 실제 병원코드를 넣고 돌린다. 여러 병원이면 병원마다 한 번씩.
INSERT INTO TBL_QPS_FORM_CYC (HOSP_CD, FORM_KEY, FORM_NM, CYC_GB, SORT_NO, REG_USER) VALUES
  ('w1234567', 'minutes',  'QPS 위원회 회의록',        'Q',  1, 'ddl'),
  ('w1234567', 'def',      '지표 정의서',              'Y',  2, 'ddl'),
  ('w1234567', 'round',    '환자안전관리 라운딩 점검표','M',  3, 'ddl'),
  ('w1234567', 'rca',      'RCA 근본원인 분석',        'S',  4, 'ddl'),
  ('w1234567', 'fmea',     'FMEA 계획서 · 보고서',     'Y',  5, 'ddl'),
  ('w1234567', 'qiplan',   'QI 활동계획서',            'Y',  6, 'ddl'),
  ('w1234567', 'qirpt',    'QI 중간 · 최종보고서',     'H',  7, 'ddl'),
  ('w1234567', 'qifund',   '활동 자원지원 내역',       'Y',  8, 'ddl'),
  ('w1234567', 'srvplan',  '환자만족도 조사계획서',    'Y',  9, 'ddl'),
  ('w1234567', 'srvnote',  '환자만족도 조사안내문',    'Y', 10, 'ddl'),
  ('w1234567', 'srvimpr',  '개선활동결과보고서',       'S', 11, 'ddl'),
  ('w1234567', 'cmplplan', '불만고충 처리계획서',      'Y', 12, 'ddl'),
  ('w1234567', 'cmplrpt',  '불만고충 지표분석보고서',  'Q', 13, 'ddl')
ON DUPLICATE KEY UPDATE FORM_NM = VALUES(FORM_NM);

-- 확인
-- SELECT * FROM TBL_QPS_FORM_CYC ORDER BY HOSP_CD, SORT_NO;
