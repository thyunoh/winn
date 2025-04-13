package egovframework.wnn_medcost.magam.model;

import java.util.List;

public class MagamDTO{

	private static final long serialVersionUID = 1L;

	public static long getSerialversionuid() {
		return serialVersionUID;
	}
	
	// TBL_MAGAM_INFO
	private String key_hosp_cd; 	// 요양기관번호 key
	private String key_mg_year; 	// 작업년 key
	private String key_mgmonth; 	// 작업월 key
	private String key_mg_flag; 	// 마감구분 8.청구서 9.평가서 key	
	
	
	private String hosp_cd; 	    // 요양기관번호
	private String mg_year; 		// 작업년
	private String mgmonth; 		// 작업월
	private String mg_flag; 		// 마감구분 8.청구서 9.평가서	
	private String jobs_dt;         // 작업번호 - 자바에서 작업일시 넘김 ( 여러번 작업시 같은그룹 ) 
	
	private String reg_dttm;		// 등록일시
	private String reg_user;    	// 등록자
	private String reg_ip;	    	// 등록 ip
	private String upd_dttm;		// 최종변경일시
	private String upd_user;		// 최종변경자
	private String upd_ip;	    	// 최종변경 ip
	
	
	// TBL_MAGAM_CHUNG
	private String claim_no;
	private String clform_ver;
	private String claim_type;
	private String treat_type;
	private String date_ym;
	private String case_cnt;
	private String tot_amt;
	private String claim_amt;
	private String file_nm;     	// 파일명
	
	private String user_nm;     	// 등록자명
	
	// 기타 필요필드 
	private String magamyn;    		// 청구서,평가표,월 마감여부
	private String filenew;         // 파일등록 구분 ('S 조회','I 입력','U 수정','D 삭제') 
	
	private List<String> list_fg;
	
	// Getter & Setter
    public List<String> getList_fg() {
        return list_fg;
    }
    
    public void setList_fg(List<String> list_fg) {
        this.list_fg = list_fg;
    }
	
    public String getClaim_no() {
		return claim_no;
	}

	public void setClaim_no(String claim_no) {
		this.claim_no = claim_no;
	}

	public String getClform_ver() {
		return clform_ver;
	}

	public void setClform_ver(String clform_ver) {
		this.clform_ver = clform_ver;
	}

	public String getClaim_type() {
		return claim_type;
	}

	public void setClaim_type(String claim_type) {
		this.claim_type = claim_type;
	}

	public String getTreat_type() {
		return treat_type;
	}

	public void setTreat_type(String treat_type) {
		this.treat_type = treat_type;
	}

	public String getDate_ym() {
		return date_ym;
	}

	public void setDate_ym(String date_ym) {
		this.date_ym = date_ym;
	}

	public String getCase_cnt() {
		return case_cnt;
	}

	public void setCase_cnt(String case_cnt) {
		this.case_cnt = case_cnt;
	}

	public String getTot_amt() {
		return tot_amt;
	}

	public void setTot_amt(String tot_amt) {
		this.tot_amt = tot_amt;
	}

	public String getClaim_amt() {
		return claim_amt;
	}

	public void setClaim_amt(String claim_amt) {
		this.claim_amt = claim_amt;
	}

	public String getKey_hosp_cd() {
		return key_hosp_cd;
	}

	public void setKey_hosp_cd(String key_hosp_cd) {
		this.key_hosp_cd = key_hosp_cd;
	}

	public String getKey_mg_year() {
		return key_mg_year;
	}

	public void setKey_mg_year(String key_mg_year) {
		this.key_mg_year = key_mg_year;
	}

	public String getKey_mgmonth() {
		return key_mgmonth;
	}

	public void setKey_mgmonth(String key_mgmonth) {
		this.key_mgmonth = key_mgmonth;
	}

	public String getKey_mg_flag() {
		return key_mg_flag;
	}

	public void setKey_mg_flag(String key_mg_flag) {
		this.key_mg_flag = key_mg_flag;
	}

	public String getJobs_dt() {
		return jobs_dt;
	}

	public void setJobs_dt(String jobs_dt) {
		this.jobs_dt = jobs_dt;
	}

	public String getMagamyn() {
		return magamyn;
	}

	public void setMagamyn(String magamyn) {
		this.magamyn = magamyn;
	}
	
	
	public String getFilenew() {
		return filenew;
	}

	public void setFilenew(String filenew) {
		this.filenew = filenew;
	}

	public String getFile_nm() {
		return file_nm;
	}

	public void setFile_nm(String file_nm) {
		this.file_nm = file_nm;
	}

	public String getUser_nm() {
		return user_nm;
	}

	public void setUser_nm(String user_nm) {
		this.user_nm = user_nm;
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
