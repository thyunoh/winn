package egovframework.wnn_cert.improve.service.impl;

import egovframework.wnn_cert.improve.mapper.ImproveMapper;
import egovframework.wnn_cert.improve.model.ImproveDTO;
import egovframework.wnn_cert.improve.service.ImproveService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service("ImproveService")
public class ImproveServiceImpl implements ImproveService {

    @Autowired
    private ImproveMapper improveMapper;

    @Override
    public List<ImproveDTO> getImproveList(ImproveDTO dto) throws Exception {
        return improveMapper.getImproveList(dto);
    }

    @Override
    public ImproveDTO getImproveInfo(ImproveDTO dto) throws Exception {
        return improveMapper.getImproveInfo(dto);
    }

    @Override
    public boolean insertImprove(ImproveDTO dto) throws Exception {
        return improveMapper.insertImprove(dto);
    }

    @Override
    public boolean updateImprove(ImproveDTO dto) throws Exception {
        return improveMapper.updateImprove(dto);
    }

    @Override
    public boolean deleteImprove(ImproveDTO dto) throws Exception {
        return improveMapper.deleteImprove(dto);
    }
}
