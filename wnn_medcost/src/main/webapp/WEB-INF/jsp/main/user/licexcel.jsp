<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>  
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="decorator" uri="http://www.opensymphony.com/sitemesh/decorator" %>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/page" prefix="page" %>
<%@ page import ="java.util.Date" %>
<link href="/css/winmc/style_comm.css?v=126"  rel="stylesheet">

<style>
	#excelPreview {
	  width: 100%;
	  min-height: 600px;   /* ← 최소 높이 확보 */
	  max-height: none;    /* ← 최대 높이 해제 */
	  overflow-y: auto; 
 	}
	
	#excelTable {
	  width: 100% !important;
	  min-width: 1200px;
	  table-layout: auto;
	}
	
	#excelPreview th {
	  position: sticky;
	  top: 0;
	  background: #f9f9f9;
	  z-index: 1;
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
		      <div class="col-12">
		        <div class="card shadow-sm rounded-3">
		          <div class="card-body">
		            <!-- 병원코드 -->
		            <div class="form-row mb-3 align-items-center" style="margin-left: 10px;">
		              <label for="hospCd" class="col-1 col-lg-1 col-form-label d-flex justify-content-center align-items-center">
						  요양기관기호
					  </label>
		              <div class="col-1 ml-1" style="width: 20%;">
		                <input id="hospCd1" name="hospCd1" type="text" readonly class="form-control is-invalid">
		              </div>
                      <span style= "margin-top: 5px; margin-left: 10px; font-size: 15px;  display: inline-block;">
							    인력신고현황 엑셀자료 업로드
					  </span>
		            </div>
		
		            <!-- 엑셀 업로드 및 버튼 -->
		            <div class="upload-container p-3 border rounded bg-light">
						<div class="d-flex justify-content-between align-items-center flex-wrap mb-3">
						  <form id="excelForm" action="/uploadExcel" method="post" enctype="multipart/form-data" class="d-flex align-items-center">
						    <input 
						      type="file"  name="excelFile"  id="excelFile" class="form-control-file mr-2" 
						      style="width: 450px; padding: 6px 12px; margin-right: 10px;"
						    />
							<button type="submit" class="btn btn-success btn-sm" style="margin-right: 10px; height: 34px;">엑셀미리보기</button>
							<button type="button" id="saveDataBtn" class="btn btn-primary btn-sm d-none" style="height: 38px;">자료저장</button>
							<span style="color: red; margin-top: 5px; margin-left: 10px; display: inline-block;">
							    해당 요양기관 정보가 맞는지 확인하고 진행하세요!
							</span>
						  </form>
						</div>
		
		              <!-- 엑셀 미리보기 -->
					<style>
					  #excelPreview {
					    height: 300px; /* 기본 높이 설정 */
					    overflow-y: auto; /* 내용이 넘치면 세로 스크롤 표시 */
					    border: 1px solid #ddd; /* 테두리 추가 (선택사항) */
					    padding: 10px; /* 안쪽 여백 (선택사항) */
					  }
					</style>
		              <div id="excelPreview">
		                <table id="excelTable" class="table table-bordered table-hover table-sm">
		                  <!-- 동적 데이터 삽입 예정 -->
		                </table>
		              </div>
		            </div>
		          </div>
		        </div>
		      </div>
		    </div>                
		  </div>
		</div>
  
		<!-- ============================================================== -->
        <!-- modal form start -->
		        <!-- ============================================================== -->
		<div class="modal fade" id="modalName" tabindex="-1"
			data-backdrop="static" role="dialog" aria-hidden="false"
			data-keyboard="false">
			<div class="modal-dialog modal-dialog-centered modal-dialog-scrollable"
				role="dialog"
				style="position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); width: 50vw; max-width: 50vw; max-height: 50vh;">
				<div class="modal-content"
					style="height: 60%; display: flex; flex-direction: column;">
					<div class="modal-header bg-light">
						<h6 class="modal-title" id="modalHead"></h6>
									
						<!-- ============================================================== -->
						<!-- end button -->
						<!-- ============================================================== -->
					</div>  
					<div class="modal-body"
						style="text-align: left; flex: 1; overflow-y: auto;">
						<!-- ================================================================== -->
						<div id="inputZone">
							<!-- ============================================================== -->
							<!-- text input 1개 start -->
							<!-- ============================================================== -->
							<div class="form-group row ">
								<label for="hospCd" class="col-2 col-lg-2 col-form-label text-left">요양기관</label>
								<div class="col-4 col-lg-4">
                                   <div class="input-group">								
								 	<input id="hospCd" name="hospCd" type="text"
					    				class="form-control text-left" placeholder="요양기관를 등록하세요">
										<button id = "hospserch"    class="btn btn-outline-info" "><i class="fas fa-search">검색</i>
										</button>
								   </div>	
								</div>	
							</div>
						</div>
						<div class="modal-footer"></div>
					</div>
				</div>
			</div>
		</div>
		<!-- 모달이 로드될 영역 -->
       <div id="modalContainer"></div>

		<script type="text/javascript">
		
    	var findTxtln  = 0;    // 조회조건시 글자수 제한 / 0이면 제한 없음
		var firstflag  = false; // 첫음부터 Find하시려면 false를 주면됨
		var findValues = [];
		// 조회조건이 있으면 설정하면됨 / 조건 없으면 막으면 됨
		// 글자수조건 있는건 1개만 설정가능 chk: true 아니면 모두 flase
		// 조회조건은 필요한 만큼 추가사용 하면됨.
		findValues.push({ id: "findData", val: "",  chk: true  });
        //병원병원에서 접속시 요양기관 값셋팅
	    let s_hospcd = getCookie("s_hospid") ;
	    let s_wnn_yn = getCookie("s_wnn_yn") ;
	    let s_hosp_uuid = getCookie("s_hosp_uuid");
	  //원너넷이 아니거나 워너넷에서 병원을 선택해서 처리한 경우)
	    if ( (s_hospcd &&  s_wnn_yn != 'Y') || (s_hospcd != s_hosp_uuid) )   { 
	        findValues.push({ id: "hospCd1", val: s_hospcd,  chk: false  });
            $("#hospCd1").val(s_hospcd);
	    }else{
	        findValues.push({ id: "hospCd1", val:"",  chk: false  });
            $("#hospCd1").val("");	    	
	    }
		
		// 초기값 설정
		var mainFocus = 'findData'; // Main 화면 focus값 설정, Modal은 따로 Focus 맞춤
		var edit_Data = null;
		var dataTable = new DataTable();
		dataTable.clear();

		var s_CheckBox = true;   		           	 // CheckBox 표시 여부
        var s_AutoNums = true;   		             // 자동순번 표시 여부
		var markColums = [];
		var mousePoint = 'pointer';                				 // row 선택시 Mouse모양
		<!-- ============================================================== -->
		<!-- Table Setting End -->
		<!-- ============================================================== -->
		</script>
		<script type="text/javascript">
	
		// 병원검색 /js/winmc/schcommons.js///////////////
		$("#hospserch").on("click", function () {
		    openHospitalSearch(function (data) {
		        $("#hospCd").val(data.hospCd);
		    });
		});
		
		function openHospitalSearch(callback) {
		    openCommonSearch("hospital", function (data) {
		        console.log("받은 병원 데이터:", data);

		        // ✅ 데이터가 올바른지 검증 후 실행
		        if (data && data.hospCd) {
		            callback(data);
		        } else {
		            console.warn("🚨 유효하지 않은 병원 데이터:", data);
		            alert("선택한 병원의 정보가 올바르지 않습니다. 다시 시도해주세요.");
		        }
		    });
		}
         ///////////////////////////////////////////////////////////
		let currentHospid = sessionStorage.getItem('hospid'); // 최초 병원 ID 저장

		setInterval(function () {
		    let newHospid = sessionStorage.getItem('hospid');
		    if (newHospid && newHospid !== currentHospid) {
		        console.log("병원이 변경됨: " + newHospid);
		        currentHospid = newHospid; // 변경된 ID로 갱신
		      //병원병원에서 접속시 요양기관 값셋팅
			    let s_hospcd = getCookie("s_hospid") ;
				findValues.push({ id: "hospCd1", val: s_hospcd,  chk: false  });
				$("#hospCd1").val(s_hospcd);
				triggerFind();
		    }
		}, 1000); // 1초마다 체크 (너무 짧으면 3000ms로 늘려도 됨)
		// 강제로 실행하고 싶을 때 사용할 함수
		function triggerFind() {
		    fn_FindData();
		}		
		//권한조건체크 applyAuthControl.js
	    document.addEventListener("DOMContentLoaded", function() {
	        applyAuthControl();
	    });
	 // ✅ 전역 변수 추가 (미리보기 데이터 저장용)
	    let previewData = [];

	    // ✅ 엑셀 미리보기 처리
		document.getElementById("excelForm").addEventListener("submit", function (e) {
		  e.preventDefault();
		
		  const fileInput = document.getElementById("excelFile");
		  if (!fileInput.files || fileInput.files.length === 0) {
		    alert("파일을 선택해주세요.");
		    document.getElementById("excelPreview").innerHTML = "";
		    return;
		  }
		
		  // ✅ 클래스 제거 방식으로 변경
		  document.getElementById("saveDataBtn").classList.remove("d-none");
		
		  const formData = new FormData(this);
		
		  fetch("/user/previewExcel.do", {
		    method: "POST",
		    body: formData,
		  })
		    .then((res) => {
		      if (!res.ok) throw new Error("HTTP 에러: " + res.status);
		      return res.json();
		    })
		    .then((data) => {
		      document.getElementById("excelPreview").innerHTML = ""; // 기존 미리보기 삭제
		      renderTable(data); // 표 렌더링
		    })
		    .catch((e) => {
		      console.error("오류 발생:", e.message);
		      alert("서버에서 JSON을 받지 못했습니다.");
		    });
		});

	    // ✅ 테이블 렌더링 함수
		function renderTable(data) {
		  previewData = data;
		
		  const container = document.getElementById("excelPreview");
		
		  if (!Array.isArray(data) || data.length === 0) {
		    container.innerHTML = "<p>미리볼 데이터가 없습니다.</p>";
		    return;
		  }
		
		  const previewBox = document.createElement("div");
		  previewBox.style.position = "relative";
		  previewBox.style.border = "1px solid #ddd";
		  previewBox.style.padding = "10px";
		  previewBox.style.marginTop = "20px";
		  previewBox.style.backgroundColor = "#fafafa";
		
		  const closeBtn = document.createElement("span");
		  closeBtn.textContent = "×";
		  closeBtn.style.position = "absolute";
		  closeBtn.style.top = "8px";
		  closeBtn.style.right = "12px";
		  closeBtn.style.cursor = "pointer";
		  closeBtn.style.fontSize = "20px";
		  closeBtn.style.fontWeight = "bold";
		  closeBtn.style.color = "#999";
		  closeBtn.addEventListener("mouseenter", () => (closeBtn.style.color = "#ff5c5c"));
		  closeBtn.addEventListener("mouseleave", () => (closeBtn.style.color = "#999"));
		  closeBtn.addEventListener("click", () => (container.innerHTML = ""));
		  previewBox.appendChild(closeBtn);
		
		  // ✅ 테이블 스크롤 래퍼 div 추가
		  const scrollWrapper = document.createElement("div");
		  scrollWrapper.style.overflow = "auto";
		  scrollWrapper.style.maxHeight = "300px"; // 세로 스크롤
		  scrollWrapper.style.maxWidth = "100%"; // 가로 스크롤
		  scrollWrapper.style.border = "1px solid #ccc";
		
		  const table = document.createElement("table");
		  table.style.borderCollapse = "collapse";
		  table.style.width = "max-content"; // 가로 길이 강제
		  table.style.whiteSpace = "nowrap"; // 줄바꿈 방지
		
		  const thead = document.createElement("thead");
		  const headerRow = document.createElement("tr");
		  const keys = Object.keys(data[0]);
		
		  keys.forEach((key) => {
		    const th = document.createElement("th");
		    th.textContent = key;
		    th.style.border = "1px solid #999";
		    th.style.padding = "6px 12px";
		    th.style.backgroundColor = "#f2f2f2";
		    th.style.position = "sticky";
		    th.style.top = "0";
		    th.style.zIndex = "1";
		    th.style.textAlign = "center";
		    headerRow.appendChild(th);
		  });
		  thead.appendChild(headerRow);
		  table.appendChild(thead);
		
		  const tbody = document.createElement("tbody");
		  data.forEach((row) => {
		    const tr = document.createElement("tr");
		    keys.forEach((key) => {
		      const td = document.createElement("td");
		      td.textContent = row[key] ?? "";
		      td.style.border = "1px solid #ccc";
		      td.style.padding = "6px 10px";
		      td.style.textAlign = "center";
		      tr.appendChild(td);
		    });
		    tbody.appendChild(tr);
		  });
		
		  table.appendChild(tbody);
		  scrollWrapper.appendChild(table);
		  previewBox.appendChild(scrollWrapper);
		
		  container.innerHTML = "";
		  container.appendChild(previewBox);
		}

	    // ✅ 자료 저장 처리
	    document.getElementById("saveDataBtn").addEventListener("click", () => {
	      const fileInput = document.getElementById("excelFile");
	      if (!fileInput.files || fileInput.files.length === 0) {
	        alert("파일을 선택해주세요.");
	        document.getElementById("excelPreview").innerHTML = "";
	        return;
	      }

	      if (!previewData || previewData.length === 0) {
	        alert("저장할 데이터가 없습니다.");
	        return;
	      }

	      const hospCd1 = document.getElementById("hospCd1").value;
	      if (hospCd1 === "") {
	        messageBox("1", "<h6> 요양기관이 선택되어야합니다. </h6><p></p><br>", mainFocus, "", "");
	        return;
	      }

	      fetch("/user/CellsaveExcelData.do", {
	        method: "POST",
	        headers: {
	          "Content-Type": "application/json"
	        },
	        body: JSON.stringify({ hospCd: hospCd1, data: previewData })
	      })
	        .then(res => res.json())
	        .then(result => {
	          if (result.success) {
	        	  messageBox("1", "<h6> 정상적으로 자료가 생성 되었습니다. </h6><p></p><br>", mainFocus, "", "");
	        	  document.getElementById("saveDataBtn").classList.add("d-none");
	          } else {
	            alert("저장 실패: " + result.message);
	          }
	        })
	        .catch(err => {
	          alert("서버 오류 발생");
	          console.error(err);
	        });
	    });
	    document.getElementById('excelFile').addEventListener('change', function() {
	        // 파일이 선택되면 saveDataBtn을 숨깁니다.
	        document.getElementById('saveDataBtn').classList.add('d-none');
	      });  
	  </script>
		<!-- ============================================================== -->
		<!-- 기타 정보 End -->
		<!-- ============================================================== -->

		