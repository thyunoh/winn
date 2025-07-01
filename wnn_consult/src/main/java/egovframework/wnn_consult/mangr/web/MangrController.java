package egovframework.wnn_consult.mangr.web;

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

import egovframework.wnn_consult.mangr.service.MangrService;
import egovframework.wnn_consult.user.service.UserService;
import egovframework.wnn_consult.mangr.model.NotiDTO;
import egovframework.wnn_consult.mangr.model.AsqDTO;
import egovframework.wnn_consult.mangr.model.FaqDTO;
import egovframework.wnn_consult.mangr.model.FileDTO;
import egovframework.wnn_consult.user.model.HospMdDTO;
import egovframework.wnn_consult.user.model.UserDTO;


import org.springframework.ui.ModelMap;


@Controller
public class MangrController {

	private static final Logger log = LoggerFactory.getLogger(MangrController.class);
	

	@Resource(name = "MangrService") // 서비스 선언
	private MangrService svc;
	@Resource(name = "UserService") // 서비스 선언
	private UserService uvc;	
	
	
	@RequestMapping(value = "/login/wnnpage_consult1.do")
	public String winpage_consult1(@ModelAttribute("DTO") UserDTO dto, HttpServletRequest request, ModelMap model) throws Exception {
	
		return ".login/wnnpage_consult1";
	}
	@RequestMapping(value = "/login/wnnpage_consult2.do")
	public String winpage_consult2(@ModelAttribute("DTO") UserDTO dto, HttpServletRequest request, ModelMap model) throws Exception {
	
		return ".login/wnnpage_consult2";
	}
	@RequestMapping(value = "/login/wnnpage_consult3.do")
	public String winpage_consult3(@ModelAttribute("DTO") UserDTO dto, HttpServletRequest request, ModelMap model) throws Exception {
	
		return ".login/wnnpage_consult3";
	}
	@RequestMapping(value = "/login/wnnpage_consult4.do")
	public String winpage_consult4(@ModelAttribute("DTO") UserDTO dto, HttpServletRequest request, ModelMap model) throws Exception {
	
		return ".login/wnnpage_consult4";
	}
	@RequestMapping(value = "/login/wnnpage_consult5.do")
	public String winpage_consult5(@ModelAttribute("DTO") UserDTO dto, HttpServletRequest request, ModelMap model) throws Exception {
	
		return ".login/wnnpage_consult5";
	}	
	/*약관조회*/
	@RequestMapping(value="/mangr/ctl_notiList.do")
	public String base_ctl_notiList(@ModelAttribute("DTO") NotiDTO dto, HttpServletRequest request, ModelMap model) throws Exception {  
		try { 
			//코그구분 정보 조회
			List<?> resultList = svc.selectNotiMstList(dto);

			model.addAttribute("resultList", resultList);
			model.addAttribute("resultCnt", resultList.size());
			model.addAttribute("error_code", "0"); 
	
		}catch(Exception ex) {
			model.addAttribute("error_code", "10000"); 
		}
		return "jsonView";
	}
	/* 공지사항 리드 카운트 */
	@RequestMapping(value="/mangr/read_noticnt.do")
	public String base_read_noticnt(@ModelAttribute("DTO") NotiDTO dto, HttpServletRequest request, ModelMap model) throws Exception {  
		try { 
			//코그구분 정보 조회
			svc.updatecntNotiMst(dto) ;
			model.addAttribute("error_code", "0"); 
	
		}catch(Exception ex) {
			model.addAttribute("error_code", "10000"); 
		}
		return "jsonView";
	}	
	//병원정보가져오기            
	@RequestMapping(value="/mangr/ctl_getHospmst.do")
	public String ctl_getHospmst(@ModelAttribute("DTO") HospMdDTO dto, HttpServletRequest request, ModelMap model) throws Exception {  
		try { 
			//코그구분 정보 조회
			HospMdDTO  result = uvc.getHospmst(dto);
			model.addAttribute("result", result);
			model.addAttribute("error_code", "0"); 
		}catch(Exception ex) {
			model.addAttribute("error_code", "10000"); 
		}
		return "jsonView";
	}	
	/* 일대일 질의응답*/	
	@RequestMapping(value= "mangr/ctl_asqList.do")
	public String ctl_asqList(@ModelAttribute("DTO") AsqDTO dto, HttpServletRequest request, ModelMap model) throws Exception {  
		try { 
			//코그구분 정보 조회
			List<?>  resultLst = svc.selectqstnlist(dto);
			model.addAttribute("resultLst", resultLst);
			model.addAttribute("resultCnt", resultLst.size());
			model.addAttribute("error_code", "0"); 
		}catch(Exception ex) {
			model.addAttribute("error_code", "10000"); 
		}
		return "jsonView";
	}	
	//질문리스트  
	@RequestMapping(value="/mangr/asqCdList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> asqCdList(@ModelAttribute("DTO") AsqDTO dto, HttpSession session, HttpServletRequest request, Model model) throws Exception {
		try { 
			System.out.println("HOSP " + dto.getHospCd());
			
		    List<AsqDTO> asqList = svc.getasqCdList(dto);
		    
			System.out.println("Asq-java size " + asqList.size());
			Map<String, Object> response = new HashMap<>();
	        response.put("data",asqList);
	        System.out.println("Asq-java response : " + response);
	        return response;
		
		}catch(Exception ex) {
			return null;
		}	
	}
	
	@RequestMapping(value= "/mangr/selectAnsrInfo.do")
	public String mangr_selectAnsrInfo(@ModelAttribute("DTO") AsqDTO dto, HttpServletRequest request, ModelMap model) throws Exception {  
		try { 
			//코그구분 정보 조회
			AsqDTO  result = svc.selectqstnInfo(dto);
			model.addAttribute("result", result);
			model.addAttribute("error_code", "0"); 
		}catch(Exception ex) {
			model.addAttribute("error_code", "10000"); 
		}
		return "jsonView";
	}	
	@RequestMapping(value="/mangr/asqSaveAct.do")
	public String mangr_asqSaveAct(@ModelAttribute("DTO") AsqDTO dto, HttpServletRequest request, ModelMap model) throws Exception {  
		try { 
			//코그구분 정보 조회
			System.out.println("getIudasq " + dto.getIudasq());
			if ("QI".equals(dto.getIudasq())){
				svc.insertqstnMst(dto) ;
			}else if ("QU".equals(dto.getIudasq())){
				svc.updateqstnMst(dto) ;
			}else if ("QD".equals(dto.getIudasq())){
				svc.updatedelasqCd(dto) ;
			}
			model.addAttribute("error_code", "0"); 	
		}catch(Exception ex) {
			model.addAttribute("error_code", "10000"); 
		}
		return "jsonView";
	}		
	/*자주하는 질문*/
	
	@RequestMapping(value= "/mangr/faqList.do" , method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getfaqCdList(@ModelAttribute("DTO") FaqDTO dto, HttpSession session, HttpServletRequest request, Model model) throws Exception {
		Map<String, Object> response = new HashMap<>();    
		try { 
			//코그구분 정보 조회
			List<FaqDTO> resultLst = svc.selectfaqlist(dto);
	        response.put("resultLst", resultLst);
            response.put("resultCnt", resultLst.size());
            response.put("error_code", "0"); // 정상 응답
            
            System.out.println("FAQ 데이터 개수: " + resultLst.size());
	            
	        } catch (Exception e) {
	            response.put("error_code", "1"); // 에러 발생
	            response.put("error_message", e.getMessage());
	        }
	        return response;
	}
	/*문서화일*/	
	@RequestMapping(value= "/mangr/fileCdList.do", method = RequestMethod.POST)
	@ResponseBody
	public List<FileDTO> getfileCdList(@ModelAttribute("DTO") FileDTO dto) {
	    List<FileDTO> resultLst = new ArrayList<>();
	    try { 
	        resultLst = svc.getFileCdList(dto);
	        System.out.println("file 데이터 개수: " + resultLst.size());
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return resultLst; // 리스트만 반환하여 JSON 배열 구조 유지
	}
}
