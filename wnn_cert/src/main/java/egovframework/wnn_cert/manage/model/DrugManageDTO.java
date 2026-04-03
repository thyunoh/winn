package egovframework.wnn_cert.manage.model;

import egovframework.wnn_cert.util.CommonDTO;

public class DrugManageDTO extends CommonDTO {

    private String drugId;
    private String hospCd;
    private String drugCd;
    private String drugNm;
    private String drugType;
    private String unit;
    private String storage;
    private String storageCond;
    private int stockQty;
    private int minQty;
    private String expireDt;
    private String supplier;
    private String lastCheckDt;
    private String note;
    private String useYn;
    private String regDt;
    private String regUser;

    public String getDrugId() { return drugId; }
    public void setDrugId(String drugId) { this.drugId = drugId; }

    public String getCompCd() { return hospCd; }
    public void setCompCd(String hospCd) { this.hospCd = hospCd; }

    public String getDrugCd() { return drugCd; }
    public void setDrugCd(String drugCd) { this.drugCd = drugCd; }

    public String getDrugNm() { return drugNm; }
    public void setDrugNm(String drugNm) { this.drugNm = drugNm; }

    public String getDrugType() { return drugType; }
    public void setDrugType(String drugType) { this.drugType = drugType; }

    public String getUnit() { return unit; }
    public void setUnit(String unit) { this.unit = unit; }

    public String getStorage() { return storage; }
    public void setStorage(String storage) { this.storage = storage; }

    public String getStorageCond() { return storageCond; }
    public void setStorageCond(String storageCond) { this.storageCond = storageCond; }

    public int getStockQty() { return stockQty; }
    public void setStockQty(int stockQty) { this.stockQty = stockQty; }

    public int getMinQty() { return minQty; }
    public void setMinQty(int minQty) { this.minQty = minQty; }

    public String getExpireDt() { return expireDt; }
    public void setExpireDt(String expireDt) { this.expireDt = expireDt; }

    public String getSupplier() { return supplier; }
    public void setSupplier(String supplier) { this.supplier = supplier; }

    public String getLastCheckDt() { return lastCheckDt; }
    public void setLastCheckDt(String lastCheckDt) { this.lastCheckDt = lastCheckDt; }

    public String getNote() { return note; }
    public void setNote(String note) { this.note = note; }

    public String getUseYn() { return useYn; }
    public void setUseYn(String useYn) { this.useYn = useYn; }

    public String getRegDt() { return regDt; }
    public void setRegDt(String regDt) { this.regDt = regDt; }

    public String getRegUser() { return regUser; }
    public void setRegUser(String regUser) { this.regUser = regUser; }
}
