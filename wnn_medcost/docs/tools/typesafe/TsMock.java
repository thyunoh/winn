import java.io.*;
import java.lang.reflect.Method;
import java.net.InetSocketAddress;
import java.util.*;
import com.sun.net.httpserver.*;
import com.google.gson.*;
import egovframework.util.TypeSafeUtil;

/** 가짜 TypeSafe 서버로 TypeSafeUtil.rerank 와 MangrServiceImpl.rerankByTypeSafe(리플렉션)를 검사한다.
 *  · 요청 본문 모양(state.question / candidates[] / questions.cN noul) 확인
 *  · 응답 noul 로 순서가 바뀌는지 · 답 없는 후보는 뒤로 · 뒤 항목은 원래 순서 · excerpt 제거 · 실패 시 null 폴백 */
public class TsMock {
	static String lastBody = null;
	static int mode = 0;   // 0 정상 · 1 HTTP 500 · 2 answers 없음

	public static void main(String[] a) throws Exception { try { run(); } catch (Throwable t) { t.printStackTrace(); System.exit(2); } }
	static void run() throws Exception {
		HttpServer sv = HttpServer.create(new InetSocketAddress("127.0.0.1", 0), 0);
		sv.createContext("/v1/systemone", ex -> {
			lastBody = new String(ex.getRequestBody().readAllBytes(), "UTF-8");
			String auth = ex.getRequestHeaders().getFirst("Authorization");
			if (!"Bearer TESTKEY".equals(auth)) { send(ex, 401, "{\"error\":\"auth\"}"); return; }
			if (mode == 1) { send(ex, 500, "{\"error\":\"boom\"}"); return; }
			if (mode == 2) { send(ex, 200, "{\"model\":\"jev\"}"); return; }
			JsonObject req = new Gson().fromJson(lastBody, JsonObject.class);
			JsonObject qs = req.getAsJsonObject("questions");
			if (qs.has("pick")) {
				JsonObject crit = qs.getAsJsonObject("pick").getAsJsonObject("criteria");
				JsonObject probs = new JsonObject(); String best = null; int n = crit.size();
				for (String k : crit.keySet()) { double v = crit.get(k).getAsString().contains("환자안전") ? 0.7 : ("NONE".equals(k) ? 0.05 : 0.25/(n-2)); probs.addProperty(k, v); if (v == 0.7) best = k; }
				JsonObject an = new JsonObject(); an.addProperty("type","choice"); an.addProperty("choice", best); an.addProperty("confidence", 0.66); an.add("probabilities", probs);
				JsonObject answers = new JsonObject(); answers.add("pick", an);
				JsonObject res = new JsonObject(); res.addProperty("model","jev-mock"); res.add("answers", answers);
				send(ex, 200, new Gson().toJson(res)); return;
			}
			// 가짜 판정 : 후보 제목에 '유치도뇨관' 이 있으면 0.9, '배뇨' 0.6, 아니면 0.1 ; c3(400) 은 답을 안 준다
			JsonArray cands = req.getAsJsonObject("state").getAsJsonArray("candidates");
			JsonObject answers = new JsonObject();
			for (String id : qs.keySet()) {
				int i = Integer.parseInt(id.substring(1));
				if (i == 3) continue;
				String t = cands.get(i).getAsJsonObject().get("title").getAsString();
				double v = t.contains("유치도뇨관") ? 0.9 : (t.contains("배뇨") ? 0.6 : 0.1);
				JsonObject an = new JsonObject(); an.addProperty("type", "noul"); an.addProperty("noul", v);
				answers.add(id, an);
			}
			JsonObject res = new JsonObject(); res.addProperty("model", "jev-mock"); res.add("answers", answers);
			JsonObject usage = new JsonObject(); usage.addProperty("input_tokens", 100); usage.addProperty("output_tokens", 10); res.add("usage", usage);
			send(ex, 200, new Gson().toJson(res));
		});
		sv.start();
		int port = sv.getAddress().getPort();
		System.setProperty("typesafe.api.url", "http://127.0.0.1:" + port + "/v1/systemone");
		int pass = 0, fail = 0;

		// ① 키 없음 → null, 요청 안 나감
		System.clearProperty("typesafe.api.key");
		lastBody = null;
		Map<String, Double> r0 = TypeSafeUtil.rerank("q", cands(), 3000);
		if (r0 == null && lastBody == null) pass++; else { fail++; System.out.println("FAIL ① 키 없음"); }

		System.setProperty("typesafe.api.key", "TESTKEY");

		// ② 정상 : 요청 모양 + 결과 맵
		Map<String, Double> r = TypeSafeUtil.rerank("소변줄 오래 꽂으면 점수 깎이나요", cands(), 3000);
		JsonObject req = new Gson().fromJson(lastBody, JsonObject.class);
		boolean shape = "jev-latest".equals(req.get("model").getAsString())
			&& req.getAsJsonObject("state").get("question").getAsString().startsWith("소변줄")
			&& req.getAsJsonObject("state").getAsJsonArray("candidates").size() == 4
			&& req.getAsJsonObject("questions").size() == 4
			&& "noul".equals(req.getAsJsonObject("questions").getAsJsonObject("c0").get("type").getAsString())
			&& req.getAsJsonObject("questions").getAsJsonObject("c1").get("instructions").getAsString().contains("`candidates[1]`")
			&& req.getAsJsonObject("questions").getAsJsonObject("c1").getAsJsonObject("criteria").has("true");
		if (shape) pass++; else { fail++; System.out.println("FAIL ② 요청 모양 : " + lastBody); }
		if (r != null && r.size() == 3 && r.get("300") == 0.9 && r.get("200") == 0.6 && r.get("100") == 0.1 && !r.containsKey("400")) pass++;
		else { fail++; System.out.println("FAIL ② 결과 맵 : " + r); }

		// ③ 서비스 재순위(리플렉션) : 목록 6건, topN 기본 10 → 4건 후보(=목록 앞 4) … 목록이 6이면 6건 후보가 된다 — topN 을 4 로
		System.setProperty("typesafe.qna.topn", "4");
		Object svc = Class.forName("egovframework.wnn_medcost.mangr.service.impl.MangrServiceImpl").getDeclaredConstructor().newInstance();
		Method m = svc.getClass().getDeclaredMethod("rerankByTypeSafe", String.class, List.class);
		m.setAccessible(true);
		List<Map<String,Object>> list = list6();
		Object top = m.invoke(svc, "홍길동 환자 소변줄 오래 꽂으면 점수 깎이나요", list);
		String order = ids(list);
		// 기대 : 후보 4건(100·200·300·400) → 300(0.9) 200(0.6) 100(0.1) 400(답 없음) , 뒤 500·600 그대로
		if ("300,200,100,400,500,600".equals(order)) pass++; else { fail++; System.out.println("FAIL ③ 순서 : " + order); }
		if (top instanceof Double && (Double) top == 0.9) pass++; else { fail++; System.out.println("FAIL ③ top : " + top); }
		boolean noExcerpt = true; for (Map<String,Object> x : list) if (x.containsKey("excerpt")) noExcerpt = false;
		if (noExcerpt) pass++; else { fail++; System.out.println("FAIL ③ excerpt 잔존"); }
		if (list.get(0).get("ai").equals(0.9) && !list.get(3).containsKey("ai") && !list.get(4).containsKey("ai")) pass++;
		else { fail++; System.out.println("FAIL ③ ai 표식 : " + list); }
		// 마스킹 : 질문의 '홍길동 환자' 가 [환자] 로 나갔는가
		String sentQ = new Gson().fromJson(lastBody, JsonObject.class).getAsJsonObject("state").get("question").getAsString();
		if (!sentQ.contains("홍길동") && sentQ.contains("[환자]")) pass++; else { fail++; System.out.println("FAIL ③ 마스킹 : " + sentQ); }

		// ④ HTTP 500 → null, 목록 원래 순서 유지 + excerpt 는 제거
		mode = 1;
		List<Map<String,Object>> l2 = list6();
		Object t2 = m.invoke(svc, "q", l2);
		if (t2 == null && "100,200,300,400,500,600".equals(ids(l2)) && !l2.get(0).containsKey("excerpt") && !l2.get(0).containsKey("ai")) pass++;
		else { fail++; System.out.println("FAIL ④ 500 폴백 : " + t2 + " " + ids(l2)); }

		// ⑤ answers 없음 → null
		mode = 2;
		if (TypeSafeUtil.rerank("q", cands(), 3000) == null) pass++; else { fail++; System.out.println("FAIL ⑤"); }

		mode = 0;   // ⑤ 가 남긴 「answers 없음」 모드를 되돌린다
		// ⑦ choice — 선택지 4개+NONE, 확률 내림차순·choice·confidence, 마스킹된 state
		{
			java.util.LinkedHashMap<String,String> opts = new java.util.LinkedHashMap<>();
			opts.put("PTSAFE","환자안전사고 보고서"); opts.put("EDURPT","직원 교육 결과 보고서"); opts.put("FIRE","화재 안전 점검"); opts.put("NONE","해당 없음");
			JsonObject st = new JsonObject(); st.addProperty("text", TypeSafeUtil.maskPrivacy("홍길동 환자 010-1234-5678 침대에서 떨어짐"));
			TypeSafeUtil.ChoiceResult cr = TypeSafeUtil.choice(st, "가장 알맞은 서식을 고른다", opts, 3000);
			JsonObject sent = new Gson().fromJson(lastBody, JsonObject.class);
			String sentText = sent.getAsJsonObject("state").get("text").getAsString();
			boolean okShape = "choice".equals(sent.getAsJsonObject("questions").getAsJsonObject("pick").get("type").getAsString())
				&& sent.getAsJsonObject("questions").getAsJsonObject("pick").getAsJsonObject("criteria").size() == 4;
			if (okShape && !sentText.contains("홍길동") && sentText.contains("[환자]") && sentText.contains("[전화번호]")) pass++; else { fail++; System.out.println("FAIL ⑦ 요청/마스킹 : " + sentText); }
			java.util.Iterator<String> it = (cr == null) ? null : cr.probabilities.keySet().iterator();
			if (cr != null && "PTSAFE".equals(cr.choice) && cr.confidence == 0.66 && cr.probabilities.size() == 4 && "PTSAFE".equals(it.next()) && cr.probabilities.get("NONE") == 0.05) pass++;
			else { fail++; System.out.println("FAIL ⑦ 결과 : " + (cr == null ? null : cr.choice + " " + cr.probabilities)); }
			if (TypeSafeUtil.choice(st, "x", new java.util.LinkedHashMap<String,String>(), 3000) == null) pass++; else { fail++; System.out.println("FAIL ⑦ 빈 선택지"); }
		}
		// ⑥ 연결 불가(방화벽 흉내) → null, 예외 없음
		System.setProperty("typesafe.api.url", "http://127.0.0.1:1/v1/systemone");
		mode = 0;
		if (TypeSafeUtil.rerank("q", cands(), 3000) == null) pass++; else { fail++; System.out.println("FAIL ⑥"); }

		sv.stop(0);
		System.out.println("PASS " + pass + " / FAIL " + fail);
		System.exit(fail == 0 ? 0 : 1);
	}

	static void send(HttpExchange ex, int code, String body) throws IOException {
		byte[] b = body.getBytes("UTF-8");
		ex.getResponseHeaders().add("Content-Type", "application/json");
		ex.sendResponseHeaders(code, b.length);
		try (OutputStream os = ex.getResponseBody()) { os.write(b); }
	}
	static List<TypeSafeUtil.Candidate> cands() {
		return Arrays.asList(
			new TypeSafeUtil.Candidate("100", "업로드가 너무 오래 걸립니다", "프로그램 사용법", "..."),
			new TypeSafeUtil.Candidate("200", "배뇨일지 작성 기준", "배뇨관리", "..."),
			new TypeSafeUtil.Candidate("300", "유치도뇨관 유지기간과 점수", "환자안전", "..."),
			new TypeSafeUtil.Candidate("400", "격리실 수가", "수가", "..."));
	}
	static List<Map<String,Object>> list6() {
		String[][] d = { {"100","업로드가 너무 오래 걸립니다"}, {"200","배뇨일지 작성 기준"}, {"300","유치도뇨관 유지기간과 점수"},
		                 {"400","격리실 수가"}, {"500","욕창 처치"}, {"600","경관영양"} };
		List<Map<String,Object>> l = new ArrayList<>();
		for (String[] x : d) { Map<String,Object> r = new HashMap<>(); r.put("kbId", Integer.parseInt(x[0])); r.put("title", x[1]); r.put("catNm", "분류"); r.put("excerpt", "본문…"); l.add(r); }
		return l;
	}
	static String ids(List<Map<String,Object>> l) { StringBuilder sb = new StringBuilder(); for (Map<String,Object> r : l) { if (sb.length() > 0) sb.append(','); sb.append(r.get("kbId")); } return sb.toString(); }
}
