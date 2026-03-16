<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="decorator" uri="http://www.opensymphony.com/sitemesh/decorator" %>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/page" prefix="page" %>
<%@ page import ="java.util.Date" %>
<link href="/css/winmc/style_comm.css?v=126" rel="stylesheet">

<style>
  /* 카드 헤더 */
  .excel-card-header {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    color: #fff;
    padding: 16px 24px;
    border-radius: 8px 8px 0 0;
    display: flex;
    align-items: center;
    gap: 10px;
  }
  .excel-card-header h5 {
    margin: 0;
    font-size: 16px;
    font-weight: 600;
    letter-spacing: -0.3px;
    color: #fff;
  }
  .excel-card-header .header-icon {
    font-size: 20px;
    color: #fff;
  }

  /* 요양기관 영역 */
  .hosp-info-bar {
    display: flex;
    align-items: center;
    gap: 12px;
    padding: 14px 20px;
    background: #f8f9ff;
    border-bottom: 1px solid #e8ecf4;
  }
  .hosp-info-bar label {
    font-size: 13px;
    font-weight: 600;
    color: #495057;
    margin: 0;
    white-space: nowrap;
  }
  .hosp-info-bar input {
    max-width: 200px;
    font-size: 14px;
    font-weight: 600;
    color: #495057;
    background: #fff;
    border: 1px solid #ced4da;
    border-radius: 6px;
    padding: 6px 12px;
  }

  /* 업로드 영역 */
  .upload-section {
    padding: 20px 24px;
    border-bottom: 1px solid #eee;
  }
  .upload-row {
    display: flex;
    align-items: center;
    gap: 10px;
    flex-wrap: wrap;
  }
  .file-input-wrapper {
    position: relative;
    display: inline-flex;
    align-items: center;
  }
  .file-input-wrapper input[type="file"] {
    font-size: 13px;
    padding: 7px 12px;
    border: 1px dashed #adb5bd;
    border-radius: 6px;
    background: #fff;
    cursor: pointer;
    transition: border-color 0.2s;
    width: 380px;
  }
  .file-input-wrapper input[type="file"]:hover {
    border-color: #667eea;
  }

  /* 버튼 공통 */
  .btn-excel-preview {
    background: linear-gradient(135deg, #28a745, #20c997);
    color: #fff;
    border: none;
    padding: 8px 20px;
    border-radius: 6px;
    font-size: 13px;
    font-weight: 600;
    cursor: pointer;
    transition: all 0.2s;
    box-shadow: 0 2px 4px rgba(40,167,69,0.3);
  }
  .btn-excel-preview:hover {
    transform: translateY(-1px);
    box-shadow: 0 4px 8px rgba(40,167,69,0.4);
  }
  .btn-excel-save {
    background: linear-gradient(135deg, #667eea, #764ba2);
    color: #fff;
    border: none;
    padding: 8px 20px;
    border-radius: 6px;
    font-size: 13px;
    font-weight: 600;
    cursor: pointer;
    transition: all 0.2s;
    box-shadow: 0 2px 4px rgba(102,126,234,0.3);
  }
  .btn-excel-save:hover {
    transform: translateY(-1px);
    box-shadow: 0 4px 8px rgba(102,126,234,0.4);
  }

  /* 경고 배지 */
  .warning-badge {
    font-size: 12px;
    color: #e74c3c;
    background: #ffeaea;
    padding: 5px 14px;
    border-radius: 20px;
    font-weight: 500;
  }

  /* 미리보기 영역 */
  #excelPreview {
    padding: 16px 24px 24px;
    min-height: 200px;
  }

  /* 검증 박스 */
  .valid-box {
    padding: 14px 18px;
    border-radius: 8px;
    font-size: 13px;
    margin-bottom: 14px;
    box-shadow: 0 1px 3px rgba(0,0,0,0.06);
  }
  .valid-box.success {
    border: 1px solid #b7e4c7;
    background: linear-gradient(135deg, #d4edda, #e8f5e9);
  }
  .valid-box.warning {
    border: 1px solid #f5c6cb;
    background: linear-gradient(135deg, #fff3cd, #fff8e1);
  }
  .valid-summary {
    font-weight: 700;
    font-size: 14px;
    margin-bottom: 10px;
    display: flex;
    align-items: center;
    gap: 8px;
  }
  .valid-summary.pass { color: #155724; }
  .valid-summary.fail { color: #856404; }
  .badge-col {
    display: inline-block;
    padding: 3px 12px;
    border-radius: 14px;
    font-size: 11px;
    font-weight: 600;
    margin: 2px 3px;
    letter-spacing: -0.2px;
  }
  .badge-col.match {
    background: #28a745;
    color: #fff;
  }
  .badge-col.mismatch {
    background: #dc3545;
    color: #fff;
  }
  .missing-info {
    color: #dc3545;
    font-size: 12px;
    margin-top: 8px;
    padding-top: 8px;
    border-top: 1px dashed #f5c6cb;
  }

  /* 데이터 건수 바 */
  .data-count-bar {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 8px 14px;
    background: #f8f9fa;
    border-radius: 6px;
    margin-bottom: 10px;
    font-size: 13px;
    color: #495057;
  }
  .data-count-bar .count {
    font-weight: 700;
    color: #667eea;
  }
  .close-preview-btn {
    background: none;
    border: 1px solid #dee2e6;
    border-radius: 4px;
    padding: 2px 10px;
    font-size: 16px;
    color: #adb5bd;
    cursor: pointer;
    transition: all 0.2s;
    line-height: 1;
  }
  .close-preview-btn:hover {
    background: #fee2e2;
    border-color: #f87171;
    color: #ef4444;
  }

  /* 테이블 래퍼 */
  .table-scroll-wrapper {
    overflow: auto;
    max-height: 400px;
    border: 1px solid #e2e8f0;
    border-radius: 8px;
    box-shadow: 0 1px 4px rgba(0,0,0,0.05);
  }
  .table-scroll-wrapper table {
    border-collapse: collapse;
    width: max-content;
    white-space: nowrap;
    font-size: 13px;
  }
  .table-scroll-wrapper thead th {
    border: 1px solid #cbd5e1;
    padding: 8px 14px;
    position: sticky;
    top: 0;
    z-index: 2;
    text-align: center;
    font-weight: 600;
    font-size: 12px;
    letter-spacing: -0.2px;
  }
  .table-scroll-wrapper thead th.col-valid {
    background: #d1fae5;
    color: #065f46;
    border-bottom: 2px solid #34d399;
  }
  .table-scroll-wrapper thead th.col-invalid {
    background: #fee2e2;
    color: #991b1b;
    border-bottom: 2px solid #f87171;
  }
  .table-scroll-wrapper thead th.col-default {
    background: #f1f5f9;
    color: #475569;
  }
  .table-scroll-wrapper tbody td {
    border: 1px solid #e2e8f0;
    padding: 6px 12px;
    text-align: center;
    color: #374151;
  }
  .table-scroll-wrapper tbody tr:nth-child(even) {
    background: #f8fafc;
  }
  .table-scroll-wrapper tbody tr:hover {
    background: #eef2ff;
  }
  .table-scroll-wrapper tbody td.cell-warn {
    background: #fffbeb;
  }

  /* 로딩 */
  .loading-overlay {
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 10px;
    padding: 40px;
    color: #667eea;
    font-size: 14px;
  }
  .spinner {
    width: 20px;
    height: 20px;
    border: 3px solid #e0e7ff;
    border-top-color: #667eea;
    border-radius: 50%;
    animation: spin 0.7s linear infinite;
  }
  @keyframes spin { to { transform: rotate(360deg); } }
</style>

<div class="dashboard-wrapper">
  <div class="container-fluid dashboard-content">
    <div class="row">
      <div class="col-12">
        <div class="card shadow-sm" style="border-radius: 8px; overflow: hidden; border: none;">

          <!-- 카드 헤더 -->
          <div class="excel-card-header">
            <span class="header-icon"><i class="fas fa-file-excel"></i></span>
            <h5>인력신고현황 엑셀자료 업로드</h5>
          </div>

          <!-- 요양기관 정보 바 -->
          <div class="hosp-info-bar">
            <label>요양기관기호</label>
            <input id="hospCd1" name="hospCd1" type="text" readonly>
          </div>

          <!-- 업로드 영역 -->
          <div class="upload-section">
            <form id="excelForm" action="/uploadExcel" method="post" enctype="multipart/form-data">
              <div class="upload-row">
                <div class="file-input-wrapper">
                  <input type="file" name="excelFile" id="excelFile" accept=".xls,.xlsx"/>
                </div>
                <button type="submit" class="btn-excel-preview">
                  <i class="fas fa-search" style="margin-right: 4px;"></i> 미리보기
                </button>
                <button type="button" id="saveDataBtn" class="btn-excel-save d-none">
                  <i class="fas fa-save" style="margin-right: 4px;"></i> 자료저장
                </button>
                <span class="warning-badge">
                  <i class="fas fa-exclamation-triangle" style="margin-right: 3px;"></i>
                  요양기관 정보를 확인 후 진행하세요
                </span>
              </div>
            </form>
          </div>

          <!-- 미리보기 영역 -->
          <div id="excelPreview"></div>

        </div>
      </div>
    </div>
  </div>
</div>

<!-- 모달 -->
<div class="modal fade" id="modalName" tabindex="-1"
  data-backdrop="static" role="dialog" aria-hidden="false"
  data-keyboard="false">
  <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable"
    role="dialog"
    style="position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); width: 50vw; max-width: 50vw; max-height: 50vh;">
    <div class="modal-content"
      style="height: 60%; display: flex; flex-direction: column;">
      <div class="modal-header bg-light">
        <h6 class="modal-title" id="modalHead"></h6>
      </div>
      <div class="modal-body"
        style="text-align: left; flex: 1; overflow-y: auto;">
        <div id="inputZone">
          <div class="form-group row">
            <label for="hospCd" class="col-2 col-lg-2 col-form-label text-left">요양기관</label>
            <div class="col-4 col-lg-4">
              <div class="input-group">
                <input id="hospCd" name="hospCd" type="text"
                  class="form-control text-left" placeholder="요양기관를 등록하세요">
                <button id="hospserch" class="btn btn-outline-info"><i class="fas fa-search">검색</i></button>
              </div>
            </div>
          </div>
        </div>
        <div class="modal-footer"></div>
      </div>
    </div>
  </div>
</div>
<div id="modalContainer"></div>

<script type="text/javascript">

var findTxtln  = 0;
var firstflag  = false;
var findValues = [];
findValues.push({ id: "findData", val: "",  chk: true  });
let s_hospcd = getCookie("s_hospid");
let s_wnn_yn = getCookie("s_wnn_yn");
let s_hosp_uuid = getCookie("s_hosp_uuid");
if ( (s_hospcd &&  s_wnn_yn != 'Y') || (s_hospcd != s_hosp_uuid) ) {
    findValues.push({ id: "hospCd1", val: s_hospcd,  chk: false  });
    $("#hospCd1").val(s_hospcd);
} else {
    findValues.push({ id: "hospCd1", val:"",  chk: false  });
    $("#hospCd1").val("");
}

var mainFocus = 'findData';
var edit_Data = null;
var dataTable = new DataTable();
dataTable.clear();
var s_CheckBox = true;
var s_AutoNums = true;
var markColums = [];
var mousePoint = 'pointer';

</script>
<script type="text/javascript">

// 병원검색
$("#hospserch").on("click", function () {
    openHospitalSearch(function (data) {
        $("#hospCd").val(data.hospCd);
    });
});

function openHospitalSearch(callback) {
    openCommonSearch("hospital", function (data) {
        if (data && data.hospCd) {
            callback(data);
        } else {
            alert("선택한 병원의 정보가 올바르지 않습니다. 다시 시도해주세요.");
        }
    });
}

let currentHospid = sessionStorage.getItem('hospid');

setInterval(function () {
    let newHospid = sessionStorage.getItem('hospid');
    if (newHospid && newHospid !== currentHospid) {
        currentHospid = newHospid;
        let s_hospcd = getCookie("s_hospid");
        findValues.push({ id: "hospCd1", val: s_hospcd,  chk: false  });
        $("#hospCd1").val(s_hospcd);
        triggerFind();
    }
}, 1000);

function triggerFind() {
    fn_FindData();
}

document.addEventListener("DOMContentLoaded", function() {
    applyAuthControl();
});

let previewData = [];
let headerValidation = [];

// 엑셀 미리보기
document.getElementById("excelForm").addEventListener("submit", function (e) {
  e.preventDefault();

  const fileInput = document.getElementById("excelFile");
  if (!fileInput.files || fileInput.files.length === 0) {
    alert("파일을 선택해주세요.");
    return;
  }

  const container = document.getElementById("excelPreview");
  container.innerHTML = '<div class="loading-overlay"><div class="spinner"></div>엑셀 파일을 분석 중입니다...</div>';

  const formData = new FormData(this);

  fetch("/user/previewExcel.do", {
    method: "POST",
    body: formData,
  })
    .then((res) => {
      const ct = res.headers.get("content-type") || "";
      if (!ct.includes("application/json")) {
        return res.text().then(txt => {
          console.error("서버 응답(비JSON):", txt.substring(0, 500));
          throw new Error("서버에서 JSON 응답을 받지 못했습니다. (HTTP " + res.status + ")");
        });
      }
      return res.json().then(json => {
        if (json.error) throw new Error(json.error);
        return json;
      });
    })
    .then((result) => {
      container.innerHTML = "";

      headerValidation = result.headerValidation || [];
      const missingHeaders = result.missingHeaders || [];
      const unknownHeaders = result.unknownHeaders || [];
      const matchCount = result.matchCount || 0;
      const totalColumns = result.totalColumns || 0;
      const data = result.data || [];
      const formatValid = result.formatValid !== false;

      renderValidation(headerValidation, missingHeaders, unknownHeaders, matchCount, totalColumns, result.titleRowDetected, result.titleRowText, result.matchedType);

      if (data.length > 0) {
        renderTable(data, headerValidation);
      }

      if (formatValid && data.length > 0) {
        document.getElementById("saveDataBtn").classList.remove("d-none");
      } else {
        document.getElementById("saveDataBtn").classList.add("d-none");
      }

      previewData = data;
    })
    .catch((e) => {
      console.error("오류 발생:", e.message);
      container.innerHTML = "";
      alert("오류: " + e.message);
    });
});

// 서식 검증 결과 렌더링
function renderValidation(headerValidation, missingHeaders, unknownHeaders, matchCount, totalColumns, titleRowDetected, titleRowText, matchedType) {
  const container = document.getElementById("excelPreview");
  const formatValid = (unknownHeaders.length === 0 && missingHeaders.length === 0) || (matchedType !== "");

  const box = document.createElement("div");
  box.className = "valid-box " + (formatValid && missingHeaders.length === 0 ? "success" : "warning");

  // 제목행 자동 감지
  if (titleRowDetected) {
    const alertDiv = document.createElement("div");
    alertDiv.style.cssText = "color:#6b7280; margin-bottom:8px; font-size:12px;";
    alertDiv.innerHTML = '<i class="fas fa-info-circle" style="margin-right:4px;"></i> 상단 제목행이 자동 감지되어 제외되었습니다. <span style="color:#9ca3af;">(' + (titleRowText || "") + ')</span>';
    box.appendChild(alertDiv);
  }

  // 양식 타입 + 요약
  const summary = document.createElement("div");
  summary.className = "valid-summary " + (formatValid && missingHeaders.length === 0 ? "pass" : "fail");
  const typeLabel = matchedType ? ' <span style="background:#e0e7ff; color:#4338ca; padding:2px 10px; border-radius:12px; font-size:12px; font-weight:600;">' + matchedType + ' 양식</span>' : '';
  if (formatValid && missingHeaders.length === 0) {
    summary.innerHTML = '<i class="fas fa-check-circle"></i> 서식 검증 통과' + typeLabel + ' <span style="font-weight:400; font-size:13px; color:#6b7280;">(' + matchCount + '/' + totalColumns + '개 컬럼 일치)</span>';
  } else {
    summary.innerHTML = '<i class="fas fa-exclamation-circle"></i> 서식 확인 필요' + typeLabel + ' <span style="font-weight:400; font-size:13px; color:#6b7280;">(' + matchCount + '/' + totalColumns + '개 컬럼 일치)</span>';
  }
  box.appendChild(summary);

  // 컬럼 배지
  const colList = document.createElement("div");
  colList.style.cssText = "display:flex; flex-wrap:wrap; gap:4px;";
  headerValidation.forEach(h => {
    const badge = document.createElement("span");
    badge.className = "badge-col " + (h.valid ? "match" : "mismatch");
    badge.textContent = h.valid ? h.name : h.name + " \u2717";
    colList.appendChild(badge);
  });
  box.appendChild(colList);

  // 누락 컬럼
  if (missingHeaders.length > 0) {
    const miss = document.createElement("div");
    miss.className = "missing-info";
    miss.innerHTML = '<i class="fas fa-exclamation-triangle" style="margin-right:4px;"></i> <b>누락 컬럼:</b> ' + missingHeaders.join(", ");
    box.appendChild(miss);
  }

  // 인식 불가 컬럼
  if (unknownHeaders.length > 0) {
    const unknown = document.createElement("div");
    unknown.className = "missing-info";
    unknown.innerHTML = '<i class="fas fa-question-circle" style="margin-right:4px;"></i> <b>인식 불가 컬럼:</b> ' + unknownHeaders.join(", ");
    box.appendChild(unknown);
  }

  container.appendChild(box);
}

// 테이블 렌더링
function renderTable(data, validation) {
  const container = document.getElementById("excelPreview");

  if (!Array.isArray(data) || data.length === 0) {
    const p = document.createElement("p");
    p.style.cssText = "color:#9ca3af; text-align:center; padding:30px;";
    p.textContent = "미리볼 데이터가 없습니다.";
    container.appendChild(p);
    return;
  }

  const validMap = {};
  if (validation) {
    validation.forEach(h => { validMap[h.name] = h.valid; });
  }

  // 데이터 건수 바
  const countBar = document.createElement("div");
  countBar.className = "data-count-bar";
  countBar.innerHTML = '<span><i class="fas fa-table" style="margin-right:6px; color:#667eea;"></i> 총 <span class="count">' + data.length + '</span>건의 데이터</span>';
  const closeBtn = document.createElement("button");
  closeBtn.className = "close-preview-btn";
  closeBtn.innerHTML = "\u00d7";
  closeBtn.title = "미리보기 닫기";
  closeBtn.addEventListener("click", () => { container.innerHTML = ""; });
  countBar.appendChild(closeBtn);
  container.appendChild(countBar);

  // 테이블
  const wrapper = document.createElement("div");
  wrapper.className = "table-scroll-wrapper";

  const table = document.createElement("table");
  const thead = document.createElement("thead");
  const headerRow = document.createElement("tr");
  const keys = Object.keys(data[0]);

  keys.forEach((key) => {
    const th = document.createElement("th");
    th.textContent = key;
    if (validMap[key] === true) {
      th.className = "col-valid";
    } else if (validMap[key] === false) {
      th.className = "col-invalid";
    } else {
      th.className = "col-default";
    }
    headerRow.appendChild(th);
  });
  thead.appendChild(headerRow);
  table.appendChild(thead);

  const tbody = document.createElement("tbody");
  data.forEach((row) => {
    const tr = document.createElement("tr");
    keys.forEach((key) => {
      const td = document.createElement("td");
      td.textContent = row[key] ?? "";
      if (validMap[key] === false) {
        td.className = "cell-warn";
      }
      tr.appendChild(td);
    });
    tbody.appendChild(tr);
  });

  table.appendChild(tbody);
  wrapper.appendChild(table);
  container.appendChild(wrapper);
}

// 자료 저장
document.getElementById("saveDataBtn").addEventListener("click", () => {
  const fileInput = document.getElementById("excelFile");
  if (!fileInput.files || fileInput.files.length === 0) {
    alert("파일을 선택해주세요.");
    return;
  }
  if (!previewData || previewData.length === 0) {
    alert("저장할 데이터가 없습니다.");
    return;
  }

  const hospCd1 = document.getElementById("hospCd1").value;
  if (hospCd1 === "") {
    messageBox("1", "<h6> 요양기관이 선택되어야합니다. </h6><p></p><br>", mainFocus, "", "");
    return;
  }

  fetch("/user/CellsaveExcelData.do", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ hospCd: hospCd1, data: previewData })
  })
    .then(res => res.json())
    .then(result => {
      if (result.success) {
        messageBox("1", "<h6> 정상적으로 자료가 생성 되었습니다. </h6><p></p><br>", mainFocus, "", "");
        document.getElementById("saveDataBtn").classList.add("d-none");
      } else {
        alert("저장 실패: " + result.message);
      }
    })
    .catch(err => {
      alert("서버 오류 발생");
      console.error(err);
    });
});

document.getElementById('excelFile').addEventListener('change', function() {
    document.getElementById('saveDataBtn').classList.add('d-none');
    document.getElementById('excelPreview').innerHTML = '';
});

</script>
