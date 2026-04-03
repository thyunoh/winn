package egovframework.wnn_cert.login.mapper;

import egovframework.wnn_cert.login.model.UserDTO;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import java.util.List;
import java.util.Map;

@Mapper("loginMapper")
public interface LoginMapper {

    UserDTO getLoginUser(UserDTO dto) throws Exception;

    Map<String, Object> getCompanyByHospCd(String hospCd) throws Exception;

    List<UserDTO> getUserList(UserDTO dto) throws Exception;

    boolean insertUser(UserDTO dto) throws Exception;

    boolean updateUser(UserDTO dto) throws Exception;
}
