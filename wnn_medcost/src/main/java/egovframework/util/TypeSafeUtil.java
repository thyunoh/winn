package egovframework.util;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.InetAddress;
import java.net.Socket;
import java.net.URL;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.SSLContext;
import javax.net.ssl.SSLSocket;
import javax.net.ssl.SSLSocketFactory;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;

/**
 * TypeSafe System One(Jev) 호출 — 글을 만들지 않고 <타입이 정해진 판정>(예/아니오 확률 등)만 받는다.
 *
 * 첫 사용처 = 적정성평가 Q&A 검색 재순위(2026-09-28) : SQL 이 뽑은 후보 몇 건을 한 번에 보내
 * 「이 항목이 질문에 답하는가」를 후보마다 확률(noul)로 받아 순위를 다시 매기고,
 * 최고 확률이 문턱 아래면 <자료에 없는 질문>으로 본다.
 *
 * ★설계 원칙
 *   · 키가 없거나 호출이 실패하면 null 을 돌려주고, 부르는 쪽은 종전 동작으로 조용히 폴백한다.
 *     (검색은 늘 나가야 한다 — 외부 서비스 장애가 화면 오류로 번지면 안 된다.)
 *   · 키는 환경변수 TYPESAFE_API_KEY 우선, 없으면 -Dtypesafe.api.key (Gemini 키와 같은 규칙).
 *     소스·설정파일에 평문으로 넣지 않는다. 운영은 톰캣 setenv.sh 에 export.
 *   · 환자 식별정보는 부르는 쪽이 먼저 지운다(MangrServiceImpl.maskPrivacy). 여기서는 받은 그대로 보낸다.
 *   · 운영 서버는 아웃바운드 HTTPS 가 막혀 있을 수 있다 — 연결 실패는 warn 한 줄로 끝내고 폴백.
 *
 * API : POST https://api.typesafe.ai/v1/systemone · Authorization: Bearer <키>
 *       본문 { state, model:"jev-latest", questions:{ id:{type,instructions,criteria} } }
 *       응답 { answers:{ id:{type:"noul", noul:0~1} | {type:"choice", choice, probabilities, confidence} } }
 */
public class TypeSafeUtil {

	private static final Logger LOGGER = LoggerFactory.getLogger(TypeSafeUtil.class);

	private TypeSafeUtil() { }

	/* ── 설정 ─────────────────────────────────────────────────────────── */

	private static String env(String envKey, String propKey, String def) {
		String v = System.getenv(envKey);
		if (v == null || v.trim().isEmpty()) v = System.getProperty(propKey);
		if (v == null || v.trim().isEmpty()) return def;
		return v.trim();
	}

	/** API 키 — 없으면 null (그러면 모든 호출이 null 을 돌려준다) */
	public static String apiKey() {
		String k = env("TYPESAFE_API_KEY", "typesafe.api.key", null);
		return (k == null || k.startsWith("YOUR_")) ? null : k;
	}
	public static boolean isReady() { return apiKey() != null; }

	public static String apiUrl() { return env("TYPESAFE_API_URL", "typesafe.api.url", "https://api.typesafe.ai/v1/systemone"); }
	public static String model()  { return env("TYPESAFE_MODEL",   "typesafe.model",   "jev-latest"); }

	/** 정수 설정(환경변수·-D) — 못 읽으면 기본값 */
	public static int intCfg(String envKey, String propKey, int def) {
		try { return Integer.parseInt(env(envKey, propKey, String.valueOf(def))); }
		catch (Exception e) { return def; }
	}
	/** 소수 설정(환경변수·-D) — 못 읽으면 기본값 */
	public static double dblCfg(String envKey, String propKey, double def) {
		try { return Double.parseDouble(env(envKey, propKey, String.valueOf(def))); }
		catch (Exception e) { return def; }
	}

	/* ── 낮은 수준 호출 ─────────────────────────────────────────────── */

	/**
	 * System One 한 번 호출. state 와 questions 를 그대로 싸서 보내고 answers 객체를 돌려준다.
	 * 키 없음·HTTP 오류·파싱 실패·타임아웃은 전부 null (warn 로그).
	 *
	 * @param state      판정할 자료(JsonObject/JsonArray/JsonPrimitive)
	 * @param questions  질문 id → {type, instructions, criteria}
	 * @param readTimeoutMs 읽기 제한(ms). 검색처럼 사용자가 기다리는 자리는 짧게.
	 */
	public static JsonObject systemOne(JsonElement state, JsonObject questions, int readTimeoutMs) {
		String key = apiKey();
		if (key == null) return null;
		if (questions == null || questions.size() == 0) return null;
		/* 한 번 실패하면 한 번만 더 — TLS 재접속 결함(아래 tlsFactory 주석)처럼 <접속 단계>에서 튀는 것은 두 번째에 대개 붙는다.
		   HTTP 4xx/5xx 응답은 재시도하지 않는다(같은 답이 온다). */
		JsonObject r = systemOneOnce(key, state, questions, readTimeoutMs);
		if (r == null && LAST_IO_FAIL) r = systemOneOnce(key, state, questions, readTimeoutMs);
		return r;
	}
	private static volatile boolean LAST_IO_FAIL = false;

	private static JsonObject systemOneOnce(String key, JsonElement state, JsonObject questions, int readTimeoutMs) {
		LAST_IO_FAIL = false;
		HttpURLConnection conn = null;
		try {
			Gson gson = new Gson();
			JsonObject body = new JsonObject();
			body.add("state", state);
			body.addProperty("model", model());
			body.add("questions", questions);

			URL url = new URL(apiUrl());
			conn = (HttpURLConnection) url.openConnection();
			if (conn instanceof HttpsURLConnection) {
				SSLSocketFactory f = tlsFactory();
				if (f != null) ((HttpsURLConnection) conn).setSSLSocketFactory(f);
			}
			conn.setRequestMethod("POST");
			conn.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
			conn.setRequestProperty("Authorization", "Bearer " + key);   /* 키는 헤더로 — URL 에 실으면 접속로그에 남는다 */
			conn.setDoOutput(true);
			conn.setConnectTimeout(5000);
			conn.setReadTimeout(readTimeoutMs <= 0 ? 15000 : readTimeoutMs);

			OutputStream os = conn.getOutputStream();
			try { os.write(gson.toJson(body).getBytes("UTF-8")); os.flush(); }
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
				LOGGER.warn("[TYPESAFE] HTTP {} : {}", code, abbreviate(sb.toString(), 400));
				return null;
			}
			JsonObject root = gson.fromJson(sb.toString(), JsonObject.class);
			if (root == null || !root.has("answers") || !root.get("answers").isJsonObject()) {
				LOGGER.warn("[TYPESAFE] answers 없음 : {}", abbreviate(sb.toString(), 400));
				return null;
			}
			if (root.has("usage") && LOGGER.isDebugEnabled())
				LOGGER.debug("[TYPESAFE] usage {}", root.get("usage"));
			return root.getAsJsonObject("answers");
		} catch (Exception e) {
			/* 방화벽·DNS·타임아웃·TLS 전부 여기로 — 폴백이 있으니 warn 한 줄로 끝낸다 */
			LAST_IO_FAIL = true;
			LOGGER.warn("[TYPESAFE] 호출 실패 (종전 동작으로 폴백) : {}", e.toString());
			return null;
		} finally {
			if (conn != null) try { conn.disconnect(); } catch (Exception ignore) { }
		}
	}

	/* ── TLS ─────────────────────────────────────────────────────────────
	   ★이 PC 의 JDK 11 첫 판(11+28, 2018)은 TLS 1.3 으로 api.typesafe.ai 에 <두 번째 새 접속>을 맺을 때
	     handshake_failure / record_overflow 를 낸다(2026-09-28 실측 : 기본 1/8 성공 · TLSv1.2 고정 8/8 성공).
	     JDK 11.0.3 이후엔 고쳐진 결함이지만 운영 서버 JDK 판을 못 믿으므로 <이 접속만> TLSv1.2 로 맺는다 —
	     -Djdk.tls.client.protocols 로 전역을 바꾸면 Gemini·메일 등 다른 접속까지 영향을 받는다.
	   TYPESAFE_TLS(-Dtypesafe.tls) 로 바꿀 수 있고, 빈 값이면 JDK 기본대로. */
	private static volatile SSLSocketFactory TLS_FACTORY;
	private static volatile boolean TLS_FACTORY_TRIED;

	private static SSLSocketFactory tlsFactory() {
		if (TLS_FACTORY_TRIED) return TLS_FACTORY;
		TLS_FACTORY_TRIED = true;
		String proto = env("TYPESAFE_TLS", "typesafe.tls", "TLSv1.2");
		if (proto.isEmpty() || "default".equalsIgnoreCase(proto)) return null;
		try {
			final String[] protos = proto.split("\\s*,\\s*");
			final SSLSocketFactory base = SSLContext.getDefault().getSocketFactory();
			TLS_FACTORY = new SSLSocketFactory() {
				private Socket fix(Socket s) { if (s instanceof SSLSocket) ((SSLSocket) s).setEnabledProtocols(protos); return s; }
				public String[] getDefaultCipherSuites()   { return base.getDefaultCipherSuites(); }
				public String[] getSupportedCipherSuites() { return base.getSupportedCipherSuites(); }
				public Socket createSocket(Socket s, String h, int p, boolean auto) throws IOException { return fix(base.createSocket(s, h, p, auto)); }
				public Socket createSocket(String h, int p) throws IOException { return fix(base.createSocket(h, p)); }
				public Socket createSocket(String h, int p, InetAddress lh, int lp) throws IOException { return fix(base.createSocket(h, p, lh, lp)); }
				public Socket createSocket(InetAddress h, int p) throws IOException { return fix(base.createSocket(h, p)); }
				public Socket createSocket(InetAddress h, int p, InetAddress lh, int lp) throws IOException { return fix(base.createSocket(h, p, lh, lp)); }
				public Socket createSocket() throws IOException { return fix(base.createSocket()); }
			};
		} catch (Exception e) {
			LOGGER.warn("[TYPESAFE] TLS 소켓 팩토리 준비 실패 (JDK 기본으로) : {}", e.toString());
			TLS_FACTORY = null;
		}
		return TLS_FACTORY;
	}

	/* ── 재순위 ───────────────────────────────────────────────────────── */

	/** 재순위 후보 한 건 — id 는 부르는 쪽이 답을 되찾는 열쇠(KB_ID 등) */
	public static class Candidate {
		public final String id, title, category, excerpt;
		public Candidate(String id, String title, String category, String excerpt) {
			this.id = id; this.title = title; this.category = category; this.excerpt = excerpt;
		}
	}

	/**
	 * 질문 하나 × 후보 여러 건 → 후보마다 「이 항목이 질문에 답하는가」 확률(0~1).
	 *
	 * 후보 전부를 <한 요청의 state> 에 담고 후보 수만큼 noul 질문을 낸다(질문은 병렬·독립 평가).
	 * TypeSafe 재순위 쿡북은 (질문,후보) 짝마다 요청을 따로 보내지만, 같은 state 위의 독립 질문은
	 * 한 요청에 묶는 것이 문서의 권장이고 왕복이 한 번이라 검색 응답 시간에 맞다.
	 *
	 * @return id → noul (요청 실패·키 없음이면 null). 답이 안 온 후보는 맵에 없다.
	 */
	public static Map<String, Double> rerank(String question, List<Candidate> cands, int readTimeoutMs) {
		if (question == null || question.trim().isEmpty() || cands == null || cands.isEmpty()) return null;
		if (!isReady()) return null;

		JsonObject state = new JsonObject();
		state.addProperty("question", question.trim());
		state.addProperty("domain", "한국 요양병원 적정성평가·수가 청구 실무 Q&A. 자료 = 심사평가원 교육자료·고시 질의응답·위너넷(WinCheck+) 확정 지식.");
		JsonArray arr = new JsonArray();
		JsonObject questions = new JsonObject();
		for (int i = 0; i < cands.size(); i++) {
			Candidate c = cands.get(i);
			JsonObject o = new JsonObject();
			o.addProperty("title",    nz(c.title));
			o.addProperty("category", nz(c.category));
			o.addProperty("excerpt",  nz(c.excerpt));
			arr.add(o);

			JsonObject q = new JsonObject();
			q.addProperty("type", "noul");
			q.addProperty("instructions",
				"사용자 질문 `question` 에 대해 지식 항목 `candidates[" + i + "]`(제목·분류·본문 앞부분)가 "
			  + "실제로 답을 주는 자료인가? 질문과 같은 낱말이 들어 있다는 것만으로는 부족하고, "
			  + "질문이 알고 싶어 하는 규칙·기준·절차·수치를 그 항목이 다루어야 한다. "
			  + "현장 용어(소변줄·콧줄·기저귀 등)와 공식 용어(유치도뇨관·경관영양·배뇨관리)는 같은 뜻으로 본다.");
			JsonObject crit = new JsonObject();
			crit.addProperty("true",  "항목이 질문의 주제를 직접 다루며, 사용자가 이 항목을 열면 질문에 대한 답(기준·절차·수치·해석)을 얻는다.");
			crit.addProperty("false", "항목이 다른 주제이거나, 낱말만 겹치고 질문이 묻는 내용은 다루지 않거나, 너무 일반적이어서 이 질문의 답이 되지 못한다.");
			q.add("criteria", crit);
			questions.add("c" + i, q);
		}
		state.add("candidates", arr);

		JsonObject answers = systemOne(state, questions, readTimeoutMs);
		if (answers == null) return null;

		Map<String, Double> out = new LinkedHashMap<>();
		for (int i = 0; i < cands.size(); i++) {
			JsonElement a = answers.get("c" + i);
			if (a == null || !a.isJsonObject()) continue;
			JsonElement n = a.getAsJsonObject().get("noul");
			if (n == null || !n.isJsonPrimitive()) continue;
			try { out.put(cands.get(i).id, n.getAsDouble()); } catch (Exception ignore) { }
		}
		return out.isEmpty() ? null : out;
	}

	/* ── 선택(Choice) ─────────────────────────────────────────────────── */

	/** Choice 한 질문의 답 — 고른 option · 분포 · 확신(분포가 뾰족한 정도, 0~1) */
	public static class ChoiceResult {
		public final String choice;
		public final double confidence;
		public final Map<String, Double> probabilities;   /* option → 확률, 내림차순 */
		ChoiceResult(String c, double conf, Map<String, Double> p) { choice = c; confidence = conf; probabilities = p; }
	}

	/**
	 * 정해진 선택지 중 하나 고르기 — 첫 사용처 = 사고·보고서 유형 추천(2026-09-28).
	 *
	 * @param state        판정할 자료(질문·자유 글 등을 담은 JSON)
	 * @param instructions 무엇을 고르는지(한 문장, state 의 칸은 `백틱` 경로로 가리킨다)
	 * @param options      option 이름(코드) → 설명. **255개 상한**(API). 목록이 완전하지 않을 수 있으면 「해당 없음」 option 을 넣을 것.
	 * @return 실패·키 없음이면 null. probabilities 는 확률 내림차순으로 정렬돼 온다.
	 */
	public static ChoiceResult choice(JsonElement state, String instructions, Map<String, String> options, int readTimeoutMs) {
		Map<String, ChoiceSpec> qs = new LinkedHashMap<>();
		qs.put("pick", new ChoiceSpec(instructions, options));
		Map<String, ChoiceResult> r = choices(state, qs, readTimeoutMs);
		return (r == null) ? null : r.get("pick");
	}

	/** Choice 질문 하나의 정의 — 여러 개를 한 요청에 묶을 때 쓴다 */
	public static class ChoiceSpec {
		public final String instructions; public final Map<String, String> options;
		public ChoiceSpec(String i, Map<String, String> o) { instructions = i; options = o; }
	}

	/**
	 * 같은 state 위의 Choice 질문 여러 개를 **한 요청**에 — 질문은 병렬·독립 평가라 왕복이 한 번이다(문서 권장).
	 * 첫 사용처 = 불만고충 대장의 유형 + 민원인 구분 동시 추천(2026-09-28).
	 * @return 질문 id → 결과. 요청 실패·키 없음이면 null. 해석 못 한 질문은 맵에 없다.
	 */
	public static Map<String, ChoiceResult> choices(JsonElement state, Map<String, ChoiceSpec> specs, int readTimeoutMs) {
		if (specs == null || specs.isEmpty()) return null;
		if (!isReady()) return null;
		JsonObject questions = new JsonObject();
		for (Map.Entry<String, ChoiceSpec> s : specs.entrySet()) {
			ChoiceSpec sp = s.getValue();
			if (sp == null || sp.options == null || sp.options.isEmpty() || sp.options.size() > 255) return null;
			JsonObject q = new JsonObject();
			q.addProperty("type", "choice");
			q.addProperty("instructions", sp.instructions);
			JsonObject crit = new JsonObject();
			for (Map.Entry<String, String> e : sp.options.entrySet()) crit.addProperty(e.getKey(), nz(e.getValue()));
			q.add("criteria", crit);
			questions.add(s.getKey(), q);
		}
		JsonObject answers = systemOne(state, questions, readTimeoutMs);
		if (answers == null) return null;
		Map<String, ChoiceResult> out = new LinkedHashMap<>();
		for (String id : specs.keySet()) {
			JsonElement a = answers.get(id);
			if (a == null || !a.isJsonObject()) continue;
			ChoiceResult r = parseChoice(a.getAsJsonObject());
			if (r != null) out.put(id, r);
		}
		return out.isEmpty() ? null : out;
	}

	private static ChoiceResult parseChoice(JsonObject ao) {
		try {
			String choice = ao.has("choice") ? ao.get("choice").getAsString() : null;
			double conf = ao.has("confidence") ? ao.get("confidence").getAsDouble() : 0;
			List<Map.Entry<String, Double>> l = new java.util.ArrayList<>();
			if (ao.has("probabilities") && ao.get("probabilities").isJsonObject())
				for (Map.Entry<String, JsonElement> e : ao.getAsJsonObject("probabilities").entrySet())
					l.add(new java.util.AbstractMap.SimpleEntry<>(e.getKey(), e.getValue().getAsDouble()));
			java.util.Collections.sort(l, new java.util.Comparator<Map.Entry<String, Double>>() {
				public int compare(Map.Entry<String, Double> x, Map.Entry<String, Double> y) { return Double.compare(y.getValue(), x.getValue()); }
			});
			Map<String, Double> probs = new LinkedHashMap<>();
			for (Map.Entry<String, Double> e : l) probs.put(e.getKey(), e.getValue());
			if (choice == null && !probs.isEmpty()) choice = probs.keySet().iterator().next();
			return new ChoiceResult(choice, conf, probs);
		} catch (Exception e) {
			LOGGER.warn("[TYPESAFE] choice 응답 해석 실패 : {}", e.toString());
			return null;
		}
	}

	/* ── 개인정보 가림 ─────────────────────────────────────────────────── */

	/** 밖으로 나가는 글에서 환자 식별정보를 지운다 — 주민번호·전화번호·「홍길동 환자/님/씨」.
	 *  (2026-08-06 Q&A Gemini 호출용으로 만든 것을 2026-09-28 여기로 옮겨 TypeSafe 호출 전부가 같은 규칙을 쓴다.) */
	public static String maskPrivacy(String s) {
		if (s == null) return "";
		String out = s;
		out = out.replaceAll("\\d{6}\\s*[-–]\\s*\\d{7}", "[주민번호]");
		out = out.replaceAll("\\d{2,3}\\s*[-–]\\s*\\d{3,4}\\s*[-–]\\s*\\d{4}", "[전화번호]");
		out = out.replaceAll("[가-힣]{2,4}\\s*(환자|님|씨)(?=\\s|$|[,.])", "[환자]");
		return out;
	}

	/* ── 잡동사니 ─────────────────────────────────────────────────────── */

	private static String nz(String s) { return (s == null) ? "" : s; }

	private static String abbreviate(String s, int max) {
		if (s == null) return "";
		return (s.length() <= max) ? s : s.substring(0, max) + "…";
	}
}
