package egovframework.wnn_cert.manage.model;

import egovframework.wnn_cert.util.CommonDTO;

public class StaffEduAttDTO extends CommonDTO {

    private String attId;
    private String eduId;
    private String empNm;
    private String deptNm;
    private String jobType;
    private String attendYn;
    private double testScore;
    private String note;

    public String getAttId() { return attId; }
    public void setAttId(String attId) { this.attId = attId; }

    public String getEduId() { return eduId; }
    public void setEduId(String eduId) { this.eduId = eduId; }

    public String getEmpNm() { return empNm; }
    public void setEmpNm(String empNm) { this.empNm = empNm; }

    public String getDeptNm() { return deptNm; }
    public void setDeptNm(String deptNm) { this.deptNm = deptNm; }

    public String getJobType() { return jobType; }
    public void setJobType(String jobType) { this.jobType = jobType; }

    public String getAttendYn() { return attendYn; }
    public void setAttendYn(String attendYn) { this.attendYn = attendYn; }

    public double getTestScore() { return testScore; }
    public void setTestScore(double testScore) { this.testScore = testScore; }

    public String getNote() { return note; }
    public void setNote(String note) { this.note = note; }
}
