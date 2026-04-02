<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap4.min.css">

<div class="container-fluid px-4 py-3">
    <h4 class="mb-3">QPS 개선활동</h4>

    <!-- Filter -->
    <div class="card shadow-sm mb-3">
        <div class="card-body py-2">
            <form class="form-inline">
                <div class="form-group mr-3">
                    <label for="searchImpStatus" class="mr-2">상태</label>
                    <select class="form-control form-control-sm" id="searchImpStatus" style="width:100px;">
                        <option value="">전체</option>
                        <option value="계획">계획</option>
                        <option value="진행">진행</option>
                        <option value="완료">완료</option>
                    </select>
                </div>
                <button type="button" class="btn btn-sm btn-primary" id="btnSearch">조회</button>
            </form>
        </div>
    </div>

    <!-- Improve Table -->
    <div class="card shadow-sm">
        <div class="card-header bg-white d-flex justify-content-between align-items-center">
            <span class="font-weight-bold">개선활동 목록</span>
            <button type="button" class="btn btn-sm btn-primary" id="btnAddImprove">등록</button>
        </div>
        <div class="card-body p-0">
            <table class="table table-bordered table-hover table-sm mb-0" id="improveTable">
                <thead class="thead-light">
                    <tr>
                        <th style="width:50px;">No</th>
                        <th style="width:90px;">활동ID</th>
                        <th style="width:100px;">상위노드</th>
                        <th style="width:110px;">노드명</th>
                        <th>제목</th>
                        <th style="width:80px;">상태</th>
                        <th style="width:80px;">담당자</th>
                        <th style="width:100px;">마감일</th>
                        <th style="width:100px;">완료일</th>
                        <th style="width:110px;">관리</th>
                    </tr>
                </thead>
                <tbody id="improveBody">
                    <tr>
                        <td colspan="10" class="text-center py-3">조회 버튼을 클릭하세요.</td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
</div>

<!-- Add/Edit Modal -->
<div class="modal fade" id="improveModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="improveModalTitle">개선활동 등록</h5>
                <button type="button" class="close" data-dismiss="modal"><span>&times;</span></button>
            </div>
            <div class="modal-body">
                <form id="improveForm">
                    <input type="hidden" id="modalImproveId" name="improveId">
                    <input type="hidden" id="modalMode" value="add">
                    <div class="form-group">
                        <label for="modalTitle">제목</label>
                        <input type="text" class="form-control" id="modalTitle" name="title" required>
                    </div>
                    <div class="form-group">
                        <label for="modalContent">내용</label>
                        <textarea class="form-control" id="modalContent" name="content" rows="4"></textarea>
                    </div>
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label for="modalImpStatus">상태</label>
                                <select class="form-control" id="modalImpStatus" name="impStatus">
                                    <option value="계획">계획</option>
                                    <option value="진행">진행</option>
                                    <option value="완료">완료</option>
                                </select>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <label for="modalManager">담당자</label>
                                <input type="text" class="form-control" id="modalManager" name="manager">
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label for="modalDueDt">마감일</label>
                                <input type="date" class="form-control" id="modalDueDt" name="dueDt">
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <label for="modalCompDt">완료일</label>
                                <input type="date" class="form-control" id="modalCompDt" name="compDt">
                            </div>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
                <button type="button" class="btn btn-primary" id="btnSaveImprove">저장</button>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap4.min.js"></script>
<script>
$(document).ready(function() {
    $('#btnSearch').on('click', function() {
        loadImproveList();
    });

    $('#btnAddImprove').on('click', function() {
        openImproveModal('add');
    });

    $('#btnSaveImprove').on('click', function() {
        saveImprove();
    });

    // Initial load
    loadImproveList();
});

function loadImproveList() {
    var param = {
        impStatus: $('#searchImpStatus').val()
    };

    $.ajax({
        url: '/improve/getImproveList.do',
        type: 'POST',
        data: param,
        dataType: 'json',
        success: function(res) {
            if (res.result === 'success') {
                renderImproveList(res.data);
            }
        },
        error: function() {
            alert('개선활동 목록을 불러오는 중 오류가 발생하였습니다.');
        }
    });
}

function renderImproveList(list) {
    var tbody = $('#improveBody');
    tbody.empty();

    if (!list || list.length === 0) {
        tbody.append('<tr><td colspan="10" class="text-center py-3">조회된 데이터가 없습니다.</td></tr>');
        return;
    }

    $.each(list, function(idx, item) {
        var statusBadge = getStatusBadge(item.impStatus);
        var tr = '<tr>' +
            '<td class="text-center">' + (idx + 1) + '</td>' +
            '<td class="text-center">' + (item.improveId || '') + '</td>' +
            '<td>' + (item.parentNm || '') + '</td>' +
            '<td>' + (item.nodeNm || '') + '</td>' +
            '<td>' + (item.title || '') + '</td>' +
            '<td class="text-center">' + statusBadge + '</td>' +
            '<td class="text-center">' + (item.manager || '') + '</td>' +
            '<td class="text-center">' + (item.dueDt || '') + '</td>' +
            '<td class="text-center">' + (item.compDt || '') + '</td>' +
            '<td class="text-center">' +
                '<button class="btn btn-sm btn-outline-primary mr-1" onclick=\'openImproveModal("edit", ' + JSON.stringify(item).replace(/'/g, "\\'") + ')\'>수정</button>' +
                '<button class="btn btn-sm btn-outline-danger" onclick="deleteImprove(\'' + item.improveId + '\')">삭제</button>' +
            '</td>' +
            '</tr>';
        tbody.append(tr);
    });
}

function getStatusBadge(status) {
    var cls = 'badge badge-secondary';
    if (status === '계획') cls = 'badge badge-info';
    else if (status === '진행') cls = 'badge badge-primary';
    else if (status === '완료') cls = 'badge badge-success';
    return '<span class="' + cls + '">' + (status || '') + '</span>';
}

function openImproveModal(mode, item) {
    $('#modalMode').val(mode);
    if (mode === 'add') {
        $('#improveModalTitle').text('개선활동 등록');
        $('#improveForm')[0].reset();
        $('#modalImproveId').val('');
    } else {
        $('#improveModalTitle').text('개선활동 수정');
        $('#modalImproveId').val(item.improveId);
        $('#modalTitle').val(item.title);
        $('#modalContent').val(item.content);
        $('#modalImpStatus').val(item.impStatus);
        $('#modalManager').val(item.manager);
        $('#modalDueDt').val(item.dueDt);
        $('#modalCompDt').val(item.compDt);
    }
    $('#improveModal').modal('show');
}

function saveImprove() {
    var param = {
        improveId: $('#modalImproveId').val(),
        title: $('#modalTitle').val().trim(),
        content: $('#modalContent').val().trim(),
        impStatus: $('#modalImpStatus').val(),
        manager: $('#modalManager').val().trim(),
        dueDt: $('#modalDueDt').val(),
        compDt: $('#modalCompDt').val(),
        mode: $('#modalMode').val()
    };

    if (!param.title) {
        alert('제목을 입력하세요.');
        return;
    }

    $.ajax({
        url: '/improve/saveImprove.do',
        type: 'POST',
        data: param,
        dataType: 'json',
        success: function(res) {
            if (res.result === 'success') {
                alert('저장되었습니다.');
                $('#improveModal').modal('hide');
                loadImproveList();
            } else {
                alert(res.msg || '저장에 실패하였습니다.');
            }
        },
        error: function() {
            alert('저장 중 오류가 발생하였습니다.');
        }
    });
}

function deleteImprove(improveId) {
    if (!confirm('삭제하시겠습니까?')) return;

    $.ajax({
        url: '/improve/deleteImprove.do',
        type: 'POST',
        data: { improveId: improveId },
        dataType: 'json',
        success: function(res) {
            if (res.result === 'success') {
                alert('삭제되었습니다.');
                loadImproveList();
            } else {
                alert(res.msg || '삭제에 실패하였습니다.');
            }
        },
        error: function() {
            alert('삭제 중 오류가 발생하였습니다.');
        }
    });
}
</script>
