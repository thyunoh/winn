package egovframework.wnn_medcost.qps.model;

/**
 * QPS 공통 첨부 (TBL_QPS_FILE).
 *
 * 한 테이블로 모든 문서의 첨부를 담는다 — REF_GB(문서종류) + REF_KEY(그 문서의 키).
 *   회의록·연간계획서·라운딩 점검표 첨부 + 조직도·내규 자료실.
 * 실제 파일은 SFTP 파일서버(월보고서 PDF 와 같은 인프라), 여기엔 메타만.
 */
public class QpsFileDTO {

	private Long    fileSeq;
	private String  hospCd;
	private String  refGb;    // MINUTES/PLAN/ROUND/LIBRARY
	private String  refKey;   // 회의록 SEQ / 계획서 년도 / 라운딩 년월 / 자료실 분류코드
	private String  fileNm;   // 원본 파일명
	private String  filePath; // SFTP 경로
	private Long    fileSize;
	private Integer sortNo;
	private String  useYn;
	private String  regUser;
	private String  updUser;

	public Long getFileSeq() { return fileSeq; }
	public void setFileSeq(Long fileSeq) { this.fileSeq = fileSeq; }
	public String getHospCd() { return hospCd; }
	public void setHospCd(String hospCd) { this.hospCd = hospCd; }
	public String getRefGb() { return refGb; }
	public void setRefGb(String refGb) { this.refGb = refGb; }
	public String getRefKey() { return refKey; }
	public void setRefKey(String refKey) { this.refKey = refKey; }
	public String getFileNm() { return fileNm; }
	public void setFileNm(String fileNm) { this.fileNm = fileNm; }
	public String getFilePath() { return filePath; }
	public void setFilePath(String filePath) { this.filePath = filePath; }
	public Long getFileSize() { return fileSize; }
	public void setFileSize(Long fileSize) { this.fileSize = fileSize; }
	public Integer getSortNo() { return sortNo; }
	public void setSortNo(Integer sortNo) { this.sortNo = sortNo; }
	public String getUseYn() { return useYn; }
	public void setUseYn(String useYn) { this.useYn = useYn; }
	public String getRegUser() { return regUser; }
	public void setRegUser(String regUser) { this.regUser = regUser; }
	public String getUpdUser() { return updUser; }
	public void setUpdUser(String updUser) { this.updUser = updUser; }
}
