<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%-- misDirector.jsp — 경영고객관리 › 병원장 조회 (2026-10-15, 수익·비용 중심으로 개편)
     · 신규 요양병원의 경영 쪽은 수익과 비용 지출을 가장 중요하게 본다. 그래서 이 화면은
         ① 이번 달 수익 · 비용 · 추정 손익(KPI) ② 12개월 수익·비용 추이 ③ 비용 지출 명세 ④ 수익 구성과 손익분기 ⑤ 운영 한눈(한 줄).
     · 계산식은 고정경비 관리(misCost)와 같다: 수익 = 총진료비 + 추가수익, 비용 = 고정비 + 1인 1일 변동비 × 입원일수, 손익 = 수익 − 비용.
     · 새로 적는 칸은 없다. 고정경비를 입력하면 손익이 계산된다(없으면 안내).
     · 알림은 ui-message. ★주의: 이 파일 안에서 Deferred EL 표기(샵+중괄호) 금지 --%>

<script src="/asset/js/ui-message.js"></script>

<div class="dashboard-wrapper">
<div id="misDirector" data-wnn="<c:out value='${wnnYn}'/>" data-hosp="<c:out value='${hospCd}'/>" data-nm="<c:out value='${hospNm}'/>">
<style>
  #misDirector{ background:#f4f6f8; color:#1f2a30; min-height:100%; padding:14px 16px 50px; max-width:100%; overflow-x:hidden; }
  #misDirector *{ box-sizing:border-box; }
  #misDirector .md-head{ display:flex; align-items:center; gap:10px; margin-bottom:6px; flex-wrap:wrap; }
  #misDirector .md-title{ font-size:18px; font-weight:800; color:#20303a; display:flex; align-items:center; gap:8px; }
  #misDirector .md-dot{ width:10px; height:10px; border-radius:50%; background:linear-gradient(135deg,#1f5a4b,#2a7665); }
  #misDirector .md-sub{ font-size:12px; color:#6b7c86; font-weight:400; }
  #misDirector .md-hosp{ background:#e7f3ee; color:#1f5a4b; font-size:12px; font-weight:800; border:1px solid #cfe3da; border-radius:14px; padding:3px 11px; }
  #misDirector .md-spacer{ flex:1; }
  #misDirector .md-btn{ border:1px solid #cfd9e0; background:#fff; color:#43555f; border-radius:6px; padding:5px 11px; font-size:12.5px; font-weight:700; cursor:pointer; text-decoration:none; white-space:nowrap; }
  #misDirector .md-btn:hover{ background:#eef3f6; }
  #misDirector .md-note{ background:#fff; border:1px solid #e3e9ed; border-radius:10px; padding:9px 14px; font-size:12.5px; color:#43555f; margin:10px 0 12px; line-height:1.6; }
  #misDirector .md-note.warn{ background:#fff7e6; border-color:#f1d9a6; color:#7a5a12; }
  #misDirector .md-kpis{ display:grid; grid-template-columns:repeat(auto-fit,minmax(170px,1fr)); gap:10px; margin-bottom:12px; }
  #misDirector .md-kpi{ background:#fff; border:1px solid #e3e9ed; border-radius:12px; padding:12px 14px; min-width:0; }
  #misDirector .md-kpi .l{ font-size:12px; color:#6b7c86; font-weight:700; }
  #misDirector .md-kpi .v{ font-size:23px; font-weight:800; color:#1f5a4b; line-height:1.25; font-variant-numeric:tabular-nums; margin-top:2px; }
  #misDirector .md-kpi .v.down{ color:#b23b3b; }
  #misDirector .md-kpi .v.up{ color:#1f5a4b; }
  #misDirector .md-kpi .v.none{ color:#9aa8b0; font-size:17px; }
  #misDirector .md-kpi .d{ font-size:11.5px; color:#6b7c86; margin-top:3px; line-height:1.45; }
  #misDirector .md-kpi.profit{ background:#e7f3ee; border-color:#1f5a4b; }
  #misDirector .md-card{ background:#fff; border:1px solid #e3e9ed; border-radius:12px; padding:12px 14px; min-width:0; margin-bottom:12px; }
  #misDirector .md-card h4{ margin:0 0 8px; font-size:13px; color:#43555f; font-weight:800; display:flex; gap:8px; align-items:center; flex-wrap:wrap; }
  #misDirector .md-card h4 .sp{ flex:1; }
  #misDirector .md-cols{ display:grid; grid-template-columns:minmax(0,1.2fr) minmax(0,1fr); gap:12px; align-items:start; }
  @media (max-width:1000px){ #misDirector .md-cols{ grid-template-columns:1fr; } }
  #misDirector .md-scroll{ overflow-x:auto; }
  #misDirector table{ width:100%; border-collapse:collapse; font-size:12.5px; }
  #misDirector th{ background:#f2f6f8; color:#43555f; font-weight:800; padding:6px 7px; border-bottom:1px solid #dde5ea; text-align:left; white-space:nowrap; }
  #misDirector td{ padding:6px 7px; border-bottom:1px solid #eef2f5; vertical-align:middle; }
  #misDirector td.n, #misDirector th.n{ text-align:right; font-variant-numeric:tabular-nums; white-space:nowrap; }
  #misDirector tr.tot td{ font-weight:800; background:#f7f9fa; border-top:1px solid #cfd8e0; }
  #misDirector tr.sub td{ color:#6b7c86; font-size:12px; }
  #misDirector .up{ color:#1f5a4b; font-weight:700; }
  #misDirector .down{ color:#b23b3b; font-weight:700; }
  #misDirector .bep{ border:2px solid #1f5a4b; border-radius:10px; padding:12px 14px; background:#e7f3ee; }
  #misDirector .bep .big{ font-size:30px; font-weight:900; line-height:1.1; color:#20303a; font-variant-numeric:tabular-nums; }
  #misDirector .bep .brow{ display:flex; justify-content:space-between; gap:10px; font-size:13px; padding:4px 0; border-top:1px dashed #cfe3da; }
  #misDirector .bep .brow:first-of-type{ border-top:0; }
  #misDirector .md-chart{ position:relative; height:260px; }
  #misDirector .md-one{ display:flex; gap:14px; flex-wrap:wrap; font-size:12.5px; color:#43555f; }
  #misDirector .md-one a{ color:#1f5a4b; font-weight:800; text-decoration:none; }
  #misDirector .md-one a:hover{ text-decoration:underline; }
  #misDirector .md-empty{ font-size:12.5px; color:#8a99a3; line-height:1.6; padding:8px 0; }
  #misDirector .md-link{ font-size:12.5px; color:#1f5a4b; font-weight:800; text-decoration:none; }
  #misDirector .md-link:hover{ text-decoration:underline; }
</style>

<div class="md-head">
  <div class="md-title"><span class="md-dot"></span> 병원장 조회 <span class="md-sub">— 수익 · 비용 · 손익 (경영 쪽 한눈)</span></div>
  <span class="md-hosp" id="mdHosp"></span>
  <span class="md-spacer"></span>
  <span class="md-sub" id="mdAsOf"></span>
  <button type="button" class="md-btn" id="mdReload">↻ 다시 보기</button>
</div>

<div class="md-note" id="mdNote" hidden></div>

<div class="md-kpis" id="mdKpis"><div class="md-kpi"><div class="l">불러오는 중</div><div class="v none">–</div></div></div>

<div class="md-card">
  <h4>12개월 수익 · 비용 · 손익 추이 <span class="sp"></span><span class="md-sub" id="mdTrendSub"></span></h4>
  <div class="md-chart"><canvas id="mdChart"></canvas></div>
  <div class="md-empty" id="mdChartNote"></div>
</div>

<div class="md-cols">
  <!-- 비용 지출 명세 -->
  <div class="md-card">
    <h4>비용 지출 명세 <span class="sp"></span><a class="md-link" href="/main/misCost.do">고정경비 관리 →</a></h4>
    <div class="md-scroll">
      <table>
        <thead><tr><th>항목</th><th class="n">이번 달</th><th class="n">전월</th><th class="n">증감</th><th class="n">비중</th></tr></thead>
        <tbody id="mdExp"><tr><td colspan="5" class="md-empty">불러오는 중…</td></tr></tbody>
      </table>
    </div>
  </div>

  <!-- 수익 구성 · 손익분기 -->
  <div>
    <div class="md-card">
      <h4>수익 구성 <span class="sp"></span><span class="md-sub" id="mdRevSub"></span></h4>
      <div class="md-scroll">
        <table>
          <thead><tr><th>항목</th><th class="n">금액</th><th class="n">비중</th></tr></thead>
          <tbody id="mdRev"><tr><td colspan="3" class="md-empty">불러오는 중…</td></tr></tbody>
        </table>
      </div>
    </div>
    <div class="bep" id="mdBep"><div class="md-empty">불러오는 중…</div></div>
  </div>
</div>

<div class="md-card">
  <h4>운영 한눈 <span class="sp"></span><span class="md-sub">수익·비용에 영향을 주는 것만 한 줄로</span></h4>
  <div class="md-one" id="mdOps"><span>불러오는 중…</span></div>
</div>

<script>
(function(){
  var root = document.getElementById('misDirector');
  var WNN = root.getAttribute('data-wnn') === 'Y';
  var VAR_DEF = 25000;             // 1인 1일 변동비 기본값 — 고정경비 관리(misCost)와 같다
  var D = null, C = null;          // D = 병원장 한 장(directorGet), C = 고정경비 자료(costGet)
  function g(id){ return document.getElementById(id); }
  function esc(s){ return (s==null?'':String(s)).replace(/[&<>"]/g, function(c){ return ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;'})[c]; }); }
  function num(v){ return Number(v||0).toLocaleString('ko-KR'); }
  function eok(v){ v = Number(v||0); return (v/100000000).toFixed(2) + '억'; }
  function man(v){ v = Number(v||0); return Math.round(v/10000).toLocaleString('ko-KR') + '만'; }
  function sgn(v, f){ return (v >= 0 ? '+' : '−') + f(Math.abs(v)); }
  function pct(a, b){ return b ? Math.round(a / b * 1000) / 10 + '%' : '—'; }
  function ymLbl(ym){ return ym ? (ym.slice(0,4) + '년 ' + Number(ym.slice(4,6)) + '월') : ''; }
  function ymShort(ym){ return ym ? (Number(ym.slice(4,6)) + '월') : ''; }
  function daysIn(ym){ return new Date(Number(ym.slice(0,4)), Number(ym.slice(4,6)), 0).getDate(); }
  function addYm(ym, n){ var y = Number(ym.slice(0,4)), m = Number(ym.slice(4,6)) - 1 + n; y += Math.floor(m/12); m = ((m%12)+12)%12; return y + String(m+1).padStart(2,'0'); }
  function err(e){ _alertBox((e && e.message) ? e.message : '처리 중 오류가 발생했습니다.', {icon:'❌'}); }
  function post(url, data){
    if (WNN) {
      var h = '';
      try { h = (getCookie('s_hospid') || '').trim(); } catch(e){}
      data.hospCd = h || root.getAttribute('data-hosp');
    }
    return $.ajax({ url:url, type:'POST', data:data, dataType:'json' }).then(function(res){
      if (res && res.result === 'FAIL') throw new Error(res.message || '처리에 실패했습니다.');
      return res;
    });
  }

  /* ── 계산: 고정경비 관리와 같은 식 ── */
  function calc(ym, cl, io){
    var cfg = (C && C.cfg) || {};
    var varC = cfg.varcostday == null ? VAR_DEF : Number(cfg.varcostday);
    var bed = Number(cfg.bedcnt || 0);
    var costMap = {}, prevMap = {};
    ((C && C.cost) || []).forEach(function(x){ costMap[x.catcd] = Number(x.amt || 0); });
    ((C && C.prevCost) || []).forEach(function(x){ prevMap[x.catcd] = Number(x.amt || 0); });
    var fixed = [], extra = [], prevFixed = 0, prevExtra = 0, hasPrev = false;
    ((C && C.cats) || []).filter(function(c){ return c.useyn !== 'N'; }).forEach(function(c){
      var v = costMap[c.catcd], pv = prevMap[c.catcd];
      if (pv != null) { hasPrev = true; if (c.catgb === 'R') prevExtra += pv; else prevFixed += pv; }
      if (v == null) return;                              // 입력된 항목만 센다
      (c.catgb === 'R' ? extra : fixed).push({ nm: c.catnm, amt: v, prev: pv == null ? null : pv });
    });
    fixed.sort(function(a, b){ return b.amt - a.amt; });
    var fixedTot = fixed.reduce(function(s, x){ return s + x.amt; }, 0);
    var extraTot = extra.reduce(function(s, x){ return s + x.amt; }, 0);
    var tot = cl ? Number(cl.totamt || 0) : 0, days = cl ? Number(cl.admdays || 0) : 0;
    var varTot = varC * days;
    var revenue = tot + extraTot, expense = fixedTot + varTot;
    var profit = (cl && fixedTot) ? revenue - expense : null;
    var dIn = daysIn(ym), census = days ? days / dIn : 0;
    var perDay = days ? tot / days : 0, contrib = perDay - varC;
    var bep = (contrib > 0 && fixedTot) ? Math.ceil(fixedTot / (contrib * dIn)) : null;
    return { varC:varC, bed:bed, fixed:fixed, extra:extra, fixedTot:fixedTot, extraTot:extraTot, tot:tot, days:days,
             varTot:varTot, revenue:revenue, expense:expense, profit:profit, census:census, bep:bep, contrib:contrib,
             prevFixed: hasPrev ? prevFixed : null, prevExtra: hasPrev ? prevExtra : null, dIn:dIn, prevYm:(C && C.prevYm) || '' };
  }

  /* ── 12개월 추이 ── */
  function trendRows(ym){
    var claim = {}, cost = {};
    ((C && C.trendClaim) || []).forEach(function(r){ claim[r.ym] = r; });
    ((C && C.trend) || []).forEach(function(r){ cost[r.ym] = r; });
    var cfg = (C && C.cfg) || {}, varC = cfg.varcostday == null ? VAR_DEF : Number(cfg.varcostday);
    var out = [], m = addYm(ym, -11);
    for (var i = 0; i < 12; i++, m = addYm(m, 1)) {
      var c = claim[m], t = cost[m];
      var tot = c ? Number(c.totamt || 0) : 0, days = c ? Number(c.admdays || 0) : 0;
      var fx = t ? Number(t.costamt || 0) : 0, ex = t ? Number(t.extraamt || 0) : 0;
      var rev = (c || t) ? tot + ex : null;
      var exp = (c && fx) ? fx + varC * days : null;
      out.push({ ym:m, rev:c ? rev : null, exp:exp, profit:(c && fx) ? rev - exp : null });
    }
    return out;
  }

  function drawChart(rows){
    var note = g('mdChartNote');
    var any = rows.some(function(r){ return r.rev != null || r.exp != null; });
    if (!any) { note.textContent = '아직 청구 자료나 고정경비 입력이 없어 추이를 그릴 수 없습니다.'; }
    else note.textContent = '막대 = 수익(진한 초록)·비용(주황) · 선 = 추정 손익(빨강 · 음수면 적자). 단위 만원.';
    if (typeof Chart === 'undefined') { note.textContent = '차트 라이브러리를 불러오지 못했습니다. 아래 표와 KPI 를 보세요.'; return; }
    if (window._mdChart) { try { window._mdChart.destroy(); } catch(e){} window._mdChart = null; }
    var u = function(v){ return v == null ? null : Math.round(v / 10000); };
    window._mdChart = new Chart(g('mdChart'), {
      type: 'bar',
      data: {
        labels: rows.map(function(r){ return ymShort(r.ym); }),
        datasets: [
          { label:'수익', data: rows.map(function(r){ return u(r.rev); }), backgroundColor:'rgba(31,90,75,0.78)' },
          { label:'비용', data: rows.map(function(r){ return u(r.exp); }), backgroundColor:'rgba(214,137,16,0.78)' },
          { type:'line', label:'추정 손익', data: rows.map(function(r){ return u(r.profit); }),
            borderColor:'#b23b3b', backgroundColor:'#b23b3b', fill:false, tension:0.25, pointRadius:3 }
        ]
      },
      options: {
        responsive: true, maintainAspectRatio: false,
        plugins: { legend: { display:true, position:'bottom', labels:{ boxWidth:12, padding:10, font:{ size:11 } } } },
        scales: {
          y: { grid:{ color:'rgba(0,0,0,0.05)' }, ticks:{ callback:function(v){ return v.toLocaleString('ko-KR') + '만'; }, font:{ size:11 } } },
          x: { grid:{ display:false }, ticks:{ font:{ size:11 } } }
        }
      }
    });
  }

  /* ── 그리기 ── */
  function drawKpis(M){
    var ok = M.fixedTot > 0 && M.tot > 0;
    var expD = M.prevFixed == null ? '전월 고정비 없음' : ('전월 고정비 ' + eok(M.prevFixed) + ' · ' + (M.fixedTot >= M.prevFixed ? '▲ ' : '▼ ') + pct(Math.abs(M.fixedTot - M.prevFixed), M.prevFixed));
    var kp = [
      { l:'이번 달 수익', v: M.revenue ? eok(M.revenue) : '—', cls: M.revenue ? '' : 'none',
        d: (M.tot ? '청구 총진료비 ' + eok(M.tot) : '청구 자료 없음') + (M.extraTot ? ' + 추가수익 ' + man(M.extraTot) : '') },
      { l:'이번 달 비용', v: M.expense ? eok(M.expense) : '—', cls: M.expense ? '' : 'none',
        d: '고정비 ' + (M.fixedTot ? eok(M.fixedTot) : '—') + ' + 변동비 ' + (M.days ? man(M.varTot) : '—') },
      { l:'추정 손익', v: M.profit == null ? '—' : sgn(M.profit, eok), cls: M.profit == null ? 'none' : (M.profit >= 0 ? 'up' : 'down'), profit:true,
        d: M.profit == null ? '고정경비를 입력하면 계산됩니다' : (M.profit >= 0 ? '흑자' : '적자') + ' · 수익 − 비용' },
      { l:'손익분기 재원 환자', v: M.bep ? M.bep + '명' : '—', cls: M.bep ? (M.census >= M.bep ? 'up' : 'down') : 'none',
        d: M.bep ? '평균 재원 ' + Math.round(M.census) + '명 · ' + (M.census >= M.bep ? '여유 ' : '부족 ') + Math.abs(Math.round(M.census - M.bep)) + '명' : '고정비·청구가 둘 다 있어야 계산됩니다' },
      { l:'가동률', v: M.bed ? pct(M.census, M.bed) : '—', cls: M.bed ? '' : 'none',
        d: M.bed ? '평균 재원 ' + Math.round(M.census) + ' / 병상 ' + M.bed : '병상 수를 고정경비 관리에서 입력하세요' },
      { l:'고정비 전월 대비', v: M.prevFixed == null ? '—' : sgn(M.fixedTot - M.prevFixed, man), cls: M.prevFixed == null ? 'none' : (M.fixedTot > M.prevFixed ? 'down' : 'up'), d: expD }
    ];
    g('mdKpis').innerHTML = kp.map(function(k){
      return '<div class="md-kpi' + (k.profit ? ' profit' : '') + '"><div class="l">' + esc(k.l) + '</div>' +
             '<div class="v ' + (k.cls || '') + '">' + esc(k.v) + '</div><div class="d">' + esc(k.d) + '</div></div>';
    }).join('');
  }

  function drawExp(M){
    var rows = [], total = M.expense || 0;
    var prevTotal = M.prevFixed == null ? null : M.prevFixed;
    M.fixed.forEach(function(x){
      rows.push('<tr><td>' + esc(x.nm) + '</td><td class="n">' + num(x.amt) + '</td><td class="n">' + (x.prev == null ? '—' : num(x.prev)) + '</td>' +
        '<td class="n ' + (x.prev == null ? '' : (x.amt > x.prev ? 'down' : (x.amt < x.prev ? 'up' : ''))) + '">' +
        (x.prev == null ? '—' : sgn(x.amt - x.prev, num)) + '</td><td class="n">' + pct(x.amt, total) + '</td></tr>');
    });
    if (M.days) {
      rows.push('<tr class="sub"><td>환자 변동비 (1인 1일 ' + num(M.varC) + '원 × ' + num(M.days) + '일)</td><td class="n">' + num(M.varTot) + '</td>' +
        '<td class="n">—</td><td class="n">—</td><td class="n">' + pct(M.varTot, total) + '</td></tr>');
    }
    if (!rows.length) rows.push('<tr><td colspan="5" class="md-empty">아직 입력된 고정비가 없습니다. <a class="md-link" href="/main/misCost.do">고정경비 관리</a>에서 항목별 금액을 적으세요.</td></tr>');
    else rows.push('<tr class="tot"><td>비용 합계</td><td class="n">' + num(total) + '</td><td class="n">' + (prevTotal == null ? '—' : num(prevTotal)) + '</td><td class="n"></td><td class="n">100%</td></tr>');
    g('mdExp').innerHTML = rows.join('');
  }

  function drawRev(M, cl){
    var rev = M.revenue || 0, rows = [];
    if (cl) rows.push('<tr><td>총진료비 (청구)</td><td class="n">' + num(M.tot) + '</td><td class="n">' + pct(M.tot, rev) + '</td></tr>');
    M.extra.forEach(function(x){ rows.push('<tr><td>' + esc(x.nm) + ' <span class="md-sub">(추가수익)</span></td><td class="n">' + num(x.amt) + '</td><td class="n">' + pct(x.amt, rev) + '</td></tr>'); });
    if (!cl) rows.push('<tr><td colspan="3" class="md-empty">청구 자료가 없어 수익을 계산하지 못했습니다. 청구 샘파일을 올리면 채워집니다.</td></tr>');
    else rows.push('<tr class="tot"><td>수익 합계</td><td class="n">' + num(rev) + '</td><td class="n">100%</td></tr>');
    g('mdRev').innerHTML = rows.join('');
    g('mdRevSub').textContent = cl ? (ymLbl(M.ym) + ' · 청구 ' + (M.days ? num(M.days) + '일' : '')) : '';
  }

  function drawBep(M){
    var b = '<h4 style="margin:0 0 6px;font-size:13px;color:#1f5a4b;">손익분기 (BEP)</h4>';
    if (M.bep) {
      var gap = M.census - M.bep;
      b += '<div class="big">' + M.bep + '명</div><div class="md-sub" style="margin-bottom:6px;">이 인원 이상 재원하면 고정비를 넘깁니다</div>' +
           '<div class="brow"><span>평균 재원 (실제)</span><b>' + Math.round(M.census) + '명</b></div>' +
           '<div class="brow"><span>' + (gap >= 0 ? '현재 여유' : '현재 부족') + ' (' + Math.round(M.census) + ' − ' + M.bep + ')</span><b class="' + (gap >= 0 ? 'up' : 'down') + '">' + (gap >= 0 ? '+' : '') + Math.round(gap) + '명</b></div>' +
           '<div class="brow"><span>환자 1인 1일 기여</span><b>' + num(Math.round(M.contrib)) + '원</b></div>';
    } else {
      b += '<div class="md-empty">고정비와 청구 자료가 둘 다 있어야 손익분기를 계산합니다.</div>';
    }
    g('mdBep').innerHTML = b;
  }

  function drawOps(d){
    var sh = Number(d.short || 0);
    var items = [
      '<span><b>재원 ' + num(d.pats) + '명</b>' + (Number(d.noTel||0) > 0 ? ' · 보호자 연락처 없음 <b class="down">' + num(d.noTel) + '명</b>' : '') + ' <a href="/main/misPatient.do">원무 환자고객 →</a></span>',
      d.nurseErr ? '<span>간호사 관리: 인력 변동 기록 표가 아직 없습니다 (DDL 실행 후 표시) <a href="/main/misNurse.do">간호사 관리 →</a></span>' : '<span>간호사 <b>' + num(d.headcount) + '명</b>' + (sh > 0 ? ' · <b class="down">' + num(sh) + '명 부족</b>' : '') + ' <a href="/main/misNurse.do">간호사 관리 →</a></span>',
      '<span>이번 달 상담 <b>' + num(d.leads) + '건</b> · 입원 전환 <b>' + num(d.admits) + '명</b> <a href="/main/misLead.do">고객관리 →</a></span>',
      '<span>챙길 일 <b class="' + (Number(d.bad||0) > 0 ? 'down' : '') + '">급함 ' + num(d.bad) + '</b> · 확인 ' + num(d.warn) + ' <a href="/main/misAlert.do">업무 알림 →</a></span>'
    ];
    g('mdOps').innerHTML = items.join('');
  }

  function render(){
    var ym = D.ym || '';
    var cl = D.claim || null, io = D.inout || null;
    g('mdHosp').textContent = root.getAttribute('data-nm') || '';
    g('mdAsOf').textContent = (D.today ? ('기준일 ' + D.today.slice(0,4) + '.' + D.today.slice(4,6) + '.' + D.today.slice(6,8)) : '');
    if (!ym) {
      g('mdNote').hidden = false; g('mdNote').className = 'md-note warn';
      g('mdNote').innerHTML = '청구 자료가 아직 없습니다. <a class="md-link" href="/main/magamFileUpload.do">청구·평가 업로드</a>에서 청구 샘파일을 올리면 수익·손익이 계산됩니다.';
    }
    var M = calc(ym || (D.today || '').slice(0,6), cl, io);
    M.ym = ym;
    M.days = M.days || 0;
    var notes = [];
    if (!M.fixedTot) notes.push('고정경비가 아직 없습니다. <a class="md-link" href="/main/misCost.do">고정경비 관리</a>에서 월 고정비를 입력하면 비용·손익이 계산됩니다.');
    if (!M.bed) notes.push('병상 수가 없어 가동률은 빈칸입니다.');
    if (notes.length) { g('mdNote').hidden = false; g('mdNote').className = 'md-note warn'; g('mdNote').innerHTML = notes.join('<br>'); }
    else g('mdNote').hidden = true;
    g('mdTrendSub').textContent = ym ? ('최근 12개월 · ' + ymLbl(addYm(ym, -11)) + ' ~ ' + ymLbl(ym)) : '';
    drawKpis(M);
    drawExp(M);
    drawRev(M, cl);
    drawBep(M);
    drawOps(D);
    drawChart(trendRows(ym || (D.today || '').slice(0,6)));
  }

  function load(){
    g('mdKpis').innerHTML = '<div class="md-kpi"><div class="l">불러오는 중</div><div class="v none">–</div></div>';
    post('/mis/directorGet.do', {}).then(function(d){
      D = d;
      return post('/mis/costGet.do', { ym: d.ym || '' }).then(function(c){ C = c; return d; }, function(){ C = null; return d; });
    }).then(render).catch(function(e){
      g('mdKpis').innerHTML = '<div class="md-kpi"><div class="l">불러오지 못했습니다</div><div class="v none" style="font-size:13px;color:#b23b3b;">' + esc(e && e.message) + '</div></div>';
      err(e);
    });
  }

  g('mdReload').onclick = load;
  load();
})();
</script>
</div>
</div>
