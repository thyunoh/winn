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

	/* ── ③-2 문자·메일 알림 (2026-10-08) ── */
	/** 받는 사람 목록 + 계정 후보 + 최근 이력 + 메일·문자 설정 상태 */
	Map<String, Object> selectNotiBoard(String hospCd) throws Exception;
	long saveNotiUser(Map<String, Object> p) throws Exception;
	void deleteNotiUser(String hospCd, long notiSeq) throws Exception;
	/** 지금 보낼 내용 미리보기 — 제목·HTML·문자 글·건수(보내지 않는다) */
	Map<String, Object> previewNoti(String hospCd, String wnnYn) throws Exception;
	/** 지금 보내기 — seqs(화면에서 체크한 받는 사람) 에게, null 이면 사용 중인 사람 전부. testTo 가 있으면 그 주소로 메일 1통만. 결과는 사람·채널마다 한 줄 + 이력 저장 */
	List<Map<String, Object>> sendNoti(String hospCd, String wnnYn, String sentBy, java.util.Set<Long> seqs, String testTo) throws Exception;
	/** 자동 발송(스케줄러) — 하루 1회 선점 후 자동 수신자가 있는 병원 전부 */
	Map<String, Object> runAutoNoti() throws Exception;
	/** 이 병원에 MIS 계약(계약 구분 'M')이 유효한가 — 병원 계정의 메뉴 노출·화면 진입은 이것으로 가른다(위너넷은 무관) */
	boolean hasMisContract(String hospCd) throws Exception;
	/** 카톡 공유·링크 복사 이력(채널 KAKAO/LINK) */
	void logNotiShare(String hospCd, String channel, String subject, String body, String result, String errMsg, String userId) throws Exception;
}
