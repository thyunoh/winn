package egovframework.wnn_cert.eval.service;

import egovframework.wnn_cert.eval.model.EvalDTO;
import egovframework.wnn_cert.eval.model.EvalDtlDTO;

import java.util.List;

public interface EvalService {

    List<EvalDTO> getEvalList(EvalDTO dto) throws Exception;

    EvalDTO getEvalInfo(EvalDTO dto) throws Exception;

    boolean insertEval(EvalDTO dto) throws Exception;

    boolean updateEval(EvalDTO dto) throws Exception;

    List<EvalDtlDTO> getEvalDtlList(EvalDtlDTO dto) throws Exception;

    boolean insertEvalDtl(EvalDtlDTO dto) throws Exception;

    boolean updateEvalDtl(EvalDtlDTO dto) throws Exception;

    List<EvalDTO> getEvalScoreSummary(EvalDTO dto) throws Exception;
}
