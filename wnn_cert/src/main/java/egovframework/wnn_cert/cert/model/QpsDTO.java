package egovframework.wnn_cert.cert.model;

import egovframework.wnn_cert.util.CommonDTO;

public class QpsDTO extends CommonDTO {

    private String hospCd;
    private String qpsCd;
    private String qpsNm;
    private String note;
    private String useYn;
    private String regDt;
    private String regUser;
    private String updDt;
    private String updUser;

    public String getCompCd() {
        return hospCd;
    }

    public void setCompCd(String hospCd) {
        this.hospCd = hospCd;
    }

    public String getQpsCd() {
        return qpsCd;
    }

    public void setQpsCd(String qpsCd) {
        this.qpsCd = qpsCd;
    }

    public String getQpsNm() {
        return qpsNm;
    }

    public void setQpsNm(String qpsNm) {
        this.qpsNm = qpsNm;
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
