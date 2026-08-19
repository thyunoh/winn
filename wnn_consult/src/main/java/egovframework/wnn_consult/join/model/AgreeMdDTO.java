package egovframework.wnn_consult.join.model;

/** 동의서(약관) 마스터 (TBL_AGREE_MST) — 화면에 뿌릴 동의 항목과 본문 */
public class AgreeMdDTO {

    private String  agreeCd;
    private Integer verNo;
    private String  agreeNm;
    private String  formNo;     // [서식1] [서식2] [서식3]
    private String  essYn;      // Y.필수
    private String  signGb;
    private String  legacyCol;  // 기존 TBL_MEMBER_MST 대응 컬럼(PER_USE/PER_INFO/PER_PRO)
    private String  agreeText;  // 본문 전문
    private Integer sort;
    private String  useYn;

    public String getAgreeCd() { return agreeCd; }
    public void setAgreeCd(String agreeCd) { this.agreeCd = agreeCd; }
    public Integer getVerNo() { return verNo; }
    public void setVerNo(Integer verNo) { this.verNo = verNo; }
    public String getAgreeNm() { return agreeNm; }
    public void setAgreeNm(String agreeNm) { this.agreeNm = agreeNm; }
    public String getFormNo() { return formNo; }
    public void setFormNo(String formNo) { this.formNo = formNo; }
    public String getEssYn() { return essYn; }
    public void setEssYn(String essYn) { this.essYn = essYn; }
    public String getSignGb() { return signGb; }
    public void setSignGb(String signGb) { this.signGb = signGb; }
    public String getLegacyCol() { return legacyCol; }
    public void setLegacyCol(String legacyCol) { this.legacyCol = legacyCol; }
    public String getAgreeText() { return agreeText; }
    public void setAgreeText(String agreeText) { this.agreeText = agreeText; }
    public Integer getSort() { return sort; }
    public void setSort(Integer sort) { this.sort = sort; }
    public String getUseYn() { return useYn; }
    public void setUseYn(String useYn) { this.useYn = useYn; }
}
