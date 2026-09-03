<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%-- qpsQiTopic.jsp — QI 주제선정 기준표 + 우선순위 집계표 (2026-08-11)

     ★원본은 문서가 4개(집계표·기준표 × 전년도·당해년도)지만 ***화면은 하나다.***
       전년도·당해년도는 **평가 연도**일 뿐이라 연도 셀렉트로 덮인다.
       (이름으로 갈라 둔 것을 그대로 베끼면 화면이 4개가 된다 — 만족도 (원무)/(원무2) 와 같은 함정)

     ★★핵심 — 기준표의 「평가위원」은 한 명이다. ***평가위원 1명 = 기준표 1장.***
       집계표 우측의 「번호」 칸은 **평가위원별 총점**이고, 원본 [생성] 버튼은
       그 해 기준표를 모아 주제별로 합산해 순위를 매기는 것이다.
       ⇒ 집계표는 저장하지 않는다. 조회할 때마다 다시 센다.

     ★기준 6개는 연간 활동계획서의 주제선정 섹션과 같다(각 10점, 총점 60점).
     ★감염 우선순위 사정 도구와 같은 구조 — [기준표] + [집계표] 두 탭.

     ★주의: 이 파일 안에서 Deferred EL 표기(샵+중괄호) 금지 --%>

<script src="/asset/js/ui-message.js"></script>
<script src="/asset/js/ui-split.js"></script>

<div class="dashboard-wrapper">
<div id="qpsQiTopic" data-wnn="<c:out value='${wnnYn}'/>">
<style>
  #qpsQiTopic{ background:#f4f6f8; color:#1f2a30; min-height:100%; padding:14px 16px 60px; max-width:100%; overflow-x:hidden; }
  #qpsQiTopic *{ box-sizing:border-box; }
  #qpsQiTopic .qt-head{ display:flex; align-items:center; gap:10px; margin-bottom:12px; flex-wrap:wrap; }
  #qpsQiTopic .qt-title{ font-size:18px; font-weight:800; color:#20303a; display:flex; align-items:center; gap:8px; }
  #qpsQiTopic .qt-dot{ width:10px; height:10px; border-radius:50%; background:linear-gradient(135deg,#1f5a4b,#2a7665); }
  #qpsQiTopic .qt-sub{ font-size:12px; color:#6b7c86; }
  #qpsQiTopic .qt-hosp{ background:#e7f3ee; color:#1f5a4b; font-size:12px; font-weight:800;
      border:1px solid #cfe3da; border-radius:14px; padding:3px 11px; }
  #qpsQiTopic .qt-spacer{ flex:1; }
  #qpsQiTopic select, #qpsQiTopic input{
      border:1px solid #cfd8e0; border-radius:5px; padding:5px 7px; font-family:inherit; font-size:12.5px; background:#fff; }
  #qpsQiTopic .qt-btn{ border:1px solid #1f5a4b; background:#1f5a4b; color:#fff; border-radius:6px;
      padding:6px 14px; font-size:13px; font-weight:600; cursor:pointer; white-space:nowrap; }
  #qpsQiTopic .qt-btn.ghost{ background:#fff; color:#1f5a4b; }
  #qpsQiTopic .qt-btn.warn{ background:#fff; color:#b23b3b; border-color:#e0b4b4; }
  #qpsQiTopic .qt-btn.mini{ padding:2px 9px; font-size:11.5px; border-color:#cfd8e0; color:#556570; background:#fff; }

  #qpsQiTopic .qt-tabs{ display:flex; gap:6px; margin-bottom:10px; }
  #qpsQiTopic .qt-tab{ padding:7px 16px; border:1px solid #dde5ea; border-radius:8px 8px 0 0;
      background:#eef3f6; font-size:13px; font-weight:700; color:#63757f; cursor:pointer; }
  #qpsQiTopic .qt-tab.on{ background:#fff; color:#1f5a4b; border-bottom-color:#fff; }
  #qpsQiTopic .qt-card{ background:#fff; border:1px solid #e3e9ed; border-radius:10px; padding:14px 16px; margin-bottom:12px; }
  #qpsQiTopic .qt-card h4{ margin:0 0 10px; font-size:14px; font-weight:800; color:#1f5a4b; }
  #qpsQiTopic .qt-card h4 .hint{ font-weight:500; font-size:12px; color:#8a99a3; }

  #qpsQiTopic .qt-wrap{ display:flex; gap:14px; align-items:flex-start; }
  #qpsQiTopic .qt-left{ width:230px; flex:none; }
  #qpsQiTopic .qt-right{ flex:1; min-width:0; }
  #qpsQiTopic .qt-item{ padding:8px 10px; border:1px solid #eef2f5; border-radius:8px; margin-bottom:6px; cursor:pointer; }
  #qpsQiTopic .qt-item:hover{ border-color:#8fc3b2; background:#f7fbf9; }
  #qpsQiTopic .qt-item.on{ border-color:#1f5a4b; background:#f0f7f4; }
  #qpsQiTopic .qt-item .t{ font-size:13px; font-weight:700; color:#20303a; }
  #qpsQiTopic .qt-item .d{ font-size:11.5px; color:#8a99a3; margin-top:2px; }
  #qpsQiTopic .qt-empty{ color:#8a99a3; font-size:12.5px; padding:16px 6px; text-align:center; }

  #qpsQiTopic table.ed{ width:100%; border-collapse:collapse; font-size:12px; }
  #qpsQiTopic table.ed th{ background:#f2f6f8; border:1px solid #dde5ea; padding:5px 3px; font-weight:700; color:#43555f; }
  #qpsQiTopic table.ed td{ border:1px solid #e6ecef; padding:2px; }
  #qpsQiTopic table.ed input{ width:100%; border:none; background:transparent; padding:4px 3px; font-size:12px; }
  #qpsQiTopic table.ed input:focus{ background:#f7fbf9; outline:1px solid #8fc3b2; }
  #qpsQiTopic table.ed input.num{ text-align:center; }
  #qpsQiTopic table.ed td.tot{ background:#f7fbf9; font-weight:800; text-align:center; }
  #qpsQiTopic table.st{ width:100%; border-collapse:collapse; font-size:12px; }
  #qpsQiTopic table.st th, #qpsQiTopic table.st td{ border:1px solid #dfe4ea; padding:5px 6px; text-align:center; }
  #qpsQiTopic table.st th{ background:#f2f6f8; font-weight:700; color:#43555f; white-space:nowrap; }
  #qpsQiTopic table.st td.l{ text-align:left; }
  #qpsQiTopic table.st tr.top1 td{ background:#f0f7f4; font-weight:700; }
  #qpsQiTopic .none{ color:#8a99a3; font-size:12.5px; padding:16px 4px; text-align:center; }
  /* ── 글자 크기 (2026-08-18 요청 「QI 에 글자 축소·확대가 없는 게 있다」)
       QI 계획서(qpsQiPlan)와 **같은 모양·같은 조작**이다 — 화면마다 다르면 손이 헷갈린다. */
  #qpsQiTopic .zz-zoom{ display:inline-flex; gap:4px; align-items:center; margin-left:2px; margin-right:14px; }
  #qpsQiTopic .zz-zoom button{ border:1px solid #cfd9e0; background:#fff; color:#43555f; border-radius:6px;
                            padding:4px 9px; font-size:13px; font-weight:700; cursor:pointer; }
  #qpsQiTopic .zz-zoom button:hover{ background:#eef3f6; }
</style>

<div class="qt-head">
  <div class="qt-title"><span class="qt-dot"></span>QI 주제선정 · 우선순위 <span class="qt-sub">평가위원별 기준표 → 집계</span></div>
  <span class="qt-hosp" id="qtHosp">🏥 <c:out value="${hospNm}" default="병원 미확인"/></span>
  <div class="qt-spacer"></div>
  <select id="qtYear" style="width:auto;" onchange="qtLoad();"></select>
  <button type="button" class="qt-btn" onclick="qtSave();">기준표 저장</button>
  <button type="button" class="qt-btn ghost" onclick="qtPrint();">🖨 인쇄(A4)</button>
  <button type="button" class="qt-btn warn" id="qtDelBtn" onclick="qtDel();" style="display:none;">삭제</button>
  <span class="qt-sub" id="qtStat"></span>
  <span style="flex:0 0 12px;"></span>
  <%-- 글자 크기 — 이 PC 이 브라우저에만 저장된다 --%>
  <span class="zz-zoom">
    <button type="button" onclick="zzZoom(-1);" title="글자 작게">가－</button>
    <button type="button" onclick="zzZoom(1);"  title="글자 크게">가＋</button>
    <button type="button" onclick="zzZoom(0);"  title="처음 크기로">↺</button>
  </span>
</div>

<div class="qt-tabs">
  <div class="qt-tab on" id="tab1" onclick="qtTab(1);">📝 주제선정 기준표</div>
  <div class="qt-tab"    id="tab2" onclick="qtTab(2);">📊 우선순위 집계표</div>
</div>

<%-- ───────── 탭1 : 기준표 (평가위원 1명 = 1장) ───────── --%>
<div id="pane1">
  <div class="qt-wrap" data-split="가로" data-split-key="qitopic.body">
    <div class="qt-left">
      <div class="qt-card">
        <h4>평가위원 <span class="hint" id="qtCnt"></span></h4>
        <div id="qtListBox"><div class="qt-empty">불러오는 중…</div></div>
        <button type="button" class="qt-btn ghost" style="width:100%; margin-top:6px;" onclick="qtNew();">＋ 새 평가위원</button>
      </div>
    </div>
    <div class="qt-right">
      <div class="qt-card">
        <h4>QPS 활동 주제선정 기준표 <span class="hint">— 평가기준 : 항목당 10점 만점</span></h4>
        <input type="hidden" id="f_qitSeq" value="">
        <div style="display:flex; gap:14px; align-items:center; margin-bottom:10px; flex-wrap:wrap;">
          <label class="qt-sub">평가일시</label> <input type="date" id="f_evalDt" style="width:auto;">
          <label class="qt-sub">평가위원 *</label> <input type="text" id="f_evaluator" maxlength="60" style="width:180px;">
        </div>
        <div style="overflow-x:auto;">
        <table class="ed" style="min-width:900px;"><thead><tr>
          <th style="width:34px;">번호</th><th style="width:90px;">부서</th><th style="min-width:200px;">주제</th>
          <th style="width:74px;">병원미션<br>정책과의<br>연관성<br>10점</th>
          <th style="width:74px;">고객에게<br>미치는<br>영향<br>10점</th>
          <th style="width:74px;">환자안전<br>관련성<br><br>10점</th>
          <th style="width:74px;">고위험<br>다빈도<br>문제가능<br>10점</th>
          <th style="width:74px;">개선활동<br>용이성<br><br>10점</th>
          <th style="width:74px;">국내·외<br>평가지표<br><br>10점</th>
          <th style="width:60px;">총점<br>60점</th><th style="width:26px;"></th>
        </tr></thead><tbody id="tbITEM"></tbody></table>
        </div>
        <button type="button" class="qt-btn mini" style="margin-top:6px;" onclick="qtAdd();">＋ 행 추가</button>
      </div>
    </div>
  </div>
</div>

<%-- ───────── 탭2 : 집계표 (저장하지 않고 계산) ───────── --%>
<div id="pane2" style="display:none;">
  <div class="qt-card">
    <h4>QPS 활동 주제 우선순위 집계표
      <span class="hint">— 그 해 기준표를 모아 자동으로 셈합니다. 따로 저장하지 않습니다</span></h4>
    <div style="overflow-x:auto;"><table class="st" id="qtRollTbl"></table></div>
    <div class="qt-sub" style="margin-top:6px;">
      ※ 주제명이 같은 행을 한 주제로 봅니다. 평가위원마다 주제를 <b>똑같이 적어야</b> 합산됩니다.
    </div>
  </div>
</div>

<script>
(function(){
  var HOSP_NM = '', APPR_LINE = [], curSeq = 0, ROLL = [], CROSS = [], EVALS = [];

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

  (function(){
    var y = new Date().getFullYear(), sel = gel('qtYear');
    for (var i = y + 1; i >= y - 4; i--) sel.add(new Option(i + '년', i));
    sel.value = y;
  })();

  window.qtTab = function(n){
    gel('pane1').style.display = (n === 1) ? '' : 'none';
    gel('pane2').style.display = (n === 2) ? '' : 'none';
    gel('tab1').className = 'qt-tab' + (n === 1 ? ' on' : '');
    gel('tab2').className = 'qt-tab' + (n === 2 ? ' on' : '');
  };

  function itemRow(r, no){
    r = r || {};
    var s = '';
    for (var i = 1; i <= 6; i++) {
      s += '<td><input class="num" data-f="s' + i + '" value="' + esc(r['s' + i] == null ? '' : r['s' + i]) + '"></td>';
    }
    var tr = document.createElement('tr');
    tr.innerHTML = '<td style="text-align:center;color:#8a99a3;">' + no + '</td>' +
      '<td><input data-f="deptnm" value="' + esc(r.deptnm) + '"></td>' +
      '<td><input data-f="topicnm" value="' + esc(r.topicnm) + '"></td>' + s +
      '<td class="tot" data-tot>' + rowTot(r) + '</td>' +
      '<td class="rowdel" style="color:#b23b3b;cursor:pointer;font-weight:700;text-align:center;" ' +
      'onclick="this.closest(\'tr\').remove(); qtRenum();">✕</td>';
    gel('tbITEM').appendChild(tr);
  }
  function rowTot(r){
    var t = 0, has = false;
    for (var i = 1; i <= 6; i++) {
      var v = Number(r['s' + i]);
      if (r['s' + i] !== '' && r['s' + i] != null && !isNaN(v)) { t += v; has = true; }
    }
    return has ? t : '';
  }
  window.qtAdd = function(){ itemRow({}, gel('tbITEM').rows.length + 1); };
  window.qtRenum = function(){
    Array.prototype.forEach.call(gel('tbITEM').rows, function(tr, i){ tr.cells[0].textContent = i + 1; });
  };

  // 점수를 고치면 총점이 바로 따라온다
  gel('qpsQiTopic').addEventListener('input', function(e){
    var tr = e.target.closest('#tbITEM tr');
    if (!tr) return;
    var r = readRow(tr), t = tr.querySelector('[data-tot]');
    if (t) t.textContent = rowTot(r);
  });

  function readRow(tr){
    var r = {};
    tr.querySelectorAll('[data-f]').forEach(function(el){ r[el.getAttribute('data-f')] = String(el.value).trim(); });
    return r;
  }
  function collect(){
    var out = [], sort = 0;
    Array.prototype.forEach.call(gel('tbITEM').rows, function(tr){
      var r = readRow(tr);
      var has = Object.keys(r).some(function(k){ return r[k] !== ''; });
      if (!has) return;
      r.sort = ++sort;
      out.push(r);
    });
    return out;
  }

  window.qtLoad = function(){
    return post('<c:url value="/qps/qiTopicList.do"/>', { inYear: gel('qtYear').value }).then(function(res){
      if (res.hosp) { HOSP_NM = res.hosp.hospnm || ''; gel('qtHosp').textContent = '🏥 ' + HOSP_NM; }
      APPR_LINE = res.line || [];
      ROLL = res.rollup || []; CROSS = res.cross || []; EVALS = res.evaluators || [];
      var list = res.list || [], box = gel('qtListBox');
      gel('qtCnt').textContent = list.length ? ('· ' + list.length + '명') : '';
      box.innerHTML = list.length
        ? list.map(function(r){
            return '<div class="qt-item' + (Number(r.qitseq) === curSeq ? ' on' : '') + '" onclick="qtOpen(' + r.qitseq + ');">' +
                   '<div class="t">' + esc(r.evaluator || '(이름 없음)') + '</div>' +
                   '<div class="d">' + esc(r.evaldt || '') + '</div></div>';
          }).join('')
        : '<div class="qt-empty">평가위원이 없습니다.<br>[＋ 새 평가위원]으로 만드세요.</div>';
      renderRollup();
    }).catch(err);
  };

  /** 집계표 — 저장하지 않는다. 원본 [생성] 버튼이 하던 일을 조회 때마다 한다. */
  function renderRollup(){
    var t = gel('qtRollTbl');
    if (!ROLL.length) { t.innerHTML = '<tr><td class="none">기준표가 없습니다. 평가위원별로 점수를 먼저 입력하세요.</td></tr>'; return; }
    // 주제 × 평가위원 총점
    var by = {};
    CROSS.forEach(function(c){ by[String(c.topicnm) + '|' + String(c.qitseq)] = c.totscore; });
    var h = '<thead><tr><th style="width:40px;">번호</th><th style="width:90px;">부서</th><th style="min-width:180px;">주제</th>' +
            '<th style="width:70px;">총점</th><th style="width:56px;">순위</th><th style="width:56px;">선정</th>';
    EVALS.forEach(function(e){ h += '<th style="width:78px;">' + esc(e.evaluator || '-') + '</th>'; });
    h += '</tr></thead><tbody>';
    ROLL.forEach(function(r, i){
      // 선정 = 상위 3개(원본은 사람이 표시한다. 우리는 순위로 제안하고 인쇄에서 그대로 나간다)
      var pick = (Number(r.rank) <= 3) ? '○' : '';
      h += '<tr' + (Number(r.rank) === 1 ? ' class="top1"' : '') + '>' +
           '<td>' + (i + 1) + '</td><td>' + esc(r.deptnm || '') + '</td><td class="l">' + esc(r.topicnm) + '</td>' +
           '<td><b>' + (r.totscore == null ? 0 : r.totscore) + '</b></td><td>' + esc(r.rank) + '</td><td>' + pick + '</td>';
      EVALS.forEach(function(e){
        var v = by[String(r.topicnm) + '|' + String(e.qitseq)];
        h += '<td>' + (v == null ? '' : v) + '</td>';
      });
      h += '</tr>';
    });
    t.innerHTML = h + '</tbody>';
  }

  window.qtOpen = function(seq){
    post('<c:url value="/qps/qiTopicGet.do"/>', { qitSeq: seq }).then(function(res){
      var d = res.doc || {};
      curSeq = Number(d.qitseq || 0);
      set('f_qitSeq', d.qitseq); set('f_evalDt', d.evaldt); set('f_evaluator', d.evaluator);
      gel('tbITEM').innerHTML = '';
      var items = res.items || [];
      (items.length ? items : blank10()).forEach(function(r, i){ itemRow(r, i + 1); });
      gel('qtStat').textContent = '— 저장된 기준표 #' + d.qitseq;
      gel('qtDelBtn').style.display = '';
      qtTab(1);
      qtLoad();
    }).catch(err);
  };
  function blank10(){ var a = []; for (var i = 0; i < 10; i++) a.push({}); return a; }

  window.qtNew = function(){
    curSeq = 0;
    ['f_qitSeq','f_evalDt','f_evaluator'].forEach(function(id){ set(id, ''); });
    gel('tbITEM').innerHTML = '';
    blank10().forEach(function(r, i){ itemRow(r, i + 1); });
    gel('qtStat').textContent = '— 새 기준표';
    gel('qtDelBtn').style.display = 'none';
    qtTab(1);
    qtLoad();
  };

  window.qtSave = function(){
    if (!val('f_evaluator')) { _alertBox('평가위원을 입력해 주세요.<br>집계표가 누가 매긴 점수인지 구분하는 기준입니다.', {icon:'⚠️'}); return; }
    post('<c:url value="/qps/qiTopicSave.do"/>', {
      qitSeq: val('f_qitSeq'), inYear: gel('qtYear').value,
      evalDt: val('f_evalDt'), evaluator: val('f_evaluator'),
      items: JSON.stringify(collect())
    }).then(function(res){
      _toast('저장되었습니다.', 'ok');
      qtOpen(res.qitSeq);
    }).catch(err);
  };

  window.qtDel = function(){
    if (!curSeq) return;
    _confirmBox({ msg:'이 평가위원의 기준표를 삭제할까요?<br><span style="font-size:12px;color:#8a99a3;">집계표에서도 빠집니다.</span>',
      icon:'⚠️', okText:'삭제', okColor:'#b23b3b',
      onOk: function(){
        post('<c:url value="/qps/qiTopicDelete.do"/>', { qitSeq: curSeq }).then(function(){
          _toast('삭제되었습니다.', 'ok'); qtNew();
        }).catch(err);
      } });
  };

  // ---------- 인쇄 — 보고 있는 탭을 낸다 ----------
  var PRINT_CSS =
    'body{ margin:0; font-family:"맑은 고딕",Malgun Gothic,sans-serif; color:#000; }' +
    '.h1{ font-size:16px; font-weight:800; text-align:center; margin:0 0 8px; }' +
    '.sub{ font-size:11px; text-align:right; margin-bottom:4px; }' +
    'table{ width:100%; border-collapse:collapse; font-size:10px; }' +
    'th,td{ border:1px solid #666; padding:3px 4px; text-align:center; vertical-align:middle; }' +
    'th{ background:#efefef; font-weight:700; }' +
    'td.l{ text-align:left; }' +
    '.appr{ float:right; width:auto; margin:0 0 6px 8px; font-size:9.5px; }' +
    '.appr th{ padding:2px 6px; } .appr td{ height:40px; width:56px; }' +
    'tr{ page-break-inside:avoid; }';

  function apprHtml(){
    if (!APPR_LINE.length) return '';
    var h = '<table class="appr"><thead><tr>';
    APPR_LINE.forEach(function(r){ h += '<th>' + esc(r.stepnm) + '</th>'; });
    h += '</tr></thead><tbody><tr>';
    APPR_LINE.forEach(function(){ h += '<td></td>'; });
    return h + '</tr></tbody></table>';
  }

  window.qtPrint = function(){
    var yy = gel('qtYear').value;
    var isRoll = (gel('pane2').style.display !== 'none');
    var body, title, css = PRINT_CSS;

    if (isRoll) {
      body = apprHtml() + '<div class="h1">' + esc(yy) + ' 년 QPS 활동 주제 우선순위 집계표</div>' +
             '<div style="clear:both;"></div><table>' + gel('qtRollTbl').innerHTML + '</table>';
      title = 'QPS주제우선순위집계표_' + yy + '_' + HOSP_NM;
      css = '@page{ size:A4 landscape; margin:10mm; }' + css;   // 평가위원 열이 늘어 가로가 안전하다
    } else {
      var rows = collect();
      var body2 = rows.map(function(r, i){
        var s = '';
        for (var k = 1; k <= 6; k++) s += '<td>' + esc(r['s' + k] || '') + '</td>';
        return '<tr><td>' + (i + 1) + '</td><td>' + esc(r.deptnm) + '</td><td class="l">' + esc(r.topicnm) + '</td>' +
               s + '<td><b>' + rowTot(r) + '</b></td></tr>';
      }).join('');
      body = apprHtml() + '<div class="h1">QPS 활동 주제선정 기준표</div><div style="clear:both;"></div>' +
        '<div class="sub">평가일시 ' + esc(val('f_evalDt')) + ' &nbsp;&nbsp; 평가위원 ' + esc(val('f_evaluator')) +
        ' &nbsp;&nbsp; (평가기준 : 항목당 10점 만점 기준)</div>' +
        '<table><thead><tr><th style="width:30px;">번호</th><th style="width:70px;">부서</th><th>주제</th>' +
        '<th style="width:60px;">병원미션<br>정책과의<br>연관성<br>10점</th><th style="width:60px;">고객에게<br>미치는<br>영향<br>10점</th>' +
        '<th style="width:60px;">환자안전<br>관련성<br><br>10점</th><th style="width:60px;">고위험<br>다빈도<br>문제가능<br>10점</th>' +
        '<th style="width:60px;">개선활동<br>용이성<br><br>10점</th><th style="width:60px;">국내·외<br>평가지표<br><br>10점</th>' +
        '<th style="width:50px;">총점<br>60점</th></tr></thead><tbody>' + body2 + '</tbody></table>';
      title = 'QPS주제선정기준표_' + yy + '_' + val('f_evaluator') + '_' + HOSP_NM;
      css = '@page{ size:A4 portrait; margin:11mm; }' + css;
    }

    var w = window.open('', '_blank', 'width=1000,height=1000');
    if (!w) { _alertBox('팝업이 차단되어 인쇄창을 열지 못했습니다.<br>주소창 오른쪽의 팝업 차단을 허용해 주세요.', {icon:'⚠️'}); return; }
    w.document.open();
    w.document.write('<!doctype html><html lang="ko"><head><meta charset="utf-8"><title>' +
      esc(title.replace(/[\\\/:*?"<>|]/g, '-')) + '</title><style>' + css + '</style></head><body>' + body + '</body></html>');
    w.document.close();
    w.focus();
    setTimeout(function(){ try { w.print(); } catch (e) { } }, 300);
  };

  $(function(){ qtNew(); });
})();

/* ═══ 글자 크기 (2026-08-18 요청) ═══════════════════════════════════════
   QI 계획서(qpsQiPlan)의 zzZoom 과 **같은 규칙** — 0.8~1.6배, 0.1 단위, ↺ 는 처음 크기.
   ★고른 크기는 **이 PC 이 브라우저에만** 남는다(localStorage). 키는 화면마다 따로 둔다. */
(function(){
  var W = 'qpsQiTopic', ZKEY = 'qpsZoom_' + W;
  /* ⚠**같은 화면이 두 벌 붙어 있을 수 있다**(주소 숨김 구조 - content 를 갈아끼운다).
     getElementById 는 「첫 번째 = 보이지 않는 사본」을 잡아 ***눌러도 아무 일이 없다.***
     ⇒ querySelectorAll 로 **붙어 있는 사본 전부**에 건다. */
  function els(){ return [].slice.call(document.querySelectorAll('#' + W)); }
  function zoom(z){
    z = Math.min(1.6, Math.max(0.8, z));
    els().forEach(function(w){ w.style.zoom = z.toFixed(2); });
    return z;
  }
  window.zzZoom = function(d){
    var e0 = els()[0], c0 = parseFloat(e0 && e0.style.zoom) || 1;
    if (d === 0) { zoom(1); try { localStorage.removeItem(ZKEY); } catch (e) {} return; }
    var z = zoom(c0 + d * 0.1);
    try { localStorage.setItem(ZKEY, String(z)); } catch (e) {}
  };
  try { var z = parseFloat(localStorage.getItem(ZKEY)); if (z) zoom(z); } catch (e) {}
})();
</script>
</div><%-- /#qpsQiTopic --%>
</div><%-- /.dashboard-wrapper --%>
