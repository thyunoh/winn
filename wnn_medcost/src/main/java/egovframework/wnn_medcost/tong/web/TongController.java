package egovframework.wnn_medcost.tong.web;

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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.util.ClientInfo;
import egovframework.wnn_medcost.tong.model.TongDTO;
import egovframework.wnn_medcost.tong.service.TongService;
@Controller
@RequestMapping("/tong")  // 클래스 레벨에서 기본 경로 설정
public class TongController {

	private static final Logger log = LoggerFactory.getLogger(TongController.class);
	private static Map<String, String> cookie_value = new HashMap<>();
	
	@Resource(name = "TongService") // 서비스 선언
	private TongService svc;

	@RequestMapping(value="/f_tong_00.do")
    public String filelist(HttpServletRequest request, ModelMap model) {

        cookie_value = ClientInfo.getCookie(request);		
		try {
			if (cookie_value.get("s_hospid").trim() != null &&
				cookie_value.get("s_hospid").trim() != "" ) {
				return ".main/tong/f_tong_00";				
			} else {  	
				return "";
			}	
		} catch(Exception ex) {
			return "";
		}
    }
	@RequestMapping(value= "/t_tong00List.do", method = RequestMethod.POST)
	@ResponseBody
	public List<TongDTO> t_tong00List(@ModelAttribute("DTO") TongDTO dto) {
	    List<TongDTO> resultLst = new ArrayList<>();
	    try { 
	        resultLst = svc.tong00List(dto);
	        System.out.println("file 데이터 개수: " + resultLst.size());
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return resultLst; // 리스트만 반환하여 JSON 배열 구조 유지
	}
	@RequestMapping(value="/f_tong_01.do")
    public String f_tong_01(HttpServletRequest request, ModelMap model) {

        cookie_value = ClientInfo.getCookie(request);		
		try {
			if (cookie_value.get("s_hospid").trim() != null &&
				cookie_value.get("s_hospid").trim() != "" ) {
				return ".main/tong/f_tong_01";				
			} else {  	
				return "";
			}	
		} catch(Exception ex) {
			return "";
		}
    }
	@RequestMapping(value= "/t_tong01List.do", method = RequestMethod.POST)
	@ResponseBody
	public List<TongDTO> t_tong01List(@ModelAttribute("DTO") TongDTO dto) {
	    List<TongDTO> resultLst = new ArrayList<>();
	    try { 
	        resultLst = svc.tong01List(dto);
	        System.out.println("file 데이터 개수: " + resultLst.size());
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return resultLst; // 리스트만 반환하여 JSON 배열 구조 유지
	}	
	//진료과별 건당진료비
	@RequestMapping(value="/f_tong_02.do")
    public String f_tong_02(HttpServletRequest request, ModelMap model) {

        cookie_value = ClientInfo.getCookie(request);		
		try {
			if (cookie_value.get("s_hospid").trim() != null &&
				cookie_value.get("s_hospid").trim() != "" ) {
				return ".main/tong/f_tong_02";				
			} else {  	
				return "";
			}	
		} catch(Exception ex) {
			return "";
		}
    }	
	@RequestMapping(value= "/t_tong02List.do", method = RequestMethod.POST)
	@ResponseBody
	public List<TongDTO> t_tong02List(@ModelAttribute("DTO") TongDTO dto) {
	    List<TongDTO> resultLst = new ArrayList<>();
	    try { 
	        resultLst = svc.tong02List(dto);
	        System.out.println("file 데이터 개수: " + resultLst.size());
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return resultLst; // 리스트만 반환하여 JSON 배열 구조 유지
	}
	//항목별건당진료비와 구성비
	@RequestMapping(value="/f_tong_03.do")
    public String f_tong_03(HttpServletRequest request, ModelMap model) {

        cookie_value = ClientInfo.getCookie(request);		
		try {
			if (cookie_value.get("s_hospid").trim() != null &&
				cookie_value.get("s_hospid").trim() != "" ) {
				return ".main/tong/f_tong_03";				
			} else {  	
				return "";
			}	
		} catch(Exception ex) {
			return "";
		}
    }	
	@RequestMapping(value= "/t_tong03List.do", method = RequestMethod.POST)
	@ResponseBody
	public List<TongDTO> t_tong03List(@ModelAttribute("DTO") TongDTO dto) {
	    List<TongDTO> resultLst = new ArrayList<>();
	    try { 
	        resultLst = svc.tong03List(dto);
	        System.out.println("file 데이터 개수: " + resultLst.size());
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return resultLst; // 리스트만 반환하여 JSON 배열 구조 유지
	}	
	//다빈도상병 진료구성비
	@RequestMapping(value="/f_tong_04.do")
    public String f_tong_04(HttpServletRequest request, ModelMap model) {

        cookie_value = ClientInfo.getCookie(request);		
		try {
			if (cookie_value.get("s_hospid").trim() != null &&
				cookie_value.get("s_hospid").trim() != "" ) {
				return ".main/tong/f_tong_04";				
			} else {  	
				return "";
			}	
		} catch(Exception ex) {
			return "";
		}
    }	
	@RequestMapping(value= "/t_tong04List.do", method = RequestMethod.POST)
	@ResponseBody
	public List<TongDTO> t_tong04List(@ModelAttribute("DTO") TongDTO dto) {
	    List<TongDTO> resultLst = new ArrayList<>();
	    try { 
	        resultLst = svc.tong04List(dto);
	        System.out.println("file 데이터 개수: " + resultLst.size());
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return resultLst; // 리스트만 반환하여 JSON 배열 구조 유지
	}
	//전문의별 건당진료비 
	@RequestMapping(value="/f_tong_05.do")
    public String f_tong_05(HttpServletRequest request, ModelMap model) {

        cookie_value = ClientInfo.getCookie(request);		
		try {
			if (cookie_value.get("s_hospid").trim() != null &&
				cookie_value.get("s_hospid").trim() != "" ) {
				return ".main/tong/f_tong_05";				
			} else {  	
				return "";
			}	
		} catch(Exception ex) {
			return "";
		}
    }	
	@RequestMapping(value= "/t_tong05List.do", method = RequestMethod.POST)
	@ResponseBody
	public List<TongDTO> t_tong05List(@ModelAttribute("DTO") TongDTO dto) {
	    List<TongDTO> resultLst = new ArrayList<>();
	    try { 
	        resultLst = svc.tong05List(dto);
	        System.out.println("file 데이터 개수: " + resultLst.size());
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return resultLst; // 리스트만 반환하여 JSON 배열 구조 유지
	}	
	//유형별 진료대비건수  
	@RequestMapping(value="/f_tong_06.do")
    public String f_tong_06(HttpServletRequest request, ModelMap model) {

        cookie_value = ClientInfo.getCookie(request);		
		try {
			if (cookie_value.get("s_hospid").trim() != null &&
				cookie_value.get("s_hospid").trim() != "" ) {
				return ".main/tong/f_tong_06";				
			} else {  	
				return "";
			}	
		} catch(Exception ex) {
			return "";
		}
    }	
	@RequestMapping(value= "/t_tong06List.do", method = RequestMethod.POST)
	@ResponseBody
	public List<TongDTO> t_tong06List(@ModelAttribute("DTO") TongDTO dto) {
	    List<TongDTO> resultLst = new ArrayList<>();
	    try { 
	        resultLst = svc.tong06List(dto);
	        System.out.println("file 데이터 개수: " + resultLst.size());
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return resultLst; // 리스트만 반환하여 JSON 배열 구조 유지
	}	
	//의사별  전월대비진료비  
	@RequestMapping(value="/f_tong_07.do")
    public String f_tong_07(HttpServletRequest request, ModelMap model) {

        cookie_value = ClientInfo.getCookie(request);		
		try {
			if (cookie_value.get("s_hospid").trim() != null &&
				cookie_value.get("s_hospid").trim() != "" ) {
				return ".main/tong/f_tong_07";				
			} else {  	
				return "";
			}	
		} catch(Exception ex) {
			return "";
		}
    }	
	@RequestMapping(value= "/t_tong07List.do", method = RequestMethod.POST)
	@ResponseBody
	public List<TongDTO> t_tong07List(@ModelAttribute("DTO") TongDTO dto) {
	    List<TongDTO> resultLst = new ArrayList<>();
	    try { 
	        resultLst = svc.tong07List(dto);
	        System.out.println("file 데이터 개수: " + resultLst.size());
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return resultLst; // 리스트만 반환하여 JSON 배열 구조 유지
	}				
}


