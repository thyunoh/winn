package egovframework.util;

import java.util.HashMap;
import java.util.Map;
import java.util.regex.Pattern;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;

public class ClientInfo {
	
	public static String getClientIP(HttpServletRequest request) {
	    String ip = request.getHeader("X-Forwarded-For");

	    if (ip == null) {
	        ip = request.getHeader("Proxy-Client-IP");
	    }
	    if (ip == null) {
	        ip = request.getHeader("WL-Proxy-Client-IP");
	    }
	    if (ip == null) {
	        ip = request.getHeader("HTTP_CLIENT_IP");
	    }
	    if (ip == null) {
	        ip = request.getHeader("HTTP_X_FORWARDED_FOR");
	    }
	    if (ip == null) {
	        ip = request.getRemoteAddr();
	    }
	    return ip;
	}
	
	public static  Map<String, String> getCookie(HttpServletRequest request) {
        // HttpServletRequest에서 쿠키 배열 가져오기
        Cookie[] cookies = request.getCookies();        
        Map<String, String> cookieval = new HashMap<>();
        
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("s_hospid".equals(cookie.getName())) {
                	cookieval.put("s_hospid", cookie.getValue());
                }
                if ("s_userid".equals(cookie.getName())) {
                	cookieval.put("s_userid", cookie.getValue());
                }
                if ("s_hospnm".equals(cookie.getName())) {
                	cookieval.put("s_hospnm", cookie.getValue());
                }
                if ("s_usernm".equals(cookie.getName())) {
                	cookieval.put("s_usernm", cookie.getValue());
                }
                if ("s_mainfg".equals(cookie.getName())) {
                	cookieval.put("s_mainfg", cookie.getValue());
                }
                if ("s_use_yn".equals(cookie.getName())) {
                	cookieval.put("s_use_yn", cookie.getValue());
                }
            }
        }
        
        return cookieval;
    }

}