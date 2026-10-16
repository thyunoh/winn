package egovframework.wnn_medcost.mis.web;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
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
	private static final String BUILD = "20261016-DIR4";   // 원장 진단(DIR4 = 청구세부통계 Ⅷ 경영 진단·AI 코멘트 · 고객관리 예상 비용·음성·AI 정리 · 청구↔평가표 알림) · 청구세부통계 시작월~종료월(DIR3) · 원무 수입실적(REV1, 일별·월별·경영 보고서 탭) · 병원장 조회·원무 환자고객·간호사 관리(MGR1) · + 통합검색 v1(MIS11, 내규·안내문) · 안내문 저장(MIS10) · 병원 내규 조회·안내문 초안·결재 대기 알림(MIS9) · 병원자료엑셀연계 삭감 자료 — 샘파일 명세서와 매칭(MIS7 = 수납·행위별·연락처·입퇴원·인력, 머리글 맞춤 · 퇴원 안부에 보호자 연락처)

	@Resource(name = "MisService")
	private MisService svc;

	/* ═══ 화면 ═══ */
	@RequestMapping(value = "main/misStat.do")
	public String misStat(HttpServletRequest request, ModelMap model) { model.addAttribute("initTab", "stat"); return screen(request, model, ".main/mismgr/misReport"); }   // 2026-10-15 경영 보고서의 「경영통계」 탭으로 통합

	@RequestMapping(value = "main/misCost.do")
	public String misCost(HttpServletRequest request, ModelMap model) { model.addAttribute("initTab", "cost"); return screen(request, model, ".main/mismgr/misReport"); }   // 2026-10-15 경영 보고서의 「고정경비 관리」 탭으로 통합

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
			// 추이 기간: fromYm 이 있으면 fromYm~ym(최대 24달), 없으면 종료월 포함 12달(고정비 화면 기본)
			String fromYm = str(p.get("fromYm"), "").replaceAll("[^0-9]", "");
			if (fromYm.matches("\\d{6}")) {
				if (fromYm.compareTo(ym) > 0) fromYm = ym;
				if (addMonths(fromYm, 23).compareTo(ym) < 0) fromYm = addMonths(ym, -23);
				res.putAll(svc.selectCostPageRange(hospCd, fromYm, ym));
			} else {
				res.putAll(svc.selectCostPage(hospCd, ym));
			}
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


	@RequestMapping(value = "main/misDrug.do")
	public String misDrug(HttpServletRequest request, ModelMap model) { return screen(request, model, ".main/mismgr/misDrug"); }   // 2026-10-16 청구세부통계 Ⅶ 약처방을 별도 화면으로 분리 (청구분 · 정액분 · 합계)

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

	/** 상담 이력 한 줄 삭제 — 상담 기록(환자)은 그대로 두고 이력 한 줄만 지운다 */
	@RequestMapping(value = "/mis/leadLogDel.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> leadLogDel(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			Long seq = longOf(p.get("leadSeq")); if (seq == null) return fail(res, "상담 번호가 없습니다.");
			Long logSeq = longOf(p.get("logSeq")); if (logSeq == null) return fail(res, "이력 번호가 없습니다.");
			svc.deleteLeadLog(hospCd, seq, logSeq);
			res.put("logs", svc.selectLeadLogs(hospCd, seq));
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

	/* ═══ EMR 엑셀 연계 (2026-10-11) — 닥터스 EMR 과 연계가 안 돼 엑셀로 받아 올린다 ═══
	 * 자료 구분 PAY 수납·진료비 / ACT 행위별 통계(행위 분류별 횟수·금액) / CUT 삭감 내역(그 달 청구 샘파일 명세서와 매칭 — 청구는 샘파일이 있어 엑셀로 안 받는다) / CONTACT 환자·보호자 연락처 / IPWON 입퇴원현황 / STAFF 직원·근무.
	 * 머리글 ↔ 필드 맞춤은 화면이 하고(견본 양식 없음) 병원·자료별로 TBL_MIS_EMR_MAP 에 기억한다.
	 * IPWON 의 저장은 기존 /main/saveExcelDatas.do(TBL_IPWON_INFO)를 그대로 쓴다 — 여기서는 맞춤·이력만(emrIpwonLog). */
	private static final java.util.Set<String> EMR_GB = new java.util.HashSet<>(java.util.Arrays.asList("PAY", "ACT", "CUT", "CONTACT", "IPWON", "STAFF"));

	@RequestMapping(value = "main/misEmr.do")
	public String misEmr(HttpServletRequest request, ModelMap model) { return screen(request, model, ".main/mismgr/misEmr"); }

	@RequestMapping(value = "/mis/emrGet.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> emrGet(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			String ym = str(p.get("ym"), "").replaceAll("[^0-9]", "");
			if (!ym.matches("\\d{6}")) ym = addMonths(nowYm(), -1);
			res.putAll(svc.selectEmrPage(hospCd, ym));
			res.put("ym", ym);
			res.put("hospCd", hospCd);
			res.put("build", BUILD);
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	/** 올린 자료 보기 */
	@RequestMapping(value = "/mis/emrRows.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> emrRows(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			String gb = str(p.get("dataGb"), "").toUpperCase();
			if (!EMR_GB.contains(gb) || "IPWON".equals(gb)) return fail(res, "자료 구분이 잘못되었습니다.");
			String ym = str(p.get("ym"), "").replaceAll("[^0-9]", "");
			if (!"CONTACT".equals(gb) && !ym.matches("\\d{6}")) return fail(res, "연월이 잘못되었습니다.");
			res.put("list", svc.selectEmrRows(hospCd, gb, ym));
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	/** 머리글 맞춤만 저장(올리지 않고 맞춤을 기억해 두고 싶을 때) */
	@RequestMapping(value = "/mis/emrMapSave.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> emrMapSave(@RequestBody Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			String gb = str(p.get("dataGb"), "").toUpperCase();
			if (!EMR_GB.contains(gb)) return fail(res, "자료 구분이 잘못되었습니다.");
			String mapJson = mapJsonOf(p.get("map"));
			if (mapJson == null) return fail(res, "맞춤 내용이 잘못되었습니다.");
			svc.saveEmrMap(hospCd, gb, mapJson, hdrRowOf(p.get("hdrRow")), userId(request));
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	/** 저장 — PAY/STAFF 는 그 달 대체, CONTACT 는 병원 통째 대체. 맞춤도 같이 기억한다. 본문 JSON(@RequestBody) — 줄이 많아 폼 크기 한도를 피하고, XSS 필터도 안 탄다. */
	@RequestMapping(value = "/mis/emrSave.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> emrSave(@RequestBody Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			String gb = str(p.get("dataGb"), "").toUpperCase();
			if (!EMR_GB.contains(gb) || "IPWON".equals(gb)) return fail(res, "자료 구분이 잘못되었습니다.");
			String ym = str(p.get("ym"), "").replaceAll("[^0-9]", "");
			if (!"CONTACT".equals(gb) && !ym.matches("\\d{6}")) return fail(res, "연월이 잘못되었습니다.");
			Object ro = p.get("rows");
			if (!(ro instanceof List)) return fail(res, "올릴 줄이 없습니다.");
			List<?> in = (List<?>) ro;
			if (in.isEmpty()) return fail(res, "올릴 줄이 없습니다.");
			if (in.size() > 20000) return fail(res, "한 번에 20,000줄까지 올릴 수 있습니다(지금 " + in.size() + "줄).");
			List<Map<String, Object>> rows = new ArrayList<>();
			int seq = 0;
			for (Object o : in) {
				if (!(o instanceof Map)) continue;
				@SuppressWarnings("unchecked") Map<String, Object> r = (Map<String, Object>) o;
				Map<String, Object> m = "PAY".equals(gb) ? emrPayRow(r) : "ACT".equals(gb) ? emrActRow(r) : "CUT".equals(gb) ? emrCutRow(r) : "STAFF".equals(gb) ? emrStaffRow(r) : emrContactRow(r);
				if (m == null) continue;
				m.put("seq", ++seq);
				rows.add(m);
			}
			if (rows.isEmpty()) return fail(res, "저장할 줄이 없습니다 — 맞춘 칸에 값이 있는지 보세요.");
			Integer sk = intOf(p.get("skipCnt"));
			int skip = (sk == null ? 0 : sk) + (in.size() - rows.size());
			int del = svc.saveEmr(hospCd, gb, ym, rows, cut(str(p.get("fileNm"), ""), 200), skip, userId(request));
			String mapJson = mapJsonOf(p.get("map"));
			if (mapJson != null) svc.saveEmrMap(hospCd, gb, mapJson, hdrRowOf(p.get("hdrRow")), userId(request));
			res.put("saved", rows.size());
			res.put("deleted", del);
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	/** 입퇴원현황은 기존 업로드가 저장한 뒤 화면이 부른다 — 맞춤 기억 + 이력 한 줄 */
	@RequestMapping(value = "/mis/emrIpwonLog.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> emrIpwonLog(@RequestBody Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			String ym = str(p.get("ym"), "").replaceAll("[^0-9]", "");
			if (!ym.matches("\\d{6}")) return fail(res, "연월이 잘못되었습니다.");
			Integer rc = intOf(p.get("rowCnt")), sc = intOf(p.get("skipCnt"));
			svc.logEmrUpload(hospCd, "IPWON", ym, cut(str(p.get("fileNm"), ""), 200), rc == null ? 0 : rc, sc == null ? 0 : sc, userId(request));
			String mapJson = mapJsonOf(p.get("map"));
			if (mapJson != null) svc.saveEmrMap(hospCd, "IPWON", mapJson, hdrRowOf(p.get("hdrRow")), userId(request));
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	/* 줄 정리 — 화면이 맞춰 보낸 값을 칸 길이·형식에 맞춘다. 이름·차트번호가 다 비면 null(뺀다). */
	private static Map<String, Object> emrPayRow(Map<String, Object> r) {
		Map<String, Object> m = new HashMap<>();
		m.put("payDt", dt8(r.get("payDt")));
		m.put("chartno", cut(str(r.get("chartno"), ""), 30));
		m.put("patNm", cut(str(r.get("patNm"), ""), 50));
		m.put("birth6", birth6(r.get("birth6")));
		m.put("inoutGb", cut(str(r.get("inoutGb"), ""), 20));
		m.put("insurNm", cut(str(r.get("insurNm"), ""), 30));
		m.put("deptNm", cut(str(r.get("deptNm"), ""), 30));
		for (String k : new String[]{"totAmt", "insAmt", "selfAmt", "nonpayAmt", "paidAmt", "unpaidAmt"}) m.put(k, amtOf(r.get(k)));
		m.put("payMethod", cut(str(r.get("payMethod"), ""), 30));
		m.put("memo", cut(str(r.get("memo"), ""), 200));
		boolean who = !((String) m.get("chartno")).isEmpty() || !((String) m.get("patNm")).isEmpty();
		boolean amt = m.get("totAmt") != null || m.get("paidAmt") != null || m.get("selfAmt") != null || m.get("nonpayAmt") != null;
		return (who || amt) ? m : null;
	}
	/** 행위별 통계 — 한 줄 = 행위 분류 하나(수가코드·명칭은 받지 않는다 — 2026-10-11 사용자). 분류가 비면 뺀다(합계 줄은 화면이 먼저 거른다) */
	private static Map<String, Object> emrActRow(Map<String, Object> r) {
		Map<String, Object> m = new HashMap<>();
		m.put("actGb", cut(str(r.get("actGb"), ""), 50));
		m.put("payGb", cut(str(r.get("payGb"), ""), 20));
		m.put("inoutGb", cut(str(r.get("inoutGb"), ""), 20));
		m.put("deptNm", cut(str(r.get("deptNm"), ""), 30));
		m.put("unitPrice", amtOf(r.get("unitPrice")));
		m.put("actCnt", decOf(r.get("actCnt"), 999999999));
		m.put("patCnt", intOf(str(r.get("patCnt"), "").replaceAll("[^0-9-]", "")));
		m.put("totAmt", amtOf(r.get("totAmt")));
		m.put("insAmt", amtOf(r.get("insAmt")));
		m.put("selfAmt", amtOf(r.get("selfAmt")));
		m.put("memo", cut(str(r.get("memo"), ""), 200));
		return ((String) m.get("actGb")).isEmpty() ? null : m;
	}
	/** 삭감 내역 — 한 줄 = 종별 × 지급처 [× 청구번호] 의 삭감·불능·조정(환자 단위 아님 — SWCHMISU 와 같은 결). 삭감액이 없으면 뺀다 */
	private static Map<String, Object> emrCutRow(Map<String, Object> r) {
		Map<String, Object> m = new HashMap<>();
		m.put("claimNo", cut(str(r.get("claimNo"), ""), 30));
		m.put("resultDt", dt8(r.get("resultDt")));
		m.put("jongNm", cut(str(r.get("jongNm"), ""), 50));
		m.put("assCd", cut(str(r.get("assCd"), ""), 30));
		m.put("assNm", cut(str(r.get("assNm"), ""), 100));
		m.put("cutGb", cut(str(r.get("cutGb"), ""), 20));
		m.put("inoutGb", cut(str(r.get("inoutGb"), ""), 20));
		m.put("cutRsnCd", cut(str(r.get("cutRsnCd"), ""), 20));
		m.put("cutRsn", cut(str(r.get("cutRsn"), ""), 200));
		m.put("claimAmt", amtOf(r.get("claimAmt")));
		m.put("cutAmt", amtOf(r.get("cutAmt")));
		m.put("objGb", cut(str(r.get("objGb"), ""), 30));
		m.put("memo", cut(str(r.get("memo"), ""), 200));
		return m.get("cutAmt") == null ? null : m;
	}
	private static Map<String, Object> emrContactRow(Map<String, Object> r) {
		Map<String, Object> m = new HashMap<>();
		m.put("chartno", cut(str(r.get("chartno"), ""), 30));
		m.put("patNm", cut(str(r.get("patNm"), ""), 50));
		m.put("birth6", birth6(r.get("birth6")));
		m.put("gender", cut(str(r.get("gender"), ""), 5));
		m.put("tel", cut(str(r.get("tel"), ""), 30));
		m.put("guardNm", cut(str(r.get("guardNm"), ""), 50));
		m.put("guardRel", cut(str(r.get("guardRel"), ""), 20));
		m.put("guardTel", cut(str(r.get("guardTel"), ""), 30));
		m.put("addr", cut(str(r.get("addr"), ""), 200));
		m.put("memo", cut(str(r.get("memo"), ""), 200));
		return (((String) m.get("chartno")).isEmpty() && ((String) m.get("patNm")).isEmpty()) ? null : m;
	}
	private static Map<String, Object> emrStaffRow(Map<String, Object> r) {
		Map<String, Object> m = new HashMap<>();
		m.put("empNo", cut(str(r.get("empNo"), ""), 30));
		m.put("empNm", cut(str(r.get("empNm"), ""), 50));
		m.put("jobNm", cut(str(r.get("jobNm"), ""), 30));
		m.put("deptNm", cut(str(r.get("deptNm"), ""), 30));
		m.put("workGb", cut(str(r.get("workGb"), ""), 20));
		m.put("joinDt", dt8(r.get("joinDt")));
		m.put("retireDt", dt8(r.get("retireDt")));
		m.put("workDays", decOf(r.get("workDays"), 99999));
		m.put("workHours", decOf(r.get("workHours"), 999999));
		m.put("nightCnt", decOf(r.get("nightCnt"), 9999));
		m.put("payAmt", amtOf(r.get("payAmt")));
		m.put("memo", cut(str(r.get("memo"), ""), 200));
		return (((String) m.get("empNo")).isEmpty() && ((String) m.get("empNm")).isEmpty()) ? null : m;
	}
	/** 금액 — 콤마·원·공백을 떼고 정수(소수는 반올림). 음수(환불)는 그대로. 숫자가 아니면 null */
	private static Long amtOf(Object o) {
		String s = str(o, "").replaceAll("[,\\s원₩]", "");
		if (s.isEmpty() || !s.matches("-?\\d+(\\.\\d+)?")) return null;
		try { long v = Math.round(Double.parseDouble(s)); return Math.abs(v) > 999999999999L ? null : v; } catch (Exception e) { return null; }
	}
	private static java.math.BigDecimal decOf(Object o, double max) {
		String s = str(o, "").replaceAll("[,\\s]", "");
		if (s.isEmpty() || !s.matches("-?\\d+(\\.\\d+)?")) return null;
		try { java.math.BigDecimal d = new java.math.BigDecimal(s).setScale(1, java.math.RoundingMode.HALF_UP); return Math.abs(d.doubleValue()) > max ? null : d; } catch (Exception e) { return null; }
	}
	/** 생년월일 6자리 — 주민번호·생년월일(1950-03-01, 500301-1…) 어느 꼴이든 앞 6자리. 8자리 생년월일(19500301)은 뒤 6자리 */
	private static String birth6(Object o) {
		String raw = str(o, "");
		String d = raw.replaceAll("[^0-9]", "");
		java.util.regex.Matcher mm = java.util.regex.Pattern.compile("^\\s*((?:19|20)\\d{2})[-./](\\d{1,2})[-./](\\d{1,2})").matcher(raw);
		if (mm.find()) return mm.group(1).substring(2) + (mm.group(2).length() == 1 ? "0" : "") + mm.group(2) + (mm.group(3).length() == 1 ? "0" : "") + mm.group(3);
		if (d.length() == 8 && d.matches("(19|20)\\d{6}")) return d.substring(2);
		return d.length() >= 6 ? d.substring(0, 6) : "";
	}
	private static String mapJsonOf(Object o) {
		if (o == null) return null;
		try {
			String json = o instanceof String ? (String) o : new com.fasterxml.jackson.databind.ObjectMapper().writeValueAsString(o);
			return json.length() > 20000 ? null : json;
		} catch (Exception e) { return null; }
	}
	private static Integer hdrRowOf(Object o) { Integer v = intOf(o); return (v == null || v < 1 || v > 50) ? null : v; }

	private static String nowDt() { return new java.text.SimpleDateFormat("yyyyMMdd").format(new java.util.Date()); }
	private static String dt8(Object o) { String s = str(o, "").replaceAll("[^0-9]", ""); return s.matches("\\d{8}") ? s : ""; }
	private static String cut(String s, int n) { if (s == null) return ""; s = s.trim(); return s.length() > n ? s.substring(0, n) : s; }

	/* ═══ 병원 내규 · 안내문 (2026-10-12) ═══ */
	@RequestMapping(value = "main/misRule.do")
	public String misRule(HttpServletRequest request, ModelMap model) { return screen(request, model, ".main/mismgr/misRule"); }

	@RequestMapping(value = "/mis/ruleList.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> ruleList(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			res.put("list", svc.ruleList(hospCd));
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	@RequestMapping(value = "/mis/ruleSave.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> ruleSave(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			String title = cut(unesc(p.get("title")), 200);
			if (title.isEmpty()) return fail(res, "내규 이름을 적어 주세요.");
			String body = unesc(p.get("body"));
			if (body.length() > 20000) return fail(res, "본문이 너무 깁니다(2만 자 이내). 나눠서 등록해 주세요.");
			long seq = 0;
			try { seq = Long.parseLong(str(p.get("ruleSeq"), "0")); } catch (NumberFormatException e) { seq = 0; }
			String uid = str(ClientInfo.getCookie(request).get("s_userid"), "");
			res.put("ruleSeq", svc.ruleSave(hospCd, seq, title, body, uid));
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	@RequestMapping(value = "/mis/ruleDel.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> ruleDel(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			long seq = 0;
			try { seq = Long.parseLong(str(p.get("ruleSeq"), "0")); } catch (NumberFormatException e) { seq = 0; }
			String uid = str(ClientInfo.getCookie(request).get("s_userid"), "");
			if (svc.ruleDel(hospCd, seq, uid) == 0) return fail(res, "지울 내규를 찾지 못했습니다.");
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	@RequestMapping(value = "/mis/ruleAsk.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> ruleAsk(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			res.putAll(svc.ruleAsk(hospCd, unesc(p.get("q"))));
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	@RequestMapping(value = "/mis/leafletDraft.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> leafletDraft(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			String audience = cut(unesc(p.get("audience")), 30);
			String topic = cut(unesc(p.get("topic")), 60);
			String note = cut(unesc(p.get("note")), 500);
			if (audience.isEmpty() || topic.isEmpty()) return fail(res, "대상과 주제를 골라 주세요.");
			res.putAll(svc.leafletDraft(audience, topic, note));
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	/* ═══ 안내문 저장 (2026-10-13) ═══ */
	private static long seqOf(Object o) { try { return Long.parseLong(str(o, "0")); } catch (NumberFormatException e) { return 0; } }

	@RequestMapping(value = "/mis/leafList.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> leafList(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			res.put("list", svc.leafletList(hospCd));
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	@RequestMapping(value = "/mis/leafGet.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> leafGet(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			Map<String, Object> leaf = svc.leafletGet(hospCd, seqOf(p.get("leafSeq")));
			if (leaf == null) return fail(res, "안내문을 찾지 못했습니다.");
			res.put("leaf", leaf);
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	@RequestMapping(value = "/mis/leafSave.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> leafSave(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			String title = cut(unesc(p.get("title")), 200);
			if (title.isEmpty()) return fail(res, "저장 이름을 적어 주세요.");
			String body = unesc(p.get("body"));
			if (body.trim().isEmpty()) return fail(res, "저장할 글이 없습니다.");
			if (body.length() > 20000) return fail(res, "글이 너무 깁니다(2만 자 이내).");
			String audience = cut(unesc(p.get("audience")), 30);
			String topic = cut(unesc(p.get("topic")), 60);
			String uid = str(ClientInfo.getCookie(request).get("s_userid"), "");
			res.put("leafSeq", svc.leafletSave(hospCd, seqOf(p.get("leafSeq")), title, audience, topic, body, uid));
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	@RequestMapping(value = "/mis/leafDel.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> leafDel(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			String uid = str(ClientInfo.getCookie(request).get("s_userid"), "");
			if (svc.leafletDel(hospCd, seqOf(p.get("leafSeq")), uid) == 0) return fail(res, "지울 안내문을 찾지 못했습니다.");
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	/* ═══ 통합검색 v1 (2026-10-13) ═══ */
	@RequestMapping(value = "/mis/searchAll.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> searchAll(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			res.putAll(svc.searchAll(hospCd, unesc(p.get("q"))));
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

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

	/* ═══ 효사랑가족요양병원 AI 사례 적용 · 원장 진단 (2026-10-16) ═══ */
	/** 입원 상담 예상 비용 재료 — 환자군별 1인 1일 진료비(최근 청구 3달). */
	@RequestMapping(value = "/mis/classCost.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> classCost(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			res.putAll(svc.classCost(hospCd));
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	/** 상담 메모 AI 정리 — kind=log(이력 한 줄)/cond(상태·요구). 실패해도 FAIL 이 아니라 ok=false(화면은 적은 글을 그대로 둔다). */
	@RequestMapping(value = "/mis/aiSummary.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> aiSummary(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			String kind = "cond".equals(str(p.get("kind"), "")) ? "cond" : "log";
			res.putAll(svc.aiSummary(kind, cut(unesc(p.get("text")), 2000)));
			res.put("result", "OK");
		} catch (Exception ex) { res.put("ok", false); res.put("reason", ex.getMessage()); res.put("result", "OK"); }
		return res;
	}

	/** 원장 진단 재료 — 청구세부통계 「Ⅷ 경영 진단」(환자군별 수익성·고객 병원 대비·돈이 새는 곳). 기간은 directorGet 과 같은 규칙. */
	@RequestMapping(value = "/mis/dirExtra.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> dirExtra(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			String toYm = str(p.get("toYm"), "").replaceAll("[^0-9]", "");
			String fromYm = str(p.get("fromYm"), "").replaceAll("[^0-9]", "");
			if (toYm.matches("\\d{6}")) {
				if (!fromYm.matches("\\d{6}")) fromYm = addMonths(toYm, -5);
				else if (fromYm.compareTo(toYm) > 0) fromYm = toYm;
				if (addMonths(fromYm, 23).compareTo(toYm) < 0) fromYm = addMonths(toYm, -23);
			}
			res.putAll(svc.selectDirectorExtra(hospCd, fromYm, toYm));
			res.put("hospCd", hospCd);
			res.put("build", BUILD);
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	/** 원장 AI 경영 코멘트 — 화면이 만든 사실 목록을 받아 다섯 줄. 실패는 ok=false. */
	@RequestMapping(value = "/mis/dirComment.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> dirComment(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			res.putAll(svc.dirComment(cut(unesc(p.get("hospNm")), 60), cut(unesc(p.get("period")), 60), cut(unesc(p.get("facts")), 3000)));
			res.put("result", "OK");
		} catch (Exception ex) { res.put("ok", false); res.put("reason", ex.getMessage()); res.put("result", "OK"); }
		return res;
	}

	/* ═══ 병원장 조회 · 원무 환자고객 · 간호사 관리 (2026-10-15) ═══ */
	@RequestMapping(value = "main/misDirector.do")
	public String misDirector(HttpServletRequest request, ModelMap model) { model.addAttribute("initTab", "dir"); return screen(request, model, ".main/mismgr/misReport"); }   // 2026-10-15 경영 보고서의 「병원장 보고」 탭으로 통합

	@RequestMapping(value = "main/misPatient.do")
	public String misPatient(HttpServletRequest request, ModelMap model) { return screen(request, model, ".main/mismgr/misPatient"); }

	@RequestMapping(value = "main/misNurse.do")
	public String misNurse(HttpServletRequest request, ModelMap model) { return screen(request, model, ".main/mismgr/misNurse"); }

	/** 병원장 한 장 — 청구·상담·재원·간호 인력·챙길 일을 한 번에. */
	@RequestMapping(value = "/mis/directorGet.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> directorGet(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			// 기간: 종료월(toYm, 없으면 ym) · 시작월(fromYm). 시작이 비었거나 뒤면 종료월 한 달, 최대 24달.
			String toYm = str(p.get("toYm"), "").replaceAll("[^0-9]", "");
			if (toYm.isEmpty()) toYm = str(p.get("ym"), "").replaceAll("[^0-9]", "");
			String fromYm = str(p.get("fromYm"), "").replaceAll("[^0-9]", "");
			if (toYm.matches("\\d{6}")) {
				// 시작월을 안 주면 종료월 포함 최근 6개월(2026-10-15) — 주었는데 종료월보다 뒤면 종료월 한 달
				if (!fromYm.matches("\\d{6}")) fromYm = addMonths(toYm, -5);
				else if (fromYm.compareTo(toYm) > 0) fromYm = toYm;
				if (addMonths(fromYm, 23).compareTo(toYm) < 0) fromYm = addMonths(toYm, -23);
			}
			res.putAll(svc.selectDirectorBoard(hospCd, wnnYn(request), fromYm, toYm));
			res.put("hospCd", hospCd);
			res.put("build", BUILD);
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	/** 원무 환자고객 — 재원 환자 목록과 요약. */
	@RequestMapping(value = "/mis/patList.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> patList(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			res.putAll(svc.selectPatBoard(hospCd));
			res.put("hospCd", hospCd);
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	/** 간호사 관리 — 직원 명단 · 변동 기록 · 인력 판정. */
	@RequestMapping(value = "/mis/nurseGet.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> nurseGet(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			res.putAll(svc.selectNurseBoard(hospCd));
			res.put("hospCd", hospCd);
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	/** 인력 변동 기록 저장(입사·퇴사·이동). 변동일·성명·구분은 필수. */
	@RequestMapping(value = "/mis/nurseSave.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> nurseSave(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			String chgDt = dt8(p.get("chgDt"));
			if (chgDt.isEmpty()) return fail(res, "변동일을 적어 주세요.");
			String staffNm = cut(unesc(p.get("staffNm")), 50);
			if (staffNm.isEmpty()) return fail(res, "성명을 적어 주세요.");
			String chgGb = str(p.get("chgGb"), "").toUpperCase();
			if (!chgGb.matches("IN|OUT|MOVE")) return fail(res, "구분(입사·퇴사·이동)을 고르세요.");
			Map<String, Object> m = new HashMap<>();
			m.put("hospCd", hospCd);
			m.put("chgDt", chgDt);
			m.put("staffNm", staffNm);
			m.put("jobNm", cut(unesc(p.get("jobNm")), 30));
			m.put("wardNm", cut(unesc(p.get("wardNm")), 30));
			m.put("chgGb", chgGb);
			m.put("memo", cut(unesc(p.get("memo")), 200));
			m.put("userId", userId(request));
			res.put("chgSeq", svc.saveStaffChg(m));
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	/** 인력 변동 기록 지우기 — 기록은 남기고 표식만 바꾼다(USE_YN='N'). */
	@RequestMapping(value = "/mis/nurseDel.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> nurseDel(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			long seq;
			try { seq = Long.parseLong(str(p.get("chgSeq"), "").trim()); }
			catch (Exception e) { return fail(res, "지울 기록을 찾지 못했습니다."); }
			if (svc.deleteStaffChg(hospCd, seq, userId(request)) == 0) return fail(res, "지울 기록이 없습니다.");
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	/* ═══ 원무 수입실적 (2026-10-15) — 경영고객관리 › 원무 수입실적 (일별·월별·경영 보고서 탭) ═══ */
	@RequestMapping(value = "main/misRevenue.do")
	public String misRevenue(HttpServletRequest request, ModelMap model) { model.addAttribute("initTab", "rev"); return screen(request, model, ".main/mismgr/misReport"); }   // 2026-10-15 경영 보고서의 「수입 일보」 탭으로 통합

	/** 원무 수입실적 — 수납대장 행. 기간을 안 주면 최근 12개월. */
	@RequestMapping(value = "/mis/revGet.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> revGet(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			String toYm = str(p.get("toYm"), "").replaceAll("[^0-9]", "");
			if (!toYm.matches("\\d{6}")) toYm = nowYm();
			String fromYm = str(p.get("fromYm"), "").replaceAll("[^0-9]", "");
			if (!fromYm.matches("\\d{6}") || fromYm.compareTo(toYm) > 0) fromYm = addMonths(toYm, -11);
			if (addMonths(fromYm, 23).compareTo(toYm) < 0) fromYm = addMonths(toYm, -23);   // 최대 24개월
			res.putAll(svc.selectRevenue(hospCd, fromYm, toYm));
			res.put("hospCd", hospCd);
			res.put("build", BUILD);
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}

	/* ═══ 경영 보고서 (2026-10-15) — 경영고객관리 › 경영 보고서 ═══ */
	@RequestMapping(value = "main/misReport.do")
	public String misReport(HttpServletRequest request, ModelMap model) { return screen(request, model, ".main/mismgr/misReport"); }

	/** 경영 보고서 한 장 — 청구월(없으면 가장 최근 청구월)의 자료와 전월 자료. */
	@RequestMapping(value = "/mis/reportGet.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> reportGet(@RequestParam Map<String, Object> p, HttpServletRequest request) {
		Map<String, Object> res = new HashMap<>();
		try {
			String hospCd = hospCd(request, p);
			if (hospCd.isEmpty()) return fail(res, "로그인이 필요합니다.");
			String ym = str(p.get("ym"), "").replaceAll("[^0-9]", "");
			if (!ym.matches("\\d{6}")) {
				String last = svc.selectLastClaimYm(hospCd);
				ym = (last == null || !last.matches("\\d{6}")) ? "" : last;
			}
			if (ym.isEmpty()) return fail(res, "청구 자료가 없습니다. 청구 샘파일을 올리면 보고서가 만들어집니다.");
			res.putAll(svc.selectReport(hospCd, ym));
			res.put("hospCd", hospCd);
			res.put("build", BUILD);
			res.put("result", "OK");
		} catch (Exception ex) { fail(res, ex.getMessage()); }
		return res;
	}
}
