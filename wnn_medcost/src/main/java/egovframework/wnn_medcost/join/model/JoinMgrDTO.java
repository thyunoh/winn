package egovframework.wnn_medcost.join.model;

/** 가입신청 담당자 (TBL_JOIN_MGR) — 의뢰서 [서식1] 의 총관리자·간호과·심사과·전산담당 */
public class JoinMgrDTO {

    private Long    reqNo;
    private String  mgrGb;      // 1.총관리자 2.간호과 3.심사과 4.전산담당 9.기타
    private Integer mgrSeq;
    private String  deptNm;
    private String  jobNm;
    private String  mgrNm;
    private String  mgrTel;
    private String  email;
    private String  userYn;     // 승인 시 사용자로 함께 만들지
    private String  actionYn;
    private String  regUser;
    private String  regIp;

    public Long getReqNo() { return reqNo; }
    public void setReqNo(Long reqNo) { this.reqNo = reqNo; }
    public String getMgrGb() { return mgrGb; }
    public void setMgrGb(String mgrGb) { this.mgrGb = mgrGb; }
    public Integer getMgrSeq() { return mgrSeq; }
    public void setMgrSeq(Integer mgrSeq) { this.mgrSeq = mgrSeq; }
    public String getDeptNm() { return deptNm; }
    public void setDeptNm(String deptNm) { this.deptNm = deptNm; }
    public String getJobNm() { return jobNm; }
    public void setJobNm(String jobNm) { this.jobNm = jobNm; }
    public String getMgrNm() { return mgrNm; }
    public void setMgrNm(String mgrNm) { this.mgrNm = mgrNm; }
    public String getMgrTel() { return mgrTel; }
    public void setMgrTel(String mgrTel) { this.mgrTel = mgrTel; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getUserYn() { return userYn; }
    public void setUserYn(String userYn) { this.userYn = userYn; }
    public String getActionYn() { return actionYn; }
    public void setActionYn(String actionYn) { this.actionYn = actionYn; }
    public String getRegUser() { return regUser; }
    public void setRegUser(String regUser) { this.regUser = regUser; }
    public String getRegIp() { return regIp; }
    public void setRegIp(String regIp) { this.regIp = regIp; }
}
