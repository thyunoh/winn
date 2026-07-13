-- =====================================================================
--  PATIENT_CATHETER_CHECK  14일 초과 판정 수정
--  작성일: 2026-07-11
--  ★핵심 사유(정양* 290725, 서울대림 2026-07 사례로 확정):
--    기산(시작일)이 이월 시 '전월 마지막 삽입일(PmLastInsD)'로 잡혀
--    전월에 이미 평가된 유지분을 당월에 재계산(더블카운트) → 14일 오집계.
--    규칙상 하한은 '전월 작성일 +1' 이어야 함(branch 2에는 2025-11-21 반영,
--    branch 3/5/6에는 미반영 → 불일치가 원인).
--  보조 사유: 비연속(제거 후 2일+ 공백) 재삽입 통산 방지(연속 세그먼트 방식),
--            당월 SELECT 중복행 제거.
--  적용  : 기존 함수 파라미터/전월·당월 조회는 그대로 두고,
--          아래 [패치0(핵심)][패치1][패치2] 반영하여 DROP+CREATE 재생성.
--  주의  : 배포 전 PATIENT_CATHETER_CHECK_TEST 로 만들어
--          기존 vs 수정 결과를 비교(특히 정양* 290725: Y→N 확인)한 뒤 교체.
--          교체 후 반드시 "적정성평가 월 자료생성" 재실행(좌측 분자 저장값 갱신).
-- =====================================================================


-- ─────────────────────────────────────────────────────────────────────
-- [패치0] ★핵심★ 이월 기산을 '전월 작성일 +1'로 통일 (branch 3, 5, 6)
--   전월 유지도뇨관이 당월로 이월될 때 시작일을 '전월 마지막 삽입일'이 아니라
--   '전월 평가표 작성일 +1'로 잡아, 전월 평가 몫을 당월이 재계산하지 않게 함.
--   (branch 2 는 이미 PmDoc_Date+1 사용 중 — 그와 일치시킴)
--
--   ▷ 대상: 아래 각 ELSEIF 안의  SET In_Date_01 = PmLastInsD ;  (3곳)
--       ① PmLastFlag='1' AND CmNullFlag='N'                    (branch 3)
--       ② PmLastFlag='1' AND CmNullFlag='Y' AND PmLastInsD<>'0..0'  (branch 5)
--       ③ PmLastFlag='1' AND CmNullFlag='N' AND PmLastInsD<>'0..0'  (branch 6)
--   ▷ 변경:
--       SET In_Date_01 = DATE_FORMAT(DATE_ADD(STR_TO_DATE(PmDoc_Date,'%Y%m%d'), INTERVAL 1 DAY), '%Y%m%d');
--
--   ※ branch 4 (PmLastFlag='2')도 동일하게 전월작성일+1로 변경 가능(window 규칙은 모든 이월 분기에 일관 적용). 2026-07-11 함께 변경함.
--   ※ branch 2 는 'PmDoc_Date + 1'(숫자덧셈) 그대로 — 전월작성일 월말이면 오류 가능. 월말 대비하려면 동일한 DATE_ADD 형태로 통일 권장(선택).
--   ※ ★검증 완료(2026-07-11, 정양* 290725, 서울대림 HOSP_CD=11283190, 2026-07):
--       전월 05-26삽입→(유지) / 07월평가 06-09제거·06-12삽입→06-24제거, 전월작성일 06-07
--       변경 전: In_Date_01=05-26 → 05-26~06-09=14 → 기존함수 'Y'(오집계)
--       변경 후: In_Date_01=06-08 → 06-08~06-09=1, (3일공백 끊김) 06-12~06-24=12 → 최대12 → _TEST 'N'(정상)
--       → PATIENT_CATHETER_CHECK vs _TEST 비교 결과 기존=Y / 수정=N 확인.


-- ─────────────────────────────────────────────────────────────────────
-- [패치1] 당월 SELECT 중복행 제거  (전월 SELECT와 동일하게 MAX(DOC_DT)+LIMIT 1)
--   기존:
--       FROM TBL_PATVAL_MST cpm
--      WHERE cpm.HOSP_CD    = p_hostcd
--        AND cpm.CLFORM_VER = p_clform
--        AND cpm.PAT_ID     = p_pat_id
--        AND cpm.ADMIT_DT   = p_adm_dt
--        AND cpm.MED_START  = p_med_dt;
--   변경(끝의 세미콜론 앞에 추가):
       FROM TBL_PATVAL_MST cpm
      WHERE cpm.HOSP_CD    = p_hostcd
        AND cpm.CLFORM_VER = p_clform
        AND cpm.PAT_ID     = p_pat_id
        AND cpm.ADMIT_DT   = p_adm_dt
        AND cpm.MED_START  = p_med_dt
        AND cpm.DOC_DT     = ( SELECT MAX(c.DOC_DT)
                                 FROM TBL_PATVAL_MST c
                                WHERE c.HOSP_CD    = cpm.HOSP_CD
                                  AND c.CLFORM_VER = cpm.CLFORM_VER
                                  AND c.MED_START  = cpm.MED_START
                                  AND c.PAT_ID     = cpm.PAT_ID
                                  AND c.ADMIT_DT   = cpm.ADMIT_DT )
      LIMIT 1;


-- ─────────────────────────────────────────────────────────────────────
-- [패치2] 연속 판정부 교체
--   기존 "첫 삽입일을 찾기" WHILE + "제거일자 루프" WHILE  두 블록 전체를
--   아래 한 블록으로 대체.  (그 위의 IF OutDate_01='00000000' THEN ... 는 있어도 무방)
--
--   규칙:
--     · 슬롯 1~10 을 순서대로 훑어 (삽입,제거) 세그먼트 구성
--     · 제거 공란(유지중) → 당월 작성일(CmDoc_Date)까지 유지로 간주
--     · 다음 삽입일이 직전 제거일 +1 이내(당일/다음날)면 연속 → 병합
--     · 2일 이상 공백이면 끊고 새 세그먼트
--     · 모든 세그먼트 중 "최대 연속 유지일수(DATEDIFF) >= 14" 이면 'Y'
--
--   ※ 파라미터/전월·당월 조회/window 기산(In_Date_01 세팅) 로직은 그대로 두고,
--     In_Date_01 이 이미 세팅된 상태에서 이 블록이 실행됨.

    BEGIN
        DECLARE seg_ins  DATE DEFAULT NULL;   -- 현재 연속 세그먼트 시작
        DECLARE seg_out  DATE DEFAULT NULL;   -- 현재 연속 세그먼트 끝
        DECLARE max_days INT  DEFAULT 0;      -- 최대 연속 유지일수(DATEDIFF)
        DECLARE k        INT  DEFAULT 1;
        DECLARE v_in     VARCHAR(8);
        DECLARE v_out    VARCHAR(8);
        DECLARE d_in     DATE;
        DECLARE d_out    DATE;

        WHILE k <= 10 DO
            SET v_in = CASE k
                WHEN 1 THEN In_Date_01 WHEN 2 THEN In_Date_02 WHEN 3 THEN In_Date_03
                WHEN 4 THEN In_Date_04 WHEN 5 THEN In_Date_05 WHEN 6 THEN In_Date_06
                WHEN 7 THEN In_Date_07 WHEN 8 THEN In_Date_08 WHEN 9 THEN In_Date_09
                WHEN 10 THEN In_Date_10 END;
            SET v_out = CASE k
                WHEN 1 THEN OutDate_01 WHEN 2 THEN OutDate_02 WHEN 3 THEN OutDate_03
                WHEN 4 THEN OutDate_04 WHEN 5 THEN OutDate_05 WHEN 6 THEN OutDate_06
                WHEN 7 THEN OutDate_07 WHEN 8 THEN OutDate_08 WHEN 9 THEN OutDate_09
                WHEN 10 THEN OutDate_10 END;

            IF v_in <> '00000000' THEN
                -- 제거 공란 = 유지중 → 당월 작성일까지
                IF v_out = '00000000' THEN SET v_out = CmDoc_Date; END IF;
                SET d_in  = STR_TO_DATE(v_in,  '%Y%m%d');
                SET d_out = STR_TO_DATE(v_out, '%Y%m%d');

                IF seg_ins IS NULL THEN
                    SET seg_ins = d_in;  SET seg_out = d_out;
                ELSEIF DATEDIFF(d_in, seg_out) <= 1 THEN
                    -- 당일/다음날 재삽입 = 연속 → 병합(끝 확장)
                    IF d_out > seg_out THEN SET seg_out = d_out; END IF;
                ELSE
                    -- 2일 이상 공백 = 끊김 → 직전 세그먼트 확정 후 새 구간
                    IF DATEDIFF(seg_out, seg_ins) > max_days THEN
                        SET max_days = DATEDIFF(seg_out, seg_ins);
                    END IF;
                    SET seg_ins = d_in;  SET seg_out = d_out;
                END IF;
            END IF;

            SET k = k + 1;
        END WHILE;

        -- 마지막 세그먼트 반영
        IF seg_ins IS NOT NULL AND DATEDIFF(seg_out, seg_ins) > max_days THEN
            SET max_days = DATEDIFF(seg_out, seg_ins);
        END IF;

        -- 14일 초과(기존 임계값 유지: DATEDIFF >= 14)
        IF max_days >= 14 THEN
            SET Return_Val = 'Y';
        END IF;
    END;


-- ─────────────────────────────────────────────────────────────────────
-- [검증 대상자]  2026-06 진단 결과 기준 (수정 후 기대값)
--   A. 'Y' 유지(정당 14일 초과, 단일 연속>14):
--      권순금 김흥순 이광례 서정자 유옥연 이효성 박순자 김복녀 오연호 한명욱
--   B. 'N' 로 바뀌어야(연속 끊김, 최대연속<=13):
--      정양원 박영희 박규태 이숙재 허옥순 순금자 강경옥 진일규
--
-- [참고] '무조건 대상' 분기(전월·당월 삽입/제거 모두 공란 + INDWELL_CATH='1' → 'Y')와
--        window 기산(전월1일/전월작성일+1/전월 마지막삽입일)은 업무규칙이라 유지.
--        만약 오집계가 위 연속 케이스가 아니라 '삽입일자 공란' 환자에서 난다면,
--        그 분기의 시작일 기산을 함께 재검토해야 함(데이터 확인 필요).
