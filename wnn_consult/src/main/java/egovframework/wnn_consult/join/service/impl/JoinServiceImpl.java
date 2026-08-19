package egovframework.wnn_consult.join.service.impl;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import egovframework.wnn_consult.join.mapper.JoinMapper;
import egovframework.wnn_consult.join.model.AgreeMdDTO;
import egovframework.wnn_consult.join.model.JoinAgreeDTO;
import egovframework.wnn_consult.join.model.JoinMgrDTO;
import egovframework.wnn_consult.join.model.JoinReqDTO;
import egovframework.wnn_consult.join.service.JoinService;

@Service("JoinService")
public class JoinServiceImpl implements JoinService {

    private static final Logger LOGGER = LoggerFactory.getLogger(JoinServiceImpl.class);

    @Autowired
    private JoinMapper mapper;

    @Override
    public List<AgreeMdDTO> selAgreeList(AgreeMdDTO dto) throws Exception {
        return mapper.selAgreeList(dto);
    }

    @Override
    public JoinReqDTO selHospChk(JoinReqDTO dto) throws Exception {
        return mapper.selHospChk(dto);
    }

    @Override
    public JoinReqDTO selEmailChk(JoinReqDTO dto) throws Exception {
        return mapper.selEmailChk(dto);
    }

    /**
     * 신청 저장.
     * 신청 1건 · 담당자 N · 동의 N · 이력 1건이 <b>전부 들어가거나 전부 안 들어가야</b> 한다.
     * 동의만 빠진 신청이 남으면 나중에 "동의 없이 가입했다" 가 된다.
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public Long insertJoinReq(JoinReqDTO dto) throws Exception {

        mapper.insertJoinReq(dto);                 // useGeneratedKeys 로 dto.reqNo 채워짐
        Long reqNo = dto.getReqNo();
        LOGGER.info("가입신청 등록 reqNo={} hospCd={}", reqNo, dto.getHospCd());

        List<JoinMgrDTO> mgrList = dto.getMgrList();
        if (mgrList != null) {
            for (JoinMgrDTO mgr : mgrList) {
                if (mgr == null) continue;
                // 이름·전화가 모두 비면 안 적은 칸이다 — 빈 행을 만들지 않는다
                boolean empty = isBlank(mgr.getMgrNm()) && isBlank(mgr.getMgrTel()) && isBlank(mgr.getEmail());
                if (empty) continue;
                mgr.setReqNo(reqNo);
                if (mgr.getMgrSeq() == null) mgr.setMgrSeq(Integer.valueOf(1));
                mgr.setRegUser(dto.getEmail());
                mgr.setRegIp(dto.getRegIp());
                mapper.insertJoinMgr(mgr);
            }
        }

        List<JoinAgreeDTO> agreeList = dto.getAgreeList();
        if (agreeList != null) {
            for (JoinAgreeDTO agr : agreeList) {
                if (agr == null || isBlank(agr.getAgreeCd())) continue;
                agr.setReqNo(reqNo);
                if (agr.getVerNo() == null)  agr.setVerNo(Integer.valueOf(1));
                if (isBlank(agr.getAgreeYn())) agr.setAgreeYn("N");
                if (isBlank(agr.getReadYn()))  agr.setReadYn("N");
                agr.setAgreeIp(dto.getRegIp());
                agr.setAgreeNm(dto.getMbrNm());
                agr.setRegUser(dto.getEmail());
                mapper.insertJoinAgree(agr);
            }
        }

        mapper.insertJoinHis(dto);
        return reqNo;
    }

    private boolean isBlank(String s) {
        return s == null || s.trim().length() == 0;
    }

}
