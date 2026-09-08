<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%-- qpsQiFund.jsp — QI 활동 자원지원 내역 (2026-08-11)

     연 1부. 원본 표 = 활동 | 총지원비 | 세부항목 | 금액.
     ★활동 하나에 세부항목이 여러 줄 붙는다(원본은 활동 칸이 세로로 병합돼 있다).
       화면은 평평한 그리드로 받고 **같은 활동번호끼리 인쇄에서 rowspan 으로 묶는다** —
       세로 병합을 입력 화면에서 흉내 내면 행 추가·삭제가 어려워진다.
     ★금액은 만원 단위. 총지원비는 세부항목 합이라 **자동 계산**한다(서버도 다시 셈한다).
     ★원본 3면 「영수증 1~4」는 공통 첨부로 대체(REF_GB='QIFUND').

     ★주의: 이 파일 안에서 Deferred EL 표기(샵+중괄호) 금지 --%>

<script src="/asset/js/ui-message.js"></script>
<%@ include file="/WEB-INF/jsp/main/inc/qpsFileBox.jsp" %>

<div class="dashboard-wrapper">
<div id="qpsQiFund" data-wnn="<c:out value='${wnnYn}'/>">
<style>
  #qpsQiFund{ background:#f4f6f8; color:#1f2a30; min-height:100%; padding:14px 16px 60px; max-width:100%; overflow-x:hidden; }
  #qpsQiFund *{ box-sizing:border-box; }
  #qpsQiFund .qf-head{ display:flex; align-items:center; gap:10px; margin-bottom:12px; flex-wrap:wrap; }
  #qpsQiFund .qf-title{ font-size:18px; font-weight:800; color:#20303a; display:flex; align-items:center; gap:8px; }
  #qpsQiFund .qf-dot{ width:10px; height:10px; border-radius:50%; background:linear-gradient(135deg,#1f5a4b,#2a7665); }
  #qpsQiFund .qf-sub{ font-size:12px; color:#6b7c86; }
  #qpsQiFund .qf-hosp{ background:#e7f3ee; color:#1f5a4b; font-size:12px; font-weight:800;
      border:1px solid #cfe3da; border-radius:14px; padding:3px 11px; }
  #qpsQiFund .qf-spacer{ flex:1; }
  #qpsQiFund select, #qpsQiFund input{
      border:1px solid #cfd8e0; border-radius:5px; padding:5px 7px; font-family:inherit; font-size:12.5px; background:#fff; }
  #qpsQiFund .qf-btn{ border:1px solid #1f5a4b; background:#1f5a4b; color:#fff; border-radius:6px;
      padding:6px 14px; font-size:13px; font-weight:600; cursor:pointer; white-space:nowrap; }
  #qpsQiFund .qf-btn.ghost{ background:#fff; color:#1f5a4b; }
  #qpsQiFund .qf-btn.mini{ padding:2px 9px; font-size:11.5px; border-color:#cfd8e0; color:#556570; background:#fff; }
  #qpsQiFund .qf-card{ background:#fff; border:1px solid #e3e9ed; border-radius:10px; padding:14px 16px; margin-bottom:12px; max-width:1000px; }
  #qpsQiFund .qf-card h4{ margin:0 0 10px; font-size:14px; font-weight:800; color:#1f5a4b; }
  #qpsQiFund .qf-card h4 .hint{ font-weight:500; font-size:12px; color:#8a99a3; }
  #qpsQiFund table.ed{ width:100%; border-collapse:collapse; font-size:12.5px; }
  #qpsQiFund table.ed th{ background:#f2f6f8; border:1px solid #dde5ea; padding:5px 6px; font-weight:700; color:#43555f; }
  #qpsQiFund table.ed td{ border:1px solid #e6ecef; padding:3px; }
  #qpsQiFund table.ed input{ width:100%; border:none; background:transparent; padding:4px 5px; }
  #qpsQiFund table.ed input:focus{ background:#f7fbf9; outline:1px solid #8fc3b2; }
  #qpsQiFund table.ed input.num{ text-align:right; }
  #qpsQiFund table.ed tr.newact td{ border-top:2px solid #cfd8e0; }
  #qpsQiFund .rowdel{ color:#b23b3b; cursor:pointer; font-weight:700; text-align:center; width:26px; }
  #qpsQiFund .tot{ background:#f7fbf9; font-weight:800; text-align:right; }
  /* ── 글자 크기 (2026-08-18 요청 「QI 에 글자 축소·확대가 없는 게 있다」)
       QI 계획서(qpsQiPlan)와 **같은 모양·같은 조작**이다 — 화면마다 다르면 손이 헷갈린다.
       ★탭 기능은 안 붙인다 — 이 화면은 카드가 둘뿐이라 한 화면에 들어간다. */
  #qpsQiFund .zz-zoom{ display:inline-flex; gap:4px; align-items:center; margin-left:2px; margin-right:14px; }
  #qpsQiFund .zz-zoom button{ border:1px solid #cfd9e0; background:#fff; color:#43555f; border-radius:6px;
                           padding:4px 9px; font-size:13px; font-weight:700; cursor:pointer; }
  #qpsQiFund .zz-zoom button:hover{ background:#eef3f6; }
</style>

<div class="qf-head">
  <div class="qf-title"><span class="qf-dot"></span>QI 활동 자원지원 내역 <span class="qf-sub">연 1부 · 만원 단위</span></div>
  <span class="qf-hosp" id="qfHosp">🏥 <c:out value="${hospNm}" default="병원 미확인"/></span>
  <div class="qf-spacer"></div>
  <select id="qfYear" style="width:auto;" onchange="qfLoad();"></select>
  <button type="button" class="qf-btn" onclick="qfSave();">저장</button>
  <button type="button" class="qf-btn ghost" onclick="qfPrint();">🖨 인쇄(A4)</button>
  <%-- ★화면 안 일괄 출력 (2026-09-08 — 확장 5호) : 저장된 해만 골라 한 번에 이어 인쇄. 아래 #qfBulkPrintBox 에 펼친다. --%>
  <button type="button" class="qf-btn ghost" onclick="qfBulkPrintToggle();" title="저장된 자원지원 내역을 연도 범위로 골라 한 번에 인쇄합니다">🖨 일괄 출력</button>
  <span class="qf-sub" id="qfStat"></span>
  <span style="flex:0 0 12px;"></span>
  <%-- 글자 크기 — 이 PC 이 브라우저에만 저장된다 --%>
  <span class="zz-zoom">
    <button type="button" onclick="zzZoom(-1);" title="글자 작게">가－</button>
    <button type="button" onclick="zzZoom(1);"  title="글자 크게">가＋</button>
    <button type="button" onclick="zzZoom(0);"  title="처음 크기로">↺</button>
  </span>
</div>
<%-- 🖨 화면 안 일괄 출력 조건 띠 (2026-09-08) — 「연 1부」 문서라 조건은 연도 범위뿐. 저장된 해만 담는다. --%>
<div id="qfBulkPrintBox" style="display:none; margin:6px 0 4px; padding:8px 12px; border:1px solid #b9cfe6; border-radius:8px; background:#eef4fb; font-size:12.5px; color:#1f2a37;">
  <div style="display:flex; align-items:center; gap:10px; flex-wrap:wrap;">
    <b style="color:#2f6fb0;">🖨 일괄 출력</b>
    <span>연도</span>
    <select id="qfBpFrom" style="width:auto;"></select><span>~</span><select id="qfBpTo" style="width:auto;"></select>
    <button type="button" class="qf-btn" id="qfBpGo" style="margin-left:auto;" onclick="qfBulkPrintGo();">출력</button>
    <button type="button" class="qf-btn ghost" onclick="qfBulkPrintToggle();">닫기</button>
  </div>
  <div style="margin-top:5px; font-size:11.5px; color:#5a6b7a;">저장된 해의 내역만 한 부씩 이어 붙여 한 번에 인쇄합니다(자료를 만들지 않음). 한 번에 120부까지. <span id="qfBpStat" style="color:#2f6fb0; font-weight:700;"></span></div>
</div>

<div class="qf-card">
  <h4>지원 내역
    <span class="hint">— 같은 활동에 세부항목이 여러 줄이면 <b>활동번호</b>를 같게 두세요. 인쇄에서 한 칸으로 묶입니다</span></h4>
  <table class="ed"><thead><tr>
    <th style="width:56px;">활동<br>번호</th><th style="width:200px;">활동</th>
    <th>세부항목</th><th style="width:120px;">금액(만원)</th><th style="width:26px;"></th>
  </tr></thead><tbody id="tbITEM"></tbody>
  <tfoot><tr><td colspan="3" class="tot">총지원비</td><td class="tot" id="qfTot">0</td><td></td></tr></tfoot></table>
  <button type="button" class="qf-btn mini" style="margin-top:6px;" onclick="qfAdd();">＋ 행 추가</button>
</div>

<div class="qf-card">
  <h4>영수증 · 첨부파일 <span class="hint">— 원본 3면의 「영수증 1~4」 자리를 첨부로 대신합니다</span></h4>
  <div id="qfFileBox"></div>
</div>

<script>
(function(){
  var HOSP_NM = '', APPR_LINE = [];

  var fileBox = window.qpsFileBox({ mount:'qfFileBox', refGb:'QIFUND',
      hint:'영수증', needSaveMsg:'년도를 선택하면 첨부할 수 있습니다.' });

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
  function num(v){ return (v==null||v===''||isNaN(v)) ? '' : Number(v).toLocaleString(); }

  (function(){
    var y = new Date().getFullYear(), sel = gel('qfYear');
    for (var i = y + 1; i >= y - 4; i--) sel.add(new Option(i + '년', i));
    qpsPickYear(sel, y);   /* 주소의 ?yy= 가 있으면 그 해로(일괄 출력, 2026-09-07) */
  })();

  function row(r){
    r = r || {};
    var tr = document.createElement('tr');
    tr.innerHTML =
      '<td><input class="num" data-f="actno" value="' + esc(r.actno == null ? '' : r.actno) + '" style="text-align:center;"></td>' +
      '<td><input data-f="actnm" value="' + esc(r.actnm) + '"></td>' +
      '<td><input data-f="detailnm" value="' + esc(r.detailnm) + '"></td>' +
      '<td><input class="num" data-f="amt" value="' + esc(r.amt == null ? '' : r.amt) + '"></td>' +
      '<td class="rowdel" onclick="this.closest(\'tr\').remove(); qfRecalc();">✕</td>';
    gel('tbITEM').appendChild(tr);
  }
  window.qfAdd = function(){
    // 새 행의 활동번호는 마지막 행을 따라간다 — 같은 활동의 세부항목을 잇달아 적는 게 보통이다
    var rows = gel('tbITEM').rows, last = rows.length ? readRow(rows[rows.length - 1]) : {};
    row({ actno: last.actno || 1 });
    paint();
  };

  function readRow(tr){
    var r = {};
    tr.querySelectorAll('[data-f]').forEach(function(el){ r[el.getAttribute('data-f')] = String(el.value).trim(); });
    return r;
  }
  function collect(){
    var out = [], sort = 0;
    Array.prototype.forEach.call(gel('tbITEM').rows, function(tr){
      var r = readRow(tr);
      var has = (r.actnm || r.detailnm || r.amt);
      if (!has) return;
      r.sort = ++sort;
      r.actno = r.actno || 1;
      out.push(r);
    });
    return out;
  }

  /** 활동이 바뀌는 줄에 굵은 선 — 인쇄에서 묶이는 단위를 화면에서도 보이게 */
  function paint(){
    var prev = null;
    Array.prototype.forEach.call(gel('tbITEM').rows, function(tr){
      var a = readRow(tr).actno;
      tr.classList.toggle('newact', prev !== null && a !== prev);
      prev = a;
    });
  }
  window.qfRecalc = function(){
    var t = 0;
    Array.prototype.forEach.call(gel('tbITEM').rows, function(tr){
      var v = Number(readRow(tr).amt); if (!isNaN(v)) t += v;
    });
    gel('qfTot').textContent = t.toLocaleString();
    paint();
  };

  gel('qpsQiFund').addEventListener('input', function(e){
    if (e.target.closest('#tbITEM tr')) qfRecalc();
  });

  var LOAD_REQ = 0;   // 조회 순번 — 늦게 온 옛 응답이 새 목록·문서를 덮지 않게(2026-09-08, 일괄 출력에서 실제로 겪음)
  window.qfLoad = function(){
    var my = ++LOAD_REQ;
    if (fileBox) fileBox.setKey(gel('qfYear').value);
    LAST_DOC = false;   // ★먼저 내린다 — 조회가 실패하면(err 가 삼켜 resolve 로 온다) 앞 해의 값이 남아 잘못 찍힌다
    return post('<c:url value="/qps/qiFundGet.do"/>', { inYear: gel('qfYear').value }).then(function(res){
      if (my !== LOAD_REQ) return;   // 더 새 조회가 나갔다 — 옛 응답은 버린다(2026-09-08)
      if (res.hosp) { HOSP_NM = res.hosp.hospnm || ''; gel('qfHosp').textContent = '🏥 ' + HOSP_NM; }
      APPR_LINE = res.line || [];
      var d = res.doc, items = res.items || [];
      LAST_DOC = !!d;
      gel('tbITEM').innerHTML = '';
      (items.length ? items : [{actno:1},{actno:1},{actno:2},{actno:2}]).forEach(row);
      gel('qfStat').textContent = d ? ('최종수정 ' + (d.upddttm || '')) : '작성 전';
      qfRecalc();
    }).catch(err);
  };

  window.qfSave = function(){
    var rows = collect();
    if (!rows.length) { _alertBox('저장할 내용이 없습니다.', {icon:'⚠️'}); return; }
    post('<c:url value="/qps/qiFundSave.do"/>', {
      inYear: gel('qfYear').value, items: JSON.stringify(rows)
    }).then(function(){
      _toast('저장되었습니다.', 'ok');
      return qfLoad();
    }).catch(err);
  };

  /* ═══ 🖨 화면 안 일괄 출력 (2026-09-08 — 확장 5호 · 연 문서형) ═══
     「연 1부」라 목록이 없다. 해를 하나씩 열어(qfLoad) **저장된 해만**(LAST_DOC) 낱장 인쇄(qfPrint)를 QPS_BULK_CB 로 모아
     끝에 qpsPrintMerge(sidebar.jsp)로 한 문서. 빈 해는 기본 줄 넷이 깔려 있어 그대로 찍으면 빈 표가 섞인다.
     끝나면 보던 해로 되돌린다. 상한 120부. */
  window.BP = { busy:false };
  var LAST_DOC = false;   // 지금 보이는 해에 저장된 내역이 있는가 — 일괄 출력이 빈 해를 거른다
  function bpFill(){
    var yf = gel('qfBpFrom'), yt = gel('qfBpTo');
    if (yf.options.length) return;
    Array.prototype.forEach.call(gel('qfYear').options, function(o){ yf.add(new Option(o.text, o.value)); yt.add(new Option(o.text, o.value)); });
  }
  window.qfBulkPrintToggle = function(){
    var box = gel('qfBulkPrintBox');
    if (box.style.display !== 'none') { box.style.display = 'none'; return; }
    bpFill();
    gel('qfBpFrom').value = gel('qfYear').value; gel('qfBpTo').value = gel('qfYear').value;
    gel('qfBpStat').textContent = '';
    box.style.display = '';
  };
  window.qfBulkPrintGo = function(){
    if (BP.busy) return;
    var f = Number(gel('qfBpFrom').value), t = Number(gel('qfBpTo').value);
    if (f > t) { var x = f; f = t; t = x; gel('qfBpFrom').value = String(f); gel('qfBpTo').value = String(t); }
    var keepYear = gel('qfYear').value;
    var title = 'QI자원지원내역_' + (f === t ? (f + '년') : (f + '~' + t + '년')) + '_' + HOSP_NM;
    var years = [];
    for (var y = f; y <= t; y++) years.push(String(y));
    var parts = [], MAX = 120, done = 0, stat = gel('qfBpStat'), yi = 0;
    BP.busy = true; gel('qfBpGo').disabled = true;
    window.QPS_BULK_CB = function(p){ parts.push(p); };
    var finish = function(){
      window.QPS_BULK_CB = null;
      gel('qfYear').value = keepYear;                     // 보던 해로
      Promise.resolve(qfLoad()).then(function(){
        BP.busy = false; gel('qfBpGo').disabled = false;
        if (!parts.length) { stat.textContent = '기간 안에 저장된 내역이 없습니다.'; return; }
        var n = qpsPrintMerge(parts, title);
        stat.textContent = (n < 0) ? '팝업이 막혀 인쇄창을 열지 못했습니다.' :
                           (parts.length + '부를 이어 붙였습니다' + (done >= MAX ? ' (상한 ' + MAX + '부)' : '') + '.');
      }, function(){ BP.busy = false; gel('qfBpGo').disabled = false; });
    };
    var oneYear = function(){
      if (yi >= years.length || done >= MAX) { finish(); return; }
      var yy = years[yi++];
      gel('qfYear').value = yy;
      stat.textContent = yy + '년 읽는 중 …';
      Promise.resolve(qfLoad()).then(function(){
        if (LAST_DOC) { try { qfPrint(); done++; } catch (e) { } }
        stat.textContent = yy + '년 — ' + done + '부';
        oneYear();
      }, function(){ oneYear(); });
    };
    oneYear();
  };

  // ---------- 인쇄 — 같은 활동번호를 rowspan 으로 묶는다(원본의 세로 병합) ----------
  var PRINT_CSS =
    '@page{ size:A4 portrait; margin:12mm; }' +
    'body{ margin:0; font-family:"맑은 고딕",Malgun Gothic,sans-serif; color:#000; }' +
    '.h1{ font-size:16px; font-weight:800; text-align:center; margin:0 0 10px; }' +
    'table{ width:100%; border-collapse:collapse; font-size:10.5px; }' +
    'th,td{ border:1px solid #666; padding:4px 5px; text-align:center; vertical-align:middle; }' +
    'th{ background:#efefef; font-weight:700; }' +
    'td.l{ text-align:left; } td.r{ text-align:right; }' +
    'tr{ page-break-inside:avoid; }';

  window.qfPrint = function(){
    var yy = gel('qfYear').value, rows = collect();
    // 같은 활동번호끼리 묶는다
    var groups = [], cur = null;
    rows.forEach(function(r){
      if (!cur || String(r.actno) !== String(cur.actno)) { cur = { actno:r.actno, actnm:r.actnm, rows:[] }; groups.push(cur); }
      if (!cur.actnm && r.actnm) cur.actnm = r.actnm;   // 활동명은 묶음 안 어디에 적혀 있어도 된다
      cur.rows.push(r);
    });
    var tot = 0;
    var body = groups.map(function(g){
      var sub = 0;
      g.rows.forEach(function(r){ var v = Number(r.amt); if (!isNaN(v)) sub += v; });
      tot += sub;
      return g.rows.map(function(r, i){
        var head = (i === 0)
          ? '<td class="l" rowspan="' + g.rows.length + '">' + esc(g.actnm || '') + '</td>' +
            '<td class="r" rowspan="' + g.rows.length + '">' + sub.toLocaleString() + ' 만원</td>'
          : '';
        return '<tr>' + head + '<td class="l">' + esc(r.detailnm || '') + '</td>' +
               '<td class="r">' + num(r.amt) + ' 만원</td></tr>';
      }).join('');
    }).join('');

    var html = '<div class="h1">' + esc(yy) + ' 년 질향상 활동 자원지원 내역</div>' +
      '<table><thead><tr><th style="width:26%;">활동</th><th style="width:18%;">총지원비</th>' +
      '<th>세부항목</th><th style="width:18%;">금액</th></tr></thead><tbody>' +
      (body || '<tr><td colspan="4" style="padding:20px;color:#666;">내역이 없습니다.</td></tr>') +
      '<tr><th>총지원비</th><th class="r">' + tot.toLocaleString() + ' 만원</th><td></td><td></td></tr>' +
      '</tbody></table>' +
      '<div style="font-size:10px;color:#444;margin-top:6px;">※ 영수증은 첨부파일로 관리합니다.</div>';

    var title = ('QI활동자원지원내역_' + yy + '_' + HOSP_NM).replace(/[\\\/:*?"<>|]/g, '-');
    qpsPrintOut(title, PRINT_CSS, html);   /* 낱장 인쇄·일괄 출력 공통(2026-09-07) */
  };

  $(function(){ qfLoad(); });
})();

/* ═══ 글자 크기 (2026-08-18 요청) ═══════════════════════════════════════
   QI 계획서(qpsQiPlan)의 zzZoom 과 **같은 규칙** — 0.8~1.6배, 0.1 단위, ↺ 는 처음 크기.
   ★고른 크기는 **이 PC 이 브라우저에만** 남는다(localStorage). 서버에 저장하지 않는다.
   ★키를 화면마다 따로 둔다 — 표가 넓은 화면과 좁은 화면의 알맞은 배율이 다르다. */
(function(){
  var W = 'qpsQiFund', ZKEY = 'qpsZoom_' + W;
  /* ⚠**같은 화면이 두 벌 붙어 있을 수 있다**(주소 숨김 구조 - content 를 갈아끼운다).
     getElementById 는 「첫 번째 = 보이지 않는 사본」을 잡아 ***눌러도 아무 일이 없다.***
     ⇒ querySelectorAll 로 **붙어 있는 사본 전부**에 건다. */
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
</div><%-- /#qpsQiFund --%>
</div><%-- /.dashboard-wrapper --%>
