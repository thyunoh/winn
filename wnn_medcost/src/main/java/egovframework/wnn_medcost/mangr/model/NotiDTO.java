package egovframework.wnn_medcost.mangr.model;
public class NotiDTO {
	private static final long serialVersionUID = 1L;

	public static long getSerialversionuid() {
		return serialVersionUID;
	}
	private int keynotiSeq;  // 수가코드 (key)
	private String keyfileGb;  // 수가코드 (key)
	private transient String findData;	
	private int notiSeq;       // 작성순서
    private String fileGb;         // 공지사항('1'), 심사방('2'), 소식지('3')
    private String jobSeq;        // 작업 순서
    private String notiTitle;      // 공지 제목
    private String notiContent;    // 공지 세부내용
    private String startDt;        // 공지 시작일자 (YYYYMMDD 형식)
    private String endDt;          // 공지 종료일자 (YYYYMMDD 형식)
    private String useYn;          // 사용 여부
    private String hospCd;         // 특정 병원 코드
    private String updateSw;       // 등록 구분
    private String actionYn;       // 활성화 여부 (기본값 'Y')
    private String notiRedcnt;     // 읽기 카운트
    private String subCodeNm;      // 공지 세부내용
    private String regDttm;        // 등록 일시
    private String regUser;        // 등록자
    private String regIp;          // 등록 IP
    private String updDttm;        // 최종 변경 일시
    private String updUser;        // 최종 변경자
    private String updIp;          // 최종 변경 IP
    private String fileYn;

	public String getFileYn() {
		return fileYn;
	}
	public void setFileYn(String fileYn) {
		this.fileYn = fileYn;
	}
	public String getNotiRedcnt() {
		return notiRedcnt;
	}
	public void setNotiRedcnt(String notiRedcnt) {
		this.notiRedcnt = notiRedcnt;
	}
	public int getKeynotiSeq() {
		return keynotiSeq;
	}
	public void setKeynotiSeq(int keynotiSeq) {
		this.keynotiSeq = keynotiSeq;
	}
	public String getKeyfileGb() {
		return keyfileGb;
	}
	public void setKeyfileGb(String keyfileGb) {
		this.keyfileGb = keyfileGb;
	}
	public String getFindData() {
		return findData;
	}
	public void setFindData(String findData) {
		this.findData = findData;
	}
	public int getNotiSeq() {
		return notiSeq;
	}
	public void setNotiSeq(int notiSeq) {
		this.notiSeq = notiSeq;
	}
	public String getFileGb() {
		return fileGb;
	}
	public void setFileGb(String fileGb) {
		this.fileGb = fileGb;
	}
	public String getJobSeq() {
		return jobSeq;
	}
	public void setJobSeq(String jobSeq) {
		this.jobSeq = jobSeq;
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
	public String getUpdateSw() {
		return updateSw;
	}
	public void setUpdateSw(String updateSw) {
		this.updateSw = updateSw;
	}
	public String getActionYn() {
		return actionYn;
	}
	public void setActionYn(String actionYn) {
		this.actionYn = actionYn;
	}
	public String getNotiRedCnt() {
		return notiRedcnt;
	}
	public void setNotiRedCnt(String notiRedCnt) {
		this.notiRedcnt = notiRedcnt;
	}
	public String getSubCodeNm() {
		return subCodeNm;
	}
	public void setSubCodeNm(String subCodeNm) {
		this.subCodeNm = subCodeNm;
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