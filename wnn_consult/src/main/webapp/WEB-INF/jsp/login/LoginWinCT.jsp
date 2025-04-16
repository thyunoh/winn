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
<meta content="width=device-width, initial-scale=1.0" name="viewport">
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
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<!-- 아이콘 및 폰트 -->
<link href="/images/icons/winnernet.ico" rel="icon" type="image/x-icon">
<link
	href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&display=swap"
	rel="stylesheet">

<!-- CSS -->
<link rel="stylesheet"
href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css">
<link href="/css/winct/bootstrap.css" rel="stylesheet">
<link href="/css/winct/style.css?v=123" rel="stylesheet">

<!-- JavaScript -->
<script type="text/javascript" src="/js/winct/main.js"></script>
<script type="text/javascript" src="/js/winct/message.js"></script>
<script type="text/javascript" src="/js/winct/contact.js"></script>
<script type="text/javascript" src="/js/winct/loading.js"></script>
<script type="text/javascript" src="/js/winct/schcommons.js"></script>
<!-- 공통검색 -->

<!-- wnnnet 설정끝 -->
<!-- DataTables JS 추가 -->
</head>
<style>
	.social-container {
	  position: relative;            /* 기준점 설정 */
	  display: flex;
	  justify-content: space-between;
	  align-items: center;
	}
	
	.wincheck-img {
	  margin-top: -15px; /* 원하는 만큼 숫자 조절 */
	  max-width: 50%;                /* 왼쪽 이미지 크기 조절 */
	}
	.social-box {
	  position: fixed;
	  top: 35%;
	  right: 270px; /* ← 기존 20px → 60px로 늘려서 왼쪽으로 당김 */
	  background: #ffffff;
	  border: 2px solid #0d3b66;
	  border-radius: 16px;
	  padding: 14px 10px;
	  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
	  display: flex;
	  flex-direction: column;
	  align-items: center;
	  gap: 10px;
	  z-index: 9999;
	}
	
	.social-box img {
	  width: 50px;
	  height: 50px;
	  margin: 10px 0;
	}
  .image-layout {
     display: flex;
     gap: 20px;
     align-items: flex-start;
   }
	.slanted-banner {
	  background-color: #003b74;
	  position: absolute;
	  top: 0;
	  right: 0;
	  width: 280px;
	  height: 100%;
	  clip-path: polygon(30% 0, 100% 0, 100% 100%, 0 100%);
	  z-index: -1;
	}

   .right-img-group {
     display: flex;
     flex-direction: column;
     gap: 20px;
   }
	#noticeTable, #noticeTable1, #noticeTable2 {
		table-layout: fixed;
		width: 100%;
	}
	
	#noticeTable th, #noticeTable1 th, #noticeTable2 th {
		padding: 8px;
		vertical-align: middle;
		background-color: #DCE6F1;
		font-weight: bold;
		text-align: center;
		font-size: 13px;
		height: 25px;
	}
	
	#noticeTable td, #noticeTable1 td, #noticeTable2 td {
		padding: 6px;
		vertical-align: middle;
		text-align: center;
		white-space: nowrap;
		overflow: hidden;
		text-overflow: ellipsis;
	} 
    #navbarMenuArea {
	    display: flex;
	    flex-direction: row;
	    flex-wrap: nowrap; /* 줄바꿈 방지 */
	    align-items: center;
	    gap: 20px; /* 메뉴 사이 간격 */
    }
	.nav-right-banner {
	  position: relative;
	  width: 300px;
	  height: 55px;
	  background: transparent;
	  overflow: hidden;
	}
	
	/* 짙은 파란색 사선 배경 */
	.main-blue {
	  position: relative;
	  width: 300px;
	  height: 100px;
	  background-color: #003b73;
	  clip-path: polygon(60px 0%, 100% 0%, 100% 100%, 0% 100%);
	  z-index: 1;
	}
	/* 옅은 하늘색 사선 */
	.light-stripe {
	  position: absolute;
	  width: 10px;
	  height: 100px; /* 전체 높이는 유지 */
	  background-color: #7ecfff;
	  clip-path: polygon(0 20%, 100% 20%, 100% 100%, 0% 100%);
	  transform: skewX(-30deg);
	  left: 40px;
	  top: 10px;
	  z-index: 2;
	}
	.back-to-top {
	  position: fixed;
	  bottom: 40px;
	  right: 40px;
	  z-index: 99;
	  width: 60px;
	  height: 60px;
	  background-color: #00aaff;
	  color: white;
	  text-align: center;
	  border-radius: 50%;
	  font-weight: bold;
	  display: none;
	  flex-direction: column; /* 위아래 정렬 */
	  align-items: center;
	  justify-content: center;
	  font-size: 14px;
	  box-shadow: 0px 0px 10px rgba(0,0,0,0.3);
	}
	.back-to-top i {
	  font-size: 14px;
	  margin-bottom: -10px; /* 간격 제거 */
	}
</style>
<body>
<!-- Navbar Start -->
<div class="container-fluid_act bg-white mb-2">
	<div class="row px-xl-8">
		<div class="col-lg-3 d-none d-lg-block">
			<a class="btn d-flex justify-content-center align-items-center bg-white w-80"
				data-bs-toggle="collapse" href="#navbar-vertical"
				style="height: 50px; padding: 0; width: 70%;">
				<img src="/images/winct/winner_log_han.png" alt="WinnerNet Logo"
					id="consultingTitle"
					style="width: 200px; height: 100px; object-fit: contain;">
			</a>
		</div>
		<div class="col-lg-9">
			<nav class="navbar navbar-expand-lg bg-white navbar-light py-3 py-lg-0 px-0"
				style="height: 55px; align-items: center;">
				<div class="collapse navbar-collapse justify-content-between">
					<div id="navbarMenuArea" class="navbar-nav mr-auto py-0">
						<div class="nav-item dropdown">
							<a href="#" class="nav-link dropdown-toggle text-dark"
								style="font-size: 16px;" data-bs-toggle="dropdown">컨설팅 소개</a>
							<div class="dropdown-menu bg-light rounded-0 border-0 m-0">
								<a href="#" class="dropdown-item"
									onclick="setActive(this); loadPage('/login/wnnpage_consult1.do')">의료기관컨설팅</a>
								<a href="#" class="dropdown-item"
									onclick="setActive(this); loadPage('/login/wnnpage_consult2.do')">재청구컨설팅</a>
								<a href="#" class="dropdown-item"
									onclick="setActive(this); loadPage('/login/wnnpage_consult3.do')">의료기관인증컨설팅</a>
								<a href="#" class="dropdown-item"
									onclick="setActive(this); loadPage('/login/wnnpage_consult4.do')">적정성평가컨설팅</a>
								<a href="#" class="dropdown-item"
									onclick="setActive(this); loadPage('/login/wnnpage_consult5.do')">현지조사컨설팅</a>
							</div>
						</div>

						<a href="https://winner797.net/" class="nav-link dropdown-toggle text-dark"
							style="font-size: 16px; margin-top: -1px;"><strong>온라인교육센터</strong></a>

						<div id="dynamicMenu_J"></div>
						<div id="dynamicMenu_T"></div>
					</div>
					<div class="navbar-nav ml-auto py-0 d-none d-lg-block"></div>
					<div class="nav-right-banner">
					  <div class="main-blue"></div>
					  <div class="light-stripe"></div>
					</div>
				</div>
			</nav>
		</div>
	</div>
</div>
<!-- Navbar End -->

<script>
   //계약관련 메뉴설정체크 A. 전체 1.적정성 2. 진료비분석 
	function hosp_conact() {
		let s_conact_gb = getCookie("s_conact_gb");
		let s_wnn_yn    = getCookie("s_wnn_yn") ;
		let menuArea    = document.getElementById("dynamicMenu_J");
		let menuHTML    = '';
	
		if (s_conact_gb === 'A' || s_wnn_yn == 'Y'  ) {
			menuHTML += `
				<a href="#" class="nav-link dropdown-toggle text-dark" style="font-size: 16px; margin-top: -1px;">
				   <strong>적정성평가 프로그램</strong>
				</a>
			`;
		} else if (s_conact_gb === '1') {
			menuHTML += `
				<a href="#" class="nav-link dropdown-toggle text-dark" style="font-size: 16px; margin-top: -1px;">
				   <strong>경영분석 프로그램</strong>
				</a>
			`;
		} else if (s_conact_gb === '2') {
			menuHTML += `
				<a href="#" class="nav-link dropdown-toggle text-dark" style="font-size: 16px; margin-top: -1px;">
			    <strong>적정성평가 프로그램</strong>
			    </a>
			`;
		}
	
		menuArea.insertAdjacentHTML("beforeend", menuHTML);

		let menuArea_T = document.getElementById("dynamicMenu_T");
		let menuHTML_T = '';
	
		if (s_conact_gb === 'A' || s_wnn_yn == 'Y'  ) {
			menuHTML_T += `
				<a href="#" class="nav-link dropdown-toggle text-dark" style="font-size: 16px; margin-top: -1px;">
				   <strong>경영분석 프로그램</strong>
				</a>
			`;
		}
	
		menuArea_T.insertAdjacentHTML("beforeend", menuHTML_T);		
	}
	
	</script>


	<script> 
       function setActive(element) {
	        document.querySelectorAll('.nav-item').forEach(item => {
	            item.classList.remove('active');
	        });
	        element.classList.add('active');
       } 
	    // 페이지가 로드될 때마다 현재 페이지를 세션 저장소에 기록
	    window.onload = function() {
	        sessionStorage.setItem("previousPage", window.location.href);
	        setTimeout(function() {
	            document.body.style.display = "none";
	            document.body.offsetHeight; // 리플로우 강제 발생
	            document.body.style.display = "block";
	        }, 100);
	    };
	    document.addEventListener("DOMContentLoaded", function() {
	        var myCarousel = new bootstrap.Carousel(document.querySelector("#header-carousel"), {
	            interval: 2000, // 2초마다 변경
	            ride: "carousel"
	        });
	    });
    </script>
	<div id="contentArea"></div>

	<!-- 위너넷 컨설팅 이미지 -->
	<script> 	<!-- 타jsp화면을 주메뉴에 가져와서 화면에 뿌리주는 기능  -->
	function loadPage(pageUrl) {
		console.log("✅ 페이지 로드 완료: " + pageUrl);
	    fetch(pageUrl)
	        .then(response => response.text())
	        .then(data => {
	            let contentArea = document.getElementById("contentArea");
	            
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

	    // 기존 컨테이너 숨기기
	    $(".container-fluid").hide();  // 기존 요소 숨기기
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
	            history.replaceState(null, "", "/");
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
	
	<!-- Carousel Start -->
	<div class="container-fluid mb-1">
		<div class="row px-xl-8">
			<!-- 캐러셀: 전체 너비 사용 -->
		<div class="col-lg-12">
		  <div id="header-carousel" class="carousel slide carousel-fade mb-3" data-bs-ride="carousel">
		    <ol class="carousel-indicators">
		      <li data-bs-target="#header-carousel" data-bs-slide-to="0" class="active"></li>
		      <li data-bs-target="#header-carousel" data-bs-slide-to="1"></li>
		      <li data-bs-target="#header-carousel" data-bs-slide-to="2"></li>
		    </ol>
		
		    <div class="carousel-inner">
		      <!-- 슬라이드 1 -->
		      <div class="carousel-item active" style="height: 350px;">
		        <div class="d-flex align-items-center justify-content-center h-100">
		          <img src="/images/winct/image-1.jpg" 
		               class="img-fluid"
		               style="max-width: 200% !important; max-height: 90% !important; object-fit: contain !important;">
		        </div>
		      </div>
		
		      <!-- 슬라이드 2 -->
		      <div class="carousel-item" style="height: 350px;">
		        <div class="d-flex align-items-center justify-content-center h-100">
		          <img src="/images/winct/image-2.jpg" 
		               class="img-fluid"
		                style="max-width: 200% !important; max-height: 90% !important; object-fit: contain !important;">
		        </div>
		      </div>
		
		      <!-- 슬라이드 3 -->
		      <div class="carousel-item" style="height: 350px;">
		        <div class="d-flex align-items-center justify-content-center h-100">
		          <img src="/images/winct/image-3.jpg" 
		               class="img-fluid"
		                style="max-width: 200% !important; max-height: 90% !important; object-fit: contain !important;">
		        </div>
		      </div>
		    </div>
		  </div>
		</div>


		<!-- 로그인과 이미지 배너를 나란히 배치 -->
		<div class="col-lg-12">
			<div class="row">

			<!-- 로그인 영역 -->
			<div class="col-lg-6">
			  <div class="contact-form box-p-10 mb-3" style="min-height: 230px; background-color: #003366;">
			    <form name="loginForm" id="loginForm">
			      <div style="display: flex; align-items: flex-start; justify-content: flex-end;">
			        <!-- 입력 필드 영역 -->
			        <div style="flex-grow: 0; width: 250px;">
			          <h6 class="section-title position-relative mb-2">
			            <span class="pr-4" style="color: white;">로그인</span> <!-- 글자색 흰색으로 -->
			          </h6>
			          <div class="control-group mb-2">
			            <input type="text" class="form-control" id="hospid" placeholder="Hospital Number" />
			          </div>
			          <div class="control-group mb-2">
			            <input type="text" class="form-control" id="userid" placeholder="User ID" />
			          </div>
			          <div class="control-group mb-2">
			            <input type="password" class="form-control" id="passwd" placeholder="PassWord" />
			          </div>
			          <!-- 아이디 저장 -->
			          <div class="form-check mb-2" style="white-space: nowrap; color: white;">
			            <input class="form-check-input" type="checkbox" id="saveyn">
			            <span class="form-check-label font-weight-bold" for="saveyn" style="font-size: 13px;">아이디저장</span>
			          </div>
			        </div>
			
			        <!-- 로그인 버튼 + 링크 영역 -->
			        <div style="margin-left: 10px; text-align: center;">
			          <button type="button"
			                  id="blogin"
			                  onclick="login()"
			                  style="
			                    height: 120px;
			                    width: 120px;
			                    background-color: white;
			                    color: black;
			                    font-weight: bold;
			                    border: 1px solid #ccc;
			                    border-radius: 10px;
			                    font-size: 14px;
			                    cursor: pointer;
			                    margin-top: 20px;
			                    margin-bottom: 5px;
			                  ">로그인
			          </button>
			          <div style="font-size: 13px; font-weight: bold; color: white;">
			            <a href="javascript:void(0);" onclick="fnmbrReg();" style="color: white; text-decoration: none;">회원가입</a> |
			            <a href="javascript:void(0);" onclick="fnPasswdmanager();" style="color: white; text-decoration: none;">ID/PW찾기</a>
			          </div>
			        </div>
			      </div>
			    </form>
			
			    <!-- 로그인 성공 시 사용자 카드 -->
			    <div id="userInfoCard" style="display: none; overflow: auto; max-height: 200px;" class="mt-4">
			      <div class="user_card">
			        <div class="user_card-body">
			          <h1 class="user_card-title">환영합니다</h1>
			          <h3 class="user_card-text" id="user_name"></h3>
			          <button class="btn btn-primary" onclick="logout()">로그아웃</button>
			        </div>
			      </div>
			    </div>
			    
			  </div>
			</div>
			<!-- 이미지 배너 영역 -->
		
				<div class="image-layout">
				  <!-- 왼쪽 이미지 -->
				  <img class="img-fluid left-img" src="/images/winct/e_clip.png" alt="e_clip">
				
					  <!-- 오른쪽 위아래 이미지 묶음 -->
				  <div class="right-img-group" style="margin-left: -20px;">
					 <img class="img-fluid" src="/images/winct/on_consult.png" alt="on_consult" style="margin-top: -2px;">
					 <a href="https://winner797.net/" target="_blank">
					  <img class="img-fluid" src="/images/winct/on_edu.png" alt="on_edu" style="margin-top: -20px;">
					 </a>
				  </div>
				</div>
			
			  <!-- 오른쪽 소셜 아이콘 박스 -->
			  <div class="social-box">
			    <a href="https://www.youtube.com/watch?v=WaWoMowapjI" target="_blank">
			      <img src="/images/winct/YTB_10_1.png" alt="유튜브">
			    </a>
			    <a href="https://www.instagram.com/" target="_blank">
			      <img src="/images/winct/IST_10_1.png" alt="인스타그램">
			    </a>
			    <a href="https://blog.naver.com/ewinner7/222973843240" target="_blank">
			      <img src="/images/winct/BLG_10_1.png" alt="블로그">
			    </a>
			  </div>
			</div>
		</div>
	</div>
   </div>
</div>
	<div class="container-fluid mb-2">
		<div class="row px-xl-8">
			<div class="col-lg-4">
				<div class="bg-light box-p-10" style="height: 215px;">
					<div class="nav nav-tabs mb-1 border-bottom border-primary">
						<a class="nav-item nav-link active px-4 py-2 fw-bold"
							data-bs-toggle="tab" href="#notice-tab"> <i
							class="fas fa-bell me-1"></i> 공지사항
						</a>
					</div>
					<div class="tab-content">
						<div class="tab-pane fade active show" id="notice-tab">
							<div class="scroll-table-container"
								style="max-height: 200px; overflow-x: auto; overflow-y: auto;">
								<table id="noticeTable" class="table table-bordered">
									<colgroup>
										<col style="width: 30px">
										<col style="width: 120px">
										<col style="width: 200px">
										<col style="width: 180px">
									</colgroup>
 									<tbody id="noticeArea">
										<tr>
											<td colspan="6">&nbsp;</td>
										</tr>
									</tbody>
								</table>
							</div>
						</div>
					</div>
				</div>
			</div>
			<div class="col-lg-4">
				<div class="bg-light box-p-10" style="height: 215px;">
					<div class="nav nav-tabs mb-1 border-bottom border-primary">
						<a class="nav-item nav-link active px-4 py-2 fw-bold"
							data-bs-toggle="tab" href="#tab-pane-1"> <i
							class="fas fa-clinic-medical me-1"></i> 심사방
						</a> <a class="nav-item nav-link px-4 py-2 fw-bold text-muted"
							data-bs-toggle="tab" href="#tab-pane-2"> <i
							class="fas fa-newspaper me-1"></i> 소식지
						</a>
					</div>
					<div class="tab-content">
						<div class="tab-pane fade active show" id="tab-pane-1">
							<div class="scroll-table-container"
								style="max-height: 200px; overflow-x: auto; overflow-y: auto;">
								<table id="noticeTable1" class="table table-bordered">
									<colgroup>
										<col style="width: 30px">
										<col style="width: 120px">
										<col style="width: 200px">
										<col style="width: 180px">
									</colgroup>
									<tbody id="noticeArea1">
										<tr>
											<td colspan="6">&nbsp;</td>
										</tr>
									</tbody>
								</table>
							</div>
						</div>
						<div class="tab-pane fade" id="tab-pane-2">
							<div class="scroll-table-container"
								style="max-height: 200px; overflow-x: auto; overflow-y: auto;">
								<table id="noticeTable2" class="table table-bordered">
									<colgroup>
										<col style="width: 30px">
										<col style="width: 120px">
										<col style="width: 200px">
										<col style="width: 180px">
									</colgroup>
									<tbody id="noticeArea2">
										<tr>
											<td colspan="6">&nbsp;</td>
										</tr>
									</tbody>
								</table>
							</div>
						</div>
					</div>
				</div>
			</div>

			<div class="col-lg-4">

				<div class="bg-transparent box-p-10" style="height: 250px; margin-top: -10px;">
					<div class="row">
						<div class="col-14 text-left">
							<!--<h5 class="text-dark text-uppercase font-weight-bold">고객센터</h5>-->
							<img class="img-fluid" src="/images/winct/c-tel-01.png">
						<div>
					</div>
				</div>
				<div class="bg-light box-p-10" style="height: 100px; margin-top: 20px;">
					<div class="row">
						<div class="col-4">
							<a href="https://open.kakao.com/o/gBvFxyYg"> <img
								class="img-fluid" src="/images/winct/KKO_10_1.png" alt="카카오상담" style="margin-top: 20px;">
							</a>
						</div>
						<div class="col-4">
							<a href="#" onclick="fnasq_main();"> <img class="img-fluid"
								src="/images/winct/1-1_10_1.png" alt="1대1상담" style="margin-top: 20px;">
							</a>
						</div>
						<div class="col-4">
							<a href="#" onclick="loadFaqData();"> <img class="img-fluid"
								src="/images/winct/FAQ_10_1.png" alt="자주듣는질문" style="margin-top: 20px;"> 
							</a>
						</div>
					</div>
				</div>
				
			</div>
		</div>
	</div>
	<!--  공공기관 포털   -->
	<div class="container-fluid bg-info mb-2">
		<div class="row px-xl-8">
			<div class="col-lg-12 bg-info">
				<nav
					class="navbar navbar-expand-lg bg-info navbar-dark py-3 py-lg-0 px-0">
					<div class="collapse navbar-collapse">
						<!-- 메뉴를 가로 정렬 -->
						<div class="navbar-nav d-flex justify-content-center w-100 py-0">
							<a href="https://winner797.kr/main/" class="nav-item nav-link">위너넷
								평생교육원</a> <a href="https://www.hirachung.co.kr/"
								class="nav-item nav-link">한국보험의료인증원</a> <a
								href="https://www.nhis.or.kr/nhis/index.do"
								class="nav-item nav-link">건강보험공단</a> <a
								href="https://www.hira.or.kr" class="nav-item nav-link">건강보험심사평가원</a>
							<a href="https://biz.hira.or.kr/index.do"
								class="nav-item nav-link">요양기관업무포탈</a> <a href="#"
								class="nav-item nav-link">통합사이트</a>
						</div>
					</div>
				</nav>
			</div>
		</div>
	</div>
	<!--회원가입 모달창   -->

	<div id="mainModal" class="modal fade" tabindex="-1" data-backdrop="static"
		data-keyboard="false" aria-hidden="true" role="dialog">
		<div class="modal-dialog modal-dialog-centered modal-dialog-scrollable" role="document"
			style="max-width: 600px;">
			<div class="modal-content rounded-3 shadow-lg">
				<div class="modal-header bg-light">
						<h5 class="modal-title">회원등록</h5>
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
							<label for="hospCd" class="form-label" style="font-size: 0.9rem;"> 병원코드</label>
							<div class="input-group">
								<input id="hospCd" name="hospCd" type="text" class="form-control"
									placeholder="병원코드를 입력하세요">
								<button class="btn btn-outline-dark rounded px-2 py-1" type="button" onclick="fnDupchk()">
									<i class="fas fa-search"></i> 중복체크
								</button>
							</div>
						</div>
						<!-- 병원명 -->
						<div class="mb-3">
							<label for="hospNm" class="form-label" style="font-size: 0.9rem;">병원명</label>
							<div class="input-group">
								<input id="hospNm" name="hospNm" type="text" class="form-control"
									placeholder="병원명을 입력하세요">
								<button class="btn btn-outline-dark rounded px-2 py-1" type="button" id="hospserch">
									<i class="fas fa-search"></i> 병원검색
								</button>
							</div>
						</div>
						<!-- 이메일 -->
						<div class="mb-3">
							<label for="email" class="form-label" style="font-size: 0.9rem;">이메일</label>
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
								<label for="passWd" class="form-label" style="font-size: 0.9rem;" >비밀번호</label>
								<input type="password" id="passWd" name="passWd" class="form-control">
							</div>
							<div class="col">
								<label for="afPassWd" class="form-label" style="font-size: 0.9rem;" >비밀번호 확인</label>
								<input type="password" id="afPassWd" name="afPassWd" class="form-control">
							</div>
						</div>
	
						<!-- 담당자 -->
						<div class="row g-2 mb-3">
							<div class="col">
								<label for="mbrNm" class="form-label" style="font-size: 0.9rem;" >담당자명</label>
								<input type="text" id="mbrNm" name="mbrNm" class="form-control">
							</div>
							<div class="col">
								<label for="mbrTel" class="form-label" style="font-size: 0.9rem;" >전화번호</label>
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
									<span class="form-check-label">이용약관 동의</span>
								</div>
								<button class="btn btn-outline-dark rounded px-2 py-1" type="button"
									onclick="openModal('이용약관 동의','PER_USE_CD')">세부확인</button>
							</div>
						
							<div class="d-flex justify-content-between align-items-center mb-2">
								<div class="form-check">
									<input type="checkbox" id="perinfoyn" name="perinfoyn" class="form-check-input agreement-checkbox" onchange="checkAction()">
									<span class="form-check-label">개인정보 수집 및 이용</span>
								</div>
								<button class="btn btn-outline-dark rounded px-2 py-1" type="button"
									onclick="openModal('개인정보 수집 및 이용 동의','PER_INFO_CD')">세부확인</button>
							</div>
						
							<div class="d-flex justify-content-between align-items-center">
								<div class="form-check">
									<input type="checkbox" id="perproyn" name="perproyn" class="form-check-input agreement-checkbox" onchange="checkAction()">
									<span class="form-check-label">개인정보 처리위탁 동의</span>
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


	<!-- 회원가입 스크립트 시작 -->
	<script>	
		    /*회원가입*/ 
		    function fnmbrReg(){
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
	            if (passWd !== afPassWd) {
	                messageBox("1", "<h6>비밀번호가 상호 상이합니다.!</h6><p></p>", "afPassWd", "", "");
	                return;
	            }

	            // 약관 동의 여부 체크
	            const terms = ['perUseYn', 'perInfoYn', 'perProYn'];
	            for (let term of terms) {
	                if (document.getElementById(term).value !== "Y") {
	                    messageBox("1", "<h6>전체 약관동의를 하여야 합니다!</h6><p></p>", "", "", "");
	                    return;
	                }
	            }

	        	$("#perUseCd").val("PER_USE_CD") ;
	        	$("#perInfoCd").val("PER_INFO_CD") ;
	        	$("#perProCd").val("PER_PRO_CD") ;
	        	var formData = $("form[name='memregForm']").serialize() ;
	        	if (!confirm("입력 하시겠습니다?")) {
	                return;  
	            }
	        	$.ajax( {
	        		type : "post" ,                      
	        		url  : CommonUtil.getContextPath() + "/user/MemberSaveAct.do",
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
	        	if ($("email").val()  ===""){
	        		messageBox("1","<h6>이메일정보를 입력하세요.!!</h6><p></p>","email","","");
	                return;         		
	        	}
	        	$.ajax( {
	        		type : "post",
	        		url :  "/user/MberDupChk.do",
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
	        		url : CommonUtil.getContextPath() + "/base/ctl_selCommDtlInfo.do",
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
	            
	            switch(code_cd){
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
		<div class="modal-dialog modal-lg" style="max-width: 500px;">
			<div class="modal-content rounded-3 shadow-lg">
				<form:form commandName="DTO" id="pwserchregForm" name="pwregForm"
					method="post">
					<h3 class="text-center">아이디찾기 비밀번호초기화</h3>
					<div class="pass-box w-70">
						<input type="text" name="userNm1" class="form-control mt-2"
							id="userNm1" placeholder="사용자성명" /> <input type="text"
							name="email1" class="form-control mt-2" id="email1"
							placeholder="사용자이메일" />
						<h11 style="font-size: 12px; color: #555;"> 아이디를 찾기 위해서 성명 및
						이메일를 등록하고 아이디찾기를 실행하세요 </h11>
						<input type="text" class="form-control mt-2" id="userId"
							name="userId" placeholder="사용자아이디">
					</div>
				</form:form>
				<div class="set-btn-box w-100 mt-3 text-right">
					<button type="button" class="btn btn-outline-dark"
						onclick="fnPasswdmanagerClose();">취소</button>
					<button type="button" class="btn btn-primary"
						onclick="fnpwsearch();">아이디찾기</button>
					<button type="button" class="btn btn-primary"
						onclick="fnPasswdreset();">초기화/변경</button>
					<!--  원래는 팝업 fnPwdClear()  -->
				</div>
			</div>
		</div>
	</div>


	<!--아이디찾기  -->
	<script>
	function fnpwsearch(){
		if(!fnRequired('userNm1', '사용자 성명을 입력하세요 .'))   return;
		if(!fnRequired('email1',   '사용자 이메일를 입력하세요 .'))   return;
		$("#userId").val("") ;
		$.ajax( {
			type : "post",
			url : CommonUtil.getContextPath() + "/popup/login_usersearch.do",
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
	    var url = CommonUtil.getContextPath() + "/popup/login_pwdchg.do";
	    
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
		<div class="modal-dialog modal-lg" style="max-width: 500px;">
			<div class="modal-content rounded-3 shadow-lg">
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
							onclick="fnSaveReset();">비밀번호초기화</button>
					</div>
					<div>
						<button type="button" class="btn btn-outline-dark"
							onclick="fnPasswdresetClose();">취소</button>
						<button type="button" class="btn btn-primary"
							onclick="fnSavechg();">변경</button>
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
			url : CommonUtil.getContextPath() + "/base/pwdchgAct.do",
			data : formData,
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
			url : CommonUtil.getContextPath() + "/base/pwdresetAct.do",
			data : {hospCd  :  $("#hospCd1").val() , userId : $("#userId1").val()},
			dataType : "json",
			success : function(data) {   
				if(data.error_code != "0"){
					if(data.error_code == "20000"){ 
						alert(data.error_msg);
						$("#userId1").focus();
					}	
					else{ 
						alert(data.error_msg);
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
		<div class="modal-dialog modal-lg" style="max-width: 800px;">
			<div class="modal-content"
				style="height: 80%; display: flex; flex-direction: column; position: relative; border-radius: 10px; box-shadow: 0px 4px 20px rgba(0, 0, 0, 0.1);">
				<div class="modal-header" style="height: 38px; padding: 5px 10px;">
					<span id="notiname" style="font-size: 20px; color: black;"></span>
					<button type="button" class="btn btn-outline-dark btn-sm"
						onclick="readsaveAdminModal(document.getElementById('notiSeq').value, document.getElementById('fileGb').value, this)">닫기</button>
				</div>
				<form:form commandName="DTO" id="regForm" name="regForm"
					method="post" enctype="multipart/form-data"
					style="flex-grow: 1; display: flex; flex-direction: column;">
					<input type="hidden" name="iud" id="iud" />
					<input type="hidden" name="notiSeq" id="notiSeq" />
					<input type="hidden" name="fileGb" id="fileGb" />

					<div class="modal-body" style="overflow-y: auto; padding: 20px;">
						<div class="mb-0">
							<label for="notiTitle" class="form-label fw-bold"
								style="font-size: 14px !important; display: block; text-align: left;">제목</label>
							<input type="text" name="notiTitle" id="notiTitle"
								class="form-control" placeholder="제목을 입력하세요.">
						</div>

						<div class="mb-0">
							<label for="notiTitle" class="form-label fw-bold"
								style="font-size: 14px !important; display: block; text-align: left;">내용</label>
							<textarea class="form-control" name="notiContent"
								id="notiContent" rows="12" placeholder="내용을 입력하세요."
								style="resize: none; font-size: 14px;"></textarea>
						</div>
						<h3 class="mt-3">첨부 문서</h3>
						<div class="table-container"
							style="width: 100%; border: 1px solid #ddd; border-radius: 10px;">
							<div style="max-height: 150px; overflow-y: auto;">
								<table id="fileTable"
									class="display nowrap table table-hover table-bordered"
									style="width: 100%;">
								</table>
							</div>
						</div>
						<!-- 파일있으면 파일 다운로드 구현 부분  -->
					</div>
				</form:form>
			</div>
		</div>
	</div>
	<!-- 공지사항 스크립트시작 -->
	<script>
	function callMultipleSearch() {
	    for (let k = 1; k <= 3; k++) {
	        fnnotice_search(k);
	    }
	}
	
	function fnnotice_search(fileGb) {
		let targetArea, targetTable;
		switch (fileGb) {
	    	case 1:
	    		targetArea  = "#noticeArea"   ;
	    		targetTable = "#noticeTable"  ;
	    		break ;
	        case 2:
	            targetArea  = "#noticeArea1"  ;
	            targetTable = "#noticeTable1" ;
	            break;
	        case 3:
	            targetArea  = "#noticeArea2"  ;
	            targetTable = "#noticeTable2" ;
	            break;
	        default:
	            targetArea  = "#noticeArea"   ;
	            targetTable = "#noticeTable"  ;
	    }
		
		$(targetTable  + " tr").attr("class", "");
		
	    if (document.getElementById("regForm")) {
	        document.getElementById("regForm").reset();
	    }
	    
		$(targetArea).empty();
		$.ajax({
		   	url : CommonUtil.getContextPath() + '/mangr/ctl_notiList.do',
		    type : 'post',
		    data : {fileGb    : fileGb   ,
		    	    startDt : "20230101",
		    	    endDt   : "20991231",
		    	    searchText : "" },
			dataType : "json",
		   	success : function(data) {
		   		if(data.error_code != "0") return;
		   		if(data.resultCnt > 0 ){
		   			var dataTxt = "" ;
		    		for(var i=0 ; i < data.resultCnt; i++){
		    			dataTxt = '<tr  class="" onclick="showAdminModal(\'' 
		    		          + data.resultList[i].notiSeq + '\', \'' 
		    		          + data.resultList[i].fileGb + '\', \'' 
		    		          + data.resultList[i].notiTitle.replace(/'/g, "\\'") + '\', \'' 
		    		          + data.resultList[i].notiContent.replace(/'/g, "\\'") + '\');" id="row_' 
		    		          + data.resultList[i].notiSeq + '_' 
		    		          + data.resultList[i].fileGb + '_' 
		    		          + data.resultList[i].notiTitle.replace(/\s+/g, '_').replace(/'/g, "\\'") + '_' 
		    		          + data.resultList[i].notiContent.replace(/\s+/g, '_').replace(/'/g, "\\'") + '">';
		    		          
		 				dataTxt += 	"<td>" + (i+1)  + "</td>" ; 
						dataTxt +=  "<td>" + data.resultList[i].notiTitle   + "</td>" ;
						dataTxt +=  "<td class='txt-left ellips'>" + data.resultList[i].notiContent    + "</td>" ;
						dataTxt +=  "<td>" + data.resultList[i].updDttm     + "</td>" ; 
					//	dataTxt +=  "<td>" + data.resultList[i].userNm      + "</td>" ;
						dataTxt +=  "<td>" + data.resultList[i].notiRedcnt  + "</td>" ;
						dataTxt +=  "</tr>";  
			            $(targetArea).append(dataTxt);
		        	 }
			 	  }else{
					  $(targetArea).append("<tr><td colspan='4'>검색된 정보가 없습니다.</td></tr>");
				  }
		      }
	   });
	}   
	function showAdminModal(notiSeq,fileGb,notiTitle,notiContent) {
		if (!sessionStorage.getItem('s_hospid')) {
		    messageBox("1", "<h6>로그인 하고 진행하세요.!!</h6><p></p>", "", "", "");
		    return; 
		} 
	    $("#notiSeq").val(notiSeq);
	    $("#fileGb").val(fileGb);
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
	    $("#notiTitle").val(notiTitle.replace(/_/g, ' '));  // 공백 복원
	    $("#notiContent").val(notiContent.replace(/_/g, ' '));  // 공백 복원
	    
	    showfileModal(notiSeq,fileGb);

	    $("#adminModal").modal('show');  // Bootstrap 모달 사용 예제
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
	        url: "/mangr/fileCdList.do",
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
	                    fileUrl = "/sftp/download.do?filePath=" + encodedPath;
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

	    if (!fileUrl.startsWith("/sftp/download.do")) {
	        alert("❌ 유효하지 않은 다운로드 경로입니다.");
	        e.preventDefault();
	    }
	});
	function readsaveAdminModal(notiSeq, fileGb, button) {
	    $(button).prop('disabled', true);
	    $.ajax({
	        url: CommonUtil.getContextPath() + '/mangr/read_noticnt.do',
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
<style>
	#asq_infoTable {
		table-layout: fixed;
		width: 100%;
	}
	
	#asq_infoTable th {
		padding: 8px; /* 내부 여백 추가 */
		vertical-align: middle; /* 글자 세로 정렬 */
		background-color: #DCE6F1; /* 연한 하늘색 배경 */
		font-weight: bold; /* 글씨 굵게 */
		text-align: center; /* 가운데 정렬 */
		font-size: 13px; /* 글자 크기 축소 */
		height: 25px; /* 행 높이 제한 */
	}
	
	#asq_infoTable td {
		padding: 6px; /* 내부 여백 */
		vertical-align: middle; /* 글자 세로 정렬 */
		text-align: center; /* 가운데 정렬 */
		white-space: nowrap;
		overflow: hidden;
		text-overflow: ellipsis;
	}
</style>
	<!-- 기존 1대1 질의응답  -->
	<div class="modal fade" id="asq_main_tab" tabindex="-1"
		data-bs-backdrop="static" data-bs-keyboard="false" aria-hidden="true">
		<div class="modal-dialog modal-lg"
			style="max-width: 900px; width: 90%;">
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
								<col style="width: 60px">
								<col style="width: 60px">
								<col style="width: 120px">
							</colgroup>

							<thead>
								<tr>
									<th>번호</th>
									<th>병원정보</th>
									<th title="질문제목">질문제목</th>
									<th title="질문내용">질문내용</th>
									<th>질문상태</th>
									<th>답변상태</th>
									<th>질문자</th>
									<th>작성일</th>
								</tr>
							</thead>
							<tbody id="asqdataArea" style="background-color: white;">
								<tr>
									<td colspan="8" class="text-muted">&nbsp; 검색된 결과가 없습니다.</td>
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

	<!--질문응답-->
	<div class="modal fade" id="asq_main" tabindex="-1"
		data-bs-backdrop="static" data-keyboard="false" aria-hidden="true">
		<div
			class="modal-dialog modal-dialog-centered modal-dialog-scrollable"
			style="position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); width: 45vw; max-width: 45vw; max-height: 50vh;">
			<div class="modal-content"
				style="height: 72%; display: flex; flex-direction: column;">
				<div class="modal-header  bg-light">
					<h6 class="modal-title">문의 등록</h6>
					<div class="form-row">
						<div class="col-sm-12 mb-2" style="text-align: right;">
							<button type="button" id="save_btn" type="submit"
								class="btn btn-outline-info" onClick="fnasq_SaveProc()">
								저장. <i class="far fa-edit"></i>
							</button>
							<button type="button" class="btn btn-outline-dark"
								data-dismiss="modal" onClick="asqModalClose()">
								닫기 <i class="fas fa-times"></i>
							</button>
						</div>
					</div>
				</div>
				<form:form commandName="DTO" id="asq_regForm" name="asq_regForm"
					method="post" enctype="multipart/form-data">
					<div class="modal-body text-left flex-fill overflow-auto">
						<!-- Spring Form 태그 사용 (Spring MVC 환경이라면 적용 가능) -->
						<input type="hidden" name="iudasq" id="iudasq" /> <input
							type="hidden" name="asqSeq" id="asqSeq" /> <input type="hidden"
							name="fileGbasq" id="fileGbasq" value="4" /> <input type="hidden"
							name="hospCdasq" id="hospCdasq" /> <input type="hidden"
							name="hospUuidasq" id="hospUuidasq" /> <input type="hidden"
							name="regUserasq" id="regUserasq" /> <input type="hidden"
							name="updUserasq" id="updUserasq" />

						<div class="form-group ">
							<label for="qstnTitle"
								class="col-2 col-lg-2 col-form-label text-left">질문제목</label>
							<div class="col-10 col-lg-10">
								<input id="qstnTitle" name="qstnTitle" type="text"
									class="form-control" placeholder="질문제목을 입력하세요">
							</div>
						</div>

						<div class="form-group">
							<label for="qstnConts"
								class="col-2 col-lg-2 col-form-label text-left">질문내용</label>
							<div class="col-10 col-lg-10">
								<textarea id="qstnConts" name="qstnConts"
									placeholder="질문내용을 입력하세요" class="form-control" rows="5"></textarea>
							</div>
						</div>

						<div class="form-group">
							<label for="qstnWan"
								class="col-2 col-lg-2 col-form-label text-left">질문완료</label>
							<div class="col-4 col-lg-4">
								<select id="qstnWan" name="qstnWan" class="custom-select"
									style="height: 35px; font-size: 14px;">
									<option value="">선택</option>
									<option value="Y">Y. 질문완료</option>
									<option value="N">N. 진행중</option>
								</select>
							</div>
						</div>

						<div class="form-group">
							<label for="ansrConts"
								class="col-2 col-lg-2 col-form-label text-left">답변내용</label>
							<div class="col-10 col-lg-10">
								<textarea id="ansrConts" name="ansrConts"
									placeholder="답변내용 입력하세요" class="form-control" rows="8"></textarea>
							</div>
						</div>

						<div class="form-group">
							<label for="ansrWan"
								class="col-2 col-lg-2 col-form-label text-left">답변완료</label>
							<div class="col-4 col-lg-4">
								<select id="ansrWan" name="ansrWan" class="custom-select"
									style="height: 35px; font-size: 14px;">
									<option value="">선택</option>
									<option value="Y">Y. 답변완료</option>
									<option value="N">N. 진행중</option>
								</select>
							</div>
						</div>
					</div>
				</form:form>
			</div>
			<div class="modal-footer"></div>
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
		   	url : 'mangr/ctl_asqList.do',
		    type : 'post',
		    data : {hospCdasq : sessionStorage.getItem('s_hospid')  , qstnTitle : $("#searchText").val() },
			dataType : "json",
		   	success : function(data) {
		   		if(data.error_code != "0") return;
	
		   		if(data.resultCnt > 0 ){
		    		var dataTxt = "";
		    		for(var i=0 ; i < data.resultCnt; i++){
		    			dataTxt = '<tr  class="" onclick="fn_asqDtlSearch(\''+ data.resultLst[i].asqSeq +'\');" id="row_' 
		    			                                                                + data.resultLst[i].asqSeq+'">';
		 				dataTxt += 	"<td>" + (i+1)  + "</td>" ; 
		 				dataTxt +=  "<td>" + data.resultLst[i].hospNm   + "</td>" ;
		 				dataTxt +=  "<td class='txt-left ellips'>" + data.resultLst[i].qstnTitle    + "</td>" ;
						dataTxt +=  "<td class='txt-left ellips'>" + data.resultLst[i].qstnConts    + "</td>" ;	
						dataTxt +=  "<td>" + data.resultLst[i].qstnStat    + "</td>" ;	
		 				dataTxt +=  "<td>" + data.resultLst[i].ansrStat    + "</td>" ;	
		 				dataTxt +=  "<td>" + data.resultLst[i].userNm   + "</td>" ;
						dataTxt +=  "<td>" + data.resultLst[i].updDttm  + "</td>" ; 
						dataTxt +=  "</tr>";
			            $("#asqdataArea").append(dataTxt);
		        	 }
			 	  }else{
					  $("#asqdataArea").append("<tr><td colspan='8'>검색된 정보가 없습니다.</td></tr>");
				  }
		      }
	   });
	}
	var  lasqSeq  ;
    var  lfileGb  ;  
    var  lregUser ;
    var  lregIp   ;
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
	            url: "/mangr/ctl_getHospmst.do",
	            data: { hospCd: sessionStorage.getItem('s_hospid') },
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
	        setCurrDate("regDtm");
	        $("#ansrConts").prop("readonly", "true");
	        $("#save_btn").show(); // 답변내용 보이기
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
	            url: "/mangr/selectAnsrInfo.do",
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
	                asqModalOpen();
	            }
	        });

	    } else if (iud.substring(1, 2) == "D") {
	        // 삭제 전에 ansrWan 상태 확인 후 처리
	        $.ajax({
	            type: "post",
	            url: "/mangr/selectAnsrInfo.do",  // 답변 상태 조회 API
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
	        // 삭제가 아닐 때만 필수 입력값 확인 및 form 데이터 설정
	        if (!fnRequired('fileGbasq', '공지구분을 확인 하세요.')) return;
	        if (!fnRequired('qstnTitle', '질문제목을 확인 하세요.')) return;
	        if (!fnRequired('qstnConts', '질문내용을 확인하세요.')) return;
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
	            url: "/mangr/asqSaveAct.do",
	            data: formData,  // formData가 정의되어 있어야 함
	            dataType: "json",
	            success: function (data) {
	                if (data.error_code !== "0") {
	                    alert(data.error_msg);
	                    return;
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

</script>
	<!-- 질의응답스크립트 종료 -->
	<!-- FAQ 모달 -->
	<div class="modal fade" id="faqModal" tabindex="-1"
		aria-labelledby="faqModalLabel" aria-hidden="true">
		<div class="modal-dialog modal-lg">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="faqModalLabel">자주 묻는 질문 (FAQ)</h5>
					<button type="button" class="btn btn-outline-dark"
						data-dismiss="modal" onclick="faqMainClose()">
						닫기 <i class="fas fa-times"></i>
					</button>
				</div>
				<div class="modal-body">
					<div id="faqList">
						<p class="text-muted text-center">FAQ 데이터를 불러오려면 버튼을 클릭하세요.</p>
					</div>
				</div>
			</div>
		</div>
	</div>

	<!-- 자주하는 질문 스크립트 시작-->
	<script>
	function loadFaqData() {
	    if (!sessionStorage.getItem('s_hospid')) {
	        messageBox("1", "<h6>로그인 하고 진행하세요.!!</h6><p></p>", "", "", "");
	        return; 
	    } 
	
	    // 모달을 먼저 연다 (첫 번째 열 때 닫히는 문제 해결)
	    $('#faqModal').modal('show');
	
	    $("#faqList").html(`<p class="text-muted text-center"></p>`);
	
	    $.ajax({
	        url: "/mangr/faqList.do",
	        type: "POST",
	        data: {},
	        dataType: "json",
	        success: function (response) {
	            let faqHtml = "";
	            if (response.error_code === "0" && Array.isArray(response.resultLst) && response.resultLst.length > 0) {
	            	$.each(response.resultLst, function (index, faq) {
	            	    let question = String(faq.qstnConts || "질문이 없습니다.").trim();
	            	    let answer = String(faq.ansrConts || "답변이 없습니다.").trim();

	            	    // div 요소 동적 생성
	            	    let faqItem = $("<div>", { class: "faq-item" });
	            	    
	            	    let faqQuestion = $("<div>", { class: "faq-question", onclick: "fnFaqToggle(this)" }).text(question);
	            	    let arrowSpan = $("<span>", { class: "arrow" }).text("▼");
	            	    faqQuestion.append(arrowSpan);

	            	    let faqAnswer = $("<div>", { class: "faq-answer", style: "display: none;" }).text(answer);

	            	    faqItem.append(faqQuestion).append(faqAnswer);

	            	    $("#faqList").append(faqItem); // 리스트에 추가
	            	});
	            } else {
	                faqHtml = `<p class="text-muted text-center">검색된 결과가 없습니다.</p>`;
	            }
             //   console.log(faqHtml)
	         //    $("#faqList").html(faqHtml);	

	            // FAQ 클릭 이벤트 적용
	            $(".faq-item .faq-question").off("click").on("click", function () {
	                let $item = $(this).closest(".faq-item");
	                
	                if ($item.hasClass("active")) {
	                    $item.removeClass("active").find(".faq-answer").slideUp();
	                    $item.find(".arrow").text("▼"); // 화살표 ▼로 변경
	                } else {
	                    $(".faq-item").removeClass("active").find(".faq-answer").slideUp();
	                    $(".faq-item .arrow").text("▼"); // 모든 화살표 초기화
	
	                    $item.addClass("active").find(".faq-answer").slideDown();
	                    $item.find(".arrow").text("▲"); // 현재 열린 항목의 화살표 ▲ 변경
	                }
	            });
	
	            console.log("📢 FAQ 데이터 로드 완료");
	        },
	        error: function () {
	            $("#faqList").html(`<p class="text-danger text-center">FAQ 데이터를 불러오는 중 오류가 발생했습니다.</p>`);
	        }
	    });
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
    	// 자식 창 변수
        let win_Check;
        window.onload = function() {
        	
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
        	    url: CommonUtil.getContextPath() + "/user/loginChk.do",
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
	        				sessionStorage.setItem('s_use_yn', data.loginUseYN); 			// 사용여부(Y,정상사용자, N.종료사용자)
	        				sessionStorage.setItem('s_hosp_uuid', $("#hospid").val().trim()); //위너넷이 접속시 데이타연관성 확인  
	        				sessionStorage.setItem('s_insauth', data.login_insAuth); //입력권한 
	        				sessionStorage.setItem('s_updauth', data.login_updAuth); //수정권한 
	        				sessionStorage.setItem('s_delauth', data.login_delAuth); //삭제권한 
	        				sessionStorage.setItem('s_inqauth', data.login_inqAuth); //조회권한 
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
                
        	    document.getElementById('user_name').textContent = sessionStorage.getItem('s_usernm') + `님 반갑습니다 !!`;
                
                if (form_Element) {
                    userInfoCard.style.height = `${form_Element.offsetHeight}px`;
                    userInfoCard.style.Width  = `${form_Element.offsetWidth}px`;
                }
                
                form_Element.style.display = 'none';
                userInfoCard.style.display = 'block';
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
        	setCookie("s_hospuuid", "", 0);
        	setCookie("s_connip", "", 0);
        	setCookie("s_wnn_yn", "", 0);  //tbl_hosp_mst 워너넷여부 
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
    	
    	function syncCardSize() {
    		const form_Element = document.getElementById('loginForm');
            const userInfoCard = document.getElementById('userInfoCard');
            
            if (form_Element && userInfoCard) {
                const formStyles = window.getComputedStyle(form_Element);
                userInfoCard.style.height = formStyles.height;
                userInfoCard.style.width  = formStyles.width;
            }
        }    	
        window.onresize = syncCardSize;
    	
        function winCheckOpen() {
            
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
        	setCookie("s_connip", sessionStorage.getItem('s_connip'), 1);
        	setCookie("s_wnn_yn", sessionStorage.getItem('s_wnn_yn'), 1);
        	setCookie("s_hosp_uuid", sessionStorage.getItem('s_hospid'), 1);
        	//tbl_hospcont테이블 (진료비,적정성(A), 진료비 '1' 적정성 '2' ,else 'N') 
        	setCookie("s_conact_gb", sessionStorage.getItem('s_conact_gb'), 1); //계약구분  
        	setCookie("s_insauth", sessionStorage.getItem('s_insauth'), 1); //입력권한
        	setCookie("s_updauth", sessionStorage.getItem('s_updauth'), 1); //수정권한  
        	setCookie("s_delauth", sessionStorage.getItem('s_delauth'), 1); //삭제권한  
        	setCookie("s_inqauth", sessionStorage.getItem('s_inqauth'), 1); //조회권한  
      	
        	hosp_conact() ;
        	
        	const url = "http://localhost:9080/user/";  // main.do 호출       
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
		// 병원검색 /js/winmc/schcommons.js///////////////
		$("#hospserch").on("click", function () {
			openHospitalSearch(function (data) {
		        $("#hospCd").val(data.hospCd);
		        $("#hospNm").val(data.hospNm);
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
		  if (document.body.scrollTop > 200 || document.documentElement.scrollTop > 200) {
		    btn.style.display = "flex";
		  } else {
		    btn.style.display = "none";
		  }
		};

		// 버튼 클릭 시 상단 이동
		document.getElementById("btnTop").onclick = function (e) {
		  e.preventDefault();
		  window.scrollTo({ top: 0, behavior: 'smooth' });
		};
		
		/*
        function saveynchange() {
            if (document.loginForm.saveyn.checked === true) { 
                document.loginForm.autoyn.disabled  = false;
            } else {
                document.loginForm.autoyn.checked   = false;
                document.loginForm.autoyn.disabled  = true;
            }
        }
        */
        
    </script>
	<jsp:include page="footer.jsp"></jsp:include>
</body>
</html>
