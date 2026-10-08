package egovframework.wnn_medcost.mis.web;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
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
import egovframework.wnn_medcost.mis.service.MisService;

/**
 * MIS(경영관리) — 경영통계 · 고정경비 (2026-10-08, 신규 요양병원 업무 패키지 1단계).
 *
 * ★노출 방침 : QPS 와 같다 — 사이드바 메뉴는 기본 숨김이고 위너넷(s_wnn_yn='Y')이 입력칸 밖에서 m·i·s 를 치면 열린다.
 *   숨김은 화면 편의일 뿐이라 서버는 로그인(s_hospid)을 직접 본다. 병원은 로그인 쿠키의 병원만, 위너넷은 hospCd 파라미터로 다른 병원을 본다.
 * ★숫자는 저장하지 않고 집계한다(경영통계). 병원이 적는 것은 설정·항목·월 금액뿐.
 */
@Controller
public class MisController {

	/** 배포 확인용 표식 — 코드를 고칠 때마다 올린다(statGet 응답의 build). */
	private static final String BUILD = "20261008-MIS6";   // + 계약 구분 'M' 으로 병원에 메뉴·화면 열기(menuChk · screen 가드)

	@Resource(name = "MisService")
	private MisService svc;

	/* ═══ 화면 ═══ */
	@RequestMapping(value = "main/misStat.do")
	public String misStat(HttpServletRequest request, ModelMap model) { return screen(request, model, ".main/mismgr/misStat"); }

	@RequestMapping(value = "main/misCost.do")
	public String misCost(HttpServletRequest request, ModelMap model) { return screen(request, model, ".main/mismgr/misCost"); }

	private String screen(HttpServletRequest request, ModelMap model, String view) {
		Map<String, String> ck = ClientInfo.getCookie(request);
		try {
			String hospId = ck.get("s_hospid") == null ? "" : ck.get("s_hospid").trim();
			if (hospId.isEmpty()) return ".login/LoginWinCT";
			String wnnYn = ck.get("s_wnn_yn") == null ? "N" : ck.get("s_wnn_yn").trim();
			// 병원 계정은 MIS 계약(계약 구분 'M')이 있어야 연다(2026-10-08 「계약 구분에 MIS 추가」). 위너넷은 어느 병원이든 본다. 쿠키가 아니라 DB 로 본다(위조 불가).
			if (!"Y".equals(wnnYn) && !svc.hasMisContract(hospId)) return "redirect:/user/dashboard.do";
			model.addAttribute("hospCd", hospId);
			model.addAttribute("wnnYn", wnnYn);
			try {
				Map<String, Object> h = svc.selectHospInfo(hospId);
				model.addAttribute("hospNm", h == null || h.get("hospnm") == null ? "" : String.valueOf(h.get("hospnm")));
			} catch (Exception ignore) { model.addAttribute("hospNm", ""); }
			// 카톡 공유(업무 알림) — konet 발주서와 같은 kakao.properties. 키가 비면 화면이 링크 복사로 물러선다.
			model.addAttribute("kakaoJsKey", kakaoProp("kakao.js.key"));
			model.addAttribute("shareBase", shareBase(request));
			return view;
		} catch (Exception ex) { return ".login/LoginWinCT"; }
	}

	/** 사이드바가 묻는다 — 지금 보는 병원에 MIS 메뉴를 보일지. 병원 계정 = MIS 계약 여부, 위너넷 = 계약이 있으면 Y(없어도 m·i·s 토글은 따로 된다). */
	@RequestMapping(value = "/mis/menuChk.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> menuChk(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			Map<String, String> ck = ClientInfo.getCookie(request);
			String hospId = ck.get("s_hospid") == null ? "" : ck.get("s_hospid").trim();
			res.put("hospCd", hospId);
			res.put("misYn", !hospId.isEmpty() && svc.hasMisContract(hospId) ? "Y" : "N");
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	/* ═══ 경영통계 ═══ */
	/** 기간 집계 — fromYm~toYm(YYYYMM). 비면 자료가 있는 마지막 달까지 6달. */
	@RequestMapping(value = "/mis/statGet.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> statGet(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			String toYm = str(p.get("toYm"), "").replaceAll("[^0-9]", "");
			if (!toYm.matches("\\d{6}")) {
				String last = svc.selectLastClaimYm(hospCd);
				toYm = (last == null || !last.matches("\\d{6}")) ? nowYm() : last;
			}
			String fromYm = str(p.get("fromYm"), "").replaceAll("[^0-9]", "");
			if (!fromYm.matches("\\d{6}") || fromYm.compareTo(toYm) > 0) fromYm = addMonths(toYm, -5);
			if (addMonths(fromYm, 23).compareTo(toYm) < 0) fromYm = addMonths(toYm, -23);   // 최대 24달
			res.putAll(svc.selectStat(hospCd, fromYm, toYm));
			res.put("fromYm", fromYm);
			res.put("toYm", toYm);
			res.put("hospCd", hospCd);
			res.put("build", BUILD);
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	/* ═══ 고정경비 ═══ */
	@RequestMapping(value = "/mis/costGet.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> costGet(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			String ym = str(p.get("ym"), "").replaceAll("[^0-9]", "");
			if (!ym.matches("\\d{6}")) {
				String last = svc.selectLastClaimYm(hospCd);
				ym = (last == null || !last.matches("\\d{6}")) ? nowYm() : last;
			}
			res.putAll(svc.selectCostPage(hospCd, ym));
			res.put("ym", ym);
			res.put("hospCd", hospCd);
			res.put("build", BUILD);
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	/** 병원 설정 저장 — 병상 수·변동비(원/일). 빈 값은 NULL(= 기본값 사용). */
	@RequestMapping(value = "/mis/cfgSave.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> cfgSave(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			Integer bed = intOf(p.get("bedCnt")), var = intOf(p.get("varCostDay"));
			if (bed != null && (bed < 0 || bed > 5000)) return fail(res, "병상 수가 범위를 벗어났습니다(0~5000).");
			if (var != null && (var < 0 || var > 10000000)) return fail(res, "변동비가 범위를 벗어났습니다.");
			Map<String, Object> m = new HashMap<>();
			m.put("hospCd", hospCd); m.put("bedCnt", bed); m.put("varCostDay", var);
			String note = unesc(p.get("note")).trim();
			m.put("note", note.length() > 200 ? note.substring(0, 200) : note);
			m.put("userId", userId(request));
			svc.saveCfg(m);
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	/** 항목 저장 — 새 항목(병원 전용) 또는 공통 항목의 이름·사용 여부 덮기(병원 전용 사본). */
	@RequestMapping(value = "/mis/catSave.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> catSave(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			String catCd = str(p.get("catCd"), "").trim().toUpperCase().replaceAll("[^A-Z0-9_]", "");
			if (catCd.isEmpty() || catCd.length() > 20) return fail(res, "항목 코드는 영문·숫자 1~20자입니다.");
			String catNm = unesc(p.get("catNm")).trim();
			if (catNm.isEmpty()) return fail(res, "항목 이름을 적어 주세요.");
			if (catNm.length() > 60) catNm = catNm.substring(0, 60);
			String gb = "R".equals(str(p.get("catGb"), "C")) ? "R" : "C";
			Integer sort = intOf(p.get("sortNo"));
			Map<String, Object> m = new HashMap<>();
			m.put("hospCd", hospCd); m.put("catCd", catCd); m.put("catNm", catNm); m.put("catGb", gb);
			m.put("sortNo", sort == null ? 50 : sort);
			m.put("useYn", "N".equals(str(p.get("useYn"), "Y")) ? "N" : "Y");
			m.put("userId", userId(request));
			svc.saveCat(m);
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	@RequestMapping(value = "/mis/catDel.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> catDel(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			String catCd = str(p.get("catCd"), "").trim().toUpperCase();
			if (catCd.isEmpty()) return fail(res, "항목 코드가 없습니다.");
			int n = svc.deleteCat(hospCd, catCd);
			if (n < 0) return fail(res, "이 항목에 입력한 금액이 있어 지울 수 없습니다. 「사용」을 끄세요.");
			if (n == 0) return fail(res, "공통 항목은 지우지 못합니다. 「사용」을 끄거나 이름을 바꾸세요.");
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	/** 한 달 금액 저장 — rows = JSON [{catCd, amt, memo}]. 0원 행도 저장한다(「이 달은 없음」을 적은 것). */
	@RequestMapping(value = "/mis/costSave.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> costSave(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			String ym = str(p.get("ym"), "").replaceAll("[^0-9]", "");
			if (!ym.matches("\\d{6}")) return fail(res, "연월이 잘못되었습니다.");
			List<Map<String, Object>> in = jsonRows(p.get("rows"));
			List<Map<String, Object>> rows = new ArrayList<>();
			for (Map<String, Object> r : in) {
				String catCd = str(r.get("catCd"), "").trim().toUpperCase();
				if (catCd.isEmpty()) continue;
				Long amt = longOf(r.get("amt"));
				if (amt == null) continue;                        // 빈 칸은 「입력 안 함」 — 저장하지 않는다
				if (amt < 0 || amt > 999999999999L) return fail(res, "금액이 범위를 벗어났습니다 : " + catCd);
				String memo = unesc(r.get("memo")).trim();
				Map<String, Object> m = new HashMap<>();
				m.put("catCd", catCd); m.put("amt", amt);
				m.put("memo", memo.length() > 200 ? memo.substring(0, 200) : memo);
				rows.add(m);
			}
			svc.saveCostMonth(hospCd, ym, rows, userId(request));
			res.put("saved", rows.size());
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}


	/* ═══ 업무 알림(③ 업무 자동화) ═══ */
	@RequestMapping(value = "main/misAlert.do")
	public String misAlert(HttpServletRequest request, ModelMap model) { return screen(request, model, ".main/mismgr/misAlert"); }

	@RequestMapping(value = "/mis/alertGet.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> alertGet(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			Map<String, String> ck = ClientInfo.getCookie(request);
			String wnn = ck.get("s_wnn_yn") == null ? "N" : ck.get("s_wnn_yn").trim();
			res.put("alerts", svc.selectAlerts(hospCd, wnn));
			res.put("hospCd", hospCd);
			res.put("build", BUILD);
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	/** 인력 시뮬레이션 재료 — 계산은 화면이 한다(숫자를 바꾸며 바로 보게). */
	@RequestMapping(value = "/mis/simGet.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> simGet(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			res.putAll(svc.selectSim(hospCd));
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}


	/* ═══ ③-2 문자·메일 알림 (2026-10-08) ═══ */
	@RequestMapping(value = "/mis/notiBoard.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> notiBoard(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			res.putAll(svc.selectNotiBoard(hospCd));
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	@RequestMapping(value = "/mis/notiUserSave.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> notiUserSave(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			String name = cut(unesc(p.get("name")), 50), email = cut(str(p.get("email"), ""), 100), tel = cut(str(p.get("tel"), ""), 30);
			if (name.isEmpty()) return fail(res, "이름을 적어 주세요.");
			String mailYn = "Y".equals(str(p.get("mailYn"), "N")) ? "Y" : "N", smsYn = "Y".equals(str(p.get("smsYn"), "N")) ? "Y" : "N";
			if ("Y".equals(mailYn) && !email.matches("[^@\\s]+@[^@\\s]+\\.[^@\\s]+")) return fail(res, "메일 주소 형식이 맞지 않습니다: " + email);
			if ("Y".equals(smsYn) && tel.replaceAll("[^0-9]", "").length() < 9) return fail(res, "휴대폰 번호를 확인해 주세요: " + tel);
			if (!"Y".equals(mailYn) && !"Y".equals(smsYn)) return fail(res, "메일·문자 중 하나는 켜야 합니다.");
			String autoGb = str(p.get("autoGb"), "W"); if (!autoGb.matches("[DWN]")) autoGb = "W";
			Map<String, Object> m = new HashMap<>();
			m.put("hospCd", hospCd); m.put("notiSeq", longOf(p.get("notiSeq")));
			m.put("name", name); m.put("roleNm", cut(unesc(p.get("roleNm")), 50)); m.put("email", email); m.put("tel", tel);
			m.put("mailYn", mailYn); m.put("smsYn", smsYn); m.put("autoGb", autoGb);
			m.put("minLevel", "bad".equals(str(p.get("minLevel"), "warn")) ? "bad" : "warn");
			m.put("useYn", "N".equals(str(p.get("useYn"), "Y")) ? "N" : "Y");
			m.put("userId", userId(request));
			res.put("notiSeq", svc.saveNotiUser(m));
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	@RequestMapping(value = "/mis/notiUserDel.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> notiUserDel(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			Long seq = longOf(p.get("notiSeq"));
			if (seq == null) return fail(res, "대상이 없습니다.");
			svc.deleteNotiUser(hospCd, seq);
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	/** 보낼 내용 미리보기(보내지 않음) */
	@RequestMapping(value = "/mis/notiPreview.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> notiPreview(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			res.putAll(svc.previewNoti(hospCd, wnnYn(request)));
			res.remove("items");
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	/** 지금 보내기 — notiSeq 가 있으면 그 사람만, testTo 가 있으면 그 주소로 메일 1통(시험) */
	@RequestMapping(value = "/mis/notiSend.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> notiSend(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			String testTo = str(p.get("testTo"), "");
			if (!testTo.isEmpty() && !testTo.matches("[^@\\s]+@[^@\\s]+\\.[^@\\s]+")) return fail(res, "시험 발송 주소 형식이 맞지 않습니다.");
			java.util.Set<Long> seqs = seqsOf(p.get("seqs"));                       // 체크한 받는 사람(JSON 배열) — 없으면 전부
			if (testTo.isEmpty() && seqs != null && seqs.isEmpty()) return fail(res, "보낼 사람을 체크해 주세요.");
			List<Map<String, Object>> rows = svc.sendNoti(hospCd, wnnYn(request), userId(request), seqs, testTo);
			int ok = 0, failN = 0, skip = 0;
			for (Map<String, Object> r : rows) { String s = String.valueOf(r.get("result")); if ("OK".equals(s)) ok++; else if ("FAIL".equals(s)) failN++; else skip++; }
			res.put("rows", rows); res.put("ok", ok); res.put("fail", failN); res.put("skip", skip);
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	/** 카톡 공유·링크 복사도 이력에 남긴다(채널 KAKAO/LINK) — 보낸 것은 서버가 아니라 사람의 카톡이지만 「언제 누가 공유했나」는 같은 표에서 본다. */
	@RequestMapping(value = "/mis/notiShareLog.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> notiShareLog(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			String ch = "LINK".equals(str(p.get("channel"), "")) ? "LINK" : "KAKAO";
			svc.logNotiShare(hospCd, ch, cut(unesc(p.get("subject")), 200), cut(unesc(p.get("body")), 2000), "FAIL".equals(str(p.get("result"), "OK")) ? "FAIL" : "OK", cut(unesc(p.get("errMsg")), 500), userId(request));
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	/** kakao.properties(UTF-8) — 톰캣 -D 옵션이 있으면 그것이 우선(konet 과 같은 규칙) */
	private static String kakaoProp(String key) {
		try { String v = System.getProperty(key); if (v != null && !v.trim().isEmpty()) return v.trim(); } catch (Exception ignore) { }
		try (java.io.InputStream in = MisController.class.getClassLoader().getResourceAsStream("kakao.properties")) {
			if (in == null) return "";
			java.util.Properties p = new java.util.Properties();
			p.load(new java.io.InputStreamReader(in, java.nio.charset.StandardCharsets.UTF_8));
			String v = p.getProperty(key);
			return v == null ? "" : v.trim();
		} catch (Exception e) { return ""; }
	}
	private static String shareBase(HttpServletRequest request) {
		String b = kakaoProp("share.base.url");
		if (!b.isEmpty()) return b.replaceAll("/+$", "");
		int port = request.getServerPort();
		boolean std = ("http".equals(request.getScheme()) && port == 80) || ("https".equals(request.getScheme()) && port == 443);
		return request.getScheme() + "://" + request.getServerName() + (std ? "" : ":" + port) + request.getContextPath();
	}

	/** 화면에서 체크한 받는 사람 번호들(JSON 배열) → Set. 파라미터가 없으면 null(= 전부), 빈 배열이면 빈 Set. ★@RequestParam JSON 은 unesc 뒤 파싱(CLAUDE.md 규칙). */
	private static java.util.Set<Long> seqsOf(Object o) {
		String json = unesc(str(o, ""));
		if (json.isEmpty()) return null;
		java.util.Set<Long> s = new java.util.LinkedHashSet<>();
		try {
			com.fasterxml.jackson.databind.ObjectMapper om = new com.fasterxml.jackson.databind.ObjectMapper();
			for (Object x : om.readValue(json, new com.fasterxml.jackson.core.type.TypeReference<List<Object>>(){})) { Long v = longOf(x); if (v != null) s.add(v); }
		} catch (Exception e) { return null; }
		return s;
	}

	private String wnnYn(HttpServletRequest request) {
		try { Map<String, String> ck = ClientInfo.getCookie(request); return ck.get("s_wnn_yn") == null ? "N" : ck.get("s_wnn_yn").trim(); } catch (Exception e) { return "N"; }
	}

	/* ═══ ④ 신규환자 고객관리 ═══ */
	@RequestMapping(value = "main/misLead.do")
	public String misLead(HttpServletRequest request, ModelMap model) { return screen(request, model, ".main/mismgr/misLead"); }

	/** 관리판 — 상담 목록(단계별) + 유입 경로 집계. 열 때마다 입퇴원현황과 대조해 입원·퇴원을 자동 반영한다. */
	@RequestMapping(value = "/mis/leadList.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> leadList(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			res.putAll(svc.selectLeadBoard(hospCd));
			res.put("hospCd", hospCd);
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	/** 상담 저장(새로/고치기). 주민번호 전체는 받지 않는다 — 생년월일 6자리만. */
	@RequestMapping(value = "/mis/leadSave.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> leadSave(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			String patNm = unesc(p.get("patNm")).trim().replaceAll("\\s+", "");
			if (patNm.isEmpty()) return fail(res, "환자 이름을 적어 주세요.");
			if (patNm.length() > 50) patNm = patNm.substring(0, 50);
			String birth6 = str(p.get("birth6"), "").replaceAll("[^0-9]", "");
			if (!birth6.isEmpty() && !birth6.matches("\\d{6}")) return fail(res, "생년월일은 6자리(YYMMDD)입니다.");
			String contactDt = str(p.get("contactDt"), "").replaceAll("[^0-9]", "");
			if (!contactDt.matches("\\d{8}")) contactDt = nowDt();
			String stage = str(p.get("stage"), "10");
			if (!stage.matches("10|20|30|40|50|90")) stage = "10";
			String channel = str(p.get("channel"), "ETC").toUpperCase();
			if (!channel.matches("INTRO|TRANS|WEB|ADS|ETC")) channel = "ETC";
			Map<String, Object> m = new HashMap<>();
			m.put("hospCd", hospCd); m.put("leadSeq", str(p.get("leadSeq"), ""));
			m.put("patNm", patNm); m.put("birth6", birth6);
			String g = str(p.get("gender"), "").toUpperCase(); m.put("gender", g.matches("M|F") ? g : null);
			m.put("guardNm", cut(unesc(p.get("guardNm")), 50)); m.put("guardRel", cut(unesc(p.get("guardRel")), 20)); m.put("tel", cut(unesc(p.get("tel")), 30));
			m.put("contactDt", contactDt); m.put("channel", channel); m.put("condMemo", cut(unesc(p.get("condMemo")), 300)); m.put("stage", stage);
			m.put("planDt", dt8(p.get("planDt"))); m.put("nextDt", dt8(p.get("nextDt"))); m.put("nextMemo", cut(unesc(p.get("nextMemo")), 200));
			m.put("admitDt", dt8(p.get("admitDt"))); m.put("dischDt", dt8(p.get("dischDt"))); m.put("closeRsn", cut(unesc(p.get("closeRsn")), 100));
			m.put("userId", userId(request));
			res.put("leadSeq", svc.saveLead(m));
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	/** 단계 옮기기(상담→방문→입원결정→입원→퇴원후, 종결). 이력에 남는다. */
	@RequestMapping(value = "/mis/leadStage.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> leadStage(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			Long seq = longOf(p.get("leadSeq")); if (seq == null) return fail(res, "상담 번호가 없습니다.");
			String stage = str(p.get("stage"), ""); if (!stage.matches("10|20|30|40|50|90")) return fail(res, "단계 값이 잘못되었습니다.");
			svc.moveLead(hospCd, seq, stage, cut(unesc(p.get("closeRsn")), 100), cut(unesc(p.get("memo")), 500), userId(request));
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	@RequestMapping(value = "/mis/leadLog.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> leadLog(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			Long seq = longOf(p.get("leadSeq")); if (seq == null) return fail(res, "상담 번호가 없습니다.");
			String memo = cut(unesc(p.get("memo")), 500);
			if (!memo.isEmpty()) svc.addLeadLog(hospCd, seq, memo, userId(request));
			res.put("logs", svc.selectLeadLogs(hospCd, seq));
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	@RequestMapping(value = "/mis/leadDel.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> leadDel(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			Long seq = longOf(p.get("leadSeq")); if (seq == null) return fail(res, "상담 번호가 없습니다.");
			svc.deleteLead(hospCd, seq, userId(request));
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	/** 퇴원 환자 안부 연락 목록 — 최근 days 일(기본 60) */
	@RequestMapping(value = "/mis/followList.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> followList(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			Integer days = intOf(p.get("days")); if (days == null || days < 7 || days > 365) days = 60;
			res.put("list", svc.selectFollowList(hospCd, days));
			res.put("days", days);
			res.put("today", nowDt());
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	@RequestMapping(value = "/mis/followSave.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> followSave(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			String b = str(p.get("birth6"), "").replaceAll("[^0-9]", ""), ip = dt8(p.get("ipwonDt")), tw = dt8(p.get("tewonDt"));
			if (!b.matches("\\d{6}") || ip.isEmpty() || tw.isEmpty()) return fail(res, "퇴원 건 키(생년월일·입원일·퇴원일)가 없습니다.");
			String done = "Y".equals(str(p.get("doneYn"), "N")) ? "Y" : "N";
			String rc = str(p.get("resultCd"), "").toUpperCase(); if (!rc.matches("HOME|READMIT|OTHER|NOANS|ETC")) rc = "";
			Map<String, Object> m = new HashMap<>();
			m.put("hospCd", hospCd); m.put("birth6", b); m.put("ipwonDt", ip); m.put("tewonDt", tw);
			m.put("doneYn", done); m.put("doneDt", "Y".equals(done) ? nowDt() : null); m.put("resultCd", rc.isEmpty() ? null : rc);
			m.put("memo", cut(unesc(p.get("memo")), 300)); m.put("userId", userId(request));
			svc.saveFollow(m);
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	private static String nowDt() { return new java.text.SimpleDateFormat("yyyyMMdd").format(new java.util.Date()); }
	private static String dt8(Object o) { String s = str(o, "").replaceAll("[^0-9]", ""); return s.matches("\\d{8}") ? s : ""; }
	private static String cut(String s, int n) { if (s == null) return ""; s = s.trim(); return s.length() > n ? s.substring(0, n) : s; }

	/* ═══ 공통 ═══ */
	/** 병원 — 로그인 쿠키. 위너넷(s_wnn_yn=Y)만 hospCd 파라미터로 다른 병원을 본다(QPS 와 같은 규칙). */
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
		String s = String.valueOf(o).trim().replace(",", "");
		if (s.isEmpty()) return null;
		try { return Long.valueOf(s); } catch (Exception e) { return null; }
	}

	/** XSS 필터가 바꾼 실체참조를 되돌린다 — 저장은 원본, 출력은 화면이 esc() 한다(QPS 와 같은 규칙). */
	private static String unesc(Object o) {
		String s = str(o, "");
		if (s.isEmpty() || s.indexOf('&') < 0) return s;
		return s.replace("&quot;", "\"").replace("&#34;", "\"")
		        .replace("&lt;", "<").replace("&gt;", ">")
		        .replace("&#39;", "'").replace("&amp;", "&");   // &amp; 는 반드시 마지막
	}

	/** 화면이 JSON 으로 보낸 행 목록 → List of Map. ★@RequestParam 으로 받은 JSON 은 반드시 되돌린 뒤 파싱(CLAUDE.md 규칙). */
	private List<Map<String, Object>> jsonRows(Object o) throws Exception {
		String json = str(o, "");
		if (json.isEmpty()) return new ArrayList<>();
		json = unesc(json);
		com.fasterxml.jackson.databind.ObjectMapper om = new com.fasterxml.jackson.databind.ObjectMapper();
		return om.readValue(json, new com.fasterxml.jackson.core.type.TypeReference<List<Map<String, Object>>>(){});
	}

	private static String nowYm() {
		return new java.text.SimpleDateFormat("yyyyMM").format(new java.util.Date());
	}

	private static String addMonths(String ym, int n) {
		int y = Integer.parseInt(ym.substring(0, 4)), m = Integer.parseInt(ym.substring(4, 6)) - 1 + n;
		y += Math.floorDiv(m, 12);
		m = Math.floorMod(m, 12);
		return String.format("%04d%02d", y, m + 1);
	}
}
