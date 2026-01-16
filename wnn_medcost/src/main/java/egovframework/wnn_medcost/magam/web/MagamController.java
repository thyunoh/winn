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
import java.util.Arrays;
import java.util.Collections;

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

import egovframework.wnn_medcost.magam.model.IpwonDTO;
import egovframework.wnn_medcost.magam.model.FilesDTO;
import egovframework.wnn_medcost.magam.model.MagamDTO;
import egovframework.wnn_medcost.magam.model.IndiDTO;
import egovframework.wnn_medcost.magam.model.PatvalDTO;
import egovframework.wnn_medcost.magam.service.MagamService;
import egovframework.wnn_medcost.total.model.TotalDTO;
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
	
	@RequestMapping(value="main/total_Report.do")
    public String total_Report(HttpServletRequest request, ModelMap model) {

        cookie_value = ClientInfo.getCookie(request);		
		try {
			if (cookie_value.get("s_hospid").trim() != null &&
				cookie_value.get("s_hospid").trim() != "" ) {
				return ".main/total_Report";				
			} else {
				return "";
			}	
		} catch(Exception ex) {
			return "";
		}
    }
	
	@RequestMapping(value="main/assessment.do")
    public String assessment(HttpServletRequest request, ModelMap model) {

        cookie_value = ClientInfo.getCookie(request);		
		try {
			if (cookie_value.get("s_hospid").trim() != null &&
				cookie_value.get("s_hospid").trim() != "" ) {
				return ".main/assessment";				
			} else {
				return "";
			}	
		} catch(Exception ex) {
			return "";
		}
    }
	@RequestMapping(value="main/simulation.do")
    public String simulation(HttpServletRequest request, ModelMap model) {

        cookie_value = ClientInfo.getCookie(request);		
		try {
			if (cookie_value.get("s_hospid").trim() != null &&
				cookie_value.get("s_hospid").trim() != "" ) {
				return ".main/simulation";				
			} else {
				return "";
			}	
		} catch(Exception ex) {
			return "";
		}
    }
	@RequestMapping(value="main/assesCheck.do")
    public String assesCheck(HttpServletRequest request, ModelMap model) {

        cookie_value = ClientInfo.getCookie(request);		
		try {
			if (cookie_value.get("s_hospid").trim() != null &&
				cookie_value.get("s_hospid").trim() != "" ) {
				return ".main/assesCheck";				
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
				
				dto.setHosp_cd(dto.getHosp_cd()); // 요양기관번호
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
	public String uploadMagamFiles(@RequestBody List<FilesDTO> filesData, ModelMap model ) {
				
		String err_cd = "0";
		
		try {
        	
        	System.out.println("파일 업로드 컨트롤 시작");
        	
        	if (!filesData.isEmpty()) {
    			// mybits Batch
        		err_cd = svc.uploadMagamFilesMain(filesData);
    			
    			model.addAttribute("error_code", err_cd);
    			
    			if        ("20000".equals(err_cd)) {
    				model.addAttribute("error_mess", "작업 2. 파일정보건수와 기초작업건수가 서로 같지 않습니다. 잠시 후 다시 시도하십시요 !!");
    			} else if ("30000".equals(err_cd)) {
    				model.addAttribute("error_mess", "작업 3. 기초작업건수와 업로드후 처리갯수가 서로 같지 않습니다. 잠시 후 다시 시도하십시요 !!");
    			} else if ("50000".equals(err_cd)) {
    				model.addAttribute("error_mess", "작업 5. 마감정보가 마무리 되기전 오류가 발생하였습니다. 잠시 후 다시 시도하십시요 !!");
    			} else {
    				model.addAttribute("error_mess", err_cd);
    			}
    			
            	// mybits Procedule
            	// svc.callUploadMagamFiles(filesData);            	
                // 데이터 저장 방식 선택 (단일 SQL 또는 Batch)
                // svc.uploadMagamFilesBatch(filesData); // Batch 방식
                // svc.uploadMagamFilesOnest(filesData); // 단일 SQL 방식
					
	    		
        	} else {
        		model.addAttribute("error_code", "10000");
        		model.addAttribute("error_mess", "작업 1. 작업대상 파일이 존재하지 않습니다. 담당자게 문의하십시요 !!");
        	}
        } catch (Exception e) {
        	model.addAttribute("error_code", "90000");
        	model.addAttribute("error_mess", e.getMessage() + " - UploadMagamFiles처리시 서버 오류가 발생했습니다.");
        }
        
        return "jsonView";

    }
	
	@RequestMapping(value="/main/deleteMagamClaimNo.do", method = RequestMethod.POST)
    public String delMagamClaimNo(@ModelAttribute("DTO") MagamDTO dto, Model model) {
		
		System.out.println("Delete 시작했음");
		String err_cd = "0";
		// 처리 로직
        try {
        	
        	System.out.println("deleteMagam 시작했음 2 - getHosp_cd  확인 - " + dto.getHosp_cd());
        	System.out.println("deleteMagam 시작했음 3 - getMg_year  확인 - " + dto.getMg_year());
        	System.out.println("deleteMagam 시작했음 4 - getMgmonth  확인 - " + dto.getMgmonth());
        	System.out.println("deleteMagam 시작했음 5 - getMg_flag  확인 - " + dto.getMg_flag());
        	System.out.println("deleteMagam 시작했음 6 - getClaim_no 확인 - " + dto.getClaim_no());
        	System.out.println("deleteMagam 시작했음 6 - getReg_user 확인 - " + dto.getReg_user());
   		    
   		    dto.setHosp_cd(dto.getHosp_cd());   // 요양기관번호
   		    dto.setMg_year(dto.getMg_year());   // 작업년
			dto.setMgmonth(dto.getMgmonth());   // 작업월
			dto.setMg_flag(dto.getMg_flag()); 	// 마감구분 8.청구서 9.평가서 z.입원현황		
			dto.setClaim_no(dto.getClaim_no()); // 청구번호 
			dto.setReg_user(dto.getReg_user()); // 사용자
   		    
   		    err_cd = svc.delMagamClaimNo(dto);
   		    
       		model.addAttribute("error_code", err_cd);
 			
 			if        ("20000".equals(err_cd)) {
 				model.addAttribute("error_mess", "작업 1. 마감자료를 찾지 못했습니다. 담당자에게 문의하세요 !!");
 			} else {
 				model.addAttribute("error_mess", err_cd);
 			}  
        	        	
        } catch (Exception e) {
            
        }
        
        return "jsonView";
	}
	
	@RequestMapping(value="/main/updateMagamLock.do", method = RequestMethod.POST)
    public String updateMagamLock(@ModelAttribute("DTO") MagamDTO dto, Model model) {
		
		System.out.println("updateMagamLock 시작했음");
		String err_cd = "0";
		// 처리 로직
        try {
        	
        	System.out.println("updateMagamLock 시작했음 2 - getHosp_cd  확인 - " + dto.getHosp_cd());
        	System.out.println("updateMagamLock 시작했음 3 - getMg_year  확인 - " + dto.getMg_year());
        	System.out.println("updateMagamLock 시작했음 4 - getMgmonth  확인 - " + dto.getMgmonth());
        	System.out.println("updateMagamLock 시작했음 5 - getMg_flag  확인 - " + dto.getMg_flag());
   		    
   		    dto.setHosp_cd(dto.getHosp_cd());   // 요양기관번호
   		    dto.setMg_year(dto.getMg_year());   // 작업년
			dto.setMgmonth(dto.getMgmonth());   // 작업월
			dto.setMg_flag(dto.getMg_flag()); 	// 마감구분 8.청구서 9.평가서		
   		    
   		    err_cd = svc.updateMagamLock(dto);
   		    
       		model.addAttribute("error_code", err_cd);
 			
 			if        ("10000".equals(err_cd)) {
 				model.addAttribute("error_mess", "작업 1. 마감정보가 정상적으로 등록되지 않았습니다. !!");
 			} else {
 				model.addAttribute("error_mess", err_cd);
 			}  
        	        	
        } catch (Exception e) {
            
        }
        
        return "jsonView";
	}
	
	@RequestMapping(value="/main/dashbordMedExpenses.do", method = RequestMethod.POST)
    public String dashbordMedExpenses(@ModelAttribute("DTO") MagamDTO dto, Model model) {
		
		System.out.println("Dashbord 시작했음");
		String err_cd = "0";
		// 처리 로직
        try {
        	
        	// System.out.println("Dashbord 시작했음 1 - s_hospid   확인 - " + cookie_value.get("s_hospid").trim());        	
        	System.out.println("Dashbord 시작했음 2 - getHosp_cd 확인 - " + dto.getHosp_cd());
        	System.out.println("Dashbord 시작했음 3 - getMg_year 확인 - " + dto.getMg_year());
        	System.out.println("Dashbord 시작했음 4 - getMgmonth 확인 - " + dto.getMgmonth());
			
	   		Map<String, Object> params = new HashMap<>();
	   		params.put("hosp_cd", dto.getHosp_cd());
	   		params.put("mg_year", dto.getMg_year());
	   		params.put("mgmonth", dto.getMgmonth());
	   		params.put("totamt1", 0);
	   		params.put("totamt2", 0);
	   		params.put("yngamt1", 0);
	   		params.put("yngamt2", 0);
	   		params.put("jngamt1", 0);
	   		params.put("jngamt2", 0);
	   		params.put("hwiamt1", 0);
	   		params.put("hwiamt2", 0);
	   		params.put("dayamt1", 0);
	   		params.put("dayamt2", 0);
	   		params.put("oneamt1", 0);
	   		params.put("oneamt2", 0);
	   		params.put("tsuamt1", 0);
	   		params.put("tsuamt2", 0);
	   		params.put("hanamt1", 0);
	   		params.put("hanamt2", 0);
	
	   		err_cd = svc.dashbordMedExpenses(params);
	
   		    model.addAttribute("totamt1", params.get("totamt1"));         // 당월 총진료비
   		    model.addAttribute("totamt2", params.get("totamt2"));         // 전월 총진료비
   		    model.addAttribute("yngamt1", params.get("yngamt1"));         // 당월 양방청구
   		    model.addAttribute("yngamt2", params.get("yngamt2"));         // 전월 양방청구
   		    model.addAttribute("jngamt1", params.get("jngamt1"));         // 당월 정액청구
   		    model.addAttribute("jngamt2", params.get("jngamt2"));         // 전월 정액청구
   		    model.addAttribute("hwiamt1", params.get("hwiamt1"));         // 당월 행위청구
   		    model.addAttribute("hwiamt2", params.get("hwiamt2"));         // 전월 행위청구
   		    model.addAttribute("dayamt1", params.get("dayamt1"));         // 당월 일당진료비
   		    model.addAttribute("dayamt2", params.get("dayamt2"));         // 전월 일당진료비
   		    model.addAttribute("oneamt1", params.get("oneamt1"));         // 당월 건당진료비
   		    model.addAttribute("oneamt2", params.get("oneamt2"));         // 전월 건당진료비
   		    model.addAttribute("tsuamt1", params.get("tsuamt1"));         // 당월 특정수가비
   		    model.addAttribute("tsuamt2", params.get("tsuamt2"));         // 전월 특정수가비
   		    model.addAttribute("hanamt1", params.get("hanamt1"));         // 당월 한방청구액
   		    model.addAttribute("hanamt2", params.get("hanamt2"));         // 전월 한방청구액
   		    
   		    model.addAttribute("error_code", err_cd);
 			
 			if        ("90000".equals(err_cd)) {
 				model.addAttribute("error_mess", "SQL, Dashbord Value Select Error !!");
 			} else {
 				model.addAttribute("error_mess", err_cd);
 			}  
        	        	
        } catch (Exception e) {
            
        }
        
        return "jsonView";
	}
	
	@RequestMapping(value="/main/dashbordINDICATORS.do", method = RequestMethod.POST)
    public String dashbordINDICATORS(@ModelAttribute("DTO") MagamDTO dto, Model model) {
		
		System.out.println("Dashbord 시작했음");
		String err_cd = "0";
		// 처리 로직
        try {
        	
        	// System.out.println("Dashbord 시작했음 1 - s_hospid   확인 - " + cookie_value.get("s_hospid").trim());        	
        	System.out.println("Dashbord 시작했음 2 - getHosp_cd 확인 - " + dto.getHosp_cd());
        	System.out.println("Dashbord 시작했음 3 - getMg_year 확인 - " + dto.getMg_year());
        	System.out.println("Dashbord 시작했음 4 - getMgmonth 확인 - " + dto.getMgmonth());
			
	   		Map<String, Object> params = new HashMap<>();
	   		params.put("hosp_cd",  dto.getHosp_cd());
	   		params.put("mg_year",  dto.getMg_year());
	   		params.put("mgmonth",  dto.getMgmonth());
	   		params.put("goalName", "");
	   		params.put("cQuarter", "");
	   		params.put("goal_Val", 0);
	   		params.put("hosGrade", "");
	   		params.put("year_Val", 0);
	   		params.put("strValue", 0);
	   		params.put("medValue", 0);
	   		params.put("monthVal", 0);
	   		params.put("checkNm1", "");
	   		params.put("checkNm2", "");
	   		params.put("checkNm3", "");
	   		params.put("checkNm4", "");
	   		
	   		err_cd = svc.dashbordINDICATORS(params);
	
   		    model.addAttribute("goalName", params.get("goalName"));         // 주기+주차 명
   		    model.addAttribute("cQuarter", params.get("cQuarter"));         // 분기
   		    model.addAttribute("goal_Val", params.get("goal_Val"));         // 목표점수
   		    model.addAttribute("hosGrade", params.get("hosGrade"));         // 병원등급
   		    model.addAttribute("year_Val", params.get("year_Val"));         // 년간점수 (7월 ~ 12월 누적)
   		    model.addAttribute("strValue", params.get("strValue"));         // 구조영역 (7월 ~ 12월 누적)
   		    model.addAttribute("medValue", params.get("medValue"));         // 진료영역 (7월 ~ 12월 누적)
   		    model.addAttribute("monthVal", params.get("monthVal"));         // 당월점수 (구조+진료)
   		    model.addAttribute("checkNm1", params.get("checkNm1"));         // 점검지표 1
   		    model.addAttribute("checkNm2", params.get("checkNm2"));         // 점검지표 2
   		    model.addAttribute("checkNm3", params.get("checkNm3"));         // 점검지표 3
   		    model.addAttribute("checkNm4", params.get("checkNm4"));         // 점검지표 4
   		    model.addAttribute("month_07", params.get("month_07"));         // 07월점수 (구조+진료)
   		    model.addAttribute("month_08", params.get("month_08"));         // 08월점수 (구조+진료)
   		    model.addAttribute("month_09", params.get("month_09"));         // 09월점수 (구조+진료)
   		    model.addAttribute("month_10", params.get("month_10"));         // 10월점수 (구조+진료)
   		    model.addAttribute("month_11", params.get("month_11"));         // 11월점수 (구조+진료)
   		    model.addAttribute("month_12", params.get("month_12"));         // 12월점수 (구조+진료)
   		    
   		    model.addAttribute("error_code", err_cd);
 			
 			if        ("90000".equals(err_cd)) {
 				model.addAttribute("error_mess", "SQL, Dashbord Value Select Error !!");
 			} else {
 				model.addAttribute("error_mess", err_cd);
 			}  
        	        	
        } catch (Exception e) {
            
        }
        
        return "jsonView";
	}
	
	@RequestMapping(value="/main/createTotalReport.do", method = RequestMethod.POST)
    public String crtTotalReport(@ModelAttribute("DTO") MagamDTO dto, Model model) {
		
		System.out.println("Create 시작했음");
		String err_cd = "0";
		// 처리 로직
        try {
        	
        	/*
        	System.out.println("crtTotalReport 시작했음 2 - getHosp_cd  확인 - " + dto.getHosp_cd());
        	System.out.println("crtTotalReport 시작했음 3 - getJobyymm  확인 - " + dto.getJobyymm());
        	System.out.println("crtTotalReport 시작했음 5 - getMake_fg  확인 - " + dto.getMake_fg());
        	*/
        	log.error("crtTotalReport 시작했음");
            log.error(dto.getHosp_cd());
            log.error(dto.getJobyymm());
            log.error(dto.getMake_fg());
            
        	dto.setHosp_cd(dto.getHosp_cd());   // 요양기관번호
   		    dto.setJobyymm(dto.getJobyymm());   // 작업년월
			dto.setMake_fg(dto.getMake_fg()); 	// 작업구분
		
			log.error("crtTotalReport 호출했음");
			err_cd = svc.crtTotalReport(dto);			
			log.error("crtTotalReport 호출종료");
   		    model.addAttribute("error_code", err_cd);
 			
 			if        ("20000".equals(err_cd)) {
 				model.addAttribute("error_mess", "작업 1. 생성자료를 찾지 못했습니다. 담당자에게 문의하세요 !!");
 			} else {
 				model.addAttribute("error_mess", err_cd);
 			}  
        	        	
        } catch (Exception e) {
            
        }
        
        return "jsonView";
	}
	
	@RequestMapping(value="/main/selectTotalReport.do", method = RequestMethod.POST)
    public String setTotalReport(@ModelAttribute("DTO") MagamDTO dto, Model model) {
		
		System.out.println("Select 시작했음");

		// 처리 로직
        try {
        	
        	/*
        	System.out.println("setTotalReport 시작했음 1 - getHosp_cd  확인 - " + dto.getHosp_cd());
        	System.out.println("setTotalReport 시작했음 2 - getMg_year  확인 - " + dto.getFr_yymm());
        	System.out.println("setTotalReport 시작했음 3 - getMidyymm  확인 - " + dto.getMidyymm());
        	System.out.println("setTotalReport 시작했음 4 - getEndyymm  확인 - " + dto.getEndyymm());
        	System.out.println("setTotalReport 시작했음 5 - getMake_fg  확인 - " + dto.getMake_fg());
        	*/
   		    
        	log.error("selectTotalReport 시작했음");
            log.error(dto.getHosp_cd());
            log.error(dto.getFr_yymm());
            log.error(dto.getMidyymm());
            log.error(dto.getEndyymm());
            log.error(dto.getMake_fg());
            
        	dto.setHosp_cd(dto.getHosp_cd());   // 요양기관번호
   		    dto.setFr_yymm(dto.getFr_yymm());   // 
   		    dto.setMidyymm(dto.getMidyymm());   // 
			dto.setEndyymm(dto.getEndyymm());   // 
			dto.setMake_fg(dto.getMake_fg()); 	// 작업구분
			
			
			// resultData 초기화
	        List<?> resultData = new ArrayList<>();

	        try {
	        	log.error("selectTotalReport 호출했음");
	        	if        (dto.getMake_fg().equals("01")) { 
	            	System.out.println("setTotalReport 01 - 시작했음");
	        	    resultData = svc.setTotalReport_01(dto);      
	        	    System.out.println("setTotalReport 01 - 완료했음");
	        	} else if (dto.getMake_fg().equals("02")) { 
	            	System.out.println("setTotalReport 02 - 시작했음");
	        	    resultData = svc.setTotalReport_02(dto);      
	        	    System.out.println("setTotalReport 02 - 완료했음");
	            } else if (dto.getMake_fg().equals("03") ||
	        			   dto.getMake_fg().equals("04") ||
	        			   dto.getMake_fg().equals("05") ||
	        			   dto.getMake_fg().equals("06") ||   
	        			   dto.getMake_fg().equals("07") ||
	        			   dto.getMake_fg().equals("08") ||
	        			   dto.getMake_fg().equals("14")) {
	        		System.out.println("setTotalReport " + dto.getMake_fg() + " - 시작했음");
	        	    resultData = svc.setTotalReport_03(dto);
	        	    System.out.println("setTotalReport " + dto.getMake_fg() + " - 완료했음");
	            } else if (dto.getMake_fg().equals("09") || 
	        			   dto.getMake_fg().equals("10")) {
	        		System.out.println("setTotalReport " + dto.getMake_fg() + " - 시작했음");
	        	    resultData = svc.setTotalReport_09(dto);
	        	    System.out.println("setTotalReport " + dto.getMake_fg() + " - 완료했음");    
	        	} else if (dto.getMake_fg().equals("11") || 
	        			   dto.getMake_fg().equals("12")) {
	        		System.out.println("setTotalReport " + dto.getMake_fg() + " - 시작했음");
	        	    resultData = svc.setTotalReport_11(dto);
	        	    System.out.println("setTotalReport " + dto.getMake_fg() + " - 완료했음");
	        	} else if (dto.getMake_fg().equals("13")) { 
	        		System.out.println("setTotalReport " + dto.getMake_fg() + " - 시작했음");
	        	    resultData = svc.setTotalReport_13(dto);
	        	    System.out.println("setTotalReport " + dto.getMake_fg() + " - 완료했음");
	        	}
	            
	        	log.error("selectTotalReport 호출했음 size 확인 - " +  resultData.size());
	            /*
	        	System.out.println("setTotalReport 시작했음 7 - resultData size 확인 - " +  resultData.size());
				*/
	            model.addAttribute("resultData", resultData);
	            model.addAttribute("resultSize", resultData.size());
	            model.addAttribute("error_code", "0"); 

	        } catch (Exception ex) {
	            model.addAttribute("error_code", ex.getMessage()); 
	        }
			
			
	        return "jsonView";
			
			
			/*
			err_cd = svc.setTotalReport(dto);			
			
   		    model.addAttribute("error_code", err_cd);
 			
 			if        ("20000".equals(err_cd)) {
 				model.addAttribute("error_mess", "작업 1. 생성자료를 찾지 못했습니다. 담당자에게 문의하세요 !!");
 			} else {
 				model.addAttribute("error_mess", err_cd);
 			}  
        	*/
			
			
        } catch (Exception e) {
            
        }
        
        return "jsonView";
	}
	
	@RequestMapping(value="/main/saveGasanMst.do", method = RequestMethod.POST)
    public String saveGasanMst(@ModelAttribute("DTO") MagamDTO dto, Model model) {
		
		System.out.println("saveGasanMst 시작했음");
		String err_cd = "0";
		// 처리 로직
        try {
        	System.out.println("saveGasanMst 시작했음 1 - getHosp_cd  확인 - " + dto.getHosp_cd());
        	System.out.println("saveGasanMst 시작했음 2 - getjobyymm  확인 - " + dto.getJobyymm());
        	System.out.println("saveGasanMst 시작했음 3 - getdoc_grd  확인 - " + dto.getDoc_grd());
        	System.out.println("saveGasanMst 시작했음 4 - getnur_grd  확인 - " + dto.getNur_grd());
        	System.out.println("saveGasanMst 시작했음 5 - getnur_cnt  확인 - " + dto.getNur_cnt());
        	System.out.println("saveGasanMst 시작했음 6 - getneed_ga  확인 - " + dto.getNeed_ga());
        	System.out.println("saveGasanMst 시작했음 7 - getdietga1  확인 - " + dto.getDietga1());
        	System.out.println("saveGasanMst 시작했음 8 - getdietga2  확인 - " + dto.getDietga2());
        	System.out.println("saveGasanMst 시작했음 9 - getdietga3  확인 - " + dto.getDietga3());
        	System.out.println("saveGasanMst 시작했음 10- getdietga4  확인 - " + dto.getDietga4());;
        	System.out.println("saveGasanMst 시작했음 11- getReg_user 확인 - " + dto.getReg_user());;
   		    
   		    dto.setHosp_cd(dto.getHosp_cd());
   		    dto.setJobyymm(dto.getJobyymm());
   		    dto.setDoc_grd(dto.getDoc_grd());
   		    dto.setNur_grd(dto.getNur_grd());
   		    dto.setNur_cnt(dto.getNur_cnt());
		    dto.setNeed_ga(dto.getNeed_ga());
		    dto.setDietga1(dto.getDietga1());
		    dto.setDietga2(dto.getDietga2());
		    dto.setDietga3(dto.getDietga3());
		    dto.setDietga4(dto.getDietga4());   
		    dto.setReg_user(dto.getReg_user());
		    
   		    
   		    err_cd = svc.saveGasanMst(dto);
   		    
       		model.addAttribute("error_code", err_cd);
 			
 			if        ("20000".equals(err_cd)) {
 				model.addAttribute("error_mess", "작업 1. 저장작업을 정상처리 하지 못했습니다. 담당자에게 문의하세요 !!");
 			} else {
 				model.addAttribute("error_mess", err_cd);
 			}  
        	        	
        } catch (Exception e) {
            
        }
        
        return "jsonView";
	}
	
	@RequestMapping(value="/main/saveExcelDatas.do", method = RequestMethod.POST)	
	public String saveExcelDatas(@RequestBody List<IpwonDTO> ipwonData, ModelMap model ) {
				
		String err_cd = "0";
		
		try {
        	
        	System.out.println("입원현황 업로드 컨트롤 시작");
        	
        	if (!ipwonData.isEmpty()) {

        		err_cd = svc.saveExcelDatas(ipwonData);
    			
    			if        ("20000".equals(err_cd)) {
    				model.addAttribute("error_mess", "작업 2. 입원현황 정리시 오류(del). 잠시 후 다시 시도하십시요 !!");
    			} else if ("30000".equals(err_cd)) {
    				model.addAttribute("error_mess", "작업 3. 입원현황 정리시 오류(ins). 잠시 후 다시 시도하십시요 !!");
    			} else {
    				model.addAttribute("error_code", err_cd);
    			}
        	} else {
        		model.addAttribute("error_code", "10000");
        		model.addAttribute("error_mess", "작업 1. 입원현황 내용이 존재하지 않습니다. 담당자게 문의하십시요 !!");
        	}
        } catch (Exception e) {
        	model.addAttribute("error_code", "90000");
        	model.addAttribute("error_mess", e.getMessage() + " - saveExcelDatas처리시 서버 오류가 발생했습니다.");
        }
        
        return "jsonView";

    }
	
	
	
	@RequestMapping(value="/main/create_Eval_Indi.do", method = RequestMethod.POST)
    public String create_Eval_Indi(@ModelAttribute("DTO") IndiDTO dto, Model model) {
		
		System.out.println("Create 시작했음");
		String err_cd = "0";
		// 처리 로직
        try {
        	
        	
        	System.out.println("create_Eval_Indi 시작했음 1 - getHosp_cd   확인 - " + dto.getHosp_cd());
        	System.out.println("create_Eval_Indi 시작했음 2 - getJobyymm   확인 - " + dto.getJobyymm());
        	System.out.println("create_Eval_Indi 시작했음 3 - getReg_user  확인 - " + dto.getReg_user());
        	
        	/*
        	log.error("crtTotalReport 시작했음");
            log.error(dto.getHosp_cd());
            log.error(dto.getJobyymm());
            */
        	
        	dto.setHosp_cd(dto.getHosp_cd());   // 요양기관번호 
   		    dto.setJobyymm(dto.getJobyymm());   // 작업년월
   		    dto.setReg_user(dto.getReg_user()); // 사용자
   		    
   		    System.out.println("create_Eval_Indi 호출했음");
			err_cd = svc.create_Eval_Indi(dto);			
			System.out.println("create_Eval_Indi 호출종료");
			
			if ("90000".equals(err_cd)) {
 				model.addAttribute("error_mess", "작업 1. 자료생성중 오류 발생됨. 담당자에게 문의하세요 !!");
 			} 
        	        	
        } catch (Exception ex) {
            model.addAttribute("error_code", ex.getMessage()); 
        }
        
        return "jsonView";
	}
	@RequestMapping(value="/main/select_Eval_Indi.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> select_Eval_Indi(@ModelAttribute("DTO") IndiDTO dto, HttpSession session, HttpServletRequest request, Model model) throws Exception {
		
		System.out.println("Create 시작했음");
		String err_cd = "0";
		// 처리 로직
        try {
        	
        	System.out.println("create_Eval_Indi 시작했음 1 - getHosp_cd   확인 - " + dto.getHosp_cd());
        	System.out.println("create_Eval_Indi 시작했음 2 - getJobyymm   확인 - " + dto.getJobyymm());
        	System.out.println("create_Eval_Indi 시작했음 3 - getReg_user  확인 - " + dto.getReg_user());
        	
        	/*
        	log.error("crtTotalReport 시작했음");
            log.error(dto.getHosp_cd());
            log.error(dto.getJobyymm());
            */
        	
        	dto.setHosp_cd(dto.getHosp_cd());   // 요양기관번호 
   		    dto.setJobyymm(dto.getJobyymm());   // 작업년월
   		    dto.setReg_user(dto.getReg_user()); // 사용자
   		   
   		    List<IndiDTO>       resultdt;
   		    Map<String, Object> response = new HashMap<>();
			
			System.out.println("select_Eval_Indi 호출했음");
			resultdt = svc.select_Eval_Indi(dto);
			response.put("data",resultdt);
			System.out.println("select_Eval_Indi 호출종료");
			model.addAttribute("error_code", err_cd);

			return response;

        } catch (Exception ex) {
            model.addAttribute("error_code", ex.getMessage()); 
            return null;
        }
	}
	
	@RequestMapping(value="/main/select_CategoryList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> select_CategoryList(@ModelAttribute("DTO") PatvalDTO dto, HttpSession session, HttpServletRequest request, Model model) throws Exception {
		
		System.out.println("Create 시작했음");
		String err_cd = "0";
		// 처리 로직
        try {
        	
        	System.out.println("select_CategoryList 시작했음 1 - getHosp_cd   확인 - " + dto.getHospCd());
        	System.out.println("select_CategoryList 시작했음 2 - getJobyymm   확인 - " + dto.getJobYymm());
        	System.out.println("select_CategoryList 시작했음 3 - getCateCd    확인 - " + dto.getCateCd());
        	        	
        	/*
        	log.error("crtTotalReport 시작했음");
            log.error(dto.getHosp_cd());
            log.error(dto.getJobyymm());
            */
        	
        	dto.setHospCd(dto.getHospCd());   // 요양기관번호 
   		    dto.setJobYymm(dto.getJobYymm()); // 작업년월
   		    dto.setCateCd(dto.getCateCd());   // 지표코드
   		   
   		    List<PatvalDTO>       resultdt;
   		    Map<String, Object> response = new HashMap<>();
			
			if        (dto.getCateCd().equals("05")) { 
				System.out.println("select_CategoryList 05 - 호출했음");
				resultdt = svc.select_CategoryList05(dto);
				response.put("data",resultdt);
        	    System.out.println("select_CategoryList 05 - 완료했음");
        	} else if (dto.getCateCd().equals("07")) {
        		System.out.println("select_CategoryList 07 - 호출했음");
				resultdt = svc.select_CategoryList07(dto);
				response.put("data",resultdt);
        	    System.out.println("select_CategoryList 07 - 완료했음");
        	}  else if (dto.getCateCd().equals("09")) {
        		System.out.println("select_CategoryList 09 - 호출했음");
				resultdt = svc.select_CategoryList09(dto);
				response.put("data",resultdt);
        	    System.out.println("select_CategoryList 09 - 완료했음");
        	}  else if (dto.getCateCd().equals("10")) {
        		System.out.println("select_CategoryList 10 - 호출했음");
				resultdt = svc.select_CategoryList10(dto);
				response.put("data",resultdt);
        	    System.out.println("select_CategoryList 10 - 완료했음");
        	}  else if (dto.getCateCd().equals("11")) {
        		System.out.println("select_CategoryList 11 - 호출했음");
				resultdt = svc.select_CategoryList11(dto);
				response.put("data",resultdt);
        	    System.out.println("select_CategoryList 11 - 완료했음");
        	}  else if (dto.getCateCd().equals("12")) {
        		System.out.println("select_CategoryList 12 - 호출했음");
				resultdt = svc.select_CategoryList12(dto);
				response.put("data",resultdt);
        	    System.out.println("select_CategoryList 12 - 완료했음");
        	}  else if (dto.getCateCd().equals("13")) {
        		System.out.println("select_CategoryList 13 - 호출했음");
				resultdt = svc.select_CategoryList13(dto);
				response.put("data",resultdt);
        	    System.out.println("select_CategoryList 13 - 완료했음");
        	}  else if (dto.getCateCd().equals("14")) {
        		System.out.println("select_CategoryList 14 - 호출했음");
				resultdt = svc.select_CategoryList14(dto);
				response.put("data",resultdt);
        	    System.out.println("select_CategoryList 14 - 완료했음");
        	}
			
			model.addAttribute("error_code", err_cd);

			return response;

        } catch (Exception ex) {
            model.addAttribute("error_code", ex.getMessage()); 
            return null;
        }
	}
	@RequestMapping(value="/main/select_assesCheck.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> select_assesCheck(@ModelAttribute("DTO") PatvalDTO dto, HttpSession session, HttpServletRequest request, Model model) throws Exception {
		
		System.out.println("Create 시작했음");
		String err_cd = "0";
		// 처리 로직
        try {
        	
        	System.out.println("select_assesCheck 시작했음 1 - getHosp_cd   확인 - " + dto.getHospCd());
        	System.out.println("select_assesCheck 시작했음 2 - getJobyymm   확인 - " + dto.getJobYymm());
        	System.out.println("select_assesCheck 시작했음 3 - getJobFlag   확인 - " + dto.getJobFlag());
        	        	
        	/*
        	log.error("crtTotalReport 시작했음");
            log.error(dto.getHosp_cd());
            log.error(dto.getJobyymm());
            */
        	
        	dto.setHospCd(dto.getHospCd());   // 요양기관번호 
   		    dto.setJobYymm(dto.getJobYymm()); // 작업년월
   		    dto.setJobFlag(dto.getJobFlag()); // 작업구분
   		   
   		    List<PatvalDTO>       resultdt;
   		    Map<String, Object> response = new HashMap<>();
			
			if        (dto.getJobFlag().equals("00")) { 
				System.out.println("select_assesCheck 00 - 호출했음");
				resultdt = svc.select_assesCheck00(dto);
				response.put("data",resultdt);
        	    System.out.println("select_assesCheck 00 - 완료했음");
        	} else if (dto.getJobFlag().equals("01")) {
        		System.out.println("select_assesCheck 01 - 호출했음");
				resultdt = svc.select_assesCheck01(dto);
				response.put("data",resultdt);
        	    System.out.println("select_assesCheck 01 - 완료했음");
        	}  else if (dto.getJobFlag().equals("02")) {
        		System.out.println("select_assesCheck 02 - 호출했음");
				resultdt = svc.select_assesCheck02(dto);
				response.put("data",resultdt);
        	    System.out.println("select_assesCheck 02 - 완료했음");
        	}  else if (dto.getJobFlag().equals("03")) {
        		System.out.println("select_assesCheck 03 - 호출했음");
				resultdt = svc.select_assesCheck03(dto);
				response.put("data",resultdt);
        	    System.out.println("select_assesCheck 03 - 완료했음");
        	}  else if (dto.getJobFlag().equals("04")) {
        		System.out.println("select_assesCheck 04 - 호출했음");
				resultdt = svc.select_assesCheck04(dto);
				response.put("data",resultdt);
        	    System.out.println("select_assesCheck 04 - 완료했음");
        	}  else if (dto.getJobFlag().equals("05")) {
        		System.out.println("select_assesCheck 05 - 호출했음");
				resultdt = svc.select_assesCheck05(dto);
				response.put("data",resultdt);
        	    System.out.println("select_assesCheck 05 - 완료했음");
        	}  else if (dto.getJobFlag().equals("06")) {
        		System.out.println("select_assesCheck 06 - 호출했음");
				resultdt = svc.select_assesCheck06(dto);
				response.put("data",resultdt);
        	    System.out.println("select_assesCheck 06 - 완료했음");
        	} else if (dto.getJobFlag().equals("99")) {
        		System.out.println("select_assesCheck 99 - 호출했음");
				resultdt = svc.select_assesCheck99(dto);
				response.put("data",resultdt);
        	    System.out.println("select_assesCheck 99 - 완료했음");
        	}  
			
			model.addAttribute("error_code", err_cd);

			return response;

        } catch (Exception ex) {
            model.addAttribute("error_code", ex.getMessage()); 
            return null;
        }
	}
	@RequestMapping(value="/main/select_HospitalMst.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> select_HospitalMst(@ModelAttribute("DTO") IndiDTO dto, HttpSession session, HttpServletRequest request, Model model) {
		
		System.out.println("select_HospitalMst 시작했음");
		String err_cd = "0";
		// 처리 로직
        try {
        	
        	List<IndiDTO>       resultdt;
   		    Map<String, Object> response = new HashMap<>();
			
			System.out.println("select_HospitalMst 호출했음");
			
			System.out.println(dto.getHosp_cd());
			
			resultdt = svc.select_HospitalMst(dto);
			response.put("data",resultdt);
			System.out.println("select_HospitalMst 호출종료");
			model.addAttribute("error_code", err_cd);

			return response;

        } catch (Exception ex) {
            model.addAttribute("error_code", ex.getMessage()); 
            return null;
        }
		
		
	}
	@RequestMapping(value = "/main/select_Hosp_Indi.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> select_Hosp_Indi(@RequestParam("hosp_cd") List<String> hospCds,
											    @RequestParam("stryymm") String stryymm,
											    @RequestParam("endyymm") String endyymm,
											    @RequestParam("month_1") String m1,
											    @RequestParam("month_2") String m2,
											    @RequestParam("month_3") String m3,
											    @RequestParam("month_4") String m4,
											    @RequestParam("month_5") String m5,
											    @RequestParam("month_6") String m6,
											    HttpSession session,
											    HttpServletRequest request,
											    Model model) {

	    System.out.println("select_Hosp_Indi 시작했음");
	    String err_cd = "0";
	    Map<String, Object> response = new HashMap<>();

	    try {
	    	Map<String, Object> params = new HashMap<>();
	        params.put("hospcds", hospCds);
	        params.put("stryymm", stryymm);
	        params.put("endyymm", endyymm);
	        params.put("month_1", m1);
	        params.put("month_2", m2);
	        params.put("month_3", m3);
	        params.put("month_4", m4);
	        params.put("month_5", m5);
	        params.put("month_6", m6);

	        System.out.println(params.get("hospcds"));
	        System.out.println(params.get("stryymm"));
	        System.out.println(params.get("endyymm"));
	        System.out.println(params.get("month_1"));
	        System.out.println(params.get("month_2"));
	        System.out.println(params.get("month_3"));
	        System.out.println(params.get("month_4"));
	        System.out.println(params.get("month_5"));
	        System.out.println(params.get("month_6"));
	        
	        
	        System.out.println("select_Hosp_Indi 호출했음");
	        List<IndiDTO> resultdt = svc.select_Hosp_Indi(params);
	        response.put("data", resultdt);
	        model.addAttribute("error_code", err_cd);
	        System.out.println("select_Hosp_Indi 호출종료");
			
	        return response;

	    } catch (Exception ex) {
	        ex.printStackTrace();
	        model.addAttribute("error_code", ex.getMessage());
	        response.put("error", ex.getMessage());
	        return response;
	    }
	}
	
	@RequestMapping(value="/main/insertGoolgleSheet.do", method = RequestMethod.POST)
    public String insGoolgleSheet(@ModelAttribute("DTO") MagamDTO dto, Model model) {
		
		System.out.println("Insert 시작했음");
		String err_cd = "0";
		// 처리 로직
        try {
        	
        	System.out.println("insertGoolgleSheet 시작했음 1 - getHosp_cd  확인 - " + dto.getHosp_cd());
        	System.out.println("insertGoolgleSheet 시작했음 2 - getJobyymm  확인 - " + dto.getJobyymm());
        	System.out.println("insertGoolgleSheet 시작했음 3 - getJobcode  확인 - " + dto.getJobcode());
        	System.out.println("insertGoolgleSheet 시작했음 4 - getHttp_st  확인 - " + dto.getHttp_st());
        	System.out.println("insertGoolgleSheet 시작했음 5 - getReg_user 확인 - " + dto.getReg_user());
   		    
   		    dto.setHosp_cd(dto.getHosp_cd());   // 요양기관번호
   		    dto.setJobyymm(dto.getJobyymm());   // 작업년월
   		    dto.setJobcode(dto.getJobcode());   // 작업구분
   		    dto.setHttp_st(dto.getHttp_st());   // 구글시트주소
			dto.setReg_user(dto.getReg_user()); // 사용자
   		    
   		    err_cd = svc.insGoolgleSheet(dto);
   		    
       		model.addAttribute("error_code", err_cd);
 			
 			if        ("10000".equals(err_cd)) {
 				model.addAttribute("error_mess", "작업 1. 등록중 오류발생 !!");
 			} else {
 				model.addAttribute("error_mess", err_cd);
 			}  
        	        	
        } catch (Exception e) {
            
        }
        
        return "jsonView";
	}
	
	@RequestMapping(value="/main/selectGoolgleSheet.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> selGoolgleSheet(@ModelAttribute("DTO") MagamDTO dto) {
	    Map<String, Object> result = new HashMap<>();

	    try {
	        MagamDTO resDto = svc.selGoolgleSheet(dto);
	        result.put("httpST", resDto != null ? resDto.getHttp_st() : null);
	    } catch (Exception e) {
	        e.printStackTrace();
	        result.put("error", "처리 중 오류 발생");
	    }

	    return result;
	}
	
	@RequestMapping(value="/main/modifyPatval.do", method = RequestMethod.POST)
    public String modifyPatval(@ModelAttribute("DTO") PatvalDTO dto, Model model) {
		
		System.out.println("modifyPatval 시작했음");
		String err_cd = "0";
		// 처리 로직
        try {
        	System.out.println("modifyPatval 시작했음 1 - getHospCd   확인 - " + dto.getHospCd());
        	System.out.println("modifyPatval 시작했음 2 - getPatId    확인 - " + dto.getPatId());
        	System.out.println("modifyPatval 시작했음 3 - getAdmitDt  확인 - " + dto.getAdmitDt());
        	System.out.println("modifyPatval 시작했음 4 - getMedStart 확인 - " + dto.getMedStart());
        	System.out.println("modifyPatval 시작했음 5 - getUseYn    확인 - " + dto.getUseYn());
        	System.out.println("modifyPatval 시작했음 6 - getUpdUser  확인 - " + dto.getUpdUser());
        	
            dto.setHospCd(dto.getHospCd());
        	dto.setPatId(dto.getPatId());
        	dto.setAdmitDt(dto.getAdmitDt());
        	dto.setMedStart(dto.getMedStart());
        	dto.setUseYn(dto.getUseYn());
        	dto.setUpdUser(dto.getUpdUser());
        	
   		    err_cd = svc.modifyPatval(dto);
   		    
       		model.addAttribute("error_code", err_cd);
 			
 			if  ("10000".equals(err_cd)) {
 				model.addAttribute("error_mess", "작업 1. 저장작업을 정상처리 하지 못했습니다. 담당자에게 문의하세요 !!");
 			} else {
 				model.addAttribute("error_mess", err_cd);
 			}  
        	        	
        } catch (Exception e) {
            
        }
        
        return "jsonView";
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
