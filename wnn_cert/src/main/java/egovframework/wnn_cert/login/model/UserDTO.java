package egovframework.wnn_cert.login.model;

import egovframework.wnn_cert.util.CommonDTO;

public class UserDTO extends CommonDTO {

    private String userId;
    private String hospCd;
    private String userNm;
    private String userPw;
    private String deptNm;
    private String roleCd;
    private String useYn;
    private String regDt;
    private String hospNm;

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getHospCd() {
        return hospCd;
    }

    public void setHospCd(String hospCd) {
        this.hospCd = hospCd;
    }

    public String getUserNm() {
        return userNm;
    }

    public void setUserNm(String userNm) {
        this.userNm = userNm;
    }

    public String getUserPw() {
        return userPw;
    }

    public void setUserPw(String userPw) {
        this.userPw = userPw;
    }

    public String getDeptNm() {
        return deptNm;
    }

    public void setDeptNm(String deptNm) {
        this.deptNm = deptNm;
    }

    public String getRoleCd() {
        return roleCd;
    }

    public void setRoleCd(String roleCd) {
        this.roleCd = roleCd;
    }

    public String getUseYn() {
        return useYn;
    }

    public void setUseYn(String useYn) {
        this.useYn = useYn;
    }

    public String getRegDt() {
        return regDt;
    }

    public void setRegDt(String regDt) {
        this.regDt = regDt;
    }

    public String getHospNm() {
        return hospNm;
    }

    public void setHospNm(String hospNm) {
        this.hospNm = hospNm;
    }

}
