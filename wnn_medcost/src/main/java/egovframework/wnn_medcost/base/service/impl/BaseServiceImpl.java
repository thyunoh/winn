package egovframework.wnn_medcost.base.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Collections;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.wnn_medcost.base.mapper.BaseMapper;
import egovframework.wnn_medcost.base.model.ClaimDTO;
import egovframework.wnn_medcost.base.model.CodeMdDTO;
import egovframework.wnn_medcost.base.model.DiseCdDTO;
import egovframework.wnn_medcost.base.model.JearyoCdDTO;
import egovframework.wnn_medcost.base.model.SamverDTO;
import egovframework.wnn_medcost.base.model.SugaCdDTO;
import egovframework.wnn_medcost.base.model.WvalDTO;
import egovframework.wnn_medcost.base.model.YakgaCdDTO;
import egovframework.wnn_medcost.base.service.BaseService;

@Service("BaseService")
public class BaseServiceImpl implements BaseService {

	private static final Logger LOGGER = LoggerFactory.getLogger(BaseServiceImpl.class);
	
	@Autowired
	private BaseMapper mapper;

	@Override
	public List<SugaCdDTO> getSugaCdList(SugaCdDTO dto) throws Exception {

		return mapper.getSugaCdList(dto);
	}
	
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
	public boolean insertSugaCdMst(SugaCdDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.insertSugaCdMst(dto);
	}


	@Override
	public boolean updateSugaCdMst(SugaCdDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.updateSugaCdMst(dto);
	}

	@Override
	public String SugaCdMstDupChk(SugaCdDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.SugaCdMstDupChk(dto);
	}
	@Override
	public List<DiseCdDTO> getDiseCdList(DiseCdDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.getDiseCdList(dto);
	}

	@Override
	public boolean insertDiseCdMst(DiseCdDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.insertDiseCdMst(dto);
	}

	@Override
	public boolean updateDiseCdMst(DiseCdDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.updateDiseCdMst(dto);
	}

	@Override
	public String DiseCdMstDupChk(DiseCdDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.DiseCdMstDupChk(dto);
	}

	@Override
	public List<CodeMdDTO> getCommMstList(CodeMdDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.getCommMstList(dto);
	}

	@Override
	public boolean insertCommMst(CodeMdDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.insertCommMst(dto);
	}

	@Override
	public boolean updateCommMst(CodeMdDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.updateCommMst(dto);
	}

	@Override
	public String CommMstDupChk(CodeMdDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.CommMstDupChk(dto);
	}

	@Override
	public List<CodeMdDTO> getCodeDtlList(CodeMdDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.getCodeDtlList(dto);
	}

	@Override
	public boolean insertCommDtl(CodeMdDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.insertCommDtl(dto);
	}

	@Override
	public boolean updateCommDtl(CodeMdDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.updateCommDtl(dto);
	}

	@Override
	public String CommDtlDupChk(CodeMdDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.CommDtlDupChk(dto);
	}

	@Override
	public List<WvalDTO> getWvalueList(WvalDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.getWvalueList(dto);
	}

	@Override
	public boolean insertWvalue(WvalDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.insertWvalue(dto);
	}

	@Override
	public boolean updateWvalue(WvalDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.updateWvalue(dto);
	}

	@Override
	public String WvalueDupChk(WvalDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.WvalueDupChk(dto);
	}

	@Override
	public List<SamverDTO> getsamverCdlist(SamverDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.getsamverCdlist(dto);
	}

	@Override
	public boolean insertsamverCd(SamverDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.insertsamverCd(dto);
	}

	@Override
	public boolean updatesamverCd(SamverDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.updatesamverCd(dto);
	}

	@Override
	public String samverCdDupChk(SamverDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.samverCdDupChk(dto);
	}

	@Override
	public List<YakgaCdDTO> getYakgaCdList(YakgaCdDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.getYakgaCdList(dto);
	}

	@Override
	public boolean updateYakCdMst(YakgaCdDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.updateYakCdMst(dto);
	}

	@Override
	public List<JearyoCdDTO> getJaeryoCdList(JearyoCdDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.getJaeryoCdList(dto);
	}

	@Override
	public List<ClaimDTO> getclaimCdList(ClaimDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.getclaimCdList(dto);
	}

	@Override
	public boolean insertclaimCd(ClaimDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.insertclaimCd(dto);
	}

	@Override
	public boolean updateclaimCd(ClaimDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.updateclaimCd(dto);
	}

	@Override
	public String claimCdDupChk(ClaimDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.claimCdDupChk(dto);
	}


}