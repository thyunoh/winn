<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>  
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="decorator" uri="http://www.opensymphony.com/sitemesh/decorator" %>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/page" prefix="page" %>
<%@ page import ="java.util.Date" %>
<%
	Date nowTime = new Date();
%>

	<meta http-equiv="Content-Type" content="text/html; charset=utf-8"> </meta>
	<meta http-equiv="X-UA-Compatible" content="IE=edge"> </meta>
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">

	<title>위너넷 분석.평가 </title>    

	<link rel="stylesheet" href="/assets/vendor/bootstrap/css/bootstrap.min.css">
	<link rel="stylesheet" href="/assets/vendor/fonts/circular-std/style.css">
	<link rel="stylesheet" href="/assets/libs/css/style.css">
	<link rel="stylesheet" href="/assets/vendor/fonts/fontawesome/css/fontawesome-all.css">
	<link rel="stylesheet" href="/assets/vendor/charts/chartist-bundle/chartist.css">
	<link rel="stylesheet" href="/assets/vendor/charts/morris-bundle/morris.css">
	<link rel="stylesheet" href="/assets/vendor/fonts/material-design-iconic-font/css/materialdesignicons.min.css">
	<link rel="stylesheet" href="/assets/vendor/charts/c3charts/c3.css">
	<link rel="stylesheet" href="/assets/vendor/fonts/flag-icon-css/flag-icon.min.css">	
	<link rel="stylesheet" href="https://cdn.datatables.net/v/dt/jszip-3.10.1/dt-2.1.8/b-3.2.0/b-colvis-3.2.0/b-html5-3.2.0/b-print-3.2.0/datatables.min.css" >
	<link rel="stylesheet" href="/css/winmc/addstyle.css">
	
	
	<!-- 맑은 고딕 정의 -->
	<style>
	    html, body {
        font-family: 'Malgun Gothic', '맑은 고딕', 'Apple SD Gothic Neo', sans-serif;
        font-weight: bold;
    }

    * {
        font-family: inherit;
        font-weight: inherit;
    }
	</style>
	
	<!-- 나눔고딕 Bold 웹폰트 로드 
	<link rel="preconnect" href="https://cdn.jsdelivr.net" crossorigin>
	<style>
	    @font-face {
	        font-family: 'Nanum Gothic Bold';
	        src: url('https://cdn.jsdelivr.net/gh/projectnoonnu/noonfonts_2107@1.1/NanumGothic-Bold.woff2') format('woff2');
	        font-weight: normal;
	        font-style: normal;
	    }
	
	    html, body {
	        font-family: 'Nanum Gothic Bold', '나눔고딕', 'Malgun Gothic', sans-serif;
	        font-weight: normal;
	    }
	
	    * {
	        font-family: inherit;
	    }
	</style>
	
	
	<!-- 구글 웹폰트 링크  
	<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&display=swap" rel="stylesheet">
	
	<style>
	    html, body {
	        font-family: 'Noto Sans KR', 'Apple SD Gothic Neo', 'Malgun Gothic', '맑은 고딕', sans-serif;
	    }
	
	    * {
	        font-family: inherit;
	    }
	</style>
	-->
	
	<!-- Noto Sans KR 웹폰트 불러오기 
	<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR&display=swap" rel="stylesheet">
	
	<style>
	    html, body {
	        font-family: 'Noto Sans KR', '본고딕', 'Malgun Gothic', sans-serif;
	        font-weight: normal;
	    }
	
	    * {
	        font-family: inherit;
	    }
	</style>
	-->
	
	
	<!--**********************************
	    Scripts
	***********************************-->
	<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.2.7/pdfmake.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.2.7/vfs_fonts.js"></script>
	<script src="https://cdn.datatables.net/v/dt/jszip-3.10.1/dt-2.1.8/b-3.2.0/b-colvis-3.2.0/b-html5-3.2.0/b-print-3.2.0/datatables.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.18.5/xlsx.full.min.js"></script>    


	<!-- chart bundle js -->
	<script src="/assets/vendor/raphael/raphael.min.js"></script>
	<script src="/assets/vendor/morris/morris.min.js"></script>
	
	
	<script src="/assets/vendor/circle-progress/circle-progress.min.js"></script>
    <script src="/assets/vendor/chart.js/Chart.bundle.min.js"></script>
	<script src="/assets/vendor/owl-carousel/js/owl.carousel.min.js"></script>	
	<script src="/assets/vendor/jqvmap/js/jquery.vmap.min.js"></script>
    <script src="/assets/vendor/jqvmap/js/jquery.vmap.usa.js"></script>
    
    <script src="/js/plugins-init/morris-init.js"></script>
    <script src="/js/plugins-init/chartist-init.js"></script>
    
    <!--     
    <script src="/assets/vendor/chartist/js/chartist.min.js"></script>
    <script src="/assets/vendor/chartist-plugin-tooltips/js/chartist-plugin-tooltip.min.js"></script>
    -->
    
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
	<script src="/assets/vendor/jquery-sparkline/jquery.sparkline.min.js"></script>
    <script src="/js/plugins-init/sparkline-init.js"></script>


	<!-- bootstap bundle js -->
	<script src="/assets/vendor/bootstrap/js/bootstrap.bundle.js"></script>
	<!-- slimscroll js -->
	<script src="/assets/vendor/slimscroll/jquery.slimscroll.js"></script>	
	<!-- main js -->
	<script src="/assets/libs/js/main-js.js"></script>
	<!-- inputmask js -->
	<script src="/assets/vendor/inputmask/js/jquery.inputmask.bundle.js"></script>	
	<!-- messagebox js -->
	<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>	
	<!-- Template Javascript -->
	<script type="text/javascript" src="/js/winmc/main.js"></script>
	<script type="text/javascript" src="/js/winmc/mess_cd.js"></script>
	<script type="text/javascript" src="/js/winmc/message.js"></script>
	<script type="text/javascript" src="/js/winmc/commons.js"></script>
	<script type="text/javascript" src="/js/winmc/contact.js"></script>
	<script type="text/javascript" src="/js/winmc/loading.js"></script>
	<script type="text/javascript" src="/js/winmc/jqBootstrapValidation.min.js"></script>
	 
	<script type="text/javascript" src="/js/winmc/schcommons.js"></script> <!--공통검색 -->
    <script type="text/javascript" src="/js/winmc/authControl.js"></script> <!--권한관리 -->   
    <script type="text/javascript" src="/js/winmc/schcommons.js"></script> <!--병원검색 -->
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script src="https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.4.1/html2canvas.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>

    
    
    