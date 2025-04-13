package egovframework.wnn_medcost.tong.mapper;

import java.util.Map;
import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import egovframework.wnn_medcost.tong.model.TongDTO;
@Mapper("tongMapper")
public interface TongMapper {	
	
	List<TongDTO>    tong00List(TongDTO dto)       throws Exception;
	List<TongDTO>    tong01List(TongDTO dto)      throws Exception;
	List<TongDTO>    tong02List(TongDTO dto)      throws Exception;
	List<TongDTO>    tong03List(TongDTO dto)      throws Exception;
	List<TongDTO>    tong04List(TongDTO dto)      throws Exception;
	List<TongDTO>    tong05List(TongDTO dto)      throws Exception;
	List<TongDTO>    tong06List(TongDTO dto)      throws Exception;
	List<TongDTO>    tong07List(TongDTO dto)      throws Exception;
}
