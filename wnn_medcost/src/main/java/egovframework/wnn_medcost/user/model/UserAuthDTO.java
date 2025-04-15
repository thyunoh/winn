package egovframework.wnn_medcost.user.model;


public class UserAuthDTO {

	private static final long serialVersionUID = 1L;

	public static long getSerialversionuid() {
		return serialVersionUID;
	}
	private String keyhospCd;  // 수가코드 (key)
    private String keyuserId;
    private String hospCd;        // 요양기관기호
    private String userId;        // 사용자아이디
    private String userNm;        // 사용자 명
    private String hospNm;        // 병원명 
    private String pgmUrl;        // 프로그램경로
    private String insAuth;       // 입력여부
    private String updAuth;       // 수정여부
    private String delAuth;       // 삭제여부
    private String inqAuth;       // 조회여부
    private String regDttm;  // 입력일자
    private String regUser;       // 입력사용자
    private String regIp;         // 입력아이피
    private String updDttm;  // 수정일자
    private String updUser;       // 수정사용자
    private String updIp;         // 수정아이피  
    private String findData;

	public String getKeyhospCd() {
		return keyhospCd;
	}
	public void setKeyhospCd(String keyhospCd) {
		this.keyhospCd = keyhospCd;
	}
	public String getKeyuserId() {
		return keyuserId;
	}
	public void setKeyuserId(String keyuserId) {
		this.keyuserId = keyuserId;
	}
	public String getHospCd() {
		return hospCd;
	}
	public void setHospCd(String hospCd) {
		this.hospCd = hospCd;
	}

	public String getHospNm() {
		return hospNm;
	}
	public void setHospNm(String hospNm) {
		this.hospNm = hospNm;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public String getUserNm() {
		return userNm;
	}
	public void setUserNm(String userNm) {
		this.userNm = userNm;
	}
	public String getPgmUrl() {
		return pgmUrl;
	}
	public void setPgmUrl(String pgmUrl) {
		this.pgmUrl = pgmUrl;
	}
	public String getInsAuth() {
		return insAuth;
	}
	public void setInsAuth(String insAuth) {
		this.insAuth = insAuth;
	}
	public String getUpdAuth() {
		return updAuth;
	}
	public void setUpdAuth(String updAuth) {
		this.updAuth = updAuth;
	}
	public String getDelAuth() {
		return delAuth;
	}
	public void setDelAuth(String delAuth) {
		this.delAuth = delAuth;
	}
	public String getInqAuth() {
		return inqAuth;
	}
	public void setInqAuth(String inqAuth) {
		this.inqAuth = inqAuth;
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
	public String getFindData() {
		return findData;
	}
	public void setFindData(String findData) {
		this.findData = findData;
	}
    
}
