package egovframework.wnn_medcost.base.model;

public class DrugMstDTO {
	private static final long serialVersionUID = 1L;

	public static long getSerialversionuid() {
		return serialVersionUID;
	}

	// PK 백업 (수정/삭제용)
	private String keyediCode;
	private String keycodeFlag;

	private transient String findData;

	private String ediCode;     // EDI 코드 (PK)
	private String atcCode;     // ATC 코드
	private String codeFlag;    // A.항정 B.최면/진정 (PK)
	private String codeFlagNm;  // codeFlag 표시명
	private String drugIng;     // 약성분
	private String drugName;    // 약성분명
	private String compName;    // 업체명
	private String ediName;     // 상품명
	private String drugSize;    // 약품규격
	private String cancelDt;    // 취소일자
	private String regDttm;     // 등록일시
	private String regUser;     // 등록자
	private String regIp;       // 등록IP
	private String updDttm;     // 최종변경일시
	private String updUser;     // 최종변경자
	private String updIp;       // 최종변경IP

	public String getKeyediCode() { return keyediCode; }
	public void setKeyediCode(String keyediCode) { this.keyediCode = keyediCode; }

	public String getKeycodeFlag() { return keycodeFlag; }
	public void setKeycodeFlag(String keycodeFlag) { this.keycodeFlag = keycodeFlag; }

	public String getFindData() { return findData; }
	public void setFindData(String findData) { this.findData = findData; }

	public String getEdiCode() { return ediCode; }
	public void setEdiCode(String ediCode) { this.ediCode = ediCode; }

	public String getAtcCode() { return atcCode; }
	public void setAtcCode(String atcCode) { this.atcCode = atcCode; }

	public String getCodeFlag() { return codeFlag; }
	public void setCodeFlag(String codeFlag) { this.codeFlag = codeFlag; }

	public String getCodeFlagNm() { return codeFlagNm; }
	public void setCodeFlagNm(String codeFlagNm) { this.codeFlagNm = codeFlagNm; }

	public String getDrugIng() { return drugIng; }
	public void setDrugIng(String drugIng) { this.drugIng = drugIng; }

	public String getDrugName() { return drugName; }
	public void setDrugName(String drugName) { this.drugName = drugName; }

	public String getCompName() { return compName; }
	public void setCompName(String compName) { this.compName = compName; }

	public String getEdiName() { return ediName; }
	public void setEdiName(String ediName) { this.ediName = ediName; }

	public String getDrugSize() { return drugSize; }
	public void setDrugSize(String drugSize) { this.drugSize = drugSize; }

	public String getCancelDt() { return cancelDt; }
	public void setCancelDt(String cancelDt) { this.cancelDt = cancelDt; }

	public String getRegDttm() { return regDttm; }
	public void setRegDttm(String regDttm) { this.regDttm = regDttm; }

	public String getRegUser() { return regUser; }
	public void setRegUser(String regUser) { this.regUser = regUser; }

	public String getRegIp() { return regIp; }
	public void setRegIp(String regIp) { this.regIp = regIp; }

	public String getUpdDttm() { return updDttm; }
	public void setUpdDttm(String updDttm) { this.updDttm = updDttm; }

	public String getUpdUser() { return updUser; }
	public void setUpdUser(String updUser) { this.updUser = updUser; }

	public String getUpdIp() { return updIp; }
	public void setUpdIp(String updIp) { this.updIp = updIp; }
}
