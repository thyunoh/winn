package egovframework.wnn_medcost.magam.service;

import java.util.List;

import egovframework.wnn_medcost.magam.model.FilesDTO;
import egovframework.wnn_medcost.magam.model.MagamDTO;

public interface MagamService {
	
	
	List<MagamDTO> getMagamYearList(MagamDTO dto) throws Exception;
	
	List<MagamDTO> magamGetFileList(MagamDTO dto) throws Exception;

	void uploadMagamFiles(List<FilesDTO> filesData) throws Exception;
	
	void callUploadMagamFiles(List<FilesDTO> filesData) throws Exception;
	
	void uploadMagamFilesBatch(List<FilesDTO> filesData) throws Exception;
	
	void uploadMagamFilesOnest(List<FilesDTO> filesData) throws Exception;
	
}