<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="decorator"
	uri="http://www.opensymphony.com/sitemesh/decorator"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/page" prefix="page"%>
<%@ page import="java.util.Date"%>
<!-- Customized Bootstrap Stylesheet -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" /> <!-- 아이콘 -->
<link href="/css/winmc/style_comm.css?v=126"  rel="stylesheet">
<style>
  .dashboard-wrapper * {
    font-size: 13px !important;
  }
  #hang_tableName td, 
  #hang_tableName th {
    padding: 12px 8px;
  }

  #hang_tableName tbody tr {
    height: 25px;
  }
</style>
<!-- ============================================================== -->
<!-- Main Form start -->
<!-- ============================================================== -->
<div class="dashboard-wrapper">
  <div class="container-fluid dashboard-content px-1">
    <div class="row mx-0">
      <!-- 전체 탭 카드 -->
      <div class="col-12">
        <div class="card mb-1">
          <div class="card-body">
            <ul class="nav nav-tabs mb-2" id="leftTab" role="tablist">
              <li class="nav-item" role="presentation">
                <button class="nav-link active" id="tab1-tab" data-bs-toggle="tab" data-bs-target="#tab1" type="button" role="tab">청구대상자</button>
              </li>
              <li class="nav-item" role="presentation">
                <button class="nav-link" id="tab2-tab" data-bs-toggle="tab" data-bs-target="#tab2" type="button" role="tab">청구기본정보</button>
              </li>
            </ul>

            <div class="tab-content" id="leftTabContent">
              <!-- Tab1: 청구대상자 -->
              <div class="tab-pane fade show active" id="tab1" role="tabpanel">
                <div class="card mb-0">
                  <div class="card-body" id="ch_inputZone" style="padding-top: 0.25rem; padding-bottom: 0.20rem;">
                    <div class="form-group row mb-0">
                      <label for="Month" class="col-1 col-sm-1 col-form-label text-left">청구년월</label>
                      <div class="col-2 col-lg-2 d-flex">
                        <select id="selYear" name="selYear" class="custom-select mr-1" style="height: 35px; font-size: 16px;" onchange="fn_setMonth()"></select>
                        <select id="selMonth" name="selMonth" class="custom-select" style="height: 35px; font-size: 16px; width: 80px;" onchange="fn_setMonth()"></select>
                        <input id="Month" name="Month" type="hidden" value="" required>
                      </div>
                      <label for="cformNo" class="col-1 col-sm-1 col-form-label text-left">서식구분</label>
                      <div class="col-2 col-lg-2">
                        <select id="cformNo" name="cformNo" class="custom-select" style="height: 35px; font-size: 16px;">
                          <option selected value="">선택</option>
                        </select>
                      </div>
                      <div class="input-group-append">
                        <button type="button" class="btn btn-rounded btn-primary" onClick="fn_re_load()">조회 <i class="fas fa-search"></i></button>
                      </div>
                    </div>
                  </div>
                </div>
                <!--  청구서내역정보  -->
                <div class="card">
                  <div class="card-body">
                    <table id="ch_tableName" class="display nowrap stripe hover cell-border order-column responsive" style="width: 100%;"></table>
                  </div>
                </div>
              </div>

              <!-- Tab2: 청구기본정보 -->
              <div class="tab-pane fade" id="tab2" role="tabpanel">
                <div class="row">
                  <!-- 🔵 새 좌측 영역 (약 2/12) -->
                  <div class="col-md-3">
	                   <div class="card-body" style="padding: 2px 10px;">
	                    <table id="my_tableName" class="display nowrap stripe hover cell-border order-column responsive" style="width: 100%;"></table>
	                  </div>
                  </div>

                  <!-- 진단명/행위료 합계 -->
                  <div class="col-md-4">
                    <div class="card mt-0">
                      <div class="card-body" style="padding: 2px 4px;">
                        <table 
                             id="dise_tableName" class="display nowrap stripe hover cell-border order-column responsive" style="width: 100%;">
                        </table>
                      </div>
                    </div>
                    <div class="card mt-0">
                      <div class="card-body" style="padding: 2px 4px;">
                        <table id="hang_tableName" class="display nowrap stripe hover cell-border order-column responsive" style="width: 100%;">
                          <tfoot>
						    <tr>
						      <th colspan="4" class="text-right">합계</th>
						      <th class="text-right"></th> <!-- 재료금액 -->
						      <th class="text-right"></th> <!-- 행위금액 -->
						      <th class="text-right"></th> <!-- 가산급액 -->
						    </tr>
						  </tfoot>
                        </table>
                      </div>
                    </div>

                    <div class="card mt-0">
                      <div class="card-body" style="padding: 2px 4px;">
                        <table id="spc_tableName" class="display nowrap stripe hover cell-border order-column responsive" style="width: 100%;">
                        </table>
                      </div>
                    </div>
                  </div>

                  <!-- 진료내역  -->
                  <div class="col-md-5">
                    <div class="card mt-0">
                      <div class="card-body" style="padding: 2px 4px;">
                        <table id="jin_tableName" class="display nowrap stripe hover cell-border order-column responsive" style="width: 100%;"></table>
                      </div>
                    </div>
                  </div>
                </div> <!-- row -->
              </div> <!-- tab2 끝 -->
            </div> <!-- tab-content 끝 -->
          </div> <!-- card-body -->
        </div> <!-- card -->
      </div> <!-- col-12 -->
    </div> <!-- row -->
  </div> <!-- container-fluid -->
</div> <!-- dashboard-wrapper -->




<!-- ============================================================== -->
<!-- 기본 초기화 Start -->
<!-- ============================================================== -->
<script type="text/javascript">
         // 안해도 상관없음, 단 getElementById를 변경하면 꼭해야됨
		// Form마다 수정해야 될 부분 시작
		var ch_tableName = document.getElementById('ch_tableName');
		ch_tableName.style.display = 'none';		
		// Form마다 수정해야 될 부분 종료
		
		// Form마다 조회 조건 변경 시작
		var findTxtln  = 0;    // 조회조건시 글자수 제한 / 0이면 제한 없음
		var firstflag  = false; // 첫음부터 Find하시려면 false를 주면됨
		var findValues = [];
		// 조회조건이 있으면 설정하면됨 / 조건 없으면 막으면 됨
		// 글자수조건 있는건 1개만 설정가능 chk: true 아니면 모두 flase
		// 조회조건은 필요한 만큼 추가사용 하면됨.
		findValues.push({ id: "dataYm", val: (function(){ var d=new Date(); return d.getFullYear()+'-'+('0'+(d.getMonth()+1)).slice(-2); })(),  chk: true  });
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
		var list_code = ['CFORM_NO'];     // 구분코드 필요한 만큼 선언해서 사용
		var select_id = ['cformNo'];     // 구분코드 데이터 담길 Select (ComboBox ID) 
		var firstnull = ['Y'];                              // Y 첫번째 Null,이후 Data 담김 / N 바로 Data 담김 
		<!-- ============================================================== -->
		<!-- 공통코드 Setting End -->
		<!-- ============================================================== -->
		var format_convert = ['Month'] ; //날자에서 '-' '/' 제외설정

		// 년월 콤보박스 초기화
		(function() {
			var now = new Date();
			var curYear = now.getFullYear();
			var curMonth = now.getMonth() + 1;
			var selYear = document.getElementById('selYear');
			var selMonth = document.getElementById('selMonth');
			// 년도: 현재년도 기준 -5 ~ +1
			for (var y = curYear - 5; y <= curYear + 1; y++) {
				var opt = document.createElement('option');
				opt.value = y;
				opt.text = y + '년';
				if (y === curYear) opt.selected = true;
				selYear.appendChild(opt);
			}
			// 월: 01 ~ 12
			for (var m = 1; m <= 12; m++) {
				var opt = document.createElement('option');
				opt.value = ('0' + m).slice(-2);
				opt.text = ('0' + m).slice(-2) + '월';
				if (m === curMonth) opt.selected = true;
				selMonth.appendChild(opt);
			}
			fn_setMonth();
		})();
		function fn_setMonth() {
			var y = document.getElementById('selYear').value;
			var m = document.getElementById('selMonth').value;
			document.getElementById('Month').value = y + '-' + m;
			// findValues 동기화
			if (typeof findValues !== 'undefined') {
				var idx = findValues.findIndex(function(item) { return item.id === 'dataYm'; });
				if (idx !== -1) findValues[idx].val = y + '-' + m;
			}
		}

		<!-- ============================================================== -->
		<!-- Table Setting Start -->
		<!-- ============================================================== -->
		var gridColums = [];
		var btm_Scroll = true;   		// 하단 scroll여부 - scrollX
		var auto_Width = true;   		// 열 너비 자동 계산 - autoWidth
		var page_Hight = 600;// 650;    		// Page 길이보다 Data가 많으면 자동 scroll - scrollY
		var p_Collapse = false;  		// Page 길이까지 auto size - scrollCollapse
		
		var datWaiting = true;   		// Data 가져오는 동안 대기상태 Waiting 표시 여부
		var page_Navig = false;   		// 페이지 네비게이션 표시여부 
		var hd_Sorting = true;   		// Head 정렬(asc,desc) 표시여부
		var info_Count = true;   		// 총건수 대비 현재 건수 보기 표시여부 
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
		
		var colPadding = '0.2px'   		// 행 높이 간격 설정
		var data_Count = [];  // Data 보기 설정
		var defaultCnt = 0;                      // Data Default 갯수
		
		
		//  DataTable Columns 정의, c_Head_Set, columnsSet갯수는 항상 같아야함.
		var c_Head_Set = ['요양기관','청구번호','서식버젼', '타병원', '서식명칭','진료형태','종별구분','청구건수','총진료비','청구액','본인액'];
		
		var columnsSet = [  // data 컬럼 id는 반드시 DTO의 컬럼,Modal id는 일치해야 함 (조회시)
	        				// name 컬럼 id는 반드시 DTO의 컬럼 일치해야 함 (수정,삭제시), primaryKey로 수정, 삭제함.
	        				// dt-body-center, dt-body-left, dt-body-right	        				
	        				{ data: 'hospCd',        visible: true,  className: 'dt-body-center'  , width: '100px',  },
	        				{ data: 'claimNo',       visible: true,  className: 'dt-body-center'  , width: '100px',  },
	        				{ data: 'clformVer',     visible: true,  className: 'dt-body-center'  , width: '60px',   },
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
	        				            if (data === 'N') {
	        				                return '<span style="font-weight:bold;">-</span>';
	        				            }
	        				        }
	        				        return data;
	        				    }
	        				},
	        				{ data: 'cformName',     visible: true,  className: 'dt-body-left'    , width: '300px',  },
	        				{ data: 'treatName',     visible: true,  className: 'dt-body-left'    , width: '100px',  },
	        				{ data: 'insurType',     visible: true,  className: 'dt-body-center'  , width: '100px',  },	   
	        				{ data: 'caseCnt',       visible: true,  className: 'dt-body-right'   , width: '100px',  },	
	        				{ data: 'totAmt',        visible: true,  className: 'dt-body-right'   , width: '100px',  },	
	        				{ data: 'claimAmt',      visible: true,  className: 'dt-body-right'   , width: '100px',  },		        				
	        				{ data: 'selfAmt',       visible: true,  className: 'dt-body-right'   , width: '100px',  }	
	        			];
		
		var s_CheckBox = true;   		           	 // CheckBox 표시 여부
        var s_AutoNums = true;   		             // 자동순번 표시 여부
        
		// 초기 data Sort,  없으면 []
		var muiltSorts = [
							['dateYm', 'asc' ]
        				 ];
        // Sort여부 표시를 일부만 할 때 개별 id, ** 전체 적용은 '_all'하면 됩니다. ** 전체 적용 안함은 []        				 
		var showSortNo = ['dateYm','claimNo'];                   
		// Columns 숨김 columnsSet -> visible로 대체함 hideColums 보다 먼제 처리됨 ( visible를 선언하지 않으면 hideColums컬럼 적용됨 )	
		var hideColums = ['dateYm','hospCd'];                             // 없으면 []; 일부 컬럼 숨길때		
		var txt_Markln = 20;                       				 // 컬럼의 글자수가 설정값보다 크면, 다음은 ...로 표시함
		// 글자수 제한표시를 일부만 할 때 개별 id, ** 전체 적용은 '_all'하면 됩니다. ** 전체 적용 안함은 []
		var markColums = ['cformName','treatName','korName_four'];
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
		//승인일종료일기준으로 사요일자 산정 시작일 종료일 입력할때 자동처리 (input 은 똑같이 작동)
		$(document).ready(function () {
		    $("#startDt_one, #endDt_one").inputmask("9999-99-99", { placeholder: "YYYY-MM-DD" });

		    $("#startDt_one").on("change", function () {
		        $("#acceptDt_one").val($(this).val());
		    });

		    $("#endDt_one").on("change", function () {
		        $("#closeDt_one").val($(this).val());
		    });
		});
		</script>
<!-- ============================================================== -->
<!-- 화면 Size변경 End -->
<!-- ============================================================== -->
<!-- ============================================================== -->
<!-- DataTable 설정 Start -->
<!-- ============================================================== -->
<script type="text/javascript">
		function fn_FirstGridSet() {
			(function($) {
				 dataTable = $('#' + ch_tableName.id).DataTable({	
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
		    let find = {};
		   	
		   	for (let findValue of findValues) {
		   		let key = findValue.id === "fee_type1" ? "fee_type" : findValue.id;
		   		find[key] = findValue.val;
		   	}
		   	
		   	const Month    = replaceMulti(document.getElementById('Month').value,'-');
		   	const cformNo  = document.getElementById('cformNo').value ;
		   	if (!Month) {
			    alert("청구년월를 선택해주세요.");
			    return;
			 }
		   	const s_hospid = getCookie("s_hospid");
		    $.ajax({
		        type: "POST",
		        url: "/chung/chungList.do",
		        data: { hospCd: s_hospid, dateYm: Month , cformNo : cformNo},
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
			hctmpedit_Data = null;
			hutmpedit_Data = null;
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
				ch_tableName.style.display = 'inline-block';
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
					    	ch_tableName.style.display = 'inline-block';
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
					ch_tableName.style.display = 'inline-block';
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
       	    const existingThead = ch_tableName.querySelector('thead');
       	    if (existingThead) {
       	    	ch_tableName.removeChild(existingThead);
       	    }
       	    ch_tableName.insertBefore(thead, ch_tableName.firstChild);
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
		$(document).ready(function () {
	
		    initmyResultsTable(); //명세서  
		    initjinResultsTable(); //진료내역 		    
		    initdiseResultsTable(); //상졍
		    inithangResultsTable(); //행위내역
		    initspcResultsTable(); //특정내역
		});
         //상병내역   
		var dise_tableName  = document.getElementById('dise_tableName');
		var dise_dataTable  = new DataTable();
		dise_dataTable.clear();
		var txt_Markln_dise  = 16;                       				
		function initdiseResultsTable() {
		  if (!$.fn.DataTable.isDataTable('#' + dise_tableName.id)) {
		   	dise_dataTable =  $('#' + dise_tableName.id).DataTable({  // 올바르게 닫힌 선택자
		            responsive:    false,
		            autoWidth:     false,
		            ordering:      false,
		            searching:     false, // 검색 기능 제거
		            lengthChange:  true, // 페이지당 개수 변경 옵션 제거
		            info:          true,
		            paging:        false, // 페이징 제거
		            scrollY:      "160px", // 세로 스크롤 추가
		            fixedHeader: true, // 헤더 고정
	    			search: {
	    	            return:  false,          	            
	    	        },	
				    rowCallback: function(row, data, index) {
			            $(row).find('td').css('padding',colPadding); 
			        },	
		            language: {
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
		            columns: [
			            	{ title: "진단코드",   data: "diagCode_two",     width: '50px', className: "text-center"},
			            	{ title: "진단명",    data: "diagName_two",     width: '300px', className: "text-left" , 
			                  	render: function(data, type, row) {
		                        return type === 'display' && data && data.length > txt_Markln_dise
		                            ? data.substr(0, txt_Markln_dise) + '...'
		                            : data;
			                  	}    
		                    },
			            	{ title: "주진단",    data: "diagType_two",      width: '20px' , className: "text-center"},  
			            	{ title: "진료과",    data: "medField_two",      width: '20px',  className: "text-center"},  
			            	{ title: "면허번호",   data: "licenseNo_two",     width: '50px', className: "text-center"} ,
			            	{ title: "진료개시일",  data: "medStartDate_two", width: '80px',  className: "text-center", 
				              	render: function(data, type, row) {
		            				if (type === 'display') {
		            					return getFormat(data,'d1')
		                			}
		                			return data;
		        				}
		    				}
	    				],
	    			     columnDefs: [
	    			         {
	    			           targets: '_all',
	    			           className: 'align-middle'
	    			         }
	    			       ],
	    			       ajax: diseLoad,
	    		  });
		   	//row 모든데이타 자동 가져오기(모달창에서 데이타 조건없이뿌려짐)  
		   	    $('#' + dise_tableName.id + ' tbody').on('click', 'tr', function() {
		        	  huedit_Data = dise_dataTable.row(this).data(); // 선택한 행 데이터 저장
		        });  
			    /* 싱글 선택 start */
			    if (row_Select) {
			    	dise_dataTable.on('click', 'tbody tr', (e) => {
				  	    let classList = e.currentTarget.classList;
				  	 
				  	    if (!classList.contains('selected')) {
				  	    	dise_dataTable.rows('.selected').nodes().each((row) => row.classList.remove('selected'));
				  	        classList.add('selected');
				  	    } 
				  	});    
			    }	
	
		    }
		}
		function diseLoad(data, callback, settings) {
			$('#' + my_tableName.id).on("click", "tr", function () {
				huedit_Data = null ;
			    var selectedRowData = $('#' + my_tableName.id).DataTable().row(this).data(); // 선택한 행 데이터 가져오기
			    if (!selectedRowData) return;
			    var hospcd     = selectedRowData.hospCd_one; // 선택한 병원 코드(hospUuid)
			    var dateym     = selectedRowData.dateYm_one; // 선택한 병원 코드(hospUuid)
			    var claimno    = selectedRowData.claimNo_one; // 선택한 병원 코드(hospUuid)
			    var billseq    = selectedRowData.billSeq_one; // 선택한 병원 코드(hospUuid)
		        $("#patName_one").val(selectedRowData.patName_one) ;
			    if (hospcd) {
			        // AJAX 요청하여 hospUuid에 해당하는 데이터 가져오기
			        $.ajax({
			            url: "/chung/diseList.do", // 실제 서버 엔드포인트 입력
			            type: "POST",
			            data: { hospCd: hospcd , dateYm :dateym , claimNo :claimno , billSeq :billseq }, 
			            dataType: "json",
				        beforeSend : function () {
				        	var table = $('#'+ dise_tableName.id).DataTable();
		                    table.clear().draw(); // 기존 데이터 초기화				        	
						},
				        success: function(response) {
				            if (response && Object.keys(response).length > 0) {
				            	let receiveList = receiveDTO(response,"_two") || [];
					    	    // DataTable 적용 시 데이터 확인 후 처리 받은 DTO KEY 뱐환작업(중복ID 배제)   
					    	    if (Array.isArray(receiveList) && receiveList.length > 0) {
					    	    	$('#' + dise_tableName.id).DataTable().clear().rows.add(receiveList).draw();
					    	    } else {
					    	        $('#' + dise_tableName.id).DataTable().clear().draw();
					    	    }
					    	    callback(receiveList);
				            } else {
				            	callback([]); // 빈 배열을 콜백으로 전달
				            }
				        },
				        error: function(jqXHR, textStatus, errorThrown) {
				            callback({
				                data: []
				            });
				            // table.clear().draw(); // 테이블 초기화 및 다시 그리기
				        }
			        });
			        const tabElement = document.querySelector('#tab2-tab');
			        if (tabElement) {
			          const tab = new bootstrap.Tab(tabElement);
			          tab.show();
			        } else {
			          console.error('tab2-tab not found!');
			        }
			    }
			});
		}
        //진료내역    
		var jin_tableName  = document.getElementById('jin_tableName');
		var jin_dataTable  = new DataTable();
		jin_dataTable.clear();
		var txt_Markln_jin  = 16;
		function initjinResultsTable() {
		  if (!$.fn.DataTable.isDataTable('#' + jin_tableName.id)) {
		  jin_dataTable =  $('#' + jin_tableName.id).DataTable({  // 올바르게 닫힌 선택자
		            responsive:    false,
		            scrollX:       true,
		            autoWidth:     false,
		            ordering:      false,
		            searching:     false, // 검색 기능 제거
		            lengthChange:  true, // 페이지당 개수 변경 옵션 제거
		            info:          true,
		            paging:        false, // 페이징 제거
		            scrollY:      "650px", // 세로 스크롤 추가
		            fixedHeader: true, // 헤더 고정
	    			search: {
	    	            return:  false,          	            
	    	        },	
				    rowCallback: function(row, data, index) {
			            $(row).find('td').css('padding',colPadding); 
			        },	
		            language: {
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
		            columns: [
		            	{ title: "항",       data: "itemNo_four",      width: '30px' ,  className: "text-center"},
		            	{ title: "목",       data: "codeNo_four",      width: '30px' ,  className: "text-center" },
		            	{ title: "항명칭",    data: "subCodeNm_four",   visible: false,  className: "text-center" },
		            	{ title: "청구코드",   data: "ediCode_four",     width: '60px' ,  className: "text-left"},  
		                {
		                    title: "수가명칭", data: "korName_four", width: '100px', className: "text-left",
		                    render: function(data, type, row) {
		                        return type === 'display' && data && data.length > txt_Markln_jin
		                            ? data.substr(0, txt_Markln_jin) + '...'
		                            : data;
		                    }
		                },
		            	{ title: "구분",      data: "codeType_four",    width: '20px',   className: "text-center"} ,
		            	{ title: "단가",      data: "unitPrice_four",   width: '80px',   className: "text-right"} ,
		            	{ title: "횟수",      data: "dailyDose_four",   width: '30px',   className: "text-right"} ,
		            	{ title: "1회투약",    data: "onceDose_four",    width: '50px',   className: "text-right"} ,
		            	{ title: "일수",      data: "totalDose_four",   width: '50px',   className: "text-right"} , 
		            	{ title: "금액",      data: "amount_four",      width: '80px',   className: "text-right"}
		            ],
		            drawCallback: function(settings) {
		                var api = this.api();
		                var rows = api.rows({ page: 'current' }).nodes();
		                var lastItemNo = null;

		                api.column(0, { page: 'current' }).data().each(function(itemNo, i) {
		                    var rowData = api.row(i).data(); // 현재 행의 전체 데이터

		                    if (lastItemNo !== itemNo) {
		                        $(rows).eq(i).before(
		                            '<tr class="group-header">' +
		                            '<td colspan="11" style="background:#d0e7ff;font-weight:bold;text-align:left;padding:2px 8px;height:24px;">' +
		                            '[ 항: ' + itemNo + ' ] ' +
		                            (rowData.subCodeNm_four ? '[   ' + rowData.subCodeNm_four + ' ]' : '') +
		                            '</td>' +
		                            '</tr>'
		                        );
		                        lastItemNo = itemNo;
		                    }
		                });
		            },
		            columnDefs: [
		                {
		                    targets: '_all',
		                    className: 'align-middle'
		                }
		            ],
		            ajax: jinLoad ,
				});
			    if (row_Select) {
			    	jin_dataTable.on('click', 'tbody tr', (e) => {
				  	    let classList = e.currentTarget.classList;
				  	 
				  	    if (!classList.contains('selected')) {
				  	    	jin_dataTable.rows('.selected').nodes().each((row) => row.classList.remove('selected'));
				  	        classList.add('selected');
				  	    } 
				  	});    
			    }	
	
		    }
		}
		function jinLoad(data, callback, settings) {
			$('#' + my_tableName.id).on("click", "tr", function () {
			    var selectedRowData = $('#' + my_tableName.id).DataTable().row(this).data(); // 선택한 행 데이터 가져오기
			    if (!selectedRowData) return;
			    var hospcd     = selectedRowData.hospCd_one; // 선택한 병원 코드(hospUuid)
			    var dateym     = selectedRowData.dateYm_one; // 선택한 병원 코드(hospUuid)
			    var claimno    = selectedRowData.claimNo_one; // 선택한 병원 코드(hospUuid)
			    var billseq    = selectedRowData.billSeq_one; // 선택한 병원 코드(hospUuid)
			    if (hospcd) {
			        $.ajax({
			            url: "/chung/jinordList.do", // 실제 서버 엔드포인트 입력
			            type: "POST",
			            data: { hospCd: hospcd , dateYm :dateym , claimNo :claimno , billSeq :billseq }, 
			            dataType: "json",
				        beforeSend : function () {
				        	var table = $('#'+ jin_tableName.id).DataTable();
		                    table.clear().draw(); // 기존 데이터 초기화				        	
						},
				        success: function(response) {
				            if (response && Object.keys(response).length > 0) {
				            	let receiveList = receiveDTO(response,"_four") || [];
					    	    // DataTable 적용 시 데이터 확인 후 처리 받은 DTO KEY 뱐환작업(중복ID 배제)   
					    	    if (Array.isArray(receiveList) && receiveList.length > 0) {
					    	    	$('#' + jin_tableName.id).DataTable().clear().rows.add(receiveList).draw();
					    	    } else {
					    	        $('#' + jin_tableName.id).DataTable().clear().draw();
					    	    }
					    	    callback(receiveList);
				            } else {
				            	callback([]); // 빈 배열을 콜백으로 전달
				            }
				        },
				        error: function(jqXHR, textStatus, errorThrown) {
				            callback({
				                data: []
				            });
				            // table.clear().draw(); // 테이블 초기화 및 다시 그리기
				        }
			        });
			    }
			});
		}
        //진료내역    
		var hang_tableName  = document.getElementById('hang_tableName');
		var hang_dataTable  = new DataTable();
		hang_dataTable.clear();
		var txt_Markln_hang = 15 ;
	
		function inithangResultsTable() {
		  if (!$.fn.DataTable.isDataTable('#' + hang_tableName.id)) {
		  hang_dataTable =  $('#' + hang_tableName.id).DataTable({  // 올바르게 닫힌 선택자
		            responsive:    false,
		            autoWidth:     false ,
		            ordering:      false,
		            searching:     false, // 검색 기능 제거
		            lengthChange:  true, // 페이지당 개수 변경 옵션 제거
		            info:          true,
		            paging:        false, // 페이징 제거
		            scrollY:      "215px", // 세로 스크롤 추가
		            fixedHeader: true, // 헤더 고정
		            rowHeight  : 1000,
	    			search: {
	    	            return:  false,          	            
	    	        },	
				    rowCallback: function(row, data, index) {
			            $(row).find('td').css('padding',colPadding); 
			        },	
		            language: {
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
		            columns: [
		            	{ title: "항",       data: "itemNo_five",       width: '30px' ,    className: "text-center"},
		            	{ title: "목",       data: "codeNo_five",       width: '40px' ,    className: "text-center" },
		            	{ title: "명칭",      data: "codeName_five",     width: '100px' ,   className: "text-left" ,  
		                 	render: function(data, type, row) {
	                        return type === 'display' && data && data.length > txt_Markln_hang
	                            ? data.substr(0, txt_Markln_hang) + '...'
	                            : data;
		                 	}
		            	},
		            	{ title: "가산율",     data: "gasanRate_five",    width: '20px',     className: "text-center"} , 
		            	{ title: "재료금액",    data: "jeaAmt_five",       width: '20px',     className: "text-right"} ,
		            	{ title: "행위금액",    data:  "hwiAmt_five",      width: '60px',     className: "text-right"} ,
		            	{ title: "가산급액",    data: "gasanAmt_five",     width: '60px',     className: "text-right"} 
		            ],
		            ajax: hangLoad ,
		         // ✅ 합계 기능 추가
		            footerCallback: function(row, data, start, end, display) {
		                let api = this.api();

		                const intVal = function(i) {
		                    return typeof i === 'string'
		                        ? parseFloat(i.replace(/[\$,]/g, '').replace(/,/g, '')) || 0
		                        : typeof i === 'number'
		                            ? i
		                            : 0;
		                };

		                const colIndexes = {
		                    jeaAmt: 4,
		                    hwiAmt: 5,
		                    gasanAmt: 6
		                };

		                let jeaTotal = api.column(colIndexes.jeaAmt).data().reduce((a, b) => intVal(a) + intVal(b), 0);
		                let hwiTotal = api.column(colIndexes.hwiAmt).data().reduce((a, b) => intVal(a) + intVal(b), 0);
		                let gasanTotal = api.column(colIndexes.gasanAmt).data().reduce((a, b) => intVal(a) + intVal(b), 0);

		                $(api.column(colIndexes.jeaAmt).footer()).html(jeaTotal.toLocaleString());
		                $(api.column(colIndexes.hwiAmt).footer()).html(hwiTotal.toLocaleString());
		                $(api.column(colIndexes.gasanAmt).footer()).html(gasanTotal.toLocaleString());
		            }		            
				});
			    if (row_Select) {
			    	hang_dataTable.on('click', 'tbody tr', (e) => {
				  	    let classList = e.currentTarget.classList;
				  	 
				  	    if (!classList.contains('selected')) {
				  	    	hang_dataTable.rows('.selected').nodes().each((row) => row.classList.remove('selected'));
				  	        classList.add('selected');
				  	    } 
				  	});    
			    }	
	
		    }
		}
		function hangLoad(data, callback, settings) {
			$('#' + my_tableName.id).on("click", "tr", function () {
			    var selectedRowData = $('#' + my_tableName.id).DataTable().row(this).data(); // 선택한 행 데이터 가져오기
			    if (!selectedRowData) return;
			    var hospcd     = selectedRowData.hospCd_one; // 
			    var dateym     = selectedRowData.dateYm_one; // 
			    var claimno    = selectedRowData.claimNo_one; // 
			    var billseq    = selectedRowData.billSeq_one; // 
			    if (hospcd) {
			        $.ajax({
			            url: "/chung/hangList.do", // 실제 서버 엔드포인트 입력
			            type: "POST",
			            data: { hospCd: hospcd , dateYm :dateym , claimNo :claimno , billSeq :billseq }, 
			            dataType: "json",
				        beforeSend : function () {
				        	var table = $('#'+ hang_tableName.id).DataTable();
		                    table.clear().draw(); // 기존 데이터 초기화				        	
						},
				        success: function(response) {
				            if (response && Object.keys(response).length > 0) {
				            	let receiveList = receiveDTO(response,"_five") || [];
					    	    // DataTable 적용 시 데이터 확인 후 처리 받은 DTO KEY 뱐환작업(중복ID 배제)   
					    	    if (Array.isArray(receiveList) && receiveList.length > 0) {
					    	    	$('#' + hang_tableName.id).DataTable().clear().rows.add(receiveList).draw();
					    	    } else {
					    	        $('#' + hang_tableName.id).DataTable().clear().draw();
					    	    }
					    	    callback(receiveList);
				            } else {
				            	callback([]); // 빈 배열을 콜백으로 전달
				            }
				        },
				        error: function(jqXHR, textStatus, errorThrown) {
				            callback({
				                data: []
				            });
				            // table.clear().draw(); // 테이블 초기화 및 다시 그리기
				        }
			        });
			    }
			});
		}
        //명세서내역  
		var my_tableName  = document.getElementById('my_tableName');
		var my_dataTable  = new DataTable();
		my_dataTable.clear();
		//	
		function initmyResultsTable() {
		  if (!$.fn.DataTable.isDataTable('#' + my_tableName.id)) {
			  my_dataTable =  $('#' + my_tableName.id).DataTable({  // 올바르게 닫힌 선택자
		            responsive:    false,
		            autoWidth:     false,
		            ordering:      false,
		            searching:     true, // 검색 기능 제거
		            lengthChange:  true, // 페이지당 개수 변경 옵션 제거
		            info:          true,
		            paging:        false, // 페이징 제거
		            scrollY     : "650px", // 세로 스크롤 추가
		            fixedHeader: true, // 헤더 고정
	    			search: {
	    	            return:  false,          	            
	    	        },	
				    rowCallback: function(row, data, index) {
			            $(row).find('td').css('padding',colPadding); 
			        },	
		            language: {
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
		            columns: [
		            	{ title: "명일련",      data:  "billSeq_one"   ,     width: '20px' ,   className: "text-center" }, 
		            	{ title: "청구번호" ,    data:  "claimNo_one"   ,     visible: false ,  },
		            	{ title: "요양기관" ,    data:  "hospCd_one"    ,     visible: false ,  },
		            	{ title: "청구년월" ,    data:  "dateYm_one"    ,     visible: false ,  },
		            	{ title: "성 명",       data:  "patName_one"   ,     width: '40px' ,    className: "text-center" } ,
		            	{ title: "행위구분"  ,   data:  "payType_one"   ,     width: '50px' ,    className: "text-center" , 
		            	    render: function(data, type, row) {
		            		    if (data === "2.행위") {
		            		      return '<span style="color: red;">' + data + '</span>';
		            		    }
		            		    return data;
		            		  }
		            	},
		            	{ title: "생년월일"  ,   data:  "patId_one"     ,     width: '50px' ,    className: "text-center" ,
		            		render: function(data, type, row) {
		            	        if (!data || data.length < 7) return "";
		            	        var birth = data.substring(0, 6);
		            	        var gender = data.charAt(6);
		            	        return birth + "-" + gender; // 템플릿 리터럴 없이 처리
		            	    }
		            	},
		            	{ title: "정보",     data:  "spcodeNm_one"   ,    width: '100px' ,    className: "text-center" ,  
		                 	render: function(data, type, row) {
		                        return type === 'display' && data && data.length > 3
		                            ? data.substr(0, 3) + '...'
		                            : data;
			                 	}
			            },
		            	{ title: "입원일자",      data:  "firstAdmt_one" ,     width: '50px' ,   className: "text-center" },
		            	{ title: "총진료비",      data:  "medAmt_one"    ,     width: '50px' ,   className: "text-right"},
		            	{ title: "청구액",       data:  "claimAmt_one"  ,     width: '50px' ,   className: "text-center"},
		            	{ title: "본인액",       data:  "selfAmt_one"   ,     width: '50px' ,   className: "text-center"},
		            	{ title: "공상구분",      data:  "accType_one"   ,     width: '50px' ,   className: "text-center"}	
		            ],
		            ajax: myoungLoad,   
				});                                 
			    /* 싱글 선택 start */
			    if (row_Select) {
			    	my_dataTable.on('click', 'tbody tr', (e) => {
				  	    let classList = e.currentTarget.classList;
				  	 
				  	    if (!classList.contains('selected')) {
				  	    	my_dataTable.rows('.selected').nodes().each((row) => row.classList.remove('selected'));
				  	        classList.add('selected');
				  	    } 
				  	});    
			    }	
		    }
		}
		function myoungLoad(data, callback, settings) {
			$('#' + ch_tableName.id).on("dblclick", "tr", function () {
			    var selectedRowData = $('#' + ch_tableName.id).DataTable().row(this).data(); // 선택한 행 데이터 가져오기
			    if (!selectedRowData) return;
			    var dateym     = selectedRowData.dateYm; // 청구년월
			    var hospcd     = selectedRowData.hospCd; // 병원정보 
			    var claimno    = selectedRowData.claimNo; //청구번호 
			    if (hospcd) {
			        $.ajax({
			            url: "/chung/myoungList.do", // 실제 서버 엔드포인트 입력
			            type: "POST",
			            data: { hospCd: hospcd , dateYm :dateym ,claimNo :claimno }, 
			            dataType: "json",
				        beforeSend : function () {
				        	var table = $('#'+ my_tableName.id).DataTable();
		                    table.clear().draw(); // 기존 데이터 초기화				        	
						},
						success: function(response) {
				            if (response && Object.keys(response).length > 0) {
				            	let receiveList = receiveDTO(response,"_one") || [];
					    	    // DataTable 적용 시 데이터 확인 후 처리 받은 DTO KEY 뱐환작업(중복ID 배제)   
					    	    if (Array.isArray(receiveList) && receiveList.length > 0) {
					    	    	$('#' + my_tableName.id).DataTable().clear().rows.add(receiveList).draw();
					    	    } else {
					    	        $('#' + my_tableName.id).DataTable().clear().draw();
					    	    }
					    	    callback(receiveList);
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
			        const tabElement = document.querySelector('#tab2-tab');
			        if (tabElement) {
			          const tab = new bootstrap.Tab(tabElement);
			          
			          $('#' + hang_tableName.id).DataTable().clear().draw();
			          $('#' + jin_tableName.id).DataTable().clear().draw();
			          $('#' + dise_tableName.id).DataTable().clear().draw();
			          $('#' + spc_tableName.id).DataTable().clear().draw();
			          
			          tab.show();
			        } else {
			          console.error('tab2-tab not found!');
			        }
			    }
			});
		}
	       //특정내역
		var spc_tableName  = document.getElementById('spc_tableName');
		var spc_dataTable  = new DataTable();
		sp_dataTable.clear();
		//	
		function initspcResultsTable() {
		  if (!$.fn.DataTable.isDataTable('#' + spc_tableName.id)) {
			  spc_dataTable =  $('#' + spc_tableName.id).DataTable({  // 올바르게 닫힌 선택자
		            responsive:    false,
		            autoWidth:     false,
		            ordering:      false,
		            searching:     false, // 검색 기능 제거
		            lengthChange:  false, // 페이지당 개수 변경 옵션 제거
		            info:          false,
		            paging:        false, // 페이징 제거
		            scrollY     : "50px", // 세로 스크롤 추가
		            fixedHeader: true, // 헤더 고정
	    			search: {
	    	            return:  false,          	            
	    	        },	
				    rowCallback: function(row, data, index) {
			            $(row).find('td').css('padding',colPadding); 
			        },	
		            language: {
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
		            columns: [
		            	{data:  "rowNo_seven"       ,  width: '20px' ,   className: "text-center" },
		            	{data:  "unitType_seven"    ,  width: '20px' ,   className: "text-center" }, 
		            	{data:  "specType_seven"    ,  width: '20px' ,  },
		            	{data:  "specDetail_seven"  ,  width: '300px',  
		                 	render: function(data, type, row) {
	                        return type === 'display' && data && data.length > txt_Markln
	                            ? data.substr(0, txt_Markln) + '...'
	                            : data;
		                 	}
		            	}
      		            	
		            ],
		            headerCallback: function(thead, data, start, end, display) {
		                $(thead).remove(); // 헤더를 동적으로 제거
		            },
		            ajax: spcLoad,   
				});                                 
			    /* 싱글 선택 start */
			    if (row_Select) {
			    	spc_dataTable.on('click', 'tbody tr', (e) => {
				  	    let classList = e.currentTarget.classList;
				  	 
				  	    if (!classList.contains('selected')) {
				  	    	spc_dataTable.rows('.selected').nodes().each((row) => row.classList.remove('selected'));
				  	        classList.add('selected');
				  	    } 
				  	});    
			    }	
		    }
		}
		function spcLoad(data, callback, settings) {
			$('#' + my_tableName.id).on("click", "tr", function () {
			    var selectedRowData = $('#' + my_tableName.id).DataTable().row(this).data(); // 선택한 행 데이터 가져오기
			    if (!selectedRowData) return;
			    var hospcd     = selectedRowData.hospCd_one; // 
			    var dateym     = selectedRowData.dateYm_one; // 
			    var claimno    = selectedRowData.claimNo_one; // 
			    var billseq    = selectedRowData.billSeq_one; // 
			    if (hospcd) {
			        $.ajax({
			            url: "/chung/spcList.do", // 실제 서버 엔드포인트 입력
			            type: "POST",
			            data: { hospCd: hospcd , dateYm :dateym ,claimNo :claimno, billSeq :billseq }, 
			            dataType: "json",
				        beforeSend : function () {
				        	var table = $('#'+ spc_tableName.id).DataTable();
		                    table.clear().draw(); // 기존 데이터 초기화				        	
						},
						success: function(response) {
				            if (response && Object.keys(response).length > 0) {
				            	let receiveList = receiveDTO(response,"_seven") || [];
					    	    // DataTable 적용 시 데이터 확인 후 처리 받은 DTO KEY 뱐환작업(중복ID 배제)   
					    	    if (Array.isArray(receiveList) && receiveList.length > 0) {
					    	    	$('#' + spc_tableName.id).DataTable().clear().rows.add(receiveList).draw();
					    	    } else {
					    	        $('#' + spc_tableName.id).DataTable().clear().draw();
					    	    }
					    	    callback(receiveList);
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
			    }
			});
		}
		function receiveDTO(response, suffix) {
		    if (!response || !response.data || !Array.isArray(response.data)) {
		        console.error("🚨 변환할 데이터가 올바르지 않습니다:", response);
		        return [];
		    }

		    console.log("📌 원본 데이터:", response);

		    return response.data.map(data => {
		        let transformedData = {};
		        Object.entries(data).forEach(([key, value]) => {
		            transformedData[key + suffix] = value; // ✅ ID 변경 (예: codeCd → codeCd_one or codeCd_two)
		        });
		        console.log(`📌 바뀐 데이터 (${suffix} 적용):`, transformedData);
		        return transformedData;
		    });
		}
	</script>
<!-- ============================================================== -->
<!-- 기타 정보 End -->
<!-- ============================================================== -->

