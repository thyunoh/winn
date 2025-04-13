var commonSearchCallback;
var currentSearchType = "";
var useTestData = false;  // true: 임시 데이터 사용, false: 실제 API 사용

var colPadding = '0.2px' ;
var searchShow = true; 
var data_Count = [[20, 30, 50, 100, -1], [20, 30, 50, 100, "All"]]
var showSortNo = ['hospCd','userNm']; 
function openCommonSearch(searchType, callback) {
    commonSearchCallback = callback;  // ✅ 콜백 함수 저장
    currentSearchType = searchType;  // ✅ 현재 검색 타입 저장

	if (!document.getElementById('commonSearchModal')) {
	    $("body").append(`
	        <div class="modal fade" id="commonSearchModal" tabindex="-1" data-bs-backdrop="static" aria-hidden="true">
	            <div class="modal-dialog modal-lg modal-dialog-centered" style="max-width: 40%;"> 
	                <div class="modal-content shadow-lg rounded-4 border-0" 
	                     style="min-height: 300px; background: white; box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);">
	                    
	                    <header class="modal-header d-flex justify-content-between align-items-center p-2" 
	                            style="background: #e9ecef; border-top-left-radius: 15px; border-top-right-radius: 15px; 
	                                   margin-bottom: 0 !important; padding-bottom: 0 !important;">
	                        <h5 id="commonSearchTitle" class="m-0 font-weight-bold">🔍 검색</h5>
	                        <button type="button" class="btn btn-outline-dark"
	                            data-dismiss="modal" onClick="closeCommonSearch()">  
	                            닫기 <i class="fas fa-times"></i>
	                        </button>
	                    </header>
	
	                    <div class="modal-body p-2" style="overflow-y: auto; padding-top: 0 !important; background: white;">
	                        <table id="commonSearchTable" class="display nowrap table table-hover table-bordered"
	                               style="width: 100%; border-radius: 10px; overflow: hidden; background: white;">
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
    // ✅ 검색 제목 변경
    var searchTitle = {
        "hospital": "병원 검색",
        "user": "사용자 검색",
    };
    $("#commonSearchTitle").text(searchTitle[searchType] || "검색");

    // ✅ 검색 테이블 컬럼 동적 생성
    setupCommonTable(searchType);

    // ✅ 데이터 로드 (임시 데이터 or 실제 데이터)
    loadCommonSearchData(searchType);

    // ✅ 모달 표시
    var modalInstance = bootstrap.Modal.getOrCreateInstance(document.getElementById('commonSearchModal'));
    modalInstance.show();
}

function setupCommonTable(searchType) {
    // ✅ 테이블을 먼저 숨김 (변경 과정이 사용자에게 보이지 않도록 설정)
    $("#commonSearchTable_wrapper").css("visibility", "hidden");

    // ✅ 기존 DataTable 제거 후 재초기화
    if ($.fn.DataTable.isDataTable("#commonSearchTable")) {
        $("#commonSearchTable").DataTable().destroy();
        $("#commonSearchTable tbody").empty();
    }

    let table = $("#commonSearchTable").DataTable({
        scrollX: true,
        scrollY: "300px",
        scrollCollapse: true, // ✅ 내용이 적을 때도 높이 유지
        autoWidth: false,
        ordering: true,
        pageLength: 20,
        lengthChange: true,
        info: true,
        paging: true,
        fixedHeader: false, // ✅ DataTables 기본 fixedHeader 사용 안 함
        lengthMenu: [[20, 30, 50, 100, -1], [20, 30, 50, 100, "All"]],
        searching: true ,
        search: {
            return: false,  // 검색창 바로바로 찾기(false) / Enter 후 찾기(true)
        },

        data: [],

        // ✅ 컬럼 설정 (여기서 title을 직접 정의)
        columns: [
            { title: "번호", data: null, className: "text-center", width: "50px" },  // ✅ 순번 컬럼
            ...getTableColumns(searchType)  // ✅ 검색 타입별 컬럼 추가
        ],

       rowCallback: function(row, data, index) {
            var pageInfo = table.page.info();
            var rowNumber = pageInfo.start + index + 1; // 시작 인덱스 + 현재 행 인덱스 + 1
            $('td:eq(0)', row).html(rowNumber);
            $(row).find('td').css('padding', colPadding);
        },

        language: {
            search: "🔍 검색: ",
            loadingRecords: "데이터 불러오는 중...",
            zeroRecords: "검색된 데이터가 없습니다.",
            info: "총 _TOTAL_ 개 중 _START_ - _END_ 표시",
            infoEmpty: "데이터 없음",
            lengthMenu: "_MENU_",
            infoFiltered: "( _MAX_건의 데이터에서 필터링됨 )",
            processing: "잠시만 기다려 주세요...",
            paginate: { next: "다음", previous: "이전" }
        }
    });

    // ✅ ✅ ✅ 해결 방법: 컬럼 조정 후 테이블 표시 (변경 과정 감춤)
    setTimeout(function () {
        table.columns.adjust().draw(); // ✅ 컬럼 너비 재조정 후 다시 그리기
        $("#commonSearchTable_wrapper").css("visibility", "visible"); // ✅ 테이블 표시
    }, 300);

    // ✅ 검색 항목 선택 이벤트
    $("#commonSearchTable tbody").off("dblclick").on("dblclick", "tr", function () {
        var data = table.row(this).data();
        if (data) {
            console.log("✅ 선택된 데이터:", data);
            if (typeof commonSearchCallback === "function") {
                commonSearchCallback(data);
            }
            closeCommonSearch();
        }
    });

    // ✅ 행을 클릭했을 때 배경색 변경
    $("#commonSearchTable tbody").off("click").on("click", "tr", function () {
        $("#commonSearchTable tbody tr").removeClass("selected");
        $(this).addClass("selected");
    });

    // ✅ 스타일 직접 추가
    const style = document.createElement("style");
    style.innerHTML = `
        /* ✅ 특정 테이블(#commonSearchTable)에만 스타일 적용 */
        #commonSearchTable tbody tr.selected {
            background-color: #d6eaf8 !important; /* 선택한 행 배경색 */
            color: #000 !important; /* 선택한 행 글자색 */
        }
	    
	    /* ✅ 테이블 헤더가 스크롤 시 고정되도록 설정 */
	    #commonSearchTable thead {
	        position: sticky;
	        top: 0;
	        z-index: 2;
	        background-color: #e8f4f7 !important; /* ✅ 헤더 배경색 */
	    }
		/* 타이틀에 연한 하늘색 배경색 적용 */
		#commonSearchTable th {
		    background-color: #e0f7fa; /* 연한 하늘색 */
		    color: #000; /* 텍스트 색상 */
		    font-weight: bold; /* 글씨 두껍게 */
            min-width: 100px !important;
		}

        /* ✅ 전체 테이블 크기를 조정하여 UI 최적화 */
        #commonSearchTable {
            font-size: 13px !important; /* ✅ 테이블 내 글씨 크기 조정 */
            width: 100% !important;
            table-layout: fixed !important;  /* ✅ 고정 레이아웃 설정 */
            margin-top: 10px; /* 상단 간격 */
       }
       /*맨앞에 번호 사이즈조정
		#commonSearchTable th:nth-child(1),
		#commonSearchTable td:nth-child(1) {
		    width: 30px !important;  /* ✅ 원하는 크기로 강제 조정 */
		    min-width: 30px !important;
		    max-width: 30px !important;
		    text-align: center;
		    white-space: nowrap !important;  /* ✅ 줄바꿈 방지 */
		    overflow: hidden;
		    text-overflow: ellipsis; /* 글자가 넘치면 ... 처리 */
		}
    `;
    document.head.appendChild(style);
}
// ✅ 검색 데이터 로드 (임시 데이터 or 실제 데이터)
function loadCommonSearchData(searchType) {
    var table = $("#commonSearchTable").DataTable();
    table.clear().draw();  // ✅ 기존 데이터 초기화

    if (useTestData) {
        // ✅ 임시 데이터 사용
        var testData = getTestData(searchType);
        console.log("⚡️ [테스트 모드] 임시 데이터 사용:", testData);
        table.rows.add(testData).draw();
    } else {
        // ✅ 실제 API 호출
        var apiUrls = {
            "hospital": "/user/phospList.do",
            "user"    : "/main/com/userSearchData.do",
        };
	if (!searchType || !apiUrls[searchType]) {
	    console.error("🚨 searchType이 유효하지 않습니다:", searchType);
	} else {
		console.log("✅ API 요청 URL:", apiUrls[searchType]);
		$.ajax({
		    type: "POST",
		    url: apiUrls[searchType],
		    contentType: "application/json",
		    dataType: "json",  
		    data: JSON.stringify({ wnnchk: "N" }),  // ✅ DTO 필드를 JSON 형식으로 변환
		    success: function (response) {
 	        if (response.error_code !== "0") {
		            console.error("🚨 서버 오류:", response.error_code);
		            return;
		        }
		        if (Array.isArray(response.resultLst) && response.resultLst.length > 0) {
		            var table = $("#commonSearchTable").DataTable();
		            table.clear();
		            table.rows.add(response.resultLst).draw();
		        } else {
		            console.warn("⚠️ 데이터가 존재하지 않습니다.");
		        }
		    },
		    error: function (jqXHR, textStatus, errorThrown) {
		        console.error("🚨 데이터 로드 실패:", textStatus, errorThrown);
		    }
		});
      }
    }
}
// ✅ 검색 타입별 컬럼 설정
function getTableColumns(searchType) {
    var columns = {
        "hospital": [
            { title: "요양기관"  , data: "hospCd"   , className: "text-center" , width: '100px',},
            { title: "병원명칭"  , data: "hospNm"   , className: "text-left"   , width: '200px', },
            { title: "주소"     , data: "hospAddr" , className: "text-left"   , width: '300px', },
        ],
        "user": [
            { title: "사용자아이디" , data: "userId", className: "text-center" , width: '100px',},
            { title: "성명"       , data: "userNm", className: "text-left"   , width: '100px',},
            { title: "요양기관"    , data: "hospCd", className: "text-center" , width: '100px',},
            { title: "병원명칭"    , data: "hospNm", className: "text-left"   , width: '300px',},
        ]
    };
    return columns[searchType] || [];
}

// ✅ 테스트 데이터 생성
function getTestData(searchType) {
    var testData = {
        "hospital": [
            { hospCd: "123456", hospNm: "서울병원" , hospAddr: "서울특별시 강남구 테헤란로 123" }
        ],
        "user": [
            { userId: "user01", userNm: "홍길동", hospCd: "123456"   ,hospNm: "서울병원" }
        ] 
    };
    return testData[searchType] || [];
}

// ✅ 공통 검색 모달 닫기
function closeCommonSearch() {
    var modalInstance = bootstrap.Modal.getOrCreateInstance(document.getElementById('commonSearchModal'));
    modalInstance.hide();
}
function replaceDynamicLabels() {
    $("label").each(function() {
        let forValue = $(this).attr("for");
        
        // `for` 속성이 `dt-search-` 또는 `dt-length-`로 시작하는 경우 변경
        if (forValue && (forValue.startsWith("dt-search-") || forValue.startsWith("dt-length-"))) {
            let $span = $("<span>").html($(this).html()).attr("id", forValue);
            $(this).replaceWith($span);
        }
    });
}

$(document).ready(function() {
    // ✅ DataTable이 초기화될 때 실행
    $('#commonSearchTable').on('init.dt', function() {
        setTimeout(replaceDynamicLabels, 100);
    });

    // ✅ DataTable이 다시 그려질 때 실행
    $('#commonSearchTable').on('draw.dt', function() {
        replaceDynamicLabels();
    });

    // ✅ 새로운 요소가 추가될 때 자동 감지
    const observer = new MutationObserver(function(mutationsList) {
        for (let mutation of mutationsList) {
            if (mutation.type === "childList") {
                replaceDynamicLabels();
            }
        }
    });

    // ✅ 문서 전체의 변화를 감지하여 실행
    observer.observe(document.body, {
        childList: true,
        subtree: true
    });

    // ✅ DOM이 변경될 때마다 실행 (예비 대비)
    document.addEventListener("DOMNodeInserted", function() {
        replaceDynamicLabels();
    });
});


