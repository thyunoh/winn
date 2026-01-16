<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>  
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="decorator" uri="http://www.opensymphony.com/sitemesh/decorator" %>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/page" prefix="page" %>
<%@ page import ="java.util.Date" %>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>기간별 건수와 진료비 추이</title>
  <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js"></script>
  <link href="/css/winmc/style_comm.css?v=123" rel="stylesheet">
  <style>
  </style>
</head>
<body>


  <div class="container_tong">
    <h4>기간별 건수와 진료비 추이</h4>

    <!-- 검색 조건 -->
    <div class="filter-box">
		<span for="startMonth">시작년월</span>
		<input type="month" id="startMonth" value="2025-01" 
		       style="width: 120px; font-size: 13px; padding: 4px; text-align: center;">
		<span>~</span>
		<span for="endMonth">종료년월</span>
		<input type="month" id="endMonth" value="2025-03" 
		       style="width: 120px; font-size: 13px; padding: 4px; text-align: center;">
 	   <span for="medType">진료</span>
	   <div style="width: 80px;">
			<select class="custom-select" id="medType" style= "font-size:14px ;">
			    <option value="1" selected>의과</option>
			    <option value="2">치과</option>
			    <option value="3">한방</option>
			    <option value="0">전체</option>
		    </select>      
	    </div>
 	   <span for="jrType">행위</span>
	   <div style="width: 80px;">
			<select class="custom-select" id="jrType" style= "font-size:14px ;">
			    <option value="0" selected>전체</option>
			    <option value="1">정액</option>
			    <option value="2">행위</option>
		    </select>      
	    </div>
	   <span for="amtType">금액</span>
 	   <div style="width: 90px;">
			<select class="custom-select" id="amtType" style= "font-size:14px ;">
			    <option value="2" selected>청구액</option>
			    <option value="1">총액</option>
		    </select>      
	    </div>
		<!-- 검색 버튼 -->
		
		<button id="serBtn" class="btn btn-outline-primary text-black btn-sm" onclick="filterData()">
		  <i class="fas fa-search"></i> 검색
		</button>
		<button id="pdfBtn" class="btn btn-outline-primary text-black btn-sm" onclick="downloadPDF()">
		  <i class="fas fa-file-pdf"></i> PDF출력
		</button>
		
    </div>
	<div id="loadingSpinner" style="display:none; text-align:center; margin-top:5px;">
	  <img src="/images/winct/loading.gif" alt="로딩 이미지 테스트">
	</div> 
    <!-- 차트 영역 -->
    <div class="chart-box">
      <canvas id="costChart"></canvas>
    </div>

    <!-- 표 영역 -->
    <table id="dataTable">
      <thead>
        <tr>
          <th rowspan="2">기간</th>
          <th colspan="3">전체</th>
          <th colspan="3">입원</th>
          <th colspan="3">외래</th>
        </tr>
        <tr>
          <th>건수</th><th>청구액</th><th>건당 진료비</th>
          <th>건수</th><th>청구액</th><th>건당 진료비</th>
          <th>건수</th><th>청구액</th><th>건당 진료비</th>
        </tr>
      </thead>
      <tbody id="tableBody"></tbody>
    </table>
  </div>
</body>
</html>


<script>
  let chart;

  function numberWithCommas(x) {
    return x?.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",") || "0";
  }

  function filterData() {
	  const start     = document.getElementById('startMonth').value;
	  const end       = document.getElementById('endMonth').value;
	  const medType   = document.getElementById('medType').value;
	  const jrType    = document.getElementById('jrType').value;
	  const amtType   = document.getElementById('amtType').value;
	  if (!start || !end) {
	    alert("시작월과 종료월을 모두 선택해주세요.");
	    return;
	  }
	  const formattedStart = start.replaceAll("-", "");
	  const formattedEnd   = end.replaceAll("-", "");

	  console.log(formattedStart); // 202501
	  console.log(formattedEnd);   // 202502
	  let s_hospid = getCookie("s_hospid") ;
	  $("#loadingSpinner").show(); // 로딩 표시
	  $.ajax({
		type: 'post',
		url: '/tong/t_tong00List.do',
		data: { hospCd : s_hospid , startMonth: formattedStart, endMonth: formattedEnd  
			  , medType : medType , jrType : jrType , amtType : amtType },
	    dataType: "json",
	    success: function(data) {
	      const labels = [];  
	      const costs = [];
	      const counts = [];
	      const tableData = [];

	      data.forEach(item => {
	        labels.push(item.dateYm);
	        costs.push(parseInt(item.totalAmt / 1000000)); //백만원가준  
	        counts.push(parseInt(item.totalCount / 1000)); //천건기준 

	        const row = [
	          item.dateYm,
	          numberWithCommas(item.totalCount),
	          numberWithCommas(item.totalAmt),
	          numberWithCommas(item.totalAvgAmt),
	          numberWithCommas(item.ipCount),
	          numberWithCommas(item.ipAmt),
	          numberWithCommas(item.ipAvgAmt),
	          numberWithCommas(item.opCount),
	          numberWithCommas(item.opAmt),
	          numberWithCommas(item.opAvgAmt)
	        ];
	        tableData.push({ row });
	      });

	      renderChart(labels, costs, counts);
	      renderTable(tableData);
	    },
	    error: function(xhr, status, error) {
	      console.error("에러 발생:", error);
	      alert("데이터를 가져오는 데 실패했습니다.");
	    },
	    complete: function() {
	       $("#loadingSpinner").hide(); // 작업 완료 후 로딩 숨김
	    }
	  });
	}

  function renderChart(labels, costs, counts) {
    const ctx = document.getElementById('costChart').getContext('2d');
    if (chart) chart.destroy();
    chart = new Chart(ctx, {
      type: 'bar',
      data: {
        labels: labels,
        datasets: [
          {
            type: 'bar',
            label: '진료비 (백만원)',
            data: costs,
            yAxisID: 'y',
            backgroundColor: 'rgba(135, 206, 250, 0.7)'
          },
          {
            type: 'line',
            label: '건수 (천건)',
            data: counts,
            yAxisID: 'y1',
            borderColor: 'blue',
            backgroundColor: 'blue',
            tension: 0.3
          }
        ]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        interaction: { mode: 'index', intersect: false },
        stacked: false,
        scales: {
          y: {
            type: 'linear',
            position: 'left',
            title: { display: true, text: '진료비(백만원)' }
          },
          y1: {
            type: 'linear',
            position: 'right',
            title: { display: true, text: '건수(천건)' },
            grid: { drawOnChartArea: false }
          }
        }
      }
    });
  }

  function renderTable(data) {
    const tbody = document.getElementById('tableBody');
    tbody.innerHTML = '';
    data.forEach(rowData => {
      const tr = document.createElement('tr');
      rowData.row.forEach(cell => {
        const td = document.createElement('td');
        td.textContent = cell;
        tr.appendChild(td);
      });
      tbody.appendChild(tr);
    });
  }

  function downloadPDF() {
    const pdfBtn = document.getElementById('pdfBtn');
    const serBtn = document.getElementById('serBtn');
    const element = document.querySelector(".container_tong");

    pdfBtn.style.display = 'none';
    serBtn.style.display = 'none';
    element.style.transform = "scale(1.0)";
    element.style.transformOrigin = "top left";

    const opt = {
      margin: 0,
      filename: '진료비_통계.pdf',
      image: { type: 'jpeg', quality: 1 },
      html2canvas: { scale: 3, useCORS: true },
      jsPDF: { unit: 'mm', format: 'a4', orientation: 'portrait' }
    };

    html2pdf().set(opt).from(element).save().then(() => {
      element.style.transform = "";
      pdfBtn.style.display = 'inline-block';
      serBtn.style.display = 'inline-block';
    });
  }
</script>

