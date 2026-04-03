<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<div class="container-fluid px-4 py-3">
    <h4 class="mb-3">배식 라운딩</h4>

    <!-- Search Area -->
    <div class="card shadow-sm mb-3">
        <div class="card-body py-2">
            <form class="form-inline" id="searchForm">
                <div class="form-group mr-3">
                    <label for="searchRoundDt" class="mr-2">라운딩일</label>
                    <input type="date" class="form-control form-control-sm" id="searchRoundDt"
                           name="roundDt" style="width:160px;">
                </div>
                <button type="button" class="btn btn-sm btn-primary" id="btnSearch">조회</button>
            </form>
        </div>
    </div>

    <!-- Data Table -->
    <div class="card shadow-sm">
        <div class="card-header bg-white d-flex justify-content-between align-items-center">
            <span class="font-weight-bold">배식 라운딩 목록</span>
            <button type="button" class="btn btn-sm btn-primary" id="btnAdd">등록</button>
        </div>
        <div class="card-body p-0">
            <table class="table table-bordered table-hover table-sm mb-0" id="dataTable">
                <thead class="thead-light">
                    <tr>
                        <th style="width:50px;">No</th>
                        <th>라운딩일</th>
                        <th>환자명</th>
                        <th>식이종류</th>
                        <th>라운딩내용</th>
                        <th>조치사항</th>
                        <th>수행자</th>
                        <th style="width:110px;">관리</th>
                    </tr>
                </thead>
                <tbody id="dataBody">
                    <tr>
                        <td colspan="8" class="text-center py-3">조회 버튼을 클릭하세요.</td>
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
                <h5 class="modal-title" id="modalTitle">배식 라운딩 등록</h5>
                <button type="button" class="close" data-dismiss="modal"><span>&times;</span></button>
            </div>
            <div class="modal-body">
                <form id="dataForm">
                    <input type="hidden" id="modalMode" value="add">
                    <input type="hidden" id="modalHospCd" name="hospCd" value="12345678">
                    <input type="hidden" id="modalSeq" name="seq">
                    <div class="row">
                        <div class="col-md-4">
                            <div class="form-group">
                                <label>라운딩일</label>
                                <input type="date" class="form-control" id="modalRoundDt" name="roundDt" required>
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
                                <label>환자코드</label>
                                <input type="text" class="form-control" id="modalPatCd" name="patCd">
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label>식이종류</label>
                                <input type="text" class="form-control" id="modalDietType" name="dietType">
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <label>수행자</label>
                                <input type="text" class="form-control" id="modalRounder" name="rounder">
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <label>라운딩내용</label>
                        <textarea class="form-control" id="modalRoundContent" name="roundContent" rows="3"></textarea>
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
        hospCd: '12345678',
        roundDt: $('#searchRoundDt').val()
    };
    $.ajax({
        url: '/manage/getMealRoundList.do',
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
        tbody.append('<tr><td colspan="8" class="text-center py-3">조회된 데이터가 없습니다.</td></tr>');
        return;
    }
    $.each(list, function(idx, item) {
        var tr = '<tr>' +
            '<td class="text-center">' + (idx + 1) + '</td>' +
            '<td class="text-center">' + (item.roundDt || '') + '</td>' +
            '<td>' + (item.patNm || '') + '</td>' +
            '<td>' + (item.dietType || '') + '</td>' +
            '<td>' + (item.roundContent || '') + '</td>' +
            '<td>' + (item.actionDesc || '') + '</td>' +
            '<td class="text-center">' + (item.rounder || '') + '</td>' +
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
        $('#modalTitle').text('배식 라운딩 등록');
        $('#dataForm')[0].reset();
        $('#modalHospCd').val('12345678');
        $('#modalSeq').val('');
    } else {
        $('#modalTitle').text('배식 라운딩 수정');
        $('#modalSeq').val(item.seq);
        $('#modalRoundDt').val(item.roundDt);
        $('#modalPatNm').val(item.patNm);
        $('#modalPatCd').val(item.patCd);
        $('#modalDietType').val(item.dietType);
        $('#modalRounder').val(item.rounder);
        $('#modalRoundContent').val(item.roundContent);
        $('#modalActionDesc').val(item.actionDesc);
        $('#modalNote').val(item.note);
    }
    $('#formModal').modal('show');
}

function saveData() {
    var param = {
        hospCd: $('#modalHospCd').val(),
        seq: $('#modalSeq').val(),
        roundDt: $('#modalRoundDt').val(),
        patNm: $('#modalPatNm').val().trim(),
        patCd: $('#modalPatCd').val().trim(),
        dietType: $('#modalDietType').val().trim(),
        rounder: $('#modalRounder').val().trim(),
        roundContent: $('#modalRoundContent').val().trim(),
        actionDesc: $('#modalActionDesc').val().trim(),
        note: $('#modalNote').val().trim(),
        mode: $('#modalMode').val()
    };
    if (!param.roundDt || !param.patNm) {
        alert('필수 항목을 입력하세요.');
        return;
    }
    $.ajax({
        url: '/manage/saveMealRound.do',
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
        url: '/manage/deleteMealRound.do',
        type: 'POST',
        data: { hospCd: '12345678', seq: seq },
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
