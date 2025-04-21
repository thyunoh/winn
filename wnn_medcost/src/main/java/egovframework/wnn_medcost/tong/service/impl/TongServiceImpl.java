package egovframework.wnn_medcost.tong.service.impl;

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
import egovframework.wnn_medcost.tong.model.TongDTO;
import egovframework.wnn_medcost.tong.mapper.TongMapper;
import egovframework.wnn_medcost.tong.service.TongService;

@Service("TongService")
public class TongServiceImpl implements TongService {

	private static final Logger LOGGER = LoggerFactory.getLogger(TongServiceImpl.class);
	
	@Autowired
	private TongMapper mapper;


	public List<TongDTO> tong00List(TongDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.tong00List(dto) ;
	}


	@Override
	public List<TongDTO> tong01List(TongDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.tong01List(dto) ;
	}
	@Override
	public List<TongDTO> tong02List(TongDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.tong02List(dto) ;
	}


	@Override
	public List<TongDTO> tong03List(TongDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.tong03List(dto) ;
	}	
	@Override
	public List<TongDTO> tong04List(TongDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.tong04List(dto) ;
	}	
	@Override
	public List<TongDTO> tong05List(TongDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.tong05List(dto) ;
	}	
	@Override
	public List<TongDTO> tong06List(TongDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.tong06List(dto) ;
	}
	@Override
	public List<TongDTO> tong07List(TongDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.tong07List(dto) ;
	}

	@Override
	public List<TongDTO> tong08List(TongDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.tong08List(dto) ;
	}

	@Override
	public List<TongDTO> tong09List(TongDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.tong09List(dto) ;
	}	
}