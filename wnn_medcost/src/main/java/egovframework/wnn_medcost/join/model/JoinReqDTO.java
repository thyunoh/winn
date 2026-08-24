package egovframework.wnn_medcost.join.model;

import java.util.ArrayList;
import java.util.List;

/**
 * 신규병원 가입신청 (TBL_JOIN_REQ)
 *
 * 기존 회원가입(MberDTO)은 <b>이미 등록된 병원의 사용자 등록</b>이고,
 * 이 DTO 는 <b>병원 자체가 아직 없는 신규 가입신청</b>이다.
 * 그래서 hospCd 는 TBL_HOSP_MST 에 없는 '신청값'이다.
 *
 * ※ 전산프로그램 ID/PW·심평원 인증서암호는 <b>이 화면에서 받지 않는다.</b>
 *   로그인 전 공개 폼으로 받을 성격이 아니라서, 승인 뒤 계약 등록 때 별도로 받는다.
 *   (컬럼은 TBL_JOIN_REQ 에 있으나 신청 화면에서는 비워 둔다)
 */
public class JoinReqDTO {

    private String  iud = "";
    private Long    reqNo;          // 신청번호(AUTO_INCREMENT)
    private String  reqStat;
    private String  reqDttm;        // 신청일시 — 목록·상세에 그대로 뿌린다        // 10.접수 20.검토중 30.승인 90.반려

    /* 요양기관 */
    private String  hospCd;         // 요양기관기호
    private String  hospNm;
    private String  hospCeo;        // 대표자
    private String  busiNum;        // 사업자등록번호
    private String  zipCd;
    private String  hospAddr;
    private String  hospExtradr;
    private String  hospTel;
    private String  hospFax;
    private String  wardcnt;        // 병상수 - 빈 문자열이 올 수 있어 String 으로 받고 SQL 에서 NULLIF

    /* 전산프로그램 정보(MASTER) — 의뢰서 항목. 승인 시 TBL_HOSPCONT_MST 로 이관한다.
     * ※기존 계약정보 화면(wnn_medcost hospcd.jsp)과 같은 항목·같은 저장 방식이다. */
    private String  ocsCompany;     // 프로그램명
    private String  ocsUserId;      // 프로그램 ID
    private String  ocsUserPw;      // 프로그램 PW
    private String  hiraCertPw;     // 심평원 인증서암호

    /* 운영정보 */
    private String  pcUseGb;        // 1.단독사용가능 2.단독불가 3.시작일지정
    private String  pcUseTime;
    private String  pcUseStdt;
    private String  asqDay;         // 환자평가표 작성완료일(매월 N일)
    private String  asqBigo;
    private String  evalGoal;       // 적정성평가 목표점수·등급
    private String  conactGb;       // 희망 계약구분 1.진료비분석 2.적정성평가

    /* 신청 계정 */
    private String  email;          // 로그인 ID
    private String  passWd;
    private String  afPassWd;
    private String  mbrNm;
    private String  jobNm;
    private String  mbrTel;
    private String  bigo;

    /* 대표자 직인 — 화면에서 파일로 불러와 동의서 「(인)」 자리에 얹은 이미지.
     * sealImg 는 data URL 이 아니라 **base64 본문만** 담는다(접두어는 화면에서 떼고 보낸다). */
    private String  sealImg;
    private String  sealMime;
    private String  sealNm;
    private String  sealHash;

    /* 승인 연계 (승인 처리에서 채운다) */
    private String  cfmHospCd;
    private Integer cfmHospSeq;
    private String  hospUuid;
    private String  cfmUserId;
    private Integer cfmUserSeq;
    private String  cfmStartDt;
    private String  cfmDttm;
    private String  cfmUser;
    private String  rjtRsn;

    /* 감사 */
    private String  actionYn;
    private String  regDttm;
    private String  regUser;
    private String  regIp;
    private String  updDttm;
    private String  updUser;
    private String  updIp;

    /* 승인 후 병원이 올리는 동의서 원본 — 이게 있어야 프로그램이 열린다 */
    private String  docYn;          // 제출여부 Y/N
    private String  docDttm;        // 제출일시
    private String  docFileNm;      // 제출 파일명

    private String  passYn;         // 비밀번호 설정여부(Y/N) — 원문은 못 꺼낸다
    private String  reqStatNm;      // 처리상태명(공통코드) — 관리자 목록용

    /* 중복확인 결과 */
    private Integer hospCnt;        // TBL_HOSP_MST 에 이미 있는가
    private Integer reqCnt;         // 진행중(10,20) 신청이 이미 있는가
    private Integer userCnt;        // 이메일이 이미 사용자로 있는가
    private String  hospNmDb;       // 이미 등록된 병원이면 그 이름
    private String  contYn;         // 계약 존재 여부(Y/N) — 목록·상세 [계약입력↔계약수정] 라벨용(2026-08-24)

    /* 하위 목록 */
    private List<JoinMgrDTO>   mgrList   = new ArrayList<JoinMgrDTO>();
    private List<JoinAgreeDTO> agreeList = new ArrayList<JoinAgreeDTO>();

    public String getIud() { return iud; }
    public void setIud(String iud) { this.iud = iud; }
    public Long getReqNo() { return reqNo; }
    public void setReqNo(Long reqNo) { this.reqNo = reqNo; }
    public String getReqStat() { return reqStat; }
    public void setReqStat(String reqStat) { this.reqStat = reqStat; }
    public String getReqDttm() { return reqDttm; }
    public void setReqDttm(String reqDttm) { this.reqDttm = reqDttm; }
    public String getHospCd() { return hospCd; }
    public void setHospCd(String hospCd) { this.hospCd = hospCd; }
    public String getHospNm() { return hospNm; }
    public void setHospNm(String hospNm) { this.hospNm = hospNm; }
    public String getHospCeo() { return hospCeo; }
    public void setHospCeo(String hospCeo) { this.hospCeo = hospCeo; }
    public String getBusiNum() { return busiNum; }
    public void setBusiNum(String busiNum) { this.busiNum = busiNum; }
    public String getZipCd() { return zipCd; }
    public void setZipCd(String zipCd) { this.zipCd = zipCd; }
    public String getHospAddr() { return hospAddr; }
    public void setHospAddr(String hospAddr) { this.hospAddr = hospAddr; }
    public String getHospExtradr() { return hospExtradr; }
    public void setHospExtradr(String hospExtradr) { this.hospExtradr = hospExtradr; }
    public String getHospTel() { return hospTel; }
    public void setHospTel(String hospTel) { this.hospTel = hospTel; }
    public String getHospFax() { return hospFax; }
    public void setHospFax(String hospFax) { this.hospFax = hospFax; }
    public String getWardcnt() { return wardcnt; }
    public void setWardcnt(String wardcnt) { this.wardcnt = wardcnt; }
    public String getOcsCompany() { return ocsCompany; }
    public void setOcsCompany(String ocsCompany) { this.ocsCompany = ocsCompany; }
    public String getOcsUserId() { return ocsUserId; }
    public void setOcsUserId(String ocsUserId) { this.ocsUserId = ocsUserId; }
    public String getOcsUserPw() { return ocsUserPw; }
    public void setOcsUserPw(String ocsUserPw) { this.ocsUserPw = ocsUserPw; }
    public String getHiraCertPw() { return hiraCertPw; }
    public void setHiraCertPw(String hiraCertPw) { this.hiraCertPw = hiraCertPw; }
    public String getPcUseGb() { return pcUseGb; }
    public void setPcUseGb(String pcUseGb) { this.pcUseGb = pcUseGb; }
    public String getPcUseTime() { return pcUseTime; }
    public void setPcUseTime(String pcUseTime) { this.pcUseTime = pcUseTime; }
    public String getPcUseStdt() { return pcUseStdt; }
    public void setPcUseStdt(String pcUseStdt) { this.pcUseStdt = pcUseStdt; }
    public String getAsqDay() { return asqDay; }
    public void setAsqDay(String asqDay) { this.asqDay = asqDay; }
    public String getAsqBigo() { return asqBigo; }
    public void setAsqBigo(String asqBigo) { this.asqBigo = asqBigo; }
    public String getEvalGoal() { return evalGoal; }
    public void setEvalGoal(String evalGoal) { this.evalGoal = evalGoal; }
    public String getConactGb() { return conactGb; }
    public void setConactGb(String conactGb) { this.conactGb = conactGb; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getPassWd() { return passWd; }
    public void setPassWd(String passWd) { this.passWd = passWd; }
    public String getAfPassWd() { return afPassWd; }
    public void setAfPassWd(String afPassWd) { this.afPassWd = afPassWd; }
    public String getMbrNm() { return mbrNm; }
    public void setMbrNm(String mbrNm) { this.mbrNm = mbrNm; }
    public String getJobNm() { return jobNm; }
    public void setJobNm(String jobNm) { this.jobNm = jobNm; }
    public String getMbrTel() { return mbrTel; }
    public void setMbrTel(String mbrTel) { this.mbrTel = mbrTel; }
    public String getBigo() { return bigo; }
    public void setBigo(String bigo) { this.bigo = bigo; }
    public String getSealImg() { return sealImg; }
    public void setSealImg(String sealImg) { this.sealImg = sealImg; }
    public String getSealMime() { return sealMime; }
    public void setSealMime(String sealMime) { this.sealMime = sealMime; }
    public String getSealNm() { return sealNm; }
    public void setSealNm(String sealNm) { this.sealNm = sealNm; }
    public String getSealHash() { return sealHash; }
    public void setSealHash(String sealHash) { this.sealHash = sealHash; }
    public String getCfmHospCd() { return cfmHospCd; }
    public void setCfmHospCd(String cfmHospCd) { this.cfmHospCd = cfmHospCd; }
    public Integer getCfmHospSeq() { return cfmHospSeq; }
    public void setCfmHospSeq(Integer cfmHospSeq) { this.cfmHospSeq = cfmHospSeq; }
    public String getHospUuid() { return hospUuid; }
    public void setHospUuid(String hospUuid) { this.hospUuid = hospUuid; }
    public String getCfmUserId() { return cfmUserId; }
    public void setCfmUserId(String cfmUserId) { this.cfmUserId = cfmUserId; }
    public Integer getCfmUserSeq() { return cfmUserSeq; }
    public void setCfmUserSeq(Integer cfmUserSeq) { this.cfmUserSeq = cfmUserSeq; }
    public String getCfmStartDt() { return cfmStartDt; }
    public void setCfmStartDt(String cfmStartDt) { this.cfmStartDt = cfmStartDt; }
    public String getCfmDttm() { return cfmDttm; }
    public void setCfmDttm(String cfmDttm) { this.cfmDttm = cfmDttm; }
    public String getCfmUser() { return cfmUser; }
    public void setCfmUser(String cfmUser) { this.cfmUser = cfmUser; }
    public String getRjtRsn() { return rjtRsn; }
    public void setRjtRsn(String rjtRsn) { this.rjtRsn = rjtRsn; }
    public String getActionYn() { return actionYn; }
    public void setActionYn(String actionYn) { this.actionYn = actionYn; }
    public String getRegDttm() { return regDttm; }
    public void setRegDttm(String regDttm) { this.regDttm = regDttm; }
    public String getRegUser() { return regUser; }
    public void setRegUser(String regUser) { this.regUser = regUser; }
    public String getRegIp() { return regIp; }
    public void setRegIp(String regIp) { this.regIp = regIp; }
    public String getUpdDttm() { return updDttm; }
    public void setUpdDttm(String updDttm) { this.updDttm = updDttm; }
    public String getUpdUser() { return updUser; }
    public void setUpdUser(String updUser) { this.updUser = updUser; }
    public String getUpdIp() { return updIp; }
    public void setUpdIp(String updIp) { this.updIp = updIp; }
    public String getPassYn() { return passYn; }
    public void setPassYn(String passYn) { this.passYn = passYn; }
    public String getReqStatNm() { return reqStatNm; }
    public void setReqStatNm(String reqStatNm) { this.reqStatNm = reqStatNm; }
    public Integer getHospCnt() { return hospCnt; }
    public void setHospCnt(Integer hospCnt) { this.hospCnt = hospCnt; }
    public Integer getReqCnt() { return reqCnt; }
    public void setReqCnt(Integer reqCnt) { this.reqCnt = reqCnt; }
    public Integer getUserCnt() { return userCnt; }
    public void setUserCnt(Integer userCnt) { this.userCnt = userCnt; }
    public String getHospNmDb() { return hospNmDb; }
    public void setHospNmDb(String hospNmDb) { this.hospNmDb = hospNmDb; }
    public String getContYn() { return contYn; }
    public void setContYn(String contYn) { this.contYn = contYn; }
    public List<JoinMgrDTO> getMgrList() { return mgrList; }
    public void setMgrList(List<JoinMgrDTO> mgrList) { this.mgrList = mgrList; }
    public List<JoinAgreeDTO> getAgreeList() { return agreeList; }
    public void setAgreeList(List<JoinAgreeDTO> agreeList) { this.agreeList = agreeList; }

    public String getDocYn()            { return docYn; }
    public void   setDocYn(String v)    { this.docYn = v; }
    public String getDocDttm()          { return docDttm; }
    public void   setDocDttm(String v)  { this.docDttm = v; }
    public String getDocFileNm()        { return docFileNm; }
    public void   setDocFileNm(String v){ this.docFileNm = v; }
}
