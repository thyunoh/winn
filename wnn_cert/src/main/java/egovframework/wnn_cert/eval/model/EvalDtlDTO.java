package egovframework.wnn_cert.eval.model;

import egovframework.wnn_cert.util.CommonDTO;

public class EvalDtlDTO extends CommonDTO {

    private String dtlId;
    private String evalId;
    private String nodeId;
    private double score;
    private String grade;
    private String evidence;
    private String note;
    private String evalUser;
    private String evalDt;

    /* transient */
    private String nodeNm;
    private String parentNm;

    public String getDtlId() {
        return dtlId;
    }

    public void setDtlId(String dtlId) {
        this.dtlId = dtlId;
    }

    public String getEvalId() {
        return evalId;
    }

    public void setEvalId(String evalId) {
        this.evalId = evalId;
    }

    public String getNodeId() {
        return nodeId;
    }

    public void setNodeId(String nodeId) {
        this.nodeId = nodeId;
    }

    public double getScore() {
        return score;
    }

    public void setScore(double score) {
        this.score = score;
    }

    public String getGrade() {
        return grade;
    }

    public void setGrade(String grade) {
        this.grade = grade;
    }

    public String getEvidence() {
        return evidence;
    }

    public void setEvidence(String evidence) {
        this.evidence = evidence;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public String getEvalUser() {
        return evalUser;
    }

    public void setEvalUser(String evalUser) {
        this.evalUser = evalUser;
    }

    public String getEvalDt() {
        return evalDt;
    }

    public void setEvalDt(String evalDt) {
        this.evalDt = evalDt;
    }

    public String getNodeNm() {
        return nodeNm;
    }

    public void setNodeNm(String nodeNm) {
        this.nodeNm = nodeNm;
    }

    public String getParentNm() {
        return parentNm;
    }

    public void setParentNm(String parentNm) {
        this.parentNm = parentNm;
    }

}
