<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>  
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="decorator" uri="http://www.opensymphony.com/sitemesh/decorator" %>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/page" prefix="page" %>
<%@ page import ="java.util.Date" %>
<!-- Customized Bootstrap Stylesheet -->
<link href="/css/winmc/style_comm.css?v=123"  rel="stylesheet">
    <!-- DataTables CSS -->
    <style>
        .dataTables_scrollHead thead th { text-align: center !important; }
        .dataTables_scrollBody tbody td { font-weight: normal !important; }
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
	                            <div id="topControlBar" class="form-row" style="display:none;">
 		                            <div class="col-auto d-flex align-items-center">
 			                         <input id="hospCd1" name="hospCd1" type="text" readonly class="form-control form-control-sm is-invalid text-left" required placeholder="" style="width:80px;">
 			                         <label class="ml-1 mb-0" style="font-size:0.8rem; cursor:pointer; white-space:nowrap;"><input type="checkbox" id="chkHospCd1Init" onclick="fn_hospCd1Init(this)"> 전체</label>
			                        </div>
                                    <div class="col-auto">
                                      <select id="asqGb" class="form-control form-control-sm" oninput="findField(this)" style="width:80px;">
									    <option selected value="">선택</option>
									  </select>
									</div>
                                    <div class="col-auto">
                                         <div class="btn-group">
                                            <button class="btn btn-sm btn-outline-dark"        data-toggle="tooltip" data-placement="top" title=""            onClick="fn_re_load()">조회. <i class="fas fa-binoculars"></i></button>
                                            <button class="btn btn-sm btn-outline-dark d-none btn-insert" data-toggle="tooltip" data-placement="top" title="신규 Data 입력" onClick="modal_Open('I')">입력. <i class="far fa-edit"></i></button>
                                            <button class="btn btn-sm btn-outline-dark btn-update"        
                                                  data-toggle="tooltip" data-placement="top" title="선택 Data 수정" onClick="modal_Open('U')"><img src="/images/winct/qnst_q.svg" alt="" style="width:16px; height:16px; vertical-align:middle;"> 답변둥록.</button>
                                            <button class="btn btn-sm btn-outline-dark"        data-toggle="tooltip" data-placement="top" title="화면 Size 확대.축소" id="fullscreenToggle">화면확장축소. <i class="fas fa-expand" id="fullscreenIcon"></i></button>
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
		<style>
		#modalName .btn-outline-secondary,
		#modalName .btn-outline-secondary:hover,
		#modalName .btn-outline-secondary:focus,
		#modalName .btn-outline-secondary:active,
		#modalName .btn-outline-secondary:active:focus,
		#modalName .btn-outline-secondary.active {
		    color: #000 !important;
		    background-color: #fff !important;
		    border-color: #bbb !important;
		    outline: none !important;
		    box-shadow: none !important;
		}
		#modalName .form-control:invalid,
		#modalName .form-control:required:invalid,
		#modalName .form-control.is-invalid,
		#modalName .was-validated .form-control:invalid {
		    border-color: #ddd !important;
		    box-shadow: none !important;
		    background-image: none !important;
		}
		/* summernote-bs4 CSS와 summernote-lite CSS 중복 아이콘 방지 */
		#modalName .note-editor .note-icon-caret {
		    display: none !important;
		}
		#modalName .note-editor .note-btn .note-icon-caret {
		    display: none !important;
		}
		#modalName .note-editor .note-toolbar .dropdown-toggle::after {
		    display: inline-block !important;
		    content: '' !important;
		    border-top: .3em solid;
		    border-right: .3em solid transparent;
		    border-left: .3em solid transparent;
		    margin-left: .3em;
		    vertical-align: middle;
		}
		</style>
		<div class="modal fade" id="modalName" tabindex="-1" data-backdrop="static" data-keyboard="true" role="dialog" aria-hidden="true">
		    <div class="modal-dialog modal-dialog-scrollable modal-lg"
		         style="max-width: 820px; width: 90%; margin-top: 10px;">
		        <div class="modal-content"
		             style="max-height: calc(100vh - 10px); display: flex; flex-direction: column; border: none; border-radius: 12px; overflow: hidden; box-shadow: 0 8px 32px rgba(0,0,0,0.18);">

		            <!-- 타이틀 헤더 -->
		            <div style="background: #fff; padding: 10px 24px 6px 24px; flex-shrink: 0; border-bottom: 1px solid #eee; display: flex; justify-content: space-between; align-items: center;">
		                <h5 id="modalHead" style="margin: 0; font-weight: 700; font-size: 17px; color: #222;"></h5>
		                <div>
		                </div>
		            </div>

		            <!-- Modal Body -->
		            <div class="modal-body" style="overflow-y: auto; flex-grow: 1; min-height: 0; padding: 0 24px 20px 24px; background: #f9f9f9;">
		                <div id="inputZone">
		                    <!-- Hidden Inputs -->
		                    <input type="hidden" id="qstnStat2"  name="qstnStat" value="">
		                    <input type="hidden" id="ansrStat2"  name="ansrStat" value="">
		                    <input type="hidden" id="hospNm"    name="hospNm"   value="">
		                    <input type="hidden" id="userNm"    name="userNm"   value="">
		                    <input type="hidden" id="asqSeq2"    name="asqSeq"   value="">
		                    <input type="hidden" id="fileGb2"    name="fileGb"   value="">
		                    <input type="hidden" id="updDttm"   name="updDttm"  value="">
		                    <input type="hidden" id="updUser"   name="updUser"  value="">
		                    <input type="hidden" id="updIp"     name="updIp"    value="">

		                    <!-- 질문제목 섹션 -->
		                    <div style="margin-top: 6px;">
		                        <div style="background: #afd4ec; color: #000; padding: 8px 16px; border-radius: 8px 8px 0 0; font-weight: 600; font-size: 15px;">
		                            질문제목
		                        </div>
		                        <div style="background: #fff; border: 1px solid #d0d0d0; border-top: none; border-radius: 0 0 8px 8px; padding: 12px 14px;">
		                            <textarea id="qstnTitle2" name="qstnTitle" class="form-control" rows="1" readonly
		                                style="border: 1px solid #ddd; border-radius: 6px; font-size: 14px; font-weight: normal; resize: vertical; color: #000; background-color: #f9f9f9;"></textarea>
		                        </div>
		                    </div>

		                    <!-- 질문내용 섹션 -->
		                    <div style="margin-top: 4px;">
		                        <div style="background: #afd4ec; color: #000; padding: 8px 16px; border-radius: 8px 8px 0 0; font-weight: 600; font-size: 15px;">
		                            질문내용
		                        </div>
		                        <div style="background: #fff; border: 1px solid #e0e0e0; border-top: none; border-radius: 0 0 8px 8px; padding: 12px 14px;">
		                            <textarea id="qstnConts2" name="qstnConts" class="form-control" rows="4" readonly
		                                style="border: 1px solid #ddd; border-radius: 6px; font-size: 14px; font-weight: normal; resize: vertical; color: #000; background-color: #f9f9f9;"></textarea>
		                        </div>
		                    </div>

		                    <!-- 질문자 첨부파일 섹션 (fileGb='4') -->
		                    <div id="qstn-file-area" style="margin-top: 4px; display:none;">
		                        <div style="background: #afd4ec; color: #000; padding: 8px 16px; border-radius: 8px 8px 0 0; font-weight: 600; font-size: 15px;">
		                            질문첨부파일
		                        </div>
		                        <div style="background: #fff; border: 1px solid #e0e0e0; border-top: 1px solid #ccc; border-radius: 0 0 8px 8px; padding: 0;">
		                            <table id="qstn-file-table" class="table" style="width: 100%; font-size: 13px; margin-bottom: 0; border-collapse: collapse;">
		                                <thead style="display: none;">
		                                    <tr>
		                                        <th>문서제목</th><th>사이즈</th><th>작성일</th><th></th>
		                                    </tr>
		                                </thead>
		                                <tbody id="qstn-file-tbody"></tbody>
		                            </table>
		                        </div>
		                    </div>

		                    <!-- 질문완료 (숨김처리) -->
		                    <div class="form-group" style="margin-top: 0; display: none;">
		                        <select name="qstnWan" id="qstnWan2" class="custom-select">
		                            <option value="Y">질문완료</option>
		                            <option value="N" selected>질문진행</option>
		                        </select>
		                    </div>

		                    <!-- 답변내용 섹션 -->
		                    <div style="margin-top: 4px;">
		                        <div style="background: #d4eaf7; color: #000; padding: 8px 16px; border-radius: 8px 8px 0 0; font-weight: 600; font-size: 15px;">
		                            답변내용
		                        </div>
		                        <div style="background: #fff; border: 1px solid #e0e0e0; border-top: none; border-radius: 0 0 8px 8px; padding: 0;">
		                            <textarea id="ansrConts2" name="ansrConts" class="form-control" rows="7" required></textarea>
		                        </div>
		                    </div>

		                    <!-- 답변 파일업로드 섹션 -->
		                    <div style="margin-top: 4px;">
		                        <div style="background: #d4eaf7; color: #000; padding: 8px 16px; border-radius: 8px 8px 0 0; font-weight: 600; font-size: 15px;">
		                            답변 파일업로드
		                        </div>
		                        <div id="ansr-upload-area" style="background: #fff; border: 1px solid #e0e0e0; border-top: 1px solid #ccc; padding: 10px 14px;">
		                            <div style="display: flex; align-items: center;">
		                                <button type="button" class="btn btn-outline-secondary btn-sm" style="border-radius: 4px; font-size: 13px; padding: 4px 14px; border-color: #bbb; color: #000;" onclick="openAnsrFileInput()">파일찾기</button>
		                                <input type="file" id="ansr-file-input" multiple style="display:none;" onchange="ansrHandleFiles(this.files)">
		                            </div>
		                            <div id="ansr-drop-zone" style="border: none; padding: 0; min-height: 0;">
		                                <div id="ansr-file-list-new" class="file-list-container"></div>
		                            </div>
		                        </div>
		                    </div>

		                    <!-- 답변자 업로드된 파일 테이블 (fileGb='5') -->
		                    <div id="ansr-file-area2" style="margin-top: 4px; display:none;">
		                        <div style="background: #d4eaf7; color: #000; padding: 8px 16px; border-radius: 8px 8px 0 0; font-weight: 600; font-size: 15px;">
		                            답변첨부파일
		                        </div>
		                        <div style="background: #fff; border: 1px solid #e0e0e0; border-top: 1px solid #ccc; border-radius: 0 0 8px 8px; padding: 0;">
		                            <table id="ansr-file-table2" class="table" style="width: 100%; font-size: 13px; margin-bottom: 0; border-collapse: collapse;">
		                                <thead style="display: none;">
		                                    <tr>
		                                        <th>문서제목</th><th>사이즈</th><th>작성일</th><th></th><th></th>
		                                    </tr>
		                                </thead>
		                                <tbody id="ansr-file-tbody2"></tbody>
		                            </table>
		                        </div>
		                    </div>

		                    <!-- 답변완료 섹션 -->
		                    <div style="margin-top: 4px;">
		                        <div style="background: #d4eaf7; color: #000; padding: 8px 16px; border-radius: 8px 8px 0 0; font-weight: 600; font-size: 15px;">
		                            답변완료
		                        </div>
		                        <div style="background: #fff; border: 1px solid #e0e0e0; border-top: none; border-radius: 0 0 8px 8px; padding: 12px 14px;">
		                            <select class="custom-select" name="ansrWan" id="ansrWan2"
		                                style="height: 35px; font-size: 14px; width: 100%;">
		                                <option value="Y">답변완료</option>
		                                <option value="N" selected>답변대기</option>
		                            </select>
		                        </div>
		                    </div>

		                </div>
		            </div>

		            <!-- Modal Footer -->
		            <div class="modal-footer" style="background: #fff; padding: 10px 24px; border-top: 1px solid #eee; justify-content: center;">
		                <button id="form_btn_ins" type="button" class="btn btn-outline-dark btn-sm" style="font-size: 13px; padding: 5px 18px; display:none;" onClick="fn_Insert()">입력 <i class="far fa-edit"></i></button>
		                <button id="form_btn_udt" type="button" class="btn btn-outline-dark btn-sm" style="font-size: 13px; padding: 5px 18px;" onClick="fn_Update()">답변저장 <i class="far fa-save"></i></button>
		                <button id="form_btn_del" type="button" class="btn btn-outline-dark btn-sm" style="font-size: 13px; padding: 5px 18px; display:none;" onClick="fn_Delete()">삭제 <i class="far fa-trash-alt"></i></button>
		                <button type="button" class="btn btn-outline-dark btn-sm" style="font-size: 13px; padding: 5px 18px;" data-dismiss="modal" onClick="modalMainClose()">닫기 <i class="fas fa-times"></i></button>
		            </div>
		        </div>
		    </div>
		</div>

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
		// Form마다 조회 조건 변경 시작
		var findTxtln  = 0;    // 조회조건시 글자수 제한 / 0이면 제한 없음
		var firstflag  = false; // 첫음부터 Find하시려면 false를 주면됨
		var findValues = [];
		// 조회조건이 있으면 설정하면됨 / 조건 없으면 막으면 됨
		// 글자수조건 있는건 1개만 설정가능 chk: true 아니면 모두 flase
		// 조회조건은 필요한 만큼 추가사용 하면됨.
		findValues.push({ id: "findData", val: "",  chk: true  });
	    let s_hospcd    = getCookie("s_hospid") ;
	    let s_wnn_yn    = getCookie("s_wnn_yn") ;
	    let s_hosp_uuid = getCookie("s_hosp_uuid");
	  //원너넷이 아니거나 워너넷에서 병원을 선택해서 처리한 경우)
	    if ( (s_hospcd &&  s_wnn_yn != 'Y') || (s_hospcd != s_hosp_uuid) )   { 
	        findValues.push({ id: "hospCd1", val: s_hospcd,  chk: false  });
            $("#hospCd1").val(s_hospcd);
	    }else{
	        findValues.push({ id: "hospCd1", val:"",  chk: false  });
            $("#hospCd1").val("");
	    }
	    findValues.push({ id: "asqGb", val: "",  chk: false  });
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
		var list_code = ['ASQ_GB'];     // 구분코드 필요한 만큼 선언해서 사용
		var select_id = ['asqGb'];     // 구분코드 데이터 담길 Select (ComboBox ID)
		var firstnull = ['Y'];                              // Y 첫번째 Null,이후 Data 담김 / N 바로 Data 담김 
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
		var c_Head_Set = ['','','답변상태','질문항목','질문내용','병원명','질문자','작성일','첨부파일'];
		var columnsSet = [  // data 컬럼 id는 반드시 DTO의 컬럼,Modal id는 일치해야 함 (조회시)
	        				// name 컬럼 id는 반드시 DTO의 컬럼 일치해야 함 (수정,삭제시), primaryKey로 수정, 삭제함.
	        				// dt-body-center, dt-body-left, dt-body-right	        				
	        				{ data: 'asqSeq',     visible: false, className: 'dt-body-center' , width: '100px' ,  name: 'keyasqSeq', primaryKey: true },
	        				{ data: 'fileGb',     visible: false, className: 'dt-body-center' , width: '100px' ,  name: 'keyfileGb', primaryKey: true },
	        				{ data: 'ansrStat',   visible: true,  className: 'dt-body-center' , headCenter: true  , width: '50px'},
	        				{ data: 'qstnTitle',  visible: true,  className: 'dt-body-left'   , width: '300px'},
	        				{ data: 'qstnConts',  visible: true,  className: 'dt-body-left'   , width: '400px'},
	        				{ data: 'hospNm',     visible: true,  className: 'dt-body-center' , headCenter: true  , width: '400px'},
	        				{ data: 'userNm',     visible: true,  className: 'dt-body-center' , headCenter: true  , width: '300px'},
	        				{ data: 'regDttm',    visible: true,  className: 'dt-body-center' , width: '150px',  },
	        				{ data: 'fileYn',     visible: true,  className: 'dt-body-center' , width: '50px',
	        				    render: function (data, type, row) {
	        				        if (type === 'display') {
	        				            if (data === 'Y') {
	        				                return '<img src="/images/winct/filedown.svg" title="첨부파일 있음" style="width:16px; height:16px; vertical-align:middle;">';
	        				            } else {
	        				                return '';
	        				            }
	        				        }
	        				        return data;
	        				    }
	        				}
	        			  ];
		
		var s_CheckBox = true;   		           	 // CheckBox 표시 여부
        var s_AutoNums = true;   		             // 자동순번 표시 여부
        
		// 초기 data Sort,  없으면 []
		var muiltSorts = [
							['regDttm', 'desc' ]
        				 ];
        // Sort여부 표시를 일부만 할 때 개별 id, ** 전체 적용은 '_all'하면 됩니다. ** 전체 적용 안함은 []        				 
		var showSortNo = ['regDttm'];                   
		// Columns 숨김 columnsSet -> visible로 대체함 hideColums 보다 먼제 처리됨 ( visible를 선언하지 않으면 hideColums컬럼 적용됨 )	
		var hideColums = ['asqSeq','fileGb'];             // 없으면 []; 일부 컬럼 숨길때		
		var txt_Markln = 80;                       				 // 컬럼의 글자수가 설정값보다 크면, 다음은 ...로 표시함
		// 글자수 제한표시를 일부만 할 때 개별 id, ** 전체 적용은 '_all'하면 됩니다. ** 전체 적용 안함은 []
		var markColums = ['qstnTitle','qstnConts','ansrConts'];
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
	        const qstnTitleInput     = document.getElementById("qstnTitle2");
	        const qstnContsInput     = document.getElementById("qstnConts2");
	        const qstnWanInput       = document.getElementById("qstnWan2");
	        const inputs = [qstnTitleInput,qstnContsInput,qstnWanInput];
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
		    }
	        if (flag !== 'I') {
	            $(qstnWanInput).css("pointer-events", "none").css("background-color", "#e9ecef"); // 비활성화된 느낌의 배경색 적용
	        } else {
	            $(qstnWanInput).css("pointer-events", "").css("background-color", ""); // 활성화
	        }	        
	        $(qstnWanInput).css("pointer-events", "none").css("background-color", "#e9ecef");
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
		            modalHead.innerText  = "1:1 문의하기" ;
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
					// ID가 변경된 필드 수동 설정 (2→접미사 때문에 formValueSet 매칭 안됨)
					$('#qstnTitle2').val(edit_Data.qstnTitle || '');
					$('#qstnConts2').val(edit_Data.qstnConts || '');
					$('#asqSeq2').val(edit_Data.asqSeq || '');
					$('#fileGb2').val(edit_Data.fileGb || '');
					$('#qstnStat2').val(edit_Data.qstnStat || '');
					$('#ansrStat2').val(edit_Data.ansrStat || '');
					// ansrWan 값이 없으면 'N'(진행) 기본값 설정
					$('#ansrWan option').prop('selected', false);
					$('#ansrWan option[value="' + (edit_Data.ansrWan || 'N') + '"]').prop('selected', true);
					// 답변내용 Summernote는 모달 표시 후 초기화
					var _ansrText = edit_Data.ansrConts || '';
					// 파일 목록 로딩
					var asqSeqVal = edit_Data.asqSeq;
					if (asqSeqVal) {
					    showQstnFileList(asqSeqVal);   // 질문자 파일 조회/다운로드
					    showAnsrFileList2(asqSeqVal);   // 답변자 파일 삭제/다운로드
					}
					ansrFileClear();
				} else {
					modal_OpenFlag = false;
					messageBox("1","<h5>작업 할 Data가 선택되지 않았습니다. !!</h5><p></p><br>",mainFocus,"","");
					return null;
				}
			} else {
				// 입력 모드 - 파일 영역 초기화
				$("#qstn-file-area").hide();
				$("#ansr-file-area2").hide();
				ansrFileClear();
				var _ansrText = '';
			}

			if (modal_OpenFlag) {
			    //수정시 키는 readonly
			    modal_key_hidden(flag) ;
			    // 모달 띄우기
			    $("#" + modalName.id).modal('show');

			    // Summernote는 모달이 완전히 표시된 후 초기화
			    $('#modalName').one('shown.bs.modal', function() {
			        modalName_rich(_ansrText);
			    });

			    if (getCookie("s_userid")) {
	  	            inputZone.querySelector("[name='updUser']").value = getCookie("s_userid");
			    }

			    if (getCookie("s_connip")) {
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
					    initComplete: function() {
				            var api = this.api();
				            api.columns().every(function(colIdx) {
				                if (gridColums[colIdx] && gridColums[colIdx].headCenter) {
				                    $(api.column(colIdx).header()).css('text-align', 'center');
				                }
				            });
				            // 해상도(확대/축소) 변경 시 헤더/바디 너비 재조정
				            $(window).on('resize', function() {
				                api.columns.adjust();
				            });
				        },
				        rowCallback: function(row, data, index) {
				            $(row).find('td').css({'padding': colPadding, 'font-weight': 'normal'});
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

				// 상단 컨트롤을 자료검색 우측 끝으로 이동
				setTimeout(function() {
				    var controlsDiv = document.querySelector('.datatable-controls');
				    var topBar = document.getElementById('topControlBar');
				    if (controlsDiv && topBar) {
				        topBar.style.cssText = 'display:flex !important; align-items:center; gap:5px; margin:0; margin-left:auto;';
				        controlsDiv.appendChild(topBar);
				    }
				}, 500);

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
		   		// DOM에서 실시간 값 가져오기
		   		var el = document.getElementById(findValue.id);
		   		if (el) {
		   		    findValue.val = el.value;
		   		}
		   		find[key] = findValue.val;
		   	}
		    $.ajax({
		        type: "POST",
		        url: "/mangr/asqCdList.do",
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
		
		// 새 창 없이 파일 다운로드 (iframe 방식)
		function fn_fileDown(url) {
		    if (!url || url === '#') return;
		    var iframe = document.getElementById('hiddenDownFrame');
		    if (!iframe) {
		        iframe = document.createElement('iframe');
		        iframe.id = 'hiddenDownFrame';
		        iframe.style.display = 'none';
		        document.body.appendChild(iframe);
		    }
		    iframe.src = url;
		}

		function fn_hospCd1Init(chk){
			if(chk.checked){
				$("#hospCd1").val("");
				for(let fv of findValues){
					if(fv.id === "hospCd1"){ fv.val = ""; break; }
				}
			}else{
				let s_hospcd = getCookie("s_hospid");
				$("#hospCd1").val(s_hospcd);
				for(let fv of findValues){
					if(fv.id === "hospCd1"){ fv.val = s_hospcd; break; }
				}
			}
			triggerFind();
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
		    	//faqSeq:     { kname: "등록순서", k_min: 3, k_max: 10, k_req: true, k_spc: true, k_clr: true },
		    	//fileGb:     { kname: "구분", k_req: true },
		    	ansrConts2:  { kname: "답변내용" , k_req: true },
		    	ansrWan2 :  { kname: "딥변여부" , k_req: true },
		    });
		    return results;
		}
		//그리드상 데이타생성및 수정 작업
		function newuptData() {
        	let newData = {
        		userNm:     $('#userNm').val(),  	
        		hospNm:     $('#hospNm').val(),        			
        		qstnTitle:  $('#qstnTitle2').val(),
        		qstnConts:  $('#qstnConts2').val(),
        		ansrConts:  $('#ansrConts2').val(),  // id changed to ansrConts2 but key stays ansrConts for DataTable
        		qstnStat:   $('#qstnStat2').val(),
        		ansrStat:   $('#ansrStat2').val(),
        		qstnWan:    $('#qstnWan2').val(),
        		ansrWan:    $('#ansrWan2').val(),
        		useYn:      $('#useYn').val(),
        		updDttm :   $('#updDttm').val()
			    };
		    return newData;
		}	
		function fn_Insert(){
			// Summernote 내용을 textarea에 동기화
			if ($('#ansrConts2').next('.note-editor').length) {
				$('#ansrConts2').val($('#ansrConts2').summernote('code'));
			}
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
				// id가 ansrConts2이므로 서버가 기대하는 ansrConts로 매핑
				if (data.hasOwnProperty('ansrConts2')) {
				    data['ansrConts'] = data['ansrConts2'];
				    delete data['ansrConts2'];
				}
				// Map new IDs back to original server-side names
				if (data.hasOwnProperty('qstnTitle2')) { data['qstnTitle'] = data['qstnTitle2']; delete data['qstnTitle2']; }
				if (data.hasOwnProperty('qstnConts2')) { data['qstnConts'] = data['qstnConts2']; delete data['qstnConts2']; }
				if (data.hasOwnProperty('qstnStat2'))  { data['qstnStat']  = data['qstnStat2'];  delete data['qstnStat2']; }
				if (data.hasOwnProperty('ansrStat2'))   { data['ansrStat']  = data['ansrStat2'];   delete data['ansrStat2']; }
				if (data.hasOwnProperty('qstnWan2'))    { data['qstnWan']   = data['qstnWan2'];    delete data['qstnWan2']; }
				if (data.hasOwnProperty('ansrWan2'))     { data['ansrWan']   = data['ansrWan2'];     delete data['ansrWan2']; }
				if (data.hasOwnProperty('asqSeq2'))     { data['asqSeq']   = data['asqSeq2'];     delete data['asqSeq2']; }
				if (data.hasOwnProperty('fileGb2'))      { data['fileGb']   = data['fileGb2'];      delete data['fileGb2']; }
		        dats.push(data);
			    $.ajax({
			            type: "POST",
			            url: "/mangr/asqCdInsert.do",
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
		    // Summernote 내용을 textarea에 동기화
		    if ($('#ansrConts2').next('.note-editor').length) {
		        $('#ansrConts2').val($('#ansrConts2').summernote('code'));
		    }
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
		        // id가 ansrConts2이므로 서버가 기대하는 ansrConts로 매핑
		        if (data.hasOwnProperty('ansrConts2')) {
		            data['ansrConts'] = data['ansrConts2'];
		            delete data['ansrConts2'];
		        }
		        // Map new IDs back to original server-side names
		        if (data.hasOwnProperty('qstnTitle2')) { data['qstnTitle'] = data['qstnTitle2']; delete data['qstnTitle2']; }
		        if (data.hasOwnProperty('qstnConts2')) { data['qstnConts'] = data['qstnConts2']; delete data['qstnConts2']; }
		        if (data.hasOwnProperty('qstnStat2'))  { data['qstnStat']  = data['qstnStat2'];  delete data['qstnStat2']; }
		        if (data.hasOwnProperty('ansrStat2'))   { data['ansrStat']  = data['ansrStat2'];   delete data['ansrStat2']; }
		        if (data.hasOwnProperty('qstnWan2'))    { data['qstnWan']   = data['qstnWan2'];    delete data['qstnWan2']; }
		        if (data.hasOwnProperty('ansrWan2'))     { data['ansrWan']   = data['ansrWan2'];     delete data['ansrWan2']; }
		        if (data.hasOwnProperty('asqSeq2'))     { data['asqSeq']   = data['asqSeq2'];     delete data['asqSeq2']; }
		        if (data.hasOwnProperty('fileGb2'))      { data['fileGb']   = data['fileGb2'];      delete data['fileGb2']; }
		        // SQL WHERE절에 필요한 키값 및 updUser/updIp 추가
		        data['asqSeq']  = $('#asqSeq2').val() || (edit_Data ? edit_Data.asqSeq : '');
		        data['fileGb']  = $('#fileGb2').val() || (edit_Data ? edit_Data.fileGb : '');
		        data['updUser'] = $('#updUser').val() || getCookie("s_userid") || '';
		        data['updIp']   = $('#updIp').val() || getCookie("s_connip") || '';

		        // 3. 선택된 행의 Primary Key 가져오기
		        var selectedRows = dataTable.rows('.selected');
		        let keys = dataTableKeys(dataTable, selectedRows);

		        // 4. Primary Key와 입력 데이터 병합 (배열로 만들어 서버에 전송)
		        let mergeData;
		        if (keys.length > 0) {
		            mergeData = keys.map(key => ({ ...data, ...key }));
		        } else {
		            // 선택된 행이 없을 경우 hidden input의 키값으로 직접 전송
		            mergeData = [data];
		        }
		        // 5. AJAX로 서버 업데이트 요청
		        $.ajax({
		            type: "POST",
		            url: "/mangr/asqCdUpdate.do",
		            data: JSON.stringify(mergeData), // JSON 변환
		            contentType: "application/json",
		            dataType: "json",
		            success: function(response) {
		                console.log("업데이트 성공", response);
		                // 6. 답변 파일 업로드 처리 (fn_FindData 전에 먼저 실행)
		                var savedAsqSeq = $('#asqSeq2').val() || (edit_Data ? edit_Data.asqSeq : '');
		                var ansrFileInput = document.getElementById('ansr-file-input');
		                if (ansrFileInput && ansrFileInput.files && ansrFileInput.files.length > 0 && savedAsqSeq) {
		                    var hospCd  = getCookie("s_hospid") || (edit_Data ? edit_Data.hospCd : '') || '';
		                    var regUser = getCookie("s_userid") || '';
		                    uploadAnsrFiles(savedAsqSeq, hospCd, regUser, function() {
		                        fn_FindData();
		                        $("#" + modalName.id).modal('hide');
		                        messageBox("1", "<h5> 정상적으로 업데이트되었습니다. </h5>", mainFocus, "", "");
		                    });
		                } else {
		                    fn_FindData();
		                    $("#" + modalName.id).modal('hide');
		                    messageBox("1", "<h5> 정상적으로 업데이트되었습니다. </h5>", mainFocus, "", "");
		                }
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
				            url: "/mangr/asqCdDelete.do",	    	    
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
				            url: "/mangr/asqCdDelete.do",	    	    
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
		function modalMainClose() {
			$('#ansrConts2').summernote('destroy');
			$("#" + modalName.id).modal('hide');
		}

		// 답변내용 Summernote 에디터 초기화
		function modalName_rich(answerText) {
			if (typeof $.fn.summernote === 'undefined') {
				console.log('summernote 미로드 상태');
				return;
			}
			let safeAnswer = (answerText || '');
			let convertedAnswer = safeAnswer.replace(/\n/g, "<br>");

			// 기존 Summernote가 있으면 먼저 제거
			try { $('#ansrConts2').summernote('destroy'); } catch(e) {}

			$('#ansrConts2').summernote({
				placeholder: '답변 내용을 입력하세요...',
				tabsize: 1,
				height: 200,
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
						$('#ansrConts2').next().find('.note-editable').css('font-size', '14px');
						$('#ansrConts2').summernote('code', convertedAnswer);
					}
				}
			});
		}

		// 모달이 닫힐 때 Summernote 제거
		$('#modalName').on('hidden.bs.modal', function () {
			$('#ansrConts2').summernote('destroy');
		});

		//요양병원 아이디 변경시 재조회
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

		// ====== 질문자 파일 조회/다운로드 (fileGb='4') ======
		function showQstnFileList(asqSeq) {
		    if (!asqSeq) { $("#qstn-file-area").hide(); return; }
		    $.ajax({
		        url: '/mangr/fileCdList.do',
		        type: 'POST',
		        data: { fileSeq: asqSeq, fileGb: '4' },
		        dataType: 'json',
		        success: function(data) {
		            var tbody = document.getElementById('qstn-file-tbody');
		            tbody.innerHTML = '';
		            if (data && data.length > 0) {
		                for (var i = 0; i < data.length; i++) {
		                    var fileTitle = data[i].fileTitle || '제목 없음';
		                    var fileSize  = data[i].fileSize  || '';
		                    var regDttm   = data[i].regDttm   || '';
		                    var fileUrl   = '#';
		                    if (data[i].filePath && data[i].fileTitle) {
		                        fileUrl = '/sftp/download.do?filePath=' + encodeURIComponent(data[i].filePath);
		                    }
		                    var row = '<tr style="border-bottom: 1px solid #eee;">';
		                    row += '<td style="padding:6px 8px; text-align:left;"><a href="javascript:void(0);" onclick="fn_fileDown(\'' + fileUrl + '\');" style="color:#2874A6; text-decoration:underline; font-weight:500;">' + fileTitle + '</a></td>';
		                    row += '<td style="text-align:center; padding:6px 8px; color:#555; white-space:nowrap; width:80px;">' + fileSize + ' KB</td>';
		                    row += '<td style="text-align:center; padding:6px 8px; color:#555; white-space:nowrap; width:140px;">' + regDttm + '</td>';
		                    row += '<td style="text-align:center; vertical-align:middle; padding:6px 4px; width:30px;">';
		                    if (fileUrl !== '#') {
		                        row += "<a href='javascript:void(0);' onclick=\"fn_fileDown('" + fileUrl + "');\" title='다운로드' style='color:#28a745;'>";
		                        row += "<img src='/images/winct/filedown.svg' alt='다운로드' style='width:16px; height:16px; vertical-align:middle;'>";
		                        row += '</a>';
		                    }
		                    row += '</td>';
		                    row += '</tr>';
		                    tbody.innerHTML += row;
		                }
		                $("#qstn-file-area").show();
		            } else {
		                tbody.innerHTML = "<tr><td colspan='4' style='text-align:center; color:#999;'>등록된 파일이 없습니다.</td></tr>";
		                $("#qstn-file-area").show();
		            }
		        }
		    });
		}

		// ====== 답변자 파일 업로드/삭제/다운로드 (fileGb='5') ======
		var ansrSelectedFiles = new DataTransfer();

		function openAnsrFileInput() {
		    document.getElementById('ansr-file-input').click();
		}

		function ansrHandleFiles(files) {
		    for (var i = 0; i < files.length; i++) {
		        ansrSelectedFiles.items.add(files[i]);
		    }
		    document.getElementById('ansr-file-input').files = ansrSelectedFiles.files;
		    ansrShowNewFileList();
		}

		function ansrDropHandler(event) {
		    var files = event.dataTransfer.files;
		    ansrHandleFiles(files);
		}

		function ansrShowNewFileList() {
		    var html = '';
		    var files = ansrSelectedFiles.files;
		    for (var i = 0; i < files.length; i++) {
		        html += '<div class="file-item" style="display:flex; align-items:center; justify-content:space-between; padding:3px 8px; border-bottom:1px solid #eee;">' +
		            '<span><i class="fa fa-file" style="color:#555; margin-right:5px;"></i>' + files[i].name +
		            ' (' + Math.round(files[i].size / 1024) + 'KB)</span>' +
		            '<button type="button" onclick="ansrRemoveNewFile(' + i + ')" class="delete-btn" style="border:none; background:none; color:red; cursor:pointer; font-size:12px;">삭제</button>' +
		            '</div>';
		    }
		    document.getElementById('ansr-file-list-new').innerHTML = html;
		}

		function ansrRemoveNewFile(index) {
		    var newDt = new DataTransfer();
		    var files = ansrSelectedFiles.files;
		    for (var i = 0; i < files.length; i++) {
		        if (i !== index) newDt.items.add(files[i]);
		    }
		    ansrSelectedFiles = newDt;
		    document.getElementById('ansr-file-input').files = ansrSelectedFiles.files;
		    ansrShowNewFileList();
		}

		function uploadAnsrFiles(asqSeq, hospCd, regUser, callback) {
		    var files = document.getElementById('ansr-file-input').files;
		    if (!files || files.length === 0) {
		        if (typeof callback === 'function') callback();
		        return;
		    }
		    var formData = new FormData();
		    for (var i = 0; i < files.length; i++) {
		        formData.append('file', files[i]);
		    }
		    formData.append('hospCd', hospCd || '');
		    formData.append('fileGb', '5');
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
		            console.log('답변 파일 업로드 성공:', res);
		            if (typeof callback === 'function') callback();
		        },
		        error: function(xhr) {
		            console.log('답변 파일 업로드 실패:', xhr.responseText);
		            alert('파일 업로드 중 오류가 발생했습니다.');
		            if (typeof callback === 'function') callback();
		        }
		    });
		}

		function showAnsrFileList2(asqSeq) {
		    if (!asqSeq) { $("#ansr-file-area2").hide(); return; }
		    $.ajax({
		        url: '/mangr/fileCdList.do',
		        type: 'POST',
		        data: { fileSeq: asqSeq, fileGb: '5' },
		        dataType: 'json',
		        success: function(data) {
		            var tbody = document.getElementById('ansr-file-tbody2');
		            tbody.innerHTML = '';
		            if (data && data.length > 0) {
		                for (var i = 0; i < data.length; i++) {
		                    var fileTitle = data[i].fileTitle || '제목 없음';
		                    var fileSize  = data[i].fileSize  || '';
		                    var regDttm   = data[i].regDttm   || '';
		                    var fileUrl   = '#';
		                    if (data[i].filePath && data[i].fileTitle) {
		                        fileUrl = '/sftp/download.do?filePath=' + encodeURIComponent(data[i].filePath);
		                    }
		                    var row = '<tr style="border-bottom: 1px solid #eee;">';
		                    row += '<td style="padding:6px 8px; text-align:left;"><a href="javascript:void(0);" onclick="fn_fileDown(\'' + fileUrl + '\');" style="color:#2874A6; text-decoration:underline; font-weight:500;">' + fileTitle + '</a></td>';
		                    row += '<td style="text-align:center; padding:6px 8px; color:#555; white-space:nowrap; width:80px;">' + fileSize + ' KB</td>';
		                    row += '<td style="text-align:center; padding:6px 8px; color:#555; white-space:nowrap; width:140px;">' + regDttm + '</td>';
		                    row += '<td style="text-align:center; vertical-align:middle; padding:6px 4px; width:30px;">';
		                    row += "<a href='javascript:void(0);' onclick=\"deleteAnsrFile('" + data[i].filePath + "','" + asqSeq + "');\" title='삭제' style='color:black;'>";
		                    row += "<i class='fa-solid fa-trash' style='font-size: 1.0em;'></i>";
		                    row += '</a></td>';
		                    row += '<td style="text-align:center; vertical-align:middle; padding:6px 4px; width:30px;">';
		                    if (fileUrl !== '#') {
		                        row += "<a href='javascript:void(0);' onclick=\"fn_fileDown('" + fileUrl + "');\" title='다운로드' style='color:#28a745;'>";
		                        row += "<img src='/images/winct/filedown.svg' alt='다운로드' style='width:16px; height:16px; vertical-align:middle;'>";
		                        row += '</a>';
		                    }
		                    row += '</td>';
		                    row += '</tr>';
		                    tbody.innerHTML += row;
		                }
		                $("#ansr-file-area2").show();
		            } else {
		                tbody.innerHTML = "<tr><td colspan='5' style='text-align:center; color:#999;'>등록된 파일이 없습니다.</td></tr>";
		                $("#ansr-file-area2").show();
		            }
		        }
		    });
		}

		function deleteAnsrFile(filePath, asqSeq) {
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
		            var savedAnsr = $("#ansrConts2").val();
		            var savedWan  = $("#ansrWan").val();
		            $.ajax({
		                url: '/sftp/deleteFile.do',
		                type: 'POST',
		                data: {
		                    hospCd: getCookie("s_hospid") || '',
		                    filePath: filePath,
		                    fileSeq: asqSeq,
		                    fileGb: '5',
		                    updUser: getCookie("s_userid") || '',
		                    updIp: getCookie("s_connip") || ''
		                },
		                success: function(res) {
		                    $("#ansrConts2").val(savedAnsr);
		                    $("#ansrWan").val(savedWan);
		                    showAnsrFileList2(asqSeq);
		                    Swal.fire({
		                        title: '처리확인',
		                        text: '정상처리 되었습니다.',
		                        icon: 'success',
		                        timer: 1500,
		                        timerProgressBar: true,
		                        showConfirmButton: false,
		                        customClass: { popup: 'small-swal' }
		                    });
		                },
		                error: function(xhr) {
		                    Swal.fire({
		                        title: '에러확인',
		                        text: '문제 발생, 잠시후 다시 하십시요.',
		                        icon: 'error',
		                        timer: 1500,
		                        timerProgressBar: true,
		                        showConfirmButton: false,
		                        customClass: { popup: 'small-swal' }
		                    });
		                }
		            });
		        } else if (result.isDismissed) {
		            Swal.fire({
		                title: '취소확인',
		                text: '작업이 취소 되었습니다.',
		                icon: 'info',
		                timer: 1000,
		                timerProgressBar: true,
		                showConfirmButton: false,
		                customClass: { popup: 'small-swal' }
		            });
		        }
		    });
		}

		function ansrFileClear() {
		    ansrSelectedFiles = new DataTransfer();
		    var fileInput = document.getElementById('ansr-file-input');
		    if (fileInput) fileInput.value = '';
		    var listNew = document.getElementById('ansr-file-list-new');
		    if (listNew) listNew.innerHTML = '';
		    var tbody = document.getElementById('ansr-file-tbody2');
		    if (tbody) tbody.innerHTML = '';
		    $("#ansr-file-area2").hide();
		}

		</script>
		<!-- ============================================================== -->
		<!-- 기타 정보 End -->
		<!-- ============================================================== -->

		