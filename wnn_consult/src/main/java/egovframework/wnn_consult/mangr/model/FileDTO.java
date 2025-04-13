package egovframework.wnn_consult.mangr.model;

import java.io.Serializable;

public class FileDTO implements Serializable {
	private static final long serialVersionUID = 1L;

	public static long getSerialversionuid() {
		return serialVersionUID;
	}
	private String keyfileSeq;      // 파일 (key)
	private String keyfileGb;       // 파일 (key)
	private String keyseq;          // 파일 (key)
	private String fileSeq;         // 등록순서
	private String fileGb;         // 문서구분
	private String seq;            // 자체순서
	private String fileTitle;      // 제목
	private String filePath;       // 경록 
	private String fileSize;       // 사이즈
	private String useYn;          // 등록 일시
    private String regDttm;        // 등록 일시
    private String regUser;        // 등록자
    private String regIp;          // 등록 IP
    private String updDttm;        // 최종 변경 일시
    private String updUser;        // 최종 변경자
    private String updIp;          // 최종 변경 IP   
    private String hospCd;        // 병원정보 
    private String subCodeNm;   
    
	public String getFileSize() {
		return fileSize;
	}
	public void setFileSize(String fileSize) {
		this.fileSize = fileSize;
	}
	public String getSubCodeNm() {
		return subCodeNm;
	}
	public void setSubCodeNm(String subCodeNm) {
		this.subCodeNm = subCodeNm;
	}
	public String getHospCd() {
		return hospCd;
	}
	public void setHospCd(String hospCd) {
		this.hospCd = hospCd;
	}
	public String getFileSeq() {
		return fileSeq;
	}
	public void setFileSeq(String fileSeq) {
		this.fileSeq = fileSeq;
	}
	public String getFileGb() {
		return fileGb;
	}
	public void setFileGb(String fileGb) {
		this.fileGb = fileGb;
	}
	public String getSeq() {
		return seq;
	}
	public void setSeq(String seq) {
		this.seq = seq;
	}
	public String getKeyfileSeq() {
		return keyfileSeq;
	}
	public void setKeyfileSeq(String keyfileSeq) {
		this.keyfileSeq = keyfileSeq;
	}
	public String getKeyfileGb() {
		return keyfileGb;
	}
	public void setKeyfileGb(String keyfileGb) {
		this.keyfileGb = keyfileGb;
	}
	public String getKeyseq() {
		return keyseq;
	}
	public void setKeyseq(String keyseq) {
		this.keyseq = keyseq;
	}
	public String getFileTitle() {
		return fileTitle;
	}
	public void setFileTitle(String fileTitle) {
		this.fileTitle = fileTitle;
	}
	public String getFilePath() {
		return filePath;
	}
	public void setFilePath(String filePath) {
		this.filePath = filePath;
	}
	public String getUseYn() {
		return useYn;
	}
	public void setUseYn(String useYn) {
		this.useYn = useYn;
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