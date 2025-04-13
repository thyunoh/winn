package egovframework.wnn_consult.user.model;
public class MberDTO {
	private static final long serialVersionUID = 1L;

	public static long getSerialversionuid() {
		return serialVersionUID;
	}
    // 기본 필드
    private String iud = "";  
    private String email;         // 이메일
    private String hospCd;        // 병원코드
    private String hospNm;        // 병원명
    private String passWd;        // 패스워드
    private String afPassWd;  
    private String mbrNm;         // 담당자명
    private String jobNm;         // 직책명
    private String mbrTel;        // 담당자 전화번호

    // 이용약관 및 개인정보 동의
    private String perUseCd;      // 이용약관코드
    private String perUseRed;  
    private String perUseYn;      // 이용약관 동의
    private String perInfoCd;     // 개인정보 수집 및 이용 동의코드
    private String perInfoRed;  
    private String perInfoYn;     // 개인정보 수집 및 이용 동의
    private String perProCd;      // 개인정보 처리위탁코드
    private String perProRed;  
    private String perProYn;      // 개인정보 처리위탁

    // 등록 및 수정 정보
    private String joinDt;        // 가입일자
    private String regDttm;       // 등록일시
    private String regUser;       // 등록 사용자
    private String regIp;         // 등록 IP
    private String updDttm;       // 수정일시
    private String updUser;       // 수정 사용자
    private String updIp;         // 수정 IP

    // 기타 필드
    private String useYn;
    private String userId;
    private String perUseNm;      // 이용약관명
    private String perInfoNm;     // 개인정보 수집 및 이용 명칭
    private String perProNm;      // 개인정보 처리위탁 명칭
    private String hospUuid;  

    // 추가 필드
    private String subNm;      
    private String startDt;     
    private String endDt;   

    private String subNm1;      
    private String startDt1;     
    private String endDt1;

	public String getIud() {
		return iud;
	}
	public void setIud(String iud) {
		this.iud = iud;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getHospCd() {
		return hospCd;
	}
	public void setHospCd(String hospCd) {
		this.hospCd = hospCd;
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
	public String getAfPassWd() {
		return afPassWd;
	}
	public void setAfPassWd(String afPassWd) {
		this.afPassWd = afPassWd;
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
	public String getUseYn() {
		return useYn;
	}
	public void setUseYn(String useYn) {
		this.useYn = useYn;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public String getPerUseNm() {
		return perUseNm;
	}
	public void setPerUseNm(String perUseNm) {
		this.perUseNm = perUseNm;
	}
	public String getPerInfoNm() {
		return perInfoNm;
	}
	public void setPerInfoNm(String perInfoNm) {
		this.perInfoNm = perInfoNm;
	}
	public String getPerProNm() {
		return perProNm;
	}
	public void setPerProNm(String perProNm) {
		this.perProNm = perProNm;
	}
	public String getHospUuid() {
		return hospUuid;
	}
	public void setHospUuid(String hospUuid) {
		this.hospUuid = hospUuid;
	}
	public String getSubNm() {
		return subNm;
	}
	public void setSubNm(String subNm) {
		this.subNm = subNm;
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
	public String getSubNm1() {
		return subNm1;
	}
	public void setSubNm1(String subNm1) {
		this.subNm1 = subNm1;
	}
	public String getStartDt1() {
		return startDt1;
	}
	public void setStartDt1(String startDt1) {
		this.startDt1 = startDt1;
	}
	public String getEndDt1() {
		return endDt1;
	}
	public void setEndDt1(String endDt1) {
		this.endDt1 = endDt1;
	}  
    
}