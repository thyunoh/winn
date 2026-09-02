-- ═══════════════════════════════════════════════════════════════════════════
-- 보류분 재판정 2차 — 기존 축으로 담기는 4종 (2026-08-15)
--   ★[RETRY 시드](QPS_SEED_RETRY_2026-08-14.sql) 와 같은 성격이다 : **새 조각을 만들지 않고**
--     보류 사유를 다시 따져 기존 축에 넣는다. 이번에도 **사유가 코드와 어긋나 있었다.**
--
--   ⓐ **w43·w44·w45 기기 예방점검표 3종** — 판독은 「건별 점검 체크리스트 = 신규 조각」이라 했고
--      보류 사유는 「결과 열 구성이 3색이라 셀 타입이 갈린다」였다. 실측하니 :
--        · `ITEM_COL` 의 `COL_NMS` 는 ***`묶음>열` 2단 머리***를 이미 푼다(qpsChk.colDefs) —
--          w45 의 「점검여부/점검결과/조치여부 × 2택」 6열이 그대로 들어간다.
--        · `HEAD_NMS` 는 **8칸**이다 — 기기정보·점검업체·점검자·점검일이 전부 머리 칸에 들어간다.
--        · ★**`INPUT_GB` 는 정렬(가운데/왼쪽)만 바꾼다**(cell() 의 `ltxt` 클래스 하나) —
--          ***「셀 타입이 갈린다」는 것이 등록을 막는 제약이 아니었다.***
--      ⇒ 셋 다 `ITEM_COL` + 일 단위 문서(점검일이 문서 키). RN16 을 LIST 로 푼 것과 같은 결론.
--      ⚠**셋을 한 서식으로 묶지 않는다** — 항목·열·머리가 제각각(판독 §13 비교표). 원본대로 3벌.
--
--   ⓑ **RN31 응급키트 물품점검대장** — 보류 사유는 「유효기간 열이 사라진다 · 앞/뒤 열은 ITEM_DAY 에 없다」.
--      실측하니 `sideOk()` 는 **ITEM_DAY 를 포함**하고(화면·서버 양쪽 같은 판단),
--      앞/뒤 열 값은 **행마다 따로 저장**된다(`ROW_NO` × `PRE_BASE+j`) — 「행마다 다른 유효기간」이
--      바로 그 장치다. ⇒ `ITEM_DAY` + `DESC_NM='수량'`(서식 고정값) + `PRE_COLS='유효기간'`(문서 값).
--      ★원본 열 차례(품명|수량|유효기간|1~31일)와 화면 차례(설명칸→앞 열→격자)가 **그대로 맞는다.**
--      캡처 `RN_2026-08-14/RN31.png` 직접 재판독으로 21행·수량 확정(판독 채록은 수량이 뭉개져 있었다).
--
--   ⛔여전히 보류 : w42(5쪽 연1회 결과보고 — 기기 마스터 사안) · w15(셀 고정문) · MR13(기능화면) ·
--     XR23(문서 키=사람) · RN25(LIST+ITEM_DAY 복합) · RN08~10(검사 성적서).
-- 재실행 안전(DELETE 후 INSERT).
-- ═══════════════════════════════════════════════════════════════════════════

DELETE FROM TBL_QPS_CHK_ITEM WHERE HOSP_CD='*' AND FORM_ID IN ('ADM016','ADM017','ADM018','RNL027');
DELETE FROM TBL_QPS_CHK_FORM WHERE HOSP_CD='*' AND FORM_ID IN ('ADM016','ADM017','ADM018','RNL027');

-- ═══ ⓐ 기기 예방점검표 3종 (ITEM_COL · 점검일이 문서 키) ══════════════════
INSERT INTO TBL_QPS_CHK_FORM
 (FORM_ID, HOSP_CD, FORM_NM, CATE_CD, DEPT_CD, AXIS_GB, PRD_GB, COL_NMS, HEAD_NMS,
  SIGNER_YN, NOTE_YN, FIX_YN, SORT_NO, USE_YN, REG_USER) VALUES
 -- w43 — ★제목의 `SETAM` 은 원본 표기 그대로(Steam 오타로 보이나 종이와 글자가 달라지면 안 된다)
 ('ADM016','*','SETAM STERILIZER(고압증기멸균기) 예방 점검표','EQUIP','ADMIN','ITEM_COL','D',
  '적합,부적합,관찰,조치여부',
  'MODEL,Serial No,설치장소,점검업체,점검자',
  'N','N','N',320,'Y','system'),
 -- w44 — 점검자·서명이 머리에 있다(하단 없음)
 ('ADM017','*','인공호흡기(Ventilator) 예방 점검표','EQUIP','ADMIN','ITEM_COL','D',
  '적합,부적합,조치사항',
  '장비명,모델,제조사,제조번호,점검업체,점검자,서명',
  'N','N','N',330,'Y','system'),
 -- w45 — ★2단 머리 6열 : `묶음>열` 규칙
 ('ADM018','*','자동 제세동기 예방 점검표','EQUIP','ADMIN','ITEM_COL','D',
  '점검여부>예,점검여부>아니오,점검결과>적합,점검결과>부적합,조치여부>예,조치여부>아니오',
  '사용부서,업체명,검사자,제조사,모델명,SN/제조번호',
  'N','N','N',340,'Y','system');

-- ── w43 항목 : 그룹 8 × 세부 32 ─────────────────────────────────────────────
INSERT INTO TBL_QPS_CHK_ITEM (FORM_ID,HOSP_CD,SORT,ITEM_NM,GRP_NM,INPUT_GB,CARRY_YN,USE_YN) VALUES
 ('ADM016','*', 1,'적정전압인가 (230V ±10%)'                    ,'전 압'    ,'CHECK','N','Y'),
 ('ADM016','*', 2,'Auto Fuse 작동 상태'                         ,'전 압'    ,'CHECK','N','Y'),
 ('ADM016','*', 3,'A.C Cord 접촉상태'                           ,'전 압'    ,'CHECK','N','Y'),
 ('ADM016','*', 4,'보호접지 및 누전체크 ( 5MΩ 이상 )'           ,'전 압'    ,'CHECK','N','Y'),
 ('ADM016','*', 5,'Float Ball 작동 상태'                        ,'저수통'   ,'CHECK','N','Y'),
 ('ADM016','*', 6,'청결 상태'                                   ,'저수통'   ,'CHECK','N','Y'),
 ('ADM016','*', 7,'원활한 작동 여부 ( 40 psi )'                  ,'안전밸브' ,'CHECK','N','Y'),
 ('ADM016','*', 8,'Door Switch 접점상태'                        ,'DOOR'     ,'CHECK','N','Y'),
 ('ADM016','*', 9,'Needle Bearing 및 윤활상태'                  ,'DOOR'     ,'CHECK','N','Y'),
 ('ADM016','*',10,'문 잠금장치 안전작동 여부'                    ,'DOOR'     ,'CHECK','N','Y'),
 ('ADM016','*',11,'Gasket 상태'                                 ,'DOOR'     ,'CHECK','N','Y'),
 ('ADM016','*',12,'정상작동 여부'                               ,'압력게이지','CHECK','N','Y'),   -- 2026-09-02 원본(Employee_Chart_037) 대조 : 「정상동작」→「정상작동」
 ('ADM016','*',13,'정상작동 여부'                               ,'온도센서' ,'CHECK','N','Y'),
 ('ADM016','*',14,'멸균 사이클 정상가동 여부'                    ,'성 능'    ,'CHECK','N','Y'),
 ('ADM016','*',15,'건조성능 (멸균전 중량의+3%이내)'              ,'성 능'    ,'CHECK','N','Y'),
 ('ADM016','*',16,'급수(설정시간 이내 급수완료)'                 ,'성 능'    ,'CHECK','N','Y'),
 ('ADM016','*',17,'가열(60분 이내 가열 완료)'                    ,'성 능'    ,'CHECK','N','Y'),
 ('ADM016','*',18,'온도편차:설정온도 ±4`C'                       ,'성 능'    ,'CHECK','N','Y'),
 ('ADM016','*',19,'멸균온도:설정온도+3`C, -0`C'                  ,'성 능'    ,'CHECK','N','Y'),
 ('ADM016','*',20,'배기:107`C에서완료 알람확인'                  ,'성 능'    ,'CHECK','N','Y'),
 ('ADM016','*',21,'멸균압력:134`C (2kgf/cm2설정유지여부)'        ,'성 능'    ,'CHECK','N','Y'),
 ('ADM016','*',22,'Chamber의 기밀 상태'                          ,'성 능'    ,'CHECK','N','Y'),
 ('ADM016','*',23,'완료후알람및경보기능작동'                      ,'성 능'    ,'CHECK','N','Y'),
 ('ADM016','*',24,'증류수, 경수의 사용 여부'                      ,'기 타'    ,'CHECK','N','Y'),
 ('ADM016','*',25,'Tray (Basket) 사용 여부'                      ,'기 타'    ,'CHECK','N','Y'),
 ('ADM016','*',26,'제품의 수평 상태'                             ,'기 타'    ,'CHECK','N','Y'),   -- 2026-09-02 원본 대조 : 「수령」→「수평」
 ('ADM016','*',27,'제품주위 환경 (적정온도, 습도 유지 여부)'      ,'기 타'    ,'CHECK','N','Y'),
 ('ADM016','*',28,'배관의 누수 여부'                             ,'기 타'    ,'CHECK','N','Y'),
 ('ADM016','*',29,'Chamber의 청결 상태'                          ,'기 타'    ,'CHECK','N','Y'),
 ('ADM016','*',30,'과열차단장치 작동 여부'                        ,'기 타'    ,'CHECK','N','Y'),
 ('ADM016','*',31,'Heater의 부식 상태'                           ,'기 타'    ,'CHECK','N','Y'),
 ('ADM016','*',32,'제품의 외관 상태'                             ,'기 타'    ,'CHECK','N','Y'),
 ('ADM016','*',33,'기록장치 점검'                                ,'기 타'    ,'CHECK','N','Y');

-- ── w44 항목 : 평면 9 (원본의 빈 행 2 는 서식이 아니라 여백이라 넣지 않는다) ──
INSERT INTO TBL_QPS_CHK_ITEM (FORM_ID,HOSP_CD,SORT,ITEM_NM,INPUT_GB,CARRY_YN,USE_YN) VALUES
 ('ADM017','*',1,'장비외관 상태 점검'        ,'CHECK','N','Y'),
 ('ADM017','*',2,'Keypad 기능점검'           ,'CHECK','N','Y'),
 ('ADM017','*',3,'Power switch 점검'         ,'CHECK','N','Y'),
 ('ADM017','*',4,'I:E ratio 설정 값 점검'    ,'CHECK','N','Y'),
 ('ADM017','*',5,'Tidal Volume 점검'         ,'CHECK','N','Y'),
 ('ADM017','*',6,'PEEP 설정 값 점검'         ,'CHECK','N','Y'),
 ('ADM017','*',7,'O2 설정 값과 측정 값 확인' ,'CHECK','N','Y'),
 ('ADM017','*',8,'모니터링 값 점검'          ,'CHECK','N','Y'),
 ('ADM017','*',9,'Accessory 점검'            ,'CHECK','N','Y');

-- ── w45 항목 : 평면 8 ───────────────────────────────────────────────────────
INSERT INTO TBL_QPS_CHK_ITEM (FORM_ID,HOSP_CD,SORT,ITEM_NM,INPUT_GB,CARRY_YN,USE_YN) VALUES
 ('ADM018','*',1,'전원접합부상태'        ,'CHECK','N','Y'),
 ('ADM018','*',2,'keypad 기능점검'       ,'CHECK','N','Y'),
 ('ADM018','*',3,'POWER SWITCH 점검'     ,'CHECK','N','Y'),
 ('ADM018','*',4,'설정에너지 점검'       ,'CHECK','N','Y'),
 ('ADM018','*',5,'R-wave sync 점검'      ,'CHECK','N','Y'),
 ('ADM018','*',6,'누설전류 점검'         ,'CHECK','N','Y'),
 ('ADM018','*',7,'배터리 구동시 작동점검','CHECK','N','Y'),
 ('ADM018','*',8,'EKG wave 점검'         ,'CHECK','N','Y');

-- ═══ ⓑ RN31 응급키트 물품점검대장 (ITEM_DAY + 설명칸 수량 + 앞 열 유효기간) ═══
--   상단 2행(봉인 여부·Laryngoscope)은 유효기간이 없는 줄이라 묶음 없이 먼저 놓고,
--   그 아래 21행을 「Emergency cart 목록」 묶음으로 둔다(약품 3종은 원본의 세로 「약품」 칸).
--   ⚠원본의 마지막 줄 이름은 「간호사 서명」이나 **엔진의 사인 행 이름은 고정**(「점검자 사인」)이다 —
--     SIGN_LINE 으로 따로 붙이면 격자 아래에 인쇄용 서명선이 **한 줄 더** 생겨 원본과 멀어진다.
--     등록된 305종이 모두 같은 고정 이름을 쓰므로 그대로 둔다(이름 오버라이드는 별건 사안).
INSERT INTO TBL_QPS_CHK_FORM
 (FORM_ID, HOSP_CD, FORM_NM, CATE_CD, DEPT_CD, AXIS_GB, PRD_GB, PRD_KIND,
  DESC_NM, PRE_COLS, SIGNER_YN, NOTE_YN, FIX_YN, SORT_NO, USE_YN, REG_USER) VALUES
 ('RNL027','*','응급키트 물품 점검대장','EQUIP','RENAL','ITEM_DAY','M','D',
  '수량','유효기간','Y','N','N',1770,'Y','system');

INSERT INTO TBL_QPS_CHK_ITEM (FORM_ID,HOSP_CD,SORT,ITEM_NM,GRP_NM,DESC_TXT,INPUT_GB,CARRY_YN,USE_YN) VALUES
 ('RNL027','*', 1,'응급키트 봉인 여부'    ,NULL                ,'유/무' ,'CHECK','N','Y'),
 ('RNL027','*', 2,'Laryngoscope 작동여부' ,NULL                ,'유/무' ,'CHECK','N','Y'),
 ('RNL027','*', 3,'아트로핀'              ,'약품'              ,'5'     ,'CHECK','N','Y'),
 ('RNL027','*', 4,'에피네프린'            ,'약품'              ,'5'     ,'CHECK','N','Y'),
 ('RNL027','*', 5,'이노판'                ,'약품'              ,'5'     ,'CHECK','N','Y'),
 ('RNL027','*', 6,'3-Way'                 ,'Emergency cart 목록','2'    ,'CHECK','N','Y'),
 ('RNL027','*', 7,'주사기(3, 5, 10cc)'    ,'Emergency cart 목록','5/2/2','CHECK','N','Y'),
 ('RNL027','*', 8,'Angio (24, 18G)'       ,'Emergency cart 목록','3/2'  ,'CHECK','N','Y'),
 ('RNL027','*', 9,'Laryngoscope'          ,'Emergency cart 목록','대/중','CHECK','N','Y'),
 ('RNL027','*',10,'E-tube (6, 6.5, 7.0)'  ,'Emergency cart 목록','1/1/1','CHECK','N','Y'),
 ('RNL027','*',11,'Stylet'                ,'Emergency cart 목록','1'    ,'CHECK','N','Y'),
 ('RNL027','*',12,'면/종이반창고'          ,'Emergency cart 목록','1/1'  ,'CHECK','N','Y'),
 ('RNL027','*',13,'Airway (#3, #4)'       ,'Emergency cart 목록','1/1'  ,'CHECK','N','Y'),
 ('RNL027','*',14,'Electrode/ S-jelly'    ,'Emergency cart 목록','3/1'  ,'CHECK','N','Y'),
 ('RNL027','*',15,'멸균Glove 7.0/7.5'     ,'Emergency cart 목록','2/2'  ,'CHECK','N','Y'),
 ('RNL027','*',16,'IV-Set'                ,'Emergency cart 목록','3'    ,'CHECK','N','Y'),
 ('RNL027','*',17,'Ambu Bag/ Mask'        ,'Emergency cart 목록','1/1'  ,'CHECK','N','Y'),
 ('RNL027','*',18,'Nasal prong'           ,'Emergency cart 목록','1'    ,'CHECK','N','Y'),
 ('RNL027','*',19,'O2 Line/O2 Mask'       ,'Emergency cart 목록','1/1'  ,'CHECK','N','Y'),
 ('RNL027','*',20,'Suction catheter'      ,'Emergency cart 목록','3'    ,'CHECK','N','Y'),
 ('RNL027','*',21,'Pen light/건전지'      ,'Emergency cart 목록','1/1'  ,'CHECK','N','Y'),
 ('RNL027','*',22,'Tourniquet'            ,'Emergency cart 목록','1'    ,'CHECK','N','Y'),
 ('RNL027','*',23,'알콜솜'                ,'Emergency cart 목록','2'    ,'CHECK','N','Y'),
 ('RNL027','*',24,'N/S 500ml'             ,'Emergency cart 목록','1'    ,'CHECK','N','Y'),
 ('RNL027','*',25,'0cc 멸균생리식염수'    ,'Emergency cart 목록','3'    ,'CHECK','N','Y');

-- ── 확인 ────────────────────────────────────────────────────────────────────
SELECT f.FORM_ID, f.FORM_NM, f.AXIS_GB, f.PRD_GB, f.COL_NMS, f.DESC_NM, f.PRE_COLS,
       (SELECT COUNT(*) FROM TBL_QPS_CHK_ITEM i WHERE i.FORM_ID=f.FORM_ID AND i.HOSP_CD='*') items
  FROM TBL_QPS_CHK_FORM f
 WHERE f.HOSP_CD='*' AND f.FORM_ID IN ('ADM016','ADM017','ADM018','RNL027')
 ORDER BY f.FORM_ID;
SELECT COUNT(*) AS chk_total FROM TBL_QPS_CHK_FORM WHERE HOSP_CD='*' AND USE_YN='Y';
