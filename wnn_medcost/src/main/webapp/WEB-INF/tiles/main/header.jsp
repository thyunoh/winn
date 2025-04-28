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
	
	<!--**********************************
	    Scripts
	***********************************-->
	<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.2.7/pdfmake.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.2.7/vfs_fonts.js"></script>
	<script src="https://cdn.datatables.net/v/dt/jszip-3.10.1/dt-2.1.8/b-3.2.0/b-colvis-3.2.0/b-html5-3.2.0/b-print-3.2.0/datatables.min.js"></script>

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
	
	