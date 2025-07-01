package egovframework.wnn_medcost.user.model;

public class HospGrdDTO {
	private static final long serialVersionUID = 1L;

	public static long getSerialversionuid() {
		return serialVersionUID;
	}
    // Key Fields
    private String keyhospCd;     // 병원코드 (key)
    private String keystartYy;    // 년도 (key)
    private String keyqterFlag;      // 분기 (key)
    
    private String hospCd;
    private String hospNm;
    private String startYy;
    private String qterFlag;
    private String jobSeq;

    private String nurGrd;
    private String nurPatCnt;
    private String nurCnt;
    private String nurSubCnt;
    private String patNurNumr;
    private String patNurCnt;
    private String nurNurMumr;

    private String docGrd;
    private String docPatCnt;
    private String docCnt;
    private String patDocCnt;
    private String sdocCnt;
    private String sdocDocCnt;

    private String needGa;
    private String needPat;
    private String needPham;
    private String needInfo;
    private String needRad;
    private String needLab;
    private String needTher;
    private String needSoci;

    private String actionYn;
    private String regDttm;
    private String regUser;
    private String regIp;
    private String updDttm;
    private String updUser;
    private String updIp;
    private String hospgrade;
    private String patCount;
    private String docCount;
    private String nurCount;
    private String nurSCnt;
    private String phamDays;
    private String totalDay;
    private String goalScore ;
    private String goalName ;


	public String getHospNm() {
		return hospNm;
	}

	public void setHospNm(String hospNm) {
		this.hospNm = hospNm;
	}

	public String getGoalScore() {
		return goalScore;
	}

	public void setGoalScore(String goalScore) {
		this.goalScore = goalScore;
	}

	public String getGoalName() {
		return goalName;
	}

	public void setGoalName(String goalName) {
		this.goalName = goalName;
	}

	public String getHospgrade() {
		return hospgrade;
	}

	public void setHospgrade(String hospgrade) {
		this.hospgrade = hospgrade;
	}

	public String getPatCount() {
		return patCount;
	}

	public void setPatCount(String patCount) {
		this.patCount = patCount;
	}

	public String getDocCount() {
		return docCount;
	}

	public void setDocCount(String docCount) {
		this.docCount = docCount;
	}

	public String getNurCount() {
		return nurCount;
	}

	public void setNurCount(String nurCount) {
		this.nurCount = nurCount;
	}

	public String getNurSCnt() {
		return nurSCnt;
	}

	public void setNurSCnt(String nurSCnt) {
		this.nurSCnt = nurSCnt;
	}

	public String getPhamDays() {
		return phamDays;
	}

	public void setPhamDays(String phamDays) {
		this.phamDays = phamDays;
	}

	public String getTotalDay() {
		return totalDay;
	}

	public void setTotalDay(String totalDay) {
		this.totalDay = totalDay;
	}
	private transient String findData; // MyBatis에서 매핑되지 않도록 설정

	public String getKeyqterFlag() {
		return keyqterFlag;
	}

	public void setKeyqterFlag(String keyqterFlag) {
		this.keyqterFlag = keyqterFlag;
	}

	public String getQterFlag() {
		return qterFlag;
	}

	public void setQterFlag(String qterFlag) {
		this.qterFlag = qterFlag;
	}

	public String getKeyhospCd() {
		return keyhospCd;
	}

	public void setKeyhospCd(String keyhospCd) {
		this.keyhospCd = keyhospCd;
	}

	public String getKeystartYy() {
		return keystartYy;
	}

	public void setKeystartYy(String keystartYy) {
		this.keystartYy = keystartYy;
	}


	public String getHospCd() {
		return hospCd;
	}

	public void setHospCd(String hospCd) {
		this.hospCd = hospCd;
	}

	public String getStartYy() {
		return startYy;
	}

	public void setStartYy(String startYy) {
		this.startYy = startYy;
	}


	public String getJobSeq() {
		return jobSeq;
	}

	public void setJobSeq(String jobSeq) {
		this.jobSeq = jobSeq;
	}

	public String getNurGrd() {
		return nurGrd;
	}

	public void setNurGrd(String nurGrd) {
		this.nurGrd = nurGrd;
	}

	public String getNurPatCnt() {
		return nurPatCnt;
	}

	public void setNurPatCnt(String nurPatCnt) {
		this.nurPatCnt = nurPatCnt;
	}

	public String getNurCnt() {
		return nurCnt;
	}

	public void setNurCnt(String nurCnt) {
		this.nurCnt = nurCnt;
	}

	public String getNurSubCnt() {
		return nurSubCnt;
	}

	public void setNurSubCnt(String nurSubCnt) {
		this.nurSubCnt = nurSubCnt;
	}

	public String getPatNurNumr() {
		return patNurNumr;
	}

	public void setPatNurNumr(String patNurNumr) {
		this.patNurNumr = patNurNumr;
	}

	public String getPatNurCnt() {
		return patNurCnt;
	}

	public void setPatNurCnt(String patNurCnt) {
		this.patNurCnt = patNurCnt;
	}

	public String getNurNurMumr() {
		return nurNurMumr;
	}

	public void setNurNurMumr(String nurNurMumr) {
		this.nurNurMumr = nurNurMumr;
	}

	public String getDocGrd() {
		return docGrd;
	}

	public void setDocGrd(String docGrd) {
		this.docGrd = docGrd;
	}

	public String getDocPatCnt() {
		return docPatCnt;
	}

	public void setDocPatCnt(String docPatCnt) {
		this.docPatCnt = docPatCnt;
	}

	public String getDocCnt() {
		return docCnt;
	}

	public void setDocCnt(String docCnt) {
		this.docCnt = docCnt;
	}

	public String getPatDocCnt() {
		return patDocCnt;
	}

	public void setPatDocCnt(String patDocCnt) {
		this.patDocCnt = patDocCnt;
	}

	public String getSdocCnt() {
		return sdocCnt;
	}

	public void setSdocCnt(String sdocCnt) {
		this.sdocCnt = sdocCnt;
	}

	public String getSdocDocCnt() {
		return sdocDocCnt;
	}

	public void setSdocDocCnt(String sdocDocCnt) {
		this.sdocDocCnt = sdocDocCnt;
	}

	public String getNeedGa() {
		return needGa;
	}

	public void setNeedGa(String needGa) {
		this.needGa = needGa;
	}

	public String getNeedPat() {
		return needPat;
	}

	public void setNeedPat(String needPat) {
		this.needPat = needPat;
	}

	public String getNeedPham() {
		return needPham;
	}

	public void setNeedPham(String needPham) {
		this.needPham = needPham;
	}

	public String getNeedInfo() {
		return needInfo;
	}

	public void setNeedInfo(String needInfo) {
		this.needInfo = needInfo;
	}

	public String getNeedRad() {
		return needRad;
	}

	public void setNeedRad(String needRad) {
		this.needRad = needRad;
	}

	public String getNeedLab() {
		return needLab;
	}

	public void setNeedLab(String needLab) {
		this.needLab = needLab;
	}

	public String getNeedTher() {
		return needTher;
	}

	public void setNeedTher(String needTher) {
		this.needTher = needTher;
	}

	public String getNeedSoci() {
		return needSoci;
	}

	public void setNeedSoci(String needSoci) {
		this.needSoci = needSoci;
	}

	public String getActionYn() {
		return actionYn;
	}

	public void setActionYn(String actionYn) {
		this.actionYn = actionYn;
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
