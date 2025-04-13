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
	                            <div class="card-header d-flex">
	                                <h3 class="card-header-title">년도</h3>
	                                <select id="year_Select" class="custom-select ml-left w-auto  ml-2 mr-4">
	                                </select>
	                                <h3 class="card-header-title ml-2">구분</h3>
	                                <select id="file_Select" class="custom-select ml-left w-auto  ml-2 mr-4">
	                                	<option selected value="1">파일선택</option>
				                        <option value="2">폴더선택</option>
	                                </select> 
	                                <select id="allowedFiles" class="custom-select ml-left w-auto ml-2 mr-4"  style="display: none;">	                                	
	                                </select>
	                                <select id="claimType" class="custom-select ml-left w-auto ml-2 mr-4"  style="display: none;">	                                	
	                                </select>
	                                <select id="insurType" class="custom-select ml-left w-auto ml-2 mr-4"  style="display: none;">	                                	
	                                </select>
	                                <select id="treatType" class="custom-select ml-left w-auto ml-2 mr-4"  style="display: none;">	                                	
	                                </select>
	                            </div>
	                        </div>
		                        
                            <div class="tab-regular mb-3">
							    <ul class="nav nav-tabs" id="mg_FlagTab" role="tablist">
							        <li class="nav-item">
							            <a class="nav-link active" id="c-tab" data-toggle="tab" href="#content" role="tab" aria-controls="content" aria-selected="true" data-type="8">청구샘파일</a>
							        </li>
							        <li class="nav-item">
							            <a class="nav-link" id="p-tab" data-toggle="tab" href="#content" role="tab" aria-controls="content" aria-selected="false" data-type="9">환자평가표</a>
							        </li>
							    </ul>
							    
							    <div class="tab-content" id="mg_FlagTabContent">
							        <div class="tab-pane fade show active" id="content" role="tabpanel">
							            <div class="row" id="months-container">
							                <!-- 월별 카드가 여기에 동적으로 추가됩니다 -->
							                
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
                             <h6 class="card-header" style="color: #8b0000; font-weight: bold;">청구서 / 평가표는 업로드시 기존자료는 삭제되고, 현재 등록된 자료로 신규생성 됩니다.</h6>
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

	var gFiles = null;
	var g_Year = new Date().getFullYear(); // 당해년도
	var gMonth = '01';                     // 1월
	var g_Flag = '8';                      // 8.청구서 9.평가표
	var allowedFiles = [];                 // 적용가능 파일 담기
	var allowedPairs = [];                 // 적용가능 필요 파일
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
	var page_Hight = 500;    		// Page 길이보다 Data가 많으면 자동 scroll - scrollY
	var p_Collapse = true;  		// Page 길이까지 auto size - scrollCollapse
	
	var datWaiting = true;   		// Data 가져오는 동안 대기상태 Waiting 표시 여부
	var page_Navig = false;   		// 페이지 네비게이션 표시여부 
	var hd_Sorting = true;   		// Head 정렬(asc,desc) 표시여부
	var info_Count = false;   		// 총건수 대비 현재 건수 보기 표시여부 
	var searchShow = false;   		// 검색창 Show/Hide 표시여부
	var showButton = false;   		// Button (복사, 엑셀, 출력)) 표시여부
	
	var copyBtn_nm = '복사.';
	var copy_Title = 'Copy Title';		
	var excelBtnnm = '엑셀.';
	var excelTitle = 'Excel Title';
	var excelFName = "파일명_";		// Excel Download시 파일명
	var printBtnnm = '출력.';
	var printTitle = 'Print Title';
    
	var find_Enter = false;  		// 검색창 바로바로 찾기(false) / Enter후 찾기(true)
	var row_Select = true;   		// Page내 Data 선택시 선택 row 색상 표시
	
	var colPadding = '0.5px'   		// 행 높이 간격 설정
	var data_Count = [5, 10, 15, 20, 30];  // Data 보기 설정
	var defaultCnt = 15;                   // Data Default 갯수
	
	
	//  DataTable Columns 정의, c_Head_Set, columnsSet갯수는 항상 같아야함.
	var c_Head_Set = [ '청구번호','버전','청구구분','진료형태','진료년월', '건수','총진료비','청구금액','작업-KEY','작업일시','작업자','파일명'];

	var columnsSet = [ 
		
					 	{ data: 'claim_no',   visible: true,  className: 'dt-body-center',  width: '100px' },
					    { data: 'clform_ver', visible: true,  className: 'dt-body-center',  width: '50px'  },
					    { data: 'claim_type', visible: true,  className: 'dt-body-center',  width: '250px' },
					    { data: 'claim_type', visible: true,  className: 'dt-body-center',  width: '250px' },
					    { data: 'date_ym',    visible: true,  className: 'dt-body-center',  width: '100px',
						    render: function(data, type, row) {
		            			if (type === 'display') {
		            				return getFormat(data,'d6')
		                		}
		                		return data;
	      			       },
					    },
					    { data: 'case_cnt',   visible: true,  className: 'dt-body-right',   width: '100px', 
							render: function(data, type, row) {
		            			if (type === 'display') {
		            				return getFormat(data,'n1') + ' 건 '
		                		}
		                		return data;
          			       },
					    },
						{ data: 'tot_amt',   visible: true,  className: 'dt-body-right',   width: '100px', 
							render: function(data, type, row) {
		            			if (type === 'display') {
		            				return getFormat(data,'n1') + ' 원 '
		                		}
		                		return data;
	          			     },
						},
						{ data: 'claim_amt', visible: true,  className: 'dt-body-right',   width: '100px', 
						    render: function(data, type, row) {
		            			if (type === 'display') {
		            				return getFormat(data,'n1') + ' 원 '
		                		}
		                		return data;
	          			    },
						},
						{ data: 'jobs_dt',  visible: true,  className: 'dt-body-center',  width: '100px' },
	        			{ data: 'upd_dttm', visible: true,  className: 'dt-body-center',  width: '100px' },
	        			{ data: 'user_nm',  visible: true,  className: 'dt-body-center',  width: '100px' },        			   
	        			{ data: 'file_nm',  visible: true,  className: 'dt-body-center',  width: '150px' }
        			   
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
	var list_code = ['ALLOWED'];          // 구분코드 필요한 만큼 선언해서 사용
	var select_id = ['allowedFiles'];     // 구분코드 데이터 담길 Select (ComboBox ID) 
	var firstnull = ['N'];                // Y 첫번째 Null,이후 Data 담김 / N 바로 Data 담김  
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
	
    // 초기 로드
    loadMonthsData();

    $('#year_Select').on('change', function() {
    	g_Year = $(this).val();
        const activeTab = $('#mg_FlagTab a.active');
        g_Flag = activeTab.data('type');
        findField('mg_year', g_Year)
        findField('mg_flag', g_Flag)
        loadMonthsData();
    });

    // 탭 전환 시 이벤트
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
	    if(e.target && e.target.getAttribute('data-action') === 'fileLoad') {
	  	  	fileLoad_Open(e.target.getAttribute('data-mgmonth'));
	  	}
	  	if(e.target && e.target.getAttribute('data-action') === 'fileView') {
	  	  	fileView_Open(e.target.getAttribute('data-mgmonth'));
	  	}
   	});
   
    find_Check();
    
    comm_Check();    

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
		    	
		    	messageBox("9","<h5>정말로 삭제하시겠습니까 ? 파일명칭 : " + data.file_nm + " 입니다. </h5><p></p><br>","","","");
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
		    
		})(jQuery);
		
	}	   
	
	//ajax 함수 정의
	function dataLoad(data, callback, settings) {
	
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

	function fileLoad_Open(mgmonth) {
		
		event.stopPropagation();
	    gMonth = mgmonth;
	    findField('mgmonth', gMonth)
	    
	    let file_Select = document.getElementById("file_Select");
	    let folderInput = document.getElementById('folderInput');
	    
	    if (file_Select.value === "2") {
	      // 폴더 선택이 선택된 경우 webkitdirectory 속성 추가
	      folderInput.setAttribute("webkitdirectory", "");
	    } else {
	      // 파일 선택이 선택된 경우 webkitdirectory 속성 제거
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
	    
	    folderInput.click();
	    
	}

	function fileView_Open(mgmonth) {
		event.stopPropagation();
		gMonth = mgmonth;
		findField('mgmonth', gMonth)
		dataTable.ajax.reload();
	}
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
			    url: "/suga/commList.do",    
			    data: {
			        list_gb: list_flag,
			        list_cd: list_code
			    },
			    dataType: "json",
			 	
			    beforeSend : function () {
			    	
				},
			    success: function(response) {
			   	
			    	allowedFiles = []; // 적용가능 파일 담기
			    	
			        let commList = response.data || [];
			    	
			        for (var i = 0; i < select_id.length; i++) {
			            
			        	let select = $('#' + select_id[i]);
			            select.empty();
			            
			            let filteredItems = commList.filter(item => item.code_cd === list_code[i]);
			            
			            if (filteredItems.length > 0) {
			            	if (firstnull[i] === "Y")
			            		select.append('<option value=""></option>');
			            		
			            	filteredItems.forEach(function (item) {
			            		
			                    select.append('<option value=' + item.sub_code + '>' + item.sub_code_nm + '</option>');
			                    
			                    allowedFiles.push(item.sub_code); 
			                    allowedPairs.push(item.sub_code_nm);
			                    
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
     	/*
        gridColums.push({ data: null, orderable: false, searchable: false, className: 'dt-center',
            render: function(data, type, row) {
                return  '<button class="btn btn-outline-light btn-xs del-btn">삭제.<i class="far fa-trash-alt"></i></button>';
            }
        });
     	**/
      	
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

document.getElementById('folderInput').addEventListener("change", handleFileSelection);

function handleFileSelection(event) {
	
    let lfiles = event.target.files;
    
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
    	messageBox("4","<h5>청구서 파일 누락 [ " + missingPairs[0] + " ],   청구서가 필요한 파일은 : " + missingFiles[0] + " 입니다. </h5><p></p><br>","","","");
    } else {
    	
    	if (gFiles) { // 서버전송
    		let jobs_dt = getJobDateTime();
    		let pro_cnt = 0;
    		
    		gFiles.forEach(file => {
    			
    			let reader = new FileReader();

    			reader.readAsText(file, 'euc-kr');
    			
    			reader.onload = function (e) {
    				
    				let content = e.target.result;
			        
			        let lines = content.split('\n');
			        
			        let chunggu = '1';
			        
			        if (file.name != 'M010.1') {
			            chunggu = chungguFiles.includes(file.name) ? '2' : '1';
			        }
			        
			        let data = lines.map((line, index) => ({
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
			            upd_ip: '127.0.0.1'
			        })).filter(item => item.lineval);

				    // 만약 data가 비어있을 경우 처리
				    
				    if (data.length === 0) {
				    	messageBox("4", "<h5>파일명 : " + file.name + " 은 유효한 데이터가 없습니다. 파일을 확인하세요.<br></h5><p></p><br>", "", "", "");
				    } else {
				        // AJAX 요청
				    	$.ajax({
				    	    url: '/main/uploadMagamFiles.do',
				    	    type: 'POST',
				    	    contentType: 'application/json',
				    	    data: JSON.stringify(data),
				    	    success: function (response) {
				    	        pro_cnt++; 
				    	        
				    	        if (pro_cnt === gFiles.length) {
				    	            messageBox("1", "<h5>모든 파일이 정상적으로 실행 되었습니다.</h5><p></p><br>", "", "", "");		    		            		
				    	            dataTable.ajax.reload();
				    	            try {
				    	            	loadMonthsData();
				    	            } catch (e) {
				    	                console.error("loadMonthsData 실행 중 오류 발생:", e);
				    	            }
				    	        }
				    	    },
				    	    error: function(xhr, status, error) {
				    	        console.error('Error Status Code:', xhr.status);
				    	        console.error('Response Text:', xhr.responseText);
				    	        console.error('Error Status:', status);
				    	        console.error('Error Message:', error);
				    	        
				    	        if (!errorOccurred) {
				    	            errorOccurred = true;
				    	            
				    	            let errorMessage = 'Error occurred while processing files. ';
				    	            
				    	            if (xhr.responseText) {
				    	                errorMessage += 'Server response: ' + xhr.responseText;
				    	            }
				    	            messageBox("4", "<h5>전송파일 처리 중 오류가 발생했습니다. " + errorMessage + "<br>Status Code: " + xhr.status + "</h5><p></p><br>", "", "", "");
				    	        }
				    	        pro_cnt++;
				    	    }
				    	});
				    }    
    		    };	
    		    
    		});
    		/*
    		formData.append("mg_Year", g_Year);   // Add year
    		formData.append("mgMonth", gMonth);   // Add month
    		formData.append("mg_Flag", g_Flag);   // Add flag

    		
    		$.ajax({
    		    url: '/main/uploadMagamFiles.do',
    		    type: 'POST',
    		    data: formData,
    		    processData: false, // Disable processing form data
    		    contentType: false, // Use FormData default content type
    		    
    		    success: function(data) {
    		        console.log('Server Response:', data);
    		        messageBox("1", "<h5> All files have been processed successfully. </h5><p></p><br>", "", "", "");
    		    },
    		    error: function(xhr, status, error) {
    		        console.error('Error Status Code:', xhr.status);
    		        console.error('Response Text:', xhr.responseText);
    		        console.error('Error Status:', status);
    		        console.error('Error Message:', error);
    		        
    		        let errorMessage = 'Error occurred while processing files. ';
    		        if (xhr.responseText) {
    		            errorMessage += 'Server response: ' + xhr.responseText;
    		        }
    		        
    		        messageBox("4", "<h5>" + errorMessage + "<br>Status Code: " + xhr.status + "</h5><p></p><br>", "", "", "");
    		    }
    		});
			
			
			
			fetch('/main/uploadMagamFiles.do', {
			    method: 'POST',
			    body: formData,
			})
		    .then(response => {
		        if (response.ok) {
		        	return response.text(); // 서버 응답이 JSON이 아니라 텍스트일 경우
		        } else {
		        	throw new Error('파일 업로드 실패');
		        }
		    })
		    .then(data => {
		    	console.log('서버 응답:', data);
		        messageBox("1", "<h5> 모든 전송파일이 정상적으로 처리되었습니다. </h5><p></p><br>", "", "", "");
		    })
		    .catch(error => {
		    	console.error('오류 발생:', error);
		        messageBox("4", "<h5> 전송파일 처리 중 오류가 발생했습니다. <br> " + error + " - 잠시 후 다시 시도해 주십시오! </h5><p></p><br>", "", "", "");
			});
			*/	
    	}
    }	    
}

function getJobDateTime() {
	
    let now     = new Date();
    let year    = now.getFullYear();
    let month   = String(now.getMonth() + 1).padStart(2, '0');
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
        data: { mg_year: g_Year,
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

    find.data.forEach((item, index) => {
        
	    const headerClass = item.magamyn === "Y" ? "bg-primary" : "bg-light";
	    const h4headClass = item.magamyn === "Y" ? "text-white" : "text-black";
	    const buttonClass = item.magamyn === "Y" ? "btn-outline-primary" : "btn-outline-light";
	    const button_Text = item.magamyn === "Y" ? "등록완료" : "미등록";
	    const hovers_Text = item.magamyn === "Y" ? "재등록" : "등록하기";

	    let buttonHTML  = '<button data-action="fileLoad" data-mgmonth="' + item.mgmonth + '"  id="' + item.mgmonth + '" class="btn ' + buttonClass + ' btn-block btn-sm hover-change d-flex align-items-center justify-content-center" data-original="' + button_Text + '" data-hover="' + hovers_Text + '">' + button_Text + '</button>';

	    if (item.magamyn === "Y") {
	        buttonHTML += '<button data-action="fileView" data-mgmonth="' + item.mgmonth + '" class="btn btn-outline-info btn-block btn-sm d-flex align-items-center justify-content-center">자료보기</button>';
	    } else {
	        buttonHTML += '<button class="btn btn-outline-light  btn-block btn-sm d-flex align-items-center justify-content-center text-white">보기없음</button>';
	    }    	    
	    
	    const cardHTML = 
	        '<div class="col-xl-1 col-lg-1">' +
	            '<div class="card">' +
	                '<div class="card-header ' + headerClass + ' text-center p-1">' +
	                    '<h4 class="mb-0 ' + h4headClass + '">' + item.mgmonth + '월' + '</h4>' +
	                '</div>' +
	                '<div class="card-body text-center">' +
	                    buttonHTML +
	                '</div>' +
	            '</div>' +
	        '</div>';

	    monthsContainer.append(cardHTML);

	    // 마우스 이벤트 처리
	    $('.hover-change').hover(
	        function() {
	            $(this).text($(this).data('hover'));
	        },
	        function() {
	            $(this).text($(this).data('original'));
	        }
	    );
	});
}

</script>
<!-- ============================================================== -->
<!-- 월별,  8.청구서 9.평가표 정보 End -->
<!-- ============================================================== -->
       
