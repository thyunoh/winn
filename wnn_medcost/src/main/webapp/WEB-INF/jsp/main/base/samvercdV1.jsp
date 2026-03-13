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
<link href="/css/winmc/style_comm.css?v=123"  rel="stylesheet">
<style>
</style>
	<!-- ============================================================== -->
	<!-- Main Form start -->
	<!-- ============================================================== -->
<div class="dashboard-wrapper">
	<div class="container-fluid dashboard-content">
		<div class="row">
			<!-- 전체 카드 (12칸) -->
			<div class="col-xl-12 col-lg-12 col-md-12 col-sm-12 col-12">
				<div class="card">
					<div class="card-body">
						<!-- 조회조건 + 버튼 -->
						<div class="d-flex align-items-start mb-2" style="gap:8px;">
							<!-- SAMVER 체크박스 (넓게) -->
							<div style="flex:1; min-width:0;">
								<label class="mb-0" style="font-size:12px;"><b>SAMVER</b></label>
								<div id="srchSamverArea" style="height:120px; overflow-y:auto; border:1px solid #dee2e6; border-radius:4px; padding:4px; 
								         display:flex; flex-wrap:wrap; gap:2px; align-content:flex-start;">
								</div>
							</div>
							<!-- VERSION + TBLINFO 세로 배치 (우측 끝) -->
							<div style="width:130px; flex-shrink:0;">
								<label class="mb-0" style="font-size:12px;"><b>VERSION</b></label>
								<input id="srchVersion" type="text" class="form-control form-control-sm mb-1" placeholder="">
								<label class="mb-0" style="font-size:12px;"><b>TBLINFO</b></label>
								<select id="srchTblinfo" class="custom-select custom-select-sm">
									<option value="" selected>전체</option>
								</select>
							</div>
							<!-- 버튼 세로 배치 (우측 끝) -->
							<div class="d-flex flex-column flex-shrink-0" style="gap:2px;">
								<div class="btn-group" style="white-space:nowrap;">
									<button class="btn btn-sm btn-outline-dark" data-toggle="tooltip" data-placement="top" title="조회"
										onClick="fn_Search()">조회 <i class="fas fa-binoculars"></i></button>
									<button class="btn btn-sm btn-outline-primary" data-toggle="tooltip"
										data-placement="top" title="버전복사 화면"
										onClick="fn_OpenCopyModal()">
										버전복사 <i class="fas fa-copy"></i>
									</button>
									<button class="btn btn-sm btn-outline-dark" data-toggle="tooltip"
										data-placement="top" title="화면 Size 확대.축소" id="fullscreenToggle">
										화면확장축소 <i class="fas fa-expand" id="fullscreenIcon"></i>
									</button>
								</div>
								<div class="btn-group" style="white-space:nowrap;">
									<button class="btn btn-sm btn-outline-dark btn-insert" data-toggle="tooltip"
										data-placement="top" title="선택행 아래에 중간삽입" onClick="fn_InsertMiddle()">
										입력 <i class="far fa-edit"></i>
									</button>
									<button class="btn btn-sm btn-outline-dark btn-update" data-toggle="tooltip"
										data-placement="top" title="선택 Data 수정" onClick="cd_modal_Open('U')">
										수정 <i class="far fa-save"></i>
									</button>
									<button class="btn btn-sm btn-outline-dark btn-delete" data-toggle="tooltip"
										data-placement="top" title="선택 Data 삭제" onClick="cd_modal_Open('D')">
										삭제 <i class="far fa-trash-alt"></i>
									</button>
									<button class="btn btn-sm btn-outline-primary" data-toggle="tooltip"
										data-placement="top" title="변경사항 일괄저장" onClick="fn_BulkSave()">
										일괄저장 <i class="fas fa-save"></i>
									</button>
								</div>
							</div>
						</div>
						<!-- 그리드 -->
						<div style="width: 100%;">
							<table id="cd_tableName"
								class="display nowrap table table-striped table-bordered">
								<!-- 테이블 내용 -->
							</table>
						</div>
					</div>
				</div>
			</div>
		</div>
		<!-- row end -->
	</div>
</div>

<!-- ============================================================== -->
<!-- Main Form end -->
<!-- ============================================================== -->

<!-- ============================================================== -->
<!-- 버전복사 모달 start -->
<!-- ============================================================== -->
<div class="modal fade" id="copyModalName" tabindex="-1"
	data-backdrop="static" role="dialog" aria-hidden="true"
	data-keyboard="false">
	<div class="modal-dialog modal-dialog-centered modal-dialog-scrollable"
		role="dialog"
		style="position: absolute; top: 40%; left: 50%; transform: translate(-50%, -50%); width: 50vw; max-width: 50vw; max-height: 70vh;">
		<div class="modal-content"
			style="height: 70%; display: flex; flex-direction: column;">
			<div class="modal-header bg-light">
				<h6 class="modal-title">버전 복사</h6>
				<div class="form-row">
					<div class="col-sm-12 mb-2" style="text-align: right;">
						<button id="copy_btn_exec" type="button"
							class="btn btn-outline-primary" onClick="fn_ExecVersionCopy()">
							복사실행. <i class="fas fa-play"></i>
						</button>
						<button type="button" class="btn btn-outline-dark"
							onClick="fn_CloseCopyModal()">
							닫기 <i class="fas fa-times"></i>
						</button>
					</div>
				</div>
			</div>
			<div class="modal-body" style="text-align: left; flex: 1; overflow-y: auto;">
				<div class="form-group row">
					<label class="col-3 col-form-label text-left">원본 VERSION</label>
					<div class="col-9">
						<input id="srcVersion" type="text" class="form-control" readonly style="background-color:#e9ecef;">
					</div>
				</div>
				<div class="form-group row">
					<label class="col-3 col-form-label text-left">대상 VERSION</label>
					<div class="col-9">
						<input id="tgtVersion" type="text" class="form-control" placeholder="대상 버전 입력 (예: 093)">
					</div>
				</div>
				<div class="form-group row">
					<label class="col-3 col-form-label text-left">복사대상 SAMVER</label>
					<div class="col-9">
						<div id="samverCheckArea" style="max-height:250px; overflow-y:auto; border:1px solid #dee2e6; border-radius:4px; padding:4px; 
						          display:flex; flex-wrap:wrap; gap:2px; align-content:flex-start;">
							<!-- 체크박스가 동적으로 생성됨 -->
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
<!-- ============================================================== -->
<!-- 버전복사 모달 end -->
<!-- ============================================================== -->

<!-- ============================================================== -->
<!-- 상세 모달 start -->
<!-- ============================================================== -->
<div class="modal fade" id="cd_modalName" tabindex="-1"
	data-backdrop="static" role="dialog" aria-hidden="true"
	data-keyboard="false">
	<div class="modal-dialog modal-dialog-centered modal-dialog-scrollable"
		role="dialog"
		style="position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); width: 50vw; max-width: 50vw; max-height: 50vh;">
		<div class="modal-content"
			style="height: 70%; display: flex; flex-direction: column;">
			<div class="modal-header bg-light">
				<h6 class="modal-title" id="cd_modalHead"></h6>
				<div class="form-row">
					<div class="col-sm-12 mb-2" style="text-align: right;">
						<button id="cd_form_btn_ins" type="submit"
							class="btn btn-outline-info btn-insert" onClick="cd_fn_Insert()">
							입력. <i class="far fa-edit"></i>
						</button>
						<button id="cd_form_btn_udt" type="submit"
							class="btn btn-outline-success btn-update" onClick="cd_fn_Update()">
							수정. <i class="far fa-save"></i>
						</button>
						<button id="cd_form_btn_del" type="submit"
							class="btn btn-outline-danger btn-delete" onClick="cd_fn_Delete()">
							삭제. <i class="far fa-trash-alt"></i>
						</button>
						<button type="button" class="btn btn-outline-dark"
							data-dismiss="modal" onClick="cd_modalClose()">
							닫기 <i class="fas fa-times"></i>
						</button>
					</div>
				</div>
			</div>
			<div class="modal-body"
				style="text-align: left; flex: 1; overflow-y: auto;">
				<div id="cd_inputZone">
				    <input type="hidden" id="subCodeNm"     name="subCodeNm"    value="">
				    <input type="hidden" id="dtlCodeNm"     name="dtlCodeNm"    value="">
					<input type="hidden" id="regUser"       name="regUser"      value="">
					<input type="hidden" id="updUser"       name="updUser"      value="">
					<input type="hidden" id="regIp"         name="regIp"        value="">
					<input type="hidden" id="updIp"         name="updIp"        value="">
					<div class="form-group row">
						<label for="samver"
							class="col-2 col-sm-2 col-form-label text-left">청구버전</label>
						<div class="col-4 col-sm-4">
							<input id="samver" name="samver" type="text"
								class="form-control text-left" placeholder="청구버젼">
						</div>
						<label for="tblinfo"
						class="col-2 col-lg-2 col-form-label text-left">청구구분명</label>
						<div class="col-4 col-lg-4">
							<select id="tblinfo" name="tblinfo" class="custom-select"
								oninput="findField(this)" style="height: 35px; font-size: 14px;">
								<option value="" selected>구분1</option>
							</select>
						</div>
				    </div>
				    <div class="form-group row">
						<label for="version"
							class="col-2 col-sm-2 col-form-label text-left">서식버전</label>
						<div class="col-4 col-sm-4">
							<input id="version" name="version" type="text"
								class="form-control text-left" placeholder="서식버젼">
						</div>
						<label for="seq"
							class="col-2 col-sm-2 col-form-label text-left">순서</label>
						<div class="col-4 col-sm-4">
							<input id="seq" name="seq" type="text"
								class="form-control text-left" placeholder="순서">
						</div>
					</div>
					<div class="form-group row">
						<label for="itemNm"
							class="col-2 col-lg-2 col-form-label text-left">항목구분명</label>
						<div class="col-4 col-lg-4">
							<input id="itemNm" name="itemNm" type="text"
								class="form-control" placeholder="">
						</div>
						<label for="dbColnm"
							class="col-2 col-lg-2 col-form-label text-left">DB컬럼정보</label>
						<div class="col-4 col-lg-4">
							<input id="dbColnm" name="dbColnm" type="text"
								class="form-control" placeholder="">
						</div>
					</div>
					<div class="form-group row">
						<label for="startPos"
							class="col-2 col-sm-2 col-form-label text-left">시작위치</label>
						<div class="col-2 col-sm-2">
							<input id="startPos" name="startPos" type="text"
								class="form-control text-left" placeholder="시작위치 입력">
						</div>
						<label for="endPos"
							class="col-2 col-sm-2 col-form-label text-left">종료위치</label>
						<div class="col-2 col-sm-2">
							<input id="endPos" name="endPos" type="text"
								class="form-control text-left" placeholder="종료위치 입력">
						</div>
                        <label for="dbComcolnm"
							class="col-2 col-sm-2 col-form-label text-left">샘파일제외</label>
						<div class="col-2 col-sm-2">
							<input id="dbComcolnm" name="dbComcolnm" type="text"
								class="form-control text-left" placeholder="">
						</div>
					</div>
					<div class="form-group row ">
						<label for="startDt_one"
							class="col-2 col-lg-2 col-form-label text-left">적용일자</label>
						<div class="col-4 col-lg-4">
							<input id="startDt_one" name="startDt_one" type="text"
								class="form-control date1-inputmask" placeholder="yyyy-mm-dd">
						</div>
						<label for="endDt_one"
							class="col-2 col-lg-2 col-form-label text-left">종료일자</label>
						<div class="col-4 col-lg-4">
							<input id="endDt_one" name="endDt_one" type="text"
								class="form-control date1-inputmask" placeholder="yyyy-mm-dd">
						</div>
					</div>
					<div class="form-group row">
						<label for="dataType"
						class="col-2 col-lg-2 col-form-label text-left">코드구분</label>
						<div class="col-4 col-lg-4">
							<select id="dataType" name="dataType" class="custom-select"
								oninput="findField(this)" style="height: 35px; font-size: 14px;">
								<option value="" selected>구분1</option>
							</select>
						</div>
						<label for="sortSeq"
							class="col-2 col-lg-2 col-form-label text-left">정렬순서</label>
						<div class="col-4 col-lg-4">
							<input id="sortSeq" name="sortSeq" type="text"
								class="form-control" placeholder="">
						</div>
					</div>
					<div class="form-group row">
						<label for="decimalPos"
						class="col-2 col-lg-2 col-form-label text-left">소수점위치</label>
						<div class="col-2 col-lg-2">
						<input id="decimalPos" name="decimalPos" type="text" class="form-control" placeholder="">
						</div>
                         <form>
                             <label class="custom-control custom-radio custom-control-inline">
                                 <input type="radio" id="dataprocYn1" name="dataprocYn" class="custom-control-input" value="Y"><span class="custom-control-label">처리</span>
                             </label>
                             <label class="custom-control custom-radio custom-control-inline">
                                 <input type="radio" id="dataprocYn2" name="dataprocYn" class="custom-control-input" value="N"><span class="custom-control-label">미처리</span>
                             </label>
                         </form>
						<label for="colSize"
						class="col-2 col-lg-2 col-form-label text-left">컬럼사이즈</label>
						<div class="col-2 col-lg-2">
						<input id="colSize" name="colSize" type="text" class="form-control" placeholder="">
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
<!-- ============================================================== -->
<!-- 상세 모달 end -->
<!-- ============================================================== -->

<!-- ============================================================== -->
<!-- 기본 초기화 Start -->
<!-- ============================================================== -->
<script type="text/javascript">
// 전역변수
var cd_tableName  = document.getElementById('cd_tableName');
var cd_modalName  = document.getElementById('cd_modalName');
var cd_modalHead  = document.getElementById('cd_modalHead');
var cd_inputZone  = document.getElementById('cd_inputZone');
var cd_dataTable  = null;
var cdedit_Data   = null;
var mainFocus     = 'srchVersion';
var edit_Data     = null;

// 공통코드 Setting
var list_flag = ['Z'];
var list_code = ['TBLINFO','TBLINFO','DATA_TYPE'];
var select_id = ['tblinfo','srchTblinfo','dataType'];
var firstnull = ['N','Y','N'];

var format_convert = [];

// Table Setting
var page_Hight = 650;
var colPadding = '0.2px';
var data_Count = [15, 30, 50, 70, 100, 150, 200];
var defaultCnt = 30;
var info_Count = true;
var row_Select = true;
var mousePoint = 'pointer';
var showButton = false;
var txt_Markln = 20;
var markColums = ['itemNm'];
var showSortNo = [];
var hideColums = [];
var muiltSorts = [];
var copyBtn_nm = '복사.';
var copy_Title = 'Copy Title';
var excelBtnnm = '엑셀.';
var excelTitle = 'Excel Title';
var excelFName = "샘파일버전_";
var printBtnnm = '출력.';
var printTitle = 'Print Title';

window.onload = function() {
    comm_Check();
    loadDistinctSamver();
};

// Enter키 검색
document.addEventListener('DOMContentLoaded', function() {
	document.getElementById('srchVersion').addEventListener('keyup', function(e) {
		if (e.key === 'Enter') fn_Search();
	});
});
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
	const samverInput     = document.getElementById("samver");
    const tblinfoInput    = document.getElementById("tblinfo");
    const versionInput    = document.getElementById("version");
    const seqInput        = document.getElementById("seq");

    const inputs = [samverInput, tblinfoInput, versionInput, seqInput];

    if (flag !== 'I') {
        const isReadOnly = flag !== 'I';
        inputs.forEach(input => {
            if (input) {
                input.readOnly = isReadOnly;
            }
        });
    } else {
        const isReadOnly = flag == 'N';
        inputs.forEach(input => {
            if (input) {
                input.readOnly = isReadOnly;
            }
        });
    }
    if (flag !== 'I') {
        $(tblinfoInput).css("pointer-events", "none").css("background-color", "#e9ecef");
    } else {
        $(tblinfoInput).css("pointer-events", "").css("background-color", "");
    }
}
</script>
<!-- ============================================================== -->
<!-- modal Form 띄우기 End -->
<!-- ============================================================== -->

<!-- ============================================================== -->
<!-- SAMVER DISTINCT 로드 Start -->
<!-- ============================================================== -->
<script type="text/javascript">
// SAMVER DISTINCT 목록 로드 (조회 체크박스 + 복사 체크박스)
function loadDistinctSamver() {
	// 우선 신규 API 시도, 실패시 기존 API로 fallback
	$.ajax({
		type: "POST",
		url: "/base/samverDistinctList.do",
		dataType: "json",
		success: function(response) {
			var list = (response && response.data) ? response.data : [];
			buildSrchSamverCheckboxes(list);
			buildCopySamverCheckboxes(list);
		},
		error: function() {
			console.log("samverDistinctList.do 실패, 기존 API로 fallback");
			// 기존 samverCdlist.do로 SAMVER LIKE '%' 조회 후 JS에서 DISTINCT 추출
			$.ajax({
				type: "POST",
				url: "/base/samverCdlist.do",
				data: { samver: '%', version: '', prop1: 'ZZZ', tblinfo: '' },
				dataType: "json",
				success: function(res) {
					var dataArr = (res && res.data) ? res.data : [];
					// JS에서 DISTINCT SAMVER 추출
					var uniqueMap = {};
					dataArr.forEach(function(item) {
						if (item.samver && !uniqueMap[item.samver]) {
							uniqueMap[item.samver] = true;
						}
					});
					var list = Object.keys(uniqueMap).sort().map(function(sv) {
						return { samver: sv };
					});
					// fallback에서 누락된 SAMVER 보완 (INNER JOIN으로 누락되는 항목 추가)
					var knownSamvers = ['C010','C110.1','C110.2','C110.3','C110.4','CAR',
						'D020.1','D020.2','D020.3','D020.4','D020.5','D020.6',
						'GHP','H010','H040.1','H040.2','H040.3','H040.4','H040.5',
						'K020.1','K020.2','K020.3','K020.4',
						'M010.1','M010.2','M020.1','M020.2','M020.3','M020.4','M020.5',
						'M021.1','M021.2','M021.3','M021.4','REP'];
					knownSamvers.forEach(function(sv) {
						if (!uniqueMap[sv]) {
							uniqueMap[sv] = true;
						}
					});
					list = Object.keys(uniqueMap).sort().map(function(sv) {
						return { samver: sv };
					});
					buildSrchSamverCheckboxes(list);
					buildCopySamverCheckboxes(list);
				},
				error: function() {
					console.error("SAMVER 목록 로드 최종 실패");
					$('#srchSamverArea').html('<span class="text-muted">로드 실패</span>');
					$('#samverCheckArea').html('<span class="text-muted">로드 실패</span>');
				}
			});
		}
	});
}

// 조회용 SAMVER 체크박스 (가로 나열, 개별선택)
function buildSrchSamverCheckboxes(list) {
	var html = '';
	if (list.length === 0) {
		html = '<span class="text-muted">데이터 없음</span>';
	} else {
		list.forEach(function(item, idx) {
			html += '<div class="custom-control custom-checkbox custom-control-inline" style="min-width:90px; margin-right:4px; margin-bottom:2px;">' +
					'<input type="checkbox" class="custom-control-input srch-samver-chk" id="srchChkSamver_' + idx + '" value="' + item.samver + '">' +
					'<label class="custom-control-label" for="srchChkSamver_' + idx + '">' + item.samver + '</label></div>';
		});
	}
	$('#srchSamverArea').html(html);
}

// 복사용 SAMVER 체크박스 (가로 나열, 개별선택, 전체선택 없음)
function buildCopySamverCheckboxes(list) {
	var html = '';
	if (list.length === 0) {
		html = '<span class="text-muted">데이터 없음</span>';
	} else {
		list.forEach(function(item, idx) {
			html += '<div class="custom-control custom-checkbox custom-control-inline" style="min-width:90px; margin-right:4px; margin-bottom:2px;">' +
					'<input type="checkbox" class="custom-control-input copy-samver-chk" id="copyChkSamver_' + idx + '" value="' + item.samver + '">' +
					'<label class="custom-control-label" for="copyChkSamver_' + idx + '">' + item.samver + '</label></div>';
		});
	}
	$('#samverCheckArea').html(html);
}
</script>
<!-- ============================================================== -->
<!-- SAMVER DISTINCT 로드 End -->
<!-- ============================================================== -->

<!-- ============================================================== -->
<!-- DataTable 설정 Start -->
<!-- ============================================================== -->
<script type="text/javascript">
function initCdResultsTable() {
  if (!$.fn.DataTable.isDataTable('#' + cd_tableName.id)) {
   	cd_dataTable = $('#' + cd_tableName.id).DataTable({
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
   		    responsive:    false,
            autoWidth:     false,
            ordering:      true,
            searching:     false,
            lengthChange:  true,
            info:          info_Count,
            paging:        true,
            scrollX:       true,
            scrollY:       page_Hight,
            fixedHeader:   true,
            search: {
    	        return: false,
    	    },
		    rowCallback: function(row, data, index) {
	            $(row).find('td').css('padding', colPadding);
	        },
	        lengthMenu: [data_Count, data_Count],
	        pageLength: defaultCnt,
		    dom: '<"datatable-controls d-flex align-items-center justify-content-between"<"d-flex"<"mr-2"l><"ml-auto"f>>>' +
		          't' +
		          '<"row mt-2"<"col-sm-7"i><"col-sm-5"p>>',
            buttons: [],
            columns: [
            	{ title: "확장자",       data: "samver"      ,  className: "text-center", name: 'keysamver' , primaryKey: true },
            	{ title: "청구구분",     data: "subCodeNm"   ,  className: "text-left"  ,  width: '120px' },
            	{ title: "테이블정보",   data: "tblinfo"     ,  visible: false  , name: 'keytblinfo'  , primaryKey: true },
            	{ title: "순서",         data: "seq"         ,  className: "text-center", name: 'keyseq'   , primaryKey: true },
            	{ title: "버전",         data: "version"     ,  className: "text-center", visible: true  , name: 'keyversion' , primaryKey: true },
            	{ title: "항목명",       data: "itemNm"      ,  className: "text-left"  ,  width: '200px' },
            	{ title: "정렬순서",     data: "sortSeq"     ,  className: "text-center",  width: '30px' },
            	{ title: "시작위치",     data: "startPos"    ,  className: "text-right"  ,  width: '30px' },
            	{ title: "종료위치",     data: "endPos"      ,  className: "text-right"  ,  width: '30px' },
			    { title: "데이타형태",   data: "dataType"    ,  className: "text-right" },
            	{ title: "소수점자리수", data: "decimalPos"  ,  className: "text-center" },
			    { title: "처리",         data: "dataprocYn"  ,  className: "text-center" },
			    { title: "DB컬럼",      data: "dbColnm"     ,  className: "text-center" },
			    { title: "컬럼사이즈",  data: "colSize"     ,  className: "text-center" }
            ],
            columnDefs: [
		        {
		            targets: ['_all'],
		            createdCell: function (td, cellData, rowData, row, col) {
		                $(td).css('cursor', mousePoint);
		            }
		        }
		    ],
            ajax: function(data, callback, settings) {
            	callback({ data: [] });
            }
		});

	    // row 클릭시 데이터 저장
	    $('#' + cd_tableName.id + ' tbody').on('click', 'tr', function() {
	    	cdedit_Data = cd_dataTable.row(this).data();
	    });

	    // 싱글 선택
	    if (row_Select) {
	    	cd_dataTable.on('click', 'tbody tr', (e) => {
		  	    let classList = e.currentTarget.classList;
		  	    if (!classList.contains('selected')) {
		  	    	cd_dataTable.rows('.selected').nodes().each((row) => row.classList.remove('selected'));
		  	        classList.add('selected');
		  	    }
		  	});
	    }

	    // 더블클릭시 인라인 편집 (셀 단위)
	    $('#' + cd_tableName.id + ' tbody').on('dblclick', 'td', function () {
	        fn_InlineEdit(this);
	    });

	    // datatable label→span
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
    }
}

// 조회 버튼 클릭
function fn_Search() {
	// 체크된 SAMVER 목록
	var checkedSamvers = [];
	$('.srch-samver-chk:checked').each(function() {
		checkedSamvers.push($(this).val());
	});
	var version = $('#srchVersion').val();
	var tblinfo = $('#srchTblinfo').val();

	if (!version) {
		Swal.fire({title:'알림', text:'VERSION을 입력해주세요.', icon:'warning',
			confirmButtonText:'확인', timer:2000, timerProgressBar:true, showConfirmButton:false,
			customClass:{popup:'small-swal'}});
		$('#srchVersion').focus();
		return;
	}
	if (checkedSamvers.length === 0) {
		Swal.fire({title:'알림', text:'SAMVER를 선택해주세요.', icon:'warning',
			confirmButtonText:'확인', timer:2000, timerProgressBar:true, showConfirmButton:false,
			customClass:{popup:'small-swal'}});
		return;
	}

	cdedit_Data = null;

	if (checkedSamvers.length === 1) {
		// SAMVER 1개 선택
		loadGridData(checkedSamvers[0], version, tblinfo);
	} else {
		// SAMVER 여러개 선택 → 각각 조회 후 합치기
		loadMultiSamverData(checkedSamvers, version, tblinfo);
	}
}

// 단일 SAMVER 그리드 데이터 로드
function loadGridData(samver, version, tblinfo) {
	$.ajax({
        url: "/base/samverCdlist.do",
        type: "POST",
        data: { samver: samver, version: version, prop1: samver, tblinfo: tblinfo },
        dataType: "json",
        beforeSend: function() {
        	if (cd_dataTable) {
        		cd_dataTable.clear().draw();
        	}
        },
	    success: function(response) {
	    	if (response && response.data && response.data.length > 0) {
	    		// SAMVER 정확히 일치 + VERSION 일치하는 데이터만 필터링
	    		var filtered = response.data.filter(function(row) {
	    			return row.samver === samver && row.version === version;
	    		});
	    		cd_dataTable.clear();
	    		if (filtered.length > 0) {
	    			cd_dataTable.rows.add(filtered).draw();
	    		} else {
	    			cd_dataTable.draw();
	    		}
	    	} else {
	    		cd_dataTable.clear().draw();
	    	}
	    },
	    error: function(jqXHR, textStatus, errorThrown) {
	        console.error("AJAX Error:", textStatus, errorThrown);
	        cd_dataTable.clear().draw();
	    }
    });
}

// 여러 SAMVER 조회 후 합치기
function loadMultiSamverData(samverArr, version, tblinfo) {
	if (cd_dataTable) {
		cd_dataTable.clear().draw();
	}
	var allData = [];
	var completed = 0;
	var total = samverArr.length;

	samverArr.forEach(function(sv) {
		$.ajax({
	        url: "/base/samverCdlist.do",
	        type: "POST",
	        data: { samver: sv, version: version, prop1: sv, tblinfo: tblinfo },
	        dataType: "json",
		    success: function(response) {
		    	if (response && response.data && response.data.length > 0) {
		    		// SAMVER 정확히 일치 + VERSION 일치하는 데이터만 필터링
		    		var filtered = response.data.filter(function(row) {
		    			return row.samver === sv && row.version === version;
		    		});
		    		if (filtered.length > 0) {
		    			allData = allData.concat(filtered);
		    		}
		    	}
		    },
		    complete: function() {
		    	completed++;
		    	if (completed === total) {
		    		// 모든 요청 완료 후 그리드에 한번에 세팅
		    		cd_dataTable.clear();
		    		if (allData.length > 0) {
		    			cd_dataTable.rows.add(allData).draw();
		    		} else {
		    			cd_dataTable.draw();
		    		}
		    	}
		    }
	    });
	});
}
</script>
<!-- ============================================================== -->
<!-- DataTable 설정 End -->
<!-- ============================================================== -->

<!-- ============================================================== -->
<!-- 버전 복사 기능 Start -->
<!-- ============================================================== -->
<script type="text/javascript">
// 버전복사 모달 열기
function fn_OpenCopyModal() {
	var version = $('#srchVersion').val();
	if (!version) {
		Swal.fire({title:'알림', text:'먼저 VERSION을 조회해주세요.', icon:'warning',
			confirmButtonText:'확인', timer:2000, timerProgressBar:true, showConfirmButton:false,
			customClass:{popup:'small-swal'}});
		return;
	}
	// 원본 VERSION 세팅
	$('#srcVersion').val(version);
	$('#tgtVersion').val('');
	// 조회 화면에서 체크된 SAMVER 가져오기
	var checkedSrchSamvers = [];
	$('.srch-samver-chk:checked').each(function() {
		checkedSrchSamvers.push($(this).val());
	});
	// 복사 체크박스: 조회에서 선택된 항목만 체크 + 회색 배경 표시
	$('.copy-samver-chk').each(function() {
		var val = $(this).val();
		var parentDiv = $(this).closest('.custom-control');
		if (checkedSrchSamvers.indexOf(val) >= 0) {
			$(this).prop('checked', true);
			parentDiv.css({'background-color':'#e9ecef', 'border-radius':'4px', 'padding':'2px 6px'});
		} else {
			$(this).prop('checked', false);
			parentDiv.css({'background-color':'', 'padding':''});
		}
	});

	// 모달 드래그 설정
	var element = document.querySelector('#copyModalName');
	dragElement(element);

	function dragElement(elmnt) {
	    var pos1 = 0, pos2 = 0, pos3 = 0, pos4 = 0;
	    if (elmnt.querySelector('.modal-header')) {
	        elmnt.querySelector('.modal-header').onmousedown = dragMouseDown;
	    }
	    function dragMouseDown(e) {
	        e = e || window.event;
	        pos3 = e.clientX;
	        pos4 = e.clientY;
	        document.onmouseup = closeDragElement;
	        document.onmousemove = elementDrag;
	    }
	    function elementDrag(e) {
	        e = e || window.event;
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

	$("#copyModalName").off('show.bs.modal').on('show.bs.modal', function () {
		var modal = document.querySelector('#copyModalName');
	    modal.style.top  = "50%";
	    modal.style.left = "50%";
	    modal.style.transform = "translate(-50%, -50%)";
	    setTimeout(function () {
	        $("#tgtVersion").focus();
	    }, 500);
	});

	$("#copyModalName").modal('show');
}

// 복사 모달 닫기
function fn_CloseCopyModal() {
	$("#copyModalName").modal('hide');
	// backdrop 잔여 제거
	setTimeout(function() {
		$('.modal-backdrop').remove();
		$('body').removeClass('modal-open').css('padding-right', '');
	}, 300);
}

// 복사 실행
function fn_ExecVersionCopy() {
	var srcVer = $('#srcVersion').val();
	var tgtVer = $('#tgtVersion').val();

	if (!srcVer) {
		Swal.fire({title:'알림', text:'원본 VERSION이 없습니다.', icon:'warning',
			confirmButtonText:'확인', timer:2000, timerProgressBar:true, showConfirmButton:false,
			customClass:{popup:'small-swal'}});
		return;
	}
	if (!tgtVer) {
		Swal.fire({title:'알림', text:'대상 VERSION을 입력해주세요.', icon:'warning',
			confirmButtonText:'확인', timer:2000, timerProgressBar:true, showConfirmButton:false,
			customClass:{popup:'small-swal'}});
		$('#tgtVersion').focus();
		return;
	}
	if (srcVer === tgtVer) {
		Swal.fire({title:'알림', text:'원본과 대상 VERSION이 같습니다.', icon:'warning',
			confirmButtonText:'확인', timer:2000, timerProgressBar:true, showConfirmButton:false,
			customClass:{popup:'small-swal'}});
		return;
	}

	// 선택된 SAMVER 목록
	var selectedSamvers = [];
	$('.copy-samver-chk:checked').each(function() {
		selectedSamvers.push($(this).val());
	});

	if (selectedSamvers.length === 0) {
		Swal.fire({title:'알림', text:'복사할 SAMVER를 선택해주세요.', icon:'warning',
			confirmButtonText:'확인', timer:2000, timerProgressBar:true, showConfirmButton:false,
			customClass:{popup:'small-swal'}});
		return;
	}

	Swal.fire({
		title: '버전복사 확인',
		html: '<b>원본:</b> ' + srcVer + ' <b>→ 대상:</b> ' + tgtVer + '<br>' +
			  '<b>SAMVER:</b> ' + selectedSamvers.join(', ') + '<br><br>복사하시겠습니까?',
		icon: 'question',
		showCancelButton: true,
		confirmButtonText: '예',
		cancelButtonText: '아니오',
		customClass: { popup: 'small-swal' }
	}).then((result) => {
		if (result.isConfirmed) {
			executeVersionCopy(srcVer, tgtVer, selectedSamvers);
		}
	});
}

function executeVersionCopy(srcVersion, tgtVersion, samverArr) {
	$.ajax({
		type: "POST",
		url: "/base/samverCdCopyVersion.do",
		data: JSON.stringify({
			srcVersion: srcVersion,
			tgtVersion: tgtVersion,
			samverList: samverArr,
			regUser: getCookie("s_userid") || '',
			regIp: getCookie("s_connip") || ''
		}),
		contentType: "application/json",
		dataType: "json",
		success: function(response) {
			if (response && response.result === 'OK') {
				Swal.fire({
					title: '처리확인',
					text: '버전 복사가 정상처리 되었습니다. (' + (response.count || 0) + '건)',
					icon: 'success',
					confirmButtonText: '확인',
					timer: 2000,
					timerProgressBar: true,
					showConfirmButton: false,
					customClass: { popup: 'small-swal' }
				});
				// 복사된 버전으로 재조회
				$('#srchVersion').val(tgtVersion);
				fn_CloseCopyModal();
				// 복사한 SAMVER들로 재조회
				var copiedSamvers = [];
				$('.copy-samver-chk:checked').each(function() { copiedSamvers.push($(this).val()); });
				if (copiedSamvers.length <= 1) {
					loadGridData(copiedSamvers[0] || '', tgtVersion, $('#srchTblinfo').val());
				} else {
					loadMultiSamverData(copiedSamvers, tgtVersion, $('#srchTblinfo').val());
				}
				// SAMVER 목록 새로고침
				loadDistinctSamver();
			} else {
				Swal.fire({title:'오류', text: response.message || '복사 처리 중 오류가 발생했습니다.',
					icon:'error', confirmButtonText:'확인', customClass:{popup:'small-swal'}});
			}
		},
		error: function(xhr, status, error) {
			var errMsg = '서버에 문제가 발생했습니다.';
			if (xhr.status === 400) {
				errMsg = xhr.responseText || '대상 버전에 이미 데이터가 존재합니다.';
			}
			Swal.fire({title:'오류', text: errMsg, icon:'error', confirmButtonText:'확인',
				customClass:{popup:'small-swal'}});
		}
	});
}
</script>
<!-- ============================================================== -->
<!-- 버전 복사 기능 End -->
<!-- ============================================================== -->

<!-- ============================================================== -->
<!-- 입력, 수정, 삭제 Start -->
<!-- ============================================================== -->
<script type="text/javascript">
function cd_validateForm() {
    const results = formValCheck(cd_inputZone.id, {
    	tblinfo:        { kname: "테이블명", k_req: true, k_spc: true, k_clr: true },
    	samver:         { kname: "청구버젼"  , k_req: true },
    	version:        { kname: "서식버젼"  , k_req: true },
    	seq:            { kname: "순번"  , k_req: true },
    	itemNm:         { kname: "항목구분명"  , k_req: true},
    	sortSeq:        { kname: "정렬순서" , k_req: true },
    	startPos:       { kname: "시작위치", k_req: true },
    	endPos:         { kname: "끝위치" , k_req: true },
    	dataType:       { kname: "데이터형태", k_req: true },
    	dbColnm:        { kname: "테이블칼럼", k_req: true },
    	colSize:        { kname: "컬럼사이즈", k_req: true }
    });
    return results;
}

function cd_newuptData() {
	let cd_newData = {
		samver:      $('#samver').val(),
		tblinfo:     $('#tblinfo').val(),
		version:     $('#version').val(),
		subCodeNm:   $('#subCodeNm').val(),
		itemNm:      $('#itemNm').val(),
		seq:         $('#seq').val(),
		sortSeq:     $('#sortSeq').val(),
		startPos:    $('#startPos').val(),
		endPos:      $('#endPos').val(),
		dataType:    $('#dataType').val(),
		decimalPos:  $('#decimalPos').val(),
		dataprocYn:  $('input[name="dataprocYn"]:checked').val() || '',
		dbColnm:     $('#dbColnm').val(),
		dbComcolnm:  $('#dbComcolnm').val(),
		colSize:     $('#colSize').val(),
		startDt_one: $('#startDt_one').val(),
		endDt_one:   $('#endDt_one').val()
	    };
    return cd_newData;
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
	let keysID = [];
	if (selectedRows.count() > 0) {
	    selectedRows.every(function(rowIdx, tableLoop, rowLoop) {
	        var rowData = this.data();
	        let key_ID = {};
	        if (rowData && typeof rowData === "object") {
		        dataTable.settings()[0].aoColumns.forEach(function(column, index) {
		            if (column.primaryKey) {
		            	key_ID[column.name] = rowData[column.data];
		            }
		        });
		        keysID.push(key_ID);
	        }
	    });
	}
	return keysID;
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
		    success: function(response) {
		        const commList = response.data || [];
		        for (var i = 0; i < select_id.length; i++) {
		        	let select = $('#' + select_id[i]);
		            select.empty();
		            let filteredItems = commList.filter(item => item.codeCd === list_code[i]);
		            if (filteredItems.length > 0) {
		            	if (firstnull[i] === "Y")
		            		select.append('<option value="">전체</option>');
		            	filteredItems.forEach(function (item) {
		                    select.append('<option value=' + item.subCode + '>' + item.subCodeNm + '</option>');
		                });
		            } else {
		                select.append('<option value="">No options</option>');
		            }
		        }
		        initCdResultsTable();
		    },
		    error: function(jqXHR, textStatus, errorThrown) {
		    	console.error("Status:   " + jqXHR.status);
		        console.error("Response: " + jqXHR.responseText);
		        initCdResultsTable();
		    }
		});
	}
}

// mask 설정
$(function(e) {
    "use strict";
    $(".date1-inputmask").inputmask("9999-99-99");
});

// modal EnterKey
document.addEventListener('DOMContentLoaded', () => {
	inputEnterFocus(cd_inputZone.id);
});

// 조회 조건 담기 (기존 호환)
function findField(element) {
}

$(document).ready(function () {
    initCdResultsTable();
});

function cd_modal_Open(flag) {
	let cd_modal_OpenFlag = true;
	const cd_insertButton = document.getElementById('cd_form_btn_ins');
    const cd_updateButton = document.getElementById('cd_form_btn_udt');
    const cd_deleteButton = document.getElementById('cd_form_btn_del');

    cd_insertButton.style.display = 'none';
    cd_updateButton.style.display = 'none';
    cd_deleteButton.style.display = 'none';

    switch (flag) {
        case 'I':
            cd_insertButton.style.display = 'inline-block';
            cd_modalHead.innerText  = "입력 모드입니다" ;
            break;
        case 'U':
            cd_updateButton.style.display = 'inline-block';
            cd_modalHead.innerText  = "수정 모드입니다" ;
            break;
        case 'D':
            cd_deleteButton.style.display = 'inline-block';
            cd_modalHead.innerText  = "삭제 모드입니다" ;
            break;
    }
    applyAuthControl();
    formValClear(cd_inputZone.id);

    if (flag == 'I') {
    	if (!cd_dataTable || cd_dataTable.rows().count() === 0) {
    		if (!$('#srchVersion').val()) {
	        	messageBox("1","<h6>먼저 조회를 해주세요. !!</h6><p></p><br>",mainFocus,"","");
	            return;
    		}
        }
    }

    if (flag !== 'I') {
		if (cdedit_Data) {
			formValueSet(cd_inputZone.id, cdedit_Data);
		} else {
			cd_modal_OpenFlag = false;
			messageBox("1","<h6>작업 할 Data가 선택되지 않았습니다. !!</h6><p></p><br>",mainFocus,"","");
			return null;
		}
	}

	if (cd_modal_OpenFlag) {
		var element = document.querySelector('#' + cd_modalName.id);
	    dragElement(element);
	    modal_key_hidden(flag);

	    function dragElement(elmnt) {
	        var pos1 = 0, pos2 = 0, pos3 = 0, pos4 = 0;
	        if (elmnt.querySelector('.modal-header')) {
	            elmnt.querySelector('.modal-header').onmousedown = dragMouseDown;
	        } else {
	            elmnt.onmousedown = dragMouseDown;
	        }
	        function dragMouseDown(e) {
	            e = e || window.event;
	            pos3 = e.clientX;
	            pos4 = e.clientY;
	            document.onmouseup = closeDragElement;
	            document.onmousemove = elementDrag;
	        }
	        function elementDrag(e) {
	            e = e || window.event;
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
	        const modal = document.querySelector('#' + cd_modalName.id);
	        modal.style.top  = "50%";
	        modal.style.left = "50%";
	        modal.style.transform = "translate(-50%, -50%)";
	    }

	    $("#" + cd_modalName.id).on('show.bs.modal', function () {
	        centerModal();
	        var firstFocus = $(this).find('input:first');
	        setTimeout(function () {
     	        $("#" + firstFocus.attr('id')).focus();
	        }, 500);
	    });
	    window.addEventListener('resize', centerModal);
	    $("#" + cd_modalName.id).modal('show');

	    if (getCookie("s_userid")) {
	        cd_inputZone.querySelector("[name='regUser']").value = getCookie("s_userid");
	        cd_inputZone.querySelector("[name='updUser']").value = getCookie("s_userid");
	    }
	    if (getCookie("s_connip")) {
	        cd_inputZone.querySelector("[name='regIp']").value = getCookie("s_connip");
	        cd_inputZone.querySelector("[name='updIp']").value = getCookie("s_connip");
	    }
	}
}

function cd_fn_Insert() {
	const results = cd_validateForm();
	if (results) {
		let dats = [];
		let data = {};
        results.forEach(result => {
        	if (format_convert.length > 0) {
        		if (format_convert.includes(result.id)) {
		            data[result.id] = replaceMulti(result.val,'-','/');
	        	} else {
	        		data[result.id] = result.val;
	        	}
        	} else {
        		data[result.id] = result.val;
        	}
        });
        dats.push(data);
	    $.ajax({
	            type: "POST",
	            url: "/base/samverCdInsert.do",
	            data: JSON.stringify(dats),
	            contentType: "application/json",
	    	    dataType: "json",
	            success: function(response) {
	            	let cd_newData = cd_newuptData();
	            	cd_dataTable.row.add(cd_newData).draw(false);
	            	messageBox("1","<h5> 정상처리 되었습니다 ...... </h5><p></p><br>",mainFocus,"","");
	            	$("#" + cd_modalName.id).modal('hide');
	        	},
	        	error: function(xhr, status, error) {
		         	switch (xhr.status) {
		         	     case 500: messageBox("5","<h5>서버에 문제가 발생했습니다.</h5>" +
	                               "<h6>잠시후 다시, 시도해주십시요. !!</h6>",mainFocus,"","");
		        		    break;
		         	     case 400:
		        		    messageBox("5","<h5>기존자료가 존재합니다.</h5>" +
	                               "<h6>다시 확인하고, 시도해주십시요. !!</h6>",mainFocus,"","");
		        		    break;
		         	     default:
		                     messageBox("5", "<h5>알 수 없는 오류가 발생했습니다.</h5>" +
	                                   "<h6>관리자에게 문의하세요.</h6>", mainFocus, "", "");
	                        break;
		           	}
	        	}
	    });
	}
}

function cd_fn_Update() {
    const results = cd_validateForm();
    if (results) {
        let data = {};
        results.forEach(result => {
        	if (format_convert.length > 0) {
        		if (format_convert.includes(result.id)) {
		            data[result.id] = replaceMulti(result.val,'-','/');
	        	} else {
	        		data[result.id] = result.val;
	        	}
        	} else {
        		data[result.id] = result.val;
        	}
        });
        var selectedRows = cd_dataTable.rows('.selected');
        let keys = dataTableKeys(cd_dataTable, selectedRows);
        let mergeData = keys.map(key => ({ ...data, ...key }));
        $.ajax({
            type: "POST",
            url: "/base/samverCdUpdate.do",
            data: JSON.stringify(mergeData),
            contentType: "application/json",
            dataType: "json",
            success: function(response) {
                let cd_updatedData = cd_newuptData();
                selectedRows.every(function(rowIdx) {
                    let rowData = this.data();
                    Object.keys(cd_updatedData).forEach(function(key) {
                    	rowData[key] = cd_updatedData[key];
                    });
                    this.data(rowData);
                });
                cd_dataTable.draw(false);
                $("#" + cd_modalName.id).modal('hide');
                messageBox("1", "<h5> 정상적으로 업데이트되었습니다. </h5>", mainFocus, "", "");
            },
            error: function(xhr, status, error) {
                messageBox("5", "<h5>서버에 문제가 발생했습니다.</h5><h6>잠시 후 다시 시도해주세요.</h6>", mainFocus, "", "");
            }
        });
    }
}

function cd_fn_Delete() {
	Swal.fire({title:'삭제여부', text:'정말 삭제 하시겠습니까 ?', icon:'question',
			   showCancelButton:true, confirmButtonText:'예', cancelButtonText:'아니오',
			   customClass: { popup: 'small-swal' }
     }).then((result) => {
		let data = {};
		if (result.isConfirmed) {
		    var selectedRows = cd_dataTable.rows('.selected');
			let keys = dataTableKeys(cd_dataTable, selectedRows);
			if (keys.length > 0) {
				$.ajax({
		            type: "POST",
		            url: "/base/samverCdDelete.do",
		    	    data: JSON.stringify(keys),
		    	    contentType: "application/json",
		    	    dataType: "json",
		            success: function(response) {
		            	Swal.fire({
				            title: '처리확인', text: '정상처리 되었습니다.', icon: 'success',
				            confirmButtonText: '확인', timer: 1500, timerProgressBar: true,
				            showConfirmButton: false, customClass: { popup: 'small-swal' }
				        });
					    selectedRows.remove().draw();
					    selectedRow = null;
					    $("#" + cd_modalName.id).modal('hide');
		        	},
		        	error: function(xhr, status, error) {
		        		Swal.fire({
				            title: '에러확인', text: '문제 발생, 잠시후 다시 하십시요.', icon: 'error',
				            confirmButtonText: '확인', timer: 1500, timerProgressBar: true,
				            showConfirmButton: false, customClass: { popup: 'small-swal' }
				        });
		        	}
			    });
			} else {
				Swal.fire({
		            title: '오류확인', text: '삭제 Key가 존재하지 않습니다.', icon: 'warning',
		            confirmButtonText: '확인', timer: 1500, timerProgressBar: true,
		            showConfirmButton: false, customClass: { popup: 'small-swal' }
		        });
			}
		} else if (result.isDismissed) {
			Swal.fire({
	            title: '취소확인', text: '작업이 취소 되었습니다.', icon: 'info',
	            confirmButtonText: '확인', timer: 1000, timerProgressBar: true,
	            showConfirmButton: false, customClass: { popup: 'small-swal' }
	        });
		}
	});
}

function cd_modalClose() {
	$("#" + cd_modalName.id).modal('hide');
}

// 권한조건체크
document.addEventListener("DOMContentLoaded", function() {
    applyAuthControl();
});

</script>
<!-- ============================================================== -->
<!-- 기타 정보 End -->
<!-- ============================================================== -->

<!-- ============================================================== -->
<!-- 인라인 편집 / 자동재계산 / 중간삽입 / 일괄저장 Start -->
<!-- ============================================================== -->
<script type="text/javascript">
// 편집 가능 컬럼 인덱스 (data 필드명 매핑)
var editableColumns = {
	3:  'seq',
	5:  'itemNm',
	6:  'sortSeq',
	7:  'startPos',
	8:  'endPos',
	9:  'dataType',
	10: 'decimalPos',
	11: 'dataprocYn',
	12: 'dbColnm',
	13: 'colSize'
};

// ─── 변경 추적 (원본키 기반) ───
var modifiedKeys = {};  // { "원본키": 현재데이터 }
var newKeys = {};       // { "현재키": true }
var _originalKeys = {}; // 수정 전 원본 키 보관 { 현재키: 원본키 }
var _insertBusy = false;

function _rowKey(rd) {
	return (rd.samver||'') + '|' + (rd.tblinfo||'') + '|' + (rd.version||'') + '|' + (rd.seq||'');
}

// ─── 전체 데이터를 배열로 꺼내서 작업하는 유틸 ───
function _getAllData() {
	var arr = [];
	cd_dataTable.rows().every(function() {
		arr.push(JSON.parse(JSON.stringify(this.data())));
	});
	return arr;
}

// 배열을 테이블에 다시 넣기
function _reloadTable(dataArr, selectSeq, selectSamver) {
	cd_dataTable.clear();
	cd_dataTable.rows.add(dataArr);
	cd_dataTable.order([0, 'asc'], [3, 'asc']).draw(false);

	// 지정 행 선택
	if (selectSeq !== undefined && selectSamver) {
		setTimeout(function() {
			cd_dataTable.rows().every(function() {
				var rd = this.data();
				if (rd.samver === selectSamver && String(rd.seq) === String(selectSeq)) {
					var node = this.node();
					if (node) {
						cd_dataTable.rows('.selected').nodes().each(function(r) { r.classList.remove('selected'); });
						node.classList.add('selected');
						node.scrollIntoView({ block: 'center' });
						cdedit_Data = rd;
					}
				}
			});
			fn_ReapplyColors();
		}, 50);
	} else {
		setTimeout(fn_ReapplyColors, 50);
	}
}

// 같은 그룹(samver+tblinfo+version) 행만 seq순 정렬 추출
function _getGroup(dataArr, samver, tblinfo, version) {
	return dataArr
		.filter(function(r) { return r.samver === samver && r.tblinfo === tblinfo && r.version === version; })
		.sort(function(a, b) { return (parseInt(a.seq)||0) - (parseInt(b.seq)||0); });
}

// 그룹 내 startPos/endPos 연쇄 재계산 (fromSeq 이후)
function _recalcGroup(dataArr, samver, tblinfo, version, fromSeq) {
	var group = _getGroup(dataArr, samver, tblinfo, version);

	// fromSeq 직전 행의 endPos 찾기
	var prevEndPos = 0;
	for (var i = 0; i < group.length; i++) {
		var seq = parseInt(group[i].seq) || 0;
		if (seq < fromSeq) {
			prevEndPos = parseInt(group[i].endPos) || 0;
		}
	}

	// fromSeq부터 연쇄 재계산
	for (var i = 0; i < group.length; i++) {
		var seq = parseInt(group[i].seq) || 0;
		if (seq < fromSeq) continue;

		var cs = parseInt(group[i].colSize) || 1;
		group[i].startPos = String(prevEndPos + 1);
		group[i].endPos = String(prevEndPos + cs);
		prevEndPos = parseInt(group[i].endPos);

		// 변경 추적
		var k = _rowKey(group[i]);
		if (!newKeys[k]) modifiedKeys[k] = true;
	}

	// 변경된 그룹 데이터를 원본 배열에 반영
	for (var i = 0; i < dataArr.length; i++) {
		if (dataArr[i].samver !== samver || dataArr[i].tblinfo !== tblinfo || dataArr[i].version !== version) continue;
		for (var j = 0; j < group.length; j++) {
			if (dataArr[i].seq === group[j].seq) {
				dataArr[i] = group[j];
				break;
			}
		}
	}
}

// ─── 인라인 셀 편집 ───
function fn_InlineEdit(td) {
	var cell = cd_dataTable.cell(td);
	if (!cell || !cell.node()) return;

	var colIdx = cell.index().column;
	var fieldName = editableColumns[colIdx];
	if (!fieldName) {
		var rowData = cd_dataTable.row($(td).closest('tr')).data();
		if (rowData) { cdedit_Data = rowData; cd_modal_Open('U'); }
		return;
	}

	if ($(td).find('input, select').length > 0) return;

	var currentVal = cell.data() || '';
	var rowIdx = cell.index().row;
	var $td = $(td);
	var tdWidth = $td.width();

	if (fieldName === 'dataprocYn') {
		var selectHtml = '<select class="inline-edit-input" style="width:' + Math.max(tdWidth, 50) + 'px; padding:0; font-size:12px; text-align:center;">' +
			'<option value="Y"' + (currentVal === 'Y' ? ' selected' : '') + '>Y</option>' +
			'<option value="N"' + (currentVal === 'N' ? ' selected' : '') + '>N</option></select>';
		$td.html(selectHtml);
		var $sel = $td.find('select');
		$sel.focus();
		var applied = false;
		$sel.on('change blur', function() {
			if (applied) return; applied = true;
			fn_ApplyCellValue(rowIdx, colIdx, fieldName, $(this).val());
		});
		return;
	}

	var inputHtml = '<input type="text" class="inline-edit-input" value="' + currentVal +
		'" style="width:' + Math.max(tdWidth, 40) + 'px; padding:0 2px; font-size:12px; text-align:' +
		(colIdx >= 7 && colIdx <= 8 ? 'right' : 'center') + ';">';
	$td.html(inputHtml);
	var $input = $td.find('input');
	$input.focus().select();

	var applied = false;
	$input.on('keydown', function(e) {
		if (e.key === 'Enter') { e.preventDefault(); $(this).blur(); }
		else if (e.key === 'Escape') { cell.data(currentVal).draw(false); return; }
		else if (e.key === 'Tab') { e.preventDefault(); $(this).blur(); fn_MoveNextEditableCell(rowIdx, colIdx, e.shiftKey); }
	});
	$input.on('blur', function() {
		if (applied) return; applied = true;
		fn_ApplyCellValue(rowIdx, colIdx, fieldName, $(this).val());
	});
}

// ─── 셀 값 적용 + 자동재계산 (배열 재구성 방식) ───
function fn_ApplyCellValue(rowIdx, colIdx, fieldName, newVal) {
	var dataArr = _getAllData();
	var rowData = cd_dataTable.row(rowIdx).data();
	if (!rowData) return;

	// 배열에서 해당 행 찾기
	var targetKey = _rowKey(rowData);
	var target = null;
	for (var i = 0; i < dataArr.length; i++) {
		if (_rowKey(dataArr[i]) === targetKey) { target = dataArr[i]; break; }
	}
	if (!target) return;

	target[fieldName] = newVal;

	// startPos/endPos/colSize 변경시 현재 행 계산 + 이후 행 연쇄 재계산
	if (fieldName === 'startPos' || fieldName === 'endPos' || fieldName === 'colSize') {
		var sp = parseInt(target.startPos) || 0;
		var ep = parseInt(target.endPos) || 0;
		var cs = parseInt(target.colSize) || 0;

		if (fieldName === 'startPos') {
			if (cs > 0) target.endPos = String(sp + cs - 1);
		} else if (fieldName === 'endPos') {
			target.colSize = String(ep - sp + 1);
		} else if (fieldName === 'colSize') {
			target.endPos = String(sp + (parseInt(target.colSize)||1) - 1);
		}

		// 키 추적
		var k = _rowKey(target);
		if (!newKeys[k]) modifiedKeys[k] = true;

		// 이후 행 연쇄 재계산
		var nextSeq = (parseInt(target.seq) || 0) + 1;
		_recalcGroup(dataArr, target.samver, target.tblinfo, target.version, nextSeq);
	} else {
		var k = _rowKey(target);
		if (!newKeys[k]) modifiedKeys[k] = true;
	}

	_reloadTable(dataArr, target.seq, target.samver);
}

// ─── 다음 편집가능 셀로 이동 ───
function fn_MoveNextEditableCell(rowIdx, colIdx, isShift) {
	var editableCols = Object.keys(editableColumns).map(Number).sort(function(a,b){ return a-b; });
	var pos = editableCols.indexOf(colIdx);
	if (!isShift) {
		if (pos < editableCols.length - 1) {
			var td = cd_dataTable.cell(rowIdx, editableCols[pos + 1]).node();
			if (td) setTimeout(function(){ fn_InlineEdit(td); }, 100);
		}
	} else {
		if (pos > 0) {
			var td = cd_dataTable.cell(rowIdx, editableCols[pos - 1]).node();
			if (td) setTimeout(function(){ fn_InlineEdit(td); }, 100);
		}
	}
}

// ─── 중간삽입 (배열 재구성 방식) ───
function fn_InsertMiddle() {
	if (_insertBusy) return;
	_insertBusy = true;
	setTimeout(function() { _insertBusy = false; }, 500);

	if (!cd_dataTable || cd_dataTable.rows().count() === 0) {
		Swal.fire({title:'알림', text:'먼저 데이터를 조회해주세요.', icon:'warning',
			timer:2000, timerProgressBar:true, showConfirmButton:false, customClass:{popup:'small-swal'}});
		return;
	}

	var selectedRow = cd_dataTable.rows('.selected');
	if (selectedRow.count() === 0) {
		Swal.fire({title:'알림', text:'삽입 위치의 행을 먼저 선택해주세요.', icon:'warning',
			timer:2000, timerProgressBar:true, showConfirmButton:false, customClass:{popup:'small-swal'}});
		return;
	}

	// 1) 전체 데이터 배열로 꺼내기
	var dataArr = _getAllData();
	var selData = JSON.parse(JSON.stringify(selectedRow.data()[0]));
	var selSeq = parseInt(selData.seq) || 0;
	var selEndPos = parseInt(selData.endPos) || 0;
	var selSortSeq = parseInt(selData.sortSeq) || 0;
	var samver = selData.samver, tblinfo = selData.tblinfo, version = selData.version;

	// 2) 같은 그룹에서 selSeq보다 큰 행의 seq, sortSeq +1
	for (var i = 0; i < dataArr.length; i++) {
		var r = dataArr[i];
		if (r.samver === samver && r.tblinfo === tblinfo && r.version === version) {
			var rSeq = parseInt(r.seq) || 0;
			if (rSeq > selSeq) {
				// 키 추적 이전
				var oldKey = _rowKey(r);
				r.seq = String(rSeq + 1);
				r.sortSeq = String((parseInt(r.sortSeq)||0) + 1);
				var nk = _rowKey(r);
				if (newKeys[oldKey]) { delete newKeys[oldKey]; newKeys[nk] = true; }
				else { if (modifiedKeys[oldKey]) delete modifiedKeys[oldKey]; modifiedKeys[nk] = true; }
			}
		}
	}

	// 3) 새 행 생성
	var newSeq = selSeq + 1;
	var newRowData = {
		samver:      samver,
		subCodeNm:   selData.subCodeNm || '',
		tblinfo:     tblinfo,
		seq:         String(newSeq),
		version:     version,
		itemNm:      '',
		sortSeq:     String(selSortSeq + 1),
		startPos:    String(selEndPos + 1),
		endPos:      String(selEndPos + 1),
		dataType:    'VARCHAR',
		decimalPos:  '0',
		dataprocYn:  'Y',
		dbColnm:     '',
		colSize:     '1',
		dbComcolnm:  '',
		startDt_one: selData.startDt_one || '',
		endDt_one:   selData.endDt_one || ''
	};
	var newKey = _rowKey(newRowData);
	newKeys[newKey] = true;
	dataArr.push(newRowData);

	// 4) 새 행 이후 startPos/endPos 연쇄 재계산
	_recalcGroup(dataArr, samver, tblinfo, version, newSeq + 1);

	// 5) 테이블 재구성
	_reloadTable(dataArr, newSeq, samver);

	Swal.fire({title:'알림', text:'행이 추가되었습니다.', icon:'success',
		timer:1200, timerProgressBar:true, showConfirmButton:false, customClass:{popup:'small-swal'}});
}

// ─── 행 색상 표시 ───
function fn_ReapplyColors() {
	cd_dataTable.rows().every(function() {
		var rd = this.data();
		var node = this.node();
		if (!node || !rd) return;
		var key = _rowKey(rd);
		if (newKeys[key]) {
			$(node).css('background-color', '#d4edda');
		} else if (modifiedKeys[key]) {
			$(node).css('background-color', '#fff3cd');
		}
	});
}

// ─── 일괄저장 ───
function fn_BulkSave() {
	var hasModified = Object.keys(modifiedKeys).length > 0;
	var hasNew = Object.keys(newKeys).length > 0;

	if (!hasModified && !hasNew) {
		Swal.fire({title:'알림', text:'변경된 데이터가 없습니다.', icon:'info',
			timer:2000, timerProgressBar:true, showConfirmButton:false, customClass:{popup:'small-swal'}});
		return;
	}

	var updateList = [];
	var insertList = [];
	var userId = getCookie("s_userid") || '';
	var connIp = getCookie("s_connip") || '';

	cd_dataTable.rows().every(function() {
		var rd = this.data();
		if (!rd) return;
		var key = _rowKey(rd);

		if (newKeys[key]) {
			var ins = JSON.parse(JSON.stringify(rd));
			ins.regUser = userId;
			ins.regIp = connIp;
			insertList.push(ins);
		} else if (modifiedKeys[key]) {
			var upd = JSON.parse(JSON.stringify(rd));
			upd.updUser = userId;
			upd.updIp = connIp;
			upd.keysamver  = upd.samver;
			upd.keytblinfo = upd.tblinfo;
			upd.keyversion = upd.version;
			upd.keyseq     = upd.seq;
			updateList.push(upd);
		}
	});

	Swal.fire({
		title: '일괄저장 확인',
		html: '<b>수정:</b> ' + updateList.length + '건, <b>신규:</b> ' + insertList.length + '건<br>저장하시겠습니까?',
		icon: 'question', showCancelButton: true, confirmButtonText: '예', cancelButtonText: '아니오',
		customClass: { popup: 'small-swal' }
	}).then(function(result) {
		if (result.isConfirmed) fn_ExecBulkSave(updateList, insertList);
	});
}

function fn_ExecBulkSave(updateList, insertList) {
	var promises = [];
	if (updateList.length > 0) {
		promises.push($.ajax({ type:"POST", url:"/base/samverCdUpdate.do",
			data:JSON.stringify(updateList), contentType:"application/json", dataType:"json" }));
	}
	if (insertList.length > 0) {
		promises.push($.ajax({ type:"POST", url:"/base/samverCdInsert.do",
			data:JSON.stringify(insertList), contentType:"application/json", dataType:"json" }));
	}
	$.when.apply($, promises).done(function() {
		Swal.fire({ title:'처리확인', text:'일괄저장이 정상처리 되었습니다.', icon:'success',
			timer:2000, timerProgressBar:true, showConfirmButton:false, customClass:{popup:'small-swal'} });
		modifiedKeys = {};
		newKeys = {};
		fn_Search();
	}).fail(function() {
		Swal.fire({title:'오류', text:'저장 처리 중 오류가 발생했습니다.', icon:'error',
			confirmButtonText:'확인', customClass:{popup:'small-swal'}});
	});
}

// DataTable draw 이벤트에 색상 재적용
var _drawBound = false;
var checkInterval = setInterval(function() {
	if (cd_dataTable && !_drawBound) {
		_drawBound = true;
		cd_dataTable.on('draw', function() { fn_ReapplyColors(); });
		clearInterval(checkInterval);
	}
}, 500);
</script>
<!-- ============================================================== -->
<!-- 인라인 편집 / 자동재계산 / 중간삽입 / 일괄저장 End -->
<!-- ============================================================== -->

<style>
.inline-edit-input {
	border: 1px solid #80bdff;
	border-radius: 2px;
	outline: none;
	height: 22px;
	box-sizing: border-box;
}
.inline-edit-input:focus {
	border-color: #007bff;
	box-shadow: 0 0 3px rgba(0,123,255,0.5);
}
</style>
