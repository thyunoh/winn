package egovframework.wnn_cert.login.service.impl;

import egovframework.wnn_cert.login.mapper.LoginMapper;
import egovframework.wnn_cert.login.model.UserDTO;
import egovframework.wnn_cert.login.service.LoginService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service("LoginService")
public class LoginServiceImpl implements LoginService {

    @Autowired
    private LoginMapper loginMapper;

    @Override
    public UserDTO getLoginUser(UserDTO dto) throws Exception {
        return loginMapper.getLoginUser(dto);
    }

    @Override
    public Map<String, Object> getCompanyByHospCd(String hospCd) throws Exception {
        return loginMapper.getCompanyByHospCd(hospCd);
    }

    @Override
    public List<UserDTO> getUserList(UserDTO dto) throws Exception {
        return loginMapper.getUserList(dto);
    }

    @Override
    public boolean insertUser(UserDTO dto) throws Exception {
        return loginMapper.insertUser(dto);
    }

    @Override
    public boolean updateUser(UserDTO dto) throws Exception {
        return loginMapper.updateUser(dto);
    }
}
