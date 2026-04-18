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
			                            - 항정처방률 · 지역사회 복귀율 기본 표준화 3점으로 산정됩니다.
			                            <br>
										<div class="d-flex justify-content-between align-items-center">
										    <span>- 청구명세서 미 업로드시 항정처방률 및 HbA1c 지표의 점수가 달라질 수 있습니다.</span>
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
    for (var i = 0; i < _prevMissingData.length; i++) {
        if (_prevMissingData[i].patId) patSet[_prevMissingData[i].patId] = 1;
    }
    for (var j = 0; j < _errCheckData.length; j++) {
        if (_errCheckData[j].patId) patSet[_errCheckData[j].patId] = 1;
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

    function addPat(patId, patNm, admitDt, issueLabel, issueColor, errType) {
        if (!patId) return;
        if (!patMap[patId]) {
            patMap[patId] = { patId: patId, patNm: patNm || '', admitDt: admitDt || '', issues: [] };
            order.push(patId);
        } else {
            if (!patMap[patId].patNm   && patNm)   patMap[patId].patNm   = patNm;
            if (!patMap[patId].admitDt && admitDt) patMap[patId].admitDt = admitDt;
        }
        patMap[patId].issues.push({ label: issueLabel, color: issueColor, errType: errType || '' });
    }

    for (var i = 0; i < _prevMissingData.length; i++) {
        var m = _prevMissingData[i];
        addPat(m.patId, m.patNm, m.admitDt, '전월대상자 당월미존재', '#333333', 'PREV');
    }
    for (var j = 0; j < _errCheckData.length; j++) {
        var er = _errCheckData[j];
        var lbl = '[' + er.errType + '] ' + (er.errName || '평가표오류');
        addPat(er.patId, er.patNm, er.admitDt, lbl, '#dc3545', er.errType);
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
            '.cath05-table { width:100%; border-collapse:separate; border-spacing:0; font-size:13px; border:1px solid #e0e4ea; border-radius:4px; overflow:hidden; }' +
            '.cath05-table thead th { background:linear-gradient(135deg,#2a5298,#1e3c72); color:#fff; font-weight:normal; padding:10px 8px; border-right:1px solid rgba(255,255,255,0.15); letter-spacing:0.2px; }' +
            '.cath05-table thead th:last-child { border-right:none; }' +
            '.cath05-table tbody td { padding:8px 8px; border-bottom:1px solid #eef1f5; vertical-align:middle; }' +
            '.cath05-table tbody tr:nth-child(even) { background:#fafbfc; }' +
            '.cath05-table tbody tr:hover { background:#f0f7ff; }' +
            '.cath05-table tbody tr:last-child td { border-bottom:none; }' +
            '.cath05-rowno { color:#8891a3; font-weight:500; }' +
            '.cath05-patid { font-family:Consolas,monospace; color:#333; font-weight:600; }' +
            '.cath05-patnm { color:#2c3e50; font-weight:500; }' +
            '.cath05-date  { color:#5a6978; font-family:Consolas,monospace; font-size:12px; }' +
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

    if (total === 0) {
        html = '<div style="padding:30px 20px; text-align:center; color:#155724; font-size:14px;"><i class="fas fa-check-circle" style="color:#28a745; font-size:24px; display:block; margin-bottom:8px;"></i>점검 대상이 없습니다.</div>';
    } else {
        html = '<div style="text-align:left; max-height:65vh; overflow:auto; padding:4px;">';
        html += '<table class="cath05-table">' +
                '<thead><tr>' +
                '<th style="width:50px;">No</th>' +
                '<th style="width:100px;">환자ID</th>' +
                '<th style="width:90px;">성명</th>' +
                '<th style="width:110px;">입원일</th>' +
                '<th>점검항목</th>' +
                '</tr></thead><tbody>';
        for (var k = 0; k < order.length; k++) {
            var p = patMap[order[k]];
            var badges = '';
            for (var b = 0; b < p.issues.length; b++) {
                var iss = p.issues[b];
                // 박스 제거 — bullet + 텍스트에 색상 적용
                badges += '<div class="cath05-badge-wrap" style="color:' + iss.color + ';"><span class="cath05-badge" style="color:' + iss.color + ';">' + $('<div>').text(iss.label).html() + '</span></div>';
            }
            html += '<tr>' +
                    '<td class="cath05-rowno" style="text-align:center;">' + (k + 1) + '</td>' +
                    '<td class="cath05-patid" style="text-align:center;">' + p.patId + '</td>' +
                    '<td class="cath05-patnm" style="text-align:center;">' + p.patNm + '</td>' +
                    '<td class="cath05-date"  style="text-align:center;">' + p.admitDt + '</td>' +
                    '<td>' + badges + '</td>' +
                    '</tr>';
        }
        html += '</tbody></table></div>';
    }

    Swal.fire({
        title: '<span style="font-size:18px;"><i class="fas fa-stethoscope" style="color:#f0ad4e; margin-right:8px;"></i>유치도뇨관 및 오류점검 결과 : ' + total + '명</span>',
        html: html,
        width: '1100px',    // 배지 세로 배치라 너비 적당히 축소
        showCancelButton: (total > 0),
        confirmButtonText: '확인',
        cancelButtonText: '<i class="far fa-file-excel"></i> 엑셀저장',
        confirmButtonColor: '#6c7bff',
        cancelButtonColor: '#28a745',
        reverseButtons: true
    }).then(function(result) {
        // "엑셀저장"(=취소 버튼 재활용) 클릭 시
        if (result.dismiss === Swal.DismissReason.cancel) {
            fn_ExportCath05Excel();
            // 저장 후 모달 재오픈 (계속 보기 편하게)
            setTimeout(fn_ShowCath05Modal, 50);
        }
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

    // (1) 환자별 통합 시트
    var summaryRows = [];
    var maxIssueCnt = 1;   // 행 높이 계산용
    for (var i = 0; i < _cath05Order.length; i++) {
        var p = _cath05PatMap[_cath05Order[i]];
        // 여러 오류는 Ctrl+Enter(=\n)로 줄바꿈
        var issueText = p.issues.map(function(x) { return x.label; }).join('\n');
        var errTypes  = p.issues.map(function(x) { return x.errType; }).filter(function(v){return v;}).join(',');
        if (p.issues.length > maxIssueCnt) maxIssueCnt = p.issues.length;
        summaryRows.push({
            '환자ID':    p.patId,
            '성명':      p.patNm,
            '입원일':    p.admitDt,
            '오류개수':  p.issues.length,
            '오류코드':  errTypes,
            '점검항목':  issueText
        });
    }

    // (2) 상세 시트 (1행 = 1오류)
    var detailRows = [];
    for (var k = 0; k < _cath05Order.length; k++) {
        var pp = _cath05PatMap[_cath05Order[k]];
        for (var b = 0; b < pp.issues.length; b++) {
            var ii = pp.issues[b];
            detailRows.push({
                '환자ID':   pp.patId,
                '성명':     pp.patNm,
                '입원일':   pp.admitDt,
                '오류코드': ii.errType || '',
                '점검항목': ii.label
            });
        }
    }

    var wb = XLSX.utils.book_new();
    var ws1 = XLSX.utils.json_to_sheet(summaryRows);
    var ws2 = XLSX.utils.json_to_sheet(detailRows);

    // 컬럼 너비
    ws1['!cols'] = [ {wch:12}, {wch:10}, {wch:12}, {wch:8}, {wch:18}, {wch:90} ];
    ws2['!cols'] = [ {wch:12}, {wch:10}, {wch:12}, {wch:10}, {wch:90} ];

    // ── 환자별요약 시트: 점검항목 셀에 줄바꿈 + Wrap Text 스타일 적용 ──
    //     (SheetJS Style/xlsx-js-style 지원 시 실제 반영, Community 버전에선 무시됨 — 값의 \n은 보존)
    var range = XLSX.utils.decode_range(ws1['!ref']);
    var colIdx_chk = 5;  // '점검항목' 6번째 컬럼 (0-based)
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
		if ($.fn.DataTable.isDataTable('#' + tableName.id)) {
			$('#' + tableName.id).DataTable().clear().destroy();
		}
		$('#' + tableName.id).empty();
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
	        	
			},
	        success: function(response) {
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
		                        var cathErr = ['D1','D2','E1','F1','G1','G2','H1'];
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
