<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<div class="container-fluid px-4 py-3">
    <h4 class="mb-3">약품 관리</h4>

    <!-- Search Area -->
    <div class="card shadow-sm mb-3">
        <div class="card-body py-2">
            <form class="form-inline" id="searchForm">
                <div class="form-group mr-3">
                    <label for="searchDrugType" class="mr-2">유형</label>
                    <select class="form-control form-control-sm" id="searchDrugType" name="drugType" style="width:120px;">
                        <option value="">전체</option>
                        <option value="일반">일반</option>
                        <option value="마약류">마약류</option>
                        <option value="향정">향정</option>
                        <option value="고위험">고위험</option>
                    </select>
                </div>
                <div class="form-group mr-3">
                    <label for="searchDrugNm" class="mr-2">약품명</label>
                    <input type="text" class="form-control form-control-sm" id="searchDrugNm"
                           name="drugNm" style="width:150px;">
                </div>
                <button type="button" class="btn btn-sm btn-primary" id="btnSearch">조회</button>
            </form>
        </div>
    </div>

    <!-- Data Table -->
    <div class="card shadow-sm">
        <div class="card-header bg-white d-flex justify-content-between align-items-center">
            <span class="font-weight-bold">약품 목록</span>
            <button type="button" class="btn btn-sm btn-primary" id="btnAdd">등록</button>
        </div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-bordered table-hover table-sm mb-0" id="dataTable">
                    <thead class="thead-light">
                        <tr>
                            <th style="width:50px;">No</th>
                            <th>약품코드</th>
                            <th>약품명</th>
                            <th style="width:80px;">유형</th>
                            <th>보관장소</th>
                            <th>보관조건</th>
                            <th style="width:70px;">재고</th>
                            <th style="width:70px;">최소재고</th>
                            <th>유효기한</th>
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
                <h5 class="modal-title" id="modalTitle">약품 등록</h5>
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
                                <label>약품코드</label>
                                <input type="text" class="form-control" id="modalDrugCd" name="drugCd" required>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group">
                                <label>약품명</label>
                                <input type="text" class="form-control" id="modalDrugNm" name="drugNm" required>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group">
                                <label>유형</label>
                                <select class="form-control" id="modalDrugType" name="drugType">
                                    <option value="일반">일반</option>
                                    <option value="마약류">마약류</option>
                                    <option value="향정">향정</option>
                                    <option value="고위험">고위험</option>
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-4">
                            <div class="form-group">
                                <label>단위</label>
                                <input type="text" class="form-control" id="modalUnit" name="unit">
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group">
                                <label>보관장소</label>
                                <input type="text" class="form-control" id="modalStorage" name="storage">
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group">
                                <label>보관조건</label>
                                <select class="form-control" id="modalStorageCond" name="storageCond">
                                    <option value="실온">실온</option>
                                    <option value="냉장">냉장</option>
                                    <option value="차광">차광</option>
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <div class="form-group">
                                <label>재고</label>
                                <input type="number" class="form-control" id="modalStockQty" name="stockQty">
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label>최소재고</label>
                                <input type="number" class="form-control" id="modalMinQty" name="minQty">
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label>유효기한</label>
                                <input type="date" class="form-control" id="modalExpireDt" name="expireDt">
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label>공급업체</label>
                                <input type="text" class="form-control" id="modalSupplier" name="supplier">
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
        hospCd: '12345678',
        drugType: $('#searchDrugType').val(),
        drugNm: $('#searchDrugNm').val().trim()
    };
    $.ajax({
        url: '/manage/getDrugManageList.do',
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
        var stockClass = '';
        if (item.stockQty != null && item.minQty != null && item.stockQty <= item.minQty) {
            stockClass = ' class="text-danger font-weight-bold"';
        }
        var tr = '<tr>' +
            '<td class="text-center">' + (idx + 1) + '</td>' +
            '<td>' + (item.drugCd || '') + '</td>' +
            '<td>' + (item.drugNm || '') + '</td>' +
            '<td class="text-center">' + (item.drugType || '') + '</td>' +
            '<td>' + (item.storage || '') + '</td>' +
            '<td class="text-center">' + (item.storageCond || '') + '</td>' +
            '<td class="text-center"' + stockClass + '>' + (item.stockQty != null ? item.stockQty : '') + '</td>' +
            '<td class="text-center">' + (item.minQty != null ? item.minQty : '') + '</td>' +
            '<td class="text-center">' + (item.expireDt || '') + '</td>' +
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
        $('#modalTitle').text('약품 등록');
        $('#dataForm')[0].reset();
        $('#modalHospCd').val('12345678');
        $('#modalSeq').val('');
    } else {
        $('#modalTitle').text('약품 수정');
        $('#modalSeq').val(item.seq);
        $('#modalDrugCd').val(item.drugCd);
        $('#modalDrugNm').val(item.drugNm);
        $('#modalDrugType').val(item.drugType);
        $('#modalUnit').val(item.unit);
        $('#modalStorage').val(item.storage);
        $('#modalStorageCond').val(item.storageCond);
        $('#modalStockQty').val(item.stockQty);
        $('#modalMinQty').val(item.minQty);
        $('#modalExpireDt').val(item.expireDt);
        $('#modalSupplier').val(item.supplier);
        $('#modalNote').val(item.note);
    }
    $('#formModal').modal('show');
}

function saveData() {
    var param = {
        hospCd: $('#modalHospCd').val(),
        seq: $('#modalSeq').val(),
        drugCd: $('#modalDrugCd').val().trim(),
        drugNm: $('#modalDrugNm').val().trim(),
        drugType: $('#modalDrugType').val(),
        unit: $('#modalUnit').val().trim(),
        storage: $('#modalStorage').val().trim(),
        storageCond: $('#modalStorageCond').val(),
        stockQty: $('#modalStockQty').val(),
        minQty: $('#modalMinQty').val(),
        expireDt: $('#modalExpireDt').val(),
        supplier: $('#modalSupplier').val().trim(),
        note: $('#modalNote').val().trim(),
        mode: $('#modalMode').val()
    };
    if (!param.drugCd || !param.drugNm) {
        alert('필수 항목을 입력하세요.');
        return;
    }
    $.ajax({
        url: '/manage/saveDrugManage.do',
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
        url: '/manage/deleteDrugManage.do',
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
