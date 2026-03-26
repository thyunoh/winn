<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>  
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="decorator" uri="http://www.opensymphony.com/sitemesh/decorator" %>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/page" prefix="page" %>
<%@ page import ="java.util.Date" %>

<link href="/css/winmc/style_comm.css?v=126"  rel="stylesheet">
    <!-- DataTables CSS -->
    <style>
/* ===== 모달 라벨 스타일 ===== */
#modalName .modal-body .col-form-label {
	font-size: 14px; font-weight: 500; color: #333;
	background: linear-gradient(135deg, #b3ddf0 0%, #d4ecf7 100%);
	border-radius: 3px; padding: 4px 8px 4px 18px;
	display: flex; align-items: center;
	min-height: 30px; white-space: nowrap;
}
#modalName .modal-body .form-group.row {
	margin-left: 0; margin-right: 0;
}
#modalName .modal-body {
	padding: 10px 18px;
}
#modalName .modal-body .form-group {
	margin-bottom: 3px; align-items: center;
}
#modalName .modal-body .form-control,
#modalName .modal-body .custom-select {
	font-size: 14px; height: 30px; padding: 2px 8px;
}
    </style>
<!-- ============================================================== -->
        <!-- Main Form start -->
        <!-- ============================================================== -->
      <div class="dashboard-wrapper">
            <div class="container-fluid  dashboard-content">
                <div class="row">
                <!-- 좌측 카드 : 상단 내용 (너비를 줄여서 50% 배정) -->
               <div class="col-xl-2 col-lg-2">
                  <div class="card">
                     <div class="card-body">
                        <div class="d-flex align-items-center mb-2" style="gap:5px; flex-wrap:nowrap;">
                            <button class="btn btn-outline-dark btn-sm" style="white-space:nowrap; font-size:13px; padding:5px 10px;" onClick="fn_re_load()">재조회<i class="fas fa-binoculars ml-1"></i></button>
                            <button class="btn btn-warning text-dark btn-sm" style="white-space:nowrap; font-size:13px; padding:5px 8px;" onclick="fn_CopyData()">최종자료복사.생성</button>
                        </div>
                        <div class="d-flex align-items-center mb-2" style="gap:4px; flex-wrap:nowrap;">
                            <select id="copyDate" name="copyDate" required class="custom-select custom-select-sm" style="flex:1; font-size:13px; padding:4px 26px 4px 6px;">
                              <!-- 연도 옵션 -->
                            </select>
                            <select id="copyMonth" name="copyMonth" required class="custom-select custom-select-sm" style="flex:1; font-size:13px; padding:4px 24px 4px 6px;">
                              <!-- 월 옵션 -->
                            </select>
                            <select id="copyDay" name="copyDay" required class="custom-select custom-select-sm" style="flex:1; font-size:13px; padding:4px 24px 4px 6px;">
                              <!-- 일 옵션 -->
                            </select>
                        </div>
                        <div>
                           <table id="wv_tableName"
                              class="display nowrap stripe hover cell-border order-column responsive">
                              <!-- 테이블 내용 -->
                           </table>
                        </div>
                     </div>
                  </div>
               </div>
                        <!-- 우측 카드 : 기존 하단의 공통세부정보 영역을 이동 -->
               <div class="col-xl-10 col-lg-10">
                        <div class="card">                           
                            <div class="card-body">  
                               <div class="form-row mb-2">
                                    <div class="col-sm-4">
                                        <div class="input-group">
                                             <input id="findData" type="text" class="form-control" placeholder="3글자 이상 입력 후 [ enter ]" 
                                                                                                 onkeyup="findEnterKey()" oninput="findField(this)">
                                             <div class="input-group-append">
                                                 <button type="button" class="btn btn-rounded btn-primary"  onClick="fn_FindData()">조회. <i class="fas fa-search"></i></button>
                                             </div>
                                        </div>
                                    </div>
                                    <div class="col-sm-6">                                    
                                         <div class="btn-group ml-auto">
                                            <button class="btn btn-outline-dark" data-toggle="tooltip" data-placement="top" title=""            onClick="fn_re_load()">재조회. <i class="fas fa-binoculars"></i></button>
                                            <button class="btn btn-outline-dark btn-insert" data-toggle="tooltip" data-placement="top" title="신규 Data 입력" onClick="modal_Open('I')">입력. <i class="far fa-edit"></i></button>                                            
                                            <button class="btn btn-outline-dark btn-update" data-toggle="tooltip" data-placement="top" title="선택 Data 수정" onClick="modal_Open('U')">수정. <i class="far fa-save"></i></button>                                            
                                            <button class="btn btn-outline-dark btn-delete" data-toggle="tooltip" data-placement="top" title="선택 Data 삭제" onClick="modal_Open('D')">삭제. <i class="far fa-trash-alt"></i></button>                                             
                                            <button class="btn btn-outline-dark btn-delete" data-toggle="tooltip" data-placement="top" title="체크 Data 삭제" onClick="fn_findchk()">체크삭제. <i class="far fa-calendar-check"></i></button>
                                            <button class="btn btn-outline-success" data-toggle="tooltip" data-placement="top" title="엑셀 파일 업로드" onClick="excelUpload_Open()">엑셀업로드. <i class="fas fa-file-excel"></i></button>
                                            <button class="btn btn-outline-dark" data-toggle="tooltip" data-placement="top" title="화면 Size 확대.축소" id="fullscreenToggle">화면확장축소. <i class="fas fa-expand" id="fullscreenIcon"></i></button>
                                        </div>
                                    </div>
                                </div>
                               
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
                    <!-- ============================================================== -->
                    <!-- data table end   -->
                    <!-- ============================================================== -->
         </div>                
        </div>
      </div>        
      <!-- ============================================================== -->
        <!-- modal form start -->
        <!-- ============================================================== -->        
       <div class="modal fade" id="modalName" tabindex="-1" data-backdrop="static" role="dialog" aria-hidden="false" data-keyboard="false">
         <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable"   role="dialog" style="position:absolute; top:50%; left:50%; 
                                                      transform:translate(-50%, -50%); width:50vw; max-width:50vw;max-height: 50vh;">
           <div class="modal-content" style="height: 45%;display: flex;flex-direction: column;">
             <div class="modal-header bg-light">
                  <h5 class="modal-title" id="modalHead"></h5> 
                 <!-- ============================================================== -->
                 <!-- button start -->
                 <!-- ============================================================== -->                  
                 <div class="form-row">
                     <div class="col-sm-12 mb-2" style="text-align:right;"> 
                       <button id="form_btn_new" type="submit" class="btn btn-outline-dark"   onClick="fn_Potion()">센터. <i class="far fa-object-group"></i></button>
                       <button id="form_btn_ins" type="submit" class="btn btn-outline-info    btn-insert"  onClick="fn_Insert()">입력. <i class="far fa-edit"></i></button>
                   <button id="form_btn_udt" type="submit" class="btn btn-outline-success btn-update"  onClick="fn_Update()">수정. <i class="far fa-save"></i></button>
                      <button id="form_btn_del" type="submit" class="btn btn-outline-danger  btn-delete"  onClick="fn_Delete()">삭제. <i class="far fa-trash-alt"></i></button>
                      <button type="button" class="btn btn-outline-dark" data-dismiss="modal" onClick="modalMainClose()">닫기 <i class="fas fa-times"></i></button>
                    </div>                      
                 </div>
                 <!-- ============================================================== -->
                 <!-- end button -->
                 <!-- ============================================================== -->   
             </div>
             <div class="modal-body" style="text-align: left;flex: 1;overflow-y: auto;">             
                <!-- ================================================================== -->                
                <div id="inputZone">                
                   <!-- ============================================================== -->
                    <!-- text input 1개 start -->
                    <!-- ============================================================== -->
                    <input type="hidden" id="regUser" name="regUser" value="">
                    <input type="hidden" id="updUser" name="updUser" value="">
                    <input type="hidden" id="regIp"   name="regIp"   value="">
                    <input type="hidden" id="updIp"   name="updIp "  value= "">
                    <div class="form-group row ">
                       <label for="cateCode" class="col-2 col-lg-2 col-form-label text-left">지표코드</label>
                       <div class="col-6 col-lg-6">  
                    <select id="cateCode" name="cateCode" class="custom-select" oninput="findField(this)" required style="height:35px; font-size:14px;">
                       <option selected value= "" >구분 1</option> 
                    </select>
                      </div>
                        <label for="orderSeq" class="col-2 col-lg-2 col-form-label text-left">분류순서</label>
                        <div class="col-2 col-sm-2">
                            <input id="orderSeq" name="orderSeq" type="text" class="form-control is-invalid text-left" required placeholder="분류순서를 입력하세요">
                        </div>
                    </div>
                    <div class="form-group row g-0 mb-0">
                      <label for="startDt" class="col-2 col-lg-2 col-form-label text-left">시작일자</label>
                      <div class="col-4 col-lg-4">                                       
                         <input id="startDt" name="startDt" type="text" class="form-control date1-inputmask" required placeholder="yyyy-mm-dd" >
                      </div>
                        <label for="endDt" class="col-2 col-lg-2 col-form-label text-left">적용종료일</label>
                        <div class="col-4 col-lg-4">
                            <input id="endDt" name="endDt"  type="text" class="form-control date1-inputmask" placeholder="yyyy-mm-dd">
                            
                        </div>   
                    </div>                  
                    <div class="form-group row g-0 mb-0">
                        <label for="wevalueNm" class="col-2 col-sm-2 col-form-label text-left">지표명칭</label>
                        <div class="col-10 col-sm-10">
                            <input id="wevalueNm" name="wevalueNm" type="text" class="form-control text-left" placeholder="지표명칭을 입력하세요">
                        </div>
                    </div>
                   
                    <div class="form-group row">
                        <label for="calGubun" class="col-2 col-lg-2 col-form-label text-left">계산방식</label>
                        <div class="col-2 col-lg-2">
                           <select class="custom-select" name="calGubun" id="calGubun" required>
                            <option value="1">1.점수</option>
                            <option value="2" selected>2.율</option>
                          </select> 
                      </div> 
                        <label for="startIndi" class="col-2 col-lg-2 col-form-label text-left">시작지표</label>
                        <div class="col-2 col-lg-2">
                            <input id="startIndi"   name="startIndi"  type="text" class="form-control"  required  placeholder="" >
                        </div>
                        <label for="endIndi" class="col-2 col-lg-2 col-form-label text-left">종료지표</label>
                        <div class="col-2 col-lg-2">
                            <input id="endIndi"   name="endIndi"  type="text" class="form-control"  required  placeholder="" >
                        </div>
                    </div>
                    <div class="form-group row">
                        <label for="stdScore" class="col-2 col-lg-2 col-form-label text-left">표준점수</label>
                        <div class="col-4 col-lg-4">
                            <input id="stdScore"   name="stdScore"  type="text"  class="form-control"  required placeholder="">
                        </div>
                        <label for="weValue" class="col-2 col-lg-2 col-form-label text-left">가중치</label>
                        <div class="col-4 col-lg-4">
                            <input id="weValue" name="weValue"  type="text" class="form-control" required  placeholder="">
                        </div>

                    </div>
 
                <!-- ============================================================== -->
                <!-- end form 수정해야 될 곳 -->
                <!-- ============================================================== -->
             </div>
             <div class="modal-footer">
             </div>
           </div>
         </div>
       </div>
       </div>
        <!-- ============================================================== -->
        <!-- modal form end -->
        <!-- ============================================================== -->
        <!-- ============================================================== -->
        <!-- Excel Upload modal start -->
        <!-- ============================================================== -->
	    <div class="modal fade" id="excelUploadModal" tabindex="-1" data-backdrop="static" role="dialog" aria-hidden="false" data-keyboard="false">
	      <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable" role="dialog" style="width:85vw; max-width:85vw; max-height:85vh; margin:auto;">
	        <div class="modal-content" style="height: 95%; display: flex; flex-direction: column;">
	          <div class="modal-header bg-light">
	            <h6 class="modal-title">엑셀 업로드 (가중치 기준)</h6>
              <div class="form-row">
                  <div class="col-sm-12 mb-2" style="text-align:right;">
                    <button type="button" class="btn btn-outline-primary" onClick="fn_ExcelSaveAll()">전체저장 <i class="fas fa-save"></i></button>
                    <button type="button" class="btn btn-outline-success" onClick="fn_ExcelSaveSelected()">선택저장 <i class="far fa-save"></i></button>
                    <button type="button" class="btn btn-outline-dark" data-dismiss="modal" onClick="excelUpload_Close()">닫기 <i class="fas fa-times"></i></button>
                 </div>
              </div>
	          </div>
	          <div class="modal-body" style="text-align: left; flex: 1; overflow-y: auto;">
                <div class="form-group row mb-2">
                    <label class="col-1 col-form-label text-left">헤더위치</label>
                    <div class="col-1">
                        <input type="number" id="excelHeaderRow" class="form-control" value="3" min="1" max="20" style="height:35px; font-size:14px;" title="엑셀에서 헤더가 위치한 행 번호 (1부터 시작)">
                    </div>
                    <label class="col-1 col-form-label text-left">엑셀파일</label>
                    <div class="col-4">
                        <input type="file" id="excelFileInput" class="form-control" accept=".xlsx,.xls" style="height:35px; font-size:14px;">
                    </div>
                    <div class="col-2">
                        <button type="button" class="btn btn-outline-primary" onClick="fn_ExcelPreview()">미리보기 <i class="fas fa-eye"></i></button>
                    </div>
                    <div class="col-2">
                        <span id="excelRowCount" class="badge badge-info" style="font-size:14px; line-height:35px;"></span>
                    </div>
                </div>
                <!-- 컬럼 매핑 영역 -->
                <div id="excelMappingZone" class="form-group row mb-2" style="display:none;">
                    <div class="col-12">
                        <div class="alert alert-info p-2 mb-2" style="font-size:13px;">
                            엑셀 헤더를 DB 컬럼에 매핑하세요. 자동매핑 후 필요시 수정 가능합니다.
                        </div>
                        <div id="mappingFields" class="form-row" style="flex-wrap:wrap;"></div>
                    </div>
                </div>
                <!-- 미리보기 테이블 -->
                <div style="width: 100%; overflow-x: auto;">
                    <table id="excelPreviewTable" class="display nowrap stripe hover cell-border compact" style="width:100%; font-size:12px;">
                    </table>
                </div>
	          </div>
	          <div class="modal-footer">
	          </div>
	        </div>
	      </div>
	    </div>
        <!-- ============================================================== -->
        <!-- Excel Upload modal end -->
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
      //Form마다 조회 조건 변경 종료
      
      // 초기값 설정
      var mainFocus = 'findData'; // Main 화면 focus값 설정, Modal은 따로 Focus 맞춤
      var edit_Data = null;
      var dataTable = new DataTable();
      dataTable.clear();
      
      <!-- ============================================================== -->
      <!-- 공통코드 Setting Start -->
      <!-- ============================================================== -->
      var list_flag = ['Z'];                                   // 대표코드, ['Z','X','Y'] 여러개 줄 수 있음
      //  list_code, select_id, firstnull는 갯수가 같아야함. firstnull의 마지막이 'N'이면 생략가능, 하지만 쌍으로 맞추는게 좋음 
      var list_code = ['WVALUE'];     // 구분코드 필요한 만큼 선언해서 사용
      var select_id = ['cateCode'];     // 구분코드 데이터 담길 Select (ComboBox ID) 
      var firstnull = ['Y'];                              // Y 첫번째 Null,이후 Data 담김 / N 바로 Data 담김 
      <!-- ============================================================== -->
      <!-- 공통코드 Setting End -->
      <!-- ============================================================== -->
      var format_convert = ['startDt','endDt'] ; //날자에서 '-' '/' 제외설정   
      
      <!-- ============================================================== -->
      <!-- Table Setting Start -->
      <!-- ============================================================== -->
      var gridColums = [];
      var btm_Scroll = true;         // 하단 scroll여부 - scrollX
      var auto_Width = true;         // 열 너비 자동 계산 - autoWidth
      var page_Hight = 700;          // Page 길이보다 Data가 많으면 자동 scroll - scrollY
      var p_Collapse = false;        // Page 길이까지 auto size - scrollCollapse
      
      var datWaiting = true;         // Data 가져오는 동안 대기상태 Waiting 표시 여부
      var page_Navig = true;         // 페이지 네비게이션 표시여부 
      var hd_Sorting = true;         // Head 정렬(asc,desc) 표시여부
      var info_Count = true;         // 총건수 대비 현재 건수 보기 표시여부 
      var searchShow = true;         // 검색창 Show/Hide 표시여부
      var showButton = true;         // Button (복사, 엑셀, 출력)) 표시여부
      
      var copyBtn_nm = '복사.';
      var copy_Title = 'Copy Title';      
      var excelBtnnm = '엑셀.';
      var excelTitle = 'Excel Title';
      var excelFName = "파일명_";      // Excel Download시 파일명
      var printBtnnm = '출력.';
      var printTitle = 'Print Title';
        
      var find_Enter = false;        // 검색창 바로바로 찾기(false) / Enter후 찾기(true)
      var row_Select = true;         // Page내 Data 선택시 선택 row 색상 표시
      
      var colPadding = '0.2px'         // 행 높이 간격 설정
      var data_Count = [30 , 50, 70, 100, 150, 200];  // Data 보기 설정
      var defaultCnt = 32;                      // Data Default 갯수
      
      
      //  DataTable Columns 정의, c_Head_Set, columnsSet갯수는 항상 같아야함.
      var c_Head_Set = ['시작일','분류번호','분류순서','분류명','구분(점수/율)','지표시작','지표종료','표준화점수' ,'가중치','종료일'  ];
      var columnsSet = [  // data 컬럼 id는 반드시 DTO의 컬럼,Modal id는 일치해야 함 (조회시)
                       // name 컬럼 id는 반드시 DTO의 컬럼 일치해야 함 (수정,삭제시), primaryKey로 수정, 삭제함.
                       // dt-body-center, dt-body-left, dt-body-right                       
                       // getFormat 사용시 
                       { data: 'startDt',    visible: true,  className: 'dt-body-center', width: '100px',  name: 'keystartDt', primaryKey: true,
                                render: function(data, type, row) {
                              if (type === 'display') {
                                 return getFormat(data,'d1')
                               }
                               return data;
                           }
                       },
                       { data: 'cateCode',   visible: true,  className: 'dt-body-center' , width: '50px',  name: 'keycateCode', primaryKey: true },
                       { data: 'orderSeq',   visible: true,  className: 'dt-body-center' , width: '50px',  name: 'keyorderSeq', primaryKey: true },
                       { data: 'wevalueNm',  visible: true,  className: 'dt-body-left'   , width: '300px',  },
                       { data: 'calGubun',  visible: true,   className: 'dt-body-center' , width: '100px',  },
                       { data: 'startIndi',   visible: true,  className: 'dt-body-center', width: '100px',  },                       
                       { data: 'endIndi'  ,   visible: true,  className: 'dt-body-center', width: '100px',  },
                       { data: 'stdScore' ,   visible: true,  className: 'dt-body-center', width: '100px',  },
                       { data: 'weValue'  ,   visible: true,  className: 'dt-body-center', width: '100px',  } ,
                       { data: 'endDt'    ,   visible: true,  className: 'dt-body-center', width: '100px',    
                           render: function(data, type, row) {
                              if (type === 'display') {
                                 return getFormat(data,'d1')
                               }
                               return data;
                           }
                       }
                   ];
      
      var s_CheckBox = true;                        // CheckBox 표시 여부
        var s_AutoNums = true;                      // 자동순번 표시 여부
        
      // 초기 data Sort,  없으면 []
      var muiltSorts = [
                         ['startDt', 'asc' ],       // 오름차순 정렬            
                         ['cateCode', 'asc' ],      // 오름차순 정렬
                        ['wevalueNm', 'desc']     // 내림차순 정렬
                     ];
        // Sort여부 표시를 일부만 할 때 개별 id, ** 전체 적용은 '_all'하면 됩니다. ** 전체 적용 안함은 []                     
      var showSortNo = ['startDt','cateCode','wevalueNm'];                    
      // Columns 숨김 columnsSet -> visible로 대체함 hideColums 보다 먼제 처리됨 ( visible를 선언하지 않으면 hideColums컬럼 적용됨 )   
      var hideColums = [];             // 없으면 []; 일부 컬럼 숨길때      
      var txt_Markln = 20;                                    // 컬럼의 글자수가 설정값보다 크면, 다음은 ...로 표시함
      // 글자수 제한표시를 일부만 할 때 개별 id, ** 전체 적용은 '_all'하면 됩니다. ** 전체 적용 안함은 []
      var markColums = ['wevalueNm'];
      var mousePoint = 'pointer';                             // row 선택시 Mouse모양
      <!-- ============================================================== -->
      <!-- Table Setting End -->
      <!-- ============================================================== -->
      
      window.onload = function() { 
         find_Check();
          comm_Check();
          start_date();
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
        //선택된 코드에 명칭으로 명칭에 뿌려줄때 
       document.addEventListener("DOMContentLoaded", function () {
           const cateCode = document.getElementById("cateCode");
           const wevalueNm = document.getElementById("wevalueNm");

           cateCode.addEventListener("change", function () {
               // 선택된 옵션의 텍스트(명칭)를 가져와서 wevalueNm에 입력
               wevalueNm.value = cateCode.selectedOptions[0].text;
           });
       });
       
      </script>
      <!-- ============================================================== -->
      <!-- 화면 Size변경 End -->
      <!-- ============================================================== -->
      
      <!-- ============================================================== -->
      <!-- modal Form 띄우기 Start -->
      <!-- ============================================================== -->
      <script type="text/javascript">
      function modal_key_hidden(flag) {   
           const cateCodeInput      = document.getElementById("cateCode");
           const orderSeqInput      = document.getElementById("orderSeq");
           const startDtInput       = document.getElementById("startDt");

           const inputs = [cateCodeInput, startDtInput,orderSeqInput];
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
           //콤보박스는 READONLY로 안됨 
           if (flag !== 'I') {
               $(cateCodeInput).css("pointer-events", "none").css("background-color", "#e9ecef"); // 비활성화된 느낌의 배경색 적용
           } else {
               $(cateCodeInput).css("pointer-events", "").css("background-color", ""); // 활성화
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
      let startDt = "" ;
      function dataLoad(data, callback, settings) {
          $('#' + wv_tableName.id).on("click", "tr", function () {
              let find = {};
      
              for (let findValue of findValues) {
                  let key = findValue.id === findValue.id;
                  find[key] = findValue.val;
              }
      
              let selectedRowData = $('#' + wv_tableName.id).DataTable().row(this).data(); // 선택한 행 데이터
              startDt = selectedRowData.startDtTwo;
      
              $.ajax({
                  type: "POST",
                  url: "/base/wvalcdList.do",
                  data: { startDt: startDt },
                  dataType: "json",
                  beforeSend: function () {
                      let table = $('#' + tableName.id).DataTable();
                      table.clear().draw(); // 기존 테이블 초기화
                  },
                  success: function (response) {
                      if (response && Object.keys(response).length > 0) {
                          callback(response);
                      } else {
                          callback([]); // 빈 배열 전달
                      }
                  },
                  error: function (jqXHR, textStatus, errorThrown) {
                      callback({
                          data: []
                      });
                  }
              });
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
             cateCode:  { kname: "지표코드", k_req: true, k_spc: true, k_clr: true },
             orderSeq:  { kname: "분류순서", k_req: true },
             startDt:   { kname: "시작일자", k_req: true },
             calGubun:  { kname: "점수율" ,k_req: true},
             wevalueNm: { kname: "명칭", k_req: true },
             startIndi: { kname: "시작지표", k_req: true },
             endIndi:   { kname: "지표종료", k_req: true },
             stdScore:  { kname: "표준화점수", k_req: true },
             weValue:   { kname: "가중치", k_req: true },
             endDt:     { kname: "종료일자"}
          });
          return results;
      }
      //그리드상 데이타생성및 수정 작업
      function newuptData() {
           let newData = {
               cateCode:  $('#cateCode').val(),
              orderSeq:  $('#orderSeq').val(),
              startDt:   $('#startDt').val(), 
              calGubun:  $('#calGubun').val(),
              wevalueNm: $('#wevalueNm').val(),
              startIndi: $('#startIndi').val(),
              endIndi:   $('#endIndi').val(),
              stdScore:  $('#stdScore').val(),
              weValue:   $('#weValue').val(),
              endDt:     $('#endDt').val()
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
                     url: "/base/WvalueInsert.do",
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
                  url: "/base/WvalueUpdate.do",
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
                        url: "/base/WvalueDelete.do",              
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
                        url: "/user/WvalueDelete.do",              
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
         $("#" + modalName.id).modal('hide');
      }
      //권한조건체크 applyAuthControl.js
       document.addEventListener("DOMContentLoaded", function() {
          initWvResultsTable() ;
           applyAuthControl();
       });
       var wvedit_Data = null;
       var wvtmpedit_Data = null;
       var wv_tableName = document.getElementById('wv_tableName');
       var wv_dataTable = new DataTable();
       wv_dataTable.clear();

       function initWvResultsTable() {
           if (!$.fn.DataTable.isDataTable('#' + wv_tableName.id)) {
               wv_dataTable = $('#' + wv_tableName.id).DataTable({
                   responsive:   false,
                   autoWidth:    false,
                   ordering:     false,
                   searching:    false,
                   lengthChange: true,
                   info:         false,
                   paging:       false,
                   scrollY:      "700px",
                   fixedHeader:  true,
                   search: {
                       return:   false,
                   },
                   rowCallback: function (row, data, index) {
                       $(row).find('td').css('padding', colPadding);
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
                       paginate: {
                           next: "다음",
                           previous: "이전"
                       },
                   },
                   columns: [
                       {
                           title: "적용일자",
                           data: "startDtTwo",
                           className: "text-center",
                           render: function (data, type, row) {
                               if (type === 'display') {
                                   return getFormat(data, 'd1');
                               }
                               return data;
                           }
                       },
                   ],
                   ajax: wvLoad,
               });

             /* 싱글 선택 start(선택표시) */
             if (row_Select) {
                wv_dataTable.on('click', 'tbody tr', (e) => {
                     let classList = e.currentTarget.classList;
                  
                     if (!classList.contains('selected')) {
                        wv_dataTable.rows('.selected').nodes().each((row) => row.classList.remove('selected'));
                         classList.add('selected');
                     } 
                 });    
             }
           }
       }

	    function wvLoad(data, callback, settings) {
	        $.ajax({
	            type: "POST",
	            url: "/base/selwvalcdList.do",
	            data: find,
	            dataType: "json",
	            beforeSend: function () {
	                // 요청 전 처리 (필요 시 작성)
	            },
	            success: function (response) {
	                if (response && Object.keys(response).length > 0) {
	                    callback(response);
	                } else {
	                    callback({ data: [] }); // 빈 데이터 셋 반환
	                }
	            },
	            error: function (jqXHR, textStatus, errorThrown) {
	                callback({ data: [] }); // 에러 시 빈 데이터 반환
	            }
	        });
	    }
	    //현재년도롤 선텍되게 
		function start_date() {
		    const yearSelect = document.getElementById('copyDate');
		    const monthSelect = document.getElementById('copyMonth');
		    const daySelect = document.getElementById('copyDay');
		    const currentDate = new Date();
		    const currentYear = currentDate.getFullYear();
		    const currentMonth = currentDate.getMonth() + 1; // 0-based index
		    const currentDay = currentDate.getDate();
		
		    // 연도 추가
		    for (let year = currentYear - 2; year <= currentYear + 3; year++) {
		        const option = document.createElement('option');
		        option.value = year;
		        option.textContent = year;
		        if (year === currentYear) option.selected = true;
		        yearSelect.appendChild(option);
		    }
		
		 // 월 추가 (1~12)
		    for (let month = 1; month <= 12; month++) {
		        const value = month.toString().padStart(2, '0');
		        const option = document.createElement('option');
		        option.value = value;
		        option.textContent = value;
		        if (month === currentMonth) option.selected = true;
		        monthSelect.appendChild(option);
		    }

		    // 일 추가 (1~31)
			function updateDays() {
			    const year = parseInt(yearSelect.value);
			    const month = parseInt(monthSelect.value);
			    const daysInMonth = new Date(year, month, 0).getDate();
			
			    daySelect.innerHTML = ''; // 기존 옵션 초기화
			    for (let day = 1; day <= daysInMonth; day++) {
			        const value = day.toString().padStart(2, '0');
			        const option = document.createElement('option');
			        option.value = value;
			        option.textContent = value;
			        if (day === 1) option.selected = true; // 항상 1일이 선택되도록 설정
			        daySelect.appendChild(option);
			    }
			}
		
		    // 초기 일 설정
		    updateDays();
		
		    // 연도나 월이 변경되면 일자 업데이트
		    yearSelect.addEventListener('change', updateDays);
		    monthSelect.addEventListener('change', updateDays);
		}
		function fn_CopyData() {
			Swal.fire({
			    title: '복사진행여부',
			    text: '복사 진행 하시겠습니까 ?',
			    icon: 'question',
			    showCancelButton: true,
			    confirmButtonText: '예',
			    cancelButtonText: '아니오',
			    customClass: {
			        popup: 'small-swal'
			    }
			}).then((result) => {
			    // 사용자가 '예' 버튼을 클릭한 경우
			    if (result.isConfirmed) {
			        const year = document.getElementById("copyDate").value;
			        const month = document.getElementById("copyMonth").value.padStart(2, '0');
			        const day = document.getElementById("copyDay").value.padStart(2, '0');
			        const newStartDt = year + month + day;

			        let regUser = getCookie("s_userid") || "";
			        let updUser = regUser;
			        let regIp = getCookie("s_connip") || "";
			        let updIp = regIp;

			        // JSON 배열 생성
			        const postData = [{
			            startDt: startDt,
			            newStartDt: newStartDt,
			            regUser: regUser,
			            updUser: updUser,
			            regIp: regIp,
			            updIp: updIp
			        }];

			        $.ajax({
			            type: "POST",
			            url: "/base/copwvalcdList.do",
			            data: JSON.stringify(postData),
			            contentType: "application/json",  // JSON으로 전송
			            dataType: "text", // 서버에서 문자열을 반환하는 경우
			            beforeSend: function () {
			                let table = $('#' + tableName.id).DataTable(); // ❗ tableName.id 정의 필요
			                table.clear().draw();
			            },
			            success: function (response) {
			                messageBox("1", "<h6> 정상적으로 업데이트되었습니다. </h6>", mainFocus, "", "");
		                    // ✅ 복사 후 데이터 다시 불러오기
		                    location.reload();
			            },
			            error: function (jqXHR, textStatus, errorThrown) {
			                console.error("에러 발생:", textStatus, errorThrown);
			                alert("오류 발생: " + jqXHR.responseText);
			            }
			        });
			    }
			}); // 🔚 Swal.then 끝
		}
		</script>
		<!-- ============================================================== -->
		<!-- 기타 정보 End -->
		<!-- ============================================================== -->

		<!-- ============================================================== -->
		<!-- 엑셀 업로드 Start -->
		<!-- ============================================================== -->
		<script type="text/javascript">
		// 엑셀 업로드 관련 변수
		var excelParsedData = [];    // 파싱된 엑셀 데이터
		var excelHeaders = [];       // 엑셀 헤더
		var excelPreviewDT = null;   // 미리보기 DataTable
		var excelColumnMap = {};     // 엑셀헤더 → DB컬럼 매핑
		var excelCachedFile = null;  // 파일 캐시
		var excelModalClosable = false;
		var excelCheckedSet = new Set();

		// ============================================
		// 엑셀 → DB 데이터 포맷 변환 함수들
		// ============================================

		// 엑셀 날짜 → yyyymmdd 변환
		function excelDateToStr(val) {
			if (!val && val !== 0) return '';
			var s = String(val).trim();
			if (!s) return '';

			function toFullYear(yy) {
				var n = parseInt(yy, 10);
				return (n <= 49 ? 2000 + n : 1900 + n);
			}

			// 숫자만(엑셀 시리얼 날짜)
			if (/^\d{5,}$/.test(s) || /^\d+\.\d+$/.test(s)) {
				var num = parseFloat(s);
				if (num > 1 && num < 200000) {
					var utcDays = Math.floor(num - 25569);
					var utcValue = utcDays * 86400 * 1000;
					var d = new Date(utcValue);
					var y = d.getUTCFullYear();
					var m = ('0' + (d.getUTCMonth() + 1)).slice(-2);
					var dd = ('0' + d.getUTCDate()).slice(-2);
					return y + m + dd;
				}
			}

			// yyyy-mm-dd, yyyy/mm/dd
			var match = s.match(/^(\d{4})[\-\/\.](\d{1,2})[\-\/\.](\d{1,2})/);
			if (match) {
				return match[1] + ('0' + match[2]).slice(-2) + ('0' + match[3]).slice(-2);
			}

			// yyyymmdd
			var match2 = s.match(/^(\d{4})(\d{2})(\d{2})$/);
			if (match2) {
				return match2[1] + match2[2] + match2[3];
			}

			// M/D/YYYY
			var match3 = s.match(/^(\d{1,2})[\-\/\.](\d{1,2})[\-\/\.](\d{4})$/);
			if (match3) {
				return match3[3] + ('0' + match3[1]).slice(-2) + ('0' + match3[2]).slice(-2);
			}

			// M/D/YY
			var match4 = s.match(/^(\d{1,2})[\-\/\.](\d{1,2})[\-\/\.](\d{2})$/);
			if (match4) {
				var fullY = toFullYear(match4[3]);
				return fullY + ('0' + match4[1]).slice(-2) + ('0' + match4[2]).slice(-2);
			}

			return s;
		}

		// 숫자값 정리
		function toNumericStr(val) {
			if (!val && val !== 0) return '0';
			var s = String(val).trim();
			if (!s) return '0';
			s = s.replace(/,/g, '');
			if (isNaN(s)) return '0';
			return s;
		}

		// 소수점 숫자값
		function toDecimalStr(val) {
			if (!val && val !== 0) return '0';
			var s = String(val).trim();
			if (!s) return '0';
			s = s.replace(/,/g, '');
			if (isNaN(s)) return '0';
			return s;
		}

		// 점수구분 변환 (점수→1, 율→2)
		function toCalGubun(val) {
			if (!val && val !== 0) return '1';
			var s = String(val).trim();
			if (!s) return '1';
			if (s === '1' || s === '2') return s;
			if (s.indexOf('점수') !== -1 || s.indexOf('접수') !== -1) return '1';
			if (s.indexOf('율') !== -1 || s.indexOf('%') !== -1 || s.indexOf('률') !== -1) return '2';
			return '1';
		}

		// 문자열 정리
		function toStr(val) {
			if (!val && val !== 0) return '';
			return String(val).trim();
		}

		// 행 전체를 DB 포맷으로 변환
		function convertRowToDbFormat(row) {
			return {
				cateCode:  toStr(row.cateCode),
				orderSeq:  toNumericStr(row.orderSeq),
				startDt:   excelDateToStr(row.startDt),
				jobSeq:    '1',
				endDt:     row.endDt ? excelDateToStr(row.endDt) : '29991231',
				calGubun:  toCalGubun(row.calGubun),
				wevalueNm: toStr(row.wevalueNm),
				startIndi: toDecimalStr(row.startIndi),
				endIndi:   toDecimalStr(row.endIndi),
				stdScore:  toDecimalStr(row.stdScore),
				weValue:   toDecimalStr(row.weValue),
				applRate:  toDecimalStr(row.applRate) || '100.00',
				actionYn:  'Y'
			};
		}

		// DB 컬럼 정의 (매핑 대상)
		var dbColumns = [
			{ key: 'cateCode',  label: '분류코드',   required: true },
			{ key: 'orderSeq',  label: '분류순서',   required: true },
			{ key: 'startDt',   label: '시작일자',   required: true },
			{ key: 'endDt',     label: '종료일자',   required: false },
			{ key: 'calGubun',  label: '점수구분(1.점수/2.율)', required: false },
			{ key: 'wevalueNm', label: '분류명칭',   required: true },
			{ key: 'startIndi', label: '시작지표',   required: false },
			{ key: 'endIndi',   label: '종료지표',   required: false },
			{ key: 'stdScore',  label: '표준화점수', required: false },
			{ key: 'weValue',   label: '가중치',     required: false },
			{ key: 'applRate',  label: '적용율',     required: false }
		];

		// 자동매핑 키워드
		var autoMapKeywords = {
			'cateCode':  ['분류코드','분류번호','지표코드','코드','cate_code','catecode','code'],
			'orderSeq':  ['분류순서','순서','order_seq','orderseq','seq'],
			'startDt':   ['시작일자','시작일','적용시작','start_dt','startdt'],
			'endDt':     ['종료일자','종료일','적용종료','end_dt','enddt'],
			'calGubun':  ['점수구분','계산방식','계산구분','cal_gubun','calgubun','구분','점수율','점수/율'],
			'wevalueNm': ['분류명','명칭','지표명','지표명칭','wevalue_nm','wevaluenm','name'],
			'startIndi': ['시작지표','지표시작','start_indi','startindi'],
			'endIndi':   ['종료지표','지표종료','end_indi','endindi'],
			'stdScore':  ['표준화점수','표준점수','std_score','stdscore'],
			'weValue':   ['가중치','we_value','wevalue','weight'],
			'applRate':  ['적용율','적용률','appl_rate','applrate','rate']
		};

		// 엑셀 업로드 모달 열기
		function excelUpload_Open() {
			// 초기화
			document.getElementById('excelFileInput').value = '';
			document.getElementById('excelRowCount').textContent = '';
			document.getElementById('excelMappingZone').style.display = 'none';
			document.getElementById('mappingFields').innerHTML = '';
			if (excelPreviewDT) {
				excelPreviewDT.destroy();
				$('#excelPreviewTable').empty();
				excelPreviewDT = null;
			}
			excelParsedData = [];
			excelHeaders = [];
			excelColumnMap = {};

			excelModalClosable = false;
			$('#excelUploadModal').off('hide.bs.modal.lock').on('hide.bs.modal.lock', function(e) {
				if (!excelModalClosable) { e.preventDefault(); e.stopImmediatePropagation(); }
			});
			$("#excelUploadModal").modal('show');
		}

		// 엑셀 업로드 모달 닫기
		function excelUpload_Close() {
			if (excelPreviewDT) {
				excelPreviewDT.destroy();
				$('#excelPreviewTable').empty();
				excelPreviewDT = null;
			}
			excelParsedData = [];
			excelCachedFile = null;
			excelModalClosable = true;
			$("#excelUploadModal").modal('hide');
		}

		// 엑셀 미리보기
		function fn_ExcelPreview() {
			var fileInput = document.getElementById('excelFileInput');
			if (!fileInput.files || fileInput.files.length === 0) {
				Swal.fire({ title: '확인', text: '엑셀 파일을 선택하세요.', icon: 'warning', timer: 1500, showConfirmButton: false, customClass: { popup: 'small-swal' } });
				return;
			}

			var file = fileInput.files[0];
			var headerRowNum = parseInt(document.getElementById('excelHeaderRow').value) || 3;

			var fileKey = file.name + '_' + file.size + '_' + file.lastModified + '_h' + headerRowNum;
			if (excelCachedFile === fileKey && excelParsedData.length > 0) {
				autoMapColumns();
				buildMappingUI();
				buildPreviewTable();
				return;
			}
			excelCachedFile = fileKey;

			Swal.fire({
				title: '엑셀 읽는 중...',
				html: '<div id="excelProgress" style="font-size:14px;">파일 읽기 준비 중...</div>' +
				      '<div class="progress mt-2" style="height:20px;">' +
				      '<div id="excelProgressBar" class="progress-bar progress-bar-striped progress-bar-animated bg-info" style="width:0%">0%</div></div>',
				allowOutsideClick: false,
				allowEscapeKey: false,
				showConfirmButton: false,
				customClass: { popup: 'small-swal' }
			});

			var reader = new FileReader();
			reader.onload = function(e) {
				$('#excelProgress').text('엑셀 파일 파싱 중...');
				$('#excelProgressBar').css({ 'width': '10%', 'transition': 'width 8s ease-out' }).text('파싱 중...');
				requestAnimationFrame(function() { $('#excelProgressBar').css('width', '45%'); });

				setTimeout(function() {
					try {
						var workbook = XLSX.read(new Uint8Array(e.target.result), { type: 'array', dense: true });

						var ws = null;
						var usedSheetName = '';

						for (var si = 0; si < workbook.SheetNames.length; si++) {
							var tmpWs = workbook.Sheets[workbook.SheetNames[si]];
							if (tmpWs && tmpWs['!ref']) {
								ws = tmpWs;
								usedSheetName = workbook.SheetNames[si];
								break;
							}
						}
						if (!ws) {
							for (var si2 = 0; si2 < workbook.SheetNames.length; si2++) {
								var tmpWs2 = workbook.Sheets[workbook.SheetNames[si2]];
								if (tmpWs2) {
									var keys = Object.keys(tmpWs2).filter(function(k){ return k[0] !== '!'; });
									if (keys.length > 0) {
										ws = tmpWs2;
										usedSheetName = workbook.SheetNames[si2];
										break;
									}
								}
							}
						}
						if (!ws) {
							for (var si3 = 0; si3 < workbook.SheetNames.length; si3++) {
								var tmpWs3 = workbook.Sheets[workbook.SheetNames[si3]];
								if (tmpWs3 && tmpWs3['!data'] && tmpWs3['!data'].length > 0) {
									ws = tmpWs3;
									usedSheetName = workbook.SheetNames[si3];
									ws['!ref'] = XLSX.utils.encode_range({ s: { r: 0, c: 0 }, e: { r: ws['!data'].length - 1, c: (ws['!data'][0] || []).length - 1 } });
									break;
								}
							}
						}
						if (!ws) {
							Swal.close();
							Swal.fire({ title: '확인', text: '엑셀에 데이터가 없습니다.', icon: 'warning', timer: 2000, showConfirmButton: true, customClass: { popup: 'small-swal' } });
							return;
						}

						$('#excelProgressBar').css({ 'transition': 'none', 'width': '50%' }).text('50%');
						$('#excelProgress').text(usedSheetName + ' 시트 변환 중...');

						var jsonData = XLSX.utils.sheet_to_json(ws, { header: 1, defval: '' });
						ws = null; workbook = null;

						// 헤더 행 위치 (0-based index)
						var headerIdx = headerRowNum - 1;
						if (headerIdx >= jsonData.length) {
							Swal.close();
							Swal.fire({ title: '확인', text: '헤더위치(' + headerRowNum + '행)가 데이터 범위를 초과합니다.', icon: 'warning', timer: 2000, showConfirmButton: true, customClass: { popup: 'small-swal' } });
							return;
						}
						// 헤더 행부터 사용, 그 이전 행은 스킵
						var filtered = [jsonData[headerIdx]];
						for (var i = headerIdx + 1; i < jsonData.length; i++) {
							var row = jsonData[i];
							for (var c = 0; c < row.length; c++) {
								if (row[c] !== '' && row[c] !== null && row[c] !== undefined) { filtered.push(row); break; }
							}
						}
						jsonData = null;
						processJsonData(filtered);
					} catch(ex) {
						Swal.close();
						Swal.fire({ title: '오류', text: '파싱 실패: ' + ex.message, icon: 'error', showConfirmButton: true, customClass: { popup: 'small-swal' } });
					}
				}, 100);
			};
			reader.readAsArrayBuffer(file);
		}

		// 파싱된 jsonData를 excelParsedData로 변환
		function processJsonData(jsonData) {
			if (jsonData.length < 2) {
				Swal.close();
				Swal.fire({ title: '확인', text: '데이터가 부족합니다. (최소 헤더 + 1행)', icon: 'warning', timer: 2000, showConfirmButton: false, customClass: { popup: 'small-swal' } });
				return;
			}

			$('#excelProgress').text('데이터 변환 중... (총 ' + (jsonData.length - 1) + '건)');
			$('#excelProgressBar').css('width', '50%').text('50%');

			excelHeaders = jsonData[0].map(function(h) { return String(h).trim().replace(/[\r\n]+/g, ''); });
			excelParsedData = [];
			var totalData = jsonData.length - 1;

			var chunkSize = 5000;
			var chunkIdx = 0;

			function processChunk() {
				var start = chunkIdx * chunkSize + 1;
				var end = Math.min(start + chunkSize, jsonData.length);

				for (var i = start; i < end; i++) {
					var row = {};
					for (var j = 0; j < excelHeaders.length; j++) {
						var cellVal = jsonData[i][j];
						row[excelHeaders[j]] = (cellVal !== undefined && cellVal !== null) ? String(cellVal).trim() : '';
					}
					excelParsedData.push(row);
				}

				var pct = Math.round(50 + (end / jsonData.length) * 40);
				$('#excelProgressBar').css('width', pct + '%').text(pct + '%');
				$('#excelProgress').text('데이터 변환 중... (' + excelParsedData.length + ' / ' + totalData + '건)');

				chunkIdx++;
				if (end < jsonData.length) {
					setTimeout(processChunk, 0);
				} else {
					jsonData = null;
					finishPreview();
				}
			}

			setTimeout(processChunk, 0);
		}

		// 미리보기 완료 처리
		function finishPreview() {
			$('#excelProgress').text('컬럼 자동 매핑 중...');
			$('#excelProgressBar').css('width', '92%').text('92%');

			autoMapColumns();
			buildMappingUI();

			$('#excelProgress').text('미리보기 테이블 생성 중...');
			$('#excelProgressBar').css('width', '96%').text('96%');

			setTimeout(function() {
				buildPreviewTable();
				$('#excelProgressBar').css('width', '100%').text('100%');
				$('#excelProgress').text('완료! 총 ' + excelParsedData.length + '건 로드됨');
				setTimeout(function() { Swal.close(); }, 500);
			}, 0);
		}

		// 자동 매핑
		function autoMapColumns() {
			excelColumnMap = {};
			// No 컬럼 감지 (autoMap 전에 미리 판별)
			excelNoColumnName = null;
			for (var ni = 0; ni < excelHeaders.length; ni++) {
				var nh = excelHeaders[ni].toLowerCase().replace(/[\s]/g, '');
				if (nh === 'no' || nh === 'no.' || nh === '번호' || nh === '순번') {
					excelNoColumnName = excelHeaders[ni];
					break;
				}
			}
			for (var i = 0; i < excelHeaders.length; i++) {
				// No 컬럼은 매핑 대상에서 제외
				if (excelNoColumnName && excelHeaders[i] === excelNoColumnName) continue;
				var header = excelHeaders[i].toLowerCase().replace(/[\s_\-\/]/g, '');
				for (var dbKey in autoMapKeywords) {
					var keywords = autoMapKeywords[dbKey];
					for (var k = 0; k < keywords.length; k++) {
						var kw = keywords[k].toLowerCase().replace(/[\s_\-\/]/g, '');
						if (header.indexOf(kw) !== -1 || kw.indexOf(header) !== -1) {
							if (!excelColumnMap[dbKey]) {
								excelColumnMap[dbKey] = excelHeaders[i];
							}
							break;
						}
					}
				}
			}
		}

		// 매핑 UI 생성
		function buildMappingUI() {
			var zone = document.getElementById('mappingFields');
			zone.innerHTML = '';
			document.getElementById('excelMappingZone').style.display = '';

			for (var i = 0; i < dbColumns.length; i++) {
				var col = dbColumns[i];
				var div = document.createElement('div');
				div.className = 'mb-1';
				div.style.cssText = 'flex: 0 0 14.28%; max-width: 14.28%; padding: 2px 4px;';

				var label = document.createElement('label');
				label.style.fontSize = '12px';
				label.style.marginBottom = '0';
				label.textContent = col.label + (col.required ? ' *' : '');
				if (col.required) label.style.color = '#dc3545';

				var select = document.createElement('select');
				select.className = 'form-control form-control-sm';
				select.id = 'map_' + col.key;
				select.style.fontSize = '11px';
				select.innerHTML = '<option value="">-- 미매핑 --</option>';
				for (var j = 0; j < excelHeaders.length; j++) {
					// No 컬럼은 매핑 대상에서 제외
					if (excelNoColumnName && excelHeaders[j] === excelNoColumnName) continue;
					var selected = (excelColumnMap[col.key] === excelHeaders[j]) ? ' selected' : '';
					select.innerHTML += '<option value="' + excelHeaders[j] + '"' + selected + '>' + excelHeaders[j] + '</option>';
				}
				select.style.backgroundColor = select.value ? '' : '#ffe0e0';
				select.onchange = function() { this.style.backgroundColor = this.value ? '' : '#ffe0e0'; };

				div.appendChild(label);
				div.appendChild(select);
				zone.appendChild(div);
			}
		}

		// 현재 매핑 읽기
		function getCurrentMapping() {
			var map = {};
			for (var i = 0; i < dbColumns.length; i++) {
				var sel = document.getElementById('map_' + dbColumns[i].key);
				if (sel && sel.value) {
					map[dbColumns[i].key] = sel.value;
				}
			}
			return map;
		}

		// 미리보기 테이블 생성
		// 엑셀 No 컬럼 여부 확인 (대소문자, 공백 무시)
		var excelNoColumnName = null;

		function buildPreviewTable() {
			if (excelPreviewDT) {
				excelPreviewDT.destroy();
				$('#excelPreviewTable').empty();
				excelPreviewDT = null;
			}

			// 엑셀에 No 컬럼이 있는지 감지
			excelNoColumnName = null;
			for (var i = 0; i < excelHeaders.length; i++) {
				var h = excelHeaders[i].toLowerCase().replace(/[\s]/g, '');
				if (h === 'no' || h === 'no.' || h === '번호' || h === '순번') {
					excelNoColumnName = excelHeaders[i];
					break;
				}
			}

			var previewCols = [
				{ data: null, title: '<input type="checkbox" id="excelSelectAll">', orderable: false, searchable: false, className: 'dt-body-center', width: '30px',
				  render: function(data, type, row, meta) {
					return '<input type="checkbox" class="excel-chk" data-idx="' + meta.row + '">';
				  }
				},
				{ data: null, title: 'No', orderable: false, className: 'dt-body-center', width: '40px',
				  render: function(data, type, row, meta) { return meta.row + 1; }
				}
			];

			for (var i = 0; i < excelHeaders.length; i++) {
				// 엑셀 No 컬럼은 자동순번으로 대체하므로 그리드에서 제외
				if (excelHeaders[i] === excelNoColumnName) continue;

				(function(header) {
					var hLower = header.toLowerCase().replace(/[\s_\-\/]/g, '');
					var isNameCol = (hLower.indexOf('분류명') !== -1 || hLower.indexOf('명칭') !== -1 || hLower.indexOf('지표명') !== -1 || hLower === 'wevaluenm' || hLower === 'name');
					var colWidth = isNameCol ? '350px' : undefined;
					previewCols.push({
						data: header,
						title: header,
						defaultContent: '',
						className: 'dt-body-left',
						width: colWidth,
						render: function(data, type, row, meta) {
							if (type === 'display') {
								var val = (data !== null && data !== undefined) ? String(data) : '';
								var safeVal = $('<span>').text(val).html();
								var inputStyle = 'width:100%; border:1px solid #ddd; padding:1px 3px; font-size:12px; box-sizing:border-box; background:#fff;';
								if (isNameCol) inputStyle += ' min-width:300px;';
								return '<input type="text" class="excel-edit-input" data-header="' + $('<span>').text(header).html() + '" value="' + safeVal + '" style="' + inputStyle + '">';
							}
							return data;
						}
					});
				})(excelHeaders[i]);
			}

			var tableData = [];
			for (var i = 0; i < excelParsedData.length; i++) {
				var row = $.extend({}, excelParsedData[i]);
				row._rowIdx = i;
				tableData.push(row);
			}

			excelPreviewDT = $('#excelPreviewTable').DataTable({
				data: tableData,
				columns: previewCols,
				scrollX: true,
				scrollY: 350,
				paging: true,
				pageLength: 50,
				lengthMenu: [50, 100, 200, 500],
				ordering: true,
				searching: true,
				info: true,
				deferRender: true,
				processing: true,
				language: {
					search: "검색 : ",
					emptyTable: "데이터가 없습니다.",
					lengthMenu: "_MENU_",
					info: "현재 _START_ - _END_ / 총 _TOTAL_건",
					infoEmpty: "데이터 없음",
					processing: "처리 중...",
					paginate: { "next": "다음", "previous": "이전" }
				},
				rowCallback: function(row, data, index) {
					$(row).find('td').css('padding', '1px 4px');
				}
			});

			document.getElementById('excelRowCount').textContent = '총 ' + tableData.length + '건';

			excelCheckedSet = new Set();

			$('#excelSelectAll').off('click').on('click', function() {
				var checked = this.checked;
				if (checked) {
					for (var i = 0; i < tableData.length; i++) excelCheckedSet.add(i);
				} else {
					excelCheckedSet.clear();
				}
				$('.excel-chk').each(function() {
					$(this).prop('checked', checked);
				});
			});

			$('#excelPreviewTable tbody').off('change', '.excel-chk').on('change', '.excel-chk', function() {
				var idx = $(this).data('idx');
				if (this.checked) {
					excelCheckedSet.add(idx);
				} else {
					excelCheckedSet.delete(idx);
					$('#excelSelectAll').prop('checked', false);
				}
				if (excelCheckedSet.size === tableData.length) {
					$('#excelSelectAll').prop('checked', true);
				}
			});

			excelPreviewDT.on('draw', function() {
				$('.excel-chk').each(function() {
					var idx = $(this).data('idx');
					$(this).prop('checked', excelCheckedSet.has(idx));
				});
			});

			// 셀 편집 시 DataTable 내부 데이터 동기화
			$('#excelPreviewTable tbody').off('change', '.excel-edit-input').on('change', '.excel-edit-input', function() {
				var $input = $(this);
				var $td = $input.closest('td');
				var $tr = $input.closest('tr');
				var rowData = excelPreviewDT.row($tr).data();
				var header = $input.data('header');
				if (rowData && header) {
					rowData[header] = $input.val();
					// 원본 데이터도 동기화
					var origIdx = rowData._rowIdx;
					if (origIdx !== undefined && excelParsedData[origIdx]) {
						excelParsedData[origIdx][header] = $input.val();
					}
				}
			});
		}

		// 전체 저장
		function fn_ExcelSaveAll() {
			if (!excelPreviewDT) {
				Swal.fire({ title: '확인', text: '먼저 미리보기를 실행하세요.', icon: 'warning', timer: 1500, showConfirmButton: false, customClass: { popup: 'small-swal' } });
				return;
			}
			var totalCount = excelPreviewDT.rows().count();
			if (totalCount === 0) {
				Swal.fire({ title: '확인', text: '저장할 데이터가 없습니다.', icon: 'warning', timer: 1500, showConfirmButton: false, customClass: { popup: 'small-swal' } });
				return;
			}
			Swal.fire({
				title: '전체저장 확인',
				text: '총 ' + totalCount + '건을 전체 저장하시겠습니까?',
				icon: 'question',
				showCancelButton: true,
				confirmButtonText: '예',
				cancelButtonText: '아니오',
				customClass: { popup: 'small-swal' }
			}).then(function(result) {
				if (result.isConfirmed) {
					for (var i = 0; i < excelPreviewDT.rows().count(); i++) excelCheckedSet.add(i);
					$('.excel-chk').prop('checked', true);
					$('#excelSelectAll').prop('checked', true);
					fn_ExcelSaveSelected();
				}
			});
		}

		// 선택된 행 저장
		function fn_ExcelSaveSelected() {
			if (!excelPreviewDT) {
				Swal.fire({ title: '확인', text: '먼저 미리보기를 실행하세요.', icon: 'warning', timer: 1500, showConfirmButton: false, customClass: { popup: 'small-swal' } });
				return;
			}

			var map = getCurrentMapping();

			// 필수 매핑 검증
			if (!map.cateCode) {
				Swal.fire({ title: '확인', text: '분류코드 매핑을 선택하세요.', icon: 'warning', timer: 2000, showConfirmButton: true, customClass: { popup: 'small-swal' } });
				return;
			}
			if (!map.orderSeq) {
				Swal.fire({ title: '확인', text: '분류순서 매핑을 선택하세요.', icon: 'warning', timer: 2000, showConfirmButton: true, customClass: { popup: 'small-swal' } });
				return;
			}
			if (!map.startDt) {
				Swal.fire({ title: '확인', text: '시작일자 매핑을 선택하세요.', icon: 'warning', timer: 2000, showConfirmButton: true, customClass: { popup: 'small-swal' } });
				return;
			}
			if (!map.wevalueNm) {
				Swal.fire({ title: '확인', text: '분류명칭 매핑을 선택하세요.', icon: 'warning', timer: 2000, showConfirmButton: true, customClass: { popup: 'small-swal' } });
				return;
			}

			// 체크된 행 수집
			var selectedRows = [];
			excelCheckedSet.forEach(function(idx) {
				var rowData = excelPreviewDT.row(idx).data();
				if (rowData) selectedRows.push(rowData);
			});

			if (selectedRows.length === 0) {
				Swal.fire({ title: '확인', text: '저장할 행을 선택하세요.', icon: 'warning', timer: 1500, showConfirmButton: false, customClass: { popup: 'small-swal' } });
				return;
			}

			var regUser = getCookie("s_userid") || '';
			var regIp = getCookie("s_connip") || '';
			var convertedRows = [];
			for (var i = 0; i < selectedRows.length; i++) {
				var excelRow = selectedRows[i];
				// 엑셀 원본 → 매핑으로 DB 필드에 대입
				var rawMapped = {};
				for (var dbKey in map) {
					var excelCol = map[dbKey];
					rawMapped[dbKey] = excelRow[excelCol] !== undefined ? excelRow[excelCol] : '';
				}
				// DB 포맷 변환
				var converted = convertRowToDbFormat(rawMapped);
				// 자동 설정 필드
				converted.actionYn = 'Y';
				converted.regUser = regUser;
				converted.regIp   = regIp;
				converted.updUser = regUser;
				converted.updIp   = regIp;

				// 필수값 검증
				if (!converted.cateCode || !converted.orderSeq || !converted.startDt || !converted.wevalueNm) {
					Swal.fire({ title: '확인', text: (i + 1) + '번째 행: 분류코드, 분류순서, 시작일자, 분류명칭 값이 비어있습니다.', icon: 'warning', timer: 3000, showConfirmButton: true, customClass: { popup: 'small-swal' } });
					return;
				}
				convertedRows.push(converted);
			}

			Swal.fire({
				title: '저장확인',
				text: convertedRows.length + '건을 저장하시겠습니까?',
				icon: 'question',
				showCancelButton: true,
				confirmButtonText: '예',
				cancelButtonText: '아니오',
				customClass: { popup: 'small-swal' }
			}).then(function(result) {
				if (result.isConfirmed) {
					fn_BatchSave(convertedRows);
				}
			});
		}

		// 배치 분할 저장 (1000건씩)
		function fn_BatchSave(allRows) {
			var BATCH_SIZE = 1000;
			var totalBatches = Math.ceil(allRows.length / BATCH_SIZE);
			var currentBatch = 0;
			var totalSuccess = 0, totalDup = 0, totalFail = 0;

			Swal.fire({
				title: '저장 중...',
				html: '<div id="saveProgress">0 / ' + allRows.length + '건 처리 중...</div>' +
				      '<div class="progress mt-2"><div id="saveProgressBar" class="progress-bar bg-success" style="width:0%">0%</div></div>',
				allowOutsideClick: false,
				allowEscapeKey: false,
				showConfirmButton: false,
				customClass: { popup: 'small-swal' }
			});

			function sendBatch() {
				var start = currentBatch * BATCH_SIZE;
				var end = Math.min(start + BATCH_SIZE, allRows.length);
				var batchData = allRows.slice(start, end);

				$.ajax({
					type: "POST",
					url: "/base/WvalueExcelInsert.do",
					data: JSON.stringify(batchData),
					contentType: "application/json",
					dataType: "text",
					success: function(response) {
						var resp = JSON.parse(response);
						totalSuccess += (resp.successCnt || 0);
						totalDup += (resp.dupCnt || 0);
						totalFail += (resp.failCnt || 0);

						currentBatch++;
						var processed = Math.min(end, allRows.length);
						var pct = Math.round((processed / allRows.length) * 100);
						$('#saveProgress').text(processed + ' / ' + allRows.length + '건 처리 중...');
						$('#saveProgressBar').css('width', pct + '%').text(pct + '%');

						if (currentBatch < totalBatches) {
							setTimeout(sendBatch, 100);
						} else {
							var msg = '성공: ' + totalSuccess + '건';
							if (totalDup > 0) msg += ', 중복: ' + totalDup + '건';
							if (totalFail > 0) msg += ', 실패: ' + totalFail + '건';

							Swal.fire({
								title: '처리완료',
								text: msg,
								icon: totalFail > 0 ? 'warning' : 'success',
								confirmButtonText: '확인',
								customClass: { popup: 'small-swal' }
							});

							excelCheckedSet.clear();
							$('#excelSelectAll').prop('checked', false);
							$('.excel-chk').prop('checked', false);

							// 메인 테이블 새로고침
							if (dataTable && typeof dataTable.ajax !== 'undefined') {
								dataTable.ajax.reload();
							}
						}
					},
					error: function(xhr, status, error) {
						totalFail += batchData.length;
						currentBatch++;
						if (currentBatch < totalBatches) {
							setTimeout(sendBatch, 100);
						} else {
							var msg = '성공: ' + totalSuccess + '건, 실패: ' + totalFail + '건';
							Swal.fire({
								title: '처리완료 (일부 실패)',
								text: msg,
								icon: 'warning',
								confirmButtonText: '확인',
								customClass: { popup: 'small-swal' }
							});
						}
					}
				});
			}

			sendBatch();
		}
		</script>
		<!-- ============================================================== -->
		<!-- 엑셀 업로드 End -->
		<!-- ============================================================== -->

	