package egovframework.wnn_cert.dashboard.service.impl;

import egovframework.wnn_cert.dashboard.mapper.DashboardMapper;
import egovframework.wnn_cert.dashboard.service.DashboardService;
import egovframework.wnn_cert.eval.model.EvalDTO;
import egovframework.wnn_cert.improve.model.ImproveDTO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service("DashboardService")
public class DashboardServiceImpl implements DashboardService {

    @Autowired
    private DashboardMapper dashboardMapper;

    @Override
    public List<EvalDTO> getDashboardSummary(EvalDTO dto) throws Exception {
        return dashboardMapper.getDashboardSummary(dto);
    }

    @Override
    public List<ImproveDTO> getRecentImprove(ImproveDTO dto) throws Exception {
        return dashboardMapper.getRecentImprove(dto);
    }
}
