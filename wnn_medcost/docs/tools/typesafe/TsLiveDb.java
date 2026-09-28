import java.lang.reflect.Method;
import java.sql.*;
import java.util.*;

/** 실제 운영 DB(TBL_QNA_KB, SELECT 만)의 후보로 TypeSafe 재순위를 돌려 본다.
 *  selectQnaSearch 와 같은 SQL 을 JDBC 로 다시 짜고(낱말은 MangrServiceImpl.splitWords 리플렉션),
 *  MangrServiceImpl.rerankByTypeSafe(리플렉션)로 순서를 바꿔 「전/후 1등 · 최고 확률 · 2등 확률」을 찍는다.
 *  판정 규칙 두 가지를 나란히 계산 : A = top>=0.5 / B = top>=0.5 강 · top<0.12 약 · 사이는 top>=2.5*second 면 강. */
public class TsLiveDb {
	static final String URL = "jdbc:mysql://114.108.153.178:3306/WNN?useSSL=false&serverTimezone=Asia/Seoul&characterEncoding=UTF-8";

	public static void main(String[] a) throws Exception {
		Object svc = Class.forName("egovframework.wnn_medcost.mangr.service.impl.MangrServiceImpl").getDeclaredConstructor().newInstance();
		Method mWords = svc.getClass().getDeclaredMethod("splitWords", String.class); mWords.setAccessible(true);
		Method mRank  = svc.getClass().getDeclaredMethod("rerankByTypeSafe", String.class, List.class); mRank.setAccessible(true);

		List<String> qs = new ArrayList<>(Arrays.asList(
			"소변줄 오래 꽂으면 점수 깎이나요",
			"침대에만 누워 있는 환자 욕창 관리 어떻게 하나요",
			"유치도뇨관 14일",
			"배뇨일지 며칠 써야 인정",
			"기저귀 차는 환자 배뇨훈련 인정받으려면",
			"직원 식당 메뉴가 어디 있나요",
			"월간보고서 승인은 누가 하나요",
			"장기입원 181일 계산 기준"));

		try (Connection cn = DriverManager.getConnection(URL, a[0], a[1])) {
			/* 최근 질문 로그에서 실제 질문 몇 개를 더 가져온다(중복·짧은 것 제외) */
			try (PreparedStatement ps = cn.prepareStatement(
				"SELECT Q_TEXT FROM TBL_QNA_LOG WHERE ASK_TYPE='TYPE' AND CHAR_LENGTH(Q_TEXT)>=6 GROUP BY Q_TEXT ORDER BY MAX(LOG_ID) DESC LIMIT 8")) {
				try (ResultSet rs = ps.executeQuery()) { while (rs.next()) { String q = rs.getString(1).trim(); if (!qs.contains(q)) qs.add(q); } }
			} catch (Exception e) { System.out.println("(로그 조회 생략 : " + e.getMessage() + ")"); }

			for (String q : qs) {
				@SuppressWarnings("unchecked") List<String> words = (List<String>) mWords.invoke(svc, q);
				List<Map<String,Object>> list = search(cn, q, words, 30);
				if (list.isEmpty()) { System.out.println("\nQ: " + q + "\n  SQL 0건"); continue; }
				String before = title(list.get(0));
				long t0 = System.currentTimeMillis();
				Object top = mRank.invoke(svc, q, list);
				long ms = System.currentTimeMillis() - t0;
				System.out.println("\nQ: " + q + "   낱말=" + words + "  SQL " + list.size() + "건  (" + ms + "ms)");
				System.out.println("  SQL 1등  : " + before);
				if (top == null) { System.out.println("  재순위 실패(null)"); continue; }
				double t = (Double) top;
				double second = 0;
				if (list.size() > 1 && list.get(1).get("ai") instanceof Number) second = ((Number) list.get(1).get("ai")).doubleValue();
				boolean ruleA = t >= 0.5;
				boolean ruleB = t >= 0.5 || (t >= 0.12 && t >= 2.5 * second);
				System.out.printf("  AI  1등  : %s   top=%.3f second=%.3f   A=%s B=%s%n", title(list.get(0)), t, second, ruleA ? "강" : "약", ruleB ? "강" : "약");
				for (int i = 0; i < Math.min(5, list.size()); i++) {
					Object ai = list.get(i).get("ai");
					System.out.printf("     %s  %s%n", (ai instanceof Number) ? String.format("%.3f", ((Number) ai).doubleValue()) : "  -  ", title(list.get(i)));
				}
			}
		}
	}

	static String title(Map<String,Object> r) { return "#" + r.get("kbId") + " [" + r.get("catNm") + "] " + r.get("title"); }

	/** selectQnaSearch 를 JDBC 로 — 매퍼와 같은 점수식·WHERE·ORDER (excerpt 포함) */
	static List<Map<String,Object>> search(Connection cn, String q, List<String> words, int limit) throws Exception {
		StringBuilder sb = new StringBuilder();
		sb.append("SELECT K.KB_ID kbId, K.TITLE title, C.CAT_NM catNm, K.SRC_TYPE srcType,")
		  .append(" LEFT(REGEXP_REPLACE(K.BODY,'<[^>]*>',' '),500) excerpt,")
		  .append(" ( MATCH(K.TITLE,K.KEYWORDS,K.BODY) AGAINST (? IN NATURAL LANGUAGE MODE)")
		  .append(" + CASE WHEN K.TITLE LIKE CONCAT('%',?,'%') THEN 14 ELSE 0 END")
		  .append(" + CASE WHEN K.KEYWORDS LIKE CONCAT('%',?,'%') THEN 6 ELSE 0 END")
		  .append(" + CASE WHEN K.BODY LIKE CONCAT('%',?,'%') THEN 3 ELSE 0 END");
		for (int i = 0; i < words.size(); i++)
			sb.append(" + CASE WHEN K.TITLE LIKE CONCAT('%',?,'%') THEN 10 ELSE 0 END + CASE WHEN K.KEYWORDS LIKE CONCAT('%',?,'%') THEN 5 ELSE 0 END");
		sb.append(" + (K.WEIGHT/2) + LEAST(K.HIT_CNT,20)/10 ) score")
		  .append(" FROM TBL_QNA_KB K LEFT JOIN TBL_QNA_CAT C ON C.CAT_ID=K.CAT_ID WHERE K.USE_YN='Y'")
		  .append(" AND ( MATCH(K.TITLE,K.KEYWORDS,K.BODY) AGAINST (? IN NATURAL LANGUAGE MODE)")
		  .append(" OR K.TITLE LIKE CONCAT('%',?,'%') OR K.KEYWORDS LIKE CONCAT('%',?,'%') OR K.BODY LIKE CONCAT('%',?,'%') )")
		  .append(" ORDER BY score DESC, K.WEIGHT DESC, K.HIT_CNT DESC LIMIT ").append(limit);
		List<Map<String,Object>> out = new ArrayList<>();
		try (PreparedStatement ps = cn.prepareStatement(sb.toString())) {
			int p = 1;
			for (int i = 0; i < 4; i++) ps.setString(p++, q);
			for (String w : words) { ps.setString(p++, w); ps.setString(p++, w); }
			for (int i = 0; i < 4; i++) ps.setString(p++, q);
			try (ResultSet rs = ps.executeQuery()) {
				while (rs.next()) {
					Map<String,Object> r = new HashMap<>();
					r.put("kbId", rs.getObject("kbId")); r.put("title", rs.getString("title")); r.put("catNm", rs.getString("catNm"));
					r.put("srcType", rs.getString("srcType")); r.put("excerpt", rs.getString("excerpt"));
					out.add(r);
				}
			}
		}
		return out;
	}
}
