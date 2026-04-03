<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<div class="container-fluid px-4 py-3">
    <h4 class="mb-3">예방접종 관리</h4>

    <!-- Search Area -->
    <div class="card shadow-sm mb-3">
        <div class="card-body py-2">
            <form class="form-inline" id="searchForm">
                <div class="form-group mr-3">
                    <label for="searchVaccinYear" class="mr-2">접종연도</label>
                    <input type="text" class="form-control form-control-sm" id="searchVaccinYear"
                           name="vaccinYear" placeholder="예: 2026" maxlength="4" style="width:100px;">
                </div>
                <div class="form-group mr-3">
                    <label for="searchVaccinType" class="mr-2">접종구분</label>
                    <select class="form-control form-control-sm" id="searchVaccinType" name="vaccinType" style="width:120px;">
                        <option value="">전체</option>
                        <option value="독감">독감</option>
                        <option value="B형간염">B형간염</option>
                        <option value="코로나">코로나</option>
                    </select>
                </div>
                <button type="button" class="btn btn-sm btn-primary" id="btnSearch">조회</button>
            </form>
        </div>
    </div>

    <!-- Data Table -->
    <div class="card shadow-sm">
        <div class="card-header bg-white d-flex justify-content-between align-items-center">
            <span class="font-weight-bold">예방접종 목록</span>
            <button type="button" class="btn btn-sm btn-primary" id="btnAdd">등록</button>
        </div>
        <div class="card-body p-0">
            <table class="table table-bordered table-hover table-sm mb-0" id="dataTable">
                <thead class="thead-light">
                    <tr>
                        <th style="width:50px;">No</th>
                        <th>직원명</th>
                        <th>부서</th>
                        <th>직종</th>
                        <th>접종구분</th>
                        <th>접종일자</th>
                        <th>약품명</th>
                        <th>비고</th>
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
                <h5 class="modal-title" id="modalTitle">예방접종 등록</h5>
                <button type="button" class="close" data-dismiss="modal"><span>&times;</span></button>
            </div>
            <div class="modal-body">
                <form id="dataForm">
                    <input type="hidden" id="modalMode" value="add">
                    <input type="hidden" id="modalHospCd" name="hospCd" value="12345678">
                    <input type="hidden" id="modalSeq" name="seq">
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label>직원명</label>
                                <input type="text" class="form-control" id="modalEmpNm" name="empNm" required>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <label>부서</label>
                                <input type="text" class="form-control" id="modalDeptNm" name="deptNm">
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-4">
                            <div class="form-group">
                                <label>직종</label>
                                <input type="text" class="form-control" id="modalJobType" name="jobType">
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group">
                                <label>접종연도</label>
                                <input type="text" class="form-control" id="modalVaccinYear" name="vaccinYear" maxlength="4">
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group">
                                <label>접종구분</label>
                                <select class="form-control" id="modalVaccinType" name="vaccinType">
                                    <option value="독감">독감</option>
                                    <option value="B형간염">B형간염</option>
                                    <option value="코로나">코로나</option>
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-4">
                            <div class="form-group">
                                <label>접종일자</label>
                                <input type="date" class="form-control" id="modalVaccinDt" name="vaccinDt" required>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group">
                                <label>접종장소</label>
                                <select class="form-control" id="modalVaccinPlace" name="vaccinPlace">
                                    <option value="원내">원내</option>
                                    <option value="원외">원외</option>
                                </select>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group">
                                <label>약품명</label>
                                <input type="text" class="form-control" id="modalDrugNm" name="drugNm">
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label>Lot No</label>
                                <input type="text" class="form-control" id="modalLotNo" name="lotNo">
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <label>비고</label>
                                <input type="text" class="form-control" id="modalNote" name="note">
                            </div>
                        </div>
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
        vaccinYear: $('#searchVaccinYear').val().trim(),
        vaccinType: $('#searchVaccinType').val()
    };
    $.ajax({
        url: '/manage/getVaccinList.do',
        type: 'POST',
        data: param,
        dataType: 'json',
        success: function(res) {
            if (res.result === 'success') {
                renderList(res.data);
            }
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
            '<td>' + (item.empNm || '') + '</td>' +
            '<td>' + (item.deptNm || '') + '</td>' +
            '<td>' + (item.jobType || '') + '</td>' +
            '<td class="text-center">' + (item.vaccinType || '') + '</td>' +
            '<td class="text-center">' + (item.vaccinDt || '') + '</td>' +
            '<td>' + (item.drugNm || '') + '</td>' +
            '<td>' + (item.note || '') + '</td>' +
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
        $('#modalTitle').text('예방접종 등록');
        $('#dataForm')[0].reset();
        $('#modalHospCd').val('12345678');
        $('#modalSeq').val('');
    } else {
        $('#modalTitle').text('예방접종 수정');
        $('#modalSeq').val(item.seq);
        $('#modalEmpNm').val(item.empNm);
        $('#modalDeptNm').val(item.deptNm);
        $('#modalJobType').val(item.jobType);
        $('#modalVaccinYear').val(item.vaccinYear);
        $('#modalVaccinType').val(item.vaccinType);
        $('#modalVaccinDt').val(item.vaccinDt);
        $('#modalVaccinPlace').val(item.vaccinPlace);
        $('#modalDrugNm').val(item.drugNm);
        $('#modalLotNo').val(item.lotNo);
        $('#modalNote').val(item.note);
    }
    $('#formModal').modal('show');
}

function saveData() {
    var param = {
        hospCd: $('#modalHospCd').val(),
        seq: $('#modalSeq').val(),
        empNm: $('#modalEmpNm').val().trim(),
        deptNm: $('#modalDeptNm').val().trim(),
        jobType: $('#modalJobType').val().trim(),
        vaccinYear: $('#modalVaccinYear').val().trim(),
        vaccinType: $('#modalVaccinType').val(),
        vaccinDt: $('#modalVaccinDt').val(),
        vaccinPlace: $('#modalVaccinPlace').val(),
        drugNm: $('#modalDrugNm').val().trim(),
        lotNo: $('#modalLotNo').val().trim(),
        note: $('#modalNote').val().trim(),
        mode: $('#modalMode').val()
    };
    if (!param.empNm || !param.vaccinDt) {
        alert('필수 항목을 입력하세요.');
        return;
    }
    $.ajax({
        url: '/manage/saveVaccin.do',
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
        url: '/manage/deleteVaccin.do',
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
