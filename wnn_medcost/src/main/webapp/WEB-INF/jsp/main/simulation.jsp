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
					    
					    <div class="col-lg-2">
					        <div class="card h-100">
					            <div class="card-body">
					                <table id="hospitalTable" class="display nowrap stripe hover cell-border order-column responsive"></table>
					                - 더블클릭시 선택,취소 됩니다.
					            </div>					            
					        </div>
					    </div>
					    
					    <div class="col-lg-10 d-flex flex-column">
					        <!-- 상단 -->
					        <div class="card mb-1">
					            <div class="card-header d-flex align-items-center">
					                <h3 class="card-header-title mb-0 mr-1">년</h3>
					                <select id="year_Select1" class="custom-select w-auto mr-3"></select>
					
					                <h3 class="card-header-title mb-0 mr-1">월</h3>
					                <select id="monthSelect1" class="custom-select w-auto mr-3"></select>
					
					                <h3 class="card-header-title mb-0 mr-1">월</h3>
					                <select id="monthSelect2" class="custom-select w-auto mr-3"></select>
					
					                <button class="btn indi-custom-btn text-white     btn-sm w-auto mr-3" onClick="fn_ViewData(1)">기간별 보기</button>
					                <button class="btn btn-outline-primary            btn-sm w-auto mr-3" onClick="fn_ViewData(2)">상반기 보기</button>
					                <button class="btn btn-outline-success text-green btn-sm w-auto mr-3" onClick="fn_ViewData(3)">하반기 보기</button>
					            </div>
					        </div>
					        
					        <div class="card">
					            <div class="card-body">
					                <table id="indicatorTable" class="display nowrap stripe hover cell-border order-column responsive"></table>
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
var stryymm = '199901';
var endyymm = '199901';

var tableName = ['hospitalTable', 'indicatorTable']; // 테이블 ID 목록
var table_Idx = 0;
var dataTable = [];

var checkHosp = null;
var edit_Data = null;


<!-- ============================================================== -->
<!-- Table Setting Start -->
<!-- ============================================================== -->
var gridColums = [];
var btm_Scroll = true;   		// 하단 scroll여부 - scrollX
var auto_Width = true;   		// 열 너비 자동 계산 - autoWidth
var page_Hight = 750;    		// Page 길이보다 Data가 많으면 자동 scroll - scrollY
var p_Collapse = true;  		// Page 길이까지 auto size - scrollCollapse
var fixed_Head = true;          // 헤더 고정 

var datWaiting = false;   		// Data 가져오는 동안 대기상태 Waiting 표시 여부
var page_Navig = false;   		// 페이지 네비게이션 표시여부 
var hd_Sorting = false;   		// Head 정렬(asc,desc) 표시여부
var info_Count = false;   		// 총건수 대비 현재 건수 보기 표시여부 
var searchShow = false;   		// 검색창 Show/Hide 표시여부
var find_Title = '자 료 검 색 : ';
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

var colPadding = '2px';   		// 행 높이 간격 설정
var data_Count = [30 , 50, 70, 100, 150, 200];  // Data 보기 설정
var defaultCnt = 30;                            // Data Default 갯수

var s_CheckBox = true;   		           	    // CheckBox 표시 여부
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

function fn_HospSelect() {

	jobFlag = '00';

	page_Hight = 750;    		// Page 길이보다 Data가 많으면 자동 scroll - scrollY
	datWaiting = false;   		// Data 가져오는 동안 대기상태 Waiting 표시 여부
	page_Navig = false;   		// 페이지 네비게이션 표시여부 
	hd_Sorting = false;   		// Head 정렬(asc,desc) 표시여부
	info_Count = false;   		// 총건수 대비 현재 건수 보기 표시여부 
	searchShow = true;   		// 검색창 Show/Hide 표시여부
	showButton = false;   		// Button (복사, 엑셀, 출력)) 표시여부
	s_CheckBox = true;  
	find_Title = '&nbsp;병원검색 :';
	colPadding = '2px';   		// 행 높이 간격 설정
	
	c_Head_Set = [ '병원코드','병원명칭' ];   
	
   	columnsSet = [  
   		            { data: 'hosp_cd', visible: false, className: 'dt-body-center', width: '100px' },
   					{ data: 'hosp_nm', visible: true,  className: 'dt-body-left',   width: '300px' }
   				 ];
   	// 초기 data Sort,  없으면 []
   	muiltSorts = [];
   	// Sort여부 표시를 일부만 할 때 개별 id, ** 전체 적용은 '_all'하면 됩니다. ** 전체 적용 안함은 []        				 
   	showSortNo = ['_all'];                   
   	// Columns 숨김 columnsSet -> visible로 대체함 hideColums 보다 먼제 처리됨 ( visible를 선언하지 않으면 hideColums컬럼 적용됨 )	
   	hideColums = [];             // 없으면 []; 일부 컬럼 숨길때		
   	txt_Markln = 15;                       				 // 컬럼의 글자수가 설정값보다 크면, 다음은 ...로 표시함
   	// 글자수 제한표시를 일부만 할 때 개별 id, ** 전체 적용은 '_all'하면 됩니다. ** 전체 적용 안함은 []
   	markColums = ['hosp_nm'];
   	
   	table_Idx = 0;
   	
   	fn_HeadColumnSet();
   	fn_FindDataTable();
   	
   	
}

function fn_ViewData(flag) {
	
	if        (flag === 2){
		$("#monthSelect1").val("01");
		$("#monthSelect2").val("06");
	} else if (flag === 3){
		$("#monthSelect1").val("07");
		$("#monthSelect2").val("12");
	}
	
	if (winner !== 'Y') {
	    
		const table = dataTable[0];
		table.rows().every(function () {
		    const row_Node = this.node();
		    const checkbox = $(row_Node).find('input[type="checkbox"]');
		    
		    checkbox.prop('checked', true);
		    
		});
	}
	
    fn_IndiSelect();
}

function fn_IndiSelect() {

	jobFlag = '01';
	
	datWaiting = false;   		// Data 가져오는 동안 대기상태 Waiting 표시 여부
	page_Navig = false;   		// 페이지 네비게이션 표시여부 
	hd_Sorting = false;   		// Head 정렬(asc,desc) 표시여부
	info_Count = false;   		// 총건수 대비 현재 건수 보기 표시여부 
	searchShow = false;   		// 검색창 Show/Hide 표시여부
	showButton = true;   		// Button (복사, 엑셀, 출력)) 표시여부
	s_CheckBox = false;  
	colPadding = '9px';   		// 행 높이 간격 설정
	
	const y_y = document.getElementById('year_Select1').value;
	const mm1 = document.getElementById('monthSelect1').value;
	const mm2 = document.getElementById('monthSelect2').value;

	const year = parseInt(y_y);
	const sMon = parseInt(mm1);  // 시작월
	const eMon = parseInt(mm2);  // 종료월
	const yymm = [];

	let monthDiff = eMon - sMon + 1;

	if (monthDiff > 0 && monthDiff <= 6) {
	    for (let i = 0; i < monthDiff; i++) {
	        let cMons = sMon + i;
	        let cYear = year;

	        if (cMons > 12) {
	        	cYear += Math.floor((cMons - 1) / 12);
	        	cMons = (cMons - 1) % 12 + 1;
	        }
             
	        yymm[i] = cYear + '년 ' + cMons.toString().padStart(2, '0') + '월';
	    }
	} else {
	    messageBox("1", "<h5>대상년월 확인. <br>" + "최대 6개월까지만 선택할 수 있습니다." + "</h5><p></p><br>", "", "", "");
	    return;
	}
    
	c_Head_Set = [
			[
				{ label: '지표코드', rowspan: 2 },
			    { label: '지표명',  rowspan: 2 },
			    { label: '포함',   rowspan: 2 },
			    { label: '가중치',  rowspan: 2 },
			    
			    { label: yymm[0], colspan: 2 },
			    { label: yymm[1], colspan: 2 },
			    { label: yymm[2], colspan: 2 },
			    { label: yymm[3], colspan: 2 },
			    { label: yymm[4], colspan: 2 },
			    { label: yymm[5], colspan: 2 },
			    
			    { label: '총 분모·분자', colspan: 2 },
			    { label: '5점구간', rowspan: 2 },
			    { label: '평균', colspan: 2 }
			    
			],
			[
				{ label: '현황값' },
			    { label: '결과' },
			    { label: '현황값' },
			    { label: '결과' },
			    { label: '현황값' },
			    { label: '결과' },
			    { label: '현황값' },
			    { label: '결과' },
			    { label: '현황값' },
			    { label: '결과' },
			    { label: '현황값' },
			    { label: '결과' },
			    
			    { label: '분모' },
			    { label: '분자' },
			    { label: '현황값' },
			    { label: '결과' }
			    
		 	]
		 ];
	
	columnsSet = [  
		    { data: 'cate_cd', visible: false, className: 'dt-body-center', width: '50px'  },
		    { data: 'cate_nm', visible: true,  className: 'dt-body-left',    width: '100px' },
		    
		    { data: null,      visible: true, orderable: false, searchable: false, width: '10px', className: 'select-checkbox dt-body-center',
		    	render: function (data, type, full, meta) {
		    		if (full.cate_cd !== '99') {
		                return '<input type="checkbox" name="id[]" value="' +
		                       $('<div/>').text(full.id).html() + '" checked>';
		            } else {
		                return ''; // 아무것도 표시하지 않음
		            }
		        }
            },
            
			{ data: 'stdweig', name: 'stdweig', visible: true,  className: 'dt-body-center', width: '10px'  },
			
			{ data: 'calval1', visible: true,  className: 'dt-body-center', width: '10px', 
				render: function(data, type, row) {
        			if (type === 'display') {
        				if (row.cate_cd === '99') {
        			        return '';
        			    }
            		}
            		return data;
  			    },
			},
			{ data: 'weival1', visible: true,  className: 'dt-body-center', width: '10px', 
				render: function(data, type, row) {
        			if (type === 'display') {
        				if (row.cate_cd === '99') {
        			        return '';
        			    }
            		}
            		return data;
  			    },
			},
			{ data: 'calval2', visible: true,  className: 'dt-body-center', width: '10px', 
				render: function(data, type, row) {
        			if (type === 'display') {
        				if (row.cate_cd === '99') {
        			        return '';
        			    }
            		}
            		return data;
  			    },
			},
			{ data: 'weival2', visible: true,  className: 'dt-body-center', width: '10px', 
				render: function(data, type, row) {
        			if (type === 'display') {
        				if (row.cate_cd === '99') {
        			        return '';
        			    }
            		}
            		return data;
  			    },
			},
			{ data: 'calval3', visible: true,  className: 'dt-body-center', width: '10px', 
				render: function(data, type, row) {
        			if (type === 'display') {
        				if (row.cate_cd === '99') {
        			        return '';
        			    }
            		}
            		return data;
  			    },
			},
			{ data: 'weival3', visible: true,  className: 'dt-body-center', width: '10px', 
				render: function(data, type, row) {
        			if (type === 'display') {
        				if (row.cate_cd === '99') {
        			        return '';
        			    }
            		}
            		return data;
  			    },
			},
			{ data: 'calval4', visible: true,  className: 'dt-body-center', width: '10px', 
				render: function(data, type, row) {
        			if (type === 'display') {
        				if (row.cate_cd === '99') {
        			        return '';
        			    }
            		}
            		return data;
  			    },
			},
			{ data: 'weival4', visible: true,  className: 'dt-body-center', width: '10px', 
				render: function(data, type, row) {
        			if (type === 'display') {
        				if (row.cate_cd === '99') {
        			        return '';
        			    }
            		}
            		return data;
  			    },
			},
			{ data: 'calval5', visible: true,  className: 'dt-body-center', width: '10px', 
				render: function(data, type, row) {
        			if (type === 'display') {
        				if (row.cate_cd === '99') {
        			        return '';
        			    }
            		}
            		return data;
  			    },
			},
			{ data: 'weival5', visible: true,  className: 'dt-body-center', width: '10px', 
				render: function(data, type, row) {
        			if (type === 'display') {
        				if (row.cate_cd === '99') {
        			        return '';
        			    }
            		}
            		return data;
  			    },
			},
			{ data: 'calval6', visible: true,  className: 'dt-body-center', width: '10px', 
				render: function(data, type, row) {
        			if (type === 'display') {
        				if (row.cate_cd === '99') {
        			        return '';
        			    }
            		}
            		return data;
  			    },
			},
			{ data: 'weival6', visible: true,  className: 'dt-body-center', width: '10px', 
				render: function(data, type, row) {
        			if (type === 'display') {
        				if (row.cate_cd === '99') {
        			        return '';
        			    }
            		}
            		return data;
  			    },
			},
			
			{ data: 'ntortot', visible: true,  className: 'dt-body-center', width: '30px', 
				render: function(data, type, row) {
        			if (type === 'display') {
        				if (row.cate_cd === '99') {
        			        return '';
        			    }
            		}
            		return data;
  			    },
			},
			{ data: 'dtortot', visible: true,  className: 'dt-body-center', width: '30px', 
				render: function(data, type, row) {
        			if (type === 'display') {
        				if (row.cate_cd === '99') {
        			        return '';
        			    }
            		}
            		return data;
  			    },
			},		
			{ data: 'fiveZone', visible: true, className: 'dt-body-center', width: '30px',
				createdCell: function(td, cellData) {
					td.style.color = 'red';
		            td.style.fontWeight = 'red';
			    }
		    },
		    { data: 'cal_avg', visible: true,  className: 'dt-body-center', width: '30px', 
				render: function(data, type, row) {
        			if (type === 'display') {
        				if (row.cate_cd === '99') {
        			        return '';
        			    }
            		}
            		return data;
  			    },
			},
		    { data: 'weigavg', name: 'weigavg', visible: true,  className: 'dt-body-center', width: '30px'  }
		    
		 ];
	
	// 초기 data Sort,  없으면 []
	muiltSorts = [];
	// Sort여부 표시를 일부만 할 때 개별 id, ** 전체 적용은 '_all'하면 됩니다. ** 전체 적용 안함은 [] 
	
	showSortNo = [];
	// Columns 숨김 columnsSet -> visible로 대체함 hideColums 보다 먼제 처리됨 ( visible를 선언하지 않으면 hideColums컬럼 적용됨 )	
	hideColums = [];             // 없으면 []; 일부 컬럼 숨길때		
	txt_Markln = 11;                       				 // 컬럼의 글자수가 설정값보다 크면, 다음은 ...로 표시함
	// 글자수 제한표시를 일부만 할 때 개별 id, ** 전체 적용은 '_all'하면 됩니다. ** 전체 적용 안함은 []
	markColums = ['cate_nm'];
	
	checkHosp  = getCheckedData(0);
	console.log('✔ 선택된 행 :', JSON.stringify(checkHosp));
	
	if (checkHosp.length === 0) {
    	Swal.fire({
            title: '✔ 선택된 행 확인',
            text:  '선택된 병원이 없습니다.',
            icon:  'warning',
            confirmButtonText: '확인',
            timer: 1000,
            timerProgressBar: true,
            showConfirmButton: false
     	});
    	
    } else {
    	
    	table_Idx = 1;
    	
    	if (
    		   (stryymm !== document.getElementById('year_Select1').value + document.getElementById('monthSelect1').value) ||
    		   (endyymm !== document.getElementById('year_Select1').value + document.getElementById('monthSelect2').value)
    		) {
    		    stryymm   = document.getElementById('year_Select1').value + document.getElementById('monthSelect1').value;
    		    endyymm   = document.getElementById('year_Select1').value + document.getElementById('monthSelect2').value;

    		    $('#' + tableName[table_Idx]).DataTable().clear().destroy();
    		    $('#' + tableName[table_Idx]).empty();

    		    fn_HeadColumnSet();
    		    fn_FindDataTable();
    		    
    	} else {
    			
    		if ($.fn.DataTable.isDataTable('#' + tableName[table_Idx])) {
    			dataTable[table_Idx].ajax.reload();
    	    } else {
    	    	fn_HeadColumnSet();
    	        fn_FindDataTable();
    	    }
    	}	
    }
	
}


</script>	

<!-- ============================================================== -->
<!-- DataTable 설정 Start -->
<!-- ============================================================== -->
<script type="text/javascript">

function fn_HeadColumnSet() {
    
    // Table Heads 정리하기
    if (c_Head_Set.length > 0) {
        const thead = document.createElement('thead');
        thead.id = 'tableHead';

        if (Array.isArray(c_Head_Set[0])) {
        	
        	// 다단 헤더 (2차원 배열)
            c_Head_Set.forEach((row, rowIndex) => {
                const tr = document.createElement('tr');
                row.forEach(cell => {
                    const th = document.createElement('th');

                    // 조건부 줄바꿈 처리
                    if        (cell.label === '5점구간') {
                        th.innerHTML = '5점<br>구간';
                    } else {
                        th.textContent = cell.label || '';
                    }

                    if (cell.colspan) th.colSpan = cell.colspan;
                    if (cell.rowspan) th.rowSpan = cell.rowspan;
                    if (cell.class)   th.classList.add(cell.class);
                    th.classList.add('dt-center');
                    tr.appendChild(th);
                });

                thead.appendChild(tr);
            });

            
        } else {
        	
            const tr = document.createElement('tr');

            if (s_CheckBox) {
                const th = document.createElement('th');
                th.innerHTML = '<input type="checkbox" id="selectAll_' + table_Idx + '">';
                tr.appendChild(th);
            }

            if (s_AutoNums) {
                const th = document.createElement('th');
                th.textContent = 'No';
                tr.appendChild(th);
            }

            c_Head_Set.forEach(header => {
                const th = document.createElement('th');
                
                if        (header === '5점구간') {
                    th.innerHTML = '5점<br>구간';
                } else if (header === '전월상병') {
                    th.innerHTML = '전월<br>상병';
                } else {
                    th.textContent = header;
                }

                th.classList.add('dt-center');
                tr.appendChild(th);
            });

            thead.appendChild(tr);
        }

        const tableElement = document.getElementById(tableName[table_Idx]);
        
        if (!tableElement) {
            console.error("Table element not found for ID:", tableName[table_Idx]);
            return;
        }

        const existingThead = tableElement.querySelector('thead');
        if (existingThead) {
        	tableElement.removeChild(existingThead);
        }
        tableElement.insertBefore(thead, tableElement.firstChild);
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

}

function getCheckedData(idx) {
	
	const table = dataTable[idx];
    const hosps = [];

    table.rows().every(function () {
        const row_Node = this.node();
        const checkbox = $(row_Node).find('input[type="checkbox"]');

        if (checkbox.prop('checked')) {
            const rowData = this.data();
            if (rowData && rowData.hosp_cd) {
                hosps.push(rowData.hosp_cd);
            }
        }
    });
    return hosps;
}





function bindTableEvents(idx) {
    let tableId     = tableName[idx];
    let selectAllId = '#selectAll_' + idx;
    let table       = dataTable[idx];

    // 1. 전체 선택
    $(selectAllId).off('click').on('click', function () {
        let rows = table.rows({ search: 'applied' }).nodes();
        $('input[type="checkbox"]', rows).prop('checked', this.checked);
    });

    // 2. 개별 체크박스
    $('#' + tableId + ' tbody').off('change', 'input[type="checkbox"]').on('change', 'input[type="checkbox"]', function () {
        let total = table.rows().count();
        let checked = $('input[type="checkbox"]:checked', table.rows().nodes()).length;
        $(selectAllId).prop('checked', checked === total);
        
        if (tableId === 'indicatorTable') {
	        let row     = table.row($(this).closest('tr'));
	        let rowData = row.data();
	        if (rowData) {
	            
	        	let col_Idx1 = table.column('stdweig:name').index();
	        	let col_Idx2 = table.column('weigavg:name').index();
	        	
	            let rowIndex = table.rows().count() - 1;
	            
	            let col_Val1 = parseFloat(table.cell(rowIndex, col_Idx1).data()) || 0;
	            let col_Val2 = parseFloat(table.cell(rowIndex, col_Idx2).data()) || 0;
	            
	            let row_Val1 = parseFloat(rowData.stdweig) || 0;
	            let row_Val2 = parseFloat(rowData.weigavg) || 0;
	            
	            if ($(this).is(':checked')) {
	            	col_Val1 += row_Val1;
	            	col_Val2 += row_Val2;
	            } else {
	            	col_Val1 -= row_Val1;
	            	col_Val2 -= row_Val2;
	            }
	            
	            if (col_Val1 === 100.00) {
	            	table.cell(rowIndex, col_Idx1).data(100).draw(false);
	            } else {
	            	table.cell(rowIndex, col_Idx1).data(col_Val1.toFixed(2)).draw(false);
	            }
	            if (col_Val2 === 100.00) {
	            	table.cell(rowIndex, col_Idx2).data(100).draw(false);
	            } else {
	            	table.cell(rowIndex, col_Idx2).data(col_Val2.toFixed(2)).draw(false);
	            }
	        }
        }
    });

    
    // 3. 첫 번째 칼럼 클릭
    $('#' + tableId).off('click').on('click', 'td', function (e) {
        let column = $(this).index();
        let $row = $(this).closest('tr');
        let $checkbox = $row.find('input[type="checkbox"]');
        
        if (tableId === 'hospitalTable') {
	        if (!$(e.target).is(':checkbox') && column === 0) {
	            e.preventDefault();
	            $checkbox.trigger('click');
	        }
        }
    });

    // 4. row 클릭
    $('#' + tableId + ' tbody').off('click', 'tr').on('click', 'tr', function () {
        edit_Data = table.row(this).data();
        
        
    });

    // 5. 싱글 선택
    if (row_Select) {
    	
    	const tbody = $('#' + tableId + ' tbody');

        // 싱글 선택
        tbody.on('click', 'tr', function (e) {
            let classList = e.currentTarget.classList;
            if (!classList.contains('selected')) {
                table.rows('.selected').nodes().each((row) => row.classList.remove('selected'));
                classList.add('selected');
            }
            
        });
		
        if (tableId === 'hospitalTable') {
	        // 더블클릭 시 체크박스 토글
	        tbody.on('dblclick', 'tr', function (e) {
	            // 해당 행에서 체크박스를 찾음
	            const checkbox = $(this).find('input[type="checkbox"]');
	            if (checkbox.length > 0) {
	                checkbox.prop('checked', !checkbox.prop('checked')); // 체크 토글
	            }
	        });
        }
    }
    
    
}

function fn_FindDataTable() {
	
	(function($) {
		dataTable[table_Idx] = $('#' + tableName[table_Idx]).DataTable({	
				language : {
					search: find_Title,
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
                /*
	                ? '<"datatable-controls d-flex align-items-center justify-content-between"<"d-flex"<B><"f-container"f>>>' +
	                  't' +
	                  '<"row mt-2"<"col-sm-7"i><"col-sm-5"p>>'
	                : '<"datatable-controls d-flex align-items-center justify-content-between"<"d-flex"<"mr-2"l><"mr-2"B><"mb-1 f-container"f>>>' +
	                  't' +
	                  '<"row mt-2"<"col-sm-7"i><"col-sm-5"p>>',
				*/
				    ? '<"datatable-controls d-flex align-items-center justify-content-between"<B><f>>' +
					  't' +
					  '<"row mt-2"<"col-sm-7"i><"col-sm-5"p>>'
				    : '<"datatable-controls d-flex align-items-center justify-content-between"<l><B><"mb-1"f>>' +
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
		
		$('body').on('mouseenter', 'td', function () {
	    	let tblid = $(this).closest('table').attr('id');
	        table_Idx = tableName.indexOf(tblid);
	    });
	    
		bindTableEvents(table_Idx);
		
		
	})(jQuery);
	
}	   

//ajax 함수 정의
function dataLoad(data, callback, settings) {
	
	if (jobFlag === "00") {
	
		let hospital = hospid;
		
		if (winner === 'Y') {
			hospital = '';
        }
		
	    $.ajax({
	    	url: "/main/select_HospitalMst.do",
	        type: "POST",
	        data: { hosp_cd: hospital
	    	},
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
	        	callback({
	                data: []
	            });
	        }
	    });
	    
    } else {
    	
    	let monthList = new Array(6).fill('');  // 6개를 ''으로 초기화
    	let str = new Date(stryymm.substring(0, 4), stryymm.substring(4, 6) - 1);
    	let end = new Date(endyymm.substring(0, 4), endyymm.substring(4, 6) - 1);

    	let cur = new Date(str);
    	let idx = 0;

    	while (cur <= end && idx < 6) {
    	    let yy = cur.getFullYear();
    	    let mm = String(cur.getMonth() + 1).padStart(2, '0');
    	    monthList[idx] = yy + mm;
    	    cur.setMonth(cur.getMonth() + 1);
    	    idx++;
    	}

    	// 디버그 출력
    	console.log("checkHosp:", checkHosp);
    	console.log("monthList:", monthList);

	    
	    $.ajax({
	    	url: "/main/select_Hosp_Indi.do",
	        type: "POST",
	        traditional: true, 
	        data: { 
	        	hosp_cd: checkHosp,
		        stryymm: stryymm,
		        endyymm: endyymm,
		        month_1: monthList[0],
		        month_2: monthList[1],
		        month_3: monthList[2],
		        month_4: monthList[3],
		        month_5: monthList[4],
		        month_6: monthList[5]
	    	},
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
    
}



</script>
<!-- ============================================================== -->
<!-- DataTable 설정 End -->
<!-- ============================================================== -->


	  
<script type="text/javascript">	
	
$(document).ready(function() {
	
	//현재 연도를 기준으로 첫 번째 옵션과 나머지 9개의 연도를 동적으로 생성
	function populateYearSelect() {
		const year_Select1 = document.getElementById('year_Select1');
	    const monthSelect1 = document.getElementById('monthSelect1');
	    const monthSelect2 = document.getElementById('monthSelect2');
	    
	    const currentYear = new Date().getFullYear();
	    const current_Mon = new Date().getMonth() + 1;
	    
	    // 기존 옵션 제거
	    year_Select1.innerHTML = '';
	    monthSelect1.innerHTML = '';
	    monthSelect2.innerHTML = '';
	    
	    // 당해년도 포함 10년 Setting
	    for (let i = 0; i <= 9; i++) {
	    	
	    	const year = currentYear - i;

	        const option1 = document.createElement('option');
	        option1.value = year;
	        option1.textContent = year;
	        if (year === currentYear) option1.selected = true;
	        year_Select1.appendChild(option1);

	    }
	    
	 	// 월 생성 로직
	    for (let i = 1; i <= 12; i++) {
	        let month2 = i < 10 ? '0' + i : i;
	        const option2 = document.createElement('option');
	        option2.value = month2;
	        option2.textContent = month2;
	        
	        // 현재 달 기준으로 전월 선택
	        if (i === current_Mon) {
	            option2.selected = true; // 기본 선택값 설정
	        }
	        monthSelect1.appendChild(option2);
	    }
	 	/*
	    // 만약 전월이 0이라면(1월 기준), 12월을 선택
	    if (current_Mon === 1) {
	        monthSelect1.value = '12';
	    }
	    */
	    
	    // 월 생성 로직
	    for (let i = 1; i <= 12; i++) {
	        let month3 = i < 10 ? '0' + i : i;
	        const option3 = document.createElement('option');
	        option3.value = month3;
	        option3.textContent = month3;
	        
	        // 현재 달 기준으로 전월 선택
	        if (i === current_Mon) {
	            option3.selected = true; // 기본 선택값 설정
	        }
	        monthSelect2.appendChild(option3);
	    }
	    /*
	    // 만약 전월이 0이라면(1월 기준), 12월을 선택
	    if (current_Mon === 1) {
	        monthSelect2.value = '12';
	    }
	    */
	    
	}	
	
	populateYearSelect();
	
	$('#year_Select1').on('change', function() {
		
    });
	$('#monthSelect1').on('change', function() {
		
    });
    $('#monthSelect2').on('change', function() {
    	
    });
    
    fn_HospSelect();	
	

});


	
</script> 


       
