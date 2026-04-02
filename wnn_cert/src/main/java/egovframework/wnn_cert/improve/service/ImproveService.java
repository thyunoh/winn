package egovframework.wnn_cert.improve.service;

import egovframework.wnn_cert.improve.model.ImproveDTO;

import java.util.List;

public interface ImproveService {

    List<ImproveDTO> getImproveList(ImproveDTO dto) throws Exception;

    ImproveDTO getImproveInfo(ImproveDTO dto) throws Exception;

    boolean insertImprove(ImproveDTO dto) throws Exception;

    boolean updateImprove(ImproveDTO dto) throws Exception;

    boolean deleteImprove(ImproveDTO dto) throws Exception;
}
