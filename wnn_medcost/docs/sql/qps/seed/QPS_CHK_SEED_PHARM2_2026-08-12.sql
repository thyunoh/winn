-- ═══════════════════════════════════════════════════════════════════════════
-- 점검표 표준 서식 시드 — 약국 **2차** (2026-08-12)
--   원본 캡처 : SUNWOO HCMS ▸ 약국 ▸ 약국서식
--   1차(PHA001~003) : QPS_CHK_SEED_PHARM_2026-08-12.sql
--
-- ★캡처에 있는 것만 넣었다. **지어낸 항목은 하나도 없다** —
--   지어낸 항목은 병원이 진짜인 줄 안다.
--
-- ★1차에서 「막혀서 못 넣는다」고 적어 둔 것이 v3 로 풀렸다 :
--     · 의료용마약류 저장시설 점검부 → `GUIDE_TXT` 200→1000 (법정 유의사항 4줄이 들어간다)
--     · 자동/반자동 조제기 → 「반달 접기」가 `SPLIT_N=15 · SPLIT_DIR='C'` 로 일반화
--
-- ★입력종류(INPUT_GB)를 제대로 넣는 것이 중요하다.
--   숫자·글자 칸을 CHECK 로 두면 **서버 정규화가 한 글자를 O/X 로 바꾼다.**
--   온도 「1」이 「O」가 되고 이름 「V」가 「O」가 된다. NUM·TEXT 는 손대지 않는다.
--
-- 실행 : 두 번 돌려도 같은 결과(먼저 지우고 넣는다).
-- ═══════════════════════════════════════════════════════════════════════════

-- ═══════════════════════════════════════════════════════════════════════════
-- PHA005 · 잔여 마약류 폐기 대장                                        [LIST]
-- ═══════════════════════════════════════════════════════════════════════════
--   ★열 묶음 「확인」 = 약사 · 참관직원. 1차의 PHA003(반납 대장)과 같은 짜임이다.
--   ★날짜가 **열**이므로 문서는 월 단위다(원본 상단의 년/월/일은 작성일 표시).

DELETE FROM TBL_QPS_CHK_ITEM WHERE FORM_ID='PHA005' AND HOSP_CD='*';
DELETE FROM TBL_QPS_CHK_FORM WHERE FORM_ID='PHA005' AND HOSP_CD='*';

INSERT INTO TBL_QPS_CHK_FORM
 (FORM_ID, HOSP_CD, FORM_NM, CATE_CD, DEPT_CD, AXIS_GB, PRD_GB, EQUIP_CNT,
  GUIDE_TXT, HEAD_NMS, SIGNER_YN, NOTE_YN, FIX_YN, SIGN_LINE, FOOT_TXT, SORT_NO, USE_YN, REG_USER)
VALUES
 ('PHA005', '*', '잔여 마약류 폐기 대장', 'DRUG', 'PHARM',
  'LIST', 'M', 15, NULL, NULL, 'N', 'N', 'N', NULL, NULL, 50, 'Y', 'system');

INSERT INTO TBL_QPS_CHK_ITEM (FORM_ID, HOSP_CD, SORT, ITEM_NM, GRP_NM, INPUT_GB, UNIT_NM, USE_YN) VALUES
 ('PHA005','*', 1,'날짜'    ,NULL  ,'TEXT',NULL,'Y'),
 ('PHA005','*', 2,'약품명'  ,NULL  ,'TEXT',NULL,'Y'),
 ('PHA005','*', 3,'제조번호',NULL  ,'TEXT',NULL,'Y'),
 ('PHA005','*', 4,'용량'    ,NULL  ,'TEXT',NULL,'Y'),
 ('PHA005','*', 5,'폐기방법',NULL  ,'TEXT',NULL,'Y'),
 ('PHA005','*', 6,'약사'    ,'확인','TEXT',NULL,'Y'),
 ('PHA005','*', 7,'참관직원','확인','TEXT',NULL,'Y'),
 ('PHA005','*', 8,'비고'    ,NULL  ,'TEXT',NULL,'Y');

-- ═══════════════════════════════════════════════════════════════════════════
-- PHA006 · 조제 전 / 후 감사 대장                                [LIST · 연단위]
-- ═══════════════════════════════════════════════════════════════════════════
--   ★원본 상단이 **「2026 년」 하나뿐**이다 — 달을 안 고른다. ⇒ `PRD_GB='Y'`.
--     ***이것이 v2 에서 「LIST 가 월단위로 못 박혀 있다」는 구멍을 드러낸 서식이다.***
--   ★※문구는 처방 감사 항목 ①~⑦ — 법정에 준하는 기준이라 **한 글자도 줄이지 않는다.**

DELETE FROM TBL_QPS_CHK_ITEM WHERE FORM_ID='PHA006' AND HOSP_CD='*';
DELETE FROM TBL_QPS_CHK_FORM WHERE FORM_ID='PHA006' AND HOSP_CD='*';

INSERT INTO TBL_QPS_CHK_FORM
 (FORM_ID, HOSP_CD, FORM_NM, CATE_CD, DEPT_CD, AXIS_GB, PRD_GB, EQUIP_CNT,
  GUIDE_TXT, HEAD_NMS, SIGNER_YN, NOTE_YN, FIX_YN, SIGN_LINE, FOOT_TXT, SORT_NO, USE_YN, REG_USER)
VALUES
 ('PHA006', '*', '조제 전 / 후 감사 대장', 'DRUG', 'PHARM',
  'LIST', 'Y', 15, NULL, NULL, 'N', 'N', 'N', NULL,
  '※처방 감사 항목:
① 약물의 용량 ② 투여횟수 ③ 투여 경로 ④ 처방 일수의 적절성
⑤ 약물의 중복 처방 ⑥ 약물 상호작용 및 병용금기 ⑦ 원내 사용 중지된 약물 처방',
  60, 'Y', 'system');

INSERT INTO TBL_QPS_CHK_ITEM (FORM_ID, HOSP_CD, SORT, ITEM_NM, GRP_NM, INPUT_GB, UNIT_NM, USE_YN) VALUES
 ('PHA006','*', 1,'날짜'      ,NULL,'TEXT',NULL,'Y'),
 ('PHA006','*', 2,'환자이름'  ,NULL,'TEXT',NULL,'Y'),
 ('PHA006','*', 3,'등록번호'  ,NULL,'TEXT',NULL,'Y'),
 ('PHA006','*', 4,'수정 요청내용',NULL,'TEXT',NULL,'Y'),
 ('PHA006','*', 5,'조치 사항' ,NULL,'TEXT',NULL,'Y'),
 ('PHA006','*', 6,'처방한 의사',NULL,'TEXT',NULL,'Y'),
 ('PHA006','*', 7,'확인'      ,NULL,'TEXT',NULL,'Y');

-- ═══════════════════════════════════════════════════════════════════════════
-- PHA008 · 의료용 마약류 저장시설 점검부  [별지 제24호서식]        [LIST]
-- ═══════════════════════════════════════════════════════════════════════════
--   ★1차에서 **GUIDE_TXT 가 200자라 못 넣었던 서식**이다. 1000자로 넓혀 이제 들어간다.
--     법정 서식이라 유의사항 4줄을 **줄이지 않는다** — 줄이면 원본이 아니다.
--   ⚠값이 O/X 가 아니라 **「유 / 무」** 다. 저장은 되지만(정규화가 한 글자만 건드리고
--     「유」·「무」는 목록에 없다) **이행 요약의 O/X 건수에서 전부 「기타」로 빠진다.**
--     ***「무 = 정상 = O」로 뒤집어 해석하는 것은 개발자가 정할 일이 아니다*** — 결정 대기 ②.

DELETE FROM TBL_QPS_CHK_ITEM WHERE FORM_ID='PHA008' AND HOSP_CD='*';
DELETE FROM TBL_QPS_CHK_FORM WHERE FORM_ID='PHA008' AND HOSP_CD='*';

INSERT INTO TBL_QPS_CHK_FORM
 (FORM_ID, HOSP_CD, FORM_NM, CATE_CD, DEPT_CD, AXIS_GB, PRD_GB, EQUIP_CNT,
  GUIDE_TXT, HEAD_NMS, SIGNER_YN, NOTE_YN, FIX_YN, SIGN_LINE, FOOT_TXT, SORT_NO, USE_YN, REG_USER)
VALUES
 ('PHA008', '*', '의료용 마약류 저장시설 점검부', 'DRUG', 'PHARM',
  'LIST', 'M', 15,
  '1. 마약류를 다른 의약품과 구별하여 잠금장치가 설치 된 업소내의 장소에 보관할 것
2. 의료용 마약류의 저장시설은 일반인이 쉽게 발견 할 수 없는 장소에 있으며, 이동할 수 없도록 할 것
3. 의료용 마약류의 저장시설에는 마약류취급자 또는 마약류취급자가 지정한 종업원외의 자를 출입시키지 않을 것
4. 의료용 마약류의 저장시설을 수시점검하고 이에 대한 기록을 작성한 점검부를 비치할 것 (저장시설점검부)',
  NULL, 'N', 'N', 'N', NULL,
  '■ 마약류 관리에 관한 법률 시행규칙 [별지 제24호서식]  <개정 2020. 5. 22.>',
  70, 'Y', 'system');

--   ★「점검내용」 열의 원본 머리글은 `점검내용 [상기 1~4 항목에 대한 점검 결과]` 이고
--     칸 안에 「이상여부」가 찍혀 있다. 표 위 안내에 1~4 가 이미 있으므로 열 이름은 그대로 옮긴다.
INSERT INTO TBL_QPS_CHK_ITEM (FORM_ID, HOSP_CD, SORT, ITEM_NM, GRP_NM, INPUT_GB, UNIT_NM, USE_YN) VALUES
 ('PHA008','*', 1,'일시'                ,NULL,'TEXT' ,NULL,'Y'),
 ('PHA008','*', 2,'점검내용 이상여부'    ,NULL,'CHECK',NULL,'Y'),
 ('PHA008','*', 3,'저장시설 이상 유무'   ,NULL,'CHECK',NULL,'Y'),
 ('PHA008','*', 4,'재고량 이상 유무'     ,NULL,'CHECK',NULL,'Y'),
 ('PHA008','*', 5,'그 밖의 이상 유무'    ,NULL,'CHECK',NULL,'Y'),
 ('PHA008','*', 6,'점검자'              ,NULL,'TEXT' ,NULL,'Y'),
 ('PHA008','*', 7,'서명 또는 인'         ,NULL,'TEXT' ,NULL,'Y');

-- ═══════════════════════════════════════════════════════════════════════════
-- PHA009 · 약제과 환경 점검표                          [ITEM_DAY · 행 그룹 3]
-- ═══════════════════════════════════════════════════════════════════════════
--   ★행 그룹 = 업무전 / 조제환경 / 업무후. ***순서가 곧 묶음이다*** — 섞으면 묶음이 쪼개진다.
--   ★원본 항목 문구에 줄바꿈·괄호 설명이 붙어 있다. **괄호까지 그대로 옮긴다** —
--     「분쇄기 분쇄틀」만 남기면 *언제* 청소하는지가 사라진다.
--   ⚠**「대청소」 줄을 격자에 못 담았다.** 원본은 표 맨 아래에 날짜 칸 없이
--     `대청소 | 집진기 필터관리 – 월 1회 ( ___ ) | 서명` 한 줄이 병합돼 있다.
--     ***격자의 한 행으로 만들면 31칸이 생겨 원본과 달라진다.*** ⇒ ※문구로 글자만 옮겼다.
--     칸에 적어야 한다는 요구가 나오면 그때 「항목 뒤 열」이나 개별 행으로 옮긴다.

DELETE FROM TBL_QPS_CHK_ITEM WHERE FORM_ID='PHA009' AND HOSP_CD='*';
DELETE FROM TBL_QPS_CHK_FORM WHERE FORM_ID='PHA009' AND HOSP_CD='*';

INSERT INTO TBL_QPS_CHK_FORM
 (FORM_ID, HOSP_CD, FORM_NM, CATE_CD, DEPT_CD, AXIS_GB, PRD_GB, PRD_KIND, EQUIP_CNT,
  GUIDE_TXT, HEAD_NMS, SIGNER_YN, NOTE_YN, FIX_YN, SIGN_LINE, FOOT_TXT, SORT_NO, USE_YN, REG_USER)
VALUES
 ('PHA009', '*', '약제과 환경 점검표', 'ENV', 'PHARM',
  'ITEM_DAY', 'M', 'D', 10, NULL, NULL, 'Y', 'N', 'N', NULL,
  '대청소 : 집진기 필터관리 – 월 1회',
  80, 'Y', 'system');

INSERT INTO TBL_QPS_CHK_ITEM (FORM_ID, HOSP_CD, SORT, ITEM_NM, GRP_NM, INPUT_GB, UNIT_NM, USE_YN) VALUES
 ('PHA009','*', 1,'업무시작 전 청결상태 점검 1) 조제대, 조제기, 조제약장, 실링기 및 가운','업무전','CHECK',NULL,'Y'),
 ('PHA009','*', 2,'청결유지 물품 확인 (청소도구, 알콜솜 등)'      ,'업무전' ,'CHECK',NULL,'Y'),
 ('PHA009','*', 3,'손씻기'                                        ,'업무전' ,'CHECK',NULL,'Y'),
 ('PHA009','*', 4,'자동조제기 전원상태 확인'                       ,'업무전' ,'CHECK',NULL,'Y'),
 ('PHA009','*', 5,'조제도구 (약가위, 약삽 등)'                     ,'조제환경','CHECK',NULL,'Y'),
 ('PHA009','*', 6,'분쇄기 분쇄틀 (환자별 조제 전/후 즉각 붓으로 청소)','조제환경','CHECK',NULL,'Y'),
 ('PHA009','*', 7,'집진기 작동'                                    ,'조제환경','CHECK',NULL,'Y'),
 ('PHA009','*', 8,'조제대 소독관리 (중간수준 환경소독)'             ,'조제환경','CHECK',NULL,'Y'),
 ('PHA009','*', 9,'비품(약 플레이트) 세척, 건조'                   ,'업무후' ,'CHECK',NULL,'Y'),
 ('PHA009','*',10,'분쇄기 본체 (알콜솜 세척 후 건조)'               ,'업무후' ,'CHECK',NULL,'Y'),
 ('PHA009','*',11,'약품제자리 정리정돈'                            ,'업무후' ,'CHECK',NULL,'Y'),
 ('PHA009','*',12,'마약류 보관, 잠금 상태 확인'                     ,'업무후' ,'CHECK',NULL,'Y'),
 ('PHA009','*',13,'자동조제기 전원 끄고 확인'                       ,'업무후' ,'CHECK',NULL,'Y'),
 ('PHA009','*',14,'출입문 잠금 상태 확인'                          ,'업무후' ,'CHECK',NULL,'Y');

-- ═══════════════════════════════════════════════════════════════════════════
-- PHA010 · 자동 조제기 일일 점검 대장          [ITEM_DAY · 인쇄 15칸 위아래]
-- ═══════════════════════════════════════════════════════════════════════════
--   ★원본이 **1~15 / 16~31 두 토막**으로 그려져 있다 — v3 의 `SPLIT_N=15 · SPLIT_DIR='C'`.
--     ***화면은 한 표, 종이만 나뉜다.*** (자투리 1칸은 앞 조각에 붙어 정확히 두 장이 된다)
--   ★상단 「사용부서 : 약제실」은 상단 자유칸으로 둔다 — 병원마다 부서 이름이 다를 수 있다.
--   ⚠**하단 「문제 발생시」 표를 담지 못했다.** `발생일자 | 문제발생내용 | 처리내용 | 확인` 3행이다.
--     ***네 부서에서 7종이 같은 표를 달고 있다*** — 「문제 발생시 부가 입력표」로 따로 만들 것.
--     지금은 특이사항(NOTE) 칸으로 대신한다.

DELETE FROM TBL_QPS_CHK_ITEM WHERE FORM_ID='PHA010' AND HOSP_CD='*';
DELETE FROM TBL_QPS_CHK_FORM WHERE FORM_ID='PHA010' AND HOSP_CD='*';

INSERT INTO TBL_QPS_CHK_FORM
 (FORM_ID, HOSP_CD, FORM_NM, CATE_CD, DEPT_CD, AXIS_GB, PRD_GB, PRD_KIND, EQUIP_CNT,
  SPLIT_N, SPLIT_DIR, GUIDE_TXT, HEAD_NMS,
  SIGNER_YN, NOTE_YN, FIX_YN, SIGN_LINE, FOOT_TXT, SORT_NO, USE_YN, REG_USER)
VALUES
 ('PHA010', '*', '자동 조제기 일일 점검 대장', 'EQUIP', 'PHARM',
  'ITEM_DAY', 'M', 'D', 10,
  15, 'C',
  '범례 : ○양호, △보통, ×불량', '사용부서',
  'Y', 'Y', 'N', NULL, NULL, 90, 'Y', 'system');

INSERT INTO TBL_QPS_CHK_ITEM (FORM_ID, HOSP_CD, SORT, ITEM_NM, GRP_NM, INPUT_GB, UNIT_NM, USE_YN) VALUES
 ('PHA010','*', 1,'전원공급 상태'              ,NULL,'CHECK',NULL,'Y'),
 ('PHA010','*', 2,'약세사리 파손여부 (캐니스터 등)',NULL,'CHECK',NULL,'Y'),
 ('PHA010','*', 3,'오토 캐니스터(FSP) 작동확인' ,NULL,'CHECK',NULL,'Y'),
 ('PHA010','*', 4,'위생 점검'                  ,NULL,'CHECK',NULL,'Y'),
 ('PHA010','*', 5,'약포지 인쇄상태'            ,NULL,'CHECK',NULL,'Y'),
 ('PHA010','*', 6,'기타 작동상의 문제'          ,NULL,'CHECK',NULL,'Y'),
 ('PHA010','*', 7,'약포지(소모품재고)'          ,NULL,'CHECK',NULL,'Y');

-- ═══════════════════════════════════════════════════════════════════════════
-- PHA004 · 수액보관실 온,습도 점검일지                              [DAY_ITEM]
-- ═══════════════════════════════════════════════════════════════════════════
--   ★날짜가 **행**, 온도·습도·점검자가 **열**. PHA001 과 같은 짜임의 단순판이다.
--   ★온도·습도는 **NUM** 이다 — CHECK 로 두면 「1」이 「O」로 바뀐다.

DELETE FROM TBL_QPS_CHK_ITEM WHERE FORM_ID='PHA004' AND HOSP_CD='*';
DELETE FROM TBL_QPS_CHK_FORM WHERE FORM_ID='PHA004' AND HOSP_CD='*';

INSERT INTO TBL_QPS_CHK_FORM
 (FORM_ID, HOSP_CD, FORM_NM, CATE_CD, DEPT_CD, AXIS_GB, PRD_GB, PRD_KIND, EQUIP_CNT,
  GUIDE_TXT, HEAD_NMS, SIGNER_YN, NOTE_YN, FIX_YN, SIGN_LINE, FOOT_TXT, SORT_NO, USE_YN, REG_USER)
VALUES
 ('PHA004', '*', '수액보관실 온,습도 점검일지', 'ENV', 'PHARM',
  'DAY_ITEM', 'M', 'D', 10,
  '※ 온도: 1~25℃, 습도: 70% 미만', NULL, 'N', 'N', 'N', NULL, NULL, 40, 'Y', 'system');

INSERT INTO TBL_QPS_CHK_ITEM (FORM_ID, HOSP_CD, SORT, ITEM_NM, GRP_NM, INPUT_GB, UNIT_NM, USE_YN) VALUES
 ('PHA004','*', 1,'온도'  ,NULL,'NUM' ,'℃','Y'),
 ('PHA004','*', 2,'습도'  ,NULL,'NUM' ,'%' ,'Y'),
 ('PHA004','*', 3,'점검자',NULL,'TEXT',NULL,'Y');

-- ═══════════════════════════════════════════════════════════════════════════
-- PHA011 · 반자동 조제기 일일 점검표          [ITEM_DAY · 인쇄 15칸 위아래]
-- ═══════════════════════════════════════════════════════════════════════════
--   ★PHA010(자동)과 **틀이 같고 항목만 다르다.** 원본이 그렇게 생겼다 — 합치지 않는다.
--   ⚠하단 「문제 발생시」 표는 PHA010 과 같은 이유로 못 담았다(특이사항 칸으로 대신).

DELETE FROM TBL_QPS_CHK_ITEM WHERE FORM_ID='PHA011' AND HOSP_CD='*';
DELETE FROM TBL_QPS_CHK_FORM WHERE FORM_ID='PHA011' AND HOSP_CD='*';

INSERT INTO TBL_QPS_CHK_FORM
 (FORM_ID, HOSP_CD, FORM_NM, CATE_CD, DEPT_CD, AXIS_GB, PRD_GB, PRD_KIND, EQUIP_CNT,
  SPLIT_N, SPLIT_DIR, GUIDE_TXT, HEAD_NMS,
  SIGNER_YN, NOTE_YN, FIX_YN, SIGN_LINE, FOOT_TXT, SORT_NO, USE_YN, REG_USER)
VALUES
 ('PHA011', '*', '반자동 조제기 일일 점검표', 'EQUIP', 'PHARM',
  'ITEM_DAY', 'M', 'D', 10,
  15, 'C',
  '범례 : ○양호, △보통, ×불량', '사용부서',
  'Y', 'Y', 'N', NULL, NULL, 100, 'Y', 'system');

INSERT INTO TBL_QPS_CHK_ITEM (FORM_ID, HOSP_CD, SORT, ITEM_NM, GRP_NM, INPUT_GB, UNIT_NM, USE_YN) VALUES
 ('PHA011','*', 1,'전원공급 상태'          ,NULL,'CHECK',NULL,'Y'),
 ('PHA011','*', 2,'작동 시 소음 및 이상 작동',NULL,'CHECK',NULL,'Y'),
 ('PHA011','*', 3,'인쇄 상태'              ,NULL,'CHECK',NULL,'Y'),
 ('PHA011','*', 4,'파손이나 불량'           ,NULL,'CHECK',NULL,'Y'),
 ('PHA011','*', 5,'기기의 오염'            ,NULL,'CHECK',NULL,'Y'),
 ('PHA011','*', 6,'기타 문제'              ,NULL,'CHECK',NULL,'Y');

-- ═══════════════════════════════════════════════════════════════════════════
-- PHA022 · 백신 보관 냉장고 일일체크리스트     [ITEM_DAY · **행 블록(가로 띠)**]
-- ═══════════════════════════════════════════════════════════════════════════
--   ★★***결정 대기 ④「행 그룹 모양」이 가리키던 바로 그 서식이다.***
--     원본이 묶음을 **왼쪽 세로 칸이 아니라 표를 가로지르는 띠**로 그린다.
--     ⇒ v3 순서 5 에서 만든 `ROW_BLK_GB='B'` 를 쓰는 **첫 실물**이다.
--   ⚠**판정표(약국)에 이 서식이 빠져 있었다.** 결정 대기 ④에 이름만 남아 있었다.
--     ⇒ 등록 대장의 약국 큐에 **PHA022 로 더한다.**
--   ★「현재 온도」는 원본이 3단(항목 → 오전/오후)이다. 영양 「조리실 냉장/냉동고」와 같은 방법으로
--     ***원본의 두 조각을 이어 붙여*** 2단으로 눌러 담았다. 없는 말은 보태지 않았다.
--   ⚠담지 못한 것 :
--     · 시건장치 행에 원본이 「해 당 사 항 없 음」을 **가로로 병합**해 두었다(적는 칸이 아니다).
--       ⇒ 항목은 그대로 두되 그 표시는 못 옮겼다. 병원이 빈칸으로 두면 된다.
--     · 「점검자 날인」 줄이 **둘**이다(오전/오후로 보이나 원본에 글자가 없다).
--       ***무엇인지 적혀 있지 않은 것을 이름 붙이지 않는다*** ⇒ 사인 줄 하나만 켰다.
--   ★「기타사항」 띠 아래 한 행은 원본에 **이름이 없다.** 띠 이름을 그대로 항목명으로 썼다 —
--     그 띠에 행이 하나뿐이라 뜻이 어긋나지 않는다.

DELETE FROM TBL_QPS_CHK_ITEM WHERE FORM_ID='PHA022' AND HOSP_CD='*';
DELETE FROM TBL_QPS_CHK_FORM WHERE FORM_ID='PHA022' AND HOSP_CD='*';

INSERT INTO TBL_QPS_CHK_FORM
 (FORM_ID, HOSP_CD, FORM_NM, CATE_CD, DEPT_CD, AXIS_GB, PRD_GB, PRD_KIND, EQUIP_CNT,
  ROW_BLK_GB, GUIDE_TXT, HEAD_NMS,
  SIGNER_YN, NOTE_YN, FIX_YN, SIGN_LINE, FOOT_TXT, SORT_NO, USE_YN, REG_USER)
VALUES
 ('PHA022', '*', '백신 보관 냉장고 일일체크리스트', 'ENV', 'PHARM',
  'ITEM_DAY', 'M', 'D', 10,
  'B', NULL, NULL, 'Y', 'N', 'N', NULL, NULL, 110, 'Y', 'system');

INSERT INTO TBL_QPS_CHK_ITEM (FORM_ID, HOSP_CD, SORT, ITEM_NM, GRP_NM, INPUT_GB, UNIT_NM, USE_YN) VALUES
 ('PHA022','*', 1,'백신보관용 냉장고의 전원플러그는 벽면의 콘센트에 연결되어 있고 누전 등의 염려는 없는지 확인하였는가?','장비 운영 확인 사항','CHECK',NULL,'Y'),
 ('PHA022','*', 2,'백신보관용 냉장고의 도어 폐쇄상태는 올바른가? (냉장고 도어 자연개방 여부 확인 철저)','장비 운영 확인 사항','CHECK',NULL,'Y'),
 ('PHA022','*', 3,'백신보관용 냉장고 도어에 대한 시건장치는 마련되어 있는가? (권장사항)','장비 운영 확인 사항','CHECK',NULL,'Y'),
 ('PHA022','*', 4,'백신보관 냉장고의 현재 온도는 몇 도인가? (오전 AM09:00)','백신보관 냉장고의 온도','NUM','℃','Y'),
 ('PHA022','*', 5,'백신보관 냉장고의 현재 온도는 몇 도인가? (오후 PM05:00)','백신보관 냉장고의 온도','NUM','℃','Y'),
 ('PHA022','*', 6,'디지털 온도계, 자동온도기록장치는 정상적으로 작동하고 있는가?','백신보관 냉장고의 온도','CHECK',NULL,'Y'),
 ('PHA022','*', 7,'디지털 온도계는 백신이 저장된 공간과 일치하는 곳의 온도를 측정 중인가?','백신보관 냉장고의 온도','CHECK',NULL,'Y'),
 ('PHA022','*', 8,'백신보관 냉장고의 온도일탈 경보는 설정되었는가? ( 2℃ 이하/ 8℃ 이상 문자수신)','백신보관 냉장고의 온도','CHECK',NULL,'Y'),
 ('PHA022','*', 9,'관할보건소 담당자 연락처','응급상황 발생 시 대응절차 숙지','TEXT',NULL,'Y'),
 ('PHA022','*',10,'냉장고 고장 시 연락처'  ,'응급상황 발생 시 대응절차 숙지','TEXT',NULL,'Y'),
 ('PHA022','*',11,'기타사항'              ,'기타사항','TEXT',NULL,'Y');

-- ═══════════════════════════════════════════════════════════════════════════
-- PHA007 · 유효기간 임박 약물 관리서                                    [LIST]
-- ═══════════════════════════════════════════════════════════════════════════
--   ★열 묶음 「유효기간 경과 후 관리」 = 일시 · 관리.
--   ★표 위 안내에 **관리 기준(3개월)** 이 적혀 있다 — 이 문장이 서식의 뜻이라 그대로 옮긴다.

DELETE FROM TBL_QPS_CHK_ITEM WHERE FORM_ID='PHA007' AND HOSP_CD='*';
DELETE FROM TBL_QPS_CHK_FORM WHERE FORM_ID='PHA007' AND HOSP_CD='*';

INSERT INTO TBL_QPS_CHK_FORM
 (FORM_ID, HOSP_CD, FORM_NM, CATE_CD, DEPT_CD, AXIS_GB, PRD_GB, EQUIP_CNT,
  GUIDE_TXT, HEAD_NMS, SIGNER_YN, NOTE_YN, FIX_YN, SIGN_LINE, FOOT_TXT, SORT_NO, USE_YN, REG_USER)
VALUES
 ('PHA007', '*', '유효기간 임박 약물 관리서', 'DRUG', 'PHARM',
  'LIST', 'M', 15,
  '조제실 담당자(약사)는 약물 재고를 확인하여 잔여 유효기간 3개월 미만의 약은 유효기간 임박약물로 관리한다.',
  NULL, 'N', 'N', 'N', NULL, NULL, 65, 'Y', 'system');

INSERT INTO TBL_QPS_CHK_ITEM (FORM_ID, HOSP_CD, SORT, ITEM_NM, GRP_NM, INPUT_GB, UNIT_NM, USE_YN) VALUES
 ('PHA007','*', 1,'약품명'  ,NULL                ,'TEXT',NULL,'Y'),
 ('PHA007','*', 2,'성분명'  ,NULL                ,'TEXT',NULL,'Y'),
 ('PHA007','*', 3,'유효기간',NULL                ,'TEXT',NULL,'Y'),
 ('PHA007','*', 4,'수량'    ,NULL                ,'TEXT',NULL,'Y'),
 ('PHA007','*', 5,'사용여부',NULL                ,'TEXT',NULL,'Y'),
 ('PHA007','*', 6,'일시'    ,'유효기간 경과 후 관리','TEXT',NULL,'Y'),
 ('PHA007','*', 7,'관리'    ,'유효기간 경과 후 관리','TEXT',NULL,'Y');

-- ═══════════════════════════════════════════════════════════════════════════
-- PHA012 · 약제과 약사부재중 조제 및 출입관리대장            [LIST · 연단위]
-- ═══════════════════════════════════════════════════════════════════════════
--   ★상단이 **「2026 년」 하나뿐**이다 ⇒ `PRD_GB='Y'`. 한 해를 이어 쓰는 대장이다.

DELETE FROM TBL_QPS_CHK_ITEM WHERE FORM_ID='PHA012' AND HOSP_CD='*';
DELETE FROM TBL_QPS_CHK_FORM WHERE FORM_ID='PHA012' AND HOSP_CD='*';

INSERT INTO TBL_QPS_CHK_FORM
 (FORM_ID, HOSP_CD, FORM_NM, CATE_CD, DEPT_CD, AXIS_GB, PRD_GB, EQUIP_CNT,
  GUIDE_TXT, HEAD_NMS, SIGNER_YN, NOTE_YN, FIX_YN, SIGN_LINE, FOOT_TXT, SORT_NO, USE_YN, REG_USER)
VALUES
 ('PHA012', '*', '약제과 약사부재중 조제 및 출입관리대장', 'DRUG', 'PHARM',
  'LIST', 'Y', 20, NULL, NULL, 'N', 'N', 'N', NULL, NULL, 120, 'Y', 'system');

INSERT INTO TBL_QPS_CHK_ITEM (FORM_ID, HOSP_CD, SORT, ITEM_NM, GRP_NM, INPUT_GB, UNIT_NM, USE_YN) VALUES
 ('PHA012','*', 1,'날짜'      ,NULL,'TEXT',NULL,'Y'),
 ('PHA012','*', 2,'출입시간'   ,NULL,'TEXT',NULL,'Y'),
 ('PHA012','*', 3,'등록번호'   ,NULL,'TEXT',NULL,'Y'),
 ('PHA012','*', 4,'환자성명'   ,NULL,'TEXT',NULL,'Y'),
 ('PHA012','*', 5,'환자 약'    ,NULL,'TEXT',NULL,'Y'),
 ('PHA012','*', 6,'의사서명'   ,NULL,'TEXT',NULL,'Y'),
 ('PHA012','*', 7,'간호사서명' ,NULL,'TEXT',NULL,'Y'),
 ('PHA012','*', 8,'약사확인서명',NULL,'TEXT',NULL,'Y');

-- ═══════════════════════════════════════════════════════════════════════════
-- PHA023 · 비치의약품 보관상태 점검대장(약국용)   [ITEM_COL · 일 · 행 그룹 7]
-- ═══════════════════════════════════════════════════════════════════════════
--   ★★***v2 때 「2종뿐이라 아직 안 만든다」고 미뤄 둔 `ITEM_COL` 의 첫 근거였던 서식이다.***
--     v3 에서 축을 만들었으므로 이제 그대로 들어간다.
--   ★문서 단위가 **일**이다(상단 년/월/**일**) — 한 번 점검에 한 장.
--   ⚠담지 못한 것 — ***반쪽이니 등록 전에 알고 있어야 한다*** :
--     ① 「비고」 열에 **미리 찍힌 안내**가 몇 줄 있다
--        (고농축전해질류 → "반드시 회석후사용 표" / 리스트 행 → "위치/상태" / 마약장 → "정 · 약사").
--        비고는 병원이 적는 칸이라 미리 채울 수 없다. 항목 설명 열로 옮기면 **열이 하나 늘어** 원본과 달라진다.
--        ⇒ ***지금은 못 옮겼다.*** 「항목마다 다른 안내」가 여러 서식에서 또 나오면 그때 장치를 만든다.
--     ② 표 아래 절반이 격자가 아니다 — `유효기간점검(임박 의약품 빈 칸 2행)` ·
--        `조치사항(사용 중단된 의약품 비치, 의약품의 개봉, 파손 등)` · `차광보관` · `유효기간점검 약사 서명`.
--        ⇒ 조치사항은 **특이사항 칸**으로, 약사 서명은 **서명란**으로 대신했다.
--          나머지 두 칸은 못 담았다. ***담은 척하지 않는다.***

DELETE FROM TBL_QPS_CHK_ITEM WHERE FORM_ID='PHA023' AND HOSP_CD='*';
DELETE FROM TBL_QPS_CHK_FORM WHERE FORM_ID='PHA023' AND HOSP_CD='*';

INSERT INTO TBL_QPS_CHK_FORM
 (FORM_ID, HOSP_CD, FORM_NM, CATE_CD, DEPT_CD, AXIS_GB, PRD_GB, EQUIP_CNT,
  COL_NMS, COL_SRC, GUIDE_TXT, HEAD_NMS,
  SIGNER_YN, NOTE_YN, FIX_YN, SIGN_LINE, FOOT_TXT, SORT_NO, USE_YN, REG_USER)
VALUES
 ('PHA023', '*', '비치의약품 보관상태 점검대장(약국용)', 'DRUG', 'PHARM',
  'ITEM_COL', 'D', 10,
  'Y,N,비고', 'F', NULL, NULL,
  'N', 'Y', 'N', '약사',
  '조치사항 : 사용 중단된 의약품 비치, 의약품의 개봉, 파손 등 — 특이사항 칸에 적습니다.',
  130, 'Y', 'system');

INSERT INTO TBL_QPS_CHK_ITEM (FORM_ID, HOSP_CD, SORT, ITEM_NM, GRP_NM, INPUT_GB, UNIT_NM, USE_YN) VALUES
 ('PHA023','*', 1,'이중금고'          ,'마약류'   ,'CHECK',NULL,'Y'),   -- 2026-09-02 원본(Pharm_Chart_020_A) 대조 : 「이중잠금」→「이중금고」
 ('PHA023','*', 2,'출납대장 보유'      ,'마약류'   ,'CHECK',NULL,'Y'),
 ('PHA023','*', 3,'마약장 관리자 표시'  ,'마약류'   ,'CHECK',NULL,'Y'),
 ('PHA023','*', 4,'잔량 반납 적절성'    ,'마약류'   ,'CHECK',NULL,'Y'),
 ('PHA023','*', 5,'분리보관여부'       ,'고위험약물','CHECK',NULL,'Y'),
 ('PHA023','*', 6,'고농축전해질류'      ,'고위험약물','CHECK',NULL,'Y'),
 ('PHA023','*', 7,'고위험의약품 리스트' ,'고위험약물','CHECK',NULL,'Y'),
 ('PHA023','*', 8,'표시여부'          ,'고주의약품','CHECK',NULL,'Y'),
 ('PHA023','*', 9,'고주의약물 리스트'   ,'고주의약품','CHECK',NULL,'Y'),
 ('PHA023','*',10,'정확한 약품/수량'    ,'응급비치약','CHECK',NULL,'Y'),
 ('PHA023','*',11,'봉인여부'          ,'응급비치약','CHECK',NULL,'Y'),
 ('PHA023','*',12,'정확한 의약품/수량'  ,'일반비치약','CHECK',NULL,'Y'),
 ('PHA023','*',13,'냉장보관 적절성'     ,'냉장보관' ,'CHECK',NULL,'Y'),
 ('PHA023','*',14,'냉장,차광약품 리스트','냉장보관' ,'CHECK',NULL,'Y'),
 ('PHA023','*',15,'차광보관 적절성'     ,'차광보관' ,'CHECK',NULL,'Y');

-- ═══════════════════════════════════════════════════════════════════════════
-- PHA013 · 회수의약품 관리대장                                  [LIST · 연단위]
-- PHA014 · 폐기 의약품 대장                                     [LIST · 일단위]
-- ═══════════════════════════════════════════════════════════════════════════
--   ★둘은 이름이 닮았지만 **문서 단위가 다르다** — 회수는 한 해를 이어 쓰고(상단 「년」만),
--     폐기는 **한 번에 한 장**이다(상단 년/월/**일**). ***이름만 보고 합치지 않는다.***

DELETE FROM TBL_QPS_CHK_ITEM WHERE FORM_ID IN ('PHA013','PHA014') AND HOSP_CD='*';
DELETE FROM TBL_QPS_CHK_FORM WHERE FORM_ID IN ('PHA013','PHA014') AND HOSP_CD='*';

INSERT INTO TBL_QPS_CHK_FORM
 (FORM_ID, HOSP_CD, FORM_NM, CATE_CD, DEPT_CD, AXIS_GB, PRD_GB, EQUIP_CNT,
  GUIDE_TXT, HEAD_NMS, SIGNER_YN, NOTE_YN, FIX_YN, SIGN_LINE, FOOT_TXT, SORT_NO, USE_YN, REG_USER)
VALUES
 ('PHA013', '*', '회수의약품 관리대장', 'DRUG', 'PHARM',
  'LIST', 'Y', 20, NULL, NULL, 'N', 'N', 'N', NULL, NULL, 140, 'Y', 'system'),
 ('PHA014', '*', '폐기 의약품 대장', 'DRUG', 'PHARM',
  'LIST', 'D', 20, NULL, NULL, 'N', 'N', 'N', NULL, NULL, 150, 'Y', 'system');

INSERT INTO TBL_QPS_CHK_ITEM (FORM_ID, HOSP_CD, SORT, ITEM_NM, GRP_NM, INPUT_GB, UNIT_NM, USE_YN) VALUES
 ('PHA013','*', 1,'날짜'    ,NULL,'TEXT',NULL,'Y'),
 ('PHA013','*', 2,'약품명'  ,NULL,'TEXT',NULL,'Y'),
 ('PHA013','*', 3,'단위'    ,NULL,'TEXT',NULL,'Y'),
 ('PHA013','*', 4,'수량'    ,NULL,'TEXT',NULL,'Y'),
 ('PHA013','*', 5,'유효기간',NULL,'TEXT',NULL,'Y'),
 ('PHA013','*', 6,'반품처'  ,NULL,'TEXT',NULL,'Y'),
 ('PHA013','*', 7,'비고'    ,NULL,'TEXT',NULL,'Y'),
 ('PHA014','*', 1,'품목명'  ,NULL,'TEXT',NULL,'Y'),
 ('PHA014','*', 2,'제조사'  ,NULL,'TEXT',NULL,'Y'),
 ('PHA014','*', 3,'제조번호',NULL,'TEXT',NULL,'Y'),
 ('PHA014','*', 4,'사용기간',NULL,'TEXT',NULL,'Y'),
 ('PHA014','*', 5,'수량'    ,NULL,'TEXT',NULL,'Y'),
 ('PHA014','*', 6,'폐기사유',NULL,'TEXT',NULL,'Y');

-- ═══════════════════════════════════════════════════════════════════════════
-- PHA021 · 냉장고온도관리기록지                    [DAY_ITEM · 상단 8칸 · 열 묶음]
-- ═══════════════════════════════════════════════════════════════════════════
--   ★★***이 서식 하나가 `HEAD5~8`(v3 순서 1) 을 만들게 한 결정적 근거였다.***
--     「순수한 점검 격자인데 오직 상단 칸 때문에 밀려난다」고 적어 둔 그 서식이다. 이제 들어간다.
--   ★상단은 `1.고위험주사제` 4줄 · `2.향정신성의약품주사제` 4줄 = **8칸**.
--     원본은 줄에 번호가 없다 — 우리 상단 칸은 **줄지어 늘어놓는 것**이라 이름이 있어야 해서
--     `고위험주사제 1~4`처럼 **번호만** 붙였다. ***없는 말을 보태지는 않았다.***
--   ★열 묶음 `10시` / `19시` — ***원본은 2단 머리글이 아니라 평평한 6열이다.***
--     그대로 두면 「확인온도」·「점검자」가 **두 개씩 같은 이름**이 되어 추출 CSV 에서
--     어느 시간 값인지 사라진다(PHA001 에서 이미 겪은 문제다).
--     ⇒ 묶음을 세워 뜻을 지켰다. 머리글에 `10시` 가 두 번 보이는 것은 그 값이다.

DELETE FROM TBL_QPS_CHK_ITEM WHERE FORM_ID='PHA021' AND HOSP_CD='*';
DELETE FROM TBL_QPS_CHK_FORM WHERE FORM_ID='PHA021' AND HOSP_CD='*';

INSERT INTO TBL_QPS_CHK_FORM
 (FORM_ID, HOSP_CD, FORM_NM, CATE_CD, DEPT_CD, AXIS_GB, PRD_GB, PRD_KIND, EQUIP_CNT,
  GUIDE_TXT, HEAD_NMS, SIGNER_YN, NOTE_YN, FIX_YN, SIGN_LINE, FOOT_TXT, SORT_NO, USE_YN, REG_USER)
VALUES
 ('PHA021', '*', '냉장고온도관리기록지', 'ENV', 'PHARM',
  'DAY_ITEM', 'M', 'D', 10,
  '냉장고 적정온도 : 2~8 ℃',
  '고위험주사제 1,고위험주사제 2,고위험주사제 3,고위험주사제 4,향정신성의약품주사제 1,향정신성의약품주사제 2,향정신성의약품주사제 3,향정신성의약품주사제 4',
  'N', 'N', 'N', NULL, NULL, 160, 'Y', 'system');

INSERT INTO TBL_QPS_CHK_ITEM (FORM_ID, HOSP_CD, SORT, ITEM_NM, GRP_NM, INPUT_GB, UNIT_NM, USE_YN) VALUES
 ('PHA021','*', 1,'10시'    ,'10시','TEXT',NULL,'Y'),
 ('PHA021','*', 2,'확인온도','10시','NUM' ,'℃','Y'),
 ('PHA021','*', 3,'점검자'  ,'10시','TEXT',NULL,'Y'),
 ('PHA021','*', 4,'19시'    ,'19시','TEXT',NULL,'Y'),
 ('PHA021','*', 5,'확인온도','19시','NUM' ,'℃','Y'),
 ('PHA021','*', 6,'점검자'  ,'19시','TEXT',NULL,'Y');

-- ═══════════════════════════════════════════════════════════════════════════
-- PHA015 · 알러지 환자 내역 관리대장(약국)                              [LIST]
-- ═══════════════════════════════════════════════════════════════════════════
--   ⚠**「Allergy 환자 내역 - 약국」과 다른 서식이다.** 그건 환자 1명당 1장짜리 라벨-값 폼이고
--     이건 대장이다. ***이름이 닮았다고 합치지 않는다.***
--   ⚠영양의 「식품 Allergy 환자 리스트」와도 마지막 열이 **약물/식품**으로 갈린다 — 서식 2개다.

DELETE FROM TBL_QPS_CHK_ITEM WHERE FORM_ID='PHA015' AND HOSP_CD='*';
DELETE FROM TBL_QPS_CHK_FORM WHERE FORM_ID='PHA015' AND HOSP_CD='*';

INSERT INTO TBL_QPS_CHK_FORM
 (FORM_ID, HOSP_CD, FORM_NM, CATE_CD, DEPT_CD, AXIS_GB, PRD_GB, EQUIP_CNT,
  GUIDE_TXT, HEAD_NMS, SIGNER_YN, NOTE_YN, FIX_YN, SIGN_LINE, FOOT_TXT, SORT_NO, USE_YN, REG_USER)
VALUES
 ('PHA015', '*', '알러지 환자 내역 관리대장(약국)', 'DRUG', 'PHARM',
  'LIST', 'M', 20, NULL, NULL, 'N', 'N', 'N', NULL, NULL, 170, 'Y', 'system');

INSERT INTO TBL_QPS_CHK_ITEM (FORM_ID, HOSP_CD, SORT, ITEM_NM, GRP_NM, INPUT_GB, UNIT_NM, USE_YN) VALUES
 ('PHA015','*', 1,'작성일자'          ,NULL,'TEXT',NULL,'Y'),
 ('PHA015','*', 2,'환자성명'          ,NULL,'TEXT',NULL,'Y'),
 ('PHA015','*', 3,'등록번호'          ,NULL,'TEXT',NULL,'Y'),
 ('PHA015','*', 4,'성별/나이'         ,NULL,'TEXT',NULL,'Y'),
 ('PHA015','*', 5,'진료과/병동'        ,NULL,'TEXT',NULL,'Y'),
 ('PHA015','*', 6,'알러지 및 과민반응 약물',NULL,'TEXT',NULL,'Y');

-- ── 확인 ────────────────────────────────────────────────────────────────────
SELECT f.FORM_ID, f.FORM_NM, f.AXIS_GB, f.PRD_GB, f.SPLIT_N, f.SPLIT_DIR, COUNT(i.SORT) AS 항목수
  FROM TBL_QPS_CHK_FORM f
  LEFT JOIN TBL_QPS_CHK_ITEM i ON i.FORM_ID = f.FORM_ID AND i.HOSP_CD = f.HOSP_CD
 WHERE f.FORM_ID LIKE 'PHA%' AND f.HOSP_CD = '*'
 GROUP BY f.FORM_ID, f.FORM_NM, f.AXIS_GB, f.PRD_GB, f.SPLIT_N, f.SPLIT_DIR
 ORDER BY f.FORM_ID;
