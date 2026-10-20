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
	int deleteLeadLog(Map<String, Object> p);   // 2026-10-16 상담 이력 한 줄 삭제
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

	/* ── 효사랑가족요양병원 AI 사례 적용 · 원장 진단 (2026-10-16) — EMR 없이 청구·평가표만으로 ── */
	/** 환자군(A~E)별 1인 1일 진료비·본인부담·공단부담 — 입원 상담 예상 비용·환자군별 수익성 */
	List<Map<String, Object>> selectClassCost(@Param("hospCd") String hospCd, @Param("fromYm") String fromYm, @Param("toYm") String toYm);
	/** 그 달 평가표↔청구 명세서 환자 대조 — gb NOCLAIM(평가표만)/NOPATVAL(명세서만) */
	List<Map<String, Object>> selectClaimPatvalGap(@Param("hospCd") String hospCd, @Param("ym") String ym);
	/** 고객 병원 대비 위치 — 그 달 1인 1일 진료비·입원일수 순위 */
	Map<String, Object> selectPeerRank(@Param("hospCd") String hospCd, @Param("ym") String ym);

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
	/** 종별 › 지급처 대조 — 샘파일 명세서·청구액 vs 삭감·불능·조정 (미매칭 삭감은 종별 '?') */
	List<Map<String, Object>> selectEmrCutGroup(@Param("hospCd") String hospCd, @Param("ym") String ym);
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

	/* ── 병원 내규 · 안내문 (2026-10-12) ── */
	List<Map<String, Object>> selectRules(@Param("hospCd") String hospCd);
	int insertRule(Map<String, Object> p);
	int updateRule(Map<String, Object> p);
	int deleteRule(Map<String, Object> p);
	int countQpsPending(@Param("hospCd") String hospCd);

	/* ── 안내문 저장 (2026-10-13) ── */
	List<Map<String, Object>> selectLeaflets(@Param("hospCd") String hospCd);
	Map<String, Object> selectLeaflet(@Param("hospCd") String hospCd, @Param("leafSeq") long leafSeq);
	int insertLeaflet(Map<String, Object> p);
	int updateLeaflet(Map<String, Object> p);
	int deleteLeaflet(Map<String, Object> p);

	/* ── 통합검색 v1 (2026-10-13) ── */
	List<Map<String, Object>> selectLeafletBodies(@Param("hospCd") String hospCd);

	/* ── 병원장 조회 · 원무 환자고객 · 간호사 관리 (2026-10-15) ── */
	List<Map<String, Object>> selectCurrentPats(@Param("hospCd") String hospCd);
	List<Map<String, Object>> selectIpwonOnlyPats(@Param("hospCd") String hospCd);
	List<Map<String, Object>> selectNurseRoster(@Param("hospCd") String hospCd);
	List<Map<String, Object>> selectStaffChgs(@Param("hospCd") String hospCd, @Param("fromDt") String fromDt);
	Map<String, Object> selectStaffChgNet(@Param("hospCd") String hospCd);
	// 적정성 장기입원 지표(TBL_PAT_INDI 14) — 해당 월 자료생성 결과. dtor=분모(대상), ntor=분자(181일 이상)
	Map<String, Object> selectPatIndi14(@Param("hospCd") String hospCd, @Param("ym") String ym);
	// 차등제 신고 간호사 수·평균 재원 — 그 달에 쓰이는 분기 우선(다음 분기 → 그 분기 → 그 해 최신)
	Map<String, Object> selectGradeStaff(@Param("hospCd") String hospCd,
	                                     @Param("startYy") String startYy,
	                                     @Param("qterFlag") String qterFlag,
	                                     @Param("nextYy") String nextYy,
	                                     @Param("nextQt") String nextQt);
	int insertStaffChg(Map<String, Object> p);
	int deleteStaffChg(Map<String, Object> p);

	/* ── 경영 보고서 (2026-10-15) — SWCHMISU 경영 보고서 형태, 청구월 한 달 + 전월 ── */
	List<Map<String, Object>> selectReportItems(@Param("hospCd") String hospCd, @Param("ym") String ym);
	List<Map<String, Object>> selectReportDiags(@Param("hospCd") String hospCd, @Param("ym") String ym);
	List<Map<String, Object>> selectReportInOut(@Param("hospCd") String hospCd, @Param("ym") String ym);
	List<Map<String, Object>> selectReportDept(@Param("hospCd") String hospCd, @Param("ym") String ym);
	List<Map<String, Object>> selectReportDrug(@Param("hospCd") String hospCd, @Param("ym") String ym);

		/* ── 원무 수입실적 (2026-10-15) ── */
		List<Map<String, Object>> selectRevRows(@Param("hospCd") String hospCd, @Param("fromDt") String fromDt, @Param("toDt") String toDt);
}
