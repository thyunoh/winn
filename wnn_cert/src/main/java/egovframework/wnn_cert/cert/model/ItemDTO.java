package egovframework.wnn_cert.cert.model;

import egovframework.wnn_cert.util.CommonDTO;

public class ItemDTO extends CommonDTO {

    private String hospCd;
    private String formCd;
    private String secCd;
    private int itemSeq;
    private String itemNm;
    private String itemDesc;
    private String useYn;

    public String getHospCd() {
        return hospCd;
    }

    public void setHospCd(String hospCd) {
        this.hospCd = hospCd;
    }

    public String getFormCd() {
        return formCd;
    }

    public void setFormCd(String formCd) {
        this.formCd = formCd;
    }

    public String getSecCd() {
        return secCd;
    }

    public void setSecCd(String secCd) {
        this.secCd = secCd;
    }

    public int getItemSeq() {
        return itemSeq;
    }

    public void setItemSeq(int itemSeq) {
        this.itemSeq = itemSeq;
    }

    public String getItemNm() {
        return itemNm;
    }

    public void setItemNm(String itemNm) {
        this.itemNm = itemNm;
    }

    public String getItemDesc() {
        return itemDesc;
    }

    public void setItemDesc(String itemDesc) {
        this.itemDesc = itemDesc;
    }

    public String getUseYn() {
        return useYn;
    }

    public void setUseYn(String useYn) {
        this.useYn = useYn;
    }

}
