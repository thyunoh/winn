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


  <title>요양병원 인증 컨설팅 | 4주기 인증 준비 | 위너넷</title>
  <meta name="description" content="요양병원 인증기준에 맞춰 규정과 문서를 점검하고, 인증 준비와 현장 컨설팅, 직원 교육 및 모의조사를 지원합니다.">
  <meta name="robots" content="index,follow">
  <link rel="canonical" href="https://winner797.co.kr/wnn_consult/login/wnnpage_consult3.do">
  <meta property="og:type" content="website">
  <meta property="og:site_name" content="위너넷">
  <meta property="og:title" content="요양병원 인증 컨설팅 | 4주기 인증 준비 | 위너넷">
  <meta property="og:description" content="요양병원 인증기준에 맞춰 규정과 문서를 점검하고, 인증 준비와 현장 컨설팅, 직원 교육 및 모의조사를 지원합니다.">
  <meta property="og:url" content="https://winner797.co.kr/wnn_consult/login/wnnpage_consult3.do">
  <script type="application/ld+json">{"@context":"https://schema.org","@type":"Service","name":"의료기관 인증 컨설팅","serviceType":"컨설팅","description":"요양병원 인증기준에 맞춰 규정과 문서를 점검하고, 인증 준비와 현장 컨설팅, 직원 교육 및 모의조사를 지원합니다.","url":"https://winner797.co.kr/wnn_consult/login/wnnpage_consult3.do","provider":{"@type":"Organization","name":"위너넷","url":"https://winner797.co.kr/wnn_consult/"}}</script>

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
    <a class="stab-link active" id="tab1" data-bs-toggle="tab" href="#sub-tab1">의료기관 인증 컨설팅</a>
  </li>
</ul>

<!-- [SEO 본문문구] 마케팅 회신 H열 문구 - 원복하려면 이 주석 두 개 사이를 지우세요 -->
<div class="wnn-intro" style="padding:18px 24px 6px;font-size:17px;line-height:1.7;font-weight:700;color:#111;">
요양병원 인증을 준비하며 규정집과 관련 문서를 정비하거나 현장 점검·직원 교육·모의조사가 필요한 기관을 위해 인증 준비 과정을 지원합니다.
</div>
<!-- [/SEO 본문문구] -->
<div class="tab-content" style="padding-bottom: 150px;">
  <div class="tab-pane fade show active" id="sub-tab1">
    <div class="steb-container">
      <div class="chart-wrap">
        <section class="content-box text-center position-relative" style="display: inline-block;">
          <!-- 이미지 -->
          <img src="/wnn_consult/images/winct/consult3_11.svg" class="img-fluid" alt="WinnerNet Main Image" style="width: 100%;">

          <!-- 오버레이 버튼 -->
          <button type="button" class="btn overlay-btn overlay-btn-a" onclick="openMyImagePopup('/wnn_consult/images/winct/consult3_1_1.svg')"></button>
          <button type="button" class="btn overlay-btn overlay-btn-b" onclick="openMyImagePopup('/wnn_consult/images/winct/consult3_1_2.svg')"></button>
          <button type="button" class="btn overlay-btn overlay-btn-c" onclick="openMyImagePopup('/wnn_consult/images/winct/consult3_1_3.svg')"></button>
         <button type="button" class="btn overlay-btn overlay-btn-d" onclick="fnVisitAsqOpen()"></button>	          
        </section>
      </div>
    </div>
  </div>
</div>
<!-- 팝업영역 openMyImagePopup이 펑션은 login\LoginWinCT.jsp 실행됨   -->
<div class="overlay" id="overlay" onclick="closePopup()"></div>
<div class="popup-box" id="popupBox">
  <div class="popup-close" onclick="closePopup()">
      <span class="close-text">닫기</span>
  </div>
  <img id="popupImg" src="" alt="팝업 이미지">
</div>

</body>
</html>



