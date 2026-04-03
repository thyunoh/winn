package egovframework.wnn_cert.manage.model;

import egovframework.wnn_cert.util.CommonDTO;

public class MealRoundDTO extends CommonDTO {

    private String roundId;
    private String hospCd;
    private String roundDt;
    private String patNm;
    private String patCd;
    private String dietType;
    private String roundContent;
    private String actionDesc;
    private String rounder;
    private String note;
    private String useYn;
    private String regDt;
    private String regUser;

    public String getRoundId() { return roundId; }
    public void setRoundId(String roundId) { this.roundId = roundId; }

    public String getCompCd() { return hospCd; }
    public void setCompCd(String hospCd) { this.hospCd = hospCd; }

    public String getRoundDt() { return roundDt; }
    public void setRoundDt(String roundDt) { this.roundDt = roundDt; }

    public String getPatNm() { return patNm; }
    public void setPatNm(String patNm) { this.patNm = patNm; }

    public String getPatCd() { return patCd; }
    public void setPatCd(String patCd) { this.patCd = patCd; }

    public String getDietType() { return dietType; }
    public void setDietType(String dietType) { this.dietType = dietType; }

    public String getRoundContent() { return roundContent; }
    public void setRoundContent(String roundContent) { this.roundContent = roundContent; }

    public String getActionDesc() { return actionDesc; }
    public void setActionDesc(String actionDesc) { this.actionDesc = actionDesc; }

    public String getRounder() { return rounder; }
    public void setRounder(String rounder) { this.rounder = rounder; }

    public String getNote() { return note; }
    public void setNote(String note) { this.note = note; }

    public String getUseYn() { return useYn; }
    public void setUseYn(String useYn) { this.useYn = useYn; }

    public String getRegDt() { return regDt; }
    public void setRegDt(String regDt) { this.regDt = regDt; }

    public String getRegUser() { return regUser; }
    public void setRegUser(String regUser) { this.regUser = regUser; }
}
