package egovframework.wnn_medcost.user.model;


public class UserDTO {

	private static final long serialVersionUID = 1L;

	public static long getSerialversionuid() {
		return serialVersionUID;
	}
	private String keyurhospCd;  // 수가코드 (key)
    private String keyuruserId;
	private String keyurstartDt;
	// 기본 필드
    private String hospCd;       // 요양기관
    private String userId;       // 사용자 ID
    private String userNm;       // 사용자 명
    private String startDt;      // 적용시작일자
    private String endDt;        // 적용종료일자
    private String mainGu;       // 관리자구분 (1.위너넷관리자, 2.위너넷사용자, 3.병원관리자, 4.병원사용자)
    private String passWd;       // 사용자비밀번호
    private String afPassWd;        // 변경 후 비밀번호
    private String bfPassWd;        // 변경 전 비밀번호
    private String passCdt;      // 비밀번호 변경일
    private String bigo;         // 비고
    private String winnerYn ;
    // 등록 및 수정 정보
    private String regDttm;      // 등록일시
    private String regUser;      // 등록자
    private String regIp;        // 등록 IP
    private String updDttm;      // 최종변경일시
    private String updUser;      // 최종변경자
    private String updIp;        // 최종변경 IP
    private String email;
    private String userTel;
    private String hospUuid;
    // 기타 필요 필드
    private String hospNm;       // 요양기관명칭
    private String useNot;       // 사용여부 (startDt between endDt then 'Y' else 'N', 등록안된 사용자는 '0')
    
    private String mainGuNm ;
    private String dupchk ;
    
    private String encPassWd;

    private String conactGb ;
	private String useYn ;
	private String mbrJoin  ;   
	private String fileYn ;
	
    public String getFileYn() {
		return fileYn;
	}
	public void setFileYn(String fileYn) {
		this.fileYn = fileYn;
	}
	public String getMbrJoin() {
		return mbrJoin;
	}
    public void setMbrJoin(String mbrJoin) {
		this.mbrJoin = mbrJoin;
	}
    public String getUseYn() {
		return useYn;
	}
	public void setUseYn(String useYn) {
		this.useYn = useYn;
	}    
	public String getConactGb() {
		return conactGb;
	}
	public void setConactGb(String conactGb) {
		this.conactGb = conactGb;
	}
	public String getEncPassWd() {
		return encPassWd;
	}
	public void setEncPassWd(String encPassWd) {
		this.encPassWd = encPassWd;
	}
	public String getDupchk() {
		return dupchk;
	}
	public void setDupchk(String dupchk) {
		this.dupchk = dupchk;
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
	public String getKeyurhospCd() {
		return keyurhospCd;
	}
	public void setKeyurhospCd(String keyurhospCd) {
		this.keyurhospCd = keyurhospCd;
	}
	public String getKeyuruserId() {
		return keyuruserId;
	}
	public void setKeyuruserId(String keyuruserId) {
		this.keyuruserId = keyuruserId;
	}
	public String getKeyurstartDt() {
		return keyurstartDt;
	}
	public void setKeyurstartDt(String keyurstartDt) {
		this.keyurstartDt = keyurstartDt;
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
	public String getHospUuid() {
		return hospUuid;
	}
	public void setHospUuid(String hospUuid) {
		this.hospUuid = hospUuid;
	}
	public String getMainGuNm() {
		return mainGuNm;
	}
	public void setMainGuNm(String mainGuNm) {
		this.mainGuNm = mainGuNm;
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
	public String getPassWd() {
		return passWd;
	}
	public void setPassWd(String passWd) {
		this.passWd = passWd;
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
	public String getHospNm() {
		return hospNm;
	}
	public void setHospNm(String hospNm) {
		this.hospNm = hospNm;
	}
	public String getUseNot() {
		return useNot;
	}
	public void setUseNot(String useNot) {
		this.useNot = useNot;
	}
    
}
