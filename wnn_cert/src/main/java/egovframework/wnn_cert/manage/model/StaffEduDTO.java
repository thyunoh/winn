package egovframework.wnn_cert.manage.model;

import egovframework.wnn_cert.util.CommonDTO;

public class StaffEduDTO extends CommonDTO {

    private String eduId;
    private String compCd;
    private String eduYear;
    private String eduType;
    private String eduTitle;
    private String eduDt;
    private String eduTime;
    private String instructor;
    private String eduMethod;
    private String targetDept;
    private int targetCnt;
    private int attendCnt;
    private double attendRate;
    private String eduContent;
    private String evalResult;
    private String note;
    private String useYn;
    private String regDt;
    private String regUser;

    public String getEduId() { return eduId; }
    public void setEduId(String eduId) { this.eduId = eduId; }

    public String getCompCd() { return compCd; }
    public void setCompCd(String compCd) { this.compCd = compCd; }

    public String getEduYear() { return eduYear; }
    public void setEduYear(String eduYear) { this.eduYear = eduYear; }

    public String getEduType() { return eduType; }
    public void setEduType(String eduType) { this.eduType = eduType; }

    public String getEduTitle() { return eduTitle; }
    public void setEduTitle(String eduTitle) { this.eduTitle = eduTitle; }

    public String getEduDt() { return eduDt; }
    public void setEduDt(String eduDt) { this.eduDt = eduDt; }

    public String getEduTime() { return eduTime; }
    public void setEduTime(String eduTime) { this.eduTime = eduTime; }

    public String getInstructor() { return instructor; }
    public void setInstructor(String instructor) { this.instructor = instructor; }

    public String getEduMethod() { return eduMethod; }
    public void setEduMethod(String eduMethod) { this.eduMethod = eduMethod; }

    public String getTargetDept() { return targetDept; }
    public void setTargetDept(String targetDept) { this.targetDept = targetDept; }

    public int getTargetCnt() { return targetCnt; }
    public void setTargetCnt(int targetCnt) { this.targetCnt = targetCnt; }

    public int getAttendCnt() { return attendCnt; }
    public void setAttendCnt(int attendCnt) { this.attendCnt = attendCnt; }

    public double getAttendRate() { return attendRate; }
    public void setAttendRate(double attendRate) { this.attendRate = attendRate; }

    public String getEduContent() { return eduContent; }
    public void setEduContent(String eduContent) { this.eduContent = eduContent; }

    public String getEvalResult() { return evalResult; }
    public void setEvalResult(String evalResult) { this.evalResult = evalResult; }

    public String getNote() { return note; }
    public void setNote(String note) { this.note = note; }

    public String getUseYn() { return useYn; }
    public void setUseYn(String useYn) { this.useYn = useYn; }

    public String getRegDt() { return regDt; }
    public void setRegDt(String regDt) { this.regDt = regDt; }

    public String getRegUser() { return regUser; }
    public void setRegUser(String regUser) { this.regUser = regUser; }
}
