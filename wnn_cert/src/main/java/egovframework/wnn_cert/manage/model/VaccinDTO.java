package egovframework.wnn_cert.manage.model;

import egovframework.wnn_cert.util.CommonDTO;

public class VaccinDTO extends CommonDTO {

    private String vaccinId;
    private String hospCd;
    private String vaccinYear;
    private String vaccinType;
    private String empNm;
    private String deptNm;
    private String jobType;
    private String vaccinDt;
    private String vaccinPlace;
    private String drugNm;
    private String lotNo;
    private String sideEffect;
    private String note;
    private String useYn;
    private String regDt;
    private String regUser;

    public String getVaccinId() { return vaccinId; }
    public void setVaccinId(String vaccinId) { this.vaccinId = vaccinId; }

    public String getCompCd() { return hospCd; }
    public void setCompCd(String hospCd) { this.hospCd = hospCd; }

    public String getVaccinYear() { return vaccinYear; }
    public void setVaccinYear(String vaccinYear) { this.vaccinYear = vaccinYear; }

    public String getVaccinType() { return vaccinType; }
    public void setVaccinType(String vaccinType) { this.vaccinType = vaccinType; }

    public String getEmpNm() { return empNm; }
    public void setEmpNm(String empNm) { this.empNm = empNm; }

    public String getDeptNm() { return deptNm; }
    public void setDeptNm(String deptNm) { this.deptNm = deptNm; }

    public String getJobType() { return jobType; }
    public void setJobType(String jobType) { this.jobType = jobType; }

    public String getVaccinDt() { return vaccinDt; }
    public void setVaccinDt(String vaccinDt) { this.vaccinDt = vaccinDt; }

    public String getVaccinPlace() { return vaccinPlace; }
    public void setVaccinPlace(String vaccinPlace) { this.vaccinPlace = vaccinPlace; }

    public String getDrugNm() { return drugNm; }
    public void setDrugNm(String drugNm) { this.drugNm = drugNm; }

    public String getLotNo() { return lotNo; }
    public void setLotNo(String lotNo) { this.lotNo = lotNo; }

    public String getSideEffect() { return sideEffect; }
    public void setSideEffect(String sideEffect) { this.sideEffect = sideEffect; }

    public String getNote() { return note; }
    public void setNote(String note) { this.note = note; }

    public String getUseYn() { return useYn; }
    public void setUseYn(String useYn) { this.useYn = useYn; }

    public String getRegDt() { return regDt; }
    public void setRegDt(String regDt) { this.regDt = regDt; }

    public String getRegUser() { return regUser; }
    public void setRegUser(String regUser) { this.regUser = regUser; }
}
