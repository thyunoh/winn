package egovframework.wnn_medcost.join.service.impl;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import egovframework.wnn_medcost.join.mapper.JoinMapper;
import egovframework.wnn_medcost.join.model.JoinAgreeDTO;
import egovframework.wnn_medcost.join.model.JoinMgrDTO;
import egovframework.wnn_medcost.join.model.JoinReqDTO;
import egovframework.wnn_medcost.join.service.JoinService;

@Service("JoinService")
public class JoinServiceImpl implements JoinService {

    private static final Logger LOGGER = LoggerFactory.getLogger(JoinServiceImpl.class);

    @Autowired
    private JoinMapper mapper;

    @Override
    public List<JoinReqDTO> selJoinReqList(JoinReqDTO dto) throws Exception { return mapper.selJoinReqList(dto); }
    @Override
    public JoinReqDTO selJoinReqInfo(JoinReqDTO dto) throws Exception { return mapper.selJoinReqInfo(dto); }
    @Override
    public List<JoinMgrDTO> selJoinMgrList(JoinReqDTO dto) throws Exception { return mapper.selJoinMgrList(dto); }
    @Override
    public List<JoinAgreeDTO> selJoinAgreeList(JoinReqDTO dto) throws Exception { return mapper.selJoinAgreeList(dto); }
    @Override
    public int selJoinReqCnt() throws Exception { return mapper.selJoinReqCnt(); }

    /**
     * 승인.
     *
     * 병원 · 사용자 · 회원 · 동의확정 · 상태변경이 <b>전부 들어가거나 전부 안 들어가야</b> 한다.
     * 중간에 끊기면 "병원은 생겼는데 로그인할 사용자가 없는" 반쪽 상태가 남고,
     * 그 상태에서는 병원이 이미 있어 다시 승인할 수도 없다.
     *
     * ※계약(TBL_HOSPCONT_MST)은 여기서 만들지 않는다. 기간·계약구분을 담당자가 정해야 해서
     *   승인 뒤 [계약관리] 화면 몫이다. 계약이 없으면 로그인은 되지만 메뉴가 열리지 않는다.
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public void confirm(JoinReqDTO dto) throws Exception {

        String stat = mapper.selReqStat(dto);
        if (stat == null)      throw new IllegalStateException("신청 내역을 찾을 수 없습니다.");
        if ("30".equals(stat)) throw new IllegalStateException("이미 승인된 신청입니다.");
        if ("90".equals(stat)) throw new IllegalStateException("반려된 신청입니다. 승인할 수 없습니다.");
        if (mapper.selHospExists(dto) > 0)
            throw new IllegalStateException("같은 요양기관기호로 이미 등록된 병원이 있습니다.");

        mapper.insertHospFromReq(dto);       // ① 병원 생성
        mapper.insertUserFromReq(dto);       // ② 사용자 연계(병원관리자)
        mapper.insertMemberFromReq(dto);     // ③ 회원행
        mapper.insertHospSignFromReq(dto);   // ④ 동의 확정본 이관
        mapper.updateReqConfirm(dto);        // ⑤ 상태 '30' + 연계키

        dto.setReqStat(stat);                // 이력의 '이전상태'
        dto.setCfmHospCd("30");              // 이력의 '변경상태'
        dto.setRjtRsn("승인 - 병원·사용자 생성");
        mapper.insertJoinHisAdm(dto);

        LOGGER.info("가입신청 승인 reqNo={} by={}", dto.getReqNo(), dto.getCfmUser());
    }

    /** 반려 — 사유를 남긴다. 병원·사용자는 만들지 않는다. */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public void reject(JoinReqDTO dto) throws Exception {

        String stat = mapper.selReqStat(dto);
        if (stat == null)      throw new IllegalStateException("신청 내역을 찾을 수 없습니다.");
        if ("30".equals(stat)) throw new IllegalStateException("이미 승인된 신청은 반려할 수 없습니다.");

        mapper.updateReqReject(dto);

        String rsn = dto.getRjtRsn();
        dto.setReqStat(stat);
        dto.setCfmHospCd("90");
        dto.setRjtRsn("반려 - " + (rsn == null ? "" : rsn));
        mapper.insertJoinHisAdm(dto);
        dto.setRjtRsn(rsn);

        LOGGER.info("가입신청 반려 reqNo={} by={}", dto.getReqNo(), dto.getCfmUser());
    }

    /* ── 병원 쪽 — 승인 후 동의서 원본 제출 ─────────────────────────────────
     * hospCd 는 반드시 쿠키에서 온 값이어야 한다(컨트롤러가 강제한다).
     * 화면에서 넘어온 값을 그대로 쓰면 남의 병원 신청서가 열린다.
     * ------------------------------------------------------------------- */
    @Override
    public JoinReqDTO selMyJoinReq(JoinReqDTO dto) throws Exception { return mapper.selMyJoinReq(dto); }

    @Override
    public int selDocGate(String hospCd) throws Exception {
        if (hospCd == null || hospCd.trim().isEmpty()) return 0;
        return mapper.selDocGate(hospCd.trim());
    }

    /** 동의서 제출 확정 — 파일은 이미 SFTP 에 올라간 뒤에 호출된다. */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public int updateDocSubmit(JoinReqDTO dto) throws Exception {

        int n = mapper.updateDocSubmit(dto);
        if (n == 0) throw new IllegalStateException("제출할 승인건이 없습니다. 이미 제출했거나 승인 전입니다.");

        dto.setReqStat("30");
        dto.setCfmHospCd("40");
        dto.setRjtRsn("동의서 제출 - " + (dto.getDocFileNm() == null ? "" : dto.getDocFileNm()));
        mapper.insertJoinHisAdm(dto);

        LOGGER.info("동의서 제출 reqNo={} hospCd={}", dto.getReqNo(), dto.getHospCd());
        return n;
    }

    /**
     * 승인 롤백(승인취소).
     *
     * 승인이 만든 것만 정확히 지운다. 대상은 승인이 보관해 둔 연계키로만 찍는다
     * (요양기관기호만 보고 지우면 다른 경로로 만든 병원까지 날아간다).
     *
     * 소프트삭제가 아니라 진짜 삭제다. TBL_HOSP_MST 의 PK 가 (HOSP_CD, JOB_SEQ) 이고
     * 승인은 JOB_SEQ=1 로 넣으므로, 남겨두면 다시 승인할 때 PK 충돌로 막힌다.
     *
     * 다음 경우는 <b>거부</b>한다 — 이미 쓰고 있다는 뜻이라 지우면 데이터가 깨진다.
     *   · 계약이 등록돼 있다
     *   · 승인으로 만든 계정 말고 다른 사용자가 생겼다
     *   · 병원행의 UUID 가 승인 기록과 다르다(승인이 만든 행이 아니다)
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public void rollback(JoinReqDTO dto) throws Exception {

        JoinReqDTO k = mapper.selReqKeys(dto);
        if (k == null) throw new IllegalStateException("신청 내역을 찾을 수 없습니다.");

        String stat = k.getReqStat();
        if (!"30".equals(stat) && !"40".equals(stat))
            throw new IllegalStateException("승인된 신청이 아닙니다. (현재 상태 " + stat + ")");
        if (k.getCfmHospCd() == null || k.getCfmHospCd().trim().isEmpty())
            throw new IllegalStateException("승인 연계정보가 없어 되돌릴 수 없습니다. 담당자에게 문의하세요.");

        if (mapper.selOtherUserCnt(k) > 0)
            throw new IllegalStateException("승인 이후 추가된 사용자가 있어 되돌릴 수 없습니다.");
        if (mapper.selHospUuidChk(k) != 1)
            throw new IllegalStateException("승인이 만든 병원정보가 아닙니다. 되돌릴 수 없습니다.");

        mapper.delContFromReq(k);       // ⑥ 계약 — 병원이 사라지므로 남기면 고아행이 된다
        mapper.delJoinFiles(k);         // ⑦ 계약폴더 파일기록(실제 파일은 컨트롤러가 지운다)
        mapper.delHospSignFromReq(k);   // ④ 동의확정
        mapper.delMemberFromReq(k);     // ③ 회원
        mapper.delUserFromReq(k);       // ② 사용자
        mapper.delHospFromReq(k);       // ① 병원

        k.setCfmUser(dto.getCfmUser());
        k.setRegIp(dto.getRegIp());
        int n = mapper.updateReqRollback(k);
        if (n == 0) throw new IllegalStateException("상태를 되돌리지 못했습니다.");

        k.setReqStat(stat);
        k.setCfmHospCd("10");
        k.setRjtRsn("승인취소 - " + (dto.getRjtRsn() == null ? "" : dto.getRjtRsn()));
        mapper.insertJoinHisAdm(k);

        LOGGER.info("가입신청 승인취소 reqNo={} hospCd={} by={}",
                    k.getReqNo(), k.getHospCd(), dto.getCfmUser());
    }

    /**
     * 롤백 전에 지울 파일 목록.
     * SFTP 실제 파일 삭제는 네트워크 작업이라 트랜잭션 안에서 하면 안 된다
     * (DB 는 롤백돼도 파일은 이미 지워진 상태가 된다). 목록만 먼저 넘긴다.
     */
    @Override
    public java.util.List<java.util.Map<String,Object>> selJoinFiles(JoinReqDTO dto) throws Exception {
        JoinReqDTO k = mapper.selReqKeys(dto);
        if (k == null || k.getCfmHospCd() == null) return new java.util.ArrayList<java.util.Map<String,Object>>();
        return mapper.selJoinFileList(k);
    }

    /**
     * 반려취소 — 반려(90)를 접수(10)로 되돌린다.
     *
     * 반려는 병원·사용자를 만들지 않으므로 지울 것이 없다. 상태와 사유만 되돌리면 되고,
     * 되돌린 뒤에는 다시 승인하거나 다시 반려할 수 있다.
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public void unreject(JoinReqDTO dto) throws Exception {

        String stat = mapper.selReqStat(dto);
        if (stat == null)       throw new IllegalStateException("신청 내역을 찾을 수 없습니다.");
        if (!"90".equals(stat)) throw new IllegalStateException("반려된 신청이 아닙니다. (현재 상태 " + stat + ")");

        int n = mapper.updateReqUnreject(dto);
        if (n == 0) throw new IllegalStateException("반려를 취소하지 못했습니다.");

        dto.setReqStat("90");
        dto.setCfmHospCd("10");
        dto.setRjtRsn("반려취소 - " + (dto.getBigo() == null ? "" : dto.getBigo()));
        mapper.insertJoinHisAdm(dto);

        LOGGER.info("가입신청 반려취소 reqNo={} by={}", dto.getReqNo(), dto.getCfmUser());
    }

    /**
     * 병원이 자기 신청내역을 고친다 — 문서에 찍히는 병원정보 7가지뿐.
     *
     * 신청서(TBL_JOIN_REQ)와 병원마스터(TBL_HOSP_MST)를 <b>같이</b> 고친다.
     * 승인 뒤에는 화면·계약이 병원마스터를 보므로, 신청서만 고치면 두 곳이 어긋난다.
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public void updateMyJoinReq(JoinReqDTO dto) throws Exception {

        int n = mapper.updateMyJoinReq(dto);
        if (n == 0) throw new IllegalStateException("수정할 수 없는 신청입니다. 승인 상태인지 확인해 주세요.");

        mapper.updateHospFromMy(dto);   // 병원이 아직 없으면 0건 — 문제되지 않는다

        LOGGER.info("신청내역 수정 reqNo={} hospCd={} by={}",
                    dto.getReqNo(), dto.getHospCd(), dto.getCfmUser());
    }

    /**
     * 신청 전체취소.
     *
     * 행을 지우지 않고 ACTION_YN='N' 으로 내린다 — 목록·조회가 모두 'Y' 만 보므로
     * 화면에서는 사라지고, 누가 언제 무엇을 취소했는지는 이력에 남는다.
     * 승인된 건은 병원·계정이 이미 만들어져 있어 [승인취소] 를 먼저 해야 한다.
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public void cancelReq(JoinReqDTO dto) throws Exception {

        String stat = mapper.selReqStat(dto);
        if (stat == null)      throw new IllegalStateException("신청 내역을 찾을 수 없습니다.");
        if (!"10".equals(stat))
            throw new IllegalStateException("접수 상태에서만 취소할 수 있습니다. (현재 상태 " + stat + ")");

        int n = mapper.updateReqCancel(dto);
        if (n == 0) throw new IllegalStateException("취소할 수 없는 신청입니다. 이미 취소되었는지 확인해 주세요.");

        mapper.updateMgrCancel(dto);

        String rsn = dto.getRjtRsn();
        dto.setReqStat(stat);
        dto.setCfmHospCd(stat);          // 상태는 그대로 두고 '내려간' 것만 기록한다
        dto.setRjtRsn("가입취소 - " + (rsn == null ? "" : rsn));
        mapper.insertJoinHisAdm(dto);
        dto.setRjtRsn(rsn);

        LOGGER.info("가입신청 전체취소 reqNo={} by={}", dto.getReqNo(), dto.getCfmUser());
    }
}
