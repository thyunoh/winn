package egovframework.wnn_medcost.user.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import com.mysql.cj.LicenseConfiguration;

import egovframework.wnn_medcost.user.model.UserDTO;
import egovframework.wnn_medcost.user.model.WardDTO;
import egovframework.wnn_medcost.user.model.DietDTO;
import egovframework.wnn_medcost.user.model.HospConDTO;
import egovframework.wnn_medcost.user.model.HospMdDTO;
import egovframework.wnn_medcost.user.model.LicnumDTO;
import egovframework.wnn_medcost.user.model.LisenceDTO;
import egovframework.wnn_medcost.user.model.MembrDTO;
import egovframework.wnn_medcost.user.model.UserAuthDTO;


@Mapper("UserMapper")
public interface UserMapper {

	UserDTO userLoginCheck(UserDTO dto)                  throws Exception;
	
	List<UserDTO> hospitalUserList(UserDTO dto)          throws Exception;
	UserDTO userInfo(UserDTO dto)                        throws Exception;

	boolean     insertUsermst(UserDTO dto)               throws Exception; 
	boolean     updateUsermst(UserDTO dto)               throws Exception; 
	String      UsermstDupChk(UserDTO dto)               throws Exception;	
	String      UseridDupChk(UserDTO dto)                throws Exception;	
	
	boolean     userPwdReset(UserDTO dto)                throws Exception;

	boolean     userPwdChange(UserDTO dto)               throws Exception;
	
	List<HospMdDTO> selHospCdList(HospMdDTO dto)         throws Exception;
	
	boolean     insertHospCdMst(HospMdDTO dto)           throws Exception; 
	boolean     updateHospCdMst(HospMdDTO dto)           throws Exception; 
	String      HospCdMstDupChk(HospMdDTO dto)           throws Exception; 	
	
	
	List<HospConDTO> selectHospContList(HospConDTO dto)  throws Exception;
	boolean          insertHospCont(HospConDTO dto)      throws Exception; 
	boolean          updateHospCont(HospConDTO dto)      throws Exception; 
	String           HospContDupChk(HospConDTO dto)      throws Exception; 
	
   //식대관리
	List<DietDTO>     getDietcdList(DietDTO dto)         throws Exception; 
	boolean           insertDietcd(DietDTO dto)          throws Exception; 
	boolean           updateDietcd(DietDTO dto)          throws Exception; 
	String            DietcdDupChk(DietDTO dto)          throws Exception; 	

	 //사용자독립정보 
	List<UserDTO>      getUserCdList(UserDTO dto)        throws Exception;
	boolean            insertUserCd(UserDTO dto)         throws Exception; 
	boolean            updateUserCd(UserDTO dto)         throws Exception; 
	String             UserCdDupChk(UserDTO dto)         throws Exception;		

	 //면하번호등록 
	List<LisenceDTO>   getLisenceCdList(LisenceDTO dto)  throws Exception;
	boolean            insertLisenceCd(LisenceDTO dto)   throws Exception; 
	boolean            updateLisenceCd(LisenceDTO dto)   throws Exception; 
	String             LisenceCdDupChk(LisenceDTO dto)   throws Exception;
	
   //병동현황관리  
	List<WardDTO>      getWardCdList(WardDTO dto)        throws Exception; 
	boolean            insertWardCd(WardDTO dto)         throws Exception; 
	boolean            updateWardCd(WardDTO dto)         throws Exception; 
	String             WardCdDupChk(WardDTO dto)         throws Exception;
	
	 //사용자 권한관리 
	List<UserAuthDTO>  getUserAuthCdList(UserAuthDTO dto) throws Exception;
	boolean            insertUserAuthCd(UserAuthDTO dto)  throws Exception; 
	boolean            updateUserAuthCd(UserAuthDTO dto)  throws Exception; 
	String             UserAuthCdDupChk(UserAuthDTO dto)  throws Exception;	
	//회원가입정보
	List<MembrDTO>     getMemberList(MembrDTO dto)        throws Exception;	
	boolean            updateMember(MembrDTO dto)         throws Exception; 
	//
	void               insertExcelDoctor(@Param("list") List<LicnumDTO> list);
	
	 //인력신고현황 
	List<LicnumDTO>    getLicNumList(LicnumDTO dto)       throws Exception;
	boolean            insertLicNum(LicnumDTO dto)        throws Exception; 
	boolean            updateLicNum(LicnumDTO dto)        throws Exception; 
	String             LicNumDupChk(LicnumDTO dto)        throws Exception;
}
                    