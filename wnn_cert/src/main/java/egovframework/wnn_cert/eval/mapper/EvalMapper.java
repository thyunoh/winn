package egovframework.wnn_cert.eval.mapper;

import egovframework.wnn_cert.eval.model.EvalDTO;
import egovframework.wnn_cert.eval.model.EvalDtlDTO;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import java.util.List;

@Mapper("evalMapper")
public interface EvalMapper {

    List<EvalDTO> getEvalList(EvalDTO dto) throws Exception;

    EvalDTO getEvalInfo(EvalDTO dto) throws Exception;

    boolean insertEval(EvalDTO dto) throws Exception;

    boolean updateEval(EvalDTO dto) throws Exception;

    List<EvalDtlDTO> getEvalDtlList(EvalDtlDTO dto) throws Exception;

    boolean insertEvalDtl(EvalDtlDTO dto) throws Exception;

    boolean updateEvalDtl(EvalDtlDTO dto) throws Exception;

    List<EvalDTO> getEvalScoreSummary(EvalDTO dto) throws Exception;
}
