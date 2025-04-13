package egovframework.wnn_medcost.magam.web;



import java.util.Map;
import java.util.List;
import java.util.HashMap;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;

import javax.annotation.Resource;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.jdbc.core.JdbcTemplate;

import com.fasterxml.jackson.databind.ObjectMapper;

import egovframework.wnn_medcost.magam.model.FilesDTO;
import egovframework.wnn_medcost.magam.model.MagamDTO;
import egovframework.wnn_medcost.magam.service.MagamService;
import egovframework.wnn_medcost.base.model.SugaCdDTO;
import egovframework.wnn_medcost.util.ResponseObject;
import egovframework.util.ClientInfo;
import egovframework.util.EgovFileScrty;

import javax.servlet.annotation.MultipartConfig;


@MultipartConfig
@Controller
public class MagamController {

	private static final Logger log = LoggerFactory.getLogger(MagamController.class);
	private static Map<String, String> cookie_value = new HashMap<>();
	
	@Resource(name = "MagamService") // 서비스 선언
	private MagamService svc;
	
	@RequestMapping(value="main/magamFileUpload.do")
    public String magamFileUpload(HttpServletRequest request, ModelMap model) throws Exception {
		
		cookie_value = ClientInfo.getCookie(request);		
		try {
			if (cookie_value.get("s_hospid").trim() != null &&
				cookie_value.get("s_hospid").trim() != "" ) {
				return ".main/magamFileUpload";				
			} else {
				return "";
			}	
		} catch(Exception ex) {
			return "";
		}
		
		
    }
	
	/* 년별,청구서,평가표 월 마감정보 List */
	@RequestMapping(value="/main/getMagamYearList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getMagamYearList(@ModelAttribute("DTO") MagamDTO dto, HttpSession session, HttpServletRequest request, Model model) throws Exception {
		
		// System.out.println("마감-java 1- start ");		
		
		cookie_value = ClientInfo.getCookie(request);		
		try {
			
			if (cookie_value.get("s_hospid").trim() != null &&
				cookie_value.get("s_hospid").trim() != "" ) {
				
				dto.setHosp_cd(cookie_value.get("s_hospid").trim()); // 요양기관번호
				dto.setMg_year(dto.getMg_year()); // 작업년
				dto.setMg_flag(dto.getMg_flag()); // 마감구분 8.청구서 9.평가서
				
				
				List<MagamDTO> magamYearList = svc.getMagamYearList(dto);
				
				// System.out.println("마감-java     size : " + magamYearList.size());
				
				Map<String, Object> response = new HashMap<>();
		        response.put("data",magamYearList);

		        // System.out.println("마감-java response : " + response);
		        
		        return response;
				
				
			} else {
				return null;
			}	
		} catch(Exception ex) {
			return null;
		}
	}
	

	@RequestMapping(value="/main/magamGetFileList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> magamGetFileList(@ModelAttribute("DTO") MagamDTO dto, HttpSession session, HttpServletRequest request, Model model) throws Exception {
		
		System.out.println("마감-java 2- start ");		
		
		cookie_value = ClientInfo.getCookie(request);		
		try {
			
			if (cookie_value.get("s_hospid").trim() != null &&
				cookie_value.get("s_hospid").trim() != "" ) {
				
				dto.setHosp_cd(cookie_value.get("s_hospid").trim()); // 요양기관번호				
				dto.setMg_year(dto.getMg_year()); // 작업년
				dto.setMgmonth(dto.getMgmonth()); // 작업월
				dto.setMg_flag(dto.getMg_flag()); // 마감구분 8.청구서 9.평가서		
				
				System.out.println("마감-java     getHosp_id : " + cookie_value.get("s_hospid").trim());
				System.out.println("마감-java     getMg_year : " + dto.getMg_year());
				System.out.println("마감-java     getMgmonth : " + dto.getMgmonth());
				System.out.println("마감-java     getMg_flag : " + dto.getMg_flag());
				
				List<MagamDTO> magamFileList = svc.magamGetFileList(dto);
				
				System.out.println("마감-java     size : " + magamFileList.size());
				
				Map<String, Object> response = new HashMap<>();
		        response.put("data",magamFileList);

		        System.out.println("마감-java response : " + response);
		        
		        return response;
				
				
			} else {
				return null;
			}	
		} catch(Exception ex) {
			return null;
		}
	}
	
	
	@RequestMapping(value="/main/uploadMagamFiles.do", method = RequestMethod.POST)	
	public ResponseEntity<String> uploadMagamFiles(@RequestBody List<FilesDTO> filesData) {
        try {
        	
        	System.out.println("파일업로드 시작");
        	
        	// mybits Batch
        	svc.uploadMagamFiles(filesData);
            
        	// mybits Procedule
        	// svc.callUploadMagamFiles(filesData);
        	
            // 데이터 저장 방식 선택 (단일 SQL 또는 Batch)
            // svc.uploadMagamFilesBatch(filesData); // Batch 방식
            // svc.uploadMagamFilesOnest(filesData); // 단일 SQL 방식
            
            
            System.out.println("파일업로드 종료");
            
            return ResponseEntity.ok("File data successfully inserted.");
            
        } catch (Exception e) {
        	
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error occurred while inserting file data.");
        }
    }
	
	/*
	public String  uploadMagamFiles(HttpServletRequest request) {
		
		System.out.println("파일업로드 시작");
        try {
            String mg_Year = request.getParameter("mg_Year");
            String mgMonth = request.getParameter("mgMonth");
            String mg_Flag = request.getParameter("mg_Flag");
            
            System.out.println("Content-Type: " + request.getContentType());
            System.out.println("Parts count:  " + request.getParts().size());
            
            System.out.println("파일업로드 시작1");
            List<FilesDTO> fileDataList = new ArrayList<>();
            System.out.println("파일업로드 시작2");
            LocalDateTime now = LocalDateTime.now();
	        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
	        String jobs_dt = now.format(formatter);
	        
	        System.out.println("파일업로드 시작3");
	        
	        for (Part part : request.getParts()) {
            	System.out.println("파일업로드 시작4");
                String file_Nm = part.getSubmittedFileName();
                
                if (file_Nm != null && !file_Nm.isEmpty()) {
                
	                int    file_No = 0;
	                System.out.println("파일업로드 시작5");
	                
	                try (BufferedReader reader = new BufferedReader(new InputStreamReader(part.getInputStream()))) {
	                    String line;
	                    while ((line = reader.readLine()) != null) {
	                    	
	                    	System.out.println("파일업로드 시작5-1");
	                    	
	                        FilesDTO dto = new FilesDTO();
	                        
	                        System.out.println("파일업로드 시작5-2");
	                        dto.setHosp_cd(cookie_value.getOrDefault("s_hospid", "").trim()); // 기본값 처리
	                        System.out.println("파일업로드 시작5-3");
		                    dto.setMg_year(mg_Year);
		                    System.out.println("파일업로드 시작5-4");
		                    dto.setMgmonth(mgMonth);
		                    System.out.println("파일업로드 시작5-5");
		                    dto.setMg_flag(mg_Flag);
		                    System.out.println("파일업로드 시작5-6");
		                    dto.setJobs_dt(jobs_dt);
		                    System.out.println("파일업로드 시작5-7");
		                    dto.setFile_nm(file_Nm);
		                    System.out.println("파일업로드 시작5-8");
		                    dto.setLine_no(file_No++);
		                    System.out.println("파일업로드 내용 : " + line );
		                    dto.setLineval(line);
		                    System.out.println("파일업로드 시작5-9");
		                    
		                    dto.setReg_user(cookie_value.getOrDefault("s_userid", "").trim());
		                    
		                    System.out.println("파일업로드 시작5-10");		                    
		                    dto.setUpd_user(dto.getReg_user());
		                    System.out.println("파일업로드 시작5-11");
		                    fileDataList.add(dto);
		                    System.out.println("파일업로드 시작5-12");
	                    }
	                }
                }    
            }
            System.out.println("파일업로드 종료");
            // Service 호출
            // svc.insertFileData(fileDataList);
            return "Files uploaded and data inserted successfully!";
        } catch (Exception e) {
            e.printStackTrace();
            return "Failed to upload files: " + e.getMessage();
        }
    }
    */
	/*
	
	@RequestMapping(value="/main/uploadMagamFiles.do", method = RequestMethod.POST)
	public ResponseEntity<String> uploadMagamFiles(@RequestParam("mgFiles") MultipartFile[] mgFiles,
	        									   @RequestParam("mg_Year") String mg_Year,
	        									   @RequestParam("mgMonth") String mgMonth,
	        									   @RequestParam("mg_Flag") String mg_Flag) {

	    try {
	    	
	    	log.info("파일 업로드 시작: 파일 수 = {}, 년도 = {}, 월 = {}, 플래그 = {}", mgFiles.length, mg_Year, mgMonth, mg_Flag);
	               
	        
	        
	        List<FilesDTO> fileDataList = new ArrayList<>();

	        LocalDateTime now = LocalDateTime.now();
	        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
	        String jobs_dt = now.format(formatter);

	        for (MultipartFile file : mgFiles) {
	            String file_Nm = file.getOriginalFilename();
	            int file_No = 0;

	            System.out.println("파일 이름 : " + file_Nm);
	            System.out.println("파일 크기 : " + file.getSize() + " bytes");

	            if (file.isEmpty()) {
	            	
	                throw new IllegalArgumentException("비어 있는 파일: " + file_Nm);
	            }

	            try (BufferedReader reader = new BufferedReader(new InputStreamReader(file.getInputStream()))) {
	                String line;
	                while ((line = reader.readLine()) != null) {
	                	
	                    FilesDTO dto = new FilesDTO();
	                    dto.setHosp_cd(cookie_value.getOrDefault("s_hospid", "").trim()); // 기본값 처리
	                    dto.setMg_year(mg_Year);
	                    dto.setMgmonth(mgMonth);
	                    dto.setMg_flag(mg_Flag);
	                    dto.setJobs_dt(jobs_dt);
	                    dto.setFile_nm(file_Nm);
	                    dto.setLine_no(file_No++);
	                    dto.setLineval(line);
	                    dto.setReg_user(cookie_value.getOrDefault("s_userid", "").trim());
	                    dto.setUpd_user(dto.getReg_user());
	                    fileDataList.add(dto);
	                }
	            }

	            System.out.println("라인 총수 : " + file_No + " 건");

	            try {
	                svc.uploadMagamFiles(fileDataList);
	            } catch (Exception e) {
	                System.err.println("파일 저장 중 오류 발생: " + e.getMessage());
	                throw e;
	            }
	            fileDataList.clear();
	        }
			
	        
            return ResponseEntity.ok("파일 업로드 및 처리 성공");
        } catch (Exception e) {
            log.error("파일 업로드 중 오류 발생", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                                 .body("파일 처리 중 오류 발생: " + e.getMessage());
        }
	}
	*/
	/*
	@RequestMapping(value="/main/uploadMagamFiles.do", method = RequestMethod.POST)
	@ResponseBody
    public ResponseEntity<String> uploadMagamFiles(@RequestParam("mgFiles") MultipartFile[] mgFiles, 
    											   @RequestParam("mg_Year") String mg_Year,
    											   @RequestParam("mgMonth") String mgMonth,
    											   @RequestParam("mg_Flag") String mg_Flag) {
		
        try {
        	
        	System.out.println("파일올림 시작");
        	
        	List<FilesDTO> fileDataList = new ArrayList<>();
        	FilesDTO dto = new FilesDTO();
        	
            LocalDateTime now = LocalDateTime.now();
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
            String jobs_dt = now.format(formatter);
        	
        	
            for (MultipartFile file : mgFiles) {
            	
            	// 공통변수 
            	String file_Nm = file.getOriginalFilename();
                int    file_No = 0;
                
                System.out.println("파일 이름 : " + file_Nm);
                System.out.println("파일 크기 : " + file.getSize() + " bytes");
                
                try (BufferedReader reader = new BufferedReader(new InputStreamReader(file.getInputStream()))) {
                	
                    String line = null;
                    
                    while ((line = reader.readLine()) != null) {
                    	
                    	dto.setHosp_cd(cookie_value.get("s_hospid").trim());  // 요양기관번호
                    	dto.setMg_year(mg_Year); 					          // 작업년
                    	dto.setMgmonth(mgMonth); 					          // 작업월
                    	dto.setMg_flag(mg_Flag); 					          // 마감구분 8.청구서 9.평가서
        				
                    	dto.setJobs_dt(jobs_dt);                              // 작업일시 (작업그룹)
                    	dto.setFile_nm(file_Nm);                              // 파일명칭
                    	dto.setLine_no(file_No++);                            // 라인번호
                    	dto.setLineval(line);                                 // 라인값 
                        
                    	dto.setReg_user(cookie_value.get("s_userid").trim()); // 입력자 ID
                    	dto.setUpd_user(dto.getReg_user());                   // 수정자 ID 
                    	
                        fileDataList.add(dto);                    
                    }                    
                }
                
                System.out.println("라인 총수 : " + file_No + " 건");
                
                svc.uploadMagamFiles(fileDataList);                
                fileDataList.clear(); // 리스트 초기화
                
                
                
            }
            
            return ResponseEntity.ok("파일 업로드 및 처리 성공");
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                                 .body("파일 처리 중 오류 발생: " + e.getMessage());
        }
    }
    */
}
