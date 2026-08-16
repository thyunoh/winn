-- =====================================================================
-- 월간보고서 지표 정의(def_01~15) — DB 템플릿을 JSP 확정 문구로 일괄 동기화 (2026-08-11)
--
--   ★왜: 검수(박혜련 2026-08-07) 지적분을 2026-08-10 오전 JSP(TPL_DEF)에 반영·커밋했으나
--     화면은 **TBL_EVAL_REPORT_TPL(DB)이 우선**이라 옛 문구가 계속 보였다("미변경" 신고의 원인).
--     def_06 때(2026-07-23)와 같은 함정 — JSP 만 고치면 DB 템플릿이 덮는다.
--   ★원칙(검수 요구): 지표 정의에는 기관별 분석 결과(현재 점수·표준화 구간·개선 여지)를 넣지 않는다.
--   ★이미 저장된 병원별 보고서의 편집본(옛 문구)은 설계상 유지된다 — 새로 생성·조회분부터 반영.
-- =====================================================================

UPDATE TBL_EVAL_REPORT_TPL SET UPD_USER='sync-20260811', TPL_CONTENT='월평균 재원환자수를 상근 환산 의사 수로 나눈 값. 값이 작을수록 우수(26명 미만 = 5구간).' WHERE SECT_KEY='def_01';
UPDATE TBL_EVAL_REPORT_TPL SET UPD_USER='sync-20260811', TPL_CONTENT='값이 작을수록 우수(6명 미만 = 5구간).' WHERE SECT_KEY='def_02';
UPDATE TBL_EVAL_REPORT_TPL SET UPD_USER='sync-20260811', TPL_CONTENT='간호사+간호조무사 등 간호인력 기준 1인당 환자수. 값이 작을수록 우수(3명 미만 = 5구간).' WHERE SECT_KEY='def_03';
UPDATE TBL_EVAL_REPORT_TPL SET UPD_USER='sync-20260811', TPL_CONTENT='평가대상기간 중 약사 재직일수 비율(100% = 5구간).' WHERE SECT_KEY='def_04';
UPDATE TBL_EVAL_REPORT_TPL SET UPD_USER='sync-20260811', TPL_CONTENT='전월 평가표 작성일로부터 유치도뇨관 삽입기간이 연속 14일을 초과한 대상자의 비율로, 연속 14일을 초과하지 않도록 관리함. 불필요한 유치도뇨관은 조기 제거하고, 재삽입이 필요한 경우 제거 후 2일이 지난 뒤 재삽입될 수 있도록 관리가 필요함.' WHERE SECT_KEY='def_05';
UPDATE TBL_EVAL_REPORT_TPL SET UPD_USER='sync-20260811', TPL_CONTENT='배뇨조절이 저하된 환자(자주 실금함·조절 못함) 중 배뇨관리를 실시한 환자의 비율. ① 일정하게 짜여진 배뇨계획에 따른 배뇨일지 3일 이상 작성, ② 방광훈련프로그램 시행 및 배뇨일지 3일 이상 작성, ③ 규칙적 도뇨 시행 중 1개 이상을 충족한 경우 분자로 인정함. 단, 의료최고도 및 배뇨 관련 루 관리 대상 등은 제외함.' WHERE SECT_KEY='def_06';
UPDATE TBL_EVAL_REPORT_TPL SET UPD_USER='sync-20260811', TPL_CONTENT='환자의 상병 구성을 보정하여 타 기관 대비 항정신성의약품 처방 수준을 평가하는 지표(PI)로, 값이 낮을수록 우수함(0.2 미만 = 5구간 / 1.6 이상 = 1구간). ※ 타 기관의 상병 구성 및 평균 처방률을 확인할 수 없어 WinCheck에서 산출된 PI값은 실제 평가결과와 차이가 있을 수 있으며 참고용으로 활용함. 기관 자체 처방률 기준으로는 10% 이하 시 5구간, 40% 이상 시 1구간 수준으로 참고하여 관리함.' WHERE SECT_KEY='def_07';
UPDATE TBL_EVAL_REPORT_TPL SET UPD_USER='sync-20260811', TPL_CONTENT='매월 심사평가원의 DUR 점검 현황을 확인하여 누락 대상자 관리가 필요하며 점검 결과에 따라 추후 결과 발표 시 점수차가 발생할 수 있음. 확인경로: 요양기관업무포털(biz.hira.or.kr) > 모니터링 > DUR정보 > 기관별 DUR 점검완료현황.' WHERE SECT_KEY='def_08';
UPDATE TBL_EVAL_REPORT_TPL SET UPD_USER='sync-20260811', TPL_CONTENT='1단계 이상 욕창을 보유한 환자 중 피부문제 처치를 적절히 실시한 환자의 비율. 압력을 줄이는 도구 사용, 체위변경, 욕창 해결을 위한 영양공급, 욕창부위 드레싱의 4개 항목을 모두 충족한 경우 처치 실시로 인정함. 단, 1단계 욕창은 드레싱을 시행하지 않아도 드레싱을 실시한 것으로 간주하여 평가함.' WHERE SECT_KEY='def_09';
UPDATE TBL_EVAL_REPORT_TPL SET UPD_USER='sync-20260811', TPL_CONTENT='해당 월 평가와 전월 평가를 모두 받은 욕창 고위험군 환자 중 전월에 비해 2단계 이상의 욕창이 새로 발생한 환자의 비율을 평가하는 지표.' WHERE SECT_KEY='def_10';
UPDATE TBL_EVAL_REPORT_TPL SET UPD_USER='sync-20260811', TPL_CONTENT='2단계 이상 욕창 보유 환자 중 당일 개선된 환자 비율(개선 = 욕창 단계 수가 줄거나 최고단계가 낮아진 경우).' WHERE SECT_KEY='def_11';
UPDATE TBL_EVAL_REPORT_TPL SET UPD_USER='sync-20260811', TPL_CONTENT='전월과 당월 의료최고도·선택입원군 및 10개 항목이 완전 자립이거나 감독 필요인 경우는 제외한 대상자 중, 전월 대비 10개 항목의 기능 정도가 2점 이상 개선된 환자의 비율.' WHERE SECT_KEY='def_12';
UPDATE TBL_EVAL_REPORT_TPL SET UPD_USER='sync-20260811', TPL_CONTENT='당뇨병 상병 환자 중 HbA1c 검사결과가 적정범위(4% 이상 ~ 8.5% 미만)에 해당하는 환자의 비율을 평가하는 지표임.' WHERE SECT_KEY='def_13';
UPDATE TBL_EVAL_REPORT_TPL SET UPD_USER='sync-20260811', TPL_CONTENT='평가 대상기간 동안 입원 중인 환자 중 입원기간이 181일 이상인 환자의 비율을 평가하는 지표로, 값이 낮을수록 우수함. 단, 평가기간(7~12월) 중 1개월이라도 의료최고도·의료고도·의료중도에 해당하는 환자는 평가대상에서 제외함.' WHERE SECT_KEY='def_14';
UPDATE TBL_EVAL_REPORT_TPL SET UPD_USER='sync-20260811', TPL_CONTENT='지역사회 복귀율은 심평원 및 행정안전부 자료 등을 연계하여 산출되는 지표로, 기관 자체 자료만으로는 정확한 결과값을 산출하기 어려워 WinCheck에서는 임의로 표준화 3점, 가중치 3점으로 적용함.' WHERE SECT_KEY='def_15';

-- 확인
-- SELECT SECT_KEY, LEFT(TPL_CONTENT,60) FROM TBL_EVAL_REPORT_TPL WHERE SECT_KEY LIKE 'def%' ORDER BY SECT_KEY;
