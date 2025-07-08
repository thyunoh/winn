package egovframework.wnn_medcost.mangr.model;

public class FaqDTO {
	private static final long serialVersionUID = 1L;

	public static long getSerialversionuid() {
		return serialVersionUID;
	}
	private String keyfaqSeq;  // 수가코드 (key)
	private transient String findData;	
	private String faqSeq;         // SEQ
    private String fileGb;          // 질문 구분
    private String qstnConts;       // 질문내용
    private String ansrConts;       // 답변 내용
    private String ansrConts1;       // 답변 내용
    private String startDt;         // 시작 날짜 (YYYYMMDD)
    private String endDt;           // 종료 날짜 (YYYYMMDD)
    private String useYn;           // 사용여부
    private String sortSeq;        // 정렬 순서
    private String regDttm;  // 등록 일시
    private String regUser;         // 등록자
    private String regIp;           // 등록 IP
    private String updDttm;  // 최종 변경 일시
    private String updUser;         // 최종 변경자
    private String updIp;           // 최종 변경 IP

	public String getAnsrConts1() {
		return ansrConts1;
	}
	public void setAnsrConts1(String ansrConts1) {
		this.ansrConts1 = ansrConts1;
	}
	public String getKeyfaqSeq() {
		return keyfaqSeq;
	}
	public void setKeyfaqSeq(String keyfaqSeq) {
		this.keyfaqSeq = keyfaqSeq;
	}
	public String getFindData() {
		return findData;
	}
	public void setFindData(String findData) {
		this.findData = findData;
	}
	public String getFaqSeq() {
		return faqSeq;
	}
	public void setFaqSeq(String faqSeq) {
		this.faqSeq = faqSeq;
	}
	public String getFileGb() {
		return fileGb;
	}
	public void setFileGb(String fileGb) {
		this.fileGb = fileGb;
	}
	public String getQstnConts() {
		return qstnConts;
	}
	public void setQstnConts(String qstnConts) {
		this.qstnConts = qstnConts;
	}
	public String getAnsrConts() {
		return ansrConts;
	}
	public void setAnsrConts(String ansrConts) {
		this.ansrConts = ansrConts;
	}
	public String getStartDt() {
		return startDt;
	}
	public void setStartDt(String startDt) {
		this.startDt = startDt;
	}
	public String getEndDt() {
		return endDt;
	}
	public void setEndDt(String endDt) {
		this.endDt = endDt;
	}
	public String getUseYn() {
		return useYn;
	}
	public void setUseYn(String useYn) {
		this.useYn = useYn;
	}
	public String getSortSeq() {
		return sortSeq;
	}
	public void setSortSeq(String sortSeq) {
		this.sortSeq = sortSeq;
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
