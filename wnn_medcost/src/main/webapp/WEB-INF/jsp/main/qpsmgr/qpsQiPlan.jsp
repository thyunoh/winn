<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%-- qpsQiPlan.jsp — QI 활동 계획서 (QI 폴더 #1, 2026-08-11)

     원본 실물 10장(낙상·손위생·신체보호대·욕창·불만고충·영양실·근접오류·투약오류·
     학대및폭력·재택복귀율) 대조 — ***서식은 하나이고 주제별로 한 장***이다.

     ★★핵심지표 블록이 우리 지표정의서와 1:1 로 대응한다.
       주제로 지표를 고르면 지표명·분자·분모·포함/제외기준·목표값·배수가 **자동으로 채워진다.**
       (원본은 이 칸들을 손으로 적었다. 10장의 배수가 우리 마스터와 전부 일치하는 것을 확인했다.)
     ★그래도 값은 저장한다(스냅샷) — 결재가 찍히는 문서라 나중에 정의서를 고쳐도
       그때 결재한 내용이 남아야 한다. 자동으로 채운 뒤에도 손으로 고칠 수 있다.
     ★주제는 코드 고정이 아니다 — 「영양실」·「근접오류」는 지표 마스터에 없다. 직접입력을 받는다.

     ★주의: 이 파일 안에서 Deferred EL 표기(샵+중괄호) 금지 --%>

<script src="/asset/js/ui-message.js"></script>
<script src="/asset/js/ui-split.js"></script>
<script src="/asset/js/ui-find.js"></script>

<div class="dashboard-wrapper">
<div id="qpsQiPlan" data-wnn="<c:out value='${wnnYn}'/>">
<style>
  #qpsQiPlan{ background:#f4f6f8; color:#1f2a30; min-height:100%; padding:14px 16px 60px; max-width:100%; overflow-x:hidden; }
  #qpsQiPlan *{ box-sizing:border-box; }
  #qpsQiPlan .qi-head{ display:flex; align-items:center; gap:10px; margin-bottom:12px; flex-wrap:wrap; }
  #qpsQiPlan .qi-title{ font-size:18px; font-weight:800; color:#20303a; display:flex; align-items:center; gap:8px; }
  #qpsQiPlan .qi-dot{ width:10px; height:10px; border-radius:50%; background:linear-gradient(135deg,#1f5a4b,#2a7665); }
  #qpsQiPlan .qi-sub{ font-size:12px; color:#6b7c86; }
  #qpsQiPlan .qi-hosp{ background:#e7f3ee; color:#1f5a4b; font-size:12px; font-weight:800;
      border:1px solid #cfe3da; border-radius:14px; padding:3px 11px; }
  #qpsQiPlan .qi-spacer{ flex:1; }
  #qpsQiPlan select, #qpsQiPlan input, #qpsQiPlan textarea{
      border:1px solid #cfd8e0; border-radius:5px; padding:5px 7px; font-family:inherit; font-size:12.5px; background:#fff; }
  #qpsQiPlan textarea{ resize:vertical; line-height:1.55; width:100%; }
  #qpsQiPlan .qi-btn{ border:1px solid #1f5a4b; background:#1f5a4b; color:#fff; border-radius:6px;
      padding:6px 14px; font-size:13px; font-weight:600; cursor:pointer; white-space:nowrap; }
  #qpsQiPlan .qi-btn.ghost{ background:#fff; color:#1f5a4b; }
  #qpsQiPlan .qi-btn.warn{ background:#fff; color:#b23b3b; border-color:#e0b4b4; }
  #qpsQiPlan .qi-btn.mini{ padding:2px 9px; font-size:11.5px; border-color:#cfd8e0; color:#556570; background:#fff; }

  #qpsQiPlan .qi-wrap{ display:flex; gap:14px; align-items:flex-start; }
  #qpsQiPlan .qi-left{ width:270px; flex:none; }
  #qpsQiPlan .qi-right{ flex:1; min-width:0; max-width:1000px; }
  #qpsQiPlan .qi-card{ background:#fff; border:1px solid #e3e9ed; border-radius:10px; padding:14px 16px; margin-bottom:12px; }
  #qpsQiPlan .qi-card h4{ margin:0 0 10px; font-size:14px; font-weight:800; color:#1f5a4b; }
  #qpsQiPlan .qi-card h4 .hint{ font-weight:500; font-size:12px; color:#8a99a3; }

  #qpsQiPlan .qi-list{ max-height:560px; overflow:auto; }
  #qpsQiPlan .qi-item{ padding:8px 10px; border:1px solid #eef2f5; border-radius:8px; margin-bottom:6px; cursor:pointer; }
  #qpsQiPlan .qi-item:hover{ border-color:#8fc3b2; background:#f7fbf9; }
  #qpsQiPlan .qi-item.on{ border-color:#1f5a4b; background:#f0f7f4; }
  #qpsQiPlan .qi-item .t{ font-size:13px; font-weight:700; color:#20303a; }
  #qpsQiPlan .qi-item .d{ font-size:11.5px; color:#8a99a3; margin-top:2px; }
  #qpsQiPlan .qi-empty{ color:#8a99a3; font-size:12.5px; padding:16px 6px; text-align:center; }

  #qpsQiPlan .qi-form{ display:grid; grid-template-columns:110px 1fr 110px 1fr; gap:9px 10px; align-items:start; }
  #qpsQiPlan .qi-form .lb{ font-size:12.5px; font-weight:700; color:#43555f; padding-top:8px; }
  #qpsQiPlan .qi-form .full{ grid-column:2 / -1; }
  #qpsQiPlan .qi-form input{ width:100%; }
  #qpsQiPlan table.ed{ width:100%; border-collapse:collapse; font-size:12.5px; }
  #qpsQiPlan table.ed th{ background:#f2f6f8; border:1px solid #dde5ea; padding:5px 4px; font-weight:700; color:#43555f; white-space:nowrap; }
  #qpsQiPlan table.ed td{ border:1px solid #e6ecef; padding:3px; }
  #qpsQiPlan table.ed input{ width:100%; border:none; background:transparent; padding:4px 5px; }
  #qpsQiPlan table.ed input:focus{ background:#f7fbf9; outline:1px solid #8fc3b2; }
  #qpsQiPlan input[type=checkbox]{
      -webkit-appearance:checkbox !important; appearance:auto !important;
      width:15px !important; height:15px !important; margin:4px auto !important; display:block !important;
      opacity:1 !important; visibility:visible !important; position:static !important; cursor:pointer; }
  #qpsQiPlan .rowdel{ color:#b23b3b; cursor:pointer; font-weight:700; text-align:center; width:26px; }
  #qpsQiPlan .autofill{ background:#f0f7f4; border:1px solid #cfe3da; border-radius:6px;
      padding:6px 10px; font-size:12px; color:#1f5a4b; margin-bottom:8px; }
  /* ── 탭 · 글자 크기 (2026-08-15) — 카드가 세로로 쌓여 스크롤이 길다는 지적.
       ★한 화면에 들어가면 **탭을 내지 않는다**(고정으로 달지 않는다).
       ★탭 이름은 카드 제목에서 뽑고, 많으면 이웃끼리 묶어 **최대 4개**. */
  #qpsQiPlan .zz-tabs{ display:flex; gap:6px; margin:0 0 10px; flex-wrap:wrap; align-items:center; }
  #qpsQiPlan .zz-tab{ border:1px solid #cfd9e0; background:#f4f7f9; color:#43555f; border-radius:8px 8px 0 0;
                   padding:7px 15px; font-size:13.5px; font-weight:700; cursor:pointer; }
  #qpsQiPlan .zz-tab:hover{ background:#e9eff3; }
  #qpsQiPlan .zz-tab.on{ background:#1f5a4b; border-color:#1f5a4b; color:#fff; }
  #qpsQiPlan .zz-tab.dim{ opacity:.5; }
  #qpsQiPlan .zz-mode{ margin-left:auto; border:1px solid #1f5a4b; background:#fff; color:#1f5a4b;
                    border-radius:8px; padding:7px 14px; font-size:13px; font-weight:700; cursor:pointer; }
  #qpsQiPlan .zz-mode.on{ background:#1f5a4b; color:#fff; }
  /* ★오른쪽 끝을 조금 띄운다(2026-08-18) — 화면 가장자리에 붙어 마지막 단추가 잘려 보였다 */
  #qpsQiPlan .zz-zoom{ display:inline-flex; gap:4px; align-items:center; margin-left:2px; margin-right:14px; }
  #qpsQiPlan .zz-zoom button{ border:1px solid #cfd9e0; background:#fff; color:#43555f; border-radius:6px;
                           padding:4px 9px; font-size:13px; font-weight:700; cursor:pointer; }
  #qpsQiPlan .zz-zoom button:hover{ background:#eef3f6; }
</style>

<div class="qi-head">
  <div class="qi-title"><span class="qi-dot"></span>QI 활동 계획서 <span class="qi-sub">주제별 1부</span></div>
  <span class="qi-hosp" id="qpHosp">🏥 <c:out value="${hospNm}" default="병원 미확인"/></span>
  <div class="qi-spacer"></div>
  <select id="qpYear" style="width:auto;" onchange="qpList();"></select>
  <button type="button" class="qi-btn" onclick="qpSave();">저장</button>
  <button type="button" class="qi-btn ghost" onclick="qpPrint();">🖨 인쇄(A4)</button>
  <button type="button" class="qi-btn warn" id="qpDelBtn" onclick="qpDel();" style="display:none;">삭제</button>
  <span class="qi-sub" id="qpStat"></span>
  <%-- ★[2026-08-18 요청 「글자크기 단추가 너무 우측 끝에 있다 — 조금 좌측으로」]
       이 빈 칸이 묶음을 오른쪽 끝까지 밀고 있었다(60 → 12px). 끝 단추 ↺ 가 화면 밖으로 잘리던 것도 같은 원인. --%>
  <span style="flex:0 0 12px;"></span>
  <%-- 글자 크기 — 이 PC 이 브라우저에만 저장된다 --%>
  <span class="zz-zoom">
    <button type="button" onclick="zzZoom(-1);" title="글자 작게">가－</button>
    <button type="button" onclick="zzZoom(1);"  title="글자 크게">가＋</button>
    <button type="button" onclick="zzZoom(0);"  title="처음 크기로">↺</button>
  </span>
</div>
<%-- ★탭 — 내용이 한 화면을 넘칠 때만 나온다(zzSync 가 재 본다) --%>
<div class="zz-tabs" id="zzTabs" style="display:none;"></div>

<div class="qi-wrap" data-split="가로" data-split-key="qiplan.body">
  <div class="qi-left">
    <div class="qi-card">
      <h4>계획서 목록 <span class="hint" id="qpCnt"></span></h4>
      <div class="qi-list" id="qpListBox" data-find="계획 찾기"><div class="qi-empty">불러오는 중…</div></div>
      <button type="button" class="qi-btn ghost" style="width:100%; margin-top:6px;" onclick="qpNew();">＋ 새 계획서</button>
    </div>
  </div>

  <div class="qi-right">
    <div class="qi-card">
      <h4>기본</h4>
      <input type="hidden" id="f_qipSeq" value="">
      <div class="qi-form">
        <div class="lb">제출부서</div> <div><input type="text" id="f_deptNm" maxlength="60"></div>
        <div class="lb">제출일</div>   <div><input type="date" id="f_submitDt"></div>
        <div class="lb">주제 *</div>
        <div class="full" style="display:flex; gap:8px; flex-wrap:wrap;">
          <%-- 지표를 고르면 아래 핵심지표가 자동으로 채워진다. 지표에 없는 주제(영양실 등)는 직접 적는다. --%>
          <select id="f_indiCd" style="width:260px;" onchange="qpPickIndi();">
            <option value="">— 지표에서 고르기 (없으면 직접 입력) —</option>
          </select>
          <input type="text" id="f_topicNm" maxlength="200" placeholder="주제명" style="flex:1; min-width:200px;">
        </div>
        <div class="lb">주제선정 배경</div> <div class="full"><textarea id="f_background" rows="3"></textarea></div>
      </div>
    </div>

    <div class="qi-card">
      <h4>핵심지표 <span class="hint">— 위에서 지표를 고르면 자동으로 채워집니다. 고쳐도 됩니다</span></h4>
      <div class="autofill" id="qpAutoMsg" style="display:none;"></div>
      <div class="qi-form">
        <div class="lb">지표명</div>   <div class="full"><input type="text" id="f_indiNm" maxlength="200"></div>
        <div class="lb">분자</div>     <div><input type="text" id="f_numerDesc" maxlength="500"></div>
        <div class="lb">배수</div>
        <div style="display:flex; gap:6px; align-items:center;">
          <span style="font-size:12.5px; color:#43555f;">X</span>
          <input type="text" id="f_multiplier" style="width:80px; text-align:center;" placeholder="1000">
          <input type="text" id="f_unit" style="width:56px; text-align:center;" placeholder="‰">
        </div>
        <div class="lb">분모</div>     <div class="full"><input type="text" id="f_denomDesc" maxlength="500"></div>
        <div class="lb">포함기준</div> <div class="full"><textarea id="f_includeTxt" rows="2"></textarea></div>
        <div class="lb">제외기준</div> <div class="full"><textarea id="f_excludeTxt" rows="2"></textarea></div>
        <div class="lb">목표값</div>   <div class="full"><input type="text" id="f_targetVal" maxlength="60"
             placeholder="예) 낙상 발생 보고율 0.5 ‰ 이하"></div>
      </div>
    </div>

    <%-- 팀구성 — 원본은 구분|성명 을 가로 4벌로 반복한다. 화면은 세로 목록으로 받고 인쇄에서 조립한다
         (인원이 12명을 넘거나 모자랄 수 있다. 불만고충 처리계획서와 같은 방식). --%>
    <div class="qi-card">
      <h4>팀구성 <span class="hint">— 인쇄물에서는 원본처럼 가로 4벌 표로 조립됩니다</span></h4>
      <table class="ed" style="max-width:520px;"><thead><tr>
        <th style="width:110px;">구분</th><th>성명</th><th style="width:26px;"></th>
      </tr></thead><tbody id="tbTEAM"></tbody></table>
      <button type="button" class="qi-btn mini" style="margin-top:6px;" onclick="qpAddTeam();">＋ 행 추가</button>
    </div>

    <div class="qi-card">
      <h4>자료수집 · 개선전략</h4>
      <div class="qi-form">
        <div class="lb">자료수집</div> <div class="full"><textarea id="f_srcTxt" rows="3"></textarea></div>
        <div class="lb">개선전략<br>개선활동평가관리</div> <div class="full"><textarea id="f_strategyTxt" rows="3"></textarea></div>
      </div>
    </div>

    <%-- 활동일정 — 원본은 PDCA 5행 고정 × 12개월 체크 --%>
    <div class="qi-card">
      <h4>활동일정 <span class="hint">— PDCA 단계별로 실시하는 달에 체크</span></h4>
      <div style="overflow-x:auto;">
      <table class="ed" style="min-width:760px;"><thead><tr>
        <th style="width:34px;"></th><th style="min-width:170px;">활동</th>
        <th style="width:28px;">1</th><th style="width:28px;">2</th><th style="width:28px;">3</th><th style="width:28px;">4</th>
        <th style="width:28px;">5</th><th style="width:28px;">6</th><th style="width:28px;">7</th><th style="width:28px;">8</th>
        <th style="width:28px;">9</th><th style="width:28px;">10</th><th style="width:28px;">11</th><th style="width:28px;">12</th>
        <th style="width:26px;"></th>
      </tr></thead><tbody id="tbSCHED"></tbody></table>
      </div>
      <button type="button" class="qi-btn mini" style="margin-top:6px;" onclick="qpAddSched();">＋ 행 추가</button>
    </div>

    <div class="qi-card">
      <h4>기대효과 및 기타</h4>
      <textarea id="f_expectTxt" rows="3"></textarea>
    </div>
  </div>
</div>

<script>
(function(){
  var HOSP_NM = '', APPR_LINE = [], INDI = [], curSeq = 0;

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

  (function(){
    var y = new Date().getFullYear(), sel = gel('qpYear');
    for (var i = y + 1; i >= y - 4; i--) sel.add(new Option(i + '년', i));
    sel.value = y;
  })();

  // ── 행 ─────────────────────────────────────────────────────────────
  function teamRow(r){
    r = r || {};
    var tr = document.createElement('tr');
    tr.setAttribute('data-sect', 'TEAM');
    tr.innerHTML =
      '<td><input data-f="grp" value="' + esc(r.grp) + '" placeholder="팀장·간사·팀원"></td>' +
      '<td><input data-f="c1" value="' + esc(r.c1) + '"></td>' +
      '<td class="rowdel" onclick="this.closest(\'tr\').remove();">✕</td>';
    gel('tbTEAM').appendChild(tr);
  }
  function schedRow(r){
    r = r || {};
    var m = '';
    for (var i = 1; i <= 12; i++){
      var k = 'm' + (i < 10 ? '0' + i : i);
      m += '<td><input type="checkbox" data-f="' + k + '"' + (r[k] === 'Y' ? ' checked' : '') + '></td>';
    }
    var tr = document.createElement('tr');
    tr.setAttribute('data-sect', 'SCHED');
    tr.innerHTML =
      '<td><input data-f="grp" value="' + esc(r.grp) + '" style="text-align:center;font-weight:700;"></td>' +
      '<td><input data-f="c1" value="' + esc(r.c1) + '"></td>' + m +
      '<td class="rowdel" onclick="this.closest(\'tr\').remove();">✕</td>';
    gel('tbSCHED').appendChild(tr);
  }
  window.qpAddTeam  = function(){ teamRow({}); };
  window.qpAddSched = function(){ schedRow({}); };

  // 새 문서 기본 틀 — 원본 서식의 고정 행
  var DEF_TEAM = [{grp:'팀장'},{grp:'간사'},{grp:'팀원'},{grp:'팀원'},{grp:'팀원'},{grp:'팀원'}];
  var DEF_SCHED = [
    { grp:'P', c1:'현황파악/원인분석' },
    { grp:'P', c1:'개선활동 계획수립' },
    { grp:'D', c1:'개선활동 실시' },
    { grp:'C', c1:'개선활동 효과파악' },
    { grp:'A', c1:'결과보고/사후관리' }
  ];

  function readRow(tr){
    var r = { sect: tr.getAttribute('data-sect') };
    tr.querySelectorAll('[data-f]').forEach(function(el){
      r[el.getAttribute('data-f')] = (el.type === 'checkbox') ? (el.checked ? 'Y' : '') : String(el.value).trim();
    });
    return r;
  }
  function collect(){
    var items = [];
    ['TEAM','SCHED'].forEach(function(sect){
      var sort = 0;
      document.querySelectorAll('#tb' + sect + ' tr').forEach(function(tr){
        var r = readRow(tr);
        var has = Object.keys(r).some(function(k){ return k !== 'sect' && r[k] !== '' && r[k] != null; });
        if (!has) return;
        r.sort = ++sort;
        items.push(r);
      });
    });
    return items;
  }

  /* ★주제로 지표를 고르면 핵심지표가 자동으로 채워진다.
     이미 손으로 적어 둔 칸은 덮지 않는다 — 고쳐 놓은 문구를 되돌리면 안 된다. */
  window.qpPickIndi = function(){
    var cd = val('f_indiCd');
    if (!cd) { gel('qpAutoMsg').style.display = 'none'; return; }
    var d = null;
    for (var i = 0; i < INDI.length; i++) if (String(INDI[i].indicd) === cd) { d = INDI[i]; break; }
    if (!d) return;
    if (!val('f_topicNm')) set('f_topicNm', d.indinm);
    var n = 0;
    function fill(id, v){ if (v != null && String(v) !== '' && !val(id)) { set(id, v); n++; } }
    fill('f_indiNm', d.indinm);
    fill('f_numerDesc', d.numerdesc);
    fill('f_denomDesc', d.denomdesc);
    fill('f_multiplier', d.multiplier);
    fill('f_unit', d.unit);
    fill('f_targetVal', d.targetval);
    var msg = gel('qpAutoMsg');
    msg.style.display = '';
    msg.innerHTML = n ? ('지표정의서에서 ' + n + '개 칸을 채웠습니다. 필요하면 고치세요.')
                      : '이미 적힌 칸은 그대로 두었습니다(자동으로 덮지 않습니다).';
  };

  window.qpList = function(){
    return post('<c:url value="/qps/qiPlanList.do"/>', { inYear: gel('qpYear').value }).then(function(res){
      if (res.hosp) { HOSP_NM = res.hosp.hospnm || ''; gel('qpHosp').textContent = '🏥 ' + HOSP_NM; }
      APPR_LINE = res.line || [];
      INDI = res.indi || [];
      var sel = gel('f_indiCd'), keep = sel.value;
      sel.innerHTML = '<option value="">— 지표에서 고르기 (없으면 직접 입력) —</option>';
      INDI.forEach(function(d){ sel.add(new Option(d.indinm, d.indicd)); });
      sel.value = keep;

      var list = res.list || [], box = gel('qpListBox');
      gel('qpCnt').textContent = list.length ? ('· ' + list.length + '건') : '';
      if (!list.length) { box.innerHTML = '<div class="qi-empty">계획서가 없습니다.<br>[＋ 새 계획서]로 만드세요.</div>'; return; }
      box.innerHTML = list.map(function(r){
        return '<div class="qi-item' + (Number(r.qipseq) === curSeq ? ' on' : '') + '" onclick="qpOpen(' + r.qipseq + ');">' +
               '<div class="t">' + esc(r.topicnm || '(주제 없음)') + '</div>' +
               '<div class="d">' + esc(r.deptnm || '') + (r.submitdt ? ' · ' + esc(r.submitdt) : '') + '</div></div>';
      }).join('');
    }).catch(err);
  };

  window.qpOpen = function(seq){
    post('<c:url value="/qps/qiPlanGet.do"/>', { qipSeq: seq }).then(function(res){
      var d = res.doc || {};
      curSeq = Number(d.qipseq || 0);
      set('f_qipSeq', d.qipseq); set('f_indiCd', d.indicd || ''); set('f_topicNm', d.topicnm);
      set('f_deptNm', d.deptnm); set('f_submitDt', d.submitdt); set('f_background', d.background);
      set('f_indiNm', d.indinm); set('f_numerDesc', d.numerdesc); set('f_denomDesc', d.denomdesc);
      set('f_includeTxt', d.includetxt); set('f_excludeTxt', d.excludetxt);
      set('f_targetVal', d.targetval); set('f_multiplier', d.multiplier); set('f_unit', d.unit);
      set('f_srcTxt', d.srctxt); set('f_strategyTxt', d.strategytxt); set('f_expectTxt', d.expecttxt);
      gel('tbTEAM').innerHTML = ''; gel('tbSCHED').innerHTML = '';
      var items = res.items || [];
      var team = items.filter(function(r){ return r.sect === 'TEAM'; });
      var sched = items.filter(function(r){ return r.sect === 'SCHED'; });
      (team.length ? team : DEF_TEAM).forEach(teamRow);
      (sched.length ? sched : DEF_SCHED).forEach(schedRow);
      gel('qpAutoMsg').style.display = 'none';
      gel('qpStat').textContent = '— 저장된 계획서 #' + d.qipseq;
      gel('qpDelBtn').style.display = '';
      qpList();
    }).catch(err);
  };

  window.qpNew = function(){
    curSeq = 0;
    ['f_qipSeq','f_indiCd','f_topicNm','f_deptNm','f_submitDt','f_background','f_indiNm',
     'f_numerDesc','f_denomDesc','f_includeTxt','f_excludeTxt','f_targetVal','f_multiplier',
     'f_unit','f_srcTxt','f_strategyTxt','f_expectTxt'].forEach(function(id){ set(id, ''); });
    gel('tbTEAM').innerHTML = ''; gel('tbSCHED').innerHTML = '';
    DEF_TEAM.forEach(teamRow);
    DEF_SCHED.forEach(schedRow);
    gel('qpAutoMsg').style.display = 'none';
    gel('qpStat').textContent = '— 새 계획서';
    gel('qpDelBtn').style.display = 'none';
    qpList();
  };

  window.qpSave = function(){
    if (!val('f_topicNm')) { _alertBox('주제명을 입력해 주세요.', {icon:'⚠️'}); return; }
    post('<c:url value="/qps/qiPlanSave.do"/>', {
      qipSeq: val('f_qipSeq'), inYear: gel('qpYear').value,
      indiCd: val('f_indiCd'), topicNm: val('f_topicNm'), deptNm: val('f_deptNm'),
      submitDt: val('f_submitDt'), background: val('f_background'),
      indiNm: val('f_indiNm'), numerDesc: val('f_numerDesc'), denomDesc: val('f_denomDesc'),
      includeTxt: val('f_includeTxt'), excludeTxt: val('f_excludeTxt'), targetVal: val('f_targetVal'),
      multiplier: val('f_multiplier'), unit: val('f_unit'),
      srcTxt: val('f_srcTxt'), strategyTxt: val('f_strategyTxt'), expectTxt: val('f_expectTxt'),
      items: JSON.stringify(collect())
    }).then(function(res){
      _toast('저장되었습니다.', 'ok');
      qpOpen(res.qipSeq);
    }).catch(err);
  };

  window.qpDel = function(){
    if (!curSeq) return;
    _confirmBox({ msg:'이 계획서를 삭제할까요?', icon:'⚠️', okText:'삭제', okColor:'#b23b3b',
      onOk: function(){
        post('<c:url value="/qps/qiPlanDelete.do"/>', { qipSeq: curSeq }).then(function(){
          _toast('삭제되었습니다.', 'ok'); qpNew();
        }).catch(err);
      } });
  };

  // ---------- 인쇄(A4 1장) — 원본 배치 ----------
  var PRINT_CSS =
    '@page{ size:A4 portrait; margin:11mm; }' +
    'body{ margin:0; font-family:"맑은 고딕",Malgun Gothic,sans-serif; color:#000; }' +
    '.h1{ font-size:17px; font-weight:800; text-align:center; margin:0 0 8px; letter-spacing:1px; }' +
    'table{ width:100%; border-collapse:collapse; font-size:10px; margin-bottom:5px; }' +
    'th,td{ border:1px solid #666; padding:3px 4px; text-align:center; vertical-align:middle; line-height:1.5; }' +
    'th{ background:#efefef; font-weight:700; }' +
    'td.l{ text-align:left; } td.pre{ text-align:left; white-space:pre-wrap; }' +
    '.appr{ float:right; width:auto; margin:0 0 4px 8px; font-size:9.5px; }' +
    '.appr th{ padding:2px 6px; } .appr td{ height:40px; width:56px; }' +
    'tr{ page-break-inside:avoid; }';

  function apprHtml(){
    if (!APPR_LINE.length) return '';
    var h = '<table class="appr"><thead><tr>';
    APPR_LINE.forEach(function(r){ h += '<th>' + esc(r.stepnm) + '</th>'; });
    h += '</tr></thead><tbody><tr>';
    APPR_LINE.forEach(function(){ h += '<td></td>'; });
    return h + '</tr></tbody></table>';
  }

  window.qpPrint = function(){
    var yy = gel('qpYear').value, items = collect();
    var team = items.filter(function(r){ return r.sect === 'TEAM'; });
    var sched = items.filter(function(r){ return r.sect === 'SCHED'; });

    // 팀구성 — 원본처럼 가로 4벌(구분|성명 × 4)
    var trs = '';
    for (var i = 0; i < team.length; i += 4) {
      var tds = '';
      for (var k = 0; k < 4; k++) {
        var m = team[i + k];
        tds += '<th style="width:7%;">' + (m ? esc(m.grp) : '') + '</th>' +
               '<td style="width:18%;">' + (m ? esc(m.c1) : '') + '</td>';
      }
      trs += '<tr>' + tds + '</tr>';
    }

    var mth = '';
    for (var j = 1; j <= 12; j++) mth += '<th style="width:20px;">' + j + '월</th>';
    var schedRows = sched.map(function(r){
      var m = '';
      for (var k = 1; k <= 12; k++){ var f = 'm' + (k < 10 ? '0' + k : k); m += '<td>' + (r[f] === 'Y' ? '●' : '') + '</td>'; }
      return '<tr><th style="width:22px;">' + esc(r.grp) + '</th><td class="l">' + esc(r.c1) + '</td>' + m + '</tr>';
    }).join('');

    var mult = val('f_multiplier') ? ('X ' + esc(val('f_multiplier'))) : '';
    var body = apprHtml() +
      '<div class="h1">' + esc(yy) + ' &nbsp; QI 활동 계획서</div><div style="clear:both;"></div>' +
      '<table><tbody>' +
        '<tr><th style="width:90px;">제출부서</th><td class="l">' + esc(val('f_deptNm')) + '</td>' +
            '<th style="width:60px;">제출일</th><td style="width:110px;">' + esc(val('f_submitDt')) + '</td></tr>' +
        '<tr><th>주제명</th><td class="l" colspan="3">' + esc(val('f_topicNm')) + '</td></tr>' +
      '</tbody></table>' +
      (trs ? '<table><tbody><tr><th rowspan="' + (team.length ? Math.ceil(team.length / 4) : 1) +
             '" style="width:60px;">팀구성</th></tr>' + trs + '</tbody></table>'
           : '') +
      '<table><tbody><tr><th style="width:90px;">주제선정 배경</th>' +
        '<td class="pre" style="height:60px;">' + esc(val('f_background')) + '</td></tr></tbody></table>' +
      '<table><tbody>' +
        '<tr><th style="width:90px;" rowspan="6">핵심지표</th><th style="width:80px;">지표명</th>' +
            '<td class="l" colspan="2">' + esc(val('f_indiNm')) + '</td></tr>' +
        '<tr><th rowspan="5">지표정의</th><td class="l">분 자 : ' + esc(val('f_numerDesc')) + '</td>' +
            '<td rowspan="2" style="width:80px;">' + mult + '</td></tr>' +
        '<tr><td class="l">분 모 : ' + esc(val('f_denomDesc')) + '</td></tr>' +
        '<tr><td class="l" colspan="2">포함기준 : ' + esc(val('f_includeTxt')) + '</td></tr>' +
        '<tr><td class="l" colspan="2">제외기준 : ' + esc(val('f_excludeTxt')) + '</td></tr>' +
        '<tr><td class="l" colspan="2">목 표 값 : ' + esc(val('f_targetVal')) + ' ' + esc(val('f_unit')) + '</td></tr>' +
      '</tbody></table>' +
      '<table><tbody>' +
        '<tr><th style="width:90px;">자료수집</th><td class="pre" style="height:48px;">' + esc(val('f_srcTxt')) + '</td></tr>' +
        '<tr><th>개선전략<br>개선활동평가관리</th><td class="pre" style="height:48px;">' + esc(val('f_strategyTxt')) + '</td></tr>' +
      '</tbody></table>' +
      '<table><thead><tr><th style="width:90px;" rowspan="2">활동일정</th><th colspan="2"></th>' + mth + '</tr>' +
        '<tr style="display:none;"><th></th><th></th></tr></thead>' +
        '<tbody>' + schedRows + '</tbody></table>' +
      '<table><tbody><tr><th style="width:90px;">기대효과 및 기타</th>' +
        '<td class="pre" style="height:56px;">' + esc(val('f_expectTxt')) + '</td></tr></tbody></table>';

    var title = ('QI활동계획서_' + yy + '_' + val('f_topicNm') + '_' + HOSP_NM).replace(/[\\\/:*?"<>|]/g, '-');
    var w = window.open('', '_blank', 'width=900,height=1000');
    if (!w) { _alertBox('팝업이 차단되어 인쇄창을 열지 못했습니다.<br>주소창 오른쪽의 팝업 차단을 허용해 주세요.', {icon:'⚠️'}); return; }
    w.document.open();
    w.document.write('<!doctype html><html lang="ko"><head><meta charset="utf-8"><title>' + esc(title) +
      '</title><style>' + PRINT_CSS + '</style></head><body>' + body + '</body></html>');
    w.document.close();
    w.focus();
    setTimeout(function(){ try { w.print(); } catch (e) { } }, 300);
  };

  $(function(){ qpNew(); });
})();

  /* ═══ 탭 · 글자 크기 (2026-08-15 · 사용자 요청) ═══════════════════════════
     ★***고정으로 달지 않는다*** — 전부 펼친 높이를 재서 **한 화면을 넘칠 때만** 탭을 낸다.
       창 크기·글자 크기가 바뀌면 다시 잰다.
     ★탭이 **잘게 나뉘지 않게** 이웃 카드를 묶어 최대 4개. 이름은 첫 카드 제목(+「외」).
     ★「전체 보기」는 탭이 아니라 **보기 방식**이라 오른쪽 끝에 따로 둔다.
     ⚠인쇄는 별도 창이라 탭과 무관하다(숨긴 항목도 종이에는 다 나온다). */
  (function(){
    var KEY = 'qpsTab_qpsQiPlan', ZKEY = 'qpsZoom_qpsQiPlan', cur = 0;
    function cards(){ return [].slice.call(document.querySelectorAll('#qpsQiPlan .qi-card')); }
    function nm(c, i){
      var h = c.querySelector('h4');
      if (!h) return '항목 ' + (i + 1);
      var t = h.cloneNode(true), hint = t.querySelector('.hint');
      if (hint) hint.remove();
      return (t.textContent || '').trim().slice(0, 20) || ('항목 ' + (i + 1));
    }
    function fits(cs){
      if (cs.length < 2) return true;
      var prev = cs.map(function(c){ return c.style.display; });
      cs.forEach(function(c){ c.style.display = ''; });
      var h = 0;
      cs.forEach(function(c){ h += c.offsetHeight + 12; });
      cs.forEach(function(c, i){ c.style.display = prev[i]; });
      return h <= (window.innerHeight - 170);
    }
    function sync(){
      var cs = cards(), box = document.getElementById('zzTabs');
      if (!box || !cs.length) return;
      if (fits(cs)) {                       // 한 화면에 들어간다 — 탭이 필요 없다
        box.style.display = 'none';
        cs.forEach(function(c){ c.style.display = ''; });
        return;
      }
      box.style.display = '';
      var MAX = 4, per = Math.ceil(cs.length / MAX), groups = [];
      for (var s0 = 0; s0 < cs.length; s0 += per) groups.push(cs.slice(s0, s0 + per));
      if (cur >= groups.length) cur = 0;
      var all = (cur === -1);
      box.innerHTML = groups.map(function(g, i){
        return '<button type="button" class="zz-tab' + (!all && cur === i ? ' on' : '') +
               (all ? ' dim' : '') + '" onclick="zzTab(' + i + ');">' +
               nm(g[0], 0) + (g.length > 1 ? ' 외' : '') + '</button>';
      }).join('') +
        '<button type="button" class="zz-mode' + (all ? ' on' : '') + '" onclick="zzTab(' +
        (all ? '0' : '-1') + ');">' + (all ? '▤ 나눠 보기' : '☰ 전체 보기') + '</button>';
      groups.forEach(function(g, i){
        g.forEach(function(c){ c.style.display = (all || cur === i) ? '' : 'none'; });
      });
    }
    window.zzTab = function(i){ cur = i; try { localStorage.setItem(KEY, String(i)); } catch (e) {} sync(); };
    function zoom(z){
      z = Math.min(1.6, Math.max(0.8, z));
      var w = document.getElementById('qpsQiPlan');
      if (w) w.style.zoom = z.toFixed(2);
      return z;
    }
    window.zzZoom = function(d){
      var w = document.getElementById('qpsQiPlan'), c0 = parseFloat(w && w.style.zoom) || 1;
      if (d === 0) { zoom(1); try { localStorage.removeItem(ZKEY); } catch (e) {} setTimeout(sync, 0); return; }
      var z = zoom(c0 + d * 0.1);
      try { localStorage.setItem(ZKEY, String(z)); } catch (e) {}
      setTimeout(sync, 0);
    };
    try {
      var t = parseInt(localStorage.getItem(KEY), 10); if (!isNaN(t)) cur = t;
      var z = parseFloat(localStorage.getItem(ZKEY)); if (z) zoom(z);
    } catch (e) {}
    function boot(){ setTimeout(sync, 0); }
    if (window.jQuery) jQuery(boot); else document.addEventListener('DOMContentLoaded', boot);
    /* ★내용이 **나중에** 채워지면 다시 잰다 (2026-08-15).
       카드 속은 AJAX 로 채우는데 높이는 부팅 직후에 쟀다 — 긴 문서인데도
       「한 화면에 들어간다」로 잘못 보고 탭이 안 나오던 구멍이다.
       ⚠**탭 띠 자신이 바뀐 것은 무시한다** — 안 그러면 재기→그리기→재기 로 서로 부른다. */
    if (window.MutationObserver) {
      var _mw = document.getElementById('qpsQiPlan'), _mt;
      if (_mw) new MutationObserver(function(ms){
        var box = document.getElementById('zzTabs');
        for (var i = 0; i < ms.length; i++) {
          if (!box || !box.contains(ms[i].target)) {
            clearTimeout(_mt); _mt = setTimeout(sync, 250); return;
          }
        }
      }).observe(_mw, { childList: true, subtree: true });
    }
    var _t; window.addEventListener('resize', function(){ clearTimeout(_t); _t = setTimeout(sync, 200); });
    window.zzResync = sync;
  })();
</script>
</div><%-- /#qpsQiPlan --%>
</div><%-- /.dashboard-wrapper --%>
