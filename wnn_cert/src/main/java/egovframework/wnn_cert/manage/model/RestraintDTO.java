package egovframework.wnn_cert.manage.model;

import egovframework.wnn_cert.util.CommonDTO;

public class RestraintDTO extends CommonDTO {

    private String restraintId;
    private String compCd;
    private String patCd;
    private String patNm;
    private String restraintType;
    private String startDt;
    private String endDt;
    private String reason;
    private String bodyPart;
    private String orderDr;
    private String nurseNm;
    private String monitorInterval;
    private String skinStatus;
    private String circulation;
    private String releaseReason;
    private String note;
    private String useYn;
    private String regDt;
    private String regUser;

    public String getRestraintId() { return restraintId; }
    public void setRestraintId(String restraintId) { this.restraintId = restraintId; }

    public String getCompCd() { return compCd; }
    public void setCompCd(String compCd) { this.compCd = compCd; }

    public String getPatCd() { return patCd; }
    public void setPatCd(String patCd) { this.patCd = patCd; }

    public String getPatNm() { return patNm; }
    public void setPatNm(String patNm) { this.patNm = patNm; }

    public String getRestraintType() { return restraintType; }
    public void setRestraintType(String restraintType) { this.restraintType = restraintType; }

    public String getStartDt() { return startDt; }
    public void setStartDt(String startDt) { this.startDt = startDt; }

    public String getEndDt() { return endDt; }
    public void setEndDt(String endDt) { this.endDt = endDt; }

    public String getReason() { return reason; }
    public void setReason(String reason) { this.reason = reason; }

    public String getBodyPart() { return bodyPart; }
    public void setBodyPart(String bodyPart) { this.bodyPart = bodyPart; }

    public String getOrderDr() { return orderDr; }
    public void setOrderDr(String orderDr) { this.orderDr = orderDr; }

    public String getNurseNm() { return nurseNm; }
    public void setNurseNm(String nurseNm) { this.nurseNm = nurseNm; }

    public String getMonitorInterval() { return monitorInterval; }
    public void setMonitorInterval(String monitorInterval) { this.monitorInterval = monitorInterval; }

    public String getSkinStatus() { return skinStatus; }
    public void setSkinStatus(String skinStatus) { this.skinStatus = skinStatus; }

    public String getCirculation() { return circulation; }
    public void setCirculation(String circulation) { this.circulation = circulation; }

    public String getReleaseReason() { return releaseReason; }
    public void setReleaseReason(String releaseReason) { this.releaseReason = releaseReason; }

    public String getNote() { return note; }
    public void setNote(String note) { this.note = note; }

    public String getUseYn() { return useYn; }
    public void setUseYn(String useYn) { this.useYn = useYn; }

    public String getRegDt() { return regDt; }
    public void setRegDt(String regDt) { this.regDt = regDt; }

    public String getRegUser() { return regUser; }
    public void setRegUser(String regUser) { this.regUser = regUser; }
}
