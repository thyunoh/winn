package egovframework.wnn_consult.join.web;

import java.nio.charset.StandardCharsets;
import java.util.Base64;
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

import egovframework.util.EgovFileScrty;
import egovframework.util.GetClientIP;
import egovframework.wnn_consult.join.model.AgreeMdDTO;
import egovframework.wnn_consult.join.model.JoinMgrDTO;
import egovframework.wnn_consult.join.model.JoinReqDTO;
import egovframework.wnn_consult.join.service.JoinService;

/**
 * 신규병원 가입신청.
 *
 * 기존 회원가입(UserController.base_MemberSaveAct)은 <b>등록된 병원의 사용자 등록</b>이라
 * 계약이 없으면 막힌다. 여기는 그 반대로 <b>병원이 아직 없는 상태</b>에서 신청만 받아 두고,
 * 위너넷이 승인할 때 TBL_HOSP_MST 를 만들고 TBL_USER_MST 를 연계한다.
 */
@Controller
public class JoinController {

    private static final Logger log = LoggerFactory.getLogger(JoinController.class);

    @Resource(name = "JoinService")
    private JoinService svc;

    /**
     * 동의서 목록(본문 포함).
     * 화면은 로그인 페이지에 붙은 모달이라 페이지 매핑이 따로 없다.
     * 모달을 열 때 이 목록을 받아 FORM_NO 기준으로 서식 탭에 나눠 붙인다.
     */
    @RequestMapping(value = "/join/joinAgreeList.do", method = RequestMethod.POST)
    public String joinAgreeList(HttpServletRequest request, ModelMap model) throws Exception {
        try {
            model.addAttribute("agreeList", svc.selAgreeList(new AgreeMdDTO()));
            model.addAttribute("error_code", "0");
        } catch (Exception ex) {
            log.error(" joinAgreeList ERROR ! : " + ex.getMessage());
            model.addAttribute("error_code", "10000");
            model.addAttribute("error_msg", "동의서를 불러오지 못했습니다.");
        }
        return "jsonView";
    }

    /** 요양기관기호 확인 — 이미 등록된 병원인지 / 진행중 신청이 있는지 */
    @RequestMapping(value = "/join/joinHospChk.do", method = RequestMethod.POST)
    public String joinHospChk(@ModelAttribute("DTO") JoinReqDTO dto, HttpServletRequest request, ModelMap model)
            throws Exception {
        try {
            JoinReqDTO r = svc.selHospChk(dto);
            model.addAttribute("hospCnt", r == null || r.getHospCnt() == null ? 0 : r.getHospCnt());
            model.addAttribute("reqCnt", r == null || r.getReqCnt() == null ? 0 : r.getReqCnt());
            model.addAttribute("hospNmDb", r == null ? "" : r.getHospNmDb());
            model.addAttribute("error_code", "0");
        } catch (Exception ex) {
            log.error(" joinHospChk ERROR ! : " + ex.getMessage());
            model.addAttribute("error_code", "10000");
            model.addAttribute("error_msg", "요양기관기호 확인 중 오류가 발생했습니다.");
        }
        return "jsonView";
    }

    /** 이메일(로그인 ID) 중복 확인 */
    @RequestMapping(value = "/join/joinEmailChk.do", method = RequestMethod.POST)
    public String joinEmailChk(@ModelAttribute("DTO") JoinReqDTO dto, HttpServletRequest request, ModelMap model)
            throws Exception {
        try {
            if (dto.getEmail() != null) dto.setEmail(dto.getEmail().trim().toLowerCase());
            JoinReqDTO r = svc.selEmailChk(dto);
            model.addAttribute("userCnt", r == null || r.getUserCnt() == null ? 0 : r.getUserCnt());
            model.addAttribute("reqCnt", r == null || r.getReqCnt() == null ? 0 : r.getReqCnt());
            model.addAttribute("error_code", "0");
        } catch (Exception ex) {
            log.error(" joinEmailChk ERROR ! : " + ex.getMessage());
            model.addAttribute("error_code", "10000");
            model.addAttribute("error_msg", "이메일 확인 중 오류가 발생했습니다.");
        }
        return "jsonView";
    }

    /**
     * 가입신청 저장.
     * 화면 검증은 참고만 하고 <b>여기서 다시 본다</b> — 화면은 우회할 수 있다.
     */
    @RequestMapping(value = "/join/joinReqSaveAct.do", method = RequestMethod.POST)
    public String joinReqSaveAct(@ModelAttribute("DTO") JoinReqDTO dto, HttpServletRequest request, ModelMap model)
            throws Exception {
        try {
            String email = dto.getEmail() == null ? "" : dto.getEmail().trim().toLowerCase();
            dto.setEmail(email);

            /* 필수 항목(2026-08-19 지정) — 화면과 같은 기준으로 여기서도 본다.
               병원명 · 요양기관기호 · 전화번호 · 심평원 인증서암호 · 전산프로그램 정보(MASTER) ·
               환자평가표 작성완료일 · 적정성평가 목표점수·등급 · 로그인 계정.
               대표자·주소도 필수. 담당자(총 관리자·심사과)는 아래에서 따로 본다. */
            if (isBlank(dto.getHospCd()) || isBlank(dto.getHospNm()) || isBlank(dto.getHospTel())
                    || isBlank(dto.getHospCeo()) || isBlank(dto.getHospAddr())
                    || isBlank(email) || isBlank(dto.getMbrNm()) || isBlank(dto.getMbrTel())
                    || isBlank(dto.getOcsCompany()) || isBlank(dto.getOcsUserId()) || isBlank(dto.getOcsUserPw())
                    || isBlank(dto.getHiraCertPw()) || isBlank(dto.getAsqDay()) || isBlank(dto.getEvalGoal())) {
                model.addAttribute("error_code", "30000");
                model.addAttribute("error_msg", "필수 항목이 비어 있습니다.");
                return "jsonView";
            }
            // 요양기관기호는 8자를 넘을 수 없다 — 화면 maxlength 는 우회할 수 있어 여기서도 본다
            if (dto.getHospCd().trim().length() > 8) {
                model.addAttribute("error_code", "30000");
                model.addAttribute("error_msg", "요양기관기호는 8자를 넘을 수 없습니다.");
                return "jsonView";
            }
            // 담당자 — 총 관리자(1)·심사과(3)는 성명·전화·이메일까지 필수
            if (!hasMgr(dto, "1")) {
                model.addAttribute("error_code", "30000");
                model.addAttribute("error_msg", "담당자 — 총 관리자의 성명·전화번호·이메일을 확인하세요.");
                return "jsonView";
            }
            if (!hasMgr(dto, "3")) {
                model.addAttribute("error_code", "30000");
                model.addAttribute("error_msg", "담당자 — 심사과의 성명·전화번호·이메일을 입력하세요.");
                return "jsonView";
            }
            if (isBlank(dto.getPassWd()) || isBlank(dto.getAfPassWd())) {
                model.addAttribute("error_code", "30000");
                model.addAttribute("error_msg", "비밀번호를 입력하세요.");
                return "jsonView";
            }
            if (dto.getPassWd().length() < 4) {
                model.addAttribute("error_code", "30000");
                model.addAttribute("error_msg", "비밀번호는 4자 이상이어야 합니다.");
                return "jsonView";
            }
            if (!dto.getPassWd().equals(dto.getAfPassWd())) {
                model.addAttribute("error_code", "30000");
                model.addAttribute("error_msg", "비밀번호가 서로 다릅니다.");
                return "jsonView";
            }

            // 이미 등록된 병원이면 신규 가입신청이 아니다 — 기존 회원가입으로 보낸다
            JoinReqDTO hchk = svc.selHospChk(dto);
            if (hchk != null && hchk.getHospCnt() != null && hchk.getHospCnt().intValue() > 0) {
                model.addAttribute("error_code", "30001");
                model.addAttribute("error_msg", "이미 등록된 요양기관입니다. 로그인 화면의 [회원가입]을 이용하세요.");
                return "jsonView";
            }
            if (hchk != null && hchk.getReqCnt() != null && hchk.getReqCnt().intValue() > 0) {
                model.addAttribute("error_code", "30002");
                model.addAttribute("error_msg", "이미 접수된 가입신청이 있습니다. 처리 결과를 기다려 주세요.");
                return "jsonView";
            }

            JoinReqDTO echk = svc.selEmailChk(dto);
            if (echk != null && echk.getUserCnt() != null && echk.getUserCnt().intValue() > 0) {
                model.addAttribute("error_code", "30003");
                model.addAttribute("error_msg", "이미 사용 중인 이메일입니다.");
                return "jsonView";
            }
            if (echk != null && echk.getReqCnt() != null && echk.getReqCnt().intValue() > 0) {
                model.addAttribute("error_code", "30004");
                model.addAttribute("error_msg", "해당 이메일로 접수된 신청이 이미 있습니다.");
                return "jsonView";
            }

            // 필수 동의가 다 체크됐는지 — 마스터의 ESS_YN='Y' 기준으로 다시 본다
            List<AgreeMdDTO> agrMst = svc.selAgreeList(new AgreeMdDTO());
            if (agrMst != null) {
                for (AgreeMdDTO m : agrMst) {
                    if (!"Y".equals(m.getEssYn())) continue;
                    if (!isAgreed(dto, m.getAgreeCd())) {
                        model.addAttribute("error_code", "30005");
                        model.addAttribute("error_msg", "필수 동의 항목에 모두 동의해야 신청할 수 있습니다.");
                        return "jsonView";
                    }
                }
            }

            // 비밀번호 암호화 — 기존 회원가입과 같은 방식(이메일을 salt 로)
            String encrypted = EgovFileScrty.encryptPassword(dto.getPassWd(), email);
            dto.setPassWd(Base64.getUrlEncoder().encodeToString(encrypted.getBytes(StandardCharsets.UTF_8)));
            dto.setAfPassWd("");

            dto.setRegIp(GetClientIP.getClientIP(request));

            /* 대표자 도장·사인은 필수 — 없으면 동의서의 (인) 자리가 빈 채로 접수된다 */
            if (isBlank(dto.getSealImg())) {
                model.addAttribute("error_code", "30006");
                model.addAttribute("error_msg", "대표자 도장·사인을 올려 주세요.");
                return "jsonView";
            }

            /* 대표자 직인 — 화면이 base64 본문만 보낸다.
               해시는 서버가 계산한다(화면이 준 값을 믿으면 대조의 의미가 없다). */
            if (!isBlank(dto.getSealImg())) {
                byte[] raw = Base64.getDecoder().decode(dto.getSealImg().trim());
                if (raw.length > 3 * 1024 * 1024) {
                    model.addAttribute("error_code", "30006");
                    model.addAttribute("error_msg", "직인 이미지가 너무 큽니다.");
                    return "jsonView";
                }
                dto.setSealHash(sha256Hex(raw));
            } else {
                dto.setSealImg(null);
                dto.setSealMime(null);
                dto.setSealNm(null);
                dto.setSealHash(null);
            }

            Long reqNo = svc.insertJoinReq(dto);
            model.addAttribute("reqNo", reqNo);
            model.addAttribute("error_code", "0");

        } catch (Exception ex) {
            log.error(" joinReqSaveAct ERROR ! : " + ex.getMessage(), ex);
            model.addAttribute("error_code", "10000");
            model.addAttribute("error_msg", "가입신청 저장 중 오류가 발생했습니다.");
        } finally {
            // @ModelAttribute("DTO") 는 jsonView 가 응답에 통째로 실어 보낸다.
            // 비워두지 않으면 저장된 형태의 비밀번호가 응답으로 되돌아 나간다.
            dto.setPassWd("");
            dto.setAfPassWd("");
        }
        return "jsonView";
    }

    private boolean isAgreed(JoinReqDTO dto, String agreeCd) {
        if (dto.getAgreeList() == null || agreeCd == null) return false;
        for (int i = 0; i < dto.getAgreeList().size(); i++) {
            if (dto.getAgreeList().get(i) == null) continue;
            if (agreeCd.equals(dto.getAgreeList().get(i).getAgreeCd())
                    && "Y".equals(dto.getAgreeList().get(i).getAgreeYn())) {
                return true;
            }
        }
        return false;
    }

    /** 해당 담당구분의 성명·전화·이메일이 모두 채워졌는지 */
    private boolean hasMgr(JoinReqDTO dto, String mgrGb) {
        if (dto.getMgrList() == null) return false;
        for (int i = 0; i < dto.getMgrList().size(); i++) {
            JoinMgrDTO m = dto.getMgrList().get(i);
            if (m == null || !mgrGb.equals(m.getMgrGb())) continue;
            if (!isBlank(m.getMgrNm()) && !isBlank(m.getMgrTel()) && !isBlank(m.getEmail())) return true;
        }
        return false;
    }

    /** 직인 이미지 SHA-256(hex) — 나중에 바꿔치기를 대조하기 위한 값 */
    private String sha256Hex(byte[] data) throws Exception {
        byte[] d = java.security.MessageDigest.getInstance("SHA-256").digest(data);
        StringBuilder sb = new StringBuilder(d.length * 2);
        for (int i = 0; i < d.length; i++) {
            sb.append(Character.forDigit((d[i] >> 4) & 0xF, 16));
            sb.append(Character.forDigit(d[i] & 0xF, 16));
        }
        return sb.toString();
    }

    private boolean isBlank(String s) {
        return s == null || s.trim().length() == 0;
    }
}
