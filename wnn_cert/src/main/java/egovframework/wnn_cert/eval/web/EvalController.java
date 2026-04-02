package egovframework.wnn_cert.eval.web;

import egovframework.wnn_cert.eval.model.EvalDTO;
import egovframework.wnn_cert.eval.model.EvalDtlDTO;
import egovframework.wnn_cert.eval.service.EvalService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/eval")
public class EvalController {

    @Resource(name = "EvalService")
    private EvalService evalService;

    @RequestMapping("/evalMain.do")
    public String evalMain() {
        return ".main/eval/evalMain";
    }

    @RequestMapping("/evalDetail.do")
    public String evalDetail(@RequestParam("evalId") String evalId, ModelMap model) {
        model.addAttribute("evalId", evalId);
        return ".main/eval/evalDetail";
    }

    @RequestMapping(value = "/getEvalList.do", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> getEvalList(EvalDTO dto) {
        Map<String, Object> resultMap = new HashMap<>();
        try {
            List<EvalDTO> list = evalService.getEvalList(dto);
            resultMap.put("result", "success");
            resultMap.put("data", list);
        } catch (Exception e) {
            resultMap.put("result", "fail");
            resultMap.put("msg", e.getMessage());
        }
        return resultMap;
    }

    @RequestMapping(value = "/getEvalDtlList.do", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> getEvalDtlList(EvalDtlDTO dto) {
        Map<String, Object> resultMap = new HashMap<>();
        try {
            List<EvalDtlDTO> list = evalService.getEvalDtlList(dto);
            resultMap.put("result", "success");
            resultMap.put("data", list);
        } catch (Exception e) {
            resultMap.put("result", "fail");
            resultMap.put("msg", e.getMessage());
        }
        return resultMap;
    }

    @RequestMapping(value = "/getEvalScoreSummary.do", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> getEvalScoreSummary(EvalDTO dto) {
        Map<String, Object> resultMap = new HashMap<>();
        try {
            List<EvalDTO> list = evalService.getEvalScoreSummary(dto);
            resultMap.put("result", "success");
            resultMap.put("data", list);
        } catch (Exception e) {
            resultMap.put("result", "fail");
            resultMap.put("msg", e.getMessage());
        }
        return resultMap;
    }

    @RequestMapping(value = "/saveEval.do", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> saveEval(EvalDTO dto) {
        Map<String, Object> resultMap = new HashMap<>();
        try {
            boolean result;
            if (dto.getEvalId() != null && !dto.getEvalId().isEmpty()) {
                result = evalService.updateEval(dto);
            } else {
                result = evalService.insertEval(dto);
            }
            resultMap.put("result", result ? "success" : "fail");
        } catch (Exception e) {
            resultMap.put("result", "fail");
            resultMap.put("msg", e.getMessage());
        }
        return resultMap;
    }

    @RequestMapping(value = "/saveEvalDtl.do", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> saveEvalDtl(EvalDtlDTO dto) {
        Map<String, Object> resultMap = new HashMap<>();
        try {
            boolean result;
            if (dto.getDtlId() != null && !dto.getDtlId().isEmpty()) {
                result = evalService.updateEvalDtl(dto);
            } else {
                result = evalService.insertEvalDtl(dto);
            }
            resultMap.put("result", result ? "success" : "fail");
        } catch (Exception e) {
            resultMap.put("result", "fail");
            resultMap.put("msg", e.getMessage());
        }
        return resultMap;
    }
}
