package egovframework.wnn_medcost.magam.mapper;

import java.util.Map;
import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import egovframework.wnn_medcost.magam.model.MagamDTO;
import egovframework.wnn_medcost.magam.model.PatvalDTO;
import egovframework.wnn_medcost.magam.model.FilesDTO;
import egovframework.wnn_medcost.magam.model.IpwonDTO;
import egovframework.wnn_medcost.magam.model.IndiDTO;




@Mapper("MagamMapper")
public interface MagamMapper {	
	
	List<MagamDTO> getMagamYearList(MagamDTO dto);
	
	List<MagamDTO> magamGetFileList(MagamDTO dto);

	List<?> selectMagamCheck(MagamDTO dto);
	
	int  uploadMagamFilesMain(List<FilesDTO> filesList);
	
	void callUploadMagamSamFiles(MagamDTO magamDTO);
	void callUploadMagamPatFiles(MagamDTO magamDTO);
	
	String delMagamClaimNo(MagamDTO dto);
	
	String updateMagamLock(MagamDTO dto);
	
	String dashbordMedExpenses(Map<String, Object> params);
	
	String dashbordINDICATORS(Map<String, Object> params);
	
	int  updateMagamInfo(MagamDTO magamDTO);

    int  insertMagamInfo(MagamDTO magamDTO);

    void callUploadMagamFiles(@Param("filesDataJson") String filesDataJson);
    
	
    // void uploadMagamFiles(FilesDTO fileData);    
	
    void uploadMagamFilesBatch(List<FilesDTO> filesData);
    
    void uploadMagamFilesOnest(List<FilesDTO> filesData);
    
    String crtTotalReport(MagamDTO dto);
    
    
    List<?> setTotalReport_01(MagamDTO dto);
	List<?> setTotalReport_02(MagamDTO dto);
	List<?> setTotalReport_03(MagamDTO dto);
	List<?> setTotalReport_09(MagamDTO dto);
	List<?> setTotalReport_11(MagamDTO dto);
	List<?> setTotalReport_13(MagamDTO dto);
	
	String saveGasanMst(MagamDTO dto);
	
	int insertIpwonInfo(List<IpwonDTO> ipwonData);
	int deleteIpwonInfo(IpwonDTO ipwonData);
	
	int  AdmMagamInsert(MagamDTO dto);
	
	String create_Eval_Indi(IndiDTO dto);
	
	List<IndiDTO> select_Eval_Indi(IndiDTO dto);
	
	List<PatvalDTO>  select_CategoryList05(PatvalDTO dto);
	List<PatvalDTO>  select_CategoryList07(PatvalDTO dto);
	List<PatvalDTO>  select_CategoryList09(PatvalDTO dto);
	List<PatvalDTO>  select_CategoryList10(PatvalDTO dto);
	List<PatvalDTO>  select_CategoryList11(PatvalDTO dto);
	List<PatvalDTO>  select_CategoryList12(PatvalDTO dto);
	List<PatvalDTO>  select_CategoryList13(PatvalDTO dto);
	List<PatvalDTO>  select_CategoryList14(PatvalDTO dto);
	
	List<PatvalDTO>  select_assesCheck00(PatvalDTO dto);
	List<PatvalDTO>  select_assesCheck01(PatvalDTO dto);
	List<PatvalDTO>  select_assesCheck02(PatvalDTO dto);
	List<PatvalDTO>  select_assesCheck03(PatvalDTO dto);
	List<PatvalDTO>  select_assesCheck04(PatvalDTO dto);
	List<PatvalDTO>  select_assesCheck05(PatvalDTO dto);
	List<PatvalDTO>  select_assesCheck06(PatvalDTO dto);
	List<PatvalDTO>  select_assesCheck99(PatvalDTO dto);
	
	List<IndiDTO> select_HospitalMst(IndiDTO dto);
	List<IndiDTO> select_Hosp_Indi(Map<String, Object> params);

	String insGoolgleSheet(MagamDTO dto);
	MagamDTO selGoolgleSheet(MagamDTO dto);
	
	String modifyPatval(PatvalDTO dto);
}
