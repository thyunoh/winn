<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<div class="container-fluid px-4 py-3">
    <h4 class="mb-3">격리/강박 기록</h4>

    <!-- Search Area -->
    <div class="card shadow-sm mb-3">
        <div class="card-body py-2">
            <form class="form-inline" id="searchForm">
                <div class="form-group mr-3">
                    <label for="searchRestraintType" class="mr-2">유형</label>
                    <select class="form-control form-control-sm" id="searchRestraintType" name="restraintType" style="width:100px;">
                        <option value="">전체</option>
                        <option value="격리">격리</option>
                        <option value="강박">강박</option>
                    </select>
                </div>
                <div class="form-group mr-3">
                    <label for="searchPatNm" class="mr-2">환자명</label>
                    <input type="text" class="form-control form-control-sm" id="searchPatNm" name="patNm" style="width:120px;">
                </div>
                <button type="button" class="btn btn-sm btn-primary" id="btnSearch">조회</button>
            </form>
        </div>
    </div>

    <!-- Data Table -->
    <div class="card shadow-sm">
        <div class="card-header bg-white d-flex justify-content-between align-items-center">
            <span class="font-weight-bold">격리/강박 기록 목록</span>
            <button type="button" class="btn btn-sm btn-primary" id="btnAdd">등록</button>
        </div>
        <div class="card-body p-0">
            <table class="table table-bordered table-hover table-sm mb-0" id="dataTable">
                <thead class="thead-light">
                    <tr>
                        <th style="width:50px;">No</th>
                        <th>환자명</th>
                        <th style="width:80px;">유형</th>
                        <th>시작일시</th>
                        <th>종료일시</th>
                        <th>사유</th>
                        <th>처방의사</th>
                        <th>수행간호사</th>
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

<!-- Add/Edit Modal -->
<div class="modal fade" id="formModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="modalTitle">격리/강박 기록 등록</h5>
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
                        <div class="col-md-4">
                            <div class="form-group">
                                <label>유형</label>
                                <select class="form-control" id="modalRestraintType" name="restraintType">
                                    <option value="격리">격리</option>
                                    <option value="강박">강박</option>
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label>시작일시</label>
                                <input type="datetime-local" class="form-control" id="modalStartDt" name="startDt" required>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <label>종료일시</label>
                                <input type="datetime-local" class="form-control" id="modalEndDt" name="endDt">
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <label>사유</label>
                        <textarea class="form-control" id="modalReason" name="reason" rows="2"></textarea>
                    </div>
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label>적용부위</label>
                                <input type="text" class="form-control" id="modalBodyPart" name="bodyPart">
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <label>모니터링 간격(분)</label>
                                <input type="number" class="form-control" id="modalMonitorInterval" name="monitorInterval">
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-4">
                            <div class="form-group">
                                <label>처방의사</label>
                                <input type="text" class="form-control" id="modalOrderDr" name="orderDr">
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group">
                                <label>수행간호사</label>
                                <input type="text" class="form-control" id="modalNurseNm" name="nurseNm">
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group">
                                <label>피부상태</label>
                                <input type="text" class="form-control" id="modalSkinStatus" name="skinStatus">
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
        restraintType: $('#searchRestraintType').val(),
        patNm: $('#searchPatNm').val().trim()
    };
    $.ajax({
        url: '/manage/getRestraintList.do',
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
        var tr = '<tr>' +
            '<td class="text-center">' + (idx + 1) + '</td>' +
            '<td>' + (item.patNm || '') + '</td>' +
            '<td class="text-center">' + (item.restraintType || '') + '</td>' +
            '<td class="text-center">' + (item.startDt || '') + '</td>' +
            '<td class="text-center">' + (item.endDt || '') + '</td>' +
            '<td>' + (item.reason || '') + '</td>' +
            '<td class="text-center">' + (item.orderDr || '') + '</td>' +
            '<td class="text-center">' + (item.nurseNm || '') + '</td>' +
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
        $('#modalTitle').text('격리/강박 기록 등록');
        $('#dataForm')[0].reset();
        $('#modalCompCd').val('0001');
        $('#modalSeq').val('');
    } else {
        $('#modalTitle').text('격리/강박 기록 수정');
        $('#modalSeq').val(item.seq);
        $('#modalPatCd').val(item.patCd);
        $('#modalPatNm').val(item.patNm);
        $('#modalRestraintType').val(item.restraintType);
        $('#modalStartDt').val(item.startDt);
        $('#modalEndDt').val(item.endDt);
        $('#modalReason').val(item.reason);
        $('#modalBodyPart').val(item.bodyPart);
        $('#modalMonitorInterval').val(item.monitorInterval);
        $('#modalOrderDr').val(item.orderDr);
        $('#modalNurseNm').val(item.nurseNm);
        $('#modalSkinStatus').val(item.skinStatus);
        $('#modalNote').val(item.note);
    }
    $('#formModal').modal('show');
}

function saveData() {
    var param = {
        compCd: $('#modalCompCd').val(),
        seq: $('#modalSeq').val(),
        patCd: $('#modalPatCd').val().trim(),
        patNm: $('#modalPatNm').val().trim(),
        restraintType: $('#modalRestraintType').val(),
        startDt: $('#modalStartDt').val(),
        endDt: $('#modalEndDt').val(),
        reason: $('#modalReason').val().trim(),
        bodyPart: $('#modalBodyPart').val().trim(),
        monitorInterval: $('#modalMonitorInterval').val(),
        orderDr: $('#modalOrderDr').val().trim(),
        nurseNm: $('#modalNurseNm').val().trim(),
        skinStatus: $('#modalSkinStatus').val().trim(),
        note: $('#modalNote').val().trim(),
        mode: $('#modalMode').val()
    };
    if (!param.patNm || !param.startDt) {
        alert('필수 항목을 입력하세요.');
        return;
    }
    $.ajax({
        url: '/manage/saveRestraint.do',
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
        url: '/manage/deleteRestraint.do',
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
