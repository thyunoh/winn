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
import egovframework.wnn_medcost.mangr.model.VisitAsqDTO;
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
@RequestMapping("/mangr")
public class MangrController {

	private static final Logger log = LoggerFactory.getLogger(MangrController.class);
	private static Map<String, String> cookie_value = new HashMap<>();

	@Resource(name = "MangrService")
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
				return ".login/LoginWinCT";
			}
		} catch(Exception ex) {
			return ".login/LoginWinCT";
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
		        response.put("error_code", "0");

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
	//공지사항
	@RequestMapping(value="/noticd.do")
    public String noticd(HttpServletRequest request, ModelMap model) {

        cookie_value = ClientInfo.getCookie(request);
		try {
			if (cookie_value.get("s_hospid").trim() != null &&
				cookie_value.get("s_hospid").trim() != "" ) {
				model.addAttribute("noticeType", "1");
				return ".main/mangr/noticd";
			} else {
				return ".login/LoginWinCT";
			}
		} catch(Exception ex) {
			return ".login/LoginWinCT";
		}
    }
	//심사방
	@RequestMapping(value="/noticd2.do")
    public String noticd2(HttpServletRequest request, ModelMap model) {

        cookie_value = ClientInfo.getCookie(request);
		try {
			if (cookie_value.get("s_hospid").trim() != null &&
				cookie_value.get("s_hospid").trim() != "" ) {
				model.addAttribute("noticeType", "2");
				return ".main/mangr/noticd";
			} else {
				return ".login/LoginWinCT";
			}
		} catch(Exception ex) {
			return ".login/LoginWinCT";
		}
    }
	//소식지
	@RequestMapping(value="/noticd3.do")
    public String noticd3(HttpServletRequest request, ModelMap model) {

        cookie_value = ClientInfo.getCookie(request);
		try {
			if (cookie_value.get("s_hospid").trim() != null &&
				cookie_value.get("s_hospid").trim() != "" ) {
				model.addAttribute("noticeType", "3");
				return ".main/mangr/noticd";
			} else {
				return ".login/LoginWinCT";
			}
		} catch(Exception ex) {
			return ".login/LoginWinCT";
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
                svc.insertnotiCd(dto);
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
            response.put("notiSeqList", notiSeqList);
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
				// 병원 사용자가 자신의 1:1 문의 화면을 열람하면 답변 확인처리(로그인 알림 해제).
				//   위너넷 접속(s_wnn_yn/s_winconect='Y')은 답변 작성자 측이므로 제외.
				try {
					String sWnn = cookie_value.get("s_wnn_yn");
					String sWin = cookie_value.get("s_winconect");
					boolean isWnn = "Y".equals(sWnn == null ? "" : sWnn.trim())
							     || "Y".equals(sWin == null ? "" : sWin.trim());
					if (!isWnn) {
						AsqDTO rd = new AsqDTO();
						rd.setHospCd(cookie_value.get("s_hospid").trim());
						svc.updateAsqRead(rd);
					}
				} catch (Exception ignore) {}
				return ".main/mangr/asqcd";
			} else {
				return ".login/LoginWinCT";
			}
		} catch(Exception ex) {
			return ".login/LoginWinCT";
		}
    }

	//병원 로그인 알림용: 미확인(답변완료) 건수 조회
	@RequestMapping(value="/asqUnreadCnt.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> asqUnreadCnt(@ModelAttribute("DTO") AsqDTO dto, HttpServletRequest request) {
		Map<String, Object> response = new HashMap<>();
		cookie_value = ClientInfo.getCookie(request);
		try {
			String hospId = (dto.getHospCd() != null && !dto.getHospCd().trim().isEmpty())
					? dto.getHospCd().trim() : cookie_value.get("s_hospid");
			if (hospId != null) hospId = hospId.trim();
			int cnt = 0;
			if (hospId != null && !hospId.isEmpty()) {
				dto.setHospCd(hospId);
				cnt = svc.selectAsqUnreadCnt(dto);
			}
			response.put("cnt", cnt);
			response.put("error_code", "0");
		} catch (Exception ex) {
			response.put("cnt", 0);
			response.put("error_code", "10000");
		}
		return response;
	}

	//알림 '확인' 클릭 시: 해당 병원 답변완료건 전부 확인처리(ANSR_READ_YN='Y')
	@RequestMapping(value="/asqReadAll.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> asqReadAll(@ModelAttribute("DTO") AsqDTO dto, HttpServletRequest request) {
		Map<String, Object> response = new HashMap<>();
		cookie_value = ClientInfo.getCookie(request);
		try {
			String hospId = (dto.getHospCd() != null && !dto.getHospCd().trim().isEmpty())
					? dto.getHospCd().trim() : cookie_value.get("s_hospid");
			if (hospId != null) hospId = hospId.trim();
			if (hospId != null && !hospId.isEmpty()) {
				dto.setHospCd(hospId);
				dto.setAsqSeq(null);   // 전체(해당 병원) 확인처리
				svc.updateAsqRead(dto);
			}
			response.put("error_code", "0");
		} catch (Exception ex) {
			response.put("error_code", "10000");
		}
		return response;
	}
	//질문리스트
	@RequestMapping(value="/asqCdList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> asqCdList(@ModelAttribute("DTO") AsqDTO dto, HttpSession session, HttpServletRequest request, Model model) throws Exception {
		cookie_value = ClientInfo.getCookie(request);
		try {

			if (cookie_value.get("s_hospid").trim() != null &&
				cookie_value.get("s_hospid").trim() != "" ) {

				System.out.println("Asq asqSeq=" + dto.getAsqSeq() + ", asqGb=" + dto.getAsqGb() + ", hospCd=" + dto.getHospCd() + ", qstnTitle=" + dto.getQstnTitle());

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
	//상담문의 삭제
	@RequestMapping(value="/asqCdDelete.do", method = RequestMethod.POST)
    public ResponseEntity<String> asqCdDelete(@RequestBody List<AsqDTO> data) {

		System.out.println("AsqCd Delete 시작했음");
		String returnValue = "OK";
		// 처리 로직
        try {
        	for (AsqDTO dto : data) {
        		dto.setAsqSeq(String.valueOf(dto.getKeyasqSeq()));
        		dto.setFileGb(dto.getKeyfileGb());
        		if (dto.getUpdUser() == null) dto.setUpdUser("");
        		if (dto.getUpdIp() == null) dto.setUpdIp("");
        		svc.updateQstnCd(dto);
       		    System.out.println("Key asqSeq: " + dto.getKeyasqSeq());

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
	    return resultLst;
	}
	@RequestMapping(value="/report/filelist.do")
    public String filelist(HttpServletRequest request, ModelMap model) {

        cookie_value = ClientInfo.getCookie(request);
		try {
			if (cookie_value.get("s_hospid").trim() != null &&
				cookie_value.get("s_hospid").trim() != "" ) {
				return ".main/mangr/report/filelist";
			} else {
				return ".login/LoginWinCT";
			}
		} catch(Exception ex) {
			return ".login/LoginWinCT";
		}
    }
	/* 사이드바 일대일 질의응답 */
	@RequestMapping(value= "/asqList.do")
	public String ctl_asqList(@ModelAttribute("DTO") AsqDTO dto, HttpServletRequest request, ModelMap model) throws Exception {
		try {
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
			// fileGb가 비어있으면 fileGb2에서 가져오기
			if (dto.getFileGb() == null || dto.getFileGb().isEmpty()) {
				dto.setFileGb(dto.getFileGb2());
			}
			System.out.println("getIud=" + dto.getIud() + " asqSeq=" + dto.getAsqSeq() + " fileGb=" + dto.getFileGb());
			if ("QI".equals(dto.getIud())){
				svc.insertQstnCd(dto);
				System.out.println("insert 후 asqSeq=" + dto.getAsqSeq());
				model.addAttribute("asqSeq", dto.getAsqSeq());
				model.addAttribute("hospCd", dto.getHospCd2());
				model.addAttribute("regUser", dto.getRegUser());
			}else if ("QU".equals(dto.getIud())){
				svc.updateQstnMst(dto);
				model.addAttribute("asqSeq", dto.getAsqSeq());
			}else if ("QD".equals(dto.getIud())){
				svc.updateQstnCd(dto);
			}
			model.addAttribute("error_code", "0");
		}catch(Exception ex) {
			System.out.println("asqSaveAct 오류: " + ex.getMessage());
			ex.printStackTrace();
			model.addAttribute("error_code", "10000");
		}
		return "jsonView";
	}

	/* 사이트방문문의 페이지 */
	@RequestMapping(value="/visitasq.do")
	public String visitasq(HttpServletRequest request, ModelMap model) {
		cookie_value = ClientInfo.getCookie(request);
		try {
			if (cookie_value.get("s_hospid").trim() != null &&
				cookie_value.get("s_hospid").trim() != "" ) {
				return ".main/mangr/visitasq";
			} else {
				return ".login/LoginWinCT";
			}
		} catch(Exception ex) {
			return ".login/LoginWinCT";
		}
	}

	/* 사이트방문문의 목록 조회 */
	@RequestMapping(value="/visitAsqList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> visitAsqList(@ModelAttribute("DTO") VisitAsqDTO dto, HttpServletRequest request, Model model) throws Exception {
		Map<String, Object> response = new HashMap<>();
		try {
			List<VisitAsqDTO> resultLst = svc.getVisitAsqList(dto);
			response.put("data", resultLst);
			response.put("resultCnt", resultLst.size());
			response.put("error_code", "0");
		} catch(Exception ex) {
			ex.printStackTrace();
			response.put("error_code", "10000");
			response.put("error_message", ex.getMessage());
		}
		return response;
	}

	/* 사이트방문문의 확인여부 저장 */
	@RequestMapping(value="/visitAsqComform.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> visitAsqComform(@ModelAttribute("DTO") VisitAsqDTO dto, HttpServletRequest request, Model model) throws Exception {
		Map<String, Object> response = new HashMap<>();
		try {
			svc.updateVisitAsqComform(dto);
			response.put("error_code", "0");
		} catch(Exception ex) {
			ex.printStackTrace();
			response.put("error_code", "10000");
			response.put("error_message", ex.getMessage());
		}
		return response;
	}

	/* ====================================================================
	   적정성평가 Q&A (qnacd.jsp) — 지식 조회 (2026-08-04)
	     · 아래 4개는 AJAX 전용이다(화면 진입은 위 qnacd.do 하나뿐).
	     · 뷰를 돌려주지 않으므로 s_hospid 쿠키가 없어도 500 이 아니라 빈 결과가 나가게 둔다
	       (쿠키 가드는 뷰 반환 메서드에만 필요 — 2026-06-10 대시보드 500 장애 참조).
	   ==================================================================== */

	/** 위너넷 관리자인가 — 로그인 때 심어 둔 s_mainfg(관리자구분)가 1 일 때만 (JoinController 와 같은 판별) */
	private boolean qnaIsWnnAdmin(HttpServletRequest request) {
		try {
			String v = ClientInfo.getCookie(request).get("s_mainfg");
			return v != null && "1".equals(v.trim());
		} catch (Exception ex) { return false; }
	}

	/** 적정성평가 Q&A 자료 — 관리자(위너넷) 메뉴 화면. 플로팅 챗과 같은 지식·같은 조회 API 를 쓴다. */
	@RequestMapping(value="/qnacd.do")
	public String qnacd(HttpServletRequest request, ModelMap model) {
		cookie_value = ClientInfo.getCookie(request);
		// 자주하는 질문 편집 버튼은 위너넷 관리자에게만 보인다(2026-08-26) — 저장 API 도 서버에서 한 번 더 막는다
		model.addAttribute("qnaAdmin", qnaIsWnnAdmin(request) ? "Y" : "N");
		try {
			if (cookie_value.get("s_hospid").trim() != null &&
				cookie_value.get("s_hospid").trim() != "" ) {
				return ".main/mangr/qnacd";
			} else {
				return ".login/LoginWinCT";
			}
		} catch(Exception ex) {
			return ".login/LoginWinCT";
		}
	}

	/** HTMLTagFilter(HTMLTagFilterRequestWrapper)가 바꾼 다섯 글자만 원래대로 — &amp; 는 맨 끝에 풀어야 이중 해제가 안 된다 */
	private static String qnaUnescapeHtml(String s) {
		if (s == null) return null;
		return s.replace("&lt;", "<").replace("&gt;", ">").replace("&quot;", "\"").replace("&apos;", "'").replace("&amp;", "&");
	}

	/** 자주하는 질문 등록·수정 (위너넷 관리자 전용, 2026-08-26) — kbId 가 있으면 수정, 없으면 신규 */
	@RequestMapping(value="/qnaTopSave.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> qnaTopSave(@RequestParam(value="kbId",  required=false) String kbId,
	                                      @RequestParam(value="title") String title,
	                                      @RequestParam(value="body")  String body,
	                                      @RequestParam(value="catId") String catId,
	                                      @RequestParam(value="topNo", required=false, defaultValue="0") int topNo,
	                                      HttpServletRequest request) {
		Map<String, Object> response = new HashMap<>();
		if (!qnaIsWnnAdmin(request)) {   // 메뉴만 감추면 주소를 직접 부를 수 있다 — 여기서도 막는다
			response.put("error_code", "403");
			response.put("error_message", "위너넷 관리자만 등록할 수 있습니다.");
			return response;
		}
		try {
			/* web.xml 의 HTMLTagFilter 가 *.do 파라미터의 < > & " ' 를 &lt; 등으로 바꿔 넘긴다.
			   답변은 편집기가 HTML 그대로 저장하는 칸이라 그대로 두면 태그가 글자로 저장돼
			   화면에 <div><span …> 이 보인다(2026-09-04 사용자 신고 — GPT 답변 붙여넣기). 여기서만 되돌린다. */
			body  = qnaUnescapeHtml(body);
			title = qnaUnescapeHtml(title);
			svc.qnaTopSave(kbId, title, body, catId, topNo);
			response.put("error_code", "0");
		} catch(Exception ex) {
			ex.printStackTrace();
			response.put("error_code", "10000");
			response.put("error_message", ex.getMessage());
		}
		return response;
	}

	/** 기존 질문을 자주하는 질문에 올리기 (위너넷 관리자 전용) — 뺐던 것 되살리기 포함 */
	@RequestMapping(value="/qnaTopAdd.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> qnaTopAdd(@RequestParam(value="kbId") String kbId,
	                                     @RequestParam(value="topNo", required=false, defaultValue="0") int topNo,
	                                     HttpServletRequest request) {
		Map<String, Object> response = new HashMap<>();
		if (!qnaIsWnnAdmin(request)) {
			response.put("error_code", "403");
			response.put("error_message", "위너넷 관리자만 등록할 수 있습니다.");
			return response;
		}
		try {
			svc.qnaTopAdd(kbId, topNo);
			response.put("error_code", "0");
		} catch(Exception ex) {
			ex.printStackTrace();
			response.put("error_code", "10000");
			response.put("error_message", ex.getMessage());
		}
		return response;
	}

	/** 질문 완전 삭제 (위너넷 관리자 전용) — 분류·검색·자주 목록 모두에서 내린다 */
	@RequestMapping(value="/qnaKbDel.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> qnaKbDel(@RequestParam(value="kbId") String kbId,
	                                    HttpServletRequest request) {
		Map<String, Object> response = new HashMap<>();
		if (!qnaIsWnnAdmin(request)) {
			response.put("error_code", "403");
			response.put("error_message", "위너넷 관리자만 삭제할 수 있습니다.");
			return response;
		}
		try {
			svc.qnaKbDel(kbId);
			response.put("error_code", "0");
		} catch(Exception ex) {
			ex.printStackTrace();
			response.put("error_code", "10000");
			response.put("error_message", ex.getMessage());
		}
		return response;
	}

	/** 자주하는 질문에서 빼기 (위너넷 관리자 전용) — 지식은 남기고 지정만 푼다 */
	@RequestMapping(value="/qnaTopDel.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> qnaTopDel(@RequestParam(value="kbId") String kbId,
	                                     HttpServletRequest request) {
		Map<String, Object> response = new HashMap<>();
		if (!qnaIsWnnAdmin(request)) {
			response.put("error_code", "403");
			response.put("error_message", "위너넷 관리자만 삭제할 수 있습니다.");
			return response;
		}
		try {
			svc.qnaTopDel(kbId);
			response.put("error_code", "0");
		} catch(Exception ex) {
			ex.printStackTrace();
			response.put("error_code", "10000");
			response.put("error_message", ex.getMessage());
		}
		return response;
	}

	/** 화면 열 때 1회 — 카테고리(대·중분류, 건수) + 자주하는 질문 순위 */
	@RequestMapping(value="/qnaInit.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> qnaInit(@RequestParam(value="topCnt", required=false, defaultValue="12") int topCnt,
	                                   HttpServletRequest request) throws Exception {
		Map<String, Object> response = new HashMap<>();
		try {
			response.putAll(svc.qnaInit(topCnt));
			response.put("error_code", "0");
		} catch(Exception ex) {
			ex.printStackTrace();
			response.put("error_code", "10000");
			response.put("error_message", ex.getMessage());
		}
		return response;
	}

	/** 카테고리를 눌렀을 때 — 그 안의 질문 목록 */
	@RequestMapping(value="/qnaList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> qnaList(@RequestParam(value="catId", required=false) String catId,
	                                   @RequestParam(value="subId", required=false) String subId,
	                                   HttpServletRequest request) throws Exception {
		Map<String, Object> response = new HashMap<>();
		try {
			response.put("list", svc.qnaList(catId, subId));
			response.put("error_code", "0");
		} catch(Exception ex) {
			ex.printStackTrace();
			response.put("error_code", "10000");
			response.put("error_message", ex.getMessage());
		}
		return response;
	}

	/** 질문 한 건의 답변 (조회수 +1 · 질문로그 기록) */
	@RequestMapping(value="/qnaGet.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> qnaGet(@RequestParam(value="kbId",    required=false) String kbId,
	                                  @RequestParam(value="kbCode",  required=false) String kbCode,
	                                  @RequestParam(value="askType", required=false) String askType,
	                                  @RequestParam(value="qText",   required=false) String qText,
	                                  HttpServletRequest request) throws Exception {
		Map<String, Object> response = new HashMap<>();
		try {
			response.putAll(svc.qnaGet(kbId, kbCode, askType, qnaHospCd(request), qnaUserId(request), qText));
			response.put("error_code", "0");
		} catch(Exception ex) {
			ex.printStackTrace();
			response.put("error_code", "10000");
			response.put("error_message", ex.getMessage());
		}
		return response;
	}

	/** 직접 입력한 질문 검색 (질문로그 기록 — 못 찾은 질문이 지식 보강 목록이 된다) */
	@RequestMapping(value="/qnaSearch.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> qnaSearch(@RequestParam(value="q") String q,
	                                     @RequestParam(value="listCnt", required=false, defaultValue="8") int listCnt,
	                                     HttpServletRequest request) throws Exception {
		Map<String, Object> response = new HashMap<>();
		try {
			response.putAll(svc.qnaSearch(q, listCnt, qnaHospCd(request), qnaUserId(request)));
			response.put("error_code", "0");
		} catch(Exception ex) {
			ex.printStackTrace();
			response.put("error_code", "10000");
			response.put("error_message", ex.getMessage());
		}
		return response;
	}

	/** 등록된 자료에서 못 찾은 질문 → LLM(Gemini) 참고답변 (2026-08-06)
	 *  · 화면이 qnaSearch 0건일 때만 부른다.
	 *  · 키 미설정·호출 실패도 error_code '0' + ok=false 로 조용히 내려보낸다
	 *    (화면은 종전 안내문구로 폴백 — 오류창을 띄우지 않는다). */
	@RequestMapping(value="/qnaAsk.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> qnaAsk(@RequestParam(value="q") String q,
	                                  HttpServletRequest request) throws Exception {
		Map<String, Object> response = new HashMap<>();
		try {
			response.putAll(svc.qnaAsk(q, qnaHospCd(request), qnaUserId(request)));
			response.put("error_code", "0");
		} catch(Exception ex) {
			ex.printStackTrace();
			response.put("ok", false);
			response.put("reason", "호출 오류");
			response.put("error_code", "0");
		}
		return response;
	}

	/* 로그용 — 쿠키가 없어도 예외 없이 null 로 넘긴다 */
	private String qnaCookie(HttpServletRequest request, String key) {
		try {
			Map<String, String> ck = ClientInfo.getCookie(request);
			String v = (ck == null) ? null : ck.get(key);
			return (v == null || v.trim().isEmpty()) ? null : v.trim();
		} catch(Exception ex) {
			return null;
		}
	}
	private String qnaHospCd(HttpServletRequest request) { return qnaCookie(request, "s_hospid"); }
	private String qnaUserId(HttpServletRequest request) { return qnaCookie(request, "s_userid"); }
}
