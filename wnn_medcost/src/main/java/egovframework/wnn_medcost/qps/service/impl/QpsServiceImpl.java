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
import egovframework.wnn_medcost.qps.model.QpsMonitorDTO;
import egovframework.wnn_medcost.qps.service.QpsService;

/**
 * QPS 서비스 — 낙상 파일럿.
 *
 * ★이 클래스가 이식의 핵심이다.
 *   SUNWOO 에서는 사람이 지표분석보고서에 '0.67‰' 를 직접 타이핑했다(실물 확인).
 *   여기서는 사고 건수(분자)와 재원일수(분모)에서 서버가 계산한다.
 *   산식·상수·단위는 코드가 아니라 TBL_QPS_INDI_MST 행에서 온다 — 지표가 늘어도 이 코드는 안 고친다.
 *
 *   검산 근거(SUNWOO 실측): 낙상 2건 / 재원일수 3,000일 × 1,000 = 0.67‰
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
	 *   SUNWOO 실측값이 그 방식이었다(1분기 2건/3,000일 = 0.67‰. 월별 2.00/0/0 의 산술평균 0.67 과
	 *   우연히 같아 보이지만, 월별 재원일수가 다르면 갈라진다 — 분모합 방식이 맞다).
	 */
	@Override
	public Map<String, Object> calcIndicator(String hospCd, String indiCd, String inYear) throws Exception {

		Map<String, Object> indi = mapper.selectQpsIndi(hospCd, indiCd);
		if (indi == null) indi = new HashMap<>();

		int multiplier = intOf(indi.get("multiplier"), 1000);
		int decimals   = intOf(indi.get("decimals"), 2);
		String denomGb = str(indi.get("denomgb"));
		if (denomGb.isEmpty()) denomGb = "INDAYS";
		String incidGb = str(indi.get("incidgb"));
		if (incidGb.isEmpty()) incidGb = indiCd;
		String minLevel = str(indi.get("minlevel"));   // 비면 전건

		// 원천에 따라 분자·분모가 갈린다:
		//   INCIDENT = 사고보고 입력분(분자) + 재원일수(분모)
		//   PATVAL   = 환자평가표 자동집계(분자) + 재원일수(분모)
		//   MONITOR  = 관찰기록에서 분자(수행)·분모(관찰)를 동시에 — 재원일수를 안 쓴다(손위생 등)
		String numerSrc = str(indi.get("numersrc"));
		List<Map<String, Object>> months = new ArrayList<>();
		boolean hasDenom;

		if ("MONITOR".equals(numerSrc)) {
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
			List<Map<String, Object>> nrows = "PATVAL".equals(numerSrc)
					? mapper.selectMonthlyNumerPatval(hospCd, inYear)
					: mapper.selectMonthlyNumer(hospCd, incidGb, inYear, minLevel);
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

	private static String str(Object o) { return (o == null) ? "" : String.valueOf(o).trim(); }

	private static int intOf(Object o, int def) {
		if (o == null) return def;
		try { return new BigDecimal(String.valueOf(o).trim().replace(",", "")).intValue(); }
		catch (Exception e) { return def; }
	}
}
