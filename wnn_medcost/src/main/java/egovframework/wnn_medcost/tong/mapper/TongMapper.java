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
	List<TongDTO>    tong08List(TongDTO dto)      throws Exception;
	List<Map<String, Object>> drugItemList(TongDTO dto) throws Exception;
	List<Map<String, Object>> drugLicList(TongDTO dto) throws Exception;
	List<Map<String, Object>> drugBreakList(TongDTO dto) throws Exception;   // 종별 × 외래입원 약제비   // 면허번호별 약제비   // 2026-10-16 약제 청구 현황 — 품목코드(EDI_CODE)별 청구분 · 정액분
	List<TongDTO>    tong082List(TongDTO dto)     throws Exception;
	List<TongDTO>    tong09List(TongDTO dto)      throws Exception;
	List<TongDTO>    tong083List(TongDTO dto)     throws Exception;
}
