package egovframework.wnn_consult.user.model;

public class UserDTO{

	private static final long serialVersionUID = 1L;

	public static long getSerialversionuid() {
		return serialVersionUID;
	}
	
	 // 기본 필드
    private String hospCd;          // 요양기관
    private String userId;          // 사용자 ID
    private String afPassWd;        // 변경 후 비밀번호
    private String bfPassWd;        // 변경 전 비밀번호
    private String passWd;          // 사용자 비밀번호

    // 비교 대상 (이전 데이터)
    private String hospCd1;         
    private String userId1;         
    private String afPassWd1;       
    private String bfPassWd1;       
    private String passWd1;         

    private String userNm;          // 사용자 명
    private String startDt;         // 적용시작일자
    private String endDt;           // 적용종료일자
    private String mainGu;          // 관리자구분 (1.위너넷관리자, 2.위너넷사용자, 3.병원관리자, 4.병원사용자)
    private String passCdt;         // 비밀번호 변경일
    private String bigo;            // 비고

    // 등록 및 수정 정보
    private String regDttm;         // 등록일시
    private String regUser;         // 등록자
    private String regIp;           // 등록 IP
    private String updDttm;         // 최종변경일시
    private String updUser;         // 최종변경자
    private String updIp;           // 최종변경 IP

    // 기타 필드
    private String encPassWd;       // 암호화된 비밀번호
    private String useYn;           // 사용 여부
    private String hospUuid;        
    private String hospUuid1;       
    
    private String winnerYn;  
    private String lastCondttm ; 
    private String lastConuser ; 
    
    private String email;           
    private String userTel;          //1 사용자 전화번호
	private String hospNm ;
    private String useNot ;
    private String conactGb ;
    private String fileYn ;
    private String insAuth ;
    private String updAuth ;
    private String delAuth ;
    private String inqAuth ;
    private String month3;
    private String month2;
    private String month1;
 
    public String getMonth3() {
		return month3;
	}
	public void setMonth3(String month3) {
		this.month3 = month3;
	}
	public String getMonth2() {
		return month2;
	}
	public void setMonth2(String month2) {
		this.month2 = month2;
	}
	public String getMonth1() {
		return month1;
	}
	public void setMonth1(String month1) {
		this.month1 = month1;
	}
	public String getLastCondttm() {
		return lastCondttm;
	}
	public void setLastCondttm(String lastCondttm) {
		this.lastCondttm = lastCondttm;
	}
	public String getLastConuser() {
		return lastConuser;
	}
	public void setLastConuser(String lastConuser) {
		this.lastConuser = lastConuser;
	}
	public String getInsAuth() {
		return insAuth;
	}
	public void setInsAuth(String insAuth) {
		this.insAuth = insAuth;
	}
	public String getUpdAuth() {
		return updAuth;
	}
	public void setUpdAuth(String updAuth) {
		this.updAuth = updAuth;
	}
	public String getDelAuth() {
		return delAuth;
	}
	public void setDelAuth(String delAuth) {
		this.delAuth = delAuth;
	}
	public String getInqAuth() {
		return inqAuth;
	}
	public void setInqAuth(String inqAuth) {
		this.inqAuth = inqAuth;
	}
	public String getFileYn() {
		return fileYn;
	}
	public void setFileYn(String fileYn) {
		this.fileYn = fileYn;
	}
	public String getConactGb() {
		return conactGb;
	}
	public void setConactGb(String conactGb) {
		this.conactGb = conactGb;
	}
	public String getUseNot() {
		return useNot;
	}
	public void setUseNot(String useNot) {
		this.useNot = useNot;
	}
	public String getHospNm() {
		return hospNm;
	}
	public void setHospNm(String hospNm) {
		this.hospNm = hospNm;
	}

    
	public String getHospCd() {
		return hospCd;
	}
	public void setHospCd(String hospCd) {
		this.hospCd = hospCd;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public String getAfPassWd() {
		return afPassWd;
	}
	public void setAfPassWd(String afPassWd) {
		this.afPassWd = afPassWd;
	}
	public String getBfPassWd() {
		return bfPassWd;
	}
	public void setBfPassWd(String bfPassWd) {
		this.bfPassWd = bfPassWd;
	}
	public String getPassWd() {
		return passWd;
	}
	public void setPassWd(String passWd) {
		this.passWd = passWd;
	}
	public String getHospCd1() {
		return hospCd1;
	}
	public void setHospCd1(String hospCd1) {
		this.hospCd1 = hospCd1;
	}
	public String getUserId1() {
		return userId1;
	}
	public void setUserId1(String userId1) {
		this.userId1 = userId1;
	}
	public String getAfPassWd1() {
		return afPassWd1;
	}
	public void setAfPassWd1(String afPassWd1) {
		this.afPassWd1 = afPassWd1;
	}
	public String getBfPassWd1() {
		return bfPassWd1;
	}
	public void setBfPassWd1(String bfPassWd1) {
		this.bfPassWd1 = bfPassWd1;
	}
	public String getPassWd1() {
		return passWd1;
	}
	public void setPassWd1(String passWd1) {
		this.passWd1 = passWd1;
	}
	public String getUserNm() {
		return userNm;
	}
	public void setUserNm(String userNm) {
		this.userNm = userNm;
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
	public String getMainGu() {
		return mainGu;
	}
	public void setMainGu(String mainGu) {
		this.mainGu = mainGu;
	}
	public String getPassCdt() {
		return passCdt;
	}
	public void setPassCdt(String passCdt) {
		this.passCdt = passCdt;
	}
	public String getBigo() {
		return bigo;
	}
	public void setBigo(String bigo) {
		this.bigo = bigo;
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
	public String getEncPassWd() {
		return encPassWd;
	}
	public void setEncPassWd(String encPassWd) {
		this.encPassWd = encPassWd;
	}
	public String getUseYn() {
		return useYn;
	}
	public void setUseYn(String useYn) {
		this.useYn = useYn;
	}
	public String getHospUuid() {
		return hospUuid;
	}
	public void setHospUuid(String hospUuid) {
		this.hospUuid = hospUuid;
	}
	public String getHospUuid1() {
		return hospUuid1;
	}
	public void setHospUuid1(String hospUuid1) {
		this.hospUuid1 = hospUuid1;
	}
	public String getWinnerYn() {
		return winnerYn;
	}
	public void setWinnerYn(String winnerYn) {
		this.winnerYn = winnerYn;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getUserTel() {
		return userTel;
	}
	public void setUserTel(String userTel) {
		this.userTel = userTel;
	}
    
}
