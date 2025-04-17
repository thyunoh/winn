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
  <style>
	* {
	  box-sizing: border-box;
	  font-family: 'Noto Sans KR', 'Segoe UI', sans-serif;
	}
	body {
	  margin: 0;
	  background-color: #f8fafc;
	  color: #1e293b;
	}
	.container {
	  max-width: 1200px;
	  margin: 40px auto;
	  padding: 40px;
	  background: linear-gradient(to bottom right, #ffffff, #f1f5f9);
	  border-radius: 1.5rem;
	  box-shadow: 0 12px 28px rgba(0, 0, 0, 0.08);
	}
	h4 {
	  font-size: 1.75rem;
	  font-weight: 700;
	  color: #0f172a;
	  margin-bottom: 2rem;
	  border-left: 6px solid #3b82f6;
	  padding-left: 1rem;
	}
	.filter-box {
	  display: flex;
	  flex-wrap: wrap;
	  gap: 1rem;
	  margin-bottom: 2rem;
	  align-items: center;
	}
	.filter-box span {
	  font-weight: 500;
	  font-size: 0.95rem;
	}
	input[type="month"],
	select {
	  padding: 0.6rem 0.9rem;
	  font-size: 0.9rem;
	  border: 1px solid #cbd5e1;
	  border-radius: 0.75rem;
	  background-color: #fff;
	}
	button {
	  display: flex;
	  align-items: center;
	  gap: 6px;
	  padding: 0.65rem 1.2rem;
	  background-color: #3b82f6;
	  border: none;
	  border-radius: 0.75rem;
	  color: white;
	  font-size: 0.95rem;
	  font-weight: 600;
	  cursor: pointer;
	  transition: background 0.3s ease, transform 0.2s ease;
	}
	button:hover {
	  background-color: #2563eb;
	  transform: translateY(-2px);
	  box-shadow: 0 6px 12px rgba(59, 130, 246, 0.2);
	}
	.chart-box {
	  margin-bottom: 2rem;
	  background: #f1f5f9;
	  padding: 1.5rem;
	  border-radius: 1rem;
	}
	canvas {
	  width: 100% !important;
	  height: auto !important;
	}
	table {
	  width: 100%;
	  border-collapse: collapse;
	  margin-top: 1rem;
	  background-color: #ffffff;
	  border-radius: 1rem;
	  overflow: hidden;
	}
	th, td {
	  border: 1px solid #e2e8f0;
	  padding: 0.85rem;
	  text-align: center;
	  font-size: 0.9rem;
	}
	th {
	  background-color: #e2e8f0;
	  font-weight: 600;
	  color: #334155;
	}
	tr:nth-child(even) td {
	  background-color: #f8fafc;
	}
	@media (max-width: 768px) {
	  .filter-box {
	    flex-direction: column;
	    align-items: flex-start;
	  }
	  table {
	    font-size: 0.8rem;
	  }
	}
	@media print {
	  #pdfBtn, #serBtn {
	    display: none !important;
	  }
	}
  </style>
</head>
<body>
  <div class="container">
    <h4>기간별 건수와 진료비 추이</h4>

    <!-- 검색 조건 -->
    <div class="filter-box">
      <span for="startMonth">시작년월</span>
      <input type="month" id="startMonth" value="2025-01">
      <span for="endMonth">종료년월</span>
      <input type="month" id="endMonth"   value="2025-03">
 	   <span for="medType">진료</span>
	   <div style="width: 80px;">
			<select class="custom-select" id="medType">
			    <option value="0" selected>전체</option>
			    <option value="1">의과</option>
			    <option value="2">치과</option>
			    <option value="9">한방</option>
		    </select>      
	    </div>
 	   <span for="jrType">행위</span>
	   <div style="width: 80px; font-size:10px ;">
			<select class="custom-select" id="jrType">
			    <option value="0" selected>전체</option>
			    <option value="1">정액</option>
			    <option value="2">행위</option>
		    </select>      
	    </div>
	   <span for="amtType">금액</span>
 	   <div style="width: 80px;">
			<select class="custom-select" id="amtType">
			    <option value="1" selected>총액</option>
			    <option value="2">청구액</option>
		    </select>      
	    </div>
		<!-- 검색 버튼 -->
		<button id="serBtn" onclick="filterData()">
		  <i class="fas fa-search"></i> 검색
		</button>
		<button id="pdfBtn" onclick="downloadPDF()">
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
	  const start = document.getElementById('startMonth').value;
	  const end   = document.getElementById('endMonth').value;

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
		data: { hospCd : s_hospid , startMonth: formattedStart, endMonth: formattedEnd },
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
    const element = document.querySelector(".container");

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

