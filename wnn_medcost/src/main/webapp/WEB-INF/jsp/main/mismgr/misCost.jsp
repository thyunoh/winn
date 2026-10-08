<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%-- misCost.jsp — 경영관리(MIS) › 고정경비 관리 (2026-10-08)
     · 제안서 ② 고정경비 화면 구현. 병원이 적는 것 = 병원 설정(병상 수·변동비) · 항목 · 월별 금액. 수익·입원일수는 서버 집계(청구 샘파일).
     · 「처음 1회 등록, 바뀐 것만」 : 이 달 입력이 없으면 가장 가까운 이전 달 값을 **회색으로 보여 주고** 저장 때 그대로 넣는다(저장 전엔 DB 에 없다).
     · 손익분기 = 월 고정비 ÷ (환자 1인 1일 기여수익 × 그 달 일수). 기여수익 = 1인 1일 진료비(실제) − 변동비(설정, 기본 25,000원).
     · 금액은 원 단위 정수로 저장, 화면은 천 단위 콤마 입력. 알림은 ui-message.
     · ★주의: 이 파일 안에서 Deferred EL 표기(샵+중괄호) 금지 --%>

<script src="/asset/js/ui-message.js"></script>
<script src="/asset/js/mis-split.js"></script>

<div class="dashboard-wrapper">
<div id="misCost" data-wnn="<c:out value='${wnnYn}'/>" data-hosp="<c:out value='${hospCd}'/>">
<style>
  #misCost{ background:#f4f6f8; color:#1f2a30; min-height:100%; padding:14px 16px 50px; max-width:100%; overflow-x:hidden; }
  #misCost *{ box-sizing:border-box; }
  #misCost .mc-head{ display:flex; align-items:center; gap:10px; margin-bottom:12px; flex-wrap:wrap; }
  #misCost .mc-title{ font-size:18px; font-weight:800; color:#20303a; display:flex; align-items:center; gap:8px; }
  #misCost .mc-dot{ width:10px; height:10px; border-radius:50%; background:linear-gradient(135deg,#1f5a4b,#2a7665); }
  #misCost .mc-sub{ font-size:12px; color:#6b7c86; font-weight:400; }
  #misCost .mc-hosp{ background:#e7f3ee; color:#1f5a4b; font-size:12px; font-weight:800; border:1px solid #cfe3da; border-radius:14px; padding:3px 11px; }
  #misCost .mc-spacer{ flex:1; }
  #misCost select, #misCost input{ border:1px solid #cfd8e0; border-radius:6px; padding:5px 8px; font-size:13px; background:#fff; font-family:inherit; }
  #misCost input.amt{ text-align:right; width:130px; font-variant-numeric:tabular-nums; }
  #misCost input.amt.inherit{ color:#8a99a3; font-style:italic; }
  #misCost input.memo{ width:100%; }
  #misCost .mc-btn{ border:1px solid #cfd9e0; background:#fff; color:#43555f; border-radius:6px; padding:5px 11px; font-size:12.5px; font-weight:700; cursor:pointer; }
  #misCost .mc-btn:hover{ background:#eef3f6; }
  #misCost .mc-btn.pri{ background:#1f5a4b; color:#fff; border-color:#1f5a4b; }
  #misCost .mc-btn.pri:hover{ background:#2a7665; }
  #misCost .mc-btn.del{ color:#b23b3b; }
  #misCost .mc-note{ background:#fff; border:1px solid #e3e9ed; border-radius:10px; padding:10px 14px; font-size:12.5px; color:#43555f; margin-bottom:12px; line-height:1.6; }
  #misCost .mc-kpis{ display:grid; grid-template-columns:repeat(5,1fr); gap:10px; margin-bottom:12px; }   /* 5칸 — 추정 월 손익 카드 추가(2026-10-08) */
  @media (max-width:1100px){ #misCost .mc-kpis{ grid-template-columns:repeat(3,1fr); } }
  @media (max-width:760px){ #misCost .mc-kpis{ grid-template-columns:repeat(2,1fr); } }
  #misCost .mc-kpi{ background:#fff; border:1px solid #e3e9ed; border-radius:10px; padding:12px 14px; min-width:0; }
  #misCost .mc-kpi .l{ font-size:12px; color:#6b7c86; }
  #misCost .mc-kpi .v{ font-size:26px; font-weight:900; color:#20303a; line-height:1.2; font-variant-numeric:tabular-nums; }
  #misCost .mc-kpi .d{ font-size:12px; font-weight:700; color:#6b7c86; }
  #misCost .up{ color:#2f8f5b; } #misCost .down{ color:#c0463f; }
  #misCost .mc-grid{ display:grid; grid-template-columns:1.3fr 1fr; gap:12px; margin-bottom:12px; }
  #misCost .mc-grid > *{ min-width:0; }   /* 그리드 칸이 안의 긴 글자 때문에 화면 밖으로 밀려 잘리던 것(2026-10-08 사용자 캡처) */
  #misCost .mc-grid > div > .mc-card, #misCost .bep{ overflow-wrap:anywhere; }
  @media (max-width:900px){ #misCost .mc-grid{ grid-template-columns:1fr; } }
  #misCost .mc-card{ background:#fff; border:1px solid #e3e9ed; border-radius:10px; padding:12px 14px; min-width:0; }
  #misCost .mc-card h4{ margin:0 0 8px; font-size:13px; color:#43555f; font-weight:700; display:flex; align-items:center; gap:8px; flex-wrap:wrap; }
  #misCost .mc-card h4 .sp{ flex:1; }
  #misCost table{ width:100%; border-collapse:collapse; font-size:13px; }
  #misCost th{ background:#f2f6f8; font-weight:700; color:#43555f; padding:7px 9px; border-bottom:1px solid #dde5ea; text-align:left; white-space:nowrap; }
  #misCost td{ padding:5px 9px; border-bottom:1px solid #eef2f5; vertical-align:middle; }
  #misCost td.n, #misCost th.n{ text-align:right; font-variant-numeric:tabular-nums; }
  #misCost tr.sum td{ font-weight:800; background:#f7faf9; }
  #misCost tr.gbhead td{ background:#eef3f6; font-weight:700; color:#43555f; font-size:12px; }
  #misCost .bep{ border:2px solid #1f5a4b; border-radius:10px; padding:12px 14px; background:#e7f3ee; }
  #misCost .bep h4{ color:#1f5a4b; }
  #misCost .bep .big{ font-size:32px; font-weight:900; line-height:1.1; color:#20303a; font-variant-numeric:tabular-nums; }
  /* ★class 이름을 row 로 두면 부트스트랩 .row(좌우 −15px 여백)가 먹어 글자가 상자 끝에 붙는다(2026-10-08 사용자 캡처) */
  #misCost .bep .brow{ margin:0;  display:flex; justify-content:space-between; gap:10px; font-size:13px; padding:4px 0; border-top:1px dashed #cfe3da; flex-wrap:wrap; }
  #misCost .bep .brow b{ white-space:nowrap; }
  #misCost .bep .brow:first-of-type{ border-top:0; }
  #misCost .gauge{ height:14px; border-radius:999px; background:#d9e3e0; overflow:hidden; margin:8px 0 4px; position:relative; }
  #misCost .gauge i{ display:block; height:100%; background:#1f5a4b; }
  #misCost .gauge b{ position:absolute; top:-4px; width:2px; height:22px; background:#d9772b; }
  #misCost .small{ font-size:12px; color:#6b7c86; }
  #misCost .mc-cfg{ display:flex; gap:14px; flex-wrap:wrap; align-items:center; font-size:13px; }
  #misCost .mc-cfg label{ display:flex; gap:6px; align-items:center; }
  #misCost .mc-wrap{ overflow-x:auto; }
  #misCost .mc-empty{ color:#8a99a3; font-size:13px; padding:18px; text-align:center; }
  #misCost .badge{ font-size:11px; font-weight:700; border-radius:10px; padding:1px 7px; background:#fbeadb; color:#b45f1c; }
  #misCost .badge.ok{ background:#e7f3ee; color:#1f5a4b; }
  #misCost .catadd{ display:flex; gap:6px; flex-wrap:wrap; align-items:center; margin-top:8px; font-size:12.5px; }
</style>

<div class="mc-head">
  <div class="mc-title"><span class="mc-dot"></span>고정경비 관리 <span class="mc-sub">— 매달 나가는 돈과 손익분기</span></div>
  <span class="mc-hosp">🏥 <c:out value='${hospNm}'/></span>
  <span class="mc-spacer"></span>
  <label style="font-size:13px;color:#43555f;">연월 <select id="mcYm" onchange="mcLoad();"></select></label>
  <button type="button" class="mc-btn" onclick="location.href='<c:url value="/main/misStat.do"/>';">경영통계 →</button>
</div>

<div class="mc-note">
  고정비는 <b>처음에 항목별로 한 번 적고, 다음 달부터는 바뀐 것만</b> 고치면 됩니다. 입력이 없는 달은 가장 가까운 이전 달 값을 <span style="color:#8a99a3;font-style:italic;">회색 기울임</span>으로 보여 주고, [저장]하면 이 달 값으로 굳습니다.
  수익(총진료비)과 입원일수는 청구 샘파일에서 자동으로 옵니다. <span id="mcClaimNote"></span>
</div>

<div class="mc-kpis" id="mcKpis"></div>

<div class="mc-grid" data-split="cost.main" data-split-bp="900" data-vsplit="cost.top">
  <div class="mc-card">
    <h4>항목별 월 금액 <span id="mcYmLbl" class="small"></span><span class="sp"></span>
      <button type="button" class="mc-btn" onclick="mcCopyPrev();" id="mcCopyBtn" title="가장 가까운 이전 달 값을 전부 가져옵니다">이전 달 값 가져오기</button>
      <button type="button" class="mc-btn pri" onclick="mcSave();">저장</button></h4>
    <div class="mc-wrap"><table id="mcTbl"><tbody><tr><td class="mc-empty">불러오는 중…</td></tr></tbody></table></div>
    <div class="catadd">
      <b>항목 추가</b>
      <select id="mcNewGb"><option value="C">고정비</option><option value="R">추가수익</option></select>
      <input type="text" id="mcNewNm" placeholder="항목 이름 (예: 차량 리스)" maxlength="60" style="width:200px;">
      <button type="button" class="mc-btn" onclick="mcCatAdd();">추가</button>
      <span class="small">공통 항목은 지울 수 없고 「끄기」로 숨겼다가 「사용」으로 되살립니다(끄면 이 달 합계에서 빠지고, 저장된 금액은 남습니다). 병원이 추가한 항목은 금액 기록이 없을 때만 [삭제]되며 되살릴 수 없습니다.</span>
    </div>
  </div>
  <div>
    <div class="bep" id="mcBep"></div>
    <div class="mc-card" style="margin-top:12px;">
      <h4>병원 설정 <span class="sp"></span><button type="button" class="mc-btn pri" onclick="mcCfgSave();">설정 저장</button></h4>
      <div class="mc-cfg">
        <label>허가 병상 수 <input type="text" id="mcBed" class="amt" style="width:90px;" placeholder="예: 200"> 병상</label>
        <label>환자 1인 1일 변동비 <input type="text" id="mcVar" class="amt" style="width:110px;" placeholder="25,000"> 원</label>
      </div>
      <div class="small" style="margin-top:6px;">변동비 = 환자가 한 명 늘 때 같이 느는 비용(식재료·소모품·약품 등). 모르면 비워 두세요 — 25,000원으로 계산합니다. 인력 신고값: <span id="mcGrade">—</span></div>
    </div>
  </div>
</div>

<div class="mc-card">
  <h4>최근 12달 추이 — 고정비 · 추가수익 · 총진료비 · 손익분기 · 추정 손익</h4>
  <div class="mc-wrap"><table id="mcTrend"></table></div>
  <div class="small" style="margin-top:6px;">손익분기 환자 = 고정비 ÷ (1인 1일 기여수익 × 그 달 일수). 여유 = 평균 재원 − 손익분기. 추정 손익 = (총진료비 + 추가수익) − 고정비 − 변동비 × 입원일수 — 청구에 없는 비급여 수익은 추가수익에 적어야 들어옵니다. 고정비 입력이 없는 달은 비어 있습니다(이전 달 값을 자동으로 쓰지 않습니다 — 저장해야 셉니다).</div>
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
  var root = gel('misCost'), WNN = root.getAttribute('data-wnn') === 'Y';
  var D = null, VAR_DEF = 25000;

  function eok(v){ v = Number(v||0); return (v/100000000).toFixed(2) + '억'; }
  function man(v){ v = Number(v||0); return (v/10000).toFixed(1) + '만'; }
  function num(v){ return Number(v||0).toLocaleString('ko-KR'); }
  function toNum(s){ s = String(s==null?'':s).replace(/[^0-9]/g, ''); return s === '' ? null : Number(s); }
  function ymLbl(ym){ return ym ? (ym.slice(0,4) + '년 ' + Number(ym.slice(4,6)) + '월') : ''; }
  function ymShort(ym){ return ym ? (Number(ym.slice(4,6)) + '월') : ''; }
  function daysIn(ym){ return new Date(Number(ym.slice(0,4)), Number(ym.slice(4,6)), 0).getDate(); }
  function addYm(ym, n){ var y = Number(ym.slice(0,4)), m = Number(ym.slice(4,6)) - 1 + n; y += Math.floor(m/12); m = ((m%12)+12)%12; return y + String(m+1).padStart(2,'0'); }
  function hospCd(){
    try { if (WNN && typeof getCookie === 'function') { var h = (getCookie('s_hospid') || '').trim(); if (h) return h; } } catch(e){}
    return root.getAttribute('data-hosp');
  }
  function withHosp(p){ if (WNN) p.hospCd = hospCd(); return p; }

  (function(){
    var now = new Date(), cur = now.getFullYear() + String(now.getMonth()+1).padStart(2,'0'), s = gel('mcYm');
    for (var i = -1; i < 30; i++) { var ym = addYm(cur, -i); s.add(new Option(ymLbl(ym), ym)); }
    s.value = addYm(cur, -1);
  })();

  /* 금액 칸 — 천 단위 콤마 */
  function fmtInput(el){ var n = toNum(el.value); el.value = n == null ? '' : num(n); }
  document.addEventListener('blur', function(ev){ var t = ev.target; if (t && t.classList && t.classList.contains('amt')) { fmtInput(t); if (t.classList.contains('inherit') && t.value !== '') t.classList.remove('inherit'); mcCalc(); } }, true);
  document.addEventListener('input', function(ev){ var t = ev.target; if (t && t.classList && t.classList.contains('amt')) { t.classList.remove('inherit'); } });

  window.mcLoad = function(){
    post('<c:url value="/mis/costGet.do"/>', withHosp({ ym: gel('mcYm').value })).then(function(res){
      D = res;
      if (gel('mcYm').value !== res.ym) gel('mcYm').value = res.ym;
      render();
    }).catch(function(e){ gel('mcTbl').innerHTML = '<tbody><tr><td class="mc-empty">' + esc((e && e.message) || '불러오지 못했습니다.') + '</td></tr></tbody>'; });
  };

  function cats(){ return (D.cats||[]).filter(function(c){ return c.useyn !== 'N'; }); }
  function catsAll(){ return D.cats || []; }

  function render(){
    var ym = D.ym, cost = {}, prev = {};
    (D.cost||[]).forEach(function(r){ cost[r.catcd] = r; });
    (D.prevCost||[]).forEach(function(r){ prev[r.catcd] = r; });
    var hasOwn = (D.cost||[]).length > 0;
    gel('mcYmLbl').textContent = ymLbl(ym) + (hasOwn ? '' : (D.prevYm ? ' · 입력 없음 — ' + ymLbl(D.prevYm) + ' 값을 보여 줍니다' : ' · 첫 입력'));
    gel('mcCopyBtn').style.display = D.prevYm ? '' : 'none';

    var h = '<thead><tr><th style="width:36%">항목</th><th class="n">이 달 금액(원)</th><th class="n">이전 달</th><th>메모</th><th style="width:70px"></th></tr></thead><tbody>';
    var lastGb = '';
    catsAll().forEach(function(c){
      if (c.catgb !== lastGb) { h += '<tr class="gbhead"><td colspan="5">' + (c.catgb === 'R' ? '추가수익 (샘파일에 없는 수익 — 비급여 등)' : '고정비') + '</td></tr>'; lastGb = c.catgb; }
      var cur = cost[c.catcd], pv = prev[c.catcd], off = c.useyn === 'N';
      var val = cur ? Number(cur.amt) : (pv ? Number(pv.amt) : null);
      var inherit = !cur && pv;
      h += '<tr data-cat="' + esc(c.catcd) + '" data-gb="' + esc(c.catgb) + '"' + (off ? ' style="opacity:.5"' : '') + '>'
         + '<td>' + esc(c.catnm) + (c.own === 'Y' && !isCopy(c) ? ' <span class="badge ok" title="이 병원이 추가한 항목">병원 추가</span>' : '') + (off ? ' <span class="badge">사용 안 함</span>' : '') + '</td>'
         + '<td class="n"><input type="text" class="amt' + (inherit ? ' inherit' : '') + '" value="' + (val == null ? '' : num(val)) + '"' + (off ? ' disabled' : '') + '></td>'
         + '<td class="n small">' + (pv ? num(pv.amt) : '—') + '</td>'
         + '<td><input type="text" class="memo" maxlength="200" value="' + esc(cur ? cur.memo : '') + '"' + (off ? ' disabled' : '') + '></td>'
         + '<td style="white-space:nowrap">' + '<button type="button" class="mc-btn" style="padding:2px 7px" onclick="mcCatToggle(\'' + esc(c.catcd) + '\',\'' + (off ? 'Y' : 'N') + '\')">' + (off ? '사용' : '끄기') + '</button>'
         + (c.own === 'Y' && !isCopy(c) ? ' <button type="button" class="mc-btn del" style="padding:2px 7px" onclick="mcCatDel(\'' + esc(c.catcd) + '\')">삭제</button>' : '') + '</td></tr>';
    });
    h += '<tr class="sum"><td>고정비 합계</td><td class="n" id="mcSumC">—</td><td class="n small" id="mcSumCp">—</td><td colspan="2" class="small" id="mcSumD"></td></tr>';
    h += '<tr class="sum"><td>추가수익 합계</td><td class="n" id="mcSumR">—</td><td class="n small" id="mcSumRp">—</td><td colspan="2"></td></tr></tbody>';
    gel('mcTbl').innerHTML = h;

    var cfg = D.cfg || {};
    gel('mcBed').value = cfg.bedcnt == null ? '' : num(cfg.bedcnt);
    gel('mcVar').value = cfg.varcostday == null ? '' : num(cfg.varcostday);
    var g = D.grade; gel('mcGrade').textContent = g ? (g.startyy + '년 ' + g.qterflag + '분기 — 평균환자 ' + g.patcount + ' · 의사 ' + g.doccount + ' · 간호사 ' + g.nurcount + ' · 간호인력 ' + g.nurscnt) : '없음';

    var cl = (D.claim||[])[0];
    gel('mcClaimNote').textContent = cl ? (ymLbl(ym) + ' 청구: 총진료비 ' + eok(cl.totamt) + ' · 입원일수 ' + num(cl.admdays) + '일.') : (ymLbl(ym) + ' 청구 샘파일이 아직 없어 수익 쪽은 비어 있습니다.');
    mcCalc();
    renderTrend();
  }

  function sums(){
    var c = 0, r = 0, cp = 0, rp = 0, prev = {};
    (D.prevCost||[]).forEach(function(x){ prev[x.catcd] = Number(x.amt); });
    $('#mcTbl tbody tr[data-cat]').each(function(){
      var tr = this, gb = tr.getAttribute('data-gb'), cat = tr.getAttribute('data-cat'), inp = tr.querySelector('input.amt');
      if (inp.disabled) return;
      var v = toNum(inp.value) || 0;
      if (gb === 'R') { r += v; rp += prev[cat] || 0; } else { c += v; cp += prev[cat] || 0; }
    });
    return { c:c, r:r, cp:cp, rp:rp };
  }

  window.mcCalc = function(){
    if (!D) return;
    var s = sums(), ym = D.ym, dIn = daysIn(ym), cl = (D.claim||[])[0];
    gel('mcSumC').textContent = num(s.c); gel('mcSumCp').textContent = s.cp ? num(s.cp) : '—';
    gel('mcSumR').textContent = num(s.r); gel('mcSumRp').textContent = s.rp ? num(s.rp) : '—';
    gel('mcSumD').innerHTML = s.cp ? ('전월 대비 <b class="' + (s.c - s.cp > 0 ? 'down' : 'up') + '">' + (s.c - s.cp >= 0 ? '+' : '−') + num(Math.abs(s.c - s.cp)) + '</b>') : '';
    var tot = cl ? Number(cl.totamt) : 0, days = cl ? Number(cl.admdays) : 0;
    var varC = toNum(gel('mcVar').value); if (varC == null) varC = VAR_DEF;
    var bed = toNum(gel('mcBed').value);
    var perDay = days ? tot / days : 0, contrib = perDay - varC, census = days ? days / dIn : 0;
    var revenue = tot + s.r;
    var bep = (contrib > 0 && s.c) ? Math.ceil(s.c / (contrib * dIn)) : null;
    // 추정 월 손익 = (총진료비 + 추가수익) − 고정비 − 변동비 × 입원일수 (2026-10-08 강화) — 청구와 고정비가 둘 다 있어야 뜻이 있다
    var varTot = varC * days, profit = (cl && s.c) ? revenue - s.c - varTot : null;
    var k = '';
    k += '<div class="mc-kpi"><div class="l">월 고정비 합계 (입력)</div><div class="v">' + (s.c ? eok(s.c) : '—') + '</div><div class="d ' + (s.cp && s.c > s.cp ? 'down' : 'up') + '">' + (s.cp ? (s.c >= s.cp ? '▲ ' : '▼ ') + eok(Math.abs(s.c - s.cp)) + ' 전월 대비' : '전월 입력 없음') + '</div></div>';
    k += '<div class="mc-kpi"><div class="l">월 수익 (총진료비' + (s.r ? ' + 추가수익' : '') + ')</div><div class="v">' + (revenue ? eok(revenue) : '—') + '</div><div class="d">' + (cl ? '청구 ' + eok(tot) + (s.r ? ' + ' + eok(s.r) : '') : '청구 샘파일 없음') + '</div></div>';
    k += '<div class="mc-kpi"><div class="l">환자 1인 1일 기여수익</div><div class="v">' + (perDay ? man(contrib) : '—') + '</div><div class="d">진료비 ' + (perDay ? man(perDay) : '—') + ' − 변동비 ' + man(varC) + '</div></div>';
    k += '<div class="mc-kpi"><div class="l">손익분기 재원 환자</div><div class="v">' + (bep ? bep + '명' : '—') + '</div><div class="d ' + (bep && census >= bep ? 'up' : 'down') + '">' + (bep && census ? '현재 평균 ' + Math.round(census) + '명 · ' + (census >= bep ? '여유 ' : '부족 ') + Math.abs(Math.round(census - bep)) + '명' : (s.c ? '청구 자료가 있어야 계산됩니다' : '고정비를 입력하세요')) + '</div></div>';
    k += '<div class="mc-kpi"><div class="l">추정 월 손익 (수익 − 고정비 − 변동비)</div><div class="v ' + (profit == null ? '' : (profit >= 0 ? 'up' : 'down')) + '">' + (profit == null ? '—' : (profit >= 0 ? '+' : '−') + eok(Math.abs(profit))) + '</div><div class="d">' + (profit == null ? '청구와 고정비가 있어야 계산됩니다' : '변동비 ' + man(varC) + ' × ' + num(days) + '일 = ' + eok(varTot)) + '</div></div>';
    gel('mcKpis').innerHTML = k;

    var scale = bed || Math.max(Math.ceil(Math.max(census, bep||0) * 1.2 / 10) * 10, 10);
    var b = '<h4>손익분기 (BEP) · ' + esc(ymLbl(ym)) + '</h4>';
    if (bep) {
      b += '<div class="big">' + bep + '명</div><div class="small">이 인원 이상 재원하면 고정비를 넘깁니다</div>';
      b += '<div class="gauge"><i style="width:' + Math.min(100, census/scale*100).toFixed(1) + '%"></i><b style="left:' + Math.min(100, bep/scale*100).toFixed(1) + '%"></b></div>';
      b += '<div class="small">막대 = 평균 재원 ' + Math.round(census) + '명 · 주황선 = 손익분기 ' + bep + '명 · 눈금 끝 = ' + scale + (bed ? '병상 (가동률 ' + (census/bed*100).toFixed(1) + '%)' : '명 (병상 수 입력 전)') + '</div>';
      b += '<div class="brow"><span>월 고정비</span><b>' + eok(s.c) + '</b></div>';
      b += '<div class="brow"><span>÷ 환자 1인 월 기여수익 (' + man(contrib) + ' × ' + dIn + '일)</span><b>' + man(contrib*dIn) + '</b></div>';
      b += '<div class="brow"><span>= 손익분기 환자 수</span><b>' + bep + '명</b></div>';
      var gap = census - bep;
      b += '<div class="brow"><span>' + (gap >= 0 ? '현재 여유' : '현재 부족') + ' (' + Math.round(census) + ' − ' + bep + ')</span><b class="' + (gap >= 0 ? 'up' : 'down') + '">' + (gap >= 0 ? '+' : '−') + Math.abs(Math.round(gap)) + '명 (약 ' + eok(Math.abs(gap) * contrib * dIn) + '/월)</b></div>';
      if (s.r) b += '<div class="brow"><span>추가수익 반영 시 손익분기</span><b>' + Math.ceil(Math.max(0, s.c - s.r) / (contrib * dIn)) + '명</b></div>';
      if (profit != null) b += '<div class="brow"><span>추정 월 손익 (' + eok(revenue) + ' − ' + eok(s.c) + ' − ' + eok(varTot) + ')</span><b class="' + (profit >= 0 ? 'up' : 'down') + '">' + (profit >= 0 ? '+' : '−') + eok(Math.abs(profit)) + '</b></div>';
    } else {
      b += '<div class="big">—</div><div class="small">' + (!s.c ? '왼쪽 표에 고정비를 넣으면 계산됩니다.' : (!cl ? '이 달 청구 샘파일이 없어 수익을 모릅니다.' : '기여수익이 0 이하입니다 — 변동비 설정을 확인하세요.')) + '</div>';
    }
    gel('mcBep').innerHTML = b;
  };

  function renderTrend(){
    var claim = {}, trend = {}; (D.trendClaim||[]).forEach(function(r){ claim[r.ym] = r; }); (D.trend||[]).forEach(function(r){ trend[r.ym] = r; });
    var varC = toNum(gel('mcVar').value); if (varC == null) varC = VAR_DEF;
    var h = '<thead><tr><th>월</th><th class="n">고정비</th><th class="n">추가수익</th><th class="n">총진료비</th><th class="n">평균 재원</th><th class="n">1인 1일 기여</th><th class="n">손익분기</th><th class="n">여유</th><th class="n">추정 손익</th></tr></thead><tbody>', any = false;
    var ym = addYm(D.ym, -11);
    for (var i = 0; i < 12; i++, ym = addYm(ym, 1)) {
      var c = claim[ym], t = trend[ym]; if (!c && !t) continue; any = true;
      var dIn = daysIn(ym), tot = c ? Number(c.totamt) : 0, days = c ? Number(c.admdays) : 0, cost = t ? Number(t.costamt) : 0, extra = t ? Number(t.extraamt) : 0;
      var perDay = days ? tot/days : 0, contrib = perDay - varC, census = days ? days/dIn : 0;
      var bep = (contrib > 0 && cost) ? Math.ceil(cost/(contrib*dIn)) : null;
      var profit = (tot && cost) ? tot + extra - cost - varC * days : null;   // KPI 의 「추정 월 손익」과 같은 식
      h += '<tr><td>' + esc(ymLbl(ym)) + '</td><td class="n">' + (cost ? eok(cost) : '—') + '</td><td class="n">' + (extra ? eok(extra) : '—') + '</td><td class="n">' + (tot ? eok(tot) : '—') + '</td><td class="n">' + (census ? Math.round(census) + '명' : '—') + '</td><td class="n">' + (perDay ? man(contrib) : '—') + '</td><td class="n">' + (bep ? bep + '명' : '—') + '</td><td class="n ' + (bep ? (census >= bep ? 'up' : 'down') : '') + '">' + (bep ? (census >= bep ? '+' : '−') + Math.abs(Math.round(census - bep)) + '명' : '—') + '</td>'
         + '<td class="n ' + (profit == null ? '' : (profit >= 0 ? 'up' : 'down')) + '">' + (profit == null ? '—' : (profit >= 0 ? '+' : '−') + eok(Math.abs(profit))) + '</td></tr>';
    }
    if (!any) h += '<tr><td colspan="9" class="mc-empty">아직 입력도 청구 자료도 없습니다.</td></tr>';
    gel('mcTrend').innerHTML = h + '</tbody>';
  }

  window.mcCopyPrev = function(){
    if (!D || !D.prevYm) return;
    var prev = {}; (D.prevCost||[]).forEach(function(x){ prev[x.catcd] = x; });
    $('#mcTbl tbody tr[data-cat]').each(function(){ var cat = this.getAttribute('data-cat'), inp = this.querySelector('input.amt'), pv = prev[cat]; if (inp.disabled || !pv) return; inp.value = num(pv.amt); inp.classList.remove('inherit'); });
    mcCalc();
    _toast(ymLbl(D.prevYm) + ' 값을 가져왔습니다. [저장]을 누르면 ' + ymLbl(D.ym) + ' 값이 됩니다.', 'ok');
  };

  window.mcSave = function(){
    if (!D) return;
    var rows = [], saved = {}; (D.cost||[]).forEach(function(r){ saved[r.catcd] = r; });
    $('#mcTbl tbody tr[data-cat]').each(function(){
      var cat = this.getAttribute('data-cat'), inp = this.querySelector('input.amt');
      // 꺼진 항목은 「숨긴 것」이지 금액을 버린 것이 아니다 — 이 달에 이미 저장된 금액이 있으면 그대로 다시 넣는다(저장은 그 달을 지우고 다시 넣으므로).
      if (inp.disabled) { if (saved[cat]) rows.push({ catCd: cat, amt: Number(saved[cat].amt), memo: saved[cat].memo || '' }); return; }
      var v = toNum(inp.value); if (v == null) return;
      rows.push({ catCd: cat, amt: v, memo: this.querySelector('input.memo').value });
    });
    if (!rows.length) { _alertBox('저장할 금액이 없습니다. 항목에 금액을 적어 주세요.', {icon:'⚠️'}); return; }
    _confirmBox({ msg: esc(ymLbl(D.ym)) + ' 금액 ' + rows.length + '건을 저장합니다.<br>이 달의 기존 입력은 이 내용으로 바뀝니다.', icon:'💾', okText:'저장',
      onOk: function(){
        post('<c:url value="/mis/costSave.do"/>', withHosp({ ym: D.ym, rows: JSON.stringify(rows) })).then(function(res){ _toast(ymLbl(D.ym) + ' ' + res.saved + '건 저장했습니다.', 'ok'); mcLoad(); }).catch(err);
      } });
  };

  window.mcCfgSave = function(){
    var bed = toNum(gel('mcBed').value), v = toNum(gel('mcVar').value);
    post('<c:url value="/mis/cfgSave.do"/>', withHosp({ bedCnt: bed == null ? '' : bed, varCostDay: v == null ? '' : v })).then(function(){ _toast('설정을 저장했습니다.', 'ok'); mcLoad(); }).catch(err);
  };

  window.mcCatAdd = function(){
    var nm = String(gel('mcNewNm').value || '').trim(), gb = gel('mcNewGb').value;
    if (!nm) { _alertBox('항목 이름을 적어 주세요.', {icon:'⚠️'}); gel('mcNewNm').focus(); return; }
    var cd = 'H' + Date.now().toString(36).toUpperCase().slice(-8);
    post('<c:url value="/mis/catSave.do"/>', withHosp({ catCd: cd, catNm: nm, catGb: gb, sortNo: 60, useYn: 'Y' })).then(function(){ gel('mcNewNm').value = ''; _toast('「' + nm + '」 항목을 추가했습니다.', 'ok'); mcLoad(); }).catch(err);
  };
  window.mcCatToggle = function(cd, useYn){
    var c = catsAll().filter(function(x){ return x.catcd === cd; })[0]; if (!c) return;
    post('<c:url value="/mis/catSave.do"/>', withHosp({ catCd: cd, catNm: c.catnm, catGb: c.catgb, sortNo: c.sortno, useYn: useYn })).then(function(){ mcLoad(); }).catch(err);
  };
  /* 공통 항목의 병원 사본인가 — 병원이 [항목 추가]로 만든 코드는 'H'+8자리(mcCatAdd), 공통 씨앗은 LABOR·RENT 같은 낱말 코드.
     공통 항목을 끄거나 켜면 병원 사본이 생기는데, 화면에서 이름을 못 바꾸므로 사본은 「끄기/사용」만 보여 주고 삭제 단추를 두지 않는다
     (처음엔 [원래대로]를 두었다가 사용자 「의미 없지 않나」로 뺌 — 2026-10-08). 삭제는 병원이 추가한 항목에만. */
  function isCopy(c){ return c.own === 'Y' && !/^H[0-9A-Z]{8}$/.test(String(c.catcd || '')); }
  window.mcCatDel = function(cd){
    var c = catsAll().filter(function(x){ return x.catcd === cd; })[0]; if (!c || isCopy(c)) return;
    _confirmBox({
      msg: '병원이 추가한 「' + esc(c.catnm) + '」 항목을 지웁니다. <b>되살릴 수 없습니다.</b><br>금액 기록이 있으면 지워지지 않으니 그때는 「끄기」를 쓰세요.',
      icon: '🗑️', okText: '삭제', okColor: '#b23b3b',
      onOk: function(){ post('<c:url value="/mis/catDel.do"/>', withHosp({ catCd: cd })).then(function(){ _toast('지웠습니다.', 'ok'); mcLoad(); }).catch(err); } });
  };

  $(function(){ mcLoad(); });
})();
</script>
</div><%-- /#misCost --%>
</div><%-- /.dashboard-wrapper --%>
