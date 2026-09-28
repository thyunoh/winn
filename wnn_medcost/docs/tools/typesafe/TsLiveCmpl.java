import java.lang.reflect.*;
import java.sql.*;
import java.util.*;

/** 실제 QpsServiceImpl.suggestCmpl 를 톰캣 없이 태운다 — 매퍼 Proxy(selectQpsCodes 만 운영 DB SELECT). 불만 글 10줄 → 유형·민원인 구분. */
public class TsLiveCmpl {
	static final String URL = "jdbc:mysql://114.108.153.178:3306/WNN?useSSL=false&serverTimezone=Asia/Seoul&characterEncoding=UTF-8";
	public static void main(String[] a) throws Exception {
		Class.forName("com.mysql.cj.jdbc.Driver");
		final List<Map<String,Object>> codes = new ArrayList<>();
		try (Connection cn = DriverManager.getConnection(URL, a[0], a[1]);
		     ResultSet rs = cn.createStatement().executeQuery(
		       "SELECT CODE_CD codecd, SUB_CODE subcode, RTRIM(SUB_CODE_NM) subcodenm, IFNULL(SORT,99) sort FROM TBL_CODE_DTL WHERE CODE_GB='Q' AND CODE_CD IN ('QPS_CMPL_TYPE','QPS_CMPL_PERSON') AND USE_YN='Y' AND ACTION_YN='Y' ORDER BY CODE_CD, IFNULL(SORT,99)")) {
			while (rs.next()) { Map<String,Object> r = new HashMap<>(); r.put("codecd", rs.getString(1)); r.put("subcode", rs.getString(2)); r.put("subcodenm", rs.getString(3)); r.put("sort", rs.getInt(4)); codes.add(r); }
		}
		Class<?> mapperIf = Class.forName("egovframework.wnn_medcost.qps.mapper.QpsMapper");
		Object mapper = Proxy.newProxyInstance(mapperIf.getClassLoader(), new Class<?>[]{ mapperIf }, (p, m, args) -> {
			if ("selectQpsCodes".equals(m.getName())) return codes; throw new UnsupportedOperationException(m.getName()); });
		Object svc = Class.forName("egovframework.wnn_medcost.qps.service.impl.QpsServiceImpl").getDeclaredConstructor().newInstance();
		Field f = svc.getClass().getDeclaredField("mapper"); f.setAccessible(true); f.set(svc, mapper);
		Method sug = svc.getClass().getMethod("suggestCmpl", String.class);

		String[] texts = {
			"병실이 너무 춥고 화장실 청소가 안 되어 있다고 보호자가 항의",
			"밥이 늘 식어서 나오고 반찬이 짜다는 환자 말씀",
			"간호사가 호출벨을 눌러도 늦게 오고 말투가 차갑다",
			"아들이 면회 시간 안내가 제대로 안 됐다고 원무과에 불만",
			"간병인이 환자 자세를 안 바꿔 줘 등이 아프다",
			"주사 맞은 자리가 부어올랐는데 설명이 없었다",
			"주차장이 좁아 방문객 차를 댈 곳이 없다",
			"환자 옷이 세탁 후 사라졐다",
			"고맙다는 인사 전화",
			"김철수 환자 010-2222-3333 보호자가 TV 소리가 크다고 함"
		};
		for (String t : texts) {
			long t0 = System.currentTimeMillis();
			@SuppressWarnings("unchecked") Map<String,Object> r = (Map<String,Object>) sug.invoke(svc, t);
			System.out.println("\n▶ " + t + "   (" + (System.currentTimeMillis() - t0) + "ms)");
			if (!Boolean.TRUE.equals(r.get("ok"))) { System.out.println("   ok=false : " + r.get("reason")); continue; }
			@SuppressWarnings("unchecked") Map<String,Object> ty = (Map<String,Object>) r.get("type");
			@SuppressWarnings("unchecked") Map<String,Object> pe = (Map<String,Object>) r.get("person");
			System.out.printf("   유형   : %s(%s) p=%s second=%s NONE=%s choice=%s%n", ty.get("nm"), ty.get("code"), ty.get("p"), ty.get("second"), ty.get("none"), ty.get("choice"));
			System.out.printf("   민원인 : %s(%s) p=%s second=%s NONE=%s choice=%s%n", pe.get("nm"), pe.get("code"), pe.get("p"), pe.get("second"), pe.get("none"), pe.get("choice"));
		}
	}
}
