<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<link href="/css/winmc/style_login.css?v=123" rel="stylesheet">

<style>
/* ===== 상단 메뉴 버튼 스타일 ===== */
.top-menu-btn {
    display: inline-flex;
    align-items: center;
    gap: 6px;
    padding: 10px 18px;
    border-radius: 4px !important;
    font-size: 14px;
    font-weight: 600;
    border: 1.5px solid #42A5F5 !important;
    background-color: #ffffff;
    color: #2196F3;
    cursor: pointer;
    transition: all 0.2s ease;
    text-decoration: none;
    white-space: nowrap;
    margin-right: 4px;
}
.top-menu-btn:hover {
    background-color: #E3F2FD;
    border-color: #1E88E5 !important;
    color: #1976d2;
    text-decoration: none;
}
.top-menu-btn.active,
.top-menu-btn:active {
    background-color: #2196f3 !important;
    border-color: #2196f3 !important;
    color: #ffffff !important;
    box-shadow: 0 2px 6px rgba(33,150,243,0.3);
    text-decoration: none;
}
.top-menu-btn.active:hover {
    background-color: #1976d2 !important;
    border-color: #1976d2 !important;
    color: #ffffff !important;
    text-decoration: none;
}

/* 병원검색, 종료하기 등 메뉴 외 버튼 (동일 스타일, JS 연동 없음) */
.top-btn-sub {
    display: inline-flex;
    align-items: center;
    gap: 6px;
    padding: 10px 18px;
    border-radius: 4px !important;
    font-size: 14px;
    font-weight: 600;
    border: 1.5px solid #42A5F5 !important;
    background-color: #ffffff;
    color: #2196F3;
    cursor: pointer;
    transition: all 0.2s ease;
    text-decoration: none;
    white-space: nowrap;
    margin-right: 4px;
}
.top-btn-sub:hover {
    background-color: #E3F2FD;
    border-color: #1E88E5 !important;
    color: #1976d2;
    text-decoration: none;
}
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
						<a href="/user/dashboard.do"
						   id="top-menu_a"
						   class="btn btn-light btn-sm top-menu-btn border">
						   <i class="fas fa-bars"></i> 전체메뉴
						</a>

						<a href="/main/magamFileUpload.do"
						   id="top-menu_b"
						   class="btn btn-light btn-sm top-menu-btn border">
						   <i class="fas fa-cloud-upload-alt"></i> 자료올리기
						</a>
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
                       class="btn btn-light btn-sm top-btn-sub border"
                       style="display: none !important;"
                     >
                       <i class="fas fa-search"></i> <span>병원검색</span>
                     </button>
                     <!--    
                     <button id="googlesheets" onclick="googleSheet()" class="btn btn-sm btn-primary" style="display: none;">🌐구글시트</button>
                     -->
                     
                 </div>
               </li>
                </ul>    
                <ul class="navbar-nav ml-auto">
                   <li class="nav-item"  style="font-size: 16px;">
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
            //   document.getElementById("googlesheets").style.display = "flex";
           }
      
    //   };
    
    	
    	function googleSheet(url) {
			if (!url || typeof url !== 'string' || url.trim() === '') {
		        window.open('https://docs.google.com/spreadsheets/u/0/', '_blank');
		    } else {
		        window.open(url, '_blank');
		    }	
			// window.open('https://docs.google.com/spreadsheets/d/1kZ9Y98S-njt7-u6ey4_CxE1jECF9SJOR1Ts2IN2wfdk/edit?gid=0#gid=0', '_blank');
		}
    	
    
       // 계약정보도  Login시 Cookie에 담아서 활용해야 됨. 아님,*** 추가해야될 내용에서 적용해도 됨.
       // 공용변수로 사용
       hosp_conact() ;
       var hospid = getCookie("hospid");   // 병원아이디
       var userid = getCookie("userid");   // 사용자아이디
       var hospnm = getCookie("s_hospnm"); // 병원이름
       var usernm = getCookie("s_usernm"); // 사용자이름
       var mainfg = getCookie("s_mainfg"); // 관리자구분(1.위너넷관리자, 2.위너넷사용자, 3.병원관리자, 4.병원사용자)
       var use_yn = getCookie("s_use_yn"); // 사용여부(Y,정상사용자, N.종료사용자)
       
       var closeDt1 = getCookie("s_closeDt1");
       var closeDt2 = getCookie("s_closeDt2");
      
       function closeTab() {
           window.close(); // 현재 탭 닫기
           self.close();   // 일부 브라우저에서 추가적으로 닫기 시도
       }
       
       //'진료비: '+ closeDt2 +'-'+ '적정성: ' + closeDt1 + '   ' + 

       if  (getCookie("s_winconect") != 'Y') {
           document.getElementById('logininfo').innerHTML = hospnm + `  [ `
                                                          + usernm + `님 ] 반갑습니다 !! &nbsp;&nbsp;&nbsp;`
                                                          + `<button type="button" class="btn btn-light btn-sm top-btn-sub border" onclick="closeTab()"><i class="fas fa-power-off mr-1"></i> 종료하기</button>`;
       }else{
           document.getElementById('logininfo').innerHTML = '진료비: '+ closeDt2 +'-'+ '적정성: ' + closeDt1 + '   ' +  hospnm + `  [ `
                                                          + usernm + `님 ] 위너넷접속 !! &nbsp;&nbsp;&nbsp;`
                                                          + `<button type="button" class="btn btn-light btn-sm top-btn-sub border" onclick="closeTab()"><i class="fas fa-power-off mr-1"></i> 종료하기</button>`;
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
	      // 위너넷일때 전체화면 보이게
	      let s_conact_gb = (getCookie("s_winconect") == 'Y') ? "A" : getCookie("s_conact_gb");

	      if (s_conact_gb == 'A') {
	          $('#menu-a, #menu-b, #menu-c, #menu-d, #menu-e, #menu-f, #menu-g, #menu-h').show();
	      }else if (s_conact_gb == '1') { //경영분석 
	          $('#menu-a, #menu-b, #menu-c, #menu-g, menu-h').show();
	      }else if (s_conact_gb == '2') { //적정성평가 
	          $('#menu-a, #menu-b, #menu-d, #menu-e, #menu-f').show();
	      }
      });
      
      $('#top-menu_b').on('click', function () {
    	  clearMenuActive();
		  $(this).addClass('active');
		  $('.menu-section').hide();
		  let s_conact_gb = getCookie("s_conact_gb");
		  if (s_conact_gb == 'A') {
		      $('#menu-a, #menu-b, #menu-c, #menu-d , #menu-e, #menu-f, #menu-g, #menu-h').show();
		  } else {
		  	$('#menu-b').show();
		  }
      });
      
      $('#top-menu_c_btn').on('click', function () {
    	  clearMenuActive();
		  $(this).addClass('active');
		  $('.menu-section').hide();
		  let s_conact_gb = getCookie("s_conact_gb");
		  if (s_conact_gb == 'A') {
		      $('#menu-a, #menu-b, #menu-c, #menu-d , #menu-e, #menu-f, #menu-g, #menu-h').show();
		  }else if (s_conact_gb == '1') { //진료비분석
		  	$('#menu-c').show();
		  }
      });
      
      $('#top-menu_d_btn').on('click', function () {
    	  clearMenuActive();
		  $(this).addClass('active');
		  $('.menu-section').hide();
		    
		  let s_conact_gb = getCookie("s_conact_gb");
		  if (s_conact_gb == 'A') {
		      $('#menu-a, #menu-b, #menu-c, #menu-d , #menu-e, #menu-f, #menu-g, #menu-h').show();
		  }else if (s_conact_gb == '2') { //적정성평가 
		  	  $('#menu-d, #menu-e, #menu-f').show();
		  }
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

              setCookie("s_closeDt1", data.closeDt1, 1);
              setCookie("s_closeDt2", data.closeDt2, 1);
              
              hospid = getCookie("hospid");   // 병원아이디
              if (hospnm != getCookie("s_hospnm")){
                 //hosp_conact();
                 location.reload(); // 페이지 새로고침
                  return;            // reload 이후의 코드는 실행 안 되게 return
              } 
              hospnm = getCookie("s_hospnm");
              // 병원 변경 없이 재선택 시에도 버튼 표시
            //  $('#btnCreateAllHosp').show();
            //  $('#btnEvalAllHosp').show();
              document.getElementById('logininfo').innerHTML =
                    //  '진료비: '+ closeDt2 +'~'+ '적정성: ' + closeDt1 + '   '
                      hospnm + `  [ `
                    + usernm + `님 ] 위너넷접속 !! &nbsp;&nbsp;&nbsp;`
                    + `<button type="button" class="btn btn-light btn-sm top-btn-sub border" onclick="closeTab()"><i class="fas fa-power-off mr-1"></i> 종료하기</button>`;
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
          menuHTML += `<a href="/user/dashboard.do" class="btn btn btn-light btn-sm top-menu-btn border" id="top-menu_c_btn" data-type="analysis"><i class="fas fa-chart-bar"></i> 진료비분석</a>`;
       } else if (s_conact_gb === '2') {
          menuHTML += `<a href="/user/dashboard.do" class="btn btn btn-light btn-sm top-menu-btn border" id="top-menu_d_btn" data-type="evaluation"><i class="fas fa-clipboard-check"></i> 적정성평가</a>`;
       }
   
       menuArea.insertAdjacentHTML("beforeend", menuHTML);
   
       // top-menu_d 영역 구성
       let menuArea_d = document.getElementById("top-menu_d");
       let menuHTML_d = '';
       menuArea_d.innerHTML = '';
   
       if (s_conact_gb === 'A') {
           menuHTML_d += `<a href="/user/dashboard.do" class="btn  btn btn-light btn-sm top-menu-btn border" id="top-menu_d_btn" data-type="evaluation"><i class="fas fa-clipboard-check"></i> 적정성평가</a>`;
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

   $(document).ready(function () {
       let isFirstLogin = sessionStorage.getItem('isFirstLogin'); // 세션 기준으로 최초 로그인 여부 확인
       let selectedTopMenu;

       if (!isFirstLogin) {
           // 최초 로그인: top-menu_a 클릭
           selectedTopMenu = 'top-menu_a';
           sessionStorage.setItem('isFirstLogin', 'false'); // 이후부터는 최초 아님
       } else {
           // 이후: 마지막 선택 메뉴 사용 (없으면 top-menu_a로 fallback)
           selectedTopMenu = localStorage.getItem('selectedTopMenu') || 'top-menu_a';
       }
       
       
       // 메뉴 활성화 및 클릭 이벤트 실행
       $('.top-menu-btn').removeClass('active');
       $('#' + selectedTopMenu).addClass('active').trigger('click');
   });

   // 메뉴 클릭 시 처리
   $(document).on('click', '.top-menu-btn', function () {
       $('.top-menu-btn').removeClass('active');
       $(this).addClass('active');

       // 선택된 메뉴 ID 저장
       localStorage.setItem('selectedTopMenu', $(this).attr('id'));
   });
   </script>
    <c:import url="sidebar.jsp" />

