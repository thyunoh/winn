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
            
                
				<!--  여기에 dashbord  -->
				<div id="content-area"></div>
            
	            
		    </div>  
	    </div>
	</div>  

<script type="text/javascript">

var load_cnt = 0;
var btnClick = 1; // 적정 


//클릭 시 DashBoard 변경
$(document).on('click', '.top-menu-btn', function () {

	firstChk = 'N';
	
	if        ($(this).attr('id') === "top-menu_d_btn") {
    	Content_Area(1);
    } else if ($(this).attr('id') === "top-menu_c_btn") {
    	Content_Area(2);
    } else if ($(this).attr('id') === "top-menu_a") {
    	let s_conact_gb = getCookie("s_conact_gb");
    	if (s_conact_gb === 'A' || s_conact_gb === '1') {
    		Content_Area(2);	
    	} else {
    		Content_Area(1);
    	}
    }
});


function Content_Area(flag) {
	
	if (flag === 1) {
		if ($('#content-area').is(':empty') || load_cnt === 0) {
			$('#content-area').html(`
	   			<div class="ecommerce-widget">
	                <div class="row justify-content-center">
		                <div class="col-xl-12 col-lg-12">
			                <div class="card-body border-top d-flex justify-content-between align-items-center p-2 box-style">
			                    
			                    <!-- 왼쪽: 안내 문구 -->
			                    <label id="notiVal" class="dsah_lab4">
			                        🔝 ` + hospnm + ` 목표 점 이상 【 등급 】
			                    </label>
			
			                    <!-- 오른쪽: 년/월 선택 영역 -->
			                    <div class="d-flex align-items-center" style="margin-right: 120px;">
			                        <h3 class="card-header-title mb-0">년</h3>
			                        <select id="year_IndiS2" class="custom-select ml-2 mr-2 w-auto"></select>
			                        <h3 class="card-header-title mb-0 ml-2">월</h3>
			                        <select id="monthIndiS2" class="custom-select ml-2 w-auto"></select>
			                    </div>
			                </div>
			            </div>
			            <br>
			            <div class="col-xl-1 col-lg-1">
			            </div>
	                    <div class="col-xl-3 col-lg-3">                        
	                        <div class="card">
							    <div class="card-header bg-primary text-center p-0">
							        <h3 class="card-header1 text-white">연간 예상점수</h3>
							    </div>
							    <div class="card-body border-top d-flex justify-content-center align-items-center p-2">
				                    <label id="yearVal" class="dsah_lab7"></label>
				                </div>
							</div>
	                    </div>
	                    <div class="col-xl-4 col-lg-4">                        
		                    <div class="card">
							    <div class="card-header bg-primary text-center p-0">
							        <h3 class="card-header1 text-white">구조영역</h3>
							    </div>
							    <div class="card-body border-top d-flex justify-content-center align-items-center p-2">
				                    <label id="struVal" class="dsah_lab7"></label>
				                </div>
							</div>
		                </div>
		                <div class="col-xl-3 col-lg-3">                        
		                    <div class="card">
							    <div class="card-header bg-primary text-center p-0">
							        <h3 class="card-header1 text-white">진료영역</h3>
							    </div>
							    <div class="card-body border-top d-flex justify-content-center align-items-center p-2">
				                    <label id="mediVal" class="dsah_lab7"></label>
				                </div>
							</div>
		                </div>
		                <div class="col-xl-1 col-lg-1">
			            </div>
		                <!--
		                <div class="col-xl-12 col-lg-12">
			                <div class="card-body border-top d-flex justify-content-start align-items-center p-2">
			                    <label id="notiVal1" class="dsah_lab5"> ◐ 구조영역 전분기 신고내역</label>
			                    <label id="notiVal2" class="dsah_lab5"> ◑ 진료영역 10월분 2025.10.15 업로드 기준</label>
			                </div>
		                </div>
		                -->
		                <div class="col-xl-1 col-lg-1">
			            </div>
		                <div class="col-xl-3 col-lg-3">                        
		                    <div class="card">
							    <div class="card-header bg-primary2 text-center p-0">
							        <h3 class="card-header1 text-white">적정성평가 예상점수</h3>
							    </div>
							    <div class="card-body border-top d-flex justify-content-center align-items-center p-2">
				                    <label id="monthVal" class="dsah_lab7"></label> 
				                </div>
							</div>
		                </div>
		                <div class="col-xl-7 col-lg-7">                        
		                    <div class="card">
							    <div class="card-header bg-primary2 text-center p-0">
							        <h3 class="card-header1 text-white">추가개선 필요지표</h3>
							    </div>
							    <div class="card-body border-top d-flex flex-wrap justify-content-start align-items-center p-2">
								    <div class="indi-group d-flex flex-wrap w-100">
								        <label id="indiVal1" class="dsah_lab6"></label>
								        <label id="indiVal2" class="dsah_lab6"></label>
								        <label id="indiVal3" class="dsah_lab6"></label>
								        <label id="indiVal4" class="dsah_lab6"></label>
								    </div>
								</div>
	
							</div>
		                </div>
		                <div class="col-xl-1 col-lg-1">
			            </div>
			            <div class="col-xl-10 col-lg-10">
			                <div class="card-body border-top d-flex justify-content-start align-items-center p-2">
			                    <label id="notiVal" class="dsah_lab4">🔢 년 월별 적정성평가 점수현황</label>
			                </div>
			                <div class="card-body11">
						        <div id="cchart_category" style="max-height: 350px;">
						            <!--  <div id="morris-bar-chart1" ></div> -->
						            <canvas id="mixedChart11" style="width: 100%; height: 350px; padding: 20px 20px; "></canvas>						            
						        </div>   
						    </div>
						    <div class="card-body border-top d-flex justify-content-center align-items-center p-2">
			                    <label id="mediVal" class="dsah_lab8" style="color: red;">각 지표별 표준화 구간은 2024년도 발표 기준이 적용되었으며, 추후 심평원 표준화 구간 재설정 또는 기준 변경에 따라 점수 변동이 발생할 수 있습니다.</label>
			                </div>
			                
		                </div>
		                
	 		        </div>        			
	            </div>
		            
		    `);
		}
    	load_cnt = 1;
    	btnClick = 1;
    	
    	loadDashbordMedExpenses();
    	loadContentData();
    	
	} else {
		
		if ($('#content-area').is(':empty') || load_cnt === 1) {
    		load_cnt = 0;
    		
    		$('#content-area').html(`
	    		<div class="ecommerce-widget">
    				<div class="col-xl-12 col-lg-12">
	                    <div class="card-header d-flex align-items-center mb-0">
	                    
	                    <h3 class="card-header-title">년</h3>
	                    <select id="year_Select" class="custom-select ml-left w-auto  ml-2 mr-2"></select>
	                    <h3 class="card-header-title ml-2">월</h3>
	                    <select id="monthSelect" class="custom-select ml-left w-auto  ml-2 mr-2"></select>
	                    
	                </div>
	                <div class="row">	                    
	                    <!--
	                	<div class="col-xl-3 col-lg-3">
	                        <div class="card">
							    <div class="card-header bg-info text-center p-0">
							        <h3 class="card-header1 text-white">총진료비</h3>
							    </div>
							    <div class="card-body border-top d-flex justify-content-between align-items-center p-2">
							        <div class="curmonth font-15 ml-3">당월</div>
							        <label id="totamt1" class="dsah_lab1 text-right mr-3"></label>
							    </div>                               
							    <div class="card-body border-top d-flex justify-content-between align-items-center p-2">
							        <div class="premonth font-15 ml-3">전월</div>
							        <label id="totamt2" class="dsah_lab2 text-right mr-3"></label>
							    </div>
							</div>
	                    </div>
	                    -->
	                    <div class="col-xl-3 col-lg-3">
		                    <div class="card">
		                        <div class="card-header bg-info text-center p-0 d-flex justify-content-between align-items-center px-3 position-relative">
		                            <span class="badge bg-info rounded-circle px-2 ml-2"> </span>
		                            <h3 class="card-header1 text-white m-2 mb-0 mr-20">총진료비</h3>
		                            <span class="tooltip-container1" style="cursor: pointer;">
		                                <span class="badge bg-light text-dark rounded-circle px-2 ml-2">?</span>
		                                <div class="custom-tooltip1">병원의 전체 총진료비 (양방+한방)</div>
		                            </span>
		                        </div>
		                        <div class="card-body border-top d-flex justify-content-between align-items-center p-2">
		                            <div class="curmonth font-15 ml-3">당월</div>
		                            <label id="totamt1" class="dsah_lab1 text-right mr-3"></label>
		                        </div>
		                        <div class="card-body border-top d-flex justify-content-between align-items-center p-2">
		                            <div class="premonth font-15 ml-3">전월</div>
		                            <label id="totamt2" class="dsah_lab2 text-right mr-3"></label>
		                        </div>
		                    </div>
		                </div>
		                <!--
	                    <div class="col-xl-3 col-lg-3">   
	                        <div class="card">
	                            <div class="card-header bg-info text-center p-0 ">
	                                <h3 class="card-header1 text-white">양방청구</h3>
	                            </div>
	                            <div class="card-body border-top d-flex justify-content-between align-items-center p-2">
									<div class="curmonth font-15 ml-3">당월</div>
									<label id="yngamt1" class="dsah_lab1 text-right mr-3"></label>
								</div>                               
	                            <div class="card-body border-top d-flex justify-content-between align-items-center p-2">
									<div class="premonth font-15 ml-3">전월</div>
									<label id="yngamt2" class="dsah_lab2 text-right mr-3"></label>
								</div>
	                        </div>
	                    </div>
	                    -->
	                    <div class="col-xl-3 col-lg-3">
		                    <div class="card">
		                        <div class="card-header bg-info text-center p-0 d-flex justify-content-between align-items-center px-3 position-relative">
		                        	<span class="badge bg-info rounded-circle px-2 ml-2"> </span>
		                            <h3 class="card-header1 text-white m-2 mb-0 mr-20">양방청구</h3>
		                            <span class="tooltip-container1" style="cursor: pointer;">
		                                <span class="badge bg-light text-dark rounded-circle px-2 ml-2">?</span>
		                                <div class="custom-tooltip1">양방관련 전체 청구금액</div>
		                            </span>
		                        </div>
		                        <div class="card-body border-top d-flex justify-content-between align-items-center p-2">
		                            <div class="curmonth font-15 ml-3">당월</div>
		                            <label id="yngamt1" class="dsah_lab1 text-right mr-3"></label>
		                        </div>
		                        <div class="card-body border-top d-flex justify-content-between align-items-center p-2">
		                            <div class="premonth font-15 ml-3">전월</div>
		                            <label id="yngamt2" class="dsah_lab2 text-right mr-3"></label>
		                        </div>
		                    </div>
		                </div>
		                <!--
	                    <div class="col-xl-3 col-lg-3">
	                        <div class="card">
	                            <div class="card-header bg-info text-center p-0 ">
	                                <h3 class="card-header1 mb-0 text-white">건당진료비</h3>
	                            </div>
	                            <div class="card-body border-top d-flex justify-content-between align-items-center p-2">
									<div class="curmonth font-15 ml-3">당월</div>
									<label id="oneamt1" class="dsah_lab1 text-right mr-3"></label>
								</div>                               
	                            <div class="card-body border-top d-flex justify-content-between align-items-center p-2">
									<div class="premonth font-15 ml-3">전월</div>
									<label id="oneamt2" class="dsah_lab2 text-right mr-3"></label>
								</div>
	                        </div>
	                    </div>
	                    -->
	                    <div class="col-xl-3 col-lg-3">
		                    <div class="card">
		                        <div class="card-header bg-info text-center p-0 d-flex justify-content-between align-items-center px-3 position-relative">
		                        	<span class="badge bg-info rounded-circle px-2 ml-2"> </span>
		                            <h3 class="card-header1 text-white m-2 mb-0 mr-20">건당진료비</h3>
		                            <span class="tooltip-container1" style="cursor: pointer;">
		                                <span class="badge bg-light text-dark rounded-circle px-2 ml-2">?</span>
		                                <div class="custom-tooltip1">요양급여 총액 / 청구대상자인원수(중복값은 1명로 산정함)</div>
		                            </span>
		                        </div>
		                        <div class="card-body border-top d-flex justify-content-between align-items-center p-2">
		                            <div class="curmonth font-15 ml-3">당월</div>
		                            <label id="oneamt1" class="dsah_lab1 text-right mr-3"></label>
		                        </div>
		                        <div class="card-body border-top d-flex justify-content-between align-items-center p-2">
		                            <div class="premonth font-15 ml-3">전월</div>
		                            <label id="oneamt2" class="dsah_lab2 text-right mr-3"></label>
		                        </div>
		                    </div>
		                </div>
		                <!--
	                    <div class="col-xl-3 col-lg-3">
	                        <div class="card">
	                        	<div class="card-header bg-info text-center p-0 ">
	                                <h3 class="card-header1 mb-0 text-white">특정진료비</h3>
	                            </div>
	                            <div class="card-body border-top d-flex justify-content-between align-items-center p-2">
									<div class="curmonth font-15 ml-3">당월</div>
									<label id="tsuamt1" class="dsah_lab1 text-right mr-3"></label>
								</div>                               
	                            <div class="card-body border-top d-flex justify-content-between align-items-center p-2">
									<div class="premonth font-15 ml-3">전월</div>
									<label id="tsuamt2" class="dsah_lab2 text-right mr-3"></label>
								</div>
	                        </div>
	                    </div>
	                    -->
	                    <div class="col-xl-3 col-lg-3">
		                    <div class="card">
		                        <div class="card-header bg-info text-center p-0 d-flex justify-content-between align-items-center px-3 position-relative">
		                        	<span class="badge bg-info rounded-circle px-2 ml-2"> </span>
		                            <h3 class="card-header1 text-white m-2 mb-0 mr-20">특정진료비</h3>
		                            <span class="tooltip-container1" style="cursor: pointer;">
		                                <span class="badge bg-light text-dark rounded-circle px-2 ml-2">?</span>
		                                <div class="custom-tooltip1">식대, CT, MRI, 전문재활치료, 혈액투석 및 혈액투석액, 복막투석액, 고시된 전문의약품, 전혈 및 혈액성분제제 등</div>
		                            </span>
		                        </div>
		                        <div class="card-body border-top d-flex justify-content-between align-items-center p-2">
		                            <div class="curmonth font-15 ml-3">당월</div>
		                            <label id="tsuamt1" class="dsah_lab1 text-right mr-3"></label>
		                        </div>
		                        <div class="card-body border-top d-flex justify-content-between align-items-center p-2">
		                            <div class="premonth font-15 ml-3">전월</div>
		                            <label id="tsuamt2" class="dsah_lab2 text-right mr-3"></label>
		                        </div>
		                    </div>
		                </div>
		           </div>
	               <div class="row">
	                    <!--
	               		<div class="col-xl-3 col-lg-3">
	                        <div class="card">
	                            <div class="card-header bg-info text-center p-0 ">
	                                <h3 class="card-header1 mb-0 text-white">정액청구</h3>
	                            </div>
	                            <div class="card-body border-top d-flex justify-content-between align-items-center p-2">
									<div class="curmonth font-15 ml-3">당월</div>
									<label id="jngamt1" class="dsah_lab1 text-right mr-3"></label>
								</div>                               
	                            <div class="card-body border-top d-flex justify-content-between align-items-center p-2">
									<div class="premonth font-15 ml-3">전월</div>
									<label id="jngamt2" class="dsah_lab2 text-right mr-3"></label>
								</div>
	                        </div>
	                    </div>
	                    -->
	                    <div class="col-xl-3 col-lg-3">
		                    <div class="card">
		                        <div class="card-header bg-info text-center p-0 d-flex justify-content-between align-items-center px-3 position-relative">
		                        	<span class="badge bg-info rounded-circle px-2 ml-2"> </span>
		                            <h3 class="card-header1 text-white m-2 mb-0 mr-20">정액청구</h3>
		                            <span class="tooltip-container1" style="cursor: pointer;">
		                                <span class="badge bg-light text-dark rounded-circle px-2 ml-2">?</span>
		                                <div class="custom-tooltip1">일당정액수가로 분류된 입원료 청구금액</div>
		                            </span>
		                        </div>
		                        <div class="card-body border-top d-flex justify-content-between align-items-center p-2">
		                            <div class="curmonth font-15 ml-3">당월</div>
		                            <label id="jngamt1" class="dsah_lab1 text-right mr-3"></label>
		                        </div>
		                        <div class="card-body border-top d-flex justify-content-between align-items-center p-2">
		                            <div class="premonth font-15 ml-3">전월</div>
		                            <label id="jngamt2" class="dsah_lab2 text-right mr-3"></label>
		                        </div>
		                    </div>
		                </div>
		                <!--
	                    <div class="col-xl-3 col-lg-3">
	                        <div class="card">
	                            <div class="card-header bg-info text-center p-0 ">
	                                <h3 class="card-header1 mb-0 text-white">행위청구</h3>
	                            </div>
	                            <div class="card-body border-top d-flex justify-content-between align-items-center p-2">
									<div class="curmonth font-15 ml-3">당월</div>
									<label id="hwiamt1" class="dsah_lab1 text-right mr-3"></label>
								</div>                               
	                            <div class="card-body border-top d-flex justify-content-between align-items-center p-2">
									<div class="premonth font-15 ml-3">전월</div>
									<label id="hwiamt2" class="dsah_lab2 text-right mr-3"></label>
								</div>
	                        </div>
	                    </div>
	                    -->
	                    <div class="col-xl-3 col-lg-3">
		                    <div class="card">
		                        <div class="card-header bg-info text-center p-0 d-flex justify-content-between align-items-center px-3 position-relative">
		                        	<span class="badge bg-info rounded-circle px-2 ml-2"> </span>
		                            <h3 class="card-header1 text-white m-2 mb-0 mr-20">행위청구</h3>
		                            <span class="tooltip-container1" style="cursor: pointer;">
		                                <span class="badge bg-light text-dark rounded-circle px-2 ml-2">?</span>
		                                <div class="custom-tooltip1">폐렴/패혈증/체내출혈/중환자실·격리실/외과적수술 행위별 청구에 대한 금액 (*7일이내 입원 제외)</div>
		                            </span>
		                        </div>
		                        <div class="card-body border-top d-flex justify-content-between align-items-center p-2">
		                            <div class="curmonth font-15 ml-3">당월</div>
		                            <label id="hwiamt1" class="dsah_lab1 text-right mr-3"></label>
		                        </div>
		                        <div class="card-body border-top d-flex justify-content-between align-items-center p-2">
		                            <div class="premonth font-15 ml-3">전월</div>
		                            <label id="hwiamt2" class="dsah_lab2 text-right mr-3"></label>
		                        </div>
		                    </div>
		                </div>
		                <!--
	                    <div class="col-xl-3 col-lg-3">
	                        <div class="card">
	                            <div class="card-header bg-info text-center p-0 ">
	                                <h3 class="card-header1 mb-0 text-white">일당진료비</h3>
	                            </div>
	                            <div class="card-body border-top d-flex justify-content-between align-items-center p-2">
									<div class="curmonth font-15 ml-3">당월</div>
									<label id="dayamt1" class="dsah_lab1 text-right mr-3"></label>
								</div>                               
	                            <div class="card-body border-top d-flex justify-content-between align-items-center p-2">
									<div class="premonth font-15 ml-3">전월</div>
									<label id="dayamt2" class="dsah_lab2 text-right mr-3"></label>
								</div>
	                        </div>
	                    </div>
	                    -->
	                    <div class="col-xl-3 col-lg-3">
		                    <div class="card">
		                        <div class="card-header bg-info text-center p-0 d-flex justify-content-between align-items-center px-3 position-relative">
		                        	<span class="badge bg-info rounded-circle px-2 ml-2"> </span>
		                            <h3 class="card-header1 text-white m-2 mb-0 mr-20">일당진료비</h3>
		                            <span class="tooltip-container1" style="cursor: pointer;">
		                                <span class="badge bg-light text-dark rounded-circle px-2 ml-2">?</span>
		                                <div class="custom-tooltip1">요양급여 총액 / 진료일수</div>
		                            </span>
		                        </div>
		                        <div class="card-body border-top d-flex justify-content-between align-items-center p-2">
		                            <div class="curmonth font-15 ml-3">당월</div>
		                            <label id="dayamt1" class="dsah_lab1 text-right mr-3"></label>
		                        </div>
		                        <div class="card-body border-top d-flex justify-content-between align-items-center p-2">
		                            <div class="premonth font-15 ml-3">전월</div>
		                            <label id="dayamt2" class="dsah_lab2 text-right mr-3"></label>
		                        </div>
		                    </div>
		                </div>
		                <!--
	                    <div class="col-xl-3 col-lg-3">
	                        <div class="card">
	                            <div class="card-header bg-info text-center p-0 ">
	                                <h3 class="card-header1 mb-0 text-white">한방청구액</h3>
	                            </div>
	                            <div class="card-body border-top d-flex justify-content-between align-items-center p-2">
									<div class="curmonth font-15 ml-3">당월</div>
									<label id="hanamt1" class="dsah_lab1 text-right mr-3"></label>
								</div>                               
	                            <div class="card-body border-top d-flex justify-content-between align-items-center p-2">
									<div class="premonth font-15 ml-3">전월</div>
									<label id="hanamt2" class="dsah_lab2 text-right mr-3"></label>
								</div>
	                        </div>
	                    </div>
	                    -->
	                    <div class="col-xl-3 col-lg-3">
		                    <div class="card">
		                        <div class="card-header bg-info text-center p-0 d-flex justify-content-between align-items-center px-3 position-relative">
		                        	<span class="badge bg-info rounded-circle px-2 ml-2"> </span>
		                            <h3 class="card-header1 text-white m-2 mb-0 mr-20">한방청구액</h3>
		                            <span class="tooltip-container1" style="cursor: pointer;">
		                                <span class="badge bg-light text-dark rounded-circle px-2 ml-2">?</span>
		                                <div class="custom-tooltip1">한방관련 전체 청구금액</div>
		                            </span>
		                        </div>
		                        <div class="card-body border-top d-flex justify-content-between align-items-center p-2">
		                            <div class="curmonth font-15 ml-3">당월</div>
		                            <label id="hanamt1" class="dsah_lab1 text-right mr-3"></label>
		                        </div>
		                        <div class="card-body border-top d-flex justify-content-between align-items-center p-2">
		                            <div class="premonth font-15 ml-3">전월</div>
		                            <label id="hanamt2" class="dsah_lab2 text-right mr-3"></label>
		                        </div>
		                    </div>
		                </div>
	                </div>                 
	            	<div class="row">
	                    <div class="col-xl-6 col-lg-6 col-md-6 col-sm-6 col-6">
	                        <div class="card">
						    <div class="card-header11 d-flex justify-content-between align-items-center">
						        <h5 class="ml-3">전월대비 진료비 총액</h5>
						        <div class="legend-container mr-3">
						            <div class="legend-item">
						                <span class="legend-box current-month"></span>
						                <span class="curmonth legend-text">당월</span>
						            </div>
						            <div class="legend-item">
						                <span class="legend-box previous-month"></span>
						                <span class="premonth legend-text">전월</span>
						            </div>
						        </div>
						    </div>
						    <div class="card-body">
						        <div id="cchart_category" style="height: 350px;">
						            <div id="morris-bar-chart1"></div>
						        </div>   
						    </div>
						</div>
	                    </div> 
	                    <div class="col-xl-3 col-lg-3 col-md-3 col-sm-3 col-3">
	                        <div class="card">
	                            <div class="card-header11 d-flex justify-content-between align-items-center">
						        <h5 class="ml-3">전월대비 일당 · 건당</h5>
						        <div class="legend-container mr-3">
						            <div class="legend-item">
						                <span class="legend-box current-month"></span>
						                <span class="curmonth legend-text">당월</span>
						            </div>
						            <div class="legend-item">
						                <span class="legend-box previous-month"></span>
						                <span class="premonth legend-text">전월</span>
						            </div>
						        </div>
						    </div>
						    <div class="card-body">
						        <div id="cchart_category" style="height: 350px;">
						            <div id="morris-bar-chart2"></div>
						        </div>   
						    </div>
	                        </div>
	                    </div>
	                    <div class="col-xl-3 col-lg-3 col-md-3 col-sm-3 col-3">
	                        <div class="card">
	                            <div class="card-header11 d-flex justify-content-between align-items-center">
						        <h5 class="ml-3">전월대비 특정 · 한방</h5>
						        <div class="legend-container mr-3">
						            <div class="legend-item">
						                <span class="legend-box current-month"></span>
						                <span class="curmonth legend-text">당월</span>
						            </div>
						            <div class="legend-item">
						                <span class="legend-box previous-month"></span>
						                <span class="premonth legend-text">전월</span>
						            </div>
						        </div>
						    </div>
						    <div class="card-body">
						        <div id="cchart_category" style="height: 350px;">
						            <div id="morris-bar-chart3"></div>
						            </div>   
						        </div>
	                        </div>
	                    </div>
	 		        </div>        			
	            </div>
	            
	    	 `);		
    		btnClick = 2;
    		
    		loadDashbordMedExpenses();
    	
    	}
	}
	
}

function loadContentData() {
	
	let cur_Year = document.getElementById('year_IndiS2').value;
	let curMonth = document.getElementById('monthIndiS2').value;
	
	$.ajax({
    	url: "/main/dashbordINDICATORS.do",
        type: "POST",
        data: {
            hosp_cd: hospid,
            mg_year: cur_Year,
            mgmonth: curMonth
        },
        success: function (response) {
            
        	$('#notiVal').text(`🔝 ` + hospnm + ` ` + response.goalName + ` 목표 ` + response.goal_Val + `점 이상 【 ` + response.hosGrade + `등급 】`);
            $('.card-header1:contains("연간 예상점수")').text(cur_Year + `년 연간 예상점수`);
            $('.card-header1:contains("구조영역")').text(`구조영역【 ` + response.cQuarter + `분기 】`);
            $('.card-header1:contains("진료영역")').text(`진료영역【 ` + curMonth + `월 작성 기준 】`);
            $('.card-header1:contains("적정성평가 예상점수")').text(curMonth + `월 적정성평가 예상점수`);
            $('label.dsah_lab4:contains("점수현황")').text(`🔢 ` + cur_Year + `년 월별 적정성평가 점수현황`);

            // 필요시 점수 영역도 업데이트
            $('#yearVal').text(response.year_Val + '점');
            $('#struVal').text(response.strValue + '점');
            $('#mediVal').first().text(response.medValue + '점');
            
            $('#monthVal').text(response.monthVal + '점');
            
            /*
            if (response.checkNm1) {
                $('#indiVal1').text('▷ ' + response.checkNm1);
            }
            if (response.checkNm2) {
                $('#indiVal2').text('▷ ' + response.checkNm2);
            }
            if (response.checkNm3) {
                $('#indiVal3').text('▷ ' + response.checkNm3);
            }
            if (response.checkNm4) {
                $('#indiVal4').text('▷ ' + response.checkNm4);
            }
            */
            for (let i = 1; i <= 4; i++) {
                $('#indiVal' + i).text('');
            }
            if (response.monthVal > 10) {
            	for (let i = 1; i <= 4; i++) {
	                const checkVal = response['checkNm' + i];
	                if (checkVal) {
	                    $('#indiVal' + i).text('▷ ' + checkVal);
	                }
	            }
            }
            
            
            
            const setValues = [response.month_07, response.month_08, response.month_09,
                               response.month_10, response.month_11, response.month_12];
            
        	const labels = ['7월', '8월', '9월', '10월', '11월', '12월'  ];
        	 
        	// [호환성] 옵셔널 체이닝(?.) 제거 — 구버전/레거시 엣지(EdgeHTML)에서 SyntaxError로 전체 스크립트가 멈추던 문제 방어
        	var _mixedEl11 = document.getElementById('mixedChart11');
        	const ctx1 = _mixedEl11 ? _mixedEl11.getContext('2d') : null;
        	
            if (!ctx1) {
                console.error("Canvas element #mixedChart11 not found!");
                return;
            }
            if (window.mixedChart1) {
                window.mixedChart1.destroy();
            }
            
            mixedChart1 = new Chart(ctx1, {
            	type: 'bar',
                data: {
                	labels: labels,
                    datasets: [
                    	{
                            label: '적정성평가 점수',
                            type: 'bar',
                            data: setValues,
                            backgroundColor: '#014992',	 
                            borderWidth: 1,
                            borderRadius: 8,
                            yAxisID: 'y',
                            minBarLength: 1,
                            order: 1,
                            clip: false,
                         
                            categoryPercentage: 0.6,
                            barPercentage: 0.6      
                        },
                        {		                        	
                            label: '적정성평가 점수',
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
            
            
        },
        error: function () {
        	alert('적정성 데이터를 불러오지 못했습니다.');
            console.error("적정성 데이터를 불러오는 중 오류가 발생했습니다.");
        }
    });
	
	
}

(function($) {
    "use strict";

    function loadDashbordMedExpenses() {
    	
    	/*
        let d = new Date();
        let y = d.getFullYear();
        let m = d.getMonth() - 1; // 실제 전월

        if (m === -1) {
            m = 11;
            y = y - 1;
        }

        let y1 = y;
        let m1 = String(m).padStart(2, '0');
        let y2 = m === 0 ? y - 1 : y;
        let m2 = m === 0 ? 11 : m - 1;
        m2 = String(m2).padStart(2, '0');

        const curym = y1 + '-' + m1;
        const preym = y2 + '-' + m2;

        document.querySelectorAll('.curmonth').forEach(el => el.textContent = curym);
        document.querySelectorAll('.premonth').forEach(el => el.textContent = preym);
        */
        
        const currentYear = new Date().getFullYear();
	    const current_Mon = new Date().getMonth() + 1;
	    
	    if (btnClick === 1) {
	    	if ($("#year_IndiS2").val() === null) {	  
	    		const year_IndiS2 = document.getElementById('year_IndiS2');
	    	    const monthIndiS2 = document.getElementById('monthIndiS2');
	    	    
	    	    // 기존 옵션 제거
	    	    year_IndiS2.innerHTML = '';
	    	    monthIndiS2.innerHTML = '';
	    	    
	    	    // 당해년도 포함 10년 Setting
	    	    for (let i = 0; i <= 9; i++) {
	    	    	
	    	    	const year = currentYear - i;

	    	        const option1 = document.createElement('option');
	    	        option1.value = year;
	    	        option1.textContent = year;
	    	        year_IndiS2.appendChild(option1);

	    	    }
	    	 	// 월 생성 로직
	    	    for (let i = 1; i <= 12; i++) {
	    	        let month = i < 10 ? '0' + i : i;
	    	        
	    	        const option = document.createElement('option');
	    	        option.value = month;
	    	        option.textContent = month;
	    	        
	    	        // 현재 달 기준으로 당월 선택
	    	        if (i === current_Mon) {
	    	            option.selected = true; // 기본 선택값 설정
	    	        }
	    	        monthIndiS2.appendChild(option);
	    	        
	    	    }

	    	 	/*	
	    	    // 만약 전월이 0이라면(1월 기준), 12월을 선택
	    	    if (current_Mon === 1) {
	    	    	monthIndiS2.value = '12';
	    	    }
	    	    */
	    	    
	    	    $('#year_IndiS2').on('change', function() {
	    	    	loadContentData();
	    	    });
	    		$('#monthIndiS2').on('change', function() {
	    			loadContentData();
	    	    });
	        }
	    	
	    	
	    } else {
	    	
	    	if ($("#year_Select").val() === null) {	  
	    		
	    		const year_Select = document.getElementById('year_Select');
	    	    const monthSelect = document.getElementById('monthSelect');
	    	    
	    	    // 기존 옵션 제거
	    	    year_Select.innerHTML = '';
	    	    monthSelect.innerHTML = '';
	    	    
	    	    // 당해년도 포함 10년 Setting
	    	    for (let i = 0; i <= 9; i++) {
	    	    	
	    	    	const year = currentYear - i;

	    	        const option1 = document.createElement('option');
	    	        option1.value = year;
	    	        option1.textContent = year;
	    	        year_Select.appendChild(option1);

	    	    }
	    	 	// 월 생성 로직
	    	    for (let i = 1; i <= 12; i++) {
	    	        let month = i < 10 ? '0' + i : i;
	    	        
	    	        const option = document.createElement('option');
	    	        option.value = month;
	    	        option.textContent = month;
	    	        
	    	        // 현재 달 기준으로 당월 선택
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
	    	    
	    	    $('#year_Select').on('change', function() {
	    	    	
	    			loadDashbordMedExpenses();
	    	    });
	    		$('#monthSelect').on('change', function() {
	    			
	    			loadDashbordMedExpenses();
	    	    });
		    } 
	        $.ajax({
	            url: "/main/dashbordMedExpenses.do",
	            type: "POST",
	            data: {
	                hosp_cd: hospid,
	                mg_year: $("#year_Select").val(),
	                mgmonth: $("#monthSelect").val()
	            },
	            success: function (response) {
	                const amounts = [
	                    { pre_base: response.totamt2, cur_base: response.totamt1, key: 'ttupdown', element1: 'totamt1', element2: 'totamt2' },
	                    { pre_base: response.yngamt2, cur_base: response.yngamt1, key: 'ygupdown', element1: 'yngamt1', element2: 'yngamt2' },
	                    { pre_base: response.jngamt2, cur_base: response.jngamt1, key: 'jgupdown', element1: 'jngamt1', element2: 'jngamt2' },
	                    { pre_base: response.hwiamt2, cur_base: response.hwiamt1, key: 'hiupdown', element1: 'hwiamt1', element2: 'hwiamt2' },
	                    { pre_base: response.dayamt2, cur_base: response.dayamt1, key: 'dyupdown', element1: 'dayamt1', element2: 'dayamt2' },
	                    { pre_base: response.oneamt2, cur_base: response.oneamt1, key: 'oeupdown', element1: 'oneamt1', element2: 'oneamt2' },
	                    { pre_base: response.tsuamt2, cur_base: response.tsuamt1, key: 'tuupdown', element1: 'tsuamt1', element2: 'tsuamt2' },
	                    { pre_base: response.hanamt2, cur_base: response.hanamt1, key: 'hnupdown', element1: 'hanamt1', element2: 'hanamt2' }
	                ];
	
	                $('#morris-bar-chart1').empty();
	                $('#morris-bar-chart2').empty();
	                $('#morris-bar-chart3').empty();
	                
	                amounts.forEach(({ pre_base, cur_base, element1, element2 }) => {
	                    const el1 = document.getElementById(element1);
	                    const el2 = document.getElementById(element2);
	                    el2.style.color = 'black';
	
	                    let diff = cur_base - pre_base;
	                    let sign = '';
	                    let tooltipText = "차액 :  ± 없음";
	                    if (diff > 0) {
	                        sign = '(▲) ';
	                        el1.style.color = 'green';
	                        tooltipText = "차액 : ＋" + getFormat(diff.toString(), 'N1', 'N', '', '') + "원";
	                    } else if (diff < 0) {
	                        sign = '(▼) ';
	                        el1.style.color = 'red';
	                        tooltipText = "차액 : －" + getFormat(Math.abs(diff).toString(), 'N1', 'N', '', '') + "원";
	                    }
	
	                    el1.textContent = sign + getFormat(cur_base.toString(), 'N1', 'N', '', '');
	                    el2.textContent = getFormat(pre_base.toString(), 'N1', 'N', '', '');
	
	                    $(el1).tooltip('dispose');
	                    el1.setAttribute("data-toggle", "tooltip");
	                    el1.setAttribute("title", tooltipText);
	                    $(el1).tooltip({ placement: "bottom", container: "body" });
	                });
	
	                Morris.Bar({
	                    element: 'morris-bar-chart1',
	                    data: [
	                        { y: '총진료비', a: response.totamt1, b: response.totamt2 },
	                        { y: '양방금액', a: response.yngamt1, b: response.yngamt2 },
	                        { y: '정액청구', a: response.jngamt1, b: response.jngamt2 },
	                        { y: '행위청구', a: response.hwiamt1, b: response.hwiamt2 }
	                    ],
	                    xkey: 'y',
	                    ykeys: ['a', 'b'],
	                    labels: ['당월', '전월'],
	                    barColors: ['#0B8ECA', '#00B050'],
	                    hideHover: 'auto',
	                    resize: true,
	                    barSizeRatio: 0.8,
	                    barGap: 5
	                });
	
	                Morris.Bar({
	                    element: 'morris-bar-chart2',
	                    data: [
	                        { y: '일당진료비', a: response.dayamt1, b: response.dayamt2 },
	                        { y: '건당진료비', a: response.oneamt1, b: response.oneamt2 }
	                    ],
	                    xkey: 'y',
	                    ykeys: ['a', 'b'],
	                    labels: ['당월', '전월'],
	                    barColors: ['#0B8ECA', '#00B050'],
	                    hideHover: 'auto',
	                    resize: true,
	                    barSizeRatio: 0.8,
	                    barGap: 5
	                });
	
	                Morris.Bar({
	                    element: 'morris-bar-chart3',
	                    data: [
	                        { y: '특정진료비', a: response.tsuamt1, b: response.tsuamt2 },
	                        { y: '한방청구액', a: response.hanamt1, b: response.hanamt2 }
	                    ],
	                    xkey: 'y',
	                    ykeys: ['a', 'b'],
	                    labels: ['당월', '전월'],
	                    barColors: ['#0B8ECA', '#00B050'],
	                    hideHover: 'auto',
	                    resize: true,
	                    barSizeRatio: 0.8,
	                    barGap: 5
	                });
	            },
	            error: function () {
	                console.error("진료비 데이터를 불러오는 중 오류가 발생했습니다.");
	            }
	        });
        }
    }

    
	
    // 다른 모듈에서 필요 시 호출할 수 있도록 window에 바인딩 (선택 사항)
    window.loadDashbordMedExpenses = loadDashbordMedExpenses;

    // [추가] 일부 PC(엣지 절전탭/백그라운드 렌더 등)에서 Morris 차트가 0-너비로 그려져
    //        빈 화면이 되는 현상 방어 — 탭이 다시 보이거나 창 포커스/복원 시 강제 재계산(redraw).
    //        Morris 는 resize:true 라 'resize' 이벤트를 받으면 올바른 너비로 다시 그린다.
    //        정상 동작 PC 에는 영향 없음(차트를 한 번 더 그릴 뿐).
    if (!window.__wnnDashRedrawBound) {
        window.__wnnDashRedrawBound = true;
        var __wnnFireResize = function () { try { window.dispatchEvent(new Event('resize')); } catch (e) {} };
        document.addEventListener('visibilitychange', function () { if (!document.hidden) __wnnFireResize(); });
        window.addEventListener('focus',  __wnnFireResize);
        window.addEventListener('pageshow', __wnnFireResize);
        // 최초 로드 직후 레이아웃이 늦게 잡히는 환경 대비 — 지연 재계산 1회
        setTimeout(__wnnFireResize, 600);
    }    
    
	/*
    $('#info-circle-card').circleProgress({
        value: 0.70,
        size: 100,
        fill: {
            gradient: ["#a389d5"]
        }
    });

    $('.testimonial-widget-one .owl-carousel').owlCarousel({
        singleItem: true,
        loop: true,
        autoplay: false,
        //        rtl: true,
        autoplayTimeout: 2500,
        autoplayHoverPause: true,
        margin: 10,
        nav: false,
        dots: false,
        responsive: {
            0: {
                items: 1
            },
            600: {
                items: 1
            },
            1000: {
                items: 1
            }
        }
    });

    $('#vmap13').vectorMap({
        map: 'usa_en',
        backgroundColor: 'transparent',
        borderColor: 'rgb(88, 115, 254)',
        borderOpacity: 0.25,
        borderWidth: 1,
        color: 'rgb(88, 115, 254)',
        enableZoom: true,
        hoverColor: 'rgba(88, 115, 254)',
        hoverOpacity: null,
        normalizeFunction: 'linear',
        scaleColors: ['#b6d6ff', '#005ace'],
        selectedColor: 'rgba(88, 115, 254, 0.9)',
        selectedRegions: null,
        showTooltip: true,
        // onRegionClick: function(element, code, region) {
        //     var message = 'You clicked "' +
        //         region +
        //         '" which has the code: ' +
        //         code.toUpperCase();

        //     alert(message);
        // }
    });

    var nk = document.getElementById("sold-product");
    // nk.height = 50
    new Chart(nk, {
        type: 'pie',
        data: {
            defaultFontFamily: 'Poppins',
            datasets: [{
                data: [45, 25, 20, 10],
                borderWidth: 0,
                backgroundColor: [
                    "rgba(89, 59, 219, .9)",
                    "rgba(89, 59, 219, .7)",
                    "rgba(89, 59, 219, .5)",
                    "rgba(89, 59, 219, .07)"
                ],
                hoverBackgroundColor: [
                    "rgba(89, 59, 219, .9)",
                    "rgba(89, 59, 219, .7)",
                    "rgba(89, 59, 219, .5)",
                    "rgba(89, 59, 219, .07)"
                ]

            }],
            labels: [
                "one",
                "two",
                "three",
                "four"
            ]
        },
        options: {
            responsive: true,
            legend: false,
            maintainAspectRatio: false
        }
    });
	*/


})(jQuery);


(function($) {
    "use strict";

    var data = [],
        totalPoints = 300;

    function getRandomData() {

        if (data.length > 0)
            data = data.slice(1);

        // Do a random walk

        while (data.length < totalPoints) {

            var prev = data.length > 0 ? data[data.length - 1] : 50,
                y = prev + Math.random() * 10 - 5;

            if (y < 0) {
                y = 0;
            } else if (y > 100) {
                y = 100;
            }

            data.push(y);
        }

        // Zip the generated y values with the x values

        var res = [];
        for (var i = 0; i < data.length; ++i) {
            res.push([i, data[i]])
        }

        return res;
    }

    // Set up the control widget

    var updateInterval = 30;
    $("#updateInterval").val(updateInterval).change(function() {
        var v = $(this).val();
        if (v && !isNaN(+v)) {
            updateInterval = +v;
            if (updateInterval < 1) {
                updateInterval = 1;
            } else if (updateInterval > 3000) {
                updateInterval = 3000;
            }
            $(this).val("" + updateInterval);
        }
    });

    var plot = $.plot("#cpu-load", [getRandomData()], {
        series: {
            shadowSize: 0 // Drawing is faster without shadows
        },
        yaxis: {
            min: 0,
            max: 100
        },
        xaxis: {
            show: false
        },
        colors: ["#007BFF"],
        grid: {
            color: "transparent",
            hoverable: true,
            borderWidth: 0,
            backgroundColor: 'transparent'
        },
        tooltip: true,
        tooltipOpts: {
            content: "Y: %y",
            defaultTheme: false
        }


    });

    function update() {

        plot.setData([getRandomData()]);

        // Since the axes don't change, we don't need to call plot.setupGrid()

        plot.draw();
        setTimeout(update, updateInterval);
    }

    update();


})(jQuery);


const wt  = new PerfectScrollbar('.widget-todo');
const wtl = new PerfectScrollbar('.widget-timeline');	

</script>     

<script type="text/javascript">	
	

$(document).ready(function() {

	/*	
	const hideElementsById = (ids) => {
        ids.forEach(id => {
            const el = document.getElementById(id);
            if (el) {
                el.style.display = "none";
            }
        });
    };

    function hosp_conact() {
        hideElementsById([
            "samcode",    // 샘버전
            "comcode",    // 공통코드
            "ratecode",   // 청구율
            "hospcont",   // 계약정보
            "wnnauth1",   // 운영정보
            "hospuser1", 
            "hospuser2", 
            "hospuser3", 
            "hospuser4", 
            "hospuser5"
        ]);
    }
	
    
    let s_wnn_yn = getCookie("s_wnn_yn");
    if (s_wnn_yn != 'Y') {
        hosp_conact();
    }
	*/
	
	
	/*
 	// 메뉴 항목 클릭 시 .active 클래스 부여
    $('.nav-item.nav-link').on('click', function () {
        // 현재 사이드바 내 모든 항목에서 active 제거
        $('.nav-item.nav-link').removeClass('active');
        // 현재 클릭한 항목에 active 추가
        $(this).addClass('active');
    });
    */
    if (firstChk === 'Y') {
    	$('#top-menu_a').trigger('click');	
    }
	
});


</script>
	
    

