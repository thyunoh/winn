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
										<div class="d-flex justify-content-between align-items-center">
											<span></span>
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
	                    <div class="col-lg-7 d-flex flex-column">
		                    <style>
									    .std-toast-title { font-size: 18px !important; font-weight: 600 !important; margin-top: 6px !important; }
									    .std-popup { padding: 10px 16px !important; }
									    .std-popup .swal2-icon { margin: 8px auto 4px !important; }
									    .std-popup .swal2-timer-progress-bar-container { height: 4px !important; }
									</style>
									    <div id="stdRangeNotice" style="display:flex; align-items:flex-start; gap:10px; border:1px solid #f3c0bb; border-left:4px solid #e74c3c; border-radius:10px; background:linear-gradient(180deg,#fff8f7,#fdeeed); color:#7a2b22; font-size:13px; line-height:1.5; padding:11px 16px; margin-bottom:12px; box-shadow:0 2px 8px rgba(231,76,60,0.08);">
								        <i class="fas fa-circle-info" style="color:#e74c3c; font-size:16px; margin-top:1px;"></i>
								        <div><b>본 표준화 점수 구간은 2024년 평가 결과 기준입니다.</b><br>
								        안정적인 상위등급 달성 및 유지를 위해, 목표값은 제시된 구간보다 <b>10~20% 이상 여유 있게</b> 설정하여 관리하시기 바랍니다.</div>
								    </div>
								    <div class="card" id="card_container" style="display: none; flex:1 1 auto;">

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

							        /* 전월청구 확인 경고박스 깜박임 */
							        @keyframes prevMonthBlink {
							            0%, 100% { opacity: 1;   }
							            50%      { opacity: 0.35; }
							        }
							        #prevMonthWarn.blink { animation: prevMonthBlink 1s ease-in-out infinite; }

							        /* '등록되지 않은 자료입니다' 안내 팝업 - 작게 */
							        .swal-compact .swal2-icon { width: 48px; height: 48px; margin: 8px auto 6px; }
							        .swal-compact .swal2-icon .swal2-icon-content { font-size: 1.8em; }
							        .swal-compact-title { font-size: 1.05rem !important; margin: 4px 0 2px !important; }
							        .swal-compact-text  { font-size: 0.82rem !important; line-height: 1.4 !important; color: #666 !important; }
							        .swal-compact-btn   { font-size: 0.82rem !important; padding: 5px 18px !important; }

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
							        #diagRank07BtnZone #btnDiagRank07.cath05-btn {
							            height: 32px !important;
							            padding: 0 14px !important;
							            box-sizing: border-box !important;
							            line-height: 1 !important;
							            font-size: 12.5px !important;
							            font-weight: 700 !important;
							            vertical-align: middle !important;
							        }
							        #btnPatvalView.patval-btn:hover,
							        .dt-buttons #btnPatvalView.patval-btn:hover { transform: translateY(-1px); filter: brightness(1.08); box-shadow: 0 4px 10px rgba(37,99,235,0.45) !important; color:#fff !important; }
							        #btnPatvalView.patval-btn:active { transform: translateY(0); filter: brightness(0.95); }
							        #btnPatvalView.patval-btn:focus  { outline: none; }
							        #btnPatvalView.patval-btn .patval-label,
							        #btnPatvalView.patval-btn .patval-icon { color: #ffffff !important; }
							        #btnPatvalView.patval-btn.is-disabled { cursor: not-allowed; filter: grayscale(0.5); opacity: 0.75; }
							        .patval-icon { font-size: 13px; opacity: 0.95; }

							        /* viewTable / indicatorTable — 변경 ✔ 컬럼 폭 최소화 (헤더 + body 셀 모두) */
							        #viewTable thead tr:first-child th:first-child,
							        #viewTable thead th.pv-chk-th,
							        #viewTable tbody td.pv-chk-cell,
							        #viewTable_wrapper .dataTables_scrollHead thead tr:first-child th:first-child,
							        #viewTable_wrapper .dataTables_scrollHead th.pv-chk-th,
							        #indicatorTable thead th.pv-chk-th,
							        #indicatorTable tbody td.pv-chk-cell,
							        #indicatorTable_wrapper .dataTables_scrollHead thead tr:first-child th:first-child,
							        #indicatorTable_wrapper .dataTables_scrollHead th.pv-chk-th {
							            width: 24px !important;
							            min-width: 24px !important;
							            max-width: 24px !important;
							            padding-left: 2px !important;
							            padding-right: 2px !important;
							            box-sizing: border-box !important;
							        }

							        /* indicatorTable — noArrow 헤더: 정렬 화살표(dt-column-order) 숨김 + 좌우 여백 축소로 폭 절약.
							           ※ scrollY 사용 시 실제 보이는 헤더는 복제본(.dt-scroll-head 안, id 없음)이라
							             #indicatorTable 이 아닌 #indicatorTable_wrapper 로 스코프해야 복제 헤더까지 잡힌다. */
							        th.noArrow span.dt-column-order,
							        th.noArrow .dt-column-order { display: none !important; }
							        th.noArrow { padding-left: 11px !important; padding-right: 11px !important; }

							        /* viewTable — 전월 대비 적정성평가 항목 변경 환자 표시는
							           첫 컬럼 ✔ 체크박스로만 표시 (행 배경 강조 제거) */

							        /* viewTable 헤더 nowrap — 90%+ 줌에서 DataTables 가 헤더 폭을 줄이려 할 때
							           텍스트가 글자 단위로 깨지지 않도록. <br>은 명시적 줄바꿈이라 정상 동작 유지. */
							        #viewTable thead th,
							        #viewTable_wrapper .dataTables_scrollHead th {
							            white-space: nowrap !important;
							        }
							        /* 단, <br> 포함된 sub-header 는 줄바꿈 허용 (일정\n배뇨 등) */
							        #viewTable thead th:has(br),
							        #viewTable_wrapper .dataTables_scrollHead th:has(br) {
							            white-space: normal !important;
							            word-break: keep-all !important;
							            line-height: 1.2 !important;
							        }
							    </style>
							    <!-- 라인 1줄 생성 -->
							    <hr style="margin: 0; border-top: 2px solid #ccc;">

							    <!-- flex 세로 컨테이너 — 카드가 늘어난 만큼 저장분기 그리드+안내문구를 카드 하단에 정렬 -->
							    <div class="card-header11" style="flex:1 1 auto; display:flex; flex-direction:column;">
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
					  	   					    onClick="fn_Select(true)">조회하기........· <i class="fas fa-search"></i></button>
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
									<!-- 저장된 분기 목록 그리드 (차등제 01~04 화면 전용) — 행 클릭 시 위 폼에 적용. 화면 넘치면 좌우 스크롤 -->
									<div id="grdListWrap" style="display:none; overflow-x:auto; margin-top:auto; min-height:245px; border:1px solid #e6e8eb; border-radius:6px;">
										<table id="grdList" class="table table-sm table-bordered text-center mb-0" style="width:100%; min-width:900px; font-size:14px; white-space:nowrap; table-layout:auto;">
											<thead style="background:#f4f6f8;">
												<tr>
													<th>신고분기</th><th>주기</th><th>차수</th><th>목표점수</th><th>병원등급</th>
													<th>평균환자수</th><th>의사수</th><th>간호사수</th><th>간호인력수</th><th>약사재직일수</th><th>수정일시</th><th>삭제</th>
												</tr>
											</thead>
											<tbody id="grdListBody"></tbody>
										</table>
									</div>
									<!-- 분석 문구 — 모든 카테고리 그리드 하단 + 약사재직일수율(01~04) 입력폼 하단 공통 표시 -->
									<div id="indiNoticeText" style="margin-top:12px; padding:10px 14px; font-size:13px; color:#555; line-height:1.7; background:#fafbfc; border:1px solid #e6e8eb; border-radius:6px;">
										- 항정처방률은 타 기관의 상병 구성 및 평균 처방률 자료 확인이 불가하여,시스템 산출 PI값은 실제 평가결과와 차이가 있을 수 있으므로 참고용으로 활용하시기 바랍니다.<br>
										- 청구명세서 미업로드 시 항정처방률 대상자 확인 및 HbA1c 분모 산정에 차이가 발생하여 최종 결과와 다를 수 있습니다.<br>
										- 본 점수는 청구명세서 자료 기반의 자체 분석 결과로, 건강보험심사평가원의 공식 평가결과와 산출기준 및 결과값이 다를 수 있습니다.
									</div>
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
								        const pdfPageHeight = doc.internal.pageSize.getHeight();
				        const fullImgHeight = (imgProps.height * pdfWidth) / imgProps.width;
								
								        if (fullImgHeight <= pdfPageHeight) {
				            doc.addImage(imgData, 'PNG', 0, 0, pdfWidth, fullImgHeight);
				        } else {
				            // 보고서가 길면 A4 여러 페이지로 자동 분할(전체 다 보이게)
				            const sliceHeightPx = Math.floor(canvas.width * pdfPageHeight / pdfWidth);
				            let y = 0, page = 0;
				            while (y < canvas.height) {
				                const hpx = Math.min(sliceHeightPx, canvas.height - y);
				                const pc = document.createElement('canvas');
				                pc.width = canvas.width; pc.height = hpx;
				                pc.getContext('2d').drawImage(canvas, 0, y, canvas.width, hpx, 0, 0, canvas.width, hpx);
				                if (page > 0) doc.addPage();
				                doc.addImage(pc.toDataURL('image/png'), 'PNG', 0, 0, pdfWidth, hpx * pdfWidth / canvas.width);
				                y += hpx; page++;
				            }
				        }
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

/* ============================================================
   [성명 마스킹] 요양기관 설정 DOCCNT='1' → 성(姓)만 노출(예: 박**), 뒤는 전부 *
   - 위너넷 접속(s_wnn_yn='Y' 또는 s_winconect='Y') → 기존대로(박덕*) 미변경
   - 일반 병원(DOCCNT!='1') → 기존대로(박덕*) 미변경
   - 그리드/엑셀/환자평가표조회 모두 동일 적용. 서버 박덕* / 평가표 풀네임 모두 박**로 정규화
   ============================================================ */
var _NAME_MASK_DOCCNT = null;   // 현 병원 DOCCNT 설정값 (마스킹 정책 플래그)

function _loadDocCnt() {
    if (_NAME_MASK_DOCCNT !== null) return;     // 1회만 조회
    try {
        $.ajax({
            url: "/user/phospList.do",
            type: "POST",
            dataType: "json",
            async: false,                        // 그리드 렌더 전 확정 필요
            data: { hospCd: (typeof hospid !== 'undefined' ? hospid : getCookie("hospid")) },
            success: function(res) {
                var lst = res && res.resultLst;
                if (lst && lst.length > 0 && lst[0].doccnt != null) {
                    _NAME_MASK_DOCCNT = String(lst[0].doccnt).trim();
                } else {
                    _NAME_MASK_DOCCNT = '';       // 값없음 → 재조회 방지
                }
            },
            error: function() { _NAME_MASK_DOCCNT = ''; }
        });
    } catch (e) { _NAME_MASK_DOCCNT = ''; }
}

function fn_NameMask(name) {
    if (name === null || name === undefined) return name;
    var s = String(name);
    if (s.length <= 1) return s;
    var isWnn = false;
    try {
        isWnn = ((getCookie("s_wnn_yn")    || '').trim() === 'Y') ||
                ((getCookie("s_winconect") || '').trim() === 'Y');
    } catch (e) {}
    if (isWnn) return s;                          // 위너넷: 기존대로
    if (_NAME_MASK_DOCCNT !== '1') return s;       // 일반 병원: 기존대로
    return s.charAt(0) + new Array(s.length).join('*');   // 성만 노출 (박**)
}

function fn_MaskPatNmRows(resp) {
    if (!resp) return resp;
    var arr = Array.isArray(resp) ? resp : (Array.isArray(resp.data) ? resp.data : null);
    if (!arr) return resp;
    for (var i = 0; i < arr.length; i++) {
        if (arr[i] && arr[i].patNm != null) arr[i].patNm = fn_NameMask(arr[i].patNm);
    }
    return resp;
}
var _curIndiDtor = 0;  // 현재 보기중인 지표의 분모(대상자수) — 우측 그리드 0건 안내 판정용

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
        //   예외: D3(오더O/평가표X)는 전월 상태와 무관하게 당월 오더가 있으면 오류로 잡음
        if (String(er2.evalType || '') === '2') {
            var _et2b = String(er2.errType || '');
            if (_et2b !== 'D3') {
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
                patId: patId, patNm: fn_NameMask(patNm) || '', admitDt: admitDt || '',
                patClass: patClass || '', evalType: evalType || '', indwellCath: indwellCath || '',
                docDt: docDt || '',
                issues: []
            };
            order.push(patId);
        } else {
            if (!patMap[patId].patNm       && patNm)       patMap[patId].patNm       = fn_NameMask(patNm);
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
        //    예외: D3(오더O/평가표X) 는 전월 상태와 무관하게 당월 오더가 있으면 오류로 잡음
        if (String(er.evalType || '') === '2') {
            var _et2 = String(er.errType || '');
            if (_et2 !== 'D3') {
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
            '.cath05-table thead th { position:sticky; top:0; z-index:2; background:linear-gradient(135deg,#2a5298,#1e3c72); color:#fff; font-weight:normal; padding:10px 8px; border-right:1px solid rgba(255,255,255,0.15); letter-spacing:0.2px; text-align:center; }' +
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
        if (!v || v === '0' || v === 0) return '<span style="color:#b0b6bf;">-</span>';
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
            html += '<tr class="cath05-row" data-patid="' + p.patId + '" data-admitdt="' + (p.admitDt || '') + '" data-eval="' + (p.evalType || '') + '" data-docdt="' + (p.docDt || '') + '" style="cursor:pointer;">' +
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
        var docDt   = $(this).data('docdt')   || '';
        if (!patId || !admitDt) return;
        _cath05LoadDetail(String(patId), String(admitDt).replace(/-/g, ''), String(docDt).replace(/-/g, ''));
    });
}

function _cath05LoadDetail(patId, admitDt, maxDocDt) {
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
            // 상단 작성일 기준으로 오더 MED_START ≤ 작성일 인 행만 표시
            $sp.html(_cath05RenderSpcsuga(res.spcsuga || [], maxDocDt));
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

function _cath05RenderSpcsuga(rows, maxDocDt) {
    if (!rows || rows.length === 0) {
        return '<div style="padding:20px; text-align:center; color:#888;">데이터 없음</div>';
    }
    // 작성일(MAX DOC_DT) 이후 오더는 제외 — 차기 평가표에서 반영될 오더
    var cutoff = (maxDocDt || '').replace(/-/g, '');
    if (cutoff) {
        rows = rows.filter(function(r) {
            var ms = (r.medStart || '').replace(/-/g, '');
            return !ms || ms <= cutoff;
        });
    }
    if (rows.length === 0) {
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
               '<th style="' + _thSt + '">주민번호</th>' +
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

    /* (2) 항정신성 처방(psyOrderYn='●') 행만 골라 주진단 3자리 prefix 별 환자수 집계
           예) G819 → G81, I639 → I63 (TBL_CODE_DTL SUB_CODE 와 매칭) */
    var diagMap = {};   // { prefix3 : { patKey : true, ... } }
    for (var i = 0; i < rows.length; i++) {
        var r = rows[i] || {};
        if (r.psyOrderYn !== '●') continue;
        var code = (r.mainDiagCd || '').toString().trim().toUpperCase();
        if (!code) continue;
        var prefix = code.substr(0, 3);
        if (!prefix) continue;
        var key = (r.patId || r.chartNo || '') + '|' + (r.admitDt || '');
        if (!diagMap[prefix]) diagMap[prefix] = {};
        diagMap[prefix][key] = true;
    }

    var codes = Object.keys(diagMap);
    if (codes.length === 0) {
        _diagRank07Data = [];
        _renderDiagRank07Modal([]);
        return;
    }

    /* (3) 진단코드 리스트만 서버에 보내 진단명 매칭 (공통코드 TBL_CODE_DTL — CODE_GB='Z', CODE_CD='DISEASE_TYPE', LEFT(code,3) prefix) */
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
    var zzKeys = {};   // 공통코드 미매칭 3자리는 ZZ 한 행으로 통합 (항상 맨 아래)
    for (var i = 0; i < codes.length; i++) {
        var c = codes[i];
        var nm = nameMap[c];
        if (nm && nm !== '기타' && nm !== '기타병명') {
            list.push({
                diagCode: c,
                diagName: nm,
                diagCnt:  String(Object.keys(diagMap[c]).length)
            });
        } else {
            var ks = diagMap[c] || {};
            for (var pk in ks) zzKeys[pk] = true;
        }
    }
    var zzCnt = Object.keys(zzKeys).length;
    if (zzCnt > 0) {
        list.push({ diagCode: 'ZZ', diagName: '기타병명', diagCnt: String(zzCnt) });
    }
    list.sort(function(a, b) {
        /* ZZ(기타병명) 은 항상 맨 아래 */
        var aEtc = (a.diagCode === 'ZZ') ? 1 : 0;
        var bEtc = (b.diagCode === 'ZZ') ? 1 : 0;
        if (aEtc !== bEtc) return aEtc - bEtc;
        var ca = parseInt(a.diagCnt, 10) || 0;
        var cb = parseInt(b.diagCnt, 10) || 0;
        if (cb !== ca) return cb - ca;
        return (a.diagCode || '').localeCompare(b.diagCode || '');
    });
    _diagRank07Data = list;
    _renderDiagRank07Modal(list);
}

/* 정렬 상태 — 진단건수 DESC 기본 */
var _diag07SortKey = 'diagCnt';    // 'diagCode' | 'diagCnt'
var _diag07SortDir = 'desc';       // 'asc' | 'desc'

function _sortDiag07(list) {
    var key = _diag07SortKey, dir = _diag07SortDir;
    var sign = (dir === 'asc') ? 1 : -1;
    list.sort(function(a, b) {
        /* ZZ(기타병명) 은 정렬 방향과 무관하게 항상 맨 아래 */
        var aEtc = (a.diagCode === 'ZZ') ? 1 : 0;
        var bEtc = (b.diagCode === 'ZZ') ? 1 : 0;
        if (aEtc !== bEtc) return aEtc - bEtc;
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
        /* ZZ 는 맨 아래 배치 효과만 유지하고 화면상 진단코드는 공백 처리 */
        var codeDisp = (code === 'ZZ') ? '' : code;
        html += '<tr>' +
                '<td class="diag07-rowno">' + (i+1) + '</td>' +
                '<td class="diag07-code">' + codeDisp + '</td>' +
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
    /* 진단건수 합계 (행 건수가 아닌, 각 행의 diagCnt 합) */
    var sumCnt = 0;
    for (var _si = 0; _si < (list || []).length; _si++) {
        sumCnt += parseInt((list[_si] || {}).diagCnt, 10) || 0;
    }
    var html;
    if (total === 0) {
        html = '<div style="padding:30px; text-align:center; color:#6c757d; font-size:14px;">' +
               '<i class="fa fa-info-circle" style="font-size:32px; color:#95a5a6; margin-bottom:12px;"></i>' +
               '<div>해당 월에 항정신성 처방 대상자의 진단 집계 결과가 없습니다.</div></div>';
    } else {
        /* 현재 정렬 상태 반영 */
        _sortDiag07(list);

        html = '<div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:8px; flex-wrap:wrap; gap:8px;">' +
                  '<span style="font-weight:600; color:#1e3c72;">총 <b style="color:#c0392b;">' + sumCnt + '</b> 건</span>' +
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
	// 표준 구간(전 병원 공통, % 또는 명)
	var stdRangeText = criteria.start + ' ~ ' + criteria.end + valUnit;
	// 해당 병원 구간: % 지표는 이 병원 분모(dtorval) 기준 명수로 환산 (메인 그리드 fiveZone 과 동일 방식)
	//   - 1인당 환자수(01·02·03) 등 명 단위 지표, 분모 0, 또는 분모가 환자수가 아닌 지표(04 재직일수율·08 DUR)는 표준 구간 그대로
	var notHeadcountDenom = ['04','08'].includes(data.cate_cd);
	var rangeText;
	if (isPersonUnit || notHeadcountDenom || !(dtorval > 0)) {
		rangeText = stdRangeText;
	} else if (criteria.direction === 'lower') {
		rangeText = '0 ~ ' + Math.floor(criteria.end * dtorval / 100) + '명';   // 상한 이하면 5점
	} else {
		rangeText = Math.ceil(criteria.start * dtorval / 100) + ' ~ ' + Math.round(dtorval) + '명';   // 하한 이상이면 5점
	}

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
				if (diff > 0) targetMsg = '5점 도달을 위해 추가 <b class="text-danger">' + diff + '명</b> 개선 필요';
			} else {
				var maxNtor = Math.floor(criteria.end * dtorval / 100);
				var diff2 = ntorval - maxNtor;
				if (diff2 > 0) targetMsg = '5점 도달을 위해 <b class="text-danger">' + diff2 + '명</b> 감소 필요';
			}
		} else if (data.fiveZone && data.fiveZone.trim() !== '') {
			targetMsg = '5점 도달 필요: <b>' + data.fiveZone + '</b>';
		}
		/* 만점 대비 부족 점수 — 기본 소수점 2자리, 둘째자리가 0 이면 절사 (예: 3.52→3.52, 3.50→3.5, 3.00→3.0) */
		var scoreDiff = (stdweig - weigval).toFixed(2).replace(/0$/, '');
		var isConverted = (rangeText !== stdRangeText);
		var detailLine = '→ 5점 구간' + (isConverted ? '(해당 병원)' : '') + ': ' + rangeText;
		if (isConverted) detailLine += ' <span class="text-muted">(표준 ' + stdRangeText + ')</span>';
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
var page_Hight = 563;    		// Page 길이보다 Data가 많으면 자동 scroll - scrollY
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


function fn_CreateData(flag, force) {

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
    let jobyymm = selected_Year + selectedMonth;
	let waitingCreate = document.getElementById("wait_Create");

    // 실제 생성 실행 — 기존 메시지("자료생성중입니다...") 유지 + 그 뒤에 지표를 '하나씩' 진행표시.
    //   ※ 이 생성 프로시저는 지표를 한 번에(원자적으로) 처리해, 외부에서 항목별 진행을 관찰할 수 없다.
    //     따라서 여기서는 [추정 기반 하나씩 애니메이션] 으로 표시한다(지루함 해소용 시각효과).
    //     - 지표 목록: 기존 생성분(재생성 시) → 없으면 표준 지표목록(_STD_RANGE_DATA) fallback
    //     - 경과시간에 맞춰 ✔ 를 하나씩 채우되, 마지막 1개는 실제 완료 시점까지 남겨 조기 100% 방지
    //     - SP 완료 시 전체 ✔ 로 확정 후 결과 로드
    //   (자바 재빌드 불필요 — 기존 엔드포인트만 사용)
    function doCreate() {
        if (waitingCreate) waitingCreate.style.display = 'flex';

        // 진행 표시용 인라인 박스(최초 1회 생성, '자료생성중입니다...' 메시지 바로 뒤)
        var box = document.getElementById('evpInline');
        if (!box && waitingCreate && waitingCreate.parentNode) {
            box = document.createElement('div');
            box.id = 'evpInline';
            box.style.cssText = 'margin-top:8px;font-size:15.5px;line-height:1.7;';
            waitingCreate.parentNode.insertBefore(box, waitingCreate.nextSibling);
        }
        if (box) box.innerHTML = '<span style="color:#888;">생성 준비 중...</span>';

        var finished = false;
        var startTime = new Date().getTime();
        var names = [];          // 예상 지표명 목록
        var shown = 0;           // ✔ 표시된 개수(추정)
        var revealTimer = null;
        var PACE = 1500;         // 항목 노출 간격(ms, 추정)

        function elapsedSec() { return Math.floor((new Date().getTime() - startTime) / 1000); }

        // 표준 지표명 fallback (_STD_RANGE_DATA: 신규생성 등 기존자료 없을 때)
        function fallbackNames() {
            try { return _STD_RANGE_DATA.map(function(d){ return d.indi; }); }
            catch (e) { return ['지표 1','지표 2','지표 3','지표 4','지표 5','지표 6','지표 7','지표 8','지표 9','지표 10','지표 11','지표 12','지표 13','지표 14']; }
        }

        function render() {
            if (!box) return;
            var total = names.length;
            var idx = Math.min(shown, Math.max(0, total - 1));   // 현재 진행 중인 항목
            var curName = total > 0 ? names[idx] : '';
            box.innerHTML =
                '<div style="display:flex;align-items:center;flex-wrap:wrap;gap:10px;font-weight:600;color:#1e3c72;">'
              + '<span>▶ 지표 생성 진행 중 (' + (total > 0 ? Math.min(shown, total) + '/' + total + ', ' : '') + elapsedSec() + '초)</span>'
              + '<span style="display:inline-flex;align-items:center;gap:6px;color:#28a745;margin-left:30px;">'
              + '<i class="fa fa-spinner fa-spin"></i><span>' + curName + '</span></span>'
              + '</div>';
        }

        function startReveal() {
            render();
            revealTimer = setInterval(function() {
                if (finished) return;
                if (shown < Math.max(0, names.length - 1)) shown++;   // 마지막 1개는 완료 때까지 보류
                render();
            }, PACE);
        }

        // 1) 예상 지표 목록 확보 → 애니메이션 시작 → 실제 생성 호출
        $.ajax({
            url: "/main/select_Eval_Indi.do",
            type: "POST",
            data: { hosp_cd: hospid, jobyymm: jobyymm },
            dataType: "json",
            complete: function(xhr) {
                try {
                    var res = xhr.responseJSON;
                    var arr = (res && res.data) ? res.data.filter(function(r){ return r.cate_cd !== '99'; }) : [];
                    names = arr.length ? arr.map(function(r){ return (r.cate_nm || r.cate_cd); }) : fallbackNames();
                } catch (e) { names = fallbackNames(); }
                startReveal();
                runCreate();
            }
        });

        // 2) 실제 생성(SP) 호출 — 완료 시점이 곧 '종료'
        function runCreate() {
            $.ajax({
                url: "/main/create_Eval_Indi.do",
                type: "POST",
                data: { hosp_cd: hospid, jobyymm: jobyymm, reg_user: userid },
                success: function(response) {
                    finished = true;
                    if (revealTimer) clearInterval(revealTimer);
                    if (response) {
                        shown = names.length; render();   // 전체 ✔ 확정
                        if (box) box.innerHTML = '<div style="font-weight:600;color:#28a745;">'
                            + '<i class="fa fa-check-circle"></i> 완료되었습니다 (' + elapsedSec() + '초)</div>';
                        setTimeout(function() {
                            if (waitingCreate) waitingCreate.style.display = 'none';
                            if (box) box.innerHTML = '';
                            loadFivePointCriteria(jobyymm);
                            Indicater_DataList();
                        }, 800);
                    } else {
                        if (waitingCreate) waitingCreate.style.display = 'none';
                        if (box) box.innerHTML = '';
                    }
                },
                error: function(xhr, status, error) {
                    finished = true;
                    if (revealTimer) clearInterval(revealTimer);
                    if (waitingCreate) waitingCreate.style.display = 'none';
                    if (box) box.innerHTML = '';
                    Swal.fire({ icon: 'error', title: '오류', text: '자료생성 중 오류가 발생했습니다.' });
                }
            });
        }
    }

    // 재생성 없이 기존 자료만 화면에 표시
    function showExisting() {
        waitingCreate.style.display = 'none';
        loadFivePointCriteria(jobyymm);
        Indicater_DataList();
    }

    // [추가] 해당 병원·년월의 적정성평가 자료가 이미 생성되어 있는지 먼저 확인.
    //   - 이미 생성됨 → "다시 생성하시겠습니까?" 확인. 취소 시 기존 자료만 표시(재생성 안 함).
    //   - 생성된 자료 없음 → 기존처럼 무조건 생성 실행.
    //   ※ select_Eval_Indi 는 '99'(합계) 행을 무조건 1건 반환하므로, 실제 지표행(cate_cd!=='99')
    //     존재 여부로 판단한다.
    //   force=true (예: 설정 저장 후 재계산 fn_Update) 인 경우 확인 없이 바로 생성.
    if (force) {
        doCreate();
        return;
    }

    $.ajax({
        url: "/main/select_Eval_Indi.do",
        type: "POST",
        data: { hosp_cd: hospid, jobyymm: jobyymm },
        dataType: "json",
        success: function(response) {
            var hasData = response && response.data && response.data.some(function(r) {
                return r.cate_cd !== '99';
            });
            if (hasData) {
                if (!document.getElementById('regenConfirmStyle')) {
                    var rst = document.createElement('style');
                    rst.id = 'regenConfirmStyle';
                    rst.innerHTML =
                        '.regen-confirm-popup { padding:14px 16px !important; }' +
                        '.regen-confirm-popup .swal2-title { font-size:1.05em !important; padding:6px 0 2px !important; }' +
                        '.regen-confirm-popup .swal2-html-container { font-size:0.92em !important; margin:6px 0 0 !important; }' +
                        '.regen-confirm-popup .swal2-icon { width:48px; height:48px; margin:8px auto 4px; }' +
                        '.regen-confirm-popup .swal2-icon .swal2-icon-content { font-size:1.6em; }' +
                        '.regen-confirm-popup .swal2-actions { margin-top:12px; }' +
                        '.regen-confirm-popup .swal2-styled { font-size:0.9em !important; padding:7px 16px !important; }';
                    document.head.appendChild(rst);
                }
                Swal.fire({
                    title: '재생성 확인',
                    html: '<b>' + selected_Year + '년 ' + selectedMonth + '월</b> 자료가 이미 생성되어 있습니다.<br>다시 생성하시겠습니까?',
                    icon: 'question',
                    width: 380,
                    showCancelButton: true,
                    confirmButtonText: '다시 생성',
                    cancelButtonText: '기존 자료 보기',
                    customClass: { popup: 'regen-confirm-popup' }
                }).then(function(result) {
                    if (result.isConfirmed) {
                        doCreate();
                    } else {
                        showExisting();
                    }
                });
            } else {
                doCreate();   // 생성된 자료 없음 → 기존처럼 무조건 생성
            }
        },
        error: function() {
            doCreate();       // 확인 실패 시 안전하게 기존처럼 생성
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
                    showConfirmButton: false,
                    width: 300,
                    padding: '0.8em',
                    customClass: { popup: 'swal-compact', title: 'swal-compact-title', htmlContainer: 'swal-compact-text' }
                });
                jobFlag = "00";
                fn_LoadGrdList(false);     // 저장 후 하단 그리드 자동 표시·갱신
                fn_CreateData(1, true);   // 설정 저장 후 재계산 — 확인 없이 강제 재생성
                // fn_CreateData(1)이 우측 카드(card_container)를 숨기므로 즉시 복원 — 저장 후에도 차등제 화면 유지
                var _cc = document.getElementById('card_container');
                if (_cc) _cc.style.display = 'flex';
            }
        },
        error: function(xhr, status, error) {
            console.error("Error saving data:", error);
        }
    });
}

function fn_Select(showMsg) {

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

        	var d = (response && response.data) ? response.data : null;

        	// 선택한 "신고분기"에 실제로 등록된 자료가 있는지 판단.
        	// goalScore/goalJugi/goalChasu 는 연도단위(다른 분기만 저장해도 채워짐)라 판정에서 제외.
        	// qterFlag 는 해당 분기 행(LEFT JOIN)이 있을 때만 채워지므로 분기 등록의 핵심 신호.
        	var hasData = d && (
        		d.qterFlag || d.hospgrade || d.patCount || d.docCount ||
        		d.nurCount || d.nurSCnt   || d.phamDays
        	);

        	if (hasData) {

                $("#hospcdGrade").val(d.hospgrade);
                $("#pat_Count").val(d.patCount);
                $("#doc_Count").val(d.docCount);
                $("#nur_Count").val(d.nurCount);
                $("#nursCount").val(d.nurSCnt);
                $("#pham_Days").val(d.phamDays);
               // $("#total_Day").val(d.totalDay);
               // $("#goal_Name").val(d.goalName);
                $("#goal_Score").val(d.goalScore);
                $("#goal_Jugi").val(d.goalJugi);
    	        $("#goal_Chasu").val(d.goalChasu);

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
    	        	} = d || {};

    	        	const isAllEmpty = [patCount, docCount, nurCount, nurSCnt, phamDays].every(val => !val);

    	        	if (isAllEmpty) {
    	        	    document.getElementById("formBtnSave").style.display = "flex";
    	        	}
    	        }
            } else {

            	// 등록된 자료 없음 → 입력값은 그대로 보존(덮어쓰지 않음), 저장 가능하도록 버튼만 노출
            	document.getElementById("formBtnSave").style.display = "flex";

            	// 사용자가 직접 조회(분기 변경 / 조회하기 버튼)한 경우에만 안내 메시지 표시
            	if (showMsg) {
            		Swal.fire({
            			icon: 'info',
            			title: '등록되지 않은 자료입니다',
            			text: '선택한 신고분기에 저장된 자료가 없습니다. 입력 후 저장하기를 눌러주세요.',
            			confirmButtonText: '확인',
            			width: 360,
            			padding: '1em',
            			iconColor: '#3fc3ee',
            			customClass: {
            				popup: 'swal-compact',
            				title: 'swal-compact-title',
            				htmlContainer: 'swal-compact-text',
            				confirmButton: 'swal-compact-btn'
            			}
            		});
            	}
            }
        },
        error: function(jqXHR, textStatus, errorThrown) {
            console.error("Error fetching data:", textStatus, errorThrown);
        }
    });
}

// ── 저장된 분기 목록 그리드 (차등제 01~04) ──────────────────────────
var _grdAllData = [];    // 전체(전 년도) 저장 목록
var _grdListData = [];   // 현재 그리드 표시 중(선택 년도) 목록
function _grdEsc(v){ return (v==null?'':String(v)).replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;'); }
// autoLatest=true 면(조회하기) 최종(최근) 분기를 자동 선택·표시
function fn_LoadGrdList(autoLatest) {
    $.ajax({
        type: "POST",
        url: "/user/selectHospGrdList.do",
        data: { hospCd: hospid },
        dataType: "json",
        success: function(response) {
            var rows = (response && response.data) ? response.data : [];
            // 같은 분기의 중복 행 방어 — SQL이 분기 내 최신(UPD_DTTM DESC)순이므로 첫 행만 채택
            var seen = {}, dedup = [];
            for (var di = 0; di < rows.length; di++) {
                var dk = (rows[di].startYy || '') + '|' + (rows[di].qterFlag || '');
                if (seen[dk]) continue;
                seen[dk] = 1;
                dedup.push(rows[di]);
            }
            rows = dedup;
            _grdAllData = rows;
            // 보기(화면 진입) → 년도 셀렉트(기본=평가년월 년도)는 그대로 두고,
            // "해당 년도 안의" 최종(최근) 분기만 자동 선택. 그 년도에 자료 없으면 기본 분기 유지
            if (autoLatest) {
                var yy0 = String($("#yearQuarter").val() || '');
                for (var li = 0; li < rows.length; li++) {
                    if (String(rows[li].startYy || '') === yy0) { fn_ApplyGrdData(rows[li]); break; }
                }
                fn_Select();
            }
            fn_RenderGrdList();   // 선택 년도(#yearQuarter) 자료만 표시
            var wrap = document.getElementById("grdListWrap");
            if (wrap) wrap.style.display = 'block';
        },
        error: function(x, s, e) { console.error("selectHospGrdList error:", s, e); }
    });
}
// 그리드 렌더 — 선택 년도(#yearQuarter)의 자료만 표시. 없으면 "해당년도 자료없음" 안내
function fn_RenderGrdList() {
    var tb = document.getElementById("grdListBody");
    if (!tb) return;
    var yy = String($("#yearQuarter").val() || '');
    var rows = [];
    for (var fi = 0; fi < _grdAllData.length; fi++) {
        if (String(_grdAllData[fi].startYy || '') === yy) rows.push(_grdAllData[fi]);
    }
    _grdListData = rows;
    if (!rows.length) {
        tb.innerHTML = '<tr><td colspan="12" style="color:#999; padding:14px;">' + _grdEsc(yy) + '년 저장된 자료가 없습니다.</td></tr>';
        return;
    }
    var html = '';
    for (var i = 0; i < rows.length; i++) {
        var r = rows[i];
        var qlabel = (r.startYy || '') + (r.qterFlag ? '-' + r.qterFlag + '분기' : '');
        html += '<tr style="cursor:pointer;" onclick="fn_ApplyGrdRow(' + i + ')">'
              + '<td>' + _grdEsc(qlabel)     + '</td>'
              + '<td>' + _grdEsc(r.goalJugi) + '</td>'
              + '<td>' + _grdEsc(r.goalChasu)+ '</td>'
              + '<td>' + _grdEsc(r.goalScore)+ '</td>'
              + '<td>' + _grdEsc(r.hospgrade)+ '</td>'
              + '<td>' + _grdEsc(r.patCount) + '</td>'
              + '<td>' + _grdEsc(r.docCount) + '</td>'
              + '<td>' + _grdEsc(r.nurCount) + '</td>'
              + '<td>' + _grdEsc(r.nurSCnt)  + '</td>'
              + '<td>' + _grdEsc(r.phamDays) + '</td>'
              + '<td style="color:#8a97a3;">' + _grdEsc(r.updDttm) + '</td>'
              + '<td><button type="button" class="btn btn-outline-danger" style="padding:0px 8px; font-size:12.5px; line-height:1.7;" '
              + 'onclick="event.stopPropagation(); fn_DeleteGrdRow(' + i + ')">삭제</button></td>'
              + '</tr>';
    }
    tb.innerHTML = html;
}
// 그리드 행 삭제 — 소프트삭제(ACTION_YN='N') 후 그리드 재조회
function fn_DeleteGrdRow(idx) {
    var r = _grdListData[idx];
    if (!r) return;
    var qlabel = (r.startYy || '') + '-' + (r.qterFlag || '') + '분기';
    Swal.fire({
        title: '삭제 확인',
        text: qlabel + ' 자료를 삭제하시겠습니까?',
        icon: 'warning',
        showCancelButton: true,
        confirmButtonText: '삭제',
        cancelButtonText: '취소',
        confirmButtonColor: '#d33',
        width: 300,
        padding: '0.8em',
        customClass: {
            popup: 'swal-compact',
            title: 'swal-compact-title',
            htmlContainer: 'swal-compact-text',
            confirmButton: 'swal-compact-btn',
            cancelButton: 'swal-compact-btn'
        }
    }).then(function(result) {
        if (!result.isConfirmed) return;
        $.ajax({
            type: "POST",
            url: "/user/deleteHospGrd.do",
            data: { hospCd: hospid, startYy: r.startYy, qterFlag: r.qterFlag, updUser: userid },
            dataType: "json",
            success: function(resp) {
                if (resp && resp.result === 'OK') {
                    // [2026-07-03] 삭제 완료 팝업 제거 — 확인 팝업만 띄우고, 완료 시 그리드 갱신으로 대체
                    fn_LoadGrdList(false);   // 그리드 재조회
                } else {
                    Swal.fire({ title: '삭제 실패', text: '삭제 처리에 실패했습니다. 관리자에게 문의해 주세요.', icon: 'error', confirmButtonText: '확인',
                                width: 300, padding: '0.8em',
                                customClass: { popup: 'swal-compact', title: 'swal-compact-title', htmlContainer: 'swal-compact-text', confirmButton: 'swal-compact-btn' } });
                }
            },
            error: function(x, s, e) {
                console.error("deleteHospGrd error:", s, e);
                Swal.fire({ title: '삭제 실패', text: '통신 오류가 발생했습니다.', icon: 'error', confirmButtonText: '확인',
                            width: 300, padding: '0.8em',
                            customClass: { popup: 'swal-compact', title: 'swal-compact-title', htmlContainer: 'swal-compact-text', confirmButton: 'swal-compact-btn' } });
            }
        });
    });
}
// 행 데이터 → 위 폼에 값 적용 (+ 신고분기 셀렉트 세팅)
function fn_ApplyGrdData(r) {
    if (!r) return;
    $("#yearQuarter").val(r.startYy);
    $("#monsQuarter").val(r.qterFlag);
    $("#hospcdGrade").val(r.hospgrade);
    $("#goal_Score").val(r.goalScore);
    $("#goal_Jugi").val(r.goalJugi);
    $("#goal_Chasu").val(r.goalChasu);
    $("#pat_Count").val(r.patCount);
    $("#doc_Count").val(r.docCount);
    $("#nur_Count").val(r.nurCount);
    $("#nursCount").val(r.nurSCnt);
    $("#pham_Days").val(r.phamDays);
}
// 그리드 행 클릭 → 폼 적용 + 행 강조
function fn_ApplyGrdRow(idx) {
    var r = _grdListData[idx];
    if (!r) return;
    fn_ApplyGrdData(r);
    var trs = document.querySelectorAll('#grdListBody tr');
    for (var i = 0; i < trs.length; i++) { trs[i].style.background = (i === idx) ? '#eaf3ff' : ''; }
}


function fn_IndiSelect() {

	jobFlag = '00';
	
	let selected_Year = document.getElementById("year_Select").value;
    let selectedMonth = document.getElementById("monthSelect").value;
    
    defaultCnt = 30;
	page_Hight = 563;
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
	page_Hight = 563;
	colPadding = '2px';   		// 행 높이 간격 설정
	
	datWaiting = false;   		// Data 가져오는 동안 대기상태 Waiting 표시 여부
	page_Navig = false;   		// 페이지 네비게이션 표시여부 
	hd_Sorting = false;   		// Head 정렬(asc,desc) 표시여부
	info_Count = false;   		// 총건수 대비 현재 건수 보기 표시여부 
	searchShow = false;   		// 검색창 Show/Hide 표시여부
	showButton = false;   		// Button (복사, 엑셀, 출력)) 표시여부
	searchShow = false;   		// 검색창 Show/Hide 표시여부
	
	btm_Scroll = true;          // 지표 그리드는 가로 스크롤(scrollX) 사용 — 기본값 복원 (06 뷰 진입 후 false 잔존 방지)
	tableName  = document.getElementById('indicatorTable');

	// ★ 재초기화 방지 — 이미 DataTable 로 초기화된 상태면 먼저 파괴 후 재구성.
	//   (자료생성 완료 후 재진입 / 기존자료 표시(showExisting) 등 fn_CreateData 의 destroy 를
	//    거치지 않는 경로에서 "Cannot reinitialise DataTable" 경고가 뜨던 문제 차단)
	if ($.fn.DataTable.isDataTable('#indicatorTable')) {
		$('#indicatorTable').DataTable().clear().destroy();
	}
	$('#indicatorTable').empty();

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
	_curIndiDtor = parseFloat(data.dtorval) || 0;  // 좌측 지표 분모(대상자수) 저장

	// jobFlag 변경 시 05 상단 버튼 재평가
	if (jobFlag !== '05') {
	    _prevMissingData = [];
	    _errCheckData = [];
	}
	fn_UpdateCath05Buttons();

	// 적정성평가 관련 항목 전월 대비 변경 환자 목록 로드 (각 카테고리 그리드 첫 셀에 ✔ 표시)
	fn_LoadPatvalChangedList();

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
	page_Hight = 563;
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

	// 엑셀/복사/출력 상단 제목 — 전 지표 공통: "지표명 [병원명 · YYYY-MM]" (2026-07-11)
	//   파일명은 "지표명_" + 저장시각(기존 filename 콜백이 시각을 덧붙임)
	var _xhnm = (typeof hospnm !== 'undefined' && hospnm) ? hospnm
	          : (typeof getCookie === 'function' ? (getCookie('s_hospnm') || '') : '');
	excelTitle = data.cate_nm + ' [' + _xhnm + ' · ' + selected_Year + '-' + selectedMonth + ']';
	printTitle = excelTitle;
	copy_Title = excelTitle;
	excelFName = (data.cate_nm || '').replace(/\s+/g, '') + '_';


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
    	// 차등제 화면이 아니면 저장분기 그리드도 숨김
    	var _grdWrapEl = document.getElementById("grdListWrap");
    	if (_grdWrapEl) _grdWrapEl.style.display = 'none';



	   	if (["01", "02", "03", "04"].includes(data.cate_cd)) {
	   		
	   		ltxt.textContent = '분기별 차등제 자료등록 및 연간 목표 등록';
	   		
	   		inputZone.style.display = 'flex';
	   		
	   		
	   		const hideTable = document.getElementById('viewTable');

    		// 차등제(01~04) 화면에서는 우측 그리드(viewTable) 자체를 숨김 처리
    		// DataTable이 초기화되어 있을 때만 destroy 호출 (미초기화 상태에서 .DataTable() 호출 시
    		// 빈 wrapper가 자동 생성되어 inputZone 하단에 "No data available in table" 표시되는 현상 방지)
    		if ($.fn.DataTable.isDataTable('#' + hideTable.id)) {
    			$('#' + hideTable.id).DataTable().clear().destroy();
    		}
    		$('#' + hideTable.id).empty();
    		// 혹시 남아있을 wrapper 처리 — 테이블을 wrapper 밖으로 빼낸 뒤 wrapper 제거
    		// (다음 지표 클릭 시 hideTable 재사용/재초기화 안전성 확보)
    		var _vtWrap = document.getElementById('viewTable_wrapper');
    		if (_vtWrap && _vtWrap.parentNode) {
    			if (hideTable.parentNode === _vtWrap || _vtWrap.contains(hideTable)) {
    				_vtWrap.parentNode.insertBefore(hideTable, _vtWrap);
    			}
    			_vtWrap.parentNode.removeChild(_vtWrap);
    		}
    		hideTable.style.display = 'none';
    	    
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
    	   	
    	    // 보기(화면 진입) → 그리드 로드 후 최종(최근) 분기 자동 선택·표시.
    	    // 저장 자료 없으면 위의 월 기반 기본 분기 그대로 fn_Select() 만 수행됨
    	    fn_LoadGrdList(true);

    	    return;
    	}
    }
    
    // 그리드 기본값: 가로 스크롤(scrollX) 사용. (06 등 일부 cate_cd 에서만 아래에서 false 로 덮어씀)
    btm_Scroll = true;

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
			    		{ data: 'patId',     visible: true,  className: 'dt-body-center', width: '80px'  },
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
    } else if (data.cate_cd === "06") {
    	// scrollX(가로스크롤) 끔 — 2단 colspan 헤더가 줌(90% 초과)에서 본문과 어긋나는 문제를
    	//   원천 차단 (헤더/본문 분리 테이블이 생기지 않아 px 반올림 드리프트 없음).
    	btm_Scroll = false;
    	// 세로스크롤 뷰 높이 — 좌측 지표패널 높이에 맞춰 약 22행만 보이게(≈25.6px/행 → 22행 ≈ 563px). 필요시 값 조정.
    	page_Hight = 563;
    	// 2-row header — 관리항목 (colspan=3) 으로 일정배뇨/방광훈련/규칙적도뇨 묶음.
    	// 폭 절약을 위해 sub-header 는 짧게 (일정/방광/규칙).
    	c_Head_Set = [
    		[
    			{ label: 'No',         rowspan: 2 },
    			{ label: '생년월일',     rowspan: 2 },
    			{ label: '대상자',       rowspan: 2 },
    			{ label: '입원일자',     rowspan: 2 },
    			{ label: '요양개시일',   rowspan: 2 },
    			{ label: '관리<br>여부', rowspan: 2, class: 'noArrow' },
    			{ label: '배뇨<br>계획', rowspan: 2, class: 'noArrow' },
    			{ label: '환자군',       rowspan: 2 },
    			{ label: '배뇨상태',     rowspan: 2 },
    			{ label: '관리항목',     colspan: 3 },
    			{ label: '평가표작성일', rowspan: 2 , class: 'noArrow'}
    		],
    		[
    			{ label: '일정<br>배뇨', class: 'noArrow' },
    			{ label: '방광<br>훈련', class: 'noArrow' },
    			{ label: '규칙<br>도뇨', class: 'noArrow' }
    		]
    	];
    	columnsSet = [
    					/* No — 화면 표시 순번 (정렬 시에도 보이는 순서대로 1,2,3…) */
    					{ data: null, orderable: false, searchable: false, visible: true, className: 'dt-body-center', width: '34px',
    						render: function(data, type, row, meta) {
    							return meta.row + 1;
    						},
    					},
    					{ data: 'patId',     visible: true,  className: 'dt-body-center', width: '66px'  },
					    { data: 'patNm',     visible: true,  className: 'dt-body-center', width: '75px'  },
					    { data: 'admitDt',   visible: true,  className: 'dt-body-center', width: '85px',
						    render: function(data, type, row) {
			        			if (type === 'display') {
			        				return getFormat(data,'d1')
			            		}
			            		return data;
						    },
					    },
					    { data: 'medStart',  visible: true,  className: 'dt-body-center', width: '85px',
							render: function(data, type, row) {
			        			if (type === 'display') {
			        				return getFormat(data,'d1')
			            		}
			            		return data;
						    },
					    },
						{ data: 'manageYn',  visible: true,  className: 'dt-body-center', width: '36px',
						render: function(data, type, row) {
							// 정렬용 값 — 관리(1) → 공란(2) → 제외(3)
							if (type === 'sort' || type === 'type') {
								if (data === 'Y')     return 1;
								if (data === '제외')  return 3;
								return 2;
							}
							if (type === 'display') {
								// SQL 3가지 상태:
								//   'Y'   → "관리" (파란색) — 분자 매칭 환자
								//   ''    → 공란            — 기존 분모이지만 분자 아닌 환자
								//   '제외' → "제외" (회색)  — 추가 표시 환자 (URINE_CTL 0/1 또는 PAT_CLASS='A')
								if (data === 'Y') {
									return '<span style="color:#1565c0;font-weight:bold;">관리</span>';
								}
								if (data === '제외') {
									return '<span style="color:#888;">제외</span>';
								}
								return '';
							}
							return data;
						}
					    },
						/* 배뇨계획 — 분모 대상이나 배뇨관리(①②③) 미실시 → ○ (관리항목 ●=실시 와 대비) */
						{ data: 'planMissYn', visible: true,  className: 'dt-body-center', width: '36px',
							render: function(data, type, row) {
								if (type === 'display') {
									return data === 'X' ? '<span style="color:#000;font-size:16px;">○</span>' : '';
								}
								return data;
							},
						},
						{ data: 'patClass',  visible: true,  className: 'dt-body-center', width: '75px',
							render: function(data, type, row) {
			        			if (type === 'display') {
			        				if (data === 'A') return '의료최고';
			        				if (data === 'B') return '의료고도';
			        				if (data === 'C') return '의료중도';
			        				if (data === 'D') return '의료경도';
			        				if (data === 'E') return '선택입원';
			            		}
			            		return data;
						    },
					    },
						{ data: 'urineCtl',  visible: true,  className: 'dt-body-center', width: '95px',
							render: function(data, type, row) {
			        			if (type === 'display') {
			        				if (data === '0') return '0.조절함';
			        				if (data === '1') return '1.가끔실금';
			        				if (data === '2') return '2.자주실금함';
			        				if (data === '3') return '3.조절못함';
			        				return data || '';
			            		}
			            		return data;
						    },
					    },
					    /* 관리항목 — 일정한 배뇨 (UR_PLAN='1' 인 경우 ● 검정 채움 표시) */
					    { data: 'urPlan',    visible: true,  className: 'dt-body-center', width: '44px',
							render: function(data, type, row) {
			        			if (type === 'display') {
			        				return data === '1' ? '<span style="color:#000;font-size:16px;">●</span>' : '';
			            		}
			            		return data;
						    },
					    },
					    /* 관리항목 — 방광훈련 (BLAD_TRAIN='1') */
					    { data: 'bladTrain', visible: true,  className: 'dt-body-center', width: '44px',
							render: function(data, type, row) {
			        			if (type === 'display') {
			        				return data === '1' ? '<span style="color:#000;font-size:16px;">●</span>' : '';
			            		}
			            		return data;
						    },
					    },
					    /* 관리항목 — 규칙적 도뇨 (REG_CATH='1') */
					    { data: 'regCath',   visible: true,  className: 'dt-body-center', width: '44px',
							render: function(data, type, row) {
			        			if (type === 'display') {
			        				return data === '1' ? '<span style="color:#000;font-size:16px;">●</span>' : '';
			            		}
			            		return data;
						    },
					    },
						{ data: 'docDt',     visible: true,  className: 'dt-body-center', width: '85px',
							render: function(data, type, row) {
			        			if (type === 'display') {
			        				return getFormat(data,'d1')
			            		}
			            		return data;
			  			    },
						}
    				 ];

    	// 초기 data Sort — 빈 배열: SQL ORDER BY (관리→공란→제외, urineCtl, patId) 결과를 그대로 사용.
    	//   DataTables 가 manageYn 을 단순 문자열로 재정렬 ('' → 'Y' → '제외') 하는 문제 회피.
    	//   사용자가 컬럼 헤더를 클릭하면 그때부터 클라이언트 정렬이 동작 (orthogonal sort 의 1/2/3 적용).
    	muiltSorts = [];
    	// Sort여부 표시를 일부만 할 때 개별 id, ** 전체 적용은 '_all'하면 됩니다. ** 전체 적용 안함은 []
    	showSortNo = ['_all'];
    	// Columns 숨김 columnsSet -> visible로 대체함 hideColums 보다 먼제 처리됨 ( visible를 선언하지 않으면 hideColums컬럼 적용됨 )
    	hideColums = [];             // 없으면 []; 일부 컬럼 숨길때
    	txt_Markln = 20;                       				 // 컬럼의 글자수가 설정값보다 크면, 다음은 ...로 표시함
    	// 글자수 제한표시를 일부만 할 때 개별 id, ** 전체 적용은 '_all'하면 됩니다. ** 전체 적용 안함은 []
    	markColums = [];

    } else if (data.cate_cd === "07") {
    	page_Hight = 563;
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
									// (수정) 1단계·치유 케이스는 드레싱(d) 제외, 압력(a)+체위(b)+영양(c) 실시해야 '해당'
									var careABC = ((Number(row.preRelDev)||0) + (Number(row.posChange)||0) + (Number(row.nutSupply)||0)) === 3;
									var condMet = hasPrev && (allCurtZero || curtStep1Is1) && careABC;
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
						    	var careABC = ((Number(rowData.preRelDev)||0) + (Number(rowData.posChange)||0) + (Number(rowData.nutSupply)||0)) === 3;
						    	var condMet = hasPrev && (allCurtZero || curtStep1Is1) && careABC;
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
    	page_Hight = 563;
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
    	page_Hight = 563;
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

	    // viewTable 환자 그리드 — 모든 카테고리(05/07/09/10/11/12/13/14) 맨앞에
	    // "변경" 컬럼 자동 prepend (전월 대비 적정성평가 항목 변경 시 ✔)
	    fn_PrependPatvalChangedColumn();

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
                    const lbl = cell.label || '';
                    // <br> 가 포함된 라벨은 줄바꿈을 살리기 위해 innerHTML 사용
                    if (lbl.indexOf('<br>') !== -1) {
                        th.innerHTML = lbl;
                    } else {
                        th.textContent = lbl;
                    }
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
		// 현재 초기화하려는 테이블이 viewTable 인지 사전 캡처
		// (전역 tableName 은 fn_ViewData setTimeout 종료 후 indicatorTable 로 복원되므로
		//  createdRow 등 비동기 콜백에서는 closure 변수로 판정해야 함)
		var __isViewTable = !!(tableName && tableName.id === 'viewTable');
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
		        		    title: excelTitle,
		        		    // (2026-07-11) 엑셀 전용 방어: 셀 값이 null/undefined 면 엑셀 열너비 계산(.length)에서
		        		    //   TypeError 로 다운로드가 통째로 실패(복사/출력은 정상인 증상) → 빈 문자열 치환 + HTML 태그 제거(✔ 등)
		        		    exportOptions: {
		        		        format: {
		        		            header: function(data) {
		        		                return (data === null || data === undefined) ? '' : String(data).replace(/<[^>]*>/g, '').trim();
		        		            },
		        		            body: function(data) {
		        		                if (data === null || data === undefined) return '';
		        		                if (typeof data !== 'string') return data;
		        		                return data.indexOf('<') !== -1 ? data.replace(/<[^>]*>/g, '').trim() : data;
		        		            }
		        		        }
		        		    }
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
			    // 전월 대비 변경 환자 표시는 첫 컬럼 ✔ 만 사용 — 행 클래스 부여 안 함 (배경 강조 제거)
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

		// viewTable draw 시 적정성평가 변경 마커 재적용 (정렬/페이지/검색 후에도 유지)
		if (__isViewTable) {
			dataTable.off('draw.pvMark').on('draw.pvMark', function() {
				if (typeof fn_ApplyPatvalChangedMark === 'function') {
					fn_ApplyPatvalChangedMark();
				}
			});
		}

		// ─────────────────────────────────────────────────────────────
		// scrollX 헤더 정렬 보정 — 브라우저 줌(90% 초과 등)/창 크기 변경 시
		//   header(scrollHead) 와 body(scrollBody) 의 px 반올림 차이로
		//   2단 colspan 헤더(관리항목 등)가 어긋나는 문제 방지.
		//   → 모든 보이는 DataTable 의 컬럼 폭을 재계산해 헤더-본문 재동기화.
		// ─────────────────────────────────────────────────────────────
		var fn_AdjustAllTables = function() {
			if (!$.fn.dataTable) return;
			try {
				$.fn.dataTable.tables({ visible: true, api: true }).columns.adjust();
			} catch (e) {}
		};
		// 초기 렌더 직후 1회 보정 (이미 줌 상태로 진입한 경우 대비)
		setTimeout(fn_AdjustAllTables, 0);
		// ajax 데이터가 그려진 직후에도 보정 (높은 줌으로 첫 진입 시 헤더 어긋남 방지)
		dataTable.off('init.dtAdjust').on('init.dtAdjust', fn_AdjustAllTables);
		dataTable.off('draw.dtAdjust').on('draw.dtAdjust', fn_AdjustAllTables);
		// 줌/리사이즈 시 디바운스 보정 (네임스페이스로 중복 바인딩 방지)
		$(window).off('resize.dtAdjust').on('resize.dtAdjust', (function() {
			var _t;
			return function() {
				clearTimeout(_t);
				_t = setTimeout(fn_AdjustAllTables, 150);
			};
		})());

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
		    // 클릭된 행이 속한 실제 테이블의 DataTable 인스턴스 사용
		    var _ct = $(this).closest('table').DataTable();
		    var _ctId = $(this).closest('table').attr('id');
		    edit_Data = _ct.row(this).data();
		    if (edit_Data) { showIndiSummary(edit_Data); }
		    // 환자평가표 조회 버튼 활성/비활성 갱신 (우측 그리드일 때만)
		    if (typeof fn_UpdatePatvalBtnState === 'function' && _ctId === 'viewTable') {
		        fn_UpdatePatvalBtnState(edit_Data);
		    }
		});
	    /* 싱글 선택 start */
	    if (row_Select) {
	        dataTable.on('click', 'tbody tr', (e) => {

	        	let classList = e.currentTarget.classList;

	        	// e.currentTarget 행이 속한 실제 테이블의 DataTable 인스턴스를 사용
	        	// (전역 dataTable 변수는 fn_ViewData setTimeout에서 복원되어 다른 테이블을 가리킬 수 있음)
	        	let curTable = $(e.currentTarget).closest('table').DataTable();
	        	let curTableId = $(e.currentTarget).closest('table').attr('id');

	        	// viewTable 행을 클릭한 경우에만 viewTable 내부 선택을 정리
	        	// (좌측 indicatorTable 행 클릭 시에는 viewTable 선택을 건드리지 않음)
	        	if (curTableId === 'viewTable' && !["01", "02", "03", "04"].includes(jobFlag)) {

	        		$('#viewTable tbody tr.selected').removeClass('selected');
	        	}


	            if (!classList.contains('selected')) {
	                curTable.rows('.selected').nodes().each((row) => {
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

	        // viewTable 모든 카테고리 그리드(05/07/09/10/11/12/13/14)에서
	        // 환자 행 더블클릭 시 환자평가표 모달 자동 열기
	        dataTable.off('dblclick.pvOpen').on('dblclick.pvOpen', 'tbody tr', function() {
	            var _ct = $(this).closest('table').DataTable();
	            var rowData = _ct.row(this).data();
	            if (!rowData || !rowData.patId || !rowData.admitDt || !rowData.medStart) return;
	            // 행 selected 처리 + edit_Data 갱신 (fn_ShowPatvalModal 의 _pvGetSelectedRow 가 사용)
	            edit_Data = rowData;
	            $(this).closest('tbody').find('tr.selected').removeClass('selected');
	            $(this).addClass('selected');
	            if (typeof fn_ShowPatvalModal === 'function') fn_ShowPatvalModal();
	        });
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
	            	
	            	
	            	fn_MaskPatNmRows(response);
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
		                let hiTotal  = 0;   // 고위험 전체 인원 (●+○, 헤더 표시용)
		                let lowTotal = 0;   // 저위험 전체 인원 (●+○, 헤더 표시용)
		                for (let i = 0; i < response.data.length; i++) {

		                	const item = response.data[i];

		                    // 헤더 인원수 = 그리드 컬럼에 표시된 인원
		                    //  - 고위험 : ●(Y, 14일초과) + ○(N, 비초과) 전체
		                    //  - 저위험 : ○(N, 비초과)만  (●는 제외)
		                    if (item.dangerHi  === 'Y' || item.dangerHi  === 'N') { hiTotal  += 1; }
		                    if (item.dangerLow === 'N') { lowTotal += 1; }

		                    if (item.overDay === 'Y') {
		                    	dayCount += 1;
		                    	if (item.dangerHi  === 'Y') { hi_Count += 1; }
			                    if (item.dangerLow === 'Y') { lowCount += 1; }
		                    }
		                }

		                cntNote = '[중복포함,14일초과 총:' + dayCount + '건 ]·고위험:' + hi_Count + '건·저위험:' + lowCount + '건';

		                // 그리드 2단 헤더의 고위험/저위험 라벨에 전체 인원수 표기.
		                //  - c_Head_Set 라벨도 갱신(다음 조회/재그리기 대비)
		                //  - 헤더는 이미 fn_HeadColumnSet()에서 그려졌으므로, 그려진 th(스크롤 헤더 복제 포함)를
		                //    callback(그리기) 이후 직접 갱신 (setTimeout 0 → 현재 동기 흐름 종료 후 실행)
		                if (c_Head_Set[1] && c_Head_Set[1][0]) { c_Head_Set[1][0].label = '고위험(' + hiTotal  + ')'; }
		                if (c_Head_Set[1] && c_Head_Set[1][1]) { c_Head_Set[1][1].label = '저위험(' + lowTotal + ')'; }
		                setTimeout(function() {
		                    var ths = document.querySelectorAll('#viewTable_wrapper thead th, #viewTable thead th');
		                    for (var t = 0; t < ths.length; t++) {
		                        var txt = (ths[t].textContent || '').trim();
		                        if (txt === '고위험' || txt.indexOf('고위험(') === 0) { ths[t].textContent = '고위험(' + hiTotal  + ')'; }
		                        if (txt === '저위험' || txt.indexOf('저위험(') === 0) { ths[t].textContent = '저위험(' + lowTotal + ')'; }
		                    }
		                }, 0);

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
	            		let bunmo_Cnt = 0;
	            		let bunja_Cnt = 0;
		                
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
		                    if (item.bunmo === 'O') {
		                    	bunmo_Cnt += 1;
		                    }
		                    if (item.bunja === 'O') {
		                    	bunja_Cnt += 1;
		                    }
		                    
		                }
		                
		                let rate_Txt = bunmo_Cnt > 0 ? (Math.round(bunja_Cnt / bunmo_Cnt * 1000) / 10) + '%' : '-';
		                cntNote = '[중복포함,당뇨 총:' + diab_Cnt + '건 ]·적정:' + appr_Cnt + '건·다음월:' + next_Cnt + '건'
		                        + '·<span style="color:#1565C0;">분모:' + bunmo_Cnt + '·분자:' + bunja_Cnt + '·분율:' + rate_Txt + '</span>';
		                
		                document.getElementById("lab_title").innerHTML = lTitle + nbsp(10) + '<span style="color: blue;">' + cntNote + '</span>';

	                // 좌측 지표 분모(당뇨 대상자)는 있는데 우측 그리드가 0건이면 전월청구 누락 가능성 안내
	                // (select_CategoryList13 은 전월 청구내역 TBL_CHUNG_MST 와 INNER JOIN 하므로
	                //  전월 청구가 없으면 당뇨 환자가 있어도 조회 결과가 0건이 됨)
	                if (_curIndiDtor > 0 && (!response.data || response.data.length === 0)) {
	                    // 제목 아래 인라인 경고박스(prevMonthWarn 스타일) — fn_ViewData 진입 시 자동 제거됨
	                    var _pmOld = document.getElementById('prevMonthWarn'); if (_pmOld) _pmOld.remove();
	                    var _pmHeader = document.getElementById('lab_title');
	                    var _pmCard = document.getElementById('card_container');
	                    var _pmWarn = document.createElement('div');
	                    _pmWarn.id = 'prevMonthWarn';
	                    _pmWarn.className = 'blink';
	                    _pmWarn.style.cssText = 'margin:6px 12px 0; padding:8px 12px; border:1px solid #f5c2c7;'
	                        + 'border-left:4px solid #dc3545; border-radius:4px; background:#fff5f5;'
	                        + 'color:#842029; font-size:12.5px; line-height:1.5;';
	                    _pmWarn.innerHTML = '<i class="fas fa-exclamation-circle" style="color:#dc3545; margin-right:6px;"></i>'
	                        + '좌측 분모(당뇨 대상자)는 있으나 대상자 목록이 <b>0건</b>입니다. '
	                        + '<b style="color:#dc3545;">전월청구 여부를 확인하세요.</b>';
	                    if (_pmHeader && _pmHeader.parentNode && _pmHeader.parentNode.parentNode) {
	                        // card-header 다음(테이블 위)에 삽입
	                        var _pmHdr = _pmHeader.parentNode;
	                        _pmHdr.parentNode.insertBefore(_pmWarn, _pmHdr.nextSibling);
	                    } else if (_pmCard) {
	                        _pmCard.appendChild(_pmWarn);
	                    }
	                }
	            	
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

	            	fn_MaskPatNmRows(response);
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

function _pvIsEmpty(v) {
    if (v === null || v === undefined || v === '') return true;
    // 전체적으로 '0' / '00' 은 '-' 로 (무의미 값)
    var s = String(v).trim();
    return s === '0' || s === '00';
}
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
    var s = String(v).trim();
    // 전체 값에서 '0' 또는 '00' 은 '-' 표시 (무의미 값)
    if (s === '0' || s === '00') return _pvEmptyMark();
    return $('<div>').text(v).html();
}
// _pvTxt 와 동일하나 '0' 점수를 유효값으로 그대로 표시 (예: K-MMSE 0점)
// 빈 값(null/undefined/'') 과 '00' 은 '0' 으로 노출 (그 외 값은 원본 유지)
function _pvTxt0(v) {
    if (v === null || v === undefined || String(v).trim() === '') return '0';
    var s = String(v).trim();
    if (s === '00') s = '0';   // '00' → '0' 케이스만 정규화
    return $('<div>').text(s).html();
}
function _pvDt(v) {
    if (_pvIsEmpty(v)) return _pvEmptyMark();
    var s = String(v).replace(/[^0-9]/g,'');
    if (s.length === 8) return s.substr(0,4) + '-' + s.substr(4,2) + '-' + s.substr(6,2);
    return _pvTxt(v);
}
// HbA1c — 마지막 자리가 소수점 (예: "083" → "8.3 %", "127" → "12.7 %", "100" → "10 %")
function _pvHbA1c(v) {
    if (_pvIsEmpty(v)) return _pvEmptyMark();
    var s = String(v).replace(/[^0-9]/g, '');
    if (s === '' || s === '0' || s === '00' || s === '000') return _pvEmptyMark();
    if (s.length < 2) return $('<div>').text(s + ' %').html();
    var intPart = String(parseInt(s.slice(0, -1), 10));
    var decDigit = s.slice(-1);
    var disp = (decDigit === '0') ? intPart : (intPart + '.' + decDigit);
    return $('<div>').text(disp + ' %').html();
}
// 체중/키 — 마지막 자리(4번째)가 소수점, 단위(unit) 뒤에 표시
// (예: "0610","kg" → "61 kg", "0615","kg" → "61.5 kg", "1680","cm" → "168 cm", "1685","cm" → "168.5 cm")
function _pvDecLast(v, unit) {
    if (_pvIsEmpty(v)) return _pvEmptyMark();
    var s = String(v).replace(/[^0-9]/g, '');
    if (s === '' || /^0+$/.test(s)) return _pvEmptyMark();
    var u = unit ? (' ' + unit) : '';
    if (s.length < 2) return $('<div>').text(s + u).html();
    var intPart = String(parseInt(s.slice(0, -1), 10));
    var decDigit = s.slice(-1);
    var disp = (decDigit === '0') ? intPart : (intPart + '.' + decDigit);
    return $('<div>').text(disp + u).html();
}
// 상단 환자ID 마스킹 (앞뒤 모두 * 처리: ******-*******)
function _pvMaskPatId(v) {
    if (_pvIsEmpty(v)) return _pvEmptyMark();
    var s = String(v).replace(/-/g,'').trim();
    if (s.length < 7) return $('<div>').text(new Array(s.length + 1).join('*')).html();
    return $('<div>').text('******-*******').html();
}

/* ============================================================
   환자평가표 전월 비교 — 적정성평가 관련 항목 변경 시 파란색 표시
   대상: D.신체기능(ADL), E·F 유치도뇨관 삽입/삽입기간,
         F.당뇨 HbA1c 검사여부, I.1~I.4 욕창(압박성궤양),
         I.5 피부문제 처치
   ============================================================ */
var _PV_PREV = null;
// 전월 대비 적정성평가 관련 항목 변경 환자 키셋 ("patId|admitDt|medStart")
var _PV_CHANGED_SET = {};

function _pvChangedKey(patId, admitDt, medStart) {
    // 그리드 SQL(select_CategoryListNN)이 LEFT(PAT_ID,6) 로 patId 를 6자리(생년월일)로
    // 잘라 반환하므로, 비교 키도 항상 첫 6자로 정규화한다
    var pid = String(patId || '').replace(/-/g,'').substring(0, 6);
    return pid + '|' +
           String(admitDt || '').replace(/-/g,'') + '|' +
           String(medStart || '').replace(/-/g,'');
}

// 워너넷 사용자 여부 — 사이드바/대시보드/total_Report 등과 동일한 컨벤션:
//   `s_wnn_yn` 쿠키 = 'Y'       → 위너넷 사용자(로그인 시 설정)
//   `s_winconect` 쿠키 = 'Y'    → 병원 검색 후 위너넷처럼 연결된 상태
// (전월 변경 ✔ 표시는 위너넷에게만 노출 — 병원 사용자에겐 의미 없는 정보이고 혼선 방지)
//
// 디버그: 콘솔에서 `_debugWinnerCheck()` 호출 → 쿠키 값/판별결과 출력.
function _isWinnerUser() {
    try {
        var w = (getCookie("s_wnn_yn")    || '').trim();
        var c = (getCookie("s_winconect") || '').trim();
        return w === 'Y' || c === 'Y';
    } catch (e) { return false; }
}
// 진단 — 브라우저 DevTools 콘솔에서 호출하여 현재 값 확인
window._debugWinnerCheck = function () {
    var w = '', c = '';
    try { w = getCookie("s_wnn_yn")    || ''; } catch (e) { w = '(err: ' + e.message + ')'; }
    try { c = getCookie("s_winconect") || ''; } catch (e) { c = '(err: ' + e.message + ')'; }
    var info = {
        cookie_s_wnn_yn:    w,
        cookie_s_winconect: c,
        isWinnerUser:       _isWinnerUser(),
        meaning: _isWinnerUser() ? '위너넷(체크표시 ✔ 노출)' : '병원 사용자(체크표시 숨김)'
    };
    console.table(info);
    return info;
};

// viewTable 의 c_Head_Set / columnsSet 맨 앞에 "변경(✔)" 컬럼 prepend
//   - 헤더는 공백, 폭 최소화 — 체크박스만 표시
//   - 전월 대비 적정성평가 5개 분류(D.ADL / E·F.유치도뇨관 / F.HbA1c / I.욕창 / I.피부처치) 변경 환자에 ✔
//   - c_Head_Set 이 1행 헤더(string[]) / 2행 헤더(object[][]) 모두 대응
//   - 워너넷 사용자가 아니면 ✔ 마크 렌더링 자체를 스킵 (컬럼 자리는 유지 — 헤더 폭 영향 최소화)
function fn_PrependPatvalChangedColumn() {
    if (typeof c_Head_Set === 'undefined' || typeof columnsSet === 'undefined') return;
    if (!Array.isArray(c_Head_Set) || !Array.isArray(columnsSet)) return;
    // 이미 변경 컬럼이 prepend 되어 있으면 skip (중복 방지)
    if (columnsSet.length > 0 && columnsSet[0] && columnsSet[0]._isPvChanged) return;

    // 헤더 prepend — 공백 라벨 + 좁은 폭
    if (c_Head_Set.length > 0 && Array.isArray(c_Head_Set[0])) {
        var rowSpan = c_Head_Set.length;
        c_Head_Set[0] = [{ label: '', rowspan: rowSpan, class: 'pv-chk-th' }].concat(c_Head_Set[0]);
    } else {
        c_Head_Set = [''].concat(c_Head_Set);
    }

    // 컬럼 정의 prepend — patId/admitDt/medStart 매칭 시 ✔ 렌더
    columnsSet = [{
        _isPvChanged: true,
        data: null,
        orderable: false,
        searchable: false,
        className: 'dt-body-center pv-chk-cell',
        width: '24px',
        render: function(data, type, row) {
            if (type !== 'display') return '';
            // 워너넷 사용자가 아니면 ✔ 표시 안함 (s_mainfg='3'/'4' = 병원 사용자)
            if (!_isWinnerUser()) return '';
            if (!row || !row.patId) return '';
            try {
                var key = _pvChangedKey(row.patId, row.admitDt, row.medStart);
                if (_PV_CHANGED_SET[key]) {
                    return '<span title="전월 대비 적정성평가 항목 변경" ' +
                           'style="color:#1565c0;font-weight:900;font-size:13px;">&#10004;</span>';
                }
            } catch (e) {}
            return '';
        }
    }].concat(columnsSet);
}

function fn_LoadPatvalChangedList() {
    _PV_CHANGED_SET = {};
    // 워너넷 사용자가 아니면 변경 ✔ 표시 안 하므로 AJAX 호출 자체 스킵 (서버 부하 절감)
    if (!_isWinnerUser()) return;
    var selYear  = document.getElementById('year_Select');
    var selMonth = document.getElementById('monthSelect');
    if (!selYear || !selMonth) return;
    var jobYymm = selYear.value + selMonth.value;
    if (!hospid || !jobYymm || jobYymm.length !== 6) return;
    $.ajax({
        url: '/main/select_PatvalChangedList.do',
        type: 'POST',
        data: { hospCd: hospid, jobYymm: jobYymm },
        dataType: 'json',
        success: function(res) {
            var rows = (res && res.data) ? res.data : [];
            var set = {};
            for (var i = 0; i < rows.length; i++) {
                var r = rows[i];
                set[_pvChangedKey(r.patId, r.admitDt, r.medStart)] = true;
            }
            _PV_CHANGED_SET = set;
            // viewTable 이 이미 그려져 있다면 즉시 재적용 (전역 tableName 은 fn_ViewData 종료 후 indicatorTable 로
            // 복원되므로 isDataTable 만으로 판정)
            try {
                if ($.fn.DataTable.isDataTable('#viewTable')) {
                    // 첫 컬럼(변경 ✔) 셀을 다시 그리도록 invalidate + 마커 재적용
                    $('#viewTable').DataTable().rows().invalidate('data').draw(false);
                    fn_ApplyPatvalChangedMark();
                }
            } catch (e) {}
        },
        error: function() { _PV_CHANGED_SET = {}; }
    });
}

// 변경 환자 표시는 첫 컬럼 ✔ 로만 처리 — 행 배경 강조 제거됨.
// 잔존 마커 클래스가 있으면 정리만 수행 (no-op 호출자 호환용)
function fn_ApplyPatvalChangedMark() {
    if (!$.fn.DataTable.isDataTable('#viewTable')) return;
    $('#viewTable tbody tr.pv-changed-row').removeClass('pv-changed-row');
}

function _pvNorm(v) {
    if (v === null || typeof v === 'undefined') return '';
    return String(v).trim();
}
function _pvIsDiff(curVal, prevVal) {
    // prev 데이터 자체가 없으면 비교 안함
    if (!_PV_PREV) return false;
    return _pvNorm(curVal) !== _pvNorm(prevVal);
}
// 변경된 값 표시 — html(현재값 렌더링 결과), prevDisp(전월 표시값), groupTitle(클릭 시 보여줄 분류명)
function _pvDiffWrap(html, prevDisp, groupTitle) {
    var pHtml  = $('<div>').text(_pvIsEmpty(prevDisp) ? '없음' : prevDisp).html();
    var gHtml  = $('<div>').text(groupTitle || '').html();
    return '<span class="pv-diff" title="전월 → ' + pHtml + ' (클릭: 이전 내용 보기)" ' +
           'data-prev="' + pHtml + '" data-group="' + gHtml + '">' + html + '</span>';
}
// Y/N 비교
function _pvDiffYn(cur, prev, groupTitle) {
    var html = _pvYn(cur);
    if (!_pvIsDiff(cur, prev)) return html;
    var prevTxt = (cur === prev) ? '' : (
        _pvIsEmpty(prev) ? '미입력' : ('값: ' + _pvNorm(prev))
    );
    return _pvDiffWrap(html, prevTxt, groupTitle);
}
// 코드 비교 (codeGroup → 매핑)
// hideCode=true 이면 전월값 팝오버에 코드 숫자 없이 설명 텍스트만 표시
function _pvDiffCd(codeGroup, cur, prev, groupTitle, hideCode) {
    var html = _pvCd(codeGroup, cur);
    if (!_pvIsDiff(cur, prev)) return html;
    var map = _PV_CODES[codeGroup] || {};
    var prevDesc;
    if (hideCode) {
        prevDesc = map[String(prev)] ? map[String(prev)] : (_pvIsEmpty(prev) ? '미입력' : _pvNorm(prev));
    } else {
        prevDesc = map[String(prev)] ? (_pvNorm(prev) + ' : ' + map[String(prev)]) : (_pvIsEmpty(prev) ? '미입력' : _pvNorm(prev));
    }
    return _pvDiffWrap(html, prevDesc, groupTitle);
}
// 일반 텍스트 비교
function _pvDiffTxt(cur, prev, groupTitle) {
    var html = _pvTxt(cur);
    if (!_pvIsDiff(cur, prev)) return html;
    var prevDisp = _pvIsEmpty(prev) ? '미입력' : _pvNorm(prev);
    return _pvDiffWrap(html, prevDisp, groupTitle);
}
// HbA1c 비교 (083 → 8.3 % 변환 후 비교)
function _pvDiffHbA1c(cur, prev, groupTitle) {
    var html = _pvHbA1c(cur);
    if (!_pvIsDiff(cur, prev)) return html;
    var prevDisp = _pvIsEmpty(prev) ? '미입력' : ($('<div>').html(_pvHbA1c(prev)).text() || _pvNorm(prev));
    return _pvDiffWrap(html, prevDisp, groupTitle);
}

// 변경 표시(.pv-diff) 클릭 시 전월값 팝오버
function _pvBindDiffClick() {
    $(document).off('click.pvDiff').on('click.pvDiff', '.pv-diff', function(e) {
        e.stopPropagation();
        var prev = $(this).data('prev') || '없음';
        var grp  = $(this).data('group') || '';
        // 기존 팝오버 제거
        $('.pv-diff-pop').remove();
        var $pop = $('<div class="pv-diff-pop"></div>')
            .css({
                position: 'absolute', zIndex: 99999,
                background: '#1e3c72', color: '#fff',
                padding: '8px 12px', borderRadius: '6px',
                fontSize: '12.5px', lineHeight: '1.5',
                boxShadow: '0 4px 12px rgba(0,0,0,0.25)',
                maxWidth: '320px', whiteSpace: 'normal'
            })
            .html('<div style="font-weight:700;font-size:11.5px;opacity:0.85;margin-bottom:3px;">' + $('<div>').text(grp).html() + ' — 전월</div>' +
                  '<div>' + $('<div>').text(prev).html() + '</div>');
        var off = $(this).offset();
        $pop.css({ top: (off.top + $(this).outerHeight() + 4) + 'px', left: off.left + 'px' });
        $('body').append($pop);
        // 다른 곳 클릭 시 닫기
        setTimeout(function() {
            $(document).one('click.pvDiffClose', function() { $('.pv-diff-pop').remove(); });
        }, 0);
    });
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
        pvBtn.title = '행 더블클릭으로도 열 수 있습니다';
        pvBtn.onclick = function() { fn_ShowPatvalModal(); };
        pvBtn.innerHTML = '<i class="fas fa-clipboard-list patval-icon"></i><span class="patval-label">환자평가표&nbsp;조회</span>';
    } else {
        pvBtn.title = '행 더블클릭으로도 열 수 있습니다';
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
    // 직전 환자 비교 데이터 초기화
    _PV_PREV = null;
    if (!document.getElementById('patvalModalStyle')) {
        var st = document.createElement('style');
        st.id = 'patvalModalStyle';
        st.innerHTML =
            '.pv-head { display:flex; flex-wrap:wrap; gap:14px 24px; padding:14px 18px; margin-bottom:12px; border-radius:8px;' +
            '  background:linear-gradient(135deg,#1e3c72 0%,#2a5298 100%); color:#fff; box-shadow:0 3px 10px rgba(30,60,114,0.25); }' +
            '.pv-head-item { font-size:13px; line-height:1.5; display:flex; align-items:center; gap:8px; }' +
            '.pv-head-item .lbl { opacity:0.8; font-size:11.5px; letter-spacing:0.3px; text-transform:uppercase; }' +
            '.pv-head-item .val { font-weight:600; font-size:13.5px; background:rgba(255,255,255,0.15); padding:3px 10px; border-radius:4px; font-family:Consolas,monospace; }' +
            '.pv-tabs { display:flex; align-items:stretch; border-bottom:2px solid #e4e7ed; margin-bottom:14px; gap:2px; flex-wrap:wrap; }' +
            '.pv-tab  { cursor:pointer; padding:10px 18px; font-size:13px; font-weight:600; color:#6b7280; background:transparent;' +
            '  border:none; border-bottom:3px solid transparent; transition:all 0.18s ease; border-radius:4px 4px 0 0;' +
            '  line-height:1.4; text-align:left; white-space:normal; }' +
            '.pv-tab:hover { color:#2a5298; background:#f5f8fc; }' +
            '.pv-tab.active { color:#1e3c72; border-bottom-color:#2a5298; background:#f5f8fc; }' +
            '.pv-tab-break { flex-basis:100%; height:0; margin:0; padding:0; }' +
            /* E·F 탭처럼 라벨이 긴 탭은 같은 줄의 남은 가로 공간을 모두 채우도록 flex-grow */
            '.pv-tab-wide { flex:1 1 0; min-width:0; }' +
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
            '.pv-cd-v { color:#2c3e50; font-weight:500; font-size:12.5px; }' +
            /* D. 신체기능(ADL) 섹션 — 코드 숫자 숨김 (변경 표시는 .pv-diff 가 텍스트 전체에 적용되므로 글자 앞에 ⚠ 표시) */
            '.pv-adl .pv-cd-k { display:none !important; }' +
            '.pv-adl .pv-cd { gap:0; }' +
            '.pv-diff { color:#d32f2f !important; font-weight:800 !important; cursor:pointer; border-bottom:2px solid #d32f2f; padding:1px 4px; background:#fff3f3; border-radius:3px; }' +
            '.pv-diff:hover { background:#ffebee; box-shadow:0 0 0 1px #d32f2f; }' +
            '.pv-diff .pv-cd-k, .pv-diff .pv-cd-v, .pv-diff .pv-empty { color:#d32f2f !important; }' +
            '.pv-diff::before { content:"\\26A0"; margin-right:4px; font-size:11px; color:#d32f2f; vertical-align:middle; }' +
            /* 변경 항목 포함 탭 — 빨간 글자 + 우측 상단 ⚠ 배지 */
            '.pv-tab.pv-tab-changed { color:#d32f2f !important; font-weight:800 !important; position:relative; }' +
            '.pv-tab.pv-tab-changed::after { content:"\\26A0"; position:absolute; top:4px; right:4px; font-size:10px; color:#d32f2f; }' +
            '.pv-tab.pv-tab-changed.active { color:#b71c1c !important; border-bottom-color:#d32f2f !important; background:#fff3f3 !important; }';
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
                    // 전월 비교용 직전 행 (있으면 전역에 저장)
                    var p = (res && res.prev) ? res.prev : null;
                    _PV_PREV = _pvNormalizeKeys(p) || null;
                    Swal.update({ html: _pvBuildHtml(d, row) });
                    _pvBindTabs();
                    _pvBindDiffClick();
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
    // 변경 항목 포함 탭에 빨간 표시 마킹
    _pvMarkChangedTabs();
}

// 각 탭 페인 안에 .pv-diff 엘리먼트가 있으면 해당 탭 버튼에 pv-tab-changed 클래스 부여
function _pvMarkChangedTabs() {
    $('.pv-tab').removeClass('pv-tab-changed');
    $('.pv-pane').each(function() {
        var tgt = $(this).data('tab');
        if ($(this).find('.pv-diff').length > 0) {
            $('.pv-tab[data-tab="' + tgt + '"]').addClass('pv-tab-changed');
        }
    });
}

function _pvBuildHtml(d, row) {
    d = d || {};
    var header = '' +
        '<div class="pv-head">' +
        '  <div class="pv-head-item"><span class="lbl">환자ID</span><span class="val">' + _pvMaskPatId(d.patId || row.patId) + '</span></div>' +
        '  <div class="pv-head-item"><span class="lbl">성명</span><span class="val">' + _pvTxt(fn_NameMask(d.patNm || row.patNm)) + '</span></div>' +
        '  <div class="pv-head-item"><span class="lbl">입원일</span><span class="val">' + _pvDt(d.admitDt || row.admitDt) + '</span></div>' +
        '  <div class="pv-head-item"><span class="lbl">요양개시일</span><span class="val">' + _pvDt(d.medStart || row.medStart) + '</span></div>' +
        '  <div class="pv-head-item"><span class="lbl">작성일</span><span class="val">' + _pvDt(d.docDt) + '</span></div>' +
        '  <div class="pv-head-item"><span class="lbl">평가구분</span><span class="val">' + (d.evalType ? $('<div>').text(d.evalType + (_PV_CODES.evalType[d.evalType] ? ' · ' + _PV_CODES.evalType[d.evalType] : '')).html() : '-') + '</span></div>' +
        '  <div class="pv-head-item"><span class="lbl">서식버전</span><span class="val">' + _pvTxt(d.clformVer) + '</span></div>' +
        '</div>';

    if (!d || !d.patId) {
        return header + '<div style="padding:30px 10px;text-align:center;color:#8891a3;">TBL_PATVAL_MST 데이터가 없습니다.</div>';
    }

    var errBadges = _pvErrorBadges(d.patId || row.patId);

    // 전월 비교 안내 (직전 행 있을 때만)
    var prevNotice = '';
    if (_PV_PREV && _PV_PREV.medStart) {
        prevNotice = '<div style="margin:8px 0; padding:8px 12px; background:#fff3f3; border-left:4px solid #d32f2f; border-radius:4px; font-size:12.5px; color:#b71c1c;">' +
                     '<i class="fas fa-exclamation-triangle" style="margin-right:6px;"></i>' +
                     '전월(' + _pvDt(_PV_PREV.medStart) + ') 대비 적정성평가 관련 항목 변경 시 <b style="color:#d32f2f;">빨간색 ⚠</b>으로 표시됩니다. (값 클릭 시 전월 내용 표시)' +
                     '</div>';
    }

    var tabs =
        '<div class="pv-tabs">' +
        '  <button class="pv-tab active" data-tab="t1">A. 일반사항</button>' +
        '  <button class="pv-tab"        data-tab="t2">B·C·D. 의식/인지/신체</button>' +
        '  <button class="pv-tab"        data-tab="t3">E·F. 배설기능/질병진단</button>' +
        '  <button class="pv-tab"        data-tab="t4">G·H·I. 건강/영양/피부</button>' +
        '  <button class="pv-tab"        data-tab="t5">J·K·L. 투약/특수처치</button>' +
        '</div>';

    return '<div style="text-align:left; max-height:70vh; overflow:auto; padding:2px 4px;">' +
           header + prevNotice + errBadges + tabs +
           _pvTab1(d) + _pvTab2(d) + _pvTab3(d) + _pvTab4(d) + _pvTab5(d) +
           '</div>';
}

function _pvSec(title, icon, items) {
    var cells = '';
    for (var i = 0; i < items.length; i++) {
        var vHtml = items[i][1];
        cells += '<div class="pv-cell"><span class="k">' + items[i][0] + '</span><span class="v">' + vHtml + '</span></div>';
    }
    var iconHtml = icon ? '<i class="fas ' + icon + '"></i>' : '';
    return '<div class="pv-sec"><div class="pv-sec-hd">' + iconHtml + title + '</div><div class="pv-grid">' + cells + '</div></div>';
}

function _pvTab1(d) {
    var s1 = _pvSec('A. 일반사항', 'fa-user', [
        ['환자성명', _pvTxt(fn_NameMask(d.patNm))], ['주민등록번호', _pvMaskPatId(d.patId)],
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
        ['K-MMSE 실시여부', _pvYn(d.mmseYn)], ['K-MMSE 점수', _pvTxt0(d.mmseScore)], ['K-MMSE 검사일', _pvDt(d.mmseDt)],
        ['CDR 실시여부', _pvYn(d.cdrYn)],   ['CDR 점수',   _pvTxt(d.cdrScore)],  ['CDR 검사일',  _pvDt(d.cdrDt)],
        ['GDS 실시여부', _pvYn(d.gdsYn)],   ['GDS 점수',   _pvTxt(d.gdsScore)],  ['GDS 검사일',  _pvDt(d.gdsDt)]
    ]);
    var p = _PV_PREV || {};
    var gAdl = 'D. 신체기능(ADL)';
    var s4 = '<div class="pv-adl">' + _pvSec('D. 신체기능 척도(1 완전자립 · 2 감독필요 · 3 약간도움 · 4 상당도움 · 5 전적도움 · 5 행위 발생안함)', '', [
        ['옷벗고 입기', _pvDiffCd('adl', d.dressing, p.dressing, gAdl, true)], ['세수하기', _pvDiffCd('adl', d.washing, p.washing, gAdl, true)],
        ['양치질하기', _pvDiffCd('adl', d.brushing, p.brushing, gAdl, true)], ['목욕하기', _pvDiffCd('adl', d.bathing, p.bathing, gAdl, true)],
        ['식사하기', _pvDiffCd('adl', d.eating, p.eating, gAdl, true)], ['체위변경하기', _pvDiffCd('adl', d.movePos, p.movePos, gAdl, true)],
        ['일어나 앉기', _pvDiffCd('adl', d.sitUp, p.sitUp, gAdl, true)], ['옮겨앉기', _pvDiffCd('adl', d.transfer, p.transfer, gAdl, true)],
        ['방밖으로 나오기', _pvDiffCd('adl', d.exitRoom, p.exitRoom, gAdl, true)], ['화장실 사용하기', _pvDiffCd('adl', d.toiletUse, p.toiletUse, gAdl, true)],
        ['와상상태', _pvDiffYn(d.bedridden, p.bedridden, gAdl)]
    ]) + '</div>';
    return '<div class="pv-pane" data-tab="t2">' + s1 + s2 + s3 + s4 + '</div>';
}

function _pvTab3(d) {
    var p = _PV_PREV || {};
    var gCath = 'E·F. 유치도뇨관 삽입/삽입기간';
    var s1 = _pvSec('E. 배설기능 / 배변조절 기구 및 프로그램', 'fa-tint', [
        ['대변조절', _pvCd('bowelCtl', d.bowelCtl)], ['소변조절', _pvCd('urineCtl', d.urineCtl)],
        ['일정하게 짜여진 배뇨계획', _pvYn(d.urPlan)], ['방광 훈련 프로그램', _pvYn(d.bladTrain)],
        ['규칙적 도뇨', _pvYn(d.regCath)], ['외부(콘돔형) 카테터', _pvYn(d.extCath)],
        ['패드, 팬티형 기저귀', _pvYn(d.padDiaper)], ['인공루', _pvYn(d.artifUr)],
        ['유치도뇨관 삽입', _pvDiffYn(d.indwellCath, p.indwellCath, gCath)], ['해당사항 없음', _pvYn(d.catNoa)],
        ['배뇨일지 작성 여부', _pvYn(d.diaryCreated)], ['배뇨일지 작성일수', _pvTxt(d.diaryDays)],
        ['삽입기간(g-1~g-10 제외)', _pvDiffTxt(d.catDur, p.catDur, gCath)]
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

    var gDM = 'F.1.a 당뇨 — HbA1c 검사 실시여부';
    var s3 = _pvSec('F.1.a 당뇨 / 혈당 / HbA1c', 'fa-vial', [
        ['당뇨', _pvYn(d.diabetes)], ['혈당검사 실시여부', _pvYn(d.bldSugarTest)],
        ['공복시 혈당 (mg/dl)', _pvTxt(d.fastingSugar)], ['식후2시간 혈당 (mg/dl)', _pvTxt(d.post2hSugar)],
        ['HbA1c검사 실시여부', _pvDiffYn(d.hba1cTest, p.hba1cTest, gDM)], ['HbA1c (%)', _pvDiffHbA1c(d.hba1cValue, p.hba1cValue, gDM)],
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
    var p = _PV_PREV || {};
    var gUlcer = 'I.1~I.4 욕창(압박성 궤양)';
    var gSkin  = 'I.5 피부문제에 대한 처치';
    var s1 = _pvSec('F.2 영양관련 장애 / H. 구강 및 영양상태', 'fa-apple-alt', [
        ['콰시오르코르(E40)', _pvYn(d.kwashE40)], ['영양성 소모증(E41)', _pvYn(d.nutrE41)],
        ['소모성 콰시오르코르(E42)', _pvYn(d.wasteKwE42)],
        ['상세불명의 중증 단백질-에너지 영양실조(E43)', _pvYn(d.sevMalE43)],
        ['중등도 및 경도의 단백질-에너지 영양실조(E44)', _pvYn(d.modMalE44)],
        ['단백질-에너지 영양실조로 인한 발육지연(E45)', _pvYn(d.growthDE45)],
        ['상세불명의 단백질-에너지 영양실조(E46)', _pvYn(d.malUnkE46)],
        ['해당사항 없음', _pvYn(d.nutrNoa)],
        ['삼키기', _pvYn(d.swallow)],
        ['체중 측정여부', _pvYn(d.weigHeigYn)], ['체중(kg)', _pvDecLast(d.weig, 'kg')], ['체중 측정일', _pvDt(d.weigDt)],
        ['체중감소', _pvCd('weigLoss', d.weigLoss)], ['키 측정여부', _pvYn(d.heigYn)],
        ['키(cm)', _pvDecLast(d.heigSec, 'cm')], ['키 측정일', _pvDt(d.heigDt)],
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
        ['욕창(압박성 궤양) 1단계', _pvDiffTxt(d.prUlcer1, p.prUlcer1, gUlcer)], ['욕창(압박성 궤양) 2단계', _pvDiffTxt(d.prUlcer2, p.prUlcer2, gUlcer)],
        ['욕창(압박성 궤양) 3단계', _pvDiffTxt(d.prUlcer3, p.prUlcer3, gUlcer)], ['욕창(압박성 궤양) 4단계', _pvDiffTxt(d.prUlcer4, p.prUlcer4, gUlcer)],
        ['울혈/허혈성 궤양 1단계', _pvDiffTxt(d.ciUl1, p.ciUl1, gUlcer)], ['울혈/허혈성 궤양 2단계', _pvDiffTxt(d.ciUl2, p.ciUl2, gUlcer)],
        ['울혈/허혈성 궤양 3단계', _pvDiffTxt(d.ciUl3, p.ciUl3, gUlcer)], ['울혈/허혈성 궤양 4단계', _pvDiffTxt(d.ciUl4, p.ciUl4, gUlcer)],
        ['새로 발생한 욕창 유무', _pvDiffCd('newUlcer', d.newUlcer, p.newUlcer, gUlcer)], ['발생일', _pvDt(d.ulcerDt)],
        ['욕창(압박성 궤양) 과거력', _pvDiffCd('pastUlcer', d.pastUlcer, p.pastUlcer, gUlcer)],
        ['2도 이상의 화상', _pvDiffYn(d.skinProb, p.skinProb, gUlcer)],
        ['개방성 피부병변', _pvDiffYn(d.openSkinLes, p.openSkinLes, gUlcer)], ['수술 창상', _pvDiffYn(d.surgWound, p.surgWound, gUlcer)],
        ['발의 감염', _pvDiffYn(d.footInfec, p.footInfec, gUlcer)], ['해당사항 없음', _pvYn(d.skinNoa)]
    ]);
    var s5 = _pvSec('I.5 피부문제에 대한 처치', 'fa-hand-holding-medical', [
        ['압력을 줄여주는 도구 사용', _pvDiffYn(d.pressRelDev, p.pressRelDev, gSkin)], ['체위변경', _pvDiffYn(d.posChange, p.posChange, gSkin)],
        ['피부문제 해결을 위한 영양공급', _pvDiffYn(d.nutrSkin, p.nutrSkin, gSkin)],
        ['피부궤양 드레싱', _pvDiffYn(d.skinUlcDres, p.skinUlcDres, gSkin)],
        ['피부궤양 드레싱 부위 : 발', _pvDiffYn(d.footDres, p.footDres, gSkin)],
        ['피부궤양 드레싱 부위 : 발 이외', _pvDiffYn(d.nonFootDres, p.nonFootDres, gSkin)],
        ['피부궤양 이외의 드레싱', _pvDiffYn(d.nonUlcDres, p.nonUlcDres, gSkin)],
        ['드레싱 부위 : 발', _pvDiffYn(d.leg, p.leg, gSkin)],
        ['드레싱 부위 : 발 이외', _pvDiffYn(d.legOther, p.legOther, gSkin)],
        ['수술창상 치료', _pvDiffYn(d.surWndCare, p.surWndCare, gSkin)],
        ['화상관련 처치', _pvDiffYn(d.burnTreat, p.burnTreat, gSkin)], ['해당사항 없음', _pvYn(d.fskinNoa)]
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
    var s3 = _pvSec('K.2 전문재활치료', 'fa-signature', [
        ['전문재활치료 실시일수', _pvTxt(d.vitalRehab)]
    ]);
    return '<div class="pv-pane" data-tab="t5">' + s1 + s2 + s3 + '</div>';
}


</script>
<!-- ============================================================== -->
<!-- DataTable 설정 End -->
<!-- ============================================================== -->


	  
<script type="text/javascript">

// =====================================================================
// 2024년(2주기 6차) 적정성평가 지표별 표준화 점수 구간 및 가중치 — 조회 팝업
//   상단 "2024년 표준화구간" 버튼(btnStdRange) 클릭 시 호출.
//   엑셀(지표별_표준화점수구간_가중치) 원본을 흰바탕·검은글자 표로 표시.
// =====================================================================
var _STD_RANGE_TITLE = '2024년(2주기 6차) 적정성평가 지표별 표준화 점수 구간 및 가중치';
// 양식(ver1.0) 컬럼: 구분 | 지표 | 가중치점수 | 표준화[구간 | 점수] | 산출점수
//   - weight : 가중치 점수
//   - rows   : [표준화구간(5~1), 점수(측정범위)]  (산출점수 = weight/5*구간 으로 계산)
var _STD_RANGE_DATA = [
    { gubun:'구조지표', indi:'의사 1인당 환자 수',        weight:8.5,
      rows:[[5,'26명 미만'],[4,'26~30명'],[3,'30~34명'],[2,'34~38명'],[1,'38명 이상']] },
    { gubun:'구조지표', indi:'간호사 1인당 환자 수',       weight:8.5,
      rows:[[5,'6명 미만'],[4,'6~9명'],[3,'9~12명'],[2,'12~15명'],[1,'15명 이상']] },
    { gubun:'구조지표', indi:'간호인력 1인당 환자 수',     weight:7.5,
      rows:[[5,'3명 미만'],[4,'3~4명'],[3,'4~5명'],[2,'5~6명'],[1,'6명 이상']] },
    { gubun:'구조지표', indi:'약사 재직일수율',            weight:5.5,
      rows:[[5,'100%'],[4,'80~100%'],[3,'60~80%'],[2,'40~60%'],[1,'40% 미만']] },
    { gubun:'과정지표', indi:'유치도뇨관이 있는 환자분율', weight:6,
      rows:[[5,'0.5% 미만'],[4,'0.5~1.5%'],[3,'1.5~2.5%'],[2,'2.5~3.5%'],[1,'3.5% 이상']] },
    { gubun:'과정지표', indi:'항정신성의약품 처방률',      weight:3,
      rows:[[5,'0.2PI 미만'],[3,'0.2~1.6PI'],[1,'1.6PI 이상']] },
    { gubun:'과정지표', indi:'의약품안전사용서비스(DUR) 점검률', weight:3,
      rows:[[5,'97% 이상'],[4,'92~97%'],[3,'87~92%'],[2,'82~87%'],[1,'82% 미만']] },
    { gubun:'과정지표', indi:'욕창 처치를 실시한 환자분율', weight:2,
      rows:[[5,'95% 이상'],[4,'85~95%'],[3,'75~85%'],[2,'65~75%'],[1,'65% 미만']] },
    { gubun:'결과지표', indi:'욕창이 새로 생긴 환자분율',  weight:4.4,
      rows:[[5,'0.25% 미만'],[4,'0.25~0.5%'],[3,'0.5~0.75%'],[2,'0.75~1%'],[1,'1.0% 이상']] },
    { gubun:'결과지표', indi:'욕창 개선 환자분율',         weight:17.6,
      rows:[[5,'60% 이상'],[4,'45~60%'],[3,'30~45%'],[2,'15~30%'],[1,'15% 미만']] },
    { gubun:'결과지표', indi:'일상생활수행능력(ADL) 개선 환자분율', weight:12,
      rows:[[5,'45% 이상'],[4,'35~45%'],[3,'25~35%'],[2,'15~25%'],[1,'15% 미만']] },
    { gubun:'결과지표', indi:'당뇨병 환자 중 HbA1c 검사결과 적정범위 환자분율', weight:12,
      rows:[[5,'98% 이상'],[4,'92~98%'],[3,'86~92%'],[2,'80~86%'],[1,'80% 미만']] },
    { gubun:'결과지표', indi:'장기입원(181일 이상) 환자분율', weight:5,
      rows:[[5,'20% 미만'],[4,'20~40%'],[3,'40~60%'],[2,'60~80%'],[1,'80% 이상']] },
    { gubun:'결과지표', indi:'지역사회 복귀율',            weight:5,
      rows:[[5,'70% 이상'],[4,'55~70%'],[3,'40~55%'],[2,'25~40%'],[1,'25% 미만']] }
];

// 산출점수 = 가중치 / 5 × 표준화구간 (부동소수 오차 제거 위해 소수 2자리 반올림)
function _stdCalcScore(weight, gugan) {
    return parseFloat((weight / 5 * gugan).toFixed(2));
}

function fn_ShowStdRangeModal() {
    /* 전용 CSS (한 번만 주입) — 흰 바탕 / 검은 글자 */
    if (!document.getElementById('stdRangeModalStyle')) {
        var st = document.createElement('style');
        st.id = 'stdRangeModalStyle';
        st.innerHTML =
            '.swal2-popup.stdrange-popup { max-width:940px !important; width:940px !important; background:#fff !important; color:#1f2937 !important; border-radius:16px !important; box-shadow:0 24px 64px rgba(15,44,82,0.28) !important; padding:20px 24px 18px !important; }' +
            '.swal2-popup.stdrange-popup .swal2-title { cursor:move; user-select:none; color:#0f2c52 !important; font-size:1.15em !important; font-weight:700 !important; line-height:1.4 !important; padding:4px 4px 12px !important; margin-bottom:6px; border-bottom:2px solid #eef2f7; }' +
            '.swal2-popup.stdrange-popup .swal2-confirm { background:#2d4d7a !important; border-radius:8px !important; padding:9px 30px !important; box-shadow:none !important; }' +
            '.stdrange-scroll-wrap { max-height:66vh; overflow:auto; border:1px solid #e3e8ef; border-radius:12px; }' +
            '.stdrange-table { width:100%; border-collapse:separate; border-spacing:0; font-size:13px; background:#fff; color:#1f2937; }' +
            '.stdrange-table th, .stdrange-table td { border-bottom:1px solid #eef1f5; border-right:1px solid #eef1f5; padding:8px 11px; }' +
            '.stdrange-table th:last-child, .stdrange-table td:last-child { border-right:none; }' +
            /* 헤더: 진한 네이비 + 흰 글자 */
            '.stdrange-table thead th { position:sticky; background:#2d4d7a; color:#fff; font-weight:600; text-align:center; letter-spacing:0.3px; border-right:1px solid rgba(255,255,255,0.2); border-bottom:1px solid #213c63; }' +
            /* 2행 헤더: 1행(표준화 등)은 top:0, 2행(구간/점수)은 1행 높이만큼 내려 고정 → 스크롤해도 표준화 행 유지 */
            '.stdrange-table thead tr:first-child  th { top:0;    z-index:3; height:34px; }' +
            '.stdrange-table thead tr:nth-child(2) th { top:34px; z-index:2; }' +
            '.stdrange-table tbody tr:hover td { background:#f3f7fc; }' +
            '.stdrange-table td.col-gubun  { text-align:center; font-weight:700; white-space:nowrap; font-size:12.5px; }' +
            '.stdrange-table td.col-gubun.gb-0 { background:#eef4fb; color:#1f4e85; }' +   /* 구조지표 */
            '.stdrange-table td.col-gubun.gb-1 { background:#eaf6f2; color:#157a5b; }' +   /* 과정지표 */
            '.stdrange-table td.col-gubun.gb-2 { background:#f3effb; color:#5b3a99; }' +   /* 결과지표 */
            '.stdrange-table td.col-indi   { text-align:left; font-weight:500; }' +
            '.stdrange-table tr.indi-alt td.col-indi, .stdrange-table tr.indi-alt td.col-weight, .stdrange-table tr.indi-alt td.col-gugan, .stdrange-table tr.indi-alt td.col-score, .stdrange-table tr.indi-alt td.col-calc { background:#fafbfd; }' +
            '.stdrange-table td.col-weight { text-align:center; color:#475569; }' +
            '.stdrange-table td.col-gugan  { text-align:center; }' +
            '.stdrange-table td.col-score  { text-align:center; color:#374151; }' +
            '.stdrange-table td.col-calc   { text-align:center; font-weight:700; color:#0f2c52; }' +
            /* 표준화 구간 점수 배지 (5=우수 … 1=미흡) */
            '.std-badge { display:inline-flex; align-items:center; justify-content:center; width:26px; height:26px; border-radius:50%; color:#fff; font-weight:700; font-size:12.5px; box-shadow:0 1px 2px rgba(0,0,0,0.18); }' +
            '.std-b5 { background:#1e9e6a; } .std-b4 { background:#5cb85c; } .std-b3 { background:#f0ad4e; } .std-b2 { background:#ec8a3c; } .std-b1 { background:#e15554; }' +
            '.stdrange-inline-excel-btn {' +
            '  display:inline-flex; align-items:center; gap:7px; padding:8px 18px; border:1px solid #1d7a4d;' +
            '  border-radius:8px; font-size:13px; font-weight:600; color:#fff; background:linear-gradient(135deg,#27ae60,#1e8e50); cursor:pointer; box-shadow:0 2px 6px rgba(30,142,80,0.3); transition:filter .15s ease, transform .15s ease; }' +
            '.stdrange-inline-excel-btn:hover { filter:brightness(1.05); transform:translateY(-1px); }' +
            '.stdrange-inline-excel-btn:active { transform:translateY(0); }';
        document.head.appendChild(st);
    }

    /* 표 본문 생성 — 구분/지표/가중치는 rowspan 으로 묶음 */
    var bodyHtml = '';
    var gubunSpan = {};
    var gubunOrder = {};   /* 구분 등장 순서 → 색상 클래스(gb-0/1/2) 매핑 */
    /* 구분별 총 행 수 + 등장 순서 선계산 (rowspan / 색상용) */
    for (var g = 0; g < _STD_RANGE_DATA.length; g++) {
        var gb = _STD_RANGE_DATA[g].gubun;
        gubunSpan[gb] = (gubunSpan[gb] || 0) + _STD_RANGE_DATA[g].rows.length;
        if (gubunOrder[gb] === undefined) gubunOrder[gb] = Object.keys(gubunOrder).length;
    }
    var gubunPrinted = {};
    for (var i = 0; i < _STD_RANGE_DATA.length; i++) {
        var item = _STD_RANGE_DATA[i];
        var altCls = (i % 2 === 1) ? ' class="indi-alt"' : '';   /* 지표 단위 교차 음영 */
        for (var r = 0; r < item.rows.length; r++) {
            bodyHtml += '<tr' + altCls + '>';
            /* 구분 셀: 각 구분 첫 행에서만 출력 */
            if (!gubunPrinted[item.gubun]) {
                bodyHtml += '<td class="col-gubun gb-' + (gubunOrder[item.gubun] % 3) + '" rowspan="' + gubunSpan[item.gubun] + '">' + item.gubun + '</td>';
                gubunPrinted[item.gubun] = true;
            }
            /* 지표 / 가중치점수 셀: 각 지표 첫 행에서만 출력 */
            if (r === 0) {
                bodyHtml += '<td class="col-indi"   rowspan="' + item.rows.length + '">' + item.indi + '</td>';
                bodyHtml += '<td class="col-weight" rowspan="' + item.rows.length + '">' + item.weight + '</td>';
            }
            var gugan = item.rows[r][0];
            bodyHtml += '<td class="col-gugan"><span class="std-badge std-b' + gugan + '">' + gugan + '</span></td>';
            bodyHtml += '<td class="col-score">' + item.rows[r][1] + '</td>';
            bodyHtml += '<td class="col-calc">'  + _stdCalcScore(item.weight, gugan) + '</td>';
            bodyHtml += '</tr>';
        }
    }

    var html =
        '<div style="display:flex; justify-content:flex-end; margin-bottom:8px;">' +
            '<button type="button" class="stdrange-inline-excel-btn" id="btnStdRangeExcel">' +
                '<i class="fa fa-file-excel"></i>엑셀 저장</button>' +
        '</div>' +
        '<div class="stdrange-scroll-wrap"><table class="stdrange-table"><thead>' +
            '<tr>' +
                '<th rowspan="2" style="width:90px;">구분</th>' +
                '<th rowspan="2">지표</th>' +
                '<th rowspan="2" style="width:70px;">가중치<br>점수</th>' +
                '<th colspan="2">표준화</th>' +
                '<th rowspan="2" style="width:70px;">산출<br>점수</th>' +
            '</tr>' +
            '<tr>' +
                '<th style="width:55px;">구간</th>' +
                '<th style="width:130px;">점수</th>' +
            '</tr>' +
        '</thead><tbody>' + bodyHtml + '</tbody></table></div>';

    Swal.fire({
        title: _STD_RANGE_TITLE,
        html: html,
        width: 920,
        showCancelButton: false,
        confirmButtonText: '닫기',
        customClass: { popup: 'stdrange-popup' },
        didOpen: function() {
            _stdRangeEnableDrag();
            var bx = document.getElementById('btnStdRangeExcel');
            if (bx) bx.onclick = function() { fn_ExportStdRangeExcel(); };
        }
    });
}

/* 팝업 제목 드래그로 이동 */
function _stdRangeEnableDrag() {
    var popup = document.querySelector('.swal2-popup.stdrange-popup');
    var title = popup ? popup.querySelector('.swal2-title') : null;
    if (!popup || !title) return;
    var dx = 0, dy = 0, dragging = false;
    title.addEventListener('mousedown', function(e) {
        dragging = true;
        var rc = popup.getBoundingClientRect();
        dx = rc.left - e.clientX; dy = rc.top - e.clientY;
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

/* 표준화구간 엑셀 저장 (구분 / 지표 / 가중치점수 / 표준화구간 / 점수 / 산출점수) */
function fn_ExportStdRangeExcel() {
    if (typeof XLSX === 'undefined') {
        Swal.fire({ icon:'error', title:'오류', text:'XLSX 라이브러리가 로드되지 않았습니다.' });
        return;
    }
    var aoa = [['구분','지표','가중치점수','표준화구간','점수','산출점수']];
    for (var i = 0; i < _STD_RANGE_DATA.length; i++) {
        var item = _STD_RANGE_DATA[i];
        for (var r = 0; r < item.rows.length; r++) {
            var gugan = item.rows[r][0];
            aoa.push([item.gubun, item.indi, item.weight, gugan, item.rows[r][1], _stdCalcScore(item.weight, gugan)]);
        }
    }
    var ws = XLSX.utils.aoa_to_sheet(aoa);
    var wb = XLSX.utils.book_new();
    XLSX.utils.book_append_sheet(wb, ws, '표준화구간');
    XLSX.writeFile(wb, '2024년_표준화점수구간_가중치.xlsx');
}

$(document).ready(function() {

	_loadDocCnt();   // 성명 마스킹 정책(DOCCNT) — 그리드 렌더 전 확정

	// === 2024년 표준화구간 안내: assessment 화면 진입 시 항상 고정 표시 (버튼 토글 아님) ===
	(function() {
	    var box = document.getElementById('stdRangeNotice');
	    if (box) box.style.display = 'block';            // 우측 내용은 버튼과 무관하게 항상 고정 노출
	    var btn = document.getElementById('btnStdRange'); // top.jsp 메뉴바 버튼(상단 표시용)
	    if (btn) {
	        btn.style.display = 'inline-flex';
	        if (!btn._stdBound) {
	            btn._stdBound = true;
	            btn.addEventListener('click', function() {
	                fn_ShowStdRangeModal();
	            });
	        }
	    }
	})();

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
	    } else if (current_Year >= 2026) {
	        $('#goal_Jugi').val('2');
	        $('#goal_Chasu').val('8');
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
	    } else if (selectedYear >= '2026') {
	        $('#goal_Jugi').val('2');
	        $('#goal_Chasu').val('8');
	    }
		
    });
	$('#monthSelect').on('change', function() {
		sessionStorage.setItem('assessment_month', this.value);
		fn_IndiSelect();
    });
	$('#yearQuarter').on('change', function() {
		fn_Select(true);
		fn_RenderGrdList();   // 하단 그리드도 선택 년도 자료로 재표시
    });
	$('#monsQuarter').on('change', function() {
		fn_Select(true);
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

