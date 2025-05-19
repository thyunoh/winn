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
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<link href="/css/winmc/bootstrap.css"   rel="stylesheet">
<link href="/css/winmc/style.css?v=123" rel="stylesheet">
<link href="/css/winmc/style_login.css?v=123" rel="stylesheet">
<!-- JavaScript -->
<script type="text/javascript" src="/js/winmc/message.js"></script>

<!-- Template Javascript -->
<!-- ============================================================== -->
<!-- sidebar start -->
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
                
                    <li class="nav-item menu-section" id="menu-a">
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
                            	<a href="#" onclick="fnasq_main();"><img class="img-fluid" src="/images/winct/1-1_10_1.png" alt="1대1상담"></a>
                            </li>
                            <li class="page-item">
                            	<a href="#" onclick="loadFaqData();"> <img class="img-fluid" src="/images/winct/FAQ_10_1.png" alt="자주듣는질문"></a>
                            </li>
                       	</ul>                        
                    </div>
                </div>
            </div>
	    </div>
        
    </div>
</div>
<!-- 질의응답스크립트 종료 -->
<!-- FAQ 모달 -->
<div class="modal fade" id="faqModal" tabindex="-1" aria-labelledby="faqModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false" >
  <div class="modal-dialog modal-lg modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="faqModalLabel">자주 묻는 질문 (FAQ)</h5>
        <button type="button" class="btn btn-outline-dark" data-dismiss="modal" onclick="faqMainClose()">
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
							<col style="width: 180px">
							<!-- 질문제목 너비 줄임 -->
							<col style="width: 180px">
							<!-- 질문내용 너비 줄임 -->
							<col style="width: 60px">
							<col style="width: 60px">
							<col style="width: 60px">
							<col style="width: 120px">
						</colgroup>

						<thead>
							<tr>
								<th>번호</th>
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
	<!--질문응답-->
	<div class="modal fade" id="asq_main" tabindex="-1" style= "margin-top:-25px"
		data-bs-backdrop="static" data-keyboard="false" aria-hidden="true">
		<div
			class="modal-dialog modal-dialog-centered modal-dialog-scrollable"
			style="position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); width: 47vw; max-width: 47vw; max-height: 50vh;">
			<div class="modal-content"
				style="height: 74%; display: flex; flex-direction: column;">
				<div class="modal-header  bg-light">
					<h6 class="modal-title">문의 등록</h6>
					<div class="form-row">
						<div class="col-sm-12 mb-2" style="text-align: right;">
							<button type="button" id="save_btn" type="submit" class="btn btn-outline-info" onClick="fnasq_SaveProc()">저장. <i class="far fa-edit"></i>
							</button>
							<button type="button" class="btn btn-outline-dark"
								data-dismiss="modal" onClick="asqModalClose()">닫기 <i class="fas fa-times"></i>
							</button>
						</div>
					</div>
				</div>
				<form:form commandName="DTO" id="asq_regForm" name="asq_regForm"
					method="post" enctype="multipart/form-data">
					<div class="modal-body text-left flex-fill overflow-auto">
						<!-- Spring Form 태그 사용 (Spring MVC 환경이라면 적용 가능) -->
						<input  type="hidden" name="iud"     id="iud" />
						<input	type="hidden" name="asqSeq"  id="asqSeq" /> 
						<input  type="hidden" name="fileGb"  id="fileGb" value="4" /> 
						<input  type="hidden" name="hospCd"  id="hospCd" /> 
						<input  type="hidden" name="regUser" id="regUser" /> 
						<input  type="hidden" name="updUser" id="updUser" />
						<input  type="hidden" name="regIp"   id="regIp" /> 
						<input  type="hidden" name="updIp"   id="updIp" />
						<div class="form-group ">
							<label for="qstnTitle"
								class="col-2 col-lg-2 col-form-label text-left">질문제목</label>
							<div class="col-10 col-lg-10">
								<input id="qstnTitle" name="qstnTitle" type="text" required
									class="form-control" placeholder="">
							</div>
						</div>

						<div class="form-group">
							<label for="qstnConts"
								class="col-2 col-lg-2 col-form-label text-left">질문내용</label>
							<div class="col-10 col-lg-10">
								<textarea id="qstnConts" name="qstnConts" required
									placeholder="" class="form-control" rows="5"></textarea>
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
									<option value="N" selected>N. 진행중</option> <!-- 기본값 설정 -->
								</select>
							</div>
						</div>

						<div class="form-group">
							<label for="ansrConts"
								class="col-2 col-lg-2 col-form-label text-left">답변내용</label>
							<div class="col-10 col-lg-10">
								<textarea id="ansrConts" name="ansrConts"
									placeholder="" class="form-control" rows="8"></textarea>
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
function loadFaqData() {
    // 모달을 먼저 연다 (첫 번째 열 때 닫히는 문제 해결)
    $('#faqModal').modal('show');
   
    $("#faqList").html(`<p class="text-muted text-center"></p>`);

    $.ajax({
        url: "/mangr/faqCdList.do",
        type: "POST",
        data: {},
        dataType: "json",
        success: function (response) {
            let faqHtml = "";
            if (response.error_code === "0" && Array.isArray(response.data) && response.data.length > 0) {
            	$.each(response.data, function (index, faq) {
            	    let question = String(faq.qstnConts || "질문이 없습니다.").trim();
            	    let answer   = String(faq.ansrConts || "답변이 없습니다.").trim();

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
	    			dataTxt = '<tr  class="" onclick="fn_asqDtlSearch(\''+ data.resultLst[i].asqSeq +'\');" id="row_' 
	    			                                                                + data.resultLst[i].asqSeq+'">';
	 				dataTxt += 	"<td>" + (i+1)  + "</td>" ; 
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
				  $("#asqdataArea").append("<tr><td colspan='7'>검색된 정보가 없습니다.</td></tr>");
			  }
	      }
   });
}
/*질의응답모달*/
function asqModalOpen() {
	$("#hospCd").val(getCookie("hospid")  || '') ;
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
        $("#hospCd").val(getCookie("hospid"));
        document.getElementById("asq_regForm").reset();
        $("#ansrConts").prop("readonly", "true");
        $("#ansrWan").css("pointer-events", "none").css("background-color", "#e9ecef"); // 비활성화된 느낌의 배경색 적용
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
                   iud:       uidGubun   // 처리 구분 (삭제: "D")
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
$(document).ready(function () {
    // 메뉴 항목 클릭 시 .active 클래스 부여
    $('.nav-item.nav-link').on('click', function () {
        // 현재 사이드바 내 모든 항목에서 active 제거
        $('.nav-item.nav-link').removeClass('active');
        // 현재 클릭한 항목에 active 추가
        $(this).addClass('active');
    });
});
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
});

</script>		
<!-- ============================================================== -->
<!-- sidebar end -->
<!-- ============================================================== -->
        