package egovframework.wnn_medcost.join.model;

/**
 * 가입신청 동의내역 (TBL_JOIN_AGREE)
 *
 * 동의를 컬럼이 아니라 <b>행</b>으로 남긴다. 동의 시점의 본문 버전(verNo)·IP·일시가 같이 남아야
 * 나중에 "무엇에 동의했는지" 를 대조할 수 있다.
 */
public class JoinAgreeDTO {

    private Long    reqNo;
    private String  agreeCd;
    private Integer verNo;
    private String  agreeYn;
    private String  readYn;     // 세부내용 열람여부
    private String  agreeIp;
    private String  agreeNm;    // 동의자명
    private String  regUser;

    /* 화면 표시용(TBL_AGREE_MST 조인) */
    private String  agreeNmTxt;
    private String  essYn;
    private String  formNo;

    public Long getReqNo() { return reqNo; }
    public void setReqNo(Long reqNo) { this.reqNo = reqNo; }
    public String getAgreeCd() { return agreeCd; }
    public void setAgreeCd(String agreeCd) { this.agreeCd = agreeCd; }
    public Integer getVerNo() { return verNo; }
    public void setVerNo(Integer verNo) { this.verNo = verNo; }
    public String getAgreeYn() { return agreeYn; }
    public void setAgreeYn(String agreeYn) { this.agreeYn = agreeYn; }
    public String getReadYn() { return readYn; }
    public void setReadYn(String readYn) { this.readYn = readYn; }
    public String getAgreeIp() { return agreeIp; }
    public void setAgreeIp(String agreeIp) { this.agreeIp = agreeIp; }
    public String getAgreeNm() { return agreeNm; }
    public void setAgreeNm(String agreeNm) { this.agreeNm = agreeNm; }
    public String getRegUser() { return regUser; }
    public void setRegUser(String regUser) { this.regUser = regUser; }
    public String getAgreeNmTxt() { return agreeNmTxt; }
    public void setAgreeNmTxt(String agreeNmTxt) { this.agreeNmTxt = agreeNmTxt; }
    public String getEssYn() { return essYn; }
    public void setEssYn(String essYn) { this.essYn = essYn; }
    public String getFormNo() { return formNo; }
    public void setFormNo(String formNo) { this.formNo = formNo; }
}
