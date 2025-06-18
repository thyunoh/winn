<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8" />
<meta content="width=device-width, initial-scale=1.0" name="viewport">

<!-- jQuery -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<!-- Bootstrap CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<title>위너넷 컨설팅</title>
<!-- Favicon -->
<link href="/images/icons/winnernet.ico" rel="icon" type="image/x-icon">
<!-- Custom CSS -->
<link href="/css/winct/bootstrap.css"         rel="stylesheet">
<link href="/css/winct/style.css"             rel="stylesheet">
<link href="/css/winct/style_login.css?v=123" rel="stylesheet">
<style>
.tab-content {
    min-height: calc(100vh - 100px); /* 대략 footer 높이 고려해서 조정 */
}
</style>

</head>
<body>

<!-- 서브 탭메뉴 영역 -->
<ul class="stab-menu nav nav-tabs">
    <li class="stab-item">
        <a class="stab-link active" id="tab1" data-bs-toggle="tab" href="#sub-tab1" onclick="changeTab(event, 'sub-tab1')">현지조사 컨설팅</a>
    </li>
</ul>
<div class="tab-content" style="padding-bottom: 150px;">
    <div class="tab-pane fade" id="sub-tab1">
        <div class="steb-container">
            <div class="chart-wrap">
				    <section class="content-box">
                    <img src="/images/winct/consult5_1.jpg" class="img-fluid" alt="WinnerNet Main Image">
                </section>
            </div>
        </div>
    </div>
</div>

<!-- JavaScript -->
<script>
</script>

</body>
</html>



