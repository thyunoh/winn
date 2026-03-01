package egovframework.wnn_medcost.total.web;


import java.util.Map;
import java.util.List;
import java.util.HashMap;
import java.util.ArrayList;

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

import egovframework.wnn_medcost.total.model.TotalDTO;
import egovframework.wnn_medcost.total.service.TotalService;
import egovframework.wnn_medcost.total.web.TotalController;


@Controller
@RequestMapping("/main")  // 클래스 레벨에서 기본 경로 설정
public class TotalController {
	
	private static final Logger log = LoggerFactory.getLogger(TotalController.class);
	
	@Resource(name = "TotalService") // 서비스 선언
	private TotalService svc;
	
	 
	
	@RequestMapping(value="/total_DataList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> total_DataList(@ModelAttribute("DTO") TotalDTO dto, HttpSession session, HttpServletRequest request, Model model) throws Exception {
		
		System.out.println("Select 시작했음");
		String returnValue = "OK";
		String err_cd = "0";
		// 처리 로직
		System.out.println("total_DataList 시작했음 1 - getHospCd  확인 - " + dto.getHospCd());
    	System.out.println("total_DataList 시작했음 2 - getWorkYm  확인 - " + dto.getWorkYm());
    	System.out.println("total_DataList 시작했음 3 - getCodeFg  확인 - " + dto.getCodeFg());
    	System.out.println("total_DataList 시작했음 4 - getMakeFg  확인 - " + dto.getMakeFg());
    	System.out.println("total_DataList 시작했음 5 - getUpdUser 확인 - " + dto.getUpdUser());
    	
		    
    	dto.setHospCd(dto.getHospCd());   // 요양기관번호
		dto.setWorkYm(dto.getWorkYm());   // 
		dto.setCodeFg(dto.getCodeFg());   // 
		dto.setMakeFg(dto.getMakeFg());   // 
		dto.setUpdUser(dto.getUpdUser()); // 작업구분
		
		List<TotalDTO>      resultdt;
		Map<String, Object> response = new HashMap<>();
		
        try {
        	
        	if        (dto.getMakeFg().equals("01")) {
            	System.out.println("total_DataList 01 - 시작했음");
            	resultdt = svc.total_DataList_01(dto);
            	response.put("data",resultdt);
		        System.out.println("total_DataList 01 response : " + response.size());
        	} else if        (dto.getMakeFg().equals("02")) {
            	System.out.println("total_DataList 02 - 시작했음");
            	resultdt = svc.total_DataList_02(dto);
            	response.put("data",resultdt);
		        System.out.println("total_DataList 02 response : " + response.size());
        	} else if (dto.getMakeFg().equals("03")) {   
        		System.out.println("total_DataList 03 - 시작했음");
            	resultdt = svc.total_DataList_03(dto);
            	response.put("data",resultdt);
		        System.out.println("total_DataList 03 response : " + response.size());
        	} else if (dto.getMakeFg().equals("04")) {   
        		System.out.println("total_DataList 04 - 시작했음");
            	resultdt = svc.total_DataList_04(dto);
            	response.put("data",resultdt);
		        System.out.println("total_DataList 04 response : " + response.size());    
        	} else if (dto.getMakeFg().equals("05")) {   
        		System.out.println("total_DataList 05 - 시작했음");
            	resultdt = svc.total_DataList_05(dto);
            	response.put("data",resultdt);
		        System.out.println("total_DataList 05 response : " + response.size());    
        	} else if (dto.getMakeFg().equals("06")) {   
        		System.out.println("total_DataList 06 - 시작했음");
            	resultdt = svc.total_DataList_06(dto);
            	response.put("data",resultdt);
		        System.out.println("total_DataList 06 response : " + response.size());    
        	} else if (dto.getMakeFg().equals("07")) {   
        		System.out.println("total_DataList 07 - 시작했음");
            	resultdt = svc.total_DataList_07(dto);
            	response.put("data",resultdt);
		        System.out.println("total_DataList 07 response : " + response.size());    
        	} else if (dto.getMakeFg().equals("08")) {   
        		System.out.println("total_DataList 08 - 시작했음");
            	resultdt = svc.total_DataList_08(dto);
            	response.put("data",resultdt);
		        System.out.println("total_DataList 08 response : " + response.size());    
        	} else if (dto.getMakeFg().equals("09")) {

        		System.out.println("total_DataList 09 - 시작했음");
            	resultdt = svc.total_DataList_09(dto);
            	response.put("data",resultdt);

            	List<TotalDTO> resultSub = svc.total_DataList_09_Sub(dto);
            	response.put("dataSub", resultSub);

		        System.out.println("total_DataList 09 response : " + response.size());    
        	} else if (dto.getMakeFg().equals("10")) {   
        		System.out.println("total_DataList 10 - 시작했음");
            	resultdt = svc.total_DataList_10(dto);
            	response.put("data",resultdt);
		        System.out.println("total_DataList 10 response : " + response.size());    
        	} else if (dto.getMakeFg().equals("11")) {   
        		System.out.println("total_DataList 11 - 시작했음");
            	resultdt = svc.total_DataList_11(dto);
            	response.put("data",resultdt);
		        System.out.println("total_DataList 11 response : " + response.size());    
        	} else if (dto.getMakeFg().equals("12")) {   
        		System.out.println("total_DataList 12 - 시작했음");
            	resultdt = svc.total_DataList_12(dto);
            	response.put("data",resultdt);
		        System.out.println("total_DataList 12 response : " + response.size());    
        	} else if (dto.getMakeFg().equals("13")) {   
        		System.out.println("total_DataList 13 - 시작했음");
            	resultdt = svc.total_DataList_13(dto);
            	response.put("data",resultdt);
		        System.out.println("total_DataList 13 response : " + response.size());    
        	} else if (dto.getMakeFg().equals("14")) {   
        		System.out.println("total_DataList 14 - 시작했음");
            	resultdt = svc.total_DataList_14(dto);
            	response.put("data",resultdt);
		        System.out.println("total_DataList 14 response : " + response.size());    
        	}
            
            return response;

        } catch (Exception ex) {
            model.addAttribute("error_code", ex.getMessage()); 
            return null;
        }
	}
}
