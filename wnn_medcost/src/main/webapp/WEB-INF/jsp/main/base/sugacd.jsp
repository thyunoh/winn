<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>  
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="decorator" uri="http://www.opensymphony.com/sitemesh/decorator" %>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/page" prefix="page" %>
<%@ page import ="java.util.Date" %>
<!-- Customized Bootstrap Stylesheet -->
<link href="/css/winmc/style_comm.css?v=126"  rel="stylesheet">
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
	                                
	                                <!-- 조회 조건은 항상 oninput(this)를 넣어야함 변경시 자동저장 -->
									<select id="feeType1" class="w-72 p-2 rounded-lg" oninput="findField(this)">
									  <option selected value="1">구분 1</option>
									</select>     
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
                                            <button  class="btn btn-outline-dark" data-toggle="tooltip" data-placement="top" title=""            onClick="fn_re_load()">재조회. <i class="fas fa-binoculars"></i></button>
                                            <button  class="btn btn-outline-dark btn-insert" data-toggle="tooltip" data-placement="top" title="신규 Data 입력" onClick="modal_Open('I')">입력. <i class="far fa-edit"></i></button>                                            
                                            <button  class="btn btn-outline-dark btn-update" data-toggle="tooltip" data-placement="top" title="선택 Data 수정" onClick="modal_Open('U')">수정. <i class="far fa-save"></i></button>                                            
                                            <button  class="btn btn-outline-dark btn-delete" data-toggle="tooltip" data-placement="top" title="선택 Data 삭제" onClick="modal_Open('D')">삭제. <i class="far fa-trash-alt"></i></button>                                             
                                            <button  class="btn btn-outline-dark btn-delete" data-toggle="tooltip" data-placement="top" title="체크 Data 삭제" onClick="fn_findchk()">체크삭제. <i class="far fa-calendar-check"></i></button>
                                            <button  class="btn btn-outline-success" data-toggle="tooltip" data-placement="top" title="엑셀 파일 업로드" onClick="excelUpload_Open()">엑셀업로드. <i class="fas fa-file-excel"></i></button>
                                            <button  class="btn btn-outline-dark" data-toggle="tooltip" data-placement="top" title="화면 Size 확대.축소" id="fullscreenToggle">화면확장축소. <i class="fas fa-expand" id="fullscreenIcon"></i></button>
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
	    <div class="modal fade" id="modalName" tabindex="-1" data-backdrop="static" role="dialog" aria-hidden="false" data-keyboard="false">
	      <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable"   role="dialog" style="position:absolute; top:50%; left:50%; 
	                                                   transform:translate(-50%, -50%); width:50vw; max-width:50vw;max-height: 60vh;">
	        <div class="modal-content" style="height: 80%;display: flex;flex-direction: column;">
	          <div class="modal-header bg-light">
	            <h6 class="modal-title" id="modalHead"></h6> 
              <!-- ============================================================== -->
              <!-- button start -->
              <!-- ============================================================== -->                  
              <div class="form-row">
                  <div class="col-sm-12 mb-2" style="text-align:right;"> 
                    <button id="form_btn_new" type="submit" class="btn btn-outline-dark"    onClick="fn_Potion()">센터. <i class="far fa-object-group"></i></button>
                    <button id="form_btn_ins" type="submit" class="btn btn-outline-info    btn-insert" onClick="fn_Insert()">입력. <i class="far fa-edit"></i></button>
				    <button id="form_btn_udt" type="submit" class="btn btn-outline-success btn-update" onClick="fn_Update()">수정. <i class="far fa-save"></i></button>
   				    <button id="form_btn_del" type="submit" class="btn btn-outline-danger  btn-delete" onClick="fn_Delete()">삭제. <i class="far fa-trash-alt"></i></button>
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
                    <input type="hidden" id="reg_user" name="reg_user" value="">
                    <input type="hidden" id="upd_user" name="upd_user" value="">
                    <input type="hidden" id="reg_ip"   name="reg_ip"   value="">
                    <input type="hidden" id="upd_ip"   name="upd_ip "  value= "">
                    <div class="form-group row ">
                        <label for="feeCode" class="col-2 col-sm-2 col-form-label text-left">수가코드</label>
                        <div class="col-2 col-sm-2">
                            <input id="feeCode" name="feeCode" type="text" class="form-control is-invalid text-left" required placeholder="">
                        </div>
                       <label for="feeType" class="col-2 col-lg-2 col-form-label text-left">수가구분</label>
                       <div class="col-2 col-lg-2">  
						  <select id="feeType" name="feeType" class="custom-select" oninput="findField(this)" required style="height:35px; font-size:14px;">
						     <option selected value= "" >구분 1</option> 
						  </select>
	                   </div>
	                   <label for="startDt" class="col-2 col-lg-2 col-form-label text-left">시작일자</label>
	                   <div class="col-2 col-lg-2">                                       
	                      <input id="startDt" name="startDt" type="text" class="form-control date1-inputmask" placeholder="yyyy-mm-dd" maxlength="">
	                   </div>
                    </div>
                    <div class="form-group row">
                       <label for="classNo" class="col-2 col-sm-2 col-form-label text-left">분류기호</label>
                       <div class="col-4 col-lg-4">  
                            <input id="classNo" name="classNo" type="text" class="form-control" required placeholder="분류기호를 입력하세요">
                       </div>
	                   <label for="endDt" class="col-2 col-lg-2 col-form-label text-left">종료일자</label>
	                   <div class="col-4 col-lg-4">                                       
	                      <input id="endDt" name="endDt" type="text" class="form-control date1-inputmask" placeholder="yyyy-mm-dd" maxlength="">
	                   </div>
                    </div>
                    <div class="form-group row g-0 mb-0">
                        <label for="korNm" class="col-2 col-sm-2 col-form-label text-left">한글명</label>
                        <div class="col-10 col-sm-10">
                            <input id="korNm" name="korNm" type="text" class="form-control text-left" placeholder="수가명칭을 입력하세요" minlength="" >
                        </div>
                    </div>
                    <div class="form-group row g-0 mb-0">
                        <label for="engNm" class="col-2 col-sm-2 col-form-label text-left">영문명</label>
                        <div class="col-10 col-sm-10">
                            <input id="engNm" name="engNm" type="text" class="form-control" placeholder="영문명칭을 입력하세요" maxlength="">
                        </div>
                      
                    </div>
  
                    <div class="form-group row ">
                        <label for="calcNm" class="col-2 col-sm-2 col-form-label text-left">산정명칭</label>
                        <div class="col-10 col-sm-10">
                            <input id="calcNm" name="calcNm" type="text" class="form-control is-invalid text-left" placeholder="산정명칭을 입력하세요">
                        </div>
                    </div>                  

                    <div class="form-group row">
                        <label for="clnPrice" class="col-2 col-lg-2 col-form-label text-left">의원단가</label>
                        <div class="col-2 col-lg-2">
                            <input id="clnPrice" name="clnPrice" value = "0" type="number"  class="form-control" style="text-align: right;" placeholder="" maxlength="">
                        </div>
                        <label for="hosPrice" class="col-2 col-lg-2 col-form-label text-left">병원단가</label>
                        <div class="col-2 col-lg-2">
                            <input id="hosPrice" name="hosPrice" value = "0" type="number" class="form-control" style="text-align: right;" placeholder="" maxlength="">
                        </div>
                        <label for="dntPrice" class="col-2 col-lg-2 col-form-label text-left">치과단가</label>
                        <div class="col-2 col-lg-2">
                            <input id="dntPrice" name="dntPrice" value = "0" type="number" class="form-control" style="text-align: right;" placeholder="" maxlength="">
                        </div>
                    </div>
                     <div class="form-group row">
                        <label for="orhPrice" class="col-2 col-lg-2 col-form-label text-left">한방단가</label>
                        <div class="col-2 col-lg-2">
                            <input id="orhPrice" name="orhPrice" value = "0" type="number" class="form-control" style="text-align: right;" placeholder="" maxlength="">
                        </div>
                        <label for="rltValue" class="col-2 col-lg-2 col-form-label text-left">상대점수</label>
                        <div class="col-2 col-lg-2">
                            <input id="rltValue" name="rltValue" value = "0" type="text" class="form-control"  placeholder="" maxlength="">
                            
                        </div>
                        <label for="copay50" class="col-2 col-lg-2 col-form-label text-left">본인50%</label>
                        <div class="col-2 col-lg-2">
	                        <select class="custom-select" name="copay50" id="copay50">
				                <option value="Y">Y</option>
				                <option value="N" selected>N</option>
	 		                </select> 
	 		            </div>    
	 		        </div>    
	 		        <div class="form-group row">    
                        <label for="copay80" class="col-2 col-lg-2 col-form-label text-left">본인80%</label>
                        <div class="col-2 col-lg-2">
	                        <select class="custom-select" name="copay80" id="copay80">
				                <option value="Y">Y</option>
				                <option value="N" selected>N</option>
	 		                </select>
                        </div>
                        <label for="copay90" class="col-2 col-lg-2 col-form-label text-left">본인90%</label>
                        <div class="col-2 col-lg-2">
                            <select class="custom-select" name="copay90" id="copay90">
				                <option value="Y">Y</option>
				                <option value="N" selected>N</option>
	 		                </select>
                        </div>
		                  <label for="dupYn" class="col-2 col-lg-2 col-form-label text-left">중복인정</label>
		                  <div class="col-2 col-lg-2">
                             <select class="custom-select"  name="dupYn" id="dupYn">
				                <option value="Y">Y</option>
				                <option value="N" selected>N</option>
	 		                </select>
		                  </div>
                    </div>
                    <div class="form-group row">
		                  <label for="secMaj" class="col-2 col-lg-2 col-form-label text-left">장구분</label>
		                  <div class="col-4 col-lg-4">
		                      <input id="secMaj" name="secMaj" type="text" class="form-control"  placeholder="" maxlength="">
		                  </div>
		                  <label for="secMin" class="col-2 col-lg-2 col-form-label text-left">절구분</label>
		                  <div class="col-4 col-lg-4">
		                      <input id="secMin" name="secMin" type="text" class="form-control"  placeholder="" maxlength="">
		                  </div>
                    </div>    
                     <div class="form-group row">
		                  <label for="subCat" class="col-2 col-lg-2 col-form-label text-left">세구분</label>
		                  <div class="col-4 col-lg-4">
		                      <input id="subCat" name="subCat" type="text" class="form-control"  placeholder="" maxlength="">
		                  </div>
                          <label for="divType" class="col-2 col-lg-2 col-form-label text-left">행위가산</label>
                          <div class="col-4 col-lg-4">
	                          <select class="custom-select" name="divType" id="divType">
				                  <option value="1">미가산</option>
				                  <option value="2" selected>가산</option>
	 		                  </select> 
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
	            <h6 class="modal-title">엑셀 업로드</h6>
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
                    <label class="col-1 col-form-label text-left">수가구분</label>
                    <div class="col-2">
                        <select id="excelFeeType" class="custom-select" style="height:35px; font-size:14px;">
                            <option value="">선택</option>
                        </select>
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
		var findTxtln  = 3;    // 조회조건시 글자수 제한 / 0이면 제한 없음
		var firstflag  = false; // 첫음부터 Find하시려면 false를 주면됨
		var findValues = [];
		// 조회조건이 있으면 설정하면됨 / 조건 없으면 막으면 됨
		// 글자수조건 있는건 1개만 설정가능 chk: true 아니면 모두 flase
		// 조회조건은 필요한 만큼 추가사용 하면됨.
		findValues.push({ id: "findData",  val: "AA100",  chk: true  });
		findValues.push({ id: "feeType1",  val: "1", chk: false });
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
		var list_code = ['SUGAGBN','SUGAGBN'];     // 구분코드 필요한 만큼 선언해서 사용
		var select_id = ['feeType','feeType1'];     // 구분코드 데이터 담길 Select (ComboBox ID) 
		var firstnull = ['N','N'];                              // Y 첫번째 Null,이후 Data 담김 / N 바로 Data 담김 
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
		var defaultCnt = 40;                      // Data Default 갯수
		
		
		//  DataTable Columns 정의, c_Head_Set, columnsSet갯수는 항상 같아야함.
		var c_Head_Set = [
						    { name: '수가코드', className: 'dt-body-center' },
						    { name: '구분',    className: 'dt-body-center' },
						    { name: '구분명',  className: 'dt-body-center' },
						    { name: '한글명',  className: 'dt-body-center' },
						    { name: '영문명',  className: 'dt-body-center' },
						    { name: '시작일',  className: 'dt-body-center' },
						    { name: '종료일',  className: 'dt-body-center' },
						    { name: '상대점수', className: 'dt-body-center' },
						    { name: '병원단가', className: 'dt-body-center' },
						    { name: '산정명칭', className: 'dt-body-center' }
						    
						];
		var columnsSet = [  // data 컬럼 id는 반드시 DTO의 컬럼,Modal id는 일치해야 함 (조회시)
	        				// name 컬럼 id는 반드시 DTO의 컬럼 일치해야 함 (수정,삭제시), primaryKey로 수정, 삭제함.
	        				// dt-body-center, dt-body-left, dt-body-right	        				
	        				{ data: 'feeCode',    visible: true,  className: 'dt-body-center', width: '100px',  name: 'key_fee_code', primaryKey: true },
							{ data: 'feeType',    visible: false, className: 'dt-body-center', width: '100px',  name: 'key_fee_type', primaryKey: true },
	        				{ data: 'feeTypeNm',  visible: false, className: 'dt-body-center', width: '100px',  },
	        				{ data: 'korNm',      visible: true,  className: 'dt-body-left'  , width: '300px',  },
	        				{ data: 'engNm',      visible: true,  className: 'dt-body-left'  , width: '300px',  },	        				
	        				// getFormat 사용시 
	        				{ data: 'startDt',    visible: true,  className: 'dt-body-center', width: '100px',  name: 'key_start_dt', primaryKey: true,
	                          	render: function(data, type, row) {
		            				if (type === 'display') {
		            					return getFormat(data,'d1')
		                			}
		                			return data;
	            				}
	        				},
	        				// getFormat 사용시
					        { data: 'endDt',      visible: true,  className: 'dt-body-center', width: '100px',    
					            render: function(data, type, row) {
					            	if (type === 'display') {
					            		return getFormat(data,'d1')
					                }
					                return data;
					            }
					        },
					        { data: 'rltValue' , visible: true, className: 'dt-body-center', width: '100px',  },
					        { data: 'hosPrice' , visible: true, className: 'dt-body-center', width: '100px',  },
					        { data: 'calcNm'   , visible: true, className: 'dt-body-left'  , width: '300px',  }					        
						 ];
		
		var s_CheckBox = true;   		           	 // CheckBox 표시 여부
        var s_AutoNums = true;   		             // 자동순번 표시 여부
        
		// 초기 data Sort,  없으면 []
		var muiltSorts = [
							['feeCode', 'asc' ],    // 오름차순 정렬
            				['startDt', 'desc']     // 내림차순 정렬
        				 ];
        // Sort여부 표시를 일부만 할 때 개별 id, ** 전체 적용은 '_all'하면 됩니다. ** 전체 적용 안함은 []        				 
		var showSortNo = ['feeCode','korNm'];                   
		// Columns 숨김 columnsSet -> visible로 대체함 hideColums 보다 먼제 처리됨 ( visible를 선언하지 않으면 hideColums컬럼 적용됨 )	
		var hideColums = ['feeType','feeTypeNm'];             // 없으면 []; 일부 컬럼 숨길때		
		var txt_Markln = 20;                       				 // 컬럼의 글자수가 설정값보다 크면, 다음은 ...로 표시함
		// 글자수 제한표시를 일부만 할 때 개별 id, ** 전체 적용은 '_all'하면 됩니다. ** 전체 적용 안함은 []
		var markColums = ['korNm','engNm','calcNm'];
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
		//수정시 키는 readonly
		function modal_key_hidden(flag) {	
	        const feeCodeInput     = document.getElementById("feeCode");
	        const feeTypeInput     = document.getElementById("feeType");
	        const startDtInput     = document.getElementById("startDt");

	        const inputs = [feeCodeInput, startDtInput];
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
	            $(feeTypeInput).css("pointer-events", "none").css("background-color", "#e9ecef"); // 비활성화된 느낌의 배경색 적용
	        } else {
	            $(feeTypeInput).css("pointer-events", "").css("background-color", ""); // 활성화
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
	            modal_key_hidden(flag)
	            
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
				     // 페이지와 버튼 간격 넓히기  
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
		   		let key = findValue.id === "feeType1" ? "feeType" : findValue.id;
		   		find[key] = findValue.val;
		   	}
		   	
		    $.ajax({
		        type: "POST",
		        url: "/base/sugaCdList.do",
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
		        feeCode: { kname: "수가코드", k_min: 3, k_max: 10, k_req: true, k_spc: true, k_clr: true },
		        startDt: { kname: "시작일자", k_req: true },
		        endDt:   { kname: "종료일자", k_req: true },
		        classNo: { kname: "분류기호", k_req: true },
		        feeType: { kname: "수가구분", k_req: true },
		        korNm:   { kname: "한글명", k_req: true },
		        engNm:   { kname: "영문명", k_req: true },
		        clnPrice: { kname: "의원단가", k_num: true },
		        hosPrice: { kname: "병원단가", k_num: true },
		        dntPrice: { kname: "치과단가", k_num: true },
		        orhPrice: { kname: "한방단가", k_num: true }
		    });
		    return results;
		}
		//그리드상 데이타생성및 수정 작업
		function newuptData() {
        	let newData = {
                feeCode: $('#feeCode').val(),
                startDt: replaceMulti($('#startDt').val(), "-", "/"),
                endDt:   replaceMulti($('#endDt').val(), "-", "/"), 
                classNo: $('#classNo').val(),
                feeType: $('#feeType').val(),
                korNm: $('#korNm').val(),
                engNm: $('#engNm').val(),
                feeTypeNm: '',
                calcNm: $('#calcNm').val(),
                rltValue: $('#rltValue').val(),
                clnPrice: $('#clnPrice').val(),
                hosPrice: $('#hosPrice').val(),
                dntPrice: $('#dntPrice').val(),
                orhPrice: $('#orhPrice').val()
			    };
		    return newData;
		}	
		function fn_Insert(){
			// 1. form (input, select, textarea Element 및 Value 확인
			// key는 (반드시 Field id로 넣어야 됨) !!!!!!!!!!!!!!!!!!!!!!			
			// { 
			//   kname(Message 처리시 재정의된 kname로 표시됨),  
			//	 k_len(자리수),      k_min(최소자릿수), k_max(최대자리수), 
			//	 k_req(반드시입력확인), k_num(숫자만입력), k_spc(공백확인), k_clr(입력값Clear), 
			//   k_chr(제거문자)
			// };
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
			            url: "/base/sugaCdInsert.do",
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
		            url: "/base/sugaCdUpdate.do",
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
				            url: "/base/sugaCdDelete.do",	    	    
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
				            url: "/user/sugaCdDelete.do",	    	    
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
		function modalMainClose() {
			$("#" + modalName.id).modal('hide');
		}
		//권한조건체크 applyAuthControl.js
	    document.addEventListener("DOMContentLoaded", function() {
	        applyAuthControl();
	    });

		</script>
		<!-- ============================================================== -->
		<!-- 기타 정보 End -->
		<!-- ============================================================== -->

		<!-- ============================================================== -->
		<!-- 엑셀 업로드 Start -->
		<!-- ============================================================== -->
		<script type="text/javascript">
		console.log('[엑셀모듈] 스크립트 블록 로드됨');
		// 엑셀 업로드 관련 변수
		var excelParsedData = [];    // 파싱된 엑셀 데이터
		var excelHeaders = [];       // 엑셀 헤더
		var excelPreviewDT = null;   // 미리보기 DataTable
		var excelColumnMap = {};     // 엑셀헤더 → DB컬럼 매핑
		var excelCachedFile = null;  // 파일 캐시 (같은 파일이면 재파싱 안함)
		var excelModalClosable = false; // 모달 닫기 허용 플래그
		var excelCheckedSet = new Set(); // 체크된 행 인덱스 관리 (deferRender 대응)

		// ============================================
		// 엑셀 → DB 데이터 포맷 변환 함수들
		// ============================================

		// 엑셀 날짜 → yyyy/mm/dd 변환 (다양한 형식 지원)
		// 지원: 2026-12-01, 2026/12/01, 20261201, 46023(시리얼),
		//       10/1/22, 7/1/23, 12/1/21 (M/D/YY 2자리연도)
		function excelDateToStr(val) {
			if (!val && val !== 0) return '';
			var s = String(val).trim();
			if (!s) return '';

			// 2자리 연도 → 4자리 변환 (00~49→2000~2049, 50~99→1950~1999)
			function toFullYear(yy) {
				var n = parseInt(yy, 10);
				return (n <= 49 ? 2000 + n : 1900 + n);
			}

			// 1) 숫자만(엑셀 시리얼 날짜) - 예: 46023, 46023.0
			if (/^\d{5,}$/.test(s) || /^\d+\.\d+$/.test(s)) {
				var num = parseFloat(s);
				if (num > 1 && num < 200000) {
					var utcDays = Math.floor(num - 25569);
					var utcValue = utcDays * 86400 * 1000;
					var d = new Date(utcValue);
					var y = d.getUTCFullYear();
					var m = ('0' + (d.getUTCMonth() + 1)).slice(-2);
					var dd = ('0' + d.getUTCDate()).slice(-2);
					return y + '/' + m + '/' + dd;
				}
			}

			// 2) yyyy-mm-dd, yyyy/mm/dd, yyyy.mm.dd → yyyy/mm/dd (4자리 연도 먼저)
			var match = s.match(/^(\d{4})[\-\/\.](\d{1,2})[\-\/\.](\d{1,2})/);
			if (match) {
				return match[1] + '/' + ('0' + match[2]).slice(-2) + '/' + ('0' + match[3]).slice(-2);
			}

			// 3) yyyymmdd → yyyy/mm/dd
			var match2 = s.match(/^(\d{4})(\d{2})(\d{2})$/);
			if (match2) {
				return match2[1] + '/' + match2[2] + '/' + match2[3];
			}

			// 4) M/D/YYYY (4자리연도) → yyyy/mm/dd
			var match3 = s.match(/^(\d{1,2})[\-\/\.](\d{1,2})[\-\/\.](\d{4})$/);
			if (match3) {
				return match3[3] + '/' + ('0' + match3[1]).slice(-2) + '/' + ('0' + match3[2]).slice(-2);
			}

			// 5) M/D/YY (2자리연도) → yyyy/mm/dd  예: 10/1/22 → 2022/10/01
			var match4 = s.match(/^(\d{1,2})[\-\/\.](\d{1,2})[\-\/\.](\d{2})$/);
			if (match4) {
				var fullY = toFullYear(match4[3]);
				return fullY + '/' + ('0' + match4[1]).slice(-2) + '/' + ('0' + match4[2]).slice(-2);
			}

			// 6) 그 외 → 그대로 반환
			return s;
		}

		// 숫자값 정리 (쉼표 제거, 빈값→0)
		function toNumericStr(val) {
			if (!val && val !== 0) return '0';
			var s = String(val).trim();
			if (!s) return '0';
			// 쉼표 제거
			s = s.replace(/,/g, '');
			// 숫자가 아닌 경우 0
			if (isNaN(s)) return '0';
			return s;
		}

		// 소수점 숫자값 (상대가치점수 등)
		function toDecimalStr(val) {
			if (!val && val !== 0) return '0';
			var s = String(val).trim();
			if (!s) return '0';
			s = s.replace(/,/g, '');
			if (isNaN(s)) return '0';
			return s;
		}

		// Y/N 값 정리
		function toYNStr(val) {
			if (!val) return 'N';
			var s = String(val).trim().toUpperCase();
			if (s === 'Y' || s === 'YES' || s === '1' || s === 'O' || s === '예') return 'Y';
			return 'N';
		}

		// 문자열 값 정리 (공백 trim, null → 빈문자)
		function toStr(val) {
			if (!val && val !== 0) return '';
			return String(val).trim();
		}

		// 행 전체를 DB 포맷으로 변환
		function convertRowToDbFormat(row) {
			return {
				feeCode:  toStr(row.feeCode),
				feeType:  toStr(row.feeType),
				startDt:  excelDateToStr(row.startDt),
				endDt:    '2099/12/31',
				classNo:  toStr(row.classNo),
				korNm:    toStr(row.korNm),
				engNm:    toStr(row.engNm),
				divType:  toStr(row.divType) || '1',
				surgYn:   toYNStr(row.surgYn),
				clnPrice: toNumericStr(row.clnPrice),
				hosPrice: toNumericStr(row.hosPrice),
				dntPrice: toNumericStr(row.dntPrice),
				pblPrice: toNumericStr(row.pblPrice),
				midPrice: toNumericStr(row.midPrice),
				orhPrice: toNumericStr(row.orhPrice),
				yngPrice: toNumericStr(row.yngPrice),
				rltValue: toDecimalStr(row.rltValue),
				copay50:  toYNStr(row.copay50),
				copay80:  toYNStr(row.copay80),
				copay90:  toYNStr(row.copay90),
				dupYn:    toYNStr(row.dupYn),
				calcNm:   toStr(row.calcNm),
				secMaj:   toStr(row.secMaj),
				secMin:   toStr(row.secMin),
				subCat:   toStr(row.subCat)
			};
		}

		// DB 컬럼 정의 (매핑 대상)
		var dbColumns = [
			{ key: 'feeCode',  label: '수가코드',   required: true },
			{ key: 'startDt',  label: '적용시작일자', required: true },
			{ key: 'endDt',    label: '적용종료일자', required: false },
			{ key: 'classNo',  label: '분류기호',   required: false },
			{ key: 'korNm',    label: '한글명',     required: true },
			{ key: 'engNm',    label: '영문명',     required: false },
			{ key: 'divType',  label: '1-2구분',    required: false },
			{ key: 'surgYn',   label: '수술여부',   required: false },
			{ key: 'clnPrice', label: '의원단가',   required: false },
			{ key: 'hosPrice', label: '병원단가',   required: false },
			{ key: 'dntPrice', label: '치과단가',   required: false },
			{ key: 'pblPrice', label: '보건기관단가', required: false },
			{ key: 'midPrice', label: '조산원단가',  required: false },
			{ key: 'orhPrice', label: '한방단가',   required: false },
			{ key: 'yngPrice', label: '요양정신단가', required: false },
			{ key: 'rltValue', label: '상대가치점수', required: false },
			{ key: 'copay50',  label: '본인부담50',  required: false },
			{ key: 'copay80',  label: '본인부담80',  required: false },
			{ key: 'copay90',  label: '본인부담90',  required: false },
			{ key: 'dupYn',    label: '중복인정',    required: false },
			{ key: 'calcNm',   label: '산정명칭',   required: false },
			{ key: 'secMaj',   label: '장구분',     required: false },
			{ key: 'secMin',   label: '절구분',     required: false },
			{ key: 'subCat',   label: '세분류',     required: false }
		];

		// 자동매핑 키워드 (엑셀 헤더 → DB 컬럼)
		var autoMapKeywords = {
			'feeCode':  ['수가코드','약품코드','재료코드','코드','fee_code','feecode','code'],
			'startDt':  ['적용시작일자','적용일자','시작일자','시작일','적용시작','start_dt','startdt','적용개시'],
			'endDt':    ['적용종료일자','종료일자','종료일','적용종료','end_dt','enddt'],
			'classNo':  ['분류기호','분류번호','분류','class_no','classno'],
			'korNm':    ['한글명','품명','한글','명칭','kor_nm','kornm','한글명칭','재료명'],
			'engNm':    ['영문명','영문','eng_nm','engnm','영문명칭'],
			'divType':  ['1-2구분','행위구분','div_type','divtype'],
			'surgYn':   ['수술여부','수술','surg_yn','surgyn'],
			'clnPrice': ['의원단가','의원','cln_price','clnprice'],
			'hosPrice': ['병원단가','병원급','병원','상한금액','상한가','hos_price','hosprice'],
			'dntPrice': ['치과단가','치과','dnt_price','dntprice'],
			'pblPrice': ['보건기관단가','보건기관','보건','pbl_price','pblprice'],
			'midPrice': ['조산원단가','조산원','조산','mid_price','midprice'],
			'orhPrice': ['한방단가','한방병원','한방','orh_price','orhprice'],
			'yngPrice': ['요양정신단가','요양정신','요양','yng_price','yngprice'],
			'rltValue': ['상대가치','상대점수','rlt_value','rltvalue','점수'],
			'copay50':  ['본인부담률50/100','본인부담율50/100','본인부담률50','본인부담률A','본인부담50','본인50','copay_50','copay50','50/100'],
			'copay80':  ['본인부담률80/100','본인부담율80/100','본인부담률80','본인부담률B','본인부담80','본인80','copay_80','copay80','80/100'],
			'copay90':  ['본인부담률90/100','본인부담율90/100','본인부담률90','본인부담90','본인90','copay_90','copay90','90/100'],
			'dupYn':    ['중복인정','중복','dup_yn','dupyn'],
			'calcNm':   ['산정명칭','산정','calc_nm','calcnm'],
			'secMaj':   ['장구분','sec_maj','secmaj'],
			'secMin':   ['절구분','sec_min','secmin'],
			'subCat':   ['세분류','세구분','sub_cat','subcat']
		};

		// 엑셀 업로드 모달 열기
		function excelUpload_Open() {
			console.log('[엑셀모듈] excelUpload_Open 호출됨');
			// 수가구분 옵션 복사
			var srcSelect = document.getElementById('feeType1');
			var tgtSelect = document.getElementById('excelFeeType');
			tgtSelect.innerHTML = '<option value="">선택</option>';
			for (var i = 0; i < srcSelect.options.length; i++) {
				var opt = srcSelect.options[i];
				tgtSelect.innerHTML += '<option value="' + opt.value + '">' + opt.text + '</option>';
			}
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

			// 닫기 버튼으로만 닫기 가능 (바깥 클릭, ESC 차단)
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
			console.log('[엑셀모듈] fn_ExcelPreview 호출됨');
			var feeType = document.getElementById('excelFeeType').value;
			if (!feeType) {
				Swal.fire({ title: '확인', text: '수가구분을 선택하세요.', icon: 'warning', timer: 1500, showConfirmButton: false, customClass: { popup: 'small-swal' } });
				return;
			}
			var fileInput = document.getElementById('excelFileInput');
			if (!fileInput.files || fileInput.files.length === 0) {
				Swal.fire({ title: '확인', text: '엑셀 파일을 선택하세요.', icon: 'warning', timer: 1500, showConfirmButton: false, customClass: { popup: 'small-swal' } });
				return;
			}

			var file = fileInput.files[0];

			// 같은 파일이면 파싱 건너뛰고 테이블만 재생성
			var fileKey = file.name + '_' + file.size + '_' + file.lastModified;
			if (excelCachedFile === fileKey && excelParsedData.length > 0) {
				autoMapColumns();
				buildMappingUI();
				buildPreviewTable(feeType);
				return;
			}
			excelCachedFile = fileKey;

			// 진행상황 표시
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
				$('#excelProgress').text('엑셀 파일 파싱 중... (대용량 파일은 시간이 걸립니다)');
				$('#excelProgressBar').css({ 'width': '10%', 'transition': 'width 8s ease-out' }).text('파싱 중...');
				requestAnimationFrame(function() { $('#excelProgressBar').css('width', '45%'); });

				setTimeout(function() {
					try {
						console.log('[엑셀] XLSX.read 시작 (ArrayBuffer + dense)...');
						var workbook = XLSX.read(new Uint8Array(e.target.result), { type: 'array', dense: true });
						console.log('[엑셀] XLSX.read 완료. 시트수:', workbook.SheetNames.length);

						// 디버그: 각 시트의 상세 정보
						for (var dbg = 0; dbg < workbook.SheetNames.length; dbg++) {
							var dbgWs = workbook.Sheets[workbook.SheetNames[dbg]];
							var dbgKeys = dbgWs ? Object.keys(dbgWs) : [];
							var dbgCellKeys = dbgKeys.filter(function(k){ return k[0] !== '!'; });
							var dbgMetaKeys = dbgKeys.filter(function(k){ return k[0] === '!'; });
							console.log('[엑셀] 시트[' + dbg + '] "' + workbook.SheetNames[dbg] + '"',
								'| !ref:', dbgWs ? dbgWs['!ref'] : 'null',
								'| 전체키:', dbgKeys.length,
								'| 셀키:', dbgCellKeys.length,
								'| 메타키:', dbgMetaKeys,
								'| 셀샘플:', dbgCellKeys.slice(0, 5),
								'| !data:', dbgWs && dbgWs['!data'] ? '있음(행수:' + dbgWs['!data'].length + ')' : '없음'
							);
						}

						// 데이터가 있는 첫 번째 시트 자동 선택
						var ws = null;
						var usedSheetName = '';

						// 1차: !ref 있는 시트
						for (var si = 0; si < workbook.SheetNames.length; si++) {
							var tmpWs = workbook.Sheets[workbook.SheetNames[si]];
							if (tmpWs && tmpWs['!ref']) {
								ws = tmpWs;
								usedSheetName = workbook.SheetNames[si];
								break;
							}
						}
						// 2차: !ref 없어도 셀이 있으면 사용
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
						// 3차: !data 배열이 있으면 사용 (dense 모드)
						if (!ws) {
							for (var si3 = 0; si3 < workbook.SheetNames.length; si3++) {
								var tmpWs3 = workbook.Sheets[workbook.SheetNames[si3]];
								if (tmpWs3 && tmpWs3['!data'] && tmpWs3['!data'].length > 0) {
									ws = tmpWs3;
									usedSheetName = workbook.SheetNames[si3];
									// dense 모드 → !ref 생성
									ws['!ref'] = XLSX.utils.encode_range({ s: { r: 0, c: 0 }, e: { r: ws['!data'].length - 1, c: (ws['!data'][0] || []).length - 1 } });
									console.log('[엑셀] dense 모드 시트 발견, !ref 생성:', ws['!ref']);
									break;
								}
							}
						}
						if (!ws) {
							Swal.close();
							Swal.fire({ title: '확인', text: '엑셀에 데이터가 없습니다.', icon: 'warning', timer: 2000, showConfirmButton: true, customClass: { popup: 'small-swal' } });
							return;
						}
						console.log('[엑셀] 사용 시트:', usedSheetName, '| !ref:', ws['!ref']);

						$('#excelProgressBar').css({ 'transition': 'none', 'width': '50%' }).text('50%');
						$('#excelProgress').text(usedSheetName + ' 시트 변환 중...');

						console.log('[엑셀] sheet_to_json 시작...');
						var jsonData = XLSX.utils.sheet_to_json(ws, { header: 1, defval: '' });
						console.log('[엑셀] sheet_to_json 완료. 행수:', jsonData.length);
						ws = null; workbook = null;

						// 빈 행 제거
						var filtered = [jsonData[0]];
						for (var i = 1; i < jsonData.length; i++) {
							var row = jsonData[i];
							for (var c = 0; c < row.length; c++) {
								if (row[c] !== '' && row[c] !== null && row[c] !== undefined) { filtered.push(row); break; }
							}
						}
						console.log('[엑셀] 빈행 제거 후:', filtered.length, '건');
						jsonData = null;
						processJsonData(filtered, feeType);
					} catch(ex) {
						console.error('[엑셀] 오류 발생:', ex);
						Swal.close();
						Swal.fire({ title: '오류', text: '파싱 실패: ' + ex.message, icon: 'error', showConfirmButton: true, customClass: { popup: 'small-swal' } });
					}
				}, 100);
			};
			reader.readAsArrayBuffer(file);
		}

		// 파싱된 jsonData를 excelParsedData로 변환 + 미리보기
		function processJsonData(jsonData, feeType) {
			if (jsonData.length < 2) {
				Swal.close();
				Swal.fire({ title: '확인', text: '데이터가 부족합니다. (최소 헤더 + 1행)', icon: 'warning', timer: 2000, showConfirmButton: false, customClass: { popup: 'small-swal' } });
				return;
			}

			$('#excelProgress').text('데이터 변환 중... (총 ' + (jsonData.length - 1) + '건)');
			$('#excelProgressBar').css('width', '50%').text('50%');

			excelHeaders = jsonData[0].map(function(h) { return String(h).trim(); });
			excelParsedData = [];
			var totalData = jsonData.length - 1;

			// 청크 처리 (5000건씩)
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
					finishPreview(feeType);
				}
			}

			setTimeout(processChunk, 0);
		}

		// 미리보기 완료 처리
		function finishPreview(feeType) {
			$('#excelProgress').text('컬럼 자동 매핑 중...');
			$('#excelProgressBar').css('width', '92%').text('92%');

			autoMapColumns();
			buildMappingUI();

			$('#excelProgress').text('미리보기 테이블 생성 중...');
			$('#excelProgressBar').css('width', '96%').text('96%');

			setTimeout(function() {
				buildPreviewTable(feeType);
				$('#excelProgressBar').css('width', '100%').text('100%');
				$('#excelProgress').text('완료! 총 ' + excelParsedData.length + '건 로드됨');
				setTimeout(function() { Swal.close(); }, 500);
			}, 0);
		}

		// 자동 매핑
		function autoMapColumns() {
			excelColumnMap = {};
			for (var i = 0; i < excelHeaders.length; i++) {
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
					var selected = (excelColumnMap[col.key] === excelHeaders[j]) ? ' selected' : '';
					select.innerHTML += '<option value="' + excelHeaders[j] + '"' + selected + '>' + excelHeaders[j] + '</option>';
				}
				// 미매핑 시 빨간색 배경
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

		// 미리보기 테이블 생성 (엑셀 원본 데이터 그대로 표시)
		function buildPreviewTable(feeType) {
			if (excelPreviewDT) {
				excelPreviewDT.destroy();
				$('#excelPreviewTable').empty();
				excelPreviewDT = null;
			}

			// 엑셀 원본 헤더 기준으로 컬럼 구성
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

			// 엑셀 원본 헤더로 컬럼 동적 생성
			for (var i = 0; i < excelHeaders.length; i++) {
				(function(header) {
					previewCols.push({
						data: header,
						title: header,
						defaultContent: '',
						className: 'dt-body-left',
						render: function(data, type) {
							if (type === 'display' && data && String(data).length > 100) {
								var safe = $('<span>').text(data).html();
								return '<span title="' + safe + '">' + $('<span>').text(String(data).substr(0, 100)).html() + '...</span>';
							}
							return data;
						}
					});
				})(excelHeaders[i]);
			}

			// 엑셀 원본 데이터를 그대로 테이블에 표시
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

			// 체크 상태 초기화
			excelCheckedSet = new Set();

			// 전체선택 체크박스
			$('#excelSelectAll').off('click').on('click', function() {
				var checked = this.checked;
				if (checked) {
					for (var i = 0; i < tableData.length; i++) excelCheckedSet.add(i);
				} else {
					excelCheckedSet.clear();
				}
				// 현재 페이지의 체크박스만 UI 반영
				$('.excel-chk').each(function() {
					$(this).prop('checked', checked);
				});
			});

			// 개별 체크박스 클릭 이벤트 (이벤트 위임)
			$('#excelPreviewTable tbody').off('change', '.excel-chk').on('change', '.excel-chk', function() {
				var idx = $(this).data('idx');
				if (this.checked) {
					excelCheckedSet.add(idx);
				} else {
					excelCheckedSet.delete(idx);
					$('#excelSelectAll').prop('checked', false);
				}
				// 전체 체크 여부
				if (excelCheckedSet.size === tableData.length) {
					$('#excelSelectAll').prop('checked', true);
				}
			});

			// 페이지 변경 시 체크 상태 복원
			excelPreviewDT.on('draw', function() {
				$('.excel-chk').each(function() {
					var idx = $(this).data('idx');
					$(this).prop('checked', excelCheckedSet.has(idx));
				});
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
					// 전체 행 체크 후 선택저장 호출
					$('.excel-chk').prop('checked', true);
					$('#excelSelectAll').prop('checked', true);
					fn_ExcelSaveSelected();
				}
			});
		}

		// 선택된 행 저장 (저장 시에만 매핑 적용하여 DB 포맷으로 변환)
		function fn_ExcelSaveSelected() {
			var feeType = document.getElementById('excelFeeType').value;
			if (!feeType) {
				Swal.fire({ title: '확인', text: '수가구분을 선택하세요.', icon: 'warning', timer: 1500, showConfirmButton: false, customClass: { popup: 'small-swal' } });
				return;
			}
			if (!excelPreviewDT) {
				Swal.fire({ title: '확인', text: '먼저 미리보기를 실행하세요.', icon: 'warning', timer: 1500, showConfirmButton: false, customClass: { popup: 'small-swal' } });
				return;
			}

			// 현재 매핑 가져오기
			var map = getCurrentMapping();

			// 필수 매핑 검증
			if (!map.feeCode) {
				Swal.fire({ title: '확인', text: '수가코드 매핑을 선택하세요.', icon: 'warning', timer: 2000, showConfirmButton: true, customClass: { popup: 'small-swal' } });
				return;
			}
			if (!map.startDt) {
				Swal.fire({ title: '확인', text: '적용시작일자 매핑을 선택하세요.', icon: 'warning', timer: 2000, showConfirmButton: true, customClass: { popup: 'small-swal' } });
				return;
			}
			if (!map.korNm) {
				Swal.fire({ title: '확인', text: '한글명 매핑을 선택하세요.', icon: 'warning', timer: 2000, showConfirmButton: true, customClass: { popup: 'small-swal' } });
				return;
			}

			// 체크된 행 수집 (Set 기반 - 모든 페이지 포함)
			var selectedRows = [];
			excelCheckedSet.forEach(function(idx) {
				var rowData = excelPreviewDT.row(idx).data();
				if (rowData) selectedRows.push(rowData);
			});

			if (selectedRows.length === 0) {
				Swal.fire({ title: '확인', text: '저장할 행을 선택하세요.', icon: 'warning', timer: 1500, showConfirmButton: false, customClass: { popup: 'small-swal' } });
				return;
			}

			// 매핑 적용하여 DB 포맷 변환
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
				rawMapped.feeType = feeType;
				// 약가, 재료대 선택 시 1-2구분 무조건 '1'
				if (feeType !== '1') {
					rawMapped.divType = '1';
				}
				// DB 포맷 변환 (날짜, 숫자, Y/N)
				var converted = convertRowToDbFormat(rawMapped);
				converted.feeType = feeType;
				converted.regUser = regUser;
				converted.regIp   = regIp;
				converted.updUser = regUser;
				converted.updIp   = regIp;

				// 필수값 검증
				if (!converted.feeCode || !converted.startDt || !converted.korNm) {
					Swal.fire({ title: '확인', text: (i + 1) + '번째 행: 수가코드, 시작일자, 한글명 값이 비어있습니다.', icon: 'warning', timer: 3000, showConfirmButton: true, customClass: { popup: 'small-swal' } });
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
					url: "/base/sugaCdExcelInsert.do",
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
							// 완료
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

							// 성공행은 Set에서 제거하고 UI 반영
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

		