-- ═══════════════════════════════════════════════════════════════════════════
-- 점검표 표준 서식 시드 — 영양 (2026-08-12)
--   원본 캡처 : SUNWOO HCMS ▸ 영양 ▸ 영양서식
--
-- ★캡처에 있는 것만 넣었다. **지어낸 항목은 하나도 없다.**
-- ★★***원본의 오타도 그대로 옮긴다.*** 「전치리씽크대」·「쌩크대」처럼 눈에 띄는 것이 있지만
--   고치면 원본과 글자가 달라져 대조가 안 된다. ***오타를 고칠지는 병원이 정할 일이다***
--   (인수인계 ⑥ 결정 대기 「원본 오타」). 우리는 옮기기만 한다.
-- ═══════════════════════════════════════════════════════════════════════════

-- ═══════════════════════════════════════════════════════════════════════════
-- NUT001 · 영양초기평가 불량환자 관리 리스트                  [LIST · 연단위]
-- ═══════════════════════════════════════════════════════════════════════════
--   ★상단이 「2026 년」 하나뿐이다 ⇒ 한 해를 이어 쓰는 대장. 상단 자유칸 「담당자」.

DELETE FROM TBL_QPS_CHK_ITEM WHERE FORM_ID='NUT001' AND HOSP_CD='*';
DELETE FROM TBL_QPS_CHK_FORM WHERE FORM_ID='NUT001' AND HOSP_CD='*';

INSERT INTO TBL_QPS_CHK_FORM
 (FORM_ID, HOSP_CD, FORM_NM, CATE_CD, DEPT_CD, AXIS_GB, PRD_GB, EQUIP_CNT,
  GUIDE_TXT, HEAD_NMS, SIGNER_YN, NOTE_YN, FIX_YN, SIGN_LINE, FOOT_TXT, SORT_NO, USE_YN, REG_USER)
VALUES
 ('NUT001','*','영양초기평가 불량환자 관리 리스트','ENV','NUTRI','LIST','Y',25,
  NULL,'담당자','N','N','N',NULL,NULL,10,'Y','system');

INSERT INTO TBL_QPS_CHK_ITEM (FORM_ID, HOSP_CD, SORT, ITEM_NM, GRP_NM, INPUT_GB, UNIT_NM, USE_YN) VALUES
 ('NUT001','*',1,'입원일'  ,NULL,'TEXT',NULL,'Y'),
 ('NUT001','*',2,'호실'    ,NULL,'TEXT',NULL,'Y'),
 ('NUT001','*',3,'등록번호',NULL,'TEXT',NULL,'Y'),
 ('NUT001','*',4,'환자명'  ,NULL,'TEXT',NULL,'Y'),
 ('NUT001','*',5,'식사종류',NULL,'TEXT',NULL,'Y'),
 ('NUT001','*',6,'영양상태',NULL,'TEXT',NULL,'Y'),
 ('NUT001','*',7,'기타'    ,NULL,'TEXT',NULL,'Y');

-- ═══════════════════════════════════════════════════════════════════════════
-- NUT003 · 일일 위생점검표                     [ITEM_DAY · 행 그룹 11 · 항목 29]
-- ═══════════════════════════════════════════════════════════════════════════
--   ★행 그룹이 열하나다 — ***순서가 곧 묶음이므로 섞으면 묶음이 쪼개진다.***
--   ★항목 앞의 번호(1.~29.)는 **원본에 찍혀 있는 글자**라 그대로 둔다.
--   ★안내 「O :양호, △ :조치필요, X :당장조치」 — ***△ 가 있다.***
--     정규화는 △ 를 건드리지 않으므로 그대로 남지만, 이행 요약에서는 「기타」로 빠진다.

DELETE FROM TBL_QPS_CHK_ITEM WHERE FORM_ID='NUT003' AND HOSP_CD='*';
DELETE FROM TBL_QPS_CHK_FORM WHERE FORM_ID='NUT003' AND HOSP_CD='*';

INSERT INTO TBL_QPS_CHK_FORM
 (FORM_ID, HOSP_CD, FORM_NM, CATE_CD, DEPT_CD, AXIS_GB, PRD_GB, PRD_KIND, EQUIP_CNT,
  GUIDE_TXT, HEAD_NMS, SIGNER_YN, NOTE_YN, FIX_YN, SIGN_LINE, FOOT_TXT, SORT_NO, USE_YN, REG_USER)
VALUES
 ('NUT003','*','일일 위생점검표','ENV','NUTRI','ITEM_DAY','M','D',10,
  'O :양호, △ :조치필요, X :당장조치',NULL,'Y','N','N',NULL,NULL,30,'Y','system');

INSERT INTO TBL_QPS_CHK_ITEM (FORM_ID, HOSP_CD, SORT, ITEM_NM, GRP_NM, INPUT_GB, UNIT_NM, USE_YN) VALUES
 ('NUT003','*', 1,'1. 감염성질환 및 심리적 안정 상태 여부'                    ,'개인위생','CHECK',NULL,'Y'),
 ('NUT003','*', 2,'2. 복장(위생복, 위생모, 위생화, 앞치마, 마스크) 위생상태'    ,'개인위생','CHECK',NULL,'Y'),
 ('NUT003','*', 3,'3. 손상처, 손톱상태, 매니큐어사용, 장신구 착용여부'          ,'개인위생','CHECK',NULL,'Y'),
 ('NUT003','*', 4,'4. 손 및 장갑세척, 장화소독 시설의 적정이용 여부'            ,'개인위생','CHECK',NULL,'Y'),
 ('NUT003','*', 5,'5. 청결, 정리정돈, 교차오염 방지 및 식품 보관상태'           ,'냉장보관','CHECK',NULL,'Y'),
 ('NUT003','*', 6,'6. 냉장, 냉동실 온도 여부 (냉장 0~10℃, 냉동 -18℃)'          ,'냉장보관','CHECK',NULL,'Y'),
 ('NUT003','*', 7,'7. 식재료 보관실 정리, 정돈, 청결, 선입선출 여부'            ,'상온보관','CHECK',NULL,'Y'),
 ('NUT003','*', 8,'8. 온도, 습도, 채광, 환기상태'                             ,'상온보관','CHECK',NULL,'Y'),
 ('NUT003','*', 9,'9. 식재료 바닥에서 60cm이상 취급'                          ,'조리작업','CHECK',NULL,'Y'),
 ('NUT003','*',10,'10.조리전식품과조리된식품,칼,도마, 고무장갑의 구분사용'      ,'조리작업','CHECK',NULL,'Y'),
 ('NUT003','*',11,'11. 식품의 중심온도 75도 이상 가열'                        ,'조리작업','CHECK',NULL,'Y'),
 ('NUT003','*',12,'12. 조리 후 덮개사용 여부'                                ,'조리작업','CHECK',NULL,'Y'),
 ('NUT003','*',13,'13.조리기구(도마,행주)설비등의 적정세척 소독보관'           ,'조리작업','CHECK',NULL,'Y'),
 ('NUT003','*',14,'14. 배식용 위생복장 및 청결상태'                           ,'배식'    ,'CHECK',NULL,'Y'),
 ('NUT003','*',15,'15. 고장/수리를 요하는 시설,설비'                          ,'장비'    ,'CHECK',NULL,'Y'),
 ('NUT003','*',16,'16. 조리장 바닥, 배수로 걸음망 상태'                       ,'내부조리','CHECK',NULL,'Y'),
 ('NUT003','*',17,'17. 바닥, 벽 등의 파손 여부'                              ,'내부조리','CHECK',NULL,'Y'),
 ('NUT003','*',18,'18. 청결구역 및 오염구역의 조도(220Lux) 적정'              ,'내부조리','CHECK',NULL,'Y'),
 ('NUT003','*',19,'19. 조리실 후드 상태'                                     ,'내부조리','CHECK',NULL,'Y'),
 ('NUT003','*',20,'20. 조리실의 통풍, 환기 상태'                             ,'내부조리','CHECK',NULL,'Y'),
 ('NUT003','*',21,'21. 식품보관실-환기상태'                                  ,'내부조리','CHECK',NULL,'Y'),
 ('NUT003','*',22,'22. 조리종사자 휴게실 및 화장실 위생상태'                   ,'내부조리','CHECK',NULL,'Y'),
 ('NUT003','*',23,'23. 세제, 소독제, 살충제 분리 보관 상태'                    ,'분리'    ,'CHECK',NULL,'Y'),
 ('NUT003','*',24,'24. 조리실 내부의 쓰레기 처리 여부'                        ,'폐기물'  ,'CHECK',NULL,'Y'),
 ('NUT003','*',25,'25. 잔반의 위생적 처리 및당일수거여부'                      ,'폐기물'  ,'CHECK',NULL,'Y'),
 ('NUT003','*',26,'26. 벌레나 쥐 침입 및 서식방지 여부'                       ,'방충구서','CHECK',NULL,'Y'),
 ('NUT003','*',27,'27. 정기적 방역소독 실시 여부'                             ,'방충구서','CHECK',NULL,'Y'),
 ('NUT003','*',28,'28. 급식실 바닥은 미끄럽지 않은지'                         ,'안전'    ,'CHECK',NULL,'Y'),
 ('NUT003','*',29,'29. 가스, 수독꼭지 잠금상태'                               ,'안전'    ,'CHECK',NULL,'Y');

-- ═══════════════════════════════════════════════════════════════════════════
-- NUT004 · 청소계획표          [ITEM_DAY · 행 그룹 4 · **항목 설명 열(청소방법)**]
-- ═══════════════════════════════════════════════════════════════════════════
--   ★★***v3 순서 7 의 「항목 설명 열」이 실제로 쓰이는 첫 서식이다.***
--     「청소방법」은 **항목마다 늘 같은 글**이라 문서가 아니라 **항목의 속성**(DESC_TXT)이다.
--     입력칸으로 만들었으면 병원이 ***매달 「중성세제로 세척」을 스물몇 번 다시 쳤을 것이다.***
--   ★행 그룹 = 청소 주기(매일 / 1주 1일 / 월 1회 / 년 1회). 원본의 「구분」 칸 그대로.
--   ⚠**원본 오타를 그대로 옮겼다** — `전치리씽크대` · `쌩크대` · `받드정리`.
--     ***고치면 원본과 글자가 달라져 대조가 안 된다.*** 고칠지는 병원이 정한다.
--   ⚠담지 못한 것 : 화면 왼쪽 아래의 **[주말(공휴)서명] 단추**. 격자 밖 장치라 우리에게 없다.

DELETE FROM TBL_QPS_CHK_ITEM WHERE FORM_ID='NUT004' AND HOSP_CD='*';
DELETE FROM TBL_QPS_CHK_FORM WHERE FORM_ID='NUT004' AND HOSP_CD='*';

INSERT INTO TBL_QPS_CHK_FORM
 (FORM_ID, HOSP_CD, FORM_NM, CATE_CD, DEPT_CD, AXIS_GB, PRD_GB, PRD_KIND, EQUIP_CNT,
  DESC_NM, GUIDE_TXT, HEAD_NMS, SIGNER_YN, NOTE_YN, FIX_YN, SIGN_LINE, FOOT_TXT,
  SORT_NO, USE_YN, REG_USER)
VALUES
 ('NUT004','*','청소계획표','ENV','NUTRI','ITEM_DAY','M','D',10,
  '청소방법',NULL,NULL,'Y','N','N',NULL,NULL,40,'Y','system');

INSERT INTO TBL_QPS_CHK_ITEM (FORM_ID, HOSP_CD, SORT, ITEM_NM, GRP_NM, DESC_TXT, INPUT_GB, UNIT_NM, USE_YN) VALUES
 ('NUT004','*', 1,'조리대 주변'                ,'매일'  ,'양념통과 정리정돈'                          ,'CHECK',NULL,'Y'),
 ('NUT004','*', 2,'작업대, 세정대, 조리기구'     ,'매일'  ,'중성세제로 세척'                            ,'CHECK',NULL,'Y'),
 ('NUT004','*', 3,'도마, 칼,조리도구'           ,'매일'  ,'중성세제로 세척'                            ,'CHECK',NULL,'Y'),
 ('NUT004','*', 4,'냉장 & 냉동고'              ,'매일'  ,'정리정돈 (물기제거)'                        ,'CHECK',NULL,'Y'),
 ('NUT004','*', 5,'행주'                      ,'매일'  ,'점심 배식 후 삶기'                          ,'CHECK',NULL,'Y'),
 ('NUT004','*', 6,'작업대/안쪽 냉장고'          ,'매일'  ,'정리정돈 (물기제거)'                        ,'CHECK',NULL,'Y'),
 ('NUT004','*', 7,'식품보관실,작업대 선반'       ,'매일'  ,'정리정돈, 청결확인'                         ,'CHECK',NULL,'Y'),
 ('NUT004','*', 8,'식판, 환자식기, 수저'        ,'매일'  ,'중성세제로 세척- 수저는 삶기'                ,'CHECK',NULL,'Y'),
 ('NUT004','*', 9,'배수로 덮개 및 배수로'       ,'매일'  ,'음식물 제거 및 물청소'                       ,'CHECK',NULL,'Y'),
 ('NUT004','*',10,'조리실 바닥'                ,'매일'  ,'작업후 매일 물청소 중성세재로 세척(식용유 사용시)','CHECK',NULL,'Y'),
 ('NUT004','*',11,'배식대 주변정리/장갑/받드정리','매일'  ,'면장갑 정리/배식도구 정리'                   ,'CHECK',NULL,'Y'),
 ('NUT004','*',12,'배식카'                    ,'매일'  ,'매회 행주로 닦고 매일 환경 소독제로 소독 후 자연건조','CHECK',NULL,'Y'),
 ('NUT004','*',13,'배기 후드'                 ,'1주 1일','중성세제로 세척, 마른걸레로 닦기'             ,'CHECK',NULL,'Y'),
 ('NUT004','*',14,'배기후드, 가스버너'          ,'1주 1일','중성세제로 세척, 마른걸레로 닦기'             ,'CHECK',NULL,'Y'),
 ('NUT004','*',15,'배기후드, 조리대'           ,'1주 1일','중성세제로 세척, 마른걸레로 닦기'             ,'CHECK',NULL,'Y'),
 ('NUT004','*',16,'3단 취사 밥솥'             ,'1주 1일','중성세제로 세척, 마른걸레로 닦기'             ,'CHECK',NULL,'Y'),
 ('NUT004','*',17,'배기팬'                    ,'1주 1일','중성세제로 세척, 마른걸레로 닦기'             ,'CHECK',NULL,'Y'),
 ('NUT004','*',18,'전처리선반/전치리씽크대'      ,'1주 1일','중성세제로 세척, 마른걸레로 닦기'             ,'CHECK',NULL,'Y'),
 ('NUT004','*',19,'배식대/전처리쌩크대'         ,'1주 1일','중성세제로 세척, 마른걸레로 닦기'             ,'CHECK',NULL,'Y'),
 ('NUT004','*',20,'설거지 씽크대, 선반'         ,'1주 1일','중성세제로 세척, 마른걸레로 닦기'             ,'CHECK',NULL,'Y'),
 ('NUT004','*',21,'배식카 청소'                ,'1주 1일','중성세제로 세척'                            ,'CHECK',NULL,'Y'),
 ('NUT004','*',22,'식당&주방벽면, 천장'         ,'월 1회','거미줄, 먼지 제거'                          ,'CHECK',NULL,'Y'),
 ('NUT004','*',23,'식기 건조기'                ,'월 1회','중성세제로 세척, 마른걸레로 닦기'             ,'CHECK',NULL,'Y'),
 ('NUT004','*',24,'식당 의자'                 ,'월 1회','중성세제로 세척, 마른걸레로 닦기'             ,'CHECK',NULL,'Y'),
 ('NUT004','*',25,'식판 및 기기 스케일'         ,'년 1회','세제 사용'                                  ,'CHECK',NULL,'Y'),
 ('NUT004','*',26,'위생관련기기 점검 및 보수'    ,'년 1회','업장 사정에 따라'                           ,'CHECK',NULL,'Y');

-- ═══════════════════════════════════════════════════════════════════════════
-- NUT005 · 안전 점검 일지                      [ITEM_DAY · 행 그룹 5 · 항목 27]
-- ═══════════════════════════════════════════════════════════════════════════
--   ★행 그룹 = 넘어짐·미끄러짐 / 잠김끼임 / 칼·도마 점검 / 가스테이블점검체크 / 기타.
--   ★항목 번호가 **묶음마다 1부터 다시 시작한다**(원본 그대로). 그래서 「1.」이 다섯 번 나온다.
--   ⚠**항목 3-4 는 원본 화면에서 글자가 잘려 보인다** — `4. 절단,다듬기,뼈 발라내기를 할 때 칼의`.
--     ***보이는 데까지만 옮겼다.*** 뒤를 지어내면 원본이 아니다.
--     ⇒ 깨끗한 캡처(또는 원본 PDF)로 이 한 줄만 확인할 것. **재캡처 목록에 더한다.**

DELETE FROM TBL_QPS_CHK_ITEM WHERE FORM_ID='NUT005' AND HOSP_CD='*';
DELETE FROM TBL_QPS_CHK_FORM WHERE FORM_ID='NUT005' AND HOSP_CD='*';

INSERT INTO TBL_QPS_CHK_FORM
 (FORM_ID, HOSP_CD, FORM_NM, CATE_CD, DEPT_CD, AXIS_GB, PRD_GB, PRD_KIND, EQUIP_CNT,
  GUIDE_TXT, HEAD_NMS, SIGNER_YN, NOTE_YN, FIX_YN, SIGN_LINE, FOOT_TXT, SORT_NO, USE_YN, REG_USER)
VALUES
 ('NUT005','*','안전 점검 일지','ENV','NUTRI','ITEM_DAY','M','D',10,
  '점검결과는 위험이 없는 경우(O), 위험이 있는 경우(X)로 표기, 비고란에 문제점 및 대책을 간략히 작성',
  NULL,'Y','Y','N',NULL,NULL,50,'Y','system');

INSERT INTO TBL_QPS_CHK_ITEM (FORM_ID, HOSP_CD, SORT, ITEM_NM, GRP_NM, INPUT_GB, UNIT_NM, USE_YN) VALUES
 ('NUT005','*', 1,'1. 바닥의 물,기름,물때 등으로 인해 미끄러진 위험 여부'          ,'넘어짐·미끄러짐','CHECK',NULL,'Y'),
 ('NUT005','*', 2,'2. 통로 확보 및 통행로에 물품 적재, 방치 여부'                 ,'넘어짐·미끄러짐','CHECK',NULL,'Y'),
 ('NUT005','*', 3,'3. 장애물(문턱,배관,파인곳 등)로 인해 넘어질 위험 여부'          ,'넘어짐·미끄러짐','CHECK',NULL,'Y'),
 ('NUT005','*', 4,'4. 미끄럼 방지용 안전장화, 작업화 등 착용 여부'                 ,'넘어짐·미끄러짐','CHECK',NULL,'Y'),
 ('NUT005','*', 5,'1. 재료 운반대차 및 배식자에 끼일 위험 여부'                    ,'잠김끼임'      ,'CHECK',NULL,'Y'),
 ('NUT005','*', 6,'2. 양념재료(마늘,파,양파 등)분쇄기, 절단기에 말려들 위험 여부'    ,'잠김끼임'      ,'CHECK',NULL,'Y'),
 ('NUT005','*', 7,'1. 작업 용도에 적합한 칼과 도마를 사용하는지 여부'               ,'칼·도마 점검'  ,'CHECK',NULL,'Y'),
 ('NUT005','*', 8,'2. 칼날은 작업에 적합할 만큼의 날카로움을 유지하고 있는지 여부'    ,'칼·도마 점검'  ,'CHECK',NULL,'Y'),
 ('NUT005','*', 9,'3. 작업 중 흡연,잡담,휴대폰 통화 등 불필요한 행동 여부'          ,'칼·도마 점검'  ,'CHECK',NULL,'Y'),
 ('NUT005','*',10,'4. 절단,다듬기,뼈 발라내기를 할 때 칼의'                        ,'칼·도마 점검'  ,'CHECK',NULL,'Y'),
 ('NUT005','*',11,'5. 칼 사용 후 작업대 위에 걸쳐서 방치 여부'                     ,'칼·도마 점검'  ,'CHECK',NULL,'Y'),
 ('NUT005','*',12,'6. 칼 손잡이에서 손이 미끄러질 위험 여부'                       ,'칼·도마 점검'  ,'CHECK',NULL,'Y'),
 ('NUT005','*',13,'7. 장시간 칼 작업으로 어깨 결림 등의 위험 여부'                  ,'칼·도마 점검'  ,'CHECK',NULL,'Y'),
 ('NUT005','*',14,'1. 호스에서 가스 누설 위험 여부'                               ,'가스테이블점검체크','CHECK',NULL,'Y'),
 ('NUT005','*',15,'2. 가스누출 자동차단기 및 누설경보기 작동상태 여부'              ,'가스테이블점검체크','CHECK',NULL,'Y'),
 ('NUT005','*',16,'3. 호스의 상태는 양호한지 여부'                                ,'가스테이블점검체크','CHECK',NULL,'Y'),
 ('NUT005','*',17,'4. 가스호스의 각 연결부위의 상태는 양호한지 여부'                ,'가스테이블점검체크','CHECK',NULL,'Y'),
 ('NUT005','*',18,'5. 가스테이블이 작업대에서 떨어질 위험 여부'                     ,'가스테이블점검체크','CHECK',NULL,'Y'),
 ('NUT005','*',19,'6. 가스테이블의 호스에 작업자의 발이 걸리는 여부'                ,'가스테이블점검체크','CHECK',NULL,'Y'),
 ('NUT005','*',20,'7. 조리도구를 올리거나 내릴 때 안전하게 작업하는지 여부'          ,'가스테이블점검체크','CHECK',NULL,'Y'),
 ('NUT005','*',21,'8. 가스테이블 앞 작업공간은 충분하게 확보되었는지 여부'           ,'가스테이블점검체크','CHECK',NULL,'Y'),
 ('NUT005','*',22,'9. 가스테이블 작업대 바닥에 물기 제거 여부'                      ,'가스테이블점검체크','CHECK',NULL,'Y'),
 ('NUT005','*',23,'10. 작업장 환기는 실시하는지 여부'                              ,'가스테이블점검체크','CHECK',NULL,'Y'),
 ('NUT005','*',24,'1. 냉동육,생선 등에 칼 사용시 베임방지장갑 착용 여부'             ,'기타'          ,'CHECK',NULL,'Y'),
 ('NUT005','*',25,'2. 전기 기구에 접지 또는 누전차단기 설치, 피복상태 확인 여부'      ,'기타'          ,'CHECK',NULL,'Y'),
 ('NUT005','*',26,'3. 후드청소, 형광등 교체 등의 작업시 추락 위험 여부'              ,'기타'          ,'CHECK',NULL,'Y'),
 ('NUT005','*',27,'4. 중량물 취급작업 종사자의 올바른 작업자세 여부'                 ,'기타'          ,'CHECK',NULL,'Y');

-- ═══════════════════════════════════════════════════════════════════════════
-- NUT016 · 식중독 예방 위생 점검 일지
--                    [ITEM_DAY · **요일 7칸** · **주 단위 문서** · 뒤 열(비고)]
-- ═══════════════════════════════════════════════════════════════════════════
--   ★★***v3 에서 만든 것이 넷이나 한꺼번에 쓰이는 첫 서식이다*** :
--     · 문서 단위 **주**(`PRD_GB='W'`)  — 상단이 `2026-08-12 ~ 2026-08-18` 한 주다
--     · 격자 기간 **요일**(`PRD_KIND='W'`) — 열이 월·화·수·목·금·토·일
--     · **항목 뒤 열**(`POST_COLS='비고'`)
--     · 행 그룹 4
--   ★「1. 건강상태」 아래에 `1)설사 2)감기 3)화농성 피부질환` **3단**이 있다.
--     ***원본의 두 조각을 이어 붙여*** 2단으로 눌러 담았다(조리실 냉장/냉동고와 같은 방법).
--   ★판정 문서는 이 서식을 **「개별 화면 쪽 신호」**로 보았다 — 하단 「식중독 지수」가 **표**이기 때문이다.
--     ⇒ ***격자는 엔진에 정확히 맞는다.*** 지수 표는 **적는 칸이 아니라 안내**라 ※문구로 옮겼다.
--       표 모양은 잃었지만 글자는 다 남는다. ***병원이 주간 점검을 못 적는 쪽이 더 나쁘다.***
--   ⚠원본의 오타로 보이는 것(`운장 보관` · `아내 섭취`)도 **그대로** 옮겼다.
--   ★글자가 작아 **캡처를 2배로 늘려 다시 읽었다** — 그러지 않았으면 `팬코일`을 `팬크일`로 적을 뻔했다.
--     ***작은 글자는 확대해서 읽는다.***

DELETE FROM TBL_QPS_CHK_ITEM WHERE FORM_ID='NUT016' AND HOSP_CD='*';
DELETE FROM TBL_QPS_CHK_FORM WHERE FORM_ID='NUT016' AND HOSP_CD='*';

INSERT INTO TBL_QPS_CHK_FORM
 (FORM_ID, HOSP_CD, FORM_NM, CATE_CD, DEPT_CD, AXIS_GB, PRD_GB, PRD_KIND, EQUIP_CNT,
  POST_COLS, GUIDE_TXT, HEAD_NMS, SIGNER_YN, NOTE_YN, FIX_YN, SIGN_LINE, FOOT_TXT,
  SORT_NO, USE_YN, REG_USER)
VALUES
 ('NUT016','*','식중독 예방 위생 점검 일지','ENV','NUTRI','ITEM_DAY','W','W',10,
  '비고','적합 O / 부적합 X 기록',NULL,'Y','N','N',NULL,
  '[식중독 지수]
85이상 — 위험 3~4시간 내 부패, 음식물 취급 극히 주의, 식중독 위험
  → 조리 즉시 냉장 또는 온장보관 / 조리 후 최대한 빠른 시일 내 섭취 권장
50~85미만 — 경고 4~6시간 내 부패, 조리시설 취급 주의, 식중독 경고
  → 조리 즉시 냉장 또는 운장 보관 / 조리 후 2시간 이내 섭취 권장
35~50미만 — 주의 6~11시간 내 부패, 식중독 발생 우려 식중독 주의
  → 날 것 섭취 시 철저한 소독, 어패류 조리 시 가열 시간 익힘 정도 주위 (95도 5분 이상)
35미만 — 근심 식중독 발생우려, 음식물 취급 주의
  → 조리 후 2시간 아내 섭취 권장',
  55,'Y','system');

INSERT INTO TBL_QPS_CHK_ITEM (FORM_ID, HOSP_CD, SORT, ITEM_NM, GRP_NM, INPUT_GB, UNIT_NM, USE_YN) VALUES
 ('NUT016','*', 1,'1. 오염구역,위생구역 준수여부'                    ,'위생환경관리','CHECK',NULL,'Y'),
 ('NUT016','*', 2,'2. 조리장 바닥,도시가스배관,천장 팬코일 청결상태'   ,'위생환경관리','CHECK',NULL,'Y'),
 ('NUT016','*', 3,'3. 칼,도마의 재료별 구분 사용 준수'                ,'위생환경관리','CHECK',NULL,'Y'),
 ('NUT016','*', 4,'4. 칼,도마,행주의 적정 세척, 소독 여부'             ,'위생환경관리','CHECK',NULL,'Y'),
 ('NUT016','*', 5,'5. 조리기구,싱크대의 정돈 및 청결 상태'             ,'위생환경관리','CHECK',NULL,'Y'),
 ('NUT016','*', 6,'6. 조미료 및 식기창고의 정리 및 청결 상태'          ,'위생환경관리','CHECK',NULL,'Y'),
 ('NUT016','*', 7,'7. 조리장의 환풍기 가동상태(통풍)'                 ,'위생환경관리','CHECK',NULL,'Y'),
 ('NUT016','*', 8,'8. 방충방서 준수여부(쥐,곤충류 등)'                ,'위생환경관리','CHECK',NULL,'Y'),
 ('NUT016','*', 9,'9. 쓰레깃통의 관리상태/쓰레기장 청결 상태'          ,'위생환경관리','CHECK',NULL,'Y'),
 ('NUT016','*',10,'10. 배수구의 청결 상태'                           ,'위생환경관리','CHECK',NULL,'Y'),
 ('NUT016','*',11,'11. 작업장 내 소독발판의 관리상태'                 ,'위생환경관리','CHECK',NULL,'Y'),
 ('NUT016','*',12,'1. 건강상태 1)설사'                              ,'개인위생'    ,'CHECK',NULL,'Y'),
 ('NUT016','*',13,'1. 건강상태 2)감기'                              ,'개인위생'    ,'CHECK',NULL,'Y'),
 ('NUT016','*',14,'1. 건강상태 3)화농성 피부질환'                     ,'개인위생'    ,'CHECK',NULL,'Y'),
 ('NUT016','*',15,'2. 위생복 및 위생모,작업화 등의 착용, 청결 상태'     ,'개인위생'    ,'CHECK',NULL,'Y'),
 ('NUT016','*',16,'3. 손 세척 및 기록여부'                           ,'개인위생'    ,'CHECK',NULL,'Y'),
 ('NUT016','*',17,'4. 손톱의 청결 및 장신구(반지 등) 착용여부'          ,'개인위생'    ,'CHECK',NULL,'Y'),
 ('NUT016','*',18,'1. 변질,부패 및 유통기한 경과 여부'                ,'식재료보관관리','CHECK',NULL,'Y'),
 ('NUT016','*',19,'2. 교차오염 방지를 위한 구분 보관 여부'             ,'식재료보관관리','CHECK',NULL,'Y'),
 ('NUT016','*',20,'3. 가열조리식품과 비가열조리식품의 구분 여부'        ,'식재료보관관리','CHECK',NULL,'Y'),
 ('NUT016','*',21,'4. 과채류 등 원료의 절단 시 세척 선행 여부'          ,'식재료보관관리','CHECK',NULL,'Y'),
 ('NUT016','*',22,'5. 조리 후 배식 전 식품 보관 상태'                 ,'식재료보관관리','CHECK',NULL,'Y'),
 ('NUT016','*',23,'6. 경관유동식 재료 및 라벨링 적정성 여부'            ,'식재료보관관리','CHECK',NULL,'Y'),
 ('NUT016','*',24,'1. 작업장의 청결상태(바닥,유리창 등)'               ,'직원식당'    ,'CHECK',NULL,'Y'),
 ('NUT016','*',25,'2. 식탁의 청결 및 정돈 상태'                       ,'직원식당'    ,'CHECK',NULL,'Y'),
 ('NUT016','*',26,'3. 배식대 및 식수대 청결 상태'                     ,'직원식당'    ,'CHECK',NULL,'Y');

-- ═══════════════════════════════════════════════════════════════════════════
-- NUT006 · 개인위생 확인 기록지                        [LIST · 열 묶음 4]
-- ═══════════════════════════════════════════════════════════════════════════
--   ★열 묶음 넷 = 대상자 정보 / 건강상태 / 복장상태 / 손위생. 판정표와 정확히 맞았다.
--   ★※문구(관리기준 3줄)는 **감염성질환의 정의**라 한 글자도 줄이지 않는다.

DELETE FROM TBL_QPS_CHK_ITEM WHERE FORM_ID='NUT006' AND HOSP_CD='*';
DELETE FROM TBL_QPS_CHK_FORM WHERE FORM_ID='NUT006' AND HOSP_CD='*';

INSERT INTO TBL_QPS_CHK_FORM
 (FORM_ID, HOSP_CD, FORM_NM, CATE_CD, DEPT_CD, AXIS_GB, PRD_GB, EQUIP_CNT,
  GUIDE_TXT, HEAD_NMS, SIGNER_YN, NOTE_YN, FIX_YN, SIGN_LINE, FOOT_TXT, SORT_NO, USE_YN, REG_USER)
VALUES
 ('NUT006','*','개인위생 확인 기록지','ENV','NUTRI','LIST','M',30,
  '점검시간 : 작업전 확인',NULL,'N','N','N',NULL,
  '관리기준 - *감염성질환 : 설사, 고열, 구토, 피부발적/습진, 인후염, 결핵, 눈·코·귀 에 진물, 알레르기질환, 피부감염자(화상, 화농성 질환 또는 상처)
         *복장상태, 손위생 :  양호 : O,  불량 : X
개선조치 - *시정, 작업배제, 작업변경, 복장교체 등 조치',
  60,'Y','system');

INSERT INTO TBL_QPS_CHK_ITEM (FORM_ID, HOSP_CD, SORT, ITEM_NM, GRP_NM, INPUT_GB, UNIT_NM, USE_YN) VALUES
 ('NUT006','*', 1,'일'          ,'대상자 정보','TEXT' ,NULL,'Y'),
 ('NUT006','*', 2,'이름'        ,'대상자 정보','TEXT' ,NULL,'Y'),
 ('NUT006','*', 3,'감염성질병유무','건강상태'  ,'CHECK',NULL,'Y'),
 ('NUT006','*', 4,'위생복'      ,'복장상태'   ,'CHECK',NULL,'Y'),
 ('NUT006','*', 5,'위생모'      ,'복장상태'   ,'CHECK',NULL,'Y'),
 ('NUT006','*', 6,'위생화'      ,'복장상태'   ,'CHECK',NULL,'Y'),
 ('NUT006','*', 7,'손상처'      ,'손위생'     ,'CHECK',NULL,'Y'),
 ('NUT006','*', 8,'손톱상태'    ,'손위생'     ,'CHECK',NULL,'Y'),
 ('NUT006','*', 9,'장신구착용'   ,'손위생'     ,'CHECK',NULL,'Y'),
 ('NUT006','*',10,'개선 조치'    ,NULL        ,'TEXT' ,NULL,'Y'),
 ('NUT006','*',11,'확인자 서명'  ,NULL        ,'TEXT' ,NULL,'Y');

-- ═══════════════════════════════════════════════════════════════════════════
-- NUT007 · 조리실 냉장/냉동고 온도 및 위생 관리일지   [ITEM_DAY · 행 그룹 2]
-- ═══════════════════════════════════════════════════════════════════════════
--   ★★***판정 문서가 「3단 머리글을 2단으로 눌러 담는다」고 적어 둔 그 서식이다.***
--     원본 왼쪽은 세 겹 — `냉장고` → `온도` → `9am/12pm/5pm`.
--     우리 행 그룹은 두 겹이므로 **원본의 두 조각을 이어 붙여** 「온도 9am」으로 담았다.
--     ***없는 말은 보태지 않았다*** — `온도` 도 `9am` 도 원본에 있는 글자다.
--   ★온도는 **NUM(℃)**, 청결도·유통기한 준수는 CHECK. ***섞으면 온도 「1」이 「O」가 된다.***

DELETE FROM TBL_QPS_CHK_ITEM WHERE FORM_ID='NUT007' AND HOSP_CD='*';
DELETE FROM TBL_QPS_CHK_FORM WHERE FORM_ID='NUT007' AND HOSP_CD='*';

INSERT INTO TBL_QPS_CHK_FORM
 (FORM_ID, HOSP_CD, FORM_NM, CATE_CD, DEPT_CD, AXIS_GB, PRD_GB, PRD_KIND, EQUIP_CNT,
  GUIDE_TXT, HEAD_NMS, SIGNER_YN, NOTE_YN, FIX_YN, SIGN_LINE, FOOT_TXT, SORT_NO, USE_YN, REG_USER)
VALUES
 ('NUT007','*','조리실 냉장/냉동고 온도 및 위생 관리일지','ENV','NUTRI','ITEM_DAY','M','D',10,
  '※온도(섭씨)-냉장:0~10℃, 냉동:-18℃ 이하 / 청결도-양호:O, 불량:X / 유통기한-준수:O, 미준수:X',
  NULL,'Y','N','N',NULL,NULL,70,'Y','system');

INSERT INTO TBL_QPS_CHK_ITEM (FORM_ID, HOSP_CD, SORT, ITEM_NM, GRP_NM, INPUT_GB, UNIT_NM, USE_YN) VALUES
 ('NUT007','*', 1,'온도 9am'      ,'냉장고','NUM'  ,'℃','Y'),
 ('NUT007','*', 2,'온도 12pm'     ,'냉장고','NUM'  ,'℃','Y'),
 ('NUT007','*', 3,'온도 5pm'      ,'냉장고','NUM'  ,'℃','Y'),
 ('NUT007','*', 4,'청결도'        ,'냉장고','CHECK',NULL,'Y'),
 ('NUT007','*', 5,'유통기한 준수'  ,'냉장고','CHECK',NULL,'Y'),
 ('NUT007','*', 6,'온도 9am'      ,'냉동고','NUM'  ,'℃','Y'),
 ('NUT007','*', 7,'온도 12pm'     ,'냉동고','NUM'  ,'℃','Y'),
 ('NUT007','*', 8,'온도 5pm'      ,'냉동고','NUM'  ,'℃','Y'),
 ('NUT007','*', 9,'청결도'        ,'냉동고','CHECK',NULL,'Y'),
 ('NUT007','*',10,'유통기한 준수'  ,'냉동고','CHECK',NULL,'Y');

-- ═══════════════════════════════════════════════════════════════════════════
-- NUT010 · 음식물 쓰레기 관리대장                            [DAY_ITEM · 월]
-- ═══════════════════════════════════════════════════════════════════════════
--   ★날짜가 **행**, 세 항목이 **열**.
--   ⚠원본은 「자가 감량 방법」 칸에 **`음식 폐기물 처리기` 를 31줄 모두 미리 채워** 둔다.
--     그건 **그 병원이 쓰는 방법**이지 서식이 아니다 — 우리는 비워 두고 적게 한다.
--     ***항목으로 박으면 방법을 바꿀 때 지난달 기록까지 같이 바뀐다.***
--     ⇒ 매달 같은 글을 다시 치는 것이 불편하다는 말이 나오면 그때 **항목 설명 열**로 옮긴다.
--   ★판정 문서가 확인해 둔 것 : 「누계」는 **자동 계산이 아니라 사람이 적는다.**

DELETE FROM TBL_QPS_CHK_ITEM WHERE FORM_ID='NUT010' AND HOSP_CD='*';
DELETE FROM TBL_QPS_CHK_FORM WHERE FORM_ID='NUT010' AND HOSP_CD='*';

INSERT INTO TBL_QPS_CHK_FORM
 (FORM_ID, HOSP_CD, FORM_NM, CATE_CD, DEPT_CD, AXIS_GB, PRD_GB, PRD_KIND, EQUIP_CNT,
  GUIDE_TXT, HEAD_NMS, SIGNER_YN, NOTE_YN, FIX_YN, SIGN_LINE, FOOT_TXT, SORT_NO, USE_YN, REG_USER)
VALUES
 ('NUT010','*','음식물 쓰레기 관리대장','ENV','NUTRI','DAY_ITEM','M','D',10,
  '(단위 : Kg)',NULL,'N','N','N',NULL,NULL,100,'Y','system');

INSERT INTO TBL_QPS_CHK_ITEM (FORM_ID, HOSP_CD, SORT, ITEM_NM, GRP_NM, INPUT_GB, UNIT_NM, USE_YN) VALUES
 ('NUT010','*',1,'발생량'         ,NULL,'NUM' ,'Kg','Y'),
 ('NUT010','*',2,'자가 처리량 합계',NULL,'NUM' ,'Kg','Y'),
 ('NUT010','*',3,'자가 감량 방법'  ,NULL,'TEXT',NULL,'Y');

-- ═══════════════════════════════════════════════════════════════════════════
-- NUT015 · 건강관리 현황표                    [LIST · 연 · **행 블록 3**]
-- ═══════════════════════════════════════════════════════════════════════════
--   ★★***v3 순서 5(행 블록)가 실제로 쓰이는 첫 서식이다.***
--     ▶병원 근무자(17행) / ▶배송기사(3행) / ▶대체인력(3행) — **열은 셋 다 같다.**
--     서식을 셋으로 나눴다면 한 장에 인쇄되지 않아 원본과 달라진다.
--   ★행 번호는 블록마다 1000 단위로 띄운다 ⇒ 근무자를 한 명 더해도 **배송기사가 안 밀린다.**
--   ⚠**「건강관리 현황표」가 메뉴에 두 번 있다.** 판정 문서가 「3블록판 / 3단 열묶음판,
--     ***다른 서식이다***」라고 적어 두었다. 여기 넣은 것은 **3블록판**이다.
--     ⇒ 나머지 한 판은 캡처를 확인한 뒤 따로 등록한다. **합치지 않는다.**
--   ⚠원본 오타로 보이는 `건강점진` 도 그대로 옮겼다.

DELETE FROM TBL_QPS_CHK_ITEM WHERE FORM_ID='NUT015' AND HOSP_CD='*';
DELETE FROM TBL_QPS_CHK_FORM WHERE FORM_ID='NUT015' AND HOSP_CD='*';

INSERT INTO TBL_QPS_CHK_FORM
 (FORM_ID, HOSP_CD, FORM_NM, CATE_CD, DEPT_CD, AXIS_GB, PRD_GB, EQUIP_CNT,
  ROW_BLKS, GUIDE_TXT, HEAD_NMS, SIGNER_YN, NOTE_YN, FIX_YN, SIGN_LINE, FOOT_TXT,
  SORT_NO, USE_YN, REG_USER)
VALUES
 ('NUT015','*','건강관리 현황표','ENV','NUTRI','LIST','Y',17,
  '병원 근무자>17,배송기사>3,대체인력>3',
  NULL,'담당자','N','N','N',NULL,
  '[작성방법]
1. 구분 항목에 직책을 기재한다.
2. 입사일은 신규 입사일 또는 발령일을 작성한다.
3. 재검일은 검진일 기준 15일 전으로 기재한다. (건강점진 유효기간 : 기업 1년, 학교 6개월)
4. 결과란에는 건강진단 결과서에 나와 있는 결과를 기재한다.
5. 필수 진단 항목: 결핵, 장티푸스, 전염성 피부염 (학교장: 세균성이질 포함)
[주의사항]
1. 변경사항(인원변동, 재검 등) 발생 시 새로 작성·출력하여 보관한다.
2. 건강진단결과서는 검진일을 기준으로 관리하며, 재검일이 지나지 않도록 관리한다.
3. 건강관리 현황표는 건강진단 결과서를 보관하는 파일 맨앞장에 보관한다.
4. 건강관리 현황표는 기재순서와 건강진단 결과서의 보관순서를 일치시킨다.',
  150,'Y','system');

INSERT INTO TBL_QPS_CHK_ITEM (FORM_ID, HOSP_CD, SORT, ITEM_NM, GRP_NM, INPUT_GB, UNIT_NM, USE_YN) VALUES
 ('NUT015','*',1,'구분'    ,NULL,'TEXT',NULL,'Y'),
 ('NUT015','*',2,'성명'    ,NULL,'TEXT',NULL,'Y'),
 ('NUT015','*',3,'입사일자',NULL,'TEXT',NULL,'Y'),
 ('NUT015','*',4,'검진일자',NULL,'TEXT',NULL,'Y'),
 ('NUT015','*',5,'재검일자',NULL,'TEXT',NULL,'Y'),
 ('NUT015','*',6,'검사 결과',NULL,'TEXT',NULL,'Y');

-- ═══════════════════════════════════════════════════════════════════════════
-- NUT011 · 식기 세척기 점검 일지                             [DAY_ITEM · 월]
-- ═══════════════════════════════════════════════════════════════════════════
--   ★★***판정 문서가 「정규화 고침의 실증 사례」로 지목한 서식이다.***
--     열이 여덟인데 **「헹굼온도(℃)」 하나만 숫자**고 나머지는 O/X 표시다.
--     ***고치기 전이었다면 헹굼온도 「1」이 「O」로 바뀌었다.*** 오류도 안 나고 티도 안 난다.
--     ⇒ 헹굼온도는 반드시 **NUM**. 여기서 틀리면 자료가 조용히 망가진다.

DELETE FROM TBL_QPS_CHK_ITEM WHERE FORM_ID='NUT011' AND HOSP_CD='*';
DELETE FROM TBL_QPS_CHK_FORM WHERE FORM_ID='NUT011' AND HOSP_CD='*';

INSERT INTO TBL_QPS_CHK_FORM
 (FORM_ID, HOSP_CD, FORM_NM, CATE_CD, DEPT_CD, AXIS_GB, PRD_GB, PRD_KIND, EQUIP_CNT,
  GUIDE_TXT, HEAD_NMS, SIGNER_YN, NOTE_YN, FIX_YN, SIGN_LINE, FOOT_TXT, SORT_NO, USE_YN, REG_USER)
VALUES
 ('NUT011','*','식기 세척기 점검 일지','ENV','NUTRI','DAY_ITEM','M','D',10,
  '* 양호(○), 불량 및 정비필요(X)로 표시',NULL,'N','N','N',NULL,NULL,110,'Y','system');

INSERT INTO TBL_QPS_CHK_ITEM (FORM_ID, HOSP_CD, SORT, ITEM_NM, GRP_NM, INPUT_GB, UNIT_NM, USE_YN) VALUES
 ('NUT011','*',1,'작동단추 꺼짐'            ,NULL,'CHECK',NULL,'Y'),
 ('NUT011','*',2,'세제통 주위청결'          ,NULL,'CHECK',NULL,'Y'),
 ('NUT011','*',3,'헹굼온도'                ,NULL,'NUM'  ,'℃','Y'),
 ('NUT011','*',4,'걸음망 오물처리 세척'      ,NULL,'CHECK',NULL,'Y'),
 ('NUT011','*',5,'세척기 내·외부 청결 정리정돈',NULL,'CHECK',NULL,'Y'),
 ('NUT011','*',6,'배수관 막힘여부'          ,NULL,'CHECK',NULL,'Y'),
 ('NUT011','*',7,'수저·식기 빠짐여부'        ,NULL,'CHECK',NULL,'Y'),
 ('NUT011','*',8,'점검자'                  ,NULL,'TEXT' ,NULL,'Y');

-- ═══════════════════════════════════════════════════════════════════════════
-- COM001 · MSDS보관소 점검표 (일단위)     [LIST · 일 · **행 블록 2** · 부서 공통]
-- ═══════════════════════════════════════════════════════════════════════════
--   ★★***부서 「공통」의 첫 서식이다.*** 같은 서식이 **영양·시설 두 목록에** 그대로 있다.
--     부서마다 복제하면 같은 것이 둘이 되어 추출이 겹친다 ⇒ `DEPT_CD='COMMON'` 하나로 둔다.
--     (작성 화면의 부서 필터가 「그 부서 + 공통」을 함께 보이도록 2026-08-12 에 고쳐 두었다)
--   ★행 블록 2 : `spill kit 품목`(8행) / `MSDS 보관소 내부 품목`(6행).
--     ***원본은 블록마다 머리글을 다시 찍고 둘째 칸 이름만 다르다.***
--     공통 부분인 「품목」을 열 이름으로 두고, 다른 부분은 **블록 이름**이 지고 있다.
--   ⚠**「MSDS보관소 점검표」가 둘이다** — 이건 **일단위(자유행)** 판이고,
--     다른 하나는 **연단위(고정품목 × 12월)** 다. ***다른 서식이다.*** 합치지 않는다.

DELETE FROM TBL_QPS_CHK_ITEM WHERE FORM_ID='COM001' AND HOSP_CD='*';
DELETE FROM TBL_QPS_CHK_FORM WHERE FORM_ID='COM001' AND HOSP_CD='*';

INSERT INTO TBL_QPS_CHK_FORM
 (FORM_ID, HOSP_CD, FORM_NM, CATE_CD, DEPT_CD, AXIS_GB, PRD_GB, EQUIP_CNT,
  ROW_BLKS, GUIDE_TXT, HEAD_NMS, SIGNER_YN, NOTE_YN, FIX_YN, SIGN_LINE, FOOT_TXT,
  SORT_NO, USE_YN, REG_USER)
VALUES
 ('COM001','*','MSDS보관소 점검표','ENV','COMMON','LIST','D',8,
  'spill kit 품목>8,MSDS 보관소 내부 품목>6',
  NULL,'점검자','N','Y','N',NULL,NULL,10,'Y','system');

INSERT INTO TBL_QPS_CHK_ITEM (FORM_ID, HOSP_CD, SORT, ITEM_NM, GRP_NM, INPUT_GB, UNIT_NM, USE_YN) VALUES
 ('COM001','*',1,'품목'   ,NULL,'TEXT' ,NULL,'Y'),
 ('COM001','*',2,'확인(O)',NULL,'CHECK',NULL,'Y'),
 ('COM001','*',3,'재고'   ,NULL,'TEXT' ,NULL,'Y'),
 ('COM001','*',4,'비고'   ,NULL,'TEXT' ,NULL,'Y');

-- ═══════════════════════════════════════════════════════════════════════════
-- NUT012 · 감량의무 사업장 음식물 쓰레기 관리대장   [DAY_ITEM · 월 · 열 묶음 2]
-- ═══════════════════════════════════════════════════════════════════════════
--   ★NUT010(음식물 쓰레기 관리대장)의 **확장판**이다. ***둘 다 실물이 있으니 둘 다 만든다*** —
--     이름이 닮았다고 합치지 않는다(밀라운딩에서 겪은 것과 같다).
--   ★열 묶음 = 자가감량(감량법·처리량·처리량 누계) / 재활용(재활용량·방법·처리업체).
--   ★「누계」는 **자동 계산이 아니다** — 작성요령에 「합산하여 누계를 작성하고」라고 적혀 있다.
--     ***사람이 적는다.*** ⇒ 「계산이 있다 → 직접 제작」 신호에 해당하지 않는다.

DELETE FROM TBL_QPS_CHK_ITEM WHERE FORM_ID='NUT012' AND HOSP_CD='*';
DELETE FROM TBL_QPS_CHK_FORM WHERE FORM_ID='NUT012' AND HOSP_CD='*';

INSERT INTO TBL_QPS_CHK_FORM
 (FORM_ID, HOSP_CD, FORM_NM, CATE_CD, DEPT_CD, AXIS_GB, PRD_GB, PRD_KIND, EQUIP_CNT,
  GUIDE_TXT, HEAD_NMS, SIGNER_YN, NOTE_YN, FIX_YN, SIGN_LINE, FOOT_TXT, SORT_NO, USE_YN, REG_USER)
VALUES
 ('NUT012','*','감량의무 사업장 음식물 쓰레기 관리대장','ENV','NUTRI','DAY_ITEM','M','D',10,
  '(단위 : Kg)',NULL,'N','N','N',NULL,
  '<작성요령>
1. 폐기물의 발생 및 처리 시마다 일자별로 작성하되 처리량 누계는 매월 말일 기준으로 합산하여 누계를 작성하고 연말에 최종 누계를 작성하야 합니다.
2. 자가감량내역은 폐기물처리시설을 설치하여 스스로 처리하는 자가 기재하며, 감량방법은 건조/발효/발효 건조 소멸화 등으로 기재하여야 합니다.
3. 재활용 내역은 스스로 재활용하거나 위탁 재활용한 경우 기재하며, 재활용 방법은 퇴비, 사료등 으로 기재하고, 스스로 재활용하는 경우에는 "자가"로 기재하며, 위탁 재활용하는 경우 위탁업소명을 기재하여야 한다.',
  120,'Y','system');

INSERT INTO TBL_QPS_CHK_ITEM (FORM_ID, HOSP_CD, SORT, ITEM_NM, GRP_NM, INPUT_GB, UNIT_NM, USE_YN) VALUES
 ('NUT012','*',1,'발생량'     ,NULL    ,'NUM' ,'Kg','Y'),
 ('NUT012','*',2,'자가 감량법' ,'자가감량','TEXT',NULL,'Y'),
 ('NUT012','*',3,'자가 처리량' ,'자가감량','NUM' ,'Kg','Y'),
 ('NUT012','*',4,'처리량 누계' ,'자가감량','NUM' ,'Kg','Y'),
 ('NUT012','*',5,'재활용량'   ,'재활용' ,'NUM' ,'Kg','Y'),
 ('NUT012','*',6,'재활용방법' ,'재활용' ,'TEXT',NULL,'Y'),
 ('NUT012','*',7,'처리업체'   ,'재활용' ,'TEXT',NULL,'Y'),
 ('NUT012','*',8,'누계'       ,NULL    ,'NUM' ,'Kg','Y');

-- ═══════════════════════════════════════════════════════════════════════════
-- NUT013 · 방 역 일 지                              [LIST · 연 · 열 묶음]
-- ═══════════════════════════════════════════════════════════════════════════
--   ★열 묶음 「방역실시시간」 = 시작 · 종료.
--   ⚠**글자가 작아 확대해서 읽었다** — 「방역전 **식개덮개**」다(그냥 보면 「식개멸개」로 보인다).
--     `식개` 는 `식기` 의 오타로 보이지만 ***원본 그대로 옮긴다.***

DELETE FROM TBL_QPS_CHK_ITEM WHERE FORM_ID='NUT013' AND HOSP_CD='*';
DELETE FROM TBL_QPS_CHK_FORM WHERE FORM_ID='NUT013' AND HOSP_CD='*';

INSERT INTO TBL_QPS_CHK_FORM
 (FORM_ID, HOSP_CD, FORM_NM, CATE_CD, DEPT_CD, AXIS_GB, PRD_GB, EQUIP_CNT,
  GUIDE_TXT, HEAD_NMS, SIGNER_YN, NOTE_YN, FIX_YN, SIGN_LINE, FOOT_TXT, SORT_NO, USE_YN, REG_USER)
VALUES
 ('NUT013','*','방역 일지','ENV','NUTRI','LIST','Y',25,
  NULL,NULL,'N','N','N',NULL,
  '*참고사항: 방역실시 후 소독필증은 반드시 비치하여야 함.',
  130,'Y','system');

INSERT INTO TBL_QPS_CHK_ITEM (FORM_ID, HOSP_CD, SORT, ITEM_NM, GRP_NM, INPUT_GB, UNIT_NM, USE_YN) VALUES
 ('NUT013','*',1,'일자'                   ,NULL         ,'TEXT' ,NULL,'Y'),
 ('NUT013','*',2,'시작'                   ,'방역실시시간','TEXT' ,NULL,'Y'),
 ('NUT013','*',3,'종료'                   ,'방역실시시간','TEXT' ,NULL,'Y'),
 ('NUT013','*',4,'방역업체'                ,NULL         ,'TEXT' ,NULL,'Y'),
 ('NUT013','*',5,'방역약품 및 기구'         ,NULL         ,'TEXT' ,NULL,'Y'),
 ('NUT013','*',6,'방역전 식개덮개 (O,X)'    ,NULL         ,'CHECK',NULL,'Y'),
 ('NUT013','*',7,'방역 후 용기 재세척 여부 (O,X)',NULL     ,'CHECK',NULL,'Y'),
 ('NUT013','*',8,'방역시 참관자'            ,NULL         ,'TEXT' ,NULL,'Y'),
 ('NUT013','*',9,'시정조치'                ,NULL         ,'TEXT' ,NULL,'Y'),
 ('NUT013','*',10,'점검자'                 ,NULL         ,'TEXT' ,NULL,'Y');

-- ═══════════════════════════════════════════════════════════════════════════
-- NUT008 · 개인위생 점검일지                          [LIST · 월 · 열 묶음 2]
-- ═══════════════════════════════════════════════════════════════════════════
--   ⚠**NUT006(개인위생 확인 기록지)과 하는 일이 같아 보인다** — 판정 문서의 「확인 필요 ⑤」다.
--     ***그러나 합치지 않았다.*** 열이 다르다 :
--       NUT006 : 일·이름 / 감염성질병유무 / 위생복·위생모·위생화 / 손상처·손톱상태·장신구착용
--       NUT008 : 일자(요일)·조리원 성명 / **체온(℃)**·감염성 여부 / 위생복~손톱상태 / 개선 조치·확인란
--     ***NUT008 에만 체온 칸이 있다.***
--   ★★그리고 ***관리기준의 글자가 다르다*** — NUT006 은 「고열」, NUT008 은 **「구열」**.
--     오타로 보이지만 ***이것이 두 서식이 다른 문서라는 증거이기도 하다.*** 그대로 옮긴다.
--   ★글자가 작아 **4배로 늘려 읽었다** — 「장신구 **착용**」(작용 아님), 「**구열**」(고열 아님).

DELETE FROM TBL_QPS_CHK_ITEM WHERE FORM_ID='NUT008' AND HOSP_CD='*';
DELETE FROM TBL_QPS_CHK_FORM WHERE FORM_ID='NUT008' AND HOSP_CD='*';

INSERT INTO TBL_QPS_CHK_FORM
 (FORM_ID, HOSP_CD, FORM_NM, CATE_CD, DEPT_CD, AXIS_GB, PRD_GB, EQUIP_CNT,
  GUIDE_TXT, HEAD_NMS, SIGNER_YN, NOTE_YN, FIX_YN, SIGN_LINE, FOOT_TXT, SORT_NO, USE_YN, REG_USER)
VALUES
 ('NUT008','*','개인위생 점검일지','ENV','NUTRI','LIST','M',30,
  NULL,'확인 담당자','N','Y','N',NULL,
  '- 감염성 질환 : 설사, 구열, 구토, 피부발진/습진, 인후염, 결핵, 눈·귀·코에 진물,
  알레르기 질환, 피부감염자(화상, 화농성 질환 또는 상처)
*작성 요령*
- 이상이 없거나 양호한 경우 "O"로 표시하고 이상이 있는 경우 그 사항을 기재
- 휴무일 조리원은 ''휴무''라고 기록한다.',
  80,'Y','system');

INSERT INTO TBL_QPS_CHK_ITEM (FORM_ID, HOSP_CD, SORT, ITEM_NM, GRP_NM, INPUT_GB, UNIT_NM, USE_YN) VALUES
 ('NUT008','*', 1,'일자(요일)'  ,NULL         ,'TEXT' ,NULL,'Y'),
 ('NUT008','*', 2,'조리원 성명'  ,NULL         ,'TEXT' ,NULL,'Y'),
 ('NUT008','*', 3,'체온'        ,'건강 상태'   ,'NUM'  ,'℃','Y'),
 ('NUT008','*', 4,'감염성 여부'  ,'건강 상태'   ,'CHECK',NULL,'Y'),
 ('NUT008','*', 5,'위생복'      ,'복장 위생상태','CHECK',NULL,'Y'),
 ('NUT008','*', 6,'위생모'      ,'복장 위생상태','CHECK',NULL,'Y'),
 ('NUT008','*', 7,'위생화'      ,'복장 위생상태','CHECK',NULL,'Y'),
 ('NUT008','*', 8,'장신구 착용'  ,'복장 위생상태','CHECK',NULL,'Y'),
 ('NUT008','*', 9,'손상처'      ,'복장 위생상태','CHECK',NULL,'Y'),
 ('NUT008','*',10,'손톱상태'    ,'복장 위생상태','CHECK',NULL,'Y'),
 ('NUT008','*',11,'개선 조치'    ,NULL         ,'TEXT' ,NULL,'Y'),
 ('NUT008','*',12,'확인란'      ,NULL         ,'TEXT' ,NULL,'Y');

-- ═══════════════════════════════════════════════════════════════════════════
-- NUT002 · 밀라운딩일지                                      [LIST · 연단위]
-- NUT009 · 밀라운딩 일지                                      [LIST · 일단위]
-- ═══════════════════════════════════════════════════════════════════════════
--   ★★***이름이 띄어쓰기 하나 차이인데 다른 서식이다.*** (2026-08-12 판정에서 정정한 그것)
--     | | NUT002 「밀라운딩일지」 | NUT009 「밀라운딩 일지」 |
--     |---|---|---|
--     | 문서 단위 | **연** (상단 「2026 년」) | **일** (상단 2026-08-12) |
--     | 열 | 상담일자·이름·식이·내용·조치사항 | 호실·이름·내용·조치사항 |
--     | 상단 | 담당자 | **점검 사항 3개**(양호/보통/나쁨) |
--     ***이름만 보고 합쳤다면 두 서식의 기록이 한 곳에 섞였을 것이다.***
--   ★NUT009 는 원본이 **머리글을 여섯 번 되풀이**한다(호실·이름·내용·조치사항 블록 6개).
--     ***자료로는 한 표에 6행이다*** — 되풀이는 종이에서 칸을 크게 쓰려는 인쇄 편의일 뿐이다.
--   ⚠NUT009 의 점검 사항은 원본이 **양호/보통/나쁨 라디오**인데 우리 상단 칸은 **글자 칸**이다.
--     담기는 뜻은 같지만 고르는 맛이 다르다. 골라 넣게 해 달라는 말이 나오면 그때 손본다.
--   ⚠원본 오타로 보이는 `식기 **위상** 상태`(위생?)도 그대로 옮겼다 — 확대해서 확인한 글자다.

DELETE FROM TBL_QPS_CHK_ITEM WHERE FORM_ID IN ('NUT002','NUT009') AND HOSP_CD='*';
DELETE FROM TBL_QPS_CHK_FORM WHERE FORM_ID IN ('NUT002','NUT009') AND HOSP_CD='*';

INSERT INTO TBL_QPS_CHK_FORM
 (FORM_ID, HOSP_CD, FORM_NM, CATE_CD, DEPT_CD, AXIS_GB, PRD_GB, EQUIP_CNT,
  GUIDE_TXT, HEAD_NMS, SIGNER_YN, NOTE_YN, FIX_YN, SIGN_LINE, FOOT_TXT, SORT_NO, USE_YN, REG_USER)
VALUES
 ('NUT002','*','밀라운딩일지','ENV','NUTRI','LIST','Y',15,
  NULL,'담당자','N','N','N',NULL,
  '※ 참조 사항
 (1) 식이 처방에 관련된 사항 (오류 및 수정)
 (2) 조리 및 배식 업무에 관련된 사항
 (3) 영양 상담 및 교육이 필요한 사항
 (4) 식기 및 위생 관련 사항',
  20,'Y','system'),
 ('NUT009','*','밀라운딩 일지 (일단위)','ENV','NUTRI','LIST','D',6,
  NULL,
  '1. 급식 서비스 상태는 양호한가?,2. 음식 및 식기 위상 상태는 양호한가?,3. 식사의 질에 대한 평가',
  'N','N','N',NULL,NULL,90,'Y','system');

INSERT INTO TBL_QPS_CHK_ITEM (FORM_ID, HOSP_CD, SORT, ITEM_NM, GRP_NM, INPUT_GB, UNIT_NM, USE_YN) VALUES
 ('NUT002','*',1,'상담일자',NULL,'TEXT',NULL,'Y'),
 ('NUT002','*',2,'이름'    ,NULL,'TEXT',NULL,'Y'),
 ('NUT002','*',3,'식이'    ,NULL,'TEXT',NULL,'Y'),
 ('NUT002','*',4,'내용'    ,NULL,'TEXT',NULL,'Y'),
 ('NUT002','*',5,'조치사항',NULL,'TEXT',NULL,'Y'),
 ('NUT009','*',1,'호실'    ,NULL,'TEXT',NULL,'Y'),
 ('NUT009','*',2,'이름'    ,NULL,'TEXT',NULL,'Y'),
 ('NUT009','*',3,'내용'    ,NULL,'TEXT',NULL,'Y'),
 ('NUT009','*',4,'조치사항',NULL,'TEXT',NULL,'Y');

-- ── 확인 ────────────────────────────────────────────────────────────────────
SELECT f.FORM_ID, f.FORM_NM, f.AXIS_GB, f.PRD_GB, f.DESC_NM, COUNT(i.SORT) AS 항목수,
       COUNT(DISTINCT i.GRP_NM) AS 묶음수
  FROM TBL_QPS_CHK_FORM f
  LEFT JOIN TBL_QPS_CHK_ITEM i ON i.FORM_ID=f.FORM_ID AND i.HOSP_CD=f.HOSP_CD
 WHERE f.FORM_ID LIKE 'NUT%' AND f.HOSP_CD='*'
 GROUP BY f.FORM_ID, f.FORM_NM, f.AXIS_GB, f.PRD_GB, f.DESC_NM ORDER BY f.FORM_ID;
