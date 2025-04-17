package egovframework.wnn_medcost.user.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.wnn_medcost.base.model.CodeMdDTO;
import egovframework.wnn_medcost.user.mapper.UserMapper;
import egovframework.wnn_medcost.user.model.HospConDTO;
import egovframework.wnn_medcost.user.model.HospMdDTO;
import egovframework.wnn_medcost.user.model.LisenceDTO;
import egovframework.wnn_medcost.user.model.MembrDTO;
import egovframework.wnn_medcost.user.model.UserAuthDTO;
import egovframework.wnn_medcost.user.model.UserDTO;
import egovframework.wnn_medcost.user.model.WardDTO;
import egovframework.wnn_medcost.user.model.DietDTO;
import egovframework.wnn_medcost.user.service.UserService;


@Service("UserService")
public class UserServiceImpl implements UserService {

	private static final Logger LOGGER = LoggerFactory.getLogger(UserServiceImpl.class);
	
	@Autowired
	private UserMapper mapper;
   /*  공통코드 상속받아씁니다*/
	
	public interface BaseService {
	    List<CodeMdDTO> getCommList(List<String> codeGbList, List<String> codeCdList);
	}
	
	@Override
	public UserDTO userLoginCheck(UserDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.userLoginCheck(dto);
	}

	@Override
	public List<UserDTO> hospitalUserList(UserDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.hospitalUserList(dto);
	}

	@Override
	public UserDTO userInfo(UserDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.userInfo(dto);
	}

	@Override
	public boolean userPwdReset(UserDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.userPwdReset(dto);
	}

	@Override
	public boolean userPwdChange(UserDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.userPwdChange(dto);
	}
  //계약관리 
	@Override
	public List<HospMdDTO> selHospCdList(HospMdDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.selHospCdList(dto) ;
	}

	@Override
	public boolean insertHospCdMst(HospMdDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.insertHospCdMst(dto) ;
	}

	@Override
	public boolean updateHospCdMst(HospMdDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.updateHospCdMst(dto) ;
	}

	@Override
	public String HospCdMstDupChk(HospMdDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.HospCdMstDupChk(dto) ;
	}

	@Override
	public List<HospConDTO> selectHospContList(HospConDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.selectHospContList(dto) ;
	}

	@Override
	public boolean insertHospCont(HospConDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.insertHospCont(dto) ;
	}

	@Override
	public boolean updateHospCont(HospConDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.updateHospCont(dto) ;
	}

	@Override
	public String HospContDupChk(HospConDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.HospContDupChk(dto) ;
	}
    //사용자등록관리 
	@Override
	public boolean insertUsermst(UserDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.insertUsermst(dto) ;
	}

	@Override
	public boolean updateUsermst(UserDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.updateUsermst(dto) ;
	}

	@Override
	public String UsermstDupChk(UserDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.UsermstDupChk(dto) ;
	}

	@Override
	public String UseridDupChk(UserDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.UseridDupChk(dto) ;
	}
    //가산식 관리 
	@Override
	public List<DietDTO> getDietcdList(DietDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.getDietcdList(dto) ;
	}

	@Override
	public boolean insertDietcd(DietDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.insertDietcd(dto) ;
	}

	@Override
	public boolean updateDietcd(DietDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.updateDietcd(dto) ;
	}

	@Override
	public String DietcdDupChk(DietDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.DietcdDupChk(dto) ;
	}
    //사용자 등록관리 
	@Override
	public List<UserDTO> getUserCdList(UserDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.getUserCdList(dto) ;
	}

	@Override
	public boolean insertUserCd(UserDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.insertUserCd(dto) ;
	}

	@Override
	public boolean updateUserCd(UserDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.updateUserCd(dto) ;
	}

	@Override
	public String UserCdDupChk(UserDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.UserCdDupChk(dto) ;
	}
    //면허등록관리  
	@Override
	public List<LisenceDTO> getLisenceCdList(LisenceDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.getLisenceCdList(dto) ;
	}
	@Override
	public boolean insertLisenceCd(LisenceDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.insertLisenceCd(dto) ;
	}

	@Override
	public boolean updateLisenceCd(LisenceDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.updateLisenceCd(dto) ;
	}

	@Override
	public String LisenceCdDupChk(LisenceDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.LisenceCdDupChk(dto) ;
	}

	//병동현황관리  
	@Override
	public List<WardDTO> getWardCdList(WardDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.getWardCdList(dto) ;
	}

	@Override
	public boolean insertWardCd(WardDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.insertWardCd(dto) ; 
	}
	@Override
	public boolean updateWardCd(WardDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.updateWardCd(dto) ; 
	}

	@Override
	public String WardCdDupChk(WardDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.WardCdDupChk(dto) ; 
	}

	@Override
	public List<UserAuthDTO> getUserAuthCdList(UserAuthDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.getUserAuthCdList(dto) ; 
	}

	@Override
	public boolean insertUserAuthCd(UserAuthDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.insertUserAuthCd(dto) ; 
	}

	@Override
	public boolean updateUserAuthCd(UserAuthDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.updateUserAuthCd(dto) ; 
	}

	@Override
	public String UserAuthCdDupChk(UserAuthDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.UserAuthCdDupChk(dto) ; 
	}

	@Override
	public List<MembrDTO> getMemberList(MembrDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.getMemberList(dto) ; 
	}

	@Override
	public boolean updateMember(MembrDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.updateMember(dto) ; 
	}
}