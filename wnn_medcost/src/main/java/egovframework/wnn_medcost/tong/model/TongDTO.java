package egovframework.wnn_medcost.tong.model;
public class TongDTO {
	private static final long serialVersionUID = 1L;
	public static long getSerialversionuid() {
		return serialVersionUID;
	}
    private String dateYm;
    private int totalCount;
    private float totalAmt;
    private int totalAvgAmt;
    private int ipCount;
    private int ipAmt;
    private int ipAvgAmt;
    private int opCount;
    private int opAmt;
    private int opAvgAmt;
    private String startMonth ;
    private String endMonth;
    private String hospCd;
    //진료비(백만원)전체 
    private String allCostCurr;
    private String allCostPrev;
    private String allCostRate;
    //전체건수 
    private String allCasesCurr;
    private String allCasesPrev;
    private String allCasesRate;    
    //젙체 전문의당월건수
    private String allCasesPerSpecPrev ;
    private String allCasesPerSpecCurr ; 
    private String allCasesPerSpecRate ;
  //젙체 전문의당진료비(백만원)
    private String allCostPerSpecPrev ;
    private String allCostPerSpecCurr ;
    private String allCostPerSpecRate ;  
   // 입원 건수 
    private String iCasesPrev ;
    private String iCasesCurr ;
    private String iCasesRate ;
   //입원 진료비(백만원) 
    private String iCostPrev ;
    private String iCostCurr ;
    private String iCostRate ;
    
    //입원 평균재원일수
    private String iAvgStayCurr ;
    private String iAvgStayPrev ;
    private String iAvgStayRate ;
 
    //입원 건당진료비(천원)
    private String iCostPerCaseCurr ;
    private String iCostPerCasePrev ;
    private String iCostPerCaseRate ;    
    //입원 일당진료비(천원)
    private String iCostPerDayCurr ;
    private String iCostPerDayPrev ;
    private String iCostPerDayRate ; 
   //입원일당구한값  
    private String iuniqPatiCurr  ;
    private String iuniqPatiPrev  ;
 
    //입원 전문의당월건수
    private String iCasesPerSpecCurr ;
    private String iCasesPerSpecPrev ;
    private String iCasesPerSpecRate ;     

    //입원 전문의당월진료비 
    private String iCostPerSpecCurr ;
    private String iCostPerSpecPrev ;
    private String iCostPerSpecRate ;     
    //외래건수 
    private String oCasesCurr   ;
    private String oCasesPrev   ;
    private String oCasesRate   ;
    //외래진료비 
    private String oCostCurr    ;
    private String oCostPrev    ;
    private String oCostRate    ;

    //외래건당진료비 
    private String oCostPerCaseCurr    ;
    private String oCostPerCasePrev    ;
    private String oCostPerCaseRate    ;    
    //외래초진건수 
    private String oFirstCasesCurr    ;
    private String oFirstCasesPrev    ;
    private String oFirstCasesRate    ; 

    //외래재진건수 
    private String oReturnCasesCurr    ;
    private String oReturnCasesPrev    ;
    private String oReturnCasesRate    ; 

    //외래전문의당월건수
    private String oCasesPerSpecCurr    ;
    private String oCasesPerSpecPrev    ;
    private String oCasesPerSpecRate    ;     

    //외래전문의당월진료비(백만원)
    private String oCostPerSpecCurr    ;
    private String oCostPerSpecPrev    ;
    private String oCostPerSpecRate    ;     

    private String medDept ;
    private String medName ;
    private String avgAmt ;
    private String percentOfTotal ;
    private String ipwe ;
    private String itemName ;
    private String codeName ;
    private String itemNo ;
    private String codeNo ;
    
    private String diagCode ;
    private String diagName ;
    private String claimCount ;  //건수 
    private String uniqPatients ; //인수 
    private String amtPerClaim ;    //건당금액 
    private String amtPerPatient ;  //인당금액 
    private String rateOfTotalAmt ; //건당비율 
    private String rateOfClaims ;   //인당비율 
    private String cformNo ;
    private String cformName ;
 
    private String targetym ;
    private String prevym ;
    
    private String licenseNo ;
    private String licenseName ; 
    private String amtPrev ;
    private String amtCurr ;
    private String cntPrev ;  
    private String cntCurr ; 
    private String avgPrev ;  
    private String avgCurr ;     
    private String amtDiff ; 
    private String percentVsPrev ;
    private String medType ; //의과,치과,한방(0,1,2,3) 
    private String jrType  ; //정액/행위(0,1,2) 
    private String amtType ; //총액/청구액(1,2)
    private String yakAmt  ;      //약제비용   
    private String percentOfAmt ; //약제비율 
    
    public String getPercentOfAmt() {
		return percentOfAmt;
	}
	public void setPercentOfAmt(String percentOfAmt) {
		this.percentOfAmt = percentOfAmt;
	}
	public String getYakAmt() {
		return yakAmt;
	}
	public void setYakAmt(String yakAmt) {
		this.yakAmt = yakAmt;
	}
	public String getMedType() {
		return medType;
	}
	public void setMedType(String medType) {
		this.medType = medType;
	}
	public String getJrType() {
		return jrType;
	}
	public void setJrType(String jrType) {
		this.jrType = jrType;
	}
	public String getAmtType() {
		return amtType;
	}
	public void setAmtType(String amtType) {
		this.amtType = amtType;
	}
	public String getAvgPrev() {
		return avgPrev;
	}
	public void setAvgPrev(String avgPrev) {
		this.avgPrev = avgPrev;
	}
	public String getAvgCurr() {
		return avgCurr;
	}
	public void setAvgCurr(String avgCurr) {
		this.avgCurr = avgCurr;
	}
	public String getTargetym() {
		return targetym;
	}
	public void setTargetym(String targetym) {
		this.targetym = targetym;
	}
	public String getPrevym() {
		return prevym;
	}
	public void setPrevym(String prevym) {
		this.prevym = prevym;
	}
	public String getAmtPrev() {
		return amtPrev;
	}
	public void setAmtPrev(String amtPrev) {
		this.amtPrev = amtPrev;
	}
	public String getAmtCurr() {
		return amtCurr;
	}
	public void setAmtCurr(String amtCurr) {
		this.amtCurr = amtCurr;
	}
	public String getCntPrev() {
		return cntPrev;
	}
	public void setCntPrev(String cntPrev) {
		this.cntPrev = cntPrev;
	}
	public String getCntCurr() {
		return cntCurr;
	}
	public void setCntCurr(String cntCurr) {
		this.cntCurr = cntCurr;
	}
	public String getAmtDiff() {
		return amtDiff;
	}
	public void setAmtDiff(String amtDiff) {
		this.amtDiff = amtDiff;
	}
	public String getPercentVsPrev() {
		return percentVsPrev;
	}
	public void setPercentVsPrev(String percentVsPrev) {
		this.percentVsPrev = percentVsPrev;
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
	public String getLicenseNo() {
		return licenseNo;
	}
	public void setLicenseNo(String licenseNo) {
		this.licenseNo = licenseNo;
	}
	public String getLicenseName() {
		return licenseName;
	}
	public void setLicenseName(String licenseName) {
		this.licenseName = licenseName;
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
	public String getUniqPatients() {
		return uniqPatients;
	}
	public void setUniqPatients(String uniqPatients) {
		this.uniqPatients = uniqPatients;
	}
	public String getAmtPerClaim() {
		return amtPerClaim;
	}
	public void setAmtPerClaim(String amtPerClaim) {
		this.amtPerClaim = amtPerClaim;
	}
	public String getAmtPerPatient() {
		return amtPerPatient;
	}
	public void setAmtPerPatient(String amtPerPatient) {
		this.amtPerPatient = amtPerPatient;
	}
	public String getRateOfTotalAmt() {
		return rateOfTotalAmt;
	}
	public void setRateOfTotalAmt(String rateOfTotalAmt) {
		this.rateOfTotalAmt = rateOfTotalAmt;
	}
	public String getRateOfClaims() {
		return rateOfClaims;
	}
	public void setRateOfClaims(String rateOfClaims) {
		this.rateOfClaims = rateOfClaims;
	}
	public String getCodeName() {
		return codeName;
	}
	public void setCodeName(String codeName) {
		this.codeName = codeName;
	}
	public String getItemName() {
		return itemName;
	}
	public void setItemName(String itemName) {
		this.itemName = itemName;
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
	public String getIpwe() {
		return ipwe;
	}
	public void setIpwe(String ipwe) {
		this.ipwe = ipwe;
	}
	public String getClaimCount() {
		return claimCount;
	}
	public void setClaimCount(String claimCount) {
		this.claimCount = claimCount;
	}
	public String getAvgAmt() {
		return avgAmt;
	}
	public void setAvgAmt(String avgAmt) {
		this.avgAmt = avgAmt;
	}
	public String getPercentOfTotal() {
		return percentOfTotal;
	}
	public void setPercentOfTotal(String percentOfTotal) {
		this.percentOfTotal = percentOfTotal;
	}
	public String getMedDept() {
		return medDept;
	}
	public void setMedDept(String medDept) {
		this.medDept = medDept;
	}
	public String getMedName() {
		return medName;
	}
	public void setMedName(String medName) {
		this.medName = medName;
	}
	public String getoCostPerSpecCurr() {
		return oCostPerSpecCurr;
	}
	public void setoCostPerSpecCurr(String oCostPerSpecCurr) {
		this.oCostPerSpecCurr = oCostPerSpecCurr;
	}
	public String getoCostPerSpecPrev() {
		return oCostPerSpecPrev;
	}
	public void setoCostPerSpecPrev(String oCostPerSpecPrev) {
		this.oCostPerSpecPrev = oCostPerSpecPrev;
	}
	public String getoCostPerSpecRate() {
		return oCostPerSpecRate;
	}
	public void setoCostPerSpecRate(String oCostPerSpecRate) {
		this.oCostPerSpecRate = oCostPerSpecRate;
	}
	public String getoCasesPerSpecCurr() {
		return oCasesPerSpecCurr;
	}
	public void setoCasesPerSpecCurr(String oCasesPerSpecCurr) {
		this.oCasesPerSpecCurr = oCasesPerSpecCurr;
	}
	public String getoCasesPerSpecPrev() {
		return oCasesPerSpecPrev;
	}
	public void setoCasesPerSpecPrev(String oCasesPerSpecPrev) {
		this.oCasesPerSpecPrev = oCasesPerSpecPrev;
	}
	public String getoCasesPerSpecRate() {
		return oCasesPerSpecRate;
	}
	public void setoCasesPerSpecRate(String oCasesPerSpecRate) {
		this.oCasesPerSpecRate = oCasesPerSpecRate;
	}
	public String getoFirstCasesCurr() {
		return oFirstCasesCurr;
	}
	public void setoFirstCasesCurr(String oFirstCasesCurr) {
		this.oFirstCasesCurr = oFirstCasesCurr;
	}
	public String getoFirstCasesPrev() {
		return oFirstCasesPrev;
	}
	public void setoFirstCasesPrev(String oFirstCasesPrev) {
		this.oFirstCasesPrev = oFirstCasesPrev;
	}
	public String getoFirstCasesRate() {
		return oFirstCasesRate;
	}
	public void setoFirstCasesRate(String oFirstCasesRate) {
		this.oFirstCasesRate = oFirstCasesRate;
	}
	public String getoReturnCasesCurr() {
		return oReturnCasesCurr;
	}
	public void setoReturnCasesCurr(String oReturnCasesCurr) {
		this.oReturnCasesCurr = oReturnCasesCurr;
	}
	public String getoReturnCasesPrev() {
		return oReturnCasesPrev;
	}
	public void setoReturnCasesPrev(String oReturnCasesPrev) {
		this.oReturnCasesPrev = oReturnCasesPrev;
	}
	public String getoReturnCasesRate() {
		return oReturnCasesRate;
	}
	public void setoReturnCasesRate(String oReturnCasesRate) {
		this.oReturnCasesRate = oReturnCasesRate;
	}
	public String getoCostPerCaseCurr() {
		return oCostPerCaseCurr;
	}
	public void setoCostPerCaseCurr(String oCostPerCaseCurr) {
		this.oCostPerCaseCurr = oCostPerCaseCurr;
	}
	public String getoCostPerCasePrev() {
		return oCostPerCasePrev;
	}
	public void setoCostPerCasePrev(String oCostPerCasePrev) {
		this.oCostPerCasePrev = oCostPerCasePrev;
	}
	public String getoCostPerCaseRate() {
		return oCostPerCaseRate;
	}
	public void setoCostPerCaseRate(String oCostPerCaseRate) {
		this.oCostPerCaseRate = oCostPerCaseRate;
	}
	public String getoCasesRate() {
		return oCasesRate;
	}
	public void setoCasesRate(String oCasesRate) {
		this.oCasesRate = oCasesRate;
	}
	public String getoCostRate() {
		return oCostRate;
	}
	public void setoCostRate(String oCostRate) {
		this.oCostRate = oCostRate;
	}
	public String getoCasesCurr() {
		return oCasesCurr;
	}
	public void setoCasesCurr(String oCasesCurr) {
		this.oCasesCurr = oCasesCurr;
	}
	public String getoCasesPrev() {
		return oCasesPrev;
	}
	public void setoCasesPrev(String oCasesPrev) {
		this.oCasesPrev = oCasesPrev;
	}
	public String getoCostCurr() {
		return oCostCurr;
	}
	public void setoCostCurr(String oCostCurr) {
		this.oCostCurr = oCostCurr;
	}
	public String getoCostPrev() {
		return oCostPrev;
	}
	public void setoCostPrev(String oCostPrev) {
		this.oCostPrev = oCostPrev;
	}
	public String getiCostPerSpecCurr() {
		return iCostPerSpecCurr;
	}
	public void setiCostPerSpecCurr(String iCostPerSpecCurr) {
		this.iCostPerSpecCurr = iCostPerSpecCurr;
	}
	public String getiCostPerSpecPrev() {
		return iCostPerSpecPrev;
	}
	public void setiCostPerSpecPrev(String iCostPerSpecPrev) {
		this.iCostPerSpecPrev = iCostPerSpecPrev;
	}
	public String getiCostPerSpecRate() {
		return iCostPerSpecRate;
	}
	public void setiCostPerSpecRate(String iCostPerSpecRate) {
		this.iCostPerSpecRate = iCostPerSpecRate;
	}
	public String getiCasesPerSpecCurr() {
		return iCasesPerSpecCurr;
	}
	public void setiCasesPerSpecCurr(String iCasesPerSpecCurr) {
		this.iCasesPerSpecCurr = iCasesPerSpecCurr;
	}
	public String getiCasesPerSpecPrev() {
		return iCasesPerSpecPrev;
	}
	public void setiCasesPerSpecPrev(String iCasesPerSpecPrev) {
		this.iCasesPerSpecPrev = iCasesPerSpecPrev;
	}
	public String getiCasesPerSpecRate() {
		return iCasesPerSpecRate;
	}
	public void setiCasesPerSpecRate(String iCasesPerSpecRate) {
		this.iCasesPerSpecRate = iCasesPerSpecRate;
	}
	public String getIuniqPatiCurr() {
		return iuniqPatiCurr;
	}
	public void setIuniqPatiCurr(String iuniqPatiCurr) {
		this.iuniqPatiCurr = iuniqPatiCurr;
	}
	public String getIuniqPatiPrev() {
		return iuniqPatiPrev;
	}
	public void setIuniqPatiPrev(String iuniqPatiPrev) {
		this.iuniqPatiPrev = iuniqPatiPrev;
	}
	public String getiCostPerDayCurr() {
		return iCostPerDayCurr;
	}
	public void setiCostPerDayCurr(String iCostPerDayCurr) {
		this.iCostPerDayCurr = iCostPerDayCurr;
	}
	public String getiCostPerDayPrev() {
		return iCostPerDayPrev;
	}
	public void setiCostPerDayPrev(String iCostPerDayPrev) {
		this.iCostPerDayPrev = iCostPerDayPrev;
	}
	public String getiCostPerDayRate() {
		return iCostPerDayRate;
	}
	public void setiCostPerDayRate(String iCostPerDayRate) {
		this.iCostPerDayRate = iCostPerDayRate;
	}
	public String getiAvgStayCurr() {
		return iAvgStayCurr;
	}
	public void setiAvgStayCurr(String iAvgStayCurr) {
		this.iAvgStayCurr = iAvgStayCurr;
	}
	public String getiAvgStayPrev() {
		return iAvgStayPrev;
	}
	public void setiAvgStayPrev(String iAvgStayPrev) {
		this.iAvgStayPrev = iAvgStayPrev;
	}
	public String getiAvgStayRate() {
		return iAvgStayRate;
	}
	public void setiAvgStayRate(String iAvgStayRate) {
		this.iAvgStayRate = iAvgStayRate;
	}
	public String getiCostPerCaseCurr() {
		return iCostPerCaseCurr;
	}
	public void setiCostPerCaseCurr(String iCostPerCaseCurr) {
		this.iCostPerCaseCurr = iCostPerCaseCurr;
	}
	public String getiCostPerCasePrev() {
		return iCostPerCasePrev;
	}
	public void setiCostPerCasePrev(String iCostPerCasePrev) {
		this.iCostPerCasePrev = iCostPerCasePrev;
	}
	public String getiCostPerCaseRate() {
		return iCostPerCaseRate;
	}
	public void setiCostPerCaseRate(String iCostPerCaseRate) {
		this.iCostPerCaseRate = iCostPerCaseRate;
	}
	public String getiCostPrev() {
		return iCostPrev;
	}
	public void setiCostPrev(String iCostPrev) {
		this.iCostPrev = iCostPrev;
	}
	public String getiCostCurr() {
		return iCostCurr;
	}
	public void setiCostCurr(String iCostCurr) {
		this.iCostCurr = iCostCurr;
	}
	public String getiCostRate() {
		return iCostRate;
	}
	public void setiCostRate(String iCostRate) {
		this.iCostRate = iCostRate;
	}
	public String getiCasesPrev() {
		return iCasesPrev;
	}
	public void setiCasesPrev(String iCasesPrev) {
		this.iCasesPrev = iCasesPrev;
	}
	public String getiCasesCurr() {
		return iCasesCurr;
	}
	public void setiCasesCurr(String iCasesCurr) {
		this.iCasesCurr = iCasesCurr;
	}
	public String getiCasesRate() {
		return iCasesRate;
	}
	public void setiCasesRate(String iCasesRate) {
		this.iCasesRate = iCasesRate;
	}
	public String getAllCostPerSpecPrev() {
		return allCostPerSpecPrev;
	}
	public void setAllCostPerSpecPrev(String allCostPerSpecPrev) {
		this.allCostPerSpecPrev = allCostPerSpecPrev;
	}
	public String getAllCostPerSpecCurr() {
		return allCostPerSpecCurr;
	}
	public void setAllCostPerSpecCurr(String allCostPerSpecCurr) {
		this.allCostPerSpecCurr = allCostPerSpecCurr;
	}
	public String getAllCostPerSpecRate() {
		return allCostPerSpecRate;
	}
	public void setAllCostPerSpecRate(String allCostPerSpecRate) {
		this.allCostPerSpecRate = allCostPerSpecRate;
	}
	public String getAllCasesPerSpecPrev() {
		return allCasesPerSpecPrev;
	}
	public void setAllCasesPerSpecPrev(String allCasesPerSpecPrev) {
		this.allCasesPerSpecPrev = allCasesPerSpecPrev;
	}
	public String getAllCasesPerSpecCurr() {
		return allCasesPerSpecCurr;
	}
	public void setAllCasesPerSpecCurr(String allCasesPerSpecCurr) {
		this.allCasesPerSpecCurr = allCasesPerSpecCurr;
	}
	public String getAllCasesPerSpecRate() {
		return allCasesPerSpecRate;
	}
	public void setAllCasesPerSpecRate(String allCasesPerSpecRate) {
		this.allCasesPerSpecRate = allCasesPerSpecRate;
	}
	public String getAllCasesCurr() {
		return allCasesCurr;
	}
	public void setAllCasesCurr(String allCasesCurr) {
		this.allCasesCurr = allCasesCurr;
	}
	public String getAllCasesPrev() {
		return allCasesPrev;
	}
	public void setAllCasesPrev(String allCasesPrev) {
		this.allCasesPrev = allCasesPrev;
	}
	public String getAllCasesRate() {
		return allCasesRate;
	}
	public void setAllCasesRate(String allCasesRate) {
		this.allCasesRate = allCasesRate;
	}
	public String getAllCostCurr() {
		return allCostCurr;
	}
	public void setAllCostCurr(String allCostCurr) {
		this.allCostCurr = allCostCurr;
	}
	public String getAllCostPrev() {
		return allCostPrev;
	}
	public void setAllCostPrev(String allCostPrev) {
		this.allCostPrev = allCostPrev;
	}
	public String getAllCostRate() {
		return allCostRate;
	}
	public void setAllCostRate(String allCostRate) {
		this.allCostRate = allCostRate;
	}
	public String getHospCd() {
		return hospCd;
	}
	public void setHospCd(String hospCd) {
		this.hospCd = hospCd;
	}
	public String getDateYm() {
		return dateYm;
	}
	public void setDateYm(String dateYm) {
		this.dateYm = dateYm;
	}
	public int getTotalCount() {
		return totalCount;
	}
	public void setTotalCount(int totalCount) {
		this.totalCount = totalCount;
	}
	public float getTotalAmt() {
		return totalAmt;
	}
	public void setTotalAmt(float totalAmt) {
		this.totalAmt = totalAmt;
	}
	public int getTotalAvgAmt() {
		return totalAvgAmt;
	}
	public void setTotalAvgAmt(int totalAvgAmt) {
		this.totalAvgAmt = totalAvgAmt;
	}
	public int getIpCount() {
		return ipCount;
	}
	public void setIpCount(int ipCount) {
		this.ipCount = ipCount;
	}
	public int getIpAmt() {
		return ipAmt;
	}
	public void setIpAmt(int ipAmt) {
		this.ipAmt = ipAmt;
	}
	public int getIpAvgAmt() {
		return ipAvgAmt;
	}
	public void setIpAvgAmt(int ipAvgAmt) {
		this.ipAvgAmt = ipAvgAmt;
	}
	public int getOpCount() {
		return opCount;
	}
	public void setOpCount(int opCount) {
		this.opCount = opCount;
	}
	public int getOpAmt() {
		return opAmt;
	}
	public void setOpAmt(int opAmt) {
		this.opAmt = opAmt;
	}
	public int getOpAvgAmt() {
		return opAvgAmt;
	}
	public void setOpAvgAmt(int opAvgAmt) {
		this.opAvgAmt = opAvgAmt;
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
