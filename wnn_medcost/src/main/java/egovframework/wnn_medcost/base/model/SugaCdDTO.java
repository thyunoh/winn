package egovframework.wnn_medcost.base.model;


public class SugaCdDTO{

	private static final long serialVersionUID = 1L;

	public static long getSerialversionuid() {
		return serialVersionUID;
	}
	
	// Key Fields
    private String keyFeeCode;  // 수가코드 (key)
    private String keyFeeType;  // 수가구분(일반/약가/재료) (key)
    private String keyStartDt;  // 적용시작일자 (key)

    // Main Fields
    private String feeCode;     // 수가코드
    private String feeType;     // 수가구분(일반/약가/재료)
    private String startDt;     // 적용시작일자
    private String endDt;       // 적용종료일자
    private String classNo;    
    private String korNm;       // 한글명
    private String engNm;       // 영문명
    private String divType;     // 1-2구분
    private String surgYn;      // 수술여부

    // Pricing Fields
    private String clnPrice;    // 의원단가
    private String hosPrice;    // 병원급이상단가
    private String dntPrice;    // 치과병의원단가
    private String pblPrice;    // 보건기관단가
    private String midPrice;    // 조산원단가
    private String orhPrice;    // 한방병원단가
    private String rltValue;    // 상대가치점수
    private String copay50;     // 본인부담률50/100
    private String copay80;     // 본인부담률80/100
    private String copay90;     // 본인부담률90/100

    // Classification Fields
    private String dupYn;       // 중복인정여부
    private String calcNm;      // 산정명칭
    private String secMaj;      // 장구분
    private String secMin;      // 절구분
    private String subCat;      // 세분류

    // Audit Fields
    private String regDttm;     // 등록일시
    private String regUser;     // 등록자
    private String regIp;       // 등록 IP
    private String updDttm;     // 최종변경일시
    private String updUser;     // 최종변경자
    private String updIp;       // 최종변경 IP

    // 기타 필요 필드
    private transient String findData;  // 검색 Data (MyBatis 매핑 제외)
    private String feeTypeNm;  // 수가 Type명칭 (1.수가, 2.약가, 3.재료)

	public String getKeyFeeCode() {
		return keyFeeCode;
	}
	public void setKeyFeeCode(String keyFeeCode) {
		this.keyFeeCode = keyFeeCode;
	}
	public String getKeyFeeType() {
		return keyFeeType;
	}
	public void setKeyFeeType(String keyFeeType) {
		this.keyFeeType = keyFeeType;
	}
	public String getKeyStartDt() {
		return keyStartDt;
	}
	public void setKeyStartDt(String keyStartDt) {
		this.keyStartDt = keyStartDt;
	}
	public String getFeeCode() {
		return feeCode;
	}
	public void setFeeCode(String feeCode) {
		this.feeCode = feeCode;
	}
	public String getFeeType() {
		return feeType;
	}
	public void setFeeType(String feeType) {
		this.feeType = feeType;
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
	public String getClassNo() {
		return classNo;
	}
	public void setClassNo(String classNo) {
		this.classNo = classNo;
	}
	public String getKorNm() {
		return korNm;
	}
	public void setKorNm(String korNm) {
		this.korNm = korNm;
	}
	public String getEngNm() {
		return engNm;
	}
	public void setEngNm(String engNm) {
		this.engNm = engNm;
	}
	public String getDivType() {
		return divType;
	}
	public void setDivType(String divType) {
		this.divType = divType;
	}
	public String getSurgYn() {
		return surgYn;
	}
	public void setSurgYn(String surgYn) {
		this.surgYn = surgYn;
	}
	public String getClnPrice() {
		return clnPrice;
	}
	public void setClnPrice(String clnPrice) {
		this.clnPrice = clnPrice;
	}
	public String getHosPrice() {
		return hosPrice;
	}
	public void setHosPrice(String hosPrice) {
		this.hosPrice = hosPrice;
	}
	public String getDntPrice() {
		return dntPrice;
	}
	public void setDntPrice(String dntPrice) {
		this.dntPrice = dntPrice;
	}
	public String getPblPrice() {
		return pblPrice;
	}
	public void setPblPrice(String pblPrice) {
		this.pblPrice = pblPrice;
	}
	public String getMidPrice() {
		return midPrice;
	}
	public void setMidPrice(String midPrice) {
		this.midPrice = midPrice;
	}
	public String getOrhPrice() {
		return orhPrice;
	}
	public void setOrhPrice(String orhPrice) {
		this.orhPrice = orhPrice;
	}
	public String getRltValue() {
		return rltValue;
	}
	public void setRltValue(String rltValue) {
		this.rltValue = rltValue;
	}
	public String getCopay50() {
		return copay50;
	}
	public void setCopay50(String copay50) {
		this.copay50 = copay50;
	}
	public String getCopay80() {
		return copay80;
	}
	public void setCopay80(String copay80) {
		this.copay80 = copay80;
	}
	public String getCopay90() {
		return copay90;
	}
	public void setCopay90(String copay90) {
		this.copay90 = copay90;
	}
	public String getDupYn() {
		return dupYn;
	}
	public void setDupYn(String dupYn) {
		this.dupYn = dupYn;
	}
	public String getCalcNm() {
		return calcNm;
	}
	public void setCalcNm(String calcNm) {
		this.calcNm = calcNm;
	}
	public String getSecMaj() {
		return secMaj;
	}
	public void setSecMaj(String secMaj) {
		this.secMaj = secMaj;
	}
	public String getSecMin() {
		return secMin;
	}
	public void setSecMin(String secMin) {
		this.secMin = secMin;
	}
	public String getSubCat() {
		return subCat;
	}
	public void setSubCat(String subCat) {
		this.subCat = subCat;
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
	public String getFeeTypeNm() {
		return feeTypeNm;
	}
	public void setFeeTypeNm(String feeTypeNm) {
		this.feeTypeNm = feeTypeNm;
	}

}
