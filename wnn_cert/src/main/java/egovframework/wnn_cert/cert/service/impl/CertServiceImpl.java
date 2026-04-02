package egovframework.wnn_cert.cert.service.impl;

import egovframework.wnn_cert.cert.mapper.CertMapper;
import egovframework.wnn_cert.cert.model.*;
import egovframework.wnn_cert.cert.service.CertService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service("CertService")
public class CertServiceImpl implements CertService {

    @Autowired
    private CertMapper certMapper;

    @Override
    public List<TreeDTO> getTreeList(TreeDTO dto) throws Exception {
        return certMapper.getTreeList(dto);
    }

    @Override
    public List<TreeDTO> getTreeAll(TreeDTO dto) throws Exception {
        return certMapper.getTreeAll(dto);
    }

    @Override
    public boolean insertTree(TreeDTO dto) throws Exception {
        return certMapper.insertTree(dto);
    }

    @Override
    public boolean updateTree(TreeDTO dto) throws Exception {
        return certMapper.updateTree(dto);
    }

    @Override
    public boolean deleteTree(TreeDTO dto) throws Exception {
        return certMapper.deleteTree(dto);
    }

    @Override
    public List<ItemDTO> getItemList(ItemDTO dto) throws Exception {
        return certMapper.getItemList(dto);
    }

    @Override
    public boolean insertItem(ItemDTO dto) throws Exception {
        return certMapper.insertItem(dto);
    }

    @Override
    public boolean updateItem(ItemDTO dto) throws Exception {
        return certMapper.updateItem(dto);
    }

    @Override
    public boolean deleteItem(ItemDTO dto) throws Exception {
        return certMapper.deleteItem(dto);
    }

    @Override
    public List<QpsDTO> getQpsList(QpsDTO dto) throws Exception {
        return certMapper.getQpsList(dto);
    }

    @Override
    public boolean insertQps(QpsDTO dto) throws Exception {
        return certMapper.insertQps(dto);
    }

    @Override
    public boolean updateQps(QpsDTO dto) throws Exception {
        return certMapper.updateQps(dto);
    }

    @Override
    public List<Map<String, Object>> getRefGroupList(Map<String, Object> param) throws Exception {
        return certMapper.getRefGroupList(param);
    }

    @Override
    public List<Map<String, Object>> getRefList(Map<String, Object> param) throws Exception {
        return certMapper.getRefList(param);
    }

    @Override
    public boolean insertRef(Map<String, Object> param) throws Exception {
        return certMapper.insertRef(param);
    }

    @Override
    public boolean updateRef(Map<String, Object> param) throws Exception {
        return certMapper.updateRef(param);
    }

    @Override
    public boolean deleteRef(Map<String, Object> param) throws Exception {
        return certMapper.deleteRef(param);
    }
}
