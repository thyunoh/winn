package egovframework.wnn_medcost.magam.model;

public class PatvalDTO {

	private static final long serialVersionUID = 1L;

	public static long getSerialversionuid() {
		return serialVersionUID;
	}
	
	private String hospCd; 	    	// 요양기관번호
	private String jobYymm;         // 작업년월
	private String regDttm;			// 등록일시
	private String regUser;    		// 등록자
	private String regIp;	    	// 등록 ip
	private String updDttm;			// 최종변경일시
	private String updUser;			// 최종변경자
	private String updIp;	    	// 최종변경 ip
	
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
	
	private String dangerHi;       	// 고위험
	private String dangerLow;       // 저위험
	private String dressingYn;      // 처치여부
	
	private String cateCd;          // 지표코드
	private String mainDiagCd;      // 주진단
	private String psyOrderYn;      // 항정처방여부
	
	private String curtStep1;       // 당월 욕창1단계
	private String curtStep2;
	private String curtStep3;
	private String curtStep4;
	private String prevStep1;       // 전월 욕창1단계
	private String prevStep2;
	private String prevStep3;
	private String prevStep4;
	
	private String preRelDev;      // 압력을 줄여주는 도구 사용 
	private String posChange;      // 체위변경
	private String nutSupply;      // 피부문제를 해결하기 위한 영양공급
	private String skinDress;      // 피부궤양 드레싱
	
	private String nextTarget;     // 다음월 대상
	
	private String improveYn;      // 개선여부
	
	private String cPatClass;      // 환자군 (당월)
	private String cAdlScore;      // ADL점수 (당월)
	private String pPatClass;      // 환자군 (전월)
	private String pAdl10Val;      // 10개
	private String pAdlScore;      // ADL점수 (전월)
	
	
	private String diabeYn;        // 당뇨여부 
	private String hba1cYn;        // hba1c 검사여부
	private String examiDt;        // 검사일자
	private String eResult;        // 검사결과
	private String approYn;        // 적정여부
	private String preDiag;        // 전월상병(당뇨)
	private String longAdm;        // 180이상 장기입원
	
	private String dangerPm;       	// 위험(전월)
	private String dangerCm;       	// 위험(당월)
	
	private String errType;         // 오류점검 Type
	private String errName;         // 오류내용 
	private String jobFlag;         // 작업구분 
	
	private String overDay;         // 14일 초과 
	private String indwellCath;         // 유치도뇨관 
	
	private String useYn;           // 사용여부
	
	private String heigYn;      // 피부궤양 드레싱
	
	private String weig;
	
	public String getWeig() {
		return weig;
	}
	public void setWeig(String weig) {
		this.weig = weig;
	}
	public String getIndwellCath() {
		return indwellCath;
	}
	public void setIndwellCath(String indwellCath) {
		this.indwellCath = indwellCath;
	}
	public String getUseYn() {
		return useYn;
	}
	public void setUseYn(String useYn) {
		this.useYn = useYn;
	}
	
	public String getErrName() {
		return errName;
	}
	public void setErrName(String errName) {
		this.errName = errName;
	}
	public String getOverDay() {
		return overDay;
	}
	public void setOverDay(String overDay) {
		this.overDay = overDay;
	}
	public String getJobFlag() {
		return jobFlag;
	}
	public void setJobFlag(String jobFlag) {
		this.jobFlag = jobFlag;
	}
	public String getErrType() {
		return errType;
	}
	public void setErrType(String errType) {
		this.errType = errType;
	}
	public String getDangerPm() {
		return dangerPm;
	}
	public void setDangerPm(String dangerPm) {
		this.dangerPm = dangerPm;
	}
	public String getDangerCm() {
		return dangerCm;
	}
	public void setDangerCm(String dangerCm) {
		this.dangerCm = dangerCm;
	}
	public String getLongAdm() {
		return longAdm;
	}
	public void setLongAdm(String longAdm) {
		this.longAdm = longAdm;
	}
	public String getPreDiag() {
		return preDiag;
	}
	public void setPreDiag(String preDiag) {
		this.preDiag = preDiag;
	}
	public String getDiabeYn() {
		return diabeYn;
	}
	public void setDiabeYn(String diabeYn) {
		this.diabeYn = diabeYn;
	}
	public String getHba1cYn() {
		return hba1cYn;
	}
	public void setHba1cYn(String hba1cYn) {
		this.hba1cYn = hba1cYn;
	}
	public String getExamiDt() {
		return examiDt;
	}
	public void setExamiDt(String examiDt) {
		this.examiDt = examiDt;
	}
	public String geteResult() {
		return eResult;
	}
	public void seteResult(String eResult) {
		this.eResult = eResult;
	}
	public String getApproYn() {
		return approYn;
	}
	public void setApproYn(String approYn) {
		this.approYn = approYn;
	}
	public String getpAdl10Val() {
		return pAdl10Val;
	}
	public void setpAdl10Val(String pAdl10Val) {
		this.pAdl10Val = pAdl10Val;
	}
	public String getcPatClass() {
		return cPatClass;
	}
	public void setcPatClass(String cPatClass) {
		this.cPatClass = cPatClass;
	}
	public String getcAdlScore() {
		return cAdlScore;
	}
	public void setcAdlScore(String cAdlScore) {
		this.cAdlScore = cAdlScore;
	}
	public String getpPatClass() {
		return pPatClass;
	}
	public void setpPatClass(String pPatClass) {
		this.pPatClass = pPatClass;
	}
	public String getpAdlScore() {
		return pAdlScore;
	}
	public void setpAdlScore(String pAdlScore) {
		this.pAdlScore = pAdlScore;
	}
	public String getImproveYn() {
		return improveYn;
	}
	public void setImproveYn(String improveYn) {
		this.improveYn = improveYn;
	}
	public String getNextTarget() {
		return nextTarget;
	}
	public void setNextTarget(String nextTarget) {
		this.nextTarget = nextTarget;
	}
	public String getCurtStep1() {
		return curtStep1;
	}
	public void setCurtStep1(String curtStep1) {
		this.curtStep1 = curtStep1;
	}
	public String getCurtStep2() {
		return curtStep2;
	}
	public void setCurtStep2(String curtStep2) {
		this.curtStep2 = curtStep2;
	}
	public String getCurtStep3() {
		return curtStep3;
	}
	public void setCurtStep3(String curtStep3) {
		this.curtStep3 = curtStep3;
	}
	public String getCurtStep4() {
		return curtStep4;
	}
	public void setCurtStep4(String curtStep4) {
		this.curtStep4 = curtStep4;
	}
	public String getPrevStep1() {
		return prevStep1;
	}
	public void setPrevStep1(String prevStep1) {
		this.prevStep1 = prevStep1;
	}
	public String getPrevStep2() {
		return prevStep2;
	}
	public void setPrevStep2(String prevStep2) {
		this.prevStep2 = prevStep2;
	}
	public String getPrevStep3() {
		return prevStep3;
	}
	public void setPrevStep3(String prevStep3) {
		this.prevStep3 = prevStep3;
	}
	public String getPrevStep4() {
		return prevStep4;
	}
	public void setPrevStep4(String prevStep4) {
		this.prevStep4 = prevStep4;
	}
	public String getPreRelDev() {
		return preRelDev;
	}
	public void setPreRelDev(String preRelDev) {
		this.preRelDev = preRelDev;
	}
	public String getPosChange() {
		return posChange;
	}
	public void setPosChange(String posChange) {
		this.posChange = posChange;
	}
	public String getNutSupply() {
		return nutSupply;
	}
	public void setNutSupply(String nutSupply) {
		this.nutSupply = nutSupply;
	}
	public String getSkinDress() {
		return skinDress;
	}
	public void setSkinDress(String skinDress) {
		this.skinDress = skinDress;
	}

	
	public String getHeigYn() {
		return heigYn;
	}
	public void setHeigYn(String heigYn) {
		this.heigYn = heigYn;
	}

	public String getMainDiagCd() {
		return mainDiagCd;
	}
	public void setMainDiagCd(String mainDiagCd) {
		this.mainDiagCd = mainDiagCd;
	}
	public String getPsyOrderYn() {
		return psyOrderYn;
	}
	public void setPsyOrderYn(String psyOrderYn) {
		this.psyOrderYn = psyOrderYn;
	}
	public String getCateCd() {
		return cateCd;
	}
	public void setCateCd(String cateCd) {
		this.cateCd = cateCd;
	}
	public String getHospCd() {
		return hospCd;
	}
	public void setHospCd(String hospCd) {
		this.hospCd = hospCd;
	}
	
	public String getJobYymm() {
		return jobYymm;
	}
	public void setJobYymm(String jobYymm) {
		this.jobYymm = jobYymm;
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
	public String getEvalType() {
		return evalType;
	}
	public void setEvalType(String evalType) {
		this.evalType = evalType;
	}
	public String getAdlScore() {
		return adlScore;
	}
	public void setAdlScore(String adlScore) {
		this.adlScore = adlScore;
	}
	public String getDangerHi() {
		return dangerHi;
	}
	public void setDangerHi(String dangerHi) {
		this.dangerHi = dangerHi;
	}
	public String getDangerLow() {
		return dangerLow;
	}
	public void setDangerLow(String dangerLow) {
		this.dangerLow = dangerLow;
	}
	public String getDressingYn() {
		return dressingYn;
	}
	public void setDressingYn(String dressingYn) {
		this.dressingYn = dressingYn;
	}
	
	
}
