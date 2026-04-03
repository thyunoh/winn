<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<div class="container-fluid px-4 py-3">
    <h4 class="mb-3">의료기기 관리</h4>

    <!-- Search Area -->
    <div class="card shadow-sm mb-3">
        <div class="card-body py-2">
            <form class="form-inline" id="searchForm">
                <div class="form-group mr-3">
                    <label for="searchCategory" class="mr-2">카테고리</label>
                    <input type="text" class="form-control form-control-sm" id="searchCategory"
                           name="category" style="width:120px;">
                </div>
                <div class="form-group mr-3">
                    <label for="searchDeviceStatus" class="mr-2">상태</label>
                    <select class="form-control form-control-sm" id="searchDeviceStatus" name="deviceStatus" style="width:100px;">
                        <option value="">전체</option>
                        <option value="정상">정상</option>
                        <option value="수리중">수리중</option>
                        <option value="폐기">폐기</option>
                    </select>
                </div>
                <button type="button" class="btn btn-sm btn-primary" id="btnSearch">조회</button>
            </form>
        </div>
    </div>

    <!-- Data Table -->
    <div class="card shadow-sm">
        <div class="card-header bg-white d-flex justify-content-between align-items-center">
            <span class="font-weight-bold">의료기기 목록</span>
            <button type="button" class="btn btn-sm btn-primary" id="btnAdd">등록</button>
        </div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-bordered table-hover table-sm mb-0" id="dataTable">
                    <thead class="thead-light">
                        <tr>
                            <th style="width:50px;">No</th>
                            <th>장비번호</th>
                            <th>제품명</th>
                            <th>모델명</th>
                            <th>제조회사</th>
                            <th>설치장소</th>
                            <th>최근점검일</th>
                            <th>차기점검일</th>
                            <th style="width:80px;">상태</th>
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
</div>

<!-- Add/Edit Modal -->
<div class="modal fade" id="formModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="modalTitle">의료기기 등록</h5>
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
                                <label>장비번호</label>
                                <input type="text" class="form-control" id="modalDeviceNo" name="deviceNo" required>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group">
                                <label>제품명</label>
                                <input type="text" class="form-control" id="modalDeviceNm" name="deviceNm" required>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group">
                                <label>모델명</label>
                                <input type="text" class="form-control" id="modalModelNm" name="modelNm">
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-4">
                            <div class="form-group">
                                <label>카테고리</label>
                                <input type="text" class="form-control" id="modalCategory" name="category">
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group">
                                <label>시리얼번호</label>
                                <input type="text" class="form-control" id="modalSerialNo" name="serialNo">
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group">
                                <label>제조회사</label>
                                <input type="text" class="form-control" id="modalMaker" name="maker">
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-4">
                            <div class="form-group">
                                <label>제조일</label>
                                <input type="date" class="form-control" id="modalMakeDt" name="makeDt">
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group">
                                <label>설치장소</label>
                                <input type="text" class="form-control" id="modalInstallPlace" name="installPlace">
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group">
                                <label>공급업체</label>
                                <input type="text" class="form-control" id="modalSupplier" name="supplier">
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-4">
                            <div class="form-group">
                                <label>구매일</label>
                                <input type="date" class="form-control" id="modalPurchaseDt" name="purchaseDt">
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group">
                                <label>점검주기</label>
                                <input type="text" class="form-control" id="modalInspectCycle" name="inspectCycle" placeholder="예: 6개월">
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group">
                                <label>상태</label>
                                <select class="form-control" id="modalDeviceStatus" name="deviceStatus">
                                    <option value="정상">정상</option>
                                    <option value="수리중">수리중</option>
                                    <option value="폐기">폐기</option>
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-4">
                            <div class="form-group">
                                <label>최근점검일</label>
                                <input type="date" class="form-control" id="modalLastInspectDt" name="lastInspectDt">
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group">
                                <label>차기점검일</label>
                                <input type="date" class="form-control" id="modalNextInspectDt" name="nextInspectDt">
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

function getStatusBadge(status) {
    var cls = 'badge badge-secondary';
    if (status === '정상') cls = 'badge badge-success';
    else if (status === '수리중') cls = 'badge badge-warning';
    else if (status === '폐기') cls = 'badge badge-danger';
    return '<span class="' + cls + '">' + (status || '') + '</span>';
}

function loadList() {
    var param = {
        hospCd: '12345678',
        category: $('#searchCategory').val().trim(),
        deviceStatus: $('#searchDeviceStatus').val()
    };
    $.ajax({
        url: '/manage/getMedDeviceList.do',
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
        var tr = '<tr>' +
            '<td class="text-center">' + (idx + 1) + '</td>' +
            '<td>' + (item.deviceNo || '') + '</td>' +
            '<td>' + (item.deviceNm || '') + '</td>' +
            '<td>' + (item.modelNm || '') + '</td>' +
            '<td>' + (item.maker || '') + '</td>' +
            '<td>' + (item.installPlace || '') + '</td>' +
            '<td class="text-center">' + (item.lastInspectDt || '') + '</td>' +
            '<td class="text-center">' + (item.nextInspectDt || '') + '</td>' +
            '<td class="text-center">' + getStatusBadge(item.deviceStatus) + '</td>' +
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
        $('#modalTitle').text('의료기기 등록');
        $('#dataForm')[0].reset();
        $('#modalHospCd').val('12345678');
        $('#modalSeq').val('');
    } else {
        $('#modalTitle').text('의료기기 수정');
        $('#modalSeq').val(item.seq);
        $('#modalDeviceNo').val(item.deviceNo);
        $('#modalDeviceNm').val(item.deviceNm);
        $('#modalModelNm').val(item.modelNm);
        $('#modalCategory').val(item.category);
        $('#modalSerialNo').val(item.serialNo);
        $('#modalMaker').val(item.maker);
        $('#modalMakeDt').val(item.makeDt);
        $('#modalInstallPlace').val(item.installPlace);
        $('#modalSupplier').val(item.supplier);
        $('#modalPurchaseDt').val(item.purchaseDt);
        $('#modalInspectCycle').val(item.inspectCycle);
        $('#modalLastInspectDt').val(item.lastInspectDt);
        $('#modalNextInspectDt').val(item.nextInspectDt);
        $('#modalDeviceStatus').val(item.deviceStatus);
        $('#modalNote').val(item.note);
    }
    $('#formModal').modal('show');
}

function saveData() {
    var param = {
        hospCd: $('#modalHospCd').val(),
        seq: $('#modalSeq').val(),
        deviceNo: $('#modalDeviceNo').val().trim(),
        deviceNm: $('#modalDeviceNm').val().trim(),
        modelNm: $('#modalModelNm').val().trim(),
        category: $('#modalCategory').val().trim(),
        serialNo: $('#modalSerialNo').val().trim(),
        maker: $('#modalMaker').val().trim(),
        makeDt: $('#modalMakeDt').val(),
        installPlace: $('#modalInstallPlace').val().trim(),
        supplier: $('#modalSupplier').val().trim(),
        purchaseDt: $('#modalPurchaseDt').val(),
        inspectCycle: $('#modalInspectCycle').val().trim(),
        lastInspectDt: $('#modalLastInspectDt').val(),
        nextInspectDt: $('#modalNextInspectDt').val(),
        deviceStatus: $('#modalDeviceStatus').val(),
        note: $('#modalNote').val().trim(),
        mode: $('#modalMode').val()
    };
    if (!param.deviceNo || !param.deviceNm) {
        alert('필수 항목을 입력하세요.');
        return;
    }
    $.ajax({
        url: '/manage/saveMedDevice.do',
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
        url: '/manage/deleteMedDevice.do',
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
