package egovframework.wnn_medcost.magam.service;

import java.util.List;
import java.util.Map;

import egovframework.wnn_medcost.magam.model.FilesDTO;
import egovframework.wnn_medcost.magam.model.IpwonDTO;
import egovframework.wnn_medcost.magam.model.MagamDTO;
import egovframework.wnn_medcost.magam.model.IndiDTO;
import egovframework.wnn_medcost.magam.model.PatvalDTO;

public interface MagamService {
	
	
	List<MagamDTO> getMagamYearList(MagamDTO dto) throws Exception;
	
	List<MagamDTO> magamGetFileList(MagamDTO dto) throws Exception;

	String uploadMagamFilesMain(List<FilesDTO> filesData) throws Exception;
	
	String delMagamClaimNo(MagamDTO dto) throws Exception;
	
	String updateMagamLock(MagamDTO dto) throws Exception;
	
	String dashbordMedExpenses(Map<String, Object> params) throws Exception;
	
	String dashbordINDICATORS(Map<String, Object> params) throws Exception;
	
	void callUploadMagamFiles(List<FilesDTO> filesData) throws Exception;
	
	void uploadMagamFilesBatch(List<FilesDTO> filesData) throws Exception;
	
	void uploadMagamFilesOnest(List<FilesDTO> filesData) throws Exception;
	
	String crtTotalReport(MagamDTO dto) throws Exception;
	
	
	
	List<?> setTotalReport_01(MagamDTO dto)  throws Exception;
	List<?> setTotalReport_02(MagamDTO dto)  throws Exception;
	List<?> setTotalReport_03(MagamDTO dto)  throws Exception;
	List<?> setTotalReport_09(MagamDTO dto)  throws Exception;
	List<?> setTotalReport_11(MagamDTO dto)  throws Exception;
	List<?> setTotalReport_13(MagamDTO dto)  throws Exception;
	
	
	String saveGasanMst(MagamDTO dto) throws Exception;
	
	String saveExcelDatas(List<IpwonDTO> ipwonData) throws Exception;
	
	String create_Eval_Indi(IndiDTO dto) throws Exception;
	
	List<IndiDTO>  select_Eval_Indi(IndiDTO dto) throws Exception;
	
	List<PatvalDTO>  select_CategoryList05(PatvalDTO dto) throws Exception;
	List<PatvalDTO>  select_CategoryList07(PatvalDTO dto) throws Exception;
	List<PatvalDTO>  select_CategoryList09(PatvalDTO dto) throws Exception;
	List<PatvalDTO>  select_CategoryList10(PatvalDTO dto) throws Exception;
	List<PatvalDTO>  select_CategoryList11(PatvalDTO dto) throws Exception;
	List<PatvalDTO>  select_CategoryList12(PatvalDTO dto) throws Exception;
	List<PatvalDTO>  select_CategoryList13(PatvalDTO dto) throws Exception;
	List<PatvalDTO>  select_CategoryList14(PatvalDTO dto) throws Exception;
	
	
	List<PatvalDTO>  select_assesCheck00(PatvalDTO dto) throws Exception;
	List<PatvalDTO>  select_assesCheck01(PatvalDTO dto) throws Exception;
	List<PatvalDTO>  select_assesCheck02(PatvalDTO dto) throws Exception;
	List<PatvalDTO>  select_assesCheck03(PatvalDTO dto) throws Exception;
	List<PatvalDTO>  select_assesCheck04(PatvalDTO dto) throws Exception;
	List<PatvalDTO>  select_assesCheck05(PatvalDTO dto) throws Exception;
	List<PatvalDTO>  select_assesCheck06(PatvalDTO dto) throws Exception;
	List<PatvalDTO>  select_assesCheck99(PatvalDTO dto) throws Exception;
	
	List<IndiDTO> select_HospitalMst(IndiDTO dto) throws Exception;
	List<IndiDTO> select_Hosp_Indi(Map<String, Object> params);
	
	String insGoolgleSheet(MagamDTO dto) throws Exception;
	
	MagamDTO selGoolgleSheet(MagamDTO dto) throws Exception;
	
	String modifyPatval(PatvalDTO dto) throws Exception;
	
}
