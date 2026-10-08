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
    <div id="msChart"></div>
    <div class="legend"><span><i style="background:#1f5a4b"></i>우리 병원</span><span id="msLegAvg"><i style="background:#cfd8e0"></i>위너넷 고객 평균 (병원명 없이)</span></div>
    <div class="small" id="msChartNote" style="margin-top:6px;"></div>
  </div>
  <div class="ms-card">
    <h4 id="msClsTtl">환자군 구성</h4>
    <div class="stack" id="msStack"></div>
    <div class="small" id="msClsNote"></div>
    <div class="ms-wrap"><table id="msClsTbl"></table></div>
  </div>
</div>

<div class="ms-card">
  <h4>월별 상세</h4>
  <div class="ms-wrap"><table id="msTbl"><tbody><tr><td class="ms-empty">불러오는 중…</td></tr></tbody></table></div>
  <div class="small" style="margin-top:6px;">총진료비 = 급여(공단) + 본인부담. 환자 1인 1일 진료비 = 총진료비 ÷ 입원일수. 평균 재원 = 입원일수 ÷ 그 달 일수. 퇴원자 평균 재원일수 = 그 달 퇴원한 환자의 입원일~퇴원일.</div>
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
    var a = B.avg[cur.ym], aPrev = prev ? B.avg[prev.ym] : null;
    var avgPerDay = a && Number(a.avgperday) ? Number(a.avgperday) : (aPrev && Number(aPrev.avgperday) ? Number(aPrev.avgperday) : 0);
    var avgPerDayYm = a && Number(a.avgperday) ? cur.ym : (aPrev ? prev.ym : '');

    // KPI
    var k = '';
    k += '<div class="ms-kpi"><div class="l">월 총진료비 (급여+본인부담) · ' + esc(ymLbl(cur.ym)) + '</div><div class="v">' + (cur.totamt ? eok(cur.totamt) : '—') + '</div><div class="d ' + (prev && cur.totamt >= prev.totamt ? 'up' : 'down') + '">' + (prev ? esc(pct(cur.totamt, prev.totamt)) + ' 전월 ' + eok(prev.totamt) : '전월 자료 없음') + '</div></div>';
    k += '<div class="ms-kpi"><div class="l">평균 재원 환자 (일)</div><div class="v">' + (census ? Math.round(census) + '명' : '—') + '</div><div class="d">입원일수 ' + num(cur.admdays) + '일 ÷ ' + dIn + '</div></div>';
    k += '<div class="ms-kpi"><div class="l">입원 / 퇴원</div><div class="v">' + (cur.incnt == null ? '—' : cur.incnt + ' / ' + cur.outcnt) + '</div><div class="d">' + (prev && prev.incnt != null ? '전월 ' + prev.incnt + ' / ' + prev.outcnt : '입퇴원현황 기준') + '</div></div>';
    k += '<div class="ms-kpi"><div class="l">환자 1인 1일 진료비</div><div class="v">' + (perDay ? man(perDay) : '—') + '</div><div class="d ' + (avgPerDay && perDay >= avgPerDay ? 'up' : 'down') + '">' + (cmp && avgPerDay ? '고객 평균 ' + man(avgPerDay) + ' (' + esc(ymShort(avgPerDayYm)) + ')' : '총진료비 ÷ 입원일수') + '</div></div>';
    gel('msKpis').innerHTML = k;

    // 막대 — 총진료비(우리) vs 고객 평균
    var maxV = 0; L.forEach(function(r){ maxV = Math.max(maxV, r.totamt, cmp && B.avg[r.ym] ? Number(B.avg[r.ym].avgtot||0) : 0); });
    var top = Math.max(1, Math.ceil(maxV / 100000000)), H = 120, base = 140, W = 420, n = L.length, slot = (W - 40) / n;
    var svg = '<svg viewBox="0 0 ' + W + ' 170" role="img" aria-label="월 총진료비 막대그래프">';
    svg += '<line x1="34" y1="' + base + '" x2="' + (W-10) + '" y2="' + base + '" stroke="#dde5ea"/><line x1="34" y1="20" x2="34" y2="' + base + '" stroke="#dde5ea"/>';
    svg += '<text x="6" y="' + (base+4) + '">0</text><text x="6" y="' + (base - H/2 + 4) + '">' + (top/2) + '</text><text x="6" y="24">' + top + '</text>';
    L.forEach(function(r, i){
      var x = 40 + i * slot, bw = cmp ? Math.min(24, slot*0.36) : Math.min(34, slot*0.6);
      var h = r.totamt / (top*100000000) * H, y = base - h;
      if (r.totamt > 0) svg += '<rect x="' + (x + (cmp ? 0 : (slot - bw)/2 - 0)) + '" y="' + y.toFixed(1) + '" width="' + bw + '" height="' + h.toFixed(1) + '" fill="#1f5a4b"/><text class="lbl" x="' + (x + bw/2 + (cmp ? 0 : (slot-bw)/2)) + '" y="' + (y-4).toFixed(1) + '" text-anchor="middle">' + (r.totamt/100000000).toFixed(2) + '</text>';
      if (cmp && B.avg[r.ym]) { var av = Number(B.avg[r.ym].avgtot||0), ah = av/(top*100000000)*H, ay = base - ah, few = Number(B.avg[r.ym].hosps||0) < 20;
        svg += '<rect x="' + (x + bw + 2) + '" y="' + ay.toFixed(1) + '" width="' + bw + '" height="' + ah.toFixed(1) + '" fill="#cfd8e0"' + (few ? ' opacity=".5"' : '') + '/><text x="' + (x + bw + 2 + bw/2) + '" y="' + (ay-4).toFixed(1) + '" text-anchor="middle">' + (few ? '집계중' : (av/100000000).toFixed(2)) + '</text>'; }
      svg += '<text x="' + (x + slot/2 - 4) + '" y="156" text-anchor="middle">' + esc(ymShort(r.ym)) + '</text>';
    });
    svg += '</svg>';
    gel('msChart').innerHTML = svg;
    gel('msLegAvg').style.display = cmp ? '' : 'none';
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
    var h = '<thead><tr><th>월</th><th class="n">총진료비</th><th class="n">급여(공단)</th><th class="n">본인부담</th><th class="n">건강보험</th><th class="n">의료급여</th><th class="n">환자</th><th class="n">입원일수</th><th class="n">평균 재원</th><th class="n">1인 1일</th><th class="n">입원</th><th class="n">퇴원</th><th class="n">퇴원자 평균 재원일</th>' + (cmp ? '<th class="n">고객 평균 진료비</th><th class="n">고객 평균 1인 1일</th>' : '') + '</tr></thead><tbody>';
    var any = false;
    L.forEach(function(r){
      if (!r.totamt && r.incnt == null && !(r.cls.A+r.cls.B+r.cls.C+r.cls.D+r.cls.E)) return; any = true;
      var di = daysIn(r.ym), av = B.avg[r.ym];
      h += '<tr><td>' + esc(ymLbl(r.ym)) + '</td><td class="n">' + (r.totamt ? eok(r.totamt) : '—') + '</td><td class="n">' + (r.claimamt ? eok(r.claimamt) : '—') + '</td><td class="n">' + (r.selfamt ? eok(r.selfamt) : '—') + '</td>'
         + '<td class="n">' + (r.insur['4'] ? eok(r.insur['4']) : '—') + '</td><td class="n">' + (r.insur['2'] ? eok(r.insur['2']) : '—') + '</td>'
         + '<td class="n">' + (r.pats || '—') + '</td><td class="n">' + (r.admdays ? num(r.admdays) : '—') + '</td><td class="n">' + (r.admdays ? Math.round(r.admdays/di) + '명' : '—') + '</td><td class="n">' + (r.admdays ? man(r.totamt/r.admdays) : '—') + '</td>'
         + '<td class="n">' + (r.incnt == null ? '—' : r.incnt) + '</td><td class="n">' + (r.outcnt == null ? '—' : r.outcnt) + '</td><td class="n">' + (r.avgstay == null ? '—' : r.avgstay + '일') + '</td>'
         + (cmp ? '<td class="n">' + (av && Number(av.avgtot) ? eok(av.avgtot) + ' <span class="small">(' + av.hosps + '곳)</span>' : '—') + '</td><td class="n">' + (av && Number(av.avgperday) ? man(av.avgperday) : '—') + '</td>' : '') + '</tr>';
    });
    if (!any) h += '<tr><td colspan="15" class="ms-empty">이 기간에 올린 자료가 없습니다.</td></tr>';
    gel('msTbl').innerHTML = h + '</tbody>';

    // 병상 안내(가동률은 고정경비 화면의 설정에서)
    gel('msBedNote').innerHTML = ' 병상 가동률은 <b>고정경비 → 병원 설정</b>에 허가 병상 수를 넣으면 보입니다.';
  };

  $(function(){ msLoad(); });
})();
</script>
</div><%-- /#misStat --%>
</div><%-- /.dashboard-wrapper --%>
