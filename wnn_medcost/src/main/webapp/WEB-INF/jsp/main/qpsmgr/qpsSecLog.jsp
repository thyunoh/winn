<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%-- qpsSecLog.jsp — 격리·강박 시행일지 (2026-08-18)

     원본 : SUNWOO 보고서 ▸ 정신 ▸ 격리강박 시행일지 (캡처 PS03)
     성격 : 병원 + 년월 1부. 결재란 4칸 + 행 표 + 하단 집계 3칸.

     ★★이 화면은 <지표의 원천>이다 — 저장하면 서버가 관찰형 집계(TBL_QPS_MONITOR)에
       ISOLATION(격리)·SECLUSION(강박) 두 지표를 함께 얹는다.
         분모 = 그 달 그 구분의 전체 건수 · 분자 = 지침준수 'Y' 건수
       ⇒ 지표분석보고서가 이 자료 없이는 빈 표만 나온다.

     ★하단 집계(격리/강박/합계)는 저장하지 않는다 — 화면에서 센다(계산값이다).
     ★소요시간도 담지 않는다 — 시작·종료로 계산한다.
       ⚠지표분석의 시간대 구간은 격리 13구간 / 강박 5구간으로 <서로 다르다>.

     ★주의: 이 파일 안에서 Deferred EL 표기(샵+중괄호) 금지 --%>

<script src="/asset/js/ui-message.js"></script>

<%-- ★.dashboard-wrapper 는 winn 공통 레이아웃 필수 — 빼면 왼쪽 264px 이 사이드바에 가려진다 --%>
<div class="dashboard-wrapper">
<div id="qpsSecLog" data-wnn="<c:out value='${wnnYn}'/>">
<style>
  #qpsSecLog{ background:#f4f6f8; color:#1f2a30; min-height:100%; padding:14px 16px 60px; max-width:100%; overflow-x:hidden; }
  #qpsSecLog *{ box-sizing:border-box; }
  #qpsSecLog .sl-head{ display:flex; align-items:center; gap:10px; margin-bottom:12px; flex-wrap:wrap; }
  #qpsSecLog .sl-title{ font-size:18px; font-weight:800; color:#20303a; display:flex; align-items:center; gap:8px; }
  #qpsSecLog .sl-dot{ width:10px; height:10px; border-radius:50%; background:linear-gradient(135deg,#1f5a4b,#2a7665); }
  #qpsSecLog .sl-sub{ font-size:12px; color:#6b7c86; }
  #qpsSecLog .sl-hosp{ background:#e7f3ee; color:#1f5a4b; font-size:12px; font-weight:800;
      border:1px solid #cfe3da; border-radius:14px; padding:3px 11px; }
  #qpsSecLog .sl-spacer{ flex:1; }
  #qpsSecLog select, #qpsSecLog input{
      border:1px solid #cfd8e0; border-radius:5px; padding:5px 7px; font-family:inherit; font-size:12.5px; background:#fff; }
  #qpsSecLog .sl-btn{ border:1px solid #1f5a4b; background:#1f5a4b; color:#fff; border-radius:6px;
      padding:6px 14px; font-size:13px; font-weight:600; cursor:pointer; white-space:nowrap; }
  #qpsSecLog .sl-btn.ghost{ background:#fff; color:#1f5a4b; }
  #qpsSecLog .sl-btn.mini{ padding:2px 9px; font-size:11.5px; border-color:#cfd8e0; color:#556570; background:#fff; }
  #qpsSecLog .sl-card{ background:#fff; border:1px solid #e3e9ed; border-radius:10px; padding:14px 16px; margin-bottom:12px; }
  #qpsSecLog .sl-card h4{ margin:0 0 10px; font-size:14px; font-weight:800; color:#1f5a4b; }
  #qpsSecLog .sl-card h4 .hint{ font-weight:500; font-size:12px; color:#8a99a3; }
  /* 열이 16칸이라 가로가 길다 — 표만 따로 스크롤한다(머리글은 sticky) */
  #qpsSecLog .sl-scroll{ overflow-x:auto; }
  #qpsSecLog table.ed{ border-collapse:collapse; font-size:12.5px; min-width:1500px; }
  #qpsSecLog table.ed th{ background:#f2f6f8; border:1px solid #dde5ea; padding:5px 6px; font-weight:700;
      color:#43555f; white-space:nowrap; position:sticky; top:0; z-index:1; }
  #qpsSecLog table.ed td{ border:1px solid #e6ecef; padding:3px; }
  #qpsSecLog table.ed input, #qpsSecLog table.ed select{ width:100%; border:none; background:transparent; padding:4px 5px; }
  #qpsSecLog table.ed input:focus, #qpsSecLog table.ed select:focus{ background:#f7fbf9; outline:1px solid #8fc3b2; }
  #qpsSecLog .rowdel{ color:#b23b3b; cursor:pointer; font-weight:700; text-align:center; width:26px; }
  #qpsSecLog tr.pick td{ background:#f0f7f4; }
  /* 하단 집계 — 원본의 격리/강박/합계 3칸 */
  #qpsSecLog .sl-sum{ display:flex; gap:10px; margin-top:10px; flex-wrap:wrap; }
  #qpsSecLog .sl-sum div{ background:#f7fbf9; border:1px solid #cfe3da; border-radius:8px; padding:8px 16px;
      font-size:13px; font-weight:800; color:#1f5a4b; }
  #qpsSecLog .sl-sum b{ font-size:16px; margin:0 4px; }
  /* ── 글자 크기 — QI 계획서(qpsQiPlan)와 같은 모양·같은 조작 */
  #qpsSecLog .zz-zoom{ display:inline-flex; gap:4px; align-items:center; margin-left:2px; margin-right:14px; }
  #qpsSecLog .zz-zoom button{ border:1px solid #cfd9e0; background:#fff; color:#43555f; border-radius:6px;
                           padding:4px 9px; font-size:13px; font-weight:700; cursor:pointer; }
  #qpsSecLog .zz-zoom button:hover{ background:#eef3f6; }
</style>

<div class="sl-head">
  <div class="sl-title"><span class="sl-dot"></span>격리 · 강박 시행일지 <span class="sl-sub">월 1부</span></div>
  <span class="sl-hosp">🏥 <c:out value="${hospNm}" default="병원 미확인"/></span>
  <div class="sl-spacer"></div>
  <input type="month" id="slYm" style="width:auto;" onchange="slLoad();">
  <button type="button" class="sl-btn" onclick="slSave();">저장</button>
  <button type="button" class="sl-btn ghost" onclick="slPrint();">🖨 인쇄(A4)</button>
  <span class="sl-sub" id="slStat"></span>
  <span style="flex:0 0 12px;"></span>
  <%-- 글자 크기 — 이 PC 이 브라우저에만 저장된다 --%>
  <span class="zz-zoom">
    <button type="button" onclick="zzZoom(-1);" title="글자 작게">가－</button>
    <button type="button" onclick="zzZoom(1);"  title="글자 크게">가＋</button>
    <button type="button" onclick="zzZoom(0);"  title="처음 크기로">↺</button>
  </span>
</div>

<div class="sl-card">
  <h4>시행 내역
    <span class="hint">— 지침준수 <b>Y</b> 가 지표(격리·강박 준수율)의 분자입니다. 저장하면 그 달 집계가 함께 갱신됩니다</span></h4>
  <div class="sl-scroll">
    <table class="ed"><thead><tr>
      <th style="width:44px;">번호</th><th style="width:110px;">시행일자</th><th style="width:80px;">구분</th>
      <th style="width:90px;">지시자</th><th style="width:90px;">작성자</th>
      <th style="width:110px;">등록번호</th><th style="width:90px;">환자성명</th>
      <th style="width:90px;">성인구분</th><th style="width:90px;">보험구분</th>
      <th style="width:120px;">주치의/해제지시자</th><th style="width:150px;">참여자</th>
      <th style="width:110px;">시작일</th><th style="width:80px;">시작시간</th>
      <th style="width:110px;">종료일</th><th style="width:80px;">종료시간</th>
      <th style="width:80px;">지침준수</th><th style="width:26px;"></th>
    </tr></thead><tbody id="slBody"></tbody></table>
  </div>
  <div style="margin-top:6px; display:flex; gap:6px; flex-wrap:wrap;">
    <button type="button" class="sl-btn mini" onclick="slAdd();">＋ 행 추가</button>
    <button type="button" class="sl-btn mini" onclick="slCopyLast();">⧉ 다음행으로 복사</button>
    <span class="sl-sub" style="align-self:center;">행을 누르면 골라집니다 — 복사는 마지막으로 고른 행을 씁니다.</span>
  </div>

  <div class="sl-sum">
    <div>격리 <b id="slCntI">0</b> 건</div>
    <div>강박 <b id="slCntR">0</b> 건</div>
    <div>합계 <b id="slCntT">0</b> 건</div>
    <div style="background:#eef3f6; border-color:#cfd9e0; color:#43555f;">지침준수 <b id="slCntG">0</b> 건</div>
  </div>
</div>

<script>
(function(){
  var GB = [['','-'],['ISOL','격리'],['RSTR','강박']];
  var ADULT = [['','-'],['ADULT','19세이상'],['MINOR','19세미만']];
  var YN = [['','-'],['Y','Y'],['N','N']];
  var _pick = null;

  function gel(id){ return document.getElementById(id); }   // ★$ 로 짓지 말 것
  // ★dataType:'json' 필수 — 빠뜨리면 응답이 문자열로 와서 오류 없이 조용히 0건이 된다
  function post(url, data){
    return $.ajax({ url:url, type:'POST', data:data, dataType:'json' }).then(function(res){
      if (res && res.result === 'FAIL') { throw new Error(res.message || '처리에 실패했습니다.'); }
      return res;
    });
  }
  function err(e){ _alertBox((e && e.message) ? e.message : '처리 중 오류가 발생했습니다.', {icon:'❌'}); }
  function esc(s){ return (s==null?'':String(s)).replace(/[&<>"]/g, function(c){
      return ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;'})[c]; }); }
  function opts(list, v){
    return list.map(function(o){
      return '<option value="' + o[0] + '"' + (String(v||'')===o[0] ? ' selected' : '') + '>' + o[1] + '</option>';
    }).join('');
  }

  (function(){
    var d = new Date();
    gel('slYm').value = d.getFullYear() + '-' + ('0' + (d.getMonth() + 1)).slice(-2);
  })();
  function ym(){ return gel('slYm').value.replace('-', ''); }

  function row(r){
    r = r || {};
    var tr = document.createElement('tr');
    tr.innerHTML =
      '<td style="text-align:center; color:#8a99a3;" data-f="no"></td>' +
      '<td><input type="date" data-f="execdt" value="' + esc(r.execdt) + '"></td>' +
      '<td><select data-f="secgb">' + opts(GB, r.secgb) + '</select></td>' +
      '<td><input data-f="ordernm" value="' + esc(r.ordernm) + '"></td>' +
      '<td><input data-f="writernm" value="' + esc(r.writernm) + '"></td>' +
      '<td><input data-f="patno" value="' + esc(r.patno) + '"></td>' +
      '<td><input data-f="patnm" value="' + esc(r.patnm) + '"></td>' +
      '<td><select data-f="adultgb">' + opts(ADULT, r.adultgb) + '</select></td>' +
      '<td><input data-f="insurgb" value="' + esc(r.insurgb) + '"></td>' +
      '<td><input data-f="relorder" value="' + esc(r.relorder) + '"></td>' +
      '<td><input data-f="joinnm" value="' + esc(r.joinnm) + '"></td>' +
      '<td><input type="date" data-f="stdt" value="' + esc(r.stdt) + '"></td>' +
      '<td><input type="time" data-f="sttm" value="' + esc(r.sttm) + '"></td>' +
      '<td><input type="date" data-f="eddt" value="' + esc(r.eddt) + '"></td>' +
      '<td><input type="time" data-f="edtm" value="' + esc(r.edtm) + '"></td>' +
      '<td><select data-f="guideyn">' + opts(YN, r.guideyn) + '</select></td>' +
      '<td class="rowdel" title="이 줄 지우기">✕</td>';
    gel('slBody').appendChild(tr);
    return tr;
  }

  function readRow(tr){
    var o = {};
    tr.querySelectorAll('[data-f]').forEach(function(el){
      if (el.tagName === 'TD') return;
      o[el.getAttribute('data-f')] = String(el.value).trim();
    });
    return o;
  }

  /** 번호 다시 매기기 + 하단 집계 — ★집계는 저장하지 않는다(계산값) */
  function paint(){
    var rows = gel('slBody').rows, i = 0, ci = 0, cr = 0, cg = 0;
    Array.prototype.forEach.call(rows, function(tr){
      tr.cells[0].textContent = (++i);
      var o = readRow(tr);
      if (o.secgb === 'ISOL') ci++;
      else if (o.secgb === 'RSTR') cr++;
      if (o.guideyn === 'Y') cg++;
    });
    gel('slCntI').textContent = ci;
    gel('slCntR').textContent = cr;
    gel('slCntT').textContent = ci + cr;
    gel('slCntG').textContent = cg;
  }

  window.slAdd = function(){ var tr = row({}); paint(); tr.querySelector('[data-f="execdt"]').focus(); };

  /** 다음행으로 복사 — 고른 행(없으면 마지막 행)을 그대로 한 줄 더 만든다.
      ★같은 환자에게 이어서 시행하는 일이 잦아 원본에도 있는 기능이다. */
  window.slCopyLast = function(){
    var rows = gel('slBody').rows;
    if (!rows.length) { _alertBox('복사할 줄이 없습니다.', {icon:'⚠'}); return; }
    var src = _pick || rows[rows.length - 1];
    row(readRow(src));
    paint();
  };

  // 행 클릭 = 고르기 · ✕ = 지우기 (위임 — 표를 다시 그려도 다시 걸 필요가 없다)
  gel('slBody').addEventListener('click', function(ev){
    var td = ev.target.closest ? ev.target.closest('td') : null;
    if (!td) return;
    var tr = td.parentNode;
    if (td.classList.contains('rowdel')) { tr.remove(); if (_pick === tr) _pick = null; paint(); return; }
    Array.prototype.forEach.call(gel('slBody').rows, function(r){ r.classList.remove('pick'); });
    tr.classList.add('pick'); _pick = tr;
  });
  gel('slBody').addEventListener('change', paint);

  window.slLoad = function(){
    if (ym().length !== 6) return;
    post('/qps/secLogGet.do', { logYm: ym() }).then(function(res){
      gel('slBody').innerHTML = '';
      (res.items || []).forEach(function(r){ row(r); });
      if (!(res.items || []).length) { row({}); row({}); row({}); }   // 빈 달은 세 줄 깔아 준다
      _pick = null;
      paint();
      gel('slStat').textContent = (res.doc ? '' : '— 새 문서');
    }).catch(err);
  };

  window.slSave = function(){
    if (ym().length !== 6) { _alertBox('년월을 고르세요.', {icon:'⚠'}); return; }
    var items = [], sort = 0, bad = 0;
    Array.prototype.forEach.call(gel('slBody').rows, function(tr){
      var o = readRow(tr);
      // 빈 줄은 보내지 않는다 — 행 추가만 하고 안 채운 줄이 저장되면 지표 분모가 부풀어 오른다
      if (!o.execdt && !o.secgb && !o.patno && !o.patnm) return;
      if (!o.secgb) bad++;
      o.sort = ++sort;
      items.push(o);
    });
    if (bad) {
      _alertBox('구분(격리/강박)이 빈 줄이 ' + bad + '개 있습니다.\n★구분이 없으면 어느 지표에도 잡히지 않습니다.', {icon:'⚠'});
      return;
    }
    post('/qps/secLogSave.do', { logYm: ym(), items: JSON.stringify(items) }).then(function(){
      _alertBox('저장했습니다.\n격리·강박 준수율 지표의 그 달 집계도 함께 갱신됐습니다.', {icon:'✅'});
      slLoad();
    }).catch(err);
  };

  window.slPrint = function(){
    var w = window.open('', '_blank');
    if (!w) { _alertBox('팝업이 막혀 있습니다.', {icon:'⚠'}); return; }
    var head = '<tr><th>번호</th><th>시행일자</th><th>구분</th><th>지시자</th><th>작성자</th><th>등록번호</th>' +
               '<th>환자성명</th><th>성인구분</th><th>보험구분</th><th>주치의/해제지시자</th><th>참여자</th>' +
               '<th>시작</th><th>종료</th><th>지침준수</th></tr>';
    var body = '', n = 0;
    Array.prototype.forEach.call(gel('slBody').rows, function(tr){
      var o = readRow(tr);
      if (!o.execdt && !o.secgb && !o.patno && !o.patnm) return;
      var gbNm = (o.secgb === 'ISOL') ? '격리' : (o.secgb === 'RSTR') ? '강박' : '';
      var adNm = (o.adultgb === 'ADULT') ? '19세이상' : (o.adultgb === 'MINOR') ? '19세미만' : '';
      body += '<tr><td>' + (++n) + '</td><td>' + esc(o.execdt) + '</td><td>' + gbNm + '</td>' +
              '<td>' + esc(o.ordernm) + '</td><td>' + esc(o.writernm) + '</td><td>' + esc(o.patno) + '</td>' +
              '<td>' + esc(o.patnm) + '</td><td>' + adNm + '</td><td>' + esc(o.insurgb) + '</td>' +
              '<td>' + esc(o.relorder) + '</td><td>' + esc(o.joinnm) + '</td>' +
              '<td>' + esc(o.stdt) + ' ' + esc(o.sttm) + '</td><td>' + esc(o.eddt) + ' ' + esc(o.edtm) + '</td>' +
              '<td>' + esc(o.guideyn) + '</td></tr>';
    });
    var css = 'body{font-family:"맑은 고딕",sans-serif;font-size:11px;margin:12mm;}' +
              'h1{font-size:16px;text-align:center;margin:0 0 10px;}' +
              'table{width:100%;border-collapse:collapse;}' +
              'th,td{border:1px solid #333;padding:3px 4px;text-align:center;}' +
              'th{background:#eee;}' +
              '.appr{float:right;border-collapse:collapse;margin-bottom:8px;}' +
              '.appr th,.appr td{width:60px;height:34px;}' +
              '@page{size:A4 landscape;}';
    w.document.write('<html><head><meta charset="UTF-8"><title>격리·강박 시행일지</title>' +
      '<style>' + css + '</style></head><body>' +
      '<table class="appr"><tr><th>담당</th><th>팀장</th><th>부서장</th><th>이사장</th></tr>' +
      '<tr><td></td><td></td><td></td><td></td></tr></table>' +
      '<h1>격리 / 강박 시행일지</h1>' +
      '<div style="clear:both;margin-bottom:6px;">' + esc(gel('slYm').value) + '</div>' +
      '<table>' + head + body + '</table>' +
      '<div style="margin-top:8px;">격리 ' + gel('slCntI').textContent + ' 건 · 강박 ' +
        gel('slCntR').textContent + ' 건 · 합계 ' + gel('slCntT').textContent + ' 건</div>' +
      '</body></html>');
    w.document.close();
    w.focus();
    setTimeout(function(){ try { w.print(); } catch (e) { } }, 300);
  };

  $(function(){ slLoad(); });
})();

/* ═══ 글자 크기 (2026-08-18) ═══════════════════════════════════════════════
   QI 계획서(qpsQiPlan)의 zzZoom 과 같은 규칙 — 0.8~1.6배, 0.1 단위, ↺ 는 처음 크기.
   ⚠같은 화면이 두 벌 붙어 있을 수 있다(주소 숨김 구조) — querySelectorAll 로 전부에 건다. */
(function(){
  var W = 'qpsSecLog', ZKEY = 'qpsZoom_' + W;
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
</div><%-- /#qpsSecLog --%>
</div><%-- /.dashboard-wrapper --%>
