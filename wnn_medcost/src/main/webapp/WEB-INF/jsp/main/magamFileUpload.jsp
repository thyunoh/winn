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

    <div class="dashboard-wrapper">
        <div class="dashboard-ecommerce">
            <div class="container-fluid dashboard-content ">
                <div class="ecommerce-widget mb-2"> 
                	<div class="row ">
                		<!-- ============================================================== -->
                        <!-- 샘파일,평가표 tabs start -->
                        <!-- ============================================================== -->
                        <div class="col-xl-12 col-lg-12">
                        
                            <div class="card mb-3">
                                
	                            <div class="card-header d-flex align-items-center">
	                                <h3 class="card-header-title">년도</h3>
	                                <select id="year_Select" class="custom-select ml-left w-auto  ml-2 mr-4">
	                                </select>
	                                <h3 class="card-header-title ml-2">구분</h3>
	                                <select id="file_Select" class="custom-select ml-left w-auto  ml-2 mr-4">
	                                	<option selected value="1">파일선택</option>
				                        <option value="2">폴더선택</option>
	                                </select> 
	                                <select id="allowedFiles" class="custom-select ml-left w-auto ml-2 mr-4" style="display: none;">	                                	
	                                </select>
	                                <select id="specode" class="custom-select ml-left w-auto ml-2 mr-4"      style="display: none;">	                                	
	                                </select>
	                                <select id="claimType" class="custom-select ml-left w-auto ml-2 mr-4"    style="display: none;">	                                	
	                                </select>
	                                <select id="insurType" class="custom-select ml-left w-auto ml-2 mr-4"    style="display: none;">	                                	
	                                </select>
	                                <select id="treatType" class="custom-select ml-left w-auto ml-2 mr-4"    style="display: none;">
	                                </select>
	                                <!-- [신규 방식 토글] 체크 시 월 클릭 → 청구파일 선택 모달(신규), 체크 해제 시 기존 파일 다이얼로그.
	                                     ★다음주 오픈 전까지 숨기려면 이 span 에 style="display:none;" 추가(→ 무조건 기존 방식)★ -->
	                                <label id="samPickModeWrap" class="ml-3 mb-0" style="font-weight:600; color:#0c7cd5; cursor:pointer;">
	                                    <input type="checkbox" id="samPickMode"> <i class="fa fa-flask mr-1"></i>신규 샘파일 작성
	                                </label>

	                            </div>
	                        </div>
		                        
                            <div class="tab-regular mb-3">
							    <ul class="nav nav-tabs" id="mg_FlagTab" role="tablist">
							        <li class="nav-item">
							            <a class="nav-link active" id="c-tab" data-toggle="tab" href="#content" role="tab" aria-controls="content" aria-selected="true" data-type="8" >청구샘파일</a>
							        </li>
							        <li class="nav-item">
							            <a class="nav-link" id="p-tab" data-toggle="tab" href="#content" role="tab" aria-controls="content" aria-selected="false" data-type="9">환자평가표</a>
							        </li>
							        <li class="nav-item ml-auto">
							            <button type="button" class="btn btn-outline-primary btn-sm" id="btnDataVerifyTop" style="font-size:12px; font-weight:600; padding:4px 12px;">
							                <i class="fa fa-clipboard-check mr-1"></i>데이터검증(오류시)
							            </button>
							        </li>
							    </ul>
							    
							    <div class="tab-content" id="mg_FlagTabContent">
							        <div class="tab-pane fade show active" id="content" role="tabpanel">
							            <div class="row" id="months-container">
							                
							            </div>
							            
							        </div>
							    </div>
							</div>
                        </div>
                        <!-- ============================================================== -->
                        <!-- 샘파일,평가표 tabs end -->
                        <!-- ============================================================== -->
	                	
                	</div>
                    
                </div>
                <div class="row">
                     
                     <div class="col-xl-12 col-lg-12 col-md-12 col-sm-12 col-12">
                         <div class="card">
                             <strong class="card-header" style="color: #8b0000; font-weight: bold;">
                             	청구서 자료등록 시 청구번호가 일치하면 기존자료는 삭제되고, 현재 등록하신 자료로 신규생성 됩니다. ( 마감, 예상시간은 네트워크 또는 서버상태에 따라 차이가 날 수 있습니다. )    평가서 자료등록 시 모든자료는 신규생성 됩니다.<br>
                             	입원현황 업로드 시 입원환자의 주민번호 앞 6자리가 부재할 경우 부재할 경우‘진료비 분석 청구 누락 대상자’ 및 ‘적정성평가 대상자 확인’의 정확도가 낮아질 수 있습니다. 
                             </strong>
                             <div class="card-body">
                             	 <div class="form-row mb-2">
	                                <input type="file" id="folderInput" multiple style="display: none;">
	                                
                                     
                                    <div class="col-sm-6">                                    
                                         <div class="btn-group ml-auto">
                                         	<!-- 
                                            <button id= "selectFolderBtn" class="btn btn-outline-danger  mr-2">폴더선택.</button>
                                            <button class="btn btn-outline-danger  mr-2" data-toggle="tooltip" data-placement="top" title="체크된 자료 Delete" onClick="fn_checked_del()">선택삭제. <i class="far fa-calendar-check"></i></button>
                                            <button class="btn btn-outline-success mr-2" data-toggle="tooltip" data-placement="top" title="등록된 자료 Upload" onClick="fn_file_upload()">서버전송. <i class="fas fa-cloud-upload-alt"></i></button>
                                            -->
                                        </div>
                                    </div> 
                                    
                                                                       
                                 </div>
                                 
                                 <!--  
                                 <div class="loading" style="display:none;">진행중</div>
								 -->
								 <!-- SPECODE 필터 결과 모달 -->
								 <div class="modal fade" id="specodeFilterModal" tabindex="-1" role="dialog">
								     <div class="modal-dialog modal-xl" role="document">
								         <div class="modal-content">
								             <div class="modal-header bg-info text-white">
								                 <h5 class="modal-title">SPECODE 필터 결과</h5>
								                 <button type="button" class="close text-white" data-dismiss="modal"><span>&times;</span></button>
								             </div>
								             <div class="modal-body" style="max-height:500px; overflow-y:auto;">
								                 <div class="row mb-3">
								                     <div class="col-md-4"><strong>전체 라인: </strong><span id="spFilterTotal" class="badge badge-primary">0</span></div>
								                     <div class="col-md-4"><strong>통과 라인: </strong><span id="spFilterPass" class="badge badge-success">0</span></div>
								                     <div class="col-md-4"><strong>제외 라인: </strong><span id="spFilterBlock" class="badge badge-danger">0</span></div>
								                 </div>
								                 <ul class="nav nav-tabs" id="spFilterTab" role="tablist">
								                     <li class="nav-item"><a class="nav-link active" data-toggle="tab" href="#spBlockedTab">제외된 라인</a></li>
								                     <li class="nav-item"><a class="nav-link" data-toggle="tab" href="#spPassedTab">통과된 라인 (최대 100건)</a></li>
								                     <li class="nav-item"><a class="nav-link" data-toggle="tab" href="#spCodesTab">제외코드 목록</a></li>
								                 </ul>
								                 <div class="tab-content mt-2">
								                     <div class="tab-pane fade show active" id="spBlockedTab">
								                         <table class="table table-sm table-bordered table-striped" style="font-size:12px;">
								                             <thead class="thead-dark"><tr><th>파일명</th><th>라인번호</th><th>매칭코드</th><th>라인내용 (앞 120자)</th></tr></thead>
								                             <tbody id="spBlockedBody"></tbody>
								                         </table>
								                     </div>
								                     <div class="tab-pane fade" id="spPassedTab">
								                         <table class="table table-sm table-bordered table-striped" style="font-size:12px;">
								                             <thead class="thead-dark"><tr><th>파일명</th><th>라인번호</th><th>라인내용 (앞 120자)</th></tr></thead>
								                             <tbody id="spPassedBody"></tbody>
								                         </table>
								                     </div>
								                     <div class="tab-pane fade" id="spCodesTab">
								                         <div id="spCodesList" style="font-size:13px;"></div>
								                     </div>
								                 </div>
								             </div>
								             <div class="modal-footer">
								                 <button type="button" class="btn btn-secondary" data-dismiss="modal">닫기</button>
								             </div>
								         </div>
								     </div>
								 </div>
								 <!-- SPECODE 필터 결과 모달 End -->

								 <!-- 파일 검증 결과 모달 -->
								 <div class="modal fade" id="verifyModal" tabindex="-1" role="dialog" data-backdrop="static">
								     <div class="modal-dialog modal-xl" role="document">
								         <div class="modal-content" style="border:none; border-radius:12px; box-shadow:0 8px 32px rgba(0,0,0,.18);">
								             <div class="modal-header" style="background:linear-gradient(135deg,#1e3c72 0%,#2a5298 100%); color:#fff; border-radius:12px 12px 0 0; padding:18px 24px;">
								                 <h5 class="modal-title" style="font-weight:600; letter-spacing:.5px;"><i class="fa fa-clipboard-check mr-2"></i>파일 검증 결과</h5>
								                 <button type="button" class="close text-white" data-dismiss="modal" id="btnVerifyX" style="opacity:.9;text-shadow:none;"><span>&times;</span></button>
								             </div>
								             <div class="modal-body" style="max-height:65vh; overflow-y:auto; padding:20px 24px;">
								                 <!-- 요약 카드 -->
								                 <div class="row mb-3" id="verifySummaryRow"></div>
								                 <!-- 파일별 탭 -->
								                 <ul class="nav nav-pills mb-3" id="verifyFileTabs" role="tablist" style="gap:6px;"></ul>
								                 <div class="tab-content" id="verifyFileTabContent"></div>
								             </div>
								             <div class="modal-footer" style="border-top:1px solid #e9ecef; padding:14px 24px;">
								                 <button type="button" class="btn btn-outline-secondary" id="btnVerifyClose" style="min-width:100px;">
								                     <i class="fa fa-times mr-1"></i>취소
								                 </button>
								             </div>
								         </div>
								     </div>
								 </div>
								 <!-- 파일 검증 결과 모달 End -->

								 <!-- 엑셀 미리보기 모달 -->
								 <div class="modal fade" id="excelPreviewModal" tabindex="-1" role="dialog" data-backdrop="static">
								     <div class="modal-dialog modal-lg" role="document" style="max-width:1200px; width:1200px; margin:1.75rem auto;">
								         <div class="modal-content" style="border:none; border-radius:12px; box-shadow:0 8px 32px rgba(0,0,0,.18);">
								             <div class="modal-header" style="background:linear-gradient(135deg,#28a745 0%,#20c997 100%); color:#fff; border-radius:12px 12px 0 0; padding:14px 20px;">
								                 <h5 class="modal-title" style="font-weight:600; color:#fff !important;"><i class="fa fa-file-excel mr-2"></i>입원현황 엑셀 미리보기</h5>
								                 <button type="button" class="close text-white" id="btnExcelPreviewX" style="opacity:.9;text-shadow:none;"><span>&times;</span></button>
								             </div>
								             <div class="modal-body" style="max-height:70vh; overflow-y:auto; padding:14px 18px;">
								                 <div id="excelPreviewContent"></div>
								             </div>
								             <div class="modal-footer" style="border-top:1px solid #e9ecef; padding:10px 20px;">
								                 <button type="button" class="btn btn-outline-secondary" id="btnExcelPreviewCancel" style="min-width:100px;">
								                     <i class="fa fa-times mr-1"></i>취소
								                 </button>
								                 <button type="button" class="btn btn-success" id="btnExcelPreviewSave" style="min-width:100px;">
								                     <i class="fa fa-save mr-1"></i>등록
								                 </button>
								             </div>
								         </div>
								     </div>
								 </div>
								 <!-- 엑셀 미리보기 모달 End -->

								 <div id="progress-container">
								     <div id="progress-bar"></div>
								     <div id="progress-text">0%</div>
								 </div>
								 <div class="loading" style="display:none;">
								     <p>예상</br>시간</br><span id="estimatedTime">0</span>초</p>
								 </div>
								 
                                 <!-- ===== [추가] 청구파일 선택 모달 (폴더선택 webkitdirectory 트리 + 첫줄 파싱) ===== -->
                                 <style>
                                     /* 스크롤해도 헤더 고정 */
                                     #samPickModal .modal-body .samPickTable thead th {
                                         position: sticky; top: 0; z-index: 3;
                                         background: #e2e6ea; box-shadow: inset 0 -1px 0 #dee2e6;
                                     }
                                     /* 상태 컬럼 오른쪽 고정 — 가로 스크롤해도 항상 보이게 */
                                     #samPickModal .samPickTable td.spkStCell {
                                         position: sticky; right: 0; z-index: 2;
                                         background: #fff; box-shadow: inset 1px 0 0 #dee2e6;
                                         width: 96px; min-width: 96px;
                                     }
                                     #samPickModal .samPickTable tr.samPickRepRow td.spkStCell { background: #f4f8ff; }
                                     #samPickModal .samPickTable th.spkStHead {
                                         position: sticky; right: 0; top: 0; z-index: 5;
                                         box-shadow: inset 1px 0 0 #dee2e6, inset 0 -1px 0 #dee2e6;
                                     }
                                 </style>
                                 <input type="file" id="samPickInput" webkitdirectory directory multiple style="display:none;">
                                 <div class="modal fade" id="samPickModal" tabindex="-1" role="dialog" data-backdrop="static">
                                     <div class="modal-dialog modal-xl" role="document">
                                         <div class="modal-content" style="border:none; border-radius:12px;">
                                             <div class="modal-header" style="background:linear-gradient(135deg,#f0932b 0%,#eb4d4b 100%); color:#fff; border-radius:12px 12px 0 0;">
                                                 <h5 class="modal-title" style="font-weight:600;"><i class="fa fa-folder-open mr-2"></i>청구파일 선택</h5>
                                                 <button type="button" class="close text-white" data-dismiss="modal"><span>&times;</span></button>
                                             </div>
                                             <div class="modal-body" style="max-height:70vh; overflow:auto; padding:14px 18px;">
                                                 <div class="mb-2">
                                                     <button type="button" id="samPickBtn"  class="btn btn-sm btn-warning">폴더 선택</button>
                                                     <button type="button" id="samPickRefresh" class="btn btn-sm btn-outline-primary"><i class="fa fa-sync-alt mr-1"></i>새로고침</button>
                                                     <span id="samPickFolder" class="ml-2" style="font-weight:600; color:#8a5a00; font-size:15px;">폴더 미선택</span>
                                                     <span id="samPickInfo" class="ml-2 text-muted" style="font-size:14px;">폴더를 선택하거나 이 창으로 폴더를 끌어다 놓으세요.</span>
                                                 </div>
                                                 <div class="mb-2" style="font-size:13.5px;">
                                                     <label class="mr-1 mb-0"><input type="checkbox" id="samPickPeriodChk"> 기간</label>
                                                     <input type="date" id="samPickFrom" class="form-control form-control-sm d-inline-block" style="width:150px;" disabled>
                                                     <span class="mx-1">~</span>
                                                     <input type="date" id="samPickTo" class="form-control form-control-sm d-inline-block" style="width:150px;" disabled>
                                                 </div>
                                                 <table class="table table-sm table-bordered table-hover mb-0 samPickTable" style="font-size:13.5px; white-space:nowrap;">
                                                     <thead class="thead-light">
                                                         <tr>
                                                             <th style="width:30px;"></th>
                                                             <th>청구년월</th>
                                                             <th>보험구분</th>
                                                             <th>입/외</th>
                                                             <th>청구구분</th>
                                                             <th>서식버전</th>
                                                             <th>청구번호</th>
                                                             <th class="text-right">청구건수</th>
                                                             <th class="text-right">총진료비</th>
                                                             <th class="text-right">크기</th>
                                                             <th>파일명</th>
                                                             <th class="text-center spkStHead" style="width:96px;min-width:96px;">상태</th>
                                                         </tr>
                                                     </thead>
                                                     <tbody id="samPickTree"><tr><td colspan="12" class="text-center text-muted" style="padding:24px;">[폴더 선택] 을 누르거나 <b>이 창으로 폴더를 끌어다 놓으세요</b>.<br><span style="font-size:12px;">드래그&amp;드롭 시 브라우저 권한창·업로드확인창 없이 바로 읽습니다.</span></td></tr></tbody>
                                                 </table>
                                             </div>
                                             <div class="modal-footer" style="border-top:1px solid #e9ecef;">
                                                 <span id="samPickFootInfo" class="mr-auto" style="font-size:18px; font-weight:700; color:#343a40;"></span>
                                                 <button type="button" id="samPickApply" class="btn btn-warning">선택 적용</button>
                                                 <button type="button" class="btn btn-outline-secondary" data-dismiss="modal">닫기</button>
                                             </div>
                                         </div>
                                     </div>
                                 </div>
                                 <!-- ===== [추가] 청구파일 선택 모달 End ===== -->

                                 <div id="file_category" style="height: 500px;">
	                                 <!-- 
	                              	 display: 기본 DataTables 스타일을 적용합니다.
									 nowrap: 셀 내용이 한 줄로 표시되도록 하며, 필요한 경우 가로 스크롤을 생성합니다.
									 stripe: 짝수/홀수 행에 다른 배경색을 적용하여 가독성을 높입니다.
									 hover: 마우스를 올린 행의 배경색을 변경하여 강조합니다.
									 compact: 테이블의 패딩을 줄여 더 조밀한 레이아웃을 만듭니다.
									 cell-border: 셀 주위에 테두리를 추가합니다.
									 row-border: 행 사이에 테두리를 추가합니다.
									 order-column: 정렬된 열을 시각적으로 강조합니다.
									 responsive: 반응형 디자인을 적용하여 작은 화면에서도 잘 보이도록 합니다.
	                                 -->
									 <div style="width: 100%;">							    
									    <table id="tableName" class="display nowrap stripe hover cell-border  order-column responsive">
									        
									    </table>
									 </div>
                                 </div>
                             </div>
                         </div>
                     </div> 
     			</div>        			
	        </div>
		</div>  
	</div>  
	
    
<script type="text/javascript">
	var signUp = 'N'; // 파일등록 진행여부
	var gExcel = 'N';                  
	var gFiles = null;
	var g_Year = new Date().getFullYear();                       // 당해년도
	var gMonth = String(new Date().getMonth()).padStart(2, '0'); // 당월
	var jobMon = String(new Date().getMonth()).padStart(2, '0'); // 당월
	var g_Flag = '8';                      						 // 8.청구서 9.평가표	 
	var allowedFiles = [];
	var allowedPairs = [];
	var specode = [];
	// 안해도 상관없음, 단 getElementById를 변경하면 꼭해야됨
	// Form마다 수정해야 될 부분 시작
	var tableName = document.getElementById('tableName');
	tableName.style.display = 'none';		
	// Form마다 수정해야 될 부분 종료
	
	// Form마다 조회 조건 변경 시작
	var findTxtln  = 0;    // 조회조건시 글자수 제한 / 0이면 제한 없음
	var firstflag  = false; // 첫음부터 Find하시려면 false를 주면됨
	var findValues = [];
	// 조회조건이 있으면 설정하면됨 / 조건 없으면 막으면 됨
	// 글자수조건 있는건 1개만 설정가능 chk: true 아니면 모두 flase
	// 조회조건은 필요한 만큼 추가사용 하면됨.
	findValues.push({ id: "mg_year",  val: g_Year, chk: false });
	findValues.push({ id: "mgmonth",  val: gMonth, chk: false });
	findValues.push({ id: "mg_flag",  val: g_Flag, chk: false });
	//Form마다 조회 조건 변경 종료
	
	// 초기값 설정
	var mainFocus = 'year_Select'; // Main 화면 focus값 설정, Modal은 따로 Focus 맞춤
	
	<!-- ============================================================== -->
	<!-- Table Setting Start -->
	<!-- ============================================================== -->
	var gridColums = [];
	var btm_Scroll = true;   		// 하단 scroll여부 - scrollX
	var auto_Width = true;   		// 열 너비 자동 계산 - autoWidth
	var page_Hight = 400;    		// Page 길이보다 Data가 많으면 자동 scroll - scrollY
	var p_Collapse = true;  		// Page 길이까지 auto size - scrollCollapse
	
	var datWaiting = true;   		// Data 가져오는 동안 대기상태 Waiting 표시 여부
	var page_Navig = false;   		// 페이지 네비게이션 표시여부 
	var hd_Sorting = true;   		// Head 정렬(asc,desc) 표시여부
	var info_Count = false;   		// 총건수 대비 현재 건수 보기 표시여부 
	var searchShow = false;   		// 검색창 Show/Hide 표시여부
	var showButton = true;   		// Button (복사, 엑셀, 출력)) 표시여부
	
	var copyBtn_nm = '복사.';
	var copy_Title = 'Copy Title';		
	var excelBtnnm = '엑셀.';
	var excelTitle = 'Excel Title';
	var excelFName = "파일명_";		// Excel Download시 파일명
	var printBtnnm = '출력.';
	var printTitle = 'Print Title';
    
	var find_Enter = false;  		// 검색창 바로바로 찾기(false) / Enter후 찾기(true)
	var row_Select = true;   		// Page내 Data 선택시 선택 row 색상 표시
	
	var colPadding = '3px'   		// 행 높이 간격 설정
	var data_Count = [5, 10, 15, 20, 30];  // Data 보기 설정
	var defaultCnt = 15;                   // Data Default 갯수
	
	
	//  DataTable Columns 정의, c_Head_Set, columnsSet갯수는 항상 같아야함.
	var c_Head_Set = [ '번호','버전','구분','형태','타병원','진료년월', '건수','총진료비','청구금액','작업-KEY','작업일시','작업자','파일명','작업년','작업월','마감','락' ];

	var columnsSet = [ 
		
					 	{ data: 'claim_no',      visible: true,  className: 'dt-body-center',  width: '100px' },
					    { data: 'clform_ver',    visible: true,  className: 'dt-body-center',  width: '50px'  },
					    { data: 'claim_type_nm', visible: true, className: 'dt-body-center',   width: '80px' },
					    { data: 'treat_type_nm', visible: true,  className: 'dt-body-center',  width: '250px',
					      render: function(data, type, row) {
					          if (type === 'display' && row && row.mg_flag === 'Z' && row.claim_no === '0000000001') {
					              return '특정수가 등록자료';
					          }
					          return data;
					      }
					    },
        				{ 
        				    data: 'js008Yn', 
        				    visible: true, 
        				    className: 'dt-body-center', 
        				    width: '60px',
        				    render: function(data, type, row) {
        				        if (type === 'display') {
        				            if (data === 'Y') {
        				                return '<span style="font-weight:bold;">타병원</span>';
        				            }
        				            if (data === 'CN') {
        				                return '<span style="font-weight:bold;">청구없음</span>';
        				            }
        				            if (data === 'N') {
        				                return '<span style="font-weight:bold;">-</span>';
        				            }
        				        }
        				        return data;
        				    }
        				},
					    { data: 'date_ym',       visible: true,  className: 'dt-body-center',  width: '100px',
						    render: function(data, type, row) {
		            			if (type === 'display') {
		            				return data != null ? getFormat(data,'d6') : '';
		                		}
		                		return data;
	      			       },
					    },
					    { data: 'case_cnt',   visible: true,  className: 'dt-body-right',   width: '100px',
							render: function(data, type, row) {
		            			if (type === 'display') {
		            				return data != null ? getFormat(data,'n1') + ' 건 ' : '';
		                		}
		                		return data;
          			       },
					    },
						{ data: 'tot_amt',   visible: true,  className: 'dt-body-right',   width: '100px',
							render: function(data, type, row) {
		            			if (type === 'display') {
		            				return data != null ? getFormat(data,'n1') + ' 원 ' : '';
		                		}
		                		return data;
	          			     },
						},
						{ data: 'claim_amt', visible: true,  className: 'dt-body-right',   width: '100px',
						    render: function(data, type, row) {
		            			if (type === 'display') {
		            				return data != null ? getFormat(data,'n1') + ' 원 ' : '';
		                		}
		                		return data;
	          			    },
						},
						{ data: 'jobs_dt',  visible: true,  className: 'dt-body-center',  width: '100px' },
	        			{ data: 'upd_dttm', visible: true,  className: 'dt-body-center',  width: '100px' },
	        			{ data: 'user_nm',  visible: true,  className: 'dt-body-center',  width: '100px' },        			   
	        			{ data: 'file_nm',  visible: true,  className: 'dt-body-center',  width: '150px' },
	        			
	        			{ data: 'mg_year',  visible: false, className: 'dt-body-center',  width: '100px' },
	        			{ data: 'mgmonth',  visible: false, className: 'dt-body-center',  width: '100px' },
	        			{ data: 'mg_flag',  visible: false, className: 'dt-body-center',  width: '100px' },
	        			{ data: 'lock_yn',  visible: false, className: 'dt-body-center',  width: '100px' }
        			   
					 ];
	
	var s_CheckBox = false;   		           	 // CheckBox 표시 여부
    var s_AutoNums = true;   		             // 자동순번 표시 여부
    
	// 초기 data Sort,  없으면 []
	var muiltSorts = [
						['claim_no', 'asc' ]    // 오름차순 정렬
    				 ];
    // Sort여부 표시를 일부만 할 때 개별 id, ** 전체 적용은 '_all'하면 됩니다. ** 전체 적용 안함은 []        				 
	var showSortNo = ['_all'];                   
	// Columns 숨김 columnsSet -> visible로 대체함 hideColums 보다 먼제 처리됨 ( visible를 선언하지 않으면 hideColums컬럼 적용됨 )	
	var hideColums = [];             // 없으면 []; 일부 컬럼 숨길때		
	var txt_Markln = 50;                       				 // 컬럼의 글자수가 설정값보다 크면, 다음은 ...로 표시함
	// 글자수 제한표시를 일부만 할 때 개별 id, ** 전체 적용은 '_all'하면 됩니다. ** 전체 적용 안함은 []
	var markColums = [];
	var mousePoint = 'pointer';                				 // row 선택시 Mouse모양
	<!-- ============================================================== -->
	<!-- Table Setting End -->
	<!-- ============================================================== -->

	<!-- ============================================================== -->
	<!-- 공통코드 Setting Start -->
	<!-- ============================================================== -->
	var list_flag = ['Z'];     			  // 대표코드, ['Z','X','Y'] 여러개 줄 수 있음
	//  list_code, select_id, firstnull는 갯수가 같아야함. firstnull의 마지막이 'N'이면 생략가능, 하지만 쌍으로 맞추는게 좋음 
	var list_code = ['ALLOWED','SPECODE'];          // 구분코드 필요한 만큼 선언해서 사용
	var select_id = ['allowedFiles','specode'];     // 구분코드 데이터 담길 Select (ComboBox ID) 
	var firstnull = ['N','N'];                // Y 첫번째 Null,이후 Data 담김 / N 바로 Data 담김  
	<!-- ============================================================== -->
	<!-- 공통코드 Setting End -->
	<!-- ============================================================== -->
	
	
$(document).ready(function() {
	
	//현재 연도를 기준으로 첫 번째 옵션과 나머지 9개의 연도를 동적으로 생성
	function populateYearSelect() {
	    const year_Select = document.getElementById('year_Select');
	    const currentYear = new Date().getFullYear();

	    // 기존 옵션 제거
	    year_Select.innerHTML = '';
	    
	    // 당해년도 포함 10년 Setting
	    for (let i = 0; i <= 9; i++) {
	        const option = document.createElement('option');
	        option.value = currentYear - i;
	        option.textContent = currentYear - i;
	        year_Select.appendChild(option);
	    }
	}	
	populateYearSelect();
	
    loadMonthsData();

    $('#year_Select').on('change', function() {
    	g_Year = $(this).val();
        let activeTab = $('#mg_FlagTab a.active');
        g_Flag = activeTab.data('type');
        findField('mg_year', g_Year)
        findField('mg_flag', g_Flag)
        loadMonthsData();
    });

    $('#mg_FlagTab a').on('click', function (e) {
        e.preventDefault();
        $(this).tab('show');
        g_Flag = $(this).data('type');
        g_Year = $('#year_Select').val();
        findField('mg_year', g_Year)
        findField('mg_flag', g_Flag)
        loadMonthsData();
    });
    
    
    document.addEventListener('click', function(e) {
	    
    	if (e.target && e.target.getAttribute('data-action') === 'fileLoad') {
    		fileLoad_Open(e.target.getAttribute('data-mgmonth'));
    	}
    	if(e.target && e.target.getAttribute('data-action') === 'fileView') {
	  	  	fileView_Open(e.target.getAttribute('data-mgmonth'));
		  	}
    	if(e.target && e.target.getAttribute('data-action') === 'fileViewNone') {
		  	  	fileViewNone_Open(e.target.getAttribute('data-mgmonth'));
	  	}
    	if (e.target && e.target.getAttribute('data-action') === 'excelLoad') {
    		excelLoad_Open(e.target.getAttribute('data-mgmonth'));
    	}
    	if (e.target && e.target.getAttribute('data-action') === 'spcsugaLoad') {
    		spcsugaLoad_Open(e.target.getAttribute('data-mgmonth'));
    	}
    	if (e.target && e.target.getAttribute('data-action') === 'magamLock') {
    		magamLock_Open(e.target.getAttribute('data-mgmonth'));
    	}
    	if (e.target && e.target.getAttribute('data-action') === 'dataVerify') {
    		fn_DataVerify(e.target.getAttribute('data-mgmonth'));
    	}
    	
    	
   	});

    // 상단 데이터검증 버튼
    $('#btnDataVerifyTop').on('click', function() {
        if (!gMonth) {
            messageBox("4", "<h5>월을 먼저 선택해 주세요.</h5>", "", "", "");
            return;
        }
        fn_DataVerify(gMonth);
    });

    find_Check();
    
    comm_Check();
    
    console.log("준비완료");

});
</script> 

<!-- ============================================================== -->
<!-- DataTable 설정 Start -->
<!-- ============================================================== -->
<script type="text/javascript">
	function fn_FirstGridSet() {
		(function($) {
			 dataTable = $('#' + tableName.id).DataTable({	
					language : {
						search: "자 료 검 색 : ",
					    emptyTable: "데이터가 없습니다.",
					    lengthMenu: "_MENU_",
					    info: "현재 _START_ - _END_ / 총 _TOTAL_건",
					    infoEmpty: "데이터 없음",
					    infoFiltered: "( _MAX_건의 데이터에서 필터링됨 )",
					    loadingRecords: "대기중...",
					    processing: "잠시만 기다려 주세요...",
					    paginate: {"next": "다음", "previous": "이전"},
					},
					scrollX:        btm_Scroll,
					autoWidth:      auto_Width,				
				    scrollY:        page_Hight, 
				    scrollCollapse: p_Collapse,
				    select:         row_Select,					    
				    processing:     datWaiting,
				    paging:         page_Navig,
				    ordering:       hd_Sorting,					    
				    info:           info_Count,					    
	    			searching:      searchShow,
	    			search: {
	    	            return:     find_Enter,          	            
	    	        },		    	        
				    rowCallback: function(row, data, index) {
			            $(row).find('td').css('padding',colPadding); 
			        },				        
			        lengthMenu: [data_Count, data_Count],
			        pageLength: defaultCnt, 
			        
			        dom: showButton ? '<"row"<"col-sm-2"l><"col-sm-7"><"col-sm-3"f>>Bt<"row mt-2"<"col-sm-7"i><"col-sm-5"p>>' : 
			        	              '<"row"<"col-sm-2"l><"col-sm-7"><"col-sm-3"f>>t<"row mt-2"<"col-sm-7"i><"col-sm-5"p>>', // 조건에 따라 dom 설정
			             buttons: showButton
			             ? [
			            	{
			        		    extend: 'copy',
			        		    text:  copyBtn_nm,
			        		    title: copy_Title
			        		},
			        		{
			        			extend: 'excelHtml5',
			        		    text: excelBtnnm,
			        		    filename: function() {
			        		        var d = new Date();
			        		        var formattedDate = d.getFullYear() + 
			        		                            ('0' + (d.getMonth())).slice(-2) + 
			        		                            ('0' + d.getDate()).slice(-2) + '_' +
			        		                            ('0' + d.getHours()).slice(-2) + 
			        		                            ('0' + d.getMinutes()).slice(-2) + 
			        		                            ('0' + d.getSeconds()).slice(-2);
			        		        return excelFName + formattedDate;
			        		    },
			        		    title: excelTitle
			        		},  
			        		{
			        			extend: 'print',
			        			text: printBtnnm,
			        		    autoPrint: true,
			        		    title: printTitle,
			        		    customize: function(win) {
			        		        $(win.document.body).find('h1').text(printTitle);
			        		        $(win.document.body).css('font-size', '10pt');
			        		        $(win.document.body).find('table')
			        		            .addClass('compact')
			        		            .css('font-size', 'inherit');
			        		    }
			        		}]
			             : []
			        ,
		    		columns: gridColums,	    		
			        order: muiltSorts,
				    columnDefs: [
				    	// 특정 열만 정렬
				    	{ 
				    		orderable: true,  
				    		targets: showSortNo 
				    	},					    	
				    	// 모든 나머지 열 정렬 불가능 설정
			            {
			                orderable: false,
			                targets: '_all'
			            },				            
			         	// column 숨김
			            { 
			            	visible: false, 
			            	targets: hideColums 
			            },
				        {
			            	targets: markColums,
				            render: function(data, type, row) {
				                return type === 'display' && data.length > txt_Markln ?
				                data.substr(0, txt_Markln) + '...' : data;
				            }
				        },				            
				        {
				            targets: ['_all'], 
				            createdCell: function (td, cellData, rowData, row, col) {
				                $(td).css('cursor', mousePoint);
				            }
				        }
				    ],
			        ajax: dataLoad,
				});
			 
			// 전체 선택 체크박스 기능
		    $('#selectAll').on('click', function() {
		        var rows = dataTable.rows({ 'search': 'applied' }).nodes();
		        $('input[type="checkbox"]', rows).prop('checked', this.checked);
		    });
	
			
		    // 개별 체크박스 변경 시 전체 선택 체크박스 상태 업데이트
		    $('#' + tableName.id + ' tbody').on('change', 'input[type="checkbox"]', function() {
		        var allChecked = ($('input[type="checkbox"]:checked', dataTable.rows().nodes()).length === dataTable.rows().count());
		        $('#selectAll').prop('checked', allChecked);
		    });
		    
		    
		    // 입력 버튼 클릭 이벤트
		    $('#' + tableName.id + ' tbody').on('click', '.ins-btn', function() {
		        // 여기에 입력 로직을 구현하세요
		        
		    });
		    // 수정 버튼 클릭 이벤트
		    $('#' + tableName.id + ' tbody').on('click', '.upt-btn', function() {
		        var data = dataTable.row($(this).parents('tr')).data();
		        // 여기에 수정 로직을 구현하세요
		    });
	
		    // 삭제 버튼 클릭 이벤트
		    $('#' + tableName.id + ' tbody').on('click', '.del-btn', function() {
		    	
		    	var data = dataTable.row($(this).parents('tr')).data();
		    	
		    	//교육담당자  mainfg = 3으로 등록되어 있어 삭제 권한 없음, 병원담당자 mainfg = 1 또는 2인 경우 삭제권한 있음. (병원직원, mainfg = 3 담당자로 등록된 경우 삭제 권한 없음)
		    	if (((data.lock_yn === 'N' && ['1', '2'].includes(mainfg)) || (winner === 'Y' && ['1', '2'].includes(mainfg)))) {
			    	// success:  성공 또는 완료를 나타내는 녹색 체크 마크 아이콘
					// error:    오류나 실패를 나타내는 빨간색 X 아이콘
					// warning:  주의나 경고를 나타내는 노란색 느낌표 아이콘
					// info:     정보를 나타내는 파란색 i 아이콘
					// question: 질문이나 확인을 나타내는 파란색 물음표 아이콘	
					Swal.fire({title: '삭제여부',
							   html:  '파일명칭 : <strong>' + data.treat_type_nm + ' - ' + data.case_cnt + '건</strong> 입니다.',
							   icon:  'question',
							   showCancelButton: true,
							   confirmButtonText: '삭제',
							   cancelButtonText: '취소',
							   customClass: {
								   popup: 'small-swal'}
					           }).then((result) => {
	
					    if (result.isConfirmed) {
						
				    		$.ajax({
				    		  url: "/main/deleteMagamClaimNo.do",
			   	              type: "POST",
			   	              data: { hosp_cd: hospid,
			   	            	      mg_year: data.mg_year,
			   	            	      mgmonth: data.mgmonth,
			   	            	      mg_flag: data.mg_flag,
						    	      claim_no: data.claim_no,
						    	      reg_user: userid
						      },
						      dataType: "json",
						      success: function(response) {
						    	 
						    	 dataTable.ajax.reload();
						    	 
						    	 Swal.fire({
							            title: '처리확인',
							            text:  '정상처리 되었습니다. ',
							            icon:  'success',
							            confirmButtonText: '확인',
							            timer: 1000,
							            timerProgressBar: true,
							            showConfirmButton: false
							     });
						    	 jobMon = gMonth; 
						    	 loadMonthsData();
						      },
						      error: function(xhr, status, error) {
						          console.error("Error fetching data:", error);
						      }
						      
							});
					  	}
			        });
		    	} else {
		    		if (!['1', '2'].includes(mainfg)) {
		    			Swal.fire({
				            title: '권한확인',
				            text:  '삭제권한이 없습니다. 삭제 불가',
				            icon:  'error',
				            confirmButtonText: '확인',
				            timer: 1000,
				            timerProgressBar: true,
				            showConfirmButton: false
				     	});
		    		} else {
		    			Swal.fire({
				            title: '마감확인',
				            text:  '마감자료입니다. 삭제 불가',
				            icon:  'error',
				            confirmButtonText: '확인',
				            timer: 1000,
				            timerProgressBar: true,
				            showConfirmButton: false
				     	});	
		    		}
		    		
		    	}
				
		    });
			
		    // 컬럼 Click과 CheckBox를 이벤트 동작이 동시에 일어나 분리함  
		    dataTable.on('click', 'td', function(e) {
		    	var column = $(this).index();        
		        var $row = $(this).closest('tr');
		        var $checkbox = $row.find('input[type="checkbox"]');
		        
		        // 체크박스가 아닌 다른 부분을 클릭했을 때 방지하기 위해 column순번 넣음
		        if ((!$(e.target).is(':checkbox')) & column === 0) {
		            e.preventDefault();         // 기본 동작 방지
		            $checkbox.trigger('click'); // 체크박스 클릭 이벤트 트리거
		        }
		    });
		    // 체크박스 클릭 이벤트
		    dataTable.on('change', 'input[type="checkbox"]', function(e) {
		        e.stopPropagation(); // 이벤트 전파 중지
		        var $row = $(this).closest('tr');
		    });
		    
		    /* row data선택 후 value set start */
		    dataTable.on('click', 'tbody tr', function() {
			    edit_Data = dataTable.row(this).data();
			});	    
		    /* 싱글 선택 start */
		    if (row_Select) {
			    dataTable.on('click', 'tbody tr', (e) => {
			  	    let classList = e.currentTarget.classList;
			  	 
			  	    if (!classList.contains('selected')) {
			  	    	dataTable.rows('.selected').nodes().each((row) => row.classList.remove('selected'));
			  	        classList.add('selected');
			  	    } 
			  	});    
		    }
		    
		})(jQuery);
		
	}	   
	
	//ajax 함수 정의
	var dataLoadSeq = 0;
	function dataLoad(data, callback, settings) {
		var __mySeq = ++dataLoadSeq;   // [중복로드 방지] 매 로드마다 시퀀스 부여

		//var table = $(settings.nTable).DataTable();
	    //table.processing(true); // 처리 중 상태 시작

	    let find = {};
	   	for (let findValue of findValues) {
	   		find[findValue.id] = findValue.val;
	   	}

	    $.ajax({
	        type: "POST",
	        url: "/main/magamGetFileList.do",
	        data: find,
	        dataType: "json",

	        // timeout: 10000, // 10초 후 타임아웃
	        beforeSend : function () {

			},
	        success: function(response) {
	        	//table.processing(false); // 처리 중 상태 종료
	            // [중복로드 방지] 이 응답보다 더 최신 로드가 시작됐으면 무시 (초기 자동로드 + reload 겹침으로 2번 들어가던 현상 방지)
            if (__mySeq !== dataLoadSeq) { return; }

            if (response && Object.keys(response).length > 0) {

	            	callback(response);
	            } else {
	            	callback([]); // 빈 배열을 콜백으로 전달
	            }
	        },
	        error: function(jqXHR, textStatus, errorThrown) {
	        	//table.processing(false); // 처리 중 상태 종료
	            callback({
	                data: []
	            });
	            //table.clear().draw(); // 테이블 초기화 및 다시 그리기
	        }
	    });
	}
	
	
	// DataTable에 자료 담기 Start	   
	function fn_FindData() {
		
		// 조회조건이 있을 경우	
		if (findValues && findValues.length > 0) {
			
			// 조회조건시 문자 길이가 있을 경우
			if (findTxtln > 0) {
					
				const foundItem = findValues.find(item => item.chk === true);
	
				if (foundItem !== undefined) {
					
					const index = findValues.findIndex(item => item.id === foundItem.id);
					
				    let { kCount, eCount, nCount, tCount } = getLengthCounts(findValues[index].val);
					
				    if (tCount >= findTxtln) {
		                fn_FindDataTable(); 	
					} else {
						messageBox("4","조회시 " + findTxtln + "글자 이상 " + getCodeMessage("A001"),findValues[index].id,"","");
					}
				    
				} else {
				    
				    messageBox("4","글자수 " + findTxtln + "글자 이상 조건이 있지만 조회 객체에는 true설정 안됨 !!","","","");			    
				}
				
			} else {
				fn_FindDataTable();
			}
		} else {
			fn_FindDataTable();
		}
		
	}
	
	function fn_FindDataTable() {
		if (firstflag) {
			firstflag = false;
			tableName.style.display = 'inline-block';
			fn_FirstGridSet();	
		} else {
			dataTable.ajax.reload();
		}
		edit_Data = null;
		// 재조회시 전체 선택 체크박스 해제
		$("#selectAll").prop("checked", false);
	}
	
	function fn_re_load(){
		if (findValues && findValues.length > 0) {
			fn_FindData();
		} 
	}
//DataTable에 자료 담기 End
</script>
<!-- ============================================================== -->
<!-- DataTable 설정 End -->
<!-- ============================================================== -->

<!-- ============================================================== -->
<!-- 기타 정보 Start -->
<!-- ============================================================== -->
<script type="text/javascript">

	
	// key Setting
	function dataTableKeys(dataTable, selectedRows) {
		// 데이터 객체 초기화
		let  keysID = []; 
		if (selectedRows.count() > 0) {
		    // 선택된 행의 데이터 가져오기
		    selectedRows.every(function(rowIdx, tableLoop, rowLoop) {
		        var rowData = this.data(); // 현재 행의 데이터 가져오기
		        let  key_ID = {};
		        // rowData가 배열이 아니라 객체 형태일 경우
		        if (rowData && typeof rowData === "object") {
		        	// primaryKey로 설정된 컬럼 찾기
			        dataTable.settings()[0].aoColumns.forEach(function(column, index) {
			            if (column.primaryKey) {
			            	// primaryKey로 name으로 id 설정
			            	key_ID[column.name] = rowData[column.data]; 
			            }	
			        });
	
			        // 객체를 배열에 추가
			        keysID.push(key_ID);
		        } 
		    });
		}
		return keysID;
	}
	// 첫조회 확인
	function find_Check() {
		if (!firstflag){
			
			if (findTxtln > 0) {
				
				const foundItem = findValues.find(item => item.chk === true);
	
				if (foundItem !== undefined) {
					
					const index = findValues.findIndex(item => item.id === foundItem.id);
					
				    let { kCount, eCount, nCount, tCount } = getLengthCounts(findValues[index].val);
					
				    if (tCount >= findTxtln) {
				    	tableName.style.display = 'inline-block';
						fn_FirstGridSet();	
					} else {
						firstflag = true;
						messageBox("4","조회시 " + findTxtln + "글자 이상 " + getCodeMessage("A001"),findValues[index].id,"","");
					}
				    
				} else {
					firstflag = true;
				    messageBox("4","글자수 " + findTxtln + "글자 이상 조건이 있지만 조회 객체에는 true설정 안됨 !!",mainFocus,"","");			    
				}
				
			} else {
				tableName.style.display = 'inline-block';
				fn_FirstGridSet();
			}
	    }	
		$("#" + mainFocus).focus();
	}
	// 공통담기
	function comm_Check() {	
		if (list_code.length > 0) {
			$.ajax({
			    type: "POST",
			    url: "/base/commList.do",    
			    data: {
			        listGb: list_flag,
			        listCd: list_code
			    },
			    dataType: "json",
			 	
			    beforeSend : function () {
			    	
				},
			    success: function(response) {
			   	
			    	
			        let commList = response.data || [];
			    	
			        for (var i = 0; i < select_id.length; i++) {
			            
			        	let select = $('#' + select_id[i]);
			            select.empty();
			            
			            
			            let filteredItems = commList.filter(item => item.codeCd === list_code[i]);
			            
			            if (filteredItems.length > 0) {
			            	if (firstnull[i] === "Y")
			            		select.append('<option value=""></option>');
			            		
			            	filteredItems.forEach(function (item) {
			            		
			                    select.append('<option value=' + item.subCode + '>' + item.subCodeNm + '</option>');
			                    
			                    if (list_code[i] === "ALLOWED") {
			                    	allowedFiles.push(item.subCode); 
			                    	allowedPairs.push(item.subCodeNm);	
			                    } else {
			                    	specode.push(item.subCode);	
			                    }
			                    
			                });
			            } else {
			                select.append('<option value="">No options</option>');
			            }
			        }
			    },
			    error: function(jqXHR, textStatus, errorThrown) {
			    	console.error("Status:   " + jqXHR.status);
			        console.error("Response: " + jqXHR.responseText);
			    }
			});
		}
	}
	

	//mask 설정
	$(function(e) {
	    "use strict";
	    $(".date1-inputmask").inputmask("9999-99-99"),
	    $(".phone-inputmask").inputmask("(999)-9999-9999"),
	    $(".email-inputmask").inputmask({
	        mask: "*{1,20}[.*{1,20}][.*{1,20}][.*{1,20}]@*{1,20}[*{2,6}][*{1,2}].*{1,}[.*{2,6}][.*{1,2}]",
	        greedy: !1,
	        onBeforePaste: function(n, a) {
	            return (e = e.toLowerCase()).replace("mailto:", "")
	        },
	        definitions: {
	            "*": {
	                validator: "[0-9A-Za-z!#$%&'*+/=?^_`{|}~/-]",
	                cardinality: 1,
	                casing: "lower"
	            }
	        }
	    })
	});
	
	// modal EnterKey 
	document.addEventListener('DOMContentLoaded', () => {
		inputEnterFocus(inputZone.id);
	});


	// Table Heads 정리하기
    if (c_Head_Set.length > 0) {
      	
      	const thead = document.createElement('thead');
   	    thead.id = 'tableHead';

   	    const tr = document.createElement('tr');

   	    // 체크박스 열 추가
   	    if (s_CheckBox) {
   	        const th = document.createElement('th');
   	        th.innerHTML = '<input type="checkbox" id="selectAll">';
   	        tr.appendChild(th);
   	    }

   	    // 자동 번호 열 추가
   	    if (s_AutoNums) {
   	        const th = document.createElement('th');
   	        th.textContent = 'No';
   	        tr.appendChild(th);
   	    }

   	    // 헤더 배열을 순회하며 <th> 추가
   	    c_Head_Set.forEach(header => {
   	        const th = document.createElement('th');
   	        th.textContent = header;       // 텍스트만 추가	   	    
	   	    if (header.class) {
	   	        th.classList.add(header.class);
	   	    }
	   	    th.classList.add('dt-center');
   	        tr.appendChild(th);
   	    });

        thead.appendChild(tr);
      	    
   	    // 기존 thead가 있으면 대체하고 없으면 새로 추가
   	    const existingThead = tableName.querySelector('thead');
   	    if (existingThead) {
   	    	tableName.removeChild(existingThead);
   	    }
   	    tableName.insertBefore(thead, tableName.firstChild);
    }
	// Table Columns 정리하기
    if (columnsSet.length > 0) {
      	gridColums = [];
      	let setnum = 0;
      	if (s_CheckBox) {
  			gridColums.push({ data: null, orderable: false, searchable: false, className: 'select-checkbox dt-body-center',
              	render: function (data, type, full, meta) {
                  	return '<input type="checkbox" name="id[]" value="' + $('<div/>').text(data.id).html() + '">';
              	}
          	});
  			setnum++;
     	}
      	if (s_AutoNums) {
      		gridColums.push({ data: null, orderable: false, searchable: false, className: 'dt-body-center',
                  render: function (data, type, row, meta) {
                      return meta.row + 1; // 자동순번: 현재 행 번호
                  }
             });
      		setnum++;
        }
     	
      	let mark_Colnm = []; 
      	let show_Sorts = [];
      	let hide_Colnm = [];
      	let muilt_Sort = [];
      	for (let i = 0; i < columnsSet.length; i++) {
      		gridColums.push(columnsSet[i]);
      		for (let a = 0; a < markColums.length; a++) {
      			if (markColums[a] === columnsSet[i].data) {
      				mark_Colnm.push(setnum+i);
      			}
      		}
      		for (let b = 0; b < showSortNo.length; b++) {
      			if (showSortNo[b] === columnsSet[i].data) {
      				show_Sorts.push(setnum+i);
      			}
      		}
      		for (let c = 0; c < hideColums.length; c++) {
      			if (hideColums[c] === columnsSet[i].data) {
      				hide_Colnm.push(setnum+i);
      			}
      		}
      		for (let d = 0; d < muiltSorts.length; d++) {
      			if (muiltSorts[d][0] === columnsSet[i].data) {
      				muilt_Sort.push(setnum+i); 
      				muilt_Sort.push(muiltSorts[d][1]);
      			}
      		}
      	}
     	// Button 생성
     	/* btn-outline-danger */
        gridColums.push({ data: null, orderable: false, searchable: false, className: 'dt-center',
            render: function(data, type, row) { 
                return  '<button class="btn btn-outline-danger btn-xs del-btn">삭제..<i class="far fa-trash-alt"></i></button>';
            }
        });
     	
      	
      	if (mark_Colnm.length > 0) { markColums = mark_Colnm; }
      	if (show_Sorts.length > 0) { showSortNo = show_Sorts; }
      	if (hide_Colnm.length > 0) { hideColums = hide_Colnm; }
      	if (muilt_Sort.length > 0) {        		
      		muiltSorts = [];
	       	for (let j = 0; j < muilt_Sort.length; j += 2) {
	       		muiltSorts.push([muilt_Sort[j],muilt_Sort[j + 1]]);
	       	}
      	}
    }
	// 조회 조건 담기
	function findField(key, dat) {
		
		const index = findValues.findIndex(item => item.id === key);
	
		if (index !== -1) {
		    findValues[index].val = dat;
		} else {
		    findValues.push({ id: key, val: dat });
		}
	}
	// 조회 조건에서 input Field가 있으면 EnterKey 후 검색 (단, input Field에서 함수 호출 해야됨)
	function findEnterKey() {
	    if (event.key === 'Enter') {
	    	fn_FindData(); 
	    }
	}
</script>
<!-- ============================================================== -->
<!-- 기타 정보 End -->
<!-- ============================================================== -->

<!-- ============================================================== -->
<!-- 월별,  8.청구서 9.평가표 정보 Start -->
<!-- ============================================================== -->

  


<script type="text/javascript">

// ====================================================================
// 입원현황 업로드용 DB컬럼 정의 / 자동매핑 키워드 (sugacd.jsp 방식)
// ====================================================================
var ipwonDbColumns = [
	{ key: 'hosp_cd', label: '요양기호(검증)', required: false },
	{ key: 'chartno', label: '차트번호', required: false },
	{ key: 'patname', label: '수진자명', required: false },
	{ key: 'ipwondt', label: '입원일',   required: false },
	{ key: 'ipwontm', label: '입원시간', required: false },
	{ key: 'tewondt', label: '퇴원일',   required: false },
	{ key: 'tewontm', label: '퇴원시간', required: false },
	{ key: 'juminno', label: '주민번호', required: false },
	{ key: 'docname', label: '의사',     required: false },
	{ key: 'dept_nm', label: '진료과',   required: false },
	{ key: 'insurnm', label: '환자유형', required: false },
	{ key: 'word_nm', label: '병동',     required: false },
	{ key: 'room_nm', label: '병실',     required: false }
];
var ipwonAutoMap = {
	'hosp_cd': ['요양기관기호','요양기호','요양기관번호','요양기호번호'],
	'chartno': ['차트번호','챠트번호','환자ID','차트No','차트 No','Chart','Chart Number','차번','환자번호'],
	'patname': ['수진자명','환자명','환자이름','이름','성명','환자성명'],
	'ipwondt': ['입원일','입원일자','입원날짜','Admission','Admission Date','최초입원일','실입원일'],
	'ipwontm': ['입원시간','Admission Time'],
	'tewondt': ['퇴원일','퇴원일자','퇴원날짜','Discharge','Discharge Date','실퇴원일'],
	'tewontm': ['퇴원시간','Discharge Time'],
	'juminno': ['주민번호','주민등록번호'],
	'docname': ['의사','진료의','주치의','의사성명','의사명'],
	'dept_nm': ['진료과','진료과목','진료과명'],
	'insurnm': ['환자유형','보험유형','유형','보험','자격','보종'],
	'word_nm': ['병동'],
	'room_nm': ['병실']
};

// 전역 상태 (입원/수가 공용)
var excelRawHeaders = [];
var excelRawRows    = [];
var excelRawRowFile = [];   // 각 행이 어느 파일에서 나왔는지
var excelColumnMap  = {};   // dbKey -> excelHeader
var excelPreviewDT  = null;
var excelCurrentMode = '';  // 'ipwon' or 'spcsuga'

// 공용 헬퍼
function excelNormHeader(s) {
	return (s == null ? '' : String(s)).trim().toLowerCase().replace(/[\s_\-\/]/g, '');
}
function excelDateFmt(value) {
	if (!value && value !== 0) return '';
	if (value instanceof Date && !isNaN(value.getTime())) {
		var y = value.getFullYear();
		var m = String(value.getMonth() + 1).padStart(2, '0');
		var d = String(value.getDate()).padStart(2, '0');
		return y + '-' + m + '-' + d;
	}
	var s = String(value).trim();
	if (!s) return '';
	if (s.includes(' ')) s = s.split(' ')[0];
	// YYYY-MM-DD / YYYY/MM/DD / YYYY.MM.DD
	var m1 = s.match(/^(\d{4})[\-\/\.](\d{1,2})[\-\/\.](\d{1,2})$/);
	if (m1) return m1[1] + '-' + m1[2].padStart(2,'0') + '-' + m1[3].padStart(2,'0');
	// YYYYMMDD
	var m2 = s.match(/^(\d{4})(\d{2})(\d{2})$/);
	if (m2) return m2[1] + '-' + m2[2] + '-' + m2[3];
	// M/D/YY or M/D/YYYY
	if (s.includes('/')) {
		var p = s.split('/');
		if (p.length === 3) {
			var mm = p[0].trim().padStart(2,'0');
			var dd = p[1].trim().padStart(2,'0');
			var yy = p[2].trim();
			if (yy.length === 2) {
				yy = (parseInt(yy,10) < 50 ? '20' : '19') + yy;
			} else if (yy.length === 4) {
				// keep
			} else {
				yy = yy.padStart(4,'0');
			}
			return yy + '-' + mm + '-' + dd;
		}
	}
	return s;
}

async function handleFileSelection(event) {

	signUp = 'Y';

	if (gExcel === 'Y') {

		const files = event.target.files;
		const rawHeaders = [];
		const rawRows = [];
		const rawRowFile = [];

		for (let file of files) {
			const reader = new FileReader();
			await new Promise((resolve, reject) => {
				reader.onload = function (e) {
					const binaryStr = e.target.result;
					const wb = XLSX.read(binaryStr, { type: 'binary', codepage: 949, raw: true });
					wb.SheetNames.forEach(sheetName => {
						const ws = wb.Sheets[sheetName];
						const json_Data = XLSX.utils.sheet_to_json(ws, { defval: '', raw: false, cellDates: true });
						json_Data.forEach((row, idx) => {
							if (idx === 0 && rawHeaders.length === 0) {
								for (const k of Object.keys(row)) rawHeaders.push(String(k).trim());
							}
							// Date 객체는 ISO(YYYY-MM-DD)로 평탄화하여 저장 (그리드 표시용)
							const r = {};
							for (const k of Object.keys(row)) {
								const v = row[k];
								if (v instanceof Date && !isNaN(v.getTime())) {
									r[String(k).trim()] = excelDateFmt(v);
								} else {
									r[String(k).trim()] = (v == null ? '' : String(v));
								}
							}
							rawRows.push(r);
							rawRowFile.push(file.name);
						});
					});
					resolve();
				};
				reader.onerror = function (e) { reject(e); };
				reader.readAsBinaryString(file);
			});
		}

		// 파일 내 행이 없을 때 방어
		if (rawRows.length === 0) {
			signUp = 'N';
			messageBox("4", "<h5>엑셀 데이터가 비어있습니다.<br>업로드 안됨 !!</h5><p></p><br>", "", "", "");
			return;
		}

		excelRawHeaders = rawHeaders;
		excelRawRows    = rawRows;
		excelRawRowFile = rawRowFile;
		excelCurrentMode = 'ipwon';
		excelAutoMapColumns(ipwonAutoMap);

		// 미리보기 모달 표시
		showExcelPreview();

	} else {
		
		let lfiles = event.target.files;
		
		// *.확장자 형태만 추출
		const restrictedExtensions = allowedFiles
		  .filter(pattern => pattern.startsWith('*.'))
		  .map(pattern => pattern.slice(2).toLowerCase());

		// 확장자가 제한 목록에 있는지 검사
		let hasRestrictedExt = Array.from(lfiles).some(file => {
		  let ext = file.name.split('.').pop().toLowerCase();
		  return restrictedExtensions.includes(ext);
		});

		// 제한된 확장자가 있고, 파일이 2개 이상이면 경고
		if (hasRestrictedExt && lfiles.length > 1) {
			signUp = 'N';
			messageBox("4","<h5>산재,산재한방,자보한방등 <br>청구서와 명세서가 분리된 경우 이외에는 1건씩 파일을 등록하셔야 됩니다.<br>다중으로 선택된 데이터 파일은 업로드가 불가합니다.<br>각각 자료 업로드 진행 부탁드립니다</h5><p></p><br>","","","");
		    return; 
		}
			    
		let gFiles = Array.from(lfiles).filter(file => {
	        let fileName = file.name;
	        return file.size > 0 && allowedFiles.some(pattern => {
	            if (pattern.startsWith('*.')) {
	                return fileName.toLowerCase().endsWith(pattern.slice(2).toLowerCase());
	            } else if (pattern.endsWith('.*')) {
	                return fileName.toLowerCase().startsWith(pattern.slice(0, -2).toLowerCase());
	            } else {
	                return fileName === pattern;
	            }
	        });
	    });
	
	    let missingPairs = [];
	    let missingFiles = [];
	    let chungguFiles = [];
	    for (let i = 0; i < allowedFiles.length; i++) {
	        if (allowedPairs[i] !== '-') {
	            let fileExists   = false;
	            let existingFile = null;
	
	            for (let file of gFiles) {
	                let fileName = file.name;
	                let pattern  = allowedFiles[i];
	                
	                if (pattern.startsWith('*.')) {
	                    fileExists = fileName.toLowerCase().endsWith(pattern.slice(2).toLowerCase());
	                } else if (pattern.endsWith('.*')) {
	                    fileExists = fileName.toLowerCase().startsWith(pattern.slice(0, -2).toLowerCase());
	                } else {
	                    fileExists = fileName === pattern;
	                }
	                
	                if (fileExists) {
	                    existingFile = fileName;
	                    chungguFiles.push(existingFile);
	                    // break;
	                }
	            }
	
	            if (fileExists) {
	                let pairExists = gFiles.some(file => {
	                    let fileName = file.name;
	                    let pairPattern = allowedPairs[i];
	                    
	                    if (pairPattern.startsWith('*.')) {
	                        return fileName.toLowerCase().endsWith(pairPattern.slice(2).toLowerCase());
	                    } else if (pairPattern.endsWith('.*')) {
	                        return fileName.toLowerCase().startsWith(pairPattern.slice(0, -2).toLowerCase());
	                    } else {
	                        return fileName === pairPattern;
	                    }
	                });
	
	                if (!pairExists) {
	                    missingPairs.push(allowedPairs[i]);
	                    missingFiles.push(existingFile);
	                }
	            }
	        }
	    }
	    
	    if (missingFiles.length > 0) {
	    	signUp = 'N';
	    	messageBox("4","<h5>청구서 파일 누락 [ " + missingPairs[0] + " ],   청구서가 필요한 파일은 : " + missingFiles[0] + " 입니다. </h5><p></p><br>","","","");
	    } else {
	    	
	    	if (gFiles) {
	    		let jobs_dt = getJobDateTime();
	    	    
	    	    let errorCheck = false;
	
	    	    let num = 0;
	    	  
	    	    let readFilesPromises = gFiles.map(file => {
	    	        return new Promise((resolve) => {
	    	            let reader = new FileReader();
	    	            reader.readAsText(file, 'euc-kr');
	    	            reader.onload = function (e) {
	    	                let content = e.target.result;
	    	                let lines = content.split(/\r?\n/);   // CRLF 파일의 trailing \r 제거 — 고정폭 라인 +1byte(valsize 오류) 방지
	    	                let chunggu = '1';
	    	                
	    	                if (file.name != 'M010.1') { 
	    	                    chunggu = chungguFiles.includes(file.name) ? '2' : '1';
	    	                }
	    	                
	    	                
	    	                // SPECODE 필터 디버깅용 수집 배열
	    	                if (!window._spFilterBlocked) window._spFilterBlocked = [];
	    	                if (!window._spFilterPassed)  window._spFilterPassed  = [];

	    	                let data = lines
	    	                    .map((line, index) => ({
	    	                        hosp_cd: hospid,
	    	                        mg_year: g_Year,
	    	                        mgmonth: gMonth,
	    	                        mg_flag: g_Flag,
	    	                        jobs_dt: jobs_dt,
	    	                        chunggu: chunggu,
	    	                        file_nm: file.name,
	    	                        line_no: index + 1,
	    	                        lineval: line,
	    	                        reg_user: userid,
	    	                        upd_user: userid,
	    	                        reg_ip: '127.0.0.1',
	    	                        upd_ip: '127.0.0.1',
	    	                    }))
	    	                    .filter((item) => {
	    	                    	// return item.lineval && !specode.some(word => item.lineval.includes(word)); 안되게 로직이 되어있음 원래  20260312일  
	    	                        if (!item.lineval) return false;
	    	                        let matchedCode = specode.find(word => item.lineval.includes(word));
	    	                        if (matchedCode) {
	    	                            window._spFilterBlocked.push({
	    	                                file_nm: item.file_nm,
	    	                                line_no: item.line_no,
	    	                                matched: matchedCode,
	    	                                lineval: item.lineval.substring(0, 120)
	    	                            });
	    	                            return true;  /* true 포함   false 이면 제외  SELECT * FROM TBL_CODE_DTL WHERE  CODE_GB = 'Z' AND CODE_CD = 'SPECODE'   */     
	    	                        }
	    	                        window._spFilterPassed.push({
	    	                            file_nm: item.file_nm,
	    	                            line_no: item.line_no,
	    	                            lineval: item.lineval.substring(0, 120)
	    	                        });
	    	                        return true; // false; specode 미매칭 → 제외
	    	                    });



							resolve(data);	
	    	            };
	    	            reader.onerror = function (e) {
	    	                reject(e);
	    	            };
	    	        });
	    	    });
	
	    	    
	    	    Promise.all(readFilesPromises)
	   	        	.then(allData => {

		   	            // ===== SPECODE 필터 결과 모달 표시 =====
		   	            (function showSpecodeFilter() {
		   	                let blocked = window._spFilterBlocked || [];
		   	                let passed  = window._spFilterPassed  || [];
		   	                let total   = blocked.length + passed.length;

		   	                $('#spFilterTotal').text(total);
		   	                $('#spFilterPass').text(passed.length);
		   	                $('#spFilterBlock').text(blocked.length);

		   	                // 제외된 라인 테이블
		   	                let blockedHtml = '';
		   	                blocked.forEach(r => {
		   	                    blockedHtml += '<tr>'
		   	                        + '<td>' + r.file_nm + '</td>'
		   	                        + '<td>' + r.line_no + '</td>'
		   	                        + '<td><span class="badge badge-danger">' + r.matched + '</span></td>'
		   	                        + '<td style="word-break:break-all;">' + r.lineval.replace(/</g, '&lt;') + '</td>'
		   	                        + '</tr>';
		   	                });
		   	                if (blocked.length === 0) blockedHtml = '<tr><td colspan="4" class="text-center">제외된 라인 없음</td></tr>';
		   	                $('#spBlockedBody').html(blockedHtml);

		   	                // 통과된 라인 테이블 (최대 100건)
		   	                let passedHtml = '';
		   	                passed.slice(0, 100).forEach(r => {
		   	                    passedHtml += '<tr>'
		   	                        + '<td>' + r.file_nm + '</td>'
		   	                        + '<td>' + r.line_no + '</td>'
		   	                        + '<td style="word-break:break-all;">' + r.lineval.replace(/</g, '&lt;') + '</td>'
		   	                        + '</tr>';
		   	                });
		   	                if (passed.length === 0) passedHtml = '<tr><td colspan="3" class="text-center">통과된 라인 없음</td></tr>';
		   	                $('#spPassedBody').html(passedHtml);

		   	                // SPECODE 목록
		   	                let codesHtml = '<div class="mb-2"><strong>제외코드 목록 (' + specode.length + '건) - 이 코드가 포함된 라인은 업로드에서 제외됩니다:</strong></div>';
		   	                codesHtml += specode.map(c => '<span class="badge badge-warning mr-1 mb-1">' + c + '</span>').join('');
		   	                $('#spCodesList').html(codesHtml);

		   	            //   $('#specodeFilterModal').modal('show');

		   	                // 초기화
		   	                window._spFilterBlocked = [];
		   	                window._spFilterPassed  = [];
		   	            })();
		   	            // ===== SPECODE 필터 결과 모달 End =====

		   	            let allDataFlat = allData.flat();

		   	            let t_lines = allData.reduce((sum, file) => sum + file.length, 0);
		   	      		
		   	            if (t_lines > 0) {
			   	      		allDataFlat.forEach(file => { file.t_lines = t_lines; });
			   	            
			   	      		let estimatedTime;
			   	      		
					   	    if (String(g_Flag) === '8') {
					   	        estimatedTime = ((t_lines / 80) * 1);
					   	    } else {
					   	        estimatedTime = ((t_lines / 25) * 1);
					   	    }
			   	      		$("#estimatedTime").text(estimatedTime.toFixed(1));
				   	        $("#progress-container").show();
				   	     	let progressBar  = $("#progress-bar");
		                    let progressText = $("#progress-text");
		
		                    progressBar.css("width", "0%");
		                    progressText.text("0%");
			
				   	        let startTime = Date.now();
				   	        let updateInterval = 100;
				   	        let interval = setInterval(function () {
				   	            let elapsed = (Date.now() - startTime) / 1000;
				   	            let progress = Math.min((elapsed / estimatedTime) * 100, 100);
				   	            
				   	            progressBar.css("width", progress + "%");
				   	            progressText.text(Math.round(progress) + "%");
			
				   	            if (progress >= 100) {
				   	                clearInterval(interval);
				   	            }
				   	        }, updateInterval);
			   	            
			   	            // === 1단계: TBL_FILES_DATA INSERT만 수행 ===
			   	            $.ajax({
			   	                url: '/main/uploadMagamFiles.do',
			   	                type: 'POST',
			   	                contentType: 'application/json',
			   	                data: JSON.stringify(allDataFlat),
				   	            beforeSend: function() {
				                    $('.loading').show();
				                    $('#estimatedTime').text(estimatedTime.toFixed(1));
				                },
			   	                success: function (response) {
			   	                	signUp = 'N';
			   	                    if (response.error_code !== "0" & !errorCheck) {
			   	                        // 오류 발생 시 메시지 출력 및 모든 처리 종료
			   	                        messageBox("4", "<h5>전송파일 처리 중 오류가 발생했습니다. <br>" + response.error_mess + "</h5><p></p><br>", "", "", "");
			   	                        window._samUpOk = false; // 청구건 오류(원본 삭제 금지)
   	                        errorCheck = true; // 오류 플래그 설정
			   	                    } else {
			   	                    	clearInterval(interval);
			   	                        progressBar.css("width", "100%");
			   	                        progressText.text("100%");
			   	                      	$("#progress-container").fadeOut();
			   	                        
			   	                    	window._samUpOk = true; if(!window._samSilent){ messageBox("1", "<h5>모든 파일이 정상적으로 실행 되었습니다.</h5><p></p><br>", "", "", ""); } if(typeof window.samPickRemoveUploaded==='function') window.samPickRemoveUploaded();
			   	                        dataTable.ajax.reload();
			   	                        
			   	                        try {
			   	                        	jobMon = gMonth; 
			   	                            loadMonthsData();
			   	                            
			   	                        } catch (e) {
			   	                            console.error("loadMonthsData 실행 중 오류 발생:", e);
			   	                        }
			   	                    }
			   	                },
			   	                error: function (xhr, status, error) {
			   	                	signUp = 'N';
			   	                    window._samUpOk = false;   // 청구건 통신오류(원본 삭제 금지)
   	                    console.error('Error Status Code:', xhr.status);
			   	                    console.error('Response Text:', xhr.responseText);
			   	                    console.error('Error Status:', status);
			   	                    console.error('Error Message:', error);
			   	                    if (!errorCheck) {
			   	                        errorCheck = true;
			
			   	                        let errorMessage = 'Error occurred while processing files. ';
			   	                        if (xhr.responseText) {
			   	                            errorMessage += 'Server response: ' + xhr.responseText;
			   	                        }
			   	                        messageBox("4", "<h5>전송파일 처리 중 오류가 발생했습니다. <br>" + errorMessage + "<br>" + "Status Code: " + xhr.status + "</h5><p></p><br>", "", "", "");
			   	                    }
			   	                },
			   	             complete: function() {
			   	             	 signUp = 'N';
			                     $('.loading').fadeOut();
			                     clearInterval(interval);
		   	                     progressBar.css("width", "100%");
		   	                     progressText.text("100%");
		   	                  	 $("#progress-container").fadeOut();
			                 },
			             });
				     }
			     })
			     .catch(error => {
			    	 signUp = 'N';
			         console.error('File read error:', error);
			     })
	    	    
	    	} else {
	    		signUp = 'N';
	    	}	
	    } 
	}
}

function fileLoad_Open(mgmonth) {
	
	if (signUp === 'Y') {
		Swal.fire({
            title: '파일 등록 진행 중.',
            text:  '파일 등록 중입니다. 잠시 후 등록하세요.',
            icon:  'warning',
            confirmButtonText: '확인',
            timer: 500,
            timerProgressBar: true,
            showConfirmButton: false
     	});
	} else {
		
		try {
			gExcel = 'N';
	        if (typeof event !== 'undefined' && event) event.stopPropagation();   // 모달 [선택 적용]에서 호출 시 전역 event 없어도 안전

	        gMonth = mgmonth;
	        findField('mgmonth', gMonth);
	
	        let file_Select = document.getElementById("file_Select");
	        let folderInput = document.getElementById('folderInput'); // 이 부분을 추가
	
	        if (!folderInput) {
	            console.error("folderInput 요소를 찾을 수 없습니다.");
	            return;
	        }
	
	        if (file_Select.value === "2") {
	            folderInput.setAttribute("webkitdirectory", "");
	        } else {
	            folderInput.removeAttribute("webkitdirectory");
	        }
	        // accept 속성 설정
	        let acceptExtensions = allowedFiles.map(file => {
	            if (file.startsWith('*.')) {
	                return '.' + file.slice(2);
	            } else {
	                return '.' + file.split('.').pop();
	            }
	        }).join(',');
	
	        folderInput.setAttribute('accept', acceptExtensions);
	        
	        // [추가] 폴더선택 트리에서 체크한 청구파일이 있으면, 파일 다이얼로그를 열지 않고
	        //        그 파일들을 기존 처리(handleFileSelection)에 그대로 넘겨 실행 — 업로드/생성 로직 동일.
	        if (window.gPickedFiles && window.gPickedFiles.length > 0) {
	            try {
	                window._samUploadedFiles = window.gPickedFiles.slice();   // 업로드 성공 시 삭제/숨김 대상 스냅샷
	                var _dt = new DataTransfer();
	                window.gPickedFiles.forEach(function(f){ _dt.items.add(f); });
	                folderInput.removeAttribute("webkitdirectory");
	                folderInput.files = _dt.files;
	                handleFileSelection({ target: folderInput });
	                if (typeof window.samPickReset === 'function') window.samPickReset();
	                return;
	            } catch (e) { console.error('선택파일 업로드 오류:', e); }
	        }
	        // 월 카드 클릭: '신규 샘파일 작성' 체크 시 → 청구파일 선택 모달(그 월 기억 → [선택 적용] 시 업로드), 아니면 → 기존 파일 다이얼로그
	        var _sm = document.getElementById('samPickMode');
	        if (_sm && _sm.checked) {
	            window._samPickMonth = mgmonth;
	            try { $('#samPickModal').modal('show'); return; } catch(e2){}
	        }
	        folderInput.value    = '';
	        folderInput.onchange = handleFileSelection;
	        folderInput.click();

	    } catch (error) {
	        console.error("fileLoad_Open 함수 실행 중 오류 발생:", error);
	    }
	}
}

function excelLoad_Open(mgmonth) {
	
	try {
		gExcel = 'Y';
        event.stopPropagation();
        gMonth = mgmonth;
        findField('mgmonth', gMonth);

        let folderInput = document.getElementById('folderInput'); // 이 부분을 추가

        if (!folderInput) {
            console.error("folderInput 요소를 찾을 수 없습니다.");
            return;
        }

        folderInput.removeAttribute("webkitdirectory");
        
        const acceptExtensions = ".xlsx, .xls";
        folderInput.setAttribute("accept", acceptExtensions);
        
        folderInput.value    = '';
        folderInput.onchange = handleFileSelection;
        folderInput.click();
        
    } catch (error) {
        console.error("excelLoad_Open 함수 실행 중 오류 발생:", error);
    }
}

// ─── 특정수가현황 엑셀 업로드 진입 ───
function spcsugaLoad_Open(mgmonth) {
	try {
		gExcel = 'S';                 // S = 특정수가현황 엑셀 업로드 모드
		event.stopPropagation();
		gMonth = mgmonth;
		findField('mgmonth', gMonth);

		let folderInput = document.getElementById('folderInput');
		if (!folderInput) {
			console.error("folderInput 요소를 찾을 수 없습니다.");
			return;
		}

		folderInput.removeAttribute("webkitdirectory");
		folderInput.setAttribute("accept", ".xlsx, .xls");
		folderInput.value    = '';
		folderInput.onchange = handleSpcsugaFileSelection;
		folderInput.click();
	} catch (error) {
		console.error("spcsugaLoad_Open 함수 실행 중 오류 발생:", error);
	}
}

// ====================================================================
// 특정수가현황 업로드용 DB컬럼 정의 / 자동매핑 키워드
// ====================================================================
var spcsugaDbColumns_NEW = [
	{ key: 'hosp_cd',    label: '요양기호',      required: false },
	{ key: 'ipwondt',    label: '입원일',        required: false },
	{ key: 'chartno',    label: '차트번호',      required: false },
	{ key: 'patname',    label: '환자성명',      required: false },
	{ key: 'juminno',    label: '주민번호',      required: false },
	{ key: 'card_no',    label: '증번호',        required: false },
	{ key: 'insurnm',    label: '종별',          required: false },
	{ key: 'suga_cd',    label: '정의/수가코드', required: false },
	{ key: 'edi_code',   label: '청구/보험코드', required: false },
	{ key: 'kor_name',   label: '한글명칭',      required: false },
	{ key: 'med_start',  label: '내원일',        required: false },
	{ key: 'comp_code',  label: '제약회사',      required: false },
	{ key: 'income_gu',  label: '구입거래처',    required: false },
	{ key: 'burye_code', label: '분류번호',      required: false },
	{ key: 'yong_code',  label: '효능코드',      required: false },
	{ key: 'unit_price', label: '단가',          required: false },
	{ key: 'total_dose', label: '수량',          required: false },
	{ key: 'amount',     label: '금액',          required: false },
	{ key: 'tel_phone',  label: '전화번호',      required: false },
	{ key: 'hand_phone', label: '핸드폰번호',    required: false },
	{ key: 'tewondt',    label: '퇴원일',        required: false },
	{ key: 'dep_name',   label: '진료과',        required: false },
	{ key: 'ward_nm',    label: '병동',          required: false },
	{ key: 'room_nm',    label: '병실',          required: false },
	{ key: 'item_no',    label: '항',            required: false },
	{ key: 'code_no',    label: '목',            required: false },
	{ key: 'spc_name',   label: '특이사항',      required: false },
	{ key: 'sec_code',   label: '성분코드',      required: false },
	{ key: 'sec_name',   label: '성분명',        required: false },
	{ key: 'doc_code',   label: '주치의',        required: false }
];
var spcsugaAutoMap = {
	'hosp_cd':    ['요양기관기호','요양기호','요양기관번호','요양기호번호'],
	'chartno':    ['차트번호','환자ID','차트No','차트 No','Chart','Chart Number','차번','환자번호'],
	'patname':    ['환자성명','환자명','환자이름','이름','성명','수진자명'],
	'med_start':  ['내원일','진료일','진료일자','방문일','방문일자'],
	'juminno':    ['주민번호','주민등록번호'],
	'card_no':    ['증번호'],
	'insurnm':    ['종별','보험유형','환자유형','보종','보험'],
	'suga_cd':    ['정의코드','수가코드'],
	'edi_code':   ['청구코드','보험코드','EDI코드','edicode','ediCode'],
	'kor_name':   ['한글명칭','한글명','코드명','명칭'],
	'comp_code':  ['제약회사'],
	'income_gu':  ['구입거래처','구입처','거래처'],
	'burye_code': ['분류번호','분류기호'],
	'yong_code':  ['효능코드'],
	'unit_price': ['단가'],
	'total_dose': ['수량'],
	'amount':     ['금액'],
	'tel_phone':  ['전화번호'],
	'hand_phone': ['핸드폰번호','휴대폰','휴대폰번호','휴대전화'],
	'tewondt':    ['퇴원일','퇴원일자'],
	'dep_name':   ['진료과','진료과목','진료과명'],
	'ward_nm':    ['병동'],
	'room_nm':    ['병실'],
	'item_no':    ['항'],
	'code_no':    ['목'],
	'spc_name':   ['특이사항','특이사할'],
	'sec_code':   ['성분코드'],
	'sec_name':   ['성분명'],
	'ipwondt':    ['입원일','입원일자','최초입원일','실입원일'],
	'doc_code':   ['주치의','의사','주치의사']
};

// ─── 수가현황 전용 헬퍼들 (저장 시점에 사용) ───
// "01-08, 02-05" / "1/8 1/15" / "01.08" 등의 MM-DD 목록에서 각 값 추출
function spcsugaSplitVisits(v) {
	if (v == null) return [];
	var s = String(v).trim();
	if (!s) return [];
	// 쉼표/세미콜론/공백으로 분리 (단일/복수, YYYY-MM-DD / YYYYMMDD / MM-DD 모두 커버)
	return s.split(/[,;\s]+/).map(function(t) { return t.trim(); }).filter(Boolean);
}
// MM-DD(또는 MM/DD) + 기준년도 => YYYY-MM-DD
function spcsugaMakeFullDate(token, baseYear) {
	if (!token) return '';
	if (/^\d{4}[-/.]\d{1,2}[-/.]\d{1,2}$/.test(token)) return excelDateFmt(token);
	var m = token.match(/^(\d{1,2})[-/.](\d{1,2})$/);
	if (m) {
		return baseYear + '-' + m[1].padStart(2,'0') + '-' + m[2].padStart(2,'0');
	}
	return token;
}
// 저장용: '-', '/', '.' 제거하여 8자리 숫자(YYYYMMDD)로
function spcsugaStripDateSep(v) {
	if (v == null || v === '') return '';
	return String(v).replace(/[^0-9]/g, '');
}

// 특정수가현황 엑셀 처리 (원본만 파싱 → 매핑 UI에서 사용자 확정 후 저장 시 비즈니스 로직 적용)
async function handleSpcsugaFileSelection(event) {
	signUp = 'Y';

	// spcsugaDbColumns_NEW → 공용 변수로 복사 (excelGetDbColumns가 참조)
	spcsugaDbColumns = spcsugaDbColumns_NEW;

	const files = event.target.files;
	const rawHeaders = [];
	const rawRows = [];
	const rawRowFile = [];

	for (let file of files) {
		const reader = new FileReader();
		await new Promise((resolve, reject) => {
			reader.onload = function(e) {
				const wb = XLSX.read(e.target.result, { type:'binary', codepage:949, raw:true });
				wb.SheetNames.forEach(sheetName => {
					const ws = wb.Sheets[sheetName];
					const rows = XLSX.utils.sheet_to_json(ws, { defval:'', raw:false, cellDates:true });
					rows.forEach((row, idx) => {
						if (idx === 0 && rawHeaders.length === 0) {
							for (const k of Object.keys(row)) rawHeaders.push(String(k).trim());
						}
						// Date 객체는 ISO로 평탄화 (그리드 표시용)
						const r = {};
						for (const k of Object.keys(row)) {
							const v = row[k];
							if (v instanceof Date && !isNaN(v.getTime())) {
								r[String(k).trim()] = excelDateFmt(v);
							} else {
								r[String(k).trim()] = (v == null ? '' : String(v));
							}
						}
						rawRows.push(r);
						rawRowFile.push(file.name);
					});
				});
				resolve();
			};
			reader.onerror = function(e) { reject(e); };
			reader.readAsBinaryString(file);
		});
	}

	if (rawRows.length === 0) {
		signUp = 'N';
		messageBox("4", "<h5>엑셀 데이터가 비어있습니다.<br>업로드 안됨 !!</h5><p></p><br>", "", "", "");
		return;
	}

	excelRawHeaders = rawHeaders;
	excelRawRows    = rawRows;
	excelRawRowFile = rawRowFile;
	excelCurrentMode = 'spcsuga';
	excelAutoMapColumns(spcsugaAutoMap);

	showExcelPreview();
}

// 수가현황 서버 전송
function doSaveSpcsugaDatas(datas) {
	$.ajax({
		url: '/main/saveSpcsugaDatas.do',
		type: 'POST',
		contentType: 'application/json',
		data: JSON.stringify(datas),
		success: function(response) {
			signUp = 'N';
			if (response.error_code !== "0") {
				messageBox("4", "<h5>전송파일 처리 중 오류가 발생했습니다. <br>" + response.error_mess + "</h5><p></p><br>", "", "", "");
			} else {
				messageBox("1", "<h5>특정수가현황 자료가 정상적으로 등록 되었습니다.</h5><p></p><br>", "", "", "");
				dataTable.ajax.reload();
				try {
					jobMon = gMonth;
					loadMonthsData();
				} catch (e) {
					console.error("loadMonthsData 실행 중 오류 발생:", e);
				}
			}
		},
		error: function(xhr, status, error) {
			signUp = 'N';
			console.error("Error fetching data:", error);
		}
	});
}

function magamLock_Open(mgmonth) {

	gMonth = mgmonth;

	$.ajax({
		url: "/main/updateMagamLock.do",
        type: "POST",
        data: { hosp_cd: hospid,
                mg_year: g_Year,
                mgmonth: gMonth,
         	    mg_flag: g_Flag
	    },
	    dataType: "json",
	    success: function(response) {
	     	 
	        dataTable.ajax.reload();
	    	 
	        Swal.fire({
		           title: '처리확인',
		           text:  '정상처리 되었습니다. ',
		           icon:  'success',
		           confirmButtonText: '확인',
		           timer: 1000,
		           timerProgressBar: true,
		           showConfirmButton: false
		    });
	    	  
	    	jobMon = gMonth; 
	    	loadMonthsData();
	    },
	    error: function(xhr, status, error) {
	        console.error("Error fetching data:", error);
	    }
	      
	});
	
	
    
}

// 월 선택 표시 — 선택된 월의 "자료보기" 버튼을 클릭(활성) 상태로 강조
function markSelectedMonth(mgmonth) {
	// 모든 자료보기 버튼 원상복구(초록 외곽선)
	$('button[data-action="fileView"]')
		.removeClass('btn-success text-white active')
		.addClass('btn-outline-success text-green');
	// 선택된 월의 자료보기 버튼만 채움(눌린 표시)
	$('button[data-action="fileView"][data-mgmonth="' + mgmonth + '"]')
		.removeClass('btn-outline-success text-green')
		.addClass('btn-success text-white active');
}

// 보기없음 클릭 — 하단 그리드 초기화(비우기) + 선택표시
function fileViewNone_Open(mgmonth) {
	if (typeof event !== 'undefined' && event) event.stopPropagation();
	try { dataTable.clear().draw(); } catch (e) {}
	markSelectedMonth(mgmonth);
}

function fileView_Open(mgmonth) {
	event.stopPropagation();
	gMonth = mgmonth;
	findField('mgmonth', gMonth)
	dataTable.ajax.reload();
	markSelectedMonth(mgmonth);
}


// ─── 자동매핑 (sugacd.jsp 방식) ───
function excelAutoMapColumns(autoMapKeywords) {
	excelColumnMap = {};
	for (var dbKey in autoMapKeywords) {
		var keywords = autoMapKeywords[dbKey];
		for (var i = 0; i < excelRawHeaders.length; i++) {
			var h = excelNormHeader(excelRawHeaders[i]);
			var matched = false;
			for (var k = 0; k < keywords.length; k++) {
				var kw = excelNormHeader(keywords[k]);
				// 엄격 우선: 정확히 일치
				if (h === kw) { matched = true; break; }
				// 느슨: 포함
				if (h.indexOf(kw) !== -1 || kw.indexOf(h) !== -1) { matched = true; break; }
			}
			if (matched && !excelColumnMap[dbKey]) {
				excelColumnMap[dbKey] = excelRawHeaders[i];
				break;
			}
		}
	}
}

// 수가현황 DB 컬럼: handleSpcsugaFileSelection에서 spcsugaDbColumns_NEW를 복사
var spcsugaDbColumns = [];

// ─── 현재 DB 컬럼 정의 반환 ───
function excelGetDbColumns() {
	return excelCurrentMode === 'spcsuga' ? spcsugaDbColumns : ipwonDbColumns;
}

// ─── 매핑 UI 구성 ───
function excelBuildMappingUI() {
	var dbColumns = excelGetDbColumns();
	var $zone = $('#excelMappingFields');
	$zone.empty();
	for (var i = 0; i < dbColumns.length; i++) {
		var col = dbColumns[i];
		var options = '<option value="">-- 미매핑 --</option>';
		for (var j = 0; j < excelRawHeaders.length; j++) {
			var h = excelRawHeaders[j];
			var sel = (excelColumnMap[col.key] === h) ? ' selected' : '';
			options += '<option value="' + $('<div>').text(h).html() + '"' + sel + '>' + $('<div>').text(h).html() + '</option>';
		}
		var star = col.required ? ' <span style="color:#dc3545;">*</span>' : '';
		var bg = excelColumnMap[col.key] ? '' : 'background-color:#ffe0e0;';
		var $div = $('<div>').css({
			'flex': '0 0 14.2857%',     // 7개/행
			'max-width': '14.2857%',
			'padding': '1px 3px',
			'margin-bottom': '2px'
		});
		$div.html(
			'<label style="font-size:11px; margin-bottom:0; font-weight:600; color:' + (col.required ? '#dc3545' : '#333') + ';">' +
				col.label + star + '</label>' +
			'<select id="excelMap_' + col.key + '" class="custom-select custom-select-sm excel-map-sel" ' +
				'data-dbkey="' + col.key + '" style="font-size:11px; height:28px; padding-right:22px; ' + bg + '">' + options + '</select>'
		);
		$zone.append($div);
	}
	// 변경 시 배경색 업데이트 + 내부 매핑 갱신
	$zone.off('change.mapsel').on('change.mapsel', '.excel-map-sel', function() {
		var dbKey = $(this).data('dbkey');
		var v = $(this).val();
		if (v) {
			excelColumnMap[dbKey] = v;
			$(this).css('background-color', '');
		} else {
			delete excelColumnMap[dbKey];
			$(this).css('background-color', '#ffe0e0');
		}
	});
}

// ─── 등록 가능 여부 판단 + 표시 ───
function excelUpdateMappingCnt() {
	var dbColumns = excelGetDbColumns();
	var total = dbColumns.length;
	var mappedCount = 0;
	var missingRequired = [];
	for (var i = 0; i < dbColumns.length; i++) {
		var col = dbColumns[i];
		if (excelColumnMap[col.key]) {
			mappedCount++;
		} else if (col.required) {
			missingRequired.push(col.label);
		}
	}

	var $box = $('#excelMappingCntBox');
	var $el  = $('#excelRegistStatus');
	if (!$el.length) return;

	var text, bg, border, color;
	if (missingRequired.length > 0) {
		// 필수 컬럼 누락 — 등록 불가
		text = '<i class="fa fa-times-circle mr-1"></i>등록 불가 — 필수 누락: ' + missingRequired.join(', ') +
		       ' <span style="font-weight:normal; opacity:0.75;">(' + mappedCount + '/' + total + ')</span>';
		bg = '#f8d7da'; border = '#dc3545'; color = '#721c24';
	} else if (mappedCount === 0) {
		// 매핑된 컬럼이 하나도 없음
		text = '<i class="fa fa-exclamation-circle mr-1"></i>등록 불가 — 매핑된 컬럼 없음';
		bg = '#fff3cd'; border = '#ffc107'; color = '#856404';
	} else {
		// 등록 가능
		text = '<i class="fa fa-check-circle mr-1"></i>매핑된 헤더' +
		       '<span style="font-weight:normal; opacity:0.75;">(' + mappedCount + '/' + total + ' 매핑됨)</span>';
		bg = '#d4edda'; border = '#28a745'; color = '#155724';
	}
	$el.html(text);
	$box.css({
		'background':  bg,
		'border-color': border,
		'color':       color
	});
}

// ─── 엑셀 미리보기 (매핑 UI + 원본 헤더 그리드) ───
function showExcelPreview() {
	var isSpcsuga = (excelCurrentMode === 'spcsuga');
	var titleText = isSpcsuga ? '특정수가현황 엑셀 미리보기' : '입원현황 엑셀 미리보기';
	$('#excelPreviewModal .modal-title').html('<i class="fa fa-file-excel mr-2"></i>' + titleText);

	// 입원현황 모드에서 상단 매칭(매핑) UI는 워너넷(winner==='Y')만 노출.
	// 비(非)워너넷은 자동매핑값으로 저장되므로 UI 구성은 그대로 수행하되 화면에서만 숨김.
	var hideMappingUI = (!isSpcsuga && winner !== 'Y');
	var hideStyle = hideMappingUI ? 'display:none;' : '';

	// 모달 본문 HTML 구성
	var html = '';
	html += '<div class="alert alert-info py-2 mb-2" style="font-size:12px; display:flex; justify-content:space-between; align-items:center;' + hideStyle + '">';
	html += '  <span><i class="fa fa-info-circle mr-1"></i>엑셀 헤더와 DB 컬럼을 매핑하세요. 자동 매핑 후 필요시 드롭다운에서 수정 가능합니다.엑셀에 요양기호 없으면 로그인정보로 저장됨 (필수 컬럼은 <span style="color:#dc3545; font-weight:600;">*</span> 표시)</span>';
	html += '  <span id="excelMappingCntBox" style="white-space:nowrap; font-weight:600; background:#ffffff; padding:4px 12px; border-radius:4px; font-size:12px; box-shadow:0 1px 2px rgba(0,0,0,0.06); margin-left:12px; border:1px solid #ccc;">' +
	        '<span id="excelRegistStatus">등록 가능 여부 확인 중...</span></span>';
	html += '</div>';
	html += '<div id="excelMappingZone" class="mb-2" style="' + hideStyle + '">';
	html += '  <div id="excelMappingFields" class="form-row" style="flex-wrap:wrap;"></div>';
	html += '</div>';
	html += '<div class="form-row mb-2" id="excelPreviewSearchBar" style="' + hideStyle + '">';
	html += '  <div class="col-3"><select id="excelPreviewSearchCol" class="custom-select custom-select-sm"><option value="">전체 컬럼</option></select></div>';
	html += '  <div class="col-5"><input type="text" id="excelPreviewSearchKw" class="form-control form-control-sm" placeholder="검색어 입력 후 Enter"></div>';
	html += '  <div class="col-4"><button type="button" class="btn btn-sm btn-outline-primary" id="btnExcelPreviewSearch"><i class="fa fa-search"></i> 검색</button> ';
	html += '    <button type="button" class="btn btn-sm btn-outline-secondary" id="btnExcelPreviewSearchReset">초기화</button>';
	html += '    <span id="excelPreviewSearchCnt" class="ml-2" style="font-size:12px; color:#666;"></span></div>';
	html += '</div>';
	// 테이블 외부 래퍼로 overflow 처리 (가로/세로 둘 다 이 div가 담당)
	var tableMinWidth = Math.max(1000, (excelRawHeaders.length + 1) * 160);
	html += '<div id="excelPreviewScrollWrap" style="width:100%; max-height:38vh; overflow:auto; border:1px solid #dee2e6; border-radius:3px; position:relative;">';
	html += '  <table id="excelPreviewTable" class="display nowrap stripe hover cell-border compact" style="font-size:12px; width:' + tableMinWidth + 'px; min-width:' + tableMinWidth + 'px;"></table>';
	html += '</div>';

	$('#excelPreviewContent').html(html);

	// 외부 래퍼 스크롤바 항상 표시 + 헤더 sticky CSS (한 번만 주입)
	if (!document.getElementById('excelPreviewScrollStyle')) {
		var pStyle = document.createElement('style');
		pStyle.id = 'excelPreviewScrollStyle';
		pStyle.innerHTML =
			// 외부 래퍼 스크롤바 스타일
			'#excelPreviewScrollWrap::-webkit-scrollbar { height:14px; width:10px; background:#e9ecef; }' +
			'#excelPreviewScrollWrap::-webkit-scrollbar-thumb { background:#6c757d; border-radius:7px; border:2px solid #e9ecef; }' +
			'#excelPreviewScrollWrap::-webkit-scrollbar-thumb:hover { background:#495057; }' +
			'#excelPreviewScrollWrap::-webkit-scrollbar-track { background:#e9ecef; border-radius:7px; }' +
			'#excelPreviewScrollWrap { scrollbar-width:auto; scrollbar-color:#6c757d #e9ecef; }' +
			// 매핑 드롭다운에 ▼ 아래 화살표만 표시 (custom-select 스타일 override)
			'.excel-map-sel {' +
			'  appearance:none !important; -webkit-appearance:none !important; -moz-appearance:none !important;' +
			'  background-image:url("data:image/svg+xml;charset=utf-8,%3Csvg xmlns=\'http://www.w3.org/2000/svg\' viewBox=\'0 0 10 6\'%3E%3Cpath fill=\'%23555\' d=\'M0 0 L10 0 L5 6 z\'/%3E%3C/svg%3E") !important;' +
			'  background-repeat:no-repeat !important;' +
			'  background-position:right 8px center !important;' +
			'  background-size:10px 6px !important;' +
			'  padding-right:24px !important;' +
			'}' +
			// ── 헤더 sticky: 세로 스크롤 시 헤더 고정 ──
			'#excelPreviewTable thead th {' +
			'  position:sticky; top:0; z-index:10;' +
			'  background:#2a5298 !important; color:#ffffff !important;' +
			'  border-right:1px solid rgba(255,255,255,0.1);' +
			'  box-shadow:0 2px 4px rgba(0,0,0,0.08);' +
			'}' +
			// DataTables 기본 정렬 아이콘(화살표) 색상도 흰색으로 맞춤
			'#excelPreviewTable thead th.sorting, ' +
			'#excelPreviewTable thead th.sorting_asc, ' +
			'#excelPreviewTable thead th.sorting_desc { color:#fff !important; }' +
			'#excelPreviewTable thead th.sorting::before, ' +
			'#excelPreviewTable thead th.sorting::after, ' +
			'#excelPreviewTable thead th.sorting_asc::before, ' +
			'#excelPreviewTable thead th.sorting_asc::after, ' +
			'#excelPreviewTable thead th.sorting_desc::before, ' +
			'#excelPreviewTable thead th.sorting_desc::after { color:#fff !important; opacity:0.7; }';
		document.head.appendChild(pStyle);
	}

	// 매핑 UI 구성
	excelBuildMappingUI();
	excelUpdateMappingCnt();
	// 드롭다운 변경 시 매핑 카운트 갱신
	$('#excelMappingFields').off('change.cnt').on('change.cnt', '.excel-map-sel', function() {
		excelUpdateMappingCnt();
	});

	// DataTables 그리드 (엑셀 원본 헤더로 동적 생성)
	if (excelPreviewDT) {
		try { excelPreviewDT.destroy(); } catch (e) {}
		$('#excelPreviewTable').empty();
		excelPreviewDT = null;
	}
	var cols = [
		{ data: null, title: 'No', orderable: false, searchable: false, className: 'dt-body-center',
		  width: '40px',
		  render: function(data, type, row, meta) { return meta.row + 1; } }
	];
	for (var i = 0; i < excelRawHeaders.length; i++) {
		(function(h) {
			cols.push({
				data: h,
				title: h,
				defaultContent: '',
				className: 'dt-body-left',
				width: '140px',                  // 좌우 스크롤 유도
				render: function(data, type) {
					if (data == null) return '';
					var s = String(data);
					if (type === 'display' && s.length > 120) {
						var safe = $('<span>').text(s).html();
						return '<span title="' + safe + '">' + $('<span>').text(s.substr(0, 120)).html() + '...</span>';
					}
					return s;
				}
			});
		})(excelRawHeaders[i]);
	}

	excelPreviewDT = $('#excelPreviewTable').DataTable({
		data: excelRawRows,
		columns: cols,
		// DataTables 내부 scroll 완전 OFF — 외부 div 래퍼가 가로/세로 overflow 모두 담당
		scrollX: false,
		scrollY: false,
		paging: false,
		ordering: true,
		searching: true,
		info: true,
		autoWidth: false,
		deferRender: true,
		processing: true,
		// 검색창 좌측에 안내 문구 배치 (dom layout)
		dom: '<"excel-dt-toprow d-flex justify-content-between align-items-center mb-1"<"excel-dt-notice">f>rt<"mt-1"i>',
		language: {
			search: '검색 : ',
			emptyTable: '데이터가 없습니다.',
			lengthMenu: '_MENU_',
			info: '현재 _START_ - _END_ / 총 _TOTAL_건',
			infoEmpty: '데이터 없음',
			processing: '처리 중...',
			paginate: { next: '다음', previous: '이전' }
		},
		rowCallback: function(row) {
			$(row).find('td').css('padding', '2px 6px');
		},
		initComplete: function() {
			// 안내 문구 HTML 주입 (dom의 "excel-dt-notice" div)
			$(this.api().table().container()).find('.excel-dt-notice').html(
				'<span style="display:inline-block; padding:4px 10px; background:#e7f3ff; ' +
				'border-left:3px solid #2a5298; color:#1e3c72; font-size:12px; font-weight:600; ' +
				'border-radius:2px;"><i class="fa fa-file-excel mr-1"></i>아래 내용은 엑셀로 로드된 원본 데이터입니다</span>'
			);
		}
	});

	// 미리보기 검색바 구성
	(function() {
		var $sel = $('#excelPreviewSearchCol');
		for (var i = 0; i < excelRawHeaders.length; i++) {
			// No(0) 다음부터가 실 데이터 컬럼 → dt 컬럼 인덱스 = i + 1
			$sel.append('<option value="' + (i + 1) + '">' + $('<div>').text(excelRawHeaders[i]).html() + '</option>');
		}
		$('#btnExcelPreviewSearch').off('click').on('click', excelPreviewSearchRun);
		$('#btnExcelPreviewSearchReset').off('click').on('click', excelPreviewSearchReset);
		$('#excelPreviewSearchKw').off('keydown.preview').on('keydown.preview', function(e) {
			if (e.key === 'Enter') { e.preventDefault(); excelPreviewSearchRun(); }
		});
	})();

	// 저장 / 닫기 버튼
	$('#btnExcelPreviewSave').off('click').on('click', function() {
		if (excelCurrentMode === 'ipwon') {
			saveIpwonWithMapping();
		} else {
			saveSpcsugaWithMapping();
		}
	});
	$('#btnExcelPreviewX').off('click').on('click', function() {
		signUp = 'N';
		$('#excelPreviewModal').modal('hide');
	});
	$('#btnExcelPreviewCancel').off('click').on('click', function() {
		signUp = 'N';
		$('#excelPreviewModal').modal('hide');
	});

	// 모달이 완전히 표시된 후 테이블 min-width 최종 확인
	$('#excelPreviewModal').off('shown.bs.modal.dtadjust').on('shown.bs.modal.dtadjust', function() {
		setTimeout(function() {
			var minW = Math.max(1000, (excelRawHeaders.length + 1) * 160);
			// 테이블 폭 재확인 (DataTables가 width를 override할 가능성 대비)
			$('#excelPreviewTable').css({
				'width': minW + 'px',
				'min-width': minW + 'px'
			});
		}, 200);
	});
	$('#excelPreviewModal').modal('show');
}

function excelPreviewSearchRun() {
	if (!excelPreviewDT) return;
	var colIdx = $('#excelPreviewSearchCol').val();
	var kw = $('#excelPreviewSearchKw').val() || '';
	excelPreviewDT.search('').columns().search('');
	if (colIdx === '') {
		excelPreviewDT.search(kw);
	} else {
		excelPreviewDT.column(parseInt(colIdx, 10)).search(kw);
	}
	excelPreviewDT.draw();
	var cnt = excelPreviewDT.rows({ search: 'applied' }).count();
	$('#excelPreviewSearchCnt').text('검색결과: ' + cnt + '건');
}
function excelPreviewSearchReset() {
	if (!excelPreviewDT) return;
	$('#excelPreviewSearchCol').val('');
	$('#excelPreviewSearchKw').val('');
	excelPreviewDT.search('').columns().search('').draw();
	$('#excelPreviewSearchCnt').text('');
}

// ─── 현재 드롭다운에서 매핑 읽기 ───
function excelReadCurrentMapping() {
	var map = {};
	$('.excel-map-sel').each(function() {
		var dbKey = $(this).data('dbkey');
		var v = $(this).val();
		if (v) map[dbKey] = v;
	});
	return map;
}

// ─── 필수 매핑 검증 ───
function excelValidateRequired(map) {
	var dbColumns = excelGetDbColumns();
	var missing = [];
	for (var i = 0; i < dbColumns.length; i++) {
		var c = dbColumns[i];
		if (c.required && !map[c.key]) missing.push(c.label);
	}
	return missing;
}

// ─── 엑셀 합계/소계/빈 행 판별 (저장에서 제외) ───
function excelIsSummaryOrEmptyRow(src) {
	// 1) 합계/소계/총계 키워드가 들어간 셀이 있으면 요약 행
	var summaryRegex = /^\[?\s*(합\s*계|소\s*계|총\s*계|합계|소계|총계|total|합\s*\s\s*계)\s*\]?\s*$/i;
	// 2) "인원:", "건수:", "총진료일:" 같은 레이블 접두 (값 대신 설명문)
	var labelRegex   = /^(인원|건수|총진료일|총\s*인원|합\s*계|소\s*계|총\s*계|총합|총계)\s*[:：]/;
	var nonEmptyCount = 0;
	for (var h in src) {
		var v = String(src[h] == null ? '' : src[h]).trim();
		if (!v) continue;
		nonEmptyCount++;
		if (summaryRegex.test(v)) return true;
		if (labelRegex.test(v))   return true;
	}
	// 3) 전부 빈 행
	if (nonEmptyCount === 0) return true;
	return false;
}

// ─── 입원현황 저장: 매핑 적용 + 날짜 포맷 + 주민번호 카운트 ───
//     요양기호 매핑됐으면 로그인 병원코드와 대조 (있으면 체크, 없으면 무시)
//     합계/소계/빈 행은 저장에서 자동 제외
function saveIpwonWithMapping() {
	var map = excelReadCurrentMapping();
	var missing = excelValidateRequired(map);
	if (missing.length > 0) {
		messageBox("4", "<h5>필수 컬럼 매핑 누락:<br>" + missing.join(', ') + "</h5><p></p><br>", "", "", "");
		return;
	}

	var jobdt = getJobDateTime();
	var datas = [];
	var juminCnt = 0;
	var seqNumber = 0;
	var skippedSummary = 0;       // 합계/빈 행 스킵 카운터
	var hospMismatch = [];        // 요양기호 불일치 행 기록 (매핑된 경우만)
	var hospCheckEnabled = !!map.hosp_cd;

	for (var i = 0; i < excelRawRows.length; i++) {
		var src = excelRawRows[i];

		// 합계/소계/빈 행 스킵
		if (excelIsSummaryOrEmptyRow(src)) {
			skippedSummary++;
			continue;
		}

		seqNumber++;

		// 요양기호 검증 (엑셀에 있고 값이 있을 때만)
		if (hospCheckEnabled) {
			var xlsHosp = String(src[map.hosp_cd] == null ? '' : src[map.hosp_cd]).trim();
			if (xlsHosp && xlsHosp !== String(hospid).trim()) {
				hospMismatch.push({ row: i + 2, xls: xlsHosp, name: (src[map.patname] || '') });
			}
		}

		var mapped = {
			hosp_cd:  hospid,                                    // 저장값은 항상 로그인 병원
			jobyymm:  g_Year + gMonth,
			seq_num:  seqNumber,
			file_nm:  (excelRawRowFile[i] || ''),
			jobs_dt:  jobdt,
			reg_user: userid
		};
		for (var dbKey in map) {
			if (dbKey === 'hosp_cd') continue;                   // hosp_cd는 엑셀값 저장 안 함
			var excelCol = map[dbKey];
			var v = (src[excelCol] == null ? '' : src[excelCol]);
			if (dbKey === 'ipwondt' || dbKey === 'tewondt') {
				mapped[dbKey] = excelDateFmt(v);
			} else {
				mapped[dbKey] = v;
			}
		}
		if (mapped.juminno) juminCnt++;
		datas.push(mapped);
	}

	if (skippedSummary > 0) {
		console.log('[입원현황] 합계/빈 행 자동 제외: ' + skippedSummary + '건');
	}

	// 요양기호 불일치 처리
	if (hospMismatch.length > 0) {
		var sample = hospMismatch.slice(0, 5).map(function(m) {
			return '• ' + m.row + '행 : ' + m.xls + (m.name ? ' (' + m.name + ')' : '');
		}).join('<br>');
		var moreTxt = hospMismatch.length > 5 ? '<br>... 외 ' + (hospMismatch.length - 5) + '건' : '';
		Swal.fire({
			title: '요양기관기호 불일치',
			html: '<div style="text-align:left; font-size:13px;">엑셀 요양기관기호가 로그인 병원(<strong>' + hospid + '</strong>)과 다릅니다.<br>불일치 건수: <strong>' + hospMismatch.length + '건</strong><hr style="margin:6px 0;">' + sample + moreTxt + '<hr style="margin:6px 0;">계속 등록하시겠습니까?</div>',
			icon: 'warning',
			showCancelButton: true,
			confirmButtonText: '등록 강행',
			cancelButtonText: '취소',
			customClass: { popup: 'small-swal' }
		}).then(function(result) {
			if (result.isConfirmed) {
				$('#excelPreviewModal').modal('hide');
				doSaveExcelDatas(datas, seqNumber, juminCnt);
			}
		});
		return;
	}

	// 모달 닫고 저장
	$('#excelPreviewModal').modal('hide');
	doSaveExcelDatas(datas, seqNumber, juminCnt);
}

// ─── 엑셀 저장 실행 (입원현황) ───
function doSaveExcelDatas(datas, seqNumber, jumin_Cnt) {

	if (datas.length > 0 && jumin_Cnt === seqNumber) {
		$.ajax({
			url: '/main/saveExcelDatas.do',
			type: 'POST',
			contentType: 'application/json',
			data: JSON.stringify(datas),
			success: function(response) {
				signUp = 'N';
				if (response.error_code !== "0") {
					messageBox("4", "<h5>전송파일 처리 중 오류가 발생했습니다. <br>" + response.error_mess + "</h5><p></p><br>", "", "", "");
				} else {
					messageBox("1", "<h5>입원현황 자료가 정상적으로 등록 되었습니다.</h5><p></p><br>", "", "", "");
					dataTable.ajax.reload();
					try {
						jobMon = gMonth;
						loadMonthsData();
					} catch (e) {
						console.error("loadMonthsData 실행 중 오류 발생:", e);
					}
				}
			},
			error: function(xhr, status, error) {
				signUp = 'N';
				console.error("Error fetching data:", error);
			}
		});

	} else if (datas.length > 0) {
		let mess = '주민번호 앞 6자리 일부 누락된 입원현황 파일';
		let cnts = seqNumber - jumin_Cnt;

		if (jumin_Cnt === 0) {
			mess = '주민번호 앞 6자리 전체 누락된 입원현황 파일';
		}

		Swal.fire({
			title: '등록여부',
			html: '<strong> 누락정보 : ' + mess + ' : 누락건수 [' + cnts + ']건 입니다. </strong>',
			icon: 'question',
			showCancelButton: true,
			confirmButtonText: '등록',
			cancelButtonText: '취소',
			customClass: { popup: 'small-swal' }
		}).then((result) => {
			if (result.isConfirmed) {
				$.ajax({
					url: '/main/saveExcelDatas.do',
					type: 'POST',
					contentType: 'application/json',
					data: JSON.stringify(datas),
					success: function(response) {
						signUp = 'N';
						if (response.error_code !== "0") {
							messageBox("4", "<h5>전송파일 처리 중 오류가 발생했습니다. <br>" + response.error_mess + "</h5><p></p><br>", "", "", "");
						} else {
							messageBox("1", "<h5>입원현황 자료가 정상적으로 등록 되었습니다.</h5><p></p><br>", "", "", "");
							dataTable.ajax.reload();
							try {
								jobMon = gMonth;
								loadMonthsData();
							} catch (e) {
								console.error("loadMonthsData 실행 중 오류 발생:", e);
							}
						}
					},
					error: function(xhr, status, error) {
						signUp = 'N';
						console.error("Error fetching data:", error);
					}
				});
			} else {
				signUp = 'N';
			}
		});

	} else {
		signUp = 'N';
		messageBox("4", "<h5>매핑된 정보가 없습니다!! <br>정확한 입원현황 파일내용을 확인하세요.<br>업로드 안됨 !!</h5><p></p><br>", "", "", "");
	}
}

// ─── 수가현황 저장: 매핑 적용 + 내원일 분해 + 입원일 연도 적용 + 요양기호 검증 + 합계/빈행 스킵 + YYYYMMDD 포맷 ───
function saveSpcsugaWithMapping() {
	var map = excelReadCurrentMapping();
	var missing = excelValidateRequired(map);    // 수가현황은 필수 없음 (모두 optional)이지만 체크 유지
	if (missing.length > 0) {
		messageBox("4", "<h5>필수 컬럼 매핑 누락:<br>" + missing.join(', ') + "</h5><p></p><br>", "", "", "");
		return;
	}

	var jobdt = getJobDateTime();
	var datas = [];
	var seqNumber = 0;
	var skippedSummary = 0;       // 합계/빈 행 스킵
	var skippedNoRequired = 0;    // 주요 필드 없는 행 스킵 (요양기호/환자명/내원일/주민번호/edi코드/입원일 모두 없음)
	var hospMismatch = [];        // 요양기호 불일치 (매핑된 경우만)
	var hospCheckEnabled = !!map.hosp_cd;

	for (var i = 0; i < excelRawRows.length; i++) {
		var src = excelRawRows[i];

		// 1) 합계/소계/빈 행 스킵
		if (excelIsSummaryOrEmptyRow(src)) {
			skippedSummary++;
			continue;
		}

		// 2) 매핑된 값 수집 (base 객체)
		var base = {};
		for (var dbKey in map) {
			var excelCol = map[dbKey];
			var v = (src[excelCol] == null ? '' : src[excelCol]);
			if (dbKey === 'tewondt' || dbKey === 'ipwondt') {
				base[dbKey] = excelDateFmt(v);   // YYYY-MM-DD로 일단 정규화
			} else {
				base[dbKey] = String(v).trim();
			}
		}

		// 3) 주요 식별 정보가 전혀 없는 행 스킵 (데이터 쓰레기 방지)
		var hasAnyKey = (base.hosp_cd || base.chartno || base.patname || base.juminno || base.edi_code || base.suga_cd || base.med_start || base.ipwondt);
		if (!hasAnyKey) {
			skippedNoRequired++;
			continue;
		}

		// 4) 요양기관기호 검증 (매핑된 경우만, 값 있을 때만)
		if (hospCheckEnabled && base.hosp_cd) {
			if (String(base.hosp_cd).trim() !== String(hospid).trim()) {
				hospMismatch.push({ row: i + 2, xls: base.hosp_cd, name: (base.patname || '') });
			}
		}

		// 5) 내원일 분해 + 입원일 연도 적용
		var ipwonYear = (base.ipwondt && base.ipwondt.length >= 4) ? base.ipwondt.substring(0, 4) : g_Year;
		var visits = spcsugaSplitVisits(base.med_start);
		var expanded = visits.length ? visits : [''];

		for (var vi = 0; vi < expanded.length; vi++) {
			var tok = expanded[vi];
			seqNumber++;
			var r = {};
			// 매핑된 필드 복사
			for (var k in base) { r[k] = base[k]; }
			// 내원일: MM-DD 토큰 + 입원일 연도 → YYYYMMDD
			r.med_start = spcsugaStripDateSep(spcsugaMakeFullDate(tok, ipwonYear));
			// 입원일/퇴원일: YYYY-MM-DD → YYYYMMDD
			r.ipwondt   = spcsugaStripDateSep(r.ipwondt || '');
			r.tewondt   = spcsugaStripDateSep(r.tewondt || '');
			// 세션/시스템 값 강제 주입
			r.hosp_cd   = hospid;
			r.jobyymm   = g_Year + gMonth;
			r.seq_num   = seqNumber;
			r.file_nm   = (excelRawRowFile[i] || '');
			r.jobs_dt   = jobdt;
			r.reg_user  = userid;
			r.upd_user  = userid;
			r.reg_ip    = '127.0.0.1';
			r.upd_ip    = '127.0.0.1';
			datas.push(r);
		}
	}

	if (skippedSummary > 0)     console.log('[수가현황] 합계/빈 행 자동 제외: ' + skippedSummary + '건');
	if (skippedNoRequired > 0)  console.log('[수가현황] 주요 식별값 없는 행 제외: ' + skippedNoRequired + '건');

	if (datas.length === 0) {
		signUp = 'N';
		messageBox("4", "<h5>저장할 데이터가 없습니다!! <br>매핑을 확인하세요.</h5><p></p><br>", "", "", "");
		return;
	}

	// 요양기관기호 불일치 → 등록 차단 (타 병원 자료 오염 방지)
	if (hospMismatch.length > 0) {
		var sample = hospMismatch.slice(0, 5).map(function(m) {
			return '• ' + m.row + '행 : ' + m.xls + (m.name ? ' (' + m.name + ')' : '');
		}).join('<br>');
		var moreTxt = hospMismatch.length > 5 ? '<br>... 외 ' + (hospMismatch.length - 5) + '건' : '';
		Swal.fire({
			title: '등록 불가 — 요양기관기호 불일치',
			html: '<div style="text-align:left; font-size:13px;">엑셀 요양기관기호가 로그인 병원(<strong>' + hospid + '</strong>)과 다릅니다.<br>불일치 건수: <strong>' + hospMismatch.length + '건</strong><hr style="margin:6px 0;">' + sample + moreTxt + '<hr style="margin:6px 0;"><strong style="color:#dc3545;">타 병원 자료는 등록할 수 없습니다.</strong><br>엑셀 파일을 확인 후 다시 업로드해 주세요.</div>',
			icon: 'error',
			confirmButtonText: '확인',
			customClass: { popup: 'small-swal' }
		});
		signUp = 'N';
		return;
	}

	// 확인 후 저장
	var expandedInfo = (datas.length !== (excelRawRows.length - skippedSummary - skippedNoRequired))
		? '<br><small style="color:#666;">(내원일 여러개 분해로 원본 ' + (excelRawRows.length - skippedSummary - skippedNoRequired) + '행 → 저장 ' + datas.length + '건)</small>'
		: '';
	Swal.fire({
		title: '저장 확인',
		html: '총 <strong>' + datas.length + '건</strong>을 저장하시겠습니까?' + expandedInfo,
		icon: 'question',
		showCancelButton: true,
		confirmButtonText: '저장',
		cancelButtonText: '취소',
		customClass: { popup: 'small-swal' }
	}).then(function(result) {
		if (result.isConfirmed) {
			$('#excelPreviewModal').modal('hide');
			doSaveSpcsugaDatas(datas);
		}
	});
}


function getJobDateTime() {
	
    let now     = new Date();
    let year    = now.getFullYear();
    let month   = String(now.getMonth()).padStart(2, '0');
    let day     = String(now.getDate()).padStart(2, '0');
    let hours   = String(now.getHours()).padStart(2, '0');
    let minutes = String(now.getMinutes()).padStart(2, '0');
    let seconds = String(now.getSeconds()).padStart(2, '0');
    
    return year + month + day + hours + minutes + seconds;
}

function loadMonthsData() {
	$.ajax({
        url: '/main/getMagamYearList.do',
        method: 'POST',
        data: { hosp_cd: hospid, 
        	    mg_year: g_Year,
        	    mg_flag: g_Flag
        	  },
        success: function(response) {
        	updateMonthsContainer(response);
        },
        error: function(xhr, status, error) {
            console.error("Error fetching data:", error);
        }
    });
}

function updateMonthsContainer(rawData) {
    const find = typeof rawData === 'string' ? JSON.parse(rawData) : rawData;

    const monthsContainer = $("#months-container");
    monthsContainer.empty();
    if (!find || !find.data || !Array.isArray(find.data)) {
        console.error('Invalid data structure');
        alert("Data structure is invalid");
        return;
    }

    let fMonth = '01';
    find.data.forEach((item, index) => {
        let activeTabId = $('#mg_FlagTab a.active').attr('id');
        let headerClass;
        let buttonClass;

        if (activeTabId === "c-tab") {
            headerClass = item.magamyn === "Y" ? "bg-info" : "bg-light";
            buttonClass = item.magamyn === "Y" ? "btn-outline-info" : "btn-outline-info";
        } else {
            headerClass = item.magamyn === "Y" ? "bg-primary" : "bg-light";
            buttonClass = item.magamyn === "Y" ? "btn-outline-primary" : "btn-outline-primary";
        }

        const h4headClass = item.magamyn === "Y" ? "text-white" : "text-black";
        const button_Text = item.magamyn === "Y" ? "등록완료" : "미등록";
        const hovers_Text = item.magamyn === "Y" ? "재등록" : "등록하기";

        let buttonHTML = '';
        
        if (item.lock_yn === "N" || (winner === 'Y' && ['1', '2'].includes(mainfg))) {
        	buttonHTML += '<button data-action="fileLoad" data-mgmonth="' + item.mgmonth + '" id="' + item.mgmonth + '" class="btn ' + buttonClass + ' btn-block btn-sm small hover-change mb-1" data-original="' + button_Text + '" data-hover="' + hovers_Text + '">' + button_Text + '</button>';
        }

        if (item.magamyn === "Y") {
        	fMonth = item.mgmonth;
            buttonHTML += '<button data-action="fileView" data-mgmonth="' + item.mgmonth + '" class="btn btn-outline-success text-green btn-block btn-sm small mb-1">자료보기</button>';
        } else {
            buttonHTML += '<button data-action="fileViewNone" data-mgmonth="' + item.mgmonth + '" class="btn btn-outline-success btn-block btn-sm small text-green mb-1">보기없음</button>';
        }

        if (item.ipwonyn === "Y") {
            buttonHTML += '<button data-action="excelLoad" data-mgmonth="' + item.mgmonth + '" id="excel_' + item.mgmonth + '" class="btn btn-outline-dark text-black btn-block btn-sm small mb-1">입원현황</button>';
        } else {
            if (item.magamyn === "Y") {
                buttonHTML += '<button data-action="excelLoad" data-mgmonth="' + item.mgmonth + '" id="excel_' + item.mgmonth + '" class="btn btn-outline-dark text-black btn-block btn-sm small mb-1">등록안됨</button>';
            } else {
                buttonHTML += '<button data-action="excelLoad" data-mgmonth="' + item.mgmonth + '" id="excel_' + item.mgmonth + '" class="btn btn-outline-dark text-black btn-block btn-sm small mb-1">자료없음</button>';
            }
        }

        // 수가 업로드 버튼은 위너넷(winner === 'Y') 사용자에게만 노출
        if (winner === 'Y') {
            if (item.spcsugayn === "Y") {
                buttonHTML += '<button data-action="spcsugaLoad" data-mgmonth="' + item.mgmonth + '" id="spc_' + item.mgmonth + '" class="btn btn-outline-success text-green btn-block btn-sm small mb-1">수가현황</button>';
            } else {
                if (item.magamyn === "Y") {
                    buttonHTML += '<button data-action="spcsugaLoad" data-mgmonth="' + item.mgmonth + '" id="spc_' + item.mgmonth + '" class="btn btn-outline-success text-green btn-block btn-sm small mb-1">수가</button>';
                } else {
                    buttonHTML += '<button data-action="spcsugaLoad" data-mgmonth="' + item.mgmonth + '" id="spc_' + item.mgmonth + '" class="btn btn-outline-success text-green btn-block btn-sm small mb-1">수가없음</button>';
                }
            }
        }

        if ((winner === 'Y' && ['1', '2'].includes(mainfg)) && item.magamyn === "Y") {
        	if (item.lock_yn === "Y") {
                buttonHTML += '<button data-action="magamLock" data-mgmonth="' + item.mgmonth + '" id="lock_' + item.mgmonth + '" class="btn btn-danger         text-black btn-block btn-sm small mb-1">🔒잠김</button>';
            } else {
                buttonHTML += '<button data-action="magamLock" data-mgmonth="' + item.mgmonth + '" id="lock_' + item.mgmonth + '" class="btn btn-outline-danger text-black btn-block btn-sm small mb-1">🔓열림</button>';
            }
        }


        const cardHTML =
            '<div class="col-xl-1 col-lg-2 col-md-3 col-sm-4 col-6 mb-2 month-card" data-month="' + item.mgmonth + '">' +
                '<div class="card" style="margin-bottom:0;">' +
                    '<div class="card-header ' + headerClass + ' text-center p-1">' +
                        '<h4 class="mb-0 ' + h4headClass + '">' + item.mgmonth + '월' + '</h4>' +
                    '</div>' +
                    '<div class="card-body text-center p-1">' +
                        buttonHTML +
                    '</div>' +
                '</div>' +
            '</div>';

        monthsContainer.append(cardHTML);
    });

    // 마우스 이벤트 처리
    $('.hover-change').hover(
        function () {
            $(this).text($(this).data('hover'));
        },
        function () {
            $(this).text($(this).data('original'));
        }
    );

    // if (fMonth != gMonth) {
        // gMonth = fMonth;

        fileView_Open(jobMon);

    // }
}

// ========== 파일 검증 모달 관련 함수 ==========

// 파일확장자/파일명 → jobssam 매핑 (SP 로직과 동일)
// SAMFVER_MST에 SAMVER='M010.1','M020.1' 등 파일명 그대로 저장됨
function fn_GetJobsSam(fileName) {
    var ext = fileName.split('.').pop().toUpperCase();
    var ghpExts = ['GHP','B00','B01','C00','C01','B60','B61','C60','C61'];
    var repExts = ['L32','CXX','L01','L02','L03','L04','L05','L06','L07','L08','L09',
                   'L10','L11','L12','L13','L14','L15','L16','L17','L18','L19','L20'];
    if (ghpExts.indexOf(ext) >= 0) return 'GHP';
    if (ext === 'CAR') return 'CAR';
    if (repExts.indexOf(ext) >= 0) return 'REP';
    return fileName.toUpperCase();
}

// EUC-KR 보정 라인 길이 계산 (SP의 valsize 계산과 유사)
function fn_CalcValsize(lineval) {
    var byteLen = 0;
    for (var i = 0; i < lineval.length; i++) {
        var code = lineval.charCodeAt(i);
        byteLen += (code > 127) ? 2 : 1;
    }
    return byteLen - 1;
}

// 검증 모달 표시

// 데이터 점검 (별도 버튼) - 파일선택 후 INSERT만 수행, SP 미실행
function fn_DataVerify(mgmonth) {
    if (signUp === 'Y') {
        Swal.fire({title: '작업 진행 중', text: '작업 중입니다. 잠시 후 시도하세요.', icon: 'warning', timer: 800, showConfirmButton: false});
        return;
    }

    gMonth = mgmonth;
    findField('mgmonth', gMonth);

    var folderInput = document.getElementById('folderInput');
    var file_Select = document.getElementById("file_Select");

    if (file_Select.value === "2") {
        folderInput.setAttribute("webkitdirectory", "");
    } else {
        folderInput.removeAttribute("webkitdirectory");
    }

    var acceptExtensions = allowedFiles.map(function(file) {
        if (file.startsWith('*.')) return '.' + file.slice(2);
        return '.' + file.split('.').pop();
    }).join(',');
    folderInput.setAttribute('accept', acceptExtensions);

    folderInput.value = '';
    folderInput.onchange = handleVerifyFileSelection;
    folderInput.click();
}

// 데이터 점검 전용 파일 처리 (handleFileSelection과 별도, 기존 미등록 로직 수정 안함)
async function handleVerifyFileSelection(event) {
    signUp = 'Y';
    gFiles = event.target.files;

    if (!gFiles || gFiles.length === 0) { signUp = 'N'; return; }

    var jobs_dt = getJobDateTime();
    var readFilesPromises = [];

    for (var fi = 0; fi < gFiles.length; fi++) {
        (function(file) {
            readFilesPromises.push(new Promise(function(resolve) {
                var reader = new FileReader();
                reader.readAsText(file, 'euc-kr');
                reader.onload = function(e) {
                    var content = e.target.result;
                    var fileLines = content.split(/\r?\n/);   // CRLF 파일의 trailing \r 제거 — 고정폭 라인 +1byte(valsize 오류) 방지
                    var data = [];
                    for (var idx = 0; idx < fileLines.length; idx++) {
                        if (fileLines[idx]) {
                            data.push({
                                hosp_cd:  hospid,
                                mg_year:  g_Year,
                                mgmonth:  gMonth,
                                mg_flag:  g_Flag,
                                jobs_dt:  jobs_dt,
                                chunggu:  '1',
                                file_nm:  file.name,
                                line_no:  idx + 1,
                                lineval:  fileLines[idx],
                                reg_user: userid,
                                upd_user: userid,
                                reg_ip:   '127.0.0.1',
                                upd_ip:   '127.0.0.1'
                            });
                        }
                    }
                    resolve(data);
                };
                reader.onerror = function() { resolve([]); };
            }));
        })(gFiles[fi]);
    }

    try {
        var allData = await Promise.all(readFilesPromises);
        var allDataFlat = allData.flat();
        var t_lines = allDataFlat.length;

        if (t_lines === 0) {
            signUp = 'N';
            messageBox("4", "<h5>파일에 데이터가 없습니다.</h5>", "", "", "");
            return;
        }

        allDataFlat.forEach(function(d) { d.t_lines = t_lines; });

        // 로딩 표시
        Swal.fire({
            title: '데이터 점검 중...',
            html: '<div style="font-size:13px;">파일을 업로드하고 검증 정보를 조회합니다.</div>',
            allowOutsideClick: false,
            didOpen: function() { Swal.showLoading(); }
        });

        // INSERT만 수행 (프로시저 미실행)
        var uploadResp = await $.ajax({
            url: '/main/uploadMagamFilesOnly.do',
            type: 'POST',
            contentType: 'application/json',
            data: JSON.stringify(allDataFlat)
        });

        if (uploadResp.error_code !== "0") {
            Swal.close();
            signUp = 'N';
            messageBox("4", "<h5>파일 업로드 중 오류: " + (uploadResp.error_mess || uploadResp.error_code) + "</h5>", "", "", "");
            return;
        }

        // 검증 모달 표시
        var verifyData = {
            hosp_cd: hospid,
            mg_year: g_Year,
            mgmonth: gMonth,
            mg_flag: g_Flag,
            jobs_dt: jobs_dt,
            t_lines: t_lines,
            reg_user: userid,
            upd_user: userid,
            reg_ip: '127.0.0.1',
            upd_ip: '127.0.0.1'
        };
        window._verifyMagamData = verifyData;

        await fn_ShowVerifyModal(verifyData);
        Swal.close();

    } catch(e) {
        Swal.close();
        signUp = 'N';
        console.error('데이터 점검 오류:', e);
        messageBox("4", "<h5>데이터 점검 중 오류가 발생했습니다.</h5>", "", "", "");
    }
}

async function fn_ShowVerifyModal(verifyData) {
    try {
        // 1) TBL_FILES_DATA에서 파일별 첫줄 조회
        var response = await $.ajax({
            url: '/main/verifyFilesData.do',
            type: 'POST',
            contentType: 'application/json',
            data: JSON.stringify(verifyData)
        });

        if (response.error_code !== "0") {
            signUp = 'N';
            messageBox("4", "<h5>검증 데이터 조회 실패: " + response.error_mess + "</h5>", "", "", "");
            return;
        }

        var firstLines = response.firstLines;
        if (!firstLines || firstLines.length === 0) {
            signUp = 'N';
            messageBox("4", "<h5>검증할 파일 데이터가 없습니다.</h5>", "", "", "");
            return;
        }

        // 2) 파일별 DISTINCT valsize로 SAMVER 매칭
        // 파일명 오름차순 정렬 (가장 작은 파일명부터 검색)
        firstLines.sort(function(a, b) {
            var fnA = (a.FILE_NM || a.file_nm || '').toUpperCase();
            var fnB = (b.FILE_NM || b.file_nm || '').toUpperCase();
            return fnA.localeCompare(fnB);
        });

        // K,D,H 시작 파일: H010에서 버전 추출
        // C,M 시작 파일: 가장 작은 파일명(정렬 후 첫번째)에서 버전 추출
        var jobsver_H010 = '';
        var jobsver_CM = '';
        for (var h = 0; h < firstLines.length; h++) {
            var hFn = (firstLines[h].FILE_NM || firstLines[h].file_nm || '').toUpperCase();
            var hLineval = firstLines[h].LINEVAL || firstLines[h].lineval || '';
            var hJobssam = fn_GetJobsSam(hFn);
            var hFirstChar = hFn.charAt(0);
            // CAR, GHP, REP는 제외
            if (hJobssam === 'CAR' || hJobssam === 'GHP' || hJobssam === 'B00' || hJobssam === 'B01' || hJobssam === 'B00' ||
           		hJobssam === 'C01' || hJobssam === 'B60' || hJobssam === 'B61' || hJobssam === 'C60' || hJobssam === 'C61' ||
            	hJobssam === 'REP' || hJobssam === 'B00') continue;
            // 빈 파일 제외
            if (!hLineval || hLineval.trim() === '') continue;
            // H010 버전 추출 (파일명이 H010으로 시작)
            if (!jobsver_H010 && hFn.indexOf('H010') === 0) {
                jobsver_H010 = hLineval.substring(0, 3);
                console.log('[데이터점검] H010 버전 확정(' + hFn + '): ' + jobsver_H010);
            }
            // C,M으로 시작하는 파일명 중 가장 작은 파일(이미 정렬됨)에서 버전 추출
            if (!jobsver_CM && (hFirstChar === 'C' || hFirstChar === 'M')) {
                jobsver_CM = hLineval.substring(0, 3);
                console.log('[데이터점검] C/M 가장작은파일(' + hFn + ') 버전 확정: ' + jobsver_CM);
            }
        }

        var fileResults = [];
        var prevFileName = '';

        for (var i = 0; i < firstLines.length; i++) {
            var fl = firstLines[i];
            var fileName = fl.FILE_NM || fl.file_nm;
            var lineval  = fl.LINEVAL || fl.lineval || '';
            var valsize  = parseInt(fl.VALSIZE || fl.valsize || 0);

            // 내용 없는 파일은 무시
            if (!lineval || lineval.trim() === '' || valsize === 0) {
                console.log('[데이터점검] 빈 파일 무시: ' + fileName);
                continue;
            }

            var jobssam = fn_GetJobsSam(fileName);

            if (fileName !== prevFileName) {
                prevFileName = fileName;
            }

            // CAR,GHP,REP → LEFT(lineval,3)
            // K,D,H로 시작하는 파일명 → H010 버전
            // C,M으로 시작하는 파일명 → 가장 작은 C/M 파일 버전
            var version;
            if (jobssam === 'CAR' || jobssam === 'GHP' || jobssam === 'REP' || jobssam === 'B00' || jobssam === 'B01' || jobssam === 'C00' || 
                jobssam === 'C01' || jobssam === 'B60' || jobssam === 'B61' || jobssam === 'C60' || jobssam === 'C61') {
                 version = lineval.substring(0, 3);
            } else if (fileName.charAt(0).toUpperCase() === 'K' || fileName.charAt(0).toUpperCase() === 'D' || fileName.charAt(0).toUpperCase() === 'H') {
                version = (jobsver_H010 !== '') ? jobsver_H010 : lineval.substring(0, 3);
            } else if (fileName.charAt(0).toUpperCase() === 'C' || fileName.charAt(0).toUpperCase() === 'M') {
                version = (jobsver_CM !== '') ? jobsver_CM : lineval.substring(0, 3);
            } else {
                version = lineval.substring(0, 3);
            }

            var fileResult = {
                fileName: fileName,
                lineval: lineval,
                valsize: valsize,
                jobssam: jobssam,
                version: version,
                samver: '',
                tblinfo: '',
                matchVersion: '',
                colsize: 0,
                columns: [],
                parsed: [],
                matched: false
            };

            try {
                // SAMVER 매칭 (samver + version + valsize)
                var matchResp = await $.ajax({
                    url: '/main/getSamfverMatch.do',
                    type: 'POST',
                    contentType: 'application/json',
                    data: JSON.stringify({ samver: jobssam, version: version, valsize: valsize })
                });
                // SP 로직: 첫 매칭 성공 시 jobsver 저장
                if (matchResp.error_code === "0" && matchResp.matchResult && matchResp.matchResult.length > 0 && jobsver === '') {
                    jobsver = matchResp.matchResult[0].VERSION || matchResp.matchResult[0].version || version;
                }

                var matchFound = (matchResp.error_code === "0" && matchResp.matchResult && matchResp.matchResult.length > 0);

                // 정확 매칭 실패 시 valsize 없이 fallback 조회 (samver + version only)
                if (!matchFound) {
                    var fallbackResp = await $.ajax({
                        url: '/main/getSamfverMatch.do',
                        type: 'POST',
                        contentType: 'application/json',
                        data: JSON.stringify({ samver: jobssam, version: version, valsize: 0 })
                    });
                    if (fallbackResp.error_code === "0" && fallbackResp.matchResult && fallbackResp.matchResult.length > 0) {
                        matchResp = fallbackResp;
                        matchFound = true;
                    }
                }

                // 매칭 결과 처리
                if (matchFound) {
                    var fMatch = matchResp.matchResult[0];
                    var fMatchColsize = parseInt(fMatch.COLSIZE || fMatch.colsize || 0);
                    var isExactSize = (fMatchColsize === valsize);

                    fileResult.samver  = fMatch.SAMVER  || fMatch.samver  || '';
                    fileResult.tblinfo = fMatch.TBLINFO || fMatch.tblinfo || '';
                    fileResult.matchVersion = fMatch.VERSION || fMatch.version || '';
                    fileResult.matched = isExactSize;
                    fileResult.colsize = fMatchColsize;

                    // 컬럼 정의 조회
                    var fbColResp2 = await $.ajax({
                        url: '/main/getSamfverColumns.do',
                        type: 'POST',
                        contentType: 'application/json',
                        data: JSON.stringify({
                            samver:  fileResult.samver,
                            tblinfo: fileResult.tblinfo,
                            version: fileResult.matchVersion
                        })
                    });
                    if (fbColResp2.error_code === "0" && fbColResp2.columns) {
                        fileResult.columns = fbColResp2.columns;
                        fileResult.parsed = fn_ParseLine(lineval, fbColResp2.columns);
                    }
                }

                // (매칭 결과 처리는 위에서 통합 수행됨)
            } catch(e) {
                console.error('SAMVER 매칭 오류:', fileName, e);
            }

            fileResults.push(fileResult);
        }

        // 3) samver/version 기준 전체 SAMFVER 테이블 정의 조회
        //    다중 samver 수집 (M-파일: M010, M020 등 각각 다른 samver 가능)
        var allTablesDef = [];
        var detectedSamver = '';
        var detectedVersion = '';
        var samverSet = {};  // 중복 방지용
        var samverList = []; // {samver, version} 배열

        for (var k = 0; k < fileResults.length; k++) {
            var kfr = fileResults[k];
            var kSamver  = kfr.samver  || kfr.jobssam || '';
            var kVersion = kfr.matchVersion || kfr.version || '';
            if (kSamver && kVersion) {
                var svKey = kSamver + '|' + kVersion;
                if (!samverSet[svKey]) {
                    samverSet[svKey] = true;
                    samverList.push({ samver: kSamver, version: kVersion });
                    // 첫번째 매칭된 것을 대표 samver로 설정
                    if (!detectedSamver && kfr.matched) {
                        detectedSamver  = kSamver;
                        detectedVersion = kVersion;
                    }
                }
            }
        }
        // samver/version이 없으면 첫 파일의 jobssam/version 사용
        if (!detectedSamver && fileResults.length > 0) {
            detectedSamver  = fileResults[0].jobssam;
            detectedVersion = fileResults[0].version;
            var svKey0 = detectedSamver + '|' + detectedVersion;
            if (!samverSet[svKey0]) {
                samverSet[svKey0] = true;
                samverList.push({ samver: detectedSamver, version: detectedVersion });
            }
        }

        // 각 samver+version 조합별로 전체 테이블 정의 조회
        var existingTbls = {};
        for (var sv = 0; sv < samverList.length; sv++) {
            try {
                var allTabResp = await $.ajax({
                    url: '/main/getSamfverAllTables.do',
                    type: 'POST',
                    contentType: 'application/json',
                    data: JSON.stringify({ samver: samverList[sv].samver, version: samverList[sv].version })
                });
                if (allTabResp.error_code === "0" && allTabResp.allTables) {
                    for (var ati = 0; ati < allTabResp.allTables.length; ati++) {
                        var atTbl = allTabResp.allTables[ati].TBLINFO || allTabResp.allTables[ati].tblinfo || '';
                        if (!existingTbls[atTbl]) {
                            existingTbls[atTbl] = true;
                            allTablesDef.push(allTabResp.allTables[ati]);
                        }
                    }
                }
            } catch(e) {
                console.error('SAMFVER 전체 테이블 조회 오류(' + samverList[sv].samver + '):', e);
            }
        }

        // 개별 파일별 tblinfo가 allTablesDef에 없는 경우 추가
        for (var kr = 0; kr < fileResults.length; kr++) {
            var krfr = fileResults[kr];
            if (krfr.tblinfo && !existingTbls[krfr.tblinfo] && krfr.colsize > 0) {
                allTablesDef.push({
                    SAMVER:  krfr.samver,
                    TBLINFO: krfr.tblinfo,
                    VERSION: krfr.matchVersion || krfr.version,
                    COLSIZE: krfr.colsize
                });
                existingTbls[krfr.tblinfo] = true;
            }
        }

        console.log('[데이터점검] samver=' + detectedSamver + ', version=' + detectedVersion);
        console.log('[데이터점검] SAMFVER 정의 테이블:', allTablesDef);
        console.log('[데이터점검] 파일 매칭 결과:', fileResults);

        // 4) 모달 렌더링 (SAMFVER 정의 기반) - 검증 결과만 표시
        fn_RenderVerifyModal(fileResults, allTablesDef);
        $('#verifyModal').modal('show');

    } catch(e) {
        signUp = 'N';
        console.error('검증 모달 표시 오류:', e);
        messageBox("4", "<h5>검증 처리 중 오류가 발생했습니다.</h5>", "", "", "");
    }
}

// 라인 파싱 (SP의 col_cursor 로직과 동일)
function fn_ParseLine(lineval, columns) {
    var result = [];
    for (var i = 0; i < columns.length; i++) {
        var col = columns[i];
        var startPos = parseInt(col.START_POS || col.start_pos || 0);
        var endPos   = parseInt(col.END_POS   || col.end_pos   || 0);
        var colSize  = parseInt(col.COL_SIZE  || col.col_size  || 0);
        var parsed = lineval.substring(startPos - 1, startPos - 1 + colSize);
        result.push({
            seq:      col.SEQ       || col.seq       || '',
            itemNm:   col.ITEM_NM   || col.item_nm   || '',
            startPos: startPos,
            endPos:   endPos,
            colSize:  colSize,
            dataType: col.DATA_TYPE || col.data_type || '',
            dbColnm:  col.DB_COLNM  || col.db_colnm  || '',
            parsedVal: parsed
        });
    }
    return result;
}

// 모달 렌더링 (횡 카드 레이아웃) - SAMFVER_MST 정의 기반
function fn_RenderVerifyModal(fileResults, allTablesDef) {
    // SAMFVER_MST 정의에서 테이블명 → 설명 매핑
    var descMap = {
        'TBL_CHUNG_MST': '청구서', 'TBL_MYOUNG_MST': '일반내역', 'TBL_JINORD_MST': '진료내역',
        'TBL_DISEASE_MST': '상병내역', 'TBL_JINOUT_MST': '처방내역', 'TBL_SPECODE_MST': '특정내역'
    };

    var fixedOrder = [
        'TBL_CHUNG_MST' , 'TBL_MYOUNG_MST', 'TBL_DISEASE_MST',
        'TBL_JINORD_MST', 'TBL_JINOUT_MST', 'TBL_SPECODE_MST'
    ];
    // SAMFVER_MST 정의 기반 targetTables 구성 (없으면 기본 6개 사용)
    var targetTables = [];
    if (allTablesDef && allTablesDef.length > 0) {
        for (var d = 0; d < allTablesDef.length; d++) {
            var def = allTablesDef[d];
            var tblName = def.TBLINFO || def.tblinfo || '';
            var shortName = tblName.replace('TBL_', '').replace('_MST', '');
            var defColsize = parseInt(def.COLSIZE || def.colsize || 0);
            targetTables.push({
                tbl: tblName, name: shortName,
                desc: descMap[tblName] || shortName,
                expectedColsize: defColsize
            });
        }
    } else {
        // fallback: 기본 6개 테이블
        var defaultTbls = [
            { tbl: 'TBL_CHUNG_MST', name: '청구서', desc: '청구서' },
            { tbl: 'TBL_MYOUNG_MST', name: '일반내역', desc: '일반내역' },
            { tbl: 'TBL_DISEASE_MST', name: '상병내역', desc: '상병내역' },
            { tbl: 'TBL_JINORD_MST', name: '진료내역', desc: '진료내역' },
            { tbl: 'TBL_JINOUT_MST', name: '처방내역', desc: '처방내역' },
            { tbl: 'TBL_SPECODE_MST', name: '처방내역', desc: '처방내역' }
        ];
        for (var dd = 0; dd < defaultTbls.length; dd++) {
            defaultTbls[dd].expectedColsize = 0;
            targetTables.push(defaultTbls[dd]);
        }
    }

    // fixedOrder 기준으로 targetTables 정렬
    targetTables.sort(function(a, b) {
        var idxA = fixedOrder.indexOf(a.tbl);
        var idxB = fixedOrder.indexOf(b.tbl);
        if (idxA === -1) idxA = fixedOrder.length;
        if (idxB === -1) idxB = fixedOrder.length;
        return idxA - idxB;
    });

    // 파일 결과를 tblinfo 기준으로 매핑
    var tableMap = {};
    var unmapped = [];
    for (var i = 0; i < fileResults.length; i++) {
        var fr = fileResults[i];
        if (fr.tblinfo && targetTables.some(function(t) { return t.tbl === fr.tblinfo; })) {
            tableMap[fr.tblinfo] = fr;
        } else {
            unmapped.push(fr);
        }
    }

    // 매핑되지 않은 파일을 SAMFVER 정의의 colsize 기준으로 가장 가까운 테이블에 추론 매칭
    if (unmapped.length > 0 && targetTables.length > 0) {
        // colsize 기준 내림차순 정렬 (가장 큰 것부터 매칭)
        var sortedUnmapped = unmapped.slice().sort(function(a, b) { return b.valsize - a.valsize; });
        var sortedTargets = targetTables.slice().filter(function(t) { return !tableMap[t.tbl]; })
            .sort(function(a, b) { return b.expectedColsize - a.expectedColsize; });

        for (var si = 0; si < sortedTargets.length && si < sortedUnmapped.length; si++) {
            var uf = sortedUnmapped[si];
            var tgt = sortedTargets[si];
            tableMap[tgt.tbl] = uf;
            uf._inferredTable = tgt.tbl;
            uf._expectedColsize = tgt.expectedColsize;
        }
        // unmapped 목록에서 추론 매칭된 항목 제거
        unmapped = unmapped.filter(function(uf) { return !uf._inferredTable; });

        // 남은 unmapped 파일을 가장 가까운 기존 카드에 오류 정보로 붙임
        for (var ui = 0; ui < unmapped.length; ui++) {
            var umf = unmapped[ui];
            var closestTbl = null;
            var closestDiff = Infinity;
            for (var ct = 0; ct < targetTables.length; ct++) {
                var expCol = targetTables[ct].expectedColsize || 0;
                if (expCol > 0) {
                    var diff = Math.abs(umf.valsize - expCol);
                    if (diff < closestDiff) {
                        closestDiff = diff;
                        closestTbl = targetTables[ct].tbl;
                    }
                }
            }
            if (closestTbl) {
                if (!tableMap[closestTbl]) tableMap[closestTbl] = {};
                if (!tableMap[closestTbl]._extraErrors) tableMap[closestTbl]._extraErrors = [];
                tableMap[closestTbl]._extraErrors.push({ valsize: umf.valsize, fileName: umf.fileName });
            }
        }
        unmapped = [];
    }

    // 요약 정보
    var totalDef = targetTables.length;
    var matchedCount = 0;
    var lengthErrorCount = 0;
    for (var m = 0; m < targetTables.length; m++) {
        var mfr = tableMap[targetTables[m].tbl];
        if (mfr && mfr.matched) {
            matchedCount++;
        } else if (mfr && mfr._inferredTable) {
            // 추론 매칭: 길이 일치 여부 확인
            if (mfr.valsize === mfr._expectedColsize) {
                matchedCount++;
            } else {
                lengthErrorCount++;
            }
        } else if (mfr && mfr.tblinfo && mfr.colsize > 0) {
            // fallback 매칭: tblinfo/colsize는 있지만 길이 불일치
            lengthErrorCount++;
        }
    }
    var unmatchedCount = totalDef - matchedCount - lengthErrorCount;

    // 요약 바 (SAMFVER 정의 기반)
    var detSamver = (allTablesDef && allTablesDef.length > 0) ? (allTablesDef[0].SAMVER || allTablesDef[0].samver || '') : '';
    var detVersion = (allTablesDef && allTablesDef.length > 0) ? (allTablesDef[0].VERSION || allTablesDef[0].version || '') : '';
    var summaryHtml = '<div class="col-12 mb-3">' +
        '<div class="d-flex align-items-center justify-content-between px-3 py-2" ' +
        'style="background:linear-gradient(135deg,#f5f7fa,#c3cfe2); border-radius:10px;">' +
        '<div><i class="fa fa-database mr-2" style="color:#1e3c72;"></i>' +
        '<strong style="color:#1e3c72;">파일 검증 결과</strong>' +
        (detSamver ? ' <span class="badge badge-dark ml-2" style="font-size:11px;">' + detSamver + '</span>' : '') +
        (detVersion ? ' <span class="badge badge-info ml-1" style="font-size:11px;">v' + detVersion + '</span>' : '') +
        '</div>' +
        '<div class="d-flex" style="gap:20px;">' +
        '<span style="font-size:13px;"><i class="fa fa-th mr-1" style="color:#555;"></i>정의 <strong>' + totalDef + '</strong></span>' +
        '<span style="font-size:13px;"><i class="fa fa-check-circle mr-1" style="color:#4caf50;"></i>정상 <strong style="color:#4caf50;">' + matchedCount + '</strong></span>' +
        (lengthErrorCount > 0 ? '<span style="font-size:13px;"><i class="fa fa-exclamation-triangle mr-1" style="color:#f44336;"></i>길이오류 <strong style="color:#f44336;">' + lengthErrorCount + '</strong></span>' : '') +
        '<span style="font-size:13px;"><i class="fa fa-minus-circle mr-1" style="color:#ff9800;"></i>미매칭 <strong style="color:#ff9800;">' + unmatchedCount + '</strong></span>' +
        '</div></div></div>';

    // 횡 카드 생성
    var cardsHtml = '<div class="col-12"><div class="d-flex flex-wrap justify-content-center" style="gap:14px;">';

    for (var t = 0; t < targetTables.length; t++) {
        var info = targetTables[t];
        var fr = tableMap[info.tbl];

        // 카드에 추가 오류가 있는지 확인
        var extraErrs = fr && fr._extraErrors ? fr._extraErrors : [];
        var hasExtra = extraErrs.length > 0;

        if (fr && fr.matched) {
            // 성공 카드 (추가오류 있으면 실패 표시)
            var borderColor = hasExtra ? '#f44336' : '#4caf50';
            var shadowColor = hasExtra ? 'rgba(244,67,54,.15)' : 'rgba(76,175,80,.15)';
            cardsHtml += '<div class="verify-card" data-tbl="' + info.tbl + '" ' +
                'style="width:155px; border:2px solid ' + borderColor + '; border-radius:12px; background:#fff; cursor:pointer; transition:all .2s; box-shadow:0 2px 8px ' + shadowColor + ';">' +
                '<div class="text-center p-3">' +
                '<div style="font-size:22px; line-height:1;">' + (hasExtra ? '\u274C' : '\u2705') + '</div>' +
                '<div style="font-size:11px; color:' + borderColor + '; font-weight:700; margin:4px 0;">' + (hasExtra ? '실패' : '성공') + '</div>' +
                '<div style="font-size:15px; font-weight:800; color:' + (hasExtra ? '#b71c1c' : '#1b5e20') + '; letter-spacing:.5px;">' + info.name + '</div>' +
                '<div style="font-size:10px; color:#888; margin-bottom:4px;">' + info.desc + '</div>' +
                '<div style="font-size:10px; color:#555; margin-bottom:4px;"><span class="badge badge-secondary" style="font-size:9px;">' + fr.samver + '</span> <span class="badge badge-outline-dark" style="font-size:9px; border:1px solid #aaa;">v' + fr.matchVersion + '</span></div>' +
                '<div style="font-size:11px; color:#333;">원: <strong style="color:#1565c0;">' + fr.colsize + '</strong></div>' +
                '<div style="font-size:11px; color:#333;">실: <strong style="color:#2e7d32;">' + fr.valsize + '</strong></div>';
            for (var ei = 0; ei < extraErrs.length; ei++) {
                cardsHtml += '<div style="font-size:12px; color:#f44336; margin-top:3px; font-weight:700;">실: <strong style="font-size:13px;">' + extraErrs[ei].valsize + '</strong> <span style="font-size:9px;">오류</span></div>';
            }
            cardsHtml += '<div style="font-size:9px; color:#aaa; margin-top:5px; white-space:nowrap; overflow:hidden; text-overflow:ellipsis;" title="' + fr.fileName + '">' + fr.fileName + '</div>' +
                '</div></div>';
        } else if (fr) {
            // 추론 매칭 또는 실패 카드
            var inferExpected = fr._expectedColsize || info.expectedColsize || fr.colsize || 0;
            var isLengthOk = (inferExpected > 0 && fr.valsize === inferExpected && !hasExtra);

            if (isLengthOk) {
                // 길이 일치 - 정상 카드 (초록)
                cardsHtml += '<div class="verify-card" data-tbl="' + info.tbl + '" ' +
                    'style="width:155px; border:2px solid #4caf50; border-radius:12px; background:#fff; cursor:pointer; transition:all .2s; box-shadow:0 2px 8px rgba(76,175,80,.15);">' +
                    '<div class="text-center p-3">' +
                    '<div style="font-size:22px; line-height:1;">\u2705</div>' +
                    '<div style="font-size:11px; color:#4caf50; font-weight:700; margin:4px 0;">정상</div>' +
                    '<div style="font-size:15px; font-weight:800; color:#1b5e20; letter-spacing:.5px;">' + info.name + '</div>' +
                    '<div style="font-size:10px; color:#888; margin-bottom:4px;">' + info.desc + '</div>' +
                    '<div style="font-size:10px; color:#555; margin-bottom:4px;"><span class="badge badge-secondary" style="font-size:9px;">' + (fr.jobssam || '-') + '</span> <span class="badge badge-outline-dark" style="font-size:9px; border:1px solid #aaa;">v' + (fr.version || '-') + '</span></div>' +
                    '<div style="font-size:11px; color:#333;">원: <strong style="color:#1565c0;">' + inferExpected + '</strong></div>' +
                    '<div style="font-size:11px; color:#333;">실: <strong style="color:#2e7d32;">' + fr.valsize + '</strong></div>' +
                    '<div style="font-size:9px; color:#aaa; margin-top:5px; white-space:nowrap; overflow:hidden; text-overflow:ellipsis;" title="' + fr.fileName + '">' + fr.fileName + '</div>' +
                    '</div></div>';
            } else {
                // 길이 불일치 또는 미정의 - 오류 카드 (빨강)
                var errLabel = (inferExpected > 0) ? '길이오류' : '실패';
                cardsHtml += '<div class="verify-card" data-tbl="' + info.tbl + '" ' +
                    'style="width:155px; border:2px solid #f44336; border-radius:12px; background:#fff; cursor:pointer; transition:all .2s; box-shadow:0 2px 8px rgba(244,67,54,.15);">' +
                    '<div class="text-center p-3">' +
                    '<div style="font-size:22px; line-height:1;">\u274C</div>' +
                    '<div style="font-size:11px; color:#f44336; font-weight:700; margin:4px 0;">' + errLabel + '</div>' +
                    '<div style="font-size:15px; font-weight:800; color:#b71c1c; letter-spacing:.5px;">' + info.name + '</div>' +
                    '<div style="font-size:10px; color:#888; margin-bottom:4px;">' + info.desc + '</div>' +
                    '<div style="font-size:10px; color:#555; margin-bottom:4px;"><span class="badge badge-secondary" style="font-size:9px;">' + (fr.jobssam || '-') + '</span> <span class="badge badge-outline-dark" style="font-size:9px; border:1px solid #aaa;">v' + (fr.version || '-') + '</span></div>' +
                    '<div style="font-size:11px; color:#333;">원: <strong style="color:#1565c0;">' + (inferExpected || '-') + '</strong></div>' +
                    '<div style="font-size:13px; color:#333;">실: <strong style="color:#f44336; font-size:14px;">' + fr.valsize + '</strong></div>';
                for (var ei2 = 0; ei2 < extraErrs.length; ei2++) {
                    cardsHtml += '<div style="font-size:12px; color:#f44336; margin-top:3px; font-weight:700;">실: <strong style="font-size:13px;">' + extraErrs[ei2].valsize + '</strong> <span style="font-size:9px;">오류</span></div>';
                }
                cardsHtml += '<div style="font-size:9px; color:#aaa; margin-top:5px; white-space:nowrap; overflow:hidden; text-overflow:ellipsis;" title="' + fr.fileName + '">' + fr.fileName + '</div>' +
                    '</div></div>';
            }
        } else {
            // 데이터 없음 카드 (SAMFVER 기대 colsize 표시)
            cardsHtml += '<div style="width:155px; border:2px dashed #ddd; border-radius:12px; background:#fafafa;">' +
                '<div class="text-center p-3">' +
                '<div style="font-size:22px; line-height:1; color:#ccc;">\u2796</div>' +
                '<div style="font-size:11px; color:#bbb; font-weight:700; margin:4px 0;">데이터없음</div>' +
                '<div style="font-size:15px; font-weight:800; color:#999; letter-spacing:.5px;">' + info.name + '</div>' +
                '<div style="font-size:10px; color:#aaa; margin-bottom:4px;">' + info.desc + '</div>' +
                (info.expectedColsize ? '<div style="font-size:11px; color:#999;">기대: <strong style="color:#1565c0;">' + info.expectedColsize + '</strong></div>' : '') +
                '</div></div>';
        }
    }

    cardsHtml += '</div></div>';

    // 상세 영역 (카드 클릭 시 표시)
    var detailHtml = '<div class="col-12 mt-3" id="verifyDetailArea" style="display:none;">' +
        '<div class="card border-0" style="box-shadow:0 2px 12px rgba(0,0,0,.08); border-radius:10px;">' +
        '<div class="card-header py-2 px-3" style="background:#f8f9fa; border-radius:10px 10px 0 0;">' +
        '<span id="verifyDetailTitle" style="font-weight:600; font-size:13px;"></span>' +
        '<button type="button" class="close" id="closeVerifyDetail" style="font-size:16px;"><span>&times;</span></button>' +
        '</div>' +
        '<div class="card-body p-0" id="verifyDetailBody" style="max-height:300px; overflow-y:auto;"></div>' +
        '</div></div>';

    $('#verifySummaryRow').html(summaryHtml + cardsHtml + detailHtml);
    $('#verifyFileTabs').html('');
    $('#verifyFileTabContent').html('');

    // 카드 hover 효과
    $('.verify-card').hover(
        function() { $(this).css({'transform':'translateY(-3px)','box-shadow':'0 6px 20px rgba(0,0,0,.15)'}); },
        function() { $(this).css({'transform':'translateY(0)','box-shadow':''}); }
    );

    // 카드 클릭 시 상세 파싱 결과 표시
    window._verifyFileResults = fileResults;
    window._verifyAllTablesDef = allTablesDef;
    window._verifyTargetTables = targetTables;
    window._verifyTableMap = tableMap;

    $('.verify-card').off('click').on('click', function() {
        var tbl = $(this).attr('data-tbl');
        if (!tbl) return;
        var fr = window._verifyTableMap[tbl];
        if (!fr) return;

        var titleText = fr.tblinfo ? (fr.tblinfo + ' - ' + fr.fileName) : fr.fileName;
        var hasExtraErrs = fr._extraErrors && fr._extraErrors.length > 0;
        var isFailed = !fr.matched || hasExtraErrs;

        // 실패 카드인데 parsed가 없으면 해당 테이블 컬럼 정의로 파싱 시도
        var parsedData = (fr.parsed && fr.parsed.length > 0) ? fr.parsed : [];
        var usedColumns = fr.columns || [];
        if (parsedData.length === 0 && fr.lineval) {
            // 카드의 tbl에 해당하는 테이블 정의 우선 찾기
            var closestDef = null;
            var allDefs = window._verifyAllTablesDef || [];
            for (var cd = 0; cd < allDefs.length; cd++) {
                var defTbl = allDefs[cd].TBLINFO || allDefs[cd].tblinfo || '';
                if (defTbl === tbl) {
                    closestDef = allDefs[cd];
                    break;
                }
            }
            // 못 찾으면 fr.tblinfo로 재시도
            if (!closestDef && fr.tblinfo && fr.tblinfo !== tbl) {
                for (var cd2 = 0; cd2 < allDefs.length; cd2++) {
                    var defTbl2 = allDefs[cd2].TBLINFO || allDefs[cd2].tblinfo || '';
                    if (defTbl2 === fr.tblinfo) {
                        closestDef = allDefs[cd2];
                        break;
                    }
                }
            }
            // 그래도 못 찾으면 가장 가까운 colsize로 fallback
            if (!closestDef) {
                var closestDiff = Infinity;
                for (var cd3 = 0; cd3 < allDefs.length; cd3++) {
                    var defCol = parseInt(allDefs[cd3].COLSIZE || allDefs[cd3].colsize || 0);
                    var diff = Math.abs(fr.valsize - defCol);
                    if (diff < closestDiff) {
                        closestDiff = diff;
                        closestDef = allDefs[cd3];
                    }
                }
            }
            if (closestDef) {
                // 해당 테이블의 컬럼 정의 조회 (동기)
                try {
                    var colResp = $.ajax({
                        url: '/main/getSamfverColumns.do', type: 'POST', async: false,
                        contentType: 'application/json',
                        data: JSON.stringify({
                            samver:  closestDef.SAMVER  || closestDef.samver  || '',
                            tblinfo: closestDef.TBLINFO || closestDef.tblinfo || '',
                            version: closestDef.VERSION || closestDef.version || ''
                        })
                    }).responseJSON;
                    if (colResp && colResp.error_code === "0" && colResp.columns) {
                        usedColumns = colResp.columns;
                        parsedData = fn_ParseLine(fr.lineval, colResp.columns);
                    }
                } catch(e) { console.error('컬럼 조회 오류:', e); }
            }
        }

        $('#verifyDetailTitle').html('<i class="fa fa-table mr-2" style="color:' + (isFailed ? '#f44336' : '#1e3c72') + ';"></i>' + titleText +
            (isFailed ? ' <span class="badge badge-danger ml-2" style="font-size:10px;">오류</span>' : ''));
        $('#verifyDetailArea').slideDown(200);

        if (parsedData.length > 0) {
            var lineLen = fr.lineval ? fn_CalcValsize(fr.lineval) : fr.valsize;
            var expectedLen = fr.colsize || (usedColumns.length > 0 ? parseInt(usedColumns[usedColumns.length - 1].END_POS || usedColumns[usedColumns.length - 1].end_pos || 0) : 0);
            var lenDiff = lineLen - expectedLen;

            // 요약 정보
            var summaryInfo = '<div class="px-3 py-2" style="background:' + (isFailed ? '#ffebee' : '#e8f5e9') + '; font-size:12px;">' +
                '<strong>원길이:</strong> <span style="color:#1565c0;">' + expectedLen + '</span>' +
                ' &nbsp; <strong>실길이:</strong> <span style="color:' + (lenDiff !== 0 ? '#f44336' : '#2e7d32') + ';">' + lineLen + '</span>';
            if (lenDiff !== 0) {
                summaryInfo += ' &nbsp; <strong style="color:#f44336;">차이: ' + (lenDiff > 0 ? '+' : '') + lenDiff + '</strong>';
            }
            if (hasExtraErrs) {
                summaryInfo += ' &nbsp; | &nbsp; <strong style="color:#f44336;">미정의 데이터:</strong>';
                for (var xe = 0; xe < fr._extraErrors.length; xe++) {
                    summaryInfo += ' <span class="badge badge-danger" style="font-size:10px;">실:' + fr._extraErrors[xe].valsize + '</span>';
                }
            }
            summaryInfo += '</div>';

            var tbl = summaryInfo + '<table class="table table-sm table-bordered mb-0" style="font-size:11px;">' +
                '<thead style="background:#1e3c72; color:#fff; position:sticky; top:0;">' +
                '<tr><th style="width:35px; text-align:center;">#</th>' +
                '<th>항목명</th>' +
                '<th style="width:50px; text-align:center;">시작</th>' +
                '<th style="width:50px; text-align:center;">종료</th>' +
                '<th style="width:45px; text-align:center;">크기</th>' +
                '<th style="width:55px; text-align:center;">타입</th>' +
                '<th>파싱값</th>' +
                '<th>DB컬럼</th>' +
                '<th style="width:45px; text-align:center;">상태</th></tr></thead><tbody>';

            var linevalLen = fr.lineval ? fr.lineval.length : 0;
            for (var j = 0; j < parsedData.length; j++) {
                var p = parsedData[j];
                var isEmpty = !p.parsedVal || p.parsedVal.trim() === '';
                var startIdx = p.startPos - 1;
                var endIdx = startIdx + p.colSize;

                // 오류 판정: 데이터가 부족하거나 넘치는 경우
                var isOverflow = (startIdx >= linevalLen);          // 원자료보다 정의가 넘음
                var isPartial  = (!isOverflow && endIdx > linevalLen); // 일부만 있음
                var isNormal   = (!isOverflow && !isPartial);

                var rowBg = '';
                var statusIcon = '';
                if (isOverflow) {
                    rowBg = 'background:#ffcdd2;';  // 빨강 - 데이터 없음(초과)
                    statusIcon = '<span style="color:#f44336; font-weight:700;">초과</span>';
                } else if (isPartial) {
                    rowBg = 'background:#fff9c4;';  // 노랑 - 데이터 부분
                    statusIcon = '<span style="color:#ff9800; font-weight:700;">부분</span>';
                } else if (isEmpty) {
                    rowBg = 'background:#fff3e0;';
                    statusIcon = '<span style="color:#888;">빈값</span>';
                } else {
                    statusIcon = '<span style="color:#4caf50;">정상</span>';
                }

                tbl += '<tr style="' + rowBg + '">' +
                    '<td style="text-align:center; color:#888;">' + p.seq + '</td>' +
                    '<td style="font-weight:500;">' + p.itemNm + '</td>' +
                    '<td style="text-align:center;">' + p.startPos + '</td>' +
                    '<td style="text-align:center;">' + p.endPos + '</td>' +
                    '<td style="text-align:center;">' + p.colSize + '</td>' +
                    '<td style="text-align:center;"><span class="badge ' +
                    (p.dataType === 'VARCHAR' ? 'badge-info' : 'badge-warning') + '" style="font-size:10px;">' + p.dataType + '</span></td>' +
                    '<td style="font-family:monospace; font-size:10px; background:' + (isOverflow ? '#ffcdd2' : isPartial ? '#fff9c4' : '#f5f5f5') + '; word-break:break-all;">' +
                    (isOverflow ? '<span style="color:#f44336;">데이터없음</span>' :
                     isPartial ? '<span style="color:#ff9800;">' + (p.parsedVal || '') + '</span><span style="color:#f44336;">|끊김</span>' :
                     (p.parsedVal || '<span style="color:#ccc;">empty</span>')) + '</td>' +
                    '<td style="color:#1565c0; font-size:10px;">' + p.dbColnm + '</td>' +
                    '<td style="text-align:center; font-size:10px;">' + statusIcon + '</td></tr>';
            }

            // 원자료가 정의보다 긴 경우 남은 데이터 표시
            if (linevalLen > 0 && usedColumns.length > 0) {
                var lastEnd = parseInt(usedColumns[usedColumns.length - 1].END_POS || usedColumns[usedColumns.length - 1].end_pos || 0);
                if (linevalLen > lastEnd) {
                    var extraData = fr.lineval.substring(lastEnd);
                    tbl += '<tr style="background:#ffcdd2;">' +
                        '<td style="text-align:center; color:#f44336; font-weight:700;" colspan="2">초과 데이터</td>' +
                        '<td style="text-align:center;">' + (lastEnd + 1) + '</td>' +
                        '<td style="text-align:center;">' + linevalLen + '</td>' +
                        '<td style="text-align:center; color:#f44336; font-weight:700;">' + (linevalLen - lastEnd) + '</td>' +
                        '<td style="text-align:center;">-</td>' +
                        '<td style="font-family:monospace; font-size:10px; background:#ffcdd2; word-break:break-all; color:#f44336;">' + extraData + '</td>' +
                        '<td>-</td>' +
                        '<td style="text-align:center;"><span style="color:#f44336; font-weight:700;">초과</span></td></tr>';
                }
            }

            tbl += '</tbody></table>';
            $('#verifyDetailBody').html(tbl);
        } else {
            $('#verifyDetailBody').html('<div class="p-3 text-center text-muted">' +
                '<i class="fa fa-info-circle mr-1"></i>' +
                'SAMVER: ' + fr.jobssam + ' | 버전: ' + fr.version + ' | 라인길이: ' + fr.valsize +
                '<br><small>TBL_SAMFVER_MST에서 매칭 정의를 찾을 수 없습니다.</small></div>');
        }

        // 선택된 카드 하이라이트
        $('.verify-card').css('outline', 'none');
        $(this).css('outline', '3px solid #1e3c72');
    });

    // 상세 닫기
    $('#closeVerifyDetail').off('click').on('click', function() {
        $('#verifyDetailArea').slideUp(200);
        $('.verify-card').css('outline', 'none');
    });

    // 하나라도 오류가 있으면 true (미매칭, 길이오류, 추가오류 모두 포함)
    var hasExtraErr = false;
    for (var chk = 0; chk < targetTables.length; chk++) {
        var chkFr = tableMap[targetTables[chk].tbl];
        if (chkFr && chkFr._extraErrors && chkFr._extraErrors.length > 0) { hasExtraErr = true; break; }
    }
    return (unmatchedCount > 0 || lengthErrorCount > 0 || hasExtraErr);
}

// 취소 버튼 클릭 → 모달 닫기
$('#btnVerifyClose').on('click', function() {
    $('#verifyModal').modal('hide');
});

// X 버튼 클릭 → 모달 닫기
$('#btnVerifyX').on('click', function() {
    $('#verifyModal').modal('hide');
});

// 검증 모달 닫을 때 이전 데이터 완전 초기화
$('#verifyModal').on('hidden.bs.modal', function() {
    signUp = 'N';
    window._verifyMagamData = null;
    window._verifyFileResults = null;
    window._verifyAllTablesDef = null;
    window._verifyTargetTables = null;
    window._verifyTableMap = null;
    $('#verifySummaryRow').html('');
    $('#verifyFileTabs').html('');
    $('#verifyFileTabContent').html('');
    $('#verifyDetailArea').hide();
});

</script>

<!-- ============================================================== -->
<!-- [추가] 청구파일 선택 모달 — 폴더선택 후 각 파일 첫줄을 읽어(fn_ParseLine 재사용) 종류·서식버전·청구번호·청구건수 표시. -->
<!--        체크한 File 을 window.gPickedFiles 에 담아, 월 카드(fileLoad_Open)가 기존 handleFileSelection 으로 그대로 업로드. -->
<!-- ============================================================== -->
<script type="text/javascript">
(function(){
    var _files = [];        // 매칭된 File 목록 (data-idx 참조)
    var _colCache = {};     // samver|tblinfo|version -> columns 캐시
    var _meta = {};         // idx -> {version, claimNo, caseCnt, insur, treat} 파싱결과 캐시(기간 필터 재렌더 시 재파싱 방지)
    var _codeMap = {};      // INSUR_TYPE/TREAT_TYPE/TREAT_SAN_TYPE -> {code:name} (commList.do)
    var _dirHandle = null;  // showDirectoryPicker 폴더 핸들 — 유지해두면 [새로고침] 시 다이얼로그 없이 재스캔

    // 업로드 성공한 파일 서명(이름|크기|수정시각)을 localStorage 에 기억 → 재로그인 후에도 목록에서 숨김
    function upKey(){ return 'samPickUploaded_' + (typeof hospid!=='undefined'?hospid:''); }
    function loadSigs(){ try{ return JSON.parse(localStorage.getItem(upKey())||'{}'); }catch(e){ return {}; } }
    function saveSigs(o){ try{ var ks=Object.keys(o); if(ks.length>1000){ ks.slice(0,ks.length-1000).forEach(function(k){ delete o[k]; }); } localStorage.setItem(upKey(), JSON.stringify(o)); }catch(e){} }
    var _upSigs = loadSigs();
    function fileSig(f){ return f.name+'|'+f.size+'|'+f.lastModified; }
    function isUploaded(f){ return !!_upSigs[fileSig(f)]; }
    function showUploaded(){ var c=document.getElementById('samPickShowUp'); return c && c.checked; }

    // 공통코드(종별구분·진료형태) 로드 — 건강보험/의료급여, 입원/외래 라벨 디코드용
    function fetchCodes(){
        return $.ajax({ type:'POST', url:'/base/commList.do', dataType:'json',
                 data:{ listGb:['Z'], listCd:['INSUR_TYPE','TREAT_TYPE','TREAT_SAN_TYPE','CLAIM_TYPE'] } })
            .done(function(res){
                var list=(res && res.data)||[]; _codeMap={};
                list.forEach(function(it){ var cd=it.codeCd, sc=it.subCode; (_codeMap[cd]=_codeMap[cd]||{})[sc]=it.subCodeNm; });
            }).fail(function(){});
    }
    // 보험구분: 자보(CAR)/산재(M)/자보한방(C) 는 파일명, 그 외는 INSUR_TYPE 코드 디코드(건강보험/의료급여)
    function calcInsur(jobssam, fileName, insurCode){
        if(jobssam==='CAR') return '자보';
        var up=fileName.toUpperCase();
        if(up.charAt(0)==='M') return '산재';
        if(up.charAt(0)==='C' && jobssam!=='REP') return '자보';   // C010~ 자보한방 (CXX=REP 제외)
        return (_codeMap['INSUR_TYPE']||{})[insurCode] || '';
    }
    // 입원/외래: TREAT_TYPE(산재는 TREAT_SAN_TYPE) 디코드 후 입원/외래 판별
    function calcTreat(fileName, treatCode){
        var grp=(fileName.toUpperCase().charAt(0)==='M')?'TREAT_SAN_TYPE':'TREAT_TYPE';
        var nm=(_codeMap[grp]||{})[treatCode]||'';
        if(!nm) return '';
        if(nm.indexOf('입원')>=0) return '입원';
        if(nm.indexOf('외래')>=0) return '외래';
        return nm;
    }
    // 청구구분: 정상(원)/보완/누락 — CLAIM_TYPE 코드 디코드
    function calcClaimType(claimTypeCode){
        var nm=(_codeMap['CLAIM_TYPE']||{})[claimTypeCode];
        return nm || (claimTypeCode||'');
    }
    // 다중파일 청구세트 키(폴더 내 하위그룹) — M/C/K/D/H 계열은 앞글자로 묶고, GHP/CAR/REP 단건은 '' (묶음 안함)
    function setKey(fileName){
        var js=(typeof fn_GetJobsSam==='function')?fn_GetJobsSam(fileName):fileName.toUpperCase();
        if(js==='GHP'||js==='CAR'||js==='REP') return '';
        var c=fileName.toUpperCase().charAt(0);
        return ('MCKDH'.indexOf(c)>=0) ? c : '';
    }
    function setLabel(k){
        return {M:'산재 청구', C:'자보한방', K:'한방', D:'질병군', H:'요양/의료급여'}[k] || (k+' 세트');
    }

    function periodActive(){ var c=document.getElementById('samPickPeriodChk'); return c && c.checked; }
    function folderDate(dir){ var m=/(\d{4}-\d{2}-\d{2})/.exec(dir||''); return m?m[1]:''; }
    function inPeriod(dir, file){
        if(!periodActive()) return true;
        var from=(document.getElementById('samPickFrom')||{}).value||'';
        var to  =(document.getElementById('samPickTo')||{}).value||'';
        var d=folderDate(dir);
        if(!d){ try{ d=new Date(file.lastModified).toISOString().slice(0,10); }catch(e){ return true; } }
        if(from && d<from) return false;
        if(to   && d>to)   return false;
        return true;
    }

    function fmtSize(b){ if(b<1024) return b+' B'; var k=b/1024; if(k<1024) return k.toFixed(1)+' KB'; return (k/1024).toFixed(1)+' MB'; }
    function esc(s){ return (s==null?'':String(s)).replace(/[&<>"]/g, function(c){ return {'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;'}[c]; }); }

    // handleFileSelection 필터와 동일 (allowedFiles: '*.ext' / 'name.*' / 정확일치)
    function matchAllowed(name){
        if(!window.allowedFiles || !allowedFiles.length) return true;
        var n = name.toLowerCase();
        return allowedFiles.some(function(p){
            if(p.indexOf('*.')===0)     return n.slice(-(p.length-2)) === p.slice(2).toLowerCase();
            else if(p.slice(-2)==='.*') return n.indexOf(p.slice(0,-2).toLowerCase())===0;
            else                        return name === p;
        });
    }
    function relDir(f){ if(f._relPath) return f._relPath; var rp=f.webkitRelativePath||f.name; var i=rp.lastIndexOf('/'); return i>=0?rp.substring(0,i):'(루트)'; }
    // 일자시간 폴더명 보기 좋게: yyyy-MM-dd_HHmmss → yyyy-MM-dd HH:mm:ss
    function prettyDir(d){ return (d||'').replace(/(\d{4}-\d{2}-\d{2})_(\d{2})(\d{2})(\d{2})/, '$1 $2:$3:$4'); }
    function typeLabel(name){
        var js = (typeof fn_GetJobsSam==='function') ? fn_GetJobsSam(name) : name.toUpperCase();
        var up = name.toUpperCase(), ext = name.split('.').pop().toUpperCase();
        if(js==='CAR') return '자보 청구·명세(CAR)';
        if(js==='GHP') return '요양/신포괄(GHP)';
        if(js==='REP') return '요양급여(REP)';
        if(up.indexOf('H010')===0) return '심사청구서(H010)';
        if(up.indexOf('H040')===0) return '의료급여정액(H040)';
        if(up.indexOf('K020')===0) return '한방명세(K020)';
        if(up.indexOf('D020')===0) return '질병군(D020)';
        if(up.charAt(0)==='M') return '산재 청구·명세';
        if(up.charAt(0)==='C') return '자보한방(C)';
        return ext;
    }
    function readHead(file){   // 파일 앞부분(청구서 첫줄 + 명세서 몇 줄) 라인 배열
        return new Promise(function(resolve){
            var r=new FileReader();
            r.onload=function(e){ resolve((e.target.result||'').split(/\r?\n/)); };
            r.onerror=function(){ resolve([]); };
            try { r.readAsText(file.slice(0, 262144), 'euc-kr'); } catch(x){ resolve([]); }
        });
    }
    // 청구구분: 명세서 CLAIM_GRP → 1 보완/2 추가/3 분리/그외 원청구
    function claimGrpLabel(g){
        g=(g||'').trim();
        if(g==='1') return '보완청구';
        if(g==='2') return '추가청구';
        if(g==='3') return '분리청구';
        return '원청구';
    }
    function post(url, obj){ return $.ajax({ url:url, type:'POST', contentType:'application/json', data:JSON.stringify(obj) }); }
    function pick(parsed, col){
        if(!parsed) return '';
        for(var i=0;i<parsed.length;i++){ if((parsed[i].dbColnm||'').toUpperCase()===col) return (parsed[i].parsedVal||'').trim(); }
        return '';
    }
    function applyMeta(idx){
        var meta=_meta[idx];
        function set(id, v){ var el=document.getElementById(id); if(el) el.textContent = meta ? (v||'-') : '…'; }
        set('spk_insur_'+idx, meta&&meta.insur);
        set('spk_treat_'+idx, meta&&meta.treat);
        set('spk_type_'+idx,  meta&&meta.claimType);
        set('spk_ver_'+idx,   meta&&meta.version);
        set('spk_claim_'+idx, meta&&meta.claimNo);
        set('spk_dateym_'+idx, meta&&meta.dateYm);
        set('spk_cnt_'+idx,   meta&&meta.caseCnt);
        set('spk_tot_'+idx,   meta&&meta.totAmt);
    }
    async function parseOne(idx){
        var file=_files[idx];
        var meta={version:'', claimNo:'', caseCnt:'', insur:'', treat:'', claimType:'', dateYm:'', totAmt:''};
        try{
            var lines=await readHead(file);
            var line=lines[0]||'';
            if(line){
                var jobssam=(typeof fn_GetJobsSam==='function')?fn_GetJobsSam(file.name):file.name.toUpperCase();
                meta.version=line.substring(0,3);
                meta.insur=calcInsur(jobssam, file.name, '');   // 자보/산재는 파일명으로 우선
                var valsize=(typeof fn_CalcValsize==='function')?fn_CalcValsize(line):0;
                var m=await post('/main/getSamfverMatch.do',{samver:jobssam, version:meta.version, valsize:valsize});
                if(!(m && m.error_code==='0' && m.matchResult && m.matchResult.length)){
                    m=await post('/main/getSamfverMatch.do',{samver:jobssam, version:meta.version, valsize:0});
                }
                if(m && m.matchResult && m.matchResult.length){
                    var mm=m.matchResult[0];
                    var samver=mm.SAMVER||mm.samver, tblinfo=mm.TBLINFO||mm.tblinfo, mver=mm.VERSION||mm.version;
                    if(tblinfo==='TBL_CHUNG_MST'){   // 청구서 파일만 청구번호/건수/구분 있음
                        var key=samver+'|'+tblinfo+'|'+mver, cols=_colCache[key];
                        if(!cols){
                            var cr=await post('/main/getSamfverColumns.do',{samver:samver, tblinfo:tblinfo, version:mver});
                            cols=(cr && cr.error_code==='0' && cr.columns)?cr.columns:[];
                            _colCache[key]=cols;
                        }
                        var parsed=(typeof fn_ParseLine==='function')?fn_ParseLine(line, cols):null;
                        var cn=pick(parsed,'CLAIM_NO'), cc=pick(parsed,'CASE_CNT');
                        var insCd=pick(parsed,'INSUR_TYPE'), trtCd=pick(parsed,'TREAT_TYPE'), dym=pick(parsed,'DATE_YM'), ta=pick(parsed,'TOT_AMT');
                        meta.claimNo=cn||'';
                        meta.caseCnt=(cc!=='' && !isNaN(cc))?Number(cc).toLocaleString():(cc||'');
                        meta.totAmt=(ta!=='' && !isNaN(ta))?Number(ta).toLocaleString():(ta||'');
                        dym=(dym||'').replace(/[^0-9]/g,''); meta.dateYm=(dym.length>=6)?(dym.substr(0,4)+'-'+dym.substr(4,2)):dym;   // YYYYMM→YYYY-MM
                        if(!meta.insur) meta.insur=calcInsur(jobssam, file.name, insCd);   // 건보/의보 디코드
                        meta.treat=calcTreat(file.name, trtCd);                             // 입원/외래
                        // 청구구분: 명세서(MYOUNG, 16번째 문자='A') 레코드의 CLAIM_GRP → 원/보완/추가/분리
                        var mline='';
                        for(var li=1; li<lines.length; li++){ var L=lines[li]; if(L && L.length>=16 && L.charAt(15)==='A'){ mline=L; break; } }
                        if(mline){
                            var mkey=samver+'|TBL_MYOUNG_MST|'+mver, mcols=_colCache[mkey];
                            if(!mcols){
                                var mcr=await post('/main/getSamfverColumns.do',{samver:samver, tblinfo:'TBL_MYOUNG_MST', version:mver});
                                mcols=(mcr && mcr.error_code==='0' && mcr.columns)?mcr.columns:[];
                                _colCache[mkey]=mcols;
                            }
                            var mparsed=(typeof fn_ParseLine==='function')?fn_ParseLine(mline, mcols):null;
                            meta.claimType=claimGrpLabel(pick(mparsed,'CLAIM_GRP'));
                        } else {
                            // 산재 등 명세('A' 레코드) 없는 유형 → 청구서 헤더 CLAIM_TYPE 로 대체(0=원청구 등)
                            var clt=pick(parsed,'CLAIM_TYPE');
                            if(clt!=='') meta.claimType=claimGrpLabel(clt);
                        }
                    }
                }
            }
        }catch(e){ console.error('청구파일 파싱 오류:', file.name, e); }
        _meta[idx]=meta;
        applyMeta(idx);
    }
    function syncPicked(){
        var checked=[];
        document.querySelectorAll('#samPickTree input.samPickFile:checked').forEach(function(cb){
            var idx=parseInt(cb.getAttribute('data-idx'),10); if(_files[idx]) checked.push(_files[idx]);
        });
        window.gPickedFiles=checked;
        // 파일 수 = 지금 화면에 보여지는(기간 필터 적용된) 파일 기준
        var shown=document.querySelectorAll('#samPickTree input.samPickFile').length;
        var t=shown ? ('선택 '+checked.length+' / 파일 '+shown+'개') : (_files.length?'표시할 파일 없음(기간 확인)':'매칭 파일 없음');
        var i1=document.getElementById('samPickInfo'), i2=document.getElementById('samPickFootInfo');
        if(i1) i1.textContent=t; if(i2) i2.textContent=t;
        var badge=document.getElementById('samPickOpenCnt');
        if(badge){ if(checked.length){ badge.style.display=''; badge.textContent=checked.length; } else badge.style.display='none'; }
    }
    function render(){
        var tb=document.getElementById('samPickTree'); if(!tb) return;
        if(_files.length===0){ tb.innerHTML='<tr><td colspan="12" class="text-center text-muted">매칭되는 청구파일이 없습니다. (허용 패턴 외이거나 빈 폴더)</td></tr>'; window.gPickedFiles=[]; syncPicked(); return; }
        var groups={}, visible=[];
        for(var i=0;i<_files.length;i++){
            var d=relDir(_files[i]);
            if(!inPeriod(d,_files[i])) continue;
            (groups[d]=groups[d]||[]).push(i); visible.push(i);
        }
        if(visible.length===0){ tb.innerHTML='<tr><td colspan="12" class="text-center text-muted">선택한 기간에 해당하는 파일이 없습니다.</td></tr>'; syncPicked(); return; }
        var dirs=Object.keys(groups).sort(); var html='';
        // 한 파일 행 HTML. opts: {rep:대표행, member:세트멤버, hidden:기본숨김, count:세트파일수}
        function fileRowHtml(idx, d, sid, indent, opts){
            opts=opts||{};
            var f=_files[idx]; var zero=(f.size===0)?' <span class="text-danger">(0B)</span>':'';
            var setAttr = sid ? (' data-set="'+esc(sid)+'"') : '';
            var trCls='samPickFileRow'+(opts.rep?' samPickRepRow':'')+(opts.member?' samPickMember':'');
            var trSty=(opts.rep?'background:#f4f8ff;':'')+(opts.hidden?'display:none;':'');
            var cbCls='samPickFile'+(opts.rep?' samPickRep':'');
            var caret=opts.rep?'<span class="samPickSetCaret" style="display:inline-block;width:18px;cursor:pointer;font-weight:700;" title="펼치기/접기">▶</span> ':'';
            var cnt=opts.rep?(' <span class="text-primary" style="font-weight:600;" title="대표 체크=전체 선택 · 클릭=펼치기">· '+opts.count+'개 세트 ▸</span>'):'';
            return '<tr class="'+trCls+'" data-dir="'+esc(d)+'"'+setAttr+(trSty?(' style="'+trSty+'"'):'')+'>'
                +'<td class="text-center"><input type="checkbox" class="'+cbCls+'" data-idx="'+idx+'" data-dir="'+esc(d)+'"'+setAttr+'></td>'
                +'<td class="text-center" id="spk_dateym_'+idx+'">…</td>'
                +'<td id="spk_insur_'+idx+'">…</td>'
                +'<td class="text-center" id="spk_treat_'+idx+'">…</td>'
                +'<td class="text-center" id="spk_type_'+idx+'">…</td>'
                +'<td class="text-center" id="spk_ver_'+idx+'">…</td>'
                +'<td class="text-center" id="spk_claim_'+idx+'">…</td>'
                +'<td class="text-right" id="spk_cnt_'+idx+'">…</td>'
                +'<td class="text-right" id="spk_tot_'+idx+'">…</td>'
                +'<td class="text-right">'+fmtSize(f.size)+'</td>'
                +'<td style="padding-left:'+indent+'px;">'+caret+'📄 '+esc(f.name)+zero+cnt+'</td>'
                +'<td class="text-center spkStCell" id="spk_st_'+idx+'" style="color:#c0c0c0;">-</td></tr>';
        }
        dirs.forEach(function(d){
            html+='<tr class="samPickDirRow" data-dir="'+esc(d)+'" style="background:#fff8ec; cursor:pointer;">'
                +'<td class="text-center"><input type="checkbox" class="samPickDir" data-dir="'+esc(d)+'"></td>'
                +'<td colspan="11" style="font-weight:600;color:#8a5a00;"><span class="samPickCaret" style="display:inline-block;width:14px;">▼</span> 📁 '+esc(prettyDir(d))+' ('+groups[d].length+')</td></tr>';
            // 폴더 내부를 청구세트(M/C/K/D/H 다중파일)와 단건(GHP/CAR 등)으로 나눔
            var sets={}, order=[];
            groups[d].forEach(function(idx){
                var k=setKey(_files[idx].name);
                if(k===''){ order.push({single:idx}); }
                else { if(!sets[k]){ sets[k]=[]; order.push({setk:k}); } sets[k].push(idx); }
            });
            order.forEach(function(u){
                if(u.single!=null){ html+=fileRowHtml(u.single, d, '', 22, {}); return; }
                var members=sets[u.setk];
                if(members.length<=1){ html+=fileRowHtml(members[0], d, '', 22, {}); return; }  // 1개면 단건
                var sid=d+'||'+u.setk;
                members.sort(function(a,b){ return _files[a].name.toUpperCase() < _files[b].name.toUpperCase() ? -1 : 1; });
                var repIdx=members[0];   // 대표 = 파일명 가장 작은 것(청구서, 예 M010.1)
                html+=fileRowHtml(repIdx, d, sid, 22, {rep:true, count:members.length});                 // 대표행 — 보임(정보 표시)
                members.slice(1).forEach(function(idx){ html+=fileRowHtml(idx, d, sid, 40, {member:true, hidden:true}); }); // 멤버 — 기본 접힘
            });
        });
        tb.innerHTML=html;
        tb.querySelectorAll('input.samPickFile').forEach(function(cb){ cb.addEventListener('change', syncPicked); });
        tb.querySelectorAll('input.samPickDir').forEach(function(cb){ cb.addEventListener('change', function(e){
            e.stopPropagation();
            var dir=cb.getAttribute('data-dir');
            tb.querySelectorAll('input.samPickFile').forEach(function(fc){ if(fc.getAttribute('data-dir')===dir) fc.checked=cb.checked; });
            syncPicked();
        }); });
        // 대표 체크 → 세트 전체(대표+멤버) 선택
        tb.querySelectorAll('input.samPickRep').forEach(function(cb){ cb.addEventListener('change', function(e){
            e.stopPropagation();
            var sid=cb.getAttribute('data-set');
            tb.querySelectorAll('input.samPickFile').forEach(function(fc){ if(fc.getAttribute('data-set')===sid) fc.checked=cb.checked; });
            syncPicked();
        }); });
        // 폴더 행 클릭 → 접기/펼치기 (펼칠 때 세트 멤버는 접힌 상태 유지)
        tb.querySelectorAll('tr.samPickDirRow').forEach(function(row){
            row.addEventListener('click', function(ev){
                if(ev.target && ev.target.classList && ev.target.classList.contains('samPickDir')) return;
                var dir=row.getAttribute('data-dir');
                var caret=row.querySelector('.samPickCaret');
                var expanding = caret && caret.textContent==='▶';
                tb.querySelectorAll('tr.samPickFileRow').forEach(function(fr){
                    if(fr.getAttribute('data-dir')!==dir) return;
                    if(expanding){ if(!fr.classList.contains('samPickMember')) fr.style.display=''; }
                    else { fr.style.display='none'; }
                });
                if(caret) caret.textContent = expanding ? '▼' : '▶';
            });
        });
        // 세트 멤버 펼침/접힘 — 대표행의 ▶ 화살표 클릭 시에만 (행 다른 부분 클릭은 무반응)
        tb.querySelectorAll('tr.samPickRepRow .samPickSetCaret').forEach(function(caret){
            caret.addEventListener('click', function(ev){
                ev.stopPropagation();
                var row=caret.closest('tr');
                var sid=row?row.getAttribute('data-set'):null;
                if(!sid) return;
                var expanding = caret.textContent==='▶';
                tb.querySelectorAll('tr.samPickMember').forEach(function(fr){ if(fr.getAttribute('data-set')===sid) fr.style.display = expanding?'':'none'; });
                caret.textContent = expanding ? '▼' : '▶';
            });
        });
        visible.forEach(function(idx){ applyMeta(idx); });   // 캐시된 파싱값 있으면 표시
        syncPicked();
        (async function(){ for(var k=0;k<visible.length;k++){ var vi=visible[k]; if(!_meta[vi]) await parseOne(vi); } })();   // 미파싱만 첫줄 파싱(순차)
    }
    function onPick(e){   // 구형 브라우저 폴백(webkitdirectory input) 경로
        var fl=e.target.files||[]; _files=[]; _meta={}; _dirHandle=null;
        for(var i=0;i<fl.length;i++){ if(matchAllowed(fl[i].name)) _files.push(fl[i]); }
        var top=(fl.length && fl[0].webkitRelativePath)?fl[0].webkitRelativePath.split('/')[0]:'';
        var fe=document.getElementById('samPickFolder'); if(fe) fe.textContent = top?('선택폴더: '+top):'폴더 미선택';
        render();
    }
    // 폴더 핸들 재귀 스캔 → _files 구성 (다이얼로그 없이 재사용 가능)
    async function scanFromHandle(){
        if(!_dirHandle) return;
        var list=[];
        async function walk(h, path){
            for await (const entry of h.values()){
                if(entry.kind==='file'){
                    if(matchAllowed(entry.name)){
                        var f=await entry.getFile();
                        try{ f._relPath=path; f._parentDir=h; f._entryName=entry.name; }catch(x){}   // 삭제(removeEntry)용 핸들 보관
                        list.push(f);
                    }
                } else if(entry.kind==='directory'){
                    await walk(entry, path+'/'+entry.name);
                }
            }
        }
        try{ await walk(_dirHandle, _dirHandle.name); }catch(e){ console.error('폴더 스캔 오류:', e); }
        _files=list; _meta={};
        var fe=document.getElementById('samPickFolder'); if(fe) fe.textContent='선택폴더: '+_dirHandle.name;
        render();
    }
    // 드래그&드롭 폴더 읽기 — 권한창/업로드확인창 전혀 없음(webkitGetAsEntry)
    function walkEntry(entry, parentPath, list){
        return new Promise(function(resolve){
            if(!entry){ resolve(); return; }
            if(entry.isFile){
                entry.file(function(f){ if(matchAllowed(f.name)){ try{ f._relPath=parentPath||'(루트)'; }catch(x){} list.push(f); } resolve(); }, function(){ resolve(); });
            } else if(entry.isDirectory){
                var myPath = parentPath ? (parentPath+'/'+entry.name) : entry.name;
                var reader=entry.createReader(), all=[];
                (function rd(){
                    reader.readEntries(function(ents){
                        if(ents && ents.length){ all=all.concat(Array.prototype.slice.call(ents)); rd(); }
                        else { Promise.all(all.map(function(en){ return walkEntry(en, myPath, list); })).then(function(){ resolve(); }); }
                    }, function(){ resolve(); });
                })();
            } else resolve();
        });
    }
    async function onDrop(e){
        e.preventDefault();
        var items=e.dataTransfer && e.dataTransfer.items ? e.dataTransfer.items : [];
        var roots=[];
        for(var i=0;i<items.length;i++){ var en=items[i].webkitGetAsEntry && items[i].webkitGetAsEntry(); if(en) roots.push(en); }
        if(!roots.length){ return; }
        var list=[];
        for(var r=0;r<roots.length;r++){ await walkEntry(roots[r], '', list); }
        _files=list; _meta={}; _dirHandle=null;
        var top=(roots[0] && roots[0].isDirectory)?roots[0].name:(roots.length?'(파일)':'');
        var fe=document.getElementById('samPickFolder'); if(fe) fe.textContent = top?('선택폴더: '+top):'폴더 미선택';
        render();
    }

    // 폴더 선택 — showDirectoryPicker(다이얼로그 버튼이 '폴더 선택', 업로드 확인창 없음) 우선, 미지원 시 webkitdirectory 폴백
    async function pickFolder(){
        if(window.showDirectoryPicker){
            var h=null;
            // readwrite: 업로드 성공 후 원본 파일 삭제(개인정보 보호)를 위해 쓰기 권한까지 요청
            try{ h=await window.showDirectoryPicker({mode:'readwrite'}); }catch(e){ return; }   // 사용자가 취소
            _dirHandle=h;
            await scanFromHandle();
        } else {
            document.getElementById('samPickInput').click();
        }
    }
    // 업로드 후 '선택만' 해제 — 폴더(파일목록)는 세션 동안 유지(다른 월에 재선택·재업로드 가능, 재선택 불필요)
    window.samPickReset=function(){
        window.gPickedFiles=[];
        document.querySelectorAll('#samPickTree input').forEach(function(cb){ cb.checked=false; });
        syncPicked();
    };
    // 업로드 '성공' 후 처리: 원본 파일 실제 삭제(개인정보 보호, removeEntry) — [폴더 선택](쓰기권한) 경로만 가능.
    // 삭제 불가 경로(드래그&드롭 등)나 [보관] 선택 시엔 localStorage 서명으로 목록에서 숨김만.
    async function deleteUploaded(list){
        var ok=0, fail=0;
        for(var i=0;i<list.length;i++){
            var f=list[i];
            try{ await f._parentDir.removeEntry(f._entryName||f.name); ok++; }
            catch(e){ fail++; console.error('원본 삭제 실패:', f.name, e); }
        }
        if(_dirHandle) await scanFromHandle(); else render();
        clearChecks();   // 업로드·삭제된 파일 체크 해제
        if(typeof Swal!=='undefined')
            Swal.fire({ icon: fail?'warning':'success',
                html:'<div style="font-size:15px;">원본 파일 삭제 '+ok+'건'+(fail?(' · 실패 '+fail+'건'):'')+'</div>',
                width:'360px', padding:'0.6em', heightAuto:false, timer:2500, showConfirmButton:false });
    }
    function clearChecks(){   // 업로드된(처리된) 파일 체크 해제
        window.gPickedFiles=[];
        document.querySelectorAll('#samPickTree input').forEach(function(cb){ cb.checked=false; });
        syncPicked();
    }
    function hideUploaded(up){   // 삭제 불가 경로(드래그&드롭 등): 숨김 방식 보류 → 체크만 해제하고 완료 안내
        clearChecks();
        if(typeof Swal!=='undefined'){
            Swal.fire({ icon:'success', html:'<div style="font-size:15px;">'+(window._samUpDoneMsg||('업로드 완료('+up.length+'건)'))+'</div>',
                width:'400px', padding:'0.6em', heightAuto:false, timer:2600, showConfirmButton:false });
        }
        window._samUpDoneMsg=null;
    }
    window.samPickRemoveUploaded=function(){
        var up=window._samUploadedFiles||[]; window._samUploadedFiles=null;
        if(!up.length) return;
        var deletable=up.filter(function(f){ return f._parentDir; });
        if(deletable.length && typeof Swal!=='undefined'){
            Swal.fire({ icon:'question',
                html:'<div style="font-size:15px;line-height:1.5;">업로드가 완료되었습니다.<br>개인정보 보호를 위해 <b>원본 파일 '+deletable.length+'건</b>을 폴더에서 삭제하시겠습니까?</div>',
                showCancelButton:true, confirmButtonText:'삭제', cancelButtonText:'보관',
                width:'420px', padding:'0.8em', heightAuto:false })
            .then(function(res){
                var confirmed = res && (res.isConfirmed===true || res.value===true);   // Swal 버전 무관 안전 판정
                if(confirmed){ deleteUploaded(deletable); }
                else { clearChecks(); }   // [보관]/취소/닫기 → 파일·표시는 유지, 단 이미 업로드된 파일이므로 체크는 해제
            });
        } else {
            hideUploaded(up);   // 삭제 불가 경로(드래그&드롭/폴백) — 숨김만
        }
    };
    $(function(){
        if(!document.getElementById('samPickModal')) return;
        // 모달이 카드/탭 안에 중첩되면 백드롭이 위를 덮어 클릭(닫기)이 막힘 → body 직속으로 이동
        try { $('#samPickModal').appendTo(document.body); } catch(e){}
        // 닫기/선택적용 등 data-dismiss 보강(위임 이벤트 누락 대비 명시적 hide)
        document.querySelectorAll('#samPickModal [data-dismiss="modal"]').forEach(function(b){
            b.addEventListener('click', function(){ try { $('#samPickModal').modal('hide'); } catch(e){} });
        });
        fetchCodes();   // 보험구분/입외 디코드용 공통코드 로드
        // 모달 다시 열 때 폴더 핸들 유지 중이면 자동 재스캔(SamCatch 새 복사분/삭제분 반영). 핸들 없으면(드롭/폴백) 화면만 갱신
        try{ $('#samPickModal').on('shown.bs.modal', function(){ if(typeof _dirHandle!=='undefined' && _dirHandle){ scanFromHandle(); } else { render(); } }); }catch(e){}
        document.getElementById('samPickBtn').addEventListener('click', function(){ pickFolder(); });
        // 드래그&드롭 — 폴더를 모달 안으로 끌어다 놓으면 권한창 없이 바로 읽음
        var mbody=document.querySelector('#samPickModal .modal-body');
        if(mbody){
            mbody.addEventListener('dragover', function(e){ e.preventDefault(); e.stopPropagation(); mbody.style.outline='2px dashed #f0932b'; mbody.style.outlineOffset='-6px'; });
            mbody.addEventListener('dragleave', function(e){ e.preventDefault(); mbody.style.outline=''; });
            mbody.addEventListener('drop', function(e){ e.preventDefault(); e.stopPropagation(); mbody.style.outline=''; onDrop(e); });
        }
        // 새로고침 — 폴더 핸들 유지 중이면 다이얼로그 없이 즉시 재스캔(SamCatch 새 복사분 반영), 없으면 폴더 선택
        var refBtn=document.getElementById('samPickRefresh');
        if(refBtn) refBtn.addEventListener('click', function(){ if(_dirHandle) scanFromHandle(); else render(); });   // 핸들 있으면 재스캔, 없으면(폴백) 화면만 갱신(다이얼로그 X)
        // [선택 적용] — 월 카드로 열었으면(그 월 기억) 업로드 내용 확인 후 그 월로 업로드 실행
        var applyBtn=document.getElementById('samPickApply');
        if(applyBtn) applyBtn.addEventListener('click', function(){
            if(!window.gPickedFiles || !window.gPickedFiles.length){
                if(typeof Swal!=='undefined'){
                    Swal.fire({ icon:'warning',
                        html:'<div style="font-size:16px;line-height:1.5;">선택된 청구파일이 없습니다.<br>올릴 파일을 체크하세요.</div>',
                        confirmButtonText:'확인', width:'420px', padding:'0.6em', heightAuto:false });
                } else { alert('선택된 청구파일이 없습니다. 올릴 파일을 체크하세요.'); }
                return;   // 선택 없으면 닫지 않고 유지(오류 방지)
            }
            var mm=window._samPickMonth;
            var yr=(document.getElementById('year_Select')||{}).value || (typeof g_Year!=='undefined'?g_Year:'');
            // 한 청구건 파일그룹을 업로드하고 완료(signUp!=='Y')까지 대기
            function uploadGroupSeq(grp){
                return new Promise(function(resolve){
                    var fi=document.getElementById('folderInput');
                    try{
                        var dt=new DataTransfer(); grp.forEach(function(f){ dt.items.add(f); });
                        fi.removeAttribute('webkitdirectory'); fi.value=''; fi.files=dt.files;
                        window._samUploadedFiles=null;   // 그룹별 자동 삭제/숨김 방지(맨 끝에 일괄)
                        handleFileSelection({ target: fi });
                    }catch(e){ console.error('청구건 업로드 오류:', e); resolve(); return; }
                    var waited=0, t=setInterval(function(){
                        if(window.signUp!=='Y'){ clearInterval(t); setTimeout(resolve, 200); }   // 완료
                        else if((waited+=200)>180000){ clearInterval(t); resolve(); }             // 안전장치 3분
                    }, 200);
                });
            }
            if(!mm){
                if(typeof Swal!=='undefined'){ Swal.fire({ icon:'warning', html:'<div style="font-size:15px;">대상 월이 지정되지 않았습니다.<br>창을 닫고 월을 다시 선택하세요.</div>', width:'420px', padding:'0.6em', heightAuto:false }); }
                else { alert('대상 월이 지정되지 않았습니다.'); }
                return;
            }
            // 청구건 단위 그룹핑 — 선택 파일을 setKey로 묶고, 상태셀 갱신용 파일 인덱스(gidx)도 함께 보관
            var picked=(window.gPickedFiles||[]).slice();
            var gm={}, order=[], gidx={};
            picked.forEach(function(f){
                var i=_files.indexOf(f);
                var k=setKey(f.name);
                var key=(k!=='') ? ('S|'+k+'|'+relDir(f)) : ('F|'+f.name+'|'+relDir(f));
                if(!gm[key]){ gm[key]=[]; gidx[key]=[]; order.push(key); }
                gm[key].push(f); if(i>=0) gidx[key].push(i);
            });
            // 상태 컬럼 셀 갱신
            function setSt(idxs, txt, color){ (idxs||[]).forEach(function(i){ var c=document.getElementById('spk_st_'+i); if(c){ c.textContent=txt; c.style.color=color; c.style.fontWeight='600'; } }); }
            var refreshBtn=document.getElementById('samPickRefresh'), folderBtn=document.getElementById('samPickBtn'), footEl=document.getElementById('samPickFootInfo');
            (async function runInline(){
                // 실행 중 버튼 잠금(오조작 방지)
                if(applyBtn){ applyBtn.disabled=true; applyBtn.textContent='업로드 중...'; }
                if(folderBtn) folderBtn.disabled=true;
                if(refreshBtn) refreshBtn.disabled=true;
                try{ window.gMonth=mm; if(typeof findField==='function') findField('mgmonth', mm); }catch(e){}
                order.forEach(function(key){ setSt(gidx[key], '대기', '#888'); });   // 선택 청구건 전부 '대기'
                window._samSilent=true;   // 청구건별 성공메시지 억제(별도 창 안 뜸)
                var removed=[], failedFiles=[], delFail=0, okCnt=0, failCnt=0;   // 성공(삭제대상)/실패(보존)/삭제실패
                for(var i=0;i<order.length;i++){
                    setSt(gidx[order[i]], '⏳ 진행', '#f0932b');
                    if(footEl) footEl.textContent='업로드 중 '+(i+1)+' / '+order.length+' 건';
                    window._samUploadedFiles=null;
                    window._samUpOk=null;   // 이번 청구건 성공여부 초기화(핸들러가 true/false 세팅)
                    await uploadGroupSeq(gm[order[i]]);   // 완료(signUp!=='Y')까지 대기
                    var grp=gm[order[i]];
                    if(window._samUpOk===true){
                        // 성공 → ✅ 완료 + 원본 삭제 + 행 제거(사라지게). 폴더핸들 있을 때만 실제 삭제(showDirectoryPicker)
                        okCnt++;
                        setSt(gidx[order[i]], '✅ 완료', '#28a745');
                        for(var g=0; g<grp.length; g++){
                            var f=grp[g];
                            if(f._parentDir && f._entryName){
                                try{ await f._parentDir.removeEntry(f._entryName); }
                                catch(ex){ delFail++; console.warn('원본 삭제 실패:', f.name, ex); }
                            }
                            removed.push(f);
                        }
                        gidx[order[i]].forEach(function(ix){ var c=document.getElementById('spk_st_'+ix); var tr=c?c.closest('tr'):null; if(tr && tr.parentNode) tr.parentNode.removeChild(tr); });   // 완료행 즉시 사라짐
                    } else {
                        // 실패/불명 → ❌ 실패 표시, 원본 보존(삭제 안 함, 목록 유지)
                        failCnt++;
                        setSt(gidx[order[i]], '❌ 실패', '#e74c3c');
                        for(var g2=0; g2<grp.length; g2++){ failedFiles.push(grp[g2]); }
                    }
                }
                window._samSilent=false;
                // _files/_meta 에서 성공·삭제분만 제거 후 재렌더(실패건은 남김) → 재렌더 후 실패건 ❌ 재표시
                if(removed.length){
                    var nf=[], nm={};
                    for(var j=0;j<_files.length;j++){ if(removed.indexOf(_files[j])<0){ var ni=nf.length; nm[ni]=_meta[j]; nf.push(_files[j]); } }
                    _files=nf; _meta=nm;
                }
                window.gPickedFiles=[];
                if(typeof loadMonthsData==='function'){ try{ loadMonthsData(); }catch(e){} }
                render();   // 성공분 빠진 목록으로 갱신(체크 초기화됨)
                failedFiles.forEach(function(f){ var ni=_files.indexOf(f); if(ni>=0) setSt([ni], '❌ 실패', '#e74c3c'); });   // 실패건 상태 재표시(원본 보존)
                if(applyBtn){ applyBtn.disabled=false; applyBtn.textContent='선택 적용'; }
                if(folderBtn) folderBtn.disabled=false;
                if(refreshBtn) refreshBtn.disabled=false;
                if(footEl){
                    var msg=esc(mm)+'월 — <b style="color:#28a745;">성공 '+okCnt+'건'+(okCnt?' · 원본 삭제됨':'')+'</b>';
                    if(delFail) msg+=' <span style="color:#e17055;">(삭제실패 '+delFail+'건)</span>';
                    if(failCnt) msg+=' <b style="color:#e74c3c;"> · 실패 '+failCnt+'건(원본 보존)</b>';
                    footEl.innerHTML=msg;
                }
            })();
        });
        document.getElementById('samPickInput').addEventListener('change', onPick);
        var chkAll=document.getElementById('samPickChkAll');
        if(chkAll) chkAll.addEventListener('change', function(){ document.querySelectorAll('#samPickTree input').forEach(function(cb){cb.checked=chkAll.checked;}); syncPicked(); });
        var upchk=document.getElementById('samPickShowUp');
        if(upchk) upchk.addEventListener('change', function(){ render(); });
        var clrup=document.getElementById('samPickClearUp');
        if(clrup) clrup.addEventListener('click', function(){
            _upSigs={}; try{ localStorage.removeItem(upKey()); }catch(e){}
            render();
            if(typeof Swal!=='undefined'){ Swal.fire({ icon:'success', html:'<div style="font-size:14px;">숨김 기록을 초기화했습니다.<br>모든 파일이 다시 표시됩니다.</div>', width:'360px', padding:'0.5em', heightAuto:false, timer:1800, showConfirmButton:false }); }
        });
        var pchk=document.getElementById('samPickPeriodChk');
        if(pchk) pchk.addEventListener('change', function(){
            var f=document.getElementById('samPickFrom'), t=document.getElementById('samPickTo');
            if(f) f.disabled=!pchk.checked; if(t) t.disabled=!pchk.checked;
            render();
        });
        ['samPickFrom','samPickTo'].forEach(function(id){
            var el=document.getElementById(id);
            if(el) el.addEventListener('change', function(){ if(periodActive()) render(); });
        });
        // 기간 기본값: 일주일 전 ~ 오늘 (기본 활성)
        (function(){
            function pad(n){ return ('0'+n).slice(-2); }
            function ymd(d){ return d.getFullYear()+'-'+pad(d.getMonth()+1)+'-'+pad(d.getDate()); }
            var to=new Date(), from=new Date(); from.setDate(from.getDate()-7);
            var f=document.getElementById('samPickFrom'), t=document.getElementById('samPickTo'), c=document.getElementById('samPickPeriodChk');
            if(c) c.checked=true;
            if(f){ f.value=ymd(from); f.disabled=false; }
            if(t){ t.value=ymd(to);   t.disabled=false; }
        })();
    });
})();
</script>

<!-- ============================================================== -->
<!-- 월별,  8.청구서 9.평가표 정보 End -->
<!-- ============================================================== -->     
