package egovframework.wnn_medcost.qps.model;

/**
 * QPS 분모 마스터 (TBL_QPS_CENSUS) — 월별 총재원일수·직원수.
 *
 * SUNWOO `T_PATIENTCNT`(GUBUN, IN_YEAR, M01~M12) 구조 그대로 옮긴 것.
 * 낙상 지표의 분모 '재원환자 연인원수' = 해당 기간 M01~M12 합.
 */
public class QpsCensusDTO {

	private Long    censusSeq;
	private String  hospCd;
	private String  censusGb;   // INDAYS(총재원일수) / STAFF(월별직원수) / PATCNT(재원환자수)
	private String  inYear;     // YYYY
	private Integer m01, m02, m03, m04, m05, m06, m07, m08, m09, m10, m11, m12;
	private String  note;
	private String  useYn;
	private String  regUser;
	private String  updUser;

	public Long getCensusSeq() { return censusSeq; }
	public void setCensusSeq(Long censusSeq) { this.censusSeq = censusSeq; }
	public String getHospCd() { return hospCd; }
	public void setHospCd(String hospCd) { this.hospCd = hospCd; }
	public String getCensusGb() { return censusGb; }
	public void setCensusGb(String censusGb) { this.censusGb = censusGb; }
	public String getInYear() { return inYear; }
	public void setInYear(String inYear) { this.inYear = inYear; }
	public Integer getM01() { return m01; }
	public void setM01(Integer m01) { this.m01 = m01; }
	public Integer getM02() { return m02; }
	public void setM02(Integer m02) { this.m02 = m02; }
	public Integer getM03() { return m03; }
	public void setM03(Integer m03) { this.m03 = m03; }
	public Integer getM04() { return m04; }
	public void setM04(Integer m04) { this.m04 = m04; }
	public Integer getM05() { return m05; }
	public void setM05(Integer m05) { this.m05 = m05; }
	public Integer getM06() { return m06; }
	public void setM06(Integer m06) { this.m06 = m06; }
	public Integer getM07() { return m07; }
	public void setM07(Integer m07) { this.m07 = m07; }
	public Integer getM08() { return m08; }
	public void setM08(Integer m08) { this.m08 = m08; }
	public Integer getM09() { return m09; }
	public void setM09(Integer m09) { this.m09 = m09; }
	public Integer getM10() { return m10; }
	public void setM10(Integer m10) { this.m10 = m10; }
	public Integer getM11() { return m11; }
	public void setM11(Integer m11) { this.m11 = m11; }
	public Integer getM12() { return m12; }
	public void setM12(Integer m12) { this.m12 = m12; }
	public String getNote() { return note; }
	public void setNote(String note) { this.note = note; }
	public String getUseYn() { return useYn; }
	public void setUseYn(String useYn) { this.useYn = useYn; }
	public String getRegUser() { return regUser; }
	public void setRegUser(String regUser) { this.regUser = regUser; }
	public String getUpdUser() { return updUser; }
	public void setUpdUser(String updUser) { this.updUser = updUser; }
}
