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
    <div class="dashboard-header" id="dashboard-header">
        <nav class="navbar navbar-expand-lg bg-white fixed-top" id="top-navbar">
    <script>
    // iframe 안에서 열리면 로고 링크만 숨김 (메뉴는 유지)
    try {
        if (window.self !== window.top) {
            var brand = document.querySelector('.navbar-brand');
            if (brand) brand.style.display = 'none';
        }
    } catch(e) {
        // 크로스 오리진이면 iframe 안임
        var brand = document.querySelector('.navbar-brand');
        if (brand) brand.style.display = 'none';
    }
    </script>
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
                         <%-- QPS(질향상·환자안전) — 적정성평가와 별개 업무라 탭을 따로 둔다(2026-08-09).
                              ★기본 숨김. 사이드바 #menu-qps 와 같은 게이트(위너넷 + 개발자 플래그)를 쓰며,
                                sidebar.jsp 의 qpsDev 스크립트가 이 버튼도 함께 켠다.
                              ★정식 오픈 시 : 계약구분(s_conact_gb)에 QPS 코드를 추가해 hosp_conact() 에서 그리면 된다. --%>
                         <a href="/main/qpsIndex.do" id="top-menu_qps"
                            class="btn btn-light btn-sm top-menu-btn border" style="display:none;"
                            data-type="qps"><i class="fas fa-heartbeat"></i> QPS</a>
                         <!-- 2024년 표준화구간 안내 토글 (적정성평가 화면에서만 노출/연결: assessment.jsp) -->
                         <button type="button" id="btnStdRange" class="btn btn-light btn-sm top-btn-sub border" style="display:none; padding-left:10px; padding-right:10px; color:#000 !important;">2024년 표준화구간</button>
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
                   <li class="nav-item"  style="font-size: 14px;">
                        <a id="logininfo" class="dropdown-item" href="#" style="white-space: nowrap;"></a>
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
           // iframe 안에서 실행 중이면 부모에게 postMessage로 닫기 요청
            if (window.parent !== window) {
               window.parent.postMessage('closeWinCheck', '*');
               return;
           } 
           window.close();
           self.close();
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
              // [복구 2026-06-10] 세션쿠키(만료일 없음)로 바꿨더니 브라우저 종료 시 s_hospid 쿠키가
              //   사라져, 다시 접속한 전 병원에서 대시보드가 500(쿠키 없음 → 서버 NPE)으로 깨졌다.
              //   → 기존처럼 1일 유지 영구쿠키로 환원. 직접 URL 우회 차단은 서버(dashboard.do)에서
              //   쿠키 없으면 로그인 화면을 반환하는 방식으로 대체 처리.
              setCookie("s_hospid", data.hospCd, 1);
              setCookie("s_hospnm", data.hospNm, 1);
              setCookie("s_conact_gb", data.conactGb, 1); // 메뉴설정체크 A. 전체 1.적정성 2. 진료비분석
              setCookie("s_winconect", 'Y', 1);

              setCookie("s_closeDt1", data.closeDt1, 1);
              setCookie("s_closeDt2", data.closeDt2, 1);
              
              hospid = getCookie("hospid");   // 병원아이디
              if (hospnm != getCookie("s_hospnm")){
                 //hosp_conact();
                 // 병원검색으로 방금 병원을 선택했다는 1회용 표식 — 월보고 목록이 콤보를 그 병원으로 세팅(그 외 진입은 전체).
                 try{ sessionStorage.setItem('hospPicked', '1'); }catch(e){}
                 // 실제 경로로 이동 (URL 숨김 때문에 location.reload() 대신 사용)
                 var realPath = sessionStorage.getItem('_realPath') || location.pathname;
                 location.href = realPath;
                  return;
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
        // [보안] 세션 쿠키(만료일 미설정) — 브라우저 종료 시 자동 삭제. 인증/식별 쿠키 전용.
        function setSessionCookie(name, value) {
            document.cookie = name + "=" + escape(value) + "; path=/;";
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

   // QPS 탭 — 누르면 좌측 메뉴가 QPS 전용이 된다(다른 업무 메뉴는 감춘다).
   // ★menu-qps 는 menu-section 이 아니라 .menu-section 일괄 hide 로는 안 사라진다 → 따로 다룬다.
   $(document).on('click', '#top-menu_qps', function () {
       // ★게이트 재확인 — '마지막 선택 탭' 복원(localStorage)이 새 세션에서 이 클릭을 자동으로 일으킨다.
       //   그때 게이트를 안 보면 qps 를 치지 않았는데도 QPS 메뉴가 펼쳐진다.
       if (typeof qpsMenuOn === 'function' && !qpsMenuOn()) {
           localStorage.removeItem('selectedTopMenu');
           $('#top-menu_a').trigger('click');
           return false;
       }
       $('.top-menu-btn').removeClass('active');
       $(this).addClass('active');
       $('.menu-section').hide();
       // ★QPS 만 남기고 전부 걷어낸다(2026-08-09 지시 "QPS만 넣고 다 제외") — 항목을 나열하지 않고
       //   사이드바 목록(#sbAllMenu)의 QPS 외 전부를 숨긴다. 그래야 메뉴가 새로 생겨도 QPS 탭에 안 샌다.
       //   · '지금 보이는 것'만 qps-tab-hid 로 표시 후 숨긴다 — 권한 게이트로 숨겨져 있던 메뉴(관리자 1:1 등)를
       //     다른 탭에서 무조건 show 로 복원하면 일반 계정에도 떠 버린다.
       //   · .menu-section 은 표시하지 않고 그냥 숨긴다 — 저 그룹은 각 탭 핸들러가 계약구분으로
       //     보임/숨김을 다시 정하므로, 우리가 복원하면 계약 필터와 싸운다.
       $('#sbAllMenu > li').not('#menu-qps').not('.menu-section').not('.nav-divider')
           .filter(':visible').addClass('qps-tab-hid').hide();
       $('#menu-qps').show();
       $('#qps-sub').addClass('show');       // 서브메뉴를 펼친 채로 — 탭을 눌렀으면 그 안을 보려는 것이다
   });
   // 다른 탭을 누르면 QPS 메뉴는 숨기고, QPS 탭이 걷어냈던 항목을 원래대로 되살린다
   $(document).on('click', '#top-menu_a, #top-menu_b, #top-menu_c_btn, #top-menu_d_btn', function () {
       $('.qps-tab-hid').removeClass('qps-tab-hid').show();
       $('#menu-qps').hide();
       $('#qps-sub').removeClass('show');
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

