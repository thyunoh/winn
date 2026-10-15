package egovframework.wnn_medcost.mis.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.wnn_medcost.mis.mapper.MisMapper;
import egovframework.wnn_medcost.mis.service.MisService;

/**
 * MIS(경영관리) 서비스 — 경영통계 · 고정경비 (2026-10-08).
 *
 * ★경영통계 수치는 저장하지 않는다. 청구·평가표·입퇴원 자료에서 그때그때 집계한다(QPS 와 같은 사상).
 *   손익분기 같은 계산은 화면(JS)이 한다 — 가정값(변동비)을 사용자가 바꾸며 바로 보게 하기 위해서다.
 * ★이 앱은 tx:annotation-driven 이 없어 @Transactional 이 동작하지 않는다(CLAUDE.md 6-1).
 *   saveCostMonth 의 「지우고 다시 넣기」는 context-transaction.xml 의 pointcut 으로 묶는다(misCostTx).
 */
@Service("MisService")
public class MisServiceImpl implements MisService {

	@Resource(name = "MisMapper")
	private MisMapper mapper;

	@Override
	public Map<String, Object> selectHospInfo(String hospCd) throws Exception { return mapper.selectHospInfo(hospCd); }

	@Override
	public Map<String, Object> selectStat(String hospCd, String fromYm, String toYm) throws Exception {
		Map<String, Object> r = new HashMap<>();
		r.put("months",  mapper.selectMonthClaim(hospCd, fromYm, toYm));
		r.put("insur",   mapper.selectMonthInsur(hospCd, fromYm, toYm));
		r.put("classes", mapper.selectMonthClass(hospCd, fromYm, toYm));
		r.put("inout",   mapper.selectMonthInOut(hospCd, fromYm, toYm));
		r.put("scores",  mapper.selectMonthScore(hospCd, fromYm, toYm));
		r.put("avg",     mapper.selectMonthAvg(fromYm, toYm));
		r.put("grade",   mapper.selectGradeLatest(hospCd));
		return r;
	}

	@Override
	public String selectLastClaimYm(String hospCd) throws Exception { return mapper.selectLastClaimYm(hospCd); }

	@Override
	public Map<String, Object> selectCostPage(String hospCd, String ym) throws Exception {
		Map<String, Object> r = new HashMap<>();
		r.put("cfg",   mapper.selectCfg(hospCd));
		r.put("cats",  mapper.selectCats(hospCd));
		r.put("cost",  mapper.selectCost(hospCd, ym));
		String prevYm = mapper.selectPrevCostYm(hospCd, ym);
		r.put("prevYm", prevYm == null ? "" : prevYm);
		r.put("prevCost", prevYm == null ? new ArrayList<Map<String, Object>>() : mapper.selectCost(hospCd, prevYm));
		// 이 달 수익·입원일수(손익분기 계산 재료) — 청구가 없는 달이면 빈 목록
		r.put("claim", mapper.selectMonthClaim(hospCd, ym, ym));
		// 최근 12달 추이(고정비·추가수익 vs 총진료비)
		String fromYm = addMonths(ym, -11);
		r.put("trend", mapper.selectCostTrend(hospCd, fromYm, ym));
		r.put("trendClaim", mapper.selectMonthClaim(hospCd, fromYm, ym));
		r.put("grade", mapper.selectGradeLatest(hospCd));
		return r;
	}

	@Override
	public void saveCfg(Map<String, Object> p) throws Exception { mapper.saveCfg(p); }

	@Override
	public void saveCat(Map<String, Object> p) throws Exception { mapper.saveCat(p); }

	@Override
	public int deleteCat(String hospCd, String catCd) throws Exception {
		if (mapper.countCostByCat(hospCd, catCd) > 0) return -1;   // 기록이 있는 항목은 지우지 않는다 — 사용 끄기로
		return mapper.deleteCat(hospCd, catCd);
	}

	@Override
	public void saveCostMonth(String hospCd, String ym, List<Map<String, Object>> rows, String userId) throws Exception {
		mapper.deleteCostMonth(hospCd, ym);
		for (Map<String, Object> row : rows) {
			Map<String, Object> m = new HashMap<>();
			m.put("hospCd", hospCd);
			m.put("ym", ym);
			m.put("catCd", row.get("catCd"));
			m.put("amt", row.get("amt"));
			m.put("memo", row.get("memo"));
			m.put("userId", userId);
			mapper.insertCost(m);
		}
	}

	/** YYYYMM 에 달을 더한다(음수 가능). */
	static String addMonths(String ym, int n) {
		int y = Integer.parseInt(ym.substring(0, 4)), m = Integer.parseInt(ym.substring(4, 6)) - 1 + n;
		y += Math.floorDiv(m, 12);
		m = Math.floorMod(m, 12);
		return String.format("%04d%02d", y, m + 1);
	}

	/* ═══ 업무 알림(③ 업무 자동화) ═══
	   규칙 : 「지난달」 자료가 올라왔는지(청구·입퇴원·평가표·자료생성) · 이번 분기 차등제 신고값 · 지난달 평가표 자가점검 오류 · 고정비·병상 수.
	   알림 하나 = { level(bad·warn·ok·info), title, desc, href, act } — 화면은 그대로 그린다. 판정 실패는 그 항목만 info 로 남긴다(한 조회 때문에 판이 안 뜨면 안 된다). */
	@Resource(name = "MagamService")
	private egovframework.wnn_medcost.magam.service.MagamService magamSvc;

	/* Gemini 호출은 적정성 Q&A 와 같은 키·같은 함수를 쓴다(MangrService.askGemini). */
	@Resource(name = "MangrService")
	private egovframework.wnn_medcost.mangr.service.MangrService mangrSvc;

	@Override
	public List<Map<String, Object>> selectAlerts(String hospCd, String wnnYn) throws Exception {
		List<Map<String, Object>> out = new ArrayList<>();
		java.util.Calendar cal = java.util.Calendar.getInstance();
		String today = new java.text.SimpleDateFormat("yyyyMMdd").format(cal.getTime());
		String nowYm = today.substring(0, 6), lastYm = addMonths(nowYm, -1);
		String lastLbl = lastYm.substring(0, 4) + "년 " + Integer.parseInt(lastYm.substring(4)) + "월";
		int day = cal.get(java.util.Calendar.DAY_OF_MONTH);

		// ① 차등제 — 이번 분기 신고값. 분기 첫 달(1·4·7·10월)에 없으면 빨강, 그 뒤 달에도 없으면 주황.
		try {
			int q = (Integer.parseInt(nowYm.substring(4)) - 1) / 3 + 1;
			String yy = nowYm.substring(0, 4);
			boolean firstMonth = (Integer.parseInt(nowYm.substring(4)) - 1) % 3 == 0;
			if (mapper.countGradeQ(hospCd, yy, String.valueOf(q)) == 0) {
				out.add(alert(firstMonth ? "bad" : "warn", yy + "년 " + q + "분기 차등제 신고값이 아직 없습니다",
					"신고값(평균환자·의사·간호사·간호인력·약사)을 입력하면 직전 분기 석 달의 구조영역 점수가 다시 계산됩니다.",
					"/main/assessment.do", "신고값 입력 →"));
			} else {
				out.add(alert("ok", yy + "년 " + q + "분기 차등제 신고값 입력됨", "구조영역(의사·간호사·간호인력·약사) 산출에 쓰입니다.", "/main/assessment.do", "확인"));
			}
		} catch (Exception e) { out.add(alert("info", "차등제 신고 여부를 확인하지 못했습니다", e.getMessage(), "", "")); }

		// ② 지난달 청구 샘파일
		try {
			if (mapper.countClaimYm(hospCd, lastYm) == 0)
				out.add(alert(day >= 15 ? "bad" : "warn", lastLbl + " 청구 샘파일이 아직 없습니다",
					"미업로드 시 항정신성의약품 처방률이 산출되지 않고, 월별통계분석의 진료비·입원일수가 비어 보입니다.", "/main/magamFileUpload.do", "올리기 →"));
			else
				out.add(alert("ok", lastLbl + " 청구 샘파일 올림", "월별통계분석·항정신성의약품 처방률에 반영됨.", "/main/magamFileUpload.do", "확인"));
		} catch (Exception e) { out.add(alert("info", "청구 샘파일 여부를 확인하지 못했습니다", e.getMessage(), "", "")); }

		// ③ 지난달 입퇴원현황
		try {
			Map<String, Object> ip = mapper.selectIpwonYm(hospCd, lastYm);
			long cnt = ip == null || ip.get("cnt") == null ? 0 : Long.parseLong(String.valueOf(ip.get("cnt")));
			if (cnt == 0)
				out.add(alert("warn", lastLbl + " 입퇴원현황이 아직 없습니다", "장기입원 「퇴원」 표시·입원/퇴원 수·고객관리의 입원 전환이 이 자료로 됩니다.", "/main/magamFileUpload.do", "올리기 →"));
			else
				out.add(alert("ok", lastLbl + " 입퇴원현황 올림 (" + cnt + "건" + regOf(ip.get("lastreg")) + ")", "장기입원 퇴원 표시·입원/퇴원 수에 반영됨.", "/main/magamFileUpload.do", "확인"));
		} catch (Exception e) { out.add(alert("info", "입퇴원현황 여부를 확인하지 못했습니다", e.getMessage(), "", "")); }

		// ④ 지난달 환자평가표 + 자료생성 + 자가점검
		try {
			Map<String, Object> pv = mapper.selectPatvalYm(hospCd, lastYm);
			long pats = pv == null || pv.get("cnt") == null ? 0 : Long.parseLong(String.valueOf(pv.get("cnt")));
			if (pats == 0) {
				out.add(alert("warn", lastLbl + " 환자평가표가 아직 없습니다", "적정성평가 지표 대부분이 평가표에서 나옵니다.", "/main/magamFileUpload.do", "올리기 →"));
			} else {
				Map<String, Object> pi = mapper.selectPatIndiYm(hospCd, lastYm);
				long ind = pi == null || pi.get("cnt") == null ? 0 : Long.parseLong(String.valueOf(pi.get("cnt")));
				if (ind == 0)
					out.add(alert("warn", lastLbl + " 자료생성이 아직 안 됐습니다 (평가표 " + pats + "명 올라옴)", "적정성평가 화면에서 [월 자료생성]을 눌러야 점수가 나옵니다.", "/main/assessment.do", "자료생성 →"));
				else
					out.add(alert("ok", lastLbl + " 자료생성 완료 (종합 " + String.valueOf(pi.get("score")) + "점" + regOf(pi.get("lastreg")) + ")", "평가표 " + pats + "명 기준.", "/main/assessment.do", "확인"));
				// 자가점검 — 적정성-평가 점검 화면과 같은 조회(select_assesCheck00)를 지난달로 돌려 건수만 센다
				try {
					egovframework.wnn_medcost.magam.model.PatvalDTO d = new egovframework.wnn_medcost.magam.model.PatvalDTO();
					d.setHospCd(hospCd); d.setJobYymm(lastYm); d.setJobFlag("00"); d.setsWnnYn(wnnYn);
					List<?> errs = magamSvc.select_assesCheck00(d);
					int n = errs == null ? 0 : errs.size();
					if (n > 0)
						out.add(alert("warn", lastLbl + " 환자평가표 자가점검: 확인할 항목 " + n + "건", "평가구분·유치도뇨관·욕창·배뇨 등 평가표와 청구가 어긋난 줄입니다. 제출 전에 보세요.", "/main/assesCheck.do", "목록 보기 →"));
					else
						out.add(alert("ok", lastLbl + " 환자평가표 자가점검: 확인할 항목 없음", "", "/main/assesCheck.do", "확인"));
				} catch (Exception e) { out.add(alert("info", "평가표 자가점검을 돌리지 못했습니다", e.getMessage(), "/main/assesCheck.do", "점검 화면 →")); }
			}
		} catch (Exception e) { out.add(alert("info", "환자평가표 여부를 확인하지 못했습니다", e.getMessage(), "", "")); }

		// ⑤ 고정비·병상 수
		try {
			if (mapper.countCostYm(hospCd, lastYm) == 0)
				out.add(alert("warn", lastLbl + " 고정비 입력이 아직 없습니다", "입력하지 않으면 손익분기 추이에 그 달이 비어 있습니다. 바뀐 것이 없으면 [이전 달 값 가져오기] → [저장].", "/main/misCost.do", "입력 →"));
			else
				out.add(alert("ok", lastLbl + " 고정비 입력됨", "손익분기에 반영됨.", "/main/misCost.do", "확인"));
			Map<String, Object> cfg = mapper.selectCfg(hospCd);
			if (cfg == null || cfg.get("bedcnt") == null)
				out.add(alert("info", "허가 병상 수가 등록되지 않았습니다", "한 번만 넣으면 월별통계분석에 병상 가동률이 나옵니다.", "/main/misCost.do", "설정 →"));
		} catch (Exception e) { out.add(alert("info", "고정비 입력 여부를 확인하지 못했습니다", e.getMessage(), "", "")); }

		// ⑥ 고객관리(④) 연동 — 연락 예정일이 지난·오늘인 상담, 퇴원 뒤 안부 연락이 밀린 환자, 이번 달 상담·입원 (2026-10-08 강화)
		//    새 조회 없이 고객관리 화면이 쓰는 조회(selectLeads·selectFollowList·selectLeadStats)를 그대로 세어 두 화면이 어긋나지 않게 한다.
		try {
			int over = 0, todayCnt = 0, active = 0;
			for (Map<String, Object> l : mapper.selectLeads(hospCd)) {
				String st = String.valueOf(l.get("stage")), nd = l.get("nextdt") == null ? "" : String.valueOf(l.get("nextdt"));
				if (!("10".equals(st) || "20".equals(st) || "30".equals(st))) continue;   // 상담·방문·입원 결정 = 아직 사람이 챙겨야 하는 단계
				active++;
				if (!nd.matches("\\d{8}")) continue;
				if (nd.compareTo(today) < 0) over++; else if (nd.equals(today)) todayCnt++;
			}
			if (over > 0) out.add(alert("bad", "연락 예정일이 지난 상담 " + over + "건", "다음 연락일을 넘긴 상담입니다. 늦을수록 다른 병원으로 갑니다.", "/main/misLead.do", "고객관리 →"));
			if (todayCnt > 0) out.add(alert("warn", "오늘 연락할 상담 " + todayCnt + "건", "고객관리에 적어 둔 다음 연락일이 오늘입니다.", "/main/misLead.do", "고객관리 →"));
			if (active > 0 && over == 0 && todayCnt == 0) out.add(alert("ok", "진행 중인 상담 " + active + "건 — 오늘 연락할 것 없음", "", "/main/misLead.do", "확인"));

			// 퇴원 안부 — 최근 30일 퇴원 가운데 7일이 지났는데 연락 기록이 없는 건
			List<Map<String, Object>> fl = selectFollowList(hospCd, 30);
			java.util.Calendar c7 = java.util.Calendar.getInstance(); c7.add(java.util.Calendar.DAY_OF_MONTH, -7);
			String limit = new java.text.SimpleDateFormat("yyyyMMdd").format(c7.getTime());
			int pend = 0;
			for (Map<String, Object> f : fl) {
				String tw = f.get("twdt") == null ? "" : String.valueOf(f.get("twdt"));
				if (!"Y".equals(String.valueOf(f.get("doneyn"))) && tw.matches("\\d{8}") && tw.compareTo(limit) <= 0) pend++;
			}
			if (pend > 0) out.add(alert("warn", "퇴원 7일이 지났는데 안부 연락이 없는 환자 " + pend + "명", "최근 30일 퇴원 기준. 재입원 안내·만족도 확인 기회입니다.", "/main/misLead.do", "안부 연락 →"));
			else if (!fl.isEmpty()) out.add(alert("ok", "최근 30일 퇴원 환자 " + fl.size() + "명 — 안부 연락 밀린 것 없음", "", "/main/misLead.do", "확인"));

			// 이번 달 상담 → 입원 전환
			long leadsM = 0, admitsM = 0;
			for (Map<String, Object> s : mapper.selectLeadStats(hospCd, nowYm + "01", today)) { leadsM += num(s.get("leads")); admitsM += num(s.get("admits")); }
			if (leadsM > 0) out.add(alert("info", "이번 달 신규 상담 " + leadsM + "건 · 그중 입원 " + admitsM + "건", "유입경로별 전환율은 고객관리 아래 표에 있습니다.", "/main/misLead.do", "보기 →"));
		} catch (Exception e) { out.add(alert("info", "고객관리 현황을 확인하지 못했습니다", e.getMessage(), "/main/misLead.do", "고객관리 →")); }

		// ⑦ 결재 대기 — QPS 보고서가 상신(SUBMIT)되어 승인 차례를 기다리는 건
		try {
			int pend = mapper.countQpsPending(hospCd);
			if (pend > 0) out.add(alert("warn", "결재 대기 " + pend + "건 (상신됨)", "품질(QPS) 보고서가 상신되어 승인 차례를 기다리고 있습니다.", "/main/qpsFall.do", "결재 상황 보기 →"));
		} catch (Exception e) { out.add(alert("info", "결재 대기 건수를 확인하지 못했습니다", e.getMessage(), "", "")); }

		return out;
	}

	/* ═══ 병원 내규 · 안내문 (2026-10-12) ═══ */
	private static final String RULE_SYS = "너는 이 병원의 내규·지침을 안내하는 도우미다. 아래 [내규] 본문에 적힌 내용만 근거로 답한다. "
		+ "본문에 없는 금액·기한·규정 번호는 지어내지 않는다. 본문에서 찾지 못하면 \"등록된 내규에서 찾지 못했습니다\"라고만 답한다. "
		+ "답은 짧게 존댓말로 쓰고, 마지막 줄에 근거 내규 제목을 \"근거: …\" 로 적는다.";
	private static final String LEAF_SYS = "너는 요양병원이 신규 환자·보호자에게 나눠 줄 안내문 초안을 쓴다. 두 가지 안을 쓰고, 두 안 사이는 \"===\" 한 줄로 구분한다. "
		+ "존댓말, 짧은 문장, 큰 글씨로 읽기 쉽게 줄을 나눈다. 금액·날짜·전화번호·주소·담당자 이름은 지어내지 말고 [ ] 빈칸으로 둔다. "
		+ "환자 이름·주민번호 같은 개인정보는 쓰지 않는다. 의료 판단이나 처방은 쓰지 않는다.";

	@Override
	public List<Map<String, Object>> ruleList(String hospCd) throws Exception { return mapper.selectRules(hospCd); }

	@Override
	public long ruleSave(String hospCd, long ruleSeq, String title, String body, String userId) throws Exception {
		Map<String, Object> p = new HashMap<>();
		p.put("hospCd", hospCd); p.put("title", title); p.put("body", body); p.put("userId", userId);
		if (ruleSeq > 0) {
			p.put("ruleSeq", ruleSeq);
			if (mapper.updateRule(p) == 0) throw new Exception("고칠 내규를 찾지 못했습니다. 목록을 새로 불러 주세요.");
			return ruleSeq;
		}
		mapper.insertRule(p);
		return num(p.get("ruleSeq"));
	}

	@Override
	public int ruleDel(String hospCd, long ruleSeq, String userId) throws Exception {
		Map<String, Object> p = new HashMap<>();
		p.put("hospCd", hospCd); p.put("ruleSeq", ruleSeq); p.put("userId", userId);
		return mapper.deleteRule(p);
	}

	/** 내규 질문 — 질문과 낱말이 많이 겹치는 내규부터 골라 그 본문만 근거로 답한다. 겹치는 내규가 없으면 AI 를 부르지 않는다(지어내기 방지). */
	@Override
	public Map<String, Object> ruleAsk(String hospCd, String question) throws Exception {
		Map<String, Object> out = new java.util.LinkedHashMap<>();
		String q = question == null ? "" : question.trim();
		if (q.length() < 2) { out.put("ok", false); out.put("reason", "질문을 두 글자 이상 적어 주세요."); return out; }
		String[] words = q.split("[\\s,.?!·/]+");
		List<Map<String, Object>> hits = new ArrayList<>();
		for (Map<String, Object> r : mapper.selectRules(hospCd)) {
			String title = String.valueOf(r.get("title"));
			String body = r.get("body") == null ? "" : String.valueOf(r.get("body"));
			String t = title + " " + body;
			int score = 0;
			for (String w : words) if (w.length() >= 2 && t.contains(w)) score++;
			if (score > 0) {
				Map<String, Object> h = new HashMap<>();
				h.put("title", title); h.put("body", body); h.put("score", score);
				hits.add(h);
			}
		}
		hits.sort((a, b) -> Integer.compare((Integer) b.get("score"), (Integer) a.get("score")));
		out.put("ok", true);
		if (hits.isEmpty()) {
			out.put("found", false); out.put("refs", new ArrayList<String>());
			out.put("answer", "등록된 내규에서 질문과 맞는 내용을 찾지 못했습니다. 내규를 등록해 두면 여기서 바로 찾아 드립니다.");
			return out;
		}
		StringBuilder ctx = new StringBuilder();
		List<String> refs = new ArrayList<>();
		for (Map<String, Object> h : hits) {
			if (refs.size() >= 3) break;
			String body = (String) h.get("body");
			if (body.length() > 3000) body = body.substring(0, 3000);
			if (ctx.length() + body.length() > 8000) break;
			refs.add((String) h.get("title"));
			ctx.append("[내규] ").append((String) h.get("title")).append("\n").append(body).append("\n\n");
		}
		out.put("found", true); out.put("refs", refs);
		String ans = mangrSvc.askGemini(RULE_SYS, "[질문] " + q + "\n\n" + ctx);
		out.put("answer", ans == null ? "" : ans.trim());
		return out;
	}

	/** 신규 환자·보호자 안내문 초안 — 두 안으로 나눈다. 금액·날짜·연락처는 AI 가 빈칸으로 둔다(LEAF_SYS). */
	@Override
	public Map<String, Object> leafletDraft(String audience, String topic, String note) throws Exception {
		Map<String, Object> out = new java.util.LinkedHashMap<>();
		String user = "대상: " + audience + "\n주제: " + topic + (note == null || note.isEmpty() ? "" : "\n추가로 담을 내용: " + note);
		String ans = mangrSvc.askGemini(LEAF_SYS, user);
		List<String> drafts = new ArrayList<>();
		if (ans != null && !ans.trim().isEmpty()) {
			for (String part : ans.trim().split("\\n\\s*={3,}\\s*\\n")) if (!part.trim().isEmpty()) drafts.add(part.trim());
		}
		out.put("ok", !drafts.isEmpty());
		out.put("drafts", drafts);
		if (drafts.isEmpty()) out.put("reason", "AI 초안을 받지 못했습니다. 연결 상태를 확인해 주세요.");
		return out;
	}

	/* ═══ 안내문 저장 (2026-10-13) ═══ */
	@Override
	public List<Map<String, Object>> leafletList(String hospCd) throws Exception { return mapper.selectLeaflets(hospCd); }

	@Override
	public Map<String, Object> leafletGet(String hospCd, long leafSeq) throws Exception { return mapper.selectLeaflet(hospCd, leafSeq); }

	/** 저장(새로)은 대상·주제까지 넣고, 고치기는 이름과 본문만 바꾼다(대상·주제는 처음 정한 대로 둔다). */
	@Override
	public long leafletSave(String hospCd, long leafSeq, String title, String audience, String topic, String body, String userId) throws Exception {
		Map<String, Object> p = new HashMap<>();
		p.put("hospCd", hospCd); p.put("title", title); p.put("body", body); p.put("userId", userId);
		if (leafSeq > 0) {
			p.put("leafSeq", leafSeq);
			if (mapper.updateLeaflet(p) == 0) throw new Exception("고칠 안내문을 찾지 못했습니다. 목록을 새로 불러 주세요.");
			return leafSeq;
		}
		p.put("audience", audience); p.put("topic", topic);
		mapper.insertLeaflet(p);
		return num(p.get("leafSeq"));
	}

	@Override
	public int leafletDel(String hospCd, long leafSeq, String userId) throws Exception {
		Map<String, Object> p = new HashMap<>();
		p.put("hospCd", hospCd); p.put("leafSeq", leafSeq); p.put("userId", userId);
		return mapper.deleteLeaflet(p);
	}

	/* ═══ 통합검색 v1 (2026-10-13) — 병원 내규 · 저장한 안내문 ═══ */
	/** 낱말이 제목에 맞으면 3점, 본문에 맞으면 1점. AI 는 쓰지 않는다(찾기만 한다). */
	@Override
	public Map<String, Object> searchAll(String hospCd, String question) throws Exception {
		Map<String, Object> out = new java.util.LinkedHashMap<>();
		String q = question == null ? "" : question.trim();
		if (q.length() < 2) { out.put("ok", false); out.put("reason", "두 글자 이상 적어 주세요."); return out; }
		String[] words = q.split("[\\s,.?!·/]+");

		List<Map<String, Object>> rules = new ArrayList<>();
		for (Map<String, Object> r : mapper.selectRules(hospCd)) {
			int sc = scoreOf(words, r.get("title"), r.get("body"));
			if (sc <= 0) continue;
			Map<String, Object> h = new HashMap<>();
			h.put("seq", r.get("ruleSeq")); h.put("title", r.get("title"));
			h.put("sub", r.get("upddttm") == null ? "" : "수정 " + r.get("upddttm"));
			h.put("snip", snippetOf(words, r.get("body")));
			h.put("score", sc);
			rules.add(h);
		}

		List<Map<String, Object>> leaves = new ArrayList<>();
		for (Map<String, Object> r : mapper.selectLeafletBodies(hospCd)) {
			int sc = scoreOf(words, r.get("title"), r.get("body"));
			if (sc <= 0) continue;
			List<String> parts = new ArrayList<>();
			for (String k : new String[]{"audience", "topic", "upddttm"}) {
				Object v = r.get(k);
				if (v != null && !String.valueOf(v).isEmpty()) parts.add(String.valueOf(v));
			}
			Map<String, Object> h = new HashMap<>();
			h.put("seq", r.get("leafSeq")); h.put("title", r.get("title"));
			h.put("sub", String.join(" · ", parts));
			h.put("snip", snippetOf(words, r.get("body")));
			h.put("score", sc);
			leaves.add(h);
		}

		rules.sort((a, b) -> Integer.compare((Integer) b.get("score"), (Integer) a.get("score")));
		leaves.sort((a, b) -> Integer.compare((Integer) b.get("score"), (Integer) a.get("score")));
		out.put("ok", true);
		out.put("rules", new ArrayList<>(rules.subList(0, Math.min(20, rules.size()))));
		out.put("leaves", new ArrayList<>(leaves.subList(0, Math.min(20, leaves.size()))));
		return out;
	}

	private static int scoreOf(String[] words, Object title, Object body) {
		String t = title == null ? "" : String.valueOf(title);
		String b = body == null ? "" : String.valueOf(body);
		int sc = 0;
		for (String w : words) {
			if (w.length() < 2) continue;
			if (t.contains(w)) sc += 3;
			if (b.contains(w)) sc += 1;
		}
		return sc;
	}

	/** 처음 맞은 낱말 주변 90자 안팎을 보여 준다. 맞은 곳이 없으면 본문 앞부분. */
	private static String snippetOf(String[] words, Object body) {
		String b = body == null ? "" : String.valueOf(body).replaceAll("\\s+", " ").trim();
		int at = -1;
		for (String w : words) {
			if (w.length() < 2) continue;
			int i = b.indexOf(w);
			if (i >= 0 && (at < 0 || i < at)) at = i;
		}
		if (at < 0) return b.length() > 90 ? b.substring(0, 90) + "…" : b;
		int from = Math.max(0, at - 30), to = Math.min(b.length(), at + 60);
		return (from > 0 ? "…" : "") + b.substring(from, to) + (to < b.length() ? "…" : "");
	}

	private static long num(Object o) { try { return o == null ? 0 : Long.parseLong(String.valueOf(o)); } catch (Exception e) { return 0; } }

	private static Map<String, Object> alert(String level, String title, String desc, String href, String act) {
		Map<String, Object> m = new HashMap<>();
		m.put("level", level); m.put("title", title); m.put("desc", desc == null ? "" : desc); m.put("href", href == null ? "" : href); m.put("act", act == null ? "" : act);
		return m;
	}

	private static String regOf(Object dttm) {
		if (dttm == null) return "";
		String s = String.valueOf(dttm);
		return s.length() >= 10 ? " · " + s.substring(5, 10).replace('-', '/') + " 올림" : "";
	}

	@Override
	public Map<String, Object> selectSim(String hospCd) throws Exception {
		Map<String, Object> r = new HashMap<>();
		r.put("grade", mapper.selectGradeLatest(hospCd));
		r.put("zones", mapper.selectStructZones(new java.text.SimpleDateFormat("yyyyMMdd").format(new java.util.Date())));
		return r;
	}

	/* ═══ ④ 신규환자 고객관리 ═══
	   상담 접수는 사람이 적고, 입원·퇴원은 입퇴원현황으로 **자동 확인**한다(생년월일 6 + 이름 — 장기입원 목록과 같은 매칭 규칙).
	   자동 매칭은 단계를 **앞으로만** 옮긴다(사람이 적은 「입원」을 「상담」으로 되돌리지 않는다). */
	@Override
	public Map<String, Object> selectLeadBoard(String hospCd) throws Exception {
		syncLeads(hospCd);
		Map<String, Object> r = new HashMap<>();
		r.put("leads", mapper.selectLeads(hospCd));
		String today = new java.text.SimpleDateFormat("yyyyMMdd").format(new java.util.Date());
		String from = today.substring(0, 6) + "01";                // 이번 달 1일
		r.put("stats", mapper.selectLeadStats(hospCd, from, today));
		String from3 = addMonths(today.substring(0, 6), -2) + "01";  // 최근 3달
		r.put("stats3", mapper.selectLeadStats(hospCd, from3, today));
		r.put("today", today);
		return r;
	}

	/** 입퇴원현황과 대조 — 상담 뒤 첫 입원 건을 찾아 입원(40)·퇴원 후(50)로 올린다. 실패해도 판은 뜬다. */
	private void syncLeads(String hospCd) {
		try {
			List<Map<String, Object>> rows = mapper.selectLeadMatches(hospCd);
			java.util.Set<Object> done = new java.util.HashSet<>();
			for (Map<String, Object> m : rows) {
				Object seq = m.get("leadseq");
				if (done.contains(seq)) continue;          // 입원일 오름차순 — 첫 입원 건만
				done.add(seq);
				String ipdt = m.get("ipdt") == null ? "" : String.valueOf(m.get("ipdt"));
				String twdt = m.get("twdt") == null ? "" : String.valueOf(m.get("twdt"));
				if (!ipdt.matches("\\d{8}")) continue;
				Map<String, Object> u = new HashMap<>();
				u.put("hospCd", hospCd); u.put("leadSeq", seq);
				u.put("stage", twdt.matches("\\d{8}") ? "50" : "40");
				u.put("admitDt", ipdt); u.put("dischDt", twdt.matches("\\d{8}") ? twdt : "");
				mapper.updateLeadMatch(u);
			}
		} catch (Exception ignore) { }
	}

	@Override
	public long saveLead(Map<String, Object> p) throws Exception {
		Object seq = p.get("leadSeq");
		if (seq == null || String.valueOf(seq).trim().isEmpty() || "0".equals(String.valueOf(seq).trim())) {
			mapper.insertLead(p);
			long newSeq = Long.parseLong(String.valueOf(p.get("leadSeq")));
			log(p.get("hospCd"), newSeq, String.valueOf(p.get("stage")), "상담 접수", String.valueOf(p.get("userId")));
			return newSeq;
		}
		mapper.updateLead(p);
		return Long.parseLong(String.valueOf(seq));
	}

	@Override
	public void moveLead(String hospCd, long leadSeq, String stage, String closeRsn, String memo, String userId) throws Exception {
		Map<String, Object> m = new HashMap<>();
		m.put("hospCd", hospCd); m.put("leadSeq", leadSeq); m.put("stage", stage); m.put("closeRsn", closeRsn); m.put("userId", userId);
		mapper.updateLeadStage(m);
		log(hospCd, leadSeq, stage, memo == null || memo.isEmpty() ? ("단계 변경 → " + stageNm(stage)) : memo, userId);
	}

	@Override
	public void addLeadLog(String hospCd, long leadSeq, String memo, String userId) throws Exception {
		Map<String, Object> l = mapper.selectLead(hospCd, leadSeq);
		if (l == null) throw new Exception("상담 기록을 찾지 못했습니다.");
		log(hospCd, leadSeq, String.valueOf(l.get("stage")), memo, userId);
	}

	@Override
	public List<Map<String, Object>> selectLeadLogs(String hospCd, long leadSeq) throws Exception { return mapper.selectLeadLogs(hospCd, leadSeq); }

	@Override
	public void deleteLead(String hospCd, long leadSeq, String userId) throws Exception {
		Map<String, Object> m = new HashMap<>();
		m.put("hospCd", hospCd); m.put("leadSeq", leadSeq); m.put("userId", userId);
		mapper.deleteLead(m);
	}

	private void log(Object hospCd, long leadSeq, String stage, String memo, String userId) {
		try {
			Map<String, Object> m = new HashMap<>();
			m.put("hospCd", hospCd); m.put("leadSeq", leadSeq); m.put("stage", stage); m.put("memo", memo); m.put("userId", userId);
			m.put("logDt", new java.text.SimpleDateFormat("yyyyMMdd").format(new java.util.Date()));
			mapper.insertLeadLog(m);
		} catch (Exception ignore) { }
	}

	static String stageNm(String s) {
		if ("10".equals(s)) return "상담"; if ("20".equals(s)) return "방문"; if ("30".equals(s)) return "입원 결정";
		if ("40".equals(s)) return "입원"; if ("50".equals(s)) return "퇴원 후"; if ("90".equals(s)) return "종결";
		return s;
	}

	/** 퇴원 환자 안부 연락 — 최근 days 일 안에 퇴원한 건(입퇴원현황) + 연락 기록 */
	@Override
	public List<Map<String, Object>> selectFollowList(String hospCd, int days) throws Exception {
		java.util.Calendar c = java.util.Calendar.getInstance();
		String toDt = new java.text.SimpleDateFormat("yyyyMMdd").format(c.getTime());
		c.add(java.util.Calendar.DAY_OF_MONTH, -days);
		String fromDt = new java.text.SimpleDateFormat("yyyyMMdd").format(c.getTime());
		return mapper.selectFollowList(hospCd, fromDt.substring(0, 6), fromDt, toDt);
	}

	@Override
	public void saveFollow(Map<String, Object> p) throws Exception { mapper.saveFollow(p); }

	/* ═══ ③-2 문자·메일 알림 (2026-10-08) ═══
	   · 받는 사람은 병원이 등록(TBL_MIS_NOTI_USER). 계정 표의 메일·전화는 후보로만.
	   · 보내는 내용 = selectAlerts 의 bad·warn 만(ok·info 는 메일에 안 담는다 — 「할 일」만 가야 읽는다). 사람마다 받을 단계(bad 만 / bad+warn).
	   · 메일은 MailUtil(네이버 SMTP), 문자는 SmsUtil(알리고). 설정이 없으면 그 채널은 SKIP 으로 이력에 남기고 다른 채널은 보낸다.
	   · 자동 발송은 하루 1회 — TBL_MIS_NOTI_RUN 선점. */
	@Override
	public Map<String, Object> selectNotiBoard(String hospCd) throws Exception {
		Map<String, Object> r = new HashMap<>();
		r.put("users", mapper.selectNotiUsers(hospCd));
		r.put("candidates", mapper.selectNotiCandidates(hospCd));
		r.put("logs", mapper.selectNotiLogs(hospCd));
		r.put("mailReady", egovframework.util.MailUtil.isReady());
		r.put("mailReason", egovframework.util.MailUtil.isReady() ? "" : egovframework.util.MailUtil.notReadyReason());
		r.put("smsReady", egovframework.util.SmsUtil.isReady());
		r.put("smsReason", egovframework.util.SmsUtil.isReady() ? "" : egovframework.util.SmsUtil.notReadyReason());
		java.util.Properties pr = egovframework.util.MailUtil.config();
		r.put("autoEnabled", "true".equalsIgnoreCase(String.valueOf(pr.getProperty("noti.auto.enabled", "false")).trim()));
		return r;
	}

	@Override
	public long saveNotiUser(Map<String, Object> p) throws Exception {
		Object seq = p.get("notiSeq");
		if (seq == null || String.valueOf(seq).trim().isEmpty() || "0".equals(String.valueOf(seq).trim())) {
			mapper.insertNotiUser(p);
			return Long.parseLong(String.valueOf(p.get("notiSeq")));
		}
		mapper.updateNotiUser(p);
		return Long.parseLong(String.valueOf(seq));
	}

	@Override
	public void deleteNotiUser(String hospCd, long notiSeq) throws Exception { mapper.deleteNotiUser(hospCd, notiSeq); }

	/** 알림을 bad·warn 만 골라 제목·HTML·문자 글로 만든다. minLevel = "bad" 면 bad 만. */
	private Map<String, Object> compose(String hospCd, List<Map<String, Object>> alerts, String minLevel) {
		List<Map<String, Object>> picked = new ArrayList<>();
		int bad = 0, warn = 0;
		for (Map<String, Object> a : alerts) {
			String lv = String.valueOf(a.get("level"));
			if ("bad".equals(lv)) { bad++; picked.add(a); }
			else if ("warn".equals(lv) && !"bad".equals(minLevel)) { warn++; picked.add(a); }
		}
		String hospNm = "";
		try { Map<String, Object> h = mapper.selectHospInfo(hospCd); if (h != null && h.get("hospnm") != null) hospNm = String.valueOf(h.get("hospnm")); } catch (Exception ignore) { }
		java.util.Calendar cal = java.util.Calendar.getInstance();
		String md = (cal.get(java.util.Calendar.MONTH) + 1) + "/" + cal.get(java.util.Calendar.DAY_OF_MONTH);
		String ymd = new java.text.SimpleDateFormat("yyyy년 M월 d일").format(cal.getTime());
		int n = picked.size();
		String subject = "[WinCheck+] " + hospNm + " 오늘 챙길 일 " + n + "건 (" + md + ")";
		String siteBase = egovframework.util.MailUtil.config().getProperty("mail.siteBase", "").trim();
		if (siteBase.endsWith("/")) siteBase = siteBase.substring(0, siteBase.length() - 1);

		StringBuilder h = new StringBuilder();
		h.append("<div style=\"font-family:'Malgun Gothic','맑은 고딕',sans-serif;color:#1f2a30;max-width:640px;margin:0 auto;\">");
		h.append("<div style=\"border-bottom:3px solid #1f5a4b;padding:10px 0 8px;\"><div style=\"font-size:18px;font-weight:800;\">WinCheck<sup>+</sup> 업무 알림</div>");
		h.append("<div style=\"font-size:13px;color:#6b7c86;\">").append(esc(hospNm)).append(" · ").append(ymd).append(" 기준</div></div>");
		if (n == 0) {
			h.append("<p style=\"font-size:14px;margin:16px 0;\">오늘은 급하게 챙길 일이 없습니다.</p>");
		} else {
			h.append("<p style=\"font-size:14px;margin:14px 0 8px;\"><b style=\"color:#b23b3b;\">급함 ").append(bad).append("건</b> · <b style=\"color:#b45f1c;\">할 일 ").append(warn).append("건</b></p>");
			h.append("<table style=\"width:100%;border-collapse:collapse;font-size:13px;\">");
			for (Map<String, Object> a : picked) {
				boolean isBad = "bad".equals(String.valueOf(a.get("level")));
				String href = String.valueOf(a.get("href") == null ? "" : a.get("href"));
				String link = (!siteBase.isEmpty() && href.startsWith("/")) ? siteBase + href : "";
				h.append("<tr><td style=\"width:8px;background:").append(isBad ? "#c0463f" : "#d9772b").append(";border-radius:3px;\"></td>");
				h.append("<td style=\"padding:8px 10px;border-bottom:1px solid #e3e9ed;\"><div style=\"font-weight:700;\">").append(esc(String.valueOf(a.get("title")))).append("</div>");
				String desc = String.valueOf(a.get("desc") == null ? "" : a.get("desc"));
				if (!desc.isEmpty()) h.append("<div style=\"color:#6b7c86;font-size:12px;margin-top:2px;\">").append(esc(desc)).append("</div>");
				if (!link.isEmpty()) h.append("<div style=\"margin-top:4px;\"><a href=\"").append(esc(link)).append("\" style=\"color:#1f5a4b;font-weight:700;font-size:12px;\">").append(esc(String.valueOf(a.get("act") == null || String.valueOf(a.get("act")).isEmpty() ? "열기 →" : a.get("act")))).append("</a></div>");
				h.append("</td></tr>");
			}
			h.append("</table>");
		}
		h.append("<p style=\"font-size:11.5px;color:#8a99a3;margin-top:16px;border-top:1px solid #e3e9ed;padding-top:8px;\">이 메일은 WinCheck+ 경영고객관리 › 업무 알림에서 등록한 담당자에게 자동으로 보내집니다. 받지 않으려면 업무 알림 화면의 「알림 받는 사람」에서 끄세요.");
		if (!siteBase.isEmpty()) h.append(" <a href=\"").append(esc(siteBase)).append("/main/misAlert.do\" style=\"color:#1f5a4b;\">업무 알림 열기</a>");
		h.append("</p></div>");

		StringBuilder sms = new StringBuilder();
		sms.append("[WinCheck+] ").append(shortNm(hospNm)).append(" 챙길 일 ").append(n).append("건");
		int k = 0;
		for (Map<String, Object> a : picked) { if (k++ >= 4) { sms.append("\n외 ").append(n - 4).append("건"); break; } sms.append("\n- ").append(cut(String.valueOf(a.get("title")), 40)); }
		if (n > 0) sms.append("\n자세히: WinCheck+ 업무 알림");

		Map<String, Object> r = new HashMap<>();
		r.put("subject", subject); r.put("html", h.toString()); r.put("sms", sms.toString());
		r.put("bad", bad); r.put("warn", warn); r.put("count", n); r.put("hospNm", hospNm);
		r.put("items", picked);
		return r;
	}

	@Override
	public Map<String, Object> previewNoti(String hospCd, String wnnYn) throws Exception {
		Map<String, Object> r = compose(hospCd, selectAlerts(hospCd, wnnYn), "warn");
		r.put("smsBytes", egovframework.util.SmsUtil.bytesKr(String.valueOf(r.get("sms"))));
		return r;
	}

	/** seqs = 화면에서 체크한 받는 사람(NOTI_SEQ). null 이면 사용 중인 사람 전부. (사용자 2026-10-08 「메일·카톡 보낼 때 해당자 체크하고 보내기」) */
	@Override
	public List<Map<String, Object>> sendNoti(String hospCd, String wnnYn, String sentBy, java.util.Set<Long> seqs, String testTo) throws Exception {
		List<Map<String, Object>> alerts = selectAlerts(hospCd, wnnYn);
		List<Map<String, Object>> out = new ArrayList<>();
		if (testTo != null && !testTo.trim().isEmpty()) {           // 시험 발송 — 적은 주소로 메일 1통
			Map<String, Object> c = compose(hospCd, alerts, "warn");
			out.add(deliver(hospCd, "MAIL", testTo.trim(), "(시험)", c, sentBy));
			return out;
		}
		for (Map<String, Object> u : mapper.selectNotiUsers(hospCd)) {
			if (!"Y".equals(String.valueOf(u.get("useyn")))) continue;
			if (seqs != null && !seqs.contains(Long.parseLong(String.valueOf(u.get("notiseq"))))) continue;
			out.addAll(sendTo(hospCd, alerts, u, sentBy, false));
		}
		return out;
	}

	/** 한 사람에게 — 채널마다 한 줄. auto=true 면 챙길 일이 0건일 때 보내지 않는다(빈 메일이 매일 오면 끈다). */
	private List<Map<String, Object>> sendTo(String hospCd, List<Map<String, Object>> alerts, Map<String, Object> u, String sentBy, boolean auto) {
		List<Map<String, Object>> out = new ArrayList<>();
		String minLevel = "bad".equals(String.valueOf(u.get("minlevel"))) ? "bad" : "warn";
		Map<String, Object> c = compose(hospCd, alerts, minLevel);
		String name = String.valueOf(u.get("name"));
		if (auto && Integer.parseInt(String.valueOf(c.get("count"))) == 0) return out;
		if ("Y".equals(String.valueOf(u.get("mailyn")))) out.add(deliver(hospCd, "MAIL", String.valueOf(u.get("email") == null ? "" : u.get("email")), name, c, sentBy));
		if ("Y".equals(String.valueOf(u.get("smsyn")))) out.add(deliver(hospCd, "SMS", String.valueOf(u.get("tel") == null ? "" : u.get("tel")), name, c, sentBy));
		return out;
	}

	/** 실제 발송 + 이력 한 줄. 설정이 없거나 주소가 비면 SKIP, 보냈는데 실패면 FAIL — 예외는 밖으로 안 낸다. */
	private Map<String, Object> deliver(String hospCd, String channel, String to, String name, Map<String, Object> c, String sentBy) {
		Map<String, Object> r = new HashMap<>();
		r.put("channel", channel); r.put("to", to); r.put("name", name);
		String result, err = "";
		String subject = String.valueOf(c.get("subject"));
		String body = "MAIL".equals(channel) ? String.valueOf(c.get("html")) : String.valueOf(c.get("sms"));
		try {
			if (to == null || to.trim().isEmpty()) { result = "SKIP"; err = ("MAIL".equals(channel) ? "메일 주소" : "휴대폰 번호") + "가 비어 있습니다"; }
			else if ("MAIL".equals(channel)) {
				if (!egovframework.util.MailUtil.isReady()) { result = "SKIP"; err = egovframework.util.MailUtil.notReadyReason(); }
				else { egovframework.util.MailUtil.send(to, subject, body, null, null); result = "OK"; }
			} else {
				if (!egovframework.util.SmsUtil.isReady()) { result = "SKIP"; err = egovframework.util.SmsUtil.notReadyReason(); }
				else { String id = egovframework.util.SmsUtil.send(to, body, "WinCheck+ 업무 알림"); result = "OK"; err = id == null || id.isEmpty() ? "" : "msg_id " + id; }
			}
		} catch (Exception e) { result = "FAIL"; err = e.getMessage() == null ? e.toString() : e.getMessage(); }
		r.put("result", result); r.put("message", err);
		try {
			Map<String, Object> l = new HashMap<>();
			l.put("hospCd", hospCd); l.put("channel", channel); l.put("toAddr", cut(to, 100)); l.put("toName", cut(name, 50));
			l.put("subject", cut(subject, 200)); l.put("body", body); l.put("result", result); l.put("errMsg", cut(err, 500)); l.put("sentBy", cut(sentBy, 50));
			l.put("levelCnt", "bad " + c.get("bad") + " · warn " + c.get("warn"));
			mapper.insertNotiLog(l);
		} catch (Exception ignore) { }
		return r;
	}

	@Override
	public Map<String, Object> runAutoNoti() throws Exception {
		Map<String, Object> r = new HashMap<>();
		String today = new java.text.SimpleDateFormat("yyyyMMdd").format(new java.util.Date());
		String host = "";
		try { host = java.net.InetAddress.getLocalHost().getHostName(); } catch (Exception ignore) { }
		if (mapper.insertNotiRun(today, host) == 0) { r.put("skipped", "이미 다른 인스턴스가 오늘 보냈습니다"); return r; }
		boolean monday = java.util.Calendar.getInstance().get(java.util.Calendar.DAY_OF_WEEK) == java.util.Calendar.MONDAY;
		int hosps = 0, sent = 0, failed = 0, skipped = 0;
		for (String hospCd : mapper.selectNotiHosps()) {
			hosps++;
			List<Map<String, Object>> alerts;
			try { alerts = selectAlerts(hospCd, "N"); } catch (Exception e) { continue; }
			for (Map<String, Object> u : mapper.selectNotiUsers(hospCd)) {
				if (!"Y".equals(String.valueOf(u.get("useyn")))) continue;
				String gb = String.valueOf(u.get("autogb"));
				if (!("D".equals(gb) || ("W".equals(gb) && monday))) continue;
				for (Map<String, Object> x : sendTo(hospCd, alerts, u, "auto", true)) {
					String rs = String.valueOf(x.get("result"));
					if ("OK".equals(rs)) sent++; else if ("FAIL".equals(rs)) failed++; else skipped++;
				}
			}
		}
		r.put("date", today); r.put("hosps", hosps); r.put("sent", sent); r.put("failed", failed); r.put("skipped", skipped);
		return r;
	}

	@Override
	public boolean hasMisContract(String hospCd) throws Exception { return hospCd != null && !hospCd.isEmpty() && mapper.countMisContract(hospCd) > 0; }

	@Override
	public void logNotiShare(String hospCd, String channel, String subject, String body, String result, String errMsg, String userId) throws Exception {
		Map<String, Object> l = new HashMap<>();
		l.put("hospCd", hospCd); l.put("channel", channel); l.put("toAddr", "KAKAO".equals(channel) ? "카카오톡(받는 사람은 카톡에서 고름)" : "클립보드"); l.put("toName", userId);
		l.put("subject", subject); l.put("body", body); l.put("result", result); l.put("errMsg", errMsg); l.put("sentBy", userId); l.put("levelCnt", "");
		mapper.insertNotiLog(l);
	}

	/* ═══ EMR 엑셀 연계 (2026-10-11) ═══ */
	@Override
	public Map<String, Object> selectEmrPage(String hospCd, String ym) throws Exception {
		Map<String, Object> r = new HashMap<>();
		r.put("maps", mapper.selectEmrMaps(hospCd));
		r.put("uploads", mapper.selectEmrUploads(hospCd));
		r.put("pay", mapper.selectEmrPaySum(hospCd, ym));
		r.put("act", mapper.selectEmrActSum(hospCd, ym));
		r.put("cut", mapper.selectEmrCutSum(hospCd, ym));
		r.put("cutGroup", mapper.selectEmrCutGroup(hospCd, ym));
		r.put("sam", mapper.selectEmrSamSum(hospCd, ym));
		r.put("contact", mapper.selectEmrContactSum(hospCd));
		r.put("staff", mapper.selectEmrStaffSum(hospCd, ym));
		r.put("ipwon", mapper.selectEmrIpwonSum(hospCd, ym));
		return r;
	}

	@Override
	public List<Map<String, Object>> selectEmrRows(String hospCd, String dataGb, String ym) throws Exception {
		if ("PAY".equals(dataGb)) return mapper.selectEmrPayRows(hospCd, ym);
		if ("ACT".equals(dataGb)) return mapper.selectEmrActRows(hospCd, ym);
		if ("CUT".equals(dataGb)) return mapper.selectEmrCutRows(hospCd, ym);
		if ("CONTACT".equals(dataGb)) return mapper.selectEmrContactRows(hospCd);
		if ("STAFF".equals(dataGb)) return mapper.selectEmrStaffRows(hospCd, ym);
		return new ArrayList<>();
	}

	@Override
	public void saveEmrMap(String hospCd, String dataGb, String mapJson, Integer hdrRow, String userId) throws Exception {
		Map<String, Object> p = new HashMap<>();
		p.put("hospCd", hospCd); p.put("dataGb", dataGb); p.put("mapJson", mapJson); p.put("hdrRow", hdrRow); p.put("userId", userId);
		mapper.saveEmrMap(p);
	}

	@Override
	public int saveEmr(String hospCd, String dataGb, String ym, List<Map<String, Object>> rows, String fileNm, int skipCnt, String userId) throws Exception {
		int del;
		if ("PAY".equals(dataGb)) del = mapper.deleteEmrPay(hospCd, ym);
		else if ("ACT".equals(dataGb)) del = mapper.deleteEmrAct(hospCd, ym);
		else if ("CUT".equals(dataGb)) del = mapper.deleteEmrCut(hospCd, ym);
		else if ("STAFF".equals(dataGb)) del = mapper.deleteEmrStaff(hospCd, ym);
		else if ("CONTACT".equals(dataGb)) del = mapper.deleteEmrContact(hospCd);
		else throw new IllegalArgumentException("자료 구분이 잘못되었습니다 : " + dataGb);
		// 한 문장이 너무 커지지 않게 500줄씩(같은 트랜잭션 안)
		for (int i = 0; i < rows.size(); i += 500) {
			Map<String, Object> p = new HashMap<>();
			p.put("hospCd", hospCd); p.put("ym", ym); p.put("userId", userId);
			p.put("rows", rows.subList(i, Math.min(rows.size(), i + 500)));
			if ("PAY".equals(dataGb)) mapper.insertEmrPay(p);
			else if ("ACT".equals(dataGb)) mapper.insertEmrAct(p);
			else if ("CUT".equals(dataGb)) mapper.insertEmrCut(p);
			else if ("STAFF".equals(dataGb)) mapper.insertEmrStaff(p);
			else mapper.insertEmrContact(p);
		}
		Map<String, Object> l = new HashMap<>();
		l.put("hospCd", hospCd); l.put("dataGb", dataGb); l.put("ym", "CONTACT".equals(dataGb) ? null : ym);
		l.put("fileNm", cut(fileNm, 200)); l.put("rowCnt", rows.size()); l.put("skipCnt", skipCnt); l.put("delCnt", del); l.put("userId", userId);
		mapper.insertEmrUpload(l);
		return del;
	}

	@Override
	public void logEmrUpload(String hospCd, String dataGb, String ym, String fileNm, int rowCnt, int skipCnt, String userId) throws Exception {
		Map<String, Object> l = new HashMap<>();
		l.put("hospCd", hospCd); l.put("dataGb", dataGb); l.put("ym", ym);
		l.put("fileNm", cut(fileNm, 200)); l.put("rowCnt", rowCnt); l.put("skipCnt", skipCnt); l.put("delCnt", 0); l.put("userId", userId);
		mapper.insertEmrUpload(l);
	}

	private static String esc(String s) { return s == null ? "" : s.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;").replace("\"", "&quot;"); }
	private static String cut(String s, int n) { return s == null ? "" : (s.length() > n ? s.substring(0, n) : s); }
	/** 문자용 짧은 병원 이름 — 「요양병원」을 떼고 8자까지 */
	private static String shortNm(String nm) { String s = nm == null ? "" : nm.replace("요양병원", "").replace("병원", "").trim(); return cut(s.isEmpty() ? nm : s, 8); }

	/* ═══ 병원장 조회 · 원무 환자고객 · 간호사 관리 (2026-10-15) ═══
	   새 표는 인력 변동 기록 하나뿐이다. 나머지는 기존 자료를 읽는다(입퇴원현황·상담·보호자·직원 명단·구조영역 구간). */

	/** 병원장 한 장 — 청구(가장 최근 달)·입퇴원·상담·재원 환자·간호 인력 판정·챙길 일 개수. */
	private static double numOf(Object o) { return o instanceof Number ? ((Number) o).doubleValue() : 0; }

	@Override
	public Map<String, Object> selectDirectorBoard(String hospCd, String wnnYn, String fromIn, String toIn) throws Exception {
		Map<String, Object> r = new HashMap<>();
		// 기간 = 시작월~종료월(안 고르면 가장 최근 청구월 한 달). 청구 금액·일수는 기간 합계, 입원·외래는 종료월 기준.
		String ym = (toIn != null && toIn.matches("\\d{6}")) ? toIn : mapper.selectLastClaimYm(hospCd);
		if (ym != null && ym.matches("\\d{6}")) {
			String from = (fromIn != null && fromIn.matches("\\d{6}") && fromIn.compareTo(ym) <= 0) ? fromIn : ym;
			Map<String, Object> st = selectStat(hospCd, from, ym);
			r.put("ym", ym);
			r.put("fromYm", from);
			List<?> months = (List<?>) st.get("months");
			Map<String, Object> agg = null;
			if (months != null && !months.isEmpty()) {
				agg = new HashMap<>();
				double bills = 0, admdays = 0, tot = 0, claimamt = 0, selfamt = 0;
				for (Object o : months) {
					Map<?, ?> m = (Map<?, ?>) o;
					bills += numOf(m.get("bills")); admdays += numOf(m.get("admdays"));
					tot += numOf(m.get("totamt")); claimamt += numOf(m.get("claimamt")); selfamt += numOf(m.get("selfamt"));
				}
				agg.put("ym", ym);
				agg.put("bills", (long) bills);
				agg.put("admdays", (long) admdays);
				agg.put("totamt", (long) tot);
				agg.put("claimamt", (long) claimamt);
				agg.put("selfamt", (long) selfamt);
				agg.put("pats", ((Map<?, ?>) months.get(months.size() - 1)).get("pats"));
			}
			r.put("claim", agg);
			List<?> io = (List<?>) st.get("inout");
			r.put("inout", io == null || io.isEmpty() ? null : io.get(io.size() - 1));
		}
		String today = new java.text.SimpleDateFormat("yyyyMMdd").format(new java.util.Date());
		// 상담 — 이번 달 접수·입원 전환(유입 경로 전체 합)
		int leads = 0, admits = 0;
		for (Map<String, Object> row : mapper.selectLeadStats(hospCd, today.substring(0, 6) + "01", today)) {
			leads += pInt(row.get("leads"));
			admits += pInt(row.get("admits"));
		}
		r.put("leads", leads);
		r.put("admits", admits);
		Map<String, Object> pat = selectPatBoard(hospCd);
		r.put("pats", pat.get("total"));
		r.put("noTel", pat.get("noTel"));
		// 간호 인력은 변동 기록 표(DDL)가 없어도 병원장 화면이 뜨도록 따로 감싼다
		Map<String, Object> nur = new HashMap<>();
		try { nur = selectNurseBoard(hospCd); }
		catch (Exception e) { r.put("nurseErr", pStr(e.getMessage())); }
		r.put("headcount", nur.get("headcount"));
		r.put("required", nur.get("required"));
		r.put("short", nur.get("short"));
		r.put("ratio", nur.get("ratio"));
		r.put("fromRoster", nur.get("fromRoster"));
		// 챙길 일 — 업무 알림의 빨강(bad)·주황(warn) 개수와 위에서부터 세 가지
		int bad = 0, warn = 0;
		List<Map<String, Object>> todo = new ArrayList<>();
		for (Map<String, Object> a : selectAlerts(hospCd, wnnYn)) {
			String lv = pStr(a.get("level"));
			if ("bad".equals(lv)) bad++;
			else if ("warn".equals(lv)) warn++;
			if (("bad".equals(lv) || "warn".equals(lv)) && todo.size() < 3) todo.add(a);
		}
		r.put("bad", bad);
		r.put("warn", warn);
		r.put("todo", todo);
		r.put("today", today);
		return r;
	}

	/** 재원 환자 — 가장 최근 입퇴원 자료의 재원 건 + 보호자 연락처 유무 + 상담 연결 + 입원 3일 이내. */
	@Override
	public Map<String, Object> selectPatBoard(String hospCd) throws Exception {
		List<Map<String, Object>> pats = mapper.selectCurrentPats(hospCd);
		int noTel = 0, fresh = 0, inLead = 0;
		for (Map<String, Object> p : pats) {
			boolean tel = !pStr(p.get("tel")).isEmpty();
			boolean lead = !pStr(p.get("leadseq")).isEmpty();
			p.put("hasTel", tel);
			p.put("hasLead", lead);
			if (!tel) noTel++;
			if (lead) inLead++;
			if (pInt(p.get("staydays")) <= 3) fresh++;
		}
		Map<String, Object> r = new HashMap<>();
		r.put("pats", pats);
		r.put("total", pats.size());
		r.put("noTel", noTel);
		r.put("fresh", fresh);
		r.put("inLead", inLead);
		return r;
	}

	/** 간호사 관리 — 직원 명단(EMR 연계, 간호 직종) · 인력 변동 기록 · 1인당 환자수와 5점 구간 상한으로 필요 인원·부족 인원. */
	@Override
	public Map<String, Object> selectNurseBoard(String hospCd) throws Exception {
		String today = new java.text.SimpleDateFormat("yyyyMMdd").format(new java.util.Date());
		List<Map<String, Object>> roster = mapper.selectNurseRoster(hospCd);
		List<Map<String, Object>> active = new ArrayList<>();
		int nurses = 0, aides = 0;
		for (Map<String, Object> s : roster) {
			String ret = pStr(s.get("retiredt")).replaceAll("[^0-9]", "");
			if (ret.length() == 8 && ret.compareTo(today) <= 0) continue;   // 퇴사일이 지난 사람은 재직으로 세지 않는다
			active.add(s);
			if ("간호사".equals(pStr(s.get("jobnm")))) nurses++; else aides++;
		}
		boolean fromRoster = !roster.isEmpty();
		// 직원 명단이 없으면 변동 기록의 입사 − 퇴사로 간호사 수를 추정한다
		int headcount = fromRoster ? nurses : pInt(mapper.selectStaffChgNet(hospCd).get("net"));
		int pats = pInt(selectPatBoard(hospCd).get("total"));
		// 1인당 환자수 기준 — 간호사 구간(TBL_WEVALUE_MST 02)의 5점 구간 상한(인력 시뮬레이션과 같은 규칙)
		double top = 0;
		for (Map<String, Object> z : mapper.selectStructZones(today)) {
			if ("02".equals(pStr(z.get("catecode"))) && pInt(z.get("stdscore")) == 5) { top = pDbl(z.get("endindi")); break; }
		}
		int required = top > 0 ? (int) Math.ceil(pats / top) : 0;
		int shortN = Math.max(0, required - headcount);
		Double ratio = headcount > 0 ? Math.round(pats * 100.0 / headcount) / 100.0 : null;
		Map<String, Object> r = new HashMap<>();
		r.put("roster", active);
		r.put("nurses", nurses);
		r.put("aides", aides);
		r.put("headcount", headcount);
		r.put("fromRoster", fromRoster);
		r.put("pats", pats);
		r.put("ratio", ratio);
		r.put("top", top);
		r.put("required", required);
		r.put("short", shortN);
		r.put("chgs", mapper.selectStaffChgs(hospCd, today.substring(0, 4) + "0101"));
		r.put("today", today);
		return r;
	}

	@Override
	public long saveStaffChg(Map<String, Object> m) throws Exception {
		mapper.insertStaffChg(m);
		Object k = m.get("chgSeq");
		return k == null ? 0L : Long.parseLong(String.valueOf(k));
	}

	@Override
	public int deleteStaffChg(String hospCd, long chgSeq, String userId) throws Exception {
		Map<String, Object> p = new HashMap<>();
		p.put("hospCd", hospCd);
		p.put("chgSeq", chgSeq);
		p.put("userId", userId);
		return mapper.deleteStaffChg(p);
	}

	private static String pStr(Object o) { return o == null ? "" : String.valueOf(o).trim(); }

	private static int pInt(Object o) {
		try { return o == null ? 0 : (int) Double.parseDouble(String.valueOf(o).trim()); } catch (Exception e) { return 0; }
	}

	private static double pDbl(Object o) {
		try { return o == null ? 0 : Double.parseDouble(String.valueOf(o).trim()); } catch (Exception e) { return 0; }
	}

	/* ═══ 경영 보고서 (2026-10-15) — SWCHMISU 경영 보고서와 같은 구성. 청구월 한 달을 전월과 나란히 ═══
	   숫자는 화면이 계산한다(서버는 원자료만 준다). 약제는 약가비율 기준(위탁 제외 · 비청구 = 정액 포함 약). */
	@Override
	public Map<String, Object> selectReport(String hospCd, String ym) throws Exception {
		String prev = addMonths(ym, -1);
		Map<String, Object> r = new HashMap<>();
		r.put("ym", ym);
		r.put("prevYm", prev);
		r.put("claim", repFirst(mapper.selectMonthClaim(hospCd, ym, ym)));
		r.put("prevClaim", repFirst(mapper.selectMonthClaim(hospCd, prev, prev)));
		r.put("insur", mapper.selectMonthInsur(hospCd, ym, ym));
		r.put("items", mapper.selectReportItems(hospCd, ym));
		r.put("prevItems", mapper.selectReportItems(hospCd, prev));
		r.put("diags", mapper.selectReportDiags(hospCd, ym));
		r.put("prevDiags", mapper.selectReportDiags(hospCd, prev));
		r.put("inout", mapper.selectReportInOut(hospCd, ym));
		r.put("prevInout", mapper.selectReportInOut(hospCd, prev));
		r.put("drug", mapper.selectReportDrug(hospCd, ym));
		r.put("prevDrug", mapper.selectReportDrug(hospCd, prev));
		return r;
	}

	/* ═══ 원무 수입실적 (2026-10-15) — 수납대장을 날짜·입원외래·수납방법별 행으로 준다. 묶기·합계는 화면이 한다. ═══ */
	@Override
	public Map<String, Object> selectRevenue(String hospCd, String fromYm, String toYm) throws Exception {
		Map<String, Object> r = new HashMap<>();
		r.put("fromYm", fromYm);
		r.put("toYm", toYm);
		r.put("rows", mapper.selectRevRows(hospCd, fromYm + "01", toYm + "31"));
		return r;
	}

	private static Map<String, Object> repFirst(List<Map<String, Object>> rows) {
		return rows == null || rows.isEmpty() ? null : rows.get(0);
	}
}
