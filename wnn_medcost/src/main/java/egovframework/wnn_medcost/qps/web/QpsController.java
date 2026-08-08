package egovframework.wnn_medcost.qps.web;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.util.ClientInfo;
import egovframework.wnn_medcost.qps.model.QpsCensusDTO;
import egovframework.wnn_medcost.qps.model.QpsIncidentDTO;
import egovframework.wnn_medcost.qps.model.QpsMonitorDTO;
import egovframework.wnn_medcost.qps.service.QpsService;

/**
 * QPS(질향상·환자안전) — 낙상 파일럿 컨트롤러.
 *
 * ★노출 방침(사용자 지시 2026-08-08): 이 메뉴는 위너넷(s_wnn_yn='Y') 사용자에게도 기본 숨김이고,
 *   개발자 핫키로만 열린다. 다만 '숨김'은 화면 편의일 뿐이므로 서버는 로그인 여부를 직접 확인한다.
 */
@Controller
public class QpsController {

	/** 배포 확인용 표식 — 코드를 고칠 때마다 올린다. 응답의 build 값으로 반영 여부를 확인한다. */
	private static final String BUILD = "20260808-2240";

	@Resource(name = "QpsService")
	private QpsService svc;

	/**
	 * 화면 진입 — 뷰파일 = /WEB-INF/jsp/main/qpsFall.jsp (타일즈 .main/* 와일드카드)
	 *
	 * ★지표는 계속 늘어난다(18종). 그래서 화면을 지표마다 만들지 않고 <b>indi 파라미터</b>로 받는다.
	 *   새 지표를 열려면 <b>사이드바에 링크 한 줄</b>만 추가하면 된다: /main/qpsFall.do?indi=BEDSORE
	 *   지표명·산식·단위·분모구분은 전부 TBL_QPS_INDI_MST 에서 오므로 이 코드는 안 고친다.
	 */
	@RequestMapping(value = "main/qpsFall.do")
	public String qpsFall(HttpServletRequest request, ModelMap model) {
		Map<String, String> ck = ClientInfo.getCookie(request);
		try {
			String hospId = ck.get("s_hospid") == null ? "" : ck.get("s_hospid").trim();
			if (hospId.isEmpty()) return ".login/LoginWinCT";
			model.addAttribute("hospCd", hospId);

			// 지표 — 기본은 낙상(파일럿). 마스터에 없는 코드가 오면 그대로 두고 화면이 안내한다.
			String indiCd = request.getParameter("indi");
			if (indiCd == null || indiCd.trim().isEmpty()) indiCd = "FALL";
			indiCd = indiCd.trim().toUpperCase();
			model.addAttribute("indiCd", indiCd);

			String indiNm = "", incidGb = indiCd;
			try {
				Map<String, Object> ind = svc.selectQpsIndi(hospId, indiCd);
				if (ind != null) {
					indiNm  = ind.get("indinm")  == null ? "" : String.valueOf(ind.get("indinm"));
					String g = ind.get("incidgb") == null ? "" : String.valueOf(ind.get("incidgb")).trim();
					if (!g.isEmpty()) incidGb = g;
				}
			} catch (Exception ignore) { }
			model.addAttribute("indiNm", indiNm);
			model.addAttribute("incidGb", incidGb);
			String wnn = ck.get("s_wnn_yn") == null ? "N" : ck.get("s_wnn_yn").trim();
			model.addAttribute("wnnYn", wnn);
			// 화면 배지에 쓸 '서버 기준' 병원명 — 쿠키를 브라우저에서 읽어 표시하면
			// 서버가 보는 병원과 어긋나도 알 수가 없다(2026-08-08 실제로 그렇게 헤맸다).
			String hospNm = "";
			int ipwonCnt = 0;
			try {
				Map<String, Object> h = svc.selectHospInfo(hospId);
				if (h != null) {
					hospNm = h.get("hospnm") == null ? "" : String.valueOf(h.get("hospnm"));
					ipwonCnt = h.get("ipwoncnt") == null ? 0 : Integer.parseInt(String.valueOf(h.get("ipwoncnt")));
				}
			} catch (Exception ignore) { }
			model.addAttribute("hospNm", hospNm);
			model.addAttribute("ipwonCnt", ipwonCnt);
			return ".main/qpsFall";
		} catch (Exception ex) {
			return ".login/LoginWinCT";
		}
	}

	// ===================== 환자 입력검색 =====================

	/** 사고보고 화면의 환자 칸 — 위너넷 입원환자에서 고른다(주민번호는 서버 밖으로 나가지 않는다). */
	@RequestMapping(value = "/qps/patientSearch.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> patientSearch(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		// ★배포 확인용 표식 — 로그인 여부와 무관하게 먼저 담는다.
		//   클래스는 JSP 와 달리 톰캣이 리로드해야 반영되는데, 반영 여부를 밖에서 알 길이 없어
		//   "코드는 고쳤는데 화면은 그대로"인 상태로 한참 헤맸다(2026-08-08). 이 한 줄이 그걸 끝낸다.
		res.put("build", BUILD);
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			String kw = str(p.get("keyword"), "");
			res.put("list", svc.selectPatientList(hospCd, kw, str(p.get("baseDt"), "")));
			// 어느 병원으로 / 무슨 글자로 조회했는지 그대로 돌려준다 —
			// 화면에서 바로 보이면 "검색이 안 된다" 를 추측 없이 가른다(병원 문제냐 글자 깨짐이냐).
			res.put("hosp", svc.selectHospInfo(hospCd));
			res.put("hospCd", hospCd);
			res.put("echoKw", kw);
			res.put("result", "OK");
		} catch (Exception ex) {
			fail(res, ex.getMessage());
		}
		return res;
	}

	// ===================== 사고 보고 =====================

	@RequestMapping(value = "/qps/incidentList.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> incidentList(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");

			QpsIncidentDTO dto = new QpsIncidentDTO();
			dto.setHospCd(hospCd);
			dto.setIncidGb(str(p.get("incidGb"), "FALL"));
			String year = str(p.get("inYear"), "");
			dto.setFromDt(str(p.get("fromDt"), year + "0101"));
			dto.setToDt(str(p.get("toDt"), year + "1231"));

			res.put("list", svc.selectIncidentList(dto));
			res.put("result", "OK");
		} catch (Exception ex) {
			fail(res, ex.getMessage());
		}
		return res;
	}

	@RequestMapping(value = "/qps/incidentSave.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> incidentSave(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");

			QpsIncidentDTO dto = new QpsIncidentDTO();
			dto.setHospCd(hospCd);
			dto.setIncidGb(str(p.get("incidGb"), "FALL"));
			dto.setIncidSeq(longOf(p.get("incidSeq")));
			dto.setOccurDt(str(p.get("occurDt"), ""));
			dto.setOccurTm(str(p.get("occurTm"), ""));
			dto.setWardCd(str(p.get("wardCd"), ""));
			dto.setRptDept(str(p.get("rptDept"), ""));
			dto.setPtNo(str(p.get("ptNo"), ""));
			dto.setPtSex(str(p.get("ptSex"), ""));
			dto.setPtAge(intOf(p.get("ptAge")));
			dto.setLevelCd(str(p.get("levelCd"), ""));
			dto.setTypeCd(str(p.get("typeCd"), ""));
			dto.setSubtypeCd(str(p.get("subtypeCd"), ""));
			dto.setPlaceCd(str(p.get("placeCd"), ""));
			dto.setDamageCd(str(p.get("damageCd"), ""));
			dto.setCauseTxt(str(p.get("causeTxt"), ""));
			dto.setActionTxt(str(p.get("actionTxt"), ""));
			dto.setRptUser(str(p.get("rptUser"), ""));
			dto.setStatus(str(p.get("status"), "DRAFT"));
			dto.setRegUser(userId(request));
			dto.setUpdUser(userId(request));

			if (dto.getOccurDt().isEmpty()) return fail(res, "발생일자는 필수입니다.");

			svc.saveIncident(dto);
			res.put("incidSeq", dto.getIncidSeq());
			res.put("result", "OK");
		} catch (Exception ex) {
			fail(res, ex.getMessage());
		}
		return res;
	}

	@RequestMapping(value = "/qps/incidentDelete.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> incidentDelete(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			QpsIncidentDTO dto = new QpsIncidentDTO();
			dto.setHospCd(hospCd);
			dto.setIncidSeq(longOf(p.get("incidSeq")));
			dto.setUpdUser(userId(request));
			svc.deleteIncident(dto);
			res.put("result", "OK");
		} catch (Exception ex) {
			fail(res, ex.getMessage());
		}
		return res;
	}

	// ===================== 관찰형 기록 (손위생 등) =====================

	@RequestMapping(value = "/qps/monitorList.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> monitorList(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			QpsMonitorDTO dto = new QpsMonitorDTO();
			dto.setHospCd(hospCd);
			dto.setIndiCd(str(p.get("indiCd"), "HANDWASH"));
			String year = str(p.get("inYear"), "");
			dto.setFromDt(str(p.get("fromDt"), year + "0101"));
			dto.setToDt(str(p.get("toDt"), year + "1231"));
			res.put("list", svc.selectMonitorList(dto));
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	@RequestMapping(value = "/qps/monitorSave.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> monitorSave(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			QpsMonitorDTO dto = new QpsMonitorDTO();
			dto.setHospCd(hospCd);
			dto.setIndiCd(str(p.get("indiCd"), "HANDWASH"));
			dto.setMonSeq(longOf(p.get("monSeq")));
			dto.setObsDt(str(p.get("obsDt"), ""));
			dto.setWardCd(str(p.get("wardCd"), ""));
			dto.setJobGb(str(p.get("jobGb"), ""));
			dto.setMomentCd(str(p.get("momentCd"), ""));
			dto.setObsCnt(intOf(p.get("obsCnt")));
			dto.setPassCnt(intOf(p.get("passCnt")));
			dto.setObserver(str(p.get("observer"), ""));
			dto.setNote(str(p.get("note"), ""));
			dto.setRegUser(userId(request));
			dto.setUpdUser(userId(request));
			if (dto.getObsDt().isEmpty()) return fail(res, "관찰일자는 필수입니다.");
			svc.saveMonitor(dto);
			res.put("monSeq", dto.getMonSeq());
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	@RequestMapping(value = "/qps/monitorDelete.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> monitorDelete(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			QpsMonitorDTO dto = new QpsMonitorDTO();
			dto.setHospCd(hospCd);
			dto.setMonSeq(longOf(p.get("monSeq")));
			dto.setUpdUser(userId(request));
			svc.deleteMonitor(dto);
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	// ===================== 분모(재원일수) =====================

	@RequestMapping(value = "/qps/censusGet.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> censusGet(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			res.put("census", svc.selectCensus(hospCd, str(p.get("censusGb"), "INDAYS"), str(p.get("inYear"), "")));
			res.put("result", "OK");
		} catch (Exception ex) {
			fail(res, ex.getMessage());
		}
		return res;
	}

	/** 재원일수 자동산출 — 입퇴원 자료로 계산해 돌려준다(저장 안 함 — 화면 칸만 채우고 사람이 저장). */
	@RequestMapping(value = "/qps/censusCalc.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> censusCalc(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		res.put("build", BUILD);
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			String inYear = str(p.get("inYear"), "");
			if (inYear.length() != 4) return fail(res, "년도가 필요합니다.");
			res.putAll(svc.calcCensusFromIpwon(hospCd, inYear));
			res.put("result", "OK");
		} catch (Exception ex) {
			fail(res, ex.getMessage());
		}
		return res;
	}

	@RequestMapping(value = "/qps/censusSave.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> censusSave(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");

			QpsCensusDTO dto = new QpsCensusDTO();
			dto.setHospCd(hospCd);
			dto.setCensusGb(str(p.get("censusGb"), "INDAYS"));
			dto.setInYear(str(p.get("inYear"), ""));
			dto.setM01(intOf(p.get("m01"))); dto.setM02(intOf(p.get("m02")));
			dto.setM03(intOf(p.get("m03"))); dto.setM04(intOf(p.get("m04")));
			dto.setM05(intOf(p.get("m05"))); dto.setM06(intOf(p.get("m06")));
			dto.setM07(intOf(p.get("m07"))); dto.setM08(intOf(p.get("m08")));
			dto.setM09(intOf(p.get("m09"))); dto.setM10(intOf(p.get("m10")));
			dto.setM11(intOf(p.get("m11"))); dto.setM12(intOf(p.get("m12")));
			dto.setRegUser(userId(request));
			dto.setUpdUser(userId(request));

			if (dto.getInYear().isEmpty()) return fail(res, "년도가 필요합니다.");
			svc.saveCensus(dto);
			res.put("result", "OK");
		} catch (Exception ex) {
			fail(res, ex.getMessage());
		}
		return res;
	}

	// ===================== 지표 산출 =====================

	@RequestMapping(value = "/qps/indiCalc.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> indiCalc(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			String indiCd = str(p.get("indiCd"), "FALL");
			String inYear = str(p.get("inYear"), "");

			res.putAll(svc.calcIndicator(hospCd, indiCd, inYear));

			// 선택 기간의 분류별 집계(연령·장소·시간·유형·부서)
			// ★분자와 같은 등급 필터를 쓴다 — calcIndicator 가 이미 읽어온 지표정의(indi)에서 꺼낸다.
			String fromDt = str(p.get("fromDt"), inYear + "0101");
			String toDt   = str(p.get("toDt"),   inYear + "1231");
			String minLevel = "", numerSrc = "";
			Object indiObj = res.get("indi");
			if (indiObj instanceof Map) {
				Object ml = ((Map<?, ?>) indiObj).get("minlevel");
				if (ml != null) minLevel = String.valueOf(ml).trim();
				Object ns = ((Map<?, ?>) indiObj).get("numersrc");
				if (ns != null) numerSrc = String.valueOf(ns).trim();
			}
			// 분류별 집계는 원천마다 다르다:
			//   MONITOR = 직군·병동·moment 별 수행률 / PATVAL = 없음(사고행 없음) / INCIDENT = 장소·손상·유형 등
			if ("MONITOR".equals(numerSrc)) {
				res.put("breakdown", svc.selectMonitorBreakdown(hospCd, indiCd, fromDt, toDt));
			} else if ("PATVAL".equals(numerSrc)) {
				res.put("breakdown", new HashMap<String, Object>());
			} else {
				res.put("breakdown", svc.selectBreakdown(hospCd, str(p.get("incidGb"), indiCd), fromDt, toDt, minLevel));
			}
			res.put("result", "OK");
		} catch (Exception ex) {
			fail(res, ex.getMessage());
		}
		return res;
	}

	// ===================== 보고서(서술) =====================

	@RequestMapping(value = "/qps/reportGet.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> reportGet(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			res.put("report", svc.selectReport(hospCd, str(p.get("indiCd"), "FALL"),
					str(p.get("prdGb"), "Q"), str(p.get("prdKey"), "")));
			res.put("result", "OK");
		} catch (Exception ex) {
			fail(res, ex.getMessage());
		}
		return res;
	}

	@RequestMapping(value = "/qps/reportSave.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> reportSave(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");

			Map<String, Object> m = new HashMap<>();
			m.put("hospCd", hospCd);
			m.put("indiCd", str(p.get("indiCd"), "FALL"));
			m.put("prdGb",  str(p.get("prdGb"),  "Q"));
			m.put("prdKey", str(p.get("prdKey"), ""));
			m.put("title",  str(p.get("title"), ""));
			m.put("analysisTxt", str(p.get("analysisTxt"), ""));
			m.put("planTxt",     str(p.get("planTxt"), ""));
			m.put("act1Txt", str(p.get("act1Txt"), ""));
			m.put("act2Txt", str(p.get("act2Txt"), ""));
			m.put("act3Txt", str(p.get("act3Txt"), ""));
			m.put("act4Txt", str(p.get("act4Txt"), ""));
			m.put("status",  str(p.get("status"), "DRAFT"));
			m.put("regUser", userId(request));

			if (String.valueOf(m.get("prdKey")).isEmpty()) return fail(res, "기간이 필요합니다.");
			svc.saveReport(m);
			res.put("result", "OK");
		} catch (Exception ex) {
			fail(res, ex.getMessage());
		}
		return res;
	}

	// ===================== 공통 =====================

	/** 병원코드 — 위너넷이면 화면에서 고른 병원, 아니면 로그인 병원으로 강제(거래처 격리). */
	private String hospCd(HttpServletRequest request, Map<String, Object> p) {
		Map<String, String> ck = ClientInfo.getCookie(request);
		String login = ck.get("s_hospid") == null ? "" : ck.get("s_hospid").trim();
		String wnn   = ck.get("s_wnn_yn") == null ? "N" : ck.get("s_wnn_yn").trim();
		if ("Y".equals(wnn)) {
			String sel = str(p.get("hospCd"), "");
			if (!sel.isEmpty()) return sel;
		}
		return login;
	}

	private String userId(HttpServletRequest request) {
		try {
			Map<String, String> ck = ClientInfo.getCookie(request);
			String u = ck.get("s_userid");
			return (u == null) ? "" : u.trim();
		} catch (Exception e) { return ""; }
	}

	private Map<String, Object> fail(Map<String, Object> res, String msg) {
		res.put("result", "FAIL");
		res.put("message", msg == null ? "처리 중 오류가 발생했습니다." : msg);
		return res;
	}

	private static String str(Object o, String def) {
		if (o == null) return def;
		String s = String.valueOf(o).trim();
		return s.isEmpty() ? def : s;
	}

	private static Integer intOf(Object o) {
		if (o == null) return null;
		String s = String.valueOf(o).trim().replace(",", "");
		if (s.isEmpty()) return null;
		try { return Integer.valueOf(s); } catch (Exception e) { return null; }
	}

	private static Long longOf(Object o) {
		if (o == null) return null;
		String s = String.valueOf(o).trim();
		if (s.isEmpty()) return null;
		try { return Long.valueOf(s); } catch (Exception e) { return null; }
	}
}
