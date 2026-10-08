package egovframework.util;

import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.Properties;

/**
 * 문자(SMS/LMS) 발송 — 알리고(apis.aligo.in) HTTP API (2026-10-08, MIS 업무 알림 문자용).
 *
 * 설정은 MailUtil 과 같은 파일(mail.properties / -Dwnn.mail.config)에서 읽는다 :
 *   sms.enabled=true · sms.provider=aligo · sms.key=API키 · sms.userId=알리고 아이디 · sms.sender=등록된 발신번호 · sms.testmode=Y|N
 * 설정이 비어 있으면 isReady()=false — 부르는 쪽은 보내지 않고 「설정 없음」으로 건너뛴다(메일은 그대로 나간다).
 * ★한글 길이 : 알리고는 EUC-KR 기준 90바이트까지 SMS, 그 위는 LMS(2,000바이트) — 글 길이를 재서 msg_type 을 고른다.
 * ★운영 서버는 아웃바운드 HTTPS 가 막혀 있다(2026-08-07·09-28 확인) — 문자를 쓰려면 apis.aligo.in 443 아웃바운드를 먼저 열어야 한다.
 */
public final class SmsUtil {

	private SmsUtil() { }

	private static String s(Properties p, String k, String def) {
		String v = p.getProperty(k);
		return (v == null || v.trim().length() == 0) ? def : v.trim();
	}

	public static boolean isReady() {
		Properties p = MailUtil.config();
		return "true".equalsIgnoreCase(s(p, "sms.enabled", "false"))
			&& s(p, "sms.key", "").length() > 0 && s(p, "sms.userId", "").length() > 0 && s(p, "sms.sender", "").length() > 0;
	}

	public static String notReadyReason() {
		Properties p = MailUtil.config();
		if (!"true".equalsIgnoreCase(s(p, "sms.enabled", "false"))) return "문자 발송이 꺼져 있습니다(sms.enabled=false). 문자 업체(알리고) 계정을 받아 설정하면 켜집니다.";
		java.util.List<String> miss = new java.util.ArrayList<>();
		if (s(p, "sms.key", "").isEmpty()) miss.add("sms.key");
		if (s(p, "sms.userId", "").isEmpty()) miss.add("sms.userId");
		if (s(p, "sms.sender", "").isEmpty()) miss.add("sms.sender");
		return miss.isEmpty() ? "" : "문자 설정이 비어 있습니다: " + String.join(", ", miss);
	}

	/** EUC-KR 바이트 수(알리고 길이 기준) */
	public static int bytesKr(String msg) {
		try { return msg == null ? 0 : msg.getBytes("EUC-KR").length; } catch (Exception e) { return msg == null ? 0 : msg.length() * 2; }
	}

	/**
	 * 문자 1건 발송. 성공하면 업체 메시지 ID, 실패면 예외(메시지에 업체 응답).
	 * @param to    받는 번호(숫자만 남겨 보낸다)
	 * @param msg   본문
	 * @param title LMS 제목(SMS 길이면 무시)
	 */
	public static String send(String to, String msg, String title) throws Exception {
		Properties c = MailUtil.config();
		if (!isReady()) throw new IllegalStateException(notReadyReason());
		String provider = s(c, "sms.provider", "aligo");
		if (!"aligo".equalsIgnoreCase(provider)) throw new IllegalStateException("지원하지 않는 문자 업체: " + provider);
		String receiver = to == null ? "" : to.replaceAll("[^0-9]", "");
		if (receiver.length() < 9) throw new IllegalArgumentException("받는 번호가 올바르지 않습니다: " + to);
		boolean lms = bytesKr(msg) > 90;

		StringBuilder form = new StringBuilder();
		form.append("key=").append(enc(s(c, "sms.key", "")));
		form.append("&user_id=").append(enc(s(c, "sms.userId", "")));
		form.append("&sender=").append(enc(s(c, "sms.sender", "").replaceAll("[^0-9]", "")));
		form.append("&receiver=").append(enc(receiver));
		form.append("&msg=").append(enc(msg));
		form.append("&msg_type=").append(lms ? "LMS" : "SMS");
		if (lms) form.append("&title=").append(enc(title == null || title.isEmpty() ? "WinCheck+ 업무 알림" : title));
		if ("Y".equalsIgnoreCase(s(c, "sms.testmode", "N"))) form.append("&testmode_yn=Y");

		String api = s(c, "sms.apiUrl", "https://apis.aligo.in/send/");
		HttpURLConnection con = (HttpURLConnection) new URL(api).openConnection();
		con.setRequestMethod("POST");
		con.setConnectTimeout(8000); con.setReadTimeout(15000);
		con.setDoOutput(true);
		con.setRequestProperty("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8");
		byte[] body = form.toString().getBytes(StandardCharsets.UTF_8);
		try (OutputStream os = con.getOutputStream()) { os.write(body); }
		int code = con.getResponseCode();
		String resp;
		try (java.io.InputStream in = code >= 400 ? con.getErrorStream() : con.getInputStream()) {
			resp = in == null ? "" : new String(readAll(in), StandardCharsets.UTF_8);
		}
		if (code >= 400) throw new Exception("문자 업체 응답 HTTP " + code + " : " + cut(resp, 200));
		// 알리고 응답 : {"result_code":"1","message":"success","msg_id":"...","success_cnt":1,...} — 1 이 아니면 실패
		String rc = pick(resp, "result_code");
		if (!"1".equals(rc)) throw new Exception("문자 발송 실패(" + rc + "): " + pick(resp, "message"));
		return pick(resp, "msg_id");
	}

	private static String enc(String v) throws Exception { return URLEncoder.encode(v == null ? "" : v, "UTF-8"); }
	private static String cut(String s, int n) { return s == null ? "" : (s.length() > n ? s.substring(0, n) : s); }
	private static byte[] readAll(java.io.InputStream in) throws Exception {
		java.io.ByteArrayOutputStream bo = new java.io.ByteArrayOutputStream(); byte[] b = new byte[4096]; int n;
		while ((n = in.read(b)) > 0) bo.write(b, 0, n);
		return bo.toByteArray();
	}
	/** 아주 작은 JSON 값 꺼내기 — "key":"value" 또는 "key":123 (라이브러리 없이) */
	private static String pick(String json, String key) {
		if (json == null) return "";
		java.util.regex.Matcher m = java.util.regex.Pattern.compile("\"" + key + "\"\\s*:\\s*\"?([^\",}]*)").matcher(json);
		return m.find() ? m.group(1).trim() : "";
	}
}
