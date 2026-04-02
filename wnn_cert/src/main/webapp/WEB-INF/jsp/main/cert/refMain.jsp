<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<style>
    .ref-panel {
        max-height: calc(100vh - 160px);
        overflow-y: auto;
    }
    .group-row { cursor: pointer; }
    .group-row:hover { background-color: #e9ecef; }
    .group-row.active { background-color: #d6eaf8; font-weight: 600; }
    .badge-count { font-size: 0.8rem; }
</style>

<div class="container-fluid px-4 py-3">
    <h4 class="mb-3">공통코드 관리</h4>
    <div class="row">

        <!-- LEFT: Code Group List -->
        <div class="col-md-4">
            <div class="card shadow-sm">
                <div class="card-header bg-white d-flex justify-content-between align-items-center">
                    <span class="font-weight-bold">코드그룹 목록</span>
                    <button type="button" class="btn btn-sm btn-success" id="btnAddGroup">새 그룹</button>
                </div>
                <div class="card-body p-2">
                    <div class="input-group input-group-sm mb-2">
                        <input type="text" class="form-control" id="searchRefCd" placeholder="코드그룹 검색...">
                        <div class="input-group-append">
                            <button class="btn btn-outline-secondary" type="button" id="btnSearchGroup">검색</button>
                        </div>
                    </div>
                </div>
                <div class="ref-panel p-0">
                    <table class="table table-sm table-hover mb-0">
                        <thead class="thead-light">
                            <tr>
                                <th style="width:40%;">코드그룹</th>
                                <th>설명</th>
                                <th style="width:60px;" class="text-center">코드수</th>
                            </tr>
                        </thead>
                        <tbody id="groupBody">
                            <tr><td colspan="3" class="text-center py-3 text-muted">로딩 중...</td></tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- RIGHT: Code Detail List -->
        <div class="col-md-8">
            <div class="card shadow-sm">
                <div class="card-header bg-white d-flex justify-content-between align-items-center">
                    <span class="font-weight-bold" id="detailTitle">코드 상세 - 그룹을 선택하세요</span>
                    <button type="button" class="btn btn-sm btn-primary" id="btnAddRef" disabled>코드 추가</button>
                </div>
                <div class="ref-panel p-0">
                    <table class="table table-bordered table-sm table-hover mb-0">
                        <thead class="thead-light">
                            <tr>
                                <th style="width:60px;" class="text-center">순번</th>
                                <th style="width:150px;">코드값</th>
                                <th>설명</th>
                                <th style="width:80px;" class="text-center">사용여부</th>
                                <th style="width:130px;" class="text-center">관리</th>
                            </tr>
                        </thead>
                        <tbody id="refBody">
                            <tr><td colspan="5" class="text-center py-3 text-muted">코드그룹을 선택하세요.</td></tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

    </div>
</div>

<!-- Add/Edit Modal -->
<div class="modal fade" id="refModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="refModalTitle">코드 추가</h5>
                <button type="button" class="close" data-dismiss="modal"><span>&times;</span></button>
            </div>
            <div class="modal-body">
                <form id="refForm">
                    <input type="hidden" id="modalMode" value="I">
                    <div class="form-group">
                        <label for="modalRefCd">코드그룹 (REF_CD)</label>
                        <input type="text" class="form-control" id="modalRefCd" required>
                    </div>
                    <div class="form-group">
                        <label for="modalRefSeq">순번 (REF_SEQ)</label>
                        <input type="number" class="form-control" id="modalRefSeq" min="1" required>
                    </div>
                    <div class="form-group">
                        <label for="modalRefVal">코드값 (REF_VAL)</label>
                        <input type="text" class="form-control" id="modalRefVal" required>
                    </div>
                    <div class="form-group">
                        <label for="modalNote">설명 (NOTE)</label>
                        <input type="text" class="form-control" id="modalNote">
                    </div>
                    <div class="form-group">
                        <label for="modalUseYn">사용여부</label>
                        <select class="form-control" id="modalUseYn">
                            <option value="Y">Y</option>
                            <option value="N">N</option>
                        </select>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
                <button type="button" class="btn btn-primary" id="btnSaveRef">저장</button>
            </div>
        </div>
    </div>
</div>

<script>
var currentRefCd = '';
var compCd = '0001';

$(document).ready(function() {
    loadGroupList();

    $('#btnSearchGroup').on('click', function() {
        loadGroupList();
    });

    $('#searchRefCd').on('keypress', function(e) {
        if (e.which === 13) loadGroupList();
    });

    $('#btnAddGroup').on('click', function() {
        openRefModal('I', null, true);
    });

    $('#btnAddRef').on('click', function() {
        openRefModal('I', null, false);
    });

    $('#btnSaveRef').on('click', function() {
        saveRef();
    });
});

/* ========== Group List ========== */
function loadGroupList() {
    var param = { compCd: compCd };
    var keyword = $('#searchRefCd').val().trim();
    if (keyword) param.refCd = keyword;

    $.ajax({
        url: '/cert/getRefGroupList.do',
        type: 'POST',
        data: param,
        dataType: 'json',
        success: function(res) {
            if (res.result === 'success') {
                renderGroupList(res.data);
            } else {
                $('#groupBody').html('<tr><td colspan="3" class="text-center py-3 text-danger">' + (res.msg || '조회 실패') + '</td></tr>');
            }
        },
        error: function() {
            $('#groupBody').html('<tr><td colspan="3" class="text-center py-3 text-danger">서버 오류</td></tr>');
        }
    });
}

function renderGroupList(list) {
    var tbody = $('#groupBody');
    tbody.empty();

    if (!list || list.length === 0) {
        tbody.append('<tr><td colspan="3" class="text-center py-3 text-muted">등록된 코드그룹이 없습니다.</td></tr>');
        return;
    }

    $.each(list, function(idx, item) {
        var refCd = item.REF_CD || item.ref_cd || '';
        var refNm = item.REF_NM || item.ref_nm || '';
        var cnt   = item.CODE_CNT || item.code_cnt || 0;
        var activeClass = (refCd === currentRefCd) ? ' active' : '';

        var tr = '<tr class="group-row' + activeClass + '" data-ref-cd="' + refCd + '">'
               + '<td><strong>' + refCd + '</strong></td>'
               + '<td>' + refNm + '</td>'
               + '<td class="text-center"><span class="badge badge-info badge-count">' + cnt + '</span></td>'
               + '</tr>';
        tbody.append(tr);
    });

    tbody.find('.group-row').on('click', function() {
        $('.group-row').removeClass('active');
        $(this).addClass('active');
        currentRefCd = $(this).data('ref-cd');
        $('#detailTitle').text('코드 상세 - ' + currentRefCd);
        $('#btnAddRef').prop('disabled', false);
        loadRefList(currentRefCd);
    });
}

/* ========== Ref Detail List ========== */
function loadRefList(refCd) {
    $.ajax({
        url: '/cert/getRefList.do',
        type: 'POST',
        data: { compCd: compCd, refCd: refCd },
        dataType: 'json',
        success: function(res) {
            if (res.result === 'success') {
                renderRefList(res.data);
            } else {
                $('#refBody').html('<tr><td colspan="5" class="text-center py-3 text-danger">' + (res.msg || '조회 실패') + '</td></tr>');
            }
        },
        error: function() {
            $('#refBody').html('<tr><td colspan="5" class="text-center py-3 text-danger">서버 오류</td></tr>');
        }
    });
}

function renderRefList(list) {
    var tbody = $('#refBody');
    tbody.empty();

    if (!list || list.length === 0) {
        tbody.append('<tr><td colspan="5" class="text-center py-3 text-muted">등록된 코드가 없습니다.</td></tr>');
        return;
    }

    $.each(list, function(idx, item) {
        var refSeq = item.REF_SEQ || item.ref_seq || '';
        var refVal = item.REF_VAL || item.ref_val || '';
        var note   = item.NOTE   || item.note   || '';
        var useYn  = item.USE_YN || item.use_yn || '';
        var useClass = (useYn === 'Y') ? 'badge-success' : 'badge-secondary';

        var tr = '<tr>'
            + '<td class="text-center">' + refSeq + '</td>'
            + '<td>' + refVal + '</td>'
            + '<td>' + note + '</td>'
            + '<td class="text-center"><span class="badge ' + useClass + '">' + useYn + '</span></td>'
            + '<td class="text-center">'
            +   '<button class="btn btn-sm btn-outline-primary mr-1" onclick="editRef(\'' + escapeJs(refSeq) + '\',\'' + escapeJs(refVal) + '\',\'' + escapeJs(note) + '\',\'' + escapeJs(useYn) + '\')">수정</button>'
            +   '<button class="btn btn-sm btn-outline-danger" onclick="deleteRef(\'' + escapeJs(refSeq) + '\')">삭제</button>'
            + '</td>'
            + '</tr>';
        tbody.append(tr);
    });
}

function escapeJs(val) {
    return String(val).replace(/'/g, "\\'").replace(/"/g, '&quot;');
}

/* ========== Modal ========== */
function openRefModal(mode, data, isNewGroup) {
    $('#modalMode').val(mode);
    $('#refForm')[0].reset();
    $('#modalUseYn').val('Y');

    if (mode === 'I') {
        $('#refModalTitle').text(isNewGroup ? '새 코드그룹 추가' : '코드 추가');
        if (isNewGroup) {
            $('#modalRefCd').val('').prop('readonly', false);
        } else {
            $('#modalRefCd').val(currentRefCd).prop('readonly', true);
        }
        $('#modalRefSeq').val('').prop('readonly', false);
    } else {
        $('#refModalTitle').text('코드 수정');
        $('#modalRefCd').val(currentRefCd).prop('readonly', true);
        $('#modalRefSeq').val(data.refSeq).prop('readonly', true);
        $('#modalRefVal').val(data.refVal);
        $('#modalNote').val(data.note);
        $('#modalUseYn').val(data.useYn);
    }

    $('#refModal').modal('show');
}

function editRef(refSeq, refVal, note, useYn) {
    openRefModal('U', { refSeq: refSeq, refVal: refVal, note: note, useYn: useYn }, false);
}

/* ========== Save ========== */
function saveRef() {
    var refCd  = $('#modalRefCd').val().trim();
    var refSeq = $('#modalRefSeq').val().trim();
    var refVal = $('#modalRefVal').val().trim();

    if (!refCd) { alert('코드그룹을 입력하세요.'); return; }
    if (!refSeq) { alert('순번을 입력하세요.'); return; }
    if (!refVal) { alert('코드값을 입력하세요.'); return; }

    var param = {
        compCd:  compCd,
        refCd:   refCd,
        refSeq:  refSeq,
        refVal:  refVal,
        note:    $('#modalNote').val().trim(),
        useYn:   $('#modalUseYn').val(),
        mode:    $('#modalMode').val(),
        regUser: 'admin',
        updUser: 'admin'
    };

    $.ajax({
        url: '/cert/saveRef.do',
        type: 'POST',
        data: param,
        dataType: 'json',
        success: function(res) {
            if (res.result === 'success') {
                alert('저장되었습니다.');
                $('#refModal').modal('hide');
                loadGroupList();
                if (currentRefCd) loadRefList(currentRefCd === refCd ? currentRefCd : refCd);
                if (currentRefCd !== refCd) currentRefCd = refCd;
            } else {
                alert(res.msg || '저장에 실패하였습니다.');
            }
        },
        error: function() {
            alert('저장 중 오류가 발생하였습니다.');
        }
    });
}

/* ========== Delete ========== */
function deleteRef(refSeq) {
    if (!confirm('해당 코드를 삭제하시겠습니까?')) return;

    $.ajax({
        url: '/cert/deleteRef.do',
        type: 'POST',
        data: { compCd: compCd, refCd: currentRefCd, refSeq: refSeq },
        dataType: 'json',
        success: function(res) {
            if (res.result === 'success') {
                alert('삭제되었습니다.');
                loadGroupList();
                loadRefList(currentRefCd);
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
