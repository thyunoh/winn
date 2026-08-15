-- ═══════════════════════════════════════════════════════════════════════════
-- 의약품 계열 safeRpt 4종 + 「의약품 · 혈액」 SORT 대역 신설 (2026-08-15)
--   근거 : 약국 모듈 실물 캡처 D:\위너넷\caps\PH_2026-08-15\ (집 PC SUNWOO, 창 제목으로 진위 확인)
--          + RN28.png(인공신장 캡처) 재판독. 판정 = QPS_서식판독_약국보충_2026-08-15.md
--
--   ★SORT 대역 10~19 = 「의약품 · 혈액」 계열 신설(qpsSafeRpt.jsp BANDS 에 같이 추가) :
--     11 BLOODRTN(26→11 이동) · 12 DRUGRTN(간호판, 별도 시드) · 13 DRUGRTNP · 14 DRUGBRK ·
--     15 DRUGADR · 16 DRUGADRE · 17 DRUGREQ(간호 [274], 간호 모듈 n274 캡처 — 확인#2 해소)
--
--   대조 판정(항목 문자열 기준) :
--   · DRUGRTNP = 약국 「병동의약품 반납신청서」(p01) — 간호판 DRUGRTN 과 **다른 판**(단건+사유 6택+
--     마약류/고가 조건부+약제과 처리 블록). 확인 #1 해소.
--   · DRUGBRK = 「의약품 불량 및 파손보고서」(p04) — **약국판 = 인공신장 RN29 와 같은 판**
--     (파손일자~약사 서명까지 글자 일치). 부서 공유 한 벌(RN38 전례). RN29 보류 해소.
--   · DRUGADR = 「의약품 부작용 보고서」(RN28) — 원내 보고판. 약국 평가서와 **별건**(결재란·4행 의약품표·
--     진행결과 상세는 보고서에만, 최종평가·인과성은 평가서에만). RN28 보류 해소.
--   · DRUGADRE = 약국 「의약품 부작용 보고 평가서」(p03) — 평가판.
--     ✅인과성 7항목 등 작은 문구는 **SUNWOO [폰트 확대] 후 재캡처**(p03_평가서_폰트확대.png)로
--     전부 확정 — 실물 대조 불필요. ★작은 글씨 재판독은 크롭 확대보다 이 방법이 정확하다(사용자 제보).
--   · 약국 「의약품부작용보고서(원외)」(p02, 총 4쪽) = **법정 별지 제77호의2 서식** — 4쪽 대형이라 보류.
--     캡처는 p02_*.png 4장으로 확보해 둠. ezdrug.mfds.go.kr 전자신청 가능 안내가 원본에 있음.
--   · RN25 병동비치약품점검표 ↔ PHA020 = **다른 판**(PHA020 은 확인일자+확인자서명 4그룹) — 대조만 해소,
--     RN25 는 「LIST+ITEM_DAY 복합」 조각 사안으로 계속 보류.
-- 재실행 안전(DELETE 후 INSERT · ON DUPLICATE KEY).
-- ═══════════════════════════════════════════════════════════════════════════

-- ── 0. BLOODRTN 을 새 대역으로(26→11) ───────────────────────────────────────
UPDATE TBL_CODE_DTL SET SORT=11
 WHERE CODE_GB='Q' AND CODE_CD='QPS_SAFERPT_GB' AND SUB_CODE='BLOODRTN';

-- ── 1. 유형 4종 ─────────────────────────────────────────────────────────────
INSERT INTO TBL_CODE_DTL
 (CODE_GB, CODE_CD, SUB_CODE, JOB_SEQ, SUB_CODE_NM, START_DT, END_DT, USE_YN, SORT, ACTION_YN, REG_USER) VALUES
 ('Q','QPS_SAFERPT_GB','DRUGRTNP',1,'병동의약품 반납신청서(약국)','20000101','99991231','Y',13,'Y','system'),
 ('Q','QPS_SAFERPT_GB','DRUGBRK' ,1,'의약품 불량 및 파손보고서' ,'20000101','99991231','Y',14,'Y','system'),
 ('Q','QPS_SAFERPT_GB','DRUGADR' ,1,'의약품 부작용 보고서'      ,'20000101','99991231','Y',15,'Y','system'),
 ('Q','QPS_SAFERPT_GB','DRUGADRE',1,'의약품 부작용 보고 평가서' ,'20000101','99991231','Y',16,'Y','system')
ON DUPLICATE KEY UPDATE SUB_CODE_NM=VALUES(SUB_CODE_NM), SORT=VALUES(SORT), USE_YN='Y', ACTION_YN='Y';

-- ── 2. DRUGRTNP — 병동의약품 반납신청서(약국 접수판, p01) ───────────────────
--   단건(약품명·제조번호·수량) · 반납사유 6택 · 마약류/고가 파손 시에만 * 발생일자·발생사유 ·
--   하단 「위와 같이 의약품 반납을 신청합니다」+년월일+서명 · 약제과 기재 사항(처리내용·처리일자·약사)
INSERT INTO TBL_QPS_SAFERPT_FORM (RPT_GB, SUB_NM, SUB_COLS, SIGN_LINE, FOOT_TXT, LBL_JSON, USE_YN, REG_USER) VALUES
 ('DRUGRTNP', NULL, NULL, '서 명,약 사',
  '위와 같이 의약품 반납을 신청합니다.',
  '{"occurDt":"신청일자","occurTm":"-","rptDt":"* 발생일자","place":"-","targetNm":"약품명","targetNo":"제조번호","deptNm":"부서명","positionNm":"-","admitDt":"-","diagNm":"-","wWhen":"수 량","wWho":"-","wWhere":"-","wWhat":"기 타","wHow":"-","wWhy":"-","summary":"* 발생사유 (육하원칙에 따라 기록 — 반납 사유 중 마약류 파손/고가의약품 파손의 경우에만 * 항목 작성)","vitalTxt":"-","injuryTxt":"-","treatTxt":"-","causeTxt":"-","planTxt":"-","note":"약제과 처리 일자"}',
  'Y','system')
ON DUPLICATE KEY UPDATE SUB_NM=VALUES(SUB_NM), SUB_COLS=VALUES(SUB_COLS),
  SIGN_LINE=VALUES(SIGN_LINE), FOOT_TXT=VALUES(FOOT_TXT), LBL_JSON=VALUES(LBL_JSON), USE_YN='Y';

DELETE FROM TBL_QPS_SAFERPT_USE WHERE RPT_GB='DRUGRTNP';
DELETE FROM TBL_QPS_SAFERPT_DEF WHERE RPT_GB='DRUGRTNP';
INSERT INTO TBL_QPS_SAFERPT_DEF (RPT_GB,GRP_CD,GRP_NM,ITEM_NM,MULTI_YN,ETC_YN,SORT,USE_YN) VALUES
 ('DRUGRTNP','RTNRSN','반납사유','단순 파손','N','N',1,'Y'),
 ('DRUGRTNP','RTNRSN','반납사유','유효기간 임박','N','N',2,'Y'),
 ('DRUGRTNP','RTNRSN','반납사유','약품 불량','N','N',3,'Y'),
 ('DRUGRTNP','RTNRSN','반납사유','재고조정','N','N',4,'Y'),
 ('DRUGRTNP','RTNRSN','반납사유','마약류 파손','N','N',5,'Y'),
 ('DRUGRTNP','RTNRSN','반납사유','기 타 (고가의약품 파손 등)','N','Y',6,'Y'),
 ('DRUGRTNP','PHACT','* 약제과 기재 사항 — 처리내용','교 환','Y','N',1,'Y'),
 ('DRUGRTNP','PHACT','* 약제과 기재 사항 — 처리내용','폐 기','Y','N',2,'Y'),
 ('DRUGRTNP','PHACT','* 약제과 기재 사항 — 처리내용','약제과 재고 반영','Y','N',3,'Y'),
 ('DRUGRTNP','PHACT','* 약제과 기재 사항 — 처리내용','보건소 보고','Y','N',4,'Y');
INSERT INTO TBL_QPS_SAFERPT_USE (RPT_GB,GRP_CD,SORT,USE_YN) VALUES
 ('DRUGRTNP','RTNRSN',1,'Y'), ('DRUGRTNP','PHACT',2,'Y');

-- ── 3. DRUGBRK — 의약품 불량 및 파손보고서 (p04 = RN29, 약국·인공신장 공용) ─
INSERT INTO TBL_QPS_SAFERPT_FORM (RPT_GB, SUB_NM, SUB_COLS, SIGN_LINE, FOOT_TXT, LBL_JSON, USE_YN, REG_USER) VALUES
 ('DRUGBRK', NULL, NULL, '보고자,수간호사,약 사',
  '위와 같이 의약품 파손을 보고합니다.',
  '{"occurDt":"파손일자","occurTm":"파손시간","rptDt":"-","place":"파손장소","targetNm":"환자성명","targetNo":"-","deptNm":"-","positionNm":"-","admitDt":"-","diagNm":"-","wWhen":"-","wWho":"수량(용량)","wWhere":"-","wWhat":"약 품 명","wHow":"-","wWhy":"-","summary":"파손경위 (육하원칙에 따라 기록)","vitalTxt":"-","injuryTxt":"-","treatTxt":"-","causeTxt":"-","planTxt":"-","note":"-"}',
  'Y','system')
ON DUPLICATE KEY UPDATE SUB_NM=VALUES(SUB_NM), SUB_COLS=VALUES(SUB_COLS),
  SIGN_LINE=VALUES(SIGN_LINE), FOOT_TXT=VALUES(FOOT_TXT), LBL_JSON=VALUES(LBL_JSON), USE_YN='Y';
DELETE FROM TBL_QPS_SAFERPT_USE WHERE RPT_GB='DRUGBRK';
DELETE FROM TBL_QPS_SAFERPT_DEF WHERE RPT_GB='DRUGBRK';

-- ── 4. DRUGADR — 의약품 부작용 보고서 (RN28, 원내 보고판) ───────────────────
--   결재란(담당~이사장)+작성자 → SIGN_LINE. 투여 의약품 4행(의심1·2/병동1·2) → 반복행 표.
INSERT INTO TBL_QPS_SAFERPT_FORM (RPT_GB, SUB_NM, SUB_COLS, SIGN_LINE, FOOT_TXT, LBL_JSON, USE_YN, REG_USER) VALUES
 ('DRUGADR', NULL, NULL, '담당,팀장,부서장,이사장,작성자',
  NULL,
  '{"occurDt":"작성일시","occurTm":"-","rptDt":"발생인지일","place":"부진단명","targetNm":"이 름","targetNo":"등록번호","deptNm":"진료과","positionNm":"-","admitDt":"진료일","diagNm":"진단명","wWhen":"생년월일","wWho":"체중(Kg)","wWhere":"-","wWhat":"알러지/음주/흡연/임신 여부(각 Y/N)","wHow":"-","wWhy":"-","summary":"이상반응내용","vitalTxt":"증상발현일 (약물투여시작 즉시 / ( )분 / ( )시간 / ( )일 후에 발현 / 알수없음)","injuryTxt":"발현기간 (( )일 / ( )시간 / ( )분 / 현재진행중)","treatTxt":"투약변경 상세 (용량변경 / 용법·투여경로변경 / 약물변경 CODE)","causeTxt":"-","planTxt":"약제과 검토의견 (확정일시 포함)","note":"-"}',
  'Y','system')
ON DUPLICATE KEY UPDATE SUB_NM=VALUES(SUB_NM), SUB_COLS=VALUES(SUB_COLS),
  SIGN_LINE=VALUES(SIGN_LINE), FOOT_TXT=VALUES(FOOT_TXT), LBL_JSON=VALUES(LBL_JSON), USE_YN='Y';

DELETE FROM TBL_QPS_SAFERPT_SUB WHERE RPT_GB='DRUGADR';
INSERT INTO TBL_QPS_SAFERPT_SUB (RPT_GB, SUB_NO, SUB_NM, SUB_COLS, USE_YN, REG_USER) VALUES
 ('DRUGADR',1,'◆ 투여 의약품 정보 (의심의약품 1·2 / 병동의약품 1·2)',
  '구분,약품명,CODE,투여시작일,경로,1회용량,1일투여횟수,과거사용여부(Y/N)','Y','system');

DELETE FROM TBL_QPS_SAFERPT_USE WHERE RPT_GB='DRUGADR';
DELETE FROM TBL_QPS_SAFERPT_DEF WHERE RPT_GB='DRUGADR';
INSERT INTO TBL_QPS_SAFERPT_DEF (RPT_GB,GRP_CD,GRP_NM,ITEM_NM,MULTI_YN,ETC_YN,SORT,USE_YN) VALUES
 ('DRUGADR','ADRACT','약물이상반응에 대한 조치','없음(투약유지)','Y','N',1,'Y'),
 ('DRUGADR','ADRACT','약물이상반응에 대한 조치','투약중지','Y','N',2,'Y'),
 ('DRUGADR','ADRACT','약물이상반응에 대한 조치','투약변경: 용량변경','Y','N',3,'Y'),
 ('DRUGADR','ADRACT','약물이상반응에 대한 조치','투약변경: 용법/투여경로변경','Y','N',4,'Y'),
 ('DRUGADR','ADRACT','약물이상반응에 대한 조치','투약변경: 약물변경(CODE)','Y','Y',5,'Y'),
 ('DRUGADR','ADRRES','약물이상반응 진행결과','( )일 후 자연회복','N','N',1,'Y'),
 ('DRUGADR','ADRRES','약물이상반응 진행결과','처치후 회복','N','N',2,'Y'),
 ('DRUGADR','ADRRES','약물이상반응 진행결과','통원( )일','N','N',3,'Y'),
 ('DRUGADR','ADRRES','약물이상반응 진행결과','입원/입원연장( )일','N','N',4,'Y'),
 ('DRUGADR','ADRRES','약물이상반응 진행결과','회복되지 않음','N','N',5,'Y'),
 ('DRUGADR','ADRRES','약물이상반응 진행결과','중대한 불구나 기능저하','N','N',6,'Y'),
 ('DRUGADR','ADRRES','약물이상반응 진행결과','선천적 기형','N','N',7,'Y'),
 ('DRUGADR','ADRRES','약물이상반응 진행결과','위독상태지속','N','N',8,'Y'),
 ('DRUGADR','ADRRES','약물이상반응 진행결과','사망( )일','N','N',9,'Y'),
 ('DRUGADR','ADRRES','약물이상반응 진행결과','판정불가','N','N',10,'Y'),
 ('DRUGADR','ADRRES','약물이상반응 진행결과','기타','N','Y',11,'Y'),
 ('DRUGADR','ADRRE','재투여시 재발현 여부','재투여하지않음','N','N',1,'Y'),
 ('DRUGADR','ADRRE','재투여시 재발현 여부','재투여시 유사증상 재발현: 재투여( )일, 재투여( )회','N','N',2,'Y'),
 ('DRUGADR','ADRRE','재투여시 재발현 여부','재투여시 유사증상없음','N','N',3,'Y'),
 ('DRUGADR','ADRRE','재투여시 재발현 여부','정보없음','N','N',4,'Y'),
 ('DRUGADR','ADRHIS','과거약물부작용','없음','N','N',1,'Y'),
 ('DRUGADR','ADRHIS','과거약물부작용','있음','N','N',2,'Y');
INSERT INTO TBL_QPS_SAFERPT_USE (RPT_GB,GRP_CD,SORT,USE_YN) VALUES
 ('DRUGADR','ADRACT',1,'Y'), ('DRUGADR','ADRRES',2,'Y'),
 ('DRUGADR','ADRRE',3,'Y'), ('DRUGADR','ADRHIS',4,'Y');

-- ── 5. DRUGADRE — 의약품 부작용 보고 평가서 (약국, p03) ─────────────────────
--   문항 전부 폰트 확대 재캡처로 확정(머리말 참조)
INSERT INTO TBL_QPS_SAFERPT_FORM (RPT_GB, SUB_NM, SUB_COLS, SIGN_LINE, FOOT_TXT, LBL_JSON, USE_YN, REG_USER) VALUES
 ('DRUGADRE', NULL, NULL, '담당,팀장,부서장,이사장,1차 평가자(약사)',
  NULL,
  '{"occurDt":"보고 일자","occurTm":"-","rptDt":"증상 발현일","place":"-","targetNm":"환자명","targetNo":"등록번호","deptNm":"-","positionNm":"-","admitDt":"생년월일 (만 세)","diagNm":"-","wWhen":"성 별","wWho":"신장/체중 (cm/kg)","wWhere":"-","wWhat":"임신여부 (Y( 주)/N)","wHow":"-","wWhy":"-","summary":"발현 증상","vitalTxt":"증상 종료일 / 증상발현시기 (투여개시 후 발현 — 예: 30초, 5분, 2시간, 3일 등)","injuryTxt":"증상지속여부 (소실(발현 후 ( )시간) / 지속 / 회복됨 / 회복중 / 모름)","treatTxt":"치 료 (약물투여 — 약품명/성분명)","causeTxt":"임상증상 소견","planTxt":"약제과 검토 의견","note":"-"}',
  'Y','system')
ON DUPLICATE KEY UPDATE SUB_NM=VALUES(SUB_NM), SUB_COLS=VALUES(SUB_COLS),
  SIGN_LINE=VALUES(SIGN_LINE), FOOT_TXT=VALUES(FOOT_TXT), LBL_JSON=VALUES(LBL_JSON), USE_YN='Y';

DELETE FROM TBL_QPS_SAFERPT_SUB WHERE RPT_GB='DRUGADRE';
INSERT INTO TBL_QPS_SAFERPT_SUB (RPT_GB, SUB_NO, SUB_NM, SUB_COLS, USE_YN, REG_USER) VALUES
 ('DRUGADRE',1,'▶ 환자 병력 / 약물 사용력',
  '질환명 또는 제품명/발현증상,시작일,종료일,상세내용','Y','system'),
 ('DRUGADRE',2,'▶ 검사치 (약물이상반응/이상사례와 관련된 검사치가 있는 경우)',
  '검사일,검사항목,검사결과,상세내용','Y','system'),
 ('DRUGADRE',3,'▶ 의약품 정보 (의심/병용/상호작용)',
  '구분(의심/병용/상호작용),제품명(성분명),투여목적(적용증),1회투여량,투여간격(예:6시간·12시간·24시간),투여기간(총 일),제형/투여경로','Y','system');

DELETE FROM TBL_QPS_SAFERPT_USE WHERE RPT_GB='DRUGADRE';
DELETE FROM TBL_QPS_SAFERPT_DEF WHERE RPT_GB='DRUGADRE';
INSERT INTO TBL_QPS_SAFERPT_DEF (RPT_GB,GRP_CD,GRP_NM,ITEM_NM,MULTI_YN,ETC_YN,SORT,USE_YN) VALUES
 ('DRUGADRE','AESEV','증상발현정도','중증','N','N',1,'Y'),
 ('DRUGADRE','AESEV','증상발현정도','중등증','N','N',2,'Y'),
 ('DRUGADRE','AESEV','증상발현정도','경증','N','N',3,'Y'),
 ('DRUGADRE','AEACT','경과 및 조치 — 조치','투여량유지','Y','N',1,'Y'),
 ('DRUGADRE','AEACT','경과 및 조치 — 조치','투여량증가','Y','N',2,'Y'),
 ('DRUGADRE','AEACT','경과 및 조치 — 조치','투여량감소','Y','N',3,'Y'),
 ('DRUGADRE','AEACT','경과 및 조치 — 조치','투여중지','Y','N',4,'Y'),
 ('DRUGADRE','AEACT','경과 및 조치 — 조치','모름','Y','N',5,'Y'),
 ('DRUGADRE','AEACT','경과 및 조치 — 조치','해당없음','Y','N',6,'Y'),
 ('DRUGADRE','AERE','재투여시 재발현여부','발현','N','N',1,'Y'),
 ('DRUGADRE','AERE','재투여시 재발현여부','발현안됨','N','N',2,'Y'),
 ('DRUGADRE','AERE','재투여시 재발현여부','알수없음','N','N',3,'Y'),
 ('DRUGADRE','AERE','재투여시 재발현여부','재투여하지 않음','N','N',4,'Y'),
 ('DRUGADRE','EVSEV','최종평가 — 중증도 평가','중증','N','N',1,'Y'),
 ('DRUGADRE','EVSEV','최종평가 — 중증도 평가','중등증','N','N',2,'Y'),
 ('DRUGADRE','EVSEV','최종평가 — 중증도 평가','경증','N','N',3,'Y'),
 ('DRUGADRE','EVCAUS','최종평가 — 인과성 평가','확실함','N','N',1,'Y'),
 ('DRUGADRE','EVCAUS','최종평가 — 인과성 평가','상당히 확실함','N','N',2,'Y'),
 ('DRUGADRE','EVCAUS','최종평가 — 인과성 평가','가능함','N','N',3,'Y'),
 ('DRUGADRE','EVCAUS','최종평가 — 인과성 평가','가능성','N','N',4,'Y'),
 ('DRUGADRE','EVCAUS','최종평가 — 인과성 평가','가능성 적음','N','N',5,'Y'),
 ('DRUGADRE','EVCAUS','최종평가 — 인과성 평가','평가곤란','N','N',6,'Y'),
 ('DRUGADRE','EVCAUS','최종평가 — 인과성 평가','평가불가','N','N',7,'Y'),
 ('DRUGADRE','EVSER','최종평가 — 중대성 여부(해당시)','사망을초래','Y','N',1,'Y'),
 ('DRUGADRE','EVSER','최종평가 — 중대성 여부(해당시)','생명을위협','Y','N',2,'Y'),
 ('DRUGADRE','EVSER','최종평가 — 중대성 여부(해당시)','입원 또는 입원기간연장 필요','Y','N',3,'Y'),
 ('DRUGADRE','EVSER','최종평가 — 중대성 여부(해당시)','지속적/중대한 장애나 기능저하 초래','Y','N',4,'Y'),
 ('DRUGADRE','EVSER','최종평가 — 중대성 여부(해당시)','선천적기형/이상 초래','Y','N',5,'Y'),
 ('DRUGADRE','EVSER','최종평가 — 중대성 여부(해당시)','기타 의학적으로 중요한 상황 발생하여 치료 필요','Y','N',6,'Y'),
 ('DRUGADRE','EVACT','최종평가 — 원내조치 사항','종결','Y','N',1,'Y'),
 ('DRUGADRE','EVACT','최종평가 — 원내조치 사항','대체약을추천','Y','N',2,'Y'),
 ('DRUGADRE','EVACT','최종평가 — 원내조치 사항','처방중단 및 의약품 회수','Y','N',3,'Y'),
 ('DRUGADRE','EVACT','최종평가 — 원내조치 사항','처방프로세스점검','Y','N',4,'Y'),
 ('DRUGADRE','EVACT','최종평가 — 원내조치 사항','기타','Y','Y',5,'Y');
INSERT INTO TBL_QPS_SAFERPT_USE (RPT_GB,GRP_CD,SORT,USE_YN) VALUES
 ('DRUGADRE','AESEV',1,'Y'), ('DRUGADRE','AEACT',2,'Y'), ('DRUGADRE','AERE',3,'Y'),
 ('DRUGADRE','EVSEV',4,'Y'), ('DRUGADRE','EVCAUS',5,'Y'), ('DRUGADRE','EVSER',6,'Y'),
 ('DRUGADRE','EVACT',7,'Y');

-- ── 6. DRUGREQ — 병동의약품 신청서 (간호 [274], n274 캡처로 확인#2 해소) ─────
--   신청일자·병동 / 신청사유(비치의약품 보충·기타) / 표 No.·의약품명·수량·기타 / 약사 확인.
INSERT INTO TBL_CODE_DTL
 (CODE_GB, CODE_CD, SUB_CODE, JOB_SEQ, SUB_CODE_NM, START_DT, END_DT, USE_YN, SORT, ACTION_YN, REG_USER) VALUES
 ('Q','QPS_SAFERPT_GB','DRUGREQ',1,'병동의약품 신청서','20000101','99991231','Y',17,'Y','system')
ON DUPLICATE KEY UPDATE SUB_CODE_NM=VALUES(SUB_CODE_NM), SORT=VALUES(SORT), USE_YN='Y', ACTION_YN='Y';

INSERT INTO TBL_QPS_SAFERPT_FORM (RPT_GB, SUB_NM, SUB_COLS, SIGN_LINE, FOOT_TXT, LBL_JSON, USE_YN, REG_USER) VALUES
 ('DRUGREQ', NULL, '의약품명,수 량,기 타', '약사 확인', NULL,
  '{"occurDt":"신청 일자","occurTm":"-","rptDt":"-","place":"-","targetNm":"-","targetNo":"-","deptNm":"병 동","positionNm":"-","admitDt":"-","diagNm":"-","wWhen":"-","wWho":"-","wWhere":"-","wWhat":"-","wHow":"-","wWhy":"-","summary":"-","vitalTxt":"-","injuryTxt":"-","treatTxt":"-","causeTxt":"-","planTxt":"-","note":"-"}',
  'Y','system')
ON DUPLICATE KEY UPDATE SUB_NM=VALUES(SUB_NM), SUB_COLS=VALUES(SUB_COLS),
  SIGN_LINE=VALUES(SIGN_LINE), FOOT_TXT=VALUES(FOOT_TXT), LBL_JSON=VALUES(LBL_JSON), USE_YN='Y';

DELETE FROM TBL_QPS_SAFERPT_USE WHERE RPT_GB='DRUGREQ';
DELETE FROM TBL_QPS_SAFERPT_DEF WHERE RPT_GB='DRUGREQ';
INSERT INTO TBL_QPS_SAFERPT_DEF (RPT_GB,GRP_CD,GRP_NM,ITEM_NM,MULTI_YN,ETC_YN,SORT,USE_YN) VALUES
 ('DRUGREQ','REQRSN','신청 사유','비치의약품 보충','N','N',1,'Y'),
 ('DRUGREQ','REQRSN','신청 사유','기타','N','Y',2,'Y');
INSERT INTO TBL_QPS_SAFERPT_USE (RPT_GB,GRP_CD,SORT,USE_YN) VALUES
 ('DRUGREQ','REQRSN',1,'Y');

-- ── 확인 ────────────────────────────────────────────────────────────────────
SELECT SUB_CODE, SUB_CODE_NM, SORT FROM TBL_CODE_DTL
 WHERE CODE_CD='QPS_SAFERPT_GB' AND SORT BETWEEN 10 AND 19 ORDER BY SORT;
SELECT RPT_GB, JSON_VALID(LBL_JSON) ok FROM TBL_QPS_SAFERPT_FORM
 WHERE RPT_GB IN ('DRUGRTNP','DRUGBRK','DRUGADR','DRUGADRE');
SELECT RPT_GB, COUNT(*) grp FROM TBL_QPS_SAFERPT_USE
 WHERE RPT_GB IN ('DRUGRTNP','DRUGADR','DRUGADRE') GROUP BY RPT_GB;
SELECT RPT_GB, SUB_NO, SUB_NM FROM TBL_QPS_SAFERPT_SUB
 WHERE RPT_GB IN ('DRUGADR','DRUGADRE') ORDER BY RPT_GB, SUB_NO;
SELECT COUNT(*) AS saferpt_total FROM TBL_CODE_DTL WHERE CODE_CD='QPS_SAFERPT_GB' AND USE_YN='Y';
