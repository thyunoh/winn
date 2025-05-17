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
  <title>전체환자 약제비율</title>
  <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-datalabels@2"></script>
  <link href="/css/winmc/style_tong.css?v=123" rel="stylesheet">    
  <style>
  </style>
</head>
<body>
  <div class="container">
    <h2>전체환자 약제비율</h2>
    <div class="filter-box">
		<span for="startMonth">시작년월</span>
		<input type="month" id="startMonth" value="2025-01" 
		       style="width: 120px; font-size: 13px; padding: 3px; text-align: center;">
		<span></span>
		<span for="endMonth">종료년월</span>
		<input type="month" id="endMonth" value="2025-03" 
		       style="width: 120px; font-size: 13px; padding: 3px; text-align: center;">
	   <span for="inoutType">구분</span>
	   <div style="width: 80px;">
			<select class="custom-select" id="inoutType" style= "font-size:13px ;">
			    <option value="T" selected>전체</option>
			    <option value="I">입원</option>
			    <option value="O">외래</option>
		    </select>      
	    </div>
 	   <span for="medType">진료</span>
	   <div style="width: 80px;">
			<select class="custom-select" id="medType" style= "font-size:13px ;">
			    <option value="1" selected>의과</option>
			    <option value="2">치과</option>
			    <option value="3">한방</option>
			    <option value="0">전체</option>
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
	<div id="loadingSpinner" style="display:none; text-align:center; margin-top:10px;">
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
	      <th rowspan="2">진료과구분</th>
	      <th colspan="6">분류내용</th>
	    </tr>
	    <tr>
	      <th>청구액</th>
	      <th>건수</th>
	      <th>건당진료비</th>
	      <th>대비(%)</th>
	      <th>약제비용</th>
	      <th>약제비율</th>
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
      const start     = document.getElementById('startMonth').value;
      const end       = document.getElementById('endMonth').value;
      const ioType    = document.getElementById('inoutType').value;
	  const medType   = document.getElementById('medType').value;
	  const amtType   = document.getElementById('amtType').value;      

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
        url: '/tong/t_tong083List.do',
        data: { hospCd: s_hospid, ipwe : ioType ,startMonth: formattedStart, endMonth: formattedEnd 
        	   , medType : medType , amtType : amtType },
        dataType: "json",
	    success: function(data) {
		      const labels    = [];  
		      const costs     = [];
		      const counts    = [];
		      const percents  = []; 
		      const ycosts    = [];
		      const ypercents = []; 
	    	  const tableData = [];
		      data.forEach(item => {
			      labels.push(item.medName);
		          costs.push((item.totalAmt / 1000000).toFixed(2)); // 백만원 단위로 변환
		          counts.push((item.claimCount / 1000).toFixed(2)); // 천건 단위로 변환
		          percents.push(item.percentOfTotal);
		          ycosts.push((item.yakAmt / 1000000).toFixed(2)); // 백만원 단위로 변환
		          ypercents.push(item.percentOfAmt);
		    	 const row = [
		          item.medName ,
		          numberWithCommas(item.totalAmt),
		          numberWithCommas(item.claimCount),
		          numberWithCommas(item.avgAmt),
		          numberWithCommas(item.percentOfTotal),
		          numberWithCommas(item.yakAmt),
		          numberWithCommas(item.percentOfAmt)
		        ];
		        tableData.push({ row });
		      });
		      renderChart(labels, costs, counts , percents ,ycosts ,ypercents );
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
    function renderChart(labels, costs, counts, percents, ycosts, ypercents) {
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
    	            formatter: (value, context) => percents[context.dataIndex] + '%',
    	            color: '#000',
    	            font: { weight: 'bold' }
    	          }
    	        },
    	        {
    	          type: 'bar',
    	          label: '약제비용 (백만원)',
    	          data: ycosts,
    	          yAxisID: 'y',
    	          backgroundColor: 'rgba(255, 99, 132, 0.6)',
    	          datalabels: {
    	            anchor: 'end',
    	            align: 'end',
    	            formatter: (value, context) => ypercents[context.dataIndex] + '%',
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
    	        },
    	        {
    	          type: 'line',
    	          label: '약제비율 (%)',
    	          data: ypercents,
    	          yAxisID: 'y2',
    	          borderColor: 'red',
    	          backgroundColor: 'red',
    	          tension: 0.3
    	        }
    	      ]
    	    },
    	    options: {
    	      responsive: true,
    	      maintainAspectRatio: false,
    	      interaction: { mode: 'index', intersect: false },
    	      plugins: {
    	        datalabels: { display: true }
    	      },
    	      stacked: false,
    	      scales: {
    	        y: {
    	          type: 'linear',
    	          position: 'left',
    	          title: { display: true, text: '금액(백만원 / 십만원)' }
    	        },
    	        y1: {
    	          type: 'linear',
    	          position: 'right',
    	          title: { display: true, text: '건수(천건)' },
    	          grid: { drawOnChartArea: false }
    	        },
    	        y2: {
    	          type: 'linear',
    	          position: 'right',
    	          title: { display: true, text: '약제비율 (%)' },
    	          grid: { drawOnChartArea: false },
    	          ticks: { callback: value => `${value}%` },
    	          beginAtZero: true,
    	          display: true
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
    		  filename: '전체환자 약제비율.pdf',
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

