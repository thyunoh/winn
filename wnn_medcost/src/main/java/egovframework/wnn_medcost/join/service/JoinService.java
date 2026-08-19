package egovframework.wnn_medcost.join.service;

import java.util.List;

import egovframework.wnn_medcost.join.model.JoinAgreeDTO;
import egovframework.wnn_medcost.join.model.JoinMgrDTO;
import egovframework.wnn_medcost.join.model.JoinReqDTO;

public interface JoinService {
    List<JoinReqDTO>   selJoinReqList(JoinReqDTO dto)   throws Exception;
    JoinReqDTO         selJoinReqInfo(JoinReqDTO dto)   throws Exception;
    List<JoinMgrDTO>   selJoinMgrList(JoinReqDTO dto)   throws Exception;
    List<JoinAgreeDTO> selJoinAgreeList(JoinReqDTO dto) throws Exception;

    /** 승인 — 병원 생성 · 사용자 연계 · 회원행 · 동의 확정 · 상태변경을 한 트랜잭션으로 */
    void confirm(JoinReqDTO dto) throws Exception;
    /** 반려 */
    void reject(JoinReqDTO dto)  throws Exception;

    /** 접수 대기 건수 */
    int selJoinReqCnt() throws Exception;
}
