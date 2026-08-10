package egovframework.wnn_medcost.qps.service;

import java.util.List;
import java.util.Map;

import egovframework.wnn_medcost.qps.model.QpsCensusDTO;
import egovframework.wnn_medcost.qps.model.QpsIncidentDTO;
import egovframework.wnn_medcost.qps.model.QpsManualDTO;
import egovframework.wnn_medcost.qps.model.QpsMonitorDTO;

public interface QpsService {

	/** 조회 대상 병원 — 화면 배지에 서버 기준 병원을 찍기 위한 것. */
	Map<String, Object> selectHospInfo(String hospCd) throws Exception;

	/** 지표 마스터 1건 — 화면 제목·사고구분을 서버에서 정하기 위한 것. */
	Map<String, Object> selectQpsIndi(String hospCd, String indiCd) throws Exception;

	/** 환자 입력검색 — 위너넷 입원환자(TBL_IPWON_INFO)에서 고른다. QPS 는 환자를 따로 등록하지 않는다. */
	List<Map<String, Object>> selectPatientList(String hospCd, String keyword, String baseDt) throws Exception;

	List<Map<String, Object>> selectIncidentList(QpsIncidentDTO dto) throws Exception;
	int saveIncident(QpsIncidentDTO dto) throws Exception;
	int deleteIncident(QpsIncidentDTO dto) throws Exception;

	/** 관찰형 기록(손위생 등) — 관찰건수·수행건수 건별 입력. */
	List<Map<String, Object>> selectMonitorList(QpsMonitorDTO dto) throws Exception;
	int saveMonitor(QpsMonitorDTO dto) throws Exception;
	int deleteMonitor(QpsMonitorDTO dto) throws Exception;
	Map<String, Object> selectMonitorBreakdown(String hospCd, String indiCd, String fromDt, String toDt) throws Exception;

	Map<String, Object> selectCensus(String hospCd, String censusGb, String inYear) throws Exception;

	/** 재원일수 자동산출 — 입퇴원 자료(TBL_IPWON_INFO)로 월별 재원일수를 계산한다(저장은 안 함). */
	Map<String, Object> calcCensusFromIpwon(String hospCd, String inYear) throws Exception;
	int saveCensus(QpsCensusDTO dto) throws Exception;

	// 서식 2호: 연간 활동계획서
	Map<String, Object> selectPlanWithItems(String hospCd, String inYear) throws Exception;
	long savePlan(String hospCd, String inYear, String submitDt,
	              List<Map<String, Object>> items, String userId) throws Exception;

	/** 기간(2026Q1 등)의 전 지표 요약 — 회의록 [지표 요약 넣기]용. {indinm, unit, rate, numer, denom} 목록. */
	List<Map<String, Object>> selectIndiSummary(String hospCd, String prdGb, String prdKey) throws Exception;

	// 서식 3호: 라운딩 점검표
	Map<String, Object> selectRoundWithItems(String hospCd, String roundYm) throws Exception;
	long saveRound(String hospCd, String roundYm, String checker,
	               List<Map<String, Object>> items, String userId) throws Exception;

	// 서식 1호: 위원회 회의록
	List<Map<String, Object>> selectMinutesList(String hospCd, String inYear) throws Exception;
	Map<String, Object> selectMinutes(String hospCd, long minSeq) throws Exception;
	long saveMinutes(Map<String, Object> param) throws Exception;
	int deleteMinutes(Map<String, Object> param) throws Exception;

	/** 보고서 현황판 — 기간별 18종 전부의 서술·결재 상태. */
	List<Map<String, Object>> selectRptStatus(String hospCd, String prdGb, String prdKey) throws Exception;

	/** 공통코드(CODE_GB='Q') — 화면 selectbox 목록. */
	List<Map<String, Object>> selectQpsCodes() throws Exception;

	/** 지표정의서 — 병원 행이 있으면 그것, 없으면 공통 기본값(own='N'). */
	Map<String, Object> selectIndiDef(String hospCd, String indiCd) throws Exception;
	/** 지표정의서 저장 — 항상 그 병원 행에 쓴다(공통값은 건드리지 않는다). */
	int saveIndiDef(Map<String, Object> param) throws Exception;
	/** 병원 정의서 삭제 — 공통 기본값으로 되돌린다. */
	int deleteIndiDef(String hospCd, String indiCd) throws Exception;

	/** 결재선 — 병원 전용이 있으면 그것, 없으면 공통 기본(4단계). */
	List<Map<String, Object>> selectApprLine(String hospCd) throws Exception;

	/** 결재선 저장 — 단계 목록을 통째로 교체한다(줄이면 뒤 단계가 사라진다). */
	int saveApprLine(String hospCd, List<String> stepNames, String userId) throws Exception;

	/** 결재 상태 + 결재선 + 이력을 한 번에 (화면이 한 번의 호출로 그린다). */
	Map<String, Object> selectApprState(String hospCd, String indiCd, String prdGb, String prdKey) throws Exception;

	/**
	 * 결재 처리 — actGb = SUBMIT(상신) / APPROVE(승인) / REJECT(반려) / CANCEL(상신취소).
	 * 상태 전이가 맞지 않으면 예외를 던진다(두 사람이 동시에 눌렀을 때 순서가 꼬이는 것을 막는다).
	 */
	Map<String, Object> actAppr(Map<String, Object> param) throws Exception;

	/** 지표 현황 — 영역별 전체 지표 + 병원의 입력 자료 유무. */
	List<Map<String, Object>> selectIndiList(String hospCd, String inYear) throws Exception;

	/** 수기입력형 지표의 월별 값 — valGb = NUMER/DENOM, axisCd '' = 총계, '정규'/'응급' = 상세. */
	Map<String, Object> selectManual(String hospCd, String indiCd, String inYear, String valGb, String axisCd) throws Exception;
	/** 축 상세 행 전부 — 분석 탭의 축별 집계표용. */
	List<Map<String, Object>> selectManualAxes(String hospCd, String indiCd, String inYear) throws Exception;
	int saveManual(QpsManualDTO dto) throws Exception;

	/** 지표 산출 — 월별 분자/분모/율 + 분기 집계 + 지표정의를 한 번에 돌려준다. */
	Map<String, Object> calcIndicator(String hospCd, String indiCd, String inYear) throws Exception;

	/** 분류별 집계 — 분자와 같은 등급 필터(minLevel)를 적용한다(기존 프로그램 실물: 분류표 합계 = 분자). */
	Map<String, Object> selectBreakdown(String hospCd, String incidGb, String fromDt, String toDt, String minLevel) throws Exception;

	Map<String, Object> selectReport(String hospCd, String indiCd, String prdGb, String prdKey) throws Exception;
	int saveReport(Map<String, Object> param) throws Exception;

	// 공통 첨부 (회의록·계획서·라운딩·자료실 공용)
	java.util.List<Map<String, Object>> selectQpsFileList(String hospCd, String refGb, String refKey) throws Exception;
	int insertQpsFile(egovframework.wnn_medcost.qps.model.QpsFileDTO dto) throws Exception;
	int deleteQpsFile(egovframework.wnn_medcost.qps.model.QpsFileDTO dto) throws Exception;
	Map<String, Object> selectQpsFileOne(Long fileSeq, String hospCd) throws Exception;
	java.util.List<Map<String, Object>> selectQpsFileCounts(String hospCd, String refGb) throws Exception;

	/* QPS 담당자(자료실 수정 권한) */
	java.util.List<Map<String, Object>> selectHospUsers(String hospCd) throws Exception;
	String selectUserMainGu(String hospCd, String userId) throws Exception;
	int selectQpsMgrCount(String hospCd) throws Exception;
	int selectQpsMgrYn(String hospCd, String userId) throws Exception;
	int saveQpsMgr(String hospCd, java.util.List<String> userIds, String regUser) throws Exception;
}
