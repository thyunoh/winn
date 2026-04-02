<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<div class="container-fluid px-4 py-3">
    <h4 class="mb-3">당직/인력 현황</h4>

    <!-- Search Area -->
    <div class="card shadow-sm mb-3">
        <div class="card-body py-2">
            <form class="form-inline" id="searchForm">
                <div class="form-group mr-3">
                    <label for="searchWorkDt" class="mr-2">근무월</label>
                    <input type="month" class="form-control form-control-sm" id="searchWorkDt"
                           name="workDt" style="width:160px;">
                </div>
                <button type="button" class="btn btn-sm btn-primary" id="btnSearch">조회</button>
            </form>
        </div>
    </div>

    <!-- Data Table -->
    <div class="card shadow-sm">
        <div class="card-header bg-white d-flex justify-content-between align-items-center">
            <span class="font-weight-bold">당직/인력 현황 목록</span>
            <button type="button" class="btn btn-sm btn-primary" id="btnAdd">등록</button>
        </div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-bordered table-hover table-sm mb-0" id="dataTable">
                    <thead class="thead-light">
                        <tr>
                            <th style="width:40px;">No</th>
                            <th>일자</th>
                            <th style="width:80px;">입원환자수</th>
                            <th style="width:70px;">의사(필요)</th>
                            <th style="width:70px;">의사(배치)</th>
                            <th style="width:70px;">간호사(필요)</th>
                            <th style="width:70px;">간호사(배치)</th>
                            <th style="width:70px;">법적준수</th>
                            <th>주간당직의</th>
                            <th>야간당직의</th>
                            <th style="width:110px;">관리</th>
                        </tr>
                    </thead>
                    <tbody id="dataBody">
                        <tr>
                            <td colspan="11" class="text-center py-3">조회 버튼을 클릭하세요.</td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<!-- Add/Edit Modal -->
<div class="modal fade" id="formModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="modalTitle">당직/인력 등록</h5>
                <button type="button" class="close" data-dismiss="modal"><span>&times;</span></button>
            </div>
            <div class="modal-body">
                <form id="dataForm">
                    <input type="hidden" id="modalMode" value="add">
                    <input type="hidden" id="modalCompCd" name="compCd" value="0001">
                    <input type="hidden" id="modalSeq" name="seq">
                    <div class="row">
                        <div class="col-md-4">
                            <div class="form-group">
                                <label>일자</label>
                                <input type="date" class="form-control" id="modalWorkDt" name="workDt" required>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group">
                                <label>입원환자수</label>
                                <input type="number" class="form-control" id="modalPatCnt" name="patCnt">
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group">
                                <label>법적준수</label>
                                <select class="form-control" id="modalLegalYn" name="legalYn">
                                    <option value="Y">Y</option>
                                    <option value="N">N</option>
                                </select>
                            </div>
                        </div>
                    </div>
                    <hr>
                    <h6>인력 배치</h6>
                    <div class="row">
                        <div class="col-md-3">
                            <div class="form-group">
                                <label>의사(필요)</label>
                                <input type="number" class="form-control" id="modalDrNeed" name="drNeed">
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label>의사(배치)</label>
                                <input type="number" class="form-control" id="modalDrAssign" name="drAssign">
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label>간호사(필요)</label>
                                <input type="number" class="form-control" id="modalNrNeed" name="nrNeed">
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label>간호사(배치)</label>
                                <input type="number" class="form-control" id="modalNrAssign" name="nrAssign">
                            </div>
                        </div>
                    </div>
                    <hr>
                    <h6>당직 배정</h6>
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label>주간당직의</label>
                                <input type="text" class="form-control" id="modalDayDr" name="dayDr">
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <label>야간당직의</label>
                                <input type="text" class="form-control" id="modalNightDr" name="nightDr">
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label>주간간호사</label>
                                <input type="text" class="form-control" id="modalDayNr" name="dayNr">
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <label>야간간호사</label>
                                <input type="text" class="form-control" id="modalNightNr" name="nightNr">
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <label>비고</label>
                        <input type="text" class="form-control" id="modalNote" name="note">
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
                <button type="button" class="btn btn-primary" id="btnSave">저장</button>
            </div>
        </div>
    </div>
</div>

<script>
$(document).ready(function() {
    $('#btnSearch').on('click', function() { loadList(); });
    $('#btnAdd').on('click', function() { openModal('add'); });
    $('#btnSave').on('click', function() { saveData(); });
    loadList();
});

function loadList() {
    var param = {
        compCd: '0001',
        workDt: $('#searchWorkDt').val()
    };
    $.ajax({
        url: '/manage/getStaffDutyList.do',
        type: 'POST',
        data: param,
        dataType: 'json',
        success: function(res) {
            if (res.result === 'success') renderList(res.data);
        },
        error: function() { alert('데이터를 불러오는 중 오류가 발생하였습니다.'); }
    });
}

function renderList(list) {
    var tbody = $('#dataBody');
    tbody.empty();
    if (!list || list.length === 0) {
        tbody.append('<tr><td colspan="11" class="text-center py-3">조회된 데이터가 없습니다.</td></tr>');
        return;
    }
    $.each(list, function(idx, item) {
        var legalBadge = item.legalYn === 'Y'
            ? '<span class="badge badge-success">Y</span>'
            : '<span class="badge badge-danger">N</span>';
        var tr = '<tr>' +
            '<td class="text-center">' + (idx + 1) + '</td>' +
            '<td class="text-center">' + (item.workDt || '') + '</td>' +
            '<td class="text-center">' + (item.patCnt != null ? item.patCnt : '') + '</td>' +
            '<td class="text-center">' + (item.drNeed != null ? item.drNeed : '') + '</td>' +
            '<td class="text-center">' + (item.drAssign != null ? item.drAssign : '') + '</td>' +
            '<td class="text-center">' + (item.nrNeed != null ? item.nrNeed : '') + '</td>' +
            '<td class="text-center">' + (item.nrAssign != null ? item.nrAssign : '') + '</td>' +
            '<td class="text-center">' + legalBadge + '</td>' +
            '<td class="text-center">' + (item.dayDr || '') + '</td>' +
            '<td class="text-center">' + (item.nightDr || '') + '</td>' +
            '<td class="text-center">' +
                '<button class="btn btn-sm btn-outline-primary mr-1" onclick=\'openModal("edit", ' + JSON.stringify(item).replace(/'/g, "\\'") + ')\'>수정</button>' +
                '<button class="btn btn-sm btn-outline-danger" onclick="deleteData(\'' + item.seq + '\')">삭제</button>' +
            '</td></tr>';
        tbody.append(tr);
    });
}

function openModal(mode, item) {
    $('#modalMode').val(mode);
    if (mode === 'add') {
        $('#modalTitle').text('당직/인력 등록');
        $('#dataForm')[0].reset();
        $('#modalCompCd').val('0001');
        $('#modalSeq').val('');
    } else {
        $('#modalTitle').text('당직/인력 수정');
        $('#modalSeq').val(item.seq);
        $('#modalWorkDt').val(item.workDt);
        $('#modalPatCnt').val(item.patCnt);
        $('#modalDrNeed').val(item.drNeed);
        $('#modalDrAssign').val(item.drAssign);
        $('#modalNrNeed').val(item.nrNeed);
        $('#modalNrAssign').val(item.nrAssign);
        $('#modalLegalYn').val(item.legalYn);
        $('#modalDayDr').val(item.dayDr);
        $('#modalNightDr').val(item.nightDr);
        $('#modalDayNr').val(item.dayNr);
        $('#modalNightNr').val(item.nightNr);
        $('#modalNote').val(item.note);
    }
    $('#formModal').modal('show');
}

function saveData() {
    var param = {
        compCd: $('#modalCompCd').val(),
        seq: $('#modalSeq').val(),
        workDt: $('#modalWorkDt').val(),
        patCnt: $('#modalPatCnt').val(),
        drNeed: $('#modalDrNeed').val(),
        drAssign: $('#modalDrAssign').val(),
        nrNeed: $('#modalNrNeed').val(),
        nrAssign: $('#modalNrAssign').val(),
        legalYn: $('#modalLegalYn').val(),
        dayDr: $('#modalDayDr').val().trim(),
        nightDr: $('#modalNightDr').val().trim(),
        dayNr: $('#modalDayNr').val().trim(),
        nightNr: $('#modalNightNr').val().trim(),
        note: $('#modalNote').val().trim(),
        mode: $('#modalMode').val()
    };
    if (!param.workDt) {
        alert('일자를 입력하세요.');
        return;
    }
    $.ajax({
        url: '/manage/saveStaffDuty.do',
        type: 'POST',
        data: param,
        dataType: 'json',
        success: function(res) {
            if (res.result === 'success') {
                alert('저장되었습니다.');
                $('#formModal').modal('hide');
                loadList();
            } else {
                alert(res.msg || '저장에 실패하였습니다.');
            }
        },
        error: function() { alert('저장 중 오류가 발생하였습니다.'); }
    });
}

function deleteData(seq) {
    if (!confirm('삭제하시겠습니까?')) return;
    $.ajax({
        url: '/manage/deleteStaffDuty.do',
        type: 'POST',
        data: { compCd: '0001', seq: seq },
        dataType: 'json',
        success: function(res) {
            if (res.result === 'success') {
                alert('삭제되었습니다.');
                loadList();
            } else {
                alert(res.msg || '삭제에 실패하였습니다.');
            }
        },
        error: function() { alert('삭제 중 오류가 발생하였습니다.'); }
    });
}
</script>
