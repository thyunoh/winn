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
	private String claim_type_nm;
	private String treat_type;
	private String treat_type_nm;
	private String date_ym;
	private String case_cnt;
	private String tot_amt;
	private String claim_amt;
	private String file_nm;     	// 파일명
	
	private String user_nm;     	// 등록자명
	
	// 기타 필요필드 
	private String magamyn;    		// 청구서,평가표,월 마감여부
	private String ipwonyn;    		// 입원현황 등록여부
	private String filenew;         // 파일등록 구분 ('S 조회','I 입력','U 수정','D 삭제')
	private String errcode;     	// 오류코드
	private String errmess;     	// 오류메세지
	private int    t_lines;         // 총작업건수

	// Total Report
	private String make_fg;         // 제언 A.요양입원료 차등제 B.월별 정액수가 ....
	private String rows_no;         // 제언 내용의 row 위치 
	private String cols_no;         // 제언 내용의 col 위치	
	private String fr_yymm;			// 
	private String midyymm;			// 
	private String endyymm;			// 
	private String jobyymm;			// 작업년월
	private String avg_val;			// 평균
	private String jobcode;			// 작업구분
	private String ta_hosp;			// 타병원
	
	private String ta_f_ym;			// 타병원 (전전월)
	private String ta_m_ym;			// 타병원 (전월)
	private String ta_e_ym;			// 타병원 (당월)
	
	private String doc_grd;         // 의사등급
	private String nur_grd;         // 간호등급
	private String nur_cnt;         // 간호사수대 간호인력수
	private String need_ga;         // 필요인력가산
	private String dietga1;         // 영양사가산
	private String dietga2;         // 조리사가산
	private String dietga3;         // 직영가산
	private String dietga4;         // 치료식 영양관리료 
	
	private String lock_yn;			// 마감 lock 여부 위너넷
	
	private String http_st;         // 구글시트 주소
	
	
	
	public String getHttp_st() {
		return http_st;
	}

	public void setHttp_st(String http_st) {
		this.http_st = http_st;
	}

	public String getLock_yn() {
		return lock_yn;
	}

	public void setLock_yn(String lock_yn) {
		this.lock_yn = lock_yn;
	}

	public String getTa_f_ym() {
		return ta_f_ym;
	}

	public void setTa_f_ym(String ta_f_ym) {
		this.ta_f_ym = ta_f_ym;
	}

	public String getTa_m_ym() {
		return ta_m_ym;
	}

	public void setTa_m_ym(String ta_m_ym) {
		this.ta_m_ym = ta_m_ym;
	}

	public String getTa_e_ym() {
		return ta_e_ym;
	}

	public void setTa_e_ym(String ta_e_ym) {
		this.ta_e_ym = ta_e_ym;
	}

	public String getDoc_grd() {
		return doc_grd;
	}

	public void setDoc_grd(String doc_grd) {
		this.doc_grd = doc_grd;
	}

	public String getNur_grd() {
		return nur_grd;
	}

	public void setNur_grd(String nur_grd) {
		this.nur_grd = nur_grd;
	}

	public String getNur_cnt() {
		return nur_cnt;
	}

	public void setNur_cnt(String nur_cnt) {
		this.nur_cnt = nur_cnt;
	}

	public String getNeed_ga() {
		return need_ga;
	}

	public void setNeed_ga(String need_ga) {
		this.need_ga = need_ga;
	}

	public String getDietga1() {
		return dietga1;
	}

	public void setDietga1(String dietga1) {
		this.dietga1 = dietga1;
	}

	public String getDietga2() {
		return dietga2;
	}

	public void setDietga2(String dietga2) {
		this.dietga2 = dietga2;
	}

	public String getDietga3() {
		return dietga3;
	}

	public void setDietga3(String dietga3) {
		this.dietga3 = dietga3;
	}

	public String getDietga4() {
		return dietga4;
	}

	public void setDietga4(String dietga4) {
		this.dietga4 = dietga4;
	}

	public String getTa_hosp() {
		return ta_hosp;
	}

	public void setTa_hosp(String ta_hosp) {
		this.ta_hosp = ta_hosp;
	}

	public String getJobcode() {
		return jobcode;
	}

	public void setJobcode(String jobcode) {
		this.jobcode = jobcode;
	}

	public String getAvg_val() {
		return avg_val;
	}

	public void setAvg_val(String avg_val) {
		this.avg_val = avg_val;
	}

	public String getJobyymm() {
		return jobyymm;
	}

	public void setJobyymm(String jobyymm) {
		this.jobyymm = jobyymm;
	}

	public String getFr_yymm() {
		return fr_yymm;
	}

	public void setFr_yymm(String fr_yymm) {
		this.fr_yymm = fr_yymm;
	}

	public String getMidyymm() {
		return midyymm;
	}

	public void setMidyymm(String midyymm) {
		this.midyymm = midyymm;
	}

	public String getEndyymm() {
		return endyymm;
	}

	public void setEndyymm(String endyymm) {
		this.endyymm = endyymm;
	}

	public String getMake_fg() {
		return make_fg;
	}

	public void setMake_fg(String make_fg) {
		this.make_fg = make_fg;
	}

	public String getRows_no() {
		return rows_no;
	}

	public void setRows_no(String rows_no) {
		this.rows_no = rows_no;
	}

	public String getCols_no() {
		return cols_no;
	}

	public void setCols_no(String cols_no) {
		this.cols_no = cols_no;
	}

	
	
	
	
	/*
	private int    totamt1;         // 당월 총진료비
	private int    totamt2;         // 전월 총진료비
	private int    yngamt1;         // 당월 양방청구
	private int    yngamt2;         // 전월 양방청구
	private int    jngamt1;         // 당월 정액청구
	private int    jngamt2;         // 전월 정액청구
	private int    hwiamt1;         // 당월 행위청구
	private int    hwiamt2;         // 전월 행위청구
	private int    dayamt1;         // 당월 일당진료비
	private int    dayamt2;         // 전월 일당진료비
	private int    oneamt1;         // 당월 건당진료비
	private int    oneamt2;         // 전월 건당진료비
	private int    tsuamt1;         // 당월 특정수가비
	private int    tsuamt2;         // 전월 특정수가비
	private int    hanamt1;         // 당월 한방청구액
	private int    hanamt2;         // 전월 한방청구액
	*/
	
	/*
	public int getTotamt1() {
		return totamt1;
	}

	public void setTotamt1(int totamt1) {
		this.totamt1 = totamt1;
	}

	public int getTotamt2() {
		return totamt2;
	}

	public void setTotamt2(int totamt2) {
		this.totamt2 = totamt2;
	}

	public int getYngamt1() {
		return yngamt1;
	}

	public void setYngamt1(int yngamt1) {
		this.yngamt1 = yngamt1;
	}

	public int getYngamt2() {
		return yngamt2;
	}

	public void setYngamt2(int yngamt2) {
		this.yngamt2 = yngamt2;
	}

	public int getJngamt1() {
		return jngamt1;
	}

	public void setJngamt1(int jngamt1) {
		this.jngamt1 = jngamt1;
	}

	public int getJngamt2() {
		return jngamt2;
	}

	public void setJngamt2(int jngamt2) {
		this.jngamt2 = jngamt2;
	}

	public int getHwiamt1() {
		return hwiamt1;
	}

	public void setHwiamt1(int hwiamt1) {
		this.hwiamt1 = hwiamt1;
	}

	public int getHwiamt2() {
		return hwiamt2;
	}

	public void setHwiamt2(int hwiamt2) {
		this.hwiamt2 = hwiamt2;
	}

	public int getDayamt1() {
		return dayamt1;
	}

	public void setDayamt1(int dayamt1) {
		this.dayamt1 = dayamt1;
	}

	public int getDayamt2() {
		return dayamt2;
	}

	public void setDayamt2(int dayamt2) {
		this.dayamt2 = dayamt2;
	}

	public int getOneamt1() {
		return oneamt1;
	}

	public void setOneamt1(int oneamt1) {
		this.oneamt1 = oneamt1;
	}

	public int getOneamt2() {
		return oneamt2;
	}

	public void setOneamt2(int oneamt2) {
		this.oneamt2 = oneamt2;
	}

	public int getTsuamt1() {
		return tsuamt1;
	}

	public void setTsuamt1(int tsuamt1) {
		this.tsuamt1 = tsuamt1;
	}

	public int getTsuamt2() {
		return tsuamt2;
	}

	public void setTsuamt2(int tsuamt2) {
		this.tsuamt2 = tsuamt2;
	}

	public int getHanamt1() {
		return hanamt1;
	}

	public void setHanamt1(int hanamt1) {
		this.hanamt1 = hanamt1;
	}

	public int getHanamt2() {
		return hanamt2;
	}
	
	public void setHanamt2(int hanamt2) {
		this.hanamt2 = hanamt2;
	}
	*/
	
	

	public int getT_lines() {
		return t_lines;
	}
	
	public void setT_lines(int t_lines) {
		this.t_lines = t_lines;
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
	
		public String getClaim_type_nm() {
		return claim_type_nm;
	}

	public void setClaim_type_nm(String claim_type_nm) {
		this.claim_type_nm = claim_type_nm;
	}

	public String getTreat_type_nm() {
		return treat_type_nm;
	}

	public void setTreat_type_nm(String treat_type_nm) {
		this.treat_type_nm = treat_type_nm;
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
	
	public String getIpwonyn() {
		return ipwonyn;
	}

	public void setIpwonyn(String ipwonyn) {
		this.ipwonyn = ipwonyn;
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
