<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%-- misStat.jsp — 경영관리(MIS) › 경영통계 (2026-10-08)
     · 제안서 ① 경영통계 화면(docs/proposals/신규요양병원_업무패키지_제안_2026-10-08.html)을 그대로 구현.
     · 숫자는 전부 서버 집계(/mis/statGet.do) — 청구 샘파일·환자평가표·입퇴원현황·자료생성 결과. 저장하는 것 없음.
     · 병상 수가 등록돼 있으면 가동률, 없으면 「입력 필요」 → 고정경비 화면으로 안내.
     · 위너넷은 hospCd 파라미터(상단 병원검색 쿠키)로 다른 병원을 본다. 고객 평균은 병원명 없이 평균만.
     · ★주의: 이 파일 안에서 Deferred EL 표기(샵+중괄호) 금지 --%>

<script src="/asset/js/ui-message.js"></script>

<div class="dashboard-wrapper">
<div id="misStat" data-wnn="<c:out value='${wnnYn}'/>" data-hosp="<c:out value='${hospCd}'/>">
<style>
  #misStat{ background:#f4f6f8; color:#1f2a30; min-height:100%; padding:14px 16px 50px; max-width:100%; overflow-x:hidden; }
  #misStat *{ box-sizing:border-box; }
  #misStat .ms-head{ display:flex; align-items:center; gap:10px; margin-bottom:12px; flex-wrap:wrap; }
  #misStat .ms-title{ font-size:18px; font-weight:800; color:#20303a; display:flex; align-items:center; gap:8px; }
  #misStat .ms-dot{ width:10px; height:10px; border-radius:50%; background:linear-gradient(135deg,#1f5a4b,#2a7665); }
  #misStat .ms-sub{ font-size:12px; color:#6b7c86; font-weight:400; }
  #misStat .ms-hosp{ background:#e7f3ee; color:#1f5a4b; font-size:12px; font-weight:800; border:1px solid #cfe3da; border-radius:14px; padding:3px 11px; }
  #misStat .ms-spacer{ flex:1; }
  #misStat select, #misStat input{ border:1px solid #cfd8e0; border-radius:6px; padding:5px 8px; font-size:13px; background:#fff; font-family:inherit; }
  #misStat .ms-btn{ border:1px solid #cfd9e0; background:#fff; color:#43555f; border-radius:6px; padding:5px 11px; font-size:12.5px; font-weight:700; cursor:pointer; }
  #misStat .ms-btn:hover{ background:#eef3f6; }
  #misStat .ms-btn.pri{ background:#1f5a4b; color:#fff; border-color:#1f5a4b; }
  #misStat .ms-note{ background:#fff; border:1px solid #e3e9ed; border-radius:10px; padding:10px 14px; font-size:12.5px; color:#43555f; margin-bottom:12px; line-height:1.6; }
  #misStat .ms-kpis{ display:grid; grid-template-columns:repeat(4,1fr); gap:10px; margin-bottom:12px; }
  @media (max-width:900px){ #misStat .ms-kpis{ grid-template-columns:repeat(2,1fr); } }
  #misStat .ms-kpi{ background:#fff; border:1px solid #e3e9ed; border-radius:10px; padding:12px 14px; min-width:0; }
  #misStat .ms-kpi .l{ font-size:12px; color:#6b7c86; }
  #misStat .ms-kpi .v{ font-size:26px; font-weight:900; color:#20303a; line-height:1.2; font-variant-numeric:tabular-nums; }
  #misStat .ms-kpi .d{ font-size:12px; font-weight:700; color:#6b7c86; }
  #misStat .up{ color:#2f8f5b; } #misStat .down{ color:#c0463f; } #misStat .need{ color:#c0463f; }
  #misStat .ms-grid{ display:grid; grid-template-columns:1.4fr 1fr; gap:12px; margin-bottom:12px; }
  #misStat .ms-grid > .ms-card:first-child{ display:flex; flex-direction:column; }   /* 그래프 카드가 오른쪽(환자군) 카드 높이만큼 늘어나 그래프가 빈칸을 채운다(2026-10-08 사용자 「아래로 내리고」) */
  #misStat .ms-grid{ align-items:start; }   /* 두 카드가 서로 높이를 끌어올리지 않게 — 가운데를 줄여 아래 월별 상세에 자리를 준다(2026-10-08 사용자) */
  @media (max-width:900px){ #misStat .ms-grid{ grid-template-columns:1fr; } }
  #misStat .ms-card{ background:#fff; border:1px solid #e3e9ed; border-radius:10px; padding:12px 14px; min-width:0; }
  #misStat .ms-card h4{ margin:0 0 8px; font-size:13px; color:#43555f; font-weight:700; }
  #misStat .ms-card svg{ width:100%; height:auto; display:block; }
  #misStat .ms-card svg text{ font-size:11px; fill:#6b7c86; }
  #misStat .ms-card svg text.lbl{ fill:#20303a; font-weight:700; }
  #misStat .legend{ display:flex; gap:14px; font-size:12px; color:#6b7c86; margin-top:4px; flex-wrap:wrap; }
  #misStat .legend i{ display:inline-block; width:10px; height:10px; border-radius:2px; margin-right:4px; vertical-align:-1px; }
  #misStat .stack{ display:flex; height:22px; border-radius:6px; overflow:hidden; margin:8px 0 4px; background:#eef2f5; }
  #misStat .stack span{ display:block; height:100%; font-size:11px; color:#fff; text-align:center; line-height:22px; font-weight:700; min-width:0; overflow:hidden; white-space:nowrap; }
  #misStat .sA{background:#7a8a86}.sB{background:#5e7d78}.sC{background:#3f8f84}.sD{background:#0f6e64}.sE{background:#0b4f48}
  #misStat table{ width:100%; border-collapse:collapse; font-size:13px; }
  #misStat th{ background:#f2f6f8; font-weight:700; color:#43555f; padding:7px 9px; border-bottom:1px solid #dde5ea; text-align:left; white-space:nowrap; }
  #misStat td{ padding:6px 9px; border-bottom:1px solid #eef2f5; }
  #misStat td.n, #misStat th.n{ text-align:right; font-variant-numeric:tabular-nums; }
  #misStat .ms-empty{ color:#8a99a3; font-size:13px; padding:22px; text-align:center; }
  #misStat .ms-wrap{ overflow-x:auto; }
  #misStat .small{ font-size:12px; color:#6b7c86; }
</style>

<div class="ms-head">
  <div class="ms-title"><span class="ms-dot"></span>경영통계 <span class="ms-sub">— 청구·평가표·입퇴원 자료로 자동 산출</span></div>
  <span class="ms-hosp">🏥 <c:out value='${hospNm}'/></span>
  <span class="ms-spacer"></span>
  <label style="font-size:13px;color:#43555f;">기간
    <select id="msFrom" onchange="msLoad();"></select> ~ <select id="msTo" onchange="msLoad();"></select>
  </label>
  <label style="font-size:13px;color:#43555f;"><input type="checkbox" id="msCmp" checked onchange="msRender();"> 고객 평균 비교</label>
  <button type="button" class="ms-btn" onclick="location.href='<c:url value="/main/misCost.do"/>';">고정경비 →</button>
</div>

<div class="ms-note" id="msNote">
  원장·행정실장이 월초에 보는 화면입니다. 숫자는 <b>청구 샘파일(총진료비·입원일수)</b>, <b>환자평가표(환자군)</b>, <b>입퇴원현황(입·퇴원)</b>, <b>자료생성 결과(적정성 점수)</b>에서 바로 계산됩니다. 올리지 않은 달은 비어 보입니다.
  <span id="msBedNote"></span>
</div>

<div class="ms-kpis" id="msKpis"></div>

<div class="ms-grid">
  <div class="ms-card">
    <h4 id="msChartTtl">월 총진료비 추이 (억원)</h4>
    <div id="msChartBox" style="flex:1 1 auto;min-height:260px;max-height:340px;position:relative;"><canvas id="msChartCv"></canvas></div>
    <div class="small" id="msChartNote" style="margin-top:6px;"></div>
  </div>
  <div class="ms-card">
    <h4 id="msClsTtl">환자군 구성</h4>
    <div class="stack" id="msStack"></div>
    <div class="small" id="msClsNote"></div>
    <details class="small" style="margin-top:8px;">
      <summary style="cursor:pointer;color:#1f5a4b;font-weight:700;">환자군(A~E) 분류 설명</summary>
      <table style="margin-top:6px;">
        <tr><th style="width:130px;white-space:nowrap;">환자군</th><th>설명</th></tr>
        <tr><td style="white-space:nowrap;"><b>A 의료최고도</b></td><td>혼수·인공호흡기·중심정맥영양 등 의료 필요도가 가장 높은 환자. 일당정액 수가가 가장 높음.</td></tr>
        <tr><td style="white-space:nowrap;"><b>B 의료고도</b></td><td>뇌성마비·척수손상·파킨슨 등 신체기능이 크게 떨어져 집중 간호가 필요한 환자.</td></tr>
        <tr><td style="white-space:nowrap;"><b>C 의료중도</b></td><td>중증 질환·욕창·경관영양 등 지속적인 의료 처치가 필요한 환자.</td></tr>
        <tr><td style="white-space:nowrap;"><b>D 의료경도</b></td><td>치매·경증 질환 등 의료 필요도가 낮은 환자. 장기입원(181일) 지표의 대상.</td></tr>
        <tr><td style="white-space:nowrap;"><b>E 선택입원군</b></td><td>의료보다 요양 목적이 큰 환자. 수가가 가장 낮고 장기입원 지표의 대상이며, 본인부담이 높음.</td></tr>
      </table>
      <div style="margin-top:4px;">분류는 매달 환자평가표(심평원 환자분류 기준)로 정해지며, 일당정액 수가는 A→E 순으로 낮아집니다. B·C 비율이 높을수록 1인 1일 진료비가 높고, D·E 가 늘면 장기입원 지표가 나빠질 수 있습니다.</div>
    </details>
    <div class="ms-wrap"><table id="msClsTbl"></table></div>
  </div>
</div>

<div class="ms-card">
  <h4>월별 상세</h4>
  <div class="ms-wrap"><table id="msTbl"><tbody><tr><td class="ms-empty">불러오는 중…</td></tr></tbody></table></div>
  <div class="small" style="margin-top:6px;">총진료비 = 급여(공단) + 본인부담. 1인 1일 = 총진료비 ÷ 입원일수. 환자 1인 월 = 총진료비 ÷ 그 달 환자 수. 평균 재원 = 입원일수 ÷ 그 달 일수. 퇴원자 평균 재원일수 = 그 달 퇴원한 환자의 입원일~퇴원일. 고객 열은 같은 달 청구를 올린 위너넷 고객 병원 평균(괄호 = 병원 수)으로, 병원 규모와 무관하게 환자 한 명 기준으로 비교합니다.</div>
</div>

<script>
(function(){
  function gel(id){ return document.getElementById(id); }
  function esc(s){ return (s==null?'':String(s)).replace(/[&<>"]/g, function(c){ return ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;'})[c]; }); }
  function post(url, data){
    return $.ajax({ url:url, type:'POST', data:data, dataType:'json' }).then(function(res){
      if (res && res.result === 'FAIL') { throw new Error(res.message || '처리에 실패했습니다.'); }
      return res;
    });
  }
  function err(e){ _alertBox((e && e.message) ? e.message : '처리 중 오류가 발생했습니다.', {icon:'❌'}); }
  var root = gel('misStat'), WNN = root.getAttribute('data-wnn') === 'Y';
  var D = null;   // 마지막 응답

  /* 숫자 표기 */
  function eok(v){ v = Number(v||0); return (v/100000000).toFixed(2) + '억'; }
  function man(v){ v = Number(v||0); return (v/10000).toFixed(1) + '만'; }
  function num(v){ return Number(v||0).toLocaleString('ko-KR'); }
  function ymLbl(ym){ return ym ? (ym.slice(0,4) + '년 ' + Number(ym.slice(4,6)) + '월') : ''; }
  function ymShort(ym){ return ym ? (Number(ym.slice(4,6)) + '월') : ''; }
  function daysIn(ym){ return new Date(Number(ym.slice(0,4)), Number(ym.slice(4,6)), 0).getDate(); }
  function addYm(ym, n){ var y = Number(ym.slice(0,4)), m = Number(ym.slice(4,6)) - 1 + n; y += Math.floor(m/12); m = ((m%12)+12)%12; return y + String(m+1).padStart(2,'0'); }
  function pct(a, b){ b = Number(b||0); if (!b) return ''; var d = (Number(a||0) - b) / b * 100; return (d >= 0 ? '▲ ' : '▼ ') + Math.abs(d).toFixed(1) + '%'; }

  /* 병원 — 위너넷은 상단 병원검색 쿠키(hospid)를 따른다 */
  function hospCd(){
    try { if (WNN && typeof getCookie === 'function') { var h = (getCookie('s_hospid') || '').trim(); if (h) return h; } } catch(e){}
    return root.getAttribute('data-hosp');
  }

  /* 기간 셀렉트 — 최근 24달 */
  (function(){
    var now = new Date(), cur = now.getFullYear() + String(now.getMonth()+1).padStart(2,'0');
    var sf = gel('msFrom'), st = gel('msTo');
    for (var i = 0; i < 30; i++) { var ym = addYm(cur, -i); sf.add(new Option(ymLbl(ym), ym)); st.add(new Option(ymLbl(ym), ym)); }
    sf.value = addYm(cur, -6); st.value = addYm(cur, -1);
  })();

  window.msLoad = function(){
    var p = { fromYm: gel('msFrom').value, toYm: gel('msTo').value };
    if (WNN) p.hospCd = hospCd();
    post('<c:url value="/mis/statGet.do"/>', p).then(function(res){
      D = res;
      if (gel('msFrom').value !== res.fromYm) gel('msFrom').value = res.fromYm;
      if (gel('msTo').value !== res.toYm) gel('msTo').value = res.toYm;
      msRender();
    }).catch(function(e){ gel('msTbl').innerHTML = '<tbody><tr><td class="ms-empty">' + esc((e && e.message) || '불러오지 못했습니다.') + '</td></tr></tbody>'; });
  };

  /* 월 단위로 합친다 */
  function build(res){
    var byYm = {};
    function row(ym){ if (!byYm[ym]) byYm[ym] = { ym:ym, totamt:0, claimamt:0, selfamt:0, admdays:0, pats:0, bills:0, cls:{A:0,B:0,C:0,D:0,E:0}, incnt:null, outcnt:null, avgstay:null, score:null, insur:{} }; return byYm[ym]; }
    (res.months||[]).forEach(function(m){ var r = row(m.ym); r.totamt = Number(m.totamt||0); r.claimamt = Number(m.claimamt||0); r.selfamt = Number(m.selfamt||0); r.admdays = Number(m.admdays||0); r.pats = Number(m.pats||0); r.bills = Number(m.bills||0); });
    (res.insur||[]).forEach(function(m){ var r = row(m.ym); r.insur[m.insurtype||'?'] = Number(m.totamt||0); });
    (res.classes||[]).forEach(function(m){ var r = row(m.ym); var c = (m.cls||'E').toUpperCase(); if (!(c in r.cls)) c = 'E'; r.cls[c] += Number(m.pats||0); });
    (res.inout||[]).forEach(function(m){ var r = row(m.ym); r.incnt = Number(m.incnt||0); r.outcnt = Number(m.outcnt||0); r.avgstay = m.avgstay == null ? null : Number(m.avgstay); });
    (res.scores||[]).forEach(function(m){ var r = row(m.ym); r.score = Number(m.score||0); });
    var avg = {}; (res.avg||[]).forEach(function(m){ avg[m.ym] = m; });
    var list = []; var ym = res.fromYm; while (ym <= res.toYm) { list.push(byYm[ym] || row(ym)); ym = addYm(ym, 1); }
    return { list:list, avg:avg };
  }

  window.msRender = function(){
    if (!D) return;
    var B = build(D), L = B.list, cmp = gel('msCmp').checked;
    // 마지막 달 = 청구가 있는 마지막 달
    var withClaim = L.filter(function(r){ return r.totamt > 0; });
    var cur = withClaim.length ? withClaim[withClaim.length-1] : L[L.length-1];
    var prev = null; for (var i = L.indexOf(cur) - 1; i >= 0; i--) { if (L[i].totamt > 0) { prev = L[i]; break; } }
    var dIn = daysIn(cur.ym), census = cur.admdays ? cur.admdays / dIn : 0, perDay = cur.admdays ? cur.totamt / cur.admdays : 0;
    // 고객 평균(1인 1일)은 20곳 이상 올린 가장 가까운 달 것을 쓴다 — 집계 중인 달(10곳)로 비교하면 어긋난다
    var avgRef = null; for (var j = L.indexOf(cur); j >= 0; j--) { var av0 = B.avg[L[j].ym]; if (av0 && Number(av0.hosps||0) >= 20 && Number(av0.avgperday)) { avgRef = av0; break; } }
    var avgPerDay = avgRef ? Number(avgRef.avgperday) : 0, avgPerDayYm = avgRef ? avgRef.ym : '';

    // KPI
    var k = '';
    k += '<div class="ms-kpi"><div class="l">월 총진료비 (급여+본인부담) · ' + esc(ymLbl(cur.ym)) + '</div><div class="v">' + (cur.totamt ? eok(cur.totamt) : '—') + '</div><div class="d ' + (prev && cur.totamt >= prev.totamt ? 'up' : 'down') + '">' + (prev ? esc(pct(cur.totamt, prev.totamt)) + ' 전월 ' + eok(prev.totamt) : '전월 자료 없음') + '</div></div>';
    k += '<div class="ms-kpi"><div class="l">평균 재원 환자 (일)</div><div class="v">' + (census ? Math.round(census) + '명' : '—') + '</div><div class="d">입원일수 ' + num(cur.admdays) + '일 ÷ ' + dIn + '</div></div>';
    k += '<div class="ms-kpi"><div class="l">입원 / 퇴원</div><div class="v">' + (cur.incnt == null ? '—' : cur.incnt + ' / ' + cur.outcnt) + '</div><div class="d">' + (prev && prev.incnt != null ? '전월 ' + prev.incnt + ' / ' + prev.outcnt : '입퇴원현황 기준') + '</div></div>';
    k += '<div class="ms-kpi"><div class="l">환자 1인 1일 진료비</div><div class="v">' + (perDay ? man(perDay) : '—') + '</div><div class="d ' + (avgPerDay && perDay >= avgPerDay ? 'up' : 'down') + '">' + (cmp && avgPerDay ? '고객 평균 ' + man(avgPerDay) + ' (' + esc(ymShort(avgPerDayYm)) + ')' : '총진료비 ÷ 입원일수') + '</div></div>';
    gel('msKpis').innerHTML = k;

    // 막대 — 총진료비(본원) vs 고객 평균 : Chart.js(header.jsp 가 싣는다) — 진료비-분석 현황(total_Report)과 같은 모양·색(본원 주황, 비교 파랑)
    var labels = L.map(function(r){ return ymLbl(r.ym); });
    var mine = L.map(function(r){ return r.totamt ? +(r.totamt/100000000).toFixed(2) : null; });
    var avgs = L.map(function(r){ var av = B.avg[r.ym]; return cmp && av && Number(av.avgtot) ? +(Number(av.avgtot)/100000000).toFixed(2) : null; });
    var fewFlag = L.map(function(r){ var av = B.avg[r.ym]; return av ? Number(av.hosps||0) < 20 : false; });
    var hospsOf = L.map(function(r){ var av = B.avg[r.ym]; return av ? Number(av.hosps||0) : 0; });
    if (window._msChart) { try { window._msChart.destroy(); } catch(e){} window._msChart = null; }
    if (typeof Chart !== 'undefined') {
      var ds = [{ label:'본원', data:mine, backgroundColor:'rgba(237,125,49,0.9)', borderWidth:0, borderRadius:4, maxBarThickness:46 }];
      if (cmp) ds.unshift({ label:'위너넷 고객 평균', data:avgs, backgroundColor: fewFlag.map(function(f){ return f ? 'rgba(11,142,202,0.35)' : 'rgba(11,142,202,0.85)'; }), borderWidth:0, borderRadius:4, maxBarThickness:46 });
      // 막대 위에 값을 적는다(종전 SVG 그래프처럼 — 사용자 「이전 그래프 위에 표현」). 비교 막대는 20곳 미만이면 「집계중」.
      var valueOnBar = { id:'msValueOnBar', afterDatasetsDraw:function(chart){
        var c = chart.ctx; c.save(); c.font = 'bold 11px sans-serif'; c.textAlign = 'center'; c.textBaseline = 'bottom';
        chart.data.datasets.forEach(function(d, di){ var meta = chart.getDatasetMeta(di); if (meta.hidden) return;
          meta.data.forEach(function(bar, i){ var v = d.data[i]; if (v == null) return;
            var isMine = d.label === '본원', txt = (!isMine && fewFlag[i]) ? '집계중' : v.toFixed(2);
            c.fillStyle = isMine ? '#20303a' : '#6b7c86'; c.fillText(txt, bar.x, bar.y - 3); }); });
        c.restore(); } };
      window._msChart = new Chart(gel('msChartCv').getContext('2d'), {
        type:'bar',
        data:{ labels:labels, datasets:ds },
        plugins:[valueOnBar],
        options:{
          maintainAspectRatio:false, responsive:true, animation:{ duration:600 },
          plugins:{
            legend:{ display:true, position:'bottom', labels:{ boxWidth:12, padding:10, font:{ size:11 } } },
            tooltip:{ callbacks:{ label:function(c){ var v = c.parsed.y; if (v == null) return c.dataset.label + ': 자료 없음'; var s = c.dataset.label + ': ' + v.toFixed(2) + '억'; if (c.dataset.label !== '본원') s += ' (' + hospsOf[c.dataIndex] + '곳' + (fewFlag[c.dataIndex] ? ' · 집계중' : '') + ')'; return s; } } }
          },
          scales:{
            y:{ beginAtZero:true, grace:'10%', grid:{ color:'rgba(0,0,0,0.05)' }, ticks:{ callback:function(v){ return v + '억'; }, font:{ size:11 } } },
            x:{ grid:{ display:false }, ticks:{ font:{ size:11 } } }
          }
        }
      });
    }
    var hospsTxt = ''; if (cmp) { var hs = L.map(function(r){ return B.avg[r.ym] ? Number(B.avg[r.ym].hosps||0) : 0; }).filter(Boolean); if (hs.length) hospsTxt = '고객 평균은 같은 달 청구를 올린 ' + Math.min.apply(null, hs) + '~' + Math.max.apply(null, hs) + '곳의 평균(20곳 미만인 달은 흐리게 「집계중」). '; }
    gel('msChartNote').textContent = hospsTxt + '진료비는 환자 수·환자군에 따라 다르므로 「환자 1인 1일 진료비」로도 비교합니다.';

    // 환자군
    var tot = cur.cls.A + cur.cls.B + cur.cls.C + cur.cls.D + cur.cls.E;
    gel('msClsTtl').textContent = '환자군 구성 (' + ymLbl(cur.ym) + ' 평가표' + (tot ? ', ' + tot + '명' : '') + ')';
    var st = ''; ['A','B','C','D','E'].forEach(function(c){ var v = cur.cls[c]; if (!tot || !v) return; var w = v/tot*100; st += '<span class="s' + c + '" style="width:' + w.toFixed(1) + '%">' + (w >= 8 ? c + ' ' + v : '') + '</span>'; });
    gel('msStack').innerHTML = st || '<span style="color:#8a99a3;background:none;line-height:22px;">평가표 없음</span>';
    gel('msClsNote').textContent = tot ? ('의료고도·중도(B·C) ' + Math.round((cur.cls.B+cur.cls.C)/tot*100) + '% · 장기입원 지표 대상(D·E) ' + (cur.cls.D+cur.cls.E) + '명') : '';
    var t = '<thead><tr><th>월</th><th class="n">환자</th><th class="n">A</th><th class="n">B</th><th class="n">C</th><th class="n">D</th><th class="n">E</th><th class="n">적정성 점수</th></tr></thead><tbody>';
    L.forEach(function(r){ var s = r.cls.A+r.cls.B+r.cls.C+r.cls.D+r.cls.E; if (!s && r.score == null) return;
      t += '<tr><td>' + esc(ymShort(r.ym)) + '</td><td class="n">' + s + '</td><td class="n">' + r.cls.A + '</td><td class="n">' + r.cls.B + '</td><td class="n">' + r.cls.C + '</td><td class="n">' + r.cls.D + '</td><td class="n">' + r.cls.E + '</td><td class="n">' + (r.score == null ? '—' : r.score.toFixed(1)) + '</td></tr>'; });
    gel('msClsTbl').innerHTML = t + '</tbody>';

    // 월별 상세
    var h = '<thead><tr><th>월</th><th class="n">총진료비</th><th class="n">급여(공단)</th><th class="n">본인부담</th><th class="n">건강보험</th><th class="n">의료급여</th><th class="n">환자</th><th class="n">입원일수</th><th class="n">평균 재원</th><th class="n">1인 1일</th><th class="n">환자 1인 월</th><th class="n">입원</th><th class="n">퇴원</th><th class="n">퇴원자 평균 재원일</th>' + (cmp ? '<th class="n">고객 환자 1인 월</th><th class="n">고객 1인 1일</th>' : '') + '</tr></thead><tbody>';
    var any = false;
    L.forEach(function(r){
      if (!r.totamt && r.incnt == null && !(r.cls.A+r.cls.B+r.cls.C+r.cls.D+r.cls.E)) return; any = true;
      var di = daysIn(r.ym), av = B.avg[r.ym];
      h += '<tr><td>' + esc(ymLbl(r.ym)) + '</td><td class="n">' + (r.totamt ? eok(r.totamt) : '—') + '</td><td class="n">' + (r.claimamt ? eok(r.claimamt) : '—') + '</td><td class="n">' + (r.selfamt ? eok(r.selfamt) : '—') + '</td>'
         + '<td class="n">' + (r.insur['4'] ? eok(r.insur['4']) : '—') + '</td><td class="n">' + (r.insur['2'] ? eok(r.insur['2']) : '—') + '</td>'
         + '<td class="n">' + (r.pats || '—') + '</td><td class="n">' + (r.admdays ? num(r.admdays) : '—') + '</td><td class="n">' + (r.admdays ? Math.round(r.admdays/di) + '명' : '—') + '</td><td class="n">' + (r.admdays ? man(r.totamt/r.admdays) : '—') + '</td><td class="n">' + (r.pats ? man(r.totamt/r.pats) : '—') + '</td>'
         + '<td class="n">' + (r.incnt == null ? '—' : r.incnt) + '</td><td class="n">' + (r.outcnt == null ? '—' : r.outcnt) + '</td><td class="n">' + (r.avgstay == null ? '—' : r.avgstay + '일') + '</td>'
         + (cmp ? '<td class="n">' + (av && Number(av.avgtot) && Number(av.avgpats) ? man(Number(av.avgtot)/Number(av.avgpats)) + ' <span class="small">(' + av.hosps + '곳)</span>' : '—') + '</td><td class="n">' + (av && Number(av.avgperday) ? man(av.avgperday) : '—') + '</td>' : '') + '</tr>';
    });
    if (!any) h += '<tr><td colspan="16" class="ms-empty">이 기간에 올린 자료가 없습니다.</td></tr>';
    gel('msTbl').innerHTML = h + '</tbody>';

    // 병상 안내(가동률은 고정경비 화면의 설정에서)
    gel('msBedNote').innerHTML = ' 병상 가동률은 <b>고정경비 → 병원 설정</b>에 허가 병상 수를 넣으면 보입니다.';
  };

  $(function(){ msLoad(); });
})();
</script>
</div><%-- /#misStat --%>
</div><%-- /.dashboard-wrapper --%>
