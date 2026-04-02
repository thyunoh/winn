package egovframework.wnn_cert.eval.service.impl;

import egovframework.wnn_cert.eval.mapper.EvalMapper;
import egovframework.wnn_cert.eval.model.EvalDTO;
import egovframework.wnn_cert.eval.model.EvalDtlDTO;
import egovframework.wnn_cert.eval.service.EvalService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service("EvalService")
public class EvalServiceImpl implements EvalService {

    @Autowired
    private EvalMapper evalMapper;

    @Override
    public List<EvalDTO> getEvalList(EvalDTO dto) throws Exception {
        return evalMapper.getEvalList(dto);
    }

    @Override
    public EvalDTO getEvalInfo(EvalDTO dto) throws Exception {
        return evalMapper.getEvalInfo(dto);
    }

    @Override
    public boolean insertEval(EvalDTO dto) throws Exception {
        return evalMapper.insertEval(dto);
    }

    @Override
    public boolean updateEval(EvalDTO dto) throws Exception {
        return evalMapper.updateEval(dto);
    }

    @Override
    public List<EvalDtlDTO> getEvalDtlList(EvalDtlDTO dto) throws Exception {
        return evalMapper.getEvalDtlList(dto);
    }

    @Override
    public boolean insertEvalDtl(EvalDtlDTO dto) throws Exception {
        return evalMapper.insertEvalDtl(dto);
    }

    @Override
    public boolean updateEvalDtl(EvalDtlDTO dto) throws Exception {
        return evalMapper.updateEvalDtl(dto);
    }

    @Override
    public List<EvalDTO> getEvalScoreSummary(EvalDTO dto) throws Exception {
        return evalMapper.getEvalScoreSummary(dto);
    }
}
