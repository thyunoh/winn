<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%-- misReport.jsp — 경영고객관리 › 청구통계 (2026-10-15)
     · SWCHMISU 「청구통계」와 같은 구성·같은 인쇄 모양(A4 두 장). 청구월 한 달을 전월과 나란히 본다.
       Ⅰ 수익 규모 · Ⅱ 총평 · Ⅲ 진료 항목별 수익 구성 · Ⅳ 입원·외래 · Ⅴ 약가비율(정액·정율·전체, 청구·비청구) ·
       Ⅵ 주상병별 · Ⅶ 보험 종별.
     · 숫자는 명세서·처방 자료에서 직접 센다(새로 적는 칸 없음). 위탁청구(JS008)는 청구액에서 뺀다.
     · 약가비율 기준: 약제비용 = 처방 약 금액 − 위탁. 비청구 = 정액에 포함된 약(항목 L). 청구 = 약제비용 − 비청구.
     · 인쇄는 [🖨 인쇄] — 새 창 없이 이 화면을 A4 두 장으로 찍는다.
     · ★주의: 이 파일 안에서 Deferred EL 표기(샵+중괄호) 금지 --%>

<script src="/asset/js/ui-message.js"></script>

<div class="dashboard-wrapper">
<style>
  #mrTabs{ display:flex; align-items:center; gap:4px; margin:14px 0 12px; background:#e4eaef; padding:3px; border-radius:9px; width:max-content; max-width:100%; }
  #mrTabs .mr-tab{ border:0; background:transparent; color:#4a5b65; font-size:13px; font-weight:700; padding:7px 14px; border-radius:7px; cursor:pointer; white-space:nowrap; }
  #mrTabs .mr-tab:hover{ background:#f1f5f7; }
  #mrTabs .mr-tab.on{ background:#fff; color:#1f5a4b; box-shadow:0 1px 3px rgba(0,0,0,.12); }
  .mr-panel[hidden]{ display:none !important; }
  #mrPanelStat .dashboard-wrapper, #mrPanelCost .dashboard-wrapper{ margin-left:0 !important; }
  #mrHead{ padding:6px 0 4px; }
  .mr-fixed{ position:fixed !important; z-index:60; background:#f4f6f8; box-shadow:0 2px 6px rgba(0,0,0,.08); margin:0 !important; }
  #misReport .rg2{ display:grid; grid-template-columns:minmax(0,1fr) minmax(0,1fr); gap:0 16px; align-items:start; }
  @media (max-width:1100px){ #misReport .rg2{ grid-template-columns:1fr; } }
</style>
<div class="mr-panel" id="mrPanelRep">
<div id="misReport" data-wnn="<c:out value='${wnnYn}'/>" data-hosp="<c:out value='${hospCd}'/>" data-nm="<c:out value='${hospNm}'/>">
<style>
  #misReport{ background:#f4f6f8; color:#1f2a30; min-height:100%; padding:14px 16px 50px; max-width:100%; overflow-x:hidden; }
  #misReport *{ box-sizing:border-box; }
  #misReport .mr-bar{ display:flex; align-items:center; gap:10px; flex-wrap:wrap; margin-bottom:10px; padding-right:72px; }   /* 오른쪽 끝 떠 있는 상담 단추와 겹치지 않게 */
  #misReport .mr-title{ font-size:18px; font-weight:800; color:#20303a; display:flex; align-items:center; gap:8px; }
  #misReport .mr-dot{ width:10px; height:10px; border-radius:50%; background:linear-gradient(135deg,#1f5a4b,#2a7665); }
  #misReport .mr-sub{ font-size:12px; color:#6b7c86; font-weight:400; }
  #misReport .mr-spacer{ flex:1; }
  #misReport input[type=month]{ border:1px solid #cfd8e0; border-radius:6px; padding:5px 8px; font-size:13px; background:#fff; font-family:inherit; }
  #misReport .mr-btn{ border:1px solid #cfd9e0; background:#fff; color:#43555f; border-radius:6px; padding:5px 11px; font-size:12.5px; font-weight:700; cursor:pointer; white-space:nowrap; }
  #misReport .mr-btn:hover{ background:#eef3f6; }
  #misReport .mr-btn.pri{ background:#1f5a4b; color:#fff; border-color:#1f5a4b; }
  #misReport .mr-btn.pri:hover{ background:#2a7665; }
  #misReport .mr-note{ background:#fff; border:1px solid #e3e9ed; border-radius:10px; padding:9px 14px; font-size:12.5px; color:#43555f; margin-bottom:12px; line-height:1.6; }
  #misReport .mr-note.warn{ background:#fff7e6; border-color:#f1d9a6; color:#7a5a12; }

  /* ── 보고서 한 장 (A4) ── */
  #misReport .pg{ background:#fff; border:1px solid #d7dfe5; border-radius:6px; width:100%; max-width:none; margin:0 0 18px; padding:18px 22px 16px; font-family:'Malgun Gothic','맑은 고딕',sans-serif; color:#1a1a1a; font-size:12.5px; }
  #misReport .pg h1{ font-size:20px; font-weight:900; margin:0 0 2px; }
  #misReport .pg .meta{ font-size:11px; color:#666; line-height:1.5; margin-bottom:8px; }
  #misReport .pg .meta2{ font-size:10.5px; color:#8a99a3; text-align:right; }
  #misReport .pg h2{ background:#1d2f3a; color:#fff; font-size:12.5px; font-weight:800; padding:4px 9px; margin:12px 0 6px; border-radius:2px; }
  #misReport .pg table{ width:100%; border-collapse:collapse; font-size:11.5px; }
  #misReport .pg th{ background:#eef3f6; color:#333; font-weight:800; padding:4px 6px; border-bottom:1px solid #b9c6cf; text-align:left; white-space:nowrap; }
  #misReport .pg td{ padding:4px 6px; border-bottom:1px solid #e6ecf0; vertical-align:middle; }
  #misReport .pg td.n, #misReport .pg th.n{ text-align:right; font-variant-numeric:tabular-nums; white-space:nowrap; }
  #misReport .pg tr.tot td{ font-weight:800; background:#f5f8fa; border-top:1px solid #9aa9b3; }
  #misReport .pg .up{ color:#1f5a4b; font-weight:700; }
  #misReport .pg .down{ color:#b23b3b; font-weight:700; }
  #misReport .pg ul.sum{ margin:4px 0 0 0; padding-left:16px; line-height:1.75; font-size:12px; }
  #misReport .pg .note{ font-size:10.5px; color:#666; line-height:1.6; margin-top:8px; border-top:1px solid #d7dfe5; padding-top:6px; }
  #misReport .pg .foot{ font-size:10.5px; color:#666; text-align:center; margin-top:12px; border-top:1px solid #d7dfe5; padding-top:5px; }
  #misReport .pg .sub{ color:#666; font-size:11px; }
  #misReport .pg .box{ background:#f7f9fa; border:1px solid #e0e7ec; border-radius:4px; padding:6px 9px; }

  @media print{
    @page{ size:A4 portrait; margin:10mm; }
    #misReport{ background:#fff; padding:0; }
    #misReport .no-print{ display:none !important; }
    #misReport .pg{ border:none; border-radius:0; margin:0; padding:0; max-width:none; page-break-after:always; }
    #misReport .pg:last-child{ page-break-after:auto; }
    #misReport .pg h2{ -webkit-print-color-adjust:exact; print-color-adjust:exact; }
  }
</style>

<div class="mr-bar no-print">
  <div class="mr-title"><span class="mr-dot"></span> 청구통계 <span class="mr-sub">— 한 장으로, 전월과 견주어 읽기</span></div>
  <span class="mr-spacer"></span>
  <label class="mr-sub">청구월 <input type="month" id="mrYm"></label>
  <button type="button" class="mr-btn pri" id="mrGo">조회</button>
  <button type="button" class="mr-btn" id="mrPrint">🖨 인쇄</button>
</div>

<div class="mr-note no-print" id="mrNote" hidden></div>

<div id="mrRoot"><div class="mr-note no-print">불러오는 중…</div></div>

<script>
(function(){
  var root = document.getElementById('misReport');
  var WNN = root.getAttribute('data-wnn') === 'Y';
  var ITEM_TOP = 10, DIAG_TOP = 10;
  var INSUR_NM = { '4':'건강보험', '1':'의료급여', '2':'의료급여', '7':'보훈', '8':'자동차보험', '9':'산재보험' };
  function g(id){ return document.getElementById(id); }
  function esc(s){ return (s==null?'':String(s)).replace(/[&<>"]/g, function(c){ return ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;'})[c]; }); }
  function n0(v){ return Number(v||0); }
  function num(v){ return n0(v).toLocaleString('ko-KR'); }
  function eok(v){ return (n0(v)/100000000).toFixed(2) + '억'; }
  function man(v){ return Math.round(n0(v)/10000).toLocaleString('ko-KR') + '만'; }
  function sgn(v){ return (n0(v) >= 0 ? '+' : '−'); }
  function pct(a, b){ return n0(b) ? (Math.round(n0(a) * 1000 / n0(b)) / 10).toFixed(1) + '%' : '—'; }
  function pctN(a, b){ return n0(b) ? Math.round(n0(a) * 1000 / n0(b)) / 10 : 0; }
  function ymLbl(ym){ return ym ? (ym.slice(0,4) + '년 ' + Number(ym.slice(4,6)) + '월') : ''; }
  function ymShort(ym){ return ym ? (Number(ym.slice(4,6)) + '월') : ''; }
  function ymInput(ym){ return ym ? (ym.slice(0,4) + '-' + ym.slice(4,6)) : ''; }
  function ymOf(v){ return String(v||'').replace(/[^0-9]/g,'').slice(0,6); }
  function err(e){ _alertBox((e && e.message) ? e.message : '처리 중 오류가 발생했습니다.', {icon:'❌'}); }
  function hosp(){ var h=''; try { h = (getCookie('s_hospid') || '').trim(); } catch(e){} return h || root.getAttribute('data-hosp'); }
  function post(url, data){
    if (WNN) data.hospCd = hosp();
    return $.ajax({ url:url, type:'POST', data:data, dataType:'json' }).then(function(res){
      if (res && res.result === 'FAIL') throw new Error(res.message || '처리에 실패했습니다.');
      return res;
    });
  }
  function bar(ratio, w, color){
    var r = Math.max(0, Math.min(1, ratio || 0));
    return "<svg width='" + w + "' height='9' viewBox='0 0 " + w + " 9'><rect x='0' y='0' width='" + w + "' height='9' fill='#eef2f5'/><rect x='0' y='0' width='" + (r * w).toFixed(1) + "' height='9' fill='" + (color || '#1f5a4b') + "'/></svg>";
  }
  function row(cells, cls){
    return '<tr' + (cls ? ' class="' + cls + '"' : '') + '>' + cells.map(function(c, i){ return '<td' + (i > 0 ? ' class="n"' : '') + '>' + c + '</td>'; }).join('') + '</tr>';
  }
  function diffTxt(now, prev){
    var d = n0(now) - n0(prev);
    if (!n0(prev) && !n0(now)) return '—';
    return '<span class="' + (d >= 0 ? 'up' : 'down') + '">' + sgn(d) + man(Math.abs(d)) + ' (' + (n0(prev) ? (d >= 0 ? '+' : '') + (Math.round(d * 1000 / n0(prev)) / 10).toFixed(1) + '%' : '—') + ')</span>';
  }

  /* ── Ⅰ 수익 규모 ── */
  /* 건수 증감 — 금액(만원)과 따로 쓴다: 「+0만」처럼 건수가 금액 단위로 찍히던 것을 고친다. */
  function diffCnt(now, prev){
    var d = n0(now) - n0(prev);
    return '<span class="' + (d >= 0 ? 'up' : 'down') + '">' + sgn(d) + num(Math.abs(d)) + '건 (' + (n0(prev) ? (d >= 0 ? '+' : '') + (Math.round(d * 1000 / n0(prev)) / 10).toFixed(1) + '%' : '—') + ')</span>';
  }
  function secI(d){
    var c = d.claim || {}, p = d.prevClaim || {};
    var inI = (d.inout || []).filter(function(x){ return x.gb === 'I'; })[0] || {};
    var pInI = (d.prevInout || []).filter(function(x){ return x.gb === 'I'; })[0] || {};
    var inO = (d.inout || []).filter(function(x){ return x.gb === 'O'; })[0] || {};
    var tot = n0(c.totamt), ptot = n0(p.totamt);
    var rows = [
      row(['급여 발생총액 (명세서 총진료비)', eok(tot), eok(ptot), diffTxt(tot, ptot), '명세서 기준(100/100 포함) — 이 보고서의 분모'], 'tot'),
      row(['공단·기관 청구액', eok(c.claimamt), eok(p.claimamt), diffTxt(c.claimamt, p.claimamt), '총진료비의 ' + pct(c.claimamt, tot)]),
      row(['본인부담', eok(c.selfamt), eok(p.selfamt), diffTxt(c.selfamt, p.selfamt), '총진료비의 ' + pct(c.selfamt, tot)]),
      row(['명세서 건수', num(c.bills) + '건', num(p.bills) + '건', diffCnt(c.bills, p.bills), '환자 ' + num(c.pats) + '명 · 입원일수 ' + num(c.admdays) + '일']),
      row(['입원 진료비', eok(inI.amt), eok(pInI.amt), diffTxt(inI.amt, pInI.amt), '입원 ' + num(inI.bills) + '건 · 외래 ' + num(inO.bills) + '건'])
    ].join('');
    return '<h2>Ⅰ. 수익 규모 — 전월 대비 증감</h2>' +
      '<table><thead><tr><th>구분</th><th class="n">' + esc(ymLbl(d.ym)) + '</th><th class="n">' + esc(ymLbl(d.prevYm)) + '</th><th class="n">증감</th><th>비고</th></tr></thead><tbody>' + rows + '</tbody></table>';
  }

  /* ── 과별 진료비 (2026-10-15) — 청구세부 과별 분석과 같은 기준(총액 · 위탁 규칙). 진료과는 주상병 기준 ── */
  function secDept(d){
    var list = d.dept || [], tot = list.reduce(function(s, x){ return s + n0(x.amt); }, 0);
    var cnt = list.reduce(function(s, x){ return s + n0(x.cnt); }, 0);
    var max = 0; list.forEach(function(x){ max = Math.max(max, n0(x.amt)); });
    var rows = list.slice(0, 10).map(function(x){
      return row([esc(x.nm || '기타'), eok(x.amt), num(x.cnt) + '건', (n0(x.cnt) ? num(Math.round(n0(x.amt) / n0(x.cnt))) + '원' : '—'), pct(x.amt, tot), bar(n0(x.amt) / (max || 1), 90, '#1f5a4b')]);
    }).join('');
    var sum = row(['합계', eok(tot), num(cnt) + '건', (cnt ? num(Math.round(tot / cnt)) + '원' : '—'), '100.0%', ''], 'tot');
    var rest = list.length > 10 ? '<div class="note">상위 10개 과 외 ' + (list.length - 10) + '개 과는 표에서 생략했고 합계에는 포함됩니다.</div>' : '';
    return '<h2>과별 진료비 — 총액 기준 (' + list.length + '개 과)</h2>' +
      '<table><thead><tr><th>진료과</th><th class="n">진료비</th><th class="n">건수</th><th class="n">건당</th><th class="n">비중</th><th>막대</th></tr></thead><tbody>' +
      (rows ? rows + sum : '<tr><td colspan="6" class="n">해당 자료가 없습니다.</td></tr>') + '</tbody></table>' + rest;
  }

  /* ── Ⅱ 총평 ── */
  function secII(d){
    var c = d.claim || {}, p = d.prevClaim || {};
    var tot = n0(c.totamt), ptot = n0(p.totamt), out = [];
    if (tot && ptot) out.push('당월 급여 발생총액은 <b>' + eok(tot) + '</b>으로 전월(' + eok(ptot) + ') 대비 <b>' + sgn(tot - ptot) + man(Math.abs(tot - ptot)) + ' (' + pct(Math.abs(tot - ptot), ptot) + ') ' + (tot >= ptot ? '증가' : '감소') + '</b>.');
    else if (tot) out.push('당월 급여 발생총액은 <b>' + eok(tot) + '</b>입니다(전월 청구 자료 없음).');
    var items = d.items || [], iSum = items.reduce(function(s, x){ return s + n0(x.amt); }, 0);
    if (items.length && iSum) {
      var top3 = items.slice(0, 3).reduce(function(s, x){ return s + n0(x.amt); }, 0);
      out.push('수익 기반은 <b>' + esc(items[0].itemnm) + '</b>(' + pct(items[0].amt, iSum) + ')이며, 상위 3개 항목이 전체의 <b>' + pct(top3, iSum) + '</b>를 차지합니다.');
      var pItems = d.prevItems || [], pSum = pItems.reduce(function(s, x){ return s + n0(x.amt); }, 0);
      var best = null;
      if (pSum) items.forEach(function(x){
        var pv = pItems.filter(function(y){ return y.itemno === x.itemno; })[0];
        var dp = (n0(x.amt) / iSum - (pv ? n0(pv.amt) / pSum : 0)) * 100;
        if (!best || dp > best.dp) best = { nm: x.itemnm, dp: dp };
      });
      if (best && best.dp >= 0.1) out.push('가장 큰 변화는 <b>' + esc(best.nm) + '</b>의 비중이 전월보다 <b>+' + best.dp.toFixed(1) + 'p</b> 커진 것입니다.');
    }
    var dg = d.diags || [], tot10 = dg.slice(0, DIAG_TOP).reduce(function(s, x){ return s + n0(x.amt); }, 0);
    if (dg.length && tot) out.push('상위 10개 상병이 총진료비의 <b>' + pct(tot10, tot) + '</b>를 점유합니다. 집중이 큰 상병은 산정 기준과 구비서류 관리가 우선 과제입니다.');
    var dr = d.drug || [], fx = dr.filter(function(x){ return x.kind === 'FIXED'; })[0], rt = dr.filter(function(x){ return x.kind === 'RATE'; })[0];
    if (fx && n0(fx.totalamt)) {
      var fxClaim = n0(fx.totalamt) - n0(fx.nonclaimamt);
      out.push('정액환자 약제비용 <b>' + eok(fx.totalamt) + '</b> 중 <b>' + pct(n0(fx.nonclaimamt), n0(fx.totalamt)) + '</b>는 정액에 포함되어 별도 청구되지 않습니다(청구 ' + pct(fxClaim, fx.totalamt) + '). 약가비율은 Ⅴ항을 봐 주세요.');
    }
    if (!out.length) out.push('이 달 자료가 아직 충분하지 않아 총평을 쓸 수 없습니다.');
    return '<h2>Ⅱ. 총평 및 시사점</h2><ul class="sum">' + out.map(function(x){ return '<li>' + x + '</li>'; }).join('') + '</ul>';
  }

  /* ── Ⅲ 진료 항목별 처방금액 · 청구금액 — 청구금액은 명세서 청구액을 청구 가능한 처방 행에 배분한 값 ── */
  function secIII(d){
    var items = d.items || [], pItems = d.prevItems || [];
    var iSum = items.reduce(function(s, x){ return s + n0(x.amt); }, 0);
    var oSum = items.reduce(function(s, x){ return s + n0(x.ordamt); }, 0);
    var pSum = pItems.reduce(function(s, x){ return s + n0(x.amt); }, 0);
    var list = items.slice(0, 10), maxS = 0;
    list.forEach(function(x){ maxS = Math.max(maxS, n0(x.amt) / (iSum || 1)); });
    var rows = list.map(function(x){
      var pv = pItems.filter(function(y){ return y.itemno === x.itemno; })[0];
      var sh = n0(x.amt) / (iSum || 1), ps = pv ? n0(pv.amt) / (pSum || 1) : 0;
      var dp = (sh - ps) * 100;
      return row([esc(x.itemnm), num(x.ordamt), num(x.amt), (sh * 100).toFixed(1) + '%', pv ? (ps * 100).toFixed(1) + '%' : '—',
                  '<span class="' + (dp >= 0 ? 'up' : 'down') + '">' + (dp >= 0 ? '+' : '') + dp.toFixed(1) + 'p</span>',
                  bar(sh / (maxS || 1), 170, '#1f5a4b')]);
    });
    rows.push(row(['합계', num(oSum), num(iSum), '100.0%', '—', '—', ''], 'tot'));
    var c = d.claim || {};
    return '<h2>Ⅲ. 진료 항목별 처방금액 · 청구금액 — 전월 대비</h2>' +
      '<table><thead><tr><th>항목</th><th class="n">처방금액</th><th class="n">청구금액</th><th class="n">비중</th><th class="n">전월 비중</th><th class="n">증감</th><th>비중 막대</th></tr></thead><tbody>' + rows.join('') + '</tbody></table>' +
      '<div class="note">처방금액 = 처방(오더) 행의 금액 합계. 청구금액 = 명세서 청구액을 청구 가능한 처방 행에 금액 비율로 배분한 값(정액 명세서는 정액 일당 L 중 Q·K 코드에만 배분, 입원료·주사·처치·약 등 정액 포함 항목은 0원, 위탁 JS008 제외). 청구금액 합계 ' + eok(iSum) + ' = 명세서 청구액 ' + eok(c.claimamt) + '.</div>';
  }

  /* ── Ⅳ 입원·외래 구성 ── */
  function secIV(d){
    var io = d.inout || [], pio = d.prevInout || [];
    var I = io.filter(function(x){ return x.gb === 'I'; })[0] || {}, O = io.filter(function(x){ return x.gb === 'O'; })[0] || {};
    var pI = pio.filter(function(x){ return x.gb === 'I'; })[0] || {}, pO = pio.filter(function(x){ return x.gb === 'O'; })[0] || {};
    var bs = n0(I.bills) + n0(O.bills), am = n0(I.amt) + n0(O.amt);
    var perI = n0(I.bills) ? n0(I.amt) / n0(I.bills) : 0, perO = n0(O.bills) ? n0(O.amt) / n0(O.bills) : 0;
    return '<h2>Ⅳ. 입원·외래 구성</h2>' +
      '<table><thead><tr><th>구분</th><th class="n">명세서 건수</th><th class="n">건수 비중</th><th class="n">진료비</th><th class="n">진료비 비중</th><th class="n">1건당</th><th class="n">전월 건수</th></tr></thead><tbody>' +
      row(['입원', num(I.bills), pct(I.bills, bs), eok(I.amt), pct(I.amt, am), num(Math.round(perI)) + '원', num(pI.bills)]) +
      row(['외래', num(O.bills), pct(O.bills, bs), eok(O.amt), pct(O.amt, am), num(Math.round(perO)) + '원', num(pO.bills)]) +
      '</tbody></table>' +
      '<div class="box sub" style="margin-top:6px;">' +
      '입원 ' + bar(n0(I.bills) / (bs || 1), 160, '#1f5a4b') + ' 건수 · ' + bar(n0(I.amt) / (am || 1), 160, '#c97d10') + ' 진료비 &nbsp; 수익의 결정 요인은 <b>입원 병상 가동·재원일수</b>입니다. 외래는 건수가 많아도 금액 기여가 작습니다.' +
      '</div>';
  }

  /* ── Ⅴ 약가비율 (정액·정율·전체 · 청구·비청구) ── */
  function secV(d){
    var dr = d.drug || [], pdr = d.prevDrug || [];
    var f = dr.filter(function(x){ return x.kind === 'FIXED'; })[0] || {}, r = dr.filter(function(x){ return x.kind === 'RATE'; })[0] || {};
    var pf = pdr.filter(function(x){ return x.kind === 'FIXED'; })[0] || {}, pr = pdr.filter(function(x){ return x.kind === 'RATE'; })[0] || {};
    function parts(x){
      var t = n0(x.totalamt), nc = n0(x.nonclaimamt);
      return { total: t, nonclaim: nc, claim: t - nc, entrust: n0(x.entrustamt) };
    }
    var F = parts(f), R = parts(r), T = { total: F.total + R.total, nonclaim: F.nonclaim + R.nonclaim, claim: F.claim + R.claim, entrust: F.entrust + R.entrust };
    var pF = parts(pf), pR = parts(pr);
    var pT = { total: pF.total + pR.total, claim: pF.claim + pR.claim };
    function line(name, P, pp){
      return row([esc(name), eok(P.total), eok(P.claim), pct(P.claim, P.total), eok(P.nonclaim), pct(P.nonclaim, P.total),
                  pp ? pct(pp.claim, pp.total) : '—']);
    }
    var rows = line('정액환자', F, pF) + line('정율환자 (행위)', R, pR) + line('전체환자', T, pT);
    return '<h2>Ⅴ. 약가비율 — 정액·정율·전체 (청구액 · 비청구액)</h2>' +
      '<table><thead><tr><th>구분</th><th class="n">약제비용</th><th class="n">청구액</th><th class="n">청구 비율</th><th class="n">비청구액</th><th class="n">비청구 비율</th><th class="n">전월 청구 비율</th></tr></thead><tbody>' +
      rows + '</tbody></table>' +
      '<div class="note">약제비용 = 처방 약 금액 − 위탁청구(JS008). <b>청구액 = 약제비용 − 비청구액</b>. 비청구액 = 정액에 포함되어 따로 청구하지 않는 약(항목 L 요양병원정액). ' +
      '정율환자는 항목상 비청구 약이 확인되지 않아 전액 청구로 봅니다(부분청구 기준은 확인 필요). ' +
      '위탁청구는 청구액에서 제외했습니다 — 이 달 위탁 금액 ' + eok(T.entrust) + '.</div>';
  }

  /* ── Ⅵ 주상병별 ── */
  function secVI(d){
    var dg = (d.diags || []).slice(0, DIAG_TOP), pdg = d.prevDiags || [];
    var tot = n0((d.claim || {}).totamt), maxA = dg.length ? n0(dg[0].amt) : 1;
    var rows = dg.map(function(x){
      var pv = pdg.filter(function(y){ return y.code === x.code; })[0];
      var dv = pv ? n0(x.amt) - n0(pv.amt) : null;
      return row([esc(x.code), esc(x.nm), num(x.bills), num(x.amt), pct(x.amt, tot), num(Math.round(n0(x.bills) ? n0(x.amt) / n0(x.bills) : 0)),
                  dv == null ? '—' : '<span class="' + (dv >= 0 ? 'up' : 'down') + '">' + sgn(dv) + man(Math.abs(dv)) + '</span>',
                  bar(n0(x.amt) / (maxA || 1), 120, '#1f5a4b')]);
    });
    return '<h2>Ⅵ. 주상병별 수익 구성 — 상위 10개 (주상병 기준)</h2>' +
      '<table><thead><tr><th>코드</th><th>상병명(대분류)</th><th class="n">명세서</th><th class="n">진료비</th><th class="n">비중</th><th class="n">명세서당</th><th class="n">전월 대비</th><th>막대</th></tr></thead><tbody>' +
      (rows.join('') || row(['—', '자료 없음', '', '', '', '', '', ''])) + '</tbody></table>';
  }

  /* ── Ⅶ 보험 종별 ── */
  function secVII(d){
    var ins = d.insur || [], m = {}, sum = 0;
    ins.forEach(function(x){ var k = String(x.insurtype || ''); m[k] = (m[k] || 0) + n0(x.totamt); sum += n0(x.totamt); });
    var keys = Object.keys(m).sort(function(a, b){ return m[b] - m[a]; });
    var rows = keys.map(function(k){
      return row([esc(INSUR_NM[k] || '기타 (' + k + ')'), eok(m[k]), pct(m[k], sum), bar(m[k] / (sum || 1), 150, '#c97d10')]);
    });
    return '<h2>Ⅶ. 보험 종별 구성</h2>' +
      '<table><thead><tr><th>종별</th><th class="n">진료비</th><th class="n">비중</th><th>막대</th></tr></thead><tbody>' +
      (rows.join('') || row(['자료 없음', '', '', ''])) + '</tbody></table>';
  }

  function header(d){
    return '<h1>' + esc(root.getAttribute('data-nm') || '') + ' — ' + esc(ymLbl(d.ym)) + ' 청구분 청구통계</h1>' +
      '<div class="meta">보고 기준: ' + esc(ymLbl(d.ym)) + ' 청구분 (전월 ' + esc(ymLbl(d.prevYm)) + ' 대비) · 대상: 입원·외래 전체 · 명세서 ' + num((d.claim || {}).bills) + '건</div>' +
      '<div class="meta2">작성일 ' + esc(new Date().toISOString().slice(0,10)) + ' · 자료 출처 청구 명세서(TBL_MYOUNG_MST) · 처방(TBL_JINORD_MST)</div>';
  }

  function render(d){
    var sumNote = '';
    var pg1 = '<div class="pg">' + header(d) + '<div class="rg2"><div>' + secI(d) + '</div><div>' + secDept(d) + '</div></div>' + secII(d) + secIII(d) +'<div class="rg2"><div>' + secIV(d) + '</div><div>' + secVII(d) + '</div></div>' +
      '<div class="foot">' + esc(root.getAttribute('data-nm') || '') + ' · ' + esc(ymLbl(d.ym)) + ' 청구분 청구통계 · 1 / 2 면 · 요약</div></div>';
    var pg2 = '<div class="pg">' + '<div class="meta">' + esc(root.getAttribute('data-nm') || '') + ' — ' + esc(ymLbl(d.ym)) + ' 청구분 · 전월 ' + esc(ymLbl(d.prevYm)) + ' 대비 · 상세 자료</div>' +
      '<div class="rg2"><div>' + secV(d) + '</div><div>' + secVI(d) + '</div></div>' +
      '<div class="note"><b>붙임 │ 산출 기준 및 유의사항</b><br>' +
      '· 금액은 <b>명세서 기준</b>(총진료비 = 명세서 TOT_AMT, 100/100 포함). 위탁청구(JS008)는 청구액에서 제외.<br>' +
      '· Ⅲ항은 처방(오더) 금액 기준이라 명세서 합계와 다를 수 있음. Ⅴ항 약제비용도 처방 금액 기준.<br>' +
      '· Ⅵ항은 명세서별 주상병(DIAG_TYPE 1)의 대분류(3자리)로 묶었음 — 상병명은 질병 대분류 코드표 기준.<br>' +
      '· 심사조정(삭감) 추이·원인은 이 자료에 없어 SWCHMISU 청구통계의 Ⅶ항은 싣지 않음.' +
      '</div>' +
      '<div class="foot">' + esc(root.getAttribute('data-nm') || '') + ' · ' + esc(ymLbl(d.ym)) + ' 청구분 청구통계 · 2 / 2 면 · 상세</div></div>';
    g('mrRoot').innerHTML = pg1 + pg2;
  }

  /* 진행바 — 청구통계 자료를 집계하는 동안 보인다(2026-10-15) */
  function repProgHtml(txt){
    return '<style>@keyframes mrProg{0%{left:-40%}100%{left:100%}}</style>' +
      '<div class="no-print" style="padding:18px 6px;"><div class="mr-note" style="margin-bottom:8px;">' + txt + '</div>' +
      '<div style="position:relative;height:10px;background:#e4eaef;border-radius:5px;overflow:hidden;max-width:560px;">' +
      '<div style="position:absolute;top:0;left:-40%;height:100%;width:40%;background:#0b8eca;border-radius:5px;animation:mrProg 1.1s ease-in-out infinite;"></div></div></div>';
  }
  function load(ym){
    g('mrRoot').innerHTML = repProgHtml('청구 자료 집계 중… (명세서 · 항목 · 진단 · 보험 구분)');
    g('mrNote').hidden = true;
    post('/mis/reportGet.do', ym ? { ym: ym } : {}).then(function(d){
      g('mrYm').value = ymInput(ymOf(d.ym));
      render(d);
    }).catch(function(e){
      g('mrRoot').innerHTML = '';
      var nb = g('mrNote'); nb.hidden = false; nb.className = 'mr-note warn no-print';
      nb.innerHTML = esc(e && e.message ? e.message : '보고서를 만들지 못했습니다.');
      err(e);
    });
  }

  /* 인쇄 — konet_vsweb 과 같이 <보고서 내용만> 담은 새 창을 만들어 그 창에서 찍는다(사이트 화면·버튼 줄은 들어가지 않는다). */
  function printReport(){
    var body = g('mrRoot').innerHTML;
    if (!body || body.indexOf('class="pg"') < 0) { _alertBox('먼저 보고서를 조회하세요.', {icon:'📄'}); return; }
    var css = root.getElementsByTagName('style')[0].textContent +
      '@page{ size:A4 portrait; margin:0; } @media print{ #misReport .pg{ padding:10mm !important; max-width:none !important; width:210mm !important; } #misReport .rg2{ grid-template-columns:minmax(0,1fr) minmax(0,1fr) !important; } }';
    var w = window.open('', '_blank');
    if (!w) { _alertBox('팝업이 막혀 있습니다. 팝업을 허용한 뒤 다시 눌러 주세요.', {icon:'🚫'}); return; }
    var title = (root.getAttribute('data-nm') || '') + ' 청구통계';
    w.document.open();
    w.document.write('<!DOCTYPE html><html lang="ko"><head><meta charset="UTF-8"><title>' + esc(title) + '</title><style>' + css + '</style></head><body>' +
      '<div id="misReport"><div id="mrRoot">' + body + '</div></div>' +
      '<scr' + 'ipt>window.addEventListener("load",function(){setTimeout(function(){window.print();},300);});' +
      'window.addEventListener("afterprint",function(){setTimeout(function(){window.close();},200);});</scr' + 'ipt></body></html>');
    w.document.close();
  }
  g('mrGo').onclick = function(){ load(ymOf(g('mrYm').value)); };
  g('mrPrint').onclick = printReport;
  load('');
})();
</script>
</div>
</div>
<%-- 탭 3개의 내용 — 청구세부통계(misDirRepPanel) · 수입일보(misRevenuePanel). jsp:include 라 실행 때마다 새로 읽는다(정적 include 는 패널만 고쳐도 톰캣이 본 파일을 다시 만들지 않아 옛 화면이 남았다). --%>
<jsp:include page="misDirRepPanel.jsp" />
<jsp:include page="misRevenuePanel.jsp" />
<div class="mr-panel" id="mrPanelStat" hidden>
<jsp:include page="misStat.jsp" />
</div>
<div class="mr-panel" id="mrPanelCost" hidden>
<jsp:include page="misCost.jsp" />
</div>
<script>
(function(){
  var INIT = '${empty initTab ? "rep" : initTab}';
  var PANELS = { rep: 'mrPanelRep', dir: 'mrPanelDir', rev: 'mrPanelRev', stat: 'mrPanelStat', cost: 'mrPanelCost' };
  function show(t){
    layoutSticky();
    Object.keys(PANELS).forEach(function(k){ var el = document.getElementById(PANELS[k]); if (el) el.hidden = (k !== t); });
    document.querySelectorAll('#mrTabs .mr-tab').forEach(function(b){ b.className = 'mr-tab' + (b.getAttribute('data-tab') === t ? ' on' : ''); });
    if (t === 'dir' && window.misDirStart) window.misDirStart();
    if (t === 'rev' && window.misRevStart) window.misRevStart();
  }
  document.querySelectorAll('#mrTabs .mr-tab').forEach(function(b){ b.onclick = function(){ show(b.getAttribute('data-tab')); }; });
  /* 상단 고정 — 탭 줄 · 각 패널의 조회·인쇄 줄을 스크롤해도 위쪽에 붙인다.
     sticky 가 바깥 스크롤 구조 때문에 안 먹어서 스크롤 위치를 보고 직접 붙인다. 숨은 패널의 줄은 건너뛴다. */
  var STICKY = [];
  function addSticky(el){
    if (!el) return;
    var ph = document.createElement('div');
    el.parentNode.insertBefore(ph, el);
    STICKY.push({ el: el, ph: ph });
  }
  function topOff(){
    var n = document.querySelector('.navbar');
    return (n && getComputedStyle(n).position === 'fixed') ? Math.max(0, n.getBoundingClientRect().bottom) : 0;
  }
  function layoutSticky(){
    var off = topOff(), y = off;
    STICKY.forEach(function(s){
      if (s.el.closest('[hidden]')) { s.el.classList.remove('mr-fixed'); s.ph.style.height = '0px'; return; }
      var h = s.el.offsetHeight, r = s.ph.getBoundingClientRect();
      if (r.top <= y) {
        s.el.classList.add('mr-fixed');
        s.el.style.top = y + 'px';
        s.el.style.left = r.left + 'px';
        s.el.style.width = s.ph.offsetWidth + 'px';
        s.ph.style.height = h + 'px';
        y += h;
      } else {
        s.el.classList.remove('mr-fixed');
        s.el.style.top = ''; s.el.style.left = ''; s.el.style.width = '';
        s.ph.style.height = '0px';
      }
    });
    document.documentElement.style.setProperty('--mr-head-h', (y - off) + 'px');
  }
  addSticky(document.querySelector('#misReport .mr-bar'));
  addSticky(document.querySelector('#misDirRep .mdr-bar'));
  addSticky(document.querySelector('#misRev > .rv-head'));
  window.addEventListener('scroll', layoutSticky, { passive: true });
  document.addEventListener('scroll', layoutSticky, true);
  window.addEventListener('resize', layoutSticky);
  show(INIT);
})();
</script>
</div>
