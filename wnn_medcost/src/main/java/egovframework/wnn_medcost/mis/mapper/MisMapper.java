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

	/* ── 업무 알림 ── */
	int countClaimYm(@Param("hospCd") String hospCd, @Param("ym") String ym);
	Map<String, Object> selectIpwonYm(@Param("hospCd") String hospCd, @Param("ym") String ym);
	Map<String, Object> selectPatvalYm(@Param("hospCd") String hospCd, @Param("ym") String ym);
	Map<String, Object> selectPatIndiYm(@Param("hospCd") String hospCd, @Param("ym") String ym);
	int countGradeQ(@Param("hospCd") String hospCd, @Param("yy") String yy, @Param("qt") String qt);
	int countCostYm(@Param("hospCd") String hospCd, @Param("ym") String ym);
	List<Map<String, Object>> selectStructZones(@Param("today") String today);

	/* ── ④ 신규환자 고객관리 ── */
	List<Map<String, Object>> selectLeads(@Param("hospCd") String hospCd);
	Map<String, Object> selectLead(@Param("hospCd") String hospCd, @Param("leadSeq") long leadSeq);
	int insertLead(Map<String, Object> p);
	int updateLead(Map<String, Object> p);
	int updateLeadStage(Map<String, Object> p);
	int updateLeadMatch(Map<String, Object> p);
	int deleteLead(Map<String, Object> p);
	List<Map<String, Object>> selectLeadMatches(@Param("hospCd") String hospCd);
	int insertLeadLog(Map<String, Object> p);
	List<Map<String, Object>> selectLeadLogs(@Param("hospCd") String hospCd, @Param("leadSeq") long leadSeq);
	List<Map<String, Object>> selectLeadStats(@Param("hospCd") String hospCd, @Param("fromDt") String fromDt, @Param("toDt") String toDt);
	List<Map<String, Object>> selectFollowList(@Param("hospCd") String hospCd, @Param("fromYm") String fromYm, @Param("fromDt") String fromDt, @Param("toDt") String toDt);
	int saveFollow(Map<String, Object> p);

	/* ── ③-2 문자·메일 알림 (2026-10-08) ── */
	List<Map<String, Object>> selectNotiUsers(@Param("hospCd") String hospCd);
	int insertNotiUser(Map<String, Object> p);
	int updateNotiUser(Map<String, Object> p);
	int deleteNotiUser(@Param("hospCd") String hospCd, @Param("notiSeq") long notiSeq);
	List<Map<String, Object>> selectNotiCandidates(@Param("hospCd") String hospCd);
	int insertNotiLog(Map<String, Object> p);
	List<Map<String, Object>> selectNotiLogs(@Param("hospCd") String hospCd);
	List<String> selectNotiHosps();
	int insertNotiRun(@Param("runDt") String runDt, @Param("runHost") String runHost);
	/** MIS 계약(CONACT_GB='M') 유효 건수 — 메뉴 노출·화면 진입 판정 */
	int countMisContract(@Param("hospCd") String hospCd);

	/* ── EMR 엑셀 연계 (2026-10-11) ── insert 는 Map(hospCd·ym·userId·rows) */
	List<Map<String, Object>> selectEmrMaps(@Param("hospCd") String hospCd);
	int saveEmrMap(Map<String, Object> p);
	int insertEmrUpload(Map<String, Object> p);
	List<Map<String, Object>> selectEmrUploads(@Param("hospCd") String hospCd);
	int deleteEmrPay(@Param("hospCd") String hospCd, @Param("ym") String ym);
	int insertEmrPay(Map<String, Object> p);
	List<Map<String, Object>> selectEmrPayRows(@Param("hospCd") String hospCd, @Param("ym") String ym);
	List<Map<String, Object>> selectEmrPaySum(@Param("hospCd") String hospCd, @Param("ym") String ym);
	int deleteEmrAct(@Param("hospCd") String hospCd, @Param("ym") String ym);
	int insertEmrAct(Map<String, Object> p);
	List<Map<String, Object>> selectEmrActRows(@Param("hospCd") String hospCd, @Param("ym") String ym);
	List<Map<String, Object>> selectEmrActSum(@Param("hospCd") String hospCd, @Param("ym") String ym);
	int deleteEmrCut(@Param("hospCd") String hospCd, @Param("ym") String ym);
	int insertEmrCut(Map<String, Object> p);
	List<Map<String, Object>> selectEmrCutRows(@Param("hospCd") String hospCd, @Param("ym") String ym);
	List<Map<String, Object>> selectEmrCutSum(@Param("hospCd") String hospCd, @Param("ym") String ym);
	List<Map<String, Object>> selectEmrCutTop(@Param("hospCd") String hospCd, @Param("ym") String ym);
	/** 삭감 줄 ↔ 그 달 샘파일 명세서 매칭 요약(구분별 줄·삭감액) */
	List<Map<String, Object>> selectEmrCutMatchSum(@Param("hospCd") String hospCd, @Param("ym") String ym);
	/** 그 달 샘파일 청구 합계 — 삭감률 분모 */
	Map<String, Object> selectEmrSamSum(@Param("hospCd") String hospCd, @Param("ym") String ym);
	int deleteEmrContact(@Param("hospCd") String hospCd);
	int insertEmrContact(Map<String, Object> p);
	List<Map<String, Object>> selectEmrContactRows(@Param("hospCd") String hospCd);
	Map<String, Object> selectEmrContactSum(@Param("hospCd") String hospCd);
	int deleteEmrStaff(@Param("hospCd") String hospCd, @Param("ym") String ym);
	int insertEmrStaff(Map<String, Object> p);
	List<Map<String, Object>> selectEmrStaffRows(@Param("hospCd") String hospCd, @Param("ym") String ym);
	List<Map<String, Object>> selectEmrStaffSum(@Param("hospCd") String hospCd, @Param("ym") String ym);
	Map<String, Object> selectEmrIpwonSum(@Param("hospCd") String hospCd, @Param("ym") String ym);
}
