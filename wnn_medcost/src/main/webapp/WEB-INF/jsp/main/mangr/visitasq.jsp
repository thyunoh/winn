<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="decorator" uri="http://www.opensymphony.com/sitemesh/decorator" %>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/page" prefix="page" %>
<%@ page import ="java.util.Date" %>
<!-- Customized Bootstrap Stylesheet -->
<link href="/css/winmc/style_comm.css?v=126"  rel="stylesheet">
    <style>
        .dataTables_scrollHead thead th { text-align: center !important; }
        .dataTables_scrollBody tbody td { font-weight: normal !important; text-align: center !important; }
        #visitAsqTable th, #visitAsqTable td { text-align: center !important; }

        /* ===== 사이트방문문의 목록 컨셉 스타일 (asqcd 동일) ===== */
        .asq-popup-card {
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 4px 24px rgba(0,0,0,0.13);
            max-width: 100%;
            margin: 10px auto;
            padding: 0;
            overflow: hidden;
        }
        .asq-popup-card .asq-title {
            font-size: 18px;
            font-weight: 700;
            color: #222;
            padding: 22px 28px 0 28px;
            margin: 0;
        }
        .asq-popup-card .asq-toolbar {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 14px 28px 10px 28px;
            flex-wrap: wrap;
            gap: 10px;
        }
        .asq-popup-card .asq-search-box {
            display: flex;
            align-items: center;
            border: 1.5px solid #bbb;
            border-radius: 6px;
            overflow: hidden;
            background: #fff;
            height: 36px;
            min-width: 220px;
        }
        .asq-popup-card .asq-search-box input {
            border: none;
            outline: none;
            padding: 6px 12px;
            font-size: 13px;
            flex: 1;
            height: 100%;
            background: transparent;
        }
        .asq-popup-card .asq-search-box button {
            border: none;
            background: transparent;
            padding: 0 10px;
            cursor: pointer;
            color: #555;
            font-size: 15px;
            height: 100%;
        }
        .asq-popup-card .asq-btn-group {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
        }
        .asq-popup-card .asq-btn {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            padding: 7px 16px;
            font-size: 13px;
            font-weight: 700;
            border: 1.5px solid #333;
            border-radius: 6px;
            background: #fff;
            color: #222;
            cursor: pointer;
            white-space: nowrap;
            transition: background 0.15s;
        }
        .asq-popup-card .asq-btn:hover {
            background: #f0f0f0;
        }
        /* 테이블 영역 */
        .asq-popup-card .asq-table-wrap {
            padding: 0 28px 10px 28px;
        }
        /* 테이블 헤더 */
        .asq-popup-card table.dataTable thead th,
        .asq-popup-card .dataTables_scrollHead table thead th,
        .asq-popup-card .dt-scroll-head table thead th {
            background: #c5d9ea !important;
            color: #222 !important;
            font-weight: 600 !important;
            font-size: 13px !important;
            border-bottom: 1px solid #ccd8e2 !important;
            padding: 6px 8px !important;
            line-height: 1.3 !important;
        }
        /* 테이블 데이터 행 간격 축소 */
        .asq-popup-card table.dataTable tbody td,
        .asq-popup-card .dataTables_scrollBody table tbody td {
            font-size: 13px !important;
            padding: 4px 8px !important;
            border-bottom: 1px solid #eee !important;
            color: #444;
            line-height: 1.3 !important;
        }
        .asq-popup-card table.dataTable tbody tr:hover {
            background: #f5f9fd !important;
        }
    </style>
    <style>
        /* ===== 선택 행 색상 ===== */
        table.dataTable tbody tr.selected > *,
        table.dataTable tbody tr.selected {
            background-color: #1a56a0 !important;
            color: #ffffff !important;
            box-shadow: none !important;
        }
        /* ===== 헤더-데이터 간격 제거 ===== */
        div.dataTables_scrollBody thead,
        div.dt-scroll-body thead {
            visibility: collapse !important;
            height: 0 !important;
            line-height: 0 !important;
            overflow: hidden !important;
        }
        div.dataTables_scrollBody thead th, div.dataTables_scrollBody thead td,
        div.dt-scroll-body thead th, div.dt-scroll-body thead td {
            height: 0 !important; padding: 0 !important; margin: 0 !important;
            border: none !important; line-height: 0 !important; font-size: 0 !important;
        }
        div.dataTables_scrollHead, div.dt-scroll-head { margin-bottom: 0 !important; border-bottom: none !important; padding-bottom: 0 !important; }
        div.dataTables_scrollBody, div.dt-scroll-body { margin-top: 0 !important; border-top: none !important; padding-top: 0 !important; }
        div.dataTables_scrollHead table, div.dt-scroll-head table { margin-bottom: 0 !important; border-bottom: none !important; }
        div.dataTables_scrollBody table, div.dt-scroll-body table { margin-top: 0 !important; border-top: none !important; }
        div.dataTables_scrollHeadInner, div.dt-scroll-headInner { padding-right: 0 !important; }
        div.dataTables_scroll, div.dt-scroll { overflow: visible !important; }

        /* 확인여부 배지 */
        .comform-y { color: #2563eb; font-weight: 700; }
        .comform-n { color: #e53e3e; font-weight: 700; }

        /* 상세 모달 */
        .visit-detail-label {
            font-weight: 600; font-size: 0.85rem; color: #555; margin-bottom: 2px;
        }
        .visit-detail-value {
            font-size: 0.9rem; margin-bottom: 10px; padding: 6px 10px;
            background: #f8f9fa; border-radius: 6px; border: 1px solid #e9ecef;
        }
        .visit-gb-badge {
            display: inline-block; padding: 3px 10px; margin: 2px 3px;
            font-size: 12px; font-weight: 500; border-radius: 12px;
            background: #e8f0fe; color: #1a73e8;
        }
        .visit-gb-badge.off {
            background: #f1f1f1; color: #aaa;
        }
    </style>
		<!-- ============================================================== -->
        <!-- Main Form start -->
        <!-- ============================================================== -->
		<div class="dashboard-wrapper">
            <div class="container-fluid dashboard-content">
                <div class="row">
                    <!-- ============================================================== -->
                    <!-- data table start -->
                    <!-- ============================================================== -->
                    <div class="col-xl-12 col-lg-12 col-md-12 col-sm-12 col-12" style="display:flex; justify-content:center;">
                        <div class="asq-popup-card" style="border: 1px solid #ccc; width:100%;">
                            <!-- 타이틀 -->
                            <h2 class="asq-title" style="font-size:20px; font-weight:800; color:#000; background:#d6e4f0; margin:0; padding:16px 28px; border-bottom:1px solid #b0c4d8;">
                                <i class="fas fa-building"></i> 사이트방문문의 목록
                            </h2>

                            <!-- 툴바 -->
                            <div class="asq-toolbar" style="background:#eef3f8;">
                                <div style="display:flex; align-items:center; gap:8px; flex-wrap:wrap;">
                                    <label class="mb-0" style="font-size:13px; font-weight:700; white-space:nowrap; color:#000;">자 료 검 색 :</label>
                                    <div class="asq-search-box">
                                        <input type="text" id="visitSearchInput" placeholder="기관명/신청자/연락처"
                                               onkeydown="if(event.key==='Enter') fnVisitSearch();">
                                        <button type="button" onclick="fnVisitSearch()"><i class="fas fa-search"></i></button>
                                    </div>
                                </div>
                                <div class="asq-btn-group">
                                    <button class="asq-btn" style="color:#000; border-color:#555;" onclick="fnVisitSearch()" title="조회"><i class="fas fa-binoculars"></i> 조회</button>
                                </div>
                            </div>

                            <!-- 테이블 영역 -->
                            <div class="asq-table-wrap">
                                <div style="width: 100%;">
                                    <table id="visitAsqTable" class="display nowrap stripe hover cell-border order-column responsive">
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!-- ============================================================== -->
                    <!-- data table end   -->
                    <!-- ============================================================== -->
                </div>
            </div>
        </div>

		<!-- ============================================================== -->
        <!-- 상세 모달 start -->
        <!-- ============================================================== -->
        <div class="modal fade" id="visitDetailModal" tabindex="-1" data-backdrop="static" data-keyboard="true" role="dialog" aria-hidden="true">
            <div class="modal-dialog modal-dialog-scrollable modal-lg"
                 style="max-width: 620px; width: 90%; margin-top: 10px;">
                <div class="modal-content"
                     style="max-height: calc(100vh - 10px); display: flex; flex-direction: column; border: none; border-radius: 12px; overflow: hidden; box-shadow: 0 8px 32px rgba(0,0,0,0.18);">

                    <!-- 타이틀 헤더 -->
                    <div style="background: #fff; padding: 10px 24px 6px 24px; flex-shrink: 0; border-bottom: 1px solid #eee; display: flex; justify-content: space-between; align-items: center;">
                        <h5 style="margin: 0; font-weight: 700; font-size: 17px; color: #222;"><i class="fas fa-building"></i> 문의 상세</h5>
                        <div></div>
                    </div>

                    <!-- Modal Body -->
                    <div class="modal-body" style="overflow-y: auto; flex-grow: 1; min-height: 0; padding: 0 24px 20px 24px; background: #f9f9f9;">
                        <!-- 기관정보 섹션 -->
                        <div style="margin-top: 6px;">
                            <div style="background: #afd4ec; color: #000; padding: 8px 16px; border-radius: 8px 8px 0 0; font-weight: 600; font-size: 15px; text-align: left;">
                                기관정보
                            </div>
                            <div style="background: #fff; border: 1px solid #d0d0d0; border-top: none; border-radius: 0 0 8px 8px; padding: 12px 14px;">
                                <div class="row">
                                    <div class="col-6">
                                        <div class="visit-detail-label">기관명</div>
                                        <div class="visit-detail-value" id="dtl_hospNm">-</div>
                                    </div>
                                    <div class="col-3">
                                        <div class="visit-detail-label">종별</div>
                                        <div class="visit-detail-value" id="dtl_jongNm">-</div>
                                    </div>
                                    <div class="col-3">
                                        <div class="visit-detail-label">병상수</div>
                                        <div class="visit-detail-value" id="dtl_bedCnt">-</div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- 컨설팅 분야 섹션 -->
                        <div style="margin-top: 4px;">
                            <div style="background: #afd4ec; color: #000; padding: 8px 16px; border-radius: 8px 8px 0 0; font-weight: 600; font-size: 15px; text-align: left;">
                                컨설팅 분야
                            </div>
                            <div style="background: #fff; border: 1px solid #e0e0e0; border-top: none; border-radius: 0 0 8px 8px; padding: 12px 14px;" id="dtl_consultGb">
                            </div>
                        </div>

                        <!-- 기타 요청사항 섹션 -->
                        <div style="margin-top: 4px;" id="dtl_gitaArea">
                            <div style="background: #afd4ec; color: #000; padding: 8px 16px; border-radius: 8px 8px 0 0; font-weight: 600; font-size: 15px; text-align: left;">
                                기타 요청사항
                            </div>
                            <div style="background: #fff; border: 1px solid #e0e0e0; border-top: none; border-radius: 0 0 8px 8px; padding: 12px 14px;">
                                <div id="dtl_consultGita1" style="white-space:pre-wrap; font-size:14px;"></div>
                            </div>
                        </div>

                        <!-- 신청자 정보 섹션 -->
                        <div style="margin-top: 4px;">
                            <div style="background: #afd4ec; color: #000; padding: 8px 16px; border-radius: 8px 8px 0 0; font-weight: 600; font-size: 15px; text-align: left;">
                                신청자 정보
                            </div>
                            <div style="background: #fff; border: 1px solid #e0e0e0; border-top: none; border-radius: 0 0 8px 8px; padding: 12px 14px;">
                                <div class="row">
                                    <div class="col-4">
                                        <div class="visit-detail-label">성함</div>
                                        <div class="visit-detail-value" id="dtl_userNm">-</div>
                                    </div>
                                    <div class="col-4">
                                        <div class="visit-detail-label">직위</div>
                                        <div class="visit-detail-value" id="dtl_userPosi">-</div>
                                    </div>
                                    <div class="col-4">
                                        <div class="visit-detail-label">연락처</div>
                                        <div class="visit-detail-value" id="dtl_userPhone">-</div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- 상태 정보 섹션 -->
                        <div style="margin-top: 4px;">
                            <div style="background: #afd4ec; color: #000; padding: 8px 16px; border-radius: 8px 8px 0 0; font-weight: 600; font-size: 15px; text-align: left;">
                                상태정보
                            </div>
                            <div style="background: #fff; border: 1px solid #e0e0e0; border-top: none; border-radius: 0 0 8px 8px; padding: 12px 14px;">
                                <div class="row">
                                    <div class="col-4">
                                        <div class="visit-detail-label">개인정보동의</div>
                                        <div class="visit-detail-value" id="dtl_accpetYn">-</div>
                                    </div>
                                    <div class="col-4">
                                        <div class="visit-detail-label">확인여부</div>
                                        <div class="visit-detail-value" id="dtl_comformYn">-</div>
                                    </div>
                                    <div class="col-4">
                                        <div class="visit-detail-label">등록일시</div>
                                        <div class="visit-detail-value" id="dtl_regDttm">-</div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Modal Footer -->
                    <div class="modal-footer" style="background: #fff; padding: 10px 24px; border-top: 1px solid #eee; justify-content: center;">
                        <button id="btnComformY" type="button" class="btn btn-outline-dark btn-sm" style="font-size: 13px; padding: 5px 18px;" onclick="fnComformSave('Y')">확인완료 <i class="fas fa-check"></i></button>
                        <button id="btnComformN" type="button" class="btn btn-outline-dark btn-sm" style="font-size: 13px; padding: 5px 18px;" onclick="fnComformSave('N')">미확인으로 <i class="fas fa-undo"></i></button>
                        <button type="button" class="btn btn-outline-dark btn-sm" style="font-size: 13px; padding: 5px 18px;" data-dismiss="modal" onclick="$('#visitDetailModal').modal('hide');">닫기 <i class="fas fa-times"></i></button>
                    </div>
                </div>
            </div>
        </div>
        <!-- ============================================================== -->
        <!-- 상세 모달 end -->
        <!-- ============================================================== -->

<script type="text/javascript">
var visitDataTable = null;
var visitDataList = [];
var selectedVisitSeq = 0;

$(document).ready(function() {
    fnVisitSearch();
});

function fnVisitSearch() {
    var findData = $('#visitSearchInput').val() || '';
    $.ajax({
        type: "POST",
        url: "/mangr/visitAsqList.do",
        data: { findData: findData },
        dataType: "json",
        success: function(res) {
            if (res.error_code === "0") {
                visitDataList = res.data || [];
                fnRenderVisitTable(visitDataList);
            } else {
                Swal.fire('오류', '데이터 조회 중 오류가 발생했습니다.', 'error');
            }
        },
        error: function() {
            Swal.fire('오류', '서버 통신 오류가 발생했습니다.', 'error');
        }
    });
}

function fnRenderVisitTable(dataList) {
    if (visitDataTable) {
        visitDataTable.destroy();
        $('#visitAsqTable').empty();
        visitDataTable = null;
    }

    var columns = [
        { title: "No",       data: "seq",       className: "dt-center", width: "50px" },
        { title: "기관명",    data: "hospNm",    className: "dt-center", width: "140px" },
        { title: "종별",      data: "jongNm",    className: "dt-center", width: "80px" },
        { title: "병상",      data: "bedCnt",    className: "dt-center", width: "50px" },
        { title: "컨설팅분야", data: null,        className: "dt-center", width: "200px",
          render: function(data, type, row) {
              var arr = [];
              if (row.consultGb1 === 'Y') arr.push('진료비분석');
              if (row.consultGb2 === 'Y') arr.push('적정성평가');
              if (row.consultGb3 === 'Y') arr.push('재청구분석');
              if (row.consultGb4 === 'Y') arr.push('인증컨설팅');
              if (row.consultGb5 === 'Y') arr.push('현지조사');
              return arr.join(', ');
          }
        },
        { title: "신청자",    data: "userNm",    className: "dt-center", width: "70px" },
        { title: "직위",      data: "userPosi",  className: "dt-center", width: "70px" },
        { title: "연락처",    data: "userPhone", className: "dt-center", width: "110px" },
        { title: "확인",      data: "comformYn", className: "dt-center", width: "50px",
          render: function(data) {
              return data === 'Y'
                  ? '<span class="comform-y"><i class="fas fa-check-circle"></i> Y</span>'
                  : '<span class="comform-n"><i class="fas fa-times-circle"></i> N</span>';
          }
        },
        { title: "등록일시",  data: "regDttm",   className: "dt-center", width: "130px",
          render: function(data) { return (data || '').substring(0, 16); }
        }
    ];

    visitDataTable = $('#visitAsqTable').DataTable({
        data: dataList,
        columns: columns,
        paging: true,
        pageLength: 30,
        lengthMenu: [[15, 30, 50, -1], [15, 30, 50, "전체"]],
        searching: false,
        info: true,
        ordering: true,
        order: [[0, 'desc']],
        scrollX: true,
        scrollY: "calc(100vh - 340px)",
        scrollCollapse: true,
        autoWidth: false,
        language: {
            emptyTable: "등록된 문의가 없습니다.",
            info: "현재 _START_ - _END_ / 총 _TOTAL_건",
            infoEmpty: "0건",
            lengthMenu: "_MENU_ &nbsp;",
            paginate: { first: "«", previous: "이전", next: "다음", last: "»" }
        },
        dom: '<"row"<"col-sm-6"l><"col-sm-6">>rt<"row"<"col-sm-5"i><"col-sm-7"p>>'
    });

    // 행 클릭 이벤트
    $('#visitAsqTable tbody').off('click', 'tr').on('click', 'tr', function() {
        var data = visitDataTable.row(this).data();
        if (data) {
            // 선택 행 표시
            $('#visitAsqTable tbody tr').removeClass('selected');
            $(this).addClass('selected');
            fnVisitDetail(data.seq);
        }
    });
}

function fnVisitDetail(seq) {
    selectedVisitSeq = seq;
    var row = null;
    for (var i = 0; i < visitDataList.length; i++) {
        if (visitDataList[i].seq === seq) {
            row = visitDataList[i];
            break;
        }
    }
    if (!row) return;

    function gbBadge(val, label) {
        return val === 'Y'
            ? '<span style="display:inline-flex; align-items:center; gap:4px; margin:3px 8px 3px 0; font-size:13px; color:#1a73e8; font-weight:600;"><i class="fas fa-check-square" style="color:#1a73e8;"></i> ' + label + '</span>'
            : '<span style="display:inline-flex; align-items:center; gap:4px; margin:3px 8px 3px 0; font-size:13px; color:#aaa;"><i class="far fa-square" style="color:#ccc;"></i> ' + label + '</span>';
    }

    $('#dtl_hospNm').text(row.hospNm || '-');
    $('#dtl_jongNm').text(row.jongNm || '-');
    $('#dtl_bedCnt').text(row.bedCnt || '-');

    var gbHtml = '';
    gbHtml += gbBadge(row.consultGb1, '진료비분석');
    gbHtml += gbBadge(row.consultGb2, '적정성평가');
    gbHtml += gbBadge(row.consultGb3, '재청구분석');
    gbHtml += gbBadge(row.consultGb4, '인증컨설팅');
    gbHtml += gbBadge(row.consultGb5, '현지조사컨설팅');
    $('#dtl_consultGb').html(gbHtml);

    if (row.consultGita1) {
        $('#dtl_gitaArea').show();
        $('#dtl_consultGita1').text(row.consultGita1);
    } else {
        $('#dtl_gitaArea').hide();
    }

    $('#dtl_userNm').text(row.userNm || '-');
    $('#dtl_userPosi').text(row.userPosi || '-');
    $('#dtl_userPhone').text(row.userPhone || '-');
    $('#dtl_accpetYn').html(row.accpetYn === 'Y' ? '<span style="color:green; font-weight:600;">동의</span>' : '미동의');
    $('#dtl_comformYn').html(row.comformYn === 'Y' ? '<span class="comform-y">확인완료</span>' : '<span class="comform-n">미확인</span>');
    $('#dtl_regDttm').text(row.regDttm || '-');

    // 버튼 표시 제어
    if (row.comformYn === 'Y') {
        $('#btnComformY').hide();
        $('#btnComformN').show();
    } else {
        $('#btnComformY').show();
        $('#btnComformN').hide();
    }

    $('#visitDetailModal').modal('show');
}

function fnComformSave(yn) {
    if (selectedVisitSeq <= 0) return;

    var msg = (yn === 'Y') ? '확인완료 처리하시겠습니까?' : '미확인으로 변경하시겠습니까?';
    Swal.fire({
        title: '확인',
        text: msg,
        icon: 'question',
        showCancelButton: true,
        confirmButtonText: '예',
        cancelButtonText: '아니오'
    }).then(function(result) {
        if (result.isConfirmed) {
            $.ajax({
                type: "POST",
                url: "/mangr/visitAsqComform.do",
                data: { seq: selectedVisitSeq, comformYn: yn },
                dataType: "json",
                success: function(res) {
                    if (res.error_code === "0") {
                        Swal.fire('완료', '저장되었습니다.', 'success');
                        $('#visitDetailModal').modal('hide');
                        fnVisitSearch();
                    } else {
                        Swal.fire('오류', '저장 중 오류가 발생했습니다.', 'error');
                    }
                },
                error: function() {
                    Swal.fire('오류', '서버 통신 오류가 발생했습니다.', 'error');
                }
            });
        }
    });
}
</script>
