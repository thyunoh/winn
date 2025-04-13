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
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import com.google.gson.Gson;

import egovframework.wnn_medcost.magam.mapper.MagamMapper;
import egovframework.wnn_medcost.magam.model.MagamDTO;
import egovframework.wnn_medcost.magam.model.FilesDTO;
import egovframework.wnn_medcost.magam.service.MagamService;




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
	public void uploadMagamFiles(List<FilesDTO> filesData) {
		
		System.out.println("파일업로드 서비스 시작");		
		
		mapper.uploadMagamFiles(filesData);

        if (!filesData.isEmpty()) {
        	
            FilesDTO firstData = filesData.get(0);

            MagamDTO magamDTO = new MagamDTO();
            
            magamDTO.setHosp_cd(firstData.getHosp_cd());
            magamDTO.setMg_year(firstData.getMg_year());
            magamDTO.setMgmonth(firstData.getMgmonth());
            magamDTO.setMg_flag(firstData.getMg_flag());
            magamDTO.setJobs_dt(firstData.getJobs_dt());
            magamDTO.setFile_nm(firstData.getFile_nm());
            magamDTO.setUpd_user(firstData.getReg_user());
            magamDTO.setUpd_ip(firstData.getReg_ip());
            magamDTO.setReg_user(firstData.getReg_user());
            magamDTO.setReg_ip(firstData.getReg_ip());
            
            
            try {
            	mapper.callUploadMagamSamFiles(magamDTO);			
			}catch(Exception e) {							
				e.printStackTrace();
			}
            
            /*
            int updateCount = mapper.updateMagamInfo(magamDTO);

            if (updateCount == 0) {
                mapper.insertMagamInfo(magamDTO);
            }
            */
        }
        
		
        System.out.println("파일업로드 서비스 종료");
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
}