<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ page import="java.util.*"%>
<!DOCTYPE html>
<html>
<!-- 로그인 -->
<head>
<meta charset="UTF-8" />
<!--  <meta content="width=device-width, initial-scale=1.0" name="viewport"> --> 
  <meta content="width=1280" name="viewport"> 
<!-- Google Web Fonts -->
<!-- JavaScript Libraries -->
<!-- wnnnet 설정시작 -->
<title>위너넷 컨설팅</title>
<!-- Favicon -->
<!-- jQuery (최신 버전 유지) -->
<script src="https://code.jquery.com/jquery-3.7.1.js"></script>

<!-- DataTables (중복 제거 후 유지) -->
<link rel="stylesheet"
	href="https://cdn.datatables.net/v/dt/jszip-3.10.1/dt-2.1.8/b-3.2.0/b-colvis-3.2.0/b-html5-3.2.0/b-print-3.2.0/datatables.min.css">
<script
	src="https://cdn.datatables.net/v/dt/jszip-3.10.1/dt-2.1.8/b-3.2.0/b-colvis-3.2.0/b-html5-3.2.0/b-print-3.2.0/datatables.min.js"></script>
<!-- Bootstrap -->
<script	src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<!-- 아이콘 및 폰트 -->
<link href="/images/icons/winnernet.ico" rel="icon" type="image/x-icon">
<link
	href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&display=swap"
	rel="stylesheet">

<!-- 배포 시 버전 번호를 변경하면 브라우저 캐시 강제 갱신 -->
<%
    String cacheVer = "20260308001";  // ★ 배포할 때마다 이 값을 변경하세요 (날짜+순번 권장)
%>
<!-- CSS -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
<link href="/wnn_consult/css/winct/bootstrap.css?v=<%=cacheVer%>" rel="stylesheet">
<link href="/wnn_consult/css/winct/style.css?v=<%=cacheVer%>" rel="stylesheet">
<link href="/wnn_consult/css/winct/style_login.css?v=<%=cacheVer%>" rel="stylesheet"> <!-- 로그인css  -->
<!-- JavaScript -->
<script type="text/javascript" src="/wnn_consult/js/winct/main.js?v=<%=cacheVer%>"></script>
<script type="text/javascript" src="/wnn_consult/js/winct/message.js?v=<%=cacheVer%>"></script>
<script type="text/javascript" src="/wnn_consult/js/winct/contact.js?v=<%=cacheVer%>"></script>
<script type="text/javascript" src="/wnn_consult/js/winct/loading.js?v=<%=cacheVer%>"></script>
<script type="text/javascript" src="/wnn_consult/js/winct/schcommons.js?v=<%=cacheVer%>"></script>
<!-- ★ CommonUtil (contextPath 등) - tiles 미사용 페이지이므로 직접 로드 -->
<script type="text/javascript" src="${pageContext.request.contextPath}/asset/js/commonUtil.js?v=<%=cacheVer%>"></script>
<script>
    // tiles header.jsp와 동일하게 contextPath를 sessionStorage에 설정
    sessionStorage.setItem("contextPath", '<c:out value="${pageContext.request.contextPath}"/>');
</script>
<!-- 리치 에디터  -->
<link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.bundle.min.js"></script>

<link   href="https://cdn.jsdelivr.net/npm/summernote@0.8.20/dist/summernote-lite.min.css" rel="stylesheet"> 
<script src="https://cdn.jsdelivr.net/npm/summernote@0.8.20/dist/summernote-lite.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/lang/summernote-ko-KR.min.js"></script>
<!-- 리치 에디터   -->
<!-- SweetAlert2 -->
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<!-- 공통검색 -->

<!-- wnnnet 설정끝 -->
<!-- DataTables JS 추가 -->

</head>
<style>
/* 팝업 배경 오버레이 */
.overlay_1 {
  display: none;
  position: fixed;
  top: 0; left: 0;
  width: 100%; height: 100%;
  background-color: rgba(0, 0, 0, 0.6);
  z-index: 999;
}

/* 팝업창 */
.popup-box_1 {
  display: none;
  position: fixed;
  width: 1080px;
  height: 1080px;
  top: 50%; 
  left: 50%;
  transform: translate(-50%, -50%);
  z-index: 1000;
  background: white;
  padding: 20px;
  border-radius: 8px;
  max-width: 40%;
  max-height: 90%; 
  overflow: auto;
}

.popup-box_1 img {
  max-width: 100%;
  height: auto;
}

.popup-close_1 {
  position: absolute;
  top: 10px; right: 15px;
  font-size: 20px;
  font-weight: bold;
  color: red;
  cursor: pointer;
}

.overlay_1 {
   position: fixed;
   top: 0;
   left: 0;
   width: 100%;
   height: 100%;
   background: rgba(0,0,0,0.5);
   z-index: 999;
 }

 .popup-box_1 {
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
 
.popup-close_1 {
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

.popup-close_1:hover {
  background-color: #ddd;
}

#popupImg_1 {
    width: 100%;
    height: 100%;
    object-fit: contain; /* 비율 유지하면서 전체 영역에 맞춤 */
    display: block;
    background: #fff; /* 이미지 로딩 전 배경 */
}

</style>
<body>
<!-- Navbar Start -->
	<div class="container-fluid_act bg-white" style="position: sticky; top: 0; z-index: 100;">
		<div class="row px-xl-8">
			<div class="col-lg-3">
				<a class="btn d-flex align-items-center bg-white w-80"
				   data-bs-toggle="collapse" href="#navbar-vertical"
				   style="height: 30px; padding: 0; width: 40%; margin-left:49%; margin-top:15px;">
					<img src="/wnn_consult/images/winct/winner_log_top.svg" alt="WinnerNet Logo" id="consultingTitle">
				</a>
			</div>
			<div class="col-lg-9">
				<nav class="navbar navbar-expand bg-white navbar-light py-0 px-0" style="height: 60px; align-items: center;">
					<div class="navbar-collapse justify-content-between" style="display: flex !important;">
						<div id="navbarMenuArea" class="navbar-nav mr-auto py-0" style="margin-left:-50px;">
			
							<!-- 위너넷 링크 -->
							<a href="http://www.winnernet.co.kr/"
							   class="nav-link consulting-menu"
							   style="font-size: 16px; padding: 24px;"
							   target="_blank" rel="noopener noreferrer" onclick="setMainActive(this)">
							   위너넷 소개
							</a>
			
							<!-- 컨설팅 소개 드롭다운 -->
							<div class="nav-link text-dark position-relative">
								<a href="#" class="nav-link  consulting-menu"
								   style="font-size: 16px; padding: 24px;"
								   data-bs-toggle="dropdown" onclick="setMainActive(this)">
								   컨설팅 소개
								</a>
								<div class="dropdown-menu bg-light rounded-0 border-0 m-0">
									<a href="#" class="dropdown-item" style="font-size: 16px;" onclick="setActive(this); loadPage('/wnn_consult/login/wnnpage_consult1.do')">의료기관컨설팅</a>
									<a href="#" class="dropdown-item" style="font-size: 16px;" onclick="setActive(this); loadPage('/wnn_consult/login/wnnpage_consult2.do')">재청구컨설팅</a>
									<a href="#" class="dropdown-item" style="font-size: 16px;" onclick="setActive(this); loadPage('/wnn_consult/login/wnnpage_consult3.do')">의료기관인증컨설팅</a>
									<a href="#" class="dropdown-item" style="font-size: 16px;" onclick="setActive(this); loadPage('/wnn_consult/login/wnnpage_consult4.do')">적정성평가컨설팅</a>
									<a href="#" class="dropdown-item" style="font-size: 16px;" onclick="setActive(this); loadPage('/wnn_consult/login/wnnpage_consult5.do')">현지조사컨설팅</a>
								</div>
							</div>
			
							<!-- 온라인 교육센터 링크 -->
							<a href="https://winner797.net/"
							   class="nav-link consulting-menu"
							   style="font-size: 16px; padding: 24px;"
							   target="_blank" rel="noopener noreferrer" onclick="setMainActive(this)">
							   온라인교육센터
							</a>
			
							<div id="dynamicMenu_J" onclick="winCheckOpen()"></div>
							<div id="dynamicMenu_T" onclick="winCheckOpen()"></div>
						</div>
			
						<img src="/wnn_consult/images/winct/headerRight.svg" alt="Header Decoration" class="headerRightImg" style="height: 83px;">
					</div>
				</nav>
			</div>
	
		</div>
	</div>
<!-- Navbar End -->

	<div id="contentArea" style="display:none;"></div>

		<!-- Carousel Start -->
	<div id="carouselContainer" class="container-fluid" style="position: relative; min-height: 540px; padding: 0; margin: 0; margin-top: 10px; overflow: hidden; background-color: #fff;">

		    <!-- 슬라이드 시작 -->
			<div>
				<div id="header-carousel"
					 class="carousel slide carousel-fade"
					 data-bs-ride="carousel"
					 data-bs-interval="2000"
					 style="position: absolute; top: 0; left: 0; right: 0; z-index: 0;">
			
					<ol class="carousel-indicators">
						<li data-bs-target="#header-carousel" data-bs-slide-to="0" class="active"></li>
						<li data-bs-target="#header-carousel" data-bs-slide-to="1"></li>
						<li data-bs-target="#header-carousel" data-bs-slide-to="2"></li>
						<li data-bs-target="#header-carousel" data-bs-slide-to="3"></li>
						<li data-bs-target="#header-carousel" data-bs-slide-to="4"></li>
					</ol>
			
					<!-- 슬라이드들 -->
					<div class="carousel-item active" style="height: 540px; overflow: hidden;">
						<div class="slide-image-container d-flex align-items-stretch justify-content-center w-100 h-100">
						<!--  	<a href="https://winner797.net/detail.php?number=324" target="_blank"> -->
						      	<a href="https://winner797.kr/lecture/?seq=1075" target="_blank">
								<img src="/wnn_consult/images/winct/image9.png" style="width: 100%; height: 100%; object-fit: cover;">
							</a>
						</div>
					</div>
					<div class="carousel-item" style="height: 540px; overflow: hidden;">
						<div class="slide-image-container d-flex align-items-stretch justify-content-center w-100 h-100">
						<!--  	<a href="https://winner797.net/detail.php?number=321" target="_blank"> -->
						     	<a href="https://winner797.kr/lecture/?seq=1073" target="_blank">
								<img src="/wnn_consult/images/winct/image7.png" style="width: 100%; height: 100%; object-fit: cover;">
							</a>
						</div>
					</div>
					<div class="carousel-item" style="height: 540px; overflow: hidden;">
						<div class="slide-image-container d-flex align-items-stretch justify-content-center w-100 h-100">
							<img src="/wnn_consult/images/winct/image2.svg" style="width: 100%; height: 100%; object-fit: cover;">
						</div>
					</div>
					<div class="carousel-item" style="height: 540px; overflow: hidden;">
						<div class="slide-image-container d-flex align-items-stretch justify-content-center w-100 h-100">
							<img src="/wnn_consult/images/winct/image3.svg" style="width: 100%; height: 100%; object-fit: cover;">
						</div>
					</div>
					<div class="carousel-item" style="height: 540px; overflow: hidden;">
						<div class="slide-image-container d-flex align-items-stretch justify-content-center w-100 h-100">
						<!--  	<a href="https://winner797.net/detail.php?number=308&category=1023" target="_blank"> -->
						  	    <a href="https://winner797.kr/lecture/?seq=1024&sort01=&page=1" target="_blank"> 
								<img src="/wnn_consult/images/winct/image5.svg" style="width: 100%; height: 100%; object-fit: cover;">
							</a>
						</div>
					</div>
			
					<!-- 왼쪽 화살표 버튼 -->
					<button class="custom-arrow left-arrow" type="button" data-bs-target="#header-carousel" data-bs-slide="prev">
						<span class="arrow-text">◁</span>
					</button>
			
					<!-- 오른쪽 화살표 버튼 -->
					<button class="custom-arrow right-arrow" type="button" data-bs-target="#header-carousel" data-bs-slide="next">
						<span class="arrow-text">▷</span>
					</button>
			
				</div>
			</div>
			<!-- 슬라이드 끝 -->
			<!-- CSS -->
			<style>
			.slide-image-container a {
				display: block;
				width: 100%;
				height: 100%;
			}
			.slide-image-container img {
				display: block;
				width: 100%;
				height: 100%;
				object-fit: cover;
			}
			.custom-arrow {
				position: absolute;
				top: 45%; /* 전체 높이의 45% 지점 */
				transform: translateY(-50%);
				background: transparent !important; /* 완전 투명 배경 */
				border: none !important;
				color: black; /* 검은색 화살표 */
				font-size: 24px;
				font-weight: bold;
				z-index: 10;
				cursor: pointer;
				opacity: 0.8;
				transition: opacity 0.2s;
				width: 50px;
				height: 50px;
				display: flex;
				align-items: center;
				justify-content: center;
			}
			
			/* 클릭, 포커스 시에도 아무 표시 안 나게 */
			.custom-arrow:focus,
			.custom-arrow:active,
			.custom-arrow:focus-visible {
				outline: none !important;
				box-shadow: none !important;
				background: transparent !important;
			}
			
			.custom-arrow:hover {
				opacity: 1;
			}
			
			.left-arrow {
				left: 20px;
			}
			.right-arrow {
				right: 20px;
			}
			
			.arrow-text {
				user-select: none;
				background: none !important;
			}
			</style>
			<!-- 슬라이드 끝 -->

		<!-- Carousel End -->
		<!-- 로그인과 이미지 배너를 그룹으로 묶어서 오른쪽으로 이동 -->
		<div class="col-lg-10" style="margin-top: 400px;">
			<!-- style="margin-top: 400px; 올려서 오버뱁  -->
			<!--   로그인시작  -->
			<div class="login-banner-wrapper" id = "login_form" 
				style="width: 100%; max-width: 1700px; margin: 0 auto; transition: all 0.3s ease;">
				<div class="row ">
					<!-- 로그인 영역 -->

					<div class="container-fluid mb-2" 	id = "login_line" style="padding-left: 150px;">
						<div class="row justify-content-center px-xl-8"	style="flex-wrap: nowrap;">
							<div class="col-lg-auto" style="width: 725px; flex-shrink: 0; min-width: 725px;">
								<div class="contact-form box-p-10 mb-3"
									style="min-height: 220px; background-color: #003366; margin-left: 35px; border-radius: 10px;">
									<form name="loginForm" id="loginForm">
										<div
											style="display: flex; align-items: flex-start; justify-content: center;">
											<!-- 입력 필드 영역 -->
											<div style="flex-grow: 0; width: 280px;">
												<hr
													style="border: none; border-top: 2px solid #aaa; margin: 2px 0; width: 0.8cm;">
												<h6 class="section-title position-relative mb-2">
													<span class="pr-6" style="color: white; font-size: 1.2em;">
														로그인 <small style="font-size: 0.80em; color: white;"></small>
													</span>
												</h6>
												<div class="control-group mb-2">
													<input type="text" class="form-control" id="hospid"
														placeholder="Hospital Number" style="width: 150%;" />
												</div>
												<div class="control-group mb-2">
													<input type="text" class="form-control" id="userid"
														placeholder="User ID" style="width: 150%;" />
												</div>
												<div class="control-group mb-2">
													<input type="password" class="form-control" id="passwd"
														placeholder="PassWord" style="width: 150%;" />
												</div>
												<div class="form-check mb-2"
													style="white-space: nowrap; color: white;">
													<input class="form-check-input" type="checkbox" id="saveyn">
													<span class="form-check-label font-weight-bold"
														for="saveyn" style="font-size: 13px;">아이디저장</span>
												</div>
											</div>

											<!-- 로그인 버튼 + 링크 -->
											<div style="margin-left: 180px; text-align: center;">
												<button type="button" id="blogin" onclick="login()"
													style="height: 120px; width: 120px; background-color: white; color: black; font-weight: bold; border: 1px solid #ccc; border-radius: 10px; font-size: 14px; cursor: pointer; margin-top: 36px; margin-bottom: 5px;">
													로그인</button>
												<div
													style="font-size: 13px; font-weight: bold; color: white;">
													<a href="javascript:void(0);" onclick="fnmbrReg();"
														style="color: white; text-decoration: none;">회원가입</a> | <a
														href="javascript:void(0);" onclick="fnPasswdmanager();"
														style="color: white; text-decoration: none;">ID/PW찾기</a>
												</div>
											</div>
										</div>

										<img src="/wnn_consult/images/winct/loginBg.svg" alt="Login Background"
											class="loginBg">
									</form>

									<!-- 로그인 성공 시 사용자 카드 -->
									<div id="userInfoCard"
										style="display: none; overflow: auto; max-height: 180px;"
										class="mt-2">
										<div class="user_card">
											<div class="user_card-body" style="position: relative;">
												<div
													style="position: relative; display: flex; align-items: center; font-size: 20px; margin-top: -20px; margin-left: -80px;">

													<!-- 병원 이름 + 환영 메시지 그룹 -->
													<div style="display: flex; align-items: center;">
														<h3 id="hosp_name" class="user_card-text"
															style="font-size: 20px; border-bottom: 2px solid #000; margin-top: 16px; margin-left: 50px; padding-bottom: 2px;">
														</h3>
														<span style="margin-left: 10px;">님 환영합니다.</span>
													</div>

													<!-- 마지막 접속시간 고정 영역 -->
													<div
														style="position: absolute; right: 0; font-size: 16px; margin-right: -20px;">
														<strong>마지막접속일자:</strong> <span style="font-size: 14px;"
															id="last_dttm"></span>
													</div>
												</div>

												<div class="title"
													style="margin-top: -5px; margin-left: -30px;">*최근 3개월
													자료 등록현황</div>
												<div
													style="display: flex; justify-content: space-between; align-items: flex-start;">
													<!-- 좌측 input-grid -->
													<div class="input-grid"
														style="margin-top: -10px; margin-left: -30px;">
														<div style="font-size: 13px; font-weight: bold;">업무구분</div>
														<div id="month3"
															style="font-size: 13px; font-weight: bold;"></div>
														<div id="month2"
															style="font-size: 13px; font-weight: bold;"></div>
														<div id="month1"
															style="font-size: 13px; font-weight: bold;"></div>
														<div style="font-size: 13px; font-weight: bold;">경영분석</div>
														<div id="admin_three"
															style="font-size: 12px; font-weight: bold;">-</div>
														<div id="admin_two"
															style="font-size: 12px; font-weight: bold;">-</div>
														<div id="admin_one"
															style="font-size: 12px; font-weight: bold;">-</div>
														<div style="font-size: 13px; font-weight: bold;">적정성평가</div>
														<div id="cost_three"
															style="font-size: 12px; font-weight: bold;">-</div>
														<div id="cost_two"
															style="font-size: 12px; font-weight: bold;">-</div>
														<div id="cost_one"
															style="font-size: 12px; font-weight: bold;">-</div>
													</div>

													<!-- 우측 로그아웃 버튼 -->
													<div style="margin-left: 68px; flex-shrink: 0;">
														<button class="btn btn-warning" onclick="logout()"
															style="min-width: 120px; height: 60px; font-size: 16px;">
															로그아웃</button>
													</div>
												</div>

											</div>
										</div>

									</div>

								</div>
							</div>

							<!-- 이미지 배너 영역  #ccc -->
							<!-- ★ 이미지 버튼 영역: position:relative로 버튼이 이미지 안에 위치하도록 설정 -->
							<div class="image-btn-wrap" style="position: relative; width: 590px; height: 225px; border: 1px solid #999; 
							    border-radius: 12px; overflow: hidden; background-color: #fff; flex-shrink: 0;">
								<img class="img-fluid" src="/wnn_consult/images/winct/e_clip2.svg" alt="e_clip" style="width: 100%; height: 100%; display: block;">
								<button type="button" class="btn overlay-btn overlay-btn-i1" style="left:5%; top:65%; width:35%; height:20%; 
								        background-color:transparent !important;" onclick="winCheckOpen()"></button>
								<a href="/path/to/consulting-intro.pdf" download class="btn overlay-btn overlay-btn-i4 program-button" 
								         style="left:62%; top:30%; width:30%; height:14%; background-color:transparent !important;" onclick="downloadFile()"></a>
								<a href="https://winner797.net/" target="_blank" rel="noopener noreferrer" class="btn overlay-btn overlay-btn-i5 program-button" 
								         style="left:62%; top:76%; width:30%; height:14%; background-color:transparent !important;"></a>
							</div>
						</div>

					<!--  공지사항   -->
					<div class="row justify-content-center noti-section"
						style="flex-wrap: nowrap; visibility: hidden;">
						<div class="col-lg-auto" style="width: 725px; flex-shrink: 0; min-width: 725px;">
							<div class="bg-light box-p-10" style="height: 220px; margin-left: 35px; border: 1px solid #ccc; border-radius: 8px;">
								<!-- 탭 헤더 -->
								<div class="nav nav-tabs mb-1 border-bottom border-black d-flex">
									<a
										class="nav-item nav-link active px-4 py-2 fw-bold text-dark text-center flex-fill"
										data-bs-toggle="tab" href="#tab-pane-1">전체 </a> <a
										class="nav-item nav-link px-4 py-2 fw-bold text-muted text-center flex-fill"
										data-bs-toggle="tab" href="#tab-pane-2">공지사항 </a> <a
										class="nav-item nav-link px-4 py-2 fw-bold text-muted text-center flex-fill"
										data-bs-toggle="tab" href="#tab-pane-3">심사방 </a> <a
										class="nav-item nav-link px-4 py-2 fw-bold text-muted text-center flex-fill"
										data-bs-toggle="tab" href="#tab-pane-4">소식지 </a>
								</div>

								<!-- 탭 콘텐츠 -->
								<div class="tab-content">
									<!-- 전체 -->
									<div class="tab-pane fade active show" id="tab-pane-1">
										<div class="scroll-table-container"
											style="max-height: 130px; overflow-y: auto;">
											<table class="notice-table table table-bordered" id="noticeTable" style="font-size: 14px;">
												<colgroup>
													<col style="width: 100px"> 
												    <col style="width: 350px"> 
													<col style="width: 120px">
													<col style="width: 10px">
												</colgroup>
												<tbody id="noticeArea">
													<tr>
														<td colspan="4" style="font-weight: bold;">&nbsp;</td>
													</tr>
												</tbody>
											</table>
										</div>
									</div>
									<!-- 공지사항 -->
									<div class="tab-pane fade" id="tab-pane-2">
										<div class="scroll-table-container"
											style="max-height: 130px; overflow-y: auto;">
											<table class="notice-table table table-bordered" id="noticeTable1" style="font-size: 14px;">
												<colgroup>
													<col style="width: 100px"> 
												    <col style="width: 350px"> 
													<col style="width: 120px">
													<col style="width: 10px">
												</colgroup>
												<tbody id="noticeArea1">
													<tr>
														<td colspan="4" style="font-weight: bold;">&nbsp;</td>
													</tr>
												</tbody>
											</table>
										</div>
									</div>
									<!-- 심사방 -->
									<div class="tab-pane fade" id="tab-pane-3">
										<div class="scroll-table-container"
											style="max-height: 130px; overflow-y: auto;">
											<table class="notice-table table table-bordered" id="noticeTable2" style="font-size: 14px;">
												<colgroup>
													<col style="width: 100px"> 
												    <col style="width: 350px"> 
													<col style="width: 120px">
													<col style="width: 10px">
												</colgroup>
												<tbody id="noticeArea2">
													<tr>
														<td colspan="4" style="font-weight: bold;">&nbsp;</td>
													</tr>
												</tbody>
											</table>
										</div>
									</div>

									<!-- 소식지 -->
									
									<div class="tab-pane fade" id="tab-pane-4">
										<div class="scroll-table-container"
											style="max-height: 130px; overflow-y: auto;">
											<table class="notice-table table table-bordered" id="noticeTable3" style="font-size: 14px;">
												<colgroup>
													<col style="width: 100px"> 
												    <col style="width: 350px"> 
													<col style="width: 120px">
													<col style="width: 10px">
												</colgroup>
												<tbody id="noticeArea3">
													<tr>
														<td colspan="4" style="font-weight: bold;">&nbsp;</td>
													</tr>
												</tbody>
											</table>
										</div>
									</div>
									
								</div>
							</div>
						</div>

						
						
						
						<!-- ★ 이미지 버튼 영역: position:relative로 버튼이 이미지 안에 위치하도록 설정 -->
						<div class="image-btn-wrap" style="position: relative; width: 590px; height: 220px; border: 1px solid #999; border-radius: 12px; overflow: hidden; background-color: #fff; flex-shrink: 0;">
							<img class="img-fluid" src="/wnn_consult/images/winct/e_clip3.svg" alt="e_clip" style="width: 100%; height: 100%; display: block;">
							<button type="button" class="btn overlay-btn overlay-btn-i6" style="left:54%; top:10%; width:44%; height:40%; background-color:transparent !important;" onclick="fnasq_main()"></button>
							<button type="button" class="btn overlay-btn overlay-btn-i7" style="left:54%; top:54%; width:44%; height:38%; background-color:transparent !important;" onclick="loadFaqData()"></button>
						</div>			
					</div>
				</div>
			</div>

			</div>
			<!-- 오른쪽 소셜 아이콘 박스 -->
			<div class="d-flex justify-content-center w-100 mt-2">
				<div class="social-box">
					<ul>
						<li><a href="https://www.youtube.com/@winnernet797"
							target="_blank" rel="noopener noreferrer"> <img
								src="/wnn_consult/images/winct/youtube.svg" alt="유튜브" class="snsImg">
								<span>유튜브</span>
						</a></li>
						<li><a href="https://blog.naver.com/ewinner7"
							target="_blank" rel="noopener noreferrer"> <img
								src="/wnn_consult/images/winct/blog.svg" alt="블로그" class="snsImg"> <span>블로그</span>
						</a></li>
						<!--  
						<li><a href="https://open.kakao.com/o/gBvFxyYg"
							target="_blank" rel="noopener noreferrer"> <img
								src="/wnn_consult/images/winct/kakao.png" alt="카카오톡" class="snsImg"> <span>카카오톡</span>
						</a></li>
						-->
					</ul>
					<img src="/wnn_consult/images/winct/quickArrow.svg" alt="더보기"
						class="quick-arrow-btn" style="width: 34px; height: auto;">
				</div>
			</div>
			<!-- 오른쪽 소셜 아이콘 박스 -->
		</div>
		<!-- 하단 간격 유지안함  컨설팅소개서 여기까지 덮는다 -->
	</div>
	<!--  공공기관 포털   -->
	<div class="bmenu">
	    <div class="row m-0"> 
	        <div class="col-lg-12 p-0" style="background-color: #004080;"> 
	            <nav class="navbar navbar-expand-lg navbar-dark py-3 py-lg-0 px-0">
	                <div class="collapse navbar-collapse">
	                    <div class="navbar-nav d-flex justify-content-center w-100 py-0">
	                        <a href="https://winner797.kr/main/"           class="nav-item nav-link" target="_blank">위너넷 평생교육원</a> 
	                        <a href="https://winner797.net/"               class="nav-item nav-link" target="_blank">위너넷 온라인교육센터</a> 
	                        <a href="https://www.hirachung.co.kr/"         class="nav-item nav-link" target="_blank">한국보험의료인증원</a> 
	                        <a href="https://www.nhis.or.kr/nhis/index.do" class="nav-item nav-link" target="_blank">건강보험공단</a> 
	                        <a href="https://www.hira.or.kr"               class="nav-item nav-link" target="_blank">건강보험심사평가원</a>
	                        <a href="https://biz.hira.or.kr/index.do"      class="nav-item nav-link" target="_blank">요양기관업무포탈</a>
	                    </div>
	                </div>
	            </nav>
	        </div>
	    </div>
	</div>
    <!--    메인화면 끝  -->
    
	<!--회원가입 모달창   -->
	<div id="mainModal" class="modal fade" tabindex="-1" data-backdrop="static"
		data-keyboard="false" aria-hidden="true" role="dialog">
		<div class="modal-dialog modal-dialog-centered modal-dialog-scrollable" role="document"
			style="max-width: 600px;">
			<div class="modal-content rounded-3 shadow-lg">
				<div class="modal-header bg-light">
						<h5 class="modal-title">회원등록</h5> 
						<!-- 필수 입력 안내 -->
						<div class="px-3 pt-2" style="font-size: 0.8rem; color: #666;">
						    <span style="color: red;">*</span> 는 필수 입력 항목입니다.
						</div>
						<div class="form-row">
							<div class="col-sm-12 mb-2" style="text-align: right;">
								<button type="submit" class="btn btn-outline-dark rounded px-2 py-1"
									onClick="fnSaveProc('I')">
									회원가입 <i class="far fa-edit"></i>
								</button>
								<button type="button" class="btn btn-outline-dark rounded px-2 py-1"
									data-dismiss="modal" onClick="mainModalClose()">
									닫기. <i class="fas fa-times"></i>
								</button>
							</div>
						</div>
				</div>
				<div class="modal-body">
					<form id="memregForm" name="memregForm" method="post">
						<input type="hidden" name="iud" id="iud" />
						<!-- 병원 코드 -->
						<div class="mb-3">
							<label for="hospCd" class="form-label" style="font-size: 0.9rem;"> 병원코드 <span style="color: red;"> *</span></label>
							<div class="input-group">
								<input id="hospCd" name="hospCd" type="text" class="form-control"
									placeholder="병원코드를 입력하고 enter key를 치세요 ">
								<button class="btn btn-outline-dark rounded px-2 py-1" type="button" onclick="fnDupchk()">
									<i class="fas fa-search"></i> 기관체크
								</button>
							</div>
						</div>
						<!-- 병원명 -->
						<div class="mb-3">
							<label for="hospNm" class="form-label" style="font-size: 0.9rem;">병원명 <span style="color: red;"> *</span></label>
							<div class="input-group">
								<input id="hospNm" name="hospNm" type="text" class="form-control"
									placeholder="병원명을 입력하세요">
								<button class="btn btn-outline-dark rounded px-2 py-1" type="button" id="hospserch" style="display: none;">
									<i class="fas fa-search"></i> 병원검색
								</button>
							</div>
						</div>
						<div class="mt-2" style="font-size: 0.8rem; padding-left: 2px;">
						    <span id="cont_name" style="color: blue;"></span>
						    <span id="cont_startDt"></span>
						    <span id="cont_endDt"></span>
						    <span id="cont_name1"style="color: blue;"></span>
						    <span id="cont_startDt1"></span>
						    <span id="cont_endDt1"></span>
						</div>						
						
						<!-- 이메일 -->
						<div class="mb-3">
							<label for="email" class="form-label" style="font-size: 0.9rem;">이메일 <span style="color: red;"> *</span></label>
							<div class="input-group">
								<input id="email" name="email" type="text" class="form-control"
									placeholder="이메일 주소를 입력하세요">
								<select id="emailList" name="emailList" class="form-select ms-2" onchange="emailcheck()">
									<option value="">선택</option>
									<c:forEach var="result" items="${commList}">
										<option value="${result.subCode}">${result.subCodeNm}</option>
									</c:forEach>
								</select>
							</div>
						</div>
	
						<!-- 비밀번호 -->
						<div class="row g-2 mb-3">
							<div class="col">
								<label for="passWd" class="form-label" style="font-size: 0.9rem;" >비밀번호 <span style="color: red;"> *</span></label>
								<input type="password" id="passWd" name="passWd" class="form-control">
							</div>
							<div class="col">
								<label for="afPassWd" class="form-label" style="font-size: 0.9rem;" >비밀번호확인 <span style="color: red;"> *</span></label>
								<input type="password" id="afPassWd" name="afPassWd" class="form-control">
							</div>
						</div>
	
						<!-- 담당자 -->
						<div class="row g-2 mb-3">
							<div class="col">
								<label for="mbrNm" class="form-label" style="font-size: 0.9rem;" >담당자명 <span style="color: red;"> *</span></label>
								<input type="text" id="mbrNm" name="mbrNm" class="form-control">
							</div>
							<div class="col">
								<label for="mbrTel" class="form-label" style="font-size: 0.9rem;" >전화번호 <span style="color: red;"> *</span></label>
								<input type="text" id="mbrTel" name="mbrTel" class="form-control">
							</div>
						</div>
	
						<!-- 약관 동의 -->
						<div class="mt-4">
							<div class="form-check mb-2">
								<input type="checkbox" id="allAgree" class="form-check-input" onclick="toggleAllAgreement()">
								<span class="form-check-label">모두 동의합니다</span>
							</div>
						
							<div class="d-flex justify-content-between align-items-center mb-2">
								<div class="form-check">
									<input type="checkbox" id="peruseyn" name="peruseyn" class="form-check-input agreement-checkbox" onchange="checkAction()">
									<span class="form-check-label">이용약관 동의 <span style="color: red;"> *</span></span>
								</div>
								<button class="btn btn-outline-dark rounded px-2 py-1" type="button"
									onclick="openModal('이용약관 동의','PER_USE_CD')">세부확인</button>
							</div>
						
							<div class="d-flex justify-content-between align-items-center mb-2">
								<div class="form-check">
									<input type="checkbox" id="perinfoyn" name="perinfoyn" class="form-check-input agreement-checkbox" onchange="checkAction()">
									<span class="form-check-label">개인정보 수집 및 이용 <span style="color: red;"> *</span></span>
								</div>
								<button class="btn btn-outline-dark rounded px-2 py-1" type="button"
									onclick="openModal('개인정보 수집 및 이용 동의','PER_INFO_CD')">세부확인</button>
							</div>
						
							<div class="d-flex justify-content-between align-items-center">
								<div class="form-check">
									<input type="checkbox" id="perproyn" name="perproyn" class="form-check-input agreement-checkbox" onchange="checkAction()">
									<span class="form-check-label">개인정보 처리위탁 동의 <span style="color: red;"> *</span></span>
								</div>
								<button class="btn btn-outline-dark rounded px-2 py-1" type="button"
									onclick="openModal('개인정보 처리위탁 동의','PER_PRO_CD')">세부확인</button>
							</div>
						</div>
	
					</form>
				</div>
			</div>
		</div>
	</div>
	
	
	<div class="overlay_1" id="overlay_1" onclick="closePopup_1()"></div>
	<div class="popup-box_1" id="popupBox_1">
	  	<div class="popup-close_1" onclick="closePopup_1()">
	    	<span class="close-text_1">닫기</span>
	  	</div>
	  	<img id="popupImg_1" src="" alt="팝업 이미지">
	</div>

	<!-- Modal 동의서 확인 -->
	<div id="termsModal" class="modal fade" data-backdrop="static"
		data-keyboard="false" tabindex="-1" role="dialog" aria-hidden="true">
		<div class="modal-dialog modal-lg" style="max-width: 700px;">
			<div class="modal-content rounded-3 shadow-lg"
				style="height: 90%; display: flex; flex-direction: column;">
	
				<!-- Header -->
				<div class="modal-header bg-light border-bottom">
					<h5 class="modal-title w-100 text-center" id="modalname" style="color: #333;"></h5>
				</div>
	
				<!-- Body -->
				<div class="modal-body" style="flex-grow: 1; overflow-y: auto;">
					<input type="hidden" name="codeCd" id="codeCd" />
					<textarea class="form-control" aria-label="동의서 내용"
						name="subCodeNm" id="subCodeNm"
						style="width: 100%; height: 100%; font-size: 14px; resize: none;"></textarea>
				</div>
	
				<!-- Footer -->
				<div class="modal-footer justify-content-center">
					<button class="btn btn-outline-dark rounded px-4 py-2 btn-sm"
						onclick="confirmAction()" style="min-width: 120px;">
						확인
					</button>
				</div>
			</div>
		</div>
	</div>
	<a href="#" class="back-to-top" id="btnTop">
	  <i class="fas fa-arrow-up"></i><br>TOP
	</a>
	
	
	<script>
	
   //계약관련 메뉴설정체크 A. 전체 1.적정성 2. 진료비분석 
	function hosp_conact() {
		    let s_conact_gb = getCookie("s_conact_gb");
		    let s_wnn_yn    = getCookie("s_wnn_yn");
		
		    // 💡 먼저 기존 메뉴 초기화 (중복 방지)
		    let menuArea   = document.getElementById("dynamicMenu_J");
		    let menuArea_T = document.getElementById("dynamicMenu_T");
		
		    if (menuArea)   menuArea.innerHTML   = '';    // 기존 내용 제거
		    if (menuArea_T) menuArea_T.innerHTML = ''; // 기존 내용 제거
		
		    let menuHTML = '';
		    let menuHTML_T = '';
		
		    if (s_conact_gb === 'A' || s_wnn_yn === 'Y') {
		        menuHTML += `
		            <a href="#" class="nav-link consulting-menu" style="font-size: 16px; padding: 24px;">
		                적정성평가
		            </a>
		        `;
		        menuHTML_T += `
		            <a href="#" class="nav-link consulting-menu" style="font-size: 16px;  padding: 24px;">
		                진료비분석
		            </a>
		        `;
		    } else if (s_conact_gb === '1') {
		        menuHTML += `
		            <a href="#" class="nav-link  consulting-menu" style="font-size: 16px;  padding: 24px;">
		                진료비분석
		            </a>
		        `;
		    } else if (s_conact_gb === '2') {
		        menuHTML += `
		            <a href="#" class="nav-link  consulting-menu" style="font-size: 16px;  padding: 24px;">
		                적정성평가
		            </a>
		        `;
		    }
	    // 삽입
		    if (menuArea) menuArea.insertAdjacentHTML("beforeend", menuHTML);
		    if (menuArea_T) menuArea_T.insertAdjacentHTML("beforeend", menuHTML_T);
		}
       function setActive(element) {
    	    // 드롭다운 항목에서 active 클래스 제거
    	    document.querySelectorAll('.dropdown-item').forEach(item => {
    	        item.classList.remove('active');
    	    });

    	    // 클릭한 항목에 active 클래스 추가
    	    element.classList.add('active');
       } 
       function setMainActive(element) {
    	    // 기존 모든 주메뉴에서 active 클래스 제거
    	    document.querySelectorAll('.consulting-menu').forEach(item => {
    	        item.classList.remove('active');
    	    });

    	    // 현재 클릭한 주메뉴에 active 클래스 추가
    	    element.classList.add('active');
    	}     
        
        
        
	    // 공지사항 정렬 함수
	    function alignNotiToLogin() {
	        var allRows = document.querySelectorAll('#login_line > .row');
	        if (allRows.length < 2) return;
	        var loginBox = allRows[0].querySelector('.contact-form');
	        if (!loginBox) return;
	        var notiRow = allRows[1];
	        var notiBox = notiRow.querySelector('.bg-light');
	        if (!notiBox) return;
	        // 초기화 후 측정
	        notiRow.style.justifyContent = 'flex-start';
	        notiRow.style.paddingLeft = '0px';
	        notiRow.offsetHeight;
	        var loginLeft = loginBox.getBoundingClientRect().left;
	        var notiLeft = notiBox.getBoundingClientRect().left;
	        var diff = loginLeft - notiLeft;
	        if (diff > 0) {
	            notiRow.style.paddingLeft = diff + 'px';
	            notiRow.offsetHeight;
	            // 2차 보정
	            var newLeft = notiBox.getBoundingClientRect().left;
	            var remain = loginLeft - newLeft;
	            if (Math.abs(remain) > 0.5) {
	                notiRow.style.paddingLeft = (diff + remain + 75) + 'px';
	            }
	        }
	        notiRow.style.visibility = 'visible';
	    }

	    // 페이지가 로드될 때마다 현재 페이지를 세션 저장소에 기록
	    window.addEventListener('load', function() {
	    	sessionStorage.setItem("previousPage", window.location.href);
	        alignNotiToLogin();
	    });

	    // 해상도/줌 변경 시 재정렬
	    var resizeTimer;
	    window.addEventListener('resize', function() {
	        clearTimeout(resizeTimer);
	        resizeTimer = setTimeout(alignNotiToLogin, 50);
	    });
	    /*
	    document.addEventListener("DOMContentLoaded", function() {
	        var myCarousel = new bootstrap.Carousel(document.querySelector("#header-carousel"), {
	            interval: 2000, // 4초마다 변경
	            ride: "carousel"
	        });
	    });  */
	//컨설팅소개서 다운로드
	function downloadFile() {
		const filePath = "/home/winner/upload/consulting-intro.jpg"; // 실제 SFTP 경로
		const encodedPath = encodeURIComponent(filePath);
		window.location.href = "/wnn_consult/sftp/download.do?filePath=" + encodedPath;
		// 기본 링크 다운로드 방지 (선택사항)
		event.preventDefault(); // 이 줄을 넣으면 href로 다운로드되지 않고 SFTP만 사용됨
	}
	document.querySelectorAll('.nav-tabs .nav-link').forEach(function(tab) {
	    tab.addEventListener('click', function () {
	        document.querySelectorAll('.nav-tabs .nav-link').forEach(function(t) {
	            t.classList.remove('text-dark');
	            t.classList.add('text-muted');
	        });
	        this.classList.remove('text-muted');
	        this.classList.add('text-dark');
	    });
	});
 	<!-- 타jsp화면을 주메뉴에 가져와서 화면에 뿌리주는 기능  -->
	function loadPage(pageUrl) {
		console.log("✅ 페이지 로드 완료: " + pageUrl);

	    // 기존 컨테이너 숨기기
	    $(".container-fluid").hide();  // 기존 요소 숨기기
	    $(".login-banner-wrapper").hide();  // 기존 요소 숨기기
	    $(".noti-section").hide();  // 기존 요소 숨기기
	    
        fetch(pageUrl)
	        .then(response => response.text())
	        .then(data => {
	            let contentArea = document.getElementById("contentArea");
	            contentArea.style.display = "block";

	            // 기존 내용 초기화 후 새로운 내용 추가
	            contentArea.innerHTML = "";
	            contentArea.innerHTML = data;

	            console.log("✅ 페이지 로드 완료: " + pageUrl);

	            // 첫 번째 탭 강제 선택 (기본값: sub-tab1)
	            let firstTab = document.querySelector(".stab-menu a");
	            let activeTab = "#sub-tab1";  // 항상 첫 번째 탭을 기본값으로 설정

	            console.log("✅ 활성화할 탭:", activeTab);

	            sessionStorage.setItem("activeTab", activeTab); // 저장된 값 업데이트

	            // 모든 탭 비활성화 후 기본 탭 활성화
	            document.querySelectorAll(".stab-menu a").forEach(tab => {
	                tab.classList.remove("active");
	                if (tab.getAttribute("href") === activeTab) {
	                    tab.classList.add("active");
	                }
	            });

	            // 모든 탭 컨텐츠 비활성화 후 기본 탭 활성화
	            document.querySelectorAll(".tab-pane").forEach(pane => {
	                pane.classList.remove("show", "active");
	            });

	            let activeContent = document.querySelector(activeTab);
	            if (activeContent) {
	                activeContent.classList.add("show", "active");
	            }

	            // **Bootstrap 탭 강제 실행 (Bootstrap 5)**
	            let activeTabElement = document.querySelector(`a[href="${activeTab}"]`);
	            if (activeTabElement) {
	                var tabInstance = new bootstrap.Tab(activeTabElement);
	                tabInstance.show();
	                console.log("✅ Bootstrap 탭 강제 실행됨");
	            }

	            // 🚀 **탭 클릭 이벤트 재설정**
	            document.querySelectorAll('a[data-bs-toggle="tab"]').forEach(tab => {
	                tab.addEventListener('click', function (event) {
	                    event.preventDefault();
	                    let targetTab = tab.getAttribute("href");

	                    console.log("✅ 사용자 탭 선택: " + targetTab);

	                    sessionStorage.setItem("activeTab", targetTab);
	                    
	                    // 기존의 active 상태 초기화
	                    document.querySelectorAll(".stab-menu a").forEach(t => t.classList.remove("active"));
	                    tab.classList.add("active");

	                    // 기존의 tab-pane 내용 제거 후 새로운 탭 활성화
	                    document.querySelectorAll(".tab-pane").forEach(pane => pane.classList.remove("show", "active"));
	                    let targetContent = document.querySelector(targetTab);
	                    if (targetContent) {
	                        targetContent.classList.add("show", "active");
	                    }
	                });
	            });
	        })
	        .catch(error => console.error('❌ 페이지 로딩 오류:', error));
	}
	document.addEventListener("DOMContentLoaded", function() {
	    let contentArea = document.getElementById("contentArea");
	    let consultingTitle = document.getElementById("consultingTitle");

	    function goBackOrRedirect() {
	        const previousPage = sessionStorage.getItem("previousPage");
	        
	        if (previousPage && previousPage !== window.location.href) {
	            history.replaceState(null, "", previousPage);
	            location.reload();
	        } else {
	        	history.replaceState(null, "", "/wnn_consult/login.do");
	            location.reload();
	        }
	    }

	    window.addEventListener("beforeunload", function() {
	        sessionStorage.setItem("previousPage", window.location.href);
	    });

	    function adjustLayout() {
	        requestAnimationFrame(() => {
	            if (contentArea.innerHTML.trim() !== "") { 
	                let contentHeight = contentArea.offsetHeight;
	                let windowHeight = window.innerHeight;

	                if (contentHeight < windowHeight * 0.8) {
	                    contentArea.style.minHeight = (windowHeight * 0.8) + "px";
	                }

	                let dynamicMargin = Math.max(50, contentArea.offsetHeight * 0.1);

	                consultingTitle.onclick = function(event) {
	                    event.preventDefault();
	                    setTimeout(() => {
	                        goBackOrRedirect();
	                    }, 50);
	                };
	            } else {
	                contentArea.style.minHeight = "0px";
	                contentArea.style.display = "none";
	                consultingTitle.onclick = null;
	            }
	        });
	    }

	    adjustLayout();

	    let observer = new MutationObserver(() => requestAnimationFrame(adjustLayout));
	    observer.observe(contentArea, { childList: true, subtree: true });

	    window.addEventListener("resize", () => requestAnimationFrame(adjustLayout));
	});

	//마우스희 제동 
	document.addEventListener("DOMContentLoaded", function () {
	    let tableContainer = document.querySelector(".table-responsive");

	    tableContainer.addEventListener("wheel", function (event) {
	        let isScrollable = tableContainer.scrollHeight > tableContainer.clientHeight;

	        if (isScrollable) {
	            let atTop = tableContainer.scrollTop === 0;
	            let atBottom = tableContainer.scrollTop + tableContainer.clientHeight >= tableContainer.scrollHeight;

	            if ((atTop && event.deltaY < 0) || (atBottom && event.deltaY > 0)) {
	                event.preventDefault();
	            }
	        }
	    }, { passive: false });
	});	

   </script>

	<!-- 회원가입 스크립트 시작 -->
	<script>	
		    /*회원가입*/ 
		    function fnmbrReg(){
		    	 const ids = ['cont_name', 'cont_startDt', 'cont_endDt', 'cont_name1', 'cont_startDt1', 'cont_endDt1'];
		    	 ids.forEach(id => {
		    	   const el = document.getElementById(id);
		    	   if (el) el.textContent = '';  // 초기값 설정
		    	 });
		    	document.getElementById('memregForm').reset();
		        // 모달 표시
		        $('#mainModal').modal('show');
		        // 배경 흐리게 처리
		        $('body').append('<div id="overlay"></div>');
		      
		        // 모달이 닫힐 때 오버레이 제거
		        $('#mainModal').on('hidden.bs.modal', function () {
		            $('#overlay').remove();
		        });
		    }
		 // 전체 동의/해제 기능
		    function toggleAllAgreement() {
		    	const isChecked = document.getElementById('allAgree').checked;
		    	document.querySelectorAll('.agreement-checkbox').forEach(function(checkbox) {
		    		checkbox.checked = isChecked;
		    	});
		    	checkAction();
		    }

		    // 개별 체크박스 상태 변경 시 전체 동의 체크 여부 갱신
		    function checkAction() {
		    	const perUseYn = document.getElementById("peruseyn").checked ? "Y" : "N";
		    	const perInfoYn = document.getElementById("perinfoyn").checked ? "Y" : "N";
		    	const perProYn = document.getElementById("perproyn").checked ? "Y" : "N";

		    	$("#perUseYn").val(perUseYn);
		    	$("#perInfoYn").val(perInfoYn);
		    	$("#perProYn").val(perProYn);

		    	// 전체 동의 체크 여부 자동 반영
		    	const allChecked = document.querySelectorAll('.agreement-checkbox:checked').length === document.querySelectorAll('.agreement-checkbox').length;
		    	document.getElementById('allAgree').checked = allChecked;
		    }
	        function confirmAction() {
	        	$("#perUseRed").val(confirm_red[0]);
	        	$("#perInfoRed").val(confirm_red[1]);
	        	$("#perProRed").val(confirm_red[2]);
	        	closeModal() ;
	        }
       
	        function fnSaveProc(iud) {
	            // iud 값 설정
	            $("#iud").val(iud);

	        	if($("#hospCd").val() == ""){
	        		messageBox("1","<h6>요양기관기호를 확인하세요.!!</h6><p></p>","hospCd","","");
	        		return;
	        	}  
	        	if($("#hospNm").val() == ""){
	        		messageBox("1","<h6>요양기관명을 확인하세요.!!</h6><p></p>","hospNm","","");
	        		return;
	        	}
	        	if($("#mbrNm").val() == ""){
	        		messageBox("1","<h6>담당자명을 확인하세요.!!</h6><p></p>","mbrNm","","");
	        		return;
	        	}
	        	if($("#mbrTel").val() == ""){
	        		messageBox("1","<h6>담당전화를 확인하세요.!!</h6><p></p>","mbrTel","","");
	        		return;
	        	}
	        	if($("#email").val() == ""){
	        		messageBox("1","<h6>'이메일를 확인하세요.!!</h6><p></p>","email","","");
	        		return;
	        	}

	            // 중복 체크 값 미확인 여부 확인 (중복체크 결과를 변수에 저장)
	            const dupchkVal = $("#dupchk").val();
	            if (dupchkVal === "Y" || dupchkVal === "X") {
	                messageBox("1", "<h6>중복체크 여부를 확인하세요.!</h6><p></p>", "", "", "");
	                return;
	            }

	            // 비밀번호 입력 및 일치 여부 체크
	            const passWd = $("#passWd").val();
	            const afPassWd = $("#afPassWd").val();
	            if (passWd === "" || afPassWd === "") {
	                messageBox("1", "<h6>비밀번호를 입력하세요.!!</h6><p></p>", "passWd", "", "");
	                return;
	            }
	            if (passWd.length < 4) {
	                messageBox("1", "<h6>비밀번호는 4자 이상이어야 합니다.!!</h6><p></p>", "passWd", "", "");
	                return;
	            }
	            if (passWd !== afPassWd) {
	                messageBox("1", "<h6>비밀번호가 상호 상이합니다.!</h6><p></p>", "afPassWd", "", "");
	                return;
	            }

	         // 약관 동의 여부 체크
				const terms = ['peruseyn', 'perinfoyn', 'perproyn'];
				for (let term of terms) {
				    const checkbox = document.getElementById(term);
				    if (!checkbox || !checkbox.checked) {
				        messageBox("1", "<h6>전체 약관동의를 하여야 합니다!</h6><p></p>", "", "", "");
				        return;
				    }
				}

	        	$("#perUseCd").val("PER_USE_CD") ;
	        	$("#perInfoCd").val("PER_INFO_CD") ;
	        	$("#perProCd").val("PER_PRO_CD") ;
	        	let trimmedEmail = $("#email").val().trim();
	        	$("#email").val(trimmedEmail);
	        	var formData = $("form[name='memregForm']").serialize() ;
	        	if (!confirm("회원가입 하시겠습니다?")) {
	                return;  
	            }
        	
	        	$.ajax( {
	        		type : "post" ,                      
	        		url  : "${pageContext.request.contextPath}" + "/user/MemberSaveAct.do",
	        		data : formData,
	        		dataType : "json",
	        		success : function(data) {    
	        			if(data.error_code != "0") {
	        			   alert(data.error_msg);
	        			   return;
	        			}else{
	        		 	   modalClose();
	                    }
	        		}	
	        	});
	        	mainModalClose() ;
	        }
	        function fnDupchk(){
	        	if($("#hospCd").val() == ""){ 
	              messageBox("1","<h6>병원정보를 입력하세요.!!</h6><p></p>","hospCd","","");
	              return; 
	        	}
	        	let email = $("#email").val().trim();

	        	if (email === "") {
	        	    messageBox("1", "<h6>이메일 정보를 입력하세요.!!</h6><p></p>", "email", "", "");
	        	    return;
	        	}
	        	$.ajax( {
	        		type : "post",
	        		url :  "${pageContext.request.contextPath}" + "/user/MberDupChk.do",
	        		data : {hospCd : $("#hospCd").val(),email : $("#email").val()},
	        		dataType : "json",
	        		success : function(data) {    
	        			if(data.error_code != "0") return;
	        			if(data.dupchk == "Y"){  
	        				messageBox("1","<h6>해당 코드정보는 이미 존재하는 코드입니다.!!</h6><p></p>","","","");
	        				$("#hospCd").val("");
	        				$("#hospNm").val("");
	        				$("#hospCd").focus();
	        				$("#dupchk").val("Y");
	        				return;
	        			}
	        			messageBox("1","<h6>사용 가능한 코드 정보입니다.!!</h6><p></p>","","","");
	        			$("#dupchk").val("N");
	        		}
	        	});
	        }
	        // 동의 세부 확인 모달 열기
	        function openModal(headerValue , codeCd) {
	            $('#termsModal').modal('show');
	        	const modalName = document.getElementById('modalname');
	            modalName.textContent = "(필수)" + headerValue; 
	            $.ajax( {
	        		url : "${pageContext.request.contextPath}" + "/base/ctl_selCommDtlInfo.do",
	        		type : "post",
	        		data : {codeCd : codeCd},
	        		dataType : "json",
	        		success : function(data) {    
	        			if(data.error_code != "0") {
	        				alert(data.error_msg);
	        				return;
	        			}
	        			var dataTxt = "";

	        			for (var i = 0; i < data.resultCnt; i++) {
	        				dataTxt += data.resultList[i].subCodeNm
	        			}	
	        			$("#subCodeNm").val(dataTxt);
	        		}
	        	});
	            
	            switch(codeCd){
	        	    case "perUseCd":
	        	    	confirm_red[0] = 'Y'; // 배열에 '1' 추가
	        	    	break;
	        	    case "perInfoCd" :
	        	    	confirm_red[1] = 'Y'; // 배열에 '1' 추가
	        	    	break ;   	
	        	    case "perProCd" :
	        	    	confirm_red[2] = 'Y'; // 배열에 '1' 추가
	        	    	break ;  
	        	    default:
	        	    	break ;  
	            } 
	            modal.style.display = "flex";
	            modal.style.justifyContent = "center";
	            modal.style.alignItems = "center";
	        }

	        // 모달 닫기
	        function closeModal() {
	            $('#termsModal').modal('hide');
	        }
	        function mainModalClose() {
	            $('#mainModal').modal('hide');
	        }	
	         function emailcheck() {
	             // 이메일 도메인 선택 시
	             const emailField = document.getElementById('email');
	             const emailList  = document.getElementById('emailList');

	             // 이메일 도메인 리스트 변경 이벤트 처리
	             emailList.addEventListener('change', function() {
	                 const email = emailField.value.split('@')[0]; // '@' 앞부분만 추출
	                 const selectedDomain = this.value;

	                 // 이메일 입력이 있고, 도메인 리스트에서 선택된 도메인이 있다면, 이메일 필드를 업데이트
	                 if (selectedDomain && email) {
	                     emailField.value = email + "@" + selectedDomain;
	                 } else if (selectedDomain && !email) {
	                     // 이메일 입력이 없으면 기본 'user@domain' 형태로 입력
	                     emailField.value = "user@" + selectedDomain;
	                 }
	                 emailField.dispatchEvent(new Event('input'));
	             });

	             // 사용자가 이메일을 입력할 때, '@' 이후의 도메인을 자동으로 선택하는 기능
	             emailField.addEventListener('input', function() {
	                 const email = emailField.value;
	                 const domainList = emailList;

	                 // '@'가 포함되면 이메일 도메인 선택을 초기화
	                 if (email.includes('@')) {
	                     const domain = email.split('@')[1];  // 이메일 '@' 이후의 부분을 추출
	                     // 이메일의 도메인이 변경되면 이메일 리스트의 도메인도 변경
	                     if (domain !== domainList.value) {
	                         domainList.value = domain || ''; // 도메인 리스트에서 해당 도메인을 선택
	                     }
	                 }
	             });

	             // 페이지 로드 후 즉시 emailcheck을 적용하여 첫 선택 시부터 동작하도록 처리
	             const emailValue = emailField.value;
	             const selectedDomain = emailList.value;

	             if (emailValue && selectedDomain) {
	                 // 이메일 입력이 있을 때, 도메인 리스트가 선택되어 있으면 이메일 필드를 업데이트
	                 emailField.value = emailValue.split('@')[0] + '@' + selectedDomain;
	             } else if (!emailValue && selectedDomain) {
	                 // 이메일이 비어있고 도메인이 선택되었으면 기본 'user@domain' 형태로 이메일 업데이트
	                 emailField.value = "user@" + selectedDomain;
	             }
	         }

	         // 페이지 로드 후 emailcheck() 함수 호출	        
	</script>
	<!-- 회원가입 스크립트 종료 -->
	<!--아이디찾기  -->

	<div class="modal fade" id="passserachModal" tabindex="-1"
		data-bs-backdrop="static" data-bs-keyboard="false" aria-hidden="true">
		<div class="modal-dialog modal-lg" style="max-width: 500px; margin-top: 50px;">
			<div class="modal-content rounded-3 shadow-lg" style="min-height: 300px; padding: 20px;">
				<form:form commandName="DTO" id="pwserchregForm" name="pwregForm" method="post">
					<h3 class="text-center">아이디찾기 비밀번호 초기화</h3>
					<div class="pass-box w-70">
						<input type="text" name="userNm1" class="form-control mt-2"	id="userNm1" placeholder="사용자성명" /> 
						<input type="text" name="email1" class="form-control mt-2"  id="email1"  placeholder="사용자이메일" />
						<h11 style="font-size: 12px; color: #555;"> 아이디를 찾기 위해서 성명 및
 					 	    이메일를 등록하고 아이디찾기를 실행하세요 </h11>
						<input type="text" class="form-control mt-2" id="userId" name="userId" placeholder="사용자아이디">
					</div>
				</form:form>
				<div class="set-btn-box w-100 mt-3 d-flex justify-content-between">
					<div>
						<button type="button" class="btn btn-outline-dark" onclick="fnPasswdmanagerClose();">취소</button>
						<button type="button" class="btn btn-primary" onclick="fnpwsearch();">아이디찾기  <i class="fas fa-search"></i> </button>
					</div>
					<div>
						<button type="button" class="btn btn-primary" onclick="fnPasswdreset();">
						  비밀번호 초기화/변경
						  <i class="fas fa-arrow-right"></i>
						</button>
					</div>
				</div>
			</div>
		</div>
	</div>


	<!--아이디찾기  -->
	<script>
	function fnpwsearch(){
		if ($("#userNm1").val() ==""){
			messageBox("1","<h6> 사용자 성명을 입력하세요 .!</h6><p></p>","","","");
			return;
		}
		if ($("#email1").val() == ""){
		    messageBox("1", "<h6>사용자 이메일를 입력하세요 .!</h6><p></p>", "", "", "");
		    return; 
		}
		$("#userId").val("") ;
		$.ajax( {
			type : "post",
			url : "${pageContext.request.contextPath}" + "/popup/login_usersearch.do",
			data : {userNm : $("#userNm1").val() , email : $("#email1").val() },
			dataType : "json",
			success : function(data) {
	            if (data.error_code !== "0" || !data.result || data.result.length === 0 ) {
	                alert("해당 사용자정보가 존재하지 않습니다!");
	                return;
	            }
	            $("#userId").val(data.result.userId);
	        },
	        error: function (xhr, status, error) {
	            alert("서버 요청 중 오류가 발생했습니다.");
	            console.error("Error: ", status, error);
	        }
		}); 
	}
	//비밀번호 초기화/팝업실행 지금 보류 상태 (팝업일때 사용) 
	function fnPwdClear(){ 

	    var popupwidth  = 450;
	    var popupheight = 350;
	    var url = "${pageContext.request.contextPath}" + "/popup/login_pwdchg.do";
	    
	    // 모니터 해상도를 기준으로 중앙 위치 계산
	    var screenLeft = window.screenLeft !== undefined ? window.screenLeft : screen.left;
	    var screenTop = window.screenTop !== undefined ? window.screenTop : screen.top;

	    var screenWidth = window.innerWidth ? window.innerWidth : document.documentElement.clientWidth ? document.documentElement.clientWidth : screen.width;
	    var screenHeight = window.innerHeight ? window.innerHeight : document.documentElement.clientHeight ? document.documentElement.clientHeight : screen.height;

	    var LeftPosition = screenLeft + (screenWidth - popupwidth) / 2;
	    var TopPosition = screenTop + (screenHeight - popupheight) / 2;

	    var oPopup = window.open(url, "비밀번호초기화", "width=" + popupwidth + ",height=" + popupheight + ",top=" 
	    		                                             + TopPosition + ",left=" + LeftPosition + ",scrollbars=no");
	    if (oPopup) {
	        oPopup.focus();
	    }
	}	
</script>
	<!-- 비빌번호 초기화 변경  -->

	<div class="modal fade" id="pwresetForm" tabindex="-1"
		data-bs-backdrop="static" data-bs-keyboard="false" aria-hidden="true"
		style="margin-left: -1px;">
		<div class="modal-dialog modal-lg" style="max-width: 500px; margin-top: 20px;">
			<<div class="modal-content rounded-3 shadow-lg" style="min-height: 380px; padding: 20px;">
				<form:form commandName="DTO" id="pwresetregForm"
					name="pwresetregForm" method="post">
					<h4>비밀번호 초기화 변경</h4>
					<div class="pass-box w-70">
						<input type="text" name="hospCd1" class="form-control mt-2"
							id="hospCd1" value="" placeholder="요양기관기호" /> <input type="text"
							name="userId1" class="form-control mt-2" id="userId1" value=""
							placeholder="사용자ID" />
						<h11 style="font-size: 12px; color: #555;">비밀번호 초기화시에는 요양기관과
						사용자ID만 입력하고 초기화하세요</h11>
						<input type="password" class="form-control mt-2" id="passWd1"
							name="passWd1" placeholder="현재 비밀번호"> <input
							type="password" class="form-control mt-2" id="bfPassWd1"
							name="bfPassWd1" placeholder="변경 비밀번호"> <input
							type="password" class="form-control mt-2" id="afPpassWd1"
							name="afPassWd1" placeholder="변경 비밀번호 확인">
					</div>
				</form:form>
				<div class="set-btn-box w-100 mt-3 d-flex justify-content-between">
					<div>
						<button type="button" class="btn btn-primary"
							onclick="fnSaveReset();">비밀번호초기화 <i class="bi bi-arrow-clockwise"></i> </button>
					</div>
					<div>
						<button type="button" class="btn btn-outline-dark"
							onclick="fnPasswdresetClose();">취소</button>
						<button type="button" class="btn btn-primary"
							onclick="fnSavechg();">변경 <i class="fas fa-cog"></i> </button>
					</div>
				</div>
			</div>
		</div>
	</div>
	<script>	 
	function fnSavechg(){
		if ($("#hospCd1").val() ==""){
			messageBox("1","<h6> 요양기관기호를 입력하세요.!</h6><p></p>","","","");
			return;
		}
		if ($("#userId1").val() == ""){
		    messageBox("1", "<h6>사용자 ID를 입력하세요.!</h6><p></p>", "", "", "");
		    return; 
		}

		if ($("#passWd1").val() == "") {
			alert("비밀번호를 입력하세요.!");
			$("#passWd1").focus();
			return;
		}
		if( $("#bfPassWd1").val() != $("#afPpassWd1").val()) {
			alert("변경할 비밀번호를 확인하세요.!");
			$("#bfPassWd1").focus();
			return;
		}
		var formData = $("form[name='pwresetregForm']").serialize();
		$.ajax( {
			type : "post",
			url : "${pageContext.request.contextPath}" + "/base/pwdchgAct.do",
			data : {hospCd  :  $("#hospCd1").val() , userId    : $("#userId1").val() , 
				    passWd  :  $("#passWd1").val() , bfPassWd  : $("#bfPassWd1").val()
				  },
			dataType : "json",
			success : function(data) {
				if(data.error_code != "0") {
					alert(data.error_msg);
					return;
				}
				alert("비밀번호가 변경되었습니다.");
	         //   window.close(); 이전 화면 모드 닫을때 
	    		fnPasswdresetClose() ;
			}
		}); 
	}
	function fnSaveReset(){ 
		if (!$("#hospCd1").val()){
			messageBox("1","<h6> 요양기관기호를 입력하세요.!</h6><p></p>","","","");
			return;
		}
		if (!$("#userId1").val()){
		    messageBox("1", "<h6>사용자 ID를 입력하세요.!</h6><p></p>", "", "", "");
		    return; 
		}
		if(!confirm("해당사용자의 비밀번호를 초기화 하시겠습니까?")) return;

		$.ajax( {
			type : "post",
			url : "${pageContext.request.contextPath}" + "/base/pwdresetAct.do",
			data : {hospCd  :  $("#hospCd1").val() , userId : $("#userId1").val()},
			dataType : "json",
			success : function(data) {   
				if(data.error_code != "0"){
					if(data.error_code == "20000"){ 
						messageBox("1", "<h6>비밀번호 변경할 사용자 정보가 존재하지 않습니다!</h6><p></p>", "", "", "");
						$("#userId1").focus();
					}	
					else{ 
						messageBox("1", "<h6>사용자 비밀번호 변경 실패하였습니다!</h6><p></p>", "", "", "");
						$("#userId1").focus();
					}
				}else{
					alert("비밀번호가 '1234'로 초기화되었습니다.\n비밀번호를 변경 후 로그인 하세요.");
					fnPwdChange();
				}
			},
		    error: function(xhr, status, error) {
		        console.error("Ajax request failed:", status, error);
		        alert("요청 처리 중 오류가 발생했습니다.");
		    }
		}); 
	}
</script>
	<!-- 비빌번호 초기화 변경  -->

	<!-- 공지사항 모달 -->
	<div id="adminModal" class="modal fade" data-backdrop="static"
	    data-keyboard="false" tabindex="-1" role="dialog" aria-hidden="true">
	    <div class="modal-dialog modal-lg" style="max-width: 800px; margin: 30px auto;">
	        <div class="modal-content"
	            style="display: flex; flex-direction: column; position: relative; border-radius: 10px; box-shadow: 0px 4px 20px rgba(0, 0, 0, 0.1); max-height: calc(100vh - 60px);">
	            
	            <!-- 헤더 -->
				<div class="modal-header"
				    style="padding: 10px 15px; display: flex; align-items: center; justify-content: flex-start; border-bottom: 1px solid #dee2e6; flex-shrink: 0;">
				    <span id="notiname" style="font-size: 20px; color: black;">공지사항</span>
				</div>	
	            <!-- 폼 (body만 포함) -->
	            <form:form commandName="DTO" id="regForm" name="regForm"
	                method="post" enctype="multipart/form-data"
	                style="flex-grow: 1; display: flex; flex-direction: column; overflow: hidden; min-height: 0;">
	                <input type="hidden" name="iud" id="iud" />
	                <input type="hidden" name="notiSeq" id="notiSeq" />
	                <input type="hidden" name="fileGb" id="fileGb" />
	                <div class="modal-body" style="overflow-y: auto; padding: 20px; flex-grow: 1; min-height: 0;">
	                    <div class="mb-0">
	                        <label for="notiTitle" class="form-label"
	                            style="font-size: 15px; font-weight: bold; display: block; text-align: left;">제목</label>
	                        <textarea name="notiTitle" id="notiTitle" rows="2"
	                            class="form-control" placeholder="제목을 입력하세요."
	                            style="font-size: 15px; resize: none;"></textarea>
	                    </div>
	                    <div class="mb-0 mt-2">
	                        <label for="notiContent" class="form-label"
	                            style="font-size: 15px; font-weight: bold; display: block; text-align: left;">내용</label>
	                        <textarea class="form-control" name="notiContent"
	                            id="notiContent" rows="10" placeholder="내용을 입력하세요."
	                            style="resize: none; font-size: 14px;"></textarea>
	                    </div>
	                    <h5 class="mt-2">첨부 문서</h5>
	                    <div class="table-container"
	                        style="width: 100%; border: 1px solid #ddd; border-radius: 10px; overflow: hidden;">
	                        <div style="max-height: 200px; overflow-y: auto;">
	                            <table id="fileTable"
	                                class="display nowrap table table-hover table-bordered"
	                                style="width: 100%; margin-bottom: 0;">
	                            </table>
	                        </div>
	                    </div>
	                </div>
	            </form:form>
	
	            <!-- 닫기 버튼 - form 밖에 위치 -->
	            <div class="modal-footer"
	                style="display: flex; justify-content: center; border-top: 1px solid #dee2e6; padding: 10px; flex-shrink: 0;">
	                <button type="button" class="btn btn-outline-dark btn-sm"
	                    style="width: 120px;"
	                    onclick="readsaveAdminModal(document.getElementById('notiSeq').value, document.getElementById('fileGb').value, this)">닫기</button>
	            </div>
	
	        </div>
	    </div>
	</div>
	<!-- 공지사항 스크립트시작 -->
	<script>
	function callMultipleSearch() {
	    for (let k = 0; k <= 3; k++) {
	        fnnotice_search(k);
	    }
	}
	
	function fnnotice_search(fileGb) {
		let targetArea, targetTable;
		switch (fileGb) {
	    	case 0:
				targetArea  = "#noticeArea";
				targetTable = "#noticeTable";
				break;
			case 1:
				targetArea  = "#noticeArea1";
				targetTable = "#noticeTable1";
				break;
			case 2:
				targetArea  = "#noticeArea2";
				targetTable = "#noticeTable2";
				break;
			case 3:
				targetArea  = "#noticeArea3";
				targetTable = "#noticeTable3";
				break;
			default:
				targetArea  = "#noticeArea";
				targetTable = "#noticeTable";
		}
		
		$(targetTable + " tr").attr("class", "");
		
		if (document.getElementById("regForm")) {
			document.getElementById("regForm").reset();
		}
		
		$(targetArea).empty();
		$.ajax({
			url: '${pageContext.request.contextPath}' + '/mangr/ctl_notiList.do',
			type: 'post',
			data: {
				fileGb: fileGb,
				startDt: "20230101",
				endDt: "20991231",
				searchText: ""
			},
			dataType: "json",
			success: function(data) {
				if (data.error_code != "0") return;
				
				if (data.resultCnt > 0) {
					const maxLength = 30;

					for (let i = 0; i < data.resultCnt; i++) {
						const noti = data.resultList[i];
						const notiSeq = noti.notiSeq;
						const fileGb = noti.fileGb;
						const notiTitle = encodeURIComponent(noti.notiTitle);
						const notiContent = encodeURIComponent(noti.notiContent);

						let dataTxt = '<tr onclick="showAdminModal(\'' 
							+ notiSeq + '\', \'' 
							+ fileGb + '\', \'' 
							+ notiTitle + '\', \'' 
							+ notiContent + '\')">';

						
						// 분류 표시
						if (fileGb == "1") {
							dataTxt += "<td class='rounded-box notice'>공지사항</td>";
						} else if (fileGb == "2") {
							dataTxt += "<td class='rounded-box audit'>심사방</td>";
						} else if (fileGb == "3") {
							dataTxt += "<td class='rounded-box newsletter'>소식지</td>";
						}

						// 제목 표시
						let titleText = decodeURIComponent(notiTitle);
						if (titleText.length > maxLength) {
							titleText = titleText.substring(0, maxLength) + " ...";
						}

						dataTxt += "<td style='text-align: left;'>" + titleText + "</td>";
						dataTxt += "<td>" + noti.updDttm.split(' ')[0] + "</td>";
						dataTxt += "<td>" + noti.notiRedcnt + "</td>";
						dataTxt += "</tr>";

						$(targetArea).append(dataTxt);
					}
				} else {
					$(targetArea).append("<tr><td colspan='4'>검색된 정보가 없습니다.</td></tr>");
				}
			}
		});
	}

	function showAdminModal(notiSeq, fileGb, notiTitle, notiContent) {
		// 로그인 여부 확인
		if (!sessionStorage.getItem('s_hospid')) {
			messageBox("1", "<h6>로그인 하고 진행하세요.!!</h6><p></p>", "", "", "");
			return; 
		}  
	    // 디코딩 처리
		const title = decodeURIComponent(notiTitle);
		const content = decodeURIComponent(notiContent);

		// 기본 값 세팅
		$("#notiSeq").val(notiSeq);
		$("#fileGb").val(fileGb);

		// 공지 유형에 따라 이름 출력
		switch (parseInt(fileGb, 10)) {
			case 1:
				$("#notiname").text("공지사항");
				break;
			case 2:
				$("#notiname").text("심사방");
				break;     
			case 3:
				$("#notiname").text("소식지");
				break;     
			default:
				$("#notiname").text("공지사항");
				break;        		
		}

		// 제목 및 내용 표시
		$("#notiTitle").val(title);  // input 박스에 제목
		modalName_rich(content);     // Summernote에 내용 세팅

		// 파일 표시 함수 호출
		showfileModal(notiSeq, fileGb);

		// 모달 열기
		$("#adminModal").modal('show');
	}  
	//데이타테입르 최초생성 
	$(document).ready(function() {
	    console.log("📌 최초 DataTables 생성");
	    $("#fileTable").DataTable({
	      //  scrollX: true,
	      //  scrollY: "100px",
	        scrollCollapse: true, // ✅ 내용이 적을 때도 높이 유지
	        paging:        false, // 페이지네이션 비활성화 (원하는 경우 제거 가능)
	        searching:     false,
	        ordering:      false,
	        autoWidth:     false,  // 🔹 자동 너비 조정 비활성화
	        fixedHeader:   true,   // 🔹 헤더 고정
	        colReorder:    true,
	        lengthChange:  true, 
	        fixedHeader:   true, // 헤더 고정
	        info:          false,	
	        lengthMenu: [],
	        language: {
	            search: "검색:",
	            lengthMenu: "페이지당 _MENU_ 개씩 보기",
	            info: "_START_ - _END_ (총 _TOTAL_ 개)",
	            paginate: {
	                next: "다음",
	                previous: "이전"
	            }
	        },
	        columns: [
	        	{ title: "번호",     className: "text-center", width: '50px' },
	            { title: "문서유형",  className: "text-center", width: '100px' },
	            { title: "문서제목",  className: "text-center", width: '300px' },
	            { title: "사이즈",   className: "text-center", width: '50px' },
	            { title: "작성일",   className: "text-center", width: '150px' },
	            { title: "첨부",     className: "text-center", width: '100px' }
	        ],
	        initComplete: function() {
	            // 테이블의 헤더 높이 맞추기
	            var headerHeight = $('#fileTable thead').outerHeight();
	            $('#fileTable tbody').css('padding-top', headerHeight + 'px');
	        }
	    });
	});	    
	function showfileModal(notiSeq, fileGb) {
	    $.ajax({
	        type: "post",
	        url: "${pageContext.request.contextPath}" + "/mangr/fileCdList.do",
	        data: { fileGb: fileGb, fileSeq: notiSeq },
	        dataType: "json",
	        success: function (data) {
	            console.log("📌 서버 응답 데이터 개수:", data.length);
	            console.log("📌 서버 응답 데이터:", JSON.stringify(data, null, 2));

	            let tbody = document.querySelector("#fileTable tbody");
	            tbody.innerHTML = "";

	            if (!Array.isArray(data) || data.length === 0) {
	                console.warn("⚠️ 파일 목록이 없습니다.");
	                tbody.innerHTML = "<tr><td colspan='5' style='text-align: center;'>등록된 파일이 없습니다.</td></tr>";
	                return;
	            }

	            let tableBody = "";
	            data.forEach(function (doc, index) {
	                let subCodeNm = doc.subCodeNm || "정보 없음";
	                let fileTitle = doc.fileTitle || "제목 없음";
	                let fileSize  = doc.fileSize  || "제목 없음";
	                let regDttm   = doc.regDttm   || "날짜 없음";

	                // ✅ SFTP 기반 다운로드 URL 생성
	                let fileUrl = "#";
	                if (doc.filePath && doc.fileTitle) {
	                    let encodedPath = encodeURIComponent(doc.filePath);
	                    fileUrl = "/wnn_consult/sftp/download.do?filePath=" + encodedPath;
	                }

	                console.log("📌 생성된 SFTP fileUrl:", fileUrl);

	                tableBody += "<tr>";
	                tableBody += "<td>" + (index + 1) + "</td>";
	                tableBody += "<td>" + subCodeNm + "</td>";
	                tableBody += "<td><a href='#' class='doc-link' data-url='" + fileUrl + "' data-title='" + fileTitle + "'>" + fileTitle + "</a></td>";
	                tableBody += "<td>" + fileSize + " KB</td>";
	                tableBody += "<td>" + regDttm + "</td>";
	                tableBody += "<td>";
	                if (fileUrl !== "#") {
	                    tableBody += "<a href='" + fileUrl + "' download='" + fileTitle + "' class='btn btn-link file-attach'>";
	                    tableBody += "<i class='fa-solid fa-floppy-disk' style='font-size: 1.2em; color: #007bff;'></i>";
	                    tableBody += "</a>";
	                } else {
	                    tableBody += "<span style='color: black;'>❌ 파일 없음</span>";
	                }

	                tableBody += "</td>";
	                tableBody += "</tr>";
	            });

	            tbody.innerHTML = tableBody;
	            console.log("✅ 테이블 업데이트 완료!");
	        },
	        error: function (xhr, status, error) {
	            console.error("❌ AJAX 요청 실패:", status, error);
	            console.error("❌ 서버 응답:", xhr.responseText);
	        }
	    });
	}

	// ✅ 파일 미리보기 클릭 시
	$(document).on("click", ".doc-link", function (e) {
	    e.preventDefault();
	    let fileUrl = $(this).data("url");
	    let fileTitle = $(this).data("title");

	    console.log("📌 파일 미리보기 실행: " + fileUrl);
	    loadFileContent(fileUrl, fileTitle);
	});

	// ✅ 미리보기 로직 (PDF, 이미지만 iframe)
	function loadFileContent(fileUrl, fileTitle) {
	    let fileExtension = fileTitle.split('.').pop().toLowerCase();
	    let contentHtml = "";

	    if (["pdf", "jpg", "jpeg", "png", "gif"].includes(fileExtension)) {
	        contentHtml = `<iframe src="${fileUrl}" width="100%" height="500px"></iframe>`;
	    } else {
	        contentHtml = `<p>미리보기를 지원하지 않는 파일 형식입니다. 
	                       <a href="${fileUrl}" download>다운로드</a>하여 확인하세요.</p>`;
	    }

	    $("#docContent").html(contentHtml);
	}

	// ✅ 다운로드 아이콘 클릭 시 (기본 다운로드 링크 사용 가능)
	$(document).on("click", ".file-attach", function (e) {
	    // 기본적으로 <a download>로 동작하지만, 필요시 확인 로직 삽입 가능
	    const fileUrl = $(this).attr("href");
	    const fileTitle = $(this).attr("download");

	    if (!fileUrl.startsWith("/wnn_consult/sftp/download.do")) {
	        alert("❌ 유효하지 않은 다운로드 경로입니다.");
	        e.preventDefault();
	    }
	});
	function readsaveAdminModal(notiSeq, fileGb, button) {
	    $(button).prop('disabled', true);
	    $.ajax({
	        url: '${pageContext.request.contextPath}' + '/mangr/read_noticnt.do',
	        type: 'post',
	        data: { notiSeq: notiSeq, fileGb: fileGb },
	        dataType: "json",
	        success: function(data) {
	            if (data.error_code !== "0") {
	                alert("오류 발생: " + data.error_msg);
	                return;
	            }
	        },
	        error: function(xhr, status, error) {
	            console.error("Error:", error);
	         //   alert("서버 요청 실패!");
	        },
	        complete: function() {
	            $(button).prop('disabled', false);
	            $("#adminModal").modal('hide');  // Bootstrap 모달 사용 예제
	        }
	    });
	}
	
</script>
	<!-- 공지사항 스크립트 종료-->
	<script>
	    // 전체 선택 체크박스 기능
	    function toggleAllCheckboxes(source) {
	        let checkboxes = document.querySelectorAll('.file-checkbox');
	        checkboxes.forEach(checkbox => {
	            checkbox.checked = source.checked;
	        });
	    }
	
	    // 선택된 파일 다운로드 (예제 함수)
	    function downloadSelectedFiles() {
	        let selectedFiles = [];
	        let checkboxes = document.querySelectorAll('.file-checkbox:checked');
	        checkboxes.forEach((checkbox, index) => {
	            let fileLink = checkbox.closest('tr').querySelector('.download-link').href;
	            selectedFiles.push(fileLink);
	        });
	
	        if (selectedFiles.length > 0) {
	            selectedFiles.forEach((file) => {
	                window.open(file, '_blank');
	            });
	        } else {
	            alert("선택된 파일이 없습니다.");
	        }
	    }
	
	    // 전체 파일 다운로드 기능
	    function downloadAllFiles() {
	        let allLinks = document.querySelectorAll('.download-link');
	        if (allLinks.length > 0) {
	            allLinks.forEach((link) => {
	                window.open(link.href, '_blank');
	            });
	        } else {
	            alert("다운로드할 파일이 없습니다.");
	        }
	    }
</script>
<!-- 기존 1대1 질의응답  -->
<div class="modal fade" id="asq_main_tab" tabindex="-1"
	data-bs-backdrop="static" data-bs-keyboard="true" aria-hidden="true">
	<div class="modal-dialog modal-lg"
		style="max-width: 900px; width: 90%; margin-top: 20px;">
		<!-- 모달 전체 높이를 100vh에서 auto로 변경하고 최대 높이를 제한 -->
		<div class="modal-content shadow-lg rounded-4"
			style="height: auto; max-height: 90vh; border: none;">
			<div class="modal-header bg-light"
				style="height: 35px; padding: 5px 10px;">
				<h5 class="modal-title">상담문의 목록</h5>
			</div>
			<!-- modal-body의 높이를 줄여서 최대 65vh 정도로 제한 -->
			<div class="modal-body bg-light"
				style="max-height: 60vh; overflow-y: auto;">
				<div class="d-flex align-items-center justify-content-between mb-3">
					<div class="d-flex">
						<input type="text" id="searchText"
							class="form-control rounded-3 border" placeholder="검색어를 입력하세요."
							onkeypress="if(event.keyCode == 13){fnasq_Search();}"
							style="width: 300px;">
						<button type="button" class="btn btn-warning rounded-3 ms-2"
							onclick="fnasq_Search()" style="margin-left: 8px;">
							<i class="fas fa-search"></i> 검색
						</button>
					</div>
					<div>
						<button class="btn btn-outline-info" onclick="fn_asqsave('QD');">질문취소</button>
						<button class="btn btn-outline-info" onclick="fn_asqsave('QI');">질문등록</button>
						<button class="btn btn-outline-info" onclick="fn_asqsave('QU');">답변조회(수정)</button>
						<button class="btn btn-outline-dark" onclick="asqMainClose();">
							닫기 <i class="fas fa-times"></i>
						</button>
					</div>
				</div>
				<div class="table-responsive rounded-3 shadow-sm mt-1 border"
					style="height: 500px; overflow-y: auto;">
					<table id="asq_infoTable" class="table table-bordered">
						<colgroup>
							<col style="width: 50px">
							<col style="width: 150px">
							<col style="width: 160px">
							<!-- 질문제목 너비 줄임 -->
							<col style="width: 160px">
							<!-- 질문내용 너비 줄임 -->
							<col style="width: 60px">
							<col style="width: 40px">
							<col style="width: 60px">
							<col style="width: 120px">
						</colgroup>

						<thead>
							<tr>
								<th>번호</th>
								<th>병원정보</th>
								<th title="질문제목">질문제목</th>
								<th title="질문내용">질문내용</th>
								<th>답변상태</th>
								<th>첨부</th>
								<th>질문자</th>
								<th>작성일</th>
							</tr>
						</thead>
						<tbody id="asqdataArea" style="background-color: white;">
							<tr>
								<td colspan="7" class="text-muted">&nbsp; 검색된 결과가 없습니다.</td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>
			<!-- modal-footer의 패딩을 줄여서 높이를 좁힘 -->
			<div class="modal-footer"
				style="background-color: white; padding: 5px 10px;">
				<!-- 필요한 footer 내용 추가 -->
			</div>
		</div>
	</div>
</div>

<div class="modal fade" id="asq_main" tabindex="-1"
    data-bs-backdrop="static" data-keyboard="false" aria-hidden="true">
    <div class="modal-dialog modal-dialog-scrollable modal-lg"
        style="max-width: 900px; width: 90%; margin-top: 20px;">
        <div class="modal-content"
            style="max-height: calc(100vh - 100px); display: flex; flex-direction: column;">
            
            <!-- 헤더 -->
            <div class="modal-header bg-light" style="flex-shrink: 0;">
                <h6 class="modal-title">문의 등록</h6>
                <div class="form-row">
                    <div class="col-sm-12 mb-2" style="text-align: right;">
                        <button type="button" id="save_btn" class="btn btn-outline-info" 
                            onClick="fnasq_SaveProc()">저장 <i class="far fa-edit"></i>
                        </button>
                        <button type="button" class="btn btn-outline-dark"
                            data-dismiss="modal" onClick="asqModalClose()">닫기 <i class="fas fa-times"></i>
                        </button>
                    </div>
                </div>
            </div>

            <!-- 폼 바디 -->
            <form:form commandName="DTO" id="asq_regForm" name="asq_regForm"
                method="post" enctype="multipart/form-data"
                style="flex-grow: 1; display: flex; flex-direction: column; overflow: hidden; min-height: 0;">
                <div class="modal-body text-left" style="overflow-y: auto; flex-grow: 1; min-height: 0; padding: 15px 20px;">
                    <input type="hidden" name="iudasq"      id="iudasq" />
                    <input type="hidden" name="asqSeq"      id="asqSeq" />
                    <input type="hidden" name="fileGbasq"   id="fileGbasq" value="4" />
                    <input type="hidden" name="qstnWan"     id="qstnWan"   value="Y" />
                    <input type="hidden" name="hospCdasq"   id="hospCdasq" />
                    <input type="hidden" name="hospUuidasq" id="hospUuidasq" />
                    <input type="hidden" name="regUserasq"  id="regUserasq" />
                    <input type="hidden" name="updUserasq"  id="updUserasq" />

                    <div class="form-group d-flex align-items-start">
                        <label for="qstnTitle"
                            style="background-color: #e6f3f7; padding: 5px 10px; border-radius: 5px; font-weight: bold; 
                            width: 100px; min-width: 100px; margin-right: 10px;">
                            질문제목
                        </label>
                        <textarea id="qstnTitle" name="qstnTitle" required
                            class="form-control" rows="2"
                            style="flex: 1;"></textarea>
                    </div>
                    <div class="form-group d-flex align-items-start">
                        <label for="qstnConts"
                            style="background-color: #e6f3f7; padding: 5px 10px; border-radius: 5px; font-weight: bold; 
                            width: 100px; min-width: 100px; margin-right: 10px;">
                            질문내용
                        </label>
                        <textarea id="qstnConts" name="qstnConts" required
                            class="form-control" rows="5"
                            style="flex: 1;"></textarea>
                    </div>
                    <div class="form-group d-flex align-items-start">
                        <label for="ansrConts"
                   
                            style="background-color: #e6f3f7; padding: 5px 10px; border-radius: 5px; font-weight: bold; width: 100px; min-width: 100px; margin-right: 10px;">
                            답변내용
                        </label>
                        <textarea id="ansrConts" name="ansrConts" required
                            class="form-control" rows="8"
                            style="flex: 1;"></textarea>
                    </div>
                    <!-- 답변자 첨부파일 그리드 (FILE_GB='5') -->
                    <div id="ansr-file-area" style="margin-top: 5px; margin-bottom: 8px; display:none;">
                        <div class="d-flex align-items-center" style="margin-bottom: 4px;">
                            <label style="background-color: #e6f3f7; padding: 5px 10px; border-radius: 5px; font-weight: bold; width: 100px; min-width: 100px; font-size: 13px; margin: 0;">
                                <i class="fa-solid fa-floppy-disk" style="color:green;"></i> 답변 파일
                            </label>
                        </div>
                        <div class="table-file-container" style="width: 100%; border: 1px solid #d0dbe5; border-radius: 10px; padding: 5px 12px; background: #fafcfe;">
                            <div style="max-height: 150px; overflow-y: auto;">
                                <table id="ansr-file-table" class="display nowrap table table-hover table-bordered" style="width: 100%; font-size: 13px; margin-bottom: 0;">
                                    <thead style="background-color: #e8f4fd; border-bottom: 2px solid #b8d4e8;">
                                        <tr>
                                            <th style="text-align:center; width:40px; padding:8px 4px; font-weight:600; font-size:12px;">번호</th>
                                            <th style="text-align:center; width:80px; padding:8px 4px; font-weight:600; font-size:12px;">문서유형</th>
                                            <th style="text-align:center; padding:8px 4px; font-weight:600; font-size:12px;">문서제목</th>
                                            <th style="text-align:center; width:60px; padding:8px 4px; font-weight:600; font-size:12px;">사이즈</th>
                                            <th style="text-align:center; width:100px; padding:8px 4px; font-weight:600; font-size:12px;">작성일</th>
                                            <th style="text-align:center; width:45px; padding:8px 4px; font-weight:600; font-size:12px;">첨부</th>
                                        </tr>
                                    </thead>
                                    <tbody id="ansr-file-tbody"></tbody>
                                </table>
                            </div>
                        </div>
                    </div>

                    <div class="form-group d-flex align-items-center">
                        <label for="ansrWan"
                            style="background-color: #e6f3f7; padding: 5px 10px; border-radius: 5px; font-weight: bold; width: 100px; min-width: 100px; margin-right: 10px;">
                            답변완료
                        </label>
                        <select id="ansrWan" name="ansrWan" class="custom-select"
                            style="height: 35px; font-size: 14px; width: 120px;">
                            <option value="">선택</option>
                            <option value="Y">Y. 답변완료</option>
                            <option value="N">N. 진행중</option>
                        </select>
                    </div>

                    <!-- 파일첨부 영역 -->
                    <div id="asq-file-area" style="margin-top: 0; border: 1px solid #ddd; border-radius: 5px; padding: 8px;">
                        <div style="display: flex; flex-wrap: nowrap; align-items: center; margin-bottom: 5px;">
                            <label style="background-color: #e6f3f7; padding: 5px 10px; border-radius: 5px; font-weight: bold; font-size: 13px; margin: 0 10px 0 0; white-space: nowrap;">파일업로드</label>
                            <button type="button" class="btn btn-primary btn-sm" style="white-space: nowrap;" onclick="openAsqFileInput()">파일 선택</button>
                            <input type="file" id="asq-file-input" multiple style="display:none;" onchange="asqHandleFiles(this.files)">
                        </div>
                        <div id="asq-drop-zone"
                            style="border: 2px dashed #ccc; border-radius: 4px; padding: 8px; text-align: center; color: #999; font-size: 14px; min-height: 40px; cursor: pointer;"
                            ondragover="event.preventDefault(); this.style.borderColor='#007bff'; this.style.backgroundColor='#f0f8ff';"
                            ondragleave="this.style.borderColor='#ccc'; this.style.backgroundColor='';"
                            ondrop="event.preventDefault(); this.style.borderColor='#ccc'; this.style.backgroundColor=''; asqDropHandler(event);">
                            <p style="margin: 3px; font-size: 14px;">파일을 여기에 드래그 하세요.
                                (<span style="color: red; font-weight: bold;">입력저장일 경우 선택한 파일 자동저장</span>)
                            </p>
                            <div id="asq-file-list-new" class="file-list-container"></div>
                        </div>
                    </div>
                </div>
                    <!-- 기존 업로드된 파일 테이블 -->
                    <div class="table-file-container" style="width: 100%; margin-top: 5px; margin-bottom: 10px; border: 1px solid #d0dbe5; border-radius: 10px; padding: 5px 12px; background: #fafcfe;">
                        <div style="max-height: 250px; overflow-y: auto;">
                            <table id="asq-file-table" class="display nowrap table table-hover table-bordered" style="width: 100%; font-size: 13px; display:none; margin-bottom: 0;">
                                <thead style="background-color: #e8f4fd; border-bottom: 2px solid #b8d4e8;">
                                    <tr>
                                        <th style="text-align:center; width:40px; padding:8px 4px; font-weight:600; font-size:12px; white-space:nowrap;">번호</th>
                                        <th style="text-align:center; width:80px; padding:8px 4px; font-weight:600; font-size:12px; white-space:nowrap;">문서유형</th>
                                        <th style="text-align:center; padding:8px 4px; font-weight:600; font-size:12px; white-space:nowrap;">문서제목</th>
                                        <th style="text-align:center; width:60px; padding:8px 4px; font-weight:600; font-size:12px; white-space:nowrap;">사이즈</th>
                                        <th style="text-align:center; width:100px; padding:8px 4px; font-weight:600; font-size:12px; white-space:nowrap;">작성일</th>
                                        <th style="text-align:center; width:45px; padding:8px 4px; font-weight:600; font-size:12px; white-space:nowrap;">삭제</th>
                                        <th style="text-align:center; width:45px; padding:8px 4px; font-weight:600; font-size:12px; white-space:nowrap;">첨부</th>
                                    </tr>
                                </thead>
                                <tbody id="asq-file-tbody"></tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </form:form>

        </div>
    </div>
</div>


	<!-- 질의응답 스크립트 시작 -->
	<script>
	function fnasq_main() {
		if (!sessionStorage.getItem('s_hospid')) {
		    messageBox("1", "<h6>로그인 하고 진행하세요.!!</h6><p></p>", "", "", "");
		    return; 
		}          	
	    fnasq_Search();
	    $('#asq_main_tab').modal('show') ;
	    $("#asqdataArea").empty();
	    if (document.getElementById('searchText')) {
	        document.getElementById('searchText').value = '';
	    }
	
	    if ($('#overlay').length === 0) {
	        $('body').append('<div id="overlay"></div>');
	    }
	
	    $('#asq_main_tab').on('hidden.bs.modal', function () {
	        $('#overlay').remove();
	    });
	}    
	/*질의응답메인*/
	function asqMainClose() {
	    $('#asq_main_tab').modal('hide');
	}   
	/*질의응답모달*/
	function asqModalOpen() {
		$("#hospCdasq").val(sessionStorage.getItem('s_hospid') || '') ;
		$("#updUserasq").val(sessionStorage.getItem('s_userid') || '');
		$("#regUserasq").val(sessionStorage.getItem('s_userid') || '');
		$("#iudasq").val(uidGubun);
	    $('#asq_main').modal('show');
	} 
	function asqModalClose() {
	    $('#asq_main').modal('hide');
	}        
	
	
	/* 자주하는 질의응답 */ 
	function fnasq_Search() {
		$("#asq_infoTable tr").attr("class", ""); 
	    if (document.getElementById("asq_regForm")) {
	        document.getElementById("asq_regForm").reset();
	    }
	    $("#asqSeq").val("") ;
	    $("#asqdataArea").empty();
	    $.ajax({
		   	url : '${pageContext.request.contextPath}' + '/mangr/ctl_asqList.do',
		    type : 'post',
		    data : {hospCdasq : sessionStorage.getItem('s_hospid')  , qstnTitle : $("#searchText").val() },
			dataType : "json",
		   	success : function(data) {
		   		if(data.error_code != "0") return;
	
		   		if(data.resultCnt > 0 ){
		    		var dataTxt = "";
		    		for(var i=0 ; i < data.resultCnt; i++){
		    			dataTxt = '<tr onclick="fn_rowClick(\'' + data.resultLst[i].asqSeq + '\')" ' +
		    	          'ondblclick="fn_rowDblClick(\'' + data.resultLst[i].asqSeq + '\')" ' +
		    	          'id="row_' + data.resultLst[i].asqSeq + '">';
		 				dataTxt += 	"<td>" + (i+1)  + "</td>" ; 
		 				dataTxt +=  "<td>" + data.resultLst[i].hospNm   + "</td>" ;
		 				dataTxt +=  "<td class='txt-left ellips'>" + data.resultLst[i].qstnTitle    + "</td>" ;
						dataTxt +=  "<td class='txt-left ellips'>" + data.resultLst[i].qstnConts    + "</td>" ;	
		 				dataTxt +=  "<td>" + data.resultLst[i].ansrStat    + "</td>" ;	
		 				dataTxt +=  "<td>" + (data.resultLst[i].fileYn === 'Y' ? '<i class="fa-solid fa-floppy-disk" title="파일 있음" style="color: green; font-size:15px;"></i>' : '') + "</td>" ;
		 				dataTxt +=  "<td>" + data.resultLst[i].userNm   + "</td>" ;
						dataTxt +=  "<td>" + data.resultLst[i].updDttm  + "</td>" ;
						dataTxt +=  "</tr>";
			            $("#asqdataArea").append(dataTxt);
		        	 }
			 	  }else{
					  $("#asqdataArea").append("<tr><td colspan='9'>검색된 정보가 없습니다.</td></tr>");
				  }
		      }
	   });
	}
	var  lasqSeq  ;
    var  lfileGb  ;  
    var  lregUser ;
    var  lregIp   ;
    let clickTimer = null;
    function fn_rowClick(asqSeq) {
        // 단일 클릭 시 (delay 후 실행, 만약 더블클릭이면 clearTimeout)
        clickTimer = setTimeout(function () {
            fn_asqDtlSearch(asqSeq);
        }, 250); // 더블클릭보다 살짝 느리게
    }

    function fn_rowDblClick(asqSeq) {
        // 더블클릭 시: 단일 클릭 취소하고 저장 실행
        clearTimeout(clickTimer);
        fn_asqDtlSearch(asqSeq);  // 필요 시 생략 가능
        fn_asqsave('QU');
    }
	function fn_asqDtlSearch(asqSeq){ 
			if(asqSeq == '' || asqSeq == null) return;
			$("#asqSeq").val(asqSeq);
			//row 클릭시 바탕색 변경 처리 Start 
			$("#asq_infoTable tr").attr("class", ""); 
			$("#asq_infoTable #"+asqSeq).attr("checked", true);
			$("#asq_infoTable #row_"+asqSeq).attr("class", "tr-primary");
	}
	function fn_asqsave(iud) {
	    $("#iud").val(iud); // 입력(I), 수정(U), 삭제(D)
        
	    var asqSeq = $("#asqSeq").val();
	    
	    if (iud.substring(1, 2) === "U" || iud.substring(1, 2) === "D") {
	        if (!asqSeq) {
			    messageBox("1", "<h6>수정 또는 삭제할 항목을 선택하세요.!!</h6><p></p>", "", "", "");
			    return; 
	        }
	    }
	    uidGubun = iud;
	    
	    $("#ansrWan").closest(".form-wrap").hide(); // 답변완료 숨기기

	    if (iud.substring(1, 2) == "I") {
	        // 등록 폼 초기화
	        $.ajax({
	            type: "post",
	            url: "${pageContext.request.contextPath}" + "/mangr/ctl_getHospmst.do",
	            data: { hospCd: getCookie("hospid") },
	            dataType: "json",
	            success: function (data) {
	                if (data.error_code != "0") {
	                    alert(data.error_msg);
	                    return;
	                }
	                $("#hospCd").val(data.result.hospCd);
	            }
	        });
	        document.getElementById("asq_regForm").reset();
	      //  setCurrDate("regDtm");
	        $("#ansrConts").prop("readonly", "true");
	        $("#ansrWan").css("pointer-events", "none").css("background-color", "#e9ecef"); // 비활성화된 느낌의 배경색 적용
	        $("#save_btn").show(); // 답변내용 보이기
	        asqFileClear();
	        $("#asq-file-table").show();
	        $("#asq-file-tbody").html("<tr><td colspan='7' style='text-align:center; color:#999;'>등록된 파일이 없습니다.</td></tr>");
	        $("#ansr-file-area").show();
	        $("#ansr-file-tbody").html("<tr><td colspan='6' style='text-align:center; color:#999;'>등록된 파일이 없습니다.</td></tr>");
	        asqModalOpen();

	    } else if (iud.substring(1, 2) == "U") {
	        if ($("#asqSeq").val() == "") {
	            alert("선택된 정보가 없습니다.!");
	            asqModalClose();
	            return;
	        }
	        $("#regDtm").prop("readonly", false);
	        $.ajax({
	            type: "post",
	            url: "${pageContext.request.contextPath}" + "/mangr/selectAnsrInfo.do",
	            data: { asqSeq: $("#asqSeq").val() },
	            dataType: "json",
	            success: function (data) {
	                if (data.error_code != "0") {
	                    alert(data.error_msg);
	                    return;
	                }

	                $("#hospUuid").val(data.result.hospUuid);
	                $("#qstnTitle").val(data.result.qstnTitle);
	                $("#qstnConts").val(data.result.qstnConts);
	                $("#qstnWan").val(data.result.qstnWan);
	                $("#ansrWan").val(data.result.ansrWan); // 답변완료 여부 값 설정
	                $("#ansrConts").val(data.result.ansrConts);
	                $("#fileGb").val(data.result.fileGb);
	                $("#regDtm").val(data.result.regDtm);

	                if ($("#ansrWan").val().trim() === "Y") {
	                    $("#save_btn").hide(); // 답변내용 숨기기
	                }else{
	                	$("#save_btn").show(); // 답변내용 
	               	}

	                if (uidGubun.substring(0, 1) == "Q") {
	                    // 질문
	                    $("#qstnTitle").prop("readonly", "");
	                    $("#qstnConts").prop("readonly", "");
	                    $("#qstnWan").css("pointer-events", "auto").css("background-color", "");
	                    // 답변
	                    $("#ansrConts").prop("readonly", "true");
	                    $("#ansrWan").css("pointer-events", "none").css("background-color", "");
	                }
	                asqFileClear();
	                showAsqFileList($("#asqSeq").val());
	                showAnsrFileList($("#asqSeq").val());
	                asqModalOpen();
	            }
	        });

	    } else if (iud.substring(1, 2) == "D") {
	        // 삭제 전에 ansrWan 상태 확인 후 처리
	        $.ajax({
	            type: "post",
	            url: "${pageContext.request.contextPath}" + "/mangr/selectAnsrInfo.do",  // 답변 상태 조회 API
	            data: { asqSeq: $("#asqSeq").val() },
	            dataType: "json",
	            success: function (data) {
	                if (data.error_code != "0") {
	                    alert(data.error_msg);
	                    return;
	                }

	                var ansrStat = data.result.ansrWan; 
	                if (ansrStat.trim() == ""  ||  ansrStat.trim() !== "Y") {
	                    lasqSeq  = data.result.asqSeq  ;
	                    lfileGb  = data.result.fileGb  ;  
	                    lregUser = data.result.regUser ;
	                    lregIp   = data.result.regIp ;
	                	fnasq_SaveProc(); // 즉시 삭제 실행
	                } else if (ansrStat === "Y") {
	                	messageBox("1", "<h6>답변완료된 항목은 삭제할 수 없습니다.!!</h6><p></p>", "", "", "");
	                } else {
	                    alert("답변 상태를 확인할 수 없습니다."); // ansrStat이 null 또는 undefined일 때
	                }

	            },
	            error: function () {
	                alert("삭제할 항목의 정보를 불러오는 중 오류가 발생했습니다.");
	            }
	        });
	    }
	}
	///////데이타 처리 루틴  
	function fnasq_SaveProc() {
	    var formData = {};
	    var msg = "";

	    if (uidGubun.substring(1, 2) != "D") {
	        if ( $("#qstnTitle").val() == "") { 
	            messageBox("1", "<h6>질문제목을 입력하세요.!!</h6><p></p>", "", "", "");
		        return; 
	        }         
	        if ( $("#qstnConts").val() == "") {
	            messageBox("1", "<h6>질문내용을 입력하세요.!!</h6><p></p>", "", "", "");
		        return; 
	        }         
		    formData = $("form[name='asq_regForm']").serialize();
		    
	    }else{
	        formData = {
	                   asqSeq:    lasqSeq,   // 문의글 고유번호
	                   fileGbasq: lfileGb,   // 파일구분
	                   iudasq:    uidGubun   // 처리 구분 (삭제: "D")
	                };
	    }
	    if (uidGubun.substring(1, 2) === "D") {
	        // 모달을 띄우고 "deleteAction"이라는 식별자로 구분
	        messageBox("2", "<h6>삭제 하시겠습니까?</h6><p></p>", "", "", "deleteAction");
	        
	    }else{
	    	 execute() ; 
	    }
	    window.modalClose = function(flag, jobs, yesno) {
	        console.log("modalClose 실행됨! flag:", flag, "jobs:", jobs, "yesno:", yesno);

	        if (jobs === "deleteAction") {
	            if (flag === "N") {
	    	        $("#messageDialog").modal("hide"); // 모달 닫기
	                return; // 'N'을 선택하면 아무 작업도 하지 않음
	            }
	            if (flag === "Y") {
	            	execute(); // 삭제 실행 함수 호출
	            }
	        }
	        $("#messageDialog").modal("hide"); // 모달 닫기
	    };
	    // 실제 삭제 로직을 실행하는 함수
	    function execute() {
	        $.ajax({
	            type: "post",
	            url: "${pageContext.request.contextPath}" + "/mangr/asqSaveAct.do",
	            data: formData,  // formData가 정의되어 있어야 함 
	            dataType: "json",
	            success: function (data) {
	                if (data.error_code !== "0") {
	                    alert(data.error_msg);
	                    return;
	                }
	                // 파일 업로드 처리
	                var asqFileInput = document.getElementById('asq-file-input');
	                if (asqFileInput && asqFileInput.files && asqFileInput.files.length > 0) {
	                    var seqVal = '';
	                    if (uidGubun === 'QI') {
	                        seqVal = data.asqSeq;
	                    } else if (uidGubun === 'QU') {
	                        seqVal = $("#asqSeq").val();
	                    }
	                    if (seqVal) {
	                        uploadAsqFiles(seqVal, data.hospCd || sessionStorage.getItem('s_hospid'), data.regUser || sessionStorage.getItem('s_userid'));
	                    }
	                }
	                $('#asq_main').modal('hide'); // 성공 시 모달 닫기
	                fnasq_Search();
	            },
	            error: function (xhr, status, error) {
	                console.log("에러 발생:", error);
	                alert("작업 중 오류가 발생했습니다.");
	            }
	        });
	    }

 	}

	// ====== 파일업로드 관련 함수 ======
	var asqSelectedFiles = new DataTransfer();

	function openAsqFileInput() {
	    document.getElementById('asq-file-input').click();
	}

	function asqHandleFiles(files) {
	    for (var i = 0; i < files.length; i++) {
	        asqSelectedFiles.items.add(files[i]);
	    }
	    document.getElementById('asq-file-input').files = asqSelectedFiles.files;
	    asqShowNewFileList();
	}

	function asqDropHandler(event) {
	    var files = event.dataTransfer.files;
	    asqHandleFiles(files);
	}

	function asqShowNewFileList() {
	    var html = '';
	    var files = asqSelectedFiles.files;
	    for (var i = 0; i < files.length; i++) {
	        html += '<div class="file-item" style="display:flex; align-items:center; justify-content:space-between; padding:3px 8px; border-bottom:1px solid #eee;">' +
	            '<span><i class="fa fa-file" style="color:#555; margin-right:5px;"></i>' + files[i].name +
	            ' (' + Math.round(files[i].size / 1024) + 'KB)</span>' +
	            '<button type="button" onclick="asqRemoveNewFile(' + i + ')" class="delete-btn" style="border:none; background:none; color:red; cursor:pointer; font-size:12px;">삭제</button>' +
	            '</div>';
	    }
	    document.getElementById('asq-file-list-new').innerHTML = html;
	}

	function asqRemoveNewFile(index) {
	    var newDt = new DataTransfer();
	    var files = asqSelectedFiles.files;
	    for (var i = 0; i < files.length; i++) {
	        if (i !== index) newDt.items.add(files[i]);
	    }
	    asqSelectedFiles = newDt;
	    document.getElementById('asq-file-input').files = asqSelectedFiles.files;
	    asqShowNewFileList();
	}

	function uploadAsqFiles(asqSeq, hospCd, regUser) {
	    var files = document.getElementById('asq-file-input').files;
	    if (!files || files.length === 0) return;

	    var formData = new FormData();
	    for (var i = 0; i < files.length; i++) {
	        formData.append('file', files[i]);
	    }
	    formData.append('hospCd', hospCd || '');
	    formData.append('fileGb', '4');
	    formData.append('notiSeq', asqSeq);
	    formData.append('regUser', regUser || '');
	    formData.append('regIp', '');

	    $.ajax({
	        url: '${pageContext.request.contextPath}/sftp/fileupload.do',
	        type: 'POST',
	        data: formData,
	        processData: false,
	        contentType: false,
	        success: function(res) {
	            console.log('파일 업로드 성공:', res);
	            fnasq_Search(); // 그리드 새로고침 (첨부 아이콘 반영)
	        },
	        error: function(xhr) {
	            console.log('파일 업로드 실패:', xhr.responseText);
	        }
	    });
	}

	function showAsqFileList(asqSeq) {
	    if (!asqSeq) { $("#asq-file-table").hide(); return; }

	    $.ajax({
	        url: '${pageContext.request.contextPath}/mangr/fileCdList.do',
	        type: 'POST',
	        data: { fileSeq: asqSeq, fileGb: '4' },
	        dataType: 'json',
	        success: function(data) {
	            var tbody = document.getElementById('asq-file-tbody');
	            tbody.innerHTML = '';
	            if (data && data.length > 0) {
	                for (var i = 0; i < data.length; i++) {
	                    var subCodeNm = data[i].subCodeNm || '문서';
	                    var fileTitle = data[i].fileTitle || '제목 없음';
	                    var fileSize  = data[i].fileSize  || '';
	                    var regDttm   = data[i].regDttm   || '';
	                    var fileUrl   = '#';
	                    if (data[i].filePath && data[i].fileTitle) {
	                        fileUrl = '${pageContext.request.contextPath}/sftp/download.do?filePath=' + encodeURIComponent(data[i].filePath);
	                    }
	                    var row = '<tr style="border-bottom: 1px solid #eee;">';
	                    row += '<td style="text-align:center; padding:6px 4px; color:#555;">' + (i + 1) + '</td>';
	                    row += '<td style="text-align:center; padding:6px 4px; color:#555;">' + subCodeNm + '</td>';
	                    row += '<td style="padding:6px 8px;"><a href="javascript:void(0);" onclick="window.open(\'' + fileUrl + '\');" style="color:#2874A6; text-decoration:none; font-weight:500;" onmouseover="this.style.color=\'#1a5276\'; this.style.textDecoration=\'underline\';" onmouseout="this.style.color=\'#2874A6\'; this.style.textDecoration=\'none\';">' + fileTitle + '</a></td>';
	                    row += '<td style="text-align:center; padding:6px 4px; color:#555;">' + fileSize + ' KB</td>';
	                    row += '<td style="text-align:center; padding:6px 4px; color:#555;">' + regDttm + '</td>';
	                    // 삭제 버튼 (휴지통 아이콘)
	                    row += '<td style="text-align:center; vertical-align:middle; padding:6px 4px;">';
	                    row += "<a href='javascript:void(0);' onclick=\"deleteAsqFile('" + data[i].filePath + "','" + asqSeq + "');\" title='삭제' style='color:black;'>";
	                    row += "<i class='fa-solid fa-trash' style='font-size: 1.1em;'></i>";
	                    row += '</a></td>';
	                    // 다운로드 버튼 (디스켓 아이콘)
	                    row += '<td style="text-align:center; vertical-align:middle; padding:6px 4px;">';
	                    if (fileUrl !== '#') {
	                        row += "<a href='javascript:void(0);' onclick=\"window.open('" + fileUrl + "');\" title='다운로드' style='color:#28a745;'>";
	                        row += "<i class='fa-solid fa-floppy-disk' style='font-size: 1.1em;'></i>";
	                        row += '</a>';
	                    }
	                    row += '</td>';
	                    row += '</tr>';
	                    tbody.innerHTML += row;
	                }
	                $("#asq-file-table").show();
	            } else {
	                tbody.innerHTML = "<tr><td colspan='7' style='text-align:center; color:#999;'>등록된 파일이 없습니다.</td></tr>";
	                $("#asq-file-table").show();
	            }
	        }
	    });
	}

	function deleteAsqFile(filePath, asqSeq) {
	    Swal.fire({
	        title: '삭제여부',
	        text: '파일을 삭제하시겠습니까?',
	        icon: 'question',
	        showCancelButton: true,
	        confirmButtonText: '예',
	        cancelButtonText: '아니오',
	        customClass: { popup: 'small-swal' }
	    }).then((result) => {
	        if (result.isConfirmed) {
	            var savedTitle = $("#qstnTitle").val();
	            var savedConts = $("#qstnConts").val();
	            var savedAnsr  = $("#ansrConts").val();
	            var savedWan   = $("#ansrWan").val();

	            $.ajax({
	                url: '${pageContext.request.contextPath}/sftp/deleteFile.do',
	                type: 'POST',
	                data: {
	                    hospCd: sessionStorage.getItem('s_hospid') || '',
	                    filePath: filePath,
	                    fileSeq: asqSeq,
	                    fileGb: '4',
	                    updUser: sessionStorage.getItem('s_userid') || '',
	                    updIp: ''
	                },
	                success: function(res) {
	                    console.log('파일 삭제 성공:', res);
	                    $("#qstnTitle").val(savedTitle);
	                    $("#qstnConts").val(savedConts);
	                    $("#ansrConts").val(savedAnsr);
	                    $("#ansrWan").val(savedWan);
	                    showAsqFileList(asqSeq);
	                    // 그리드 파일아이콘 갱신 (파일 남아있는지 확인)
	                    $.ajax({
	                        url: '${pageContext.request.contextPath}/mangr/fileCdList.do',
	                        type: 'POST',
	                        data: { fileSeq: asqSeq, fileGb: '4' },
	                        dataType: 'json',
	                        success: function(fileData) {
	                            var row = document.getElementById('row_' + asqSeq);
	                            if (row) {
	                                var fileCell = row.getElementsByTagName('td')[5];
	                                if (fileCell) {
	                                    fileCell.innerHTML = (fileData && fileData.length > 0)
	                                        ? '<i class="fa-solid fa-floppy-disk" title="파일 있음" style="color: green; font-size:15px;"></i>'
	                                        : '';
	                                }
	                            }
	                        }
	                    });
	                    Swal.fire({
	                        title: '삭제완료',
	                        text: '파일이 삭제되었습니다.',
	                        icon: 'success',
	                        confirmButtonText: '확인',
	                        customClass: { popup: 'small-swal' }
	                    });
	                },
	                error: function(xhr) {
	                    Swal.fire({
	                        title: '삭제실패',
	                        text: '파일 삭제에 실패하였습니다.',
	                        icon: 'error',
	                        confirmButtonText: '확인',
	                        customClass: { popup: 'small-swal' }
	                    });
	                }
	            });
	        } else if (result.isDismissed) {
	            Swal.fire({
	                title: '취소',
	                text: '삭제가 취소되었습니다.',
	                icon: 'info',
	                confirmButtonText: '확인',
	                customClass: { popup: 'small-swal' }
	            });
	        }
	    });
	}

	function asqFileClear() {
	    asqSelectedFiles = new DataTransfer();
	    var fileInput = document.getElementById('asq-file-input');
	    if (fileInput) fileInput.value = '';
	    document.getElementById('asq-file-list-new').innerHTML = '';
	    document.getElementById('asq-file-tbody').innerHTML = '';
	    $("#asq-file-table").hide();
	}

	// 답변자 첨부파일 조회 (FILE_GB='5')
	function showAnsrFileList(asqSeq) {
	    if (!asqSeq) { $("#ansr-file-area").hide(); return; }

	    $.ajax({
	        url: '${pageContext.request.contextPath}/mangr/fileCdList.do',
	        type: 'POST',
	        data: { fileSeq: asqSeq, fileGb: '5' },
	        dataType: 'json',
	        success: function(data) {
	            var tbody = document.getElementById('ansr-file-tbody');
	            tbody.innerHTML = '';
	            if (data && data.length > 0) {
	                for (var i = 0; i < data.length; i++) {
	                    var subCodeNm = data[i].subCodeNm || '문서';
	                    var fileTitle = data[i].fileTitle || '제목 없음';
	                    var fileSize  = data[i].fileSize  || '';
	                    var regDttm   = data[i].regDttm   || '';
	                    var fileUrl   = '#';
	                    if (data[i].filePath && data[i].fileTitle) {
	                        fileUrl = '${pageContext.request.contextPath}/sftp/download.do?filePath=' + encodeURIComponent(data[i].filePath);
	                    }
	                    var row = '<tr style="border-bottom: 1px solid #eee;">';
	                    row += '<td style="text-align:center; padding:6px 4px; color:#555;">' + (i + 1) + '</td>';
	                    row += '<td style="text-align:center; padding:6px 4px; color:#555;">' + subCodeNm + '</td>';
	                    row += '<td style="padding:6px 8px;"><a href="javascript:void(0);" onclick="window.open(\'' + fileUrl + '\');" style="color:#2874A6; text-decoration:none; font-weight:500;" onmouseover="this.style.color=\'#1a5276\'; this.style.textDecoration=\'underline\';" onmouseout="this.style.color=\'#2874A6\'; this.style.textDecoration=\'none\';">' + fileTitle + '</a></td>';
	                    row += '<td style="text-align:center; padding:6px 4px; color:#555;">' + fileSize + ' KB</td>';
	                    row += '<td style="text-align:center; padding:6px 4px; color:#555;">' + regDttm + '</td>';
	                    // 다운로드 아이콘
	                    row += '<td style="text-align:center; vertical-align:middle; padding:6px 4px;">';
	                    if (fileUrl !== '#') {
	                        row += "<a href='javascript:void(0);' onclick=\"window.open('" + fileUrl + "');\" title='다운로드' style='color:#28a745;'>";
	                        row += "<i class='fa-solid fa-floppy-disk' style='font-size: 1.1em;'></i>";
	                        row += '</a>';
	                    }
	                    row += '</td>';
	                    row += '</tr>';
	                    tbody.innerHTML += row;
	                }
	                $("#ansr-file-area").show();
	            } else {
	                tbody.innerHTML = "<tr><td colspan='6' style='text-align:center; color:#999;'>등록된 파일이 없습니다.</td></tr>";
	                $("#ansr-file-area").show();
	            }
	        }
	    });
	}

</script>
	<!-- 질의응답스크립트 종료 -->
	<!-- FAQ 모달 -->
<!-- FAQ 모달 -->


<div class="modal fade" id="faqModal" tabindex="-1" aria-labelledby="faqModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
  <div class="modal-dialog modal-lg" style="margin-top: 5px;"> <!-- 여기 추가 -->
    <div class="modal-content" style="max-height: 900px;"> <!-- 높이 제한 -->
      <div class="modal-header">
        <h5 class="modal-title" id="faqModalLabel">자주 묻는 질문 (FAQ)</h5>
        <button type="button" class="btn btn-outline-dark" data-dismiss="modal" onclick="faqMainClose()">
          닫기 <i class="fas fa-times"></i>
        </button>
      </div>
      <div class="modal-body" style="max-height: 700px; overflow-y: auto;">
        <div class="input-group mb-3">
          <input type="text" id="faqSearchInput" class="form-control" placeholder="검색어를 입력하세요" onkeypress="if(event.keyCode===13) searchFaq();">
          <div class="input-group-append">
            <button class="btn btn-primary" type="button" onclick="searchFaq();">
              <i class="fas fa-search"></i> 검색
            </button>
          </div>
        </div>
        <div id="faqList">
          <p class="text-muted text-center">FAQ 데이터를 불러오려면 버튼을 클릭하세요.</p>
        </div>
      </div>
    </div>
  </div>
</div>

	<!-- 자주하는 질문 스크립트 시작-->
	<script>
	function loadFaqData(keyword) {
	    if (!sessionStorage.getItem('s_hospid')) {
	        messageBox("1", "<h6>로그인 하고 진행하세요.!!</h6><p></p>", "", "", "");
	        return;
	    }
        // 모달 열기
        $('#faqModal').modal('show');

        // FAQ 리스트 초기화
        $("#faqList").html(`<p class="text-muted text-center"></p>`);

        var searchKeyword = keyword || "";

        // AJAX로 FAQ 데이터 요청

        $.ajax({
        	type: "post",
        	url: "${pageContext.request.contextPath}/mangr/getfaqCdList.do",
            data: { qstnConts: searchKeyword, ansrConts: searchKeyword },
            dataType: "json",
            success: function (response) {
            	if (response.error_code === "0" && Array.isArray(response.resultLst) && response.resultLst.length > 0) {
            		$.each(response.resultLst, function (index, faq) {
                        let question = String(faq.qstnConts || "질문이 없습니다.").trim();
                        let answer   = String(faq.ansrConts || "답변이 없습니다.").trim();

                        // faq-item 전체 묶음 div
                        let faqItem = $("<div>", { class: "faq-item" });

                        // 질문 div
						let faqQuestion = $("<div>", {
						    class: "faq-question",
						    style: "font-size: 14px;"  // 글자 크기 조절
						}).text(question);

                        // ▼ 아이콘
                        let arrowSpan = $("<span>", { class: "arrow" }).text("▼");
                        faqQuestion.append(arrowSpan);

                        // 답변 div
                        let faqAnswer = $("<div>", {
                            class: "faq-answer",
                            style: "display: none;"
                        });

                        // textarea ID를 유니크하게 생성
                        let textareaId = "faqTextarea_" + index;

                        // textarea 생성
                        let textarea = $("<textarea>", {
                            id: textareaId,
                            class: "faq-textarea"
                        }).val(answer);

                        faqAnswer.append(textarea);
                        faqItem.append(faqQuestion).append(faqAnswer);
                        $("#faqList").append(faqItem);

                        // click 이벤트 바인딩 (각 item별)
                        faqQuestion.on("click", function () {
                            let $thisItem = $(this).closest(".faq-item");

                            if ($thisItem.hasClass("active")) {
                                // 열려있으면 닫기
                                $thisItem.removeClass("active").find(".faq-answer").slideUp();
                                $thisItem.find(".arrow").text("▼");

                                // Summernote 제거
                                if ($("#" + textareaId).hasClass("summernote")) {
                                    $("#" + textareaId).summernote('destroy');
                                }
                            } else {
                                // 다른 항목 닫기 및 summernote 제거
                                $(".faq-item").each(function () {
                                    $(this).removeClass("active").find(".faq-answer").slideUp();
                                    $(this).find(".arrow").text("▼");

                                    let $ta = $(this).find("textarea");
                                    if ($ta.hasClass("summernote")) {
                                        $ta.summernote('destroy');
                                    }
                                });

                                // 현재 항목 열기
                                $thisItem.addClass("active").find(".faq-answer").slideDown();
                                $thisItem.find(".arrow").text("▲");
                                
                                let convertedAnswer = answer.replace(/\n/g, "<br>"); // 줄바꿈 → <br>

    	                         // Summernote 적용
    	                         $("#" + textareaId).summernote({
    	                             height: 300,
    	                             lang: 'ko-KR',
    	                             toolbar: [
    	                                 ['style', ['style']],
    	                                 ['font', ['bold', 'italic', 'underline', 'clear']],
    	                                 ['fontname', ['fontname']],
    	                                 ['fontsize', ['fontsize']],
    	                                 ['color', ['color']],
    	                             ],
    	                             fontNames: ['Arial', 'Arial Black', 'Comic Sans MS', 'Courier New', '맑은 고딕', '굴림체', '돋움체'],
    	                             fontNamesIgnoreCheck: ['맑은 고딕', '굴림체', '돋움체'],
    	                             callbacks: {
    	                                 onInit: function () {
    	                                     $('.note-editable').css('font-size', '14px');
    	                                     $("#" + textareaId).next(".note-editor").find(".note-toolbar").hide();
    	
    	                                     // 줄바꿈 처리된 내용 넣기
    	                                     $("#" + textareaId).summernote('code', convertedAnswer);
    	                                 }
    	                             }
    	                         });
                            }
                        });
                    });
                } else {
                    $("#faqList").html(`<p class="text-muted text-center">검색된 결과가 없습니다.</p>`);
                }
	            
				console.log("📢 FAQ 데이터 로드 완료");
            },
            error: function () {
                $("#faqList").html(`<p class="text-danger text-center">FAQ 데이터를 불러오는 중 오류가 발생했습니다.</p>`);
            }
        });
    }

	// FAQ 검색
	function searchFaq() {
	    var keyword = $.trim($("#faqSearchInput").val());
	    loadFaqData(keyword);
	}

	// FAQ 모달 닫기
	function faqMainClose() {
	    console.log("📢 FAQ 모달 닫힘 실행");
	    $('#faqModal').modal('hide');
	}  

</script>

	<!-- 자주하는 질문 스크립트 종료  -->
	<script type="text/javascript">
        var confirm_red = [];  
    	$(document).ready(function () {
	        // 모달이 열릴 때 스타일 적용
	        $('#mainModal, #termsModal, #searchModal, #asq_main').on('show.bs.modal', function () {
	            $('.modal-backdrop').css('background', 'rgba(0, 0, 0, 0.2)'); // 투명도 조정
	        });
	
	        // 모달이 닫힐 때 기존 설정 유지
	        $('#mainModal, #termsModal, #searchModal , #asq_main').on('hidden.bs.modal', function () {
	            $('.modal-backdrop').css('background', 'rgba(0, 0, 0, 0.5)');
	        });
	        /*공지사항띄우기*/ 
	        callMultipleSearch() ;
	        //funcommlist() ;
   
	    
	    });
 
   		window.addEventListener('unload', () => {    	
        	logout();
    	});
   		
   		
   		function openImagePopup(imgUrl) {
   			window.open('popup.jsp?img=' + encodeURIComponent(imgUrl),
   			            'imgPopup',
		    	        'width=1080,height=1350,resizable=no,scrollbars=no');
    	}
   		
    	// 자식 창 변수
        let win_Check;
        window.onload = function() {
        	
        	// openMyImagePopup_1('/wnn_consult/images/winct/popup2.jpg');
        	
            if (getCookie("saveyn")) {
                document.loginForm.saveyn.checked  = true;
                document.loginForm.passwd.focus();
            } /* else {
                document.loginForm.autoyn.checked  = false;
                document.loginForm.autoyn.disabled = true;
            } */

            /*
            if (getCookie("autoyn")) {
                document.loginForm.autoyn.checked = true;
            } 
            */
            if (getCookie("hospid")) {
                document.loginForm.hospid.value = getCookie("hospid"); 
            } else {
            	document.loginForm.hospid.focus();
            }
            	 
            if (getCookie("userid")) {
                document.loginForm.userid.value = getCookie("userid"); 
            }
            /*
            if (getCookie("passwd")) {
                document.loginForm.passwd.value = getCookie("passwd");
            }
            */
            /*
            if (getCookie("autoyn") && getCookie("hospid") && getCookie("userid") && getCookie("passwd")) {
                login();
            }
            */
            
        }

        function login() {
        	
        	if    ($("#hospid").val().trim() === "" ){                
                messageBox("1","<h5>Hospital Number를 입력해 주세요 !!</h5><p></p><br>","hospid","","");                
            } else if ($("#userid").val().trim() === "" ){
            	messageBox("1","<h5>User ID를 입력해 주세요 !!</h5><p></p>","userid","","");    
            	
            	/*
            	// Yes후 여기서 처리할 로직 구현 
            	messageBox("9","<br> User ID를 입력해 주세요 !! <br>","userid","","");
            	confirmYes.addEventListener('click', () => {
            		messageDialog.hide();
                });
            	*/
            } else if ($("#passwd").val().trim() === "" ){
                messageBox("1","<h5>PassWord를 입력해 주세요 !!</h5><p></p>","passwd","","");
            	
            } else {

                if (document.loginForm.saveyn.checked === false){
                    
                    /* document.loginForm.autoyn.checked = false; */
                    /* document.loginForm.autoyn.disabled = true; */

                    // 모든쿠키 값 제거
                    setCookie("saveyn", "N", 0);                
                    /* setCookie("autoyn", "N", 0); */
                    setCookie("hospid", document.loginForm.hospid.value, 0); // 날짜를 0으로 저장하여 쿠키삭제
                    setCookie("userid", document.loginForm.userid.value, 0); // 날짜를 0으로 저장하여 쿠키삭제
                    setCookie("passwd", document.loginForm.passwd.value, 0); // 날짜를 0으로 저장하여 쿠키삭제

                } else {
                    //"saveyn"이라는 키 값에 "Y" 값 셋팅
                    setCookie("saveyn", "Y", 30); 
                    //"hospid"라는 키 값에 form에 입력한 HospID 값 셋팅
                    setCookie("hospid", document.loginForm.hospid.value, 30);
                    //"userid"라는 키 값에 form에 입력한 UserID 값 셋팅
                    setCookie("userid", document.loginForm.userid.value, 30);
					
                    /*
                    if (document.loginForm.autoyn.checked === true){
                        //"passwd"라는 키 값에 form에 입력한 PassWD 값 셋팅
                        setCookie("passwd", document.loginForm.passwd.value, 30); 
                        setCookie("autoyn", "Y", 30); 
                    } else {
                        setCookie("autoyn", "N", 0);
                    }
                    */
                }
                loginSession();
            }
        }

        function setCookie(name, value, expiredays) {
            var todayDate = new Date();
            todayDate.setDate(todayDate.getDate() + expiredays);
            document.cookie = name + "=" + escape(value) + "; path=/; expires=" + todayDate.toGMTString() + ";"
        }

        function getCookie(name) {
            var search = name + "=";
            if (document.cookie.length > 0) {
                offset = document.cookie.indexOf(search);
                if (offset != -1) {                             // 쿠키 존재 시 
                    offset += search.length;                    // 첫번째 값의 인덱스 셋팅 
                    end = document.cookie.indexOf(";", offset); // 마지막 쿠키 값의 인덱스 셋팅
                    if (end == -1)
                        end = document.cookie.length;
                    return unescape(document.cookie.substring(offset, end));
                }
            }
        }
        
        // 로그인 요청
        function loginSession() {
        	
        	// 로딩화면 표시
        	// LoadingUI.show({ position: 'center' });            // 화면 중앙
        	LoadingUI.show({ position: 'cursor', event: event }); // 커서 위치
        	
        	
        	$.ajax({
        	    type: "POST",
        	    url: "${pageContext.request.contextPath}" + "/user/loginChk.do",
        	    data: {
			        hospCd: document.loginForm.hospid.value,
			        userId: document.loginForm.userid.value,
			        passWd: document.loginForm.passwd.value
			    },
        	    dataType: "json",
        	    
        	    success: function (data) {
        	    	
        	    	if (data.error_code === "00000") {
        	    		
        	            if (data.login_User){
        	            	
	        	            sessionStorage.clear();
	        	            
	        				sessionStorage.setItem('s_hospid', $("#hospid").val().trim());  // sessionStorage에 로그인 병원코드
	        				sessionStorage.setItem('s_userid', $("#userid").val().trim());  // sessionStorage에 로그인 사용자id
	        				sessionStorage.setItem('s_hospnm', data.login_Hosp); 			// sessionStorage에 로그인 병원명
	        				sessionStorage.setItem('s_usernm', data.login_User); 			// sessionStorage에 로그인 사용자명
	        				sessionStorage.setItem('s_connip', data.login_Connip); 		    // sessionStorage에 아이피  
	        				///
	        				sessionStorage.setItem('s_wnn_yn', data.login_WnnYN); 	        ////tbl_hosp_mst 워너넷여부 
	        				sessionStorage.setItem('s_conact_gb', data.login_ConactGB);     // tbl_hospcont테이블을 (진료비,적정성(A), 진료비 '1' 적정성 '2' ,else 'N') 
	        				sessionStorage.setItem('s_mainfg', data.login_Main); 			// sessionStorage에 로그인 관리자구분(1.위너넷관리자, 2.위너넷사용자, 3.병원관리자, 4.병원사용자)
	        				sessionStorage.setItem('s_use_yn', data.loginUseYN); 			// 사용여부(Y,정상사용자, N.종료사용자)기간 
	        				sessionStorage.setItem('s_use_can', data.loginUseCan); 			// 사용여부(Y,정상사용자, N.종료사용자) y.n
	        				sessionStorage.setItem('s_hosp_uuid', $("#hospid").val().trim()); //위너넷이 접속시 데이타연관성 확인  
	        				sessionStorage.setItem('s_insauth', data.login_insAuth); //입력권한 
	        				sessionStorage.setItem('s_updauth', data.login_updAuth); //수정권한 
	        				sessionStorage.setItem('s_delauth', data.login_delAuth); //삭제권한 
	        				sessionStorage.setItem('s_inqauth', data.login_inqAuth); //조회권한 
	        				sessionStorage.setItem('s_last_dttm', data.login_Last_Condttm); 	        //// 최종접속일자  
	        				sessionStorage.setItem('s_last_user', data.login_Last_Conuser); 	        //// 최종접속자  
	        				showUserInfo(); 
        				
	        	            winCheckOpen();
	        				
        	            } else {
        	            	// 세션 초기화
        	        	    sessionStorage.clear();
        	        	    // 화면 초기화
        	        	    location.reload();
        	            }
        	        } else {
        	        	
        	        	if (data.error_code === "10000") {
        	        		messageBox("4","<h6>사용자 정보가 존재하지 않습니다.</h6><p></P>" +
        	        				       "<h6>로그인 정보를 확인하고 다시 로그인하십시요 !!</h6>","hospid","","");
        	        		document.loginForm.hospid.value = "";
        	        		document.loginForm.userid.value = "";
        	        		document.loginForm.passwd.value = "";
        	        	} else if (data.error_code === "10001") { //계약정보(진료비,적정성(A), 진료비 '1' 적정성 '2' ,else 'N')
        	        		messageBox("4","<h6>계약관련 사용권한을 확인하세요 !!</h6><p></P>" +
 	        				       "<h6>로그인 정보를 확인하고 다시 로그인하십시요 !!</h6>","hospid","","");
        	        	} else if (data.error_code === "10002") { //사용여부 Y ,N)    // 협의후 판단  
        	        		messageBox("4","<h6>사용여부를 확인하세요 !!</h6><p></P>" +
 	        				       "<h6>사용자 사용여부를 확인하고 로그인하세요 !!</h6>","hospid","","");
        	        	
        	        	} else if (data.error_code === "20000") {
        	        		
        	        		messageBox("4","<h5>비밀번호가 맞지 않습니다.</h5><p></P>" +
 	        				               "<h6>비밀번호를 확인 후 다시 로그인하십시요 !!</h6>","passwd","","");
 	        				document.loginForm.passwd.value = "";
 	        				
        	        	} else if (data.error_code === "90001") {
        	        		messageBox("5","<h5>Error No.90001</h5><p></p>" +
        	        				       "<h5>서버에 문제가 발생했습니다.</h5>" +  
 				                           "<h6>잠시후 다시, 시도해주십시요. !!</h6>","","","");
        	        		logout();
        	        	}
        	        }
        	    },        	    
        	    error: function (xhr, status, error) {
        	    	messageBox("5","<h5>Error No.90002</h5><p></p>" +
     				               "<h5>서버에 문제가 발생했습니다.</h5>" +  
	                               "<h6>잠시후 다시, 시도해주십시요. !!</h6>","","","");
        	    	logout();
        	    },        	    
        	    complete: function() {        	    	
                    LoadingUI.hide();
                }
        	});
        }
        function showUserInfo(login_user_name) {
        	if (sessionStorage.getItem('s_hospid') !== null && sessionStorage.getItem('s_hospid') !== '') {
        		
        		const form_Element = document.getElementById('loginForm');
                const userInfoCard = document.getElementById('userInfoCard');
                
        	    document.getElementById('hosp_name').textContent = sessionStorage.getItem('s_hospnm'); //접속병원  
                var lastDttm = sessionStorage.getItem('s_last_dttm');
                if (lastDttm) {
                   document.getElementById('last_dttm').textContent = lastDttm ; //접속시간 
                } 
                if (form_Element) {
                    userInfoCard.style.height = `${form_Element.offsetHeight}px`;
                    userInfoCard.style.Width  = `${form_Element.offsetWidth}px`;
                }
                
                form_Element.style.display = 'none';
                userInfoCard.style.display = 'block';
                GetReportList() ;
            }
    	}

    	function logout() {
    		
    		if (win_Check && !win_Check.closed) {
                // 기존 창이 열려 있으면 닫기
                win_Check.close();
            }
    		
    		setCookie("s_hospid", "", 0);
        	setCookie("s_userid", "", 0);
        	setCookie("s_hospnm", "", 0);
        	setCookie("s_usernm", "", 0);
        	setCookie("s_mainfg", "", 0);
        	setCookie("s_use_yn", "", 0);
        	setCookie("s_use_can", "", 0);
        	setCookie("s_hospuuid", "", 0);
        	setCookie("s_connip", "", 0);
        	setCookie("s_wnn_yn", "", 0);  //tbl_hosp_mst 워너넷여부 
        	setCookie("s_last_dttm", "", 0);  //tbl_hosp_mst 최종접속일자 
        	setCookie("s_last_user", "", 0);  //tbl_hosp_mst 최종접속자  
        	setCookie("s_hosp_uuid", "", 0);  // 
        	//tbl_hospcont테이블 (진료비,적정성(A), 진료비 '1' 적정성 '2' ,else 'N' 
        	setCookie("s_conact_gb", "", 0); 
        	setCookie("s_winconect", "", 0);
        	setCookie("s_insauth", "", 0); //입력권한
        	setCookie("s_updauth", "", 0); //수정권한 
        	setCookie("s_delauth", "", 0); //삭제권한 
        	setCookie("s_inqauth", "", 0); //조회권한 
    		// 세션 초기화
    	    sessionStorage.clear();    	 	
    	 	// 화면 초기화
    	    location.reload();
    	}
        function winCheckOpen() {
        	if (sessionStorage.getItem('s_hospnm') == ""  || sessionStorage.getItem('s_hospnm') == null  ) {
        		messageBox("1", "<h6>로그인 하고 진행하세요.!!</h6><p></p>", "", "", "");
        	    return;
        	}
        	if (win_Check && !win_Check.closed) {
                // 기존 창이 열려 있으면 닫기
                win_Check.close();
            }
        	
        	setCookie("s_hospid", sessionStorage.getItem('s_hospid'), 1);
        	setCookie("s_userid", sessionStorage.getItem('s_userid'), 1);
        	setCookie("s_hospnm", sessionStorage.getItem('s_hospnm'), 1);
        	setCookie("s_usernm", sessionStorage.getItem('s_usernm'), 1);
        	setCookie("s_mainfg", sessionStorage.getItem('s_mainfg'), 1);
        	setCookie("s_use_yn", sessionStorage.getItem('s_use_yn'), 1);
        	setCookie("s_use_can", sessionStorage.getItem('s_use_can'), 1);
        	setCookie("s_connip", sessionStorage.getItem('s_connip'), 1);
        	setCookie("s_wnn_yn", sessionStorage.getItem('s_wnn_yn'), 1);
        	setCookie("s_last_dttm", sessionStorage.getItem('s_last_dttm'), 1);
        	setCookie("s_last_user", sessionStorage.getItem('s_last_user'), 1);
        	setCookie("s_hosp_uuid", sessionStorage.getItem('s_hospid'), 1);
        	//tbl_hospcont테이블 (진료비,적정성(A), 진료비 '1' 적정성 '2' ,else 'N') 
        	setCookie("s_conact_gb", sessionStorage.getItem('s_conact_gb'), 1); //계약구분  
        	setCookie("s_insauth", sessionStorage.getItem('s_insauth'), 1); //입력권한
        	setCookie("s_updauth", sessionStorage.getItem('s_updauth'), 1); //수정권한  
        	setCookie("s_delauth", sessionStorage.getItem('s_delauth'), 1); //삭제권한  
        	setCookie("s_inqauth", sessionStorage.getItem('s_inqauth'), 1); //조회권한  
    		
      	
        	hosp_conact() ;
        	
        //  const url = "http://localhost:8080/user/";    
        //  const url = "https://winner797.co.kr/user/dashboard.do";
            const url = window.location.hostname === 'localhost' || window.location.hostname === '127.0.0.1'
                    ? "http://localhost:8080/user/"
                    : "https://winner797.co.kr/user/dashboard.do";
        	
            win_Check = window.open(url);            
            
            win_Check.addEventListener('unload', () => {
                // 창이 닫혔을 때
                document.loginForm.hospid.disabled = false;
                document.loginForm.userid.disabled = false;
                document.loginForm.passwd.disabled = false;
                document.loginForm.blogin.disabled = false; 
            });
            win_Check.addEventListener('load', function() {
                // 창이 열렸을 때
                document.loginForm.hospid.disabled = true;
                document.loginForm.userid.disabled = true;
                document.loginForm.passwd.disabled = true;
                document.loginForm.blogin.disabled = true;
            });
           
        }
		function fnPasswdmanager(){ 
		    document.getElementById('pwserchregForm').reset();
	        $('#passserachModal').modal('show');
		}
		function fnPasswdmanagerClose(){ 
	        $('#passserachModal').modal('hide');
		}
		function fnPasswdreset(){ 
		    document.getElementById('pwresetregForm').reset();
            if (sessionStorage.getItem('s_hospid') !== "" && sessionStorage.getItem('s_hospid') !== null ) {
                document.getElementById('hospCd1').value = sessionStorage.getItem('s_hospid');
            }
	        $('#pwresetForm').modal('show');
		}
		function fnPasswdresetClose(){ 
	        $('#pwresetForm').modal('hide');
	        
	        $('#passserachModal').modal('hide');
		}		
        document.addEventListener('DOMContentLoaded', function () {
        	emailcheck();
            const modals = document.querySelectorAll('.modal');
            modals.forEach(modal => {
                modal.addEventListener('click', function (event) {
                    if (event.target === modal) {
                        event.stopPropagation();
                    }
                });
            });

            const userInfoCard = document.getElementById("userInfoCard");
            const user_name    = document.getElementById("user_name");
            
            if (userInfoCard && user_name) {
                const len = 3;
                // 듀얼 모니터 이동 시 스크롤 유지 (창 크기 변경 감지)
                window.addEventListener("resize", function () {
                    setTimeout(() => {
                        userInfoCard.scrollTop = userInfoCard.scrollHeight / len;
                    }, 100); // 리사이즈 후 일정 시간 딜레이 후 적용
                });
            
                userInfoCard.style.overflow = "hidden";
            }
        });
		// 병원검색 /js/winct/schcommons.js///////////////
		$("#hospserch").on("click", function () {
			openHospitalSearch(function (data) {
		        $("#hospCd").val(data.hospCd);
		        $("#hospNm").val(data.hospNm);
		        hospcont_search();
		    });
		});
		
		function openHospitalSearch(callback) {
		    openCommonSearch("hospital", function (data) {
		        console.log("받은 병원 데이터:", data);

		        // ✅ 데이터가 올바른지 검증 후 실행
		        if (data && data.hospCd) {
		            callback(data);
		        } else {
		            console.warn("🚨 유효하지 않은 병원 데이터:", data);
		            alert("선택한 병원의 정보가 올바르지 않습니다. 다시 시도해주세요.");
		        }
		    });
		}
		// 스크롤 시 버튼 표시
		window.onscroll = function () {
		  const btn = document.getElementById("btnTop");
		  if (document.body.scrollTop > 0 || document.documentElement.scrollTop > 0) {
		    btn.style.display = "flex";
		  } else {
		    btn.style.display = "none";
		  }
		};
		//이전3개월 처리내용
		function GetReportList() {	    
		    $.ajax({
		        type: "post",
		        url: "${pageContext.request.contextPath}" + "/user/getReportList.do",
		        data: { hospCd: sessionStorage.getItem('s_hospid') },
		        dataType: "json",
		        success: function (data) {
		        	console.log("서버 응답 데이터:", data);
		            const admin = data[0] || {};
		            const cost  = data[1] || {};
		            document.getElementById('admin_three').textContent = admin.month3 ||'-';
		            document.getElementById('admin_two').textContent   = admin.month2 ||'-';
		            document.getElementById('admin_one').textContent   = admin.month1 ||'-';

		            document.getElementById('cost_three').textContent  = cost.month3  ||'-';
		            document.getElementById('cost_two').textContent    = cost.month2  ||'-';
		            document.getElementById('cost_one').textContent    = cost.month1  ||'-';
		        },
		        error: function (xhr, status, error) {
		            // 요청 실패 시에도 안전하게 '-' 처리
		            document.getElementById('admin_three').textContent = '-';
		            document.getElementById('admin_two').textContent   = '-';
		            document.getElementById('admin_one').textContent   = '-';
		            document.getElementById('cost_three').textContent  = '-';
		            document.getElementById('cost_two').textContent    = '-';
		            document.getElementById('cost_one').textContent    = '-';
		            console.error("데이터 요청 실패:", error);
		        }
		    });	  
		    setPreviousMonths();
		}
		/* 현재달기준 -1개월  */
	    function setPreviousMonths() {
	        var today = new Date();

	        // 각각 이전 달부터 3개월 전까지 계산
	        var prev1 = new Date(today.getFullYear(), today.getMonth() - 0, 1);
	        var prev2 = new Date(today.getFullYear(), today.getMonth() - 1, 1);
	        var prev3 = new Date(today.getFullYear(), today.getMonth() - 2, 1);

	        // YYYY-MM 포맷으로 바꾸는 함수
	        function formatMonth(date) {
	            var year = date.getFullYear();
	            var month = date.getMonth() + 1;
	            if (month < 10) {
	                month = '0' + month;
	            }
	            return year + '-' + month;
	        }

	        // 각 input 박스에 값 채우기
	        document.getElementById('month1').textContent = formatMonth(prev1);
	        document.getElementById('month2').textContent = formatMonth(prev2);
	        document.getElementById('month3').textContent = formatMonth(prev3);
	    }
	    function openMyImagePopup_1(imgSrc) {
		      const popupImg = document.getElementById("popupImg_1");
		      const overlay  = document.getElementById("overlay_1");
		      const popupBox = document.getElementById("popupBox_1");

		      if (popupImg && overlay && popupBox) {
		        popupImg.src = imgSrc;
		        overlay.style.display = "block";
		        popupBox.style.display = "block";
		      } else {
		        console.error("팝업 요소를 찾을 수 없습니다.");
		      }
		    }
	    function closePopup_1() {
		      const overlay = document.getElementById("overlay_1");
		      const popupBox = document.getElementById("popupBox_1");

		      if (overlay && popupBox) {
		        overlay.style.display = "none";
		        popupBox.style.display = "none";
		      } else {
		        console.error("팝업 요소를 찾을 수 없습니다.");
		      }
		    }
/* wnnpage_consult3.jsp 로직이 여기에서 실행됨  */
	    function openMyImagePopup(imgSrc) {
	      const popupImg = document.getElementById("popupImg");
	      const overlay  = document.getElementById("overlay");
	      const popupBox = document.getElementById("popupBox");

	      if (popupImg && overlay && popupBox) {
	        popupImg.src = imgSrc;
	        overlay.style.display = "block";
	        popupBox.style.display = "block";
	      } else {
	        console.error("팝업 요소를 찾을 수 없습니다.");
	      }
	    }
	    function closePopup() {
	      const overlay = document.getElementById("overlay");
	      const popupBox = document.getElementById("popupBox");

	      if (overlay && popupBox) {
	        overlay.style.display = "none";
	        popupBox.style.display = "none";
	      } else {
	        console.error("팝업 요소를 찾을 수 없습니다.");
	      }
	    }
	    $(document).ready(function () {
	        $("#hospCd").on("keydown", function (e) {
	            // Enter 키: 13, Tab 키: 9
	            if (e.keyCode === 13 || e.keyCode === 9) {
	                e.preventDefault(); // 기본 동작 방지 (필요한 경우)
	                hospcont_search();
	            }
	        });
	    });
	    
	    function hospcont_search() {
	           const hospCd = document.getElementById("hospCd").value; // 👈 병원코드 입력값 가져오기
	           if (/^\d{8}$/.test(hospCd)) {
	              $.ajax({
	                  type: "post",
	                  url: "${pageContext.request.contextPath}" + "/user/selHospsumList.do",
	                  data: { hospCd: hospCd },
	                  dataType: "json",
	                  success: function (data) {
	                      console.log("서버 응답 데이터:", data);
	                      const cont = Array.isArray(data) && data.length > 0 ? data[0] : {};

	                      function setValue(id, value) {
	                          const el = document.getElementById(id);
	                          if (el) el.value = value || '';
	                      }

	                      function setText(id, value) {
	                          const el = document.getElementById(id);
	                          if (el) el.textContent = value || '';
	                      }

	                      function isDateInRange(start, end) {
	                          const now = new Date();
	                          const startDate = new Date(start);
	                          const endDate = new Date(end);
	                          if (isNaN(startDate) || isNaN(endDate)) return false;
	                          return startDate <= now && now <= endDate;
	                      }

	                      // 기간 유효성 판단
	                      const rangeValid1 = isDateInRange(cont.startDt, cont.endDt);
	                      const rangeValid2 = isDateInRange(cont.startDt2, cont.endDt2);

	                      // 병원명 설정
	                      setValue('hospNm', cont.hospNm);

	                      // 날짜 조건에 따라 날짜 또는 공백 처리
	                      setText('cont_startDt',  rangeValid1 ? cont.startDt  +'~' : '');
	                      setText('cont_endDt',    rangeValid1 ? cont.endDt    : '');
	                      setText('cont_startDt1', rangeValid2 ? cont.startDt2 +'~' : '');
	                      setText('cont_endDt1',   rangeValid2 ? cont.endDt2   : '');

	                      const startDtVal  = document.getElementById('cont_startDt')?.textContent;
	                      const startDtVal2 = document.getElementById('cont_startDt1')?.textContent;

	                      setText('cont_name',  startDtVal  ? cont.name1 : '');
	                      setText('cont_name1', startDtVal2 ? cont.name2 : '');


	                  }
	              });
	           
	           } else {
	              messageBox("1","<h6>요양기관기호를 8자를 모두 입력후 Enter !!</h6><p></p>","hospCd","","");
	              return;
	           }

	     }
        //상단이미지 중앙이 아닌 로그인 화면비율에 맞게 조정 (좌측으로 이동정렬)
        function adjustCarouselPosition() {
        	  const items = document.querySelectorAll('.carousel-item');
        	  const indis  = document.querySelectorAll('.carousel-indicators');
        	  const windowWidth = window.innerWidth;

        	  items.forEach((item) => {
        		  if (windowWidth > 1920) {
        	      const offset = Math.floor((1920 - windowWidth) / 100)* 10;
        	      item.style.transform = 'translateX(' + offset + 'px)';
        	    } else {
        	      // 데스크탑/노트북에서는 원래 위치
        	      item.style.transform = 'translateX(0)';
        	    }
        	  });
        	  indis.forEach((indi) => {
        		  if (windowWidth > 1920) {
        	      const indiset = windowWidth - (windowWidth + 2500);
        	      indi.style.transform = 'translateX(' + indiset + 'px)';
        	    } else {
        	      // 데스크탑/노트북에서는 원래 위치
        	      indi.style.transform = 'translateX(0)';
        	    }
        	  });        	  
        	}

            adjustCarouselPosition(); // 페이지 로딩 시 바로 실행
            window.addEventListener('resize', adjustCarouselPosition);

         function ready_kakao(){
        	 messageBox("1","<h6>카카오상담은 준비중입니다 !!</h6><p></p>","","",""); 
         }   
         //공지사항 리치에디터  
			function modalName_rich(notiText) {
			  let safeAnswer = (notiText || '');
			  let convertedAnswer = safeAnswer.replace(/\n/g, "<br>");
			
			  $('#notiContent').summernote({
			    placeholder: '내용을 입력하세요...',
			    tabsize: 1,
			    height: 300,
			    lang: 'ko-KR',
			    toolbar: [
			      ['style', ['style']],
			      ['font', ['bold', 'italic', 'underline', 'clear']],
			      ['fontname', ['fontname']],
			      ['fontsize', ['fontsize']],
			      ['color', ['color']],
			    ],
			    fontNames: ['Arial', 'Arial Black', 'Comic Sans MS', 'Courier New', '맑은 고딕', '굴림체', '돋움체'],
			    fontNamesIgnoreCheck: ['맑은 고딕', '굴림체', '돋움체'],
			    callbacks: {
			      onInit: function () {
			        const $editable = $('#notiContent').next().find('.note-editable');
			        // 폰트 크기 및 정렬 설정
			        $editable.css({
			          'font-size': '14px',
			          'text-align': 'left' // ← 여기 추가
			        });
			        // 툴바 숨김
			        $('#notiContent').next(".note-editor").find(".note-toolbar").hide();
			        // 줄바꿈 유지된 내용 적용
			        $('#notiContent').summernote('code', convertedAnswer);
			      }
			    }
			  });
			}
			// 모달이 닫힐 때 두 에디터 제거
			$('#adminModal').on('hidden.bs.modal', function () {
			  $('#notiContent').summernote('destroy');
			});
         </script>    
	<jsp:include page="footer.jsp"></jsp:include>
</body>
</html>

