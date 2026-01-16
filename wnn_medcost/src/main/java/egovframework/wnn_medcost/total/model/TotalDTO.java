package egovframework.wnn_medcost.total.model;

public class TotalDTO {
	
	private String hospCd; 	    	// 요양기관번호
	private String regDttm;			// 등록일시
	private String regUser;    		// 등록자
	private String regIp;	    	// 등록 ip
	private String updDttm;			// 최종변경일시
	private String updUser;			// 최종변경자
	private String updIp;	    	// 최종변경 ip
	
	private String makeFg;         	// 제언 01,02,... 
	private String codeFg;         	// 제언 row 위치
	private String workYm;		   	// 작업년월
	
	private String patId;          	// 환자번호
	private String patNm;          	// 환자성명
	private String admitDt;        	// 입원일자
	private String dischDt;        	// 퇴원일자
	private String admitTm;        	// 입원시간
	private String dischTm;        	// 퇴원시간
	
	private String medStart;       	// 개시일자
	private String docDt;          	// 작성일자
	private String patClass;       	// 환자군
	private String evalType;       	// 평가구분
	private String adlScore;       	// ADL점수
	
	private String classUp;        	// 상향대상
	
	private String claimNo;        	// 청구번호
	private String medCovType;     	// 종별구분
	private String claimGrp;       	// 청구구분
	private String billSeq;        	// 명일련번호
	private String totAmt;         	// 요양급여 총액
	private String claimAmt;       	// 청구액
	private String selfAmt;        	// 본인부담
	private String disabledAmt;    	// 장애인진료비
	private String jinDays;        	// 진료일수   				
	private String admDays;        	// 입원일수
	private String myoungFg;       	// 명세서구분
	
	private String ediCode;        	// edi
	private String ediName;        	// edi 명칭
	private String unitAmt;        	// 단가 
	private String dayQtys;        	// 일투  
	private String totDays;        	// 일수 
	private String calcAmt;        	// 계산금액(병원가산포함)
	private String calPrics;       	// 계산금액(단가*수량*일수)
	
	private String jobNote;        // note
	
	private String inspAmt;
	private String inspCode;
	private String mmseVal;
	
	
	public String getMmseVal() {
		return mmseVal;
	}
	public void setMmseVal(String mmseVal) {
		this.mmseVal = mmseVal;
	}
	public String getInspAmt() {
		return inspAmt;
	}
	public void setInspAmt(String inspAmt) {
		this.inspAmt = inspAmt;
	}
	public String getInspCode() {
		return inspCode;
	}
	public void setInspCode(String inspCode) {
		this.inspCode = inspCode;
	}
	public String getJobNote() {
		return jobNote;
	}
	public void setJobNote(String jobNote) {
		this.jobNote = jobNote;
	}
	public String getEdiName() {
		return ediName;
	}
	public void setEdiName(String ediName) {
		this.ediName = ediName;
	}
	public String getCalPrics() {
		return calPrics;
	}
	public void setCalPrics(String calPrics) {
		this.calPrics = calPrics;
	}
	public String getCalcAmt() {
		return calcAmt;
	}
	public void setCalcAmt(String calcAmt) {
		this.calcAmt = calcAmt;
	}
	public String getEdiCode() {
		return ediCode;
	}
	public void setEdiCode(String ediCode) {
		this.ediCode = ediCode;
	}
	public String getUnitAmt() {
		return unitAmt;
	}
	public void setUnitAmt(String unitAmt) {
		this.unitAmt = unitAmt;
	}
	public String getDayQtys() {
		return dayQtys;
	}
	public void setDayQtys(String dayQtys) {
		this.dayQtys = dayQtys;
	}
	public String getTotDays() {
		return totDays;
	}
	public void setTotDays(String totDays) {
		this.totDays = totDays;
	}
	public String getHospCd() {
		return hospCd;
	}
	public void setHospCd(String hospCd) {
		this.hospCd = hospCd;
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
	public String getMakeFg() {
		return makeFg;
	}
	public void setMakeFg(String makeFg) {
		this.makeFg = makeFg;
	}
	public String getCodeFg() {
		return codeFg;
	}
	public void setCodeFg(String codeFg) {
		this.codeFg = codeFg;
	}
	public String getWorkYm() {
		return workYm;
	}
	public void setWorkYm(String workYm) {
		this.workYm = workYm;
	}
	public String getPatId() {
		return patId;
	}
	public void setPatId(String patId) {
		this.patId = patId;
	}
	public String getPatNm() {
		return patNm;
	}
	public void setPatNm(String patNm) {
		this.patNm = patNm;
	}
	public String getAdmitDt() {
		return admitDt;
	}
	public void setAdmitDt(String admitDt) {
		this.admitDt = admitDt;
	}	
	public String getDischDt() {
		return dischDt;
	}
	public void setDischDt(String dischDt) {
		this.dischDt = dischDt;
	}
	
	public String getAdmitTm() {
		return admitTm;
	}
	public void setAdmitTm(String admitTm) {
		this.admitTm = admitTm;
	}
	public String getDischTm() {
		return dischTm;
	}
	public void setDischTm(String dischTm) {
		this.dischTm = dischTm;
	}
	public String getMedStart() {
		return medStart;
	}
	public void setMedStart(String medStart) {
		this.medStart = medStart;
	}
	public String getDocDt() {
		return docDt;
	}
	public void setDocDt(String docDt) {
		this.docDt = docDt;
	}
	public String getPatClass() {
		return patClass;
	}
	public void setPatClass(String patClass) {
		this.patClass = patClass;
	}	
	public String getAdlScore() {
		return adlScore;
	}
	public void setAdlScore(String adlScore) {
		this.adlScore = adlScore;
	}
	public String getEvalType() {
		return evalType;
	}
	public void setEvalType(String evalType) {
		this.evalType = evalType;
	}
	public String getClassUp() {
		return classUp;
	}
	public void setClassUp(String classUp) {
		this.classUp = classUp;
	}
	public String getClaimNo() {
		return claimNo;
	}
	public void setClaimNo(String claimNo) {
		this.claimNo = claimNo;
	}
	public String getMedCovType() {
		return medCovType;
	}
	public void setMedCovType(String medCovType) {
		this.medCovType = medCovType;
	}
	public String getClaimGrp() {
		return claimGrp;
	}
	public void setClaimGrp(String claimGrp) {
		this.claimGrp = claimGrp;
	}
	public String getBillSeq() {
		return billSeq;
	}
	public void setBillSeq(String billSeq) {
		this.billSeq = billSeq;
	}
	public String getTotAmt() {
		return totAmt;
	}
	public void setTotAmt(String totAmt) {
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
	public String getDisabledAmt() {
		return disabledAmt;
	}
	public void setDisabledAmt(String disabledAmt) {
		this.disabledAmt = disabledAmt;
	}
	public String getJinDays() {
		return jinDays;
	}
	public void setJinDays(String jinDays) {
		this.jinDays = jinDays;
	}
	public String getAdmDays() {
		return admDays;
	}
	public void setAdmDays(String admDays) {
		this.admDays = admDays;
	}
	public String getMyoungFg() {
		return myoungFg;
	}
	public void setMyoungFg(String myoungFg) {
		this.myoungFg = myoungFg;
	}

}
