<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%-- misDrug.jsp — 경영고객관리 › 약제 청구 현황 (2026-10-16, 청구세부통계 Ⅶ 약처방을 별도 화면으로 분리)
     · 기간의 약제비를 청구분 · 정액분 · 합계로 나눠 보여 준다. 정액분 = 정액에 포함되어 따로 청구하지 않는 약(항목 L).
     · 자료는 청구세부통계와 같은 /tong/t_tong08* · t_tong09List 를 쓴다. 기간은 화면에서 고른다(기본 = 최근 청구월까지 6개월).
     · ★주의: 이 파일 안에서 Deferred EL 표기(샵+중괄호) 금지 --%>

<script src="/asset/js/ui-message.js"></script>

<div class="dashboard-wrapper">
<div id="misDrug"data-hosp="<c:out value='${hospCd}'/>" data-nm="<c:out value='${hospNm}'/>">
<style>
  #misDrug{ background:#f4f6f8; color:#1f2a30; min-height:100%; padding:14px 16px 50px; max-width:100%; overflow-x:hidden; }
  #misDrug *{ box-sizing:border-box; }
  #misDrug .dg-head{ display:flex; align-items:center; gap:10px; flex-wrap:wrap; margin-bottom:12px; }
  #misDrug .dg-title{ font-size:18px; font-weight:800; color:#20303a; }
  #misDrug .dg-sub{ font-size:12px; color:#6b7c86; font-weight:400; }
  #misDrug .dg-hosp{ background:#e7f3ee; color:#1f5a4b; font-size:12px; font-weight:800; border:1px solid #cfe3da; border-radius:14px; padding:3px 11px; }
  #misDrug .dg-spacer{ flex:1; }
  #misDrug .dg-card{ background:#fff; border:1px solid #e3e9ed; border-radius:10px; padding:14px 16px; margin-bottom:12px; }
  #misDrug .dg-card h2{ margin:0 0 10px; font-size:15px; color:#20303a; }
  #misDrug .dg-period{ display:flex; gap:8px; align-items:center; flex-wrap:wrap; font-size:13px; color:#43555f; font-weight:700; }
  #misDrug input[type=month]{ border:1px solid #cfd8e0; border-radius:6px; padding:5px 8px; font-size:13px; background:#fff; }
  #misDrug .dg-btn{ border:1px solid #cfd9e0; background:#fff; color:#43555f; border-radius:6px; padding:5px 12px; font-size:12.5px; font-weight:700; cursor:pointer; }
  #misDrug .dg-btn.pri{ background:#1f5a4b; color:#fff; border-color:#1f5a4b; }
  #misDrug .dg-note{ font-size:12px; color:#6b7c86; line-height:1.7; margin-top:8px; }
  #misDrug .dg-prog{ font-size:13px; color:#43555f; padding:16px 4px; }
  #misDrug table{ width:100%; border-collapse:collapse; font-size:13px; }
  #misDrug th{ background:#f2f6f8; font-weight:700; color:#43555f; padding:7px 9px; border-bottom:1px solid #dde5ea; text-align:left; white-space:nowrap; }
  #misDrug td{ padding:6px 9px; border-bottom:1px solid #eef2f5; vertical-align:middle; }
  #misDrug td.n, #misDrug th.n{ text-align:right; font-variant-numeric:tabular-nums; }
  #misDrug tr.tot td{ font-weight:800; background:#f2f6f8; border-top:1px solid #9fb3bd; }
  #misDrug .sub{ color:#8a99a3; }
  #misDrug .dg-link{ color:#1f5a4b; font-weight:800; text-decoration:none; }
  #misDrug .dg-link:hover{ text-decoration:underline; }
  #misDrug .dg-hd{ display:flex; align-items:center; gap:10px; flex-wrap:wrap; }
  #misDrug .dg-hd .dg-spacer{ flex:1; }
  #misDrug .dg-wrap{ overflow-x:auto; }
  #misDrug .dg-scroll{ max-height:690px; overflow:auto; border:1px solid #e3e9ed; border-radius:8px; }
  #misDrug .dg-scroll table{ border-collapse:separate; border-spacing:0; }
  #misDrug .dg-scroll thead th{ position:sticky; top:0; z-index:2; background:#f2f6f8; box-shadow:0 1px 0 #dde5ea; }
  #misDrug .dg-scroll tfoot td{ position:sticky; bottom:0; z-index:2; background:#eef3f6; font-weight:800; border-top:2px solid #9fb3bd; }
</style>

<div class="dg-head">
  <div class="dg-title">약제 청구 현황 <span class="dg-sub">— 품목코드별 청구분 · 정액분 · 합계</span></div>
  
  <span class="dg-hosp">🏥 <c:out value='${hospNm}'/></span>
  <span class="dg-spacer"></span>
  <a class="dg-link" href="/main/misDirector.do">← 청구세부통계로</a>
</div>

<div class="dg-card">
  <div class="dg-period">
    기간
    <input type="month" id="dgFrom"> ~ <input type="month" id="dgTo">
    <button type="button" class="dg-btn pri" id="dgGo">조회</button>
    <span id="dgInfo" class="dg-sub"></span>
  </div>
  <div class="dg-note">청구세부통계와 같은 명세서 기준(위탁 명세서 제외). 기간을 바꾸면 이 화면만 다시 계산한다.</div>
</div>

<div class="dg-card">
  <div id="dgBody"><div class="dg-prog">기간을 고르고 조회를 누르세요.</div></div>
</div>

<script>
(function(){
  var root = document.getElementById('misDrug');
  function g(id){ return document.getElementById(id); }
  function esc(s){ return (s==null?'':String(s)).replace(/[&<>"]/g, function(c){ return ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;'})[c]; }); }
  function num(v){ return Number(v||0).toLocaleString('ko-KR'); }
  function ratio(a, b){ return b ? (Math.round(Number(a||0) / Number(b) * 1000) / 10).toFixed(1) + '%' : '—'; }
  function arr(x){ return Array.isArray(x) ? x : []; }
  function totRow(rows){ return rows.filter(function(r){ return r.medDept === '00' || r.medName === '전체'; })[0] || null; }
  function tr(cells, cls, text){
    return '<tr' + (cls ? ' class="' + cls + '"' : '') + '>' + cells.map(function(c, i){
      var isN = i > 0 && !(text && text.indexOf(i) >= 0);
      return '<td' + (isN ? ' class="n"' : '') + '>' + c + '</td>';
    }).join('') + '</tr>';
  }
  function head(cols, text){
    return '<thead><tr>' + cols.map(function(c, i){
      var isN = i > 0 && !(text && text.indexOf(i) >= 0);
      return '<th' + (isN ? ' class="n"' : '') + '>' + c + '</th>';
    }).join('') + '</tr></thead>';
  }
  function hosp(){ var h = ''; try { h = (getCookie('s_hospid') || '').trim(); } catch(e){} return h || root.getAttribute('data-hosp'); }
  function ymOf(v){ return String(v || '').replace(/[^0-9]/g, '').slice(0, 6); }
  function inp(ym){ return ym ? ym.slice(0, 4) + '-' + ym.slice(4, 6) : ''; }
  function tong(url, p){ p.hospCd = hosp(); return $.ajax({ url:url, type:'POST', data:p, dataType:'json' }); }

  var REQ = 0;
  /* 기간 → 품목코드별 약제비(1개) → 화면 */
  function load(from, to){
    var my = ++REQ;
    g('dgBody').innerHTML = '<div class="dg-prog">약제 자료 불러오는 중…</div>';
    var base = { ipwe:'', medType:'9', jrType:'0', amtType:'1', startMonth: from, endMonth: to };
    tong('/tong/t_drugItemList.do', $.extend({}, base)).then(function(r){
      if (my !== REQ) return;
      render(from, to, { drug: arr(r) });
    }, function(){
      if (my !== REQ) return;
      g('dgBody').innerHTML = '<div class="dg-prog">약제 자료를 불러오지 못했습니다. 기간을 바꾸어 다시 조회하세요.</div>';
    });
  }

  /* 품목별: 청구분 = (정액 명세서 약제비 − 그 중 항목 L) + 정액이 아닌 명세서 약제비 · 정액분 = 항목 L · 합계 = 청구분 + 정액분 */
  function render(from, to, T){
    var rows = T.drug.map(function(r){
      var fixTot = Number(r.fixTotal || 0), fixNc = Number(r.fixNonclaim || 0), prod = Number(r.prodTotal || 0);
      var fixed = fixNc, total = fixTot + prod, claim = total - fixed;
      return { code: r.ediCode || '', name: r.ediName || '', claim: claim, fixed: fixed, total: total, cnt: Number(r.claimCount || 0) };
    }).filter(function(x){ return x.total !== 0; }).sort(function(a, b){ return b.total - a.total; });

    var sumClaim = 0, sumFix = 0, sumTot = 0;
    rows.forEach(function(x){ sumClaim += x.claim; sumFix += x.fixed; sumTot += x.total; });

    var body = rows.map(function(x, i){
      return tr([i + 1, esc(x.code), esc(x.name), num(x.claim), num(x.fixed), num(x.total), ratio(x.total, sumTot), num(x.cnt)], '', [1, 2]);
    }).join('');
    var foot = rows.length ? '<tfoot>' + tr(['합계', '', rows.length + '개 품목', num(sumClaim), num(sumFix), num(sumTot), ratio(sumTot, sumTot), ''], 'tot', [1, 2]) + '</tfoot>' : '';

    var h = '<div class="dg-hd"><h2>품목코드별 약제 청구</h2></div>' +
      (rows.length
        ? '<div class="dg-scroll"><table>' + head(['번호', '품목코드', '품목명', '청구분(원)', '정액분(원)', '합계(원)', '비중', '명세서(건)'], [1, 2]) + '<tbody>' + body + '</tbody>' + foot + '</table></div>'
        : '<div class="dg-prog">해당 기간에 약제 청구 자료가 없습니다.</div>') +
      '<div class="dg-note">합계 = 처방 오더 금액에서 위탁청구(JS008)를 뺀 약제비. 청구분 = 실제로 청구되는 약제비. 정액분 = 정액에 포함되어 따로 청구하지 않는 약(항목 L). 명세서는 그 약이 든 명세서 수다. 합계 순으로 정렬했다.</div>';
    g('dgBody').innerHTML = h;
    g('dgInfo').textContent = inp(from) + ' ~ ' + inp(to) + ' · 품목 ' + rows.length + '개 · 합계 ' + num(sumTot) + '원';
  }

  window.dgSearch = function(){
    var f = ymOf(g('dgFrom').value), t = ymOf(g('dgTo').value);
    if (!f || !t || f.length !== 6 || t.length !== 6) { _alertBox('시작월과 종료월을 고르세요.', {icon:'⚠️'}); return; }
    if (f > t) { var x = f; f = t; t = x; g('dgFrom').value = inp(f); g('dgTo').value = inp(t); }
    load(f, t);
  };

  /* 처음 열 때 기간 기본값 = 청구세부통계와 같은 규칙(최근 청구월까지 6개월) */
  $(function(){
    $.ajax({ url:'/mis/directorGet.do', type:'POST', data:{ hospCd: hosp(), fromYm:'', toYm:'' }, dataType:'json' }).then(function(d){
      var to = ymOf(d && d.ym), from = ymOf(d && d.fromYm) || to;
      if (!to) { g('dgBody').innerHTML = '<div class="dg-prog">청구 자료가 없어 약제 현황을 만들 수 없습니다.</div>'; return; }
      g('dgFrom').value = inp(from); g('dgTo').value = inp(to);
      load(from, to);
    }, function(){ g('dgBody').innerHTML = '<div class="dg-prog">기간을 가져오지 못했습니다. 기간을 고르고 조회를 누르세요.</div>'; });
    g('dgGo').addEventListener('click', window.dgSearch);
  });
})();
</script>
</div>
</div>
