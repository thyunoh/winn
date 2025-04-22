package egovframework.wnn_medcost.chung.service;

import java.io.File;
import java.io.IOException;
import java.nio.file.Path;
import java.util.List;
import java.util.Map;

import javax.servlet.http.Part;

import egovframework.wnn_medcost.chung.model.ChungDTO;

public interface ChungService {
	List<ChungDTO>    chungList(ChungDTO dto)        throws Exception;
	List<ChungDTO>    myoungList(ChungDTO dto)       throws Exception;
	List<ChungDTO>    diseList(ChungDTO dto)         throws Exception;
	List<ChungDTO>    jinordList(ChungDTO dto)       throws Exception;
	List<ChungDTO>    hangList(ChungDTO dto)         throws Exception;
	List<ChungDTO>    spcList(ChungDTO dto)          throws Exception;
	boolean           temp_suga_mst(ChungDTO dto)    throws Exception;
}