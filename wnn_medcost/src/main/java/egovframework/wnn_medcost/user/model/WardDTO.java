package egovframework.wnn_medcost.user.model;

public class WardDTO {
	private static final long serialVersionUID = 1L;

	public static long getSerialversionuid() {
		return serialVersionUID;
	}
    // Key Fields
    private String keyhospCd;   // 병원코드 (key)
    private String keystartYm;  // 해당월 (key)
    private String hospCd;      // 요양기관번호
    private String hospNm;      // 요양기관명칭
    private String startYm;     // 적용년월
    private String jobSeq;      // 작업 순번
    private String wardCnt;     // 입원병상수
    private String icuCnt;      // 중환자실 병상수
    private String erCnt;       // 응급실 병상수
    private String isolCnt;     // 격리실 병상수
    private String docCnt;      // 전문의 수
    private String useYn;      // 전문의 수
    private String actionYn;    // 활성화 여부
    private String hospUuid;    // 병원 UUID
    private String regDttm;     // 등록일시
    private String regUser;     // 등록자
    private String regIp;       // 등록 IP
    private String updDttm;     // 최종변경일시
    private String updUser;     // 최종변경자
    private String updIp;       // 최종변경 IP    

    
    public String getHospNm() {
		return hospNm;
	}
	public void setHospNm(String hospNm) {
		this.hospNm = hospNm;
	}
	public String getUseYn() {
		return useYn;
	}
	public void setUseYn(String useYn) {
		this.useYn = useYn;
	}
	public String getFindData() {
		return findData;
	}
	public void setFindData(String findData) {
		this.findData = findData;
	}
	private transient String findData; // MyBatis에서 매핑되지 않도록 설정
    
	public String getKeyhospCd() {
		return keyhospCd;
	}
	public void setKeyhospCd(String keyhospCd) {
		this.keyhospCd = keyhospCd;
	}
	public String getKeystartYm() {
		return keystartYm;
	}
	public void setKeystartYm(String keystartYm) {
		this.keystartYm = keystartYm;
	}
	public String getHospCd() {
		return hospCd;
	}
	public void setHospCd(String hospCd) {
		this.hospCd = hospCd;
	}
	public String getStartYm() {
		return startYm;
	}
	public void setStartYm(String startYm) {
		this.startYm = startYm;
	}
	public String getJobSeq() {
		return jobSeq;
	}
	public void setJobSeq(String jobSeq) {
		this.jobSeq = jobSeq;
	}
	public String getWardCnt() {
		return wardCnt;
	}
	public void setWardCnt(String wardCnt) {
		this.wardCnt = wardCnt;
	}
	public String getIcuCnt() {
		return icuCnt;
	}
	public void setIcuCnt(String icuCnt) {
		this.icuCnt = icuCnt;
	}
	public String getErCnt() {
		return erCnt;
	}
	public void setErCnt(String erCnt) {
		this.erCnt = erCnt;
	}
	public String getIsolCnt() {
		return isolCnt;
	}
	public void setIsolCnt(String isolCnt) {
		this.isolCnt = isolCnt;
	}
	public String getDocCnt() {
		return docCnt;
	}
	public void setDocCnt(String docCnt) {
		this.docCnt = docCnt;
	}
	public String getActionYn() {
		return actionYn;
	}
	public void setActionYn(String actionYn) {
		this.actionYn = actionYn;
	}
	public String getHospUuid() {
		return hospUuid;
	}
	public void setHospUuid(String hospUuid) {
		this.hospUuid = hospUuid;
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
