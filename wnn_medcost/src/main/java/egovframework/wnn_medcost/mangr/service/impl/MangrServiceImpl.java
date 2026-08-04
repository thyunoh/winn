package egovframework.wnn_medcost.mangr.service.impl;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.Collections;

import javax.annotation.Resource;
import javax.servlet.http.Part;
import javax.transaction.Transactional;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import egovframework.wnn_medcost.base.model.CodeMdDTO;
import egovframework.wnn_medcost.mangr.mapper.MangrMapper;
import egovframework.wnn_medcost.mangr.model.AsqDTO;
import egovframework.wnn_medcost.mangr.model.ChartDTO;
import egovframework.wnn_medcost.mangr.model.FaqDTO;
import egovframework.wnn_medcost.mangr.model.FileDTO;
import egovframework.wnn_medcost.mangr.model.NotiDTO;
import egovframework.wnn_medcost.mangr.model.VisitAsqDTO;
import egovframework.wnn_medcost.mangr.service.MangrService;
import egovframework.wnn_medcost.user.model.LisenceDTO;

@Service("MangrService")
public class MangrServiceImpl implements MangrService {

	private static final Logger LOGGER = LoggerFactory.getLogger(MangrServiceImpl.class);
	
	@Autowired
	private MangrMapper mapper;

	public List<CodeMdDTO> getCommList(List<String> codeGbList, List<String> codeCdList) {
        
        try {
        	// 파라미터를 Map 형태로 준비
            Map<String, Object> params = new HashMap<>();
            
            params.put("codeGbList", codeGbList);
            params.put("codeCdList", codeCdList);
            
            return mapper.getCommList(params);
            
        } catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList(); // 빈 리스트 반환
        }
    }

	@Override
	public List<FaqDTO> getfaqCdList(FaqDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.getfaqCdList(dto) ;
	}

	@Override
	public boolean insertfaqCd(FaqDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.insertfaqCd(dto) ;
	}

	@Override
	public boolean updatefaqCd(FaqDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.updatefaqCd(dto) ;
	}

	@Override
	public String faqCdDupChk(FaqDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.faqCdDupChk(dto) ;
	}

	@Override
	public List<NotiDTO> getnotiCdList(NotiDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.getnotiCdList(dto) ;
	}

	@Override
	public int insertnotiCd(NotiDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.insertnotiCd(dto) ;
	}

	@Override
	public boolean updatenotiCd(NotiDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.updatenotiCd(dto) ;
	}

	@Override
	public String notiCdDupChk(NotiDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.notiCdDupChk(dto) ;
	}
  //문서등록 
	@Override
	public int insertFileCd(FileDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.insertFileCd(dto) ;
	}

	@Override
	public boolean updateFileCd(FileDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.updateFileCd(dto) ;
	}

	@Override
	public boolean updateFilePath(FileDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.updateFilePath(dto) ;
	}

	@Override
	public List<AsqDTO> getasqCdList(AsqDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.getasqCdList(dto) ;
	}

	@Override
	public boolean updateasqCd(AsqDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.updateasqCd(dto) ;
	}

	@Override
	public String asqCdDupChk(AsqDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.asqCdDupChk(dto) ;
	}

	@Override
	public int selectAsqUnreadCnt(AsqDTO dto) throws Exception {
		return mapper.selectAsqUnreadCnt(dto) ;
	}

	@Override
	public int updateAsqRead(AsqDTO dto) throws Exception {
		return mapper.updateAsqRead(dto) ;
	}

	@Override
	public void saveFile(String fileName, String filePath, String hospCd ,  
    		      String fileGb, String notiSeq ,  String regUser, String regIp , String fileSize) {
        FileDTO dto = new FileDTO();
        dto.setHospCd(hospCd);
        dto.setFileGb(fileGb);
        dto.setFileSeq(notiSeq);
        dto.setFileTitle(fileName);
        dto.setFilePath(filePath.toString());
        dto.setRegUser(regUser);
        dto.setRegIp(regIp);
        dto.setFileSize(fileSize);

        try {
			mapper.saveFileCd(dto);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} // ✅ DB 저장
    }

	@Override
	public List<FileDTO> getFileCdList(FileDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.getFileCdList(dto) ;
	}

	@Override
	public void deleteFile(String hospCd , String  filePath , String fileSeq 
			                             , String fileGb , String updUser , String  updIp ) { 
		FileDTO dto = new FileDTO();
        dto.setFileGb(fileGb);
        dto.setFileSeq(fileSeq);
        dto.setFilePath(filePath.toString());
        dto.setUpdUser(updUser);
        dto.setUpdIp(updIp);
		try {
			mapper.deleteFileCd(dto) ;
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	@Override
	public AsqDTO selectQstnInfo(AsqDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.selectQstnInfo(dto) ;
	}

	@Override
	public boolean insertQstnCd(AsqDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.insertQstnCd(dto) ;
	}
	@Override
	public boolean updateQstnMst(AsqDTO dto) throws Exception {
		return mapper.updateQstnMst(dto);
	}
	@Override
	public boolean updateQstnCd(AsqDTO dto) throws Exception {
		return mapper.updateQstnCd(dto);
	}

	@Override
	public NotiDTO selectNotiBySeq(int notiSeq) throws Exception {
		// TODO Auto-generated method stub
		return mapper.selectNotiBySeq(notiSeq) ;
	}

	@Override
	public boolean delupdatenotiCd(NotiDTO dto) throws Exception {
		// TODO Auto-generated method stub
		return mapper.delupdatenotiCd(dto) ;
	}

	@Override
	public List<VisitAsqDTO> getVisitAsqList(VisitAsqDTO dto) throws Exception {
		return mapper.getVisitAsqList(dto);
	}

	@Override
	public boolean updateVisitAsqComform(VisitAsqDTO dto) throws Exception {
		return mapper.updateVisitAsqComform(dto);
	}

	/* ====================================================================
	   적정성평가 Q&A 챗봇 (2026-08-04)
	     · 지식 원본  : TBL_QNA_KB (사내 확정지식 44건 + 심평원 교육자료 원문)
	     · 화면 진입  : 카테고리 목록 + 자주하는 질문 순위를 한 번에 내려준다.
	     · 질문 기록  : 답을 줬든 못 줬든 TBL_QNA_LOG 에 남긴다.
	       ★ 로그·조회수 적재가 실패해도 <답변은 정상으로 나가야> 하므로 삼키고 로그만 남긴다.
	   ==================================================================== */

	/** 화면 진입 — 카테고리(대·중분류, 건수 포함) + 자주하는 질문 순위 */
	@Override
	public Map<String,Object> qnaInit(int topCnt) throws Exception {
		Map<String,Object> p = new HashMap<>();
		p.put("topCnt", topCnt <= 0 ? 12 : topCnt);

		Map<String,Object> res = new HashMap<>();
		res.put("cats", mapper.selectQnaCatList());
		res.put("top",  mapper.selectQnaTopList(p));
		return res;
	}

	/** 카테고리(대분류 또는 중분류)에 속한 질문 목록 */
	@Override
	public List<Map<String,Object>> qnaList(String catId, String subId) throws Exception {
		Map<String,Object> p = new HashMap<>();
		p.put("catId", catId);
		p.put("subId", subId);
		return mapper.selectQnaKbList(p);
	}

	/** 질문 한 건의 답변 — 조회수 +1, 연관질문 동봉, 로그 기록 */
	@Override
	public Map<String,Object> qnaGet(String kbId, String kbCode, String askType,
	                                 String hospCd, String userId, String qText) throws Exception {
		Map<String,Object> p = new HashMap<>();
		p.put("kbId",   (kbId   != null && !kbId.trim().isEmpty())   ? kbId.trim()   : null);
		p.put("kbCode", (kbCode != null && !kbCode.trim().isEmpty()) ? kbCode.trim() : null);

		Map<String,Object> kb = mapper.selectQnaKb(p);
		Map<String,Object> res = new HashMap<>();
		if (kb == null) { res.put("found", false); return res; }

		String relIds = (String) kb.get("relIds");
		if (relIds != null && !relIds.trim().isEmpty()) {
			Map<String,Object> rp = new HashMap<>();
			rp.put("relIds", relIds.trim());
			kb.put("rel", mapper.selectQnaRelList(rp));
		}
		res.put("found", true);
		res.put("kb", kb);

		Object id = kb.get("kbId");
		try {
			Map<String,Object> h = new HashMap<>();
			h.put("kbId", id);
			mapper.updateQnaHit(h);
			writeLog(hospCd, userId, (qText != null && !qText.trim().isEmpty()) ? qText : String.valueOf(kb.get("title")),
			         id, "Y", (askType == null || askType.trim().isEmpty()) ? "PICK" : askType);
		} catch (Exception e) {
			LOGGER.warn("[QNA] 조회수/로그 적재 실패 (답변은 정상) : {}", e.getMessage());
		}
		return res;
	}

	/** 질문 검색 — 결과 목록만 돌려주고, 본문은 사용자가 고른 뒤 qnaGet 으로 받는다 */
	@Override
	public Map<String,Object> qnaSearch(String q, int listCnt, String hospCd, String userId) throws Exception {
		Map<String,Object> res = new HashMap<>();
		String key = (q == null) ? "" : q.trim();
		if (key.isEmpty()) { res.put("list", new ArrayList<Map<String,Object>>()); return res; }

		Map<String,Object> p = new HashMap<>();
		p.put("q", key);
		p.put("listCnt", listCnt <= 0 ? 8 : listCnt);
		p.put("words", splitWords(key));
		List<Map<String,Object>> list = mapper.selectQnaSearch(p);
		res.put("list", list);

		try {
			boolean hit = (list != null && !list.isEmpty());
			writeLog(hospCd, userId, key, hit ? list.get(0).get("kbId") : null, hit ? "Y" : "N", "TYPE");
		} catch (Exception e) {
			LOGGER.warn("[QNA] 질문로그 적재 실패 (검색은 정상) : {}", e.getMessage());
		}
		return res;
	}

	/** 검색어를 낱말로 쪼갠다 — 제목 적중 가산에 쓴다.
	 *  한 글자 낱말과 흔한 꼬리말("무엇","어떻게" 등)은 아무 데나 걸려 순위를 흐리므로 뺀다.
	 *  낱말이 많으면 앞의 4개만 쓴다(조건이 길어질수록 느려진다). */
	private static final String QNA_STOP = "무엇|어떻게|어떤|얼마|언제|어디|누구|경우|여부|기준|방법|산정|가능|알려|주세요|해야|하나요|인가요|입니까|건가요|되나요";
	private List<String> splitWords(String q) {
		List<String> out = new ArrayList<>();
		if (q == null) return out;
		for (String w : q.replaceAll("[^0-9A-Za-z가-힣]+", " ").trim().split("\\s+")) {
			if (w.length() < 2) continue;
			if (w.matches(QNA_STOP)) continue;
			if (!out.contains(w)) out.add(w);
			if (out.size() >= 4) break;
		}
		return out;
	}

	private void writeLog(String hospCd, String userId, String qText, Object kbId,
	                      String matchYn, String askType) throws Exception {
		Map<String,Object> l = new HashMap<>();
		l.put("hospCd",  hospCd);
		l.put("userId",  userId);
		l.put("qText",   (qText == null) ? "" : (qText.length() > 480 ? qText.substring(0, 480) : qText));
		l.put("kbId",    kbId);
		l.put("matchYn", matchYn);
		l.put("askType", askType);
		mapper.insertQnaLog(l);
	}
}