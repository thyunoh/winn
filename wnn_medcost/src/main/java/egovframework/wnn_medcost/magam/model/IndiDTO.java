package egovframework.wnn_medcost.magam.model;

import java.math.BigDecimal;

public class IndiDTO {
	
	private static final long serialVersionUID = 1L;

	public static long getSerialversionuid() {
		return serialVersionUID;
	}
	
	private String     hosp_cd; 	    // 요양기관번호
	private String     jobyymm; 		// 작업년월
	private String     cate_cd; 		// 지표코드
	private String     cate_fg; 		// 지표구분 (구조영역,진료영역,모니터링)
	private String     stryymm; 		// 시작년월
	private String     endyymm; 		// 종료년월
	private BigDecimal dtorval; 		// 분모
	private BigDecimal ntorval; 		// 분자
	private BigDecimal cal_val; 		// 산출값
	private int        max_val; 		// 표준화 최고점
	private BigDecimal stdweig; 		// 가중치
	private BigDecimal weigval; 		// 계산값
	private int        s_score; 		// 표준화 적용구간
	
	private String 	   reg_dttm;		// 등록일시
	private String 	   reg_user;    	// 등록자
	private String     reg_ip;	    	// 등록 ip
	private String     upd_dttm;		// 최종변경일시
	private String     upd_user;		// 최종변경자
	private String     upd_ip;	    	// 최종변경 ip
	
	// 기타 컬럼
	private String     cate_nm;         // 지표명칭
	private String     goal_nm;         // 목표내용
	private String     hospgrd;         // 병원등급
	private String     scoreyy;         // 년 예상 점수
	private String     scoremm;         // 월 예상 점수
	private String     scorest;         // 구조영역 점수
	private String     scoremd;         // 진료영역 점수
	private String     checknm;         // 점검지표 명칭 구분자 ','로 연결	
	private String     fiveZone;        // 5구간 점검
	
	private String     hosp_nm;         // 요양기관명칭
	private String     hospchk;         // 병원사용여부
	private String     indichk;         // 지표적용여부
	
	
	private String     month_1;         // 첫째월
	private String     month_2;         // 둘째월
	private String     month_3;         // 세째월
	private String     month_4;         // 네째월
	private String     month_5;         // 다섯째월
	private String     month_6;         // 여섯째월
	private BigDecimal calval1; 		// 산출값(첫째월)
	private BigDecimal calval2; 		// 산출값(둘째월)
	private BigDecimal calval3; 		// 산출값(세째월)
	private BigDecimal calval4; 		// 산출값(세째월)
	private BigDecimal calval5; 		// 산출값(다섯째월)
	private BigDecimal calval6; 		// 산출값(여섯째월)
	private BigDecimal weival1; 		// 계산값(첫째월)
	private BigDecimal weival2; 		// 계산값(둘째월)
	private BigDecimal weival3; 		// 계산값(세째월)
	private BigDecimal weival4; 		// 계산값(세째월)
	private BigDecimal weival5; 		// 계산값(다섯째월)
	private BigDecimal weival6; 		// 계산값(여섯째월)
	private BigDecimal dtortot; 		// 분모(총합)
	private BigDecimal ntortot; 		// 분자(총합)
	private BigDecimal cal_avg; 		// 산출값(평균)
	private BigDecimal weigavg; 		// 계산값(평균)
	
	

	public String getMonth_1() {
		return month_1;
	}
	public void setMonth_1(String month_1) {
		this.month_1 = month_1;
	}
	public String getMonth_2() {
		return month_2;
	}
	public void setMonth_2(String month_2) {
		this.month_2 = month_2;
	}
	public String getMonth_3() {
		return month_3;
	}
	public void setMonth_3(String month_3) {
		this.month_3 = month_3;
	}
	public String getMonth_4() {
		return month_4;
	}
	public void setMonth_4(String month_4) {
		this.month_4 = month_4;
	}
	public String getMonth_5() {
		return month_5;
	}
	public void setMonth_5(String month_5) {
		this.month_5 = month_5;
	}
	public String getMonth_6() {
		return month_6;
	}
	public void setMonth_6(String month_6) {
		this.month_6 = month_6;
	}
	public BigDecimal getCalval1() {
		return calval1;
	}
	public void setCalval1(BigDecimal calval1) {
		this.calval1 = calval1;
	}
	public BigDecimal getCalval2() {
		return calval2;
	}
	public void setCalval2(BigDecimal calval2) {
		this.calval2 = calval2;
	}
	public BigDecimal getCalval3() {
		return calval3;
	}
	public void setCalval3(BigDecimal calval3) {
		this.calval3 = calval3;
	}
	public BigDecimal getCalval4() {
		return calval4;
	}
	public void setCalval4(BigDecimal calval4) {
		this.calval4 = calval4;
	}
	public BigDecimal getCalval5() {
		return calval5;
	}
	public void setCalval5(BigDecimal calval5) {
		this.calval5 = calval5;
	}
	public BigDecimal getCalval6() {
		return calval6;
	}
	public void setCalval6(BigDecimal calval6) {
		this.calval6 = calval6;
	}
	public BigDecimal getWeival1() {
		return weival1;
	}
	public void setWeival1(BigDecimal weival1) {
		this.weival1 = weival1;
	}
	public BigDecimal getWeival2() {
		return weival2;
	}
	public void setWeival2(BigDecimal weival2) {
		this.weival2 = weival2;
	}
	public BigDecimal getWeival3() {
		return weival3;
	}
	public void setWeival3(BigDecimal weival3) {
		this.weival3 = weival3;
	}
	public BigDecimal getWeival4() {
		return weival4;
	}
	public void setWeival4(BigDecimal weival4) {
		this.weival4 = weival4;
	}
	public BigDecimal getWeival5() {
		return weival5;
	}
	public void setWeival5(BigDecimal weival5) {
		this.weival5 = weival5;
	}
	public BigDecimal getWeival6() {
		return weival6;
	}
	public void setWeival6(BigDecimal weival6) {
		this.weival6 = weival6;
	}
	public BigDecimal getDtortot() {
		return dtortot;
	}
	public void setDtortot(BigDecimal dtortot) {
		this.dtortot = dtortot;
	}
	public BigDecimal getNtortot() {
		return ntortot;
	}
	public void setNtortot(BigDecimal ntortot) {
		this.ntortot = ntortot;
	}
	public BigDecimal getCal_avg() {
		return cal_avg;
	}
	public void setCal_avg(BigDecimal cal_avg) {
		this.cal_avg = cal_avg;
	}
	public BigDecimal getWeigavg() {
		return weigavg;
	}
	public void setWeigavg(BigDecimal weigavg) {
		this.weigavg = weigavg;
	}
	public String getHosp_nm() {
		return hosp_nm;
	}
	public void setHosp_nm(String hosp_nm) {
		this.hosp_nm = hosp_nm;
	}
	public String getHospchk() {
		return hospchk;
	}
	public void setHospchk(String hospchk) {
		this.hospchk = hospchk;
	}
	public String getIndichk() {
		return indichk;
	}
	public void setIndichk(String indichk) {
		this.indichk = indichk;
	}
	public String getFiveZone() {
		return fiveZone;
	}
	public void setFiveZone(String fiveZone) {
		this.fiveZone = fiveZone;
	}
	public String getCate_nm() {
		return cate_nm;
	}
	public void setCate_nm(String cate_nm) {
		this.cate_nm = cate_nm;
	}
	public String getGoal_nm() {
		return goal_nm;
	}
	public void setGoal_nm(String goal_nm) {
		this.goal_nm = goal_nm;
	}
	public String getHospgrd() {
		return hospgrd;
	}
	public void setHospgrd(String hospgrd) {
		this.hospgrd = hospgrd;
	}
	public String getScoreyy() {
		return scoreyy;
	}
	public void setScoreyy(String scoreyy) {
		this.scoreyy = scoreyy;
	}
	public String getScoremm() {
		return scoremm;
	}
	public void setScoremm(String scoremm) {
		this.scoremm = scoremm;
	}
	public String getScorest() {
		return scorest;
	}
	public void setScorest(String scorest) {
		this.scorest = scorest;
	}
	public String getScoremd() {
		return scoremd;
	}
	public void setScoremd(String scoremd) {
		this.scoremd = scoremd;
	}
	public String getChecknm() {
		return checknm;
	}
	public void setChecknm(String checknm) {
		this.checknm = checknm;
	}
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
	public String getCate_cd() {
		return cate_cd;
	}
	public void setCate_cd(String cate_cd) {
		this.cate_cd = cate_cd;
	}
	public String getCate_fg() {
		return cate_fg;
	}
	public void setCate_fg(String cate_fg) {
		this.cate_fg = cate_fg;
	}
	public String getStryymm() {
		return stryymm;
	}
	public void setStryymm(String stryymm) {
		this.stryymm = stryymm;
	}
	public String getEndyymm() {
		return endyymm;
	}
	public void setEndyymm(String endyymm) {
		this.endyymm = endyymm;
	}
	public BigDecimal getDtorval() {
		return dtorval;
	}
	public void setDtorval(BigDecimal dtorval) {
		this.dtorval = dtorval;
	}
	public BigDecimal getNtorval() {
		return ntorval;
	}
	public void setNtorval(BigDecimal ntorval) {
		this.ntorval = ntorval;
	}
	public BigDecimal getCal_val() {
		return cal_val;
	}
	public void setCal_val(BigDecimal cal_val) {
		this.cal_val = cal_val;
	}
	public int getMax_val() {
		return max_val;
	}
	public void setMax_val(int max_val) {
		this.max_val = max_val;
	}
	public BigDecimal getStdweig() {
		return stdweig;
	}
	public void setStdweig(BigDecimal stdweig) {
		this.stdweig = stdweig;
	}
	public BigDecimal getWeigval() {
		return weigval;
	}
	public void setWeigval(BigDecimal weigval) {
		this.weigval = weigval;
	}
	public int getS_score() {
		return s_score;
	}
	public void setS_score(int s_score) {
		this.s_score = s_score;
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
