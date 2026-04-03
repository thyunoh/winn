package egovframework.wnn_cert.cert.model;

import egovframework.wnn_cert.util.CommonDTO;

public class PatientCntDTO extends CommonDTO {

    private String hospCd;
    private String cntType;
    private String cntYear;
    private int m01;
    private int m02;
    private int m03;
    private int m04;
    private int m05;
    private int m06;
    private int m07;
    private int m08;
    private int m09;
    private int m10;
    private int m11;
    private int m12;
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

    public String getCntType() {
        return cntType;
    }

    public void setCntType(String cntType) {
        this.cntType = cntType;
    }

    public String getCntYear() {
        return cntYear;
    }

    public void setCntYear(String cntYear) {
        this.cntYear = cntYear;
    }

    public int getM01() { return m01; }
    public void setM01(int m01) { this.m01 = m01; }

    public int getM02() { return m02; }
    public void setM02(int m02) { this.m02 = m02; }

    public int getM03() { return m03; }
    public void setM03(int m03) { this.m03 = m03; }

    public int getM04() { return m04; }
    public void setM04(int m04) { this.m04 = m04; }

    public int getM05() { return m05; }
    public void setM05(int m05) { this.m05 = m05; }

    public int getM06() { return m06; }
    public void setM06(int m06) { this.m06 = m06; }

    public int getM07() { return m07; }
    public void setM07(int m07) { this.m07 = m07; }

    public int getM08() { return m08; }
    public void setM08(int m08) { this.m08 = m08; }

    public int getM09() { return m09; }
    public void setM09(int m09) { this.m09 = m09; }

    public int getM10() { return m10; }
    public void setM10(int m10) { this.m10 = m10; }

    public int getM11() { return m11; }
    public void setM11(int m11) { this.m11 = m11; }

    public int getM12() { return m12; }
    public void setM12(int m12) { this.m12 = m12; }

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
