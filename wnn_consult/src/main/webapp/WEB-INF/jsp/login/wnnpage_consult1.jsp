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


  <title>병원·요양병원·한방병원 컨설팅 | 위너넷</title>
  <meta name="description" content="병원·요양병원·한방병원의 진료비 분석과 청구·심사 업무를 지원합니다. 기관 상황에 맞춰 재청구, 적정성평가, 인증 등 필요한 컨설팅을 안내합니다.">
  <meta name="robots" content="index,follow">
  <link rel="canonical" href="https://winner797.co.kr/wnn_consult/login/wnnpage_consult1.do">
  <meta property="og:type" content="website">
  <meta property="og:site_name" content="위너넷">
  <meta property="og:title" content="병원·요양병원·한방병원 컨설팅 | 위너넷">
  <meta property="og:description" content="병원·요양병원·한방병원의 진료비 분석과 청구·심사 업무를 지원합니다. 기관 상황에 맞춰 재청구, 적정성평가, 인증 등 필요한 컨설팅을 안내합니다.">
  <meta property="og:url" content="https://winner797.co.kr/wnn_consult/login/wnnpage_consult1.do">
  <script type="application/ld+json">{"@context":"https://schema.org","@type":"Service","name":"병의원·요양병원·한방병원 컨설팅","serviceType":"컨설팅","description":"병원·요양병원·한방병원의 진료비 분석과 청구·심사 업무를 지원합니다. 기관 상황에 맞춰 재청구, 적정성평가, 인증 등 필요한 컨설팅을 안내합니다.","url":"https://winner797.co.kr/wnn_consult/login/wnnpage_consult1.do","provider":{"@type":"Organization","name":"위너넷","url":"https://winner797.co.kr/wnn_consult/"}}</script>

<style>
.tab-content {
    min-height: calc(100vh - 100px); /* 대략 footer 높이 고려해서 조정 */
}
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
	<!-- [SEO 본문문구] 마케팅 회신 H열 문구 - 원복하려면 이 주석 두 개 사이를 지우세요 -->
<div class="wnn-intro" style="padding:18px 24px 6px;font-size:17px;line-height:1.7;font-weight:700;color:#111;">
병원 운영 중 진료비 청구나 심사, 적정성평가, 인증 준비에 어려움이 있다면 기관 상황에 맞는 컨설팅을 확인해 보세요. 위너넷이 의료기관별 실무 과제를 함께 점검합니다.
</div>
<!-- [/SEO 본문문구] -->
<div class="tab-content" style="padding-bottom: 150px;">
	    <div class="tab-pane fade" id="sub-tab1">
	        <div class="steb-container">
	            <div class="chart-wrap">
				    <section class="content-box text-center position-relative" style="display: inline-block;">				    
				        <img src="/wnn_consult/images/winct/consult1_11.svg" class="img-fluid" alt="WinnerNet Main Image" style="width: 100%;">	
 			<!--          <button type="button" class="btn overlay-btn overlay-btn-e1" onclick="fnasq_main()"></button>		-->			         
			           <button type="button" class="btn overlay-btn overlay-btn-e1" onclick="fnVisitAsqOpen()"></button> 			        
				    </section>
				</div>
	        </div>
	    </div>
	
	    <div class="tab-pane fade" id="sub-tab2">
	        <div class="steb-container">
	            <div class="chart-wrap">
				    <section class="content-box text-center position-relative" style="display: inline-block;">				    
				        <img src="/wnn_consult/images/winct/consult1_12.svg" class="img-fluid" alt="WinnerNet Main Image" style="width: 100%;">				        
				          <button type="button" class="btn overlay-btn overlay-btn-e2" onclick="fnVisitAsqOpen()"></button> 				        
				    </section>
	            </div>
	        </div>
	    </div>
	
	    <div class="tab-pane fade" id="sub-tab3">
	        <div class="steb-container">
	            <div class="chart-wrap">
				    <section class="content-box text-center position-relative" style="display: inline-block;">				    
				        <img src="/wnn_consult/images/winct/consult1_13.svg" class="img-fluid" alt="WinnerNet Main Image" style="width: 100%;">				        
 				          <button type="button" class="btn overlay-btn overlay-btn-e3" onclick="fnVisitAsqOpen()"></button> 			        
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
