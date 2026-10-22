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
  #misDrug .dg-scroll{ max-height:760px; overflow:auto; border:1px solid #e3e9ed; border-radius:8px; }
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
    $.when(tong('/tong/t_drugItemList.do', $.extend({}, base)), tong('/tong/t_drugLicList.do', $.extend({}, base)), tong('/tong/t_drugBreakList.do', $.extend({}, base))).then(function(r1, r2, r3){
      if (my !== REQ) return;
      render(from, to, { drug: arr(r1[0]), lic: arr(r2[0]), brk: arr(r3[0]) });
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

    /* 묶음 3가지(종별 · 외래입원 · 면허번호)는 같은 기준으로 나눈다 — 청구분 = 합계 − 항목 L, 정액분 = 항목 L */
    function split(fixTot, fixNc, prod){ var total = fixTot + prod; return { claim: total - fixNc, fixed: fixNc, total: total }; }
    var BR = arr(T.brk).map(function(x){
      var s = split(Number(x.fixTotal || 0), Number(x.fixNonclaim || 0), Number(x.prodTotal || 0));
      return { type: String(x.typeCd || '0'), ipw: String(x.ipwCd || 'I'), claim: s.claim, fixed: s.fixed, total: s.total, cnt: Number(x.claimCount || 0) };
    });
    function groupBy(list, field){
      var m = {}, out = [];
      list.forEach(function(x){
        var k = x[field];
        if (!m[k]) { m[k] = { key: k, claim: 0, fixed: 0, total: 0, cnt: 0 }; out.push(m[k]); }
        m[k].claim += x.claim; m[k].fixed += x.fixed; m[k].total += x.total; m[k].cnt += x.cnt;
      });
      return out.filter(function(x){ return x.total !== 0; }).sort(function(a, b){ return b.total - a.total; });
    }
    /* 종별 = 청구서 보험종별(INSUR_TYPE) — 청구세부통계 Ⅶ 보험 종별 구성과 같은 이름 */
    var INSUR_NM = { '4': '건강보험', '1': '의료급여', '2': '의료급여', '7': '보훈', '8': '자동차보험', '9': '산재보험' };
    var IPW_NM = { 'I': '입원', 'O': '외래' };
    var byType = groupBy(BR, 'type').map(function(x){ x.label = INSUR_NM[x.key] || (x.key ? '기타 (' + x.key + ')' : '기타'); return x; });
    var byIpw = groupBy(BR, 'ipw').map(function(x){ x.label = IPW_NM[x.key] || x.key; return x; });
    var byLic = arr(T.lic).map(function(x){
      var s = split(Number(x.fixTotal || 0), Number(x.fixNonclaim || 0), Number(x.prodTotal || 0));
      var no = x.licenseNo || '';
      return { label: x.licenseName ? x.licenseName : ('면허 ' + (no === '' || no === '00' ? '미상' : no)), claim: s.claim, fixed: s.fixed, total: s.total, cnt: Number(x.claimCount || 0) };
    }).filter(function(x){ return x.total !== 0; }).sort(function(a, b){ return b.total - a.total; });

    /* 묶음 한 칸 — 청구분(파랑) · 정액분(주황) 막대, 길이는 그 묶음 안에서 가장 큰 합계 기준 */
    function brkBox(title, list){
      if (!list.length) return '';
      var sum = list.reduce(function(s, x){ return s + x.total; }, 0), max = list[0].total;
      var lines = list.map(function(x){
        var a = max ? (x.claim / max * 100) : 0, b = max ? (x.fixed / max * 100) : 0;
        return '<div class="dgl-row"><div class="dgb-lbl" title="' + esc(x.label) + '">' + esc(x.label) + ' (' + num(x.cnt) + '건)</div>' +
          '<div class="dgl-trk"><div style="width:' + a.toFixed(2) + '%;background:#2d9fd3;"></div><div style="width:' + b.toFixed(2) + '%;background:#ef8a45;"></div></div>' +
          '<div class="dgb-val">청구 ' + num(x.claim) + ' · 정액 ' + num(x.fixed) + ' · 합계 ' + num(x.total) + ' (' + ratio(x.total, sum) + ')</div></div>';
      }).join('');
      return '<div class="dgb-wrap"><div class="dgb-hd">' + esc(title) + '</div>' +
        '<div class="dgb-sum"><span style="color:#2d9fd3;">■</span> 청구분 &nbsp; <span style="color:#ef8a45;">■</span> 정액분 · 막대 길이 = 합계</div>' + lines + '</div>';
    }
    var side = brkBox('보험 종별 약제 청구 (청구분 · 정액분 · 합계)', byType) +
      brkBox('외래 · 입원 약제 청구 (청구분 · 정액분 · 합계)', byIpw) +
      brkBox('면허번호별 약제 청구 (청구분 · 정액분 · 합계)', byLic);

    var css = '<style>' +
      '.dg-grid2{display:grid;grid-template-columns:minmax(0,1fr) minmax(0,1.5fr);gap:14px;align-items:start;}' +
      '@media (max-width:1100px){.dg-grid2{grid-template-columns:minmax(0,1fr);}}' +
      '.dg-side{display:flex;flex-direction:column;gap:12px;min-width:0;}' +
      '.dgb-wrap{background:#fff;border:1px solid #e1e7ec;border-radius:10px;padding:12px 14px;}' +
      '.dgb-hd{font-size:14px;font-weight:800;color:#20303a;margin-bottom:8px;}' +
      '.dgb-sum{font-size:12px;color:#43555f;margin:0 0 8px;}' +
      '.dgb-lbl{overflow:hidden;white-space:nowrap;text-overflow:ellipsis;color:#20303a;}' +
      '.dgb-val{white-space:nowrap;color:#20303a;font-variant-numeric:tabular-nums;}' +
      '.dgb-row{display:grid;grid-template-columns:minmax(0,1fr) 110px 150px;gap:8px;align-items:center;margin:6px 0;font-size:12px;}' +
      '.dgb-trk{height:12px;background:#eef2f5;border-radius:3px;overflow:hidden;}' +
      '.dgb-fill{height:100%;background:#2d9fd3;border-radius:3px;}' +
      '.dg-main{min-width:0;}' +
      '.dgt-tabs{display:flex;gap:6px;}' +
      '.dgt-tab{border:1px solid #cfd9e0;background:#fff;color:#43555f;border-radius:6px;padding:6px 12px;font-size:13px;font-weight:700;cursor:pointer;}' +
      '.dgt-tab.on{background:#1f5a4b;color:#fff;border-color:#1f5a4b;}' +
      '.dgl-row{display:grid;grid-template-columns:150px minmax(0,1fr);gap:3px 8px;align-items:center;margin:6px 0;font-size:12px;}' +
      '.dgl-row .dgb-val{grid-column:2;white-space:normal;font-size:11px;color:#43555f;}' +
      '.dgl-trk{display:flex;height:12px;background:#eef2f5;border-radius:3px;overflow:hidden;}' +
      '</style>';
    var top = rows.slice(0, 20), maxT = top.length ? top[0].total : 0;
    var topSum = top.reduce(function(s, x){ return s + x.total; }, 0), othCnt = rows.length - top.length, othSum = sumTot - topSum;
    var bars = top.map(function(x, i){
      var w = maxT ? Math.max(1, Math.round(x.total / maxT * 100)) : 0;
      return '<div class="dgb-row"><div class="dgb-lbl" title="' + esc(x.name) + '">' + (i + 1) + '. ' + esc(x.name) + '</div>' +
        '<div class="dgb-trk"><div class="dgb-fill" style="width:' + w + '%"></div></div>' +
        '<div class="dgb-val">' + num(x.total) + '원 · ' + ratio(x.total, sumTot) + '</div></div>';
    }).join('');
    var chart = '<div class="dgb-wrap"><div class="dgb-hd">합계 1~20위 (약제비 기준)</div>' +
      '<div class="dgb-sum">상위 ' + top.length + '개 = 전체의 <b>' + ratio(topSum, sumTot) + '</b>' +
      (othCnt > 0 ? ' · 기타 ' + othCnt + '개 = <b>' + ratio(othSum, sumTot) + '</b>' : '') + '</div>' +
      (top.length ? bars : '<div class="dg-prog">자료가 없습니다.</div>') + '</div>';
    var detail = '<div class="dg-scroll"><table>' + head(['번호', '품목코드', '품목명', '청구분(원)', '정액분(원)', '합계(원)', '비중', '명세서(건)'], [1, 2]) + '<tbody>' + body + '</tbody>' + foot + '</table></div>';
    var tabs = '<div class="dgt-tabs"><button type="button" class="dgt-tab on" data-dgt="chart">합계 20위 그래프</button>' +
      '<button type="button" class="dgt-tab" data-dgt="detail">세부 내역</button></div>';
    var main = '<div data-dgt-pane="chart">' + chart + '</div>' +
      '<div data-dgt-pane="detail" style="display:none;">' + detail + '</div>';

    var h = css + '<div class="dg-hd" style="justify-content:space-between;"><h2>품목코드별 약제 청구</h2>' + tabs + '</div>' +
      (rows.length
        ? '<div class="dg-grid2"><div class="dg-side">' + side + '</div><div class="dg-main">' + main + '</div></div>'
        : '<div class="dg-prog">해당 기간에 약제 청구 자료가 없습니다.</div>') +
      '<div class="dg-note">합계 = 처방 오더 금액에서 위탁청구(JS008)를 뺀 약제비. 청구분 = 실제로 청구되는 약제비. 정액분 = 정액에 포함되어 따로 청구하지 않는 약(항목 L). 명세서는 그 약이 든 명세서 수다. 합계 순으로 정렬했다.</div>';
    g('dgBody').innerHTML = h;
    /* 탭 — 본문 영역 한 번만 위임. 고른 탭만 보이고 나머지 패널은 숨긴다 */
    g('dgBody').onclick = function(e){
      var t = e.target && e.target.closest ? e.target.closest('[data-dgt]') : null;
      if (!t) return;
      var k = t.getAttribute('data-dgt');
      Array.prototype.forEach.call(this.querySelectorAll('.dgt-tab'), function(b){ b.classList.toggle('on', b.getAttribute('data-dgt') === k); });
      Array.prototype.forEach.call(this.querySelectorAll('[data-dgt-pane]'), function(p){ p.style.display = p.getAttribute('data-dgt-pane') === k ? '' : 'none'; });
    };
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
