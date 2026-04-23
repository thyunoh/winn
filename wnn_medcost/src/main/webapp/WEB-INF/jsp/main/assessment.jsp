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
    						<div class="card">				
							    <!-- 추가 s -->
							    <div class="container">
								    <div class="card-body">
								        <div class="row header-row2 gx-0">
								            <div class="col-xl-3 col-lg-3">
								                <div class=score-card>
								                	<h5>평가년월</h5>
											        <div>
											            <select id="year_Select" class="custom-select w-100" style="text-align-last: center;"></select>
											        </div>
											        <div>
											            <select id="monthSelect" class="custom-select w-100" style="text-align-last: center;"></select>
											        </div>
											    </div>
								            </div>
								            <div class="col-xl-3 col-lg-3">
								            	<div class="score-card">
								                    <h5>구조영역</h5>
								                    <label id="structureScore" class="score-label"></label>
								                </div>
								            </div>
								            <div class="col-xl-3 col-lg-3">
								            	<div class="score-card">
								                    <h5>진료영역</h5>
								                    <label id="medicalScore" class="score-label"></label>
								                </div>
								            </div>
								            <div class="col-xl-3 col-lg-3">
								                <div class="score-card">
								                    <h5>종합점수</h5>
								                    <label id="totalScore" class="score-label red"></label>
								                </div>
								            </div>
								        </div>
								        <button class="btn indi-custom-btn text-white btn-block btn-sm d-flex align-items-center justify-content-center mb-2" onClick="fn_CreateData(1)">적정성평가 월 자료생성</button>
										<span id="wait_Create" class="loader" style="display: none;">자료생성중입니다...</span>

																							        
										<!-- 지표 테이블 -->
								        <table id="indicatorTable" class="display nowrap stripe hover cell-border order-column responsive">
								            
								        </table>
			                            - 항정처방률은 타 기관의 상병 구성 및 평균 처방률 자료 확인이 불가하여,시스템 산출 PI값은 실제 평가결과와 차이가 있을 수 있으므로 참고용으로 활용하시기 바랍니다.
			                            <br>
										- 청구명세서 미업로드 시 항정처방률 대상자 확인 및 HbA1c 분모 산정에 차이가 발생하여 최종 결과와 다를 수 있습니다.
										<br>
										<div class="d-flex justify-content-between align-items-center">
											<span>- 본 점수는 청구명세서 자료 기반의 자체 분석 결과로, 건강보험심사평가원의 공식 평가결과와 산출기준 및 결과값이 다를 수 있습니다.</span>
										    <button id="btnEvalAllHosp" class="btn btn-outline-danger btn-sm" onClick="fn_CreateEvalAllHosp()" style="display:none;">전체병원 생성</button>
										</div>
										<!-- 지표 선택 시 분석 문구 표시 영역 -->
										<div id="indiSummaryText" style="display:none; margin-top:8px; border:1px solid #b8daff; border-radius:8px; background:#f8fbff; padding:12px 16px;"></div>
										<div class="d-flex align-items-center">
										    
										    <button id="googleLink" onclick="google_Link()" class="btn btn-sm btn-outline-primary me-2" style="display: none;">🌐 구글</button>
										
										    <input  id="googleHttp" type="text" class="form-control text-left mx-2" placeholder="구글시트 주소를 입력하세요 " style="max-width: 400px;display: none;">
										
										    <button id="googleSave" onclick="google_Save()" class="btn btn-sm btn-outline-success ms-2" style="display: none;">📝 등록</button>
										    
										</div>
										
								    </div>
								</div>
							
							    <!-- 추가 e -->
							</div>
						</div>	
	                    <div class="col-lg-7">
		                    <div class="card" id="card_container" style="display: none;">

							    <div class="card-header11 d-flex justify-content-between align-items-top">

							        <label id="lab_title" class="dsah_lab9"></label>

							        <div id="cath05BtnZone" style="display:none; white-space:nowrap;">
							            <button type="button" id="btnCath05Check" class="cath05-btn"
							                    onclick="fn_ShowCath05Modal()">
							                <i class="fas fa-stethoscope cath05-icon"></i>
							                <span class="cath05-label">유치도뇨관&nbsp;&nbsp;및 오류점검</span>
							                <span class="cath05-badge" id="badgeCath05">0</span>
							            </button>
							        </div>

							        <!-- 다빈도 상병순위별 (jobFlag=07 항정신성의약품 처방률 전용) -->
							        <div id="diagRank07BtnZone" style="display:none; white-space:nowrap;">
							            <button type="button" id="btnDiagRank07" class="cath05-btn"
							                    onclick="fn_ShowDiagRank07Modal()">
							                <i class="fas fa-notes-medical cath05-icon"></i>
							                <span class="cath05-label">다빈도&nbsp;상병순위별조회</span>
							            </button>
							        </div>

							        <!-- 환자평가표 조회 버튼 템플릿 (viewTable 렌더 후 .dt-buttons 영역으로 이동) -->
							        <button type="button" id="btnPatvalView" class="patval-btn"
							                onclick="fn_ShowPatvalModal()"
							                style="display:none;">
							            <i class="fas fa-clipboard-list patval-icon"></i>
							            <span class="patval-label">환자평가표&nbsp;조회</span>
							        </button>

							    </div>
							    <style>
							        .cath05-btn {
							            display: inline-flex;
							            align-items: center;
							            gap: 8px;
							            padding: 6px 14px;
							            border: none;
							            border-radius: 4px;
							            font-size: 12.5px;
							            font-weight: 600;
							            letter-spacing: 0.2px;
							            color: #5a3d00;
							            background: linear-gradient(135deg, #ffe082 0%, #ffc107 100%);
							            box-shadow: 0 2px 6px rgba(255, 193, 7, 0.35), inset 0 1px 0 rgba(255,255,255,0.5);
							            cursor: pointer;
							            transition: transform 0.15s ease, box-shadow 0.15s ease, filter 0.15s ease;
							        }
							        .cath05-btn:hover  { transform: translateY(-1px); filter: brightness(1.05); box-shadow: 0 4px 10px rgba(255, 193, 7, 0.45); }
							        .cath05-btn:active { transform: translateY(0);    filter: brightness(0.97); }
							        .cath05-btn:focus  { outline: none; }
							        .cath05-icon  { font-size: 13px; opacity: 0.9; }
							        .cath05-label { line-height: 1; }
							        .cath05-badge {
							            display: inline-flex;
							            align-items: center;
							            justify-content: center;
							            min-width: 22px;
							            height: 22px;
							            padding: 0 7px;
							            border-radius: 3px;
							            background: #fff;
							            color: #dc3545;
							            font-size: 11.5px;
							            font-weight: 700;
							            box-shadow: inset 0 0 0 1px rgba(220,53,69,0.15);
							        }
							        .cath05-btn.is-zero {
							            color: #5a6268;
							            background: linear-gradient(135deg, #e9ecef 0%, #ced4da 100%);
							            box-shadow: 0 1px 3px rgba(0,0,0,0.08);
							        }
							        .cath05-btn.is-zero .cath05-badge { color: #6c757d; box-shadow: inset 0 0 0 1px rgba(108,117,125,0.2); }

							        @keyframes cath05Pulse {
							            0%   { box-shadow: 0 2px 6px rgba(255, 193, 7, 0.35), 0 0 0 0    rgba(255, 152, 0, 0.55); }
							            70%  { box-shadow: 0 2px 6px rgba(255, 193, 7, 0.35), 0 0 0 10px rgba(255, 152, 0, 0);    }
							            100% { box-shadow: 0 2px 6px rgba(255, 193, 7, 0.35), 0 0 0 0    rgba(255, 152, 0, 0);    }
							        }
							        .cath05-blink { animation: cath05Pulse 1.6s ease-out infinite; }

							        /* 환자평가표 조회 버튼 — 활성화됨 (_show 클래스로 표시) */
							        /* 재오픈 시 아래 display:inline-flex !important 선택자 사용 예정 */
							        #btnPatvalView.patval-btn._show,
							        .dt-buttons #btnPatvalView.patval-btn._show,
							        .dt-buttons button#btnPatvalView._show {
							            display: inline-flex !important;
							            align-items: center !important;
							            gap: 8px !important;
							            height: 32px !important;
							            padding: 0 14px !important;
							            box-sizing: border-box !important;
							            border: none !important;
							            border-radius: 4px !important;
							            font-size: 12.5px !important;
							            font-weight: 700 !important;
							            line-height: 1 !important;
							            letter-spacing: 0.2px !important;
							            color: #ffffff !important;
							            background: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%) !important;
							            box-shadow: 0 2px 6px rgba(37,99,235,0.35), inset 0 1px 0 rgba(255,255,255,0.25) !important;
							            cursor: pointer !important;
							            text-shadow: 0 1px 1px rgba(0,0,0,0.18);
							            margin-left: 6px !important;
							            vertical-align: middle !important;
							            transition: transform 0.15s ease, box-shadow 0.15s ease, filter 0.15s ease;
							        }
							        /* 유치도뇨관 및 오류점검 버튼 — .dt-buttons 영역에서도 높이 통일 */
							        .dt-buttons #cath05BtnZone { display: inline-flex; align-items: center; vertical-align: middle; margin-left: 6px; }
							        .dt-buttons #cath05BtnZone .cath05-btn {
							            height: 32px !important;
							            padding: 0 12px !important;
							            box-sizing: border-box !important;
							            line-height: 1 !important;
							            font-size: 12.5px !important;
							            vertical-align: middle !important;
							        }
							        .dt-buttons #cath05BtnZone .cath05-badge {
							            height: 20px !important;
							            line-height: 20px !important;
							        }
							        #btnPatvalView.patval-btn:hover,
							        .dt-buttons #btnPatvalView.patval-btn:hover { transform: translateY(-1px); filter: brightness(1.08); box-shadow: 0 4px 10px rgba(37,99,235,0.45) !important; color:#fff !important; }
							        #btnPatvalView.patval-btn:active { transform: translateY(0); filter: brightness(0.95); }
							        #btnPatvalView.patval-btn:focus  { outline: none; }
							        #btnPatvalView.patval-btn .patval-label,
							        #btnPatvalView.patval-btn .patval-icon { color: #ffffff !important; }
							        #btnPatvalView.patval-btn.is-disabled { cursor: not-allowed; filter: grayscale(0.5); opacity: 0.75; }
							        .patval-icon { font-size: 13px; opacity: 0.95; }
							    </style>
							    <!-- 라인 1줄 생성 -->
							    <hr style="margin: 0; border-top: 2px solid #ccc;">
							    
							    <div class="card-header11">							        
						        	<div id="inputZone" style="display: none;">                
					                	<div class="form-group row">
					                	
					                	    <label class="col-2 col-sm-2 col-form-label text-right  mb-3">주기</label>											
											<div class="col-sm-2 col-sm-2 ">
											    <input id="goal_Jugi" type="text" class="form-control is-invalid text-center mb-3" placeholder="주기">
											</div>
											
											<label class="col-2 col-sm-2 col-form-label text-right  mb-3">차수</label>											
											<div class="col-sm-2 col-sm-2 ">
											    <input id="goal_Chasu" type="text" class="form-control is-invalid text-center mb-3" placeholder="차수">
											</div>
											<label class="col-4 col-sm-4 col-form-label text-left  mb-3"></label>
					                	    
					                	    <label class="col-2 col-sm-2 col-form-label text-right  mb-3">연간 목표 점수</label>											
											<div class="col-sm-2 col-sm-2 ">
											    <input id="goal_Score" type="text" class="form-control is-invalid text-center mb-3" placeholder="목표 점수">
											</div>
					                		<label class="col-2 col-sm-2 col-form-label text-right  mb-3">병원 등급</label>
											<div class="col-sm-2 col-sm-2 ">
											    <select id="hospcdGrade" class="custom-select w-100  mb-3" style="text-align-last: center;"></select>
											</div>
											<label class="col-4 col-sm-4 col-form-label text-left  mb-3"></label>
											
					                		<label class="col-2 col-sm-2 col-form-label text-right  mb-3">차등제 신고분기</label>
					                        <div class="col-sm-2 col-sm-2 ">
											    <select id="yearQuarter" class="custom-select w-100  mb-3" style="text-align-last: center;"></select>
											</div>
											<div class="col-sm-2 col-sm-2 ">
											    <select id="monsQuarter" class="custom-select w-100  mb-3" style="text-align-last: center;"></select>
											</div>
											<div class="col-sm-2 col-sm-2">
					  	   					    <button id="form_BtnSel" type="button" class="btn btm-xs btn-outline-warning mb-3"
					  	   					    style="padding: 2px 15px; font-size: 12px; line-height: 2.6; font-weight: bold;"  
					  	   					    onClick="fn_Select()">조회하기........· <i class="fas fa-search"></i></button>
					                        </div>
					                        <label class="col-4 col-sm-4 col-form-label text-left  mb-3"></label>
			
											
											
											<label class="col-2 col-sm-2 col-form-label text-right  mb-3">평균 환자 수 </label>
											<div class="col-sm-2 col-sm-2 ">
											    <input id="pat_Count" type="text" class="form-control is-invalid text-center mb-3" placeholder="입력하기">
											</div>
											<label class="col-8 col-sm-8 col-form-label text-left  mb-3"></label>
											
											
					                        <label class="col-2 col-sm-2 col-form-label text-right mb-3">의사 수</label>
					                        
					                        <div class="col-2 col-sm-2">
					                            <input id="doc_Count" type="text" class="form-control is-invalid text-center mb-3" placeholder="입력하기">
					                        </div>
					                        <label class="col-8 col-sm-8 col-form-label text-left  mb-3"></label>

					                        
					                        <label class="col-2 col-sm-2 col-form-label text-right">간호사수</label>
					                        <div class="col-2 col-sm-2">
					                            <input id="nur_Count" type="text" class="form-control is-invalid text-center mb-3" placeholder="입력하기">
					                        </div>
					                        <label class="col-8 col-sm-8 col-form-label text-left  mb-3"></label>
					                        
					                        
					                        <label class="col-2 col-sm-2 col-form-label text-right mb-3">간호인력수</label>
					                        <div class="col-2 col-sm-2">
					                            <input id="nursCount" name="input1" type="text" class="form-control is-invalid text-center mb-3" placeholder="입력하기">
					                        </div>
					                        <label class="col-8 col-sm-8 col-form-label text-left  mb-3"></label>
					                        
					                        <label class="col-2 col-sm-2 col-form-label text-right mb-3">약사재직일수</label>
					                        <div class="col-2 col-sm-2">
					                            <input id="pham_Days" name="input1" type="text" class="form-control is-invalid text-center mb-3" placeholder="입력하기">
					                        </div>
					                        <!-- 
					                        <div class="col-2 col-sm-2">
					                            <input id="total_Day" name="input1" type="text" class="form-control is-invalid text-center mb-3" placeholder="전체 일수의 합">
					                        </div>
					                        -->
					                        <label class="col-2 col-sm-2 col-form-label text-left  mb-3"></label>
					                        <div class="col-sm-2 col-sm-2">
					  	   					    <button id="formBtnSave" class="btn btm-xs btn-outline-primary  mb-3" 
					  	   					    style="padding: 2px 15px; font-size: 12px; line-height: 2.3; font-weight: bold;" 
					  	   					    onClick="fn_Update()">저장하기........· <i class="far fa-save"></i></button>
					                        </div>
					                        <label class="col-4 col-sm-4 col-form-label text-left  mb-3"></label>
					                        
					                    </div>
									</div> 
						        	<table id="viewTable" class="display nowrap stripe hover cell-border order-column responsive">
															       
									</table>
							    </div>
							</div>

		                    <div class="card" id="view_container" style="display: none;">
								<div class="card-header11">
		                    	<!-- PDF 저장 버튼 -->
									<div class="text-end me-4 mt-2">
									    <button onclick="downloadPDF()" class="btn btn-sm btn-danger">📄 PDF 저장</button>
									</div>
									
									<!-- 보고서 영역 -->
									<div class="report-container" id="reportArea">
									
									    <!-- 로고 + 제목 -->
									    <div class="d-flex justify-content-between align-items-start mb-4">
    									    <!-- 왼쪽 로고 -->
										    <div>
										        <img src="/images/winct/wincheck.jpg" alt="로고" class="logo">
										    </div>
										    <!-- 중앙 텍스트 -->
										    <div class="text-center">
										        
										        <div id="reportTitle"  class="report-title"></div>
										        <div id="reportPeriod" class="report-period"></div>
										        
										    </div>
										
										    <!-- 오른쪽 여백 -->
										    <div style="width:120px;"></div>
										</div>
									
										<div class="score-box-container d-flex justify-content-between mb-4">
										    <div class="score-box text-center">
										        <h3>구조영역</h3>
										        <label id="strScore" class="score-label"></label>
										        
										    </div>
										    <div class="score-box text-center">
										        <h3>진료영역</h3>
										        <label id="medScore" class="score-label"></label>
										    </div>
										    <div class="score-box text-center">
										        <h3>종합점수</h3>
										        <label id="totScore" class="score-label red"></label>
										    </div>
										</div>
									
									    <!-- 지표 테이블 -->
									    <table class="data-table" id="viewIndicator">
									        <thead>
									        <tr>
									            <th>지표명칭</th>
									            <th>가중치</th>
									            <th>분모</th>
									            <th>분자</th>
									            <th class="highlight-cell">현황값</th>
									            <th class="highlight-cell">결과</th>
									        </tr>
									        </thead>
									        <tbody></tbody>
									    </table>
									</div>
								</div>
								<!-- PDF 저장 스크립트 -->
								<script>
								function loadEvaluationData() {
							        
							        $.ajax({
							            url: "/main/select_Eval_Indi.do",
							            type: "POST",
							            data: {
							                hosp_cd: hospid,
							                jobyymm: $('#year_Select').val() + $('#monthSelect').val()
							            },
							            dataType: "json",
							            success: function(response) {
							                // 예: 응답 구조에 따라 수정
							                const data = response.data || {};

												
											$('#reportTitle').text(hospnm + ' 적정성평가 보고서');
											$('#reportPeriod').text('( ' + $('#year_Select').val() + '년 ' + $('#monthSelect').val() + '월 )');
											
							                const tbody = $('#viewIndicator tbody');
							                tbody.empty();
							                
							                let totScore = 0;
							                let strScore = 0;
							                let medScore = 0;
							                
							                for (let i = 0; i < data.length; i++) {
							                    const item = data[i];

							                    if (item.cate_cd !== '99') {
							                        totScore += item.weigval;
							                    }

							                    if (item.cate_fg === '10') {
							                        if (item.cate_cd !== '99') {
							                            strScore += item.weigval;
							                        }
							                    } else if (['21', '22'].includes(item.cate_fg)) {
							                        if (item.cate_cd !== '99') {
							                            medScore += item.weigval;
							                        }
							                    }
							                    
							                 	// 출력 값 보정 함수
							                    const displayVal = val => (val === null || val === undefined || val === '') ? '' : val;

							                    // 행 추가
							                    tbody.append(
							                        '<tr class="high-row">' +
							                            '<td>' + displayVal(item.cate_nm)  + '</td>' +
							                            '<td>' + displayVal(item.stdweig)  + '</td>' +
							                            '<td>' + displayVal(item.dtorval)  + '</td>' +
							                            '<td>' + displayVal(item.ntorval)  + '</td>' +
							                            '<td class="highlight-cell">' + displayVal(item.cal_val) + '</td>' +
							                            '<td class="highlight-cell">' + displayVal(item.weigval) + '</td>' +
							                        '</tr>'
							                    );
							                }
							                
							                tbody.after(`
						                	    <tr>
						                	        <td colspan="6" style="text-align:left; font-weight:bold;">
						                	        - 항정처방률 · 지역사회 복귀율 기본 표준화 3점으로 산정됩니다.
						                            <br>
													- 청구명세서 미 업로드시 항정처방률 및 HbA1c 지표의 점수가 달라질 수 있습니다.
						                	        </td>
						                	    </tr>
						                	`);
							                
							                $('#strScore').text(Number(strScore).toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 }) + '점');
							                $('#medScore').text(Number(medScore).toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 }) + '점');
							                $('#totScore').text(Number(totScore).toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 }) + '점');
											
							                $('#reportArea').show();
							            },
							            error: function() {
							                alert("서버 오류가 발생했습니다.");
							            }
							        });
								}

								    async function downloadPDF() {
								        const { jsPDF } = window.jspdf;
								        const doc = new jsPDF('p', 'mm', 'a4');
								
								        const reportElement = document.getElementById('reportArea');
								        const canvas = await html2canvas(reportElement, { scale: 2 });
								        const imgData = canvas.toDataURL('image/png');
								
								        const imgProps = doc.getImageProperties(imgData);
								        const pdfWidth = doc.internal.pageSize.getWidth();
								        const pdfHeight = (imgProps.height * pdfWidth) / imgProps.width;
								
								        doc.addImage(imgData, 'PNG', 0, 0, pdfWidth, pdfHeight);
								        doc.save(hospnm + ' 적정성평가_종합보고서.pdf');
								    }
								</script>		                    
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
var evalIndiData = []; // 지표 데이터 저장용

// 05(유치도뇨관) 상단 버튼용 데이터 저장소
var _prevMissingData = [];
var _errCheckData = [];

// 상단 버튼 카운트/표시 갱신 (환자 단위로 unique 카운트)
function fn_UpdateCath05Buttons() {
    var btnZone = document.getElementById('cath05BtnZone');
    if (!btnZone) return;

    if (jobFlag !== '05') {
        btnZone.style.display = 'none';
        return;
    }
    btnZone.style.display = 'inline-block';

    var patSet = {};
    // ★ [제외1] 당월 평가표 없는 대상자(_prevMissingData) 는 오류에서 제외 — 카운트 안 함
    // for (var i = 0; i < _prevMissingData.length; i++) {
    //     if (_prevMissingData[i].patId) patSet[_prevMissingData[i].patId] = 1;
    // }

    // _errCheckData 루프 (모달과 동일 필터 규칙 적용)
    for (var j = 0; j < _errCheckData.length; j++) {
        var er2 = _errCheckData[j];
        if (!er2 || !er2.patId) continue;

        // ★ [제외3] 평가구분 1·입원평가는 A1/A2만 오류로 카운트
        if (String(er2.evalType || '') === '1') {
            var _et2 = String(er2.errType || '');
            if (_et2 !== 'A1' && _et2 !== 'A2') continue;
        }

        // ★ [제외2] 평가구분 2·계속입원 + 전월 유치도뇨관 제거된 대상자는 오류에서 제외
        //   예외: D3/D7(오더O/평가표X, 평가표없음)은 전월 상태와 무관하게 당월 오더가 있으면 오류로 잡음
        if (String(er2.evalType || '') === '2') {
            var _et2b = String(er2.errType || '');
            if (_et2b !== 'D3' && _et2b !== 'D7') {
                var prevCath2 = (er2.prevIndwellCath === undefined) ? null : String(er2.prevIndwellCath || '');
                if (prevCath2 !== null && prevCath2 !== '1' && prevCath2 !== 'Y') continue;
            }
        }
        patSet[er2.patId] = 1;
    }
    var total = Object.keys(patSet).length;

    var badge = document.getElementById('badgeCath05');
    if (badge) badge.textContent = total;

    var btn = document.getElementById('btnCath05Check');
    if (btn) {
        if (total > 0) {
            btn.classList.add('cath05-blink');
            btn.classList.remove('is-zero');
        } else {
            btn.classList.remove('cath05-blink');
            btn.classList.add('is-zero');
        }
    }
}

// 유치도뇨관 점검 모달용 글로벌 상태 (엑셀 저장 시 재사용)
var _cath05PatMap = {};
var _cath05Order  = [];

// 유치도뇨관 점검 통합 모달 (환자별로 통합된 단일 목록)
function fn_ShowCath05Modal() {
    // 환자별 병합: patId 기준으로 1행, 문제유형을 배지로 누적
    var patMap = {};
    var order = [];

    function addPat(patId, patNm, admitDt, patClass, evalType, indwellCath, docDt, issueLabel, issueColor, errType) {
        if (!patId) return;
        if (!patMap[patId]) {
            patMap[patId] = {
                patId: patId, patNm: patNm || '', admitDt: admitDt || '',
                patClass: patClass || '', evalType: evalType || '', indwellCath: indwellCath || '',
                docDt: docDt || '',
                issues: []
            };
            order.push(patId);
        } else {
            if (!patMap[patId].patNm       && patNm)       patMap[patId].patNm       = patNm;
            if (!patMap[patId].admitDt     && admitDt)     patMap[patId].admitDt     = admitDt;
            if (!patMap[patId].patClass    && patClass)    patMap[patId].patClass    = patClass;
            if (!patMap[patId].evalType    && evalType)    patMap[patId].evalType    = evalType;
            if (!patMap[patId].indwellCath && indwellCath) patMap[patId].indwellCath = indwellCath;
            if (!patMap[patId].docDt       && docDt)       patMap[patId].docDt       = docDt;
        }
        patMap[patId].issues.push({ label: issueLabel, color: issueColor, errType: errType || '' });
    }

    // ★ [제외1] 당월 평가표가 없는 대상자(=_prevMissingData, 전월대상자 당월미존재)는 오류에서 제외
    //    (요청: 2026-04 유치도뇨관 오류점검 규칙 변경)
    // for (var i = 0; i < _prevMissingData.length; i++) {
    //     var m = _prevMissingData[i];
    //     addPat(m.patId, m.patNm, m.admitDt, m.patClass, m.evalType, m.indwellCath, '전월대상자 당월미존재', '#333333', 'PREV');
    // }

    for (var j = 0; j < _errCheckData.length; j++) {
        var er = _errCheckData[j];

        // ★ [제외3] 평가구분 1·입원평가는 A1/A2만 오류로 잡음
        //    (요청: 2026-04 — "당월 입원환자 아닌데 입원평가" / "당월 이미 입원평가 있는데 또 입원평가"만 오류)
        //    H1/D1~D5/E1/F1/G1/G2 등 기존 오류는 1·입원평가 대상자에서는 제외
        if (String(er.evalType || '') === '1') {
            var _et1 = String(er.errType || '');
            if (_et1 !== 'A1' && _et1 !== 'A2') {
                continue;
            }
        }

        // ★ [제외2] 평가구분 2·계속입원중 + 전월 유치도뇨관 제거된 대상자는 오류에서 제외
        //    서버 필드 관례: prevIndwellCath 가 제공되면 '0' 또는 빈값 = 제거됨
        //    prevIndwellCath 미제공 시엔 기존 동작 유지 (서버 SQL 개선 전까지)
        //    예외: D3/D7(오더O/평가표X, 평가표없음) 은 전월 상태와 무관하게 당월 오더가 있으면 오류로 잡음
        if (String(er.evalType || '') === '2') {
            var _et2 = String(er.errType || '');
            if (_et2 !== 'D3' && _et2 !== 'D7') {
                var prevCath = (er.prevIndwellCath === undefined) ? null : String(er.prevIndwellCath || '');
                if (prevCath !== null && prevCath !== '1' && prevCath !== 'Y') {
                    continue;  // 제거됨 → skip
                }
            }
        }

        var lbl = '[' + er.errType + '] ' + (er.errName || '평가표오류');
        addPat(er.patId, er.patNm, er.admitDt, er.patClass, er.evalType, er.indwellCath, er.docDt, lbl, '#dc3545', er.errType);
    }

    // 엑셀 저장용 전역 저장
    _cath05PatMap = patMap;
    _cath05Order  = order;

    var total = order.length;
    var html;

    // 전용 CSS (한 번만 주입)
    if (!document.getElementById('cath05ModalStyle')) {
        var st = document.createElement('style');
        st.id = 'cath05ModalStyle';
        st.innerHTML =
            '.cath05-table { width:100%; border-collapse:separate; border-spacing:0; font-size:13px; border:1px solid #e0e4ea; border-radius:4px; }' +
            '.cath05-table thead th { position:sticky; top:0; z-index:2; background:linear-gradient(135deg,#2a5298,#1e3c72); color:#fff; font-weight:normal; padding:10px 8px; border-right:1px solid rgba(255,255,255,0.15); letter-spacing:0.2px; }' +
            '.cath05-table thead th:last-child { border-right:none; }' +
            '.cath05-table tbody td { padding:8px 8px; border-bottom:1px solid #eef1f5; vertical-align:middle; }' +
            '.cath05-table tbody tr:nth-child(even) { background:#fafbfc; }' +
            '.cath05-table tbody tr:hover { background:#f0f7ff; }' +
            '.cath05-table tbody tr.cath05-selected { background:#e3edfb !important; }' +
            '.cath05-table tbody tr:last-child td { border-bottom:none; }' +
            '.cath05-rowno { color:#8891a3; font-weight:500; }' +
            '.cath05-patid { font-family:Consolas,monospace; color:#333; font-weight:600; }' +
            '.cath05-patnm { color:#2c3e50; font-weight:500; }' +
            '.cath05-date  { color:#5a6978; font-family:Consolas,monospace; font-size:12px; }' +
            '.cath05-pclass { color:#1e3c72; font-weight:700; font-family:Consolas,monospace; font-size:12.5px; }' +
            '.cath05-eval { color:#2c3e50; font-size:12px; }' +
            '.cath05-indwell { font-size:14px; }' +
            // 드래그 이동 지원
            '.swal2-popup.cath05-draggable { cursor: default; }' +
            '.swal2-popup.cath05-draggable .swal2-title { cursor: move; user-select: none; }' +
            // cath05 모달에서는 Cancel 버튼(엑셀저장 슬롯) 강제 숨김 — 인라인 버튼으로 대체됨
            '.swal2-popup.cath05-draggable .swal2-cancel { display: none !important; }' +
            // 1·입원 평가 필터 체크박스
            '.cath05-filter-chk { display:inline-flex; align-items:center; gap:6px; font-size:13px; font-weight:600; color:#1e3c72; cursor:pointer; user-select:none; }' +
            '.cath05-filter-chk input[type="checkbox"] { cursor:pointer; width:15px; height:15px; }' +
            '.cath05-filter-info { color:#5a6978; font-weight:500; font-size:12.5px; }' +
            '.cath05-filter-info b { color:#1e3c72; font-weight:800; }' +
            // 모달 내부 엑셀저장 버튼
            '.cath05-inline-excel-btn {' +
            '  display:inline-flex; align-items:center; gap:6px; padding:7px 16px; border:none;' +
            '  border-radius:4px; font-size:13px; font-weight:600; letter-spacing:0.2px; color:#fff;' +
            '  background:linear-gradient(135deg,#28a745 0%,#20c997 100%);' +
            '  box-shadow:0 2px 6px rgba(40,167,69,0.25), inset 0 1px 0 rgba(255,255,255,0.25);' +
            '  cursor:pointer; transition:filter 0.15s ease, box-shadow 0.15s ease;' +
            '}' +
            '.cath05-inline-excel-btn:hover  { filter:brightness(1.08); box-shadow:0 4px 10px rgba(40,167,69,0.35); }' +
            '.cath05-inline-excel-btn:active { filter:brightness(0.95); }' +
            '.cath05-inline-excel-btn:focus  { outline:none; }' +
            // 오류 텍스트 — 박스 제거, 인라인 color 로 각 타입별 색상 적용
            //   · 전월대상자 : 검정 (#333)
            //   · 오류 전체  : 빨강 (#dc3545)
            '.cath05-badge { display:inline-block; padding:0; font-size:12.5px; font-weight:600; line-height:1.5; background:none !important; box-shadow:none !important; text-shadow:none !important; word-break:keep-all; white-space:normal; }' +
            '.cath05-badge-wrap { display:block; padding:2px 0; }' +
            '.cath05-badge-wrap::before { content:"•"; display:inline-block; width:14px; text-align:center; font-weight:bold; vertical-align:middle; }' +
            // 하단 버튼 공통 — 기존 Swal 기본 구성과 동일한 라운드
            '.swal2-actions .swal2-confirm, .swal2-actions .swal2-cancel {' +
            '  min-width:120px !important; height:40px !important; font-size:14px !important;' +
            '  font-weight:600 !important; border-radius:4px !important; border:none !important;' +
            '  letter-spacing:0.2px !important; transition:filter 0.15s ease, box-shadow 0.15s ease;' +
            '  display:inline-flex !important; align-items:center; justify-content:center;' +
            '  padding:0 18px !important; margin:0 6px !important;' +
            '}' +
            // 확인 버튼 — 보라 그라데이션
            '.swal2-actions .swal2-confirm {' +
            '  background:linear-gradient(135deg,#667eea 0%,#764ba2 100%) !important;' +
            '  box-shadow:0 2px 6px rgba(118,75,162,0.25) !important;' +
            '  color:#fff !important;' +
            '}' +
            '.swal2-actions .swal2-confirm:hover { filter:brightness(1.08); box-shadow:0 4px 10px rgba(118,75,162,0.35) !important; }' +
            '.swal2-actions .swal2-confirm:active { filter:brightness(0.95); }' +
            // 엑셀 버튼 — 녹색 그라데이션
            '.swal2-actions .swal2-cancel {' +
            '  background:linear-gradient(135deg,#28a745 0%,#20c997 100%) !important;' +
            '  box-shadow:0 2px 6px rgba(40,167,69,0.25) !important;' +
            '  color:#fff !important;' +
            '}' +
            '.swal2-actions .swal2-cancel:hover { filter:brightness(1.08); box-shadow:0 4px 10px rgba(40,167,69,0.35) !important; }' +
            '.swal2-actions .swal2-cancel:active { filter:brightness(0.95); }' +
            // 아이콘 여백
            '.swal2-actions .swal2-cancel i { margin-right:6px; }';
        document.head.appendChild(st);
    }

    // 평가구분 코드표 (PDF 기준)
    var _EVAL_TYPE_MAP = {
        '1': '입원 평가',
        '2': '계속 입원 중인 환자 평가',
        '3': '이전 환자평가표를 적용하는 경우'
    };
    function _fmtEvalType(v) {
        if (!v) return '-';
        var t = String(v);
        return _EVAL_TYPE_MAP[t] ? (t + '·' + _EVAL_TYPE_MAP[t]) : t;
    }
    function _fmtIndwell(v) {
        if (v === '1' || v === 'Y') return '<span style="color:#28a745;font-weight:700;">✓</span>';
        if (!v) return '<span style="color:#b0b6bf;">-</span>';
        return $('<div>').text(v).html();
    }

    if (total === 0) {
        html = '<div style="padding:30px 20px; text-align:center; color:#155724; font-size:14px;"><i class="fas fa-check-circle" style="color:#28a745; font-size:24px; display:block; margin-bottom:8px;"></i>점검 대상이 없습니다.</div>';
    } else {
        // 컨트롤 바 : 필터 체크박스 + 엑셀저장
        html = '<div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:8px; gap:12px;">' +
               '  <label class="cath05-filter-chk">' +
               '    <input type="checkbox" id="chkHideEvalAdmit">' +
               '    <span>1·입원 평가 숨기기</span>' +
               '    <span class="cath05-filter-info" id="cath05FilterInfo"></span>' +
               '  </label>' +
               '  <button type="button" id="btnCath05ExcelInline" class="cath05-inline-excel-btn">' +
               '    <i class="far fa-file-excel"></i>&nbsp;엑셀저장' +
               '  </button>' +
               '</div>';
        html += '<div style="text-align:left; max-height:38vh; overflow:auto;">';
        html += '<table class="cath05-table">' +
                '<thead><tr>' +
                '<th style="width:50px;">No</th>' +
                '<th style="width:100px;">생년월일</th>' +
                '<th style="width:90px;">성명</th>' +
                '<th style="width:110px;">입원일</th>' +
                '<th style="width:90px;">환자분류군</th>' +
                '<th style="width:260px;">평가구분</th>' +
                '<th style="width:110px;">작성일</th>' +
                '<th style="width:140px;">유치도뇨관 삽입</th>' +
                '<th>점검항목</th>' +
                '</tr></thead><tbody>';
        for (var k = 0; k < order.length; k++) {
            var p = patMap[order[k]];
            var badges = '';
            for (var b = 0; b < p.issues.length; b++) {
                var iss = p.issues[b];
                badges += '<div class="cath05-badge-wrap" style="color:' + iss.color + ';"><span class="cath05-badge" style="color:' + iss.color + ';">' + $('<div>').text(iss.label).html() + '</span></div>';
            }
            html += '<tr class="cath05-row" data-patid="' + p.patId + '" data-admitdt="' + (p.admitDt || '') + '" data-eval="' + (p.evalType || '') + '" style="cursor:pointer;">' +
                    '<td class="cath05-rowno"   style="text-align:center;"></td>' +  // 순번은 필터링 후 재계산
                    '<td class="cath05-patid"   style="text-align:center;">' + p.patId + '</td>' +
                    '<td class="cath05-patnm"   style="text-align:center;">' + p.patNm + '</td>' +
                    '<td class="cath05-date"    style="text-align:center;">' + p.admitDt + '</td>' +
                    '<td class="cath05-pclass"  style="text-align:center;">' + ($('<div>').text(p.patClass || '-').html()) + '</td>' +
                    '<td class="cath05-eval"    style="text-align:left; padding-left:14px;">' + ($('<div>').text(_fmtEvalType(p.evalType)).html()) + '</td>' +
                    '<td class="cath05-date"    style="text-align:center;">' + (p.docDt || '-') + '</td>' +
                    '<td class="cath05-indwell" style="text-align:center;">' + _fmtIndwell(p.indwellCath) + '</td>' +
                    '<td>' + badges + '</td>' +
                    '</tr>';
        }
        html += '</tbody></table></div>';

        // 하단 상세 패널 (초기 숨김 — 행 클릭 시 표시)
        html += '<div id="cath05DetailZone" style="display:none; margin-top:10px; border-top:2px solid #1e3c72; padding-top:10px;">' +
                '  <div id="cath05DetailHeader" style="font-size:13px; font-weight:600; color:#1e3c72; margin-bottom:6px;"></div>' +
                '  <div style="display:flex; gap:10px;">' +
                '    <div style="flex:1; min-width:0;">' +
                '      <div style="font-size:12.5px; font-weight:700; color:#1e3c72; margin-bottom:4px; text-align:center;">📋 환자평가표</div>' +
                '      <div id="cath05DetailPatval" style="max-height:26vh; overflow:auto; border:1px solid #e0e4ea; border-radius:4px;"></div>' +
                '    </div>' +
                '    <div style="flex:1; min-width:0;">' +
                '      <div style="font-size:12.5px; font-weight:700; color:#1e3c72; margin-bottom:4px; text-align:center;">💊 수가 오더 (M0060)</div>' +
                '      <div id="cath05DetailSpcsuga" style="max-height:26vh; overflow:auto; border:1px solid #e0e4ea; border-radius:4px;"></div>' +
                '    </div>' +
                '  </div>' +
                '</div>';
    }

    Swal.fire({
        title: '<span style="font-size:18px;" title="드래그로 이동"><i class="fas fa-stethoscope" style="color:#f0ad4e; margin-right:8px;"></i>유치도뇨관 및 오류점검 결과 : ' + total + '명</span>',
        html: html,
        width: '1600px',
        showCancelButton: false,                              // 엑셀저장은 모달 내부 버튼으로 이동
        showConfirmButton: true,
        confirmButtonText: '확인',
        confirmButtonColor: '#6c7bff',
        allowOutsideClick: false,                             // 외부 클릭으로 닫히지 않음
        allowEscapeKey: true,
        customClass: { popup: 'cath05-draggable' },
        didOpen: function() {
            _cath05EnableDrag();
            // 엑셀저장 버튼
            var $excelBtn = $('#btnCath05ExcelInline');
            if ($excelBtn.length) {
                $excelBtn.off('click.pvExcel').on('click.pvExcel', function(e) {
                    e.preventDefault();
                    fn_ExportCath05Excel();
                });
            }
            // 1·입원 평가 숨기기 체크박스
            var $chk = $('#chkHideEvalAdmit');
            if ($chk.length) {
                $chk.off('change.pvFilter').on('change.pvFilter', _cath05ApplyFilter);
                _cath05ApplyFilter();  // 초기 적용 (기본: 체크됨 → 입원평가 숨김)
            }
            // 성명 헤더 클릭 정렬 (토글: 가나다순 ↔ 역순)
            _cath05BindNameSort();
            // 행 클릭 → 하단 상세 패널
            _cath05BindRowClick();
        }
    });
}

// 상단 그리드 행 클릭 시 하단 상세 패널 표시 (AJAX)
function _cath05BindRowClick() {
    $('.cath05-table tbody').off('click.pvRow').on('click.pvRow', 'tr.cath05-row', function() {
        $('.cath05-table tbody tr.cath05-row').removeClass('cath05-selected');
        $(this).addClass('cath05-selected');
        var patId   = $(this).data('patid')   || '';
        var admitDt = $(this).data('admitdt') || '';
        if (!patId || !admitDt) return;
        _cath05LoadDetail(String(patId), String(admitDt).replace(/-/g, ''));
    });
}

function _cath05LoadDetail(patId, admitDt) {
    var $zone = $('#cath05DetailZone');
    var $hdr  = $('#cath05DetailHeader');
    var $pv   = $('#cath05DetailPatval');
    var $sp   = $('#cath05DetailSpcsuga');
    // 깜박거림 방지: 기존 내용 유지하면서 로딩중 상태만 시각적 표시(opacity)
    $zone.show();
    $pv.css('opacity', 0.5);
    $sp.css('opacity', 0.5);

    $.ajax({
        url: '/main/select_CathDetailByPat.do',
        type: 'POST',
        data: {
            hospCd:  hospid,
            jobYymm: jobYyMm,
            patId:   patId,
            admitDt: admitDt
        },
        dataType: 'json',
        success: function(res) {
            $hdr.html('환자ID <b>' + patId + '</b> · 입원일 <b>' + admitDt + '</b>');
            $pv.html(_cath05RenderPatval(res.patval  || []));
            $sp.html(_cath05RenderSpcsuga(res.spcsuga || []));
        },
        error: function() {
            $pv.html('<div style="padding:20px; text-align:center; color:#dc3545;">조회 실패</div>');
            $sp.html('<div style="padding:20px; text-align:center; color:#dc3545;">조회 실패</div>');
        },
        complete: function() {
            $pv.css('opacity', 1);
            $sp.css('opacity', 1);
        }
    });
}

function _cath05RenderPatval(rows) {
    if (!rows || rows.length === 0) {
        return '<div style="padding:20px; text-align:center; color:#888;">데이터 없음</div>';
    }
    // 이전월 / 해당월 그룹 분리
    var prev = [], curr = [];
    for (var i = 0; i < rows.length; i++) {
        if (rows[i].monthType === 'curr') curr.push(rows[i]);
        else prev.push(rows[i]);
    }

    function _renderPatvalGroup(group) {
        var h = '';
        var prevMedStart = null;
        for (var i = 0; i < group.length; i++) {
            var r = group[i];
            var mt = r.monthType === 'curr' ? '해당월' : '이전월';
            var mtColor = r.monthType === 'curr' ? '#1e3c72' : '#6c757d';
            var curMedStart = r.medStart || '';
            var groupRows = '';
            for (var n = 1; n <= 10; n++) {
                var ci = r['catIn'  + n] || '00000000';
                var co = r['catOut' + n] || '00000000';
                if (ci === '00000000' && co === '00000000') continue;
                var ciTxt = (ci === '00000000') ? '-' : ci;
                var coTxt = (co === '00000000') ? '-' : co;
                groupRows +=
                     '<tr>' +
                     '<td style="padding:4px 6px; text-align:center; color:' + mtColor + '; font-weight:600;">' + mt + '</td>' +
                     '<td style="padding:4px 6px; text-align:center; font-family:Consolas,monospace;">' + curMedStart + '</td>' +
                     '<td style="padding:4px 6px; text-align:center; font-family:Consolas,monospace;">' + (r.docDt || '') + '</td>' +
                     '<td style="padding:4px 6px; text-align:center;">' + n + '</td>' +
                     '<td style="padding:4px 6px; text-align:center; font-family:Consolas,monospace;">' + ciTxt + '</td>' +
                     '<td style="padding:4px 6px; text-align:center; font-family:Consolas,monospace;">' + coTxt + '</td>' +
                     '</tr>';
            }
            if (groupRows) {
                // 진료일 바뀌면 점선 구분
                if (prevMedStart !== null && curMedStart !== prevMedStart) {
                    h += '<tr><td colspan="6" style="padding:0; border-top:1px dashed #b0b6bf; height:0;"></td></tr>';
                }
                h += groupRows;
                prevMedStart = curMedStart;
            }
        }
        return h;
    }

    var _thSt = 'background:linear-gradient(135deg,#2a5298,#1e3c72); color:#fff; font-weight:normal; padding:8px 6px; letter-spacing:0.2px; border-right:1px solid rgba(255,255,255,0.15);';
    var html = '<table style="width:100%; border-collapse:separate; border-spacing:0; font-size:12px;">' +
               '<thead><tr>' +
               '<th style="' + _thSt + '">구분</th>' +
               '<th style="' + _thSt + '">진료일</th>' +
               '<th style="' + _thSt + '">작성일</th>' +
               '<th style="' + _thSt + '">회차</th>' +
               '<th style="' + _thSt + '">삽입일</th>' +
               '<th style="' + _thSt + ' border-right:none;">제거일</th>' +
               '</tr></thead><tbody>';
    var prevHtml = _renderPatvalGroup(prev);
    var currHtml = _renderPatvalGroup(curr);
    html += prevHtml;
    // 이전월 ↔ 해당월 사이 구분선 (양쪽 다 행 있을 때만)
    if (prevHtml && currHtml) {
        html += '<tr><td colspan="6" style="padding:0; border-top:2px dashed #1e3c72; height:0;"></td></tr>';
    }
    html += currHtml;
    html += '</tbody></table>';
    return html;
}

function _cath05RenderSpcsuga(rows) {
    if (!rows || rows.length === 0) {
        return '<div style="padding:20px; text-align:center; color:#888;">데이터 없음</div>';
    }
    // 이전월 / 해당월 그룹 분리
    var prev = [], curr = [];
    for (var i = 0; i < rows.length; i++) {
        if (rows[i].monthType === 'curr') curr.push(rows[i]);
        else prev.push(rows[i]);
    }

    function _renderRow(r) {
        var mt = r.monthType === 'curr' ? '해당월' : '이전월';
        var mtColor = r.monthType === 'curr' ? '#1e3c72' : '#6c757d';
        return '<tr>' +
               '<td style="padding:4px 6px; text-align:center; color:' + mtColor + '; font-weight:600;">' + mt + '</td>' +
               '<td style="padding:4px 6px; text-align:center; font-family:Consolas,monospace;">' + (r.jobYymm || '') + '</td>' +
               '<td style="padding:4px 6px; text-align:center;">' + ($('<div>').text(r.patName || '').html()) + '</td>' +
               '<td style="padding:4px 6px; text-align:center; font-family:Consolas,monospace;">' + (r.juminno || '') + '</td>' +
               '<td style="padding:4px 6px; text-align:center; font-family:Consolas,monospace;">' + (r.ipwonDt || '') + '</td>' +
               '<td style="padding:4px 6px; text-align:center; font-family:Consolas,monospace;">' + (r.medStart || '') + '</td>' +
               '</tr>';
    }
    function _renderGroup(group) {
        var h = '';
        var prevJY = null;
        for (var i = 0; i < group.length; i++) {
            var r = group[i];
            var curJY = r.jobYymm || '';
            if (prevJY !== null && curJY !== prevJY) {
                h += '<tr><td colspan="6" style="padding:0; border-top:1px dashed #b0b6bf; height:0;"></td></tr>';
            }
            h += _renderRow(r);
            prevJY = curJY;
        }
        return h;
    }

    var _thSt = 'background:linear-gradient(135deg,#2a5298,#1e3c72); color:#fff; font-weight:normal; padding:8px 6px; letter-spacing:0.2px; border-right:1px solid rgba(255,255,255,0.15);';
    var html = '<table style="width:100%; border-collapse:separate; border-spacing:0; font-size:12px;">' +
               '<thead><tr>' +
               '<th style="' + _thSt + '">구분</th>' +
               '<th style="' + _thSt + '">적용년월</th>' +
               '<th style="' + _thSt + '">환자명</th>' +
               '<th style="' + _thSt + '">주민(6)</th>' +
               '<th style="' + _thSt + '">입원일</th>' +
               '<th style="' + _thSt + ' border-right:none;">오더일</th>' +
               '</tr></thead><tbody>';
    var prevHtml = _renderGroup(prev);
    var currHtml = _renderGroup(curr);
    html += prevHtml;
    // 이전월 ↔ 해당월 사이 구분선 (양쪽 다 있을 때만)
    if (prevHtml && currHtml) {
        html += '<tr><td colspan="6" style="padding:0; border-top:2px dashed #1e3c72; height:0;"></td></tr>';
    }
    html += currHtml;
    html += '</tbody></table>';
    return html;
}

// 성명 헤더 클릭 → 가나다순/역순 토글 정렬
var _cath05NameAsc = true;
function _cath05BindNameSort() {
    // 성명은 thead 의 3번째 th (No / 생년월일 / 성명 / ...)
    var $nameTh = $('.cath05-table thead th').eq(2);
    if (!$nameTh.length) return;

    // 초기 UI: 커서 포인터 + 화살표 표시
    $nameTh.css({ 'cursor': 'pointer', 'user-select': 'none' })
           .attr('title', '클릭 시 성명 기준 정렬');
    if ($nameTh.text().indexOf('▲') < 0 && $nameTh.text().indexOf('▼') < 0) {
        $nameTh.html('성명 <span class="cath05-sort-ind" style="font-size:11px;color:#6c7bff;">▲</span>');
    }

    $nameTh.off('click.nameSort').on('click.nameSort', function() {
        var $tbody = $('.cath05-table tbody');
        var rows = $tbody.find('tr').toArray();
        var asc = _cath05NameAsc;
        rows.sort(function(a, b) {
            var ta = $(a).find('.cath05-patnm').text().trim();
            var tb = $(b).find('.cath05-patnm').text().trim();
            if (ta === tb) return 0;
            return asc ? ta.localeCompare(tb, 'ko') : tb.localeCompare(ta, 'ko');
        });
        _cath05NameAsc = !asc;
        $tbody.empty().append(rows);
        // 정렬 방향 표시 업데이트
        $nameTh.find('.cath05-sort-ind').text(_cath05NameAsc ? '▲' : '▼');
        // 1·입원 평가 필터 및 순번 재계산
        _cath05ApplyFilter();
    });
}

// 1·입원 평가 필터 적용 + 순번 재계산 + 카운트 갱신
function _cath05ApplyFilter() {
    var hideAdmit = $('#chkHideEvalAdmit').prop('checked');
    var totalCnt = 0, hiddenCnt = 0, visibleNo = 0;
    $('.cath05-table tbody tr').each(function() {
        totalCnt++;
        var ev = String($(this).attr('data-eval') || '');
        var shouldHide = hideAdmit && ev === '1';
        if (shouldHide) {
            $(this).hide();
            hiddenCnt++;
        } else {
            $(this).show();
            visibleNo++;
            $(this).find('.cath05-rowno').text(visibleNo);
        }
    });
    var visibleCnt = totalCnt - hiddenCnt;
    // 제목 및 안내 영역 갱신
    var $info = $('#cath05FilterInfo');
    if ($info.length) {
        if (hideAdmit && hiddenCnt > 0) {
            $info.html('&nbsp;·&nbsp;표시 <b>' + visibleCnt + '</b>명&nbsp;(숨김 <b>' + hiddenCnt + '</b>명)');
        } else {
            $info.html('&nbsp;·&nbsp;전체 <b>' + totalCnt + '</b>명');
        }
    }
}

// SweetAlert2 팝업을 제목 영역 드래그로 이동
function _cath05EnableDrag() {
    var popup = document.querySelector('.swal2-popup.cath05-draggable');
    if (!popup) return;
    var handle = popup.querySelector('.swal2-title');
    if (!handle) return;

    var startX = 0, startY = 0, originX = 0, originY = 0, dragging = false;

    function onMouseMove(e) {
        if (!dragging) return;
        var dx = e.clientX - startX;
        var dy = e.clientY - startY;
        popup.style.position = 'fixed';
        popup.style.left   = (originX + dx) + 'px';
        popup.style.top    = (originY + dy) + 'px';
        popup.style.right  = 'auto';
        popup.style.bottom = 'auto';
        popup.style.margin = '0';
    }
    function onMouseUp() {
        dragging = false;
        document.removeEventListener('mousemove', onMouseMove);
        document.removeEventListener('mouseup',   onMouseUp);
    }
    handle.addEventListener('mousedown', function(e) {
        // 초기 1회 고정 위치 설정
        var rect = popup.getBoundingClientRect();
        popup.style.position = 'fixed';
        popup.style.left = rect.left + 'px';
        popup.style.top  = rect.top  + 'px';
        popup.style.right = 'auto';
        popup.style.bottom = 'auto';
        popup.style.margin = '0';

        startX  = e.clientX;
        startY  = e.clientY;
        originX = rect.left;
        originY = rect.top;
        dragging = true;
        document.addEventListener('mousemove', onMouseMove);
        document.addEventListener('mouseup',   onMouseUp);
        e.preventDefault();
    });
}

// xlsx-js-style 라이브러리 동적 로드 (스타일 쓰기 지원 — SheetJS Community는 스타일 쓰기 불가)
// - 이미 로드돼 있으면 재사용, 없으면 CDN에서 로드 후 XLSX 전역을 style-capable 버전으로 교체
function _loadXlsxStyleLib(callback) {
    if (window._xlsxStyleLoaded) { callback(); return; }
    var s = document.createElement('script');
    s.src = 'https://cdn.jsdelivr.net/npm/xlsx-js-style@1.2.0/dist/xlsx.bundle.js';
    s.onload = function() { window._xlsxStyleLoaded = true; callback(); };
    s.onerror = function() {
        console.warn('[cath05] xlsx-js-style 로드 실패 — 기본 XLSX 사용 (줄바꿈 스타일 반영 안됨)');
        callback();
    };
    document.head.appendChild(s);
}

// 유치도뇨관 오류점검 결과 엑셀 저장 (xlsx-js-style 지원 시 wrapText 자동 적용)
function fn_ExportCath05Excel() {
    if (!_cath05Order || _cath05Order.length === 0) {
        Swal.fire({ icon: 'info', title: '알림', text: '저장할 데이터가 없습니다.', timer: 1500, showConfirmButton: false });
        return;
    }
    if (typeof XLSX === 'undefined') {
        Swal.fire({ icon: 'error', title: '오류', text: 'XLSX 라이브러리가 로드되지 않았습니다.' });
        return;
    }
    // xlsx-js-style 로드 후 실제 쓰기
    _loadXlsxStyleLib(function() { _doCath05ExcelWrite(); });
}

function _doCath05ExcelWrite() {

    // 평가구분 코드표 (엑셀에서 재사용)
    var _XLS_EVAL = { '1':'입원 평가', '2':'계속 입원 중인 환자 평가', '3':'이전 환자평가표를 적용하는 경우' };
    function _xlsEvalText(v) {
        if (!v) return '';
        var t = String(v);
        return _XLS_EVAL[t] ? (t + '·' + _XLS_EVAL[t]) : t;
    }
    function _xlsIndwell(v) { return (v === '1' || v === 'Y') ? 'O' : ''; }

    // 화면 필터 상태(1·입원평가 숨기기) 반영 — 체크됨이면 EVAL_TYPE='1'은 엑셀에서도 제외
    var hideAdmit = $('#chkHideEvalAdmit').prop('checked');
    function _isVisible(p) { return !(hideAdmit && String(p.evalType || '') === '1'); }

    // (1) 환자별 통합 시트 — 환자분류군 / 평가구분 / 유치도뇨관 삽입 추가
    var summaryRows = [];
    var maxIssueCnt = 1;
    for (var i = 0; i < _cath05Order.length; i++) {
        var p = _cath05PatMap[_cath05Order[i]];
        if (!_isVisible(p)) continue;
        var issueText = p.issues.map(function(x) { return x.label; }).join('\n');
        var errTypes  = p.issues.map(function(x) { return x.errType; }).filter(function(v){return v;}).join(',');
        if (p.issues.length > maxIssueCnt) maxIssueCnt = p.issues.length;
        summaryRows.push({
            '환자ID':        p.patId,
            '성명':          p.patNm,
            '입원일':        p.admitDt,
            '환자분류군':    p.patClass   || '',
            '평가구분':      _xlsEvalText(p.evalType),
            '유치도뇨관 삽입': _xlsIndwell(p.indwellCath),
            '오류개수':      p.issues.length,
            '오류코드':      errTypes,
            '점검항목':      issueText
        });
    }

    if (summaryRows.length === 0) {
        Swal.fire({ icon: 'info', title: '알림', text: '저장할 데이터가 없습니다.', timer: 1500, showConfirmButton: false });
        return;
    }

    // (2) 상세 시트 (1행 = 1오류)
    var detailRows = [];
    for (var k = 0; k < _cath05Order.length; k++) {
        var pp = _cath05PatMap[_cath05Order[k]];
        if (!_isVisible(pp)) continue;
        for (var b = 0; b < pp.issues.length; b++) {
            var ii = pp.issues[b];
            detailRows.push({
                '환자ID':        pp.patId,
                '성명':          pp.patNm,
                '입원일':        pp.admitDt,
                '환자분류군':    pp.patClass   || '',
                '평가구분':      _xlsEvalText(pp.evalType),
                '유치도뇨관 삽입': _xlsIndwell(pp.indwellCath),
                '오류코드':      ii.errType || '',
                '점검항목':      ii.label
            });
        }
    }

    var wb = XLSX.utils.book_new();
    var ws1 = XLSX.utils.json_to_sheet(summaryRows);
    var ws2 = XLSX.utils.json_to_sheet(detailRows);

    // 컬럼 너비 (환자ID / 성명 / 입원일 / 환자분류군 / 평가구분 / 유치도뇨관 삽입 / 오류개수 / 오류코드 / 점검항목)
    ws1['!cols'] = [ {wch:12}, {wch:10}, {wch:12}, {wch:12}, {wch:36}, {wch:16}, {wch:8}, {wch:18}, {wch:90} ];
    ws2['!cols'] = [ {wch:12}, {wch:10}, {wch:12}, {wch:12}, {wch:36}, {wch:16}, {wch:10}, {wch:90} ];

    // ── 환자별요약 시트: 점검항목 셀에 줄바꿈 + Wrap Text 스타일 적용 ──
    var range = XLSX.utils.decode_range(ws1['!ref']);
    var colIdx_chk = 8;  // '점검항목' 9번째 컬럼 (0-based) — 컬럼 추가로 위치 변경
    for (var R = range.s.r; R <= range.e.r; R++) {
        var addr = XLSX.utils.encode_cell({ r: R, c: colIdx_chk });
        if (ws1[addr]) {
            ws1[addr].s = {
                alignment: { wrapText: true, vertical: 'top', horizontal: 'left' }
            };
        }
    }
    // 헤더 스타일
    var headerRange = range;
    for (var c = headerRange.s.c; c <= headerRange.e.c; c++) {
        var hAddr = XLSX.utils.encode_cell({ r: 0, c: c });
        if (ws1[hAddr]) {
            ws1[hAddr].s = {
                font: { bold: true, color: { rgb: 'FFFFFFFF' } },
                fill: { patternType: 'solid', fgColor: { rgb: 'FF1E3C72' } },
                alignment: { horizontal: 'center', vertical: 'center' }
            };
        }
    }

    // 행 높이 — 최다 오류 환자에 맞춰 여유있게 (줄당 약 15pt)
    var rowHeights = [ { hpt: 22 } ];  // 헤더
    for (var r = 0; r < summaryRows.length; r++) {
        var lines = summaryRows[r]['점검항목'].split('\n').length;
        rowHeights.push({ hpt: Math.max(18, lines * 16) });
    }
    ws1['!rows'] = rowHeights;

    XLSX.utils.book_append_sheet(wb, ws1, '환자별요약');
    XLSX.utils.book_append_sheet(wb, ws2, '오류상세');

    // 파일명
    var now = new Date();
    var pad = function(n) { return String(n).padStart(2, '0'); };
    var tsLabel = now.getFullYear() + pad(now.getMonth()+1) + pad(now.getDate()) +
                  '_' + pad(now.getHours()) + pad(now.getMinutes()) + pad(now.getSeconds());
    var fname = '유치도뇨관오류_' + (jobYyMm || '') + '_' + tsLabel + '.xlsx';

    // cellStyles 옵션 활성화 — xlsx-js-style 사용 시 스타일 반영
    XLSX.writeFile(wb, fname, { cellStyles: true });
}

// ================================================================
// 다빈도 상병순위별 (jobFlag=07 항정신성의약품 처방률 전용)
// - 항정신성 처방 대상자(psyOrderYn='●')의 주진단을 집계
// - 헤더: 순번 / 진단코드 / 진단명 / 진단건수
// - 엑셀저장: 진단코드 / 진단명 / 진단건수
// ================================================================
var _diagRank07Data = [];

function fn_ShowDiagRank07Modal() {
    /* 전용 CSS (한 번만 주입) */
    if (!document.getElementById('diagRank07ModalStyle')) {
        var st = document.createElement('style');
        st.id = 'diagRank07ModalStyle';
        st.innerHTML =
            /* 모달 폭 제한 + 내부 스크롤 */
            '.swal2-popup.diag07-popup { max-width:720px !important; width:720px !important; }' +
            '.diag07-scroll-wrap { max-height:60vh; overflow-y:auto; overflow-x:auto; border:1px solid #e0e4ea; border-radius:4px; }' +
            '.diag07-table { width:100%; border-collapse:separate; border-spacing:0; font-size:13px; }' +
            '.diag07-table thead th { position:sticky; top:0; z-index:1; background:linear-gradient(135deg,#2a5298,#1e3c72); color:#fff; font-weight:normal; padding:10px 8px; border-right:1px solid rgba(255,255,255,0.15); letter-spacing:0.2px; }' +
            '.diag07-table thead th:last-child { border-right:none; }' +
            '.diag07-table tbody td { padding:7px 8px; border-bottom:1px solid #eef1f5; vertical-align:middle; }' +
            '.diag07-table tbody tr:nth-child(even) { background:#fafbfc; }' +
            '.diag07-table tbody tr:hover { background:#f0f7ff; }' +
            '.diag07-rowno { color:#8891a3; font-weight:500; text-align:center; }' +
            '.diag07-code  { font-family:Consolas,monospace; color:#1e3c72; font-weight:600; text-align:center; }' +
            '.diag07-name  { color:#2c3e50; text-align:left; }' +
            '.diag07-cnt   { color:#c0392b; font-weight:700; text-align:right; font-family:Consolas,monospace; }' +
            /* 정렬 가능 헤더 — 인디케이터 고정폭 + 공백 Reserve (문자 변경 시 너비 변동 방지) */
            '.diag07-table thead th.sortable { cursor:pointer; user-select:none; position:sticky; top:0; white-space:nowrap; }' +
            '.diag07-table thead th.sortable:hover { background:linear-gradient(135deg,#3565b3,#264a8e); }' +
            '.diag07-table thead th .sort-ind {' +
            '  display:inline-block; width:12px; margin-left:6px; font-size:11px;' +
            '  line-height:1; text-align:center; vertical-align:middle; color:#fff;' +
            '  font-family:Arial,sans-serif;' +   /* 플랫폼 독립 기호 렌더 */
            '}' +
            '.diag07-table thead th .sort-ind-off { opacity:0.50; }' +
            '.diag07-table thead th .sort-ind-on  { opacity:1; }' +
            '.swal2-popup.diag07-popup .swal2-title {' +
            '  cursor:move; user-select:none;' +
            '  font-size:1.35em !important;' +   /* 한 단계 작게 (기본 ≈1.875em → 약 1.35em) */
            '  line-height:1.35 !important;' +
            '}' +
            '.swal2-popup.diag07-popup .swal2-cancel { display:none !important; }' +
            /* 인라인 엑셀저장 버튼 */
            '.diag07-inline-excel-btn {' +
            '  display:inline-flex; align-items:center; gap:6px; padding:7px 16px; border:none;' +
            '  border-radius:4px; font-size:13px; font-weight:600; letter-spacing:0.2px; color:#fff;' +
            '  background:linear-gradient(135deg,#28a745 0%,#20c997 100%);' +
            '  box-shadow:0 2px 6px rgba(40,167,69,0.25), inset 0 1px 0 rgba(255,255,255,0.25);' +
            '  cursor:pointer; transition:all .15s ease;' +
            '}' +
            '.diag07-inline-excel-btn:hover { transform:translateY(-1px); box-shadow:0 4px 10px rgba(40,167,69,0.35); }';
        document.head.appendChild(st);
    }

    /* (1) 그리드(viewTable)에 이미 뿌려진 데이터 사용 — DB 재조회 없음 */
    var rows = [];
    try {
        rows = $('#viewTable').DataTable().rows().data().toArray();
    } catch(e) { rows = []; }

    if (!rows || rows.length === 0) {
        Swal.fire({ icon:'info', title:'알림', text:'그리드에 표시된 데이터가 없습니다.', timer:1500, showConfirmButton:false });
        return;
    }

    /* (2) 항정신성 처방(psyOrderYn='●') 행만 골라 주진단(mainDiagCd)별 환자수 집계 */
    var diagMap = {};   // { diagCode : { patKey : true, ... } }
    for (var i = 0; i < rows.length; i++) {
        var r = rows[i] || {};
        if (r.psyOrderYn !== '●') continue;
        var code = (r.mainDiagCd || '').toString().trim();
        if (!code) continue;
        var key = (r.patId || r.chartNo || '') + '|' + (r.admitDt || '');
        if (!diagMap[code]) diagMap[code] = {};
        diagMap[code][key] = true;
    }

    var codes = Object.keys(diagMap);
    if (codes.length === 0) {
        _diagRank07Data = [];
        _renderDiagRank07Modal([]);
        /* 뱃지 제거됨 */
        return;
    }

    /* (3) 진단코드 리스트만 서버에 보내 진단명 매칭 (가벼운 조회, 로딩 메시지 없음) */
    $.ajax({
        url: '/main/select_DiagNames.do',
        type: 'POST',
        data: { diagCodes: codes.join(',') },
        dataType: 'json',
        success: function(res) {
            var nameMap = {};
            var arr = (res && res.data) ? res.data : [];
            for (var k = 0; k < arr.length; k++) {
                nameMap[arr[k].diagCode] = arr[k].diagName || '';
            }
            _buildDiag07ListAndRender(codes, diagMap, nameMap);
        },
        error: function() {
            /* 진단명 조회 실패해도 코드/건수만으로 표시 */
            _buildDiag07ListAndRender(codes, diagMap, {});
        }
    });
}

function _buildDiag07ListAndRender(codes, diagMap, nameMap) {
    var list = [];
    for (var i = 0; i < codes.length; i++) {
        var c = codes[i];
        list.push({
            diagCode: c,
            diagName: nameMap[c] || '',
            diagCnt:  String(Object.keys(diagMap[c]).length)
        });
    }
    list.sort(function(a, b) {
        var ca = parseInt(a.diagCnt, 10) || 0;
        var cb = parseInt(b.diagCnt, 10) || 0;
        if (cb !== ca) return cb - ca;
        return (a.diagCode || '').localeCompare(b.diagCode || '');
    });
    _diagRank07Data = list;
    _renderDiagRank07Modal(list);
    /* 버튼 뱃지 제거됨 — 건수 표시 안 함 */
}

/* 정렬 상태 — 진단건수 DESC 기본 */
var _diag07SortKey = 'diagCnt';    // 'diagCode' | 'diagCnt'
var _diag07SortDir = 'desc';       // 'asc' | 'desc'

function _sortDiag07(list) {
    var key = _diag07SortKey, dir = _diag07SortDir;
    var sign = (dir === 'asc') ? 1 : -1;
    list.sort(function(a, b) {
        var va, vb;
        if (key === 'diagCnt') {
            va = parseInt(a.diagCnt, 10) || 0;
            vb = parseInt(b.diagCnt, 10) || 0;
            if (va !== vb) return (va - vb) * sign;
            /* 동률일 때 진단코드 ASC 고정 */
            return (a.diagCode || '').localeCompare(b.diagCode || '');
        } else {
            va = (a.diagCode || '');
            vb = (b.diagCode || '');
            var cmp = va.localeCompare(vb);
            if (cmp !== 0) return cmp * sign;
            var ca = parseInt(a.diagCnt, 10) || 0;
            var cb = parseInt(b.diagCnt, 10) || 0;
            return cb - ca;
        }
    });
    return list;
}

function _diag07TbodyHtml(list) {
    var html = '';
    for (var i = 0; i < list.length; i++) {
        var r = list[i] || {};
        var code = (r.diagCode || '').toString();
        var name = (r.diagName || '').toString();
        var cnt  = (r.diagCnt  || '0').toString();
        html += '<tr>' +
                '<td class="diag07-rowno">' + (i+1) + '</td>' +
                '<td class="diag07-code">' + code + '</td>' +
                '<td class="diag07-name">' + name + '</td>' +
                '<td class="diag07-cnt">' + cnt + '</td>' +
                '</tr>';
    }
    return html;
}

function _diag07SortInd(col) {
    /* 인디케이터 — 3상태, 모든 상태에 문자 표시 (같은 폭 유지):
       - 비활성 : ↕ (희미한 중립, 정렬 가능함을 암시)
       - ASC    : ▲ (진한색)
       - DESC   : ▼ (진한색)
       모두 BMP 도형문자 — 플랫폼 독립 안정 렌더 */
    if (_diag07SortKey !== col) {
        return '<span class="sort-ind sort-ind-off">&#8597;</span>';
    }
    return (_diag07SortDir === 'asc')
        ? '<span class="sort-ind sort-ind-on">&#9650;</span>'
        : '<span class="sort-ind sort-ind-on">&#9660;</span>';
}

function _renderDiagRank07Modal(list) {
    var total = (list || []).length;
    var html;
    if (total === 0) {
        html = '<div style="padding:30px; text-align:center; color:#6c757d; font-size:14px;">' +
               '<i class="fa fa-info-circle" style="font-size:32px; color:#95a5a6; margin-bottom:12px;"></i>' +
               '<div>해당 월에 항정신성 처방 대상자의 진단 집계 결과가 없습니다.</div></div>';
    } else {
        /* 현재 정렬 상태 반영 */
        _sortDiag07(list);

        html = '<div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:8px; flex-wrap:wrap; gap:8px;">' +
                  '<span style="font-weight:600; color:#1e3c72;">총 <b style="color:#c0392b;">' + total + '</b> 건</span>' +
                  '<button type="button" class="diag07-inline-excel-btn" id="btnDiag07ExcelInline">' +
                      '<i class="fa fa-file-excel"></i>엑셀 저장' +
                  '</button>' +
               '</div>';
        html += '<div class="diag07-scroll-wrap"><table class="diag07-table" id="diag07Table"><thead><tr>' +
                '<th style="width:50px;">순번</th>' +
                '<th class="sortable" data-sort="diagCode" style="width:110px;">진단코드' + _diag07SortInd('diagCode') + '</th>' +
                '<th style="text-align:left;">진단명</th>' +
                '<th class="sortable" data-sort="diagCnt" style="width:110px;">진단건수' + _diag07SortInd('diagCnt') + '</th>' +
                '</tr></thead><tbody id="diag07Tbody">';
        html += _diag07TbodyHtml(list);
        html += '</tbody></table></div>';
    }

    Swal.fire({
        title: '다빈도 상병순위별 (항정신성 처방 대상자)',
        html: html,
        width: 720,
        showCancelButton: false,
        confirmButtonText: '확인',
        customClass: { popup: 'diag07-popup' },
        didOpen: function() {
            /* 드래그 이동 */
            _diag07EnableDrag();
            /* 엑셀 버튼 바인딩 */
            var _bx = document.getElementById('btnDiag07ExcelInline');
            if (_bx) _bx.onclick = function() { fn_ExportDiagRank07Excel(); };

            /* 정렬 가능한 th 클릭 핸들러 */
            var ths = document.querySelectorAll('#diag07Table thead th.sortable');
            for (var t = 0; t < ths.length; t++) {
                ths[t].addEventListener('click', function() {
                    var key = this.getAttribute('data-sort');
                    if (_diag07SortKey === key) {
                        _diag07SortDir = (_diag07SortDir === 'asc') ? 'desc' : 'asc';
                    } else {
                        _diag07SortKey = key;
                        /* 진단건수: 기본 DESC, 진단코드: 기본 ASC */
                        _diag07SortDir = (key === 'diagCnt') ? 'desc' : 'asc';
                    }
                    _sortDiag07(_diagRank07Data);
                    /* 헤더 인디케이터 갱신 */
                    var hdCode = document.querySelector('#diag07Table thead th[data-sort="diagCode"]');
                    var hdCnt  = document.querySelector('#diag07Table thead th[data-sort="diagCnt"]');
                    if (hdCode) hdCode.innerHTML = '진단코드' + _diag07SortInd('diagCode');
                    if (hdCnt)  hdCnt.innerHTML  = '진단건수' + _diag07SortInd('diagCnt');
                    /* tbody 재렌더 */
                    var tb = document.getElementById('diag07Tbody');
                    if (tb) tb.innerHTML = _diag07TbodyHtml(_diagRank07Data);
                });
            }
        }
    });
}

function _diag07EnableDrag() {
    var popup = document.querySelector('.swal2-popup.diag07-popup');
    var title = popup ? popup.querySelector('.swal2-title') : null;
    if (!popup || !title) return;
    var dx = 0, dy = 0, sx = 0, sy = 0, dragging = false;
    title.addEventListener('mousedown', function(e) {
        dragging = true;
        sx = e.clientX; sy = e.clientY;
        var rc = popup.getBoundingClientRect();
        dx = rc.left - sx; dy = rc.top - sy;
        popup.style.position = 'fixed';
        popup.style.margin = '0';
        document.body.style.userSelect = 'none';
    });
    document.addEventListener('mousemove', function(e) {
        if (!dragging) return;
        popup.style.left = (e.clientX + dx) + 'px';
        popup.style.top  = (e.clientY + dy) + 'px';
    });
    document.addEventListener('mouseup', function() {
        dragging = false;
        document.body.style.userSelect = '';
    });
}

// 다빈도 상병순위 엑셀 저장 (진단코드 / 진단명 / 진단건수)
function fn_ExportDiagRank07Excel() {
    if (!_diagRank07Data || _diagRank07Data.length === 0) {
        Swal.fire({ icon:'info', title:'알림', text:'저장할 데이터가 없습니다.', timer:1500, showConfirmButton:false });
        return;
    }
    if (typeof XLSX === 'undefined') {
        Swal.fire({ icon:'error', title:'오류', text:'XLSX 라이브러리가 로드되지 않았습니다.' });
        return;
    }

    var rows = _diagRank07Data.map(function(r) {
        return {
            '진단코드': (r.diagCode || ''),
            '진단명':   (r.diagName || ''),
            '진단건수': Number(r.diagCnt || 0)
        };
    });

    var wb = XLSX.utils.book_new();
    var ws = XLSX.utils.json_to_sheet(rows);
    ws['!cols'] = [ {wch:14}, {wch:56}, {wch:12} ];
    XLSX.utils.book_append_sheet(wb, ws, '다빈도상병순위');

    var ym = (document.getElementById('year_Select').value || '') + (document.getElementById('monthSelect').value || '');
    var fname = '다빈도상병순위_항정신성_' + ym + '.xlsx';
    XLSX.writeFile(wb, fname);
}

// 낮을수록 좋은 지표 (5점 구간이 0부터 시작)
var LOWER_IS_BETTER = ['01','02','03','05','07','10','14'];

// 5점 구간 기준 (초기값, 서버 조회 후 덮어씀)
var FIVE_POINT_CRITERIA = {
	'01': { start: 0,    end: 25.99, direction: 'lower',  weight: 8.5  },
	'02': { start: 0,    end: 5.99,  direction: 'lower',  weight: 8.5  },
	'03': { start: 0,    end: 2.99,  direction: 'lower',  weight: 7.5  },
	'04': { start: 100,  end: 100,   direction: 'higher', weight: 5.5  },
	'05': { start: 0,    end: 2.99,  direction: 'lower',  weight: 6.0  },
	'07': { start: 0,    end: 9.99,  direction: 'lower',  weight: 3.0  },
	'08': { start: 98,   end: 100,   direction: 'higher', weight: 3.0  },
	'09': { start: 90,   end: 100,   direction: 'higher', weight: 2.0  },
	'10': { start: 0,    end: 0.24,  direction: 'lower',  weight: 4.4  },
	'11': { start: 60,   end: 100,   direction: 'higher', weight: 17.6 },
	'12': { start: 45,   end: 100,   direction: 'higher', weight: 12.0 },
	'13': { start: 98,   end: 100,   direction: 'higher', weight: 12.0 },
	'14': { start: 0,    end: 19.99, direction: 'lower',  weight: 5.0  },
	'15': { start: 70,   end: 100,   direction: 'higher', weight: 5.0  }
};

// 5점 구간 기준 서버 조회 (TBL_WEVALUE_MST) - 기준 변경 시 자동 반영
function loadFivePointCriteria(jobyymm) {
	$.ajax({
		url: "/main/select_ScoreCriteria.do",
		type: "POST",
		data: { jobyymm: jobyymm },
		dataType: "json",
		success: function(response) {
			if (response && response.data) {
				for (var i = 0; i < response.data.length; i++) {
					var item = response.data[i];
					var cd = item.cate_cd;
					var score = parseFloat(item.std_score);
					if (score === 5) {
						FIVE_POINT_CRITERIA[cd] = {
							start: parseFloat(item.start_indi),
							end: parseFloat(item.end_indi),
							direction: LOWER_IS_BETTER.includes(cd) ? 'lower' : 'higher',
							weight: parseFloat(item.we_value)
						};
					}
				}
			}
		}
	});
}

// 지표 선택 시 분석 문구 표시
function showIndiSummary(data) {
	var box = document.getElementById('indiSummaryText');
	if (!box) return;
	if (!data || data.cate_cd === '99') { box.style.display = 'none'; return; }

	var criteria = FIVE_POINT_CRITERIA[data.cate_cd];
	if (!criteria) { box.style.display = 'none'; return; }

	var calVal   = parseFloat(data.cal_val) || 0;
	var dtorval  = parseFloat(data.dtorval) || 0;
	var ntorval  = parseFloat(data.ntorval) || 0;
	var weigval  = parseFloat(data.weigval) || 0;
	var stdweig  = parseFloat(data.stdweig) || 0;
	var cateName = data.cate_nm;
	var isPersonUnit = ['01','02','03'].includes(data.cate_cd);
	var valUnit  = isPersonUnit ? '명' : '%';
	var isFivePoint = (calVal >= criteria.start && calVal <= criteria.end);
	var rangeText = criteria.start + ' ~ ' + criteria.end + '명';

	var html = '';
	if (isFivePoint) {
		html = '<div class="indi-summary-good">' +
			'<span class="indi-dot good">●</span> ' +
			'<b>' + cateName + '</b> 현재 <b>' + calVal + valUnit + '</b>로 ' +
			'<b class="text-primary">5점 구간 달성</b> (결과: ' + weigval + '점 / 만점: ' + stdweig + '점)' +
			'</div>';
	} else {
		var targetMsg = '';
		if (isPersonUnit) {
			targetMsg = '5점 도달 목표: <b>' + criteria.end + '명 이하</b>';
		} else if (dtorval > 0 && !['04','07','08'].includes(data.cate_cd)) {
			if (criteria.direction === 'higher') {
				var needNtor = Math.ceil(criteria.start * dtorval / 100);
				var diff = needNtor - ntorval;
				if (diff > 0) targetMsg = '5점 도달을 위해 추가 <b class="text-danger">' + diff + '명</b> 개선 필요 (분자 ' + ntorval + ' → ' + needNtor + ')';
			} else {
				var maxNtor = Math.floor(criteria.end * dtorval / 100);
				var diff2 = ntorval - maxNtor;
				if (diff2 > 0) targetMsg = '5점 도달을 위해 <b class="text-danger">' + diff2 + '명</b> 감소 필요 (분자 ' + ntorval + ' → ' + maxNtor + ')';
			}
		} else if (data.fiveZone && data.fiveZone.trim() !== '') {
			targetMsg = '5점 도달 필요: <b>' + data.fiveZone + '</b>';
		}
		var scoreDiff = (stdweig - weigval).toFixed(1);
		var detailLine = '→ 5점 구간: ' + rangeText;
		if (targetMsg) detailLine += ' | ' + targetMsg;
		html = '<div class="indi-summary-warn">' +
			'<span class="indi-dot warn">▲</span> ' +
			'<b>' + cateName + '</b> 현재 <b>' + calVal + valUnit + '</b>로 ' +
			'결과 <b>' + weigval + '점</b> (만점 ' + stdweig + '점 대비 <b class="text-danger">' + scoreDiff + '점 부족</b>)' +
			'<br>' +
			'<span class="indi-summary-detail">' + detailLine + '</span>' +
			'</div>';
	}
	box.innerHTML = html;
	box.style.display = 'block';
}

var mixedChart1;
var mixedChart2;
// var set_Table = null; 
var tableName = null;
var dataTable = new DataTable();
// var bak_Table = new DataTable();
dataTable.clear();
// bak_Table.clear();


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

var colPadding = '2px';   		// 행 높이 간격 설정
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

	if (flag === 1) {
		const card = document.getElementById('card_container');
	    card.style.display = 'none';
	    jobFlag = '00';

	    // ★ tableName 이 '보기' 모드 등으로 viewTable 로 바뀌었을 수 있음
	    //   지표 테이블(indicatorTable)을 ID로 직접 지정해 확실히 파괴
	    if ($.fn.DataTable.isDataTable('#indicatorTable')) {
	        $('#indicatorTable').DataTable().clear().destroy();
	    }
	    $('#indicatorTable').empty();

	    // tableName 포인터도 지표 테이블로 복귀
	    tableName = document.getElementById('indicatorTable');
	}
	
	let selected_Year = document.getElementById("year_Select").value;
    let selectedMonth = document.getElementById("monthSelect").value;
	let waitingCreate = document.getElementById("wait_Create");
    waitingCreate.style.display = 'flex';
    
    $.ajax({
  		url: "/main/create_Eval_Indi.do",
        type: "POST",
        data: { hosp_cd: hospid,
         	    jobyymm: selected_Year + selectedMonth,
         	    reg_user: userid
        },
        success: function(response) { 
        	if (response) { // 서버가 성공 응답을 보냈을 때 실행
	    		waitingCreate.style.display = 'none';
	    		loadFivePointCriteria(selected_Year + selectedMonth);
	    		Indicater_DataList();
	       	}
        },
        error: function(xhr, status, error) {
    	    waitingCreate.style.display = 'none';
        }
	});
}

// WINCHECK 로그인 시 전체생성 버튼 표시
$(document).ready(function() {
    // s_wnn_yn(위너넷사용자-로그인시설정) 또는 s_winconect(병원검색후설정)
     $('#btnEvalAllHosp').hide();
    if (getCookie("s_wnn_yn") === 'Y' || getCookie("s_winconect") === 'Y') {
    //	$('#btnEvalAllHosp').show();
    }
});

// 전체 병원 일괄 적정성평가 생성 (선택 월, W1236457 제외)
function fn_CreateEvalAllHosp() {

    var selYear  = document.getElementById("year_Select").value;
    var selMonth = document.getElementById("monthSelect").value;
    var jobMonth = selYear + selMonth;
    var monthLabel = selYear + '년 ' + selMonth + '월';

    Swal.fire({
        title: '전체 병원 적정성평가 생성',
        html: '전체 병원 대상으로<br><b>' + monthLabel + '</b> 적정성평가를 생성합니다.<br><br><span style="color:red;">시간이 오래 걸릴 수 있습니다.</span>',
        icon: 'warning',
        showCancelButton: true,
        confirmButtonText: '생성 시작',
        cancelButtonText: '취소'
    }).then(function(result) {
        if (!result.isConfirmed) return;

        // 1단계: 병원 목록 조회 (기존 URL + mode=list)
        $.ajax({
            url: "/main/createEvalIndiAllHosp.do",
            type: "POST",
            dataType: "json",
            data: { mode: 'list' },
            success: function(res) {
                if (typeof res === 'string') res = JSON.parse(res);
                if (res.result !== 'OK') {
                    Swal.fire({ icon: 'error', title: '오류', html: '병원 목록 조회 실패<br><small>' + JSON.stringify(res) + '</small>' });
                    return;
                }
                var hospList = res.hospList;
                var totalHosp = hospList.length;
                var hIdx = 0;
                var doneCount = 0;
                var errorCount = 0;

                Swal.fire({
                    title: '전체 병원 적정성평가 진행 중',
                    html: '<style>' +
                          '@keyframes progressStripe { 0% { background-position: 1rem 0; } 100% { background-position: 0 0; } }' +
                          '.swal-progress-animated { background: linear-gradient(90deg,#dc3545,#fd7e14); border-radius:11px; transition:width 0.5s; ' +
                          'background-image: linear-gradient(45deg, rgba(255,255,255,.15) 25%, transparent 25%, transparent 50%, rgba(255,255,255,.15) 50%, rgba(255,255,255,.15) 75%, transparent 75%, transparent); ' +
                          'background-size: 1rem 1rem; animation: progressStripe 0.5s linear infinite; }' +
                          '</style>' +
                          '<div style="text-align:center; margin-top:10px;">' +
                          '<div id="swalEvalBar" style="width:100%; height:22px; background:#e9ecef; border-radius:11px; overflow:hidden; margin-bottom:10px;">' +
                          '  <div id="swalEvalFill" class="swal-progress-animated" style="width:1%; height:100%;"></div>' +
                          '</div>' +
                          '<div id="swalEvalText" style="font-size:14px; color:#333;"><i class="fa fa-spinner fa-spin mr-1"></i> 준비 중...</div>' +
                          '<div id="swalEvalCount" style="font-size:15px; color:#dc3545; margin-top:6px; font-weight:bold;">0 / ' + totalHosp + ' 병원</div>' +
                          '<div id="swalEvalMonth" style="font-size:13px; color:#555; margin-top:4px;">' + monthLabel + '</div>' +
                          '<div id="swalEvalTime" style="font-size:12px; color:#888; margin-top:4px;">경과시간: 0초</div>' +
                          '</div>',
                    allowOutsideClick: false,
                    allowEscapeKey: false,
                    showConfirmButton: false
                });

                var startTime = new Date().getTime();
                var timerInterval = setInterval(function() {
                    var elapsed = Math.floor((new Date().getTime() - startTime) / 1000);
                    var min = Math.floor(elapsed / 60);
                    var sec = elapsed % 60;
                    var timeEl = document.getElementById('swalEvalTime');
                    if (timeEl) timeEl.textContent = '경과시간: ' + (min > 0 ? min + '분 ' : '') + sec + '초';
                }, 1000);

                function runNext() {
                    if (hIdx >= totalHosp) {
                        clearInterval(timerInterval);
                        if (errorCount > 0) {
                            Swal.fire({ icon: 'warning', title: '적정성평가 완료', html: monthLabel + ' 총 ' + totalHosp + '건 중 <b style="color:red;">' + errorCount + '건 오류</b>' });
                        } else {
                            Swal.fire({ icon: 'success', title: '적정성평가 완료', text: monthLabel + ' 전체 ' + totalHosp + '개 병원 정상 처리 완료' });
                        }
                        return;
                    }

                    var curHosp = hospList[hIdx];
                    var pct = Math.round(((hIdx + 1) / totalHosp) * 100);

                    var fill = document.getElementById('swalEvalFill');
                    var text = document.getElementById('swalEvalText');
                    var cnt  = document.getElementById('swalEvalCount');
                    if (fill) fill.style.width = Math.max(pct, 1) + '%';
                    if (text) text.innerHTML = '<i class="fa fa-spinner fa-spin mr-1"></i> <b>' + monthLabel + '</b> - ' + curHosp + ' 처리 중...';
                    if (cnt) cnt.textContent = (hIdx + 1) + ' / ' + totalHosp + ' 병원';

                    $.ajax({
                        url: "/main/createEvalIndiAllHosp.do",
                        type: "POST",
                        dataType: "json",
                        data: {
                            mode: 'one',
                            hosp_cd: curHosp,
                            jobyymm: jobMonth,
                            reg_user: userid
                        },
                        timeout: 300000,
                        success: function(response) {
                            if (response.result !== 'OK') errorCount++;
                            doneCount++;
                            hIdx++;
                            runNext();
                        },
                        error: function() {
                            errorCount++;
                            doneCount++;
                            hIdx++;
                            runNext();
                        }
                    });
                }

                runNext();
            },
            error: function(xhr, status, error) {
                Swal.fire({ icon: 'error', title: '오류', html: '병원 목록 조회 실패<br><small>상태: ' + status + '<br>코드: ' + xhr.status + '<br>' + error + '</small>' });
            }
        });
    });
}

function fn_Update() {
	
	const dataList = [
	    {
	        hospCd: hospid,
	        startYy: $("#yearQuarter").val(),
	        qterFlag: $("#monsQuarter").val(),
	        hospgrade: $("#hospcdGrade").val(),
	        patCount: $("#pat_Count").val(),
	        docCount: $("#doc_Count").val(),
	        nurCount: $("#nur_Count").val(),
	        nurSCnt: $("#nursCount").val(),
	        phamDays: $("#pham_Days").val(),
	        // totalDay: $("#total_Day").val(),
	        // goalName: $("#goal_Name").val(),	        
	        goalScore: $("#goal_Score").val(),
	        goalJugi: $("#goal_Jugi").val(),
	        goalChasu: $("#goal_Chasu").val(),
	        regUser: userid,
	        updUser: userid
	    }
	];
	
    $.ajax({
    	type: "POST",
        url: "/user/saveHospGrd.do",
        contentType: "application/json",
        data: JSON.stringify(dataList), 
        success: function(response) {
            if (response) {
                Swal.fire({
                    title: '처리확인',
                    text: '정상처리 되었습니다.',
                    icon: 'success',
                    confirmButtonText: '확인',
                    timer: 800,
                    timerProgressBar: true,
                    showConfirmButton: false
                });
                jobFlag = "00";
                fn_CreateData(1);
            }
        },
        error: function(xhr, status, error) {
            console.error("Error saving data:", error);
        }
    });
}

function fn_Select() {
	
	$.ajax({
        type: "POST",
        url: "/user/selectHospGrd.do", 
        data: {
            hospCd: hospid,
            startYy: $("#yearQuarter").val(),
            qterFlag: $("#monsQuarter").val()
        },
        dataType: "json",
        success: function(response) {
        	
        	if (response && Object.keys(response).length > 0) {
        		
                $("#hospcdGrade").val(response.data.hospgrade);
                $("#pat_Count").val(response.data.patCount);
                $("#doc_Count").val(response.data.docCount);
                $("#nur_Count").val(response.data.nurCount);
                $("#nursCount").val(response.data.nurSCnt);
                $("#pham_Days").val(response.data.phamDays);
               // $("#total_Day").val(response.data.totalDay);
               // $("#goal_Name").val(response.data.goalName);
                $("#goal_Score").val(response.data.goalScore);
                $("#goal_Jugi").val(response.data.goalJugi);
    	        $("#goal_Chasu").val(response.data.goalChasu);
    	        
    	        if (winner === 'Y' || mainfg === '1') {
                	document.getElementById("formBtnSave").style.display = "flex";
    	        } else {
    	        	
    	        	document.getElementById("formBtnSave").style.display = "none";
    	        	
    	        	const {
    	        	    patCount,
    	        	    docCount,
    	        	    nurCount,
    	        	    nurSCnt,
    	        	    phamDays
    	        	} = response.data || {};

    	        	const isAllEmpty = [patCount, docCount, nurCount, nurSCnt, phamDays].every(val => !val);

    	        	if (isAllEmpty) {
    	        	    document.getElementById("formBtnSave").style.display = "flex";
    	        	}
    	        }
            }
        },
        error: function(jqXHR, textStatus, errorThrown) {
            console.error("Error fetching data:", textStatus, errorThrown);
        }
    });
}


function fn_IndiSelect() {

	jobFlag = '00';
	
	let selected_Year = document.getElementById("year_Select").value;
    let selectedMonth = document.getElementById("monthSelect").value;
    
    defaultCnt = 30;
	page_Hight = 600;
	colPadding = '2px';   	// 행 높이 간격 설정
	
	datWaiting = false;   		// Data 가져오는 동안 대기상태 Waiting 표시 여부
	page_Navig = false;   		// 페이지 네비게이션 표시여부 
	hd_Sorting = false;   		// Head 정렬(asc,desc) 표시여부
	info_Count = false;   		// 총건수 대비 현재 건수 보기 표시여부 
	searchShow = false;   		// 검색창 Show/Hide 표시여부
	showButton = false;   		// Button (복사, 엑셀, 출력)) 표시여부
	txt_Markln = 13; 
    dataTable.ajax.reload();
}
function Indicater_DataList() {
	
	defaultCnt = 30;
	page_Hight = 600;
	colPadding = '2px';   		// 행 높이 간격 설정
	
	datWaiting = false;   		// Data 가져오는 동안 대기상태 Waiting 표시 여부
	page_Navig = false;   		// 페이지 네비게이션 표시여부 
	hd_Sorting = false;   		// Head 정렬(asc,desc) 표시여부
	info_Count = false;   		// 총건수 대비 현재 건수 보기 표시여부 
	searchShow = false;   		// 검색창 Show/Hide 표시여부
	showButton = false;   		// Button (복사, 엑셀, 출력)) 표시여부
	searchShow = false;   		// 검색창 Show/Hide 표시여부
	
	tableName  = document.getElementById('indicatorTable');
	
	c_Head_Set = [  '지표명칭','가중치','분모','분자','5점구간','현황값','결과','지표코드','지표구분','작업년월','적용구간'  ];   
	
   	columnsSet = [  { data: 'cate_nm', visible: true,  className: 'dt-body-left',   width: '100px' },
   					{ data: 'stdweig', visible: true,  className: 'dt-body-center', width: '50px' },
   					{ data: 'dtorval', visible: true,  className: 'dt-body-center', width: '50px', 
						render: function(data, type, row) {
		        			if (type === 'display') {
		        				if (row.cate_cd === '99') {
		        			        return '';
		        			    }
		            		}
		            		return data;
		  			    },
					},
					
					{ data: 'ntorval', visible: true,  className: 'dt-body-center', width: '50px', 
						render: function(data, type, row) {
		        			if (type === 'display') {
		        				if (row.cate_cd === '99') {
		        			        return '';
		        			    }
		            		}
		            		return data;
		  			    },
					},	
					/*
					{ data: 'fiveZone', visible: true,  className: 'dt-body-center', width: '100px',
						render: function(data, type, row) {
						    if (type === 'display' && typeof data === 'string') {
						      const sign = data.charAt(0);
						      if (sign === '+' || sign === '-') {
						        return `<span style="color:red; font-weight:bold;">` + sign + `</span>` + data.slice(1);
						      }
						    }
						    return data;
						  }
					},
					*/
					{ data: 'fiveZone', visible: true, className: 'dt-body-center', width: '100px',
						createdCell: function(td, cellData) {
							td.style.color = 'red';
				            td.style.fontWeight = 'red';
					    }
				    },
					{ data: 'cal_val',  visible: true,  className: 'dt-body-center', width: '50px', 
						render: function(data, type, row) {
		        			if (type === 'display') {
		        				if (row.cate_cd === '99') {
		        			        return '';
		        			    }
		        				if (['01', '02', '03'].includes(row.cate_cd)) {
		        			        return data + '명';
		        			    } else {
		        			        return data + '%';
		        			    }
		        			}
		        			return data;
		  			    },
					},
					{ data: 'weigval', visible: true,  className: 'dt-body-center', width: '50px' },
					{ data: 'cate_cd', visible: false, className: 'dt-body-center', width: '50px' },
					{ data: 'cate_fg', visible: false, className: 'dt-body-center', width: '50px' },
					{ data: 'jobyymm', visible: false, className: 'dt-body-center', width: '50px' },
					{ data: 's_score', visible: false, className: 'dt-body-center', width: '50px' }
   				 ];
   	// 초기 data Sort,  없으면 []
   	muiltSorts = [];
   	// Sort여부 표시를 일부만 할 때 개별 id, ** 전체 적용은 '_all'하면 됩니다. ** 전체 적용 안함은 []        				 
   	showSortNo = [];                   
   	// Columns 숨김 columnsSet -> visible로 대체함 hideColums 보다 먼제 처리됨 ( visible를 선언하지 않으면 hideColums컬럼 적용됨 )	
   	hideColums = [];             // 없으면 []; 일부 컬럼 숨길때		
   	txt_Markln = 13;                       				 // 컬럼의 글자수가 설정값보다 크면, 다음은 ...로 표시함
   	// 글자수 제한표시를 일부만 할 때 개별 id, ** 전체 적용은 '_all'하면 됩니다. ** 전체 적용 안함은 []
   	markColums = ['cate_nm'];
   	
   	fn_HeadColumnSet();
   	fn_FindDataTable();
   	
}
function fn_ViewData(data) {

	jobFlag    = data.cate_cd;
	jobYyMm    = data.jobyymm;

	// jobFlag 변경 시 05 상단 버튼 재평가
	if (jobFlag !== '05') {
	    _prevMissingData = [];
	    _errCheckData = [];
	}
	fn_UpdateCath05Buttons();

	// 환자평가표 조회 버튼 초기화 (행 재선택 시 다시 활성화)
	if (typeof fn_UpdatePatvalBtnState === 'function') {
	    fn_UpdatePatvalBtnState(null);
	}

	datWaiting = false;   		// Data 가져오는 동안 대기상태 Waiting 표시 여부
	page_Navig = true;   		// 페이지 네비게이션 표시여부 
	hd_Sorting = true;   		// Head 정렬(asc,desc) 표시여부
	info_Count = true;   		// 총건수 대비 현재 건수 보기 표시여부 
	showButton = true;   		// Button (복사, 엑셀, 출력)) 표시여부
	s_CheckBox = false;   		// CheckBox 표시 여부
	s_AutoNums = false;   		// 자동순번 표시 여부
	page_Hight = 720;
	defaultCnt = 100;
	colPadding = '0.2px';   	// 행 높이 간격 설정
	searchShow = true;   		// 검색창 Show/Hide 표시여부
	
	const card = document.getElementById('card_container');
	const view = document.getElementById('view_container');
	view.style.display = 'none';

	// 이전 경고 박스 제거
	var pw = document.getElementById('prevMonthWarn'); if (pw) pw.remove();
	var ew = document.getElementById('errCheckWarn');  if (ew) ew.remove();
	
	const ltxt = document.getElementById('lab_title');
	ltxt.textContent = data.cate_cd + '. ' + data.cate_nm;
	
    let selected_Year = document.getElementById("year_Select").value;
    let selectedMonth = document.getElementById("monthSelect").value;
    
    
    
	if (["08", "15", "99"].includes(data.cate_cd)) {
		
		card.style.display = 'none';	
		
		if (data.cate_cd === '99') {
		    view.style.display = 'flex';
			loadEvaluationData();
		}
		
		
    	return;
    	
    } else {
    	
    	card.style.display = 'flex';
    	
    	const inputZone = document.getElementById("inputZone");
    	inputZone.style.display = 'none';
    	
    	
    	
	   	if (["01", "02", "03", "04"].includes(data.cate_cd)) {
	   		
	   		ltxt.textContent = '분기별 차등제 자료등록 및 연간 목표 등록';
	   		
	   		inputZone.style.display = 'flex';
	   		
	   		
	   		const hideTable = document.getElementById('viewTable');
	   		
    		$('#' + hideTable.id).DataTable().clear().destroy();
    		$('#' + hideTable.id).empty();
    	    
    		/*
    	    if (getCookie("s_winconect") === 'Y') { 
    	   		
    	   		f_btnSave.style.display = 'inline-block';
    	   	}
    	   	*/
    	    
    	   	if        (["01", "02", "03"].includes(selectedMonth)) {
    	   		$("#monsQuarter").val(1);
    	   	} else if (["04", "05", "06"].includes(selectedMonth)) {
    	   		$("#monsQuarter").val(2);
    	   	} else if (["07", "08", "09"].includes(selectedMonth)) {
    	   		$("#monsQuarter").val(3);
    	   	} else {
    	   		$("#monsQuarter").val(4);
    	   	}
    	   	
    	    fn_Select();
    	   	
    	    return;
    	}
    }
    
    if (data.cate_cd === "05") {
    	c_Head_Set = [
        				[
			        	    { label: '생년월일',          rowspan: 2 },
			        	    { label: '대상자',           rowspan: 2 },
			        	    { label: '입원일',           rowspan: 2 },
			        	    { label: '개시일',           rowspan: 2 },
			        	    { label: '작성일',           rowspan: 2 },
			        	    { label: '전월',             rowspan: 2 },
			        	    { label: selected_Year + '년 ' + selectedMonth + '월 (당월)', colspan: 2 },
			        	    { label: 'foley체크',        rowspan: 2 } ,
			        	    { label: '14일초과',          rowspan: 2 }
			        	],
			        	[
			        	    { label: '고위험' },
			        	    { label: '저위험' }
		        	  	]
		        	 ];
        
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
						{ data: 'prevMonth', visible: true, className: 'dt-body-center', width: '40px',
							render: function(data, type, row) {
								if (type === 'display') {
									return data === 'Y' ? '✔' : '';
								}
								return data;
							}
						},
						{ data: 'dangerHi',  visible: true, className: 'dt-body-center', width: '100px',
							
							render: function(data, type, row) {
						        // 화면 출력용(type === 'display')일 때만 텍스트를 변환
						        if (type === 'display') {
						        	return data === 'Y' ? '●' : data === 'N' ? '○' : '';
						        }
						        return data;
						    },
						},
						{ data: 'dangerLow', visible: true, className: 'dt-body-center', width: '100px',
							render: function(data, type, row) {
						        // 화면 출력용(type === 'display')일 때만 텍스트를 변환
						        if (type === 'display') {
						        	return data === 'Y' ? '●' : data === 'N' ? '○' : '';
						        }
						        return data;
						    },
						},
						{ data: 'indwellCath', visible: true, className: 'dt-body-center', width: '40px',
							render: function(data, type, row) {
						        // 화면 출력용(type === 'display')일 때만 텍스트를 변환
								if (type === 'display') {
								      return data === '1' ? '✔' : '';
								}
								return data;
						    }
					    },						
						{ data: 'overDay', visible: true, className: 'dt-body-center', width: '100px',
							render: function(data, type, row) {
						        // 화면 출력용(type === 'display')일 때만 텍스트를 변환
								if (type === 'display') {
								      return data === 'Y' ? '해당' : '';
								}
								return data;
						    }
					    }
    				 ];
    	
    	// 초기 data Sort,  없으면 []
    	muiltSorts = [
		             	['overDay', 'desc']  // 내림차순 정렬
	   		         ];
    	// Sort여부 표시를 일부만 할 때 개별 id, ** 전체 적용은 '_all'하면 됩니다. ** 전체 적용 안함은 []        				 
    	showSortNo = ['_all'];                   
    	// Columns 숨김 columnsSet -> visible로 대체함 hideColums 보다 먼제 처리됨 ( visible를 선언하지 않으면 hideColums컬럼 적용됨 )	
    	hideColums = [];             // 없으면 []; 일부 컬럼 숨길때		
    	txt_Markln = 20;                       				 // 컬럼의 글자수가 설정값보다 크면, 다음은 ...로 표시함
    	// 글자수 제한표시를 일부만 할 때 개별 id, ** 전체 적용은 '_all'하면 됩니다. ** 전체 적용 안함은 []
    	markColums = [];
    } else if (data.cate_cd === "07") {
    	page_Hight = 690;
    	c_Head_Set = [  '생년월일','대상자','입원일자','요양개시일','평가표작성일','주진단','항정신성처방여부'  ];
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
   						{ data: 'mainDiagCd', visible: true,  className: 'dt-body-center', width: '100px'  },
   						{ data: 'psyOrderYn', visible: true,  className: 'dt-body-center', width: '100px'  }
       				 ];
       	
       	// 초기 data Sort,  없으면 []
       	muiltSorts = [
		             	['psyOrderYn', 'desc']  // 내림차순 정렬
	   		         ];
       	// Sort여부 표시를 일부만 할 때 개별 id, ** 전체 적용은 '_all'하면 됩니다. ** 전체 적용 안함은 []        				 
       	showSortNo = ['_all'];                   
       	// Columns 숨김 columnsSet -> visible로 대체함 hideColums 보다 먼제 처리됨 ( visible를 선언하지 않으면 hideColums컬럼 적용됨 )	
       	hideColums = [];             // 없으면 []; 일부 컬럼 숨길때		
       	txt_Markln = 20;                       				 // 컬럼의 글자수가 설정값보다 크면, 다음은 ...로 표시함
       	// 글자수 제한표시를 일부만 할 때 개별 id, ** 전체 적용은 '_all'하면 됩니다. ** 전체 적용 안함은 []
       	markColums = [];	
    	
    } else if (data.cate_cd === "09") {
    	c_Head_Set = [
			    		[
			    		    { label: '', rowspan: 2 },
			    		    { label: '대상자',  rowspan: 2 },
			    		    { label: '입원일',  rowspan: 2 },
			    		    { label: '개시일',  rowspan: 2 },
			    		    { label: '작성일',  rowspan: 2 },
			    		    { label: '욕창단계(전월)', colspan: 4 },
			    		    { label: '욕창단계(당월)', colspan: 4 },
			    		    { label: '욕창처치(당월)', colspan: 5 },
			    		    
			    		    { label: '다음월', rowspan: 2 },
			    		    { label: '처치'  , rowspan: 2 }
			    		],
			    		[
			    			{ label: '1' },
			    		    { label: '2' },
			    		    { label: '3' },
			    		    { label: '4' },
			    		    { label: '1' },
			    		    { label: '2' },
			    		    { label: '3' },
			    		    { label: '4' },
			    		    { label: 'a' },
			    		    { label: 'b' },
			    		    { label: 'c' },
			    		    { label: 'd' },
			    		    { label: '체중'}
			    		    
			    		    
			    	 	]
			    	 ];

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
						{ data: 'prevStep1', visible: true,  className: 'dt-body-center', width: '100px'  },
						{ data: 'prevStep2', visible: true,  className: 'dt-body-center', width: '100px'  },
						{ data: 'prevStep3', visible: true,  className: 'dt-body-center', width: '100px'  },
						{ data: 'prevStep4', visible: true,  className: 'dt-body-center', width: '100px'  },
						{ data: 'curtStep1', visible: true,  className: 'dt-body-center', width: '100px'  },
						{ data: 'curtStep2', visible: true,  className: 'dt-body-center', width: '100px'  },
						{ data: 'curtStep3', visible: true,  className: 'dt-body-center', width: '100px'  },
						{ data: 'curtStep4', visible: true,  className: 'dt-body-center', width: '100px'  },
						{ data: 'preRelDev', visible: true,  className: 'dt-body-center', width: '100px'  },
						{ data: 'posChange', visible: true,  className: 'dt-body-center', width: '100px'  },
						{ data: 'nutSupply', visible: true,  className: 'dt-body-center', width: '100px'  },
						{ data: 'skinDress', visible: true,  className: 'dt-body-center', width: '100px'  },
						{ data: 'weig'     , visible: true,  className: 'dt-body-center', width: '100px'  },
					    { data: 'dressingYn', visible: true, className: 'dt-body-center', width: '100px',
							render: function(data, type, row) {
						        // 화면 출력용(type === 'display')일 때만 텍스트를 변환
								if (type === 'display') {
									var hasPrev = row.prevStep1 !== '0' || row.prevStep2 !== '0' || row.prevStep3 !== '0' || row.prevStep4 !== '0';
									var allCurtZero = row.curtStep1 === '0' && row.curtStep2 === '0' && row.curtStep3 === '0' && row.curtStep4 === '0';
									var curtStep1Is1 = row.curtStep1 === '1';
									var condMet = hasPrev && (allCurtZero || curtStep1Is1);
						        	if (data === '1') return '해당';
						        	if (data === '2' && condMet) return '해당';
						        	if (data === '2') return '미처치';
						            if (data === '3') return '미처치';
						            if (data === '9') return '';
						        }
						        return data;
						    },
						    createdCell: function(td, cellData, rowData) {
						    	var hasPrev = rowData.prevStep1 !== '0' || rowData.prevStep2 !== '0' || rowData.prevStep3 !== '0' || rowData.prevStep4 !== '0';
						    	var allCurtZero = rowData.curtStep1 === '0' && rowData.curtStep2 === '0' && rowData.curtStep3 === '0' && rowData.curtStep4 === '0';
						    	var curtStep1Is1 = rowData.curtStep1 === '1';
						    	var condMet = hasPrev && (allCurtZero || curtStep1Is1);
						        if (cellData === '1' || (cellData === '2' && condMet)) {
						            td.style.color = 'green';
						            td.style.fontWeight = 'bold';
						        }
						    }
					    },
					    { data: 'nextTarget', visible: true, className: 'dt-body-center', width: '100px',
							render: function(data, type, row) {
						        // 화면 출력용(type === 'display')일 때만 텍스트를 변환
						        if (type === 'display') {
						            return data === 'N' ? '' : '대상자';
						        }
						        return data; // 그 외 타입(ex. sort, export 등)은 원본 데이터 유지
						    },
						    createdCell: function(td, cellData) {
						        if (cellData === 'Y') {
						            td.style.color = 'blue';
						            td.style.fontWeight = 'bold';
						        }
						    }
					    }
					 ];
			
			// 초기 data Sort,  없으면 []
			muiltSorts = [
			             	['dressingYn', 'asc']  // 오름차순 정렬
		   		         ];
			// Sort여부 표시를 일부만 할 때 개별 id, ** 전체 적용은 '_all'하면 됩니다. ** 전체 적용 안함은 [] 
			
			showSortNo = ['patId','patNm','admitDt','medStart','docDt','dressingYn','nextTarget'];
			// Columns 숨김 columnsSet -> visible로 대체함 hideColums 보다 먼제 처리됨 ( visible를 선언하지 않으면 hideColums컬럼 적용됨 )	
			hideColums = [];             // 없으면 []; 일부 컬럼 숨길때		
			txt_Markln = 20;                       				 // 컬럼의 글자수가 설정값보다 크면, 다음은 ...로 표시함
			// 글자수 제한표시를 일부만 할 때 개별 id, ** 전체 적용은 '_all'하면 됩니다. ** 전체 적용 안함은 []
			markColums = [];
    } else if (data.cate_cd === "10") {
    	c_Head_Set = [
			    		[
			    		    { label: '', rowspan: 2 },
			    		    { label: '대상자',  rowspan: 2 },
			    		    { label: '입원일',  rowspan: 2 },
			    		    { label: '개시일',  rowspan: 2 },
			    		    { label: '작성일',  rowspan: 2 },
			    		    
			    		    { label: '위험군', colspan: 2 },
			    		    
			    		    { label: '욕창단계(전월)', colspan: 4 },
			    		    { label: '욕창단계(당월)', colspan: 4 },
			    		    { label: '당월발생',  rowspan: 2 }
			    		],
			    		[
			    			{ label: '전월' },
			    		    { label: '당월' },
			    		    { label: '1' },
			    		    { label: '2' },
			    		    { label: '3' },
			    		    { label: '4' },
			    		    { label: '1' },
			    		    { label: '2' },
			    		    { label: '3' },
			    		    { label: '4' }
			    	 	]
			    	 ];

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
						{ data: 'dangerPm',  visible: true,  className: 'dt-body-center', width: '100px'  },
						{ data: 'dangerCm',  visible: true,  className: 'dt-body-center', width: '100px'  },
						{ data: 'prevStep1', visible: true,  className: 'dt-body-center', width: '100px'  },
						{ data: 'prevStep2', visible: true,  className: 'dt-body-center', width: '100px'  },
						{ data: 'prevStep3', visible: true,  className: 'dt-body-center', width: '100px'  },
						{ data: 'prevStep4', visible: true,  className: 'dt-body-center', width: '100px'  },
						{ data: 'curtStep1', visible: true,  className: 'dt-body-center', width: '100px'  },
						{ data: 'curtStep2', visible: true,  className: 'dt-body-center', width: '100px'  },
						{ data: 'curtStep3', visible: true,  className: 'dt-body-center', width: '100px'  },
						{ data: 'curtStep4', visible: true,  className: 'dt-body-center', width: '100px'  },
						{ data: 'improveYn', visible: true, className: 'dt-body-center', width: '100px',
							render: function(data, type, row) {
						        // 화면 출력용(type === 'display')일 때만 텍스트를 변환
						        if (type === 'display') {
						            return data === '2' ? '' : '발생';
						        }
						        return data; // 그 외 타입(ex. sort, export 등)은 원본 데이터 유지
						    },
						    createdCell: function(td, cellData) {
						        if (cellData === '1') {
						            td.style.color = 'red';
						            td.style.fontWeight = 'bold';
						        }
						    }
					    }
					 ];
		
		// 초기 data Sort,  없으면 []
		muiltSorts = [
		             	['improveYn', 'asc']  // 오름차순 정렬
	   		         ];
		// Sort여부 표시를 일부만 할 때 개별 id, ** 전체 적용은 '_all'하면 됩니다. ** 전체 적용 안함은 []        				 
		showSortNo = ['patId','patNm','admitDt','medStart','docDt','dangerHi','improveYn'];  
		// Columns 숨김 columnsSet -> visible로 대체함 hideColums 보다 먼제 처리됨 ( visible를 선언하지 않으면 hideColums컬럼 적용됨 )	
		hideColums = [];             // 없으면 []; 일부 컬럼 숨길때		
		txt_Markln = 20;                       				 // 컬럼의 글자수가 설정값보다 크면, 다음은 ...로 표시함
		// 글자수 제한표시를 일부만 할 때 개별 id, ** 전체 적용은 '_all'하면 됩니다. ** 전체 적용 안함은 []
		markColums = [];
    			
    } else if (data.cate_cd === "11") {
    	c_Head_Set = [
			    		[
			    		    { label: '생년월일', rowspan: 2 },
			    		    { label: '대상자',  rowspan: 2 },
			    		    { label: '입원일',  rowspan: 2 },
			    		    { label: '개시일',  rowspan: 2 },
			    		    { label: '작성일',  rowspan: 2 },
			    		    { label: '욕창단계(전월)', colspan: 4 },
			    		    { label: '욕창단계(당월)', colspan: 4 },
			    		    { label: '개선',   rowspan: 2 },
			    		    { label: '다음월',  rowspan: 2 }
			    		],
			    		[
			    		    { label: '1' },
			    		    { label: '2' },
			    		    { label: '3' },
			    		    { label: '4' },
			    		    { label: '1' },
			    		    { label: '2' },
			    		    { label: '3' },
			    		    { label: '4' }
			    	 	]
			    	 ];

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
						{ data: 'prevStep1', visible: true,  className: 'dt-body-center', width: '100px'  },
						{ data: 'prevStep2', visible: true,  className: 'dt-body-center', width: '100px'  },
						{ data: 'prevStep3', visible: true,  className: 'dt-body-center', width: '100px'  },
						{ data: 'prevStep4', visible: true,  className: 'dt-body-center', width: '100px'  },
						{ data: 'curtStep1', visible: true,  className: 'dt-body-center', width: '100px'  },
						{ data: 'curtStep2', visible: true,  className: 'dt-body-center', width: '100px'  },
						{ data: 'curtStep3', visible: true,  className: 'dt-body-center', width: '100px'  },
						{ data: 'curtStep4', visible: true,  className: 'dt-body-center', width: '100px'  },
						{ data: 'improveYn', visible: true, className: 'dt-body-center', width: '100px',
							render: function(data, type, row) {
						        // 화면 출력용(type === 'display')일 때만 텍스트를 변환
						        if (type === 'display') {
						        	if (data === '1') return '개선';
						            if (data === '2') return '제외';
						            if (data === '4') return '';
						            if (data === '3') return '미개선';
						        }
						        return data;
						    },
						    createdCell: function(td, cellData) {
						    	if        (cellData === '1') {
						            td.style.color = 'green';
						        } else if (cellData === '2') {
						            td.style.color = 'gray';
						        } else if (cellData === '3') {
						            td.style.color = 'red';
						        } 
						    }
					    },
					    { data: 'nextTarget', visible: true, className: 'dt-body-center', width: '100px',
							render: function(data, type, row) {
						        // 화면 출력용(type === 'display')일 때만 텍스트를 변환
						        if (type === 'display') {
						        	if (data === 'Y') return '대상자';
						            if (data === 'N') return '제외';
						            if (data === 'X') return '퇴원';
						        }
						        return data;
						    },
						    createdCell: function(td, cellData) {
						    	if (cellData === 'Y') {
						            td.style.color = 'blue';
						            td.style.fontWeight = 'bold';
						        } else if (cellData === 'X') {
						            td.style.color = 'red';
						            td.style.fontWeight = 'bold';
						        }
						    }
					    }
					 ];
		
		// 초기 data Sort,  없으면 []
		muiltSorts = [
		             	['improveYn', 'asc']  // 오름차순 정렬
	   		         ];
		// Sort여부 표시를 일부만 할 때 개별 id, ** 전체 적용은 '_all'하면 됩니다. ** 전체 적용 안함은 []        				 
		showSortNo = ['patId','patNm','admitDt','medStart','docDt','improveYn','nextTarget'];
		// Columns 숨김 columnsSet -> visible로 대체함 hideColums 보다 먼제 처리됨 ( visible를 선언하지 않으면 hideColums컬럼 적용됨 )	
		hideColums = [];             // 없으면 []; 일부 컬럼 숨길때		
		txt_Markln = 20;                       				 // 컬럼의 글자수가 설정값보다 크면, 다음은 ...로 표시함
		// 글자수 제한표시를 일부만 할 때 개별 id, ** 전체 적용은 '_all'하면 됩니다. ** 전체 적용 안함은 []
		markColums = [];
    			
    } else if (data.cate_cd === "12") {
    	c_Head_Set = [
			    		[
			    		    { label: '', rowspan: 2 },
			    		    { label: '대상자',  rowspan: 2 },
			    		    { label: '입원일',  rowspan: 2 },
			    		    { label: '개시일',  rowspan: 2 },
			    		    { label: '작성일',  rowspan: 2 },
			    		    { label: 'ADL (전월)', colspan: 3 },
			    		    { label: 'ADL (당월)', colspan: 2 },
			    		    { label: '당월개선', rowspan: 2 },
			    		    { label: '다음월',  rowspan: 2 }
			    		],
			    		[
			    			{ label: '환자군' },
			    			{ label: '총점' },
			    			{ label: '10개' },
			    			
			    			{ label: '환자군' },
			    		    { label: '총점' }
			    		    
			    	 	]
			    	 ];

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
						{ data: 'pPatClass', visible: true, className: 'dt-body-center', width: '100px',
							render: function(data, type, row) {
						        // 화면 출력용(type === 'display')일 때만 텍스트를 변환
						        if (type === 'display') {
						        	if (data === 'A') return '의료최고';
						        	if (data === 'B') return '의료고도';
						        	if (data === 'C') return '의료중도';
						        	if (data === 'D') return '의료경도';
						        	if (data === 'E') return '선택입원';
						        }
						        return data;
						    }
					    },						
						{ data: 'pAdlScore', visible: true,  className: 'dt-body-center', width: '100px'  },
						{ data: 'pAdl10Val', visible: true, className: 'dt-body-center', width: '100px',
							render: function(data, type, row) {
						        // 화면 출력용(type === 'display')일 때만 텍스트를 변환
						        if (type === 'display') {
						        	if (data === '1') return '적용';
						            if (data === '0') return '';
						        }
						        return data;
						    },
						    createdCell: function(td, cellData) {
						    	if (cellData === '1') {
						    		td.style.color = 'red';
						            td.style.fontWeight = 'bold';
						        } 
						    }
					    },
						{ data: 'cPatClass', visible: true, className: 'dt-body-center', width: '100px',
							render: function(data, type, row) {
						        // 화면 출력용(type === 'display')일 때만 텍스트를 변환
						        if (type === 'display') {
						        	if (data === 'A') return '의료최고';
						        	if (data === 'B') return '의료고도';
						        	if (data === 'C') return '의료중도';
						        	if (data === 'D') return '의료경도';
						        	if (data === 'E') return '선택입원';
						        }
						        return data;
						    }
					    },
						{ data: 'cAdlScore', visible: true,  className: 'dt-body-center', width: '100px'  },
						{ data: 'improveYn', visible: true, className: 'dt-body-center', width: '100px',
							render: function(data, type, row) {
						        // 화면 출력용(type === 'display')일 때만 텍스트를 변환
						        if (type === 'display') {
						        	// 추가 20250619 아래 변경 (기존내용 막고 수정)  
						        	/*
						        	if (data === '1') return '개선';
						        	if (data === '2') return '제외';
						            if (data === '3') return '미개선';
						            */
						        	if (data === '1') return '개선';
						        	if (data === '2') return '악화';
						        	if (data === '3') return '제외';
						            if (data === '4') return '미개선';  
						            
						        }
						        return data;
						    },
						    createdCell: function(td, cellData) {
						    	if        (cellData === '1') {
						            td.style.color = 'green';
						        } else if (cellData === '2') {
						            td.style.color = 'red';
						        } else if (cellData === '3') {
						            td.style.color = 'gray';
						        } 
						    }
					    },
					    { data: 'nextTarget', visible: true, className: 'dt-body-center', width: '100px',
							render: function(data, type, row) {
						        // 화면 출력용(type === 'display')일 때만 텍스트를 변환
						        if (type === 'display') {
						        	if (data === 'Y') return '퇴원';
						            if (data === 'N') return '';
						        }
						        return data;
						    },
						    createdCell: function(td, cellData) {
						    	if (cellData === 'Y') {
						            td.style.color = 'red';
						            td.style.fontWeight = 'bold';
						        }
						    }
					    }
					 ];
		
		// 초기 data Sort,  없으면 []
		muiltSorts = [
		             	['improveYn', 'asc']  // 오름차순 정렬
	   		         ];
		// Sort여부 표시를 일부만 할 때 개별 id, ** 전체 적용은 '_all'하면 됩니다. ** 전체 적용 안함은 []        				 
		showSortNo = ['patId','patNm','admitDt','medStart','docDt','improveYn','nextTarget'];      
		// showSortNo = ['_all'];
		// Columns 숨김 columnsSet -> visible로 대체함 hideColums 보다 먼제 처리됨 ( visible를 선언하지 않으면 hideColums컬럼 적용됨 )	
		hideColums = [];             // 없으면 []; 일부 컬럼 숨길때		
		txt_Markln = 4;                       				 // 컬럼의 글자수가 설정값보다 크면, 다음은 ...로 표시함
		// 글자수 제한표시를 일부만 할 때 개별 id, ** 전체 적용은 '_all'하면 됩니다. ** 전체 적용 안함은 []
		markColums = ['patNm'];
    			
    } else if (data.cate_cd === "13") {
    	page_Hight = 690;
    	c_Head_Set = [  '','대상자','입원일','개시일','작성일','당뇨','Hba1c','전월상병','검사일','결과','당월','다음월'  ];
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
   						{ data: 'diabeYn',     visible: true,  className: 'dt-body-center', width: '100px', 
   							render: function(data, type, row) {
   			        			if (type === 'display') {
   			        				if (data === '1') return '●';
   			            		}
   			            		return data;
   			  			    },
   						},
   						{ data: 'hba1cYn',     visible: true,  className: 'dt-body-center', width: '100px', 
   							render: function(data, type, row) {
   			        			if (type === 'display') {
   			        				return data === '1' ? '●' : '';
   			            		}
   			            		return data;
   			  			    },
   						},
   						{ data: 'preDiag', visible: true,  className: 'dt-body-center', width: '50px'  },
   						{ data: 'examiDt', visible: true,  className: 'dt-body-center', width: '100px'  },
   						{ data: 'eResult', visible: true,  className: 'dt-body-center', width: '100px'  },
   						{ data: 'approYn', visible: true,  className: 'dt-body-center', width: '100px',
							render: function(data, type, row) {
						        // 화면 출력용(type === 'display')일 때만 텍스트를 변환
						        if (type === 'display') {
						        	if (data === 'X') return '제외';
						            if (['1','2','3'].includes(data)) return '초과';
						            if (data === '4') return '미만';
						            if (data === '5') return '누락';
						            if (data === '6') return '적정';
						            if (data === 'Y') return '확인';
						        }
						        return data;
						    },
						    createdCell: function(td, cellData) {
						    	if (['X','Y'].includes(cellData)) {
						            td.style.color = 'gray';
						        //    td.style.fontWeight = 'bold';
						        } else if (['1','2','3','4','5'].includes(cellData)) {
						            td.style.color = 'red';
						        //    td.style.fontWeight = 'bold';
						        } else if (cellData === '6') {
						            td.style.color = 'green';
						        //    td.style.fontWeight = 'bold';
						        }
						    }
					    },
					    { data: 'nextTarget', visible: true, className: 'dt-body-center', width: '100px',
							render: function(data, type, row) {
						        // 화면 출력용(type === 'display')일 때만 텍스트를 변환
						        if (type === 'display') {
						        	if (data === 'Y') return '퇴원';
						            if (data === 'N') return '';
						        }
						        return data;
						    },
						    createdCell: function(td, cellData) {
						    	if (cellData === 'Y') {
						            td.style.color = 'red';
						        //    td.style.fontWeight = 'bold';
						        }
						    }
					    }
       				 ];
       	
       	// 초기 data Sort,  없으면 []
       	muiltSorts = [
       		             ['diabeYn', 'desc'],  // 내림차순 정렬
       		             ['approYn', 'desc']
       		         ];  
       	// Sort여부 표시를 일부만 할 때 개별 id, ** 전체 적용은 '_all'하면 됩니다. ** 전체 적용 안함은 []        				 
       	showSortNo = ['patId','patNm','admitDt','medStart','docDt','diabeYn','approYn','examiDt','eResult'];
       	// showSortNo = ['_all'];
       	// Columns 숨김 columnsSet -> visible로 대체함 hideColums 보다 먼제 처리됨 ( visible를 선언하지 않으면 hideColums컬럼 적용됨 )	
       	hideColums = [];             // 없으면 []; 일부 컬럼 숨길때		
       	txt_Markln = 20;                       				 // 컬럼의 글자수가 설정값보다 크면, 다음은 ...로 표시함
       	// 글자수 제한표시를 일부만 할 때 개별 id, ** 전체 적용은 '_all'하면 됩니다. ** 전체 적용 안함은 []
       	markColums = [];	
    	
    } else if (data.cate_cd === "14") {
    	page_Hight = 690;
    	c_Head_Set = [  '생년월일','대상자','입원일자','요양개시일','평가표작성일','평가군','장기입원','제외대상'  ];
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
   						{ data: 'cPatClass', visible: true, className: 'dt-body-center', width: '100px',
							render: function(data, type, row) {
						        // 화면 출력용(type === 'display')일 때만 텍스트를 변환
						        if (type === 'display') {
						        	if (data === 'A') return '의료최고';
						        	if (data === 'B') return '의료고도';
						        	if (data === 'C') return '의료중도';
						        	if (data === 'D') return '의료경도';
						        	if (data === 'E') return '선택입원';
						        }
						        return data;
						    }
					    },
   						{ data: 'longAdm',     visible: true,  className: 'dt-body-center', width: '100px', 
   							render: function(data, type, row) {
   			        			if (type === 'display') {
   			        				if (data === 'Y') return '●';
   			            		}
   			            		return data;
   			  			    },
   						},
					    { data: 'approYn',     visible: true,  className: 'dt-body-center', width: '100px', 
   							render: function(data, type, row) {
   			        			if (type === 'display') {
   			        				if (data === 'Y') return '●';
   			            		}
   			            		return data;
   			  			    },
   						}
       				 ];
       	
       	// 초기 data Sort,  없으면 []
       	muiltSorts = [
		             	['longAdm', 'desc']  // 오름차순 정렬
	   		         ];
       	// Sort여부 표시를 일부만 할 때 개별 id, ** 전체 적용은 '_all'하면 됩니다. ** 전체 적용 안함은 []        				 
       	showSortNo = ['_all'];                   
       	// Columns 숨김 columnsSet -> visible로 대체함 hideColums 보다 먼제 처리됨 ( visible를 선언하지 않으면 hideColums컬럼 적용됨 )	
       	hideColums = [];             // 없으면 []; 일부 컬럼 숨길때		
       	txt_Markln = 20;                       				 // 컬럼의 글자수가 설정값보다 크면, 다음은 ...로 표시함
       	// 글자수 제한표시를 일부만 할 때 개별 id, ** 전체 적용은 '_all'하면 됩니다. ** 전체 적용 안함은 []
       	markColums = [];	
    	
    } 
	
	// 현재 상태 백업
	const bak_Table = dataTable;
	const set_Table = tableName.id;

	setTimeout(function() {
	    const newTable = document.getElementById('viewTable');
	    if (!newTable) { return; }

	    tableName = newTable; // tableName 업데이트
        
	    $('#' + tableName.id).DataTable().clear().destroy();
	    $('#' + tableName.id).empty();

	    fn_HeadColumnSet();
	    fn_FindDataTable();

	    tableName = document.getElementById(set_Table);
	    dataTable = bak_Table;
	    
	    
	}, 100);
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

        if (jobFlag === '00') {
            gridColums.push({
                data: null,
                orderable: false,
                searchable: false,
                className: 'dt-center',
                
                
                render: function(data, type, row) {
        			if (type === 'display') {
        				if (row.cate_cd === '99') { 
        					return '<button class="btn btn-outline-danger btn-xs showbtn">출력</button>';
        				} else if (["08","15","99"].includes(row.cate_cd)) {
        			        return '';
        			    } else {
        			    	return '<button class="btn btn-outline-info btn-xs showbtn">보기</button>';
        			    }
            		}
            		return data;
  			    }
            	/*
                render: function (data, type, row) {
                    return '<button class="btn btn-outline-info btn-xs showbtn">보기·<i class="fas fa-search"></i></button>';
                }
  			    */
            });
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

    tableName.style.display = 'inline-block';
}

function fn_FindDataTable() {
	(function($) {
		 dataTable = $('#' + tableName.id).DataTable({	
				language : {
					search: "&nbsp;자 료 검 색 : ",
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
	    	showIndiSummary(data);

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
		    if (edit_Data) { showIndiSummary(edit_Data); }
		    // 환자평가표 조회 버튼 활성/비활성 갱신 (우측 그리드일 때만)
		    if (typeof fn_UpdatePatvalBtnState === 'function' && tableName && tableName.id === 'viewTable') {
		        fn_UpdatePatvalBtnState(edit_Data);
		    }
		});
	    /* 싱글 선택 start */
	    if (row_Select) {
	        dataTable.on('click', 'tbody tr', (e) => {
		    	
	        	let classList = e.currentTarget.classList;
	        	
	        	if (!["01", "02", "03", "04"].includes(jobFlag)) {
	        		
	        		$('#viewTable tbody tr.selected').removeClass('selected');
	        		/*
	        		const viewTable = $('#viewTable').DataTable();
	        		$(viewTable.rows('.selected').nodes()).removeClass('selected');
	        		*/
	        	}
	        	
	            
	            if (!classList.contains('selected')) {
	                dataTable.rows('.selected').nodes().each((row) => {
	                    row.classList.remove('selected');
	                });
	                classList.add('selected');
	            }
	        	
	        	/*
	            let classList = e.currentTarget.classList;
		  	 
		  	    if (!classList.contains('selected')) {
		  	    	dataTable.rows('.selected').nodes().each((row) => row.classList.remove('selected'));
		  	        classList.add('selected');
		  	    }
		  	    */
		  	});

	    }

	    // viewTable이면 환자평가표 조회 버튼을 .dt-buttons 영역으로 이동
	    if (tableName && tableName.id === 'viewTable' && typeof fn_AttachPatvalBtnToDt === 'function') {
	        setTimeout(fn_AttachPatvalBtnToDt, 0);
	    } else {
	        // 좌측 indicator 그리드일 땐 숨김
	        var pb = document.getElementById('btnPatvalView');
	        if (pb) pb.style.display = 'none';
	    }

	})(jQuery);

}

//ajax 함수 정의
function dataLoad(data, callback, settings) {

	const ltxt = document.getElementById('lab_title');
    let lTitle = ltxt.textContent;
    
	//var table = $(settings.nTable).DataTable();
    //table.processing(true); // 처리 중 상태 시작
    
    if (jobFlag === "00") {
    
	    let selected_Year = document.getElementById("year_Select").value;
	    let selectedMonth = document.getElementById("monthSelect").value;
	    
	    $.ajax({
	    	url: "/main/select_Eval_Indi.do",
	        type: "POST",
	        data: { hosp_cd: hospid,
	     	        jobyymm: selected_Year + selectedMonth
	   		},
	        dataType: "json",
	        // timeout: 10000, // 10초 후 타임아웃
	        beforeSend : function () {
	        	
			},
	        success: function(response) {
	        	//table.processing(false); // 처리 중 상태 종료
	            if (response && Object.keys(response).length > 0) {
	            	
	            	let totScore = 0;
	                let strScore = 0;
	                let medScore = 0;
	
	                for (let i = 0; i < response.data.length; i++) {
	                	
	                    const item = response.data[i];
	                    
	                    if (item.cate_cd !== '99') {
	                    	totScore += item.weigval;
	                    }
	
	                    if (item.cate_fg === '10') {
	                        
	                    	if (item.cate_cd !== '99') {
	                    		strScore += item.weigval;
		                    }
	                        
	                    } else if (['21', '22'].includes(item.cate_fg)) {
	                        
	                        if (item.cate_cd !== '99') {
	                        	medScore += item.weigval;
		                    }   
	                    }
	                }
	
	                if (totScore > 0) {
	                    let tScore = document.getElementById("totalScore");
	                    let sScore = document.getElementById("structureScore");
	                    let mScore = document.getElementById("medicalScore");
	
	                    tScore.innerHTML = totScore.toFixed(2);
	                    sScore.innerHTML = strScore.toFixed(2);
	                    mScore.innerHTML = medScore.toFixed(2);
	                }
	            	
	            	
	            	callback(response);
	            	tableName.style.display = 'inline-block';
	            	
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
    } else {
    	$.ajax({
	    	url: "/main/select_CategoryList.do",
	        type: "POST",
	        data: { hospCd: hospid,
	     	        jobYymm: jobYyMm,
	     	        cateCd: jobFlag
	   		},
	        dataType: "json",
	        // timeout: 10000, // 10초 후 타임아웃
	        beforeSend : function () {
	        	if (jobFlag === '07') {
	        		Swal.fire({
	        			title: '<span style="font-size:17px;"><i class="fas fa-hourglass-half" style="color:#6c7bff; margin-right:8px;"></i>조회 중입니다</span>',
	        			html: '<div style="font-size:14px; color:#555;">향정신성의약품 처방은 데이터량에 따라<br>조회 속도가 다소 늦을 수 있습니다.<br><br>잠시만 기다려 주세요...</div>',
	        			allowOutsideClick: false,
	        			allowEscapeKey: false,
	        			showConfirmButton: false,
	        			showCancelButton: false,
	        			didOpen: function() {
	        				Swal.showLoading();
	        				var _ac = Swal.getActions();     if (_ac) _ac.style.display = 'none';
	        				var _ok = Swal.getConfirmButton(); if (_ok) _ok.style.display = 'none';
	        				var _cc = Swal.getCancelButton();  if (_cc) _cc.style.display = 'none';
	        			}
	        		});
	        	}
			},
	        success: function(response) {
	        	if (jobFlag === '07') { Swal.close(); }
	        	//table.processing(false); // 처리 중 상태 종료
	            if (response && Object.keys(response).length > 0) {
	            	
	            	function nbsp(n) {
	            	    return '&nbsp;'.repeat(n);
	            	}
	            	
	            	let cntNote = '';
	            	
	            	if (jobFlag === '05') {
	            		
	            		let hi_Count = 0;
		                let lowCount = 0;
		                let dayCount = 0;
		                for (let i = 0; i < response.data.length; i++) {

		                	const item = response.data[i];

		                    if (item.overDay === 'Y') {
		                    	dayCount += 1;
		                    	if (item.dangerHi  === 'Y') { hi_Count += 1; }
			                    if (item.dangerLow === 'Y') { lowCount += 1; }
		                    }
		                }

		                cntNote = '[중복포함,14일초과 총:' + dayCount + '건 ]·고위험:' + hi_Count + '건·저위험:' + lowCount + '건';

		                document.getElementById("lab_title").innerHTML = lTitle + nbsp(35) + '<span style="color: blue;">' + cntNote + '</span>';

		                // 상단 버튼 영역 초기화
		                _prevMissingData = [];
		                _errCheckData = [];
		                fn_UpdateCath05Buttons();
		                var cath05BtnZone = document.getElementById('cath05BtnZone');
		                if (cath05BtnZone) cath05BtnZone.style.display = 'inline-block';

		                // 전월에 있었는데 당월에 빠진 환자 데이터 조회 (상단 버튼/모달용)
		                $.ajax({
		                    url: "/main/select_PrevMonthMissing05.do",
		                    type: "POST",
		                    data: { hospCd: hospid, jobYymm: jobYyMm },
		                    dataType: "json",
		                    success: function(res) {
		                        _prevMissingData = (res && res.data) ? res.data : [];
		                        fn_UpdateCath05Buttons();
		                    }
		                });

		                // 평가표 오류점검 (D1/D2/E1/F1/G1/G2/H1) + 오더↔평가표 크로스체크 (X1/X2/X3) 병렬 조회
		                var _tmpPatvalErr = null;
		                var _tmpCrossErr  = null;
		                function _mergeCathErrors() {
		                    if (_tmpPatvalErr === null || _tmpCrossErr === null) return;  // 둘 다 도착 대기
		                    _errCheckData = _tmpPatvalErr.concat(_tmpCrossErr);
		                    fn_UpdateCath05Buttons();
		                }

		                // (A) 평가표 오류점검
		                $.ajax({
		                    url: "/main/select_assesCheck.do",
		                    type: "POST",
		                    data: { hospCd: hospid, jobYymm: jobYyMm, jobFlag: '00' },
		                    dataType: "json",
		                    success: function(res) {
		                        if (!res || !res.data) { _tmpPatvalErr = []; _mergeCathErrors(); return; }
		                        // 기존 평가표 자체 오류 (D/E/F/G/H)
		                        // A4: 입원평가 + 당월 입원환자 아님 / A5: 입원평가 중복
		                        var cathErr = ['A4','A5','D1','D2','E1','F1','G1','G2','H1'];
		                        var errors = [];
		                        for (var e = 0; e < res.data.length; e++) {
		                            if (cathErr.includes(res.data[e].errType)) {
		                                errors.push(res.data[e]);
		                            }
		                        }
		                        _tmpPatvalErr = errors;
		                        _mergeCathErrors();
		                    },
		                    error: function() { _tmpPatvalErr = []; _mergeCathErrors(); }
		                });

		                // (B) 오더(TBL_SPCSUGA_INFO) ↔ 평가표(TBL_PATVAL_MST) 유치도뇨관 크로스체크
		                $.ajax({
		                    url: "/main/select_CathCrossCheck.do",
		                    type: "POST",
		                    data: { hospCd: hospid, jobYymm: jobYyMm },
		                    dataType: "json",
		                    success: function(res) {
		                        _tmpCrossErr = (res && res.data) ? res.data : [];
		                        _mergeCathErrors();
		                    },
		                    error: function() { _tmpCrossErr = []; _mergeCathErrors(); }
		                });

	            	} else if (jobFlag === '07') {

	            	    let psyCount = 0;

	            	    for (let i = 0; i < response.data.length; i++) {
	            	        const item = response.data[i];

	            	        if (item.psyOrderYn === '●') {
	            	            psyCount += 1;
	            	        }
	            	    }

	            	    cntNote = '[중복포함,항정신성의약품 처방 대상자:' + psyCount + '건 ]';

	            	    document.getElementById("lab_title").innerHTML = lTitle + nbsp(60) + '<span style="color: blue;">' + cntNote + '</span>';
	            	
	            	} else if (jobFlag === '09') {
	            		
	            		let yesCount = 0;
		                let next_Cnt = 0;
		                
		                for (let i = 0; i < response.data.length; i++) {
		                    
		                	const item = response.data[i];
		                	
		                    if (item.dressingYn === '1') {
		                    	yesCount += 1;
		                    }
		                    if (item.nextTarget === 'Y') {
		                    	next_Cnt += 1;
		                    }
		                }
		                
		                cntNote = '[중복포함, 처치 총:' + yesCount + '건 ]·다음월:' + next_Cnt + '건';
		                
		                document.getElementById("lab_title").innerHTML = lTitle + nbsp(60) + '<span style="color: blue;">' + cntNote + '</span>';
	            	
	            	} else if (jobFlag === '10') {
	            		
	            		let impCount = 0;
		                
		                for (let i = 0; i < response.data.length; i++) {
		                    
		                	const item = response.data[i];
		                	
		                    if (item.improveYn === '1') {
		                    	impCount += 1;
		                    }
		                }
		                
		                cntNote = '[중복포함,당원발생 총:' + impCount + '건]';
		                
		                document.getElementById("lab_title").innerHTML = lTitle + nbsp(80) + '<span style="color: blue;">' + cntNote + '</span>';
	            	
	            	} else if (jobFlag === '11') {
	            		
	            		let impCount = 0;
		                let next_Cnt = 0;
		                
		                for (let i = 0; i < response.data.length; i++) {
		                    
		                	const item = response.data[i];
		                	
		                    if (item.improveYn === '1') {
		                    	impCount += 1;
		                    }
		                    if (item.nextTarget === 'Y') {
		                    	next_Cnt += 1;
		                    }
		                }
		                
		                cntNote = '[중복포함,개선 총:' + impCount + '건]·다음월:' + next_Cnt + '건';
		                
		                document.getElementById("lab_title").innerHTML = lTitle + nbsp(75) + '<span style="color: blue;">' + cntNote + '</span>';
	            	
	            	} else if (jobFlag === '12') {
	            		
	            		let impCount = 0;
		                let next_Cnt = 0;
		                
		                for (let i = 0; i < response.data.length; i++) {
		                    
		                	const item = response.data[i];
		                	
		                    if (item.improveYn === '1') {
		                    	impCount += 1;
		                    }
		                    if (item.nextTarget != 'Y') {
		                    	next_Cnt += 1;
		                    }
		                }
		                
		                cntNote = '[중복포함,당월개선 총:' + impCount + '건 ]·다음월:' + next_Cnt + '건';
		                
		                document.getElementById("lab_title").innerHTML = lTitle + nbsp(65) + '<span style="color: blue;">' + cntNote + '</span>';
	            	
	            	} else if (jobFlag === '13') {
	            		
	            		let diab_Cnt = 0;
	            		let appr_Cnt = 0;
	            		let next_Cnt = 0;
		                
		                for (let i = 0; i < response.data.length; i++) {
		                    
		                	const item = response.data[i];
		                	
		                    if (item.diabeYn === '1') {
		                    	diab_Cnt += 1;
		                    	if (item.nextTarget != 'Y') {
			                    	next_Cnt += 1;
			                    }
		                    }
		                    if (item.approYn === '5') {
		                    	appr_Cnt += 1;
		                    }
		                    
		                }
		                
		                cntNote = '[중복포함,당뇨 총:' + diab_Cnt + '건 ]·적정:' + appr_Cnt + '건·다음월:' + next_Cnt + '건';
		                
		                document.getElementById("lab_title").innerHTML = lTitle + nbsp(10) + '<span style="color: blue;">' + cntNote + '</span>';
	            	
	            	} else if (jobFlag === '14') {
	            		
	            		let long_Cnt = 0;
	            		let next_Cnt = 0;
		                
		                for (let i = 0; i < response.data.length; i++) {
		                    
		                	const item = response.data[i];
		                	
		                    if (item.longAdm === 'Y') {
		                    	long_Cnt += 1;
		                    }
		                    if (item.nextTarget === 'Y') {
		                    	next_Cnt += 1;
		                    }
		                }
		                
		                cntNote = '[중복포함,181일 총:' + long_Cnt + '건 ]·제외대상:' + next_Cnt + '건';
		                
		                document.getElementById("lab_title").innerHTML = lTitle + nbsp(65) + '<span style="color: blue;">' + cntNote + '</span>';
	            	
	            	}

	            	callback(response);
	            	tableName.style.display = 'inline-block';
	            	
	            } else {
	            	
	            	callback([]); // 빈 배열을 콜백으로 전달
	            }
	        },
	        error: function(jqXHR, textStatus, errorThrown) {
	        	if (jobFlag === '07') { Swal.close(); }
	        	//table.processing(false); // 처리 중 상태 종료
	            callback({
	                data: []
	            });
	            //table.clear().draw(); // 테이블 초기화 및 다시 그리기
	        }
	    });
    }

}


// =====================================================================
// 환자평가표(TBL_PATVAL_MST) 조회 모달 (조회전용)
//   - 우측 그리드(viewTable) 행 선택 시 상단 버튼 활성화
//   - cath05 오류점검 데이터(_errCheckData)와 매칭되는 항목은 상단 배지로 강조
// =====================================================================

function _pvIsEmpty(v) { return v === null || v === undefined || v === ''; }
function _pvEmptyMark() { return '<span class="pv-empty" style="color:#b0b6bf;">-</span>'; }

// 서버 응답 키가 UPPERCASE(AUTH_DOC) 또는 snake(auth_doc)로 와도 카멜(authDoc)로 접근 가능하게 정규화
function _pvNormalizeKeys(src) {
    if (!src || typeof src !== 'object') return src;
    var out = {};
    for (var k in src) {
        if (!src.hasOwnProperty(k)) continue;
        out[k] = src[k];
        // snake_case/UPPER_SNAKE → camelCase 보조키 추가
        if (k.indexOf('_') >= 0) {
            var camel = k.toLowerCase().replace(/_([a-z0-9])/g, function(_, c) { return c.toUpperCase(); });
            if (!(camel in out)) out[camel] = src[k];
        } else if (k === k.toUpperCase() && k !== k.toLowerCase()) {
            // 전부 대문자인 경우 소문자 키도 만들어 둠
            var lower = k.toLowerCase();
            if (!(lower in out)) out[lower] = src[k];
        }
    }
    return out;
}

function _pvYn(v) {
    if (_pvIsEmpty(v)) return _pvEmptyMark();
    if (v === '1' || v === 'Y') return '<span style="color:#28a745;font-weight:700;">✓</span>';
    if (v === '0' || v === 'N') return '<span style="color:#6c757d;">−</span>';
    return _pvTxt(v);
}

// 명세서서식(2024.7.1.~) 기준 코드표 — 값이 여러 개인 필드의 의미를 콤보식으로 표시
var _PV_CODES = {
    evalType: {
        '1':'입원 평가', '2':'계속 입원 중인 환자 평가', '3':'이전 환자평가표를 적용하는 경우'
    },
    lastPlace: {
        '1':'집에 거주(서비스 받음)', '2':'집에 거주(서비스 안받음)', '3':'요양시설/그룹홈',
        '4':'급성기병원', '5':'요양병원', '6':'정신병원/정신시설', '7':'기타'
    },
    eduLevel: {
        '1':'무학', '2':'초졸(퇴)', '3':'중졸(퇴)', '4':'고졸(퇴)', '5':'대졸(퇴) 이상', '6':'확인 불가'
    },
    ltcareGrdReq: {
        '1':'해당사항 없음', '2':'미신청', '3':'신청 중', '4':'신청하였으나 인정 못 받음',
        '5':'등급 내 자', '6':'등급 외 자'
    },
    ltcareGrade: {
        '1':'1등급', '2':'2등급', '3':'3등급', '4':'4~5등급', '5':'인지지원등급', '6':'확인 불가'
    },
    delirium: {
        '0':'없음', '1':'증상 있으나 7일 이전 발생', '2':'증상 있으며 7일 이내 발생/악화'
    },
    shortMem: { '0':'정상', '1':'이상 있음', '2':'확인 불가' },
    perception: {
        '0':'합리적 의사결정', '1':'새로운 상황만 어려움', '2':'다소 손상', '3':'심하게 손상'
    },
    comprehen: {
        '0':'이해시킴', '1':'대부분 이해시킴', '2':'가끔 이해시킴', '3':'거의/전혀 이해시키지 못함'
    },
    // BPSD 빈도 (delusion~wander) : 0 없음, 1 가끔, 2 자주, 3 매우 자주
    bpsd: { '0':'없음', '1':'가끔', '2':'자주', '3':'매우 자주' },
    // ADL (dressing~toiletUse) : 0 완전자립 … 8 행위 발생안함
    adl: {
        '0':'완전자립', '1':'감독필요', '2':'약간의 도움', '3':'상당한 도움', '4':'전적인 도움', '8':'행위 발생안함'
    },
    bowelCtl: { '0':'조절할 수 있음', '1':'가끔 실금함', '2':'자주 실금함', '3':'조절 못함' },
    urineCtl: { '0':'조절할 수 있음', '1':'가끔 실금함', '2':'자주 실금함', '3':'조절 못함' },
    painFreq: { '0':'통증 없음', '1':'통증 있으나 매일은 아님', '2':'매일 통증 있음' },
    fall: { '0':'아니오', '1':'예', '2':'확인 불가' },
    weigLoss: { '0':'아니오', '1':'예', '2':'확인 불가' },
    newUlcer: { '0':'없음', '1':'있음' },
    pastUlcer: { '0':'없음', '1':'있음', '2':'확인 불가' },
    insulin: {
        '0':'투여되지 않았거나 매일은 아님', '1':'매일 1회 투여됨', '2':'매일 2회 이상 투여됨'
    },
    medCount: {
        '0':'없음', '1':'5개 미만', '2':'5개 ~ 9개', '3':'10개 ~ 14개', '4':'15개 이상'
    },
    calories: {
        '0':'없음', '1':'1~25%', '2':'26~50%', '3':'51~75%', '4':'76~100%'
    },
    waterAmt: {
        '0':'없음', '1':'1~500㎖', '2':'501~1000㎖', '3':'1001~1500㎖', '4':'1501~2000㎖', '5':'2001㎖ 이상'
    }
};

// 코드값 → "코드 : 설명" 형태로 렌더 (매핑 없으면 _pvTxt 로 fallback)
function _pvCd(codeGroup, v) {
    if (_pvIsEmpty(v)) return _pvEmptyMark();
    var map = _PV_CODES[codeGroup];
    var desc = map ? map[String(v)] : null;
    if (!desc) return _pvTxt(v);
    var vHtml  = $('<div>').text(v).html();
    var dHtml  = $('<div>').text(desc).html();
    return '<span class="pv-cd"><span class="pv-cd-k">' + vHtml + '</span><span class="pv-cd-v">' + dHtml + '</span></span>';
}
function _pvTxt(v) {
    if (_pvIsEmpty(v)) return _pvEmptyMark();
    return $('<div>').text(v).html();
}
function _pvDt(v) {
    if (_pvIsEmpty(v)) return _pvEmptyMark();
    var s = String(v).replace(/[^0-9]/g,'');
    if (s.length === 8) return s.substr(0,4) + '-' + s.substr(4,2) + '-' + s.substr(6,2);
    return _pvTxt(v);
}

function fn_UpdatePatvalBtnState(row) {
    // 시각 피드백만 — 선택 없을 때 grayscale 처리
    var btn = document.getElementById('btnPatvalView');
    if (!btn) return;
    var ok = !!(row && row.patId && row.admitDt && row.medStart);
    if (ok) btn.classList.remove('is-disabled');
    else    btn.classList.add('is-disabled');
}

// viewTable .dt-buttons 영역으로 버튼 이동 (DataTable 초기화 후 호출)
//   DataTable destroy → 재초기화 시 .dt-buttons 컨테이너가 교체되어 버튼도 함께 사라지므로,
//   버튼 DOM이 없는 경우 동적으로 재생성한 뒤 부착한다.
//   cath05BtnZone(유치도뇨관 및 오류점검)도 동일 라인으로 이동.
function fn_AttachPatvalBtnToDt() {
    var $dtBtns = $('#viewTable_wrapper .dt-buttons');
    if ($dtBtns.length === 0) return;

    // (1) 환자평가표 조회 버튼 — 활성화 (DataTable 버튼 영역으로 이동 + _show 클래스 부여)
    var pvBtn = document.getElementById('btnPatvalView');
    if (!pvBtn) {
        pvBtn = document.createElement('button');
        pvBtn.id = 'btnPatvalView';
        pvBtn.type = 'button';
        pvBtn.className = 'patval-btn _show';
        pvBtn.onclick = function() { fn_ShowPatvalModal(); };
        pvBtn.innerHTML = '<i class="fas fa-clipboard-list patval-icon"></i><span class="patval-label">환자평가표&nbsp;조회</span>';
    }
    if (pvBtn.parentNode !== $dtBtns[0]) {
        $dtBtns.append(pvBtn);
        pvBtn.style.marginLeft = '6px';
    }
    pvBtn.classList.add('_show');

    // (2) 유치도뇨관 및 오류점검 버튼 — 05 카테고리에서만 .dt-buttons 영역으로 이동
    //     DataTable destroy 로 DOM이 사라진 경우 재생성한다.
    var cathZone = document.getElementById('cath05BtnZone');
    if (!cathZone) {
        cathZone = document.createElement('div');
        cathZone.id = 'cath05BtnZone';
        cathZone.style.whiteSpace = 'nowrap';
        cathZone.innerHTML =
            '<button type="button" id="btnCath05Check" class="cath05-btn">' +
                '<i class="fas fa-stethoscope cath05-icon"></i>' +
                '<span class="cath05-label">유치도뇨관&nbsp;&nbsp;및 오류점검</span>' +
                '<span class="cath05-badge" id="badgeCath05">0</span>' +
            '</button>';
        var _innerBtn = cathZone.querySelector('#btnCath05Check');
        if (_innerBtn) _innerBtn.onclick = function() { fn_ShowCath05Modal(); };
    }
    if (jobFlag === '05') {
        if (cathZone.parentNode !== $dtBtns[0]) {
            $dtBtns.append(cathZone);
            cathZone.style.marginLeft = '6px';
        }
        cathZone.style.display = 'inline-block';
    } else {
        cathZone.style.display = 'none';
    }
    if (typeof fn_UpdateCath05Buttons === 'function') fn_UpdateCath05Buttons();

    /* (3) 다빈도 상병순위별 버튼 — 07 카테고리에서만 자료검색(.dataTables_filter) 뒤쪽(우측 끝)으로 부착
           (향후 환자평가표 조회 버튼도 같은 우측 영역에 부착 예정) */
    var diagZone = document.getElementById('diagRank07BtnZone');
    if (!diagZone) {
        diagZone = document.createElement('div');
        diagZone.id = 'diagRank07BtnZone';
        diagZone.style.whiteSpace = 'nowrap';
        diagZone.style.display = 'inline-block';
        diagZone.innerHTML =
            '<button type="button" id="btnDiagRank07" class="cath05-btn">' +
                '<i class="fas fa-notes-medical cath05-icon"></i>' +
                '<span class="cath05-label">다빈도&nbsp;상병순위별</span>' +
            '</button>';
        var _dBtn = diagZone.querySelector('#btnDiagRank07');
        if (_dBtn) _dBtn.onclick = function() { fn_ShowDiagRank07Modal(); };
    }
    if (jobFlag === '07') {
        /* .dataTables_filter 의 형제(sibling)로 바로 뒤에 붙여 자료검색 입력 우측 끝에 표시 */
        var $filter = $('#viewTable_wrapper .dataTables_filter');
        if ($filter.length > 0) {
            $filter.after(diagZone);
        } else if ($dtBtns.length > 0) {
            $dtBtns.append(diagZone);
        }
        diagZone.style.cssText =
            'display:inline-block; white-space:nowrap;' +
            ' float:right; margin-left:10px; vertical-align:middle;';
    } else {
        diagZone.style.display = 'none';
    }
}

// 현재 viewTable에서 선택된 행 데이터 반환 (edit_Data가 비어도 .selected 행에서 복구)
function _pvGetSelectedRow() {
    try {
        var dt = $('#viewTable').DataTable();
        var sel = dt.row('.selected');
        if (sel && sel.data()) return sel.data();
    } catch (e) {}
    if (typeof edit_Data !== 'undefined' && edit_Data && edit_Data.patId) return edit_Data;
    return null;
}

function _pvErrorBadges(patId) {
    try {
        if (!patId || typeof _errCheckData === 'undefined' || !_errCheckData || _errCheckData.length === 0) return '';
        var hits = [];
        for (var i = 0; i < _errCheckData.length; i++) {
            if (_errCheckData[i].patId === patId) hits.push(_errCheckData[i]);
        }
        if (hits.length === 0) return '';
        var html = '<div class="pv-err-zone"><div class="pv-err-title"><i class="fas fa-exclamation-triangle"></i>&nbsp;평가표 오류점검 매칭 (' + hits.length + '건)</div><div class="pv-err-list">';
        for (var j = 0; j < hits.length; j++) {
            html += '<span class="pv-err-chip">[' + (hits[j].errType || '') + '] ' + $('<div>').text(hits[j].errName || '').html() + '</span>';
        }
        html += '</div></div>';
        return html;
    } catch (ex) { return ''; }
}

function fn_ShowPatvalModal() {
    var row = _pvGetSelectedRow();
    if (!row || !row.patId || !row.admitDt || !row.medStart) {
        Swal.fire({ icon: 'info', title: '환자 선택 필요', text: '우측 목록에서 환자(행)를 먼저 선택해 주세요.', timer: 1800, showConfirmButton: false });
        return;
    }
    if (!document.getElementById('patvalModalStyle')) {
        var st = document.createElement('style');
        st.id = 'patvalModalStyle';
        st.innerHTML =
            '.pv-head { display:flex; flex-wrap:wrap; gap:14px 24px; padding:14px 18px; margin-bottom:12px; border-radius:8px;' +
            '  background:linear-gradient(135deg,#1e3c72 0%,#2a5298 100%); color:#fff; box-shadow:0 3px 10px rgba(30,60,114,0.25); }' +
            '.pv-head-item { font-size:13px; line-height:1.5; display:flex; align-items:center; gap:8px; }' +
            '.pv-head-item .lbl { opacity:0.8; font-size:11.5px; letter-spacing:0.3px; text-transform:uppercase; }' +
            '.pv-head-item .val { font-weight:600; font-size:13.5px; background:rgba(255,255,255,0.15); padding:3px 10px; border-radius:4px; font-family:Consolas,monospace; }' +
            '.pv-tabs { display:flex; border-bottom:2px solid #e4e7ed; margin-bottom:14px; gap:2px; flex-wrap:wrap; }' +
            '.pv-tab  { cursor:pointer; padding:10px 18px; font-size:13px; font-weight:600; color:#6b7280; background:transparent;' +
            '  border:none; border-bottom:3px solid transparent; transition:all 0.18s ease; border-radius:4px 4px 0 0; }' +
            '.pv-tab:hover { color:#2a5298; background:#f5f8fc; }' +
            '.pv-tab.active { color:#1e3c72; border-bottom-color:#2a5298; background:#f5f8fc; }' +
            '.pv-pane { display:none; padding:0 4px; }' +
            '.pv-pane.active { display:block; animation:pvFadeIn 0.18s ease; }' +
            '@keyframes pvFadeIn { from { opacity:0; transform:translateY(4px);} to { opacity:1; transform:none;} }' +
            '.pv-sec { margin-bottom:18px; border:1px solid #e4e7ed; border-radius:8px; overflow:hidden; }' +
            '.pv-sec-hd { padding:9px 14px; background:linear-gradient(135deg,#f7f9fc 0%,#eef2f7 100%); font-size:13px; font-weight:700; color:#2c3e50; border-bottom:1px solid #e4e7ed;' +
            '  display:flex; align-items:center; gap:6px; }' +
            '.pv-sec-hd i { color:#2a5298; font-size:12px; }' +
            '.pv-grid { display:grid; grid-template-columns:repeat(auto-fill,minmax(240px,1fr)); gap:0; }' +
            '.pv-cell { display:flex; align-items:center; padding:8px 12px; border-bottom:1px solid #f0f2f6; border-right:1px solid #f0f2f6; font-size:12.5px; min-height:34px; }' +
            '.pv-cell .k { flex:0 0 48%; color:#1e3c72; font-weight:500; letter-spacing:0.1px; }' +
            '.pv-cell .v { flex:1; color:#2c3e50; font-weight:500; text-align:right; padding-left:6px; word-break:break-all; font-family:Consolas,"맑은 고딕",sans-serif; }' +
            '.pv-cath-tbl { width:100%; border-collapse:collapse; font-size:12.5px; }' +
            '.pv-cath-tbl th, .pv-cath-tbl td { border:1px solid #e4e7ed; padding:6px 10px; text-align:center; }' +
            '.pv-cath-tbl thead th { background:linear-gradient(135deg,#2a5298,#1e3c72); color:#fff; font-weight:600; }' +
            '.pv-cath-tbl tbody td.dt { font-family:Consolas,monospace; color:#2c3e50; }' +
            '.pv-cath-tbl tbody tr:hover { background:#f0f7ff; }' +
            '.pv-err-zone { margin-bottom:14px; padding:12px 14px; border-radius:8px; background:#fff4f4; border:1px solid #f8c4c4; }' +
            '.pv-err-title { font-size:13px; font-weight:700; color:#c53030; margin-bottom:6px; }' +
            '.pv-err-list  { display:flex; flex-wrap:wrap; gap:6px; }' +
            '.pv-err-chip  { display:inline-block; padding:3px 10px; background:#fff; border:1px solid #f8c4c4; border-radius:14px; font-size:12px; color:#c53030; font-weight:600; }' +
            '.pv-cd { display:inline-flex; align-items:center; gap:6px; }' +
            '.pv-cd-k { display:inline-block; min-width:20px; padding:1px 7px; border-radius:3px; background:#eef3fb; color:#1e3c72; font-weight:700; font-family:Consolas,monospace; font-size:12px; text-align:center; }' +
            '.pv-cd-v { color:#2c3e50; font-weight:500; font-size:12.5px; }';
        document.head.appendChild(st);
    }

    var loadingHtml = '<div style="padding:40px 0; text-align:center; color:#6b7280;"><i class="fas fa-spinner fa-spin" style="font-size:22px;"></i><div style="margin-top:8px;">불러오는 중...</div></div>';

    Swal.fire({
        title: '<span style="font-size:17px;"><i class="fas fa-clipboard-list" style="color:#2a5298;margin-right:8px;"></i>환자평가표 조회</span>',
        html: loadingHtml,
        width: '1180px',
        showCloseButton: true,
        showConfirmButton: false,
        didOpen: function() {
            $.ajax({
                url: "/main/select_PatvalMst.do",
                type: "POST",
                data: {
                    hospCd:   hospid,
                    patId:    row.patId,
                    admitDt:  row.admitDt,
                    medStart: row.medStart
                },
                dataType: "json",
                success: function(res) {
                    var d = (res && res.data) ? res.data : null;
                    d = _pvNormalizeKeys(d);
                    Swal.update({ html: _pvBuildHtml(d, row) });
                    _pvBindTabs();
                },
                error: function() {
                    Swal.update({ html: '<div style="padding:30px;text-align:center;color:#c53030;">데이터를 불러오지 못했습니다.</div>' });
                }
            });
        }
    });
}

function _pvBindTabs() {
    $('.pv-tab').off('click.pv').on('click.pv', function() {
        var tgt = $(this).data('tab');
        $('.pv-tab').removeClass('active');
        $(this).addClass('active');
        $('.pv-pane').removeClass('active');
        $('.pv-pane[data-tab="' + tgt + '"]').addClass('active');
    });
}

function _pvBuildHtml(d, row) {
    d = d || {};
    var header = '' +
        '<div class="pv-head">' +
        '  <div class="pv-head-item"><span class="lbl">환자ID</span><span class="val">' + _pvTxt(d.patId || row.patId) + '</span></div>' +
        '  <div class="pv-head-item"><span class="lbl">성명</span><span class="val">' + _pvTxt(d.patNm || row.patNm) + '</span></div>' +
        '  <div class="pv-head-item"><span class="lbl">입원일</span><span class="val">' + _pvDt(d.admitDt || row.admitDt) + '</span></div>' +
        '  <div class="pv-head-item"><span class="lbl">요양개시일</span><span class="val">' + _pvDt(d.medStart || row.medStart) + '</span></div>' +
        '  <div class="pv-head-item"><span class="lbl">작성일</span><span class="val">' + _pvDt(d.docDt) + '</span></div>' +
        '  <div class="pv-head-item"><span class="lbl">평가구분</span><span class="val">' + (d.evalType ? $('<div>').text(d.evalType + (_PV_CODES.evalType[d.evalType] ? ' · ' + _PV_CODES.evalType[d.evalType] : '')).html() : '-') + '</span></div>' +
        '  <div class="pv-head-item"><span class="lbl">서식버전</span><span class="val">' + _pvTxt(d.clformVer) + '</span></div>' +
        '  <div class="pv-head-item"><span class="lbl">환자분류군</span><span class="val">' + _pvTxt(d.patClass) + '</span></div>' +
        '</div>';

    if (!d || !d.patId) {
        return header + '<div style="padding:30px 10px;text-align:center;color:#8891a3;">TBL_PATVAL_MST 데이터가 없습니다.</div>';
    }

    var errBadges = _pvErrorBadges(d.patId || row.patId);

    var tabs =
        '<div class="pv-tabs">' +
        '  <button class="pv-tab active" data-tab="t1">A. 일반사항</button>' +
        '  <button class="pv-tab"        data-tab="t2">B·C·D. 의식/인지/신체</button>' +
        '  <button class="pv-tab"        data-tab="t3">E·F. 배설/질병진단</button>' +
        '  <button class="pv-tab"        data-tab="t4">G·H·I. 건강/영양/피부</button>' +
        '  <button class="pv-tab"        data-tab="t5">J·K·L. 투약/특수처치/작성자</button>' +
        '</div>';

    return '<div style="text-align:left; max-height:70vh; overflow:auto; padding:2px 4px;">' +
           header + errBadges + tabs +
           _pvTab1(d) + _pvTab2(d) + _pvTab3(d) + _pvTab4(d) + _pvTab5(d) +
           '</div>';
}

function _pvSec(title, icon, items) {
    var cells = '';
    for (var i = 0; i < items.length; i++) {
        var vHtml = items[i][1];
        cells += '<div class="pv-cell"><span class="k">' + items[i][0] + '</span><span class="v">' + vHtml + '</span></div>';
    }
    return '<div class="pv-sec"><div class="pv-sec-hd"><i class="fas ' + (icon || 'fa-circle') + '"></i>' + title + '</div><div class="pv-grid">' + cells + '</div></div>';
}

function _pvTab1(d) {
    var s1 = _pvSec('A. 일반사항', 'fa-user', [
        ['환자성명', _pvTxt(d.patNm)], ['주민등록번호', _pvTxt(d.patId)],
        ['입원일', _pvDt(d.admitDt)], ['요양개시일', _pvDt(d.medStart)],
        ['평가구분', _pvCd('evalType', d.evalType)], ['작성일', _pvDt(d.docDt)],
        ['입원 직전 있던 곳', _pvCd('lastPlace', d.lastPlace)], ['교육수준', _pvCd('eduLevel', d.eduLevel)]
    ]);
    var s2 = _pvSec('건강생활습관 / 혈압', 'fa-heartbeat', [
        ['수축기혈압', _pvTxt(d.sbp)], ['이완기혈압', _pvTxt(d.dbp)],
        ['담배', _pvYn(d.tobacco)], ['술', _pvYn(d.alcohol)],
        ['운동', _pvYn(d.exercise)], ['식사', _pvYn(d.diet)]
    ]);
    var s3 = _pvSec('장기요양등급 및 이용 서비스', 'fa-hands-helping', [
        ['장기요양등급 및 신청', _pvCd('ltcareGrdReq', d.ltcareGrdReq)], ['등급', _pvCd('ltcareGrade', d.ltcareGrade)],
        ['주·야간보호', _pvYn(d.wkdayCare)], ['방문요양', _pvYn(d.visitCare)],
        ['방문간호', _pvYn(d.visitNurse)], ['방문목욕', _pvYn(d.visitBath)],
        ['단기보호', _pvYn(d.shortStay)], ['복지용구 구입 및 대여', _pvYn(d.aidEquip)],
        ['시설입소', _pvYn(d.facStay)], ['기타', _pvYn(d.othService)],
        ['장기요양서비스 이용 의향', _pvYn(d.ltcareInt)]
    ]);
    var s4 = _pvSec('사회환경 선별 조사', 'fa-home', [
        ['응답거부', _pvYn(d.refResp)], ['식사준비, 간병 등', _pvYn(d.mealCare)],
        ['전기·수도 등', _pvYn(d.utilities)], ['거주지', _pvYn(d.residence)],
        ['병원비, 주거비 등', _pvYn(d.medHousing)], ['교통수단', _pvYn(d.transMthd)],
        ['긴급도움', _pvYn(d.emerHelp)]
    ]);
    return '<div class="pv-pane active" data-tab="t1">' + s1 + s2 + s3 + s4 + '</div>';
}

function _pvTab2(d) {
    var s1 = _pvSec('B. 의식상태 / C. 인지기능', 'fa-brain', [
        ['혼수', _pvYn(d.coma)], ['섬망', _pvCd('delirium', d.delirium)],
        ['단기기억력', _pvCd('shortMem', d.shortMem)], ['인식기술', _pvCd('perception', d.perception)],
        ['이해시키는 능력', _pvCd('comprehen', d.comprehen)], ['의사표현', _pvYn(d.express)]
    ]);
    var s2 = _pvSec('행동심리증상의 빈도 (0 없음·1 가끔·2 자주·3 매우 자주)', 'fa-comment-medical', [
        ['망상', _pvCd('bpsd', d.delusion)], ['환각', _pvCd('bpsd', d.hallucin)],
        ['초조/공격성', _pvCd('bpsd', d.agitation)], ['우울/낙담', _pvCd('bpsd', d.depress)],
        ['불안', _pvCd('bpsd', d.anxiety)], ['들뜬 기분/다행감', _pvCd('bpsd', d.euphoria)],
        ['무감동/무관심', _pvCd('bpsd', d.apathy)], ['탈억제', _pvCd('bpsd', d.disinhib)],
        ['과민/불안정', _pvCd('bpsd', d.irritable)], ['이상 운동증상 또는 반복적 행동', _pvCd('bpsd', d.dyskinesia)],
        ['수면/야간행동', _pvCd('bpsd', d.sleepBehav)], ['식욕/식습관의 변화', _pvCd('bpsd', d.appetite)],
        ['케어에 대한 저항', _pvCd('bpsd', d.careResist)], ['배회', _pvCd('bpsd', d.wander)]
    ]);
    var s3 = _pvSec('K-MMSE(또는 MMSE-K) / 치매 척도 검사 (CDR · GDS)', 'fa-notes-medical', [
        ['K-MMSE 실시여부', _pvYn(d.mmseYn)], ['K-MMSE 점수', _pvTxt(d.mmseScore)], ['K-MMSE 검사일', _pvDt(d.mmseDt)],
        ['CDR 실시여부', _pvYn(d.cdrYn)],   ['CDR 점수',   _pvTxt(d.cdrScore)],  ['CDR 검사일',  _pvDt(d.cdrDt)],
        ['GDS 실시여부', _pvYn(d.gdsYn)],   ['GDS 점수',   _pvTxt(d.gdsScore)],  ['GDS 검사일',  _pvDt(d.gdsDt)]
    ]);
    var s4 = _pvSec('D. 신체기능 (0 완전자립 · 1 감독필요 · 2 약간도움 · 3 상당도움 · 4 전적도움 · 8 행위 발생안함)', 'fa-walking', [
        ['옷벗고 입기', _pvCd('adl', d.dressing)], ['세수하기', _pvCd('adl', d.washing)],
        ['양치질하기', _pvCd('adl', d.brushing)], ['목욕하기', _pvCd('adl', d.bathing)],
        ['식사하기', _pvCd('adl', d.eating)], ['체위변경하기', _pvCd('adl', d.movePos)],
        ['일어나 앉기', _pvCd('adl', d.sitUp)], ['옮겨앉기', _pvCd('adl', d.transfer)],
        ['방밖으로 나오기', _pvCd('adl', d.exitRoom)], ['화장실 사용하기', _pvCd('adl', d.toiletUse)],
        ['와상상태', _pvYn(d.bedridden)]
    ]);
    return '<div class="pv-pane" data-tab="t2">' + s1 + s2 + s3 + s4 + '</div>';
}

function _pvTab3(d) {
    var s1 = _pvSec('E. 배설기능 / 배변조절 기구 및 프로그램', 'fa-tint', [
        ['대변조절', _pvCd('bowelCtl', d.bowelCtl)], ['소변조절', _pvCd('urineCtl', d.urineCtl)],
        ['일정하게 짜여진 배뇨계획', _pvYn(d.urPlan)], ['방광 훈련 프로그램', _pvYn(d.bladTrain)],
        ['규칙적 도뇨', _pvYn(d.regCath)], ['외부(콘돔형) 카테터', _pvYn(d.extCath)],
        ['패드, 팬티형 기저귀', _pvYn(d.padDiaper)], ['인공루', _pvYn(d.artifUr)],
        ['유치도뇨관 삽입', _pvYn(d.indwellCath)], ['해당사항 없음', _pvYn(d.catNoa)],
        ['배뇨일지 작성 여부', _pvYn(d.diaryCreated)], ['배뇨일지 작성일수', _pvTxt(d.diaryDays)],
        ['삽입기간(g-1~g-10 제외)', _pvTxt(d.catDur)]
    ]);

    var cathRows = '';
    for (var i = 1; i <= 10; i++) {
        var ii = d['catIn' + i];
        var oo = d['catOut' + i];
        if (!ii && !oo) continue;
        cathRows += '<tr><td>' + i + '</td><td class="dt">' + _pvDt(ii) + '</td><td class="dt">' + _pvDt(oo) + '</td></tr>';
    }
    if (!cathRows) cathRows = '<tr><td colspan="3" style="color:#b0b6bf;padding:14px;">삽입/제거 기록 없음</td></tr>';
    var s2 =
        '<div class="pv-sec">' +
        '  <div class="pv-sec-hd"><i class="fas fa-syringe"></i>유치도뇨관 삽입 / 제거 이력</div>' +
        '  <table class="pv-cath-tbl"><thead><tr><th style="width:60px;">회차</th><th>삽입일자</th><th>제거일자</th></tr></thead>' +
        '  <tbody>' + cathRows + '</tbody></table>' +
        '</div>';

    var s3 = _pvSec('F.1.a 당뇨 / 혈당 / HbA1c', 'fa-vial', [
        ['당뇨', _pvYn(d.diabetes)], ['혈당검사 실시여부', _pvYn(d.bldSugarTest)],
        ['공복시 혈당 (mg/dl)', _pvTxt(d.fastingSugar)], ['식후2시간 혈당 (mg/dl)', _pvTxt(d.post2hSugar)],
        ['HbA1c검사 실시여부', _pvYn(d.hba1cTest)], ['HbA1c (%)', _pvTxt(d.hba1cValue)],
        ['검사일', _pvDt(d.testDate)]
    ]);
    var s4 = _pvSec('F.1 질병', 'fa-disease', [
        ['고혈압', _pvYn(d.hyperten)], ['요로감염', _pvYn(d.uti)],
        ['말초혈관질환', _pvYn(d.vascDis)], ['하지마비', _pvYn(d.paralysis)],
        ['사지마비', _pvYn(d.allLimbs)], ['편마비', _pvYn(d.hemiplegia)],
        ['뇌성마비', _pvYn(d.cerebralP)], ['뇌혈관질환', _pvYn(d.stroke)],
        ['파킨슨병(G20)', _pvYn(d.parkinson)], ['척수손상', _pvYn(d.spinalInj)],
        ['중증근무력증 및 기타 근신경장애(G70)', _pvYn(d.myasthenia)],
        ['근육의 원발성 장애(G71)', _pvYn(d.muscDis)],
        ['다발경화증(G35)', _pvYn(d.ms)], ['헌팅톤병(G10)', _pvYn(d.huntington)],
        ['유전성 운동실조(G11)', _pvYn(d.heredAtax)],
        ['척수성 근위축 및 관련 증후군(G12)', _pvYn(d.spinalAtro)],
        ['계통성 위축(G13)', _pvYn(d.systemAtro)],
        ['진행성 핵상 안근마비(G23.1)', _pvYn(d.progSupra)],
        ['중추신경계통의 비정형바이러스 감염(A81)', _pvYn(d.viralInf)],
        ['아급성 괴사성 뇌병증[리이](G31.81)', _pvYn(d.subNecr)],
        ['후천성면역결핍증(B20~B24, Z21)', _pvYn(d.hiv)], ['치매', _pvYn(d.dementia)],
        ['고지혈증', _pvYn(d.lipidemia)], ['심부전', _pvYn(d.heartFail)],
        ['만성폐색성폐질환', _pvYn(d.copd)], ['천식', _pvYn(d.asthma)],
        ['해당사항 없음', _pvYn(d.diseNoa)]
    ]);
    return '<div class="pv-pane" data-tab="t3">' + s1 + s2 + s3 + s4 + '</div>';
}

function _pvTab4(d) {
    var s1 = _pvSec('F.2 영양관련 장애 / H. 구강 및 영양상태', 'fa-apple-alt', [
        ['콰시오르코르(E40)', _pvYn(d.kwashE40)], ['영양성 소모증(E41)', _pvYn(d.nutrE41)],
        ['소모성 콰시오르코르(E42)', _pvYn(d.wasteKwE42)],
        ['상세불명의 중증 단백질-에너지 영양실조(E43)', _pvYn(d.sevMalE43)],
        ['중등도 및 경도의 단백질-에너지 영양실조(E44)', _pvYn(d.modMalE44)],
        ['단백질-에너지 영양실조로 인한 발육지연(E45)', _pvYn(d.growthDE45)],
        ['상세불명의 단백질-에너지 영양실조(E46)', _pvYn(d.malUnkE46)],
        ['해당사항 없음', _pvYn(d.nutrNoa)],
        ['삼키기', _pvYn(d.swallow)],
        ['체중 측정여부', _pvYn(d.weigHeigYn)], ['체중(kg)', _pvTxt(d.weig)], ['체중 측정일', _pvDt(d.weigDt)],
        ['체중감소', _pvCd('weigLoss', d.weigLoss)], ['키 측정여부', _pvYn(d.heigYn)],
        ['키(cm)', _pvTxt(d.heigSec)], ['키 측정일', _pvDt(d.heigDt)],
        ['정맥영양', _pvYn(d.ivNutri)], ['경관영양 실시여부', _pvYn(d.ivNutYn)],
        ['경관영양 실시일수', _pvTxt(d.ivNutDy)],
        ['칼로리 (6일간 1일 평균)', _pvCd('calories', d.calories)],
        ['수분량 (6일간 1일 평균)',  _pvCd('waterAmt', d.waterAmt)]
    ]);
    var s2 = _pvSec('G.1 문제상황', 'fa-thermometer-half', [
        ['열', _pvYn(d.fever)], ['체온(℃)', _pvTxt(d.bodyTemp)],
        ['검사와 처치', _pvYn(d.testTreat)], ['발열 일수', _pvTxt(d.feverDays)],
        ['탈수', _pvYn(d.dehydr)], ['구토', _pvYn(d.vomit)],
        ['수술 3개월 이내 루 관리', _pvYn(d.surgInfec)],
        ['출혈·감염 등의 문제로 인한 루 관리', _pvYn(d.bloodInfec)],
        ['해당사항 없음', _pvYn(d.helthNoa)]
    ]);
    var s3 = _pvSec('G.2 통증 / G.3 낙상여부 / G.4 말기질환', 'fa-bolt', [
        ['통증 발생 빈도', _pvCd('painFreq', d.painFreq)], ['시각 통증 등급(VAS)', _pvTxt(d.painVisSc)],
        ['숫자 통증 등급(NRS)', _pvTxt(d.painNumSc)], ['얼굴 통증 등급(FPS)', _pvTxt(d.painFaceSc)],
        ['통증관련 치료', _pvYn(d.painTreatR)], ['암성통증 치료', _pvYn(d.painTreatC)],
        ['30일 이내 낙상', _pvCd('fall', d.fall30d)], ['31~180일 사이에 낙상', _pvCd('fall', d.fall31180d)],
        ['말기질환', _pvYn(d.termDisease)]
    ]);
    var s4 = _pvSec('I.1 피부궤양의 수 / I.2 새로 발생한 욕창 / I.3 과거력 / I.4 기타문제', 'fa-band-aid', [
        ['욕창(압박성 궤양) 1단계', _pvTxt(d.prUlcer1)], ['욕창(압박성 궤양) 2단계', _pvTxt(d.prUlcer2)],
        ['욕창(압박성 궤양) 3단계', _pvTxt(d.prUlcer3)], ['욕창(압박성 궤양) 4단계', _pvTxt(d.prUlcer4)],
        ['울혈/허혈성 궤양 1단계', _pvTxt(d.ciUl1)], ['울혈/허혈성 궤양 2단계', _pvTxt(d.ciUl2)],
        ['울혈/허혈성 궤양 3단계', _pvTxt(d.ciUl3)], ['울혈/허혈성 궤양 4단계', _pvTxt(d.ciUl4)],
        ['새로 발생한 욕창 유무', _pvCd('newUlcer', d.newUlcer)], ['발생일', _pvDt(d.ulcerDt)],
        ['욕창(압박성 궤양) 과거력', _pvCd('pastUlcer', d.pastUlcer)],
        ['2도 이상의 화상', _pvYn(d.skinProb)],
        ['개방성 피부병변', _pvYn(d.openSkinLes)], ['수술 창상', _pvYn(d.surgWound)],
        ['발의 감염', _pvYn(d.footInfec)], ['해당사항 없음', _pvYn(d.skinNoa)]
    ]);
    var s5 = _pvSec('I.5 피부문제에 대한 처치', 'fa-hand-holding-medical', [
        ['압력을 줄여주는 도구 사용', _pvYn(d.pressRelDev)], ['체위변경', _pvYn(d.posChange)],
        ['피부문제 해결을 위한 영양공급', _pvYn(d.nutrSkin)],
        ['피부궤양 드레싱', _pvYn(d.skinUlcDres)],
        ['피부궤양 드레싱 부위 : 발', _pvYn(d.footDres)],
        ['피부궤양 드레싱 부위 : 발 이외', _pvYn(d.nonFootDres)],
        ['피부궤양 이외의 드레싱', _pvYn(d.nonUlcDres)],
        ['드레싱 부위 : 발', _pvYn(d.leg)],
        ['드레싱 부위 : 발 이외', _pvYn(d.legOther)],
        ['수술창상 치료', _pvYn(d.surWndCare)],
        ['화상관련 처치', _pvYn(d.burnTreat)], ['해당사항 없음', _pvYn(d.fskinNoa)]
    ]);
    return '<div class="pv-pane" data-tab="t4">' + s1 + s2 + s3 + s4 + s5 + '</div>';
}

function _pvTab5(d) {
    var s1 = _pvSec('J. 투약', 'fa-pills', [
        ['인슐린 주사제 투여 일수', _pvCd('insulin', d.insulin)],
        ['행동심리증상에 대한 약물 치료 여부', _pvYn(d.psychDrug)],
        ['치매관련 약제 투여 여부', _pvYn(d.demnDrug)],
        ['복용한 의약품 수', _pvCd('medCount', d.medCount)]
    ]);
    var s2 = _pvSec('K.1 특수처치', 'fa-lungs', [
        ['정맥주사에 의한 투약', _pvYn(d.ivMed)],
        ['정맥주사 투여일수', _pvTxt(d.ivDays)],
        ['배뇨관련 루 관리', _pvYn(d.urineMgmt)],
        ['배변관련 루 관리', _pvYn(d.bowelMgmt)],
        ['영양관련 루 관리', _pvYn(d.nutriMgmt)],
        ['산소요법', _pvYn(d.oxygen)],
        ['(산소투여 전) 산소포화도(%)', _pvTxt(d.oxySatBf)],
        ['산소투여일수', _pvTxt(d.oxyDays)],
        ['하기도 증기흡입치료', _pvYn(d.lowAirTh)],
        ['흡인', _pvYn(d.suction)],
        ['기관절개관 관리', _pvYn(d.trachCare)],
        ['인공호흡기', _pvYn(d.ventilator)],
        ['인공호흡기 개인용', _pvYn(d.perVent)],
        ['인공호흡기 병원용', _pvYn(d.hosVent)],
        ['중심정맥영양', _pvYn(d.cvNutr)],
        ['해당사항 없음', _pvYn(d.specNoa)]
    ]);
    var s3 = _pvSec('K.2 전문재활치료 / L. 작성자', 'fa-signature', [
        ['전문재활치료 실시일수', _pvTxt(d.vitalRehab)],
        ['의사', _pvTxt(d.authDoc)],
        ['간호사', _pvTxt(d.authNurse)],
        ['환자분류군', _pvTxt(d.patClass)]
    ]);
    return '<div class="pv-pane" data-tab="t5">' + s1 + s2 + s3 + '</div>';
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
	    const yearQuarter = document.getElementById('yearQuarter');
	    const monsQuarter = document.getElementById('monsQuarter');
	    const hospcdGrade = document.getElementById('hospcdGrade');

	    const currentYear = new Date().getFullYear();
	    const current_Mon = new Date().getMonth() + 1;

	    // 기존 옵션 제거
	    year_Select.innerHTML = '';
	    monthSelect.innerHTML = '';
	    yearQuarter.innerHTML = '';
	    monsQuarter.innerHTML = '';

	    const current_Year = new Date().getFullYear();


	    if (current_Year === 2025) {
	    	$('#goal_Jugi').val('2');
	        $('#goal_Chasu').val('7');

	    }

	    // sessionStorage에 저장된 값이 있으면 그 값을, 없으면 현재 년월을 기본 선택
	    var savedYear  = sessionStorage.getItem('assessment_year');
	    var savedMonth = sessionStorage.getItem('assessment_month');
	    var targetYear  = savedYear  ? parseInt(savedYear, 10)  : currentYear;
	    var targetMonth = savedMonth ? parseInt(savedMonth, 10) : current_Mon;

	    // 당해년도 포함 10년 Setting
	    for (let i = 0; i <= 9; i++) {

	    	const year = currentYear - i;

	        const option1 = document.createElement('option');
	        option1.value = year;
	        option1.textContent = year;
	        if (year === targetYear) option1.selected = true;
	        year_Select.appendChild(option1);

	        const option2 = document.createElement('option');
	        option2.value = year;
	        option2.textContent = year;
	        if (year === targetYear) option2.selected = true;
	        yearQuarter.appendChild(option2);
	    }
	 	// 월 생성 로직
	    for (let i = 1; i <= 12; i++) {
	        let month = i < 10 ? '0' + i : '' + i;
	        const option = document.createElement('option');
	        option.value = month;
	        option.textContent = month;

	        if (i === targetMonth) {
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
	    
	    // 분기 옵션 생성
	    const quarters = ['1분기', '2분기', '3분기', '4분기'];
	    quarters.forEach((q, idx) => {
	        const option = document.createElement('option');
	        option.value = (idx + 1).toString();
	        option.textContent = q;
	        monsQuarter.appendChild(option);
	    });
	    const hospgrade = ['1등급', '2등급', '3등급', '4등급', '5등급'];
	    hospgrade.forEach((q, idx) => {
	        const option = document.createElement('option');
	        option.value = (idx + 1).toString();
	        option.textContent = q;
	        hospcdGrade.appendChild(option);
	    });
	    
	}	
	
	populateYearSelect();
	
	$('#year_Select').on('change', function() {
		sessionStorage.setItem('assessment_year', this.value);
		fn_IndiSelect();

		const selectedYear = $(this).val(); // 선택된 연도 값

	    if (selectedYear === '2025') {
	        $('#goal_Jugi').val('2');
	        $('#goal_Chasu').val('7');
	    }

    });
	$('#monthSelect').on('change', function() {
		sessionStorage.setItem('assessment_month', this.value);
		fn_IndiSelect();
    });
	$('#yearQuarter').on('change', function() {
		fn_Select();
    });
	$('#monsQuarter').on('change', function() {
		fn_Select();
    });
	
	document.getElementById('goal_Score').addEventListener('input', function () {
		  const scoreInput = this.value.trim();
		  const score = parseFloat(scoreInput);
		  const select = document.getElementById('hospcdGrade');

		  if (isNaN(score) || score < 0 || score > 100) {
		    select.value = ""; // 값이 유효하지 않으면 선택 해제
		    return;
		  }

		  let grade;
		  if        (score >= 88 && score <= 100) {
		    grade = "1";
		  } else if (score >= 79 && score < 88) {
		    grade = "2";
		  } else if (score >= 71 && score < 79) {
		    grade = "3";
		  } else if (score >= 63 && score < 71) {
		    grade = "4";
		  } else {
		    grade = "5";
		  }

		  select.value = grade;
	});
	
	/*
	if (winner === 'Y') {
		
        document.getElementById("googleLink").style.display = "flex";
        document.getElementById("googleHttp").style.display = "flex";
        document.getElementById("googleSave").style.display = "flex";

        
        $.ajax({
    		  url: "/main/selectGoolgleSheet.do",
  	      type: "POST",
  	      data: { hosp_cd: hospid,
  	    	      jobyymm: $('#year_Select').val() + $('#monthSelect').val(),
  	    	      jobcode: '1' 
  		  },
  		  dataType: "json",
  		  success: function(response) {
  		    	
  			if (response && response.httpST) {
  				
  		    	$('#googleHttp').val(response.httpST);
  		    }
  		    
  		  	fn_CreateData(0);
  		  },
  		  error: function(xhr, status, error) {
  		      console.error("Error fetching data:", error);
  		    	fn_CreateData(0);
  		  }
  		      
  		});
    } else {
    	fn_CreateData(0);	
    }
	*/
	
	
	fn_CreateData(0);		
	

});

function google_Link() {
	
	let url = document.getElementById("googleHttp").value; 
	
	if (!url || typeof url !== 'string' || url.trim() === '') {
        window.open('https://docs.google.com/spreadsheets/u/0/', '_blank');
    } else {
        window.open(url, '_blank');
    }
}
function google_Save() {
	
	let url = document.getElementById("googleHttp").value; 
	
	if (!url || typeof url !== 'string' || url.trim() === '') {
		Swal.fire({
            title: '등록 할 주소가 없습니다.',
            text:  '등록 할 주소를 정확하게 입력하고 저장하십시요.',
            icon:  'warning',
            confirmButtonText: '확인',
            timer: 1000,
            timerProgressBar: true,
            showConfirmButton: false
     	});
	} else if (!url.includes("https://docs.google.com/spreadsheets/")) {
		Swal.fire({
            title: '정상 주소가 아닙니다.',
            text:  '정상 주소를 정확하게 입력하고 저장하십시요.',
            icon:  'warning',
            confirmButtonText: '확인',
            timer: 1000,
            timerProgressBar: true,
            showConfirmButton: false
     	});
	} else {      
		$.ajax({
  		  url: "/main/insertGoolgleSheet.do",
	      type: "POST",
	      data: { hosp_cd: hospid,
	    	      jobyymm: $('#year_Select').val() + $('#monthSelect').val(),
	    	      jobcode: '1', 
	    	      http_st: document.getElementById("googleHttp").value,
      	          reg_user: userid
		  },
		  dataType: "json",
		  success: function(response) {
		    	 
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
	
}
	
</script> 
