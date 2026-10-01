-- [2026-10-01] FN_ADMIT_CONT — 전월 평가표와 당월 평가표가 「이어지는 입원」인가 ('Y' / 'N')
--   요청(검수 박혜련) : 선한이웃요양병원 박형근(590515) — 2026-08-26 퇴원 → 2026-09-04 재입원(당일·익일 재입원 아님).
--     9월에는 「전월 평가표가 없는 신규 입원환자」인데 전월과 비교하는 지표(유치도뇨관·욕창 처치·욕창 개선·ADL)에 전부 들어가 있었다.
--   원인 : 전월 평가표를 환자ID 로만 이었다(입원일 비교 없음). 05 는 전월 평가표 유무를 아예 안 봤다.
--   규칙(이 함수 하나가 정본 — 목록 select_CategoryList05/09/10/11/12 와 SP_EVALUATION_INDICATORS_CREATE2 가 같이 쓴다) :
--     ① 입원일이 같다                                   → 'Y'
--     ② 당월 입원일 ≤ 전월 평가표 요양개시일             → 'Y'  (전월 평가 때 이미 입원 중 — 병원이 입원일 표기만 달리 적은 경우)
--     ③ 입퇴원현황(TBL_IPWON_INFO)에 당월 입원일의 당일·전일 퇴원 기록이 있다(당일·익일 재입원) → 'Y'
--     그 밖(전월 평가 뒤에 새로 입원 · 당일/익일 재입원 아님 · 또는 입퇴원현황에 퇴원 기록 없음) → 'N'
--   원복 : DROP FUNCTION FN_ADMIT_CONT;  (단, 이 함수를 쓰는 프로시저·매퍼를 먼저 되돌릴 것)
DROP FUNCTION IF EXISTS FN_ADMIT_CONT;
DELIMITER $$
CREATE DEFINER=`winner`@`%` FUNCTION `FN_ADMIT_CONT`(
    p_hosp_cd    VARCHAR(10),
    p_pat_id     VARCHAR(20),
    p_pat_nm     VARCHAR(50),
    p_prev_admit VARCHAR(8),     -- 전월 평가표 입원일
    p_prev_med   VARCHAR(8),     -- 전월 평가표 요양개시일
    p_cur_admit  VARCHAR(8)      -- 당월 평가표 입원일
) RETURNS varchar(1) CHARSET utf8mb4
    READS SQL DATA
    DETERMINISTIC
BEGIN
    DECLARE v_cnt INT DEFAULT 0;

    IF p_prev_admit IS NULL OR p_cur_admit IS NULL THEN
        RETURN 'N';
    END IF;

    /* ① 입원일이 같다 */
    IF p_cur_admit = p_prev_admit THEN
        RETURN 'Y';
    END IF;

    /* ② 전월 평가표의 요양개시일에 이미 (당월 평가표의) 입원 중이었다 */
    IF p_prev_med IS NOT NULL AND p_cur_admit <= p_prev_med THEN
        RETURN 'Y';
    END IF;

    IF p_cur_admit NOT REGEXP '^[0-9]{8}$' THEN
        RETURN 'N';
    END IF;

    /* ③ 당일·익일 재입원 — 입퇴원현황에 「당월 입원일의 당일 또는 전일」 퇴원 기록 */
    SELECT COUNT(*)
      INTO v_cnt
      FROM TBL_IPWON_INFO i
     WHERE i.HOSP_CD = p_hosp_cd
       AND LEFT(i.JUMINNO,6) = LEFT(p_pat_id,6)
       AND REGEXP_REPLACE(i.PATNAME,'[0-9]','') = REGEXP_REPLACE(p_pat_nm,'[0-9]','')
       AND COALESCE(i.TEWONDT,'') <> ''
       AND REPLACE(REPLACE(i.IPWONDT,'-',''),'/','') < p_cur_admit
       AND REPLACE(REPLACE(i.TEWONDT,'-',''),'/','')
           BETWEEN DATE_FORMAT(DATE_SUB(STR_TO_DATE(p_cur_admit,'%Y%m%d'), INTERVAL 1 DAY),'%Y%m%d')
               AND p_cur_admit;

    RETURN IF(v_cnt > 0, 'Y', 'N');
END$$
DELIMITER ;
