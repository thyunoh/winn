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
        return mapper.select_Hosp_Indi(params);
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
	
	
}