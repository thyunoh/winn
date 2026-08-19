package egovframework.wnn_medcost.join.web;

import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import egovframework.util.ClientInfo;
import egovframework.wnn_medcost.join.model.JoinReqDTO;
import egovframework.wnn_medcost.join.service.JoinService;

/**
 * 신규병원 가입신청 — 위너넷 관리자 화면.
 *
 * 신청은 wnn_consult(로그인 화면의 [신규병원 가입신청])에서 들어오고,
 * 확인·승인은 <b>사이드바가 있는 이 프로그램</b>에서 한다. 두 앱이 같은 DB(WNN)를 본다.
 * 승인 직후 계약을 넣어야 이용이 시작되는데 그 [계약관리] 화면이 여기 있다.
 *
 * ★<b>위너넷 관리자(MAIN_GU='1') 전용</b>. 메뉴만 감추면 주소를 직접 칠 수 있어 여기서도 막는다.
 *   막힐 때는 <b>왜 막혔는지 구분</b>한다 — 둘 다 로그인 화면으로 보내면
 *   "로그인했는데도 로그인 화면이 뜬다" 로 보여 원인을 못 찾는다.
 */
@Controller
@RequestMapping("/join")
public class JoinController {

    private static final Logger log = LoggerFactory.getLogger(JoinController.class);

    @Resource(name = "JoinService")
    private JoinService svc;

    /* ★로그인은 **wnn_consult(로그인 화면)** 에서 한다. 이 프로그램은 그 뒤에 열리므로
         세션이 아니라 **쿠키**로 판별해야 한다 — 세션은 앱마다 따로라 여기선 비어 있다.
         쿠키는 호스트 단위라 포트가 달라도(9080 → 8080) 그대로 넘어온다.
         이 프로그램의 다른 화면들도 같은 방식이다(ClientInfo.getCookie). */
    private String ck(HttpServletRequest request, String name) {
        java.util.Map<String, String> c = ClientInfo.getCookie(request);
        String v = (c == null) ? null : c.get(name);
        return (v == null) ? "" : v.trim();
    }

    private boolean isLoggedIn(HttpServletRequest request) {
        return ck(request, "s_hospid").length() > 0;
    }

    /** 위너넷 관리자인가 — 로그인 시 심어 둔 s_mainfg(관리자구분)가 1 일 때만 */
    private boolean isWnnAdmin(HttpServletRequest request) {
        return "1".equals(ck(request, "s_mainfg"));
    }


    /** 가입신청 목록 화면 */
    @RequestMapping(value = "/joinReq.do")
    public String joinReq(HttpServletRequest request, ModelMap model) throws Exception {
        if (!isLoggedIn(request)) {
            log.warn(" joinReq : 로그인 세션 없음 — 로그인 화면으로");
            return ".login/LoginWinCT";
        }
        if (!isWnnAdmin(request)) {
            log.warn(" joinReq : 권한 없음 — s_hospid={} s_userid={} s_mainfg={} (필요값 1)",
                     ck(request, "s_hospid"), ck(request, "s_userid"), ck(request, "s_mainfg"));
            return ".main/main";
        }
        return ".main/mangr/joinReq";
    }

    /** 신청 목록 */
    @RequestMapping(value = "/joinReqList.do", method = RequestMethod.POST)
    public String joinReqList(@ModelAttribute("DTO") JoinReqDTO dto, HttpServletRequest request, ModelMap model)
            throws Exception {
        try {
            if (!isWnnAdmin(request)) {
                model.addAttribute("error_code", "40100");
                model.addAttribute("error_msg", "권한이 없습니다.");
                return "jsonView";
            }
            List<?> list = svc.selJoinReqList(dto);
            model.addAttribute("resultList", list);
            model.addAttribute("resultCnt", list.size());
            model.addAttribute("error_code", "0");
        } catch (Exception ex) {
            log.error(" joinReqList ERROR ! : " + ex.getMessage(), ex);
            model.addAttribute("error_code", "10000");
            model.addAttribute("error_msg", "목록을 불러오지 못했습니다.");
        }
        return "jsonView";
    }

    /** 신청 상세 — 신청내용 · 담당자 · 동의내역 · 도장 */
    @RequestMapping(value = "/joinReqInfo.do", method = RequestMethod.POST)
    public String joinReqInfo(@ModelAttribute("DTO") JoinReqDTO dto, HttpServletRequest request, ModelMap model)
            throws Exception {
        try {
            if (!isWnnAdmin(request)) {
                model.addAttribute("error_code", "40100");
                model.addAttribute("error_msg", "권한이 없습니다.");
                return "jsonView";
            }
            model.addAttribute("info",      svc.selJoinReqInfo(dto));
            model.addAttribute("mgrList",   svc.selJoinMgrList(dto));
            model.addAttribute("agreeList", svc.selJoinAgreeList(dto));
            model.addAttribute("error_code", "0");
        } catch (Exception ex) {
            log.error(" joinReqInfo ERROR ! : " + ex.getMessage(), ex);
            model.addAttribute("error_code", "10000");
            model.addAttribute("error_msg", "상세를 불러오지 못했습니다.");
        }
        return "jsonView";
    }

    /** 승인 */
    @RequestMapping(value = "/joinReqCfm.do", method = RequestMethod.POST)
    public String joinReqCfm(@ModelAttribute("DTO") JoinReqDTO dto, HttpServletRequest request, ModelMap model)
            throws Exception {
        try {
            if (!isWnnAdmin(request)) {
                model.addAttribute("error_code", "40100");
                model.addAttribute("error_msg", "권한이 없습니다.");
                return "jsonView";
            }
            fillActor(dto, request);
            svc.confirm(dto);
            model.addAttribute("error_code", "0");
        } catch (IllegalStateException ex) {          // 업무상 막은 것 — 사유를 그대로 보여준다
            model.addAttribute("error_code", "30000");
            model.addAttribute("error_msg", ex.getMessage());
        } catch (Exception ex) {
            log.error(" joinReqCfm ERROR ! : " + ex.getMessage(), ex);
            model.addAttribute("error_code", "10000");
            model.addAttribute("error_msg", "승인 처리 중 오류가 발생했습니다.");
        }
        return "jsonView";
    }

    /** 반려 */
    @RequestMapping(value = "/joinReqRjt.do", method = RequestMethod.POST)
    public String joinReqRjt(@ModelAttribute("DTO") JoinReqDTO dto, HttpServletRequest request, ModelMap model)
            throws Exception {
        try {
            if (!isWnnAdmin(request)) {
                model.addAttribute("error_code", "40100");
                model.addAttribute("error_msg", "권한이 없습니다.");
                return "jsonView";
            }
            if (dto.getRjtRsn() == null || dto.getRjtRsn().trim().length() == 0) {
                model.addAttribute("error_code", "30000");
                model.addAttribute("error_msg", "반려 사유를 입력하세요.");
                return "jsonView";
            }
            fillActor(dto, request);
            svc.reject(dto);
            model.addAttribute("error_code", "0");
        } catch (IllegalStateException ex) {
            model.addAttribute("error_code", "30000");
            model.addAttribute("error_msg", ex.getMessage());
        } catch (Exception ex) {
            log.error(" joinReqRjt ERROR ! : " + ex.getMessage(), ex);
            model.addAttribute("error_code", "10000");
            model.addAttribute("error_msg", "반려 처리 중 오류가 발생했습니다.");
        }
        return "jsonView";
    }

    /**
     * 접수 대기 건수 — 사이드바가 이 값으로 메뉴를 보일지 정한다.
     * ★로그인만 되어 있으면 답한다(관리자 여부까지 보지 않는다) —
     *   메뉴 표시용 숫자일 뿐이고, 화면 진입은 joinReq.do 가 다시 막는다.
     */
    @RequestMapping(value = "/joinReqCnt.do", method = RequestMethod.POST)
    public String joinReqCnt(HttpServletRequest request, ModelMap model) throws Exception {
        try {
            model.addAttribute("cnt", isWnnAdmin(request) ? svc.selJoinReqCnt() : 0);
            model.addAttribute("error_code", "0");
        } catch (Exception ex) {
            log.error(" joinReqCnt ERROR ! : " + ex.getMessage());
            model.addAttribute("cnt", 0);
            model.addAttribute("error_code", "10000");
        }
        return "jsonView";
    }

    /** 처리자·IP — 화면에서 온 값을 믿지 않고 쿠키·요청에서 채운다 */
    private void fillActor(JoinReqDTO dto, HttpServletRequest request) {
        String uid = ck(request, "s_userid");
        dto.setCfmUser(uid.length() > 0 ? uid : "WNNADMIN");
        dto.setRegIp(ClientInfo.getClientIP(request));
    }
}
