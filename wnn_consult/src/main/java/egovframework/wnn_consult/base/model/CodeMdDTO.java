package egovframework.wnn_consult.base.model;

public class CodeMdDTO {
	private static final long serialVersionUID = 1L;

	public static long getSerialversionuid() {
		return serialVersionUID;
	}
	
	// 기본 필드
    private String iud = "";   // 
    private String codeCd;     // 코드(DTL같이 씀)
    private String codeNm;     // 코드명
    private String startDt;    // 적용시작일자
    private String endDt;      // 적용종료일자
    private String useYn;      // 사용여부
    private String regDttm;    // 등록일시
    private String regUser;    // 등록자
    private String regIp;      // 등록 IP
    private String updDttm;    // 최종변경일시
    private String updUser;    // 최종변경자
    private String updIp;      // 최종변경 IP

    // TBL_CODE_DTL 추가 필드
    private String codeGb;     // 코드구분
    private String subCode;     // 상세코드
    private String subCodeNm;   // 상세코드명
    private String dtlCode;     // 상세코드
    private String dtlCodeNm;   // 상세코드명   
    private Integer sort;      // 정렬순서

    // 추가 속성 필드
    private String prop1;  
    private String prop2;  
    private String prop3;  
    private String prop4;  
    private String prop5;

	public String getIud() {
		return iud;
	}
	public void setIud(String iud) {
		this.iud = iud;
	}
	public String getCodeCd() {
		return codeCd;
	}
	public void setCodeCd(String codeCd) {
		this.codeCd = codeCd;
	}
	public String getCodeNm() {
		return codeNm;
	}
	public void setCodeNm(String codeNm) {
		this.codeNm = codeNm;
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
	public String getCodeGb() {
		return codeGb;
	}
	public void setCodeGb(String codeGb) {
		this.codeGb = codeGb;
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
	public String getDtlCode() {
		return dtlCode;
	}
	public void setDtlCode(String dtlCode) {
		this.dtlCode = dtlCode;
	}
	public String getDtlCodeNm() {
		return dtlCodeNm;
	}
	public void setDtlCodeNm(String dtlCodeNm) {
		this.dtlCodeNm = dtlCodeNm;
	}
	public Integer getSort() {
		return sort;
	}
	public void setSort(Integer sort) {
		this.sort = sort;
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
