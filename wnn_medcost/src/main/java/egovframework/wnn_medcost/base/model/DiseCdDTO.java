package egovframework.wnn_medcost.base.model;
public class DiseCdDTO {
	private static final long serialVersionUID = 1L;

	public static long getSerialversionuid() {
		return serialVersionUID;
	}
    // Key Fields
    private String keyDiagCode;  // 수가코드 (key)
    private String keyStartDt;   // 적용시작일자 (key)

    // Main Fields
    private String diagCode;      // 상병코드(KCD)
    private String startDt;       // 적용시작일자
    private String korDiagName;   // 한글상병명
    private String engDiagName;   // 영문상병명
    private String genderType;    // 성별구분
    private String infectType;    // 법정감염병구분
    private String diagType;      // 상병구분
    private String icd10Code;     // ICD10코드
    private String endDt;         // 적용종료일자
    private Integer maxAge;       // 상한연령
    private Integer minAge;       // 하한연령
    private String vcode;         // V코드 정보
    private String descInfo;      // 설명

    // Audit Fields
    private String regDttm;  // 등록일시
    private String regUser;  // 등록자
    private String regIp;    // 등록 IP
    private String updDttm;  // 최종변경일시
    private String updUser;  // 최종변경자
    private String updIp;    // 최종변경 IP

    // 검색 데이터 (MyBatis ResultMap 제외)
    private transient String findData; // MyBatis에서 매핑되지 않도록 설정

	public String getKeyDiagCode() {
		return keyDiagCode;
	}

	public void setKeyDiagCode(String keyDiagCode) {
		this.keyDiagCode = keyDiagCode;
	}

	public String getKeyStartDt() {
		return keyStartDt;
	}

	public void setKeyStartDt(String keyStartDt) {
		this.keyStartDt = keyStartDt;
	}

	public String getDiagCode() {
		return diagCode;
	}

	public void setDiagCode(String diagCode) {
		this.diagCode = diagCode;
	}

	public String getStartDt() {
		return startDt;
	}

	public void setStartDt(String startDt) {
		this.startDt = startDt;
	}

	public String getKorDiagName() {
		return korDiagName;
	}

	public void setKorDiagName(String korDiagName) {
		this.korDiagName = korDiagName;
	}

	public String getEngDiagName() {
		return engDiagName;
	}

	public void setEngDiagName(String engDiagName) {
		this.engDiagName = engDiagName;
	}

	public String getGenderType() {
		return genderType;
	}

	public void setGenderType(String genderType) {
		this.genderType = genderType;
	}

	public String getInfectType() {
		return infectType;
	}

	public void setInfectType(String infectType) {
		this.infectType = infectType;
	}

	public String getDiagType() {
		return diagType;
	}

	public void setDiagType(String diagType) {
		this.diagType = diagType;
	}

	public String getIcd10Code() {
		return icd10Code;
	}

	public void setIcd10Code(String icd10Code) {
		this.icd10Code = icd10Code;
	}

	public String getEndDt() {
		return endDt;
	}

	public void setEndDt(String endDt) {
		this.endDt = endDt;
	}

	public Integer getMaxAge() {
		return maxAge;
	}

	public void setMaxAge(Integer maxAge) {
		this.maxAge = maxAge;
	}

	public Integer getMinAge() {
		return minAge;
	}

	public void setMinAge(Integer minAge) {
		this.minAge = minAge;
	}

	public String getvcode() {
		return vcode;
	}

	public void setvCode(String vcode) {
		this.vcode = vcode;
	}

	public String getDescInfo() {
		return descInfo;
	}

	public void setDescInfo(String descInfo) {
		this.descInfo = descInfo;
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
