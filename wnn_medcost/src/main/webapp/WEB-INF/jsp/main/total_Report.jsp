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
			    		<div class="col-lg-6">
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
								            <button class="btn btn-outline-success btn-block btn-sm d-flex align-items-center justify-content-center mb-2" onClick="fn_CreateData_all('00')">《 전체 대상 점검 》</button>								                        
								        </div>
								        <div class="col-lg-6">
								            <button data-action="FindView" data-value="accordion_item_1" class="btn btn-outline-primary text-black btn-block btn-sm d-flex align-items-center justify-content-center mb-2" onClick="fn_CreateData('01')">요양병원 입원료 차등제 / 식대가산 점검</button>
								            <button data-action="FindView" data-value="accordion_item_2" class="btn btn-outline-primary text-black btn-block btn-sm d-flex align-items-center justify-content-center mb-2" onClick="fn_CreateData('02')">월별 정액수가 분포율【 환자평가표 】</button>            
								        </div>
								        <div class="col-lg-6">
								        	<button data-action="FindView" data-value="accordion_item_7" class="btn btn-outline-primary text-black btn-block btn-sm d-flex align-items-center justify-content-center mb-2" onClick="fn_CreateData('07')">특정기간 현황【 격리실 】</button>            
								            <button data-action="FindView" data-value="accordion_item_8" class="btn btn-outline-primary text-black btn-block btn-sm d-flex align-items-center justify-content-center mb-2" onClick="fn_CreateData('08')">한방「입원」월별 청구현황</button>
								            
								        </div>
								        <div class="col-lg-6">
								            <button data-action="FindView" data-value="accordion_item_3" class="btn btn-outline-primary text-black btn-block btn-sm d-flex align-items-center justify-content-center mb-2" onClick="fn_CreateData('03')">환자군별 상향 가능 대상자 명단</button>
								            <button data-action="FindView" data-value="accordion_item_4" class="btn btn-outline-primary text-black btn-block btn-sm d-flex align-items-center justify-content-center mb-2" onClick="fn_CreateData('04')">월별 청구현황【 장기요양 + 특정기간 】</button>
								            
								            
								        </div>
								        <div class="col-lg-6">
								        	<button data-action="FindView" data-value="accordion_item_A" class="btn btn-outline-primary text-black btn-block btn-sm d-flex align-items-center justify-content-center mb-2" onClick="fn_CreateData('09')">재활치료 청구현황</button>
								            <button data-action="FindView" data-value="accordion_item_B" class="btn btn-outline-primary text-black btn-block btn-sm d-flex align-items-center justify-content-center mb-2" onClick="fn_CreateData('10')">투석치료 청구현황</button>
								        </div>
								        <div class="col-lg-6">
								        	<button data-action="FindView" data-value="accordion_item_5" class="btn btn-outline-primary text-black btn-block btn-sm d-flex align-items-center justify-content-center mb-2" onClick="fn_CreateData('05')">특정기간【 폐렴,패혈증,격리실,중환자실 】</button>
								        	<button data-action="FindView" data-value="accordion_item_6" class="btn btn-outline-primary text-black btn-block btn-sm d-flex align-items-center justify-content-center mb-2" onClick="fn_CreateData('06')">특정기간 현황【 폐렴, 패혈증 】</button>
								            
								        </div>
								        <div class="col-lg-6">
								        	<button data-action="FindView" data-value="accordion_item_C" class="btn btn-outline-primary text-black btn-block btn-sm d-flex align-items-center justify-content-center mb-2" onClick="fn_CreateData('11')">검사료 현황</button>
								            <button data-action="FindView" data-value="accordion_item_D" class="btn btn-outline-primary text-black btn-block btn-sm d-flex align-items-center justify-content-center mb-2" onClick="fn_CreateData('12')">약제료 현황</button>
								        </div>								        
								        <div class="col-lg-6">
								        	<button data-action="FindView" data-value="accordion_item_F" class="btn btn-outline-primary text-black btn-block btn-sm d-flex align-items-center justify-content-center mb-2" onClick="fn_CreateData('14')">특정 진료비</button>
								        </div>
								        <div class="col-lg-6">
								        	<button data-action="FindView" data-value="accordion_item_E" class="btn btn-info            text-white btn-block btn-sm d-flex align-items-center justify-content-center mb-2" onClick="fn_CreateData('13')">《 입원현황기준 누락 대상자 보기 》</button>
								        </div>
								    </div>
								    <br>
								    <div id="accordion-eleven" class="accordion accordion-header-bg accordion-rounded-stylish accordion-header-shadow accordion-bordered">
	                                    <div  id="accordion_item_1" class="accordion__item">
	                                        <div class="accordion__header accordion__header--winner text-center" data-toggle="collapse" data-target="#rounded-stylish_collapse" >
	                                            <span class="accordion__header--icon"></span>
	                                            <span class="accordion__header--text"></span>
	                                            <span class="accordion__header--indicator"></span>
	                                        </div>
	                                        <div id="rounded-stylish_collapse" class="collapse accordion__body" data-parent="#accordion-eleven">
	                                            <div class="accordion__body--text">
	                                            	<div class="input-group-append mb-1">
	                                            	    <div class="row w-100 justify-content-between align-items-center">
        													<label id="lab_text" class="text-right ml-auto mb-0 small">[ 건 ] / 청구금액</label>
    													</div>
                                    				</div>
	                                                <div id="grid-container1"></div>
								                    <div class="form-row">
									                    <div class="col-xl-12 col-lg-12 text-left mb-1">
								                  	        <div class="form-group">
								                                <label for="textarea1"></label>
								                                <textarea id="textarea1" name="textarea1" type="text"  data-parsley-trigger="change" placeholder="" autocomplete="off" class="form-control" rows="4"  readonly></textarea>
								                            </div>    
								                        </div>
								                    </div>   
	                                            </div>
	                                        </div>
	                                    </div>
	                                </div>
								</div> 	                            
	                        </div>
	                    </div>
	                    
	                    <div class="col-lg-6">
	                    
		                    <div class="card" id="card_container1" style="height: 1100px; display:none">
							    
							    <div class="card-header d-block justify-content-between align-items-top">
							        <h5 class="text-left mb-1">차등제 자료 등록 Part Ⅰ</h5>
							        <div style="width: 100%;">							    
								    	<div class="form-row">
								    	    <label for="doc_grd" class="col-3 col-sm-3 col-form-label text-right">의사등급</label>
						                    <div class="col-xl-3 col-lg-3 mb-1">
						                        <select id="doc_grd" name="doc_grd"  class="form-control" required>
						                        	<option selected value="1">1 등급</option>
						                            <option value="2">2 등급</option>
						                            <option value="3">3 등급</option>
						                            <option value="4">4 등급</option>
						                            <option value="5">5 등급</option>
						                            <option value="6">6 등급</option>
						                        </select>
						                    </div>
						                    <label for="nur_grd" class="col-2 col-sm-2 col-form-label text-right">간호등급</label>
						                    <div class="col-xl-3 col-lg-3 mb-1">
					     	                    <select id="nur_grd" name="nur_grd" class="form-control">
					     	                    	<option selected value="1">1 등급</option>
						                            <option value="2">2 등급</option>
						                            <option value="3">3 등급</option>
						                            <option value="4">4 등급</option>
						                            <option value="5">5 등급</option>
						                            <option value="6">6 등급</option>
						                        </select>
						                    </div>
						                    <label for="nur_cnt" class="col-3 col-sm-3 col-form-label text-right">간호사수대간호인력가산</label>
						                    <div class="col-xl-3 col-lg-3 mb-1">
						                        <select id="nur_cnt" name="nur_cnt"  class="form-control" required>
						                        	<option selected value="1">미감산</option>
						                            <option value="2">감산</option>
						                        </select>
						                    </div>
						                    <label for="need_ga" class="col-2 col-sm-2 col-form-label text-right">필요인력수 가산</label>
						                    <div class="col-xl-3 col-lg-3 mb-1">
					     	                    <select id="need_ga" name="need_ga" class="form-control">
					     	                    	<option selected value="1">가산</option>
						                            <option value="2">미가산</option>
						                        </select>
						                    </div>
						                    <label for="dietga1" class="col-3 col-sm-3 col-form-label text-right">영양사가산</label>
						                    <div class="col-xl-3 col-lg-3 mb-1">
						                        <select id="dietga1" name="dietga1"  class="form-control" required>
						                        	<option selected value="1">가산</option>
						                            <option value="2">미가산</option>
						                        </select>
						                    </div>
						                    <label for="dietga2" class="col-2 col-sm-2 col-form-label text-right">조리사가산</label>
						                    <div class="col-xl-3 col-lg-3 mb-1">
					     	                    <select id="dietga2" name="dietga2" class="form-control">
					     	                    	<option selected value="1">가산</option>
						                            <option value="2">미가산</option>
						                        </select>
						                    </div>
						                    <label for="dietga3" class="col-3 col-sm-3 col-form-label text-right">직영가산</label>
						                    <div class="col-xl-3 col-lg-3 mb-1">
						                        <select id="dietga3" name="dietga3"  class="form-control" required>
						                        	<option selected value="1">가산</option>
						                            <option value="2">미가산</option>
						                        </select>
						                    </div>
						                    <label for="dietga4" class="col-2 col-sm-2 col-form-label text-right">치료식 영양관리</label>
						                    <div class="col-xl-3 col-lg-3 mb-1">
					     	                    <select id="dietga4" name="dietga4" class="form-control">
					     	                    	<option selected value="1">가산</option>
						                            <option value="2">미가산</option>
						                        </select>
						                    </div>
						                    
					                    </div>
					                    <!-- ============================================================== -->
					                    <!-- button start -->
					                    <!-- ============================================================== -->                  
					                    <div class="form-row">
						                    <div class="col-sm-11 mb-1 text-right">
					  	   					    <button id="form_btn_udt" class="btn btn-outline-primary" onClick="fn_Update()">차등제 · 저장하기 · <i class="far fa-save"></i></button>
					                        </div>                      
					                    </div>
					                    <!-- ============================================================== -->
					                    <!-- end button -->
					                    <!-- ============================================================== --> 
                    												    	
									</div>
							    </div>
							    
							    <!-- 라인 1줄 생성 -->
							    <hr style="margin: 0; border-top: 2px solid #ccc;">
							    <div class="card-header11">
							        <h5 class="text-left ml-3 mb-1">식대 점검 대상 Part Ⅱ</h5>
						        	
						        	<table id="tableName01" class="display nowrap stripe hover cell-border  order-column responsive mb-1">
															       
									</table>
									
							    </div>
							    
							    
							</div>
							
							<div class="card" id="card_container2" style="height: 1100px; display: none;">
							    <div class="card-header11 d-flex justify-content-between align-items-top">
							        <h5 class="ml-3 mb-1">타병원 대비 환자군 비교 Part Ⅰ</h5> 
							        <div class="legend-container mr-3">
							            <div class="legend-item">
							                <span class="legend-box current-month2"></span>
							                <span class="legend-text">타병원</span>
							            </div>
							            <div class="legend-item">
							                <span class="legend-box previous-month2"></span>
							                <span class="legend-text">본원</span>
							            </div>
							        </div>
							    </div>
							    <div class="card-body11">
							        <div id="cchart_category" style="max-height: 300px;">
							            <!--  <div id="morris-bar-chart2" ></div> -->
							            <canvas id="mixedChart21" style="width: 100%; height: 250px; padding: 20px 20px; "></canvas>						            
							        </div>   
							    </div>
							    <!-- 라인 1줄 생성 -->			    
							    <hr style="margin: 0; border-top: 2px solid #ccc;">
							    <div class="card-header11">
							        <h5 class="text-left ml-3 mb-1">환자군 대상 Part Ⅱ</h5>
							       
							        <div style="width: 100%;">							    
								    	<table id="tableName02" class="display nowrap stripe hover cell-border  order-column responsive mb-1">
								        
								    	</table>
									</div>
									
							    </div>
							</div>
							
							<div class="card" id="card_container3" style="height: 1100px; display: none;">
							    <div class="card-header11 d-flex justify-content-between align-items-top">
							        <h5 class="ml-3 mb-1">환자군 상향 가능 대상자 명단 Part Ⅰ</h5>
							    </div>
							    <br>
							    <!-- 라인 1줄 생성 -->
							    <hr style="margin: 0; border-top: 2px solid #ccc;">
							    <div class="card-header11">						        
						        	
						        	<table id="tableName03" class="display nowrap stripe hover cell-border  order-column responsive mb-1">
															       
									</table>
									
							    </div>
							</div>
						
							<div class="card" id="card_container4" style="height: 1100px; display: none;">
							    <div class="card-header11 d-flex justify-content-between align-items-top">
							        <h5 class="ml-3 mb-1">타병원 대비 본원 건당진료비 비교 · 본원 3개월 일당진료비 그래프 Part Ⅰ</h5> 
							        <div class="legend-container mr-3">
							            <div class="legend-item">
							                <span class="legend-box current-month2"></span>
							                <span class="legend-text">타병원</span>
							            </div>
							            <div class="legend-item">
							                <span class="legend-box previous-month2"></span>
							                <span class="legend-text">본원</span>
							            </div>
							        </div>
							    </div>
							    <div class="card-body11">
							        <div id="cchart_category" style="max-height: 300px; display: flex; gap: 10px;">
								        <div style="flex: 6; padding: 20px 20px; ">
										    <canvas id="mixedChart41" style="width: 100%; height: 250px;"></canvas>
										</div>
										<div style="flex: 4; padding: 20px 20px; ">
										    <canvas id="mixedChart42" style="width: 100%; height: 250px;"></canvas>
										</div>
								    </div>    
							    </div>
							    <!-- 라인 1줄 생성 -->
							    <hr style="margin: 0; border-top: 2px solid #ccc;">
							    <div class="card-header11">
							        <h5 class="text-left ml-3 mb-1">청구현황 대상 Part Ⅱ</h5>
						        	
						        	<table id="tableName04" class="display nowrap stripe hover cell-border  order-column responsive mb-1">
															       
									</table>
									
							    </div>
							</div>
	                    	<div class="card" id="card_container5" style="height: 1100px; display: none;">
							    <div class="card-header11 d-flex justify-content-between align-items-top">
							        <h5 class="ml-3 mb-1">타병원 대비 본원 건당진료비 비교 · 본원 3개월 일당진료비 그래프 Part Ⅰ</h5> 
							        <div class="legend-container mr-3">
							            <div class="legend-item">
							                <span class="legend-box current-month2"></span>
							                <span class="legend-text">타병원</span>
							            </div>
							            <div class="legend-item">
							                <span class="legend-box previous-month2"></span>
							                <span class="legend-text">본원</span>
							            </div>
							        </div>
							    </div>
							    <div class="card-body11">
							        <div id="cchart_category" style="max-height: 300px; display: flex; gap: 10px;">
								        <div style="flex: 6; padding: 20px 20px; ">
								            <canvas id="mixedChart51" style="width: 100%; height: 250px;"></canvas>
								        </div>
								        <div style="flex: 4; padding: 20px 20px; ">
								            <canvas id="mixedChart52" style="width: 100%; height: 250px;"></canvas>
								        </div>
								    </div>     
							    </div>
							    <!-- 라인 1줄 생성 -->
							    <hr style="margin: 0; border-top: 2px solid #ccc;">
							    <div class="card-header11">
							        <h5 class="text-left ml-3 mb-1">특정기간 대상 Part Ⅱ</h5>
						        	
						        	<table id="tableName05" class="display nowrap stripe hover cell-border  order-column responsive mb-1">
															       
									</table>
									
							    </div>
							</div>
							<div class="card" id="card_container6" style="height: 1100px; display: none;">
							    <div class="card-header11 d-flex justify-content-between align-items-top">
							        <h5 class="ml-3 mb-1">타병원 대비 본원 건당진료비 비교 · 본원 3개월 일당진료비 그래프 Part Ⅰ</h5> 
							        <div class="legend-container mr-3">
							            <div class="legend-item">
							                <span class="legend-box current-month2"></span>
							                <span class="legend-text">타병원</span>
							            </div>
							            <div class="legend-item">
							                <span class="legend-box previous-month2"></span>
							                <span class="legend-text">본원</span>
							            </div>
							        </div>
							    </div>
							    <div class="card-body11">
							         <div id="cchart_category" style="max-height: 300px; display: flex; gap: 10px;">
							            <div style="flex: 6; padding: 20px 20px; ">
								            <canvas id="mixedChart61" style="width: 100%; height: 250px;"></canvas>
								        </div>
								        <div style="flex: 4; padding: 20px 20px; ">
								            <canvas id="mixedChart62" style="width: 100%; height: 250px;"></canvas>
								        </div>
							        </div>   
							    </div>
							    <!-- 라인 1줄 생성 -->
							    <hr style="margin: 0; border-top: 2px solid #ccc;">
							    <div class="card-header11">
							        <h5 class="text-left ml-3 mb-1">특정기간 대상 Part Ⅱ</h5>
						        	 
						        	<table id="tableName06" class="display nowrap stripe hover cell-border  order-column responsive mb-1">
															       
									</table>
									
							    </div>
							</div>
							<div class="card" id="card_container7" style="height: 1100px; display: none;">
							    <div class="card-header11 d-flex justify-content-between align-items-top">
							        <h5 class="ml-3 mb-1">타병원 대비 본원 건당진료비 비교 · 본원 3개월 일당진료비 그래프 Part Ⅰ</h5> 
							        <div class="legend-container mr-3">
							            <div class="legend-item">
							                <span class="legend-box current-month2"></span>
							                <span class="legend-text">타병원</span>
							            </div>
							            <div class="legend-item">
							                <span class="legend-box previous-month2"></span>
							                <span class="legend-text">본원</span>
							            </div>
							        </div>
							    </div>
							    <div class="card-body11">
							        <div id="cchart_category" style="max-height: 300px; display: flex; gap: 10px;">
							            <div style="flex: 6; padding: 20px 20px; ">
								            <canvas id="mixedChart71" style="width: 100%; height: 250px;"></canvas>
								        </div>
								        <div style="flex: 4; padding: 20px 20px; ">
								            <canvas id="mixedChart72" style="width: 100%; height: 250px;"></canvas>
								        </div>
							        </div>    
							    </div>
							    <!-- 라인 1줄 생성 -->
							    <hr style="margin: 0; border-top: 2px solid #ccc;">
							    <div class="card-header11">
							        <h5 class="text-left ml-3 mb-1">특정기간 대상 Part Ⅱ</h5>
						        	
						        	<table id="tableName07" class="display nowrap stripe hover cell-border  order-column responsive mb-1">
															       
									</table>
									
							    </div>
							</div>
							<div class="card" id="card_container8" style="height: 1100px; display: none;">
							    <div class="card-header11 d-flex justify-content-between align-items-top">
							        <h5 class="ml-3 mb-1">타병원 대비 본원 건당진료비 비교 · 본원 3개월 일당진료비 그래프 Part Ⅰ</h5> 
							        <div class="legend-container mr-3">
							            <div class="legend-item">
							                <span class="legend-box current-month2"></span>
							                <span class="legend-text">타병원</span>
							            </div>
							            <div class="legend-item">
							                <span class="legend-box previous-month2"></span>
							                <span class="legend-text">본원</span>
							            </div>
							        </div>
							    </div>
							    <div class="card-body11">
							        <div id="cchart_category" style="max-height: 300px; display: flex; gap: 10px;">
							        	<canvas id="mixedChart81" style="width: 100%; height: 250px; padding: 20px 20px; "></canvas>
							        </div>  
							    </div>
							    <!-- 라인 1줄 생성 -->
							    <hr style="margin: 0; border-top: 2px solid #ccc;">
							    <div class="card-header11">
							        <h5 class="text-left ml-3 mb-1">한방입원 대상 Part Ⅱ</h5>
						        	 
						        	<table id="tableName08" class="display nowrap stripe hover cell-border  order-column responsive mb-1">
															       
									</table>
									
							    </div>
							</div>
							<div class="card" id="card_containerA" style="height: 1100px; display: none;">
							    <div class="card-header11 d-flex justify-content-between align-items-top">
							        <h5 class="ml-3 mb-1">타병원 대비 본원 재활청구 비교 그래프 Part Ⅰ</h5> 
							        <div class="legend-container mr-3">
							            <div class="legend-item">
							                <span class="legend-box current-month2"></span>
							                <span class="legend-text">타병원</span>
							            </div>
							            <div class="legend-item">
							                <span class="legend-box previous-month2"></span>
							                <span class="legend-text">본원</span>
							            </div>
							        </div>
							    </div>
							    <div class="card-body11">
							        <div id="cchart_category" style="max-height: 300px;"> 
							            <!-- <div id="morris-bar-chartA" ></div> -->
							            <canvas id="mixedChartA1" style="width: 100%; height: 250px;  padding: 20px 20px; "></canvas>
							        </div>   
							    </div>
							    <!-- 라인 1줄 생성 -->
							    <hr style="margin: 0; border-top: 2px solid #ccc;">
							    <div class="card-header11">
							        <h5 class="text-left ml-3 mb-1">재활처방 대상자 Part Ⅱ</h5>
							        
						        	<table id="tableName09" class="display nowrap stripe hover cell-border  order-column responsive mb-1">
															       
									</table>
							    </div>
							</div>
	                        <div class="card" id="card_containerB" style="height: 1100px; display: none;">
							    <div class="card-header11 d-flex justify-content-between align-items-top">
							        <h5 class="ml-3 mb-1">타병원 대비 본원 투석청구 비교 그래프 Part Ⅰ</h5> 
							        <div class="legend-container mr-3">
							            <div class="legend-item">
							                <span class="legend-box current-month2"></span>
							                <span class="legend-text">타병원</span>
							            </div>
							            <div class="legend-item">
							                <span class="legend-box previous-month2"></span>
							                <span class="legend-text">본원</span>
							            </div>
							        </div>
							    </div>
							    <div class="card-body11">
							        <div id="cchart_category" style="max-height: 300px;"> 
							            <!-- <div id="morris-bar-chartB" ></div> -->
							            <canvas id="mixedChartB1" style="width: 100%; height: 250px;  padding: 20px 20px; "></canvas>
							        </div>   
							    </div>
							    <!-- 라인 1줄 생성 -->
							    <hr style="margin: 0; border-top: 2px solid #ccc;">
							    <div class="card-header11">
							        <h5 class="text-left ml-3 mb-1">투석처방 대상자 Part Ⅱ</h5>
						        	
						        	<table id="tableName10" class="display nowrap stripe hover cell-border  order-column responsive mb-1">
															       
									</table>
							    </div>
							</div>
							<div class="card" id="card_containerC" style="height: 1100px; display: none;">
							    <div class="card-header11 d-flex justify-content-between align-items-top">
							        <h5 class="ml-3 mb-1">검사료 산정현황 비교 Part Ⅰ</h5> 
							        <div class="legend-container mr-3">
							        
							        	<div class="legend-item">
							                <span class="legend-box current-month"></span>
							                <span class="legend-text">총진료비</span>
							            </div>
							        	<div class="legend-item">
							                <span class="legend-box previous-month"></span>
							                <span class="legend-text">총검사료</span>
							            </div>
							            <div class="legend-item">
							                <span class="legend-box current-month4"></span>
							                <span class="legend-text">정액금액</span>
							            </div>
							            <div class="legend-item">
							                <span class="legend-box previous-month2"></span>
							                <span class="legend-text">행위금액</span>
							            </div>
							            <div class="legend-item">
							                <span class="legend-box current-month3"></span>
							                <span class="legend-text">원내검사</span>
							            </div>
							            <div class="legend-item">
							                <span class="legend-box previous-month3"></span>
							                <span class="legend-text">위탁검사</span>
							            </div>
							        </div>
							    </div>
							    
							    <br>
							    <div class="card-body11">
								    <div class="row">
								        <div class="col-xl-3 col-lg-3 col-md-3 col-sm-3 col-3">
								            <div id="morris-bar-chartC1" class="morris_chart_height"></div>
								        </div>
								        <div class="col-xl-3 col-lg-3 col-md-3 col-sm-3 col-3">
								            <div id="morris-bar-chartC2" class="morris_chart_height"></div>
								        </div>
								        <div class="col-xl-3 col-lg-3 col-md-3 col-sm-3 col-3">
								            <div id="morris-bar-chartC3" class="morris_chart_height"></div>
								        </div>
								        <div class="col-xl-3 col-lg-3 col-md-3 col-sm-3 col-3">
								            <div id="morris-bar-chartC4" class="morris_chart_height"></div>
								        </div>
								   </div>     
								</div>   
							    <br>
							    <!-- 라인 1줄 생성 -->
							    <hr style="margin: 0; border-top: 2px solid #ccc;">
							    <div class="card-header11">
							        <h5 class="text-left ml-3 mb-1">검사료 대상자 Part Ⅱ</h5>
						        	
						        	<table id="tableName11" class="display nowrap stripe hover cell-border  order-column responsive mb-1">
															       
									</table>
							    </div>
							</div>
							<div class="card" id="card_containerD" style="height: 1100px; display: none;">
							    <div class="card-header11 d-flex justify-content-between align-items-top">
							        <h5 class="ml-3 mb-1">약재료 산정현황 비교 Part Ⅰ</h5> 
							        <div class="legend-container mr-3">
							           <div class="legend-item">
							                <span class="legend-box current-month"></span>
							                <span class="legend-text">총진료비</span>
							            </div>							            
							           <div class="legend-item">
							                <span class="legend-box previous-month"></span>
							                <span class="legend-text">총약제비</span>
							            </div>
							            <div class="legend-item">
							                <span class="legend-box current-month4"></span>
							                <span class="legend-text">정액금액</span>
							            </div>
							            <div class="legend-item">
							                <span class="legend-box previous-month2"></span>
							                <span class="legend-text">행위금액</span>
							            </div>
							            <div class="legend-item">
							                <span class="legend-box current-month3"></span>
							                <span class="legend-text">경구약제</span>
							            </div>
							            <div class="legend-item">
							                <span class="legend-box previous-month3"></span>
							                <span class="legend-text">주사약제</span>
							            </div>
							        </div>
							    </div>
							    <br>
							    <div class="card-body11">
								    <div class="row">
								        <div class="col-xl-3 col-lg-3 col-md-3 col-sm-3 col-3">
								            <div id="morris-bar-chartD1" class="morris_chart_height"></div>
								        </div>
								        <div class="col-xl-3 col-lg-3 col-md-3 col-sm-3 col-3">
								            <div id="morris-bar-chartD2" class="morris_chart_height"></div>
								        </div>
								        <div class="col-xl-3 col-lg-3 col-md-3 col-sm-3 col-3">
								            <div id="morris-bar-chartD3" class="morris_chart_height"></div>
								        </div>
								        <div class="col-xl-3 col-lg-3 col-md-3 col-sm-3 col-3">
								            <div id="morris-bar-chartD4" class="morris_chart_height"></div>
								        </div>
								   </div>     
								</div>   
							    <br>
							    <!-- 라인 1줄 생성 -->
							    <hr style="margin: 0; border-top: 2px solid #ccc;">
							    <div class="card-header11">
							        <h5 class="text-left ml-3 mb-1">약재료 대상자 Part Ⅱ</h5>
						        	
						        	<table id="tableName12" class="display nowrap stripe hover cell-border  order-column responsive mb-1">
															       
									</table>
							    </div>
							</div>
							
							<div class="card" id="card_containerE" style="height: 1100px; display: none;">
							    <div class="card-header11 d-flex justify-content-between align-items-top">
							        <h5 class="ml-3 mb-1">입원현황 대비 누락대상자 명단 Part Ⅰ</h5>
							    </div>
							    <br>
							    <!-- 라인 1줄 생성 -->
							    <hr style="margin: 0; border-top: 2px solid #ccc;">
							    <div class="card-header11">							        
						        	 
						        	<table id="tableName13" class="display nowrap stripe hover cell-border  order-column responsive mb-1">
															       
									</table>
									
							    </div>
							</div> 
							
							<div class="card" id="card_containerF" style="height: 1100px; display: none;">
							    <div class="card-header11 d-flex justify-content-between align-items-top">
							        <h5 class="ml-3 mb-1">타병원 대비 본원 건당진료비 비교 · 본원 3개월 일당진료비 그래프 Part Ⅰ</h5> 
							        <div class="legend-container mr-3">
							            <div class="legend-item">
							                <span class="legend-box current-month2"></span>
							                <span class="legend-text">타병원</span>
							            </div>
							            <div class="legend-item">
							                <span class="legend-box previous-month2"></span>
							                <span class="legend-text">본원</span>
							            </div>
							        </div>
							    </div>
							    <div class="card-body11">
							        <div id="cchart_category" style="max-height: 300px; display: flex; gap: 10px;">
								        <div style="flex: 6; padding: 20px 20px; ">
										    <canvas id="mixedChartF1" style="width: 100%; height: 250px;"></canvas>
										</div>
										<div style="flex: 4; padding: 20px 20px; ">
										    <canvas id="mixedChartF2" style="width: 100%; height: 250px;"></canvas>
										</div>
								    </div>    
							    </div>
							    <!-- 라인 1줄 생성 -->
							    <hr style="margin: 0; border-top: 2px solid #ccc;">
							    <div class="card-header11">
							        <h5 class="text-left ml-3 mb-1">청구현황 대상 Part Ⅱ</h5>
						        	
						        	<table id="tableName14" class="display nowrap stripe hover cell-border  order-column responsive mb-1">
															       
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

var openAccordionId = null;

var jobFlag = null;
var jobyymm = null;
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
var page_Hight = 500;    		// Page 길이보다 Data가 많으면 자동 scroll - scrollY
var p_Collapse = true;  		// Page 길이까지 auto size - scrollCollapse
var fixed_Head = false;         // 헤더 고정 

var datWaiting = true;   		// Data 가져오는 동안 대기상태 Waiting 표시 여부
var page_Navig = false;   		// 페이지 네비게이션 표시여부 
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

var colPadding = '0.2px';   		// 행 높이 간격 설정
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


document.addEventListener("DOMContentLoaded", function () {    
    document.querySelectorAll("button[data-action='FindView']").forEach(button => {
        button.addEventListener("click", function () {
            
        	
            let button_Text = this.textContent.trim();
            openAccordionId = this.getAttribute("data-value");

            let accordionHeaderText = document.querySelector(".accordion__header--text");
            if (accordionHeaderText) {
                accordionHeaderText.textContent = button_Text; 
            }

            let accordionBody = document.querySelector("#rounded-stylish_collapse");

            if (accordionBody) {
                accordionBody.classList.remove("show");
            }
            
            switch (openAccordionId) {
	    	    case "accordion_item_1":
	    	    	jobFlag = "01"
	            	break;
	        	case "accordion_item_2":
	        		jobFlag = "02"
	            	break;
	        	case "accordion_item_3":
	        		jobFlag = "03"
	            	break;
	        	case "accordion_item_4":
	        		jobFlag = "04"
	            	break;
	        	case "accordion_item_5":
	        		jobFlag = "05"
	            	break;
	        	case "accordion_item_6":
	        		jobFlag = "06"
	            	break;
	        	case "accordion_item_7":
	        		jobFlag = "07"
	            	break;
	        	case "accordion_item_8":
	        		jobFlag = "08"
	            	break;
	        	case "accordion_item_A":
	        		jobFlag = "09"
	            	break;
	        	case "accordion_item_B":
	        		jobFlag = "10"
	            	break;
	        	case "accordion_item_C":
	        		jobFlag = "11"
	            	break;	
	        	case "accordion_item_D":
	        		jobFlag = "12"
	            	break;
	        	case "accordion_item_E":
	        		jobFlag = "13"
	            	break;	
	        	case "accordion_item_F":
	        		jobFlag = "14"
	            	break;		
	        	default:
	    	}
            
        });
    });
});

function setMakeGrid() {
	const card1 = document.getElementById('card_container1');
    const card2 = document.getElementById('card_container2');
    const card3 = document.getElementById('card_container3');
	const card4 = document.getElementById('card_container4');
	const card5 = document.getElementById('card_container5');
	const card6 = document.getElementById('card_container6');
	const card7 = document.getElementById('card_container7');
	const card8 = document.getElementById('card_container8');
	const cardA = document.getElementById('card_containerA');
	const cardB = document.getElementById('card_containerB');
	const cardC = document.getElementById('card_containerC');
	const cardD = document.getElementById('card_containerD');
	const cardE = document.getElementById('card_containerE');
	const cardF = document.getElementById('card_containerF');
	
	
	card1.style.display = 'none';
	card2.style.display = 'none';
	card3.style.display = 'none';
	card4.style.display = 'none';
	card5.style.display = 'none';
	card6.style.display = 'none';
	card7.style.display = 'none';
	card8.style.display = 'none';
	cardA.style.display = 'none';
	cardB.style.display = 'none';
	cardC.style.display = 'none';
	cardD.style.display = 'none';	
	cardE.style.display = 'none';	
	cardF.style.display = 'none';	
	
	let lab_txt = document.getElementById('lab_text');	
	
    if        (jobFlag === "01" ) {
    	card1.style.display = 'flex';
    	lab_txt.textContent = "등급·가산";
    } else if (jobFlag === "02" ) {
    	card2.style.display = 'flex';
    	lab_txt.textContent = "백분율";
    } else if (jobFlag === "03" ) {
    	card3.style.display = 'flex';
    	lab_txt.textContent = "[ 건 ] / 예상금액";	
    } else if (jobFlag === "04" ) {
    	card4.style.display = 'flex';
    	lab_txt.textContent = "[ 건 ] / 청구금액";
	} else if (jobFlag === "05" ) {
    	card5.style.display = 'flex';
    	lab_txt.textContent = "[ 건 ] / 청구금액";
    } else if (jobFlag === "06" ) {
    	card6.style.display = 'flex';
    	lab_txt.textContent = "[ 건 ] / 청구금액";
    } else if (jobFlag === "07" ) {
    	card7.style.display = 'flex';
    	lab_txt.textContent = "[ 건 ] / 청구금액";
    } else if (jobFlag === "08" ) {
    	card8.style.display = 'flex';
    	lab_txt.textContent = "[ 건 ] / 청구금액";
    } else if (jobFlag === "09" ) {
    	cardA.style.display = 'flex';
    	lab_txt.textContent = "[ 명 ] / 계산총액";
	} else if (jobFlag === "10" ) {
    	cardB.style.display = 'flex';
    	lab_txt.textContent = "[ 명 ] / 계산총액";
	} else if (jobFlag === "11" ) {
    	cardC.style.display = 'flex';
    	lab_txt.textContent = "[ 비율 ] / 계산총액";
	} else if (jobFlag === "12"  ) {
    	cardD.style.display = 'flex';
    	lab_txt.textContent = "[ 비율 ] / 계산총액";
	} else if (jobFlag === "13"  ) {
    	cardE.style.display = 'flex';
    	lab_txt.textContent = "[ 입원현황 건수 ] / [ 누락대상 건수 ]";	
	} else if (jobFlag === "14"  ) {
    	cardF.style.display = 'flex';
    	lab_txt.textContent = "[ 건 ] / 계산총액";
	}	
    
    
    let selected_Year = parseInt(document.getElementById("year_Select").value);
    let selectedMonth = parseInt(document.getElementById("monthSelect").value);
    
        
    let year_3 = selected_Year;
    let month3 = selectedMonth;
    
    let month2 = month3 - 1;
    let month1 = month2 - 1;
    
    let year_2 = year_3;
    let year_1 = year_2;
     
    if (month3 === 1) {
        month2 = 12;
        month1 = 11;
        year_2 = year_3 - 1;
        year_1 = year_2;
    } else if (month2 === 1) {
        month1 = 12;
        year_1 = year_2 - 1;
    }
    
    month1 = month1 < 10 ? "0" + month1 : String(month1);
    month2 = month2 < 10 ? "0" + month2 : String(month2);
    month3 = month3 < 10 ? "0" + month3 : String(month3);
     
    const yymm1 = year_1 + '년' + month1 +'월'; 
    const yymm2 = year_2 + '년' + month2 +'월';
    const yymm3 = year_3 + '년' + month3 +'월';
    const avg_0 = "평균";
    
    jobyymm = year_3 + month3;
    
    if        (jobFlag === "01" ) {
    	makeGrid(
    	  'grid-container1',
    	  [8, 3],
    	  ["내용", yymm1, yymm2, yymm3],
    	  ["의사등급", "간호등급", "간호사수대 간호인력수", "필요인력가산", "영양사가산", "조리사가산", "직영가산", "치료식 영양관리료"],
    	  ["의사등급", "간호등급", "간호사수대 간호인력수", "필요인력가산", "영양사가산", "조리사가산", "직영가산", "치료식 영양관리료"],
    	  [],
    	  ["2,2,2,6", "4,4,2,6"]
    	);

    } else if (jobFlag === "02" ) {
    	makeGrid(
    	  'grid-container1',
    	  [6, 4],
    	  ["환자군", yymm1, yymm2, yymm3, avg_0],
    	  ["의료최고도", "의료고도", "의료중도", "의료경도", "선택입원군", "합계"],
    	  ["합계"],
    	  [6,7],
    	  ["2,2,2,6", "4,4,2,6"]
    	);
    } else if (jobFlag === "03" ) {
    	makeGrid(
    	  'grid-container1',
    	  [5, 4],
    	  ["상향대상", yymm1, yymm2, yymm3, avg_0],
    	  ["중도 → 의료고도", "선택 → 의료중도", "경도 → 의료중도", "선택 → 의료경도","합계"],
    	  ["합계"],
    	  [5,6],
    	  ["2,2,2,6", "4,4,2,6"]
    	);	
    } else if (jobFlag === "03" ) {
    	const container = document.getElementById("grid-container1");
	    container.innerHTML = ''; // 기존 내용 초기화
    } else if (jobFlag === "04" ) {
    	makeGrid(
    	  'grid-container1',
    	  [7, 4],
    	  ["내용", yymm1, yymm2, yymm3, avg_0],
    	  ["보험", "보호", "자보", "산재", "합계", "건당진료비", "일당진료비"],
    	  ["합계","건당진료비","일당진료비"],
    	  [5,6],
    	  ["2,2,2,6", "4,4,2,6"]
    	);
    	
    } else if (jobFlag === "05" ) {
    	makeGrid(
    	  'grid-container1',
    	  [9, 4],
    	  ["내용", yymm1, yymm2, yymm3, avg_0],
    	  ["보험", "보호", "자보", "산재", "합계", "특정 총진료일수", "평균진료일수", "건당진료비", "일당진료비"],
    	  ["합계", "특정 총진료일수", "평균진료일수", "건당진료비", "일당진료비"],
    	  [5,6,8],
    	  ["2,2,2,6", "4,4,2,6"]
    	);
    	
    } else if (jobFlag === "06" ) {
    	makeGrid(
    	  'grid-container1',
    	  [9, 4],
    	  ["내용", yymm1, yymm2, yymm3, avg_0],
    	  ["보험", "보호", "자보", "산재", "합계", "특정 총진료일수", "평균진료일수", "건당진료비", "일당진료비"],
    	  ["합계", "특정 총진료일수", "평균진료일수", "건당진료비", "일당진료비"],
    	  [5,6,8],
    	  ["2,2,2,6", "4,4,2,6"]
    	);
    } else if (jobFlag === "07" ) {
    	makeGrid(
    	  'grid-container1',
    	  [9, 4],
    	  ["내용", yymm1, yymm2, yymm3, avg_0],
    	  ["보험", "보호", "자보", "산재", "합계", "특정 총진료일수", "평균진료일수", "건당진료비", "일당진료비"],
    	  ["합계", "특정 총진료일수", "평균진료일수", "건당진료비", "일당진료비"],
    	  [5,6,8],
    	  ["2,2,2,6", "4,4,2,6"]
    	);
    	
    } else if (jobFlag === "08" ) {
    	makeGrid(
    	  'grid-container1',
    	  [6, 4],
    	  ["내용", yymm1, yymm2, yymm3, avg_0],
    	  ["보험", "보호", "자보", "산재", "합계", "건당진료비"],
    	  ["합계", "건당진료비"],
    	  [5,6],
    	  ["2,2,2,6", "4,4,2,6"]
    	);
    } else if (jobFlag === "09" ) {
    	makeGrid(
    	  'grid-container1',
    	  [6, 4],
    	  ["", yymm1, yymm2, yymm3, avg_0],
    	  ["보험", "보호", "자보", "산재", "합계", "인당평균재활치료료"],
    	  ["합계", "인당평균재활치료료"],
    	  [5,6],
    	  ["2,2,2,6", "4,4,2,6"]
    	);
    } else if (jobFlag === "10" ) {
    	makeGrid(
    	  'grid-container1',
    	  [6, 4],
    	  ["", yymm1, yymm2, yymm3, avg_0],
    	  ["보험", "보호", "자보", "산재", "합계", "인당평균투석료"],
    	  ["합계", "인당평균투석료"],
    	  [5,6],
    	  ["2,2,2,6", "4,4,2,6"]
    	);
    } else if (jobFlag === "11" ) {
    	makeGrid(
    	  'grid-container1',
    	  [6, 4],
    	  ["", yymm1, yymm2, yymm3, avg_0],
    	  ["총진료비", "원내", "위탁", "총검사비", "정액", "행위"],
    	  ["총진료비", "총검사비"],
    	  [4,5],
    	  ["2,2,2,6", "4,4,2,6"]
    	);
    } else if (jobFlag === "12" ) {
    	makeGrid(
    	  'grid-container1',
    	  [6, 4],
    	  ["", yymm1, yymm2, yymm3, avg_0],
    	  ["총진료비", "경구", "주사", "총약제비", "정액", "행위"],
    	  ["총진료비", "총약제비"],
    	  [4,5],
    	  ["2,2,2,6", "4,4,2,6"]
    	);
    } else if (jobFlag === "13" ) {
    	makeGrid(
    	  'grid-container1',
    	  [1, 3],
    	  ["", yymm1, yymm2, yymm3],
    	  ["누락건수"],
    	  [],
    	  [],
    	  ["2,2,2,6", "4,4,2,6"]
    	);	
    } else if (jobFlag === "14" ) {
    	makeGrid(
    	  'grid-container1',
    	  [7, 4],
    	  ["내용", yymm1, yymm2, yymm3, avg_0],
    	  ["보험", "보호", "자보", "산재", "합계", "건당진료비", "일당진료비"],
    	  ["합계","건당진료비","일당진료비"],
    	  [5,6],
    	  ["2,2,2,6", "4,4,2,6"]
    	);
    	
    }
	
}

function makeGrid(containerId, size, rowTitles, colTitles, colColors, lineNums, mergeCells = []) {
	
	const container = document.getElementById(containerId);
    
    if (!container) {
        console.error('Container not found');
        return;
    }    
    const [rows, cols] = size;    
    
    container.innerHTML = ''; // 기존 내용 초기화
    container.classList.add('grid-container');
    
    container.style.display = 'grid';
    container.style.gridTemplateRows = Array(rows + 1).fill('auto').join(' ');
    container.style.gridTemplateColumns = Array(cols + 1).fill('1fr').join(' ');
    container.style.border = '1px solid #808080';
    container.style.gap = '0px';
    container.style.padding = '10px';
    container.style.backgroundColor = '#f8f9fa';

    const f_yymm = replaceMulti(rowTitles[1],"년","월");
    const m_yymm = replaceMulti(rowTitles[2],"년","월");
    const e_yymm = replaceMulti(rowTitles[3],"년","월");

    if (mixedChart1) {
        mixedChart1.destroy();
    }
    if (mixedChart2) {
        mixedChart2.destroy();
    }
    $.ajax({
			
	    url: "/main/selectTotalReport.do",
        type: "POST",
        data: {hosp_cd: hospid,
               fr_yymm: f_yymm,
               midyymm: m_yymm,
               endyymm: e_yymm,
               make_fg: jobFlag
        },
        success: function(response) {
        	
            if(response.error_code != "0") return;	 
            for (let r = 0; r <= rows; r++) {
		   		for (let c = 0; c <= cols; c++) {
		   	        const cell = document.createElement('div');
	   	            cell.style.border = '1px solid #ccc';
	   	            cell.style.padding = '5px';
	   	            cell.style.textAlign = 'center';
	   	            cell.style.display = 'flex';
	   	            cell.style.alignItems = 'center';
	   	            cell.style.justifyContent = 'center';
	   	            /* cell.style.fontSize = '13px'; */
	   	            cell.style.fontWeight = 'bold';
	   	            cell.style.backgroundColor = '#fff';
	   	            
	   	            if (lineNums.includes(r)) {
	   	                cell.style.borderTop = '1px solid #808080';
	   	            }
	
	   	            if (r === 0) {
	   	                cell.textContent = rowTitles[c];
	   	                cell.style.backgroundColor = '#DFE6F7';
	   	                cell.style.color = '#000';
	   	            } else if (c === 0) {
	   	                cell.textContent = colTitles[r - 1];
	   	                cell.style.backgroundColor = '#DFE6F7';
	   	                cell.style.color = '#000';
	   	            } else {
	   	                cell.style.flexDirection = 'column';
	   	                const label = document.createElement('span');
	   	                
	   	                if (response.resultSize >= 1 ){
	   	             		
	   	             		let value = "0";
		   	                if        (c === 1) {
		   	                	value = replaceMulti(response.resultData[c,r-1].fr_yymm,"[ 0.00 ] 0",".00");
		   	                } else if (c === 2) {
		   	                	value = replaceMulti(response.resultData[c,r-1].midyymm,"[ 0.00 ] 0",".00");
		   	             	} else if (c === 3) {
		   	             	    value = replaceMulti(response.resultData[c,r-1].endyymm,"[ 0.00 ] 0",".00");
		   	             	} else if (c === 4) {
		   	             	    value = replaceMulti(response.resultData[c,r-1].avg_val,"[ 0.00 ] 0",".00");
		   	             	}
		   	                
		   	                if (value === "0") {
	   	                		label.textContent = "-";
		   	                } else if (value === "") {
		   	                	label.textContent = "-";
		   	                }
	   	                	else {
	   	                		label.textContent = value;
	   	                	} 
		   	                	
	   	             	} else {
	   	             		label.textContent = "";
	   	             	}
	   	             
	   	                label.id = r + '_' + c;
	   	                
	   	                const rowTitle = rowTitles[c] ?? 'Unknown';
	   	                const colTitle = colTitles[r-1] ?? 'Unknown';
	   	                
	   	                if (rowTitle === "평균" || colTitle === "계" || colTitle === "합계") {
	   	                    cell.style.backgroundColor = '#DFE6F7';
	   	                    cell.style.color = '#2E2E2E';
	   	                } else if (colColors.includes(colTitle)) {
	   	                    label.style.color = '#007bff';
	   	                } else {
	   	                	if (label.textContent != "-") {
	   	                		label.style.cursor = 'pointer';
	   	                		label.setAttribute('data-id', [rowTitle, r, c].join(','));
	   	                	}
	   	                    label.style.color = '#007bff';
	   	                    
	   	                }
	   	                
	   	                label.addEventListener('click', (e) => {
	   	                    const selectedColDataId = e.target.dataset.id;                	
	   	                    let [date_ym, rows_no, cols_no] = replaceMulti(selectedColDataId,"년","월").split(',');
	
	   	                    if (!isNaN(date_ym)) {
	   	                    	jobyymm = date_ym;
	   	                    	jobCode = rows_no;
	   	                    	total_Report_DataList();
	   	                    }
	   	                });
	
	   	                cell.appendChild(label);
	   	            }
	   	            container.appendChild(cell);
		   	    }
		   	}
		   	
		   	if (response.resultSize >= 1) {
		   		
		   		if (jobFlag === "01") {
		   	    	
		   			total_Report_DataList();
		   	    	
	            } else if (jobFlag === "02") {
		   		    
		            const labels = ['의료최고도', '의료고도', '의료중도', '의료경도', '선택입원군' ];
		            
		            const ctx1 = document.getElementById('mixedChart21').getContext('2d');		         
		            
		            mixedChart1 = new Chart(ctx1, {
		                type: 'bar',
		                data: {
		                    labels: labels,
		                    datasets: [
		                        {
		                            label: '',
		                            data: [
		                            	   response.resultData[1,0].ta_e_ym,
		                            	   response.resultData[2,1].ta_e_ym,
		                            	   response.resultData[3,2].ta_e_ym,
		                            	   response.resultData[4,3].ta_e_ym,
		                            	   response.resultData[5,4].ta_e_ym
		                            	  ],
		                            backgroundColor: '#0B8ECA',
		                            borderWidth: 1,
		                            borderRadius: 8,
		                            yAxisID: 'y',
		                            type: 'bar',
		                            minBarLength: 0
		                            
		                        },
		                        {
		                            label: '',
		                            data: [
		                            	   response.resultData[1,0].endyymm,
		                            	   response.resultData[2,1].endyymm,
		                            	   response.resultData[3,2].endyymm,
		                            	   response.resultData[4,3].endyymm,
		                            	   response.resultData[5,4].endyymm
		                            	  ],
		                            backgroundColor: '#ED7D31',
		                            borderWidth: 1,
		                            borderRadius: 8,
		                            yAxisID: 'y',
		                            type: 'bar',
		                            minBarLength: 0
		                            
		                        }
		                    ]
		                },
		                options: {
		                	maintainAspectRatio: false,
		                    responsive: true,
		                    animation: {
		                        duration: 1000
		                    },
		                    plugins: {
		                        legend: {
		                            display: false 
		                        }
		                    },
		                    scales: {
		                        y: {
		                            beginAtZero: true,
		                            grid: {
		                                color: 'rgba(0, 0, 0, 0.05)'
		                            }
		                        },
		                        y1: {
		                            beginAtZero: true,
		                            position: 'right',
		                            ticks: {
		                                display: false
		                            },
		                            grid: {
		                                drawOnChartArea: false
		                            }
		                        }
		                    }
		                }
		            });
		            
		 	    } else if (jobFlag === "04") {
	                
		            const ctx1 = document.getElementById('mixedChart41').getContext('2d');

		            mixedChart1 = new Chart(ctx1, {
		                type: 'line',
		                data: {
		                    labels: [f_yymm, [m_yymm,"건당진료비"], e_yymm],
		                    datasets: [
		                        {
		                            label: '건당진료비',
		                            type: 'bar',
		                            data: [
		                                replaceMulti(response.resultData[4,5].ta_f_ym, ","),
		                                replaceMulti(response.resultData[5,5].ta_m_ym, ","),
		                                replaceMulti(response.resultData[6,5].ta_e_ym, ",")
		                            ],
		                            backgroundColor: 'rgba(11, 142, 202, 1)',   // '#0B8ECA' → 투명도 80%	→ 100%로 변경
		                            borderWidth: 1,
		                            borderRadius: 8,
		                            yAxisID: 'y',
		                            minBarLength: 1,
		                            order: 1,
		                            clip: false
		                        },
		                        {
		                            label: '건당진료비',
		                            type: 'bar',
		                            data: [
		                                replaceMulti(response.resultData[4,5].fr_yymm, ","),
		                                replaceMulti(response.resultData[5,5].midyymm, ","),
		                                replaceMulti(response.resultData[6,5].endyymm, ",")
		                            ],
		                            backgroundColor: 'rgba(237, 125, 49, 1)',   // '#ED7D31' → 투명도 80%	→ 100%로 변경
		                            borderWidth: 1,
		                            borderRadius: 8,
		                            yAxisID: 'y',
		                            minBarLength: 1,
		                            order: 2,
		                            clip: false
		                        },
		                        {
		                            label: '건당진료비',
		                            type: 'line',
		                            data: [
		                                replaceMulti(response.resultData[4,5].fr_yymm, ","),
		                                replaceMulti(response.resultData[5,5].midyymm, ","),
		                                replaceMulti(response.resultData[6,5].endyymm, ",")
		                            ],
		                            borderColor: '#000',
		                            backgroundColor: '#000',
		                            borderWidth: 1,
		                            yAxisID: 'y',
		                            // borderDash: [5, 5],
		                            borderDash: [], // 실선으로 표시
		                            fill: false,
		                            tension: 0.4,
		                            pointRadius: 4,
		                            pointHoverRadius: 6,
		                            order: 0,
		                            clip: false
		                        }
		                    ]
		                },
		                options: {
		                    maintainAspectRatio: false,
		                    responsive: true,
		                    plugins: {
		                        legend: {
		                            display: false
		                        }
		                    },
		                    scales: {
		                        y: {
		                            beginAtZero: true,
		                            grid: {
		                                color: 'rgba(0, 0, 0, 0.05)'
		                            }
		                        },
		                        y1: {
		                            beginAtZero: true,
		                            position: 'right',
		                            ticks: {
		                                display: false
		                            },
		                            grid: {
		                                drawOnChartArea: false
		                            }
		                        }
		                    }
		                }
		            });
		            
		            
		            const setValues = [
		                parseFloat(replaceMulti(response.resultData[7,6].fr_yymm, ",")),
		                parseFloat(replaceMulti(response.resultData[7,6].midyymm, ",")),
		                parseFloat(replaceMulti(response.resultData[7,6].endyymm, ","))
		            ];
		            
		            const ctx2 = document.getElementById('mixedChart42').getContext('2d');;
		            
		            mixedChart2 = new Chart(ctx2, {
		                type: 'bar',
		                data: {
		                    labels: [f_yymm, [m_yymm," 일당진료비"], e_yymm],
		                    datasets: [
		                    	{
		                            label: '일당진료비',
		                            type: 'bar',
		                            data: setValues,
		                            backgroundColor: 'rgba(237, 125, 49, 1)',   // '#ED7D31' → 투명도 80%	 
		                            borderWidth: 1,
		                            borderRadius: 8,
		                            yAxisID: 'y',
		                            minBarLength: 1,
		                            order: 1,
		                            clip: false,
		                         
		                            categoryPercentage: 0.8,
		                            barPercentage: 0.8      
		                        },
		                        {		                        	
		                            label: '일당진료비',
		                            type: 'line',
		                            data: setValues,
		                            borderColor: '#000',
		                            backgroundColor: '#000',
		                            borderWidth: 1,
		                            yAxisID: 'y1',
		                            borderDash: [],
		                            fill: false,
		                            tension: 0.4,
		                            pointRadius: 4,
		                            pointHoverRadius: 6,
		                            order: 0,
		                            clip: false
		                        }
		                    ]
		                },
		                options: {
		                    maintainAspectRatio: false,
		                    responsive: true,
		                    plugins: {
		                        legend: {
		                            display: false
		                        }
		                    },
		                    scales: {
		                        y: {
		                            beginAtZero: true,
		                            grid: {
		                                color: 'rgba(0, 0, 0, 0.05)'
		                            }
		                        },
		                        y1: {
		                            beginAtZero: true,
		                            position: 'right',
		                            ticks: {
		                                display: false
		                            },
		                            grid: {
		                                drawOnChartArea: false
		                            }
		                        }
		                    }
		                }
		            });
	                
		 	    } else if (jobFlag === "05") {
		 	    	
		            const ctx1 = document.getElementById('mixedChart51').getContext('2d');
		            
		            mixedChart1 = new Chart(ctx1, {
		                type: 'line',
		                data: {
		                	labels: [f_yymm, [m_yymm,"건당진료비"], e_yymm],
		                    datasets: [
		                        {
		                            label: '건당진료비',
		                            type: 'bar',
		                            data: [
		                                replaceMulti(response.resultData[6,7].ta_f_ym, ","),
		                                replaceMulti(response.resultData[7,7].ta_m_ym, ","),
		                                replaceMulti(response.resultData[8,7].ta_e_ym, ",")
		                            ],
		                            backgroundColor: 'rgba(11, 142, 202, 1)',   // '#0B8ECA' → 투명도 80%	→ 100%로 변경
		                            borderWidth: 1,
		                            borderRadius: 8,
		                            yAxisID: 'y',
		                            minBarLength: 1,
		                            order: 1,
		                            clip: false
		                        },
		                        {
		                            label: '건당진료비',
		                            type: 'bar',
		                            data: [
		                                replaceMulti(response.resultData[6,7].fr_yymm, ","),
		                                replaceMulti(response.resultData[7,7].midyymm, ","),
		                                replaceMulti(response.resultData[8,7].endyymm, ",")
		                            ],
		                            backgroundColor: 'rgba(237, 125, 49, 1)',   // '#ED7D31' → 투명도 80%	→ 100%로 변경
		                            borderWidth: 1,
		                            borderRadius: 8,
		                            yAxisID: 'y',
		                            minBarLength: 1,
		                            order: 2,
		                            clip: false
		                        },
		                        {
		                            label: '건당진료비',
		                            type: 'line',
		                            data: [
		                                replaceMulti(response.resultData[6,7].fr_yymm, ","),
		                                replaceMulti(response.resultData[7,7].midyymm, ","),
		                                replaceMulti(response.resultData[8,7].endyymm, ",")
		                            ],
		                            borderColor: '#000',
		                            backgroundColor: '#000',
		                            borderWidth: 1,
		                            yAxisID: 'y',
		                            // borderDash: [5, 5],
		                            borderDash: [], // 실선으로 표시
		                            fill: false,
		                            tension: 0.4,
		                            pointRadius: 4,
		                            pointHoverRadius: 6,
		                            order: 0,
		                            clip: false
		                        }
		                    ]
		                },
		                options: {
		                    maintainAspectRatio: false,
		                    responsive: true,
		                    plugins: {
		                        legend: {
		                            display: false
		                        }
		                    },
		                    scales: {
		                        y: {
		                            beginAtZero: true,
		                            grid: {
		                                color: 'rgba(0, 0, 0, 0.05)'
		                            }
		                        },
		                        y1: {
		                            beginAtZero: true,
		                            position: 'right',
		                            ticks: {
		                                display: false
		                            },
		                            grid: {
		                                drawOnChartArea: false
		                            }
		                        }
		                    }
		                }
		            });
		            
		            
		            const setValues = [
		                parseFloat(replaceMulti(response.resultData[9,8].fr_yymm, ",")),
		                parseFloat(replaceMulti(response.resultData[9,8].midyymm, ",")),
		                parseFloat(replaceMulti(response.resultData[9,8].endyymm, ","))
		            ];
		            
		            const ctx2 = document.getElementById('mixedChart52').getContext('2d');;
		            
		            mixedChart2 = new Chart(ctx2, {
		                type: 'bar',
		                data: {
		                	labels: [f_yymm, [m_yymm,"일당진료비"], e_yymm],
		                    datasets: [
		                    	{
		                            label: '일당진료비',
		                            type: 'bar',
		                            data: setValues,
		                            backgroundColor: 'rgba(237, 125, 49, 1)',   // '#ED7D31' → 투명도 80%	 
		                            borderWidth: 1,
		                            borderRadius: 8,
		                            yAxisID: 'y',
		                            minBarLength: 1,
		                            order: 1,
		                            clip: false,
		                         
		                            categoryPercentage: 0.8,
		                            barPercentage: 0.8      
		                        },
		                        {		                        	
		                            label: '일당진료비',
		                            type: 'line',
		                            data: setValues,
		                            borderColor: '#000',
		                            backgroundColor: '#000',
		                            borderWidth: 1,
		                            yAxisID: 'y1',
		                            borderDash: [],
		                            fill: false,
		                            tension: 0.4,
		                            pointRadius: 4,
		                            pointHoverRadius: 6,
		                            order: 0,
		                            clip: false
		                        }
		                    ]
		                },
		                options: {
		                    maintainAspectRatio: false,
		                    responsive: true,
		                    plugins: {
		                        legend: {
		                            display: false
		                        }
		                    },
		                    scales: {
		                        y: {
		                            beginAtZero: true,
		                            grid: {
		                                color: 'rgba(0, 0, 0, 0.05)'
		                            }
		                        },
		                        y1: {
		                            beginAtZero: true,
		                            position: 'right',
		                            ticks: {
		                                display: false
		                            },
		                            grid: {
		                                drawOnChartArea: false
		                            }
		                        }
		                    }
		                }
		            });
	    	    	
		 	    } else if (jobFlag === "06") {
		 	    	
		 	    	const ctx1 = document.getElementById('mixedChart61').getContext('2d');
		            
		            mixedChart1 = new Chart(ctx1, {
		                type: 'line',
		                data: {
		                	labels: [f_yymm, [m_yymm,"건당진료비"], e_yymm],
		                    datasets: [
		                        {
		                            label: '건당진료비',
		                            type: 'bar',
		                            data: [
		                                replaceMulti(response.resultData[6,7].ta_f_ym, ","),
		                                replaceMulti(response.resultData[7,7].ta_m_ym, ","),
		                                replaceMulti(response.resultData[8,7].ta_e_ym, ",")
		                            ],
		                            backgroundColor: 'rgba(11, 142, 202, 1)',   // '#0B8ECA' → 투명도 80%	→ 100%로 변경
		                            borderWidth: 1,
		                            borderRadius: 8,
		                            yAxisID: 'y',
		                            minBarLength: 1,
		                            order: 1,
		                            clip: false
		                        },
		                        {
		                            label: '건당진료비',
		                            type: 'bar',
		                            data: [
		                                replaceMulti(response.resultData[6,7].fr_yymm, ","),
		                                replaceMulti(response.resultData[7,7].midyymm, ","),
		                                replaceMulti(response.resultData[8,7].endyymm, ",")
		                            ],
		                            backgroundColor: 'rgba(237, 125, 49, 1)',   // '#ED7D31' → 투명도 80%	→ 100%로 변경
		                            borderWidth: 1,
		                            borderRadius: 8,
		                            yAxisID: 'y',
		                            minBarLength: 1,
		                            order: 2,
		                            clip: false
		                        },
		                        {
		                            label: '건당진료비',
		                            type: 'line',
		                            data: [
		                                replaceMulti(response.resultData[6,7].fr_yymm, ","),
		                                replaceMulti(response.resultData[7,7].midyymm, ","),
		                                replaceMulti(response.resultData[8,7].endyymm, ",")
		                            ],
		                            borderColor: '#000',
		                            backgroundColor: '#000',
		                            borderWidth: 1,
		                            yAxisID: 'y',
		                            // borderDash: [5, 5],
		                            borderDash: [], // 실선으로 표시
		                            fill: false,
		                            tension: 0.4,
		                            pointRadius: 4,
		                            pointHoverRadius: 6,
		                            order: 0,
		                            clip: false
		                        }
		                    ]
		                },
		                options: {
		                    maintainAspectRatio: false,
		                    responsive: true,
		                    plugins: {
		                        legend: {
		                            display: false
		                        }
		                    },
		                    scales: {
		                        y: {
		                            beginAtZero: true,
		                            grid: {
		                                color: 'rgba(0, 0, 0, 0.05)'
		                            }
		                        },
		                        y1: {
		                            beginAtZero: true,
		                            position: 'right',
		                            ticks: {
		                                display: false
		                            },
		                            grid: {
		                                drawOnChartArea: false
		                            }
		                        }
		                    }
		                }
		            });
		            
		            
		            const setValues = [
		                parseFloat(replaceMulti(response.resultData[9,8].fr_yymm, ",")),
		                parseFloat(replaceMulti(response.resultData[9,8].midyymm, ",")),
		                parseFloat(replaceMulti(response.resultData[9,8].endyymm, ","))
		            ];
		            
		            const ctx2 = document.getElementById('mixedChart62').getContext('2d');;
		            
		            mixedChart2 = new Chart(ctx2, {
		                type: 'bar',
		                data: {
		                	labels: [f_yymm, [m_yymm,"일당진료비"], e_yymm],
		                    datasets: [
		                    	{
		                            label: '일당진료비',
		                            type: 'bar',
		                            data: setValues,
		                            backgroundColor: 'rgba(237, 125, 49, 1)',   // '#ED7D31' → 투명도 80%	 
		                            borderWidth: 1,
		                            borderRadius: 8,
		                            yAxisID: 'y',
		                            minBarLength: 1,
		                            order: 1,
		                            clip: false,
		                         
		                            categoryPercentage: 0.8,
		                            barPercentage: 0.8      
		                        },
		                        {		                        	
		                            label: '일당진료비',
		                            type: 'line',
		                            data: setValues,
		                            borderColor: '#000',
		                            backgroundColor: '#000',
		                            borderWidth: 1,
		                            yAxisID: 'y1',
		                            borderDash: [],
		                            fill: false,
		                            tension: 0.4,
		                            pointRadius: 4,
		                            pointHoverRadius: 6,
		                            order: 0,
		                            clip: false
		                        }
		                    ]
		                },
		                options: {
		                    maintainAspectRatio: false,
		                    responsive: true,
		                    plugins: {
		                        legend: {
		                            display: false
		                        }
		                    },
		                    scales: {
		                        y: {
		                            beginAtZero: true,
		                            grid: {
		                                color: 'rgba(0, 0, 0, 0.05)'
		                            }
		                        },
		                        y1: {
		                            beginAtZero: true,
		                            position: 'right',
		                            ticks: {
		                                display: false
		                            },
		                            grid: {
		                                drawOnChartArea: false
		                            }
		                        }
		                    }
		                }
		            });
		 	    	
		 	    } else if (jobFlag === "07") {
		 	    	
		 	    	const ctx1 = document.getElementById('mixedChart71').getContext('2d');
		            
		            mixedChart1 = new Chart(ctx1, {
		                type: 'line',
		                data: {
		                	labels: [f_yymm, [m_yymm,"건당진료비"], e_yymm],
		                    datasets: [
		                        {
		                            label: '건당진료비',
		                            type: 'bar',
		                            data: [
		                                replaceMulti(response.resultData[6,7].ta_f_ym, ","),
		                                replaceMulti(response.resultData[7,7].ta_m_ym, ","),
		                                replaceMulti(response.resultData[8,7].ta_e_ym, ",")
		                            ],
		                            backgroundColor: 'rgba(11, 142, 202, 1)',   // '#0B8ECA' → 투명도 80%	→ 100%로 변경
		                            borderWidth: 1,
		                            borderRadius: 8,
		                            yAxisID: 'y',
		                            minBarLength: 1,
		                            order: 1,
		                            clip: false
		                        },
		                        {
		                            label: '건당진료비',
		                            type: 'bar',
		                            data: [
		                                replaceMulti(response.resultData[6,7].fr_yymm, ","),
		                                replaceMulti(response.resultData[7,7].midyymm, ","),
		                                replaceMulti(response.resultData[8,7].endyymm, ",")
		                            ],
		                            backgroundColor: 'rgba(237, 125, 49, 1)',   // '#ED7D31' → 투명도 80%	→ 100%로 변경
		                            borderWidth: 1,
		                            borderRadius: 8,
		                            yAxisID: 'y',
		                            minBarLength: 1,
		                            order: 2,
		                            clip: false
		                        },
		                        {
		                            label: '건당진료비',
		                            type: 'line',
		                            data: [
		                                replaceMulti(response.resultData[6,7].fr_yymm, ","),
		                                replaceMulti(response.resultData[7,7].midyymm, ","),
		                                replaceMulti(response.resultData[8,7].endyymm, ",")
		                            ],
		                            borderColor: '#000',
		                            backgroundColor: '#000',
		                            borderWidth: 1,
		                            yAxisID: 'y',
		                            // borderDash: [5, 5],
		                            borderDash: [], // 실선으로 표시
		                            fill: false,
		                            tension: 0.4,
		                            pointRadius: 4,
		                            pointHoverRadius: 6,
		                            order: 0,
		                            clip: false
		                        }
		                    ]
		                },
		                options: {
		                    maintainAspectRatio: false,
		                    responsive: true,
		                    plugins: {
		                        legend: {
		                            display: false
		                        }
		                    },
		                    scales: {
		                        y: {
		                            beginAtZero: true,
		                            grid: {
		                                color: 'rgba(0, 0, 0, 0.05)'
		                            }
		                        },
		                        y1: {
		                            beginAtZero: true,
		                            position: 'right',
		                            ticks: {
		                                display: false
		                            },
		                            grid: {
		                                drawOnChartArea: false
		                            }
		                        }
		                    }
		                }
		            });
		            
		            
		            const setValues = [
		                parseFloat(replaceMulti(response.resultData[9,8].fr_yymm, ",")),
		                parseFloat(replaceMulti(response.resultData[9,8].midyymm, ",")),
		                parseFloat(replaceMulti(response.resultData[9,8].endyymm, ","))
		            ];
		            
		            const ctx2 = document.getElementById('mixedChart72').getContext('2d');;
		            
		            mixedChart2 = new Chart(ctx2, {
		                type: 'bar',
		                data: {
		                	labels: [f_yymm, [m_yymm,"일당진료비"], e_yymm],
		                    datasets: [
		                    	{
		                            label: '일당진료비',
		                            type: 'bar',
		                            data: setValues,
		                            backgroundColor: 'rgba(237, 125, 49, 1)',   // '#ED7D31' → 투명도 80%	 
		                            borderWidth: 1,
		                            borderRadius: 8,
		                            yAxisID: 'y',
		                            minBarLength: 1,
		                            order: 1,
		                            clip: false,
		                         
		                            categoryPercentage: 0.8,
		                            barPercentage: 0.8      
		                        },
		                        {		                        	
		                            label: '일당진료비',
		                            type: 'line',
		                            data: setValues,
		                            borderColor: '#000',
		                            backgroundColor: '#000',
		                            borderWidth: 1,
		                            yAxisID: 'y1',
		                            borderDash: [],
		                            fill: false,
		                            tension: 0.4,
		                            pointRadius: 4,
		                            pointHoverRadius: 6,
		                            order: 0,
		                            clip: false
		                        }
		                    ]
		                },
		                options: {
		                    maintainAspectRatio: false,
		                    responsive: true,
		                    plugins: {
		                        legend: {
		                            display: false
		                        }
		                    },
		                    scales: {
		                        y: {
		                            beginAtZero: true,
		                            grid: {
		                                color: 'rgba(0, 0, 0, 0.05)'
		                            }
		                        },
		                        y1: {
		                            beginAtZero: true,
		                            position: 'right',
		                            ticks: {
		                                display: false
		                            },
		                            grid: {
		                                drawOnChartArea: false
		                            }
		                        }
		                    }
		                }
		            });
	    	    	
		 	    	
		 	    } else if (jobFlag === "08") {
		 	    	
		            const ctx1 = document.getElementById('mixedChart81').getContext('2d');
		            
		            mixedChart1 = new Chart(ctx1, {
		                type: 'line',
		                data: {
		                	labels: [f_yymm, [m_yymm,"건당진료비"], e_yymm],
		                    datasets: [
		                        {
		                            label: '건당진료비',
		                            type: 'bar',
		                            data: [
		                                replaceMulti(response.resultData[4,5].ta_f_ym, ","),
		                                replaceMulti(response.resultData[5,5].ta_m_ym, ","),
		                                replaceMulti(response.resultData[6,5].ta_e_ym, ",")
		                            ],
		                            backgroundColor: 'rgba(11, 142, 202, 1)',   // '#0B8ECA' → 투명도 80%	→ 100%로 변경
		                            borderWidth: 1,
		                            borderRadius: 8,
		                            yAxisID: 'y',
		                            minBarLength: 1,
		                            order: 1,
		                            clip: false,
		                            barPercentage: 0.8,
		                            categoryPercentage: 0.5
		                        },
		                        {
		                            label: '건당진료비',
		                            type: 'bar',
		                            data: [
		                                replaceMulti(response.resultData[4,5].fr_yymm, ","),
		                                replaceMulti(response.resultData[5,5].midyymm, ","),
		                                replaceMulti(response.resultData[6,5].endyymm, ",")
		                            ],
		                            backgroundColor: 'rgba(237, 125, 49, 1)',   // '#ED7D31' → 투명도 80%	→ 100%로 변경
		                            borderWidth: 1,
		                            borderRadius: 8,
		                            yAxisID: 'y',
		                            minBarLength: 1,
		                            order: 2,
		                            clip: false,
		                            barPercentage: 0.8,
		                            categoryPercentage: 0.5
		                        },
		                        {
		                            label: '건당진료비',
		                            type: 'line',
		                            data: [
		                                replaceMulti(response.resultData[4,5].fr_yymm, ","),
		                                replaceMulti(response.resultData[5,5].midyymm, ","),
		                                replaceMulti(response.resultData[6,5].endyymm, ",")
		                            ],
		                            borderColor: '#000',
		                            backgroundColor: '#000',
		                            borderWidth: 1,
		                            yAxisID: 'y',
		                            // borderDash: [5, 5],
		                            borderDash: [], // 실선으로 표시
		                            fill: false,
		                            tension: 0.4,
		                            pointRadius: 4,
		                            pointHoverRadius: 6,
		                            order: 0,
		                            clip: false
		                        }
		                    ]
		                },
		                options: {
		                    maintainAspectRatio: false,
		                    responsive: true,
		                    plugins: {
		                        legend: {
		                            display: false
		                        }
		                    },
		                    scales: {
		                        y: {
		                            beginAtZero: true,
		                            grid: {
		                                color: 'rgba(0, 0, 0, 0.05)'
		                            }
		                        },
		                        y1: {
		                            beginAtZero: true,
		                            position: 'right',
		                            ticks: {
		                                display: false
		                            },
		                            grid: {
		                                drawOnChartArea: false
		                            }
		                        }
		                    }
		                }
		            });
		            
		 	    } else if (jobFlag === "09") {
		 	    	
		 	    	const ctx1 = document.getElementById('mixedChartA1').getContext('2d');
		            
		            mixedChart1 = new Chart(ctx1, {
		                type: 'line',
		                data: {
		                	labels: [f_yymm, [m_yymm,"인당 재활청구액"], e_yymm],
		                    datasets: [
		                        {
		                            label: '인당 재활청구액',
		                            type: 'bar',
		                            data: [
		                                replaceMulti(response.resultData[4,5].ta_f_ym, ","),
		                                replaceMulti(response.resultData[5,5].ta_m_ym, ","),
		                                replaceMulti(response.resultData[6,5].ta_e_ym, ",")
		                            ],
		                            backgroundColor: 'rgba(11, 142, 202, 1)',   // '#0B8ECA' → 투명도 80%	→ 100%로 변경
		                            borderWidth: 1,
		                            borderRadius: 8,
		                            yAxisID: 'y',
		                            minBarLength: 1,
		                            order: 1,
		                            clip: false,
		                            barPercentage: 0.8,
		                            categoryPercentage: 0.5
		                        },
		                        {
		                            label: '인당 재활청구액',
		                            type: 'bar',
		                            data: [
		                                replaceMulti(response.resultData[4,5].fr_yymm, ","),
		                                replaceMulti(response.resultData[5,5].midyymm, ","),
		                                replaceMulti(response.resultData[6,5].endyymm, ",")
		                            ],
		                            backgroundColor: 'rgba(237, 125, 49, 1)',   // '#ED7D31' → 투명도 80%	→ 100%로 변경
		                            borderWidth: 1,
		                            borderRadius: 8,
		                            yAxisID: 'y',
		                            minBarLength: 1,
		                            order: 2,
		                            clip: false,
		                            barPercentage: 0.8,
		                            categoryPercentage: 0.5
		                        },
		                        {
		                            label: '인당 재활청구액',
		                            type: 'line',
		                            data: [
		                                replaceMulti(response.resultData[4,5].fr_yymm, ","),
		                                replaceMulti(response.resultData[5,5].midyymm, ","),
		                                replaceMulti(response.resultData[6,5].endyymm, ",")
		                            ],
		                            borderColor: '#000',
		                            backgroundColor: '#000',
		                            borderWidth: 1,
		                            yAxisID: 'y',
		                            // borderDash: [5, 5],
		                            borderDash: [], // 실선으로 표시
		                            fill: false,
		                            tension: 0.4,
		                            pointRadius: 4,
		                            pointHoverRadius: 6,
		                            order: 0,
		                            clip: false
		                        }
		                    ]
		                },
		                options: {
		                    maintainAspectRatio: false,
		                    responsive: true,
		                    plugins: {
		                        legend: {
		                            display: false
		                        }
		                    },
		                    scales: {
		                        y: {
		                            beginAtZero: true,
		                            grid: {
		                                color: 'rgba(0, 0, 0, 0.05)'
		                            }
		                        },
		                        y1: {
		                            beginAtZero: true,
		                            position: 'right',
		                            ticks: {
		                                display: false
		                            },
		                            grid: {
		                                drawOnChartArea: false
		                            }
		                        }
		                    }
		                }
		            });
	    	    	
		 	   } else if (jobFlag === "10") {
		 		   
		            const ctx1 = document.getElementById('mixedChartB1').getContext('2d');
		            
		            mixedChart1 = new Chart(ctx1, {
		                type: 'line',
		                data: {
		                	labels: [f_yymm, [m_yymm,"인당 투석청구액"], e_yymm],
		                    datasets: [
		                        {
		                            label: '인당 투석청구액',
		                            type: 'bar',
		                            data: [
		                                replaceMulti(response.resultData[4,5].ta_f_ym, ","),
		                                replaceMulti(response.resultData[5,5].ta_m_ym, ","),
		                                replaceMulti(response.resultData[6,5].ta_e_ym, ",")
		                            ],
		                            backgroundColor: 'rgba(11, 142, 202, 1)',   // '#0B8ECA' → 투명도 80%	→ 100%로 변경
		                            borderWidth: 1,
		                            borderRadius: 8,
		                            yAxisID: 'y',
		                            minBarLength: 1,
		                            order: 1,
		                            clip: false,
		                            barPercentage: 0.8,
		                            categoryPercentage: 0.5
		                        },
		                        {
		                            label: '인당 투석청구액',
		                            type: 'bar',
		                            data: [
		                                replaceMulti(response.resultData[4,5].fr_yymm, ","),
		                                replaceMulti(response.resultData[5,5].midyymm, ","),
		                                replaceMulti(response.resultData[6,5].endyymm, ",")
		                            ],
		                            backgroundColor: 'rgba(237, 125, 49, 1)',   // '#ED7D31' → 투명도 80%	→ 100%로 변경
		                            borderWidth: 1,
		                            borderRadius: 8,
		                            yAxisID: 'y',
		                            minBarLength: 1,
		                            order: 2,
		                            clip: false,
		                            barPercentage: 0.8,
		                            categoryPercentage: 0.5
		                        },
		                        {
		                            label: '인당 투석청구액',
		                            type: 'line',
		                            data: [
		                                replaceMulti(response.resultData[4,5].fr_yymm, ","),
		                                replaceMulti(response.resultData[5,5].midyymm, ","),
		                                replaceMulti(response.resultData[6,5].endyymm, ",")
		                            ],
		                            borderColor: '#000',
		                            backgroundColor: '#000',
		                            borderWidth: 1,
		                            yAxisID: 'y',
		                            // borderDash: [5, 5],
		                            borderDash: [], // 실선으로 표시
		                            fill: false,
		                            tension: 0.4,
		                            pointRadius: 4,
		                            pointHoverRadius: 6,
		                            order: 0,
		                            clip: false
		                        }
		                    ]
		                },
		                options: {
		                    maintainAspectRatio: false,
		                    responsive: true,
		                    plugins: {
		                        legend: {
		                            display: false
		                        }
		                    },
		                    scales: {
		                        y: {
		                            beginAtZero: true,
		                            grid: {
		                                color: 'rgba(0, 0, 0, 0.05)'
		                            }
		                        },
		                        y1: {
		                            beginAtZero: true,
		                            position: 'right',
		                            ticks: {
		                                display: false
		                            },
		                            grid: {
		                                drawOnChartArea: false
		                            }
		                        }
		                    }
		                }
		            }); 
		            
		            
		 	    } else if (jobFlag === "11") {
		 	    	const chartContainer = document.getElementById("morris-bar-chartC1");    	    	
	                chartContainer.innerHTML = '';
	                chartContainer.style.height = "200px";
	                chartContainer.style.width  = "250px";
	                
	                let totamt = replaceMulti(response.resultData[1,0].endyymm,",");
	                let wonamt = replaceMulti(response.resultData[2,1].endyymm,",");
	                let witamt = replaceMulti(response.resultData[3,2].endyymm,",");
	                let onlyNo = replaceMulti(response.resultData[4,3].endyymm,",");
	                let totgam = onlyNo.match(/(\d[\d,]*)\s*$/)[1].replace(/,/g,'');
	                let drgamt = replaceMulti(response.resultData[5,4].endyymm,",");
	                let hwiamt = replaceMulti(response.resultData[6,5].endyymm,",");
	                
	                let pro_01 = 0;
	                let pro_02 = 0;
	                let pro_03 = 0;
	                let pro_04 = 0;
	                let pro_05 = 0;
	                let pro_06 = 0;
	                
	                if (totamt > 0) {
	                	pro_01 = Math.round((totgam / totamt) * 100);
	                	pro_02 = 100 - pro_01;
	                } 
	                if (wonamt + witamt > 0 ) {
	                	pro_03 = Math.round((witamt / totgam) * 100);
	                	pro_04 = 100 - pro_03;
	                }
	                if (drgamt + hwiamt > 0) {
	                	pro_05 = Math.round((drgamt / totgam) * 100);
	                	pro_06 = 100 - pro_05;
	                }
	                
	                const chart = Morris.Bar({
		    	        element: 'morris-bar-chartC1',
		    	        data: [
	    	        	   	{ y: '총진료비 대비 검사비 (백만원)', 
			    	          a: Math.round(totamt/1000000), 
			    	          b: Math.round(totgam/1000000), 
			    	          c: Math.round(drgamt/1000000), 
			    	          d: Math.round(hwiamt/1000000) }
		    	        ],
		    	        xkey: 'y',
		    		    ykeys: ['a', 'b', 'c', 'd'],
		    		    labels: ['총진료비','총검사비', '정액금액','행위금액' ],
		    		    barColors: ['#0B8ECA','#00B050', '#C785C8', '#ED7D31'],
		    		    hideHover: 'auto',
		    		    gridLineColor: '#eef0f2',
		    		    resize: true,
		    		    gridTextSize: 12, // 축 폰트 크기 조절
		    		    labelsColor: '#000', // 레이블 색상 설정
		    		    barSizeRatio: 1, // 막대 크기 조정
		    		    barGap: 5 // 막대 간격 조정
		    	    });
	                
	                const chartContainer2 = document.getElementById("morris-bar-chartC2");    	    	
	                chartContainer2.innerHTML = '';
	                chartContainer2.style.height = "180px";
	                chartContainer2.style.width  = "180px";
	                
	                const chart2 = Morris.Donut({
	                    element: 'morris-bar-chartC2',
	                    data: [{
	                        label: "\xa0 \xa0 총진료비 \xa0 \xa0",
	                        value: pro_02,
	                    }, {
	                        label: "\xa0 \xa0 총검사료 \xa0 \xa0",
	                        value: pro_01
	                    }],
	                    resize: true,
	                    colors: ['#0B8ECA','#00B050'],
	                    formatter: function (y) { return y + '%'; }
	                });
	                setTimeout(() => { chart2.select(1); }, 50);
	                
	                
	                const chartContainer3 = document.getElementById("morris-bar-chartC3");    	    	
	                chartContainer3.innerHTML = '';
	                chartContainer3.style.height = "180px";
	                chartContainer3.style.width  = "180px";
	                
	                const chart3 = Morris.Donut({
	                    element: 'morris-bar-chartC3',
	                    data: [{
	                        label: "\xa0 \xa0 총검사료(원내) \xa0 \xa0",
	                        value: pro_04,
	                    }, {
	                        label: "\xa0 \xa0 총검사료(위탁) \xa0 \xa0",
	                        value: pro_03
	                    }],
	                    resize: true,
	                    colors: ['#BFB500', '#808080'], 
	                	formatter: function (y) { return y + '%'; }
	                });
	                
	                
	                const chartContainer4 = document.getElementById("morris-bar-chartC4");    	    	
	                chartContainer4.innerHTML = '';
	                chartContainer4.style.height = "180px";
	                chartContainer4.style.width  = "180px";
	                
	                const chart4 = Morris.Donut({
	                    element: 'morris-bar-chartC4',
	                    data: [{
	                        label: "\xa0 \xa0 총검사료(정액) \xa0 \xa0",
	                        value: pro_05,
	                    }, {
	                        label: "\xa0 \xa0 총검사료(행위) \xa0 \xa0",
	                        value: pro_06
	                    }], 
	                    resize: true,
	                    colors: ['#C785C8', '#ED7D31'],
	                    formatter: function (y) { return y + '%'; }
	                });
	                
		 	    } else if (jobFlag === "12") { 
		 	    	const chartContainer = document.getElementById("morris-bar-chartD1");    	    	
	                chartContainer.innerHTML = '';
	                chartContainer.style.height = "200px";
	                chartContainer.style.width  = "250px";
	                
	                let totamt = replaceMulti(response.resultData[1,0].endyymm,",");
	                let phar03 = replaceMulti(response.resultData[2,1].endyymm,",");
	                let phar04 = replaceMulti(response.resultData[3,2].endyymm,",");
	                let onlyNo = replaceMulti(response.resultData[4,3].endyymm,",");
	                let totpha = onlyNo.match(/(\d[\d,]*)\s*$/)[1].replace(/,/g,'');
	                let drgamt = replaceMulti(response.resultData[5,4].endyymm,",");
	                let hwiamt = replaceMulti(response.resultData[6,5].endyymm,",");
	                
	                let pro_01 = 0;
	                let pro_02 = 0;
	                let pro_03 = 0;
	                let pro_04 = 0;
	                let pro_05 = 0;
	                let pro_06 = 0;
	                
	                if (totamt > 0) {
	                	pro_01 = Math.round((totpha / totamt) * 100);
	                	pro_02 = 100 - pro_01;
	                } 
	                if (phar03 + phar04 > 0 ) {
	                	pro_03 = Math.round((phar03 / totpha) * 100);
	                	pro_04 = 100 - pro_03;
	                }
	                if (drgamt + hwiamt > 0) {
	                	pro_05 = Math.round((drgamt / totpha) * 100);
	                	pro_06 = 100 - pro_05;	
	                }
	                
	                const chart = Morris.Bar({
		    	        element: 'morris-bar-chartD1',
		    	        data: [
		    	            { y: '총진료비 대비 약제비 (백만원)', 
		    	              a: Math.round(totamt/1000000), 
		    	              b: Math.round(totpha/1000000), 
		    	              c: Math.round(drgamt/1000000), 
		    	              d: Math.round(hwiamt/1000000) }
		    	        ],
		    	        xkey: 'y',
		    		    ykeys: ['a', 'b', 'c', 'd'],
		    		    labels: ['총진료비','총약제비', '정액금액','행위금액' ],
		    		    barColors: ['#0B8ECA','#00B050', '#C785C8', '#ED7D31'],
		    		    hideHover: 'auto',
		    		    gridLineColor: '#eef0f2',
		    		    resize: true,
		    		    gridTextSize: 12, // 축 폰트 크기 조절
		    		    labelsColor: '#000', // 레이블 색상 설정
		    		    barSizeRatio: 1, // 막대 크기 조정
		    		    barGap: 5 // 막대 간격 조정
		    	    });
	                
	                const chartContainer2 = document.getElementById("morris-bar-chartD2");    	    	
	                chartContainer2.innerHTML = '';
	                chartContainer2.style.height = "180px";
	                chartContainer2.style.width  = "180px";
	                
	                const chart2 = Morris.Donut({
	                    element: 'morris-bar-chartD2',
	                    data: [{
	                        label: "\xa0 \xa0 총진료비 \xa0 \xa0",
	                        value: pro_02,
	                    }, {
	                        label: "\xa0 \xa0 총약제비 \xa0 \xa0",
	                        value: pro_01
	                    }],
	                    resize: true,
	                    colors: ['#0B8ECA','#00B050'],
	                    formatter: function (y) { return y + '%'; }
	                });
	                setTimeout(() => { chart2.select(1); }, 50);
	                
	                const chartContainer3 = document.getElementById("morris-bar-chartD3");    	    	
	                chartContainer3.innerHTML = '';
	                chartContainer3.style.height = "180px";
	                chartContainer3.style.width  = "180px";
	                
	                const chart3 = Morris.Donut({
	                    element: 'morris-bar-chartD3',
	                    data: [{
	                        label: "\xa0 \xa0 총약제비(경구) \xa0 \xa0",
	                        value: pro_03,
	                    }, {
	                        label: "\xa0 \xa0 총약제비(주사) \xa0 \xa0",
	                        value: pro_04
	                    }],
	                    resize: true,
	                    colors: ['#BFB500', '#808080'], 
	                	formatter: function (y) { return y + '%'; }
	                });
	                
	                const chartContainer4 = document.getElementById("morris-bar-chartD4");    	    	
	                chartContainer4.innerHTML = '';
	                chartContainer4.style.height = "180px";
	                chartContainer4.style.width  = "180px";
	                
	                const chart4 = Morris.Donut({
	                    element: 'morris-bar-chartD4',
	                    data: [{
	                        label: "\xa0 \xa0 총약제비(정액) \xa0 \xa0",
	                        value: pro_05,
	                    }, {
	                        label: "\xa0 \xa0 총약제비(행위) \xa0 \xa0",
	                        value: pro_06
	                    }], 
	                    resize: true,
	                    colors: ['#C785C8', '#ED7D31'],
	                    formatter: function (y) { return y + '%'; }
	                });
	                
		 	    } else if (jobFlag === "13") { 
		 	    	jobCode = '1'; 
		 	    	total_Report_DataList();
		 	    	
		 	   } else if (jobFlag === "14") {
	                
		            const ctx1 = document.getElementById('mixedChartF1').getContext('2d');

		            mixedChart1 = new Chart(ctx1, {
		                type: 'line',
		                data: {
		                    labels: [f_yymm, [m_yymm,"건당진료비"], e_yymm],
		                    datasets: [
		                        {
		                            label: '건당진료비',
		                            type: 'bar',
		                            data: [
		                                replaceMulti(response.resultData[4,5].ta_f_ym, ","),
		                                replaceMulti(response.resultData[5,5].ta_m_ym, ","),
		                                replaceMulti(response.resultData[6,5].ta_e_ym, ",")
		                            ],
		                            backgroundColor: 'rgba(11, 142, 202, 1)',   // '#0B8ECA' → 투명도 80%	→ 100%로 변경
		                            borderWidth: 1,
		                            borderRadius: 8,
		                            yAxisID: 'y',
		                            minBarLength: 1,
		                            order: 1,
		                            clip: false
		                        },
		                        {
		                            label: '건당진료비',
		                            type: 'bar',
		                            data: [
		                                replaceMulti(response.resultData[4,5].fr_yymm, ","),
		                                replaceMulti(response.resultData[5,5].midyymm, ","),
		                                replaceMulti(response.resultData[6,5].endyymm, ",")
		                            ],
		                            backgroundColor: 'rgba(237, 125, 49, 1)',   // '#ED7D31' → 투명도 80%	→ 100%로 변경
		                            borderWidth: 1,
		                            borderRadius: 8,
		                            yAxisID: 'y',
		                            minBarLength: 1,
		                            order: 2,
		                            clip: false
		                        },
		                        {
		                            label: '건당진료비',
		                            type: 'line',
		                            data: [
		                                replaceMulti(response.resultData[4,5].fr_yymm, ","),
		                                replaceMulti(response.resultData[5,5].midyymm, ","),
		                                replaceMulti(response.resultData[6,5].endyymm, ",")
		                            ],
		                            borderColor: '#000',
		                            backgroundColor: '#000',
		                            borderWidth: 1,
		                            yAxisID: 'y',
		                            // borderDash: [5, 5],
		                            borderDash: [], // 실선으로 표시
		                            fill: false,
		                            tension: 0.4,
		                            pointRadius: 4,
		                            pointHoverRadius: 6,
		                            order: 0,
		                            clip: false
		                        }
		                    ]
		                },
		                options: {
		                    maintainAspectRatio: false,
		                    responsive: true,
		                    plugins: {
		                        legend: {
		                            display: false
		                        }
		                    },
		                    scales: {
		                        y: {
		                            beginAtZero: true,
		                            grid: {
		                                color: 'rgba(0, 0, 0, 0.05)'
		                            }
		                        },
		                        y1: {
		                            beginAtZero: true,
		                            position: 'right',
		                            ticks: {
		                                display: false
		                            },
		                            grid: {
		                                drawOnChartArea: false
		                            }
		                        }
		                    }
		                }
		            });
		            
		            
		            const setValues = [
		                parseFloat(replaceMulti(response.resultData[7,6].fr_yymm, ",")),
		                parseFloat(replaceMulti(response.resultData[7,6].midyymm, ",")),
		                parseFloat(replaceMulti(response.resultData[7,6].endyymm, ","))
		            ];
		            
		            const ctx2 = document.getElementById('mixedChartF2').getContext('2d');;
		            
		            mixedChart2 = new Chart(ctx2, {
		                type: 'bar',
		                data: {
		                    labels: [f_yymm, [m_yymm," 일당진료비"], e_yymm],
		                    datasets: [
		                    	{
		                            label: '일당진료비',
		                            type: 'bar',
		                            data: setValues,
		                            backgroundColor: 'rgba(237, 125, 49, 1)',   // '#ED7D31' → 투명도 80%	 
		                            borderWidth: 1,
		                            borderRadius: 8,
		                            yAxisID: 'y',
		                            minBarLength: 1,
		                            order: 1,
		                            clip: false,
		                         
		                            categoryPercentage: 0.8,
		                            barPercentage: 0.8      
		                        },
		                        {		                        	
		                            label: '일당진료비',
		                            type: 'line',
		                            data: setValues,
		                            borderColor: '#000',
		                            backgroundColor: '#000',
		                            borderWidth: 1,
		                            yAxisID: 'y1',
		                            borderDash: [],
		                            fill: false,
		                            tension: 0.4,
		                            pointRadius: 4,
		                            pointHoverRadius: 6,
		                            order: 0,
		                            clip: false
		                        }
		                    ]
		                },
		                options: {
		                    maintainAspectRatio: false,
		                    responsive: true,
		                    plugins: {
		                        legend: {
		                            display: false
		                        }
		                    },
		                    scales: {
		                        y: {
		                            beginAtZero: true,
		                            grid: {
		                                color: 'rgba(0, 0, 0, 0.05)'
		                            }
		                        },
		                        y1: {
		                            beginAtZero: true,
		                            position: 'right',
		                            ticks: {
		                                display: false
		                            },
		                            grid: {
		                                drawOnChartArea: false
		                            }
		                        }
		                    }
		                }
		            });
	                
		 	    } 
		   	}
        },
        error: function(xhr, status, error) {
             console.error("Error fetching data:", error);
        }
     
    });
    
    
}

</script>


<script type="text/javascript">
	   
function fn_CreateData(flag) {
	
	let selected_Year = document.getElementById("year_Select").value;
    let selectedMonth = document.getElementById("monthSelect").value;
    
    if (flag) { jobFlag = flag; }	
    
    
    /*
	messageBox("9","<h5> 자 료 생 성 ..: " + selected_Year + "년" + selectedMonth + "월 " + jobFlag + " 자료를 생성 하시겠습니까 ? </h5><p></p><br>","","","");
	*/
	
   	//confirmYes.addEventListener('click', () => {
   		$.ajax({
   			
   		  url: "/main/createTotalReport.do",
              type: "POST",
              data: { hosp_cd: hospid,
            	      jobyymm: selected_Year + selectedMonth,
            	      make_fg: jobFlag
	      },
	      success: function(response) {
	    	 
	    	  
	    	if (response) { // 서버가 성공 응답을 보냈을 때 실행
	    		  
	    		let accordionBody = document.querySelector("#rounded-stylish_collapse");
	            if (accordionBody) {
	                accordionBody.classList.add("show"); 
	            }
	             
            	setMakeGrid();
        	}
	    	 
	      },
	      error: function(xhr, status, error) {
	          console.error("Error fetching data:", error);
	      }
	      
		});
   		
   		//messageDialog.hide();
   		
    //});
}
//전체 처리
function fn_CreateData_all() {

    let selected_Year = document.getElementById("year_Select").value;
    let selectedMonth = document.getElementById("monthSelect").value;

    const flagList = [
        '01','02','03','04','05','06',
        '07','08','09','10','11','12',
        '13','14'
    ];

    let index = 0;

    function runNext() {

        if (index >= flagList.length) {
            alert("전체 자료 생성 완료!");
            // 필요하면 여기서 갱신
            // setMakeGrid();
            return;
        }

        const currentFg = flagList[index];

        $.ajax({
            url: "/main/createTotalReport.do",
            type: "POST",
            data: {
                hosp_cd: hospid,
                jobyymm: selected_Year + selectedMonth,
                make_fg: currentFg
            },
            success: function(response) {
                console.log(currentFg + " success:", response);
                index++;
                runNext();
            },
            error: function(xhr, status, error) {
                console.error(currentFg + " error:", error);
                index++;
                runNext(); // 실패해도 다음 진행 (원하면 여기서 중단 가능)
            }
        });
    }

    runNext();
}


function fn_Update()
{
	let selected_Year = document.getElementById("year_Select").value;
    let selectedMonth = document.getElementById("monthSelect").value;

    $.ajax({
			
		url: "/main/saveGasanMst.do",
        type: "POST",
        data: { hosp_cd: hospid,
                jobyymm: selected_Year + selectedMonth,
         	    doc_grd: $("#doc_grd").val(),
       	        nur_grd: $("#nur_grd").val(),
			    nur_cnt: $("#nur_cnt").val(),
			    need_ga: $("#need_ga").val(),
			    dietga1: $("#dietga1").val(),
			    dietga2: $("#dietga2").val(),
			    dietga3: $("#dietga3").val(),
			    dietga4: $("#dietga4").val(),
			    reg_user: userid
			    
        },
        success: function(response) {
    	    if (response) { // 서버가 성공 응답을 보냈을 때 실행
    	    	
    	    	Swal.fire({
		            title: '처리확인',
		            text:  '정상처리 되었습니다. ',
		            icon:  'success',
		            confirmButtonText: '확인',
		            timer: 800,
		            timerProgressBar: true,
		            showConfirmButton: false
		        });
    	    	
    	    	let accordionBody = document.querySelector("#rounded-stylish_collapse");
	            if (accordionBody) {
	                accordionBody.classList.add("show"); 
	            }
	            
            	setMakeGrid();
     	    }
        },
        error: function(xhr, status, error) {
            console.error("Error fetching data:", error);
        }
      
	});
	
	
}

function total_Report_DataList() {
	
	page_Navig = false;
	defaultCnt = 30;
	page_Hight = 600;
	
	if      (jobFlag === "01") { tableName = document.getElementById('tableName01');
	    c_Head_Set = [  '청구번호','환자ID','성명','종별','청구구분','명일련','MMSE','월 예상수익','점검내용' ];	    
		columnsSet = [  { data: 'claimNo',  visible: true,  className: 'dt-body-center', width: '100px' },
						{ data: 'patId',    visible: true,  className: 'dt-body-center', width: '100px' },
						{ data: 'patNm',    visible: true,  className: 'dt-body-center', width: '100px' },
						{ data: 'medCovType',  visible: true,  className: 'dt-body-center', width: '100px' },
						{ data: 'claimGrp', visible: false,  className: 'dt-body-center', width: '100px' },
						{ data: 'billSeq',  visible: true,  className: 'dt-body-center', width: '80px' },
						{ data: 'mmseVal',  visible: true,  className: 'dt-body-center', width: '80px' },
						
		   				{ data: 'inspAmt',  visible: true,  className: 'dt-body-right',  width: '120px',
		                    render: function(data, type, row) {
		           				if (type === 'display') {
		           					return getFormat(data,'n1') + ' 원'
		               			}
		               			return data;
		       				},
		   				},	
		   				{ data: 'inspCode', visible: true,  className: 'dt-body-left', width: '100px', 
   							render: function(data, type, row) {
   			        			if (type === 'display') {
   			        				if (data === 'E1') return '치료식(O),영양관리료(X)';
   			        				if (data === 'E2') return '치료식(O),영양관리료(O),13점 이하';
   			        				if (data === 'E3') return '치료식(O),영양관리료(X),13점 이상';
   			            		}
   			            		return data;
   			  			    },
   						}
					 ];
		// 초기 data Sort,  없으면 []
		muiltSorts = [];
		// Sort여부 표시를 일부만 할 때 개별 id, ** 전체 적용은 '_all'하면 됩니다. ** 전체 적용 안함은 []        				 
		showSortNo = [];                   
		// Columns 숨김 columnsSet -> visible로 대체함 hideColums 보다 먼제 처리됨 ( visible를 선언하지 않으면 hideColums컬럼 적용됨 )	
		hideColums = [];             // 없으면 []; 일부 컬럼 숨길때		
		txt_Markln = 20;                       				 // 컬럼의 글자수가 설정값보다 크면, 다음은 ...로 표시함
		// 글자수 제한표시를 일부만 할 때 개별 id, ** 전체 적용은 '_all'하면 됩니다. ** 전체 적용 안함은 []
		markColums = [];
	}
    else if (jobFlag === "02") { tableName = document.getElementById('tableName02');
    		
    	
        c_Head_Set = [  '환자ID','성명','입원일자','요양개시','작성일자','평가군','평가구분','상향가능'  ];
        
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
						
						{ data: 'patClass',  visible: true,  className: 'dt-body-center',   width: '100px'  },
						{ data: 'evalType',  visible: true,  className: 'dt-body-center',   width: '100px'  },
						{
						    data: 'classUp',
						    visible: true,
						    className: 'dt-body-left',
						    width: '100px',
						    render: function(data, type, row) {
						        if (type === 'display') {
						            if (data !== null && data !== '' && data !== undefined) {
						                return '<span style="color: blue; font-weight: bold;">' + data + '</span>';
						            }
						        }
						        return data;
						    }
						}
    				 ];
    	
    	// 초기 data Sort,  없으면 []
    	muiltSorts = [];
    	// Sort여부 표시를 일부만 할 때 개별 id, ** 전체 적용은 '_all'하면 됩니다. ** 전체 적용 안함은 []        				 
    	showSortNo = ['_all'];                   
    	// Columns 숨김 columnsSet -> visible로 대체함 hideColums 보다 먼제 처리됨 ( visible를 선언하지 않으면 hideColums컬럼 적용됨 )	
    	hideColums = [];             // 없으면 []; 일부 컬럼 숨길때		
    	txt_Markln = 8;                       				 // 컬럼의 글자수가 설정값보다 크면, 다음은 ...로 표시함
    	// 글자수 제한표시를 일부만 할 때 개별 id, ** 전체 적용은 '_all'하면 됩니다. ** 전체 적용 안함은 []
    	markColums = ['evalType'];
    	
    }
    else if (jobFlag === "03") { tableName  = document.getElementById('tableName03');
    
        page_Hight = 800;
    	
    	c_Head_Set = [  '환자ID','성명','입원일자','요양개시','작성일자','평가군','평가구분','ADL점수'  ];    	
    	columnsSet = [  { data: 'patId',    visible: true,  className: 'dt-body-center', width: '100px' },
						{ data: 'patNm',    visible: true,  className: 'dt-body-center', width: '100px' },
						{ data: 'admitDt',  visible: true,  className: 'dt-body-center', width: '100px',
			                render: function(data, type, row) {
			       				if (type === 'display') {
			       					return getFormat(data,'d1')
			           			}
			           			return data;
			   				},
						},
						{ data: 'medStart', visible: true,  className: 'dt-body-center', width: '100px',
			             	render: function(data, type, row) {
			   					if (type === 'display') {
			   						return getFormat(data,'d1')
			       				}
			       				return data;
							},
						},    	   				
						{ data: 'docDt',    visible: true,  className: 'dt-body-center', width: '100px',
			         		render: function(data, type, row) {
									if (type === 'display') {
										return getFormat(data,'d1')
			   					}
		   						return data;
							},
						},
						{ data: 'patClass', visible: true,  className: 'dt-body-center', width: '100px' },
						{ data: 'evalType', visible: true,  className: 'dt-body-left',   width: '100px' },
						{ data: 'adlScore', visible: true,  className: 'dt-body-center', width: '100px' }
    				 ];
    	// 초기 data Sort,  없으면 []
    	muiltSorts = [];
    	// Sort여부 표시를 일부만 할 때 개별 id, ** 전체 적용은 '_all'하면 됩니다. ** 전체 적용 안함은 []        				 
    	showSortNo = ['_all'];                   
    	// Columns 숨김 columnsSet -> visible로 대체함 hideColums 보다 먼제 처리됨 ( visible를 선언하지 않으면 hideColums컬럼 적용됨 )	
    	hideColums = [];             // 없으면 []; 일부 컬럼 숨길때		
    	txt_Markln = 8;                       				 // 컬럼의 글자수가 설정값보다 크면, 다음은 ...로 표시함
    	// 글자수 제한표시를 일부만 할 때 개별 id, ** 전체 적용은 '_all'하면 됩니다. ** 전체 적용 안함은 []
    	markColums = ['evalType'];
    	
    }
    else if (jobFlag === "04") { tableName = document.getElementById('tableName04');
    
    	
	    c_Head_Set = [  '청구번호','환자ID','성명','종별','청구구분','명일련','급여총액','청구금액','장애기금','본인부담','청구기간','입원일수'  ];	    
		columnsSet = [  { data: 'claimNo',  visible: true,  className: 'dt-body-center', width: '100px' },
						{ data: 'patId',    visible: true,  className: 'dt-body-center', width: '100px' },
						{ data: 'patNm',    visible: true,  className: 'dt-body-center', width: '100px' },
						{ data: 'medCovType',  visible: true,  className: 'dt-body-center', width: '100px' },
						{ data: 'claimGrp', visible: true,  className: 'dt-body-center', width: '100px' },
						{ data: 'billSeq',  visible: true,  className: 'dt-body-center', width: '80px' },
						
		   				{ data: 'totAmt',   visible: true,  className: 'dt-body-right',  width: '120px',
		                    render: function(data, type, row) {
		           				if (type === 'display') {
		           					return getFormat(data,'n1') + '원'
		               			}
		               			return data;
		       				},
		   				},		   				
		   				{ data: 'claimAmt', visible: true,  className: 'dt-body-right', width: '120px',
	                     	render: function(data, type, row) {
	           					if (type === 'display') {
	           						return getFormat(data,'n1') + '원'
	               				}
	               				return data;
	       					},
	   					},    	   				
	   					{ data: 'disabledAmt',visible: true,  className: 'dt-body-right', width: '100px',
	                 		render: function(data, type, row) {
	       						if (type === 'display') {
	       							return getFormat(data,'n1') + '원'
	           					}
	           					return data;
	   						},
						},
						{ data: 'selfAmt',  visible: true,  className: 'dt-body-right', width: '100px',
	                 		render: function(data, type, row) {
	       						if (type === 'display') {
	       							return getFormat(data,'n1') + '원'
	           					}
	           					return data;
	   						}
						},
						
		   				{ data: 'jinDays',  visible: true,  className: 'dt-body-right', width: '100px' },    	   				
		   				{ data: 'admDays',  visible: true,  className: 'dt-body-right', width: '100px' }
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
    else if (jobFlag === "05") { tableName = document.getElementById('tableName05');
    
	    c_Head_Set = [  '환자ID','성명','종별','명일련','급여총액','청구금액','장애기금','본인부담','명세서','청구기간','입원일수','청구번호' ];	    
		columnsSet = [  { data: 'patId',    visible: true,  className: 'dt-body-center', width: '100px' },
						{ data: 'patNm',    visible: true,  className: 'dt-body-center', width: '100px' },
						{ data: 'medCovType',  visible: true,  className: 'dt-body-center', width: '100px' },
					//	{ data: 'claimGrp', visible: true,  className: 'dt-body-center', width: '100px' ,
					//		render: function(data, type, row) {
	           		//			if (data === '분리청구') {
	           		//				return '' ;
	               	//			}
	               	//			return data;
	       			//		},
					//	},	
						{ data: 'billSeq',  visible: true,  className: 'dt-body-center', width: '80px' },
						
		   				{ data: 'totAmt',   visible: true,  className: 'dt-body-right',  width: '120px',
		                    render: function(data, type, row) {
		           				if (type === 'display') {
		           					return getFormat(data,'n1') + '원'
		               			}
		               			return data;
		       				},
		   				},		   				
		   				{ data: 'claimAmt', visible: true,  className: 'dt-body-right', width: '120px',
	                     	render: function(data, type, row) {
	           					if (type === 'display') {
	           						return getFormat(data,'n1') + '원'
	               				}
	               				return data;
	       					},
	   					},    	   				
	   					{ data: 'disabledAmt',visible: true,  className: 'dt-body-right', width: '100px',
	                 		render: function(data, type, row) {
	       						if (type === 'display') {
	       							return getFormat(data,'n1') + '원'
	           					}
	           					return data;
	   						},
						},
						{ data: 'selfAmt',  visible: true,  className: 'dt-body-right', width: '100px',
	                 		render: function(data, type, row) {
	       						if (type === 'display') {
	       							return getFormat(data,'n1') + '원'
	           					}
	           					return data;
	   						}
						},
						
						{ data: 'myoungFg', visible: true,  className: 'dt-body-center', width: '100px' },
		   				{ data: 'jinDays',  visible: true,  className: 'dt-body-right', width: '100px' },    	   				
		   				{ data: 'admDays',  visible: true,  className: 'dt-body-right', width: '100px' },
		   				{ data: 'claimNo',  visible: true,  className: 'dt-body-center', width: '100px' }
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
    else if (jobFlag === "06") { tableName = document.getElementById('tableName06');
    
	    c_Head_Set = [  '청구번호','환자ID','성명','종별','청구구분','명일련','급여총액','청구금액','장애기금','본인부담','명세서','청구기간','입원일수'  ];	    
		columnsSet = [  { data: 'claimNo',  visible: true,  className: 'dt-body-center', width: '100px' },
						{ data: 'patId',    visible: true,  className: 'dt-body-center', width: '100px' },
						{ data: 'patNm',    visible: true,  className: 'dt-body-center', width: '100px' },
						{ data: 'medCovType',  visible: true,  className: 'dt-body-center', width: '100px' },
						{ data: 'claimGrp', visible: true,  className: 'dt-body-center', width: '100px' },
						{ data: 'billSeq',  visible: true,  className: 'dt-body-center', width: '80px' },
						
		   				{ data: 'totAmt',   visible: true,  className: 'dt-body-right',  width: '120px',
		                    render: function(data, type, row) {
		           				if (type === 'display') {
		           					return getFormat(data,'n1') + '원'
		               			}
		               			return data;
		       				},
		   				},		   				
		   				{ data: 'claimAmt', visible: true,  className: 'dt-body-right', width: '120px',
	                     	render: function(data, type, row) {
	           					if (type === 'display') {
	           						return getFormat(data,'n1') + '원'
	               				}
	               				return data;
	       					},
	   					},    	   				
	   					{ data: 'disabledAmt',visible: true,  className: 'dt-body-right', width: '100px',
	                 		render: function(data, type, row) {
	       						if (type === 'display') {
	       							return getFormat(data,'n1') + '원'
	           					}
	           					return data;
	   						},
						},
						{ data: 'selfAmt',  visible: true,  className: 'dt-body-right', width: '100px',
	                 		render: function(data, type, row) {
	       						if (type === 'display') {
	       							return getFormat(data,'n1') + '원'
	           					}
	           					return data;
	   						}
						},
						
						{ data: 'myoungFg', visible: true,  className: 'dt-body-center', width: '100px' },
		   				{ data: 'jinDays',  visible: true,  className: 'dt-body-right', width: '100px' },    	   				
		   				{ data: 'admDays',  visible: true,  className: 'dt-body-right', width: '100px' }
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
    else if (jobFlag === "07") { tableName = document.getElementById('tableName07');
    
	    c_Head_Set = [  '청구번호','환자ID','성명','종별','청구구분','명일련','급여총액','청구금액','장애기금','본인부담','명세서','청구기간','입원일수'  ];	    
		columnsSet = [  { data: 'claimNo',  visible: true,  className: 'dt-body-center', width: '100px' },
						{ data: 'patId',    visible: true,  className: 'dt-body-center', width: '100px' },
						{ data: 'patNm',    visible: true,  className: 'dt-body-center', width: '100px' },
						{ data: 'medCovType',  visible: true,  className: 'dt-body-center', width: '100px' },
						{ data: 'claimGrp', visible: true,  className: 'dt-body-center', width: '100px' },
						{ data: 'billSeq',  visible: true,  className: 'dt-body-center', width: '80px' },
						
		   				{ data: 'totAmt',   visible: true,  className: 'dt-body-right',  width: '120px',
		                    render: function(data, type, row) {
		           				if (type === 'display') {
		           					return getFormat(data,'n1') + '원'
		               			}
		               			return data;
		       				},
		   				},		   				
		   				{ data: 'claimAmt', visible: true,  className: 'dt-body-right', width: '120px',
	                     	render: function(data, type, row) {
	           					if (type === 'display') {
	           						return getFormat(data,'n1') + '원'
	               				}
	               				return data;
	       					},
	   					},    	   				
	   					{ data: 'disabledAmt',visible: true,  className: 'dt-body-right', width: '100px',
	                 		render: function(data, type, row) {
	       						if (type === 'display') {
	       							return getFormat(data,'n1') + '원'
	           					}
	           					return data;
	   						},
						},
						{ data: 'selfAmt',  visible: true,  className: 'dt-body-right', width: '100px',
	                 		render: function(data, type, row) {
	       						if (type === 'display') {
	       							return getFormat(data,'n1') + '원'
	           					}
	           					return data;
	   						}
						},
						
						{ data: 'myoungFg', visible: true,  className: 'dt-body-center', width: '100px' },
		   				{ data: 'jinDays',  visible: true,  className: 'dt-body-right', width: '100px' },    	   				
		   				{ data: 'admDays',  visible: true,  className: 'dt-body-right', width: '100px' }
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
    else if (jobFlag === "08") { tableName = document.getElementById('tableName08');
	    c_Head_Set = [  '청구번호','환자ID','성명','종별','청구구분','명일련','급여총액','청구금액','장애기금','본인부담','명세서','청구기간','입원일수'  ];	    
		columnsSet = [  { data: 'claimNo',  visible: true,  className: 'dt-body-center', width: '100px' },
						{ data: 'patId',    visible: true,  className: 'dt-body-center', width: '100px' },
						{ data: 'patNm',    visible: true,  className: 'dt-body-center', width: '100px' },
						{ data: 'medCovType',  visible: true,  className: 'dt-body-center', width: '100px' },
						{ data: 'claimGrp', visible: true,  className: 'dt-body-center', width: '100px' },
						{ data: 'billSeq',  visible: true,  className: 'dt-body-center', width: '80px' },
						
		   				{ data: 'totAmt',   visible: true,  className: 'dt-body-right',  width: '120px',
		                    render: function(data, type, row) {
		           				if (type === 'display') {
		           					return getFormat(data,'n1') + '원'
		               			}
		               			return data;
		       				},
		   				},		   				
		   				{ data: 'claimAmt', visible: true,  className: 'dt-body-right', width: '120px',
	                     	render: function(data, type, row) {
	           					if (type === 'display') {
	           						return getFormat(data,'n1') + '원'
	               				}
	               				return data;
	       					},
	   					},    	   				
	   					{ data: 'disabledAmt',visible: true,  className: 'dt-body-right', width: '100px',
	                 		render: function(data, type, row) {
	       						if (type === 'display') {
	       							return getFormat(data,'n1') + '원'
	           					}
	           					return data;
	   						},
						},
						{ data: 'selfAmt',  visible: true,  className: 'dt-body-right', width: '100px',
	                 		render: function(data, type, row) {
	       						if (type === 'display') {
	       							return getFormat(data,'n1') + '원'
	           					}
	           					return data;
	   						}
						},
						
						{ data: 'myoungFg', visible: true,  className: 'dt-body-center', width: '100px' },
		   				{ data: 'jinDays',  visible: true,  className: 'dt-body-right', width: '100px' },    	   				
		   				{ data: 'admDays',  visible: true,  className: 'dt-body-right', width: '100px' }
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
    else if (jobFlag === "09") { tableName = document.getElementById('tableName09');
	    c_Head_Set = [  '청구번호','환자ID','성명','종별','청구구분','명일련','계산총액','청구금액','본인부담','EDI코드','단가','일투','일수'  ];	    
		columnsSet = [  { data: 'claimNo',  visible: true,  className: 'dt-body-center', width: '100px' },
						{ data: 'patId',    visible: true,  className: 'dt-body-center', width: '100px' },
						{ data: 'patNm',    visible: true,  className: 'dt-body-center', width: '100px' },
						{ data: 'medCovType',  visible: true,  className: 'dt-body-center', width: '100px' },
						{ data: 'claimGrp', visible: true,  className: 'dt-body-center', width: '100px' },
						{ data: 'billSeq',  visible: true,  className: 'dt-body-center', width: '80px' },
						
		   				{ data: 'calcAmt',  visible: true,  className: 'dt-body-right',  width: '120px',
		                    render: function(data, type, row) {
		           				if (type === 'display') {
		           					return getFormat(data,'n1') + '원'
		               			}
		               			return data;
		       				},
		   				},		   				
		   				{ data: 'claimAmt', visible: true,  className: 'dt-body-right', width: '120px',
	                     	render: function(data, type, row) {
	           					if (type === 'display') {
	           						return getFormat(data,'n1') + '원'
	               				}
	               				return data;
	       					},
	   					},    	   				
						{ data: 'selfAmt',  visible: true,  className: 'dt-body-right', width: '100px',
	                 		render: function(data, type, row) {
	       						if (type === 'display') {
	       							return getFormat(data,'n1') + '원'
	           					}
	           					return data;
	   						}
						},
						
						{ data: 'ediCode', visible: true,  className: 'dt-body-center', width: '100px' },

						{ data: 'unitAmt',  visible: true,  className: 'dt-body-right', width: '100px',
	                 		render: function(data, type, row) {
	       						if (type === 'display') {
	       							return getFormat(data,'n1') + '원'
	           					}
	           					return data;
	   						}
						},		   				
		   				
		   				{ data: 'dayQtys',  visible: true,  className: 'dt-body-right', width: '100px' },
		   				{ data: 'totDays',  visible: true,  className: 'dt-body-right', width: '100px' }
					 ];
		// 초기 data Sort,  없으면 []
		muiltSorts = [];
		// Sort여부 표시를 일부만 할 때 개별 id, ** 전체 적용은 '_all'하면 됩니다. ** 전체 적용 안함은 []        				 
		showSortNo = ['_all'];                   
		// Columns 숨김 columnsSet -> visible로 대체함 hideColums 보다 먼제 처리됨 ( visible를 선언하지 않으면 hideColums컬럼 적용됨 )	
		hideColums = [];             // 없으면 []; 일부 컬럼 숨길때		
		txt_Markln = 20;                       				 // 컬럼의 글자수가 설정값보다 크면, 다음은 ...로 표시함
		// 글자수 제한표시를 일부만 할 때 개별 id, ** 전체 적용은 '_all'하면 됩니다. ** 전체 적용 안함은 []
		markColums = []
    }
    else if (jobFlag === "10") { tableName = document.getElementById('tableName10');
	    c_Head_Set = [  '청구번호','환자ID','성명','종별','청구구분','명일련','계산총액','청구금액','본인부담','EDI코드','단가','일투','일수'  ];	    
		columnsSet = [  { data: 'claimNo',  visible: true,  className: 'dt-body-center', width: '100px' },
						{ data: 'patId',    visible: true,  className: 'dt-body-center', width: '100px' },
						{ data: 'patNm',    visible: true,  className: 'dt-body-center', width: '100px' },
						{ data: 'medCovType',  visible: true,  className: 'dt-body-center', width: '100px' },
						{ data: 'claimGrp', visible: true,  className: 'dt-body-center', width: '100px' },
						{ data: 'billSeq',  visible: true,  className: 'dt-body-center', width: '80px' },
						
		   				{ data: 'calcAmt',  visible: true,  className: 'dt-body-right',  width: '120px',
		                    render: function(data, type, row) {
		           				if (type === 'display') {
		           					return getFormat(data,'n1') + '원'
		               			}
		               			return data;
		       				},
		   				},		   				
		   				{ data: 'claimAmt', visible: true,  className: 'dt-body-right', width: '120px',
	                     	render: function(data, type, row) {
	           					if (type === 'display') {
	           						return getFormat(data,'n1') + '원'
	               				}
	               				return data;
	       					},
	   					},    	   				
						{ data: 'selfAmt',  visible: true,  className: 'dt-body-right', width: '100px',
	                 		render: function(data, type, row) {
	       						if (type === 'display') {
	       							return getFormat(data,'n1') + '원'
	           					}
	           					return data;
	   						}
						},
						
						{ data: 'ediCode', visible: true,  className: 'dt-body-center', width: '100px' },
	
						{ data: 'unitAmt',  visible: true,  className: 'dt-body-right', width: '100px',
	                 		render: function(data, type, row) {
	       						if (type === 'display') {
	       							return getFormat(data,'n1') + '원'
	           					}
	           					return data;
	   						}
						},		   				
		   				
		   				{ data: 'dayQtys',  visible: true,  className: 'dt-body-right', width: '100px' },
		   				{ data: 'totDays',  visible: true,  className: 'dt-body-right', width: '100px' }
					 ];
		// 초기 data Sort,  없으면 []
		muiltSorts = [];
		// Sort여부 표시를 일부만 할 때 개별 id, ** 전체 적용은 '_all'하면 됩니다. ** 전체 적용 안함은 []        				 
		showSortNo = ['_all'];                   
		// Columns 숨김 columnsSet -> visible로 대체함 hideColums 보다 먼제 처리됨 ( visible를 선언하지 않으면 hideColums컬럼 적용됨 )	
		hideColums = [];             // 없으면 []; 일부 컬럼 숨길때		
		txt_Markln = 20;                       				 // 컬럼의 글자수가 설정값보다 크면, 다음은 ...로 표시함
		// 글자수 제한표시를 일부만 할 때 개별 id, ** 전체 적용은 '_all'하면 됩니다. ** 전체 적용 안함은 []
		markColums = []
    }
    else if (jobFlag === "11") { tableName = document.getElementById('tableName11');
        page_Navig = true;
    	page_Hight = 360;
    	c_Head_Set = [  '청구번호','환자ID','성명','종별','청구구분','명일련','EDI코드','단가','일투','일수','계산금액'  ];	    
		columnsSet = [  { data: 'claimNo',  visible: true,  className: 'dt-body-center', width: '100px' },
						{ data: 'patId',    visible: true,  className: 'dt-body-center', width: '100px' },
						{ data: 'patNm',    visible: true,  className: 'dt-body-center', width: '100px' },
						{ data: 'medCovType', visible: true, className: 'dt-body-center', width: '100px' },
						{ data: 'claimGrp', visible: true,  className: 'dt-body-center', width: '100px' },
						{ data: 'billSeq',  visible: true,  className: 'dt-body-center', width: '80px' },
						{ data: 'ediCode',  visible: true,  className: 'dt-body-center', width: '100px' },
						
		   						   				
		   				{ data: 'unitAmt',  visible: true,  className: 'dt-body-right', width: '100px',
	                 		render: function(data, type, row) {
	       						if (type === 'display') {
	       							return getFormat(data,'n1') + '원'
	           					}
	           					return data;
	   						}
						},
						
		   				
		   				{ data: 'dayQtys',  visible: true,  className: 'dt-body-right', width: '100px' },
		   				{ data: 'totDays',  visible: true,  className: 'dt-body-right', width: '100px' },
		   				
		   				{ data: 'calPrics',visible: true,  className: 'dt-body-right',  width: '100px',
		                    render: function(data, type, row) {
		           				if (type === 'display') {
		           					return getFormat(data,'n1') + '원'
		               			}
		               			return data;
		       				},
		   				}
					 ];
		// 초기 data Sort,  없으면 []
		muiltSorts = [];
		// Sort여부 표시를 일부만 할 때 개별 id, ** 전체 적용은 '_all'하면 됩니다. ** 전체 적용 안함은 []        				 
		showSortNo = ['_all'];                   
		// Columns 숨김 columnsSet -> visible로 대체함 hideColums 보다 먼제 처리됨 ( visible를 선언하지 않으면 hideColums컬럼 적용됨 )	
		hideColums = [];             // 없으면 []; 일부 컬럼 숨길때		
		txt_Markln = 10;                       				 // 컬럼의 글자수가 설정값보다 크면, 다음은 ...로 표시함
		// 글자수 제한표시를 일부만 할 때 개별 id, ** 전체 적용은 '_all'하면 됩니다. ** 전체 적용 안함은 []
		markColums = []
    }	
	else if (jobFlag === "12") { tableName  = document.getElementById('tableName12');
	    page_Navig = true;
		page_Hight = 620;
		c_Head_Set = [  '청구번호','환자ID','성명','종별','청구구분','명일련','EDI코드','단가','일투','일수','계산금액'  ];	    
		columnsSet = [  { data: 'claimNo',  visible: true,  className: 'dt-body-center', width: '100px' },
						{ data: 'patId',    visible: true,  className: 'dt-body-center', width: '100px' },
						{ data: 'patNm',    visible: true,  className: 'dt-body-center', width: '100px' },
						{ data: 'medCovType', visible: true, className: 'dt-body-center', width: '100px' },
						{ data: 'claimGrp', visible: true,  className: 'dt-body-center', width: '100px' },
						{ data: 'billSeq',  visible: true,  className: 'dt-body-center', width: '80px' },
						{ data: 'ediCode',  visible: true,  className: 'dt-body-center', width: '100px' },
						
		   						   				
		   				{ data: 'unitAmt',  visible: true,  className: 'dt-body-right', width: '100px',
	                 		render: function(data, type, row) {
	       						if (type === 'display') {
	       							return getFormat(data,'n1') + '원'
	           					}
	           					return data;
	   						}
						},
						
		   				
		   				{ data: 'dayQtys',  visible: true,  className: 'dt-body-right', width: '100px' },
		   				{ data: 'totDays',  visible: true,  className: 'dt-body-right', width: '100px' },
		   				
		   				{ data: 'calPrics',visible: true,  className: 'dt-body-right',  width: '100px',
		                    render: function(data, type, row) {
		           				if (type === 'display') {
		           					return getFormat(data,'n1') + '원'
		               			}
		               			return data;
		       				},
		   				}
					 ];
		// 초기 data Sort,  없으면 []
		muiltSorts = [];
		// Sort여부 표시를 일부만 할 때 개별 id, ** 전체 적용은 '_all'하면 됩니다. ** 전체 적용 안함은 []        				 
		showSortNo = ['_all'];                   
		// Columns 숨김 columnsSet -> visible로 대체함 hideColums 보다 먼제 처리됨 ( visible를 선언하지 않으면 hideColums컬럼 적용됨 )	
		hideColums = [];             // 없으면 []; 일부 컬럼 숨길때		
		txt_Markln = 10;                       				 // 컬럼의 글자수가 설정값보다 크면, 다음은 ...로 표시함
		// 글자수 제한표시를 일부만 할 때 개별 id, ** 전체 적용은 '_all'하면 됩니다. ** 전체 적용 안함은 []
		markColums = []
    }
    else if (jobFlag === "13") { tableName  = document.getElementById('tableName13');
    	page_Hight = 880;
		        
        c_Head_Set = [  '생년월일','성명','입원일자','입원시간','퇴원일자','퇴원시간','입원일수','청구일수','누락정보' ];    	
       	columnsSet = [  { data: 'patId',    visible: true,  className: 'dt-body-center', width: '100px' },
   						{ data: 'patNm',    visible: true,  className: 'dt-body-center', width: '100px' },
   						{ data: 'admitDt',  visible: true,  className: 'dt-body-center', width: '100px',
   			                render: function(data, type, row) {
   			       				if (type === 'display') {
   			       					return getFormat(data,'d1')
   			           			}
   			           			return data;
   			   				},
   						},
   						{ data: 'admitTm', visible: true,  className: 'dt-body-center', width: '100px' },
   						{ data: 'dischDt', visible: true,  className: 'dt-body-center', width: '100px',
   			             	render: function(data, type, row) {
   			   					if (type === 'display') {
   			   						return getFormat(data,'d1')
   			       				}
   			       				return data;
   							},
   						},   
   						{ data: 'dischTm', visible: true,  className: 'dt-body-center', width: '100px' },
   						{ data: 'admDays', visible: true,  className: 'dt-body-center', width: '100px' },
   						{ data: 'totDays', visible: true,  className: 'dt-body-center', width: '100px' },
   						{ data: 'jobNote', visible: true,  className: 'dt-body-center', width: '400px' }
       				 ];
       	// 초기 data Sort,  없으면 []
       	muiltSorts = [];
       	// Sort여부 표시를 일부만 할 때 개별 id, ** 전체 적용은 '_all'하면 됩니다. ** 전체 적용 안함은 []        				 
       	showSortNo = ['_all'];                   
       	// Columns 숨김 columnsSet -> visible로 대체함 hideColums 보다 먼제 처리됨 ( visible를 선언하지 않으면 hideColums컬럼 적용됨 )	
       	hideColums = [];             // 없으면 []; 일부 컬럼 숨길때		
       	txt_Markln = 8;                       				 // 컬럼의 글자수가 설정값보다 크면, 다음은 ...로 표시함
       	// 글자수 제한표시를 일부만 할 때 개별 id, ** 전체 적용은 '_all'하면 됩니다. ** 전체 적용 안함은 []
       	markColums = ['patNm'];
		
    } 
    else if (jobFlag === "14") { tableName = document.getElementById('tableName14');
	    page_Navig = true;
	    page_Hight = 580;
	    c_Head_Set = [  '청구번호','환자ID','성명','종별','청구구분','명일련','EDI코드','단가','일투','일수','계산금액'  ];	    
		columnsSet = [  { data: 'claimNo',  visible: true,  className: 'dt-body-center', width: '100px' },
						{ data: 'patId',    visible: true,  className: 'dt-body-center', width: '100px' },
						{ data: 'patNm',    visible: true,  className: 'dt-body-center', width: '100px' },
						{ data: 'medCovType', visible: true, className: 'dt-body-center', width: '100px' },
						{ data: 'claimGrp', visible: true,  className: 'dt-body-center', width: '100px' },
						{ data: 'billSeq',  visible: true,  className: 'dt-body-center', width: '80px' },
						{ data: 'ediCode',  visible: true,  className: 'dt-body-center', width: '100px' },
						
		   						   				
		   				{ data: 'unitAmt',  visible: true,  className: 'dt-body-right', width: '100px',
	                 		render: function(data, type, row) {
	       						if (type === 'display') {
	       							return getFormat(data,'n1') + '원'
	           					}
	           					return data;
	   						}
						},
						
		   				
		   				{ data: 'dayQtys',  visible: true,  className: 'dt-body-right', width: '100px' },
		   				{ data: 'totDays',  visible: true,  className: 'dt-body-right', width: '100px' },
		   				
		   				{ data: 'calPrics',visible: true,  className: 'dt-body-right',  width: '100px',
		                    render: function(data, type, row) {
		           				if (type === 'display') {
		           					return getFormat(data,'n1') + '원'
		               			}
		               			return data;
		       				},
		   				}
					 ];
		// 초기 data Sort,  없으면 []
		muiltSorts = [];
		// Sort여부 표시를 일부만 할 때 개별 id, ** 전체 적용은 '_all'하면 됩니다. ** 전체 적용 안함은 []        				 
		showSortNo = ['_all'];                   
		// Columns 숨김 columnsSet -> visible로 대체함 hideColums 보다 먼제 처리됨 ( visible를 선언하지 않으면 hideColums컬럼 적용됨 )	
		hideColums = [];             // 없으면 []; 일부 컬럼 숨길때		
		txt_Markln = 10;                       				 // 컬럼의 글자수가 설정값보다 크면, 다음은 ...로 표시함
		// 글자수 제한표시를 일부만 할 때 개별 id, ** 전체 적용은 '_all'하면 됩니다. ** 전체 적용 안함은 []
		markColums = []
	}
    else return alert("올바른 jobFlag 값을 입력하세요.");
	
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
     	/* btn-outline-danger 
        gridColums.push({ data: null, orderable: false, searchable: false, className: 'dt-center',
            render: function(data, type, row) { 
                return  '<button class="btn btn-outline-danger btn-xs del-btn">삭제..<i class="far fa-trash-alt"></i></button>';
            }
        });
     	*/
      	
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
	    
	})(jQuery);
	
}	   

//ajax 함수 정의
function dataLoad(data, callback, settings) {

	//var table = $(settings.nTable).DataTable();
    //table.processing(true); // 처리 중 상태 시작
    
    $.ajax({
    	url: "/main/total_DataList.do",
        type: "POST",
        data: {
        	hospCd:  hospid,
        	workYm: jobyymm,
        	codeFg: jobCode,
        	makeFg: jobFlag,
        	updUser: userid
        },
        dataType: "json",
        // timeout: 10000, // 10초 후 타임아웃
        beforeSend : function () {
        	
		},
        success: function(response) {
        	//table.processing(false); // 처리 중 상태 종료
            if (response && Object.keys(response).length > 0) {
            	console.log(response);
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
	    
	    const current_Year = new Date().getFullYear();
	    
	    
	    // 당해년도 포함 10년 Setting
	    for (let i = 0; i <= 9; i++) {
	        const option = document.createElement('option');
	        option.value = current_Year - i;
	        option.textContent = current_Year - i;
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
		
		setMakeGrid();
    });
	$('#monthSelect').on('change', function() {
		
		setMakeGrid();
    });
	

});
	
</script> 


       
