package egovframework.wnn_medcost.user.model;

public class LisenceDTO {
	private static final long serialVersionUID = 1L;

	public static long getSerialversionuid() {
		return serialVersionUID;
	}
    // Key Fields
    private String keyhospCd;    // 병원코드 (key)
    private String keylicNum;    // 면허번호 (key)
    private String keyipDt;      // 입사일자  (key)
   
    private String hospCd;    // 병원코드 (key)
    private String hospNm ;
    private String licNum;    // 면허번호 (key)
    private String ipDt;      // 입사일자  (key)
    private String teDt;      // 퇴사일자  
    private String userNm;    // 성명 
    private String updUserNnm ;  //등록자  
    private String licType;   //구분번호 의사(01)/치과의사(02)/한의사(03)/간호사(05)/간호조무사(06)/약사(07)/영양사(18)
    private String subCodeNm;
    private String useYn;
    private String licDetail; //세부내용 
    private String weekHours ; //의사,약사등 1주 근무시간
    private String deptCode; //진료과  
    private String regDttm; // 등록일시
	private String regUser; // 등록자
	private String regIp; // 등록 IP
	private String updDttm; // 최종변경일시
	private String updUser; // 최종변경자
	private String updIp; // 최종변경 IP
	private String checkValue ;
	private transient String findData; // MyBatis에서 매핑되지 않도록 설정
	
	public String getCheckValue() {
		return checkValue;
	}
	public void setCheckValue(String checkValue) {
		this.checkValue = checkValue;
	}
	
    public String getUseYn() {
		return useYn;
	}
	public void setUseYn(String useYn) {
		this.useYn = useYn;
	}

	public String getWeekHours() {
		return weekHours;
	}

	public void setWeekHours(String weekHours) {
		this.weekHours = weekHours;
	}

	public String getTeDt() {
		return teDt;
	}

	public void setTeDt(String teDt) {
		this.teDt = teDt;
	}

	public String getHospNm() {
		return hospNm;
	}

	public void setHospNm(String hospNm) {
		this.hospNm = hospNm;
	}

	public String getUpdUserNnm() {
		return updUserNnm;
	}

	public void setUpdUserNnm(String updUserNnm) {
		this.updUserNnm = updUserNnm;
	}

	public String getKeyhospCd() {
		return keyhospCd;
	}

	public void setKeyhospCd(String keyhospCd) {
		this.keyhospCd = keyhospCd;
	}

	public String getKeylicNum() {
		return keylicNum;
	}

	public void setKeylicNum(String keylicNum) {
		this.keylicNum = keylicNum;
	}

	public String getKeyipDt() {
		return keyipDt;
	}

	public void setKeyipDt(String keyipDt) {
		this.keyipDt = keyipDt;
	}

	public String getHospCd() {
		return hospCd;
	}

	public void setHospCd(String hospCd) {
		this.hospCd = hospCd;
	}

	public String getLicNum() {
		return licNum;
	}

	public void setLicNum(String licNum) {
		this.licNum = licNum;
	}

	public String getIpDt() {
		return ipDt;
	}

	public void setIpDt(String ipDt) {
		this.ipDt = ipDt;
	}

	public String getUserNm() {
		return userNm;
	}

	public void setUserNm(String userNm) {
		this.userNm = userNm;
	}

	public String getLicType() {
		return licType;
	}

	public void setLicType(String licType) {
		this.licType = licType;
	}

	public String getSubCodeNm() {
		return subCodeNm;
	}

	public void setSubCodeNm(String subCodeNm) {
		this.subCodeNm = subCodeNm;
	}

	public String getLicDetail() {
		return licDetail;
	}

	public void setLicDetail(String licDetail) {
		this.licDetail = licDetail;
	}

	public String getDeptCode() {
		return deptCode;
	}

	public void setDeptCode(String deptCode) {
		this.deptCode = deptCode;
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
