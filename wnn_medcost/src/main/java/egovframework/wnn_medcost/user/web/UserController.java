package egovframework.wnn_medcost.user.web;

import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Base64;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.annotation.Resource;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.ss.usermodel.DateUtil;
import org.apache.poi.ss.usermodel.Workbook;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
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

import egovframework.wnn_medcost.util.ResponseObject;
import egovframework.util.ClientInfo;
import egovframework.wnn_medcost.base.model.DiseCdDTO;
import egovframework.wnn_medcost.base.web.BaseController;
import egovframework.wnn_medcost.user.model.DietDTO;
import egovframework.wnn_medcost.user.model.HospConDTO;
import egovframework.wnn_medcost.user.model.HospGrdDTO;
import egovframework.wnn_medcost.user.model.HospMdDTO;
import egovframework.wnn_medcost.user.model.LicnumDTO;
import egovframework.wnn_medcost.user.model.LisenceDTO;
import egovframework.wnn_medcost.user.model.MembrDTO;
import egovframework.wnn_medcost.user.model.UserAuthDTO;
import egovframework.wnn_medcost.user.model.UserDTO;
import egovframework.wnn_medcost.user.model.WardDTO;
import egovframework.wnn_medcost.user.service.UserService;
import egovframework.util.EgovFileScrty;

import org.springframework.ui.ModelMap;
import org.apache.poi.ss.usermodel.CellType;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.WorkbookFactory;

@Controller
@RequestMapping("/user")  // 클래스 레벨에서 기본 경로 설정
public class UserController extends BaseController {

	private static final Logger log = LoggerFactory.getLogger(UserController.class);
	private static Map<String, String> cookie_value = new HashMap<>();
	
	@Resource(name = "UserService") // 서비스 선언
	private UserService svc;

	//메인화면 호출
	@RequestMapping(value = "/" , method = RequestMethod.GET) 
	public String BlankPage(HttpServletRequest request, ModelMap model) throws Exception {

		cookie_value = ClientInfo.getCookie(request);
		try {
			if (cookie_value.get("s_hospid").trim() != null &&
				cookie_value.get("s_hospid").trim() != "" ) {
				return ".main/dashboard";
			} else {
				return "";
			}
		} catch(Exception ex) {
			return "";
		}
	}
	
    //메인화면 호출
	@RequestMapping(value = "/main.do" , method = RequestMethod.GET) 
	public String MainPage(HttpServletRequest request, ModelMap model) throws Exception {

		cookie_value = ClientInfo.getCookie(request);
		try {
			if (cookie_value.get("s_hospid").trim() != null &&
				cookie_value.get("s_hospid").trim() != "" ) {
				return ".main/dashboard";
			} else {
				return "";
			}
		} catch(Exception ex) {
			return "";
		}
	}

	//메인화면 호출
    @RequestMapping(value = "/index.do" , method = RequestMethod.GET) 
	public String IndexPage(HttpServletRequest request, ModelMap model) throws Exception {
		
    	cookie_value = ClientInfo.getCookie(request);		
		try {
			if (cookie_value.get("s_hospid").trim() != null &&
				cookie_value.get("s_hospid").trim() != "" ) {
				return ".main/dashboard";				
			} else {
				return "";
			}	
		} catch(Exception ex) {
			return "";
		}
	}
	
	
	@RequestMapping(value="/dashboard.do")
    public String main1(HttpServletRequest request, ModelMap model) throws Exception {
		
		cookie_value = ClientInfo.getCookie(request);		
		try {
			if (cookie_value.get("s_hospid").trim() != null &&
				cookie_value.get("s_hospid").trim() != "" ) {
				return ".main/dashboard";				
			} else {
				return "";
			}	
		} catch(Exception ex) {
			return "";
		}
		
		
    }
	

	@RequestMapping(value="/main3.do")
    public String main3(HttpServletRequest request, ModelMap model) {

        cookie_value = ClientInfo.getCookie(request);		
		try {
			if (cookie_value.get("s_hospid").trim() != null &&
				cookie_value.get("s_hospid").trim() != "" ) {
				return ".main/main3";				
			} else {
				return "";
			}	
		} catch(Exception ex) {
			return "";
		}
    }
	
	// 로그인 화면
	@RequestMapping(value = "/login.do" , method = RequestMethod.POST)  // 두 경로를 모두 처리
	public String login(@ModelAttribute("DTO") UserDTO dto, HttpServletRequest request,ModelMap model) throws Exception {

		try { 
			
		}catch(Exception ex) {
			model.addAttribute("error_code", "10000"); 
		}
	
		return ".login/LoginWinCT";
	}  

	/* 사용자 로그인 Check */
	@RequestMapping(value="/loginChk.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, String> UserLoginProcess(@ModelAttribute("DTO") UserDTO dto, HttpSession session, HttpServletRequest request, Model model) throws Exception {
		
		System.out.print("시작-java - " + dto.getHospCd() + " - " + dto.getUserId()+ " - " + dto.getPassWd());
		
		Map<String, String> response = new HashMap<>();
		
		try {
			
			// 암호된 상태로 저장 후 EgovFileScrty 풀고 해야됨.
			// 일단은 암호화 안된 상태로 테스트 
			// dto.setPass_wd(EgovFileScrty.encryptPassword(dto.getPass_wd(), dto.getUser_id()));
			
			UserDTO result = svc.userLoginCheck(dto);
			
		    if ("0".equals(result.getUserId())) {
				
		    	response.put("error_code", "10000");
	            response.put("error_mess", "사용자 ID 정보가 존재하지 않습니다.");
	            System.out.print("사용자 ID 정보가 존재하지 않습니다.");
	            
			} else {	
				
				// 암호된 상태로 저장 후 EgovFileScrty 풀고 해야됨.
				// 일단은 암호화 안된 상태로 테스트
				String chkpwd = dto.getPassWd(); // EgovFileScrty.encryptPassword(dto.getPass_wd(), dto.getUser_id());
				
				if (!result.getPassWd().equals(chkpwd)) {
					
					response.put("error_code", "20000");
					response.put("error_mess", "비밀번호를 확인하세요.!");
					System.out.print("비밀번호를 확인하세요.!");
					
	            } else {
					
					session.setAttribute("s_hosp_cd"   , result.getHospCd());   // 병원코드
					session.setAttribute("s_hosp_nm"   , result.getHospNm());   // 병원명칭
					session.setAttribute("s_user_id"   , result.getUserId());   // 사용자ID
					session.setAttribute("s_user_nm"   , result.getUserNm());   // 사용자명					
					session.setAttribute("s_start_dt"  , result.getStartDt());  // 시작일자
					session.setAttribute("s_end_dt"    , result.getEndDt());    // 종료일자					
					session.setAttribute("s_main_gu"   , result.getMainGu()); 	 // 관리자구분(1.위너넷관리자, 2.위너넷사용자, 3.병원관리자, 4.병원사용자)
					session.setAttribute("s_use_not"   , result.getUseNot()); 	 // 사용여부(Y,정상사용자, N.종료사용자, 0.등록안된 사용자)					
					session.setAttribute("s_conn_ip"   , ClientInfo.getClientIP(request));  // 접속IP 주소
					
					System.out.print(ClientInfo.getClientIP(request));
					
					response.put("login_Hosp", result.getHospNm()); // 병원명
					response.put("login_User", result.getUserNm()); // 사용자
					response.put("login_Main", result.getMainGu()); // 관리자구분
					response.put("loginUseYN", result.getUseNot()); // 사용여부
					
					response.put("error_code", "00000");
					response.put("error_mess", "정상적 처리 되었습니다.");
					System.out.print("정상처리");
				}
			}
		}catch(Exception ex) {
			
			log.error(" LOGIN ERROR ! : " + ex.getMessage());
			
			response.put("error_code", "90001");
		    response.put("error_mess", "UserLoginProcess처리시 서버 오류가 발생했습니다.");
		}
	    
	    return response;
	}
	
		
	/* User List */
	
	@RequestMapping(value="/userList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> userList(@ModelAttribute("DTO") UserDTO dto, HttpSession session, HttpServletRequest request, Model model) throws Exception {
		
		System.out.println("시작-java 1- ");
		
		cookie_value = ClientInfo.getCookie(request);		
		try {
			
			if (cookie_value.get("s_hospid").trim() != null &&
				cookie_value.get("s_hospid").trim() != "" ) {
				
				System.out.println("시작-java 2- " + cookie_value.get("s_hospid").trim());
				
				
				dto.setHospCd(cookie_value.get("s_hospid").trim());
				
				System.out.println("시작-java 3- " + dto.getHospCd());				
				
				List<UserDTO> userList = svc.hospitalUserList(dto);
				
				System.out.println("시작-java 4- " );
				
				for(int i = 0; i < userList.size(); i++)
				{
					System.out.println(userList.get(i).getUserId());
				}
				
				System.out.println("시작-java 5- " );
				
				Map<String, Object> response = new HashMap<>();
		        response.put("data", userList);

		        return response;
				
				
			} else {
				dto.setHospCd("");
				return null;
			}	
		} catch(Exception ex) {
			dto.setHospCd("");
			return null;
		}
	}
	@RequestMapping(value="/hospcd.do")
    public String hospcd(HttpServletRequest request, ModelMap model) {

        cookie_value = ClientInfo.getCookie(request);		
		try {
			if (cookie_value.get("s_hospid").trim() != null &&
				cookie_value.get("s_hospid").trim() != "" ) {
				return ".main/mangr/hospcd";				
			} else {
				return "";
			}	
		} catch(Exception ex) {
			return "";
		}
    }	
	@RequestMapping(value="/hospCdList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getHospCdList(@ModelAttribute("DTO") HospMdDTO dto, HttpSession session, HttpServletRequest request, Model model) throws Exception {
		
		System.out.println("병원-java 1- start ");		
		
		cookie_value = ClientInfo.getCookie(request);		
		try {
			
			if (cookie_value.get("s_hospid").trim() != null &&
				cookie_value.get("s_hospid").trim() != "" ) {
	
				dto.setFindData(dto.getFindData()) ;
			
				List<HospMdDTO> hospList = svc.selHospCdList(dto);
		
				System.out.println("병원-java size " + hospList.size());
				
				Map<String, Object> response = new HashMap<>();
		        response.put("data",hospList);

		        System.out.println("병원-java response : " + response);
		        
		        return response;
				
				
			} else {
				return null;
			}	
		} catch(Exception ex) {
			return null;
		}
	}
	@RequestMapping(value="/hospCdInsert.do", method = RequestMethod.POST)
    public ResponseEntity<String> hospInsert(@RequestBody List<HospMdDTO> data) {
		
		System.out.println("Insert 시작했음");
		String returnValue = "OK";
		
		// 처리 로직
        try {
        	
        	for (HospMdDTO dto : data) {
        		String dupchk =   svc.HospCdMstDupChk(dto) ;
        		if ("Y".equals(dupchk)) {
        			return ResponseEntity.status(400).body(dto.getKeyHospCd()); 
        		}
       		    UUID uuid = UUID.randomUUID();
       		    dto.setHospUuid(uuid.toString());
        		svc.insertHospCdMst(dto) ; 
       		    System.out.println("hospCd: " + dto.getKeyHospCd());
            }
        	
            
        	return ResponseEntity.ok(returnValue);   
        	
        } catch (Exception e) {
        	
            return ResponseEntity.status(500).body(e.getMessage());
            
        }
	}
	@RequestMapping(value="/hospCdUpdate.do", method = RequestMethod.POST)
    public ResponseEntity<String> hospCdUpdate(@RequestBody List<HospMdDTO> data) {
	
		System.out.println("Update 시작했음");
		String returnValue = "OK";
		// 처리 로직
        try {
        	
        	for (HospMdDTO dto : data) {
        		svc.updateHospCdMst(dto) ; //이력관리 
       		    System.out.println("hospCd: " + dto.getHospCd());
       		    System.out.println("hospNm: " + dto.getHospNm());
       		    System.out.println("hospUuid: " + dto.getHospUuid());
        		svc.insertHospCdMst(dto) ; 
  	
            }
        	return ResponseEntity.ok(returnValue);   
        	
        } catch (Exception e) {
        	
            return ResponseEntity.status(500).body(e.getMessage());
            
        }
	}
	@RequestMapping(value="/hospCdDelete.do", method = RequestMethod.POST)
    public ResponseEntity<String> hospCdDelete(@RequestBody List<HospMdDTO> data) {
		
		System.out.println("Delete 시작했음");
		String returnValue = "OK";
		// 처리 로직
        try {
        	for (HospMdDTO dto : data) {
        		dto.setKeyHospCd(dto.getKeyHospCd());
        		svc.updateHospCdMst(dto) ; //이력관리 
       		    System.out.println("Key hospCd: " + dto.getKeyHospCd());
              
            }
        	return ResponseEntity.ok(returnValue);   
        	
        } catch (Exception e) {
        	
            return ResponseEntity.status(500).body(e.getMessage());
            
        }
	}	
	//계약정보 
	@RequestMapping(value="/hospContList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> hospContList(@ModelAttribute("DTO") HospConDTO dto, HttpSession session, HttpServletRequest request, Model model) throws Exception {
		
		System.out.println("병원-java 1- start ");		
		
		cookie_value = ClientInfo.getCookie(request);		
		try {
			
			if (cookie_value.get("s_hospid").trim() != null &&
				cookie_value.get("s_hospid").trim() != "" ) {
	
			
				List<HospConDTO> hospContList = svc.selectHospContList(dto);
				
			//	for(HospMdDTO dao: hospList  ) {
			//		System.out.println("병원-java getWardCnt : " + dao.getWardcnt());
			//	}
			
				System.out.println("병원-java size " + hospContList.size());
				
				Map<String, Object> response = new HashMap<>();
		        response.put("data",hospContList);

		        System.out.println("병원-java response : " + response);
		        
		        return response;
				
				
			} else {
				return null;
			}	
		} catch(Exception ex) {
			return null;
		}
	}
	@RequestMapping(value="/hospContInsert.do", method = RequestMethod.POST)
    public ResponseEntity<String> hospconInsert(@RequestBody List<HospConDTO> data) {
		
		System.out.println("Insert 시작했음");
		String returnValue = "OK";
		
		// 처리 로직
        try {
        	
        	for (HospConDTO dto : data) {
        		String dupchk =   svc.HospContDupChk(dto) ;
        		if ("Y".equals(dupchk)) {
        			return ResponseEntity.status(400).body(dto.getHospCd()); 
        		}
        		log.error("🚨 HospConDTO  : " + dto.getHospCd() + "-" + 
        		                                dto.getConactGb() + "-" + 
        				                        dto.getStartDt() + "-" + 
        		                                dto.getEndDt());
        		svc.insertHospCont(dto)   ; 
       		    System.out.println("hospCd: " + dto.getHospCd());
            }
        	
            
        	return ResponseEntity.ok(returnValue);   
        	
        } catch (Exception e) {
        	
            return ResponseEntity.status(500).body(e.getMessage());
            
        }
	}
	@RequestMapping(value="/hospContUpdate.do", method = RequestMethod.POST)
    public ResponseEntity<String> hospContUpdate(@RequestBody List<HospConDTO> data) {
	
		System.out.println("Update 시작했음");
		String returnValue = "OK";
		// 처리 로직
        try {
        	
        	for (HospConDTO dto : data) {
       		    System.out.println("hospCd:     " + dto.getHospCd());
       		    System.out.println("hospUuid:    " + dto.getHospUuid());
        		svc.updateHospCont(dto) ; //이력관리 
        		System.out.println("insert 시작했음");
       		    System.out.println("🚨 insert  : " + dto.getHospCd() + "-" + dto.getConactGb() + "-" 
        		                                   + dto.getStartDt() + '-' + dto.getEndDt());      		    
        		svc.insertHospCont(dto) ; 
  	
            }
        	return ResponseEntity.ok(returnValue);   
        	
        } catch (Exception e) {
        	
            return ResponseEntity.status(500).body(e.getMessage());
            
        }
	}
	@RequestMapping(value="/hospContDelete.do", method = RequestMethod.POST)
    public ResponseEntity<String> hospContDelete(@RequestBody List<HospConDTO> data) {
		
		System.out.println("Delete 시작했음");
		String returnValue = "OK";
		// 처리 로직
        try {
        	for (HospConDTO dto : data) {
        		dto.setHospCd(dto.getKeyhospCd());
        		dto.setStartDt(dto.getKeystartDt());
        		dto.setEndDt(dto.getKeyendDt());
        		dto.setConactGb(dto.getKeyconactGb());
        		svc.updateHospCont(dto) ; //이력관리 
       		    System.out.println("Key hospCd: " + dto.getKeyhospCd());
              
            }
        	return ResponseEntity.ok(returnValue);   
        	
        } catch (Exception e) {
        	
            return ResponseEntity.status(500).body(e.getMessage());
            
        }
	}	
    //사용자등록시 보여주기 
	@RequestMapping(value="/gethospContList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getHospContList(@ModelAttribute("DTO") HospConDTO dto, HttpSession session, HttpServletRequest request, Model model) throws Exception {
		
		System.out.println("병원-java 1- start ");		
		
		cookie_value = ClientInfo.getCookie(request);		
		try {
			
			if (cookie_value.get("s_hospid").trim() != null &&
				cookie_value.get("s_hospid").trim() != "" ) {
	
			
				List<HospConDTO> hospContList = svc.getHospContList(dto);

			
				System.out.println("병원-java size " + hospContList.size());
				
				Map<String, Object> response = new HashMap<>();
		        response.put("data",hospContList);

		        System.out.println("병원-java response : " + response);
		        
		        return response;
				
				
			} else {
				return null;
			}	
		} catch(Exception ex) {
			return null;
		}
	}
	//사용자등록정보 
	@RequestMapping(value="/hospuserList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getuserList(@ModelAttribute("DTO") UserDTO dto, HttpSession session, HttpServletRequest request, Model model) throws Exception {
		
		System.out.println("병원-java 1- start ");		
		
		cookie_value = ClientInfo.getCookie(request);		
		try {
			
			if (cookie_value.get("s_hospid").trim() != null &&
				cookie_value.get("s_hospid").trim() != "" ) {
	
				List<UserDTO> userList = svc.hospitalUserList(dto);
		
				System.out.println("병원-java size " + userList.size());
				
				Map<String, Object> response = new HashMap<>();
		        response.put("data",userList);

		        System.out.println("병원-java response : " + response);
		        
		        return response;
			
				
			} else {
				return null;
			}	
		} catch(Exception ex) {
			return null;
		}
	}
	@RequestMapping(value="/userCdInsert.do", method = RequestMethod.POST)
    public ResponseEntity<String> userCdInsert(@RequestBody List<UserDTO> data) {
		
		System.out.println("Insert 시작했음");
		String returnValue = "OK";
		
		// 처리 로직
        try {
        	
        	for (UserDTO dto : data) {
        		dto.setEncPassWd("");
        		//패스워드통과 했으면 
        		if (!dto.getBfPassWd().isEmpty()) {
    				String encrypted     = EgovFileScrty.encryptPassword(dto.getBfPassWd(), dto.getUserId().trim().toLowerCase());
    				String base64Encoded = Base64.getUrlEncoder().encodeToString(encrypted.getBytes(StandardCharsets.UTF_8));
    				dto.setEncPassWd(base64Encoded);
        		}
        		String dupchk =   svc.UsermstDupChk(dto) ;
        		if ("Y".equals(dupchk)) {
        			return ResponseEntity.status(400).body(dto.getHospCd()); 
        		}
        		svc.insertUsermst(dto) ; 
       		    System.out.println("hospCd: " + dto.getHospCd());
       		    System.out.println("PassWd: " + dto.getEncPassWd());
            }
     	
            
        	return ResponseEntity.ok(returnValue);   
        	
        } catch (Exception e) {
        	
            return ResponseEntity.status(500).body(e.getMessage());
            
        }
	}
	@RequestMapping(value="/userCdUpdate.do", method = RequestMethod.POST)
    public ResponseEntity<String> userCdUpdate(@RequestBody List<UserDTO> data) {
	
		System.out.println("Update 시작했음");
		String returnValue = "OK";
		// 처리 로직
        try {
        	
        	for (UserDTO dto : data) {
        		//기존자료 ATION_YN = 'N'
        		svc.updateUsermst(dto) ; //이력관리 
       		    System.out.println("hospCd: "   + dto.getHospCd());
	       		 dto.setEncPassWd("");
	     		//패스워드통과 했으면 
	     		if (!dto.getBfPassWd().isEmpty()) {
	     			String encrypted     = EgovFileScrty.encryptPassword(dto.getBfPassWd(), dto.getUserId().trim().toLowerCase());
    				String base64Encoded = Base64.getUrlEncoder().encodeToString(encrypted.getBytes(StandardCharsets.UTF_8));
    				dto.setEncPassWd(base64Encoded);
	     		}
	     		//입력루틴 사제는 없음   
       		    svc.insertUsermst(dto) ; 
  	
            }
        	return ResponseEntity.ok(returnValue);   
        	
        } catch (Exception e) {
        	
            return ResponseEntity.status(500).body(e.getMessage());
            
        }
	}
	@RequestMapping(value="/userCdDelete.do", method = RequestMethod.POST)
    public ResponseEntity<String> userCdDelete(@RequestBody List<UserDTO> data) {
		
		System.out.println("Delete 시작했음");
		String returnValue = "OK";
		// 처리 로직
        try {
        	for (UserDTO dto : data) {
        		dto.setHospCd(dto.getKeyurhospCd());
        		dto.setStartDt(dto.getKeyurstartDt());
        		dto.setUserId(dto.getKeyuruserId());
     		
        		svc.updateUsermst(dto) ; //이력관리 
       		    System.out.println("Key hospCd: " + dto.getKeyurhospCd());
              
            }
        	return ResponseEntity.ok(returnValue);   
        	
        } catch (Exception e) {
        	
            return ResponseEntity.status(500).body(e.getMessage());
            
        }
	}	
	@RequestMapping(value="/useridupchk.do", method = RequestMethod.POST)
	public ResponseEntity<String> useridupck(@RequestBody UserDTO dto) {
	    System.out.println("useridupck 시작했음");
	    String returnValue = "OK";

	    try {
	        // 아이디 중복 체크
	        String dupchk = svc.UseridDupChk(dto);
	        System.out.println("Key hospCd: " + dto.getKeyurhospCd());

	        if ("Y".equals(dupchk)) {
	            return ResponseEntity.status(400).body("기존사용아이디가 존재합니다.");
	        }

	        return ResponseEntity.ok(returnValue);
	        
	    } catch (Exception e) {
	        return ResponseEntity.status(500).body("서버 오류: " + e.getMessage());
	    }
	}
	@RequestMapping(value="/dietcd.do")
    public String dietcd(HttpServletRequest request, ModelMap model) {

        cookie_value = ClientInfo.getCookie(request);		
		try {
			if (cookie_value.get("s_hospid").trim() != null &&
				cookie_value.get("s_hospid").trim() != "" ) {
				return ".main/user/dietcd";				
			} else {
				return "";
			}	
		} catch(Exception ex) {
			return "";
		}
    }	 	
	@RequestMapping(value="/dietCdList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getdietCdList(@ModelAttribute("DTO") DietDTO dto, HttpSession session, HttpServletRequest request, Model model) throws Exception {
		
		System.out.println("수가-java 1- start ");		
		
		cookie_value = ClientInfo.getCookie(request);		
		try {
			
			if (cookie_value.get("s_hospid").trim() != null &&
				cookie_value.get("s_hospid").trim() != "" ) {
				
				dto.setFindData(dto.getFindData());
				dto.setDietGb(dto.getDietGb());
				
				List<DietDTO> dietList = svc.getDietcdList(dto);
				
				System.out.println("수가-java size " + dietList.size());
				
				Map<String, Object> response = new HashMap<>();
		        response.put("data",dietList);

		        System.out.println("수가-java response : " + response);
		        
		        return response;
				
				
			} else {
				return null;
			}	
		} catch(Exception ex) {
			return null;
		}
	}
	
	@RequestMapping(value="/dietCdInsert.do", method = RequestMethod.POST)
    public ResponseEntity<String> dietCdInsert(@RequestBody List<DietDTO> data) {
		
		System.out.println("Insert 시작했음");
		String returnValue = "OK";
		// 처리 로직
        try {
        	for (DietDTO dto : data) {
        		String dupchk =   svc.DietcdDupChk(dto) ;
        		if ("Y".equals(dupchk)) {
        			return ResponseEntity.status(400).body(dto.getDietGb()); 
        		}
        		svc.insertDietcd(dto) ; 
       		    System.out.println("diet Code: " + dto.getDietGb());
       		    System.out.println("HospCd: " + dto.getHospCd());
            }

         
        	return ResponseEntity.ok(returnValue);   
        	
        } catch (Exception e) {
        	
            return ResponseEntity.status(500).body(e.getMessage());
            
        }
	}
	@RequestMapping(value="/dietCdUpdate.do", method = RequestMethod.POST)
    public ResponseEntity<String> dietCdUpdate(@RequestBody List<DietDTO> data) {
	
		System.out.println("Update 시작했음");
		String returnValue = "OK";
		// 처리 로직
        try {
        	
        	for (DietDTO dto : data) {
        		svc.updateDietcd(dto) ; //이력관리 
            	svc.insertDietcd(dto) ; 
       		    System.out.println("diet Code: " + dto.getDietGb());
       		    System.out.println("HospCd: " + dto.getHospCd());
     	
            }
        	return ResponseEntity.ok(returnValue);   
        	
        } catch (Exception e) {
        	
            return ResponseEntity.status(500).body(e.getMessage());
            
        }
	}
	@RequestMapping(value="/dietCdDelete.do", method = RequestMethod.POST)
    public ResponseEntity<String> dietCdDelete(@RequestBody List<DietDTO> data) {
		
		System.out.println("Delete 시작했음");
		String returnValue = "OK";
		// 처리 로직
        try {
        	for (DietDTO dto : data) {
        		dto.setDietGb(dto.getKeydietGb()); 
        		dto.setHospCd(dto.getKeyhospCd()); 
        		dto.setStartDt(dto.getKeyStartDt()); 
        		svc.updateDietcd(dto) ; //이력관리 
       		    System.out.println("diet Code: " + dto.getDietGb());
       		    System.out.println("HospCd: "    + dto.getHospCd());
              
            }
        	return ResponseEntity.ok(returnValue);   
        	
        } catch (Exception e) {
        	
            return ResponseEntity.status(500).body(e.getMessage());
            
        }
	}
	//사용자개별등록 
	@RequestMapping(value="/pusercd.do")
    public String puserCd(HttpServletRequest request, ModelMap model) {

        cookie_value = ClientInfo.getCookie(request);		
		try {
			if (cookie_value.get("s_hospid").trim() != null &&
				cookie_value.get("s_hospid").trim() != "" ) {
				return ".main/user/usercd";				
			} else {
				return "";
			}	
		} catch(Exception ex) {
			return "";
		}
    }	
	@RequestMapping(value="/puserCdList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> puserCdList(@ModelAttribute("DTO") UserDTO dto, HttpSession session, HttpServletRequest request, Model model) throws Exception {
		
		System.out.println("병원-java 1- start ");		
		
		cookie_value = ClientInfo.getCookie(request);		
		try {
			
			if (cookie_value.get("s_hospid").trim() != null &&
				cookie_value.get("s_hospid").trim() != "" ) {
	
			
				List<UserDTO> userList = svc.getUserCdList(dto);
		
				System.out.println("병원-java size " + userList.size());
				
				Map<String, Object> response = new HashMap<>();
		        response.put("data",userList);

		        System.out.println("병원-java response : " + response);
		        
		        return response;
				
				
			} else {
				return null;
			}	
		} catch(Exception ex) {
			return null;
		}
	}	
	@RequestMapping(value="/puserCdInsert.do", method = RequestMethod.POST)
    public ResponseEntity<String> puserCdInsert(@RequestBody List<UserDTO> data) {
		
		System.out.println("Insert 시작했음");
		String returnValue = "OK";
		
		// 처리 로직
        try {
        	
        	for (UserDTO dto : data) {
        		dto.setEncPassWd("");
        		//패스워드통과 했으면 
        		if (!dto.getBfPassWd().isEmpty()) {
	     			String encrypted     = EgovFileScrty.encryptPassword(dto.getBfPassWd(), dto.getUserId().trim().toLowerCase());
    				String base64Encoded = Base64.getUrlEncoder().encodeToString(encrypted.getBytes(StandardCharsets.UTF_8));
    				dto.setEncPassWd(base64Encoded);        			
        		}
        		String dupchk =   svc.UserCdDupChk(dto) ;
        		if ("Y".equals(dupchk)) {
        			return ResponseEntity.status(400).body(dto.getHospCd()); 
        		}
        		svc.insertUserCd(dto) ; 
       		    System.out.println("hospCd: " + dto.getHospCd());
       		    System.out.println("PassWd: " + dto.getEncPassWd());
            }
     	
            
        	return ResponseEntity.ok(returnValue);   
        	
        } catch (Exception e) {
        	
            return ResponseEntity.status(500).body(e.getMessage());
            
        }
	}
	@RequestMapping(value="/puserCdUpdate.do", method = RequestMethod.POST)
    public ResponseEntity<String> puserCdUpdate(@RequestBody List<UserDTO> data) {
	
		System.out.println("Update 시작했음");
		String returnValue = "OK";
		// 처리 로직
        try {
        	
        	for (UserDTO dto : data) {
        		//기존자료 ATION_YN = 'N'
        		svc.updateUserCd(dto) ; //이력관리 
       		    System.out.println("hospCd: "   + dto.getHospCd());
	       		 dto.setEncPassWd("");
	     		//패스워드통과 했으면 
	     		if (!dto.getBfPassWd().isEmpty()) {
	     			String encrypted     = EgovFileScrty.encryptPassword(dto.getBfPassWd(), dto.getUserId().trim().toLowerCase());
    				String base64Encoded = Base64.getUrlEncoder().encodeToString(encrypted.getBytes(StandardCharsets.UTF_8));
    				dto.setEncPassWd(base64Encoded);	     			
	     		}
	     		//입력루틴 사제는 없음   
       		    svc.insertUserCd(dto) ; 
  	
            }
        	return ResponseEntity.ok(returnValue);   
        	
        } catch (Exception e) {
        	
            return ResponseEntity.status(500).body(e.getMessage());
            
        }
	}
	@RequestMapping(value="/puserCdDelete.do", method = RequestMethod.POST)
    public ResponseEntity<String> puserCdDelete(@RequestBody List<UserDTO> data) {
		
		System.out.println("Delete 시작했음");
		String returnValue = "OK";
		// 처리 로직
        try {
        	for (UserDTO dto : data) {
        		dto.setHospCd(dto.getKeyurhospCd());
        		dto.setStartDt(dto.getKeyurstartDt());
        		dto.setUserId(dto.getKeyuruserId());
     		
        		svc.updateUserCd(dto) ; //이력관리 
       		    System.out.println("Key hospCd: " + dto.getKeyurhospCd());
              
            }
        	return ResponseEntity.ok(returnValue);   
        	
        } catch (Exception e) {
        	
            return ResponseEntity.status(500).body(e.getMessage());
            
        }
	}	
	@RequestMapping(value="/puserCddupchk.do", method = RequestMethod.POST)
	public ResponseEntity<String> usercdupck(@RequestBody UserDTO dto) {
	    System.out.println("useridupck 시작했음");
	    String returnValue = "OK";

	    try {
	        // 아이디 중복 체크
	        String dupchk = svc.UserCdDupChk(dto);
	        System.out.println("Key hospCd: " + dto.getKeyurhospCd());

	        if ("Y".equals(dupchk)) {
	            return ResponseEntity.status(400).body("기존사용아이디가 존재합니다.");
	        }

	        return ResponseEntity.ok(returnValue);
	        
	    } catch (Exception e) {
	        return ResponseEntity.status(500).body("서버 오류: " + e.getMessage());
	    }
	}	
	/* 회원가입시 병원검색  */
	@RequestMapping(value= "/ctl_hospList.do", method = RequestMethod.POST)
	@ResponseBody
	public String ctl_hospList(@ModelAttribute("DTO") HospMdDTO dto, HttpServletRequest request, Model model) throws Exception {
	try {
		List<HospMdDTO> result = svc.selHospCdList(dto) ;
		model.addAttribute("resultLst", result); 
		model.addAttribute("resultCnt", result.size());  
		model.addAttribute("error_code", "0"); 
		
	}catch(Exception ex) {
		log.error(" HospMdDTO ERROR ! : "+ ex.getMessage());
		model.addAttribute("error_code", "10000"); 
		}
		return "jsonView";
	}
	/*병원정보 공통검색 */
	@RequestMapping(value= "/phospList.do", method = RequestMethod.POST)
	@ResponseBody  // ✅ JSON 응답을 위해 추가
	public Map<String, Object> phospList(@ModelAttribute("DTO") HospMdDTO dto) throws Exception {
	    Map<String, Object> response = new HashMap<>() ;
	try {
		dto.setWnnchk("N") ;//병원검색하명 등록시 위너넷은 제외한다 
		List<HospMdDTO> result = svc.selHospCdList(dto) ;

		if (result == null || result.isEmpty()) {
            response.put("error_code", "10001");  // 데이터 없음
            response.put("message", "No data found");
        } else {
            response.put("resultLst", result);
            response.put("resultCnt", result.size());
            response.put("error_code", "0");  // 성공
        }

		
	}catch(Exception ex) {
        log.error("🚨 HospMdDTO ERROR ! : " + ex.getMessage());
        response.put("error_code", "10000");
        response.put("message", ex.getMessage());
		}
        return response;
	}			
	@RequestMapping(value="/license.do")
    public String license(HttpServletRequest request, ModelMap model) {

        cookie_value = ClientInfo.getCookie(request);		
		try {
			if (cookie_value.get("s_hospid").trim() != null &&
				cookie_value.get("s_hospid").trim() != "" ) {
				return ".main/user/license";				
			} else {
				return "";
			}	
		} catch(Exception ex) {
			return "";
		}
    }
	//면허등록관리 
	@RequestMapping(value="/licenseCdList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getlicenseCdList(@ModelAttribute("DTO") LisenceDTO dto, HttpSession session, HttpServletRequest request, Model model) throws Exception {
		
		System.out.println("수가-java 1- start ");		
		
		cookie_value = ClientInfo.getCookie(request);		
		try {
			
			if (cookie_value.get("s_hospid").trim() != null &&
				cookie_value.get("s_hospid").trim() != "" ) {
				
				dto.setFindData(dto.getFindData());
			
				List<LisenceDTO> LisencetList = svc.getLisenceCdList(dto);
				
				System.out.println("면허등록-java size " + LisencetList.size());
				
				Map<String, Object> response = new HashMap<>();
		        response.put("data",LisencetList);

		        System.out.println("수가-java response : " + response);
		        
		        return response;
				
				
			} else {
				return null;
			}	
		} catch(Exception ex) {
			return null;
		}
	}
	
	@RequestMapping(value="/licenseCdInsert.do", method = RequestMethod.POST)
    public ResponseEntity<String> licenseCdInsert(@RequestBody List<LisenceDTO> data) {
		
		System.out.println("Insert 시작했음");
		String returnValue = "OK";
		// 처리 로직
        try {
        	for (LisenceDTO dto : data) {
        		String dupchk =   svc.LisenceCdDupChk(dto) ;
        		if ("Y".equals(dupchk)) {
        			return ResponseEntity.status(400).body(dto.getLicNum()); 
        		}
       		    System.out.println("licCode: "  + dto.getLicNum());
       		    System.out.println("HospCd: "   + dto.getHospCd());
       		    System.out.println("ipDt: "   + dto.getIpDt());
        		svc.insertLisenceCd(dto) ; 
            }
         
        	return ResponseEntity.ok(returnValue);   
        	
        } catch (Exception e) {
        	
            return ResponseEntity.status(500).body(e.getMessage());
            
        }
	}
	@RequestMapping(value="/licenseCdUpdate.do", method = RequestMethod.POST)
    public ResponseEntity<String> licenseCdUpdate(@RequestBody List<LisenceDTO> data) {
	
		System.out.println("Update 시작했음");
		String returnValue = "OK";
		// 처리 로직
        try {
        	
        	for (LisenceDTO dto : data) {
        		svc.updateLisenceCd(dto) ; //이력관리 
       		    System.out.println("licCode: " + dto.getLicNum());
       		    System.out.println("HospCd: " + dto.getHospCd());
       		    System.out.println("ipDt: "   + dto.getIpDt());
       		    System.out.println("LIC_TYPE: "   + dto.getLicType());
       		    System.out.println("TE_DT: "   + dto.getTeDt());
       		    System.out.println("USE_YN: "   + dto.getUseYn());
        		svc.insertLisenceCd(dto) ; 
     	
            }
        	return ResponseEntity.ok(returnValue);   
        	
        } catch (Exception e) {
        	
            return ResponseEntity.status(500).body(e.getMessage());
            
        }
	}
	@RequestMapping(value="/licenseCdDelete.do", method = RequestMethod.POST)
    public ResponseEntity<String> licenseCdDelete(@RequestBody List<LisenceDTO> data) {
		
		System.out.println("Delete 시작했음");
		String returnValue = "OK";
		// 처리 로직
        try {
        	for (LisenceDTO dto : data) {
        		dto.setLicNum(dto.getKeylicNum()); 
        		dto.setHospCd(dto.getKeyhospCd()); 
        		dto.setIpDt(dto.getKeyipDt()); 
        		svc.updateLisenceCd(dto) ; //이력관리 
       		    System.out.println("licCode: " + dto.getLicNum());
       		    System.out.println("HospCd: "    + dto.getHospCd());
              
            }
        	return ResponseEntity.ok(returnValue);   
        	
        } catch (Exception e) {
        	
            return ResponseEntity.status(500).body(e.getMessage());
            
        }
	}
	//병동현황등록  
	@RequestMapping(value="/wardcd.do")
    public String wardcd(HttpServletRequest request, ModelMap model) {

        cookie_value = ClientInfo.getCookie(request);		
		try {
			if (cookie_value.get("s_hospid").trim() != null &&
				cookie_value.get("s_hospid").trim() != "" ) {
				return ".main/user/wardcd";				
			} else {
				return "";
			}	
		} catch(Exception ex) {
			return "";
		}
    }		
	@RequestMapping(value="/wardCdList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> WardCdList(@ModelAttribute("DTO") WardDTO dto, HttpSession session, HttpServletRequest request, Model model) throws Exception {
		
		System.out.println("수가-java 1- start ");		
		
		cookie_value = ClientInfo.getCookie(request);		
		try {
			
			if (cookie_value.get("s_hospid").trim() != null &&
				cookie_value.get("s_hospid").trim() != "" ) {
				
				dto.setFindData(dto.getFindData());
			
				List<WardDTO> WardcdList = svc.getWardCdList(dto);
				
				System.out.println("면허등록-java size " + WardcdList.size());
				
				Map<String, Object> response = new HashMap<>();
		        response.put("data",WardcdList);

		        System.out.println("수가-java response : " + response);
		        
		        return response;
				
				
			} else {
				return null;
			}	
		} catch(Exception ex) {
			return null;
		}
	}
	
	@RequestMapping(value="/wardCdInsert.do", method = RequestMethod.POST)
    public ResponseEntity<String> wardCdInsert(@RequestBody List<WardDTO> data) {
		
		System.out.println("Insert 시작했음");
		String returnValue = "OK";
		// 처리 로직
        try {
        	for (WardDTO dto : data) {
        		String dupchk =   svc.WardCdDupChk(dto) ;
        		if ("Y".equals(dupchk)) {
        			return ResponseEntity.status(400).body(dto.getHospCd()); 
        		}
       		    System.out.println("HospCd: "  + dto.getHospCd());
        		svc.insertWardCd(dto) ; 
            }
         
        	return ResponseEntity.ok(returnValue);   
        	
        } catch (Exception e) {
        	
            return ResponseEntity.status(500).body(e.getMessage());
            
        }
	}
	@RequestMapping(value="/wardCdUpdate.do", method = RequestMethod.POST)
    public ResponseEntity<String> wardCdUpdate(@RequestBody List<WardDTO> data) {
	
		System.out.println("Update 시작했음");
		String returnValue = "OK";
		// 처리 로직
        try {
        	
        	for (WardDTO dto : data) {
        		svc.updateWardCd(dto) ; //이력관리 
       		    System.out.println("HospCd: " + dto.getHospCd());

        		svc.insertWardCd(dto) ; 
     	
            }
        	return ResponseEntity.ok(returnValue);   
        	
        } catch (Exception e) {
        	
            return ResponseEntity.status(500).body(e.getMessage());
            
        }
	}
	@RequestMapping(value="/wardCdDelete.do", method = RequestMethod.POST)
    public ResponseEntity<String> wardCdDelete(@RequestBody List<WardDTO> data) {
		
		System.out.println("Delete 시작했음");
		String returnValue = "OK";
		// 처리 로직
        try {
        	for (WardDTO dto : data) {
        		dto.setHospCd(dto.getKeyhospCd()); 
        		dto.setStartYm(dto.getKeystartYm()); 
        		svc.updateWardCd(dto) ; //이력관리 

       		    System.out.println("HospCd: "    + dto.getHospCd());
              
            }
        	return ResponseEntity.ok(returnValue);   
        	
        } catch (Exception e) {
        	
            return ResponseEntity.status(500).body(e.getMessage());
            
        }
	}
	//사용자 사용자권한관리 등록 
	@RequestMapping(value="/userauthcd.do")
    public String userauthcd(HttpServletRequest request, ModelMap model) {

        cookie_value = ClientInfo.getCookie(request);		
		try {
			if (cookie_value.get("s_hospid").trim() != null &&
				cookie_value.get("s_hospid").trim() != "" ) {
				return ".main/user/userauthcd";				
			} else {
				return "";
			}	
		} catch(Exception ex) {
			return "";
		}
    }	
	@RequestMapping(value="/userauthCdList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> userauthCdList(@ModelAttribute("DTO") UserAuthDTO dto, HttpSession session, HttpServletRequest request, Model model) throws Exception {
		
		System.out.println("병원-java 1- start ");		
		
		cookie_value = ClientInfo.getCookie(request);		
		try {
			
			if (cookie_value.get("s_hospid").trim() != null &&
				cookie_value.get("s_hospid").trim() != "" ) {
	
			
				List<UserAuthDTO> userauthList = svc.getUserAuthCdList(dto);
		
				System.out.println("병원-java size " + userauthList.size());
				
				Map<String, Object> response = new HashMap<>();
		        response.put("data",userauthList);

		        System.out.println("병원-java response : " + response);
		        
		        return response;
				
				
			} else {
				return null;
			}	
		} catch(Exception ex) {
			return null;
		}
	}	
	@RequestMapping(value="/userauthCdInsert.do", method = RequestMethod.POST)
    public ResponseEntity<String> userauthCdInsert(@RequestBody List<UserAuthDTO> data) {
		
		System.out.println("Insert 시작했음");
		String returnValue = "OK";
		
		// 처리 로직
        try {
        	
        	for (UserAuthDTO dto : data) {
        		String dupchk =   svc.UserAuthCdDupChk(dto) ;
        		if ("Y".equals(dupchk)) {
        			return ResponseEntity.status(400).body(dto.getUserId()); 
        		}        		
        		svc.insertUserAuthCd(dto) ; 
       		    System.out.println("hospCd: " + dto.getHospCd());
            }
     	
            
        	return ResponseEntity.ok(returnValue);   
        	
        } catch (Exception e) {
        	
            return ResponseEntity.status(500).body(e.getMessage());
            
        }
	}
	@RequestMapping(value="/userauthCdUpdate.do", method = RequestMethod.POST)
    public ResponseEntity<String> userauthCdUpdate(@RequestBody List<UserAuthDTO> data) {
	
		System.out.println("Update 시작했음");
		String returnValue = "OK";
		// 처리 로직
        try {
        	
        	for (UserAuthDTO dto : data) {
        		//기존자료 ATION_YN = 'N'
        		svc.updateUserAuthCd(dto) ; //이력관리 
       		    System.out.println("hospCd: "   + dto.getHospCd());
	     		//입력루틴 사제는 없음   
       		    svc.insertUserAuthCd(dto) ; 
  	
            }
        	return ResponseEntity.ok(returnValue);   
        	
        } catch (Exception e) {
        	
            return ResponseEntity.status(500).body(e.getMessage());
            
        }
	}
	@RequestMapping(value="/userauthCdDelete.do", method = RequestMethod.POST)
    public ResponseEntity<String> userauthCdDelete(@RequestBody List<UserAuthDTO> data) {
		
		System.out.println("Delete 시작했음");
		String returnValue = "OK";
		// 처리 로직
        try {
        	for (UserAuthDTO dto : data) {
        		dto.setHospCd(dto.getKeyhospCd());
        		dto.setUserId(dto.getKeyuserId());
     		
        		svc.updateUserAuthCd(dto) ; //이력관리 
       		    System.out.println("Key hospCd: " + dto.getKeyhospCd());
              
            }
        	return ResponseEntity.ok(returnValue);   
        	
        } catch (Exception e) {
        	
            return ResponseEntity.status(500).body(e.getMessage());
            
        }
	}	
	@RequestMapping(value="/userauthCddupchk.do", method = RequestMethod.POST)
	public ResponseEntity<String> userauthCddupck(@RequestBody UserAuthDTO dto) {
	    System.out.println("useridupck 시작했음");
	    String returnValue = "OK";

	    try {
	        // 아이디 중복 체크
	        String dupchk = svc.UserAuthCdDupChk(dto);
	        System.out.println("Key hospCd: " + dto.getKeyhospCd());

	        if ("Y".equals(dupchk)) {
	            return ResponseEntity.status(400).body("기존사용아이디가 존재합니다.");
	        }

	        return ResponseEntity.ok(returnValue);
	        
	    } catch (Exception e) {
	        return ResponseEntity.status(500).body("서버 오류: " + e.getMessage());
	    }
	}	
	//회원가입현황관리 
	@RequestMapping(value="/mbrcd.do")
    public String mbrcd(HttpServletRequest request, ModelMap model) {

        cookie_value = ClientInfo.getCookie(request);		
		try {
			if (cookie_value.get("s_hospid").trim() != null &&
				cookie_value.get("s_hospid").trim() != "" ) {
				return ".main/user/mbrcd";				
			} else {
				return "";
			}	
		} catch(Exception ex) {
			return "";
		}
    }	
	@RequestMapping(value="/membrList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> membrList(@ModelAttribute("DTO") MembrDTO dto, HttpSession session, HttpServletRequest request, Model model) throws Exception {
		
		System.out.println("수가-java 1- start ");		
		
		cookie_value = ClientInfo.getCookie(request);		
		try {
			
			if (cookie_value.get("s_hospid").trim() != null &&
				cookie_value.get("s_hospid").trim() != "" ) {
				
				dto.setFindData(dto.getFindData());
			
				List<MembrDTO> memberList = svc.getMemberList(dto);
				
				System.out.println("면허등록-java size " + memberList.size());
				
				Map<String, Object> response = new HashMap<>();
		        response.put("data",memberList);

		        System.out.println("수가-java response : " + response);
		        
		        return response;
				
				
			} else {
				return null;
			}	
		} catch(Exception ex) {
			return null;
		}
	}	
	//위너넷 사용자권한관리 등록 
	@RequestMapping(value="/wnnauthcd.do")
    public String wnnauthcd(HttpServletRequest request, ModelMap model) {

        cookie_value = ClientInfo.getCookie(request);		
		try {
			if (cookie_value.get("s_hospid").trim() != null &&
				cookie_value.get("s_hospid").trim() != "" ) {
				return ".main/user/wnnauthcd";				
			} else {
				return "";
			}	
		} catch(Exception ex) {
			return "";
		}
    }	
	//의사.간호사 엑셀업로드   
	@RequestMapping(value="/licexcel.do")
    public String licexcel(HttpServletRequest request, ModelMap model) {

        cookie_value = ClientInfo.getCookie(request);		
		try {
			if (cookie_value.get("s_hospid").trim() != null &&
				cookie_value.get("s_hospid").trim() != "" ) {
				return ".main/user/licexcel";				
			} else {
				return "";
			}	
		} catch(Exception ex) {
			return "";
		}
    }		
	//엑셀자료 미리보기
    @RequestMapping(value = "/previewExcel.do", method = RequestMethod.POST)
    public void previewExcel(
            @RequestParam("excelFile") MultipartFile file,
            HttpSession session,
            HttpServletResponse resp) throws Exception {

        resp.setContentType("application/json; charset=UTF-8");

        Map<String, Object> response = new LinkedHashMap<>();
        List<Map<String, Object>> dataList = new ArrayList<>();
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMdd");

        // 의사 양식 (순서대로, 중복 컬럼은 변환 후 기준)
        List<String> doctorTemplate = Arrays.asList(
            "면허종별", "의사구분", "의사형태", "성명", "주민등록번호", "근무형태",
            "면허번호", "면허취득일자", "입사일자", "구분", "시작일자", "종료일자",
            "대체자명", "대체시작일자", "대체종료일자", "병동명", "단위",
            "근무시작일자", "근무종료일자", "전담여부",
            "최종근무일", "이력조회", "인력변동", "변동이유"
        );
        // 간호사 양식 (순서대로)
        List<String> nurseTemplate = Arrays.asList(
            "면허종별", "세부종별", "근무형태", "직책", "성명", "주민등록번호",
            "간호등급여부", "면허번호", "면허취득일자", "입사일자", "구분", "시작일자",
            "종료일자", "대체자", "대체시작일자", "대체종료일자", "병동명", "단위",
            "근무시작일자", "근무종료일자", "전담여부",
            "최종근무일", "이력조회", "인력변동", "변동이유"
        );
        // 인식 가능한 전체 컬럼 (두 양식 합침)
        List<String> allKnownHeaders = new ArrayList<>();
        allKnownHeaders.addAll(doctorTemplate);
        for (String h : nurseTemplate) {
            if (!allKnownHeaders.contains(h)) allKnownHeaders.add(h);
        }
        if (!allKnownHeaders.contains("대체자")) allKnownHeaders.add("대체자");
        if (!allKnownHeaders.contains("대체자명")) allKnownHeaders.add("대체자명");

        try (Workbook workbook = WorkbookFactory.create(file.getInputStream())) {
            Sheet sheet = workbook.getSheetAt(0);

            // 헤더 행 자동 탐색: 키워드가 2개 이상 포함된 행을 헤더로 판단
            int headerRowIdx = -1;
            List<String> headerKeywords = Arrays.asList("면허종별", "성명", "면허번호", "입사일자");
            for (int i = 0; i <= Math.min(5, sheet.getLastRowNum()); i++) {
                Row r = sheet.getRow(i);
                if (r == null) continue;
                int keywordHit = 0;
                for (int j = 0; j < r.getLastCellNum(); j++) {
                    Cell c = r.getCell(j);
                    if (c != null && c.getCellTypeEnum() == CellType.STRING) {
                        String val = c.getStringCellValue().trim();
                        if (headerKeywords.contains(val)) keywordHit++;
                    }
                }
                if (keywordHit >= 2) {
                    headerRowIdx = i;
                    break;
                }
            }
            if (headerRowIdx < 0) headerRowIdx = 0;
            int dataStartIdx = headerRowIdx + 1;

            // 헤더 위에 제목행이 있었으면 알림
            if (headerRowIdx > 0) {
                Row titleRow = sheet.getRow(0);
                response.put("titleRowDetected", true);
                response.put("titleRowText", titleRow != null && titleRow.getCell(0) != null ? titleRow.getCell(0).toString().trim() : "");
            }

            Row headerRow = sheet.getRow(headerRowIdx);
            if (headerRow == null) throw new IllegalArgumentException("엑셀 헤더 행이 비어 있습니다.");

            // 실제 헤더 추출
            List<String> actualHeaders = new ArrayList<>();
            boolean afterWard = false;
            for (int j = 0; j < headerRow.getLastCellNum(); j++) {
                Cell headerCell = headerRow.getCell(j);
                String headerName = "Column" + j;
                if (headerCell != null) {
                    try {
                        if (headerCell.getCellTypeEnum() == CellType.STRING) {
                            headerName = headerCell.getStringCellValue().trim();
                        } else {
                            headerName = headerCell.toString().trim();
                        }
                    } catch (Exception e) {
                        headerName = headerCell.toString().trim();
                    }
                }

                // 병동명 이후 플래그
                if ("병동명".equals(headerName)) afterWard = true;

                // 의사 파일: 병동명 뒤의 중복 "시작일자"/"종료일자"를 "근무시작일자"/"근무종료일자"로 변환
                if (afterWard && "시작일자".equals(headerName) && actualHeaders.contains("시작일자")) {
                    headerName = "근무시작일자";
                } else if (afterWard && "종료일자".equals(headerName) && actualHeaders.contains("종료일자")) {
                    headerName = "근무종료일자";
                }

                actualHeaders.add(headerName);
            }

            // 템플릿 매칭: 의사/간호사 양식 순서대로 일치하는지 확인
            boolean isDoctorMatch = actualHeaders.equals(doctorTemplate);
            boolean isNurseMatch = actualHeaders.equals(nurseTemplate);
            String matchedType = isDoctorMatch ? "의사" : (isNurseMatch ? "간호사" : "");

            // 각 컬럼 인식 여부 체크
            List<Map<String, Object>> headerValidation = new ArrayList<>();
            int matchCount = 0;
            for (String actual : actualHeaders) {
                Map<String, Object> hv = new LinkedHashMap<>();
                hv.put("name", actual);
                boolean matched = allKnownHeaders.contains(actual);
                hv.put("valid", matched);
                if (matched) matchCount++;
                headerValidation.add(hv);
            }

            // 인식 불가 컬럼
            List<String> unknownHeaders = new ArrayList<>();
            for (String actual : actualHeaders) {
                if (!allKnownHeaders.contains(actual)) {
                    unknownHeaders.add(actual);
                }
            }

            // 양식이 정확히 일치하면 통과, 아니면 가장 가까운 양식과 비교
            List<String> missingHeaders = new ArrayList<>();
            boolean formatValid = isDoctorMatch || isNurseMatch;

            if (!formatValid && unknownHeaders.isEmpty()) {
                int doctorDiff = 0, nurseDiff = 0;
                for (String h : doctorTemplate) { if (!actualHeaders.contains(h)) doctorDiff++; }
                for (String h : nurseTemplate) { if (!actualHeaders.contains(h)) nurseDiff++; }
                List<String> closestTemplate = (doctorDiff <= nurseDiff) ? doctorTemplate : nurseTemplate;
                matchedType = (doctorDiff <= nurseDiff) ? "의사" : "간호사";

                for (String exp : closestTemplate) {
                    if (!actualHeaders.contains(exp)) {
                        missingHeaders.add(exp);
                    }
                }
                if (missingHeaders.isEmpty()) {
                    formatValid = true;
                }
            }

            response.put("headerValidation", headerValidation);
            response.put("actualHeaders", actualHeaders);
            response.put("missingHeaders", missingHeaders);
            response.put("unknownHeaders", unknownHeaders);
            response.put("matchCount", matchCount);
            response.put("totalColumns", actualHeaders.size());
            response.put("formatValid", formatValid);
            response.put("matchedType", matchedType);

            // 양식이 틀려도 데이터는 항상 읽어서 반환
            for (int i = dataStartIdx; i <= sheet.getLastRowNum(); i++) {
                Row row = sheet.getRow(i);
                if (row == null) continue;

                Map<String, Object> map = new LinkedHashMap<>();
                for (int j = 0; j < actualHeaders.size(); j++) {
                    Cell cell = row.getCell(j);
                    String key = actualHeaders.get(j);
                    String value = "";

                    if (cell != null) {
                        try {
                            if (DateUtil.isCellDateFormatted(cell)) {
                                value = dateFormat.format(cell.getDateCellValue());
                            } else {
                                value = cell.toString().trim();
                            }
                        } catch (Exception e) {
                            value = cell.toString().trim();
                        }
                    }
                    map.put(key, value);
                }
                dataList.add(map);
            }

            response.put("data", dataList);
            session.setAttribute("previewExcel", dataList);
        } catch (Exception e) {
            e.printStackTrace();
            response.put("error", e.getMessage() != null ? e.getMessage() : "알 수 없는 오류");
        }

        ObjectMapper mapper = new ObjectMapper();
        resp.getWriter().write(mapper.writeValueAsString(response));
    }
  //엑셀로드 저장(cell 를 setdto 해서 처리하는 경우 ) 
    @SuppressWarnings("unchecked")
    @RequestMapping(value = "/CellsaveExcelData.do", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> CellsaveExcelData(@RequestBody Map<String, Object> request) {
        Map<String, Object> result = new HashMap<>();
        try {
            String hospCd = (String) request.get("hospCd");
            List<Map<String, Object>> rows = (List<Map<String, Object>>) request.get("data");
            List<LicnumDTO> dtoList = new ArrayList<>();

            for (Map<String, Object> row : rows) {
                LicnumDTO dto = new LicnumDTO();

                dto.setLicenseGb((String) row.get("면허종별"));
                
             // '의사구분' 또는 '세부종별' 중 하나
                if (row.containsKey("의사구분")) {
                    dto.setDoctorGb((String) row.get("의사구분"));
                } else if (row.containsKey("세부종별")) {
                    dto.setDoctorGb((String) row.get("세부종별")); //간호사   
                }

                // '의사형태' 또는 '직책' 중 하나
                if (row.containsKey("의사형태")) {
                    dto.setDoctorType((String) row.get("의사형태"));
                } else if (row.containsKey("직책")) {
                    dto.setDoctorType((String) row.get("직책")); //간호사   
                }
                if (row.containsKey("간호등급여부")) {
                   dto.setNurGrd((String) row.get("간호등급여부")); //간호사                 
                }
                dto.setName((String) row.get("성명"));
                dto.setJumin((String) row.get("주민등록번호"));
                dto.setWorkGb((String) row.get("근무형태"));
                dto.setLicNum((String) row.get("면허번호"));

                String licDat = (String) row.get("면허취득일자");
                if (licDat != null && licDat.matches("\\d{8}|\\d{4}-\\d{2}-\\d{2}")) {
                    dto.setLicDat(licDat.replaceAll("-", ""));
                }
                String ipDt = (String) row.get("입사일자");
                if (ipDt != null && ipDt.matches("\\d{8}|\\d{4}-\\d{2}-\\d{2}")) {
                    dto.setIpDt(ipDt.replaceAll("-", ""));
                }

                dto.setVacGb((String) row.get("구분"));

                String vacStart = (String) row.get("시작일자");
                if (vacStart != null && vacStart.matches("\\d{8}|\\d{4}-\\d{2}-\\d{2}")) {
                    dto.setVacStart(vacStart.replaceAll("-", ""));
                }

                String vacEnd = (String) row.get("종료일자");
                if (vacEnd != null && vacEnd.matches("\\d{8}|\\d{4}-\\d{2}-\\d{2}")) {
                    dto.setVacEnd(vacEnd.replaceAll("-", ""));
                }

                // '대체자' 또는 '대체자명' 중 하나
                if (row.containsKey("대체자명")) {
                    dto.setVacSubnm((String) row.get("대체자명"));
                } else if (row.containsKey("대체자")) {
                    dto.setVacSubnm((String) row.get("대체자"));
                }

                String vacSubStart = (String) row.get("대체시작일자");
                if (vacSubStart != null && vacSubStart.matches("\\d{8}|\\d{4}-\\d{2}-\\d{2}")) {
                    dto.setVacsubStrdt(vacSubStart.replaceAll("-", ""));
                }

                String vacSubEnd = (String) row.get("대체종료일자");
                if (vacSubEnd != null && vacSubEnd.matches("\\d{8}|\\d{4}-\\d{2}-\\d{2}")) {
                    dto.setVacsubEnddt(vacSubEnd.replaceAll("-", ""));
                }

                dto.setWardNm((String) row.get("병동명"));
                dto.setWardDanwi((String) row.get("단위"));

                String wardStart = (String) row.get("근무시작일자");
                if (wardStart != null && wardStart.matches("\\d{8}|\\d{4}-\\d{2}-\\d{2}")) {
                    dto.setWardStrdt(wardStart.replaceAll("-", ""));
                }

                String wardEnddt = (String) row.get("근무종료일자");
                if (wardEnddt != null && wardEnddt.matches("\\d{8}|\\d{4}-\\d{2}-\\d{2}")) {
                    dto.setWardEnddt(wardEnddt.replaceAll("-", ""));
                }                
                
                dto.setWardMain((String) row.get("전담여부"));

                String lastWorkdt = (String) row.get("최종근무일");
                if (lastWorkdt != null && lastWorkdt.matches("\\d{8}|\\d{4}-\\d{2}-\\d{2}")) {
                    dto.setLastWorkdt(lastWorkdt.replaceAll("-", ""));
                }

                dto.setHisInfo((String) row.get("이력조회"));
                dto.setManChg((String) row.get("인력변동"));
                dto.setManRea((String) row.get("변동이유"));
                dto.setHospCd(hospCd);
                if (dto.getIpDt() != "" && dto.getIpDt() != null) {
                    dtoList.add(dto);
                }
            }

            if (!dtoList.isEmpty()) {
                svc.insertExcelDoctorBatch(dtoList);
            }

            result.put("success", true);
        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", e.getMessage());
        }
        return result;
    }
    //인력신고현황 
	@RequestMapping(value="/licnumber.do")
    public String licnumber(HttpServletRequest request, ModelMap model) {

        cookie_value = ClientInfo.getCookie(request);		
		try {
			if (cookie_value.get("s_hospid").trim() != null &&
				cookie_value.get("s_hospid").trim() != "" ) {
				return ".main/user/licnumber";				
			} else {
				return "";
			}	
		} catch(Exception ex) {
			return "";
		}
    }
	//인력신고현황 관리 
	@RequestMapping(value="/licnumList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getlicnumList(@ModelAttribute("DTO") LicnumDTO dto, HttpSession session, HttpServletRequest request, Model model) throws Exception {
		
		System.out.println("수가-java 1- start ");		
		
		cookie_value = ClientInfo.getCookie(request);		
		try {
			
			if (cookie_value.get("s_hospid").trim() != null &&
				cookie_value.get("s_hospid").trim() != "" ) {
				
				dto.setFindData(dto.getFindData());
			
				List<LicnumDTO> LicNumList = svc.getLicNumList(dto);
				
				System.out.println("인력신고등록-java size " + LicNumList.size());
				
				Map<String, Object> response = new HashMap<>();
		        response.put("data",LicNumList);

		        System.out.println("수가-java response : " + response);
		        
		        return response;
				
				
			} else {
				return null;
			}	
		} catch(Exception ex) {
			return null;
		}
	}
	@RequestMapping(value="/licnumInsert.do", method = RequestMethod.POST)
    public ResponseEntity<String> licnumInsert(@RequestBody List<LicnumDTO> data) {
		
		System.out.println("Insert 시작했음");
		String returnValue = "OK";
		// 처리 로직
        try {
        	for (LicnumDTO dto : data) {
        		String dupchk =   svc.LicNumDupChk(dto) ;
        		if ("Y".equals(dupchk)) {
        			return ResponseEntity.status(400).body(dto.getLicNum()); 
        		}
       		    System.out.println("licCode: "  + dto.getLicNum());
       		    System.out.println("HospCd: "   + dto.getHospCd());
       		    System.out.println("ipDt: "     + dto.getIpDt());
        		svc.insertLicNum(dto) ; 
            }
         
        	return ResponseEntity.ok(returnValue);   
        	
        } catch (Exception e) {
        	
            return ResponseEntity.status(500).body(e.getMessage());
            
        }
	}
	@RequestMapping(value="/licnumUpdate.do", method = RequestMethod.POST)
    public ResponseEntity<String> licnumUpdate(@RequestBody List<LicnumDTO> data) {
	
		System.out.println("Update 시작했음");
		String returnValue = "OK";
		// 처리 로직
        try {
        	
        	for (LicnumDTO dto : data) {
       		    System.out.println("licCode: " + dto.getLicNum());
       		    System.out.println("HospCd: "  + dto.getHospCd());
       		    System.out.println("ipDt: "    + dto.getIpDt());
        		
        		svc.updateLicNum(dto) ; //이력관리 
        		svc.insertLicNum(dto) ; 
     	
            }
        	return ResponseEntity.ok(returnValue);   
        	
        } catch (Exception e) {
        	
            return ResponseEntity.status(500).body(e.getMessage());
            
        }
	}
	@RequestMapping(value="/licnumDelete.do", method = RequestMethod.POST)
    public ResponseEntity<String> licnumDelete(@RequestBody List<LicnumDTO> data) {
		
		System.out.println("Delete 시작했음");
		String returnValue = "OK";
		// 처리 로직
        try {
        	for (LicnumDTO dto : data) {
        		dto.setLicNum(dto.getKeylicNum()); 
        		dto.setHospCd(dto.getKeyhospCd()); 
        		dto.setIpDt(dto.getKeyipDt()); 
        		svc.updateLicNum(dto) ; //이력관리 
       		    System.out.println("licCode: " + dto.getLicNum());
       		    System.out.println("HospCd: "  + dto.getHospCd());
              
            }
        	return ResponseEntity.ok(returnValue);   
        	
        } catch (Exception e) {
        	
            return ResponseEntity.status(500).body(e.getMessage());
            
        }
	}

	@RequestMapping(value="/hospemp_licnum.do", method = RequestMethod.POST)
	@ResponseBody
	public ResponseEntity<Map<String, Object>> hospemp_licnum(@ModelAttribute("DTO") LicnumDTO dto, 
	                                                          HttpSession session, 
	                                                          HttpServletRequest request) throws Exception {
	    
	    System.out.println("라이센스등록 - java 1 - start");
	    
	    Map<String, Object> result = new HashMap<>();
	    
	    try {
	        if (dto.getHospCd() != null && !dto.getHospCd().trim().isEmpty()) {
        	
	        	svc.inserthospemp_Licnum(dto); // 저장 처리

	            result.put("success", true);
	            result.put("message", "저장되었습니다.");
	        } else {
	            result.put("success", false);
	            result.put("message", "병원코드가 없습니다.");
	        }
	    } catch (Exception ex) {
	        result.put("success", false);
	        result.put("message", "에러 발생: " + ex.getMessage());
	    }

	    return ResponseEntity.ok(result);
	}
    //의사/간호사등급현황  
	@RequestMapping(value="/hospgrdcd.do")
    public String hospgrdcd(HttpServletRequest request, ModelMap model) {

        cookie_value = ClientInfo.getCookie(request);		
		try {
			if (cookie_value.get("s_hospid").trim() != null &&
				cookie_value.get("s_hospid").trim() != "" ) {
				return ".main/user/hospgrdcd";				
			} else {
				return "";
			}	
		} catch(Exception ex) {
			return "";
		}
    }
	@RequestMapping(value="/hospgrdList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> hospgrdList(@ModelAttribute("DTO") HospGrdDTO dto, HttpSession session, HttpServletRequest request, Model model) throws Exception {
		
		System.out.println("의사.간호사등급 -java 1- start ");		
		
		cookie_value = ClientInfo.getCookie(request);		
		try {
			
			if (cookie_value.get("s_hospid").trim() != null &&
				cookie_value.get("s_hospid").trim() != "" ) {
				
				dto.setFindData(dto.getFindData());
			
				List<HospGrdDTO> HospGrdList = svc.getHospGrdList(dto);
				
				System.out.println("의사.간호사등급-java size " + HospGrdList.size());
				
				Map<String, Object> response = new HashMap<>();
		        response.put("data",HospGrdList);

		        System.out.println("의사.간호사등급-java response : " + response);
		        
		        return response;
				
				
			} else {
				return null;
			}	
		} catch(Exception ex) {
			return null;
		}
	}
	@RequestMapping(value="/selhospgrdList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> selhospgrdList(@ModelAttribute("DTO") HospGrdDTO dto, HttpSession session, HttpServletRequest request, Model model) throws Exception {
		
		System.out.println("의사.간호사등급 -java 1- start ");		
		
		cookie_value = ClientInfo.getCookie(request);		
		try {
			
			if (cookie_value.get("s_hospid").trim() != null &&
				cookie_value.get("s_hospid").trim() != "" ) {
				
				dto.setFindData(dto.getFindData());
			
				List<HospGrdDTO> HospGrdList = svc.selHospGrdList(dto);
				
				System.out.println("의사.간호사등급-java size " + HospGrdList.size());
				
				Map<String, Object> response = new HashMap<>();
		        response.put("data",HospGrdList);

		        System.out.println("의사.간호사등급-java response : " + response);
		        
		        return response;
				
				
			} else {
				return null;
			}	
		} catch(Exception ex) {
			return null;
		}
	}
	@RequestMapping(value="/hospGrdInsert.do", method = RequestMethod.POST)
    public ResponseEntity<String> hospGrdInsert(@RequestBody List<HospGrdDTO> data) {
		
		System.out.println("Insert 시작했음");
		String returnValue = "OK";
		
		// 처리 로직
        try {
        	
        	for (HospGrdDTO dto : data) {
        		String dupchk =   svc.HospGrdDupChk(dto) ;
        		if ("Y".equals(dupchk)) {
        			return ResponseEntity.status(400).body(dto.getKeyhospCd()); 
        		}
        		svc.insertHospGrd(dto) ; 
       		    System.out.println("hospCd: " + dto.getKeyhospCd());
            }
        	
            
        	return ResponseEntity.ok(returnValue);   
        	
        } catch (Exception e) {
        	
            return ResponseEntity.status(500).body(e.getMessage());
            
        }
	}
	@RequestMapping(value="/hospGrdUpdate.do", method = RequestMethod.POST)
    public ResponseEntity<String> hospGrdUpdate(@RequestBody List<HospGrdDTO> data) {
	
		System.out.println("Update 시작했음");
		String returnValue = "OK";
		// 처리 로직
        try {
        	
        	for (HospGrdDTO dto : data) {
       		    System.out.println("HospCd: "   + dto.getHospCd());
       		    System.out.println("startYy: "  + dto.getStartYy());
       		    System.out.println("QterFlag: "    + dto.getQterFlag());
        		
        		svc.updateHospGrd(dto) ; //이력관리 
        		svc.insertHospGrd(dto) ; 
     	
            }
        	return ResponseEntity.ok(returnValue);   
        	
        } catch (Exception e) {
        	
            return ResponseEntity.status(500).body(e.getMessage());
            
        }
	}	
	@RequestMapping(value="/hospGrdDelete.do", method = RequestMethod.POST)
    public ResponseEntity<String> hospGrdDelete(@RequestBody List<HospGrdDTO> data) {
		
		System.out.println("Delete 시작했음");
		String returnValue = "OK";
		// 처리 로직
        try {
        	for (HospGrdDTO dto : data) {
        		dto.setHospCd(dto.getKeyhospCd()); 
        		dto.setStartYy(dto.getKeystartYy()); 
        		dto.setQterFlag(dto.getKeyqterFlag()); 
        		svc.updateHospGrd(dto) ; //이력관리 
       		    System.out.println("HospCd: "   + dto.getHospCd());
       		    System.out.println("startYy: "  + dto.getStartYy());
       		    System.out.println("bunji: "    + dto.getQterFlag());
              
            }
        	return ResponseEntity.ok(returnValue);   
        	
        } catch (Exception e) {
        	
            return ResponseEntity.status(500).body(e.getMessage());
            
        }
	}	
	@RequestMapping(value = "/saveHospGrd.do", method = RequestMethod.POST)
	public ResponseEntity<String> saveHospGrd(@RequestBody List<HospGrdDTO> data) {
	    /*
		System.out.println("saveHospGrd 호출됨");
	    
	    try {
	        for (HospGrdDTO dto : data) {
	        	System.out.println("HospCd: " + dto.getHospCd());
       		    System.out.println("startYy: " + dto.getStartYy());
       		    System.out.println("qterFlag: " + dto.getQterFlag());
       		    System.out.println("goalScore: " + dto.getGoalScore());
       		    
	        	svc.saveHospGrd(dto);
	        	svc.yearSaveHospGrd(dto);
	        	
	        }
	        return ResponseEntity.ok("OK");
	    } catch (Exception e) {
	        e.printStackTrace();
	        return ResponseEntity.status(500).body("Error: " + e.getMessage());
	    }
	    */
		
		System.out.println("saveHospGrd 호출됨");

		try {
	        for (HospGrdDTO dto : data) {
	        	
	            String originalYear = dto.getStartYy();
	            String originalQter = dto.getQterFlag();

	            int qter = Integer.parseInt(originalQter);
	            int year = Integer.parseInt(originalYear);

	            if (qter == 1) {
	                dto.setStartYy(String.valueOf(year - 1));
	                dto.setQterFlag("4");
	            } else {
	                dto.setStartYy(String.valueOf(year));
	                dto.setQterFlag(String.valueOf(qter - 1));
	            }

	            System.out.println("1회차 호출");
	            System.out.println("HospCd: " + dto.getHospCd());
	            System.out.println("startYy: " + dto.getStartYy());
	            System.out.println("qterFlag: " + dto.getQterFlag());
	            System.out.println("goalScore: " + dto.getGoalScore());

	            svc.saveHospGrd(dto);
	            
	            switch (dto.getQterFlag()) {
	                case "1":
	                	dto.setStrYm(dto.getStartYy() + "01");
	                	dto.setEndYm(dto.getStartYy() + "03");
	                    break;
	                case "2":
	                	dto.setStrYm(dto.getStartYy() + "04");
	                	dto.setEndYm(dto.getStartYy() + "06");
	                    break;
	                case "3":
	                	dto.setStrYm(dto.getStartYy() + "07");
	                	dto.setEndYm(dto.getStartYy() + "08");
	                    break;
	                case "4":
	                	dto.setStrYm(dto.getStartYy() + "10");
	                	dto.setEndYm(dto.getStartYy() + "12");
	                    break;
	            }
	            dto.setJobYm(dto.getStrYm());
	            
	            svc.callIndicatorsStructureZone(dto);
	            
	            
	            dto.setStartYy(originalYear);
	            dto.setQterFlag(originalQter);

	            System.out.println("2회차 호출");
	            System.out.println("HospCd: " + dto.getHospCd());
	            System.out.println("startYy: " + dto.getStartYy());
	            System.out.println("qterFlag: " + dto.getQterFlag());
	            System.out.println("goalScore: " + dto.getGoalScore());

	            svc.saveHospGrd(dto);
	            svc.yearSaveHospGrd(dto);
	        }

	        return ResponseEntity.ok("OK");
	    } catch (Exception e) {
	        e.printStackTrace();
	        return ResponseEntity.status(500).body("Error: " + e.getMessage());
	    }
	}
	@RequestMapping(value="/selectHospGrd.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> selectHospGrd(@ModelAttribute("DTO") HospGrdDTO dto, HttpSession session, HttpServletRequest request, Model model) throws Exception {
		
		System.out.println("selectHospGrd - start ");		
		
		cookie_value = ClientInfo.getCookie(request);		
		try {
			
			if (cookie_value.get("s_hospid").trim() != null &&
				cookie_value.get("s_hospid").trim() != "" ) {
				
				HospGrdDTO HospGrdList = svc.selectHospGrd(dto);
				
				Map<String, Object> response = new HashMap<>();
		        response.put("data",HospGrdList);

		        System.out.println("selectHospGrd response : " + response);
		        
		        return response;
				
				
			} else {
				return null;
			}	
		} catch(Exception ex) {
			return null;
		}
	}
	
}
