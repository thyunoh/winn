<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>


<link href="/images/icons/winnernet.ico" rel="icon" type="image/x-icon" >
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />

<!-- 리치에디터 -->

<!--  
<link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.bundle.min.js"></script>
-->

<link   href="https://cdn.jsdelivr.net/npm/summernote@0.8.20/dist/summernote-lite.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/summernote@0.8.20/dist/summernote-lite.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/lang/summernote-ko-KR.min.js"></script>
<!-- 리치에디터 -->
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>

<!-- ============================================================== -->
<!-- sidebar start -->
<style>
.nav-left-sidebar {
    overflow-y: auto !important;
    overflow-x: hidden !important;
    height: calc(100vh - 60px) !important;
    background-color: white !important;
}
.nav-left-sidebar .fixed-sidebar-info-box {
    position: sticky;
    bottom: 0;
    background-color: white;
    z-index: 10;
}
/* 파일찾기 버튼 빨간색 제거 */
#asq_main .btn-outline-secondary,
#asq_main .btn-outline-secondary:hover,
#asq_main .btn-outline-secondary:focus,
#asq_main .btn-outline-secondary:active,
#asq_main .btn-outline-secondary:active:focus,
#asq_main .btn-outline-secondary.active {
    color: #000 !important;
    background-color: #fff !important;
    border-color: #bbb !important;
    outline: none !important;
    box-shadow: none !important;
}
#asq_main .btn:focus,
#asq_main .btn:active,
#asq_main .btn:active:focus {
    outline: none !important;
    box-shadow: none !important;
}
</style>
<div class="nav-left-sidebar">
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
                        <a class="nav-item nav-link" style="font-size: 15px;" href="/user/dashboard.do"><i class="fas fa-chart-bar"></i>DashBoard</a>                        
                    </li>
                    
                    <li class="nav-item menu-section" id="menu-b">
                        <a class="nav-item nav-link"  href="#" data-toggle="collapse" aria-expanded="false" data-target="#file-upload" aria-controls="file-upload">
                                                                                      <i class="fas fa-cloud-upload-alt"></i>자료올리기</a>
                        <div id="file-upload" class="collapse submenu" style="background-color: white;">
                            <ul class="nav flex-column">
                                <li class="nav-item">
                                    <a class="nav-item nav-link"  href="/main/magamFileUpload.do">청구.평가 업로드</a>
                                </li>
                                <li class="nav-item">
                              <a class="nav-item nav-link" href="#" data-toggle="collapse" aria-expanded="false" 
                                data-target="#lic_excel" aria-controls="lic_excel">기타.자료 업로드
                              </a>
                              <div id="lic_excel" class="collapse submenu" style="background-color: white;">
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
                    
                    <li class="nav-item menu-section" id="menu-c">
                        <a class="nav-item nav-link" style="font-size: 15px;" href="/main/total_Report.do" ><i class="fa fa-calculator"></i>진료비-분석 현황</a>
                    </li>
                
                    <li class="nav-item menu-section" id="menu-d">
                        <a class="nav-item nav-link" style="font-size: 15px;" href="/main/assessment.do" >
                        <i class="fa fa-list-ol" aria-hidden="true"></i>적정성-평가 현황</a>
                    </li>
                    
                            
                    <li class="nav-item" id="simulation">
                        <a class="nav-item nav-link" style="font-size: 15px;" href="/main/simulation.do" >
                        <i class="fa fa-cart-plus" aria-hidden="true"></i>적정성-Simulation</a>
                    </li>
                    
                    
                    <li class="nav-item menu-section" id="menu-e">
                        <a class="nav-item nav-link" style="font-size: 15px;" href="/main/assesCheck.do"><i class="fa fa-check-circle"></i>적정성-평가 점검</a>
                    </li>
                   
                    <li class="nav-item menu-section" id="menu-a">
                        <a class="nav-item nav-link"  href="#" data-toggle="collapse" aria-expanded="false" data-target="#user-info" aria-controls="user-info">
                                                                                      <i class="fa fa-building" aria-hidden="true"></i></i>요양기관등록</a>
                        <div id="user-info" class="collapse submenu" style="background-color: white;">
                            <ul class="nav flex-column">
                                <li class="nav-item" id="hospuser1">
                                    <a class="nav-item nav-link"  href="/user/license.do">라이센스면허등록</a>
                                </li>
                                <li class="nav-item" id="hospuser2">
                                    <a class="nav-item nav-link"  href="/user/licnumber.do">인력신고현황등록</a>
                                </li>
                                <li class="nav-item" id="hospuser3">
                                    <a class="nav-item nav-link"  href="/user/dietcd.do">가산식대등록</a>
                                </li>
                                
                                
                                <li class="nav-item">
                                    <a class="nav-item nav-link"  href="/user/pusercd.do">사용자등록</a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-item nav-link"  href="/user/userauthcd.do">사용자권한관리</a>
                                </li>
                                 
                                <li class="nav-item" id="hospuser4">
                                    <a class="nav-item nav-link"  href="/user/wardcd.do">병동현황등록</a>
                                </li>
                                <li class="nav-item"  id="hospuser5">
                                    <a class="nav-item nav-link"  href="/user/hospgrdcd.do">의사간호사등급현황</a>
                                </li>
                           </ul>
                        </div>
                    </li>
                    
                    <!-- 기준정보 -->
                    <li class="nav-item menu-section" id="menu-h">
                        <a class="nav-item nav-link"  href="#" data-toggle="collapse" aria-expanded="false" data-target="#base-info" aria-controls="base-info">
                                                                                                            <i class="fa fa-copyright" aria-hidden="true"></i>기준정보</a>
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
                                       <div id="hira-code" class="collapse submenu" style="background-color: white;">
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
                                            <li class="nav-item" id = "ratecode">
                                                <a class="nav-item nav-link"  href="/base/claimcd.do">유형별 청구율관리</a>
                                            </li>
                                        </ul>
                                    </div>
                                </li>
                                <li class="nav-item" id="samcode">
                                    <a class="nav-item nav-link"  href="#" data-toggle="collapse" aria-expanded="false" data-target="#base-info-2" 
                                                                             aria-controls="base-info-2">기준코드 관리</a>
                                    <div id="base-info-2" class="collapse submenu" style="background-color: white;">
                                        <ul class="nav flex-column">
                                            <li class="nav-item">
                                                <a class="nav-item nav-link"  href="/base/samvercd.do">샘파일 버전</a>
                                            </li>
                                            <li class="nav-item">
                                                <a class="nav-item nav-link"  href="/base/wvalcd.do">적정성지표</a>
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
                                                <a class="nav-item nav-link"  href="/user/wnnauthcd.do">위너넷권한관리</a>
                                            </li>
                                            <li class="nav-item">
                                                <a class="nav-item nav-link"  href="/user/mbrcd.do">회원가입현황</a>
                                            </li>
                                            <li class="nav-item">
                                                <a class="nav-item nav-link"  href="">수납관리</a>
                                            </li>
                                            <li class="nav-item">
                                                <a class="nav-item nav-link"  href="/chung/chgsimsa.do">청구심사조회</a>
                                            </li>
                                        </ul>
                                    </div>
                                </li>
                             </ul>
                        </div>
                    </li>
                     <li class="nav-item" id = "wnnauth1">
						<a class="nav-item nav-link" href="#" data-toggle="collapse" aria-expanded="false"
						   data-target="#base-info-4" aria-controls="base-info-4">
						   <i class="fas fa-comments"></i> 고객지원
						</a>
                        <div id="base-info-4" class="collapse submenu" style="background-color: white;">
                            <ul class="nav flex-column">
								<li class="nav-item">
								    <a class="nav-item nav-link" href="/mangr/noticd.do">공지사항</a>
								</li>
								<li class="nav-item">
								    <a class="nav-item nav-link" href="/mangr/noticd2.do">심 사 방</a>
								</li>
								<li class="nav-item">
								    <a class="nav-item nav-link" href="/mangr/noticd3.do">소 식 지</a>
								</li>                                                                
                                <li class="nav-item">
                                    <a class="nav-item nav-link"  href="/mangr/faqcd.do">자주하는 질문</a>
                                </li>
                                <!--  
                                <li class="nav-item">
                                    <a class="nav-item nav-link"  href="/mangr/asqcd.do">1:1 문의하기</a>
                                </li>
                                -->
								<li class="nav-item">
								    <a class="nav-item nav-link"  href="https://377.co.kr" target="_blank">원격지원상담 </a>
								</li>
                            </ul>
                        </div>
                    </li>
                    <li class="nav-item" id="adminAsqMenu" style="display:none;">
                        <a class="nav-item nav-link" style="font-size: 15px;" href="/mangr/asqcd.do"><i class="fas fa-headset"></i>관리자 1:1 문의하기</a>
                    </li>

                    <!-- 진료비 분석 보고서 -->
                    <li class="nav-item menu-section" id="menu-g">
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
                                                <a class="nav-item nav-link"  href="/tong/f_tong_03.do">항목별 건당진료비 구성</a>
                                            </li>
                                            <li class="nav-item">
                                                <a class="nav-item nav-link"  href="/tong/f_tong_09.do">정액환자 비청구분 항목비</a>
                                            </li>
                                      </ul>
                                    </div>
                                </li>
                            </ul>
                        </div>
                    </li>
                </ul>
            </div>            
        </nav>
        

    </div>
	<div class="fixed-sidebar-info-box">
	    <div class="col-xl-12">
	        <div class="card border-3 border-top border-top-primary">
	            <div class="card-body">
	                <img class="img-fluid" src="/images/winct/time_main.svg" alt="고객센터" style="height: 140px; margin-top: -10px; width: 120%;">
	                <div class="mt-3">
	                    <a href="#" onclick="fnasq_main();" class="btn btn-outline-primary btn-block d-flex align-items-center justify-content-between mb-2"
	                        style="border-radius: 8px; padding: 6px 16px; font-size: 12px; border-width: 2px; margin-right:35px;">
	                        <span><i class="fas fa-headphones" style="opacity: 0.6; margin-right: 10px;"></i> <b>1:1 문의하기</b></span>
	                        <i class="fas fa-chevron-right" style="opacity: 0.6;"></i>
	                    </a>
	                    <a href="#" onclick="loadFaqData();" class="btn btn-outline-primary btn-block d-flex align-items-center justify-content-between"
	                       style="border-radius: 8px; padding: 6px 16px; font-size: 12px; border-width: 2px; margin-right:35px;">
	                        <span><i class="fas fa-clipboard-list" style="opacity: 0.6; margin-right: 10px;"></i> <b>자주하는 질문</b></span>
	                        <i class="fas fa-chevron-right" style="opacity: 0.6;"></i>
	                    </a>
	                </div>
	            </div>
	        </div>
	    </div>
	</div>
</div>
<!-- 질의응답스크립트 종료 -->
<!-- FAQ 모달 -->

<div class="modal fade" id="faqModal" tabindex="-1" aria-labelledby="faqModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
  <div class="modal-dialog modal-lg" style="margin-top: 420px;"> <!-- 여기 추가 -->
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
<!-- 기존 1대1 질의응답  -->
<div class="modal fade" id="asq_main_tab" tabindex="-1"
   data-bs-backdrop="static" data-bs-keyboard="false" aria-hidden="true">
   <div class="modal-dialog modal-lg modal-dialog-centered" 
      style="max-width: 900px; width: 90%;">
      <!-- 모달 전체 높이를 100vh에서 auto로 변경하고 최대 높이를 제한 -->
      <div class="modal-content shadow-lg rounded-4"
         style="height: auto; max-height: 90vh; border: none;">
         <div class="modal-header bg-light"
            style="height: 35px; padding: 3px 8px;">
            <h5 class="modal-title">상담문의 목록</h5>
         </div>
         <!-- modal-body의 높이를 줄여서 최대 65vh 정도로 제한 -->
         <div class="modal-body bg-light"
            style="max-height: 60vh; overflow-y: auto;">
            <div class="d-flex align-items-center justify-content-between mb-3">
               <div class="d-flex" style="position: relative;">
                  <input type="text" id="searchText"
                     class="form-control rounded-3 border" placeholder="검색어를 입력하세요."
                     onkeypress="if(event.keyCode == 13){fnasq_Search();}"
                     style="width: 250px; font-size: 13px; height: 33px; padding-right: 35px;">
                  <i class="fas fa-search" onclick="fnasq_Search();" style="position: absolute; right: 10px; top: 50%; transform: translateY(-50%); cursor: pointer; color: #888; font-size: 14px;"></i>
               </div>
               <div>
                  <button class="btn btn-outline-info btn-sm" onclick="fn_asqsave('QD');" style="font-size: 13px; padding: 5px 11px;">
                     <img src="/images/winct/qnst_c.svg" alt="질문취소" style="width:16px; height:16px; vertical-align:middle; margin-right:4px;">질문취소</button>
                  <button class="btn btn-outline-info btn-sm" onclick="fn_asqsave('QI');" style="font-size: 13px; padding: 5px 11px;">
                     <img src="/images/winct/qnst_i.svg" alt="질문등록" style="width:16px; height:16px; vertical-align:middle; margin-right:4px;">질문등록</button>
                  <button class="btn btn-outline-info btn-sm" onclick="fn_asqsave('QU');" style="font-size: 13px; padding: 5px 11px;">
                     <img src="/images/winct/qnst_q.svg" alt="질문조회" style="width:16px; height:16px; vertical-align:middle; margin-right:4px;">답변조회(수정)</button>
               </div>
            </div>
            <div class="table-responsive rounded-3 shadow-sm mt-1 border"
               style="height:500px; overflow-y: auto;">
               <table id="asq_infoTable" class="table table-bordered">
                  <colgroup>
                     <col style="width: 30px">
                     <!-- NO -->
                     <col style="width: 60px">
                     <!-- 답변상태 -->
                     <col style="width: 120px">
                     <!-- 질문항목 -->
                     <col style="width: 160px">
                     <!-- 질문내용 -->
                     <col style="width: 80px">
                     <!-- 병원명 -->
                     <col style="width: 60px">
                     <!-- 질문자 -->
                     <col style="width: 110px">
                     <!-- 작성일 -->
                     <col style="width: 30px">
                     <!-- 첨부 -->
                  </colgroup>
                  <thead>
                    <tr style="background: #afd4ec; color: #000; font-weight: 600; font-size: 14px !important;">
                        <th>NO</th>
                        <th>답변상태</th>
                        <th title="질문항목">질문항목</th>
                        <th title="질문내용">질문내용</th>
                        <th>병원명</th>
                        <th>질문자</th>
                        <th>작성일</th>
                        <th>첨부</th>
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
         <div class="modal-footer" style="background-color: white; padding: 5px 10px; justify-content: center;">
            <button class="btn btn-outline-info" onclick="asqMainClose();">닫기 <i class="fas fa-times"></i></button>
         </div>
      </div>
   </div>
</div>
<!--질문응답-->
<div class="modal fade" id="asq_main" tabindex="-1"
   data-bs-backdrop="static" data-keyboard="false" aria-hidden="true">
   <div class="modal-dialog modal-dialog-scrollable modal-lg"
      style="max-width: 910px; width: 90%; margin-top: 30px;">
      <div class="modal-content"
         style="max-height: calc(100vh - 110px); display: flex; flex-direction: column; border: none; border-radius: 12px; overflow: hidden; box-shadow: 0 8px 32px rgba(0,0,0,0.18);">

         <!-- 타이틀 헤더 -->
         <div style="background: #fff; padding: 10px 24px 6px 24px; flex-shrink: 0; border-bottom: 1px solid #eee;">
            <h5 style="margin: 0; font-weight: 700; font-size: 16px; color: #222;">1:1 문의하기</h5>
         </div>

         <!-- 폼 바디 -->
         <form:form commandName="DTO" id="asq_regForm" name="asq_regForm"
            method="post" enctype="multipart/form-data" novalidate="novalidate"
            style="flex-grow: 1; display: flex; flex-direction: column; overflow: hidden; min-height: 0;">
            <div class="modal-body" style="overflow-y: auto; flex-grow: 1; min-height: 0; padding: 0 24px 15px 24px; background: #f9f9f9;">
               <input type="hidden" name="iud"      id="iud" />
               <input type="hidden" name="asqSeq"   id="asqSeq" />
               <input type="hidden" name="fileGb"   id="fileGb" value="4" />
               <input type="hidden" name="fileGb2"  id="fileGb2" value="4" />
               <input type="hidden" name="qstnWan"  id="qstnWan" value="Y" />
               <input type="hidden" name="hospCd2"  id="hospCd2" />
               <input type="hidden" name="regUser"  id="regUser" />
               <input type="hidden" name="updUser"  id="updUser" />
               <input type="hidden" name="regIp"    id="regIp" />
               <input type="hidden" name="updIp"    id="updIp" />

               <!-- 질문제목 섹션 -->
               <div style="margin-top: 15px;">
                  <div style="background: #afd4ec; color: #000; padding: 8px 16px; border-radius: 8px 8px 0 0; font-weight: 600; font-size: 13px;">
                     질문제목
                  </div>
                  <div style="background: #fff; border: 1px solid #d0d0d0; border-top: none; border-radius: 0 0 8px 8px; padding: 12px 14px;">
                     <textarea id="qstnTitle" name="qstnTitle" required
                        class="form-control" rows="2"
                        style="border: 1px solid #ddd; border-radius: 6px; font-size: 12px; resize: vertical;"></textarea>
                  </div>
               </div>

               <!-- 질문내용 섹션 -->
               <div style="margin-top: 12px;">
                  <div style="background: #afd4ec; color: #000; padding: 8px 16px; border-radius: 8px 8px 0 0; font-weight: 600; font-size: 13px;">
                     질문내용
                  </div>
                  <div style="background: #fff; border: 1px solid #e0e0e0; border-top: none; border-radius: 0 0 8px 8px; padding: 12px 14px;">
                     <textarea id="qstnConts" name="qstnConts" required
                        class="form-control" rows="4"
                        style="border: 1px solid #ddd; border-radius: 6px; font-size: 13px; font-weight: normal; resize: vertical;"></textarea>
                  </div>
               </div>

               <!-- 질문첨부파일 섹션 -->
               <div style="margin-top: 12px;">
                  <div style="background: #afd4ec; color: #000; padding: 8px 16px; border-radius: 8px 8px 0 0; font-weight: 600; font-size: 13px;">
                     질문첨부파일
                  </div>
                  <div id="asq-file-area" style="background: #fff; border: 1px solid #e0e0e0; border-top: 1px solid #ccc; padding: 10px 14px;">
                     <div style="display: flex; align-items: center;">
                        <button type="button" class="btn btn-outline-secondary btn-sm" style="border-radius: 4px; font-size: 13px; padding: 4px 14px; 
                             border-color: #bbb; color: #000; outline: none !important; box-shadow: none !important;" onclick="openAsqFileInput()">파일찾기</button>
                        <span id="asq-file-label" style="margin-left: 14px; color: #999; font-size: 13px;">선택된 파일 없음</span>
                        <input type="file" id="asq-file-input" multiple style="display:none;" onchange="asqHandleFiles(this.files)">
                     </div>
                     <div id="asq-drop-zone" style="border: none; padding: 0; min-height: 0;">
                        <div id="asq-file-list-new" class="file-list-container"></div>
                     </div>
                  </div>
                  <!-- 기존 업로드된 파일 목록 -->
                  <div style="background: #fff; border: 1px solid #e0e0e0; border-top: none; border-radius: 0 0 8px 8px; padding: 0;">
                     <table id="asq-file-table" class="table" style="width: 100%; font-size: 12px; display:none; margin-bottom: 0; border-collapse: collapse;">
                        <thead style="display: none;">
                           <tr>
                              <th>문서제목</th><th>사이즈</th><th>작성일</th><th></th><th></th>
                           </tr>
                        </thead>
                        <tbody id="asq-file-tbody"></tbody>
                     </table>
                  </div>
               </div>

               <!-- 답변내용 섹션 -->
               <div style="margin-top: 12px;">
                  <div style="background: #d4eaf7; color: #000; padding: 8px 16px; border-radius: 8px 8px 0 0; font-weight: 600; font-size: 13px;">
                     답변내용
                  </div>
                  <div style="background: #fff; border: 1px solid #e0e0e0; border-top: none; border-radius: 0 0 8px 8px; padding: 12px 14px;">
                     <div id="ansrContsView"
                        style="border: 1px solid #ddd; border-radius: 6px; font-size: 13px; font-weight: normal; min-height:200px; max-height: 400px; 
                                overflow-y: auto; padding: 8px 12px; background: #fff;"></div>
                     <input type="hidden" id="ansrConts" name="ansrConts" value="">
                  </div>
               </div>

               <!-- 답변완료 (숨김처리용) -->
               <div class="form-group" style="margin-top: 0; display: none;">
                  <select id="ansrWan" name="ansrWan" class="custom-select"
                     style="height: 35px; font-size: 14px; width: 120px;">
                     <option value="">선택</option>
                     <option value="Y">Y. 답변완료</option>
                     <option value="N">N. 진행중</option>
                  </select>
               </div>

               <!-- 답변자 첨부파일 섹션 (FILE_GB='5') -->
               <div id="ansr-file-area" style="margin-top: 12px; display:none;">
                  <div style="background: #d4eaf7; color: #000; padding: 8px 16px; border-radius: 8px 8px 0 0; font-weight: 600; font-size: 13px;">
                     답변첨부파일
                  </div>
                  <div style="background: #fff; border: 1px solid #e0e0e0; border-top: none; border-radius: 0 0 8px 8px; padding: 0;">
                     <table id="ansr-file-table" class="table" style="width: 100%; font-size: 12px; margin-bottom: 0; border-collapse: collapse;">
                        <thead style="display: none;">
                           <tr>
                              <th>문서제목</th><th>사이즈</th><th>작성일</th><th></th>
                           </tr>
                        </thead>
                        <tbody id="ansr-file-tbody"></tbody>
                     </table>
                  </div>
               </div>

            </div>

            <!-- 하단 버튼 영역 -->
            <div style="background: #fff; padding: 12px 24px; border-top: 1px solid #eee; text-align: center; flex-shrink: 0;">
               <button type="button" id="save_btn" class="btn"
                  style="background: #fff; border: 1px solid #ccc; border-radius: 6px; padding: 8px 30px; font-size: 14px; font-weight: 500; color: #333; margin-right: 8px;"
                  onClick="fnasq_SaveProc()">저장</button>
               <button type="button" class="btn"
                  style="background: #5bb8e8; border: none; border-radius: 6px; padding: 8px 30px; font-size: 14px; font-weight: 500; color: #fff;"
                  data-dismiss="modal" onClick="asqModalClose()">닫기</button>
            </div>
         </form:form>

      </div>
   </div>
</div>

<script>
function loadFaqData(keyword) {
    // 모달 열기
    $('#faqModal').modal('show');

    // FAQ 리스트 초기화
    $("#faqList").html(`<p class="text-muted text-center"></p>`);

    var searchKeyword = keyword || "";

    // AJAX로 FAQ 데이터 요청
    $.ajax({
        url: "/mangr/faqCdList.do",
        type: "POST",
        data: { qstnConts: searchKeyword, ansrConts: searchKeyword },
        dataType: "json",
        success: function (response) {
            if (response.error_code === "0" && Array.isArray(response.data) && response.data.length > 0) {
                $.each(response.data, function (index, faq) {
                    let question = String(faq.qstnConts || "질문이 없습니다.").trim();
                    let answer = String(faq.ansrConts || "답변이 없습니다.").trim();

                    // faq-item 전체 묶음 div
                    let faqItem = $("<div>", { class: "faq-item" });

                    // 질문 div
                    let faqQuestion = $("<div>", {
                        class: "faq-question"
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
/*질의응답메인*/
function asqMainClose() {
    $('#asq_main_tab').modal('hide');
}   

function fnasq_main() {
         
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
  
function fnasq_Search() {
   $("#asq_infoTable tr").attr("class", ""); 
    if (document.getElementById("asq_regForm")) {
        document.getElementById("asq_regForm").reset();
    }
    $("#asqSeq").val("") ;
    $("#asqdataArea").empty();
    $.ajax({
         url : '/mangr/asqList.do',
         type : 'post',
         data : {hospCd : getCookie("hospid")  , qstnTitle : $("#searchText").val() },
         dataType : "json",
         success : function(data) {
            if(data.error_code != "0") return;

            if(data.resultCnt > 0 ){
             var dataTxt = "";
             for(var i=0 ; i < data.resultCnt; i++){
	    	    dataTxt = '<tr onclick="fn_rowClick(\'' + data.resultLst[i].asqSeq + '\')" ' +
	    	          'ondblclick="fn_rowDblClick(\'' + data.resultLst[i].asqSeq + '\')" ' +
	    	          'id="row_' + data.resultLst[i].asqSeq + '">';
                dataTxt +=  "<td>" + (i+1)  + "</td>" ;
                var statTxt = data.resultLst[i].ansrStat;
                if(statTxt == '답변대기') statTxt = '답변대기';
                else if(statTxt == '답변완료') statTxt = '답변완료';
                dataTxt +=  "<td style='white-space:nowrap;'>" + statTxt    + "</td>" ;
                dataTxt +=  "<td class='txt-left ellips'>" + data.resultLst[i].qstnTitle    + "</td>" ;
                dataTxt +=  "<td class='txt-left ellips'>" + data.resultLst[i].qstnConts    + "</td>" ;
                dataTxt +=  "<td>" + data.resultLst[i].hospNm   + "</td>" ;
                dataTxt +=  "<td>" + data.resultLst[i].userNm   + "</td>" ;
                dataTxt +=  "<td>" + data.resultLst[i].updDttm  + "</td>" ;
                dataTxt +=  "<td>" + (data.resultLst[i].fileYn === 'Y' ? '<img src="/images/winct/filedown.svg" alt="파일 있음" title="파일 있음" style="width:15px; height:15px; vertical-align:middle;">' : '') + "</td>" ;
                dataTxt +=  "</tr>";
                  $("#asqdataArea").append(dataTxt);
               }
            }else{
              $("#asqdataArea").append("<tr><td colspan='8'>검색된 정보가 없습니다.</td></tr>");
           }
         }
   });
}
/*질의응답모달*/
function asqModalOpen() {
   $("#hospCd2").val(getCookie("hospid")  || '') ;
   $("#updUser").val(getCookie("userid") || '') ;
   $("#regUser").val(getCookie("userid") || '') ;
   $("#updIp").val(getCookie("s_connip") || '') ;
   $("#regIp").val(getCookie("s_connip") || '') ;
   $("#iud").val(uidGubun);
    $('#asq_main').modal('show');
} 
function asqModalClose() {
    $('#asq_main').modal('hide');
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
function fn_asqDtlSearch(asqSeq) { 
   if (!asqSeq) return;

   $("#asqSeq").val(asqSeq);

   // row 클릭 시 바탕색 변경 처리
   $("#asq_infoTable tr").removeClass("tr-primary"); // 모든 행 클래스 초기화
   $("#row_" + asqSeq).addClass("tr-primary");       // 선택된 행에 강조 클래스 추가
}
function fn_asqsave(iud) {
    $("#iud").val(iud); // 입력(I), 수정(U), 삭제(D)
    var asqSeq = $("#asqSeq").val();

    if (iud.substring(1, 2) === "U" || iud.substring(1, 2) === "D") {
        if (!asqSeq) {
          messageBox("1", "<h6>해당자료를 선택하세요.!!</h6><p></p>", "", "", "");
          return; 
        }
    }
    uidGubun = iud;
    $("#ansrWan").closest(".form-wrap").hide(); // 답변완료 숨기기
    if (iud.substring(1, 2) == "I") {
        document.getElementById("asq_regForm").reset();
        $("#iud").val(iud);
        $("#hospCd2").val(getCookie("hospid"));
        $("#regUser").val(getCookie("userid"));
        $("#updUser").val(getCookie("userid"));
        $("#ansrConts").val("");
        $("#ansrContsView").html("");
        $("#ansrWan").css("pointer-events", "none").css("background-color", "#e9ecef"); // 비활성화된 느낌의 배경색 적용
        $("#save_btn").show(); // 답변내용 보이기
        asqFileClear();
        $("#asq-file-table").show();
        $("#asq-file-tbody").html("<tr><td colspan='5' style='text-align:center; color:#999;'>등록된 파일이 없습니다.</td></tr>");
        $("#ansr-file-area").show();
        $("#ansr-file-tbody").html("<tr><td colspan='4' style='text-align:center; color:#999;'>등록된 파일이 없습니다.</td></tr>");
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
                $("#qstnTitle").val(data.result.qstnTitle);
                $("#qstnConts").val(data.result.qstnConts);
                $("#qstnWan").val(data.result.qstnWan);
                $("#ansrWan").val(data.result.ansrWan); // 답변완료 여부 값 설정
                $("#ansrConts").val(data.result.ansrConts);
                var ansrHtml = (data.result.ansrConts || '').replace(/\n/g, '<br>');
                $("#ansrContsView").html(ansrHtml);
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
                   fileGb:    lfileGb,   // 파일구분
                   iud:       uidGubun,  // 처리 구분 (삭제: "D")
                   updUser:   getCookie("userid") || '',
                   updIp:     ''
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
                // 파일 업로드 처리
                console.log('=== 파일업로드 디버깅 ===');
                console.log('uidGubun:', uidGubun);
                console.log('data.asqSeq:', data.asqSeq);
                console.log('data.hospCd:', data.hospCd);
                console.log('data.regUser:', data.regUser);
                console.log('data.error_code:', data.error_code, typeof data.error_code);
                var asqFileInput = document.getElementById('asq-file-input');
                console.log('asqFileInput:', asqFileInput);
                console.log('files:', asqFileInput ? asqFileInput.files : 'null');
                console.log('files.length:', asqFileInput && asqFileInput.files ? asqFileInput.files.length : 0);
                if (asqFileInput && asqFileInput.files && asqFileInput.files.length > 0) {
                    var seqVal = '';
                    if (uidGubun === 'QI') {
                        seqVal = data.asqSeq || '';
                    } else if (uidGubun === 'QU') {
                        seqVal = data.asqSeq || $("#asqSeq").val();
                    }
                    console.log('seqVal:', seqVal);
                    if (seqVal) {
                        uploadAsqFiles(seqVal, data.hospCd || getCookie("hospid"), data.regUser || getCookie("userid"), function() {
                            $('#asq_main').modal('hide');
                            fnasq_Search();
                        });
                        return; // 파일 업로드 콜백에서 처리
                    }
                }
                $('#asq_main').modal('hide'); // 파일 없으면 바로 닫기
                fnasq_Search();
            },
            error: function (xhr, status, error) {
                console.log("에러 발생:", error);
                alert("작업 중 오류가 발생했습니다.");
            }
        });
    }

}
$(document).ready(function () {
    // 메뉴 항목 클릭 시 .active 클래스 부여
    $('.nav-item.nav-link').on('click', function () {
        // 현재 사이드바 내 모든 항목에서 active 제거
        $('.nav-item.nav-link').removeClass('active');
        // 현재 클릭한 항목에 active 추가
        $(this).addClass('active');
    });

    // ESC 키로 모달 닫기
    $(document).on('keydown', function(e) {
        if (e.keyCode === 27) {
            if ($('#asq_main').hasClass('show')) {
                asqModalClose();
            } else if ($('#asq_main_tab').hasClass('show')) {
                asqMainClose();
            }
        }
    });
});
   //위너넷만 메뉴가 생성됨   
function hosp_conact() {
    const hospcont  = document.getElementById("hospcont"); 
    const wnnauth1  = document.getElementById("wnnauth1");
    const comcode   = document.getElementById("comcode");
    const ratecode    = document.getElementById("ratecode");
    const samcode     = document.getElementById("samcode");
    const hospuser1   = document.getElementById("hospuser1");
    const hospuser2   = document.getElementById("hospuser2");
    const hospuser3   = document.getElementById("hospuser3");
    const hospuser4   = document.getElementById("hospuser4");
    const hospuser5   = document.getElementById("hospuser5");
    
  //  const simulation  = document.getElementById("simulation");
  
    const hideElementsById = (ids) => {
        ids.forEach(id => {
            const el = document.getElementById(id);
            if (el) el.style.display = "none";
        });
    };

    // 숨기고자 하는 ID 목록
    hideElementsById([
        "samcode",    // 샘버전
        "comcode",    // 공통코드
        "ratecode",   // 청구율
        "hospcont",   // 계약정보
        "wnnauth1",   // 운영정보
        "hospuser1",  // 병원사용
        "hospuser2",
        "hospuser3",
        "hospuser4",
        "hospuser5"
        
      //  ,"simulation"
    ]);
}
document.addEventListener('DOMContentLoaded', function () {
    const currentPath = window.location.pathname;    
    // 모든 nav-link 순회
    document.querySelectorAll('.nav-link').forEach(function (link) {
        const href = link.getAttribute('href');

        if (href && currentPath.includes(href)) {
            link.classList.add('active');

            // 현재 링크 기준으로 상위 submenu 모두 열기
            let parent = link.closest('.nav-item');
            while (parent) {
                const submenu = parent.querySelector('.submenu');
                if (submenu) {
                    submenu.classList.add('show');
                }

                const toggler = parent.querySelector('[data-toggle="collapse"]');
                if (toggler) {
                    toggler.setAttribute('aria-expanded', 'true');
                }

                // 다음 상위로 이동
                parent = parent.parentElement.closest('.nav-item');
            }
        }
    });
    let s_wnn_yn = getCookie("s_wnn_yn"); //위너넷여부
    if (s_wnn_yn != 'Y') {
    	hosp_conact();
    }
    // 관리자 1:1 문의하기 메뉴 표시
    var winner = getCookie("s_wnn_yn").trim();
    if (winner === 'Y') {
        var adminAsq = document.getElementById("adminAsqMenu");
        if (adminAsq) adminAsq.style.display = "";
    }
});

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
            '<button type="button" onclick="asqRemoveNewFile(' + i + ')" class="delete-btn" style="border:none; background:none; color:#333; cursor:pointer; font-size:12px;">삭제</button>' +
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

function uploadAsqFiles(asqSeq, hospCd, regUser, callback) {
    var files = document.getElementById('asq-file-input').files;
    if (!files || files.length === 0) {
        if (typeof callback === 'function') callback();
        return;
    }

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
        url: '/sftp/fileupload.do',
        type: 'POST',
        data: formData,
        processData: false,
        contentType: false,
        success: function(res) {
            console.log('파일 업로드 성공:', res);
            if (typeof callback === 'function') callback();
        },
        error: function(xhr) {
            console.log('파일 업로드 실패:', xhr.responseText);
            alert('파일 업로드 중 오류가 발생했습니다.');
            if (typeof callback === 'function') callback();
        }
    });
}

function showAsqFileList(asqSeq) {
    if (!asqSeq) { $("#asq-file-table").hide(); return; }

    $.ajax({
        url: '/mangr/fileCdList.do',
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
                        fileUrl = '/sftp/download.do?filePath=' + encodeURIComponent(data[i].filePath);
                    }
                    var row = '<tr style="border-bottom: 1px solid #eee;">';
                    row += '<td style="padding:6px 8px; text-align:left;"><a href="javascript:void(0);" onclick="window.open(\'' + fileUrl + '\');" style="color:#2874A6; text-decoration:underline; font-weight:500;">' + fileTitle + '</a></td>';
                    row += '<td style="text-align:center; padding:6px 8px; color:#555; white-space:nowrap; width:80px;">' + fileSize + ' KB</td>';
                    row += '<td style="text-align:center; padding:6px 8px; color:#555; white-space:nowrap; width:140px;">' + regDttm + '</td>';
                    row += '<td style="text-align:center; vertical-align:middle; padding:6px 4px; width:30px;">';
                    row += "<a href='javascript:void(0);' onclick=\"deleteAsqFile('" + data[i].filePath + "','" + asqSeq + "');\" title='삭제' style='color:black;'>";
                    row += "<i class='fa-solid fa-trash' style='font-size: 1.1em;'></i>";
                    row += '</a></td>';
                    row += '<td style="text-align:center; vertical-align:middle; padding:6px 4px; width:30px;">';
                    if (fileUrl !== '#') {
                        row += "<a href='javascript:void(0);' onclick=\"window.open('" + fileUrl + "');\" title='다운로드' style='color:#28a745;'>";
                        row += "<img src='/images/winct/filedown.svg' alt='다운로드' style='width:16px; height:16px; vertical-align:middle;'>";
                        row += '</a>';
                    }
                    row += '</td>';
                    row += '</tr>';
                    tbody.innerHTML += row;
                }
                $("#asq-file-table").show();
            } else {
                tbody.innerHTML = "<tr><td colspan='5' style='text-align:center; color:#999;'>등록된 파일이 없습니다.</td></tr>";
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
            var savedAnsrHtml = $("#ansrContsView").html();
            var savedWan   = $("#ansrWan").val();

            $.ajax({
                url: '/sftp/deleteFile.do',
                type: 'POST',
                data: {
                    hospCd: getCookie("hospid") || '',
                    filePath: filePath,
                    fileSeq: asqSeq,
                    fileGb: '4',
                    updUser: getCookie("userid") || '',
                    updIp: ''
                },
                success: function(res) {
                    console.log('파일 삭제 성공:', res);
                    $("#qstnTitle").val(savedTitle);
                    $("#qstnConts").val(savedConts);
                    $("#ansrConts").val(savedAnsr);
                    $("#ansrContsView").html(savedAnsrHtml);
                    $("#ansrWan").val(savedWan);
                    showAsqFileList(asqSeq);
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
        url: '/mangr/fileCdList.do',
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
                        fileUrl = '/sftp/download.do?filePath=' + encodeURIComponent(data[i].filePath);
                    }
                    var row = '<tr style="border-bottom: 1px solid #eee;">';
                    row += '<td style="padding:6px 8px; text-align:left;"><a href="javascript:void(0);" onclick="window.open(\'' + fileUrl + '\');" style="color:#2874A6; text-decoration:underline; font-weight:500;">' + fileTitle + '</a></td>';
                    row += '<td style="text-align:center; padding:6px 8px; color:#555; white-space:nowrap; width:80px;">' + fileSize + ' KB</td>';
                    row += '<td style="text-align:center; padding:6px 8px; color:#555; white-space:nowrap; width:140px;">' + regDttm + '</td>';
                    row += '<td style="text-align:center; vertical-align:middle; padding:6px 4px; width:30px;">';
                    if (fileUrl !== '#') {
                        row += "<a href='javascript:void(0);' onclick=\"window.open('" + fileUrl + "');\" title='다운로드' style='color:#28a745;'>";
                        row += "<img src='/images/winct/filedown.svg' alt='다운로드' style='width:16px; height:16px; vertical-align:middle;'>";
                        row += '</a>';
                    }
                    row += '</td>';
                    row += '</tr>';
                    tbody.innerHTML += row;
                }
                $("#ansr-file-area").show();
            } else {
                tbody.innerHTML = "<tr><td colspan='4' style='text-align:center; color:#999;'>등록된 파일이 없습니다.</td></tr>";
                $("#ansr-file-area").show();
            }
        }
    });
}

</script>
<!-- ============================================================== -->
<!-- sidebar end -->
<!-- ============================================================== -->
        
        
        