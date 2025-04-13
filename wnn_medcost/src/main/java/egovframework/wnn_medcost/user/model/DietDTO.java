package egovframework.wnn_medcost.user.model;

public class DietDTO {
	private static final long serialVersionUID = 1L;

	public static long getSerialversionuid() {
		return serialVersionUID;
	}
    // Key Fields
    private String keyhospCd;    // 수가코드 (key)
    private String keydietGb;    // 식대구분 (key)
    private String keyStartDt;   // 적용시작일자 (key)
    
	private String hospCd; // 요양기관 UUID
    private String dietGb; // 식대구분(직영/영양사/조리사/치료사)
    private String startDt; // 적용일자
    private String endDt; // 종료일자
    private String bigo; // 비고
    private String regDttm; // 등록일시
    private String regUser; // 등록자
    private String regIp; // 등록 IP
    private String updDttm; // 최종변경일시
    private String updUser; // 최종변경자
    private String updIp; // 최종변경 IP
    private String hospNm ; // 병원명
    private String userNm ; // 사용자명 
    private String subCodeNm; // 서브명   
    private String useYn ; 
    private transient String findData; // MyBatis에서 매핑되지 않도록 설정

	public String getKeyhospCd() {
		return keyhospCd;
	}
	public void setKeyhospCd(String keyhospCd) {
		this.keyhospCd = keyhospCd;
	}
	public String getKeydietGb() {
		return keydietGb;
	}
	public void setKeydietGb(String keydietGb) {
		this.keydietGb = keydietGb;
	}
	public String getKeyStartDt() {
		return keyStartDt;
	}
	public void setKeyStartDt(String keyStartDt) {
		this.keyStartDt = keyStartDt;
	}
	public String getHospCd() {
		return hospCd;
	}
	public void setHospCd(String hospCd) {
		this.hospCd = hospCd;
	}
	public String getDietGb() {
		return dietGb;
	}
	public void setDietGb(String dietGb) {
		this.dietGb = dietGb;
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
	public String getBigo() {
		return bigo;
	}
	public void setBigo(String bigo) {
		this.bigo = bigo;
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
	public String getHospNm() {
		return hospNm;
	}
	public void setHospNm(String hospNm) {
		this.hospNm = hospNm;
	}
	public String getUserNm() {
		return userNm;
	}
	public void setUserNm(String userNm) {
		this.userNm = userNm;
	}
	public String getSubCodeNm() {
		return subCodeNm;
	}
	public void setSubCodeNm(String subCodeNm) {
		this.subCodeNm = subCodeNm;
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
    
}
