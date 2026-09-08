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
  <%-- ★화면 안 일괄 출력 (2026-09-08 — 확장 3호) : 저장된 달만 골라 한 번에 이어 인쇄. 아래 #cdBulkPrintBox 에 펼친다. --%>
  <button type="button" class="cd-btn ghost" onclick="cdBulkPrintToggle();" title="저장된 월별 기록지를 월 범위로 골라 한 번에 인쇄합니다">🖨 일괄 출력</button>
  <span class="cd-sub" id="cdStat"></span>
  <span style="flex:0 0 12px;"></span>
  <%-- 글자 크기 — 이 PC 이 브라우저에만 저장된다 --%>
  <span class="zz-zoom">
    <button type="button" onclick="zzZoom(-1);" title="글자 작게">가－</button>
    <button type="button" onclick="zzZoom(1);"  title="글자 크게">가＋</button>
    <button type="button" onclick="zzZoom(0);"  title="처음 크기로">↺</button>
  </span>
</div>

<%-- 🖨 화면 안 일괄 출력 조건 띠 (2026-09-08) — 월별 기록지는 「월 1부」 문서라 조건은 연도 · 월 범위뿐. 저장된 달만 담는다. --%>
<div id="cdBulkPrintBox" style="display:none; margin:6px 0 4px; padding:8px 12px; border:1px solid #b9cfe6; border-radius:8px; background:#eef4fb; font-size:12.5px; color:#1f2a37;">
  <div style="display:flex; align-items:center; gap:10px; flex-wrap:wrap;">
    <b style="color:#2f6fb0;">🖨 일괄 출력</b>
    <span>기간</span>
    <select id="cdBpYear" style="width:auto;"></select>
    <select id="cdBpFrom" style="width:auto;"></select><span>~</span><select id="cdBpTo" style="width:auto;"></select>
    <button type="button" class="cd-btn" id="cdBpGo" style="margin-left:auto;" onclick="cdBulkPrintGo();">출력</button>
    <button type="button" class="cd-btn ghost" onclick="cdBulkPrintToggle();">닫기</button>
  </div>
  <div style="margin-top:5px; font-size:11.5px; color:#5a6b7a;">저장된 달의 기록지만 한 장씩 이어 붙여 한 번에 인쇄합니다(자료를 만들지 않음). 한 번에 120장까지. <span id="cdBpStat" style="color:#2f6fb0; font-weight:700;"></span></div>
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
  var LAST_DOC = false;   // 지금 보이는 달에 저장된 기록지가 있는가 — 일괄 출력이 빈 달을 거른다(2026-09-08)

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

  var LOAD_REQ = 0;   // 조회 순번 — 늦게 온 옛 응답이 새 목록·문서를 덮지 않게(2026-09-08, 일괄 출력에서 실제로 겪음)
  window.cdLoad = function(){
    var my = ++LOAD_REQ;
    if (ym().length !== 6) return;
    LAST_DOC = false;   // ★먼저 내린다 — 조회가 실패하면(err 가 삼켜 resolve 로 온다) 앞 달의 값이 남아 잘못 찍힌다
    // ★프라미스를 돌려준다(2026-09-08) — 일괄 출력이 「열림 → 인쇄」 를 차례로 잇는 데 쓴다
    return post('/qps/cathDayGet.do', { cathYm: ym() }).then(function(res){
      if (my !== LOAD_REQ) return;   // 더 새 조회가 나갔다 — 옛 응답은 버린다(2026-09-08)
      LAST_DOC = !!res.doc;
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

  /* ═══ 🖨 화면 안 일괄 출력 (2026-09-08 — 확장 3호 · 월 문서형) ═══
     월별 기록지는 「월 1부」라 목록이 없다. 달을 하나씩 열어(cdLoad) **저장된 달만**(LAST_DOC) 낱장 인쇄(cdPrint)를
     QPS_BULK_CB 로 모아 끝에 qpsPrintMerge(sidebar.jsp)로 한 문서. 빈 달은 날짜 줄만 깔려 있어 그대로 찍으면 빈 표가 섞인다.
     ★자료를 만들지 않는다. 끝나면 보던 달로 되돌린다. 상한 120장. */
  window.BP = { busy:false };
  function bpFill(){
    var ys = gel('cdBpYear');
    if (!ys.options.length) { var y = new Date().getFullYear(); for (var i = y + 1; i >= y - 4; i--) ys.add(new Option(i + '년', i)); }
    var mf = gel('cdBpFrom'), mt = gel('cdBpTo');
    if (mf.options.length) return;
    for (var m = 1; m <= 12; m++) { var v = (m < 10 ? '0' : '') + m; mf.add(new Option(m + '월', v)); mt.add(new Option(m + '월', v)); }
  }
  window.cdBulkPrintToggle = function(){
    var box = gel('cdBulkPrintBox');
    if (box.style.display !== 'none') { box.style.display = 'none'; return; }
    bpFill();
    gel('cdBpYear').value = ym().substring(0, 4); gel('cdBpFrom').value = '01'; gel('cdBpTo').value = '12';
    gel('cdBpStat').textContent = '';
    box.style.display = '';
  };
  window.cdBulkPrintGo = function(){
    if (BP.busy) return;
    var yy = gel('cdBpYear').value, f = gel('cdBpFrom').value, t = gel('cdBpTo').value;
    if (f > t) { var x = f; f = t; t = x; gel('cdBpFrom').value = f; gel('cdBpTo').value = t; }
    var keepYm = gel('cdYm').value;
    var title = '유치도뇨관 월별기록지_' + yy + '년' + (f === '01' && t === '12' ? '' : ('_' + Number(f) + '~' + Number(t) + '월'));
    var months = [];
    for (var m = Number(f); m <= Number(t); m++) months.push((m < 10 ? '0' : '') + m);
    var parts = [], MAX = 120, done = 0, stat = gel('cdBpStat'), mi = 0;
    BP.busy = true; gel('cdBpGo').disabled = true;
    window.QPS_BULK_CB = function(p){ parts.push(p); };
    var finish = function(){
      window.QPS_BULK_CB = null;
      gel('cdYm').value = keepYm;                        // 보던 달로
      Promise.resolve(cdLoad()).then(function(){
        BP.busy = false; gel('cdBpGo').disabled = false;
        if (!parts.length) { stat.textContent = '기간 안에 저장된 기록지가 없습니다.'; return; }
        var n = qpsPrintMerge(parts, title);
        stat.textContent = (n < 0) ? '팝업이 막혀 인쇄창을 열지 못했습니다.' :
                           (parts.length + '장을 이어 붙였습니다' + (done >= MAX ? ' (상한 ' + MAX + '장)' : '') + '.');
      }, function(){ BP.busy = false; gel('cdBpGo').disabled = false; });
    };
    var oneMonth = function(){
      if (mi >= months.length || done >= MAX) { finish(); return; }
      var mm = months[mi++];
      gel('cdYm').value = yy + '-' + mm;
      stat.textContent = yy + '년 ' + Number(mm) + '월 읽는 중 …';
      Promise.resolve(cdLoad()).then(function(){
        if (LAST_DOC) { try { cdPrint(); done++; } catch (e) { } }
        stat.textContent = yy + '년 ' + Number(mm) + '월 — ' + done + '장';
        oneMonth();
      }, function(){ oneMonth(); });
    };
    oneMonth();
  };

  window.cdPrint = function(){
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
              '@page{ size:A4 portrait; margin:12mm; }';   /* 여백을 정해 둔다 — 없으면 브라우저·프린터 기본값을 따라 자리가 달라진다(2026-09-07) */
    /* 인쇄는 공통 창구로 — 낱장·일괄이 같은 조립을 쓴다(2026-09-07) */
    qpsPrintOut('유치도뇨관 월별 기록지', css,
      '<h1>유치도뇨관 월별 기록지</h1>' +
      '<div style="text-align:center;margin-bottom:8px;">' + esc(gel('cdYm').value) + '</div>' +
      '<table><tr><th>날짜</th><th>입원환자수</th><th>재원환자수</th><th>재원환자중 유치도뇨관 보유 환자 수</th></tr>' +
      body +
      '<tr><th>Total</th><th>' + gel('cdTotIn').textContent + '</th><th>' + gel('cdTotStay').textContent +
        '</th><th>' + gel('cdTotCath').textContent + '</th></tr>' +
      '</table>');
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
