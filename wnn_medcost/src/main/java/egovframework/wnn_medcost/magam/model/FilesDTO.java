package egovframework.wnn_medcost.magam.model;

import java.util.List;

public class FilesDTO{

	private static final long serialVersionUID = 1L;

	public static long getSerialversionuid() {
		return serialVersionUID;
	}
	
	private String hosp_cd; 	    // 요양기관번호 				TBL_MAGAM_INFO Key 매핑
	private String mg_year; 		// 작업년 					TBL_MAGAM_INFO Key 매핑
	private String mgmonth; 		// 작업월 					TBL_MAGAM_INFO Key 매핑
	private String mg_flag; 		// 마감구분 8.청구서 9.평가서  TBL_MAGAM_INFO Key 매핑
	private String jobs_dt;         // 작업번호 - 자바에서 작업일시 넘김 ( 여러번 작업시 같은그룹 )
	
    private String file_nm;         // 파일명칭
    private int    line_no;         // 라인번호
    private int    t_lines;         // 총라인수
    private String lineval;         // 라인값
    private String chunggu;         // 청구서포함여부
    
	private String reg_dttm;		// 등록일시
	private String reg_user;    	// 등록자
	private String reg_ip;	    	// 등록 ip
	private String upd_dttm;		// 최종변경일시
	private String upd_user;		// 최종변경자
	private String upd_ip;	    	// 최종변경 ip

	private String ver_number;      // Ver Check 
	private String errcode;     	// 오류코드
	private String errmess;     	// 오류메세지
	
	
	
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
	public int getT_lines() {
		return t_lines;
	}
	public void setT_lines(int t_lines) {
		this.t_lines = t_lines;
	}
	public String getVer_number() {
		return ver_number;
	}
	public void setVer_number(String ver_number) {
		this.ver_number = ver_number;
	}
	public String getHosp_cd() {
		return hosp_cd;
	}
	public void setHosp_cd(String hosp_cd) {
		this.hosp_cd = hosp_cd;
	}
	public String getMg_year() {
		return mg_year;
	}
	public void setMg_year(String mg_year) {
		this.mg_year = mg_year;
	}
	public String getMgmonth() {
		return mgmonth;
	}
	public void setMgmonth(String mgmonth) {
		this.mgmonth = mgmonth;
	}
	public String getMg_flag() {
		return mg_flag;
	}
	public void setMg_flag(String mg_flag) {
		this.mg_flag = mg_flag;
	}
	public String getJobs_dt() {
		return jobs_dt;
	}
	public void setJobs_dt(String jobs_dt) {
		this.jobs_dt = jobs_dt;
	}
	public String getFile_nm() {
		return file_nm;
	}
	public void setFile_nm(String file_nm) {
		this.file_nm = file_nm;
	}
	public int getLine_no() {
		return line_no;
	}
	public void setLine_no(int line_no) {
		this.line_no = line_no;
	}
	public String getLineval() {
		return lineval;
	}
	public void setLineval(String lineval) {
		this.lineval = lineval;
	}
	public String getChunggu() {
		return chunggu;
	}
	public void setChunggu(String chunggu) {
		this.chunggu = chunggu;
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
	
}
