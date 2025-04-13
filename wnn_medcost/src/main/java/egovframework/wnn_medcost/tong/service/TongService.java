package egovframework.wnn_medcost.tong.service;

import java.io.File;
import java.io.IOException;
import java.nio.file.Path;
import java.util.List;
import java.util.Map;

import javax.servlet.http.Part;

import egovframework.wnn_medcost.tong.model.TongDTO;

public interface TongService {
	List<TongDTO>     tong00List(TongDTO dto)       throws Exception;
	List<TongDTO>     tong01List(TongDTO dto)      throws Exception;
	List<TongDTO>     tong02List(TongDTO dto)      throws Exception;
	List<TongDTO>     tong03List(TongDTO dto)      throws Exception;
	List<TongDTO>     tong04List(TongDTO dto)      throws Exception;
	List<TongDTO>     tong05List(TongDTO dto)      throws Exception;
	List<TongDTO>     tong06List(TongDTO dto)      throws Exception;
	List<TongDTO>     tong07List(TongDTO dto)      throws Exception;
}