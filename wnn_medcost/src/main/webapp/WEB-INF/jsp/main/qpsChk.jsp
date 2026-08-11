<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%-- qpsChk.jsp — 점검표 작성 (2026-08-11)

     ★★이 화면에는 서식별 분기가 **하나도 없다.**
       표는 서버가 준 서식정의(AXIS_GB + 항목)가 그린다. 새 점검표가 생겨도 이 파일은 안 고친다.
       — 사고 유형별 보고서(qpsSafeRpt)에서 쓴 것과 같은 원칙을 격자에 적용한 것.

     ★축 4가지 (실물에서 관찰된 것만)
       EQUIP_DAY  기기 N행 × 1~31일    · 항목은 표 위 안내박스, 기기명은 문서마다 다름
       ITEM_DAY   점검항목 행 × 1~31일
       DAY_ITEM   1~31일 행 × 점검항목 열 (열 묶음 = 2단 머리글)
       ITEM_MONTH 점검항목 행 × 1~12월 (연 1장 — 월 셀렉트가 없다)

     ★셀 저장은 (행,열,값) — 빈 칸은 저장하지 않는다. 31×16 을 다 넣으면 낭비다.
     ★예약 행/열 900 = 점검자 사인.

     ★주의: 이 파일 안에서 Deferred EL 표기(샵+중괄호) 금지 --%>

<script src="/asset/js/ui-message.js"></script>

<div class="dashboard-wrapper">
<div id="qpsChk" data-wnn="<c:out value='${wnnYn}'/>">
<style>
  #qpsChk{ background:#f4f6f8; color:#1f2a30; min-height:100%; padding:14px 16px 60px; max-width:100%; overflow-x:hidden; }
  #qpsChk *{ box-sizing:border-box; }
  #qpsChk .ck-head{ display:flex; align-items:center; gap:10px; margin-bottom:12px; flex-wrap:wrap; }
  #qpsChk .ck-title{ font-size:18px; font-weight:800; color:#20303a; display:flex; align-items:center; gap:8px; }
  #qpsChk .ck-dot{ width:10px; height:10px; border-radius:50%; background:linear-gradient(135deg,#1f5a4b,#2a7665); }
  #qpsChk .ck-sub{ font-size:12px; color:#6b7c86; }
  #qpsChk .ck-hosp{ background:#e7f3ee; color:#1f5a4b; font-size:12px; font-weight:800;
      border:1px solid #cfe3da; border-radius:14px; padding:3px 11px; }
  #qpsChk .ck-spacer{ flex:1; }
  #qpsChk select, #qpsChk input, #qpsChk textarea{
      border:1px solid #cfd8e0; border-radius:5px; padding:5px 7px; font-family:inherit; font-size:12.5px; background:#fff; }
  #qpsChk textarea{ resize:vertical; line-height:1.55; width:100%; }
  #qpsChk .ck-btn{ border:1px solid #1f5a4b; background:#1f5a4b; color:#fff; border-radius:6px;
      padding:6px 14px; font-size:13px; font-weight:600; cursor:pointer; white-space:nowrap; }
  #qpsChk .ck-btn.ghost{ background:#fff; color:#1f5a4b; }
  #qpsChk .ck-btn.warn{ background:#fff; color:#b23b3b; border-color:#e0b4b4; }
  #qpsChk .ck-btn.mini{ padding:2px 9px; font-size:11.5px; border-color:#cfd8e0; color:#556570; background:#fff; }

  #qpsChk .ck-card{ background:#fff; border:1px solid #e3e9ed; border-radius:10px; padding:14px 16px; margin-bottom:12px; }
  #qpsChk .ck-card h4{ margin:0 0 10px; font-size:14px; font-weight:800; color:#1f5a4b; }
  #qpsChk .ck-card h4 .hint{ font-weight:500; font-size:12px; color:#8a99a3; }
  #qpsChk .ck-bar{ display:flex; gap:8px; align-items:center; flex-wrap:wrap; margin-bottom:10px; }
  #qpsChk .ck-guide{ background:#f2f8f5; border:1px solid #cfe3da; border-radius:6px;
      padding:6px 10px; font-size:12px; color:#33564a; margin-bottom:8px; }
  #qpsChk .ck-legend{ border:1px solid #dde5ea; border-radius:6px; padding:7px 10px; margin-bottom:8px;
      font-size:12px; color:#43555f; display:flex; flex-wrap:wrap; gap:4px 18px; }
  #qpsChk .ck-empty{ color:#8a99a3; font-size:12.5px; padding:20px 6px; text-align:center; }

  #qpsChk .gridwrap{ overflow:auto; max-height:62vh; border:1px solid #dfe4ea; border-radius:6px; }
  #qpsChk table.gr{ border-collapse:separate; border-spacing:0; font-size:12px; background:#fff; }
  #qpsChk table.gr th, #qpsChk table.gr td{ border-right:1px solid #e2e8ec; border-bottom:1px solid #e2e8ec;
      padding:0; text-align:center; white-space:nowrap; }
  #qpsChk table.gr th{ background:#f2f6f8; font-weight:700; color:#43555f; padding:4px 5px; position:sticky; top:0; z-index:2; }
  #qpsChk table.gr thead tr:nth-child(2) th{ top:26px; }
  #qpsChk table.gr th.hd, #qpsChk table.gr td.hd{ position:sticky; left:0; z-index:3; background:#f8fafb;
      text-align:left; padding:4px 7px; min-width:170px; max-width:340px; white-space:normal; line-height:1.4; }
  #qpsChk table.gr th.hd{ z-index:4; }
  #qpsChk table.gr td input{ width:100%; min-width:30px; border:none; background:transparent;
      text-align:center; padding:4px 2px; font-size:12px; }
  #qpsChk table.gr td input:focus{ background:#eaf5f0; outline:1px solid #8fc3b2; }
  #qpsChk table.gr td.hd input{ text-align:left; }
  #qpsChk table.gr tr.sign td, #qpsChk table.gr tr.sign th{ background:#fbfcfd; }
  #qpsChk .sun{ color:#c0392b; } #qpsChk .sat{ color:#2c6fb5; }

  #qpsChk .ck-form{ display:grid; grid-template-columns:110px 1fr 110px 1fr; gap:9px 10px; align-items:start; }
  #qpsChk .ck-form .lb{ font-size:12.5px; font-weight:700; color:#43555f; padding-top:8px; }
  #qpsChk .ck-form .full{ grid-column:2 / -1; }
  #qpsChk .ck-form input{ width:100%; }
</style>

<div class="ck-head">
  <div class="ck-title"><span class="ck-dot"></span><span id="ckTitle">점검표</span>
    <span class="ck-sub" id="ckAxisNm"></span></div>
  <span class="ck-hosp" id="ckHosp">🏥 <c:out value="${hospNm}" default="병원 미확인"/></span>
  <div class="ck-spacer"></div>
  <button type="button" class="ck-btn" onclick="ckSave();">저장</button>
  <button type="button" class="ck-btn ghost" onclick="ckPrint();">🖨 인쇄(A4 가로)</button>
  <button type="button" class="ck-btn warn" id="ckDelBtn" onclick="ckDel();" style="display:none;">삭제</button>
  <span class="ck-sub" id="ckStat"></span>
  <span style="flex:0 0 60px;"></span>
</div>

<div class="ck-card">
  <div class="ck-bar">
    <span style="font-size:12.5px; font-weight:700; color:#43555f;">서식</span>
    <select id="ckForm" style="min-width:300px;" onchange="ckPickForm();"></select>
    <span style="font-size:12.5px; font-weight:700; color:#43555f; margin-left:6px;">연도</span>
    <select id="ckYear" style="width:auto;" onchange="ckBase();"></select>
    <span id="ckMmWrap"><span style="font-size:12.5px; font-weight:700; color:#43555f;">월</span>
      <select id="ckMm" style="width:auto;"></select></span>
    <span style="font-size:12.5px; font-weight:700; color:#43555f; margin-left:6px;">병동</span>
    <input type="text" id="f_wardNm" maxlength="100" placeholder="예) 3병동" style="width:120px;">
    <span class="ck-spacer"></span>
    <select id="ckDoc" style="min-width:220px;" onchange="ckPickDoc();">
      <option value="">— 저장된 점검표 —</option>
    </select>
    <button type="button" class="ck-btn ghost" onclick="ckNew();">＋ 새로 작성</button>
  </div>
  <div id="ckHeadWrap" class="ck-form" style="margin-bottom:10px;"></div>
  <div class="ck-guide" id="ckGuide" style="display:none;"></div>
  <div class="ck-legend" id="ckLegend" style="display:none;"></div>
  <div class="gridwrap" id="ckGridWrap"><div class="ck-empty">서식을 고르세요.</div></div>

  <div id="ckNoteWrap" style="display:none; margin-top:10px;">
    <div style="font-size:12.5px; font-weight:700; color:#43555f; margin-bottom:4px;">특이사항</div>
    <textarea id="f_noteTxt" rows="2"></textarea>
  </div>
  <div id="ckFixWrap" style="display:none; margin-top:8px;">
    <div style="font-size:12.5px; font-weight:700; color:#43555f; margin-bottom:4px;">수리날짜 및 고장 발생 내용</div>
    <textarea id="f_fixTxt" rows="2"></textarea>
  </div>
  <div id="ckFoot" style="display:none; margin-top:8px; font-size:12px; color:#6b7c86;"></div>
</div>

<script>
(function(){
  var HOSP_NM = '', APPR_LINE = [], FORMS = [], FORM = null, ITEMS = [], DOCS = [], curSeq = 0;

  function gel(id){ return document.getElementById(id); }
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
  var AXIS_NM = { ITEM_DAY:'항목 × 일', DAY_ITEM:'일 × 항목', EQUIP_DAY:'기기 × 일', ITEM_MONTH:'항목 × 월' };
  var SIGN_NO = 900;   // 예약 — 점검자 사인 행(또는 열)

  (function(){
    var y = new Date().getFullYear(), sy = gel('ckYear');
    for (var i = y + 1; i >= y - 4; i--) sy.add(new Option(i + '년', i));
    sy.value = y;
    var sm = gel('ckMm');
    for (var m = 1; m <= 12; m++) sm.add(new Option(m + '월', ('0' + m).slice(-2)));
    sm.value = ('0' + (new Date().getMonth() + 1)).slice(-2);
  })();

  /** 그 달의 날 수 — ★31 로 고정하면 2월에 없는 날짜 칸이 생긴다. */
  function daysInMonth(){
    var y = Number(gel('ckYear').value), m = Number(gel('ckMm').value || 1);
    return new Date(y, m, 0).getDate();
  }
  function dowCls(d){
    if (isMonthly() === false) return '';
    var y = Number(gel('ckYear').value), m = Number(gel('ckMm').value || 1);
    var w = new Date(y, m - 1, d).getDay();
    return w === 0 ? ' sun' : (w === 6 ? ' sat' : '');
  }
  function isMonthly(){ return !FORM || FORM.prdgb !== 'Y'; }
  function axis(){ return (FORM && FORM.axisgb) || 'ITEM_DAY'; }

  function cell(r, c, v){
    return '<td><input data-r="' + r + '" data-c="' + c + '" value="' + esc(v) + '"></td>';
  }

  /** ★표를 그리는 곳은 여기 하나다. 서식이 늘어도 여기만 돈다. */
  function renderGrid(vals, rows){
    var box = gel('ckGridWrap');
    if (!FORM) { box.innerHTML = '<div class="ck-empty">서식을 고르세요.</div>'; return; }
    var V = {};
    (vals || []).forEach(function(v){ V[v.rowno + '_' + v.colno] = v.val; });
    var RN = {};
    (rows || []).forEach(function(r){ RN[r.rowno] = r.rownm; });
    function g(r, c){ return V[r + '_' + c] || ''; }

    var a = axis(), h = '', i, d;
    var nCol = isMonthly() ? daysInMonth() : 12;
    var suf  = isMonthly() ? '' : '월';

    if (a === 'DAY_ITEM') {
      // 1~31일 행 × 항목 열. 열 묶음(GRP_NM)이 있으면 2단 머리글.
      var grps = [], last = null;
      ITEMS.forEach(function(r){
        var gname = r.grpnm || '';
        if (last && last.g === gname) last.n++; else { last = { g:gname, n:1 }; grps.push(last); }
      });
      var hasGrp = grps.some(function(x){ return x.g; });
      h += '<table class="gr"><thead>';
      if (hasGrp) {
        h += '<tr><th class="hd" rowspan="2" style="min-width:44px;">일</th>' +
             grps.map(function(x){ return '<th colspan="' + x.n + '">' + esc(x.g) + '</th>'; }).join('') + '</tr><tr>';
        ITEMS.forEach(function(r){ h += '<th style="min-width:88px;white-space:normal;">' + esc(r.itemnm) +
            (r.unitnm ? ('<br>(' + esc(r.unitnm) + ')') : '') + '</th>'; });
        h += '</tr>';
      } else {
        h += '<tr><th class="hd" style="min-width:44px;">일</th>';
        ITEMS.forEach(function(r){ h += '<th style="min-width:88px;white-space:normal;">' + esc(r.itemnm) +
            (r.unitnm ? ('<br>(' + esc(r.unitnm) + ')') : '') + '</th>'; });
        h += '</tr>';
      }
      h += '</thead><tbody>';
      for (d = 1; d <= nCol; d++) {
        h += '<tr><td class="hd' + dowCls(d) + '" style="text-align:center;">' + d + suf + '</td>';
        ITEMS.forEach(function(r){ h += cell(d, r.sort, g(d, r.sort)); });
        h += '</tr>';
      }
      h += '</tbody></table>';

    } else if (a === 'EQUIP_DAY') {
      // 기기 N행 × 1~31일. ★기기명은 문서마다 다르다(병동마다 장비가 다르다).
      var n = Number(FORM.equipcnt || 10);
      h += '<table class="gr"><thead><tr><th class="hd">의료기기</th>';
      for (d = 1; d <= nCol; d++) h += '<th class="' + dowCls(d).trim() + '" style="min-width:32px;">' + d + suf + '</th>';
      h += '</tr></thead><tbody>';
      for (i = 1; i <= n; i++) {
        h += '<tr><td class="hd"><input data-rn="' + i + '" value="' + esc(RN[i] || '') +
             '" placeholder="의료기기 ' + i + '"></td>';
        for (d = 1; d <= nCol; d++) h += cell(i, d, g(i, d));
        h += '</tr>';
      }
      if (FORM.signeryn === 'Y') {
        h += '<tr class="sign"><th class="hd">점검자 확인란</th>';
        for (d = 1; d <= nCol; d++) h += cell(SIGN_NO, d, g(SIGN_NO, d));
        h += '</tr>';
      }
      h += '</tbody></table>';

    } else {
      // ITEM_DAY / ITEM_MONTH — 항목 행 × 일(또는 월) 열
      h += '<table class="gr"><thead><tr><th class="hd">' + (a === 'ITEM_MONTH' ? '점검 항목' : '일') + '</th>';
      for (d = 1; d <= nCol; d++) h += '<th class="' + dowCls(d).trim() + '" style="min-width:32px;">' + d + suf + '</th>';
      h += '</tr></thead><tbody>';
      if (!ITEMS.length) h += '<tr><td class="hd" style="color:#8a99a3;">이 서식에 점검항목이 없습니다 — [서식 관리]에서 등록하세요.</td>' +
                              '<td colspan="' + nCol + '"></td></tr>';
      ITEMS.forEach(function(r){
        h += '<tr><th class="hd">' + esc(r.itemnm) + (r.unitnm ? (' (' + esc(r.unitnm) + ')') : '') + '</th>';
        for (d = 1; d <= nCol; d++) h += cell(r.sort, d, g(r.sort, d));
        h += '</tr>';
      });
      if (FORM.signeryn === 'Y') {
        h += '<tr class="sign"><th class="hd">점검자 사인</th>';
        for (d = 1; d <= nCol; d++) h += cell(SIGN_NO, d, g(SIGN_NO, d));
        h += '</tr>';
      }
      h += '</tbody></table>';
    }
    box.innerHTML = h;
  }

  function renderHead(doc){
    doc = doc || {};
    var wrap = gel('ckHeadWrap'), nms = (FORM && FORM.headnms) ? String(FORM.headnms).split(',') : [];
    nms = nms.map(function(s){ return s.trim(); }).filter(function(s){ return s; }).slice(0, 4);
    if (!nms.length) { wrap.innerHTML = ''; wrap.style.display = 'none'; return; }
    wrap.style.display = '';
    wrap.innerHTML = nms.map(function(nm, i){
      return '<div class="lb">' + esc(nm) + '</div><div><input type="text" id="f_head' + (i + 1) +
             '" maxlength="200" value="' + esc(doc['head' + (i + 1)]) + '"></div>';
    }).join('');
  }

  function applyFormUi(){
    gel('ckTitle').textContent = FORM ? FORM.formnm : '점검표';
    gel('ckAxisNm').textContent = FORM ? ('— ' + (AXIS_NM[FORM.axisgb] || FORM.axisgb)) : '';
    // ★연단위 서식(ITEM_MONTH)은 월 셀렉트가 뜻이 없다 — 두면 「몇 월을 고르지?」가 된다
    gel('ckMmWrap').style.display = isMonthly() ? '' : 'none';
    var gd = gel('ckGuide');
    if (FORM && FORM.guidetxt) { gd.style.display = ''; gd.textContent = FORM.guidetxt; } else gd.style.display = 'none';
    // EQUIP_DAY 는 점검항목이 표 위 안내박스로만 나온다(셀은 기기별 일별)
    var lg = gel('ckLegend');
    if (FORM && FORM.axisgb === 'EQUIP_DAY' && ITEMS.length) {
      lg.style.display = '';
      lg.innerHTML = '<b style="margin-right:6px;">점검항목</b>' +
        ITEMS.map(function(r, i){ return '<span>' + (i + 1) + '. ' + esc(r.itemnm) + '</span>'; }).join('');
    } else lg.style.display = 'none';
    gel('ckNoteWrap').style.display = (FORM && FORM.noteyn === 'Y') ? '' : 'none';
    gel('ckFixWrap').style.display  = (FORM && FORM.fixyn === 'Y') ? '' : 'none';
    var ft = gel('ckFoot');
    if (FORM && FORM.foottxt) { ft.style.display = ''; ft.textContent = FORM.foottxt; } else ft.style.display = 'none';
  }

  window.ckBase = function(){
    return post('<c:url value="/qps/chkBase.do"/>', {
      inYear: gel('ckYear').value, formId: val('ckForm')
    }).then(function(res){
      if (res.hosp) { HOSP_NM = res.hosp.hospnm || ''; gel('ckHosp').textContent = '🏥 ' + HOSP_NM; }
      APPR_LINE = res.line || [];
      if (!FORMS.length) {
        FORMS = res.forms || [];
        var sel = gel('ckForm');
        sel.innerHTML = '';
        if (!FORMS.length) sel.add(new Option('— 등록된 서식이 없습니다 —', ''));
        FORMS.forEach(function(f){ sel.add(new Option(f.formnm, f.formid)); });
      }
      FORM = res.form || null;
      ITEMS = res.items || [];
      DOCS = res.list || [];
      var ds = gel('ckDoc');
      ds.innerHTML = '<option value="">— 저장된 점검표 (' + DOCS.length + ') —</option>';
      DOCS.forEach(function(d){
        var nm = (d.inmm ? (Number(d.inmm) + '월') : '연간') + (d.wardnm ? (' · ' + d.wardnm) : '') +
                 (d.head1 ? (' · ' + d.head1) : '');
        ds.add(new Option(nm, d.chkseq));
      });
      ds.value = curSeq ? String(curSeq) : '';
      applyFormUi();
      if (!curSeq) renderGrid([], []);
    }).catch(err);
  };

  window.ckPickForm = function(){
    curSeq = 0;
    gel('ckStat').textContent = '';
    gel('ckDelBtn').style.display = 'none';
    set('f_wardNm', ''); set('f_noteTxt', ''); set('f_fixTxt', '');
    ckBase().then(function(){ renderHead({}); renderGrid([], []); });
  };

  window.ckPickDoc = function(){
    var seq = val('ckDoc');
    if (!seq) { ckNew(); return; }
    post('<c:url value="/qps/chkGet.do"/>', { chkSeq: seq }).then(function(res){
      var d = res.doc || {};
      curSeq = Number(d.chkseq || 0);
      set('ckYear', d.inyear || gel('ckYear').value);
      if (d.inmm) set('ckMm', d.inmm);
      set('f_wardNm', d.wardnm); set('f_noteTxt', d.notetxt); set('f_fixTxt', d.fixtxt);
      renderHead(d);
      renderGrid(res.vals || [], res.rows || []);
      gel('ckStat').textContent = '— 저장분 #' + d.chkseq;
      gel('ckDelBtn').style.display = '';
    }).catch(err);
  };

  window.ckNew = function(){
    curSeq = 0;
    gel('ckDoc').value = '';
    set('f_noteTxt', ''); set('f_fixTxt', '');
    renderHead({});
    renderGrid([], []);
    gel('ckStat').textContent = '— 새 점검표';
    gel('ckDelBtn').style.display = 'none';
  };

  function collect(){
    var vals = [], rows = [];
    document.querySelectorAll('#ckGridWrap input[data-r]').forEach(function(el){
      var v = String(el.value).trim();
      if (!v) return;                       // ★빈 칸은 안 담는다
      vals.push({ rowno: Number(el.getAttribute('data-r')), colno: Number(el.getAttribute('data-c')), val: v });
    });
    document.querySelectorAll('#ckGridWrap input[data-rn]').forEach(function(el){
      var v = String(el.value).trim();
      if (!v) return;
      rows.push({ rowno: Number(el.getAttribute('data-rn')), rownm: v });
    });
    return { vals: vals, rows: rows };
  }

  window.ckSave = function(){
    if (!FORM) { _alertBox('서식을 먼저 고르세요.', {icon:'⚠️'}); return; }
    var c = collect();
    var m = { chkSeq: curSeq || '', formId: FORM.formid, inYear: gel('ckYear').value,
              inMm: isMonthly() ? gel('ckMm').value : '',
              wardNm: val('f_wardNm'),
              head1: val('f_head1'), head2: val('f_head2'), head3: val('f_head3'), head4: val('f_head4'),
              noteTxt: val('f_noteTxt'), fixTxt: val('f_fixTxt'),
              vals: JSON.stringify(c.vals), rows: JSON.stringify(c.rows) };
    post('<c:url value="/qps/chkSave.do"/>', m).then(function(res){
      _toast('저장되었습니다.', 'ok');
      curSeq = Number(res.chkSeq);
      ckBase().then(function(){ gel('ckDoc').value = String(curSeq); ckPickDoc(); });
    }).catch(err);
  };

  window.ckDel = function(){
    if (!curSeq) return;
    _confirmBox({ msg:'이 점검표를 삭제할까요?', icon:'⚠️', okText:'삭제', okColor:'#b23b3b',
      onOk: function(){
        post('<c:url value="/qps/chkDelete.do"/>', { chkSeq: curSeq }).then(function(){
          _toast('삭제되었습니다.', 'ok'); curSeq = 0; ckBase().then(ckNew);
        }).catch(err);
      } });
  };

  // ---------- 인쇄 ----------
  // ★A4 **가로**다. 31칸 격자는 세로로는 안 들어간다.
  var PRINT_CSS =
    '@page{ size:A4 landscape; margin:9mm; }' +
    'body{ margin:0; font-family:"맑은 고딕",Malgun Gothic,sans-serif; color:#000; }' +
    '.h1{ font-size:16px; font-weight:800; text-align:center; margin:0 0 6px; }' +
    '.meta{ font-size:11px; margin:0 0 6px; display:flex; gap:14px; flex-wrap:wrap; }' +
    'table{ width:100%; border-collapse:collapse; font-size:9px; }' +
    'th,td{ border:1px solid #666; padding:2px 3px; text-align:center; height:17px; }' +
    'th{ background:#eee; font-weight:700; }' +
    'td.l,th.l{ text-align:left; white-space:normal; }' +
    '.appr{ float:right; width:auto; margin:0 0 4px 8px; font-size:9px; }' +
    '.appr td{ height:34px; width:52px; }' +
    '.box{ border:1px solid #666; padding:4px 6px; font-size:9.5px; margin-top:4px;' +
    '      white-space:pre-wrap; text-align:left; min-height:24px; }' +
    '.sig{ margin-top:8px; font-size:10px; text-align:right; }' +
    '.sig span{ display:inline-block; margin-left:26px; }';

  function apprHtml(){
    if (!APPR_LINE.length) return '';
    return '<table class="appr"><thead><tr>' + APPR_LINE.map(function(r){ return '<th>' + esc(r.stepnm) + '</th>'; }).join('') +
           '</tr></thead><tbody><tr>' + APPR_LINE.map(function(){ return '<td></td>'; }).join('') + '</tr></tbody></table>';
  }

  window.ckPrint = function(){
    if (!FORM) { _alertBox('서식을 먼저 고르세요.', {icon:'⚠️'}); return; }
    // ★인쇄는 화면 격자를 그대로 옮긴다 — 따로 만들면 화면과 종이가 갈린다
    var src = document.querySelector('#ckGridWrap table.gr');
    if (!src) { _alertBox('표가 없습니다.', {icon:'⚠️'}); return; }
    var t = src.cloneNode(true);
    // 입력칸은 값만 남긴다(종이에 네모를 찍지 않는다)
    t.querySelectorAll('input').forEach(function(el){
      var td = el.parentNode, isHd = td.classList.contains('hd');
      td.textContent = String(el.value || '');
      if (isHd) td.className = 'l';
    });
    t.querySelectorAll('th.hd').forEach(function(el){ el.className = 'l'; });

    var yy = gel('ckYear').value, mm = isMonthly() ? (Number(gel('ckMm').value) + '월') : '';
    var meta = '<div class="meta"><span><b>병동</b> ' + esc(val('f_wardNm') || '') + '</span>' +
               '<span><b>기간</b> ' + esc(yy) + '년 ' + esc(mm) + '</span>';
    var nms = (FORM.headnms || '').split(',').map(function(s){ return s.trim(); }).filter(function(s){ return s; });
    nms.slice(0, 4).forEach(function(nm, i){
      var v = val('f_head' + (i + 1));
      if (v) meta += '<span><b>' + esc(nm) + '</b> ' + esc(v) + '</span>';
    });
    meta += '</div>';

    var legend = '';
    if (FORM.axisgb === 'EQUIP_DAY' && ITEMS.length)
      legend = '<div class="box"><b>점검항목</b> &nbsp;' +
               ITEMS.map(function(r, i){ return (i + 1) + '. ' + esc(r.itemnm); }).join(' &nbsp; ') + '</div>';
    var guide = FORM.guidetxt ? ('<div style="font-size:10px;text-align:right;margin-bottom:3px;">' + esc(FORM.guidetxt) + '</div>') : '';

    var tail = '';
    if (FORM.noteyn === 'Y') tail += '<div class="box"><b>특이사항</b><br>' + esc(val('f_noteTxt')) + '</div>';
    if (FORM.fixyn === 'Y')  tail += '<div class="box"><b>수리날짜 및 고장 발생 내용</b><br>' + esc(val('f_fixTxt')) + '</div>';
    if (FORM.foottxt)        tail += '<div style="font-size:9px;margin-top:4px;text-align:left;">' + esc(FORM.foottxt) + '</div>';
    if (FORM.signline) {
      tail += '<div class="sig">' + String(FORM.signline).split(',').map(function(s){
                return '<span>' + esc(s.trim()) + ' _____________ (인)</span>'; }).join('') + '</div>';
    }

    var body = apprHtml() + '<div class="h1">' + esc(FORM.formnm) + '</div><div style="clear:both;"></div>' +
               meta + legend + guide + t.outerHTML + tail;

    var title = (FORM.formnm + '_' + yy + mm + '_' + (val('f_wardNm') || '') + '_' + HOSP_NM).replace(/[\\\/:*?"<>|]/g, '-');
    var w = window.open('', '_blank', 'width=1200,height=900');
    if (!w) { _alertBox('팝업이 차단되어 인쇄창을 열지 못했습니다.<br>주소창 오른쪽의 팝업 차단을 허용해 주세요.', {icon:'⚠️'}); return; }
    w.document.open();
    w.document.write('<!doctype html><html lang="ko"><head><meta charset="utf-8"><title>' + esc(title) +
      '</title><style>' + PRINT_CSS + '</style></head><body>' + body + '</body></html>');
    w.document.close();
    w.focus();
    setTimeout(function(){ try { w.print(); } catch (e) { } }, 300);
  };

  // 월을 바꾸면 날 수가 달라진다 — 값은 지우지 않고 표만 다시 그린다
  gel('ckMm').addEventListener('change', function(){
    var c = collect();
    renderGrid(c.vals, c.rows);
  });

  $(function(){
    ckBase().then(function(){
      if (FORMS.length && !val('ckForm')) { gel('ckForm').value = FORMS[0].formid; }
      return ckBase();
    }).then(function(){ renderHead({}); renderGrid([], []); });
  });
})();
</script>
</div><%-- /#qpsChk --%>
</div><%-- /.dashboard-wrapper --%>
