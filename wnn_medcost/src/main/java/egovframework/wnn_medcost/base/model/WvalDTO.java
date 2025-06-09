package egovframework.wnn_medcost.base.model;

public class WvalDTO{
	private static final long serialVersionUID = 1L;

	public static long getSerialversionuid() {
		return serialVersionUID;
	}
	private String keycateCode;  // 수가코드 (key)
	private String keyorderSeq ;
	private String keystartDt ;
	private transient String findData;
    private String cateCode; // 분류코드
    private String orderSeq; // 분류순서
    private String startDt; // 시작일자
    private String endDt; // 시작일자
    private String calGubun; // 점수구분(1.접수/2.율)
    private String wevalueNm; // 명칭
    private String startIndi; // 시작지표
    private String endIndi; // 지표종료
    private String stdScore; // 표준화점수
    private String weValue; // 가중치
    private String regDttm; // 입력일시
    private String regUser; // 입력자
    private String regIp; // 입력IP
    private String updDttm; // 수정일시
    private String updUser; // 수정자
    private String updIp; // 수정IP 
    private String startDtTwo ;
    private String newStartDt ;

	public String getNewStartDt() {
		return newStartDt;
	}
	public void setNewStartDt(String newStartDt) {
		this.newStartDt = newStartDt;
	}
	public String getStartDtTwo() {
		return startDtTwo;
	}
	public void setStartDtTwo(String startDtTwo) {
		this.startDtTwo = startDtTwo;
	}
	public String getEndDt() {
		return endDt;
	}
	public void setEndDt(String endDt) {
		this.endDt = endDt;
	}
	public String getKeycateCode() {
		return keycateCode;
	}
	public void setKeycateCode(String keycateCode) {
		this.keycateCode = keycateCode;
	}
	public String getKeyorderSeq() {
		return keyorderSeq;
	}
	public void setKeyorderSeq(String keyorderSeq) {
		this.keyorderSeq = keyorderSeq;
	}
	public String getKeystartDt() {
		return keystartDt;
	}
	public void setKeystartDt(String keystartDt) {
		this.keystartDt = keystartDt;
	}
	public String getFindData() {
		return findData;
	}
	public void setFindData(String findData) {
		this.findData = findData;
	}
	public String getCateCode() {
		return cateCode;
	}
	public void setCateCode(String cateCode) {
		this.cateCode = cateCode;
	}
	public String getOrderSeq() {
		return orderSeq;
	}
	public void setOrderSeq(String orderSeq) {
		this.orderSeq = orderSeq;
	}
	public String getStartDt() {
		return startDt;
	}
	public void setStartDt(String startDt) {
		this.startDt = startDt;
	}
	public String getCalGubun() {
		return calGubun;
	}
	public void setCalGubun(String calGubun) {
		this.calGubun = calGubun;
	}
	public String getWevalueNm() {
		return wevalueNm;
	}
	public void setWevalueNm(String wevalueNm) {
		this.wevalueNm = wevalueNm;
	}
	public String getStartIndi() {
		return startIndi;
	}
	public void setStartIndi(String startIndi) {
		this.startIndi = startIndi;
	}
	public String getEndIndi() {
		return endIndi;
	}
	public void setEndIndi(String endIndi) {
		this.endIndi = endIndi;
	}
	public String getStdScore() {
		return stdScore;
	}
	public void setStdScore(String stdScore) {
		this.stdScore = stdScore;
	}
	public String getWeValue() {
		return weValue;
	}
	public void setWeValue(String weValue) {
		this.weValue = weValue;
	}
	public String getRegDttm() {
		return regDttm;
	}
	public void setRegDttm(String regDttm) {
		this.regDttm = regDttm;
	}
	public String getRegUser() {
		return regUser;
	}
	public void setRegUser(String regUser) {
		this.regUser = regUser;
	}
	public String getRegIp() {
		return regIp;
	}
	public void setRegIp(String regIp) {
		this.regIp = regIp;
	}
	public String getUpdDttm() {
		return updDttm;
	}
	public void setUpdDttm(String updDttm) {
		this.updDttm = updDttm;
	}
	public String getUpdUser() {
		return updUser;
	}
	public void setUpdUser(String updUser) {
		this.updUser = updUser;
	}
	public String getUpdIp() {
		return updIp;
	}
	public void setUpdIp(String updIp) {
		this.updIp = updIp;
	}

 
}
