package egovframework.wnn_medcost.user.model;


public class HospMdDTO {
	private static final long serialVersionUID = 1L;

	public static long getSerialversionuid() {
		return serialVersionUID;
	}
	private String keyHospCd;  // 수가코드 (key)
	private String findData;
	private String wnnchk = ""; 
	private String year = "";    
	private String month = "";   
	private String hospCd; // 요양기관번호
	private String startYm; // 적용년월
	private String wardcnt; // 입원병상수
	private String icucnt; // 중환자실 병상수
	private String ercnt; // 응급실 병상수
	private String doccnt; // 전문의 수
	private String hospNm; // 병원명
	private String hospAddr; // 병원주소
	private String hospCeo; // 병원대표자
	private String busiNum; // 사업자등록번호
	private String inaccd; // 산재기관번호
	private String startDt; // 적용시작일자
	private String endDt; // 적용종료일자
	private String useYn; // 사용여부
	private String sthpnm; // 통계용 병원명
	private String regDttm; // 등록일시
	private String regUser; // 등록자
	private String regIp; // 등록 IP
	private String updDttm; // 최종변경일시
	private String updUser; // 최종변경자
	private String updIp; // 최종변경 IP
	private String acceptDt;
	private String closeDt;
	private String joinDt;
	private String zipCd;
	private String hospTel;
	private String hospFax;
	private String hospExtradr;
	private String hospUuid;
	private String winnerYn;

	private String name1;
	private String startDt1;
	private String endDt1;
	private String joinDt1;
	private String name2;
	private String startDt2;
	private String endDt2;
	private String joinDt2;
	private String fileYn ;
	private String hosGrd ;
	private String conactGb ;
	private	String omtYn;
	private String closeDt1;
	private String closeDt2;
	
    public String getCloseDt1() {
		return closeDt1;
	}
	public void setCloseDt1(String closeDt1) {
		this.closeDt1 = closeDt1;
	}
	
	public String getCloseDt2() {
		return closeDt2;
	}
	public void setCloseDt2(String closeDt2) {
		this.closeDt2 = closeDt2;
	}
	
	public String getOmtYn() {
		return omtYn;
	}
	public void setOmtYn(String omtYn) {
		this.omtYn = omtYn;
	}
	public String getConactGb() {
		return conactGb;
	}
	public void setConactGb(String conactGb) {
		this.conactGb = conactGb;
	}
	public String getHosGrd() {
		return hosGrd;
	}
	public void setHosGrd(String hosGrd) {
		this.hosGrd = hosGrd;
	}
	public String getFileYn() {
		return fileYn;
	}
	public void setFileYn(String fileYn) {
		this.fileYn = fileYn;
	}
	public String getWnnchk() {
		return wnnchk;
	}
	public void setWnnchk(String wnnchk) {
		this.wnnchk = wnnchk;
	}
	public String getHospExtradr() {
		return hospExtradr;
	}
	public void setHospExtradr(String hospExtradr) {
		this.hospExtradr = hospExtradr;
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
	public String getJoinDt1() {
		return joinDt1;
	}
	public void setJoinDt1(String joinDt1) {
		this.joinDt1 = joinDt1;
	}
	public String getKeyHospCd() {
		return keyHospCd;
	}
	public void setKeyHospCd(String keyHospCd) {
		this.keyHospCd = keyHospCd;
	}
	public String getFindData() {
		return findData;
	}
	public void setFindData(String findData) {
		this.findData = findData;
	}
	public String getYear() {
		return year;
	}
	public void setYear(String year) {
		this.year = year;
	}
	public String getMonth() {
		return month;
	}
	public void setMonth(String month) {
		this.month = month;
	}
	public String getHospCd() {
		return hospCd;
	}
	public void setHospCd(String hospCd) {
		this.hospCd = hospCd;
	}
	public String getStartYm() {
		return startYm;
	}
	public void setStartYm(String startYm) {
		this.startYm = startYm;
	}
	public String getWardcnt() {
		return wardcnt;
	}
	public void setWardcnt(String wardcnt) {
		this.wardcnt = wardcnt;
	}
	public String getIcucnt() {
		return icucnt;
	}
	public void setIcucnt(String icucnt) {
		this.icucnt = icucnt;
	}
	public String getErcnt() {
		return ercnt;
	}
	public void setErcnt(String ercnt) {
		this.ercnt = ercnt;
	}
	public String getDoccnt() {
		return doccnt;
	}
	public void setDoccnt(String doccnt) {
		this.doccnt = doccnt;
	}
	public String getHospNm() {
		return hospNm;
	}
	public void setHospNm(String hospNm) {
		this.hospNm = hospNm;
	}
	public String getHospAddr() {
		return hospAddr;
	}
	public void setHospAddr(String hospAddr) {
		this.hospAddr = hospAddr;
	}
	public String getHospCeo() {
		return hospCeo;
	}
	public void setHospCeo(String hospCeo) {
		this.hospCeo = hospCeo;
	}
	public String getBusiNum() {
		return busiNum;
	}
	public void setBusiNum(String busiNum) {
		this.busiNum = busiNum;
	}
	public String getInaccd() {
		return inaccd;
	}
	public void setInaccd(String inaccd) {
		this.inaccd = inaccd;
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
	public String getUseYn() {
		return useYn;
	}
	public void setUseYn(String useYn) {
		this.useYn = useYn;
	}
	public String getSthpnm() {
		return sthpnm;
	}
	public void setSthpnm(String sthpnm) {
		this.sthpnm = sthpnm;
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
	public String getAcceptDt() {
		return acceptDt;
	}
	public void setAcceptDt(String acceptDt) {
		this.acceptDt = acceptDt;
	}
	public String getCloseDt() {
		return closeDt;
	}
	public void setCloseDt(String closeDt) {
		this.closeDt = closeDt;
	}
	public String getJoinDt() {
		return joinDt;
	}
	public void setJoinDt(String joinDt) {
		this.joinDt = joinDt;
	}
	public String getZipCd() {
		return zipCd;
	}
	public void setZipCd(String zipCd) {
		this.zipCd = zipCd;
	}
	public String getHospTel() {
		return hospTel;
	}
	public void setHospTel(String hospTel) {
		this.hospTel = hospTel;
	}
	public String getHospFax() {
		return hospFax;
	}
	public void setHospFax(String hospFax) {
		this.hospFax = hospFax;
	}
	public String getHospExtraDr() {
		return hospExtradr;
	}
	public void setHospExtraDr(String hospExtradr) {
		this.hospExtradr = hospExtradr;
	}
	public String getHospUuid() {
		return hospUuid;
	}
	public void setHospUuid(String hospUuid) {
		this.hospUuid = hospUuid;
	}
	public String getWinnerYn() {
		return winnerYn;
	}
	public void setWinnerYn(String winnerYn) {
		this.winnerYn = winnerYn;
	}
	public String getName1() {
		return name1;
	}
	public void setName1(String name1) {
		this.name1 = name1;
	}
	public String getName2() {
		return name2;
	}
	public void setName2(String name2) {
		this.name2 = name2;
	}
	public String getStartDt2() {
		return startDt2;
	}
	public void setStartDt2(String startDt2) {
		this.startDt2 = startDt2;
	}
	public String getEndDt2() {
		return endDt2;
	}
	public void setEndDt2(String endDt2) {
		this.endDt2 = endDt2;
	}
	public String getJoinDt2() {
		return joinDt2;
	}
	public void setJoinDt2(String joinDt2) {
		this.joinDt2 = joinDt2;
	}

}
