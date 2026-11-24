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
    .tab-content .tab-pane { height: auto !important; }
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
	    <div class="tab-pane fade show active" id="sub-tab1">
	        <div class="steb-container">
	            <div class="chart-wrap">
				    <section class="content-box text-center position-relative" style="display: inline-block;">				    
				        <img src="/wnn_consult/images/winct/consult1_11.svg" class="img-fluid" alt="병의원 컨설팅 안내 이미지" style="width: 100%;">	
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
				        <img src="/wnn_consult/images/winct/consult1_12.svg" class="img-fluid" alt="요양병원 컨설팅 안내 이미지" style="width: 100%;">				        
				          <button type="button" class="btn overlay-btn overlay-btn-e2" onclick="fnVisitAsqOpen()"></button> 				        
				    </section>
	            </div>
	        </div>
	    </div>
	
	    <div class="tab-pane fade" id="sub-tab3">
	        <div class="steb-container">
	            <div class="chart-wrap">
				    <section class="content-box text-center position-relative" style="display: inline-block;">				    
				        <img src="/wnn_consult/images/winct/consult1_13.svg" class="img-fluid" alt="한방병원 컨설팅 안내 이미지" style="width: 100%;">				        
 				          <button type="button" class="btn overlay-btn overlay-btn-e3" onclick="fnVisitAsqOpen()"></button> 			        
				    </section>
	            </div>
	        </div>
	    </div>  
	    
	    
	    
	</div>


<section class="seo-text container py-4">
    <h2>병원 유형별 진료비 청구·심사 컨설팅</h2>
    <p>병의원, 요양병원, 한방병원은 기관 유형마다 청구 기준과 점검 항목이 다릅니다. 위너넷은 기관 상황을 먼저 확인한 뒤, 진료비 분석과 청구·심사 업무에 필요한 컨설팅을 안내합니다.</p>

    <h3>주요 점검 영역</h3>
    <ul>
        <li><strong>진료비 분석:</strong> 청구 내역을 기간·항목별로 살펴 이상 패턴과 개선 지점 확인</li>
        <li><strong>청구·심사 업무:</strong> 청구 명세와 심사 결과를 비교해 재청구 검토 대상 정리</li>
        <li><strong>적정성평가·인증 준비:</strong> 평가와 인증에 필요한 자료 항목과 준비 순서 안내</li>
    </ul>

    <p class="small text-muted">위 탭(병의원·요양병원·한방병원)에서 기관 유형에 맞는 안내를 확인하세요. 본 페이지는 일반적인 안내이며, 개별 사안에 대한 법률·행정 판단이 아닙니다.</p>
</section>

<!-- JavaScript 추가 -->
<script>
</script>
</body>
</html>
