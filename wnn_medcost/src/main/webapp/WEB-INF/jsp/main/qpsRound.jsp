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
</style>

<div class="qr-head">
  <div class="qr-title"><span class="qr-dot"></span>환자안전 관리 라운딩 점검표 <span class="qr-sub">서식 3호 · 월 1부</span></div>
  <span class="qr-hosp" id="rdHosp">🏥 <c:out value="${hospNm}" default="병원 미확인"/></span>
  <div class="qr-spacer"></div>
  <label class="qr-sub">점검자</label> <input type="text" id="rdChecker" maxlength="50" style="width:110px;">
  <input type="month" id="rdYm" style="width:auto;" onchange="rdLoad();">
  <button type="button" class="qr-btn ghost" onclick="rdCopyPrev();">⧉ 전월 복사</button>
  <button type="button" class="qr-btn" onclick="rdSave();">저장</button>
  <button type="button" class="qr-btn ghost" onclick="rdPrint();">🖨 인쇄(A4)</button>
  <span class="qr-sub" id="rdStat"></span>
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
  var HOSP_NM = '', rowIdx = 0;
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

  window.rdLoad = function(){
    if (fileBox) fileBox.setKey(ym());   // 년월 = 첨부 키
    return post('/qps/roundGet.do', { roundYm: ym() }).then(function(res){
      if (res.hosp) { HOSP_NM = res.hosp.hospnm || '';
        document.getElementById('rdHosp').textContent = '🏥 ' + HOSP_NM; }
      var rnd = res.round;
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
    post('/qps/roundGet.do', { roundYm: prevYm }).then(function(res){
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
      roundYm: ym(), checker: document.getElementById('rdChecker').value.trim(),
      items: JSON.stringify(collect())
    }).then(function(){
      _toast('저장되었습니다.', 'ok');
      return rdLoad();
    }).catch(err);
  };

  // ---------- 인쇄(A4) — 별도 창 ----------
  var PRINT_CSS =
    '@page{ size:A4 portrait; margin:12mm 12mm 14mm; }' +
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
    var w = window.open('', '_blank', 'width=900,height=1000');
    if (!w) { _alertBox('팝업이 차단되어 인쇄창을 열지 못했습니다.<br>주소창 오른쪽의 팝업 차단을 허용해 주세요.', {icon:'⚠️'}); return; }
    w.document.open();
    w.document.write('<!doctype html><html lang="ko"><head><meta charset="utf-8"><title>' + esc(title) +
      '</title><style>' + PRINT_CSS + '</style></head><body>' + body + '</body></html>');
    w.document.close();
    w.focus();
    setTimeout(function(){ try { w.print(); } catch (e) { } }, 300);
  };

  $(function(){ rdLoad(); });
})();
</script>
</div><%-- /#qpsRound --%>
</div><%-- /.dashboard-wrapper --%>
