package egovframework.wnn_medcost.user.model;


public class MembrDTO {

	private static final long serialVersionUID = 1L;

	public static long getSerialversionuid() {
		return serialVersionUID;
	}
	private String keyhospCd;  // 수가코드 (key)
    private String keyemail;
    private String hospCd;        // 병원코드
    private String email;         // 이메일
    private String hospNm;        // 병원명
    private String passWd;        // 패스워드
    private String mbrNm;         // 담당자명
    private String jobNm;         // 직위명
    private String mbrTel;        // 담당자전화번호
    private String userId;
    private String useYn;
    private String perUseCd;      // 이용약관동의코드
    private String perUseRed;     // 세부내용READING
    private String perUseYn;      // 이용약관동의
    private String perInfoCd;     // 수집 및 이용 동의코드
    private String perInfoRed;    // 세부내용READING
    private String perInfoYn;     // 개인정보 수집 및 이용 동의
    private String perProCd;      // 개인정보 처리위탁코드
    private String perProRed;     // 세부내용READING
    private String perProYn;      // 개인정보 처리위탁
    private String hospUuid;
    private String joinDt;        // 가입일자 (yyyyMMdd 형식)
    private String regDttm;
    private String regUser;
    private String regIp;
    private String updDttm;
    private String updUser;
    private String updIp;
    private String findData ;

	public String getFindData() {
		return findData;
	}
	public void setFindData(String findData) {
		this.findData = findData;
	}
	public String getKeyhospCd() {
		return keyhospCd;
	}
	public void setKeyhospCd(String keyhospCd) {
		this.keyhospCd = keyhospCd;
	}
	public String getKeyemail() {
		return keyemail;
	}
	public void setKeyemail(String keyemail) {
		this.keyemail = keyemail;
	}
	public String getHospCd() {
		return hospCd;
	}
	public void setHospCd(String hospCd) {
		this.hospCd = hospCd;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getHospNm() {
		return hospNm;
	}
	public void setHospNm(String hospNm) {
		this.hospNm = hospNm;
	}
	public String getPassWd() {
		return passWd;
	}
	public void setPassWd(String passWd) {
		this.passWd = passWd;
	}
	public String getMbrNm() {
		return mbrNm;
	}
	public void setMbrNm(String mbrNm) {
		this.mbrNm = mbrNm;
	}
	public String getJobNm() {
		return jobNm;
	}
	public void setJobNm(String jobNm) {
		this.jobNm = jobNm;
	}
	public String getMbrTel() {
		return mbrTel;
	}
	public void setMbrTel(String mbrTel) {
		this.mbrTel = mbrTel;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public String getUseYn() {
		return useYn;
	}
	public void setUseYn(String useYn) {
		this.useYn = useYn;
	}
	public String getPerUseCd() {
		return perUseCd;
	}
	public void setPerUseCd(String perUseCd) {
		this.perUseCd = perUseCd;
	}
	public String getPerUseRed() {
		return perUseRed;
	}
	public void setPerUseRed(String perUseRed) {
		this.perUseRed = perUseRed;
	}
	public String getPerUseYn() {
		return perUseYn;
	}
	public void setPerUseYn(String perUseYn) {
		this.perUseYn = perUseYn;
	}
	public String getPerInfoCd() {
		return perInfoCd;
	}
	public void setPerInfoCd(String perInfoCd) {
		this.perInfoCd = perInfoCd;
	}
	public String getPerInfoRed() {
		return perInfoRed;
	}
	public void setPerInfoRed(String perInfoRed) {
		this.perInfoRed = perInfoRed;
	}
	public String getPerInfoYn() {
		return perInfoYn;
	}
	public void setPerInfoYn(String perInfoYn) {
		this.perInfoYn = perInfoYn;
	}
	public String getPerProCd() {
		return perProCd;
	}
	public void setPerProCd(String perProCd) {
		this.perProCd = perProCd;
	}
	public String getPerProRed() {
		return perProRed;
	}
	public void setPerProRed(String perProRed) {
		this.perProRed = perProRed;
	}
	public String getPerProYn() {
		return perProYn;
	}
	public void setPerProYn(String perProYn) {
		this.perProYn = perProYn;
	}
	public String getHospUuid() {
		return hospUuid;
	}
	public void setHospUuid(String hospUuid) {
		this.hospUuid = hospUuid;
	}
	public String getJoinDt() {
		return joinDt;
	}
	public void setJoinDt(String joinDt) {
		this.joinDt = joinDt;
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
   
}
