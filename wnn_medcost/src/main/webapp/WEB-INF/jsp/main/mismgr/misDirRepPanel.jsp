<%@ page pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%-- misDirRepPanel.jsp — 경영고객관리 › 청구통계 › 🏥 청구세부통계 탭 (2026-10-15)
     · 병원장 조회(misDirector)와 같은 계산·같은 조회 API 를 쓴다(손익분기 관리 식, 분야별통계와 같은 청구 기준).
     · 출력 양식은 청구통계와 같은 A4 두 장. 세부 항목을 한 단계 더 넣었다:
       Ⅰ 수익·비용·손익 요약 · Ⅱ 12개월 추이 · Ⅲ 비용 지출 명세 · Ⅳ 수익 구성·손익분기 ·
       Ⅴ 청구 분석(유형·의사·질환 상세: 건당·환자당) · Ⅵ 일당청구액 · Ⅶ 약처방·정액 비청구 항목
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
  @media print{
    @page{ size:A4 portrait; margin:10mm; }
    #misDirRep{ background:#fff; padding:0; }
    #misDirRep .mdr-bar, #misDirRep .mdr-note{ display:none !important; }
    #misDirRep .pg{ border:none; border-radius:0; margin:0; padding:0; max-width:none; page-break-after:always; }
    #misDirRep .pg:last-child{ page-break-after:auto; }
    #misDirRep .pg h2{ -webkit-print-color-adjust:exact; print-color-adjust:exact; }
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
  <div id="mdrRoot"><div class="mdr-note" style="padding:20px 4px;">청구세부통계를 불러오는 중…</div></div>

<script>
(function(){
  var root = document.getElementById('misDirRep');
  if (!root) return;
  var WNN = root.getAttribute('data-wnn') === 'Y';
  var VAR_DEF = 25000;                       // 1인 1일 변동비 기본값 — 손익분기 관리(misCost)와 같다
  var D = null, C = null, T = null;          // D = directorGet 한 장, C = costGet(고정비), T = 청구 분석 묶음
  var STARTED = false, LOAD_REQ = 0;         // 늦게 온 옛 응답이 새 보고서를 덮지 않게 하는 순번

  function g(id){ return document.getElementById(id); }
  function esc(s){ return (s==null?'':String(s)).replace(/[&<>"]/g, function(c){ return ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;'})[c]; }); }
  function num(v){ return Number(v||0).toLocaleString('ko-KR'); }
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
  function secSummary(M, prevRev){
    var rows = [
      ['기간 수익', M.revenue ? num(M.revenue) + '원' : '—', M.tot ? '청구 총진료비 ' + eok(M.tot) + (M.extraTot ? ' + 추가수익 ' + man(M.extraTot) : '') : '청구 자료 없음'],
      ['기간 비용', M.expense ? num(M.expense) + '원' : '—', '고정비 ' + (M.fixedTot ? eok(M.fixedTot) : '—') + ' + 변동비 ' + (M.days ? man(M.varTot) : '—')],
      ['추정 손익', M.profit == null ? '—' : sgn(M.profit, num) + '원', M.profit == null ? '고정비를 입력하면 계산됩니다' : (M.profit >= 0 ? '흑자' : '적자') + ' · 수익 − 비용'],
      ['손익분기 재원 환자', M.bep ? M.bep + '명' : '—', M.bep ? '평균 재원 ' + Math.round(M.census) + '명 · ' + (M.census >= M.bep ? '여유 ' : '부족 ') + Math.abs(Math.round(M.census - M.bep)) + '명' : '고정비·청구가 둘 다 있어야 계산됩니다'],
      ['평균 재원 · 가동률', M.days ? Math.round(M.census) + '명' : '—', M.bed ? '병상 ' + M.bed + ' · 가동률 ' + pct(M.census, M.bed) : '병상 수를 손익분기 관리에서 입력하세요'],
      ['전월 수익', prevRev == null ? '—' : num(prevRev) + '원', (prevRev == null || !M.revenue) ? '전월 청구 자료 없음' : '기간과 차이 ' + sgn(M.revenue - prevRev, num) + '원']
    ];
    return '<h2>Ⅰ. 수익 · 비용 · 손익 요약</h2>' +
      '<table>' + head(['구분', '금액', '설명'], [2]) + '<tbody>' +
      rows.map(function(r){ return tr([esc(r[0]), r[1], esc(r[2])], '', [2]); }).join('') +
      '</tbody></table>' +
      (M.fixedTot ? '' : '<div class="sec-note">고정비가 아직 없어 비용·손익은 계산되지 않았습니다. 손익분기 관리에서 월 고정비를 입력하세요.</div>') +
      (M.bed ? '' : '<div class="sec-note">병상 수가 없어 가동률은 빈칸입니다.</div>');
  }

  /* ── Ⅱ 12개월 추이 ── */
  function secTrend(tr12){
    var body = tr12.map(function(r){
      var cls = r.rev == null ? 'sub' : '';
      return '<tr class="' + cls + '"><td>' + esc(ymLbl(r.ym)) + '</td><td class="n">' + (r.rev == null ? '—' : num(r.rev)) + '</td><td class="n">' + (r.exp == null ? '—' : num(r.exp)) + '</td><td class="n ' + (r.profit == null ? '' : (r.profit >= 0 ? 'up' : 'down')) + '">' + (r.profit == null ? '—' : sgn(r.profit, num)) + '</td></tr>';
    }).join('');
    return '<h2>Ⅱ. 기간 수익 · 비용 · 손익 추이 (조회 기간 월별)</h2>' +
      '<table>' + head(['월', '수익(원)', '비용(원)', '추정 손익(원)']) + '<tbody>' + body + '</tbody></table>' +
      '<div class="sec-note">수익 = 청구 총진료비 + 추가수익 · 비용 = 고정비 + 환자 변동비(1인 1일 ' + num(VAR_DEF) + '원 기본). 청구나 고정비가 없는 달은 —.</div>';
  }

  /* ── Ⅲ 비용 지출 명세 ── */
  function secExpense(M){
    var total = M.expense || 0, prevTotal = M.prevFixed;
    var rows = M.fixed.map(function(x){
      return tr([esc(x.nm), num(x.amt), x.prev == null ? '—' : num(x.prev), x.prev == null ? '—' : sgn(x.amt - x.prev, num), pct(x.amt, total)], '', []);
    });
    if (M.days) rows.push(tr(['환자 변동비 (1인 1일 ' + num(M.varC) + '원 × ' + num(M.days) + '일)', num(M.varTot), '—', '—', pct(M.varTot, total)], 'sub', []));
    if (!M.fixed.length && !M.days) rows.push(emptyRow(5, '고정비가 아직 입력되지 않았습니다. 손익분기 관리에서 항목별 금액을 적으면 여기 채워집니다.'));
    else rows.push(tr(['비용 합계', num(total), prevTotal == null ? '—' : num(prevTotal), '', '100%'], 'tot', []));
    return '<h2>Ⅲ. 비용 지출 명세</h2>' +
      '<table>' + head(['항목', '기간', '전월', '증감', '비중']) + '<tbody>' + rows.join('') + '</tbody></table>';
  }

  /* ── Ⅳ 수익 구성 · 손익분기 ── */
  function secRevenue(M, cl){
    var rev = M.revenue || 0, rows = [];
    if (cl) rows.push(tr(['총진료비 (청구)', num(M.tot), pct(M.tot, rev)], '', []));
    M.extra.forEach(function(x){ rows.push(tr([esc(x.nm) + ' <span class="sub">(추가수익)</span>', num(x.amt), pct(x.amt, rev)], '', [])); });
    if (!cl) rows.push(emptyRow(3, '청구 자료가 없어 수익을 계산하지 못했습니다. 청구 샘파일을 올리면 채워집니다.'));
    else rows.push(tr(['수익 합계', num(rev), '100%'], 'tot', []));
    var b = '<h2>Ⅳ. 수익 구성 · 손익분기(BEP)</h2>' +
      '<table>' + head(['항목', '금액(원)', '비중']) + '<tbody>' + rows.join('') + '</tbody></table>';
    if (M.bep) {
      var gap = M.census - M.bep;
      b += '<div class="sub2">손익분기(BEP)</div><table>' + head(['지표', '값', '의미'], [2]) + '<tbody>' +
        tr(['손익분기 재원 인원', M.bep + '명', '이 인원 이상 재원하면 고정비를 넘는다'], '', [2]) +
        tr(['평균 재원 (실제)', Math.round(M.census) + '명', '청구 재원일수 ÷ 그 달 일수'], '', [2]) +
        '<tr><td>' + (gap >= 0 ? '현재 여유' : '현재 부족') + ' (' + Math.round(M.census) + ' − ' + M.bep + ')</td><td class="n ' + (gap >= 0 ? 'up' : 'down') + '">' + (gap >= 0 ? '+' : '') + Math.round(gap) + '명</td><td>' + (gap >= 0 ? '손익분기보다 많이 재원 중' : '손익분기에 못 미침') + '</td></tr>' +
        tr(['환자 1인 1일 기여', num(Math.round(M.contrib)) + '원', '1인 1일 진료비 − 변동비'], '', [2]) +
        '</tbody></table>';
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
    var p51 = '<h2>Ⅴ-1. 유형별 청구</h2><table>' + head(['번호', '유형', '총액(원)', '건수', '건당(원)', '비중'], [1]) + '<tbody>' +
      (typ.length ? typ.map(function(r, i){ return tr([i + 1, esc(r.cformName || r.medName), num(r.totalAmt), num(r.claimCount), num(r.avgAmt), ratio(r.totalAmt, typSum)], '', [1]); }).join('') : emptyRow(6, '해당 자료가 없습니다.')) +
      '</tbody></table>';

    /* 5-2 의사별 — 면허번호 기준, 의사명이 없으면 면허 번호로 표시 */
    var doc = T.doc.filter(function(r){ return r.licenseNo && r.licenseNo !== '99'; })
                   .sort(function(a, b){ return Number(b.totalAmt||0) - Number(a.totalAmt||0); });
    var docSum = doc.reduce(function(s, r){ return s + Number(r.totalAmt||0); }, 0);
    var p52 = '<h2>Ⅴ-2. 의사별 청구 (상위 10 · 면허번호 기준)</h2><table>' + head(['번호', '의사', '총액(원)', '건수', '건당(원)', '비중'], [1]) + '<tbody>' +
      (doc.length ? doc.slice(0, 10).map(function(r, i){
        var nm = (r.licenseName && r.licenseName !== '전체') ? r.licenseName : ('면허 ' + r.licenseNo + ' (의사명 미등록)');
        return tr([i + 1, esc(nm), num(r.totalAmt), num(r.claimCount), num(r.avgAmt), ratio(r.totalAmt, docSum)], '', [1]);
      }).join('') : emptyRow(6, '해당 자료가 없습니다.')) +
      '</tbody></table>';

    out += '<div class="mdr-grid"><div>' + p51 + '</div><div>' + p52 + '</div></div>';
    if (part === 'top') return out;   // 5-1·5-2 만 (위쪽 줄)
    out = '';                         // 5-3 만 — 일당청구액 옆에 한 줄로 놓는다

    /* 5-3 질환별 — 건당·환자당까지 (청구통계 Ⅵ 과 다른 점: 등록된 질병코드만 개별, 나머지는 ZZ 한 줄) */
    var dis = T.dis.filter(function(r){ return r.diagName || r.diagCode; })
                   .sort(function(a, b){ return Number(b.totalAmt||0) - Number(a.totalAmt||0); });
    var disSum = T.dis.reduce(function(s, r){ return s + Number(r.totalAmt||0); }, 0);
    var hasZZ = dis.some(function(r){ return r.diagCode === 'ZZ'; });
    out += '<h2>Ⅴ-3. 질환별 청구 (상위 10 · 건당 · 환자당)</h2><table>' +
      head(['번호', '질환', '총액(원)', '건수', '환자', '건당(원)', '환자당(원)', '비중'], [1]) + '<tbody>' +
      (dis.length ? dis.slice(0, 10).map(function(r, i){
        var cnt = Number(r.claimCount||0), pts = Number(r.uniqPatients||0), amt = Number(r.totalAmt||0);
        return tr([i + 1, esc((r.diagCode ? r.diagCode + ' ' : '') + (r.diagName || '')), num(amt), num(cnt), num(pts),
          num(r.amtPerClaim != null ? r.amtPerClaim : (cnt ? Math.floor(amt / cnt) : 0)),
          num(r.amtPerPatient != null ? r.amtPerPatient : (pts ? Math.floor(amt / pts) : 0)), ratio(amt, disSum)], '', [1]);
      }).join('') : emptyRow(8, '해당 자료가 없습니다.')) +
      '</tbody></table>' +
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
      '<table>' + head(['월', '입원 총액(원)', '입원일수', '일당금액(원)', '명세서당 평균(원)']) + '<tbody>' +
      (body || emptyRow(5, '해당 자료가 없습니다.')) + '</tbody></table>';
  }

  /* ── Ⅶ 약처방 4분류 · 정액 비청구 항목 ── */
  function secDrug(){
    if (!T) return '<h2>Ⅶ. 약처방 · 정액 비청구</h2><div class="sec-note">자료를 불러오지 못했습니다.</div>';
    var t082 = totRow(arr(T.drug[0])), t08 = totRow(arr(T.drug[1])), t081 = totRow(arr(T.drug[2])), t083 = totRow(arr(T.drug[3]));
    var yk = function(t){ return t ? Number(t.yakAmt || 0) : null; };
    var rows = [];
    var line = function(name, total, nonclaim){
      if (total == null) { rows.push(tr([esc(name), '—', '—', '—', '—', '—'], '', [])); return; }
      var nc = nonclaim || 0, claim = total - nc;
      rows.push(tr([esc(name), num(total), num(claim), ratio(claim, total), num(nc), ratio(nc, total)], '', []));
    };
    line('정액환자', yk(t081), yk(t08));
    line('정율환자 (행위)', yk(t082), 0);
    line('전체환자', yk(t083), yk(t08));
    var items = T.item.filter(function(r){ return r.itemName && r.itemName !== '전체'; })
                      .sort(function(a, b){ return Number(b.totalAmt||0) - Number(a.totalAmt||0); }).slice(0, 12);
    var itemTot = T.item.filter(function(r){ return r.itemName === '전체'; })[0];
    var itemSum = itemTot ? Number(itemTot.totalAmt || 0) : items.reduce(function(s, r){ return s + Number(r.totalAmt||0); }, 0);
    var itemRows = items.map(function(r, i){
      return tr([i + 1, esc(r.codeName || ''), esc(r.itemName || ''), num(r.totalAmt), num(r.claimCount), ratio(r.totalAmt, itemSum)], '', [1, 2]);
    }).join('');
    var topHtml = '<h2>Ⅶ-1. 약처방 — 진료대비 약제비율 · 정액 비청구</h2>' +
      '<table>' + head(['구분', '약제비용(원)', '청구액(원)', '청구 비율', '비청구액(원)', '비청구 비율']) + '<tbody>' + rows.join('') + '</tbody></table>' +
      '<div class="sec-note">약제비용 = 처방 오더 금액에서 위탁청구(JS008)를 뺀 금액. 청구액 = 약제비용 − 비청구액. 비청구액 = 정액에 포함되어 따로 청구하지 않는 약(항목 L). 정율환자는 항목상 비청구 약이 확인되지 않아 전액 청구로 봤다.</div>';
    var disHtml = '<h2>Ⅶ-2. 정액 비청구분 항목별 — 약 말고 다른 처방 (상위 12)</h2>' +
      '<table style="width:100%;">' + head(['번호', '항목', '분류', '금액(원)', '건수', '비중'], [1, 2]) + '<tbody>' +
      (itemRows || emptyRow(6, '해당 자료가 없습니다.')) + '</tbody></table>';
    // 같은 줄에 좌(약처방 요약) · 우(정액 비청구분 항목별)
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
    g('mdrRoot').innerHTML = p1 + p2;
  }

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
      return loadAnalysis(my).then(function(){ if (my === LOAD_REQ) render(); });
    }, function(e){
      if (my !== LOAD_REQ) return;
      g('mdrRoot').innerHTML = '';
      g('mdrNote').hidden = false;
      g('mdrNote').textContent = '청구세부통계를 불러오지 못했습니다: ' + ((e && e.message) || '');
    });
  }

  function printDir(){
    var body = g('mdrRoot').innerHTML;
    if (!body || body.indexOf('class="pg"') < 0) { _alertBox('먼저 청구세부통계를 불러오세요.', {icon:'📄'}); return; }
    var css = root.getElementsByTagName('style')[0].textContent +
      '@page{ size:A4 portrait; margin:0; } @media print{ #misDirRep .pg{ padding:10mm !important; max-width:none !important; width:210mm !important; } #misDirRep .mdr-grid{ grid-template-columns:minmax(0,1fr) minmax(0,1fr) !important; } }';
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
