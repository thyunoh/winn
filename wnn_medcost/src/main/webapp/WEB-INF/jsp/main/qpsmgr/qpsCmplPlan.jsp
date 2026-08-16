<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%-- qpsCmplPlan.jsp — 불만고충 처리계획서 (2026-08-11)

     ★새 테이블·새 엔드포인트를 만들지 않았다.
       연간 활동계획서가 쓰는 TBL_QPS_PLAN / TBL_QPS_PLAN_ITEM 을 그대로 쓰고
       서식구분 FORM_GB 에 'C'(불만고충)를 얹었다 — Q=질향상 / I=감염관리 / S=만족도 / C=불만고충.
       유니크 키가 (병원, 구분, 년도)라 서로 안 부딪히고, 항목표는 SECT_CD 로 갈리는 범용 표다.
       첨부 키도 같은 규칙 : REF_GB='PLAN', REF_KEY='2026|C'.

     섹션 3개
       INTRO : 항목 | 내용   (주제명·배경·문제개요·자료수집·핵심지표)
       TEAM  : 구분 | 성명   (★만족도 계획서엔 없던 표 — 불만고충은 팀을 꾸려 다루는 활동이다)
       SCHED : 활동 | 월 1~12 체크 (원본이 12개월 전체다)
       TOOL  : 분석·통계도구 체크(막대그래프/원그래프) 한 줄

     ★주의: 이 파일 안에서 Deferred EL 표기(샵+중괄호) 금지 --%>

<script src="/asset/js/ui-message.js"></script>
<%@ include file="/WEB-INF/jsp/main/inc/qpsFileBox.jsp" %>

<div class="dashboard-wrapper">
<div id="qpsCmplPlan" data-wnn="<c:out value='${wnnYn}'/>">
<style>
  #qpsCmplPlan{ background:#f4f6f8; color:#1f2a30; min-height:100%; padding:14px 16px 60px; max-width:100%; overflow-x:hidden; }
  #qpsCmplPlan *{ box-sizing:border-box; }
  #qpsCmplPlan .qp-head{ display:flex; align-items:center; gap:10px; margin-bottom:12px; flex-wrap:wrap; }
  #qpsCmplPlan .qp-title{ font-size:18px; font-weight:800; color:#20303a; display:flex; align-items:center; gap:8px; }
  #qpsCmplPlan .qp-dot{ width:10px; height:10px; border-radius:50%; background:linear-gradient(135deg,#1f5a4b,#2a7665); }
  #qpsCmplPlan .qp-sub{ font-size:12px; color:#6b7c86; }
  #qpsCmplPlan .qp-hosp{ background:#e7f3ee; color:#1f5a4b; font-size:12px; font-weight:800;
      border:1px solid #cfe3da; border-radius:14px; padding:3px 11px; }
  #qpsCmplPlan .qp-spacer{ flex:1; }
  #qpsCmplPlan select, #qpsCmplPlan input, #qpsCmplPlan textarea{
      border:1px solid #cfd8e0; border-radius:5px; padding:5px 7px; font-family:inherit; font-size:12.5px; background:#fff; }
  #qpsCmplPlan textarea{ resize:vertical; line-height:1.55; }
  #qpsCmplPlan .qp-btn{ border:1px solid #1f5a4b; background:#1f5a4b; color:#fff; border-radius:6px;
      padding:6px 14px; font-size:13px; font-weight:600; cursor:pointer; white-space:nowrap; }
  #qpsCmplPlan .qp-btn.ghost{ background:#fff; color:#1f5a4b; }
  #qpsCmplPlan .qp-btn.mini{ padding:2px 9px; font-size:11.5px; border-color:#cfd8e0; color:#556570; background:#fff; }
  #qpsCmplPlan .qp-btn:hover{ opacity:.9; }

  #qpsCmplPlan .qp-card{ background:#fff; border:1px solid #e3e9ed; border-radius:10px; padding:14px 16px; margin-bottom:14px; }
  #qpsCmplPlan .qp-card h4{ margin:0 0 10px; font-size:14px; font-weight:800; color:#1f5a4b; }
  #qpsCmplPlan .qp-card h4 .hint{ font-weight:500; font-size:12px; color:#8a99a3; }
  #qpsCmplPlan table.ed{ width:100%; border-collapse:collapse; font-size:12.5px; }
  #qpsCmplPlan table.ed th{ background:#f2f6f8; border:1px solid #dde5ea; padding:5px 6px; font-weight:700; color:#43555f; white-space:nowrap; }
  #qpsCmplPlan table.ed td{ border:1px solid #e6ecef; padding:3px; vertical-align:top; }
  #qpsCmplPlan table.ed input, #qpsCmplPlan table.ed textarea{ width:100%; border:none; background:transparent; padding:4px 5px; }
  #qpsCmplPlan table.ed input:focus, #qpsCmplPlan table.ed textarea:focus{ background:#f7fbf9; outline:1px solid #8fc3b2; }
  /* 공통 CSS 가 체크박스를 감추는 화면이 있다 → 기본 모양 복원 */
  #qpsCmplPlan input[type=checkbox]{
      -webkit-appearance:checkbox !important; appearance:auto !important;
      width:15px !important; height:15px !important; display:inline-block !important;
      opacity:1 !important; visibility:visible !important; position:static !important; cursor:pointer; margin:0 4px 0 0 !important; }
  #qpsCmplPlan table.ed input[type=checkbox]{ margin:4px auto !important; display:block !important; }
  #qpsCmplPlan .rowdel{ color:#b23b3b; cursor:pointer; font-weight:700; text-align:center; width:26px; }
  /* ── 탭 · 글자 크기 (2026-08-15) — 카드가 세로로 쌓여 스크롤이 길다는 지적.
       ★한 화면에 들어가면 **탭을 내지 않는다**(고정으로 달지 않는다).
       ★탭 이름은 카드 제목에서 뽑고, 많으면 이웃끼리 묶어 **최대 4개**. */
  #qpsCmplPlan .zz-tabs{ display:flex; gap:6px; margin:0 0 10px; flex-wrap:wrap; align-items:center; }
  #qpsCmplPlan .zz-tab{ border:1px solid #cfd9e0; background:#f4f7f9; color:#43555f; border-radius:8px 8px 0 0;
                   padding:7px 15px; font-size:13.5px; font-weight:700; cursor:pointer; }
  #qpsCmplPlan .zz-tab:hover{ background:#e9eff3; }
  #qpsCmplPlan .zz-tab.on{ background:#1f5a4b; border-color:#1f5a4b; color:#fff; }
  #qpsCmplPlan .zz-tab.dim{ opacity:.5; }
  #qpsCmplPlan .zz-mode{ margin-left:auto; border:1px solid #1f5a4b; background:#fff; color:#1f5a4b;
                    border-radius:8px; padding:7px 14px; font-size:13px; font-weight:700; cursor:pointer; }
  #qpsCmplPlan .zz-mode.on{ background:#1f5a4b; color:#fff; }
  #qpsCmplPlan .zz-zoom{ display:inline-flex; gap:4px; align-items:center; margin-left:2px; }
  #qpsCmplPlan .zz-zoom button{ border:1px solid #cfd9e0; background:#fff; color:#43555f; border-radius:6px;
                           padding:4px 9px; font-size:13px; font-weight:700; cursor:pointer; }
  #qpsCmplPlan .zz-zoom button:hover{ background:#eef3f6; }
</style>

<div class="qp-head">
  <div class="qp-title"><span class="qp-dot"></span>불만고충 처리계획서 <span class="qp-sub">연 1부</span></div>
  <span class="qp-hosp" id="cpHosp">🏥 <c:out value="${hospNm}" default="병원 미확인"/></span>
  <div class="qp-spacer"></div>
  <label class="qp-sub">제출일</label> <input type="date" id="cpSubmitDt" style="width:auto;">
  <select id="cpYear" style="width:auto;" onchange="cpLoad();"></select>
  <button type="button" class="qp-btn" onclick="cpSave();">저장</button>
  <button type="button" class="qp-btn ghost" onclick="cpPrint();">🖨 인쇄(A4)</button>
  <span class="qp-sub" id="cpStat"></span>
  <%-- 글자 크기 — 이 PC 이 브라우저에만 저장된다 --%>
  <span class="zz-zoom">
    <button type="button" onclick="zzZoom(-1);" title="글자 작게">가－</button>
    <button type="button" onclick="zzZoom(1);"  title="글자 크게">가＋</button>
    <button type="button" onclick="zzZoom(0);"  title="처음 크기로">↺</button>
  </span>
</div>
<%-- ★탭 — 내용이 한 화면을 넘칠 때만 나온다(zzSync 가 재 본다) --%>
<div class="zz-tabs" id="zzTabs" style="display:none;"></div>

<div class="qp-card"><h4>주제 · 문제개요 <span class="hint">— 항목명도 병원에 맞게 고칠 수 있습니다</span></h4>
  <table class="ed"><thead><tr><th style="width:180px;">항목</th><th>내용</th><th style="width:26px;"></th></tr></thead>
  <tbody id="tbINTRO"></tbody></table>
  <button type="button" class="qp-btn mini" style="margin-top:6px;" onclick="cpAdd('INTRO');">＋ 행 추가</button>
</div>

<%-- ★팀구성 — 만족도 계획서엔 없던 표다. 불만고충은 팀을 꾸려서 다루는 활동이라는 뜻.
     원본은 「구분|성명」을 4벌 가로로 반복해 12칸이지만, 우리는 세로 목록으로 둔다
     (인원이 12명을 넘거나 모자랄 수 있고, 인쇄에서 4벌 가로표로 조립한다). --%>
<div class="qp-card"><h4>팀 구성 <span class="hint">— 인쇄물에서는 원본처럼 가로 4벌 표로 조립됩니다</span></h4>
  <table class="ed" style="max-width:560px;"><thead><tr>
    <th style="width:120px;">구분</th><th>성명</th><th style="width:26px;"></th>
  </tr></thead><tbody id="tbTEAM"></tbody></table>
  <button type="button" class="qp-btn mini" style="margin-top:6px;" onclick="cpAdd('TEAM');">＋ 행 추가</button>
</div>

<div class="qp-card"><h4>자료수집 — 분석 및 통계도구</h4>
  <label style="font-size:13px; margin-right:18px;"><input type="checkbox" id="cpToolBar"> 막대그래프</label>
  <label style="font-size:13px;"><input type="checkbox" id="cpToolPie"> 원그래프</label>
  <div class="qp-sub" style="margin-top:6px;">※ 조사대상 · 조사도구 및 방법은 위 「주제 · 문제개요」 표의 항목으로 적습니다.</div>
</div>

<div class="qp-card"><h4>활동일정 <span class="hint">— 실시하는 달에 체크 (원본은 12개월 전체)</span></h4>
  <div style="overflow-x:auto;">
  <table class="ed" style="min-width:820px;"><thead><tr>
    <th style="min-width:240px;">활동</th>
    <th style="width:30px;">1</th><th style="width:30px;">2</th><th style="width:30px;">3</th><th style="width:30px;">4</th>
    <th style="width:30px;">5</th><th style="width:30px;">6</th><th style="width:30px;">7</th><th style="width:30px;">8</th>
    <th style="width:30px;">9</th><th style="width:30px;">10</th><th style="width:30px;">11</th><th style="width:30px;">12</th>
    <th style="width:150px;">비고</th><th style="width:26px;"></th>
  </tr></thead><tbody id="tbSCHED"></tbody></table>
  </div>
  <button type="button" class="qp-btn mini" style="margin-top:6px;" onclick="cpAdd('SCHED');">＋ 행 추가</button>
</div>

<div class="qp-card"><h4>첨부파일</h4>
  <div id="cpFileBox"></div>
</div>

<script>
(function(){
  var HOSP_NM = '', APPR_LINE = [];
  var FORM_GB = 'C';                    // ★불만고충 처리계획서 — 계획서 표를 구분값으로 나눠 쓴다

  var fileBox = window.qpsFileBox({ mount:'cpFileBox', refGb:'PLAN',
      hint:'계획서에 붙는 근거자료', needSaveMsg:'년도를 선택하면 첨부할 수 있습니다.' });

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

  (function(){
    var y = new Date().getFullYear(), sel = gel('cpYear');
    for (var i = y + 1; i >= y - 4; i--) sel.add(new Option(i + '년', i));
    sel.value = y;
  })();

  function inp(name, v, ph){
    return '<input data-f="' + name + '" value="' + esc(v) + '"' + (ph ? ' placeholder="' + esc(ph) + '"' : '') + '>';
  }
  function ta(name, v){ return '<textarea data-f="' + name + '" rows="2">' + esc(v) + '</textarea>'; }
  function chk(name, v){ return '<input type="checkbox" data-f="' + name + '"' + (v === 'Y' ? ' checked' : '') + '>'; }
  function del(){ return '<td class="rowdel" onclick="cpDelRow(this);">✕</td>'; }

  var ROW = {
    INTRO: function(r){ return '<td>' + inp('c1', r.c1) + '</td><td>' + ta('c2', r.c2) + '</td>' + del(); },
    TEAM:  function(r){ return '<td>' + inp('grp', r.grp, '팀장·간사·팀원') + '</td><td>' + inp('c1', r.c1) + '</td>' + del(); },
    SCHED: function(r){
      var m = '';
      for (var i = 1; i <= 12; i++){ var k = 'm' + (i < 10 ? '0' + i : i); m += '<td>' + chk(k, r[k]) + '</td>'; }
      return '<td>' + inp('c1', r.c1) + '</td>' + m + '<td>' + inp('c2', r.c2) + '</td>' + del();
    }
  };

  // 새 문서 기본 틀 — 원본 서식의 고정 행
  var DEFAULTS = {
    INTRO: ['주제명','주제선정 배경','문제개요 (현황분석)','문제개요 (사전조사)',
            '조사대상','조사도구 및 방법','핵심지표 / 목표'].map(function(t){ return { c1:t, c2:'' }; }),
    TEAM:  [{grp:'팀장'},{grp:'간사'},{grp:'팀원'},{grp:'팀원'},{grp:'팀원'},{grp:'팀원'}],
    SCHED: ['활동계획서','지표정의서','불만고충접수','현황분석','개선활동','지표분석보고']
           .map(function(t){ return { c1:t }; })
  };
  var SECTS = ['INTRO','TEAM','SCHED'];

  function addRow(sect, r){
    var tr = document.createElement('tr');
    tr.setAttribute('data-sect', sect);
    tr.innerHTML = ROW[sect](r || {});
    gel('tb' + sect).appendChild(tr);
  }
  window.cpAdd = function(sect){ addRow(sect, {}); };
  window.cpDelRow = function(el){ el.closest('tr').remove(); };

  function readRow(tr){
    var r = {};
    tr.querySelectorAll('[data-f]').forEach(function(el){
      r[el.getAttribute('data-f')] = (el.type === 'checkbox') ? (el.checked ? 'Y' : '') : String(el.value).trim();
    });
    return r;
  }
  function collect(){
    var items = [];
    SECTS.forEach(function(sect){
      var sort = 0;
      document.querySelectorAll('#tb' + sect + ' tr').forEach(function(tr){
        var r = readRow(tr);
        var hasVal = Object.keys(r).some(function(k){ return r[k] !== '' && r[k] != null; });
        if (!hasVal) return;
        r.sect = sect; r.sort = ++sort;
        items.push(r);
      });
    });
    // 분석·통계도구 — 표가 아니라 체크 두 개라 한 줄로 담는다(c3=막대, c4=원)
    if (gel('cpToolBar').checked || gel('cpToolPie').checked) {
      items.push({ sect:'TOOL', sort:1, c1:'분석 및 통계도구',
                   c3: gel('cpToolBar').checked ? 'Y' : '', c4: gel('cpToolPie').checked ? 'Y' : '' });
    }
    return items;
  }

  window.cpLoad = function(){
    if (fileBox) fileBox.setKey(gel('cpYear').value + '|' + FORM_GB);
    return post('<c:url value="/qps/planGet.do"/>', { formGb: FORM_GB, inYear: gel('cpYear').value }).then(function(res){
      if (res.hosp) { HOSP_NM = res.hosp.hospnm || ''; gel('cpHosp').textContent = '🏥 ' + HOSP_NM; }
      APPR_LINE = res.line || [];
      var plan = res.plan, items = res.items || [];
      gel('cpSubmitDt').value = (plan && plan.submitdt) ? plan.submitdt : '';
      gel('cpStat').textContent = plan ? ('최종수정 ' + (plan.upddttm || '')) : '작성 전 — 기본 틀을 채워 두었습니다';
      SECTS.forEach(function(sect){
        var tb = gel('tb' + sect);
        tb.innerHTML = '';
        var rows = items.filter(function(r){ return r.sect === sect; });
        if (!rows.length && !plan) rows = DEFAULTS[sect];
        (rows.length ? rows : [{}]).forEach(function(r){ addRow(sect, r); });
      });
      var tool = items.filter(function(r){ return r.sect === 'TOOL'; })[0] || {};
      gel('cpToolBar').checked = (tool.c3 === 'Y');
      gel('cpToolPie').checked = (tool.c4 === 'Y');
    }).catch(err);
  };

  window.cpSave = function(){
    post('<c:url value="/qps/planSave.do"/>', {
      formGb: FORM_GB, inYear: gel('cpYear').value,
      submitDt: gel('cpSubmitDt').value,
      items: JSON.stringify(collect())
    }).then(function(){
      _toast('저장되었습니다.', 'ok');
      return cpLoad();
    }).catch(err);
  };

  // ---------- 인쇄(A4) ----------
  var PRINT_CSS =
    '@page{ size:A4 portrait; margin:12mm 12mm 14mm; }' +
    'body{ margin:0; font-family:"맑은 고딕",Malgun Gothic,sans-serif; color:#000; }' +
    '.h1{ font-size:18px; font-weight:800; text-align:center; margin:0 0 10px; letter-spacing:1px; }' +
    '.sec{ font-size:13px; font-weight:800; margin:11px 0 5px; padding-bottom:3px; border-bottom:1.5px solid #333; }' +
    'table{ width:100%; border-collapse:collapse; font-size:10.5px; margin-bottom:6px; }' +
    'th,td{ border:1px solid #666; padding:4px 5px; text-align:center; vertical-align:middle; line-height:1.6; }' +
    'th{ background:#efefef; font-weight:700; }' +
    'td.l{ text-align:left; } td.pre{ text-align:left; white-space:pre-wrap; }' +
    '.appr{ float:right; width:auto; margin:0 0 6px 8px; font-size:10px; }' +
    '.appr th{ padding:2px 6px; } .appr td{ height:44px; width:60px; }' +
    '.sub{ text-align:center; font-size:12px; font-weight:700; margin-top:12mm; }' +
    'tr{ page-break-inside:avoid; }';

  function apprHtml(){
    if (!APPR_LINE.length) return '';
    var h = '<table class="appr"><thead><tr>';
    APPR_LINE.forEach(function(r){ h += '<th>' + esc(r.stepnm) + '</th>'; });
    h += '</tr></thead><tbody><tr>';
    APPR_LINE.forEach(function(){ h += '<td></td>'; });
    return h + '</tr></tbody></table>';
  }

  window.cpPrint = function(){
    var yy = gel('cpYear').value, items = collect();
    function by(s){ return items.filter(function(r){ return r.sect === s; }); }

    var intro = '<div class="sec">주제 · 문제개요</div><table><tbody>' +
      by('INTRO').map(function(r){
        return '<tr><th style="width:140px;">' + esc(r.c1) + '</th><td class="pre">' + esc(r.c2) + '</td></tr>';
      }).join('') + '</tbody></table>';

    // 팀구성 — 원본처럼 가로 4벌(구분|성명 × 4)로 조립한다
    var team = by('TEAM'), trs = '';
    for (var i = 0; i < team.length; i += 4) {
      var tds = '';
      for (var k = 0; k < 4; k++) {
        var m = team[i + k];
        tds += '<th style="width:9%;">' + (m ? esc(m.grp) : '') + '</th>' +
               '<td style="width:16%;">' + (m ? esc(m.c1) : '') + '</td>';
      }
      trs += '<tr>' + tds + '</tr>';
    }
    var teamTbl = trs ? ('<div class="sec">팀 구성</div><table><tbody>' + trs + '</tbody></table>') : '';

    var tool = by('TOOL')[0] || {};
    var toolTxt = (tool.c3 === 'Y' ? '☑' : '☐') + ' 막대그래프 &nbsp;&nbsp;' +
                  (tool.c4 === 'Y' ? '☑' : '☐') + ' 원그래프';
    var toolTbl = '<table><tbody><tr><th style="width:140px;">분석 및 통계도구</th>' +
                  '<td class="l">' + toolTxt + '</td></tr></tbody></table>';

    var mth = '';
    for (var j = 1; j <= 12; j++) mth += '<th style="width:22px;">' + j + '</th>';
    var sched = '<div class="sec">활동일정</div><table><thead><tr>' +
      '<th>활동</th>' + mth + '<th style="width:90px;">비고</th></tr></thead><tbody>' +
      by('SCHED').map(function(r){
        var m = '';
        for (var k = 1; k <= 12; k++){ var f = 'm' + (k < 10 ? '0' + k : k); m += '<td>' + (r[f] === 'Y' ? '●' : '') + '</td>'; }
        return '<tr><td class="l">' + esc(r.c1) + '</td>' + m + '<td class="l">' + esc(r.c2) + '</td></tr>';
      }).join('') + '</tbody></table>';

    var body = apprHtml() +
      '<div class="h1">' + esc(yy) + '년 불만고충 처리계획서</div>' +
      '<div style="clear:both;"></div>' + intro + teamTbl + toolTbl + sched +
      '<div class="sub">' + esc(HOSP_NM) + '<br>제출일 &nbsp;' + esc(gel('cpSubmitDt').value || '') + '</div>';

    var title = ('불만고충처리계획서_' + yy + '_' + HOSP_NM).replace(/[\\\/:*?"<>|]/g, '-');
    var w = window.open('', '_blank', 'width=900,height=1000');
    if (!w) { _alertBox('팝업이 차단되어 인쇄창을 열지 못했습니다.<br>주소창 오른쪽의 팝업 차단을 허용해 주세요.', {icon:'⚠️'}); return; }
    w.document.open();
    w.document.write('<!doctype html><html lang="ko"><head><meta charset="utf-8"><title>' + esc(title) +
      '</title><style>' + PRINT_CSS + '</style></head><body>' + body + '</body></html>');
    w.document.close();
    w.focus();
    setTimeout(function(){ try { w.print(); } catch (e) { } }, 300);
  };

  $(function(){ cpLoad(); });
})();

  /* ═══ 탭 · 글자 크기 (2026-08-15 · 사용자 요청) ═══════════════════════════
     ★***고정으로 달지 않는다*** — 전부 펼친 높이를 재서 **한 화면을 넘칠 때만** 탭을 낸다.
       창 크기·글자 크기가 바뀌면 다시 잰다.
     ★탭이 **잘게 나뉘지 않게** 이웃 카드를 묶어 최대 4개. 이름은 첫 카드 제목(+「외」).
     ★「전체 보기」는 탭이 아니라 **보기 방식**이라 오른쪽 끝에 따로 둔다.
     ⚠인쇄는 별도 창이라 탭과 무관하다(숨긴 항목도 종이에는 다 나온다). */
  (function(){
    var KEY = 'qpsTab_qpsCmplPlan', ZKEY = 'qpsZoom_qpsCmplPlan', cur = 0;
    function cards(){ return [].slice.call(document.querySelectorAll('#qpsCmplPlan .qp-card')); }
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
      var w = document.getElementById('qpsCmplPlan');
      if (w) w.style.zoom = z.toFixed(2);
      return z;
    }
    window.zzZoom = function(d){
      var w = document.getElementById('qpsCmplPlan'), c0 = parseFloat(w && w.style.zoom) || 1;
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
    var _t; window.addEventListener('resize', function(){ clearTimeout(_t); _t = setTimeout(sync, 200); });
    window.zzResync = sync;
  })();
</script>
</div><%-- /#qpsCmplPlan --%>
</div><%-- /.dashboard-wrapper --%>
