package egovframework.wnn_cert.cert.service;

import egovframework.wnn_cert.cert.model.*;

import java.util.List;
import java.util.Map;

public interface CertService {

    List<TreeDTO> getTreeList(TreeDTO dto) throws Exception;

    List<TreeDTO> getTreeAll(TreeDTO dto) throws Exception;

    boolean insertTree(TreeDTO dto) throws Exception;

    boolean updateTree(TreeDTO dto) throws Exception;

    boolean deleteTree(TreeDTO dto) throws Exception;

    List<ItemDTO> getItemList(ItemDTO dto) throws Exception;

    boolean insertItem(ItemDTO dto) throws Exception;

    boolean updateItem(ItemDTO dto) throws Exception;

    boolean deleteItem(ItemDTO dto) throws Exception;

    List<QpsDTO> getQpsList(QpsDTO dto) throws Exception;

    boolean insertQps(QpsDTO dto) throws Exception;

    boolean updateQps(QpsDTO dto) throws Exception;

    List<Map<String, Object>> getRefGroupList(Map<String, Object> param) throws Exception;

    List<Map<String, Object>> getRefList(Map<String, Object> param) throws Exception;

    boolean insertRef(Map<String, Object> param) throws Exception;

    boolean updateRef(Map<String, Object> param) throws Exception;

    boolean deleteRef(Map<String, Object> param) throws Exception;
}
