package egovframework.wnn_medcost.chung.web;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.util.ClientInfo;
import egovframework.wnn_medcost.base.model.SugaCdDTO;
import egovframework.wnn_medcost.chung.model.ChungDTO;
import egovframework.wnn_medcost.chung.service.ChungService;
@Controller
@RequestMapping("/chung")  // 클래스 레벨에서 기본 경로 설정
public class ChungController {

	private static final Logger log = LoggerFactory.getLogger(ChungController.class);
	private static Map<String, String> cookie_value = new HashMap<>();
	
	@Resource(name = "ChungService") // 서비스 선언
	private ChungService svc;
	//청구심사조회
	@RequestMapping(value="/chgsimsa.do")
    public String chgsimsao(HttpServletRequest request, ModelMap model) {

        cookie_value = ClientInfo.getCookie(request);		
		try {
			if (cookie_value.get("s_hospid").trim() != null &&
				cookie_value.get("s_hospid").trim() != "" ) {
				return ".main/chung/chgsimsa";				
			} else {  	
				return "";
			}	
		} catch(Exception ex) {
			return "";
		}
    }	
	//청구서조회 
	@RequestMapping(value="/chungList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> chungList(@ModelAttribute("DTO") ChungDTO dto, HttpSession session, HttpServletRequest request, Model model) throws Exception {
		cookie_value = ClientInfo.getCookie(request);		
		try {
			
			if (cookie_value.get("s_hospid").trim() != null &&
				cookie_value.get("s_hospid").trim() != "" ) {
				List<ChungDTO> chungList = svc.chungList(dto);
				System.out.println("faq-java size " + chungList.size());
				Map<String, Object> response = new HashMap<>();
		        response.put("data",chungList);
		        return response;

			} else {
				return null;
			}	
		} catch(Exception ex) {
			return null;
		}
	}
	//명세서조회               
	@RequestMapping(value="/myoungList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> myoungList(@ModelAttribute("DTO") ChungDTO dto, HttpSession session, HttpServletRequest request, Model model) throws Exception {
		cookie_value = ClientInfo.getCookie(request);		
		try {
			
			if (cookie_value.get("s_hospid").trim() != null &&
				cookie_value.get("s_hospid").trim() != "" ) {
				List<ChungDTO> myoungList = svc.myoungList(dto);
				System.out.println("faq-java size " + myoungList.size());
				Map<String, Object> response = new HashMap<>();
		        response.put("data",myoungList);
		        return response;

			} else {
				return null;
			}	
		} catch(Exception ex) {
			return null;
		}
	}	
	//상병조회               
	@RequestMapping(value="/diseList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> diseList(@ModelAttribute("DTO") ChungDTO dto, HttpSession session, HttpServletRequest request, Model model) throws Exception {
		cookie_value = ClientInfo.getCookie(request);		
		try {
			
			if (cookie_value.get("s_hospid").trim() != null &&
				cookie_value.get("s_hospid").trim() != "" ) {
				List<ChungDTO> diseList = svc.diseList(dto);
				System.out.println("faq-java size " + diseList.size());
				Map<String, Object> response = new HashMap<>();
		        response.put("data",diseList);
		        return response;

			} else {
				return null;
			}	
		} catch(Exception ex) {
			return null;
		}
	}
	//진료내역              
	@RequestMapping(value="/jinordList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> jinordList(@ModelAttribute("DTO") ChungDTO dto, HttpSession session, HttpServletRequest request, Model model) throws Exception {
		cookie_value = ClientInfo.getCookie(request);		
		try {
        	
			if (cookie_value.get("s_hospid").trim() != null &&
				cookie_value.get("s_hospid").trim() != "" ) {
				List<ChungDTO> jinordList = svc.jinordList(dto);
				System.out.println("faq-java size " + jinordList.size());
				Map<String, Object> response = new HashMap<>();
		        response.put("data",jinordList);
		        return response;

			} else {
				return null;
			}	
		} catch(Exception ex) {
			return null;
		}
	}
	//진료내역              
	@RequestMapping(value="/hangList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> hangList(@ModelAttribute("DTO") ChungDTO dto, HttpSession session, HttpServletRequest request, Model model) throws Exception {
		cookie_value = ClientInfo.getCookie(request);		
		try {
			
			if (cookie_value.get("s_hospid").trim() != null &&
				cookie_value.get("s_hospid").trim() != "" ) {
				List<ChungDTO> hangList = svc.hangList(dto);
				System.out.println("faq-java size " + hangList.size());
				Map<String, Object> response = new HashMap<>();
		        response.put("data",hangList);
		        return response;

			} else {
				return null;
			}	
		} catch(Exception ex) {
			return null;
		}
	}
	//특정내역              
	@RequestMapping(value="/spcList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> spcList(@ModelAttribute("DTO") ChungDTO dto, HttpSession session, HttpServletRequest request, Model model) throws Exception {
		cookie_value = ClientInfo.getCookie(request);		
		try {
			
			if (cookie_value.get("s_hospid").trim() != null &&
				cookie_value.get("s_hospid").trim() != "" ) {
				List<ChungDTO> spcList = svc.spcList(dto);
				System.out.println("faq-java size " + spcList.size());
				Map<String, Object> response = new HashMap<>();
		        response.put("data",spcList);
		        return response;

			} else {
				return null;
			}	
		} catch(Exception ex) {
			return null;
		}
	}	
}



