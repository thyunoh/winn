package egovframework.wnn_consult.join.mapper;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import egovframework.wnn_consult.join.model.AgreeMdDTO;
import egovframework.wnn_consult.join.model.JoinAgreeDTO;
import egovframework.wnn_consult.join.model.JoinMgrDTO;
import egovframework.wnn_consult.join.model.JoinReqDTO;

@Mapper("JoinMapper")
public interface JoinMapper {

    /** 화면에 뿌릴 동의서 목록(본문 포함) */
    List<AgreeMdDTO> selAgreeList(AgreeMdDTO dto) throws Exception;

    /** 요양기관기호 확인 — 이미 등록된 병원인지 / 진행중 신청이 있는지 */
    JoinReqDTO selHospChk(JoinReqDTO dto) throws Exception;

    /** 이메일 확인 — 이미 사용자·회원이거나 진행중 신청이 있는지 */
    JoinReqDTO selEmailChk(JoinReqDTO dto) throws Exception;

    boolean insertJoinReq(JoinReqDTO dto) throws Exception;
    boolean insertJoinMgr(JoinMgrDTO dto) throws Exception;
    boolean insertJoinAgree(JoinAgreeDTO dto) throws Exception;
    boolean insertJoinHis(JoinReqDTO dto) throws Exception;

}
