package egovframework.wnn_medcost.total.service.impl;


import java.util.Map;
import java.util.List;
import java.util.HashMap;
import java.util.ArrayList;
import java.util.Collections;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;


import egovframework.wnn_medcost.total.mapper.TotalMapper;
import egovframework.wnn_medcost.total.model.TotalDTO;
import egovframework.wnn_medcost.total.service.TotalService;


@Service("TotalService")
public class TotalServiceImpl implements TotalService {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(TotalServiceImpl.class);
	
	@Autowired
	private TotalMapper mapper; 
	
	@Override
	public List<TotalDTO> total_DataList_01(TotalDTO dto) {
		
		try {
			
			return mapper.total_DataList_01(dto);
			
		} catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList(); // 빈 리스트 반환
        }
	}
	
	@Override
	public List<TotalDTO> total_DataList_02(TotalDTO dto) {
		
		try {
			
			return mapper.total_DataList_02(dto);
			
		} catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList(); // 빈 리스트 반환
        }
	}
	@Override
	public List<TotalDTO> total_DataList_03(TotalDTO dto) {
		
		try {
			
			return mapper.total_DataList_03(dto);
			
		} catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList(); // 빈 리스트 반환
        }
	}
	@Override
	public List<TotalDTO> total_DataList_04(TotalDTO dto) {
		
		try {
			
			return mapper.total_DataList_04(dto);
			
		} catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList(); // 빈 리스트 반환
        }
	}
	@Override
	public List<TotalDTO> total_DataList_05(TotalDTO dto) {
		
		try {
			
			return mapper.total_DataList_05(dto);
			
		} catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList(); // 빈 리스트 반환
        }
	}
	@Override
	public List<TotalDTO> total_DataList_06(TotalDTO dto) {
		
		try {
			
			return mapper.total_DataList_06(dto);
			
		} catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList(); // 빈 리스트 반환
        }
	}
	@Override
	public List<TotalDTO> total_DataList_07(TotalDTO dto) {
		
		try {
			
			return mapper.total_DataList_07(dto);
			
		} catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList(); // 빈 리스트 반환
        }
	}
	@Override
	public List<TotalDTO> total_DataList_08(TotalDTO dto) {
		
		try {
			
			return mapper.total_DataList_08(dto);
			
		} catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList(); // 빈 리스트 반환
        }
	}
	@Override
	public List<TotalDTO> total_DataList_09(TotalDTO dto) {
		
		try {
			
			return mapper.total_DataList_09(dto);
			
		} catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList(); // 빈 리스트 반환
        }
	}
	@Override
	public List<TotalDTO> total_DataList_10(TotalDTO dto) {
		
		try {
			
			return mapper.total_DataList_10(dto);
			
		} catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList(); // 빈 리스트 반환
        }
	}
	@Override
	public List<TotalDTO> total_DataList_11(TotalDTO dto) {
		
		try {
			
			return mapper.total_DataList_11(dto);
			
		} catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList(); // 빈 리스트 반환
        }
	}
	@Override
	public List<TotalDTO> total_DataList_12(TotalDTO dto) {
		
		try {
			
			return mapper.total_DataList_12(dto);
			
		} catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList(); // 빈 리스트 반환
        }
	}
	@Override
	public List<TotalDTO> total_DataList_13(TotalDTO dto) {
		
		try {
			
			return mapper.total_DataList_13(dto);
			
		} catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList(); // 빈 리스트 반환
        }
	}
	@Override
	public List<TotalDTO> total_DataList_14(TotalDTO dto) {
		
		try {
			
			return mapper.total_DataList_14(dto);
			
		} catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList(); // 빈 리스트 반환
        }
	}

	@Override
	public List<TotalDTO> total_DataList_09_Sub(TotalDTO dto) throws Exception {
		try {
			
			return mapper.total_DataList_09_Sub(dto);
			
		} catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList(); // 빈 리스트 반환
        }
	}

}
