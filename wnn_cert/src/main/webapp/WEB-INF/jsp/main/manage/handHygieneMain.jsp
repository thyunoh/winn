<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<div class="container-fluid px-4 py-3">
    <h4 class="mb-3">손위생 모니터링</h4>

    <!-- Search Area -->
    <div class="card shadow-sm mb-3">
        <div class="card-body py-2">
            <form class="form-inline" id="searchForm">
                <div class="form-group mr-3">
                    <label for="searchMonitorMonth" class="mr-2">조사월</label>
                    <input type="month" class="form-control form-control-sm" id="searchMonitorMonth"
                           name="monitorMonth" style="width:160px;">
                </div>
                <div class="form-group mr-3">
                    <label for="searchWardNm" class="mr-2">부서</label>
                    <input type="text" class="form-control form-control-sm" id="searchWardNm"
                           name="wardNm" style="width:120px;">
                </div>
                <button type="button" class="btn btn-sm btn-primary" id="btnSearch">조회</button>
            </form>
        </div>
    </div>

    <!-- Data Table -->
    <div class="card shadow-sm">
        <div class="card-header bg-white d-flex justify-content-between align-items-center">
            <span class="font-weight-bold">손위생 모니터링 목록</span>
            <button type="button" class="btn btn-sm btn-primary" id="btnAdd">등록</button>
        </div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-bordered table-hover table-sm mb-0" id="dataTable">
                    <thead class="thead-light">
                        <tr>
                            <th style="width:40px;">No</th>
                            <th>조사월</th>
                            <th>부서</th>
                            <th>직종</th>
                            <th style="width:80px;">관찰건수</th>
                            <th style="width:80px;">수행건수</th>
                            <th style="width:80px;">수행률(%)</th>
                            <th style="width:55px;">M1</th>
                            <th style="width:55px;">M2</th>
                            <th style="width:55px;">M3</th>
                            <th style="width:55px;">M4</th>
                            <th style="width:55px;">M5</th>
                            <th style="width:110px;">관리</th>
                        </tr>
                    </thead>
                    <tbody id="dataBody">
                        <tr>
                            <td colspan="13" class="text-center py-3">조회 버튼을 클릭하세요.</td>
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
                <h5 class="modal-title" id="modalTitle">손위생 모니터링 등록</h5>
                <button type="button" class="close" data-dismiss="modal"><span>&times;</span></button>
            </div>
            <div class="modal-body">
                <form id="dataForm">
                    <input type="hidden" id="modalMode" value="add">
                    <input type="hidden" id="modalCompCd" name="hospCd" value="0001">
                    <input type="hidden" id="modalSeq" name="seq">
                    <div class="row">
                        <div class="col-md-4">
                            <div class="form-group">
                                <label>조사일</label>
                                <input type="date" class="form-control" id="modalMonitorDt" name="monitorDt" required>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group">
                                <label>조사월</label>
                                <input type="month" class="form-control" id="modalMonitorMonth" name="monitorMonth" required>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group">
                                <label>부서</label>
                                <input type="text" class="form-control" id="modalWardNm" name="wardNm" required>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-4">
                            <div class="form-group">
                                <label>직종</label>
                                <select class="form-control" id="modalJobType" name="jobType">
                                    <option value="의사">의사</option>
                                    <option value="간호사">간호사</option>
                                    <option value="간병인">간병인</option>
                                    <option value="기타">기타</option>
                                </select>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group">
                                <label>관찰건수</label>
                                <input type="number" class="form-control" id="modalObserveCnt" name="observeCnt">
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group">
                                <label>수행건수</label>
                                <input type="number" class="form-control" id="modalComplyCnt" name="complyCnt">
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-4">
                            <div class="form-group">
                                <label>수행률(%)</label>
                                <input type="text" class="form-control" id="modalComplyRate" name="complyRate" readonly>
                            </div>
                        </div>
                    </div>
                    <hr>
                    <h6>5 Moments (수행건수)</h6>
                    <div class="row">
                        <div class="col">
                            <div class="form-group">
                                <label>M1 (환자접촉전)</label>
                                <input type="number" class="form-control form-control-sm" id="modalMoment1" name="moment1">
                            </div>
                        </div>
                        <div class="col">
                            <div class="form-group">
                                <label>M2 (무균술전)</label>
                                <input type="number" class="form-control form-control-sm" id="modalMoment2" name="moment2">
                            </div>
                        </div>
                        <div class="col">
                            <div class="form-group">
                                <label>M3 (체액노출후)</label>
                                <input type="number" class="form-control form-control-sm" id="modalMoment3" name="moment3">
                            </div>
                        </div>
                        <div class="col">
                            <div class="form-group">
                                <label>M4 (환자접촉후)</label>
                                <input type="number" class="form-control form-control-sm" id="modalMoment4" name="moment4">
                            </div>
                        </div>
                        <div class="col">
                            <div class="form-group">
                                <label>M5 (환경접촉후)</label>
                                <input type="number" class="form-control form-control-sm" id="modalMoment5" name="moment5">
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label>조사자</label>
                                <input type="text" class="form-control" id="modalMonitorUser" name="monitorUser">
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

    // Auto-calculate complyRate
    $('#modalObserveCnt, #modalComplyCnt').on('input', function() {
        calcComplyRate();
    });

    loadList();
});

function calcComplyRate() {
    var observe = parseInt($('#modalObserveCnt').val()) || 0;
    var comply = parseInt($('#modalComplyCnt').val()) || 0;
    if (observe > 0) {
        $('#modalComplyRate').val((comply / observe * 100).toFixed(1));
    } else {
        $('#modalComplyRate').val('');
    }
}

function loadList() {
    var param = {
        hospCd: '0001',
        monitorMonth: $('#searchMonitorMonth').val(),
        wardNm: $('#searchWardNm').val().trim()
    };
    $.ajax({
        url: '/manage/getHandHygieneList.do',
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
        tbody.append('<tr><td colspan="13" class="text-center py-3">조회된 데이터가 없습니다.</td></tr>');
        return;
    }
    $.each(list, function(idx, item) {
        var rate = '-';
        if (item.observeCnt && item.observeCnt > 0) {
            rate = ((item.complyCnt / item.observeCnt) * 100).toFixed(1);
        }
        var tr = '<tr>' +
            '<td class="text-center">' + (idx + 1) + '</td>' +
            '<td class="text-center">' + (item.monitorMonth || '') + '</td>' +
            '<td>' + (item.wardNm || '') + '</td>' +
            '<td class="text-center">' + (item.jobType || '') + '</td>' +
            '<td class="text-center">' + (item.observeCnt != null ? item.observeCnt : '') + '</td>' +
            '<td class="text-center">' + (item.complyCnt != null ? item.complyCnt : '') + '</td>' +
            '<td class="text-center">' + rate + '</td>' +
            '<td class="text-center">' + (item.moment1 != null ? item.moment1 : '') + '</td>' +
            '<td class="text-center">' + (item.moment2 != null ? item.moment2 : '') + '</td>' +
            '<td class="text-center">' + (item.moment3 != null ? item.moment3 : '') + '</td>' +
            '<td class="text-center">' + (item.moment4 != null ? item.moment4 : '') + '</td>' +
            '<td class="text-center">' + (item.moment5 != null ? item.moment5 : '') + '</td>' +
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
        $('#modalTitle').text('손위생 모니터링 등록');
        $('#dataForm')[0].reset();
        $('#modalCompCd').val('0001');
        $('#modalSeq').val('');
        $('#modalComplyRate').val('');
    } else {
        $('#modalTitle').text('손위생 모니터링 수정');
        $('#modalSeq').val(item.seq);
        $('#modalMonitorDt').val(item.monitorDt);
        $('#modalMonitorMonth').val(item.monitorMonth);
        $('#modalWardNm').val(item.wardNm);
        $('#modalJobType').val(item.jobType);
        $('#modalObserveCnt').val(item.observeCnt);
        $('#modalComplyCnt').val(item.complyCnt);
        $('#modalMoment1').val(item.moment1);
        $('#modalMoment2').val(item.moment2);
        $('#modalMoment3').val(item.moment3);
        $('#modalMoment4').val(item.moment4);
        $('#modalMoment5').val(item.moment5);
        $('#modalMonitorUser').val(item.monitorUser);
        $('#modalNote').val(item.note);
        calcComplyRate();
    }
    $('#formModal').modal('show');
}

function saveData() {
    var param = {
        hospCd: $('#modalCompCd').val(),
        seq: $('#modalSeq').val(),
        monitorDt: $('#modalMonitorDt').val(),
        monitorMonth: $('#modalMonitorMonth').val(),
        wardNm: $('#modalWardNm').val().trim(),
        jobType: $('#modalJobType').val(),
        observeCnt: $('#modalObserveCnt').val(),
        complyCnt: $('#modalComplyCnt').val(),
        complyRate: $('#modalComplyRate').val(),
        moment1: $('#modalMoment1').val(),
        moment2: $('#modalMoment2').val(),
        moment3: $('#modalMoment3').val(),
        moment4: $('#modalMoment4').val(),
        moment5: $('#modalMoment5').val(),
        monitorUser: $('#modalMonitorUser').val().trim(),
        note: $('#modalNote').val().trim(),
        mode: $('#modalMode').val()
    };
    if (!param.monitorMonth || !param.wardNm) {
        alert('필수 항목을 입력하세요.');
        return;
    }
    $.ajax({
        url: '/manage/saveHandHygiene.do',
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
        url: '/manage/deleteHandHygiene.do',
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
