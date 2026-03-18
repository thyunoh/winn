package egovframework.wnn_consult.mangr.model;

public class VisitAsqDTO {
	private static final long serialVersionUID = 1L;

	public static long getSerialversionuid() {
		return serialVersionUID;
	}

	private int seq;                 // SEQ (PK)
	private String hospNm;           // 기관명
	private String jongNm;           // 의료기관 종별
	private String bedCnt;           // 기관규모(병상)
	private String consultGb1;       // 진료비분석
	private String consultGb2;       // 적정성평가
	private String consultGb3;       // 재정구분석
	private String consultGb4;       // 인증컨설팅
	private String consultGb5;       // 현지조사컨설팅
	private String consultGita1;     // 기타1
	private String consultGita2;     // 기타2
	private String consultGita3;     // 기타3
	private String userNm;           // 신청자 성함
	private String userPosi;         // 신청자 직위
	private String userPhone;        // 연락처
	private String accpetYn;         // 개인정보 동의
	private String actionYn;         // 데이터 유효성
	private String comformYn;        // 관리자 확인
	private String passWd;           // 비밀번호
	private String regDttm;          // 등록일시
	private String updDttm;          // 수정일시

	public int getSeq() { return seq; }
	public void setSeq(int seq) { this.seq = seq; }
	public String getHospNm() { return hospNm; }
	public void setHospNm(String hospNm) { this.hospNm = hospNm; }
	public String getJongNm() { return jongNm; }
	public void setJongNm(String jongNm) { this.jongNm = jongNm; }
	public String getBedCnt() { return bedCnt; }
	public void setBedCnt(String bedCnt) { this.bedCnt = bedCnt; }
	public String getConsultGb1() { return consultGb1; }
	public void setConsultGb1(String consultGb1) { this.consultGb1 = consultGb1; }
	public String getConsultGb2() { return consultGb2; }
	public void setConsultGb2(String consultGb2) { this.consultGb2 = consultGb2; }
	public String getConsultGb3() { return consultGb3; }
	public void setConsultGb3(String consultGb3) { this.consultGb3 = consultGb3; }
	public String getConsultGb4() { return consultGb4; }
	public void setConsultGb4(String consultGb4) { this.consultGb4 = consultGb4; }
	public String getConsultGb5() { return consultGb5; }
	public void setConsultGb5(String consultGb5) { this.consultGb5 = consultGb5; }
	public String getConsultGita1() { return consultGita1; }
	public void setConsultGita1(String consultGita1) { this.consultGita1 = consultGita1; }
	public String getConsultGita2() { return consultGita2; }
	public void setConsultGita2(String consultGita2) { this.consultGita2 = consultGita2; }
	public String getConsultGita3() { return consultGita3; }
	public void setConsultGita3(String consultGita3) { this.consultGita3 = consultGita3; }
	public String getUserNm() { return userNm; }
	public void setUserNm(String userNm) { this.userNm = userNm; }
	public String getUserPosi() { return userPosi; }
	public void setUserPosi(String userPosi) { this.userPosi = userPosi; }
	public String getUserPhone() { return userPhone; }
	public void setUserPhone(String userPhone) { this.userPhone = userPhone; }
	public String getAccpetYn() { return accpetYn; }
	public void setAccpetYn(String accpetYn) { this.accpetYn = accpetYn; }
	public String getActionYn() { return actionYn; }
	public void setActionYn(String actionYn) { this.actionYn = actionYn; }
	public String getComformYn() { return comformYn; }
	public void setComformYn(String comformYn) { this.comformYn = comformYn; }
	public String getPassWd() { return passWd; }
	public void setPassWd(String passWd) { this.passWd = passWd; }
	public String getRegDttm() { return regDttm; }
	public void setRegDttm(String regDttm) { this.regDttm = regDttm; }
	public String getUpdDttm() { return updDttm; }
	public void setUpdDttm(String updDttm) { this.updDttm = updDttm; }
}
