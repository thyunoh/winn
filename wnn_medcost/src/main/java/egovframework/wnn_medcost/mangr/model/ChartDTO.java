package egovframework.wnn_medcost.mangr.model;
public class ChartDTO {
	private static final long serialVersionUID = 1L;
	public static long getSerialversionuid() {
		return serialVersionUID;
	}
    private String dateYm;
    private int totalCount;
    private int totalAmt;
    private int totalAvgAmt;
    private int ipCount;
    private int ipAmt;
    private int ipAvgAmt;
    private int opCount;
    private int opAmt;
    private int opAvgAmt;
    private String startMonth ;
    private String endMonth;

	public String getDateYm() {
		return dateYm;
	}
	public void setDateYm(String dateYm) {
		this.dateYm = dateYm;
	}
	public int getTotalCount() {
		return totalCount;
	}
	public void setTotalCount(int totalCount) {
		this.totalCount = totalCount;
	}
	public int getTotalAmt() {
		return totalAmt;
	}
	public void setTotalAmt(int totalAmt) {
		this.totalAmt = totalAmt;
	}
	public int getTotalAvgAmt() {
		return totalAvgAmt;
	}
	public void setTotalAvgAmt(int totalAvgAmt) {
		this.totalAvgAmt = totalAvgAmt;
	}
	public int getIpCount() {
		return ipCount;
	}
	public void setIpCount(int ipCount) {
		this.ipCount = ipCount;
	}
	public int getIpAmt() {
		return ipAmt;
	}
	public void setIpAmt(int ipAmt) {
		this.ipAmt = ipAmt;
	}
	public int getIpAvgAmt() {
		return ipAvgAmt;
	}
	public void setIpAvgAmt(int ipAvgAmt) {
		this.ipAvgAmt = ipAvgAmt;
	}
	public int getOpCount() {
		return opCount;
	}
	public void setOpCount(int opCount) {
		this.opCount = opCount;
	}
	public int getOpAmt() {
		return opAmt;
	}
	public void setOpAmt(int opAmt) {
		this.opAmt = opAmt;
	}
	public int getOpAvgAmt() {
		return opAvgAmt;
	}
	public void setOpAvgAmt(int opAvgAmt) {
		this.opAvgAmt = opAvgAmt;
	}
	public String getStartMonth() {
		return startMonth;
	}
	public void setStartMonth(String startMonth) {
		this.startMonth = startMonth;
	}
	public String getEndMonth() {
		return endMonth;
	}
	public void setEndMonth(String endMonth) {
		this.endMonth = endMonth;
	}
    
}
