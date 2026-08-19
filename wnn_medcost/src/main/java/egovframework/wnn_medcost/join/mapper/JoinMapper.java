package egovframework.wnn_medcost.join.mapper;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import egovframework.wnn_medcost.join.model.JoinAgreeDTO;
import egovframework.wnn_medcost.join.model.JoinMgrDTO;
import egovframework.wnn_medcost.join.model.JoinReqDTO;

/**
 * 신규병원 가입신청 — 위너넷 관리자용(조회·승인).
 *
 * 신청 자체는 wnn_consult(로그인 화면의 [신규병원 가입신청])에서 들어오고,
 * 확인·승인은 사이드바가 있는 이 프로그램에서 한다. 두 앱이 같은 DB(WNN)를 본다.
 */
@Mapper("JoinMapper")
public interface JoinMapper {

    List<JoinReqDTO>   selJoinReqList(JoinReqDTO dto)   throws Exception;
    JoinReqDTO         selJoinReqInfo(JoinReqDTO dto)   throws Exception;
    List<JoinMgrDTO>   selJoinMgrList(JoinReqDTO dto)   throws Exception;
    List<JoinAgreeDTO> selJoinAgreeList(JoinReqDTO dto) throws Exception;

    /* 승인 처리 — 서비스에서 한 트랜잭션으로 묶는다 */
    String  selReqStat(JoinReqDTO dto)            throws Exception;
    int     selHospExists(JoinReqDTO dto)         throws Exception;
    boolean insertHospFromReq(JoinReqDTO dto)     throws Exception;
    boolean insertUserFromReq(JoinReqDTO dto)     throws Exception;
    boolean insertMemberFromReq(JoinReqDTO dto)   throws Exception;
    boolean insertHospSignFromReq(JoinReqDTO dto) throws Exception;
    boolean updateReqConfirm(JoinReqDTO dto)      throws Exception;
    boolean updateReqReject(JoinReqDTO dto)       throws Exception;
    boolean insertJoinHisAdm(JoinReqDTO dto)      throws Exception;

    /** 접수 대기(10·20) 건수 — 사이드바 메뉴 노출 판단용 */
    int selJoinReqCnt() throws Exception;
}
