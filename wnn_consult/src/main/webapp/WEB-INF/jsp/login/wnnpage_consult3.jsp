<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>  
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="decorator" uri="http://www.opensymphony.com/sitemesh/decorator" %>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/page" prefix="page" %>
<%@ page import ="java.util.Date" %>

<!DOCTYPE html>
<html lang="ko">
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

<style>
 </style>
</head>
<body>
<!-- 서브 탭메뉴 영역 -->
<ul class="stab-menu nav nav-tabs">
  <li class="stab-item">
    <a class="stab-link active" id="tab1" data-bs-toggle="tab" href="#sub-tab1">의료기관 인증 컨설팅</a>
  </li>
</ul>

<div class="tab-content" style="padding-bottom: 150px;">
  <div class="tab-pane fade show active" id="sub-tab1">
    <div class="steb-container">
      <div class="chart-wrap">
        <section class="content-box text-center position-relative" style="display: inline-block;">
          <!-- 이미지 -->
          <img src="/images/winct/consult3_1.jpg" class="img-fluid" alt="WinnerNet Main Image" style="width: 100%;">


          <!-- 오버레이 버튼 -->
          <button type="button" class="btn overlay-btn overlay-btn-l" onclick="openMyImagePopup('/images/winct/consult3_1_1.jpg')">자세히보기</button>
          <button type="button" class="btn overlay-btn overlay-btn-c" onclick="openMyImagePopup('/images/winct/consult3_1_2.jpg')">자세히보기</button>
          <button type="button" class="btn overlay-btn overlay-btn-r" onclick="openMyImagePopup('/images/winct/consult3_1_3.jpg')">자세히보기</button>
        </section>
      </div>
    </div>
  </div>
</div>
<!-- 팝업 영역 -->
<div class="overlay" id="overlay" onclick="closePopup()"></div>
<div class="popup-box" id="popupBox">
  <div class="popup-close" onclick="closePopup()">
  <span class="close-text">닫기</span>
</div>
  <img id="popupImg" src="" alt="팝업 이미지" width="600" height="600">
</div>
<script type="text/javascript">
</script>
</body>
</html>
