package egovframework.wnn_medcost.chung.model;
public class ChungDTO {
	private static final long serialVersionUID = 1L;
	public static long getSerialversionuid() {
		return serialVersionUID;
	}
    private String  dateYm;
    private String  hospCd;
    private String  claimNo   ;  
    private String  clformVer ;
    private String  cformNo   ;
    private String  cformName ; 
    private String  treatType ;
    private String  treatName ;
    private String  caseCnt   ;
    private String  totAmt     ;
    private String  claimAmt  ;
    private String  selfAmt   ;  
    private String  startMonth ;
    private String  endMonth  ;
    private String  Month  ;
    private String  mformNm  ;
    private String  billSeq  ;
    private String  patName  ;
    private String  firstAdmt  ;
    private String  patId  ;
    private String  facCode  ;    
    private String  jinDays  ; 
    private String  medAmt  ; 
    private String  payType ;
    private String  claimGrp ;
	private String  insurType ;
	private String  accType  ;
	private String  medType ;
	private String  medResult ;
	
	private String  diagCode ;
	private String  diagName ;
	private String  diagType ;
	private String  medField ;
	private String  licenseType ;
	private String  licenseNo ; 
	private String  medStartDate ; 
	private String  ediCode ;
	private String  korName ;
	
	private String  codeType ;   //코드구분
	private String  unitPrice ;  //단가 
	private String  onceDose ;   //횟수 
	private String  dailyDose ;  //투약량
	private String  totalDose ;  //일수 
	private String  amount ;     //금액 

	private String  itemNo ;
	private String  codeNo ;	
	private String  codeName ;     //금액 
	private String  gasanRate ;     //금액 
	private String  jeaAmt ;
	private String  hwiAmt ;
	private String  gasanAmt ;
	private String  unitType ;
	private String  specType ;
	private String  specDetail ;
	
	public String getUnitType() {
		return unitType;
	}
	public void setUnitType(String unitType) {
		this.unitType = unitType;
	}
	public String getSpecType() {
		return specType;
	}
	public void setSpecType(String specType) {
		this.specType = specType;
	}
	public String getSpecDetail() {
		return specDetail;
	}
	public void setSpecDetail(String specDetail) {
		this.specDetail = specDetail;
	}
	public String getCodeName() {
		return codeName;
	}
	public void setCodeName(String codeName) {
		this.codeName = codeName;
	}
	public String getGasanRate() {
		return gasanRate;
	}
	public void setGasanRate(String gasanRate) {
		this.gasanRate = gasanRate;
	}
	public String getJeaAmt() {
		return jeaAmt;
	}
	public void setJeaAmt(String jeaAmt) {
		this.jeaAmt = jeaAmt;
	}
	public String getHwiAmt() {
		return hwiAmt;
	}
	public void setHwiAmt(String hwiAmt) {
		this.hwiAmt = hwiAmt;
	}
	public String getGasanAmt() {
		return gasanAmt;
	}
	public void setGasanAmt(String gasanAmt) {
		this.gasanAmt = gasanAmt;
	}
	public String getCodeType() {
		return codeType;
	}
	public void setCodeType(String codeType) {
		this.codeType = codeType;
	}
	public String getUnitPrice() {
		return unitPrice;
	}
	public void setUnitPrice(String unitPrice) {
		this.unitPrice = unitPrice;
	}
	public String getOnceDose() {
		return onceDose;
	}
	public void setOnceDose(String onceDose) {
		this.onceDose = onceDose;
	}
	public String getDailyDose() {
		return dailyDose;
	}
	public void setDailyDose(String dailyDose) {
		this.dailyDose = dailyDose;
	}
	public String getTotalDose() {
		return totalDose;
	}
	public void setTotalDose(String totalDose) {
		this.totalDose = totalDose;
	}
	public String getAmount() {
		return amount;
	}
	public void setAmount(String amount) {
		this.amount = amount;
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
	public String getEdiCode() {
		return ediCode;
	}
	public void setEdiCode(String ediCode) {
		this.ediCode = ediCode;
	}
	public String getKorName() {
		return korName;
	}
	public void setKorName(String korName) {
		this.korName = korName;
	}
	public String getDiagCode() {
		return diagCode;
	}
	public void setDiagCode(String diagCode) {
		this.diagCode = diagCode;
	}
	public String getDiagName() {
		return diagName;
	}
	public void setDiagName(String diagName) {
		this.diagName = diagName;
	}
	public String getDiagType() {
		return diagType;
	}
	public void setDiagType(String diagType) {
		this.diagType = diagType;
	}
	public String getMedField() {
		return medField;
	}
	public void setMedField(String medField) {
		this.medField = medField;
	}
	public String getLicenseType() {
		return licenseType;
	}
	public void setLicenseType(String licenseType) {
		this.licenseType = licenseType;
	}
	public String getLicenseNo() {
		return licenseNo;
	}
	public void setLicenseNo(String licenseNo) {
		this.licenseNo = licenseNo;
	}
	public String getMedStartDate() {
		return medStartDate;
	}
	public void setMedStartDate(String medStartDate) {
		this.medStartDate = medStartDate;
	}
	public String getMedResult() {
		return medResult;
	}
	public void setMedResult(String medResult) {
		this.medResult = medResult;
	}
    public String getMedType() {
		return medType;
	}
	public void setMedType(String medType) {
		this.medType = medType;
	}
	public String getAccType() {
		return accType;
	}
	public void setAccType(String accType) {
		this.accType = accType;
	}
	public String getInsurType() {
		return insurType;
	}
	public void setInsurType(String insurType) {
		this.insurType = insurType;
	}
    
    public String getClaimGrp() {
		return claimGrp;
	}
	public void setClaimGrp(String claimGrp) {
		this.claimGrp = claimGrp;
	}
	public String getPayType() {
		return payType;
	}
	public void setPayType(String payType) {
		this.payType = payType;
	}
	public String getMformNm() {
		return mformNm;
	}
	public void setMformNm(String mformNm) {
		this.mformNm = mformNm;
	}
	public String getBillSeq() {
		return billSeq;
	}
	public void setBillSeq(String billSeq) {
		this.billSeq = billSeq;
	}
	public String getPatName() {
		return patName;
	}
	public void setPatName(String patName) {
		this.patName = patName;
	}
	public String getFirstAdmt() {
		return firstAdmt;
	}
	public void setFirstAdmt(String firstAdmt) {
		this.firstAdmt = firstAdmt;
	}
	public String getPatId() {
		return patId;
	}
	public void setPatId(String patId) {
		this.patId = patId;
	}
	public String getFacCode() {
		return facCode;
	}
	public void setFacCode(String facCode) {
		this.facCode = facCode;
	}
	public String getJinDays() {
		return jinDays;
	}
	public void setJinDays(String jinDays) {
		this.jinDays = jinDays;
	}
	public String getMedAmt() {
		return medAmt;
	}
	public void setMedAmt(String medAmt) {
		this.medAmt = medAmt;
	}
	public String getMonth() {
		return Month;
	}
	public void setMonth(String month) {
		Month = month;
	}
	public void setTotAmt(String totAmt) {
		this.totAmt = totAmt;
	}
	public String getDateYm() {
		return dateYm;
	}
	public void setDateYm(String dateYm) {
		this.dateYm = dateYm;
	}
	public String getHospCd() {
		return hospCd;
	}
	public void setHospCd(String hospCd) {
		this.hospCd = hospCd;
	}
	public String getClaimNo() {
		return claimNo;
	}
	public void setClaimNo(String claimNo) {
		this.claimNo = claimNo;
	}
	public String getClformVer() {
		return clformVer;
	}
	public void setClformVer(String clformVer) {
		this.clformVer = clformVer;
	}
	public String getCformNo() {
		return cformNo;
	}
	public void setCformNo(String cformNo) {
		this.cformNo = cformNo;
	}
	public String getCformName() {
		return cformName;
	}
	public void setCformName(String cformName) {
		this.cformName = cformName;
	}
	public String getTreatType() {
		return treatType;
	}
	public void setTreatType(String treatType) {
		this.treatType = treatType;
	}
	public String getTreatName() {
		return treatName;
	}
	public void setTreatName(String treatName) {
		this.treatName = treatName;
	}
	public String getCaseCnt() {
		return caseCnt;
	}
	public void setCaseCnt(String caseCnt) {
		this.caseCnt = caseCnt;
	}
	public String getTotAmt() {
		return totAmt;
	}
	public void setTotamt(String totAmt) {
		this.totAmt = totAmt;
	}
	public String getClaimAmt() {
		return claimAmt;
	}
	public void setClaimAmt(String claimAmt) {
		this.claimAmt = claimAmt;
	}
	public String getSelfAmt() {
		return selfAmt;
	}
	public void setSelfAmt(String selfAmt) {
		this.selfAmt = selfAmt;
	}
	public String getStartMonth() {
		return startMonth;
	}
	public void setStartMonth(String startMonth) {
		this.startMonth = startMonth;
	}
	public String getEndMonth() {
		return endMonth;
	}
	public void setEndMonth(String endMonth) {
		this.endMonth = endMonth;
	}
  
}
