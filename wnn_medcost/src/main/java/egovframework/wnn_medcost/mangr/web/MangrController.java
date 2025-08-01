package egovframework.wnn_medcost.mangr.web;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;


import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import egovframework.util.ClientInfo;
import egovframework.wnn_medcost.mangr.model.AsqDTO;
import egovframework.wnn_medcost.mangr.model.FaqDTO;
import egovframework.wnn_medcost.mangr.model.FileDTO;
import egovframework.wnn_medcost.mangr.model.NotiDTO;
import egovframework.wnn_medcost.mangr.service.MangrService;
import egovframework.wnn_medcost.user.model.LicnumDTO;
import egovframework.wnn_medcost.user.model.LisenceDTO;

import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.http.HttpStatus;
import org.apache.poi.ss.usermodel.CellType;
import org.apache.poi.ss.usermodel.DataFormatter;
import org.apache.poi.ss.usermodel.DateUtil;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.Gson;

@Controller
@RequestMapping("/mangr")  // 클래스 레벨에서 기본 경로 설정
public class MangrController {

	private static final Logger log = LoggerFactory.getLogger(MangrController.class);
	private static Map<String, String> cookie_value = new HashMap<>();
	
	@Resource(name = "MangrService") // 서비스 선언
	private MangrService svc;
	//자주하는 질문 
	@RequestMapping(value="/faqcd.do")
    public String faqcdcd(HttpServletRequest request, ModelMap model) {

        cookie_value = ClientInfo.getCookie(request);		
		try {
			if (cookie_value.get("s_hospid").trim() != null &&
				cookie_value.get("s_hospid").trim() != "" ) {
				return ".main/mangr/faqcd";				
			} else {
				return "";
			}	
		} catch(Exception ex) {
			return "";
		}
    }	
	//자주하는 질문 
	@RequestMapping(value="/faqCdList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> faqCdlist(@ModelAttribute("DTO") FaqDTO dto, HttpSession session, HttpServletRequest request, Model model) throws Exception {
		
		System.out.println("샘파일-java 1- start ");		
		
		cookie_value = ClientInfo.getCookie(request);		
		try {
			
			if (cookie_value.get("s_hospid").trim() != null &&
				cookie_value.get("s_hospid").trim() != "" ) {
				
				System.out.println("faq " + dto.getFaqSeq());
			
				List<FaqDTO> faqList = svc.getfaqCdList(dto);
				
				System.out.println("faq-java size " + faqList.size());
				
				Map<String, Object> response = new HashMap<>();
		        response.put("data",faqList);
		        response.put("error_code", "0"); // 정상 응답

		        System.out.println("faq-java response : " + response);
		        
		        return response;
				
				
			} else {
				return null;
			}	
		} catch(Exception ex) {
			return null;
		}
	}
	@RequestMapping(value="/faqCdInsert.do", method = RequestMethod.POST)
    public ResponseEntity<String> faqCdInsert(@RequestBody List<FaqDTO> data) {
		
		System.out.println("Insert 시작했음");
		String returnValue = "OK";
		
		// 처리 로직
        try {
        	
        	for (FaqDTO dto : data) {
        	//	String dupchk =   svc.faqCdDupChk(dto) ;
        	//	if ("Y".equals(dupchk)) {
        	//		return ResponseEntity.status(400).body(dto.getFaqSeq()); 
        	//	}
        		svc.insertfaqCd(dto) ; 
       		    System.out.println("FaqSeq: "      + dto.getFaqSeq());
       		    System.out.println("ansr_conts: "  + dto.getAnsrConts1());
       		    System.out.println("qstnConts: "   + dto.getQstnConts1());
            }
        	
            
        	return ResponseEntity.ok(returnValue);   
        	
        } catch (Exception e) {
        	
            return ResponseEntity.status(500).body(e.getMessage());
            
        }
	}
	@RequestMapping(value="/faqCdUpdate.do", method = RequestMethod.POST)
    public ResponseEntity<String> faqCdUpdate(@RequestBody List<FaqDTO> data) {
	
		System.out.println("Update 시작했음");
		String returnValue = "OK";
		// 처리 로직
        try {
        	
        	for (FaqDTO dto : data) {
        		System.out.println(dto.getFaqSeq());
        		svc.updatefaqCd(dto) ; //이력관리 
        		
            	svc.insertfaqCd(dto) ; 
       		    System.out.println("FaqSeq: "  + dto.getFaqSeq());
     	
            }
        	return ResponseEntity.ok(returnValue);   
        	
        } catch (Exception e) {
        	
            return ResponseEntity.status(500).body(e.getMessage());
            
        }
	}
	@RequestMapping(value="/faqCdDelete.do", method = RequestMethod.POST)
    public ResponseEntity<String> faqCdDelete(@RequestBody List<FaqDTO> data) {
		
		System.out.println("Delete 시작했음");
		String returnValue = "OK";
		// 처리 로직
        try {
        	for (FaqDTO dto : data) {
        		dto.setFaqSeq(dto.getKeyfaqSeq()); 
        		svc.updatefaqCd(dto) ; //이력관리 
       		    System.out.println("Key cateCode: " + dto.getKeyfaqSeq());
             
            }
        	return ResponseEntity.ok(returnValue);   
        	
        } catch (Exception e) {
        	
            return ResponseEntity.status(500).body(e.getMessage());
            
        }
	}	
	@RequestMapping(value="/noticd.do")
    public String noticd(HttpServletRequest request, ModelMap model , @RequestParam(value = "type", required = false, defaultValue = "notice") String type) {

        cookie_value = ClientInfo.getCookie(request);		
        model.addAttribute("type", type);
        try {
			if (cookie_value.get("s_hospid").trim() != null &&
				cookie_value.get("s_hospid").trim() != "" ) {
			    switch (type) {
			        case "notice":
			            model.addAttribute("title", "공지사항");
			            model.addAttribute("fileGb1", "1");   // 숫자값 전달
			            break;
			        case "review":
			            model.addAttribute("title", "심사방");
			            model.addAttribute("fileGb1", "2");   // 숫자값 전달
			            break;
			        case "newsletter":
			            model.addAttribute("title", "소식지");
			            model.addAttribute("fileGb1", "3");   // 숫자값 전달
			            break;
			        default:
			            model.addAttribute("title", "공지사항");
			            model.addAttribute("fileGb1", "1");
			    }  
				return ".main/mangr/noticd";				
			} else {
				return "";
			}	
		} catch(Exception ex) {
			return "";
		}
    }	
	@RequestMapping(value="/notiCdList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> notiCdList(@ModelAttribute("DTO") NotiDTO dto, HttpSession session, HttpServletRequest request, Model model) throws Exception {
		
		System.out.println("java 1- start ");		
		
		cookie_value = ClientInfo.getCookie(request);		
		try {
			
			if (cookie_value.get("s_hospid").trim() != null &&
				cookie_value.get("s_hospid").trim() != "" ) {
				
				System.out.println("Noti " + dto.getNotiSeq());
			    dto.setStartDt("20200101");
			    dto.setEndDt("20991231");
			    List<NotiDTO> notiList = svc.getnotiCdList(dto);
				
				System.out.println("Noti-java size " + notiList.size());
				
				Map<String, Object> response = new HashMap<>();
		        response.put("data",notiList);

		        System.out.println("Noti-java response : " + response);
		        
		        return response;
				
				
			} else {
				return null;
			}	
		} catch(Exception ex) {
			return null;
		}
	}
	@RequestMapping(value="/notiCdInsert.do", method = RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> notiCdInsert(@RequestBody List<NotiDTO> data) {
		
		System.out.println("Insert 시작했음");
		String returnValue = "OK";
		Map<String, Object> response = new HashMap<>();
        List<Long> notiSeqList = new ArrayList<>();		
		// 처리 로직
        try {
            for (NotiDTO dto : data) {
                svc.insertnotiCd(dto); // 공지사항 ID 생성
                notiSeqList.add((long) dto.getNotiSeq());
                System.out.println("NotiSeq: "  +dto.getNotiSeq());
                response.put("status", "OK");
                
                NotiDTO dto1 =  svc.selectNotiBySeq(dto.getNotiSeq());
                
                if (!notiSeqList.isEmpty()) {
                    response.put("hospCd", dto1.getHospCd()); 
                    response.put("notiSeq", dto1.getNotiSeq()); 
                    response.put("fileGb", dto1.getFileGb()); 
                    response.put("regUser", dto1.getRegUser()); 
                    response.put("regIp", dto1.getRegIp()); 
                    System.out.println("notiSeqList: "  +dto1.getNotiSeq());
                }
            }
            response.put("notiSeqList", notiSeqList); // 삽입된 공지사항 번호 리스트 반환
            return ResponseEntity.ok(response);

        } catch (Exception e) {
            response.put("status", "FAIL");
            response.put("message", e.getMessage());
            return ResponseEntity.status(500).body(response);
        }

	}
	@RequestMapping(value="/notiCdUpdate.do", method = RequestMethod.POST)
    public ResponseEntity<String> notiCdUpdate(@RequestBody List<NotiDTO> data) {
	
		System.out.println("Update 시작했음");
		String returnValue = "OK";
		// 처리 로직
        try {
        	
        	for (NotiDTO dto : data) {
        		System.out.println(dto.getNotiSeq());
        		svc.updatenotiCd(dto) ; //이력관리 
       		    System.out.println("FaqSeq: "  + dto.getNotiSeq());
     	
            }
        	return ResponseEntity.ok(returnValue);   
        	
        } catch (Exception e) {
        	
            return ResponseEntity.status(500).body(e.getMessage());
            
        }
	}
	@RequestMapping(value="/notiCdDelete.do", method = RequestMethod.POST)
    public ResponseEntity<String> notiCdDelete(@RequestBody List<NotiDTO> data) {
		
		System.out.println("Delete 시작했음");
		String returnValue = "OK";
		// 처리 로직
        try {
        	for (NotiDTO dto : data) {
        		dto.setNotiSeq(dto.getKeynotiSeq()); 
        		dto.setFileGb(dto.getKeyfileGb()); 
        		svc.delupdatenotiCd(dto) ; //이력관리 
       		    System.out.println("Key notiSEQ: " + dto.getKeynotiSeq());
             
            }
        	return ResponseEntity.ok(returnValue);   
        	
        } catch (Exception e) {
        	
            return ResponseEntity.status(500).body(e.getMessage());
            
        }
	}	
	//화일문서관리 
	@RequestMapping(value="/fileCdInsert.do", method = RequestMethod.POST)
    public ResponseEntity<String> fileCdInsert(@RequestBody List<FileDTO> data) {
		
		System.out.println("Insert 시작했음");
		String returnValue = "OK";
	
		// 처리 로직
        try {
        	
        	for (FileDTO dto : data) {
        		svc.insertFileCd(dto) ; 
       		    System.out.println("NotiSeq: "  + dto.getFilePath());
            }
        	return ResponseEntity.ok(returnValue);   
        	
        } catch (Exception e) {
        	
            return ResponseEntity.status(500).body(e.getMessage());
            
        }
	}
	@RequestMapping(value="/fileCdUpdate.do", method = RequestMethod.POST)
    public ResponseEntity<String> fileCdUpdate(@RequestBody List<FileDTO> data) {
	
		System.out.println("Update 시작했음");
		String returnValue = "OK";
		// 처리 로직
        try {
        	
        	for (FileDTO dto : data) {
        		System.out.println(dto.getFilePath());
        		svc.updateFileCd(dto) ; //이력관리 
        		
            	svc.insertFileCd(dto) ; 
       		    System.out.println("FaqSeq: "  + dto.getFilePath());
     	
            }
        	return ResponseEntity.ok(returnValue);   
        	
        } catch (Exception e) {
        	
            return ResponseEntity.status(500).body(e.getMessage());
            
        }
	}
	@RequestMapping(value="/fileCdDelete.do", method = RequestMethod.POST)
    public ResponseEntity<String> fileCdDelete(@RequestBody List<FileDTO> data) {
		
		System.out.println("Delete 시작했음");
		String returnValue = "OK";
		// 처리 로직
        try {
        	for (FileDTO dto : data) {
        		dto.setFileSeq(dto.getKeyfileSeq()); 
        		dto.setFileGb(dto.getKeyfileGb()); 
        		dto.setSeq(dto.getKeyseq()); 
        		svc.updateFileCd(dto) ; //이력관리 
       		    System.out.println("Key cateCode: " + dto.getKeyfileSeq());
             
            }
        	return ResponseEntity.ok(returnValue);   
        	
        } catch (Exception e) {
        	
            return ResponseEntity.status(500).body(e.getMessage());
            
        }
	}	
	//질의응답 
	@RequestMapping(value="/asqcd.do")
    public String asqcdcd(HttpServletRequest request, ModelMap model) {

        cookie_value = ClientInfo.getCookie(request);		
		try {
			if (cookie_value.get("s_hospid").trim() != null &&
				cookie_value.get("s_hospid").trim() != "" ) {
				return ".main/mangr/asqcd";				
			} else {
				return "";
			}	
		} catch(Exception ex) {
			return "";
		}
    }
	//질문리스트  
	@RequestMapping(value="/asqCdList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> asqCdList(@ModelAttribute("DTO") AsqDTO dto, HttpSession session, HttpServletRequest request, Model model) throws Exception {
		cookie_value = ClientInfo.getCookie(request);		
		try {
			
			if (cookie_value.get("s_hospid").trim() != null &&
				cookie_value.get("s_hospid").trim() != "" ) {
				
				System.out.println("Asq " + dto.getAsqSeq());
				
			    List<AsqDTO> asqList = svc.getasqCdList(dto);
			    
				System.out.println("Noti-java size " + asqList.size());
				Map<String, Object> response = new HashMap<>();
		        response.put("data",asqList);
		        System.out.println("Noti-java response : " + response);
		        return response;
			
			} else {
				return null;
			}	
		} catch(Exception ex) {
			return null;
		}
	}
	//답변달기 
	@RequestMapping(value="/asqCdUpdate.do", method = RequestMethod.POST)
    public ResponseEntity<String> asqCdUpdate(@RequestBody List<AsqDTO> data) {
	
		System.out.println("Update 시작했음");
		String returnValue = "OK";
		// 처리 로직
        try {
        	
        	for (AsqDTO dto : data) {
        		System.out.println(dto.getAsqGb());
        		svc.updateasqCd(dto) ; //이력관리 
       		    System.out.println("AsqGb: "  + dto.getAsqGb());
     	
            }
        	return ResponseEntity.ok(returnValue);   
        	
        } catch (Exception e) {
        	
            return ResponseEntity.status(500).body(e.getMessage());
            
        }
	}
	/*문서화일*/	
	@RequestMapping(value= "/fileCdList.do", method = RequestMethod.POST)
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
	@RequestMapping(value="/report/filelist.do")
    public String filelist(HttpServletRequest request, ModelMap model) {

        cookie_value = ClientInfo.getCookie(request);		
		try {
			if (cookie_value.get("s_hospid").trim() != null &&
				cookie_value.get("s_hospid").trim() != "" ) {
				return ".main/mangr/report/filelist";				
			} else {  	
				return "";
			}	
		} catch(Exception ex) {
			return "";
		}
    }
	/* 사이드바 일대일 질의응답 */	
	@RequestMapping(value= "/asqList.do")
	public String ctl_asqList(@ModelAttribute("DTO") AsqDTO dto, HttpServletRequest request, ModelMap model) throws Exception {  
		try { 
			//코그구분 정보 조회
			List<?>  resultLst = svc.getasqCdList(dto);
			model.addAttribute("resultLst", resultLst);
			model.addAttribute("resultCnt", resultLst.size());
			model.addAttribute("error_code", "0"); 
		}catch(Exception ex) {
			model.addAttribute("error_code", "10000"); 
		}
		return "jsonView";
	}	
	/* 사이드바 일대일 질의응답 */	
	@RequestMapping(value= "/selectAnsrInfo.do")
	public String mangr_selectAnsrInfo(@ModelAttribute("DTO") AsqDTO dto, HttpServletRequest request, ModelMap model) throws Exception {  
		try { 
			//코그구분 정보 조회
			AsqDTO  result = svc.selectQstnInfo(dto);
			model.addAttribute("result", result);
			model.addAttribute("error_code", "0"); 
		}catch(Exception ex) {
			model.addAttribute("error_code", "10000"); 
		}
		return "jsonView";
	}	
	/* 사이드바 일대일 질의응답 */	 
	@RequestMapping(value="/asqSaveAct.do")
	public String mangr_asqSaveAct(@ModelAttribute("DTO") AsqDTO dto, HttpServletRequest request, ModelMap model) throws Exception {  
		try { 
			//코그구분 정보 조회
			System.out.println("getIud " + dto.getIud());
			if ("QI".equals(dto.getIud())){
				svc.insertQstnCd(dto) ;
			}else if ("QU".equals(dto.getIud())){
				svc.updateQstnCd(dto) ; 
				svc.insertQstnCd(dto) ;
			}else if ("QD".equals(dto.getIud())){
				svc.updateQstnCd(dto) ; 
			}
			model.addAttribute("error_code", "0"); 	
		}catch(Exception ex) {
			model.addAttribute("error_code", "10000"); 
		}
		return "jsonView";
	}			
}

