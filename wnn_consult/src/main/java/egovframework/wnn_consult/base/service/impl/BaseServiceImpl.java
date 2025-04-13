package egovframework.wnn_consult.base.service.impl;

import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.wnn_consult.base.mapper.BaseMapper;
import egovframework.wnn_consult.base.model.CodeMdDTO;
import egovframework.wnn_consult.base.service.BaseService;


@Service("BaseService")
public class BaseServiceImpl implements BaseService {

	private static final Logger LOGGER = LoggerFactory.getLogger(BaseServiceImpl.class);
	
	@Autowired
	private BaseMapper mapper;

	@Override
	public List<?> selCommMstList(CodeMdDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.selCommMstList(dto);
	}

	@Override
	public String selCommMstDupChk(CodeMdDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.selCommMstDupChk(dto);
	}

	@Override
	public boolean insertCommMst(CodeMdDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.insertCommMst(dto) ;
	}

	@Override
	public boolean updateCommMst(CodeMdDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.updateCommMst(dto) ; 
	}
	@Override
	public boolean deleteCommMst(CodeMdDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.deleteCommMst(dto);
	}

	@Override
	public List<?> selectCodeDetailList(CodeMdDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.selectCodeDetailList(dto);
	}

	@Override
	public List<?> selCommDetailList(CodeMdDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.selCommDetailList(dto);
	}

	@Override
	public String selCommDetailDupChk(CodeMdDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.selCommDetailDupChk(dto);
	}

	@Override
	public boolean insertCommDetail(CodeMdDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.insertCommDetail(dto);
	}

	@Override
	public boolean updateCommDetail(CodeMdDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.updateCommDetail(dto);
	}

	@Override
	public boolean deleteCommDetail(CodeMdDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.deleteCommDetail(dto);
	}

	@Override
	public List<?> selCommDtlInfo(CodeMdDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.selCommDtlInfo(dto);
	}
}