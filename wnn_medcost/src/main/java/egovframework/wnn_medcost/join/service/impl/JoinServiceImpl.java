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
}
