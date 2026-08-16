-- =====================================================================
-- 감염관리 우선순위 사정 도구 (2026-08-10) — 원본 캡처 2쪽 채록
--
--   ★원본은 사람이 세 값을 보고 <곱셈을 손으로 해서> 위험점수를 적는다.
--     여기서는 발생가능성(P) × 심각성(S) × 준비·대처(R) 를 서버가 계산한다.
--       P 1~5 (거의없음 … 지속적임)
--       S 1~5 (미약 … 극심함)
--       R 1~4 (준비됨/불가능 … 준비안됨,지원가능)
--     최대 5×5×4 = 100. 등급 : 1~24 낮음 / 25~49 중간 / 50~74 높음 / 75~100 매우 위험.
--     ★점수는 계산값이지만 <저장>한다 — 집계표(우선순위 정렬)가 SQL 정렬로 끝나고,
--       나중에 구간 기준이 바뀌어도 그때 매긴 점수가 남아야 하기 때문(스냅샷 성격).
--
--   ★항목(31개)은 병원마다 늘리거나 지울 수 있어야 해서 <행으로> 관리한다.
--     새 평가를 만들면 기본 31행을 깔아 주고, 병원이 고친 것은 그 평가 안에만 남는다.
--
--   재실행 안전(CREATE IF NOT EXISTS).
-- =====================================================================

CREATE TABLE IF NOT EXISTS TBL_QPS_INFRISK (
  RISK_SEQ   BIGINT      NOT NULL AUTO_INCREMENT,
  HOSP_CD    VARCHAR(20) NOT NULL COMMENT '병원코드',
  EVAL_DT    VARCHAR(8)  NOT NULL COMMENT '평가일시(YYYYMMDD)',
  EVALUATOR  VARCHAR(100) NULL    COMMENT '평가위원',
  USE_YN     CHAR(1)     DEFAULT 'Y',
  REG_USER   VARCHAR(50) NULL,
  REG_DTTM   DATETIME    DEFAULT CURRENT_TIMESTAMP,
  UPD_USER   VARCHAR(50) NULL,
  UPD_DTTM   DATETIME    NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (RISK_SEQ),
  UNIQUE KEY UK_QPS_INFRISK (HOSP_CD, EVAL_DT)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='감염관리 우선순위 사정 도구(머리)';

CREATE TABLE IF NOT EXISTS TBL_QPS_INFRISK_ITEM (
  RISK_SEQ  BIGINT      NOT NULL,
  SORT      INT         NOT NULL COMMENT '표시 순서',
  GRP_NM    VARCHAR(60) NULL COMMENT '대분류 — 환자에 영향 / 직원에게 영향',
  SEC_CD    VARCHAR(4)  NULL COMMENT '구역 A~I',
  SEC_NM    VARCHAR(80) NULL COMMENT '구역명(손위생 관련 감염 위험 요인 등)',
  ITEM_NO   VARCHAR(8)  NULL COMMENT '번호 A-1',
  ITEM_NM   VARCHAR(200) NULL COMMENT '위험 항목',
  P_VAL     TINYINT     NULL COMMENT '발생·노출가능성 1~5',
  S_VAL     TINYINT     NULL COMMENT '심각성 1~5',
  R_VAL     TINYINT     NULL COMMENT '준비·대처기능 1~4',
  SCORE     INT         NULL COMMENT '위험점수 = P×S×R',
  NOTE      VARCHAR(300) NULL,
  PRIMARY KEY (RISK_SEQ, SORT),
  KEY IX_QPS_INFRISK_ITEM (RISK_SEQ, SCORE)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='감염관리 우선순위 사정 도구(항목)';

-- ── 기본 항목 31종 (원본 캡처 그대로) ────────────────────────────────
--    화면이 '새 평가'를 만들 때 이 표를 읽어 초기 행을 깐다.
CREATE TABLE IF NOT EXISTS TBL_QPS_INFRISK_DEF (
  SORT     INT         NOT NULL,
  GRP_NM   VARCHAR(60) NULL,
  SEC_CD   VARCHAR(4)  NULL,
  SEC_NM   VARCHAR(80) NULL,
  ITEM_NO  VARCHAR(8)  NULL,
  ITEM_NM  VARCHAR(200) NULL,
  USE_YN   CHAR(1) DEFAULT 'Y',
  PRIMARY KEY (SORT)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='감염 위험항목 기본표';

INSERT INTO TBL_QPS_INFRISK_DEF (SORT, GRP_NM, SEC_CD, SEC_NM, ITEM_NO, ITEM_NM) VALUES
 ( 1,'환자에 영향을 주는 감염 위험 요인','A','손위생 관련 감염 위험 요인','A-1','손위생 수행률'),
 ( 2,'환자에 영향을 주는 감염 위험 요인','A','손위생 관련 감염 위험 요인','A-2','올바른 손위생 방법'),
 ( 3,'환자에 영향을 주는 감염 위험 요인','A','손위생 관련 감염 위험 요인','A-3','손위생 자원'),
 ( 4,'환자에 영향을 주는 감염 위험 요인','B','삽입기구 관련 감염 위험 요인','B-1','중심정맥관련 혈류감염'),
 ( 5,'환자에 영향을 주는 감염 위험 요인','B','삽입기구 관련 감염 위험 요인','B-2','인공호흡기관련 폐렴'),
 ( 6,'환자에 영향을 주는 감염 위험 요인','B','삽입기구 관련 감염 위험 요인','B-3','유치도뇨관관련 요로감염'),
 ( 7,'환자에 영향을 주는 감염 위험 요인','C','시술 관련 감염 위험 요인','C-1','시술부위 감염'),
 ( 8,'환자에 영향을 주는 감염 위험 요인','D','다제내성균 관련 감염 위험 요인','D-1','MRSA'),
 ( 9,'환자에 영향을 주는 감염 위험 요인','D','다제내성균 관련 감염 위험 요인','D-2','VRE'),
 (10,'환자에 영향을 주는 감염 위험 요인','D','다제내성균 관련 감염 위험 요인','D-3','CRE'),
 (11,'환자에 영향을 주는 감염 위험 요인','D','다제내성균 관련 감염 위험 요인','D-4','MRPA'),
 (12,'환자에 영향을 주는 감염 위험 요인','D','다제내성균 관련 감염 위험 요인','D-5','MRAB'),
 (13,'환자에 영향을 주는 감염 위험 요인','E','감염병 관련 감염 위험 요인','E-1','법정감염병 보고율'),
 (14,'환자에 영향을 주는 감염 위험 요인','E','감염병 관련 감염 위험 요인','E-2','격리실 구비 및 사용지침 준수'),
 (15,'환자에 영향을 주는 감염 위험 요인','E','감염병 관련 감염 위험 요인','E-3','인플루엔자'),
 (16,'환자에 영향을 주는 감염 위험 요인','E','감염병 관련 감염 위험 요인','E-4','옴'),
 (17,'환자에 영향을 주는 감염 위험 요인','E','감염병 관련 감염 위험 요인','E-5','결핵'),
 (18,'환자에 영향을 주는 감염 위험 요인','E','감염병 관련 감염 위험 요인','E-6','지역유행 감염병'),
 (19,'환자에 영향을 주는 감염 위험 요인','F','의료물품 관련 감염 위험 요인','F-1','재사용기구의 부적절한 세척'),
 (20,'환자에 영향을 주는 감염 위험 요인','F','의료물품 관련 감염 위험 요인','F-2','부적절한 소독제 선택'),
 (21,'환자에 영향을 주는 감염 위험 요인','F','의료물품 관련 감염 위험 요인','F-3','소독제 희석농도, 침적시간 미준수'),
 (22,'환자에 영향을 주는 감염 위험 요인','F','의료물품 관련 감염 위험 요인','F-4','청결물품과 오염물품 분리 보관'),
 (23,'환자에 영향을 주는 감염 위험 요인','G','환경 관련 감염 위험 요인','G-1','청결·오염구역 혼재'),
 (24,'환자에 영향을 주는 감염 위험 요인','G','환경 관련 감염 위험 요인','G-2','환경표면의 정기적·적절한 청소 및 소독'),
 (25,'환자에 영향을 주는 감염 위험 요인','H','지역사회 감염 위험 요인','H-1','지리적 특성 관련 감염위험요인'),
 (26,'환자에 영향을 주는 감염 위험 요인','H','지역사회 감염 위험 요인','H-2','지역사회 인구분포 관련 감염위험요인'),
 (27,'직원에게 영향을 주는 감염 위험 요인','I','감염질환 노출','I-1','혈액매개질환자(주사침 손상 등)'),
 (28,'직원에게 영향을 주는 감염 위험 요인','I','감염질환 노출','I-2','수두/홍역 노출'),
 (29,'직원에게 영향을 주는 감염 위험 요인','I','감염질환 노출','I-3','결핵 노출'),
 (30,'직원에게 영향을 주는 감염 위험 요인','I','감염질환 노출','I-4','옴 노출'),
 (31,'직원에게 영향을 주는 감염 위험 요인','I','감염질환 노출','I-5','코로나 노출')
ON DUPLICATE KEY UPDATE GRP_NM=VALUES(GRP_NM), SEC_CD=VALUES(SEC_CD), SEC_NM=VALUES(SEC_NM),
                        ITEM_NO=VALUES(ITEM_NO), ITEM_NM=VALUES(ITEM_NM), USE_YN='Y';
