<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>  
<%@ page import = "java.util.*" %>
<!DOCTYPE html>
<html>
 <head>
<meta charset="UTF-8" />
<meta content="width=device-width, initial-scale=1.0" name="viewport">

<title>위너넷 컨설팅</title>
<!-- Favicon -->
<link href="/images/icons/wincheck.ico" rel="icon" type="image/x-icon" >

<!-- Google Web Fonts -->
<link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">

    
<!-- Customized Bootstrap Stylesheet -->
<link href="/css/winct/bootstrap.css" rel="stylesheet">
<link href="/css/winct/style.css" rel="stylesheet">

<!-- JavaScript Libraries -->

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.bundle.min.js"></script>

<!-- Template Javascript -->
<script type="text/javascript" src="/js/winct/main.js"></script>
<script type="text/javascript" src="/js/winct/message.js"></script>
<script type="text/javascript" src="/js/winct/contact.js"></script>
<script type="text/javascript" src="/js/winct/loading.js"></script>
<script type="text/javascript" src="/js/winct/jqBootstrapValidation.min.js"></script> 
</head>

<body>
 
  	<!-- Navbar Start -->
    <div class="container-fluid bg-info mb-2">
        <div class="row px-xl-8">
            <div class="col-lg-3 d-none d-lg-block">
                <a class="btn d-flex justify-content-center align-items-center bg-primary w-100" data-toggle="collapse" href="#navbar-vertical" style="height: 65px; padding: 0 30px;">
                    <h4 class="text-blue m-1">wincheck</h4>
                </a>
                <nav class="collapse position-absolute navbar navbar-vertical navbar-light align-items-start p-0 bg-light" id="navbar-vertical" style="width: calc(100% - 30px); z-index: 999;">
                    <div class="navbar-nav w-100">
                        <div class="dropdown dropright">
                            <a href="" class="nav-link dropdown-toggle" data-toggle="dropdown">wincheck Consulting Intro Page 1 <i class="fa fa-angle-right float-right mt-1"></i></a>
                            <div class="dropdown-menu position-absolute rounded-0 border-0 m-0">
                                <a href="" class="dropdown-item">wincheck Consulting Intro Page 1-1</a>
                                <a href="" class="dropdown-item">wincheck Consulting Intro Page 1-2</a>
                                <a href="" class="dropdown-item">wincheck Consulting Intro Page 1-3</a>
                            </div>
                        </div>
                        <a href="" class="nav-item nav-link">wincheck Consulting Intro Page 2 </a>
                        <a href="" class="nav-item nav-link">wincheck Consulting Intro Page 3 </a>
                        <a href="" class="nav-item nav-link">wincheck Consulting Intro Page 4 </a>
                        <a href="" class="nav-item nav-link">wincheck Consulting Intro Page 5 </a>
                        <a href="" class="nav-item nav-link">wincheck Consulting Intro Page 6 </a>
                        <a href="" class="nav-item nav-link">wincheck Consulting Intro Page 7 </a>
                        <a href="" class="nav-item nav-link">wincheck Consulting Intro Page 8 </a>
                        <a href="" class="nav-item nav-link">wincheck Consulting Intro Page 9 </a>
                    </div>
                </nav>
            </div>
            <div class="col-lg-9">
                <nav class="navbar navbar-expand-lg bg-info navbar-dark py-3 py-lg-0 px-0">
                    <div class="collapse navbar-collapse justify-content-between">
                        <div class="navbar-nav mr-auto py-0">
                            <a href="#" class="nav-item nav-link">Goto Page 1</a>
                            <a href="#" class="nav-item nav-link">Goto Page 2</a>
                            <a href="#" class="nav-item nav-link">Goto Page 3</a>                            
                            <a href="#" class="nav-item nav-link">Goto Page 4</a>
                        </div>
                        <div class="navbar-nav ml-auto py-0 d-none d-lg-block">
                            
                        </div>
                    </div>
                </nav>
            </div>
            
        </div>
    </div>
    <!-- Navbar End -->


    <!-- Carousel Start -->
    <div class="container-fluid mb-1">
        <div class="row px-xl-8">
            <div class="col-lg-8">
                <div id="header-carousel" class="carousel slide carousel-fade mb-30 mb-lg-0" data-ride="carousel">
                    <ol class="carousel-indicators">
                        <li data-target="#header-carousel" data-slide-to="0" class="active"></li>
                        <li data-target="#header-carousel" data-slide-to="1"></li>
                        <li data-target="#header-carousel" data-slide-to="2"></li>
                    </ol>
                    <div class="carousel-inner">
                        <div class="carousel-item position-relative active" style="height: 530px;">
                            <img class="position-absolute w-100 h-100" src="/images/winct/image-1.jpg" style="object-fit: fill;">
                            <div class="carousel-caption d-flex flex-column align-items-center justify-content-center">
                                <div class="p-3" style="max-width: 700px;">
                                    <!--<h1 class="display-4 text-white mb-3 animate__animated animate__fadeInDown">Image 1 .</h1>-->
                                    <!--<p class="mx-md-5 px-5 animate__animated animate__bounceIn">문구 1 ......................................................... 1</p>-->
                                    <!--<a class="btn btn-outline-light py-2 px-4 mt-3 animate__animated animate__fadeInUp" href="#">Shop Now</a>-->
                                </div>
                            </div>
                        </div>
                        <div class="carousel-item position-relative" style="height: 530px;">
                            <img class="position-absolute w-100 h-100" src="/images/winct/image-2.jpg" style="object-fit: fill;">
                            <div class="carousel-caption d-flex flex-column align-items-center justify-content-center">
                                <div class="p-3" style="max-width: 700px;">
                                    <!--<h1 class="display-4 text-white mb-3 animate__animated animate__fadeInDown">Image 2 ..</h1>-->
                                    <!--<p class="mx-md-5 px-5 animate__animated animate__bounceIn">문구 2 ......................................................... 2</p>-->
                                    <!--<a class="btn btn-outline-light py-2 px-4 mt-3 animate__animated animate__fadeInUp" href="#">Shop Now</a>-->
                                </div>
                            </div>
                        </div>
                        <div class="carousel-item position-relative" style="height: 530px;">
                            <img class="position-absolute w-100 h-100" src="/images/winct/image-3.jpg" style="object-fit: fill;">
                            <div class="carousel-caption d-flex flex-column align-items-center justify-content-center">
                                <div class="p-3" style="max-width: 700px;">
                                    <!--<h1 class="display-4 text-white mb-3 animate__animated animate__fadeInDown">Image 3 ...</h1>-->
                                    <!--<p class="mx-md-5 px-5 animate__animated animate__bounceIn">문구 3 ......................................................... 3</p>-->
                                    <!--<a class="btn btn-outline-light py-2 px-4 mt-3 animate__animated animate__fadeInUp" href="#">Shop Now</a>-->
                                </div>
                            </div>
                        </div>
                        
                    </div>
                </div>
            </div>
            <div class="col-lg-4">
                <div class="bg-light box-p-5 mb-2">
                    <div class="control-group">
                         <button class="btn btn-block btn-blue   text-md-left font-weight-bold my-2 py-2">위너넷 컨설팅 통합 가이드북. Open  &raquo;&raquo;&raquo;</button>
                    </div>
                    <div class="control-group">
                         <button class="btn btn-block btn-blue text-md-left font-weight-bold my-2 py-2">위너넷 온라인 교육 바로가기. &raquo;&raquo;&raquo;</button>
                    </div>
                        
                </div>
                <h5 class="section-title position-relative text-muted mb-1"><span class="bg-secondary pr-3">Login</span></h5>                
                <div class="contact-form bg-light box-p-10 mb-3">
                    <form name="loginForm" id="loginForm">
                        <div class="control-group">
                            <input type="text" class="form-control" id="hospid" placeholder="Hospital Number"/>
                            <p class="help-block text-danger"></p>
                        </div>
                        <div class="control-group">
                            <input type="text" class="form-control" id="userid" placeholder="User ID"/>
                            <p class="help-block text-danger"></p>
                        </div>
                        <div class="control-group">
                            <input type="password" class="form-control" id="passwd" placeholder="PassWord"/>
                            <p class="help-block text-danger"></p>
                        </div>
                        <div>
                            <button class="btn btn-block btn-blue text-center font-weight-bold my-2 py-2" id="blogin" onClick="login()">로그인</button>
                        </div>

                        <div class="row">
                            <div class="col-4">
                                <button class="btn btn-block btn btn-outline-dark text-center font-weight-bold my-1 py-2">회원가입</button>
                            </div>
                            <div class="col-4">
                                <button class="btn btn-block btn btn-outline-dark text-center font-weight-bold my-1 py-2">ID/PW찾기</button>
                            </div>
                            <div class="col-md-4">
                                <div class="form-check">
                                    <!-- <input class="form-check-input" type="checkbox"  id="saveyn" onchange="saveynchange()"> -->
                                    <input class="form-check-input" type="checkbox"  id="saveyn">
                                    <label class="form-check-label font-weight-bold" for="saveyn">아이디저장</label>
                                </div>
                                <!-- 
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox"  id="autoyn">
                                    <label class="form-check-label font-weight-bold" for="autoyn">자동로그인</label>
                                </div>
                                 -->
                            </div>
                        </div>
                    </form>
                    <!-- 로그인 후 표시될 사용자 정보 카드 -->
				    <div id="userInfoCard" style="display: none;">
				        <div class="user_card">
				            <div class="user_card-body">
				                <h1 class="user_card-title">환영합니다</h1><p></p>
				                <!-- <h2 class="user_card-text" id="hosp_name"></h3><p></p> -->
				                <h3 class="user_card-text" id="user_name"></h3><p></p>
				                <button class="btn btn-primary" onclick="logout()">로그아웃</button>
				            </div>
				        </div>
				    </div>
                </div>
                <div class="bg-light box-p-5 mb-2 style="height: 100px;">
                    <div class="row">
                        <div class="col-12">
                            <a href="#">
                                <img class="img-fluid" src="/images/winct/wincheck-02.png" alt="wincheck" href="#">
                            </a>
                        </div>
                    </div>
                    
                </div>
                
            </div>            
        </div>
    </div>
    <!-- Carousel End -->

	<div class="container-fluid mb-2">
        <div class="row px-xl-8">
            <div class="col-lg-4">
            	<div class="bg-light box-p-10" style="height: 300px;">
            		<div class="nav nav-tabs mb-2">
                        <a class="nav-item nav-link text-dark active" data-toggle="tab" href="#tab-pane-1">공지사항</a>
                    </div>
                    <div class="tab-content">
                        <div class="tab-pane fade active show" id="tab-pane-1">
                            
                        </div>
                    </div>
            	</div>
            </div>
            <div class="col-lg-4">
            	<div class="bg-light box-p-10" style="height: 300px;">
                    <div class="nav nav-tabs mb-2">
                        <a class="nav-item nav-link text-dark active" data-toggle="tab" href="#tab-pane-1">심사방</a>
                        <a class="nav-item nav-link text-dark" data-toggle="tab" href="#tab-pane-2">소식지</a>
                    </div>
                    <div class="tab-content">
                        <div class="tab-pane fade active show" id="tab-pane-1">
                            
                        </div>
                        <div class="tab-pane fade" id="tab-pane-2">
                            
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-lg-4">
                
                <div class="bg-transparent box-p-10" style="height: 100px;">
                    <div class="row">
                        <div class="col-sm-4 text-left">
                            <!--<h5 class="text-dark text-uppercase font-weight-bold">고객센터</h5>-->
                            <img class="img-fluid" src="/images/winct/c-tel-01.png" alt="고객센터">
                            <h4 class="text-dark text-uppercase font-weight-bold">02-2653-7971</h4>
                        </div>
                        <div class="col-sm-8 text-left">
                            <p class="small_font">근무시간 - 09:00 ~ 18:00</p>
                            <p class="small_font">점심시간 - 12:00 ~ 13:00</p>
                            <p class="small_font">주말/공휴일 휴무</p>
                        </div>
                    </div>
                </div>
                <div class="bg-light box-p-10" style="height: 100px;"">
                    <div class="row">
                        <div class="col-4">
                            <a href="#">
                                <img class="img-fluid" src="/images/winct/KKO_10_1.png" alt="카카오상담" href="#">
                            </a>
                        </div>
                        <div class="col-4">
                            <a href="#">
                                <img class="img-fluid" src="/images/winct/1-1_10_1.png" alt="1대1상담" href="#">
                            </a>
                        </div>
                        <div class="col-4">
                            <a href="#">
                            <img class="img-fluid" src="/images/winct/FAQ_10_1.png" alt="자주듣는질문" href="#">
                            </a>
                        </div>
                    </div>
                    
                </div>
                <div class="bg-light box-p-10" style="height: 100px;"">
                    <div class="row">
                        <div class="col-4">
                            <a href="#">
                                <img class="img-fluid" src="/images/winct/YTB_10_1.png" alt="유튜브" href="#">
                            </a>
                        </div>
                        <div class="col-4">
                            <a href="#">
                                <img class="img-fluid" src="/images/winct/BLG_10_1.png" alt="블로그" href="#">
                            </a>
                        </div>
                        <div class="col-4">
                            <a href="#">
                            <img class="img-fluid" src="/images/winct/IST_10_1.png" alt="인스타그램" href="#">
                            </a>
                        </div>
                    </div>
                    
                </div>
            </div> 
            
        </div>    
    </div>
    
    <div class="container-fluid bg-info mb-2">
        <div class="row px-xl-8">
            <div class="col-lg-12 bg-info">
			    <nav class="navbar navbar-expand-lg bg-info navbar-dark py-3 py-lg-0 px-0">
			        <div class="collapse navbar-collapse">
			            <!-- 메뉴를 가로 정렬 -->
			            <div class="navbar-nav d-flex justify-content-center w-100 py-0">
			                <a href="#" class="nav-item nav-link">위너넷 평생교육원</a>
			                <a href="#" class="nav-item nav-link">한국보험의료인증원</a>
			                <a href="#" class="nav-item nav-link">건강보험공단</a>
			                <a href="#" class="nav-item nav-link">건강보험심사평가원</a>
			                <a href="#" class="nav-item nav-link">요양기관업무포탈</a>
			                <a href="#" class="nav-item nav-link">통합사이트</a>
			            </div>
			        </div>
			    </nav>
			</div>
        </div>
    </div>
    
    <script type="text/javascript">
    	
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
        	
        	if        ($("#hospid").val().trim() === "" ){                
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
        	// LoadingUI.show({ position: 'center' });               // 화면 중앙
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
        	        	
        	    		/*
        	            winCheckOpen();
        	            location.href = CommonUtil.getContextPath() + "/main.do";
        	            */
        	            
        	            if (data.login_User){
        	            	
	        	            sessionStorage.clear();
	        	            
	        				sessionStorage.setItem('s_hospid', $("#hospid").val().trim());  // sessionStorage에 로그인 병원코드
	        				sessionStorage.setItem('s_userid', $("#userid").val().trim());  // sessionStorage에 로그인 사용자id
	        				sessionStorage.setItem('s_hospnm', data.login_Hosp); 			// sessionStorage에 로그인 병원명
	        				sessionStorage.setItem('s_usernm', data.login_User); 			// sessionStorage에 로그인 사용자명
	        				sessionStorage.setItem('s_mainfg', data.login_Main); 			// sessionStorage에 로그인 관리자구분(1.위너넷관리자, 2.위너넷사용자, 3.병원관리자, 4.병원사용자)
	        				sessionStorage.setItem('s_use_yn', data.loginUseYN); 			// 사용여부(Y,정상사용자, N.종료사용자)
	        	            
	        	            showUserInfo(); 
	        				
        	            } else {
        	            	// 세션 초기화
        	        	    sessionStorage.clear();
        	        	    // 화면 초기화
        	        	    location.reload();
        	            }
        	        } else {
        	        	
        	        	if (data.error_code === "10000") {
        	        		messageBox("4","<h5>사용자 정보가 존재하지 않습니다.</h5><p></P>" +
        	        				       "<h6>로그인 정보를 확인하고 다시 로그인하십시요 !!</h6>","hospid","","");
        	        		document.loginForm.hospid.value = "";
        	        		document.loginForm.userid.value = "";
        	        		document.loginForm.passwd.value = "";
        	        		
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
            //const url = '../template/index1.html';            
            //win_Check = window.open(url, '_blank');
            
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
