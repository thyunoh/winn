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
                <div class="ecommerce-widget">                                
                <!-- Row starts -->
	                <div class="row">
			    		<div class="col-lg-5">
	                        <div class="card" >
	                            <div class="card-header d-flex align-items-center">
	                            
	                                <h3 class="card-header-title">년</h3>
	                                <select id="year_Select" class="custom-select ml-left w-auto  ml-2 mr-4"></select>
	                                <h3 class="card-header-title ml-2">월</h3>
	                                <select id="monthSelect" class="custom-select ml-left w-auto  ml-2 mr-4"></select>
	                                
	                            </div>
	                                       
	                            <div class="card-body">
								    <div class="row">
								        <div class="col-lg-12">
								            <button class="btn btn-outline-success btn-block btn-sm d-flex align-items-center justify-content-center mb-2" onClick="fn_CreateData('00')">《 전체 대상 점검 》</button>								                        
								        </div>
								        <div class="col-lg-6">
								        	<button class="btn btn-outline-primary btn-block btn-sm d-flex align-items-center justify-content-center mb-2" onClick="fn_CreateData('01')">【 평가 구분 점검 】</button>            
								            <button class="btn btn-outline-primary btn-block btn-sm d-flex align-items-center justify-content-center mb-2" onClick="fn_CreateData('03')">【 신규 욕창 점검 】</button>
								            
								        </div>
								        <div class="col-lg-6">
								        	<button class="btn btn-outline-primary btn-block btn-sm d-flex align-items-center justify-content-center mb-2" onClick="fn_CreateData('02')">【 유치도뇨관 점검 】</button>            
								            <button class="btn btn-outline-primary btn-block btn-sm d-flex align-items-center justify-content-center mb-2" onClick="fn_CreateData('04')">【 욕창 관리 점검 】</button>
								        </div>
								        <div class="col-lg-6">
								            <button class="btn btn-outline-primary btn-block btn-sm d-flex align-items-center justify-content-center mb-2" onClick="fn_CreateData('05')">【 일상 생활 점검 】</button>
								        </div>
								        <div class="col-lg-6">
								            <button class="btn btn-outline-primary btn-block btn-sm d-flex align-items-center justify-content-center mb-2" onClick="fn_CreateData('06')">【 당뇨 환자 점검 】</button>
								        </div>
								        <div class="col-lg-12">
								        	<span id="wait_Create" class="loader" style="display: none;">환자평가표 점검중...</span>
								        </div>
								        <div class="col-lg-12">
								            <button id="etarget" class="btn btn-outline-info btn-block btn-sm align-items-center justify-content-center mb-2" onClick="fn_CreateData('99')" style="display: none;">《 평가 대상 보기 》</button>								                        
								        </div>
								    </div>
								</div> 	                            
	                        </div>
	                    </div>
	                    
	                    <div class="col-lg-7">
		                    <div class="card" id="card_container" style="height: 880px; display: none;">
							    <div class="card-header11 d-flex justify-content-between align-items-top">
							        
							        <label id="lab_title" class="dsah_lab9"></label>
							        
							    </div>
							    <!-- 라인 1줄 생성 -->
							    <hr style="margin: 0; border-top: 2px solid #ccc;">
							    <div class="card-header11">							        
						        	
						        	<table id="errorTable" class="display nowrap stripe hover cell-border order-column responsive">
															       
									</table>
							    </div>
							</div>
	                    </div>
					</div>            
            	</div>
        	</div>
    	</div>
    </div>
    

<script type="text/javascript">

var jobFlag = '00'; 
var jobYyMm = '202501';
var jobCode = null;

var mixedChart1;
var mixedChart2;
var set_Table = null; 
var tableName = null;
var dataTable = new DataTable();
dataTable.clear();


<!-- ============================================================== -->
<!-- Table Setting Start -->
<!-- ============================================================== -->
var gridColums = [];
var btm_Scroll = true;   		// 하단 scroll여부 - scrollX
var auto_Width = true;   		// 열 너비 자동 계산 - autoWidth
var page_Hight = 600;    		// Page 길이보다 Data가 많으면 자동 scroll - scrollY
var p_Collapse = true;  		// Page 길이까지 auto size - scrollCollapse
var fixed_Head = true;          // 헤더 고정 

var datWaiting = false;   		// Data 가져오는 동안 대기상태 Waiting 표시 여부
var page_Navig = false;   		// 페이지 네비게이션 표시여부 
var hd_Sorting = false;   		// Head 정렬(asc,desc) 표시여부
var info_Count = false;   		// 총건수 대비 현재 건수 보기 표시여부 
var searchShow = true;   		// 검색창 Show/Hide 표시여부
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

var colPadding = '3px';   		// 행 높이 간격 설정
var data_Count = [30 , 50, 70, 100, 150, 200];  // Data 보기 설정
var defaultCnt = 30;                            // Data Default 갯수

var s_CheckBox = false;   		           	    // CheckBox 표시 여부
var s_AutoNums = false;   		                // 자동순번 표시 여부

//  DataTable Columns 정의, c_Head_Set, columnsSet갯수는 항상 같아야함.
var c_Head_Set = [];
var columnsSet = [];
// 초기 data Sort,  없으면 []
var muiltSorts = [];
// Sort여부 표시를 일부만 할 때 개별 id, ** 전체 적용은 '_all'하면 됩니다. ** 전체 적용 안함은 []        				 
var showSortNo = [];                   
// Columns 숨김 columnsSet -> visible로 대체함 hideColums 보다 먼제 처리됨 ( visible를 선언하지 않으면 hideColums컬럼 적용됨 )	
var hideColums = [];             // 없으면 []; 일부 컬럼 숨길때		
var txt_Markln = 20;                       				 // 컬럼의 글자수가 설정값보다 크면, 다음은 ...로 표시함
// 글자수 제한표시를 일부만 할 때 개별 id, ** 전체 적용은 '_all'하면 됩니다. ** 전체 적용 안함은 []
var markColums = [];
var mousePoint = 'pointer';                				 // row 선택시 Mouse모양
<!-- ============================================================== -->
<!-- Table Setting End -->
<!-- ============================================================== -->


function fn_CreateData(flag) {

	let chkFlag = '0';
	
	if        (flag === "99" && jobFlag !== flag) {
		chkFlag = '1';
	} else if (flag !== "99" && jobFlag === "99") {
		chkFlag = '2';
	}
	
	jobFlag = flag;
	
	let waitingCreate = document.getElementById("wait_Create");	
    waitingCreate.style.display = 'flex';

    const lab_txt = document.getElementById('lab_title');
    const cardbox = document.getElementById('card_container');
    
    cardbox.style.display = 'flex';
    
    if        (jobFlag === "00" ) {
    	lab_txt.textContent = "전체 대상 점검";
    } else if (jobFlag === "01" ) {
    	lab_txt.textContent = "평가 구분 점검";
    } else if (jobFlag === "02" ) {
    	lab_txt.textContent = "유치도뇨관 점검";
    } else if (jobFlag === "03" ) {
    	lab_txt.textContent = "신규 욕창 점검";	
    } else if (jobFlag === "04" ) {
    	lab_txt.textContent = "욕창 관리 점검";
	} else if (jobFlag === "05" ) {
		lab_txt.textContent = "일상 생활 점검";
    } else if (jobFlag === "06" ) {
    	lab_txt.textContent = "당뇨 환자 점검";
    } else if (jobFlag === "99" ) {
    	lab_txt.textContent = "평가 대상 보기";
    }
    
    datWaiting = false;   		// Data 가져오는 동안 대기상태 Waiting 표시 여부
	page_Navig = true;   		// 페이지 네비게이션 표시여부 
	hd_Sorting = true;   		// Head 정렬(asc,desc) 표시여부
	info_Count = true;   		// 총건수 대비 현재 건수 보기 표시여부 
	showButton = true;   		// Button (복사, 엑셀, 출력)) 표시여부
	s_CheckBox = false;   		// CheckBox 표시 여부
	s_AutoNums = false;   		// 자동순번 표시 여부
	page_Hight = 690;
	defaultCnt = 100;
	colPadding = '0.2px';   	// 행 높이 간격 설정
	
    if (jobFlag === "99") {
		
		c_Head_Set = [  '생년월일','대상자','입원일자','요양개시일','평가표작성일','평가구분','분류군','제외구분','상세내용'  ];
	   	columnsSet = [  
			    		
			    		
			    		{ data: 'patId',     visible: true,  className: 'dt-body-center', width: '100px' , 
							render: function(data, type, row) {
								if (type === 'display') {
			        				return data.substring(0, 6);
			            		}
			            		return data;
						    },
					    },
			    		
					    { data: 'patNm',     visible: true,  className: 'dt-body-center', width: '100px'  },					    
					    { data: 'admitDt',   visible: true,  className: 'dt-body-center', width: '100px',
						    render: function(data, type, row) {
			        			if (type === 'display') {
			        				return getFormat(data,'d1')
			            		}
			            		return data;
						    },
					    },
					    { data: 'medStart',  visible: true,  className: 'dt-body-center', width: '100px', 
							render: function(data, type, row) {
			        			if (type === 'display') {
			        				return getFormat(data,'d1')
			            		}
			            		return data;
						    },
					    },
						{ data: 'docDt',     visible: true,  className: 'dt-body-center', width: '100px', 
							render: function(data, type, row) {
			        			if (type === 'display') {
			        				return getFormat(data,'d1')
			            		}
			            		return data;
			  			    },
						},  
						{ data: 'evalType', visible: true,  className: 'dt-body-center', width: '100px'  },	
						
						{ data: 'patClass', visible: true,  className: 'dt-body-center', width: '100px'  },	
						
						{ data: 'useYn',  visible: true, className: 'dt-body-center', width: '100px',
							render: function(data, type, row) {
						        // 화면 출력용(type === 'display')일 때만 텍스트를 변환
								if (type === 'display') {
									return data === 'N' ? '' : '제외대상';
						        }
						        return data;
						    }
					    },
						{ data: 'patClass', visible: false,  className: 'dt-body-center', width: '100px'  }
	   				 ];
	   	
	   	// 초기 data Sort,  없으면 []
	   	muiltSorts = [];
	   	// Sort여부 표시를 일부만 할 때 개별 id, ** 전체 적용은 '_all'하면 됩니다. ** 전체 적용 안함은 []        				 
	   	showSortNo = ['_all'];                   
	   	// Columns 숨김 columnsSet -> visible로 대체함 hideColums 보다 먼제 처리됨 ( visible를 선언하지 않으면 hideColums컬럼 적용됨 )	
	   	hideColums = [];             // 없으면 []; 일부 컬럼 숨길때		
	   	txt_Markln = 20;                       				 // 컬럼의 글자수가 설정값보다 크면, 다음은 ...로 표시함
	   	// 글자수 제한표시를 일부만 할 때 개별 id, ** 전체 적용은 '_all'하면 됩니다. ** 전체 적용 안함은 []
	   	markColums = [];
    	
    } else {
    
	    c_Head_Set = [  '생년월일','대상자','입원일자','요양개시일','평가표작성일','평가구분','코드','점검내용','상세내용'  ];
	   	columnsSet = [  
	   					{ data: 'patId',     visible: true,  className: 'dt-body-center', width: '100px'  },
					    { data: 'patNm',     visible: true,  className: 'dt-body-center', width: '100px'  },					    
					    { data: 'admitDt',   visible: true,  className: 'dt-body-center', width: '100px',
						    render: function(data, type, row) {
			        			if (type === 'display') {
			        				return getFormat(data,'d1')
			            		}
			            		return data;
						    },
					    },
					    { data: 'medStart',  visible: true,  className: 'dt-body-center', width: '100px', 
							render: function(data, type, row) {
			        			if (type === 'display') {
			        				return getFormat(data,'d1')
			            		}
			            		return data;
						    },
					    },
						{ data: 'docDt',     visible: true,  className: 'dt-body-center', width: '100px', 
							render: function(data, type, row) {
			        			if (type === 'display') {
			        				return getFormat(data,'d1')
			            		}
			            		return data;
			  			    },
						},  
						{ data: 'evalType', visible: true,  className: 'dt-body-center', width: '100px'  },	
						
						{ data: 'errType',  visible: true, className: 'dt-body-center', width: '100px',
							render: function (data, type, row, meta) {
							        return '<span class="tooltip-cell" title="' + row.errName + '">' + data + '</span>';
							}
						},
						
						{ data: 'errType',  visible: true, className: 'dt-body-center', width: '100px',
							render: function(data, type, row) {
						        // 화면 출력용(type === 'display')일 때만 텍스트를 변환
						        if (type === 'display') {
						        	
						        	const prefix = data.charAt(0);  // 첫번쨰 추출
						        	
						            /* 평가구분 */
						            if (prefix === 'A') return '평가구분';
						            if (prefix === 'B') return '작성일자';
						            if (prefix === 'C') return '환자군 분류';
	
						            /* 유치도뇨관 */
						            if (prefix === 'D') return '삽입일자';
						            if (prefix === 'E') return '제거일자';
						            if (prefix === 'F') return '삽입기간';
						            if (prefix === 'G') return '삽입·제거일자';
						            if (prefix === 'H') return '소변조절';
	
						            /* 신규욕창 */
						            if (prefix === 'I') return '욕창 발생일 확인';
	
						            /* 욕창관리 */
						            if (prefix === 'J' && data === 'J1') return '욕창 과거력 확인';
						            if (prefix === 'J' && data === 'J2') return '욕창처치 확인';
						            if (prefix === 'J' && data === 'J3') return '욕창처치 확인';
	
						            /* 일상생활 */
						            if (prefix === 'K') return 'ADL 점수 점검';
						            if (prefix === 'L') return '행동증상 점검';
	
						            /* 당뇨환자 */
						            if (prefix === 'M') return '검사결과 입력';
						            if (prefix === 'N') return '검사일자 확인';
						          }
						          return data;
						    }
					    },
					    { data: 'errName', visible: false,  className: 'dt-body-center', width: '100px'  }	
	   				 ];
	   	
	   	// 초기 data Sort,  없으면 []
	   	muiltSorts = [];
	   	// Sort여부 표시를 일부만 할 때 개별 id, ** 전체 적용은 '_all'하면 됩니다. ** 전체 적용 안함은 []        				 
	   	showSortNo = ['_all'];                   
	   	// Columns 숨김 columnsSet -> visible로 대체함 hideColums 보다 먼제 처리됨 ( visible를 선언하지 않으면 hideColums컬럼 적용됨 )	
	   	hideColums = [];             // 없으면 []; 일부 컬럼 숨길때		
	   	txt_Markln = 20;                       				 // 컬럼의 글자수가 설정값보다 크면, 다음은 ...로 표시함
	   	// 글자수 제한표시를 일부만 할 때 개별 id, ** 전체 적용은 '_all'하면 됩니다. ** 전체 적용 안함은 []
	   	markColums = [];
    }
   	
	tableName = document.getElementById('errorTable');
	
	if (chkFlag === '0') {
   		
   		if ($.fn.DataTable.isDataTable('#' + tableName.id) ) {
   			dataTable.ajax.reload();
   		} else {
   			$('#' + tableName.id).DataTable().clear().destroy();
  			$('#' + tableName.id).empty();
   			fn_HeadColumnSet();
   			fn_FindDataTable();
   		}
   		
	} else {
		
		$('#' + tableName.id).DataTable().clear().destroy();
		$('#' + tableName.id).empty();
		fn_HeadColumnSet();
		fn_FindDataTable();
	}
   	
   	
   	/*
	if ($.fn.DataTable.isDataTable('#' + tableName.id) ) {
		if (set_Table === tableName.id){
			
			dataTable.ajax.reload();
			
		} else {
			$('#' + tableName.id).DataTable().clear().destroy();
			$('#' + tableName.id).empty();
			set_Table = tableName.id;
			fn_HeadColumnSet();
			fn_FindDataTable();
		}
	} else {
		set_Table = tableName.id;
		fn_HeadColumnSet();
		fn_FindDataTable();	
	}
   	*/
}




</script>	

<!-- ============================================================== -->
<!-- DataTable 설정 Start -->
<!-- ============================================================== -->
<script type="text/javascript">

function fn_HeadColumnSet() {
    tableName.style.display = 'none';

    // Table Heads 정리하기
    if (c_Head_Set.length > 0) {
        const thead = document.createElement('thead');
        thead.id = 'tableHead';

        if (Array.isArray(c_Head_Set[0])) {
            c_Head_Set.forEach(row => {
                const tr = document.createElement('tr');
                row.forEach(cell => {
                    const th = document.createElement('th');
                    th.textContent = cell.label || '';
                    if (cell.colspan) th.colSpan = cell.colspan;
                    if (cell.rowspan) th.rowSpan = cell.rowspan;
                    if (cell.class) th.classList.add(cell.class);
                    th.classList.add('dt-center');
                    tr.appendChild(th);
                });
                thead.appendChild(tr);
            });
        } else {
            const tr = document.createElement('tr');

            if (s_CheckBox) {
                const th = document.createElement('th');
                th.innerHTML = '<input type="checkbox" id="selectAll">';
                tr.appendChild(th);
            }

            if (s_AutoNums) {
                const th = document.createElement('th');
                th.textContent = 'No';
                tr.appendChild(th);
            }

            c_Head_Set.forEach(header => {
                const th = document.createElement('th');
                th.textContent = header;
                th.classList.add('dt-center');
                tr.appendChild(th);
            });

            thead.appendChild(tr);
        }

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
            gridColums.push({
                data: null,
                orderable: false,
                searchable: false,
                className: 'select-checkbox dt-body-center',
                render: function (data, type, full, meta) {
                    return '<input type="checkbox" name="id[]" value="' + $('<div/>').text(data.id).html() + '">';
                }
            });
            setnum++;
        }

        if (s_AutoNums) {
            gridColums.push({
                data: null,
                orderable: false,
                searchable: false,
                className: 'dt-body-center',
                render: function (data, type, row, meta) {
                    return meta.row + 1;
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

            if (markColums.includes(columnsSet[i].data)) mark_Colnm.push(setnum + i);
            if (showSortNo.includes(columnsSet[i].data)) show_Sorts.push(setnum + i);
            if (hideColums.includes(columnsSet[i].data)) hide_Colnm.push(setnum + i);
            for (let d = 0; d < muiltSorts.length; d++) {
                if (muiltSorts[d][0] === columnsSet[i].data) {
                    muilt_Sort.push(setnum + i);
                    muilt_Sort.push(muiltSorts[d][1]);
                }
            }
        }

     	// Button 생성
     	/* btn-outline-danger 
        gridColums.push({ data: null, orderable: false, searchable: false, className: 'dt-center',
            render: function(data, type, row) { 
                return  '<button class="btn btn-outline-danger btn-xs del-btn">삭제..<i class="far fa-trash-alt"></i></button>';
            }
        });
     	*/

        if (mark_Colnm.length > 0) markColums = mark_Colnm;
        if (show_Sorts.length > 0) showSortNo = show_Sorts;
        if (hide_Colnm.length > 0) hideColums = hide_Colnm;
        if (muilt_Sort.length > 0) {
            muiltSorts = [];
            for (let j = 0; j < muilt_Sort.length; j += 2) {
                muiltSorts.push([muilt_Sort[j], muilt_Sort[j + 1]]);
            }
        }
    }

    tableName.style.display = 'inline-block';
}

function fn_FindDataTable() {
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
				fixedHeader:    fixed_Head, 
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
		        
		        /*
		        dom: showButton ? '<"row"<"col-sm-2"l><"col-sm-7"><"col-sm-3"f>>Bt<"row mt-2"<"col-sm-7"i><"col-sm-5"p>>' : 
		        	              '<"row"<"col-sm-2"l><"col-sm-7"><"col-sm-3"f>>t<"row mt-2"<"col-sm-7"i><"col-sm-5"p>>', // 조건에 따라 dom 설정
		        */
		        
    	        // 페이지와 버튼 간격 좁히기 
    	        /*
			    dom: showButton  
			        ? '<"datatable-controls d-flex align-items-center justify-content-between"<"d-flex"<B><"ml-auto"f>>>' +
			          't' +
			          '<"row mt-2"<"col-sm-7"i><"col-sm-5"p>>'
			        : '<"datatable-controls d-flex align-items-center justify-content-between"<"d-flex"<"mr-2"l><"mr-2"B><"ml-auto"f>>>' +
			          't' +
			          '<"row mt-2"<"col-sm-7"i><"col-sm-5"p>>',
                */	 
                dom: showButton  
	                ? '<"datatable-controls d-flex align-items-center justify-content-between"<"d-flex"<B><"ml-2 f-container"f>>>' +
	                  't' +
	                  '<"row mt-2"<"col-sm-7"i><"col-sm-5"p>>'
	                : '<"datatable-controls d-flex align-items-center justify-content-between"<"d-flex"<"mr-2"l><"mr-2"B><"ml-2 f-container"f>>>' +
	                  't' +
	                  '<"row mt-2"<"col-sm-7"i><"col-sm-5"p>>',    
					          
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
	    
	    // 보기 버튼 클릭 이벤트
	    $('#' + tableName.id + ' tbody').on('click', '.showbtn', function() {
	    	
	    	var data = dataTable.row($(this).parents('tr')).data();
	    	// 여기에 보기 로직을 구현하세요
	        
	    	fn_ViewData(data);
	    	
	        
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
	    	// 여기에 삭제 로직을 구현하세요
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
	    
	    if (jobFlag === '99') {
        	
	    	dataTable.on('dblclick', 'tr', function (e) {
        		
        		let selData = dataTable.row(this).data();
        		let msgText = '';
        		let chnText = '';
        		
        		if (selData.useYn === 'N') {
        			msgText = '제외 하시겠습니까 ?';
        			chnText = 'Y';
        		} else {
        			msgText = '포함 하시겠습니까 ?';
        			chnText = 'N';
        		} 
        			
       			Swal.fire({title:'제외여부',text:msgText,icon:'question',showCancelButton:true,confirmButtonText:'예',cancelButtonText:'아니오'}).then((result) => {
       			
       				if (result.isConfirmed) {
				
       					$.ajax({
			    		  url: "/main/modifyPatval.do",
		   	              type: "POST",
		   	              data: { hospCd: hospid,
		   	            	      patId: selData.patId,
		   	            	      admitDt: selData.admitDt,
		   	            	      medStart: selData.medStart,
		   	            	      useYn: chnText,
		   	            	      UpdUser: userid
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
					      },
					      error: function(xhr, status, error) {
					          console.error("Error fetching data:", error);
					      }
					      
						});
				  	}
		        });
        		
        		
	        });
        }   
	    
	    
	})(jQuery);
	
}	   

//ajax 함수 정의
function dataLoad(data, callback, settings) {

	//var table = $(settings.nTable).DataTable();
    //table.processing(true); // 처리 중 상태 시작
    
	let selected_Year = document.getElementById("year_Select").value;
    let selectedMonth = document.getElementById("monthSelect").value;
    let waitingCreate = document.getElementById("wait_Create");
    
    
    $.ajax({
    	url: "/main/select_assesCheck.do",
        type: "POST",
        data: { hospCd: hospid,
 	            jobYymm: selected_Year + selectedMonth,
     	        jobFlag: jobFlag 
   		},
        dataType: "json",
        // timeout: 10000, // 10초 후 타임아웃
        beforeSend : function () {
        	
		},
        success: function(response) {
        	//table.processing(false); // 처리 중 상태 종료
        	waitingCreate.style.display = 'none';
            if (response && Object.keys(response).length > 0) {
            	
            	callback(response);
            	tableName.style.display = 'inline-block';
                
            	
            } else {
            	
            	callback([]); // 빈 배열을 콜백으로 전달
            }
        },
        error: function(jqXHR, textStatus, errorThrown) {
        	waitingCreate.style.display = 'none';
        	//table.processing(false); // 처리 중 상태 종료		                    
            callback({
                data: []
            });
            //table.clear().draw(); // 테이블 초기화 및 다시 그리기
        }
    });
    
}



</script>
<!-- ============================================================== -->
<!-- DataTable 설정 End -->
<!-- ============================================================== -->


	  
<script type="text/javascript">	
	
$(document).ready(function() {
	
	//현재 연도를 기준으로 첫 번째 옵션과 나머지 9개의 연도를 동적으로 생성
	function populateYearSelect() {
	    
		const year_Select = document.getElementById('year_Select');
	    const monthSelect = document.getElementById('monthSelect');
	    
	    const currentYear = new Date().getFullYear();
	    const current_Mon = new Date().getMonth() + 1;
	    
	    // 기존 옵션 제거
	    year_Select.innerHTML = '';
	    monthSelect.innerHTML = '';
	    
	    
	    // 당해년도 포함 10년 Setting
	    for (let i = 0; i <= 9; i++) {
	    	
	    	const year = currentYear - i;

	        const option = document.createElement('option');
	        option.value = year;
	        option.textContent = year;
	        if (year === currentYear) option.selected = true;
	        year_Select.appendChild(option);
	    }
	 	// 월 생성 로직
	    for (let i = 1; i <= 12; i++) {
	        let month = i < 10 ? '0' + i : i;
	        const option = document.createElement('option');
	        option.value = month;
	        option.textContent = month;
	        
	        // 현재 달 기준으로 전월 선택
	        if (i === current_Mon) {
	            option.selected = true; // 기본 선택값 설정
	        }
	        
	        monthSelect.appendChild(option);
	    }

	 	/*
	    // 만약 전월이 0이라면(1월 기준), 12월을 선택
	    if (current_Mon === 1) {
	        monthSelect.value = '12';
	    }
	 	*/
	}	
	
	populateYearSelect();
	
	$('#year_Select').on('change', function() {
		
    });
	$('#monthSelect').on('change', function() {
		
    });
	
	
	if (winner === 'Y') {
        document.getElementById("etarget").style.display = "flex";
    } else {
    	document.getElementById("etarget").style.display = "none";
    }
	
	fn_CreateData('00');	
	
	
});
	
</script> 


       
