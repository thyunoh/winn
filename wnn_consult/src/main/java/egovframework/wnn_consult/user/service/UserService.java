package egovframework.wnn_consult.user.service;

import java.util.List;

import egovframework.wnn_consult.user.model.HospMdDTO;
import egovframework.wnn_consult.user.model.MberDTO;
import egovframework.wnn_consult.user.model.UserDTO;

public interface UserService {
	UserDTO userLoginCheck(UserDTO dto) throws Exception;

	UserDTO userInfo(UserDTO dto) throws Exception;

	boolean userPwdReset(UserDTO dto) throws Exception;

	boolean userPwdChange(UserDTO dto) throws Exception;

	UserDTO   UsernmInfo(UserDTO dto)         throws Exception;
	UserDTO   UserPasswdInfo(UserDTO dto)    throws Exception;
	boolean   UserPasswdChange(UserDTO dto)  throws Exception;	
	boolean   insertUser(UserDTO dto)        throws Exception;
	boolean   updateUser(UserDTO dto)        throws Exception;	
	boolean   deleteUser(UserDTO dto)        throws Exception;	
	boolean   insertmbrUser (MberDTO dto)    throws Exception;
	String    UserDupChk (MberDTO dto)       throws Exception;	
	
	List<?>   selHospList(HospMdDTO dto)    throws Exception; 
	List<?>   selHospsumList(HospMdDTO dto) throws Exception; 
	HospMdDTO   HospInfo(HospMdDTO dto)     throws Exception;
	boolean   insertHosp(HospMdDTO dto)     throws Exception; 
	boolean   updateHosp(HospMdDTO dto)     throws Exception; 
	boolean   deleteHosp(HospMdDTO dto)     throws Exception; 	
	boolean   insertHospDtlMonlyList(HospMdDTO dto)  throws Exception; 
	HospMdDTO getHospmst(HospMdDTO dto)    throws Exception;
	
	boolean   insertMember(MberDTO dto)      throws Exception; 
	String    selMberDupChk(MberDTO dto)     throws Exception; 
	List<?>   selectMbrList(MberDTO dto)     throws Exception; 
	MberDTO   selectMbrInfo(MberDTO dto)     throws Exception; 
	boolean   updateMember(MberDTO dto)      throws Exception;
	List<?>   getMbrList(MberDTO dto)        throws Exception;	

}