package egovframework.wnn_medcost.base.model;
public class ClaimDTO {
	private static final long serialVersionUID = 1L;

	public static long getSerialversionuid() {
		return serialVersionUID;
	}
	private String keyhosGrd;       // 1(상급)2.(종합)3.(병원)
    private String keycformNo;       // 보험유형(건강보험 요양급여비용 심사청구서)
    private String keymedcovtype;    //급여분류 
    private String keyacctype;       // 공상구분  
    private String keycformIo;       // 외래입원
    private String keyitemNo;        // 항
    private String keycodeNo;        // 목
    private String keyedifcode;      // FROM(EDI_CODE)
    private String keyeditcode;      // TO(EDI_CODE)
    private String keystartYm;       // 적용년월
    
	private String  hosGrd;       // 1(상급)2.(종합)3.(병원)
    private String  cformNo;       // 보험유형(건강보험 요양급여비용 심사청구서)
    private String  medCovType;   //급여분류 
    private String  accType;      // 공상구분 
    private String  cformIo;       // 외래입원
    private String  itemNo;        // 항
    private String  codeNo;        // 목
    private String  ediFcode;      // FROM(EDI_CODE)
    private String  ediTcode;      // TO(EDI_CODE)
    private String  ediLcode;      // 
    private String  ediPcode1;      // 
    private String  ediPcode2; 
    private String  ediPcode3;
    private String  startYm;       // 적용년월
    private String  claimRate;    // 청구율
    private String  minorRate;    // 경증청구율
    private String  hosGrdName;    // 청구율
    private String  cformName;    // 청구율
    private String  accTypeName;    // 경증청구율
    private String  medCovName ;
    private String  cformIoName ;    // 청구율
    // Audit Fields
    private String regDttm;  // 등록일시
    private String regUser;  // 등록자
    private String regIp;    // 등록 IP
    private String updDttm;  // 최종변경일시
    private String updUser;  // 최종변경자
    private String updIp;    // 최종변경 IP

    public String getCformIoName() {
		return cformIoName;
	}

	public void setCformIoName(String cformIoName) {
		this.cformIoName = cformIoName;
	}
	private transient String findData; // MyBatis에서 매핑되지 않도록 설정

	public String getMedCovName() {
		return medCovName;
	}

	public String getKeymedcovtype() {
		return keymedcovtype;
	}

	public void setKeymedcovtype(String keymedcovtype) {
		this.keymedcovtype = keymedcovtype;
	}

	public String getKeyacctype() {
		return keyacctype;
	}

	public void setKeyacctype(String keyacctype) {
		this.keyacctype = keyacctype;
	}

	public String getAccTypeName() {
		return accTypeName;
	}

	public void setAccTypeName(String accTypeName) {
		this.accTypeName = accTypeName;
	}

	public void setMedCovName(String medCovName) {
		this.medCovName = medCovName;
	}

	public String getMedCovType() {
		return medCovType;
	}

	public void setMedCovType(String medCovType) {
		this.medCovType = medCovType;
	}

	public String getAccType() {
		return accType;
	}

	public void setAccType(String accType) {
		this.accType = accType;
	}

	public String getKeycformIo() {
		return keycformIo;
	}

	public void setKeycformIo(String keycformIo) {
		this.keycformIo = keycformIo;
	}

	public String getHosGrdName() {
		return hosGrdName;
	}

	public void setHosGrdName(String hosGrdName) {
		this.hosGrdName = hosGrdName;
	}

	public String getCformName() {
		return cformName;
	}

	public void setCformName(String cformName) {
		this.cformName = cformName;
	}
	public String getKeyhosGrd() {
		return keyhosGrd;
	}

	public void setKeyhosGrd(String keyhosGrd) {
		this.keyhosGrd = keyhosGrd;
	}

	public String getKeycformNo() {
		return keycformNo;
	}

	public void setKeycformNo(String keycformNo) {
		this.keycformNo = keycformNo;
	}

	public String getKeyclaimIo() {
		return keycformIo;
	}

	public void setKeyclaimIo(String keyclaimIo) {
		this.keycformIo = keyclaimIo;
	}

	public String getKeyitemNo() {
		return keyitemNo;
	}

	public void setKeyitemNo(String keyitemNo) {
		this.keyitemNo = keyitemNo;
	}

	public String getKeycodeNo() {
		return keycodeNo;
	}

	public void setKeycodeNo(String keycodeNo) {
		this.keycodeNo = keycodeNo;
	}


	public String getKeystartYm() {
		return keystartYm;
	}

	public void setKeystartYm(String keystartYm) {
		this.keystartYm = keystartYm;
	}

	public String getHosGrd() {
		return hosGrd;
	}

	public void setHosGrd(String hosGrd) {
		this.hosGrd = hosGrd;
	}
	public String getItemNo() {
		return itemNo;
	}

	public void setItemNo(String itemNo) {
		this.itemNo = itemNo;
	}

	public String getCodeNo() {
		return codeNo;
	}

	public void setCodeNo(String codeNo) {
		this.codeNo = codeNo;
	}

	public String getEdiFcode() {
		return ediFcode;
	}

	public void setEdiFcode(String ediFcode) {
		this.ediFcode = ediFcode;
	}

	public String getEdiTcode() {
		return ediTcode;
	}

	public void setEdiTcode(String ediTcode) {
		this.ediTcode = ediTcode;
	}

	public String getStartYm() {
		return startYm;
	}

	public void setStartYm(String startYm) {
		this.startYm = startYm;
	}

	public String getClaimRate() {
		return claimRate;
	}

	public void setClaimRate(String claimRate) {
		this.claimRate = claimRate;
	}

	public String getMinorRate() {
		return minorRate;
	}

	public void setMinorRate(String minorRate) {
		this.minorRate = minorRate;
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

	public String getCformNo() {
		return cformNo;
	}

	public void setCformNo(String cformNo) {
		this.cformNo = cformNo;
	}

	public String getCformIo() {
		return cformIo;
	}

	public void setCformIo(String cformIo) {
		this.cformIo = cformIo;
	}

	public String getEdiLcode() {
		return ediLcode;
	}

	public void setEdiLcode(String ediLcode) {
		this.ediLcode = ediLcode;
	}

	public String getEdiPcode1() {
		return ediPcode1;
	}

	public void setEdiPcode1(String ediPcode1) {
		this.ediPcode1 = ediPcode1;
	}

	public String getEdiPcode2() {
		return ediPcode2;
	}

	public void setEdiPcode2(String ediPcode2) {
		this.ediPcode2 = ediPcode2;
	}

	public String getEdiPcode3() {
		return ediPcode3;
	}

	public void setEdiPcode3(String ediPcode3) {
		this.ediPcode3 = ediPcode3;
	}

	public String getKeyedifcode() {
		return keyedifcode;
	}

	public void setKeyedifcode(String keyedifcode) {
		this.keyedifcode = keyedifcode;
	}

	public String getKeyeditcode() {
		return keyeditcode;
	}

	public void setKeyeditcode(String keyeditcode) {
		this.keyeditcode = keyeditcode;
	}

    
}
