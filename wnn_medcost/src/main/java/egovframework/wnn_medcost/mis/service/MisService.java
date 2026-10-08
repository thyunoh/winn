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

	/** 업무 알림 — 지난달 자료(청구·입퇴원·평가표·자료생성)·이번 분기 차등제·평가표 자가점검·고정비·병상 수를 점검해 알림 목록으로. */
	List<Map<String, Object>> selectAlerts(String hospCd, String wnnYn) throws Exception;
	/** 인력 시뮬레이션 재료 — 최신 차등제 신고값 + 구조영역(01~03) 표준화 구간. */
	Map<String, Object> selectSim(String hospCd) throws Exception;

	/* ── ④ 신규환자 고객관리 ── */
	/** 관리판 — 열 때마다 입퇴원현황과 대조(자동 매칭) 후 상담 목록·유입 경로 집계를 준다. */
	Map<String, Object> selectLeadBoard(String hospCd) throws Exception;
	long saveLead(Map<String, Object> p) throws Exception;
	void moveLead(String hospCd, long leadSeq, String stage, String closeRsn, String memo, String userId) throws Exception;
	void addLeadLog(String hospCd, long leadSeq, String memo, String userId) throws Exception;
	List<Map<String, Object>> selectLeadLogs(String hospCd, long leadSeq) throws Exception;
	void deleteLead(String hospCd, long leadSeq, String userId) throws Exception;
	List<Map<String, Object>> selectFollowList(String hospCd, int days) throws Exception;
	void saveFollow(Map<String, Object> p) throws Exception;
}
