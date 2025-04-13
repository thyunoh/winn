package egovframework.wnn_consult.base.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.util.GetClientIP;
import egovframework.wnn_consult.base.service.BaseService;
import egovframework.wnn_consult.base.model.CodeMdDTO;
import egovframework.util.EgovFileScrty;

import org.springframework.ui.ModelMap;


@Controller
public class BaseController {

	private static final Logger log = LoggerFactory.getLogger(BaseController.class);
	
	
	@Resource(name = "BaseService") // 서비스 선언
	private BaseService svc;
    /*약관조회*/
	@RequestMapping(value="/base/ctl_selCommDtlInfo.do")
	public String base_selCommDtlInfo(@ModelAttribute("DTO") CodeMdDTO dto, HttpServletRequest request, ModelMap model) throws Exception {  
		try { 
			//코그구분 정보 조회
			List<?> resultList = svc.selCommDtlInfo(dto);

			model.addAttribute("resultList", resultList);
			model.addAttribute("resultCnt", resultList.size());
			model.addAttribute("error_code", "0"); 
	
		}catch(Exception ex) {
			model.addAttribute("error_code", "10000"); 
		}
		return "jsonView";
	}		
}
