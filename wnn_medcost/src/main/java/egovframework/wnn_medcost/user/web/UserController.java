package egovframework.wnn_medcost.user.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.annotation.Resource;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import egovframework.wnn_medcost.util.ResponseObject;
import egovframework.util.ClientInfo;
import egovframework.wnn_medcost.base.model.DiseCdDTO;
import egovframework.wnn_medcost.base.web.BaseController;
import egovframework.wnn_medcost.user.model.DietDTO;
import egovframework.wnn_medcost.user.model.HospConDTO;
import egovframework.wnn_medcost.user.model.HospMdDTO;
import egovframework.wnn_medcost.user.model.LisenceDTO;
import egovframework.wnn_medcost.user.model.UserDTO;
import egovframework.wnn_medcost.user.model.WardDTO;
import egovframework.wnn_medcost.user.service.UserService;
import egovframework.util.EgovFileScrty;

import org.springframework.ui.ModelMap;


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
				
			//	for(HospMdDTO dao: hospList  ) {
			//		System.out.println("병원-java getWardCnt : " + dao.getWardcnt());
			//	}
			
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
	public Map<String, Object> getHospContList(@ModelAttribute("DTO") HospConDTO dto, HttpSession session, HttpServletRequest request, Model model) throws Exception {
		
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
				
			//	for(HospMdDTO dao: hospList  ) {
			//		System.out.println("병원-java getWardCnt : " + dao.getWardcnt());
			//	}
			
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
        			dto.setEncPassWd(EgovFileScrty.encryptPassword(dto.getBfPassWd(), dto.getUserId())) ;
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
	     			dto.setEncPassWd(EgovFileScrty.encryptPassword(dto.getBfPassWd(), dto.getUserId())) ;
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
        			dto.setEncPassWd(EgovFileScrty.encryptPassword(dto.getBfPassWd(), dto.getUserId())) ;
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
	     			dto.setEncPassWd(EgovFileScrty.encryptPassword(dto.getBfPassWd(), dto.getUserId())) ;
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
}
