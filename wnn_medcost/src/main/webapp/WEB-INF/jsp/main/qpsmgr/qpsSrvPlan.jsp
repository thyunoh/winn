<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%-- qpsSrvPlan.jsp — 만족도 조사 계획서 (만족도 사이클 #2, 2026-08-11)

     ★새 테이블·새 엔드포인트를 만들지 않았다.
       연간 활동계획서(서식 2호)가 쓰는 TBL_QPS_PLAN / TBL_QPS_PLAN_ITEM 을 그대로 쓰고
       서식구분 FORM_GB 에 'S'(만족도 조사 계획서)를 하나 더 얹었다.
       - 유니크 키가 이미 (병원, 구분, 년도)라 질향상 'Q'·감염 'I' 와 안 부딪힌다.
       - 항목표는 SECT_CD 로 갈리는 범용 테이블이라 섹션만 다르게 쓰면 된다.
       - 첨부 키도 같은 규칙 : REF_GB='PLAN', REF_KEY='년도|S'.
       → 서버(planGet/planSave)는 formGb 를 그대로 받아 넘기므로 자바·XML 변경이 없다.

     섹션 2개
       INTRO : 항목 | 내용        (주제·배경·조사팀·기간·대상·인원·항목·추진계획)
       SCHED : 활동 | 월 1~12 체크 (원본은 8열이지만 12열로 둔다 — 열을 고정하면 불만고충 12개월판에서 막힌다)

     ★원본에 없는 것 하나 : [조사 개요 가져오기].
       조사기간·대상·방법·요원은 만족도 조사(TBL_QPS_SURVEY)에 이미 있는 값이다.
       두 번 적게 만들지 않으려고 그 해 조사에서 끌어온다(비어 있는 칸만 채운다).

     ★주의: 이 파일 안에서 Deferred EL 표기(샵+중괄호) 금지 --%>

<script src="/asset/js/ui-message.js"></script>
<%@ include file="/WEB-INF/jsp/main/inc/qpsFileBox.jsp" %>

<div class="dashboard-wrapper">
<div id="qpsSrvPlan" data-wnn="<c:out value='${wnnYn}'/>">
<style>
  #qpsSrvPlan{ background:#f4f6f8; color:#1f2a30; min-height:100%; padding:14px 16px 60px; max-width:100%; overflow-x:hidden; }
  #qpsSrvPlan *{ box-sizing:border-box; }
  #qpsSrvPlan .qp-head{ display:flex; align-items:center; gap:10px; margin-bottom:12px; flex-wrap:wrap; }
  #qpsSrvPlan .qp-title{ font-size:18px; font-weight:800; color:#20303a; display:flex; align-items:center; gap:8px; }
  #qpsSrvPlan .qp-dot{ width:10px; height:10px; border-radius:50%; background:linear-gradient(135deg,#1f5a4b,#2a7665); }
  #qpsSrvPlan .qp-sub{ font-size:12px; color:#6b7c86; }
  #qpsSrvPlan .qp-hosp{ background:#e7f3ee; color:#1f5a4b; font-size:12px; font-weight:800;
      border:1px solid #cfe3da; border-radius:14px; padding:3px 11px; }
  #qpsSrvPlan .qp-spacer{ flex:1; }
  #qpsSrvPlan select, #qpsSrvPlan input, #qpsSrvPlan textarea{
      border:1px solid #cfd8e0; border-radius:5px; padding:5px 7px; font-family:inherit; font-size:12.5px; background:#fff; }
  #qpsSrvPlan textarea{ resize:vertical; line-height:1.55; }
  #qpsSrvPlan .qp-btn{ border:1px solid #1f5a4b; background:#1f5a4b; color:#fff; border-radius:6px;
      padding:6px 14px; font-size:13px; font-weight:600; cursor:pointer; white-space:nowrap; }
  #qpsSrvPlan .qp-btn.ghost{ background:#fff; color:#1f5a4b; }
  #qpsSrvPlan .qp-btn.mini{ padding:2px 9px; font-size:11.5px; border-color:#cfd8e0; color:#556570; background:#fff; }
  #qpsSrvPlan .qp-btn:hover{ opacity:.9; }

  #qpsSrvPlan .qp-card{ background:#fff; border:1px solid #e3e9ed; border-radius:10px; padding:14px 16px; margin-bottom:14px; }
  #qpsSrvPlan .qp-card h4{ margin:0 0 10px; font-size:14px; font-weight:800; color:#1f5a4b; }
  #qpsSrvPlan .qp-card h4 .hint{ font-weight:500; font-size:12px; color:#8a99a3; }
  #qpsSrvPlan table.ed{ width:100%; border-collapse:collapse; font-size:12.5px; }
  #qpsSrvPlan table.ed th{ background:#f2f6f8; border:1px solid #dde5ea; padding:5px 6px; font-weight:700; color:#43555f; white-space:nowrap; }
  #qpsSrvPlan table.ed td{ border:1px solid #e6ecef; padding:3px; vertical-align:top; }
  #qpsSrvPlan table.ed input, #qpsSrvPlan table.ed textarea{ width:100%; border:none; background:transparent; padding:4px 5px; }
  #qpsSrvPlan table.ed input:focus, #qpsSrvPlan table.ed textarea:focus{ background:#f7fbf9; outline:1px solid #8fc3b2; }
  /* 공통 CSS 가 라디오·체크박스를 감추는 화면이 있다(qpsSurvey 에서 겪음) → 기본 모양을 되살린다 */
  #qpsSrvPlan table.ed input[type=checkbox]{
      -webkit-appearance:checkbox !important; appearance:auto !important;
      width:15px !important; height:15px !important; margin:4px auto !important; display:block !important;
      opacity:1 !important; visibility:visible !important; position:static !important; cursor:pointer; }
  #qpsSrvPlan .rowdel{ color:#b23b3b; cursor:pointer; font-weight:700; text-align:center; width:26px; }
  /* ── 탭 · 글자 크기 (2026-08-15) — 카드가 세로로 쌓여 스크롤이 길다는 지적.
       ★한 화면에 들어가면 **탭을 내지 않는다**(고정으로 달지 않는다).
       ★탭 이름은 카드 제목에서 뽑고, 많으면 이웃끼리 묶어 **최대 4개**. */
  #qpsSrvPlan .zz-tabs{ display:flex; gap:6px; margin:0 0 10px; flex-wrap:wrap; align-items:center; }
  #qpsSrvPlan .zz-tab{ border:1px solid #cfd9e0; background:#f4f7f9; color:#43555f; border-radius:8px 8px 0 0;
                   padding:7px 15px; font-size:13.5px; font-weight:700; cursor:pointer; }
  #qpsSrvPlan .zz-tab:hover{ background:#e9eff3; }
  #qpsSrvPlan .zz-tab.on{ background:#1f5a4b; border-color:#1f5a4b; color:#fff; }
  #qpsSrvPlan .zz-tab.dim{ opacity:.5; }
  #qpsSrvPlan .zz-mode{ margin-left:auto; border:1px solid #1f5a4b; background:#fff; color:#1f5a4b;
                    border-radius:8px; padding:7px 14px; font-size:13px; font-weight:700; cursor:pointer; }
  #qpsSrvPlan .zz-mode.on{ background:#1f5a4b; color:#fff; }
  #qpsSrvPlan .zz-zoom{ display:inline-flex; gap:4px; align-items:center; margin-left:2px; }
  #qpsSrvPlan .zz-zoom button{ border:1px solid #cfd9e0; background:#fff; color:#43555f; border-radius:6px;
                           padding:4px 9px; font-size:13px; font-weight:700; cursor:pointer; }
  #qpsSrvPlan .zz-zoom button:hover{ background:#eef3f6; }
</style>

<div class="qp-head">
  <div class="qp-title"><span class="qp-dot"></span>만족도 조사 계획서 <span class="qp-sub">만족도 사이클 · 연 1부</span></div>
  <span class="qp-hosp" id="spHosp">🏥 <c:out value="${hospNm}" default="병원 미확인"/></span>
  <div class="qp-spacer"></div>
  <label class="qp-sub">제출일</label> <input type="date" id="spSubmitDt" style="width:auto;">
  <select id="spYear" style="width:auto;" onchange="spLoad();"></select>
  <button type="button" class="qp-btn" onclick="spSave();">저장</button>
  <button type="button" class="qp-btn ghost" onclick="spPrint();">🖨 인쇄(A4)</button>
  <span class="qp-sub" id="spStat"></span>
  <%-- 글자 크기 — 이 PC 이 브라우저에만 저장된다 --%>
  <span class="zz-zoom">
    <button type="button" onclick="zzZoom(-1);" title="글자 작게">가－</button>
    <button type="button" onclick="zzZoom(1);"  title="글자 크게">가＋</button>
    <button type="button" onclick="zzZoom(0);"  title="처음 크기로">↺</button>
  </span>
</div>
<%-- ★탭 — 내용이 한 화면을 넘칠 때만 나온다(zzSync 가 재 본다) --%>
<div class="zz-tabs" id="zzTabs" style="display:none;"></div>

<div class="qp-card"><h4>조사 계획 <span class="hint">— 항목명도 병원에 맞게 고칠 수 있습니다</span></h4>
  <table class="ed"><thead><tr><th style="width:170px;">항목</th><th>내용</th><th style="width:26px;"></th></tr></thead>
  <tbody id="tbINTRO"></tbody></table>
  <div style="margin-top:6px; display:flex; gap:6px; flex-wrap:wrap;">
    <button type="button" class="qp-btn mini" onclick="spAdd('INTRO');">＋ 행 추가</button>
    <button type="button" class="qp-btn mini" onclick="spPullSurvey();">↧ 조사 개요 가져오기</button>
    <span class="qp-sub">— 그 해 만족도 조사에 적어 둔 기간·대상·방법·요원을 <b>빈 칸에만</b> 채웁니다.</span>
  </div>
</div>

<div class="qp-card"><h4>추진계획 및 활동일정 <span class="hint">— 실시하는 달에 체크</span></h4>
  <div style="overflow-x:auto;">
  <table class="ed" style="min-width:820px;"><thead><tr>
    <th style="min-width:260px;">활동 일정</th>
    <th style="width:30px;">1</th><th style="width:30px;">2</th><th style="width:30px;">3</th><th style="width:30px;">4</th>
    <th style="width:30px;">5</th><th style="width:30px;">6</th><th style="width:30px;">7</th><th style="width:30px;">8</th>
    <th style="width:30px;">9</th><th style="width:30px;">10</th><th style="width:30px;">11</th><th style="width:30px;">12</th>
    <th style="width:150px;">비고</th><th style="width:26px;"></th>
  </tr></thead><tbody id="tbSCHED"></tbody></table>
  </div>
  <button type="button" class="qp-btn mini" style="margin-top:6px;" onclick="spAdd('SCHED');">＋ 행 추가</button>
</div>

<%-- 만족도 조사안내(사이클 #1) — 원본은 별도 문서지만 내용이 <자유입력 박스 1개>뿐이다.
     메뉴를 하나 더 만들 만한 서식이 아니라 계획서 화면에 카드로 붙였다(같은 활동의 게시물이다).
     저장은 계획서 항목표의 SECT_CD='NOTICE' 한 줄 — 새 테이블이 필요 없다. --%>
<div class="qp-card"><h4>조사 안내문 <span class="hint">— 병동·게시판에 붙이는 안내문. 내용만 적으면 됩니다</span></h4>
  <textarea id="spNotice" rows="7" style="width:100%;"
            placeholder="예) 저희 병원은 더 나은 의료서비스를 위하여 입원환자 만족도 조사를 시행합니다. …"></textarea>
  <button type="button" class="qp-btn ghost" style="margin-top:8px;" onclick="spPrintNotice();">🖨 안내문 인쇄</button>
</div>

<div class="qp-card"><h4>첨부파일 <span class="hint">— 계획서에 붙는 근거자료·설문지 초안 등</span></h4>
  <div id="spFileBox"></div>
</div>

<script>
(function(){
  var HOSP_NM = '', APPR_LINE = [];
  var FORM_GB = 'S';                       // ★만족도 조사 계획서 — Q(질향상)·I(감염관리)와 같은 표에 구분만 다르게

  var fileBox = window.qpsFileBox({ mount:'spFileBox', refGb:'PLAN',
      hint:'계획서에 붙는 사진·파일', needSaveMsg:'년도를 선택하면 첨부할 수 있습니다.' });

  function gel(id){ return document.getElementById(id); }   // ★$ 로 짓지 말 것 — jQuery 가 가려져 통신이 조용히 죽는다
  function post(url, data){
    return $.ajax({ url:url, type:'POST', data:data, dataType:'json' }).then(function(res){
      if (res && res.result === 'FAIL') { throw new Error(res.message || '처리에 실패했습니다.'); }
      return res;
    });
  }
  function err(e){ _alertBox((e && e.message) ? e.message : '처리 중 오류가 발생했습니다.', {icon:'❌'}); }
  function esc(s){ return (s==null?'':String(s)).replace(/[&<>"]/g, function(c){
      return ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;'})[c]; }); }
  function ymd(s){ s = (s==null?'':String(s)).replace(/[^0-9]/g,'');
      return (s.length===8) ? (s.substr(0,4)+'-'+s.substr(4,2)+'-'+s.substr(6,2)) : ''; }

  (function(){
    var y = new Date().getFullYear(), sel = gel('spYear');
    for (var i = y + 1; i >= y - 4; i--) sel.add(new Option(i + '년', i));
    sel.value = y;
  })();

  // ── 행 템플릿 ───────────────────────────────────────────────────────
  function inp(name, v, ph){
    return '<input data-f="' + name + '" value="' + esc(v) + '"' + (ph ? ' placeholder="' + esc(ph) + '"' : '') + '>';
  }
  function ta(name, v){ return '<textarea data-f="' + name + '" rows="2">' + esc(v) + '</textarea>'; }
  function chk(name, v){ return '<input type="checkbox" data-f="' + name + '"' + (v === 'Y' ? ' checked' : '') + '>'; }
  function del(){ return '<td class="rowdel" onclick="spDelRow(this);">✕</td>'; }

  var ROW = {
    INTRO: function(r){ return '<td>' + inp('c1', r.c1) + '</td><td>' + ta('c2', r.c2) + '</td>' + del(); },
    SCHED: function(r){
      var m = '';
      for (var i = 1; i <= 12; i++){ var k = 'm' + (i < 10 ? '0' + i : i); m += '<td>' + chk(k, r[k]) + '</td>'; }
      return '<td>' + inp('c1', r.c1) + '</td>' + m + '<td>' + inp('c2', r.c2) + '</td>' + del();
    }
  };

  // 새 문서 기본 틀 — 원본 서식의 고정 행(병원이 지우거나 고치면 그대로 저장된다)
  var DEFAULTS = {
    INTRO: ['주제','주제 선정 배경','조사팀 구성','조사계획(구분)','조사기간','조사대상',
            '조사 인원 계획','조사 항목','추진 계획'].map(function(t){ return { c1:t, c2:'' }; }),
    SCHED: ['조사 계획','설문지 작성','설문조사','설문지 통계분석','설문지 결과보고서 작성',
            '개선활동 계획','개선활동 시행','개선활동 결과 분석','최종 보고']
           .map(function(t){ return { c1:t }; })
  };
  var SECTS = ['INTRO','SCHED'];

  function addRow(sect, r){
    var tr = document.createElement('tr');
    tr.setAttribute('data-sect', sect);
    tr.innerHTML = ROW[sect](r || {});
    gel('tb' + sect).appendChild(tr);
  }
  window.spAdd = function(sect){ addRow(sect, {}); };
  window.spDelRow = function(el){ el.closest('tr').remove(); };

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
        if (!hasVal) return;                     // 전부 빈 행은 저장 안 함
        r.sect = sect; r.sort = ++sort;
        items.push(r);
      });
    });
    // 조사안내 — 표가 아니라 자유입력 1칸이라 항목표의 한 줄로 담는다
    var notice = String(gel('spNotice').value || '').trim();
    if (notice) items.push({ sect:'NOTICE', sort:1, c1:'조사안내', c2:notice });
    return items;
  }

  window.spLoad = function(){
    /* 첨부 키 = 년도|S. 구분을 빼면 질향상 계획서 첨부와 섞인다. */
    if (fileBox) fileBox.setKey(gel('spYear').value + '|' + FORM_GB);
    return post('<c:url value="/qps/planGet.do"/>', { formGb: FORM_GB, inYear: gel('spYear').value }).then(function(res){
      if (res.hosp) { HOSP_NM = res.hosp.hospnm || ''; gel('spHosp').textContent = '🏥 ' + HOSP_NM; }
      APPR_LINE = res.line || [];
      var plan = res.plan, items = res.items || [];
      gel('spSubmitDt').value = (plan && plan.submitdt) ? plan.submitdt : '';
      gel('spStat').textContent = plan ? ('최종수정 ' + (plan.upddttm || '')) : '작성 전 — 기본 틀을 채워 두었습니다';
      SECTS.forEach(function(sect){
        var tb = gel('tb' + sect);
        tb.innerHTML = '';
        var rows = items.filter(function(r){ return r.sect === sect; });
        if (!rows.length && !plan) rows = DEFAULTS[sect];
        (rows.length ? rows : [{}]).forEach(function(r){ addRow(sect, r); });
      });
      var nt = items.filter(function(r){ return r.sect === 'NOTICE'; })[0];
      gel('spNotice').value = nt ? (nt.c2 || '') : '';
    }).catch(err);
  };

  window.spSave = function(){
    post('<c:url value="/qps/planSave.do"/>', {
      formGb: FORM_GB,
      inYear: gel('spYear').value,
      submitDt: gel('spSubmitDt').value,
      items: JSON.stringify(collect())
    }).then(function(){
      _toast('저장되었습니다.', 'ok');
      return spLoad();
    }).catch(err);
  };

  /* 조사 개요 가져오기 — 만족도 조사(TBL_QPS_SURVEY)에 이미 적어 둔 값을 끌어온다.
     ★덮어쓰지 않는다. 비어 있는 칸만 채운다 — 계획서에서 손으로 고친 문구를 되돌리면 안 된다. */
  window.spPullSurvey = function(){
    var yy = gel('spYear').value;
    post('<c:url value="/qps/surveyBase.do"/>', { inYear: yy }).then(function(res){
      var list = (res && res.list) || [];
      if (!list.length) { _alertBox(yy + '년 만족도 조사가 아직 없습니다.<br>[환자만족도 조사] 화면에서 조사를 먼저 만들어 주세요.', {icon:'⚠️'}); return; }
      return post('<c:url value="/qps/surveyGet.do"/>', { surveyId: list[0].surveyid }).then(function(g){
        var d = (g && g.doc) || {};
        var period = (ymd(d.frdt) && ymd(d.todt)) ? (ymd(d.frdt) + ' ~ ' + ymd(d.todt)) : '';
        var src = { '주제': d.surveynm, '조사기간': period, '조사대상': d.target,
                    '조사계획(구분)': d.method, '조사 인원 계획': d.target, '주제 선정 배경': d.purpose,
                    '추진 계획': d.goal, '조사팀 구성': d.staff };
        var n = 0;
        document.querySelectorAll('#tbINTRO tr').forEach(function(tr){
          var nm = tr.querySelector('[data-f=c1]'), va = tr.querySelector('[data-f=c2]');
          if (!nm || !va) return;
          var v = src[String(nm.value).trim()];
          if (v && !String(va.value).trim()) { va.value = v; n++; }
        });
        _toast(n ? (n + '개 칸을 채웠습니다. 확인 후 저장해 주세요.') : '채울 빈 칸이 없습니다.', n ? 'ok' : 'info');
      });
    }).catch(err);
  };

  // ---------- 인쇄(A4) — 별도 창(QPS 공통 방식) ----------
  var PRINT_CSS =
    '@page{ size:A4 portrait; margin:12mm 12mm 14mm; }' +
    'body{ margin:0; font-family:"맑은 고딕",Malgun Gothic,sans-serif; color:#000; }' +
    '.h1{ font-size:18px; font-weight:800; text-align:center; margin:0 0 10px; letter-spacing:1px; }' +
    '.sec{ font-size:13px; font-weight:800; margin:12px 0 5px; padding-bottom:3px; border-bottom:1.5px solid #333; }' +
    'table{ width:100%; border-collapse:collapse; font-size:10.5px; margin-bottom:6px; }' +
    'th,td{ border:1px solid #666; padding:4px 5px; text-align:center; vertical-align:middle; line-height:1.6; }' +
    'th{ background:#efefef; font-weight:700; }' +
    'td.l{ text-align:left; } td.pre{ text-align:left; white-space:pre-wrap; }' +
    '.appr{ float:right; width:auto; margin:0 0 6px 8px; font-size:10px; }' +
    '.appr th{ padding:2px 6px; } .appr td{ height:44px; width:60px; }' +
    '.sub{ text-align:center; font-size:12px; font-weight:700; margin-top:14mm; }' +
    'tr{ page-break-inside:avoid; }';

  function apprHtml(){
    if (!APPR_LINE.length) return '';
    var h = '<table class="appr"><thead><tr>';
    APPR_LINE.forEach(function(r){ h += '<th>' + esc(r.stepnm) + '</th>'; });
    h += '</tr></thead><tbody><tr>';
    APPR_LINE.forEach(function(){ h += '<td></td>'; });
    return h + '</tr></tbody></table>';
  }

  window.spPrint = function(){
    var yy = gel('spYear').value, items = collect();
    function by(s){ return items.filter(function(r){ return r.sect === s; }); }

    var intro = '<div class="sec">조사 계획</div><table><tbody>' +
      by('INTRO').map(function(r){
        return '<tr><th style="width:130px;">' + esc(r.c1) + '</th><td class="pre">' + esc(r.c2) + '</td></tr>';
      }).join('') + '</tbody></table>';

    var mth = '';
    for (var i = 1; i <= 12; i++) mth += '<th style="width:22px;">' + i + '</th>';
    var sched = '<div class="sec">추진계획 및 활동일정</div><table><thead><tr>' +
      '<th>활동 일정</th>' + mth + '<th style="width:90px;">비고</th></tr></thead><tbody>' +
      by('SCHED').map(function(r){
        var m = '';
        for (var k = 1; k <= 12; k++){ var f = 'm' + (k < 10 ? '0' + k : k); m += '<td>' + (r[f] === 'Y' ? '●' : '') + '</td>'; }
        return '<tr><td class="l">' + esc(r.c1) + '</td>' + m + '<td class="l">' + esc(r.c2) + '</td></tr>';
      }).join('') + '</tbody></table>';

    var body = apprHtml() +
      '<div class="h1">' + esc(yy) + '년 의료서비스 만족도 조사 계획서</div>' +
      '<div style="clear:both;"></div>' + intro + sched +
      '<div class="sub">' + esc(HOSP_NM) + '<br>제출일 &nbsp;' + esc(gel('spSubmitDt').value || '') + '</div>';

    var title = ('만족도조사계획서_' + yy + '_' + HOSP_NM).replace(/[\\\/:*?"<>|]/g, '-');
    var w = window.open('', '_blank', 'width=900,height=1000');
    if (!w) { _alertBox('팝업이 차단되어 인쇄창을 열지 못했습니다.<br>주소창 오른쪽의 팝업 차단을 허용해 주세요.', {icon:'⚠️'}); return; }
    w.document.open();
    w.document.write('<!doctype html><html lang="ko"><head><meta charset="utf-8"><title>' + esc(title) +
      '</title><style>' + PRINT_CSS + '</style></head><body>' + body + '</body></html>');
    w.document.close();
    w.focus();
    setTimeout(function(){ try { w.print(); } catch (e) { } }, 300);
  };

  /* 조사안내 인쇄 — 원본은 장식 테두리 + 제목 + 자유입력 박스 1개짜리 게시용 안내문이다.
     결재란도 표도 없다. 한 장으로 끝난다. */
  var NOTICE_CSS =
    '@page{ size:A4 portrait; margin:14mm; }' +
    'body{ margin:0; font-family:"맑은 고딕",Malgun Gothic,sans-serif; color:#000; }' +
    '.box{ border:6px double #1f5a4b; padding:18mm 14mm; min-height:230mm; }' +
    '.t{ font-size:30px; font-weight:800; text-align:center; letter-spacing:6px; margin-bottom:16mm; }' +
    '.b{ font-size:15px; line-height:2.1; white-space:pre-wrap; }' +
    '.f{ text-align:center; font-size:15px; font-weight:700; margin-top:20mm; }';

  window.spPrintNotice = function(){
    var yy = gel('spYear').value, txt = String(gel('spNotice').value || '').trim();
    if (!txt) { _alertBox('안내문 내용을 먼저 적어 주세요.', {icon:'⚠️'}); return; }
    var body = '<div class="box"><div class="t">안 내 문</div>' +
      '<div class="b">' + esc(txt) + '</div>' +
      '<div class="f">' + esc(HOSP_NM) + '</div></div>';
    var title = ('만족도조사안내_' + yy + '_' + HOSP_NM).replace(/[\\\/:*?"<>|]/g, '-');
    var w = window.open('', '_blank', 'width=900,height=1000');
    if (!w) { _alertBox('팝업이 차단되어 인쇄창을 열지 못했습니다.<br>주소창 오른쪽의 팝업 차단을 허용해 주세요.', {icon:'⚠️'}); return; }
    w.document.open();
    w.document.write('<!doctype html><html lang="ko"><head><meta charset="utf-8"><title>' + esc(title) +
      '</title><style>' + NOTICE_CSS + '</style></head><body>' + body + '</body></html>');
    w.document.close();
    w.focus();
    setTimeout(function(){ try { w.print(); } catch (e) { } }, 300);
  };

  $(function(){ spLoad(); });
})();

  /* ═══ 탭 · 글자 크기 (2026-08-15 · 사용자 요청) ═══════════════════════════
     ★***고정으로 달지 않는다*** — 전부 펼친 높이를 재서 **한 화면을 넘칠 때만** 탭을 낸다.
       창 크기·글자 크기가 바뀌면 다시 잰다.
     ★탭이 **잘게 나뉘지 않게** 이웃 카드를 묶어 최대 4개. 이름은 첫 카드 제목(+「외」).
     ★「전체 보기」는 탭이 아니라 **보기 방식**이라 오른쪽 끝에 따로 둔다.
     ⚠인쇄는 별도 창이라 탭과 무관하다(숨긴 항목도 종이에는 다 나온다). */
  (function(){
    var KEY = 'qpsTab_qpsSrvPlan', ZKEY = 'qpsZoom_qpsSrvPlan', cur = 0;
    function cards(){ return [].slice.call(document.querySelectorAll('#qpsSrvPlan .qp-card')); }
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
      var w = document.getElementById('qpsSrvPlan');
      if (w) w.style.zoom = z.toFixed(2);
      return z;
    }
    window.zzZoom = function(d){
      var w = document.getElementById('qpsSrvPlan'), c0 = parseFloat(w && w.style.zoom) || 1;
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
      var _mw = document.getElementById('qpsSrvPlan'), _mt;
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
</div><%-- /#qpsSrvPlan --%>
</div><%-- /.dashboard-wrapper --%>
