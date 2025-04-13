package egovframework.util;

import java.util.regex.Pattern;

import javax.servlet.http.HttpServletRequest;



public class GetClientIP {
    public static String getClientIP(HttpServletRequest request) {
        String ip = request.getHeader("X-Forwarded-For"); // 프록시 서버 사용 시 확인
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("Proxy-Client-IP");
        }
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("WL-Proxy-Client-IP"); // 웹로직 서버 사용 시 확인
        }
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("HTTP_CLIENT_IP");
        }
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("HTTP_X_FORWARDED_FOR");
        }
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getRemoteAddr(); // 최종적으로 기본 IP 가져오기
        }
        return ip;
    }

}