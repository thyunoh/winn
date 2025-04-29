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
  <title>전문의별 전월비교 진료비</title>
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
      font-size: 16px;
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
    <h2>전문의별 전월비교 진료비</h2>
    <div class="filter-box">
       <span for="endMonth">적용년월</span>
	   <input type="month" id="endMonth" value="2025-03" 
		       style="width: 120px; font-size: 13px; padding: 4px; text-align: center;">
	   <span for="inoutType">구분</span>
	   <div style="width: 80px;">
			<select class="custom-select" id="inoutType" style= "font-size:13px ;">
			    <option value="T" selected>전체</option>
			    <option value="I">입원</option>
			    <option value="O">외래</option>
		    </select>      
	    </div>
 	   <span for="medType">진료</span>
	   <div style="width: 70px;">
			<select class="custom-select" id="medType" style= "font-size:13px ;">
			    <option value="0" selected>전체</option>
			    <option value="1">의과</option>
			    <option value="2">치과</option>
			    <option value="3">한방</option>
		    </select>      
	    </div>
 	   <span for="jrType">행위</span>
	   <div style="width: 70px;">
			<select class="custom-select" id="jrType" style= "font-size:13px ;">
			    <option value="0" selected>전체</option>
			    <option value="1">정액</option>
			    <option value="2">행위</option>
		    </select>      
	    </div>
	   <span for="amtType">금액</span>
 	   <div style="width: 90px;">
			<select class="custom-select" id="amtType" style= "font-size:13px ;">
			    <option value="2" selected>청구액</option>
			    <option value="1">총액</option>
		    </select>      
	    </div>
      <button id="serBtn" onclick="filterData()">검색</button>
      <button id="pdfBtn" onclick="downloadPDF()">PDF 출력</button>
 	<div id="loadingSpinner" style="display:none; text-align:center; margin-top:2px;">
	  <img src="/images/winct/loading.gif" alt="로딩 이미지 테스트">
	</div>
    </div>  
        <!-- 차트 영역 -->
    <div class="chart-box">
      <canvas id="costChart"></canvas>
    </div>
     
	<table id="dataTable" border="1" cellspacing="0" cellpadding="1" style="border-collapse: collapse; text-align: center;">
	  <thead>
	    <tr>
	      <th rowspan="2">전문의구분</th>
	      <th colspan="8">분류내용</th>
	    </tr>
	    <tr>
	      <th>전월청구액</th>
	      <th>당월청구액</th>
	      <th>전월건수</th>
	      <th>당월건수</th>
	      <th>전월건당진료비</th>
	      <th>당월건당진료비</th>	      
	      <th>증감차액</th>
	      <th>대비(%)</th>
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
      const end       = document.getElementById('endMonth').value;
      const ioType    = document.getElementById('inoutType').value;
	  const medType   = document.getElementById('medType').value;
	  const jrType    = document.getElementById('jrType').value;
	  const amtType   = document.getElementById('amtType').value;       

      if (!end) {
        alert("가준월을 선택해주세요.");
        return;
      }

      const formattedEnd = end.replaceAll("-", "");
      const s_hospid = getCookie("s_hospid");
      $("#loadingSpinner").show(); // 로딩 표시
      $.ajax({
        type: 'post',
        url: '/tong/t_tong07List.do',
        data: { hospCd: s_hospid, ipwe : ioType , endMonth: formattedEnd , 
        	   medType : medType , jrType : jrType , amtType : amtType },
        dataType: "json",
	    success: function(data) {
	       	  const labels     = [];  
	    	  const costsPrev  = [];
	    	  const costsCurr  = [];
	    	  const countsPrev = [];
	    	  const countsCurr = [];
	    	  const percents = [];  // ✅ 추가
	    	  const tableData = [];
		      data.forEach(item => {
		    	  labels.push(item.licenseNo + " (" + item.licenseName + ")");
 		    	// 백만원 단위
	    	    costsPrev.push((item.amtPrev / 1000000).toFixed(2));
	    	    costsCurr.push((item.amtCurr / 1000000).toFixed(2));

	    	    // 천건 단위
	    	    countsPrev.push((item.cntPrev / 1000).toFixed(2));
	    	    countsCurr.push((item.cntCurr / 1000).toFixed(2));

	    	    percents.push(item.percentVsPrev); // ✅ 퍼센트 값 추가
	    	    
		    	 const row = [
		    	  item.licenseNo + "(" + item.licenseName + ")",
		          numberWithCommas(item.amtPrev),
		          numberWithCommas(item.amtCurr),
		          numberWithCommas(item.cntPrev),
		          numberWithCommas(item.cntCurr),
		          numberWithCommas(item.avgPrev),
		          numberWithCommas(item.avgCurr),
		          numberWithCommas(item.amtDiff),
		          numberWithCommas(item.percentVsPrev)
		        ];
		        tableData.push({ row });
		      });
		      renderChart(labels, costsPrev, costsCurr, countsPrev, countsCurr, percents);
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
    function renderChart(labels, costsPrev, costsCurr, countsPrev, countsCurr ,percents) {
    	  const ctx = document.getElementById('costChart').getContext('2d');
    	  if (chart) chart.destroy();

    	  chart = new Chart(ctx, {
    	    type: 'bar',
    	    data: {
    	      labels: labels,
    	      datasets: [
    	        {
    	          type: 'bar',
    	          label: '전월 진료비 (백만원)',
    	          data: costsPrev,
    	          yAxisID: 'y',
    	          backgroundColor: 'rgba(173, 216, 230, 0.7)'
    	        },
    	        {
    	          type: 'bar',
    	          label: '당월 진료비 (백만원)',
    	          data: costsCurr,
    	          yAxisID: 'y',
    	          backgroundColor: 'rgba(0, 191, 255, 0.7)'
    	        },
    	        {
    	          type: 'line',
    	          label: '당월 건수 (천건)',
    	          data: countsPrev,
    	          yAxisID: 'y1',
    	          borderColor: 'gray',
    	          backgroundColor: 'gray',
    	          tension: 0.3
    	        },
    	        {
    	          type: 'line',
    	          label: '전월 건수 (천건)',
    	          data: countsCurr,
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
    	      interaction: {
    	        mode: 'index',
    	        intersect: false
    	      },
    	      plugins: {
    	        datalabels: {
    	          display: (context) => {
    	            // 오직 "당해년도 진료비" 막대(bar)에만 퍼센트 표시
    	            return context.dataset.label === '당해년도 진료비 (백만원)';
    	          },
    	          formatter: (value, context) => {
    	            return percents && percents[context.dataIndex]
    	              ? percents[context.dataIndex] + '%'
    	              : '';
    	          },
    	          anchor: 'end',
    	          align: 'end',
    	          color: '#000',
    	          font: {
    	            weight: 'bold'
    	          }
    	        },
    	        legend: {
    	          position: 'top'
    	        },
    	        tooltip: {
    	          mode: 'index',
    	          intersect: false
    	        }
    	      },
    	      stacked: false,
    	      scales: {
    	        y: {
    	          type: 'linear',
    	          position: 'left',
    	          title: {
    	            display: true,
    	            text: '진료비 (백만원)'
    	          }
    	        },
    	        y1: {
    	          type: 'linear',
    	          position: 'right',
    	          title: {
    	            display: true,
    	            text: '건수 (천건)'
    	          },
    	          grid: {
    	            drawOnChartArea: false
    	          }
    	        }
    	      }
    	    },
    	    plugins: [ChartDataLabels] // plugin 등록은 그대로 유지
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
    		  filename: '전문의별 전월비교 진료비.pdf',
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

