package egovframework.wnn_consult.mangr.model;

public class AsqDTO {
	private static final long serialVersionUID = 1L;

	public static long getSerialversionuid() {
		return serialVersionUID;
	}
	
	// 기본 필드
    private String iud = "";        // 
    private String hospCd;          // 요양기관
    private String asqSeq;          // SEQ
    private String fileGb;          // 파일 구분
    private String qstnTitle;       // 질문 제목
    private String qstnConts;       // 질문 내용
    private String asqShare;        // 전체 공유
    private String ansrConts;       // 답변 내용
    private String updateSw;        // 등록 구분

    // 등록 및 수정 정보
    private String regDttm;         // 등록 일시
    private String regUser;         // 등록자
    private String regIp;           // 등록 IP
    private String updDttm;         // 최종 변경 일시
    private String updUser;         // 최종 변경자
    private String updIp;           // 최종 변경 IP

    // 답변 관련 정보
    private String ansrDttm;        // 답변 일자
    private String ansrUser;        // 답변자
    private String ansrIp;          // 답변 IP
    private String ansrUpdDttm;     // 답변 변경 일자
    private String ansrUpdUser;     // 답변 변경자
    private String ansrUpdIp;       // 답변 변경 IP

    // 기타 필드
    private String hospUuid;
    private String userNm;
    private String hospNm;
    private String qstnWan;
    private String ansrWan;
    private String qstnStat;
    private String ansrStat;
    private String iudasq ;
    private String fileGbasq ;
    private String hospCdasq;
    private String hospUuidasq;
    private String regUserasq;
    private String asqGb;
    
    
    public String getAsqGb() {
		return asqGb;
	}
	public void setAsqGb(String asqGb) {
		this.asqGb = asqGb;
	}
	public String getIudasq() {
		return iudasq;
	}
	public void setIudasq(String iudasq) {
		this.iudasq = iudasq;
	}
	public String getFileGbasq() {
		return fileGbasq;
	}
	public void setFileGbasq(String fileGbasq) {
		this.fileGbasq = fileGbasq;
	}
	public String getHospCdasq() {
		return hospCdasq;
	}
	public void setHospCdasq(String hospCdasq) {
		this.hospCdasq = hospCdasq;
	}
	public String getHospUuidasq() {
		return hospUuidasq;
	}
	public void setHospUuidasq(String hospUuidasq) {
		this.hospUuidasq = hospUuidasq;
	}
	public String getRegUserasq() {
		return regUserasq;
	}
	public void setRegUserasq(String regUserasq) {
		this.regUserasq = regUserasq;
	}
	public String getUpdUserasq() {
		return updUserasq;
	}
	public void setUpdUserasq(String updUserasq) {
		this.updUserasq = updUserasq;
	}

	private String updUserasq;
    
	public String getIud() {
		return iud;
	}
	public void setIud(String iud) {
		this.iud = iud;
	}
	public String getHospCd() {
		return hospCd;
	}
	public void setHospCd(String hospCd) {
		this.hospCd = hospCd;
	}
	public String getAsqSeq() {
		return asqSeq;
	}
	public void setAsqSeq(String asqSeq) {
		this.asqSeq = asqSeq;
	}
	public String getFileGb() {
		return fileGb;
	}
	public void setFileGb(String fileGb) {
		this.fileGb = fileGb;
	}
	public String getQstnTitle() {
		return qstnTitle;
	}
	public void setQstnTitle(String qstnTitle) {
		this.qstnTitle = qstnTitle;
	}
	public String getQstnConts() {
		return qstnConts;
	}
	public void setQstnConts(String qstnConts) {
		this.qstnConts = qstnConts;
	}
	public String getAsqShare() {
		return asqShare;
	}
	public void setAsqShare(String asqShare) {
		this.asqShare = asqShare;
	}
	public String getAnsrConts() {
		return ansrConts;
	}
	public void setAnsrConts(String ansrConts) {
		this.ansrConts = ansrConts;
	}
	public String getUpdateSw() {
		return updateSw;
	}
	public void setUpdateSw(String updateSw) {
		this.updateSw = updateSw;
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
	public String getAnsrDttm() {
		return ansrDttm;
	}
	public void setAnsrDttm(String ansrDttm) {
		this.ansrDttm = ansrDttm;
	}
	public String getAnsrUser() {
		return ansrUser;
	}
	public void setAnsrUser(String ansrUser) {
		this.ansrUser = ansrUser;
	}
	public String getAnsrIp() {
		return ansrIp;
	}
	public void setAnsrIp(String ansrIp) {
		this.ansrIp = ansrIp;
	}
	public String getAnsrUpdDttm() {
		return ansrUpdDttm;
	}
	public void setAnsrUpdDttm(String ansrUpdDttm) {
		this.ansrUpdDttm = ansrUpdDttm;
	}
	public String getAnsrUpdUser() {
		return ansrUpdUser;
	}
	public void setAnsrUpdUser(String ansrUpdUser) {
		this.ansrUpdUser = ansrUpdUser;
	}
	public String getAnsrUpdIp() {
		return ansrUpdIp;
	}
	public void setAnsrUpdIp(String ansrUpdIp) {
		this.ansrUpdIp = ansrUpdIp;
	}
	public String getHospUuid() {
		return hospUuid;
	}
	public void setHospUuid(String hospUuid) {
		this.hospUuid = hospUuid;
	}
	public String getUserNm() {
		return userNm;
	}
	public void setUserNm(String userNm) {
		this.userNm = userNm;
	}
	public String getHospNm() {
		return hospNm;
	}
	public void setHospNm(String hospNm) {
		this.hospNm = hospNm;
	}
	public String getQstnWan() {
		return qstnWan;
	}
	public void setQstnWan(String qstnWan) {
		this.qstnWan = qstnWan;
	}
	public String getAnsrWan() {
		return ansrWan;
	}
	public void setAnsrWan(String ansrWan) {
		this.ansrWan = ansrWan;
	}
	public String getQstnStat() {
		return qstnStat;
	}
	public void setQstnStat(String qstnStat) {
		this.qstnStat = qstnStat;
	}
	public String getAnsrStat() {
		return ansrStat;
	}
	public void setAnsrStat(String ansrStat) {
		this.ansrStat = ansrStat;
	}
	


}
