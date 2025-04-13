package egovframework.wnn_medcost.magam.mapper;
import java.util.Map;
import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import egovframework.wnn_medcost.magam.model.MagamDTO;
import egovframework.wnn_medcost.magam.model.FilesDTO;
@Mapper("MagamMapper")
public interface MagamMapper {	
	
	List<MagamDTO> getMagamYearList(MagamDTO dto) throws Exception;
	
	List<MagamDTO> magamGetFileList(MagamDTO dto) throws Exception;
	
	void uploadMagamFiles(List<FilesDTO> filesList);
	
	void callUploadMagamSamFiles(MagamDTO magamDTO);
	
	int  updateMagamInfo(MagamDTO magamDTO);

    int  insertMagamInfo(MagamDTO magamDTO);

    void callUploadMagamFiles(@Param("filesDataJson") String filesDataJson);
    
	
    // void uploadMagamFiles(FilesDTO fileData);    
	
    void uploadMagamFilesBatch(List<FilesDTO> filesData);
    
    void uploadMagamFilesOnest(List<FilesDTO> filesData);
    
}
