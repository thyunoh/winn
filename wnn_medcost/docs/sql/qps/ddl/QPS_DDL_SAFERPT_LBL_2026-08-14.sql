-- =====================================================================
-- safeRpt 본문 칸 라벨 오버라이드 — DDL (2026-08-14)
--   왜 : safeRpt 본문 26칸의 라벨이 사고 서식(발생일·사건경위…)으로 고정이라
--        교육 보고서(EDURPT)·상담일지 계열은 칸은 맞는데 <이름>이 안 맞는다.
--        서식은 코드가 아니라 데이터다(엔진 원칙) — 라벨도 유형 설정(FORM) 한 칸으로 준다.
--   값 : JSON 한 덩이. 키 = 화면 data-lbl (occurDt·occurTm·rptDt·place·targetNm·targetNo·
--        deptNm·positionNm·admitDt·diagNm·wWhen~wWhy·summary·vitalTxt·injuryTxt·
--        treatTxt·causeTxt·planTxt·note). 값 '-' = 그 칸을 화면·인쇄에서 숨긴다.
--   비면(NULL) 지금과 동일 — 기존 유형 무영향. 더하기만 하는 DDL ⇒ 운영 선적용 안전.
-- =====================================================================

ALTER TABLE TBL_QPS_SAFERPT_FORM
  ADD COLUMN LBL_JSON TEXT NULL DEFAULT NULL
      COMMENT '본문 칸 라벨 오버라이드(JSON, 값 -=숨김) — 교육·상담 계열용' AFTER PHOTO_YN;
