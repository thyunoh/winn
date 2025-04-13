package egovframework.wnn_consult.base.service;

import java.util.List;

import egovframework.wnn_consult.base.model.CodeMdDTO;

public interface BaseService {

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