<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8" />
<meta content="width=device-width, initial-scale=1.0" name="viewport">

<!-- Google Web Fonts -->
<link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
<!-- JavaScript Libraries -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"> </script>
<!-- wnnnet 설정시작 -->
<title>위너넷 컨설팅</title>
<!-- Favicon -->
<link href="/images/icons/winnernet.ico" rel="icon" type="image/x-icon" >
<!-- Customized Bootstrap Stylesheet -->
<link href="/css/winct/bootstrap.css" rel="stylesheet">
<link href="/css/winct/style.css" rel="stylesheet">
<link href="/css/winct/style_login.css?v=123" rel="stylesheet"> 
<!-- Template Javascript -->
<script type="text/javascript" src="/js/winct/main.js"></script>
<script type="text/javascript" src="/js/winct/message.js"></script>
<script type="text/javascript" src="/js/winct/contact.js"></script>
<script type="text/javascript" src="/js/winct/loading.js"></script>
<script type="text/javascript" src="/js/winct/jqBootstrapValidation.min.js"></script> 
<!-- wnnnet 설정끝 -->
<style>
</style>
</head>
<body>
<!-- 서브 탭메뉴 영역 start -->
	<ul class="stab-menu">
	    <li class="stab-item">
	        <a class="stab-link active" id="tab1" data-bs-toggle="tab" href="#sub-tab1" onclick="changeTab(event, 'sub-tab1')">병의원컨설팅</a>
	    </li>
	    <li class="stab-item">
	        <a class="stab-link" id="tab2" data-bs-toggle="tab" href="#sub-tab2" onclick="changeTab(event, 'sub-tab2')">요양병원컨설팅</a>
	    </li>
	    <li class="stab-item">
	        <a class="stab-link" id="tab3"  data-bs-toggle="tab" href="#sub-tab3" onclick="changeTab(event, 'sub-tab3')">한방병원컨설팅</a>
	    </li>
	</ul>
	
	<!-- 콘텐츠 영역 -->
	<div class="tab-content" style="padding-bottom: 150px;">
	    <div class="tab-pane fade" id="sub-tab1">
	        <div class="steb-container">
	            <div class="chart-wrap">
				    <section class="content-box">
				        <img src="/images/winct/consult1_1.jpg" class="img-fluid" alt="WinnerNet Main Image">
				    </section>
				</div>
	        </div>
	    </div>
	
	    <div class="tab-pane fade" id="sub-tab2">
	        <div class="steb-container">
	            <div class="chart-wrap">
				    <section class="content-box">
	                    <img src="/images/winct/consult1_2.jpg" class="img-fluid" alt="WinnerNet Main Image">
	                </section>
	            </div>
	        </div>
	    </div>
	
	    <div class="tab-pane fade" id="sub-tab3">
	        <div class="steb-container">
	            <div class="chart-wrap">
				    <section class="content-box">
	                    <img src="/images/winct/consult1_3.jpg" class="img-fluid" alt="WinnerNet Main Image">
	                </section>
	            </div>
	        </div>
	    </div>  
	</div>

<!-- JavaScript 추가 -->
<script>
</script>

</body>
</html>
