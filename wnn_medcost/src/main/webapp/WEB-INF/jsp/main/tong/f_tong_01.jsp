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
  <title>주요 진료지표</title>
  <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js"></script>
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
    <h2>주요 진료지표</h2>
    <div class="filter-box">
      <span for="endMonth">청구년월</span>
      <input type="month" id="endMonth" value="2025-02">
 	   <span for="medType">진료</span>
	   <div style="width: 90px;">
			<select class="custom-select" id="medType" style= "font-size:14px ;">
			    <option value="0" selected>전체</option>
			    <option value="1">의과</option>
			    <option value="2">치과</option>
			    <option value="3">한방</option>
		    </select>      
	    </div>
 	   <span for="jrType">행위</span>
	   <div style="width: 90px;">
			<select class="custom-select" id="jrType" style= "font-size:14px ;">
			    <option value="0" selected>전체</option>
			    <option value="1">정액</option>
			    <option value="2">행위</option>
		    </select>      
	    </div>
	   <span for="amtType">금액</span>
 	   <div style="width: 90px;">
			<select class="custom-select" id="amtType" style= "font-size:14px ;">
			    <option value="1" selected>총액</option>
			    <option value="2">청구액</option>
		    </select>      
	    </div>
      <button id="serBtn" onclick="filterData()">검색</button>
      <button id="pdfBtn" onclick="downloadPDF()">PDF 출력</button>
    </div>   
	<div id="loadingSpinner" style="display:none; text-align:center; margin-top:10px;">
	  <img src="/images/winct/loading.gif" alt="로딩 이미지 테스트">
	</div> 
	<table border="1" cellspacing="0" cellpadding="1" style="border-collapse: collapse; text-align: center;">
	  <thead>
	    <tr>
	      <th rowspan="2">구분</th>
	      <th rowspan="2">주요 진료지표</th>
	      <th colspan="3">분류내용</th>
	    </tr>
	    <tr>
	      <th>당월</th>
	      <th>전월</th>
	      <th>대비(%)</th>
	    </tr>
	  </thead>
	  <tbody id="tableBody">
		  <!-- Overall -->
		  <tr>
		    <td rowspan="6">전체</td>
		    <td>입원병상수</td>
		    <td id="allBedsCurr"></td>
		    <td id="allBedsPrev"></td>
		    <td id="allBedsRate"></td>
		  </tr>
		  <tr>
		    <td>전문의 수</td>
		    <td id="allSpecCurr"></td>
		    <td id="allSpecPrev"></td>
		    <td id="allSpecRate"></td>
		  </tr>
		  <tr>
		    <td>건수</td>
		    <td id="allCasesCurr"></td>
		    <td id="allCasesPrev"></td>
		    <td id="allCasesRate"></td>
		  </tr>
		  <tr>
		    <td>진료비(백만원)</td>
		    <td id="allCostCurr"></td>
		    <td id="allCostPrev"></td>
		    <td id="allCostRate"></td>
		  </tr>
		  <tr>
		    <td>전문의당월건수</td>
		    <td id="allCasesPerSpecCurr"></td>
		    <td id="allCasesPerSpecPrev"></td>
		    <td id="allCasesPerSpecRate"></td>
		  </tr>
		  <tr>
		    <td>전문의당진료비(백만원)</td>
		    <td id="allCostPerSpecCurr"></td>
		    <td id="allCostPerSpecPrev"></td>
		    <td id="allCostPerSpecRate"></td>
		  </tr>
		
		  <!-- Inpatient -->
		  <tr>
		    <td rowspan="8">입원</td> 
		    <td>건수</td>
		    <td id="iCasesCurr"></td>
		    <td id="iCasesPrev"></td>
		    <td id="iCasesRate"></td>
		  </tr>
		  <tr>
		    <td>진료비(백만원)</td>
		    <td id="iCostCurr"></td>
		    <td id="iCostPrev"></td>
		    <td id="iCostRate"></td>
		  </tr>
		  <tr> <!-- style="display: none;" -->
		    <td>평균재원일수</td>
		    <td id="iAvgStayCurr"></td>
		    <td id="iAvgStayPrev"></td>
		    <td id="iAvgStayRate"></td>
		  </tr>
		  <tr>
		    <td>건당진료비(천원)</td>
		    <td id="iCostPerCaseCurr"></td>
		    <td id="iCostPerCasePrev"></td>
		    <td id="iCostPerCaseRate"></td>
		  </tr>
		  <tr>
		    <td>일당진료비(천원)</td>
		    <td id="iCostPerDayCurr"></td>
		    <td id="iCostPerDayPrev"></td>
		    <td id="iCostPerDayRate"></td>
		  </tr>
		  <tr>
		    <td>전문질환(A)구성비</td>
		    <td id="iDiseaseAratioCurr"></td>
		    <td id="iDiseaseAratioPrev"></td>
		    <td id="iDiseaseAratioRate"></td>
		  </tr>
		  <tr>
		    <td>전문의당월건수</td>
		    <td id="iCasesPerSpecCurr"></td>
		    <td id="iCasesPerSpecPrev"></td>
		    <td id="iCasesPerSpecRate"></td>
		  </tr>
		  <tr>
		    <td>전문의당월진료비(백만원)</td>
		    <td id="iCostPerSpecCurr"></td>
		    <td id="iCostPerSpecPrev"></td>
		    <td id="iCostPerSpecRate"></td>
		  </tr>
		
		  <!-- Outpatient -->
		  <tr>
		    <td rowspan="8">외래</td>
		    <td>건수</td>
		    <td id="oCasesCurr"></td>
		    <td id="oCasesPrev"></td>
		    <td id="oCasesRate"></td>
		  </tr>
		  <tr>
		    <td>진료비(백만원)</td>
		    <td id="oCostCurr"></td>
		    <td id="oCostPrev"></td>
		    <td id="oCostRate"></td>
		  </tr>
		  <tr>
		    <td>건당진료비(원)</td>
		    <td id="oCostPerCaseCurr"></td>
		    <td id="oCostPerCasePrev"></td>
		    <td id="oCostPerCaseRate"></td>
		  </tr>
		  <tr>
		    <td>초진건수</td>
		    <td id="oFirstCasesCurr"></td>
		    <td id="oFirstCasesPrev"></td>
		    <td id="oFirstCasesRate"></td>
		  </tr>
		  <tr>
		    <td>재진건수</td>
		    <td id="oReturnCasesCurr"></td>
		    <td id="oReturnCasesPrev"></td>
		    <td id="oReturnCasesRate"></td>
		  </tr>
		  <tr>
		    <td>경증환자 구성비</td>
		    <td id="oMildRatioCurr"></td>
		    <td id="oMildRatioPrev"></td>
		    <td id="oMildRatioRate"></td>
		  </tr>
		  <tr>
		    <td>전문의당월건수</td>
		    <td id="oCasesPerSpecCurr"></td>
		    <td id="oCasesPerSpecPrev"></td>
		    <td id="oCasesPerSpecRate"></td>
		  </tr>
		  <tr>
		    <td>전문의당월진료비(백만원)</td>
		    <td id="oCostPerSpecCurr"></td>
		    <td id="oCostPerSpecPrev"></td>
		    <td id="oCostPerSpecRate"></td>
		  </tr>
		</tbody>
  
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
	  const end       = document.getElementById('endMonth').value;
	  const medType   = document.getElementById('medType').value;
	  const jrType    = document.getElementById('jrType').value;
	  const amtType   = document.getElementById('amtType').value;	  

	  if (!end) {
	    alert("시작월과 종료월을 모두 선택해주세요.");
	    return;
	  }
	  const formattedEnd = end.replaceAll("-", "");

	  const s_hospid = getCookie("s_hospid");
	  
	  console.log(s_hospid);   // 202502
	  $("#loadingSpinner").show(); // 로딩 표시
	  $.ajax({
		  type: 'post',
		  url: '/tong/t_tong01List.do',
		  data: { hospCd: s_hospid, endMonth: formattedEnd , 
			      medType : medType , jrType : jrType , amtType : amtType },  
		  dataType: "json",
		  success: function (data) {
		    if (data && data.length >= 1) {
		      const row = data[0]; // 한 줄만 응답됨

		      // 콤마 표시 함수
		      function numberWithCommas(x) {
		        if (x === null || x === undefined) return '0';
		        return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
		      }

		      // 💰 진료비용 (백만원 단위로 나누고, 콤마 표시)
		      function setCost(id, prevVal, currVal, rateVal) {
		        const prevNum = prevVal ? prevVal / 1000000 : 0;
		        const currNum = currVal ? currVal / 1000000 : 0;
		        const rate = rateVal || 0;

		        document.getElementById(id + 'Curr').innerText = numberWithCommas(currNum.toFixed(1));
		        document.getElementById(id + 'Prev').innerText = numberWithCommas(prevNum.toFixed(1));
		        document.getElementById(id + 'Rate').innerText = rate;
		      }
		      // ✅ 전체 진료비(백만원)
		      setCost("allCost", row.allCostPrev , row.allCostCurr ,  row.allCostRate);
		      
		      // 🧾 전체 진료건수
		      function setCases(id, prevVal, currVal, rateVal) {
		        const prevNum = prevVal || 0;
		        const currNum = currVal || 0;
		        const rate = rateVal || 0;

		        document.getElementById(id + 'Curr').innerText = numberWithCommas(currNum);
		        document.getElementById(id + 'Prev').innerText = numberWithCommas(prevNum);
		        document.getElementById(id + 'Rate').innerText = rate;
		      }

		      // ✅ 전체 진료건수
		      setCases("allCases", row.allCasesPrev , row.allCasesCurr ,row.allCasesRate);
      
			    // 전체 병동 수
		      const Bprev = Number(row.allBedsPrev);
		      const Bcurr = Number(row.allBedsCurr);

		      let Brate = 0;
		      if (Bprev > 0) {
		          Brate = (Bcurr / Bprev) * 100;
		      }
		      document.getElementById("allBedsCurr").innerText = numberWithCommas(Bcurr);
		      document.getElementById("allBedsPrev").innerText = numberWithCommas(Bprev);
		      document.getElementById("allBedsRate").innerText = Math.floor(Brate);  //
		      
		   // 전체병동 수
		      setCases("allBeds", row.allBedsPrev , row.allBedsCurr , Math.floor(Brate));			      
		      // 전체 전문의 수
     
		      const prev = Number(row.allSpecPrev);
		      const curr = Number(row.allSpecCurr);

		      let rate = 0;
		      if (prev > 0) {
		          rate = (curr / prev) * 100;
		      }
		      document.getElementById("allSpecCurr").innerText = numberWithCommas(curr);
		      document.getElementById("allSpecPrev").innerText = numberWithCommas(prev);
		      document.getElementById("allSpecRate").innerText = Math.floor(rate);  // 97%
		   // 전체 전문의 수
		      setCases("allSpec", row.allSpecPrev , row.allSpecCurr , Math.floor(rate));

		      
		      // 👨‍⚕️ 전문의 수 변수
		      const specPrev = row.allSpecPrev || 0;
		      const specCurr = row.allSpecCurr || 0;

		      // 🧾 전체 진료건수 변수
		      const casesPrev = row.allCasesPrev || 0;
		      const casesCurr = row.allCasesCurr || 0;

		      // 💰 전체 진료비 변수
		      const costPrev = row.allCostPrev || 0;
		      const costCurr = row.allCostCurr || 0;

		      
		      // 📊 전체 전문의당월 건수
		      const casesPerSpecPrev = specPrev ? (casesPrev / specPrev).toFixed(1) : 0;
		      const casesPerSpecCurr = specCurr ? (casesCurr / specCurr).toFixed(1) : 0;

		      const casesPerSpecRate = Math.floor( (casesPerSpecCurr / casesPerSpecPrev ) * 100 )  || 0;
		      
		      document.getElementById('allCasesPerSpecCurr').innerText = numberWithCommas(casesPerSpecCurr);
		      document.getElementById('allCasesPerSpecPrev').innerText = numberWithCommas(casesPerSpecPrev);
		      document.getElementById('allCasesPerSpecRate').innerText = casesPerSpecRate;
		      
		      // 💰 전체 전문의당 진료비 (백만원 단위)
		      const costPerSpecPrev = specPrev ? (costPrev / specPrev / 1000000).toFixed(1) : 0;
		      const costPerSpecCurr = specCurr ? (costCurr / specCurr / 1000000).toFixed(1) : 0;
		      const costPerSpecRate = Math.floor( ( costPerSpecCurr /costPerSpecPrev ) * 100 )  || 0;

		      document.getElementById('allCostPerSpecCurr').innerText = numberWithCommas(costPerSpecCurr);
		      document.getElementById('allCostPerSpecPrev').innerText = numberWithCommas(costPerSpecPrev);
		      document.getElementById('allCostPerSpecRate').innerText = costPerSpecRate;

		      //////////입원시작  
		      setCases("iCases", row.iCasesPrev , row.iCasesCurr , row.iCasesRate ); //입원건수///// 
		      // 👨‍⚕️ 입원진료건수 
		      const ispecPrev = row.iCasesPrev || 0;
		      const ispecCurr = row.iCasesCurr || 0;
		      
		      setCost("iCost"  , row.iCostPrev  , row.iCostCurr  , row.iCostRate ); //입원진료비/////
		      // 👨‍⚕️ 입원진료비 
		      const iCostPrev = row.iCostPrev || 0;
		      const iCostCurr = row.iCostCurr || 0;		      
		      
		      //입원건당진료비 
			  const iCostPerCaseCurr = (Number(row.iCasesCurr) > 0 && Number(row.iCostCurr) > 0)
				    ? Math.round(Number(row.iCostCurr) / Number(row.iCasesCurr) / 1000) : 0;
			  const iCostPerCasePrev = (Number(row.iCasesPrev) > 0 && Number(row.iCostPrev) > 0)
				    ? Math.round(Number(row.iCostPrev) / Number(row.iCasesPrev) / 1000) : 0;
		      const iCostPerCaseRate = Math.floor( ( iCostPerCaseCurr /iCostPerCasePrev ) * 100 )  || 0;
		      setCases("iCostPerCase", iCostPerCasePrev , iCostPerCaseCurr , iCostPerCaseRate ); //입원건당진료비/// 
              ///////////////////////////////
		      //입원일당진료비 
			  const iCostPerDayCurr = (Number(row.iuniqPatiCurr) > 0 && Number(row.iCostCurr) > 0)
					? Math.round(Number(row.iCostCurr) / Number(row.iuniqPatiCurr) / 1000) : 0;
			  const iCostPerDayPrev = (Number(row.iuniqPatiPrev) > 0 && Number(row.iCostPrev) > 0)
				    ? Math.round(Number(row.iCostPrev) / Number(row.iuniqPatiPrev) / 1000) : 0;
		      const iCostPerDayRate = Math.floor( ( iCostPerDayCurr /iCostPerDayPrev ) * 100 )  || 0;
		      setCases("iCostPerDay", iCostPerDayPrev , iCostPerDayCurr , iCostPerDayRate ); //입원일당진료비//////
		      
		      // 📊 입원 전문의당월 건수      입원진료건수                전체전문의건수   
		      const iCasesPerSpecPrev = ispecPrev ? (ispecPrev / specPrev).toFixed(1) : 0;
		      const iCasesPerSpecCurr = ispecCurr ? (ispecCurr / specCurr).toFixed(1) : 0;

		      const iCasesPerSpecRate = Math.floor( (iCasesPerSpecCurr / iCasesPerSpecPrev ) * 100 )  || 0;
		      
		      setCases("iCasesPerSpec", iCasesPerSpecPrev , iCasesPerSpecCurr , iCasesPerSpecRate ); //입원전문의당월건수

		      // 📊 입원 전문의당월진료비      입원진료비                 전체전문의건수   
		      const iCostPerSpecPrev = iCostPrev ? (iCostPrev / specPrev).toFixed(1) : 0;
		      const iCostPerSpecCurr = iCostCurr ? (iCostCurr / specCurr).toFixed(1) : 0;

		      const iCostPerSpecRate = Math.floor( (iCostPerSpecCurr / iCostPerSpecPrev ) * 100 )  || 0;
		      
		      setCost("iCostPerSpec", iCostPerSpecPrev , iCostPerSpecCurr , iCostPerSpecRate ); //입원 전문의당월진료비		      

		      ///외래시작 외래진료건수///////////////////////////////// 
		      const oCasesRate = Math.floor( (row.oCasesCurr / row.oCasesPrev ) * 100 )  || 0;
		      setCases("oCases", row.oCasesPrev , row.oCasesCurr ,oCasesRate ); //
		      ///외래진료비  
		      const oCostRate = Math.floor( (row.oCostCurr / row.oCostPrev ) * 100 )  || 0;
		      setCost("oCost", row.oCostPrev , row.oCostCurr ,oCostRate ); //

		      // 👨‍⚕️ 외래건수 
		      const oCasesPrev = row.oCasesPrev || 0;
		      const oCasesCurr = row.oCasesCurr || 0;

		      // 🧾 외래진료비 
		      const oCostPrev = row.oCostPrev || 0;
		      const oCostCurr = row.oCostCurr || 0;
		    
		      //외래건당진료비             !외래건수       !외래진료비     
			  const oCostPerCasePrev = oCasesPrev ? Math.floor(oCostPrev / oCasesPrev) : 0;
		      const oCostPerCaseCurr = oCasesCurr ? Math.floor(oCostCurr / oCasesCurr) : 0;
		      const oCostPerCaseRate = Math.floor( (oCostPerCaseCurr / oCostPerCasePrev ) * 100 )  || 0;
		      setCases("oCostPerCase", oCostPerCasePrev , oCostPerCaseCurr , oCostPerCaseRate ); //
			   ///외래초진건수 
		      const oFirstCasesRate = Math.floor( (row.oFirstCasesCurr / row.oFirstCasesPrev ) * 100 )  || 0;
		      setCases("oFirstCases", row.oFirstCasesPrev , row.oFirstCasesCurr ,oFirstCasesRate ); //		      
			   ///외래재진건수 
		      const oReturnCasesRate = Math.floor( (row.oReturnCasesCurr / row.oReturnCasesPrev  ) * 100 )  || 0;
		      setCases("oReturnCases", row.oReturnCasesPrev , row.oReturnCasesCurr ,oReturnCasesRate ); //	
		      
		      // 📊 외래 전문의당월 건수                   !외래건수       !전문의수  
		      const oCasesPerSpecPrev = oCasesPrev ? (oCasesPrev / specPrev).toFixed(1) : 0;
		      const oCasesPerSpecCurr = oCasesCurr ? (oCasesCurr / specCurr).toFixed(1) : 0;
		      const oCasesPerSpecRate = Math.floor( (oCasesPerSpecCurr / oCasesPerSpecCurr  ) * 100 )  || 0;
		      setCases("oCasesPerSpec", oCasesPerSpecPrev , oCasesPerSpecCurr ,oCasesPerSpecRate ); //

		      // 📊 외래 전문의당월 진료비                  !외래진료비       !전문의수  
		      const oCostPerSpecPrev = oCasesPrev ? (oCostPrev / specPrev).toFixed(1) : 0;
		      const oCostPerSpecCurr = oCasesCurr ? (oCostCurr / specCurr).toFixed(1) : 0;
		      const oCostPerSpecRate = Math.floor( (oCostPerSpecCurr / oCostPerSpecPrev  ) * 100 )  || 0;
		      setCost("oCostPerSpec", oCostPerSpecPrev , oCostPerSpecCurr ,oCostPerSpecRate ); //

		      // ✅ 여기 아래 추가
		      const rateCells = document.querySelectorAll('td[id$="Rate"]');
		      rateCells.forEach(cell => {
		        const value = parseFloat(cell.textContent.trim());
		        if (!isNaN(value) && value < 100 && value !== 0) {
		          cell.style.color = 'red';
		       // 중복 방지: 기존에 삼각형이 없을 때만 추가
		          if (!cell.innerHTML.includes("▼")) {
		            cell.innerHTML += ' <span style="color:red;">▼</span>';
		          }
		        }
		      });		      
  		      $("#loadingSpinner").hide(); // 작업 완료 후 로딩 숨김
 
		    } else {
		      alert("조회된 데이터가 없습니다.");
		    }
		  }
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
    		  filename: '주요 진료지표.pdf',
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

