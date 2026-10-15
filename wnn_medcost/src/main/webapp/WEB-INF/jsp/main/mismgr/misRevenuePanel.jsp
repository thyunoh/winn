<%@ page pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%-- misRevenuePanel.jsp — 경영고객관리 › 경영 보고서 › 💰 수입일보 탭 (2026-10-15)
     · 수납대장(TBL_MIS_EMR_PAY) 을 날짜 · 입원외래 · 수납방법별로 집계한다.
       자료는 병원자료엑셀연계 › 수납대장 으로 올라오거나 데이터 연계로 들어온다(OCS 와 직접 연결은 없다).
     · 안쪽 탭 2개 : 📅 일별(한 달, 날짜마다) · 📊 월별(기간, 달마다).
     · 자료가 없으면 빈 칸 대신 안내를 보이고 엑셀연계 화면을 가리킨다.
     · misReport.jsp 가 정적 include 한다 — pageEncoding 만 둔다(없으면 include 될 때 ISO-8859-1 로 읽혀 한글이 깨진다). 태그 라이브러리는 부모 파일의 것을 쓴다.
     · ★ 이 파일 안에서 Deferred EL 표기(샵+중괄호) 금지 --%>
<div class="mr-panel" id="mrPanelRev" hidden>
<div id="misRev" data-wnn="<c:out value='${wnnYn}'/>" data-hosp="<c:out value='${hospCd}'/>" data-nm="<c:out value='${hospNm}'/>">
<style>
  #misRev{ background:#f4f6f8; color:#1f2a30; min-height:100%; padding:14px 0 50px; max-width:100%; overflow-x:hidden; }
  #misRev .rv-head{ display:flex; align-items:center; gap:8px; flex-wrap:wrap; background:#fff; border:1px solid #e3e9ed; border-radius:10px 10px 0 0; padding:10px 72px 10px 14px; font-size:13px; color:#43555f; }
  #misRev .rv-head input[type=month]{ border:1px solid #cfd8e0; border-radius:6px; padding:5px 8px; font-size:13px; background:#fff; font-family:inherit; }
  #misRev .rv-spacer{ flex:1; }
  #misRev .rv-subnote{ width:100%; font-size:12.5px; color:#43555f; line-height:1.6; margin-top:2px; }
  #misRev *{ box-sizing:border-box; }
  #misRev [hidden]{ display:none !important; }
  #misRev .rv-title{ font-size:18px; font-weight:800; color:#20303a; margin:6px 0 8px; }
  #misRev .rv-title small{ font-size:12px; color:#6b7c86; font-weight:400; margin-left:6px; }
  #misRev .rv-tabs{ display:flex; gap:4px; background:#e4eaef; padding:3px; border-radius:9px; width:max-content; max-width:100%; margin-bottom:10px; }
  #misRev .rv-tab{ border:0; background:transparent; color:#4a5b65; font-size:13px; font-weight:700; padding:6px 14px; border-radius:7px; cursor:pointer; white-space:nowrap; }
  #misRev .rv-tab:hover{ background:#f1f5f7; }
  #misRev .rv-tab.on{ background:#fff; color:#1f5a4b; box-shadow:0 1px 3px rgba(0,0,0,.12); }
  #misRev .rv-ctl{ display:flex; align-items:center; gap:8px; flex-wrap:wrap; background:#fff; border:1px solid #e3e9ed; border-radius:10px; padding:9px 72px 9px 12px; margin-bottom:12px; font-size:13px; color:#43555f; }
  #misRev .rv-ctl input[type=month]{ border:1px solid #cfd8e0; border-radius:6px; padding:5px 8px; font-size:13px; background:#fff; font-family:inherit; }
  #misRev .rv-btn{ border:1px solid #cfd9e0; background:#fff; color:#43555f; border-radius:6px; padding:5px 12px; font-size:12.5px; font-weight:700; cursor:pointer; white-space:nowrap; }
  #misRev .rv-btn:hover{ background:#eef3f6; }
  #misRev .rv-btn.pri{ background:#1f5a4b; color:#fff; border-color:#1f5a4b; }
  #misRev .rv-note{ font-size:12px; color:#6b7c86; }
  #misRev .rv-kpis{ display:grid; grid-template-columns:repeat(6,minmax(0,1fr)); gap:8px; margin-bottom:12px; }
  #misRev .rv-k{ background:#fff; border:1px solid #e3e9ed; border-radius:10px; padding:9px 11px; }
  #misRev .rv-k .l{ font-size:11.5px; color:#6b7c86; margin-bottom:3px; }
  #misRev .rv-k .v{ font-size:16px; font-weight:800; color:#20303a; font-variant-numeric:tabular-nums; white-space:nowrap; }
  #misRev .rv-k .s{ font-size:11px; color:#8a99a3; margin-top:2px; }
  #misRev .rv-card{ background:#fff; border:1px solid #e3e9ed; border-radius:10px; padding:12px 14px; margin-bottom:12px; }
  #misRev .rv-h{ font-size:14px; font-weight:800; color:#20303a; margin:0 0 8px; }
  #misRev .rv-tb{ width:100%; border-collapse:collapse; font-size:12.5px; }
  #misRev .rv-tb th{ background:#eef3f6; color:#333; font-weight:800; padding:6px 8px; border-bottom:1px solid #b9c6cf; text-align:left; white-space:nowrap; }
  #misRev .rv-tb td{ padding:6px 8px; border-bottom:1px solid #e6ecf0; white-space:nowrap; }
  #misRev .rv-tb td.n, #misRev .rv-tb th.n{ text-align:right; font-variant-numeric:tabular-nums; }
  #misRev .rv-tb tr.tot td{ font-weight:800; background:#f5f8fa; border-top:1px solid #9aa9b3; }
  #misRev .rv-tb tr.dim td{ color:#a4b0b8; }
  #misRev .rv-empty{ background:#fff; border:1px dashed #b9c6cf; border-radius:10px; padding:22px 18px; text-align:center; color:#43555f; font-size:13px; line-height:1.7; }
  #misRev .rv-empty b{ color:#20303a; }
  #misRev .rv-empty a{ color:#1f5a4b; font-weight:700; }
  @media (max-width:900px){ #misRev .rv-kpis{ grid-template-columns:repeat(3,minmax(0,1fr)); } }
</style>

  <div class="rv-head" id="rvCtl">
    <div class="rv-title">수입일보 <small>수납대장 기준 · 날짜별·월별 집계</small></div>
    <span class="rv-spacer"></span>
    <span>조회 기간</span>
    <input type="month" id="rvFrom"> <span>~</span> <input type="month" id="rvTo">
    <button type="button" class="rv-btn pri" id="rvGo">조회</button>
    <div class="rv-subnote">수납대장 자료 기준 · 최대 24개월 · 자료는 병원자료엑셀연계 › 수납대장 에서 올립니다</div>
  </div>
  <div class="rv-tabs" style="margin-top:14px;">
    <button type="button" class="rv-tab on" data-tab="day">📅 일별</button>
    <button type="button" class="rv-tab" data-tab="mon">📊 월별</button>
  </div>

  <!-- 📅 일별 : 달 하나를 골라 날짜마다 -->
  <div id="rvDay">
    <div class="rv-ctl">
      <span>달</span> <input type="month" id="rvDayYm">
      <span class="rv-note">고른 달이 조회 기간 밖이면 기간을 넓혀 다시 받는다</span>
    </div>
    <div class="rv-kpis" id="rvDayKpi"></div>
    <div class="rv-card" id="rvDayBody"></div>
  </div>

  <!-- 📊 월별 : 기간 안의 달마다 -->
  <div id="rvMon" hidden>
    <div class="rv-kpis" id="rvMonKpi"></div>
    <div class="rv-card" id="rvMonBody"></div>
  </div>
</div>
</div>

<script>
(function(){
  var root = document.getElementById('misRev');
  if (!root) return;
  var ROWS = [];          // 서버가 준 수납대장 행 (날짜·입원외래·수납방법별)
  var RANGE = null;       // 마지막으로 받은 기간 {from, to} (YYYYMM)
  var LOADED = false, STARTED = false;
  var LOAD_REQ = 0;       // 늦게 온 옛 응답이 새 목록을 덮지 않게 하는 순번
  var TAB = 'day';

  function $g(id){ return document.getElementById(id); }
  function esc(s){ return String(s == null ? '' : s).replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;'); }
  function num(v){ var n = Number(v); return isNaN(n) ? 0 : n; }
  function won(v){ return Math.round(num(v)).toLocaleString('ko-KR'); }
  function pct(a, b){ return b > 0 ? (a / b * 100).toFixed(1) + '%' : '—'; }
  function getCookie(n){ var m = document.cookie.match(new RegExp('(?:^|; )' + n + '=([^;]*)')); return m ? decodeURIComponent(m[1]) : ''; }
  function hosp(){ var h = ''; try { h = (getCookie('s_hospid') || '').trim(); } catch(e){} return h || root.getAttribute('data-hosp'); }

  /* 연월 도우미 — 내부는 YYYYMM 문자열(대소 비교가 그대로 맞는다), 입력칸은 YYYY-MM */
  function ymOfInput(v){ return String(v || '').replace(/[^0-9]/g, '').substr(0, 6); }
  function inputOfYm(ym){ return ym.substr(0, 4) + '-' + ym.substr(4, 2); }
  function addM(ym, n){
    var y = +ym.substr(0, 4), m = (+ym.substr(4, 2) - 1) + n;
    y += Math.floor(m / 12); m = ((m % 12) + 12) % 12;
    return y + ('0' + (m + 1)).slice(-2);
  }
  function monthsBetween(from, to){
    var out = [], cur = from, guard = 0;
    while (cur <= to && guard < 60) { out.push(cur); cur = addM(cur, 1); guard++; }
    return out;
  }
  function nowYm(){ var d = new Date(); return d.getFullYear() + ('0' + (d.getMonth() + 1)).slice(-2); }
  function fmtDay(d){ return d.substr(0, 4) + '-' + d.substr(4, 2) + '-' + d.substr(6, 2); }

  /* 집계 — 행 하나를 묶음 하나에 더한다 */
  function blank(){ return { cnt:0, ip:0, ipPaid:0, op:0, opPaid:0, tot:0, paid:0, unpaid:0, self:0, ins:0, nonpay:0 }; }
  function addRow(o, r){
    var c = num(r.cnt);
    o.cnt += c; o.tot += num(r.totamt); o.paid += num(r.paidamt); o.unpaid += num(r.unpaidamt);
    o.self += num(r.selfamt); o.ins += num(r.insamt); o.nonpay += num(r.nonpayamt);
    if (r.io === 'IP') { o.ip += c; o.ipPaid += num(r.paidamt); }
    else if (r.io === 'OP') { o.op += c; o.opPaid += num(r.paidamt); }
    return o;
  }

  function post(url, data){
    data.hospCd = hosp();
    return $.ajax({ url:url, type:'POST', data:data, dataType:'json' }).then(function(res){
      if (res && res.result === 'FAIL') throw new Error(res.message || '처리에 실패했습니다.');
      return res;
    });
  }

  function guide(){
    return '<div class="rv-empty"><b>수납대장 자료가 아직 없습니다.</b><br>' +
      '병원자료엑셀연계 › <b>수납대장</b> 에서 EMR 엑셀을 올리면 날짜·입원외래·수납방법별로 여기에 집계됩니다.<br>' +
      '<a href="/main/misEmr.do">병원자료엑셀연계 열기 →</a></div>';
  }

  function kpiHtml(o, label){
    function card(l, v, s){ return '<div class="rv-k"><div class="l">' + l + '</div><div class="v">' + v + '</div>' + (s ? '<div class="s">' + s + '</div>' : '') + '</div>'; }
    return card('건수', o.cnt.toLocaleString('ko-KR') + '건', esc(label)) +
      card('총진료비', won(o.tot) + '원', '') +
      card('수납액', won(o.paid) + '원', '') +
      card('미수액', won(o.unpaid) + '원', '') +
      card('수납률', pct(o.paid, o.tot), '수납 ÷ 총진료비') +
      card('입원 · 외래 수납', won(o.ipPaid) + ' · ' + won(o.opPaid), '입원 ' + o.ip + '건 · 외래 ' + o.op + '건');
  }

  /* ── 일별 ── */
  function dayMap(ym){
    var m = {};
    ROWS.forEach(function(r){
      var d = String(r.paydt || '');
      if (d.substr(0, 6) !== ym) return;
      m[d] = addRow(m[d] || blank(), r);
    });
    return m;
  }
  function pmTable(ym){
    var g = {}, total = 0;
    ROWS.forEach(function(r){
      if (String(r.paydt || '').substr(0, 6) !== ym) return;
      var k = String(r.pm || '기타');
      g[k] = addRow(g[k] || blank(), r);
    });
    var keys = Object.keys(g).sort(function(a, b){ return g[b].paid - g[a].paid; });
    keys.forEach(function(k){ total += g[k].paid; });
    var h = '<h3 class="rv-h">수납방법별 (' + esc(inputOfYm(ym)) + ')</h3>' +
      '<table class="rv-tb"><thead><tr><th>수납방법</th><th class="n">건수</th><th class="n">수납액</th><th class="n">비중</th></tr></thead><tbody>';
    keys.forEach(function(k){
      h += '<tr><td>' + esc(k) + '</td><td class="n">' + g[k].cnt.toLocaleString('ko-KR') + '</td><td class="n">' + won(g[k].paid) + '</td><td class="n">' + pct(g[k].paid, total) + '</td></tr>';
    });
    return h + '</tbody></table>';
  }
  function renderDay(){
    var ym = ymOfInput($g('rvDayYm').value) || (RANGE ? RANGE.to : nowYm());
    var m = dayMap(ym), days = Object.keys(m).sort(), sum = blank();
    days.forEach(function(d){
      var o = m[d];
      Object.keys(sum).forEach(function(k){ sum[k] += o[k]; });
    });
    $g('rvDayKpi').innerHTML = kpiHtml(sum, inputOfYm(ym));
    if (!ROWS.length) { $g('rvDayBody').innerHTML = guide(); return; }
    if (!days.length) { $g('rvDayBody').innerHTML = '<div class="rv-empty">' + esc(inputOfYm(ym)) + ' 에는 수납 자료가 없습니다. 다른 달을 고르세요.</div>'; return; }
    var h = '<h3 class="rv-h">날짜별 (' + esc(inputOfYm(ym)) + ')</h3>' +
      '<table class="rv-tb"><thead><tr><th>날짜</th><th class="n">입원 건</th><th class="n">입원 수납</th><th class="n">외래 건</th><th class="n">외래 수납</th><th class="n">총진료비</th><th class="n">수납액</th><th class="n">미수액</th></tr></thead><tbody>';
    days.forEach(function(d){
      var o = m[d];
      h += '<tr><td>' + fmtDay(d) + '</td><td class="n">' + o.ip + '</td><td class="n">' + won(o.ipPaid) + '</td><td class="n">' + o.op + '</td><td class="n">' + won(o.opPaid) + '</td><td class="n">' + won(o.tot) + '</td><td class="n">' + won(o.paid) + '</td><td class="n">' + won(o.unpaid) + '</td></tr>';
    });
    h += '<tr class="tot"><td>합계</td><td class="n">' + sum.ip + '</td><td class="n">' + won(sum.ipPaid) + '</td><td class="n">' + sum.op + '</td><td class="n">' + won(sum.opPaid) + '</td><td class="n">' + won(sum.tot) + '</td><td class="n">' + won(sum.paid) + '</td><td class="n">' + won(sum.unpaid) + '</td></tr>';
    h += '</tbody></table><div style="height:14px"></div>' + pmTable(ym);
    $g('rvDayBody').innerHTML = h;
  }

  /* ── 월별 ── */
  function renderMon(){
    var from = RANGE ? RANGE.from : addM(nowYm(), -11), to = RANGE ? RANGE.to : nowYm();
    var months = monthsBetween(from, to), agg = {}, all = blank();
    months.forEach(function(ym){ agg[ym] = blank(); });
    ROWS.forEach(function(r){
      var ym = String(r.paydt || '').substr(0, 6);
      if (agg[ym]) { addRow(agg[ym], r); addRow(all, r); }
    });
    $g('rvMonKpi').innerHTML = kpiHtml(all, inputOfYm(from) + ' ~ ' + inputOfYm(to));
    if (!ROWS.length) { $g('rvMonBody').innerHTML = guide(); return; }
    var h = '<h3 class="rv-h">월별 (' + esc(inputOfYm(from)) + ' ~ ' + esc(inputOfYm(to)) + ')</h3>' +
      '<table class="rv-tb"><thead><tr><th>월</th><th class="n">건수</th><th class="n">입원 수납</th><th class="n">외래 수납</th><th class="n">총진료비</th><th class="n">수납액</th><th class="n">미수액</th><th class="n">수납률</th></tr></thead><tbody>';
    months.slice().reverse().forEach(function(ym){
      var o = agg[ym], dim = o.cnt === 0 ? ' class="dim"' : '';
      h += '<tr' + dim + '><td>' + inputOfYm(ym) + '</td><td class="n">' + (o.cnt ? o.cnt.toLocaleString('ko-KR') : '—') + '</td><td class="n">' + (o.cnt ? won(o.ipPaid) : '—') + '</td><td class="n">' + (o.cnt ? won(o.opPaid) : '—') + '</td><td class="n">' + (o.cnt ? won(o.tot) : '—') + '</td><td class="n">' + (o.cnt ? won(o.paid) : '—') + '</td><td class="n">' + (o.cnt ? won(o.unpaid) : '—') + '</td><td class="n">' + pct(o.paid, o.tot) + '</td></tr>';
    });
    h += '<tr class="tot"><td>합계</td><td class="n">' + all.cnt.toLocaleString('ko-KR') + '</td><td class="n">' + won(all.ipPaid) + '</td><td class="n">' + won(all.opPaid) + '</td><td class="n">' + won(all.tot) + '</td><td class="n">' + won(all.paid) + '</td><td class="n">' + won(all.unpaid) + '</td><td class="n">' + pct(all.paid, all.tot) + '</td></tr>';
    $g('rvMonBody').innerHTML = h + '</tbody></table>';
  }

  function render(){
    if (TAB === 'day') renderDay();
    else if (TAB === 'mon') renderMon();
  }

  /* 기간을 받아 다시 그린다. 기간은 최대 24개월 — 넘으면 끝 달 기준으로 줄인다. */
  function load(){
    var from = ymOfInput($g('rvFrom').value), to = ymOfInput($g('rvTo').value);
    if (!from || !to) { _alertBox('조회 기간을 골라 주세요.', {icon:'📅'}); return; }
    if (from > to) { var t = from; from = to; to = t; }
    if (monthsBetween(from, to).length > 24) from = addM(to, -23);
    $g('rvFrom').value = inputOfYm(from);
    $g('rvTo').value = inputOfYm(to);
    var my = ++LOAD_REQ;
    return post('/mis/revGet.do', { fromYm: from, toYm: to }).then(function(res){
      if (my !== LOAD_REQ) return;          // 더 새 조회가 나갔으면 옛 응답은 버린다
      ROWS = res.rows || [];
      RANGE = { from: from, to: to };
      LOADED = true;
      render();
    }, function(e){
      if (my !== LOAD_REQ) return;
      _alertBox((e && e.message) ? e.message : '수납 자료를 불러오지 못했습니다.', {icon:'❌'});
    });
  }

  function setTab(t){
    TAB = t;
    document.querySelectorAll('#misRev .rv-tab').forEach(function(b){
      b.className = 'rv-tab' + (b.getAttribute('data-tab') === t ? ' on' : '');
    });
    $g('rvDay').hidden = t !== 'day';
    $g('rvMon').hidden = t !== 'mon';
    if (LOADED) render(); else load();
  }

  document.querySelectorAll('#misRev .rv-tab').forEach(function(b){
    b.onclick = function(){ setTab(b.getAttribute('data-tab')); };
  });
  $g('rvGo').onclick = function(){ load(); };
  $g('rvDayYm').onchange = function(){
    var ym = ymOfInput($g('rvDayYm').value);
    if (!ym) return;
    if (RANGE && (ym < RANGE.from || ym > RANGE.to)) {
      if (ym < RANGE.from) $g('rvFrom').value = inputOfYm(ym);
      if (ym > RANGE.to) $g('rvTo').value = inputOfYm(ym);
      load();
    } else render();
  };

  var nowYmStr = nowYm();
  $g('rvTo').value = inputOfYm(nowYmStr);
  $g('rvFrom').value = inputOfYm(addM(nowYmStr, -11));
  $g('rvDayYm').value = inputOfYm(nowYmStr);
  /* 탭을 처음 열 때 한 번 불러온다(경영 보고서 탭 전환 스크립트가 부른다) */
  window.misRevStart = function(){ if (!STARTED) { STARTED = true; setTab('day'); } };
})();
</script>
