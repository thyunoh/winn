package egovframework.wnn_consult.mangr.model;
public class FaqDTO {
	// 기본 필드
    private String faqSeq;        // FAQ SEQ
    private String fileGb;        // 파일 구분
    private String qstnConts;     // 질문 내용
    private String ansrConts;     // 답변 내용
    private String startDt;       // 적용 시작일자
    private String endDt;         // 적용 종료일자
    private String useYn;         // 사용 여부
    private String hospCd; 
    // 등록 및 수정 정보1
    private String regUser;       // 등록자
    private String regDttm;       // 등록 일시
    private String regIp;         // 등록 IP
    private String updUser;       // 수정자
    private String updDttm;       // 수정 일시
    private String updIp;         // 수정 IP
    
	public String getHospCd() {
		return hospCd;
	}
	public void setHospCd(String hospCd) {
		this.hospCd = hospCd;
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
	public String getRegUser() {
		return regUser;
	}
	public void setRegUser(String regUser) {
		this.regUser = regUser;
	}
	public String getRegDttm() {
		return regDttm;
	}
	public void setRegDttm(String regDttm) {
		this.regDttm = regDttm;
	}
	public String getRegIp() {
		return regIp;
	}
	public void setRegIp(String regIp) {
		this.regIp = regIp;
	}
	public String getUpdUser() {
		return updUser;
	}
	public void setUpdUser(String updUser) {
		this.updUser = updUser;
	}
	public String getUpdDttm() {
		return updDttm;
	}
	public void setUpdDttm(String updDttm) {
		this.updDttm = updDttm;
	}
	public String getUpdIp() {
		return updIp;
	}
	public void setUpdIp(String updIp) {
		this.updIp = updIp;
	}

}
