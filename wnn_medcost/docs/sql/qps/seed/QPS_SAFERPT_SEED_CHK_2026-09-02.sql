-- ═══════════════════════════════════════════════════════════════════════════
-- safeRpt 체크 묶음 보강 — 델파이 원본 대조로 찾은 9유형 (2026-09-02)
--   왜 : 08-18 시드 메모 「체크 선택지는 LBL_JSON 으로 못 넣는다 — 글자 칸으로 흡수」는 틀렸다.
--        TBL_QPS_SAFERPT_DEF/USE(유형별 체크 묶음 · 라디오/체크 · 기타 글자칸)가 이미 20여 유형에 쓰인다.
--        원본 dfm 1,367개의 TcxCheckBox 를 전수 대조해 「원본엔 체크가 있는데 우리 DEF 가 없는」 유형을 골랐다
--        (docs/tools/dfm대조 · 사진 위젯 체크·오매칭 잡음 제외 = 9유형).
--   근거 : 각 유형의 원본 .pas 가 전부 「같은 Hint 묶음에서 하나만」(cxCheckBox Click 배타) ⇒ **전부 MULTI_YN='N'(라디오)**.
--          「기타」에 글자칸이 붙은 것은 ETC_YN='Y'. 항목 글자는 원본 캡션 그대로.
--   코드 변경 없음 — 작성 화면 「구분」 카드가 항목표를 읽어 그린다. 재실행 안전(ON DUPLICATE KEY UPDATE).
--   ⚠이미 글자 칸(LBL_JSON 라벨)에 적어 둔 작성분은 그대로 남는다 — 새 문서부터 체크로 고른다.
--   ★[09-02 밤 정정] ② 는 STAFFVIO 가 아니라 **HARASS** — 같은 서식이 이미 HARASS(SORT 9)로 있었다(08-18 신규분이 못 보고 또 만듦 ·
--      PSY 시드는 운영에 아직 안 돌았고 HARASS 작성분 0). 1차 실행 때 STAFFVIO 로 들어간 묶음은 아래 DELETE 가 지운다. **다시 돌려 주세요.**
-- ═══════════════════════════════════════════════════════════════════════════

DELETE FROM TBL_QPS_SAFERPT_USE WHERE RPT_GB='STAFFVIO';
DELETE FROM TBL_QPS_SAFERPT_DEF WHERE RPT_GB='STAFFVIO';

INSERT INTO TBL_QPS_SAFERPT_DEF (RPT_GB,GRP_CD,GRP_NM,ITEM_NM,MULTI_YN,ETC_YN,SORT,USE_YN) VALUES
 -- ① PSYVISIT 방문객 안전사고보고서 (RPT_Insane_014) — 방문사유 · 사고종류(+성폭력 종류) · 사고결과
 ('PSYVISIT','VISITRSN','방문사유','보호자','N','N',1,'Y'),('PSYVISIT','VISITRSN','방문사유','실습생','N','N',2,'Y'),
 ('PSYVISIT','VISITRSN','방문사유','기타','N','Y',99,'Y'),
 ('PSYVISIT','ACCTYPE','사고종류','시설 및 환경안전사고','N','N',1,'Y'),('PSYVISIT','ACCTYPE','사고종류','폭언','N','N',2,'Y'),
 ('PSYVISIT','ACCTYPE','사고종류','폭행','N','N',3,'Y'),('PSYVISIT','ACCTYPE','사고종류','성폭력','N','N',4,'Y'),
 ('PSYVISIT','ACCTYPE','사고종류','기타','N','Y',99,'Y'),
 ('PSYVISIT','SEXVIOL','성폭력 종류','성희롱','N','N',1,'Y'),('PSYVISIT','SEXVIOL','성폭력 종류','성추행','N','N',2,'Y'),
 ('PSYVISIT','SEXVIOL','성폭력 종류','성폭행','N','N',3,'Y'),
 ('PSYVISIT','ACCRESULT','사고결과','지속적인 치료가 필요','N','N',1,'Y'),('PSYVISIT','ACCRESULT','사고결과','치료 후 후유증 없이 치료됨','N','N',2,'Y'),
 ('PSYVISIT','ACCRESULT','사고결과','특별한 이상 없음','N','N',3,'Y'),('PSYVISIT','ACCRESULT','사고결과','추후 관찰 필요','N','N',4,'Y'),
 ('PSYVISIT','ACCRESULT','사고결과','기타','N','Y',99,'Y'),
 -- ② HARASS 직원간 폭행/성희롱 사건 보고서 (RPT_Chart_047) — 피해자 요구사항 (기존 「사건유형」 HRTYPE 은 우리가 더한 묶음 — 그대로 둠)
 ('HARASS','DEMAND','피해자 요구사항','공개사과','N','N',1,'Y'),('HARASS','DEMAND','피해자 요구사항','징계조치','N','N',2,'Y'),
 ('HARASS','DEMAND','피해자 요구사항','법적조치','N','N',3,'Y'),('HARASS','DEMAND','피해자 요구사항','해고','N','N',4,'Y'),
 ('HARASS','DEMAND','피해자 요구사항','기타요구','N','Y',99,'Y'),
 -- ③ INFDIS 감염성 질환 발생 보고서 (RPT_Chart_005_A) — 구분
 ('INFDIS','INFKIND','구분','폐렴','N','N',1,'Y'),('INFDIS','INFKIND','구분','결핵','N','N',2,'Y'),
 ('INFDIS','INFKIND','구분','접촉성 피부질환','N','N',3,'Y'),('INFDIS','INFKIND','구분','기타 감염병 질환','N','Y',99,'Y'),
 -- ④ MRLOST 의무기록 분실보고서 (HEALTH_Chart_017) — 결과
 ('MRLOST','RESULT','결과','종결','N','N',1,'Y'),('MRLOST','RESULT','결과','미결','N','N',2,'Y'),
 -- ⑤ SWDIARY 프로그램 일지 (WEL_Chart_005) — 시간
 ('SWDIARY','AMPM','시간','오전','N','N',1,'Y'),('SWDIARY','AMPM','시간','오후','N','N',2,'Y'),
 -- ⑥ SWINTAKE 사회사업 초기면접기록지 (WEL_Chart_007_A) — 경제상태 · 의료보장
 ('SWINTAKE','ECON','경제상태','상','N','N',1,'Y'),('SWINTAKE','ECON','경제상태','중','N','N',2,'Y'),('SWINTAKE','ECON','경제상태','하','N','N',3,'Y'),
 ('SWINTAKE','INSUR','의료보장','건강보험','N','N',1,'Y'),('SWINTAKE','INSUR','의료보장','의료급여 1종','N','N',2,'Y'),
 ('SWINTAKE','INSUR','의료보장','의료급여 2종','N','N',3,'Y'),('SWINTAKE','INSUR','의료보장','기타','N','Y',99,'Y'),
 -- ⑦ SWCLOSE 사회사업 종결기록지 (WEL_Chart_009) — 종결사유
 ('SWCLOSE','CLOSERSN','종결사유','퇴원','N','N',1,'Y'),('SWCLOSE','CLOSERSN','종결사유','자의퇴원','N','N',2,'Y'),
 ('SWCLOSE','CLOSERSN','종결사유','사망','N','N',3,'Y'),('SWCLOSE','CLOSERSN','종결사유','문제 해결','N','N',4,'Y'),
 ('SWCLOSE','CLOSERSN','종결사유','타 기관의뢰','N','N',5,'Y'),('SWCLOSE','CLOSERSN','종결사유','기타','N','Y',99,'Y'),
 -- ⑧ SWSPONS 사회복지 후원 신청서 (WEL_Chart_012) — 성별 · 의료보장유형
 ('SWSPONS','SEX','성별','남','N','N',1,'Y'),('SWSPONS','SEX','성별','여','N','N',2,'Y'),
 ('SWSPONS','INSUR','의료보장유형','건강보험','N','N',1,'Y'),('SWSPONS','INSUR','의료보장유형','의료급여 1종','N','N',2,'Y'),
 ('SWSPONS','INSUR','의료보장유형','의료급여 2종','N','N',3,'Y'),('SWSPONS','INSUR','의료보장유형','기타','N','Y',99,'Y'),
 -- ⑨ CONSENT 개인정보 수집 및 이용 동의서 (Employee_Chart_044) — 항목별 동의함/동의하지 않음
 ('CONSENT','AGREE1','필수정보','동의함','N','N',1,'Y'),('CONSENT','AGREE1','필수정보','동의하지 않음','N','N',2,'Y'),
 ('CONSENT','AGREE2','선택적 정보','동의함','N','N',1,'Y'),('CONSENT','AGREE2','선택적 정보','동의하지 않음','N','N',2,'Y'),
 ('CONSENT','AGREE3','고유식별정보','동의함','N','N',1,'Y'),('CONSENT','AGREE3','고유식별정보','동의하지 않음','N','N',2,'Y'),
 ('CONSENT','AGREE4','민감정보','동의함','N','N',1,'Y'),('CONSENT','AGREE4','민감정보','동의하지 않음','N','N',2,'Y'),
 ('CONSENT','AGREE5','제3자 제공','동의함','N','N',1,'Y'),('CONSENT','AGREE5','제3자 제공','동의하지 않음','N','N',2,'Y')
ON DUPLICATE KEY UPDATE GRP_NM=VALUES(GRP_NM), MULTI_YN=VALUES(MULTI_YN), ETC_YN=VALUES(ETC_YN), SORT=VALUES(SORT), USE_YN='Y';

INSERT INTO TBL_QPS_SAFERPT_USE (RPT_GB,GRP_CD,SORT,USE_YN) VALUES
 ('PSYVISIT','VISITRSN',1,'Y'),('PSYVISIT','ACCTYPE',2,'Y'),('PSYVISIT','SEXVIOL',3,'Y'),('PSYVISIT','ACCRESULT',4,'Y'),
 ('HARASS','DEMAND',1,'Y'),
 ('INFDIS','INFKIND',1,'Y'),
 ('MRLOST','RESULT',1,'Y'),
 ('SWDIARY','AMPM',1,'Y'),
 ('SWINTAKE','ECON',1,'Y'),('SWINTAKE','INSUR',2,'Y'),
 ('SWCLOSE','CLOSERSN',1,'Y'),
 ('SWSPONS','SEX',1,'Y'),('SWSPONS','INSUR',2,'Y'),
 ('CONSENT','AGREE1',1,'Y'),('CONSENT','AGREE2',2,'Y'),('CONSENT','AGREE3',3,'Y'),('CONSENT','AGREE4',4,'Y'),('CONSENT','AGREE5',5,'Y')
ON DUPLICATE KEY UPDATE SORT=VALUES(SORT), USE_YN='Y';

-- 확인 : 유형별 묶음 수 (PSYVISIT 4 · SWINTAKE 2 · SWSPONS 2 · CONSENT 5 · HARASS 2(기존 HRTYPE + DEMAND) · 나머지 1) — STAFFVIO 는 안 나와야 한다
SELECT u.RPT_GB, COUNT(DISTINCT u.GRP_CD) AS 묶음, COUNT(d.ITEM_NM) AS 항목
  FROM TBL_QPS_SAFERPT_USE u JOIN TBL_QPS_SAFERPT_DEF d ON d.RPT_GB=u.RPT_GB AND d.GRP_CD=u.GRP_CD
 WHERE u.RPT_GB IN ('PSYVISIT','HARASS','STAFFVIO','INFDIS','MRLOST','SWDIARY','SWINTAKE','SWCLOSE','SWSPONS','CONSENT')
 GROUP BY u.RPT_GB ORDER BY u.RPT_GB;
