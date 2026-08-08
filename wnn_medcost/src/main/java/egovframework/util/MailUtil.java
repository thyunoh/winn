package egovframework.util;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;

import javax.activation.DataHandler;
import javax.activation.FileDataSource;
import javax.mail.Address;
import javax.mail.Message;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;

/**
 * SMTP 메일 발송 (월보고서 PDF 첨부 발송용).
 *
 * 설정은 mail.properties 에서 읽는다. 톰캣 실행 옵션에 -Dwnn.mail.config=경로 를 주면
 * 그 파일이 우선이라, 계정·비밀번호를 소스(WAR)에 두지 않고 서버 파일로 뺄 수 있다.
 *
 * 네이버(465/SSL)·구글(587/STARTTLS) 둘 다 이 코드로 보낸다 — 차이는 설정값(port·ssl)뿐이다.
 */
public class MailUtil {

	private MailUtil() { }

	/** 설정 로드 — 서버 파일(-Dwnn.mail.config) 우선, 없으면 클래스패스 mail.properties.
	 *  ★반드시 UTF-8 Reader 로 읽는다(2026-07-30) — Properties.load(InputStream) 는 ISO-8859-1 고정이라
	 *    mail.fromName 의 한글('적정성평가')이 깨져 보낸사람 이름이 'ì...' 로 나갔다(실제 발생). */
	public static Properties config() {
		Properties p = new Properties();
		String ext = System.getProperty("wnn.mail.config");
		if (ext != null && ext.trim().length() > 0) {
			File f = new File(ext.trim());
			if (f.isFile()) {
				try (java.io.Reader in = new java.io.InputStreamReader(new FileInputStream(f), java.nio.charset.StandardCharsets.UTF_8)) { p.load(in); return p; }
				catch (Exception ignore) { /* 못 읽으면 클래스패스로 폴백 */ }
			}
		}
		try (InputStream in = MailUtil.class.getClassLoader().getResourceAsStream("mail.properties")) {
			if (in != null) p.load(new java.io.InputStreamReader(in, java.nio.charset.StandardCharsets.UTF_8));
		} catch (Exception ignore) { }
		return p;
	}

	private static String s(Properties p, String k, String def) {
		String v = p.getProperty(k);
		return (v == null || v.trim().length() == 0) ? def : v.trim();
	}

	/** 발송 가능 상태인지 — enabled + 필수값(host/user/from) 이 채워져 있는지 */
	public static boolean isReady() {
		Properties p = config();
		return "true".equalsIgnoreCase(s(p, "mail.enabled", "false"))
			&& s(p, "mail.smtp.host", "").length() > 0
			&& s(p, "mail.smtp.user", "").length() > 0
			&& s(p, "mail.from", "").length() > 0;
	}

	/** 설정이 왜 미완인지 사람이 읽을 안내 (화면 메시지용) */
	public static String notReadyReason() {
		Properties p = config();
		if (!"true".equalsIgnoreCase(s(p, "mail.enabled", "false"))) return "메일 발송이 꺼져 있습니다(mail.enabled=false).";
		List<String> miss = new ArrayList<>();
		if (s(p, "mail.smtp.host", "").length() == 0)  miss.add("mail.smtp.host");
		if (s(p, "mail.smtp.user", "").length() == 0)  miss.add("mail.smtp.user");
		if (s(p, "mail.from", "").length() == 0)       miss.add("mail.from");
		if (miss.isEmpty()) return "";
		return "메일 설정이 비어 있습니다: " + String.join(", ", miss);
	}

	/** "a@b.com, c@d.com" → InternetAddress[] (빈 값·공백 제거) */
	public static InternetAddress[] parseAddresses(String csv) throws Exception {
		List<Address> list = new ArrayList<>();
		if (csv != null) {
			for (String one : csv.split("[,;]")) {
				String t = one.trim();
				if (t.length() > 0) list.add(new InternetAddress(t, false));   // false = 형식만 확인
			}
		}
		return list.toArray(new InternetAddress[0]);
	}

	/**
	 * 메일 발송.
	 *
	 * @param toCsv      수신자(콤마/세미콜론 구분)
	 * @param subject    제목
	 * @param htmlBody   본문(HTML)
	 * @param attachFile 첨부 파일 (없으면 null)
	 * @param attachName 첨부 파일명 (없으면 실제 파일명 사용)
	 */
	public static void send(String toCsv, String subject, String htmlBody,
	                        File attachFile, String attachName) throws Exception {

		Properties c = config();
		String host = s(c, "mail.smtp.host", "");
		String port = s(c, "mail.smtp.port", "465");
		boolean ssl = "true".equalsIgnoreCase(s(c, "mail.smtp.ssl", "true"));
		final String user = s(c, "mail.smtp.user", "");
		final String pass = s(c, "mail.smtp.password", "");
		String from     = s(c, "mail.from", "");
		String fromName = s(c, "mail.fromName", "WinCheck+");
		String timeout  = s(c, "mail.smtp.timeout", "15000");
		// ★TLS 버전을 반드시 명시한다(2026-08-07) — 없으면 발송이 통째로 실패한다.
		//   javax.mail 1.5.0(2013) 은 SSL 소켓에 켤 프로토콜을 구버전(SSLv3/TLSv1) 위주로 지정하는데,
		//   Java 11 은 java.security 의 jdk.tls.disabledAlgorithms 로 그것들을 막아 둔다.
		//   → 쓸 수 있는 프로토콜이 하나도 안 남아 핸드셰이크 시작 전에 죽고,
		//     JavaMail 이 그걸 "Could not connect to SMTP host" 로 감싸 버려 원인이 안 보인다
		//     (실제 원인은 SSLHandshakeException: No appropriate protocol).
		//   ※ 서버에서 openssl s_client 로는 붙는데 앱만 안 붙으면 십중팔구 이것이다.
		//   TLSv1.3 을 쓰려면 mail.properties 에 mail.smtp.ssl.protocols=TLSv1.2 TLSv1.3 으로 덮어쓴다.
		String sslProt  = s(c, "mail.smtp.ssl.protocols", "TLSv1.2");

		InternetAddress[] to = parseAddresses(toCsv);
		if (to.length == 0) throw new IllegalArgumentException("수신자 주소가 없습니다.");

		Properties p = new Properties();
		p.put("mail.smtp.host", host);
		p.put("mail.smtp.port", port);
		p.put("mail.smtp.auth", "true");
		p.put("mail.smtp.connectiontimeout", timeout);
		p.put("mail.smtp.timeout", timeout);
		p.put("mail.smtp.writetimeout", timeout);
		p.put("mail.smtp.ssl.protocols", sslProt);   // 465·587 양쪽 다 필요 (위 주석 참고)
		if (ssl) {                                   // 465 — 처음부터 SSL
			p.put("mail.smtp.ssl.enable", "true");
			p.put("mail.smtp.socketFactory.port", port);
			p.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
			p.put("mail.smtp.socketFactory.fallback", "false");
		} else {                                     // 587 — 평문 연결 후 STARTTLS 승격
			p.put("mail.smtp.starttls.enable", "true");
			p.put("mail.smtp.starttls.required", "true");
		}

		Session session = Session.getInstance(p, new javax.mail.Authenticator() {
			@Override protected javax.mail.PasswordAuthentication getPasswordAuthentication() {
				return new javax.mail.PasswordAuthentication(user, pass);
			}
		});

		MimeMessage msg = new MimeMessage(session);
		msg.setFrom(new InternetAddress(from, fromName, "UTF-8"));
		msg.setRecipients(Message.RecipientType.TO, to);
		msg.setSubject(subject == null ? "" : subject, "UTF-8");
		msg.setSentDate(new java.util.Date());

		MimeBodyPart bodyPart = new MimeBodyPart();
		bodyPart.setContent(htmlBody == null ? "" : htmlBody, "text/html; charset=UTF-8");

		MimeMultipart mp = new MimeMultipart();
		mp.addBodyPart(bodyPart);

		if (attachFile != null && attachFile.isFile()) {
			MimeBodyPart att = new MimeBodyPart();
			att.setDataHandler(new DataHandler(new FileDataSource(attachFile)));
			String nm = (attachName == null || attachName.trim().length() == 0) ? attachFile.getName() : attachName.trim();
			// 한글 파일명 깨짐 방지 (RFC 2047)
			att.setFileName(javax.mail.internet.MimeUtility.encodeText(nm, "UTF-8", "B"));
			mp.addBodyPart(att);
		}

		msg.setContent(mp);
		Transport.send(msg);
	}
}
