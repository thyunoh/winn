package egovframework.wnn_consult.user.model;
public class HospMdDTO {
	private static final long serialVersionUID = 1L;

	public static long getSerialversionuid() {
		return serialVersionUID;
	}
    // 기본 필드
    private String iud = "";  
    private String iud2 = "";  
    private String year = "";  
    private String month = "";  

    // 병원 정보
    private String hospCd;       // 요양기관번호
    private String hospCd2;     
    private String startYm;      // 적용년월
    private String wardCnt;      // 입원병상수
    private String icuCnt;       // 중환자실 병상수
    private String erCnt;        // 응급실 병상수
    private String docCnt;       // 전문의 수
    private String hospNm;       // 병원명
    private String hospAddr;     // 병원주소
    private String hospCeo;      // 병원대표자
    private String busiNum;      // 사업자등록번호
    private String inacCd;       // 산재기관번호

    // 적용 기간
    private String startDt;      // 적용시작일자
    private String endDt;        // 적용종료일자
    private String useYn;        // 사용여부
    private String sthpNm;       // 통계용 병원명

    // 등록 및 수정 정보
    private String regDttm;      // 등록일시
    private String regUser;      // 등록자
    private String regIp;        // 등록 IP
    private String updDttm;      // 최종변경일시
    private String updUser;      // 최종변경자
    private String updIp;        // 최종변경 IP

    // 기타 병원 정보
    private String joinDt;
    private String acceptDt;
    private String closeDt;
    private String zipCd;
    private String hospTel;
    private String hospFax;
    private String hospExtradr;
    private String hospUuid;
    private String winnerYn;
    private String wnnchk;
    // 추가 필드
    private String name1;
    private String name2;
    private String startDt2;
    private String endDt2;
    private String joinDt2;
    private String acceptDt2;
    private String closeDt2;

	public String getWnnchk() {
		return wnnchk;
	}
	public void setWnnchk(String wnnchk) {
		this.wnnchk = wnnchk;
	}
	public String getIud() {
		return iud;
	}
	public void setIud(String iud) {
		this.iud = iud;
	}
	public String getIud2() {
		return iud2;
	}
	public void setIud2(String iud2) {
		this.iud2 = iud2;
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
	public String getHospCd2() {
		return hospCd2;
	}
	public void setHospCd2(String hospCd2) {
		this.hospCd2 = hospCd2;
	}
	public String getStartYm() {
		return startYm;
	}
	public void setStartYm(String startYm) {
		this.startYm = startYm;
	}
	public String getWardCnt() {
		return wardCnt;
	}
	public void setWardCnt(String wardCnt) {
		this.wardCnt = wardCnt;
	}
	public String getIcuCnt() {
		return icuCnt;
	}
	public void setIcuCnt(String icuCnt) {
		this.icuCnt = icuCnt;
	}
	public String getErCnt() {
		return erCnt;
	}
	public void setErCnt(String erCnt) {
		this.erCnt = erCnt;
	}
	public String getDocCnt() {
		return docCnt;
	}
	public void setDocCnt(String docCnt) {
		this.docCnt = docCnt;
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
	public String getInacCd() {
		return inacCd;
	}
	public void setInacCd(String inacCd) {
		this.inacCd = inacCd;
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
	public String getSthpNm() {
		return sthpNm;
	}
	public void setSthpNm(String sthpNm) {
		this.sthpNm = sthpNm;
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
	public String getJoinDt() {
		return joinDt;
	}
	public void setJoinDt(String joinDt) {
		this.joinDt = joinDt;
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
	public String getHospExtradr() {
		return hospExtradr;
	}
	public void setHospExtradr(String hospExtradr) {
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
	public String getAcceptDt2() {
		return acceptDt2;
	}
	public void setAcceptDt2(String acceptDt2) {
		this.acceptDt2 = acceptDt2;
	}
	public String getCloseDt2() {
		return closeDt2;
	}
	public void setCloseDt2(String closeDt2) {
		this.closeDt2 = closeDt2;
	}
	
	
}
