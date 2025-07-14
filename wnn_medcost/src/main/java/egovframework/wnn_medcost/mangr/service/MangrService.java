package egovframework.wnn_medcost.mangr.service;

import java.io.File;
import java.io.IOException;
import java.nio.file.Path;
import java.util.List;
import java.util.Map;

import javax.servlet.http.Part;

import org.springframework.web.multipart.MultipartFile;

import egovframework.wnn_medcost.base.model.CodeMdDTO;
import egovframework.wnn_medcost.mangr.model.AsqDTO;
import egovframework.wnn_medcost.mangr.model.ChartDTO;
import egovframework.wnn_medcost.mangr.model.FaqDTO;
import egovframework.wnn_medcost.mangr.model.FileDTO;
import egovframework.wnn_medcost.mangr.model.NotiDTO;
import egovframework.wnn_medcost.user.model.LisenceDTO;

public interface MangrService {
    List<CodeMdDTO> getCommList(List<String> codeGbList, List<String> codeCdList) throws Exception;
    
	List<FaqDTO>      getfaqCdList(FaqDTO dto)     throws Exception; 
	boolean           insertfaqCd(FaqDTO dto)      throws Exception; 
	boolean           updatefaqCd(FaqDTO dto)      throws Exception; 
	String            faqCdDupChk(FaqDTO dto)      throws Exception; 

	//공지사항 
	List<NotiDTO>     getnotiCdList(NotiDTO dto)   throws Exception; 
	int               insertnotiCd(NotiDTO dto)    throws Exception; 
	NotiDTO           selectNotiBySeq(int notiSeq) throws Exception;
	boolean           updatenotiCd(NotiDTO dto)    throws Exception; 
	boolean           delupdatenotiCd(NotiDTO dto)  throws Exception; 
	String            notiCdDupChk(NotiDTO dto)    throws Exception; 		
    //문서등록 
	int               insertFileCd(FileDTO dto)    throws Exception; 
	boolean           updateFilePath(FileDTO dto)  throws Exception; 
	boolean           updateFileCd(FileDTO dto)    throws Exception;
	
	void saveFile(String fileName, String filePath, String hospCd ,  
            String fileGb, String notiSeq ,  String regUser, String regIp , String fileSize) throws Exception;	
	//질의응답 (위너넷)
	List<AsqDTO>      getasqCdList(AsqDTO dto)      throws Exception; 
	boolean           updateasqCd(AsqDTO dto)       throws Exception; 
	String            asqCdDupChk(AsqDTO dto)       throws Exception;
	//사이드바에서 사용자 일대일질문 
	AsqDTO            selectQstnInfo(AsqDTO dto)    throws Exception;
	boolean           insertQstnCd(AsqDTO dto)      throws Exception; 
	boolean           updateQstnCd(AsqDTO dto)      throws Exception; 

    //문서파일 
	List<FileDTO>    getFileCdList(FileDTO dto)  throws Exception; 
	void             deleteFile(String hospCd , String filePath, String fileSeq, String fileGb , String updUser , String  updIp );



}