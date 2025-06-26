package egovframework.wnn_consult.user.web;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.util.GetClientIP;
import egovframework.wnn_consult.user.model.UserDTO;
import egovframework.wnn_consult.user.model.MberDTO;
import egovframework.wnn_consult.user.model.HospMdDTO;
import egovframework.wnn_consult.user.service.UserService;
import egovframework.wnn_consult.base.model.CodeMdDTO;
import egovframework.wnn_consult.base.service.BaseService;
import egovframework.util.EgovFileScrty;

import org.springframework.ui.ModelMap;


@Controller
public class UserController {

	private static final Logger log = LoggerFactory.getLogger(UserController.class);

	
	@Resource(name = "UserService") // 서비스 선언
	private UserService svc;
	@Resource(name = "BaseService") // 서비스 선언
	private BaseService bvc;	
	
	//메인화면 호출
	@RequestMapping(value = "/main.do")
	public String MainPage(HttpServletRequest request, ModelMap model) throws Exception {
		
		return ".main/main";
	}


	//최초 로그인 페이지 호출
	@RequestMapping(value = "/index.do")
	public String IndexPage(@ModelAttribute("DTO") UserDTO dto, HttpServletRequest request, ModelMap model) throws Exception {
	
		return ".login/LoginWinCT";
	}	 
	
	// 로그인 화면
	@RequestMapping(value = "/login.do")  // 두 경로를 모두 처리
	public String login(@ModelAttribute("DTO") CodeMdDTO dto, HttpServletRequest request,ModelMap model) throws Exception {

		try { 
			//코그구분 정보 조회
			dto.setCodeCd("EMAIL");
			dto.setUseYn("Y");
			dto.setCodeGb("Z");
			List <?> resultLst = bvc.selectCodeDetailList(dto);	
			model.addAttribute("commList", resultLst); 
		}catch(Exception ex) {
			model.addAttribute("error_code", "10000"); 
		}
	
		return ".login/LoginWinCT";
	}  


	
	/* 사용자 로그인 Check */
	@RequestMapping(value="/user/loginChk.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, String> UserLoginProcess(@ModelAttribute("DTO") UserDTO dto, HttpSession session, HttpServletRequest request, Model model) throws Exception {
		
		System.out.print("시작-java - " + dto.getHospCd() + " - " + dto.getUserId()+ " - " + dto.getPassWd());
		
		Map<String, String> response = new HashMap<>();
		
		try {
			
			// 암호된 상태로 저장 후 EgovFileScrty 풀고 해야됨.
			// 일단은 암호화 안된 상태로 테스트 
			//dto.setPass_wd(EgovFileScrty.encryptPassword(dto.getPass_wd(), dto.getUser_id()));
			
			UserDTO result = svc.userLoginCheck(dto);
			
		    if ("0".equals(result.getUserId())) {
				
		    	response.put("error_code", "10000");
	            response.put("error_mess", "사용자 ID 정보가 존재하지 않습니다.");
	            System.out.print("사용자 ID 정보가 존재하지 않습니다.");
	            
			} else {	
				
				// 암호된 상태로 저장 후 EgovFileScrty 풀고 해야됨.
				// 일단은 암호화 안된 상태로 테스트
				String chkpwd = EgovFileScrty.encryptPassword(dto.getPassWd(), dto.getUserId());
				System.out.print("비밀번호를 확인하세요.!");
				if (!result.getPassWd().equals(chkpwd)) {
					
					response.put("error_code", "20000");
					response.put("error_mess", "비밀번호를 확인하세요.!");
					System.out.print("비밀번호를 확인하세요.!");
					//위너넷이 아니면서 게약정보가 없으면  
				}else if (!result.getWinnerYn().equals("Y") &&  result.getConactGb().equals("N")) { //(진료비,적정성(A), 진료비 '1' 적정성 '2' ,else 'N') 
					    response.put("error_code", "10001");
						response.put("error_mess", "계약관련 사용권한을 확인하세요 !");
						System.out.print("계약관련 사용권한을 확인하세요.!");
			//	}else if (!result.getUseYn().equals("Y")) { //사용여부 Y ,N)   
			//	    response.put("error_code", "10002");
			//		response.put("error_mess", "사용자 사용여부를 확인하세요 !");
			//		System.out.print("사용자 사용여부를 확인하세요.!");
				} else {
	            	log.error("s_main_gu: " + result.getMainGu());
	            	log.error("s_wnn_yn: "  + result.getWinnerYn());
	            	log.error("s_conact_gb: "  + result.getConactGb());
					session.setAttribute("s_hosp_cd"   , result.getHospCd());     // 병원코드
					session.setAttribute("s_hosp_uuid" , result.getHospCd());   // 병원코드
					session.setAttribute("s_hosp_nm"   , result.getHospNm());     // 병원명칭
					session.setAttribute("s_user_id"   , result.getUserId());     // 사용자ID
					session.setAttribute("s_user_nm"   , result.getUserNm());     // 사용자명					
					session.setAttribute("s_start_dt"  , result.getStartDt());    // 시작일자
					session.setAttribute("s_end_dt"    , result.getEndDt());      // 종료일자					
					session.setAttribute("s_main_gu"   , result.getMainGu()); 	   // 관리자구분(1.위너넷관리자, 2.위너넷사용자, 3.병원관리자, 4.병원사용자)
					session.setAttribute("s_use_not"   , result.getUseNot()); 	   // 사용여부(Y,정상사용자, N.종료사용자, 0.등록안된 사용자)					
					session.setAttribute("s_conn_ip"   , GetClientIP.getClientIP(request));  // 접속IP 주소
					
					System.out.print(GetClientIP.getClientIP(request));
					
					response.put("login_Hosp", result.getHospNm()); // 병원명
					response.put("login_User", result.getUserNm()); // 사용자
					response.put("login_Main", result.getMainGu()); // 관리자구분(1.위너넷관리자, 2.위너넷사용자, 3.병원관리자, 4.병원사용자)
					response.put("loginUseYN", result.getUseNot()); // 사용여부
					response.put("loginUseCan", result.getUseYn()); // 사용여부
					response.put("login_Hospuuid", result.getHospUuid()); // 사용자 uuid 
					response.put("login_Connip", GetClientIP.getClientIP(request)); // 사용자 uuid 
					response.put("login_WnnYN" , result.getWinnerYn()) ; //위너넷정보 
					response.put("login_ConactGB" , result.getConactGb()) ; //계약정보(진료비,적정성(A), 진료비 '1' 적정성 '2' ,else 'N')
					response.put("login_insAuth"  , result.getInsAuth()) ; //입력권한 
					response.put("login_updAuth"  , result.getUpdAuth()) ; //수정권한 
					response.put("login_delAuth"  , result.getDelAuth()) ; //삭제권한 
					response.put("login_inqAuth"  , result.getInqAuth()) ; //조회권한 
					LocalDateTime now = LocalDateTime.now();
					String formattedNow = now.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
					
					response.put("login_Last_Condttm" , formattedNow) ; //최종접속일자  
					response.put("login_Last_Conuser" , result.getLastConuser()) ; //최종접속자  
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

	@RequestMapping(value= "/popup/login_pwdmgr.do")
	public String login_pwdsearch(@ModelAttribute("DTO") UserDTO dto, HttpServletRequest request, ModelMap model) throws Exception {  

		return ".login/login_pwdmgr";
	}
	@RequestMapping(value= "/popup/login_usersearch.do")
	public String base_usersearch(@ModelAttribute("DTO") UserDTO dto, HttpServletRequest request, ModelMap model) throws Exception {  
		try {
			UserDTO result = svc.UsernmInfo(dto);
			model.addAttribute("result", result);
			model.addAttribute("error_code", "0");
		}catch(Exception ex){
			model.addAttribute("error_code", "10000"); 	
		}

		return "jsonView";
	}	
	@RequestMapping(value= "/popup/login_pwdchg.do")
	public String base_pwdclear(@ModelAttribute("DTO") UserDTO dto, HttpServletRequest request, ModelMap model) throws Exception {  

		return ".login/login_pwdchg";
	}
	/*비밀번호초기화 */
	@RequestMapping(value= "/base/pwdresetAct.do")
	public String base_pwdresetAct(@ModelAttribute("DTO") UserDTO dto, HttpServletRequest request, ModelMap model) throws Exception {  
		try { 
			UserDTO result = svc.UserPasswdInfo(dto);
			if(result.getUserId() == null || result.getUserId().toString().isEmpty()){
				model.addAttribute("error_code", "20000");
			    model.addAttribute("error_msg", "비밀번호 변경할 사용자 정보가 존재하지 않습니다.");
			    return "jsonView";			
			}
			dto.setEncPassWd(EgovFileScrty.encryptPassword("1234", dto.getUserId()));
			//비밀번호 변경 처리			
			boolean chk = svc.UserPasswdChange(dto);
			
			if(chk) {
				model.addAttribute("error_code", "0");
				model.addAttribute("error_msg" , "");
			}else {
				model.addAttribute("error_code", "10000");
				model.addAttribute("error_msg" , "사용자 비밀번호 변경 실패하였습니다.");
			}		
			
		}catch(Exception ex) {
			model.addAttribute("error_code", "10000"); 
		}
		return "jsonView";
	}          
	/* 사용자 비밀번호변경 처리 */
	@RequestMapping(value="/base/pwdchgAct.do")
	public String UserPwdChangeSave(@ModelAttribute("DTO") UserDTO dto, HttpServletRequest request, ModelMap model)
			throws Exception {  
		try {
           
            UserDTO result = svc.userInfo(dto);

            if (result == null || "".equals(result.getUserId()) || result.getUserId() == null) { 
				model.addAttribute("error_code", "20000");
				model.addAttribute("error_msg" , "비밀번호 변경할 사용자 정보가 존재하지 않습니다.");
				return "jsonView";
			}
			String chkpwd = EgovFileScrty.encryptPassword(dto.getPassWd(), dto.getUserId());
			
			if(!result.getPassWd().equals(chkpwd)) {
				model.addAttribute("error_code", "30000");
				model.addAttribute("error_msg" , "현재 비밀번호를 확인하세요.!");
				return "jsonView";
			}

			if(dto.getBfPassWd() == "") {
				model.addAttribute("error_code", "30000");
				model.addAttribute("error_msg" , "비밀번호 변경할 정보가 존재하지 않습니다.");
				return "jsonView";
			}
			dto.setEncPassWd(EgovFileScrty.encryptPassword(dto.getBfPassWd(), dto.getUserId()));
			boolean chk = svc.UserPasswdChange(dto);
			
			if(chk) {
				model.addAttribute("error_code", "0");
				model.addAttribute("error_msg" , "");
			}else {
				model.addAttribute("error_code", "10000");
				model.addAttribute("error_msg" , "사용자 비밀번호 변경 실패하였습니다.");
			}
		}catch(Exception ex) {
			log.error(" UserPwdChangeSave ERROR ! : "+ ex.getMessage());
			model.addAttribute("error_code", "10000");
			model.addAttribute("error_msg" , "사용자 비밀번호 변경 실패하였습니다."); 
						
		}
		//
		return "jsonView";
	}	

	/* 회원가입시 병원검색  */
	@RequestMapping(value= "/user/ctl_hospList.do", method = RequestMethod.POST)
	public String ctl_hospList(@ModelAttribute("DTO") HospMdDTO dto, HttpServletRequest request, Model model) throws Exception {
	try {
		List<?> result = svc.selHospList(dto) ;
		model.addAttribute("resultLst", result); 
		model.addAttribute("resultCnt", result.size());  
		model.addAttribute("error_code", "0"); 
		
	}catch(Exception ex) {
		log.error(" HospMdDTO ERROR ! : "+ ex.getMessage());
		model.addAttribute("error_code", "10000"); 
		}
		return "jsonView";
	}	
	/* 회원가입시 중복체크  */
	@RequestMapping(value="/user/MberDupChk.do")
	public String baee_MberDupChk(@ModelAttribute("DTO") MberDTO dto, HttpServletRequest request, ModelMap model) throws Exception {  
		try { 
			//코그구분 정보 조회
			String   dupchk =  svc.selMberDupChk(dto) ;
			model.addAttribute("dupchk", dupchk); 
			model.addAttribute("error_code", "0"); 
	
		}catch(Exception ex) {
			model.addAttribute("error_code", "10000"); 
		}
		return "jsonView";
	}
	/*회원가입*/
	@RequestMapping(value= "/user/MemberSaveAct.do")
	public String base_MemberSaveAct(@ModelAttribute("DTO") MberDTO dto, HttpServletRequest request, ModelMap model) throws Exception {  
		try { 
			//코그구분 정보 조회
			if ("I".equals(dto.getIud())) {
				
				dto.setPassWd(EgovFileScrty.encryptPassword(dto.getPassWd(), dto.getEmail()));
				String chkapwd = EgovFileScrty.encryptPassword(dto.getPassWd(), dto.getEmail());
	
				if(chkapwd == "") {
					model.addAttribute("error_code", "30000");
					model.addAttribute("error_msg" , "등록할 비밀번호를 입력하세요   .");
					return "jsonView";
				}
				
				String chkbpwd = EgovFileScrty.encryptPassword(dto.getAfPassWd(), dto.getEmail());
					
				if ((chkbpwd == "") & (chkapwd != chkbpwd)) {
					model.addAttribute("error_code", "30000");
					model.addAttribute("error_msg" , "등록할 비밀번호와 상이합니다    .");
					return "jsonView";
				}
				svc.insertMember(dto);
                //MberDTO(원래 USERDTO)
				String userchk = svc.UserDupChk(dto);
				//멤버등록시 사용자에 없으면 등록  
				
				log.error("hospCd: " + dto.getHospCd());
				log.error("userId: " + dto.getEmail());
				log.error("userchk: " + userchk);
				if (!"Y".equals(userchk)){
					svc.insertmbrUser(dto) ; //MberDTO dto 처리  
				}
			}
			model.addAttribute("error_code", "0"); 	
		}catch(Exception ex) {
			model.addAttribute("error_code", "10000"); 
		}
		return "jsonView";
	}
	/*병원정보 공통검색 */
	@RequestMapping(value= "/user/phospList.do", method = RequestMethod.POST)
	@ResponseBody  // ✅ JSON 응답을 위해 추가
	public Map<String, Object> phospList(@ModelAttribute("DTO") HospMdDTO dto) throws Exception {
	    Map<String, Object> response = new HashMap<>() ;
	try {
		List<?> result = svc.selHospList(dto) ;
		log.error("🚨 getWnnchk  : " + dto.getWnnchk());
		log.error("🚨 getHospCd  : " + dto.getHospCd());
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
	/*경여분석/적정성평가등록여부 */	
	@RequestMapping(value= "/user/getReportList.do", method = RequestMethod.POST)
	@ResponseBody
	public List<UserDTO> getReportList(@ModelAttribute("DTO") UserDTO dto) {
	    List<UserDTO> resultLst = new ArrayList<>();
	    try { 
	        resultLst = svc.getReportList(dto);
	        System.out.println("file 데이터 개수: " + resultLst);
	        System.out.println("file 데이터 개수: " + resultLst.size());
	        for (UserDTO dtoItem : resultLst) {
	            System.out.println("DTO 내용: " + dtoItem);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return resultLst; // 리스트만 반환하여 JSON 배열 구조 유지
	}	
	/*회원가입시 계약에따라 병원명가져오기 1*/	
	@RequestMapping(value= "/user/selHospsumList.do", method = RequestMethod.POST)
	@ResponseBody
	public List<HospMdDTO> selHospsumList(@ModelAttribute("DTO") HospMdDTO dto) {
	    List<HospMdDTO> resultLst = new ArrayList<>();
	    try { 
	        resultLst = svc.selHospsumList(dto);
	        System.out.println("file 데이터 개수: " + resultLst);
	        System.out.println("file 데이터 개수: " + resultLst.size());
	        for (HospMdDTO dtoItem : resultLst) {
	            System.out.println("DTO 내용: " + dtoItem);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return resultLst; // 리스트만 반환하여 JSON 배열 구조 유지
	}	
}
