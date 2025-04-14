package egovframework.wnn_medcost.base.web;

import java.util.Map;
import java.util.List;
import java.util.HashMap;
import java.util.ArrayList;

import javax.annotation.Resource;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpSession;
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
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.http.ResponseEntity;

import com.fasterxml.jackson.databind.ObjectMapper;

import egovframework.wnn_medcost.base.model.CodeMdDTO;
import egovframework.wnn_medcost.base.model.SugaCdDTO;
import egovframework.wnn_medcost.base.model.WvalDTO;
import egovframework.wnn_medcost.base.model.YakgaCdDTO;
import egovframework.wnn_medcost.base.model.DiseCdDTO;
import egovframework.wnn_medcost.base.model.JearyoCdDTO;
import egovframework.wnn_medcost.base.model.SamverDTO;
import egovframework.wnn_medcost.base.service.BaseService;
import egovframework.wnn_medcost.util.ResponseObject;
import egovframework.util.ClientInfo;
import egovframework.util.EgovFileScrty;


@Controller
@RequestMapping("/base")  // 클래스 레벨에서 기본 경로 설정
public class BaseController {

	private static final Logger log = LoggerFactory.getLogger(BaseController.class);
	private static Map<String, String> cookie_value = new HashMap<>();
	
	@Resource(name = "BaseService") // 서비스 선언
	private BaseService svc;

	
	/* suga List */

	@RequestMapping(value="/sugacd.do")
    public String sugacd(HttpServletRequest request, ModelMap model) {

        cookie_value = ClientInfo.getCookie(request);		
		try {
			if (cookie_value.get("s_hospid").trim() != null &&
				cookie_value.get("s_hospid").trim() != "" ) {
				return ".main/base/sugacd";				
			} else {
				return "";
			}	
		} catch(Exception ex) {
			return "";
		}
    }	 	
	@RequestMapping(value="/sugaCdList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getSugaCdList(@ModelAttribute("DTO") SugaCdDTO dto, HttpSession session, HttpServletRequest request, Model model) throws Exception {
		
		System.out.println("수가-java 1- start ");		
		
		cookie_value = ClientInfo.getCookie(request);		
		try {
			
			if (cookie_value.get("s_hospid").trim() != null &&
				cookie_value.get("s_hospid").trim() != "" ) {
				
				dto.setFindData(dto.getFindData());
				dto.setFeeType(dto.getFeeType());
				
				List<SugaCdDTO> sugaList = svc.getSugaCdList(dto);
				
				System.out.println("수가-java size " + sugaList.size());
				
				Map<String, Object> response = new HashMap<>();
		        response.put("data",sugaList);

		        System.out.println("수가-java response : " + response);
		        
		        return response;
				
				
			} else {
				return null;
			}	
		} catch(Exception ex) {
			return null;
		}
	}
	
	@RequestMapping(value="/commList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getCommList(@ModelAttribute("DTO") CodeMdDTO dto, HttpSession session, HttpServletRequest request, Model model) throws Exception {
		
		System.out.println("공통-java 1- start ");
		cookie_value = ClientInfo.getCookie(request);	
				
		try {
			
			if (cookie_value.get("s_hospid").trim() != null &&
				cookie_value.get("s_hospid").trim() != "" ) {
				
				List<String> codeGbList = dto.getListGb();
		        List<String> codeCdList = dto.getListCd();		
		        
			    System.out.println("listGb: " + codeGbList);
				System.out.println("listCd: " + codeCdList);
				
				List<CodeMdDTO> commList = svc.getCommList(codeGbList, codeCdList);

				for (CodeMdDTO item : commList) {
					
					System.out.println(item.getCodeCd());
					System.out.println(item.getSubCode());
		            System.out.println(item.getSubCodeNm());
		            
		        }
		        
				Map<String, Object> response = new HashMap<>();
		        response.put("data",commList);

		        System.out.println("공통-java response : " + response);

		        System.out.println("공통-java 1- end ");
		        
		        return response;
		        
			} else {
				return null;
			}
						
		} catch(Exception ex) {
			return null;
		}
	}
	
	
	
	@RequestMapping(value="/sugaCdInsert.do", method = RequestMethod.POST)
    public ResponseEntity<String> sugaInsert(@RequestBody List<SugaCdDTO> data) {
		
		System.out.println("Insert 시작했음");
		String returnValue = "OK";
		// 처리 로직
        try {
        	for (SugaCdDTO dto : data) {
        		String dupchk =   svc.SugaCdMstDupChk(dto) ;
        		if ("Y".equals(dupchk)) {
        			return ResponseEntity.status(400).body(dto.getFeeCode()); 
        		}
        		svc.insertSugaCdMst(dto) ; 
       		    System.out.println("Fee Code: " + dto.getFeeCode());
       		    System.out.println("Start_Dt: " + dto.getStartDt());
            }

         
        	return ResponseEntity.ok(returnValue);   
        	
        } catch (Exception e) {
        	
            return ResponseEntity.status(500).body(e.getMessage());
            
        }
	}
	@RequestMapping(value="/sugaCdUpdate.do", method = RequestMethod.POST)
    public ResponseEntity<String> sugaUpdate(@RequestBody List<SugaCdDTO> data) {
	
		System.out.println("Update 시작했음");
		String returnValue = "OK";
		// 처리 로직
        try {
        	
        	for (SugaCdDTO dto : data) {
        		svc.updateSugaCdMst(dto) ; //이력관리 
            	svc.insertSugaCdMst(dto) ; 
       		    System.out.println("Fee Code: " + dto.getFeeCode());
                System.out.println("Start_Dt: " + dto.getStartDt());
     	
            }
        	return ResponseEntity.ok(returnValue);   
        	
        } catch (Exception e) {
        	
            return ResponseEntity.status(500).body(e.getMessage());
            
        }
	}
	@RequestMapping(value="/sugaCdDelete.do", method = RequestMethod.POST)
    public ResponseEntity<String> sugaDelete(@RequestBody List<SugaCdDTO> data) {
		
		System.out.println("Delete 시작했음");
		String returnValue = "OK";
		// 처리 로직
        try {
        	for (SugaCdDTO dto : data) {
        		dto.setFeeCode(dto.getKeyFeeCode()); 
        		dto.setFeeType(dto.getKeyFeeType()); 
        		dto.setStartDt(dto.getKeyStartDt()); 
        		svc.updateSugaCdMst(dto) ; //이력관리 
       		    System.out.println("Key fee code: " + dto.getKeyFeeCode());
       		    System.out.println("Key Fee type: " + dto.getKeyFeeType());
       		    System.out.println("Key Start dt: " + dto.getKeyStartDt());                
            }
        	return ResponseEntity.ok(returnValue);   
        	
        } catch (Exception e) {
        	
            return ResponseEntity.status(500).body(e.getMessage());
            
        }
	}
	@RequestMapping(value="/disecd.do")
    public String disecd(HttpServletRequest request, ModelMap model) {

        cookie_value = ClientInfo.getCookie(request);		
		try {
			if (cookie_value.get("s_hospid").trim() != null &&
				cookie_value.get("s_hospid").trim() != "" ) {
				return ".main/base/disecd";				
			} else {
				return "";
			}	
		} catch(Exception ex) {
			return "";
		}
    }	
	@RequestMapping(value="/diseCdList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getDiseCdList(@ModelAttribute("DTO") DiseCdDTO dto, HttpSession session, HttpServletRequest request, Model model) throws Exception {
		
		System.out.println("상병-java 1- start ");		
		
		cookie_value = ClientInfo.getCookie(request);		
		try {
			
			if (cookie_value.get("s_hospid").trim() != null &&
				cookie_value.get("s_hospid").trim() != "" ) {
				
				dto.setFindData(dto.getFindData());
				
				List<DiseCdDTO> diseList = svc.getDiseCdList(dto);
				
				System.out.println("상병-java size " + diseList.size());
				
				Map<String, Object> response = new HashMap<>();
		        response.put("data",diseList);

		        System.out.println("수가-java response : " + response);
		        
		        return response;
				
				
			} else {
				return null;
			}	
		} catch(Exception ex) {
			return null;
		}
	}	
	@RequestMapping(value="/diseCdInsert.do", method = RequestMethod.POST)
    public ResponseEntity<String> diseInsert(@RequestBody List<DiseCdDTO> data) {
		
		System.out.println("Insert 시작했음");
		String returnValue = "OK";
		
		// 처리 로직
        try {
        	
        	for (DiseCdDTO dto : data) {
        		String dupchk =   svc.DiseCdMstDupChk(dto) ;
        		if ("Y".equals(dupchk)) {
        			return ResponseEntity.status(400).body(dto.getDiagCode()); 
        		}
        		svc.insertDiseCdMst(dto) ; 
       		    System.out.println("Fee Code: " + dto.getDiagCode());
       		    System.out.println("Start_Dt: " + dto.getStartDt());
            }
        	
            
        	return ResponseEntity.ok(returnValue);   
        	
        } catch (Exception e) {
        	
            return ResponseEntity.status(500).body(e.getMessage());
            
        }
	}
	@RequestMapping(value="/diseCdUpdate.do", method = RequestMethod.POST)
    public ResponseEntity<String> diseCdUpdate(@RequestBody List<DiseCdDTO> data) {
	
		System.out.println("Update 시작했음");
		String returnValue = "OK";
		// 처리 로직
        try {
        	
        	for (DiseCdDTO dto : data) {
        		svc.updateDiseCdMst(dto) ; //이력관리 
            	svc.insertDiseCdMst(dto) ; 
       		    System.out.println("Fee Code: " + dto.getDiagCode());
                System.out.println("Start_Dt: " + dto.getStartDt());
     	
            }
        	return ResponseEntity.ok(returnValue);   
        	
        } catch (Exception e) {
        	
            return ResponseEntity.status(500).body(e.getMessage());
            
        }
	}
	@RequestMapping(value="/diseCdDelete.do", method = RequestMethod.POST)
    public ResponseEntity<String> diseCdDelete(@RequestBody List<DiseCdDTO> data) {
		
		System.out.println("Delete 시작했음");
		String returnValue = "OK";
		// 처리 로직
        try {
        	for (DiseCdDTO dto : data) {
        		dto.setDiagCode(dto.getKeyDiagCode()); 
        		dto.setStartDt(dto.getKeyStartDt()); 
        		svc.updateDiseCdMst(dto) ; //이력관리 
       		    System.out.println("Key fee code: " + dto.getKeyDiagCode());
       		    System.out.println("Key Start dt: " + dto.getKeyStartDt());                
            }
        	return ResponseEntity.ok(returnValue);   
        	
        } catch (Exception e) {
        	
            return ResponseEntity.status(500).body(e.getMessage());
            
        }
	}
	//공통코드 마스터 
	@RequestMapping(value="/commcd.do")
    public String commcd(HttpServletRequest request, ModelMap model) {

        cookie_value = ClientInfo.getCookie(request);		
		try {
			if (cookie_value.get("s_hospid").trim() != null &&
				cookie_value.get("s_hospid").trim() != "" ) {
				return ".main/base/commcd";				
			} else {
				return "";
			}	
		} catch(Exception ex) {
			return "";
		}
    }	
	@RequestMapping(value="/commMstList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> commMstList(@ModelAttribute("DTO") CodeMdDTO dto, HttpSession session, HttpServletRequest request, Model model) throws Exception {
		
		System.out.println("상병-java 1- start ");		
		
		cookie_value = ClientInfo.getCookie(request);		
		try {
			
			if (cookie_value.get("s_hospid").trim() != null &&
				cookie_value.get("s_hospid").trim() != "" ) {
				
				dto.setFindData(dto.getFindData());
				
				List<CodeMdDTO> commmstList = svc.getCommMstList(dto);
				
				System.out.println("상병-java size " + commmstList.size());
				
				Map<String, Object> response = new HashMap<>();
		        response.put("data",commmstList);

		        System.out.println("수가-java response : " + response);
		        
		        return response;
				
				
			} else {
				return null;
			}	
		} catch(Exception ex) {
			return null;
		}
	}	
	@RequestMapping(value="/commMstInsert.do", method = RequestMethod.POST)
    public ResponseEntity<String> commMstInsert(@RequestBody List<CodeMdDTO> data) {
		
		System.out.println("Insert 시작했음");
		String returnValue = "OK";
		
		// 처리 로직
        try {
        	
        	for (CodeMdDTO dto : data) {
        		String dupchk =   svc.CommMstDupChk(dto) ;
        		if ("Y".equals(dupchk)) {
        			return ResponseEntity.status(400).body(dto.getCodeCd()); 
        		}
        		svc.insertCommMst(dto) ; 
       		    System.out.println("Fee Code: " + dto.getCodeCd());
       		    System.out.println("Start_Dt: " + dto.getStartDt());
            }
        	
            
        	return ResponseEntity.ok(returnValue);   
        	
        } catch (Exception e) {
        	
            return ResponseEntity.status(500).body(e.getMessage());
            
        }
	}
	@RequestMapping(value="/commMstUpdate.do", method = RequestMethod.POST)
    public ResponseEntity<String> commMstUpdate(@RequestBody List<CodeMdDTO> data) {
	
		System.out.println("Update 시작했음");
		String returnValue = "OK";
		// 처리 로직
        try {
        	
        	for (CodeMdDTO dto : data) {
        		svc.updateCommMst(dto) ; //이력관리 
            	svc.insertCommMst(dto) ; 
       		    System.out.println("code_cd: "  + dto.getCodeCd());
                System.out.println("Start_Dt: " + dto.getStartDt());
     	
            }
        	return ResponseEntity.ok(returnValue);   
        	
        } catch (Exception e) {
        	
            return ResponseEntity.status(500).body(e.getMessage());
            
        }
	}
	@RequestMapping(value="/commMstDelete.do", method = RequestMethod.POST)
    public ResponseEntity<String> commMstDelete(@RequestBody List<CodeMdDTO> data) {
		
		System.out.println("Delete 시작했음");
		String returnValue = "OK";
		// 처리 로직
        try {
        	for (CodeMdDTO dto : data) {
        		dto.setCodeCd(dto.getKeycodeCd()); 
        		svc.updateCommMst(dto) ; //이력관리 
       		    System.out.println("Key code_cd: " + dto.getKeycodeCd());
             
            }
        	return ResponseEntity.ok(returnValue);   
        	
        } catch (Exception e) {
        	
            return ResponseEntity.status(500).body(e.getMessage());
            
        }
	}	
	//공통세부코드 
	@RequestMapping(value="/commDtlList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> commDtlList(@ModelAttribute("DTO") CodeMdDTO dto, HttpSession session, HttpServletRequest request, Model model) throws Exception {
		
		System.out.println("상병-java 1- start ");		
		
		cookie_value = ClientInfo.getCookie(request);		
		try {
			
			if (cookie_value.get("s_hospid").trim() != null &&
				cookie_value.get("s_hospid").trim() != "" ) {
				
				dto.setFindData(dto.getFindData()); 
				
				List<CodeMdDTO> commdtlList = svc.getCodeDtlList(dto);
				
				System.out.println("상병-java size " + commdtlList.size());
				
				Map<String, Object> response = new HashMap<>();
		        response.put("data",commdtlList);

		        System.out.println("수가-java response : " + response);
		        
		        return response;
				
				
			} else {
				return null;
			}	
		} catch(Exception ex) {
			return null;
		}
	}	
	@RequestMapping(value="/CommDtlInsert.do", method = RequestMethod.POST)
    public ResponseEntity<String> CommDtlInsert(@RequestBody List<CodeMdDTO> data) {
		
		System.out.println("Insert 시작했음");
		String returnValue = "OK";
		
		// 처리 로직
        try {
        	
        	for (CodeMdDTO dto : data) {
        		String dupchk =   svc.CommDtlDupChk(dto) ;
        		if ("Y".equals(dupchk)) {
        			return ResponseEntity.status(400).body(dto.getCodeCd()); 
        		}
        		svc.insertCommDtl(dto) ; 
       		    System.out.println("Fee Code: " + dto.getCodeCd());
       		    System.out.println("Start_Dt: " + dto.getStartDt());
            }
        	
            
        	return ResponseEntity.ok(returnValue);   
        	
        } catch (Exception e) {
        	
            return ResponseEntity.status(500).body(e.getMessage());
            
        }
	}
	@RequestMapping(value="/CommDtlUpdate.do", method = RequestMethod.POST)
    public ResponseEntity<String> CommDtlUpdate(@RequestBody List<CodeMdDTO> data) {
	
		System.out.println("Update 시작했음");
		String returnValue = "OK";
		// 처리 로직
        try {
        	
        	for (CodeMdDTO dto : data) {
        		svc.updateCommDtl(dto) ; //이력관리 
            	svc.insertCommDtl(dto) ; 
       		    System.out.println("code_cd: "  + dto.getCodeCd());
                System.out.println("Start_Dt: " + dto.getStartDt());
     	
            }
        	return ResponseEntity.ok(returnValue);   
        	
        } catch (Exception e) {
        	
            return ResponseEntity.status(500).body(e.getMessage());
            
        }
	}
	@RequestMapping(value="/CommDtlDelete.do", method = RequestMethod.POST)
    public ResponseEntity<String> CommDtlDelete(@RequestBody List<CodeMdDTO> data) {
		
		System.out.println("Delete 시작했음");
		String returnValue = "OK";
		// 처리 로직
        try {
        	for (CodeMdDTO dto : data) {
        		dto.setCodeCd(dto.getKeycodeCd()); 
        		dto.setCodeGb(dto.getKeycodeGb());
        		dto.setSubCode(dto.getKeysubCode()); 
        		svc.updateCommDtl(dto) ; //이력관리 
       		    System.out.println("Key code_cd: " + dto.getKeycodeCd());
             
            }
        	return ResponseEntity.ok(returnValue);   
        	
        } catch (Exception e) {
        	
            return ResponseEntity.status(500).body(e.getMessage());
            
        }
	}	
	//가증치관리 
	@RequestMapping(value="/wvalcd.do")
    public String wvalcd(HttpServletRequest request, ModelMap model) {

        cookie_value = ClientInfo.getCookie(request);		
		try {
			if (cookie_value.get("s_hospid").trim() != null &&
				cookie_value.get("s_hospid").trim() != "" ) {
				return ".main/base/wvalcd";				
			} else {
				return "";
			}	
		} catch(Exception ex) {
			return "";
		}
    }
	@RequestMapping(value="/wvalcdList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getwvalcdList(@ModelAttribute("DTO") WvalDTO dto, HttpSession session, HttpServletRequest request, Model model) throws Exception {
		
		System.out.println("가중치-java 1- start ");		
		
		cookie_value = ClientInfo.getCookie(request);		
		try {
			
			if (cookie_value.get("s_hospid").trim() != null &&
				cookie_value.get("s_hospid").trim() != "" ) {
				
				dto.setFindData(dto.getFindData());
	
				List<WvalDTO> wvalList = svc.getWvalueList(dto);
				
				System.out.println("가중치-java size " + wvalList.size());
				
				Map<String, Object> response = new HashMap<>();
		        response.put("data",wvalList);

		        System.out.println("수가-java response : " + response);
		        
		        return response;
				
				
			} else {
				return null;
			}	
		} catch(Exception ex) {
			return null;
		}
	}	
	@RequestMapping(value="/WvalueInsert.do", method = RequestMethod.POST)
    public ResponseEntity<String> WvalueInsert(@RequestBody List<WvalDTO> data) {
		
		System.out.println("Insert 시작했음");
		String returnValue = "OK";
		
		// 처리 로직
        try {
        	
        	for (WvalDTO dto : data) {
        		String dupchk =   svc.WvalueDupChk(dto) ;
        		if ("Y".equals(dupchk)) {
        			return ResponseEntity.status(400).body(dto.getCateCode()); 
        		}
        		svc.insertWvalue(dto) ; 
       		    System.out.println("Fee Code: " + dto.getCateCode());
       		    System.out.println("Start_Dt: " + dto.getStartDt());
            }
        	
            
        	return ResponseEntity.ok(returnValue);   
        	
        } catch (Exception e) {
        	
            return ResponseEntity.status(500).body(e.getMessage());
            
        }
	}
	@RequestMapping(value="/WvalueUpdate.do", method = RequestMethod.POST)
    public ResponseEntity<String> WvalueUpdate(@RequestBody List<WvalDTO> data) {
	
		System.out.println("Update 시작했음");
		String returnValue = "OK";
		// 처리 로직
        try {
        	
        	for (WvalDTO dto : data) {
        		svc.updateWvalue(dto) ; //이력관리 
            	svc.insertWvalue(dto) ; 
       		    System.out.println("code_cd: "  + dto.getCateCode());
                System.out.println("Start_Dt: " + dto.getStartDt());
     	
            }
        	return ResponseEntity.ok(returnValue);   
        	
        } catch (Exception e) {
        	
            return ResponseEntity.status(500).body(e.getMessage());
            
        }
	}
	@RequestMapping(value="/WvalueDelete.do", method = RequestMethod.POST)
    public ResponseEntity<String> WvalueDelete(@RequestBody List<WvalDTO> data) {
		
		System.out.println("Delete 시작했음");
		String returnValue = "OK";
		// 처리 로직
        try {
        	for (WvalDTO dto : data) {
        		dto.setCateCode(dto.getKeycateCode()); 
        		dto.setOrderSeq(dto.getKeyorderSeq());
        		dto.setStartDt(dto.getKeystartDt()); 
        		svc.updateWvalue(dto) ; //이력관리 
       		    System.out.println("Key cateCode: " + dto.getKeycateCode());
             
            }
        	return ResponseEntity.ok(returnValue);   
        	
        } catch (Exception e) {
        	
            return ResponseEntity.status(500).body(e.getMessage());
            
        }
	}	
	//샘파일 load 
	@RequestMapping(value="/samvercd.do")
    public String samvercd(HttpServletRequest request, ModelMap model) {

        cookie_value = ClientInfo.getCookie(request);		
		try {
			if (cookie_value.get("s_hospid").trim() != null &&
				cookie_value.get("s_hospid").trim() != "" ) {
				return ".main/base/samvercd";				
			} else {
				return "";
			}	
		} catch(Exception ex) {
			return "";
		}
    }		
	@RequestMapping(value="/samverCdlist.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> samverCdlist(@ModelAttribute("DTO") SamverDTO dto, HttpSession session, HttpServletRequest request, Model model) throws Exception {
		
		System.out.println("샘파일-java 1- start ");		
		
		cookie_value = ClientInfo.getCookie(request);		
		try {
			
			if (cookie_value.get("s_hospid").trim() != null &&
				cookie_value.get("s_hospid").trim() != "" ) {
				
				System.out.println("samver " + dto.getSamver());
			
				List<SamverDTO> samList = svc.getsamverCdlist(dto);
				
				System.out.println("샘파일-java size " + samList.size());
				
				Map<String, Object> response = new HashMap<>();
		        response.put("data",samList);

		        System.out.println("샘파일-java response : " + response);
		        
		        return response;
				
				
			} else {
				return null;
			}	
		} catch(Exception ex) {
			return null;
		}
	}
	@RequestMapping(value="/samverCdInsert.do", method = RequestMethod.POST)
    public ResponseEntity<String> samverCdInsert(@RequestBody List<SamverDTO> data) {
		
		System.out.println("Insert 시작했음");
		String returnValue = "OK";
		
		// 처리 로직
        try {
        	
        	for (SamverDTO dto : data) {
        		String dupchk =   svc.samverCdDupChk(dto) ;
        		if ("Y".equals(dupchk)) {
        			return ResponseEntity.status(400).body(dto.getTblinfo()); 
        		}
        		svc.insertsamverCd(dto) ; 
       		    System.out.println("Tblinfo: "  + dto.getTblinfo());
       		    System.out.println("Version: "  + dto.getVersion());
            }
        	
            
        	return ResponseEntity.ok(returnValue);   
        	
        } catch (Exception e) {
        	
            return ResponseEntity.status(500).body(e.getMessage());
            
        }
	}
	@RequestMapping(value="/samverCdUpdate.do", method = RequestMethod.POST)
    public ResponseEntity<String> samverCdUpdate(@RequestBody List<SamverDTO> data) {
	
		System.out.println("Update 시작했음");
		String returnValue = "OK";
		// 처리 로직
        try {
        	
        	for (SamverDTO dto : data) {
        		System.out.println(dto.getTblinfo());
        		svc.updatesamverCd(dto) ; //이력관리 
        		
            	svc.insertsamverCd(dto) ; 
       		    System.out.println("Tblinfo: "  + dto.getTblinfo());
                System.out.println("Version: " + dto.getVersion());
     	
            }
        	return ResponseEntity.ok(returnValue);   
        	
        } catch (Exception e) {
        	
            return ResponseEntity.status(500).body(e.getMessage());
            
        }
	}
	@RequestMapping(value="/samverCdDelete.do", method = RequestMethod.POST)
    public ResponseEntity<String> samverCdDelete(@RequestBody List<SamverDTO> data) {
		
		System.out.println("Delete 시작했음");
		String returnValue = "OK";
		// 처리 로직
        try {
        	for (SamverDTO dto : data) {
        		dto.setSamver(dto.getKeysamver());
        		dto.setTblinfo(dto.getKeytblinfo()); 
        		dto.setVersion(dto.getKeyversion());
        		dto.setSeq(dto.getKeyseq()); 
        		svc.updatesamverCd(dto) ; //이력관리 
       		    System.out.println("Key cateCode: " + dto.getKeytblinfo());
             
            }
        	return ResponseEntity.ok(returnValue);   
        	
        } catch (Exception e) {
        	
            return ResponseEntity.status(500).body(e.getMessage());
            
        }
	}
	//약가관리 
	@RequestMapping(value="/yakgacd.do")
    public String yakgacd(HttpServletRequest request, ModelMap model) {

        cookie_value = ClientInfo.getCookie(request);		
		try {
			if (cookie_value.get("s_hospid").trim() != null &&
				cookie_value.get("s_hospid").trim() != "" ) {
				return ".main/base/yakgacd";				
			} else {
				return "";
			}	
		} catch(Exception ex) {
			return "";
		}
    }	
	@RequestMapping(value="/yakgaCdList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getyakgaCdList(@ModelAttribute("DTO") YakgaCdDTO dto, HttpSession session, HttpServletRequest request, Model model) throws Exception {
		
		System.out.println("수가-java 1- start ");		
		
		cookie_value = ClientInfo.getCookie(request);		
		try {
			
			if (cookie_value.get("s_hospid").trim() != null &&
				cookie_value.get("s_hospid").trim() != "" ) {
				
				dto.setFindData(dto.getFindData());
				
				List<YakgaCdDTO> yakgaList = svc.getYakgaCdList(dto);
				
				System.out.println("약갸-java size " + yakgaList.size());
				
				Map<String, Object> response = new HashMap<>();
		        response.put("data",yakgaList);

		        System.out.println("수가-java response : " + response);
		        
		        return response;
				
				
			} else {
				return null;
			}	
		} catch(Exception ex) {
			return null;
		}
	}
	@RequestMapping(value="/yakgaCdUpdate.do", method = RequestMethod.POST)
    public ResponseEntity<String> yakgaCdUpdate(@RequestBody List<YakgaCdDTO> data) {
	
		System.out.println("Update 시작했음");
		String returnValue = "OK";
		// 처리 로직
        try {
        	
        	for (YakgaCdDTO dto : data) {
        		svc.updateYakCdMst(dto) ; //이력관리 
       		    System.out.println("Fee Code: " + dto.getFeeCode());
                System.out.println("Start_Dt: " + dto.getStartDt());
     	
            }
        	return ResponseEntity.ok(returnValue);   
        	
        } catch (Exception e) {
        	
            return ResponseEntity.status(500).body(e.getMessage());
            
        }
	}	
	//재료대관리 
	@RequestMapping(value="/jaeryocd.do")
    public String jaeryocd(HttpServletRequest request, ModelMap model) {

        cookie_value = ClientInfo.getCookie(request);		
		try {
			if (cookie_value.get("s_hospid").trim() != null &&
				cookie_value.get("s_hospid").trim() != "" ) {
				return ".main/base/jaeryocd";				
			} else {
				return "";
			}	
		} catch(Exception ex) {
			return "";
		}
    }
	@RequestMapping(value="/jaeryoCdList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> jaeryoCdList(@ModelAttribute("DTO") JearyoCdDTO dto, HttpSession session, HttpServletRequest request, Model model) throws Exception {
		
		System.out.println("수가-java 1- start ");		
		
		cookie_value = ClientInfo.getCookie(request);		
		try {
			
			if (cookie_value.get("s_hospid").trim() != null &&
				cookie_value.get("s_hospid").trim() != "" ) {
				
				dto.setFindData(dto.getFindData());
				
				List<JearyoCdDTO> jaeryoList = svc.getJaeryoCdList(dto);
				
				System.out.println("약갸-java size " + jaeryoList.size());
				
				Map<String, Object> response = new HashMap<>();
		        response.put("data",jaeryoList);

		        System.out.println("수가-java response : " + response);
		        
		        return response;
				
				
			} else {
				return null;
			}	
		} catch(Exception ex) {
			return null;
		}
	}	
}
