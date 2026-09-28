package egovframework.wnn_medcost.mangr.service.impl;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
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

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;

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

		List<String> words = splitWords(key);
		Map<String,Object> p = new HashMap<>();
		p.put("q", key);
		p.put("listCnt", listCnt <= 0 ? 8 : listCnt);
		p.put("words", words);
		List<Map<String,Object>> list = mapper.selectQnaSearch(p);
		res.put("list", list);

		/* 제대로 찾았는가? — 화면은 이 값으로 AI 참고답변 여부를 정한다 (2026-08-06)
		     ★"0건이면 AI" 로는 안 된다. ngram 이 '오래'·'점수' 같은 조각에도 걸려
		       엉뚱한 항목이 수십 건 잡히므로 0건 자체가 거의 안 난다
		       (예: "소변줄 오래 꽂으면 점수 깎이나요" → 30건, 1등이 '업로드가 너무 오래 걸립니다').
		     ★판정은 점수 절대값이 아니라 <낱말 적중 비율>로 한다. 점수는 낱말이 많을수록
		       통째로 커져서 기준으로 쓸 수 없다(검색 랭킹 튜닝 때 이미 겪은 함정).
		     낱말이 절반도 안 걸렸으면 못 찾은 것으로 본다. 낱말이 없으면(한 글자 검색 등) 판정하지 않는다. */
		boolean weak;
		if (list == null || list.isEmpty()) {
			weak = true;
		} else if (words.isEmpty()) {
			weak = false;
		} else {
			Object hit = list.get(0).get("wHit");
			int wHit = (hit instanceof Number) ? ((Number) hit).intValue() : 0;
			weak = (wHit * 2 < words.size());
		}
		res.put("weak", weak);

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
	/* ★뒤에 '환자·있는·누워' 류를 더한 이유 (2026-08-06 사용자 지적으로 확인) —
	     "침대에만 누워 있는 환자 욕창 관리 어떻게 하나요" 가 엉뚱한 <중환자실 행정해석>을 1등으로
	     물고 왔는데도 AI 로 안 넘어갔다. 앞에서 4개만 쓰다 보니 낱말이 [침대에·누워·있는·환자] 로
	     잡혀 <정작 핵심어인 욕창·관리가 잘려 나갔고>, 그 '환자' 가 "중환자실" 에 걸려
	     '제대로 찾았다'로 오판했다. 흔한 기능어·범용어는 변별력이 없어 빼고, 상한도 6으로 올린다. */
	private static final String QNA_STOP = "무엇|어떻게|어떤|얼마|언제|어디|누구|경우|여부|기준|방법|산정|가능|알려|주세요|해야|하나요|인가요|입니까|건가요|되나요"
	                                     + "|환자|있는|없는|하는|되는|같은|많은|누워|앉아|대한|위한|관련|때문|정도|무슨|이런|그런";
	private List<String> splitWords(String q) {
		List<String> out = new ArrayList<>();
		if (q == null) return out;
		for (String w : q.replaceAll("[^0-9A-Za-z가-힣]+", " ").trim().split("\\s+")) {
			w = stripJosa(w);
			if (w.length() < 2) continue;
			if (w.matches(QNA_STOP)) continue;
			if (!out.contains(w)) out.add(w);
			if (out.size() >= 6) break;
		}
		return out;
	}

	/** 낱말 끝의 조사를 뗀다 — "배뇨일지를" 이 제목의 "배뇨일지" 에 안 걸리는 것을 막는다.
	 *  ★떼고 나서 2글자가 안 되면 떼지 않는다 — 안 그러면 "수가"→"수", "자료"→"자" 처럼
	 *    끝 글자가 우연히 조사와 같은 <업무 용어>가 망가진다. */
	private static final String[] JOSA = { "에서", "으로", "까지", "부터",
	                                       "은", "는", "이", "가", "을", "를", "의", "에", "로", "와", "과", "도", "만" };
	private String stripJosa(String w) {
		/* 두 번까지 떼어 낸다 — "침대에만" 은 '만' 을 떼도 "침대에" 가 남아 제목의 "침대" 에 안 걸린다 */
		for (int n = 0; n < 2; n++) {
			if (w == null || w.length() < 3) return w;       /* 2글자 낱말은 손대지 않는다 */
			String before = w;
			for (int i = 0; i < JOSA.length; i++) {
				String j = JOSA[i];
				if (w.endsWith(j) && w.length() - j.length() >= 2) { w = w.substring(0, w.length() - j.length()); break; }
			}
			if (w.equals(before)) break;
		}
		return w;
	}

	/* ====================================================================
	   등록된 자료 밖 질문 → LLM(Gemini Flash) 참고답변 (2026-08-06)
	     · sejong_app 혈당 Q&A(BloodController.callGemini) 와 <같은 방식>이다.
	     · 화면에서 KB 검색이 0건일 때만 부른다. 자료가 있으면 그쪽이 우선이다.
	     · ★자료 밖 창작 금지 — selectQnaGround 로 가까운 지식 몇 건을 뽑아 <그 본문만>
	       근거로 넣고, "주어진 자료 안에서만 답하라"고 못박는다. 수가·점수를 지어내면
	       병원이 그대로 청구·평가에 반영해 실제 손해가 난다.
	     · 키가 없거나 호출이 실패하면 조용히 실패로 돌려준다 — 화면은 종전 안내문구로 폴백.
	   ==================================================================== */

	/** 무료 등급은 보낸 내용이 모델 개선에 쓰일 수 있다 → 환자 식별정보는 보내기 전에 지운다.
	 *  질문칸에 "홍길동 환자 주민번호 123456-1234567" 처럼 섞여 들어오는 경우가 있다. */
	private String maskPrivacy(String s) {
		if (s == null) return "";
		String out = s;
		out = out.replaceAll("\\d{6}\\s*[-–]\\s*\\d{7}", "[주민번호]");        /* 주민등록번호 */
		out = out.replaceAll("\\d{2,3}\\s*[-–]\\s*\\d{3,4}\\s*[-–]\\s*\\d{4}", "[전화번호]");
		out = out.replaceAll("[가-힣]{2,4}\\s*(환자|님|씨)(?=\\s|$|[,.])", "[환자]");
		return out;
	}

	@Override
	public Map<String,Object> qnaAsk(String q, String hospCd, String userId) throws Exception {
		Map<String,Object> res = new HashMap<>();
		String key = (q == null) ? "" : q.trim();
		if (key.isEmpty()) { res.put("ok", false); res.put("reason", "빈 질문"); return res; }
		if (key.length() > 500) key = key.substring(0, 500);      /* 프롬프트 인젝션·과금 폭증 방지 */

		String apiKey = geminiKey();
		if (apiKey == null) { res.put("ok", false); res.put("reason", "LLM 미설정"); return res; }

		/* ① 사용자가 친 말 그대로 근거 후보를 찾는다 */
		List<Map<String,Object>> ground = findGround(key, splitWords(key));

		/* ② 용어를 바꿔 한 번 더 찾는다 (2026-08-06)
		     ★이게 없으면 <자료가 있는데도> "등록된 자료에는 없습니다"가 나온다.
		       병원은 '소변줄'이라 하고 자료는 '유치도뇨관'이라 적혀 있어, 낱말이 안 걸려
		       엉뚱한 근거(욕창·격리·업로드)가 딸려 들어가기 때문이다. 실제로 겪은 것.
		     동의어 사전을 손으로 채우는 대신 LLM 에게 <공식 용어로 바꿔 달라>고 시킨다 —
		     현장 용어는 끝이 없어서 사전으로는 못 따라간다.
		     호출이 한 번 더 늘지만 같은 질문은 화면에서 캐시되므로 실제 부담은 작다. */
		String alt = rewriteTerms(apiKey, key);
		List<String> altWords = splitWords(alt);
		if (!altWords.isEmpty()) {
			List<Map<String,Object>> more = findGround(alt, altWords);
			/* 바꾼 용어로 찾은 것을 <앞에> 둔다 — 주제에 더 가깝다 */
			for (int i = 0; i < ground.size(); i++) {
				boolean dup = false;
				for (int j = 0; j < more.size(); j++)
					if (String.valueOf(more.get(j).get("kbId")).equals(String.valueOf(ground.get(i).get("kbId")))) { dup = true; break; }
				if (!dup) more.add(ground.get(i));
			}
			ground = (more.size() > 6) ? new ArrayList<Map<String,Object>>(more.subList(0, 6)) : more;
		}

		StringBuilder ctx = new StringBuilder();
		List<Map<String,Object>> refs = new ArrayList<Map<String,Object>>();
		if (ground != null) {
			for (int i = 0; i < ground.size(); i++) {
				Map<String,Object> g = ground.get(i);
				String title = String.valueOf(g.get("title"));
				String body  = (g.get("body") == null) ? "" : String.valueOf(g.get("body"));
				ctx.append("[자료").append(i + 1).append("] ").append(title).append('\n')
				   .append(body).append("\n\n");
				Map<String,Object> r = new HashMap<>();
				r.put("kbId",  g.get("kbId"));
				r.put("title", title);
				refs.add(r);
			}
		}

		String sys =
			  "너는 요양병원 <적정성평가·수가> 실무를 돕는 한국어 도우미다. "
			+ "아래 [등록자료] 안에 있는 내용으로만 답해라. "
			+ "자료에 근거가 없으면 지어내지 말고 '등록된 자료에는 이 내용이 없습니다'라고만 답하고, "
			+ "위너넷 1:1 문의로 확인하도록 안내해라. "
			+ "점수·수가 금액·기간 같은 숫자는 자료에 적힌 것만 그대로 말하고, 추정하지 마라. "
			+ "답변은 300자 내외로 간결하게, 줄바꿈은 그냥 개행으로 한다. 표나 마크다운 기호는 쓰지 마라.\n\n"
			+ "[등록자료]\n" + (ctx.length() == 0 ? "(해당하는 자료 없음)" : ctx.toString());

		String answer = null;
		try {
			answer = callGemini(apiKey, sys, maskPrivacy(key));
		} catch (Exception e) {
			LOGGER.warn("[QNA-AI] 호출 오류 : {}", e.getMessage());
		}
		if (answer == null || answer.trim().isEmpty()) {
			res.put("ok", false); res.put("reason", "LLM 응답 없음");
			return res;
		}

		res.put("ok", true);
		res.put("answer", answer.trim());
		res.put("refs", refs);
		res.put("alt", (altWords.isEmpty() ? "" : join(altWords)));   /* 화면의 [이 용어로 다시 검색] 버튼용 */

		/* 로그 — MATCH_YN 은 'N' 그대로다. AI 가 답했어도 <지식에는 없는 질문>이라
		   다음 지식 보강 대상 목록에 계속 남아야 한다. askType 으로만 구분한다. */
		try { writeLog(hospCd, userId, key, null, "N", "AI"); }
		catch (Exception e) { LOGGER.warn("[QNA-AI] 질문로그 적재 실패 (답변은 정상) : {}", e.getMessage()); }
		return res;
	}

	/** 근거 후보 조회 — 실패해도 빈 목록으로 진행한다(근거 없이도 답은 시도한다) */
	private List<Map<String,Object>> findGround(String q, List<String> words) {
		Map<String,Object> p = new HashMap<>();
		p.put("q", q);
		p.put("words", words);
		p.put("listCnt", 6);
		try {
			List<Map<String,Object>> r = mapper.selectQnaGround(p);
			return (r == null) ? new ArrayList<Map<String,Object>>() : new ArrayList<Map<String,Object>>(r);
		} catch (Exception e) {
			LOGGER.warn("[QNA-AI] 근거 조회 실패 (근거 없이 진행) : {}", e.getMessage());
			return new ArrayList<Map<String,Object>>();
		}
	}

	private String join(List<String> l) {
		StringBuilder sb = new StringBuilder();
		for (int i = 0; i < l.size(); i++) { if (i > 0) sb.append(' '); sb.append(l.get(i)); }
		return sb.toString();
	}

	/** 현장 용어 → 심평원 공식 용어. 키워드만 한 줄로 받아 온다(실패하면 빈 문자열). */
	private String rewriteTerms(String apiKey, String q) {
		String sys =
			  "너는 요양병원 적정성평가 자료를 찾아 주는 검색어 변환기다. "
			+ "사용자가 현장에서 쓰는 말을 심사평가원 공식 용어로 바꿔, 검색 키워드만 3~5개 "
			+ "공백으로 구분해 <한 줄>로 출력해라. 설명·문장·기호·따옴표는 절대 쓰지 마라.\n"
			+ "예) 소변줄 → 유치도뇨관 유지기간 배뇨관리 / 기저귀 → 배뇨관리 배뇨일지 / "
			+ "욕창약 → 욕창 처치 피부손상 / 밥줄 콧줄 → 경관영양 영양관리";
		try {
			String r = callGemini(apiKey, sys, maskPrivacy(q));
			if (r == null) return "";
			/* 혹시 여러 줄로 오면 첫 줄만, 기호는 털어낸다 */
			r = r.trim().split("\\r?\\n")[0].replaceAll("[\"'`,/·:\\-]", " ").trim();
			return (r.length() > 120) ? r.substring(0, 120) : r;
		} catch (Exception e) {
			LOGGER.warn("[QNA-AI] 용어 변환 실패 (원래 검색어로 진행) : {}", e.getMessage());
			return "";
		}
	}

	/** API 키 — 환경변수 우선, 없으면 -D 시스템 프로퍼티. ★소스·설정파일에 평문으로 넣지 않는다.
	 *  운영서버는 톰캣 setenv.sh 에 export GEMINI_API_KEY=... 로 넣는다. */
	private String geminiKey() {
		String k = System.getenv("GEMINI_API_KEY");
		if (k == null || k.trim().isEmpty()) k = System.getProperty("gemini.api.key");
		if (k == null) return null;
		k = k.trim();
		return (k.isEmpty() || k.startsWith("YOUR_")) ? null : k;
	}
	private String geminiUrl() {
		String u = System.getenv("GEMINI_API_URL");
		if (u == null || u.trim().isEmpty()) u = System.getProperty("gemini.api.url");
		if (u == null || u.trim().isEmpty())
			u = "https://generativelanguage.googleapis.com/v1beta/models/gemini-flash-latest:generateContent";
		return u.trim();
	}

	/** Gemini generateContent 호출 → 첫 후보 텍스트 (실패 시 null) */
	private String callGemini(String apiKey, String systemInstruction, String userText) {
		HttpURLConnection conn = null;
		try {
			Gson gson = new Gson();

			JsonObject sysPart = new JsonObject();
			sysPart.addProperty("text", systemInstruction);
			JsonArray sysParts = new JsonArray();
			sysParts.add(sysPart);
			JsonObject sysInstr = new JsonObject();
			sysInstr.add("parts", sysParts);

			JsonObject userPart = new JsonObject();
			userPart.addProperty("text", userText);
			JsonArray userParts = new JsonArray();
			userParts.add(userPart);
			JsonObject content = new JsonObject();
			content.addProperty("role", "user");
			content.add("parts", userParts);
			JsonArray contents = new JsonArray();
			contents.add(content);

			JsonObject genCfg = new JsonObject();
			genCfg.addProperty("temperature", 0.2);            /* 실무 답변이라 낮게 — 창의성 불필요 */
			/* ★추론(thinking) 예산 — 2026-08-06 gemini-flash-latest 로 실제 호출해 확인한 값이다.
			     · thinkingBudget 0  → 400 INVALID_ARGUMENT (모델이 거부한다. sejong_app 의 0 을
			                            그대로 가져오면 <매 호출 실패>한다 — 여기서 갈린다)
			     · thinkingConfig 생략 → 추론이 979 토큰까지 불어나 maxOutputTokens 를 다 먹고
			                            답변이 41 토큰에서 잘린다(finishReason=MAX_TOKENS)
			     · thinkingBudget 128 + maxOutputTokens 2048 → 정상 종료(STOP) 확인
			   모델을 바꾸면 이 조합을 다시 재 볼 것. */
			genCfg.addProperty("maxOutputTokens", 2048);
			JsonObject thinkingCfg = new JsonObject();
			thinkingCfg.addProperty("thinkingBudget", 128);
			genCfg.add("thinkingConfig", thinkingCfg);

			JsonObject reqBody = new JsonObject();
			reqBody.add("system_instruction", sysInstr);
			reqBody.add("contents", contents);
			reqBody.add("generationConfig", genCfg);

			/* 키는 헤더로 — URL 쿼리에 실으면 접속로그에 그대로 남는다 */
			URL url = new URL(geminiUrl());
			conn = (HttpURLConnection) url.openConnection();
			conn.setRequestMethod("POST");
			conn.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
			conn.setRequestProperty("x-goog-api-key", apiKey);
			conn.setDoOutput(true);
			conn.setConnectTimeout(10000);
			conn.setReadTimeout(30000);

			OutputStream os = conn.getOutputStream();
			try { os.write(gson.toJson(reqBody).getBytes("UTF-8")); os.flush(); }
			finally { os.close(); }

			int code = conn.getResponseCode();
			InputStream is = (code >= 200 && code < 300) ? conn.getInputStream() : conn.getErrorStream();
			StringBuilder sb = new StringBuilder();
			if (is != null) {
				BufferedReader in = new BufferedReader(new InputStreamReader(is, "UTF-8"));
				try { String line; while ((line = in.readLine()) != null) sb.append(line); }
				finally { in.close(); }
			}
			if (code < 200 || code >= 300) {
				LOGGER.warn("[QNA-AI] Gemini HTTP {} : {}", code, sb.toString());
				return null;
			}

			JsonObject root = gson.fromJson(sb.toString(), JsonObject.class);
			JsonArray candidates = (root == null) ? null : root.getAsJsonArray("candidates");
			if (candidates == null || candidates.size() == 0) return null;
			JsonObject cand = candidates.get(0).getAsJsonObject();

			/* 정상 종료가 아니면 로그로 남긴다 — MAX_TOKENS(답변 잘림)·SAFETY 를 눈으로 봐야
			   위 thinkingBudget/maxOutputTokens 조합을 다시 맞출 수 있다. */
			JsonElement fin = cand.get("finishReason");
			if (fin != null && !"STOP".equals(fin.getAsString()))
				LOGGER.warn("[QNA-AI] finishReason={} — 답변이 잘렸을 수 있다", fin.getAsString());

			JsonObject candContent = cand.getAsJsonObject("content");
			if (candContent == null) return null;
			JsonArray parts = candContent.getAsJsonArray("parts");
			if (parts == null || parts.size() == 0) return null;
			/* 첫 조각이 비어 있는 경우가 있어 <내용 있는 첫 조각>을 찾는다 */
			for (int i = 0; i < parts.size(); i++) {
				JsonElement textEl = parts.get(i).getAsJsonObject().get("text");
				if (textEl != null && !textEl.getAsString().trim().isEmpty()) return textEl.getAsString();
			}
			return null;

		} catch (Exception e) {
			LOGGER.error("[QNA-AI] callGemini error : " + e.getMessage(), e);
			return null;
		} finally {
			if (conn != null) try { conn.disconnect(); } catch (Exception ignore) { }
		}
	}

	/* ── 자주하는 질문 편집(위너넷 관리자, 2026-08-26) ─────────────────────
	     조회수 자동 순위는 안 쓰기로 확정 — 관리자가 등록·수정·해제한 지정(TOP_YN·TOP_NO)이 정본이다. */
	@Override
	public void qnaTopSave(String kbId, String title, String body, String catId, int topNo) throws Exception {
		Map<String,Object> p = new HashMap<>();
		p.put("title", title);
		p.put("body",  body);
		p.put("catId", catId);
		p.put("topNo", topNo);
		if (kbId != null && !kbId.trim().isEmpty()) {
			p.put("kbId", kbId.trim());
			mapper.updateQnaTop(p);
		} else {
			// KB_CODE 는 UNIQUE — 밀리초로 만들어 충돌을 피한다(관리자 등록분은 'WNNFAQ-' 접두로 구분)
			p.put("kbCode", "WNNFAQ-" + System.currentTimeMillis());
			mapper.insertQnaTop(p);
		}
	}

	@Override
	public void qnaTopDel(String kbId) throws Exception {
		Map<String,Object> p = new HashMap<>();
		p.put("kbId", kbId);
		mapper.deleteQnaTop(p);
	}

	/** 기존 질문을 자주하는 질문에 올린다 — 뺐던 것 되살리기 포함(내용은 안 건드린다) */
	@Override
	public void qnaTopAdd(String kbId, int topNo) throws Exception {
		Map<String,Object> p = new HashMap<>();
		p.put("kbId",  kbId);
		p.put("topNo", topNo);
		mapper.addQnaTop(p);
	}

	/** 질문 완전 삭제 — 분류·검색·자주 목록 모두에서 내린다(행은 USE_YN='N' 로 남겨 되살릴 수 있게) */
	@Override
	public void qnaKbDel(String kbId) throws Exception {
		Map<String,Object> p = new HashMap<>();
		p.put("kbId", kbId);
		mapper.deleteQnaKb(p);
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