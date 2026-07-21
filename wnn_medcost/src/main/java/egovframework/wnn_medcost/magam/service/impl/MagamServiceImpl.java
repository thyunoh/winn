package egovframework.wnn_medcost.magam.service.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Collections;

import javax.annotation.Resource;
import javax.sql.DataSource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.google.gson.Gson;

import egovframework.wnn_medcost.magam.mapper.MagamMapper;
import egovframework.wnn_medcost.magam.model.MagamDTO;
import egovframework.wnn_medcost.magam.model.FilesDTO;
import egovframework.wnn_medcost.magam.model.IpwonDTO;
import egovframework.wnn_medcost.magam.model.SpcsugaDTO;
import egovframework.wnn_medcost.magam.model.IndiDTO;
import egovframework.wnn_medcost.magam.model.PatvalDTO;

import egovframework.wnn_medcost.magam.service.MagamService;
import egovframework.wnn_medcost.total.model.TotalDTO;




@Service("MagamService")
public class MagamServiceImpl implements MagamService {

	private static final Logger LOGGER = LoggerFactory.getLogger(MagamServiceImpl.class);
	
	@Autowired
	private MagamMapper mapper;

	@Autowired
	private DataSource dataSource;

	private JdbcTemplate jdbcTemplate;

	// TBL_FILES_DATA 대량 적재 — JDBC 배치(1000행 단위, rewriteBatchedStatements 로 multi-row 변환).
	// 기존 MyBatis foreach 는 수만 행이면 한 문장 생성/전송이 수 분 걸려 대형 파일 업로드가 90000 으로 실패.
	// 한 커넥션에서 마지막에 commit 하므로 기존(단일 문장)과 동일하게 전체 성공/전체 취소가 보장됨.
	private int insertFilesDataBatch(List<FilesDTO> filesData) throws Exception {
		final String sql = "INSERT INTO TBL_FILES_DATA "
				+ "(HOSP_CD, MG_YEAR, MGMONTH, MG_FLAG, JOBS_DT, FILE_NM, LINE_NO, LINEVAL, CHUNGGU, REG_DTTM, REG_USER, REG_IP) "
				+ "VALUES (?,?,?,?,?,?,?,?,?,NOW(),?,?)";
		try (Connection conn = dataSource.getConnection()) {
			boolean oldAutoCommit = conn.getAutoCommit();
			conn.setAutoCommit(false);
			try (PreparedStatement ps = conn.prepareStatement(sql)) {
				int inBatch = 0;
				for (FilesDTO dto : filesData) {
					ps.setString(1,  dto.getHosp_cd());
					ps.setString(2,  dto.getMg_year());
					ps.setString(3,  dto.getMgmonth());
					ps.setString(4,  dto.getMg_flag());
					ps.setString(5,  dto.getJobs_dt());
					ps.setString(6,  dto.getFile_nm());
					ps.setInt(7,     dto.getLine_no());
					ps.setString(8,  dto.getLineval());
					ps.setString(9,  dto.getChunggu());
					ps.setString(10, dto.getReg_user());
					ps.setString(11, dto.getReg_ip());
					ps.addBatch();
					if (++inBatch >= 1000) {
						ps.executeBatch();
						inBatch = 0;
					}
				}
				if (inBatch > 0) {
					ps.executeBatch();
				}
				conn.commit();
			} catch (Exception e) {
				conn.rollback();
				throw e;
			} finally {
				conn.setAutoCommit(oldAutoCommit);
			}
		}
		return filesData.size();   // 예외 없이 commit 되면 전량 INSERT 된 것
	}

	@Override
	public List<MagamDTO> getMagamYearList(MagamDTO dto) throws Exception {

		return mapper.getMagamYearList(dto);
	}
	@Override
	public List<MagamDTO> magamGetFileList(MagamDTO dto) throws Exception {

		return mapper.magamGetFileList(dto);
	}
	
	/*
	@Override
	public void uploadMagamFiles(List<FilesDTO> filesData) {
		
        if (filesData == null || filesData.isEmpty()) {
            throw new IllegalArgumentException("File data cannot be empty.");
        }
        
        for (FilesDTO file : filesData) {
        	mapper.uploadMagamFiles(file);
        }
    }
	*/
	@Override
	public String uploadMagamFilesMain(List<FilesDTO> filesData) {
		
		String err_cd = "0";
		int    counts = 0;
		try {

			// === ACTION_YN='N' SPECODE(특정내역) 코드가 포함된 라인은 TBL_FILES_DATA 저장에서 제외 ===
			List<String> exclCodes = mapper.getSpecodeExclCodes();
			if (exclCodes != null && !exclCodes.isEmpty()) {
				filesData.removeIf(dto -> {
					String lv = dto.getLineval();
					if (lv == null) return false;
					for (String code : exclCodes) {
						if (code != null && !code.isEmpty() && lv.contains(code)) {
							return true; // 제외 대상
						}
					}
					return false;
				});
				// 제외 후 잔여 라인 수로 t_lines 재설정 (insert 건수 == t_lines 검증 정합성 유지)
				int newTotal = filesData.size();
				for (FilesDTO f : filesData) {
					f.setT_lines(newTotal);
				}
				System.out.println("SPECODE(ACTION_YN='N') 제외 후 라인 수 : " + newTotal);
			}

			if (filesData.isEmpty()) {
				System.out.println("저장할 파일 데이터가 없습니다(전량 제외).");
				return "0";
			}

			FilesDTO firstData = filesData.get(0);
        	
            MagamDTO magamDTO = new MagamDTO();
        
            System.out.println("파일업로드 서비스 시작 - 0 : " + firstData.getT_lines());

            counts = insertFilesDataBatch(filesData);   // 기존 mapper.uploadMagamFilesMain(foreach 단일문장) → JDBC 배치 (2026-07-09)

            System.out.println("파일업로드 서비스 시작 - 1 : " + counts);
    		
			if (counts == firstData.getT_lines()) {
				
				magamDTO.setHosp_cd(firstData.getHosp_cd());
	            magamDTO.setMg_year(firstData.getMg_year());
	            magamDTO.setMgmonth(firstData.getMgmonth());
	            magamDTO.setMg_flag(firstData.getMg_flag());
	            magamDTO.setJobs_dt(firstData.getJobs_dt());
	            magamDTO.setFile_nm(firstData.getFile_nm());
	            magamDTO.setT_lines(firstData.getT_lines());
	            magamDTO.setUpd_user(firstData.getReg_user());
	            magamDTO.setUpd_ip(firstData.getReg_ip());
	            magamDTO.setReg_user(firstData.getReg_user());
	            magamDTO.setReg_ip(firstData.getReg_ip());
	            
	            try {
	            	
	            	mapper.callUploadMagamSamFiles(magamDTO);
	                
	            	/*
	            	if ("8".equals(firstData.getMg_flag())) {
	            		mapper.callUploadMagamSamFiles(magamDTO);
	            	} else {
	            		mapper.callUploadMagamPatFiles(magamDTO);
	            	}
	            	*/	
	            	
	                
	                String errorCode = magamDTO.getErrcode();
	                String errorMess = magamDTO.getErrmess();
	                
	                if (errorCode != null && !errorCode.isEmpty()) {
	                    if ("30000".equals(errorCode)) {
	                        err_cd = errorCode;
	                    } else {
	                        err_cd = errorCode + " - " + errorMess;
	                    }
	                } else {
	                    if (mapper.selectMagamCheck(magamDTO).size() != 1) {
	                        err_cd = "50000";
	                    }
	                }
	            } catch (Exception e) {
	            	err_cd = "90000" + " - " + e.getMessage();
	            }
			} else {
				err_cd = "20000";
			}
			
    		
            /*
            int updateCount = mapper.updateMagamInfo(magamDTO);

            if (updateCount == 0) {
                mapper.insertMagamInfo(magamDTO);
            }
            */
    		
		} catch(Exception e) {							
			e.printStackTrace();
			err_cd = "90000";
		}
		
		System.out.println("파일업로드 서비스 시작 - 9 : " + err_cd);	
		System.out.println("파일업로드 서비스 종료");
		return err_cd;
		
        
    }	
	
	@Override
	public void callUploadMagamFiles(List<FilesDTO> filesData) {
		
		System.out.println("파일업로드 서비스 시작");		
		
		
		// FilesDTO 리스트를 JSON 형식으로 변환
        String filesDataJson = new Gson().toJson(filesData);

        // MyBatis 매퍼를 통해 저장 프로시저 호출
        mapper.callUploadMagamFiles(filesDataJson);
		
        System.out.println("파일업로드 서비스 종료");
    }
	
	@Override
	public void uploadMagamFilesOnest(List<FilesDTO> filesData) {
        
		if (filesData == null || filesData.isEmpty()) {
            throw new IllegalArgumentException("File data cannot be empty.");
        }

        // 단일 SQL로 처리
        StringBuilder sqlBuilder = new StringBuilder();
        sqlBuilder.append("INSERT INTO TBL_FILES_DATA (hosp_cd, mg_year, mgmonth, mg_flag, jobs_dt, file_nm, line_no, lineval, reg_user, upd_user, reg_ip, upd_ip) VALUES ");

        for (int i = 0; i < filesData.size(); i++) {
        	
            FilesDTO dto = filesData.get(i);
            
            sqlBuilder.append(String.format(
                "('%s', '%s', '%s', '%s', '%s', '%s', %d, '%s', '%s', '%s', '%s', '%s', '%s')",
                dto.getHosp_cd(), dto.getMg_year(), dto.getMgmonth(), dto.getMg_flag(),
                dto.getJobs_dt(), dto.getFile_nm(), dto.getLine_no(), dto.getLineval(), dto.getChunggu(),
                dto.getReg_user(),dto.getUpd_user(),dto.getReg_ip(),  dto.getUpd_ip()
            ));
            if (i < filesData.size() - 1) {
                sqlBuilder.append(", ");
            }
        }

        // SQL 실행
        jdbcTemplate.update(sqlBuilder.toString());
    }

    // Batch Insert를 처리하는 메서드
	@Override
    public void uploadMagamFilesBatch(List<FilesDTO> filesData) {
    	
		/*
        if (filesData == null || filesData.isEmpty()) {
            throw new IllegalArgumentException("File data cannot be empty.");
        }
		*/
		
        String sql = "INSERT INTO TBL_FILES_DATA (hosp_cd, mg_year, mgmonth, mg_flag, jobs_dt, file_nm, line_no, lineval, chunggu, reg_user, upd_user, reg_ip, upd_ip) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        // Batch Insert 처리
        jdbcTemplate.batchUpdate(sql, filesData, 1000, (ps, dto) -> {
            ps.setString(1,  dto.getHosp_cd());
            ps.setString(2,  dto.getMg_year());
            ps.setString(3,  dto.getMgmonth());
            ps.setString(4,  dto.getMg_flag());
            ps.setString(5,  dto.getJobs_dt());
            ps.setString(6,  dto.getFile_nm());
            ps.setInt(7,     dto.getLine_no());
            ps.setString(8,  dto.getLineval());
            ps.setString(9,  dto.getChunggu());
            ps.setString(10,  dto.getReg_user());
            ps.setString(11, dto.getUpd_user());
            ps.setString(12, dto.getReg_ip());
            ps.setString(13, dto.getUpd_ip());
        });
    }
	
	@Override
	public String delMagamClaimNo(MagamDTO dto) {
		// 특정수가(0000000001) 삭제 시 TBL_SPCSUGA_INFO 의 해당 월 데이터도 함께 삭제
		if ("Z".equals(dto.getMg_flag()) && "0000000001".equals(dto.getClaim_no())) {
			try {
				SpcsugaDTO sp = new SpcsugaDTO();
				sp.setHosp_cd(dto.getHosp_cd());
				sp.setJobyymm((dto.getMg_year() == null ? "" : dto.getMg_year())
				             + (dto.getMgmonth() == null ? "" : dto.getMgmonth()));
				int delCnt = mapper.deleteSpcsugaInfo(sp);
				System.out.println("특정수가현황 TBL_SPCSUGA_INFO 삭제 결과 - : " + delCnt);
			} catch(Exception e) {
				e.printStackTrace();
			}
		}
		return mapper.delMagamClaimNo(dto);
	}
	
	@Override
	public String updateMagamLock(MagamDTO dto) {
		return mapper.updateMagamLock(dto);
	}
	
	@Override
	public String dashbordMedExpenses(Map<String, Object> params) {
		return mapper.dashbordMedExpenses(params);
	}
	@Override
	public String dashbordINDICATORS(Map<String, Object> params) {
		return mapper.dashbordINDICATORS(params);
	}
	@Override
	public String crtTotalReport(MagamDTO dto) {
		return mapper.crtTotalReport(dto);
	}
	
	@Override
	public List<?> setTotalReport_01(MagamDTO dto) throws Exception {
		return mapper.setTotalReport_01(dto);
	}
	@Override
	public List<?> setTotalReport_02(MagamDTO dto) throws Exception {
		return mapper.setTotalReport_02(dto);
	}
	@Override
	public List<?> setTotalReport_03(MagamDTO dto) throws Exception {
		return mapper.setTotalReport_03(dto);
	}
	@Override
	public List<?> setTotalReport_09(MagamDTO dto) throws Exception {
		return mapper.setTotalReport_09(dto);
	}
	@Override
	public List<?> setTotalReport_11(MagamDTO dto) throws Exception {
		return mapper.setTotalReport_11(dto);
	}
	@Override
	public List<?> setTotalReport_13(MagamDTO dto) throws Exception {
		return mapper.setTotalReport_13(dto);
	}
	@Override
	public String saveGasanMst(MagamDTO dto) {
		return mapper.saveGasanMst(dto);
	}
	
	@Override
	public String saveExcelDatas(List<IpwonDTO> ipwonData) {
		
		String err_cd = "0";
		int    counts = 0;
		
		try {
			
			IpwonDTO firstData = ipwonData.get(0);
        	
			System.out.println("입원현황 hosp_cd - : " + firstData.getHosp_cd());
			System.out.println("입원현황 jobyymm - : " + firstData.getJobyymm());
            
			counts = mapper.deleteIpwonInfo(firstData);
			
			if (counts >= 0){
				
				counts = mapper.insertIpwonInfo(ipwonData);
				
				if (counts < 1 ) { 
					err_cd = "30000"; 
				} else {
					
					System.out.println("입원현황 ipwonData - : " + ipwonData.size());
					
					MagamDTO dto = new MagamDTO();
				    
					dto.setHosp_cd(firstData.getHosp_cd());
					dto.setMg_year(firstData.getJobyymm().substring(0, 4));
					dto.setMgmonth(firstData.getJobyymm().substring(4, 6));
				    dto.setMg_flag("Z");
				    dto.setClaim_no("0000000000");
				    dto.setClform_ver("000");
				    dto.setClaim_type("Z");
				    dto.setTreat_type("Z");
				    dto.setDate_ym(firstData.getJobyymm());
				    dto.setCase_cnt(String.valueOf(ipwonData.size()));
				    dto.setTot_amt("0");
				    dto.setClaim_amt("0");				    
				    dto.setFile_nm(firstData.getFile_nm());
				    dto.setJobs_dt(firstData.getJobs_dt());
				    dto.setReg_user(firstData.getReg_user());
				    
				    mapper.AdmMagamInsert(dto);
				}
				
			} else { err_cd = "20000"; }
                		
		} catch(Exception e) {							
			e.printStackTrace();
			err_cd = "90000";
		}
		
		System.out.println("파일업로드 서비스 시작 - 9 : " + err_cd);	
		System.out.println("파일업로드 서비스 종료");
		
		return err_cd;
		
        
    }	
	@Override
	public String saveSpcsugaDatas(List<SpcsugaDTO> spcsugaData) {

		String err_cd = "0";
		int    counts = 0;

		try {

			SpcsugaDTO firstData = spcsugaData.get(0);

			System.out.println("특정수가현황 hosp_cd - : " + firstData.getHosp_cd());
			System.out.println("특정수가현황 jobyymm - : " + firstData.getJobyymm());

			counts = mapper.deleteSpcsugaInfo(firstData);

			if (counts >= 0) {

				counts = mapper.insertSpcsugaInfo(spcsugaData);

				if (counts < 1) {
					err_cd = "30000";
				} else {
					System.out.println("특정수가현황 spcsugaData - : " + spcsugaData.size());

					// 그리드(magamGetFileList) 표시용 - 입원현황과 동일 패턴
					// claim_no '0000000001'로 입원현황(0000000000)과 구분, 나머지는 동일하게 'Z'
					MagamDTO dto = new MagamDTO();
					dto.setHosp_cd(firstData.getHosp_cd());
					dto.setMg_year(firstData.getJobyymm().substring(0, 4));
					dto.setMgmonth(firstData.getJobyymm().substring(4, 6));
					dto.setMg_flag("Z");
					dto.setClaim_no("0000000001");
					dto.setClform_ver("000");
					dto.setClaim_type("Z");
					dto.setTreat_type("Z");
					dto.setDate_ym(firstData.getJobyymm());
					dto.setCase_cnt(String.valueOf(spcsugaData.size()));
					dto.setTot_amt("0");
					dto.setClaim_amt("0");
					dto.setFile_nm(firstData.getFile_nm());
					dto.setJobs_dt(firstData.getJobs_dt());
					dto.setReg_user(firstData.getReg_user());

					System.out.println("특정수가현황 AdmMagamInsert 전 파라미터 => hosp_cd=" + dto.getHosp_cd()
						+ ", mg_year=" + dto.getMg_year() + ", mgmonth=" + dto.getMgmonth()
						+ ", mg_flag=" + dto.getMg_flag() + ", claim_no=" + dto.getClaim_no()
						+ ", clform_ver=" + dto.getClform_ver() + ", claim_type=" + dto.getClaim_type()
						+ ", treat_type=" + dto.getTreat_type() + ", date_ym=" + dto.getDate_ym()
						+ ", case_cnt=" + dto.getCase_cnt() + ", tot_amt=" + dto.getTot_amt()
						+ ", claim_amt=" + dto.getClaim_amt() + ", file_nm=" + dto.getFile_nm()
						+ ", jobs_dt=" + dto.getJobs_dt() + ", reg_user=" + dto.getReg_user());
					try {
						int admCnt = mapper.AdmMagamInsert(dto);
						System.out.println("특정수가현황 AdmMagamInsert 결과 - : " + admCnt + ", claim_no=0000000001");
					} catch(Exception adex) {
						System.out.println("특정수가현황 AdmMagamInsert 예외 발생: " + adex.getClass().getName() + " - " + adex.getMessage());
						adex.printStackTrace();
						throw adex;
					}
				}

			} else { err_cd = "20000"; }

		} catch(Exception e) {
			e.printStackTrace();
			err_cd = "90000";
		}

		System.out.println("특정수가현황 서비스 종료 : " + err_cd);

		return err_cd;
	}

	@Override
	public String create_Eval_Indi(IndiDTO dto) {
		return mapper.create_Eval_Indi(dto);
	}
	
	@Override
	public List<IndiDTO> select_Eval_Indi(IndiDTO dto) throws Exception {
		return mapper.select_Eval_Indi(dto);
	}

	// ===== 적정성평가 컨설팅 월보고서 =====
	@Override
	public List<Map<String, Object>> selectEvalReportList(Map<String, Object> params) throws Exception {
		return mapper.selectEvalReportList(params);
	}

	@Override
	public List<Map<String, Object>> selectEvalReportHst(Map<String, Object> params) throws Exception {
		return mapper.selectEvalReportHst(params);
	}

	@Override
	public Map<String, Object> selectEvalReportHstOne(Map<String, Object> params) throws Exception {
		return mapper.selectEvalReportHstOne(params);
	}

	@Override
	public Map<String, Object> loadEvalReport(String hospCd, String evalYm) throws Exception {
		Map<String, Object> res = new HashMap<>();
		Map<String, Object> mst = mapper.selectEvalReportMst(hospCd, evalYm);
		res.put("mst", mst);
		// report_seq 는 스칼라 조회로 확정(HashMap 결과의 키 케이싱에 의존하지 않도록)
		Long seq = mapper.selectEvalReportSeq(hospCd, evalYm);
		List<Map<String, Object>> texts = (seq != null) ? mapper.selectEvalReportTexts(seq) : new ArrayList<Map<String, Object>>();
		res.put("texts", texts);
		// 전사 표준문구(TPL) — 화면에서 병원별 TEXT > TPL > 내장 기본값 순으로 적용
		res.put("tpls", mapper.selectEvalReportTpls());
		// 차등제 등록(TBL_GRADE_MST)에서 목표점수/병원등급 조회 → 월보고서 목표값 기본소스로 내려줌
		//   evalYm(YYYYMM) → 년도(YYYY) + 분기(월/3 올림: 1~3=1,4~6=2,7~9=3,10~12=4)
		if (evalYm != null && evalYm.length() == 6) {
			String startYy = evalYm.substring(0, 4);
			int mon = Integer.parseInt(evalYm.substring(4, 6));
			String qterFlag = String.valueOf((mon + 2) / 3);
			Map<String, Object> goal = mapper.selectHospGoalGrade(hospCd, startYy, qterFlag);
			res.put("goal", goal);   // {goalscore, hospgrade} 또는 null(미등록)
		}
		return res;
	}

	@Override
	@Transactional
	public Long saveEvalReport(Map<String, Object> p) throws Exception {
		String hospCd = (String) p.get("hospCd");
		String evalYm = (String) p.get("evalYm");
		Long seq = mapper.selectEvalReportSeq(hospCd, evalYm);
		// ★ 이력용 — MST 를 덮어쓰기 '전'의 목표등급·점수를 확보(이력 열람 시 그 시점 수치 복원에 사용)
		Map<String, Object> prevMst = (seq != null) ? mapper.selectEvalReportMst(hospCd, evalYm) : null;
		if (seq == null) {
			mapper.insertEvalReportMst(p);                 // useGeneratedKeys → p["reportSeq"]
			Object gen = p.get("reportSeq");
			seq = (gen instanceof Number) ? ((Number) gen).longValue() : Long.valueOf(String.valueOf(gen));
		} else {
			p.put("reportSeq", seq);
			mapper.updateEvalReportMst(p);
		}
		// 이력: 덮어쓰기 직전의 편집 문구 전체를 JSON 스냅샷으로 보존 (TBL_EVAL_REPORT_HST, HST_TYPE='TEXT')
		//   ★ 문구가 '실제로 바뀐 경우에만' 기록 — PDF 이력(경로가 달라질 때만 기록)과 동일 기준.
		//     승인(approve)은 내부적으로 saveEvalReport 를 한 번 더 호출하므로, 이 비교가 없으면
		//     방금 저장한 '최종본'이 이력에 그대로 한 줄 더 쌓여 '최종것이 이력에 보이는' 현상이 생긴다.
		//   이력 기록 실패가 저장 자체를 막지 않도록 별도 try (로그만)
		try {
			// 최초 생성(기존 MST 없음)만 이력 제외. 기존 보고서면 '저장분이 없던 상태(전부 자동문구) → 생김' 도 변경이므로 기록.
			boolean existed = (prevMst != null);
			List<Map<String, Object>> prevTexts = existed ? mapper.selectEvalReportTexts(seq) : null;
			// ★ 화면이 보낸 dirty(실제 편집 여부)가 true 일 때만 이력을 남긴다.
			//   HTML 재직렬화 차이로 문자열 비교가 어긋나 '안 바뀐 저장'이 이력을 만들던 문제를 원천 차단.
			//   (구버전 화면 호환 — dirty 가 아예 안 오면 종전처럼 내용 비교로 판단)
			Object dirtyObj = p.get("dirty");
			boolean dirtyKnown = (dirtyObj != null);
			boolean clientDirty = dirtyKnown && Boolean.parseBoolean(String.valueOf(dirtyObj));
			if (existed && (!dirtyKnown || clientDirty)) {
				@SuppressWarnings("unchecked")
				List<Map<String, Object>> newTexts = (p.get("texts") instanceof List)
						? (List<Map<String, Object>>) p.get("texts") : null;
				if (!sameEvalTexts(prevTexts, newTexts)) {          // 내용 동일하면 이력 생략
					// 스냅샷 = 직전 문구 + '__meta'(직전 목표등급·점수). DDL 없이 TEXTS_JSON 안에 함께 보존.
					//   이력 열람 시 화면이 현재 마스터 목표값으로 덮어쓰는 문제를 이 메타로 되돌린다.
					List<Map<String, Object>> snap = new ArrayList<>();
					if (prevTexts != null) snap.addAll(prevTexts);   // 비어 있으면 = 그땐 전부 자동문구였다는 뜻
					if (prevMst != null) {
						Map<String, Object> mv = new HashMap<>();
						mv.put("goalgrade",   prevMst.get("goalgrade"));
						mv.put("goalscore",   prevMst.get("goalscore"));
						mv.put("structscore", prevMst.get("structscore"));
						mv.put("carescore",   prevMst.get("carescore"));
						mv.put("totalscore",  prevMst.get("totalscore"));
						Map<String, Object> meta = new HashMap<>();
						meta.put("sectkey", "__meta");
						meta.put("content", new Gson().toJson(mv));
						snap.add(meta);
					}
					Map<String, Object> h = new HashMap<>();
					h.put("reportSeq", seq);
					h.put("hstType", "TEXT");
					h.put("textsJson", new Gson().toJson(snap));
					h.put("pdfPath", null);
					h.put("regUser", p.get("regUser"));
					mapper.insertEvalReportHst(h);
				}
			}
		} catch (Exception he) {
			LoggerFactory.getLogger(getClass()).error("saveEvalReport history WARN: " + he.getMessage());
		}
		mapper.deleteEvalReportTexts(seq);                 // 전체교체(단일 편집자)
		Object txObj = p.get("texts");
		if (txObj instanceof List) {
			@SuppressWarnings("unchecked")
			List<Map<String, Object>> texts = (List<Map<String, Object>>) txObj;
			if (!texts.isEmpty()) {
				mapper.insertEvalReportTexts(seq, texts, (String) p.get("regUser"));
			}
		}
		return seq;
	}

	/** 편집 문구 동일 여부 — 같으면 이력(HST) 기록을 생략한다.
	 *  DB 조회본은 별칭이 sectkey, 저장 요청본은 sectKey 라 키 표기를 정규화해 비교. */
	private boolean sameEvalTexts(List<Map<String, Object>> prev, List<Map<String, Object>> next) {
		return normalizeEvalTexts(prev).equals(normalizeEvalTexts(next));
	}

	private Map<String, String> normalizeEvalTexts(List<Map<String, Object>> list) {
		Map<String, String> m = new HashMap<>();
		if (list == null) return m;
		for (Map<String, Object> t : list) {
			if (t == null) continue;
			Object k = t.get("sectkey");
			if (k == null) k = t.get("sectKey");
			if (k == null) continue;
			m.put(String.valueOf(k), normContent(t.get("content")));
		}
		return m;
	}

	/** 문구 비교용 정규화 — 저장 왕복 과정에서 생기는 HTML 미세차이(&nbsp;·공백·개행)로
	 *  '변경 없음'이 '변경됨'으로 오판되어 불필요한 이력이 쌓이는 것을 막는다. */
	private String normContent(Object v) {
		if (v == null) return "";
		String s = String.valueOf(v);
		s = s.replace("&nbsp;", " ").replace(' ', ' ');
		s = s.replaceAll("\\s+", " ").trim();
		return s;
	}

	@Override
	@Transactional
	public void approveEvalReport(Map<String, Object> p) throws Exception {
		mapper.approveEvalReportMst(p);
		insertApprovalHst(p, "APPROVE");     // 누가 언제 승인했는지 이력 보존(근거자료)
	}

	@Override
	@Transactional
	public void cancelApproveEvalReport(Map<String, Object> p) throws Exception {
		mapper.cancelApproveEvalReportMst(p);
		insertApprovalHst(p, "CANCEL");      // 승인취소도 이력으로 남김(취소하면 MST 기록은 사라지므로)
	}

	/** 승인/승인취소 이력(TBL_EVAL_REPORT_HST) — 그 시점 목표·점수도 __meta 로 함께 보존.
	 *  이력 기록 실패가 승인 처리 자체를 막지 않도록 예외는 로그만 남긴다. */
	private void insertApprovalHst(Map<String, Object> p, String type) {
		try {
			String hospCd = (String) p.get("hospCd");
			String evalYm = (String) p.get("evalYm");
			Long seq = mapper.selectEvalReportSeq(hospCd, evalYm);
			if (seq == null) return;
			Map<String, Object> mst = mapper.selectEvalReportMst(hospCd, evalYm);
			String textsJson = null;
			if (mst != null) {
				Map<String, Object> mv = new HashMap<>();
				mv.put("goalgrade",   mst.get("goalgrade"));
				mv.put("goalscore",   mst.get("goalscore"));
				mv.put("structscore", mst.get("structscore"));
				mv.put("carescore",   mst.get("carescore"));
				mv.put("totalscore",  mst.get("totalscore"));
				Map<String, Object> meta = new HashMap<>();
				meta.put("sectkey", "__meta");
				meta.put("content", new Gson().toJson(mv));
				List<Map<String, Object>> snap = new ArrayList<>();
				snap.add(meta);
				textsJson = new Gson().toJson(snap);
			}
			Map<String, Object> h = new HashMap<>();
			h.put("reportSeq", seq);
			h.put("hstType", type);                 // APPROVE / CANCEL
			h.put("textsJson", textsJson);
			h.put("pdfPath", null);
			Object who = (p.get("approveUser") != null) ? p.get("approveUser") : p.get("regUser");
			h.put("regUser", who);
			mapper.insertEvalReportHst(h);
		} catch (Exception e) {
			LoggerFactory.getLogger(getClass()).error("approval history WARN: " + e.getMessage());
		}
	}

	@Override
	@Transactional
	public void saveEvalReportPdf(Map<String, Object> p) throws Exception {
		String hospCd = (String) p.get("hospCd");
		String evalYm = (String) p.get("evalYm");
		Long seq = mapper.selectEvalReportSeq(hospCd, evalYm);
		if (seq == null) {
			// 마스터가 아직 없으면 최소 정보로 생성 (PDF 만 먼저 첨부하는 경우) — 직전 첨부가 없으니 이력 없음
			mapper.insertEvalReportMst(p);
		} else {
			// 이력: 교체·해제 직전의 첨부 경로 보존 (TBL_EVAL_REPORT_HST, HST_TYPE='PDF'. 경로가 같으면 생략)
			//   파일 실물은 업로드 시 타임스탬프 파일명이라 덮어써지지 않음 → 이력 경로로 이전 버전 열람 가능
			try {
				String oldPath = mapper.selectEvalReportPdfPath(seq);
				Object np = p.get("pdfPath");
				String newPath = (np == null) ? null : String.valueOf(np);
				if (oldPath != null && !oldPath.trim().isEmpty() && !oldPath.equals(newPath)) {
					Map<String, Object> h = new HashMap<>();
					h.put("reportSeq", seq);
					h.put("hstType", "PDF");
					h.put("textsJson", null);
					h.put("pdfPath", oldPath);
					h.put("regUser", p.get("regUser"));
					mapper.insertEvalReportHst(h);
				}
			} catch (Exception he) {
				LoggerFactory.getLogger(getClass()).error("saveEvalReportPdf history WARN: " + he.getMessage());
			}
		}
		mapper.updateEvalReportPdf(p);
	}

	@Override
	public List<Map<String, Object>> select_EvalProgress(IndiDTO dto) throws Exception {
		return mapper.select_EvalProgress(dto);
	}
	
	@Override
	public List<PatvalDTO> select_CategoryList05(PatvalDTO dto) throws Exception {
		return mapper.select_CategoryList05(dto);
	}

	@Override
	public List<PatvalDTO> select_CategoryList06(PatvalDTO dto) throws Exception {
		return mapper.select_CategoryList06(dto);
	}

	@Override
	public List<PatvalDTO> select_CategoryList07(PatvalDTO dto) throws Exception {
		return mapper.select_CategoryList07(dto);
	}

	@Override
	public List<PatvalDTO> select_DiagRank07(PatvalDTO dto) throws Exception {
		return mapper.select_DiagRank07(dto);
	}

	@Override
	public List<PatvalDTO> select_DiagNames(java.util.Map<String, Object> param) throws Exception {
		return mapper.select_DiagNames(param);
	}

	@Override
	public List<PatvalDTO> select_CategoryList09(PatvalDTO dto) throws Exception {
		return mapper.select_CategoryList09(dto);
	}
	
	@Override
	public List<PatvalDTO> select_CategoryList10(PatvalDTO dto) throws Exception {
		return mapper.select_CategoryList10(dto);
	}
	
	@Override
	public List<PatvalDTO> select_CategoryList11(PatvalDTO dto) throws Exception {
		return mapper.select_CategoryList11(dto);
	}
	
	@Override
	public List<PatvalDTO> select_CategoryList12(PatvalDTO dto) throws Exception {
		return mapper.select_CategoryList12(dto);
	}
	
	@Override
	public List<PatvalDTO> select_CategoryList13(PatvalDTO dto) throws Exception {
		return mapper.select_CategoryList13(dto);
	}
	
	@Override
	public List<PatvalDTO> select_CategoryList14(PatvalDTO dto) throws Exception {
		return mapper.select_CategoryList14(dto);
	}
	
	@Override
	public List<PatvalDTO> select_CathCrossCheck(PatvalDTO dto) throws Exception {
		return mapper.select_CathCrossCheck(dto);
	}

	@Override
	public List<Map<String, Object>> select_CathPatvalByPat(Map<String, Object> params) throws Exception {
		return mapper.select_CathPatvalByPat(params);
	}

	@Override
	public List<Map<String, Object>> select_CathSpcsugaByPat(Map<String, Object> params) throws Exception {
		return mapper.select_CathSpcsugaByPat(params);
	}

	@Override
	public List<PatvalDTO> select_assesCheck00(PatvalDTO dto) throws Exception {
		return mapper.select_assesCheck00(dto);
	}
	
	@Override
	public List<PatvalDTO> select_assesCheck01(PatvalDTO dto) throws Exception {
		return mapper.select_assesCheck01(dto);
	}
	@Override
	public List<PatvalDTO> select_assesCheck02(PatvalDTO dto) throws Exception {
		return mapper.select_assesCheck02(dto);
	}
	@Override
	public List<PatvalDTO> select_assesCheck03(PatvalDTO dto) throws Exception {
		return mapper.select_assesCheck03(dto);
	}
	@Override
	public List<PatvalDTO> select_assesCheck04(PatvalDTO dto) throws Exception {
		return mapper.select_assesCheck04(dto);
	}
	@Override
	public List<PatvalDTO> select_assesCheck05(PatvalDTO dto) throws Exception {
		return mapper.select_assesCheck05(dto);
	}
	@Override
	public List<PatvalDTO> select_assesCheck06(PatvalDTO dto) throws Exception {
		return mapper.select_assesCheck06(dto);
	}
	@Override
	public List<PatvalDTO> select_assesCheck07(PatvalDTO dto) throws Exception {
		return mapper.select_assesCheck07(dto);
	}
	@Override
	public List<PatvalDTO> select_assesCheck99(PatvalDTO dto) throws Exception {
		return mapper.select_assesCheck99(dto);
	}
	@Override
	public List<IndiDTO> select_HospitalMst(IndiDTO dto) throws Exception {
		return mapper.select_HospitalMst(dto);
	}
	@Override
    public List<IndiDTO> select_Hosp_Indi(Map<String, Object> params) {
        List<IndiDTO> result = mapper.select_Hosp_Indi(params);

        // CATE_CD=14 (장기입원) SP_LONGADM_COUNT 호출하여 분모/분자/현황값/결과 교체
        try {
            @SuppressWarnings("unchecked")
            List<String> hospCds = (List<String>) params.get("hospcds");
            String stryymm = (String) params.get("stryymm");
            String endyymm = (String) params.get("endyymm");

            int totalDtor = 0;
            int totalNtor = 0;

            // 각 병원별 SP 호출 후 합산
            for (String hospCd : hospCds) {
                Map<String, Object> spParams = new HashMap<>();
                spParams.put("hosp_cd", hospCd);
                spParams.put("stryymm", stryymm);
                spParams.put("endyymm", endyymm);
                spParams.put("dtorvalue", 0);
                spParams.put("ntorvalue", 0);
                mapper.callLongAdmCount(spParams);
                totalDtor += ((Number) spParams.get("dtorvalue")).intValue();
                totalNtor += ((Number) spParams.get("ntorvalue")).intValue();
            }

            // EVALUATION_INDICATORS_VALUE + fiveZone 계산
            Map<String, Object> evalParams = new HashMap<>();
            evalParams.put("cate_cd", "14");
            evalParams.put("jobyymm", endyymm);
            evalParams.put("stryymm", stryymm);
            evalParams.put("dtorvalue", totalDtor);
            evalParams.put("ntorvalue", totalNtor);
            Map<String, Object> evalResult = mapper.calcEvalIndiValue(evalParams);

            java.math.BigDecimal newCalAvg  = evalResult != null && evalResult.get("cal_avg")  != null ? new java.math.BigDecimal(evalResult.get("cal_avg").toString())  : java.math.BigDecimal.ZERO;
            java.math.BigDecimal newWeigavg = evalResult != null && evalResult.get("weigavg") != null ? new java.math.BigDecimal(evalResult.get("weigavg").toString()) : java.math.BigDecimal.ZERO;
            String newFiveZone = evalResult != null && evalResult.get("fiveZone") != null ? evalResult.get("fiveZone").toString() : "";

            // CATE_CD=14 행 찾아서 값 교체
            java.math.BigDecimal oldWeigavg = java.math.BigDecimal.ZERO;
            for (IndiDTO dto : result) {
                if ("14".equals(dto.getCate_cd())) {
                    oldWeigavg = dto.getWeigavg() != null ? dto.getWeigavg() : java.math.BigDecimal.ZERO;
                    dto.setDtortot(new java.math.BigDecimal(totalNtor));  // dtortot컬럼 → 분자 표시
                    dto.setNtortot(new java.math.BigDecimal(totalDtor));  // ntortot컬럼 → 분모 표시
                    dto.setCal_avg(newCalAvg);
                    dto.setWeigavg(newWeigavg);
                    dto.setFiveZone(newFiveZone);
                    break;
                }
            }

            // 합계(cate_cd=99) 행의 weigavg 재계산
            java.math.BigDecimal diffWeigavg = newWeigavg.subtract(oldWeigavg);
            for (IndiDTO dto : result) {
                if ("99".equals(dto.getCate_cd())) {
                    java.math.BigDecimal sumWeigavg = dto.getWeigavg() != null ? dto.getWeigavg() : java.math.BigDecimal.ZERO;
                    dto.setWeigavg(sumWeigavg.add(diffWeigavg));
                    break;
                }
            }

        } catch (Exception e) {
            System.out.println("SP_LONGADM_COUNT 호출 오류: " + e.getMessage());
            e.printStackTrace();
        }

        return result;
    }

    @Override
    public void callLongAdmCount(Map<String, Object> params) {
        mapper.callLongAdmCount(params);
    }

    @Override
    public Map<String, Object> calcEvalIndiValue(Map<String, Object> params) {
        return mapper.calcEvalIndiValue(params);
    }
	
	@Override
	public List<PatvalDTO> select_PrevMonthMissing05(PatvalDTO dto) {
		return mapper.select_PrevMonthMissing05(dto);
	}

	@Override
	public List<Map<String, Object>> select_ScoreCriteria(IndiDTO dto) {
		return mapper.select_ScoreCriteria(dto);
	}

	@Override
	public Map<String, Object> select_PatvalMst(Map<String, Object> params) {
		return mapper.select_PatvalMst(params);
	}

	@Override
	public Map<String, Object> select_PatvalMstPrev(Map<String, Object> params) {
		return mapper.select_PatvalMstPrev(params);
	}

	@Override
	public List<Map<String, Object>> select_PatvalChangedList(Map<String, Object> params) {
		return mapper.select_PatvalChangedList(params);
	}

	@Override
	public List<MagamDTO> selectAllHospCdList() {
		return mapper.selectAllHospCdList();
	}

	@Override
	public String insGoolgleSheet(MagamDTO dto) {
		return mapper.insGoolgleSheet(dto);
	}
	
	@Override
	public MagamDTO selGoolgleSheet(MagamDTO dto) {
		return mapper.selGoolgleSheet(dto);
	}
	
	@Override
	public String modifyPatval(PatvalDTO dto) {
		return mapper.modifyPatval(dto);
	}

	// ========== 파일 검증 관련 ==========

	@Override
	public String uploadMagamFilesOnly(List<FilesDTO> filesData) {
		String err_cd = "0";
		try {
			FilesDTO firstData = filesData.get(0);
			int counts = insertFilesDataBatch(filesData);   // 기존 mapper.uploadMagamFilesMain(foreach 단일문장) → JDBC 배치 (2026-07-09)

			if (counts != firstData.getT_lines()) {
				err_cd = "20000";
			}
		} catch(Exception e) {
			e.printStackTrace();
			err_cd = "90000";
		}
		return err_cd;
	}

	@Override
	public String execMagamSP(MagamDTO magamDTO) {
		String err_cd = "0";
		try {
			mapper.callUploadMagamSamFiles(magamDTO);

			String errorCode = magamDTO.getErrcode();
			String errorMess = magamDTO.getErrmess();

			if (errorCode != null && !errorCode.isEmpty()) {
				if ("30000".equals(errorCode)) {
					err_cd = errorCode;
				} else {
					err_cd = errorCode + " - " + errorMess;
				}
			} else {
				if (mapper.selectMagamCheck(magamDTO).size() != 1) {
					err_cd = "50000";
				}
			}
		} catch (Exception e) {
			err_cd = "90000" + " - " + e.getMessage();
		}
		return err_cd;
	}

	@Override
	public List<Map<String, Object>> verifyFilesData(MagamDTO dto) throws Exception {
		return mapper.getFilesFirstLine(dto);
	}

	@Override
	public List<Map<String, Object>> getSamfverMatch(Map<String, Object> params) throws Exception {
		return mapper.getSamfverMatch(params);
	}

	@Override
	public List<Map<String, Object>> getSamfverAllTables(Map<String, Object> params) throws Exception {
		return mapper.getSamfverAllTables(params);
	}

	@Override
	public List<Map<String, Object>> getSamfverColumns(Map<String, Object> params) throws Exception {
		return mapper.getSamfverColumns(params);
	}

}