package egovframework.wnn_medcost.mis.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

/**
 * MIS(경영관리) 매퍼 — 경영통계 · 고정경비 (2026-10-08).
 *
 * ★단일 원시타입 파라미터에는 반드시 @Param — 안 붙이면 ParamMap 이 안 만들어져
 *   다른 #{} 바인딩이 그 값으로 덮인다(QpsMapper 와 같은 규칙).
 */
@Mapper("MisMapper")
public interface MisMapper {

	Map<String, Object> selectHospInfo(@Param("hospCd") String hospCd);

	/* ── 경영통계(집계) ── */
	List<Map<String, Object>> selectMonthClaim(@Param("hospCd") String hospCd, @Param("fromYm") String fromYm, @Param("toYm") String toYm);
	List<Map<String, Object>> selectMonthInsur(@Param("hospCd") String hospCd, @Param("fromYm") String fromYm, @Param("toYm") String toYm);
	List<Map<String, Object>> selectMonthClass(@Param("hospCd") String hospCd, @Param("fromYm") String fromYm, @Param("toYm") String toYm);
	List<Map<String, Object>> selectMonthInOut(@Param("hospCd") String hospCd, @Param("fromYm") String fromYm, @Param("toYm") String toYm);
	List<Map<String, Object>> selectMonthScore(@Param("hospCd") String hospCd, @Param("fromYm") String fromYm, @Param("toYm") String toYm);
	List<Map<String, Object>> selectMonthAvg(@Param("fromYm") String fromYm, @Param("toYm") String toYm);
	Map<String, Object> selectGradeLatest(@Param("hospCd") String hospCd);
	String selectLastClaimYm(@Param("hospCd") String hospCd);

	/* ── 고정경비 ── */
	Map<String, Object> selectCfg(@Param("hospCd") String hospCd);
	int saveCfg(Map<String, Object> p);
	List<Map<String, Object>> selectCats(@Param("hospCd") String hospCd);
	int saveCat(Map<String, Object> p);
	int deleteCat(@Param("hospCd") String hospCd, @Param("catCd") String catCd);
	int countCostByCat(@Param("hospCd") String hospCd, @Param("catCd") String catCd);
	List<Map<String, Object>> selectCost(@Param("hospCd") String hospCd, @Param("ym") String ym);
	String selectPrevCostYm(@Param("hospCd") String hospCd, @Param("ym") String ym);
	List<Map<String, Object>> selectCostTrend(@Param("hospCd") String hospCd, @Param("fromYm") String fromYm, @Param("toYm") String toYm);
	int deleteCostMonth(@Param("hospCd") String hospCd, @Param("ym") String ym);
	int insertCost(Map<String, Object> p);
}
