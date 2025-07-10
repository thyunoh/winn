<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="decorator" uri="http://www.opensymphony.com/sitemesh/decorator"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/page" prefix="page"%>
<%@ page import="java.util.Date"%>
<!-- Customized Bootstrap Stylesheet -->
 
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" /> <!-- 파일다운로드관련아이콘 -->

<link href="/css/winmc/bootstrap.css"   rel="stylesheet">
<link href="/css/winmc/style.css?v=123" rel="stylesheet">
<link href="/css/winmc/style_comm.css?v=123"  rel="stylesheet">
<!-- DataTables CSS -->
<style>
</style>
<!-- ============================================================== -->
<!-- Main Form start -->
<!-- ============================================================== -->
<div class="dashboard-wrapper">
	<div class="container-fluid  dashboard-content">
		<div class="row">
			<!-- ============================================================== -->
			<!-- data table start -->
			<!-- ============================================================== -->
			<div class="col-xl-12 col-lg-12 col-md-12 col-sm-12 col-12">
				<div class="card">
					<div class="card-body">
						<div class="form-row mb-2">
							<div class="col-sm-1">
								<select id="fileGb1" class="w-72 p-2 rounded-lg"
									oninput="findField(this)">
									<option selected value="1">구분 1</option>
								</select>
							</div>
							<div class="col-sm-6">
								<div class="btn-group ml-auto">
									<button class="btn btn-outline-dark" data-toggle="tooltip"
										data-placement="top" title="" onClick="fn_re_load()">
										재조회. <i class="fas fa-binoculars"></i>
									</button>
									<button class="btn btn-outline-dark btn-insert" data-toggle="tooltip"
										data-placement="top" title="신규 Data 입력"
										onClick="modal_Open('I')">
										입력. <i class="far fa-edit"></i>
									</button>
									<button class="btn btn-outline-dark  btn-update" data-toggle="tooltip"
										data-placement="top" title="선택 Data 수정"
										onClick="modal_Open('U')">
										수정. <i class="far fa-save"></i>
									</button>
									<button class="btn btn-outline-dark btn-delete" data-toggle="tooltip"
										data-placement="top" title="선택 Data 삭제"
										onClick="modal_Open('D')">
										삭제. <i class="far fa-trash-alt"></i>
									</button>
									<button class="btn btn-outline-dark btn-delete" data-toggle="tooltip"
										data-placement="top" title="체크 Data 삭제" onClick="fn_findchk()">
										체크삭제. <i class="far fa-calendar-check"></i>
									</button>
									<button class="btn btn-outline-dark" data-toggle="tooltip"
										data-placement="top" title="화면 Size 확대.축소"
										id="fullscreenToggle">
										화면확장축소. <i class="fas fa-expand" id="fullscreenIcon"></i>
									</button>
								</div>
							</div>
						</div>
						<div style="width: 100%;">
							<table id="tableName"
								class="display nowrap stripe hover cell-border  order-column responsive">

							</table>
						</div>
					</div>
				</div>
			</div>
			<!-- ============================================================== -->
			<!-- data table end   -->
			<!-- ============================================================== -->
		</div>
	</div>
</div>
<!-- ============================================================== -->
<!-- modal form start -->
<!-- ============================================================== -->
<div class="modal fade" id="modalName" tabindex="-1" data-bs-backdrop="static" data-bs-keyboard="false" role="dialog" aria-hidden="true">	
	<div class="modal-dialog modal-dialog-centered modal-dialog-scrollable"
		role="dialog"
		style="position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); width: 50vw; max-width: 50vw; max-height: 50vh;">
		<div class="modal-content"
			style="height: 100%; display: flex; flex-direction: column;">
			<div class="modal-header bg-light">
				<h6 class="modal-title" id="modalHead"></h6>
				<!-- ============================================================== -->
				<!-- button start -->
				<!-- ============================================================== -->
				<div class="form-row">
					<div class="col-sm-12 mb-2" style="text-align: right;">
						<button id="form_btn_new" type="submit"
							class="btn btn-outline-dark" onClick="fn_Potion()">
							센터. <i class="far fa-object-group"></i>
						</button>
						<button id="form_btn_ins" type="submit"
							class="btn btn-outline-info btn-insert" onClick="fn_Insert()">
							입력. <i class="far fa-edit"></i>
						</button>
						<button id="form_btn_udt" type="submit"
							class="btn btn-outline-success btn-update" onClick="fn_Update()">
							수정. <i class="far fa-save"></i>
						</button>
						<button id="form_btn_del" type="submit"
							class="btn btn-outline-danger btn-delete" onClick="fn_Delete()">
							삭제. <i class="far fa-trash-alt"></i>
						</button>
						<button type="button" class="btn btn-outline-dark"
							data-dismiss="modal" onClick="modalMainClose()">
							닫기 <i class="fas fa-times"></i>
						</button>
					</div>
				</div>
				<!-- ============================================================== -->
				<!-- end button -->
				<!-- ============================================================== -->
			</div>
			<div class="modal-body"
				style="text-align: left; flex: 1; overflow-y: auto;">
				<!-- ================================================================== -->
				<div id="inputZone">
					<!-- ============================================================== -->
					<!-- text input 1개 start -->
					<!-- ============================================================== -->
					<input  type="hidden" id="notiSeq"   name="notiSeq"   value="">
					<input  type="hidden" id="hospCd"    name="hospCd"    value=""> <input
							type="hidden" id="subCodeNm" name="subCodeNm" value=""> <input
							type="hidden" id="regUser"   name="regUser"   value=""> <input
							type="hidden" id="updDttm"   name="updDttm"   value=""> <input
							type="hidden" id="updUser"   name="updUser"   value=""> <input
							type="hidden" id="regIp"     name="regIp"     value=""> <input
							type="hidden" id="updIp"     name="updIp "    value=""><input
							type="hidden" id="fileYn"    name="fileYn "   value="">
					<div class="form-row">
						<label for="fileGb"
							class="col-2 col-lg-2 col-form-label text-left">공지구분</label>
						<div class="col-2 col-lg-2">
							<select id="fileGb" name="fileGb" class="custom-select"
								oninput="findField(this)" style="height: 35px; font-size: 14px;">
								<option value="" selected>구분1</option>
							</select>
						</div>
					</div>
					<div class="form-row">
						<label for="notiTitle"
							class="col-2 col-lg-2 col-form-label text-left">공지제목</label>
						<div class="col-xl-10 col-lg-10 text-left mb-2">
							<textarea id="notiTitle" name="notiTitle" type="text"
								data-parsley-trigger="change" placeholder="" autocomplete="off"
								class="form-control" rows="2"></textarea>
						</div>
					</div>
					<div class="form-row">
						<label for="notiContent"
							class="col-2 col-lg-2 col-form-label text-left">공지내용</label>
						<div class="col-xl-10 col-lg-10 text-left mb-2">
							<textarea id="notiContent" name="notiContent" type="text"
								data-parsley-trigger="change" placeholder="" autocomplete="off"
								class="form-control" rows="8"></textarea>
						</div>
					</div>
					<div class="form-group row">
						<label for="startDt"
							class="col-2 col-lg-2 col-form-label text-left">적용시작일</label>
						<div class="col-2 col-lg-2">
							<input id="startDt" name="startDt" type="text"
								class="form-control date1-inputmask" placeholder="yyyy-mm-dd">

						</div>
						<label for="endDt" class="col-2 col-lg-2 col-form-label text-left">적용종료일</label>
						<div class="col-2 col-lg-2">
							<input id="endDt" name="endDt" value='20991231' type="text"
								class="form-control date1-inputmask" placeholder="yyyy-mm-dd">

						</div>
						<label for="useYn" class="col-2 col-lg-2 col-form-label text-left">사용여부</label>
						<div class="col-2 col-lg-2">
							<select class="custom-select" name="useYn" id="useYn" value='Y'>
								<option value="Y">Y</option>
								<option value="N" selected>N</option>
							</select>
						</div>
					</div>

					<form id="uploadForm" action="${pageContext.request.contextPath}"
						method="post" enctype="multipart/form-data" style="margin-top: -12px;">
						<div class="container-md mt-1">
							<div class="form-group">
								<input type="hidden" name="action" value="upload"> 
									<label class="col-2 col-lg-2 col-form-label text-left" style="margin-left: -25px;">파일 업로드</label>
								<div class="col-10 col-lg-10">
									<!-- 파일 선택 버튼 -->
									<div class="btn-box">
										<button type="button" class="btn btn-primary custom-btn-small"
											onclick="openFileInput()">파일 선택</button>
										<button type="submit" class="btn btn-success custom-btn-small">업로드</button>
									</div>

									<!-- 숨겨진 파일 입력 -->
									<input type="file" id="file-input" name="file" multiple
										style="display: none;" onchange="changeHandler(event)">
									<p id="file-name-display" style="color: blue;"></p>
									<!-- 드래그 앤 드롭 영역 -->
									<div id="drag-area" ondrop="dropHandler(event)"
										ondragover="dragOverHandler(event)">
										<p style="margin: 3px; font-size: 14px;">파일을 여기에 드래그 하세요.</p>
										<div id="file-list" class="file-list-container"></div>
									</div>

								</div>
							</div>
						</div>
					</form>  
					<p>
						<strong><%=request.getAttribute("message") != null ? request.getAttribute("message") : ""%></strong>
					</p>
					<div class="table-file-container" style="width: 100%;  margin-top: 30px; border: 1px solid #ddd; border-radius: 10px;">
					    <div style="max-height: 150px; overflow-y: auto;">
					        <table id="fileTable" class="display nowrap table table-hover table-bordered" style="width: 100%;">
					       </table>    
					    </div>
					</div>     
					<!-- ============================================================== -->
					<!-- end form 수정해야 될 곳 -->
					<!-- ============================================================== -->
				</div>
				<div class="modal-footer"></div>
			</div>
		</div>
	</div>
</div>
<!-- JS로 추가 로그 출력 -->

<!-- ============================================================== -->
<!-- modal form end -->
<!-- ============================================================== -->
<!-- ============================================================== -->
<!-- 기본 초기화 Start -->
<!-- ============================================================== -->
<script type="text/javascript">
		// 안해도 상관없음, 단 getElementById를 변경하면 꼭해야됨
		// Form마다 수정해야 될 부분 시작
		var tableName = document.getElementById('tableName');
		tableName.style.display = 'none';		
		var modalName = document.getElementById('modalName');
		var modalHead = document.getElementById('modalHead');
		modalHead.innerText = "...";
		var inputZone = document.getElementById('inputZone');
		// Form마다 수정해야 될 부분 종료
        let s_hospcd = getCookie("s_hospid") ;	
        $("#hospCd").val(s_hospcd);
		// Form마다 조회 조건 변경 시작
		var findTxtln  = 0;    // 조회조건시 글자수 제한 / 0이면 제한 없음
		var firstflag  = false; // 첫음부터 Find하시려면 false를 주면됨
		var findValues = [];
		// 조회조건이 있으면 설정하면됨 / 조건 없으면 막으면 됨
		// 글자수조건 있는건 1개만 설정가능 chk: true 아니면 모두 flase
		// 조회조건은 필요한 만큼 추가사용 하면됨.
		findValues.push({ id: "findData", val: "",  chk: true  });
		//Form마다 조회 조건 변경 종료
		
		// 초기값 설정
		var mainFocus = 'findData'; // Main 화면 focus값 설정, Modal은 따로 Focus 맞춤
		var edit_Data = null;
		var dataTable = new DataTable();
		dataTable.clear();
		
		<!-- ============================================================== -->
		<!-- 공통코드 Setting Start -->
		<!-- ============================================================== -->
		var list_flag = ['Z'];     										// 대표코드, ['Z','X','Y'] 여러개 줄 수 있음
		//  list_code, select_id, firstnull는 갯수가 같아야함. firstnull의 마지막이 'N'이면 생략가능, 하지만 쌍으로 맞추는게 좋음 
		var list_code = ['FILE_GB','FILE_GB'];     // 구분코드 필요한 만큼 선언해서 사용
		var select_id = ['fileGb','fileGb1'];     // 구분코드 데이터 담길 Select (ComboBox ID) 
		var firstnull = ['N','Y'];                              // Y 첫번째 Null,이후 Data 담김 / N 바로 Data 담김
		<!-- ============================================================== -->
		<!-- 공통코드 Setting End -->
		<!-- ============================================================== -->
		var format_convert = ['startDt','endDt'] ; //날자에서 '-' '/' 제외설정   
		
		<!-- ============================================================== -->
		<!-- Table Setting Start -->
		<!-- ============================================================== -->
		var gridColums = [];
		var btm_Scroll = true;   		// 하단 scroll여부 - scrollX
		var auto_Width = true;   		// 열 너비 자동 계산 - autoWidth
		var page_Hight = 650;    		// Page 길이보다 Data가 많으면 자동 scroll - scrollY
		var p_Collapse = false;  		// Page 길이까지 auto size - scrollCollapse
		
		var datWaiting = true;   		// Data 가져오는 동안 대기상태 Waiting 표시 여부
		var page_Navig = true;   		// 페이지 네비게이션 표시여부 
		var hd_Sorting = true;   		// Head 정렬(asc,desc) 표시여부
		var info_Count = true;   		// 총건수 대비 현재 건수 보기 표시여부 
		var searchShow = true;   		// 검색창 Show/Hide 표시여부
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
		
		var colPadding = '0.2px'   		// 행 높이 간격 설정
		var data_Count = [30 , 50, 70, 100, 150, 200];  // Data 보기 설정
		var defaultCnt = 30;                      // Data Default 갯수
		
		
		//  DataTable Columns 정의, c_Head_Set, columnsSet갯수는 항상 같아야함.
		var c_Head_Set = ['순서','공지구분','공지명칭','공지제목','공지내용','시작일','종료일','사용여부','등록일','첨부자료'];
		var columnsSet = [  // data 컬럼 id는 반드시 DTO의 컬럼,Modal id는 일치해야 함 (조회시)
	        				// name 컬럼 id는 반드시 DTO의 컬럼 일치해야 함 (수정,삭제시), primaryKey로 수정, 삭제함.
	        				// dt-body-center, dt-body-left, dt-body-right	        				
	        				{ data: 'notiSeq',      visible: false, className: 'dt-body-center', width: '100px',   name: 'keynotiSeq', primaryKey: true },
	        				{ data: 'fileGb',       visible: false, className: 'dt-body-center', width: '100px',   name: 'keyfileGb', primaryKey: true },
	        				{ data: 'subCodeNm',    visible: true,  className: 'dt-body-left'  , width: '100px',  },
	        				{ data: 'notiTitle',    visible: true,  className: 'dt-body-left'  , width: '300px',  },
	        				{ data: 'notiContent',  visible: true,  className: 'dt-body-left'  , width: '300px',
	        					  render: function (data, type, row) {
	        					    if (type === 'display') {
	        					      var text = $('<div>').html(data).text(); // HTML 태그 제거
	        					      return text.length > txt_Markln ? text.substring(0, txt_Markln) + '...' : text;
	        					    }
	        					    return data;
	        					  }
	        				},

	        				// getFormat 사용시 
	        				{ data: 'startDt',    visible: true,  className: 'dt-body-center', width: '100px',  
	                          	render: function(data, type, row) {
		            				if (type === 'display') {
		            					return getFormat(data,'d1')
		                			}
		                			return data;
	            				}
	        				},
	        				{ data: 'endDt',    visible: true,  className: 'dt-body-center', width: '100px',  
	                          	render: function(data, type, row) {
		            				if (type === 'display') {
		            					return getFormat(data,'d1')
		                			}
		                			return data;
	            				}
	        				},
	        				{ data: 'useYn'  ,      visible: true,  className: 'dt-body-center'  , width: '50px',   },
	        				{ data: 'updDttm',      visible: true,  className: 'dt-body-center'  , width: '100px',  },
	        				{ data: 'fileYn',       visible: true,  className: 'dt-body-center'  , width: '50px'  
	        				,render: function (data, type, row) 
	        				  {
	        			        if (type === 'display') {
	        			            if (data === 'Y') {
	        			                // 디스켓 아이콘 표시 (Font Awesome 사용 예)
	        			                return '<i class="fa fa-save" title="파일 있음" style="color: green;"></i>';
	        			            } else {
	        			                return ''; // 파일 없음은 공백 처리
	        			            }
	        			        }
	        			        return data; // 'display' 외 타입은 원본 데이터 반환
	        			      }  
	        				}
	        			  ];
		
		var s_CheckBox = true;   		           	 // CheckBox 표시 여부
        var s_AutoNums = true;   		             // 자동순번 표시 여부
        
		// 초기 data Sort,  없으면 []
		var muiltSorts = [
							['updDttm','desc' ]
        				 ];
        // Sort여부 표시를 일부만 할 때 개별 id, ** 전체 적용은 '_all'하면 됩니다. ** 전체 적용 안함은 []        				 
		var showSortNo = ['updDttm'];                   
		// Columns 숨김 columnsSet -> visible로 대체함 hideColums 보다 먼제 처리됨 ( visible를 선언하지 않으면 hideColums컬럼 적용됨 )	
		var hideColums = [notiSeq];             // 없으면 []; 일부 컬럼 숨길때		
		var txt_Markln = 20;                       				 // 컬럼의 글자수가 설정값보다 크면, 다음은 ...로 표시함
		// 글자수 제한표시를 일부만 할 때 개별 id, ** 전체 적용은 '_all'하면 됩니다. ** 전체 적용 안함은 []
		var markColums = ['notiTitle','notiContent'];
		var mousePoint = 'pointer';                				 // row 선택시 Mouse모양
		<!-- ============================================================== -->
		<!-- Table Setting End -->
		<!-- ============================================================== -->
	    
		let dt_com = new DataTransfer();
	    
		window.onload = function() { 
			find_Check();
		    comm_Check();
		};

		// find_data` 입력 필드에서 Enter 키 이벤트를 강제 실행하는 함수
		function triggerEnterKey() {
		    let findDataInput = document.getElementById("findData");
		    if (findDataInput) {
		        findDataInput.focus(); // 자동 포커스 설정
		        // 가짜 'Enter' 키 이벤트 생성하여 `findEnterKey()` 실행
		        let enterEvent = new KeyboardEvent("keyup", { key: "Enter" });
		        findDataInput.dispatchEvent(enterEvent);
		        console.log("🔍 Enter 키 자동 실행 완료!");
		    }
		}

		</script>
<!-- ============================================================== -->
<!-- 기본 초기화 End -->
<!-- ============================================================== -->

<!-- ============================================================== -->
<!-- 화면 Size변경 Start -->
<!-- ============================================================== -->
<script type="text/javascript">
		const fullscreenToggle = document.getElementById('fullscreenToggle');
		const fullscreenIcon   = document.getElementById('fullscreenIcon');
		
		fullscreenToggle.addEventListener('click', toggleFullscreen);
		
		function toggleFullscreen() {
			if (!document.fullscreenElement) {
				
				if (document.documentElement.requestFullscreen) {
				    document.documentElement.requestFullscreen();
				} else if (document.documentElement.webkitRequestFullscreen) {
				    document.documentElement.webkitRequestFullscreen();
				} else if (document.documentElement.msRequestFullscreen) {
				    document.documentElement.msRequestFullscreen();
				}
				fullscreenIcon.classList.replace('fa-expand', 'fa-compress');
			  
			} else {
				if (document.exitFullscreen) {
				    document.exitFullscreen();
				} else if (document.webkitExitFullscreen) {
				    document.webkitExitFullscreen();
				} else if (document.msExitFullscreen) {
				    document.msExitFullscreen();
				}
				fullscreenIcon.classList.replace('fa-compress', 'fa-expand');
			}
		}
		document.addEventListener('fullscreenchange', updateIcon);
		document.addEventListener('webkitfullscreenchange', updateIcon);
		document.addEventListener('msfullscreenchange', updateIcon);
		
		function updateIcon() {
		    if (document.fullscreenElement) {
		        fullscreenIcon.classList.replace('fa-expand', 'fa-compress');
		    } else {
		        fullscreenIcon.classList.replace('fa-compress', 'fa-expand');
		    }
		}
		</script>
<!-- ============================================================== -->
<!-- 화면 Size변경 End -->
<!-- ============================================================== -->

<!-- ============================================================== -->
<!-- modal Form 띄우기 Start -->
<!-- ============================================================== -->
<script type="text/javascript">
		function modal_key_hidden(flag) {	
	        const notiSeqInput     = document.getElementById("notiSeq");
	        const fileGbInput      = document.getElementById("fileGb");
	        const startDtInput      = document.getElementById("startDt");
	        const inputs = [notiSeqInput,fileGbInput,startDtInput];
	        if (flag !== 'I') {
		        const isReadOnly = flag !== 'I';
		        inputs.forEach(input => {
		            if (input) { // 요소가 존재하는지 확인
		                input.readOnly = isReadOnly;
		            }
		        });
		    }else{
		        const isReadOnly = flag == 'N';
		        inputs.forEach(input => {
		            if (input) { // 요소가 존재하는지 확인
		                input.readOnly = isReadOnly;
		            }
		        });		    	
		        now_check() ;
		    }
	        if (flag !== 'I') {
	            $(fileGbInput).css("pointer-events", "none").css("background-color", "#e9ecef"); // 비활성화된 느낌의 배경색 적용
	        } else {
	            $(fileGbInput).css("pointer-events", "").css("background-color", ""); // 활성화
	        }	        
		}
		function now_check() {
	        let today = new Date();
	        let formattedDate = today.getFullYear().toString() +
	                            ('0' + (today.getMonth() + 1)).slice(-2) +
	                            ('0' + today.getDate()).slice(-2);
	        document.getElementById('startDt').value = formattedDate;
	    };
		function modal_Open(flag) {	
		    //파일업로드후 초기화 
		    fileinput_clear() ;
		    
	    
			let modal_OpenFlag = true;
			
			const insertButton = document.getElementById('form_btn_ins');
		    const updateButton = document.getElementById('form_btn_udt');
		    const deleteButton = document.getElementById('form_btn_del');
    
		    // Hide all
		    insertButton.style.display = 'none';
		    updateButton.style.display = 'none';
		    deleteButton.style.display = 'none';
		    if (flag == 'I') {
		        document.getElementById("file-input").disabled = true;
		        document.querySelector(".btn-box").style.display = "none";
		        document.getElementById("drag-area").style.pointerEvents = "none";
		        document.getElementById("drag-area").style.opacity = 0.5;
		    } else {
		        document.getElementById("file-input").disabled = false;
		        document.querySelector(".btn-box").style.display = "inline-block";
		        document.getElementById("drag-area").style.pointerEvents = "auto";  // 고친 부분
		        document.getElementById("drag-area").style.opacity = 1;
		    }
		    
		    // Show button
		    switch (flag) {
		        case 'I': // Show Insert button
		            insertButton.style.display = 'inline-block';
		            modalHead.innerText  = "입력 모드입니다" ; 
		            break;
		        case 'U': // Show Update button
		            updateButton.style.display = 'inline-block';
		            modalHead.innerText  = "수정 모드입니다" ;
		            break;
		        case 'D': // Show Delete button
		            deleteButton.style.display = 'inline-block';
		            modalHead.innerText  = "삭제 모드입니다" ;
		            break;
		    }    
		    applyAuthControl(); //권한관리 (입력수정삭제 ) 모달뛰우기전 
		    formValClear(inputZone.id);
		    
			if (flag !== 'I'){ 
				// 수정.삭제 모드 (대상확인)
				if (edit_Data) {
					// Value Setting
					formValueSet(inputZone.id,edit_Data);
					modalName_rich(edit_Data.notiContent);
				} else {
					modal_OpenFlag = false;
					messageBox("1","<h5>작업 할 Data가 선택되지 않았습니다. !!</h5><p></p><br>",mainFocus,"","");			
					return null;
				}
	            showfileModal(document.getElementById("notiSeq").value, document.getElementById("fileGb").value);
			}else{
	            let tbody = document.querySelector("#fileTable tbody");
	            tbody.innerHTML = "";
	            modalName_rich("");
			}
				
			if (modal_OpenFlag) {
				// 모달을 드레그할 수 있도록 처리
			    // Make the DIV element draggable:	    
			    
				var element = document.querySelector('#' + modalName.id);
			    dragElement(element);
	            //수정시 키는 readonly
	            modal_key_hidden(flag) ;
	            
			    function dragElement(elmnt) {
			        var pos1 = 0, pos2 = 0, pos3 = 0, pos4 = 0;
			        // 어디든 클릭하여 움직여도 가능 (.modal-content)
			        // 타이틀 클릭하여 움직여만 가능 (.modal-header)
			        // 필요시 변경하여 사용하면 됨
			        if (elmnt.querySelector('.modal-header')) {
			            elmnt.querySelector('.modal-header').onmousedown = dragMouseDown;
			        } else {
			            elmnt.onmousedown = dragMouseDown;
			        }
			        function dragMouseDown(e) {
			            e = e || window.event;
			            //e.preventDefault(); // 기본 동작 방지1
			            pos3 = e.clientX;
			            pos4 = e.clientY;
			            document.onmouseup = closeDragElement;
			            document.onmousemove = elementDrag;
			        }
		
			        function elementDrag(e) {
			            e = e || window.event;
			            //e.preventDefault(); // 기본 동작 방지
			            pos1 = pos3 - e.clientX;
			            pos2 = pos4 - e.clientY;
			            pos3 = e.clientX;
			            pos4 = e.clientY;
			            elmnt.style.top  = (elmnt.offsetTop - pos2)  + "px";
			            elmnt.style.left = (elmnt.offsetLeft - pos1) + "px";
			        }
		
			        function closeDragElement() {
			            document.onmouseup = null;
			            document.onmousemove = null;
			        }
			    }
		
			    function centerModal() {
			        const modal = document.querySelector('#' + modalName.id);
			        modal.style.top  = "50%";
			        modal.style.left = "50%";
			        modal.style.transform = "translate(-50%, -50%)";
			    }
			    // 모달 띄울 때 항상 중앙에 위치
			    $("#" + modalName.id).on('show.bs.modal', function () {	    	
			        centerModal();
			        var firstFocus = $(this).find('input:first');
			        setTimeout(function () {
		     	        $("#" + firstFocus.attr('id')).focus();
			        }, 500); // 포커스 강제 설정
			    });
			    // 모달 창 크기가 변경될 때도 중앙에 유지
			    window.addEventListener('resize', centerModal);
			    // 모달 띄우기
			    $("#" + modalName.id).modal('show');   
			    
			    if (getCookie("s_userid")) {
			        inputZone.querySelector("[name='regUser']").value = getCookie("s_userid");
			        inputZone.querySelector("[name='updUser']").value = getCookie("s_userid");
			    }

			    if (getCookie("s_connip")) {
			        inputZone.querySelector("[name='regIp']").value = getCookie("s_connip");
			        inputZone.querySelector("[name='updIp']").value = getCookie("s_connip");
			    }  
			}
		}
		function fn_Potion() {
		    
			const modal = document.querySelector('#' + modalName.id);
		    modal.style.top  = "50%";
		    modal.style.left = "50%";
		    modal.style.transform = "translate(-50%, -50%)";    
		}
		</script>
<!-- ============================================================== -->
<!-- modal Form 띄우기 End -->
<!-- ============================================================== -->

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
				        // 페이지와 버튼 넓히기  
						//dom: showButton   ? '<"row"<"col-sm-2"l><"col-sm-2"B><"col-sm-5"><"col-sm-3"f>>t<"row mt-2"<"col-sm-7"i><"col-sm-5"p>>'
						//                  : '<"row"<"col-sm-2"l><"col-sm-7"><"col-sm-3"f>>t<"row mt-2"<"col-sm-7"i><"col-sm-5"p>>',
							// 페이지와 버튼 간격 좁히기 
						dom: showButton  
						        ? '<"datatable-controls d-flex align-items-center justify-content-between"<"d-flex"<"mr-2"l><"mr-2"B><"ml-auto"f>>>' +
						          't' +
						          '<"row mt-2"<"col-sm-7"i><"col-sm-5"p>>'
						        : '<"datatable-controls d-flex align-items-center justify-content-between"<"d-flex"<"mr-2"l><"ml-auto"f>>>' +
						          't' +
						          '<"row mt-2"<"col-sm-7"i><"col-sm-5"p>>',
	                        //
						                  
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
				        		                            ('0' + (d.getMonth() + 1)).slice(-2) + 
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
			    	
			    	messageBox("9","<h5>정말로 삭제하시겠습니까 ? 수가코드 : " + data.fee_code + " 입니다. </h5><p></p><br>",mainFocus,"","");
			    	confirmYes.addEventListener('click', () => {
			    		// Yes후 여기서 처리할 로직 구현
			    		
			    		// grid data 삭제
			    		dataTable.row($(this).parents('tr')).remove().draw();    		 
			    		messageDialog.hide();
			    		
			        });
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
				//더블클릭시 수정모드  
			    $('#' + tableName.id + ' tbody').on('dblclick', 'tr', function () {
			        let table = $('#' + tableName.id).DataTable();
			        let rowData = table.row(this).data(); // 해당 행 데이터 가져오기
			        modal_Open('U', rowData);
			    });
				//datatable(jquery) 옵션관련 label을 span 변환 
				 $(document).ready(function() {
	                 let replaceLabelWithSpan = function(forValue) {
	                     let $label = $("label[for='" + forValue + "']");
	                     if ($label.length) {
	                         let $span = $("<span>").html($label.html()).attr("id", $label.attr("for"));
	                         $label.replaceWith($span);
	                     }
	                 };

	                 replaceLabelWithSpan('dt-search-0');
	                 replaceLabelWithSpan('dt-length-0');
	                 replaceLabelWithSpan('dt-length-1');
	             });
			    
			})(jQuery);
			
		}	   
		
		//ajax 함수 정의
		function dataLoad(data, callback, settings) {
		
			// var table = $(settings.nTable).DataTable();
		    // table.processing(true); // 처리 중 상태 시작
				
		    let find = {};
		   	
		   	for (let findValue of findValues) {
		   		let key = findValue.id === "fileGb1" ? "fileGb" : findValue.id;
		   		find[key] = findValue.val;
		   	}
		   	
		    $.ajax({
		        type: "POST",
		        url: "/mangr/notiCdList.do",
		        data: find,
		        dataType: "json",
		        
		        // timeout: 10000, // 10초 후 타임아웃
		        beforeSend : function () {
		        	
				},
		        success: function(response) {
		        	// table.processing(false); // 처리 중 상태 종료
		            if (response && Object.keys(response).length > 0) {
		            	callback(response);
		            } else {
		            	callback([]); // 빈 배열을 콜백으로 전달
		            }
		        },
		        error: function(jqXHR, textStatus, errorThrown) {
		        	// table.processing(false); // 처리 중 상태 종료		                    
		            callback({
		                data: []
		            });
		            // table.clear().draw(); // 테이블 초기화 및 다시 그리기
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
<!-- 입력, 수정, 삭제 Start -->
<!-- ============================================================== -->
<script type="text/javascript">
		//Modal Form에서 입력
		//일력값 오류체크및 서버데이타전달(json) 
		function validateForm() {
		    const results = formValCheck(inputZone.id, {
		    	//notiSeq:     { kname: "등록순서", k_min: 3, k_max: 10, k_req: true, k_spc: true, k_clr: true },
		    	//fileGb:     { kname: "구분", k_req: true },
		    	notiTitle:     { kname: "공지제목", k_req: true },
		    	notiContent:   { kname: "공지내용", k_req: true },
		    	startDt:       { kname: "시작일",  k_req: true },
		    	endDt:         { kname: "종료일",  k_req: true },
		    	useYn:         { kname: "사용여부", k_req: true }
		    });
		    return results;
		}
		//그리드상 데이타생성및 수정 작업
		function newuptData() {
        	let newData = {
       			notiSeq:      $('#notiSeq').val(),
       			fileGb:       $('#fileGb').val(),
       			subCodeNm:    $('#subCodeNm').val(),
       			notiTitle:    $('#notiTitle').val(),
       			notiContent:  $('#notiContent').val(),
        		startDt:      $('#startDt').val(),
        		endDt:        $('#endDt').val(),
        		useYn:        $('#useYn').val(),
        		updDttm :     $('#updDttm').val(),
        		fileYn :      $('#fileYn').val()
			    };
		    return newData;
		}	
		// 페이지 로드 시 자동 적용(입력시 참고인덱스한것 가져오는 조건 )
		window.addEventListener('DOMContentLoaded', function() {
		    var select = document.getElementById('fileGb');
		    document.getElementById('subCodeNm').value = select.options[select.selectedIndex].text;
		});
		// 사용자가 선택을 변경할 때 적용
		document.getElementById('fileGb').addEventListener('change', function() {
		    document.getElementById('subCodeNm').value = this.options[this.selectedIndex].text;
		});		
		function fn_Insert(){
			const results = validateForm();
			if (results)
			{
				let dats = [];
				let data = {};
		        results.forEach(result => {
		        	if (format_convert.length > 0) {
		        		if (format_convert.includes(result.id)) {
				            data[result.id] = replaceMulti(result.val,'-','/');		        		
			        	}else{
			        		data[result.id] = result.val;
			        	}
		        	}else{
		        		data[result.id] = result.val;
		        	}	
		        });
				
		        dats.push(data);	    
			    $.ajax({
			            type: "POST",
			            url: "/mangr/notiCdInsert.do",
			            data: JSON.stringify(dats),
			            contentType: "application/json",
			    	    dataType: "json",
			            success: function(response) {
			            	// checkbox, 자동순번은 넣지 않습니다.
			            	// *******단, 나머지 컬럼은 반드시 기술해야 합니다. 
			            	let newData = newuptData();
			            	dataTable.row.add(newData).draw(false);
			            	messageBox("1","<h5> 정상처리 되었습니다 ...... </h5><p></p><br>",mainFocus,"","");	            	
			            	$("#" + modalName.id).modal('hide');
			            	
			        	},
			        	error: function(xhr, status, error) {
				         	switch (xhr.status){  
				         	     case 500: messageBox("5","<h5>서버에 문제가 발생했습니다.</h5>" +  
			                               "<h6>잠시후 다시, 시도해주십시요. !!</h6>",mainFocus,"","");
				        		    break;
				         	     case 400:
				        		    messageBox("5","<h5>기존자료가 존재합니다.</h5>" +  
			                               "<h6>다시 확인하고, 시도해주십시요. !!</h6>",mainFocus,"","");
				        		    break;
				        		 defalut:  
				                     messageBox("5", "<h5>알 수 없는 오류가 발생했습니다.</h5>" +  
			                                   "<h6>관리자에게 문의하세요.</h6>", mainFocus, "", "");
			                        break;
				        		end    
				           	}
			        	}	
			    });
			}
		}

		// Modal Form에서 수정
		function fn_Update() {
		    // 1. 입력값 검증 및 유효성 검사
            const results = validateForm();
		    if (results) {
		        // 2. 데이터 수집
		        let data = {};
		        results.forEach(result => {
		        	if (format_convert.length > 0) {
		        		if (format_convert.includes(result.id)) {
				            data[result.id] = replaceMulti(result.val,'-','/');		        		
			        	}else{
			        		data[result.id] = result.val;
			        	}
		        	}else{
		        		data[result.id] = result.val;
		        	}	
  	
		        });
		
		        // 3. 선택된 행의 Primary Key 가져오기
		        var selectedRows = dataTable.rows('.selected');
		        let keys = dataTableKeys(dataTable, selectedRows);
		
		        // 4. Primary Key와 입력 데이터 병합 (배열로 만들어 서버에 전송)
		        let mergeData = keys.map(key => ({ ...data, ...key }));
		        // 5. AJAX로 서버 업데이트 요청
		        $.ajax({
		            type: "POST",
		            url: "/mangr/notiCdUpdate.do",
		            data: JSON.stringify(mergeData), // JSON 변환
		            contentType: "application/json",
		            dataType: "json",
		            success: function(response) {
		                console.log("업데이트 성공", response);
		                // 6. DataTable에 변경된 값 반영
		                let updatedData = newuptData();		                

		                selectedRows.every(function(rowIdx) {
		                    let rowData = this.data();
		                    Object.keys(updatedData).forEach(function(key) {
		                    	rowData[key] = updatedData[key];
		                    });
		                    this.data(rowData);
		                });
		
		                dataTable.draw(false);
		                
		                // 7. 모달 닫기 및 성공 메시지 표시
		                $("#" + modalName.id).modal('hide');
		                messageBox("1", "<h5> 정상적으로 업데이트되었습니다. </h5>", mainFocus, "", "");
		            },
		            error: function(xhr, status, error) {
		                console.error("업데이트 실패", xhr.responseText);
		                messageBox("5", "<h5>서버에 문제가 발생했습니다.</h5><h6>잠시 후 다시 시도해주세요.</h6>", mainFocus, "", "");
		            }
		        });
		    }
		}

		// Modal Form에서 삭제
		function fn_Delete(){
			let isKey = false;
			// success:  성공 또는 완료를 나타내는 녹색 체크 마크 아이콘
			// error:    오류나 실패를 나타내는 빨간색 X 아이콘
			// warning:  주의나 경고를 나타내는 노란색 느낌표 아이콘
			// info:     정보를 나타내는 파란색 i 아이콘
			// question: 질문이나 확인을 나타내는 파란색 물음표 아이콘	
			Swal.fire({title:'삭제여부',text:'정말 삭제 하시겠습니까 ?', icon:'question' ,
					   showCancelButton:true,confirmButtonText:'예',cancelButtonText:'아니오',
					   customClass: {
						   popup: 'small-swal'}
			     }).then((result) => {
				// 사용자가 '예' 버튼을 클릭한 경우
				let data = {};
				if (result.isConfirmed) {
					// (수정.삭제 primaryKey로 조회)			
				    // primaryKey로 설정된 컬럼 찾기 
				    var selectedRows = dataTable.rows('.selected');
					let keys = dataTableKeys(dataTable, selectedRows);
					if (keys.length > 0) {	        	
						$.ajax({
				            type: "POST",
				            url: "/mangr/notiCdDelete.do",	    	    
				    	    data: JSON.stringify(keys),	    	    
				    	    contentType: "application/json",
				    	    dataType: "json",
				            success: function(response) {
				            	Swal.fire({
						            title: '처리확인',
						            text:  '정상처리 되었습니다. ',
						            icon:  'success',
						            confirmButtonText: '확인',
						            timer: 1500, // 1.5초후 없어짐
						            timerProgressBar: true,
						            showConfirmButton: false,
						            customClass: {
										   popup: 'small-swal'}
						        });
							    // 선택된 행 삭제
							    selectedRows.remove().draw();
							    // 삭제 후 선택 초기화
							    selectedRow = null; 
							    $("#" + modalName.id).modal('hide');
		
				        	},
				        	error: function(xhr, status, error) {
				        		Swal.fire({
						            title: '에러확인',
						            text:  '문제 발생, 잠시후 다시 하십시요.',
						            icon:  'error',
						            confirmButtonText: '확인',
						            timer: 1500, // 1.5초후 없어짐
						            timerProgressBar: true,
						            showConfirmButton: false,
						            customClass: {
										   popup: 'small-swal'}
						        });
				        	}
					    });
							
					} else {
						Swal.fire({
				            title: '오류확인',
				            text:  '삭제 Key가 존재하지 않습니다. ',
				            icon:  'warning',
				            confirmButtonText: '확인',
				            timer: 1500, // 1.5초후 없어짐
				            timerProgressBar: true,
				            showConfirmButton: false ,
				            customClass: {
								   popup: 'small-swal'}
				        });
					}
				
				} else if (result.isDismissed) {
					Swal.fire({
			            title: '취소확인',
			            text:  '작업이 취소 되었습니다. ',
			            icon:  'info',
			            confirmButtonText: '확인',
			            timer: 1000, // 1.5초후 없어짐
			            timerProgressBar: true,
			            showConfirmButton: false ,
			            customClass: {
							   popup: 'small-swal'}
			        });
				}
			});
		}
		// Check된 자료 찾아 삭제
		function fn_findchk(){
			let isKey = false; 	    
		 	// success:  성공 또는 완료를 나타내는 녹색 체크 마크 아이콘
			// error:    오류나 실패를 나타내는 빨간색 X 아이콘
			// warning:  주의나 경고를 나타내는 노란색 느낌표 아이콘
			// info:     정보를 나타내는 파란색 i 아이콘
			// question: 질문이나 확인을 나타내는 파란색 물음표 아이콘	
			Swal.fire({title:'삭제여부',text:'정말 삭제 하시겠습니까 ?', 
				       icon:'question' ,
					   showCancelButton:true,confirmButtonText:'예',cancelButtonText:'아니오',
					   customClass: {
						   popup: 'small-swal'}
			          }).then((result) => {

               	  // 사용자가 '예' 버튼을 클릭한 경우
				if (result.isConfirmed) {
					// 체크박스가 ':checked'인 행만 선택
					let selectedRows = dataTable.rows(function (idx, data, node) {
					    let $row = $(node); // 현재 행의 DOM 노드
					    let $checkbox = $row.find('input[type="checkbox"]'); // 체크박스 찾기
					    return $checkbox.is(':checked'); // 체크된 행만 필터링
					});
					
					let keys = dataTableKeys(dataTable, selectedRows);
					
			        if (keys.length > 0) {
						$.ajax({
				            type: "POST",
				            url: "/mangr/notiCdDelete.do",	    	    
				    	    data: JSON.stringify(keys),	    	    
				    	    contentType: "application/json",
				    	    dataType: "json",
				            success: function(response) {
				            	Swal.fire({
						            title: '처리확인',
						            text:  '정상처리 되었습니다. ',
						            icon:  'success',
						            confirmButtonText: '확인',
						            timer: 1500, // 1.5초후 없어짐
						            timerProgressBar: true,
						            showConfirmButton: false ,
						            customClass: {
										   popup: 'small-swal'}
						        });
				            	// 선택된 행 삭제
							    selectedRows.remove().draw();
							    // 삭제 후 선택 초기화
							    selectedRow = null; 
				        	},
				        	error: function(xhr, status, error) {
				        		Swal.fire({
						            title: '에러확인',
						            text:  '문제 발생, 잠시후 다시 하십시요.',
						            icon:  'error',
						            confirmButtonText: '확인',
						            timer: 1500, // 1.5초후 없어짐
						            timerProgressBar: true,
						            showConfirmButton: false ,
						            customClass: {
										   popup: 'small-swal'}
						        });
				        	}
					    });
							
					} else {
						
						Swal.fire({
				            title: '오류확인',
				            text:  '삭제 Key가 존재하지 않습니다. ',
				            icon:  'warning',
				            confirmButtonText: '확인',
				            timer: 1500, // 1.5초후 없어짐
				            timerProgressBar: true,
				            showConfirmButton: false ,
				            customClass: {
								   popup: 'small-swal'}
				        });
					}
			        
			          
				
				
				} else if (result.isDismissed) {
					Swal.fire({
			            title: '취소확인',
			            text:  '작업이 취소 되었습니다. ',
			            icon:  'info',
			            confirmButtonText: '확인',
			            timer: 1500, // 1.5초후 없어짐
			            timerProgressBar: true,
			            showConfirmButton: false ,
			            customClass: {
							   popup: 'small-swal'}
			        });
				}
			});
		}
		</script>
<!-- ============================================================== -->
<!-- 입력, 수정, 삭제 End -->
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
				   	
				        const commList = response.data || [];
				        
				        for (var i = 0; i < select_id.length; i++) {
				            
				        	let select = $('#' + select_id[i]);
				            select.empty();
				            
				            let filteredItems = commList.filter(item => 
				                item.codeCd === list_code[i] && item.subCode !== 'C'  //계약관련는 제외 
				            );
				            
				            if (filteredItems.length > 0) {
				            	if (firstnull[i] === "Y")
				            		select.append('<option value="">선택</option>');
				            		
				            	filteredItems.forEach(function (item) {
				                    select.append('<option value=' + item.subCode + '>' + item.subCodeNm + '</option>');
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
       	        th.textContent = header; // 텍스트만 추가
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
		function findField(element) {
			
			const index = findValues.findIndex(item => item.id === element.id);
		
			if (index !== -1) {
			    findValues[index].val = element.value;
			} else {
			    findValues.push({ id: element.id, val: element.value });
			}
		}
		// 조회 조건에서 input Field가 있으면 EnterKey 후 검색 (단, input Field에서 함수 호출 해야됨)
		function findEnterKey() {
		    if (event.key === 'Enter') {
		    	fn_FindData(); 
		    }
		}
		// 파일 업로드 기능
		document.addEventListener("DOMContentLoaded", function () {
		    const dragArea = document.getElementById("drag-area");
		    const fileInput = document.getElementById("file-input");
		    const fileList = document.getElementById("file-list");
		
		    // 📌 파일 선택 버튼 클릭 시, 숨겨진 file-input을 클릭하도록 트리거
		    function openFileInput() {
		        fileInput.click();
		    }
		
		    // 📌 파일 변경 이벤트 핸들러 (파일이 선택되면 목록에 표시)
		    function changeHandler(event) {
		        let files = event.target.files;
		        handleFiles(files);
		    }
		
		    // 📌 파일 드래그 오버 이벤트 (파일이 드래그되면 스타일 변경)
		    function dragOverHandler(event) {
		        event.preventDefault();
		        dragArea.style.border = "2px dashed #007bff";
		    }
		
		    // 📌 파일 드래그 리브 이벤트 (드래그 해제 시 원래 스타일로 복귀)
		    function dragLeaveHandler(event) {
		        event.preventDefault();
		        dragArea.style.border = "2px dashed #ccc";
		    }
		
		    // 📌 파일 드롭 이벤트 (파일이 드롭되면 입력 필드에 추가)
		    function dropHandler(event) {
		        event.preventDefault();
		        dragArea.style.border = "2px dashed #ccc";
		
		        let dt = new DataTransfer(); // DataTransfer 객체 생성
		        for (let file of event.dataTransfer.files) {
		            dt.items.add(file);
		        }
		
		        fileInput.files = dt.files; // 파일 리스트를 file input에 설정
		        handleFiles(event.dataTransfer.files);
		    }
		    

		    
		    function handleFiles(files) {
		    	// ✅ 새로 추가된 파일을 DataTransfer에 추가
		    	for (let k = 0; k < files.length; k++) {
		            const file = files[k];
		            // ✅ 중복 체크
		            if (!fileExists(file.name, dt_com.files)) {  
		                const fileItem = document.createElement("div");
		                fileItem.classList.add("file-item");
		                fileItem.textContent = file.name;
		                const deleteBtn = document.createElement("button");
		                deleteBtn.textContent = "삭제";
		                deleteBtn.classList.add("delete-btn");
		                deleteBtn.style.marginLeft = "10px";
		                // ✅ 삭제 버튼 클릭 시 파일 삭제
		                deleteBtn.addEventListener("click", function () {
		                    removeFile(file.name);
		                    fileItem.remove(); // ✅ UI에서도 제거
		                    dt_com.items.remove(k); 
		                });
		                dt_com.items.add(file); // ✅ 새로운 파일 추가
		                fileItem.appendChild(deleteBtn);
		                fileList.appendChild(fileItem);
		            } else {
		                console.warn(`⚠ 중복 파일 감지됨: ${file.name}`);
		            }
		        }
		        console.log("📌 최종 추가된 파일 개수:", dt_com.files.length);
		        
		        // ✅ 기존 fileInput을 직접 업데이트 (새로운 input을 만들지 않음)
			    updateFileInput(dt_com.files); //파일등록 초기화되지않는문제 로 마킹 (누적현상)
		        
		        console.log("📌 fileInput.files 업데이트 후 개수:", fileInput.files.length);
		        
		        saveFileListToStorage();
		    }
		    function updateFileInput(files) {
		        // dt 객체의 items를 새로운 파일 리스트로 설정
		        let dt_com = new DataTransfer();
		        for (let i = 0; i < files.length; i++) {
		        	dt_com.items.add(files[i]);
		        }

		        // ✅ 실제 fileInput의 files를 새로 설정
		        fileInput.files = dt_com.files;
		    }

		    // 📌 파일이 이미 존재하는지 확인하는 함수
 		    function fileExists(fileName) {
		        const fileItems = document.querySelectorAll(".file-item");
		        return Array.from(fileItems).some(item => item.textContent.includes(fileName));
		    }  
		    
			function removeFile(fileName) {
			    let dt = new DataTransfer();
			    // ✅ 삭제되지 않은 파일만 유지
			    for (let i = 0; i < fileInput.files.length; i++) {
			        if (fileInput.files[i].name !== fileName) {
			            dt.items.add(fileInput.files[i]);
			        }
			    }
			    fileInput.files = dt.files; // ✅ 변경된 파일 리스트 반영
			    saveFileListToStorage(); // ✅ LocalStorage 업데이트 (선택사항)
			}		
	
		    // 📌 파일 목록을 LocalStorage에 저장하는 함수
		    function saveFileListToStorage() {
		        const fileItems = document.querySelectorAll(".file-item");
		        const fileNames = Array.from(fileItems).map(item => item.textContent.replace("삭제", "").trim());
		        localStorage.setItem("fileList", JSON.stringify(fileNames));
		    }
		
		    // 📌 LocalStorage에서 파일 목록을 불러와 UI에 추가하는 함수
		    function loadFileListFromStorage() {
		        const savedFileList = JSON.parse(localStorage.getItem("fileList") || "[]");
		
		        savedFileList.forEach(fileName => {
		            if (!fileExists(fileName)) {
		                const fileItem = document.createElement("div");
		                fileItem.classList.add("file-item");
		                fileItem.textContent = fileName;
		
		                const deleteBtn = document.createElement("button");
		                deleteBtn.textContent = "삭제";
		                deleteBtn.classList.add("delete-btn");
		                deleteBtn.style.marginLeft = "10px";
		                deleteBtn.addEventListener("click", function () {
		                    fileItem.remove();
		                    saveFileListToStorage();
		                });
		
		                fileItem.appendChild(deleteBtn);
		                fileList.appendChild(fileItem);
		            }
		        });
		    }
		
		    // 📌 이벤트 리스너 등록
		    dragArea.addEventListener("dragover", dragOverHandler);
		    dragArea.addEventListener("dragleave", dragLeaveHandler);
		    dragArea.addEventListener("drop", dropHandler);
		    fileInput.addEventListener("change", changeHandler);
		
		    // 📌 페이지 로드 시 LocalStorage에서 파일 목록 불러오기
		    loadFileListFromStorage();
		
		    // 📌 파일 선택 버튼이 있으면 이벤트 리스너 추가
		    const fileSelectButton = document.querySelector(".btn-primary");
		    if (fileSelectButton) {
		        fileSelectButton.addEventListener("click", openFileInput);
		    }
		});
		// ✅ 파일문서 초기화
		function fileinput_clear() {
		    const fileInput = document.getElementById("file-input");
		    const fileList = document.getElementById("file-list");
		    const fileNameDisplay = document.getElementById("file-name-display");

		    dt_com = new DataTransfer();

		 // input 요소의 files 속성에 빈 DataTransfer 적용
		    fileInput.files = dt_com.files;
		    // ✅ UI 초기화
		    fileList.innerHTML = "";
		    fileNameDisplay.innerText = "";

		    // ✅ 로컬스토리지도 초기화 (필요시)
		    localStorage.removeItem("fileList");

		    console.log("🧹 파일 초기화 완료 → 남은 파일 수:", dt_com.files.length);
		}

		//파일문서 업로드 부분(다중처리)
		document.getElementById("uploadForm").addEventListener("submit", function (event) {
		    event.preventDefault(); // 기본 제출 방지

		    let fileInput     = document.getElementById("file-input"); 
		    let statusDisplay = document.getElementById("file-name-display");

		    if (!fileInput.files.length) {
		        alert("📌 파일을 선택해주세요!");
		        return;
		    }
		    let formData = new FormData();
		    // ✅ 다중 파일 추가 (서버에서 `files`로 받도록 수정)
		    for (let i = 0; i < fileInput.files.length; i++) {
		        formData.append("file", fileInput.files[i]); 
		    }
		    // ✅ 추가 폼 데이터 설정
		    
		    let hospcd   =  document.getElementById("hospCd").value;
		    let notiseq  =  document.getElementById("notiSeq").value;
		    let filegb   =  document.getElementById("fileGb").value;
		    let reguser  =  document.getElementById("regUser").value;
		    let regip    =  document.getElementById("regIp").value;
		    formData.append("action" , "upload");
		    formData.append("hospCd" , hospcd); // 병원 코드
		    formData.append("notiSeq", notiseq); // 공시사항 번호
		    formData.append("fileGb" , filegb); // 1: 공시사항, 2: 심사방, 3: 소식지  
		    formData.append("regUser", reguser);
		    formData.append("regIp"  , regip);

		    console.log("📌 FormData 확인:");
		    for (let pair of formData.entries()) {
		        console.log(`🔹 Key: ${pair[0]}, Value:`, pair[1]);
		    }       
		    fetch("/sftp/fileupload.do", {
		        method: "POST",
		        body: formData
		    })
		    .then(response => {
		        if (!response.ok) {
		            throw new Error(`서버 오류: ${response.status}`);
		        }
		        return response.text();
		    })
		    .then(data => {
		        fileInput.value = "";
		        console.log("✅ 파일 업로드 성공:", data);
		        statusDisplay.textContent = "✅ 업로드 성공!";
		        statusDisplay.style.color = "green";
		        
		        fileinput_clear() //파일문서초기화 
		        
		        showfileModal(document.getElementById("notiSeq").value, document.getElementById("fileGb").value);
		    })
		    .catch(error => {
		        console.error("❌ 파일 업로드 실패:", error);
		        statusDisplay.textContent = "❌ 업로드 실패!";
		        statusDisplay.style.color = "red";
		    });
		}); 
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
		            { title: "삭제",     className: "text-center", width: '100px' },
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
		                tbody.innerHTML = "<tr><td colspan='8' style='text-align: center;'>등록된 파일이 없습니다.</td></tr>";
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

		                if (fileUrl !== "#") {
		                    // ✅ 삭제 버튼
		                    tableBody += "<td style='text-align: center; vertical-align: middle;'>";
		                    tableBody += "<a href='#' class='btn btn-link delete-file' " +
		                                 "data-filepath ='" + doc.filePath     + "' " +
		                                 "data-filetitle='" + doc.fileTitle    + "' " +
		                                 "data-filegb   ='" + doc.fileGb       + "' " +
		                                 "data-fileseq  ='" + doc.fileSeq      + "'>"; // fileSeq가 notiSeq인 경우
		                    tableBody += "<i class='fa-solid fa-trash' style='font-size: 1.2em; color: black;'></i>";
		                    tableBody += "</a>";
		                    tableBody += "</td>";

		                    // ✅ 다운로드 버튼
		                    tableBody += "<td style='text-align: center; vertical-align: middle;'>";
		                    tableBody += "<a href='" + fileUrl + "' download='" + fileTitle + "' " +
		                                 "class='btn btn-link file-download' title='다운로드'>" +
		                                 "<i class='fa-solid fa-floppy-disk' style='font-size: 1.2em; color: green; margin-right: 10px;'></i>" +
		                                 "</a>";
		                    tableBody += "</td>";
		                } else {
		                    // 파일 없을 때
		                    tableBody += "<td colspan='2' style='text-align: center; color: black;'>❌ 파일 없음</td>";
		                }
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
		$(document).on("click", ".file-download", function (e) {
		    const fileUrl = $(this).attr("href");
		    const fileTitle = $(this).attr("download");
		
		    if (!fileUrl.startsWith("/sftp/download.do")) {
		        alert("❌ 유효하지 않은 다운로드 경로입니다.");
		        e.preventDefault();
		    } else {
		        console.log("⬇️ 다운로드 시작: " + fileTitle);
		        // 기본 다운로드 동작이므로 굳이 loadFileContent() 호출할 필요 없음
		    }
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

	// ✅ 삭제 버튼 클릭 시
	$(document).on("click", ".delete-file", function (e) {
	    e.preventDefault();
	
	    const filePath  = $(this).data("filepath");
	    const fileTitle = $(this).data("filetitle");
	    const fileSeq   = $(this).data("fileseq");
	    const fileGb    = $(this).data("filegb");
	    const updUser   = document.getElementById("updUser").value;
	    const updIp     = document.getElementById("updIp").value;
	
	    Swal.fire({
	        title: '삭제 확인',
	        text: '파일 "' + fileTitle + '" 을(를) 삭제하시겠습니까?',
	        icon: 'question',
	        showCancelButton: true,
	        confirmButtonText: '예',
	        cancelButtonText: '아니오',
	        customClass: {
	            popup: 'small-swal'
	        }
		    }).then((result) => {
		        if (result.isConfirmed) {
		            $.ajax({
		                type: "POST",
		                url: "/sftp/deleteFile.do",
		                data: {
		                	hospCd   : "" ,
		                    filePath : filePath,
		                    fileTitle: fileTitle,
		                    fileSeq  : fileSeq,
		                    fileGb   : fileGb,
		                    updUser  : updUser,
		                    updIp    : updIp
		                },
		                success: function (res) {
		                    showfileModal(fileSeq, fileGb); // 필요에 맞게 값 지정
		                },
		                error: function (xhr, status, error) {
		                    console.error("❌ 삭제 실패:", status, error);
		                }
		            });
		        }
		    });
	});
	function modalMainClose() {
		$("#" + modalName.id).modal('hide');
	}
	//권한조건체크 applyAuthControl.js
    document.addEventListener("DOMContentLoaded", function() {
        applyAuthControl();
    });
	function modalName_rich(answerText) {
		  // answerText가 null/undefined일 경우 빈 문자열로 초기화
		  let safeAnswer = (answerText || '');
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
		        // 폰트 크기
		        $('#notiContent').next().find('.note-editable').css('font-size', '14px');
		        // 줄바꿈 유지된 내용 적용
		        $('#notiContent').summernote('code', convertedAnswer);
		      }
		    }
		  });
		}


		// 모달이 닫힐 때 두 에디터 제거
		$('#modalName').on('hidden.bs.modal', function () {
		  $('#notiContent').summernote('destroy');
		});
	
	</script>
<!-- ============================================================== -->
<!-- 기타 정보 End -->
<!-- ============================================================== -->
