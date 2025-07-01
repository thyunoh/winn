package egovframework.wnn_consult.mangr.service;

import java.util.List;

import egovframework.wnn_consult.mangr.model.AsqDTO;
import egovframework.wnn_consult.mangr.model.FaqDTO;
import egovframework.wnn_consult.mangr.model.FileDTO;
import egovframework.wnn_consult.mangr.model.NotiDTO;

public interface MangrService {
	List<?>     selectNotiMstList(NotiDTO dto)  throws Exception; 
	NotiDTO     selectNotiMstinfo(NotiDTO dto)  throws Exception; 
	boolean     insertNotiMst(NotiDTO dto)      throws Exception;
	boolean     updateNotiMst(NotiDTO dto)      throws Exception;
	boolean     deleteNotiMst(NotiDTO dto)      throws Exception;
	boolean     updatecntNotiMst(NotiDTO dto)   throws Exception;
	
	List<AsqDTO> getasqCdList(AsqDTO dto)       throws Exception;
	List<?>     selectqstnlist(AsqDTO dto)      throws Exception; 
	boolean     insertqstnMst(AsqDTO dto)       throws Exception;
	boolean     updateqstnMst(AsqDTO dto)       throws Exception;
	AsqDTO      selectqstnInfo(AsqDTO dto)      throws Exception;
	boolean     updateAnsrMst(AsqDTO dto)       throws Exception;	
	boolean     updatedelasqCd(AsqDTO dto)       throws Exception;	
	List<FaqDTO>  selectfaqlist(FaqDTO dto)  throws Exception; 
	FaqDTO        selectfaqInfo(FaqDTO dto)  throws Exception; 	
	
    //문서파일 
	List<FileDTO>  getFileCdList(FileDTO dto)  throws Exception; 
}