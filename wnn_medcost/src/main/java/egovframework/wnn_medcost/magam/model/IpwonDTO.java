package egovframework.wnn_medcost.magam.model;

import java.util.List;

public class IpwonDTO {
	
	private static final long serialVersionUID = 1L;

	public static long getSerialversionuid() {
		return serialVersionUID;
	}
	
	private String hosp_cd; 	    // 요양기관번호
	private String jobyymm; 		// 작업년월
	private String seq_num;         // 순번
	private String chartno;         // 환자번호
	private String patname;		    // 환자성명 
	private String ipwondt;			// 입원일자
	private String ipwontm;         // 입원시간
	private String tewondt;         // 퇴원일자
	private String tewontm;         // 퇴원시간 
	private String juminno;         // 주민번호  
	private String docname;         // 의사
	private String dept_nm;         // 진료과
	private String insurnm;         // 보험유형
	private String word_nm;         // 병동
	private String room_nm;         // 병실

	private String reg_dttm;		// 등록일시
	private String reg_user;    	// 등록자
	private String reg_ip;	    	// 등록 ip
	private String upd_dttm;		// 최종변경일시
	private String upd_user;		// 최종변경자
	private String upd_ip;	    	// 최종변경 ip
	
	private String errcode;     	// 오류코드
	private String errmess;     	// 오류메세지

	private String file_nm;     	// 파일명
	private String jobs_dt;     	// 작업일시
	
	public String getHosp_cd() {
		return hosp_cd;
	}
	public void setHosp_cd(String hosp_cd) {
		this.hosp_cd = hosp_cd;
	}
	public String getJobyymm() {
		return jobyymm;
	}
	public void setJobyymm(String jobyymm) {
		this.jobyymm = jobyymm;
	}
	public String getSeq_num() {
		return seq_num;
	}
	public void setSeq_num(String seq_num) {
		this.seq_num = seq_num;
	}
	public String getChartno() {
		return chartno;
	}
	public void setChartno(String chartno) {
		this.chartno = chartno;
	}
	public String getPatname() {
		return patname;
	}
	public void setPatname(String patname) {
		this.patname = patname;
	}
	public String getIpwondt() {
		return ipwondt;
	}
	public void setIpwondt(String ipwondt) {
		this.ipwondt = ipwondt;
	}
	public String getIpwontm() {
		return ipwontm;
	}
	public void setIpwontm(String ipwontm) {
		this.ipwontm = ipwontm;
	}
	public String getTewondt() {
		return tewondt;
	}
	public void setTewondt(String tewondt) {
		this.tewondt = tewondt;
	}
	public String getTewontm() {
		return tewontm;
	}
	public void setTewontm(String tewontm) {
		this.tewontm = tewontm;
	}
	public String getJuminno() {
		return juminno;
	}
	public void setJuminno(String juminno) {
		this.juminno = juminno;
	}
	public String getDocname() {
		return docname;
	}
	public void setDocname(String docname) {
		this.docname = docname;
	}
	public String getDept_nm() {
		return dept_nm;
	}
	public void setDept_nm(String dept_nm) {
		this.dept_nm = dept_nm;
	}
	public String getInsurnm() {
		return insurnm;
	}
	public void setInsurnm(String insurnm) {
		this.insurnm = insurnm;
	}
	public String getWord_nm() {
		return word_nm;
	}
	public void setWord_nm(String word_nm) {
		this.word_nm = word_nm;
	}
	public String getRoom_nm() {
		return room_nm;
	}
	public void setRoom_nm(String room_nm) {
		this.room_nm = room_nm;
	}
	public String getReg_dttm() {
		return reg_dttm;
	}
	public void setReg_dttm(String reg_dttm) {
		this.reg_dttm = reg_dttm;
	}
	public String getReg_user() {
		return reg_user;
	}
	public void setReg_user(String reg_user) {
		this.reg_user = reg_user;
	}
	public String getReg_ip() {
		return reg_ip;
	}
	public void setReg_ip(String reg_ip) {
		this.reg_ip = reg_ip;
	}
	public String getUpd_dttm() {
		return upd_dttm;
	}
	public void setUpd_dttm(String upd_dttm) {
		this.upd_dttm = upd_dttm;
	}
	public String getUpd_user() {
		return upd_user;
	}
	public void setUpd_user(String upd_user) {
		this.upd_user = upd_user;
	}
	public String getUpd_ip() {
		return upd_ip;
	}
	public void setUpd_ip(String upd_ip) {
		this.upd_ip = upd_ip;
	}
	
	public String getFile_nm() {
		return file_nm;
	}
	public void setFile_nm(String file_nm) {
		this.file_nm = file_nm;
	}
	public String getJobs_dt() {
		return jobs_dt;
	}
	public void setJobs_dt(String jobs_dt) {
		this.jobs_dt = jobs_dt;
	}
	public String getErrcode() {
		return errcode;
	}
	public void setErrcode(String errcode) {
		this.errcode = errcode;
	}
	public String getErrmess() {
		return errmess;
	}
	public void setErrmess(String errmess) {
		this.errmess = errmess;
	}

	
			
}
