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
<style>
  .overlay {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: rgba(0,0,0,0.5);
    z-index: 999;
  }

  .popup-box {
    position: fixed;
    top: 50%;
    left: 0; /* 좌측 끝으로 이동 */
    transform: translateY(-50%);
    background: white;
    padding: 10px;
    z-index: 1000;
    max-height: 80vh;
    overflow: auto; /* 스크롤 가능하도록 */
  }
.popup-close {
  position: absolute;
  top: 20px;
  right: 20px;
  cursor: pointer;
  font-size: 16px;
  font-weight: normal;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 4px 8px;
  background-color: #f0f0f0; /* 버튼처럼 보이게 */
  border-radius: 4px;
  border: 1px solid #ccc;
  color: black; /* 글자색을 검정으로 지정 */
}

.popup-close:hover {
  background-color: #ddd;
}
#popupImg {
    max-width: 100%;
    height: auto;
    display: block;
}
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
          <button type="button" class="btn overlay-btn overlay-btn_c" onclick="openMyImagePopup('/images/winct/consult3_1_2.jpg')">자세히보기</button>
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
  <img id="popupImg" src="" alt="팝업 이미지" width="600" height="500">
</div>
<script type="text/javascript">
</script>
</body>
</html>
