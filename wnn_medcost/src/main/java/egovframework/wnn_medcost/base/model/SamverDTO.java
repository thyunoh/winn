package egovframework.wnn_medcost.base.model;
public class SamverDTO  extends CommonDTO{
	private String keysamver;
	private String keytblinfo;  // 수가코드 (key)
	private String keyversion ;
	private String keyseq ;
	private transient String findData;
	private String samver;       // SAM FILE 확장구분
    private String tblinfo;      // 청구서, 명세서 구분정보
    private String version;      // 버전정보
    private String seq;             // 순번
    private String itemNm;       // 청구서 항목구분명
    private String sortSeq;     // 정렬순서
    private String startPos;    // 시작위치
    private String endPos;      // 끝위치
    private String dataType;     // 데이터형태
    private String decimalPos;  // 소수점 자리수
    private String dataprocYn;   // 데이터처리여부
    private String dbColnm;      // 데이터형태
    private String lastYn;       // 마지막 컬럼여부
    private String dbComcolnm;   // 공통테이블칼럼
    private String colSize;     // 컬럼사이즈
    private String regDttm; // 입력일시
    private String regUser;      // 입력자
    private String regIp;        // 입력IP
    private String updDttm; // 수정일시
    private String updUser;      // 수정자
    private String updIp;        // 수정IP
    
    private String subCode ;
    private String subCodeNm; // 정렬순서
    private String prop1; // 
    private String prop2; // 
    private String prop3; // 
    private String prop4; // 
    private String prop5; //
 

	public String getKeysamver() {
		return keysamver;
	}
	public void setKeysamver(String keysamver) {
		this.keysamver = keysamver;
	}
	public String getKeytblinfo() {
		return keytblinfo;
	}
	public void setKeytblinfo(String keytblinfo) {
		this.keytblinfo = keytblinfo;
	}
	public String getKeyversion() {
		return keyversion;
	}
	public void setKeyversion(String keyversion) {
		this.keyversion = keyversion;
	}
	public String getKeyseq() {
		return keyseq;
	}
	public void setKeyseq(String keyseq) {
		this.keyseq = keyseq;
	}
	public String getFindData() {
		return findData;
	}
	public void setFindData(String findData) {
		this.findData = findData;
	}
	public String getSamver() {
		return samver;
	}
	public void setSamver(String samver) {
		this.samver = samver;
	}
	public String getTblinfo() {
		return tblinfo;
	}
	public void setTblinfo(String tblinfo) {
		this.tblinfo = tblinfo;
	}
	public String getVersion() {
		return version;
	}
	public void setVersion(String version) {
		this.version = version;
	}
	public String getSeq() {
		return seq;
	}
	public void setSeq(String seq) {
		this.seq = seq;
	}
	public String getItemNm() {
		return itemNm;
	}
	public void setItemNm(String itemNm) {
		this.itemNm = itemNm;
	}
	public String getSortSeq() {
		return sortSeq;
	}
	public void setSortSeq(String sortSeq) {
		this.sortSeq = sortSeq;
	}
	public String getStartPos() {
		return startPos;
	}
	public void setStartPos(String startPos) {
		this.startPos = startPos;
	}
	public String getEndPos() {
		return endPos;
	}
	public void setEndPos(String endPos) {
		this.endPos = endPos;
	}
	public String getDataType() {
		return dataType;
	}
	public void setDataType(String dataType) {
		this.dataType = dataType;
	}
	public String getDecimalPos() {
		return decimalPos;
	}
	public void setDecimalPos(String decimalPos) {
		this.decimalPos = decimalPos;
	}
	public String getDataprocYn() {
		return dataprocYn;
	}
	public void setDataprocYn(String dataprocYn) {
		this.dataprocYn = dataprocYn;
	}
	public String getDbColnm() {
		return dbColnm;
	}
	public void setDbColnm(String dbColnm) {
		this.dbColnm = dbColnm;
	}
	public String getLastYn() {
		return lastYn;
	}
	public void setLastYn(String lastYn) {
		this.lastYn = lastYn;
	}
	public String getDbComcolnm() {
		return dbComcolnm;
	}
	public void setDbComcolnm(String dbComcolnm) {
		this.dbComcolnm = dbComcolnm;
	}
	public String getColSize() {
		return colSize;
	}
	public void setColSize(String colSize) {
		this.colSize = colSize;
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
	public String getSubCode() {
		return subCode;
	}
	public void setSubCode(String subCode) {
		this.subCode = subCode;
	}
	public String getSubCodeNm() {
		return subCodeNm;
	}
	public void setSubCodeNm(String subCodeNm) {
		this.subCodeNm = subCodeNm;
	}
	public String getProp1() {
		return prop1;
	}
	public void setProp1(String prop1) {
		this.prop1 = prop1;
	}
	public String getProp2() {
		return prop2;
	}
	public void setProp2(String prop2) {
		this.prop2 = prop2;
	}
	public String getProp3() {
		return prop3;
	}
	public void setProp3(String prop3) {
		this.prop3 = prop3;
	}
	public String getProp4() {
		return prop4;
	}
	public void setProp4(String prop4) {
		this.prop4 = prop4;
	}
	public String getProp5() {
		return prop5;
	}
	public void setProp5(String prop5) {
		this.prop5 = prop5;
	}
  
    
}
