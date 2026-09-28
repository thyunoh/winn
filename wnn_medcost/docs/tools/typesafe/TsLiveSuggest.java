import java.lang.reflect.*;
import java.sql.*;
import java.util.*;

/** 실제 QpsServiceImpl.suggestRptGb 를 톰캣 없이 태운다 — 매퍼는 Proxy 로 흉내 내고(selectQpsCodes 만 운영 DB 에서 SELECT),
 *  자유 글 몇 줄을 넣어 상위 3 추천·NONE·confidence 를 찍는다. 기대 유형은 사람이 본다. */
public class TsLiveSuggest {
	static final String URL = "jdbc:mysql://114.108.153.178:3306/WNN?useSSL=false&serverTimezone=Asia/Seoul&characterEncoding=UTF-8";
	public static void main(String[] a) throws Exception {
		Class.forName("com.mysql.cj.jdbc.Driver");
		final List<Map<String,Object>> codes = new ArrayList<>();
		try (Connection cn = DriverManager.getConnection(URL, a[0], a[1]);
		     ResultSet rs = cn.createStatement().executeQuery(
		       "SELECT CODE_CD codecd, SUB_CODE subcode, RTRIM(SUB_CODE_NM) subcodenm, IFNULL(SORT,99) sort FROM TBL_CODE_DTL WHERE CODE_GB='Q' AND CODE_CD='QPS_SAFERPT_GB' AND USE_YN='Y' AND ACTION_YN='Y' ORDER BY IFNULL(SORT,99), SUB_CODE")) {
			while (rs.next()) { Map<String,Object> r = new HashMap<>(); r.put("codecd", rs.getString(1)); r.put("subcode", rs.getString(2)); r.put("subcodenm", rs.getString(3)); r.put("sort", rs.getInt(4)); codes.add(r); }
		}
		System.out.println("유형 " + codes.size() + "종");

		Class<?> mapperIf = Class.forName("egovframework.wnn_medcost.qps.mapper.QpsMapper");
		Object mapper = Proxy.newProxyInstance(mapperIf.getClassLoader(), new Class<?>[]{ mapperIf }, (p, m, args) -> {
			if ("selectQpsCodes".equals(m.getName())) return codes;
			throw new UnsupportedOperationException(m.getName());
		});
		Object svc = Class.forName("egovframework.wnn_medcost.qps.service.impl.QpsServiceImpl").getDeclaredConstructor().newInstance();
		Field f = svc.getClass().getDeclaredField("mapper"); f.setAccessible(true); f.set(svc, mapper);
		Method sug = svc.getClass().getMethod("suggestRptGb", String.class);

		String[] texts = {
			"밤에 환자가 침대에서 내려오다 넘어져 이마가 찢어졌다",
			"신입 간호사 대상으로 손위생 교육을 했다",
			"약을 잘못 준 것을 발견했다. 다른 환자 약이 투약됨",
			"수혈 후 환자에게 발열과 오한이 생겼다",
			"보호자가 간호사에게 욕설을 하고 밀쳤다",
			"MRSA 환자가 새로 입원해 격리했다",
			"환자 개인정보가 담긴 서류를 잘못 버렸다",
			"직원 건강검진 결과를 정리한다",
			"오늘 점심 뭐 먹을까",
			"홍길동 환자 010-1234-5678 화장실에서 미끄러짐"
		};
		for (String t : texts) {
			long t0 = System.currentTimeMillis();
			@SuppressWarnings("unchecked") Map<String,Object> r = (Map<String,Object>) sug.invoke(svc, t);
			System.out.println("\n▶ " + t + "   (" + (System.currentTimeMillis() - t0) + "ms)");
			if (!Boolean.TRUE.equals(r.get("ok"))) { System.out.println("   ok=false : " + r.get("reason")); continue; }
			System.out.println("   choice=" + r.get("choice") + " conf=" + r.get("confidence") + " NONE=" + r.get("none"));
			@SuppressWarnings("unchecked") List<Map<String,Object>> top = (List<Map<String,Object>>) r.get("top");
			for (Map<String,Object> o : top) System.out.printf("   %5.3f  %s [%s] sort=%s%n", ((Number) o.get("p")).doubleValue(), o.get("nm"), o.get("code"), o.get("sort"));
		}
	}
}
