package egovframework.wnn_medcost.chung.mapper;

import java.util.Map;
import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import egovframework.wnn_medcost.chung.model.ChungDTO;
@Mapper("chungMapper")
public interface ChungMapper {	
	
	List<ChungDTO>    chungList(ChungDTO dto)          throws Exception;
	List<ChungDTO>    myoungList(ChungDTO dto)         throws Exception;
	List<ChungDTO>    diseList(ChungDTO dto)           throws Exception;
	List<ChungDTO>    jinordList(ChungDTO dto)         throws Exception;
	List<ChungDTO>    hangList(ChungDTO dto)           throws Exception;
	List<ChungDTO>    spcList(ChungDTO dto)            throws Exception;
	boolean           temp_suga_mst(ChungDTO dto)      throws Exception;
}
