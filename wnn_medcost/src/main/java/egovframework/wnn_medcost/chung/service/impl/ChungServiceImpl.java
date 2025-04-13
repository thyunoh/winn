package egovframework.wnn_medcost.chung.service.impl;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.Collections;

import javax.annotation.Resource;
import javax.servlet.http.Part;
import javax.transaction.Transactional;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import egovframework.wnn_medcost.chung.model.ChungDTO;
import egovframework.wnn_medcost.chung.mapper.ChungMapper;
import egovframework.wnn_medcost.chung.service.ChungService;

@Service("ChungService")
public class ChungServiceImpl implements ChungService {

	private static final Logger LOGGER = LoggerFactory.getLogger(ChungServiceImpl.class);
	
	@Autowired
	private ChungMapper mapper;

	@Override
	public List<ChungDTO> chungList(ChungDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.chungList(dto) ;
	}

	@Override
	public List<ChungDTO> myoungList(ChungDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.myoungList(dto) ;
	}

	@Override
	public List<ChungDTO> diseList(ChungDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.diseList(dto) ;
	}

	@Override
	public List<ChungDTO> jinordList(ChungDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.jinordList(dto) ;
	}

	@Override
	public List<ChungDTO> hangList(ChungDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.hangList(dto) ;
	}

	@Override
	public List<ChungDTO> spcList(ChungDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.spcList(dto) ;
	}
}