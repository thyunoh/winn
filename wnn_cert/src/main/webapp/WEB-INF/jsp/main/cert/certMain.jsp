<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap4.min.css">
<style>
    .tree-panel {
        max-height: calc(100vh - 120px);
        overflow-y: auto;
        border-right: 1px solid #dee2e6;
    }
    .tree-panel .card-header {
        cursor: pointer;
        padding: 8px 12px;
        font-size: 0.9rem;
    }
    .tree-panel .card-header:hover {
        background-color: #e9ecef;
    }
    .tree-level1 { background-color: #d6eaf8 !important; font-weight: 700 !important; font-size: 16px !important; display: flex; justify-content: space-between; align-items: center; padding: 13px 14px !important; }
    .tree-level2 { background-color: #ebf5fb !important; padding-left: 28px !important; font-weight: 600 !important; font-size: 15px !important; display: flex; justify-content: space-between; align-items: center; padding: 12px 14px !important; }
    .tree-toggle-icon { display: inline-flex; width: 22px; height: 22px; justify-content: center; align-items: center; border: 1px solid #888; border-radius: 3px; font-size: 15px; font-weight: bold; color: #333; background: #fff; flex-shrink: 0; margin-left: 8px; }
    .tree-level3 {
        padding: 11px 14px 11px 45px !important;
        cursor: pointer;
        font-size: 14px !important;
        border-bottom: 1px solid #f0f0f0;
    }
    .tree-level3:hover, .tree-level3.active {
        background-color: #aed6f1;
    }
    .item-panel {
        max-height: calc(100vh - 120px);
        overflow-y: auto;
    }
</style>

<div class="container-fluid px-4 py-3">
    <h4 class="mb-3">인증기준 관리</h4>
    <div class="row">
        <!-- Left: Tree Navigation -->
        <div class="col-md-4 col-lg-3">
            <div class="card shadow-sm">
                <div class="card-header bg-white font-weight-bold">인증기준 목록</div>
                <div class="card-body p-0 tree-panel" id="treePanel">
                    <div class="text-center py-3 text-muted">로딩 중...</div>
                </div>
            </div>
        </div>

        <!-- Right: Items Table -->
        <div class="col-md-8 col-lg-9">
            <div class="card shadow-sm">
                <div class="card-header bg-white d-flex justify-content-between align-items-center">
                    <span class="font-weight-bold" id="selectedNodeNm">조사항목 목록</span>
                    <button type="button" class="btn btn-sm btn-primary" id="btnAddItem" disabled>항목 추가</button>
                </div>
                <div class="card-body p-0 item-panel">
                    <table class="table table-bordered table-hover table-sm mb-0" id="itemTable">
                        <thead class="thead-light">
                            <tr>
                                <th style="width:50px;">No</th>
                                <th style="width:100px;">항목코드</th>
                                <th>항목명</th>
                                <th style="width:200px;">항목설명</th>
                                <th style="width:80px;">순서</th>
                                <th style="width:80px;">사용</th>
                                <th style="width:80px;">관리</th>
                            </tr>
                        </thead>
                        <tbody id="itemBody">
                            <tr>
                                <td colspan="7" class="text-center py-3">기준을 선택하세요.</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Add/Edit Item Modal -->
<div class="modal fade" id="itemModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="itemModalTitle">항목 추가</h5>
                <button type="button" class="close" data-dismiss="modal"><span>&times;</span></button>
            </div>
            <div class="modal-body">
                <form id="itemForm">
                    <input type="hidden" id="modalMode" value="add">
                    <div class="form-group">
                        <label for="modalItemCd">항목코드</label>
                        <input type="text" class="form-control" id="modalItemCd" name="itemCd" required>
                    </div>
                    <div class="form-group">
                        <label for="modalItemNm">항목명</label>
                        <input type="text" class="form-control" id="modalItemNm" name="itemNm" required>
                    </div>
                    <div class="form-group">
                        <label for="modalItemDesc">항목설명</label>
                        <textarea class="form-control" id="modalItemDesc" name="itemDesc" rows="3"></textarea>
                    </div>
                    <div class="form-group">
                        <label for="modalEvalType">평가유형</label>
                        <select class="form-control" id="modalEvalType" name="evalType">
                            <option value="Y/N">Y/N</option>
                            <option value="상/중/하">상/중/하</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="modalWeight">가중치</label>
                        <input type="number" class="form-control" id="modalWeight" name="weight"
                               min="0" max="100" step="0.1" value="1">
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
                <button type="button" class="btn btn-primary" id="btnSaveItem">저장</button>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap4.min.js"></script>
<script>
var currentNodeId = '';

$(document).ready(function() {
    loadTreeNodes('00');

    $('#btnAddItem').on('click', function() {
        openItemModal('add');
    });

    $('#btnSaveItem').on('click', function() {
        saveItem();
    });
});

/* ========== Tree Loading (recursive via getTreeList.do) ========== */
function loadTreeNodes(parentId, container, level) {
    level = level || 1;

    $.ajax({
        url: '/cert/getTreeList.do',
        type: 'POST',
        data: { hospCd: '12345678', tabId: 'CERT', grpCd: 'STD', parentId: parentId },
        dataType: 'json',
        success: function(res) {
            if (res.result === 'success') {
                if (level === 1) {
                    renderLevel1(res.data);
                } else if (level === 2) {
                    renderLevel2(res.data, container, parentId);
                } else if (level === 3) {
                    renderLevel3(res.data, container);
                }
            } else {
                var msg = res.msg || '데이터 로딩 실패';
                if (container) {
                    container.html('<div class="text-center py-2 text-danger">' + msg + '</div>');
                } else {
                    $('#treePanel').html('<div class="text-center py-3 text-danger">' + msg + '</div>');
                }
            }
        },
        error: function() {
            var target = container || $('#treePanel');
            target.html('<div class="text-center py-3 text-danger">데이터 로딩 실패</div>');
        }
    });
}

/* Level 1: 영역 */
function renderLevel1(nodeList) {
    var html = '<div class="accordion" id="treeAccordion">';
    $.each(nodeList, function(idx, node) {
        var collapseId = 'level1_' + idx;
        html += '<div class="card border-0 rounded-0">';
        html += '<div class="card-header tree-level1" data-toggle="collapse" data-target="#' + collapseId + '"'
              + ' data-node-id="' + node.nodeId + '">'
              + node.nodeNm + '<span class="tree-toggle-icon">+</span></div>';
        html += '<div id="' + collapseId + '" class="collapse">';
        html += '<div class="level2-area" data-node-id="' + node.nodeId + '"></div>';
        html += '</div></div>';
    });
    html += '</div>';
    $('#treePanel').html(html);

    // Load level2 children on expand + toggle icon
    $('.tree-level1').on('click', function() {
        var $icon = $(this).find('.tree-toggle-icon');
        var isOpen = $(this).next('.collapse').hasClass('show');
        $icon.text(isOpen ? '+' : '-');
        var nodeId = $(this).data('node-id');
        var target = $(this).next('.collapse');
        var level2Area = target.find('.level2-area');
        if (level2Area.children().length === 0) {
            loadTreeNodes(nodeId, level2Area, 2);
        }
    });
}

/* Level 2: 장 */
function renderLevel2(nodeList, container, parentNodeId) {
    var html = '';
    $.each(nodeList, function(idx, node) {
        var collapseId = 'level2_' + parentNodeId + '_' + idx;
        html += '<div class="card-header tree-level2" data-toggle="collapse" data-target="#' + collapseId + '"'
              + ' data-node-id="' + node.nodeId + '">'
              + node.nodeNm + '<span class="tree-toggle-icon">+</span></div>';
        html += '<div id="' + collapseId + '" class="collapse">';
        html += '<div class="level3-area" data-node-id="' + node.nodeId + '"></div>';
        html += '</div>';
    });
    container.html(html);

    container.find('.tree-level2').on('click', function() {
        var $icon = $(this).find('.tree-toggle-icon');
        var isOpen = $(this).next('.collapse').hasClass('show');
        $icon.text(isOpen ? '+' : '-');
        var nodeId = $(this).data('node-id');
        var target = $(this).next('.collapse');
        var level3Area = target.find('.level3-area');
        if (level3Area.children().length === 0) {
            loadTreeNodes(nodeId, level3Area, 3);
        }
    });
}

/* Level 3: 기준 */
function renderLevel3(nodeList, container) {
    var html = '';
    $.each(nodeList, function(idx, node) {
        html += '<div class="tree-level3" data-node-id="' + node.nodeId + '">'
              + node.nodeNm + '</div>';
    });
    container.html(html);

    container.find('.tree-level3').on('click', function() {
        $('.tree-level3').removeClass('active');
        $(this).addClass('active');
        currentNodeId = $(this).data('node-id');
        $('#selectedNodeNm').text('조사항목 - ' + $(this).text());
        $('#btnAddItem').prop('disabled', false);
        loadItemList(currentNodeId);
    });
}

/* ========== Items ========== */
function loadItemList(nodeId) {
    $.ajax({
        url: '/cert/getTreeList.do',
        type: 'POST',
        data: { hospCd: '12345678', tabId: 'CERT', grpCd: 'STD', parentId: nodeId },
        dataType: 'json',
        success: function(res) {
            if (res.result === 'success') {
                renderItems(res.data);
            } else {
                alert(res.msg || '항목 목록을 불러오지 못했습니다.');
            }
        },
        error: function() {
            alert('항목 목록을 불러오는 중 오류가 발생하였습니다.');
        }
    });
}

function renderItems(itemList) {
    var tbody = $('#itemBody');
    tbody.empty();

    if (!itemList || itemList.length === 0) {
        tbody.append('<tr><td colspan="7" class="text-center py-3">등록된 항목이 없습니다.</td></tr>');
        return;
    }

    $.each(itemList, function(idx, item) {
        var tr = '<tr>' +
            '<td class="text-center">' + (idx + 1) + '</td>' +
            '<td>' + (item.nodeId || '') + '</td>' +
            '<td>' + (item.nodeNm || '') + '</td>' +
            '<td>' + (item.nodeDesc || '') + '</td>' +
            '<td class="text-center">' + (item.sortOrd || '') + '</td>' +
            '<td class="text-center">' + (item.useYn || '') + '</td>' +
            '<td class="text-center">' +
                '<button class="btn btn-sm btn-outline-primary" onclick="openItemModal(\'edit\', ' + JSON.stringify(item).replace(/"/g, '&quot;') + ')">수정</button>' +
            '</td>' +
            '</tr>';
        tbody.append(tr);
    });
}

/* ========== Modal ========== */
function openItemModal(mode, item) {
    $('#modalMode').val(mode);
    if (mode === 'add') {
        $('#itemModalTitle').text('항목 추가');
        $('#itemForm')[0].reset();
        $('#modalItemCd').prop('readonly', false);
    } else {
        $('#itemModalTitle').text('항목 수정');
        $('#modalItemCd').val(item.itemCd).prop('readonly', true);
        $('#modalItemNm').val(item.itemNm);
        $('#modalItemDesc').val(item.itemDesc);
        $('#modalEvalType').val(item.evalType);
        $('#modalWeight').val(item.weight);
    }
    $('#itemModal').modal('show');
}

function saveItem() {
    var param = {
        nodeId: currentNodeId,
        itemCd: $('#modalItemCd').val().trim(),
        itemNm: $('#modalItemNm').val().trim(),
        itemDesc: $('#modalItemDesc').val().trim(),
        evalType: $('#modalEvalType').val(),
        weight: parseFloat($('#modalWeight').val()) || 0,
        mode: $('#modalMode').val()
    };

    if (!param.itemCd || !param.itemNm) {
        alert('항목코드와 항목명을 입력하세요.');
        return;
    }

    $.ajax({
        url: '/cert/saveItem.do',
        type: 'POST',
        data: param,
        dataType: 'json',
        success: function(res) {
            if (res.result === 'success') {
                alert('저장되었습니다.');
                $('#itemModal').modal('hide');
                loadItemList(currentNodeId);
            } else {
                alert(res.msg || '저장에 실패하였습니다.');
            }
        },
        error: function() {
            alert('저장 중 오류가 발생하였습니다.');
        }
    });
}
</script>
