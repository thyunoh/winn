<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%-- qpsInfRisk.jsp — 감염관리 우선순위 사정 도구 (2026-08-10)
     원본은 [기준표]와 [집계표] 두 문서다. 집계표는 기준표를 점수순으로 세운 것뿐이라
     한 화면에 탭으로 둔다 — 같은 자료를 두 번 입력할 이유가 없다.
     ★핵심 = 자동계산. 원본은 사람이 P×S×R 을 손으로 곱해 적는다.
       여기서는 세 값을 고르면 점수·등급이 즉시 나오고, 저장 시 <서버가 다시 계산>한다.
     ★주의: 이 파일 안에서 Deferred EL 표기(샵+중괄호) 금지 --%>

<script src="/asset/js/ui-message.js"></script>
<%@ include file="/WEB-INF/jsp/main/inc/qpsFileBox.jsp" %>

<div class="dashboard-wrapper">
<div id="qpsInfRisk" data-wnn="<c:out value='${wnnYn}'/>">
<style>
  #qpsInfRisk{ background:#f4f6f8; color:#1f2a30; min-height:100%; padding:14px 16px 60px; max-width:100%; overflow-x:hidden; }
  #qpsInfRisk *{ box-sizing:border-box; }
  #qpsInfRisk .rk-head{ display:flex; align-items:center; gap:10px; margin-bottom:12px; flex-wrap:wrap; }
  #qpsInfRisk .rk-title{ font-size:18px; font-weight:800; color:#20303a; display:flex; align-items:center; gap:8px; }
  #qpsInfRisk .rk-dot{ width:10px; height:10px; border-radius:50%; background:linear-gradient(135deg,#1f5a4b,#2a7665); }
  #qpsInfRisk .rk-sub{ font-size:12px; color:#6b7c86; }
  #qpsInfRisk .rk-hosp{ background:#e7f3ee; color:#1f5a4b; font-size:12px; font-weight:800;
      border:1px solid #cfe3da; border-radius:14px; padding:3px 11px; }
  #qpsInfRisk .rk-spacer{ flex:1; }
  #qpsInfRisk select, #qpsInfRisk input[type=text], #qpsInfRisk input[type=date]{
      border:1px solid #cfd8e0; border-radius:6px; padding:5px 8px; font-family:inherit; font-size:12.5px; background:#fff; }
  #qpsInfRisk .rk-btn{ border:1px solid #1f5a4b; background:#1f5a4b; color:#fff; border-radius:6px;
      padding:6px 14px; font-size:13px; font-weight:600; cursor:pointer; white-space:nowrap; }
  #qpsInfRisk .rk-btn.ghost{ background:#fff; color:#1f5a4b; }
  #qpsInfRisk .rk-btn.warn{ background:#fff; color:#b23b3b; border-color:#e0b4b4; }
  #qpsInfRisk .rk-card{ background:#fff; border:1px solid #e3e9ed; border-radius:10px; padding:14px 16px; margin-bottom:12px; }
  #qpsInfRisk .rk-card h4{ margin:0 0 10px; font-size:14px; font-weight:800; color:#1f5a4b; }
  #qpsInfRisk .rk-card h4 .hint{ font-weight:500; font-size:12px; color:#8a99a3; }

  #qpsInfRisk .rk-tabs{ display:flex; gap:6px; margin-bottom:10px; }
  #qpsInfRisk .rk-tab{ padding:6px 16px; border:1px solid #cfd8e0; border-radius:7px; background:#fff;
      font-size:13px; font-weight:700; color:#5a6a73; cursor:pointer; }
  #qpsInfRisk .rk-tab.on{ background:#1f5a4b; border-color:#1f5a4b; color:#fff; }

  #qpsInfRisk table.ed{ width:100%; border-collapse:collapse; font-size:12.5px; }
  #qpsInfRisk table.ed th{ background:#f2f6f8; border:1px solid #dde5ea; padding:5px 6px; font-weight:700; color:#43555f; }
  #qpsInfRisk table.ed td{ border:1px solid #e6ecef; padding:3px 5px; }
  #qpsInfRisk table.ed select{ width:100%; padding:3px 4px; font-size:12px; }
  #qpsInfRisk table.ed input[type=text]{ width:100%; border:none; background:transparent; padding:3px 4px; }
  #qpsInfRisk tr.grp td{ background:#eef4f2; font-weight:800; color:#1f5a4b; text-align:center; }
  #qpsInfRisk tr.sec td{ background:#e8f5e9; font-weight:700; color:#2e5c3e; }
  #qpsInfRisk .sc{ text-align:center; font-weight:800; font-variant-numeric:tabular-nums; }
  /* 등급 색 — 1~24 낮음 / 25~49 중간 / 50~74 높음 / 75~100 매우 위험 */
  #qpsInfRisk .lv1{ color:#4a7c59; } #qpsInfRisk .lv2{ color:#b0873b; }
  #qpsInfRisk .lv3{ color:#c25c2a; } #qpsInfRisk .lv4{ color:#b23b3b; }
  #qpsInfRisk .rk-legend{ font-size:11.5px; color:#6b7c86; margin-top:6px; }
  #qpsInfRisk .rk-empty{ color:#8a99a3; font-size:12.5px; padding:16px 6px; text-align:center; }
  /* -- 글자 크기 (2026-08-18 요청) : QI 계획서(qpsQiPlan)와 같은 모양.같은 조작 */
  #qpsInfRisk .zz-zoom{ display:inline-flex; gap:4px; align-items:center; margin-left:2px; margin-right:14px; }
  #qpsInfRisk .zz-zoom button{ border:1px solid #cfd9e0; background:#fff; color:#43555f; border-radius:6px;
                        padding:4px 9px; font-size:13px; font-weight:700; cursor:pointer; }
  #qpsInfRisk .zz-zoom button:hover{ background:#eef3f6; }
</style>

<div class="rk-head">
  <div class="rk-title"><span class="rk-dot"></span>감염관리 우선순위 사정 도구</div>
  <span class="rk-hosp">🏥 <c:out value="${hospNm}" default="병원 미확인"/></span>
  <div class="rk-spacer"></div>
  <label class="rk-sub">평가일시</label> <input type="date" id="rkEvalDt">
  <label class="rk-sub">평가위원</label> <input type="text" id="rkEvaluator" maxlength="100" style="width:150px;">
  <select id="rkYear" style="width:auto;" onchange="rkList();"></select>
  <select id="rkDoc" style="width:auto; min-width:150px;" onchange="rkOpen(this.value);"></select>
  <button type="button" class="rk-btn" onclick="rkSave();">저장</button>
  <button type="button" class="rk-btn ghost" onclick="rkNew();">＋ 새 평가</button>
  <button type="button" class="rk-btn warn" id="rkDelBtn" onclick="rkDel();" style="display:none;">삭제</button>
  <span class="rk-sub" id="rkStat"></span>
  <span style="flex:0 0 12px;"></span>
  <span style="flex:0 0 12px;"></span>
  <%-- 글자 크기 - 이 PC 이 브라우저에만 저장된다 --%>
  <span class="zz-zoom">
    <button type="button" onclick="zzZoom(-1);" title="글자 작게">가－</button>
    <button type="button" onclick="zzZoom(1);"  title="글자 크게">가＋</button>
    <button type="button" onclick="zzZoom(0);"  title="처음 크기로">↺</button>
  </span>
</div>

<div class="rk-tabs">
  <div class="rk-tab on" id="tabBase" onclick="rkTab('B');">기준표</div>
  <div class="rk-tab" id="tabSum" onclick="rkTab('S');">집계표 <span class="rk-sub">— 점수순</span></div>
</div>

<div class="rk-card" id="cardBase">
  <h4>위험 항목 평가 <span class="hint">— 세 값을 고르면 위험점수와 등급이 자동으로 나옵니다</span></h4>
  <div style="overflow-x:auto;">
  <table class="ed" style="min-width:960px;"><thead>
    <tr>
      <th style="width:54px;">번호</th><th style="min-width:230px;">위험 항목</th>
      <th style="width:150px;">발생·노출가능성<br><span style="font-weight:400;">(Probability) 1~5</span></th>
      <th style="width:150px;">심각성<br><span style="font-weight:400;">(Severity) 1~5</span></th>
      <th style="width:170px;">준비·대처기능<br><span style="font-weight:400;">(Preparedness) 1~4</span></th>
      <th style="width:78px;">위험점수</th><th style="width:88px;">등급</th><th style="min-width:130px;">비고</th>
    </tr>
  </thead><tbody id="rkBody"></tbody></table>
  </div>
  <div class="rk-legend">
    위험점수 = 발생가능성 × 심각성 × 준비·대처 (최대 100) ·
    <b class="lv1">1~24 낮은 위험</b> · <b class="lv2">25~49 중간 위험</b> ·
    <b class="lv3">50~74 높은 위험</b> · <b class="lv4">75~100 매우 위험</b>
  </div>
</div>

<div class="rk-card" id="cardSum" style="display:none;">
  <h4>집계표 <span class="hint">— 점수가 높은 항목부터. 개선 우선순위입니다</span></h4>
  <table class="ed"><thead><tr>
    <th style="width:60px;">순위</th><th style="width:60px;">번호</th><th>위험 항목</th>
    <th style="width:120px;">구역</th><th style="width:78px;">위험점수</th><th style="width:88px;">등급</th>
  </tr></thead><tbody id="sumBody"></tbody></table>
  <div class="rk-legend" id="sumStat"></div>
</div>

<div class="rk-card">
  <h4>첨부파일 <span class="hint">— 근거자료</span></h4>
  <div id="rkFileBox"></div>
</div>

<script>
(function(){
  var curSeq = 0, ITEMS = [];

  var fileBox = window.qpsFileBox({ mount:'rkFileBox', refGb:'INFRISK',
      hint:'근거자료', needSaveMsg:'평가를 먼저 저장하면 첨부할 수 있습니다.' });

  // ★hospCd 를 보내지 않는다(서버가 쿠키를 본다) · dataType:'json' 필수 — QPS 화면 공통 원칙
  function post(url, data){
    return $.ajax({ url:url, type:'POST', data:data, dataType:'json' }).then(function(res){
      if (res && res.result === 'FAIL') { throw new Error(res.message || '처리에 실패했습니다.'); }
      return res;
    });
  }
  function err(e){ try{ _alertBox((e && e.message) || '처리 중 오류가 발생했습니다.', {icon:'❌'}); }catch(x){ alert(e && e.message); } }
  function esc(s){ return (s==null?'':String(s)).replace(/[&<>"]/g, function(c){
      return ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;'})[c]; }); }

  /* 원본 기준표의 보기값 — 숫자만 두면 무슨 뜻인지 알 수 없어 말을 같이 적는다 */
  var P_OPT = ['거의없음','가끔있음','때때로있음','자주있음','지속적임'];
  var S_OPT = ['미약(insignificant)','약함(minor)','보통(moderate)','심각(major)','극심함(extreme)'];
  var R_OPT = ['준비됨 또는 불가능','일부준비·보완불가','일부준비·지원가능','준비안됨·지원가능'];

  /** 등급 — 원본 기준표의 4구간 */
  function level(sc){
    if (sc == null || sc === '') return { t:'-', c:'' };
    sc = Number(sc);
    if (sc >= 75) return { t:'매우 위험', c:'lv4' };
    if (sc >= 50) return { t:'높은 위험', c:'lv3' };
    if (sc >= 25) return { t:'중간 위험', c:'lv2' };
    return { t:'낮은 위험', c:'lv1' };
  }
  function opt(list, v, base){
    var h = '<option value=""></option>';
    for (var i=0;i<list.length;i++){
      var n = i + 1;
      h += '<option value="'+n+'"'+(String(v)===String(n)?' selected':'')+'>'+n+'-'+esc(list[i])+'</option>';
    }
    return h;
  }

  (function(){
    var y = new Date().getFullYear(), sel = document.getElementById('rkYear');
    for (var i=y+1; i>=y-3; i--) sel.add(new Option(i+'년', i));
    sel.value = y;
    var d = new Date();
    document.getElementById('rkEvalDt').value =
      d.getFullYear()+'-'+('0'+(d.getMonth()+1)).slice(-2)+'-'+('0'+d.getDate()).slice(-2);
  })();

  function drawRows(items){
    var tb = document.getElementById('rkBody'), h = '', lastGrp = '', lastSec = '';
    items.forEach(function(r, i){
      if (r.grpnm && r.grpnm !== lastGrp){
        h += '<tr class="grp"><td colspan="8">' + esc(r.grpnm) + '</td></tr>';
        lastGrp = r.grpnm; lastSec = '';
      }
      if (r.secnm && r.secnm !== lastSec){
        h += '<tr class="sec"><td>' + esc(r.seccd) + '</td><td colspan="7">' + esc(r.secnm) + '</td></tr>';
        lastSec = r.secnm;
      }
      var sc = (r.score == null || r.score === '') ? '' : r.score;
      var lv = level(sc);
      h += '<tr data-i="' + i + '">' +
           '<td class="sc">' + esc(r.itemno) + '</td>' +
           '<td><input type="text" data-f="itemnm" value="' + esc(r.itemnm) + '"></td>' +
           '<td><select data-f="pval">' + opt(P_OPT, r.pval) + '</select></td>' +
           '<td><select data-f="sval">' + opt(S_OPT, r.sval) + '</select></td>' +
           '<td><select data-f="rval">' + opt(R_OPT, r.rval) + '</select></td>' +
           '<td class="sc" data-c="score">' + esc(sc) + '</td>' +
           '<td class="sc ' + lv.c + '" data-c="lv">' + lv.t + '</td>' +
           '<td><input type="text" data-f="note" value="' + esc(r.note) + '"></td>' +
           '</tr>';
    });
    tb.innerHTML = h || '<tr><td colspan="8" class="rk-empty">항목이 없습니다.</td></tr>';
  }

  /** 세 값이 다 채워졌을 때만 점수를 낸다 — 빈 칸은 '평가 안 함'이지 0점이 아니다 */
  function calcRow(tr){
    var p = tr.querySelector('[data-f="pval"]').value;
    var s = tr.querySelector('[data-f="sval"]').value;
    var r = tr.querySelector('[data-f="rval"]').value;
    var sc = (p && s && r) ? (Number(p) * Number(s) * Number(r)) : '';
    var lv = level(sc === '' ? null : sc);
    tr.querySelector('[data-c="score"]').textContent = sc;
    var el = tr.querySelector('[data-c="lv"]');
    el.textContent = lv.t; el.className = 'sc ' + lv.c;
  }

  document.getElementById('rkBody').addEventListener('change', function(e){
    var tr = e.target.closest('tr[data-i]');
    if (tr) { calcRow(tr); drawSum(); }
  });

  function collect(){
    var out = [], sort = 0;
    document.querySelectorAll('#rkBody tr[data-i]').forEach(function(tr){
      var base = ITEMS[Number(tr.getAttribute('data-i'))] || {};
      var r = { sort: ++sort, grpnm: base.grpnm, seccd: base.seccd, secnm: base.secnm, itemno: base.itemno };
      tr.querySelectorAll('[data-f]').forEach(function(el){ r[el.getAttribute('data-f')] = String(el.value).trim(); });
      var sc = tr.querySelector('[data-c="score"]').textContent.trim();
      r.score = sc === '' ? null : Number(sc);
      out.push(r);
    });
    return out;
  }

  /** 집계표 — 점수순. 점수 없는 항목(미평가)은 빼고 센다. */
  function drawSum(){
    var rows = collect().filter(function(r){ return r.score != null; });
    rows.sort(function(a,b){ return b.score - a.score; });
    var tb = document.getElementById('sumBody');
    tb.innerHTML = rows.length ? rows.map(function(r, i){
      var lv = level(r.score);
      return '<tr><td class="sc">' + (i+1) + '</td><td class="sc">' + esc(r.itemno) + '</td>' +
             '<td>' + esc(r.itemnm) + '</td><td>' + esc(r.secnm) + '</td>' +
             '<td class="sc">' + r.score + '</td>' +
             '<td class="sc ' + lv.c + '">' + lv.t + '</td></tr>';
    }).join('') : '<tr><td colspan="6" class="rk-empty">평가된 항목이 없습니다. 기준표에서 세 값을 고르세요.</td></tr>';
    var all = collect().length, hi = rows.filter(function(r){ return r.score >= 50; }).length;
    document.getElementById('sumStat').textContent =
      '전체 ' + all + '개 중 평가 ' + rows.length + '개 · 높은 위험 이상 ' + hi + '개';
  }

  window.rkTab = function(t){
    var b = (t === 'B');
    document.getElementById('cardBase').style.display = b ? '' : 'none';
    document.getElementById('cardSum').style.display  = b ? 'none' : '';
    document.getElementById('tabBase').className = 'rk-tab' + (b ? ' on' : '');
    document.getElementById('tabSum').className  = 'rk-tab' + (b ? '' : ' on');
    if (!b) drawSum();
  };

  window.rkList = function(){
    return post('/qps/infRiskList.do', { inYear: document.getElementById('rkYear').value })
      .then(function(res){
        var list = res.list || [], sel = document.getElementById('rkDoc');
        sel.innerHTML = '<option value="">— 새 평가 —</option>';
        list.forEach(function(r){ sel.add(new Option(r.evaldt + (r.evaluator ? ' · ' + r.evaluator : ''), r.riskseq)); });
        sel.value = curSeq ? String(curSeq) : '';
      }).catch(err);
  };

  window.rkOpen = function(seq){
    post('/qps/infRiskGet.do', { riskSeq: seq || '' }).then(function(res){
      var d = res.doc || {};
      curSeq = Number(d.riskseq || 0);
      ITEMS = res.items || [];
      if (d.evaldt) document.getElementById('rkEvalDt').value = d.evaldt;
      document.getElementById('rkEvaluator').value = d.evaluator || '';
      drawRows(ITEMS);
      drawSum();
      document.getElementById('rkStat').textContent = curSeq ? ('— 저장된 평가 #' + curSeq) : '— 새 평가';
      document.getElementById('rkDelBtn').style.display = curSeq ? '' : 'none';
      if (fileBox) fileBox.setKey(curSeq || '');
      rkList();
    }).catch(err);
  };

  window.rkNew = function(){ curSeq = 0; rkOpen(''); };

  window.rkSave = function(){
    var dt = document.getElementById('rkEvalDt').value;
    if (!dt) { _alertBox('평가일시를 입력해 주세요.', {icon:'⚠️'}); return; }
    post('/qps/infRiskSave.do', {
      evalDt: dt,
      evaluator: document.getElementById('rkEvaluator').value.trim(),
      items: JSON.stringify(collect())
    }).then(function(res){
      curSeq = Number(res.riskSeq || 0);
      document.getElementById('rkStat').textContent = '— 저장된 평가 #' + curSeq;
      document.getElementById('rkDelBtn').style.display = '';
      if (fileBox) fileBox.setKey(curSeq);
      _toast('저장되었습니다.', 'ok');
      rkList();
    }).catch(err);
  };

  window.rkDel = function(){
    if (!curSeq) return;
    _confirmBox({ msg:'이 평가를 삭제할까요?', icon:'⚠️', okText:'삭제', okColor:'#b23b3b',
      onOk: function(){ post('/qps/infRiskDelete.do', { riskSeq: curSeq })
        .then(function(){ _toast('삭제되었습니다.', 'ok'); rkNew(); }).catch(err); } });
  };

  rkNew();
})();

/* === 글자 크기 (2026-08-18 요청) ==========================================
   QI 계획서(qpsQiPlan)의 zzZoom 과 **같은 규칙** - 0.8~1.6배, 0.1 단위, ↺ 는 처음 크기.
   ★고른 크기는 **이 PC 이 브라우저에만** 남는다(localStorage). 키는 화면마다 따로 둔다. */
(function(){
  var W = 'qpsInfRisk', ZKEY = 'qpsZoom_' + W;
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
</div>
</div><%-- /.dashboard-wrapper --%>
