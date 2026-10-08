package egovframework.wnn_medcost.mis.service;

import java.util.List;
import java.util.Map;

/** MIS(경영관리) 서비스 — 경영통계 · 고정경비 (2026-10-08). */
public interface MisService {

	Map<String, Object> selectHospInfo(String hospCd) throws Exception;

	/** 경영통계 — 기간(fromYm~toYm)의 월별 집계를 한 번에 묶어 준다(months · insur · classes · inout · scores · avg · grade). */
	Map<String, Object> selectStat(String hospCd, String fromYm, String toYm) throws Exception;
	String selectLastClaimYm(String hospCd) throws Exception;

	/** 고정경비 — 한 달 화면에 필요한 것 전부(cfg · cats · cost(이 달) · prevYm · prevCost · claim(이 달) · trend). */
	Map<String, Object> selectCostPage(String hospCd, String ym) throws Exception;
	void saveCfg(Map<String, Object> p) throws Exception;
	void saveCat(Map<String, Object> p) throws Exception;
	/** 병원 전용 항목 삭제 — 금액 기록이 있으면 거절(사용 끄기를 안내). 공통 항목은 매퍼 WHERE 가 막는다. */
	int deleteCat(String hospCd, String catCd) throws Exception;
	/** 한 달 금액 통째 저장(지우고 다시 넣기) — 행마다 catCd·amt·memo. */
	void saveCostMonth(String hospCd, String ym, List<Map<String, Object>> rows, String userId) throws Exception;
}
