import java.util.*;
import egovframework.util.TypeSafeUtil;

/** 실제 TypeSafe API 로 한국어 판정 품질을 본다 — 환경변수 TYPESAFE_API_KEY 필요.
 *  후보는 TBL_QNA_KB 의 실제 제목을 흉내 낸 6건. 질문마다 noul 을 찍어 「맞는 항목이 가장 높은가 · 답 없는 질문은 전부 낮은가」를 본다. */
public class TsLive {
	public static void main(String[] a) {
		if (!TypeSafeUtil.isReady()) { System.out.println("TYPESAFE_API_KEY 가 없습니다"); System.exit(1); }
		List<TypeSafeUtil.Candidate> c = Arrays.asList(
			new TypeSafeUtil.Candidate("1", "업로드가 너무 오래 걸립니다", "프로그램 사용법", "청구 샘파일 업로드는 파일 크기에 따라 수 분이 걸릴 수 있습니다. 진행바가 100% 후에도 서버 처리가 이어집니다."),
			new TypeSafeUtil.Candidate("2", "유치도뇨관이 있는 환자분율 — 지표 정의와 산출", "지표 정의", "평가 대상 환자 중 유치도뇨관을 가진 환자의 비율. 분모는 평가대상 환자, 분자는 유치도뇨관 삽입 환자. 값이 낮을수록 우수."),
			new TypeSafeUtil.Candidate("3", "배뇨일지는 며칠 이상 작성해야 하나요", "배뇨관리", "배뇨훈련 프로그램 인정을 위해 배뇨일지는 3일 이상 작성되어야 하며 일정한 배뇨 또는 방광훈련 체크가 있어야 합니다."),
			new TypeSafeUtil.Candidate("4", "격리실 입원료 산정 기준", "수가 산정지침", "격리실 입원료는 법정 감염병 등 격리가 필요한 환자에게 산정하며 1인실 요건과 격리 사유 기록이 필요합니다."),
			new TypeSafeUtil.Candidate("5", "장기입원(181일 이상) 환자분율", "지표 정의", "입원 181일 이상 환자의 비율. 의료최고도·고도 환자는 분모·분자에서 제외."),
			new TypeSafeUtil.Candidate("6", "욕창 처치 기록 방법", "환자안전", "욕창 단계별 처치 내용과 드레싱 교환 주기를 간호기록에 남깁니다.")
		);
		String[] qs = {
			"소변줄 오래 꽂으면 점수 깎이나요",          // 기대 : 2 가 최고
			"기저귀 차는 환자 배뇨훈련 인정받으려면",     // 기대 : 3 이 최고
			"6개월 넘게 입원한 환자는 어떻게 되나요",     // 기대 : 5 가 최고
			"직원 식당 메뉴가 어디 있나요",                // 기대 : 전부 낮음(자료 없음)
			"청구 파일 올리는데 왜 이렇게 느려요"          // 기대 : 1 이 최고
		};
		for (String q : qs) {
			long t0 = System.currentTimeMillis();
			Map<String, Double> r = TypeSafeUtil.rerank(q, c, 15000);
			long ms = System.currentTimeMillis() - t0;
			System.out.println("\nQ: " + q + "   (" + ms + "ms)");
			if (r == null) { System.out.println("  → null (호출 실패 — 로그 참조)"); continue; }
			List<Map.Entry<String, Double>> l = new ArrayList<>(r.entrySet());
			l.sort((x, y) -> Double.compare(y.getValue(), x.getValue()));
			for (Map.Entry<String, Double> e : l) {
				String title = "";
				for (TypeSafeUtil.Candidate cc : c) if (cc.id.equals(e.getKey())) title = cc.title;
				System.out.printf("  %5.3f  #%s %s%n", e.getValue(), e.getKey(), title);
			}
		}
	}
}
