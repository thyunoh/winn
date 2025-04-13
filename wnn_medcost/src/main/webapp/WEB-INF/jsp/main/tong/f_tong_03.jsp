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
  <title>항목별건당진료비와 구성비</title>
  <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-datalabels@2"></script>
  <style>
    * {
      box-sizing: border-box;
      font-family: 'Segoe UI', sans-serif;
    }
    body {
      margin: 0;
      background-color: #f3f4f6;
      color: #111827;
    }
    .container {
      max-width: 1200px;
      margin: 40px auto;
      padding: 30px;
      background: #ffffff;
      border-radius: 20px;
      box-shadow: 0 10px 25px rgba(0, 0, 0, 0.07);
    }
    h2 {
      font-size: 28px;
      font-weight: bold;
      color: #1f2937;
      margin-bottom: 30px;
      border-left: 6px solid #3b82f6;
      padding-left: 16px;
    }
    .filter-box {
      display: flex;
      flex-wrap: wrap;
      justify-content: flex-start;
      align-items: center;
      gap: 12px;
      margin-bottom: 24px;
    }
    .filter-box span {
      font-weight: 500;
      font-size: 15px;
    }
    input[type="month"] {
      padding: 8px 12px;
      font-size: 14px;
      border: 1px solid #d1d5db;
      border-radius: 8px;
    }
    button {
      padding: 10px 20px;
      background-color: #3b82f6;
      border: none;
      border-radius: 8px;
      color: white;
      font-size: 14px;
      font-weight: 600;
      cursor: pointer;
      transition: all 0.3s ease;
    }
    button:hover {
      background-color: #2563eb;
      transform: translateY(-2px);
      box-shadow: 0 6px 12px rgba(59, 130, 246, 0.2);
    }
    .chart-box {
      margin-bottom: 30px;
      background: #f9fafb;
      padding: 24px;
      border-radius: 12px;
    }
    canvas {
      width: 100% !important;
      height: auto !important;
    }
    table {
      width: 100%;
      border-collapse: collapse;
      overflow-x: auto;
      margin-top: 16px;
      background-color: #ffffff;
      box-shadow: 0 4px 10px rgba(0, 0, 0, 0.04);
    }
    th, td {
      border: 1px solid #e5e7eb;
      padding: 4px;
      text-align: center;
      font-size: 14px;
    }
    th {
      background-color: #f3f4f6;
      font-weight: 700;
      color: #374151;
    }
    td {
      background-color: #ffffff;
    }
    tr:nth-child(even) td {
      background-color: #f9fafb;
    }
    @media (max-width: 768px) {
      .filter-box {
        flex-direction: column;
        align-items: flex-start;
      }
      table {
        font-size: 12px;
      }
      th, td {
        padding: 8px;
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
    <h2>항목별건당진료비와 구성비</h2>
    <div class="filter-box">
      <span for="startMonth">시작년월</span>
      <input style="text-align: center" type="month" id="startMonth" value="2025-01" style="width: 100px; padding: 4px;">
      <span>~</span>
      <span for="endMonth">종료년월</span>
      <input style="text-align: center" type="month" id="endMonth" value="2025-02" style="width: 100px; padding: 4px;">
	   <span for="inoutType">구분</span>
	   <div style="width: 100px;">
			<select class="custom-select" id="inoutType">
			    <option value="I" selected>입원</option>
			    <option value="O">외래</option>
		    </select>      
	    </div>
      <button id="serBtn" onclick="filterData()">검색</button>
      <button id="pdfBtn" onclick="downloadPDF()">PDF 출력</button>
    </div>  
	<div id="loadingSpinner" style="display:none; text-align:center; margin-top:2px;">
	  <img src="/images/winct/loading.gif" alt="로딩 이미지 테스트">
	</div> 
        <!-- 차트 영역 -->
    <div class="chart-box">
      <canvas id="costChart"></canvas>
    </div>
     
	<table id="dataTable" border="1" cellspacing="0" cellpadding="1" style="border-collapse: collapse; text-align: center;">
	  <thead>
	    <tr>
	      <th rowspan="2" style="width: 100px;">진료항구분</th>
	      <th rowspan="2" style="width: 100px;">진료목구분</th>
	      <th colspan="4">분류내용</th>
	    </tr>
	    <tr>
	      <th style="width: 100px;">진료비총액</th>
	      <th style="width: 80px;">건수</th>
	      <th style="width: 100px;">건당진료비</th>
	      <th style="width: 80px;">대비(%)</th>
	    </tr>
	  </thead>
	  <tbody id="tableBody">
   	 </tbody>
	</table>
  </div>  
</body>
</html>
<script>
    let chart;
 // ✅ 3자리마다 콤마 표시 함수 (한 번만 정의)
	  function numberWithCommas(x) {
	    return x?.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",") || "0";
	  }

    // ✅ 데이터 필터 함수
    function filterData() {
      const start  = document.getElementById('startMonth').value;
      const end    = document.getElementById('endMonth').value;
      const ioType = document.getElementById('inoutType').value;

      if (!start || !end) {
        alert("시작월과 종료월을 모두 선택해주세요.");
        return;
      }

      const formattedStart = start.replaceAll("-", "");
      const formattedEnd = end.replaceAll("-", "");
      const s_hospid = getCookie("s_hospid");
      $("#loadingSpinner").show(); // 로딩 표시
      $.ajax({
        type: 'post',
        url: '/tong/t_tong03List.do',
        data: { hospCd: s_hospid, ipwe : ioType ,startMonth: formattedStart, endMonth: formattedEnd },
        dataType: "json",
	    success: function(data) {
		      const labels    = [];  
		      const costs     = [];
		      const counts    = [];
		      const percents  = []; 
	    	  const tableData = [];
		      data.forEach(item => {
		    	  labels.push(item.itemName + " (" + item.codeName + ")");
		          costs.push((item.totalAmt / 1000000).toFixed(2)); // 백만원 단위로 변환
		          counts.push((item.claimCount / 1000).toFixed(2)); // 천건 단위로 변환
		          percents.push(item.percentOfTotal);
		    	 const row = [
		          item.itemName ,
		          item.codeName ,
		          numberWithCommas(item.totalAmt),
		          numberWithCommas(item.claimCount),
		          numberWithCommas(item.avgAmt),
		          numberWithCommas(item.percentOfTotal)
		        ];
		        tableData.push({ row });
		      });
		      renderChart(labels, costs, counts , percents);
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
    function renderChart(labels, costs, counts, percents) {
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
    	          backgroundColor: 'rgba(135, 206, 250, 0.7)',
    	          datalabels: {
    	            anchor: 'end',
    	            align: 'end',
    	            formatter: (value, context) => {
    	              return percents[context.dataIndex] + '%';
    	            },
    	            color: '#000',
    	            font: { weight: 'bold' }
    	          }
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
    	      plugins: {
    	        datalabels: {
    	          display: true
    	        }
    	      },
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
    	    },
    	    plugins: [ChartDataLabels]
    	  });
    	}

  function downloadPDF() {
    const pdfBtn  = document.getElementById('pdfBtn');
    const serBtn  = document.getElementById('serBtn');
    const element = document.querySelector(".container");

    pdfBtn.style.display = 'none';
    serBtn.style.display = 'none';
    element.style.transform = "scale(1.0)";
    element.style.transformOrigin = "top left";

    const opt = {
    		  margin: [2, 10, 5, 10], // [상(top), 우(right), 하(bottom), 좌(left)]
    		  filename: '항목별건당진료비와 구성비.pdf',
    		  image: { type: 'jpeg', quality: 1 },
    		  html2canvas: { scale: 2, useCORS: true ,scrollY: 0},
    		  jsPDF: { unit: 'mm', format: 'a4', orientation: 'portrait' }
    };

    html2pdf().set(opt).from(element).save().then(() => {
      element.style.transform = "";
      pdfBtn.style.display = 'inline-block';
      serBtn.style.display = 'inline-block';
    });
  }
</script>

