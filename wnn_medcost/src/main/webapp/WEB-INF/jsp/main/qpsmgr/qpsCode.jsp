<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%-- qpsCode.jsp — 기준코드 › 공통코드(QPS) 관리 (2026-09-02)
     · 메뉴 : QPS ▸ 관리(설정) ▸ 기준코드 ▸ 공통코드 (사용자 지시 「스크립트로 생성한 공통코드를 해당 내용 관리하게」).
     · 대상 : TBL_CODE_DTL 의 'Q' 묶음(QPS_%) 31개 — 점검표 부서·분류, 보고서 유형, 불만고충, 만족도, 사고 세부유형, 자료실 분류 …
     · 왼쪽 = 묶음(이름·쓰는 수/전체), 오른쪽 = 세부코드 표(코드값·이름·차례·사용). 이름·차례·사용만 고친다 — **코드값은 작성분의 키라 못 바꾼다.**
       지움 = 「사용 안 함」(USE_YN N) — 작성분이 남으므로 지우지 않는다. 다시 켤 수 있다.
     · 보는 것은 모두 · 고치는 것은 위너넷만(data-wnn 으로 숨기고 서버가 다시 막는다).
     · ★주의: 이 파일 안에서 Deferred EL 표기(샵+중괄호) 금지 --%>

<script src="/asset/js/ui-message.js"></script>
<script src="/asset/js/ui-split.js"></script>

<div class="dashboard-wrapper">
<div id="qpsCode" data-wnn="<c:out value='${wnnYn}'/>">
<style>
  #qpsCode{ background:#f4f6f8; color:#1f2a30; min-height:100%; padding:14px 16px 50px; max-width:100%; overflow-x:hidden; }
  #qpsCode *{ box-sizing:border-box; }
  #qpsCode .qc-head{ display:flex; align-items:center; gap:10px; margin-bottom:12px; flex-wrap:wrap; }
  #qpsCode .qc-title{ font-size:18px; font-weight:800; color:#20303a; display:flex; align-items:center; gap:8px; }
  #qpsCode .qc-dot{ width:10px; height:10px; border-radius:50%; background:linear-gradient(135deg,#1f5a4b,#2a7665); }
  #qpsCode .qc-sub{ font-size:12px; color:#6b7c86; font-weight:400; }
  #qpsCode .qc-hosp{ background:#e7f3ee; color:#1f5a4b; font-size:12px; font-weight:800; border:1px solid #cfe3da; border-radius:14px; padding:3px 11px; }
  #qpsCode .qc-spacer{ flex:1; }
  #qpsCode input, #qpsCode select{ border:1px solid #cfd8e0; border-radius:5px; padding:4px 7px; font-size:12.5px; background:#fff; font-family:inherit; }
  #qpsCode .qc-note{ background:#fff; border:1px solid #e3e9ed; border-radius:10px; padding:9px 14px; font-size:12.5px; color:#43555f; margin-bottom:12px; line-height:1.6; }
  #qpsCode .qc-note b{ color:#20303a; }
  #qpsCode .qc-body{ display:flex; gap:12px; align-items:flex-start; }
  #qpsCode .qc-left{ width:330px; flex:0 0 330px; background:#fff; border:1px solid #e3e9ed; border-radius:10px; overflow:hidden; }
  #qpsCode .qc-left .hd{ padding:8px 12px; font-size:12.5px; font-weight:700; color:#43555f; background:#f2f6f8; border-bottom:1px solid #dde5ea; }
  /* 묶음 32개 — 화면 높이만큼만 보여 주고 목록 안에서 스크롤(2026-09-02 「여기까지 보여주고 스크롤로」). 오른쪽 표는 그대로 */
  #qpsCode #qcGroups{ max-height:calc(100vh - 300px); min-height:240px; overflow-y:auto; }
  #qpsCode .qc-left{ position:sticky; top:8px; }
  /* 오른쪽 표도 같은 높이에서 안쪽 스크롤 — 머리글은 고정(「오른쪽도 동일하게 스크롤」) */
  #qpsCode #qcTableWrap{ max-height:calc(100vh - 300px); min-height:240px; overflow-y:auto; }
  #qpsCode #qcTableWrap thead th{ position:sticky; top:0; z-index:1; }
  #qpsCode .qc-grp{ padding:7px 12px; border-bottom:1px solid #eef2f5; cursor:pointer; font-size:12.5px; display:flex; gap:8px; align-items:center; }
  #qpsCode .qc-grp:hover{ background:#f7fbf9; }
  #qpsCode .qc-grp.on{ background:#e7f3ee; }
  #qpsCode .qc-grp .nm{ flex:1; font-weight:700; color:#20303a; }
  #qpsCode .qc-grp .cd{ font-size:11px; color:#8a99a3; font-family:Consolas,monospace; }
  #qpsCode .qc-grp .n{ font-size:11.5px; color:#6b7c86; white-space:nowrap; }
  #qpsCode .qc-grp .nm.none{ color:#b23b3b; font-weight:400; font-style:italic; }
  #qpsCode .qc-right{ flex:1; min-width:0; background:#fff; border:1px solid #e3e9ed; border-radius:10px; padding:10px 12px; }
  #qpsCode .qc-rhead{ display:flex; align-items:center; gap:8px; flex-wrap:wrap; margin-bottom:8px; }
  #qpsCode .qc-rhead .t{ font-size:14px; font-weight:800; color:#20303a; }
  #qpsCode table{ width:100%; border-collapse:collapse; font-size:12.5px; }
  #qpsCode th{ background:#f2f6f8; font-weight:700; color:#43555f; padding:6px 8px; border-bottom:1px solid #dde5ea; text-align:left; white-space:nowrap; }
  #qpsCode td{ padding:4px 8px; border-bottom:1px solid #eef2f5; vertical-align:middle; }
  #qpsCode td input[type=text]{ width:100%; }
  #qpsCode td input.num{ width:60px; text-align:center; }
  #qpsCode tr.off td{ color:#a8b4bb; background:#fafbfc; }
  #qpsCode tr.off td input{ color:#a8b4bb; }
  #qpsCode tr.new td{ background:#fffbea; }
  #qpsCode tr.dirty td:first-child{ border-left:3px solid #e0a23a; }
  #qpsCode .qc-btn{ border:1px solid #cfd9e0; background:#fff; color:#43555f; border-radius:6px; padding:4px 10px; font-size:12px; font-weight:700; cursor:pointer; white-space:nowrap; }
  #qpsCode .qc-btn:hover{ background:#eef3f6; }
  #qpsCode .qc-btn.pri{ background:#1f5a4b; color:#fff; border-color:#1f5a4b; }
  #qpsCode .qc-btn.pri:hover{ background:#2a7665; }
  #qpsCode .qc-empty{ color:#8a99a3; font-size:13px; padding:22px; text-align:center; }
  #qpsCode .qc-cd{ font-family:Consolas,monospace; font-size:12px; color:#43555f; }
</style>

<div class="qc-head">
  <div class="qc-title"><span class="qc-dot"></span>공통코드 <span class="qc-sub">— 기준코드 · QPS 묶음 · 전 병원 공용</span></div>
  <span class="qc-hosp">🏥 <c:out value='${hospNm}'/></span>
  <span class="qc-spacer"></span>
  <input type="text" id="qcFind" placeholder="묶음·코드·이름 찾기" style="width:200px;" oninput="qcPaintGroups();">
</div>

<div class="qc-note">
  QPS 화면들이 쓰는 <b>선택지 목록</b>입니다(점검표 부서·분류, 보고서 유형, 불만고충·만족도 선택지, 사고 세부유형, 자료실 분류 …).
  <b>이름·차례·사용 여부</b>를 고칩니다. <b>코드값은 못 바꿉니다</b> — 이미 작성된 문서가 그 값으로 저장돼 있습니다.
  쓰지 않을 코드는 「사용」을 끄세요(지우지 않습니다 — 옛 문서가 그대로 읽힙니다).
  <span id="qcHospNote" style="display:none;">고치는 것은 위너넷 담당자가 합니다 — 바꿀 것이 있으면 알려 주세요.</span>
</div>

<div class="qc-body" data-split="가로" data-split-key="code.body">
  <div class="qc-left">
    <div class="hd">묶음 <span id="qcGrpCnt" class="qc-sub"></span></div>
    <div id="qcGroups"><div class="qc-empty">불러오는 중…</div></div>
  </div>
  <div class="qc-right">
    <div class="qc-rhead">
      <span class="t" id="qcTitle">묶음을 고르세요</span>
      <span class="qc-cd" id="qcCode"></span>
      <span id="qcGrpEdit" style="display:none;">
        <input type="text" id="qcGrpNm" placeholder="묶음 이름" maxlength="100" style="width:220px;">
        <button type="button" class="qc-btn" onclick="qcGrpSave();">이름 저장</button>
      </span>
      <span class="qc-spacer"></span>
      <span id="qcRowBtns" style="display:none;">
        <button type="button" class="qc-btn" onclick="qcAddRow();">＋ 코드 추가</button>
        <button type="button" class="qc-btn pri" onclick="qcSaveAll();">고친 것 저장</button>
      </span>
    </div>
    <div id="qcTableWrap">
    <table>
      <thead><tr><th style="width:150px;">코드값</th><th>이름</th><th style="width:70px;">차례</th><th style="width:60px;">사용</th><th style="width:90px;"></th></tr></thead>
      <tbody id="qcBody"><tr><td colspan="5" class="qc-empty">왼쪽에서 묶음을 고르세요.</td></tr></tbody>
    </table>
    </div>
  </div>
</div>

<script>
(function(){
  function gel(id){ return document.getElementById(id); }
  function esc(s){ return (s==null?'':String(s)).replace(/[&<>"]/g, function(c){ return ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;'})[c]; }); }
  function post(url, data){
    return $.ajax({ url:url, type:'POST', data:data, dataType:'json' }).then(function(res){
      if (res && res.result === 'FAIL') { throw new Error(res.message || '처리에 실패했습니다.'); }
      return res;
    });
  }
  function err(e){ _alertBox((e && e.message) ? e.message : '처리 중 오류가 발생했습니다.', {icon:'❌'}); }
  var WNN = gel('qpsCode').getAttribute('data-wnn') === 'Y';
  var GROUPS = [], ROWS = [], CUR = '';
  gel('qcHospNote').style.display = WNN ? 'none' : '';

  window.qcLoad = function(keep){
    post('<c:url value="/qps/qcodeList.do"/>', {}).then(function(res){
      GROUPS = res.groups || []; ROWS = res.rows || [];
      qcPaintGroups();
      if (keep && CUR) qcPick(CUR); else if (!CUR && GROUPS.length) qcPick(GROUPS[0].codecd);
    }).catch(function(e){ gel('qcGroups').innerHTML = '<div class="qc-empty">' + esc(e.message || '불러오지 못했습니다.') + '</div>'; });
  };
  window.qcPaintGroups = function(){
    var q = String(gel('qcFind').value || '').trim().toLowerCase(), h = '', n = 0;
    GROUPS.forEach(function(g){
      var hit = !q || String(g.codecd).toLowerCase().indexOf(q) >= 0 || String(g.codenm || '').toLowerCase().indexOf(q) >= 0 ||
                ROWS.some(function(r){ return r.codecd === g.codecd && (String(r.subcode).toLowerCase().indexOf(q) >= 0 || String(r.subcodenm || '').toLowerCase().indexOf(q) >= 0); });
      if (!hit) return; n++;
      h += '<div class="qc-grp' + (g.codecd === CUR ? ' on' : '') + '" onclick="qcPick(\'' + esc(g.codecd) + '\');">' +
           '<span class="nm' + (g.codenm ? '' : ' none') + '">' + (g.codenm ? esc(g.codenm) : '(이름 없음)') + '<br><span class="cd">' + esc(g.codecd) + '</span></span>' +
           '<span class="n">' + g.cnt + ' / ' + g.total + '</span></div>';
    });
    gel('qcGroups').innerHTML = h || '<div class="qc-empty">맞는 묶음이 없습니다.</div>';
    gel('qcGrpCnt').textContent = n + '개';
  };
  window.qcPick = function(cd){
    CUR = cd; qcPaintGroups();
    var g = GROUPS.filter(function(x){ return x.codecd === cd; })[0] || {};
    gel('qcTitle').textContent = g.codenm || '(이름 없음)';
    gel('qcCode').textContent = cd;
    gel('qcGrpNm').value = g.codenm || '';
    gel('qcGrpEdit').style.display = WNN ? '' : 'none';
    gel('qcRowBtns').style.display = WNN ? '' : 'none';
    var rows = ROWS.filter(function(r){ return r.codecd === cd; }), h = '';
    rows.forEach(function(r){ h += rowHtml(r, false); });
    gel('qcBody').innerHTML = h || '<tr><td colspan="5" class="qc-empty">이 묶음에 코드가 없습니다.</td></tr>';
  };
  function rowHtml(r, isNew){
    var off = r.useyn === 'N', dis = WNN ? '' : ' disabled';
    return '<tr class="' + (off ? 'off' : '') + (isNew ? ' new' : '') + '" data-sub="' + esc(r.subcode) + '">' +
      '<td>' + (isNew ? '<input type="text" data-f="subcode" maxlength="50" placeholder="코드값(영문·숫자)" style="width:130px;font-family:Consolas,monospace;">'
                      : '<span class="qc-cd">' + esc(r.subcode) + '</span>') + '</td>' +
      '<td><input type="text" data-f="subcodenm" value="' + esc(r.subcodenm) + '" maxlength="100"' + dis + ' oninput="qcDirty(this);"></td>' +
      '<td><input type="text" class="num" data-f="sort" value="' + esc(r.sort) + '"' + dis + ' oninput="qcDirty(this);"></td>' +
      '<td style="text-align:center;"><input type="checkbox" data-f="useyn"' + (off ? '' : ' checked') + dis + ' onchange="qcDirty(this);"></td>' +
      '<td>' + (WNN ? '<button type="button" class="qc-btn" onclick="qcSaveRow(this);">저장</button>' : '') + '</td></tr>';
  }
  window.qcDirty = function(el){ var tr = el.closest('tr'); tr.classList.add('dirty'); tr.classList.toggle('off', !tr.querySelector('[data-f="useyn"]').checked); };
  window.qcAddRow = function(){
    var body = gel('qcBody'); if (body.querySelector('.qc-empty')) body.innerHTML = '';
    var tr = document.createElement('tbody'); tr.innerHTML = rowHtml({ subcode:'', subcodenm:'', sort: 99, useyn:'Y' }, true);
    body.appendChild(tr.firstElementChild); body.lastElementChild.classList.add('dirty');
    body.lastElementChild.querySelector('[data-f="subcode"]').focus();
  };
  function readRow(tr){
    var sub = tr.querySelector('[data-f="subcode"]');
    return { codeCd: CUR, subCode: sub ? String(sub.value).trim() : tr.getAttribute('data-sub'),
             subCodeNm: String(tr.querySelector('[data-f="subcodenm"]').value).trim(),
             sort: String(tr.querySelector('[data-f="sort"]').value).trim() || '99',
             useYn: tr.querySelector('[data-f="useyn"]').checked ? 'Y' : 'N' };
  }
  function saveRows(trs){
    var list = trs.map(readRow), bad = list.filter(function(r){ return !r.subCode || !r.subCodeNm; });
    if (bad.length) { _alertBox('코드값과 이름을 모두 적어 주세요.', {icon:'⚠️'}); return; }
    var i = 0, n = 0;
    (function next(){
      if (i >= list.length) { _toast(n + '건 저장했습니다.', 'ok'); qcLoad(true); return; }
      post('<c:url value="/qps/qcodeSave.do"/>', list[i++]).then(function(){ n++; next(); }).catch(function(e){ err(e); qcLoad(true); });
    })();
  }
  window.qcSaveRow = function(btn){ saveRows([btn.closest('tr')]); };
  window.qcSaveAll = function(){
    var trs = [].slice.call(gel('qcBody').querySelectorAll('tr.dirty'));
    if (!trs.length) { _toast('고친 것이 없습니다.', 'ok'); return; }
    saveRows(trs);
  };
  window.qcGrpSave = function(){
    var nm = String(gel('qcGrpNm').value || '').trim();
    if (!nm) { _alertBox('묶음 이름을 적어 주세요.', {icon:'⚠️'}); return; }
    post('<c:url value="/qps/qcodeGrpSave.do"/>', { codeCd: CUR, codeNm: nm }).then(function(){ _toast('묶음 이름을 저장했습니다.', 'ok'); qcLoad(true); }).catch(err);
  };
  $(function(){ qcLoad(false); });
})();
</script>
</div><%-- /#qpsCode --%>
</div><%-- /.dashboard-wrapper --%>
