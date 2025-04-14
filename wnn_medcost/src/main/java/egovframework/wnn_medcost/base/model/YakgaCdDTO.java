package egovframework.wnn_medcost.base.model;


public class YakgaCdDTO{

	private static final long serialVersionUID = 1L;

	public static long getSerialversionuid() {
		return serialVersionUID;
	}
    private String keyFeeCode;  // 수가코드 (key)
    private String keyStartDt;  // 적용시작일자 (key)
    
	private String feeCode;
    private String startDt;
    private String kyeGu;
    private String hosPrice;
    private String gaPrice;
    private String bokPath;
    private String korNm;
    private String std;
    private String unit;
    private String upso;
    private String bunCd;
    private String sungCd;
    private String medGu;
    private String tejangRea;
    private String medLevel;
    private String lowYn;
    private String etcMed;
    private String optMedYn;
    private String medRegDt;
    private String repCd;
    private String spcMedGu;
    private String saleDt;
    private String identiMed;
    private String chungStd;
    private String copay30;
    private String copay50;
    private String copay80;
    private String copayYn;
    private String preFeeCode;
    private String afrFeeCode;

    private transient String findData;  // 검색 Data (MyBatis 매핑 제외)
    
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
	public String getFindData() {
		return findData;
	}
	public void setFindData(String findData) {
		this.findData = findData;
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
	public String getKyeGu() {
		return kyeGu;
	}
	public void setKyeGu(String kyeGu) {
		this.kyeGu = kyeGu;
	}
	public String getHosPrice() {
		return hosPrice;
	}
	public void setHosPrice(String hosPrice) {
		this.hosPrice = hosPrice;
	}
	public String getGaPrice() {
		return gaPrice;
	}
	public void setGaPrice(String gaPrice) {
		this.gaPrice = gaPrice;
	}
	public String getBokPath() {
		return bokPath;
	}
	public void setBokPath(String bokPath) {
		this.bokPath = bokPath;
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
	public String getUpso() {
		return upso;
	}
	public void setUpso(String upso) {
		this.upso = upso;
	}
	public String getBunCd() {
		return bunCd;
	}
	public void setBunCd(String bunCd) {
		this.bunCd = bunCd;
	}
	public String getSungCd() {
		return sungCd;
	}
	public void setSungCd(String sungCd) {
		this.sungCd = sungCd;
	}
	public String getMedGu() {
		return medGu;
	}
	public void setMedGu(String medGu) {
		this.medGu = medGu;
	}
	public String getTejangRea() {
		return tejangRea;
	}
	public void setTejangRea(String tejangRea) {
		this.tejangRea = tejangRea;
	}
	public String getMedLevel() {
		return medLevel;
	}
	public void setMedLevel(String medLevel) {
		this.medLevel = medLevel;
	}
	public String getLowYn() {
		return lowYn;
	}
	public void setLowYn(String lowYn) {
		this.lowYn = lowYn;
	}
	public String getEtcMed() {
		return etcMed;
	}
	public void setEtcMed(String etcMed) {
		this.etcMed = etcMed;
	}
	public String getOptMedYn() {
		return optMedYn;
	}
	public void setOptMedYn(String optMedYn) {
		this.optMedYn = optMedYn;
	}
	public String getMedRegDt() {
		return medRegDt;
	}
	public void setMedRegDt(String medRegDt) {
		this.medRegDt = medRegDt;
	}
	public String getRepCd() {
		return repCd;
	}
	public void setRepCd(String repCd) {
		this.repCd = repCd;
	}
	public String getSpcMedGu() {
		return spcMedGu;
	}
	public void setSpcMedGu(String spcMedGu) {
		this.spcMedGu = spcMedGu;
	}
	public String getSaleDt() {
		return saleDt;
	}
	public void setSaleDt(String saleDt) {
		this.saleDt = saleDt;
	}
	public String getIdentiMed() {
		return identiMed;
	}
	public void setIdentiMed(String identiMed) {
		this.identiMed = identiMed;
	}
	public String getChungStd() {
		return chungStd;
	}
	public void setChungStd(String chungStd) {
		this.chungStd = chungStd;
	}
	public String getCopay30() {
		return copay30;
	}
	public void setCopay30(String copay30) {
		this.copay30 = copay30;
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
	public String getCopayYn() {
		return copayYn;
	}
	public void setCopayYn(String copayYn) {
		this.copayYn = copayYn;
	}
	public String getPreFeeCode() {
		return preFeeCode;
	}
	public void setPreFeeCode(String preFeeCode) {
		this.preFeeCode = preFeeCode;
	}
	public String getAfrFeeCode() {
		return afrFeeCode;
	}
	public void setAfrFeeCode(String afrFeeCode) {
		this.afrFeeCode = afrFeeCode;
	}

}
