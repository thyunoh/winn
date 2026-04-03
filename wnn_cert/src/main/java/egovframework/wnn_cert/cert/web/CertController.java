package egovframework.wnn_cert.cert.web;

import egovframework.wnn_cert.cert.model.ItemDTO;
import egovframework.wnn_cert.cert.model.QpsDTO;
import egovframework.wnn_cert.cert.model.TreeDTO;
import egovframework.wnn_cert.cert.service.CertService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/cert")
public class CertController {

    @Resource(name = "CertService")
    private CertService certService;

    @RequestMapping("/certMain.do")
    public String certMain() {
        return ".main/cert/certMain";
    }

    @RequestMapping(value = "/getTreeList.do", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> getTreeList(TreeDTO dto) {
        Map<String, Object> resultMap = new HashMap<>();
        try {
            List<TreeDTO> list = certService.getTreeList(dto);
            resultMap.put("result", "success");
            resultMap.put("data", list);
        } catch (Exception e) {
            resultMap.put("result", "fail");
            resultMap.put("msg", e.getMessage());
        }
        return resultMap;
    }

    @RequestMapping(value = "/getTreeAll.do", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> getTreeAll(TreeDTO dto) {
        Map<String, Object> resultMap = new HashMap<>();
        try {
            List<TreeDTO> list = certService.getTreeAll(dto);
            resultMap.put("result", "success");
            resultMap.put("data", list);
        } catch (Exception e) {
            resultMap.put("result", "fail");
            resultMap.put("msg", e.getMessage());
        }
        return resultMap;
    }

    @RequestMapping(value = "/saveTree.do", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> saveTree(TreeDTO dto) {
        Map<String, Object> resultMap = new HashMap<>();
        try {
            boolean result;
            if ("edit".equals(dto.getMode())) {
                result = certService.updateTree(dto);
            } else {
                result = certService.insertTree(dto);
            }
            resultMap.put("result", result ? "success" : "fail");
        } catch (Exception e) {
            resultMap.put("result", "fail");
            resultMap.put("msg", e.getMessage());
        }
        return resultMap;
    }

    @RequestMapping(value = "/deleteTree.do", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> deleteTree(TreeDTO dto) {
        Map<String, Object> resultMap = new HashMap<>();
        try {
            boolean result = certService.deleteTree(dto);
            resultMap.put("result", result ? "success" : "fail");
        } catch (Exception e) {
            resultMap.put("result", "fail");
            resultMap.put("msg", e.getMessage());
        }
        return resultMap;
    }

    @RequestMapping(value = "/getItemList.do", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> getItemList(ItemDTO dto) {
        Map<String, Object> resultMap = new HashMap<>();
        try {
            List<ItemDTO> list = certService.getItemList(dto);
            resultMap.put("result", "success");
            resultMap.put("data", list);
        } catch (Exception e) {
            resultMap.put("result", "fail");
            resultMap.put("msg", e.getMessage());
        }
        return resultMap;
    }

    @RequestMapping(value = "/saveItem.do", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> saveItem(ItemDTO dto) {
        Map<String, Object> resultMap = new HashMap<>();
        try {
            boolean result;
            if ("edit".equals(dto.getMode())) {
                result = certService.updateItem(dto);
            } else {
                result = certService.insertItem(dto);
            }
            resultMap.put("result", result ? "success" : "fail");
        } catch (Exception e) {
            resultMap.put("result", "fail");
            resultMap.put("msg", e.getMessage());
        }
        return resultMap;
    }

    @RequestMapping(value = "/deleteItem.do", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> deleteItem(ItemDTO dto) {
        Map<String, Object> resultMap = new HashMap<>();
        try {
            boolean result = certService.deleteItem(dto);
            resultMap.put("result", result ? "success" : "fail");
        } catch (Exception e) {
            resultMap.put("result", "fail");
            resultMap.put("msg", e.getMessage());
        }
        return resultMap;
    }

    @RequestMapping(value = "/getQpsList.do", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> getQpsList(QpsDTO dto) {
        Map<String, Object> resultMap = new HashMap<>();
        try {
            List<QpsDTO> list = certService.getQpsList(dto);
            resultMap.put("result", "success");
            resultMap.put("data", list);
        } catch (Exception e) {
            resultMap.put("result", "fail");
            resultMap.put("msg", e.getMessage());
        }
        return resultMap;
    }

    @RequestMapping(value = "/saveQps.do", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> saveQps(QpsDTO dto) {
        Map<String, Object> resultMap = new HashMap<>();
        try {
            boolean result;
            if ("edit".equals(dto.getMode())) {
                result = certService.updateQps(dto);
            } else {
                result = certService.insertQps(dto);
            }
            resultMap.put("result", result ? "success" : "fail");
        } catch (Exception e) {
            resultMap.put("result", "fail");
            resultMap.put("msg", e.getMessage());
        }
        return resultMap;
    }

    /* ========== TW_REF 공통코드 관리 ========== */

    @RequestMapping("/refMain.do")
    public String refMain() {
        return ".main/cert/refMain";
    }

    @RequestMapping(value = "/getRefGroupList.do", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> getRefGroupList(@RequestParam Map<String, Object> param) {
        Map<String, Object> resultMap = new HashMap<>();
        try {
            if (param.get("hospCd") == null || "".equals(param.get("hospCd"))) param.put("hospCd", "12345678");
            resultMap.put("result", "success");
            resultMap.put("data", certService.getRefGroupList(param));
        } catch (Exception e) {
            resultMap.put("result", "fail");
            resultMap.put("msg", e.getMessage());
        }
        return resultMap;
    }

    @RequestMapping(value = "/getRefList.do", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> getRefList(@RequestParam Map<String, Object> param) {
        Map<String, Object> resultMap = new HashMap<>();
        try {
            if (param.get("hospCd") == null || "".equals(param.get("hospCd"))) param.put("hospCd", "12345678");
            resultMap.put("result", "success");
            resultMap.put("data", certService.getRefList(param));
        } catch (Exception e) {
            resultMap.put("result", "fail");
            resultMap.put("msg", e.getMessage());
        }
        return resultMap;
    }

    @RequestMapping(value = "/saveRef.do", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> saveRef(@RequestParam Map<String, Object> param) {
        Map<String, Object> resultMap = new HashMap<>();
        try {
            if (param.get("hospCd") == null || "".equals(param.get("hospCd"))) param.put("hospCd", "12345678");
            boolean result;
            if ("U".equals(param.get("mode"))) {
                result = certService.updateRef(param);
            } else {
                result = certService.insertRef(param);
            }
            resultMap.put("result", result ? "success" : "fail");
        } catch (Exception e) {
            resultMap.put("result", "fail");
            resultMap.put("msg", e.getMessage());
        }
        return resultMap;
    }

    @RequestMapping(value = "/deleteRef.do", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> deleteRef(@RequestParam Map<String, Object> param) {
        Map<String, Object> resultMap = new HashMap<>();
        try {
            if (param.get("hospCd") == null || "".equals(param.get("hospCd"))) param.put("hospCd", "12345678");
            resultMap.put("result", certService.deleteRef(param) ? "success" : "fail");
        } catch (Exception e) {
            resultMap.put("result", "fail");
            resultMap.put("msg", e.getMessage());
        }
        return resultMap;
    }
}
