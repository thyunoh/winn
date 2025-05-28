package egovframework.wnn_consult.user.service.impl;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.wnn_consult.user.mapper.UserMapper;
import egovframework.wnn_consult.user.model.HospMdDTO;
import egovframework.wnn_consult.user.model.MberDTO;
import egovframework.wnn_consult.user.model.UserDTO;
import egovframework.wnn_consult.user.service.UserService;


@Service("UserService")
public class UserServiceImpl implements UserService {

	private static final Logger LOGGER = LoggerFactory.getLogger(UserServiceImpl.class);
	
	@Autowired
	private UserMapper mapper;

	@Override
	public UserDTO userLoginCheck(UserDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.userLoginCheck(dto);
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

	@Override
	public UserDTO UsernmInfo(UserDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.UsernmInfo(dto);
	}

	@Override
	public UserDTO UserPasswdInfo(UserDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.UserPasswdInfo(dto);
	}

	@Override
	public boolean UserPasswdChange(UserDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.UserPasswdChange(dto);
	}

	@Override
	public List<?> selHospList(HospMdDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.selHospList(dto);
	}

	@Override
	public List<?> selHospsumList(HospMdDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.selHospsumList(dto);
	}

	@Override
	public HospMdDTO HospInfo(HospMdDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.HospInfo(dto);
	}

	@Override
	public boolean insertHosp(HospMdDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.insertHosp(dto);
	}

	@Override
	public boolean updateHosp(HospMdDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.updateHosp(dto);
	}

	@Override
	public boolean deleteHosp(HospMdDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.deleteHosp(dto);
	}

	@Override
	public boolean insertHospDtlMonlyList(HospMdDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.insertHospDtlMonlyList(dto);
	}

	@Override
	public HospMdDTO getHospmst(HospMdDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.getHospmst(dto);
	}

	@Override
	public boolean insertMember(MberDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.insertMember(dto);
	}

	@Override
	public String selMberDupChk(MberDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.selMberDupChk(dto);
	}

	@Override
	public List<?> selectMbrList(MberDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.selectMbrList(dto);
	}

	@Override
	public MberDTO selectMbrInfo(MberDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.selectMbrInfo(dto);
	}

	@Override
	public boolean updateMember(MberDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.updateMember(dto);
	}

	@Override
	public List<?> getMbrList(MberDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.getMbrList(dto);
	}

	@Override
	public boolean insertUser(UserDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.insertUser(dto);
	}

	@Override
	public boolean updateUser(UserDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.updateUser(dto);
	}

	@Override
	public boolean deleteUser(UserDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.deleteUser(dto);
	}

	@Override
	public boolean insertmbrUser(MberDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.insertmbrUser(dto);
	}

	@Override
	public String UserDupChk(MberDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.UserDupChk(dto);
	}
	//최종접속정보 업데이트 
	@Override
	public boolean Last_updateHOSP(UserDTO dto) throws Exception {
        return mapper.Last_updateHOSP(dto);
	}

	@Override
	public List<UserDTO> getReportList(UserDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.getReportList(dto);
	}

}