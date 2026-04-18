package egovframework.wnn_medcost.magam.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Collections;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

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
	
	private JdbcTemplate jdbcTemplate;

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
			
			FilesDTO firstData = filesData.get(0);
        	
            MagamDTO magamDTO = new MagamDTO();
        
            System.out.println("파일업로드 서비스 시작 - 0 : " + firstData.getT_lines());	
            
            counts = mapper.uploadMagamFilesMain(filesData);
            
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
	
	@Override
	public List<PatvalDTO> select_CategoryList05(PatvalDTO dto) throws Exception {
		return mapper.select_CategoryList05(dto);
	}
	
	@Override
	public List<PatvalDTO> select_CategoryList07(PatvalDTO dto) throws Exception {
		return mapper.select_CategoryList07(dto);
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
			int counts = mapper.uploadMagamFilesMain(filesData);

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