package egovframework.wnn_medcost.magam.mapper;

import java.util.Map;
import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import egovframework.wnn_medcost.magam.model.MagamDTO;
import egovframework.wnn_medcost.magam.model.PatvalDTO;
import egovframework.wnn_medcost.magam.model.FilesDTO;
import egovframework.wnn_medcost.magam.model.IpwonDTO;
import egovframework.wnn_medcost.magam.model.SpcsugaDTO;
import egovframework.wnn_medcost.magam.model.IndiDTO;




@Mapper("MagamMapper")
public interface MagamMapper {	
	
	List<MagamDTO> getMagamYearList(MagamDTO dto);
	
	List<MagamDTO> magamGetFileList(MagamDTO dto);

	List<?> selectMagamCheck(MagamDTO dto);
	
	int  uploadMagamFilesMain(List<FilesDTO> filesList);

	// ACTION_YN='N' 으로 비활성화된 SPECODE(특정내역) 코드 목록 (TBL_FILES_DATA 저장 제외 대상)
	List<String> getSpecodeExclCodes();

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

	int insertSpcsugaInfo(List<SpcsugaDTO> spcsugaData);
	int deleteSpcsugaInfo(SpcsugaDTO spcsugaData);
	
	int  AdmMagamInsert(MagamDTO dto);
	
	String create_Eval_Indi(IndiDTO dto);
	
	List<IndiDTO> select_Eval_Indi(IndiDTO dto);

	// ===== 적정성평가 컨설팅 월보고서 (TBL_EVAL_REPORT_*) =====
	Long selectEvalReportSeq(@Param("hospCd") String hospCd, @Param("evalYm") String evalYm);
	Map<String, Object> selectEvalReportMst(@Param("hospCd") String hospCd, @Param("evalYm") String evalYm);
	// 차등제 등록(TBL_GRADE_MST) 목표점수/병원등급 — 월보고서 목표값 기본소스
	Map<String, Object> selectHospGoalGrade(@Param("hospCd") String hospCd,
	                                        @Param("startYy") String startYy,
	                                        @Param("qterFlag") String qterFlag);
	List<Map<String, Object>> selectEvalReportTexts(@Param("reportSeq") Long reportSeq);
	// 전사 표준문구(TPL) — 병원 공통 기본 문구 (우선순위: 병원별 TEXT > TPL > JSP 내장 기본값)
	List<Map<String, Object>> selectEvalReportTpls();
	int insertEvalReportMst(Map<String, Object> p);
	int updateEvalReportMst(Map<String, Object> p);
	int approveEvalReportMst(Map<String, Object> p);
	int cancelApproveEvalReportMst(Map<String, Object> p);
	int updateEvalReportPdf(Map<String, Object> p);
	int deleteEvalReportTexts(@Param("reportSeq") Long reportSeq);
	int insertEvalReportTexts(@Param("reportSeq") Long reportSeq,
	                          @Param("texts") List<Map<String, Object>> texts,
	                          @Param("updUser") String updUser);

	List<Map<String, Object>> select_EvalProgress(IndiDTO dto);   // 자료생성 진행상태(항목별)
	
	List<PatvalDTO>  select_CategoryList05(PatvalDTO dto);
	List<PatvalDTO>  select_PrevMonthMissing05(PatvalDTO dto);
	List<PatvalDTO>  select_CategoryList06(PatvalDTO dto);
	List<PatvalDTO>  select_CategoryList07(PatvalDTO dto);
	List<PatvalDTO>  select_DiagRank07(PatvalDTO dto);
	List<PatvalDTO>  select_DiagNames(java.util.Map<String, Object> param);
	List<PatvalDTO>  select_CategoryList09(PatvalDTO dto);
	List<PatvalDTO>  select_CategoryList10(PatvalDTO dto);
	List<PatvalDTO>  select_CategoryList11(PatvalDTO dto);
	List<PatvalDTO>  select_CategoryList12(PatvalDTO dto);
	List<PatvalDTO>  select_CategoryList13(PatvalDTO dto);
	List<PatvalDTO>  select_CategoryList14(PatvalDTO dto);
	
	List<PatvalDTO>  select_CathCrossCheck(PatvalDTO dto);

	List<Map<String, Object>> select_CathPatvalByPat(Map<String, Object> params);
	List<Map<String, Object>> select_CathSpcsugaByPat(Map<String, Object> params);

	List<PatvalDTO>  select_assesCheck00(PatvalDTO dto);
	List<PatvalDTO>  select_assesCheck01(PatvalDTO dto);
	List<PatvalDTO>  select_assesCheck02(PatvalDTO dto);
	List<PatvalDTO>  select_assesCheck03(PatvalDTO dto);
	List<PatvalDTO>  select_assesCheck04(PatvalDTO dto);
	List<PatvalDTO>  select_assesCheck05(PatvalDTO dto);
	List<PatvalDTO>  select_assesCheck06(PatvalDTO dto);
	List<PatvalDTO>  select_assesCheck07(PatvalDTO dto);
	List<PatvalDTO>  select_assesCheck99(PatvalDTO dto);
	
	List<IndiDTO> select_HospitalMst(IndiDTO dto);
	List<IndiDTO> select_Hosp_Indi(Map<String, Object> params);
	void callLongAdmCount(Map<String, Object> params);
	Map<String, Object> calcEvalIndiValue(Map<String, Object> params);

	List<MagamDTO> selectAllHospCdList();

	String insGoolgleSheet(MagamDTO dto);
	MagamDTO selGoolgleSheet(MagamDTO dto);
	
	String modifyPatval(PatvalDTO dto);

	List<Map<String, Object>> select_ScoreCriteria(IndiDTO dto);

	Map<String, Object> select_PatvalMst(Map<String, Object> params);

	Map<String, Object> select_PatvalMstPrev(Map<String, Object> params);

	List<Map<String, Object>> select_PatvalChangedList(Map<String, Object> params);

	// 파일 검증 관련
	List<Map<String, Object>> getFilesFirstLine(MagamDTO dto);
	List<Map<String, Object>> getSamfverMatch(Map<String, Object> params);
	List<Map<String, Object>> getSamfverAllTables(Map<String, Object> params);
	List<Map<String, Object>> getSamfverColumns(Map<String, Object> params);
}
