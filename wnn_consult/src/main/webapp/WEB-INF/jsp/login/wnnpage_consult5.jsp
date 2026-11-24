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


  <title>요양기관 현지조사 대비·대응 컨설팅 | 위너넷</title>
  <meta name="description" content="요양기관 현지조사에 대비해 진료기록과 청구자료를 점검하고, 조사 준비와 대응에 필요한 실무 컨설팅을 제공합니다.">
  <meta name="robots" content="index,follow">
  <link rel="canonical" href="https://winner797.co.kr/wnn_consult/login/wnnpage_consult5.do">
  <meta property="og:type" content="website">
  <meta property="og:site_name" content="위너넷">
  <meta property="og:title" content="요양기관 현지조사 대비·대응 컨설팅 | 위너넷">
  <meta property="og:description" content="요양기관 현지조사에 대비해 진료기록과 청구자료를 점검하고, 조사 준비와 대응에 필요한 실무 컨설팅을 제공합니다.">
  <meta property="og:url" content="https://winner797.co.kr/wnn_consult/login/wnnpage_consult5.do">
  <script type="application/ld+json">{"@context":"https://schema.org","@type":"Service","name":"현지조사 컨설팅","serviceType":"컨설팅","description":"요양기관 현지조사에 대비해 진료기록과 청구자료를 점검하고, 조사 준비와 대응에 필요한 실무 컨설팅을 제공합니다.","url":"https://winner797.co.kr/wnn_consult/login/wnnpage_consult5.do","provider":{"@type":"Organization","name":"위너넷","url":"https://winner797.co.kr/wnn_consult/"}}</script>

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
<!-- [SEO 본문문구] 마케팅 회신 H열 문구 - 원복하려면 이 주석 두 개 사이를 지우세요 -->
<div class="wnn-intro" style="padding:18px 24px 6px;font-size:17px;line-height:1.7;font-weight:700;color:#111;">
요양기관 현지조사를 앞두고 준비 절차나 자료 점검이 필요한 병원을 위해 진료기록과 청구자료를 살펴보고 조사 준비와 대응 실무를 지원합니다.
</div>
<!-- [/SEO 본문문구] -->
<div class="tab-content" style="padding-bottom: 150px;">
    <div class="tab-pane fade" id="sub-tab1">
        <div class="steb-container">
            <div class="chart-wrap">				
                <section class="content-box text-center position-relative" style="display: inline-block;">				    
			        <img src="/wnn_consult/images/winct/consult5_1.svg" class="img-fluid" alt="WinnerNet Main Image" style="width: 100%;">				        
 				        <button type="button" class="btn overlay-btn overlay-btn-h1" onclick="fnVisitAsqOpen()"></button> 	
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



