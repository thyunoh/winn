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
}
