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


  <title>요양병원 적정성평가 컨설팅 | 월분석·지표 관리 | 위너넷</title>
  <meta name="description" content="요양병원 입원급여 적정성평가 자료와 환자평가표·의무기록을 분석해 지표별 현황과 개선 과제를 안내하고, 월별 점검과 평가 대응을 지원합니다.">
  <meta name="robots" content="index,follow">
  <link rel="canonical" href="https://winner797.co.kr/wnn_consult/login/wnnpage_consult4.do">
  <meta property="og:type" content="website">
  <meta property="og:site_name" content="위너넷">
  <meta property="og:title" content="요양병원 적정성평가 컨설팅 | 월분석·지표 관리 | 위너넷">
  <meta property="og:description" content="요양병원 입원급여 적정성평가 자료와 환자평가표·의무기록을 분석해 지표별 현황과 개선 과제를 안내하고, 월별 점검과 평가 대응을 지원합니다.">
  <meta property="og:url" content="https://winner797.co.kr/wnn_consult/login/wnnpage_consult4.do">
  <script type="application/ld+json">{"@context":"https://schema.org","@type":"Service","name":"병원·요양병원 컨설팅","serviceType":"컨설팅","description":"요양병원 입원급여 적정성평가 자료와 환자평가표·의무기록을 분석해 지표별 현황과 개선 과제를 안내하고, 월별 점검과 평가 대응을 지원합니다.","url":"https://winner797.co.kr/wnn_consult/login/wnnpage_consult4.do","provider":{"@type":"Organization","name":"위너넷","url":"https://winner797.co.kr/wnn_consult/"}}</script>

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
        <a class="stab-link active" id="tab1" data-bs-toggle="tab" href="#sub-tab1" onclick="changeTab(event, 'sub-tab1')">병원컨설팅</a>
    </li>
    <li class="stab-item">
        <a class="stab-link active" id="tab2" data-bs-toggle="tab" href="#sub-tab2" onclick="changeTab(event, 'sub-tab1')">요양병원컨설팅</a>
    </li>
</ul>
<!-- [SEO 본문문구] 마케팅 회신 H열 문구 - 원복하려면 이 주석 두 개 사이를 지우세요 -->
<div class="wnn-intro" style="padding:18px 24px 6px;font-size:17px;line-height:1.7;font-weight:700;color:#111;">
적정성평가 점수와 지표를 관리하고 싶은 요양병원을 위해 월별 분석, 환자평가표·의무기록 점검, 평가자료 오류 확인 및 개선 방향을 안내합니다. 윈체크 적정성평가 프로그램을 통한 분석도 확인할 수 있습니다.
</div>
<!-- [/SEO 본문문구] -->
<div class="tab-content" style="padding-bottom: 150px;">
	<div class="tab-pane fade show active" id="sub-tab1">
        <div class="steb-container">
            <div class="chart-wrap">
			    <section class="content-box text-center position-relative" style="display: inline-block;">				    
			        <img src="/wnn_consult/images/winct/consult4_1.svg" class="img-fluid" alt="병원 적정성평가 컨설팅 안내 이미지" style="width: 100%;">				        
 				        <button type="button" class="btn overlay-btn overlay-btn-g1" onclick="fnVisitAsqOpen()"></button> 	
			    </section>
			</div>
        </div>
    </div>

    <div class="tab-pane fade" id="sub-tab2">
        <div class="steb-container">
            <div class="chart-wrap">
			    <section class="content-box text-center position-relative" style="display: inline-block;">				    
			        <img src="/wnn_consult/images/winct/consult4_2.svg" class="img-fluid" alt="요양병원 적정성평가 컨설팅 안내 이미지" style="width: 100%;">				        
			        <button type="button" class="btn overlay-btn overlay-btn-g2" onclick="fnVisitAsqOpen()"></button> 				        		        
			    </section>
            </div>
        </div>
    </div>
	    
    
</div>

<section class="seo-text container py-4">
    <h2>요양병원 적정성평가, 월별로 나눠 관리하기</h2>
    <p>적정성평가는 지표 하나가 실적과 점수에 직접 영향을 줍니다. 위너넷은 평가 자료를 월별로 분석해 지표별 현황과 개선 과제를 정리하고, 평가 대응을 지원합니다.</p>

    <h3>주요 지원 내용</h3>
    <ul>
        <li><strong>월별 분석:</strong> 지표별 현황과 전월 대비 변화 확인</li>
        <li><strong>환자평가표·의무기록 점검:</strong> 평가 자료의 누락과 오류 확인</li>
        <li><strong>개선 방향 안내:</strong> 점수 향상에 필요한 지표와 실행 항목 정리</li>
        <li><strong>윈체크 적정성평가 분석:</strong> 프로그램으로 확인할 수 있는 분석 결과 안내</li>
    </ul>

    <p class="small text-muted">본 페이지는 일반적인 안내이며, 개별 사안에 대한 법률·행정 판단이 아닙니다.</p>
</section>

<!-- JavaScript -->
<script>
</script>

</body>
</html>



