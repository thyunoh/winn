package egovframework.wnn_medcost.user.model;

public class LicnumDTO {
	private static final long serialVersionUID = 1L;

	public static long getSerialversionuid() {
		return serialVersionUID;
	}
    // Key Fields
    private String keyhospCd;    // 
    private String keylicNum;    // 
    private String keyipDat;      // 
    
    private String hospCd;
    private String licNum;
    private String ipDat;

    private String licenseGb;
    private String doctorGb;
    private String doctorType;
    private String name;
    private String jumin;
    private String workGb;
    private String licDat;

    private String vacGb;
    private String vacStart;
    private String vacEnd;
    private String vacSubnm;
    private String vacsubStrdt;
    private String vacsubEnddt;

    private String wardNm;
    private String wardDanwi;
    private String wardStrdt;
    private String wardEnddt;
    private String wardMain;

    private String lastWorkdt;
    private String hisInfo;
    private String manChg;
    private String manRea;
    private String nurGrd;
    
    public String getNurGrd() {
		return nurGrd;
	}
	public void setNurGrd(String nurGrd) {
		this.nurGrd = nurGrd;
	}
	private transient String findData; // MyBatis에서 매핑되지 않도록 설정

	public String getWardNm() {
		return wardNm;
	}
	public void setWardNm(String wardNm) {
		this.wardNm = wardNm;
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
	public String getKeyipDat() {
		return keyipDat;
	}
	public void setKeyipDat(String keyipDat) {
		this.keyipDat = keyipDat;
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
	public String getIpDat() {
		return ipDat;
	}
	public void setIpDat(String ipDat) {
		this.ipDat = ipDat;
	}
	public String getLicenseGb() {
		return licenseGb;
	}
	public void setLicenseGb(String licenseGb) {
		this.licenseGb = licenseGb;
	}
	public String getDoctorGb() {
		return doctorGb;
	}
	public void setDoctorGb(String doctorGb) {
		this.doctorGb = doctorGb;
	}
	public String getDoctorType() {
		return doctorType;
	}
	public void setDoctorType(String doctorType) {
		this.doctorType = doctorType;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getJumin() {
		return jumin;
	}
	public void setJumin(String jumin) {
		this.jumin = jumin;
	}
	public String getWorkGb() {
		return workGb;
	}
	public void setWorkGb(String workGb) {
		this.workGb = workGb;
	}
	public String getLicDat() {
		return licDat;
	}
	public void setLicDat(String licDat) {
		this.licDat = licDat;
	}
	public String getVacGb() {
		return vacGb;
	}
	public void setVacGb(String vacGb) {
		this.vacGb = vacGb;
	}
	public String getVacStart() {
		return vacStart;
	}
	public void setVacStart(String vacStart) {
		this.vacStart = vacStart;
	}
	public String getVacEnd() {
		return vacEnd;
	}
	public void setVacEnd(String vacEnd) {
		this.vacEnd = vacEnd;
	}
	public String getVacSubnm() {
		return vacSubnm;
	}
	public void setVacSubnm(String vacSubnm) {
		this.vacSubnm = vacSubnm;
	}
	public String getVacsubStrdt() {
		return vacsubStrdt;
	}
	public void setVacsubStrdt(String vacsubStrdt) {
		this.vacsubStrdt = vacsubStrdt;
	}
	public String getVacsubEnddt() {
		return vacsubEnddt;
	}
	public void setVacsubEnddt(String vacsubEnddt) {
		this.vacsubEnddt = vacsubEnddt;
	}

	public String getWardDanwi() {
		return wardDanwi;
	}
	public void setWardDanwi(String wardDanwi) {
		this.wardDanwi = wardDanwi;
	}
	public String getWardStrdt() {
		return wardStrdt;
	}
	public void setWardStrdt(String wardStrdt) {
		this.wardStrdt = wardStrdt;
	}
	public String getWardEnddt() {
		return wardEnddt;
	}
	public void setWardEnddt(String wardEnddt) {
		this.wardEnddt = wardEnddt;
	}
	public String getWardMain() {
		return wardMain;
	}
	public void setWardMain(String wardMain) {
		this.wardMain = wardMain;
	}
	public String getLastWorkdt() {
		return lastWorkdt;
	}
	public void setLastWorkdt(String lastWorkdt) {
		this.lastWorkdt = lastWorkdt;
	}
	public String getHisInfo() {
		return hisInfo;
	}
	public void setHisInfo(String hisInfo) {
		this.hisInfo = hisInfo;
	}
	public String getManChg() {
		return manChg;
	}
	public void setManChg(String manChg) {
		this.manChg = manChg;
	}
	public String getManRea() {
		return manRea;
	}
	public void setManRea(String manRea) {
		this.manRea = manRea;
	}
	public String getFindData() {
		return findData;
	}
	public void setFindData(String findData) {
		this.findData = findData;
	}

    
}
