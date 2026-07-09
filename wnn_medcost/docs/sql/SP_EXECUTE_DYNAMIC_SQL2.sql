-- ============================================================================
-- SP_EXECUTE_DYNAMIC_SQL2 (2026-07-09)
-- SP_EXECUTE_DYNAMIC_SQL 과 동일한 ';' 분할 실행기이나 stmt_text 를 LONGTEXT 로 확장.
-- SP_UPLOAD_MAGAM_SAMFILES 최적화(multi-row INSERT 배치, 문장당 최대 ~2MB)용.
-- 기존 SP_EXECUTE_DYNAMIC_SQL(TEXT, 64KB 한계)은 다른 호출자가 있어 그대로 둠.
-- ============================================================================
DELIMITER $$

DROP PROCEDURE IF EXISTS SP_EXECUTE_DYNAMIC_SQL2 $$

CREATE DEFINER=`winner`@`%` PROCEDURE `SP_EXECUTE_DYNAMIC_SQL2`(
	IN `sql_stmt` LONGTEXT
)
BEGIN
    DECLARE stmt_text LONGTEXT;
    DECLARE stmt_end INT DEFAULT 0;
    DECLARE stmt_start INT DEFAULT 1;

    WHILE stmt_end >= 0 DO

        SET stmt_end = LOCATE(';', sql_stmt, stmt_start);

        IF stmt_end = 0 THEN
            SET stmt_text = SUBSTRING(sql_stmt, stmt_start);
        ELSE
            SET stmt_text = SUBSTRING(sql_stmt, stmt_start, stmt_end - stmt_start);
        END IF;

        -- 공백/개행만 있는 조각은 스킵 (Query was empty 방지 — 원본과 동일 가드)
        IF stmt_text IS NOT NULL AND stmt_text REGEXP '[^[:space:]]' THEN
            SET @sql_val = stmt_text;
            PREPARE stmt FROM @sql_val;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;
        END IF;

        IF stmt_end = 0 THEN
            SET stmt_end = -1;
        ELSE
            SET stmt_start = stmt_end + 1;
        END IF;
    END WHILE;

END $$

DELIMITER ;
