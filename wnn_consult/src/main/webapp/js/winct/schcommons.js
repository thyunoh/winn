// ✅ 공통 검색 콜백 및 타입 변수
var commonSearchCallback;
var currentSearchType = "";
var useTestData = false; // true: 임시 데이터 사용

// ✅ 전역 변수
var colPadding = '0.2px';
var showSortNo = ['hospCd','userNm'];

// ✅ 공통 검색 모달 열기
function openCommonSearch(searchType, callback) {
    commonSearchCallback = callback;
    currentSearchType = searchType;

    if (!document.getElementById('commonSearchModal')) {
        $("body").append(`
            <div class="modal fade" id="commonSearchModal" tabindex="-1" data-bs-backdrop="static" aria-hidden="true">
                <div class="modal-dialog modal-lg modal-dialog-centered" style="max-width: 31%;">
                    <div class="modal-content shadow-lg rounded-4 border-0" style="min-height: 600px; background: white; box-shadow: 0 10px 34px rgba(0, 0, 0, 0.1);">
                        <header class="modal-header d-flex justify-content-between align-items-center p-2" style="background: #e9ecef; border-top-left-radius: 15px; border-top-right-radius: 15px;">
                            <h5 id="commonSearchTitle" class="m-0 font-weight-bold">🔍 검색</h5>
                            <button type="button" class="btn btn-outline-dark rounded px-2 py-1" data-dismiss="modal" onClick="closeCommonSearch()">닫기 <i class="fas fa-times"></i></button>
                        </header>

                        <!-- ✅ 검색 영역 -->
						<div class="container px-3 py-2">
						  <div class="row g-2">
						    <div class="col-12 col-md-10">
						      <input type="text" id="searchHospCd" class="form-control form-control-sm" placeholder="요양기관코드 입력">
						    </div>
						    <div class="col-12 col-md-2">
						      <button class="btn btn-primary w-90 btn-sm" type="button" 
						              onclick="loadCommonSearchData(currentSearchType);">
						        🔍 검색
						      </button>
						    </div>
						  </div>
						</div>

                        <!-- ✅ 테이블 영역 -->
                        <div class="modal-body p-2" style="overflow-y: auto; padding-top: 0 !important; background: white;">
                            <table id="commonSearchTable" class="display nowrap table table-hover table-bordered" style="width: 100%; border-radius: 10px; overflow: hidden; background: white;">
                                <thead class="bg-light">
                                    <tr id="commonSearchTableHead"></tr>
                                </thead>
                                <tbody></tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        `);
    }

    var searchTitle = {
        "hospital": "병원 검색",
        "user": "사용자 검색",
    };
    $("#commonSearchTitle").text(searchTitle[searchType] || "검색");

    setupCommonTable(searchType);
    // 초기 데이터 조회 제거 (버튼 클릭 시에만 실행)
    // loadCommonSearchData(searchType);

    var modalInstance = bootstrap.Modal.getOrCreateInstance(document.getElementById('commonSearchModal'));
    modalInstance.show();
}

// ✅ 공통 테이블 세팅
function setupCommonTable(searchType) {
    if ($.fn.DataTable.isDataTable("#commonSearchTable")) {
        $("#commonSearchTable").DataTable().destroy();
        $("#commonSearchTable tbody").empty();
    }

    let table = $("#commonSearchTable").DataTable({
        scrollX: true,
        scrollY: "400px",
        scrollCollapse: true,
        autoWidth: true,
        ordering: true,
        pageLength: -1,
        lengthChange: true,
        info: true,
        paging: false,
        fixedHeader: false,
        lengthMenu: [],
        searching: false,  // ✅ 자동 검색 제거
        data: [],
        columns: [
            { title: "번호", data: null, className: "text-center", width: "50px" },
            ...getTableColumns(searchType)
        ],
        rowCallback: function(row, data, index) {
            var pageInfo = table.page.info();
            var rowNumber = pageInfo.start + index + 1;
            $('td:eq(0)', row).html(rowNumber);
            $(row).find('td').css('padding', colPadding);
        },
        language: {
            search: "🔍 검색: ",
            zeroRecords: "검색된 데이터가 없습니다.",
            emptyTable: "데이터가 없습니다.",
            info: "총 _TOTAL_ 개 중 _START_ - _END_ 표시",
            infoEmpty: "데이터 없음",
            lengthMenu: "_MENU_",
            infoFiltered: "( _MAX_건의 데이터에서 필터링됨 )",
            processing: "잠시만 기다려 주세요..."
        }
    });

    // ✅ 더블 클릭 시 선택
    $("#commonSearchTable tbody").off("dblclick").on("dblclick", "tr", function () {
        var data = table.row(this).data();
        if (data && typeof commonSearchCallback === "function") {
            commonSearchCallback(data);
            closeCommonSearch();
        }
    });
}

// ✅ 데이터 로딩 (검색 버튼 클릭 시 호출)
function loadCommonSearchData(searchType) {
    var table = $("#commonSearchTable").DataTable();
    table.clear().draw();

    if (useTestData) {
        var testData = getTestData(searchType);
        table.rows.add(testData).draw();
    } else {
        var apiUrls = {
            "hospital": "/user/phospList.do",
            "user"    : "/main/com/userSearchData.do",
        };
		const hospCd = $("#searchHospCd").val().trim();
		
		if (!hospCd || hospCd.trim().length < 3) {
            messageBox("4","병원명을 세 글자 이상 입력해주세요. !!","","","");	
		    $("#searchHospCd").focus();
		    return; // 실행 중단
		}
		
        if (!searchType || !apiUrls[searchType]) return;

        $.ajax({
            type: "POST",
            url: apiUrls[searchType],
            dataType: "json",
		    data: {
		        hospCd: hospCd,
		        wnnchk: "N"
		    },
            success: function (response) {
                if (response.error_code !== "0") return;
                if (Array.isArray(response.resultLst) && response.resultLst.length > 0) {
                    table.rows.add(response.resultLst).draw();
                }
            },
            error: function (jqXHR, textStatus, errorThrown) {
                console.error("데이터 로드 실패:", textStatus);
            }
        });
    }
}

// ✅ 컬럼 정의
function getTableColumns(searchType) {
    return {
        "hospital": [
            { title: "요양기관", data: "hospCd", className: "text-center" },
            { title: "병원명칭", data: "hospNm", className: "text-left" },
            { title: "주소", data: "hospAddr", className: "text-left" }
        ],
        "user": [
            { title: "사용자아이디", data: "userId", className: "text-center" },
            { title: "성명", data: "userNm", className: "text-left" },
            { title: "요양기관", data: "hospCd", className: "text-center" },
            { title: "병원명칭", data: "hospNm", className: "text-left" }
        ]
    }[searchType] || [];
}

// ✅ 테스트 데이터
function getTestData(searchType) {
    return {
        "hospital": [ { hospCd: "123456", hospNm: "서울병원", hospAddr: "서울 강남" } ],
        "user": [ { userId: "user01", userNm: "홍길동", hospCd: "123456", hospNm: "서울병원" } ]
    }[searchType] || [];
}

// ✅ 모달 닫기
function closeCommonSearch() {
    const modalInstance = bootstrap.Modal.getOrCreateInstance(document.getElementById('commonSearchModal'));
    modalInstance.hide();
}
