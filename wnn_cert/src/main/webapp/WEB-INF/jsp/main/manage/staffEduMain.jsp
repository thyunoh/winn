<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<div class="container-fluid px-4 py-3">
    <h4 class="mb-3">직원 교육관리</h4>

    <!-- Search Area -->
    <div class="card shadow-sm mb-3">
        <div class="card-body py-2">
            <form class="form-inline" id="searchForm">
                <div class="form-group mr-3">
                    <label for="searchEduYear" class="mr-2">교육연도</label>
                    <input type="text" class="form-control form-control-sm" id="searchEduYear"
                           name="eduYear" placeholder="예: 2026" maxlength="4" style="width:100px;">
                </div>
                <div class="form-group mr-3">
                    <label for="searchEduType" class="mr-2">교육구분</label>
                    <select class="form-control form-control-sm" id="searchEduType" name="eduType" style="width:140px;">
                        <option value="">전체</option>
                        <option value="필수교육">필수교육</option>
                        <option value="법정의무교육">법정의무교육</option>
                        <option value="특성화교육">특성화교육</option>
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
            <span class="font-weight-bold">교육 목록</span>
            <button type="button" class="btn btn-sm btn-primary" id="btnAdd">등록</button>
        </div>
        <div class="card-body p-0">
            <table class="table table-bordered table-hover table-sm mb-0" id="dataTable">
                <thead class="thead-light">
                    <tr>
                        <th style="width:50px;">No</th>
                        <th>교육구분</th>
                        <th>교육명</th>
                        <th>교육일자</th>
                        <th>강사</th>
                        <th>교육방법</th>
                        <th style="width:80px;">대상인원</th>
                        <th style="width:80px;">참석인원</th>
                        <th style="width:80px;">참석률</th>
                        <th style="width:110px;">관리</th>
                    </tr>
                </thead>
                <tbody id="dataBody">
                    <tr>
                        <td colspan="10" class="text-center py-3">조회 버튼을 클릭하세요.</td>
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
                <h5 class="modal-title" id="modalTitle">교육 등록</h5>
                <button type="button" class="close" data-dismiss="modal"><span>&times;</span></button>
            </div>
            <div class="modal-body">
                <form id="dataForm">
                    <input type="hidden" id="modalMode" value="add">
                    <input type="hidden" id="modalCompCd" name="hospCd" value="0001">
                    <input type="hidden" id="modalSeq" name="seq">
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label>교육구분</label>
                                <select class="form-control" id="modalEduType" name="eduType">
                                    <option value="필수교육">필수교육</option>
                                    <option value="법정의무교육">법정의무교육</option>
                                    <option value="특성화교육">특성화교육</option>
                                    <option value="기타">기타</option>
                                </select>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <label>교육명</label>
                                <input type="text" class="form-control" id="modalEduTitle" name="eduTitle" required>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-4">
                            <div class="form-group">
                                <label>교육일자</label>
                                <input type="date" class="form-control" id="modalEduDt" name="eduDt" required>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group">
                                <label>교육시간</label>
                                <input type="text" class="form-control" id="modalEduTime" name="eduTime" placeholder="예: 2시간">
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group">
                                <label>강사</label>
                                <input type="text" class="form-control" id="modalInstructor" name="instructor">
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-4">
                            <div class="form-group">
                                <label>교육방법</label>
                                <select class="form-control" id="modalEduMethod" name="eduMethod">
                                    <option value="집합">집합</option>
                                    <option value="온라인">온라인</option>
                                    <option value="실습">실습</option>
                                </select>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group">
                                <label>대상부서</label>
                                <input type="text" class="form-control" id="modalTargetDept" name="targetDept">
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group">
                                <label>대상인원</label>
                                <input type="number" class="form-control" id="modalTargetCnt" name="targetCnt">
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-4">
                            <div class="form-group">
                                <label>참석인원</label>
                                <input type="number" class="form-control" id="modalAttendCnt" name="attendCnt">
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <label>교육내용</label>
                        <textarea class="form-control" id="modalEduContent" name="eduContent" rows="3"></textarea>
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
        hospCd: '0001',
        eduYear: $('#searchEduYear').val().trim(),
        eduType: $('#searchEduType').val()
    };
    $.ajax({
        url: '/manage/getStaffEduList.do',
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
        tbody.append('<tr><td colspan="10" class="text-center py-3">조회된 데이터가 없습니다.</td></tr>');
        return;
    }
    $.each(list, function(idx, item) {
        var rate = (item.targetCnt && item.targetCnt > 0) ? ((item.attendCnt / item.targetCnt) * 100).toFixed(1) + '%' : '-';
        var tr = '<tr>' +
            '<td class="text-center">' + (idx + 1) + '</td>' +
            '<td class="text-center">' + (item.eduType || '') + '</td>' +
            '<td>' + (item.eduTitle || '') + '</td>' +
            '<td class="text-center">' + (item.eduDt || '') + '</td>' +
            '<td class="text-center">' + (item.instructor || '') + '</td>' +
            '<td class="text-center">' + (item.eduMethod || '') + '</td>' +
            '<td class="text-center">' + (item.targetCnt != null ? item.targetCnt : '') + '</td>' +
            '<td class="text-center">' + (item.attendCnt != null ? item.attendCnt : '') + '</td>' +
            '<td class="text-center">' + rate + '</td>' +
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
        $('#modalTitle').text('교육 등록');
        $('#dataForm')[0].reset();
        $('#modalCompCd').val('0001');
        $('#modalSeq').val('');
    } else {
        $('#modalTitle').text('교육 수정');
        $('#modalSeq').val(item.seq);
        $('#modalEduType').val(item.eduType);
        $('#modalEduTitle').val(item.eduTitle);
        $('#modalEduDt').val(item.eduDt);
        $('#modalEduTime').val(item.eduTime);
        $('#modalInstructor').val(item.instructor);
        $('#modalEduMethod').val(item.eduMethod);
        $('#modalTargetDept').val(item.targetDept);
        $('#modalTargetCnt').val(item.targetCnt);
        $('#modalAttendCnt').val(item.attendCnt);
        $('#modalEduContent').val(item.eduContent);
        $('#modalNote').val(item.note);
    }
    $('#formModal').modal('show');
}

function saveData() {
    var param = {
        hospCd: $('#modalCompCd').val(),
        seq: $('#modalSeq').val(),
        eduType: $('#modalEduType').val(),
        eduTitle: $('#modalEduTitle').val().trim(),
        eduDt: $('#modalEduDt').val(),
        eduTime: $('#modalEduTime').val().trim(),
        instructor: $('#modalInstructor').val().trim(),
        eduMethod: $('#modalEduMethod').val(),
        targetDept: $('#modalTargetDept').val().trim(),
        targetCnt: $('#modalTargetCnt').val(),
        attendCnt: $('#modalAttendCnt').val(),
        eduContent: $('#modalEduContent').val().trim(),
        note: $('#modalNote').val().trim(),
        mode: $('#modalMode').val()
    };
    if (!param.eduTitle || !param.eduDt) {
        alert('필수 항목을 입력하세요.');
        return;
    }
    $.ajax({
        url: '/manage/saveStaffEdu.do',
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
        url: '/manage/deleteStaffEdu.do',
        type: 'POST',
        data: { hospCd: '0001', seq: seq },
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
