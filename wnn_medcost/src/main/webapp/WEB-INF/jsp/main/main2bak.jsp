<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>  
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="decorator" uri="http://www.opensymphony.com/sitemesh/decorator" %>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/page" prefix="page" %>
<%@ page import ="java.util.Date" %>

		<!-- ============================================================== -->
        <!-- Main Form start -->
        <!-- ============================================================== -->
		<div class="dashboard-wrapper">
            <div class="container-fluid  dashboard-content">
                <div class="row">
                    <!-- ============================================================== -->
                    <!-- data table start -->
                    <!-- ============================================================== -->                    
                    <div class="col-xl-8 col-lg-8 col-md-8 col-sm-8 col-8">
                        <div class="card">                        	
                            <div class="card-body">  
	                            <div class="form-row mb-2">
	                                
	                                <!-- 조회 조건은 항상 oninput(this)를 넣어야함 변경시 자동저장 -->
	                                <div class="col-sm-2">
	                                	<select id="fee_type" class="form-control" oninput="findField(this)">
				                            <option selected value="1">구분 1</option>
				                            <option value="2">구분 2</option>
				                            <option value="3">구분 3</option>
				                        </select>
                                    </div>	                                
                                    <div class="col-sm-4">
                                        <div class="input-group">
                                             <input id="find_data" type="text" class="form-control" placeholder="3글자 이상 입력 후 [ enter ]" onkeyup="findEnterKey()" oninput="findField(this)">
                                             <div class="input-group-append">
                                                 <button type="button" class="btn btn-rounded btn-primary"  onClick="fn_FindData()">조회. <i class="fas fa-search"></i></button>
                                             </div>
                                        </div>
                                    </div>
                                    
                                    <div class="col-sm-6">                                    
                                         <div class="btn-group ml-auto">
                                            <button class="btn btn-outline-light" data-toggle="tooltip" data-placement="top" title=""            onClick="fn_re_load()">Reload. <i class="fas fa-binoculars"></i></button>
                                            <button class="btn btn-outline-light" data-toggle="tooltip" data-placement="top" title="신규 Data 입력" onClick="modal_Open('I')">Insert. <i class="far fa-edit"></i></button>                                            
                                            <button class="btn btn-outline-light" data-toggle="tooltip" data-placement="top" title="선택 Data 수정" onClick="modal_Open('U')">Update. <i class="far fa-save"></i></button>                                            
                                            <button class="btn btn-outline-light" data-toggle="tooltip" data-placement="top" title="선택 Data 삭제" onClick="modal_Open('D')">Delete. <i class="far fa-trash-alt"></i></button>                                             
                                            <button class="btn btn-outline-light" data-toggle="tooltip" data-placement="top" title="체크 Data 삭제" onClick="fn_findchk()">Delete. <i class="far fa-calendar-check"></i></button>
                                            <button class="btn btn-outline-light" data-toggle="tooltip" data-placement="top" title="화면 Size 확대.축소" id="fullscreenToggle">Screen. <i class="fas fa-expand" id="fullscreenIcon"></i></button>
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
                    
                    <!-- ============================================================== -->
                    <!-- basic form start -->
                    <!-- ============================================================== -->                    
                    <div class="col-xl-4 col-lg-4 col-md-4 col-sm-4 col-4">
                        <div class="card">
                        	<br>
                            <h4 class="card-header">User Information</h4>
                            <div class="card-body">
                                <form id="basicForm" name="basicForm" data-parsley-validate="">
                                    <div class="form-group">
                                        <label for="userid">아이디</label>
                                        <input id="userid" type="text" name="id" data-parsley-trigger="change" placeholder="" autocomplete="off" class="form-control">
                                    </div>
                                    <div class="form-group">
                                        <label for="usernm">성명</label>
                                        <input id="usernm" type="text" name="name" data-parsley-trigger="change" placeholder="" autocomplete="off" class="form-control">
                                    </div>
                                    
                                    <div class="form-group">
                                        <label for="passwd">비밀번호</label>
                                        <input id="passwd" type="password" placeholder=""  class="form-control">
                                    </div>
                                    <div class="form-group">
                                        <label for="repasswd">비밀번호 확인</label>
                                        <input id="repasswd" data-parsley-equalto="#passwd" type="password"  placeholder="" class="form-control">
                                    </div>
                                    
                                    <div class="form-row">
	                                    <div class="col-xl-6 col-lg-6 col-md-12 col-sm-12 col-12 mb-2">
	                                        <label for="startdt">시작일자</label>
	                                        <input type="text" class="form-control" id="startdt"  placeholder="시작일자 8자리 예) 20240101" oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');" minlength="8" maxlength="8">
	                                    </div>
	                                    <div class="col-xl-6 col-lg-6 col-md-12 col-sm-12 col-12 mb-2">
	                                        <label for="enddt">종료일자</label>	                                        
	                                        <input type="text" class="form-control" id="enddt"    placeholder="종료일자 8자리 예) 20240101" oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');" minlength="8" maxlength="8">
	                                    </div>
                                    </div>
                                    <form>
                                        <label class="custom-control custom-radio custom-control-inline">
                                            <input type="radio" id="userflag1" name="maingu" class="custom-control-input" value="1"><span class="custom-control-label">관리자</span>
                                        </label>
                                        <label class="custom-control custom-radio custom-control-inline">
                                            <input type="radio" id="userflag2" name="maingu" class="custom-control-input" value="2"><span class="custom-control-label">사용자</span>
                                        </label>
                                        <label class="custom-control custom-radio custom-control-inline">
                                            <input type="radio" id="userflag3" name="maingu" class="custom-control-input" value="3"><span class="custom-control-label">기타</span>
                                        </label>
                                    </form>
                                    
                                    <div class="form-group">
                                         <label for="bigo">비고</label>
                                         <textarea id="bido" type="text" name="name" data-parsley-trigger="change"  placeholder="" autocomplete="off" class="form-control" rows="5"></textarea>                                        
                                    </div>
                                    <div class="row">
                                         <div class="col-sm-12 pl-3">
                                            <button id="form_btn_new1" class="btn btn-outline-light"   onClick="fn_111()">지움.  <i class="far fa-clipboard"></i></button>
                                            <button id="form_btn_ins1" class="btn btn-outline-info"    onClick="fn_222()">입력. <i class="far fa-edit"></i></button>
                    	   					<button id="form_btn_udt1" class="btn btn-outline-success" onClick="fn_333()">수정. <i class="far fa-save"></i></button>
                           					<button id="form_btn_del1" class="btn btn-outline-danger"  onClick="fn_444()">삭제. <i class="far fa-trash-alt"></i></button>
                           					<button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#exampleModal" onClick="modalopen()">modal</button>                                           	
                                        </div>
                                        
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                    <!-- ============================================================== -->
                    <!-- basic form end -->
                    <!-- ============================================================== -->
                </div>
			</div>                
		</div>        
		<!-- ============================================================== -->
        <!-- modal form start -->
        <!-- ============================================================== -->        
	    <div class="modal fade" id="modalName" tabindex="-1" data-backdrop="static" role="dialog" aria-hidden="false" data-keyboard="false">
	      <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable"   role="dialog" style="position:absolute; top:50%; left:50%; transform:translate(-50%, -50%); width:50vw; max-width:50vw;max-height: 80vh;margin: 0;">
	        <div class="modal-content" style="height: 100%;display: flex;flex-direction: column;">
	          <div class="modal-header bg-light">
	            <h3 class="modal-title" id="modalHead"></h3> 
	            <button type="button" class="close" data-dismiss="modal" aria-label="Close" onClick="modalClose()">
	              <span aria-hidden="true">&times;</span>
	            </button>
	          </div>
	          <div class="modal-body" style="text-align: left;flex: 1;overflow-y: auto;">	          
			    <!-- ================================================================== -->
                <!-- 수정해야 될 곳 start -->
                <!-- 반드시 id는 DTO에 등록 된 것으로 해야됨  input,select,radio 등 -->
                <!-- dataTable의 data 컬럼 id는 반드시 DTO의 컬럼, Modal의 id와 일치해야 함 (입력,수정,삭제시) -->
                <!-- 최대자리, 입력형식은 필요시 사용 -->
                <!-- 기본 text-left 좌측정렬, text-right 오른쪽정렬, text-center 중앙정렬 -->
                <!-- is-invalid,required필드 테두리 붉은색 -->
                <!-- input에서 Enter하면 다음 input으로, 단 required필드에 값이 없으면 focus이동 안함 inputEnterFocus(formId) -->
                <!-- checkbox     ''-선택안함 나머지는 알아서 value값 설정 -->
                <!-- select,radio ''-선택안함 나머지는 알아서 value값 설정 -->
                <!-- 만약, inputZone에서, required, 공백, 자리수등 설정하지 않으면 formValCheck시 반드시 재정의 해야됨 -->
                <!-- number, numeric은  formValCheck Null일 경우 0을 줌 required시 통과 함 -->                
                <!-- ================================================================== -->		          
                <div id="inputZone">                
                	<!-- ============================================================== -->
                    <!-- text input 1개 start -->
                    <!-- ============================================================== -->
                    <div class="form-group row">
                        <label for="input1" class="col-1 col-sm-1 col-form-label text-left">입력 1</label>
                        <div class="col-11 col-sm-11">
                            <input id="fee_code" name="input1" type="text" class="form-control is-invalid text-left" required placeholder="입력하세요 1">
                        </div>
                    </div>
                    <div class="form-group row">
                        <label for="input2" class="col-1 col-sm-1 col-form-label text-left">입력 2</label>
                        <div class="col-11 col-sm-11">
                            <input id="kor_nm" name="input2" type="text" class="form-control text-left" placeholder="입력하세요 2" minlength="3" maxlength="10" >
                        </div>
                        
                    </div>
                    <div class="form-group row">
                        <label for="input3" class="col-1 col-sm-1 col-form-label text-left">입력 3</label>
                        <div class="col-11 col-sm-11">
                            <input id="eng_nm" name="input3" type="text" class="form-control" placeholder="입력하세요 3" maxlength="">
                        </div>
                    </div>
                    <!-- ============================================================== -->
                    <!-- end text input 1개 -->
                    <!-- ============================================================== -->
                    <!-- ============================================================== -->
                    <!-- text input 2개 start -->
                    <!-- ============================================================== -->
                    <div class="form-group row">
                        <label for="input4" class="col-1 col-lg-1 col-form-label text-left">입력 4</label>
                        <div class="col-5 col-lg-5">
                            <input id="input4" name="input4" type="number" class="form-control" placeholder="입력하세요 1" maxlength="" >
                        </div>
                        <label for="input5" class="col-1 col-lg-1 col-form-label text-left">입력 5</label>
                        <div class="col-5 col-lg-5">
                            <input id="input5" name="input5" type="text" class="form-control is-invalid text-left" required placeholder="입력하세요 2" maxlength="">
                        </div>
                    </div>
                    <div class="form-group row">
                        <label for="passwd1" class="col-1 col-lg-1 col-form-label text-left">비밀 1</label>
                        <div class="col-5 col-lg-5">
                            <input id="passwd1" name="passwd1" type="password" class="form-control" placeholder="" maxlength="">
                        </div>
                        <label for="passwd2" class="col-1 col-lg-1 col-form-label text-left">비밀 2</label>
                        <div class="col-5 col-lg-5">
                            <input id="passwd2" name="passwd2" type="password" class="form-control" placeholder="" maxlength="" data-parsley-equalto="#passwd1" >
                        </div>
                    </div>
                    <!-- ============================================================== -->
                    <!-- end text input 2개 -->
                    <!-- ============================================================== -->
                    <!-- ============================================================== -->
                    <!-- mask input 3개 label Top start -->
                    <!-- ============================================================== -->
                    <div class="form-row">
                        <div class="col-xl-4 col-lg-4 mb-2 text-left">
		                    <label for="mask1">날짜 Mask <small class="text-muted"> yyyy-mm-dd</small></label>	                                        
		                    <input id="mask1" name="mask1" type="text" class="form-control date1-inputmask" placeholder="yyyy-mm-dd" maxlength="">
		                </div>
		                <div class="col-xl-4 col-lg-4 mb-2 text-left">
		                    <label for="mask2">핸드폰 Mask <small class="text-muted"> (010)-0000-0000</small></label>	                                        
		                    <input id="mask2" name="mask2" type="text" class="form-control phone-inputmask" placeholder="(010)-0000-0000" maxlength="">
		                </div>
		                <div class="col-xl-4 col-lg-4 mb-2 text-left">
		                    <label for="mask3">메일 1<small class="text-muted"> xxx@xxx.xxx</small></label>	                                        
		                    <input id="mask3" name="mask3" type="text" class="form-control email-inputmask" placeholder="메일주소 예) aaa@bbb.com" maxlength="">
		                </div>
                    </div>
                    <!-- ============================================================== -->
                    <!-- end mask input label Top 3개 -->
                    <!-- ============================================================== -->
                    <!-- ============================================================== -->
                    <!-- 숫자,max자리수 text input 2개 label Top start -->
                    <!-- ============================================================== -->                    
                    <div class="form-row">
		                <div class="col-xl-4 col-lg-4 mb-2 text-left">
		                    <label for="input6">입력 6</label>
		                    <input id="input6" name="input6" type="text" class="form-control" placeholder="시작일자 8자리 예) 20240101" oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');" maxlength="8">
		                </div>
		                <div class="col-xl-4 col-lg-4 mb-2 text-left">
		                    <label for="input7">입력 7</label>	                                        
		                    <input id="input7" name="input7" type="text" class="form-control" placeholder="종료일자 8자리 예) 20240101" oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');" maxlength="8">
		                </div>
                    </div>                    
                    <!-- ============================================================== -->
                    <!-- end 숫자,max자리수 text input label Top 2개 -->
                    <!-- ============================================================== -->
                    <!-- ============================================================== -->
                    <!-- checkbox start -->
                    <!-- ============================================================== -->
                    <div class="form-row">
	                    <div class="col-xl-4 col-lg-4 mb-2">
	                  	    <label class="custom-control custom-checkbox custom-control-inline">
	                               <input id="checkbox1" type="checkbox" name="checkbox1" value = "Y" class="custom-control-input" required><span class="custom-control-label">체크 1</span>
	                           </label>
	                           <label class="custom-control custom-checkbox custom-control-inline">
	                               <input id="checkbox2" type="checkbox" name="checkbox2" value = "Y" class="custom-control-input"><span class="custom-control-label">체크 2</span>
	                           </label>
	                           <label class="custom-control custom-checkbox custom-control-inline">
	                               <input id="checkbox3" type="checkbox" name="checkbox3" value = "Y" class="custom-control-input"><span class="custom-control-label">체크 3</span>
	                           </label>
	                    </div>
	                    <div class="col-xl-4 col-lg-4 mb-2">
	                    	  <label class="custom-control custom-checkbox custom-control-inline">
	                               <input id="checkbox4" type="checkbox" name="checkbox4" checked value = "Y" class="custom-control-input"><span class="custom-control-label">체크 1</span>
	                           </label>
	                           <label class="custom-control custom-checkbox custom-control-inline">
	                               <input id="checkbox5" type="checkbox" name="checkbox5" value = "Y" class="custom-control-input"><span class="custom-control-label">체크 2</span>
	                           </label>
	                           <label class="custom-control custom-checkbox custom-control-inline">
	                               <input id="checkbox6" type="checkbox" name="checkbox6" value = "Y" class="custom-control-input"><span class="custom-control-label">체크 3</span>
	                           </label>
	                    </div>
                    </div>        
                    <!-- ============================================================== -->
                    <!-- end checkbox
                    <!-- ============================================================== -->                  
                    <!-- ============================================================== -->
                    <!-- radio start -->
                    <!-- ============================================================== -->
                    <div class="form-row">
	                    <div class="col-xl-4 col-lg-4 mb-2">
	                        <label class="custom-control custom-radio custom-control-inline">
                                <input id="radio101" type="radio" name="radio1" value = "1" class="custom-control-input" required><span class="custom-control-label">옵션 1</span>
                            </label>
                            <label class="custom-control custom-radio custom-control-inline">
                                <input id="radio102" type="radio" name="radio1" value = "2" class="custom-control-input"><span class="custom-control-label">옵션 2</span>
                            </label>
                            <label class="custom-control custom-radio custom-control-inline">
                                <input id="radio103" type="radio" name="radio1" value = "3" class="custom-control-input"><span class="custom-control-label">옵션 3</span>
                            </label>
	                    </div>
	                    <div class="col-xl-4 col-lg-4 mb-2">
	                    	  <label class="custom-control custom-radio custom-control-inline">
                                <input id="radio201" type="radio" name="radio2" checked value = "1" class="custom-control-input"><span class="custom-control-label">옵션 1</span>
                            </label>
                            <label class="custom-control custom-radio custom-control-inline">
                                <input id="radio202" type="radio" name="radio2" value = "2" class="custom-control-input"><span class="custom-control-label">옵션 2</span>
                            </label>
                            <label class="custom-control custom-radio custom-control-inline">
                                <input id="radio203" type="radio" name="radio2" value = "3" class="custom-control-input"><span class="custom-control-label">옵션 3</span>
                            </label>
	                    </div>
                    </div>
                    <!-- ============================================================== -->
                    <!-- end radio -->
                    <!-- ============================================================== -->
                    <!-- ============================================================== -->
                    <!-- select start -->
                    <!-- ============================================================== -->
                    <div class="form-row">
	                    <div class="col-xl-4 col-lg-4 mb-2">
	                        <select id="select1" name="select1" class="form-control" required>
	                        	<option value=""></option>
	                            <option selected value="1">111</option>
	                            <option value="2">222</option>
	                            <option value="3">333</option>
	                        </select>
	                    </div>
	                    <div class="col-xl-4 col-lg-4 mb-2">
     	                    <select id="select2" name="select2" class="form-control">
     	                    	<option selected value=""></option>
	                            <option value="1">111</option>
	                            <option value="2">222</option>
	                            <option value="3">333</option>
	                        </select>
	                    </div>
	                    <div class="col-xl-4 col-lg-4 mb-2">
     	                    <select id="select3" name="select3" class="form-control">
	                            <option selected value=""></option>
	                            <option value="1">111</option>
	                            <option value="2">222</option>
	                            <option value="3">333</option>
	                        </select>
	                    </div>
                    </div>
                    <!-- ============================================================== -->
                    <!-- end select -->
                    <!-- ============================================================== -->
                    <!-- ============================================================== -->
                    <!-- textarea start -->
                    <!-- ============================================================== -->
                    <div class="form-row">
	                    <div class="col-xl-12 col-lg-12 text-left mb-2">
                  		    <div class="form-group">
                                <label for="textarea1">멀티입력 1</label>
                                <textarea id="textarea1" name="textarea1" type="text"  data-parsley-trigger="change" placeholder="" autocomplete="off" class="form-control" rows="7" ></textarea>
                            </div>    
                        </div>
                    </div>                    
                    <!-- ============================================================== -->
                    <!-- end textarea -->
                    <!-- ============================================================== -->
                    <!-- ============================================================== -->
                    <!-- button start -->
                    <!-- ============================================================== -->                  
                    <div class="form-row">
	                    <div class="col-sm-12 mb-2" style="text-align:right;"> 
	                    	
                            <button id="form_btn_new" type="submit" class="btn btn-outline-light"   onClick="fn_Potion()">센터. <i class="far fa-object-group"></i></button>
                            <button id="form_btn_ins" type="submit" class="btn btn-outline-info"    onClick="fn_Insert()">입력. <i class="far fa-edit"></i></button>
  	   					    <button id="form_btn_udt" type="submit" class="btn btn-outline-success" onClick="fn_Update()">수정. <i class="far fa-save"></i></button>
         				    <button id="form_btn_del" type="submit" class="btn btn-outline-danger"  onClick="fn_Delete()">삭제. <i class="far fa-trash-alt"></i></button>
                        </div>                      
                    </div>
                    <!-- ============================================================== -->
                    <!-- end button -->
                    <!-- ============================================================== -->                  
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
        <!-- ============================================================== -->
        <!-- modal form end -->
        <!-- ============================================================== -->
		<!-- ============================================================== -->
        <!-- Main Form End -->
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
		var firstflag  = true; // 첫음부터 Find하시려면 false를 주면됨
		var findValues = [];
		// 조회조건이 있으면 설정하면됨 / 조건 없으면 막으면 됨
		// 글자수조건 있는건 1개만 설정가능 chk: true 아니면 모두 flase
		// 조회조건은 필요한 만큼 추가사용 하면됨.
		findValues.push({ id: "find_data", val: "입원료",  chk: true  });
		findValues.push({ id: "fee_type",  val: "1", chk: false });
		//Form마다 조회 조건 변경 종료
		
		// 초기값 설정
		var mainFocus = 'find_data'; // Main 화면 focus값 설정, Modal은 따로 Focus 맞춤
		var edit_Data = null;
		var dataTable = new DataTable();
		dataTable.clear();
		
		<!-- ============================================================== -->
		<!-- 공통코드 Setting Start -->
		<!-- ============================================================== -->
		var list_flag = ['Z'];     										// 대표코드, ['Z','X','Y'] 여러개 줄 수 있음
		//  list_code, select_id, firstnull는 갯수가 같아야함. firstnull의 마지막이 'N'이면 생략가능, 하지만 쌍으로 맞추는게 좋음 
		var list_code = ['GASAN_SIK','H010VER','VAC_GB','SUGAGBN'];     // 구분코드 필요한 만큼 선언해서 사용
		var select_id = ['select1','select2','select3','fee_type'];     // 구분코드 데이터 담길 Select (ComboBox ID) 
		var firstnull = ['N','Y','Y','N'];                              // Y 첫번째 Null,이후 Data 담김 / N 바로 Data 담김 
		<!-- ============================================================== -->
		<!-- 공통코드 Setting End -->
		<!-- ============================================================== -->
		
		
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
		var data_Count = [50, 70, 100, 150, 200];  // Data 보기 설정
		var defaultCnt = 100;                      // Data Default 갯수
		
		
		//  DataTable Columns 정의, c_Head_Set, columnsSet갯수는 항상 같아야함.
		var c_Head_Set = [  '수가코드','구분','구분명','한글명','영문명','시작일','종료일'  ];
		var columnsSet = [  // data 컬럼 id는 반드시 DTO의 컬럼,Modal id는 일치해야 함 (조회시)
	        				// name 컬럼 id는 반드시 DTO의 컬럼 일치해야 함 (수정,삭제시), primaryKey로 수정, 삭제함.
	        				// dt-body-center, dt-body-left, dt-body-right	        				
	        				{ data: 'fee_code',    visible: true,  className: 'dt-body-center', width: '100px',  name: 'key_fee_code', primaryKey: true },
							{ data: 'fee_type',    visible: false, className: 'dt-body-center', width: '100px',  name: 'key_fee_type', primaryKey: true },
	        				{ data: 'fee_type_nm', visible: false, className: 'dt-body-center', width: '100px',  },
	        				{ data: 'kor_nm',      visible: true,  className: 'dt-body-left'  , width: '300px',  },
	        				{ data: 'eng_nm',      visible: true,  className: 'dt-body-left'  , width: '300px',  },	        				
	        				// getFormat 사용시 
	        				{ data: 'start_dt',    visible: true,  className: 'dt-body-center', width: '100px',  name: 'key_start_dt', primaryKey: true,
	                          	render: function(data, type, row) {
		            				if (type === 'display') {
		            					return getFormat(data,'d1')
		                			}
		                			return data;
	            				}
	        				},
	        				// getFormat 사용시
					        { data: 'end_dt',      visible: true,  className: 'dt-body-center', width: '100px',    
					            render: function(data, type, row) {
					            	if (type === 'display') {
					            		return getFormat(data,'d1')
					                }
					                return data;
					            }
					        }
						 ];
		
		var s_CheckBox = true;   		           	 // CheckBox 표시 여부
        var s_AutoNums = true;   		             // 자동순번 표시 여부
        
		// 초기 data Sort,  없으면 []
		var muiltSorts = [
							['fee_code', 'asc' ],    // 오름차순 정렬
            				['start_dt', 'desc']     // 내림차순 정렬
        				 ];
        // Sort여부 표시를 일부만 할 때 개별 id, ** 전체 적용은 '_all'하면 됩니다. ** 전체 적용 안함은 []        				 
		var showSortNo = ['fee_code','kor_nm'];                   
		// Columns 숨김 columnsSet -> visible로 대체함 hideColums 보다 먼제 처리됨 ( visible를 선언하지 않으면 hideColums컬럼 적용됨 )	
		var hideColums = ['fee_type','fee_type_nm'];             // 없으면 []; 일부 컬럼 숨길때		
		var txt_Markln = 20;                       				 // 컬럼의 글자수가 설정값보다 크면, 다음은 ...로 표시함
		// 글자수 제한표시를 일부만 할 때 개별 id, ** 전체 적용은 '_all'하면 됩니다. ** 전체 적용 안함은 []
		var markColums = ['kor_nm','eng_nm'];
		var mousePoint = 'pointer';                				 // row 선택시 Mouse모양
		<!-- ============================================================== -->
		<!-- Table Setting End -->
		<!-- ============================================================== -->
		
		window.onload = function() {
			find_Check();
			comm_Check();
			
			// onload후 해야될 내용 추가 Start
			
			
			// onload후 해야될 내용 추가 End
		};
		
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
		            break;
		        case 'U': // Show Update button
		            updateButton.style.display = 'inline-block';
		            break;
		        case 'D': // Show Delete button
		            deleteButton.style.display = 'inline-block';
		            break;
		    }    
			
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
			    /* 선택 Data 삭제 확인 */  
			    //document.querySelector('#button').addEventListener('click', function () {
			    //    table.row('.selected').remove().draw(false);
			    //});  
			    /* 싱글 선택 end */
			    
			    /* 멀티 선택 start */
			    //table.on('click', 'tbody tr', function (e) {
			   	//	e.currentTarget.classList.toggle('selected');
				//});
			    /* 선택 Data 건수 확인 */   
			    //document.querySelector('#button').addEventListener('click', function () {
			    //    alert(table.rows('.selected').data().length + ' row(s) selected');
			    //});
			    /* 멀티 선택 end */
			    
			})(jQuery);
			
		}	   
		
		//ajax 함수 정의
		function dataLoad(data, callback, settings) {
		
			// var table = $(settings.nTable).DataTable();
		    // table.processing(true); // 처리 중 상태 시작
				
		    let find = {};
		            
		   	for (let findValue of findValues) {
		   		find[findValue.id] = findValue.val;
		   	}	
		    $.ajax({
		        type: "POST",
		        url: "/suga/sugaList.do",
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
		function fn_Insert(){
			// 1. form (input, select, textarea Element 및 Value 확인
			// key는 (반드시 Field id로 넣어야 됨) !!!!!!!!!!!!!!!!!!!!!!			
			// { 
			//   kname(Message 처리시 재정의된 kname로 표시됨),  
			//	 k_len(자리수),      k_min(최소자릿수), k_max(최대자리수), 
			//	 k_req(반드시입력확인), k_num(숫자만입력), k_spc(공백확인), k_clr(입력값Clear), 
			//   k_chr(제거문자)
			// };
			const results = formValCheck(inputZone.id, {
				// 반드시 모든것을 재정의 할 필요없음 정의하지 않은것은 사용하지 않음
				// kname은 사용자가 인식 할 수 있는 명칭을 넣으면 됩니다.		 
		  		// fee_code:  { kname: "입력 1",  k_min: 3, k_max: 10, k_req: true, k_spc: true, k_clr:true },
		  		// input3:  { kname: "입력 3",  k_num: true, k_min: 3, k_max: 10, k_req: true },
		  		// input4:  { kname: "입력 4",  k_num: true, k_clr: true },
		  		// input5:  { kname: "입력 5",  k_req: true, k_clr:true },  		
		  		// mask1:   { kname: "마스크1",  k_len: 8,  k_req: true,  k_chr: "-" },
		  		// mask2:   { kname: "마스크2",  k_len: 11, k_req: true,  k_chr: "()-" },
		  		// checkbox_21: { kname: "두번째선택", k_req: true },
		  		// select2: { kname: "관리자여부", k_req: true }
			});
			if (results)
			{
				let dats = [];
				let data = {};
			    for (let result of results) {	    	
			        data[result.id] = result.val;
			    }
			    dats.push(data);	    
			    $.ajax({
			            type: "POST",
			            url: "/suga/sugaInsert.do",
			            data: JSON.stringify(dats),
			            contentType: "application/json",
			    	    dataType: "json",
			            success: function(response) {
			            	// checkbox, 자동순번은 넣지 않습니다.
			            	// *******단, 나머지 컬럼은 반드시 기술해야 합니다. 
			            	let newData = {
						        fee_code:    $('#fee_code').val(),
						        fee_type:    '',
						        fee_type_nm: '',
						        kor_nm:      $('#kor_nm').val(),
						        eng_nm:      $('#eng_nm').val(),
						        start_dt:    '',
						        end_dt:      ''
						    };
			            	dataTable.row.add(newData).draw(false);
			            	
			            	messageBox("1","<h5> 정상처리 되었습니다 ...... </h5><p></p><br>",mainFocus,"","");	            	
			            	$("#" + modalName.id).modal('hide');
			            	
			        	},
			        	error: function(xhr, status, error) {
			        		messageBox("5","<h5>서버에 문제가 발생했습니다.</h5>" +  
		                               "<h6>잠시후 다시, 시도해주십시요. !!</h6>",mainFocus,"","");
			        	}
			    });
			}
		}
		// Modal Form에서 수정
		function fn_Update(){
			// 1. form (input, select, textarea Element 및 Value 확인
			// key는 (반드시 Field id로 넣어야 됨) !!!!!!!!!!!!!!!!!!!!!!			
			// { 
			//   kname(Message 처리시 재정의된 kname로 표시됨),  
			//	 k_len(자리수),      k_min(최소자릿수), k_max(최대자리수), 
			//	 k_req(반드시입력확인), k_num(숫자만입력), k_spc(공백확인), k_clr(입력값Clear), 
			//   k_chr(제거문자)
			// };
			const results = formValCheck(inputZone.id, {
				// 반드시 모든것을 재정의 할 필요없음 정의하지 않은것은 사용하지 않음
				// kname은 사용자가 인식 할 수 있는 명칭을 넣으면 됩니다.		 
		  	    // fee_code:  { kname: "입력 1",  k_min: 3, k_max: 10, k_req: true, k_spc: true, k_clr:true },
		  		// input3:  { kname: "입력 3",  k_num: true, k_min: 3, k_max: 10, k_req: true },
		  		// input4:  { kname: "입력 4",  k_num: true, k_clr: true },
		  		// input5:  { kname: "입력 5",  k_req: true, k_clr:true },  		
		  		// mask1:   { kname: "마스크1",  k_len: 8,  k_req: true,  k_chr: "-" },
		  		// mask2:   { kname: "마스크2",  k_len: 11, k_req: true,  k_chr: "()-" },
		  		// checkbox_21: { kname: "두번째선택", k_req: true },
		  		// select2: { kname: "관리자여부", k_req: true }
			});
			if (results)
			{	
				let dats = [];
				let data = {};
			    for (let result of results) {	    	
			        data[result.id] = result.val;
			    }
			    dats.push(data);
			 	// (수정.삭제 primaryKey로 조회)			
			    // primaryKey로 설정된 컬럼 찾기 
				var selectedRows = dataTable.rows('.selected');
				let keys = dataTableKeys(dataTable, selectedRows);
				let mergeData = keys.map(key => ({ ...dats, ...key }));
			    $.ajax({
			    	 type: "POST",
			    	    url: "/suga/sugaUpdate.do",	    	    
			    	    data: JSON.stringify(mergeData),	    	    
			    	    contentType: "application/json",
			    	    dataType: "json",
			            success: function(response) {
			            	// checkbox, 자동순번은 넣지 않습니다.
			            	// 수정할 컬럼만 기술하며 됨 
			            	let updatedData = {
			            		fee_code: $('#fee_code').val(),
			            		kor_nm:   $('#kor_nm').val(),
			            		eng_nm:   $('#eng_nm').val()
			            		};			            	
			            	selectedRows.every(function(rowIdx) {
			            		let rowData = this.data();
			            	    Object.keys(updatedData).forEach(function(key) {
			            	      rowData[key] = updatedData[key];
			            	    });
			            	    this.data(rowData);
			            	});
			            	dataTable.draw(false);
			            	
			            	$("#" + modalName.id).modal('hide');
			            	messageBox("1","<h5> 정상처리 되었습니다 ...... </h5><p></p><br>",mainFocus,"","");
			            	
			        	},
			        	error: function(xhr, status, error) {
			        	    messageBox("5","<h5>서버에 문제가 발생했습니다.</h5>" +  
		                               "<h6>잠시후 다시, 시도해주십시요. !!</h6>",mainFocus,"","");
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
			Swal.fire({title:'삭제여부',text:'정말 삭제 하시겠습니까 ?',icon:'question',showCancelButton:true,confirmButtonText:'예',cancelButtonText:'아니오'}).then((result) => {
				// 사용자가 '예' 버튼을 클릭한 경우
				if (result.isConfirmed) {
					// (수정.삭제 primaryKey로 조회)			
				    // primaryKey로 설정된 컬럼 찾기 
					var selectedRows = dataTable.rows('.selected');
					let keys = dataTableKeys(dataTable, selectedRows);
					if (keys.length > 0) {	        	
						$.ajax({
				            type: "POST",
				            url: "/suga/sugaDelete.do",	    	    
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
						            showConfirmButton: false
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
						            showConfirmButton: false
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
				            showConfirmButton: false
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
			            showConfirmButton: false
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
			Swal.fire({title:'삭제여부',text:'정말 삭제 하시겠습니까 ?',icon:'question',showCancelButton:true,confirmButtonText:'예',cancelButtonText:'아니오'}).then((result) => {
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
				            url: "/suga/sugaDelete.do",	    	    
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
						            showConfirmButton: false
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
						            showConfirmButton: false
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
				            showConfirmButton: false
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
			            showConfirmButton: false
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
				    url: "/suga/commList.do",    
				    data: {
				        list_gb: list_flag,
				        list_cd: list_code
				    },
				    dataType: "json",
				 	
				    beforeSend : function () {
				    	
					},
				    success: function(response) {
				   	
				        const commList = response.data || [];
				        
				        for (var i = 0; i < select_id.length; i++) {
				            
				        	let select = $('#' + select_id[i]);
				            select.empty();
				            
				            let filteredItems = commList.filter(item => item.code_cd === list_code[i]);
				            
				            if (filteredItems.length > 0) {
				            	if (firstnull[i] === "Y")
				            		select.append('<option value=""></option>');
				            		
				            	filteredItems.forEach(function (item) {
				                    select.append('<option value=' + item.sub_code + '>' + item.sub_code_nm + '</option>');
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
		</script>
		<!-- ============================================================== -->
		<!-- 기타 정보 End -->
		<!-- ============================================================== -->

		