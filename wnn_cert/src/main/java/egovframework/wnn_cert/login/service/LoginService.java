package egovframework.wnn_cert.login.service;

import egovframework.wnn_cert.login.model.UserDTO;

import java.util.List;

public interface LoginService {

    UserDTO getLoginUser(UserDTO dto) throws Exception;

    List<UserDTO> getUserList(UserDTO dto) throws Exception;

    boolean insertUser(UserDTO dto) throws Exception;

    boolean updateUser(UserDTO dto) throws Exception;
}
