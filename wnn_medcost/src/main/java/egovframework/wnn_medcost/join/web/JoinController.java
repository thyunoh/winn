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
import org.springframework.web.bind.annotation.RequestParam;

import java.io.File;

import egovframework.util.ClientInfo;
import egovframework.wnn_medcost.ftpload.service.SftpService;
import egovframework.wnn_medcost.join.service.JoinPdfMaker;
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

    @org.springframework.beans.factory.annotation.Autowired
    private SftpService sftpService;

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

            /* [변경 2026-08-19] 승인 시 PDF 를 만들어 올리던 것을 뺐다.
               문서는 **병원이** 자기 화면에서 만들어 서명·날인 후 올린다(joinDocs.do). */
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

    /**
     * 승인 문서(PDF)를 만들어 <b>계약 폴더</b>에 올린다.
     *
     * 폴더 규칙은 <b>기존 계약관리 업로드와 같게</b> 간다 —
     * {@code /home/winner/upload/<요양기관기호>/1/C/} (SftpController 가 쓰는 hospCd/notiSeq/fileGb 규칙).
     * 그래야 승인 때 만든 문서가 <b>계약관리 화면의 파일 목록에 그대로</b> 보인다.
     * 따로 contract/ 폴더를 파면 화면 조회 조건(fileGb='C')과 어긋나 담당자가 못 본다.
     */
    private String makeAndUploadPdf(JoinReqDTO dto, HttpServletRequest request) throws Exception {

        JoinReqDTO info = svc.selJoinReqInfo(dto);
        if (info == null) return "신청 내역을 찾지 못해 문서를 만들지 못했습니다.";

        String webapp = request.getServletContext().getRealPath("/");
        JoinPdfMaker maker = new JoinPdfMaker(webapp);
        File pdf = maker.make(info, svc.selJoinMgrList(dto), svc.selJoinAgreeList(dto));

        try {
            String hospCd   = info.getHospCd();
            String fileGb   = "C";                    // 계약
            String notiSeq  = "1";
            String folder   = hospCd + "/" + notiSeq + "/" + fileGb;
            String fileName = "가입신청서_" + hospCd + "_" + dto.getReqNo() + ".pdf";
            String sizeKb   = Long.toString(pdf.length() / 1024);

            boolean ok = sftpService.uploadFile(pdf.getAbsolutePath(), fileName, folder,
                                                hospCd, fileGb, notiSeq,
                                                dto.getCfmUser(), dto.getRegIp(), sizeKb);
            if (!ok) return "승인은 되었으나 문서 업로드에 실패했습니다. 계약관리 화면에서 직접 올려 주세요.";

            log.info("가입신청 문서 업로드 reqNo={} → {}/{}", dto.getReqNo(), folder, fileName);
            return "신청서·동의서 PDF 를 계약 폴더에 올렸습니다.";
        } finally {
            if (pdf.exists() && !pdf.delete()) pdf.deleteOnExit();   // 임시파일은 남기지 않는다
        }
    }

    /** 처리자·IP — 화면에서 온 값을 믿지 않고 쿠키·요청에서 채운다 */
    private void fillActor(JoinReqDTO dto, HttpServletRequest request) {
        String uid = ck(request, "s_userid");
        dto.setCfmUser(uid.length() > 0 ? uid : "WNNADMIN");
        dto.setRegIp(ClientInfo.getClientIP(request));
    }

    /* ══════════════════════════════════════════════════════════════════════════
     *  병원 쪽 — 승인 후 동의서 원본 제출
     *
     *  승인(30)만으로는 프로그램을 쓸 수 없다. 병원이 서명·날인한 동의서를 올려야(40)
     *  화면이 열리고, 위너넷이 계약까지 넣으면 메뉴가 열린다.
     *
     *  hospCd 는 **화면에서 받지 않고 쿠키에서만** 가져온다. 화면 값을 믿으면
     *  요양기관기호만 바꿔서 남의 병원 신청서를 열 수 있다.
     * ════════════════════════════════════════════════════════════════════════ */

    /** 동의서 제출 화면 */
    @RequestMapping(value = "/joinDocs.do")
    public String joinDocs(HttpServletRequest request, ModelMap model) throws Exception {
        if (!isLoggedIn(request)) return ".login/LoginWinCT";
        model.addAttribute("hospCd", ck(request, "s_hospid"));
        return ".main/mangr/joinDocs";
    }

    /** 내 병원 승인건 조회 — 자기 것만 */
    @RequestMapping(value = "/joinDocsInfo.do", method = RequestMethod.POST)
    public String joinDocsInfo(HttpServletRequest request, ModelMap model) throws Exception {
        try {
            String hospCd = ck(request, "s_hospid");
            if (hospCd.length() == 0) {
                model.addAttribute("error_code", "40100");
                model.addAttribute("error_msg", "로그인이 필요합니다.");
                return "jsonView";
            }
            JoinReqDTO q = new JoinReqDTO();
            q.setHospCd(hospCd);

            JoinReqDTO info = svc.selMyJoinReq(q);
            model.addAttribute("info", info);            // 없으면 null — 화면이 "해당 없음" 처리

            // 최초 로그인 때 "무엇에 동의했는지" 를 같이 보여준다
            if (info != null) {
                JoinReqDTO a = new JoinReqDTO();
                a.setReqNo(info.getReqNo());
                model.addAttribute("agreeList", svc.selJoinAgreeList(a));
                model.addAttribute("mgrList",   svc.selJoinMgrList(a));
            }
            model.addAttribute("error_code", "0");
        } catch (Exception e) {
            log.error(" joinDocsInfo 오류", e);
            model.addAttribute("error_code", "50000");
            model.addAttribute("error_msg", "조회 중 오류가 발생했습니다.");
        }
        return "jsonView";
    }

    /**
     * 제출 확정.
     * 파일 자체는 화면에서 기존 /sftp/fileupload.do 로 먼저 올린 뒤,
     * 성공했을 때만 여기로 파일명을 넘겨 상태를 40 으로 바꾼다.
     * 순서를 바꾸면 "제출됨인데 파일이 없는" 상태가 남는다.
     */
    @RequestMapping(value = "/joinDocsSubmit.do", method = RequestMethod.POST)
    public String joinDocsSubmit(@RequestParam(value = "docFileNm", required = false) String docFileNm,
                                 HttpServletRequest request, ModelMap model) throws Exception {
        try {
            String hospCd = ck(request, "s_hospid");
            if (hospCd.length() == 0) {
                model.addAttribute("error_code", "40100");
                model.addAttribute("error_msg", "로그인이 필요합니다.");
                return "jsonView";
            }
            if (docFileNm == null || docFileNm.trim().isEmpty()) {
                model.addAttribute("error_code", "40000");
                model.addAttribute("error_msg", "올린 파일이 없습니다.");
                return "jsonView";
            }

            JoinReqDTO q = new JoinReqDTO();
            q.setHospCd(hospCd);
            JoinReqDTO info = svc.selMyJoinReq(q);
            if (info == null) {
                model.addAttribute("error_code", "40400");
                model.addAttribute("error_msg", "승인된 가입신청을 찾을 수 없습니다.");
                return "jsonView";
            }

            JoinReqDTO dto = new JoinReqDTO();
            dto.setReqNo(info.getReqNo());
            dto.setHospCd(hospCd);                       // 쿠키값으로 한 번 더 잠근다
            dto.setDocFileNm(docFileNm.trim());
            dto.setCfmUser(ck(request, "s_userid"));
            dto.setRegIp(ClientInfo.getClientIP(request));

            svc.updateDocSubmit(dto);

            model.addAttribute("error_code", "0");
        } catch (IllegalStateException e) {
            model.addAttribute("error_code", "40900");
            model.addAttribute("error_msg", e.getMessage());
        } catch (Exception e) {
            log.error(" joinDocsSubmit 오류", e);
            model.addAttribute("error_code", "50000");
            model.addAttribute("error_msg", "제출 처리 중 오류가 발생했습니다.");
        }
        return "jsonView";
    }

    /**
     * 승인 롤백(승인취소) — 위너넷 관리자만.
     *
     * 병원·사용자를 지우는 되돌릴 수 없는 처리라, 사유를 반드시 남긴다.
     * 계약이 있거나 사용자가 늘었으면 서비스에서 거부한다.
     */
    @RequestMapping(value = "/joinReqRollback.do", method = RequestMethod.POST)
    public String joinReqRollback(@ModelAttribute("DTO") JoinReqDTO dto,
                                  HttpServletRequest request, ModelMap model) throws Exception {
        try {
            if (!isWnnAdmin(request)) {
                model.addAttribute("error_code", "40100");
                model.addAttribute("error_msg", "권한이 없습니다.");
                return "jsonView";
            }
            if (dto.getRjtRsn() == null || dto.getRjtRsn().trim().isEmpty()) {
                model.addAttribute("error_code", "40000");
                model.addAttribute("error_msg", "취소 사유를 입력하세요.");
                return "jsonView";
            }

            // 지울 파일 목록을 **먼저** 확보한다 — 롤백이 DB 기록을 지우고 나면 경로를 알 수 없다
            java.util.List<java.util.Map<String,Object>> files = svc.selJoinFiles(dto);

            dto.setCfmUser(ck(request, "s_userid"));
            dto.setRegIp(ClientInfo.getClientIP(request));
            svc.rollback(dto);

            // SFTP 실제 파일 삭제 — 트랜잭션 밖. 실패해도 롤백은 유효하다.
            int del = 0, fail = 0;
            for (java.util.Map<String,Object> f : files) {
                String path = f.get("filePath") == null ? "" : String.valueOf(f.get("filePath"));
                if (path.length() == 0) continue;
                try {
                    if (sftpService.deleteOnly(path)) del++; else fail++;
                } catch (Exception fe) {
                    fail++;
                    log.warn(" 승인취소 파일삭제 실패 path={}", path, fe);
                }
            }
            if (fail > 0) model.addAttribute("file_msg", "파일 " + fail + "건은 지우지 못했습니다. 계약관리에서 확인해 주세요.");
            else if (del > 0) model.addAttribute("file_msg", "올렸던 파일 " + del + "건도 지웠습니다.");

            model.addAttribute("error_code", "0");
        } catch (IllegalStateException e) {
            model.addAttribute("error_code", "40900");
            model.addAttribute("error_msg", e.getMessage());
        } catch (Exception e) {
            log.error(" joinReqRollback 오류", e);
            model.addAttribute("error_code", "50000");
            model.addAttribute("error_msg", "승인취소 중 오류가 발생했습니다.");
        }
        return "jsonView";
    }

    /** 반려취소 — 위너넷 관리자만. 반려는 만든 게 없어 상태만 되돌린다. */
    @RequestMapping(value = "/joinReqRjtCancel.do", method = RequestMethod.POST)
    public String joinReqRjtCancel(@ModelAttribute("DTO") JoinReqDTO dto,
                                   HttpServletRequest request, ModelMap model) throws Exception {
        try {
            if (!isWnnAdmin(request)) {
                model.addAttribute("error_code", "40100");
                model.addAttribute("error_msg", "권한이 없습니다.");
                return "jsonView";
            }
            dto.setCfmUser(ck(request, "s_userid"));
            dto.setRegIp(ClientInfo.getClientIP(request));
            svc.unreject(dto);
            model.addAttribute("error_code", "0");
        } catch (IllegalStateException e) {
            model.addAttribute("error_code", "40900");
            model.addAttribute("error_msg", e.getMessage());
        } catch (Exception e) {
            log.error(" joinReqRjtCancel 오류", e);
            model.addAttribute("error_code", "50000");
            model.addAttribute("error_msg", "반려취소 중 오류가 발생했습니다.");
        }
        return "jsonView";
    }

    /**
     * 신청내역 수정 — 로그인한 병원이 자기 것만.
     *
     * 요양기관기호는 화면에서 받지 않고 쿠키에서만 가져온다. 화면 값을 믿으면
     * 기호만 바꿔 남의 병원 신청서를 고칠 수 있다.
     */
    @RequestMapping(value = "/joinDocsSave.do", method = RequestMethod.POST)
    public String joinDocsSave(@ModelAttribute("DTO") JoinReqDTO dto,
                               HttpServletRequest request, ModelMap model) throws Exception {
        try {
            String hospCd = ck(request, "s_hospid");
            if (hospCd.length() == 0) {
                model.addAttribute("error_code", "40100");
                model.addAttribute("error_msg", "로그인이 필요합니다.");
                return "jsonView";
            }
            if (dto.getHospNm() == null || dto.getHospNm().trim().isEmpty()) {
                model.addAttribute("error_code", "40000");
                model.addAttribute("error_msg", "병원명을 입력하세요.");
                return "jsonView";
            }
            if (dto.getHospCeo() == null || dto.getHospCeo().trim().isEmpty()) {
                model.addAttribute("error_code", "40000");
                model.addAttribute("error_msg", "대표자를 입력하세요.");
                return "jsonView";
            }

            JoinReqDTO q = new JoinReqDTO();
            q.setHospCd(hospCd);
            JoinReqDTO info = svc.selMyJoinReq(q);
            if (info == null) {
                model.addAttribute("error_code", "40400");
                model.addAttribute("error_msg", "승인된 가입신청을 찾을 수 없습니다.");
                return "jsonView";
            }

            dto.setReqNo(info.getReqNo());
            dto.setHospCd(hospCd);                     // 쿠키값으로 잠근다
            dto.setCfmUser(ck(request, "s_userid"));
            dto.setRegIp(ClientInfo.getClientIP(request));
            svc.updateMyJoinReq(dto);

            model.addAttribute("error_code", "0");
        } catch (IllegalStateException e) {
            model.addAttribute("error_code", "40900");
            model.addAttribute("error_msg", e.getMessage());
        } catch (Exception e) {
            log.error(" joinDocsSave 오류", e);
            model.addAttribute("error_code", "50000");
            model.addAttribute("error_msg", "수정 중 오류가 발생했습니다.");
        }
        return "jsonView";
    }

    /**
     * 사이드바 게이트 — 신청서 미제출 병원이면 'Y'.
     *
     * 대시보드 진입만 막으면 주소를 직접 쳐서 다른 화면에 들어갈 수 있다.
     * 메뉴 자체를 잠그기 위해 사이드바가 이 값을 물어본다.
     * 판정에 실패하면 'N'(통과) 이다 — 조회 하나 때문에 기존 병원이 잠기면 안 된다.
     */
    @RequestMapping(value = "/joinGate.do", method = RequestMethod.POST)
    public String joinGate(HttpServletRequest request, ModelMap model) throws Exception {
        String gate = "N";
        try {
            if (!"1".equals(ck(request, "s_mainfg"))) {
                gate = svc.selDocGate(ck(request, "s_hospid")) > 0 ? "Y" : "N";
            }
        } catch (Exception e) {
            log.warn(" joinGate 확인 실패 — 통과시킨다", e);
        }
        model.addAttribute("gate", gate);
        model.addAttribute("error_code", "0");
        return "jsonView";
    }

    /** 신청 전체취소 — 위너넷 관리자만. 사유를 남긴다. */
    @RequestMapping(value = "/joinReqCancel.do", method = RequestMethod.POST)
    public String joinReqCancel(@ModelAttribute("DTO") JoinReqDTO dto,
                                HttpServletRequest request, ModelMap model) throws Exception {
        try {
            if (!isWnnAdmin(request)) {
                model.addAttribute("error_code", "40100");
                model.addAttribute("error_msg", "권한이 없습니다.");
                return "jsonView";
            }
            if (dto.getRjtRsn() == null || dto.getRjtRsn().trim().isEmpty()) {
                model.addAttribute("error_code", "40000");
                model.addAttribute("error_msg", "취소 사유를 입력하세요.");
                return "jsonView";
            }
            dto.setCfmUser(ck(request, "s_userid"));
            dto.setRegIp(ClientInfo.getClientIP(request));
            svc.cancelReq(dto);
            model.addAttribute("error_code", "0");
        } catch (IllegalStateException e) {
            model.addAttribute("error_code", "40900");
            model.addAttribute("error_msg", e.getMessage());
        } catch (Exception e) {
            log.error(" joinReqCancel 오류", e);
            model.addAttribute("error_code", "50000");
            model.addAttribute("error_msg", "취소 중 오류가 발생했습니다.");
        }
        return "jsonView";
    }
}
