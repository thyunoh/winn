-- =============================================================================
-- fn_GetValSize : 요양기관/파일별 특정내역 라인 길이(valsize) 산출 공통 함수
-- -----------------------------------------------------------------------------
-- 배경
--   파일생성 SP(dat_cursor)에서 TBL_FILES_DATA 의 각 라인을 고정폭으로 패딩하는데,
--   일부 요양기관은 파일별 라인 길이가 제각각이라 RPAD 목표 길이를 하드코딩했다.
--   동일한 CASE 식이 SELECT(lineval) / SELECT(valsize) / ORDER BY 3곳에 중복되어
--   유지보수가 어려웠다. 이 함수 한 곳으로 길이 산출 규칙을 일원화한다.
--
-- 반환값
--   - 요양기관/파일 특례에 해당하면 고정 길이
--   - 그 외에는 라인의 실제 바이트 길이(EUC-KR 기준, 한글 2바이트) - 1
--     == 기존 CAST(((CHAR_LENGTH + (LENGTH-CHAR_LENGTH)/2) - 1) AS UNSIGNED)
--
-- 사용
--   valsize  : fn_GetValSize(hosp_cd, file_nm, lineval)
--   lineval  : RPAD(REPLACE(REPLACE(lineval,'''',''),';',''), fn_GetValSize(...), ' ')
--              (특례 없는 라인은 자기 길이로 RPAD => no-op 이므로 분기 불필요)
--   ORDER BY : fn_GetValSize(hosp_cd, file_nm, lineval) DESC
--
-- 비고 (원본 하드코딩 대비 정정 사항)
--   * ORDER BY 절에 있던 'K020.5' 는 SELECT 절의 'K020.4' 와 불일치(오타)였다.
--     본 함수는 'K020.4' 로 통일한다.
--   * H040.5 주석은 "→739" 였으나 실제 적용값은 738 이었다. 값(738)을 따른다.
-- =============================================================================

DELIMITER $$

DROP FUNCTION IF EXISTS fn_GetValSize $$

CREATE FUNCTION fn_GetValSize(
      p_hosp_cd  VARCHAR(20)
    , p_file_nm  VARCHAR(50)
    , p_lineval  TEXT
)
    RETURNS INT
    DETERMINISTIC
    NO SQL
BEGIN
    -- ── 요양기관별 특정내역 라인 길이 특례 ──────────────────────────────
    -- 청암요양병원
    IF p_hosp_cd = '36282642' THEN
        IF SUBSTRING(p_lineval, 16, 1) = 'E' THEN
            RETURN 739;   -- GHP E (건강/자보 양방 동일)
        ELSEIF p_file_nm = 'K020.4' THEN
            RETURN 725;   -- 건강 한방
        ELSEIF p_file_nm = 'H040.5' THEN
            RETURN 738;   -- 급여 혈액투석
        ELSEIF p_file_nm = 'M020.5' THEN
            RETURN 738;   -- 산재 양방
        ELSEIF p_file_nm = 'M021.4' THEN
            RETURN 725;   -- 산재 한방
        ELSEIF p_file_nm = 'C110.4' THEN
            RETURN 725;   -- 자보 한방
        END IF;
    END IF;

    -- ── 기본: 라인의 실제 바이트 길이(EUC-KR 기준) - 1 ─────────────────
    RETURN CAST(
        ((CHAR_LENGTH(p_lineval) + (LENGTH(p_lineval) - CHAR_LENGTH(p_lineval)) / 2) - 1)
        AS UNSIGNED);
END $$

DELIMITER ;


-- =============================================================================
-- fn_PadLineVal : 출력용 lineval 산출 공통 함수
-- -----------------------------------------------------------------------------
--   - 특례 기관/파일에 해당하면 정리 후 고정폭으로 RPAD
--   - 그 외에는 정리(REPLACE)만 하고 패딩하지 않음  ← 원본 CASE 의 ELSE 동작 유지
--
--   주의) 기본 라인에까지 RPAD 를 걸면 안 된다. RPAD 의 길이는 '문자 수'인데
--         fn_GetValSize 의 기본값은 'EUC-KR 바이트수-1' 이라, 한글 라인은 공백이
--         덧붙고 ASCII 라인은 끝 글자가 잘릴 수 있다. 패딩은 특례 라인에만.
-- =============================================================================

DELIMITER $$

DROP FUNCTION IF EXISTS fn_PadLineVal $$

CREATE FUNCTION fn_PadLineVal(
      p_hosp_cd  VARCHAR(20)
    , p_file_nm  VARCHAR(50)
    , p_lineval  TEXT
)
    RETURNS TEXT
    DETERMINISTIC
    NO SQL
BEGIN
    DECLARE v_clean TEXT;
    SET v_clean = REPLACE(REPLACE(p_lineval, '''', ''), ';', '');

    -- 특례 기관/파일만 고정폭 패딩
    IF p_hosp_cd = '36282642'
       AND ( SUBSTRING(p_lineval, 16, 1) = 'E'
          OR p_file_nm IN ('K020.4', 'H040.5', 'M020.5', 'M021.4', 'C110.4') ) THEN
        RETURN RPAD(v_clean, fn_GetValSize(p_hosp_cd, p_file_nm, p_lineval), ' ');
    END IF;

    -- 그 외: 패딩 없이 정리값 그대로 (원본 ELSE)
    RETURN v_clean;
END $$

DELIMITER ;


-- =============================================================================
-- 리팩터링된 dat_cursor (참고용)
-- =============================================================================
/*
    DECLARE dat_cursor CURSOR FOR
        SELECT fn_PadLineVal(hosp_cd, b.file_nm, b.lineval)       AS lineval
             , fn_GetValSize(hosp_cd, b.file_nm, b.lineval)       AS valsize
             , b.file_nm
          FROM TBL_FILES_DATA b
         WHERE b.HOSP_CD  = hosp_cd
           AND b.MG_YEAR  = mg_year
           AND b.MGMONTH  = mgmonth
           AND b.MG_FLAG  = mg_flag
           AND b.JOBS_DT  = jobs_dt
         ORDER BY b.file_nm
                , CASE WHEN b.LINE_NO = 1 THEN 0 ELSE 1 END
                , fn_GetValSize(hosp_cd, b.file_nm, b.lineval) DESC;
*/
