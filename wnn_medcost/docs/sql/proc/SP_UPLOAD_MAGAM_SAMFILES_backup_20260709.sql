-- SP_UPLOAD_MAGAM_SAMFILES 운영본 백업 (2026-07-09, 최적화 작업 전 원본)
-- 복원 시: DROP PROCEDURE IF EXISTS SP_UPLOAD_MAGAM_SAMFILES; 후 아래를 DELIMITER $$ 로 감싸 실행
DELIMITER $$
CREATE DEFINER=`winner`@`%` PROCEDURE `SP_UPLOAD_MAGAM_SAMFILES`(
	IN `hosp_cd` VARCHAR(8),
	IN `mg_year` VARCHAR(4),
	IN `mgmonth` VARCHAR(2),
	IN `mg_flag` VARCHAR(1),
	IN `jobs_dt` VARCHAR(50),
	IN `reg_user` VARCHAR(50),
	IN `t_lines` INT,
	OUT `errcode` VARCHAR(5),
	OUT `errmess` VARCHAR(4000)
)
BEGIN

    DECLARE lineval      VARCHAR(4000) DEFAULT '';
    DECLARE valsize      INT DEFAULT 0;
    DECLARE prev_valsize INT DEFAULT 0;
    DECLARE sam_ver      VARCHAR(10) DEFAULT '';
    DECLARE version      VARCHAR(10) DEFAULT '';
    DECLARE tblinfo      VARCHAR(50) DEFAULT '';
    DECLARE prev_tblinfo VARCHAR(50) DEFAULT '';
    DECLARE file_nm      VARCHAR(100) DEFAULT '';
    DECLARE prev_file_nm VARCHAR(100) DEFAULT '';
    DECLARE table_column  TEXT DEFAULT '';
    DECLARE table_update TEXT DEFAULT '';
    DECLARE col_list     VARCHAR(4000) DEFAULT ''; 
    DECLARE val_list     VARCHAR(4000) DEFAULT '';  
    DECLARE select_stmt  LONGTEXT DEFAULT '';
    DECLARE iuds_sql_nm  LONGTEXT DEFAULT '';
    DECLARE max_insert_length INT DEFAULT 10000000;
	 DECLARE nextjobstmt  INT DEFAULT 0;
    DECLARE col_name     VARCHAR(50) DEFAULT '';
    DECLARE col_value    VARCHAR(4000) DEFAULT '';
    DECLARE dat_done     INT DEFAULT 0;
    DECLARE col_done     INT DEFAULT 0;
    DECLARE next_pos     INT DEFAULT 0;
    DECLARE dmal_pos     INT DEFAULT 0;
    DECLARE data_type    VARCHAR(20) DEFAULT '';
    DECLARE claim_no     VARCHAR(20) DEFAULT '';
    DECLARE clform_ver   VARCHAR(10) DEFAULT '';
    DECLARE claim_type   VARCHAR(10) DEFAULT '';
    DECLARE treat_type   VARCHAR(10) DEFAULT '';
    DECLARE date_ym      VARCHAR(10) DEFAULT '';
    DECLARE case_cnt     INT DEFAULT 0;
    DECLARE tot_amt      INT DEFAULT 0;
    DECLARE claim_amt    INT DEFAULT 0;
    DECLARE chung_seq    INT DEFAULT 0;
    DECLARE total_cnt    INT DEFAULT 0;
    DECLARE exitmsg      VARCHAR(255) DEFAULT '';
    DECLARE jobssam      VARCHAR(10) DEFAULT '';
    DECLARE jobsver      VARCHAR(10) DEFAULT '';

    DECLARE file_change  VARCHAR(1) DEFAULT 'Y';
    
    DECLARE samfver_cnt  INT DEFAULT 0;


--  샘파일 오류정리  

-- 삭제 START 20260626
--    DECLARE col_cursor CURSOR FOR
--     SELECT a.DB_COLNM,
--            CONVERT(
--                SUBSTRING(
--                    CAST(CONVERT(REPLACE(REPLACE(lineval, CHAR(13), ''), CHAR(10), '') USING euckr) AS BINARY),
--                    a.START_POS,
--                    a.COL_SIZE
--                ) USING euckr
--            )                       AS col_value,
--            0                       AS next_pos,
--            a.DATA_TYPE,
--            a.DECIMAL_POS
-- 
--           FROM TBL_SAMFVER_MST a
--          WHERE a.SAMVER  = sam_ver
--            AND a.TBLINFO = tblinfo
--            AND a.VERSION = version
--            AND a.DATAPROC_YN = 'Y'
--          ORDER BY a.START_POS  ;
-- 삭제 END 20260626

--  샘파일 오류정리 
-- START 20260626 
    DECLARE col_cursor CURSOR FOR
    SELECT a.DB_COLNM,
           CONVERT(
               CASE WHEN a.START_POS = MAX(a.START_POS) OVER ()
                    THEN SUBSTRING(
                            CAST(CONVERT(REPLACE(REPLACE(lineval, CHAR(13), ''), CHAR(10), '') USING euckr) AS BINARY),
                            a.START_POS )
                    ELSE SUBSTRING(
                            CAST(CONVERT(REPLACE(REPLACE(lineval, CHAR(13), ''), CHAR(10), '') USING euckr) AS BINARY),
                            a.START_POS, a.COL_SIZE )
               END USING euckr
           )                       AS col_value,
           0                       AS next_pos,
           a.DATA_TYPE,
           a.DECIMAL_POS
          FROM TBL_SAMFVER_MST a
         WHERE a.SAMVER  = sam_ver
           AND a.TBLINFO = tblinfo
           AND a.VERSION = version
           AND a.DATAPROC_YN = 'Y'
         ORDER BY a.START_POS  ;
-- END   20260626 

--  요양기관 특정내역 길이가 제각각 → 공통함수 호출 START
    DECLARE dat_cursor CURSOR FOR
        SELECT fn_PadLineVal(hosp_cd, b.file_nm, b.lineval)  AS lineval
             , fn_GetValSize(hosp_cd, b.file_nm, b.lineval)  AS valsize
             , b.file_nm
          FROM TBL_FILES_DATA b
         WHERE b.HOSP_CD = hosp_cd
           AND b.MG_YEAR = mg_year
           AND b.MGMONTH = mgmonth
           AND b.MG_FLAG = mg_flag
           AND b.JOBS_DT = jobs_dt
         ORDER BY b.file_nm
                , CASE WHEN b.LINE_NO = 1 THEN 0 ELSE 1 END
                , fn_GetValSize(hosp_cd, b.file_nm, b.lineval) DESC;
--  요양기관 길이가 제각각 END

	DECLARE CONTINUE HANDLER FOR NOT FOUND
    BEGIN
        IF  col_done = 0 THEN
            SET col_done = 1;
        ELSE 
            SET dat_done = 1;    
        END IF;
    END;

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
	    DECLARE errstat VARCHAR(5);
	    DECLARE errtext VARCHAR(1000);
	
	    GET DIAGNOSTICS CONDITION 1
	        errstat = RETURNED_SQLSTATE,
	        errtext = MESSAGE_TEXT;
	
	    SET errcode = IFNULL(errstat,'45000');
	    SET errmess = CONCAT(
	        IFNULL(errstat,'SQLSTATE 없음'), ' - ', IFNULL(errtext,'MESSAGE 없음'),
	        ' | file=',    IFNULL(file_nm,''),
	        ', valsize=',  IFNULL(valsize,0),
	        ', tblinfo=',  IFNULL(tblinfo,''),
	        ', line=',     LEFT(IFNULL(lineval,''), 60),
	        ' || stage=',  IFNULL(@dbg,'(none)'),          -- 향후 디버깅용
	        ', colVal=',   LEFT(IFNULL(col_value,''),60),  -- 향후 디버깅용
	        ', lastSQL=',  LEFT(IFNULL(@sql_val,'(none)'),3500)
	    );

	    ROLLBACK;
	  --  RESIGNAL; -- ★ 임시: 진짜 오류 노출 (확인 후 제거)
	END;

    START TRANSACTION;

    SET iuds_sql_nm = '';
    SET select_stmt = '';
    SET nextjobstmt = 0;
    SET chung_seq   = 0;
    SET errcode     = '';
    SET errmess     = '';


    -- SET SESSION group_concat_max_len = 1048576;
    SET SESSION group_concat_max_len = 102400;
    
    OPEN dat_cursor;
    dat_loop: LOOP
        FETCH dat_cursor INTO lineval, valsize, file_nm;
        
        IF dat_done = 1 THEN
            LEAVE dat_loop;
        END IF;
        
        SET @dbg = CONCAT('fetched file=', IFNULL(file_nm,''), ' valsize=', IFNULL(valsize,0));
        
        
        SET total_cnt = total_cnt + 1;
 
	         
        IF valsize < 9 THEN 
           ITERATE dat_loop;
        END IF;
        
		SET chung_seq = chung_seq + 1;

		IF (file_nm != prev_file_nm) OR (valsize != prev_valsize) THEN
        	SET chung_seq = 1;
        	SET jobssam   = (CASE WHEN UPPER(SUBSTRING_INDEX(file_nm, '.', -1)) IN ('GHP','B00','B01','C00','C01','B60','B61','C60','C61') THEN 'GHP'
             			    	  WHEN UPPER(SUBSTRING_INDEX(file_nm, '.', -1)) IN ('CAR')              THEN 'CAR'
             				      WHEN UPPER(SUBSTRING_INDEX(file_nm, '.', -1)) IN ('L32','CXX','L01','L02','L03','L04','L05','L06','L07','L08','L09'
             				                                                       ,'L10','L11','L12','L13','L14','L15','L16','L17','L18','L19','L20') THEN 'REP'
             				      ELSE UPPER(file_nm) END);
             				      
			IF (file_nm != prev_file_nm) THEN
   			
        		SET prev_file_nm = file_nm;
        		SET prev_valsize = 0;
        		SET prev_tblinfo = '';
        		SET file_change  = 'Y';
        		IF (file_nm != jobssam) THEN
        			SET jobsver = '';
        		END IF;
           		
        	    IF (mg_flag = '9') THEN
        	    
        	      SET sam_ver    = jobssam;
        	      SET jobsver    = LEFT(lineval, 3);
        	      SET version    = jobsver;
				   SET tblinfo    = 'TBL_PATVAL_MST';
				   SET clform_ver = jobsver;
					SET claim_no   = jobs_dt;
				    -- ============================================================
				    -- [추가] 환자평가표(mg_flag='9') 버전 검증
				    -- TBL_SAMFVER_MST 에 (SAMVER, TBLINFO, VERSION) 조합이 없으면 오류 처리
				    -- ============================================================
				    
				    SET samfver_cnt = 0 ;
 				    
 				    SELECT COUNT(*) INTO samfver_cnt
 				          FROM TBL_SAMFVER_MST a
				         WHERE a.SAMVER  = sam_ver
				           AND a.TBLINFO = tblinfo
				           AND a.VERSION = version ;
                 IF  samfver_cnt = 0  THEN
        	            SET errcode  = '40000' ;
        	            SET errmess  = CONCAT(jobssam, ' - ',  tblinfo ,' - ' , VERSION,' - ' , samfver_cnt , ' -' ,  ' 환자평가표 버전및 평가표자료인지 확인하세요.');
        	            SET dat_done = 1;
        	            ROLLBACK;
        	            LEAVE dat_loop;
        	        END IF;

				    -- ============================================================
				    -- [추가 끝]
				    -- ============================================================					
					/*
					SET claim_no = ( SELECT IFNULL(MIN(c.CLAIM_NO), '')
									   FROM TBL_MAGAM_CHUNG c
								      WHERE c.HOSP_CD = hosp_cd
								        AND c.MG_YEAR = mg_year
								        AND c.MGMONTH = mgmonth
								        AND c.MG_FLAG = mg_flag
								        AND RIGHT(c.CLAIM_NO,3) = version );
					*/			        
					SET case_cnt = ( SELECT IFNULL(MAX(d.LINE_NO), 0)
					                   FROM TBL_FILES_DATA d
					                  WHERE d.HOSP_CD = hosp_cd
				                        AND d.MG_YEAR = mg_year
				                        AND d.MGMONTH = mgmonth
				                        AND d.MG_FLAG = mg_flag
				                        AND d.JOBS_DT = jobs_dt
				                        AND d.FILE_NM = file_nm );
			    END IF;
			END IF;
        	IF (valsize != prev_valsize) OR (tblinfo != prev_tblinfo) THEN
        		SET prev_valsize = valsize;
        	

        		IF (mg_flag = '8') THEN
        			SET sam_ver    = '';
        	      SET version    = '';
				   SET tblinfo    = '';

					IF hosp_cd = '37282441' THEN  -- 바른요양병원
						IF jobssam = 'GHP' THEN 
					        IF LEFT(lineval, 3) = '090' THEN
					            SET valsize = 2096;
					            
					        ELSEIF LENGTH(lineval) >= 16 THEN
					            SET valsize = 
					                CASE SUBSTRING(lineval, 16, 1)
					                    WHEN 'A' THEN 348
					                    WHEN 'B' THEN 78
					                    WHEN 'C' THEN 234
					                    WHEN 'D' THEN 63
					                    WHEN 'E' THEN 739
					                    ELSE valsize 
					                END;
					        END IF;
					    END IF;    
					ELSE 
						IF hosp_cd IN('38282682')   THEN  -- 울산효원 

						    IF jobssam = 'GHP' THEN 
						        IF LEFT(lineval, 3) = '091' THEN
						            SET valsize = 2096;
						            
						        ELSEIF LENGTH(lineval) >= 16 THEN

						            SET valsize = 
						                CASE SUBSTRING(lineval, 16, 1)
						                    WHEN 'A' THEN 348
						                    WHEN 'B' THEN 78
						                    WHEN 'C' THEN 236
						                    WHEN 'D' THEN 63
						                    WHEN 'E' THEN 739 
						                    ELSE valsize 
						                END;
						        END IF;

						    ELSE
						        IF LEFT(lineval, 3) = '091' THEN
						            SET valsize = 2096;
						        ELSE
						            SET valsize = valsize + 1;
						        END IF;
						    END IF;
							    
						ELSEIF  hosp_cd = '12280011' AND jobssam = 'M020.3' THEN  -- 새미래요양병원 
						        SET valsize = 186;
						ELSE
	
						    IF jobssam = 'GHP' AND valsize IN (46, 204, 202, 346) THEN
						        IF valsize = 346 THEN 
						            SET valsize = valsize + 1750;
						        ELSE 
						            SET valsize = valsize + 32;
						        END IF;
						    END IF;
	
						END IF;
					
					END IF;

               SET @dbg = 'resolve samfver (SELECT INTO)';
-- 삭제  START 20260626               
--         			SELECT f.sam_ver, f.tblinfo, f.version
-- 				      INTO   sam_ver,   tblinfo,   version
-- 				      FROM ( SELECT e.samver AS sam_ver,
-- 				                    e.tblinfo,
-- 				                    e.version,
-- 				                    SUM(CASE WHEN e.db_comcolnm = 'X' THEN 0 ELSE e.col_size END) AS colsize
-- 					           FROM TBL_SAMFVER_MST e
-- 					          GROUP BY e.samver, e.tblinfo, e.version ) f
-- 				     WHERE f.version = CASE WHEN jobsver = '' THEN LEFT(lineval, 3) ELSE jobsver END
-- 				       AND f.colsize = valsize
-- 				       AND f.sam_ver = jobssam
-- 				    LIMIT 1;
-- 				    
-- 				    SET jobsver = version;
-- 삭제  END 20260626

-- 교체 START 20260626   				    
        			SET @ver  := CASE WHEN jobsver = '' THEN LEFT(lineval,3) ELSE jobsver END;
        			SET @disc := SUBSTRING(lineval, 16, 1);
        			SET sam_ver=''; SET tblinfo=''; SET version='';

        			IF jobssam IN ('GHP','CAR') THEN
        			    IF @disc IN ('A','B','C','D','E') THEN
        			        SET tblinfo = CASE @disc
        			                        WHEN 'A' THEN 'TBL_MYOUNG_MST'
        			                        WHEN 'B' THEN 'TBL_DISEASE_MST'
        			                        WHEN 'C' THEN 'TBL_JINORD_MST'
        			                        WHEN 'D' THEN 'TBL_JINOUT_MST'
        			                        WHEN 'E' THEN 'TBL_SPECODE_MST' END;
        			        SET version = @ver;
        			    ELSE
        			        SET tblinfo = 'TBL_CHUNG_MST';
        			        SET version = LEFT(lineval,3);
        			        SET jobsver = version;
        			    END IF;
        			    SET sam_ver = jobssam;
        			    IF NOT EXISTS (SELECT 1 FROM TBL_SAMFVER_MST e
        			                    WHERE e.samver=sam_ver AND e.tblinfo=tblinfo AND e.version=version) THEN
        			        SET tblinfo='';
        			    END IF;

        			ELSEIF jobssam = 'REP' THEN
        			    /* ── REP: 기존 로직 그대로 (정확 길이매칭) ── */
        			    SELECT f.sam_ver, f.tblinfo, f.version
        			      INTO   sam_ver,   tblinfo,   version
        			      FROM ( SELECT e.samver AS sam_ver,
        			                    e.tblinfo,
        			                    e.version,
        			                    SUM(CASE WHEN e.db_comcolnm = 'X' THEN 0 ELSE e.col_size END) AS colsize
        			               FROM TBL_SAMFVER_MST e
        			              GROUP BY e.samver, e.tblinfo, e.version ) f
        			     WHERE f.version = CASE WHEN jobsver = '' THEN LEFT(lineval, 3) ELSE jobsver END
        			       AND f.colsize = valsize
        			       AND f.sam_ver = jobssam
        			     LIMIT 1;

        			ELSE
        			    /* ── 유형 B·C: SAMVER=파일명 → 테이블 1개 → valsize 무시 ── */
        			    SELECT e.samver, MIN(e.tblinfo), e.version
        			      INTO sam_ver,  tblinfo,        version
        			      FROM TBL_SAMFVER_MST e
        			     WHERE e.samver = jobssam
        			       AND e.version = @ver
        			     GROUP BY e.samver, e.version
        			     LIMIT 1;
        			END IF;

        			SET jobsver = version;
-- 교체 END 20260626

        		END IF;
        		
        		SET table_column = (SELECT GROUP_CONCAT(COLUMN_NAME) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = tblinfo);

        	END IF;

        END IF;
        
        IF (version IS NULL OR version = '') THEN
        	
        	SET errcode = '40000';
	    	SET errmess = CONCAT(jobssam, ' - ', CASE WHEN jobsver = '' THEN LEFT(lineval, 3) ELSE jobsver END, ' 버전이 누락 되어 있습니다. 담당자에게 등록요청 바랍니다. !!');
	    	SET dat_done = 1;
	    	ROLLBACK;
	    	
        END IF;
        IF (tblinfo IS NOT NULL) THEN
	        SET col_list = '';
			SET val_list = '';
			IF (mg_flag = '9') THEN
		        SET col_list = 'CHUNGSEQ,';
		        SET val_list = CONCAT("'", jobs_dt, "',");
		    ELSE
		        SET col_list = 'CHUNGSEQ,JOBS_DT,';
		        SET val_list = CONCAT("'", chung_seq, "',","'", jobs_dt, "',");
	        END IF;

         SET @dbg = CONCAT('before col_cursor tbl=', IFNULL(tblinfo,''));
			OPEN col_cursor;
			SET col_done = 0;
			col_loop_insert: LOOP
			    SET @adjustment := 0;
			    
-- 			    FETCH col_cursor INTO col_name, col_value, next_pos, data_type, dmal_pos;
-- 			    IF col_done = 1 THEN
-- 			        LEAVE col_loop_insert;
-- 			    END IF;

-- START 20260626  			    
			    FETCH col_cursor INTO col_name, col_value, next_pos, data_type, dmal_pos;
			    IF col_done = 1 THEN
			        LEAVE col_loop_insert;
			    END IF;
			    SET col_value = REPLACE(REPLACE(col_value, ';', ''), '''', '');	
			    
-- END   20260626  				 		    
             SET @dbg = CONCAT('col=', IFNULL(col_name,''), ' type=', IFNULL(data_type,''), ' pos=', IFNULL(@adjustment,0));
             
			    IF FIND_IN_SET(col_name, table_column) > 0 THEN
			        SET col_list = CONCAT(col_list, col_name, ',');
			        IF col_value IS NULL OR TRIM(col_value) = '' THEN
			            IF data_type = 'VARCHAR' THEN
			                SET val_list = CONCAT(val_list, "''", ',');
			            ELSE
			                SET val_list = CONCAT(val_list, "'0'", ',');
			            END IF;
			        ELSE
			            /*
			            IF IFNULL(dmal_pos,0) > 0 AND LENGTH(TRIM(col_value)) > IFNULL(dmal_pos,0)  THEN
			                SET val_list = CONCAT(val_list, "'", SUBSTRING(TRIM(col_value), 1, LENGTH(TRIM(col_value)) - dmal_pos), "',");
			            ELSE
			                SET val_list = CONCAT(val_list, "'", TRIM(col_value), "',");
			            END IF;
			            */
			            
			            IF IFNULL(dmal_pos, 0) > 0 THEN
						    SET @col_trim = TRIM(col_value);
						    SET @int_part = SUBSTRING(@col_trim, 1, LENGTH(@col_trim) - dmal_pos);
						    SET @dec_part = RIGHT(@col_trim, dmal_pos);

						    IF  @int_part IS NULL OR @int_part = '' OR CAST(@int_part AS UNSIGNED) = 0 THEN
						        SET val_list = CONCAT(val_list, "'0.", LPAD(@dec_part, dmal_pos, '0'), "',");
						    ELSE
						        SET val_list = CONCAT(val_list, "'", @int_part, ".", LPAD(@dec_part, dmal_pos, '0'), "',");
						    END IF;
						ELSE
						    SET val_list = CONCAT(val_list, "'", TRIM(col_value), "',");
						END IF;
			            
			            
			        END IF;
			        IF TRIM(tblinfo) = 'TBL_CHUNG_MST' THEN

					    IF     TRIM(UPPER(col_name)) = 'CLAIM_NO'   THEN SET claim_no   = TRIM(col_value);
					    ELSEIF TRIM(UPPER(col_name)) = 'CLFORM_VER' THEN SET clform_ver = TRIM(col_value);
					    ELSEIF TRIM(UPPER(col_name)) = 'CLAIM_TYPE' THEN SET claim_type = TRIM(col_value);
					    ELSEIF TRIM(UPPER(col_name)) = 'TREAT_TYPE' THEN SET treat_type = TRIM(col_value);
					    ELSEIF TRIM(UPPER(col_name)) = 'DATE_YM'    THEN SET date_ym    = TRIM(col_value);
					    ELSEIF TRIM(UPPER(col_name)) = 'CASE_CNT'   THEN SET case_cnt   = TRIM(col_value);
					    ELSEIF TRIM(UPPER(col_name)) = 'TOT_AMT'    THEN SET tot_amt    = TRIM(col_value);
					    ELSEIF TRIM(UPPER(col_name)) = 'CLAIM_AMT'  THEN SET claim_amt  = TRIM(col_value);
						END IF;
						
						
						IF  file_nm = 'M010.1' THEN
						
							-- INSERT INTO data_log (log_message) VALUES (CONCAT('M010.1 - 시작', case_cnt,' - ', tot_amt));
							
							-- 초기값 처리
						    IF case_cnt IS NULL OR TRIM(case_cnt) = '' THEN SET case_cnt = 0; END IF;
						    IF tot_amt  IS NULL OR TRIM(tot_amt)  = '' THEN SET tot_amt  = 0; END IF;

						    -- 누적 처리
						    IF TRIM(UPPER(col_name))      IN ('CLAIM_CNT1','CLAIM_CNT2','CLAIM_CNT3','CLAIM_CNT4','CLAIM_CNT5','CLAIM_CNT6') THEN
						        SET case_cnt  = case_cnt + CAST(TRIM(col_value) AS UNSIGNED);
						    ELSEIF TRIM(UPPER(col_name))  IN ('CLAIM_AMT1','CLAIM_AMT2','CLAIM_AMT3','CLAIM_AMT4','CLAIM_AMT5','CLAIM_AMT6') THEN
						        SET tot_amt   = tot_amt  + CAST(TRIM(col_value) AS DECIMAL(18,0));
						        SET claim_amt = tot_amt; 
						    END IF;
						    
						    -- INSERT INTO data_log (log_message) VALUES (CONCAT('M010.1 - 작업', case_cnt,' - ', tot_amt));
						
						END IF;
						
					ELSEIF TRIM(tblinfo) = 'TBL_PATVAL_MST' AND TRIM(UPPER(col_name)) = 'MED_START' THEN
					    SET date_ym = SUBSTRING(TRIM(col_value), 1, 6);
					END IF;
			    END IF;
			END LOOP;
			CLOSE col_cursor;

		    IF (prev_tblinfo != tblinfo) THEN
		    	SET prev_tblinfo = tblinfo;
		      	IF (mg_flag = '9') THEN
		      		-- SET iuds_sql_nm  = CONCAT(iuds_sql_nm, "DELETE FROM ", tblinfo,   " WHERE HOSP_CD = '", hosp_cd , "' AND CHUNGSEQ = IFNULL('", LEFT(claim_no,14), "','0');\n");
		      		-- SET iuds_sql_nm  = CONCAT(iuds_sql_nm, "DELETE FROM TBL_MAGAM_CHUNG WHERE HOSP_CD = '", hosp_cd , "' AND CLAIM_NO = IFNULL('", claim_no, "','0');\n");
			        -- SET claim_no     = CONCAT(jobs_dt,version);
			        SET claim_no = jobs_dt;
			    ELSE
			    	SET iuds_sql_nm  = CONCAT(iuds_sql_nm, "DELETE FROM ", tblinfo,   " WHERE HOSP_CD = '", hosp_cd , "' AND CLAIM_NO = IFNULL('", claim_no, "','0');\n");
				END IF;
	        END IF;

	      	SET col_list = LEFT(col_list, LENGTH(col_list) - 1);
	        SET val_list = IF(RIGHT(val_list, 1) = ',', LEFT(val_list, CHAR_LENGTH(val_list) - 1), val_list);

	        IF FIND_IN_SET('HOSP_CD', col_list) = 0 THEN
			    SET col_list = CONCAT('HOSP_CD,', col_list);
			    SET val_list = CONCAT("'", hosp_cd, "',", val_list);
			END IF;

			SET select_stmt = '';
			IF  TRIM(tblinfo) IN ('TBL_CHUNG_MST','TBL_PATVAL_MST') AND file_change = 'Y' THEN
			    
			    IF  IFNULL(mg_flag,'') = '9' THEN 
			    	SET treat_type = 'Y';
			    END IF;
			    
				SET select_stmt = CONCAT("INSERT INTO TBL_MAGAM_CHUNG (HOSP_CD,MG_YEAR,MGMONTH,MG_FLAG,CLAIM_NO,CLFORM_VER,CLAIM_TYPE,TREAT_TYPE,DATE_YM,CASE_CNT,TOT_AMT,CLAIM_AMT,JOBS_DT,FILE_NM,REG_USER,UPD_USER) VALUES ('",
				                          hosp_cd   , "','", mg_year   , "','", mgmonth   , "','", mg_flag   , "','", claim_no  , "','",
				                          clform_ver, "','", claim_type, "','", treat_type, "','", date_ym   , "','", case_cnt  , "','",
				                          tot_amt   , "','", claim_amt , "','", jobs_dt   , "','", file_nm   , "','", reg_user  , "','", reg_user,"')\n",
										 " ON DUPLICATE KEY UPDATE            ",
										 "    CLFORM_VER = VALUES(CLFORM_VER),",
										 "    CLAIM_TYPE = VALUES(CLAIM_TYPE),",
										 "    TREAT_TYPE = VALUES(TREAT_TYPE),",
										 "    DATE_YM    = VALUES(DATE_YM),   ",
										 "    CASE_CNT   = VALUES(CASE_CNT),  ",
										 "    TOT_AMT    = VALUES(TOT_AMT),   ",
										 "    CLAIM_AMT  = VALUES(CLAIM_AMT), ",
										 "    JOBS_DT    = VALUES(JOBS_DT),   ",
										 "    FILE_NM    = VALUES(FILE_NM),   ",
										 "    UPD_USER   = VALUES(UPD_USER);\n");

				-- INSERT INTO data_log (log_message) VALUES (CONCAT('M010.1 - 종료', case_cnt,' - ', tot_amt));
				
			    IF  TRIM(tblinfo) = 'TBL_PATVAL_MST' THEN
			    	SET file_change = 'N';
				END IF;
				
				SET iuds_sql_nm  = CONCAT(iuds_sql_nm, select_stmt);

			END IF;

	        -- SET iuds_sql_nm = CONCAT(iuds_sql_nm, "INSERT INTO ", tblinfo, " (", col_list, ") VALUES (", val_list, ");\n");
	        
	        IF (mg_flag = '9') THEN
			    SET table_update = (SELECT GROUP_CONCAT(CONCAT(' ', COLUMN_NAME, ' = VALUES(', COLUMN_NAME, ')')SEPARATOR ', ') 
			                          FROM INFORMATION_SCHEMA.COLUMNS 
			                         WHERE TABLE_NAME   = 'TBL_PATVAL_MST'
			                           AND IS_NULLABLE  = 'YES');
			    
			    SET iuds_sql_nm  = CONCAT(iuds_sql_nm, "INSERT INTO ", tblinfo, " (", col_list, ") VALUES (", val_list, ")\n",
				                                       " ON DUPLICATE KEY UPDATE            ", table_update, ";\n");
				                                       				
			ELSE 
	        	SET iuds_sql_nm  = CONCAT(iuds_sql_nm, "INSERT INTO ", tblinfo, " (", col_list, ") VALUES (", val_list, ");\n");
	        END IF;
			
        END IF;
		
		
		IF LENGTH(iuds_sql_nm) > max_insert_length THEN
			SET nextjobstmt = 1;
		
			CALL SP_EXECUTE_DYNAMIC_SQL(iuds_sql_nm);
			
			SET iuds_sql_nm = '';
			
		END IF;
		
    END LOOP;
    
    
    
    IF LENGTH(iuds_sql_nm) > 0 AND errcode != '40000' THEN

        SET select_stmt = CONCAT("INSERT INTO TBL_MAGAM_INFO (HOSP_CD, MG_YEAR, MGMONTH, MG_FLAG, JOBS_DT, REG_USER, UPD_USER) VALUES ('",
		                          hosp_cd, "','", mg_year, "','", mgmonth, "','", mg_flag, "','",jobs_dt, "','",reg_user, "','", reg_user,"')\n",
								 " ON DUPLICATE KEY UPDATE          ",
								 "    JOBS_DT  = VALUES(JOBS_DT),   ",
								 "    REG_USER = VALUES(REG_USER),  ",
								 "    UPD_USER = VALUES(UPD_USER);");

		IF LENGTH(select_stmt) > 0 THEN
    		SET iuds_sql_nm = CONCAT(iuds_sql_nm, select_stmt);
    	END IF;
    	IF total_cnt != t_lines THEN
    		SET errcode = "30000";
    		ROLLBACK;
    	ELSE
    	   SET @dbg = 'before CALL exec (final)';
 
	    	CALL SP_EXECUTE_DYNAMIC_SQL(iuds_sql_nm);
	    	COMMIT;
		END IF;
	END IF;

    CLOSE dat_cursor;

	IF mg_flag = 8 THEN
	   
--	    INSERT INTO data_log (log_message) VALUES (CONCAT('시작 - ', hosp_cd, ' - ', claim_no,' - ', date_ym, ' - ', jobs_dt));
	    
	    UPDATE TBL_MYOUNG_MST mm
		  JOIN ( SELECT c.HOSP_CD     AS com_hosp_cd
		              , c.PAT_ID      AS com_patid
		              , c.BILL_SEQ_NO AS com_billseq
		              , IFNULL(date_ym, CONCAT(mg_year, mgmonth)) AS com_dateym
		           FROM TBL_MYOUNG_MST c
		          WHERE c.HOSP_CD   = hosp_cd
		            AND c.CLAIM_NO  = claim_no
		            AND c.CLAIM_GRP = '1'
		            AND c.JOBS_DT   = jobs_dt
		       ) src ON mm.HOSP_CD  = src.com_hosp_cd
		            AND mm.PAT_ID   = src.com_patid
		            AND mm.BILL_SEQ = src.com_billseq
		            AND IFNULL(mm.BILL_SEQ_NO, '') = ''
		  JOIN TBL_CHUNG_MST cm ON cm.HOSP_CD  = src.com_hosp_cd
		                       AND cm.DATE_YM  = src.com_dateym
		                       AND cm.CLAIM_NO = mm.CLAIM_NO
		   SET mm.DELYN = 'Y';
    /*  보안청구 현재돌리느것을 제외하고 모두 DELYN = 'Y' 보완청구 명일련번호가 같으면  */

			UPDATE TBL_MYOUNG_MST mm
			  JOIN (
			         SELECT c.hosp_cd                                 AS com_hosp_cd
			              , c.pat_id                                  AS com_patid
			              , c.bill_seq                                AS com_billseq
			              , c.bill_seq_no                             AS com_billseq_no
			              , IFNULL(date_ym, CONCAT(mg_year, mgmonth)) AS com_dateym
			              , c.mform_no                                AS com_mform_no
			           FROM TBL_MYOUNG_MST c
			          WHERE c.hosp_cd   = hosp_cd
			            AND c.claim_no  = claim_no
			            AND c.claim_grp = '1'
			            AND c.jobs_dt   = jobs_dt
			       ) src
			    ON mm.hosp_cd                    = src.com_hosp_cd
			   AND mm.pat_id                     = src.com_patid
			   AND mm.mform_no                   = src.com_mform_no
			   AND mm.bill_seq                  <> src.com_billseq
			   AND IFNULL(mm.delyn, '')         <> 'Y'
			   AND mm.claim_grp                  = '1'
			   AND IFNULL(mm.bill_seq_no, '')   <> '' AND IFNULL(src.com_billseq_no, '') <> '' 
			   AND IFNULL(mm.bill_seq_no, '')    = IFNULL(src.com_billseq_no, '')
			  JOIN TBL_CHUNG_MST cm
			    ON cm.hosp_cd  = src.com_hosp_cd
			   AND cm.date_ym  = src.com_dateym
			   AND cm.claim_no = mm.claim_no
			   SET mm.delyn = 'Y';
			   
	 /* 보안청구 현재돌리느것을 제외하고 모두 DELYN = 'Y' 보완청구 명일련번호가 같으면  */		   
    END IF;
END
$$
DELIMITER ;
