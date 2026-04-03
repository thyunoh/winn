<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<div class="container-fluid px-4 py-3">
    <h4 class="mb-3">직원 건강검진</h4>

    <!-- Search Area -->
    <div class="card shadow-sm mb-3">
        <div class="card-body py-2">
            <form class="form-inline" id="searchForm">
                <div class="form-group mr-3">
                    <label for="searchChkYear" class="mr-2">검진연도</label>
                    <input type="text" class="form-control form-control-sm" id="searchChkYear"
                           name="chkYear" placeholder="예: 2026" maxlength="4" style="width:100px;">
                </div>
                <div class="form-group mr-3">
                    <label for="searchEmpNm" class="mr-2">직원명</label>
                    <input type="text" class="form-control form-control-sm" id="searchEmpNm"
                           name="empNm" style="width:120px;">
                </div>
                <button type="button" class="btn btn-sm btn-primary" id="btnSearch">조회</button>
            </form>
        </div>
    </div>

    <!-- Data Table -->
    <div class="card shadow-sm">
        <div class="card-header bg-white d-flex justify-content-between align-items-center">
            <span class="font-weight-bold">건강검진 목록</span>
            <button type="button" class="btn btn-sm btn-primary" id="btnAdd">등록</button>
        </div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-bordered table-hover table-sm mb-0" id="dataTable">
                    <thead class="thead-light">
                        <tr>
                            <th style="width:50px;">No</th>
                            <th>직원명</th>
                            <th>부서</th>
                            <th>직종</th>
                            <th>일반검진일</th>
                            <th>일반검진결과</th>
                            <th>결핵검진일</th>
                            <th>B형간염</th>
                            <th>독감접종</th>
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
                <h5 class="modal-title" id="modalTitle">건강검진 등록</h5>
                <button type="button" class="close" data-dismiss="modal"><span>&times;</span></button>
            </div>
            <div class="modal-body">
                <form id="dataForm">
                    <input type="hidden" id="modalMode" value="add">
                    <input type="hidden" id="modalCompCd" name="hospCd" value="0001">
                    <input type="hidden" id="modalSeq" name="seq">
                    <h6>기본정보</h6>
                    <div class="row">
                        <div class="col-md-3">
                            <div class="form-group">
                                <label>직원명</label>
                                <input type="text" class="form-control" id="modalEmpNm" name="empNm" required>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label>부서</label>
                                <input type="text" class="form-control" id="modalDeptNm" name="deptNm">
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label>직종</label>
                                <input type="text" class="form-control" id="modalJobType" name="jobType">
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label>입사일</label>
                                <input type="date" class="form-control" id="modalHireDt" name="hireDt">
                            </div>
                        </div>
                    </div>
                    <hr>
                    <h6>일반검진</h6>
                    <div class="row">
                        <div class="col-md-4">
                            <div class="form-group">
                                <label>일반검진일</label>
                                <input type="date" class="form-control" id="modalGeneralDt" name="generalDt">
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group">
                                <label>검진결과</label>
                                <input type="text" class="form-control" id="modalGeneralResult" name="generalResult">
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group">
                                <label>사후관리</label>
                                <input type="text" class="form-control" id="modalGeneralFollowup" name="generalFollowup">
                            </div>
                        </div>
                    </div>
                    <hr>
                    <h6>결핵검진</h6>
                    <div class="row">
                        <div class="col-md-3">
                            <div class="form-group">
                                <label>흉부X선일</label>
                                <input type="date" class="form-control" id="modalTbXrayDt" name="tbXrayDt">
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label>흉부X선결과</label>
                                <input type="text" class="form-control" id="modalTbXrayResult" name="tbXrayResult">
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label>잠복결핵일</label>
                                <input type="date" class="form-control" id="modalTbLatentDt" name="tbLatentDt">
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label>잠복결핵결과</label>
                                <input type="text" class="form-control" id="modalTbLatentResult" name="tbLatentResult">
                            </div>
                        </div>
                    </div>
                    <hr>
                    <h6>B형간염 / 독감접종</h6>
                    <div class="row">
                        <div class="col-md-3">
                            <div class="form-group">
                                <label>B형간염 검사일</label>
                                <input type="date" class="form-control" id="modalHbvDt" name="hbvDt">
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label>항원</label>
                                <input type="text" class="form-control" id="modalHbvAntigen" name="hbvAntigen">
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label>항체</label>
                                <input type="text" class="form-control" id="modalHbvAntibody" name="hbvAntibody">
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <div class="form-group">
                                <label>독감접종일</label>
                                <input type="date" class="form-control" id="modalFluDt" name="fluDt">
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label>독감유형</label>
                                <input type="text" class="form-control" id="modalFluType" name="fluType">
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
        hospCd: '0001',
        chkYear: $('#searchChkYear').val().trim(),
        empNm: $('#searchEmpNm').val().trim()
    };
    $.ajax({
        url: '/manage/getHealthChkList.do',
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
            '<td>' + (item.empNm || '') + '</td>' +
            '<td>' + (item.deptNm || '') + '</td>' +
            '<td>' + (item.jobType || '') + '</td>' +
            '<td class="text-center">' + (item.generalDt || '') + '</td>' +
            '<td class="text-center">' + (item.generalResult || '') + '</td>' +
            '<td class="text-center">' + (item.tbXrayDt || '') + '</td>' +
            '<td class="text-center">' + (item.hbvAntibody || '') + '</td>' +
            '<td class="text-center">' + (item.fluDt || '') + '</td>' +
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
        $('#modalTitle').text('건강검진 등록');
        $('#dataForm')[0].reset();
        $('#modalCompCd').val('0001');
        $('#modalSeq').val('');
    } else {
        $('#modalTitle').text('건강검진 수정');
        $('#modalSeq').val(item.seq);
        $('#modalEmpNm').val(item.empNm);
        $('#modalDeptNm').val(item.deptNm);
        $('#modalJobType').val(item.jobType);
        $('#modalHireDt').val(item.hireDt);
        $('#modalGeneralDt').val(item.generalDt);
        $('#modalGeneralResult').val(item.generalResult);
        $('#modalGeneralFollowup').val(item.generalFollowup);
        $('#modalTbXrayDt').val(item.tbXrayDt);
        $('#modalTbXrayResult').val(item.tbXrayResult);
        $('#modalTbLatentDt').val(item.tbLatentDt);
        $('#modalTbLatentResult').val(item.tbLatentResult);
        $('#modalHbvDt').val(item.hbvDt);
        $('#modalHbvAntigen').val(item.hbvAntigen);
        $('#modalHbvAntibody').val(item.hbvAntibody);
        $('#modalFluDt').val(item.fluDt);
        $('#modalFluType').val(item.fluType);
        $('#modalNote').val(item.note);
    }
    $('#formModal').modal('show');
}

function saveData() {
    var param = {
        hospCd: $('#modalCompCd').val(),
        seq: $('#modalSeq').val(),
        empNm: $('#modalEmpNm').val().trim(),
        deptNm: $('#modalDeptNm').val().trim(),
        jobType: $('#modalJobType').val().trim(),
        hireDt: $('#modalHireDt').val(),
        generalDt: $('#modalGeneralDt').val(),
        generalResult: $('#modalGeneralResult').val().trim(),
        generalFollowup: $('#modalGeneralFollowup').val().trim(),
        tbXrayDt: $('#modalTbXrayDt').val(),
        tbXrayResult: $('#modalTbXrayResult').val().trim(),
        tbLatentDt: $('#modalTbLatentDt').val(),
        tbLatentResult: $('#modalTbLatentResult').val().trim(),
        hbvDt: $('#modalHbvDt').val(),
        hbvAntigen: $('#modalHbvAntigen').val().trim(),
        hbvAntibody: $('#modalHbvAntibody').val().trim(),
        fluDt: $('#modalFluDt').val(),
        fluType: $('#modalFluType').val().trim(),
        note: $('#modalNote').val().trim(),
        mode: $('#modalMode').val()
    };
    if (!param.empNm) {
        alert('직원명을 입력하세요.');
        return;
    }
    $.ajax({
        url: '/manage/saveHealthChk.do',
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
        url: '/manage/deleteHealthChk.do',
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
