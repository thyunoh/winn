package egovframework.wnn_consult.base.mapper;
import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import egovframework.wnn_consult.base.model.CodeMdDTO;
@Mapper("BaseMapper")
public interface BaseMapper {
	List<?>   selCommMstList(CodeMdDTO dto)   throws Exception; 
	String    selCommMstDupChk(CodeMdDTO dto) throws Exception; 
	boolean   insertCommMst(CodeMdDTO dto)    throws Exception; 
	boolean   updateCommMst(CodeMdDTO dto)    throws Exception; 
	boolean   deleteCommMst(CodeMdDTO dto)    throws Exception; 
	
	List<?>   selectCodeDetailList(CodeMdDTO dto) throws Exception; 
	List<?>   selCommDetailList(CodeMdDTO dto)    throws Exception; 
	String    selCommDetailDupChk(CodeMdDTO dto)  throws Exception; 
	boolean   insertCommDetail(CodeMdDTO dto)     throws Exception; 
	boolean   updateCommDetail(CodeMdDTO dto)     throws Exception; 
	boolean   deleteCommDetail(CodeMdDTO dto)     throws Exception; 
	
	List<?>   selCommDtlInfo(CodeMdDTO dto)       throws Exception; 

}
