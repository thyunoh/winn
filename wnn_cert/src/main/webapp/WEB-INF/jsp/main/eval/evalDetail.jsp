<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<style>
    .eval-info-label { font-weight: 600; color: #495057; }
    .score-input { width: 70px; text-align: center; }
    .grade-select { width: 90px; }
    .evidence-input { min-width: 120px; }
    .modified-row { background-color: #fff9e6 !important; }
    .summary-card { font-size: 0.9rem; }
    .summary-card .score-val { font-size: 1.3rem; font-weight: 700; }
</style>

<input type="hidden" id="evalId" value="${param.evalId}">

<div class="container-fluid px-4 py-3">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h4 class="mb-0">평가 상세</h4>
        <a href="/eval/evalMain.do" class="btn btn-sm btn-outline-secondary">목록</a>
    </div>

    <!-- Eval Info -->
    <div class="card shadow-sm mb-3">
        <div class="card-body py-2">
            <div class="row">
                <div class="col-md-2">
                    <span class="eval-info-label">평가연도:</span>
                    <span id="infoEvalYear">-</span>
                </div>
                <div class="col-md-2">
                    <span class="eval-info-label">평가주기:</span>
                    <span id="infoEvalCycle">-</span>
                </div>
                <div class="col-md-2">
                    <span class="eval-info-label">상태:</span>
                    <span id="infoEvalStatus">-</span>
                </div>
                <div class="col-md-3">
                    <span class="eval-info-label">시작일:</span>
                    <span id="infoStartDt">-</span>
                </div>
                <div class="col-md-3">
                    <span class="eval-info-label">종료일:</span>
                    <span id="infoEndDt">-</span>
                </div>
            </div>
        </div>
    </div>

    <!-- Filter by tree level -->
    <div class="card shadow-sm mb-3">
        <div class="card-body py-2">
            <form class="form-inline">
                <div class="form-group mr-3">
                    <label for="filterLevel1" class="mr-2">영역</label>
                    <select class="form-control form-control-sm" id="filterLevel1" style="width:180px;">
                        <option value="">전체</option>
                    </select>
                </div>
                <div class="form-group mr-3">
                    <label for="filterLevel2" class="mr-2">장</label>
                    <select class="form-control form-control-sm" id="filterLevel2" style="width:180px;">
                        <option value="">전체</option>
                    </select>
                </div>
                <button type="button" class="btn btn-sm btn-primary" id="btnFilter">조회</button>
            </form>
        </div>
    </div>

    <!-- Eval Detail Table -->
    <div class="card shadow-sm mb-3">
        <div class="card-header bg-white d-flex justify-content-between align-items-center">
            <span class="font-weight-bold">평가 항목</span>
            <button type="button" class="btn btn-sm btn-success" id="btnSaveDtl">저장</button>
        </div>
        <div class="card-body p-0" style="overflow-x:auto;">
            <table class="table table-bordered table-hover table-sm mb-0" id="evalDtlTable">
                <thead class="thead-light">
                    <tr>
                        <th style="width:40px;">No</th>
                        <th style="width:110px;">영역</th>
                        <th style="width:110px;">장</th>
                        <th style="width:120px;">기준</th>
                        <th>항목명</th>
                        <th style="width:80px;">평가유형</th>
                        <th style="width:80px;">점수</th>
                        <th style="width:100px;">등급</th>
                        <th style="width:160px;">근거자료</th>
                        <th style="width:140px;">비고</th>
                    </tr>
                </thead>
                <tbody id="evalDtlBody">
                    <tr>
                        <td colspan="10" class="text-center py-3">데이터를 불러오는 중입니다...</td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>

    <!-- Score Summary -->
    <div class="card shadow-sm">
        <div class="card-header bg-white font-weight-bold">점수 요약</div>
        <div class="card-body" id="scoreSummaryArea">
            <div class="text-center text-muted py-2">데이터를 불러오는 중입니다...</div>
        </div>
    </div>
</div>

<script>
var evalId = '';
var modifiedRows = {};

$(document).ready(function() {
    evalId = $('#evalId').val();
    if (!evalId) {
        alert('평가 ID가 없습니다.');
        return;
    }

    loadEvalDtlList();
    loadEvalScoreSummary();
    loadLevel1Filter();

    $('#filterLevel1').on('change', function() {
        loadLevel2Filter($(this).val());
    });

    $('#btnFilter').on('click', function() {
        loadEvalDtlList();
    });

    $('#btnSaveDtl').on('click', function() {
        saveEvalDtl();
    });
});

/* ========== Filters (tree-based) ========== */
function loadLevel1Filter() {
    $.ajax({
        url: '/cert/getTreeList.do',
        type: 'POST',
        data: { compCd: '0001', tabId: 'CERT', grpCd: 'STD', parentId: '00' },
        dataType: 'json',
        success: function(res) {
            if (res.result === 'success') {
                var sel = $('#filterLevel1');
                sel.find('option:not(:first)').remove();
                $.each(res.data, function(i, node) {
                    sel.append('<option value="' + node.nodeId + '">' + node.nodeNm + '</option>');
                });
            }
        }
    });
}

function loadLevel2Filter(parentId) {
    var sel = $('#filterLevel2');
    sel.find('option:not(:first)').remove();
    if (!parentId) return;

    $.ajax({
        url: '/cert/getTreeList.do',
        type: 'POST',
        data: { compCd: '0001', tabId: 'CERT', grpCd: 'STD', parentId: parentId },
        dataType: 'json',
        success: function(res) {
            if (res.result === 'success') {
                $.each(res.data, function(i, node) {
                    sel.append('<option value="' + node.nodeId + '">' + node.nodeNm + '</option>');
                });
            }
        }
    });
}

/* ========== Detail List ========== */
function loadEvalDtlList() {
    var param = {
        evalId: evalId,
        level1Id: $('#filterLevel1').val(),
        level2Id: $('#filterLevel2').val()
    };

    $.ajax({
        url: '/eval/getEvalDtlList.do',
        type: 'POST',
        data: param,
        dataType: 'json',
        success: function(res) {
            if (res.result === 'success') {
                renderEvalInfo(res.data.evalInfo);
                renderEvalDtlList(res.data.dtlList);
            }
        },
        error: function() {
            alert('평가 상세를 불러오는 중 오류가 발생하였습니다.');
        }
    });
}

function renderEvalInfo(info) {
    if (!info) return;
    $('#infoEvalYear').text(info.evalYear || '-');
    $('#infoEvalCycle').text(info.evalCycle || '-');
    $('#infoEvalStatus').text(info.evalStatus || '-');
    $('#infoStartDt').text(info.startDt || '-');
    $('#infoEndDt').text(info.endDt || '-');
}

function renderEvalDtlList(list) {
    var tbody = $('#evalDtlBody');
    tbody.empty();
    modifiedRows = {};

    if (!list || list.length === 0) {
        tbody.append('<tr><td colspan="10" class="text-center py-3">조회된 데이터가 없습니다.</td></tr>');
        return;
    }

    $.each(list, function(idx, item) {
        var scoreInput = '';
        var gradeSelect = '';

        if (item.evalType === 'Y/N') {
            scoreInput = '<select class="form-control form-control-sm score-input" data-row-idx="' + idx + '" data-field="score">' +
                '<option value=""' + (!item.score ? ' selected' : '') + '>-</option>' +
                '<option value="Y"' + (item.score === 'Y' ? ' selected' : '') + '>Y</option>' +
                '<option value="N"' + (item.score === 'N' ? ' selected' : '') + '>N</option>' +
                '</select>';
        } else {
            scoreInput = '<input type="number" class="form-control form-control-sm score-input"' +
                ' data-row-idx="' + idx + '" data-field="score"' +
                ' value="' + (item.score || '') + '" min="0" max="100" step="0.1">';
        }

        gradeSelect = '<select class="form-control form-control-sm grade-select" data-row-idx="' + idx + '" data-field="grade">' +
            '<option value=""' + (!item.grade ? ' selected' : '') + '>-</option>' +
            '<option value="상"' + (item.grade === '상' ? ' selected' : '') + '>상</option>' +
            '<option value="중"' + (item.grade === '중' ? ' selected' : '') + '>중</option>' +
            '<option value="하"' + (item.grade === '하' ? ' selected' : '') + '>하</option>' +
            '</select>';

        var tr = '<tr data-row-idx="' + idx + '" data-dtl-id="' + (item.dtlId || '') + '"' +
            ' data-node-id="' + (item.nodeId || '') + '">' +
            '<td class="text-center">' + (idx + 1) + '</td>' +
            '<td>' + (item.level1Nm || '') + '</td>' +
            '<td>' + (item.level2Nm || '') + '</td>' +
            '<td>' + (item.nodeNm || '') + '</td>' +
            '<td>' + (item.nodeNm || '') + '</td>' +
            '<td class="text-center">' + (item.evalType || '') + '</td>' +
            '<td class="text-center">' + scoreInput + '</td>' +
            '<td class="text-center">' + gradeSelect + '</td>' +
            '<td><textarea class="form-control form-control-sm evidence-input" data-row-idx="' + idx + '"' +
                ' data-field="evidence" rows="1">' + (item.evidence || '') + '</textarea></td>' +
            '<td><input type="text" class="form-control form-control-sm" data-row-idx="' + idx + '"' +
                ' data-field="note" value="' + (item.note || '') + '"></td>' +
            '</tr>';
        tbody.append(tr);
    });

    // Track modifications
    tbody.find('input, select, textarea').on('change', function() {
        var rowIdx = $(this).data('row-idx');
        var tr = $('tr[data-row-idx="' + rowIdx + '"]');
        tr.addClass('modified-row');
        modifiedRows[rowIdx] = true;
    });
}

/* ========== Save ========== */
function saveEvalDtl() {
    var rows = [];
    $.each(modifiedRows, function(rowIdx) {
        var tr = $('tr[data-row-idx="' + rowIdx + '"]');
        var row = {
            evalId: evalId,
            dtlId: tr.data('dtl-id'),
            nodeId: tr.data('node-id'),
            score: tr.find('[data-field="score"]').val(),
            grade: tr.find('[data-field="grade"]').val(),
            evidence: tr.find('[data-field="evidence"]').val(),
            note: tr.find('[data-field="note"]').val()
        };
        rows.push(row);
    });

    if (rows.length === 0) {
        alert('변경된 항목이 없습니다.');
        return;
    }

    $.ajax({
        url: '/eval/saveEvalDtl.do',
        type: 'POST',
        data: { evalId: evalId, dtlList: rows },
        dataType: 'json',
        success: function(res) {
            if (res.result === 'success') {
                alert('저장되었습니다.');
                modifiedRows = {};
                $('.modified-row').removeClass('modified-row');
                loadEvalScoreSummary();
            } else {
                alert(res.msg || '저장에 실패하였습니다.');
            }
        },
        error: function() {
            alert('저장 중 오류가 발생하였습니다.');
        }
    });
}

/* ========== Score Summary ========== */
function loadEvalScoreSummary() {
    $.ajax({
        url: '/eval/getEvalScoreSummary.do',
        type: 'POST',
        data: { evalId: evalId },
        dataType: 'json',
        success: function(res) {
            if (res.result === 'success') {
                renderScoreSummary(res.data);
            }
        },
        error: function() {
            $('#scoreSummaryArea').html('<div class="text-center text-danger py-2">점수 요약 로딩 실패</div>');
        }
    });
}

function renderScoreSummary(summaryList) {
    var area = $('#scoreSummaryArea');
    area.empty();

    if (!summaryList || summaryList.length === 0) {
        area.html('<div class="text-center text-muted py-2">점수 데이터가 없습니다.</div>');
        return;
    }

    var colors = ['#3498db', '#2ecc71', '#e67e22', '#9b59b6', '#e74c3c', '#1abc9c'];
    var html = '<div class="row">';
    $.each(summaryList, function(idx, node) {
        var color = colors[idx % colors.length];
        html += '<div class="col-lg-3 col-md-6 mb-3">';
        html += '<div class="card summary-card border-0" style="border-left:4px solid ' + color + ' !important;">';
        html += '<div class="card-body py-2">';
        html += '<div class="font-weight-bold">' + (node.nodeNm || '') + '</div>';
        html += '<div class="score-val" style="color:' + color + ';">' + (node.avgScore != null ? node.avgScore : '-') + '</div>';

        if (node.children && node.children.length > 0) {
            html += '<div class="mt-1" style="font-size:0.8rem;">';
            $.each(node.children, function(ci, child) {
                html += '<div class="d-flex justify-content-between">';
                html += '<span>' + (child.nodeNm || '') + '</span>';
                html += '<span class="font-weight-bold">' + (child.avgScore != null ? child.avgScore : '-') + '</span>';
                html += '</div>';
            });
            html += '</div>';
        }

        html += '</div></div></div>';
    });
    html += '</div>';
    area.html(html);
}
</script>
