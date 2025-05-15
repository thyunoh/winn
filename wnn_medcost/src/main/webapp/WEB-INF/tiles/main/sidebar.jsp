<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;700&display=swap"rel="stylesheet">
<link href="/images/icons/winnernet.ico" rel="icon" type="image/x-icon" >
<!-- Customized Bootstrap Stylesheet -->
<!-- Bootstrap -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<link href="/css/winmc/bootstrap.css"   rel="stylesheet">
<link href="/css/winmc/style.css?v=123" rel="stylesheet">
<!-- Template Javascript -->
<!-- ============================================================== -->
<!-- sidebar start -->
<!-- ============================================================== -->
<!-- <c:if test='${not empty cookie.s_wnn_yn and cookie.s_wnn_yn.value == "Y"}'>  -->
<!--  </c:if> -->
<style>
</style>
<div class="nav-left-sidebar" style="background-color: white; color: black;">
    <div class="menu-list">
        <nav class="navbar navbar-expand-lg navbar-white">
            <a class="d-xl-none d-lg-none" href="#">Dashboard</a>
            <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav" aria-controls="navbarNav" 
                                                                         aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav flex-column">
                    <li class="nav-divider">
                        Menu
                    </li>
                    <li class="nav-item ">
                        <a class="nav-item nav-link" href="/user/dashboard.do"><i class="fas fa-chart-bar"></i>DashBoard</a>                        
                    </li>
                
                    <li class="nav-item menu-section">
                        <a class="nav-item nav-link"  href="#" data-toggle="collapse" aria-expanded="false" data-target="#user-info" aria-controls="user-info">
                                                                                      <i class="fas fa-cloud-upload-alt"></i>요양기관등록</a>
                        <div id="user-info" class="collapse submenu" style="background-color: white;">
                            <ul class="nav flex-column">
                                <li class="nav-item">
                                    <a class="nav-item nav-link"  href="/user/license.do">라이센스면허등록</a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-item nav-link"  href="/user/licnumber.do">인력신고현황등록</a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-item nav-link"  href="/user/dietcd.do">가산식대등록</a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-item nav-link"  href="/user/pusercd.do">사용자등록</a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-item nav-link"  href="/user/userauthcd.do">사용자권한관리</a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-item nav-link"  href="/user/wardcd.do">병동현황등록</a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-item nav-link"  href="/user/hospgrdcd.do">의사간호사등급현황</a>
                                </li>
                           </ul>
                        </div>
                    </li> 
                    <!-- 기준정보 -->
                    <li class="nav-item">
                        <a class="nav-item nav-link"  href="#" data-toggle="collapse" aria-expanded="false" data-target="#base-info" aria-controls="base-info">
                                                                                                            <i class="fas fa-list-ul"></i>기준정보</a>
                        <div id="base-info" class="collapse submenu" style="background-color: white;">
                            <ul class="nav flex-column">
                                <li class="nav-item">
                                    <a class="nav-item nav-link"  href="#" data-toggle="collapse" aria-expanded="false" data-target="#base-info-1" 
                                                                                                                aria-controls="base-info-1">각종코드 관리</a>
                                    <div id="base-info-1" class="collapse submenu" style="background-color: white;">
                                        <ul class="nav flex-column">
                                            <li class="nav-item" id = "comcode">
                                                <a class="nav-item nav-link"  href="/base/commcd.do">공통코드</a>
                                            </li>
									        <li class="nav-item">
									            <a class="nav-item nav-link" href="#" data-toggle="collapse" aria-expanded="false" 
									              data-target="#hira-code" aria-controls="hira-code">심평원고시코드
									            </a>
									            <div id="hira-code" class="collapse submenu" style="background-color: white; padding-left: 15px;">
									                <ul class="nav flex-column">
									                    <li class="nav-item">
									                        <a class="nav-item nav-link" href="/base/sugacd.do">수가코드</a>
									                    </li>
									                    <li class="nav-item">
									                        <a class="nav-item nav-link" href="/base/yakgacd.do">약가코드</a>
									                    </li>
									                    <li class="nav-item">
									                        <a class="nav-item nav-link" href="/base/jaeryocd.do">재료대코드</a>
									                    </li>
									                </ul>
									            </div>
									        </li>                                         
                                            <li class="nav-item">
                                                <a class="nav-item nav-link"  href="/base/disecd.do">상병코드</a>
                                            </li>
                                             <li class="nav-item">
                                                <a class="nav-item nav-link"  href="/base/wvalcd.do">가중치코드</a>
                                            </li>
                                            <li class="nav-item" id = "ratecode">
                                                <a class="nav-item nav-link"  href="/base/claimcd.do">유형별 청구율관리</a>
                                            </li>
                                        </ul>
                                    </div>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-item nav-link"  href="#" data-toggle="collapse" aria-expanded="false" data-target="#base-info-2" 
                                                                             aria-controls="base-info-2">기준코드 관리</a>
                                    <div id="base-info-2" class="collapse submenu" style="background-color: white;">
                                        <ul class="nav flex-column">
                                            <li class="nav-item" id = "samcode">
                                                <a class="nav-item nav-link"  href="/base/samvercd.do">샘파일 버전</a>
                                            </li>
                                            <li class="nav-item">
                                                <a class="nav-item nav-link"  href="/base/sugacd.do">적정성 지표</a>
                                            </li>
                                        </ul>
                                    </div>
                                </li>
                                <li class="nav-item"  id="hospcont">
                                    <a class="nav-item nav-link"  href="#" data-toggle="collapse" aria-expanded="false" data-target="#base-info-3" 
                                                                             aria-controls="base-info-3">병원정보 관리</a>
                                    <div id="base-info-3" class="collapse submenu" style="background-color: white;">
                                        <ul class="nav flex-column">
											<li class="nav-item">
											    <a class="nav-item nav-link" href="/user/hospcd.do">계약관리</a>
											</li>
                                            <li class="nav-item">
                                                <a class="nav-item nav-link"  href="/user/mbrcd.do">회원가입현황</a>
                                            </li>
                                            <li class="nav-item">
                                                <a class="nav-item nav-link"  href="/base/sugacd.do">수납관리</a>
                                            </li>
                                            <li class="nav-item">
                                                <a class="nav-item nav-link"  href="/chung/chgsimsa.do">청구심사조회</a>
                                            </li>
                                        </ul>
                                    </div>
                                </li>
                                <li class="nav-item" id = "wnnauth1">
                                    <a class="nav-item nav-link"   href="#" data-toggle="collapse" aria-expanded="false" 
                                                                data-target="#base-info-4" aria-controls="base-info-4">정보운영관리</a>
                                    <div id="base-info-4" class="collapse submenu" style="background-color: white;">
                                        <ul class="nav flex-column">
                                            <li class="nav-item">
                                                <a class="nav-item nav-link"  href="/user/wnnauthcd.do">위너넷권한관리</a>
                                            </li>
                                            <li class="nav-item">
                                                <a class="nav-item nav-link"  href="/mangr/noticd.do">공지사항</a>
                                            </li>
                                            <li class="nav-item">
                                                <a class="nav-item nav-link"  href="/mangr/asqcd.do">질의응답</a>
                                            </li>
                                            <li class="nav-item">
                                                <a class="nav-item nav-link"  href="/mangr/faqcd.do">자주하는 질문</a>
                                            </li>
                                        </ul>
                                    </div>
                                </li>
                            </ul>
                        </div>
                    </li>
                    <li class="nav-item menu-section" id="menu-b">
                        <a class="nav-item nav-link"  href="#" data-toggle="collapse" aria-expanded="false" data-target="#file-upload" aria-controls="file-upload">
                                                                                      <i class="fas fa-cloud-upload-alt"></i>자료올리기</a>
                        <div id="file-upload" class="collapse submenu" style="background-color: white;">
                            <ul class="nav flex-column">
                                <li class="nav-item">
                                    <a class="nav-item nav-link"  href="/base/magamFileUpload.do">청구.평가 업로드</a>
                                </li>
                                <li class="nav-item">
						            <a class="nav-item nav-link" href="#" data-toggle="collapse" aria-expanded="false" 
						              data-target="#lic_excel" aria-controls="lic_excel">기타.자료 업로드
						            </a>
						            <div id="lic_excel" class="collapse submenu" style="background-color: white; padding-left: 15px;">
						                <ul class="nav flex-column">
						                    <li class="nav-item">
						                        <a class="nav-item nav-link" href="/user/licexcel.do">인력신고현황 엑셀</a>
						                    </li>
						                </ul>
						            </div>
							   </li>                                     
                            </ul>
                        </div>
                    </li>
                    
                    <!-- 진료비 분석 보고서 -->    
                    <li class="nav-item menu-section" id="menu-c">
                        <a class="nav-item nav-link"  href="#" data-toggle="collapse" aria-expanded="false" data-target="#management" aria-controls="management">
                                                                                         <i class="fas fa-cogs"></i>분야별통계</a>
                        <div id="management" class="collapse submenu" style="background-color: white;">
                            <ul class="nav flex-column">
                                <li class="nav-item">
                                    <a class="nav-item nav-link"  href="#" data-toggle="collapse" aria-expanded="false" data-target="#management-1" 
                                                                                                       aria-controls="management-1">진료실적통계</a>
                                    <div id="management-1" class="collapse submenu" style="background-color: white;">
                                        <ul class="nav flex-column">
                                            <li class="nav-item">
                                                <a class="nav-item nav-link"  href="/tong/f_tong_00.do">일당,건당진료비</a>
                                            </li>
                                            <li class="nav-item">
                                                <a class="nav-item nav-link"  href="/tong/f_tong_02.do">진료과별 건당진료비</a>
                                            </li>
                                            <li class="nav-item">
                                                <a class="nav-item nav-link"  href="/tong/f_tong_05.do">전문의별 건당진료비</a>
                                            </li>
                                            <li class="nav-item">
                                                <a class="nav-item nav-link"  href="/tong/f_tong_04.do">다빈도상병 진료구성비</a>
                                            </li>
                                            <li class="nav-item">
                                                <a class="nav-item nav-link"  href="/tong/f_tong_06.do">유형별 건당진료비</a>
                                            </li>                                            
                                            <li class="nav-item">
                                                <a class="nav-item nav-link"  href="/tong/f_tong_07.do">전문의별 전월대비진료비</a>
                                            </li> 
                                        </ul>
                                    </div>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-item nav-link"  href="#" data-toggle="collapse" aria-expanded="false" data-target="#management-2" 
                                                                                                       aria-controls="management-2">진료대비 약제비율</a>
                                    <div id="management-2" class="collapse submenu" style="background-color: white;">
                                      <ul class="nav flex-column">
                                            <li class="nav-item">
						                        <a class="nav-item nav-link" href="/tong/f_tong_08.do">정액환자(비청구분)</a>
						                    </li>
						                    <li class="nav-item">
						                        <a class="nav-item nav-link" href="/tong/f_tong_081.do">정액환자(전체)</a>
						                    </li>
						                    <li class="nav-item">
						                        <a class="nav-item nav-link" href="/tong/f_tong_082.do">행위환자</a>
						                    </li>
						                    <li class="nav-item">
						                        <a class="nav-item nav-link" href="/tong/f_tong_083.do">전체환자</a>
						                    </li>
                                      </ul>
                                    </div>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-item nav-link"  href="#" data-toggle="collapse" aria-expanded="false" data-target="#management-3" 
                                                                                                       aria-controls="management-3">주요지표통계</a>
                                    <div id="management-3" class="collapse submenu" style="background-color: white;">
                                      <ul class="nav flex-column">
                                         <li class="nav-item">
                                              <a class="nav-item nav-link"  href="/tong/f_tong_01.do">진료지표</a>
                                          </li>
                                      </ul>
                                    </div>
                                </li>                                
                                <li class="nav-item">
                                    <a class="nav-item nav-link"  href="#" data-toggle="collapse" aria-expanded="false" data-target="#management-4" 
                                                                                                       aria-controls="management-4">처치항목별통계</a>
                                    <div id="management-4" class="collapse submenu" style="background-color: white;">
                                      <ul class="nav flex-column">
                                             <li class="nav-item">
                                                <a class="nav-item nav-link"  href="/tong/f_tong_03.do">항목별 건당진료비 구성비</a>
                                            </li>
                                            <li class="nav-item">
                                                <a class="nav-item nav-link"  href="/tong/f_tong_09.do">정액환자 비청구분 항목비율</a>
                                            </li>
                                      </ul>
                                    </div>
                                </li>
                            </ul>
                        </div>
                    </li>
                    <!-- 적정성 평가 보고서 -->
                    <!--  -->
                    <li class="nav-item menu-section" id="menu-d">
                        <a class="nav-item nav-link"  href="#" data-toggle="collapse" aria-expanded="false" data-target="#adequacy" aria-controls="adequacy">
                                                                                                         <i class="fas fa-notes-medical"></i>지표별점수확인</a>
                        <div id="adequacy" class="collapse submenu" style="background-color: white;">
                            <ul class="nav flex-column">                            
                            	<li class="nav-item">
                        			<a class="nav-item nav-link"  href="/base/sugacd.do" ><i class="fas"></i>구조영역</a>
                    			</li>
                                <li class="nav-item">
                                    <a class="nav-item nav-link"  href="#" data-toggle="collapse" aria-expanded="false" data-target="#adequacy-1" 
                                                                                                         aria-controls="adequacy-1">진료영역 지표별</a>
                                    <div id="adequacy-1" class="collapse submenu" style="background-color: white;">
                                        <ul class="nav flex-column">
                                            <li class="nav-item">
                                                <a class="nav-item nav-link"  href="/base/sugacd.do">유치도뇨관이 있는 환자율</a>
                                            </li>
                                            <li class="nav-item">
                                                <a class="nav-item nav-link"  href="/base/sugacd.do">정액수가 현황</a>
                                            </li>
                                            <li class="nav-item">
                                                <a class="nav-item nav-link"  href="/base/sugacd.do">특정기간 현황</a>
                                            </li>
                                            <li class="nav-item">
                                                <a class="nav-item nav-link"  href="/base/sugacd.do">재활치료 현황</a>
                                            </li>
                                            <li class="nav-item">
                                                <a class="nav-item nav-link"  href="/base/sugacd.do">투석치료 현황</a>
                                            </li>
                                        </ul>
                                    </div>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-item nav-link"  href="#" data-toggle="collapse" aria-expanded="false" data-target="#adequacy-2" aria-controls="adequacy-2">평가대상자</a>
                                    <div id="adequacy-2" class="collapse submenu" style="background-color: white;">
                                        <ul class="nav flex-column">
                                            <li class="nav-item">
                                                <a class="nav-item nav-link"  href="/base/sugacd.do">일당,건당진료비</a>
                                            </li>
                                            <li class="nav-item">
                                                <a class="nav-item nav-link"  href="/base/sugacd.do">다빈도 치료현황</a>
                                            </li>
                                        </ul>
                                    </div>
                                </li>                                
                            </ul>
                        </div>
                    </li>
                    <!--  -->
                </ul>
            </div>            
        </nav>
        
        <div class="fixed-sidebar-info-box">
	        <div class="col-xl-12" >
                <div class="card border-3 border-top border-top-primary">
                    <div class="card-body">
                        <img class="img-fluid" src="/images/winct/c-tel-01.png" alt="고객센터">
                        <div class="metric-value d-inline-block">
                            <h3 class="mb-1">02-2653-7971</h3>
                        </div>
                        <nav aria-label="..."></nav>
                        <ul class="pagination pagination-xl">
                       		<li class="page-item">
                       			<a href="#"><img class="img-fluid" src="/images/winct/KKO_10_1.png" alt="카카오상담"></a>
                       		</li>
                            <li class="page-item">
                            	<a href="#"><img class="img-fluid" src="/images/winct/1-1_10_1.png" alt="1대1상담"></a>
                            </li>
                            <li class="page-item">
                            	<a href="#"><img class="img-fluid" src="/images/winct/FAQ_10_1.png" alt="자주듣는질문"></a>
                            </li>
                       	</ul>                        
                    </div>
                </div>
            </div>
	    </div>
        
    </div>
    
</div>
<script>
window.addEventListener("DOMContentLoaded", function() {
    let s_wnn_yn = getCookie("s_wnn_yn"); //위너넷여부 
    if (s_wnn_yn != 'Y') {
        hosp_conact();
    }
});
// 위너넷만 메뉴가 생성됨   
function hosp_conact() {
    const hospcont = document.getElementById("hospcont"); 
    const wnnauth1 = document.getElementById("wnnauth1");
    const comcode  = document.getElementById("comcode");
    const ratecode = document.getElementById("ratecode");
    const samcode  = document.getElementById("samcode");
    if (samcode) {
    	samcode.style.display = "none";  // 샘버젼  
    }  
    if (comcode) {
    	comcode.style.display = "none";  // 공통코드 
    }    
    if (ratecode) {
    	ratecode.style.display = "none";  // 청구율 
    }  
    if (hospcont) {
    	hospcont.style.display = "none";  // 계약정보  
    }
    if (wnnauth1) {
    	wnnauth1.style.display = "none";  // 운영정보 
    }
}
</script>		
<!-- ============================================================== -->
<!-- sidebar end -->
<!-- ============================================================== -->
        