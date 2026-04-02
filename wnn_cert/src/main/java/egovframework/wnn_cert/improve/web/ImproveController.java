package egovframework.wnn_cert.improve.web;

import egovframework.wnn_cert.improve.model.ImproveDTO;
import egovframework.wnn_cert.improve.service.ImproveService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/improve")
public class ImproveController {

    @Resource(name = "ImproveService")
    private ImproveService improveService;

    @RequestMapping("/improveMain.do")
    public String improveMain() {
        return ".main/improve/improveMain";
    }

    @RequestMapping(value = "/getImproveList.do", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> getImproveList(ImproveDTO dto) {
        Map<String, Object> resultMap = new HashMap<>();
        try {
            List<ImproveDTO> list = improveService.getImproveList(dto);
            resultMap.put("result", "success");
            resultMap.put("data", list);
        } catch (Exception e) {
            resultMap.put("result", "fail");
            resultMap.put("msg", e.getMessage());
        }
        return resultMap;
    }

    @RequestMapping(value = "/saveImprove.do", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> saveImprove(ImproveDTO dto) {
        Map<String, Object> resultMap = new HashMap<>();
        try {
            boolean result;
            if ("edit".equals(dto.getMode())) {
                result = improveService.updateImprove(dto);
            } else {
                result = improveService.insertImprove(dto);
            }
            resultMap.put("result", result ? "success" : "fail");
        } catch (Exception e) {
            resultMap.put("result", "fail");
            resultMap.put("msg", e.getMessage());
        }
        return resultMap;
    }

    @RequestMapping(value = "/deleteImprove.do", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> deleteImprove(ImproveDTO dto) {
        Map<String, Object> resultMap = new HashMap<>();
        try {
            boolean result = improveService.deleteImprove(dto);
            resultMap.put("result", result ? "success" : "fail");
        } catch (Exception e) {
            resultMap.put("result", "fail");
            resultMap.put("msg", e.getMessage());
        }
        return resultMap;
    }
}
