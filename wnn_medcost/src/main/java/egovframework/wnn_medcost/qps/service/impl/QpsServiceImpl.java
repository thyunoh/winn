package egovframework.wnn_medcost.qps.service.impl;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.wnn_medcost.qps.mapper.QpsMapper;
import egovframework.wnn_medcost.qps.model.QpsCensusDTO;
import egovframework.wnn_medcost.qps.model.QpsIncidentDTO;
import egovframework.wnn_medcost.qps.model.QpsManualDTO;
import egovframework.wnn_medcost.qps.model.QpsMonitorDTO;
import egovframework.wnn_medcost.qps.service.QpsService;

/**
 * QPS 서비스 — 낙상 파일럿.
 *
 * ★이 클래스가 이식의 핵심이다.
 *   기존 프로그램에서는 사람이 지표분석보고서에 '0.67‰' 를 직접 타이핑했다(실물 확인).
 *   여기서는 사고 건수(분자)와 재원일수(분모)에서 서버가 계산한다.
 *   산식·상수·단위는 코드가 아니라 TBL_QPS_INDI_MST 행에서 온다 — 지표가 늘어도 이 코드는 안 고친다.
 *
 *   검산 근거(기존 프로그램 실측): 낙상 2건 / 재원일수 3,000일 × 1,000 = 0.67‰
 */
@Service("QpsService")
public class QpsServiceImpl implements QpsService {

	@Resource(name = "QpsMapper")
	private QpsMapper mapper;

	private static final String[] MM = {"01","02","03","04","05","06","07","08","09","10","11","12"};

	@Override
	public Map<String, Object> selectHospInfo(String hospCd) throws Exception {
		return mapper.selectHospInfo(hospCd);
	}

	@Override
	public Map<String, Object> selectQpsIndi(String hospCd, String indiCd) throws Exception {
		return mapper.selectQpsIndi(hospCd, indiCd);
	}

	@Override
	public List<Map<String, Object>> selectPatientList(String hospCd, String keyword, String baseDt) throws Exception {
		// baseDt(사고 발생일) 는 나이 계산과 '재원 중' 판정의 기준이다. 없으면 오늘로 본다.
		String base = (baseDt == null) ? "" : baseDt.replace("-", "").trim();
		if (base.length() != 8) base = new java.text.SimpleDateFormat("yyyyMMdd").format(new java.util.Date());
		return mapper.selectPatientList(hospCd, keyword == null ? "" : keyword.trim(), base);
	}

	@Override
	public List<Map<String, Object>> selectIncidentList(QpsIncidentDTO dto) throws Exception {
		return mapper.selectIncidentList(dto);
	}

	@Override
	public int saveIncident(QpsIncidentDTO dto) throws Exception {
		if (dto.getIncidSeq() == null || dto.getIncidSeq() <= 0) {
			return mapper.insertIncident(dto);
		}
		return mapper.updateIncident(dto);
	}

	@Override
	public int deleteIncident(QpsIncidentDTO dto) throws Exception {
		return mapper.deleteIncident(dto);
	}

	@Override
	public List<Map<String, Object>> selectMonitorList(QpsMonitorDTO dto) throws Exception {
		return mapper.selectMonitorList(dto);
	}

	@Override
	public int saveMonitor(QpsMonitorDTO dto) throws Exception {
		if (dto.getMonSeq() == null || dto.getMonSeq() <= 0) return mapper.insertMonitor(dto);
		return mapper.updateMonitor(dto);
	}

	@Override
	public int deleteMonitor(QpsMonitorDTO dto) throws Exception {
		return mapper.deleteMonitor(dto);
	}

	@Override
	public Map<String, Object> selectMonitorBreakdown(String hospCd, String indiCd, String fromDt, String toDt) throws Exception {
		List<Map<String, Object>> rows = mapper.selectMonitorBreakdown(hospCd, indiCd, fromDt, toDt);
		Map<String, Object> out = new LinkedHashMap<>();
		if (rows != null) {
			for (Map<String, Object> r : rows) {
				String axis = str(r.get("axis"));
				@SuppressWarnings("unchecked")
				List<Map<String, Object>> list = (List<Map<String, Object>>) out.get(axis);
				if (list == null) { list = new ArrayList<>(); out.put(axis, list); }
				int numer = intOf(r.get("numer"), 0), denom = intOf(r.get("denom"), 0);
				Map<String, Object> item = new HashMap<>();
				item.put("code", r.get("code"));
				item.put("numer", numer);
				item.put("denom", denom);
				item.put("rate", denom > 0 ? new BigDecimal(numer * 100).divide(new BigDecimal(denom), 1, RoundingMode.HALF_UP) : null);
				list.add(item);
			}
		}
		return out;
	}

	@Override
	public Map<String, Object> selectCensus(String hospCd, String censusGb, String inYear) throws Exception {
		return mapper.selectCensus(hospCd, censusGb, inYear);
	}

	@Override
	public List<Map<String, Object>> selectIndiList(String hospCd, String inYear) throws Exception {
		return mapper.selectIndiList(hospCd, inYear);
	}

	@Override
	public List<Map<String, Object>> selectQpsCodes() throws Exception {
		return mapper.selectQpsCodes();
	}

	@Override
	public List<Map<String, Object>> selectRptStatus(String hospCd, String prdGb, String prdKey) throws Exception {
		return mapper.selectRptStatus(hospCd, prdGb, prdKey);
	}

	// ===================== 서식 2호: 연간 활동계획서 =====================

	@Override
	public Map<String, Object> selectPlanWithItems(String hospCd, String formGb, String inYear) throws Exception {
		Map<String, Object> out = new LinkedHashMap<>();
		Map<String, Object> plan = mapper.selectPlan(hospCd, formGb, inYear);
		out.put("plan", plan);
		if (plan != null && plan.get("planseq") != null) {
			out.put("items", mapper.selectPlanItems(Long.parseLong(String.valueOf(plan.get("planseq")))));
		} else {
			out.put("items", new ArrayList<>());
		}
		return out;
	}

	@Override
	public long savePlan(String hospCd, String formGb, String inYear, String submitDt,
	                     List<Map<String, Object>> items, String userId) throws Exception {
		Map<String, Object> p = new HashMap<>();
		p.put("hospCd", hospCd);
		p.put("formGb", formGb);
		p.put("inYear", inYear);
		p.put("submitDt", submitDt);
		p.put("regUser", userId);
		mapper.upsertPlan(p);
		long planSeq = Long.parseLong(String.valueOf(p.get("planSeq")));

		// 항목행 통째 교체 — 섹션별 부분 수정 API 를 두지 않는다(연 1부 문서, 단순함이 우선)
		mapper.deletePlanItems(planSeq);
		if (items != null && !items.isEmpty()) {
			// ★한 번에 몰아 넣되 행이 아주 많으면 나눈다(파라미터 수 제한 대비 — 27컬럼 × 행수)
			int CHUNK = 200;
			for (int i = 0; i < items.size(); i += CHUNK) {
				Map<String, Object> ip = new HashMap<>();
				ip.put("planSeq", planSeq);
				ip.put("items", items.subList(i, Math.min(i + CHUNK, items.size())));
				mapper.insertPlanItems(ip);
			}
		}
		return planSeq;
	}

	/**
	 * 기간의 전 지표 요약 — 회의록 [지표 요약 넣기]용.
	 * 이전 시스템의 [지표조회] 버튼(회의록 본문에 지표 표 삽입)을 옮긴 것 — 다만 저쪽은 손입력 값을
	 * 불러오고, 우리는 **산출값을 그대로** 넣는다. 18종 각각 calcIndicator 를 돌므로 가벼운 호출은 아니다
	 * — 버튼을 눌렀을 때 한 번만 부른다(화면 로드마다 부르지 말 것).
	 */
	@Override
	public List<Map<String, Object>> selectIndiSummary(String hospCd, String prdGb, String prdKey) throws Exception {
		List<Map<String, Object>> out = new ArrayList<>();
		if (prdKey == null || prdKey.length() < 4) return out;
		String inYear = prdKey.substring(0, 4);
		List<Map<String, Object>> list = mapper.selectIndiList(hospCd, inYear);
		if (list == null) return out;
		for (Map<String, Object> ind : list) {
			String cd = str(ind.get("indicd"));
			try {
				Map<String, Object> calc = calcIndicator(hospCd, cd, inYear);
				Map<String, Object> roll = rollupOf(calc, prdGb, prdKey);
				Map<String, Object> r = new LinkedHashMap<>();
				r.put("indinm", ind.get("indinm"));
				r.put("unit",   ind.get("unit"));
				r.put("rate",   roll == null ? null : roll.get("rate"));
				r.put("numer",  roll == null ? null : roll.get("numer"));
				r.put("denom",  roll == null ? null : roll.get("denom"));
				Object dec = ((Map<String, Object>) calc.get("indi")).get("decimals");
				r.put("decimals", dec == null ? 2 : dec);
				out.add(r);
			} catch (Exception skip) { /* 한 지표가 실패해도 나머지는 나간다 */ }
		}
		return out;
	}

	// ===================== 서식 3호: 라운딩 점검표 =====================

	@Override
	public Map<String, Object> selectRoundWithItems(String hospCd, String formGb, String roundYm) throws Exception {
		Map<String, Object> out = new LinkedHashMap<>();
		Map<String, Object> rnd = mapper.selectRound(hospCd, formGb, roundYm);
		out.put("round", rnd);
		if (rnd != null && rnd.get("rndseq") != null) {
			out.put("items", mapper.selectRoundItems(Long.parseLong(String.valueOf(rnd.get("rndseq")))));
		} else {
			out.put("items", new ArrayList<>());
		}
		return out;
	}

	@Override
	public long saveRound(String hospCd, String formGb, String roundYm, String checker,
	                      List<Map<String, Object>> items, String userId) throws Exception {
		Map<String, Object> p = new HashMap<>();
		p.put("hospCd", hospCd);
		p.put("formGb", formGb);
		p.put("roundYm", roundYm);
		p.put("checker", checker);
		p.put("regUser", userId);
		mapper.upsertRound(p);
		long rndSeq = Long.parseLong(String.valueOf(p.get("rndSeq")));
		mapper.deleteRoundItems(rndSeq);
		if (items != null && !items.isEmpty()) {
			int CHUNK = 300;
			for (int i = 0; i < items.size(); i += CHUNK) {
				Map<String, Object> ip = new HashMap<>();
				ip.put("rndSeq", rndSeq);
				ip.put("items", items.subList(i, Math.min(i + CHUNK, items.size())));
				mapper.insertRoundItems(ip);
			}
		}
		return rndSeq;
	}

	// ===================== 서식 1호: 회의록 =====================

	@Override
	public List<Map<String, Object>> selectMinutesList(String hospCd, String formGb, String inYear) throws Exception {
		return mapper.selectMinutesList(hospCd, formGb, inYear);
	}

	@Override
	public Map<String, Object> selectMinutes(String hospCd, long minSeq) throws Exception {
		return mapper.selectMinutes(hospCd, minSeq);
	}

	@Override
	public long saveMinutes(Map<String, Object> param) throws Exception {
		Object seq = param.get("minSeq");
		long minSeq = (seq == null || String.valueOf(seq).trim().isEmpty()) ? 0L
				: Long.parseLong(String.valueOf(seq).trim());
		if (minSeq > 0) {
			mapper.updateMinutes(param);
			return minSeq;
		}
		mapper.insertMinutes(param);
		Object gen = param.get("minSeq");   // useGeneratedKeys 가 채워 준다
		return (gen == null) ? 0L : Long.parseLong(String.valueOf(gen));
	}

	@Override
	public int deleteMinutes(Map<String, Object> param) throws Exception {
		return mapper.deleteMinutes(param);
	}

	// ===================== 지표정의서 =====================

	@Override
	public Map<String, Object> selectIndiDef(String hospCd, String indiCd) throws Exception {
		return mapper.selectIndiDef(hospCd, indiCd);
	}

	@Override
	public int saveIndiDef(Map<String, Object> param) throws Exception {
		return mapper.saveIndiDef(param);
	}

	@Override
	public int deleteIndiDef(String hospCd, String indiCd) throws Exception {
		return mapper.deleteIndiDef(hospCd, indiCd);
	}

	// ===================== 결재 =====================

	@Override
	public List<Map<String, Object>> selectApprLine(String hospCd) throws Exception {
		return mapper.selectApprLine(hospCd);
	}

	@Override
	public int saveApprLine(String hospCd, List<String> stepNames, String userId) throws Exception {
		// 통째로 교체 — 단계를 줄이면 뒤 단계 행이 남지 않아야 한다(남으면 결재가 끝나지 않는다)
		mapper.deleteApprLine(hospCd);
		int n = 0;
		if (stepNames != null) {
			for (int i = 0; i < stepNames.size(); i++) {
				String nm = stepNames.get(i) == null ? "" : stepNames.get(i).trim();
				if (nm.isEmpty()) continue;
				Map<String, Object> p = new HashMap<>();
				p.put("hospCd", hospCd);
				p.put("stepNo", n + 1);      // 빈 칸을 건너뛰므로 번호는 다시 매긴다
				p.put("stepNm", nm);
				p.put("regUser", userId);
				mapper.insertApprLine(p);
				n++;
			}
		}
		return n;
	}

	@Override
	public Map<String, Object> selectApprState(String hospCd, String indiCd, String prdGb, String prdKey)
			throws Exception {
		Map<String, Object> out = new LinkedHashMap<>();
		List<Map<String, Object>> line = mapper.selectApprLine(hospCd);
		Map<String, Object> rpt = mapper.selectReport(hospCd, indiCd, prdGb, prdKey);
		String status = (rpt == null) ? "DRAFT" : str(rpt.get("status"));
		if (status.isEmpty()) status = "DRAFT";
		int curStep = (rpt == null) ? 0 : intOf(rpt.get("curstep"), 0);

		out.put("line", line);
		out.put("status", status);
		out.put("curStep", curStep);
		out.put("lastStep", (line == null) ? 0 : line.size());
		out.put("hist", mapper.selectApprHist(hospCd, indiCd, prdGb, prdKey));

		// 확정 스냅샷 — 최종승인된 기간이면 동결된 수치를 함께 준다(인쇄물이 이 값을 쓴다)
		try {
			Map<String, Object> sp = new HashMap<>();
			sp.put("hospCd", hospCd); sp.put("indiCd", indiCd); sp.put("prdKey", prdKey);
			List<String> mms = monthsOfPeriod(prdGb, prdKey);
			if (mms.isEmpty()) mms.add("-");
			sp.put("months", mms);
			List<Map<String, Object>> stat = mapper.selectStat(sp);
			out.put("stat", stat);
			out.put("frozen", (stat != null && !stat.isEmpty()) ? "Y" : "N");
		} catch (Exception ignore) {
			out.put("frozen", "N");
		}
		return out;
	}

	@Override
	public Map<String, Object> actAppr(Map<String, Object> param) throws Exception {
		String hospCd = str(param.get("hospCd"));
		String indiCd = str(param.get("indiCd"));
		String prdGb  = str(param.get("prdGb"));
		String prdKey = str(param.get("prdKey"));
		String actGb  = str(param.get("actGb"));

		List<Map<String, Object>> line = mapper.selectApprLine(hospCd);
		int lastStep = (line == null) ? 0 : line.size();
		if (lastStep == 0) throw new Exception("결재선이 설정되어 있지 않습니다.");

		Map<String, Object> rpt = mapper.selectReport(hospCd, indiCd, prdGb, prdKey);
		String status = (rpt == null) ? "DRAFT" : str(rpt.get("status"));
		if (status.isEmpty()) status = "DRAFT";
		int curStep = (rpt == null) ? 0 : intOf(rpt.get("curstep"), 0);

		String newStatus;
		int    newStep;
		int    actStep;      // 이력에 남길 단계
		String actStepNm = "";

		if ("SUBMIT".equals(actGb)) {
			// 작성중·반려 상태에서만 올릴 수 있다
			if (!("DRAFT".equals(status) || "REJECT".equals(status)))
				throw new Exception("이미 상신된 문서입니다.");
			newStatus = "SUBMIT"; newStep = 0; actStep = 0;

		} else if ("CANCEL".equals(actGb)) {
			// 아무도 승인하지 않았을 때만 회수할 수 있다
			if (!"SUBMIT".equals(status)) throw new Exception("상신 상태가 아닙니다.");
			if (curStep > 0) throw new Exception("이미 결재가 진행되어 회수할 수 없습니다.");
			newStatus = "DRAFT"; newStep = 0; actStep = 0;

		} else if ("APPROVE".equals(actGb)) {
			if (!"SUBMIT".equals(status)) throw new Exception("상신된 문서가 아닙니다.");
			int want = curStep + 1;
			// ★두 사람이 동시에 눌렀을 때 순서가 꼬이는 것을 막는다 — 화면이 보낸 단계와 서버 상태를 대조
			int given = intOf(param.get("stepNo"), want);
			if (given != want)
				throw new Exception((want) + "단계 차례입니다. 화면을 새로고침해 주세요.");
			actStep = want;
			actStepNm = stepNmOf(line, want);
			newStep = want;
			newStatus = (want >= lastStep) ? "CONFIRM" : "SUBMIT";   // 마지막 단계면 최종 승인

		} else if ("REJECT".equals(actGb)) {
			if (!"SUBMIT".equals(status)) throw new Exception("상신된 문서가 아닙니다.");
			actStep = curStep + 1;
			actStepNm = stepNmOf(line, actStep);
			newStatus = "REJECT"; newStep = 0;                        // 반려하면 처음부터 다시

		} else if ("REOPEN".equals(actGb)) {
			// ★확정 취소 — 최종승인 뒤에도 되돌릴 길이 있어야 한다("이사장까지 하면 취소가 안 되나요", 2026-08-09).
			//   수정하려면 처음(작성중)으로 돌아가 다시 결재를 밟는다. 동결도 함께 푼다.
			//   누가 언제 왜 취소했는지는 이력에 남는다 — 사유 필수.
			if (!"CONFIRM".equals(status)) throw new Exception("최종 승인된 문서가 아닙니다.");
			if (str(param.get("note")).isEmpty()) throw new Exception("확정 취소 사유를 입력해 주세요.");
			actStep = 0; newStatus = "DRAFT"; newStep = 0;

		} else {
			throw new Exception("알 수 없는 결재 동작입니다.");
		}

		Map<String, Object> h = new HashMap<>();
		h.put("hospCd", hospCd); h.put("indiCd", indiCd);
		h.put("prdGb", prdGb);   h.put("prdKey", prdKey);
		h.put("stepNo", actStep); h.put("stepNm", actStepNm);
		h.put("actGb", actGb);
		h.put("actUser", param.get("actUser"));
		h.put("actNm",   param.get("actNm"));
		h.put("note",    param.get("note"));
		mapper.insertAppr(h);

		Map<String, Object> u = new HashMap<>();
		u.put("hospCd", hospCd); u.put("indiCd", indiCd);
		u.put("prdGb", prdGb);   u.put("prdKey", prdKey);
		u.put("status", newStatus); u.put("curStep", newStep);
		u.put("updUser", param.get("actUser"));
		mapper.updateReportAppr(u);

		// ★수치 동결 — 최종승인되면 그 기간 값을 붙잡아 두고, 결재가 풀리면 놓아 준다.
		//   (결재 이력·상태 갱신이 끝난 뒤에 한다 — 동결이 실패해도 결재는 남아야 한다)
		if ("CONFIRM".equals(newStatus)) {
			freezeStat(hospCd, indiCd, prdGb, prdKey, str(param.get("actUser")));
		} else if ("REJECT".equals(newStatus)
				|| ("DRAFT".equals(newStatus) && ("CANCEL".equals(actGb) || "REOPEN".equals(actGb)))) {
			unfreezeStat(hospCd, indiCd, prdGb, prdKey);
		}

		Map<String, Object> res = new LinkedHashMap<>();
		res.put("status", newStatus);
		res.put("curStep", newStep);
		res.put("lastStep", lastStep);
		return res;
	}

	/**
	 * 기간(prdGb+prdKey)에 속한 월 목록 — '2026Q1' → [202601,202602,202603].
	 * 스냅샷의 월별 행과 조회 조건에 함께 쓴다.
	 */
	private List<String> monthsOfPeriod(String prdGb, String prdKey) {
		List<String> out = new ArrayList<>();
		if (prdKey == null || prdKey.length() < 4) return out;
		String yy = prdKey.substring(0, 4);
		int from = 1, to = 12;
		if ("Q".equals(prdGb) && prdKey.length() >= 6) {
			int q = Integer.parseInt(prdKey.substring(5, 6));
			from = (q - 1) * 3 + 1; to = from + 2;
		} else if ("H".equals(prdGb) && prdKey.length() >= 6) {
			boolean h1 = prdKey.charAt(5) == '1';
			from = h1 ? 1 : 7; to = h1 ? 6 : 12;
		}
		for (int m = from; m <= to; m++) out.add(yy + (m < 10 ? ("0" + m) : String.valueOf(m)));
		return out;
	}

	/** 그 기간의 rollup 한 덩어리를 골라온다(Q1~Q4 / H1·H2 / 연간). */
	private Map<String, Object> rollupOf(Map<String, Object> calc, String prdGb, String prdKey) {
		String key = (prdKey.length() > 4) ? prdKey.substring(4) : prdKey;   // 2026Q1 → Q1
		@SuppressWarnings("unchecked")
		List<Map<String, Object>> qs = (List<Map<String, Object>>) calc.get("quarters");
		@SuppressWarnings("unchecked")
		List<Map<String, Object>> hs = (List<Map<String, Object>>) calc.get("halves");
		if ("Q".equals(prdGb) && qs != null) {
			for (Map<String, Object> q : qs) if (key.equals(str(q.get("key")))) return q;
		} else if ("H".equals(prdGb) && hs != null) {
			for (Map<String, Object> h : hs) if (key.equals(str(h.get("key")))) return h;
		}
		@SuppressWarnings("unchecked")
		Map<String, Object> y = (Map<String, Object>) calc.get("year");
		return y;
	}

	/**
	 * 최종승인 시 수치 동결 — 그 기간의 합계 1행 + 그 기간에 속한 월행을 저장한다.
	 * ★실패해도 결재 자체는 되돌리지 않는다(동결은 부가 기능이고, 결재가 더 중요하다).
	 */
	private void freezeStat(String hospCd, String indiCd, String prdGb, String prdKey, String user) {
		try {
			String yy = prdKey.substring(0, 4);
			Map<String, Object> calc = calcIndicator(hospCd, indiCd, yy);
			List<String> mms = monthsOfPeriod(prdGb, prdKey);

			Map<String, Object> roll = rollupOf(calc, prdGb, prdKey);
			if (roll != null) saveOneStat(hospCd, indiCd, prdGb, prdKey,
					roll.get("numer"), roll.get("denom"), roll.get("rate"), user);

			@SuppressWarnings("unchecked")
			List<Map<String, Object>> months = (List<Map<String, Object>>) calc.get("months");
			if (months != null) for (Map<String, Object> m : months) {
				String key = yy + str(m.get("mm"));
				if (!mms.contains(key)) continue;
				saveOneStat(hospCd, indiCd, "M", key, m.get("numer"), m.get("denom"), m.get("rate"), user);
			}
		} catch (Exception ignore) { }
	}

	private void saveOneStat(String hospCd, String indiCd, String prdGb, String prdKey,
	                         Object numer, Object denom, Object rate, String user) throws Exception {
		Map<String, Object> p = new HashMap<>();
		p.put("hospCd", hospCd); p.put("indiCd", indiCd);
		p.put("prdGb", prdGb);   p.put("prdKey", prdKey);
		p.put("numer", numer);   p.put("denom", denom);   p.put("rate", rate);
		p.put("confirmUser", user);
		mapper.saveStat(p);
	}

	/** 결재가 풀리면(반려·회수) 동결도 푼다 — 확정 안 된 값이 확정본처럼 남으면 안 된다. */
	private void unfreezeStat(String hospCd, String indiCd, String prdGb, String prdKey) {
		try {
			Map<String, Object> p = new HashMap<>();
			p.put("hospCd", hospCd); p.put("indiCd", indiCd); p.put("prdKey", prdKey);
			List<String> mms = monthsOfPeriod(prdGb, prdKey);
			if (mms.isEmpty()) mms.add("-");     // IN () 는 문법오류라 더미를 넣는다
			p.put("months", mms);
			mapper.deleteStat(p);
		} catch (Exception ignore) { }
	}

	private String stepNmOf(List<Map<String, Object>> line, int stepNo) {
		if (line == null) return "";
		for (Map<String, Object> r : line) {
			if (intOf(r.get("stepno"), -1) == stepNo) return str(r.get("stepnm"));
		}
		return "";
	}

	@Override
	public Map<String, Object> selectManual(String hospCd, String indiCd, String inYear, String valGb, String axisCd) throws Exception {
		return mapper.selectManual(hospCd, indiCd, inYear, valGb, axisCd);
	}

	@Override
	public List<Map<String, Object>> selectManualAxes(String hospCd, String indiCd, String inYear) throws Exception {
		return mapper.selectManualAxes(hospCd, indiCd, inYear);
	}

	@Override
	public int saveManual(QpsManualDTO dto) throws Exception {
		return mapper.saveManual(dto);
	}

	@Override
	public int saveCensus(QpsCensusDTO dto) throws Exception {
		return mapper.saveCensus(dto);
	}

	/**
	 * 재원일수 자동산출 — 입퇴원 자료로 '해당 월 일일 재원환자 수의 합'을 계산한다.
	 *
	 * 산정 기준(화면에도 명시):
	 *   · 입원일 포함, 퇴원일 제외 (당일 입·퇴원은 1일로 본다)
	 *   · 퇴원일이 비어 있으면(재원중) 오늘까지만 센다 — 미래 월에 유령 재원일이 생기지 않게
	 *   · 자료의 마지막 월 이후는 퇴원 기록이 아직 안 올라와 부풀 수 있다 → 그래서 자동 '저장'이 아니라
	 *     칸만 채우고 사람이 확인 후 저장한다.
	 */
	@Override
	public Map<String, Object> calcCensusFromIpwon(String hospCd, String inYear) throws Exception {
		int year = Integer.parseInt(inYear);
		List<Map<String, Object>> stays = mapper.selectStaysForYear(hospCd, inYear + "0101", inYear + "1231");

		java.time.format.DateTimeFormatter F = java.time.format.DateTimeFormatter.BASIC_ISO_DATE;
		java.time.LocalDate capOpen = java.time.LocalDate.now().plusDays(1);   // 재원중은 오늘까지(끝 배타)
		long[] days = new long[12];
		int used = 0, skipped = 0;

		if (stays != null) {
			for (Map<String, Object> s : stays) {
				java.time.LocalDate d1, d2;
				try { d1 = java.time.LocalDate.parse(str(s.get("indt")), F); }
				catch (Exception e) { skipped++; continue; }
				String out = str(s.get("outdt"));
				if (out.isEmpty()) {
					d2 = capOpen;
				} else {
					try { d2 = java.time.LocalDate.parse(out, F); } catch (Exception e) { d2 = capOpen; }
				}
				if (!d2.isAfter(d1)) d2 = d1.plusDays(1);   // 당일 입·퇴원(또는 역전 자료) = 1일
				if (!d2.isAfter(java.time.LocalDate.of(year, 1, 1))) { skipped++; continue; }
				used++;
				for (int mo = 1; mo <= 12; mo++) {
					java.time.LocalDate ms = java.time.LocalDate.of(year, mo, 1);
					java.time.LocalDate me = ms.plusMonths(1);
					java.time.LocalDate from = d1.isAfter(ms) ? d1 : ms;
					java.time.LocalDate to   = d2.isBefore(me) ? d2 : me;
					if (to.isAfter(from)) days[mo - 1] += java.time.temporal.ChronoUnit.DAYS.between(from, to);
				}
			}
		}

		Map<String, Object> out = new LinkedHashMap<>();
		for (int mo = 1; mo <= 12; mo++) out.put(String.format("m%02d", mo), days[mo - 1]);
		out.put("stays", used);
		out.put("skipped", skipped);
		return out;
	}

	@Override
	public Map<String, Object> selectBreakdown(String hospCd, String incidGb, String fromDt, String toDt, String minLevel) throws Exception {
		List<Map<String, Object>> rows = mapper.selectBreakdown(hospCd, incidGb, fromDt, toDt, minLevel);
		// axis 별로 묶어서 화면이 바로 표로 그릴 수 있게 만든다
		Map<String, Object> out = new LinkedHashMap<>();
		if (rows != null) {
			for (Map<String, Object> r : rows) {
				String axis = str(r.get("axis"));
				@SuppressWarnings("unchecked")
				List<Map<String, Object>> list = (List<Map<String, Object>>) out.get(axis);
				if (list == null) { list = new ArrayList<>(); out.put(axis, list); }
				Map<String, Object> item = new HashMap<>();
				item.put("code", r.get("code"));
				item.put("cnt",  r.get("cnt"));
				list.add(item);
			}
		}
		return out;
	}

	@Override
	public Map<String, Object> selectReport(String hospCd, String indiCd, String prdGb, String prdKey) throws Exception {
		return mapper.selectReport(hospCd, indiCd, prdGb, prdKey);
	}

	@Override
	public int saveReport(Map<String, Object> param) throws Exception {
		return mapper.saveReport(param);
	}

	/**
	 * 지표 산출 — 월 → 분기 → 반기 → 연 순서로 누적한다.
	 *
	 * ★분기 율은 '월별 율의 평균'이 아니라 '분기 분자합 ÷ 분기 분모합' 이다.
	 *   기존 프로그램 실측값이 그 방식이었다(1분기 2건/3,000일 = 0.67‰. 월별 2.00/0/0 의 산술평균 0.67 과
	 *   우연히 같아 보이지만, 월별 재원일수가 다르면 갈라진다 — 분모합 방식이 맞다).
	 */
	@Override
	public Map<String, Object> calcIndicator(String hospCd, String indiCd, String inYear) throws Exception {

		Map<String, Object> indi = mapper.selectQpsIndi(hospCd, indiCd);
		if (indi == null) indi = new HashMap<>();

		int multiplier = intOf(indi.get("multiplier"), 1000);
		int decimals   = intOf(indi.get("decimals"), 2);
		// ★MANUAL 은 분모도 수기일 수 있어 빈 값을 'INDAYS' 로 메우면 안 된다 —
		//   TAT·재택복귀·불만고충·만족도는 분모가 재원일수가 아니라 '전체 건수'다.
		String denomGb = str(indi.get("denomgb"));
		String numerSrcTmp = str(indi.get("numersrc"));
		if (denomGb.isEmpty() && !"MANUAL".equals(numerSrcTmp)) denomGb = "INDAYS";
		String incidGb = str(indi.get("incidgb"));
		if (incidGb.isEmpty()) incidGb = indiCd;
		String minLevel = str(indi.get("minlevel"));   // 비면 전건

		// 원천에 따라 분자·분모가 갈린다:
		//   INCIDENT = 사고보고 입력분(분자) + 재원일수(분모)
		//   PATVAL   = 환자평가표 자동집계(분자) + 재원일수(분모)
		//   MONITOR  = 관찰기록에서 분자(수행)·분모(관찰)를 동시에 — 재원일수를 안 쓴다(손위생 등)
		//   MANUAL   = 병원이 대장을 보고 월별로 적은 값(TBL_QPS_MANUAL). 분모는 지표에 따라
		//              재원일수/직원수(DENOM_GB 있음)이거나 역시 수기(DENOM_GB 없음)다.
		String numerSrc = str(indi.get("numersrc"));
		List<Map<String, Object>> months = new ArrayList<>();
		boolean hasDenom;

		if ("MANUAL".equals(numerSrc)) {
			// 산출은 늘 **총계 행(axis='')** 만 읽는다 — 정규/응급 상세는 분석 탭 표에만 쓴다
			Map<String, Object> mNumer = mapper.selectManual(hospCd, indiCd, inYear, "NUMER", "");
			// 분모: DENOM_GB 가 있으면 기존 분모 마스터(재원일수·직원수), 없으면 수기 DENOM 행
			boolean denomFromCensus = !denomGb.isEmpty();
			Map<String, Object> mDenom = denomFromCensus
					? mapper.selectCensus(hospCd, denomGb, inYear)
					: mapper.selectManual(hospCd, indiCd, inYear, "DENOM", "");
			for (String mm : MM) {
				int numer = (mNumer == null) ? 0 : intOf(mNumer.get("m" + mm), 0);
				int denom = (mDenom == null) ? 0 : intOf(mDenom.get("m" + mm), 0);
				Map<String, Object> m = new LinkedHashMap<>();
				m.put("mm", mm);
				m.put("numer", numer);
				m.put("denom", denom);
				m.put("rate", rate(numer, denom, multiplier, decimals));
				months.add(m);
			}
			hasDenom = (mDenom != null);
		} else if ("MONITOR".equals(numerSrc)) {
			Map<String, int[]> byMm = new HashMap<>();   // mm -> [numer, denom]
			List<Map<String, Object>> mrows = mapper.selectMonthlyMonitor(hospCd, indiCd, inYear);
			if (mrows != null) for (Map<String, Object> r : mrows) {
				byMm.put(str(r.get("mm")), new int[]{ intOf(r.get("numer"), 0), intOf(r.get("denom"), 0) });
			}
			int denomTot = 0;
			for (String mm : MM) {
				int[] v = byMm.containsKey(mm) ? byMm.get(mm) : new int[]{0, 0};
				denomTot += v[1];
				Map<String, Object> m = new LinkedHashMap<>();
				m.put("mm", mm);
				m.put("numer", v[0]);
				m.put("denom", v[1]);
				m.put("rate", rate(v[0], v[1], multiplier, decimals));
				months.add(m);
			}
			hasDenom = denomTot > 0;
		} else {
			Map<String, Integer> numerByMm = new HashMap<>();
			// PATVAL 안에서도 지표마다 원천 항목이 다르다 — INCID_GB 로 가른다
			//   BEDSORE = 신규발생(NEW_ULCER)+발생일 / UTI = 유병 플래그라 '환자별 최초'로 센다
			List<Map<String, Object>> nrows;
			if ("PATVAL".equals(numerSrc)) {
				nrows = "UTI".equals(incidGb)
						? mapper.selectMonthlyNumerPatvalUti(hospCd, inYear)
						: mapper.selectMonthlyNumerPatval(hospCd, inYear);
			} else {
				nrows = mapper.selectMonthlyNumer(hospCd, incidGb, inYear, minLevel);
			}
			if (nrows != null) for (Map<String, Object> r : nrows) {
				numerByMm.put(str(r.get("mm")), intOf(r.get("cnt"), 0));
			}
			Map<String, Object> census = mapper.selectCensus(hospCd, denomGb, inYear);
			for (String mm : MM) {
				int numer = numerByMm.containsKey(mm) ? numerByMm.get(mm) : 0;
				int denom = (census == null) ? 0 : intOf(census.get("m" + mm), 0);
				Map<String, Object> m = new LinkedHashMap<>();
				m.put("mm", mm);
				m.put("numer", numer);
				m.put("denom", denom);
				m.put("rate", rate(numer, denom, multiplier, decimals));
				months.add(m);
			}
			hasDenom = census != null;
		}

		List<Map<String, Object>> quarters = new ArrayList<>();
		for (int q = 0; q < 4; q++) {
			quarters.add(rollup("Q" + (q + 1), months, q * 3, q * 3 + 3, multiplier, decimals));
		}
		List<Map<String, Object>> halves = new ArrayList<>();
		halves.add(rollup("H1", months, 0, 6,  multiplier, decimals));
		halves.add(rollup("H2", months, 6, 12, multiplier, decimals));

		Map<String, Object> out = new LinkedHashMap<>();
		out.put("indi",     indi);
		out.put("months",   months);
		out.put("quarters", quarters);
		out.put("halves",   halves);
		out.put("year",     rollup(inYear, months, 0, 12, multiplier, decimals));
		out.put("hasCensus", hasDenom ? "Y" : "N");
		return out;
	}

	/** [from, to) 구간의 분자합·분모합으로 율을 다시 계산한다. */
	private Map<String, Object> rollup(String key, List<Map<String, Object>> months,
	                                   int from, int to, int multiplier, int decimals) {
		int numer = 0, denom = 0;
		for (int i = from; i < to && i < months.size(); i++) {
			numer += intOf(months.get(i).get("numer"), 0);
			denom += intOf(months.get(i).get("denom"), 0);
		}
		Map<String, Object> m = new LinkedHashMap<>();
		m.put("key", key);
		m.put("numer", numer);
		m.put("denom", denom);
		m.put("rate", rate(numer, denom, multiplier, decimals));
		return m;
	}

	/** 분모 0 이면 null — 화면에서 '-' 로 표시한다(0.00 으로 찍으면 '자료 없음'과 '발생 0'이 섞인다). */
	private BigDecimal rate(int numer, int denom, int multiplier, int decimals) {
		if (denom <= 0) return null;
		return new BigDecimal(numer)
				.multiply(new BigDecimal(multiplier))
				.divide(new BigDecimal(denom), decimals, RoundingMode.HALF_UP);
	}

	// ===================== 공통 첨부 =====================
	@Override
	public java.util.List<Map<String, Object>> selectQpsFileList(String hospCd, String refGb, String refKey) throws Exception {
		return mapper.selectQpsFileList(hospCd, refGb, refKey);
	}
	@Override
	public int insertQpsFile(egovframework.wnn_medcost.qps.model.QpsFileDTO dto) throws Exception {
		return mapper.insertQpsFile(dto);
	}
	@Override
	public int deleteQpsFile(egovframework.wnn_medcost.qps.model.QpsFileDTO dto) throws Exception {
		return mapper.deleteQpsFile(dto);
	}
	@Override
	public java.util.List<Map<String, Object>> selectQpsFileCounts(String hospCd, String refGb) throws Exception {
		return mapper.selectQpsFileCounts(hospCd, refGb);
	}

	/* ── QPS 담당자(자료실 수정 권한) ────────────────────────────── */

	@Override
	public java.util.List<Map<String, Object>> selectHospUsers(String hospCd) throws Exception {
		return mapper.selectHospUsers(hospCd);
	}

	@Override
	public String selectUserMainGu(String hospCd, String userId) throws Exception {
		return mapper.selectUserMainGu(hospCd, userId);
	}

	@Override
	public int selectQpsMgrCount(String hospCd) throws Exception {
		return mapper.selectQpsMgrCount(hospCd);
	}

	@Override
	public int selectQpsMgrYn(String hospCd, String userId) throws Exception {
		return mapper.selectQpsMgrYn(hospCd, userId);
	}

	/** 명단 통째 교체 — 지운 뒤 다시 넣는다. 화면이 체크한 목록이 곧 최종 명단. */
	@Override
	public int saveQpsMgr(String hospCd, java.util.List<String> userIds, String regUser) throws Exception {
		mapper.deleteQpsMgrAll(hospCd);
		int n = 0;
		if (userIds != null) for (String u : userIds) {
			if (u == null || u.trim().isEmpty()) continue;
			n += mapper.insertQpsMgr(hospCd, u.trim(), regUser);
		}
		return n;
	}

	@Override
	public Map<String, Object> selectQpsFileOne(Long fileSeq, String hospCd) throws Exception {
		return mapper.selectQpsFileOne(fileSeq, hospCd);
	}

	private static String str(Object o) { return (o == null) ? "" : String.valueOf(o).trim(); }

	private static int intOf(Object o, int def) {
		if (o == null) return def;
		try { return new BigDecimal(String.valueOf(o).trim().replace(",", "")).intValue(); }
		catch (Exception e) { return def; }
	}

	// ===================== 감염종합보고 (3종 통합) =====================

	@Override
	public List<Map<String, Object>> selectInfRptList(String hospCd, String rptGb, String inYear) throws Exception {
		return mapper.selectInfRptList(hospCd, rptGb, inYear);
	}

	@Override
	public Map<String, Object> selectInfRptWithMem(String hospCd, long rptSeq) throws Exception {
		Map<String, Object> out = new LinkedHashMap<>();
		Map<String, Object> doc = mapper.selectInfRpt(hospCd, rptSeq);
		out.put("doc", doc);
		out.put("members", doc == null ? new ArrayList<>() : mapper.selectInfRptMem(rptSeq));
		return out;
	}

	/** 저장 — 새 문서면 insert, 있으면 update. 명단은 통째 교체(부분 수정 API 를 두지 않는다). */
	@Override
	public long saveInfRpt(Map<String, Object> p, List<Map<String, Object>> members) throws Exception {
		long seq = 0;
		Object s = p.get("rptSeq");
		if (s != null && !String.valueOf(s).trim().isEmpty()) {
			try { seq = Long.parseLong(String.valueOf(s).trim()); } catch (Exception ignore) { seq = 0; }
		}
		if (seq > 0) { mapper.updateInfRpt(p); }
		else { mapper.insertInfRpt(p); seq = Long.parseLong(String.valueOf(p.get("rptSeq"))); }

		mapper.deleteInfRptMem(seq);
		if (members != null && !members.isEmpty()) {
			Map<String, Object> mp = new HashMap<>();
			mp.put("rptSeq", seq);
			mp.put("items", members);
			mapper.insertInfRptMem(mp);
		}
		return seq;
	}

	@Override
	public int deleteInfRpt(Map<String, Object> param) throws Exception {
		return mapper.deleteInfRpt(param);
	}

	// ============ 불만고충 (처리대장 · 건별 처리결과 · 지표분석보고서) ============

	@Override
	public List<Map<String, Object>> selectCmplList(String hospCd, String inYear) throws Exception {
		return mapper.selectCmplList(hospCd, inYear);
	}

	/**
	 * 처리대장 저장 — ★행별 upsert 다. 「통째 교체」가 아니다.
	 *
	 * 계획서·라운딩은 항목행을 지우고 다시 넣지만, 대장의 각 건에는 개선활동 처리결과가
	 * CMPL_SEQ 로 1:1 매달려 있다. 통째 교체하면 SEQ 가 새로 발급되어 <b>그 상세가 통째로 미아</b>가 된다.
	 * 삭제는 화면에서 명시적으로(소프트삭제) 한다.
	 *
	 * @return 저장한 행 수
	 */
	@Override
	public long saveCmplRows(String hospCd, String inYear, List<Map<String, Object>> rows, String regUser)
			throws Exception {
		if (rows == null || rows.isEmpty()) return 0;
		long n = 0;
		for (Map<String, Object> r : rows) {
			Map<String, Object> p = new HashMap<>();
			p.put("hospCd", hospCd);
			p.put("inYear", inYear);
			p.put("recvDt",  str(r.get("recvdt")));
			// ★접수월은 접수일에서 채운다 — 둘이 어긋나면 월별 집계가 통째로 틀어진다.
			//   화면이 월을 직접 준 경우(접수일 없이 월만 아는 건)에는 그 값을 쓴다.
			String mm = str(r.get("recvmm"));
			String dt = str(r.get("recvdt")).replace("-", "");
			if (dt.length() == 8) mm = dt.substring(4, 6);
			p.put("recvMm", mm.isEmpty() ? null : mm);
			p.put("recvCd",    nz(r.get("recvcd")));
			p.put("personNm",  str(r.get("personnm")));
			p.put("personCd",  nz(r.get("personcd")));
			p.put("termDays",  intOrNull(r.get("termdays")));
			p.put("typeCd",    nz(r.get("typecd")));
			p.put("content",   str(r.get("content")));
			p.put("resultTxt", str(r.get("resulttxt")));
			p.put("replyDt",   str(r.get("replydt")));
			p.put("replyCd",   nz(r.get("replycd")));
			p.put("noreplyCd", nz(r.get("noreplycd")));
			p.put("regUser",   regUser);

			long seq = 0;
			Object sq = r.get("cmplseq");
			if (sq != null && !String.valueOf(sq).trim().isEmpty()) {
				try { seq = Long.parseLong(String.valueOf(sq).trim()); } catch (Exception ignore) { seq = 0; }
			}
			if (seq > 0) { p.put("cmplSeq", seq); mapper.updateCmpl(p); }
			else { mapper.insertCmpl(p); }
			n++;
		}
		return n;
	}

	@Override
	public int deleteCmpl(Map<String, Object> param) throws Exception {
		return mapper.deleteCmpl(param);
	}

	@Override
	public Map<String, Object> selectCmplAct(String hospCd, long cmplSeq) throws Exception {
		return mapper.selectCmplAct(hospCd, cmplSeq);
	}

	@Override
	public int saveCmplAct(Map<String, Object> param) throws Exception {
		return mapper.upsertCmplAct(param);
	}

	@Override
	public Map<String, Object> selectCmplRpt(String hospCd, String inYear, String halfGb) throws Exception {
		return mapper.selectCmplRpt(hospCd, inYear, halfGb);
	}

	@Override
	public int saveCmplRpt(Map<String, Object> param) throws Exception {
		return mapper.upsertCmplRpt(param);
	}

	/**
	 * 지표분석보고서 수치 — <b>전부 처리대장에서 집계</b>한다(저장하지 않는다).
	 * halfGb 1=전반기(01~06) · 2=후반기(07~12) · 그 밖이면 연간(01~12).
	 */
	@Override
	public Map<String, Object> selectCmplStat(String hospCd, String inYear, String halfGb) throws Exception {
		String frMm = "1".equals(halfGb) ? "01" : "2".equals(halfGb) ? "07" : "01";
		String toMm = "1".equals(halfGb) ? "06" : "2".equals(halfGb) ? "12" : "12";

		Map<String, Object> p = new HashMap<>();
		p.put("hospCd", hospCd); p.put("inYear", inYear);
		p.put("frMm", frMm);     p.put("toMm", toMm);

		Map<String, Object> out = new LinkedHashMap<>();
		out.put("frMm", frMm);
		out.put("toMm", toMm);
		out.put("months", mapper.selectCmplStatMonth(p));
		out.put("typeMonth", mapper.selectCmplStatTypeMonth(p));
		out.put("term", mapper.selectCmplStatTerm(p));
		out.put("half", mapper.selectCmplStatHalf(p));   // 반기는 연간 기준(범위 무관)
		for (String gb : new String[] { "TYPE", "RECV", "REPLY", "NOREPLY" }) {
			Map<String, Object> q = new HashMap<>(p);
			q.put("gb", gb);
			out.put("ax" + gb, mapper.selectCmplStatAxis(q));
		}
		return out;
	}

	/** 빈 문자열은 코드칸에 넣지 않는다 — 집계에서 '' 축이 하나 더 생긴다. */
	private static String nz(Object o) {
		String v = str(o);
		return v.isEmpty() ? null : v;
	}

	// ============ 만족도 개선활동 결과보고서 ============

	@Override
	public List<Map<String, Object>> selectSrvImprList(String hospCd, String inYear) throws Exception {
		return mapper.selectSrvImprList(hospCd, inYear);
	}

	@Override
	public Map<String, Object> selectSrvImprWithItems(String hospCd, long imprSeq) throws Exception {
		Map<String, Object> out = new LinkedHashMap<>();
		Map<String, Object> doc = mapper.selectSrvImpr(hospCd, imprSeq);
		out.put("doc", doc);
		out.put("items", doc == null ? new ArrayList<>() : mapper.selectSrvImprItems(imprSeq));
		return out;
	}

	/** 저장 — 새 문서면 insert, 있으면 update. 표는 통째 교체(감염종합보고 명단과 같은 방식). */
	@Override
	public long saveSrvImpr(Map<String, Object> p, List<Map<String, Object>> items) throws Exception {
		long seq = 0;
		Object s = p.get("imprSeq");
		if (s != null && !String.valueOf(s).trim().isEmpty()) {
			try { seq = Long.parseLong(String.valueOf(s).trim()); } catch (Exception ignore) { seq = 0; }
		}
		if (seq > 0) { mapper.updateSrvImpr(p); }
		else { mapper.insertSrvImpr(p); seq = Long.parseLong(String.valueOf(p.get("imprSeq"))); }

		mapper.deleteSrvImprItems(seq);
		if (items != null && !items.isEmpty()) {
			Map<String, Object> mp = new HashMap<>();
			mp.put("imprSeq", seq);
			mp.put("items", items);
			mapper.insertSrvImprItems(mp);
		}
		return seq;
	}

	@Override
	public int deleteSrvImpr(Map<String, Object> param) throws Exception {
		return mapper.deleteSrvImpr(param);
	}

	// ============ 감염관리 우선순위 사정 도구 ============

	@Override
	public List<Map<String, Object>> selectInfRiskList(String hospCd, String inYear) throws Exception {
		return mapper.selectInfRiskList(hospCd, inYear);
	}

	@Override
	public List<Map<String, Object>> selectInfRiskDef() throws Exception {
		return mapper.selectInfRiskDef();
	}

	@Override
	public Map<String, Object> selectInfRiskWithItems(String hospCd, long riskSeq) throws Exception {
		Map<String, Object> out = new LinkedHashMap<>();
		Map<String, Object> doc = mapper.selectInfRisk(hospCd, riskSeq);
		out.put("doc", doc);
		List<Map<String, Object>> items = (doc == null) ? null : mapper.selectInfRiskItems(riskSeq);
		// 항목이 없으면 기본 31행을 깔아 준다 — 화면이 빈 표로 시작하지 않게
		if (items == null || items.isEmpty()) items = mapper.selectInfRiskDef();
		out.put("items", items);
		return out;
	}

	/**
	 * 저장 — 위험점수는 <서버가> 계산해 넣는다.
	 * ★화면에서 온 score 를 믿지 않는다. 원본은 사람이 곱셈을 손으로 해 틀릴 수 있었고,
	 *   여기서는 그 계산을 옮겨오는 것이 이식의 핵심이다. 세 값 중 하나라도 비면 점수는 null.
	 */
	@Override
	public long saveInfRisk(Map<String, Object> p, List<Map<String, Object>> items) throws Exception {
		mapper.insertInfRisk(p);
		long seq = Long.parseLong(String.valueOf(p.get("riskSeq")));

		mapper.deleteInfRiskItems(seq);
		if (items != null && !items.isEmpty()) {
			for (Map<String, Object> it : items) {
				Integer pv = intOrNull(it.get("pval")), sv = intOrNull(it.get("sval")), rv = intOrNull(it.get("rval"));
				it.put("pval", pv); it.put("sval", sv); it.put("rval", rv);
				it.put("score", (pv == null || sv == null || rv == null) ? null : (pv * sv * rv));
			}
			int CHUNK = 100;
			for (int i = 0; i < items.size(); i += CHUNK) {
				Map<String, Object> ip = new HashMap<>();
				ip.put("riskSeq", seq);
				ip.put("items", items.subList(i, Math.min(i + CHUNK, items.size())));
				mapper.insertInfRiskItems(ip);
			}
		}
		return seq;
	}

	@Override
	public int deleteInfRisk(Map<String, Object> param) throws Exception {
		return mapper.deleteInfRisk(param);
	}

	// ============ 감염병환자 월별 리스트 ============

	@Override
	public Map<String, Object> selectInfPatWithItems(String hospCd, String ipatYm) throws Exception {
		Map<String, Object> out = new LinkedHashMap<>();
		Map<String, Object> doc = mapper.selectInfPat(hospCd, ipatYm);
		out.put("doc", doc);
		out.put("items", (doc == null || doc.get("ipatseq") == null)
				? new ArrayList<>()
				: mapper.selectInfPatItems(Long.parseLong(String.valueOf(doc.get("ipatseq")))));
		return out;
	}

	@Override
	public long saveInfPat(Map<String, Object> p, List<Map<String, Object>> items) throws Exception {
		mapper.upsertInfPat(p);
		long seq = Long.parseLong(String.valueOf(p.get("ipatSeq")));
		mapper.deleteInfPatItems(seq);
		if (items != null && !items.isEmpty()) {
			Map<String, Object> ip = new HashMap<>();
			ip.put("ipatSeq", seq);
			ip.put("items", items);
			mapper.insertInfPatItems(ip);
		}
		return seq;
	}

	// ============ 감염관리 전담자 ============

	@Override
	public List<Map<String, Object>> selectInfStaffList(String hospCd) throws Exception {
		return mapper.selectInfStaffList(hospCd);
	}

	@Override
	public Map<String, Object> selectInfStaffAll(String hospCd, long stfSeq) throws Exception {
		Map<String, Object> out = new LinkedHashMap<>();
		Map<String, Object> doc = mapper.selectInfStaff(hospCd, stfSeq);
		out.put("doc", doc);
		out.put("edus",   doc == null ? new ArrayList<>() : mapper.selectInfStaffEdu(stfSeq));
		out.put("duties", doc == null ? new ArrayList<>() : mapper.selectInfStaffDuty(stfSeq));
		return out;
	}

	@Override
	public long saveInfStaff(Map<String, Object> p,
	                         List<Map<String, Object>> edus,
	                         List<Map<String, Object>> duties) throws Exception {
		long seq = 0;
		Object s = p.get("stfSeq");
		if (s != null && !String.valueOf(s).trim().isEmpty()) {
			try { seq = Long.parseLong(String.valueOf(s).trim()); } catch (Exception ignore) { seq = 0; }
		}
		if (seq > 0) { mapper.updateInfStaff(p); }
		else { mapper.insertInfStaff(p); seq = Long.parseLong(String.valueOf(p.get("stfSeq"))); }

		mapper.deleteInfStaffEdu(seq);
		if (edus != null && !edus.isEmpty()) {
			Map<String, Object> ep = new HashMap<>(); ep.put("stfSeq", seq); ep.put("items", edus);
			mapper.insertInfStaffEdu(ep);
		}
		mapper.deleteInfStaffDuty(seq);
		if (duties != null && !duties.isEmpty()) {
			Map<String, Object> dp = new HashMap<>(); dp.put("stfSeq", seq); dp.put("items", duties);
			mapper.insertInfStaffDuty(dp);
		}
		return seq;
	}

	@Override
	public int deleteInfStaff(Map<String, Object> param) throws Exception {
		return mapper.deleteInfStaff(param);
	}

	/** 빈 칸은 0 이 아니라 null 이다 — '평가 안 함'과 '1점'을 구별해야 한다. */
	private static Integer intOrNull(Object o) {
		if (o == null) return null;
		String s = String.valueOf(o).trim();
		if (s.isEmpty()) return null;
		try { return Integer.valueOf(new BigDecimal(s).intValue()); } catch (Exception e) { return null; }
	}

	// ═══ 환자만족도 조사 : 설문 ═══════════════════════════════════════
	//  ★배점은 SCORE 에 그대로 저장한다(5=매우만족 … 1=매우불만족).
	//    설문지의 보기번호와 역순이라 화면이 뒤집어 보내야 하고,
	//    여기서 한 번 더 범위를 막아 잘못된 값이 들어가지 않게 한다.

	@Override
	public Map<String, Object> selectSurveyBase(String hospCd, String inYear) throws Exception {
		Map<String, Object> out = new HashMap<>();
		out.put("def", mapper.selectSrvDef());
		Map<String, Object> p = new HashMap<>();
		p.put("hospCd", hospCd);
		p.put("inYear", inYear);
		out.put("list", mapper.selectSurveyList(p));
		return out;
	}

	@Override
	public Map<String, Object> selectSurveyOne(Map<String, Object> param) throws Exception {
		Map<String, Object> out = new HashMap<>();
		Map<String, Object> doc = mapper.selectSurvey(param);
		out.put("doc", doc);
		out.put("ans", doc == null ? new ArrayList<>() : mapper.selectSurveyAnsList(param));
		return out;
	}

	@Override
	public List<Map<String, Object>> selectSurveyAnsItem(long ansId) throws Exception {
		return mapper.selectSurveyAnsItem(ansId);
	}

	@Override
	public long saveSurvey(Map<String, Object> param) throws Exception {
		Object sid = param.get("surveyId");
		boolean isNew = (sid == null || String.valueOf(sid).trim().isEmpty() || "0".equals(String.valueOf(sid)));
		if (isNew) {
			// ★차수를 1 로 고정하면 UNIQUE(HOSP_CD, IN_YEAR, SEQ) 에 걸린다.
			//   같은 해에 두 번째 조사를 만들 수 있어야 하므로 max+1 로 채번한다.
			param.put("seq", mapper.selectSurveyNextSeq(param));
			mapper.insertSurvey(param);                 // useGeneratedKeys → param 에 surveyId 채워짐
			Object k = param.get("surveyId");
			return k == null ? 0L : Long.parseLong(String.valueOf(k));
		}
		mapper.updateSurvey(param);
		return Long.parseLong(String.valueOf(sid));
	}

	@Override
	public long saveSurveyAns(Map<String, Object> param, List<Map<String, Object>> items) throws Exception {
		Object aid = param.get("ansId");
		boolean isNew = (aid == null || String.valueOf(aid).trim().isEmpty() || "0".equals(String.valueOf(aid)));
		long ansId;
		if (isNew) {
			// ★번호는 서버가 매긴다. 화면이 비워 보내도 저장이 막히지 않게 한다.
			Integer no = intOrNull(param.get("ansno"));
			if (no == null || no <= 0) param.put("ansno", mapper.selectSurveyNextAnsNo(param));
			mapper.insertSurveyAns(param);
			Object k = param.get("ansId");
			ansId = (k == null ? 0L : Long.parseLong(String.valueOf(k)));
		} else {
			ansId = Long.parseLong(String.valueOf(aid));
			mapper.updateSurveyAns(param);
		}
		if (ansId <= 0) throw new Exception("응답 저장에 실패했습니다.");

		// 문항점수는 통째로 갈아끼운다(부분수정 없음).
		mapper.deleteSurveyAnsItem(ansId);
		List<Map<String, Object>> rows = new ArrayList<>();
		if (items != null) {
			for (Map<String, Object> it : items) {
				Integer q = intOrNull(it.get("qsort"));
				if (q == null) continue;                        // 문항번호 없으면 버린다
				Integer sc = intOrNull(it.get("score"));
				if (sc != null && (sc < 1 || sc > 5)) sc = null; // ★배점 범위 밖은 무응답 처리
				Map<String, Object> r = new HashMap<>();
				r.put("qsort", q);
				r.put("score", sc);
				rows.add(r);
			}
		}
		if (!rows.isEmpty()) {
			Map<String, Object> ip = new HashMap<>();
			ip.put("ansId", ansId);
			ip.put("items", rows);
			mapper.insertSurveyAnsItem(ip);
		}
		return ansId;
	}

	@Override
	public int deleteSurveyAns(Map<String, Object> param) throws Exception {
		long ansId = Long.parseLong(String.valueOf(param.get("ansId")));
		mapper.deleteSurveyAnsItem(ansId);
		return mapper.deleteSurveyAns(param);
	}

	@Override
	public Map<String, Object> selectSurveyStat(Map<String, Object> param) throws Exception {
		Map<String, Object> out = new HashMap<>();
		out.put("item",  mapper.selectSrvStatItem(param));
		out.put("area",  mapper.selectSrvStatArea(param));
		out.put("total", mapper.selectSrvStatTotal(param));

		// 분포 3종은 같은 쿼리에 축만 바꿔 부른다.
		for (String gb : new String[] { "SEX", "AGE", "WRITER" }) {
			Map<String, Object> p = new HashMap<>(param);
			p.put("gb", gb);
			out.put("prof" + gb, mapper.selectSrvStatProfile(p));
		}
		out.put("opinion", mapper.selectSrvOpinion(param));
		return out;
	}
}
