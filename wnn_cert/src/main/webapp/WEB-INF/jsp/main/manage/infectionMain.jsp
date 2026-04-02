<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<div class="container-fluid px-4 py-3">
    <h4 class="mb-3">감염감시</h4>

    <!-- Search Area -->
    <div class="card shadow-sm mb-3">
        <div class="card-body py-2">
            <form class="form-inline" id="searchForm">
                <div class="form-group mr-3">
                    <label for="searchInfectDtFrom" class="mr-2">발생일</label>
                    <input type="date" class="form-control form-control-sm" id="searchInfectDtFrom"
                           name="infectDtFrom" style="width:150px;">
                    <span class="mx-1">~</span>
                    <input type="date" class="form-control form-control-sm" id="searchInfectDtTo"
                           name="infectDtTo" style="width:150px;">
                </div>
                <div class="form-group mr-3">
                    <label for="searchInfectType" class="mr-2">감염유형</label>
                    <select class="form-control form-control-sm" id="searchInfectType" name="infectType" style="width:120px;">
                        <option value="">전체</option>
                        <option value="요로감염">요로감염</option>
                        <option value="폐렴">폐렴</option>
                        <option value="피부감염">피부감염</option>
                        <option value="MRSA">MRSA</option>
                        <option value="기타">기타</option>
                    </select>
                </div>
                <button type="button" class="btn btn-sm btn-primary" id="btnSearch">조회</button>
            </form>
        </div>
    </div>

    <!-- Data Table -->
    <div class="card shadow-sm">
        <div class="card-header bg-white d-flex justify-content-between align-items-center">
            <span class="font-weight-bold">감염감시 목록</span>
            <button type="button" class="btn btn-sm btn-primary" id="btnAdd">등록</button>
        </div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-bordered table-hover table-sm mb-0" id="dataTable">
                    <thead class="thead-light">
                        <tr>
                            <th style="width:50px;">No</th>
                            <th>발생일</th>
                            <th>환자명</th>
                            <th>병동</th>
                            <th>감염유형</th>
                            <th>원인균</th>
                            <th style="width:80px;">격리여부</th>
                            <th>결과</th>
                            <th style="width:110px;">관리</th>
                        </tr>
                    </thead>
                    <tbody id="dataBody">
                        <tr>
                            <td colspan="9" class="text-center py-3">조회 버튼을 클릭하세요.</td>
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
                <h5 class="modal-title" id="modalTitle">감염감시 등록</h5>
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
                                <label>발생일</label>
                                <input type="date" class="form-control" id="modalInfectDt" name="infectDt" required>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group">
                                <label>환자코드</label>
                                <input type="text" class="form-control" id="modalPatCd" name="patCd">
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group">
                                <label>환자명</label>
                                <input type="text" class="form-control" id="modalPatNm" name="patNm" required>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-4">
                            <div class="form-group">
                                <label>병동</label>
                                <input type="text" class="form-control" id="modalWardNm" name="wardNm">
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group">
                                <label>감염유형</label>
                                <select class="form-control" id="modalInfectType" name="infectType">
                                    <option value="요로감염">요로감염</option>
                                    <option value="폐렴">폐렴</option>
                                    <option value="피부감염">피부감염</option>
                                    <option value="MRSA">MRSA</option>
                                    <option value="기타">기타</option>
                                </select>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group">
                                <label>감염부위</label>
                                <input type="text" class="form-control" id="modalInfectSite" name="infectSite">
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-4">
                            <div class="form-group">
                                <label>검체</label>
                                <input type="text" class="form-control" id="modalSpecimen" name="specimen">
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group">
                                <label>원인균</label>
                                <input type="text" class="form-control" id="modalOrganism" name="organism">
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group">
                                <label>항생제</label>
                                <input type="text" class="form-control" id="modalAntibiotic" name="antibiotic">
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-4">
                            <div class="form-group">
                                <label>격리여부</label>
                                <select class="form-control" id="modalIsolationYn" name="isolationYn">
                                    <option value="N">N</option>
                                    <option value="Y">Y</option>
                                </select>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group">
                                <label>격리유형</label>
                                <input type="text" class="form-control" id="modalIsolationType" name="isolationType">
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group">
                                <label>결과</label>
                                <input type="text" class="form-control" id="modalResult" name="result">
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <label>조치사항</label>
                        <textarea class="form-control" id="modalActionDesc" name="actionDesc" rows="2"></textarea>
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
        infectDtFrom: $('#searchInfectDtFrom').val(),
        infectDtTo: $('#searchInfectDtTo').val(),
        infectType: $('#searchInfectType').val()
    };
    $.ajax({
        url: '/manage/getInfectionList.do',
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
        tbody.append('<tr><td colspan="9" class="text-center py-3">조회된 데이터가 없습니다.</td></tr>');
        return;
    }
    $.each(list, function(idx, item) {
        var isolBadge = item.isolationYn === 'Y'
            ? '<span class="badge badge-danger">Y</span>'
            : '<span class="badge badge-secondary">N</span>';
        var tr = '<tr>' +
            '<td class="text-center">' + (idx + 1) + '</td>' +
            '<td class="text-center">' + (item.infectDt || '') + '</td>' +
            '<td>' + (item.patNm || '') + '</td>' +
            '<td>' + (item.wardNm || '') + '</td>' +
            '<td class="text-center">' + (item.infectType || '') + '</td>' +
            '<td>' + (item.organism || '') + '</td>' +
            '<td class="text-center">' + isolBadge + '</td>' +
            '<td>' + (item.result || '') + '</td>' +
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
        $('#modalTitle').text('감염감시 등록');
        $('#dataForm')[0].reset();
        $('#modalCompCd').val('0001');
        $('#modalSeq').val('');
    } else {
        $('#modalTitle').text('감염감시 수정');
        $('#modalSeq').val(item.seq);
        $('#modalInfectDt').val(item.infectDt);
        $('#modalPatCd').val(item.patCd);
        $('#modalPatNm').val(item.patNm);
        $('#modalWardNm').val(item.wardNm);
        $('#modalInfectType').val(item.infectType);
        $('#modalInfectSite').val(item.infectSite);
        $('#modalSpecimen').val(item.specimen);
        $('#modalOrganism').val(item.organism);
        $('#modalAntibiotic').val(item.antibiotic);
        $('#modalIsolationYn').val(item.isolationYn);
        $('#modalIsolationType').val(item.isolationType);
        $('#modalResult').val(item.result);
        $('#modalActionDesc').val(item.actionDesc);
        $('#modalNote').val(item.note);
    }
    $('#formModal').modal('show');
}

function saveData() {
    var param = {
        compCd: $('#modalCompCd').val(),
        seq: $('#modalSeq').val(),
        infectDt: $('#modalInfectDt').val(),
        patCd: $('#modalPatCd').val().trim(),
        patNm: $('#modalPatNm').val().trim(),
        wardNm: $('#modalWardNm').val().trim(),
        infectType: $('#modalInfectType').val(),
        infectSite: $('#modalInfectSite').val().trim(),
        specimen: $('#modalSpecimen').val().trim(),
        organism: $('#modalOrganism').val().trim(),
        antibiotic: $('#modalAntibiotic').val().trim(),
        isolationYn: $('#modalIsolationYn').val(),
        isolationType: $('#modalIsolationType').val().trim(),
        result: $('#modalResult').val().trim(),
        actionDesc: $('#modalActionDesc').val().trim(),
        note: $('#modalNote').val().trim(),
        mode: $('#modalMode').val()
    };
    if (!param.infectDt || !param.patNm) {
        alert('필수 항목을 입력하세요.');
        return;
    }
    $.ajax({
        url: '/manage/saveInfection.do',
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
        url: '/manage/deleteInfection.do',
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
