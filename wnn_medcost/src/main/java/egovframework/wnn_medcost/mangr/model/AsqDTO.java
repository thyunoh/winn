package egovframework.wnn_medcost.mangr.model;

public class AsqDTO {
	private static final long serialVersionUID = 1L;

	public static long getSerialversionuid() {
		return serialVersionUID;
	}
	private int keyasqSeq;  // 수가코드 (key)
	private String keyfileGb;  // 수가코드 (key)
	private transient String findData;	
	private String asqSeq;          // SEQ
    private String fileGb;           // 파일 구분
    private String jobSeq;          // JOB SEQ
    private String hospUuid;         // 병원 UUID
    private String hospCd;           // 요양기관
    private String qstnTitle;        // 질문 제목
    private String qstnConts;        // 질문 내용
    private String asqShare;         // 전체 공유
    private String ansrConts;        // 답변 내용
    private String updateSw;         // 등록 구분
    private String qstnWan;          // 질문 완료 여부
    private String ansrWan;          // 답변 완료 여부
    private String actionYn;         // 활성 여부
    private String readCnt;         // 조회 수
    private String subCodeNm;      // 공지 세부내용
    private String iud = ""; 

    private String regDttm;   // 등록 일시
    private String regUser;          // 등록자
    private String regIp;            // 등록 IP
    private String updDttm;   // 최종 변경 일시
    private String updUser;          // 최종 변경자
    private String updIp;            // 최종 변경 IP
    private String asqGb;
    private String qstnStat;
    private String ansrStat; 
	private String hospNm ;
    private String userNm ;
	private String hospCd2; //사이드바 작업
	private String fileGb2 ;
	public String getFileGb2() {
		return fileGb2;
	}
	public void setFileGb2(String fileGb2) {
		this.fileGb2 = fileGb2;
	}
	public String getHospCd2() {
		return hospCd2;
	}
	public void setHospCd2(String hospCd2) {
		this.hospCd2 = hospCd2;
	}
 
    
    public String getIud() {
		return iud;
	}
	public void setIud(String iud) {
		this.iud = iud;
	}
	public String getUidGubun() {
		return uidGubun;
	}
	public void setUidGubun(String uidGubun) {
		this.uidGubun = uidGubun;
	}
	private String uidGubun ;
    
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
	public String getAsqGb() {
		return asqGb;
	}
	public void setAsqGb(String asqGb) {
		this.asqGb = asqGb;
	}
	public int getKeyasqSeq() {
		return keyasqSeq;
	}
	public void setKeyasqSeq(int keyasqSeq) {
		this.keyasqSeq = keyasqSeq;
	}
	public String getKeyfileGb() {
		return keyfileGb;
	}
	public void setKeyfileGb(String keyfileGb) {
		this.keyfileGb = keyfileGb;
	}
	public String getFindData() {
		return findData;
	}
	public void setFindData(String findData) {
		this.findData = findData;
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
	public String getJobSeq() {
		return jobSeq;
	}
	public void setJobSeq(String jobSeq) {
		this.jobSeq = jobSeq;
	}
	public String getHospUuid() {
		return hospUuid;
	}
	public void setHospUuid(String hospUuid) {
		this.hospUuid = hospUuid;
	}
	public String getHospCd() {
		return hospCd;
	}
	public void setHospCd(String hospCd) {
		this.hospCd = hospCd;
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
	public String getActionYn() {
		return actionYn;
	}
	public void setActionYn(String actionYn) {
		this.actionYn = actionYn;
	}
	public String getReadCnt() {
		return readCnt;
	}
	public void setReadCnt(String readCnt) {
		this.readCnt = readCnt;
	}
	public String getSubCodeNm() {
		return subCodeNm;
	}
	public void setSubCodeNm(String subCodeNm) {
		this.subCodeNm = subCodeNm;
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
