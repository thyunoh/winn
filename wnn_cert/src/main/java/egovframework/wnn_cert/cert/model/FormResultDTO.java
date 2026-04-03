package egovframework.wnn_cert.cert.model;

import egovframework.wnn_cert.util.CommonDTO;

public class FormResultDTO extends CommonDTO {

    private String resultId;
    private String hospCd;
    private String dischargeDt;
    private String patCd;
    private String evalRound;
    private String formCd;
    private String secCd;
    private int itemSeq;
    private String chkVal;
    private String note;
    private String useYn;
    private String regDt;
    private String regUser;
    private String updDt;
    private String updUser;

    public String getResultId() {
        return resultId;
    }

    public void setResultId(String resultId) {
        this.resultId = resultId;
    }

    public String getCompCd() {
        return hospCd;
    }

    public void setCompCd(String hospCd) {
        this.hospCd = hospCd;
    }

    public String getDischargeDt() {
        return dischargeDt;
    }

    public void setDischargeDt(String dischargeDt) {
        this.dischargeDt = dischargeDt;
    }

    public String getPatCd() {
        return patCd;
    }

    public void setPatCd(String patCd) {
        this.patCd = patCd;
    }

    public String getEvalRound() {
        return evalRound;
    }

    public void setEvalRound(String evalRound) {
        this.evalRound = evalRound;
    }

    public String getFormCd() {
        return formCd;
    }

    public void setFormCd(String formCd) {
        this.formCd = formCd;
    }

    public String getSecCd() {
        return secCd;
    }

    public void setSecCd(String secCd) {
        this.secCd = secCd;
    }

    public int getItemSeq() {
        return itemSeq;
    }

    public void setItemSeq(int itemSeq) {
        this.itemSeq = itemSeq;
    }

    public String getChkVal() {
        return chkVal;
    }

    public void setChkVal(String chkVal) {
        this.chkVal = chkVal;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public String getUseYn() {
        return useYn;
    }

    public void setUseYn(String useYn) {
        this.useYn = useYn;
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

}
