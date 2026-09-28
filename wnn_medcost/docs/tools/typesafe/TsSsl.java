import java.io.*;
import java.net.*;

/** record_overflow 원인 가르기 — 같은 요청을 빠르게 8번. A=기본(keep-alive) · B=Connection: close · C=기본 + TLSv1.2 강제 */
public class TsSsl {
	static final String BODY = "{\"state\":\"Help!\",\"model\":\"jev-latest\",\"questions\":{\"u\":{\"type\":\"noul\",\"instructions\":\"Is this urgent?\"}}}";
	public static void main(String[] a) throws Exception {
		String key = System.getenv("TYPESAFE_API_KEY");
		String mode = a.length > 0 ? a[0] : "A";
		if ("C".equals(mode)) System.setProperty("https.protocols", "TLSv1.2");
		if ("D".equals(mode) || "E".equals(mode)) System.setProperty("jdk.tls.client.protocols", "TLSv1.2");
		int ok = 0, fail = 0;
		StringBuilder log = new StringBuilder();
		for (int i = 0; i < 8; i++) {
			long t0 = System.currentTimeMillis();
			HttpURLConnection c = null;
			try {
				c = (HttpURLConnection) new URL("https://api.typesafe.ai/v1/systemone").openConnection();
				c.setRequestMethod("POST");
				c.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
				c.setRequestProperty("Authorization", "Bearer " + key);
				if ("B".equals(mode) || "E".equals(mode)) c.setRequestProperty("Connection", "close");
				c.setDoOutput(true); c.setConnectTimeout(5000); c.setReadTimeout(15000);
				try (OutputStream os = c.getOutputStream()) { os.write(BODY.getBytes("UTF-8")); }
				int code = c.getResponseCode();
				try (InputStream is = code < 300 ? c.getInputStream() : c.getErrorStream()) { if (is != null) is.readAllBytes(); }
				ok++; log.append(String.format("  #%d %d %dms%n", i + 1, code, System.currentTimeMillis() - t0));
			} catch (Exception e) {
				fail++; log.append(String.format("  #%d FAIL %s %dms%n", i + 1, e.toString(), System.currentTimeMillis() - t0));
			} finally { if (c != null) c.disconnect(); }
		}
		System.out.println("mode " + mode + " : ok " + ok + " / fail " + fail + "\n" + log);
	}
}
