<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<div class="container-fluid px-4 py-3">
    <h4 class="mb-3">소방설비 점검</h4>

    <!-- Search Area -->
    <div class="card shadow-sm mb-3">
        <div class="card-body py-2">
            <form class="form-inline" id="searchForm">
                <div class="form-group mr-3">
                    <label for="searchChkYear" class="mr-2">점검연도</label>
                    <input type="text" class="form-control form-control-sm" id="searchChkYear"
                           name="chkYear" placeholder="예: 2026" maxlength="4" style="width:100px;">
                </div>
                <button type="button" class="btn btn-sm btn-primary" id="btnSearch">조회</button>
            </form>
        </div>
    </div>

    <!-- Data Table -->
    <div class="card shadow-sm">
        <div class="card-header bg-white d-flex justify-content-between align-items-center">
            <span class="font-weight-bold">소방설비 점검 목록</span>
            <button type="button" class="btn btn-sm btn-primary" id="btnAdd">등록</button>
        </div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-bordered table-hover table-sm mb-0" id="dataTable">
                    <thead class="thead-light">
                        <tr>
                            <th style="width:40px;">No</th>
                            <th>건물/층</th>
                            <th>설치위치</th>
                            <th>소화기종류</th>
                            <th style="width:55px;">1월</th>
                            <th style="width:55px;">2월</th>
                            <th style="width:55px;">3월</th>
                            <th style="width:55px;">4월</th>
                            <th style="width:55px;">5월</th>
                            <th style="width:55px;">6월</th>
                            <th style="width:55px;">7월</th>
                            <th style="width:55px;">8월</th>
                            <th style="width:55px;">9월</th>
                            <th style="width:55px;">10월</th>
                            <th style="width:55px;">11월</th>
                            <th style="width:55px;">12월</th>
                            <th>비고</th>
                            <th style="width:110px;">관리</th>
                        </tr>
                    </thead>
                    <tbody id="dataBody">
                        <tr>
                            <td colspan="18" class="text-center py-3">조회 버튼을 클릭하세요.</td>
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
                <h5 class="modal-title" id="modalTitle">소방설비 점검 등록</h5>
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
                                <label>건물/층</label>
                                <input type="text" class="form-control" id="modalBuilding" name="building" required>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group">
                                <label>설치위치</label>
                                <input type="text" class="form-control" id="modalLocation" name="location" required>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group">
                                <label>소화기종류</label>
                                <input type="text" class="form-control" id="modalEquipType" name="equipType">
                            </div>
                        </div>
                    </div>
                    <hr>
                    <h6>월별 점검결과</h6>
                    <div class="row">
                        <div class="col-md-3">
                            <div class="form-group">
                                <label>1월</label>
                                <select class="form-control form-control-sm" id="modalM01" name="m01">
                                    <option value="">미점검</option>
                                    <option value="양호">양호</option>
                                    <option value="불량">불량</option>
                                </select>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label>2월</label>
                                <select class="form-control form-control-sm" id="modalM02" name="m02">
                                    <option value="">미점검</option>
                                    <option value="양호">양호</option>
                                    <option value="불량">불량</option>
                                </select>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label>3월</label>
                                <select class="form-control form-control-sm" id="modalM03" name="m03">
                                    <option value="">미점검</option>
                                    <option value="양호">양호</option>
                                    <option value="불량">불량</option>
                                </select>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label>4월</label>
                                <select class="form-control form-control-sm" id="modalM04" name="m04">
                                    <option value="">미점검</option>
                                    <option value="양호">양호</option>
                                    <option value="불량">불량</option>
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <div class="form-group">
                                <label>5월</label>
                                <select class="form-control form-control-sm" id="modalM05" name="m05">
                                    <option value="">미점검</option>
                                    <option value="양호">양호</option>
                                    <option value="불량">불량</option>
                                </select>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label>6월</label>
                                <select class="form-control form-control-sm" id="modalM06" name="m06">
                                    <option value="">미점검</option>
                                    <option value="양호">양호</option>
                                    <option value="불량">불량</option>
                                </select>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label>7월</label>
                                <select class="form-control form-control-sm" id="modalM07" name="m07">
                                    <option value="">미점검</option>
                                    <option value="양호">양호</option>
                                    <option value="불량">불량</option>
                                </select>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label>8월</label>
                                <select class="form-control form-control-sm" id="modalM08" name="m08">
                                    <option value="">미점검</option>
                                    <option value="양호">양호</option>
                                    <option value="불량">불량</option>
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <div class="form-group">
                                <label>9월</label>
                                <select class="form-control form-control-sm" id="modalM09" name="m09">
                                    <option value="">미점검</option>
                                    <option value="양호">양호</option>
                                    <option value="불량">불량</option>
                                </select>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label>10월</label>
                                <select class="form-control form-control-sm" id="modalM10" name="m10">
                                    <option value="">미점검</option>
                                    <option value="양호">양호</option>
                                    <option value="불량">불량</option>
                                </select>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label>11월</label>
                                <select class="form-control form-control-sm" id="modalM11" name="m11">
                                    <option value="">미점검</option>
                                    <option value="양호">양호</option>
                                    <option value="불량">불량</option>
                                </select>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label>12월</label>
                                <select class="form-control form-control-sm" id="modalM12" name="m12">
                                    <option value="">미점검</option>
                                    <option value="양호">양호</option>
                                    <option value="불량">불량</option>
                                </select>
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

function getMonthBadge(val) {
    if (val === '양호') return '<span class="badge badge-success">양호</span>';
    if (val === '불량') return '<span class="badge badge-danger">불량</span>';
    return '<span class="badge badge-secondary">-</span>';
}

function loadList() {
    var param = {
        compCd: '0001',
        chkYear: $('#searchChkYear').val().trim()
    };
    $.ajax({
        url: '/manage/getFireEquipList.do',
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
        tbody.append('<tr><td colspan="18" class="text-center py-3">조회된 데이터가 없습니다.</td></tr>');
        return;
    }
    $.each(list, function(idx, item) {
        var tr = '<tr>' +
            '<td class="text-center">' + (idx + 1) + '</td>' +
            '<td>' + (item.building || '') + '</td>' +
            '<td>' + (item.location || '') + '</td>' +
            '<td>' + (item.equipType || '') + '</td>' +
            '<td class="text-center">' + getMonthBadge(item.m01) + '</td>' +
            '<td class="text-center">' + getMonthBadge(item.m02) + '</td>' +
            '<td class="text-center">' + getMonthBadge(item.m03) + '</td>' +
            '<td class="text-center">' + getMonthBadge(item.m04) + '</td>' +
            '<td class="text-center">' + getMonthBadge(item.m05) + '</td>' +
            '<td class="text-center">' + getMonthBadge(item.m06) + '</td>' +
            '<td class="text-center">' + getMonthBadge(item.m07) + '</td>' +
            '<td class="text-center">' + getMonthBadge(item.m08) + '</td>' +
            '<td class="text-center">' + getMonthBadge(item.m09) + '</td>' +
            '<td class="text-center">' + getMonthBadge(item.m10) + '</td>' +
            '<td class="text-center">' + getMonthBadge(item.m11) + '</td>' +
            '<td class="text-center">' + getMonthBadge(item.m12) + '</td>' +
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
        $('#modalTitle').text('소방설비 점검 등록');
        $('#dataForm')[0].reset();
        $('#modalCompCd').val('0001');
        $('#modalSeq').val('');
    } else {
        $('#modalTitle').text('소방설비 점검 수정');
        $('#modalSeq').val(item.seq);
        $('#modalBuilding').val(item.building);
        $('#modalLocation').val(item.location);
        $('#modalEquipType').val(item.equipType);
        for (var i = 1; i <= 12; i++) {
            var mm = ('0' + i).slice(-2);
            $('#modalM' + mm).val(item['m' + mm] || '');
        }
        $('#modalNote').val(item.note);
    }
    $('#formModal').modal('show');
}

function saveData() {
    var param = {
        compCd: $('#modalCompCd').val(),
        seq: $('#modalSeq').val(),
        chkYear: $('#searchChkYear').val().trim(),
        building: $('#modalBuilding').val().trim(),
        location: $('#modalLocation').val().trim(),
        equipType: $('#modalEquipType').val().trim(),
        note: $('#modalNote').val().trim(),
        mode: $('#modalMode').val()
    };
    for (var i = 1; i <= 12; i++) {
        var mm = ('0' + i).slice(-2);
        param['m' + mm] = $('#modalM' + mm).val();
    }
    if (!param.building || !param.location) {
        alert('필수 항목을 입력하세요.');
        return;
    }
    $.ajax({
        url: '/manage/saveFireEquip.do',
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
        url: '/manage/deleteFireEquip.do',
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
