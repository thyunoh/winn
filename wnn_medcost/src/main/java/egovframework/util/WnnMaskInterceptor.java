package egovframework.util;

import java.util.Map;
import java.util.Properties;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.ibatis.executor.Executor;
import org.apache.ibatis.mapping.MappedStatement;
import org.apache.ibatis.plugin.Interceptor;
import org.apache.ibatis.plugin.Intercepts;
import org.apache.ibatis.plugin.Invocation;
import org.apache.ibatis.plugin.Plugin;
import org.apache.ibatis.plugin.Signature;
import org.apache.ibatis.session.ResultHandler;
import org.apache.ibatis.session.RowBounds;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

/**
 * 환자명 마스킹 해제 스위치 (2026-08-26 「위너넷으로만 * 없애서, 일반병원은 기존대로」).
 *   매퍼 93곳의 마스킹 식이 #{sWnnYn} 로 분기한다 — 값은 여기서 모든 map 파라미터 조회에 자동으로 실어 준다
 *   (호출 컨트롤러가 수십 개라 각자 넣게 하면 반드시 빠뜨린다).
 *   ★위너넷 판별은 쿠키·세션을 **함께** 본다 — wnn_consult 로그인 경유면 세션에 s_wnn_yn 이 없다
 *     (MagamController.evalCompare 와 같은 함정). 판별 불가·비웹 스레드는 'N' = 마스킹 유지가 기본값.
 */
@Intercepts({ @Signature(type = Executor.class, method = "query",
        args = { MappedStatement.class, Object.class, RowBounds.class, ResultHandler.class }) })
public class WnnMaskInterceptor implements Interceptor {

    @Override
    public Object intercept(Invocation invocation) throws Throwable {
        Object param = invocation.getArgs()[1];
        if (param instanceof Map) {
            @SuppressWarnings("unchecked")
            Map<String, Object> m = (Map<String, Object>) param;
            try {
                if (!m.containsKey("sWnnYn")) {
                    m.put("sWnnYn", wnnYn());
                }
            } catch (Exception ignore) { }
        } else if (param != null) {
            // ★매퍼 인터페이스 호출은 XML 이 parameterType="map" 이어도 DTO 가 그대로 온다
            //   (PatvalDTO·TotalDTO — 2026-08-26 「대상자리스트 안뿌려짐」의 원인: sWnnYn getter 없음 → 조회 예외).
            //   sWnnYn 필드를 가진 DTO 에만 리플렉션으로 채운다. 없는 객체는 그냥 통과.
            try {
                java.lang.reflect.Field f = param.getClass().getDeclaredField("sWnnYn");
                f.setAccessible(true);
                if (f.get(param) == null) {
                    f.set(param, wnnYn());
                }
            } catch (NoSuchFieldException ignore) {
            } catch (Exception ignore) { }
        }
        return invocation.proceed();
    }

    private static String wnnYn() {
        try {
            ServletRequestAttributes a = (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
            if (a == null) return "N";
            HttpServletRequest req = a.getRequest();
            HttpSession ses = req.getSession(false);
            Object w = (ses != null) ? ses.getAttribute("s_wnn_yn") : null;
            if (w != null && "Y".equalsIgnoreCase(String.valueOf(w).trim())) return "Y";
            String ck = ClientInfo.getCookie(req).get("s_wnn_yn");
            return (ck != null && "Y".equalsIgnoreCase(ck.trim())) ? "Y" : "N";
        } catch (Exception e) {
            return "N";
        }
    }

    @Override
    public Object plugin(Object target) { return Plugin.wrap(target, this); }

    @Override
    public void setProperties(Properties properties) { }
}
