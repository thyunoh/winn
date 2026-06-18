<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<head>
<script>
(function(){
  // URL 숨김 + 새로고침(F5) 시 보던 화면 유지.
  //   - 실제 화면 진입(메뉴 클릭) 시: 실제 경로를 _realPath 에 저장하고 주소창은
  //     '/user/dashboard.do' 로 숨긴다(주소창에 실제 경로 비노출).
  //   - F5(새로고침) 시: 브라우저가 숨김 주소('/user/dashboard.do')를 다시 요청 →
  //     이 스크립트가 _realPath(숨겨둔 실제 경로)로 location.replace 하여 보던 화면을 복원한다.
  //   - 대시보드 '메뉴 클릭'(reload 아님)으로 진입한 경우엔 그대로 대시보드를 보여준다.
  //   ※ 숨김 주소로 '/user/' 를 쓰면 *.do 매핑이 아니라 F5 시 스크립트조차 실행 못 해(빈 화면)
  //     복원이 불가능하므로, 해석 가능한 '/user/dashboard.do' 를 숨김 주소로 사용한다.
  function navType(){
    try {
      var e = performance.getEntriesByType && performance.getEntriesByType('navigation')[0];
      if (e && e.type) return e.type;                                   // 'navigate' | 'reload' | 'back_forward'
      if (performance.navigation) return performance.navigation.type === 1 ? 'reload' : 'navigate';
    } catch (ignore) {}
    return 'navigate';
  }
  var isReload = (navType() === 'reload');
  var realPath = location.pathname + location.search;

  if (realPath === '/user/dashboard.do') {
    var rp = sessionStorage.getItem('_realPath');
    if (isReload && rp && rp !== '/user/dashboard.do') {
      // F5: 숨겨둔 실제 화면으로 복원 (복원 후 아래 else-if 가 다시 주소를 숨김)
      location.replace(rp);
      return;
    }
    // 대시보드 메뉴 진입 또는 대시보드 자체 새로고침 → 대시보드 표시
    sessionStorage.setItem('_realPath', '/user/dashboard.do');
  } else if (realPath !== '/user/' && realPath !== '/') {
    // 실제 화면 진입 → 경로 저장 후 주소 숨김
    sessionStorage.setItem('_realPath', realPath);
    history.replaceState({ _realPath: realPath }, '', '/user/dashboard.do');
  } else if (!sessionStorage.getItem('_realPath')) {
    sessionStorage.setItem('_realPath', '/user/dashboard.do');
  }
})();
</script>
<tiles:insertAttribute name="header" />

</head>
<body> 

	<tiles:insertAttribute name="top" />
		
    <tiles:insertAttribute name="content" />
	
<script>
function loadPage(url) {
  
  $.ajax({
    url: url,
    method: "GET",
	data: {
		
    },
    beforeSend: function() {
      $('#contentArea').empty();
    },
    success: function(response) {    
      $('#contentArea').html(response);      
    },
    error: function(xhr, status, error) {
      alert("페이지 로드 실패: " + error);
    }
  });
}

</script>
	
</body>
</html>