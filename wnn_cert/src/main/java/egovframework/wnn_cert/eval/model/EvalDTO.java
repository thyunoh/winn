package egovframework.wnn_cert.eval.model;

import egovframework.wnn_cert.util.CommonDTO;

public class EvalDTO extends CommonDTO {

    private String evalId;
    private String hospCd;
    private String evalYear;
    private String evalCycle;
    private String evalStatus;
    private String evalResult;
    private String startDt;
    private String endDt;
    private double totalScore;
    private String regDt;
    private String regUser;
    private String updDt;
    private String updUser;

    /* transient for summary */
    private String nodeNm;
    private double domainScore;

    public String getEvalId() {
        return evalId;
    }

    public void setEvalId(String evalId) {
        this.evalId = evalId;
    }

    public String getHospCd() {
        return hospCd;
    }

    public void setHospCd(String hospCd) {
        this.hospCd = hospCd;
    }

    public String getEvalYear() {
        return evalYear;
    }

    public void setEvalYear(String evalYear) {
        this.evalYear = evalYear;
    }

    public String getEvalCycle() {
        return evalCycle;
    }

    public void setEvalCycle(String evalCycle) {
        this.evalCycle = evalCycle;
    }

    public String getEvalStatus() {
        return evalStatus;
    }

    public void setEvalStatus(String evalStatus) {
        this.evalStatus = evalStatus;
    }

    public String getEvalResult() {
        return evalResult;
    }

    public void setEvalResult(String evalResult) {
        this.evalResult = evalResult;
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

    public double getTotalScore() {
        return totalScore;
    }

    public void setTotalScore(double totalScore) {
        this.totalScore = totalScore;
    }

    public String getRegDt() {
        return regDt;
    }

    public void setRegDt(String regDt) {
        this.regDt = regDt;
    }

    public String getRegUser() {
        return regUser;
    }

    public void setRegUser(String regUser) {
        this.regUser = regUser;
    }

    public String getUpdDt() {
        return updDt;
    }

    public void setUpdDt(String updDt) {
        this.updDt = updDt;
    }

    public String getUpdUser() {
        return updUser;
    }

    public void setUpdUser(String updUser) {
        this.updUser = updUser;
    }

    public String getNodeNm() {
        return nodeNm;
    }

    public void setNodeNm(String nodeNm) {
        this.nodeNm = nodeNm;
    }

    public double getDomainScore() {
        return domainScore;
    }

    public void setDomainScore(double domainScore) {
        this.domainScore = domainScore;
    }

}
