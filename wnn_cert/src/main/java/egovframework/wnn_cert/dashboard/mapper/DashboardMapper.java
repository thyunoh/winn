package egovframework.wnn_cert.dashboard.mapper;

import egovframework.wnn_cert.eval.model.EvalDTO;
import egovframework.wnn_cert.improve.model.ImproveDTO;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import java.util.List;

@Mapper("dashboardMapper")
public interface DashboardMapper {

    List<EvalDTO> getDashboardSummary(EvalDTO dto) throws Exception;

    List<ImproveDTO> getRecentImprove(ImproveDTO dto) throws Exception;
}
