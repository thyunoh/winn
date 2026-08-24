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

    /* 병원 쪽 — 승인 후 동의서 원본 제출 */
    JoinReqDTO selMyJoinReq(JoinReqDTO dto) throws Exception;
    int  updateDocSubmit(JoinReqDTO dto) throws Exception;
    int  selDocGate(String hospCd) throws Exception;

    /* 승인 롤백 */
    JoinReqDTO selReqKeys(JoinReqDTO dto) throws Exception;
    int  selContCnt(String hospCd) throws Exception;
    int  selOtherUserCnt(JoinReqDTO dto) throws Exception;
    int  selHospUuidChk(JoinReqDTO dto) throws Exception;
    int  delHospSignFromReq(JoinReqDTO dto) throws Exception;
    int  delMemberFromReq(JoinReqDTO dto) throws Exception;
    int  delUserFromReq(JoinReqDTO dto) throws Exception;
    int  delHospFromReq(JoinReqDTO dto) throws Exception;
    int  updateReqRollback(JoinReqDTO dto) throws Exception;
    int  delContFromReq(JoinReqDTO dto) throws Exception;
    java.util.List<java.util.Map<String,Object>> selJoinFileList(JoinReqDTO dto) throws Exception;
    int  delJoinFiles(JoinReqDTO dto) throws Exception;
    int  updateReqUnreject(JoinReqDTO dto) throws Exception;
    int updateMyJoinReq(JoinReqDTO dto) throws Exception;
    int updateHospFromMy(JoinReqDTO dto) throws Exception;
    int updateContOcsFromMy(JoinReqDTO dto) throws Exception;   /* 2026-08-24 : 계약의 빈 OCS 정보 채움 */
    java.util.List<String> selContGbList(String hospCd) throws Exception;   /* 2026-08-24 : 승인 계약의 구분 목록 */
    int updateReqCancel(JoinReqDTO dto) throws Exception;
    int updateMgrCancel(JoinReqDTO dto) throws Exception;

    /* ★2026-08-24 — 승인 후 화면에서 담당자·동의를 채운다(신청 단계에서 옮겨 온 항목).
       담당자는 <통째로 갈아끼운다> — 지운 뒤 다시 넣는다.
       행마다 대조하면 MGR_SEQ(구분별 일련번호)가 꼬여 같은 담당자가 두 번 들어간다. */
    java.util.List<java.util.Map<String,Object>> selAgreeMstList() throws Exception;
    int deleteJoinMgrAll(JoinReqDTO dto) throws Exception;
    int insertJoinMgr(egovframework.wnn_medcost.join.model.JoinMgrDTO dto) throws Exception;
    int insertJoinAgree(egovframework.wnn_medcost.join.model.JoinAgreeDTO dto) throws Exception;
}
