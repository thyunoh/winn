package egovframework.wnn_cert.improve.mapper;

import egovframework.wnn_cert.improve.model.ImproveDTO;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import java.util.List;

@Mapper("improveMapper")
public interface ImproveMapper {

    List<ImproveDTO> getImproveList(ImproveDTO dto) throws Exception;

    ImproveDTO getImproveInfo(ImproveDTO dto) throws Exception;

    boolean insertImprove(ImproveDTO dto) throws Exception;

    boolean updateImprove(ImproveDTO dto) throws Exception;

    boolean deleteImprove(ImproveDTO dto) throws Exception;
}
