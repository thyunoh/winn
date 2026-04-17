package egovframework.wnn_medcost.magam.model;

public class SpcsugaDTO {

	private static final long serialVersionUID = 1L;

	public static long getSerialversionuid() {
		return serialVersionUID;
	}

	private String hosp_cd;      // 요양기관번호
	private String jobyymm;      // 작업년월
	private String seq_num;      // 순번

	private String chartno;      // 환자ID
	private String patname;      // 환자성명
	private String med_start;    // 진료일자
	private String juminno;      // 주민번호
	private String card_no;      // 증번호
	private String insurnm;      // 종별
	private String suga_cd;      // 수가코드
	private String edi_code;     // 보험코드
	private String kor_name;     // 한글명
	private String comp_code;    // 제약회사
	private String income_gu;    // 구입거래처
	private String burye_code;   // 분류기호
	private String yong_code;    // 효능코드
	private String unit_price;   // 단가
	private String total_dose;   // 수량
	private String amount;       // 금액
	private String tel_phone;    // 전화번호
	private String hand_phone;   // 휴대폰번호
	private String tewondt;      // 퇴원일자
	private String dep_name;     // 진료과목
	private String ward_nm;      // 병동
	private String room_nm;      // 병실
	private String item_no;      // 항
	private String code_no;      // 목
	private String spc_name;     // 특이사항
	private String sec_code;     // 성분코드
	private String sec_name;     // 성분명
	private String ipwondt;      // 입원일자
	private String doc_code;     // 주치의

	private String reg_dttm;     // 등록일시
	private String reg_user;     // 등록자
	private String reg_ip;       // 등록 IP
	private String upd_dttm;     // 최종변경일시
	private String upd_user;     // 최종변경자
	private String upd_ip;       // 최종변경 IP

	private String errcode;      // 오류코드
	private String errmess;      // 오류메세지

	private String file_nm;      // 파일명
	private String jobs_dt;      // 작업일시

	public String getHosp_cd() { return hosp_cd; }
	public void setHosp_cd(String hosp_cd) { this.hosp_cd = hosp_cd; }
	public String getJobyymm() { return jobyymm; }
	public void setJobyymm(String jobyymm) { this.jobyymm = jobyymm; }
	public String getSeq_num() { return seq_num; }
	public void setSeq_num(String seq_num) { this.seq_num = seq_num; }
	public String getChartno() { return chartno; }
	public void setChartno(String chartno) { this.chartno = chartno; }
	public String getPatname() { return patname; }
	public void setPatname(String patname) { this.patname = patname; }
	public String getMed_start() { return med_start; }
	public void setMed_start(String med_start) { this.med_start = med_start; }
	public String getJuminno() { return juminno; }
	public void setJuminno(String juminno) { this.juminno = juminno; }
	public String getCard_no() { return card_no; }
	public void setCard_no(String card_no) { this.card_no = card_no; }
	public String getInsurnm() { return insurnm; }
	public void setInsurnm(String insurnm) { this.insurnm = insurnm; }
	public String getSuga_cd() { return suga_cd; }
	public void setSuga_cd(String suga_cd) { this.suga_cd = suga_cd; }
	public String getEdi_code() { return edi_code; }
	public void setEdi_code(String edi_code) { this.edi_code = edi_code; }
	public String getKor_name() { return kor_name; }
	public void setKor_name(String kor_name) { this.kor_name = kor_name; }
	public String getComp_code() { return comp_code; }
	public void setComp_code(String comp_code) { this.comp_code = comp_code; }
	public String getIncome_gu() { return income_gu; }
	public void setIncome_gu(String income_gu) { this.income_gu = income_gu; }
	public String getBurye_code() { return burye_code; }
	public void setBurye_code(String burye_code) { this.burye_code = burye_code; }
	public String getYong_code() { return yong_code; }
	public void setYong_code(String yong_code) { this.yong_code = yong_code; }
	public String getUnit_price() { return unit_price; }
	public void setUnit_price(String unit_price) { this.unit_price = unit_price; }
	public String getTotal_dose() { return total_dose; }
	public void setTotal_dose(String total_dose) { this.total_dose = total_dose; }
	public String getAmount() { return amount; }
	public void setAmount(String amount) { this.amount = amount; }
	public String getTel_phone() { return tel_phone; }
	public void setTel_phone(String tel_phone) { this.tel_phone = tel_phone; }
	public String getHand_phone() { return hand_phone; }
	public void setHand_phone(String hand_phone) { this.hand_phone = hand_phone; }
	public String getTewondt() { return tewondt; }
	public void setTewondt(String tewondt) { this.tewondt = tewondt; }
	public String getDep_name() { return dep_name; }
	public void setDep_name(String dep_name) { this.dep_name = dep_name; }
	public String getWard_nm() { return ward_nm; }
	public void setWard_nm(String ward_nm) { this.ward_nm = ward_nm; }
	public String getRoom_nm() { return room_nm; }
	public void setRoom_nm(String room_nm) { this.room_nm = room_nm; }
	public String getItem_no() { return item_no; }
	public void setItem_no(String item_no) { this.item_no = item_no; }
	public String getCode_no() { return code_no; }
	public void setCode_no(String code_no) { this.code_no = code_no; }
	public String getSpc_name() { return spc_name; }
	public void setSpc_name(String spc_name) { this.spc_name = spc_name; }
	public String getSec_code() { return sec_code; }
	public void setSec_code(String sec_code) { this.sec_code = sec_code; }
	public String getSec_name() { return sec_name; }
	public void setSec_name(String sec_name) { this.sec_name = sec_name; }
	public String getIpwondt() { return ipwondt; }
	public void setIpwondt(String ipwondt) { this.ipwondt = ipwondt; }
	public String getDoc_code() { return doc_code; }
	public void setDoc_code(String doc_code) { this.doc_code = doc_code; }
	public String getReg_dttm() { return reg_dttm; }
	public void setReg_dttm(String reg_dttm) { this.reg_dttm = reg_dttm; }
	public String getReg_user() { return reg_user; }
	public void setReg_user(String reg_user) { this.reg_user = reg_user; }
	public String getReg_ip() { return reg_ip; }
	public void setReg_ip(String reg_ip) { this.reg_ip = reg_ip; }
	public String getUpd_dttm() { return upd_dttm; }
	public void setUpd_dttm(String upd_dttm) { this.upd_dttm = upd_dttm; }
	public String getUpd_user() { return upd_user; }
	public void setUpd_user(String upd_user) { this.upd_user = upd_user; }
	public String getUpd_ip() { return upd_ip; }
	public void setUpd_ip(String upd_ip) { this.upd_ip = upd_ip; }
	public String getFile_nm() { return file_nm; }
	public void setFile_nm(String file_nm) { this.file_nm = file_nm; }
	public String getJobs_dt() { return jobs_dt; }
	public void setJobs_dt(String jobs_dt) { this.jobs_dt = jobs_dt; }
	public String getErrcode() { return errcode; }
	public void setErrcode(String errcode) { this.errcode = errcode; }
	public String getErrmess() { return errmess; }
	public void setErrmess(String errmess) { this.errmess = errmess; }
}
