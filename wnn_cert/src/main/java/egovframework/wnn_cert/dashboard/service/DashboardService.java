package egovframework.wnn_cert.dashboard.service;

import egovframework.wnn_cert.eval.model.EvalDTO;
import egovframework.wnn_cert.improve.model.ImproveDTO;

import java.util.List;

public interface DashboardService {

    List<EvalDTO> getDashboardSummary(EvalDTO dto) throws Exception;

    List<ImproveDTO> getRecentImprove(ImproveDTO dto) throws Exception;
}
