<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%-- qpsCmpl.jsp — 불만고충 처리대장 + 개선활동 처리결과 (2026-08-11)

     ★이 폴더의 급소가 대장이다. 지표분석보고서의 모든 수치(월별·유형별·접수유형·
       처리기간·회신방법·미회신사유)가 이 대장 한 곳에서 집계된다.
       그래서 유형·접수유형·회신방법·미회신사유는 자유입력이 아니라 <코드값>이다.

     ★화면을 둘로 나누지 않았다.
       원본은 처리대장(목록)과 개선활동 처리결과서(건별 상세)가 별도 문서이고,
       처리결과서는 좌측 「1~14」 라디오로 건을 넘겨 본다.
       ***14 는 종이의 물리적 한계일 뿐 의미 있는 수가 아니다.***
       우리는 대장에서 건을 고르면 그 건의 상세가 열리는 <목록 ↔ 상세>로 푼다.
       접수방법·민원인·불만고충내용·고객통보(회신방법)는 대장에 이미 있으므로
       상세에서 다시 받지 않는다 — 같은 것을 두 번 입력하게 만들지 않는다.

     ★★대장 저장은 「통째 교체」가 아니라 행별 upsert 다.
       각 건에 상세가 CMPL_SEQ 로 1:1 매달려 있어, 통째로 지우고 다시 넣으면
       SEQ 가 새로 발급되어 그 상세가 통째로 미아가 된다.

     ★주의: 이 파일 안에서 Deferred EL 표기(샵+중괄호) 금지 --%>

<script src="/asset/js/ui-message.js"></script>

<div class="dashboard-wrapper">
<div id="qpsCmpl" data-wnn="<c:out value='${wnnYn}'/>">
<style>
  #qpsCmpl{ background:#f4f6f8; color:#1f2a30; min-height:100%; padding:14px 16px 60px; max-width:100%; overflow-x:hidden; }
  #qpsCmpl *{ box-sizing:border-box; }
  #qpsCmpl .cm-head{ display:flex; align-items:center; gap:10px; margin-bottom:12px; flex-wrap:wrap; }
  #qpsCmpl .cm-title{ font-size:18px; font-weight:800; color:#20303a; display:flex; align-items:center; gap:8px; }
  #qpsCmpl .cm-dot{ width:10px; height:10px; border-radius:50%; background:linear-gradient(135deg,#1f5a4b,#2a7665); }
  #qpsCmpl .cm-sub{ font-size:12px; color:#6b7c86; }
  #qpsCmpl .cm-hosp{ background:#e7f3ee; color:#1f5a4b; font-size:12px; font-weight:800;
      border:1px solid #cfe3da; border-radius:14px; padding:3px 11px; }
  #qpsCmpl .cm-spacer{ flex:1; }
  #qpsCmpl select, #qpsCmpl input, #qpsCmpl textarea{
      border:1px solid #cfd8e0; border-radius:5px; padding:5px 7px; font-family:inherit; font-size:12.5px; background:#fff; }
  #qpsCmpl textarea{ resize:vertical; line-height:1.55; width:100%; }
  #qpsCmpl .cm-btn{ border:1px solid #1f5a4b; background:#1f5a4b; color:#fff; border-radius:6px;
      padding:6px 14px; font-size:13px; font-weight:600; cursor:pointer; white-space:nowrap; }
  #qpsCmpl .cm-btn.ghost{ background:#fff; color:#1f5a4b; }
  #qpsCmpl .cm-btn.warn{ background:#fff; color:#b23b3b; border-color:#e0b4b4; }
  #qpsCmpl .cm-btn.mini{ padding:2px 9px; font-size:11.5px; border-color:#cfd8e0; color:#556570; background:#fff; }

  #qpsCmpl .cm-tabs{ display:flex; gap:6px; margin-bottom:10px; }
  #qpsCmpl .cm-tab{ padding:7px 16px; border:1px solid #dde5ea; border-radius:8px 8px 0 0;
      background:#eef3f6; font-size:13px; font-weight:700; color:#63757f; cursor:pointer; }
  #qpsCmpl .cm-tab.on{ background:#fff; color:#1f5a4b; border-bottom-color:#fff; }
  #qpsCmpl .cm-card{ background:#fff; border:1px solid #e3e9ed; border-radius:10px; padding:14px 16px; margin-bottom:12px; }
  #qpsCmpl .cm-card h4{ margin:0 0 10px; font-size:14px; font-weight:800; color:#1f5a4b; }
  #qpsCmpl .cm-card h4 .hint{ font-weight:500; font-size:12px; color:#8a99a3; }

  #qpsCmpl table.ed{ width:100%; border-collapse:collapse; font-size:12px; }
  #qpsCmpl table.ed th{ background:#f2f6f8; border:1px solid #dde5ea; padding:5px 4px; font-weight:700; color:#43555f; white-space:nowrap; }
  #qpsCmpl table.ed td{ border:1px solid #e6ecef; padding:2px; vertical-align:middle; }
  #qpsCmpl table.ed input, #qpsCmpl table.ed select{ width:100%; border:none; background:transparent; padding:4px 3px; font-size:12px; }
  #qpsCmpl table.ed input:focus, #qpsCmpl table.ed select:focus{ background:#f7fbf9; outline:1px solid #8fc3b2; }
  #qpsCmpl table.ed tr.sel td{ background:#f0f7f4; }
  #qpsCmpl table.ed tr.noreply td{ background:#fff8f2; }
  #qpsCmpl .rowdel{ color:#b23b3b; cursor:pointer; font-weight:700; text-align:center; width:26px; }
  #qpsCmpl .pick{ color:#1f5a4b; cursor:pointer; font-weight:700; text-align:center; white-space:nowrap; }

  #qpsCmpl .cm-form{ display:grid; grid-template-columns:120px 1fr 120px 1fr; gap:9px 10px; align-items:start; }
  #qpsCmpl .cm-form .lb{ font-size:12.5px; font-weight:700; color:#43555f; padding-top:8px; }
  #qpsCmpl .cm-form .full{ grid-column:2 / -1; }
  #qpsCmpl .cm-form input{ width:100%; }
  #qpsCmpl .ro{ background:#f5f7f9; border:1px solid #e3e9ed; border-radius:5px; padding:6px 8px;
      font-size:12.5px; color:#43555f; min-height:31px; }
  /* -- 글자 크기 (2026-08-18 요청) : QI 계획서(qpsQiPlan)와 같은 모양.같은 조작 */
  #qpsCmpl .zz-zoom{ display:inline-flex; gap:4px; align-items:center; margin-left:2px; margin-right:14px; }
  #qpsCmpl .zz-zoom button{ border:1px solid #cfd9e0; background:#fff; color:#43555f; border-radius:6px;
                        padding:4px 9px; font-size:13px; font-weight:700; cursor:pointer; }
  #qpsCmpl .zz-zoom button:hover{ background:#eef3f6; }
</style>

<div class="cm-head">
  <div class="cm-title"><span class="cm-dot"></span>불만고충 처리대장 <span class="cm-sub">연 단위 · 건별</span></div>
  <span class="cm-hosp" id="cmHosp">🏥 <c:out value="${hospNm}" default="병원 미확인"/></span>
  <div class="cm-spacer"></div>
  <select id="cmYear" style="width:auto;" onchange="cmLoad();"></select>
  <button type="button" class="cm-btn" onclick="cmSaveAll();">대장 저장</button>
  <button type="button" class="cm-btn ghost" onclick="cmPrintBook();">🖨 대장 인쇄</button>
  <%-- ★화면 안 일괄 출력 (2026-09-08 — 확장 7호) : 그 해 대장 1장 + 접수일 범위의 처리결과 보고서(있는 건만)를 이어 인쇄. 아래 #cmBulkPrintBox 에 펼친다. --%>
  <button type="button" class="cm-btn ghost" onclick="cmBulkPrintToggle();" title="대장과 건별 처리결과 보고서를 한 번에 인쇄합니다">🖨 일괄 출력</button>
  <span class="cm-sub" id="cmStat"></span>
  <span style="flex:0 0 12px;"></span>
  <span style="flex:0 0 12px;"></span>
  <%-- 글자 크기 - 이 PC 이 브라우저에만 저장된다 --%>
  <span class="zz-zoom">
    <button type="button" onclick="zzZoom(-1);" title="글자 작게">가－</button>
    <button type="button" onclick="zzZoom(1);"  title="글자 크게">가＋</button>
    <button type="button" onclick="zzZoom(0);"  title="처음 크기로">↺</button>
  </span>
</div>
<%-- 🖨 화면 안 일괄 출력 조건 띠 (2026-09-08) — 처리대장은 「연 1장(가로) + 건마다 처리결과 보고서(세로)」라 조건은 연도 + 접수일 월 범위 + 무엇을 담을지. --%>
<div id="cmBulkPrintBox" style="display:none; margin:6px 0 4px; padding:8px 12px; border:1px solid #b9cfe6; border-radius:8px; background:#eef4fb; font-size:12.5px; color:#1f2a37;">
  <div style="display:flex; align-items:center; gap:10px; flex-wrap:wrap;">
    <b style="color:#2f6fb0;">🖨 일괄 출력</b>
    <span>연도</span><select id="cmBpYear" style="width:auto;"></select>
    <span style="margin-left:8px;">접수일</span>
    <select id="cmBpFrom" style="width:auto;"></select><span>~</span><select id="cmBpTo" style="width:auto;"></select>
    <label style="display:inline-flex; align-items:center; gap:4px; margin:0 0 0 8px;"><input type="checkbox" id="cmBpBook" checked> 처리대장(그 해 전체)</label>
    <label style="display:inline-flex; align-items:center; gap:4px; margin:0;"><input type="checkbox" id="cmBpAct" checked> 처리결과 보고서(범위 안 · 작성된 건만)</label>
    <button type="button" class="cm-btn" id="cmBpGo" style="margin-left:auto;" onclick="cmBulkPrintGo();">출력</button>
    <button type="button" class="cm-btn ghost" onclick="cmBulkPrintToggle();">닫기</button>
  </div>
  <div style="margin-top:5px; font-size:11.5px; color:#5a6b7a;">대장 한 장 뒤에 접수일이 범위 안이고 처리결과가 작성된 건의 보고서를 한 장씩 이어 붙입니다(자료를 만들지 않음). 다른 해를 고르면 대장을 다시 불러오니 <b>저장 안 한 수정은 먼저 저장</b>하세요. 한 번에 120장까지. <span id="cmBpStat" style="color:#2f6fb0; font-weight:700;"></span></div>
</div>

<div class="cm-tabs">
  <div class="cm-tab on" id="tab1" onclick="cmTab(1);">📒 처리대장</div>
  <div class="cm-tab"    id="tab2" onclick="cmTab(2);">📄 개선활동 처리결과</div>
</div>

<%-- ───────── 탭1 : 처리대장 그리드 ───────── --%>
<div id="pane1">
  <div class="cm-card">
    <h4>처리대장 <span class="hint" id="cmCnt"></span>
      <span class="hint">— 회신날짜가 비면 미회신사유를 적어 주세요(연한 주황 행)</span></h4>
    <div style="overflow-x:auto;">
    <table class="ed" style="min-width:1500px;"><thead><tr>
      <th style="width:38px;">번호</th>
      <th style="width:96px;">접수일</th>
      <th style="width:46px;">접수월</th>
      <th style="width:110px;">접수유형</th>
      <th style="width:100px;">민원인</th>
      <th style="width:96px;">민원인구분</th>
      <th style="width:70px;">처리기간<br>(일)</th>
      <th style="width:110px;">불만고충유형</th>
      <th style="min-width:200px;">불만고충내용</th>
      <th style="min-width:170px;">처리결과</th>
      <th style="width:96px;">회신날짜</th>
      <th style="width:100px;">회신방법</th>
      <th style="width:120px;">미회신사유</th>
      <th style="width:70px;">처리결과서</th>
      <th style="width:26px;"></th>
    </tr></thead><tbody id="cmBody"></tbody></table>
    </div>
    <button type="button" class="cm-btn mini" style="margin-top:6px;" onclick="cmAdd();">＋ 행 추가</button>
    <span class="cm-sub" style="margin-left:8px;">접수일을 넣으면 접수월이 자동으로 채워집니다.</span>
  </div>
</div>

<%-- ───────── 탭2 : 개선활동 처리결과 (선택 건의 상세) ───────── --%>
<div id="pane2" style="display:none;">
  <div class="cm-card">
    <h4>대상 건 <span class="hint">— 대장에서 [상세]를 눌러 고릅니다. 아래 회색 칸은 대장 값이라 여기서 고치지 않습니다</span></h4>
    <input type="hidden" id="a_cmplSeq" value="">
    <div class="cm-form">
      <div class="lb">접수날짜</div>   <div><div class="ro" id="a_recvDt">—</div></div>
      <div class="lb">접수방법</div>   <div><div class="ro" id="a_recvCd">—</div></div>
      <div class="lb">민원인</div>     <div><div class="ro" id="a_person">—</div></div>
      <div class="lb">고객통보</div>   <div><div class="ro" id="a_replyCd">—</div></div>
      <div class="lb">불만고충내용</div> <div class="full"><div class="ro" id="a_content" style="white-space:pre-wrap;">—</div></div>
    </div>
  </div>

  <div class="cm-card">
    <h4>개선활동 처리결과</h4>
    <div class="cm-form">
      <div class="lb">보고날짜</div>   <div><input type="date" id="a_rptDt"></div>
      <div class="lb">부서명</div>     <div><input type="text" id="a_deptNm" maxlength="60"></div>
      <div class="lb">개선날짜</div>   <div><input type="date" id="a_imprDt"></div>
      <div class="lb">민원발생장소</div> <div><input type="text" id="a_place" maxlength="200"></div>
      <div class="lb">문제진술</div>   <div class="full"><textarea id="a_problem" rows="3"></textarea></div>
      <div class="lb">현상파악 및<br>원인분석</div> <div class="full"><textarea id="a_analysis" rows="3"></textarea></div>
      <div class="lb">개선 대책안</div> <div class="full"><textarea id="a_planTxt" rows="3"></textarea></div>
      <div class="lb">개선방안 적용<br>Action·개선지속</div>
      <div class="full"><textarea id="a_actTxt" rows="4"
           placeholder="한 줄에 한 건 — 유형|불만고충 문제점|개선활동"></textarea></div>
      <div class="lb">원인</div>       <div class="full"><textarea id="a_cause" rows="2"></textarea></div>
      <div class="lb">조치 및 답변</div> <div class="full"><textarea id="a_answer" rows="3"></textarea></div>
      <div class="lb">재발방지대책</div> <div class="full"><textarea id="a_prevent" rows="3"></textarea></div>
    </div>
    <div style="margin-top:10px; display:flex; gap:6px;">
      <button type="button" class="cm-btn" onclick="cmActSave();">처리결과 저장</button>
      <button type="button" class="cm-btn ghost" onclick="cmActPrint();">🖨 처리결과 인쇄</button>
    </div>
  </div>
</div>

<script>
(function(){
  var HOSP_NM = '', APPR_LINE = [], CODES = {}, curSeq = 0, ROWS = [];

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
  function txt(id, v){ var e = gel(id); if (e) e.textContent = (v == null || v === '') ? '—' : v; }

  /** 코드값 → 라벨. 코드가 없으면 저장값을 그대로 보여준다(폴백 원칙). */
  function codeNm(grp, cd){
    if (!cd) return '';
    var rows = CODES[grp] || [];
    for (var i = 0; i < rows.length; i++) if (String(rows[i].subcode) === String(cd)) return rows[i].subcodenm;
    return cd;
  }
  function codeOpts(grp, cd){
    var h = '<option value=""></option>', rows = CODES[grp] || [], found = false;
    rows.forEach(function(c){
      var on = (String(c.subcode) === String(cd || ''));
      if (on) found = true;
      h += '<option value="' + esc(c.subcode) + '"' + (on ? ' selected' : '') + '>' + esc(c.subcodenm) + '</option>';
    });
    // 목록에 없는 옛 저장값은 덧붙여 보존한다 — 안 그러면 조용히 지워진다
    if (cd && !found) h += '<option value="' + esc(cd) + '" selected>' + esc(cd) + '</option>';
    return h;
  }

  (function(){
    var y = new Date().getFullYear(), sel = gel('cmYear');
    for (var i = y + 1; i >= y - 4; i--) sel.add(new Option(i + '년', i));
    sel.value = y;
  })();

  window.cmTab = function(n){
    gel('pane1').style.display = (n === 1) ? '' : 'none';
    gel('pane2').style.display = (n === 2) ? '' : 'none';
    gel('tab1').className = 'cm-tab' + (n === 1 ? ' on' : '');
    gel('tab2').className = 'cm-tab' + (n === 2 ? ' on' : '');
  };

  // ── 대장 그리드 ────────────────────────────────────────────────────
  function rowHtml(r, no){
    r = r || {};
    return '<td class="pick" style="text-align:center;color:#8a99a3;">' + no + '</td>' +
      '<td><input type="date" data-f="recvdt" value="' + esc(r.recvdt) + '"></td>' +
      '<td><input data-f="recvmm" value="' + esc(r.recvmm) + '" maxlength="2" style="text-align:center;"></td>' +
      '<td><select data-f="recvcd">' + codeOpts('QPS_CMPL_RECV', r.recvcd) + '</select></td>' +
      '<td><input data-f="personnm" value="' + esc(r.personnm) + '"></td>' +
      '<td><select data-f="personcd">' + codeOpts('QPS_CMPL_PERSON', r.personcd) + '</select></td>' +
      '<td><input data-f="termdays" value="' + esc(r.termdays) + '" style="text-align:center;"></td>' +
      '<td><select data-f="typecd">' + codeOpts('QPS_CMPL_TYPE', r.typecd) + '</select></td>' +
      '<td><input data-f="content" value="' + esc(r.content) + '"></td>' +
      '<td><input data-f="resulttxt" value="' + esc(r.resulttxt) + '"></td>' +
      '<td><input type="date" data-f="replydt" value="' + esc(r.replydt) + '"></td>' +
      '<td><select data-f="replycd">' + codeOpts('QPS_CMPL_REPLY', r.replycd) + '</select></td>' +
      '<td><select data-f="noreplycd">' + codeOpts('QPS_CMPL_NOREPLY', r.noreplycd) + '</select></td>' +
      '<td class="pick" onclick="cmPick(this);">' + (Number(r.hasact) > 0 ? '✔ 상세' : '상세') + '</td>' +
      '<td class="rowdel" onclick="cmDelRow(this);">✕</td>';
  }
  function addRow(r){
    var tb = gel('cmBody');
    var tr = document.createElement('tr');
    tr.setAttribute('data-seq', (r && r.cmplseq) ? r.cmplseq : '');
    tr.innerHTML = rowHtml(r, tb.rows.length + 1);
    tb.appendChild(tr);
    paintRow(tr);
  }
  window.cmAdd = function(){ addRow({}); };

  /** 회신날짜가 없는 행을 눈에 띄게 — 이 대장의 관리 포인트가 '회신했는가'다. */
  function paintRow(tr){
    var rd = tr.querySelector('[data-f=replydt]');
    var any = Array.prototype.some.call(tr.querySelectorAll('[data-f]'), function(el){ return String(el.value).trim(); });
    tr.classList.toggle('noreply', any && rd && !String(rd.value).trim());
  }

  window.cmDelRow = function(el){
    var tr = el.closest('tr'), seq = tr.getAttribute('data-seq');
    if (!seq) { tr.remove(); renumber(); return; }   // 저장 전 행은 그냥 지운다
    _confirmBox({ msg:'이 건을 삭제할까요?<br><span style="font-size:12px;color:#8a99a3;">처리결과 상세도 함께 볼 수 없게 됩니다.</span>',
      icon:'⚠️', okText:'삭제', okColor:'#b23b3b',
      onOk: function(){
        post('<c:url value="/qps/cmplDelete.do"/>', { cmplSeq: seq }).then(function(){
          _toast('삭제되었습니다.', 'ok');
          if (String(curSeq) === String(seq)) { curSeq = 0; clearAct(); }
          cmLoad();
        }).catch(err);
      } });
  };
  function renumber(){
    Array.prototype.forEach.call(gel('cmBody').rows, function(tr, i){ tr.cells[0].textContent = i + 1; });
  }

  // 접수일 → 접수월 자동 채움 + 미회신 표시 갱신
  gel('qpsCmpl').addEventListener('input', function(e){
    var tr = e.target.closest('#cmBody tr');
    if (!tr) return;
    if (e.target.getAttribute('data-f') === 'recvdt') {
      var d = String(e.target.value || '').replace(/-/g, '');
      if (d.length === 8) tr.querySelector('[data-f=recvmm]').value = d.substr(4, 2);
    }
    paintRow(tr);
  });
  gel('qpsCmpl').addEventListener('change', function(e){
    var tr = e.target.closest('#cmBody tr');
    if (tr) paintRow(tr);
  });

  function readRow(tr){
    var r = { cmplseq: tr.getAttribute('data-seq') || '' };
    tr.querySelectorAll('[data-f]').forEach(function(el){ r[el.getAttribute('data-f')] = String(el.value).trim(); });
    return r;
  }
  function collect(){
    var out = [];
    Array.prototype.forEach.call(gel('cmBody').rows, function(tr){
      var r = readRow(tr);
      var has = Object.keys(r).some(function(k){ return k !== 'cmplseq' && r[k] !== ''; });
      if (has) out.push(r);
    });
    return out;
  }

  var LOAD_REQ = 0;   // 조회 순번 — 늦게 온 옛 응답이 새 목록·문서를 덮지 않게(2026-09-08, 일괄 출력에서 실제로 겪음)
  window.cmLoad = function(){
    var my = ++LOAD_REQ;
    return post('<c:url value="/qps/cmplList.do"/>', { inYear: gel('cmYear').value }).then(function(res){
      if (my !== LOAD_REQ) return;   // 더 새 조회가 나갔다 — 옛 응답은 버린다(2026-09-08)
      if (res.hosp) { HOSP_NM = res.hosp.hospnm || ''; gel('cmHosp').textContent = '🏥 ' + HOSP_NM; }
      APPR_LINE = res.line || [];
      ROWS = res.list || [];
      var tb = gel('cmBody');
      tb.innerHTML = '';
      ROWS.forEach(addRow);
      if (!ROWS.length) { addRow({}); addRow({}); addRow({}); }
      gel('cmCnt').textContent = ROWS.length ? ('· ' + ROWS.length + '건') : '· 자료 없음';
      gel('cmStat').textContent = '';
    }).catch(err);
  };

  window.cmSaveAll = function(){
    var rows = collect();
    if (!rows.length) { _alertBox('저장할 내용이 없습니다.', {icon:'⚠️'}); return; }
    post('<c:url value="/qps/cmplSave.do"/>', { inYear: gel('cmYear').value, rows: JSON.stringify(rows) })
      .then(function(res){
        _toast((res.saved || 0) + '건 저장되었습니다.', 'ok');
        return cmLoad();
      }).catch(err);
  };

  // ── 건 고르기 → 처리결과 상세 ─────────────────────────────────────
  window.cmPick = function(el){
    var tr = el.closest('tr'), seq = tr.getAttribute('data-seq');
    if (!seq) { _alertBox('먼저 [대장 저장]을 눌러 이 건을 저장해 주세요.<br>저장된 건에만 처리결과를 붙일 수 있습니다.', {icon:'⚠️'}); return; }
    Array.prototype.forEach.call(gel('cmBody').rows, function(x){ x.classList.remove('sel'); });
    tr.classList.add('sel');
    curSeq = Number(seq);

    // 대장 값(읽기 전용 머리) — 상세에서 다시 입력받지 않는다
    var r = readRow(tr);
    txt('a_recvDt',  r.recvdt);
    txt('a_recvCd',  codeNm('QPS_CMPL_RECV', r.recvcd));
    txt('a_person',  (r.personnm || '') + (r.personcd ? ' (' + codeNm('QPS_CMPL_PERSON', r.personcd) + ')' : ''));
    txt('a_replyCd', codeNm('QPS_CMPL_REPLY', r.replycd));
    txt('a_content', r.content);
    set('a_cmplSeq', seq);

    // ★프라미스(성공 true/실패 false)를 돌려준다(2026-09-08) — 일괄 출력이 「고름 → 처리결과 인쇄」 를 차례로 잇는 데 쓴다
    return post('<c:url value="/qps/cmplActGet.do"/>', { cmplSeq: seq }).then(function(res){
      var a = res.act || {};
      set('a_rptDt', a.rptdt); set('a_deptNm', a.deptnm); set('a_imprDt', a.imprdt);
      set('a_place', a.place); set('a_problem', a.problem); set('a_analysis', a.analysis);
      set('a_planTxt', a.plantxt); set('a_actTxt', a.acttxt); set('a_cause', a.cause);
      set('a_answer', a.answer); set('a_prevent', a.prevent);
      if (!(window.BP && BP.busy)) cmTab(2);   // 일괄 출력 중엔 탭을 안 바꾼다(끝에 원래 탭으로)
      return true;
    }).catch(function(e){ err(e); return false; });
  };
  function clearAct(){
    ['a_cmplSeq','a_rptDt','a_deptNm','a_imprDt','a_place','a_problem','a_analysis',
     'a_planTxt','a_actTxt','a_cause','a_answer','a_prevent'].forEach(function(id){ set(id, ''); });
    ['a_recvDt','a_recvCd','a_person','a_replyCd','a_content'].forEach(function(id){ txt(id, ''); });
  }

  window.cmActSave = function(){
    if (!curSeq) { _alertBox('대장에서 건을 먼저 고르세요.', {icon:'⚠️'}); return; }
    post('<c:url value="/qps/cmplActSave.do"/>', {
      cmplSeq: curSeq, inYear: gel('cmYear').value,
      rptDt: val('a_rptDt'), deptNm: val('a_deptNm'), imprDt: val('a_imprDt'), place: val('a_place'),
      problem: val('a_problem'), analysis: val('a_analysis'), planTxt: val('a_planTxt'),
      actTxt: val('a_actTxt'), cause: val('a_cause'), answer: val('a_answer'), prevent: val('a_prevent')
    }).then(function(){
      _toast('저장되었습니다.', 'ok');
      var keep = curSeq;
      return cmLoad().then(function(){
        // 저장 후 목록이 다시 그려져도 고른 건은 유지한다
        Array.prototype.forEach.call(gel('cmBody').rows, function(tr){
          if (String(tr.getAttribute('data-seq')) === String(keep)) tr.classList.add('sel');
        });
        curSeq = keep;
      });
    }).catch(err);
  };

  // ---------- 인쇄 ----------
  var PRINT_CSS =
    'body{ margin:0; font-family:"맑은 고딕",Malgun Gothic,sans-serif; color:#000; }' +
    '.h1{ font-size:17px; font-weight:800; text-align:center; margin:0 0 10px; letter-spacing:1px; }' +
    'table{ width:100%; border-collapse:collapse; font-size:9.5px; margin-bottom:6px; }' +
    'th,td{ border:1px solid #666; padding:3px 4px; text-align:center; vertical-align:middle; line-height:1.5; }' +
    'th{ background:#efefef; font-weight:700; }' +
    'td.l{ text-align:left; } td.pre{ text-align:left; white-space:pre-wrap; }' +
    '.appr{ float:right; width:auto; margin:0 0 6px 8px; font-size:10px; }' +
    '.appr th{ padding:2px 6px; } .appr td{ height:44px; width:60px; }' +
    'tr{ page-break-inside:avoid; }';

  function apprHtml(){
    if (!APPR_LINE.length) return '';
    var h = '<table class="appr"><thead><tr>';
    APPR_LINE.forEach(function(r){ h += '<th>' + esc(r.stepnm) + '</th>'; });
    h += '</tr></thead><tbody><tr>';
    APPR_LINE.forEach(function(){ h += '<td></td>'; });
    return h + '</tr></tbody></table>';
  }
  function openPrint(title, css, body){
    /* 인쇄는 공통 창구로 — 낱장·일괄이 같은 조립을 쓴다(2026-09-07) */
    qpsPrintOut(title, css, body);
  }

  /** 대장 인쇄 — 가로(A4 landscape). 컬럼이 12개라 세로로는 못 담는다. */
  window.cmPrintBook = function(){
    var yy = gel('cmYear').value, rows = collect();
    var body = '<div class="h1">' + esc(yy) + ' 년 불만고충처리 대장</div>' +
      '<table><thead><tr><th style="width:26px;">번호</th><th style="width:34px;">접수월</th>' +
      '<th style="width:62px;">접수일</th><th style="width:62px;">접수유형</th><th style="width:56px;">민원인</th>' +
      '<th style="width:44px;">처리<br>기간</th><th style="width:62px;">불만고충<br>유형</th><th>불만고충내용</th>' +
      '<th>처리결과</th><th style="width:62px;">회신날짜</th><th style="width:52px;">회신방법</th>' +
      '<th style="width:74px;">미회신사유</th></tr></thead><tbody>' +
      (rows.length ? rows.map(function(r, i){
        return '<tr><td>' + (i + 1) + '</td><td>' + esc(r.recvmm) + '</td><td>' + esc(r.recvdt) + '</td>' +
          '<td>' + esc(codeNm('QPS_CMPL_RECV', r.recvcd)) + '</td><td>' + esc(r.personnm) + '</td>' +
          '<td>' + esc(r.termdays) + '</td><td>' + esc(codeNm('QPS_CMPL_TYPE', r.typecd)) + '</td>' +
          '<td class="l">' + esc(r.content) + '</td><td class="l">' + esc(r.resulttxt) + '</td>' +
          '<td>' + esc(r.replydt) + '</td><td>' + esc(codeNm('QPS_CMPL_REPLY', r.replycd)) + '</td>' +
          '<td>' + esc(codeNm('QPS_CMPL_NOREPLY', r.noreplycd)) + '</td></tr>';
      }).join('')
      // 원본은 자료가 없으면 <No data to display> 를 찍는다. 우리는 우리말로.
      : '<tr><td colspan="12" style="padding:20px;color:#666;">접수된 불만고충이 없습니다.</td></tr>') +
      '</tbody></table>';
    openPrint('불만고충처리대장_' + yy + '_' + HOSP_NM,
      '@page{ size:A4 landscape; margin:10mm; }' + PRINT_CSS, body);
  };

  /** 처리결과 인쇄 — A4 세로 1장. 대장 값(접수방법·민원인·내용·고객통보)이 함께 찍힌다. */
  window.cmActPrint = function(){
    if (!curSeq) { _alertBox('대장에서 건을 먼저 고르세요.', {icon:'⚠️'}); return; }
    function row(lb, v){ return '<tr><th style="width:118px;">' + lb + '</th><td class="pre" colspan="3">' + esc(v) + '</td></tr>'; }
    var actRows = String(val('a_actTxt')).split('\n').map(function(s){ return s.trim(); }).filter(function(s){ return s; });
    var actTbl = '<table><thead><tr><th style="width:110px;">유형</th>' +
      '<th>불만고충 문제점</th><th>개선활동</th></tr></thead><tbody>' +
      (actRows.length ? actRows : ['']).map(function(ln){
        var p = ln.split('|');
        return '<tr><td>' + esc(p[0] || '') + '</td><td class="l">' + esc(p[1] || '') +
               '</td><td class="l">' + esc(p[2] || '') + '</td></tr>';
      }).join('') + '</tbody></table>';

    var body = apprHtml() +
      '<div class="h1">불만고충 개선활동 처리결과 보고서</div><div style="clear:both;"></div>' +
      '<table><tbody>' +
        '<tr><th style="width:118px;">보고날짜</th><td class="l" style="width:32%;">' + esc(val('a_rptDt')) + '</td>' +
            '<th style="width:118px;">부서명</th><td class="l">' + esc(val('a_deptNm')) + '</td></tr>' +
        '<tr><th>접수날짜</th><td class="l">' + esc(gel('a_recvDt').textContent) + '</td>' +
            '<th>개선날짜</th><td class="l">' + esc(val('a_imprDt')) + '</td></tr>' +
        '<tr><th>접수방법</th><td class="l">' + esc(gel('a_recvCd').textContent) + '</td>' +
            '<th>민원인</th><td class="l">' + esc(gel('a_person').textContent) + '</td></tr>' +
        row('민원발생장소', val('a_place')) +
        row('불만고충내용', gel('a_content').textContent) +
        row('문제진술', val('a_problem')) +
        row('현상파악 및 원인분석', val('a_analysis')) +
        row('개선 대책안', val('a_planTxt')) +
      '</tbody></table>' + actTbl +
      '<table><tbody>' +
        row('원인', val('a_cause')) +
        row('조치 및 답변', val('a_answer')) +
        row('재발방지대책', val('a_prevent')) +
        '<tr><th>고객통보</th><td class="l" colspan="3">' + esc(gel('a_replyCd').textContent) + '</td></tr>' +
      '</tbody></table>';
    openPrint('불만고충처리결과_' + gel('cmYear').value + '_' + HOSP_NM,
      '@page{ size:A4 portrait; margin:12mm; }' + PRINT_CSS + 'table{font-size:10.5px;}', body);
  };

  /* ═══ 🖨 화면 안 일괄 출력 (2026-09-08 — 확장 7호 · 대장 + 건별 보고서) ═══
     처리대장은 「연 1장(가로 · 그 해 전체 건) + 건마다 처리결과 보고서(세로)」다. 조건 = 연도 + 접수일 월 범위 + 무엇을 담을지(체크 둘).
     ①대장은 cmPrintBook(화면 표 그대로) ②처리결과는 ROWS 중 hasact 있고 접수일이 범위 안인 건마다 cmPick → cmActPrint.
     QPS_BULK_CB 로 모아 끝에 qpsPrintMerge(sidebar.jsp) — 장마다 제 종이 방향(가로/세로)이 붙는다.
     ★다른 해를 고르면 cmLoad 로 대장을 다시 그린다(저장 안 한 수정은 사라짐 — 안내문에 적음). 끝나면 보던 해·건·탭으로. 상한 120장. */
  window.BP = { busy:false };
  function bpFill(){
    var ys = gel('cmBpYear');
    if (ys.options.length) return;
    Array.prototype.forEach.call(gel('cmYear').options, function(o){ ys.add(new Option(o.text, o.value)); });
    var mf = gel('cmBpFrom'), mt = gel('cmBpTo');
    for (var m = 1; m <= 12; m++) { mf.add(new Option(m + '월', m)); mt.add(new Option(m + '월', m)); }
  }
  window.cmBulkPrintToggle = function(){
    var box = gel('cmBulkPrintBox');
    if (box.style.display !== 'none') { box.style.display = 'none'; return; }
    bpFill();
    gel('cmBpYear').value = gel('cmYear').value; gel('cmBpFrom').value = '1'; gel('cmBpTo').value = '12';
    gel('cmBpStat').textContent = '';
    box.style.display = '';
  };
  /** 접수일(없으면 접수월)의 달이 범위 안인가 */
  function bpInRange(r, f, t){
    var m = Number(String(r.recvdt || '').replace(/-/g, '').substr(4, 2)) || Number(r.recvmm || 0);
    if (!m) return false;
    return m >= f && m <= t;
  }
  function rowOf(seq){ return gel('cmBody').querySelector('tr[data-seq="' + seq + '"]'); }
  window.cmBulkPrintGo = function(){
    if (BP.busy) return;
    var wantBook = gel('cmBpBook').checked, wantAct = gel('cmBpAct').checked;
    if (!wantBook && !wantAct) { _alertBox('대장·처리결과 보고서 중 하나는 골라야 합니다.', {icon:'⚠️'}); return; }
    var yy = gel('cmBpYear').value, f = Number(gel('cmBpFrom').value), t = Number(gel('cmBpTo').value);
    if (f > t) { var x = f; f = t; t = x; gel('cmBpFrom').value = String(f); gel('cmBpTo').value = String(t); }
    var keepYear = gel('cmYear').value, keepSeq = curSeq, keepTab = (gel('pane2').style.display !== 'none') ? 2 : 1;
    var changed = (yy !== keepYear);
    var title = '불만고충처리_' + yy + '년' + ((f === 1 && t === 12) ? '' : ('_' + f + '~' + t + '월')) + '_' + HOSP_NM;
    var parts = [], MAX = 120, done = 0, stat = gel('cmBpStat');
    BP.busy = true; gel('cmBpGo').disabled = true;
    window.QPS_BULK_CB = function(p){ parts.push(p); };
    var finish = function(){
      window.QPS_BULK_CB = null;
      var back = Promise.resolve();
      if (changed) { gel('cmYear').value = keepYear; back = Promise.resolve(cmLoad()); }   // 보던 해의 대장으로
      back.then(function(){
        var tr = keepSeq ? rowOf(keepSeq) : null;
        return tr ? cmPick(tr) : null;                    // 보던 건의 처리결과로(BP.busy 라 탭은 안 바뀐다)
      }).then(function(){
        cmTab(keepTab);
        BP.busy = false; gel('cmBpGo').disabled = false;
        if (!parts.length) { stat.textContent = '기간 안에 찍을 것이 없습니다.'; return; }
        var n = qpsPrintMerge(parts, title);
        stat.textContent = (n < 0) ? '팝업이 막혀 인쇄창을 열지 못했습니다.' :
                           (parts.length + '장을 이어 붙였습니다' + (done >= MAX ? ' (상한 ' + MAX + '장)' : '') + '.');
      }, function(){ cmTab(keepTab); BP.busy = false; gel('cmBpGo').disabled = false; });
    };
    var start = Promise.resolve();
    if (changed) { gel('cmYear').value = yy; stat.textContent = yy + '년 대장 읽는 중 …'; start = Promise.resolve(cmLoad()); }
    start.then(function(){
      if (wantBook) { try { cmPrintBook(); done++; } catch (e) { } }
      var docs = wantAct ? (ROWS || []).filter(function(r){ return Number(r.hasact) > 0 && bpInRange(r, f, t); }) : [], j = 0;
      var oneDoc = function(){
        if (j >= docs.length || done >= MAX) { finish(); return; }
        var seq = Number(docs[j++].cmplseq), tr = rowOf(seq);
        if (!tr) { oneDoc(); return; }
        Promise.resolve(cmPick(tr)).then(function(okv){
          if (okv && curSeq === seq) { try { cmActPrint(); done++; } catch (e) { } }   // 못 읽은 건은 건너뛴다 — 앞 건의 처리결과가 찍히면 안 된다
          stat.textContent = yy + '년 — ' + done + '장';
          oneDoc();
        }, function(){ oneDoc(); });
      };
      oneDoc();
    }, function(){ finish(); });
  };

  // 코드 먼저, 그 다음 목록 — 셀렉트를 그릴 때 코드가 있어야 한다
  $(function(){
    post('<c:url value="/qps/codeList.do"/>', {}).then(
      function(res){ CODES = (res && res.codes) || {}; cmLoad(); },
      function(){ CODES = {}; cmLoad(); }        // 코드가 없어도 대장은 열린다(폴백)
    );
  });
})();

/* === 글자 크기 (2026-08-18 요청) ==========================================
   QI 계획서(qpsQiPlan)의 zzZoom 과 **같은 규칙** - 0.8~1.6배, 0.1 단위, ↺ 는 처음 크기.
   ★고른 크기는 **이 PC 이 브라우저에만** 남는다(localStorage). 키는 화면마다 따로 둔다. */
(function(){
  var W = 'qpsCmpl', ZKEY = 'qpsZoom_' + W;
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
</div><%-- /#qpsCmpl --%>
</div><%-- /.dashboard-wrapper --%>
