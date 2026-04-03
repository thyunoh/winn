package egovframework.wnn_cert.manage.model;

import egovframework.wnn_cert.util.CommonDTO;

public class HandHygieneDTO extends CommonDTO {

    private String hhId;
    private String hospCd;
    private String monitorDt;
    private String monitorMonth;
    private String wardNm;
    private String jobType;
    private int observeCnt;
    private int complyCnt;
    private double complyRate;
    private int moment1;
    private int moment2;
    private int moment3;
    private int moment4;
    private int moment5;
    private String note;
    private String monitorUser;
    private String useYn;
    private String regDt;
    private String regUser;

    public String getHhId() { return hhId; }
    public void setHhId(String hhId) { this.hhId = hhId; }

    public String getCompCd() { return hospCd; }
    public void setCompCd(String hospCd) { this.hospCd = hospCd; }

    public String getMonitorDt() { return monitorDt; }
    public void setMonitorDt(String monitorDt) { this.monitorDt = monitorDt; }

    public String getMonitorMonth() { return monitorMonth; }
    public void setMonitorMonth(String monitorMonth) { this.monitorMonth = monitorMonth; }

    public String getWardNm() { return wardNm; }
    public void setWardNm(String wardNm) { this.wardNm = wardNm; }

    public String getJobType() { return jobType; }
    public void setJobType(String jobType) { this.jobType = jobType; }

    public int getObserveCnt() { return observeCnt; }
    public void setObserveCnt(int observeCnt) { this.observeCnt = observeCnt; }

    public int getComplyCnt() { return complyCnt; }
    public void setComplyCnt(int complyCnt) { this.complyCnt = complyCnt; }

    public double getComplyRate() { return complyRate; }
    public void setComplyRate(double complyRate) { this.complyRate = complyRate; }

    public int getMoment1() { return moment1; }
    public void setMoment1(int moment1) { this.moment1 = moment1; }

    public int getMoment2() { return moment2; }
    public void setMoment2(int moment2) { this.moment2 = moment2; }

    public int getMoment3() { return moment3; }
    public void setMoment3(int moment3) { this.moment3 = moment3; }

    public int getMoment4() { return moment4; }
    public void setMoment4(int moment4) { this.moment4 = moment4; }

    public int getMoment5() { return moment5; }
    public void setMoment5(int moment5) { this.moment5 = moment5; }

    public String getNote() { return note; }
    public void setNote(String note) { this.note = note; }

    public String getMonitorUser() { return monitorUser; }
    public void setMonitorUser(String monitorUser) { this.monitorUser = monitorUser; }

    public String getUseYn() { return useYn; }
    public void setUseYn(String useYn) { this.useYn = useYn; }

    public String getRegDt() { return regDt; }
    public void setRegDt(String regDt) { this.regDt = regDt; }

    public String getRegUser() { return regUser; }
    public void setRegUser(String regUser) { this.regUser = regUser; }
}
