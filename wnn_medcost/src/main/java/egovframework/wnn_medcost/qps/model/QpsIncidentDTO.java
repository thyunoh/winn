package egovframework.wnn_medcost.qps.model;

/**
 * QPS 사고 건별 보고 (TBL_QPS_INCIDENT).
 *
 * 기존 프로그램 「04 보고서」 8종(환자안전·욕창·직원안전·감염노출·유해물질·보안·학대폭력)의 입력을
 * INCID_GB 하나로 통합한 것. 낙상 파일럿에서는 INCID_GB='FALL' 만 쓴다.
 *
 * ★분자 산정 규칙: 낙상 지표의 분자는 '낙상 발생 보고 건수(Level 2 이상)' 이므로
 *   levelCd 가 분자 포함 여부를 가른다(기존 프로그램 실측 지표정의 — QPS_지표정의서_산식채록 문서).
 */
public class QpsIncidentDTO {

	private Long   incidSeq;
	private String hospCd;      // 요양기관기호 (기존 프로그램 COMPANY 대체)
	private String incidGb;     // FALL/BEDSORE/PTSAFE/STAFFSAFE/ABUSE/SECURITY/HAZMAT/INFEXP
	private String occurDt;     // YYYYMMDD
	private String occurTm;     // HHMM
	private String wardCd;      // 병동/부서
	private String rptDept;     // 보고부서
	private String ptNo;        // 환자등록번호(최소식별)
	private String ptSex;
	private Integer ptAge;
	private String levelCd;     // 위해정도 (LV1~) — 낙상 분자는 LV2 이상
	private String typeCd;      // 사고유형
	private String subtypeCd;   // 세부유형(낙상유형)
	private String placeCd;     // 발생장소
	private String damageCd;    // 손상유형
	private String causeTxt;
	private String actionTxt;
	private String rptUser;
	private String status;      // DRAFT/SUBMIT/CONFIRM
	private String useYn;
	private String regUser;
	private String updUser;

	// 조회 조건 전용
	private String fromDt;
	private String toDt;

	public Long getIncidSeq() { return incidSeq; }
	public void setIncidSeq(Long incidSeq) { this.incidSeq = incidSeq; }
	public String getHospCd() { return hospCd; }
	public void setHospCd(String hospCd) { this.hospCd = hospCd; }
	public String getIncidGb() { return incidGb; }
	public void setIncidGb(String incidGb) { this.incidGb = incidGb; }
	public String getOccurDt() { return occurDt; }
	public void setOccurDt(String occurDt) { this.occurDt = occurDt; }
	public String getOccurTm() { return occurTm; }
	public void setOccurTm(String occurTm) { this.occurTm = occurTm; }
	public String getWardCd() { return wardCd; }
	public void setWardCd(String wardCd) { this.wardCd = wardCd; }
	public String getRptDept() { return rptDept; }
	public void setRptDept(String rptDept) { this.rptDept = rptDept; }
	public String getPtNo() { return ptNo; }
	public void setPtNo(String ptNo) { this.ptNo = ptNo; }
	public String getPtSex() { return ptSex; }
	public void setPtSex(String ptSex) { this.ptSex = ptSex; }
	public Integer getPtAge() { return ptAge; }
	public void setPtAge(Integer ptAge) { this.ptAge = ptAge; }
	public String getLevelCd() { return levelCd; }
	public void setLevelCd(String levelCd) { this.levelCd = levelCd; }
	public String getTypeCd() { return typeCd; }
	public void setTypeCd(String typeCd) { this.typeCd = typeCd; }
	public String getSubtypeCd() { return subtypeCd; }
	public void setSubtypeCd(String subtypeCd) { this.subtypeCd = subtypeCd; }
	public String getPlaceCd() { return placeCd; }
	public void setPlaceCd(String placeCd) { this.placeCd = placeCd; }
	public String getDamageCd() { return damageCd; }
	public void setDamageCd(String damageCd) { this.damageCd = damageCd; }
	public String getCauseTxt() { return causeTxt; }
	public void setCauseTxt(String causeTxt) { this.causeTxt = causeTxt; }
	public String getActionTxt() { return actionTxt; }
	public void setActionTxt(String actionTxt) { this.actionTxt = actionTxt; }
	public String getRptUser() { return rptUser; }
	public void setRptUser(String rptUser) { this.rptUser = rptUser; }
	public String getStatus() { return status; }
	public void setStatus(String status) { this.status = status; }
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
