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

    /* 병원 쪽 — 승인 후 동의서 원본 제출 */
    JoinReqDTO selMyJoinReq(JoinReqDTO dto) throws Exception;
    int  updateDocSubmit(JoinReqDTO dto) throws Exception;
    int  selDocGate(String hospCd) throws Exception;

    /** 승인 롤백 — 승인이 만든 병원·사용자·회원·동의확정을 지우고 접수(10)로 되돌린다. */
    void rollback(JoinReqDTO dto) throws Exception;

    /** 롤백 전에 지울 파일 목록 — SFTP 실제 파일은 트랜잭션 밖에서 지운다. */
    java.util.List<java.util.Map<String,Object>> selJoinFiles(JoinReqDTO dto) throws Exception;

    /** 반려취소 — 반려(90)를 접수(10)로 되돌린다. */
    void unreject(JoinReqDTO dto) throws Exception;

    /** 병원이 자기 신청내역(병원정보 7항목)을 고친다. */
    void updateMyJoinReq(JoinReqDTO dto) throws Exception;

    /* ★2026-08-24 — 승인 후 화면에서 동의를 받는다. 그 화면이 쓸 동의서 마스터 목록. */
    java.util.List<java.util.Map<String,Object>> selAgreeMstList() throws Exception;

    /* ★2026-08-24 — 승인이 만든 계약의 구분 목록(희망 서비스 자동체크·제출 검사용). */
    java.util.List<String> selContGbList(String hospCd) throws Exception;

    /** 신청 전체취소 — 접수·검토중·반려 건을 없던 일로 한다. */
    void cancelReq(JoinReqDTO dto) throws Exception;
}
