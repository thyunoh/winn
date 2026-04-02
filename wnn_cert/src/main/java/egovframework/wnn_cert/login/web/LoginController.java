package egovframework.wnn_cert.login.web;

import egovframework.wnn_cert.login.model.UserDTO;
import egovframework.wnn_cert.login.service.LoginService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/login")
public class LoginController {

    @Resource(name = "LoginService")
    private LoginService loginService;

    @RequestMapping("/loginPage.do")
    public String loginPage() {
        return ".login/login";
    }

    @RequestMapping(value = "/doLogin.do", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> doLogin(UserDTO dto, HttpServletRequest request) {
        Map<String, Object> resultMap = new HashMap<>();
        try {
            UserDTO loginUser = loginService.getLoginUser(dto);
            if (loginUser != null) {
                HttpSession session = request.getSession();
                session.setAttribute("loginUser", loginUser);
                resultMap.put("result", "success");
                resultMap.put("data", loginUser);
            } else {
                resultMap.put("result", "fail");
                resultMap.put("msg", "아이디 또는 비밀번호가 일치하지 않습니다.");
            }
        } catch (Exception e) {
            resultMap.put("result", "fail");
            resultMap.put("msg", e.getMessage());
        }
        return resultMap;
    }

    @RequestMapping("/doLogout.do")
    public String doLogout(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        return "redirect:/login/loginPage.do";
    }
}
