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
					"미업로드 시 항정신성의약품 처방률이 산출되지 않고, 경영통계의 진료비·입원일수가 비어 보입니다.", "/main/magamFileUpload.do", "올리기 →"));
			else
				out.add(alert("ok", lastLbl + " 청구 샘파일 올림", "경영통계·항정신성의약품 처방률에 반영됨.", "/main/magamFileUpload.do", "확인"));
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
				out.add(alert("info", "허가 병상 수가 등록되지 않았습니다", "한 번만 넣으면 경영통계에 병상 가동률이 나옵니다.", "/main/misCost.do", "설정 →"));
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

		return out;
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

	private static String esc(String s) { return s == null ? "" : s.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;").replace("\"", "&quot;"); }
	private static String cut(String s, int n) { return s == null ? "" : (s.length() > n ? s.substring(0, n) : s); }
	/** 문자용 짧은 병원 이름 — 「요양병원」을 떼고 8자까지 */
	private static String shortNm(String nm) { String s = nm == null ? "" : nm.replace("요양병원", "").replace("병원", "").trim(); return cut(s.isEmpty() ? nm : s, 8); }
}
