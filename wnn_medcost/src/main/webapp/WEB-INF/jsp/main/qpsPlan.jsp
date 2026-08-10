<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%-- qpsPlan.jsp — QPS 서식 2호: 질향상및 환자안전 활동계획서 (2026-08-09)
     · 원본(이전 시스템 실물 캡처 9장)을 그대로 옮긴 연간 문서. 병원+년도당 1부.
     · 섹션 6개: 개요 / 주제선정(점수표) / 주요업무 사업계획 / 활동 평가지표 / 연간 활동표(월12칸) / 예산안.
     · 저장 = 항목행 통째 교체(items JSON). 인쇄 = 표지(작성·검토·승인 3단)+섹션별 A4.
     · ★주의: 이 파일 안에서 Deferred EL 표기(샵+중괄호) 금지 --%>

<script src="/asset/js/ui-message.js"></script>
<%@ include file="/WEB-INF/jsp/main/inc/qpsFileBox.jsp" %>

<div class="dashboard-wrapper">
<div id="qpsPlan" data-wnn="<c:out value='${wnnYn}'/>">
<style>
  #qpsPlan{ background:#f4f6f8; color:#1f2a30; min-height:100%; padding:14px 16px 60px; max-width:100%; overflow-x:hidden; }
  #qpsPlan *{ box-sizing:border-box; }
  #qpsPlan .qp-head{ display:flex; align-items:center; gap:10px; margin-bottom:12px; flex-wrap:wrap; }
  #qpsPlan .qp-title{ font-size:18px; font-weight:800; color:#20303a; display:flex; align-items:center; gap:8px; }
  #qpsPlan .qp-dot{ width:10px; height:10px; border-radius:50%; background:linear-gradient(135deg,#1f5a4b,#2a7665); }
  #qpsPlan .qp-sub{ font-size:12px; color:#6b7c86; }
  #qpsPlan .qp-hosp{ background:#e7f3ee; color:#1f5a4b; font-size:12px; font-weight:800;
      border:1px solid #cfe3da; border-radius:14px; padding:3px 11px; }
  #qpsPlan .qp-spacer{ flex:1; }
  #qpsPlan select, #qpsPlan input, #qpsPlan textarea{
      border:1px solid #cfd8e0; border-radius:5px; padding:5px 7px; font-family:inherit; font-size:12.5px; background:#fff; }
  #qpsPlan textarea{ resize:vertical; line-height:1.55; }
  #qpsPlan .qp-btn{ border:1px solid #1f5a4b; background:#1f5a4b; color:#fff; border-radius:6px;
      padding:6px 14px; font-size:13px; font-weight:600; cursor:pointer; white-space:nowrap; }
  #qpsPlan .qp-btn.ghost{ background:#fff; color:#1f5a4b; }
  #qpsPlan .qp-btn.mini{ padding:2px 9px; font-size:11.5px; border-color:#cfd8e0; color:#556570; background:#fff; }
  #qpsPlan .qp-btn:hover{ opacity:.9; }

  #qpsPlan .qp-card{ background:#fff; border:1px solid #e3e9ed; border-radius:10px; padding:14px 16px; margin-bottom:14px; }
  #qpsPlan .qp-card h4{ margin:0 0 10px; font-size:14px; font-weight:800; color:#1f5a4b; }
  #qpsPlan .qp-card h4 .hint{ font-weight:500; font-size:12px; color:#8a99a3; }
  #qpsPlan table.ed{ width:100%; border-collapse:collapse; font-size:12.5px; }
  #qpsPlan table.ed th{ background:#f2f6f8; border:1px solid #dde5ea; padding:5px 6px; font-weight:700; color:#43555f; white-space:nowrap; }
  #qpsPlan table.ed td{ border:1px solid #e6ecef; padding:3px; vertical-align:top; }
  #qpsPlan table.ed input, #qpsPlan table.ed textarea{ width:100%; border:none; background:transparent; padding:4px 5px; }
  #qpsPlan table.ed input:focus, #qpsPlan table.ed textarea:focus{ background:#f7fbf9; outline:1px solid #8fc3b2; }
  #qpsPlan table.ed .num{ text-align:center; }
  #qpsPlan table.ed input[type=checkbox]{ width:15px; height:15px; margin:4px auto; display:block; }
  #qpsPlan .rowdel{ color:#b23b3b; cursor:pointer; font-weight:700; text-align:center; width:26px; }
  #qpsPlan .tot{ background:#f7fbf9; font-weight:800; text-align:center; }
</style>

<div class="qp-head">
  <div class="qp-title"><span class="qp-dot"></span><span id="plTitle">질향상및 환자안전 활동계획서</span> <span class="qp-sub">서식 2호 · 연 1부</span></div>
  <span class="qp-hosp" id="plHosp">🏥 <c:out value="${hospNm}" default="병원 미확인"/></span>
  <div class="qp-spacer"></div>
  <%-- 서식구분(2026-08-10 감염관리 포함) — 같은 년도라도 질향상용·감염관리용이 <각각 1부> 존재한다 --%>
  <select id="plGb" style="width:auto;" onchange="plLoad();">
    <option value="Q">질향상·환자안전</option>
    <option value="I">감염관리</option>
  </select>
  <label class="qp-sub">제출일</label> <input type="date" id="plSubmitDt" style="width:auto;">
  <select id="plYear" style="width:auto;" onchange="plLoad();"></select>
  <button type="button" class="qp-btn" onclick="plSave();">저장</button>
  <button type="button" class="qp-btn ghost" onclick="plPrint();">🖨 인쇄(A4)</button>
  <span class="qp-sub" id="plStat"></span>
</div>

<div class="qp-card"><h4>1. 개요 <span class="hint">— 항목명도 병원에 맞게 고칠 수 있습니다 (추진체계 흐름도는 글로 적습니다)</span></h4>
  <table class="ed"><thead><tr><th style="width:150px;">항목</th><th>내용</th><th style="width:26px;"></th></tr></thead>
  <tbody id="tbINTRO"></tbody></table>
  <button type="button" class="qp-btn mini" style="margin-top:6px;" onclick="plAdd('INTRO');">＋ 행 추가</button>
</div>

<div class="qp-card"><h4>2. 주제 선정 <span class="hint">— 기준 6개 × 10점, 총점 60점 만점(자동 합산)</span></h4>
  <table class="ed"><thead><tr>
    <th style="width:90px;">부서</th><th>주제</th>
    <th style="width:64px;">병원미션<br>연관성</th><th style="width:64px;">고객<br>영향</th><th style="width:64px;">환자안전<br>관련성</th>
    <th style="width:64px;">고위험<br>다빈도</th><th style="width:64px;">개선<br>용이성</th><th style="width:64px;">국내외<br>평가지표</th>
    <th style="width:56px;">총점</th><th style="width:26px;"></th>
  </tr></thead><tbody id="tbTOPIC"></tbody></table>
  <button type="button" class="qp-btn mini" style="margin-top:6px;" onclick="plAdd('TOPIC');">＋ 행 추가</button>
</div>

<div class="qp-card"><h4>3. 주요업무 사업계획</h4>
  <table class="ed"><thead><tr>
    <th style="width:120px;">주요사업</th><th>세부 추진 내용</th><th style="width:200px;">비고</th><th style="width:110px;">일정</th><th style="width:26px;"></th>
  </tr></thead><tbody id="tbBIZ"></tbody></table>
  <button type="button" class="qp-btn mini" style="margin-top:6px;" onclick="plAdd('BIZ');">＋ 행 추가</button>
</div>

<div class="qp-card"><h4>4. QPS 활동 평가지표</h4>
  <table class="ed"><thead><tr>
    <th style="width:140px;">주요사업</th><th>세부내용</th><th style="width:200px;">사업지표</th><th style="width:90px;">목표치</th><th style="width:110px;">평가</th><th style="width:26px;"></th>
  </tr></thead><tbody id="tbEVAL"></tbody></table>
  <button type="button" class="qp-btn mini" style="margin-top:6px;" onclick="plAdd('EVAL');">＋ 행 추가</button>
</div>

<div class="qp-card"><h4>5. 연간 활동 계획표 <span class="hint">— 실시하는 달에 체크</span></h4>
  <div style="overflow-x:auto;">
  <table class="ed" style="min-width:1050px;"><thead><tr>
    <th style="width:92px;">구분</th><th style="min-width:190px;">내용</th><th style="width:80px;">일정</th>
    <th style="width:30px;">1</th><th style="width:30px;">2</th><th style="width:30px;">3</th><th style="width:30px;">4</th>
    <th style="width:30px;">5</th><th style="width:30px;">6</th><th style="width:30px;">7</th><th style="width:30px;">8</th>
    <th style="width:30px;">9</th><th style="width:30px;">10</th><th style="width:30px;">11</th><th style="width:30px;">12</th>
    <th style="width:88px;">예산(원)</th><th style="width:100px;">비고</th><th style="width:26px;"></th>
  </tr></thead><tbody id="tbSCHED"></tbody></table>
  </div>
  <button type="button" class="qp-btn mini" style="margin-top:6px;" onclick="plAdd('SCHED');">＋ 행 추가</button>
</div>

<div class="qp-card"><h4>6. 사업 예산안 <span class="hint">— 총예산 자동 합산</span></h4>
  <table class="ed"><thead><tr>
    <th style="width:150px;">관련 사업</th><th style="width:150px;">예산과목</th><th>내역</th><th style="width:130px;">총비용(원)</th><th style="width:26px;"></th>
  </tr></thead><tbody id="tbBUDGET"></tbody>
  <tfoot><tr><td colspan="3" class="tot">총 예산</td><td class="tot" id="plBudTot">0</td><td></td></tr></tfoot></table>
  <button type="button" class="qp-btn mini" style="margin-top:6px;" onclick="plAdd('BUDGET');">＋ 행 추가</button>
</div>

<div class="qp-card"><h4>첨부파일 <span class="hint">— 연간계획서에 붙는 사진·파일(조직도·근거자료 등)</span></h4>
  <div id="plFileBox"></div>
</div>

<script>
(function(){
  var HOSP_NM = '';
    /** 서식구분 — Q=질향상·환자안전, I=감염관리 (2026-08-10) */
  function plGb(){ var e=document.getElementById("plGb"); return e ? e.value : "Q"; }

  // 공통 첨부 — 계획서(PLAN) 문서키 = 년도(자연키, 저장 전에도 존재).
  var fileBox = window.qpsFileBox({ mount:'plFileBox', refGb:'PLAN',
      hint:'연간계획서에 붙는 사진·파일', needSaveMsg:'년도를 선택하면 첨부할 수 있습니다.' });
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
    var y = new Date().getFullYear(), sel = document.getElementById('plYear');
    for (var i = y + 1; i >= y - 4; i--) sel.add(new Option(i + '년', i));
    sel.value = y;
  })();

  // ── 섹션별 행 템플릿 — inp(name, r) 는 값 보존 렌더 ─────────────────────
  function inp(cls, name, v, ph){
    return '<input class="' + cls + '" data-f="' + name + '" value="' + esc(v) + '"' + (ph ? ' placeholder="' + esc(ph) + '"' : '') + '>';
  }
  function ta(name, v){ return '<textarea data-f="' + name + '" rows="2">' + esc(v) + '</textarea>'; }
  function chk(name, v){ return '<input type="checkbox" data-f="' + name + '"' + (v === 'Y' ? ' checked' : '') + '>'; }
  function del(){ return '<td class="rowdel" onclick="plDelRow(this);">✕</td>'; }

  var ROW = {
    INTRO:  function(r){ return '<td>' + inp('', 'c1', r.c1) + '</td><td>' + ta('c2', r.c2) + '</td>' + del(); },
    TOPIC:  function(r){
      var s = '';
      for (var i = 1; i <= 6; i++) s += '<td>' + inp('num', 's' + i, r['s' + i] == null ? '' : r['s' + i]) + '</td>';
      return '<td>' + inp('', 'c1', r.c1) + '</td><td>' + inp('', 'c2', r.c2) + '</td>' + s +
             '<td class="tot" data-tot>' + topicTot(r) + '</td>' + del();
    },
    BIZ:    function(r){ return '<td>' + inp('', 'grp', r.grp) + '</td><td>' + ta('c1', r.c1) + '</td>' +
                         '<td>' + inp('', 'c2', r.c2) + '</td><td>' + inp('', 'c3', r.c3) + '</td>' + del(); },
    EVAL:   function(r){ return '<td>' + inp('', 'grp', r.grp) + '</td><td>' + ta('c1', r.c1) + '</td>' +
                         '<td>' + inp('', 'c2', r.c2) + '</td><td>' + inp('', 'c3', r.c3) + '</td>' +
                         '<td>' + inp('', 'c4', r.c4) + '</td>' + del(); },
    SCHED:  function(r){
      var m = '';
      for (var i = 1; i <= 12; i++){ var k = 'm' + (i < 10 ? '0' + i : i); m += '<td>' + chk(k, r[k]) + '</td>'; }
      return '<td>' + inp('', 'grp', r.grp) + '</td><td>' + inp('', 'c1', r.c1) + '</td><td>' + inp('', 'c2', r.c2) + '</td>' +
             m + '<td>' + inp('num', 'amt', r.amt == null ? '' : r.amt) + '</td><td>' + inp('', 'c3', r.c3) + '</td>' + del();
    },
    BUDGET: function(r){ return '<td>' + inp('', 'grp', r.grp) + '</td><td>' + inp('', 'c1', r.c1) + '</td>' +
                         '<td>' + inp('', 'c2', r.c2) + '</td><td>' + inp('num', 'amt', r.amt == null ? '' : r.amt) + '</td>' + del(); }
  };
  function topicTot(r){
    var t = 0, has = false;
    for (var i = 1; i <= 6; i++){ var v = Number(r['s' + i]); if (r['s' + i] !== '' && r['s' + i] != null && !isNaN(v)){ t += v; has = true; } }
    return has ? t : '';
  }

  // 새 문서일 때 채워 주는 기본 틀 — 원본 서식의 고정 행들(병원이 지우거나 고치면 그대로 저장된다)
  var DEFAULTS = {
    INTRO: ['목적','목표','추진체계','운영방침','적용범위','기타'].map(function(t){ return { c1:t, c2:'' }; }),
    TOPIC: [{}, {}, {}],
    BIZ: ['QPS위원회 운영','질향상 활동','지표 관리','환자안전 관리','교육','의료서비스 관리','불만고충','정보공유']
         .map(function(g){ return { grp:g }; }),
    EVAL: ['질향상 및 환자안전관리 체계구축','질향상활동·환자안전','의료서비스 만족도 관리','교육','정보공유']
         .map(function(g){ return { grp:g }; }),
    SCHED: [
      { grp:'위원회',    c1:'위원회 개최' },
      { grp:'계획',      c1:'질향상·환자안전사업 연간계획서 작성' },
      { grp:'질향상활동', c1:'QI 활동 계획서 제출, 심의' },
      { grp:'질향상활동', c1:'QI 중간보고서 제출' },
      { grp:'질향상활동', c1:'QI 최종보고서 제출' },
      { grp:'환자안전',  c1:'환자안전사고 보고 모니터링' },
      { grp:'환자안전',  c1:'환자안전사건·사고분석 및 개선활동' },
      { grp:'환자안전',  c1:'환자안전 주간 행사(년1회 이상)' },
      { grp:'환자안전',  c1:'환자안전 라운딩 (월1회)' },
      { grp:'직원교육',  c1:'신규 — 질향상 및 환자안전교육' },
      { grp:'직원교육',  c1:'재직 — 질향상 및 환자안전교육' },
      { grp:'직원교육',  c1:'재직 — 의료기관 평가 관련 교육(전체·부서별·방문교육)' },
      { grp:'직원교육',  c1:'담당자 — 질향상·환자안전 외부교육' },
      { grp:'직원교육',  c1:'전직원 — 환자안전 주의경보' },
      { grp:'환자교육',  c1:'환자 및 보호자 교육' },
      { grp:'지표관리',  c1:'지표 정의서' },
      { grp:'지표관리',  c1:'지표 결과 보고' },
      { grp:'지표관리',  c1:'지표 모니터링 및 결과 개선활동' },
      { grp:'의료서비스', c1:'의료서비스 만족도 조사' },
      { grp:'의료서비스', c1:'만족도 개선활동' },
      { grp:'의료서비스', c1:'만족도 최종 보고' },
      { grp:'불만고충',  c1:'불만고충 처리 활동' },
      { grp:'불만고충',  c1:'불만고충 처리 분석' },
      { grp:'정보공유',  c1:'효율적의사소통(부서/원내 게시판)' }
    ],
    BUDGET: [{}, {}, {}]
  };
  var SECTS = ['INTRO','TOPIC','BIZ','EVAL','SCHED','BUDGET'];

  function addRow(sect, r){
    var tb = document.getElementById('tb' + sect);
    var tr = document.createElement('tr');
    tr.setAttribute('data-sect', sect);
    tr.innerHTML = ROW[sect](r || {});
    tb.appendChild(tr);
  }
  window.plAdd = function(sect){ addRow(sect, {}); };
  window.plDelRow = function(el){ el.closest('tr').remove(); recalc(); };

  // 총점·총예산 자동 계산(입력 이벤트 위임)
  document.getElementById('qpsPlan').addEventListener('input', function(e){
    var tr = e.target.closest('tr');
    if (tr && tr.getAttribute('data-sect') === 'TOPIC') {
      var r = readRow(tr), t = tr.querySelector('[data-tot]');
      if (t) t.textContent = topicTot(r);
    }
    if (tr && tr.getAttribute('data-sect') === 'BUDGET') recalc();
  });
  function recalc(){
    var tot = 0;
    document.querySelectorAll('#tbBUDGET tr').forEach(function(tr){
      var v = Number(readRow(tr).amt); if (!isNaN(v)) tot += v;
    });
    document.getElementById('plBudTot').textContent = tot.toLocaleString();
  }

  function readRow(tr){
    var r = {};
    tr.querySelectorAll('[data-f]').forEach(function(el){
      r[el.getAttribute('data-f')] = (el.type === 'checkbox') ? (el.checked ? 'Y' : '') : String(el.value).trim();
    });
    return r;
  }
  function collect(){
    var items = [];
    SECTS.forEach(function(sect){
      var sort = 0;
      document.querySelectorAll('#tb' + sect + ' tr').forEach(function(tr){
        var r = readRow(tr);
        var hasVal = Object.keys(r).some(function(k){ return r[k] !== '' && r[k] != null; });
        if (!hasVal) return;                    // 전부 빈 행은 저장 안 함
        r.sect = sect; r.sort = ++sort;
        ['s1','s2','s3','s4','s5','s6','amt'].forEach(function(k){ if (r[k] === '') r[k] = null; });
        items.push(r);
      });
    });
    return items;
  }

  window.plLoad = function(){
    /* 첨부 키 = 년도|구분. ★구분을 빼면 감염 계획서 첨부가 질향상 것과 섞인다(2026-08-10). */
    if (fileBox) fileBox.setKey(document.getElementById('plYear').value + '|' + plGb());
    var t = document.getElementById('plTitle');
    if (t) t.textContent = (plGb()==='I') ? '감염관리 활동계획서' : '질향상및 환자안전 활동계획서';
    return post('/qps/planGet.do', { formGb: plGb(), inYear: document.getElementById('plYear').value }).then(function(res){
      if (res.hosp) { HOSP_NM = res.hosp.hospnm || '';
        document.getElementById('plHosp').textContent = '🏥 ' + HOSP_NM; }
      var plan = res.plan, items = res.items || [];
      document.getElementById('plSubmitDt').value = (plan && plan.submitdt) ? plan.submitdt : '';
      document.getElementById('plStat').textContent = plan ? ('최종수정 ' + (plan.upddttm || '')) : '작성 전 — 기본 틀을 채워 두었습니다';
      SECTS.forEach(function(sect){
        var tb = document.getElementById('tb' + sect);
        tb.innerHTML = '';
        var rows = items.filter(function(r){ return r.sect === sect; });
        if (!rows.length && !plan) rows = DEFAULTS[sect];       // 새 문서 = 원본 서식의 기본 틀
        (rows.length ? rows : [{}]).forEach(function(r){ addRow(sect, r); });
      });
      recalc();
    }).catch(err);
  };

  window.plSave = function(){
    post('/qps/planSave.do', {
      formGb: plGb(),
      inYear: document.getElementById('plYear').value,
      submitDt: document.getElementById('plSubmitDt').value,
      items: JSON.stringify(collect())
    }).then(function(){
      _toast('저장되었습니다.', 'ok');
      return plLoad();
    }).catch(err);
  };

  // ---------- 인쇄(A4 여러 장) — 별도 창 방식 ----------
  var PRINT_CSS =
    '@page{ size:A4 portrait; margin:12mm 12mm 14mm; }' +
    'body{ margin:0; font-family:"맑은 고딕",Malgun Gothic,sans-serif; color:#000; }' +
    '.cover{ text-align:center; padding-top:30mm; page-break-after:always; }' +
    '.cover .t{ font-size:30px; font-weight:800; letter-spacing:2px; }' +
    '.cover .y{ font-size:16px; font-weight:700; margin-top:10mm; }' +
    '.cover .h{ font-size:13px; margin-top:6mm; }' +
    '.cover .appr{ margin:14mm 0 0 auto; margin-right:10mm; border-collapse:collapse; font-size:11px; }' +
    '.cover .appr th{ border:1px solid #666; background:#f0f0f0; padding:3px 14px; }' +
    '.cover .appr td{ border:1px solid #666; height:52px; width:72px; }' +
    '.cover .sub{ font-size:14px; font-weight:700; margin-top:40mm; }' +
    '.sec{ font-size:14px; font-weight:800; margin:12px 0 6px; padding-bottom:3px; border-bottom:1.5px solid #333; }' +
    'table.p{ width:100%; border-collapse:collapse; font-size:10.5px; page-break-inside:auto; }' +
    'table.p th, table.p td{ border:1px solid #666; padding:4px 5px; text-align:left; vertical-align:top; line-height:1.55; }' +
    'table.p th{ background:#efefef; font-weight:700; text-align:center; }' +
    'table.p td.c{ text-align:center; }' +
    'table.p td.pre{ white-space:pre-wrap; }' +
    'tr{ page-break-inside:avoid; }' +
    '.brk{ page-break-before:always; }';

  window.plPrint = function(){
    var yy = document.getElementById('plYear').value;
    var items = collect();
    function by(sect){ return items.filter(function(r){ return r.sect === sect; }); }
    function rows(sect, fn){ return by(sect).map(fn).join(''); }

    var cover =
      '<div class="cover"><div class="t">질향상및 환자안전 활동계획서</div>' +
      '<div class="y">' + esc(yy) + ' 년</div>' +
      '<div class="h">' + esc(HOSP_NM) + '</div>' +
      '<table class="appr"><thead><tr><th>작성</th><th>검토</th><th>승인</th></tr></thead>' +
      '<tbody><tr><td></td><td></td><td></td></tr></tbody></table>' +
      '<div class="sub">제출일&nbsp;&nbsp;' + esc(document.getElementById('plSubmitDt').value || '') + '</div></div>';

    var intro = '<div class="sec">1. 개요</div><table class="p"><tbody>' +
      rows('INTRO', function(r){ return '<tr><th style="width:110px;">' + esc(r.c1) + '</th><td class="pre">' + esc(r.c2) + '</td></tr>'; }) +
      '</tbody></table>';

    var topic = '<div class="sec">2. 주제 선정</div><table class="p"><thead><tr>' +
      '<th style="width:26px;">번호</th><th style="width:70px;">부서</th><th>주제</th>' +
      '<th style="width:52px;">병원미션<br>연관성<br>(10점)</th><th style="width:52px;">고객<br>영향<br>(10점)</th>' +
      '<th style="width:52px;">환자안전<br>관련성<br>(10점)</th><th style="width:52px;">고위험<br>다빈도<br>(10점)</th>' +
      '<th style="width:52px;">개선활동<br>용이성<br>(10점)</th><th style="width:52px;">국내외<br>평가지표<br>(10점)</th>' +
      '<th style="width:46px;">총점<br>(60점)</th></tr></thead><tbody>' +
      by('TOPIC').map(function(r, i){
        var s = '';
        for (var k = 1; k <= 6; k++) s += '<td class="c">' + esc(r['s' + k] == null ? '' : r['s' + k]) + '</td>';
        return '<tr><td class="c">' + (i + 1) + '</td><td>' + esc(r.c1) + '</td><td>' + esc(r.c2) + '</td>' + s +
               '<td class="c"><b>' + topicTot(r) + '</b></td></tr>';
      }).join('') + '</tbody></table>';

    var biz = '<div class="brk"></div><div class="sec">3. ' + esc(yy) + '년 주요업무 사업계획</div>' +
      '<table class="p"><thead><tr><th style="width:96px;">주요사업</th><th>세부 추진 내용</th>' +
      '<th style="width:150px;">비고</th><th style="width:80px;">일정</th></tr></thead><tbody>' +
      rows('BIZ', function(r){ return '<tr><td class="c">' + esc(r.grp) + '</td><td class="pre">' + esc(r.c1) + '</td>' +
        '<td>' + esc(r.c2) + '</td><td class="c">' + esc(r.c3) + '</td></tr>'; }) + '</tbody></table>';

    var ev = '<div class="sec">4. ' + esc(yy) + '년 QPS 활동 평가지표</div>' +
      '<table class="p"><thead><tr><th style="width:110px;">주요사업</th><th>세부내용</th>' +
      '<th style="width:150px;">사업지표</th><th style="width:64px;">목표치</th><th style="width:80px;">평가</th></tr></thead><tbody>' +
      rows('EVAL', function(r){ return '<tr><td class="c">' + esc(r.grp) + '</td><td class="pre">' + esc(r.c1) + '</td>' +
        '<td>' + esc(r.c2) + '</td><td class="c">' + esc(r.c3) + '</td><td class="c">' + esc(r.c4) + '</td></tr>'; }) + '</tbody></table>';

    var mth = '';
    for (var i = 1; i <= 12; i++) mth += '<th style="width:20px;">' + i + '</th>';
    var sched = '<div class="brk"></div><div class="sec">' + esc(yy) + '년 QPS 연간 활동 계획서</div>' +
      '<table class="p"><thead><tr><th style="width:64px;">구분</th><th>내용</th><th style="width:52px;">일정</th>' +
      mth + '<th style="width:64px;">예산</th><th style="width:64px;">비고</th></tr></thead><tbody>' +
      rows('SCHED', function(r){
        var m = '';
        for (var i = 1; i <= 12; i++){ var k = 'm' + (i < 10 ? '0' + i : i); m += '<td class="c">' + (r[k] === 'Y' ? '●' : '') + '</td>'; }
        return '<tr><td class="c">' + esc(r.grp) + '</td><td>' + esc(r.c1) + '</td><td class="c">' + esc(r.c2) + '</td>' +
               m + '<td class="c">' + num(r.amt) + '</td><td>' + esc(r.c3) + '</td></tr>';
      }) + '</tbody></table>';

    var tot = 0;
    by('BUDGET').forEach(function(r){ var v = Number(r.amt); if (!isNaN(v)) tot += v; });
    var bud = '<div class="brk"></div><div class="sec">' + esc(yy) + '년 QPS 사업 예산안</div>' +
      '<table class="p"><thead><tr><th style="width:120px;">관련 사업</th><th style="width:120px;">예산과목</th>' +
      '<th>내역</th><th style="width:100px;">총비용(원)</th></tr></thead><tbody>' +
      rows('BUDGET', function(r){ return '<tr><td class="c">' + esc(r.grp) + '</td><td class="c">' + esc(r.c1) + '</td>' +
        '<td class="pre">' + esc(r.c2) + '</td><td class="c">' + num(r.amt) + '</td></tr>'; }) +
      '<tr><td colspan="3" class="c" style="background:#efefef;font-weight:700;">총 예산</td>' +
      '<td class="c"><b>' + tot.toLocaleString() + '</b></td></tr></tbody></table>';

    var title = ('활동계획서_' + yy + '_' + HOSP_NM).replace(/[\\\/:*?"<>|]/g, '-');
    var w = window.open('', '_blank', 'width=900,height=1000');
    if (!w) { _alertBox('팝업이 차단되어 인쇄창을 열지 못했습니다.<br>주소창 오른쪽의 팝업 차단을 허용해 주세요.', {icon:'⚠️'}); return; }
    w.document.open();
    w.document.write('<!doctype html><html lang="ko"><head><meta charset="utf-8"><title>' + esc(title) +
      '</title><style>' + PRINT_CSS + '</style></head><body>' +
      cover + intro + topic + biz + ev + sched + bud + '</body></html>');
    w.document.close();
    w.focus();
    setTimeout(function(){ try { w.print(); } catch (e) { } }, 300);
  };

  $(function(){ plLoad(); });
})();
</script>
</div><%-- /#qpsPlan --%>
</div><%-- /.dashboard-wrapper --%>
