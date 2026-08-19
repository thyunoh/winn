package egovframework.wnn_consult.join.service;

import java.util.List;

import egovframework.wnn_consult.join.model.AgreeMdDTO;
import egovframework.wnn_consult.join.model.JoinReqDTO;

public interface JoinService {

    List<AgreeMdDTO> selAgreeList(AgreeMdDTO dto) throws Exception;

    JoinReqDTO selHospChk(JoinReqDTO dto)  throws Exception;
    JoinReqDTO selEmailChk(JoinReqDTO dto) throws Exception;

    /** 신청 + 담당자 + 동의 + 이력을 한 트랜잭션으로 저장 */
    Long insertJoinReq(JoinReqDTO dto) throws Exception;

}
