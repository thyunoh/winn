<%@ page pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%-- misDirRepPanel.jsp — 경영고객관리 › 청구통계 › 🏥 청구세부통계 탭 (2026-10-15)
     · 병원장 조회(misDirector)와 같은 계산·같은 조회 API 를 쓴다(손익분기 관리 식, 분야별통계와 같은 청구 기준).
     · 출력 양식은 청구통계와 같은 A4 두 장. 세부 항목을 한 단계 더 넣었다:
       Ⅰ 수익·비용·손익 요약 · Ⅱ 12개월 추이 · Ⅲ 비용 지출 명세 · Ⅳ 수익 구성·손익분기 ·
       Ⅴ 청구 분석(유형·의사·질환 상세: 건당·환자당) · Ⅵ 일당청구액 (약제 청구 현황은 별도 화면 misDrug.jsp)
     · misReport.jsp 가 정적 include 한다 — pageEncoding 만 둔다(없으면 include 될 때 ISO-8859-1 로 읽혀 한글이 깨진다). 태그 라이브러리는 부모 파일의 것을 쓴다.
     · ★ 이 파일 안에서 Deferred EL 표기(샵+중괄호) 금지 --%>
<div class="mr-panel" id="mrPanelDir" hidden>
<div id="misDirRep" data-wnn="<c:out value='${wnnYn}'/>" data-hosp="<c:out value='${hospCd}'/>" data-nm="<c:out value='${hospNm}'/>">
<style>
  #misDirRep{ background:#f4f6f8; color:#1f2a30; min-height:100%; padding:0 0 50px; max-width:100%; }
  #misDirRep *{ box-sizing:border-box; }
  #misDirRep .mdr-bar{ display:flex; align-items:center; gap:10px; flex-wrap:wrap; margin-bottom:10px; padding:14px 72px 6px 0; }   /* 위쪽 여백을 넓혀 줄을 조금 내리고, 오른쪽은 상담 단추 자리를 비운다 */
  #misDirRep .mdr-grid{ display:grid; grid-template-columns:minmax(0,1fr) minmax(0,1fr); gap:0 16px; align-items:start; }
  @media (max-width:1100px){ #misDirRep .mdr-grid{ grid-template-columns:1fr; } }
  #misDirRep .mdr-btn{ border:1px solid #cfd9e0; background:#fff; color:#43555f; border-radius:6px; padding:5px 12px; font-size:12.5px; font-weight:700; cursor:pointer; white-space:nowrap; }
  #misDirRep .mdr-btn:hover{ background:#eef3f6; }
  #misDirRep .mdr-btn.pri{ background:#1f5a4b; color:#fff; border-color:#1f5a4b; }
  #misDirRep .mdr-note{ font-size:12px; color:#6b7c86; }
  #misDirRep .mdr-note.warn{ background:#fff7e6; border:1px solid #f1d9a6; color:#7a5a12; border-radius:10px; padding:9px 14px; line-height:1.6; margin-bottom:12px; }
  #misDirRep .mdr-note a{ color:#1f5a4b; font-weight:800; text-decoration:none; }
  #misDirRep .pg{ background:#fff; border:1px solid #d7dfe5; border-radius:6px; width:100%; max-width:none; margin:0 0 18px; padding:18px 22px 16px; font-family:'Malgun Gothic','맑은 고딕',sans-serif; color:#1a1a1a; font-size:12.5px; }
  #misDirRep .pg h1{ font-size:20px; font-weight:900; margin:0 0 2px; }
  #misDirRep .pg .meta{ font-size:11px; color:#666; line-height:1.5; margin-bottom:8px; }
  #misDirRep .pg .meta2{ font-size:10.5px; color:#8a99a3; text-align:right; }
  #misDirRep .pg h2{ background:#1d2f3a; color:#fff; font-size:12.5px; font-weight:800; padding:4px 9px; margin:12px 0 6px; border-radius:2px; }
  #misDirRep .pg table{ width:100%; border-collapse:collapse; font-size:11.5px; }
  #misDirRep .pg th{ background:#eef3f6; color:#333; font-weight:800; padding:4px 6px; border-bottom:1px solid #b9c6cf; text-align:left; white-space:nowrap; }
  #misDirRep .pg td{ padding:4px 6px; border-bottom:1px solid #e6ecf0; vertical-align:middle; }
  #misDirRep .pg td.n, #misDirRep .pg th.n{ text-align:right; font-variant-numeric:tabular-nums; white-space:nowrap; }
  #misDirRep .pg tr.tot td{ font-weight:800; background:#f5f8fa; border-top:1px solid #9aa9b3; }
  #misDirRep .pg tr.sub td{ color:#43555f; }
  #misDirRep .pg .up{ color:#1f5a4b; font-weight:700; }
  #misDirRep .pg .down{ color:#b23b3b; font-weight:700; }
  #misDirRep .pg .sub2{ font-size:11.5px; font-weight:800; color:#1f5a4b; margin:9px 0 4px; }
  #misDirRep .pg .sec-note{ font-size:10.5px; color:#666; margin-top:3px; line-height:1.55; }
  #misDirRep .pg .note{ font-size:10.5px; color:#666; line-height:1.6; margin-top:8px; border-top:1px solid #d7dfe5; padding-top:6px; }
  #misDirRep .mdr-tabs{ display:flex; gap:6px; margin:4px 0 12px; flex-wrap:wrap; }
  #misDirRep .mdr-tab{ border:1px solid #cfd9e0; background:#fff; color:#43555f; border-radius:8px; padding:7px 16px; font-size:13px; font-weight:700; cursor:pointer; }
  #misDirRep .mdr-tab:hover{ background:#eef3f6; }
  #misDirRep .mdr-tab.on{ background:#1f5a4b; color:#fff; border-color:#1f5a4b; }
  #misDirRep [data-pane][hidden]{ display:none; }
  #misDirRep .pg ul.diag{ margin:2px 0 8px; padding-left:18px; line-height:1.7; font-size:12px; }
  #misDirRep .pg ul.diag li.up{ color:#1f5a4b; }
  #misDirRep .pg ul.diag li.down{ color:#b23b3b; font-weight:700; }
  #misDirRep .pg tr.tot td{ font-weight:800; background:#f2f6f8; border-top:1px solid #9fb3bd; }
  #misDirRep .pg .aibox{ background:#f3f7fb; border:1px solid #cfdce8; border-radius:6px; padding:8px 10px; font-size:12px; line-height:1.7; min-height:40px; }
  @media print{
    @page{ size:A4 portrait; margin:10mm; }
    #misDirRep{ background:#fff; padding:0; }
    #misDirRep .mdr-bar, #misDirRep .mdr-note{ display:none !important; }
    #misDirRep .pg{ border:none; border-radius:0; margin:0; padding:0; max-width:none; page-break-after:always; }
    #misDirRep .pg:last-child{ page-break-after:auto; }
    #misDirRep .pg h2{ -webkit-print-color-adjust:exact; print-color-adjust:exact; }
    #misDirRep .noprint{ display:none !important; }
  }
</style>

  <div class="mdr-bar">
    <label class="mdr-note">시작월 <input type="month" id="mdrFrom" style="border:1px solid #cfd9e0;border-radius:6px;padding:4px 8px;font-size:13px;background:#fff;"></label>
    <label class="mdr-note">종료월 <input type="month" id="mdrYm" style="border:1px solid #cfd9e0;border-radius:6px;padding:4px 8px;font-size:13px;background:#fff;"></label>
    <button type="button" class="mdr-btn pri" id="mdrGo">조회</button>
    <button type="button" class="mdr-btn" id="mdrPrint">🖨 인쇄</button>
    <button type="button" class="mdr-btn" id="mdrReload">↻ 다시 불러오기</button>
    <span class="mdr-note">기간은 시작월~종료월 · 처음에는 종료월 포함 최근 6개월 · 최대 24개월</span>
  </div>
  <div class="mdr-note warn" id="mdrNote" hidden></div>
  <div class="mdr-tabs" id="mdrTabs"><button type="button" class="mdr-tab on" data-tab="rep">청구 현황</button><button type="button" class="mdr-tab" data-tab="diag">경영 진단</button></div>
  <div id="mdrRoot"><div class="mdr-note" style="padding:20px 4px;">청구세부통계를 불러오는 중…</div></div>

<script>
(function(){
  var root = document.getElementById('misDirRep');
  if (!root) return;
  var WNN = root.getAttribute('data-wnn') === 'Y';
  var VAR_DEF = 25000;                       // 1인 1일 변동비 기본값 — 손익분기 관리(misCost)와 같다
  var D = null, C = null, T = null;          // D = directorGet 한 장, C = costGet(고정비), T = 청구 분석 묶음
  var X = null, FACTS = [], AI_TXT = '';      // X = 원장 진단 재료(dirExtra) · FACTS = AI 코멘트에 보내는 사실 목록 · AI_TXT = 받은 코멘트(기간을 바꾸면 비운다)
  var STARTED = false, LOAD_REQ = 0;         // 늦게 온 옛 응답이 새 보고서를 덮지 않게 하는 순번

  function g(id){ return document.getElementById(id); }
  function esc(s){ return (s==null?'':String(s)).replace(/[&<>"]/g, function(c){ return ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;'})[c]; }); }
  function num(v){ return Number(v||0).toLocaleString('ko-KR'); }
  /* 그래프 — 표 대신 막대로 그린다(인쇄에도 그대로 나간다, 2026-10-20) */
  var BAR_CSS = '<style>.hbars{display:grid;grid-template-columns:200px minmax(60px,1fr) max-content;column-gap:8px;row-gap:5px;align-items:center;font-size:11.5px}.hbar-row{display:contents}.hbar-lbl{flex:0 0 200px;width:200px;text-align:left;color:#43555f;overflow:hidden;white-space:nowrap;text-overflow:ellipsis}.hbar-trk{flex:1;height:12px;background:#eef2f5;border-radius:3px;overflow:hidden}.hbar-fill{height:100%;background:#2d9fd3;border-radius:3px}.hbar-val{text-align:left;font-variant-numeric:tabular-nums;color:#20303a;white-space:nowrap}.vbars{display:flex;align-items:flex-end;gap:10px;height:230px;padding:8px 4px 0;border-bottom:1px solid #d5dee5}.vbar-col{flex:1;display:flex;flex-direction:column;align-items:center;justify-content:flex-end;height:100%;min-width:0}.vbar-fill{width:60%;max-width:46px;background:#2d9fd3;border-radius:3px 3px 0 0}.vbar-val{font-size:11px;color:#20303a;font-weight:700;margin-bottom:3px;white-space:nowrap}.vbar-lbl{font-size:11px;color:#43555f;margin-top:4px;white-space:nowrap}.vbar-sub{font-size:10px;color:#8a99a3}</style>';
  function hBars(rows, msg){
    if (!rows.length) return '<div class="sec-note">' + (msg || '해당 자료가 없습니다.') + '</div>';
    var max = 0; rows.forEach(function(r){ max = Math.max(max, Number(r.value||0)); });
    return BAR_CSS + '<div class="hbars">' + rows.map(function(r){
      var pct = max ? Math.max(1, Math.round(Number(r.value||0) / max * 100)) : 0;
      return '<div class="hbar-row"><div class="hbar-lbl" title="' + esc(r.label) + '">' + esc(r.label) + '</div>' +
        '<div class="hbar-trk"><div class="hbar-fill" style="width:' + pct + '%"></div></div>' +
        '<div class="hbar-val" title="' + esc(r.text) + '">' + esc(r.text) + '</div></div>';
    }).join('') + '</div>';
  }
  function vBars(rows){
    if (!rows.length) return '<div class="sec-note">해당 자료가 없습니다.</div>';
    var max = 0; rows.forEach(function(r){ max = Math.max(max, Number(r.value||0)); });
    return BAR_CSS + '<div class="vbars">' + rows.map(function(r){
      var h = max ? Math.max(2, Math.round(Number(r.value||0) / max * 140)) : 2;
      return '<div class="vbar-col"><div class="vbar-val">' + esc(r.text) + '</div>' +
        '<div class="vbar-fill" style="height:' + h + 'px"></div>' +
        '<div class="vbar-lbl">' + esc(r.label) + '</div><div class="vbar-sub">' + esc(r.sub || '') + '</div></div>';
    }).join('') + '</div>';
  }
  /* 월별 수익·비용 묶음 막대 — 한 달에 수익(진하게)·비용(연하게) 두 개, 아래 줄은 추정 손익 */
  var GB_CSS = '<style>.gbars{display:flex;align-items:flex-end;gap:8px;height:270px;padding:8px 4px 0;border-bottom:1px solid #d5dee5}.gb-col{flex:1;min-width:0;height:100%;display:flex;flex-direction:column;justify-content:flex-end;align-items:center}.gb-pair{display:flex;align-items:flex-end;gap:4px;height:215px;width:100%;justify-content:center}.gb-one{width:44%;max-width:40px;height:100%;display:flex;flex-direction:column;justify-content:flex-end;align-items:center}.gb-val{font-size:10px;color:#20303a;font-weight:700;margin-bottom:3px;white-space:nowrap}.gb-fill{width:100%;border-radius:3px 3px 0 0}.gb-lbl{font-size:11px;color:#43555f;margin-top:4px;white-space:nowrap}.gb-sub{font-size:10.5px;color:#8a99a3;white-space:nowrap}.gb-sub.up{color:#1f7a4d;font-weight:700}.gb-sub.down{color:#b3261e;font-weight:700}</style>';
  function gBars(rows){
    if (!rows.length) return '<div class="sec-note">해당 자료가 없습니다.</div>';
    var max = 0; rows.forEach(function(r){ [r.a, r.b].forEach(function(s){ if (s.value != null) max = Math.max(max, Number(s.value)); }); });
    var one = function(s, color){
      if (s.value == null) return '<div class="gb-one"><div class="gb-val">—</div></div>';
      var h = max ? Math.max(2, Math.round(Number(s.value) / max * 190)) : 2;
      return '<div class="gb-one"><div class="gb-val">' + esc(s.text) + '</div><div class="gb-fill" style="height:' + h + 'px;background:' + color + '"></div></div>';
    };
    return GB_CSS + '<div class="gbars">' + rows.map(function(r){
      return '<div class="gb-col"><div class="gb-pair">' + one(r.a, '#2d9fd3') + one(r.b, '#ef8a45') + '</div>' +
        '<div class="gb-lbl">' + esc(r.label) + '</div><div class="gb-sub ' + (r.subCls || '') + '">' + esc(r.sub || '') + '</div></div>';
    }).join('') + '</div>' +
      '<div class="sec-note"><span style="color:#2d9fd3">■</span> 수익 &nbsp; <span style="color:#ef8a45">■</span> 비용 · 아래 숫자는 추정 손익</div>';
  }
  function eok(v){ v = Number(v||0); return (v/100000000).toFixed(2) + '억'; }
  function man(v){ v = Number(v||0); return Math.round(v/10000).toLocaleString('ko-KR') + '만'; }
  function sgn(v, f){ return (v >= 0 ? '+' : '−') + f(Math.abs(v)); }
  function pct(a, b){ return b ? Math.round(a / b * 1000) / 10 + '%' : '—'; }
  function ratio(a, b){ return b ? (Math.round(Number(a||0) / Number(b) * 1000) / 10).toFixed(1) + '%' : '—'; }
  function ymLbl(ym){ return ym ? (ym.slice(0,4) + '년 ' + Number(ym.slice(4,6)) + '월') : ''; }
  function ymShort(ym){ return ym ? (Number(ym.slice(4,6)) + '월') : ''; }
  function daysIn(ym){ return new Date(Number(ym.slice(0,4)), Number(ym.slice(4,6)), 0).getDate(); }
  function addYm(ym, n){ var y = Number(ym.slice(0,4)), m = Number(ym.slice(4,6)) - 1 + n; y += Math.floor(m/12); m = ((m%12)+12)%12; return y + String(m+1).padStart(2,'0'); }
  function arr(x){ return Array.isArray(x) ? x : []; }
  function ymOf(v){ return String(v || '').replace(/[^0-9]/g, '').substr(0, 6); }
  /* 기간 — 시작월~종료월에 든 달 수와 일수 (일수는 입원일수 나눗셈과 손익분기에 쓴다) */
  function rangeInfo(from, to){
    var n = 0, d = 0, cur = from;
    while (cur && cur <= to && n < 24) { d += daysIn(cur); n++; cur = addYm(cur, 1); }
    return { n: Math.max(1, n), days: d || daysIn(to) };
  }
  function periodLbl(from, to){ return from === to ? ymLbl(to) : ymLbl(from) + ' ~ ' + ymLbl(to); }
  function totRow(rows){ return rows.filter(function(r){ return r.medDept === '00' || r.medName === '전체'; })[0] || null; }
  function getCookie(n){ var m = document.cookie.match(new RegExp('(?:^|; )' + n + '=([^;]*)')); return m ? decodeURIComponent(m[1]) : ''; }
  function hosp(){ var h = ''; try { h = (getCookie('s_hospid') || '').trim(); } catch(e){} return h || root.getAttribute('data-hosp'); }
  function post(url, data){
    data.hospCd = hosp();
    return $.ajax({ url:url, type:'POST', data:data, dataType:'json' }).then(function(res){
      if (res && res.result === 'FAIL') throw new Error(res.message || '처리에 실패했습니다.');
      return res;
    });
  }
  function mdrProg(pct, text){ var f = g('mdrProgFill'); if (!f) return; f.style.width = Math.max(0, Math.min(100, pct)) + '%'; g('mdrProgTxt').textContent = text; g('mdrProgPct').textContent = Math.round(pct) + '%'; }
  function tong(url, p){ p.hospCd = hosp(); return $.ajax({ url:url, type:'POST', data:p, dataType:'json' }); }

  /* 한 줄 — 첫 칸은 글자, 나머지는 숫자(오른쪽 맞춤). text 에 든 번호 칸만 글자로 둔다 */
  function tr(cells, cls, text){
    return '<tr' + (cls ? ' class="' + cls + '"' : '') + '>' + cells.map(function(c, i){
      var isN = i > 0 && !(text && text.indexOf(i) >= 0);
      return '<td' + (isN ? ' class="n"' : '') + '>' + c + '</td>';
    }).join('') + '</tr>';
  }
  function head(cols, text){
    return '<thead><tr>' + cols.map(function(c, i){
      var isN = i > 0 && !(text && text.indexOf(i) >= 0);
      return '<th' + (isN ? ' class="n"' : '') + '>' + c + '</th>';
    }).join('') + '</tr></thead>';
  }
  function emptyRow(n, msg){ return '<tr><td colspan="' + n + '" class="sub">' + msg + '</td></tr>'; }

  /* ── 계산: 병원장 조회·손익분기 관리와 같은 식 ── */
  function calc(ym, cl, nMonths, totDays){
    var cfg = (C && C.cfg) || {};
    var varC = cfg.varcostday == null ? VAR_DEF : Number(cfg.varcostday);
    var bed = Number(cfg.bedcnt || 0);
    var costMap = {}, prevMap = {};
    ((C && C.cost) || []).forEach(function(x){ costMap[x.catcd] = Number(x.amt || 0); });
    ((C && C.prevCost) || []).forEach(function(x){ prevMap[x.catcd] = Number(x.amt || 0); });
    var fixed = [], extra = [], prevFixed = 0, prevExtra = 0, hasPrev = false;
    ((C && C.cats) || []).filter(function(c){ return c.useyn !== 'N'; }).forEach(function(c){
      var v = costMap[c.catcd], pv = prevMap[c.catcd];
      if (pv != null) { hasPrev = true; if (c.catgb === 'R') prevExtra += pv; else prevFixed += pv; }
      if (v == null) return;
      // 고정비·추가수익은 월 금액 × 기간의 달 수. 전월 비교는 한 달을 골랐을 때만 한다.
      (c.catgb === 'R' ? extra : fixed).push({ nm: c.catnm, amt: v * nMonths, prev: (nMonths === 1 && pv != null) ? pv : null });
    });
    fixed.sort(function(a, b){ return b.amt - a.amt; });
    var fixedTot = fixed.reduce(function(s, x){ return s + x.amt; }, 0);
    var extraTot = extra.reduce(function(s, x){ return s + x.amt; }, 0);
    var tot = cl ? Number(cl.totamt || 0) : 0, days = cl ? Number(cl.admdays || 0) : 0;
    var varTot = varC * days;
    var revenue = tot + extraTot, expense = fixedTot + varTot;
    var profit = (cl && fixedTot) ? revenue - expense : null;
    var dIn = totDays, census = days ? days / dIn : 0;
    // 재원 기준 = 차등제 신고 평균 재원(적정성 구조영역과 같은 값). 신고가 없으면 청구 입원일수로 센다.
    if (D && D.headSrc === 'grade' && D.census != null) census = Number(D.census);
    var perDay = days ? tot / days : 0, contrib = perDay - varC;
    var bep = (contrib > 0 && fixedTot) ? Math.ceil(fixedTot / (contrib * dIn)) : null;
    return { varC:varC, bed:bed, fixed:fixed, extra:extra, fixedTot:fixedTot, extraTot:extraTot, tot:tot, days:days,
             varTot:varTot, revenue:revenue, expense:expense, profit:profit, census:census, bep:bep, contrib:contrib,
             prevFixed: (hasPrev && nMonths === 1) ? prevFixed : null, prevExtra: (hasPrev && nMonths === 1) ? prevExtra : null, dIn:dIn, ym:ym, nMonths:nMonths };
  }

  /* 추이 — 조회 기간(from~to)의 달마다 수익·비용을 채운다. 청구 자료가 있는 달만 수익을 채운다 (2026-10-15: 12개월 고정 → 조회 기간) */
  function trendRows(from, to){
    var claim = {}, cost = {};
    ((C && C.trendClaim) || []).forEach(function(r){ claim[r.ym] = r; });
    ((C && C.trend) || []).forEach(function(r){ cost[r.ym] = r; });
    var cfg = (C && C.cfg) || {}, varC = cfg.varcostday == null ? VAR_DEF : Number(cfg.varcostday);
    var out = [], m = from;
    for (var i = 0; i < 24 && m <= to; i++, m = addYm(m, 1)) {
      var c = claim[m], t = cost[m];
      var tot = c ? Number(c.totamt || 0) : 0, days = c ? Number(c.admdays || 0) : 0;
      var fx = t ? Number(t.costamt || 0) : 0, ex = t ? Number(t.extraamt || 0) : 0;
      var rev = (c || t) ? tot + ex : null;
      var exp = (c && fx) ? fx + varC * days : null;
      out.push({ ym:m, rev:c ? rev : null, exp:exp, profit:(c && fx) ? rev - exp : null });
    }
    return out;
  }

  /* ── Ⅰ 수익·비용·손익 요약 ── */
  function donutSvg(parts, cTop, cBot){
    var R = 52, C = 2 * Math.PI * R, off = 0;
    var tot = parts.reduce(function(s, p){ return s + Math.max(0, p.v || 0); }, 0);
    var ring = '<circle cx="70" cy="70" r="' + R + '" fill="none" stroke="#eef2f5" stroke-width="22"/>';
    if (tot > 0) parts.forEach(function(p){
      var len = C * Math.max(0, p.v || 0) / tot;
      if (len <= 0) return;
      ring += '<circle cx="70" cy="70" r="' + R + '" fill="none" stroke="' + p.color + '" stroke-width="22" stroke-dasharray="' + len.toFixed(2) + ' ' + (C - len).toFixed(2) + '" stroke-dashoffset="' + (-off).toFixed(2) + '" transform="rotate(-90 70 70)"/>';
      off += len;
    });
    return '<svg viewBox="0 0 140 140" width="140" height="140" role="img">' + ring +
      '<text x="70" y="64" text-anchor="middle" font-size="11" fill="#6b7b85">' + esc(cTop) + '</text>' +
      '<text x="70" y="82" text-anchor="middle" font-size="13" font-weight="800" fill="#20303a">' + esc(cBot) + '</text></svg>';
  }
  function secSummary(M, prevRev){
    var rev = M.revenue || 0, exp = M.expense || 0;
    var parts = [], cTop = '기간 수익', cBot = '—', legend = '';
    if (rev > 0 && M.profit != null) {
      var profit = M.profit;
      parts = profit >= 0
        ? [{ v: exp, color: '#ef8a45', label: '비용' }, { v: profit, color: '#2d9fd3', label: '추정 손익(흑자)' }]
        : [{ v: rev, color: '#2d9fd3', label: '수익' }, { v: -profit, color: '#b3261e', label: '손실분(적자)' }];
      cTop = '수익 ' + eok(rev); cBot = (profit >= 0 ? '흑자 ' : '적자 ') + sgn(profit, eok);
      legend = parts.map(function(p){ return '<div class="sm-lg"><span class="sm-sw" style="background:' + p.color + '"></span>' + esc(p.label) + ' <b>' + eok(p.v) + '</b> <span class="sm-m">' + pct(p.v, rev) + '</span></div>'; }).join('');
    } else if (rev > 0) {
      parts = [{ v: rev, color: '#2d9fd3', label: '수익' }];
      cBot = eok(rev);
      legend = '<div class="sm-m">고정비를 입력하면 비용·손익 구간이 나뉩니다.</div>';
    } else {
      legend = '<div class="sm-m">청구 자료가 없어 도넛을 그리지 못했습니다.</div>';
    }
    var kpi = function(k, v, d, cls){
      return '<div class="sm-kpi"><div class="sm-k">' + k + '</div><div class="sm-v ' + (cls || '') + '">' + v + '</div><div class="sm-d">' + esc(d) + '</div></div>';
    };
    var kpis =
      kpi('기간 수익', M.revenue ? num(M.revenue) + '원' : '—', M.tot ? '청구 총진료비 ' + eok(M.tot) + (M.extraTot ? ' + 추가수익 ' + man(M.extraTot) : '') : '청구 자료 없음') +
      kpi('기간 비용', M.expense ? num(M.expense) + '원' : '—', '고정비 ' + (M.fixedTot ? eok(M.fixedTot) : '—') + ' + 변동비 ' + (M.days ? man(M.varTot) : '—')) +
      kpi('추정 손익', M.profit == null ? '—' : sgn(M.profit, num) + '원', M.profit == null ? '고정비를 입력하면 계산됩니다' : (M.profit >= 0 ? '흑자' : '적자') + ' · 수익 − 비용', M.profit == null ? '' : (M.profit >= 0 ? 'up' : 'down')) +
      kpi('전월 수익', prevRev == null ? '—' : num(prevRev) + '원', (prevRev == null || !M.revenue) ? '전월 청구 자료 없음' : '기간과 차이 ' + sgn(M.revenue - prevRev, num) + '원');
    var gauges = '';
    if (M.bed && M.days) {
      var occ = Math.min(100, M.census / M.bed * 100);
      gauges += '<div class="sm-gauge"><div class="sm-gl"><span>가동률</span><b>' + pct(M.census, M.bed) + '</b><span class="sm-m">평균 재원 ' + Math.round(M.census) + '명 / 병상 ' + M.bed + '</span></div>' +
        '<div class="sm-track"><div class="sm-fill" style="width:' + occ.toFixed(1) + '%"></div></div></div>';
    }
    if (M.bep && M.days) {
      var gap = M.census - M.bep, gapN = Math.abs(Math.round(gap));
      var max = Math.max(M.bep, M.census) * 1.2;
      gauges += '<div class="sm-gauge"><div class="sm-gl"><span>손익분기</span><b class="' + (gap >= 0 ? 'up' : 'down') + '">' + (gap >= 0 ? '여유 +' : '부족 ') + gapN + '명</b><span class="sm-m">평균 재원 ' + Math.round(M.census) + '명 · 손익분기 ' + M.bep + '명</span></div>' +
        '<div class="sm-track"><div class="sm-fill" style="width:' + Math.min(100, M.census / max * 100).toFixed(1) + '%;background:' + (gap >= 0 ? '#1f7a4d' : '#b3261e') + '"></div>' +
        '<div class="sm-mark" style="left:' + (M.bep / max * 100).toFixed(1) + '%"></div></div></div>';
    }
    return '<h2>Ⅰ. 수익 · 비용 · 손익 요약</h2>' +
      '<style>.sm-wrap{display:grid;grid-template-columns:170px 1fr;gap:14px;align-items:center}.sm-donut{display:flex;flex-direction:column;align-items:center;gap:8px}.sm-legend{display:flex;flex-direction:column;gap:3px;font-size:11.5px;color:#43555f;align-self:stretch}.sm-lg{display:flex;align-items:center;gap:6px}.sm-sw{width:10px;height:10px;border-radius:2px;display:inline-block}.sm-kpis{display:grid;grid-template-columns:1fr 1fr;gap:8px}.sm-kpi{border:1px solid #dbe3e9;border-radius:8px;padding:7px 9px;background:#fbfcfd;min-width:0}.sm-k{font-size:11.5px;color:#6b7b85}.sm-v{font-size:13.5px;font-weight:800;color:#20303a;margin:2px 0;white-space:nowrap}.sm-v.up,.sm-gl b.up{color:#1f7a4d}.sm-v.down,.sm-gl b.down{color:#b3261e}.sm-d,.sm-m{font-size:10.5px;color:#8a99a3}.sm-gauge{margin-top:10px}.sm-gl{display:flex;align-items:baseline;gap:8px;flex-wrap:wrap;font-size:12px;color:#43555f;margin-bottom:4px}.sm-gl b{font-size:13px;color:#20303a}.sm-track{height:12px;background:#eef2f5;border-radius:4px;position:relative}.sm-fill{height:100%;background:#2d9fd3;border-radius:4px}.sm-mark{position:absolute;top:-3px;bottom:-3px;width:2px;background:#ef8a45;margin-left:-1px}</style>' +
      '<div class="sm-wrap"><div class="sm-donut">' + donutSvg(parts, cTop, cBot) + '<div class="sm-legend">' + legend + '</div></div>' +
      '<div><div class="sm-kpis">' + kpis + '</div>' + gauges + '</div></div>' +
      (M.fixedTot ? '' : '<div class="sec-note">고정비가 아직 없어 비용·손익은 계산되지 않았습니다. 손익분기 관리에서 월 고정비를 입력하세요.</div>') +
      (M.bed ? '' : '<div class="sec-note">병상 수가 없어 가동률은 빈칸입니다.</div>');
  }

  /* ── Ⅱ 12개월 추이 ── */
  function secTrend(tr12){
    var rows = tr12.map(function(r){
      return { label: ymLbl(r.ym),
        a: { value: r.rev, text: r.rev == null ? '' : eok(r.rev) },
        b: { value: r.exp, text: r.exp == null ? '' : eok(r.exp) },
        sub: r.profit == null ? '손익 —' : '손익 ' + sgn(r.profit, eok),
        subCls: r.profit == null ? '' : (r.profit >= 0 ? 'up' : 'down') };
    });
    return '<h2>Ⅱ. 기간 수익 · 비용 · 손익 추이 (조회 기간 월별)</h2>' + gBars(rows) +
      '<div class="sec-note">수익 = 청구 총진료비 + 추가수익 · 비용 = 고정비 + 환자 변동비(1인 1일 ' + num(VAR_DEF) + '원 기본). 청구나 고정비가 없는 달은 —. 정확한 금액은 Ⅰ 요약과 손익분기 관리에서 확인.</div>';
  }

  /* ── Ⅲ 비용 지출 명세 ── */
  function secExpense(M){
    var total = M.expense || 0, prevTotal = M.prevFixed;
    var rows = M.fixed.map(function(x){
      return { label: x.nm, value: x.amt, text: num(x.amt) + '원 · ' + pct(x.amt, total) };
    });
    if (M.days) rows.push({ label: '환자 변동비', value: M.varTot, text: num(M.varTot) + '원 · ' + pct(M.varTot, total) });
    return '<h2>Ⅲ. 비용 지출 명세</h2>' +
      hBars(rows, '고정비가 아직 입력되지 않았습니다. 손익분기 관리에서 항목별 금액을 적으면 여기 채워집니다.') +
      (M.days ? '<div class="sec-note">환자 변동비 = 1인 1일 ' + num(M.varC) + '원 × ' + num(M.days) + '일</div>' : '') +
      '<div class="sec-note">비용 합계 ' + num(total) + '원' + (prevTotal == null ? '' : ' · 전월 고정비 ' + num(prevTotal) + '원') + '</div>';
  }

  /* ── Ⅳ 수익 구성 · 손익분기 ── */
  function secRevenue(M, cl){
    var rev = M.revenue || 0, bars = [];
    if (cl) bars.push({ label: '총진료비 (청구)', value: M.tot, text: num(M.tot) + '원 · ' + pct(M.tot, rev) });
    M.extra.forEach(function(x){ bars.push({ label: x.nm + ' (추가수익)', value: x.amt, text: num(x.amt) + '원 · ' + pct(x.amt, rev) }); });
    var b = '<h2>Ⅳ. 수익 구성 · 손익분기(BEP)</h2>' +
      hBars(bars, '청구 자료가 없어 수익을 계산하지 못했습니다. 청구 샘파일을 올리면 채워집니다.') +
      (rev ? '<div class="sec-note">수익 합계 ' + num(rev) + '원</div>' : '');
    if (M.bep) {
      var gap = M.census - M.bep;
      var card = function(k, v, m, cls){
        return '<div class="bep-it"><div class="bep-k">' + k + '</div><div class="bep-v ' + (cls || '') + '">' + v + '</div><div class="bep-m">' + m + '</div></div>';
      };
      b += '<div class="sub2">손익분기(BEP)</div>' +
        '<style>.bep-grid{display:grid;grid-template-columns:1fr 1fr;gap:6px 10px}.bep-it{display:grid;grid-template-columns:1fr auto;column-gap:8px;row-gap:2px;border:1px solid #dbe3e9;border-radius:6px;padding:7px 10px;background:#fbfcfd}.bep-k{grid-column:1;font-size:12px;font-weight:700;color:#20303a}.bep-v{grid-column:2;grid-row:1;font-size:13px;font-weight:800;color:#20303a;text-align:right;white-space:nowrap}.bep-m{grid-column:1 / 3;font-size:11px;color:#6b7b85}.bep-v.up{color:#1f7a4d}.bep-v.down{color:#b3261e}</style>' +
        '<div class="bep-grid">' +
          card('손익분기 재원 인원', M.bep + '명', '이 인원 이상 재원하면 고정비를 넘는다') +
          card('평균 재원 (실제)', Math.round(M.census) + '명', '청구 재원일수 ÷ 그 달 일수') +
          card((gap >= 0 ? '현재 여유' : '현재 부족') + ' (' + Math.round(M.census) + ' − ' + M.bep + ')', (gap >= 0 ? '+' : '') + Math.round(gap) + '명', gap >= 0 ? '손익분기보다 많이 재원 중' : '손익분기에 못 미침', gap >= 0 ? 'up' : 'down') +
          card('환자 1인 1일 기여', num(Math.round(M.contrib)) + '원', '1인 1일 진료비 − 변동비') +
        '</div>';
    } else {
      b += '<div class="sec-note">고정비와 청구 자료가 둘 다 있어야 손익분기를 계산합니다.</div>';
    }
    return b;
  }

  /* ── Ⅴ 청구 분석 (의과 · 총액 기준 — 청구세부통계는 진료비 총액으로 본다) ── */
  function secAnalysis(part){
    if (!T) return '<h2>Ⅴ. 청구 분석</h2><div class="sec-note">청구 분석 자료를 불러오지 못했습니다.</div>';
    var out = '';   // Ⅴ 상위 제목 제거 — 5-1·5-2·5-3 을 독립 구획으로 (2026-10-15)

    /* 5-1 유형별 */
    var typ = T.type.filter(function(r){ return !(r.medDept === '00' || r.medName === '전체' || r.cformName === '전체'); })
                    .sort(function(a, b){ return Number(b.totalAmt||0) - Number(a.totalAmt||0); });
    var typSum = typ.reduce(function(s, r){ return s + Number(r.totalAmt||0); }, 0);
    var p51 = '<h2>Ⅴ-1. 유형별 청구</h2>' +
      hBars(typ.map(function(r, i){ return { label: (i + 1) + '. ' + (r.cformName || r.medName || ''), value: Number(r.totalAmt || 0), text: num(r.totalAmt) + '원 · ' + ratio(r.totalAmt, typSum) + ' · ' + num(r.claimCount) + '건' }; }));

    /* 5-2 의사별 — 면허번호 기준, 의사명이 없으면 면허 번호로 표시 */
    var doc = T.doc.filter(function(r){ return r.licenseNo && r.licenseNo !== '99'; })
                   .sort(function(a, b){ return Number(b.totalAmt||0) - Number(a.totalAmt||0); });
    var docSum = doc.reduce(function(s, r){ return s + Number(r.totalAmt||0); }, 0);
    var p52 = '<h2>Ⅴ-2. 의사별 청구 (상위 10 · 면허번호 기준)</h2>' +
      hBars(doc.slice(0, 10).map(function(r, i){
        var nm = (r.licenseName && r.licenseName !== '전체') ? r.licenseName : ('면허 ' + r.licenseNo + ' (의사명 미등록)');
        return { label: (i + 1) + '. ' + nm, value: Number(r.totalAmt || 0), text: num(r.totalAmt) + '원 · ' + ratio(r.totalAmt, docSum) + ' · ' + num(r.claimCount) + '건' };
      }));

    out += '<div class="mdr-grid"><div>' + p51 + '</div><div>' + p52 + '</div></div>';
    if (part === 'top') return out;   // 5-1·5-2 만 (위쪽 줄)
    out = '';                         // 5-3 만 — 일당청구액 옆에 한 줄로 놓는다

    /* 5-3 질환별 — 건당·환자당까지 (청구통계 Ⅵ 과 다른 점: 등록된 질병코드만 개별, 나머지는 ZZ 한 줄) */
    var dis = T.dis.filter(function(r){ return r.diagName || r.diagCode; })
                   .sort(function(a, b){ return Number(b.totalAmt||0) - Number(a.totalAmt||0); });
    var disSum = T.dis.reduce(function(s, r){ return s + Number(r.totalAmt||0); }, 0);
    var hasZZ = dis.some(function(r){ return r.diagCode === 'ZZ'; });
    out += '<h2>Ⅴ-3. 질환별 청구 (상위 10 · 건당 · 환자당)</h2>' +
      hBars(dis.slice(0, 10).map(function(r, i){ var amt = Number(r.totalAmt||0), cnt = Number(r.claimCount||0), pts = Number(r.uniqPatients||0); return { label: (i + 1) + '. ' + (r.diagCode ? r.diagCode + ' ' : '') + (r.diagName || ''), value: amt, text: num(amt) + '원 · ' + ratio(amt, disSum) + ' · ' + num(cnt) + '건 · ' + num(pts) + '명' }; })) +
      (hasZZ ? '<div class="sec-note">ZZ 기타병명 = 질병 분류표(공통코드 DISEASE_TYPE)에 없는 주상병 코드를 한데 모은 줄이다. 코드별로 보려면 「청구통계」 탭 Ⅵ(주상병별 수익 구성)을 본다.</div>' : '');
    return out;
  }

  /* ── Ⅵ 일당청구액 ── */
  function secDay(){
    if (!T) return '<h2>Ⅵ. 일당청구액</h2><div class="sec-note">자료를 불러오지 못했습니다.</div>';
    var trend = (C && C.trendClaim) || [], days = {};
    trend.forEach(function(t){ days[t.ym] = Number(t.admdays || 0); });
    var rows = T.day.slice().sort(function(a, b){ return String(a.dateYm).localeCompare(String(b.dateYm)); });
    var body = rows.map(function(r){
      var d = days[r.dateYm] || 0, amt = Number(r.ipAmt != null ? r.ipAmt : (r.totalAmt || 0));
      return tr([esc(ymLbl(r.dateYm)), num(amt), num(d), d ? num(Math.round(amt / d)) : '—', num(r.totalAvgAmt)], '', []);
    }).join('');
    return '<h2>Ⅵ. 일당금액 (최근 6개월 · 입원 총액 ÷ 입원일수)</h2>' +
      vBars(rows.map(function(r){ var d = days[r.dateYm] || 0, amt = Number(r.ipAmt != null ? r.ipAmt : (r.totalAmt || 0)); var dly = d ? Math.round(amt / d) : 0; return { label: ymLbl(r.dateYm), value: dly, text: d ? man(dly) + '원' : '—', sub: '입원 ' + num(d) + '일' }; }));
  }

  /* ── Ⅶ 약제 청구 현황 — 청구분 · 정액분 · 합계 · 정액 비청구 항목 ── */
  function secDrug(){
    if (!T) return '<h2>Ⅶ. 약제 청구 현황</h2><div class="sec-note">자료를 불러오지 못했습니다.</div>';
    var t082 = totRow(arr(T.drug[0])), t08 = totRow(arr(T.drug[1])), t081 = totRow(arr(T.drug[2])), t083 = totRow(arr(T.drug[3]));
    var yk = function(t){ return t ? Number(t.yakAmt || 0) : null; };
    // 청구분 = 실제로 청구되는 약제비 · 정액분 = 정액에 포함되어 따로 청구하지 않는 약(항목 L). 합계 = 청구분 + 정액분.
    var rows = [], sumClaim = 0, sumFix = 0, sumTot = 0;
    var line = function(name, claim, fixed){
      if (claim == null && fixed == null) { rows.push(tr([esc(name), '—', '—', '—', '—', '—'], '', [])); return; }
      var c = claim || 0, f = fixed || 0, t = c + f;
      sumClaim += c; sumFix += f; sumTot += t;
      rows.push(tr([esc(name), num(c), ratio(c, t), num(f), ratio(f, t), num(t)], '', []));
    };
    var fixTot = yk(t081), fixNc = yk(t08);
    line('정액환자', fixTot == null ? null : fixTot - (fixNc || 0), fixTot == null ? null : (fixNc || 0));
    line('정율환자 (행위)', yk(t082), 0);
    rows.push(tr(['합계', num(sumClaim), ratio(sumClaim, sumTot), num(sumFix), ratio(sumFix, sumTot), num(sumTot)], 'tot', []));
    var allTot = yk(t083), gap = allTot == null ? 0 : Math.round(allTot - sumTot);
    var refNote = allTot == null ? '' : '<div class="sec-note">전체환자 약제비 ' + num(allTot) + '원' +
      (Math.abs(gap) > 1 ? ' — 합계와 ' + num(Math.abs(gap)) + '원 차이가 있어 명세서 항목 누락 여부를 확인하세요.' : ' — 합계와 일치합니다.') + '</div>';
    var items = T.item.filter(function(r){ return r.itemName && r.itemName !== '전체'; })
                      .sort(function(a, b){ return Number(b.totalAmt||0) - Number(a.totalAmt||0); }).slice(0, 12);
    var itemTot = T.item.filter(function(r){ return r.itemName === '전체'; })[0];
    var itemSum = itemTot ? Number(itemTot.totalAmt || 0) : items.reduce(function(s, r){ return s + Number(r.totalAmt||0); }, 0);
    var topHtml = '<h2>Ⅶ-1. 약제 청구 현황 — 청구분 · 정액분 · 합계</h2>' +
      '<table>' + head(['구분', '청구분(원)', '청구 비율', '정액분(원)', '정액 비율', '합계(원)']) + '<tbody>' + rows.join('') + '</tbody></table>' + refNote +
      '<div class="sec-note">합계 = 처방 오더 금액에서 위탁청구(JS008)를 뺀 약제비. 청구분 = 실제로 청구되는 약제비. 정액분 = 정액에 포함되어 따로 청구하지 않는 약(항목 L). 정율환자는 항목상 정액분이 확인되지 않아 전액 청구분으로 봤다.</div>';
    var disHtml = '<h2>Ⅶ-2. 정액 비청구분 항목별 — 약 말고 다른 처방 (상위 12)</h2>' +
      hBars(items.slice(0, 12).map(function(r, i){ return { label: (i + 1) + '. ' + (r.codeName || ''), value: Number(r.totalAmt || 0), text: num(r.totalAmt) + '원 · ' + ratio(r.totalAmt, itemSum) }; }));
    return '<div class="mdr-grid"><div>' + topHtml + '</div><div>' + disHtml + '</div></div>';
  }
  function render(){
    if (D && D.ym) g('mdrYm').value = D.ym.slice(0, 4) + '-' + D.ym.slice(4, 6);
    if (D && D.fromYm) g('mdrFrom').value = D.fromYm.slice(0, 4) + '-' + D.fromYm.slice(4, 6);
    var ym = (D && D.ym) || '';
    if (!ym) {
      g('mdrNote').hidden = false;
      g('mdrNote').innerHTML = '청구 자료가 아직 없습니다. <a href="/main/magamFileUpload.do">청구·평가 업로드</a>에서 청구 샘파일을 올리면 청구세부통계가 만들어집니다.';
      g('mdrRoot').innerHTML = '';
      return;
    }
    g('mdrNote').hidden = true;
    var cl = (D && D.claim) || null;
    var from = (D && D.fromYm) || ym;
    var R = rangeInfo(from, ym);
    var M = calc(ym, cl, R.n, R.days);
    var tr12 = trendRows(from, ym);
    var prevYmRow = trendRows(addYm(ym, -1), addYm(ym, -1))[0];   // 전월 수익 — 조회 기간과 관계없이 종료월 전월
    var prevRev = prevYmRow ? prevYmRow.rev : null;
    var today = (D && D.today) || '';
    var asof = today ? (today.slice(0,4) + '.' + today.slice(4,6) + '.' + today.slice(6,8)) : '';
    var nm = root.getAttribute('data-nm') || '';
    var header = '<h1>청구세부통계</h1>' +
      '<div class="meta">' + esc(nm) + ' · 기간 ' + esc(periodLbl(from, ym)) + ' · 기간 추이 포함</div>' +
      '<div class="meta2">작성일 ' + esc(asof) + '</div>';
    var p1 = '<div class="pg">' + header + '<div class="mdr-grid"><div>' + secSummary(M, prevRev) + '</div><div>' + secTrend(tr12) + '</div></div>' +
      '<div class="mdr-grid"><div>' + secExpense(M) + '</div><div>' + secRevenue(M, cl) + '</div></div>' +
      '<div class="note">Ⅰ~Ⅲ : 수익·비용은 손익분기 관리 입력 기준 · 병원장 조회 화면과 같은 식으로 계산했다.</div></div>';
    var p2 = '<div class="pg">' + secAnalysis('top') + '<div class="mdr-grid"><div>' + secAnalysis('dis') + '</div><div>' + secDay() + '</div></div>' + secDrug() +
      '<div class="note">Ⅴ~Ⅶ : 청구 분석은 전체 명세서 기준(총액 · 위탁 명세서 제외). 금액은 원 단위.</div></div>';
    var p3 = '<div class="pg">' + '<div class="mdr-grid"><div>' + secClass(M) + '</div><div>' + secPeer(M) + secStruct(M) + '</div></div>' + secLeak(M) + secDiag(M, prevRev) +
      '</div>';
    g('mdrRoot').innerHTML = '<div class="mdr-pane" data-pane="rep">' + p1 + p2 + '</div><div class="mdr-pane" data-pane="diag" hidden>' + p3 + '</div>';
    mdrShowTab(MDR_TAB);
  }

  /* ── Ⅷ 경영 진단 — 원장용 (2026-10-16, 효사랑가족요양병원 「AI 실무활용 사례」를 EMR 없이 청구·평가표·고정비·상담 자료로 옮김) ──
     Ⅷ-1 환자군별 수익성 · Ⅷ-2 고객 병원 대비 위치 · Ⅷ-3 비용 구조 · Ⅷ-4 돈이 새는 곳 점검 · Ⅷ-5 자동 진단 + AI 경영 코멘트.
     자료는 /mis/dirExtra.do 한 번(X). AI 코멘트는 단추를 눌렀을 때만(화면의 숫자를 사실 목록으로 보내고, 서버가 Gemini 에 묻는다). */
  var CLS_NM = { A:'A군 (의료최고도)', B:'B군 (의료고도)', C:'C군 (의료중도)', D:'D군 (의료경도)', E:'E군 (선택입원)' };
  function loadExtra(my){
    return post('/mis/dirExtra.do', { fromYm: (D && D.fromYm) || '', toYm: (D && D.ym) || '' }).then(function(x){ if (my === LOAD_REQ) X = x; }, function(){ if (my === LOAD_REQ) X = null; });
  }
  function secClass(M){
    var rows = arr(X && X.classCost), out = '<h2>Ⅷ-1. 환자군별 수익성 (' + esc(periodLbl((X && X.fromYm) || M.ym, M.ym)) + ' · 청구 명세서 + 같은 달 환자평가표)</h2>';
    if (!rows.length) return out + '<div class="sec-note">환자군을 맞출 환자평가표가 없어 계산하지 못했습니다(평가표가 올라오면 자동으로 채워집니다).</div>';
    var days = rows.reduce(function(s, r){ return s + Number(r.admdays || 0); }, 0), hi = null, lo = null;
    rows.forEach(function(r){ var p = Number(r.perday || 0); if (!hi || p > Number(hi.perday)) hi = r; if (!lo || p < Number(lo.perday)) lo = r; });
    out += hBars(rows.map(function(r){
      var pd = Number(r.perday || 0);
      return { label: (CLS_NM[r.cls] || r.cls) + ' · ' + num(r.pats) + '명', value: pd,
        text: num(r.perday) + '원 · 입원 ' + num(r.admdays) + '일 · 비중 ' + pct(Number(r.admdays || 0), days) + ' · 30일 ' + man(pd * 30) + '원' };
    }), '환자군 자료가 없습니다.');
    if (hi && lo && hi !== lo) out += '<div class="sec-note">' + esc(CLS_NM[hi.cls] || hi.cls) + ' 1인 1일 ' + num(hi.perday) + '원 vs ' + esc(CLS_NM[lo.cls] || lo.cls) + ' ' + num(lo.perday) + '원 — 하루 ' + num(Number(hi.perday) - Number(lo.perday)) + '원, 한 달 약 ' + man((Number(hi.perday) - Number(lo.perday)) * 30) + '원 차이. 환자군 판정(환자평가표)이 곧 수익이다.</div>';
    return out;
  }
  function secPeer(M){
    var p = X && X.peer, out = '<h2>Ⅷ-2. 고객 병원 대비 위치 (' + esc(ymLbl(M.ym)) + ' · 같은 달 청구를 올린 병원)</h2>';
    if (!p || !Number(p.hosps)) return out + '<div class="sec-note">같은 달 청구를 올린 다른 병원이 아직 없어 비교하지 못했습니다.</div>';
    var n = Number(p.hosps), r1 = Number(p.rankperday), r2 = Number(p.rankdays), dIn = daysIn(M.ym);
    function top(r){ return '상위 ' + Math.round(r / n * 100) + '%'; }
    var dv = Number(p.myperday) - Number(p.avgperday);
    out += '<table>' + head(['지표', '본원', '고객 평균', '순위', '비고'], [4]) + '<tbody>' +
      tr(['1인 1일 진료비', num(p.myperday) + '원', num(p.avgperday) + '원', r1 + ' / ' + n + '위 (' + top(r1) + ')', esc('평균보다 ' + pct(Math.abs(dv), Number(p.avgperday)) + (dv >= 0 ? ' 높음' : ' 낮음'))], '', [4]) +
      tr(['월 입원일수 (규모)', num(p.mydays) + '일', num(p.avgdays) + '일', r2 + ' / ' + n + '위 (' + top(r2) + ')', '평균 재원 ' + Math.round(Number(p.mydays) / dIn) + '명 vs ' + Math.round(Number(p.avgdays) / dIn) + '명'], '', [4]) +
      '</tbody></table><div class="sec-note">순위는 명세서 금액 그대로(위탁 제외 전)라 Ⅰ의 1인 1일(위탁 제외)과 조금 다를 수 있다. 다른 병원 이름은 보이지 않는다(위너넷 고객 평균).</div>';
    return out;
  }
  function secStruct(M){
    var out = '<h2>Ⅷ-3. 비용 구조 (기간)</h2>';
    if (!M.fixedTot || !M.revenue) return out + '<div class="sec-note">고정비와 청구가 둘 다 있어야 비율이 나옵니다.</div>';
    var rev = M.revenue, labor = M.fixed.filter(function(x){ return /인건비/.test(x.nm); }).reduce(function(s, x){ return s + x.amt; }, 0);
    var other = M.fixedTot - labor, vr = M.varTot || 0, pr = M.profit == null ? 0 : M.profit;
    var segs = [{ nm: '인건비', v: labor, c: '#1f5a4b' }, { nm: '기타 고정비', v: other, c: '#7aa89d' }, { nm: '환자 변동비', v: vr, c: '#ef8a45' }];
    if (pr >= 0) segs.push({ nm: '추정 이익', v: pr, c: '#2d9fd3' });
    else segs.push({ nm: '적자 (비용이 수익을 초과)', v: -pr, c: '#b3261e', over: true });
    // 막대 전체 길이 = 흑자면 수익, 적자면 비용 합계(수익보다 긴 부분은 표시하지 않는다)
    var total = pr >= 0 ? rev : (M.fixedTot + vr);
    var bar = segs.filter(function(s){ return !s.over && s.v > 0; }).map(function(s){
      return '<div style="width:' + (s.v / total * 100).toFixed(2) + '%;height:100%;background:' + s.c + '" title="' + esc(s.nm) + ' ' + pct(s.v, rev) + '"></div>';
    }).join('');
    var legend = segs.filter(function(s){ return s.v > 0 || !s.over; }).map(function(s){
      return '<span class="sb-lg"><i style="background:' + s.c + '"></i>' + esc(s.nm) + ' <b>' + pct(s.v, rev) + '</b></span>';
    }).join('');
    return out +
      '<style>.sb-bar{display:flex;height:26px;border-radius:5px;overflow:hidden;background:#eef2f5;margin:6px 0 8px}.sb-lg{display:inline-flex;align-items:center;gap:5px;margin:0 14px 4px 0;font-size:12px;color:#43555f}.sb-lg i{display:inline-block;width:11px;height:11px;border-radius:2px}.sb-lg b{color:#20303a}</style>' +
      '<div class="sm-m" style="font-size:11px;color:#8a99a3">수익 100% 기준 — 수익이 어디로 나가고 얼마가 남는지</div>' +
      '<div class="sb-bar">' + bar + '</div>' +
      '<div>' + legend + '</div>' +
      '<div class="sec-note">환자 1인 1일 기여 ' + num(Math.round(M.contrib)) + '원 (1인 1일 진료비 − 변동비) · 재원 1명의 한 달 손익 기여 ' + num(Math.round(M.contrib * 30)) + '원 · 손익분기 ' + (M.bep ? M.bep + '명' : '—') + '</div>';
  }
  function secLeak(M){
    var x = X || {}, rows = [], out = '<h2>Ⅷ-4. 돈이 새는 곳 점검 (' + esc(ymLbl(M.ym)) + ')</h2>';
    function row(nm, val, st, note){ rows.push('<tr><td>' + nm + '</td><td class="n">' + val + '</td><td><b class="' + st + '">' + (st === 'down' ? '확인' : st === 'up' ? '양호' : '자료 없음') + '</b></td><td class="sub">' + note + '</td></tr>'); }
    if (x.gapReady) {
      row('평가표는 있는데 청구 명세서 없음', num(x.noClaim) + '명', Number(x.noClaim) ? 'down' : 'up', Number(x.noClaim) ? '청구 누락 의심 — ' + esc(arr(x.noClaimNm).join(', ')) + (Number(x.noClaim) > 10 ? ' 외' : '') : '누락 없음');
      row('청구는 됐는데 환자평가표 없음', num(x.noPatval) + '명', Number(x.noPatval) ? 'down' : 'up', Number(x.noPatval) ? '평가표 누락 의심 — 적정성 분모·환자군 비용 계산에서 빠진다' : '누락 없음');
    } else row('청구 ↔ 환자평가표 대조', '—', '', '청구와 평가표가 둘 다 올라온 달에 대조한다');
    if (Number(x.cutCnt)) row('삭감·조정', num(x.cutAmt) + '원 (' + num(x.cutCnt) + '건)', 'down', '감액률 ' + pct(Number(x.cutAmt), Number(x.samClaim)) + ' (청구액 ' + eok(x.samClaim) + ' 대비) — 사유는 병원자료엑셀연계 › 삭감');
    else row('삭감·조정', '—', '', '삭감 자료 없음 — 병원자료엑셀연계에 삭감 통보 엑셀을 올리면 계산');
    if (Number(x.payCnt)) row('미수 (수납대장)', num(x.unpaid) + '원', Number(x.unpaid) ? 'down' : 'up', '미수율 ' + pct(Number(x.unpaid), Number(x.unpaid) + Number(x.paid)) + ' · 수납 ' + eok(x.paid));
    else row('미수 (수납대장)', '—', '', '수납대장 없음 — 병원자료엑셀연계 › 수납대장');
    row('장기입원 181일↑ (적정성 지표)', x.longStay == null ? '자료생성 전' : num(x.longStay) + '명 / 대상 ' + num(x.inCnt) + '명', Number(x.longStay) ? 'down' : 'up', '적정성 장기입원 지표와 같은 계산(해당 월 자료생성 결과) · 체감제로 수가가 깎인다');
    row('오늘 챙길 일', '급함 ' + num(D && D.bad) + ' · 확인 ' + num(D && D.warn), Number(D && D.bad) ? 'down' : 'up', '업무 알림 — 자료 미업로드·신고·상담 연락');
    return out + '<table>' + head(['점검 항목', '값', '판정', '설명'], [3, 4]) + '<tbody>' + rows.join('') + '</tbody></table>';
  }
  function buildFacts(M, prevRev){
    var f = [], x = X || {}, p = x.peer;
    f.push('기간 ' + periodLbl((D && D.fromYm) || M.ym, M.ym) + ' · 수익 ' + (M.revenue ? num(M.revenue) + '원' : '청구 없음') + (M.tot ? ' (청구 총진료비 ' + num(M.tot) + '원, 입원일수 ' + num(M.days) + '일, 평균 재원 ' + Math.round(M.census) + '명' + (M.bed ? ', 병상 ' + M.bed + ' 가동률 ' + pct(M.census, M.bed) : '') + ')' : ''));
    if (M.fixedTot) f.push('비용 ' + num(M.expense) + '원 (고정비 ' + num(M.fixedTot) + ' + 변동비 ' + num(M.varTot) + ') · 추정 손익 ' + sgn(M.profit, num) + '원 · 손익률 ' + pct(M.profit, M.revenue) + (M.bep ? ' · 손익분기 ' + M.bep + '명(여유 ' + Math.round(M.census - M.bep) + '명)' : ''));
    else f.push('고정비 미입력 — 손익 계산 불가');
    if (prevRev != null && M.nMonths === 1) f.push('전월 수익 ' + num(prevRev) + '원 → 이번 달 ' + sgn(M.revenue - prevRev, num) + '원 (' + pct(M.revenue - prevRev, prevRev) + ')');
    var cls = arr(x.classCost); if (cls.length) f.push('환자군별 1인 1일 진료비: ' + cls.map(function(r){ return r.cls + '군 ' + num(r.perday) + '원(' + num(r.pats) + '명)'; }).join(', '));
    if (p && Number(p.hosps)) f.push('고객 병원 ' + p.hosps + '곳 중 1인 1일 진료비 ' + p.rankperday + '위(본원 ' + num(p.myperday) + ' vs 평균 ' + num(p.avgperday) + '원), 입원일수 ' + p.rankdays + '위');
    if (x.gapReady) f.push('청구↔평가표 대조: 평가표만 있는 환자 ' + num(x.noClaim) + '명, 명세서만 있는 환자 ' + num(x.noPatval) + '명');
    if (Number(x.cutCnt)) f.push('삭감 ' + num(x.cutAmt) + '원 ' + num(x.cutCnt) + '건 (감액률 ' + pct(Number(x.cutAmt), Number(x.samClaim)) + ')');
    if (Number(x.payCnt)) f.push('수납 ' + num(x.paid) + '원, 미수 ' + num(x.unpaid) + '원');
    f.push('장기입원 181일↑(적정성 지표) ' + (x.longStay == null ? '자료생성 전' : num(x.longStay) + '명 / 대상 ' + num(x.inCnt) + '명'));
    if (D && D.headSrc === 'none') f.push('간호사: 차등제 신고값 없음 — 구조영역 계산 불가 · 이번 달 상담 ' + num(D.leads) + '건 중 입원 ' + num(D.admits) + '건');
    else if (D) f.push('간호사 ' + num(D.headcount) + '명(' + (D.headLabel || '') + ')' + (D.required ? ' · 5점 기준 필요 ' + num(D.required) + '명' : '') + (Number(D.short) ? ' (부족 ' + D.short + '명)' : '') + ' · 이번 달 상담 ' + num(D.leads) + '건 중 입원 ' + num(D.admits) + '건 · 챙길 일 급함 ' + num(D.bad) + ' 확인 ' + num(D.warn));
    return f;
  }
  function autoDiag(M, prevRev){
    var d = [], x = X || {}, p = x.peer;
    if (M.profit == null) d.push(['', '고정비가 없어 손익을 모른다 — 손익분기 관리에 월 고정비(인건비·임대료 등)를 한 번만 적으면 매달 자동 계산된다.']);
    else d.push([M.profit >= 0 ? 'up' : 'down', (M.profit >= 0 ? '흑자 ' : '적자 ') + sgn(M.profit, eok) + ' (손익률 ' + pct(M.profit, M.revenue) + ')' + (M.bep ? ' · 손익분기 ' + M.bep + '명 대비 ' + (M.census >= M.bep ? '여유 ' : '부족 ') + Math.abs(Math.round(M.census - M.bep)) + '명' : '')]);
    if (prevRev != null && M.nMonths === 1 && M.revenue) { var dv = M.revenue - prevRev; d.push([dv >= 0 ? 'up' : 'down', '수익 전월 대비 ' + sgn(dv, eok) + ' (' + pct(dv, prevRev) + ')' + (Math.abs(dv) / prevRev > 0.1 ? ' — 10% 넘는 변동, 입원·퇴원 수와 환자군 변화를 보라' : '')]); }
    var cls = arr(x.classCost);
    if (cls.length >= 2) { var hi = cls.reduce(function(a, b){ return Number(a.perday) >= Number(b.perday) ? a : b; }), lo = cls.reduce(function(a, b){ return Number(a.perday) <= Number(b.perday) ? a : b; }); d.push(['', '환자군 ' + hi.cls + '군 ' + num(hi.perday) + '원 vs ' + lo.cls + '군 ' + num(lo.perday) + '원/일 — 환자 1명이 ' + lo.cls + '→' + hi.cls + '군이면 한 달 약 ' + man((Number(hi.perday) - Number(lo.perday)) * 30) + '원. 평가표 작성 정확도가 곧 수익.']); }
    if (p && Number(p.hosps) > 1) { var diff = Number(p.myperday) - Number(p.avgperday); d.push([diff >= 0 ? 'up' : 'down', '1인 1일 진료비가 고객 평균보다 ' + pct(Math.abs(diff), Number(p.avgperday)) + (diff >= 0 ? ' 높다' : ' 낮다') + ' (' + p.rankperday + '/' + p.hosps + '위)' + (diff < 0 ? ' — 환자군 구성·행위 청구 누락을 점검' : '')]); }
    if (x.gapReady && Number(x.noClaim)) d.push(['down', '평가표는 있는데 청구 명세서가 없는 환자 ' + x.noClaim + '명 — 청구 전에 누락인지 퇴원·전원인지 확인']);
    if (Number(x.cutCnt) && Number(x.samClaim) && Number(x.cutAmt) / Number(x.samClaim) > 0.01) d.push(['down', '감액률 ' + pct(Number(x.cutAmt), Number(x.samClaim)) + ' — 1% 를 넘는다, 사유 상위부터 심사과와 점검']);
    if (Number(x.longStay)) d.push(['', '장기입원(181일 이상) ' + x.longStay + '명 — 적정성 장기입원 지표 기준(대상 ' + x.inCnt + '명)']);
    if (D && D.headSrc === 'none') d.push(['down', '차등제 신고값이 없어 간호사 구조영역을 계산하지 못했다 — 차등제 신고를 입력하면 자동 계산']);
    if (D && Number(D.short)) d.push(['down', '간호사 ' + D.short + '명 부족 — ' + (D.headLabel || '') + ' 간호사 ' + D.headcount + '명, 5점 기준(1인당 환자 ' + (D.top ? Number(D.top).toFixed(2) : '') + '명 이하) 필요 ' + D.required + '명. 구간이 떨어지면 구조영역 점수와 차등 수가가 같이 내려간다']);
    if (D && Number(D.leads) && !Number(D.admits)) d.push(['', '이번 달 상담 ' + D.leads + '건 중 입원 0 — 상담→방문 전환이 막힌 지점을 고객관리에서 확인']);
    if (!d.length) d.push(['up', '숫자로 드러난 위험 신호가 없다.']);
    return d;
  }
  /* 한눈에 보기 — 자동 진단·AI 코멘트가 쓰는 같은 숫자(M · X · D)를 막대로 (2026-10-20) */
  function dgRow(label, v, max, color, text, mark){
    var w = max ? Math.min(100, Math.max(0, v / max * 100)) : 0;
    return '<div class="dg-row"><div>' + esc(label) + '</div><div class="dg-trk"><div class="dg-f" style="width:' + w.toFixed(1) + '%;background:' + color + '"></div>' +
      (mark != null && max ? '<div class="dg-m" style="left:' + Math.min(100, mark / max * 100).toFixed(1) + '%"></div>' : '') +
      '</div><div class="dg-v">' + text + '</div></div>';
  }
  function dgCard(t, html){ return '<div class="dg-card"><div class="dg-t">' + esc(t) + '</div>' + html + '</div>'; }
  function dgHtml(M){
    var x = X || {}, dd = D || {}, cards = [];
    var rev = M.revenue || 0, exp = M.expense || 0;
    var css = '<style>.dg-wrap{display:grid;grid-template-columns:1fr 1fr;gap:10px;margin:6px 0 10px}.dg-card{border:1px solid #dbe3e9;border-radius:8px;padding:9px 11px;background:#fbfcfd;min-width:0}.dg-t{font-size:12px;font-weight:800;color:#20303a;margin-bottom:6px}.dg-row{display:grid;grid-template-columns:120px 1fr auto;column-gap:8px;align-items:center;margin:5px 0;font-size:11.5px;color:#43555f}.dg-trk{height:11px;background:#eef2f5;border-radius:3px;position:relative}.dg-f{height:100%;border-radius:3px;-webkit-print-color-adjust:exact;print-color-adjust:exact}.dg-m{position:absolute;top:-3px;bottom:-3px;width:2px;background:#ef8a45}.dg-v{white-space:nowrap;color:#20303a;font-variant-numeric:tabular-nums}@media (max-width:900px){.dg-wrap{grid-template-columns:1fr}}</style>';
    if (rev) {
      var pl = '';
      pl += dgRow('수익', rev, rev, '#2d9fd3', eok(rev));
      pl += dgRow('비용', exp, rev, '#ef8a45', exp ? eok(exp) + ' (' + pct(exp, rev) + ')' : '—');
      if (M.profit != null) pl += dgRow('추정 손익', Math.abs(M.profit), rev, M.profit >= 0 ? '#1f7a4d' : '#b3261e', sgn(M.profit, eok) + ' (' + pct(M.profit, rev) + ')');
      cards.push(dgCard('손익 — 수익 · 비용', pl));
    }
    if (M.census) {
      var rc = '';
      rc += M.bep
        ? dgRow('평균 재원', M.census, Math.max(M.census, M.bep) * 1.2, M.census >= M.bep ? '#1f7a4d' : '#b3261e', Math.round(M.census) + '명 / 손익분기 ' + M.bep + '명', M.bep)
        : dgRow('평균 재원', M.census, M.bed || M.census, '#2d9fd3', Math.round(M.census) + '명');
      if (M.bed) rc += dgRow('가동률', M.census, M.bed, '#2d9fd3', pct(M.census, M.bed) + ' (병상 ' + M.bed + ')');
      cards.push(dgCard('재원 · 손익분기 · 가동률', rc));
    }
    if (dd.headcount != null) {
      var need = dd.required != null ? Number(dd.required) : Number(dd.headcount) + Number(dd.short || 0);
      cards.push(dgCard('간호사 인원 · ' + (dd.headLabel || ''), dgRow('현재', Number(dd.headcount), need || 1, '#2d9fd3', num(dd.headcount) + '명') +
        dgRow('필요', need, need || 1, '#ef8a45', num(need) + '명' + (Number(dd.short) ? ' (부족 ' + num(dd.short) + '명)' : ''))));
    }
    if (x.inCnt != null) {
      var mxL = Math.max(Number(x.inCnt), Number(x.longStay)) || 1;
      cards.push(dgCard('장기입원 지표 (적정성 기준)', dgRow('지표 대상', Number(x.inCnt), mxL, '#2d9fd3', num(x.inCnt) + '명') +
        dgRow('181일 이상', Number(x.longStay), mxL, '#ef8a45', num(x.longStay) + '명' + (Number(x.inCnt) ? ' (' + pct(Number(x.longStay), Number(x.inCnt)) + ')' : ''))));
    }
    if (!cards.length) return '';
    return css + '<div class="sub2">한눈에 보기 (아래 진단과 같은 숫자)</div><div class="dg-wrap">' + cards.join('') + '</div>';
  }
  function secDiag(M, prevRev){
    FACTS = buildFacts(M, prevRev);
    var d = autoDiag(M, prevRev);
    return '<h2>Ⅷ-5. 자동 진단 · AI 경영 코멘트</h2>' +
      '<div class="sub2">자동 진단 (규칙 — 화면의 숫자에서 바로)</div><ul class="diag">' + d.map(function(x){ return '<li' + (x[0] ? ' class="' + x[0] + '"' : '') + '>' + esc(x[1]) + '</li>'; }).join('') + '</ul>' +
      dgHtml(M) + '<div class="sub2">AI 경영 코멘트 (요약 · 원인 · 위험 · 기회 · 권고)</div>' +
      '<div class="aibox" id="mdrAiBox">' + (AI_TXT ? esc(AI_TXT).replace(/\n/g, '<br>') : '<span class="sub">[✨ AI 코멘트 받기]를 누르면 위 사실 목록으로 다섯 줄을 씁니다. 숫자를 지어내지 않도록 지시했지만 판단은 원장이 합니다.</span>') + '</div>' +
      '<div class="noprint" style="margin-top:6px;display:flex;gap:6px;flex-wrap:wrap;"><button type="button" class="mdr-btn pri" onclick="mdrAi()">✨ AI 코멘트 받기</button><button type="button" class="mdr-btn" onclick="mdrCopyDiag()">🔗 진단 글 복사</button><span class="mdr-note">복사한 글은 카톡·메일에 그대로 붙일 수 있습니다</span></div>';
  }
  window.mdrAi = function(){
    if (!FACTS.length) return;
    var box = g('mdrAiBox'); if (!box) return;
    box.innerHTML = '<span class="sub">AI 가 쓰는 중…</span>';
    post('/mis/dirComment.do', { hospNm: root.getAttribute('data-nm') || '', period: periodLbl((D && D.fromYm) || (D && D.ym) || '', (D && D.ym) || ''), facts: FACTS.join('\n') }).then(function(r){
      if (r && r.ok) { AI_TXT = r.text || ''; box.innerHTML = esc(AI_TXT).replace(/\n/g, '<br>'); }
      else { AI_TXT = ''; box.innerHTML = '<span class="sub">' + esc((r && r.reason) || 'AI 코멘트를 받지 못했습니다.') + '</span>'; }
    }, function(e){ AI_TXT = ''; box.innerHTML = '<span class="sub">' + esc((e && e.message) || '실패') + '</span>'; });
  };
  window.mdrCopyDiag = function(){
    var nm = root.getAttribute('data-nm') || '', t = '[' + nm + '] 경영 진단 · ' + periodLbl((D && D.fromYm) || (D && D.ym) || '', (D && D.ym) || '') + '\n' + FACTS.map(function(f){ return '- ' + f; }).join('\n') + (AI_TXT ? '\n\n[AI 코멘트]\n' + AI_TXT : '');
    function done(){ _toast('복사했습니다. 카톡·메일에 붙여 넣으세요.', 'ok'); }
    function fallback(){ var ta = document.createElement('textarea'); ta.value = t; document.body.appendChild(ta); ta.select(); try { document.execCommand('copy'); done(); } catch(e){ _alertBox('복사하지 못했습니다.', {icon:'❌'}); } document.body.removeChild(ta); }
    if (navigator.clipboard && navigator.clipboard.writeText) navigator.clipboard.writeText(t).then(done, fallback); else fallback();
  };

  /* 청구세부통계 자료 — 한 장(directorGet) → 고정비(costGet) → 청구 분석 9개 조회를 같은 청구월로 */
  function loadAnalysis(my){
    var ym = D && D.ym;
    if (!ym) { T = null; return $.Deferred().resolve().promise(); }
    var from = (D && D.fromYm) || ym;
    var done = 0; var step = function(){ done++; mdrProg(50 + done / 9 * 50, '청구 분석 불러오는 중… (3/3 · ' + done + '/9)'); }; mdrProg(50, '청구 분석 불러오는 중… (3/3 · 0/9)');
    var base = { ipwe:'', medType:'9', jrType:'0', amtType:'1', startMonth: from, endMonth: ym };   // medType 9 = 전체(의과 필터 없음), amtType 1 = 총액(진료비) 기준
    var reqs = [
      tong('/tong/t_tong06List.do', $.extend({}, base)),
      tong('/tong/t_tong05List.do', $.extend({}, base)),
      tong('/tong/t_tong04List.do', $.extend({}, base)),
      tong('/tong/t_tong00List.do', $.extend({}, base, { ipwe:'I', startMonth: addYm(ym, -5) })),
      tong('/tong/t_tong082List.do', $.extend({}, base)),
      tong('/tong/t_tong08List.do', $.extend({}, base)),
      tong('/tong/t_tong081List.do', $.extend({}, base)),
      tong('/tong/t_tong083List.do', $.extend({}, base)),
      tong('/tong/t_tong09List.do', { ipwe:'', medType:'9', amtType:'1', startMonth: from, endMonth: ym })
    ].map(function(q){ return q.then(function(r){ step(); return r; }, function(){ step(); return []; }); });
    return $.when.apply($, reqs).then(function(){
      if (my !== LOAD_REQ) return;
      var a = arguments;
      T = { type: arr(a[0]), doc: arr(a[1]), dis: arr(a[2]), day: arr(a[3]),
            drug: [a[4], a[5], a[6], a[7]], item: arr(a[8]) };
    });
  }

  function load(fromYm, toYm){
    var my = ++LOAD_REQ;
    g('mdrNote').hidden = true;
    g('mdrRoot').innerHTML = '<div style="padding:20px 4px;"><div id="mdrProgTxt" class="mdr-note">자료 불러오는 중… (1/3)</div><div style="height:10px;background:#e4eaef;border-radius:5px;overflow:hidden;margin:8px 0;max-width:560px;"><div id="mdrProgFill" style="height:100%;width:0%;background:#1f5a4b;transition:width .25s;"></div></div><div id="mdrProgPct" class="mdr-note">0%</div></div>'; mdrProg(10, '자료 불러오는 중… (1/3)');
    return post('/mis/directorGet.do', { fromYm: fromYm || '', toYm: toYm || '' }).then(function(d){
      if (my !== LOAD_REQ) return null;
      D = d;
      // 추이는 조회 기간(시작월~종료월)으로 받는다. 전월 수익을 위해 시작월 한 달 전부터 받는다.
      var f0 = (d.fromYm || d.ym || '');
      var cf = f0 ? addYm(f0, -1) : '';
      mdrProg(30, '고정비 불러오는 중… (2/3)'); return post('/mis/costGet.do', { ym: d.ym || '', fromYm: cf }).then(function(c){ C = c; }, function(){ C = null; });
    }).then(function(){
      if (my !== LOAD_REQ || !D) return;
      AI_TXT = '';
      return $.when(loadAnalysis(my), loadExtra(my)).then(function(){ if (my === LOAD_REQ) render(); });
    }, function(e){
      if (my !== LOAD_REQ) return;
      g('mdrRoot').innerHTML = '';
      g('mdrNote').hidden = false;
      g('mdrNote').textContent = '청구세부통계를 불러오지 못했습니다: ' + ((e && e.message) || '');
    });
  }

  /* 탭: 청구 현황(기본) · 경영 진단. 고른 탭은 다시 그려도 유지한다. */
  var MDR_TAB = 'rep';
  function mdrShowTab(t){
    MDR_TAB = t;
    var btns = document.querySelectorAll('#mdrTabs .mdr-tab');
    for (var i = 0; i < btns.length; i++) btns[i].classList.toggle('on', btns[i].getAttribute('data-tab') === t);
    var panes = document.querySelectorAll('#mdrRoot [data-pane]');
    for (var j = 0; j < panes.length; j++) { if (panes[j].getAttribute('data-pane') === t) panes[j].removeAttribute('hidden'); else panes[j].setAttribute('hidden', ''); }
  }
  g('mdrTabs').addEventListener('click', function(e){ var b = e.target.closest ? e.target.closest('.mdr-tab') : null; if (b) mdrShowTab(b.getAttribute('data-tab')); });

  function printDir(){
    var clone = g('mdrRoot').cloneNode(true); var pn = clone.querySelectorAll('[data-pane]'); for (var k = 0; k < pn.length; k++) pn[k].removeAttribute('hidden');
    var body = clone.innerHTML;
    if (!body || body.indexOf('class="pg"') < 0) { _alertBox('먼저 청구세부통계를 불러오세요.', {icon:'📄'}); return; }
    var css = root.getElementsByTagName('style')[0].textContent +
      '@page{ size:A4 portrait; margin:0; } @media print{ #misDirRep .noprint{ display:none !important; } #misDirRep .pg{ padding:10mm !important; max-width:none !important; width:210mm !important; } #misDirRep .mdr-grid{ grid-template-columns:minmax(0,1fr) minmax(0,1fr) !important; } }';
    var w = window.open('', '_blank');
    if (!w) { _alertBox('팝업이 막혀 있습니다. 팝업을 허용한 뒤 다시 눌러 주세요.', {icon:'🚫'}); return; }
    var title = (root.getAttribute('data-nm') || '') + ' 청구세부통계';
    w.document.open();
    w.document.write('<!DOCTYPE html><html lang="ko"><head><meta charset="UTF-8"><title>' + esc(title) + '</title><style>' + css + '</style></head><body>' +
      '<div id="misDirRep"><div id="mdrRoot">' + body + '</div></div>' +
      '<scr' + 'ipt>window.addEventListener("load",function(){setTimeout(function(){window.print();},300);});' +
      'window.addEventListener("afterprint",function(){setTimeout(function(){window.close();},200);});</scr' + 'ipt></body></html>');
    w.document.close();
  }

  g('mdrPrint').onclick = printDir;
  g('mdrReload').onclick = function(){ load(ymOf(g('mdrFrom').value), ymOf(g('mdrYm').value)); };
  g('mdrGo').onclick = function(){ load(ymOf(g('mdrFrom').value), ymOf(g('mdrYm').value)); };
  /* 탭을 처음 열 때 한 번 불러온다(탭 전환 스크립트가 부른다) */
  window.misDirStart = function(){ if (!STARTED) { STARTED = true; load(); } };
})();
</script>
</div>
</div>
