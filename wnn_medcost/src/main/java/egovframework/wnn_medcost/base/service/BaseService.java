package egovframework.wnn_medcost.base.service;

import java.util.List;
import java.util.Map;

import egovframework.wnn_medcost.base.model.ClaimDTO;
import egovframework.wnn_medcost.base.model.CodeMdDTO;
import egovframework.wnn_medcost.base.model.DiseCdDTO;
import egovframework.wnn_medcost.base.model.JearyoCdDTO;
import egovframework.wnn_medcost.base.model.SamverDTO;
import egovframework.wnn_medcost.base.model.SugaCdDTO;
import egovframework.wnn_medcost.base.model.WvalDTO;
import egovframework.wnn_medcost.base.model.YakgaCdDTO;
import egovframework.wnn_medcost.base.model.DrugMstDTO;

public interface BaseService {
    List<CodeMdDTO> getCommList(List<String> codeGbList, List<String> codeCdList) throws Exception;
	
	List<SugaCdDTO> getSugaCdList(SugaCdDTO dto)   throws Exception;
	boolean     insertSugaCdMst(SugaCdDTO dto)     throws Exception;
	boolean     updateSugaCdMst(SugaCdDTO dto)     throws Exception;
	String      SugaCdMstDupChk(SugaCdDTO dto)     throws Exception;
	// Bulk ops (Excel 업로드 최적화)
	List<String> SugaCdMstDupChkList(List<SugaCdDTO> list)     throws Exception;
	int          insertSugaCdMstBulk(List<SugaCdDTO> list)     throws Exception;
	int          updateSugaCdMstBulk(Map<String, Object> params) throws Exception;
	
	List<DiseCdDTO> getDiseCdList(DiseCdDTO dto)   throws Exception;
	boolean     insertDiseCdMst(DiseCdDTO dto)     throws Exception;
	boolean     updateDiseCdMst(DiseCdDTO dto)     throws Exception;
	String      DiseCdMstDupChk(DiseCdDTO dto)     throws Exception;
	// Bulk ops (Excel 업로드)
	List<String> DiseCdMstDupChkList(List<DiseCdDTO> list)     throws Exception;
	int          insertDiseCdMstBulk(List<DiseCdDTO> list)     throws Exception;
	int          updateDiseCdMstBulk(Map<String, Object> params) throws Exception;
	int          deactivateAllDiseCdMst(Map<String, Object> params) throws Exception;
	List<Map<String, Object>> selectMaxJobSeqDiseCd(List<DiseCdDTO> list) throws Exception;
	
	List<CodeMdDTO> getCommMstList(CodeMdDTO dto)   throws Exception;
	boolean     insertCommMst(CodeMdDTO dto)        throws Exception; 
	boolean     updateCommMst(CodeMdDTO dto)        throws Exception; 
	String      CommMstDupChk(CodeMdDTO dto)        throws Exception; 	

	List<CodeMdDTO>   getCodeDtlList(CodeMdDTO dto) throws Exception; 
	boolean           insertCommDtl(CodeMdDTO dto)  throws Exception; 
	boolean           updateCommDtl(CodeMdDTO dto)  throws Exception; 
	String            CommDtlDupChk(CodeMdDTO dto)  throws Exception; 	
   //가중치관리 
	List<WvalDTO>     getWvalueList(WvalDTO dto)    throws Exception; 
	List<WvalDTO>     selWvalueList(WvalDTO dto)    throws Exception;
	boolean           insertWvalue(WvalDTO dto)     throws Exception; 
	boolean           updateWvalue(WvalDTO dto)     throws Exception; 
	String            WvalueDupChk(WvalDTO dto)     throws Exception; 	
	boolean           copWvalueList(WvalDTO dto)    throws Exception;
	int               updPrevWvalueEndDt(WvalDTO dto) throws Exception;  // 기존 그룹 END_DT 끊기
//samfile 	
	List<SamverDTO>   getsamverCdlist(SamverDTO dto) throws Exception;
	boolean           insertsamverCd(SamverDTO dto)  throws Exception;
	boolean           updatesamverCd(SamverDTO dto)  throws Exception;
	String            samverCdDupChk(SamverDTO dto)  throws Exception;
	List<SamverDTO>   getDistinctSamver()            throws Exception;
 //약가  	
	List<YakgaCdDTO>  getYakgaCdList(YakgaCdDTO dto)  throws Exception;
	boolean           updateYakCdMst(YakgaCdDTO dto)  throws Exception;	
 //재료대 
	List<JearyoCdDTO>  getJaeryoCdList(JearyoCdDTO dto)  throws Exception;

	//청구율
	List<ClaimDTO>     getclaimCdList(ClaimDTO dto)   throws Exception;
	boolean            insertclaimCd(ClaimDTO dto)    throws Exception;
	boolean            updateclaimCd(ClaimDTO dto)    throws Exception;
	String             claimCdDupChk(ClaimDTO dto)    throws Exception;

	//특정코드관리(항정/최면진정 약품)
	List<DrugMstDTO>   getDrugMstList(DrugMstDTO dto) throws Exception;
	boolean            insertDrugMst(DrugMstDTO dto)  throws Exception;
	boolean            updateDrugMst(DrugMstDTO dto)  throws Exception;
	boolean            deleteDrugMst(DrugMstDTO dto)  throws Exception;
	String             DrugMstDupChk(DrugMstDTO dto)  throws Exception;
}