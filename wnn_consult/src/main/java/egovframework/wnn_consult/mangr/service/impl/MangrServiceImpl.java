package egovframework.wnn_consult.mangr.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.wnn_consult.mangr.model.AsqDTO;
import egovframework.wnn_consult.mangr.model.FaqDTO;
import egovframework.wnn_consult.mangr.model.FileDTO;
import egovframework.wnn_consult.mangr.model.NotiDTO;
import egovframework.wnn_consult.mangr.service.MangrService;
import egovframework.wnn_consult.mangr.mapper.MangrMapper;

import org.apache.commons.net.ftp.FTP;
import org.apache.commons.net.ftp.FTPClient;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;

@Service("MangrService")
public class MangrServiceImpl implements MangrService {

	private static final Logger LOGGER = LoggerFactory.getLogger(MangrServiceImpl.class);
	
	@Autowired
	private MangrMapper mapper;

	@Override
	public List<?> selectNotiMstList(NotiDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.selectNotiMstList(dto);
	}

	@Override
	public NotiDTO selectNotiMstinfo(NotiDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.selectNotiMstinfo(dto);
	}

	@Override
	public boolean insertNotiMst(NotiDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.insertNotiMst(dto);
	}

	@Override
	public boolean updateNotiMst(NotiDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.updateNotiMst(dto);
	}

	@Override
	public boolean deleteNotiMst(NotiDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.deleteNotiMst(dto);
	}

	@Override
	public boolean updatecntNotiMst(NotiDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.updatecntNotiMst(dto);
	}

	@Override
	public List<?> selectqstnlist(AsqDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.selectqstnlist(dto);
	}

	@Override
	public boolean insertqstnMst(AsqDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.insertqstnMst(dto);
	}

	@Override
	public boolean updateqstnMst(AsqDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.updateqstnMst(dto);
	}

	@Override
	public AsqDTO selectqstnInfo(AsqDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.selectqstnInfo(dto);
	}

	@Override
	public boolean updateAnsrMst(AsqDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.updateAnsrMst(dto);
	}

	@Override
	public List<FaqDTO> selectfaqlist(FaqDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.selectfaqlist(dto);
	}
	@Override
	public FaqDTO selectfaqInfo(FaqDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.selectfaqInfo(dto);
	}

	@Override
	public List<AsqDTO> getasqCdList(AsqDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.getasqCdList(dto);
	}

	@Override
	public boolean updatedelasqCd(AsqDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.updatedelasqCd(dto);
	}

	@Override
	public List<FileDTO> getFileCdList(FileDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.getFileCdList(dto);
	}
}