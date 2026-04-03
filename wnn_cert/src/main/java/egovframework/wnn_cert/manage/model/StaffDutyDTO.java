package egovframework.wnn_cert.manage.model;

import egovframework.wnn_cert.util.CommonDTO;

public class StaffDutyDTO extends CommonDTO {

    private String dutyId;
    private String hospCd;
    private String workDt;
    private int patCnt;
    private int drNeed;
    private int drAssign;
    private double drPerPat;
    private int nrNeed;
    private int nrAssign;
    private double nrPerPat;
    private String legalYn;
    private String dayDr;
    private String nightDr;
    private String dayNr;
    private String nightNr;
    private String note;
    private String useYn;
    private String regDt;
    private String regUser;

    public String getDutyId() { return dutyId; }
    public void setDutyId(String dutyId) { this.dutyId = dutyId; }

    public String getCompCd() { return hospCd; }
    public void setCompCd(String hospCd) { this.hospCd = hospCd; }

    public String getWorkDt() { return workDt; }
    public void setWorkDt(String workDt) { this.workDt = workDt; }

    public int getPatCnt() { return patCnt; }
    public void setPatCnt(int patCnt) { this.patCnt = patCnt; }

    public int getDrNeed() { return drNeed; }
    public void setDrNeed(int drNeed) { this.drNeed = drNeed; }

    public int getDrAssign() { return drAssign; }
    public void setDrAssign(int drAssign) { this.drAssign = drAssign; }

    public double getDrPerPat() { return drPerPat; }
    public void setDrPerPat(double drPerPat) { this.drPerPat = drPerPat; }

    public int getNrNeed() { return nrNeed; }
    public void setNrNeed(int nrNeed) { this.nrNeed = nrNeed; }

    public int getNrAssign() { return nrAssign; }
    public void setNrAssign(int nrAssign) { this.nrAssign = nrAssign; }

    public double getNrPerPat() { return nrPerPat; }
    public void setNrPerPat(double nrPerPat) { this.nrPerPat = nrPerPat; }

    public String getLegalYn() { return legalYn; }
    public void setLegalYn(String legalYn) { this.legalYn = legalYn; }

    public String getDayDr() { return dayDr; }
    public void setDayDr(String dayDr) { this.dayDr = dayDr; }

    public String getNightDr() { return nightDr; }
    public void setNightDr(String nightDr) { this.nightDr = nightDr; }

    public String getDayNr() { return dayNr; }
    public void setDayNr(String dayNr) { this.dayNr = dayNr; }

    public String getNightNr() { return nightNr; }
    public void setNightNr(String nightNr) { this.nightNr = nightNr; }

    public String getNote() { return note; }
    public void setNote(String note) { this.note = note; }

    public String getUseYn() { return useYn; }
    public void setUseYn(String useYn) { this.useYn = useYn; }

    public String getRegDt() { return regDt; }
    public void setRegDt(String regDt) { this.regDt = regDt; }

    public String getRegUser() { return regUser; }
    public void setRegUser(String regUser) { this.regUser = regUser; }
}
