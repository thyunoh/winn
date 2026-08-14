<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%-- qpsCmplRpt.jsp — 불만고충 지표분석보고서 (2026-08-11)

     ★원본 3종(무제 · 전반기 · 후반기)을 <한 화면 + 반기 구분>으로 덮는다.
       기본형(무제)은 구버전이다 — 항목 번호가 1,2,2,4,5 로 오타이고 코드값도 옛것이라
       ***전반기형을 정본으로 삼는다***(2026-08-10 판단). 번호는 1~7 로 바로잡았다.

     ★수치는 하나도 저장하지 않는다. 전부 처리대장에서 조회 시 집계한다.
       사람이 쓰는 칸(목표·개선전략·결론·개선활동 표)만 TBL_QPS_CMPL_RPT 에 담는다.
     ★지표정의·모니터링 블록은 지표정의서(INDI_CD='CLAIM')를 그대로 가져다 쓴다 —
       만족도 지표분석 보고서와 같은 방식. 같은 문구를 두 곳에서 관리하지 않는다.
     ★0건이면 '-' 로 찍는다(원본은 서식마다 NAN·0.0 이 뒤섞여 있었다).

     ★주의: 이 파일 안에서 Deferred EL 표기(샵+중괄호) 금지 --%>

<script src="/asset/js/ui-message.js"></script>

<div class="dashboard-wrapper">
<div id="qpsCmplRpt" data-wnn="<c:out value='${wnnYn}'/>">
<style>
  #qpsCmplRpt{ background:#f4f6f8; color:#1f2a30; min-height:100%; padding:14px 16px 60px; max-width:100%; overflow-x:hidden; }
  #qpsCmplRpt *{ box-sizing:border-box; }
  #qpsCmplRpt .cr-head{ display:flex; align-items:center; gap:10px; margin-bottom:12px; flex-wrap:wrap; }
  #qpsCmplRpt .cr-title{ font-size:18px; font-weight:800; color:#20303a; display:flex; align-items:center; gap:8px; }
  #qpsCmplRpt .cr-dot{ width:10px; height:10px; border-radius:50%; background:linear-gradient(135deg,#1f5a4b,#2a7665); }
  #qpsCmplRpt .cr-sub{ font-size:12px; color:#6b7c86; }
  #qpsCmplRpt .cr-hosp{ background:#e7f3ee; color:#1f5a4b; font-size:12px; font-weight:800;
      border:1px solid #cfe3da; border-radius:14px; padding:3px 11px; }
  #qpsCmplRpt .cr-spacer{ flex:1; }
  #qpsCmplRpt select, #qpsCmplRpt input, #qpsCmplRpt textarea{
      border:1px solid #cfd8e0; border-radius:5px; padding:5px 7px; font-family:inherit; font-size:12.5px; background:#fff; }
  #qpsCmplRpt textarea{ resize:vertical; line-height:1.55; width:100%; }
  #qpsCmplRpt .cr-btn{ border:1px solid #1f5a4b; background:#1f5a4b; color:#fff; border-radius:6px;
      padding:6px 14px; font-size:13px; font-weight:600; cursor:pointer; white-space:nowrap; }
  #qpsCmplRpt .cr-btn.ghost{ background:#fff; color:#1f5a4b; }

  #qpsCmplRpt .cr-card{ background:#fff; border:1px solid #e3e9ed; border-radius:10px; padding:14px 16px; margin-bottom:12px; }
  #qpsCmplRpt .cr-card h4{ margin:0 0 10px; font-size:14px; font-weight:800; color:#1f5a4b; }
  #qpsCmplRpt .cr-card h4 .hint{ font-weight:500; font-size:12px; color:#8a99a3; }
  #qpsCmplRpt .cr-form{ display:grid; grid-template-columns:130px 1fr; gap:9px 10px; align-items:start; }
  #qpsCmplRpt .cr-form .lb{ font-size:12.5px; font-weight:700; color:#43555f; padding-top:8px; }

  #qpsCmplRpt table.st{ width:100%; border-collapse:collapse; font-size:12px; margin-bottom:10px; }
  #qpsCmplRpt table.st th, #qpsCmplRpt table.st td{ border:1px solid #dfe4ea; padding:5px 6px; text-align:center; }
  #qpsCmplRpt table.st th{ background:#f2f6f8; font-weight:700; color:#43555f; white-space:nowrap; }
  #qpsCmplRpt table.st td.l{ text-align:left; }
  #qpsCmplRpt table.st tr.tot td, #qpsCmplRpt table.st tr.tot th{ background:#f7fbf9; font-weight:800; }
  #qpsCmplRpt .barbox{ display:inline-block; width:90px; height:10px; background:#e9edf0; vertical-align:middle; }
  #qpsCmplRpt .bar{ display:inline-block; height:10px; background:#1f5a4b; }
  #qpsCmplRpt .grid2{ display:grid; grid-template-columns:1fr 1fr; gap:14px; }
  @media (max-width:1100px){ #qpsCmplRpt .grid2{ grid-template-columns:1fr; } }
  #qpsCmplRpt .none{ color:#8a99a3; font-size:12.5px; padding:14px 4px; text-align:center; }
</style>

<div class="cr-head">
  <div class="cr-title"><span class="cr-dot"></span>불만고충 지표분석보고서
    <span class="cr-sub">수치는 처리대장에서 자동 집계</span></div>
  <span class="cr-hosp" id="crHosp">🏥 <c:out value="${hospNm}" default="병원 미확인"/></span>
  <div class="cr-spacer"></div>
  <select id="crYear" style="width:auto;" onchange="crLoad();"></select>
  <%-- ★원본은 「전반기」·「후반기」가 별도 서식이지만 우리는 구분 하나로 덮는다 --%>
  <select id="crHalf" style="width:auto;" onchange="crLoad();">
    <option value="1">전반기 (1~6월)</option>
    <option value="2">후반기 (7~12월)</option>
  </select>
  <button type="button" class="cr-btn" onclick="crSave();">저장</button>
  <button type="button" class="cr-btn ghost" onclick="crPrint();">🖨 인쇄(A4)</button>
  <span class="cr-sub" id="crStat"></span>
</div>

<div class="cr-card">
  <h4>지표 정의 · 모니터링 <span class="hint">— 지표정의서(불만 및 고충처리 처리율)에서 가져옵니다. 고치려면 [지표정의서] 화면에서</span></h4>
  <table class="st"><tbody id="crDefBody"><tr><td class="none">불러오는 중…</td></tr></tbody></table>
  <div class="cr-form">
    <div class="lb">목표</div>      <div><input type="text" id="f_goalVal" placeholder="예) 불만 및 고충처리 처리율 90 % 이상"></div>
    <div class="lb">제출일</div>    <div><input type="date" id="f_submitDt" style="width:auto;"></div>
  </div>
</div>

<div class="cr-card">
  <h4>[현황] <span class="hint">— 반기별 처리율. 연간 평균은 두 반기 합계로 계산합니다</span></h4>
  <table class="st" id="crHalfTbl"></table>
</div>

<div class="cr-card">
  <h4>[지표분석] (1) 월별 <span class="hint">— 불만 및 고충건수 · 처리건수 · 처리율</span></h4>
  <div style="overflow-x:auto;"><table class="st" id="crMonthTbl"></table></div>
</div>

<div class="grid2">
  <div class="cr-card"><h4>(2) 불만고충유형</h4><table class="st" id="crTypeTbl"></table></div>
  <div class="cr-card"><h4>(4) 접수유형</h4><table class="st" id="crRecvTbl"></table></div>
</div>

<div class="cr-card">
  <h4>(3) 월 × 유형 교차표</h4>
  <div style="overflow-x:auto;"><table class="st" id="crCrossTbl"></table></div>
</div>

<div class="grid2">
  <div class="cr-card"><h4>(5) 처리기간</h4><table class="st" id="crTermTbl"></table></div>
  <div class="cr-card"><h4>(6) 회신방법</h4><table class="st" id="crReplyTbl"></table></div>
</div>

<div class="cr-card"><h4>(7) 미회신 사유 <span class="hint">— 회신날짜가 비어 있는 건만 셉니다</span></h4>
  <table class="st" id="crNoReplyTbl"></table>
</div>

<div class="cr-card">
  <h4>서술 <span class="hint">— 사람이 쓰는 칸입니다. 위 수치는 저장되지 않고 볼 때마다 대장에서 다시 셉니다</span></h4>
  <div class="cr-form">
    <div class="lb">개선 전략 및 실행</div> <div><textarea id="f_strategyTxt" rows="4"></textarea></div>
    <div class="lb">결론 및 제언</div>     <div><textarea id="f_conclTxt" rows="4"></textarea></div>
    <div class="lb">개선활동 표</div>
    <div><textarea id="f_imprTxt" rows="4" placeholder="한 줄에 한 건 — 유형|불만고충 문제점|개선활동"></textarea></div>
  </div>
</div>

<script>
(function(){
  var HOSP_NM = '', APPR_LINE = [], CODES = {}, DEF = {}, STAT = {};

  function gel(id){ return document.getElementById(id); }   // ★$ 로 짓지 말 것
  function post(url, data){
    return $.ajax({ url:url, type:'POST', data:data, dataType:'json' }).then(function(res){
      if (res && res.result === 'FAIL') { throw new Error(res.message || '처리에 실패했습니다.'); }
      return res;
    });
  }
  function err(e){ _alertBox((e && e.message) ? e.message : '처리 중 오류가 발생했습니다.', {icon:'❌'}); }
  function esc(s){ return (s==null?'':String(s)).replace(/[&<>"]/g, function(c){
      return ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;'})[c]; }); }
  function val(id){ var e = gel(id); return e ? String(e.value).trim() : ''; }
  function set(id, v){ var e = gel(id); if (e) e.value = (v == null ? '' : v); }
  function n(v){ return Number(v || 0); }

  /** 0건이면 '-'. ★원본은 서식마다 NAN·0.0 이 뒤섞여 있었다 — 우리는 '-' 로 통일한다. */
  function pct(done, tot){ return n(tot) > 0 ? (n(done) / n(tot) * 100).toFixed(1) + ' %' : '-'; }
  function bar(v, max){
    var w = (n(max) > 0) ? Math.round(n(v) / n(max) * 90) : 0;
    return '<span class="barbox"><span class="bar" style="width:' + w + 'px;"></span></span>';
  }

  function codeRows(grp){ return CODES[grp] || []; }
  function codeNm(grp, cd){
    if (!cd) return '(미지정)';
    var rows = codeRows(grp);
    for (var i = 0; i < rows.length; i++) if (String(rows[i].subcode) === String(cd)) return rows[i].subcodenm;
    return cd;
  }

  (function(){
    var y = new Date().getFullYear(), sel = gel('crYear');
    for (var i = y + 1; i >= y - 4; i--) sel.add(new Option(i + '년', i));
    sel.value = y;
    gel('crHalf').value = (new Date().getMonth() + 1) <= 6 ? '1' : '2';
  })();

  function months(){
    var h = gel('crHalf').value === '2' ? [7,8,9,10,11,12] : [1,2,3,4,5,6];
    return h.map(function(m){ return { no:m, mm:(m < 10 ? '0' + m : String(m)) }; });
  }

  /** 축별 표 — 코드 목록을 순회해 0건 항목도 빠짐없이 보여준다(집계에 없다고 빠지면 안 된다). */
  function axisTable(elId, grp, rows, label){
    var byCd = {};
    (rows || []).forEach(function(r){ byCd[r.cd == null ? '' : String(r.cd)] = n(r.cnt); });
    var list = codeRows(grp).map(function(c){ return { cd:String(c.subcode), nm:c.subcodenm, cnt:n(byCd[String(c.subcode)]) }; });
    // 코드에 없는 값(미지정 포함)도 빠뜨리지 않는다
    Object.keys(byCd).forEach(function(k){
      if (!list.some(function(x){ return x.cd === k; })) list.push({ cd:k, nm:codeNm(grp, k), cnt:byCd[k] });
    });
    var tot = list.reduce(function(a, b){ return a + b.cnt; }, 0);
    var max = list.reduce(function(a, b){ return Math.max(a, b.cnt); }, 0);
    gel(elId).innerHTML =
      '<thead><tr><th>' + esc(label) + '</th><th style="width:70px;">건수</th>' +
      '<th style="width:70px;">비율</th><th style="width:104px;"></th></tr></thead><tbody>' +
      list.map(function(r){
        return '<tr><td class="l">' + esc(r.nm) + '</td><td>' + r.cnt + '</td>' +
               '<td>' + (tot > 0 ? (r.cnt / tot * 100).toFixed(1) + ' %' : '-') + '</td>' +
               '<td>' + bar(r.cnt, max) + '</td></tr>';
      }).join('') +
      '<tr class="tot"><td>합계</td><td>' + tot + '</td><td>' + (tot > 0 ? '100.0 %' : '-') + '</td><td></td></tr>' +
      '</tbody>';
    return list;
  }

  function render(){
    // [현황] 반기 — 집계는 연간 기준이라 두 반기가 다 온다
    var hf = { '1':{tot:0,done:0}, '2':{tot:0,done:0} };
    (STAT.half || []).forEach(function(r){ hf[String(r.half)] = { tot:n(r.tot), done:n(r.done) }; });
    var yTot = hf['1'].tot + hf['2'].tot, yDone = hf['1'].done + hf['2'].done;
    gel('crHalfTbl').innerHTML =
      '<thead><tr><th style="width:180px;">구분</th><th>전반기</th><th>후반기</th><th>연간</th>' +
      '<th style="width:110px;">목표값 달성여부</th></tr></thead><tbody>' +
      '<tr><td class="l">불만 및 고충건수</td><td>' + hf['1'].tot + '</td><td>' + hf['2'].tot + '</td><td>' + yTot + '</td><td>—</td></tr>' +
      '<tr><td class="l">불만 및 고충 처리건수</td><td>' + hf['1'].done + '</td><td>' + hf['2'].done + '</td><td>' + yDone + '</td><td>—</td></tr>' +
      '<tr class="tot"><td class="l">불만 및 고충처리 처리율</td><td>' + pct(hf['1'].done, hf['1'].tot) + '</td>' +
        '<td>' + pct(hf['2'].done, hf['2'].tot) + '</td><td>' + pct(yDone, yTot) + '</td>' +
        '<td>' + goalMet(yDone, yTot) + '</td></tr></tbody>';

    // (1) 월별
    var byMm = {};
    (STAT.months || []).forEach(function(r){ byMm[String(r.mm)] = r; });
    var ms = months(), mt = 0, md = 0;
    var head = '<thead><tr><th style="width:180px;">구분</th>';
    ms.forEach(function(m){ head += '<th>' + m.no + '월</th>'; });
    head += '<th style="width:70px;">총계</th></tr></thead>';
    var r1 = '<tr><td class="l">불만 및 고충건수(건)</td>', r2 = '<tr><td class="l">불만 및 고충처리 처리건수</td>',
        r3 = '<tr class="tot"><td class="l">불만 및 고충처리 처리율(%)</td>';
    ms.forEach(function(m){
      var r = byMm[m.mm] || {}; var t = n(r.tot), d = n(r.done);
      mt += t; md += d;
      r1 += '<td>' + t + '</td>'; r2 += '<td>' + d + '</td>'; r3 += '<td>' + pct(d, t) + '</td>';
    });
    gel('crMonthTbl').innerHTML = head + '<tbody>' +
      r1 + '<td>' + mt + '</td></tr>' + r2 + '<td>' + md + '</td></tr>' + r3 + '<td>' + pct(md, mt) + '</td></tr></tbody>';

    // (2)(4)(5)(6)(7) 축별 — ★원본의 번호 오타(1,2,2,4,5)는 바로잡아 1~7 로 붙였다
    axisTable('crTypeTbl',    'QPS_CMPL_TYPE',    STAT.axTYPE,    '불만고충유형');
    axisTable('crRecvTbl',    'QPS_CMPL_RECV',    STAT.axRECV,    '접수유형');
    axisTable('crTermTbl',    'QPS_CMPL_TERM',    STAT.term,      '처리기간');
    axisTable('crReplyTbl',   'QPS_CMPL_REPLY',   STAT.axREPLY,   '회신방법');
    axisTable('crNoReplyTbl', 'QPS_CMPL_NOREPLY', STAT.axNOREPLY, '미회신 사유');

    // (3) 월 × 유형 교차표
    var types = codeRows('QPS_CMPL_TYPE');
    var cross = {};
    (STAT.typeMonth || []).forEach(function(r){ cross[String(r.mm) + '|' + String(r.cd == null ? '' : r.cd)] = n(r.cnt); });
    var ch = '<thead><tr><th style="width:130px;">유형</th>';
    ms.forEach(function(m){ ch += '<th>' + m.no + '월</th>'; });
    ch += '<th style="width:64px;">합계</th></tr></thead><tbody>';
    var colTot = {}, grand = 0;
    types.forEach(function(t){
      var sum = 0, tds = '';
      ms.forEach(function(m){
        var v = n(cross[m.mm + '|' + t.subcode]);
        sum += v; colTot[m.mm] = n(colTot[m.mm]) + v;
        tds += '<td>' + (v || '') + '</td>';
      });
      grand += sum;
      ch += '<tr><td class="l">' + esc(t.subcodenm) + '</td>' + tds + '<td>' + sum + '</td></tr>';
    });
    ch += '<tr class="tot"><td>합계</td>';
    ms.forEach(function(m){ ch += '<td>' + n(colTot[m.mm]) + '</td>'; });
    ch += '<td>' + grand + '</td></tr></tbody>';
    gel('crCrossTbl').innerHTML = ch;

    // 지표정의 · 모니터링 — 지표정의서(CLAIM)에서 온 값. 여기서는 고치지 않는다.
    var d = DEF || {};
    function cycNm(c){ return c === 'Q' ? '분기별' : c === 'H' ? '반기별' : c === 'Y' ? '연 1회' : (c || ''); }
    function tr(lb, v){ return '<tr><th style="width:150px;">' + lb + '</th><td class="l">' + esc(v || '—') + '</td></tr>'; }
    gel('crDefBody').innerHTML =
      tr('지표명', d.indinm || '불만 및 고충처리 처리율') +
      tr('지표정의', d.definition) + tr('분자정의', d.numerdesc) + tr('분모정의', d.denomdesc) +
      tr('지표관리자', d.ownernm) + tr('모니터링 주기', cycNm(d.cyclegb)) +
      tr('자료수집', d.sourcenm) + tr('통계적 기법과 도구', d.methodnm) +
      tr('기간', gel('crYear').value + '-' + (gel('crHalf').value === '2' ? '07-01 ~ ' : '01-01 ~ ') +
                 gel('crYear').value + (gel('crHalf').value === '2' ? '-12-31' : '-06-30'));
  }

  function goalMet(done, tot){
    var g = String(val('f_goalVal')).match(/([0-9]+(\.[0-9]+)?)/);
    if (!g || n(tot) <= 0) return '—';
    var rate = n(done) / n(tot) * 100;
    return (rate >= Number(g[1]))
      ? '<b style="color:#1f5a4b;">달성</b>' : '<b style="color:#b23b3b;">미달성</b>';
  }

  window.crLoad = function(){
    return post('<c:url value="/qps/cmplRptGet.do"/>',
        { inYear: gel('crYear').value, halfGb: gel('crHalf').value }).then(function(res){
      if (res.hosp) { HOSP_NM = res.hosp.hospnm || ''; gel('crHosp').textContent = '🏥 ' + HOSP_NM; }
      APPR_LINE = res.line || [];
      STAT = res.stat || {};
      var d = res.doc;
      set('f_submitDt', d ? d.submitdt : '');
      set('f_goalVal', d ? d.goalval : '');
      set('f_strategyTxt', d ? d.strategytxt : '');
      set('f_conclTxt', d ? d.concltxt : '');
      set('f_imprTxt', d ? d.imprtxt : '');
      gel('crStat').textContent = d ? ('최종수정 ' + (d.upddttm || '')) : '작성 전';
      render();
    }).catch(err);
  };

  window.crSave = function(){
    post('<c:url value="/qps/cmplRptSave.do"/>', {
      inYear: gel('crYear').value, halfGb: gel('crHalf').value,
      submitDt: val('f_submitDt'), goalVal: val('f_goalVal'),
      strategyTxt: val('f_strategyTxt'), conclTxt: val('f_conclTxt'), imprTxt: val('f_imprTxt')
    }).then(function(){
      _toast('저장되었습니다.', 'ok');
      return crLoad();
    }).catch(err);
  };

  // ---------- 인쇄(A4) ----------
  var PRINT_CSS =
    '@page{ size:A4 portrait; margin:12mm 12mm 14mm; }' +
    'body{ margin:0; font-family:"맑은 고딕",Malgun Gothic,sans-serif; color:#000; }' +
    '.h1{ font-size:17px; font-weight:800; text-align:center; margin:0 0 10px; letter-spacing:1px; }' +
    '.sec{ font-size:12.5px; font-weight:800; margin:10px 0 4px; padding-bottom:2px; border-bottom:1.5px solid #333; }' +
    'table{ width:100%; border-collapse:collapse; font-size:10px; margin-bottom:6px; }' +
    'th,td{ border:1px solid #666; padding:3px 4px; text-align:center; vertical-align:middle; line-height:1.5; }' +
    'th{ background:#efefef; font-weight:700; }' +
    'td.l{ text-align:left; } td.pre{ text-align:left; white-space:pre-wrap; min-height:40px; }' +
    '.appr{ float:right; width:auto; margin:0 0 6px 8px; font-size:10px; }' +
    '.appr th{ padding:2px 6px; } .appr td{ height:44px; width:60px; }' +
    '.brk{ page-break-before:always; }' +
    'tr{ page-break-inside:avoid; }';

  function apprHtml(){
    if (!APPR_LINE.length) return '';
    var h = '<table class="appr"><thead><tr>';
    APPR_LINE.forEach(function(r){ h += '<th>' + esc(r.stepnm) + '</th>'; });
    h += '</tr></thead><tbody><tr>';
    APPR_LINE.forEach(function(){ h += '<td></td>'; });
    return h + '</tr></tbody></table>';
  }
  /** 화면 표를 그대로 인쇄에 싣는다 — 같은 집계를 두 번 계산하면 어긋날 길이 생긴다. */
  function tbl(id){ return '<table>' + gel(id).innerHTML + '</table>'; }

  window.crPrint = function(){
    var yy = gel('crYear').value, half = (gel('crHalf').value === '2') ? '후반기' : '전반기';
    function box(v){ return '<div style="border:1px solid #666;padding:5px 7px;font-size:10px;white-space:pre-wrap;text-align:left;min-height:38px;">' + esc(v) + '</div>'; }

    var imprRows = String(val('f_imprTxt')).split('\n').map(function(s){ return s.trim(); }).filter(function(s){ return s; });
    var imprTbl = '<table><thead><tr><th style="width:110px;">유형</th><th>불만고충 문제점</th>' +
      '<th>개선활동</th></tr></thead><tbody>' +
      (imprRows.length ? imprRows : ['']).map(function(ln){
        var p = ln.split('|');
        return '<tr><td>' + esc(p[0] || '') + '</td><td class="l">' + esc(p[1] || '') +
               '</td><td class="l">' + esc(p[2] || '') + '</td></tr>';
      }).join('') + '</tbody></table>';

    var body = apprHtml() +
      '<div class="h1">' + esc(yy) + '년 ' + half + ' 불만고충 지표 분석 보고서</div>' +
      '<div style="clear:both;"></div>' +
      '<div class="sec">[지표정의] · [모니터링]</div><table>' + gel('crDefBody').innerHTML + '</table>' +
      '<table><tbody><tr><th style="width:150px;">목표</th><td class="l">' + esc(val('f_goalVal')) + '</td></tr>' +
      '<tr><th>제출일</th><td class="l">' + esc(val('f_submitDt')) + '</td></tr></tbody></table>' +
      '<div class="sec">[현황]</div>' + tbl('crHalfTbl') +
      '<div class="sec">[지표분석] (1) 월별</div>' + tbl('crMonthTbl') +
      '<div class="brk"></div>' +
      '<div class="sec">(2) 불만고충유형</div>' + tbl('crTypeTbl') +
      '<div class="sec">(3) 월 × 유형</div>' + tbl('crCrossTbl') +
      '<div class="sec">(4) 접수유형</div>' + tbl('crRecvTbl') +
      '<div class="sec">(5) 처리기간</div>' + tbl('crTermTbl') +
      '<div class="brk"></div>' +
      '<div class="sec">(6) 회신방법</div>' + tbl('crReplyTbl') +
      '<div class="sec">(7) 미회신 사유</div>' + tbl('crNoReplyTbl') +
      '<div class="sec">개선 전략 및 실행</div>' + box(val('f_strategyTxt')) +
      '<div class="sec">결론 및 제언</div>' + box(val('f_conclTxt')) +
      '<div class="brk"></div><div class="sec">개선활동</div>' + imprTbl +
      '<div style="text-align:center;font-size:11px;font-weight:700;margin-top:10mm;">' + esc(HOSP_NM) + '</div>';

    var title = ('불만고충지표분석_' + yy + '_' + half + '_' + HOSP_NM).replace(/[\\\/:*?"<>|]/g, '-');
    var w = window.open('', '_blank', 'width=900,height=1000');
    if (!w) { _alertBox('팝업이 차단되어 인쇄창을 열지 못했습니다.<br>주소창 오른쪽의 팝업 차단을 허용해 주세요.', {icon:'⚠️'}); return; }
    w.document.open();
    w.document.write('<!doctype html><html lang="ko"><head><meta charset="utf-8"><title>' + esc(title) +
      '</title><style>' + PRINT_CSS + '</style></head><body>' + body + '</body></html>');
    w.document.close();
    w.focus();
    setTimeout(function(){ try { w.print(); } catch (e) { } }, 300);
  };

  // 목표를 고치면 달성여부 판정이 바로 바뀌게
  gel('f_goalVal').addEventListener('input', function(){ if (STAT.half) render(); });

  // 코드 → 정의서 → 본문. 축별 표가 코드 목록을 순회하므로 코드가 먼저 있어야 한다.
  $(function(){
    post('<c:url value="/qps/codeList.do"/>', {}).then(
      function(res){ CODES = (res && res.codes) || {}; step2(); },
      function(){ CODES = {}; step2(); }
    );
    function step2(){
      post('<c:url value="/qps/indiDefGet.do"/>', { indiCd:'CLAIM' }).then(
        function(res){ DEF = (res && res.def) || {}; crLoad(); },
        function(){ DEF = {}; crLoad(); }
      );
    }
  });
})();
</script>
</div><%-- /#qpsCmplRpt --%>
</div><%-- /.dashboard-wrapper --%>
