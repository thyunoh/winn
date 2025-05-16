package egovframework.wnn_medcost.mangr.mapper;

import java.util.Map;
import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import egovframework.wnn_medcost.base.model.CodeMdDTO;
import egovframework.wnn_medcost.mangr.model.AsqDTO;
import egovframework.wnn_medcost.mangr.model.ChartDTO;
import egovframework.wnn_medcost.mangr.model.FaqDTO;
import egovframework.wnn_medcost.mangr.model.NotiDTO;
import egovframework.wnn_medcost.user.model.LisenceDTO;
import egovframework.wnn_medcost.mangr.model.FileDTO;
@Mapper("mangrMapper")
public interface MangrMapper {	
	
	List<CodeMdDTO> getCommList(Map<String, Object> params) throws Exception;

   //faq등록
	List<FaqDTO>      getfaqCdList(FaqDTO dto)  throws Exception; 
	boolean           insertfaqCd(FaqDTO dto)   throws Exception; 
	boolean           updatefaqCd(FaqDTO dto)   throws Exception; 
	String            faqCdDupChk(FaqDTO dto)   throws Exception; 	
  //공지사항 
	List<NotiDTO>     getnotiCdList(NotiDTO dto) throws Exception; 
	int               insertnotiCd(NotiDTO dto)  throws Exception; 
	boolean           updatenotiCd(NotiDTO dto)  throws Exception; 
	String            notiCdDupChk(NotiDTO dto)  throws Exception; 	
	//문서등록 
	int               insertFileCd(FileDTO dto)   throws Exception; 
	boolean           updateFilePath(FileDTO dto) throws Exception; 
	boolean           updateFileCd(FileDTO dto)   throws Exception; 
	boolean           saveFileCd(FileDTO dto)     throws Exception; 
	boolean           saveFile(FileDTO dto)       throws Exception; 
	
	
	 //질의응답 (위너넷답변)
	List<AsqDTO>      getasqCdList(AsqDTO dto)   throws Exception; 
	boolean           insertasqCd(AsqDTO dto)    throws Exception; 
	boolean           updateasqCd(AsqDTO dto)    throws Exception; 
	String            asqCdDupChk(AsqDTO dto)    throws Exception;
	List<AsqDTO>      selectqstnlist(AsqDTO dto) throws Exception;
	//사이드바에서 사용자 일대일질문  
	AsqDTO            selectqstnInfo(AsqDTO dto) throws Exception;
	boolean           updateQstnCd(AsqDTO dto)   throws Exception; 
	
    //문서파일 
	List<FileDTO>     getFileCdList(FileDTO dto)  throws Exception;
	boolean           deleteFileCd(FileDTO dto)   throws Exception;
}
