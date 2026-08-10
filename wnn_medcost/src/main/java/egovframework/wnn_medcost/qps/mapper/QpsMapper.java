package egovframework.wnn_medcost.qps.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import egovframework.wnn_medcost.qps.model.QpsCensusDTO;
import egovframework.wnn_medcost.qps.model.QpsIncidentDTO;
import egovframework.wnn_medcost.qps.model.QpsManualDTO;
import egovframework.wnn_medcost.qps.model.QpsMonitorDTO;

/**
 * QPS 매퍼 — 낙상 파일럿.
 *
 * ★단일 원시타입 파라미터에는 반드시 @Param — 안 붙이면 ParamMap 이 안 만들어져
 *   다른 #{} 바인딩이 그 값으로 덮인다(konet 멀티테넌트에서 겪은 함정과 같은 계열).
 */
@Mapper("QpsMapper")
public interface QpsMapper {

	// 지표 마스터 (병원 전용 → 없으면 공통 '*')
	Map<String, Object> selectQpsIndi(@Param("hospCd") String hospCd,
	                                  @Param("indiCd") String indiCd);

	// 서식 2호: 연간 활동계획서 (병원+년도 1부, 항목행 통째 교체)
	Map<String, Object> selectPlan(@Param("hospCd") String hospCd, @Param("formGb") String formGb, @Param("inYear") String inYear);
	int upsertPlan(Map<String, Object> param);
	List<Map<String, Object>> selectPlanItems(@Param("planSeq") long planSeq);
	int deletePlanItems(@Param("planSeq") long planSeq);
	int insertPlanItems(Map<String, Object> param);

	// 서식 3호: 라운딩 점검표 (병원+년월 1부, 항목행 통째 교체)
	Map<String, Object> selectRound(@Param("hospCd") String hospCd, @Param("formGb") String formGb, @Param("roundYm") String roundYm);
	int upsertRound(Map<String, Object> param);
	List<Map<String, Object>> selectRoundItems(@Param("rndSeq") long rndSeq);
	int deleteRoundItems(@Param("rndSeq") long rndSeq);
	int insertRoundItems(Map<String, Object> param);

	// 서식 1호: 위원회 회의록 (서식빌더 결정 근거용 파일럿)
	List<Map<String, Object>> selectMinutesList(@Param("hospCd") String hospCd, @Param("formGb") String formGb,
	                                            @Param("inYear") String inYear);
	Map<String, Object> selectMinutes(@Param("hospCd") String hospCd,
	                                  @Param("minSeq") long minSeq);
	int insertMinutes(Map<String, Object> param);
	int updateMinutes(Map<String, Object> param);
	int deleteMinutes(Map<String, Object> param);

	// 보고서 현황판 — 기간별 18종 전부의 서술·결재 상태
	List<Map<String, Object>> selectRptStatus(@Param("hospCd") String hospCd,
	                                          @Param("prdGb")  String prdGb,
	                                          @Param("prdKey") String prdKey);

	// 공통코드(CODE_GB='Q') — 화면 selectbox 목록. 기준정보 화면에서 항목을 늘린다.
	List<Map<String, Object>> selectQpsCodes();

	// 지표정의서 (병원 행 우선, 없으면 공통 '*')
	Map<String, Object> selectIndiDef(@Param("hospCd") String hospCd,
	                                  @Param("indiCd") String indiCd);
	int saveIndiDef(Map<String, Object> param);
	int deleteIndiDef(@Param("hospCd") String hospCd, @Param("indiCd") String indiCd);

	// 지표 현황 화면 — 영역별 전체 지표 + 그 병원의 입력 자료 유무
	List<Map<String, Object>> selectIndiList(@Param("hospCd") String hospCd,
	                                         @Param("inYear") String inYear);

	// 조회 대상 병원(화면 배지·진단용)
	Map<String, Object> selectHospInfo(@Param("hospCd") String hospCd);

	// 환자 입력검색 (TBL_IPWON_INFO — 위너넷 기존 입원환자 자료)
	List<Map<String, Object>> selectPatientList(@Param("hospCd")  String hospCd,
	                                            @Param("keyword") String keyword,
	                                            @Param("baseDt")  String baseDt);

	// 사고 보고
	List<Map<String, Object>> selectIncidentList(QpsIncidentDTO dto);
	int insertIncident(QpsIncidentDTO dto);
	int updateIncident(QpsIncidentDTO dto);
	int deleteIncident(QpsIncidentDTO dto);

	// 분모 자동산출 — 입원 건 목록(중복 제거). 재원일수 계산은 서비스가 한다.
	List<Map<String, Object>> selectStaysForYear(@Param("hospCd")    String hospCd,
	                                             @Param("yearStart") String yearStart,
	                                             @Param("yearEnd")   String yearEnd);

	// 분모
	Map<String, Object> selectCensus(@Param("hospCd")   String hospCd,
	                                 @Param("censusGb") String censusGb,
	                                 @Param("inYear")   String inYear);
	int saveCensus(QpsCensusDTO dto);

	// 수기입력형(NUMER_SRC='MANUAL') — 월별 분자·분모를 병원이 직접 적는 지표.
	// axisCd '' = 총계(지표 산출이 읽는 행), '정규'/'응급' = 상세(TAT 축별 표)
	Map<String, Object> selectManual(@Param("hospCd") String hospCd,
	                                 @Param("indiCd") String indiCd,
	                                 @Param("inYear") String inYear,
	                                 @Param("valGb")  String valGb,
	                                 @Param("axisCd") String axisCd);
	List<Map<String, Object>> selectManualAxes(@Param("hospCd") String hospCd,
	                                           @Param("indiCd") String indiCd,
	                                           @Param("inYear") String inYear);
	int saveManual(QpsManualDTO dto);

	// 집계
	List<Map<String, Object>> selectMonthlyNumer(@Param("hospCd")   String hospCd,
	                                             @Param("incidGb")  String incidGb,
	                                             @Param("inYear")   String inYear,
	                                             @Param("minLevel") String minLevel);

	// 분자(월별) — 환자평가표 원천(NUMER_SRC='PATVAL'). 욕창과 요로감염은 셈법이 달라 SQL 이 둘이다.
	List<Map<String, Object>> selectMonthlyNumerPatval(@Param("hospCd") String hospCd,
	                                                   @Param("inYear") String inYear);
	List<Map<String, Object>> selectMonthlyNumerPatvalUti(@Param("hospCd") String hospCd,
	                                                      @Param("inYear") String inYear);

	// 관찰형(손위생 등, NUMER_SRC='MONITOR')
	List<Map<String, Object>> selectMonitorList(QpsMonitorDTO dto);
	int insertMonitor(QpsMonitorDTO dto);
	int updateMonitor(QpsMonitorDTO dto);
	int deleteMonitor(QpsMonitorDTO dto);
	List<Map<String, Object>> selectMonthlyMonitor(@Param("hospCd") String hospCd,
	                                               @Param("indiCd") String indiCd,
	                                               @Param("inYear") String inYear);
	List<Map<String, Object>> selectMonitorBreakdown(@Param("hospCd") String hospCd,
	                                                 @Param("indiCd") String indiCd,
	                                                 @Param("fromDt") String fromDt,
	                                                 @Param("toDt")   String toDt);

	List<Map<String, Object>> selectBreakdown(@Param("hospCd")   String hospCd,
	                                          @Param("incidGb")  String incidGb,
	                                          @Param("fromDt")   String fromDt,
	                                          @Param("toDt")     String toDt,
	                                          @Param("minLevel") String minLevel);

	// 보고서(서술)
	Map<String, Object> selectReport(@Param("hospCd") String hospCd,
	                                 @Param("indiCd") String indiCd,
	                                 @Param("prdGb")  String prdGb,
	                                 @Param("prdKey") String prdKey);
	int saveReport(Map<String, Object> param);

	// 확정 스냅샷 — 최종승인 시 그 기간 수치를 동결한다(원천이 바뀌어도 제출값이 안 변하게)
	List<Map<String, Object>> selectStat(Map<String, Object> param);
	int saveStat(Map<String, Object> param);
	int deleteStat(Map<String, Object> param);

	// 결재선 (병원 행이 있으면 그것, 없으면 공통 '*')
	List<Map<String, Object>> selectApprLine(@Param("hospCd") String hospCd);
	int deleteApprLine(@Param("hospCd") String hospCd);
	int insertApprLine(Map<String, Object> param);

	// 결재 이력·상태
	List<Map<String, Object>> selectApprHist(@Param("hospCd") String hospCd,
	                                         @Param("indiCd") String indiCd,
	                                         @Param("prdGb")  String prdGb,
	                                         @Param("prdKey") String prdKey);
	int insertAppr(Map<String, Object> param);
	int updateReportAppr(Map<String, Object> param);

	// 공통 첨부 (TBL_QPS_FILE — REF_GB+REF_KEY)
	List<Map<String, Object>> selectQpsFileList(@Param("hospCd") String hospCd,
	                                            @Param("refGb")  String refGb,
	                                            @Param("refKey") String refKey);
	int insertQpsFile(egovframework.wnn_medcost.qps.model.QpsFileDTO dto);
	int deleteQpsFile(egovframework.wnn_medcost.qps.model.QpsFileDTO dto);
	Map<String, Object> selectQpsFileOne(@Param("fileSeq") Long fileSeq, @Param("hospCd") String hospCd);
	List<Map<String, Object>> selectQpsFileCounts(@Param("hospCd") String hospCd, @Param("refGb") String refGb);

	/* QPS 담당자(자료실 수정 권한) */
	List<Map<String, Object>> selectHospUsers(@Param("hospCd") String hospCd);
	String selectUserMainGu(@Param("hospCd") String hospCd, @Param("userId") String userId);
	int selectQpsMgrCount(@Param("hospCd") String hospCd);
	int selectQpsMgrYn(@Param("hospCd") String hospCd, @Param("userId") String userId);
	int deleteQpsMgrAll(@Param("hospCd") String hospCd);
	int insertQpsMgr(@Param("hospCd") String hospCd, @Param("userId") String userId, @Param("regUser") String regUser);

	/* 감염종합보고 (P 계획수립 / D 수행 / E 손위생 교육결과 — 골격이 같아 한 서식) */
	List<Map<String, Object>> selectInfRptList(@Param("hospCd") String hospCd,
	                                           @Param("rptGb")  String rptGb,
	                                           @Param("inYear") String inYear);
	Map<String, Object> selectInfRpt(@Param("hospCd") String hospCd, @Param("rptSeq") long rptSeq);
	int insertInfRpt(Map<String, Object> param);
	int updateInfRpt(Map<String, Object> param);
	int deleteInfRpt(Map<String, Object> param);
	List<Map<String, Object>> selectInfRptMem(@Param("rptSeq") long rptSeq);
	int deleteInfRptMem(@Param("rptSeq") long rptSeq);
	int insertInfRptMem(Map<String, Object> param);

	/* 감염관리 우선순위 사정 도구 */
	List<Map<String, Object>> selectInfRiskList(@Param("hospCd") String hospCd, @Param("inYear") String inYear);
	Map<String, Object> selectInfRisk(@Param("hospCd") String hospCd, @Param("riskSeq") long riskSeq);
	int insertInfRisk(Map<String, Object> param);
	int deleteInfRisk(Map<String, Object> param);
	List<Map<String, Object>> selectInfRiskItems(@Param("riskSeq") long riskSeq);
	List<Map<String, Object>> selectInfRiskDef();
	int deleteInfRiskItems(@Param("riskSeq") long riskSeq);
	int insertInfRiskItems(Map<String, Object> param);

	/* 감염병환자 월별 리스트 */
	Map<String, Object> selectInfPat(@Param("hospCd") String hospCd, @Param("ipatYm") String ipatYm);
	int upsertInfPat(Map<String, Object> param);
	List<Map<String, Object>> selectInfPatItems(@Param("ipatSeq") long ipatSeq);
	int deleteInfPatItems(@Param("ipatSeq") long ipatSeq);
	int insertInfPatItems(Map<String, Object> param);

	/* 감염관리 전담자 */
	List<Map<String, Object>> selectInfStaffList(@Param("hospCd") String hospCd);
	Map<String, Object> selectInfStaff(@Param("hospCd") String hospCd, @Param("stfSeq") long stfSeq);
	int insertInfStaff(Map<String, Object> param);
	int updateInfStaff(Map<String, Object> param);
	int deleteInfStaff(Map<String, Object> param);
	List<Map<String, Object>> selectInfStaffEdu(@Param("stfSeq") long stfSeq);
	int deleteInfStaffEdu(@Param("stfSeq") long stfSeq);
	int insertInfStaffEdu(Map<String, Object> param);
	List<Map<String, Object>> selectInfStaffDuty(@Param("stfSeq") long stfSeq);
	int deleteInfStaffDuty(@Param("stfSeq") long stfSeq);
	int insertInfStaffDuty(Map<String, Object> param);
}
