package egovframework.wnn_medcost.magam.service;

import java.util.List;
import java.util.Map;

import egovframework.wnn_medcost.magam.model.FilesDTO;
import egovframework.wnn_medcost.magam.model.IpwonDTO;
import egovframework.wnn_medcost.magam.model.SpcsugaDTO;
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

	String saveSpcsugaDatas(List<SpcsugaDTO> spcsugaData) throws Exception;
	
	String create_Eval_Indi(IndiDTO dto) throws Exception;
	
	List<IndiDTO>  select_Eval_Indi(IndiDTO dto) throws Exception;

	// ===== 적정성평가 컨설팅 월보고서 =====
	List<Map<String, Object>> selectEvalReportList(Map<String, Object> params) throws Exception;   // 월보고서 목록(년월+선택 병원)
	List<Map<String, Object>> selectEvalReportHst(Map<String, Object> params) throws Exception;    // 월보고서 변경이력(병원·월)
	Map<String, Object> selectEvalReportHstOne(Map<String, Object> params) throws Exception;       // 이력 단건 스냅샷(TEXTS_JSON)
	Map<String, Object> loadEvalReport(String hospCd, String evalYm) throws Exception;
	Long saveEvalReport(Map<String, Object> p) throws Exception;
	void approveEvalReport(Map<String, Object> p) throws Exception;
	void cancelApproveEvalReport(Map<String, Object> p) throws Exception;
	void saveEvalReportPdf(Map<String, Object> p) throws Exception;   // 첨부 PDF 경로 저장(마스터 없으면 생성) / pdfPath=null 이면 해제

	List<Map<String, Object>> select_EvalProgress(IndiDTO dto) throws Exception;   // 자료생성 진행상태(항목별)
	
	List<PatvalDTO>  select_CategoryList05(PatvalDTO dto) throws Exception;
	List<PatvalDTO>  select_CategoryList06(PatvalDTO dto) throws Exception;
	List<PatvalDTO>  select_CategoryList07(PatvalDTO dto) throws Exception;
	List<PatvalDTO>  select_DiagRank07(PatvalDTO dto) throws Exception;
	List<PatvalDTO>  select_DiagNames(java.util.Map<String, Object> param) throws Exception;
	List<PatvalDTO>  select_CategoryList09(PatvalDTO dto) throws Exception;
	List<PatvalDTO>  select_CategoryList10(PatvalDTO dto) throws Exception;
	List<PatvalDTO>  select_CategoryList11(PatvalDTO dto) throws Exception;
	List<PatvalDTO>  select_CategoryList12(PatvalDTO dto) throws Exception;
	List<PatvalDTO>  select_CategoryList13(PatvalDTO dto) throws Exception;
	List<PatvalDTO>  select_CategoryList14(PatvalDTO dto) throws Exception;
	
	
	List<PatvalDTO>  select_CathCrossCheck(PatvalDTO dto) throws Exception;

	List<Map<String, Object>> select_CathPatvalByPat(Map<String, Object> params) throws Exception;
	List<Map<String, Object>> select_CathSpcsugaByPat(Map<String, Object> params) throws Exception;

	List<PatvalDTO>  select_assesCheck00(PatvalDTO dto) throws Exception;
	List<PatvalDTO>  select_assesCheck01(PatvalDTO dto) throws Exception;
	List<PatvalDTO>  select_assesCheck02(PatvalDTO dto) throws Exception;
	List<PatvalDTO>  select_assesCheck03(PatvalDTO dto) throws Exception;
	List<PatvalDTO>  select_assesCheck04(PatvalDTO dto) throws Exception;
	List<PatvalDTO>  select_assesCheck05(PatvalDTO dto) throws Exception;
	List<PatvalDTO>  select_assesCheck06(PatvalDTO dto) throws Exception;
	List<PatvalDTO>  select_assesCheck07(PatvalDTO dto) throws Exception;
	List<PatvalDTO>  select_assesCheck99(PatvalDTO dto) throws Exception;
	
	List<IndiDTO> select_HospitalMst(IndiDTO dto) throws Exception;
	List<IndiDTO> select_Hosp_Indi(Map<String, Object> params);
	void callLongAdmCount(Map<String, Object> params);
	Map<String, Object> calcEvalIndiValue(Map<String, Object> params);

	List<MagamDTO> selectAllHospCdList() throws Exception;

	String insGoolgleSheet(MagamDTO dto) throws Exception;
	
	MagamDTO selGoolgleSheet(MagamDTO dto) throws Exception;
	
	String modifyPatval(PatvalDTO dto) throws Exception;

	List<PatvalDTO>  select_PrevMonthMissing05(PatvalDTO dto) throws Exception;
	List<Map<String, Object>> select_ScoreCriteria(IndiDTO dto) throws Exception;

	Map<String, Object> select_PatvalMst(Map<String, Object> params) throws Exception;

	Map<String, Object> select_PatvalMstPrev(Map<String, Object> params) throws Exception;

	List<Map<String, Object>> select_PatvalChangedList(Map<String, Object> params) throws Exception;

	// 파일 검증 관련
	String uploadMagamFilesOnly(List<FilesDTO> filesData) throws Exception;
	String execMagamSP(MagamDTO magamDTO) throws Exception;
	List<Map<String, Object>> verifyFilesData(MagamDTO dto) throws Exception;
	List<Map<String, Object>> getSamfverMatch(Map<String, Object> params) throws Exception;
	List<Map<String, Object>> getSamfverAllTables(Map<String, Object> params) throws Exception;
	List<Map<String, Object>> getSamfverColumns(Map<String, Object> params) throws Exception;
}
