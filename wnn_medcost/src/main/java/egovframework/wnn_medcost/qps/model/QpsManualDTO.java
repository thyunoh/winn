package egovframework.wnn_medcost.qps.model;

/**
 * QPS 수기입력형 지표의 월별 값 (TBL_QPS_MANUAL).
 *
 * 원천이 위너넷 안에 없는 지표 — 신체보호대 사용대장 · TAT 관리대장 · 퇴원자료 ·
 * 불만고충 처리대장 · 만족도 설문 — 은 병원이 대장을 보고 월별 숫자를 옮겨 적는다.
 *
 * 분자·분모를 한 테이블에 담고 {@code valGb} 로 가른다(NUMER/DENOM).
 * 분모가 재원일수·직원수인 지표(신체보호대 등)는 DENOM 행을 쓰지 않고
 * 마스터의 DENOM_GB 를 따라 {@link QpsCensusDTO}(TBL_QPS_CENSUS) 를 그대로 쓴다.
 */
public class QpsManualDTO {

	private Long    manSeq;
	private String  hospCd;
	private String  indiCd;
	private String  inYear;     // YYYY
	private String  valGb;      // NUMER(분자) / DENOM(분모)
	private String  axisCd;     // 축('' = 총계, '정규'/'응급' = 상세 — TAT 등)
	private Integer m01, m02, m03, m04, m05, m06, m07, m08, m09, m10, m11, m12;
	private String  note;
	private String  useYn;
	private String  regUser;
	private String  updUser;

	public Long getManSeq() { return manSeq; }
	public void setManSeq(Long manSeq) { this.manSeq = manSeq; }
	public String getHospCd() { return hospCd; }
	public void setHospCd(String hospCd) { this.hospCd = hospCd; }
	public String getIndiCd() { return indiCd; }
	public void setIndiCd(String indiCd) { this.indiCd = indiCd; }
	public String getInYear() { return inYear; }
	public void setInYear(String inYear) { this.inYear = inYear; }
	public String getValGb() { return valGb; }
	public void setValGb(String valGb) { this.valGb = valGb; }
	public String getAxisCd() { return axisCd; }
	public void setAxisCd(String axisCd) { this.axisCd = axisCd; }
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
