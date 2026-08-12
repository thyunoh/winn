package egovframework.wnn_medcost.qps.service.impl;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

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

	/**
	 * 분류별 집계를 분기 4벌로 — QI 최종보고서 활동효과(v2).
	 *
	 * ★새 SQL 을 만들지 않는다. 지표 화면이 쓰는 분류 집계를 <b>분기 기간으로 네 번</b> 부를 뿐이다.
	 *   축을 새로 짜면 지표 화면과 QI 보고서가 다른 숫자를 낼 수 있다 — 같은 쿼리를 써야 어긋나지 않는다.
	 * ★사고형이면 위해등급·사고분류가, 관찰형이면 직종·시점이 그대로 나온다(원본 요구가 정확히 이것).
	 */
	@Override
	public List<Map<String, Object>> selectBreakdownQuarters(String hospCd, String indiCd, String incidGb,
	                                                         String inYear, String numerSrc, String minLevel) throws Exception {
		String[][] Q = { {"1/4 분기","0101","0331"}, {"2/4 분기","0401","0630"},
		                 {"3/4 분기","0701","0930"}, {"4/4 분기","1001","1231"} };
		List<Map<String, Object>> out = new ArrayList<>();
		boolean isMon = "MONITOR".equals(numerSrc);
		// 사고 행이 없는 원천은 분류 축이 성립하지 않는다 — 빈 목록을 준다(화면이 표를 안 그린다)
		if (!isMon && !"INCIDENT".equals(numerSrc)) return out;
		for (String[] q : Q) {
			String fr = inYear + q[1], to = inYear + q[2];
			Map<String, Object> row = new LinkedHashMap<>();
			row.put("prd", q[0]);
			row.put("bd", isMon ? selectMonitorBreakdown(hospCd, indiCd, fr, to)
			                    : selectBreakdown(hospCd, incidGb, fr, to, minLevel));
			out.add(row);
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
		// ★CMPL·SRV 도 마찬가지다 — 분모가 각각 처리대장의 접수건수·설문 만점합이라 재원일수를 쓰면 안 된다.
		if (denomGb.isEmpty() && !"MANUAL".equals(numerSrcTmp)
		 && !"CMPL".equals(numerSrcTmp) && !"SRV".equals(numerSrcTmp)) denomGb = "INDAYS";
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
		} else if ("CMPL".equals(numerSrc)) {
			// 불만고충 처리대장에서 직접 — 분자=처리(회신)건수, 분모=접수건수. 재원일수를 안 쓴다.
			// ★같은 것을 두 번 적게 만들지 않으려고 수기입력(MANUAL)에서 옮겼다(2026-08-11).
			//   '처리 = 회신날짜가 있는 건' 의 정의는 지표분석보고서와 **같은 쿼리**를 써서
			//   두 화면의 숫자가 어긋날 수 없게 한다.
			Map<String, Object> cp = new HashMap<>();
			cp.put("hospCd", hospCd);
			cp.put("inYear", inYear);
			cp.put("frMm", "01");
			cp.put("toMm", "12");
			Map<String, int[]> byMm = new HashMap<>();   // mm -> [분자(처리), 분모(접수)]
			List<Map<String, Object>> crows = mapper.selectCmplStatMonth(cp);
			if (crows != null) for (Map<String, Object> r : crows) {
				byMm.put(str(r.get("mm")), new int[]{ intOf(r.get("done"), 0), intOf(r.get("tot"), 0) });
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
			// 접수 건이 하나도 없으면 분모가 없는 것 — 지표는 '-' 로 나간다(0% 가 아니다).
			hasDenom = denomTot > 0;
		} else if ("SRV".equals(numerSrc)) {
			// 만족도 설문에서 직접 — 분자=점수합, 분모=만점합(응답문항수×5). 재원일수를 안 쓴다.
			// ★조사가 끝난 달(TO_DT)에 값을 세운다. 만족도는 연 1~2회라 조사 없는 달은 분모가 0 이고,
			//   그 달·그 분기는 '-' 로 나간다(0% 가 아니다 — 조사를 안 한 것과 만족도 0 은 다르다).
			// ★분기·연 누계는 '월별 율의 평균'이 아니라 점수합÷만점합이다. 조사가 두 번이면
			//   응답이 많은 쪽이 더 무겁게 반영된다 — 보고서의 전체평균과 같은 셈법이다.
			Map<String, int[]> byMm = new HashMap<>();   // mm -> [점수합, 만점합]
			List<Map<String, Object>> srows = mapper.selectSrvStatMonth(hospCd, inYear);
			if (srows != null) for (Map<String, Object> r : srows) {
				byMm.put(str(r.get("mm")), new int[]{ intOf(r.get("sumscore"), 0), intOf(r.get("totscore"), 0) });
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

	// ============ QI 활동 계획서 ============

	@Override
	public List<Map<String, Object>> selectQiPlanList(String hospCd, String inYear) throws Exception {
		return mapper.selectQiPlanList(hospCd, inYear);
	}

	@Override
	public Map<String, Object> selectQiPlanWithItems(String hospCd, long qipSeq) throws Exception {
		Map<String, Object> out = new LinkedHashMap<>();
		Map<String, Object> doc = mapper.selectQiPlan(hospCd, qipSeq);
		out.put("doc", doc);
		out.put("items", doc == null ? new ArrayList<>() : mapper.selectQiPlanItems(qipSeq));
		return out;
	}

	/** 저장 — 새 문서면 insert, 있으면 update. 팀구성·활동일정은 통째 교체(연간계획서와 같은 방식). */
	@Override
	public long saveQiPlan(Map<String, Object> p, List<Map<String, Object>> items) throws Exception {
		long seq = 0;
		Object s = p.get("qipSeq");
		if (s != null && !String.valueOf(s).trim().isEmpty()) {
			try { seq = Long.parseLong(String.valueOf(s).trim()); } catch (Exception ignore) { seq = 0; }
		}
		if (seq > 0) { mapper.updateQiPlan(p); }
		else { mapper.insertQiPlan(p); seq = Long.parseLong(String.valueOf(p.get("qipSeq"))); }

		mapper.deleteQiPlanItems(seq);
		if (items != null && !items.isEmpty()) {
			Map<String, Object> ip = new HashMap<>();
			ip.put("qipSeq", seq);
			ip.put("items", items);
			mapper.insertQiPlanItems(ip);
		}
		return seq;
	}

	@Override
	public int deleteQiPlan(Map<String, Object> param) throws Exception {
		return mapper.deleteQiPlan(param);
	}

	// ============ FMEA 계획서·보고서 ============

	@Override
	public Map<String, Object> selectFmeaBase(String hospCd, String inYear, String docGb) throws Exception {
		Map<String, Object> out = new LinkedHashMap<>();
		out.put("scale", mapper.selectFmeaScale());   // 척도표 — 화면 안내와 인쇄물에 그대로 낸다
		out.put("list",  mapper.selectFmeaList(hospCd, inYear, docGb));
		return out;
	}

	@Override
	public Map<String, Object> selectFmeaOne(String hospCd, long fmeSeq) throws Exception {
		Map<String, Object> out = new LinkedHashMap<>();
		Map<String, Object> doc = mapper.selectFmea(hospCd, fmeSeq);
		out.put("doc", doc);
		out.put("items", doc == null ? new ArrayList<>() : mapper.selectFmeaItems(fmeSeq));
		out.put("sheet", doc == null ? new ArrayList<>() : mapper.selectFmeaSheet(fmeSeq));
		return out;
	}

	/**
	 * 저장 — ★점수는 서버에서 다시 셈한다(화면이 잘못 보내도 값이 오염되지 않게).
	 *   위험도점수 = 발생가능성 × 심각성
	 *   RPN        = 심각성 × 발생가능성 × 발견가능성
	 *   CI         = 심각성 × 발생가능성   ← ★추정 산식. 원본 확인 전이며 화면에도 그렇게 표시한다.
	 * 순위는 RPN 내림차순(동점이면 같은 순위).
	 */
	@Override
	public long saveFmea(Map<String, Object> p, List<Map<String, Object>> items,
	                     List<Map<String, Object>> sheet) throws Exception {
		long seq = longOfObj(p.get("fmeSeq"));
		if (seq > 0) { mapper.updateFmea(p); }
		else { mapper.insertFmea(p); seq = Long.parseLong(String.valueOf(p.get("fmeSeq"))); }

		mapper.deleteFmeaItems(seq);
		if (items != null && !items.isEmpty()) {
			for (Map<String, Object> r : items) {
				for (String k : new String[]{ "n1","n2","n3","n4" }) r.put(k, intOrNull(r.get(k)));
				// 위험도평가 행은 위험도점수를 다시 셈한다
				if ("RISK".equals(str(r.get("sect")))) {
					Integer o = (Integer) r.get("n2"), s = (Integer) r.get("n3");
					r.put("n4", (o == null || s == null) ? null : Integer.valueOf(o * s));
				}
			}
			Map<String, Object> ip = new HashMap<>();
			ip.put("fmeSeq", seq); ip.put("items", items);
			mapper.insertFmeaItems(ip);
		}

		mapper.deleteFmeaSheet(seq);
		if (sheet != null && !sheet.isEmpty()) {
			for (Map<String, Object> r : sheet) {
				for (String k : new String[]{ "aoccur","asever","adetect","boccur","bsever","bdetect" }) {
					r.put(k, intOrNull(r.get(k)));
				}
				r.put("arpn", rpn(r.get("asever"), r.get("aoccur"), r.get("adetect")));
				r.put("aci",  ci(r.get("asever"), r.get("aoccur")));
				r.put("brpn", rpn(r.get("bsever"), r.get("boccur"), r.get("bdetect")));
				r.put("bci",  ci(r.get("bsever"), r.get("boccur")));
			}
			// 순위 — 사전 RPN 내림차순, 동점이면 같은 순위
			List<Map<String, Object>> sorted = new ArrayList<>(sheet);
			sorted.sort((a, b) -> intOf(b.get("arpn"), 0) - intOf(a.get("arpn"), 0));
			int rank = 0, prev = Integer.MIN_VALUE, seen = 0;
			for (Map<String, Object> r : sorted) {
				int v = intOf(r.get("arpn"), 0);
				seen++;
				if (v != prev) { rank = seen; prev = v; }
				r.put("arank", v > 0 ? Integer.valueOf(rank) : null);
			}
			Map<String, Object> sp = new HashMap<>();
			sp.put("fmeSeq", seq); sp.put("items", sheet);
			mapper.insertFmeaSheet(sp);
		}
		return seq;
	}

	/** RPN = 심각성 × 발생가능성 × 발견가능성. 하나라도 비면 null(0 이 아니다 — '미평가'와 구별). */
	private static Integer rpn(Object sever, Object occur, Object detect) {
		Integer s = intOrNull(sever), o = intOrNull(occur), d = intOrNull(detect);
		return (s == null || o == null || d == null) ? null : Integer.valueOf(s * o * d);
	}
	/** ★CI — 산식이 원본 인쇄물에 없다. 심각성 × 발생가능성으로 추정한다(화면에 그렇게 표시). */
	private static Integer ci(Object sever, Object occur) {
		Integer s = intOrNull(sever), o = intOrNull(occur);
		return (s == null || o == null) ? null : Integer.valueOf(s * o);
	}

	@Override
	public int deleteFmea(Map<String, Object> param) throws Exception { return mapper.deleteFmea(param); }

	// ============ RCA 근본원인 분석 보고서 ============

	@Override
	public List<Map<String, Object>> selectRcaList(String hospCd, String inYear) throws Exception {
		return mapper.selectRcaList(hospCd, inYear);
	}

	@Override
	public Map<String, Object> selectRca(String hospCd, long rcaSeq) throws Exception {
		return mapper.selectRca(hospCd, rcaSeq);
	}

	@Override
	public long saveRca(Map<String, Object> p) throws Exception {
		long seq = longOfObj(p.get("rcaSeq"));
		if (seq > 0) { mapper.updateRca(p); }
		else { mapper.insertRca(p); seq = Long.parseLong(String.valueOf(p.get("rcaSeq"))); }
		return seq;
	}

	@Override
	public int deleteRca(Map<String, Object> param) throws Exception { return mapper.deleteRca(param); }

	// ============ 사고 유형별 보고서 ============

	/** 화면 초기 로드 — ★항목표(DEF)를 함께 준다. 화면은 이걸 순회해 체크박스를 그린다(유형별 하드코딩 없음). */
	@Override
	public Map<String, Object> selectSafeRptBase(String hospCd, String inYear, String rptGb) throws Exception {
		Map<String, Object> out = new LinkedHashMap<>();
		out.put("def",  mapper.selectSafeRptDef(rptGb));
		out.put("list", mapper.selectSafeRptList(hospCd, inYear, rptGb));
		return out;
	}

	@Override
	public Map<String, Object> selectSafeRptOne(String hospCd, long srpSeq) throws Exception {
		Map<String, Object> out = new LinkedHashMap<>();
		Map<String, Object> doc = mapper.selectSafeRpt(hospCd, srpSeq);
		out.put("doc", doc);
		out.put("chks", doc == null ? new ArrayList<>() : mapper.selectSafeRptChk(srpSeq));
		return out;
	}

	/** 저장 — 체크는 통째 교체. 무엇을 골랐는지만 남기면 되므로 부분 수정이 필요 없다. */
	@Override
	public long saveSafeRpt(Map<String, Object> p, List<Map<String, Object>> chks) throws Exception {
		long seq = longOfObj(p.get("srpSeq"));
		if (seq > 0) { mapper.updateSafeRpt(p); }
		else { mapper.insertSafeRpt(p); seq = Long.parseLong(String.valueOf(p.get("srpSeq"))); }
		mapper.deleteSafeRptChk(seq);
		if (chks != null && !chks.isEmpty()) {
			Map<String, Object> ip = new HashMap<>();
			ip.put("srpSeq", seq); ip.put("items", chks);
			mapper.insertSafeRptChk(ip);
		}
		return seq;
	}

	@Override
	public int deleteSafeRpt(Map<String, Object> param) throws Exception { return mapper.deleteSafeRpt(param); }

	// ============ QI 중간·최종보고서 ============

	@Override
	public List<Map<String, Object>> selectQiRptList(String hospCd, String inYear, String rptGb) throws Exception {
		return mapper.selectQiRptList(hospCd, inYear, rptGb);
	}

	@Override
	public Map<String, Object> selectQiRptWithItems(String hospCd, long qirSeq) throws Exception {
		Map<String, Object> out = new LinkedHashMap<>();
		Map<String, Object> doc = mapper.selectQiRpt(hospCd, qirSeq);
		out.put("doc", doc);
		out.put("items", doc == null ? new ArrayList<>() : mapper.selectQiRptItems(qirSeq));
		return out;
	}

	@Override
	public long saveQiRpt(Map<String, Object> p, List<Map<String, Object>> items) throws Exception {
		long seq = longOfObj(p.get("qirSeq"));
		if (seq > 0) { mapper.updateQiRpt(p); }
		else { mapper.insertQiRpt(p); seq = Long.parseLong(String.valueOf(p.get("qirSeq"))); }
		mapper.deleteQiRptItems(seq);
		if (items != null && !items.isEmpty()) {
			Map<String, Object> ip = new HashMap<>();
			ip.put("qirSeq", seq); ip.put("items", items);
			mapper.insertQiRptItems(ip);
		}
		return seq;
	}

	@Override
	public int deleteQiRpt(Map<String, Object> param) throws Exception { return mapper.deleteQiRpt(param); }

	// ============ QI 주제선정 기준표 + 우선순위 집계표 ============

	@Override
	public List<Map<String, Object>> selectQiTopicList(String hospCd, String inYear) throws Exception {
		return mapper.selectQiTopicList(hospCd, inYear);
	}

	@Override
	public Map<String, Object> selectQiTopicWithItems(String hospCd, long qitSeq) throws Exception {
		Map<String, Object> out = new LinkedHashMap<>();
		Map<String, Object> doc = mapper.selectQiTopic(hospCd, qitSeq);
		out.put("doc", doc);
		out.put("items", doc == null ? new ArrayList<>() : mapper.selectQiTopicItems(qitSeq));
		return out;
	}

	/** 저장 — 총점은 서버에서 다시 셈한다(화면이 잘못 보내도 집계가 오염되지 않게). */
	@Override
	public long saveQiTopic(Map<String, Object> p, List<Map<String, Object>> items) throws Exception {
		long seq = longOfObj(p.get("qitSeq"));
		if (seq > 0) { mapper.updateQiTopic(p); }
		else { mapper.insertQiTopic(p); seq = Long.parseLong(String.valueOf(p.get("qitSeq"))); }
		mapper.deleteQiTopicItems(seq);
		if (items != null && !items.isEmpty()) {
			for (Map<String, Object> r : items) {
				int t = 0;
				for (String k : new String[]{ "s1","s2","s3","s4","s5","s6" }) {
					Integer v = intOrNull(r.get(k));
					r.put(k, v);
					if (v != null) t += v;
				}
				r.put("totscore", t);
			}
			Map<String, Object> ip = new HashMap<>();
			ip.put("qitSeq", seq); ip.put("items", items);
			mapper.insertQiTopicItems(ip);
		}
		return seq;
	}

	@Override
	public int deleteQiTopic(Map<String, Object> param) throws Exception { return mapper.deleteQiTopic(param); }

	/**
	 * 우선순위 집계표 — ★저장하지 않는다. 그 해 기준표(평가위원별)를 주제로 묶어 합산한다.
	 * 원본 [생성] 버튼이 하던 일이다. 순위는 총점 내림차순(동점이면 같은 순위).
	 */
	@Override
	public Map<String, Object> selectQiTopicRollup(String hospCd, String inYear) throws Exception {
		List<Map<String, Object>> rows = mapper.selectQiTopicRollup(hospCd, inYear);
		int rank = 0, prev = Integer.MIN_VALUE, seen = 0;
		if (rows != null) for (Map<String, Object> r : rows) {
			int t = intOf(r.get("totscore"), 0);
			seen++;
			if (t != prev) { rank = seen; prev = t; }   // 동점이면 같은 순위, 다음은 건너뛴다
			r.put("rank", rank);
		}
		Map<String, Object> out = new LinkedHashMap<>();
		out.put("rollup", rows);
		out.put("cross", mapper.selectQiTopicCross(hospCd, inYear));   // 주제 × 평가위원 총점
		out.put("evaluators", mapper.selectQiTopicList(hospCd, inYear));
		return out;
	}

	// ============ QI 활동 자원지원 내역 ============

	@Override
	public Map<String, Object> selectQiFundWithItems(String hospCd, String inYear) throws Exception {
		Map<String, Object> out = new LinkedHashMap<>();
		Map<String, Object> doc = mapper.selectQiFund(hospCd, inYear);
		out.put("doc", doc);
		out.put("items", (doc == null || doc.get("qifseq") == null)
				? new ArrayList<>()
				: mapper.selectQiFundItems(Long.parseLong(String.valueOf(doc.get("qifseq")))));
		return out;
	}

	/** 저장 — 총지원비는 세부항목 합으로 서버가 다시 셈한다. */
	@Override
	public long saveQiFund(Map<String, Object> p, List<Map<String, Object>> items) throws Exception {
		long tot = 0;
		if (items != null) for (Map<String, Object> r : items) {
			Integer v = intOrNull(r.get("amt"));
			r.put("amt", v);
			if (v != null) tot += v;
		}
		p.put("totAmt", tot);
		mapper.upsertQiFund(p);
		long seq = Long.parseLong(String.valueOf(p.get("qifSeq")));
		mapper.deleteQiFundItems(seq);
		if (items != null && !items.isEmpty()) {
			Map<String, Object> ip = new HashMap<>();
			ip.put("qifSeq", seq); ip.put("items", items);
			mapper.insertQiFundItems(ip);
		}
		return seq;
	}

	/** 화면이 보낸 seq 문자열 → long. 비었거나 못 읽으면 0(=새 문서). */
	private static long longOfObj(Object o) {
		if (o == null) return 0;
		String s = String.valueOf(o).trim();
		if (s.isEmpty()) return 0;
		try { return Long.parseLong(s); } catch (Exception e) { return 0; }
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

	/* ═══════════════════════════════════════════════════════════════════
	   점검표 엔진 (2026-08-11)
	   ★서식은 데이터다. 새 점검표를 만드는 데 자바를 고칠 일이 없어야 한다.
	   ═══════════════════════════════════════════════════════════════════ */

	@Override
	public List<Map<String, Object>> selectChkFormList(String hospCd, String cateCd, String deptCd, String onlyUse) throws Exception {
		return mapper.selectChkFormList(hospCd, cateCd, deptCd, onlyUse);
	}

	@Override
	public void saveChkUse(String hospCd, List<Map<String, Object>> uses, String regUser) throws Exception {
		mapper.deleteChkUse(hospCd);
		if (uses == null || uses.isEmpty()) return;   // 전부 끄면 지정 없음 = 기본 열림으로 돌아간다
		Map<String, Object> p = new HashMap<>();
		p.put("hospCd", hospCd); p.put("uses", uses); p.put("regUser", regUser);
		mapper.insertChkUse(p);
	}

	@Override
	public boolean existsChkForm(String formId) throws Exception {
		return mapper.countChkForm(formId) > 0;
	}

	/**
	 * 자동 서식코드 — 접두어 + 3자리. ★130 종을 지어 내다 보면 사람이 코드를 못 짓는다.
	 * ★이미 쓰는 번호 다음을 준다. 지운 서식(USE_YN='N')의 번호도 건너뛴다 —
	 *   같은 코드를 되살리면 옛 항목이 섞인다.
	 */
	@Override
	public String nextChkFormId(String prefix) throws Exception {
		String p = (prefix == null) ? "" : prefix.trim().toUpperCase();
		if (p.isEmpty()) p = "CHK";
		for (int i = mapper.selectChkCodeMax(p) + 1; i <= 999; i++) {
			String cand = p + String.format("%03d", i);
			if (mapper.countChkForm(cand) == 0) return cand;
		}
		throw new Exception("자동 코드를 만들지 못했습니다. 접두어를 바꿔 주세요.");
	}

	/**
	 * 서식 화면에서 부서·분류 코드 추가 (2026-08-11) —
	 * "서식에 관련 공통코드는 여기에서 관리하게".
	 * ★★<b>추가만</b> 한다. 이름 바꾸기·지우기는 공통코드 화면에서 —
	 *   ***이미 그 코드를 쓰는 서식이 있는데 지우면 그 서식이 미아가 된다.***
	 */
	@Override
	public List<Map<String, Object>> addChkCode(String codeCd, String subCode, String subCodeNm,
	                                            String regUser) throws Exception {
		Map<String, Object> p = new HashMap<>();
		p.put("codeCd", codeCd); p.put("subCode", subCode);
		p.put("subCodeNm", subCodeNm); p.put("regUser", regUser);
		mapper.insertChkCode(p);
		// 갱신된 그 세트만 돌려준다 — 화면이 셀렉트를 바로 다시 그린다
		List<Map<String, Object>> out = new ArrayList<>();
		List<Map<String, Object>> all = mapper.selectQpsCodes();
		if (all != null) for (Map<String, Object> r : all) {
			if (codeCd.equals(String.valueOf(r.get("codecd")))) out.add(r);
		}
		return out;
	}

	/**
	 * 서식 복제 — ★130종을 손으로 만들 수 없어서 넣은 것이다.
	 *   비슷한 점검표가 대부분이라 「복제 → 항목만 손보기」가 새로 짜는 것보다 훨씬 빠르다.
	 *   원본이 공통('*')이든 병원 것이든 상관없이 **이 병원 것**으로 만들어진다.
	 */
	@Override
	public void copyChkForm(String hospCd, String srcFormId, String newFormId, String newFormNm,
	                        String regUser) throws Exception {
		Map<String, Object> src = mapper.selectChkForm(hospCd, srcFormId);
		if (src == null) throw new Exception("복제할 원본 서식을 찾지 못했습니다.");
		String owner = str(src.get("hospcd"));
		if (owner.isEmpty()) owner = "*";

		Map<String, Object> m = new HashMap<>();
		m.put("formId", newFormId);  m.put("hospCd", hospCd);
		m.put("formNm", newFormNm);  m.put("cateCd", str(src.get("catecd")));
		// ★부서를 빠뜨리고 있었다(2026-08-12) — 복제본의 DEPT_CD 가 비면 작성 화면의
		//   부서 셀렉트에서 **그 서식이 안 보인다.** 복제는 「비슷한 것을 빨리 만드는」 길인데
		//   가장 비슷해야 할 부서가 날아갔다.
		m.put("deptCd", str(src.get("deptcd")));
		m.put("axisGb", str(src.get("axisgb")));  m.put("prdGb", str(src.get("prdgb")));
		m.put("equipCnt", src.get("equipcnt"));
		m.put("halfYn", "N");                         // 더 이상 쓰지 않는다(SPLIT_N·SPLIT_DIR 로 옮겼다)
		// ⚠***여기는 서식 정의를 하나라도 빠뜨리면 조용히 다른 서식이 된다.***
		//   파라미터가 Map 이라 없는 키는 예외가 아니라 **null** 이다 — 화면도 로그도 아무 말이 없고,
		//   복제본만 「모양이 왜 다르지」가 된다. 실제로 DEPT_CD 가 그렇게 날아갔었다.
		//   ⇒ ***서식에 칸을 더할 때마다 이 줄들도 같이 더한다.*** (saveChkForm 의 컬럼 목록과 짝이다)
		m.put("prdKind",  src.get("prdkind"));        // 격자의 기간 종류 D·W·N·M·Q
		m.put("splitN",   src.get("splitn"));         // 인쇄를 몇 칸씩 끊나
		m.put("splitDir", src.get("splitdir"));       //   그 방향 C·R
		m.put("rowBlkGb", src.get("rowblkgb"));       // 행 묶음을 세로 칸으로 그리나 가로 띠로 그리나
		m.put("rowBlks",  str(src.get("rowblks")));   // LIST 의 행 블록 정의
		m.put("descNm",   str(src.get("descnm")));    // 항목 설명 열의 머리글
		m.put("preCols",  str(src.get("precols")));   // 격자 앞에 붙는 입력 열
		m.put("postCols", str(src.get("postcols")));  //   뒤에 붙는 입력 열
		m.put("guideTxt", str(src.get("guidetxt")));  m.put("headNms", str(src.get("headnms")));
		m.put("colNms",  str(src.get("colnms")));     // ITEM_COL 의 고정 열 — 복제할 때 빠지면 표가 안 그려진다
		m.put("colSrc",  str(src.get("colsrc")));     // 열 이름을 서식이 정하나 문서가 정하나
		m.put("rowSrc",  str(src.get("rowsrc")));     // 행 묶음을 서식이 정하나 문서가 정하나
		m.put("signerYn", str(src.get("signeryn")));  m.put("noteYn", str(src.get("noteyn")));
		m.put("fixYn", str(src.get("fixyn")));        m.put("signLine", str(src.get("signline")));
		m.put("footTxt", str(src.get("foottxt")));    m.put("sortNo", src.get("sortno"));
		m.put("regUser", regUser);

		List<Map<String, Object>> items = mapper.selectChkItems(owner, srcFormId);
		saveChkForm(m, items);
	}

	@Override
	public Map<String, Object> selectChkFormOne(String hospCd, String formId) throws Exception {
		Map<String, Object> out = new LinkedHashMap<>();
		Map<String, Object> form = mapper.selectChkForm(hospCd, formId);
		out.put("form", form);
		// ★항목은 **그 서식 행이 있는 병원코드**로 읽는다. 화면의 hospCd 로 읽으면
		//   공통서식을 보고 있는 병원에서 항목이 0건이 된다(서식은 '*' 인데 항목을 병원코드로 찾게 되므로).
		String owner = (form == null) ? "*" : str(form.get("hospcd"));
		if (owner.isEmpty()) owner = "*";
		out.put("items", form == null ? new ArrayList<>() : mapper.selectChkItems(owner, formId));
		return out;
	}

	@Override
	public void saveChkForm(Map<String, Object> form, List<Map<String, Object>> items) throws Exception {
		mapper.saveChkForm(form);
		String hospCd = str(form.get("hospCd")), formId = str(form.get("formId"));
		mapper.deleteChkItems(hospCd, formId);
		if (items != null && !items.isEmpty()) {
			int sort = 0;
			List<Map<String, Object>> keep = new ArrayList<>();
			for (Map<String, Object> r : items) {
				if (str(r.get("itemnm")).isEmpty()) continue;   // 빈 줄은 버린다
				r.put("sort", ++sort);
				keep.add(r);
			}
			if (!keep.isEmpty()) {
				Map<String, Object> p = new HashMap<>();
				p.put("hospCd", hospCd); p.put("formId", formId); p.put("items", keep);
				mapper.insertChkItems(p);
			}
		}
	}

	@Override
	public void deleteChkForm(Map<String, Object> param) throws Exception {
		mapper.deleteChkForm(param);
	}

	@Override
	public Map<String, Object> selectChkBase(String hospCd, String formId, String inYear) throws Exception {
		Map<String, Object> out = new LinkedHashMap<>(selectChkFormOne(hospCd, formId));
		out.put("list", mapper.selectChkDocList(hospCd, formId, inYear));
		return out;
	}

	@Override
	public Map<String, Object> selectChkDocOne(String hospCd, long chkSeq) throws Exception {
		Map<String, Object> out = new LinkedHashMap<>();
		Map<String, Object> doc = mapper.selectChkDoc(hospCd, chkSeq);
		out.put("doc", doc);
		out.put("vals", doc == null ? new ArrayList<>() : mapper.selectChkVals(chkSeq));
		out.put("rows", doc == null ? new ArrayList<>() : mapper.selectChkRows(chkSeq));
		out.put("cols", doc == null ? new ArrayList<>() : mapper.selectChkCols(chkSeq));
		return out;
	}

	@Override
	public long saveChkDoc(Map<String, Object> doc, List<Map<String, Object>> vals,
	                       List<Map<String, Object>> rows, List<Map<String, Object>> cols) throws Exception {
		long seq = longOfObj(doc.get("chkSeq"));
		if (seq > 0) { mapper.updateChkDoc(doc); }
		else { mapper.insertChkDoc(doc); seq = Long.parseLong(String.valueOf(doc.get("chkSeq"))); }

		// ★통째 교체다. 셀은 딸린 상세가 없어 SEQ 가 바뀌어도 미아가 생기지 않는다
		//   (불만고충 처리결과처럼 1:1 로 매달린 것이 있으면 통째 교체하면 안 된다 — 여기는 아니다).
		mapper.deleteChkVals(seq);
		if (vals != null && !vals.isEmpty()) {
			// ★★정규화는 **체크 칸에만** 한다 (2026-08-12).
			//   normChk 는 한 글자면 O/X 로 맞추는데, 그것만으로는 **숫자·글자 칸이 망가진다** —
			//   온도 「1」이 「O」가 되고, 대장의 「1」호실·「V」라는 이름도 마찬가지다.
			//   ⇒ 그 칸의 INPUT_GB 를 보고 CHECK 일 때만 맞춘다. LIST(자유행 대장)는 글자 칸이
			//     대부분이라 이 구분이 없으면 축을 붙이는 순간 자료가 깨진다.
			ChkNorm norm = chkNorm(str(doc.get("hospCd")), str(doc.get("formId")));
			List<Map<String, Object>> keep = new ArrayList<>();
			for (Map<String, Object> v : vals) {
				if (str(v.get("val")).isEmpty()) continue;   // 빈 칸은 저장하지 않는다 — 31×16 을 다 넣으면 낭비다
				v.put("val", norm.apply(v));
				keep.add(v);
			}
			if (!keep.isEmpty()) {
				Map<String, Object> p = new HashMap<>();
				p.put("chkSeq", seq); p.put("vals", keep);
				mapper.insertChkVals(p);
			}
		}
		mapper.deleteChkRows(seq);
		if (rows != null && !rows.isEmpty()) {
			List<Map<String, Object>> keep = new ArrayList<>();
			for (Map<String, Object> r : rows) {
				if (str(r.get("rownm")).isEmpty()) continue;
				keep.add(r);
			}
			if (!keep.isEmpty()) {
				Map<String, Object> p = new HashMap<>();
				p.put("chkSeq", seq); p.put("rows", keep);
				mapper.insertChkRows(p);
			}
		}
		// 문서가 정하는 **열** 이름 — 바로 위 행 이름과 **같은 차례로** 처리한다(2026-08-12)
		mapper.deleteChkCols(seq);
		if (cols != null && !cols.isEmpty()) {
			List<Map<String, Object>> keep = new ArrayList<>();
			for (Map<String, Object> c : cols) {
				if (str(c.get("colnm")).isEmpty()) continue;
				keep.add(c);
			}
			if (!keep.isEmpty()) {
				Map<String, Object> p = new HashMap<>();
				p.put("chkSeq", seq); p.put("cols", keep);
				mapper.insertChkCols(p);
			}
		}
		return seq;
	}

	@Override
	public void deleteChkDoc(Map<String, Object> param) throws Exception {
		mapper.deleteChkDoc(param);
	}

	/**
	 * ═══ 전월 복사 — <b>무엇을 복사할지</b>가 이 기능의 전부다 (2026-08-12, v3 순서 9) ═══
	 *
	 * ★★***점검 결과는 절대 복사하지 않는다.***
	 *   원본 화면 여럿에 「전월복사」 버튼이 있는 것은 실제로 많이 쓴다는 뜻이지만,
	 *   ***지난달 O 가 남아 있으면 화면은 「점검했다」로 보인다.*** 아무도 안 한 점검이 기록이 된다.
	 *   ⇒ 안 하는 쪽이 언제나 되돌릴 수 있는 쪽이다. 값은 사람이 다시 찍는다.
	 *
	 * ★복사하는 것 = <b>문서의 틀</b>. 달이 바뀌어도 같은 것들이다.
	 *   · 상단 자유칸 HEAD1~8 (장비명·모델명·사용부서·점검주기)
	 *   · 병동
	 *   · 기기 행 이름 (TBL_QPS_CHK_ROW) — 소화기·냉난방기의 자산 목록
	 *   · 열 이름 (TBL_QPS_CHK_COL) — MSDS 물질명 · 소방 층·병동
	 *
	 * ★복사하지 않는 것 = <b>그 달에 일어난 일</b>
	 *   · 격자 값 전부 (TBL_QPS_CHK_VAL) — 앞/뒤 열(예산·조치사항·수량)도 여기 산다.
	 *     ⚠수량처럼 「자산에 가까운」 것이 섞여 있지만 ***칸마다 갈라 줄 근거가 없다.***
	 *       근거 없이 반만 복사하면 어느 칸이 복사됐는지 아무도 모른다 ⇒ 전부 안 한다.
	 *   · 특이사항 · 수리내용
	 *
	 * @return {@code {found, head1..8, wardNm, rows[], cols[]}} — ***저장하지 않는다.***
	 *         화면에 깔아 주기만 하고, 저장은 사람이 [저장]을 눌러야 일어난다.
	 */
	@Override
	public Map<String, Object> selectChkPrevSeed(String hospCd, String formId, String prdKey,
	                                             String wardNm) throws Exception {
		Map<String, Object> out = new LinkedHashMap<>();
		Map<String, Object> p = new HashMap<>();
		p.put("hospCd", hospCd); p.put("formId", formId); p.put("prdKey", prdKey); p.put("wardNm", wardNm);
		Map<String, Object> prev = mapper.selectChkDocPrev(p);
		if (prev == null) { out.put("found", "N"); return out; }
		long seq = longOfObj(prev.get("chkseq"));
		out.put("found", "Y");
		out.put("doc", prev);
		out.put("rows", mapper.selectChkRows(seq));
		out.put("cols", mapper.selectChkCols(seq));
		return out;
	}

	/**
	 * ═══ 월 생성 — <b>일 단위 서식</b>의 한 달치 빈 문서를 미리 깐다 (v3 순서 9) ═══
	 *
	 * 근거 2종(고위험 병실 순회 · 병동 순회일지). 문서 단위에 「일」을 넣어 놓고 이게 없으면
	 * ***한 달에 [새로 작성]을 31번 눌러야 한다.***
	 *
	 * ★틀은 {@link #selectChkPrevSeed} 와 <b>같은 규칙</b>으로 가져온다 — 값은 하나도 안 넣는다.
	 * ★이미 있는 날은 건너뛴다. ***다시 만들면 그날 적어 둔 것이 둘로 갈린다.***
	 */
	@Override
	public Map<String, Object> makeChkMonth(Map<String, Object> param) throws Exception {
		String hospCd = str(param.get("hospCd")), formId = str(param.get("formId"));
		String inYear = str(param.get("inYear")), inMm = str(param.get("inMm"));
		String wardNm = str(param.get("wardNm"));
		int days = intOf(param.get("days"), 0);

		Map<String, Object> q = new HashMap<>();
		q.put("hospCd", hospCd); q.put("formId", formId);
		q.put("inYear", inYear); q.put("inMm", inMm); q.put("wardNm", wardNm);
		Set<Integer> have = new HashSet<>();
		List<Integer> nos = mapper.selectChkDocNos(q);
		if (nos != null) have.addAll(nos);

		// 틀은 이 달 **첫날 앞**의 문서에서 가져온다
		Map<String, Object> seed = selectChkPrevSeed(hospCd, formId, inYear + inMm + "000", wardNm);
		Map<String, Object> sd = (Map<String, Object>) seed.get("doc");
		List<Map<String, Object>> sr = (List<Map<String, Object>>) seed.get("rows");
		List<Map<String, Object>> sc = (List<Map<String, Object>>) seed.get("cols");

		int made = 0;
		for (int d = 1; d <= days; d++) {
			if (have.contains(d)) continue;
			Map<String, Object> doc = new HashMap<>();
			doc.put("hospCd", hospCd);   doc.put("formId", formId);
			doc.put("inYear", inYear);   doc.put("inMm", inMm);
			doc.put("prdGb", "D");       doc.put("prdNo", Integer.valueOf(d));
			doc.put("wardNm", wardNm.isEmpty() ? (sd == null ? null : sd.get("wardnm")) : wardNm);
			for (int h = 1; h <= 8; h++) doc.put("head" + h, sd == null ? null : sd.get("head" + h));
			doc.put("noteTxt", null);    doc.put("fixTxt", null);   // ★그 달에 일어난 일은 안 옮긴다
			doc.put("chkSeq", "");
			doc.put("regUser", str(param.get("regUser")));
			saveChkDoc(doc, null, sr, sc);                          // ★vals 는 null — 값은 하나도 안 넣는다
			made++;
		}
		Map<String, Object> out = new LinkedHashMap<>();
		out.put("made", made);
		out.put("skipped", days - made);
		out.put("seeded", sd == null ? "N" : "Y");
		return out;
	}

	@Override
	public Map<String, Object> selectChkExtract(Map<String, Object> param) throws Exception {
		Map<String, Object> out = new LinkedHashMap<>();
		out.put("rows",    mapper.selectChkExtract(param));
		out.put("summary", mapper.selectChkSummary(param));
		return out;
	}

	/**
	 * ★★값 정규화 — <b>이게 없으면 점검표를 전산화한 뜻이 없다</b>(사용자 지시 2026-08-11 :
	 * "서식 생성시 주의사항은 데이터 추출 가능이어야 함").
	 *
	 * 사람은 같은 뜻을 제각각으로 적는다 — `O · ○ · ㅇ · o · V · v · 1 · Y` 가 전부 「양호」다.
	 * 그대로 담으면 <b>세어 볼 수가 없다</b>. 「이 달 부적합 몇 건」이 안 나온다.
	 * ⇒ 담을 때 <b>O / X</b> 두 글자로 맞춘다. 사람 입력은 관대하게 받고, 저장은 엄격하게.
	 *
	 * ⚠글자·숫자 칸(TEXT·NUM — 점검자 이름, 온도)은 손대지 않는다. 「V」라는 이름도 있을 수 있고
	 *   온도 1 을 O 로 바꾸면 자료가 망가진다. 그래서 <b>한 글자짜리 표시만</b> 바꾼다.
	 *
	 * ★★2026-08-12 — <b>「한 글자만 바꾼다」만으로는 그 약속이 지켜지지 않았다.</b>
	 *   온도 「1」·이름 「V」가 한 글자라 <b>그대로 O 로 바뀌었다.</b> 오류가 나지 않아 티도 안 난다.
	 *   ⇒ 이제 그 칸이 어느 항목의 칸인지 보고 <b>INPUT_GB 가 CHECK 일 때만</b> 맞춘다({@link ChkNorm}).
	 *   LIST(자유행 대장)는 글자 칸이 대부분이라 이 구분 없이는 축을 붙이는 순간 자료가 깨진다.
	 */
	private static String normChk(String v) {
		String s = v.trim();
		if (s.length() != 1) return s;              // 두 글자 이상은 사람이 적은 글 — 건드리지 않는다
		if ("O○◯ㅇoＯ０Vv√✓✔1Y y".indexOf(s) >= 0 && !" ".equals(s)) return "O";
		if ("XxＸ×✗✘0Nn".indexOf(s) >= 0) return "X";
		return s;                                   // △ 같은 제3의 표시는 그대로 둔다
	}

	/** 점검자 사인 행/열 예약번호 — 항목이 아니라 사람 이름이 들어간다. */
	private static final int CHK_SIGN_NO = 900;

	/**
	 * 셀 하나가 <b>어느 항목의 칸인지</b> 알아야 정규화 여부를 정할 수 있다. 그 대응은 축이 정한다 —
	 * DAY_ITEM·LIST 는 항목이 <b>열</b>, 나머지는 <b>행</b>이다.
	 */
	private static final class ChkNorm {
		private final boolean legacy;      // 서식을 못 읽었다 → 예전처럼 전부 맞춘다(저장을 막지는 않는다)
		private final boolean allCheck;    // EQUIP_DAY — 셀에 항목이 없다. 전부 표시칸이다
		private final boolean itemIsCol;   // 항목이 열인가(DAY_ITEM·LIST)
		private final Map<Integer, String> inputGb;

		ChkNorm(boolean legacy, boolean allCheck, boolean itemIsCol, Map<Integer, String> inputGb) {
			this.legacy = legacy; this.allCheck = allCheck; this.itemIsCol = itemIsCol; this.inputGb = inputGb;
		}

		String apply(Map<String, Object> v) {
			String s = str(v.get("val"));
			if (legacy || allCheck) return normChk(s);
			int no = intOf(v.get(itemIsCol ? "colno" : "rowno"), 0);
			if (no == CHK_SIGN_NO) return s;   // 사인칸 — 「1」이라는 서명을 O 로 바꾸면 안 된다
			String gb = inputGb.get(no);
			// ★모르는 항목이면 건드리지 않는다. 원본 그대로가 언제나 되돌릴 수 있는 쪽이다.
			return "CHECK".equals(gb) ? normChk(s) : s;
		}
	}

	/** 그 서식의 축 + 항목별 입력종류를 한 번만 읽어 둔다(셀마다 조회하면 31×16 번 돈다). */
	@SuppressWarnings("unchecked")
	private ChkNorm chkNorm(String hospCd, String formId) {
		Map<Integer, String> gb = new HashMap<>();
		String axisGb = "";
		try {
			Map<String, Object> one = selectChkFormOne(hospCd, formId);
			Object fo = one.get("form");
			if (fo instanceof Map) axisGb = str(((Map<String, Object>) fo).get("axisgb"));
			Object its = one.get("items");
			if (its instanceof List) {
				for (Object o : (List<Object>) its) {
					if (!(o instanceof Map)) continue;
					Map<String, Object> it = (Map<String, Object>) o;
					gb.put(intOf(it.get("sort"), 0), str(it.get("inputgb")));
				}
			}
		} catch (Exception ignore) { axisGb = ""; }
		if (axisGb.isEmpty()) return new ChkNorm(true, false, false, gb);
		boolean itemIsCol = "DAY_ITEM".equals(axisGb) || "LIST".equals(axisGb);
		return new ChkNorm(false, "EQUIP_DAY".equals(axisGb), itemIsCol, gb);
	}
}
