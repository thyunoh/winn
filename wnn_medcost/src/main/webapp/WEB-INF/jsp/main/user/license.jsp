<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>  
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="decorator" uri="http://www.opensymphony.com/sitemesh/decorator" %>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/page" prefix="page" %>
<%@ page import ="java.util.Date" %>
<link href="/css/winmc/bootstrap.css"     rel="stylesheet">
<link href="/css/winmc/style.css?v=123"   rel="stylesheet">
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
 		                            <div class="col-1 col-lg-1"> 
 			                         <input id="hospCd1" name="hospCd1" type="text" readonly class="form-control is-invalid text-left" required placeholder="">
			                        </div> 
                                    <div class="col-sm-3">
                                        <div class="input-group">
                                             <input id="findData" type="text" class="form-control" placeholder="3글자이상 입력 후 [enter]" 
                                                                                                 onkeyup="findEnterKey()" oninput="findField(this)">
											<span style="margin-left: 20px; margin-top: 5px; ">
											  <input type="checkbox" id="checkValue" name="checkValue">
											  근무 미지정자
											</span>
                                             <div class="input-group-append" style="margin-left: 20px;">
                                                 <button type="button" class="btn btn-rounded btn-primary"  onClick="fn_FindData()">조회. <i class="fas fa-search"></i></button>
                                             </div>
                                        </div>
                                        
                                    </div>      
                 
                                    <div class="col-sm-6">                                    
                                         <div class="btn-group ml-auto">
                                            <button class="btn btn-outline-dark" data-toggle="tooltip" data-placement="top" title="" onClick="license_load()">라이센스 가져오기<i class="fas fa-binoculars"></i></button>
                                            <button class="btn btn-outline-dark" data-toggle="tooltip" data-placement="top" style = "margin-left :20px" title="" onClick="fn_re_load()">재조회. <i class="fas fa-binoculars"></i></button>
                                            <button id="btnInsert"  class="btn btn-outline-dark btn-insert" data-toggle="tooltip" data-placement="top" title="신규 Data 입력" onClick="modal_Open('I')">입력. <i class="far fa-edit"></i></button>                                            
                                            <button id="btnUpdate"  class="btn btn-outline-dark btn-update" data-toggle="tooltip" data-placement="top" title="선택 Data 수정" onClick="modal_Open('U')">수정. <i class="far fa-save"></i></button>                                            
                                            <button id="btnDelete"  class="btn btn-outline-dark btn-delete" data-toggle="tooltip" data-placement="top" title="선택 Data 삭제" onClick="modal_Open('D')">삭제. <i class="far fa-trash-alt"></i></button>                                             
                                            <button id="btnSearchDelete"  class="btn btn-outline-dark btn-delete" data-toggle="tooltip" data-placement="top" title="체크 Data 삭제" onClick="fn_findchk()">선택삭제. <i class="far fa-calendar-check"></i></button>
                                            <button class="btn btn-outline-dark" data-toggle="tooltip" data-placement="top" title="화면 Size 확대.축소" id="fullscreenToggle">화면확장축소. <i class="fas fa-expand" id="fullscreenIcon"></i></button>
                                        </div>
                                    </div>
                                </div>
								<div style="width: 100%;">							    
								    <table id="tableName" class="display nowrap stripe hover cell-border  order-column responsive">
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
		<div class="modal fade" id="modalName" tabindex="-1"
			data-backdrop="static" role="dialog" aria-hidden="false"
			data-keyboard="false">
			<div class="modal-dialog modal-dialog-centered modal-dialog-scrollable"
				role="dialog"
				style="position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); width: 50vw; max-width: 50vw; max-height: 50vh;">
				<div class="modal-content"
					style="height: 60%; display: flex; flex-direction: column;">
					<div class="modal-header bg-light">
						<h6 class="modal-title" id="modalHead"></h6>
						<!-- ============================================================== -->
						<!-- button start -->
						<!-- ============================================================== -->
						<div class="form-row">
							<div class="col-sm-12 mb-2" style="text-align: right;">
								<button id="form_btn_new" type="submit"
									class="btn btn-outline-dark" onClick="fn_Potion()">센터. <i class="far fa-object-group"></i>
								</button>
								<button id="form_btn_ins" type="submit"
									class="btn btn-outline-info btn-insert"    onClick="fn_Insert()">입력. <i class="far fa-edit"></i>
								</button>
								<button id="form_btn_udt" type="submit"
									class="btn btn-outline-success btn-update" onClick="fn_Update()">수정. <i class="far fa-save"></i>
								</button>
								<button id="form_btn_del" type="submit"
									class="btn btn-outline-danger btn-delete"  onClick="fn_Delete()">삭제. <i class="far fa-trash-alt"></i>
								</button>
								<button type="button" class="btn btn-outline-dark"
									data-dismiss="modal" onClick="closeMainModal()">닫기 <i class="fas fa-times"></i>
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
							<input type="hidden" id="hospNm"      name="hospNm" value="">
							<input type="hidden" id="subCodeNm"   name="subCodeNm" value="">
							<input type="hidden" id="updUserNnm"  name="updUserNnm" value="">
							<input type="hidden" id="regUser"     name="regUser" value="">
							<input type="hidden" id="updUser"     name="updUser" value="">
							<input type="hidden" id="regIp"       name="regIp" value=""> 
							<input type="hidden" id="updIp"       name="updIp" value="">
							<div class="form-group row ">
								<label for="hospCd" class="col-2 col-lg-2 col-form-label text-left">요양기관</label>
								<div class="col-4 col-lg-4">
                                   <div class="input-group">								
								 	<input id="hospCd" name="hospCd" type="text"
					    				class="form-control text-left" placeholder="요양기관를 등록하세요">
										<button id = "hospserch"    class="btn btn-outline-info" "><i class="fas fa-search">검색</i>
										</button>
								   </div>	
								</div>	
								<label for="licNum"	class="col-2 col-lg-2 col-form-label text-left">면허번호</label>
								<div class="col-4 col-lg-4">	
									<input id="licNum" name="licNum" type="text"
									class="form-control text-left" placeholder="면허번호 입력하세요">
						    	</div>
							</div>
							<div class="form-group row ">
								<div class="input-group">
									<label for="ipDt"
										class="col-2 col-lg-2 col-form-label text-left">입사일자</label>
									<div class="col-4 col-lg-4">
										<input id="ipDt" name="ipDt" type="text"
											class="form-control date1-inputmask" required
											placeholder="yyyy-mm-dd">
									</div>
									<label for="teDt" class="col-2 col-lg-2 col-form-label text-left">퇴사일자</label>
									<div class="col-4 col-lg-4">
										<input id="teDt" name="teDt" type="text"
											class="form-control date1-inputmask" required
											placeholder="yyyy-mm-dd">
									</div>
								</div>
							</div>
							<div class="form-group row ">
								<label for="userNm"	class="col-2 col-lg-2 col-form-label text-left">성명</label>
								<div class="col-4 col-lg-4">
									<input id="userNm" name="userNm" type="text"
										class="form-control text-left" placeholder="사용자명을 입력하세요">
								</div>
								<label for="licType"
									class="col-2 col-lg-2 col-form-label text-left">면허구분</label>
								<div class="col-4 col-lg-4">
									<select id="licType" name="licType" class="custom-select"
										oninput="findField(this)" style="height: 35px; font-size: 14px;">
										<option selected value="">구분 1</option>
									</select>
								</div>
		
							</div>
							<div class="form-group row ">
								<label for=licDetail
									class="col-2 col-lg-2 col-form-label text-left">면허세부내용</label>
								<div class="col-4 col-lg-4">
									<input id="licDetail" name="licDetail" type="text"
										class="form-control text-left" placeholder="면허세부내용를 입력하세요">
								</div>
								<label for=weekHours
									class="col-2 col-lg-2 col-form-label text-left">근무시간</label>
								<div class="col-4 col-lg-4">
									<input id="weekHours" name="weekHours" type="text"
										class="form-control text-left" placeholder="근무시간를 입력하세요">
								</div>
							</div>
                            <div class="form-group row ">
								<label for=deptCode
									class="col-2 col-lg-2 col-form-label text-left">진료과</label>
								<div class="col-4 col-lg-4">
									<input id="deptCode" name="deptCode" type="text"
										class="form-control text-left" placeholder="진료과를 입력하세요">
								</div>
								<label for="useYn"
									class="col-2 col-lg-2 col-form-label text-left">사용구분</label>
								<div class="col-4 col-lg-4">
									<select id="useYn" name="useYn" class="custom-select">
										<option value="Y">Y</option>
										<option value="N" selected>N</option>
									</select>
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
		<!-- 모달이 로드될 영역 -->
       <div id="modalContainer"></div>
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
		
		// Form마다 조회 조건 변경 시작
		var findTxtln  = 0;    // 조회조건시 글자수 제한 / 0이면 제한 없음
		var firstflag  = false; // 첫음부터 Find하시려면 false를 주면됨
		var findValues = [];
		// 조회조건이 있으면 설정하면됨 / 조건 없으면 막으면 됨
		// 글자수조건 있는건 1개만 설정가능 chk: true 아니면 모두 flase
		// 조회조건은 필요한 만큼 추가사용 하면됨.
		findValues.push({ id: "findData", val: "",  chk: true  });
        //병원병원에서 접속시 요양기관 값셋팅
	    let s_hospcd = getCookie("s_hospid") ;
	    let s_wnn_yn = getCookie("s_wnn_yn") ;
	    let s_hosp_uuid = getCookie("s_hosp_uuid");
	  //원너넷이 아니거나 워너넷에서 병원을 선택해서 처리한 경우)
	    if ( (s_hospcd &&  s_wnn_yn != 'Y') || (s_hospcd != s_hosp_uuid) )   { 
	        findValues.push({ id: "hospCd1", val: s_hospcd,  chk: false  });
            $("#hospCd1").val(s_hospcd);
	    }else{
	        findValues.push({ id: "hospCd1", val:"",  chk: false  });
            $("#hospCd1").val("");	    	
	    }
		
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
	    var list_code = ['LIC_TYPE']; 
	    var select_id = ['licType'];     // 구분코드 데이터 담길 Select (ComboBox ID)
		var firstnull = ['N'];                              // Y 첫번째 Null,이후 Data 담김 / N 바로 Data 담김 
		<!-- ============================================================== -->
		<!-- 공통코드 Setting End -->
		<!-- ============================================================== -->
		var format_convert = ['ipDt','teDt'] ; //날자에서 '-' '/' 제외설정   
		
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
		var c_Head_Set =  [ { name: '병원정보',  className: 'dt-body-center' },
						    { name: '병원명',   className: 'dt-body-center' },
						    { name: '라이센스',  className: 'dt-body-center' },
						    { name: '성명',     className: 'dt-body-center' },
						    { name: '입사일자',  className: 'dt-body-center' },
						    { name: '면허구분',  className: 'dt-body-center' },
						    { name: '면허명칭',  className: 'dt-body-center' },
						    { name: '퇴사일자',  className: 'dt-body-center' },
						    { name: '세부구분',  className: 'dt-body-center' },
						    { name: '근무시간',  className: 'dt-body-center' },
						    { name: '진료과',   className: 'dt-body-center' },
						    { name: '등록자',   className: 'dt-body-center' }
						 ] ;  
		var columnsSet = [  // data 컬럼 id는 반드시 DTO의 컬럼,Modal id는 일치해야 함 (조회시)
	        				// name 컬럼 id는 반드시 DTO의 컬럼 일치해야 함 (수정,삭제시), primaryKey로 수정, 삭제함.
	        				// dt-body-center, dt-body-left, dt-body-right	        				
	        				{ data: 'hospCd',    visible: true,  className: 'dt-body-center', width: '100px',  name: 'keyhospCd', primaryKey: true },
	        				{ data: 'hospNm',    visible: true,  className: 'dt-body-center', width: '180px',  },
	        				{ data: 'licNum',    visible: true,  className: 'dt-body-center', width: '70px',   name: 'keylicNum', primaryKey: true },
	        				{ data: 'userNm',    visible: true,  className: 'dt-body-center', width: '100px',  },
	        				{ data: 'ipDt',      visible: true,  className: 'dt-body-center', width: '100px',  name: 'keyipDt', primaryKey: true ,
                             	render: function(data, type, row) {
	            				if (type === 'display') {
	            					return getFormat(data,'d1')
	                			}
	                			return data;
                             	}
            				},
            				{ data: 'licType',         visible: true,  className: 'dt-body-center', width: '50px',  },
            				{ data: 'subCodeNm',       visible: true,  className: 'dt-body-center', width: '100px',  },
            				{ data: 'teDt',            visible: true,  className: 'dt-body-center', width: '100px', 
	                          	render: function(data, type, row) {
		            			if (type === 'display') {
		            					return getFormat(data,'d1')
		                			}
		                			return data;
	            				}
	        				},
	        				{ data: 'licDetail',    visible: true,  className: 'dt-body-center', width: '100px',  },
	        				{ data: 'weekHours',    visible: true,  className: 'dt-body-center', width: '200px',  },
	        				{ data: 'deptCode',     visible: true,  className: 'dt-body-center', width: '100px',  },
					        { data: 'updUserNnm',   visible: true,  className: 'dt-body-center', width: '100px',  }
					    ];
		
		var s_CheckBox = true;   		           	 // CheckBox 표시 여부
        var s_AutoNums = true;   		             // 자동순번 표시 여부
        
		// 초기 data Sort,  없으면 []
		var muiltSorts = [
							['licNum' , 'asc' ],    // 오름차순 정렬
							['hospCd' , 'asc' ],    // 오름차순 정렬
            				['ipDt', 'desc']     // 내림차순 정렬
        				 ];
        // Sort여부 표시를 일부만 할 때 개별 id, ** 전체 적용은 '_all'하면 됩니다. ** 전체 적용 안함은 []        				 
		var showSortNo = ['hospCd','licNum','ipDt','licType'];                   
		// Columns 숨김 columnsSet -> visible로 대체함 hideColums 보다 먼제 처리됨 ( visible를 선언하지 않으면 hideColums컬럼 적용됨 )	
		var hideColums = [];             // 없으면 []; 일부 컬럼 숨길때		
		var txt_Markln = 20;                       				 // 컬럼의 글자수가 설정값보다 크면, 다음은 ...로 표시함
		// 글자수 제한표시를 일부만 할 때 개별 id, ** 전체 적용은 '_all'하면 됩니다. ** 전체 적용 안함은 []
		var markColums = ['hospNm'];
		var mousePoint = 'pointer';                				 // row 선택시 Mouse모양
		<!-- ============================================================== -->
		<!-- Table Setting End -->
		<!-- ============================================================== -->
		
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
	        const hospCdInput     = document.getElementById("hospCd");
			const licNumInput     = document.getElementById("licNum");
	        const ipDtInput       = document.getElementById("ipDt");
		    const hospserch       = document.getElementById('hospserch');
	        const inputs         = [licNumInput, ipDtInput,hospCdInput];

	        if (flag !== 'I') {
		        const isReadOnly = flag !== 'I';
		        inputs.forEach(input => {
		            if (input) { // 요소가 존재하는지 확인
		                input.readOnly = isReadOnly;
		            }
		        });
		        hospserch.style.display = 'none'
		    }else{
		        const isReadOnly = flag == 'N';
		        inputs.forEach(input => {
		            if (input) { // 요소가 존재하는지 확인
		                input.readOnly = isReadOnly;
		            }
		        });		
		        if ((s_hospcd  && s_wnn_yn != 'Y') || (s_hospcd != s_hosp_uuid)) {
		           hospCdInput.readOnly = true ;
		           hospserch.style.display = 'none'	
		        }else{
		           hospCdInput.readOnly = false ; //워너넷에서 로그인한경우 입력시 요양기관처야함 
		           hospserch.style.display = 'inline-block'	
		        }
		    }
		}
		function modal_Open(flag) {	
			let modal_OpenFlag = true;
			const insertButton = document.getElementById('form_btn_ins');
		    const updateButton = document.getElementById('form_btn_udt');
		    const deleteButton = document.getElementById('form_btn_del');
    
		    // Hide all
		    insertButton.style.display = 'none';
		    updateButton.style.display = 'none';
		    deleteButton.style.display = 'none';
		
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
					
				} else {
					modal_OpenFlag = false;
					messageBox("1","<h5>작업 할 Data가 선택되지 않았습니다. !!</h5><p></p><br>",mainFocus,"","");			
					return null;
				}
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
			            //e.preventDefault(); // 기본 동작 방지
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
			    //위너넷이아니면  병원정보 자동로그인에서 가져와서 등록  
			    console.log(getCookie("s_hospid") +"---"+ getCookie("s_wnn_yn"))

			    if ( (getCookie("s_hospid") &&  getCookie("s_wnn_yn") != 'Y') || (s_hospcd != s_hosp_uuid)) {
			        inputZone.querySelector("[name='hospCd']").value = getCookie("s_hospid") || "";
			        inputZone.querySelector("[name='hospNm']").value = getCookie("s_hospnm") || "";
			    }			    
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
		   		let key = findValue.id === "hospCd1" ? "hospCd" : findValue.id;
		   		console.log(findValue.id);
		   		find[key] = findValue.val;
		   	}
		   	let checkValue = $("#checkValue").is(":checked") ? "Y" : "N";
		   	let findData   = $("#findData").val() ;
		   	let hospCd     = $("#hospCd1").val() ;
		   	$.ajax({
		        type: "POST", 
		        url: "/user/licenseCdList.do",
		        data: {find: find, checkValue: checkValue , findData : findData , hospCd : hospCd },
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
		    	hospCd:       { kname: "요양기관", k_req: true, k_spc: true, k_clr: true },
		    	licNum:       { kname: "면허번호", k_req: true },
		    	userNm:       { kname: "사용자성명" , k_req: true },
		    	ipDt:         { kname: "입사일자", k_req: true},
		    	licType:      { kname: "구분번호", k_req: true }
		    });
		    return results;
		}
		//그리드상 데이타생성및 수정 작업
		function newuptData() {
        	let newData = {
        		licNum:        $('#licNum').val(),
         		hospCd:        $('#hospCd').val(),
         		hospNm:        $('#hospNm').val(),
         		subCodeNm:     $('#subCodeNm').val(),
         		userNm:        $('#userNm').val(),
         		ipDt:          $('#ipDt').val(), 
         		teDt:          $('#teDt').val(), 
         		userNm:        $('#userNm').val(), 
         		updUserNnm:    $('#updUserNnm').val(), 
         		licDetail:     $('#licDetail').val(), 
         		weekHours:     $('#weekHours').val(), 
         		deptCode:      $('#deptCode').val()
			    };
		    return newData;
		}	
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
			            url: "/user/licenseCdInsert.do",
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
		            url: "/user/licenseCdUpdate.do",
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
		                messageBox("1", "<h6> 정상적으로 업데이트되었습니다. </h6>", mainFocus, "", "");
		            },
		            error: function(xhr, status, error) {
		                console.error("업데이트 실패", xhr.responseText);
		                messageBox("5", "<h6>서버에 문제가 발생했습니다.</h5><h6>잠시 후 다시 시도해주세요.</h6>", mainFocus, "", "");
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
				            url: "/user/licenseCdDelete.do",	    	    
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
				            url: "/base/licenseCdDelete.do",	    	    
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
				            
				            let filteredItems = commList.filter(item => item.codeCd === list_code[i]);
				            
				            if (filteredItems.length > 0) {
				            	if (firstnull[i] === "Y")
				            		select.append('<option value=""></option>');
				            		
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
		        th.classList.add('dt-body-center'); // 체크박스는 가운데 정렬
		        tr.appendChild(th);
		    }
		
		    // 자동 번호 열 추가
		    if (s_AutoNums) {
		        const th = document.createElement('th');
		        th.textContent = 'No';
		        th.classList.add('dt-body-center'); // 번호도 가운데 정렬
		        tr.appendChild(th);
		    }
		
		    // 헤더 배열을 순회하며 <th> 추가
		    c_Head_Set.forEach(header => {
		        const th = document.createElement('th');
		        th.textContent = header.name; // 컬럼명 설정
		        th.classList.add(header.className); // c_Head_Set에서 정의된 className 적용
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
		function closeMainModal() {
			$("#" + modalName.id).modal('hide');
		}
		
		// 병원검색 /js/winmc/schcommons.js///////////////
		$("#hospserch").on("click", function () {
		    openHospitalSearch(function (data) {
		        $("#hospCd").val(data.hospCd);
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
         ///////////////////////////////////////////////////////////
		let currentHospid = sessionStorage.getItem('hospid'); // 최초 병원 ID 저장

		setInterval(function () {
		    let newHospid = sessionStorage.getItem('hospid');
		    if (newHospid && newHospid !== currentHospid) {
		        console.log("병원이 변경됨: " + newHospid);
		        currentHospid = newHospid; // 변경된 ID로 갱신
		      //병원병원에서 접속시 요양기관 값셋팅
			    let s_hospcd = getCookie("s_hospid") ;
				findValues.push({ id: "hospCd1", val: s_hospcd,  chk: false  });
				$("#hospCd1").val(s_hospcd);
				triggerFind();
		    }
		}, 1000); // 1초마다 체크 (너무 짧으면 3000ms로 늘려도 됨)
		// 강제로 실행하고 싶을 때 사용할 함수
		function triggerFind() {
		    fn_FindData();
		}		
		//권한조건체크 applyAuthControl.js
	    document.addEventListener("DOMContentLoaded", function() {
	        applyAuthControl();
	    });
	    function license_load() {
	        const hospCd1 = document.getElementById("hospCd1").value;
        	let  s_userid = getCookie("s_userid") ;
        	let  s_connip = getCookie("s_connip") ;

	        if (hospCd1 == '' || hospCd1 ==  null) {
	           messageBox("4", "요양기관을 선택하고 진행하세요  !!",mainFocus,"","");
	        }
	        if (hospCd1 !== '') {
	            $.ajax({
	                type: "POST",
	                url: "/user/hospemp_licnum.do",
	                data: { hospCd: hospCd1 ,regUser : s_userid , regIp : s_connip ,
	                	    updUser : s_userid , updIp : s_connip
	                	  },
	                dataType: "json",
	                success: function(response) {
	                    // 응답 처리 로직 추가
	                    console.log(response);
	                    fn_re_load() ;
	                },
	                error: function(xhr, status, error) {
	                    console.error("AJAX 요청 실패:", status, error);
	                }
	            });
	        }
	    }
	  </script>
		<!-- ============================================================== -->
		<!-- 기타 정보 End -->
		<!-- ============================================================== -->

		