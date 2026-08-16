<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%-- qpsQiRpt.jsp — QI 중간보고서 · 최종보고서 (2026-08-11)

     ★한 서식 + 종류 구분(M=중간 / F=최종). 최종이 중간의 상위집합이라 화면을 둘로 만들지 않았다.
       원본 좌측의 P·D·C·A 마크가 그 근거다 —
         P 1면 주제·배경·팀 운영·자료수집(결과분석)·현황파악·목표   ← 중간·최종 동일
         D 2면 개선활동                                            ← 중간은 계획/실행/비고
         C 활동효과 · A 결론 및 제언                               ← ***최종만***
       ⇒ 최종을 고르면 C·A 카드가 나타난다.

     ★결과분석·활동효과의 수치는 저장하지 않는다. 지표에서 조회 시 계산한다.
       축도 지표 유형이 정한다 — 관찰형=분기별 %, 사고형=월별 건수(원본 실측).

     ★주의: 이 파일 안에서 Deferred EL 표기(샵+중괄호) 금지 --%>

<script src="/asset/js/ui-message.js"></script>
<%@ include file="/WEB-INF/jsp/main/inc/qpsFileBox.jsp" %>

<div class="dashboard-wrapper">
<div id="qpsQiRpt" data-wnn="<c:out value='${wnnYn}'/>">
<style>
  #qpsQiRpt{ background:#f4f6f8; color:#1f2a30; min-height:100%; padding:14px 16px 60px; max-width:100%; overflow-x:hidden; }
  #qpsQiRpt *{ box-sizing:border-box; }
  #qpsQiRpt .qr-head{ display:flex; align-items:center; gap:10px; margin-bottom:12px; flex-wrap:wrap; }
  #qpsQiRpt .qr-title{ font-size:18px; font-weight:800; color:#20303a; display:flex; align-items:center; gap:8px; }
  #qpsQiRpt .qr-dot{ width:10px; height:10px; border-radius:50%; background:linear-gradient(135deg,#1f5a4b,#2a7665); }
  #qpsQiRpt .qr-sub{ font-size:12px; color:#6b7c86; }
  #qpsQiRpt .qr-hosp{ background:#e7f3ee; color:#1f5a4b; font-size:12px; font-weight:800;
      border:1px solid #cfe3da; border-radius:14px; padding:3px 11px; }
  #qpsQiRpt .qr-spacer{ flex:1; }
  #qpsQiRpt select, #qpsQiRpt input, #qpsQiRpt textarea{
      border:1px solid #cfd8e0; border-radius:5px; padding:5px 7px; font-family:inherit; font-size:12.5px; background:#fff; }
  #qpsQiRpt textarea{ resize:vertical; line-height:1.55; width:100%; }
  #qpsQiRpt .qr-btn{ border:1px solid #1f5a4b; background:#1f5a4b; color:#fff; border-radius:6px;
      padding:6px 14px; font-size:13px; font-weight:600; cursor:pointer; white-space:nowrap; }
  #qpsQiRpt .qr-btn.ghost{ background:#fff; color:#1f5a4b; }
  #qpsQiRpt .qr-btn.warn{ background:#fff; color:#b23b3b; border-color:#e0b4b4; }
  #qpsQiRpt .qr-btn.mini{ padding:2px 9px; font-size:11.5px; border-color:#cfd8e0; color:#556570; background:#fff; }

  #qpsQiRpt .qr-wrap{ display:flex; gap:14px; align-items:flex-start; }
  #qpsQiRpt .qr-left{ width:260px; flex:none; }
  #qpsQiRpt .qr-right{ flex:1; min-width:0; max-width:1000px; }
  #qpsQiRpt .qr-card{ background:#fff; border:1px solid #e3e9ed; border-radius:10px; padding:14px 16px; margin-bottom:12px; }
  #qpsQiRpt .qr-card h4{ margin:0 0 10px; font-size:14px; font-weight:800; color:#1f5a4b; }
  #qpsQiRpt .qr-card h4 .hint{ font-weight:500; font-size:12px; color:#8a99a3; }
  #qpsQiRpt .qr-card h4 .pdca{ display:inline-block; width:20px; height:20px; line-height:20px; text-align:center;
      background:#1f5a4b; color:#fff; border-radius:4px; font-size:12px; margin-right:6px; }

  #qpsQiRpt .qr-list{ max-height:520px; overflow:auto; }
  #qpsQiRpt .qr-item{ padding:8px 10px; border:1px solid #eef2f5; border-radius:8px; margin-bottom:6px; cursor:pointer; }
  #qpsQiRpt .qr-item:hover{ border-color:#8fc3b2; background:#f7fbf9; }
  #qpsQiRpt .qr-item.on{ border-color:#1f5a4b; background:#f0f7f4; }
  #qpsQiRpt .qr-item .t{ font-size:13px; font-weight:700; color:#20303a; }
  #qpsQiRpt .qr-item .d{ font-size:11.5px; color:#8a99a3; margin-top:2px; }
  #qpsQiRpt .qr-empty{ color:#8a99a3; font-size:12.5px; padding:16px 6px; text-align:center; }

  #qpsQiRpt .qr-form{ display:grid; grid-template-columns:110px 1fr 110px 1fr; gap:9px 10px; align-items:start; }
  #qpsQiRpt .qr-form .lb{ font-size:12.5px; font-weight:700; color:#43555f; padding-top:8px; }
  #qpsQiRpt .qr-form .full{ grid-column:2 / -1; }
  #qpsQiRpt .qr-form input{ width:100%; }
  #qpsQiRpt table.ed{ width:100%; border-collapse:collapse; font-size:12.5px; }
  #qpsQiRpt table.ed th{ background:#f2f6f8; border:1px solid #dde5ea; padding:5px 4px; font-weight:700; color:#43555f; }
  #qpsQiRpt table.ed td{ border:1px solid #e6ecef; padding:3px; }
  #qpsQiRpt table.ed input{ width:100%; border:none; background:transparent; padding:4px 5px; }
  #qpsQiRpt table.ed input:focus{ background:#f7fbf9; outline:1px solid #8fc3b2; }
  #qpsQiRpt .rowdel{ color:#b23b3b; cursor:pointer; font-weight:700; text-align:center; width:26px; }
  #qpsQiRpt table.st{ width:100%; border-collapse:collapse; font-size:12px; }
  #qpsQiRpt table.st th, #qpsQiRpt table.st td{ border:1px solid #dfe4ea; padding:5px 6px; text-align:center; }
  #qpsQiRpt table.st th{ background:#f2f6f8; font-weight:700; color:#43555f; white-space:nowrap; }
  #qpsQiRpt table.st td.l{ text-align:left; }
  #qpsQiRpt .none{ color:#8a99a3; font-size:12.5px; padding:12px 4px; text-align:center; }
  /* ── 탭 · 글자 크기 (2026-08-15) — 카드가 세로로 쌓여 스크롤이 길다는 지적.
       ★한 화면에 들어가면 **탭을 내지 않는다**(고정으로 달지 않는다).
       ★탭 이름은 카드 제목에서 뽑고, 많으면 이웃끼리 묶어 **최대 4개**. */
  #qpsQiRpt .zz-tabs{ display:flex; gap:6px; margin:0 0 10px; flex-wrap:wrap; align-items:center; }
  #qpsQiRpt .zz-tab{ border:1px solid #cfd9e0; background:#f4f7f9; color:#43555f; border-radius:8px 8px 0 0;
                   padding:7px 15px; font-size:13.5px; font-weight:700; cursor:pointer; }
  #qpsQiRpt .zz-tab:hover{ background:#e9eff3; }
  #qpsQiRpt .zz-tab.on{ background:#1f5a4b; border-color:#1f5a4b; color:#fff; }
  #qpsQiRpt .zz-tab.dim{ opacity:.5; }
  #qpsQiRpt .zz-mode{ margin-left:auto; border:1px solid #1f5a4b; background:#fff; color:#1f5a4b;
                    border-radius:8px; padding:7px 14px; font-size:13px; font-weight:700; cursor:pointer; }
  #qpsQiRpt .zz-mode.on{ background:#1f5a4b; color:#fff; }
  #qpsQiRpt .zz-zoom{ display:inline-flex; gap:4px; align-items:center; margin-left:2px; }
  #qpsQiRpt .zz-zoom button{ border:1px solid #cfd9e0; background:#fff; color:#43555f; border-radius:6px;
                           padding:4px 9px; font-size:13px; font-weight:700; cursor:pointer; }
  #qpsQiRpt .zz-zoom button:hover{ background:#eef3f6; }
</style>

<div class="qr-head">
  <div class="qr-title"><span class="qr-dot"></span><span id="qrTitle">QI활동 중간보고서</span>
    <span class="qr-sub">주제별 1부</span></div>
  <span class="qr-hosp" id="qrHosp">🏥 <c:out value="${hospNm}" default="병원 미확인"/></span>
  <div class="qr-spacer"></div>
  <%-- ★종류 — 최종을 고르면 활동효과·결론 카드가 나타난다 --%>
  <select id="qrGb" style="width:auto;" onchange="qrGbChange();">
    <option value="M">중간보고서</option>
    <option value="F">최종보고서</option>
  </select>
  <select id="qrYear" style="width:auto;" onchange="qrList();"></select>
  <button type="button" class="qr-btn" onclick="qrSave();">저장</button>
  <button type="button" class="qr-btn ghost" onclick="qrPrint();">🖨 인쇄(A4)</button>
  <button type="button" class="qr-btn warn" id="qrDelBtn" onclick="qrDel();" style="display:none;">삭제</button>
  <span class="qr-sub" id="qrStat"></span>
  <span style="flex:0 0 60px;"></span>
  <%-- 글자 크기 — 이 PC 이 브라우저에만 저장된다 --%>
  <span class="zz-zoom">
    <button type="button" onclick="zzZoom(-1);" title="글자 작게">가－</button>
    <button type="button" onclick="zzZoom(1);"  title="글자 크게">가＋</button>
    <button type="button" onclick="zzZoom(0);"  title="처음 크기로">↺</button>
  </span>
</div>
<%-- ★탭 — 내용이 한 화면을 넘칠 때만 나온다(zzSync 가 재 본다) --%>
<div class="zz-tabs" id="zzTabs" style="display:none;"></div>

<div class="qr-wrap">
  <div class="qr-left">
    <div class="qr-card">
      <h4>보고서 목록 <span class="hint" id="qrCnt"></span></h4>
      <div class="qr-list" id="qrListBox"><div class="qr-empty">불러오는 중…</div></div>
      <button type="button" class="qr-btn ghost" style="width:100%; margin-top:6px;" onclick="qrNew();">＋ 새 보고서</button>
    </div>
  </div>

  <div class="qr-right">
    <div class="qr-card">
      <h4><span class="pdca">P</span>기본</h4>
      <input type="hidden" id="f_qirSeq" value="">
      <div class="qr-form">
        <div class="lb">제출일자</div> <div><input type="date" id="f_submitDt"></div>
        <div class="lb">부서</div>     <div><input type="text" id="f_deptNm" maxlength="60"></div>
        <div class="lb">주제 *</div>
        <div class="full" style="display:flex; gap:8px; flex-wrap:wrap;">
          <select id="f_indiCd" style="width:250px;" onchange="qrPickIndi();">
            <option value="">— 지표에서 고르기 (없으면 직접 입력) —</option>
          </select>
          <input type="text" id="f_topicNm" maxlength="200" placeholder="주제" style="flex:1; min-width:200px;">
        </div>
        <div class="lb">주제선정 배경</div> <div class="full"><textarea id="f_background" rows="3"></textarea></div>
      </div>
    </div>

    <div class="qr-card">
      <h4><span class="pdca">P</span>팀 운영 <span class="hint">— 인쇄물에서는 원본처럼 가로 4벌 표로 조립됩니다</span></h4>
      <table class="ed" style="max-width:520px;"><thead><tr>
        <th style="width:110px;">구분</th><th>성명</th><th style="width:26px;"></th>
      </tr></thead><tbody id="tbTEAM"></tbody></table>
      <button type="button" class="qr-btn mini" style="margin-top:6px;" onclick="qrAddTeam();">＋ 행 추가</button>
    </div>

    <div class="qr-card">
      <h4><span class="pdca">P</span>자료수집 및 문제분석</h4>
      <div class="qr-form">
        <div class="lb">조사대상</div> <div class="full"><input type="text" id="f_surveyTarget" maxlength="300"></div>
        <div class="lb">조사기간</div>
        <div class="full" style="display:flex; gap:6px; align-items:center;">
          <input type="text" id="f_surveyFrMm" style="width:60px; text-align:center;" maxlength="2" placeholder="1">
          <span style="font-size:12.5px;">월 ~</span>
          <input type="text" id="f_surveyToMm" style="width:60px; text-align:center;" maxlength="2" placeholder="6">
          <span style="font-size:12.5px;">월</span>
        </div>
        <div class="lb">조사방법</div> <div class="full"><input type="text" id="f_surveyMethod" maxlength="300"></div>
      </div>
      <%-- ★결과분석 — 저장하지 않는다. 주제로 고른 지표에서 계산한다. --%>
      <h4 style="margin-top:14px;">결과분석 <span class="hint" id="qrResHint">— 주제로 지표를 고르면 자동으로 나옵니다</span></h4>
      <table class="st" id="qrResTbl"><tr><td class="none">주제에서 지표를 고르세요.</td></tr></table>
    </div>

    <div class="qr-card">
      <h4><span class="pdca">P</span>현황파악 및 원인분석 · 목표</h4>
      <div class="qr-form">
        <div class="lb">현황파악<br>원인분석</div> <div class="full"><textarea id="f_analysis" rows="4"></textarea></div>
        <div class="lb">목표</div>
        <div class="full"><textarea id="f_goalTxt" rows="2" placeholder="한 줄에 하나 — 예) 낙상 발생 보고율을 0.5‰ 이하로 줄이자"></textarea></div>
      </div>
    </div>

    <div class="qr-card">
      <h4><span class="pdca">P</span>개선활동계획 <span class="hint">— 개선내용과 일정</span></h4>
      <table class="ed"><thead><tr>
        <th>개선 내용</th><th style="width:170px;">일정</th><th style="width:26px;"></th>
      </tr></thead><tbody id="tbIMPR"></tbody></table>
      <button type="button" class="qr-btn mini" style="margin-top:6px;" onclick="qrAddImpr();">＋ 행 추가</button>
      <div style="margin-top:10px;"><textarea id="f_planTxt" rows="3" placeholder="개선활동계획 서술(선택)"></textarea></div>
    </div>

    <div class="qr-card">
      <h4><span class="pdca">D</span><span id="qrActLb">실행</span></h4>
      <textarea id="f_actTxt" rows="5"></textarea>
    </div>

    <div class="qr-card" id="cardNote">
      <h4>비고</h4>
      <textarea id="f_note" rows="2"></textarea>
    </div>

    <%-- ───── 최종보고서에서만 ───── --%>
    <div class="qr-card" id="cardEffect" style="display:none;">
      <h4><span class="pdca">C</span>활동효과 <span class="hint">— 표는 지표에서 자동으로 나옵니다. 아래 칸에 해석을 적으세요</span></h4>
      <table class="st" id="qrEffTbl"><tr><td class="none">주제에서 지표를 고르세요.</td></tr></table>
      <div style="margin-top:10px;"><textarea id="f_effectTxt" rows="4"></textarea></div>
    </div>

    <div class="qr-card" id="cardConcl" style="display:none;">
      <h4><span class="pdca">A</span>결론 및 제언</h4>
      <textarea id="f_conclTxt" rows="4"></textarea>
    </div>

    <div class="qr-card">
      <h4>사진 · 첨부파일 <span class="hint">— 원본 개선활동 면의 사진 자리를 첨부로 대신합니다</span></h4>
      <div id="qrFileBox"></div>
    </div>
  </div>
</div>

<script>
(function(){
  // QBD = 분기별 분류집계(활동효과 v2). 사고형이면 위해등급·사고분류, 관찰형이면 직종·시점이 들어온다.
  var HOSP_NM = '', APPR_LINE = [], INDI = [], curSeq = 0, CALC = null, QBD = [];

  var fileBox = window.qpsFileBox({ mount:'qrFileBox', refGb:'QIRPT',
      hint:'개선활동 사진', needSaveMsg:'보고서를 먼저 저장하면 사진을 붙일 수 있습니다.' });

  function gel(id){ return document.getElementById(id); }   // ★$ 로 짓지 말 것
  function post(url, data){
    return $.ajax({ url:url, type:'POST', data:data, dataType:'json' }).then(function(res){
      if (res && res.result === 'FAIL') { throw new Error(res.message || '처리에 실패했습니다.'); }
      return res;
    });
  }
  function err(e){ _alertBox((e && e.message) ? e.message : '처리 중 오류가 발생했습니다.', {icon:'❌'}); }
  function esc(s){ return (s==null?'':String(s)).replace(/[&<>"]/g, function(c){
      return ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;'})[c]; }); }
  function val(id){ var e = gel(id); return e ? String(e.value).trim() : ''; }
  function set(id, v){ var e = gel(id); if (e) e.value = (v == null ? '' : v); }
  function gb(){ return gel('qrGb').value; }

  (function(){
    var y = new Date().getFullYear(), sel = gel('qrYear');
    for (var i = y + 1; i >= y - 4; i--) sel.add(new Option(i + '년', i));
    sel.value = y;
  })();

  /** 종류에 따라 화면을 바꾼다 — 최종에만 활동효과·결론이 있다. */
  window.qrGbChange = function(){
    var f = (gb() === 'F');
    gel('qrTitle').textContent = f ? 'QI활동 최종보고서' : 'QI활동 중간보고서';
    gel('qrActLb').textContent = f ? '개선활동' : '실행';
    gel('cardEffect').style.display = f ? '' : 'none';
    gel('cardConcl').style.display  = f ? '' : 'none';
    gel('cardNote').style.display   = f ? 'none' : '';   // 비고는 중간에만 있다
    qrList();
  };

  function teamRow(r){
    r = r || {};
    var tr = document.createElement('tr');
    tr.setAttribute('data-sect','TEAM');
    tr.innerHTML = '<td><input data-f="grp" value="' + esc(r.grp) + '" placeholder="팀장·간사·팀원"></td>' +
      '<td><input data-f="c1" value="' + esc(r.c1) + '"></td>' +
      '<td class="rowdel" onclick="this.closest(\'tr\').remove();">✕</td>';
    gel('tbTEAM').appendChild(tr);
  }
  function imprRow(r){
    r = r || {};
    var tr = document.createElement('tr');
    tr.setAttribute('data-sect','IMPR');
    tr.innerHTML = '<td><input data-f="c1" value="' + esc(r.c1) + '"></td>' +
      '<td><input data-f="c2" value="' + esc(r.c2) + '"></td>' +
      '<td class="rowdel" onclick="this.closest(\'tr\').remove();">✕</td>';
    gel('tbIMPR').appendChild(tr);
  }
  window.qrAddTeam = function(){ teamRow({}); };
  window.qrAddImpr = function(){ imprRow({}); };

  var DEF_TEAM = [{grp:'팀장'},{grp:'간사'},{grp:'팀원'},{grp:'팀원'}];

  function collect(){
    var items = [];
    ['TEAM','IMPR'].forEach(function(sect){
      var sort = 0;
      document.querySelectorAll('#tb' + sect + ' tr').forEach(function(tr){
        var r = { sect:sect };
        tr.querySelectorAll('[data-f]').forEach(function(el){ r[el.getAttribute('data-f')] = String(el.value).trim(); });
        var has = Object.keys(r).some(function(k){ return k !== 'sect' && r[k] !== ''; });
        if (!has) return;
        r.sort = ++sort;
        items.push(r);
      });
    });
    return items;
  }

  /* 주제로 지표를 고르면 결과분석·활동효과 표를 지표에서 그린다.
     ★수치는 저장하지 않는다 — 볼 때마다 다시 센다(지표 화면과 어긋날 수 없게). */
  window.qrPickIndi = function(){
    var cd = val('f_indiCd');
    if (!cd) { CALC = null; QBD = []; renderStat(); return; }
    var d = null;
    for (var i = 0; i < INDI.length; i++) if (String(INDI[i].indicd) === cd) { d = INDI[i]; break; }
    if (d && !val('f_topicNm')) set('f_topicNm', d.indinm);
    var yy = gel('qrYear').value;
    post('<c:url value="/qps/indiCalc.do"/>', { indiCd: cd, inYear: yy }).then(function(res){
      CALC = res || null;
      renderStat();                       // 먼저 그린다 — 분류집계는 늦게 와도 표가 비어 보이지 않게
      // 활동효과 v2 — 분기별 분류집계. ★실패해도 본 표는 그대로 둔다(있으면 좋은 것이지 없으면 안 되는 게 아니다)
      return post('<c:url value="/qps/indiBreakQtr.do"/>', { indiCd: cd, inYear: yy }).then(function(r2){
        QBD = (r2 && r2.quarters) || [];
        renderStat();
      }).catch(function(){ QBD = []; });
    }).catch(function(){ CALC = null; QBD = []; renderStat(); });
  };

  function fmt(v, dec){
    if (v == null) return '-';
    var d = (dec == null) ? 2 : Number(dec);
    return Number(v).toFixed(d);
  }
  /** 결과분석·활동효과 — 축은 지표 유형이 정한다(관찰형=분기 %, 사고형=월별 건수). */
  function renderStat(){
    var res = gel('qrResTbl'), eff = gel('qrEffTbl');
    if (!CALC || !CALC.indi) {
      res.innerHTML = '<tr><td class="none">주제에서 지표를 고르세요.</td></tr>';
      eff.innerHTML = '<tr><td class="none">주제에서 지표를 고르세요.</td></tr>';
      return;
    }
    var ind = CALC.indi || {}, unit = ind.unit || '', dec = ind.decimals;
    var months = CALC.months || [], quarters = CALC.quarters || [];
    var isIncid = (String(ind.numersrc) !== 'MONITOR');   // 사고형이면 월별 건수를 함께 본다

    // 결과분석 : 분기별 율 (+ 사고형은 월별 건수)
    var h = '<thead><tr><th style="width:150px;">구분</th>';
    quarters.forEach(function(q){ h += '<th>' + esc(q.prd || q.key || '') + '</th>'; });
    h += '</tr></thead><tbody><tr><td class="l">' + esc(ind.indinm || '') + ' (' + esc(unit) + ')</td>';
    quarters.forEach(function(q){ h += '<td>' + fmt(q.rate, dec) + '</td>'; });
    h += '</tr><tr><td class="l">분자 / 분모</td>';
    quarters.forEach(function(q){ h += '<td>' + (q.numer == null ? '-' : q.numer) + ' / ' + (q.denom == null ? '-' : q.denom) + '</td>'; });
    h += '</tr></tbody>';
    res.innerHTML = h;
    gel('qrResHint').textContent = isIncid ? '— 분기별 발생률(월별 건수는 인쇄물에 함께 나갑니다)' : '— 분기별 수행률';

    // 활동효과(최종) : 분기 + 연간 + 목표값 달성여부
    var goal = String(val('f_goalTxt')).match(/([0-9]+(\.[0-9]+)?)/);
    var yr = CALC.year || {};
    var e = '<thead><tr><th style="width:150px;">구분</th>';
    quarters.forEach(function(q){ e += '<th>' + esc(q.prd || q.key || '') + '</th>'; });
    e += '<th>연간</th><th style="width:110px;">목표값 달성여부</th></tr></thead><tbody>';
    e += '<tr><td class="l">' + esc(ind.indinm || '') + ' (' + esc(unit) + ')</td>';
    quarters.forEach(function(q){ e += '<td>' + fmt(q.rate, dec) + '</td>'; });
    e += '<td><b>' + fmt(yr.rate, dec) + '</b></td><td>' + goalMet(yr.rate, goal, ind) + '</td></tr>';
    e += '<tr><td class="l">보고건수(분자)</td>';
    quarters.forEach(function(q){ e += '<td>' + (q.numer == null ? '-' : q.numer) + '</td>'; });
    e += '<td>' + (yr.numer == null ? '-' : yr.numer) + '</td><td>—</td></tr>';
    // ★v2 — 원본이 요구하는 축을 분기 4벌로 덧붙인다.
    //   사고형 = 위해등급(level 3·4)·사고분류 / 관찰형 = 직종별·시점별.
    //   자료는 QBD(분기별 분류집계)에 이미 들어와 있다 — 지표 화면과 같은 쿼리다.
    e += effAxisRows(ind);
    e += '</tbody>';
    eff.innerHTML = e;
  }

  /** 활동효과 v2 — 분기별 분류집계(QBD)를 표 행으로. 자료가 없으면 아무것도 안 붙인다. */
  function effAxisRows(ind){
    if (!QBD || !QBD.length) return '';
    var isMon = (String(ind.numersrc) === 'MONITOR');
    // 사고형은 위해등급(LEVEL 3·4)과 사고분류, 관찰형은 직종·시점
    var axes = isMon ? [['JOB','직종별'], ['MOMENT','시점별']]
                     : [['HARM','사고분류']];
    var out = '';
    function cell(bd, axis, code){
      var list = (bd && bd[axis]) || [];
      for (var i = 0; i < list.length; i++) if (String(list[i].code) === code) return list[i];
      return null;
    }
    axes.forEach(function(ax){
      // 그 해에 실제로 나온 구분만 행으로 만든다 — 코드표를 박으면 안 쓰는 구분이 빈 줄로 남는다
      var codes = [];
      QBD.forEach(function(q){
        ((q.bd && q.bd[ax[0]]) || []).forEach(function(r){
          if (codes.indexOf(String(r.code)) < 0) codes.push(String(r.code));
        });
      });
      if (!codes.length) return;
      codes.sort();
      out += '<tr><td class="l" style="background:#f2f6f8;"><b>' + esc(ax[1]) + '</b></td>' +
             '<td colspan="' + (QBD.length + 2) + '" style="background:#f2f6f8;"></td></tr>';
      codes.forEach(function(cd){
        var tot = 0, tds = '';
        QBD.forEach(function(q){
          var r = cell(q.bd, ax[0], cd);
          if (isMon) {
            // 관찰형은 수행/관찰 → 수행률
            tds += '<td>' + (r ? (fmt(r.rate, ind.decimals) + '%') : '-') + '</td>';
          } else {
            var c = r ? Number(r.cnt || 0) : 0;
            tot += c;
            tds += '<td>' + (r ? c : '-') + '</td>';
          }
        });
        out += '<tr><td class="l">　' + esc(cd) + '</td>' + tds +
               '<td>' + (isMon ? '—' : tot) + '</td><td>—</td></tr>';
      });
    });
    // 사고형은 원본이 「위해등급 level 3·4 건수」를 따로 본다 — 사고분류만으로는 3·4 가 안 보인다
    if (!isMon) {
      var lv34 = '', any = false, tot34 = 0;
      QBD.forEach(function(q){
        var list = (q.bd && q.bd.HARM) || [], c = 0;
        list.forEach(function(r){ if (String(r.code).indexOf('위해사건') === 0) c += Number(r.cnt || 0); });
        if (list.length) any = true;
        tot34 += c;
        lv34 += '<td>' + c + '</td>';
      });
      if (any) out += '<tr><td class="l"><b>위해사건(Level 2~4)</b></td>' + lv34 +
                      '<td><b>' + tot34 + '</b></td><td>—</td></tr>';
    }
    return out;
  }
  /** 목표는 문장이라 숫자만 뽑아 비교한다.
   *  ★방향은 지표정의서의 목표방향(GOAL_DIR)을 쓴다 — 단위로 가르면 틀린다(2026-08-11 수정).
   *    종전에는 `unit==='%'` 면 높을수록 좋다고 봤는데, 직원감염노출·직원안전사고 **발생률**도 단위가 % 라
   *    그 둘이 거꾸로 판정됐다. 지표분석보고서 인쇄물과 같은 기준을 쓴다. */
  function goalMet(rate, goal, ind){
    if (rate == null || !goal) return '—';
    var g = Number(goal[1]), r = Number(rate);
    var ok = ((ind && ind.goaldir) === 'H') ? (r >= g) : (r <= g);
    return ok ? '<b style="color:#1f5a4b;">충족</b>' : '<b style="color:#b23b3b;">미충족</b>';
  }

  window.qrList = function(){
    return post('<c:url value="/qps/qiRptList.do"/>', { inYear: gel('qrYear').value, rptGb: gb() }).then(function(res){
      if (res.hosp) { HOSP_NM = res.hosp.hospnm || ''; gel('qrHosp').textContent = '🏥 ' + HOSP_NM; }
      APPR_LINE = res.line || [];
      INDI = res.indi || [];
      var sel = gel('f_indiCd'), keep = sel.value;
      sel.innerHTML = '<option value="">— 지표에서 고르기 (없으면 직접 입력) —</option>';
      INDI.forEach(function(d){ sel.add(new Option(d.indinm, d.indicd)); });
      sel.value = keep;

      var list = res.list || [], box = gel('qrListBox');
      gel('qrCnt').textContent = list.length ? ('· ' + list.length + '건') : '';
      if (!list.length) { box.innerHTML = '<div class="qr-empty">보고서가 없습니다.<br>[＋ 새 보고서]로 만드세요.</div>'; return; }
      box.innerHTML = list.map(function(r){
        return '<div class="qr-item' + (Number(r.qirseq) === curSeq ? ' on' : '') + '" onclick="qrOpen(' + r.qirseq + ');">' +
               '<div class="t">' + esc(r.topicnm || '(주제 없음)') + '</div>' +
               '<div class="d">' + esc(r.deptnm || '') + (r.submitdt ? ' · ' + esc(r.submitdt) : '') + '</div></div>';
      }).join('');
    }).catch(err);
  };

  window.qrOpen = function(seq){
    post('<c:url value="/qps/qiRptGet.do"/>', { qirSeq: seq }).then(function(res){
      var d = res.doc || {};
      curSeq = Number(d.qirseq || 0);
      if (d.rptgb) { gel('qrGb').value = d.rptgb; }
      set('f_qirSeq', d.qirseq); set('f_indiCd', d.indicd || ''); set('f_topicNm', d.topicnm);
      set('f_deptNm', d.deptnm); set('f_submitDt', d.submitdt); set('f_background', d.background);
      set('f_surveyTarget', d.surveytarget); set('f_surveyFrMm', d.surveyfrmm);
      set('f_surveyToMm', d.surveytomm); set('f_surveyMethod', d.surveymethod);
      set('f_analysis', d.analysis); set('f_goalTxt', d.goaltxt);
      set('f_actTxt', d.acttxt); set('f_planTxt', d.plantxt); set('f_note', d.note);
      set('f_effectTxt', d.effecttxt); set('f_conclTxt', d.concltxt);
      gel('tbTEAM').innerHTML = ''; gel('tbIMPR').innerHTML = '';
      var items = res.items || [];
      var team = items.filter(function(r){ return r.sect === 'TEAM'; });
      var impr = items.filter(function(r){ return r.sect === 'IMPR'; });
      (team.length ? team : DEF_TEAM).forEach(teamRow);
      (impr.length ? impr : [{},{},{}]).forEach(imprRow);
      // 종류가 바뀌었을 수 있으니 카드 표시를 맞춘다(목록은 다시 부르지 않는다)
      var f = (gb() === 'F');
      gel('qrTitle').textContent = f ? 'QI활동 최종보고서' : 'QI활동 중간보고서';
      gel('qrActLb').textContent = f ? '개선활동' : '실행';
      gel('cardEffect').style.display = f ? '' : 'none';
      gel('cardConcl').style.display  = f ? '' : 'none';
      gel('cardNote').style.display   = f ? 'none' : '';
      gel('qrStat').textContent = '— 저장된 보고서 #' + d.qirseq;
      gel('qrDelBtn').style.display = '';
      if (fileBox) fileBox.setKey(d.qirseq);
      qrPickIndi();
      qrList();
    }).catch(err);
  };

  window.qrNew = function(){
    curSeq = 0; CALC = null; QBD = [];
    ['f_qirSeq','f_indiCd','f_topicNm','f_deptNm','f_submitDt','f_background','f_surveyTarget',
     'f_surveyFrMm','f_surveyToMm','f_surveyMethod','f_analysis','f_goalTxt','f_actTxt',
     'f_planTxt','f_note','f_effectTxt','f_conclTxt'].forEach(function(id){ set(id, ''); });
    gel('tbTEAM').innerHTML = ''; gel('tbIMPR').innerHTML = '';
    DEF_TEAM.forEach(teamRow);
    [{},{},{}].forEach(imprRow);
    renderStat();
    gel('qrStat').textContent = '— 새 보고서';
    gel('qrDelBtn').style.display = 'none';
    if (fileBox) fileBox.setKey('');
    qrList();
  };

  window.qrSave = function(){
    if (!val('f_topicNm')) { _alertBox('주제를 입력해 주세요.', {icon:'⚠️'}); return; }
    post('<c:url value="/qps/qiRptSave.do"/>', {
      qirSeq: val('f_qirSeq'), inYear: gel('qrYear').value, rptGb: gb(),
      indiCd: val('f_indiCd'), topicNm: val('f_topicNm'), deptNm: val('f_deptNm'),
      submitDt: val('f_submitDt'), background: val('f_background'),
      surveyTarget: val('f_surveyTarget'), surveyFrMm: val('f_surveyFrMm'),
      surveyToMm: val('f_surveyToMm'), surveyMethod: val('f_surveyMethod'),
      analysis: val('f_analysis'), goalTxt: val('f_goalTxt'),
      actTxt: val('f_actTxt'), planTxt: val('f_planTxt'), note: val('f_note'),
      effectTxt: val('f_effectTxt'), conclTxt: val('f_conclTxt'),
      items: JSON.stringify(collect())
    }).then(function(res){
      _toast('저장되었습니다.', 'ok');
      qrOpen(res.qirSeq);
    }).catch(err);
  };

  window.qrDel = function(){
    if (!curSeq) return;
    _confirmBox({ msg:'이 보고서를 삭제할까요?', icon:'⚠️', okText:'삭제', okColor:'#b23b3b',
      onOk: function(){
        post('<c:url value="/qps/qiRptDelete.do"/>', { qirSeq: curSeq }).then(function(){
          _toast('삭제되었습니다.', 'ok'); qrNew();
        }).catch(err);
      } });
  };

  // ---------- 인쇄 ----------
  var PRINT_CSS =
    '@page{ size:A4 portrait; margin:11mm; }' +
    'body{ margin:0; font-family:"맑은 고딕",Malgun Gothic,sans-serif; color:#000; }' +
    '.h1{ font-size:17px; font-weight:800; text-align:center; margin:0 0 8px; letter-spacing:1px; }' +
    'table{ width:100%; border-collapse:collapse; font-size:10px; margin-bottom:5px; }' +
    'th,td{ border:1px solid #666; padding:3px 4px; text-align:center; vertical-align:middle; line-height:1.5; }' +
    'th{ background:#efefef; font-weight:700; }' +
    'td.l{ text-align:left; } td.pre{ text-align:left; white-space:pre-wrap; }' +
    '.appr{ float:right; width:auto; margin:0 0 4px 8px; font-size:9.5px; }' +
    '.appr th{ padding:2px 6px; } .appr td{ height:40px; width:56px; }' +
    '.brk{ page-break-before:always; } tr{ page-break-inside:avoid; }';

  function apprHtml(){
    if (!APPR_LINE.length) return '';
    var h = '<table class="appr"><thead><tr>';
    APPR_LINE.forEach(function(r){ h += '<th>' + esc(r.stepnm) + '</th>'; });
    h += '</tr></thead><tbody><tr>';
    APPR_LINE.forEach(function(){ h += '<td></td>'; });
    return h + '</tr></tbody></table>';
  }

  window.qrPrint = function(){
    var yy = gel('qrYear').value, f = (gb() === 'F'), items = collect();
    var team = items.filter(function(r){ return r.sect === 'TEAM'; });
    var impr = items.filter(function(r){ return r.sect === 'IMPR'; });

    var trs = '';
    for (var i = 0; i < team.length; i += 4) {
      var tds = '';
      for (var k = 0; k < 4; k++) {
        var m = team[i + k];
        tds += '<th style="width:7%;">' + (m ? esc(m.grp) : '') + '</th>' +
               '<td style="width:18%;">' + (m ? esc(m.c1) : '') + '</td>';
      }
      trs += '<tr>' + tds + '</tr>';
    }

    function box(v, h){ return '<div style="border:1px solid #666;padding:5px 7px;font-size:10px;white-space:pre-wrap;text-align:left;min-height:' + (h||44) + 'px;">' + esc(v) + '</div>'; }
    var body = apprHtml() +
      '<div class="h1">' + esc(yy) + ' 년 QI활동 ' + (f ? '최종' : '중간') + '보고서</div><div style="clear:both;"></div>' +
      '<table><tbody><tr><th style="width:90px;">제출일자</th><td class="l" style="width:33%;">' + esc(val('f_submitDt')) + '</td>' +
        '<th style="width:70px;">부서</th><td class="l">' + esc(val('f_deptNm')) + '</td></tr>' +
        '<tr><th>주제</th><td class="l" colspan="3">' + esc(val('f_topicNm')) + '</td></tr></tbody></table>' +
      '<table><tbody><tr><th style="width:90px;">주제선정 배경</th><td class="pre" style="height:50px;">' +
        esc(val('f_background')) + '</td></tr></tbody></table>' +
      (trs ? '<table><tbody>' + trs + '</tbody></table>' : '') +
      '<table><tbody>' +
        '<tr><th style="width:90px;" rowspan="4">자료수집 및<br>문제분석</th><th style="width:80px;">조사대상</th>' +
          '<td class="l">' + esc(val('f_surveyTarget')) + '</td></tr>' +
        '<tr><th>조사기간</th><td class="l">' + esc(val('f_surveyFrMm')) + ' 월 ~ ' + esc(val('f_surveyToMm')) + ' 월</td></tr>' +
        '<tr><th>조사방법</th><td class="l">' + esc(val('f_surveyMethod')) + '</td></tr>' +
        '<tr><th>결과분석</th><td>' + (gel('qrResTbl').innerHTML ? '<table>' + gel('qrResTbl').innerHTML + '</table>' : '') + '</td></tr>' +
      '</tbody></table>' +
      '<table><tbody><tr><th style="width:90px;">현황파악 및<br>원인분석</th><td class="pre" style="height:70px;">' +
        esc(val('f_analysis')) + '</td></tr>' +
        '<tr><th>' + (f ? '목표' : '활동목표') + '</th><td class="pre">' + esc(val('f_goalTxt')) + '</td></tr></tbody></table>' +
      (impr.length ? '<table><thead><tr><th style="width:90px;" rowspan="' + (impr.length + 1) + '">개선활동계획</th>' +
          '<th>개선 내용</th><th style="width:120px;">일 정</th></tr>' +
          impr.map(function(r){ return '<tr><td class="l">' + esc(r.c1) + '</td><td>' + esc(r.c2) + '</td></tr>'; }).join('') +
          '</thead></table>' : '') +
      (val('f_planTxt') ? '<table><tbody><tr><th style="width:90px;">개선활동계획</th><td class="pre">' + esc(val('f_planTxt')) + '</td></tr></tbody></table>' : '') +
      '<div class="brk"></div>' +
      '<table><tbody><tr><th style="width:90px;">' + (f ? '개선활동' : '실행') + '</th><td class="pre" style="height:150px;">' +
        esc(val('f_actTxt')) + '</td></tr>' +
        (f ? '' : '<tr><th>비고</th><td class="pre" style="height:50px;">' + esc(val('f_note')) + '</td></tr>') +
      '</tbody></table>' +
      (f ? ('<div class="brk"></div><table><tbody><tr><th style="width:90px;">활동효과</th><td>' +
              '<table>' + gel('qrEffTbl').innerHTML + '</table>' +
              '<div style="text-align:left;white-space:pre-wrap;font-size:10px;margin-top:4px;">' + esc(val('f_effectTxt')) + '</div>' +
            '</td></tr>' +
            '<tr><th>결론 및 제언</th><td class="pre" style="height:120px;">' + esc(val('f_conclTxt')) + '</td></tr></tbody></table>')
         : '') +
      '<div style="font-size:9.5px;color:#444;margin-top:4px;">※ 사진은 첨부파일로 관리합니다.</div>';

    var title = ('QI' + (f ? '최종' : '중간') + '보고서_' + yy + '_' + val('f_topicNm') + '_' + HOSP_NM).replace(/[\\\/:*?"<>|]/g, '-');
    var w = window.open('', '_blank', 'width=900,height=1000');
    if (!w) { _alertBox('팝업이 차단되어 인쇄창을 열지 못했습니다.<br>주소창 오른쪽의 팝업 차단을 허용해 주세요.', {icon:'⚠️'}); return; }
    w.document.open();
    w.document.write('<!doctype html><html lang="ko"><head><meta charset="utf-8"><title>' + esc(title) +
      '</title><style>' + PRINT_CSS + '</style></head><body>' + body + '</body></html>');
    w.document.close();
    w.focus();
    setTimeout(function(){ try { w.print(); } catch (e) { } }, 300);
  };

  // 목표를 고치면 달성여부 판정이 바로 바뀌게
  gel('f_goalTxt').addEventListener('input', function(){ if (CALC) renderStat(); });

  $(function(){ qrNew(); });
})();

  /* ═══ 탭 · 글자 크기 (2026-08-15 · 사용자 요청) ═══════════════════════════
     ★***고정으로 달지 않는다*** — 전부 펼친 높이를 재서 **한 화면을 넘칠 때만** 탭을 낸다.
       창 크기·글자 크기가 바뀌면 다시 잰다.
     ★탭이 **잘게 나뉘지 않게** 이웃 카드를 묶어 최대 4개. 이름은 첫 카드 제목(+「외」).
     ★「전체 보기」는 탭이 아니라 **보기 방식**이라 오른쪽 끝에 따로 둔다.
     ⚠인쇄는 별도 창이라 탭과 무관하다(숨긴 항목도 종이에는 다 나온다). */
  (function(){
    var KEY = 'qpsTab_qpsQiRpt', ZKEY = 'qpsZoom_qpsQiRpt', cur = 0;
    function cards(){ return [].slice.call(document.querySelectorAll('#qpsQiRpt .qr-card')); }
    function nm(c, i){
      var h = c.querySelector('h4');
      if (!h) return '항목 ' + (i + 1);
      var t = h.cloneNode(true), hint = t.querySelector('.hint');
      if (hint) hint.remove();
      return (t.textContent || '').trim().slice(0, 20) || ('항목 ' + (i + 1));
    }
    function fits(cs){
      if (cs.length < 2) return true;
      var prev = cs.map(function(c){ return c.style.display; });
      cs.forEach(function(c){ c.style.display = ''; });
      var h = 0;
      cs.forEach(function(c){ h += c.offsetHeight + 12; });
      cs.forEach(function(c, i){ c.style.display = prev[i]; });
      return h <= (window.innerHeight - 170);
    }
    function sync(){
      var cs = cards(), box = document.getElementById('zzTabs');
      if (!box || !cs.length) return;
      if (fits(cs)) {                       // 한 화면에 들어간다 — 탭이 필요 없다
        box.style.display = 'none';
        cs.forEach(function(c){ c.style.display = ''; });
        return;
      }
      box.style.display = '';
      var MAX = 4, per = Math.ceil(cs.length / MAX), groups = [];
      for (var s0 = 0; s0 < cs.length; s0 += per) groups.push(cs.slice(s0, s0 + per));
      if (cur >= groups.length) cur = 0;
      var all = (cur === -1);
      box.innerHTML = groups.map(function(g, i){
        return '<button type="button" class="zz-tab' + (!all && cur === i ? ' on' : '') +
               (all ? ' dim' : '') + '" onclick="zzTab(' + i + ');">' +
               nm(g[0], 0) + (g.length > 1 ? ' 외' : '') + '</button>';
      }).join('') +
        '<button type="button" class="zz-mode' + (all ? ' on' : '') + '" onclick="zzTab(' +
        (all ? '0' : '-1') + ');">' + (all ? '▤ 나눠 보기' : '☰ 전체 보기') + '</button>';
      groups.forEach(function(g, i){
        g.forEach(function(c){ c.style.display = (all || cur === i) ? '' : 'none'; });
      });
    }
    window.zzTab = function(i){ cur = i; try { localStorage.setItem(KEY, String(i)); } catch (e) {} sync(); };
    function zoom(z){
      z = Math.min(1.6, Math.max(0.8, z));
      var w = document.getElementById('qpsQiRpt');
      if (w) w.style.zoom = z.toFixed(2);
      return z;
    }
    window.zzZoom = function(d){
      var w = document.getElementById('qpsQiRpt'), c0 = parseFloat(w && w.style.zoom) || 1;
      if (d === 0) { zoom(1); try { localStorage.removeItem(ZKEY); } catch (e) {} setTimeout(sync, 0); return; }
      var z = zoom(c0 + d * 0.1);
      try { localStorage.setItem(ZKEY, String(z)); } catch (e) {}
      setTimeout(sync, 0);
    };
    try {
      var t = parseInt(localStorage.getItem(KEY), 10); if (!isNaN(t)) cur = t;
      var z = parseFloat(localStorage.getItem(ZKEY)); if (z) zoom(z);
    } catch (e) {}
    function boot(){ setTimeout(sync, 0); }
    if (window.jQuery) jQuery(boot); else document.addEventListener('DOMContentLoaded', boot);
    /* ★내용이 **나중에** 채워지면 다시 잰다 (2026-08-15).
       카드 속은 AJAX 로 채우는데 높이는 부팅 직후에 쟀다 — 긴 문서인데도
       「한 화면에 들어간다」로 잘못 보고 탭이 안 나오던 구멍이다.
       ⚠**탭 띠 자신이 바뀐 것은 무시한다** — 안 그러면 재기→그리기→재기 로 서로 부른다. */
    if (window.MutationObserver) {
      var _mw = document.getElementById('qpsQiRpt'), _mt;
      if (_mw) new MutationObserver(function(ms){
        var box = document.getElementById('zzTabs');
        for (var i = 0; i < ms.length; i++) {
          if (!box || !box.contains(ms[i].target)) {
            clearTimeout(_mt); _mt = setTimeout(sync, 250); return;
          }
        }
      }).observe(_mw, { childList: true, subtree: true });
    }
    var _t; window.addEventListener('resize', function(){ clearTimeout(_t); _t = setTimeout(sync, 200); });
    window.zzResync = sync;
  })();
</script>
</div><%-- /#qpsQiRpt --%>
</div><%-- /.dashboard-wrapper --%>
