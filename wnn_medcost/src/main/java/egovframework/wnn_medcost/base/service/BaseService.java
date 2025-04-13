package egovframework.wnn_medcost.base.service;

import java.util.List;
import java.util.Map;

import egovframework.wnn_medcost.base.model.CodeMdDTO;
import egovframework.wnn_medcost.base.model.DiseCdDTO;
import egovframework.wnn_medcost.base.model.SamverDTO;
import egovframework.wnn_medcost.base.model.SugaCdDTO;
import egovframework.wnn_medcost.base.model.WvalDTO;

public interface BaseService {
    List<CodeMdDTO> getCommList(List<String> codeGbList, List<String> codeCdList) throws Exception;
	
	List<SugaCdDTO> getSugaCdList(SugaCdDTO dto)   throws Exception;	
	boolean     insertSugaCdMst(SugaCdDTO dto)     throws Exception; 
	boolean     updateSugaCdMst(SugaCdDTO dto)     throws Exception; 	
	String      SugaCdMstDupChk(SugaCdDTO dto)     throws Exception; 	
	
	List<DiseCdDTO> getDiseCdList(DiseCdDTO dto)   throws Exception;
	boolean     insertDiseCdMst(DiseCdDTO dto)     throws Exception; 
	boolean     updateDiseCdMst(DiseCdDTO dto)     throws Exception; 
	String      DiseCdMstDupChk(DiseCdDTO dto)     throws Exception; 	
	
	List<CodeMdDTO> getCommMstList(CodeMdDTO dto)   throws Exception;
	boolean     insertCommMst(CodeMdDTO dto)        throws Exception; 
	boolean     updateCommMst(CodeMdDTO dto)        throws Exception; 
	String      CommMstDupChk(CodeMdDTO dto)        throws Exception; 	

	List<CodeMdDTO>   getCodeDtlList(CodeMdDTO dto) throws Exception; 
	boolean           insertCommDtl(CodeMdDTO dto)  throws Exception; 
	boolean           updateCommDtl(CodeMdDTO dto)  throws Exception; 
	String            CommDtlDupChk(CodeMdDTO dto)  throws Exception; 	

   //가중치관리 
	List<WvalDTO>     getWvalueList(WvalDTO dto) throws Exception; 
	boolean           insertWvalue(WvalDTO dto)  throws Exception; 
	boolean           updateWvalue(WvalDTO dto)  throws Exception; 
	String            WvalueDupChk(WvalDTO dto)  throws Exception; 	
//samfile 	
	List<SamverDTO>   getsamverCdlist(SamverDTO dto) throws Exception;
	boolean           insertsamverCd(SamverDTO dto)  throws Exception; 
	boolean           updatesamverCd(SamverDTO dto)  throws Exception; 
	String            samverCdDupChk(SamverDTO dto)  throws Exception; 		
}