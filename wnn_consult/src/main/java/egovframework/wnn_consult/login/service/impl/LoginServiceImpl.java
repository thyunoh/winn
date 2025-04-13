package egovframework.wnn_consult.login.service.impl;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.wnn_consult.login.mapper.LoginMapper;
import egovframework.wnn_consult.login.service.LoginService;


@Service("LoginService")
public class LoginServiceImpl implements LoginService {
	@Resource(name = "LoginMapper")
	private LoginMapper loginMapper;

	@Override
	public int connectionTest() {
		System.out.println("IMPL");
		return loginMapper.connectionTest();
	}

}