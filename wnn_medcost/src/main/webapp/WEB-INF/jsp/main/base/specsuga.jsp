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
/* ===== disabled select 글자 선명하게 (수정/삭제 모드 코드구분) ===== */
#modalName .modal-body .custom-select:disabled,
#modalName .modal-body select:disabled {
	color: #495057 !important;
	opacity: 1 !important;
	-webkit-text-fill-color: #495057 !important;  /* Safari/Chrome */
	background-color: #e9ecef !important;
}
/* ===== DataTables 기본 페이지네이션 숨김 (수동 페이지만 사용) ===== */
.dataTables_wrapper,
#tableName_wrapper {
	width: 100% !important;
	overflow: visible !important;
}
.dataTables_wrapper .dataTables_paginate,
.dataTables_wrapper .dt-paging,
.dt-container .dt-paging,
div.dataTables_paginate,
div.dt-paging {
	display: none !important;
}
.dataTables_wrapper .dataTables_info,
.dataTables_wrapper .dt-info,
.dt-container .dt-info {
	float: left !important;
	padding-top: 10px !important;
	display: block !important;
}
.dataTables_wrapper:after,
#tableName_wrapper:after {
	content: "";
	display: table;
	clear: both;
}
/* ===== 수동 페이지네이션 (유일하게 보이는 페이지 영역) ===== */
#manualPaging {
	clear: both;
	display: block !important;
	visibility: visible !important;
	text-align: right;
	padding: 8px 4px;
}
#manualPaging button {
	font-size: 13px;
	cursor: pointer;
}
#manualPaging button:not([disabled]):hover {
	background: #e9f3ff !important;
	border-color: #0d6efd !important;
}
#manualPaging button[disabled] {
	cursor: not-allowed;
}
</style>
<!-- ============================================================== -->
<!-- Main Form start -->
<!-- ============================================================== -->
<div class="dashboard-wrapper">
	<div class="container-fluid dashboard-content">
		<div class="row">
			<div class="col-xl-12 col-lg-12">
				<div class="card">
					<div class="card-body">
						<div class="form-row mb-2">
							<div class="col-sm-2">
								<select id="findCodeFlag" class="custom-select" oninput="findField(this)" style="height:38px;">
								</select>
							</div>
							<div class="col-sm-4">
								<div class="input-group">
									<input id="findData" type="text" class="form-control" placeholder="EDI코드/상품명/성분/업체명 (2글자 이상)"
									       onkeyup="findEnterKey()" oninput="findField(this)">
									<div class="input-group-append">
										<button type="button" class="btn btn-rounded btn-primary" onClick="fn_FindData()">조회. <i class="fas fa-search"></i></button>
									</div>
								</div>
							</div>
							<div class="col-sm-6">
								<div class="btn-group ml-auto">
									<button class="btn btn-outline-dark" data-toggle="tooltip" data-placement="top" title="" onClick="fn_re_load()">재조회. <i class="fas fa-binoculars"></i></button>
									<button class="btn btn-outline-dark btn-insert" data-toggle="tooltip" data-placement="top" title="신규 Data 입력" onClick="modal_Open('I')">입력. <i class="far fa-edit"></i></button>
									<button class="btn btn-outline-dark btn-update" data-toggle="tooltip" data-placement="top" title="선택 Data 수정" onClick="modal_Open('U')">수정. <i class="far fa-save"></i></button>
									<button class="btn btn-outline-dark btn-delete" data-toggle="tooltip" data-placement="top" title="선택 Data 삭제" onClick="modal_Open('D')">삭제. <i class="far fa-trash-alt"></i></button>
									<button class="btn btn-outline-dark" data-toggle="tooltip" data-placement="top" title="화면 Size 확대.축소" id="fullscreenToggle">화면확장축소. <i class="fas fa-expand" id="fullscreenIcon"></i></button>
								</div>
							</div>
						</div>
						<div style="width: 100%;">
							<table id="tableName" class="display nowrap stripe hover cell-border order-column responsive">
							</table>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
<!-- ============================================================== -->
<!-- modal form start -->
<!-- ============================================================== -->
<div class="modal fade" id="modalName" tabindex="-1" data-backdrop="static" role="dialog" aria-hidden="false" data-keyboard="false">
	<div class="modal-dialog modal-dialog-centered modal-dialog-scrollable" role="dialog" style="position:absolute; top:50%; left:50%;
	     transform:translate(-50%, -50%); width:55vw; max-width:55vw; max-height:65vh;">
		<div class="modal-content" style="height: 45%; display: flex; flex-direction: column;">
			<div class="modal-header bg-light">
				<h5 class="modal-title" id="modalHead"></h5>
				<div class="form-row">
					<div class="col-sm-12 mb-2" style="text-align:right;">
						<button id="form_btn_new" type="submit" class="btn btn-outline-dark" onClick="fn_Potion()">센터. <i class="far fa-object-group"></i></button>
						<button id="form_btn_ins" type="submit" class="btn btn-outline-info    btn-insert" onClick="fn_Insert()">입력. <i class="far fa-edit"></i></button>
						<button id="form_btn_udt" type="submit" class="btn btn-outline-success btn-update" onClick="fn_Update()">수정. <i class="far fa-save"></i></button>
						<button id="form_btn_del" type="submit" class="btn btn-outline-danger  btn-delete" onClick="fn_Delete()">삭제. <i class="far fa-trash-alt"></i></button>
						<button type="button" class="btn btn-outline-dark" data-dismiss="modal" onClick="modalMainClose()">닫기 <i class="fas fa-times"></i></button>
					</div>
				</div>
			</div>
			<div class="modal-body" style="text-align: left; flex: 1; overflow-y: auto;">
				<div id="inputZone">
					<input type="hidden" id="regUser" name="regUser" value="">
					<input type="hidden" id="updUser" name="updUser" value="">
					<input type="hidden" id="regIp"   name="regIp"   value="">
					<input type="hidden" id="updIp"   name="updIp"   value="">
					<div class="form-group row">
						<label for="codeFlag" class="col-2 col-lg-2 col-form-label text-left">코드구분</label>
						<div class="col-4 col-lg-4">
							<select id="codeFlag" name="codeFlag" class="custom-select" required>
							</select>
						</div>
						<label for="ediCode" class="col-2 col-lg-2 col-form-label text-left">EDI코드</label>
						<div class="col-4 col-lg-4">
							<input id="ediCode" name="ediCode" type="text" class="form-control text-left" required maxlength="10" placeholder="EDI코드">
						</div>
					</div>
					<div class="form-group row">
						<label for="atcCode" class="col-2 col-lg-2 col-form-label text-left">ATC코드</label>
						<div class="col-4 col-lg-4">
							<input id="atcCode" name="atcCode" type="text" class="form-control text-left" maxlength="10" placeholder="ATC코드">
						</div>
						<label for="cancelDt" class="col-2 col-lg-2 col-form-label text-left">취소일자</label>
						<div class="col-4 col-lg-4">
							<input id="cancelDt" name="cancelDt" type="text" class="form-control date1-inputmask" placeholder="yyyy-mm-dd">
						</div>
					</div>
					<div class="form-group row">
						<label for="ediName" class="col-2 col-lg-2 col-form-label text-left">상품명</label>
						<div class="col-10 col-lg-10">
							<input id="ediName" name="ediName" type="text" class="form-control text-left" maxlength="500" placeholder="상품명">
						</div>
					</div>
					<div class="form-group row">
						<label for="drugIng" class="col-2 col-lg-2 col-form-label text-left">약성분</label>
						<div class="col-4 col-lg-4">
							<input id="drugIng" name="drugIng" type="text" class="form-control text-left" maxlength="50" placeholder="약성분">
						</div>
						<label for="drugName" class="col-2 col-lg-2 col-form-label text-left">약성분명</label>
						<div class="col-4 col-lg-4">
							<input id="drugName" name="drugName" type="text" class="form-control text-left" maxlength="50" placeholder="약성분명">
						</div>
					</div>
					<div class="form-group row">
						<label for="compName" class="col-2 col-lg-2 col-form-label text-left">업체명</label>
						<div class="col-4 col-lg-4">
							<input id="compName" name="compName" type="text" class="form-control text-left" maxlength="100" placeholder="업체명">
						</div>
						<label for="drugSize" class="col-2 col-lg-2 col-form-label text-left">약품규격</label>
						<div class="col-4 col-lg-4">
							<input id="drugSize" name="drugSize" type="text" class="form-control text-left" maxlength="50" placeholder="약품규격">
						</div>
					</div>
				</div>
				<div class="modal-footer"></div>
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
var tableName = document.getElementById('tableName');
tableName.style.display = 'none';
var modalName = document.getElementById('modalName');
var modalHead = document.getElementById('modalHead');
modalHead.innerText = "...";
var inputZone = document.getElementById('inputZone');

var findTxtln  = 0;
var firstflag  = false;
var findValues = [];
findValues.push({ id: "findData",     val: "", chk: true  });
findValues.push({ id: "findCodeFlag", val: "", chk: false });

var mainFocus = 'findData';
var edit_Data = null;
var dataTable = new DataTable();
dataTable.clear();

// 공통코드 - TBL_CODE_DTL (CODE_GB='Z', CODE_CD='SEC_CODE')
var list_flag = ['Z'];
var list_code = ['SEC_CODE', 'SEC_CODE'];
var select_id = ['findCodeFlag', 'codeFlag'];
var firstnull = ['Y', 'Y'];   // findCodeFlag → '전체', codeFlag → '선택'

var format_convert = ['cancelDt'];

// Table Setting
var gridColums = [];
var btm_Scroll = true;        // scrollX 켜고 wrapper 100% 강제로 폭 확보
var auto_Width = false;       // 명시 폭 사용
var page_Hight = false;       // scrollY 끔 (페이지네이션 가려짐 방지)
var p_Collapse = false;

var datWaiting = true;
var page_Navig = true;
var hd_Sorting = true;
var info_Count = true;
var searchShow = true;
var showButton = true;

var copyBtn_nm = '복사.';
var copy_Title = '특정코드관리';
var excelBtnnm = '엑셀.';
var excelTitle = '특정코드관리';
var excelFName = "특정코드관리_";
var printBtnnm = '출력.';
var printTitle = '특정코드관리';

var find_Enter = false;
var row_Select = true;

var colPadding = '0.2px';
var data_Count = [35, 70, 90, 120, 150, 200];
var defaultCnt = 35;

var c_Head_Set = ['코드구분','EDI코드','ATC코드','상품명','약성분','약성분명','업체명','약품규격','취소일자'];
var columnsSet = [
	{ data: 'codeFlagNm', visible: true, className: 'dt-body-center', width: '90px',  name: 'keycodeFlag', primaryKey: true, orderable: true,
	  render: function(data, type, row) {
	      if (type === 'sort' || type === 'type') return row.codeFlag;
	      return data || row.codeFlag || '';
	  }
	},
	{ data: 'ediCode',    visible: true, className: 'dt-body-center', width: '110px', name: 'keyediCode', primaryKey: true, orderable: true },
	{ data: 'atcCode',    visible: true, className: 'dt-body-center', width: '100px', orderable: false },
	{ data: 'ediName',    visible: true, className: 'dt-body-left',   width: '400px', orderable: true },
	{ data: 'drugIng',    visible: true, className: 'dt-body-left',   width: '180px', orderable: false },
	{ data: 'drugName',   visible: true, className: 'dt-body-left',   width: '180px', orderable: true },
	{ data: 'compName',   visible: true, className: 'dt-body-left',   width: '350px', orderable: true },
	{ data: 'drugSize',   visible: true, className: 'dt-body-left',   width: '130px', orderable: false },
	{ data: 'cancelDt',   visible: true, className: 'dt-body-center', width: '110px', orderable: false,
	  render: function(data, type, row) {
	      if (type === 'display') return data ? getFormat(data, 'd1') : '';
	      return data;
	  }
	}
];

var s_CheckBox = true;
var s_AutoNums = true;

var muiltSorts = [
	['codeFlagNm', 'asc'],
	['ediCode',    'asc']
];

var showSortNo = ['codeFlagNm','ediCode','ediName','drugName','compName'];
var hideColums = [];
var txt_Markln = 30;
var markColums = [];
var mousePoint = 'pointer';

window.onload = function() {
	find_Check();
	comm_Check();
};

function triggerEnterKey() {
	let findDataInput = document.getElementById("findData");
	if (findDataInput) {
		findDataInput.focus();
		let enterEvent = new KeyboardEvent("keyup", { key: "Enter" });
		findDataInput.dispatchEvent(enterEvent);
	}
}
</script>

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
document.addEventListener('fullscreenchange',       updateIcon);
document.addEventListener('webkitfullscreenchange', updateIcon);
document.addEventListener('msfullscreenchange',     updateIcon);
function updateIcon() {
	if (document.fullscreenElement) fullscreenIcon.classList.replace('fa-expand', 'fa-compress');
	else                            fullscreenIcon.classList.replace('fa-compress', 'fa-expand');
}
</script>

<!-- ============================================================== -->
<!-- modal Form 띄우기 Start -->
<!-- ============================================================== -->
<script type="text/javascript">
function modal_key_hidden(flag) {
	const ediCodeInput  = document.getElementById("ediCode");
	const codeFlagInput = document.getElementById("codeFlag");
	const isReadOnly = (flag !== 'I');
	if (ediCodeInput) {
		ediCodeInput.readOnly = isReadOnly;
		ediCodeInput.style.backgroundColor = isReadOnly ? '#e9ecef' : '';
	}
	if (codeFlagInput) {
		// select 는 readOnly 가 동작하지 않으므로 disabled 사용
		codeFlagInput.disabled = isReadOnly;
		codeFlagInput.style.backgroundColor = isReadOnly ? '#e9ecef' : '';
	}
}
function modal_Open(flag) {
	let modal_OpenFlag = true;
	const insertButton = document.getElementById('form_btn_ins');
	const updateButton = document.getElementById('form_btn_udt');
	const deleteButton = document.getElementById('form_btn_del');

	insertButton.style.display = 'none';
	updateButton.style.display = 'none';
	deleteButton.style.display = 'none';

	switch (flag) {
		case 'I': insertButton.style.display = 'inline-block'; modalHead.innerText = "입력 모드입니다"; break;
		case 'U': updateButton.style.display = 'inline-block'; modalHead.innerText = "수정 모드입니다"; break;
		case 'D': deleteButton.style.display = 'inline-block'; modalHead.innerText = "삭제 모드입니다"; break;
	}
	applyAuthControl();
	formValClear(inputZone.id);

	if (flag !== 'I') {
		if (edit_Data) {
			formValueSet(inputZone.id, edit_Data);
		} else {
			modal_OpenFlag = false;
			messageBox("1","<h5>작업 할 Data가 선택되지 않았습니다. !!</h5><p></p><br>", mainFocus, "", "");
			return null;
		}
	}

	if (modal_OpenFlag) {
		var element = document.querySelector('#' + modalName.id);
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
				pos3 = e.clientX; pos4 = e.clientY;
				document.onmouseup = closeDragElement;
				document.onmousemove = elementDrag;
			}
			function elementDrag(e) {
				e = e || window.event;
				pos1 = pos3 - e.clientX; pos2 = pos4 - e.clientY;
				pos3 = e.clientX;        pos4 = e.clientY;
				elmnt.style.top  = (elmnt.offsetTop  - pos2) + "px";
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
		$("#" + modalName.id).on('show.bs.modal', function () {
			centerModal();
			var firstFocus = $(this).find('input:first');
			setTimeout(function () { $("#" + firstFocus.attr('id')).focus(); }, 500);
		});
		window.addEventListener('resize', centerModal);
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
<!-- DataTable 설정 Start -->
<!-- ============================================================== -->
<script type="text/javascript">
// 수동 페이지네이션 fallback — DataTables paging 이 어떤 이유로 보이지 않을 때 직접 그려줌
function renderManualPaging(api) {
	if (!api) return;
	var info = api.page.info();
	var $wrapper = $('#' + tableName.id).closest('.dataTables_wrapper');
	if (!$wrapper.length) $wrapper = $('#tableName_wrapper');

	var $box = $wrapper.find('#manualPaging');
	if ($box.length === 0) {
		$wrapper.append('<div id="manualPaging" style="text-align:right; padding:8px 4px; font-size:13px;"></div>');
		$box = $wrapper.find('#manualPaging');
	}
	if (info.pages <= 1) { $box.empty(); return; }

	var cur = info.page;            // 0-based
	var total = info.pages;
	var start = Math.max(0, cur - 3);
	var end   = Math.min(total - 1, cur + 3);

	var html = '';
	html += btnHTML('이전', cur - 1, cur === 0);
	if (start > 0) {
		html += btnHTML('1', 0, false);
		if (start > 1) html += '<span style="padding:0 4px;">…</span>';
	}
	for (var i = start; i <= end; i++) {
		html += btnHTML(String(i + 1), i, false, i === cur);
	}
	if (end < total - 1) {
		if (end < total - 2) html += '<span style="padding:0 4px;">…</span>';
		html += btnHTML(String(total), total - 1, false);
	}
	html += btnHTML('다음', cur + 1, cur === total - 1);
	$box.html(html);

	$box.find('button').off('click').on('click', function() {
		var p = parseInt($(this).attr('data-page'), 10);
		if (!isNaN(p)) api.page(p).draw('page');
	});

	function btnHTML(text, page, disabled, current) {
		var bg = current ? '#0d6efd' : '#fff';
		var fg = current ? '#fff' : '#333';
		var br = current ? '#0d6efd' : '#ccc';
		var op = disabled ? 0.4 : 1;
		var st = 'border:1px solid ' + br + '; background:' + bg + '; color:' + fg + '; padding:3px 9px; margin:0 2px; border-radius:3px; cursor:pointer; opacity:' + op + ';';
		return '<button type="button" data-page="' + page + '" ' + (disabled ? 'disabled' : '') + ' style="' + st + '">' + text + '</button>';
	}
}

function fn_FirstGridSet() {
	(function($) {
		dataTable = $('#' + tableName.id).DataTable({
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
			search: { return: find_Enter },
			rowCallback: function(row, data, index) { $(row).find('td').css('padding', colPadding); },
			lengthMenu: [data_Count, data_Count],
			pageLength: defaultCnt,
			dom: showButton
				? '<"datatable-controls d-flex align-items-center justify-content-between"<"d-flex"<"mr-2"l><"mr-2"B><"ml-auto"f>>>' + 't' + '<"row mt-2"<"col-sm-7"i><"col-sm-5"p>>'
				: '<"datatable-controls d-flex align-items-center justify-content-between"<"d-flex"<"mr-2"l><"ml-auto"f>>>' + 't' + '<"row mt-2"<"col-sm-7"i><"col-sm-5"p>>',
			pagingType: 'simple_numbers',
			drawCallback: function() {
				renderManualPaging(this.api());
			},
			initComplete: function() {
				renderManualPaging(this.api());
			},
			buttons: showButton
				? [
					{ extend: 'copy', text: copyBtn_nm, title: copy_Title },
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
						extend: 'print', text: printBtnnm, autoPrint: true, title: printTitle,
						customize: function(win) {
							$(win.document.body).find('h1').text(printTitle);
							$(win.document.body).css('font-size', '10pt');
							$(win.document.body).find('table').addClass('compact').css('font-size', 'inherit');
						}
					}]
				: [],
			columns: gridColums,
			order: muiltSorts,
			columnDefs: [
				{ orderable: true,  targets: showSortNo },
				{ orderable: false, targets: '_all' },
				{ visible:   false, targets: hideColums },
				{
					targets: markColums,
					render: function(data, type, row) {
						return type === 'display' && data && data.length > txt_Markln ?
						       data.substr(0, txt_Markln) + '...' : data;
					}
				},
				{
					targets: ['_all'],
					createdCell: function (td, cellData, rowData, row, col) { $(td).css('cursor', mousePoint); }
				}
			],
			ajax: dataLoad,
		});

		$('#selectAll').on('click', function() {
			var rows = dataTable.rows({ 'search': 'applied' }).nodes();
			$('input[type="checkbox"]', rows).prop('checked', this.checked);
		});

		$('#' + tableName.id + ' tbody').on('change', 'input[type="checkbox"]', function() {
			var allChecked = ($('input[type="checkbox"]:checked', dataTable.rows().nodes()).length === dataTable.rows().count());
			$('#selectAll').prop('checked', allChecked);
		});

		dataTable.on('click', 'td', function(e) {
			var column = $(this).index();
			var $row = $(this).closest('tr');
			var $checkbox = $row.find('input[type="checkbox"]');
			if ((!$(e.target).is(':checkbox')) & column === 0) {
				e.preventDefault();
				$checkbox.trigger('click');
			}
		});

		dataTable.on('change', 'input[type="checkbox"]', function(e) { e.stopPropagation(); });

		dataTable.on('click', 'tbody tr', function() { edit_Data = dataTable.row(this).data(); });

		if (row_Select) {
			dataTable.on('click', 'tbody tr', (e) => {
				let classList = e.currentTarget.classList;
				if (!classList.contains('selected')) {
					dataTable.rows('.selected').nodes().each((row) => row.classList.remove('selected'));
					classList.add('selected');
				}
			});
		}
		$('#' + tableName.id + ' tbody').on('dblclick', 'tr', function () {
			let table = $('#' + tableName.id).DataTable();
			let rowData = table.row(this).data();
			modal_Open('U', rowData);
		});

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

function dataLoad(data, callback, settings) {
	let find = {};
	for (let findValue of findValues) {
		find[findValue.id === 'findData' ? 'findData' :
		     findValue.id === 'findCodeFlag' ? 'codeFlag' : findValue.id] = findValue.val;
	}

	$.ajax({
		type: "POST",
		url: "/base/drugMstList.do",
		data: find,
		dataType: "json",
		success: function (response) {
			if (response && Object.keys(response).length > 0) callback(response);
			else                                              callback({ data: [] });
		},
		error: function () { callback({ data: [] }); }
	});
}

function fn_FindData() {
	if (findValues && findValues.length > 0) {
		if (findTxtln > 0) {
			const foundItem = findValues.find(item => item.chk === true);
			if (foundItem !== undefined) {
				const index = findValues.findIndex(item => item.id === foundItem.id);
				let { kCount, eCount, nCount, tCount } = getLengthCounts(findValues[index].val);
				if (tCount >= findTxtln) fn_FindDataTable();
				else                     messageBox("4","조회시 " + findTxtln + "글자 이상 " + getCodeMessage("A001"), findValues[index].id, "", "");
			} else {
				messageBox("4","글자수 " + findTxtln + "글자 이상 조건이 있지만 조회 객체에는 true설정 안됨 !!", "", "", "");
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
	$("#selectAll").prop("checked", false);
}

function fn_re_load() {
	if (findValues && findValues.length > 0) fn_FindData();
}
</script>

<!-- ============================================================== -->
<!-- 입력, 수정, 삭제 Start -->
<!-- ============================================================== -->
<script type="text/javascript">
function validateForm() {
	const results = formValCheck(inputZone.id, {
		codeFlag: { kname: "코드구분", k_req: true },
		ediCode:  { kname: "EDI코드",  k_req: true, k_spc: true, k_clr: true },
		atcCode:  { kname: "ATC코드" },
		ediName:  { kname: "상품명" },
		drugIng:  { kname: "약성분" },
		drugName: { kname: "약성분명" },
		compName: { kname: "업체명" },
		drugSize: { kname: "약품규격" },
		cancelDt: { kname: "취소일자" }
	});
	return results;
}

function newuptData() {
	let codeFlag    = $('#codeFlag').val();
	let codeFlagNm  = $('#codeFlag option:selected').text() || codeFlag;
	return {
		codeFlag:   codeFlag,
		codeFlagNm: codeFlagNm,
		ediCode:    $('#ediCode').val(),
		atcCode:    $('#atcCode').val(),
		ediName:    $('#ediName').val(),
		drugIng:    $('#drugIng').val(),
		drugName:   $('#drugName').val(),
		compName:   $('#compName').val(),
		drugSize:   $('#drugSize').val(),
		cancelDt:   $('#cancelDt').val()
	};
}

function fn_Insert() {
	const results = validateForm();
	if (!results) return;

	let dats = [];
	let data = {};
	results.forEach(result => {
		if (format_convert.length > 0 && format_convert.includes(result.id)) {
			data[result.id] = replaceMulti(result.val, '-', '');
		} else {
			data[result.id] = result.val;
		}
	});
	dats.push(data);

	$.ajax({
		type: "POST",
		url: "/base/drugMstInsert.do",
		data: JSON.stringify(dats),
		contentType: "application/json",
		dataType: "json",
		success: function() {
			let newData = newuptData();
			dataTable.row.add(newData).draw(false);
			messageBox("1","<h5> 정상처리 되었습니다 ...... </h5><p></p><br>", mainFocus, "", "");
			$("#" + modalName.id).modal('hide');
		},
		error: function(xhr) {
			switch (xhr.status) {
				case 500: messageBox("5","<h5>서버에 문제가 발생했습니다.</h5><h6>잠시후 다시, 시도해주십시요. !!</h6>", mainFocus, "", ""); break;
				case 400: messageBox("5","<h5>기존자료가 존재합니다.</h5><h6>다시 확인하고, 시도해주십시요. !!</h6>", mainFocus, "", ""); break;
				default:  messageBox("5","<h5>알 수 없는 오류가 발생했습니다.</h5><h6>관리자에게 문의하세요.</h6>", mainFocus, "", ""); break;
			}
		}
	});
}

function fn_Update() {
	const results = validateForm();
	if (!results) return;

	let data = {};
	results.forEach(result => {
		if (format_convert.length > 0 && format_convert.includes(result.id)) {
			data[result.id] = replaceMulti(result.val, '-', '');
		} else {
			data[result.id] = result.val;
		}
	});

	var selectedRows = dataTable.rows('.selected');
	let keys = dataTableKeys(dataTable, selectedRows);
	let mergeData = keys.map(key => ({ ...data, ...key }));

	$.ajax({
		type: "POST",
		url: "/base/drugMstUpdate.do",
		data: JSON.stringify(mergeData),
		contentType: "application/json",
		dataType: "json",
		success: function() {
			let updatedData = newuptData();
			selectedRows.every(function() {
				let rowData = this.data();
				Object.keys(updatedData).forEach(function(key) { rowData[key] = updatedData[key]; });
				this.data(rowData);
			});
			dataTable.draw(false);
			$("#" + modalName.id).modal('hide');
			messageBox("1","<h5> 정상적으로 업데이트되었습니다. </h5>", mainFocus, "", "");
		},
		error: function() {
			messageBox("5","<h5>서버에 문제가 발생했습니다.</h5><h6>잠시 후 다시 시도해주세요.</h6>", mainFocus, "", "");
		}
	});
}

function fn_Delete() {
	Swal.fire({
		title: '삭제여부', text: '정말 삭제 하시겠습니까 ?', icon: 'question',
		showCancelButton: true, confirmButtonText: '예', cancelButtonText: '아니오',
		customClass: { popup: 'small-swal' }
	}).then((result) => {
		if (result.isConfirmed) {
			var selectedRows = dataTable.rows('.selected');
			let keys = dataTableKeys(dataTable, selectedRows);
			if (keys.length > 0) {
				$.ajax({
					type: "POST",
					url: "/base/drugMstDelete.do",
					data: JSON.stringify(keys),
					contentType: "application/json",
					dataType: "json",
					success: function() {
						Swal.fire({ title:'처리확인', text:'정상처리 되었습니다.', icon:'success',
						            timer: 1500, timerProgressBar: true, showConfirmButton: false,
						            customClass: { popup: 'small-swal' } });
						selectedRows.remove().draw();
						$("#" + modalName.id).modal('hide');
					},
					error: function() {
						Swal.fire({ title:'에러확인', text:'문제 발생, 잠시후 다시 하십시요.', icon:'error',
						            timer: 1500, timerProgressBar: true, showConfirmButton: false,
						            customClass: { popup: 'small-swal' } });
					}
				});
			} else {
				Swal.fire({ title:'오류확인', text:'삭제 Key가 존재하지 않습니다.', icon:'warning',
				            timer: 1500, timerProgressBar: true, showConfirmButton: false,
				            customClass: { popup: 'small-swal' } });
			}
		} else if (result.isDismissed) {
			Swal.fire({ title:'취소확인', text:'작업이 취소 되었습니다.', icon:'info',
			            timer: 1000, timerProgressBar: true, showConfirmButton: false,
			            customClass: { popup: 'small-swal' } });
		}
	});
}
</script>

<!-- ============================================================== -->
<!-- 기타 정보 Start -->
<!-- ============================================================== -->
<script type="text/javascript">
function dataTableKeys(dataTable, selectedRows) {
	let keysID = [];
	if (selectedRows.count() > 0) {
		selectedRows.every(function() {
			var rowData = this.data();
			let key_ID = {};
			if (rowData && typeof rowData === "object") {
				dataTable.settings()[0].aoColumns.forEach(function(column) {
					if (column.primaryKey) key_ID[column.name] = rowData[column.data === 'codeFlagNm' ? 'codeFlag' : column.data];
				});
				keysID.push(key_ID);
			}
		});
	}
	return keysID;
}

function find_Check() {
	if (!firstflag) {
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
					messageBox("4","조회시 " + findTxtln + "글자 이상 " + getCodeMessage("A001"), findValues[index].id, "", "");
				}
			} else {
				firstflag = true;
				messageBox("4","글자수 " + findTxtln + "글자 이상 조건이 있지만 조회 객체에는 true설정 안됨 !!", mainFocus, "", "");
			}
		} else {
			tableName.style.display = 'inline-block';
			fn_FirstGridSet();
		}
	}
	$("#" + mainFocus).focus();
}

function comm_Check() {
	if (list_code.length > 0) {
		$.ajax({
			type: "POST",
			url: "/base/commList.do",
			data: { listGb: list_flag, listCd: list_code },
			dataType: "json",
			success: function(response) {
				const commList = response.data || [];
				for (var i = 0; i < select_id.length; i++) {
					let select = $('#' + select_id[i]);
					select.empty();
					let filteredItems = commList.filter(item => item.codeCd === list_code[i]);
					if (firstnull[i] === "Y") {
						let firstLabel = (select_id[i] === 'findCodeFlag') ? '전체' : '선택';
						select.append('<option value="">' + firstLabel + '</option>');
					}
					if (filteredItems.length > 0) {
						filteredItems.forEach(function(item) {
							select.append('<option value="' + item.subCode + '">' + item.subCodeNm + '</option>');
						});
					}
				}
			},
			error: function(jqXHR) {
				console.error("commList error: " + jqXHR.status + " " + jqXHR.responseText);
			}
		});
	}
}

$(function() {
	"use strict";
	$(".date1-inputmask").inputmask("9999-99-99");
});

document.addEventListener('DOMContentLoaded', () => { inputEnterFocus(inputZone.id); });

if (c_Head_Set.length > 0) {
	const thead = document.createElement('thead');
	thead.id = 'tableHead';
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
		th.textContent = header;
		tr.appendChild(th);
	});
	thead.appendChild(tr);
	const existingThead = tableName.querySelector('thead');
	if (existingThead) tableName.removeChild(existingThead);
	tableName.insertBefore(thead, tableName.firstChild);
}

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
		    render: function (data, type, row, meta) { return meta.row + 1; }
		});
		setnum++;
	}
	let mark_Colnm = [], show_Sorts = [], hide_Colnm = [], muilt_Sort = [];
	for (let i = 0; i < columnsSet.length; i++) {
		gridColums.push(columnsSet[i]);
		for (let a = 0; a < markColums.length; a++) if (markColums[a] === columnsSet[i].data) mark_Colnm.push(setnum + i);
		for (let b = 0; b < showSortNo.length; b++) if (showSortNo[b] === columnsSet[i].data) show_Sorts.push(setnum + i);
		for (let c = 0; c < hideColums.length; c++) if (hideColums[c] === columnsSet[i].data) hide_Colnm.push(setnum + i);
		for (let d = 0; d < muiltSorts.length; d++) if (muiltSorts[d][0] === columnsSet[i].data) {
			muilt_Sort.push(setnum + i);
			muilt_Sort.push(muiltSorts[d][1]);
		}
	}
	if (mark_Colnm.length > 0) markColums = mark_Colnm;
	if (show_Sorts.length > 0) showSortNo = show_Sorts;
	if (hide_Colnm.length > 0) hideColums = hide_Colnm;
	if (muilt_Sort.length > 0) {
		muiltSorts = [];
		for (let j = 0; j < muilt_Sort.length; j += 2) muiltSorts.push([muilt_Sort[j], muilt_Sort[j + 1]]);
	}
}

function findField(element) {
	const index = findValues.findIndex(item => item.id === element.id);
	if (index !== -1) findValues[index].val = element.value;
	else              findValues.push({ id: element.id, val: element.value });
}

function findEnterKey() { if (event.key === 'Enter') fn_FindData(); }
function modalMainClose() { $("#" + modalName.id).modal('hide'); }

document.addEventListener("DOMContentLoaded", function() { applyAuthControl(); });
</script>
