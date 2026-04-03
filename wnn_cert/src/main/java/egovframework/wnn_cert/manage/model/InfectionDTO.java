package egovframework.wnn_cert.manage.model;

import egovframework.wnn_cert.util.CommonDTO;

public class InfectionDTO extends CommonDTO {

    private String infectId;
    private String hospCd;
    private String infectDt;
    private String patCd;
    private String patNm;
    private String wardNm;
    private String infectType;
    private String infectSite;
    private String specimen;
    private String organism;
    private String antibiotic;
    private String isolationYn;
    private String isolationType;
    private String result;
    private String actionDesc;
    private String note;
    private String useYn;
    private String regDt;
    private String regUser;

    public String getInfectId() { return infectId; }
    public void setInfectId(String infectId) { this.infectId = infectId; }

    public String getHospCd() { return hospCd; }
    public void setHospCd(String hospCd) { this.hospCd = hospCd; }

    public String getInfectDt() { return infectDt; }
    public void setInfectDt(String infectDt) { this.infectDt = infectDt; }

    public String getPatCd() { return patCd; }
    public void setPatCd(String patCd) { this.patCd = patCd; }

    public String getPatNm() { return patNm; }
    public void setPatNm(String patNm) { this.patNm = patNm; }

    public String getWardNm() { return wardNm; }
    public void setWardNm(String wardNm) { this.wardNm = wardNm; }

    public String getInfectType() { return infectType; }
    public void setInfectType(String infectType) { this.infectType = infectType; }

    public String getInfectSite() { return infectSite; }
    public void setInfectSite(String infectSite) { this.infectSite = infectSite; }

    public String getSpecimen() { return specimen; }
    public void setSpecimen(String specimen) { this.specimen = specimen; }

    public String getOrganism() { return organism; }
    public void setOrganism(String organism) { this.organism = organism; }

    public String getAntibiotic() { return antibiotic; }
    public void setAntibiotic(String antibiotic) { this.antibiotic = antibiotic; }

    public String getIsolationYn() { return isolationYn; }
    public void setIsolationYn(String isolationYn) { this.isolationYn = isolationYn; }

    public String getIsolationType() { return isolationType; }
    public void setIsolationType(String isolationType) { this.isolationType = isolationType; }

    public String getResult() { return result; }
    public void setResult(String result) { this.result = result; }

    public String getActionDesc() { return actionDesc; }
    public void setActionDesc(String actionDesc) { this.actionDesc = actionDesc; }

    public String getNote() { return note; }
    public void setNote(String note) { this.note = note; }

    public String getUseYn() { return useYn; }
    public void setUseYn(String useYn) { this.useYn = useYn; }

    public String getRegDt() { return regDt; }
    public void setRegDt(String regDt) { this.regDt = regDt; }

    public String getRegUser() { return regUser; }
    public void setRegUser(String regUser) { this.regUser = regUser; }
}
