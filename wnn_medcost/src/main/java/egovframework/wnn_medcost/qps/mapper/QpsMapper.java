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

	// 수기입력형(NUMER_SRC='MANUAL') — 월별 분자·분모를 병원이 직접 적는 지표
	Map<String, Object> selectManual(@Param("hospCd") String hospCd,
	                                 @Param("indiCd") String indiCd,
	                                 @Param("inYear") String inYear,
	                                 @Param("valGb")  String valGb);
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
}
