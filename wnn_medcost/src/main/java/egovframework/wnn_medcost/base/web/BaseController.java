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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.http.ResponseEntity;

import com.fasterxml.jackson.databind.ObjectMapper;

import egovframework.wnn_medcost.base.model.ClaimDTO;
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
	@RequestMapping(value="/sugaCdExcelInsert.do", method = RequestMethod.POST)
	@ResponseBody
    public ResponseEntity<Map<String, Object>> sugaExcelInsert(
    		@RequestBody List<SugaCdDTO> data,
    		@RequestParam(value="dupMode", required=false, defaultValue="skip") String dupMode) {

		long t0 = System.currentTimeMillis();
		System.out.println("Excel Insert 시작 - 건수: " + data.size() + " / 중복모드: " + dupMode);
		int successCnt = 0;   // 신규 insert
		int updCnt     = 0;   // 덮어쓰기 update
		int dupCnt     = 0;   // 중복 skip (insert 안 됨)
		int failCnt    = 0;   // 실패
		boolean isUpdateMode = "update".equalsIgnoreCase(dupMode);
		Map<String, Object> result = new HashMap<>();

        try {
        	if (data == null || data.isEmpty()) {
        		result.put("successCnt", 0);
        		result.put("updCnt",     0);
        		result.put("dupCnt",     0);
        		result.put("failCnt",    0);
        		return ResponseEntity.ok(result);
        	}

        	// 1) 한 번의 쿼리로 기존 키 조회 (SELECT IN)
        	List<String> existingKeys = svc.SugaCdMstDupChkList(data);
        	java.util.Set<String> existingSet = new java.util.HashSet<>(existingKeys);

        	// 2) 기존/신규 분리
        	List<SugaCdDTO> existingList = new java.util.ArrayList<>();
        	List<SugaCdDTO> newList      = new java.util.ArrayList<>();
        	for (SugaCdDTO dto : data) {
        		String key = dto.getFeeCode() + "|" + dto.getFeeType() + "|" + dto.getStartDt();
        		if (existingSet.contains(key)) {
        			existingList.add(dto);
        		} else {
        			newList.add(dto);
        		}
        	}

        	if (isUpdateMode) {
        		// 덮어쓰기 모드 (Upsert): 적용일자 기준 기존 행 → UPDATE, 없는 행 → INSERT
        		if (!existingList.isEmpty()) {
        			try {
        				SugaCdDTO first = existingList.get(0);
        				Map<String, Object> params = new HashMap<>();
        				params.put("list",    existingList);
        				params.put("updUser", first.getUpdUser());
        				params.put("updIp",   first.getUpdIp());
        				updCnt = svc.updateSugaCdMstBulk(params);
        				if (updCnt <= 0) updCnt = existingList.size(); // 일부 DB driver가 영향 행수 반환 안 함
        			} catch (Exception bulkEx) {
        				failCnt += existingList.size();
        				System.out.println("Excel Bulk update 실패: " + bulkEx.getMessage());
        			}
        		}
        		// 기존에 없는 행은 신규 INSERT (적용일자가 다르거나 수가코드 자체가 없는 경우)
        		if (!newList.isEmpty()) {
        			try {
        				int inserted = svc.insertSugaCdMstBulk(newList);
        				successCnt = (inserted > 0) ? inserted : newList.size();
        			} catch (Exception bulkEx) {
        				System.out.println("Excel Bulk insert 실패 (Upsert) → 개별 fallback: " + bulkEx.getMessage());
        				int failLogged = 0;
        				for (SugaCdDTO dto : newList) {
        					try {
        						svc.insertSugaCdMst(dto);
        						successCnt++;
        					} catch (Exception rowEx) {
        						failCnt++;
        						if (failLogged < 5) {
        							System.out.println("  행 실패 FeeCode=" + dto.getFeeCode() + " / " + rowEx.getMessage());
        							failLogged++;
        						}
        					}
        				}
        			}
        		}
        	} else {
        		// 건너뜀 모드: 신규만 bulk insert, 기존은 dupCnt
        		dupCnt = existingList.size();
        		if (!newList.isEmpty()) {
        			try {
        				int inserted = svc.insertSugaCdMstBulk(newList);
        				successCnt = (inserted > 0) ? inserted : newList.size();
        			} catch (Exception bulkEx) {
        				// bulk 실패 시 개별 insert fallback — 에러난 행만 추적
        				System.out.println("Excel Bulk insert 실패 → 개별 fallback: " + bulkEx.getMessage());
        				int failLogged = 0;
        				for (SugaCdDTO dto : newList) {
        					try {
        						svc.insertSugaCdMst(dto);
        						successCnt++;
        					} catch (Exception rowEx) {
        						failCnt++;
        						if (failLogged < 5) {
        							System.out.println("  행 실패 FeeCode=" + dto.getFeeCode() + " / " + rowEx.getMessage());
        							failLogged++;
        						}
        					}
        				}
        			}
        		}
        	}

        	result.put("successCnt", successCnt);
        	result.put("updCnt",     updCnt);
        	result.put("dupCnt",     dupCnt);
        	result.put("failCnt",    failCnt);

        	long elapsed = System.currentTimeMillis() - t0;
        	System.out.println("Excel Insert 완료 - 신규:" + successCnt + " 수정:" + updCnt + " 중복:" + dupCnt + " 실패:" + failCnt + " (elapsed=" + elapsed + "ms)");

        	return ResponseEntity.ok(result);

        } catch (Exception e) {
        	e.printStackTrace();
        	result.put("successCnt", successCnt);
        	result.put("updCnt",     updCnt);
        	result.put("dupCnt",     dupCnt);
        	result.put("failCnt",    failCnt);
        	result.put("error", e.getMessage());
            return ResponseEntity.status(500).body(result);
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
	// 상병 엑셀 업로드 — 덮어쓰기는 "전체 비활성화 후 신규 insert", 건너뜀은 기존 insert-only
	// 첫 배치만 전체 비활성화를 수행하도록 dupMode=updateFirst 를 클라이언트가 보냄
	@RequestMapping(value="/diseCdExcelInsert.do", method = RequestMethod.POST)
	@ResponseBody
    public ResponseEntity<Map<String, Object>> diseExcelInsert(
    		@RequestBody List<DiseCdDTO> data,
    		@RequestParam(value="dupMode", required=false, defaultValue="skip") String dupMode) {

		long t0 = System.currentTimeMillis();
		System.out.println("Dise Excel Insert 시작 - 건수: " + data.size() + " / 중복모드: " + dupMode);
		int successCnt = 0;   // 신규 insert
		int updCnt     = 0;   // 덮어쓰기 = deactivated 건수
		int dupCnt     = 0;   // 중복 skip
		int failCnt    = 0;   // 실패
		boolean isUpdateMode      = "update".equalsIgnoreCase(dupMode);
		boolean isUpdateFirstMode = "updateFirst".equalsIgnoreCase(dupMode); // 첫 배치
		Map<String, Object> result = new HashMap<>();

        try {
        	if (data == null || data.isEmpty()) {
        		result.put("successCnt", 0);
        		result.put("updCnt",     0);
        		result.put("dupCnt",     0);
        		result.put("failCnt",    0);
        		return ResponseEntity.ok(result);
        	}

        	if (isUpdateMode || isUpdateFirstMode) {
        		// 덮어쓰기 모드: 첫 배치에만 전체 비활성화, 이후 배치는 그냥 insert
        		if (isUpdateFirstMode) {
        			try {
        				DiseCdDTO first = data.get(0);
        				Map<String, Object> deactParams = new HashMap<>();
        				deactParams.put("updUser", first.getUpdUser());
        				deactParams.put("updIp",   first.getUpdIp());
        				int deactivated = svc.deactivateAllDiseCdMst(deactParams);
        				updCnt = deactivated;
        				System.out.println("Dise 전체 비활성화 완료: " + deactivated + "건");
        			} catch (Exception deEx) {
        				System.out.println("Dise 전체 비활성화 실패: " + deEx.getMessage());
        				deEx.printStackTrace();
        			}
        		}
        		// JOB_SEQ 계산:
        		//   - updateFirst (첫 배치): 직전에 deactivateAll만 했으므로 비활성 행이 있으나 키별 max 조회로 시작값 결정
        		//   - update (후속 배치): 이전 배치가 이미 잘 채워둔 상태, 키별 max 조회로 안전하게 누적
        		// JSP가 같은 키를 같은 배치에 묶어서 보내주므로 배치 내에서 카운터로만 증가시키면 됨
        		try {
        			List<Map<String, Object>> maxList = svc.selectMaxJobSeqDiseCd(data);
        			java.util.Map<String, Integer> jobSeqMap = new java.util.HashMap<>();
        			for (Map<String, Object> row : maxList) {
        				String key = String.valueOf(row.get("diagCode")) + "|" + String.valueOf(row.get("startDt"));
        				Object v = row.get("maxJobSeq");
        				int max = (v == null) ? 0 : ((Number) v).intValue();
        				jobSeqMap.put(key, max);
        			}
        			// DTO 각 행에 jobSeq 할당 (배치 내 동일 키 카운터 증가)
        			for (DiseCdDTO dto : data) {
        				String key = dto.getDiagCode() + "|" + dto.getStartDt();
        				int next = jobSeqMap.getOrDefault(key, 0) + 1;
        				dto.setJobSeq(next);
        				jobSeqMap.put(key, next);
        			}
        		} catch (Exception seqEx) {
        			System.out.println("Dise JOB_SEQ 사전 계산 실패: " + seqEx.getMessage());
        			seqEx.printStackTrace();
        			for (DiseCdDTO dto : data) dto.setJobSeq(1);
        		}

        		// 모든 행을 신규 insert (dupchk 없음, JOB_SEQ는 사전 계산된 값 사용)
        		try {
        			int inserted = svc.insertDiseCdMstBulk(data);
        			successCnt = (inserted > 0) ? inserted : data.size();
        		} catch (Exception bulkEx) {
        			System.out.println("Dise Bulk insert 실패 → 개별 fallback: " + bulkEx.getMessage());
        			int failLogged = 0;
        			for (DiseCdDTO dto : data) {
        				try {
        					svc.insertDiseCdMst(dto);
        					successCnt++;
        				} catch (Exception rowEx) {
        					failCnt++;
        					if (failLogged < 5) {
        						System.out.println("  행 실패 DiagCode=" + dto.getDiagCode() + " / " + rowEx.getMessage());
        						failLogged++;
        					}
        				}
        			}
        		}
        	} else {
        		// 건너뜀 모드: 기존 활성 행 있는 키는 skip, 신규만 insert
        		List<String> existingKeys = svc.DiseCdMstDupChkList(data);
        		java.util.Set<String> existingSet = new java.util.HashSet<>(existingKeys);
        		List<DiseCdDTO> newList = new java.util.ArrayList<>();
        		for (DiseCdDTO dto : data) {
        			String key = dto.getDiagCode() + "|" + dto.getStartDt();
        			if (existingSet.contains(key)) dupCnt++;
        			else newList.add(dto);
        		}
        		if (!newList.isEmpty()) {
        			try {
        				int inserted = svc.insertDiseCdMstBulk(newList);
        				successCnt = (inserted > 0) ? inserted : newList.size();
        			} catch (Exception bulkEx) {
        				System.out.println("Dise Bulk insert 실패 → 개별 fallback: " + bulkEx.getMessage());
        				int failLogged = 0;
        				for (DiseCdDTO dto : newList) {
        					try {
        						svc.insertDiseCdMst(dto);
        						successCnt++;
        					} catch (Exception rowEx) {
        						failCnt++;
        						if (failLogged < 5) {
        							System.out.println("  행 실패 DiagCode=" + dto.getDiagCode() + " / " + rowEx.getMessage());
        							failLogged++;
        						}
        					}
        				}
        			}
        		}
        	}

        	result.put("successCnt", successCnt);
        	result.put("updCnt",     updCnt);
        	result.put("dupCnt",     dupCnt);
        	result.put("failCnt",    failCnt);

        	long elapsed = System.currentTimeMillis() - t0;
        	System.out.println("Dise Excel Insert 완료 - 신규:" + successCnt + " 비활성:" + updCnt + " 중복:" + dupCnt + " 실패:" + failCnt + " (elapsed=" + elapsed + "ms)");

        	return ResponseEntity.ok(result);

        } catch (Exception e) {
        	e.printStackTrace();
        	result.put("successCnt", successCnt);
        	result.put("updCnt",     updCnt);
        	result.put("dupCnt",     dupCnt);
        	result.put("failCnt",    failCnt);
        	result.put("error", e.getMessage());
            return ResponseEntity.status(500).body(result);
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
	@RequestMapping(value="/selwvalcdList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> selwvalcdList(@ModelAttribute("DTO") WvalDTO dto, HttpSession session, HttpServletRequest request, Model model) throws Exception {
		
		System.out.println("가중치-java 1- start ");		
		
		cookie_value = ClientInfo.getCookie(request);		
		try {
			
			if (cookie_value.get("s_hospid").trim() != null &&
				cookie_value.get("s_hospid").trim() != "" ) {
				
				dto.setFindData(dto.getFindData());
	
				List<WvalDTO> wvalList = svc.selWvalueList(dto);
				
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
	@RequestMapping(value="/copwvalcdList.do", method = RequestMethod.POST)
    public ResponseEntity<String> copwvalcdList(@RequestBody List<WvalDTO> data) {
	
		System.out.println("copy Update 시작했음");
		String returnValue = "OK";
		// 처리 로직
        try {
    	
        	for (WvalDTO dto : data) {
        		svc.copWvalueList(dto); // 이력관리
            }
        	return ResponseEntity.ok(returnValue);   
        	
        } catch (Exception e) {
        	
            return ResponseEntity.status(500).body(e.getMessage());
            
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
	@RequestMapping(value="/WvalueExcelInsert.do", method = RequestMethod.POST)
	@ResponseBody
    public ResponseEntity<Map<String, Object>> WvalueExcelInsert(@RequestBody List<WvalDTO> data) {

		System.out.println("Wvalue Excel Insert 시작 - 건수: " + data.size());
		int successCnt = 0;
		int dupCnt = 0;
		int failCnt = 0;

        try {
        	for (WvalDTO dto : data) {
        		try {
	        		String dupchk = svc.WvalueDupChk(dto);
	        		if ("Y".equals(dupchk)) {
	        			dupCnt++;
	        			continue;
	        		}
	        		svc.insertWvalue(dto);
	        		successCnt++;
        		} catch (Exception e) {
        			failCnt++;
        			System.out.println("Wvalue Excel Insert 실패 - CateCode: " + dto.getCateCode() + " / " + e.getMessage());
        		}
            }

        	Map<String, Object> result = new HashMap<>();
        	result.put("successCnt", successCnt);
        	result.put("dupCnt", dupCnt);
        	result.put("failCnt", failCnt);

        	System.out.println("Wvalue Excel Insert 완료 - 성공:" + successCnt + " 중복:" + dupCnt + " 실패:" + failCnt);

        	return ResponseEntity.ok(result);

        } catch (Exception e) {
        	Map<String, Object> result = new HashMap<>();
        	result.put("successCnt", successCnt);
        	result.put("dupCnt", dupCnt);
        	result.put("failCnt", failCnt);
        	result.put("error", e.getMessage());
            return ResponseEntity.status(500).body(result);
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
	//샘파일 버젼VER1.0 load
	@RequestMapping(value="/samvercdV1.do")
    public String samvercdV1(HttpServletRequest request, ModelMap model) {
        cookie_value = ClientInfo.getCookie(request);
		try {
			if (cookie_value.get("s_hospid").trim() != null &&
				cookie_value.get("s_hospid").trim() != "" ) {
				return ".main/base/samvercdV1";
			} else {
				return "";
			}
		} catch(Exception ex) {
			return "";
		}
    }
	//SAMVER DISTINCT 목록 조회
	@RequestMapping(value="/samverDistinctList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> samverDistinctList(HttpServletRequest request) throws Exception {
		cookie_value = ClientInfo.getCookie(request);
		Map<String, Object> response = new HashMap<>();
		try {
			if (cookie_value.get("s_hospid").trim() != null &&
				cookie_value.get("s_hospid").trim() != "" ) {
				List<SamverDTO> list = svc.getDistinctSamver();
				response.put("data", list);
				return response;
			} else {
				return null;
			}
		} catch(Exception ex) {
			return null;
		}
	}
	//샘파일 버전 복사
	@RequestMapping(value="/samverCdCopyVersion.do", method = RequestMethod.POST)
	@ResponseBody
	public ResponseEntity<Map<String, Object>> samverCdCopyVersion(@RequestBody Map<String, Object> param, HttpServletRequest request) {
		System.out.println("버전복사 시작");
		Map<String, Object> result = new HashMap<>();
		try {
			cookie_value = ClientInfo.getCookie(request);
			if (cookie_value.get("s_hospid").trim() == null ||
				cookie_value.get("s_hospid").trim().equals("")) {
				result.put("result", "FAIL");
				result.put("message", "로그인 정보가 없습니다.");
				return ResponseEntity.status(401).body(result);
			}

			String srcVersion = (String) param.get("srcVersion");
			String tgtVersion = (String) param.get("tgtVersion");
			List<String> samverList = (List<String>) param.get("samverList");
			String regUser = (String) param.get("regUser");
			String regIp = (String) param.get("regIp");

			System.out.println("원본VERSION: " + srcVersion + " → 대상VERSION: " + tgtVersion);

			int copyCount = 0;
			for (String samver : samverList) {
				// 원본 데이터 조회
				SamverDTO searchDto = new SamverDTO();
				searchDto.setSamver(samver);
				searchDto.setVersion(srcVersion);
				searchDto.setProp1(samver);
				List<SamverDTO> srcList = svc.getsamverCdlist(searchDto);

				for (SamverDTO srcDto : srcList) {
					if (!samver.equals(srcDto.getSamver())) continue;
					// 대상 버전으로 변경하여 입력
					srcDto.setVersion(tgtVersion);
					srcDto.setRegUser(regUser);
					srcDto.setRegIp(regIp);
					srcDto.setUpdUser(regUser);
					srcDto.setUpdIp(regIp);

					String dupchk = svc.samverCdDupChk(srcDto);
					if (!"Y".equals(dupchk)) {
						svc.insertsamverCd(srcDto);
						copyCount++;
					}
				}
			}

			result.put("result", "OK");
			result.put("count", copyCount);
			System.out.println("버전복사 완료: " + copyCount + "건");
			return ResponseEntity.ok(result);

		} catch (Exception e) {
			e.printStackTrace();
			result.put("result", "FAIL");
			result.put("message", e.getMessage());
			return ResponseEntity.status(500).body(result);
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
	//청구율 계산 
	@RequestMapping(value="/claimcd.do")
    public String claimcd(HttpServletRequest request, ModelMap model) {

        cookie_value = ClientInfo.getCookie(request);		
		try {
			if (cookie_value.get("s_hospid").trim() != null &&
				cookie_value.get("s_hospid").trim() != "" ) {
				return ".main/base/claimcd";				
			} else {
				return "";
			}	
		} catch(Exception ex) {
			return "";
		}
    }
	
	@RequestMapping(value="/claimCdList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> claimCdList(@ModelAttribute("DTO") ClaimDTO dto, HttpSession session, HttpServletRequest request, Model model) throws Exception {
		System.out.println("청구율-java 1- start ");		
		cookie_value = ClientInfo.getCookie(request);		
		try {
			if (cookie_value.get("s_hospid").trim() != null &&
				cookie_value.get("s_hospid").trim() != "" ) {
				dto.setFindData(dto.getFindData());
				List<ClaimDTO> claimList = svc.getclaimCdList(dto);
				System.out.println("청구율-java size " + claimList.size());
				Map<String, Object> response = new HashMap<>();
		        response.put("data",claimList);
		        System.out.println("청구율-java response : " + response);
		        return response;
			} else {
				return null;
			}	
		} catch(Exception ex) {
			return null;
		}
	}
	@RequestMapping(value="/claimCdInsert.do", method = RequestMethod.POST)
    public ResponseEntity<String> claimCdInsert(@RequestBody List<ClaimDTO> data) {
		System.out.println("Insert 시작했음");
		String returnValue = "OK";
		// 처리 로직
        try {
        	for (ClaimDTO dto : data) {
        		String dupchk =   svc.claimCdDupChk(dto) ;
        		if ("Y".equals(dupchk)) {
        			return ResponseEntity.status(400).body(dto.getCformNo()); 
        		}
        		svc.insertclaimCd(dto) ; 
       		    System.out.println("Tblinfo: "  + dto.getCformNo());
       		    System.out.println("Version: "  + dto.getMedCovType());
            }
        	return ResponseEntity.ok(returnValue);   
        } catch (Exception e) {
            return ResponseEntity.status(500).body(e.getMessage());
        }
	}	
	@RequestMapping(value="/claimCdUpdate.do", method = RequestMethod.POST)
    public ResponseEntity<String> claimCdUpdate(@RequestBody List<ClaimDTO> data) {
		System.out.println("Update 시작했음");
		String returnValue = "OK";
		// 처리 로직
        try {
        	for (ClaimDTO dto : data) {
        		svc.updateclaimCd(dto) ; //이력관리 
        		svc.insertclaimCd(dto) ; 
       		    System.out.println("CFORM_IO: " + dto.getCformIo());
                System.out.println("CFORM_NO: " + dto.getCformNo());
             }
        	return ResponseEntity.ok(returnValue);   
        } catch (Exception e) {
             return ResponseEntity.status(500).body(e.getMessage());
        }
	}	
	@RequestMapping(value="/claimCdDelete.do", method = RequestMethod.POST)
    public ResponseEntity<String> claimCdDelete(@RequestBody List<ClaimDTO> data) {
		System.out.println("Delete 시작했음");
		String returnValue = "OK";
		// 처리 로직
        try {
        	for (ClaimDTO dto : data) {
        		dto.setHosGrd(dto.getKeyhosGrd());
        		dto.setCformNo(dto.getKeycformNo()); 
        		dto.setMedCovType(dto.getKeymedcovtype());
        		dto.setAccType(dto.getKeyacctype()); 
        		dto.setCformIo(dto.getKeycformIo()); 
        		dto.setItemNo(dto.getKeyitemNo()); 
        		dto.setCodeNo(dto.getKeycodeNo()); 
        		dto.setEdiFcode(dto.getKeyedifcode());
        		dto.setEdiTcode(dto.getKeyeditcode());
        		dto.setStartYm(dto.getKeystartYm());
        		svc.updateclaimCd(dto) ; //이력관리 
       		    System.out.println("Key CformNo: " + dto.getKeycformNo());
            }
        	return ResponseEntity.ok(returnValue);   
        } catch (Exception e) {
            return ResponseEntity.status(500).body(e.getMessage());
        }
	}	
}
