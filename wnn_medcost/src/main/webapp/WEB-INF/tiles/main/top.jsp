<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<script	src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<link href="/css/winmc/style_login.css?v=123" rel="stylesheet">
<style>
</style>
<!-- ============================================================== -->
<!-- main wrapper -->
<!-- ============================================================== -->

<div class="dashboard-main-wrapper">
    <!-- ============================================================== -->
    <!-- navbar -->
    <!-- ============================================================== -->
    <div class="dashboard-header">
        <nav class="navbar navbar-expand-lg bg-white fixed-top">
            <a class="navbar-brand ml-4 mr-5" href="/user/dashboard.do">
			  <img src="/images/winct/wincheck.jpg" alt="WinnerNet Logo" height="40">
			</a>
            <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" 
                                          aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse " id="navbarSupportedContent">
                <ul class="navbar-nav ml-left">
					<li class="nav-item">
                        <div id="custom-search" class="top-search-bar">
                            <a href="#" id="top-menu_a" class="btn btn-rounded btn-light btn-sm top-menu-btn">전체메뉴</a>
                            <a href="#" id="top-menu_b" class="btn btn-rounded btn-light btn-sm top-menu-btn">자료올리기</a>
                			<div id="top-menu_c"> </div>
                			<div id="top-menu_d"> </div>
                        </div>
                    </li>
                    <!--  
                    <li class="nav-item">
                        <div id="custom-search" class="ml-2 top-search-bar">
                        	<input class="form-control" type="text" placeholder="Search.."  maxlength="20">
                        </div>
                        
                    </li> 
                    -->
					<li class="nav-item">
					  <div id="custom-search" class="ms-2 top-search-bar">
							<button id="hospserchtop"
							  class="btn d-flex align-items-center gap-1 px-3 py-1 rounded-pill"
							  style="
							    display: none !important;
							    background-color: #e3f2fd;
							    border: 2px solid #2196f3;
							    color: #1565c0;
							    font-weight: 600;
							    font-size: 14px;
							    box-shadow: 0 0 6px rgba(33, 150, 243, 0.3);
							    transition: all 0.2s ease-in-out;
							  "
							>
							  <i class="fas fa-hospital-symbol"></i>
							  <span>병원검색</span>
							</button>
					  </div>
					</li>
                </ul>    
                <ul class="navbar-nav ml-auto">
                	<li class="nav-item" style="font-size: 16px;">
                        <a id="logininfo" class="dropdown-item" href="#"></a>
                    </li>                    
                </ul>
            </div>
        </nav>
    </div>
    <script type="text/javascript">
    
	 //   window.onload = function () {
	        var winner = getCookie("s_wnn_yn").trim();
            if (winner === 'Y') {
	          	document.getElementById("hospserchtop").style.display = "flex";
	        }
      
	 //   };
 		// 계약정보도  Login시 Cookie에 담아서 활용해야 됨. 아님,*** 추가해야될 내용에서 적용해도 됨.
    	// 공용변수로 사용
    	hosp_conact() ;
    	var hospid = getCookie("hospid");   // 병원아이디
	    var userid = getCookie("userid");   // 사용자아이디
	    var hospnm = getCookie("s_hospnm"); // 병원이름
	    var usernm = getCookie("s_usernm"); // 사용자이름
	    var mainfg = getCookie("s_mainfg"); // 관리자구분(1.위너넷관리자, 2.위너넷사용자, 3.병원관리자, 4.병원사용자)
	    var use_yn = getCookie("s_use_yn"); // 사용여부(Y,정상사용자, N.종료사용자)
	    if  (getCookie("s_winconect") != 'Y') {
	        document.getElementById('logininfo').innerHTML = `<i class="fas fa-power-off mr-2"></i> ` 
	                                                     + hospnm + `  [ ` 
	                                                     + usernm + `님 ] 반갑습니다 !! ( 종료하기 ) `;
	    }else{
	        document.getElementById('logininfo').innerHTML = `<i class="fas fa-power-off mr-2"></i> ` 
										                + hospnm + `  [ ` 
										                + usernm + `님 ] 위너넷접속 !! ( 종료하기 ) `;	    	
	    }
	    
	 // 권한 쿠키 가져오기 TBL_USERAUTH_MST 테이블에 정의  
	    let s_insauth = getCookie("s_insauth");
	    let s_updauth = getCookie("s_updauth");
	    let s_delauth = getCookie("s_delauth");
	    let s_inqauth = getCookie("s_inqauth");
	    
	    function getCookie(name) {
	        var search = name + "=";
	        if (document.cookie.length > 0) {
	            offset = document.cookie.indexOf(search);
	            if (offset != -1) {                              
	                offset += search.length;                     
	                end = document.cookie.indexOf(";", offset); 
	                if (end == -1)
	                    end = document.cookie.length;
	                return unescape(document.cookie.substring(offset, end));
	            }
	        }
	    }
	    
	    // *** 추가해야될 내용 Start ***
	    // 여기서, 계약정보,메뉴설정 관련 Table 정보 가져와 구성해도 될 듯
	    // 계약정보에 따라 기준정보????, 진료비분석,적정성평가 button:none,display / Dashboard 구성변경(진료비분석,적정성평가) 또는 Dashboard1, Dashboard2로 화면 2개 구성 	     
	    // 관리자여부에 따라 메뉴보기 정리필요 (메뉴권한에 따른 따른 메뉴구성도 고민해야 됨)	
	    // File Upload 권한관리 필요
	    // *** 추가해야될 내용 End ***
	    
	    
	    // 일단, 단순하게 메뉴보기만 설정하고 넘어감
	    // 전체 메뉴보기
		function clearMenuActive() {
		    $('.top-menu-btn').removeClass('active');
		}
		
		$('#top-menu_a').on('click', function () {
		    clearMenuActive();
		    $(this).addClass('active');
		    $('.menu-section').hide();
		    $('#menu-a, #menu-b, #menu-c, #menu-d').show();
		});
		
		$('#top-menu_b').on('click', function () {
		    clearMenuActive();
		    $(this).addClass('active');
		    $('.menu-section').hide();
		    $('#menu-b').show();
		});
		
		$(document).on('click', '#top-menu_c_btn', function () {
		    clearMenuActive();
		    $(this).addClass('active');
		    $('.menu-section').hide();
		    $('#menu-c').show();
		});
		
		$(document).on('click', '#top-menu_d_btn', function () {
		    clearMenuActive();
		    $(this).addClass('active');
		    $('.menu-section').hide();
		    $('#menu-d').show();
		});
		$("#hospserchtop").on("click", function () {
		    openHospitalSearchtop(function (data) {
		        // 세션에 저장
		        sessionStorage.setItem('hospid', data.hospCd);  
		        sessionStorage.setItem('s_hospid', data.hospCd);  
		        sessionStorage.setItem('s_hospnm', data.hospNm);
		        sessionStorage.setItem('s_winconect', 'Y');
		        // 쿠키 덮어쓰기 (1일 유지)
		        setCookie("hospid", data.hospCd, 1);
		        setCookie("s_hospid", data.hospCd, 1);
		        setCookie("s_hospnm", data.hospNm, 1);
		        setCookie("s_conact_gb", data.conactGb, 1); // 메뉴설정체크 A. 전체 1.적정성 2. 진료비분석 
		        setCookie("s_winconect", 'Y',1);
		        hospid = getCookie("hospid");   // 병원아이디
		        if (hospnm != getCookie("s_hospnm")){
		        	//hosp_conact();
		        	location.reload(); // 페이지 새로고침
		            return;            // reload 이후의 코드는 실행 안 되게 return
		        } 
		        hospnm = getCookie("s_hospnm"); 
		        
		        document.getElementById('logininfo').innerHTML = `<i class="fas fa-power-off mr-2"></i> ` 
										                    + hospnm + `  [ ` 
										                    + usernm + `님 ] 위너넷접속 !! ( 종료하기 ) `;
		    });
		});
        function setCookie(name, value, expiredays) {
            var todayDate = new Date();
            todayDate.setDate(todayDate.getDate() + expiredays);
            document.cookie = name + "=" + escape(value) + "; path=/; expires=" + todayDate.toGMTString() + ";"
        }
		function openHospitalSearchtop(callback) {
		    openCommonSearch("hospital", function (data) {
		        console.log("받은 병원 데이터:", data);
		        if (data && data.hospCd && data.hospCd.trim() !== "") {
		        	console.log("정상 데이터:", data);
		            callback(data);
		        } else {
		            console.warn("🚨 유효하지 않은 병원 데이터:", data);
		            alert("선택한 병원의 정보가 올바르지 않습니다. 다시 시도해주세요.");
		        }
		    });
		}		
		   //계약관련 메뉴설정체크 A. 전체 1.진료비분석 2. 적정성평가 
	function hosp_conact() {
	    let s_conact_gb = getCookie("s_conact_gb");
	
	    // top-menu_c 영역 구성
	    let menuArea = document.getElementById("top-menu_c");
	    let menuHTML = '';
	    menuArea.innerHTML = '';
	
	    if (s_conact_gb === 'A' || s_conact_gb === '1') {
	        menuHTML += `<a href="#" class="btn btn-rounded btn-light btn-sm top-menu-btn consulting-menu" id="top-menu_c_btn" data-type="analysis">진료비분석</a>`;
	    } else if (s_conact_gb === '2') {
	        menuHTML += `<a href="#" class="btn btn-rounded btn-light btn-sm top-menu-btn consulting-menu" id="top-menu_c_btn" data-type="evaluation">적정성평가</a>`;
	    }
	
	    menuArea.insertAdjacentHTML("beforeend", menuHTML);
	
	    // top-menu_d 영역 구성
	    let menuArea_d = document.getElementById("top-menu_d");
	    let menuHTML_d = '';
	    menuArea_d.innerHTML = '';
	
	    if (s_conact_gb === 'A') {
	        menuHTML_d += `<a href="#" class="btn btn-rounded btn-light btn-sm top-menu-btn consulting-menu" id="top-menu_d_btn" data-type="evaluation">적정성평가</a>`;
	    }
	
	    menuArea_d.insertAdjacentHTML("beforeend", menuHTML_d);
	
	    // ★ localStorage에 저장된 선택 메뉴 복원
	    const selectedTopMenu = localStorage.getItem('selectedTopMenu');
	    if (selectedTopMenu) {
	        const selectedBtn = document.getElementById(selectedTopMenu);
	        if (selectedBtn) {
	            selectedBtn.classList.add('active');
	        }
	    }
	}

	// 클릭 시 active 클래스 부여 및 저장
	$(document).on('click', '.top-menu-btn', function () {
	    $('.top-menu-btn').removeClass('active');
	    $(this).addClass('active');

	    // 선택된 top-menu ID 저장
	    localStorage.setItem('selectedTopMenu', $(this).attr('id'));
	});

	// 페이지 로드시 저장된 메뉴 상태 복원
	$(document).ready(function () {
	    const selectedTopMenu = localStorage.getItem('selectedTopMenu');
	    if (selectedTopMenu) {
	        const selectedBtn = document.getElementById(selectedTopMenu);
	        if (selectedBtn) {
	            selectedBtn.classList.add('active');
	            $('#' + selectedTopMenu).trigger('click');  // ⭐ 클릭 이벤트 강제 발생
	        }
	    }
	});

	</script>
    <c:import url="sidebar.jsp" />
