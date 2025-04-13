package egovframework.wnn_consult.mangr.model;
public class NotiDTO {
	private static final long serialVersionUID = 1L;

	public static long getSerialversionuid() {
		return serialVersionUID;
	}
    // 기본 필드
    private String iud = "";    
    private String notiSeq;       // 작성순서
    private String fileGb;        // 공지사항('1'), 심사방('2'), 소식지('3')
    private String startDt;       // 공지 시작일자
    private String endDt;         // 공지 종료일자
    private String useYn;         // 사용여부
    private String hospCd;        // 요양기관(특정병원에만 올릴경우)
    private String notiTitle;     // 공지 제목
    private String notiContent;   // 공지 세부내용
    private String updateSw;      // 등록 구분
    private String notiRedcnt;    // 읽기 카운트

    // 등록 및 수정 정보
    private String regDttm;       // 등록 일시
    private String regUser;       // 등록자
    private String regIp;         // 등록 IP
    private String updDttm;       // 최종 변경 일시
    private String updUser;       // 최종 변경자
    private String updIp;         // 최종 변경 IP

    // 검색 및 기타 필드
    private String searchText;
    private String startDate;
    private String endDate;
    private String userNm;
    private String subCodeNm;
    private String notiNm;
    private String hospUuid;
    private String subquery;

	public String getIud() {
		return iud;
	}
	public void setIud(String iud) {
		this.iud = iud;
	}
	public String getNotiSeq() {
		return notiSeq;
	}
	public void setNotiSeq(String notiSeq) {
		this.notiSeq = notiSeq;
	}
	public String getFileGb() {
		return fileGb;
	}
	public void setFileGb(String fileGb) {
		this.fileGb = fileGb;
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
	public String getHospCd() {
		return hospCd;
	}
	public void setHospCd(String hospCd) {
		this.hospCd = hospCd;
	}
	public String getNotiTitle() {
		return notiTitle;
	}
	public void setNotiTitle(String notiTitle) {
		this.notiTitle = notiTitle;
	}
	public String getNotiContent() {
		return notiContent;
	}
	public void setNotiContent(String notiContent) {
		this.notiContent = notiContent;
	}
	public String getUpdateSw() {
		return updateSw;
	}
	public void setUpdateSw(String updateSw) {
		this.updateSw = updateSw;
	}
	public String getNotiRedcnt() {
		return notiRedcnt;
	}
	public void setNotiRedcnt(String notiRedcnt) {
		this.notiRedcnt = notiRedcnt;
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
	public String getSearchText() {
		return searchText;
	}
	public void setSearchText(String searchText) {
		this.searchText = searchText;
	}
	public String getStartDate() {
		return startDate;
	}
	public void setStartDate(String startDate) {
		this.startDate = startDate;
	}
	public String getEndDate() {
		return endDate;
	}
	public void setEndDate(String endDate) {
		this.endDate = endDate;
	}
	public String getUserNm() {
		return userNm;
	}
	public void setUserNm(String userNm) {
		this.userNm = userNm;
	}
	public String getSubCodeNm() {
		return subCodeNm;
	}
	public void setSubCodeNm(String subCodeNm) {
		this.subCodeNm = subCodeNm;
	}
	public String getNotiNm() {
		return notiNm;
	}
	public void setNotiNm(String notiNm) {
		this.notiNm = notiNm;
	}
	public String getHospUuid() {
		return hospUuid;
	}
	public void setHospUuid(String hospUuid) {
		this.hospUuid = hospUuid;
	}
	public String getSubquery() {
		return subquery;
	}
	public void setSubquery(String subquery) {
		this.subquery = subquery;
	}
    
}