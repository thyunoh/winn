package egovframework.wnn_medcost.mangr.service.impl;

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
import org.springframework.web.multipart.MultipartFile;

import egovframework.wnn_medcost.base.model.CodeMdDTO;
import egovframework.wnn_medcost.mangr.mapper.MangrMapper;
import egovframework.wnn_medcost.mangr.model.AsqDTO;
import egovframework.wnn_medcost.mangr.model.ChartDTO;
import egovframework.wnn_medcost.mangr.model.FaqDTO;
import egovframework.wnn_medcost.mangr.model.FileDTO;
import egovframework.wnn_medcost.mangr.model.NotiDTO;
import egovframework.wnn_medcost.mangr.service.MangrService;
import egovframework.wnn_medcost.user.model.LisenceDTO;

@Service("MangrService")
public class MangrServiceImpl implements MangrService {

	private static final Logger LOGGER = LoggerFactory.getLogger(MangrServiceImpl.class);
	
	@Autowired
	private MangrMapper mapper;

	public List<CodeMdDTO> getCommList(List<String> codeGbList, List<String> codeCdList) {
        
        try {
        	// 파라미터를 Map 형태로 준비
            Map<String, Object> params = new HashMap<>();
            
            params.put("codeGbList", codeGbList);
            params.put("codeCdList", codeCdList);
            
            return mapper.getCommList(params);
            
        } catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList(); // 빈 리스트 반환
        }
    }

	@Override
	public List<FaqDTO> getfaqCdList(FaqDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.getfaqCdList(dto) ;
	}

	@Override
	public boolean insertfaqCd(FaqDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.insertfaqCd(dto) ;
	}

	@Override
	public boolean updatefaqCd(FaqDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.updatefaqCd(dto) ;
	}

	@Override
	public String faqCdDupChk(FaqDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.faqCdDupChk(dto) ;
	}

	@Override
	public List<NotiDTO> getnotiCdList(NotiDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.getnotiCdList(dto) ;
	}

	@Override
	public int insertnotiCd(NotiDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.insertnotiCd(dto) ;
	}

	@Override
	public boolean updatenotiCd(NotiDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.updatenotiCd(dto) ;
	}

	@Override
	public String notiCdDupChk(NotiDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.notiCdDupChk(dto) ;
	}
  //문서등록 
	@Override
	public int insertFileCd(FileDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.insertFileCd(dto) ;
	}

	@Override
	public boolean updateFileCd(FileDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.updateFileCd(dto) ;
	}

	@Override
	public boolean updateFilePath(FileDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.updateFilePath(dto) ;
	}

	@Override
	public List<AsqDTO> getasqCdList(AsqDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.getasqCdList(dto) ;
	}

	@Override
	public boolean insertasqCd(AsqDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.insertasqCd(dto) ;
	}

	@Override
	public boolean updateasqCd(AsqDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.updateasqCd(dto) ;
	}

	@Override
	public String asqCdDupChk(AsqDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.asqCdDupChk(dto) ;
	}

	@Override
	public void saveFile(String fileName, String filePath, String hospCd ,  
    		      String fileGb, String notiSeq ,  String regUser, String regIp , String fileSize) {
        FileDTO dto = new FileDTO();
        dto.setHospCd(hospCd);
        dto.setFileGb(fileGb);
        dto.setFileSeq(notiSeq);
        dto.setFileTitle(fileName);
        dto.setFilePath(filePath.toString());
        dto.setRegUser(regUser);
        dto.setRegIp(regIp);
        dto.setFileSize(fileSize);

        try {
			mapper.saveFileCd(dto);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} // ✅ DB 저장
    }

	@Override
	public List<FileDTO> getFileCdList(FileDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.getFileCdList(dto) ;
	}

	@Override
	public void deleteFile(String hospCd , String  filePath , String fileSeq 
			                             , String fileGb , String updUser , String  updIp ) { 
		FileDTO dto = new FileDTO();
        dto.setFileGb(fileGb);
        dto.setFileSeq(fileSeq);
        dto.setFilePath(filePath.toString());
        dto.setUpdUser(updUser);
        dto.setUpdIp(updIp);
		try {
			mapper.deleteFileCd(dto) ;
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	@Override
	public List<AsqDTO> selectqstnlist(AsqDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.selectqstnlist(dto) ;
	}

	@Override
	public AsqDTO selectqstnInfo(AsqDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.selectqstnInfo(dto) ;
	}

	@Override
	public boolean updateQstnCd(AsqDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.updateQstnCd(dto) ;
	}
}