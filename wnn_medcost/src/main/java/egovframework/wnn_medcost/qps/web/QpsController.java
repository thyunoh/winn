package egovframework.wnn_medcost.qps.web;

import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import org.springframework.web.multipart.MultipartFile;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.util.ClientInfo;
import egovframework.wnn_medcost.qps.model.QpsCensusDTO;
import egovframework.wnn_medcost.qps.model.QpsIncidentDTO;
import egovframework.wnn_medcost.qps.model.QpsManualDTO;
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
	private static final String BUILD = "20260811-SRVCYCLE";

	@Resource(name = "QpsService")
	private QpsService svc;

	@Resource // 공통 첨부 — 파일서버(SFTP) 전송 재사용(월보고서 PDF 와 같은 인프라)
	private egovframework.wnn_medcost.ftpload.service.SftpService sftpService;

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

			// 기간 딥링크(현황판→지표 이동용, 예: prd=Q2·H1). 주소 숨김이 location.search 를 지우므로
			// 쿼리를 JS 에서 읽지 않고 서버가 모델로 내려준다.
			String prd = request.getParameter("prd");
			model.addAttribute("prdKey", (prd == null) ? "" : prd.trim().toUpperCase());

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

	/**
	 * 지표 현황 — QPS 첫 화면. 18종을 영역별로 보여주고 클릭해서 각 지표로 들어간다.
	 *
	 * ★사이드바에 지표를 하나씩 늘어놓지 않는 이유: 18종(+병원별 추가)이면 메뉴가 화면을 다 먹고,
	 *   앞으로 붙을 지표정의서·분석보고서·서식이 들어갈 자리가 없다.
	 */
	@RequestMapping(value = "main/qpsIndex.do")
	public String qpsIndex(HttpServletRequest request, ModelMap model) {
		Map<String, String> ck = ClientInfo.getCookie(request);
		try {
			String hospId = ck.get("s_hospid") == null ? "" : ck.get("s_hospid").trim();
			if (hospId.isEmpty()) return ".login/LoginWinCT";
			model.addAttribute("hospCd", hospId);
			String wnn = ck.get("s_wnn_yn") == null ? "N" : ck.get("s_wnn_yn").trim();
			model.addAttribute("wnnYn", wnn);
			try {
				Map<String, Object> h = svc.selectHospInfo(hospId);
				model.addAttribute("hospNm", h == null || h.get("hospnm") == null ? "" : String.valueOf(h.get("hospnm")));
			} catch (Exception ignore) { model.addAttribute("hospNm", ""); }
			return ".main/qpsIndex";
		} catch (Exception ex) {
			return ".login/LoginWinCT";
		}
	}

	/**
	 * 지표정의서 편집 화면 — 정의서는 '병원이 채우는 빈 양식'이라 편집 화면이 곧 그 서식을 대체한다.
	 * 지표는 ?indi=코드 로 받는다(없으면 지표 현황에서 고르게 한다).
	 */
	@RequestMapping(value = "main/qpsDef.do")
	public String qpsDef(HttpServletRequest request, ModelMap model) {
		Map<String, String> ck = ClientInfo.getCookie(request);
		try {
			String hospId = ck.get("s_hospid") == null ? "" : ck.get("s_hospid").trim();
			if (hospId.isEmpty()) return ".login/LoginWinCT";
			model.addAttribute("hospCd", hospId);
			String indiCd = request.getParameter("indi");
			model.addAttribute("indiCd", (indiCd == null) ? "" : indiCd.trim().toUpperCase());
			String wnn = ck.get("s_wnn_yn") == null ? "N" : ck.get("s_wnn_yn").trim();
			model.addAttribute("wnnYn", wnn);
			try {
				Map<String, Object> h = svc.selectHospInfo(hospId);
				model.addAttribute("hospNm", h == null || h.get("hospnm") == null ? "" : String.valueOf(h.get("hospnm")));
			} catch (Exception ignore) { model.addAttribute("hospNm", ""); }
			return ".main/qpsDef";
		} catch (Exception ex) {
			return ".login/LoginWinCT";
		}
	}

	/**
	 * 지표분석보고서 현황판 — 선택 기간의 18종 전부를 작성·결재 상태와 함께 보여준다.
	 * QPS 담당자는 "어느 보고서가 안 됐나", 결재자는 "내가 승인할 문서가 있나"를 여기서 본다.
	 */
	@RequestMapping(value = "main/qpsRpt.do")
	public String qpsRpt(HttpServletRequest request, ModelMap model) {
		Map<String, String> ck = ClientInfo.getCookie(request);
		try {
			String hospId = ck.get("s_hospid") == null ? "" : ck.get("s_hospid").trim();
			if (hospId.isEmpty()) return ".login/LoginWinCT";
			model.addAttribute("hospCd", hospId);
			String wnn = ck.get("s_wnn_yn") == null ? "N" : ck.get("s_wnn_yn").trim();
			model.addAttribute("wnnYn", wnn);
			try {
				Map<String, Object> h = svc.selectHospInfo(hospId);
				model.addAttribute("hospNm", h == null || h.get("hospnm") == null ? "" : String.valueOf(h.get("hospnm")));
			} catch (Exception ignore) { model.addAttribute("hospNm", ""); }
			return ".main/qpsRpt";
		} catch (Exception ex) {
			return ".login/LoginWinCT";
		}
	}

	/** 현황판 목록(JSON) — 18종 × 선택 기간의 상태 + 결재선 단계 수. */
	@RequestMapping(value = "/qps/rptStatusList.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> rptStatusList(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		res.put("build", BUILD);
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			String prdKey = str(p.get("prdKey"), "");
			if (prdKey.length() < 5) return fail(res, "기간이 필요합니다.");
			String prdGb = prdKey.substring(4, 5);          // 2026Q1 → Q
			res.put("list", svc.selectRptStatus(hospCd, prdGb, prdKey));
			res.put("line", svc.selectApprLine(hospCd));    // 단계 수 — '2/4 단계' 표시용
			res.put("hosp", svc.selectHospInfo(hospCd));
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	/** 서식 2호: 연간 활동계획서(질향상·환자안전) — 인증 심사 필수 문서. 연 1부. */
	@RequestMapping(value = "main/qpsPlan.do")
	public String qpsPlan(HttpServletRequest request, ModelMap model) {
		Map<String, String> ck = ClientInfo.getCookie(request);
		try {
			String hospId = ck.get("s_hospid") == null ? "" : ck.get("s_hospid").trim();
			if (hospId.isEmpty()) return ".login/LoginWinCT";
			model.addAttribute("hospCd", hospId);
			String wnn = ck.get("s_wnn_yn") == null ? "N" : ck.get("s_wnn_yn").trim();
			model.addAttribute("wnnYn", wnn);
			try {
				Map<String, Object> h = svc.selectHospInfo(hospId);
				model.addAttribute("hospNm", h == null || h.get("hospnm") == null ? "" : String.valueOf(h.get("hospnm")));
			} catch (Exception ignore) { model.addAttribute("hospNm", ""); }
			putFormGb(request, model);   // 감염 메뉴에서 ?gb=I 로 들어오면 감염관리계획서로 열린다
			return ".main/qpsPlan";
		} catch (Exception ex) {
			return ".login/LoginWinCT";
		}
	}

	/**
	 * 만족도 조사 계획서 (만족도 사이클 #2) — 화면만 따로, 자료는 계획서와 같은 표를 쓴다.
	 *
	 * ★새 테이블·새 엔드포인트를 만들지 않았다. TBL_QPS_PLAN 의 서식구분(FORM_GB)에 'S' 를 하나 더 얹었을 뿐이다
	 *   (Q=질향상 · I=감염관리 · S=만족도 조사). 유니크 키가 이미 (병원, 구분, 년도)라 서로 안 부딪히고,
	 *   항목표(TBL_QPS_PLAN_ITEM)는 SECT_CD 로 갈리는 범용 표라 섹션만 다르게 쓰면 된다.
	 *   → planGet/planSave 가 formGb 를 그대로 받으므로 이 매핑 한 줄이면 끝난다.
	 */
	@RequestMapping(value = "main/qpsSrvPlan.do")
	public String qpsSrvPlan(HttpServletRequest request, ModelMap model) { return qpsScreen(request, model, ".main/qpsSrvPlan"); }

	@RequestMapping(value = "/qps/planGet.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> planGet(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			String inYear = str(p.get("inYear"), "");
			if (inYear.length() != 4) return fail(res, "년도가 필요합니다.");
			res.putAll(svc.selectPlanWithItems(hospCd, str(p.get("formGb"), "Q"), inYear));
			res.put("line", svc.selectApprLine(hospCd));
			res.put("hosp", svc.selectHospInfo(hospCd));
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	/** 저장 — 항목행은 items(JSON 배열 문자열)로 받아 통째 교체한다. */
	@RequestMapping(value = "/qps/planSave.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> planSave(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			String inYear = str(p.get("inYear"), "");
			if (inYear.length() != 4) return fail(res, "년도가 필요합니다.");

			java.util.List<Map<String, Object>> items = new java.util.ArrayList<>();
			String json = str(p.get("items"), "");
			if (!json.isEmpty()) {
				com.fasterxml.jackson.databind.ObjectMapper om = new com.fasterxml.jackson.databind.ObjectMapper();
				items = om.readValue(json,
					new com.fasterxml.jackson.core.type.TypeReference<java.util.List<Map<String, Object>>>(){});
			}
			long seq = svc.savePlan(hospCd, str(p.get("formGb"), "Q"), inYear, str(p.get("submitDt"), ""), items, userId(request));
			res.put("planSeq", seq);
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	/** 서식 3호: 환자안전 관리 라운딩 점검표 — 월 1부. [전월 복사]는 화면이 전월 roundGet 으로 채운다. */
	@RequestMapping(value = "main/qpsRound.do")
	public String qpsRound(HttpServletRequest request, ModelMap model) {
		Map<String, String> ck = ClientInfo.getCookie(request);
		try {
			String hospId = ck.get("s_hospid") == null ? "" : ck.get("s_hospid").trim();
			if (hospId.isEmpty()) return ".login/LoginWinCT";
			model.addAttribute("hospCd", hospId);
			String wnn = ck.get("s_wnn_yn") == null ? "N" : ck.get("s_wnn_yn").trim();
			model.addAttribute("wnnYn", wnn);
			try {
				Map<String, Object> h = svc.selectHospInfo(hospId);
				model.addAttribute("hospNm", h == null || h.get("hospnm") == null ? "" : String.valueOf(h.get("hospnm")));
			} catch (Exception ignore) { model.addAttribute("hospNm", ""); }
			putFormGb(request, model);   // 감염 메뉴에서 ?gb=I → 감염라운딩
			return ".main/qpsRound";
		} catch (Exception ex) {
			return ".login/LoginWinCT";
		}
	}

	@RequestMapping(value = "/qps/roundGet.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> roundGet(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			String ym = str(p.get("roundYm"), "").replace("-", "");
			if (ym.length() != 6) return fail(res, "년월이 필요합니다.");
			res.putAll(svc.selectRoundWithItems(hospCd, str(p.get("formGb"), "Q"), ym));
			res.put("hosp", svc.selectHospInfo(hospCd));
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	@RequestMapping(value = "/qps/roundSave.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> roundSave(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			String ym = str(p.get("roundYm"), "").replace("-", "");
			if (ym.length() != 6) return fail(res, "년월이 필요합니다.");

			java.util.List<Map<String, Object>> items = new java.util.ArrayList<>();
			String json = str(p.get("items"), "");
			if (!json.isEmpty()) {
				com.fasterxml.jackson.databind.ObjectMapper om = new com.fasterxml.jackson.databind.ObjectMapper();
				items = om.readValue(json,
					new com.fasterxml.jackson.core.type.TypeReference<java.util.List<Map<String, Object>>>(){});
			}
			res.put("rndSeq", svc.saveRound(hospCd, str(p.get("formGb"), "Q"), ym, str(p.get("checker"), ""), items, userId(request)));
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	/** 서식 1호: 위원회 회의록 — 서술형 서식 203종의 첫 파일럿(서식빌더 결정 근거용). */
	@RequestMapping(value = "main/qpsMinutes.do")
	public String qpsMinutes(HttpServletRequest request, ModelMap model) {
		Map<String, String> ck = ClientInfo.getCookie(request);
		try {
			String hospId = ck.get("s_hospid") == null ? "" : ck.get("s_hospid").trim();
			if (hospId.isEmpty()) return ".login/LoginWinCT";
			model.addAttribute("hospCd", hospId);
			String wnn = ck.get("s_wnn_yn") == null ? "N" : ck.get("s_wnn_yn").trim();
			model.addAttribute("wnnYn", wnn);
			try {
				Map<String, Object> h = svc.selectHospInfo(hospId);
				model.addAttribute("hospNm", h == null || h.get("hospnm") == null ? "" : String.valueOf(h.get("hospnm")));
			} catch (Exception ignore) { model.addAttribute("hospNm", ""); }
			putFormGb(request, model);   // 감염 메뉴에서 ?gb=I → 감염관리위원회
			return ".main/qpsMinutes";
		} catch (Exception ex) {
			return ".login/LoginWinCT";
		}
	}

	/** 기간의 전 지표 요약(JSON) — 회의록 [지표 요약 넣기]. 무거우니 버튼 클릭 시에만 부른다. */
	@RequestMapping(value = "/qps/indiSummary.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> indiSummary(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			String prdKey = str(p.get("prdKey"), "");
			if (prdKey.length() < 5) return fail(res, "기간이 필요합니다.");
			String prdGb = prdKey.length() == 4 ? "Y" : prdKey.substring(4, 5);
			res.put("list", svc.selectIndiSummary(hospCd, prdGb, prdKey));
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	@RequestMapping(value = "/qps/minutesList.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> minutesList(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			String inYear = str(p.get("inYear"), "");
			if (inYear.length() != 4) return fail(res, "년도가 필요합니다.");
			res.put("list", svc.selectMinutesList(hospCd, str(p.get("formGb"), "Q"), inYear));
			res.put("line", svc.selectApprLine(hospCd));   // 인쇄 결재란(빈칸)용
			res.put("hosp", svc.selectHospInfo(hospCd));
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	@RequestMapping(value = "/qps/minutesGet.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> minutesGet(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			long seq = longOf(p.get("minSeq")) == null ? 0L : longOf(p.get("minSeq"));
			if (seq <= 0) return fail(res, "문서 번호가 필요합니다.");
			res.put("doc", svc.selectMinutes(hospCd, seq));
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	@RequestMapping(value = "/qps/minutesSave.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> minutesSave(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			Map<String, Object> m = new HashMap<>();
			m.put("hospCd", hospCd);
			m.put("minSeq", str(p.get("minSeq"), ""));
			m.put("meetDt", str(p.get("meetDt"), ""));
			m.put("title",  str(p.get("title"), ""));
			// Q=질향상위원회 / I=감염관리위원회(2026-08-10) / J=QI 활동(2026-08-11)
			m.put("formGb", str(p.get("formGb"), "Q"));
			m.put("meetGb", str(p.get("meetGb"), ""));       // R=정기 / T=임시
			m.put("place",  str(p.get("place"), ""));
			m.put("clerkNm", str(p.get("clerkNm"), ""));     // 간사 — QI 회의록에 있는 칸
			m.put("personnel", str(p.get("personnel"), ""));
			m.put("attendees", str(p.get("attendees"), ""));
			m.put("members",   str(p.get("members"), ""));   // 직책: 이름 (줄바꿈 구분)
			m.put("agenda",  str(p.get("agenda"), ""));
			m.put("content", str(p.get("content"), ""));
			m.put("decision", str(p.get("decision"), ""));
			m.put("nextTxt", str(p.get("nextTxt"), ""));
			m.put("attachTxt",  str(p.get("attachTxt"), ""));
			m.put("specialTxt", str(p.get("specialTxt"), ""));
			m.put("regUser", userId(request));
			if (String.valueOf(m.get("meetDt")).isEmpty()) return fail(res, "회의일을 입력해 주세요.");
			if (String.valueOf(m.get("title")).isEmpty())  return fail(res, "회의명을 입력해 주세요.");
			res.put("minSeq", svc.saveMinutes(m));
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	@RequestMapping(value = "/qps/minutesDel.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> minutesDel(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			Map<String, Object> m = new HashMap<>();
			m.put("hospCd", hospCd);
			m.put("minSeq", longOf(p.get("minSeq")));
			m.put("regUser", userId(request));
			svc.deleteMinutes(m);
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	/** 사용 안내(도움말) — 정적 화면. 내용 수정은 qpsHelp.jsp 교체로 끝난다(재기동 불필요). */
	@RequestMapping(value = "main/qpsHelp.do")
	public String qpsHelp(HttpServletRequest request, ModelMap model) {
		Map<String, String> ck = ClientInfo.getCookie(request);
		try {
			String hospId = ck.get("s_hospid") == null ? "" : ck.get("s_hospid").trim();
			if (hospId.isEmpty()) return ".login/LoginWinCT";
			String wnn = ck.get("s_wnn_yn") == null ? "N" : ck.get("s_wnn_yn").trim();
			model.addAttribute("wnnYn", wnn);
			return ".main/qpsHelp";
		} catch (Exception ex) {
			return ".login/LoginWinCT";
		}
	}

	/**
	 * 자료실 — 조직도·내규처럼 "문서라기보다 보관물"인 자료를 분류별로 모아 둔다.
	 * 서식(회의록·계획서·라운딩)과 달리 본문 입력이 없다. 분류(QPS_LIB 코드)가 곧 첨부의 문서키다.
	 */
	@RequestMapping(value = "main/qpsLib.do")
	public String qpsLib(HttpServletRequest request, ModelMap model) {
		Map<String, String> ck = ClientInfo.getCookie(request);
		try {
			String hospId = ck.get("s_hospid") == null ? "" : ck.get("s_hospid").trim();
			if (hospId.isEmpty()) return ".login/LoginWinCT";
			model.addAttribute("hospCd", hospId);
			String wnn = ck.get("s_wnn_yn") == null ? "N" : ck.get("s_wnn_yn").trim();
			model.addAttribute("wnnYn", wnn);
			try {
				Map<String, Object> h = svc.selectHospInfo(hospId);
				model.addAttribute("hospNm", h == null || h.get("hospnm") == null ? "" : String.valueOf(h.get("hospnm")));
			} catch (Exception ignore) { model.addAttribute("hospNm", ""); }
			return ".main/qpsLib";
		} catch (Exception ex) {
			return ".login/LoginWinCT";
		}
	}

	/**
	 * 자료실을 고칠 수 있는 사람인가 — 보기·내려받기는 전원, 올리기·지우기만 이 판정을 탄다.
	 *   ① 위너넷 계정(지원 목적) → 항상 가능
	 *   ② TBL_QPS_MGR 에 지정된 담당자 → 가능
	 *   ③ 담당자가 한 명도 없으면 → 병원관리자(MAIN_GU 1·2·3)가 대신한다(신규 병원 락아웃 방지)
	 *   ④ 그 외 → 불가
	 * 등급은 쿠키(s_mainfg)를 믿지 않고 TBL_USER_MST 에서 직접 읽는다 — 쿠키는 화면에서 바꿀 수 있다.
	 */
	private String libPermWhy(HttpServletRequest request, String hospCd) {
		try {
			Map<String, String> ck = ClientInfo.getCookie(request);
			String wnn = ck.get("s_wnn_yn") == null ? "N" : ck.get("s_wnn_yn").trim();
			if ("Y".equals(wnn)) return "WNN";                        // ①
			String uid = userId(request);
			if (uid == null || uid.trim().isEmpty()) return "NONE";
			if (svc.selectQpsMgrYn(hospCd, uid) > 0) return "MGR";    // ②
			if (svc.selectQpsMgrCount(hospCd) == 0) {                 // ③
				String gu = svc.selectUserMainGu(hospCd, uid);
				if ("1".equals(gu) || "2".equals(gu) || "3".equals(gu)) return "ADMIN";
				return "NOMGR";   // 담당자도 없고 관리자도 아님 — 지정해 달라고 안내한다
			}
			return "NONE";                                            // ④
		} catch (Exception ex) {
			return "NONE";   // 판정이 안 되면 막는 쪽으로 — 규정 파일이 들어가는 곳이다
		}
	}

	private boolean canEditLib(HttpServletRequest request, String hospCd) {
		String why = libPermWhy(request, hospCd);
		return "WNN".equals(why) || "MGR".equals(why) || "ADMIN".equals(why);
	}

	/** 담당자 명단 자체를 고칠 수 있는 사람 — 병원관리자(1·2·3) 또는 위너넷. 담당자가 스스로를 늘리진 못한다. */
	private boolean canEditMgr(HttpServletRequest request, String hospCd) {
		try {
			Map<String, String> ck = ClientInfo.getCookie(request);
			String wnn = ck.get("s_wnn_yn") == null ? "N" : ck.get("s_wnn_yn").trim();
			if ("Y".equals(wnn)) return true;
			String gu = svc.selectUserMainGu(hospCd, userId(request));
			return "1".equals(gu) || "2".equals(gu) || "3".equals(gu);
		} catch (Exception ex) {
			return false;
		}
	}

	/** 자료실 권한 + 담당자 지정 화면 자료(병원 사용자 목록). */
	@RequestMapping(value = "/qps/mgrList.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> mgrList(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			String why = libPermWhy(request, hospCd);
			res.put("why",     why);                           // WNN/MGR/ADMIN/NOMGR/NONE — 화면 안내 문구용
			res.put("canEdit", "WNN".equals(why) || "MGR".equals(why) || "ADMIN".equals(why));
			res.put("canMgr",  canEditMgr(request, hospCd));   // 담당자 명단을 고칠 수 있는가
			res.put("mgrCnt",  svc.selectQpsMgrCount(hospCd));
			res.put("users",   svc.selectHospUsers(hospCd));
			res.put("result",  "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	/** 담당자 명단 저장 — 체크한 목록이 곧 최종 명단(통째 교체). */
	@RequestMapping(value = "/qps/mgrSave.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> mgrSave(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			if (!canEditMgr(request, hospCd)) return fail(res, "담당자 지정은 병원 관리자만 할 수 있습니다.");
			String ids = str(p.get("userIds"), "");   // 콤마로 이어 보낸다
			java.util.List<String> list = new java.util.ArrayList<>();
			if (!ids.isEmpty()) for (String s : ids.split(",")) if (!s.trim().isEmpty()) list.add(s.trim());
			svc.saveQpsMgr(hospCd, list, userId(request));
			res.put("saved", list.size());
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	/** 분류별 첨부 건수 — 자료실 왼쪽 목록의 (n) 배지. 분류마다 목록을 부르지 않으려고 한 번에 센다. */
	@RequestMapping(value = "/qps/fileCounts.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> fileCounts(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			String refGb = str(p.get("refGb"), "");
			Map<String, Object> cnt = new HashMap<>();
			java.util.List<Map<String, Object>> rows = svc.selectQpsFileCounts(hospCd, refGb);
			if (rows != null) for (Map<String, Object> r : rows) {
				cnt.put(String.valueOf(r.get("refkey")), r.get("cnt"));
			}
			res.put("counts", cnt);
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	/* ═══ 감염종합보고 (3종 통합 — P 계획수립 / D 수행 / E 손위생 교육결과) ═══
	     원본은 문서 3개지만 골격이 같아 한 서식으로 묶었다(2026-08-10 확정). */
	@RequestMapping(value = "main/qpsInfRpt.do")
	public String qpsInfRpt(HttpServletRequest request, ModelMap model) {
		Map<String, String> ck = ClientInfo.getCookie(request);
		try {
			String hospId = ck.get("s_hospid") == null ? "" : ck.get("s_hospid").trim();
			if (hospId.isEmpty()) return ".login/LoginWinCT";
			model.addAttribute("hospCd", hospId);
			model.addAttribute("wnnYn", ck.get("s_wnn_yn") == null ? "N" : ck.get("s_wnn_yn").trim());
			try {
				Map<String, Object> h = svc.selectHospInfo(hospId);
				model.addAttribute("hospNm", h == null || h.get("hospnm") == null ? "" : String.valueOf(h.get("hospnm")));
			} catch (Exception ignore) { model.addAttribute("hospNm", ""); }
			return ".main/qpsInfRpt";
		} catch (Exception ex) { return ".login/LoginWinCT"; }
	}

	@RequestMapping(value = "/qps/infRptList.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> infRptList(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			res.put("list", svc.selectInfRptList(hospCd, str(p.get("rptGb"), "P"), str(p.get("inYear"), "")));
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	@RequestMapping(value = "/qps/infRptGet.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> infRptGet(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			long seq = longOf(p.get("rptSeq")) == null ? 0 : longOf(p.get("rptSeq"));
			if (seq <= 0) return fail(res, "문서번호가 필요합니다.");
			res.putAll(svc.selectInfRptWithMem(hospCd, seq));
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	@RequestMapping(value = "/qps/infRptSave.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> infRptSave(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			if (str(p.get("rptDt"), "").isEmpty()) return fail(res, "작성일을 입력해 주세요.");

			Map<String, Object> m = new HashMap<>(p);
			m.put("hospCd", hospCd);
			m.put("rptGb",  str(p.get("rptGb"), "P"));
			m.put("regUser", userId(request));
			// 안 온 칸은 빈 값으로 — 서식마다 쓰는 칸이 달라 null 바인딩 오류를 막는다
			String[] cols = {"title","docCls","docNo","draftDt","drafter","deptNm","chairNm","roomNm",
			                 "coopNm","recvNm","refNm","sendDt","body","eduDt","eduTeacher",
			                 "eduTarget","eduTopic","eduBody","note"};
			for (String c : cols) m.put(c, str(p.get(c), ""));

			java.util.List<Map<String, Object>> mem = new java.util.ArrayList<>();
			String json = str(p.get("members"), "");
			if (!json.isEmpty()) {
				com.fasterxml.jackson.databind.ObjectMapper om = new com.fasterxml.jackson.databind.ObjectMapper();
				mem = om.readValue(json,
					new com.fasterxml.jackson.core.type.TypeReference<java.util.List<Map<String, Object>>>(){});
			}
			res.put("rptSeq", svc.saveInfRpt(m, mem));
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	@RequestMapping(value = "/qps/infRptDelete.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> infRptDelete(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			Map<String, Object> m = new HashMap<>();
			m.put("hospCd", hospCd);
			m.put("rptSeq", longOf(p.get("rptSeq")));
			m.put("regUser", userId(request));
			svc.deleteInfRpt(m);
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	/* ═══ 감염관리 우선순위 사정 도구 ═══ */
	@RequestMapping(value = "main/qpsInfRisk.do")
	public String qpsInfRisk(HttpServletRequest request, ModelMap model) {
		Map<String, String> ck = ClientInfo.getCookie(request);
		try {
			String hospId = ck.get("s_hospid") == null ? "" : ck.get("s_hospid").trim();
			if (hospId.isEmpty()) return ".login/LoginWinCT";
			model.addAttribute("hospCd", hospId);
			model.addAttribute("wnnYn", ck.get("s_wnn_yn") == null ? "N" : ck.get("s_wnn_yn").trim());
			try {
				Map<String, Object> h = svc.selectHospInfo(hospId);
				model.addAttribute("hospNm", h == null || h.get("hospnm") == null ? "" : String.valueOf(h.get("hospnm")));
			} catch (Exception ignore) { model.addAttribute("hospNm", ""); }
			return ".main/qpsInfRisk";
		} catch (Exception ex) { return ".login/LoginWinCT"; }
	}

	@RequestMapping(value = "/qps/infRiskList.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> infRiskList(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			res.put("list", svc.selectInfRiskList(hospCd, str(p.get("inYear"), "")));
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	/** 평가 1건 — riskSeq 가 없으면 기본 항목표(31종)만 돌려준다(새 평가 화면). */
	@RequestMapping(value = "/qps/infRiskGet.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> infRiskGet(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			Long seq = longOf(p.get("riskSeq"));
			if (seq == null || seq <= 0) {
				res.put("doc", null);
				res.put("items", svc.selectInfRiskDef());
			} else {
				res.putAll(svc.selectInfRiskWithItems(hospCd, seq));
			}
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	@RequestMapping(value = "/qps/infRiskSave.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> infRiskSave(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			if (str(p.get("evalDt"), "").isEmpty()) return fail(res, "평가일시를 입력해 주세요.");
			Map<String, Object> m = new HashMap<>();
			m.put("hospCd", hospCd);
			m.put("evalDt", str(p.get("evalDt"), ""));
			m.put("evaluator", str(p.get("evaluator"), ""));
			m.put("regUser", userId(request));

			java.util.List<Map<String, Object>> items = new java.util.ArrayList<>();
			String json = str(p.get("items"), "");
			if (!json.isEmpty()) {
				com.fasterxml.jackson.databind.ObjectMapper om = new com.fasterxml.jackson.databind.ObjectMapper();
				items = om.readValue(json,
					new com.fasterxml.jackson.core.type.TypeReference<java.util.List<Map<String, Object>>>(){});
			}
			res.put("riskSeq", svc.saveInfRisk(m, items));
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	@RequestMapping(value = "/qps/infRiskDelete.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> infRiskDelete(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			Map<String, Object> m = new HashMap<>();
			m.put("hospCd", hospCd);
			m.put("riskSeq", longOf(p.get("riskSeq")));
			m.put("regUser", userId(request));
			svc.deleteInfRisk(m);
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	/* ═══ 감염병환자 월별 리스트 ═══ */
	@RequestMapping(value = "main/qpsInfPat.do")
	public String qpsInfPat(HttpServletRequest request, ModelMap model) { return qpsScreen(request, model, ".main/qpsInfPat"); }

	@RequestMapping(value = "/qps/infPatGet.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> infPatGet(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			String ym = str(p.get("ipatYm"), "").replace("-", "");
			if (ym.length() != 6) return fail(res, "년월이 필요합니다.");
			res.putAll(svc.selectInfPatWithItems(hospCd, ym));
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	@RequestMapping(value = "/qps/infPatSave.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> infPatSave(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			String ym = str(p.get("ipatYm"), "").replace("-", "");
			if (ym.length() != 6) return fail(res, "년월이 필요합니다.");
			Map<String, Object> m = new HashMap<>();
			m.put("hospCd", hospCd); m.put("ipatYm", ym);
			m.put("stBlood", str(p.get("stBlood"), ""));
			m.put("stMdro",  str(p.get("stMdro"), ""));
			m.put("stTb",    str(p.get("stTb"), ""));
			m.put("regUser", userId(request));
			res.put("ipatSeq", svc.saveInfPat(m, jsonRows(p.get("items"))));
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	/* ═══ QI 활동 계획서 ═══
	   원본 10장(낙상·손위생·신체보호대·욕창·불만고충·영양실·근접오류·투약오류·학대및폭력·재택복귀율)
	   대조 결과 서식은 하나이고 <주제별로 한 장>이다. */
	@RequestMapping(value = "main/qpsQiPlan.do")
	public String qpsQiPlan(HttpServletRequest request, ModelMap model) { return qpsScreen(request, model, ".main/qpsQiPlan"); }

	@RequestMapping(value = "/qps/qiPlanList.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> qiPlanList(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		res.put("build", BUILD);
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			String inYear = str(p.get("inYear"), "");
			if (inYear.length() != 4) return fail(res, "년도가 필요합니다.");
			res.put("list", svc.selectQiPlanList(hospCd, inYear));
			res.put("indi", svc.selectIndiList(hospCd, inYear));   // 주제 고르기 — 지표 18종
			res.put("line", svc.selectApprLine(hospCd));
			res.put("hosp", svc.selectHospInfo(hospCd));
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	@RequestMapping(value = "/qps/qiPlanGet.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> qiPlanGet(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			Long seq = longOf(p.get("qipSeq"));
			if (seq == null || seq <= 0) return fail(res, "계획서를 선택해 주세요.");
			res.putAll(svc.selectQiPlanWithItems(hospCd, seq));
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	@RequestMapping(value = "/qps/qiPlanSave.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> qiPlanSave(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			String inYear = str(p.get("inYear"), "");
			if (inYear.length() != 4) return fail(res, "년도가 필요합니다.");
			if (str(p.get("topicNm"), "").isEmpty()) return fail(res, "주제명을 입력해 주세요.");

			Map<String, Object> m = new HashMap<>();
			m.put("hospCd", hospCd);
			m.put("qipSeq",     str(p.get("qipSeq"), ""));
			m.put("inYear",     inYear);
			// 지표에서 고른 주제면 코드가, 자유 주제(영양실 등)면 빈 값이 온다
			m.put("indiCd",     str(p.get("indiCd"), ""));
			m.put("topicNm",    str(p.get("topicNm"), ""));
			m.put("deptNm",     str(p.get("deptNm"), ""));
			m.put("submitDt",   str(p.get("submitDt"), ""));
			m.put("background", str(p.get("background"), ""));
			// 핵심지표 — 정의서에서 채워 온 값을 이 문서의 스냅샷으로 저장한다
			m.put("indiNm",     str(p.get("indiNm"), ""));
			m.put("numerDesc",  str(p.get("numerDesc"), ""));
			m.put("denomDesc",  str(p.get("denomDesc"), ""));
			m.put("includeTxt", str(p.get("includeTxt"), ""));
			m.put("excludeTxt", str(p.get("excludeTxt"), ""));
			m.put("targetVal",  str(p.get("targetVal"), ""));
			m.put("multiplier", intOf(p.get("multiplier")));
			m.put("unit",       str(p.get("unit"), ""));
			m.put("srcTxt",      str(p.get("srcTxt"), ""));
			m.put("strategyTxt", str(p.get("strategyTxt"), ""));
			m.put("expectTxt",   str(p.get("expectTxt"), ""));
			m.put("regUser",     userId(request));
			res.put("qipSeq", svc.saveQiPlan(m, jsonRows(p.get("items"))));
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	@RequestMapping(value = "/qps/qiPlanDelete.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> qiPlanDelete(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			Map<String, Object> m = new HashMap<>();
			m.put("hospCd", hospCd);
			m.put("qipSeq", longOf(p.get("qipSeq")));
			m.put("regUser", userId(request));
			svc.deleteQiPlan(m);
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	/* ═══ FMEA 계획서·보고서 (한 서식 + 문서구분) ═══
	   ★FMEA 회의록은 여기 없다 — 서식 1호(회의록)에 FORM_GB='F' 로 흡수했다. */
	@RequestMapping(value = "main/qpsFmea.do")
	public String qpsFmea(HttpServletRequest request, ModelMap model) { return qpsScreen(request, model, ".main/qpsFmea"); }

	@RequestMapping(value = "/qps/fmeaBase.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> fmeaBase(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		res.put("build", BUILD);
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			String inYear = str(p.get("inYear"), "");
			if (inYear.length() != 4) return fail(res, "년도가 필요합니다.");
			res.putAll(svc.selectFmeaBase(hospCd, inYear, str(p.get("docGb"), "P")));
			res.put("indi", svc.selectIndiList(hospCd, inYear));
			res.put("line", svc.selectApprLine(hospCd));
			res.put("hosp", svc.selectHospInfo(hospCd));
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	@RequestMapping(value = "/qps/fmeaGet.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> fmeaGet(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			Long seq = longOf(p.get("fmeSeq"));
			if (seq == null || seq <= 0) return fail(res, "문서를 선택해 주세요.");
			res.putAll(svc.selectFmeaOne(hospCd, seq));
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	@RequestMapping(value = "/qps/fmeaSave.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> fmeaSave(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			String inYear = str(p.get("inYear"), "");
			if (inYear.length() != 4) return fail(res, "년도가 필요합니다.");
			if (str(p.get("topicNm"), "").isEmpty()) return fail(res, "주제를 입력해 주세요.");
			Map<String, Object> m = new HashMap<>();
			m.put("hospCd", hospCd);
			m.put("fmeSeq",  str(p.get("fmeSeq"), ""));
			m.put("inYear",  inYear);
			m.put("docGb",   str(p.get("docGb"), "P"));       // P=계획서 R=보고서
			m.put("indiCd",  str(p.get("indiCd"), ""));
			m.put("topicNm", str(p.get("topicNm"), ""));
			m.put("writeDt", str(p.get("writeDt"), ""));
			m.put("writerNm", str(p.get("writerNm"), ""));
			m.put("purpose", str(p.get("purpose"), ""));
			// 활동일정 기간 열 이름 — 원본이 「7~8월 / 9월 / 10월」처럼 가변이다
			m.put("prdHead", str(p.get("prdHead"), ""));
			m.put("stepTxt",   str(p.get("stepTxt"), ""));    m.put("rcaDiff",   str(p.get("rcaDiff"), ""));
			m.put("hiriskTxt", str(p.get("hiriskTxt"), ""));  m.put("goalTxt",   str(p.get("goalTxt"), ""));
			m.put("procmapTxt", str(p.get("procmapTxt"), "")); m.put("rootStep", str(p.get("rootStep"), ""));
			m.put("rootHr",  str(p.get("rootHr"), ""));  m.put("rootEnv", str(p.get("rootEnv"), ""));
			m.put("rootSys", str(p.get("rootSys"), "")); m.put("fishboneTxt", str(p.get("fishboneTxt"), ""));
			m.put("imprTxt",  str(p.get("imprTxt"), ""));  m.put("verifyTxt", str(p.get("verifyTxt"), ""));
			m.put("conclTxt", str(p.get("conclTxt"), "")); m.put("nextTxt",   str(p.get("nextTxt"), ""));
			m.put("shareTxt", str(p.get("shareTxt"), ""));
			m.put("regUser",  userId(request));
			res.put("fmeSeq", svc.saveFmea(m, jsonRows(p.get("items")), jsonRows(p.get("sheet"))));
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	@RequestMapping(value = "/qps/fmeaDelete.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> fmeaDelete(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			Map<String, Object> m = new HashMap<>();
			m.put("hospCd", hospCd); m.put("fmeSeq", longOf(p.get("fmeSeq"))); m.put("regUser", userId(request));
			svc.deleteFmea(m);
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	/* ═══ RCA 근본원인 분석 보고서 ═══
	   ★RCA 회의록은 여기 없다 — 서식 1호(회의록)에 FORM_GB='R' 로 흡수했다. */
	@RequestMapping(value = "main/qpsRca.do")
	public String qpsRca(HttpServletRequest request, ModelMap model) { return qpsScreen(request, model, ".main/qpsRca"); }

	@RequestMapping(value = "/qps/rcaList.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> rcaList(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		res.put("build", BUILD);
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			String inYear = str(p.get("inYear"), "");
			if (inYear.length() != 4) return fail(res, "년도가 필요합니다.");
			res.put("list", svc.selectRcaList(hospCd, inYear));
			res.put("line", svc.selectApprLine(hospCd));
			res.put("hosp", svc.selectHospInfo(hospCd));
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	@RequestMapping(value = "/qps/rcaGet.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> rcaGet(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			Long seq = longOf(p.get("rcaSeq"));
			if (seq == null || seq <= 0) return fail(res, "보고서를 선택해 주세요.");
			res.put("doc", svc.selectRca(hospCd, seq));
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	@RequestMapping(value = "/qps/rcaSave.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> rcaSave(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			String inYear = str(p.get("inYear"), "");
			if (inYear.length() != 4) return fail(res, "년도가 필요합니다.");
			if (str(p.get("occurDt"), "").isEmpty()) return fail(res, "발생일시를 입력해 주세요.");
			Map<String, Object> m = new HashMap<>();
			m.put("hospCd", hospCd);
			m.put("rcaSeq",   str(p.get("rcaSeq"), ""));
			m.put("inYear",   inYear);
			m.put("incidSeq", longOf(p.get("incidSeq")));
			m.put("roomNm",  str(p.get("roomNm"), ""));  m.put("patNm",  str(p.get("patNm"), ""));
			m.put("patNo",   str(p.get("patNo"), ""));   m.put("sexAge", str(p.get("sexAge"), ""));
			m.put("occurDt", str(p.get("occurDt"), "")); m.put("occurTm", str(p.get("occurTm"), ""));
			m.put("occurPl", str(p.get("occurPl"), "")); m.put("problem", str(p.get("problem"), ""));
			m.put("processTxt", str(p.get("processTxt"), ""));
			m.put("hrPerson", str(p.get("hrPerson"), "")); m.put("hrEdu",   str(p.get("hrEdu"), ""));
			m.put("syProc",   str(p.get("syProc"), ""));   m.put("syEquip", str(p.get("syEquip"), ""));
			m.put("syEnv",    str(p.get("syEnv"), ""));    m.put("syComm",  str(p.get("syComm"), ""));
			m.put("syEtc",    str(p.get("syEtc"), ""));
			m.put("actHr",    str(p.get("actHr"), ""));    m.put("actSy",   str(p.get("actSy"), ""));
			m.put("actEtc",   str(p.get("actEtc"), ""));   m.put("resultTxt", str(p.get("resultTxt"), ""));
			m.put("writeDt",  str(p.get("writeDt"), ""));  m.put("writerNm",  str(p.get("writerNm"), ""));
			m.put("regUser",  userId(request));
			res.put("rcaSeq", svc.saveRca(m));
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	@RequestMapping(value = "/qps/rcaDelete.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> rcaDelete(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			Map<String, Object> m = new HashMap<>();
			m.put("hospCd", hospCd); m.put("rcaSeq", longOf(p.get("rcaSeq"))); m.put("regUser", userId(request));
			svc.deleteRca(m);
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	/* ═══ 사고 유형별 보고서 (한 서식 + 유형) ═══
	   ★체크박스 묶음은 항목표(TBL_QPS_SAFERPT_DEF)에서 온다 — 유형이 늘어도 코드를 안 고친다. */
	@RequestMapping(value = "main/qpsSafeRpt.do")
	public String qpsSafeRpt(HttpServletRequest request, ModelMap model) { return qpsScreen(request, model, ".main/qpsSafeRpt"); }

	@RequestMapping(value = "/qps/safeRptBase.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> safeRptBase(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		res.put("build", BUILD);
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			String inYear = str(p.get("inYear"), "");
			if (inYear.length() != 4) return fail(res, "년도가 필요합니다.");
			res.putAll(svc.selectSafeRptBase(hospCd, inYear, str(p.get("rptGb"), "PTSAFE")));
			res.put("line", svc.selectApprLine(hospCd));
			res.put("hosp", svc.selectHospInfo(hospCd));
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	@RequestMapping(value = "/qps/safeRptGet.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> safeRptGet(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			Long seq = longOf(p.get("srpSeq"));
			if (seq == null || seq <= 0) return fail(res, "보고서를 선택해 주세요.");
			res.putAll(svc.selectSafeRptOne(hospCd, seq));
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	@RequestMapping(value = "/qps/safeRptSave.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> safeRptSave(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			String inYear = str(p.get("inYear"), "");
			if (inYear.length() != 4) return fail(res, "년도가 필요합니다.");
			if (str(p.get("occurDt"), "").isEmpty()) return fail(res, "발생일을 입력해 주세요.");
			Map<String, Object> m = new HashMap<>();
			m.put("hospCd", hospCd);
			m.put("srpSeq",  str(p.get("srpSeq"), ""));
			m.put("inYear",  inYear);
			m.put("rptGb",   str(p.get("rptGb"), "PTSAFE"));
			m.put("incidSeq", longOf(p.get("incidSeq")));   // 사고 연결(없으면 null)
			m.put("occurDt", str(p.get("occurDt"), ""));  m.put("occurTm", str(p.get("occurTm"), ""));
			m.put("rptDt",   str(p.get("rptDt"), ""));    m.put("place",   str(p.get("place"), ""));
			m.put("targetNm", str(p.get("targetNm"), "")); m.put("targetNo", str(p.get("targetNo"), ""));
			m.put("deptNm",   str(p.get("deptNm"), ""));   m.put("positionNm", str(p.get("positionNm"), ""));
			m.put("admitDt",  str(p.get("admitDt"), ""));  m.put("diagNm",  str(p.get("diagNm"), ""));
			m.put("wWhen", str(p.get("wWhen"), "")); m.put("wWho",  str(p.get("wWho"), ""));
			m.put("wWhat", str(p.get("wWhat"), "")); m.put("wHow",  str(p.get("wHow"), ""));
			m.put("wWhy",  str(p.get("wWhy"), ""));  m.put("wWhere", str(p.get("wWhere"), ""));
			m.put("summary",   str(p.get("summary"), ""));   m.put("vitalTxt", str(p.get("vitalTxt"), ""));
			m.put("injuryTxt", str(p.get("injuryTxt"), "")); m.put("treatTxt", str(p.get("treatTxt"), ""));
			m.put("causeTxt",  str(p.get("causeTxt"), ""));  m.put("planTxt",  str(p.get("planTxt"), ""));
			m.put("note",      str(p.get("note"), ""));
			m.put("regUser",   userId(request));
			res.put("srpSeq", svc.saveSafeRpt(m, jsonRows(p.get("chks"))));
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	@RequestMapping(value = "/qps/safeRptDelete.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> safeRptDelete(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			Map<String, Object> m = new HashMap<>();
			m.put("hospCd", hospCd); m.put("srpSeq", longOf(p.get("srpSeq"))); m.put("regUser", userId(request));
			svc.deleteSafeRpt(m);
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	/* ═══ QI 중간·최종보고서 (한 서식 + 종류 구분) ═══ */
	@RequestMapping(value = "main/qpsQiRpt.do")
	public String qpsQiRpt(HttpServletRequest request, ModelMap model) { return qpsScreen(request, model, ".main/qpsQiRpt"); }

	@RequestMapping(value = "/qps/qiRptList.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> qiRptList(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		res.put("build", BUILD);
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			String inYear = str(p.get("inYear"), "");
			if (inYear.length() != 4) return fail(res, "년도가 필요합니다.");
			res.put("list", svc.selectQiRptList(hospCd, inYear, str(p.get("rptGb"), "M")));
			res.put("indi", svc.selectIndiList(hospCd, inYear));
			res.put("line", svc.selectApprLine(hospCd));
			res.put("hosp", svc.selectHospInfo(hospCd));
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	@RequestMapping(value = "/qps/qiRptGet.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> qiRptGet(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			Long seq = longOf(p.get("qirSeq"));
			if (seq == null || seq <= 0) return fail(res, "보고서를 선택해 주세요.");
			res.putAll(svc.selectQiRptWithItems(hospCd, seq));
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	@RequestMapping(value = "/qps/qiRptSave.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> qiRptSave(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			String inYear = str(p.get("inYear"), "");
			if (inYear.length() != 4) return fail(res, "년도가 필요합니다.");
			if (str(p.get("topicNm"), "").isEmpty()) return fail(res, "주제를 입력해 주세요.");
			Map<String, Object> m = new HashMap<>();
			m.put("hospCd", hospCd);
			m.put("qirSeq",  str(p.get("qirSeq"), ""));
			m.put("inYear",  inYear);
			m.put("rptGb",   str(p.get("rptGb"), "M"));       // M=중간 F=최종
			m.put("indiCd",  str(p.get("indiCd"), ""));
			m.put("topicNm", str(p.get("topicNm"), ""));
			m.put("deptNm",  str(p.get("deptNm"), ""));
			m.put("submitDt", str(p.get("submitDt"), ""));
			m.put("background",   str(p.get("background"), ""));
			m.put("surveyTarget", str(p.get("surveyTarget"), ""));
			m.put("surveyFrMm",   str(p.get("surveyFrMm"), ""));
			m.put("surveyToMm",   str(p.get("surveyToMm"), ""));
			m.put("surveyMethod", str(p.get("surveyMethod"), ""));
			m.put("analysis", str(p.get("analysis"), ""));
			m.put("goalTxt",  str(p.get("goalTxt"), ""));
			m.put("actTxt",   str(p.get("actTxt"), ""));
			m.put("planTxt",  str(p.get("planTxt"), ""));
			m.put("note",     str(p.get("note"), ""));
			// 활동효과·결론은 최종보고서에서만 쓴다(중간이면 빈 값이 온다)
			m.put("effectTxt", str(p.get("effectTxt"), ""));
			m.put("conclTxt",  str(p.get("conclTxt"), ""));
			m.put("regUser",   userId(request));
			res.put("qirSeq", svc.saveQiRpt(m, jsonRows(p.get("items"))));
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	@RequestMapping(value = "/qps/qiRptDelete.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> qiRptDelete(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			Map<String, Object> m = new HashMap<>();
			m.put("hospCd", hospCd); m.put("qirSeq", longOf(p.get("qirSeq"))); m.put("regUser", userId(request));
			svc.deleteQiRpt(m);
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	/* ═══ QI 주제선정 기준표 + 우선순위 집계표 (한 화면 두 탭) ═══ */
	@RequestMapping(value = "main/qpsQiTopic.do")
	public String qpsQiTopic(HttpServletRequest request, ModelMap model) { return qpsScreen(request, model, ".main/qpsQiTopic"); }

	@RequestMapping(value = "/qps/qiTopicList.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> qiTopicList(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		res.put("build", BUILD);
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			String inYear = str(p.get("inYear"), "");
			if (inYear.length() != 4) return fail(res, "년도가 필요합니다.");
			res.put("list", svc.selectQiTopicList(hospCd, inYear));
			res.putAll(svc.selectQiTopicRollup(hospCd, inYear));   // 집계표 — 저장 안 하고 계산
			res.put("line", svc.selectApprLine(hospCd));
			res.put("hosp", svc.selectHospInfo(hospCd));
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	@RequestMapping(value = "/qps/qiTopicGet.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> qiTopicGet(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			Long seq = longOf(p.get("qitSeq"));
			if (seq == null || seq <= 0) return fail(res, "평가위원을 선택해 주세요.");
			res.putAll(svc.selectQiTopicWithItems(hospCd, seq));
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	@RequestMapping(value = "/qps/qiTopicSave.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> qiTopicSave(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			String inYear = str(p.get("inYear"), "");
			if (inYear.length() != 4) return fail(res, "년도가 필요합니다.");
			// ★평가위원이 문서를 가르는 키다 — 비면 집계에서 누가 매긴 점수인지 알 수 없다.
			if (str(p.get("evaluator"), "").isEmpty()) return fail(res, "평가위원을 입력해 주세요.");
			Map<String, Object> m = new HashMap<>();
			m.put("hospCd", hospCd);
			m.put("qitSeq",    str(p.get("qitSeq"), ""));
			m.put("inYear",    inYear);
			m.put("evalDt",    str(p.get("evalDt"), ""));
			m.put("evaluator", str(p.get("evaluator"), ""));
			m.put("regUser",   userId(request));
			res.put("qitSeq", svc.saveQiTopic(m, jsonRows(p.get("items"))));
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	@RequestMapping(value = "/qps/qiTopicDelete.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> qiTopicDelete(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			Map<String, Object> m = new HashMap<>();
			m.put("hospCd", hospCd); m.put("qitSeq", longOf(p.get("qitSeq"))); m.put("regUser", userId(request));
			svc.deleteQiTopic(m);
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	/* ═══ QI 활동 자원지원 내역 (연 1부) ═══ */
	@RequestMapping(value = "main/qpsQiFund.do")
	public String qpsQiFund(HttpServletRequest request, ModelMap model) { return qpsScreen(request, model, ".main/qpsQiFund"); }

	@RequestMapping(value = "/qps/qiFundGet.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> qiFundGet(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		res.put("build", BUILD);
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			String inYear = str(p.get("inYear"), "");
			if (inYear.length() != 4) return fail(res, "년도가 필요합니다.");
			res.putAll(svc.selectQiFundWithItems(hospCd, inYear));
			res.put("line", svc.selectApprLine(hospCd));
			res.put("hosp", svc.selectHospInfo(hospCd));
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	@RequestMapping(value = "/qps/qiFundSave.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> qiFundSave(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			String inYear = str(p.get("inYear"), "");
			if (inYear.length() != 4) return fail(res, "년도가 필요합니다.");
			Map<String, Object> m = new HashMap<>();
			m.put("hospCd", hospCd); m.put("inYear", inYear); m.put("regUser", userId(request));
			res.put("qifSeq", svc.saveQiFund(m, jsonRows(p.get("items"))));
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	/* ═══ 불만고충 ═══
	   처리계획서는 여기 없다 — TBL_QPS_PLAN 의 FORM_GB='C' 로 계획서 엔드포인트를 그대로 쓴다. */

	/** 처리대장 + 개선활동 처리결과. 한 화면 두 탭 — 대장이 목록, 처리결과가 그 건의 상세다. */
	@RequestMapping(value = "main/qpsCmpl.do")
	public String qpsCmpl(HttpServletRequest request, ModelMap model) { return qpsScreen(request, model, ".main/qpsCmpl"); }

	/** 불만고충 처리계획서 — 화면만 따로, 자료는 연간 활동계획서와 같은 표(FORM_GB='C'). */
	@RequestMapping(value = "main/qpsCmplPlan.do")
	public String qpsCmplPlan(HttpServletRequest request, ModelMap model) { return qpsScreen(request, model, ".main/qpsCmplPlan"); }

	/** 불만고충 지표분석보고서 — 한 화면 + 반기 구분으로 원본 3종을 덮는다. */
	@RequestMapping(value = "main/qpsCmplRpt.do")
	public String qpsCmplRpt(HttpServletRequest request, ModelMap model) { return qpsScreen(request, model, ".main/qpsCmplRpt"); }

	@RequestMapping(value = "/qps/cmplList.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> cmplList(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		res.put("build", BUILD);
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			String inYear = str(p.get("inYear"), "");
			if (inYear.length() != 4) return fail(res, "년도가 필요합니다.");
			res.put("list", svc.selectCmplList(hospCd, inYear));
			res.put("line", svc.selectApprLine(hospCd));
			res.put("hosp", svc.selectHospInfo(hospCd));
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	/** 대장 저장 — ★행별 upsert. 통째 교체하면 각 건에 매달린 처리결과가 미아가 된다. */
	@RequestMapping(value = "/qps/cmplSave.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> cmplSave(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			String inYear = str(p.get("inYear"), "");
			if (inYear.length() != 4) return fail(res, "년도가 필요합니다.");
			res.put("saved", svc.saveCmplRows(hospCd, inYear, jsonRows(p.get("rows")), userId(request)));
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	@RequestMapping(value = "/qps/cmplDelete.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> cmplDelete(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			Map<String, Object> m = new HashMap<>();
			m.put("hospCd", hospCd);
			m.put("cmplSeq", longOf(p.get("cmplSeq")));
			m.put("regUser", userId(request));
			svc.deleteCmpl(m);
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	/** 건별 처리결과 조회 — 아직 안 쓴 건이면 act 가 null 로 온다(새 문서). */
	@RequestMapping(value = "/qps/cmplActGet.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> cmplActGet(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			Long seq = longOf(p.get("cmplSeq"));
			if (seq == null || seq <= 0) return fail(res, "대장에서 건을 먼저 고르세요.");
			res.put("act", svc.selectCmplAct(hospCd, seq));
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	@RequestMapping(value = "/qps/cmplActSave.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> cmplActSave(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			Long seq = longOf(p.get("cmplSeq"));
			if (seq == null || seq <= 0) return fail(res, "대장에서 건을 먼저 고르세요.");
			// ★남의 병원 건에 상세를 붙이지 못하게 — 대장 행이 이 병원 것인지 먼저 확인한다.
			boolean mine = false;
			for (Map<String, Object> r : svc.selectCmplList(hospCd, str(p.get("inYear"), ""))) {
				if (seq.equals(longOf(r.get("cmplseq")))) { mine = true; break; }
			}
			if (!mine) return fail(res, "이 병원의 대장에 없는 건입니다.");

			Map<String, Object> m = new HashMap<>();
			m.put("cmplSeq", seq);
			m.put("rptDt",    str(p.get("rptDt"), ""));
			m.put("deptNm",   str(p.get("deptNm"), ""));
			m.put("imprDt",   str(p.get("imprDt"), ""));
			m.put("place",    str(p.get("place"), ""));
			m.put("problem",  str(p.get("problem"), ""));
			m.put("analysis", str(p.get("analysis"), ""));
			m.put("planTxt",  str(p.get("planTxt"), ""));
			m.put("actTxt",   str(p.get("actTxt"), ""));
			m.put("cause",    str(p.get("cause"), ""));
			m.put("answer",   str(p.get("answer"), ""));
			m.put("prevent",  str(p.get("prevent"), ""));
			m.put("regUser",  userId(request));
			svc.saveCmplAct(m);
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	/** 지표분석보고서 — 서술칸(저장분) + 수치(대장 집계)를 함께 돌려준다. */
	@RequestMapping(value = "/qps/cmplRptGet.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> cmplRptGet(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		res.put("build", BUILD);
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			String inYear = str(p.get("inYear"), "");
			if (inYear.length() != 4) return fail(res, "년도가 필요합니다.");
			String halfGb = str(p.get("halfGb"), "1");
			res.put("doc",  svc.selectCmplRpt(hospCd, inYear, halfGb));
			res.put("stat", svc.selectCmplStat(hospCd, inYear, halfGb));
			res.put("line", svc.selectApprLine(hospCd));
			res.put("hosp", svc.selectHospInfo(hospCd));
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	@RequestMapping(value = "/qps/cmplRptSave.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> cmplRptSave(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			String inYear = str(p.get("inYear"), "");
			if (inYear.length() != 4) return fail(res, "년도가 필요합니다.");
			Map<String, Object> m = new HashMap<>();
			m.put("hospCd", hospCd);
			m.put("inYear", inYear);
			m.put("halfGb",      str(p.get("halfGb"), "1"));
			m.put("submitDt",    str(p.get("submitDt"), ""));
			m.put("goalVal",     str(p.get("goalVal"), ""));
			m.put("strategyTxt", str(p.get("strategyTxt"), ""));
			m.put("conclTxt",    str(p.get("conclTxt"), ""));
			m.put("imprTxt",     str(p.get("imprTxt"), ""));
			m.put("regUser",     userId(request));
			svc.saveCmplRpt(m);
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	/* ═══ 만족도 개선활동 결과보고서 (만족도 사이클 #6) ═══
	   원본 (원무)(원무2)(간호)(영양) 4종은 같은 서식이고 <부서 × 유형> 조합만 다르다. */
	@RequestMapping(value = "main/qpsSrvImpr.do")
	public String qpsSrvImpr(HttpServletRequest request, ModelMap model) { return qpsScreen(request, model, ".main/qpsSrvImpr"); }

	@RequestMapping(value = "/qps/srvImprList.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> srvImprList(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		res.put("build", BUILD);
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			String inYear = str(p.get("inYear"), "");
			if (inYear.length() != 4) return fail(res, "년도가 필요합니다.");
			res.put("list", svc.selectSrvImprList(hospCd, inYear));
			res.put("line", svc.selectApprLine(hospCd));   // 인쇄물 결재란(빈칸) — 종이 결재와 같은 모양
			res.put("hosp", svc.selectHospInfo(hospCd));
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	@RequestMapping(value = "/qps/srvImprGet.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> srvImprGet(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			Long seq = longOf(p.get("imprSeq"));
			if (seq == null || seq <= 0) return fail(res, "보고서를 선택해 주세요.");
			res.putAll(svc.selectSrvImprWithItems(hospCd, seq));
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	@RequestMapping(value = "/qps/srvImprSave.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> srvImprSave(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			String inYear = str(p.get("inYear"), "");
			if (inYear.length() != 4) return fail(res, "년도가 필요합니다.");
			if (str(p.get("deptNm"), "").isEmpty()) return fail(res, "부서명을 입력해 주세요.");

			Map<String, Object> m = new HashMap<>();
			m.put("hospCd", hospCd);
			m.put("imprSeq",  str(p.get("imprSeq"), ""));
			m.put("inYear",   inYear);
			m.put("deptNm",   str(p.get("deptNm"), ""));
			// ★유형은 코드 고정이 아니다 — 비어 있어도 저장한다((영양) 버전이 그렇다).
			m.put("typeNm",   str(p.get("typeNm"), ""));
			m.put("topic",    str(p.get("topic"), ""));
			m.put("problem",  str(p.get("problem"), ""));
			m.put("analysis", str(p.get("analysis"), ""));
			m.put("planTxt",  str(p.get("planTxt"), ""));
			m.put("imprDt",   str(p.get("imprDt"), ""));
			m.put("rptDt",    str(p.get("rptDt"), ""));
			m.put("regUser",  userId(request));
			res.put("imprSeq", svc.saveSrvImpr(m, jsonRows(p.get("items"))));
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	@RequestMapping(value = "/qps/srvImprDelete.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> srvImprDelete(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			Map<String, Object> m = new HashMap<>();
			m.put("hospCd", hospCd);
			m.put("imprSeq", longOf(p.get("imprSeq")));
			m.put("regUser", userId(request));
			svc.deleteSrvImpr(m);
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	/* ═══ 감염관리 전담자 (임명장·자격경력·직무기술서 한 벌) ═══ */
	@RequestMapping(value = "main/qpsInfStaff.do")
	public String qpsInfStaff(HttpServletRequest request, ModelMap model) { return qpsScreen(request, model, ".main/qpsInfStaff"); }

	/* ═══ 환자만족도 조사 — 설문 ═══ */
	@RequestMapping(value = "main/qpsSurvey.do")
	public String qpsSurvey(HttpServletRequest request, ModelMap model) { return qpsScreen(request, model, ".main/qpsSurvey"); }

	/** 화면 초기 로드 : 문항표 + 회차 목록 */
	@RequestMapping(value = "/qps/surveyBase.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> surveyBase(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		res.put("build", BUILD);
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			res.putAll(svc.selectSurveyBase(hospCd, str(p.get("inYear"), "")));
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	/** 회차 1건 + 응답 목록 */
	@RequestMapping(value = "/qps/surveyGet.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> surveyGet(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			Map<String, Object> q = new HashMap<>(p);
			q.put("hospCd", hospCd);
			res.putAll(svc.selectSurveyOne(q));
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	/** 회차 저장 */
	@RequestMapping(value = "/qps/surveySave.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> surveySave(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			Map<String, Object> q = new HashMap<>(p);
			q.put("hospCd", hospCd);
			q.put("regUser", hospCd);
			q.put("updUser", hospCd);
			if (str(q.get("seq"), "").isEmpty()) q.put("seq", 1);
			res.put("surveyId", svc.saveSurvey(q));
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	/** 응답 1건 저장 — 문항점수는 items(JSON)로 함께 온다 */
	@RequestMapping(value = "/qps/surveyAnsSave.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> surveyAnsSave(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			Map<String, Object> q = new HashMap<>(p);
			q.put("hospCd", hospCd);
			q.put("regUser", hospCd);
			res.put("ansId", svc.saveSurveyAns(q, jsonRows(p.get("items"))));
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	/** 응답 1건 조회(문항점수) */
	@RequestMapping(value = "/qps/surveyAnsGet.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> surveyAnsGet(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			long ansId = Long.parseLong(str(p.get("ansId"), "0"));
			res.put("items", svc.selectSurveyAnsItem(ansId));
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	/** 응답 삭제 */
	@RequestMapping(value = "/qps/surveyAnsDelete.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> surveyAnsDelete(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			Map<String, Object> q = new HashMap<>(p);
			q.put("hospCd", hospCd);
			svc.deleteSurveyAns(q);
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	/** 집계 — 조사결과·지표분석 보고서가 쓰는 수치 일체 */
	@RequestMapping(value = "/qps/surveyStat.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> surveyStat(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			Map<String, Object> q = new HashMap<>(p);
			q.put("hospCd", hospCd);
			res.putAll(svc.selectSurveyStat(q));
			res.put("def", svc.selectSurveyBase(hospCd, "").get("def"));
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	@RequestMapping(value = "/qps/infStaffList.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> infStaffList(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			res.put("list", svc.selectInfStaffList(hospCd));
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	@RequestMapping(value = "/qps/infStaffGet.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> infStaffGet(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			Long seq = longOf(p.get("stfSeq"));
			if (seq == null || seq <= 0) return fail(res, "전담자를 선택해 주세요.");
			res.putAll(svc.selectInfStaffAll(hospCd, seq));
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	@RequestMapping(value = "/qps/infStaffSave.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> infStaffSave(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			if (str(p.get("stfNm"), "").isEmpty()) return fail(res, "성명을 입력해 주세요.");
			Map<String, Object> m = new HashMap<>();
			m.put("hospCd", hospCd);
			m.put("stfSeq", str(p.get("stfSeq"), ""));
			m.put("regUser", userId(request));
			String[] cols = {"stfNm","deptNm","position","apptDt","jobKind","careerTxt","joinDt","rankNm",
			                 "deptDt","dutyDt","writeDt","eduLevel","majorTxt","licenseTxt","careerReq"};
			for (String c : cols) m.put(c, str(p.get(c), ""));
			res.put("stfSeq", svc.saveInfStaff(m, jsonRows(p.get("edus")), jsonRows(p.get("duties"))));
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	@RequestMapping(value = "/qps/infStaffDelete.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> infStaffDelete(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			Map<String, Object> m = new HashMap<>();
			m.put("hospCd", hospCd); m.put("stfSeq", longOf(p.get("stfSeq"))); m.put("regUser", userId(request));
			svc.deleteInfStaff(m);
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	/** QPS 화면 진입 공통 — 로그인 확인 + 병원명 배지. 화면마다 같은 코드를 반복하지 않는다. */
	/**
	 * 서식구분 딥링크 — 계획서·회의록·라운딩은 화면이 하나이고 FORM_GB 로만 갈린다.
	 * 감염 메뉴에서 들어오면 <b>구분이 처음부터 감염(I)으로 잡혀 있어야</b> 한다.
	 * 안 그러면 감염관리계획서를 눌렀는데 질향상 계획서가 열린다.
	 *
	 * ★주소 숨김이 location.search 를 지우므로 화면이 쿼리를 직접 읽을 수 없다 —
	 *   서버가 모델로 내려준다(지표 기간 딥링크 prdKey 와 같은 방식).
	 */
	private void putFormGb(HttpServletRequest request, ModelMap model) {
		String gb = request.getParameter("gb");
		gb = (gb == null) ? "" : gb.trim().toUpperCase();
		// 아는 값만 통과시킨다 — 엉뚱한 값이 들어오면 저장 키가 오염된다.
		// I=감염관리 · S=만족도 · C=불만고충 · J=QI 활동 · R=RCA · F=FMEA (뒤 셋은 회의록에서만 쓴다)
		if (!"I".equals(gb) && !"S".equals(gb) && !"C".equals(gb)
		 && !"J".equals(gb) && !"R".equals(gb) && !"F".equals(gb)) gb = "Q";
		model.addAttribute("formGb", gb);
	}

	private String qpsScreen(HttpServletRequest request, ModelMap model, String view) {
		Map<String, String> ck = ClientInfo.getCookie(request);
		try {
			String hospId = ck.get("s_hospid") == null ? "" : ck.get("s_hospid").trim();
			if (hospId.isEmpty()) return ".login/LoginWinCT";
			model.addAttribute("hospCd", hospId);
			model.addAttribute("wnnYn", ck.get("s_wnn_yn") == null ? "N" : ck.get("s_wnn_yn").trim());
			try {
				Map<String, Object> h = svc.selectHospInfo(hospId);
				model.addAttribute("hospNm", h == null || h.get("hospnm") == null ? "" : String.valueOf(h.get("hospnm")));
			} catch (Exception ignore) { model.addAttribute("hospNm", ""); }
			return view;
		} catch (Exception ex) { return ".login/LoginWinCT"; }
	}

	/** 화면이 JSON 으로 보낸 행 목록 → List<Map>. 비어 있으면 빈 목록. */
	private java.util.List<Map<String, Object>> jsonRows(Object o) throws Exception {
		String json = str(o, "");
		if (json.isEmpty()) return new java.util.ArrayList<>();
		// ★XSS 필터가 파라미터의 따옴표를 &quot; 로 바꿔 보낸다. 그대로 파싱하면
		//   Unexpected character ('&') 로 깨진다. 파싱 전에 되돌린다.
		if (json.indexOf("&quot;") >= 0 || json.indexOf("&#34;") >= 0 || json.indexOf("&amp;") >= 0) {
			json = json.replace("&quot;", "\"").replace("&#34;", "\"")
			           .replace("&lt;", "<").replace("&gt;", ">")
			           .replace("&#39;", "'").replace("&amp;", "&");
		}
		com.fasterxml.jackson.databind.ObjectMapper om = new com.fasterxml.jackson.databind.ObjectMapper();
		return om.readValue(json,
			new com.fasterxml.jackson.core.type.TypeReference<java.util.List<Map<String, Object>>>(){});
	}

	/** 지표정의서 조회 — 병원 행이 없으면 공통 기본값(own='N')을 준다. */
	@RequestMapping(value = "/qps/indiDefGet.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> indiDefGet(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			String indiCd = str(p.get("indiCd"), "");
			if (indiCd.isEmpty()) return fail(res, "지표가 필요합니다.");
			res.put("def",  svc.selectIndiDef(hospCd, indiCd));
			res.put("hosp", svc.selectHospInfo(hospCd));
			res.put("line", svc.selectApprLine(hospCd));   // 정의서 인쇄물의 결재란(빈칸)에 쓴다
			res.put("list", svc.selectIndiList(hospCd, str(p.get("inYear"), "2026")));  // 지표 고르는 셀렉트
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	/** 지표정의서 저장 — 항상 그 병원 행에 쓴다(공통값은 안 바뀐다). */
	@RequestMapping(value = "/qps/indiDefSave.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> indiDefSave(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			String indiCd = str(p.get("indiCd"), "");
			if (indiCd.isEmpty()) return fail(res, "지표가 필요합니다.");
			// ★공통 기본값('*')은 화면에서 못 고치게 막는다 — 한 병원의 수정이 전 병원에 번지면 안 된다.
			if ("*".equals(hospCd)) return fail(res, "공통 기본값은 화면에서 수정할 수 없습니다.");

			Map<String, Object> m = new HashMap<>();
			m.put("hospCd", hospCd);
			m.put("indiCd", indiCd);
			m.put("indiNm",     str(p.get("indiNm"), ""));
			m.put("definition", str(p.get("definition"), ""));
			m.put("numerDesc",  str(p.get("numerDesc"), ""));
			m.put("denomDesc",  str(p.get("denomDesc"), ""));
			m.put("sourceNm",   str(p.get("sourceNm"), ""));
			m.put("methodNm",   str(p.get("methodNm"), ""));
			m.put("ownerNm",    str(p.get("ownerNm"), ""));
			m.put("deptNm",     str(p.get("deptNm"), ""));
			m.put("background", str(p.get("background"), ""));
			m.put("includeTxt", str(p.get("includeTxt"), ""));
			m.put("excludeTxt", str(p.get("excludeTxt"), ""));
			m.put("targetVal",  decOf(p.get("targetVal")));
			m.put("prevVal",    decOf(p.get("prevVal")));
			m.put("targetBase", str(p.get("targetBase"), ""));
			m.put("rptCycle",   str(p.get("rptCycle"), ""));
			m.put("rptScope",   str(p.get("rptScope"), ""));
			m.put("shareTxt",   str(p.get("shareTxt"), ""));
			m.put("note",       str(p.get("note"), ""));
			m.put("regUser",    userId(request));

			if (String.valueOf(m.get("indiNm")).isEmpty()) return fail(res, "지표명은 필수입니다.");
			svc.saveIndiDef(m);
			res.put("def", svc.selectIndiDef(hospCd, indiCd));
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	/** 병원 정의서 되돌리기 — 병원 행을 지우면 공통 기본값으로 돌아간다. */
	@RequestMapping(value = "/qps/indiDefReset.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> indiDefReset(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			String indiCd = str(p.get("indiCd"), "");
			if (indiCd.isEmpty()) return fail(res, "지표가 필요합니다.");
			svc.deleteIndiDef(hospCd, indiCd);
			res.put("def", svc.selectIndiDef(hospCd, indiCd));
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	/** 지표 현황 목록(JSON) — 영역별 지표 + 그 해의 입력 자료 유무. */
	@RequestMapping(value = "/qps/indiList.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> indiList(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			String inYear = str(p.get("inYear"), "");
			if (inYear.length() != 4) return fail(res, "년도가 필요합니다.");
			res.put("list", svc.selectIndiList(hospCd, inYear));
			res.put("hosp", svc.selectHospInfo(hospCd));
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	/** 공통코드 목록 — 화면 selectbox(위해등급·유형·직군 등). 세트별로 묶어 돌려준다. */
	@RequestMapping(value = "/qps/codeList.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> codeList(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		res.put("build", BUILD);
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			Map<String, java.util.List<Map<String, Object>>> byCd = new java.util.LinkedHashMap<>();
			java.util.List<Map<String, Object>> rows = svc.selectQpsCodes();
			if (rows != null) for (Map<String, Object> r : rows) {
				String cd = String.valueOf(r.get("codecd"));
				byCd.computeIfAbsent(cd, k -> new java.util.ArrayList<>()).add(r);
			}
			res.put("codes", byCd);
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
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
			// ★분모 가드 — 화면(JS)에도 같은 검사가 있지만 서버에서 한 번 더 막는다.
			//   수행 > 관찰이면 수행률이 100% 를 넘어 지표가 깨진다(분기 합산까지 오염된다).
			//   intOf 는 빈 값이면 null 을 준다 — 언박싱 전에 0 으로 바꿔 놓는다(NPE 방지).
			int obsN  = (dto.getObsCnt()  == null) ? 0 : dto.getObsCnt().intValue();
			int passN = (dto.getPassCnt() == null) ? 0 : dto.getPassCnt().intValue();
			if (obsN <= 0)     return fail(res, "관찰건수(분모)는 1 이상이어야 합니다.");
			if (passN > obsN)  return fail(res, "수행건수(" + passN + ")가 관찰건수(" + obsN + ")보다 많습니다.");
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

	// ===================== 수기입력형(MANUAL) 월별 값 =====================

	/** 분자·분모를 한 번에 돌려준다 — 화면이 두 줄(분자/분모) 그리드를 그린다. */
	@RequestMapping(value = "/qps/manualGet.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> manualGet(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			String indiCd = str(p.get("indiCd"), "");
			String inYear = str(p.get("inYear"), "");
			if (indiCd.isEmpty() || inYear.length() != 4) return fail(res, "지표와 년도가 필요합니다.");
			res.put("numer", svc.selectManual(hospCd, indiCd, inYear, "NUMER", ""));
			res.put("denom", svc.selectManual(hospCd, indiCd, inYear, "DENOM", ""));
			res.put("axes",  svc.selectManualAxes(hospCd, indiCd, inYear));   // 정규/응급 상세(있으면)
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	@RequestMapping(value = "/qps/manualSave.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> manualSave(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");

			QpsManualDTO dto = new QpsManualDTO();
			dto.setHospCd(hospCd);
			dto.setIndiCd(str(p.get("indiCd"), ""));
			dto.setInYear(str(p.get("inYear"), ""));
			// 분자/분모를 한 번의 저장으로 처리한다 — 화면에서 두 줄을 같이 고치기 때문
			String valGb = str(p.get("valGb"), "NUMER");
			if (!"DENOM".equals(valGb)) valGb = "NUMER";
			dto.setValGb(valGb);
			dto.setAxisCd(str(p.get("axisCd"), ""));   // '' = 총계, '정규'/'응급' = 상세
			dto.setM01(intOf(p.get("m01"))); dto.setM02(intOf(p.get("m02")));
			dto.setM03(intOf(p.get("m03"))); dto.setM04(intOf(p.get("m04")));
			dto.setM05(intOf(p.get("m05"))); dto.setM06(intOf(p.get("m06")));
			dto.setM07(intOf(p.get("m07"))); dto.setM08(intOf(p.get("m08")));
			dto.setM09(intOf(p.get("m09"))); dto.setM10(intOf(p.get("m10")));
			dto.setM11(intOf(p.get("m11"))); dto.setM12(intOf(p.get("m12")));
			dto.setRegUser(userId(request));
			dto.setUpdUser(userId(request));

			if (dto.getIndiCd().isEmpty() || dto.getInYear().length() != 4)
				return fail(res, "지표와 년도가 필요합니다.");
			svc.saveManual(dto);
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
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
			// ★수치를 계산한 '그 병원'을 함께 돌려준다 — 화면 배지와 인쇄물의 병원명이 여기서 온다.
			//   화면이 로드 시점 병원명을 붙들고 있으면, 상단 [병원검색]으로 바꾼 뒤 새로고침 없이 인쇄할 때
			//   숫자는 새 병원인데 이름은 옛 병원으로 찍힌다(제출물이 틀어진다).
			res.put("hosp", svc.selectHospInfo(hospCd));

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
			} else if ("PATVAL".equals(numerSrc) || "MANUAL".equals(numerSrc)) {
				// 사고 행이 없는 원천 — 분류 축이 성립하지 않는다(화면도 카드를 감춘다)
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

			// ★결재가 시작된 문서는 서술을 못 고친다 — 결재자가 본 내용과 최종본이 달라지면 안 된다.
			//   작성중(DRAFT)·반려(REJECT)일 때만 수정 가능. 상태 자체는 결재 API 만 바꾼다.
			Map<String, Object> cur = svc.selectReport(hospCd, String.valueOf(m.get("indiCd")),
					String.valueOf(m.get("prdGb")), String.valueOf(m.get("prdKey")));
			String st = (cur == null || cur.get("status") == null) ? "DRAFT" : String.valueOf(cur.get("status")).trim();
			if ("SUBMIT".equals(st))  return fail(res, "결재 상신 중인 문서는 수정할 수 없습니다. 상신을 회수한 뒤 수정해 주세요.");
			if ("CONFIRM".equals(st)) return fail(res, "최종 승인된 문서는 수정할 수 없습니다.");

			svc.saveReport(m);
			res.put("result", "OK");
		} catch (Exception ex) {
			fail(res, ex.getMessage());
		}
		return res;
	}

	// ===================== 결재 =====================

	/** 결재 상태 + 결재선 + 이력 — 화면이 한 번의 호출로 결재 영역을 그린다. */
	@RequestMapping(value = "/qps/apprGet.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> apprGet(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			res.putAll(svc.selectApprState(hospCd, str(p.get("indiCd"), "FALL"),
					str(p.get("prdGb"), "Q"), str(p.get("prdKey"), "")));
			res.put("me", userId(request));
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	/** 결재 처리 — SUBMIT(상신)/APPROVE(승인)/REJECT(반려)/CANCEL(회수). */
	@RequestMapping(value = "/qps/apprAct.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> apprAct(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			String prdKey = str(p.get("prdKey"), "");
			if (prdKey.isEmpty()) return fail(res, "기간이 필요합니다.");

			Map<String, Object> m = new HashMap<>();
			m.put("hospCd", hospCd);
			m.put("indiCd", str(p.get("indiCd"), "FALL"));
			m.put("prdGb",  str(p.get("prdGb"), "Q"));
			m.put("prdKey", prdKey);
			m.put("actGb",  str(p.get("actGb"), ""));
			m.put("stepNo", intOf(p.get("stepNo")));
			m.put("note",   str(p.get("note"), ""));
			m.put("actUser", userId(request));
			// 이력에 남길 이름 — 쿠키의 사용자명(없으면 아이디). 나중에 결재란에 그대로 찍힌다.
			m.put("actNm", userNm(request));
			res.putAll(svc.actAppr(m));
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	/** 결재선 설정 — 단계 이름을 순서대로 받아 통째로 교체(단계 수를 줄이면 뒤 단계가 사라진다). */
	@RequestMapping(value = "/qps/apprLineSave.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> apprLineSave(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			java.util.List<String> steps = new java.util.ArrayList<>();
			for (int i = 1; i <= 10; i++) {
				String nm = str(p.get("step" + i), "");
				if (!nm.isEmpty()) steps.add(nm);
			}
			if (steps.isEmpty()) return fail(res, "결재 단계를 1개 이상 입력해 주세요.");
			res.put("saved", svc.saveApprLine(hospCd, steps, userId(request)));
			res.put("line", svc.selectApprLine(hospCd));
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	// ===================== 공통 =====================

	/** 결재란에 찍을 이름 — 사용자명 쿠키가 없으면 아이디로 대체한다. */
	private String userNm(HttpServletRequest request) {
		try {
			Map<String, String> ck = ClientInfo.getCookie(request);
			String n = cookieDecode(ck.get("s_usernm"));
			if (n != null && !n.trim().isEmpty()) return n.trim();
		} catch (Exception ignore) { }
		return userId(request);
	}

	/**
	 * 쿠키 한글 복원 — 로그인 화면이 `escape()`(비표준, %uB9C8 형태)로 저장한 값이라
	 * URLDecoder 로는 안 풀린다('마스터'가 결재란에 %uB9C8%uC2A4%uD130 으로 찍혔다, 2026-08-09).
	 * %uXXXX 와 표준 %XX 를 모두 처리한다.
	 */
	private static String cookieDecode(String s) {
		if (s == null || s.indexOf('%') < 0) return s;
		StringBuilder sb = new StringBuilder(s.length());
		for (int i = 0; i < s.length(); ) {
			char c = s.charAt(i);
			try {
				if (c == '%' && i + 5 < s.length() && (s.charAt(i + 1) == 'u' || s.charAt(i + 1) == 'U')) {
					sb.append((char) Integer.parseInt(s.substring(i + 2, i + 6), 16));
					i += 6; continue;
				}
				if (c == '%' && i + 2 < s.length()) {
					// 연속된 %XX 를 모아 UTF-8 로 푼다(한 바이트씩 char 로 만들면 한글이 깨진다)
					int j = i;
					java.io.ByteArrayOutputStream bos = new java.io.ByteArrayOutputStream();
					while (j + 2 < s.length() && s.charAt(j) == '%' && s.charAt(j + 1) != 'u' && s.charAt(j + 1) != 'U') {
						bos.write(Integer.parseInt(s.substring(j + 1, j + 3), 16));
						j += 3;
					}
					if (bos.size() > 0) {
						sb.append(new String(bos.toByteArray(), java.nio.charset.StandardCharsets.UTF_8));
						i = j; continue;
					}
				}
			} catch (Exception badSeq) { /* 형식이 아니면 글자 그대로 둔다 */ }
			sb.append(c);
			i++;
		}
		return sb.toString();
	}

	// ===================== 공통 첨부 (회의록·계획서·라운딩·자료실 공용) =====================

	/** 첨부 목록 — refGb(문서종류) + refKey(문서키) 로 조회. */
	@RequestMapping(value = "/qps/fileList.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> fileList(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			res.put("list", svc.selectQpsFileList(hospCd, str(p.get("refGb"), ""), str(p.get("refKey"), "")));
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	/**
	 * 첨부 업로드(멀티파트) — SFTP 전송 후 TBL_QPS_FILE 에 메타 저장.
	 * 저장 경로 = QPS/{병원}/{문서종류}/{문서키}/ — 월보고서와 같은 파일서버, 폴더만 분리.
	 */
	@RequestMapping(value = "/qps/fileUpload.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> fileUpload(@RequestParam("file") MultipartFile[] files,
	                                      @RequestParam Map<String, Object> p,
	                                      HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			String refGb  = str(p.get("refGb"), "");
			String refKey = str(p.get("refKey"), "");
			if (refGb.isEmpty() || refKey.isEmpty()) return fail(res, "먼저 문서를 저장한 뒤 첨부해 주세요.");
			if (files == null || files.length == 0) return fail(res, "파일을 선택해 주세요.");
			// 자료실(규정·내규)만 담당자 제한. 서식(회의록·계획서·라운딩)은 실무 입력자가 쓰므로 그대로 둔다.
			if ("LIBRARY".equals(refGb) && !canEditLib(request, hospCd))
				return fail(res, "자료실에 파일을 올릴 권한이 없습니다. QPS 담당자에게 요청해 주세요.");

			String folder = "QPS/" + hospCd + "/" + refGb + "/" + refKey;
			int saved = 0;
			for (MultipartFile f : files) {
				if (f == null || f.isEmpty()) continue;
				String origNm = f.getOriginalFilename();
				// 파일서버에는 충돌 방지용 UUID 접두어로 저장하고, 화면 표시는 원본명(FILE_NM)으로 한다.
				String remoteNm = UUID.randomUUID() + "_" + origNm;
				java.io.File tmp = java.nio.file.Files.createTempFile("qpsatt_", ".bin").toFile();
				try {
					f.transferTo(tmp);
					String remotePath = sftpService.putFile(tmp.getAbsolutePath(), folder, remoteNm);
					if (remotePath == null) return fail(res, "파일서버 전송에 실패했습니다: " + origNm);
					egovframework.wnn_medcost.qps.model.QpsFileDTO dto = new egovframework.wnn_medcost.qps.model.QpsFileDTO();
					dto.setHospCd(hospCd);
					dto.setRefGb(refGb);
					dto.setRefKey(refKey);
					dto.setFileNm(origNm);
					dto.setFilePath(remotePath);
					dto.setFileSize(f.getSize());
					dto.setRegUser(userId(request));
					svc.insertQpsFile(dto);
					saved++;
				} finally {
					if (tmp.exists()) tmp.delete();
				}
			}
			res.put("saved", saved);
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	/** 첨부 삭제(소프트) — 본인 병원 것만. 파일 실체는 파일서버에 남긴다. */
	@RequestMapping(value = "/qps/fileDelete.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> fileDelete(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			Long seq = longOf(p.get("fileSeq"));
			// 어느 문서의 첨부인지 먼저 확인한다 — 자료실(규정·내규)이면 담당자만 지울 수 있다.
			Map<String, Object> one = svc.selectQpsFileOne(seq, hospCd);
			if (one == null) return fail(res, "이미 삭제되었거나 없는 파일입니다.");
			if ("LIBRARY".equals(String.valueOf(one.get("refgb"))) && !canEditLib(request, hospCd))
				return fail(res, "자료실 파일을 지울 권한이 없습니다. QPS 담당자에게 요청해 주세요.");
			egovframework.wnn_medcost.qps.model.QpsFileDTO dto = new egovframework.wnn_medcost.qps.model.QpsFileDTO();
			dto.setHospCd(hospCd);
			dto.setFileSeq(seq);
			dto.setUpdUser(userId(request));
			svc.deleteQpsFile(dto);
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

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

	/** 목표값·이전값처럼 소수가 들어오는 칸 — 빈 값이면 null(‘미입력’과 0 을 구분한다). */
	private static java.math.BigDecimal decOf(Object o) {
		if (o == null) return null;
		String s = String.valueOf(o).trim().replace(",", "").replace("%", "").replace("‰", "");
		if (s.isEmpty()) return null;
		try { return new java.math.BigDecimal(s); } catch (Exception e) { return null; }
	}

	private static Long longOf(Object o) {
		if (o == null) return null;
		String s = String.valueOf(o).trim();
		if (s.isEmpty()) return null;
		try { return Long.valueOf(s); } catch (Exception e) { return null; }
	}
}
