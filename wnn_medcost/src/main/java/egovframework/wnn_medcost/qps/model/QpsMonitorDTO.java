package egovframework.wnn_medcost.qps.model;

/**
 * QPS 관찰형 지표 기록 (TBL_QPS_MONITOR).
 *
 * 손위생 수행률 같은 '관찰' 지표의 원천. 낙상(사고 건별)·욕창(평가표)과 다른 세 번째 유형이다.
 *   · 분자 = 수행건수(PASS_CNT), 분모 = 관찰건수(OBS_CNT) — 둘 다 이 표에서 나온다.
 *   · 그래서 이 지표는 재원일수(TBL_QPS_CENSUS)를 쓰지 않는다.
 */
public class QpsMonitorDTO {

	private Long   monSeq;
	private String hospCd;
	private String indiCd;      // HANDWASH ...
	private String obsDt;       // YYYYMMDD (관찰일)
	private String wardCd;      // 병동
	private String jobGb;       // 직군(의사/간호사/기타)
	private String momentCd;    // 손위생 5 moments 등
	private Integer obsCnt;     // 관찰건수(분모)
	private Integer passCnt;    // 수행건수(분자)
	private String observer;    // 관찰자
	private String note;
	private String useYn;
	private String regUser;
	private String updUser;

	// 조회 조건
	private String fromDt;
	private String toDt;

	public Long getMonSeq() { return monSeq; }
	public void setMonSeq(Long monSeq) { this.monSeq = monSeq; }
	public String getHospCd() { return hospCd; }
	public void setHospCd(String hospCd) { this.hospCd = hospCd; }
	public String getIndiCd() { return indiCd; }
	public void setIndiCd(String indiCd) { this.indiCd = indiCd; }
	public String getObsDt() { return obsDt; }
	public void setObsDt(String obsDt) { this.obsDt = obsDt; }
	public String getWardCd() { return wardCd; }
	public void setWardCd(String wardCd) { this.wardCd = wardCd; }
	public String getJobGb() { return jobGb; }
	public void setJobGb(String jobGb) { this.jobGb = jobGb; }
	public String getMomentCd() { return momentCd; }
	public void setMomentCd(String momentCd) { this.momentCd = momentCd; }
	public Integer getObsCnt() { return obsCnt; }
	public void setObsCnt(Integer obsCnt) { this.obsCnt = obsCnt; }
	public Integer getPassCnt() { return passCnt; }
	public void setPassCnt(Integer passCnt) { this.passCnt = passCnt; }
	public String getObserver() { return observer; }
	public void setObserver(String observer) { this.observer = observer; }
	public String getNote() { return note; }
	public void setNote(String note) { this.note = note; }
	public String getUseYn() { return useYn; }
	public void setUseYn(String useYn) { this.useYn = useYn; }
	public String getRegUser() { return regUser; }
	public void setRegUser(String regUser) { this.regUser = regUser; }
	public String getUpdUser() { return updUser; }
	public void setUpdUser(String updUser) { this.updUser = updUser; }
	public String getFromDt() { return fromDt; }
	public void setFromDt(String fromDt) { this.fromDt = fromDt; }
	public String getToDt() { return toDt; }
	public void setToDt(String toDt) { this.toDt = toDt; }
}
