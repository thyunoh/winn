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

	/* 만족도 개선활동 결과보고서 — 원본 4종은 <부서 × 유형> 조합일 뿐 같은 서식이다 */
	List<Map<String, Object>> selectSrvImprList(@Param("hospCd") String hospCd, @Param("inYear") String inYear);
	Map<String, Object> selectSrvImpr(@Param("hospCd") String hospCd, @Param("imprSeq") long imprSeq);
	int insertSrvImpr(Map<String, Object> param);
	int updateSrvImpr(Map<String, Object> param);
	int deleteSrvImpr(Map<String, Object> param);
	List<Map<String, Object>> selectSrvImprItems(@Param("imprSeq") long imprSeq);
	int deleteSrvImprItems(@Param("imprSeq") long imprSeq);
	int insertSrvImprItems(Map<String, Object> param);

	/* QI 활동 계획서 — 서식 하나 + 주제(지표)별 여러 장 */
	List<Map<String, Object>> selectQiPlanList(@Param("hospCd") String hospCd, @Param("inYear") String inYear);
	Map<String, Object> selectQiPlan(@Param("hospCd") String hospCd, @Param("qipSeq") long qipSeq);
	int insertQiPlan(Map<String, Object> param);
	int updateQiPlan(Map<String, Object> param);
	int deleteQiPlan(Map<String, Object> param);
	List<Map<String, Object>> selectQiPlanItems(@Param("qipSeq") long qipSeq);
	int deleteQiPlanItems(@Param("qipSeq") long qipSeq);
	int insertQiPlanItems(Map<String, Object> param);

	/* FMEA 계획서·보고서 (한 표 + DOC_GB) */
	List<Map<String, Object>> selectFmeaScale();
	List<Map<String, Object>> selectFmeaList(@Param("hospCd") String hospCd, @Param("inYear") String inYear,
	                                         @Param("docGb") String docGb);
	Map<String, Object> selectFmea(@Param("hospCd") String hospCd, @Param("fmeSeq") long fmeSeq);
	int insertFmea(Map<String, Object> param);
	int updateFmea(Map<String, Object> param);
	int deleteFmea(Map<String, Object> param);
	List<Map<String, Object>> selectFmeaItems(@Param("fmeSeq") long fmeSeq);
	int deleteFmeaItems(@Param("fmeSeq") long fmeSeq);
	int insertFmeaItems(Map<String, Object> param);
	List<Map<String, Object>> selectFmeaSheet(@Param("fmeSeq") long fmeSeq);
	int deleteFmeaSheet(@Param("fmeSeq") long fmeSeq);
	int insertFmeaSheet(Map<String, Object> param);

	/* RCA 근본원인 분석 보고서 — 항목 고정, 표 하나 */
	List<Map<String, Object>> selectRcaList(@Param("hospCd") String hospCd, @Param("inYear") String inYear);
	Map<String, Object> selectRca(@Param("hospCd") String hospCd, @Param("rcaSeq") long rcaSeq);
	int insertRca(Map<String, Object> param);
	int updateRca(Map<String, Object> param);
	int deleteRca(Map<String, Object> param);

	/* 사고 유형별 보고서 — 체크 묶음은 항목표(DEF)에서 온다 */
	List<Map<String, Object>> selectSafeRptDef(@Param("rptGb") String rptGb);
	List<Map<String, Object>> selectSafeRptList(@Param("hospCd") String hospCd, @Param("inYear") String inYear,
	                                            @Param("rptGb") String rptGb);
	Map<String, Object> selectSafeRpt(@Param("hospCd") String hospCd, @Param("srpSeq") long srpSeq);
	int insertSafeRpt(Map<String, Object> param);
	int updateSafeRpt(Map<String, Object> param);
	int deleteSafeRpt(Map<String, Object> param);
	List<Map<String, Object>> selectSafeRptChk(@Param("srpSeq") long srpSeq);
	int deleteSafeRptChk(@Param("srpSeq") long srpSeq);
	int insertSafeRptChk(Map<String, Object> param);
	// 반복행 표 · 서명란 · 정형문구 (2026-08-14) — 저장이 필요한 건 반복행뿐(나머지 둘은 인쇄 전용)
	Map<String, Object> selectSafeRptForm(@Param("rptGb") String rptGb);
	List<Map<String, Object>> selectSafeRptRow(@Param("srpSeq") long srpSeq);
	int deleteSafeRptRow(@Param("srpSeq") long srpSeq);
	int insertSafeRptRow(Map<String, Object> param);
	// 반복행 표 여러 벌 (2026-08-15) — 벌이 있으면 FORM 단벌 정의를 이긴다
	List<Map<String, Object>> selectSafeRptSub(@Param("rptGb") String rptGb);
	// 사진첨부 (2026-08-14) — 칸(1~4) 고정, 같은 칸 재업로드=교체(UPSERT)
	List<Map<String, Object>> selectSafeRptFile(@Param("srpSeq") long srpSeq);
	int upsertSafeRptFile(Map<String, Object> param);
	int deleteSafeRptFile(@Param("srpSeq") long srpSeq, @Param("fileSeq") int fileSeq);
	// 점검표 사진칸 (2026-08-15) — 서식 PHOTO_NMS 가 칸 이름·수를 정한다
	List<Map<String, Object>> selectChkFile(@Param("chkSeq") long chkSeq);
	int upsertChkFile(Map<String, Object> param);
	int deleteChkFile(@Param("chkSeq") long chkSeq, @Param("fileSeq") int fileSeq);

	// 사용자 ↔ 담당 부서 (2026-08-15) — 등록이 없으면 「전 부서」다(막는 장치가 아니다)
	List<Map<String, Object>> selectQpsUserList(@Param("hospCd") String hospCd);
	List<String> selectQpsUserDept(@Param("hospCd") String hospCd, @Param("userId") String userId);
	int deleteQpsUserDept(@Param("hospCd") String hospCd, @Param("userId") String userId);
	int insertQpsUserDept(Map<String, Object> param);

	// 부서별 「쓰는 분류」 (2026-08-18) — 정해 둔 것이 없는 부서는 「전 분류」다
	List<Map<String, Object>> selectDeptCate();
	List<Map<String, Object>> selectDeptCateCnt();
	List<Map<String, Object>> selectDeptMenuCnt(@Param("hospCd") String hospCd);
	/** 부서별 양식 관리 — 부서·분류 두 칸만 고친다(공통 '*' 행도 대상. 위너넷 전용) */
	int updateChkFormDept(Map<String, Object> param);

	// 지표분석보고서 분포 표 — ★원자료만 꺼낸다(구간 나누기는 자바)
	List<Map<String, Object>> selectIncidDistRows(Map<String, Object> param);
	List<Map<String, Object>> selectSecLogDistRows(Map<String, Object> param);
	int deleteDeptCate(@Param("deptCd") String deptCd);
	int insertDeptCate(Map<String, Object> param);

	/* QI 중간·최종보고서 (한 표 + RPT_GB) */
	List<Map<String, Object>> selectQiRptList(@Param("hospCd") String hospCd, @Param("inYear") String inYear,
	                                          @Param("rptGb") String rptGb);
	Map<String, Object> selectQiRpt(@Param("hospCd") String hospCd, @Param("qirSeq") long qirSeq);
	int insertQiRpt(Map<String, Object> param);
	int updateQiRpt(Map<String, Object> param);
	int deleteQiRpt(Map<String, Object> param);
	List<Map<String, Object>> selectQiRptItems(@Param("qirSeq") long qirSeq);
	int deleteQiRptItems(@Param("qirSeq") long qirSeq);
	int insertQiRptItems(Map<String, Object> param);

	/* QI 주제선정 기준표(평가위원 1명=1장) + 우선순위 집계(저장 안 함, 계산) */
	List<Map<String, Object>> selectQiTopicList(@Param("hospCd") String hospCd, @Param("inYear") String inYear);
	Map<String, Object> selectQiTopic(@Param("hospCd") String hospCd, @Param("qitSeq") long qitSeq);
	int insertQiTopic(Map<String, Object> param);
	int updateQiTopic(Map<String, Object> param);
	int deleteQiTopic(Map<String, Object> param);
	List<Map<String, Object>> selectQiTopicItems(@Param("qitSeq") long qitSeq);
	int deleteQiTopicItems(@Param("qitSeq") long qitSeq);
	int insertQiTopicItems(Map<String, Object> param);
	List<Map<String, Object>> selectQiTopicRollup(@Param("hospCd") String hospCd, @Param("inYear") String inYear);
	List<Map<String, Object>> selectQiTopicCross(@Param("hospCd") String hospCd, @Param("inYear") String inYear);

	/* QI 활동 자원지원 내역 (연 1부) */
	Map<String, Object> selectQiFund(@Param("hospCd") String hospCd, @Param("inYear") String inYear);
	int upsertQiFund(Map<String, Object> param);
	List<Map<String, Object>> selectQiFundItems(@Param("qifSeq") long qifSeq);
	int deleteQiFundItems(@Param("qifSeq") long qifSeq);
	int insertQiFundItems(Map<String, Object> param);

	/* 불만고충 — 처리대장(급소) · 건별 처리결과 · 지표분석보고서 */
	List<Map<String, Object>> selectCmplList(@Param("hospCd") String hospCd, @Param("inYear") String inYear);
	int insertCmpl(Map<String, Object> param);
	int updateCmpl(Map<String, Object> param);
	int deleteCmpl(Map<String, Object> param);
	Map<String, Object> selectCmplAct(@Param("hospCd") String hospCd, @Param("cmplSeq") long cmplSeq);
	int upsertCmplAct(Map<String, Object> param);
	Map<String, Object> selectCmplRpt(@Param("hospCd") String hospCd, @Param("inYear") String inYear,
	                                  @Param("halfGb") String halfGb);
	int upsertCmplRpt(Map<String, Object> param);
	/* 집계 — 전부 처리대장에서. frMm~toMm 은 반기 범위('01'~'06' / '07'~'12') */
	List<Map<String, Object>> selectCmplStatMonth(Map<String, Object> param);
	List<Map<String, Object>> selectCmplStatAxis(Map<String, Object> param);
	List<Map<String, Object>> selectCmplStatTypeMonth(Map<String, Object> param);
	List<Map<String, Object>> selectCmplStatTerm(Map<String, Object> param);
	List<Map<String, Object>> selectCmplStatHalf(Map<String, Object> param);

	/** 지표 SATISFY 자동집계 — 설문에서 월별(조사 종료월) 점수합·만점합. */
	List<Map<String, Object>> selectSrvStatMonth(@Param("hospCd") String hospCd, @Param("inYear") String inYear);

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

	// ── 환자만족도 조사 : 설문 ──────────────────────────────────────
	List<Map<String, Object>> selectSrvDef();

	List<Map<String, Object>> selectSurveyList(Map<String, Object> param);
	Map<String, Object> selectSurvey(Map<String, Object> param);
	int selectSurveyNextSeq(Map<String, Object> param);
	int insertSurvey(Map<String, Object> param);
	int updateSurvey(Map<String, Object> param);

	List<Map<String, Object>> selectSurveyAnsList(Map<String, Object> param);
	List<Map<String, Object>> selectSurveyAnsItem(@Param("ansId") long ansId);
	int selectSurveyNextAnsNo(Map<String, Object> param);
	int insertSurveyAns(Map<String, Object> param);
	int updateSurveyAns(Map<String, Object> param);
	int deleteSurveyAns(Map<String, Object> param);
	int deleteSurveyAnsItem(@Param("ansId") long ansId);
	int insertSurveyAnsItem(Map<String, Object> param);

	List<Map<String, Object>> selectSrvStatItem(Map<String, Object> param);
	List<Map<String, Object>> selectSrvStatArea(Map<String, Object> param);
	Map<String, Object> selectSrvStatTotal(Map<String, Object> param);
	List<Map<String, Object>> selectSrvStatProfile(Map<String, Object> param);
	List<Map<String, Object>> selectSrvOpinion(Map<String, Object> param);

	/* ═══ 점검표 엔진 — 서식이 코드가 아니라 데이터다 ═══ */
	List<Map<String, Object>> selectChkFormList(@Param("hospCd") String hospCd, @Param("cateCd") String cateCd,
	                                            @Param("deptCd") String deptCd,
	                                            @Param("onlyUse") String onlyUse);
	int deleteChkUse(@Param("hospCd") String hospCd);
	int insertChkUse(Map<String, Object> param);
	/** 서식 화면에서 부서·분류 코드 추가 — 추가만(지우기는 공통코드 화면에서). */
	int insertChkCode(Map<String, Object> param);
	/** 서식코드 중복 검사 — 새 서식 저장 전 필수(안 하면 남의 서식을 덮는다). */
	int countChkForm(@Param("formId") String formId);
	/** 이 병원이 사용 서식을 직접 정한 적이 있는가(0 이면 기본 세트를 그대로 쓰는 중) */
	int countChkUseHosp(@Param("hospCd") String hospCd);
	int selectChkCodeMax(@Param("prefix") String prefix);
	Map<String, Object> selectChkForm(@Param("hospCd") String hospCd, @Param("formId") String formId);
	List<Map<String, Object>> selectChkItems(@Param("hospCd") String hospCd, @Param("formId") String formId);
	int saveChkForm(Map<String, Object> param);
	int deleteChkForm(Map<String, Object> param);
	int deleteChkItems(@Param("hospCd") String hospCd, @Param("formId") String formId);
	int insertChkItems(Map<String, Object> param);

	List<Map<String, Object>> selectChkDocList(@Param("hospCd") String hospCd, @Param("formId") String formId,
	                                           @Param("inYear") String inYear);
	Map<String, Object> selectChkDoc(@Param("hospCd") String hospCd, @Param("chkSeq") long chkSeq);
	int insertChkDoc(Map<String, Object> param);
	int updateChkDoc(Map<String, Object> param);
	int deleteChkDoc(Map<String, Object> param);

	List<Map<String, Object>> selectChkVals(@Param("chkSeq") long chkSeq);
	int deleteChkVals(@Param("chkSeq") long chkSeq);
	int insertChkVals(Map<String, Object> param);
	List<Map<String, Object>> selectChkRows(@Param("chkSeq") long chkSeq);
	int deleteChkRows(@Param("chkSeq") long chkSeq);
	int insertChkRows(Map<String, Object> param);

	/** 전월 복사·월 생성이 <b>틀</b>을 가져올 직전 문서(2026-08-12, v3 순서 9). */
	Map<String, Object> selectChkDocPrev(Map<String, Object> param);
	/** 그 달에 이미 있는 문서 번호들 — 월 생성이 같은 날을 또 만들지 않도록. */
	List<Integer> selectChkDocNos(Map<String, Object> param);

	/** 문서가 정하는 <b>열</b> 이름 — 바로 위 CHK_ROW 의 대칭(2026-08-12, v3 순서 8). */
	List<Map<String, Object>> selectChkCols(@Param("chkSeq") long chkSeq);
	int deleteChkCols(@Param("chkSeq") long chkSeq);
	int insertChkCols(Map<String, Object> param);

	/** 데이터 추출 — 평면 한 줄씩(엑셀/집계용). 축을 되돌려 일자·항목으로 준다. */
	List<Map<String, Object>> selectChkExtract(Map<String, Object> param);
	List<Map<String, Object>> selectChkSummary(Map<String, Object> param);

	/* ═══ 격리·강박 시행일지 (2026-08-18) ═══
	   ★지표 ISOLATION/SECLUSION 의 원천이다 — 분모=전체 건수, 분자=GUIDE_YN='Y'. */
	Map<String, Object> selectSecLog(@Param("hospCd") String hospCd, @Param("logYm") String logYm);
	int upsertSecLog(Map<String, Object> param);
	List<Map<String, Object>> selectSecLogItems(@Param("logSeq") long logSeq);
	int deleteSecLogItems(@Param("logSeq") long logSeq);
	int insertSecLogItems(Map<String, Object> param);
	/** 관찰형 집계 반영 — 그 달 그 지표 행을 지우고 다시 넣는다(다시 세는 것이다). */
	int deleteSecLogMonitor(Map<String, Object> param);
	int insertSecLogMonitor(Map<String, Object> param);

	/* ═══ 유치도뇨관 월별 기록지 (2026-08-18) ═══
	   ★CATH_CNT 월 합계가 지표 UTI 의 분모(유치도뇨관 일수)다. */
	Map<String, Object> selectCathDay(@Param("hospCd") String hospCd, @Param("cathYm") String cathYm);
	int upsertCathDay(Map<String, Object> param);
	List<Map<String, Object>> selectCathDayItems(@Param("cathSeq") long cathSeq);
	int deleteCathDayItems(@Param("cathSeq") long cathSeq);
	int insertCathDayItems(Map<String, Object> param);
	/** 분모 반영 — TBL_QPS_CENSUS(CATHDAYS)의 해당 월 칸만 갱신. monCol 은 서버가 M01~M12 로만 만든다. */
	int upsertCathCensus(Map<String, Object> param);
}
