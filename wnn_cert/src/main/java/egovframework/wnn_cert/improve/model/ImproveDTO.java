package egovframework.wnn_cert.improve.model;

import egovframework.wnn_cert.util.CommonDTO;

public class ImproveDTO extends CommonDTO {

    private String improveId;
    private String dtlId;
    private String title;
    private String content;
    private String impStatus;
    private String dueDt;
    private String compDt;
    private String manager;
    private String regDt;
    private String regUser;

    /* transient */
    private String nodeNm;
    private String parentNm;

    public String getImproveId() {
        return improveId;
    }

    public void setImproveId(String improveId) {
        this.improveId = improveId;
    }

    public String getDtlId() {
        return dtlId;
    }

    public void setDtlId(String dtlId) {
        this.dtlId = dtlId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getImpStatus() {
        return impStatus;
    }

    public void setImpStatus(String impStatus) {
        this.impStatus = impStatus;
    }

    public String getDueDt() {
        return dueDt;
    }

    public void setDueDt(String dueDt) {
        this.dueDt = dueDt;
    }

    public String getCompDt() {
        return compDt;
    }

    public void setCompDt(String compDt) {
        this.compDt = compDt;
    }

    public String getManager() {
        return manager;
    }

    public void setManager(String manager) {
        this.manager = manager;
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
