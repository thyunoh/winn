package egovframework.wnn_cert.dashboard.web;

import egovframework.wnn_cert.dashboard.service.DashboardService;
import egovframework.wnn_cert.eval.model.EvalDTO;
import egovframework.wnn_cert.improve.model.ImproveDTO;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/dashboard")
public class DashboardController {

    @Resource(name = "DashboardService")
    private DashboardService dashboardService;

    @RequestMapping("/dashboardMain.do")
    public String dashboardMain() {
        return ".main/dashboard/dashboardMain";
    }

    @RequestMapping(value = "/getDashboardData.do", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> getDashboardData(EvalDTO evalDto, ImproveDTO improveDto) {
        Map<String, Object> resultMap = new HashMap<>();
        try {
            List<EvalDTO> summary = dashboardService.getDashboardSummary(evalDto);
            List<ImproveDTO> recentImprove = dashboardService.getRecentImprove(improveDto);

            Map<String, Object> data = new HashMap<>();
            data.put("summary", summary);
            data.put("recentImprove", recentImprove);

            resultMap.put("result", "success");
            resultMap.put("data", data);
        } catch (Exception e) {
            resultMap.put("result", "fail");
            resultMap.put("msg", e.getMessage());
        }
        return resultMap;
    }
}
