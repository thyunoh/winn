package egovframework.wnn_medcost.base.model;


public class JearyoCdDTO{

	private static final long serialVersionUID = 1L;

	public static long getSerialversionuid() {
		return serialVersionUID;
	}
    private String keyFeeCode;  // 수가코드 (key)
    private String keyStartDt;  // 적용시작일자 (key)
    
	private String feeCode;
    private String startDt;

    private String firstDt;
    private String endDt;
    private String midBunru;
    private String midCode;
    private String korNm;
    private String std;
    private String unit;
    private String hospPrice;
    private String companyNm;
    private String jaejil;
    private String impUpso;
    private String regNumber;
    private String copay50;
    private String copay80;
    private String copay90;
    private String dupYn;
    private String remark;
    private transient String findData;  // 검색 Data (MyBatis 매핑 제외)
    
	public String getFindData() {
		return findData;
	}
	public void setFindData(String findData) {
		this.findData = findData;
	}
	public String getKeyFeeCode() {
		return keyFeeCode;
	}
	public void setKeyFeeCode(String keyFeeCode) {
		this.keyFeeCode = keyFeeCode;
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
	public String getStartDt() {
		return startDt;
	}
	public void setStartDt(String startDt) {
		this.startDt = startDt;
	}
	public String getFirstDt() {
		return firstDt;
	}
	public void setFirstDt(String firstDt) {
		this.firstDt = firstDt;
	}
	public String getEndDt() {
		return endDt;
	}
	public void setEndDt(String endDt) {
		this.endDt = endDt;
	}
	public String getMidBunru() {
		return midBunru;
	}
	public void setMidBunru(String midBunru) {
		this.midBunru = midBunru;
	}
	public String getMidCode() {
		return midCode;
	}
	public void setMidCode(String midCode) {
		this.midCode = midCode;
	}
	public String getKorNm() {
		return korNm;
	}
	public void setKorNm(String korNm) {
		this.korNm = korNm;
	}
	public String getStd() {
		return std;
	}
	public void setStd(String std) {
		this.std = std;
	}
	public String getUnit() {
		return unit;
	}
	public void setUnit(String unit) {
		this.unit = unit;
	}
	public String getHospPrice() {
		return hospPrice;
	}
	public void setHospPrice(String hospPrice) {
		this.hospPrice = hospPrice;
	}
	public String getCompanyNm() {
		return companyNm;
	}
	public void setCompanyNm(String companyNm) {
		this.companyNm = companyNm;
	}
	public String getJaejil() {
		return jaejil;
	}
	public void setJaejil(String jaejil) {
		this.jaejil = jaejil;
	}
	public String getImpUpso() {
		return impUpso;
	}
	public void setImpUpso(String impUpso) {
		this.impUpso = impUpso;
	}
	public String getRegNumber() {
		return regNumber;
	}
	public void setRegNumber(String regNumber) {
		this.regNumber = regNumber;
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
	public String getRemark() {
		return remark;
	}
	public void setRemark(String remark) {
		this.remark = remark;
	}   
    
}
