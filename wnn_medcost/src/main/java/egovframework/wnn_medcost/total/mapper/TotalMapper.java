package egovframework.wnn_medcost.total.mapper;

import java.util.Map;
import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import egovframework.wnn_medcost.total.model.TotalDTO;


@Mapper("TotalMapper")
public interface TotalMapper {
	
	List<TotalDTO> total_DataList_01(TotalDTO dto) throws Exception;
	List<TotalDTO> total_DataList_02(TotalDTO dto) throws Exception;
	List<TotalDTO> total_DataList_03(TotalDTO dto) throws Exception;
	List<TotalDTO> total_DataList_04(TotalDTO dto) throws Exception;
	List<TotalDTO> total_DataList_05(TotalDTO dto) throws Exception;
	List<TotalDTO> total_DataList_06(TotalDTO dto) throws Exception;
	List<TotalDTO> total_DataList_07(TotalDTO dto) throws Exception;
	List<TotalDTO> total_DataList_08(TotalDTO dto) throws Exception;
	List<TotalDTO> total_DataList_09(TotalDTO dto) throws Exception;
	List<TotalDTO> total_DataList_09_Sub(TotalDTO dto) throws Exception;
	List<TotalDTO> total_DataList_10(TotalDTO dto) throws Exception;
	List<TotalDTO> total_DataList_11(TotalDTO dto) throws Exception;
	List<TotalDTO> total_DataList_12(TotalDTO dto) throws Exception;
	List<TotalDTO> total_DataList_13(TotalDTO dto) throws Exception;
	List<TotalDTO> total_DataList_14(TotalDTO dto) throws Exception;
	
}
