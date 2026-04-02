<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap4.min.css">

<div class="container-fluid px-4 py-3">
    <h4 class="mb-3">평가 목록</h4>

    <!-- Search Area -->
    <div class="card shadow-sm mb-3">
        <div class="card-body py-2">
            <form class="form-inline" id="searchForm">
                <div class="form-group mr-3">
                    <label for="searchEvalYear" class="mr-2">평가연도</label>
                    <input type="text" class="form-control form-control-sm" id="searchEvalYear"
                           name="evalYear" placeholder="예: 2026" maxlength="4" style="width:100px;">
                </div>
                <div class="form-group mr-3">
                    <label for="searchEvalStatus" class="mr-2">상태</label>
                    <select class="form-control form-control-sm" id="searchEvalStatus" name="evalStatus" style="width:100px;">
                        <option value="">전체</option>
                        <option value="준비">준비</option>
                        <option value="진행">진행</option>
                        <option value="완료">완료</option>
                    </select>
                </div>
                <button type="button" class="btn btn-sm btn-primary" id="btnSearch">조회</button>
            </form>
        </div>
    </div>

    <!-- Eval Table -->
    <div class="card shadow-sm">
        <div class="card-header bg-white d-flex justify-content-between align-items-center">
            <span class="font-weight-bold">평가 목록</span>
            <button type="button" class="btn btn-sm btn-primary" id="btnNewEval">신규 평가</button>
        </div>
        <div class="card-body p-0">
            <table class="table table-bordered table-hover table-sm mb-0" id="evalTable">
                <thead class="thead-light">
                    <tr>
                        <th style="width:50px;">No</th>
                        <th style="width:100px;">평가ID</th>
                        <th style="width:90px;">평가연도</th>
                        <th style="width:80px;">평가주기</th>
                        <th style="width:90px;">상태</th>
                        <th style="width:80px;">결과</th>
                        <th style="width:80px;">총점</th>
                        <th style="width:140px;">등록일시</th>
                        <th style="width:80px;">상세</th>
                    </tr>
                </thead>
                <tbody id="evalBody">
                    <tr>
                        <td colspan="9" class="text-center py-3">조회 버튼을 클릭하세요.</td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
</div>

<!-- New Eval Modal -->
<div class="modal fade" id="evalModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">신규 평가 등록</h5>
                <button type="button" class="close" data-dismiss="modal"><span>&times;</span></button>
            </div>
            <div class="modal-body">
                <form id="evalForm">
                    <div class="form-group">
                        <label for="modalCompCd">기관코드</label>
                        <input type="text" class="form-control" id="modalCompCd" name="compCd" value="0001" required>
                    </div>
                    <div class="form-group">
                        <label for="modalEvalYear">평가연도</label>
                        <input type="text" class="form-control" id="modalEvalYear" name="evalYear"
                               placeholder="예: 2026" maxlength="4" required>
                    </div>
                    <div class="form-group">
                        <label for="modalEvalCycle">평가주기</label>
                        <input type="text" class="form-control" id="modalEvalCycle" name="evalCycle"
                               placeholder="예: 1차">
                    </div>
                    <div class="form-group">
                        <label for="modalStartDt">평가시작일</label>
                        <input type="date" class="form-control" id="modalStartDt" name="startDt" required>
                    </div>
                    <div class="form-group">
                        <label for="modalEndDt">평가종료일</label>
                        <input type="date" class="form-control" id="modalEndDt" name="endDt" required>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
                <button type="button" class="btn btn-primary" id="btnSaveEval">저장</button>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap4.min.js"></script>
<script>
$(document).ready(function() {
    $('#btnSearch').on('click', function() {
        loadEvalList();
    });

    $('#btnNewEval').on('click', function() {
        $('#evalForm')[0].reset();
        $('#modalCompCd').val('0001');
        $('#evalModal').modal('show');
    });

    $('#btnSaveEval').on('click', function() {
        saveEval();
    });

    // Initial load
    loadEvalList();
});

function loadEvalList() {
    var param = {
        evalYear: $('#searchEvalYear').val().trim(),
        evalStatus: $('#searchEvalStatus').val()
    };

    $.ajax({
        url: '/eval/getEvalList.do',
        type: 'POST',
        data: param,
        dataType: 'json',
        success: function(res) {
            if (res.result === 'success') {
                renderEvalList(res.data);
            }
        },
        error: function() {
            alert('평가 목록을 불러오는 중 오류가 발생하였습니다.');
        }
    });
}

function renderEvalList(list) {
    var tbody = $('#evalBody');
    tbody.empty();

    if (!list || list.length === 0) {
        tbody.append('<tr><td colspan="9" class="text-center py-3">조회된 데이터가 없습니다.</td></tr>');
        return;
    }

    $.each(list, function(idx, item) {
        var statusBadge = getStatusBadge(item.evalStatus);
        var tr = '<tr>' +
            '<td class="text-center">' + (idx + 1) + '</td>' +
            '<td class="text-center">' + (item.evalId || '') + '</td>' +
            '<td class="text-center">' + (item.evalYear || '') + '</td>' +
            '<td class="text-center">' + (item.evalCycle || '') + '</td>' +
            '<td class="text-center">' + statusBadge + '</td>' +
            '<td class="text-center">' + (item.evalResult || '-') + '</td>' +
            '<td class="text-center">' + (item.totalScore != null ? item.totalScore : '-') + '</td>' +
            '<td class="text-center">' + (item.regDttm || '') + '</td>' +
            '<td class="text-center">' +
                '<a href="/eval/evalDetail.do?evalId=' + item.evalId + '" class="btn btn-sm btn-outline-info">상세</a>' +
            '</td>' +
            '</tr>';
        tbody.append(tr);
    });
}

function getStatusBadge(status) {
    var cls = 'badge badge-secondary';
    if (status === '준비') cls = 'badge badge-warning';
    else if (status === '진행') cls = 'badge badge-primary';
    else if (status === '완료') cls = 'badge badge-success';
    return '<span class="' + cls + '">' + (status || '') + '</span>';
}

function saveEval() {
    var param = {
        compCd: $('#modalCompCd').val().trim(),
        evalYear: $('#modalEvalYear').val().trim(),
        evalCycle: $('#modalEvalCycle').val().trim(),
        startDt: $('#modalStartDt').val(),
        endDt: $('#modalEndDt').val()
    };

    if (!param.compCd || !param.evalYear || !param.startDt || !param.endDt) {
        alert('필수 항목을 입력하세요.');
        return;
    }

    $.ajax({
        url: '/eval/saveEval.do',
        type: 'POST',
        data: param,
        dataType: 'json',
        success: function(res) {
            if (res.result === 'success') {
                alert('저장되었습니다.');
                $('#evalModal').modal('hide');
                loadEvalList();
            } else {
                alert(res.msg || '저장에 실패하였습니다.');
            }
        },
        error: function() {
            alert('저장 중 오류가 발생하였습니다.');
        }
    });
}
</script>
