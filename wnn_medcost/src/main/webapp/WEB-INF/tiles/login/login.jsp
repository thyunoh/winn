<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
<tiles:insertAttribute name="header" />
</head>
<body>
<script>
// URL에서 .do 제거 (브라우저 주소창에서만 숨김)
(function() {
    var loc = window.location;
    var path = loc.pathname;
    if (path.indexOf('.do') !== -1) {
        var newPath = path.replace(/\.do$/,'').replace(/\.do\?/,'?').replace(/\.do#/,'#');
        if (newPath !== path) {
            history.replaceState(null, '', newPath + loc.search + loc.hash);
        }
    }
})();
</script>
	<div id="wrap" class="wrap">
		<div id="header">
		</div>
		<div id="contents">
		<tiles:insertAttribute name="content" />	
		<%-- <tiles:insertAttribute name="foot" /> --%>
		</div>
	</div>
</body>