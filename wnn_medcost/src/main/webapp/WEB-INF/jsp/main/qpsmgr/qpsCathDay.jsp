<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%-- qpsCathDay.jsp — 유치도뇨관 월별 기록지 (2026-08-18)

     원본 : SUNWOO 감염 ▸ 요로감염 ▸ 유치도뇨관기구 ▸ 유치도뇨관 월별 기록지 (캡처 UT05)
     성격 : 병원 + 년월 1부. 날짜 1~31 행 × 입원환자수 · 재원환자수 · 유치도뇨관 보유 환자 수.

     ★★이 화면은 <지표 UTI 의 분모>다 — 저장하면 서버가
       TBL_QPS_CENSUS(CENSUS_GB='CATHDAYS')의 그 달 칸에 유치도뇨관 보유 수의 합을 넣는다.
       이것이 요로감염 발생률의 분모(유치도뇨관 일수 · device-day)다.

     ⚠지금 지표 마스터의 UTI 분모는 아직 'INDAYS'(총재원일수)다.
       바꾸는 UPDATE 는 QPS_DDL_SECLOG_CATH_2026-08-18.sql 에 <주석으로> 넣어 뒀다 —
       분모를 바꾸면 이미 산출된 값이 달라지므로 병원 확인 후 실행할 것.

     ★Total 행은 저장하지 않는다 — 합계는 화면에서 센다.
     ★주의: 이 파일 안에서 Deferred EL 표기(샵+중괄호) 금지 --%>

<script src="/asset/js/ui-message.js"></script>

<%-- ★.dashboard-wrapper 는 winn 공통 레이아웃 필수 --%>
<div class="dashboard-wrapper">
<div id="qpsCathDay" data-wnn="<c:out value='${wnnYn}'/>">
<style>
  #qpsCathDay{ background:#f4f6f8; color:#1f2a30; min-height:100%; padding:14px 16px 60px; max-width:100%; overflow-x:hidden; }
  #qpsCathDay *{ box-sizing:border-box; }
  #qpsCathDay .cd-head{ display:flex; align-items:center; gap:10px; margin-bottom:12px; flex-wrap:wrap; }
  #qpsCathDay .cd-title{ font-size:18px; font-weight:800; color:#20303a; display:flex; align-items:center; gap:8px; }
  #qpsCathDay .cd-dot{ width:10px; height:10px; border-radius:50%; background:linear-gradient(135deg,#1f5a4b,#2a7665); }
  #qpsCathDay .cd-sub{ font-size:12px; color:#6b7c86; }
  #qpsCathDay .cd-hosp{ background:#e7f3ee; color:#1f5a4b; font-size:12px; font-weight:800;
      border:1px solid #cfe3da; border-radius:14px; padding:3px 11px; }
  #qpsCathDay .cd-spacer{ flex:1; }
  #qpsCathDay select, #qpsCathDay input{
      border:1px solid #cfd8e0; border-radius:5px; padding:5px 7px; font-family:inherit; font-size:12.5px; background:#fff; }
  #qpsCathDay .cd-btn{ border:1px solid #1f5a4b; background:#1f5a4b; color:#fff; border-radius:6px;
      padding:6px 14px; font-size:13px; font-weight:600; cursor:pointer; white-space:nowrap; }
  #qpsCathDay .cd-btn.ghost{ background:#fff; color:#1f5a4b; }
  #qpsCathDay .cd-card{ background:#fff; border:1px solid #e3e9ed; border-radius:10px; padding:14px 16px;
      margin-bottom:12px; max-width:840px; }
  #qpsCathDay .cd-card h4{ margin:0 0 10px; font-size:14px; font-weight:800; color:#1f5a4b; }
  #qpsCathDay .cd-card h4 .hint{ font-weight:500; font-size:12px; color:#8a99a3; }
  #qpsCathDay table.ed{ width:100%; border-collapse:collapse; font-size:12.5px; }
  #qpsCathDay table.ed th{ background:#f2f6f8; border:1px solid #dde5ea; padding:6px; font-weight:700; color:#43555f; }
  #qpsCathDay table.ed td{ border:1px solid #e6ecef; padding:3px; }
  #qpsCathDay table.ed td.day{ text-align:center; font-weight:700; color:#43555f; background:#fafcfd; width:64px; }
  /* 원본이 주말을 색으로 구분한다 — 토(파랑)·일(빨강) */
  #qpsCathDay table.ed td.day.sat{ color:#1f5aa8; }
  #qpsCathDay table.ed td.day.sun{ color:#b23b3b; }
  #qpsCathDay table.ed input{ width:100%; border:none; background:transparent; padding:4px 5px; text-align:right; }
  #qpsCathDay table.ed input:focus{ background:#f7fbf9; outline:1px solid #8fc3b2; }
  #qpsCathDay table.ed tfoot td{ background:#f7fbf9; font-weight:800; text-align:right; color:#1f5a4b; }
  #qpsCathDay .cd-note{ background:#f0f7f4; border:1px solid #cfe3da; border-radius:8px; padding:9px 12px;
      font-size:12.5px; color:#1f5a4b; line-height:1.6; margin-bottom:12px; max-width:840px; }
  /* ── 글자 크기 */
  #qpsCathDay .zz-zoom{ display:inline-flex; gap:4px; align-items:center; margin-left:2px; margin-right:14px; }
  #qpsCathDay .zz-zoom button{ border:1px solid #cfd9e0; background:#fff; color:#43555f; border-radius:6px;
                            padding:4px 9px; font-size:13px; font-weight:700; cursor:pointer; }
  #qpsCathDay .zz-zoom button:hover{ background:#eef3f6; }
</style>

<div class="cd-head">
  <div class="cd-title"><span class="cd-dot"></span>유치도뇨관 월별 기록지 <span class="cd-sub">월 1부</span></div>
  <span class="cd-hosp">🏥 <c:out value="${hospNm}" default="병원 미확인"/></span>
  <div class="cd-spacer"></div>
  <input type="month" id="cdYm" style="width:auto;" onchange="cdLoad();">
  <button type="button" class="cd-btn" onclick="cdSave();">저장</button>
  <button type="button" class="cd-btn ghost" onclick="cdPrint();">🖨 인쇄(A4)</button>
  <span class="cd-sub" id="cdStat"></span>
  <span style="flex:0 0 12px;"></span>
  <%-- 글자 크기 — 이 PC 이 브라우저에만 저장된다 --%>
  <span class="zz-zoom">
    <button type="button" onclick="zzZoom(-1);" title="글자 작게">가－</button>
    <button type="button" onclick="zzZoom(1);"  title="글자 크게">가＋</button>
    <button type="button" onclick="zzZoom(0);"  title="처음 크기로">↺</button>
  </span>
</div>

<div class="cd-note">
  <b>이 표가 요로감염 지표의 분모입니다.</b> 「재원환자중 유치도뇨관 보유 환자 수」의 한 달 합계가
  <b>유치도뇨관 일수(device-day)</b> 가 되어 저장할 때 지표 분모로 넘어갑니다.
</div>

<div class="cd-card">
  <h4>일자별 현황 <span class="hint">— 빈 칸은 0 으로 셉니다. 합계 줄은 자동입니다</span></h4>
  <table class="ed">
    <thead><tr>
      <th style="width:64px;">날짜</th><th>입원환자수</th><th>재원환자수</th>
      <th>재원환자중<br>유치도뇨관 보유 환자 수</th>
    </tr></thead>
    <tbody id="cdBody"></tbody>
    <tfoot><tr>
      <td class="day">Total</td>
      <td id="cdTotIn">0</td><td id="cdTotStay">0</td><td id="cdTotCath">0</td>
    </tr></tfoot>
  </table>
</div>

<script>
(function(){
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
  function n(v){ var x = parseInt(v, 10); return isNaN(x) ? 0 : x; }

  (function(){
    var d = new Date();
    gel('cdYm').value = d.getFullYear() + '-' + ('0' + (d.getMonth() + 1)).slice(-2);
  })();
  function ym(){ return gel('cdYm').value.replace('-', ''); }
  /** 그 달의 날 수 — 31일 고정이 아니다(2월·30일 달에 빈 줄이 생기면 안 된다) */
  function daysInMonth(){
    var y = parseInt(ym().substring(0, 4), 10), m = parseInt(ym().substring(4, 6), 10);
    return new Date(y, m, 0).getDate();
  }
  function dowOf(day){
    var y = parseInt(ym().substring(0, 4), 10), m = parseInt(ym().substring(4, 6), 10);
    return new Date(y, m - 1, day).getDay();   // 0=일 … 6=토
  }

  function build(map){
    var tb = gel('cdBody'), last = daysInMonth(), h = '';
    for (var d = 1; d <= last; d++) {
      var r = map[d] || {}, w = dowOf(d);
      var cls = 'day' + (w === 0 ? ' sun' : (w === 6 ? ' sat' : ''));
      h += '<tr>' +
           '<td class="' + cls + '">' + d + '</td>' +
           '<td><input type="number" min="0" data-d="' + d + '" data-f="incnt"   value="' + esc(r.incnt) + '"></td>' +
           '<td><input type="number" min="0" data-d="' + d + '" data-f="staycnt" value="' + esc(r.staycnt) + '"></td>' +
           '<td><input type="number" min="0" data-d="' + d + '" data-f="cathcnt" value="' + esc(r.cathcnt) + '"></td>' +
           '</tr>';
    }
    tb.innerHTML = h;
    paint();
  }

  /** 합계 — ★저장하지 않는다(계산값). 원본의 Total 줄이다. */
  function paint(){
    var ti = 0, ts = 0, tc = 0;
    gel('cdBody').querySelectorAll('input[data-f]').forEach(function(el){
      var v = n(el.value), f = el.getAttribute('data-f');
      if (f === 'incnt') ti += v; else if (f === 'staycnt') ts += v; else tc += v;
    });
    gel('cdTotIn').textContent   = ti.toLocaleString();
    gel('cdTotStay').textContent = ts.toLocaleString();
    gel('cdTotCath').textContent = tc.toLocaleString();
  }
  gel('cdBody').addEventListener('input', paint);

  window.cdLoad = function(){
    if (ym().length !== 6) return;
    post('/qps/cathDayGet.do', { cathYm: ym() }).then(function(res){
      var map = {};
      (res.items || []).forEach(function(r){ map[n(r.dayno)] = r; });
      build(map);
      gel('cdStat').textContent = (res.doc ? '' : '— 새 문서');
    }).catch(err);
  };

  window.cdSave = function(){
    if (ym().length !== 6) { _alertBox('년월을 고르세요.', {icon:'⚠'}); return; }
    var byDay = {};
    gel('cdBody').querySelectorAll('input[data-f]').forEach(function(el){
      var d = n(el.getAttribute('data-d'));
      if (!byDay[d]) byDay[d] = { dayno: d };
      var v = String(el.value).trim();
      byDay[d][el.getAttribute('data-f')] = (v === '') ? null : n(v);
    });
    var items = [];
    Object.keys(byDay).forEach(function(k){
      var o = byDay[k];
      // 세 칸이 다 비면 그 날은 보내지 않는다 — 빈 날까지 0 으로 저장할 이유가 없다
      if (o.incnt == null && o.staycnt == null && o.cathcnt == null) return;
      items.push(o);
    });
    post('/qps/cathDaySave.do', { cathYm: ym(), items: JSON.stringify(items) }).then(function(){
      _alertBox('저장했습니다.\n유치도뇨관 일수 ' + gel('cdTotCath').textContent +
                ' 일이 요로감염 지표의 분모로 넘어갔습니다.', {icon:'✅'});
      cdLoad();
    }).catch(err);
  };

  window.cdPrint = function(){
    var w = window.open('', '_blank');
    if (!w) { _alertBox('팝업이 막혀 있습니다.', {icon:'⚠'}); return; }
    var body = '';
    var last = daysInMonth();
    for (var d = 1; d <= last; d++) {
      var g = function(f){
        var el = gel('cdBody').querySelector('input[data-d="' + d + '"][data-f="' + f + '"]');
        return el ? esc(el.value) : '';
      };
      body += '<tr><td>' + d + '</td><td>' + g('incnt') + '</td><td>' + g('staycnt') + '</td><td>' + g('cathcnt') + '</td></tr>';
    }
    var css = 'body{font-family:"맑은 고딕",sans-serif;font-size:12px;margin:14mm;}' +
              'h1{font-size:17px;text-align:center;margin:0 0 12px;}' +
              'table{width:100%;border-collapse:collapse;}' +
              'th,td{border:1px solid #333;padding:3px 5px;text-align:center;}' +
              'th{background:#eee;}' +
              '@page{size:A4 portrait;}';
    w.document.write('<html><head><meta charset="UTF-8"><title>유치도뇨관 월별 기록지</title>' +
      '<style>' + css + '</style></head><body>' +
      '<h1>유치도뇨관 월별 기록지</h1>' +
      '<div style="text-align:center;margin-bottom:8px;">' + esc(gel('cdYm').value) + '</div>' +
      '<table><tr><th>날짜</th><th>입원환자수</th><th>재원환자수</th><th>재원환자중 유치도뇨관 보유 환자 수</th></tr>' +
      body +
      '<tr><th>Total</th><th>' + gel('cdTotIn').textContent + '</th><th>' + gel('cdTotStay').textContent +
        '</th><th>' + gel('cdTotCath').textContent + '</th></tr>' +
      '</table></body></html>');
    w.document.close();
    w.focus();
    setTimeout(function(){ try { w.print(); } catch (e) { } }, 300);
  };

  $(function(){ cdLoad(); });
})();

/* ═══ 글자 크기 (2026-08-18) ═══════════════════════════════════════════════ */
(function(){
  var W = 'qpsCathDay', ZKEY = 'qpsZoom_' + W;
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
</div><%-- /#qpsCathDay --%>
</div><%-- /.dashboard-wrapper --%>
