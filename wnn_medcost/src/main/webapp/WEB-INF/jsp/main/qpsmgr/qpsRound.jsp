<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%-- qpsRound.jsp — QPS 서식 3호: 환자안전 관리 라운딩 점검표 (2026-08-09)
     · 월 1부(병원+년월). 원본의 [전월복사]가 핵심 — 매달 같은 항목을 재점검하므로
       전월 항목·내용을 가져오고 평가(양호/불량)·불량내용만 리셋한다.
     · 사진 첨부(원본 2쪽)는 공통 파일첨부 과제로 미룸.
     · ★주의: 이 파일 안에서 Deferred EL 표기(샵+중괄호) 금지 --%>

<script src="/asset/js/ui-message.js"></script>
<%@ include file="/WEB-INF/jsp/main/inc/qpsFileBox.jsp" %>

<div class="dashboard-wrapper">
<div id="qpsRound" data-wnn="<c:out value='${wnnYn}'/>">
<style>
  #qpsRound{ background:#f4f6f8; color:#1f2a30; min-height:100%; padding:14px 16px 60px; max-width:100%; overflow-x:hidden; }
  #qpsRound *{ box-sizing:border-box; }
  #qpsRound .qr-head{ display:flex; align-items:center; gap:10px; margin-bottom:12px; flex-wrap:wrap; }
  #qpsRound .qr-title{ font-size:18px; font-weight:800; color:#20303a; display:flex; align-items:center; gap:8px; }
  #qpsRound .qr-dot{ width:10px; height:10px; border-radius:50%; background:linear-gradient(135deg,#1f5a4b,#2a7665); }
  #qpsRound .qr-sub{ font-size:12px; color:#6b7c86; }
  #qpsRound .qr-hosp{ background:#e7f3ee; color:#1f5a4b; font-size:12px; font-weight:800;
      border:1px solid #cfe3da; border-radius:14px; padding:3px 11px; }
  #qpsRound .qr-spacer{ flex:1; }
  #qpsRound select, #qpsRound input{ border:1px solid #cfd8e0; border-radius:5px; padding:5px 7px;
      font-family:inherit; font-size:12.5px; background:#fff; }
  #qpsRound .qr-btn{ border:1px solid #1f5a4b; background:#1f5a4b; color:#fff; border-radius:6px;
      padding:6px 14px; font-size:13px; font-weight:600; cursor:pointer; white-space:nowrap; }
  #qpsRound .qr-btn.ghost{ background:#fff; color:#1f5a4b; }
  #qpsRound .qr-btn.mini{ padding:2px 9px; font-size:11.5px; border-color:#cfd8e0; color:#556570; background:#fff; }
  #qpsRound .qr-btn:hover{ opacity:.9; }

  #qpsRound .qr-card{ background:#fff; border:1px solid #e3e9ed; border-radius:10px; padding:14px 16px; }
  #qpsRound table.ed{ width:100%; border-collapse:collapse; font-size:12.5px; }
  #qpsRound table.ed th{ background:#f2f6f8; border:1px solid #dde5ea; padding:6px; font-weight:700; color:#43555f; }
  #qpsRound table.ed td{ border:1px solid #e6ecef; padding:3px; vertical-align:middle; }
  #qpsRound table.ed input[type=text]{ width:100%; border:none; background:transparent; padding:4px 5px; }
  #qpsRound table.ed input[type=text]:focus{ background:#f7fbf9; outline:1px solid #8fc3b2; }
  #qpsRound table.ed input[type=radio]{ display:block; margin:4px auto; width:15px; height:15px; }
  #qpsRound .rowdel{ color:#b23b3b; cursor:pointer; font-weight:700; text-align:center; width:26px; }
  #qpsRound tr.bad td{ background:#fff8f5; }
  /* ── 글자 크기 (2026-08-18 요청 「QPS 메뉴에도 없는 것 추가」)
       QI 계획서(qpsQiPlan)와 **같은 모양·같은 조작**이다 — 화면마다 다르면 손이 헷갈린다.
       ⚠이 화면은 감염 메뉴(?gb=I 감염라운딩)와 **틀이 하나**라 배율도 함께 쓴다. */
  #qpsRound .zz-zoom{ display:inline-flex; gap:4px; align-items:center; margin-left:2px; margin-right:14px; }
  #qpsRound .zz-zoom button{ border:1px solid #cfd9e0; background:#fff; color:#43555f; border-radius:6px;
                          padding:4px 9px; font-size:13px; font-weight:700; cursor:pointer; }
  #qpsRound .zz-zoom button:hover{ background:#eef3f6; }
</style>

<div class="qr-head">
  <div class="qr-title"><span class="qr-dot"></span><span id="rdTitle">환자안전 관리 라운딩 점검표</span> <span class="qr-sub">서식 3호 · 월 1부</span></div>
  <span class="qr-hosp" id="rdHosp">🏥 <c:out value="${hospNm}" default="병원 미확인"/></span>
  <div class="qr-spacer"></div>
  <%-- 서식구분(2026-08-10 감염관리 포함) — 같은 달이라도 질향상용·감염관리용이 각각 1부 --%>
  <%-- 초기값은 서버가 정한다 — 감염 메뉴(?gb=I)로 들어오면 감염라운딩으로 열린다 --%>
  <select id="rdGb" style="width:auto;" onchange="rdLoad();" data-init="<c:out value='${formGb}' default='Q'/>">
    <option value="Q">질향상·환자안전</option>
    <option value="I">감염관리</option>
  </select>
  <label class="qr-sub">점검자</label> <input type="text" id="rdChecker" maxlength="50" style="width:110px;">
  <input type="month" id="rdYm" style="width:auto;" onchange="rdLoad();">
  <button type="button" class="qr-btn ghost" onclick="rdCopyPrev();">⧉ 전월 복사</button>
  <button type="button" class="qr-btn" onclick="rdSave();">저장</button>
  <button type="button" class="qr-btn ghost" onclick="rdPrint();">🖨 인쇄(A4)</button>
  <%-- ★화면 안 일괄 출력 (2026-09-08 — 확장 3호) : 저장된 달만 골라 한 번에 이어 인쇄. 아래 #rdBulkPrintBox 에 펼친다. --%>
  <button type="button" class="qr-btn ghost" onclick="rdBulkPrintToggle();" title="이 구분(또는 둘 다)의 저장된 라운딩 점검표를 월 범위로 골라 한 번에 인쇄합니다">🖨 일괄 출력</button>
  <span class="qr-sub" id="rdStat"></span>
  <span style="flex:0 0 12px;"></span>
  <%-- 글자 크기 — 이 PC 이 브라우저에만 저장된다 --%>
  <span class="zz-zoom">
    <button type="button" onclick="zzZoom(-1);" title="글자 작게">가－</button>
    <button type="button" onclick="zzZoom(1);"  title="글자 크게">가＋</button>
    <button type="button" onclick="zzZoom(0);"  title="처음 크기로">↺</button>
  </span>
</div>

<%-- 🖨 화면 안 일괄 출력 조건 띠 (2026-09-08) — 라운딩은 「구분 × 월 1부」 문서라 조건도 그것 : 구분(이 구분/둘 다) · 연도 · 월 범위.
     저장된 달만 담는다(빈 달은 기본 틀이 그려져 있어 그대로 찍으면 빈 서식이 나온다). --%>
<div id="rdBulkPrintBox" style="display:none; margin:6px 0 4px; padding:8px 12px; border:1px solid #b9cfe6; border-radius:8px; background:#eef4fb; font-size:12.5px; color:#1f2a37;">
  <div style="display:flex; align-items:center; gap:10px; flex-wrap:wrap;">
    <b style="color:#2f6fb0;">🖨 일괄 출력</b>
    <label style="display:inline-flex; align-items:center; gap:4px; margin:0;"><input type="radio" name="rdBpScope" value="F" checked> 이 구분만 <span id="rdBpGbNm" style="color:#5a6b7a;"></span></label>
    <label style="display:inline-flex; align-items:center; gap:4px; margin:0;"><input type="radio" name="rdBpScope" value="A"> 질향상·감염 둘 다</label>
    <span style="margin-left:8px;">기간</span>
    <select id="rdBpYear" style="width:auto;"></select>
    <select id="rdBpFrom" style="width:auto;"></select><span>~</span><select id="rdBpTo" style="width:auto;"></select>
    <button type="button" class="qr-btn" id="rdBpGo" style="margin-left:auto;" onclick="rdBulkPrintGo();">출력</button>
    <button type="button" class="qr-btn ghost" onclick="rdBulkPrintToggle();">닫기</button>
  </div>
  <div style="margin-top:5px; font-size:11.5px; color:#5a6b7a;">저장된 달의 점검표만 한 장씩 이어 붙여 한 번에 인쇄합니다(자료를 만들지 않음). 한 번에 120장까지. <span id="rdBpStat" style="color:#2f6fb0; font-weight:700;"></span></div>
</div>

<div class="qr-card">
  <table class="ed"><thead><tr>
    <%-- 구분: '각실 관리(공통)' 처럼 괄호 달린 이름이 잘리지 않을 폭 --%>
    <th style="width:150px;">구분</th><th style="width:190px;">점검 항목</th><th>점검 내용</th>
    <th style="width:46px;">양호</th><th style="width:46px;">불량</th>
    <th style="width:240px;">불량 내용 및 개선사항</th><th style="width:26px;"></th>
  </tr></thead><tbody id="rdBody"></tbody></table>
  <button type="button" class="qr-btn mini" style="margin-top:6px;" onclick="rdAdd();">＋ 행 추가</button>
  <span class="qr-sub" style="margin-left:8px;">양호/불량을 다시 누르면 해제됩니다(미점검).</span>
  <div style="margin-top:14px; border-top:1px solid #eef2f5; padding-top:12px;">
    <div style="font-size:13px; font-weight:800; color:#20303a; margin-bottom:6px;">첨부파일 <span style="font-weight:500;font-size:11.5px;color:#8a99a3;">— 라운딩 사진 등</span></div>
    <div id="rdFileBox"></div>
  </div>
</div>

<script>
(function(){
  var HOSP_NM = '', rowIdx = 0,
      LAST_DOC = false;   // 지금 보이는 달에 저장된 점검표가 있는가 — 일괄 출력이 빈 달을 거른다(2026-09-08)
  // 공통 첨부 — 라운딩(ROUND) 문서키 = 년월(자연키).
  var fileBox = window.qpsFileBox({ mount:'rdFileBox', refGb:'ROUND',
      hint:'라운딩 사진·파일', needSaveMsg:'년월을 선택하면 첨부할 수 있습니다.' });
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
    var d = new Date();
    document.getElementById('rdYm').value = d.getFullYear() + '-' + ('0' + (d.getMonth() + 1)).slice(-2);
  })();
  function ym(){ return document.getElementById('rdYm').value.replace('-', ''); }
  /** 서식구분 — Q=질향상·환자안전, I=감염관리 (2026-08-10) */
  function rdGb(){ var e=document.getElementById("rdGb"); return e ? e.value : "Q"; }

  // 새 문서 기본 틀 — 원본 1쪽의 구분 묶음(항목·내용은 병원이 채우고 [전월 복사]로 재사용)
  var DEFAULTS = [];
  [['의료기기 관리',5],['의료용구 관리',4],['응급 kit',1],['각실 관리(공통)',6],['공통',4],
   ['화재',2],['건축시설',1],['공조설비',1],['전기시설',1],['교육',1]]
  .forEach(function(g){ for (var i = 0; i < g[1]; i++) DEFAULTS.push({ grp: (i === 0 ? g[0] : g[0]), c1:'', c2:'' }); });

  function addRow(r){
    r = r || {};
    var id = ++rowIdx;
    var tb = document.getElementById('rdBody');
    var tr = document.createElement('tr');
    tr.innerHTML =
      '<td><input type="text" data-f="grp" value="' + esc(r.grp) + '"></td>' +
      '<td><input type="text" data-f="c1" value="' + esc(r.c1) + '"></td>' +
      '<td><input type="text" data-f="c2" value="' + esc(r.c2) + '"></td>' +
      '<td><input type="radio" name="ev' + id + '" data-f="evalgb" value="G"' + (r.evalgb === 'G' ? ' checked' : '') + '></td>' +
      '<td><input type="radio" name="ev' + id + '" data-f="evalgb" value="B"' + (r.evalgb === 'B' ? ' checked' : '') + '></td>' +
      '<td><input type="text" data-f="c3" value="' + esc(r.c3) + '"></td>' +
      '<td class="rowdel" onclick="this.closest(\'tr\').remove();">✕</td>';
    tb.appendChild(tr);
  }
  window.rdAdd = function(){ addRow({}); };

  // 라디오 재클릭 해제(미점검 상태로 되돌리기) + 불량 행 배경
  document.getElementById('qpsRound').addEventListener('click', function(e){
    var t = e.target;
    if (t.type === 'radio') {
      if (t.getAttribute('data-was') === '1') { t.checked = false; t.removeAttribute('data-was'); }
      else {
        document.getElementsByName(t.name).forEach ?
          Array.prototype.forEach.call(document.getElementsByName(t.name), function(o){ o.removeAttribute('data-was'); }) : 0;
        t.setAttribute('data-was', '1');
      }
      var tr = t.closest('tr');
      var b = tr.querySelector('input[value="B"]');
      tr.className = (b && b.checked) ? 'bad' : '';
    }
  });

  function collect(){
    var items = [], sort = 0;
    document.querySelectorAll('#rdBody tr').forEach(function(tr){
      var r = { sort: ++sort };
      tr.querySelectorAll('[data-f]').forEach(function(el){
        if (el.type === 'radio') { if (el.checked) r.evalgb = el.value; }
        else r[el.getAttribute('data-f')] = String(el.value).trim();
      });
      if (!r.evalgb) r.evalgb = null;
      var hasVal = r.grp || r.c1 || r.c2 || r.c3 || r.evalgb;
      if (hasVal) items.push(r);
    });
    return items;
  }

  function fill(items, resetEval){
    var tb = document.getElementById('rdBody');
    tb.innerHTML = '';
    (items.length ? items : DEFAULTS).forEach(function(r){
      if (resetEval) r = { grp: r.grp, c1: r.c1, c2: r.c2 };   // 평가·불량내용 리셋
      addRow(r);
    });
    // 불량 행 배경 복원
    document.querySelectorAll('#rdBody tr').forEach(function(tr){
      var b = tr.querySelector('input[value="B"]');
      if (b && b.checked) tr.className = 'bad';
      tr.querySelectorAll('input[type=radio]').forEach(function(o){ if (o.checked) o.setAttribute('data-was', '1'); });
    });
  }

  var LOAD_REQ = 0;   // 조회 순번 — 늦게 온 옛 응답이 새 목록·문서를 덮지 않게(2026-09-08, 일괄 출력에서 실제로 겪음)
  window.rdLoad = function(){
    var my = ++LOAD_REQ;
    if (fileBox) fileBox.setKey(ym() + '|' + rdGb());   /* 년월|구분 = 첨부 키(감염 것과 안 섞이게) */
    var t = document.getElementById('rdTitle');
    if (t) t.textContent = (rdGb()==='I') ? '감염관리 라운딩 점검표' : '환자안전 관리 라운딩 점검표';
    LAST_DOC = false;   // ★먼저 내린다 — 조회가 실패하면(err 가 삼켜 resolve 로 온다) 앞 달의 값이 남아 잘못 찍힌다
    return post('/qps/roundGet.do', { formGb: rdGb(), roundYm: ym() }).then(function(res){
      if (my !== LOAD_REQ) return;   // 더 새 조회가 나갔다 — 옛 응답은 버린다(2026-09-08)
      if (res.hosp) { HOSP_NM = res.hosp.hospnm || '';
        document.getElementById('rdHosp').textContent = '🏥 ' + HOSP_NM; }
      var rnd = res.round;
      LAST_DOC = !!rnd;
      document.getElementById('rdChecker').value = (rnd && rnd.checker) ? rnd.checker : '';
      document.getElementById('rdStat').textContent = rnd ? ('최종수정 ' + (rnd.upddttm || '')) : '작성 전';
      fill(res.items || [], false);
    }).catch(err);
  };

  // [전월 복사] — 전월 항목·내용을 가져오고 평가·불량내용은 리셋(이번 달 점검은 새로 한다)
  window.rdCopyPrev = function(){
    var v = document.getElementById('rdYm').value.split('-');
    var d = new Date(Number(v[0]), Number(v[1]) - 2, 1);   // 전월
    var prevYm = d.getFullYear() + ('0' + (d.getMonth() + 1)).slice(-2);
    post('/qps/roundGet.do', { formGb: rdGb(), roundYm: prevYm }).then(function(res){
      var items = res.items || [];
      if (!items.length) { _alertBox('전월(' + prevYm.substring(0,4) + '-' + prevYm.substring(4) + ') 점검표가 없습니다.', {icon:'⚠️'}); return; }
      _confirmBox({ msg:'전월 점검표의 <b>항목·내용 ' + items.length + '행</b>을 가져올까요?<br>' +
        '<span style="color:#6b7c86;font-size:12px;">평가(양호/불량)와 불량내용은 비워집니다. 현재 화면의 행은 대체됩니다.</span>',
        icon:'⧉', okText:'가져오기',
        onOk: function(){ fill(items, true); _toast('전월 항목을 가져왔습니다. 점검 후 저장하세요.', 'ok'); } });
    }).catch(err);
  };

  window.rdSave = function(){
    post('/qps/roundSave.do', {
      formGb: rdGb(), roundYm: ym(), checker: document.getElementById('rdChecker').value.trim(),
      items: JSON.stringify(collect())
    }).then(function(){
      _toast('저장되었습니다.', 'ok');
      return rdLoad();
    }).catch(err);
  };

  /* ═══ 🖨 화면 안 일괄 출력 (2026-09-08 — 확장 3호 · 월 문서형) ═══
     ★조건은 이 업무의 말로 — 라운딩은 「구분 × 월 1부」라 목록이 없다. 달을 하나씩 열어(rdLoad) **저장된 달만**(LAST_DOC)
       낱장 인쇄(rdPrint)를 QPS_BULK_CB 로 모아 끝에 qpsPrintMerge(sidebar.jsp)로 한 문서. 빈 달은 기본 틀이 깔려
       있어 그대로 찍으면 빈 서식이 섞인다 — 그래서 LAST_DOC 으로 거른다.
     ★자료를 만들지 않는다. 끝나면 보던 구분·달로 되돌린다. 상한 120장. */
  window.BP = { busy:false };
  function $id(id){ return document.getElementById(id); }
  function bpFill(){
    var ys = $id('rdBpYear');
    if (!ys.options.length) { var y = new Date().getFullYear(); for (var i = y + 1; i >= y - 4; i--) ys.add(new Option(i + '년', i)); }
    var mf = $id('rdBpFrom'), mt = $id('rdBpTo');
    if (mf.options.length) return;
    for (var m = 1; m <= 12; m++) { var v = (m < 10 ? '0' : '') + m; mf.add(new Option(m + '월', v)); mt.add(new Option(m + '월', v)); }
  }
  function rdGbNm(v){ var o = document.querySelector('#rdGb option[value="' + v + '"]'); return o ? o.text : v; }
  window.rdBulkPrintToggle = function(){
    var box = $id('rdBulkPrintBox');
    if (box.style.display !== 'none') { box.style.display = 'none'; return; }
    bpFill();
    $id('rdBpYear').value = ym().substring(0, 4); $id('rdBpFrom').value = '01'; $id('rdBpTo').value = '12';
    $id('rdBpGbNm').textContent = '(' + rdGbNm(rdGb()) + ')';
    $id('rdBpStat').textContent = '';
    box.style.display = '';
  };
  window.rdBulkPrintGo = function(){
    if (BP.busy) return;
    var scope = (document.querySelector('input[name=rdBpScope]:checked') || {}).value || 'F';
    var yy = $id('rdBpYear').value, f = $id('rdBpFrom').value, t = $id('rdBpTo').value;
    if (f > t) { var x = f; f = t; t = x; $id('rdBpFrom').value = f; $id('rdBpTo').value = t; }
    var gbs = (scope === 'A') ? Array.prototype.map.call($id('rdGb').options, function(o){ return o.value; }) : [rdGb()];
    var keepYm = $id('rdYm').value, keepGb = rdGb();
    var title = '라운딩점검표_' + yy + '년' + (f === '01' && t === '12' ? '' : ('_' + Number(f) + '~' + Number(t) + '월')) +
                '_' + (scope === 'A' ? '전체' : rdGbNm(keepGb)) + '_' + HOSP_NM;
    var months = [];
    for (var m = Number(f); m <= Number(t); m++) months.push((m < 10 ? '0' : '') + m);
    var parts = [], MAX = 120, done = 0, stat = $id('rdBpStat'), gi = 0;
    BP.busy = true; $id('rdBpGo').disabled = true;
    window.QPS_BULK_CB = function(p){ parts.push(p); };
    var finish = function(){
      window.QPS_BULK_CB = null;
      $id('rdGb').value = keepGb; $id('rdYm').value = keepYm;   // 보던 구분·달로
      Promise.resolve(rdLoad()).then(function(){
        BP.busy = false; $id('rdBpGo').disabled = false;
        if (!parts.length) { stat.textContent = '기간 안에 저장된 점검표가 없습니다.'; return; }
        var n = qpsPrintMerge(parts, title);
        stat.textContent = (n < 0) ? '팝업이 막혀 인쇄창을 열지 못했습니다.' :
                           (parts.length + '장을 이어 붙였습니다' + (done >= MAX ? ' (상한 ' + MAX + '장)' : '') + '.');
      }, function(){ BP.busy = false; $id('rdBpGo').disabled = false; });
    };
    var nextGb = function(){
      if (gi >= gbs.length || done >= MAX) { finish(); return; }
      $id('rdGb').value = gbs[gi++];
      var mi = 0;
      var oneMonth = function(){
        if (mi >= months.length || done >= MAX) { nextGb(); return; }
        var mm = months[mi++];
        $id('rdYm').value = yy + '-' + mm;
        stat.textContent = '(' + rdGbNm(rdGb()) + ') ' + yy + '년 ' + Number(mm) + '월 읽는 중 …';
        Promise.resolve(rdLoad()).then(function(){
          if (LAST_DOC) { try { rdPrint(); done++; } catch (e) { } }
          stat.textContent = '(' + rdGbNm(rdGb()) + ') ' + yy + '년 ' + Number(mm) + '월 — ' + done + '장';
          oneMonth();
        }, function(){ oneMonth(); });
      };
      oneMonth();
    };
    nextGb();
  };

  // ---------- 인쇄(A4) — 별도 창 ----------
  var PRINT_CSS =
    '@page{ size:A4 portrait; margin:12mm; }' +
    'body{ margin:0; font-family:"맑은 고딕",Malgun Gothic,sans-serif; color:#000; }' +
    '.h1{ font-size:17px; font-weight:800; margin:0 0 2px; }' +
    '.h2{ font-size:12px; color:#333; margin:0 0 10px; display:flex; justify-content:space-between; }' +
    'table{ width:100%; border-collapse:collapse; font-size:10.5px; }' +
    'th,td{ border:1px solid #666; padding:4px 5px; text-align:left; vertical-align:middle; line-height:1.55; }' +
    'th{ background:#efefef; font-weight:700; text-align:center; }' +
    'td.c{ text-align:center; }' +
    'tr{ page-break-inside:avoid; }';

  window.rdPrint = function(){
    var items = collect();
    if (!items.length) { _alertBox('점검 항목이 없습니다.', {icon:'⚠️'}); return; }
    var v = document.getElementById('rdYm').value.split('-');
    var rows = '', prevGrp = null;
    items.forEach(function(r){
      rows += '<tr><td class="c">' + (r.grp !== prevGrp ? esc(r.grp || '') : '') + '</td>' +
        '<td>' + esc(r.c1 || '') + '</td><td>' + esc(r.c2 || '') + '</td>' +
        '<td class="c">' + (r.evalgb === 'G' ? '✔' : '') + '</td>' +
        '<td class="c">' + (r.evalgb === 'B' ? '✔' : '') + '</td>' +
        '<td>' + esc(r.c3 || '') + '</td></tr>';
      prevGrp = r.grp;
    });
    var body =
      '<div class="h1">환자안전 관리 라운딩 점검표</div>' +
      '<div class="h2"><span>' + esc(HOSP_NM) + '</span>' +
      '<span>' + esc(v[0]) + '년 ' + Number(v[1]) + '월 &nbsp;&nbsp; 점검자 : ' +
        esc(document.getElementById('rdChecker').value) + '</span></div>' +
      '<table><thead><tr><th style="width:96px;">구분</th><th style="width:140px;">점검 항목</th><th>점검 내용</th>' +
      '<th style="width:34px;">양호</th><th style="width:34px;">불량</th><th style="width:170px;">불량 내용 및 개선사항</th></tr></thead>' +
      '<tbody>' + rows + '</tbody></table>';

    var title = ('라운딩점검표_' + v[0] + v[1] + '_' + HOSP_NM).replace(/[\\\/:*?"<>|]/g, '-');
    qpsPrintOut(title, PRINT_CSS, body);   /* 낱장 인쇄·일괄 출력 공통(2026-09-07) */
  };

  $(function(){
    var g = document.getElementById('rdGb');
    if (g) { var init = g.getAttribute('data-init'); if (init) g.value = init; }
    rdLoad();
  });
})();

/* ═══ 글자 크기 (2026-08-18 요청) ═══════════════════════════════════════
   QI 계획서(qpsQiPlan)의 zzZoom 과 **같은 규칙** — 0.8~1.6배, 0.1 단위, ↺ 는 처음 크기.
   ★고른 크기는 **이 PC 이 브라우저에만** 남는다(localStorage). 키는 화면마다 따로 둔다. */
(function(){
  var W = 'qpsRound', ZKEY = 'qpsZoom_' + W;
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
</div><%-- /#qpsRound --%>
</div><%-- /.dashboard-wrapper --%>
