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
	Map<String, Object> selectPlanWithItems(String hospCd, String formGb, String inYear) throws Exception;
	long savePlan(String hospCd, String formGb, String inYear, String submitDt,
	              List<Map<String, Object>> items, String userId) throws Exception;

	/** 기간(2026Q1 등)의 전 지표 요약 — 회의록 [지표 요약 넣기]용. {indinm, unit, rate, numer, denom} 목록. */
	List<Map<String, Object>> selectIndiSummary(String hospCd, String prdGb, String prdKey) throws Exception;

	// 서식 3호: 라운딩 점검표
	Map<String, Object> selectRoundWithItems(String hospCd, String formGb, String roundYm) throws Exception;
	long saveRound(String hospCd, String formGb, String roundYm, String checker,
	               List<Map<String, Object>> items, String userId) throws Exception;

	// 서식 1호: 위원회 회의록
	List<Map<String, Object>> selectMinutesList(String hospCd, String formGb, String inYear) throws Exception;
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

	/** 분류별 집계를 <b>분기 4벌</b>로 — QI 최종보고서 활동효과(v2). 기존 분류 집계를 분기마다 부를 뿐이다. */
	List<Map<String, Object>> selectBreakdownQuarters(String hospCd, String indiCd, String incidGb,
	                                                  String inYear, String numerSrc, String minLevel) throws Exception;

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

	/* 감염종합보고 (3종 통합 — P 계획수립 / D 수행 / E 손위생 교육결과) */
	List<Map<String, Object>> selectInfRptList(String hospCd, String rptGb, String inYear) throws Exception;
	Map<String, Object> selectInfRptWithMem(String hospCd, long rptSeq) throws Exception;
	long saveInfRpt(Map<String, Object> param, List<Map<String, Object>> members) throws Exception;
	int deleteInfRpt(Map<String, Object> param) throws Exception;

	/* QI 활동 계획서 */
	List<Map<String, Object>> selectQiPlanList(String hospCd, String inYear) throws Exception;
	Map<String, Object> selectQiPlanWithItems(String hospCd, long qipSeq) throws Exception;
	long saveQiPlan(Map<String, Object> param, List<Map<String, Object>> items) throws Exception;
	int deleteQiPlan(Map<String, Object> param) throws Exception;

	/* FMEA 계획서·보고서 */
	Map<String, Object> selectFmeaBase(String hospCd, String inYear, String docGb) throws Exception;
	Map<String, Object> selectFmeaOne(String hospCd, long fmeSeq) throws Exception;
	long saveFmea(Map<String, Object> param, List<Map<String, Object>> items,
	              List<Map<String, Object>> sheet) throws Exception;
	int deleteFmea(Map<String, Object> param) throws Exception;

	/* RCA 근본원인 분석 보고서 */
	List<Map<String, Object>> selectRcaList(String hospCd, String inYear) throws Exception;
	Map<String, Object> selectRca(String hospCd, long rcaSeq) throws Exception;
	long saveRca(Map<String, Object> param) throws Exception;
	int deleteRca(Map<String, Object> param) throws Exception;

	/* 사고 유형별 보고서 */
	Map<String, Object> selectSafeRptBase(String hospCd, String inYear, String rptGb) throws Exception;
	Map<String, Object> selectSafeRptOne(String hospCd, long srpSeq) throws Exception;
	/** @param rows 반복행 표(SUB_COLS) 값. 쓰지 않는 유형이 대부분이라 null 이어도 된다. */
	long saveSafeRpt(Map<String, Object> param, List<Map<String, Object>> chks,
	                 List<Map<String, Object>> rows) throws Exception;
	int deleteSafeRpt(Map<String, Object> param) throws Exception;
	/* 사진첨부 — 칸(1~4) 고정 자리. 파일 실체는 sftp 파일서버, 여기는 경로 메타만. */
	int saveSafeRptPhoto(Map<String, Object> param) throws Exception;
	int deleteSafeRptPhoto(long srpSeq, int fileSeq) throws Exception;
	/* 점검표 사진칸(2026-08-15) — 서식 PHOTO_NMS 가 칸 이름·수를 정한다 */
	int saveChkPhoto(Map<String, Object> param) throws Exception;
	int deleteChkPhoto(long chkSeq, int fileSeq) throws Exception;

	/* QI 중간·최종보고서 */
	List<Map<String, Object>> selectQiRptList(String hospCd, String inYear, String rptGb) throws Exception;
	Map<String, Object> selectQiRptWithItems(String hospCd, long qirSeq) throws Exception;
	long saveQiRpt(Map<String, Object> param, List<Map<String, Object>> items) throws Exception;
	int deleteQiRpt(Map<String, Object> param) throws Exception;

	/* QI 주제선정 기준표 + 우선순위 집계표 */
	List<Map<String, Object>> selectQiTopicList(String hospCd, String inYear) throws Exception;
	Map<String, Object> selectQiTopicWithItems(String hospCd, long qitSeq) throws Exception;
	long saveQiTopic(Map<String, Object> param, List<Map<String, Object>> items) throws Exception;
	int deleteQiTopic(Map<String, Object> param) throws Exception;
	Map<String, Object> selectQiTopicRollup(String hospCd, String inYear) throws Exception;

	/* QI 활동 자원지원 내역 */
	Map<String, Object> selectQiFundWithItems(String hospCd, String inYear) throws Exception;
	long saveQiFund(Map<String, Object> param, List<Map<String, Object>> items) throws Exception;

	/* 불만고충 — 처리대장 · 건별 처리결과 · 지표분석보고서 */
	List<Map<String, Object>> selectCmplList(String hospCd, String inYear) throws Exception;
	long saveCmplRows(String hospCd, String inYear, List<Map<String, Object>> rows, String regUser) throws Exception;
	int deleteCmpl(Map<String, Object> param) throws Exception;
	Map<String, Object> selectCmplAct(String hospCd, long cmplSeq) throws Exception;
	int saveCmplAct(Map<String, Object> param) throws Exception;
	Map<String, Object> selectCmplRpt(String hospCd, String inYear, String halfGb) throws Exception;
	int saveCmplRpt(Map<String, Object> param) throws Exception;
	Map<String, Object> selectCmplStat(String hospCd, String inYear, String halfGb) throws Exception;

	/* 만족도 개선활동 결과보고서 (만족도 사이클 #6) */
	List<Map<String, Object>> selectSrvImprList(String hospCd, String inYear) throws Exception;
	Map<String, Object> selectSrvImprWithItems(String hospCd, long imprSeq) throws Exception;
	long saveSrvImpr(Map<String, Object> param, List<Map<String, Object>> items) throws Exception;
	int deleteSrvImpr(Map<String, Object> param) throws Exception;

	/* 감염관리 우선순위 사정 도구 */
	List<Map<String, Object>> selectInfRiskList(String hospCd, String inYear) throws Exception;
	/** 평가 1건 + 항목. 항목이 없으면(새 평가) 기본 31행을 깔아 돌려준다. */
	Map<String, Object> selectInfRiskWithItems(String hospCd, long riskSeq) throws Exception;
	/** 새 평가용 기본 항목표(31종). */
	List<Map<String, Object>> selectInfRiskDef() throws Exception;
	long saveInfRisk(Map<String, Object> param, List<Map<String, Object>> items) throws Exception;
	int deleteInfRisk(Map<String, Object> param) throws Exception;

	/* 감염병환자 월별 리스트 */
	Map<String, Object> selectInfPatWithItems(String hospCd, String ipatYm) throws Exception;
	long saveInfPat(Map<String, Object> param, List<Map<String, Object>> items) throws Exception;

	/* 감염관리 전담자 (임명장·자격경력·직무기술서 한 벌) */
	List<Map<String, Object>> selectInfStaffList(String hospCd) throws Exception;
	Map<String, Object> selectInfStaffAll(String hospCd, long stfSeq) throws Exception;
	long saveInfStaff(Map<String, Object> param,
	                  List<Map<String, Object>> edus,
	                  List<Map<String, Object>> duties) throws Exception;
	int deleteInfStaff(Map<String, Object> param) throws Exception;

	// ── 환자만족도 조사 : 설문 ──────────────────────────────────────
	/** 설문 화면 초기 로드 — 문항표 + 회차목록 + 코드 */
	Map<String, Object> selectSurveyBase(String hospCd, String inYear) throws Exception;
	/** 회차 1건 + 응답 목록 */
	Map<String, Object> selectSurveyOne(Map<String, Object> param) throws Exception;
	/** 응답 1건의 문항점수 */
	List<Map<String, Object>> selectSurveyAnsItem(long ansId) throws Exception;
	/** 회차 저장(신규/수정) — surveyId 반환 */
	long saveSurvey(Map<String, Object> param) throws Exception;
	/** 응답 1건 저장(문항점수 포함) — ansId 반환 */
	long saveSurveyAns(Map<String, Object> param, List<Map<String, Object>> items) throws Exception;
	/** 응답 삭제(문항점수 함께) */
	int deleteSurveyAns(Map<String, Object> param) throws Exception;
	/** 집계 일체 — 문항별/영역별/전체/분포/기타의견 */
	Map<String, Object> selectSurveyStat(Map<String, Object> param) throws Exception;

	/* ═══ 점검표 엔진 ═══ */
	/** 서식 목록(+항목수·작성건수). onlyUse='Y' 면 그 병원이 켠 것만(작성 화면용) */
	List<Map<String, Object>> selectChkFormList(String hospCd, String cateCd, String deptCd, String onlyUse) throws Exception;
	/** 병원별 사용 서식 저장 — 통째 교체 */
	void saveChkUse(String hospCd, List<Map<String, Object>> uses, String regUser) throws Exception;
	/** 서식 화면에서 부서·분류 코드 추가 → 갱신된 코드목록을 돌려준다. */
	List<Map<String, Object>> addChkCode(String codeCd, String subCode, String subCodeNm, String regUser) throws Exception;
	/** 서식코드가 이미 있는가 — 새 서식 저장 전 검사. */
	boolean existsChkForm(String formId) throws Exception;
	/** 자동 서식코드 제안 — 접두어 + 3자리 순번. */
	String nextChkFormId(String prefix) throws Exception;
	/** 서식 복제 — 원본 서식+항목을 새 코드로 이 병원 것으로 베낀다 */
	void copyChkForm(String hospCd, String srcFormId, String newFormId, String newFormNm, String regUser) throws Exception;
	/** 서식 1건 + 항목 */
	Map<String, Object> selectChkFormOne(String hospCd, String formId) throws Exception;
	/** 서식 저장 — 병원 전용 행으로만 쓴다(공통 '*' 는 안 건드린다) */
	void saveChkForm(Map<String, Object> form, List<Map<String, Object>> items) throws Exception;
	void deleteChkForm(Map<String, Object> param) throws Exception;
	/** 작성 화면 기초 — 서식 + 항목 + 그 해 작성목록 */
	Map<String, Object> selectChkBase(String hospCd, String formId, String inYear) throws Exception;
	/** 작성 문서 1건 — 머리 + 셀값 + 기기행 */
	Map<String, Object> selectChkDocOne(String hospCd, long chkSeq) throws Exception;
	/**
	 * 작성 문서 저장 — chkSeq 반환.
	 * @param rows 문서가 정하는 <b>행</b> 이름(EQUIP_DAY 의 기기명)
	 * @param cols 문서가 정하는 <b>열</b> 이름(MSDS 물질명 · 소방 층·병동) — 2026-08-12
	 */
	long saveChkDoc(Map<String, Object> doc, List<Map<String, Object>> vals,
	                List<Map<String, Object>> rows, List<Map<String, Object>> cols) throws Exception;
	void deleteChkDoc(Map<String, Object> param) throws Exception;
	/**
	 * 전월 복사용 <b>틀</b>만 돌려준다 — ★***점검 결과는 담지 않는다.***
	 * 저장도 하지 않는다(화면에 깔아 주기만 한다).
	 */
	Map<String, Object> selectChkPrevSeed(String hospCd, String formId, String prdKey, String wardNm)
			throws Exception;
	/** 월 생성 — 일 단위 서식의 한 달치 <b>빈</b> 문서를 만든다. 이미 있는 날은 건너뛴다. */
	Map<String, Object> makeChkMonth(Map<String, Object> param) throws Exception;
	/** 데이터 추출 — 평면 목록 + 이행 요약. ★점검표를 전산화한 뜻이 여기 있다. */
	Map<String, Object> selectChkExtract(Map<String, Object> param) throws Exception;
}
