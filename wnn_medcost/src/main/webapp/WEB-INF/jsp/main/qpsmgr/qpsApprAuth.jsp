<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%-- qpsApprAuth.jsp — 결재 권한 (2026-09-08)

     왜 : 사용자 「결재는 **권한 관리**로 — 서식별 해당 권한 있는 내용 보여주고 결재하게」.
          점검표 결재란은 로그인만 하면 빈 단계 아무 데나 찍을 수 있었다. 종이 결재란은 그렇지 않다.

     ★★단위 = **부서**(사용자 확정). 서식이 300종이라 서식마다 4단계를 사람이 채울 수 없다 —
       「방사선 : 담당=김기사 · 팀장=박실장」 한 번이면 그 부서 서식 전부가 정해진다.
     ★서식별 예외도 같은 표로 푼다. ⚠**이김은 단계 단위다**(서버 apprAuthMap) —
       서식에 「팀장」만 적어 두면 팀장만 그 서식 지정을 쓰고, 나머지 단계는 **부서 기본을 그대로 따른다.**
     ★한 단계에 **여러 사람**을 넣을 수 있다(대리·교대).
     ⚠**지정이 하나도 없는 단계는 종전처럼 누구나** 찍는다 — 도입하는 날 결재가 멈추면 안 된다
       (qpsUserDept 에서 얻은 원칙 : 막는 장치가 아니라 좁혀 주는 장치).
     ⚠공통('*') 서식을 다루므로 **위너넷 전용** — 서버(QpsController.qpsApprAuth)가 병원 계정을 돌려보낸다.

     ── 2026-09-08 저녁 개편(사용자 「서식을 뿌리고 우측에 결재 단계를 횡으로 하면 어떨까요」
                              · 「지금 이것은 한 건 한 건이고 밑에 별도 보여줄 필요도 없는데」) ──
       옛 판은 **한 번에 한 건**(부서 하나 또는 서식 하나)만 다뤄, 서식마다 예외를 주려면
       「서식 고르기 → 담기 → 저장」을 되풀이해야 했고, 아래에 그 결과를 또 한 번 목록으로 보여 줬다.
       ⇒ **한 표**로 바꿨다 : 줄 = 서식(맨 위가 부서 기본) · 열 = 결재 단계 · 칸 = 그 자리의 결재자.
         바꾼 줄만 저장한다(단추에 줄 수). 아래 목록은 없앴다 — 표가 곧 현황이다.
     ★주의: 이 파일 안에서 Deferred EL 표기(샵+중괄호) 금지 --%>

<script src="/asset/js/ui-message.js"></script>

<div class="dashboard-wrapper">
<div id="qpsApprAuth">
<style>
  #qpsApprAuth{ background:#f4f6f8; color:#1f2a30; min-height:100%; padding:14px 16px 60px; max-width:100%; overflow-x:hidden; }
  #qpsApprAuth *{ box-sizing:border-box; }
  #qpsApprAuth .aa-head{ display:flex; align-items:center; gap:10px; margin-bottom:10px; flex-wrap:wrap; }
  #qpsApprAuth .aa-title{ font-size:18px; font-weight:800; color:#20303a; display:flex; align-items:center; gap:8px; }
  #qpsApprAuth .aa-dot{ width:10px; height:10px; border-radius:50%; background:linear-gradient(135deg,#1f5a4b,#2a7665); }
  #qpsApprAuth .aa-sub{ font-size:12px; color:#6b7c86; }
  #qpsApprAuth .aa-spacer{ flex:1; }
  #qpsApprAuth select, #qpsApprAuth input[type=text]{
      border:1px solid #cfd8e0; border-radius:5px; padding:4px 6px; font-family:inherit; font-size:12.5px; background:#fff; }
  #qpsApprAuth .aa-btn{ border:1px solid #1f5a4b; background:#1f5a4b; color:#fff; border-radius:6px;
      padding:6px 14px; font-size:13px; font-weight:600; cursor:pointer; white-space:nowrap; }
  #qpsApprAuth .aa-btn.mini{ padding:3px 10px; font-size:12px; border-color:#cfd8e0; color:#556570; background:#fff; font-weight:500; }
  #qpsApprAuth .aa-note{ background:#f0f7f4; border:1px solid #cfe3da; border-radius:8px; padding:8px 12px;
      font-size:12.5px; color:#1f5a4b; line-height:1.6; margin-bottom:10px; }
  #qpsApprAuth .aa-bar{ background:#eef4fb; border:1px solid #b9cfe6; border-left:4px solid #2f6fb0;
      border-radius:8px; padding:10px 14px; margin-bottom:10px; display:flex; gap:8px; align-items:center; flex-wrap:wrap; font-size:13px; }
  #qpsApprAuth .aa-bar b{ color:#2f6fb0; }
  <%-- ★표가 서식 수만큼 길다(부서에 따라 80줄) — **카드 안에서만 스크롤**한다(2026-09-08 사용자 「스크롤로 보이게」).
       높이는 JS 가 실측해 맞춘다(aaFit) — 고정 calc 은 배율·줌마다 어긋난다(이 저장소가 겪은 함정). --%>
  <%-- ★★CSS 로 **먼저** 막는다 — JS 실측(aaFit)이 늦거나 어긋나도 표는 반드시 카드 안에서 스크롤된다.
       (실측만 믿었더니 화면이 다 그려지기 전에 재어 카드가 뷰포트보다 커졌다 — 2026-09-08 사용자 캡처) --%>
  #qpsApprAuth .aa-card{ background:#fff; border:1px solid #e3e9ed; border-radius:10px; padding:0 12px 8px;
      overflow:auto; -webkit-overflow-scrolling:touch; max-height:calc(100vh - 300px); min-height:260px; }
  #qpsApprAuth table{ border-collapse:separate; border-spacing:0; width:100%; min-width:820px; }
  #qpsApprAuth th, #qpsApprAuth td{ border-bottom:1px solid #eef2f5; padding:6px 8px; font-size:12.5px; text-align:left; vertical-align:top; background:#fff; }
  #qpsApprAuth thead th{ background:#f7fafb; color:#43555f; font-weight:700; white-space:nowrap;
      border-bottom:1px solid #e3e9ed; position:sticky; top:0; z-index:3; }
  <%-- 번호·서식 이름 두 열은 왼쪽에 붙여 둔다 — 가로로 밀어도 「몇 번째 · 어느 서식인지」가 사라지면 안 된다 --%>
  #qpsApprAuth th:first-child, #qpsApprAuth td:first-child{ position:sticky; left:0; z-index:2;
      width:46px; min-width:46px; text-align:right; color:#8a99a3; font-size:11.5px; padding-right:6px; }
  #qpsApprAuth th:nth-child(2), #qpsApprAuth td:nth-child(2){ position:sticky; left:46px; z-index:2; box-shadow:1px 0 0 #eef2f5; }
  #qpsApprAuth thead th:first-child, #qpsApprAuth thead th:nth-child(2){ z-index:4; }
  #qpsApprAuth tr.base td:first-child, #qpsApprAuth tr.base td:nth-child(2){ z-index:3; }
  #qpsApprAuth tr.base td:first-child{ background:#f2f9f6; }
  <%-- ★부서 기본 줄은 **스크롤해도 붙어 있는다**(2026-09-08 사용자 「부서기본 스크롤 안되게」) —
       서식 줄의 「부서 기본 : 누구」가 무엇을 가리키는지 늘 위에 보여야 한다.
       top 값(머리줄 높이)은 JS(aaFit)가 실측해 넣는다 — 머리줄 높이가 글꼴·줌에 따라 다르다. --%>
  #qpsApprAuth tr.base td{ background:#f2f9f6; border-bottom:2px solid #cfe3da; position:sticky; z-index:2; }
  #qpsApprAuth tr.base td:first-child{ z-index:3; }
  #qpsApprAuth tr.own td:first-child{ box-shadow:inset 3px 0 0 #2f6fb0; }
  #qpsApprAuth .aa-fnm{ font-weight:600; color:#20303a; }
  #qpsApprAuth .aa-fid{ font-size:11px; color:#8a99a3; margin-left:4px; }
  #qpsApprAuth .aa-users{ display:flex; gap:5px; flex-wrap:wrap; align-items:center; }
  #qpsApprAuth .aa-chip{ border:1px solid #cfe3da; background:#f2f9f6; border-radius:14px; padding:2px 7px 2px 9px;
      font-size:12px; color:#1f5a4b; display:inline-flex; align-items:center; gap:5px; white-space:nowrap; }
  #qpsApprAuth .aa-chip button{ border:0; background:transparent; color:#8a99a3; cursor:pointer; font-size:12px; line-height:1; padding:0; }
  #qpsApprAuth .aa-add{ border:1px dashed #b9cfe6; background:#fff; color:#2f6fb0; border-radius:12px;
      padding:2px 8px; font-size:12px; cursor:pointer; }
  #qpsApprAuth .aa-empty{ color:#8a99a3; font-size:12px; }
  #qpsApprAuth .aa-inh{ color:#8a99a3; font-size:12px; font-style:italic; }
  #qpsApprAuth .aa-warn{ color:#b5443c; }
  #qpsApprAuth .aa-dirty{ color:#c05621; font-weight:700; }
</style>

<div class="aa-head">
  <div class="aa-title"><span class="aa-dot"></span>결재 권한
    <span class="aa-sub">부서마다 <b>단계별로 누가 결재할지</b> 정합니다 — 서식은 한 줄씩 예외를 줍니다</span></div>
  <div class="aa-spacer"></div>
</div>

<div class="aa-note">
  · 맨 윗줄 <b>「이 부서 기본」</b>이 그 부서 서식 전부에 적용되고, 서식 줄에 넣은 칸만 기본을 이깁니다(칸마다 여러 사람 가능).<br>
  · 지정이 없는 칸은 종전처럼 <b>누구나</b> 결재할 수 있습니다.
</div>

<div class="aa-bar">
  <b>부서</b>
  <select id="aaDept" onchange="aaLoad();" style="min-width:150px;"></select>
  <b>서식 찾기</b>
  <input type="text" id="aaFind" style="width:170px;" placeholder="이름·코드" oninput="aaPaint();">
  <label class="aa-sub" style="display:flex; align-items:center; gap:4px;">
    <input type="checkbox" id="aaOnlyOwn" onchange="aaPaint();"> 지정한 서식만
  </label>
  <span class="aa-sub" id="aaScope"></span>
  <div class="aa-spacer"></div>
  <%-- ★결재선(열 이름)을 여기서 고친다(2026-09-08 사용자 「결재선 설정」) — 그동안 이 단추는
       지표분석(낙상) 화면 안에만 있어 찾기 어려웠다. 이 표의 **열이 곧 그 결재선**이라 여기가 제자리다. --%>
  <button type="button" class="aa-btn mini" onclick="aaLineToggle();">결재 단계 설정</button>
  <%-- ⚠저장은 **띠 안**에 둔다(2026-09-08 사용자 「저장이 안 보임」) — 화면 오른쪽 위는
       고정 요소(자주 쓰는 메뉴 · 문의 단추)가 덮어 단추가 가려진다. --%>
  <button type="button" class="aa-btn" id="aaSaveBtn" onclick="aaSave();">저장</button>
</div>

<div id="aaLineBox" class="aa-bar" style="display:none; background:#fdf7ec; border-color:#e6d6b4; border-left-color:#c99a3a;">
  <b style="color:#8a6d2f;">결재 단계</b>
  <input type="text" id="aaLineTxt" style="width:330px;" placeholder="담당, 팀장, 부서장, 이사장">
  <span class="aa-sub">쉼표로 순서대로 · 최대 10단계 · 줄이려면 뒤 단계를 빼면 됩니다</span>
  <div class="aa-spacer"></div>
  <button type="button" class="aa-btn" onclick="aaLineSave();">단계 저장</button>
  <button type="button" class="aa-btn mini" onclick="aaLineToggle();">닫기</button>
</div>

<div class="aa-card">
  <table>
    <thead id="aaHead"></thead>
    <tbody id="aaBody"><tr><td class="aa-empty">부서를 고르세요.</td></tr></tbody>
  </table>
</div>

</div>
</div>

<script>
(function(){
  /* SEL : 서식키('*' = 부서 기본) → 단계번호 → [{userId,userNm}]   ·   DIRTY : 바뀐 서식키 */
  var DEPTS = [], FORMS = [], USERS = [], LINE = [], SEL = {}, DIRTY = {}, LOAD_REQ = 0;

  function gel(id){ return document.getElementById(id); }
  function val(id){ var e = gel(id); return e ? e.value : ''; }
  function esc(s){ return String(s == null ? '' : s).replace(/[&<>"']/g, function(c){
    return ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'})[c]; }); }
  function err(e){ _alertBox((e && e.message) ? e.message : '처리 중 오류가 발생했습니다.', {icon:'❌'}); }
  function toast(t, k){ if (window._toast) { _toast(t, k || 'ok'); return; } _alertBox(t, {icon:'✅'}); }
  function post(url, data){
    return new Promise(function(res, rej){
      $.post(url, data, function(r){ if (r && r.result === 'OK') res(r); else rej(new Error((r && r.message) || '실패')); }, 'json')
       .fail(function(){ rej(new Error('서버에 연결하지 못했습니다.')); });
    });
  }
  function nmOf(list, cd, k1, k2){
    for (var i = 0; i < list.length; i++) if (list[i][k1] === cd) return list[i][k2] || cd;
    return cd || '';
  }
  function stepList(){ return LINE.length ? LINE : []; }
  function cell(key, step){ return ((SEL[key] || {})[String(step)] || []); }

  /* 기준자료 — 부서·서식·사용자·결재선 */
  function aaBase(){
    /* ★chkBase 는 연도를 요구한다(없으면 FAIL) · 부서 키는 **dept**(depts 아님) — 실측으로 맞췄다 */
    return post('<c:url value="/qps/chkBase.do"/>', { inYear: String(new Date().getFullYear()) })
      .then(function(res){
        DEPTS = (res.dept || []).filter(function(d){ return d.subcode; });
        FORMS = res.forms || [];
        var s = gel('aaDept');
        s.innerHTML = DEPTS.map(function(d){ return '<option value="' + esc(d.subcode) + '">' + esc(d.subcodenm) + '</option>'; }).join('');
        return aaLoad();
      }).catch(err);
  }

  /** 그 부서의 지정을 통째로 읽어 표를 그린다. ★순번 가드 — 늦게 온 옛 부서 응답이 새 부서를 덮지 않게. */
  window.aaLoad = function(){
    var my = ++LOAD_REQ, d = val('aaDept');
    return post('<c:url value="/qps/apprAuthList.do"/>', { deptCd: d }).then(function(res){
      if (my !== LOAD_REQ) return;
      LINE = res.line || []; USERS = res.users || [];
      SEL = {}; DIRTY = {};
      (res.list || []).forEach(function(r){
        var key = String(r.formid || '*');
        if (!SEL[key]) SEL[key] = {};
        var k = String(r.stepno);
        if (!SEL[key][k]) SEL[key][k] = [];
        SEL[key][k].push({ userId: r.userid, userNm: r.usernm });
      });
      aaHeadPaint();
      aaPaint();
    }).catch(function(e){ if (my === LOAD_REQ) err(e); });
  };

  function aaHeadPaint(){
    var st = stepList();
    gel('aaHead').innerHTML = '<tr><th>#</th><th style="width:270px;">서식</th>' +
      (st.length
        ? st.map(function(s){ return '<th>' + esc(s.stepno) + '. ' + esc(s.stepnm) + '</th>'; }).join('')
        : '<th class="aa-warn">결재선이 없습니다</th>') +
      '<th style="width:64px;"></th></tr>';
  }

  /** 그 부서의 서식 — 공통(COMMON)은 어느 부서에서나 쓰므로 함께 둔다(옛 판과 같은 규칙) */
  function deptForms(){
    var d = val('aaDept');
    return FORMS.filter(function(f){ return !d || f.deptcd === d; });
  }

  function chipsHtml(key, step){
    var rows = cell(key, step);
    return rows.map(function(u){
      return '<span class="aa-chip">' + esc(u.userNm || u.userId) +
             '<button type="button" title="빼기" data-del="' + esc(key) + '|' + esc(step) + '|' + esc(u.userId) + '">✕</button></span>';
    }).join('');
  }
  function cellHtml(key, step){
    var mine = cell(key, step), h = chipsHtml(key, step);
    if (!mine.length) {
      if (key === '*') h = '<span class="aa-empty">누구나</span>';
      else {
        var base = cell('*', step);
        h = '<span class="aa-inh">' + (base.length
              ? ('부서 기본 : ' + esc(base.map(function(u){ return u.userNm || u.userId; }).join(', ')))
              : '부서 기본 (누구나)') + '</span>';
      }
    }
    return '<div class="aa-users">' + h +
           '<button type="button" class="aa-add" data-add="' + esc(key) + '|' + esc(step) + '" title="결재자 더하기">＋</button></div>';
  }

  window.aaPaint = function(){
    var st = stepList();
    if (!st.length) { gel('aaBody').innerHTML = '<tr><td class="aa-warn">결재선이 없습니다 — 먼저 결재선을 정하세요.</td></tr>'; return; }
    var q = String(val('aaFind') || '').trim().toLowerCase();
    var onlyOwn = gel('aaOnlyOwn').checked;
    var rows = [];

    /* ① 맨 윗줄 = 이 부서 기본 — 늘 보인다(찾기·거르기와 무관하게 기준이 되는 줄이다) */
    rows.push('<tr class="base"><td>■</td><td><span class="aa-fnm">이 부서 기본</span>' +
              '<div class="aa-sub">지정 없는 서식은 이 줄을 따릅니다</div></td>' +
              st.map(function(s){ return '<td>' + cellHtml('*', s.stepno) + '</td>'; }).join('') +
              '<td>' + rowBtns('*') + '</td></tr>');

    /* ② 서식 줄 */
    var fs = deptForms().filter(function(f){
      if (onlyOwn && !SEL[f.formid]) return false;
      if (!q) return true;
      return (String(f.formnm || '').toLowerCase().indexOf(q) >= 0 || String(f.formid || '').toLowerCase().indexOf(q) >= 0);
    });
    if (!fs.length) {
      rows.push('<tr><td colspan="' + (st.length + 3) + '" class="aa-empty">' +
                (onlyOwn ? '이 부서에는 서식별 예외가 없습니다 — 위 기본 줄만 씁니다.' : '찾는 서식이 없습니다.') + '</td></tr>');
    } else {
      fs.forEach(function(f, i){
        var own = !!SEL[f.formid];
        rows.push('<tr' + (own ? ' class="own"' : '') + '><td>' + (i + 1) + '</td>' +
                  '<td><span class="aa-fnm">' + esc(f.formnm) + '</span>' +
                  '<span class="aa-fid">' + esc(f.formid) + '</span></td>' +
                  st.map(function(s){ return '<td>' + cellHtml(f.formid, s.stepno) + '</td>'; }).join('') +
                  '<td>' + rowBtns(f.formid) + '</td></tr>');
      });
    }
    gel('aaBody').innerHTML = rows.join('');
    gel('aaScope').textContent = '이 부서 서식 ' + deptForms().length + '종 · 예외 ' +
      Object.keys(SEL).filter(function(k){ return k !== '*'; }).length + '종';
    aaCntPaint();
    aaFit();                       // ★줄 수·줄 높이가 바뀌었으니 다시 잰다(찾기·거르기 뒤에도 15줄로)
  };

  function rowBtns(key){
    var dirty = DIRTY[key] ? '<span class="aa-dirty" title="아직 저장 전">●</span> ' : '';
    var has = !!SEL[key] && Object.keys(SEL[key]).some(function(k){ return (SEL[key][k] || []).length; });
    return dirty + (has ? '<button type="button" class="aa-btn mini" data-clr="' + esc(key) + '">비우기</button>' : '');
  }

  /** ★저장 단추에 **바뀐 줄 수**를 적는다 — 아무것도 안 바꾸고 저장하면 「안 됐다」로 읽힌다(2026-09-08). */
  function aaCntPaint(){
    var n = Object.keys(DIRTY).length;
    var b = gel('aaSaveBtn');
    if (b) b.textContent = n ? ('저장 (' + n + '줄)') : '저장 (바꾼 줄 없음)';
  }

  /* ── 칸 조작 : ＋ 로 고르기 · ✕ 로 빼기 · 줄 비우기 (표를 다시 그려도 살아남게 위임) ── */
  gel('aaBody').addEventListener('click', function(ev){
    var t = ev.target;

    var add = t.getAttribute && t.getAttribute('data-add');
    if (add) {                                   // ＋ → 그 칸에만 셀렉트를 낸다(칸마다 셀렉트를 미리 깔면 수백 개가 된다)
      var box = t.parentNode;
      if (box.querySelector('select')) return;
      var p = add.split('|');
      var sel = document.createElement('select');
      sel.setAttribute('data-pick', add);
      sel.style.width = '128px';
      sel.innerHTML = '<option value="">— 결재자 선택 —</option>' + USERS.map(function(u){
        return '<option value="' + esc(u.userid) + '">' + esc(u.usernm || u.userid) + '</option>'; }).join('');
      box.replaceChild(sel, t);
      sel.focus();
      return;
    }

    var del = t.getAttribute && t.getAttribute('data-del');
    if (del) {
      var d = del.split('|'), key = d[0], step = d[1], uid = d[2];
      SEL[key][step] = (SEL[key][step] || []).filter(function(u){ return u.userId !== uid; });
      if (!SEL[key][step].length) delete SEL[key][step];
      if (!Object.keys(SEL[key]).length) delete SEL[key];
      DIRTY[key] = 1;
      aaPaint();
      return;
    }

    var clr = t.getAttribute && t.getAttribute('data-clr');
    if (clr) {
      var nm = (clr === '*') ? '이 부서 기본' : nmOf(FORMS, clr, 'formid', 'formnm');
      _confirmBox({ msg: '<b>' + esc(nm) + '</b> 줄의 지정을 비웁니다.<br>' +
                         '<span style="font-size:12px;color:#8a99a3;">' +
                         (clr === '*' ? '비우면 이 부서 서식은 <b>누구나</b> 결재할 수 있게 됩니다(서식 예외는 그대로).'
                                      : '비우면 이 서식은 다시 <b>부서 기본</b>을 따릅니다.') + '</span>',
        icon:'⚠️', okText:'비우기', okColor:'#b23b3b',
        onOk: function(){ delete SEL[clr]; DIRTY[clr] = 1; aaPaint(); } });
      return;
    }
  });

  /** 고르면 **바로 담긴다** — [더하기]를 따로 누르게 두었더니 고르기만 하고 저장해 0건이 저장됐다(2026-09-08 실사고). */
  gel('aaBody').addEventListener('change', function(ev){
    var sel = ev.target, pick = sel.getAttribute && sel.getAttribute('data-pick');
    if (!pick) return;
    var uid = sel.value;
    if (!uid) { aaPaint(); return; }
    var p = pick.split('|'), key = p[0], step = p[1];
    if (!SEL[key]) SEL[key] = {};
    if (!SEL[key][step]) SEL[key][step] = [];
    if (SEL[key][step].some(function(u){ return u.userId === uid; })) { _alertBox('이미 들어 있습니다.', {icon:'ℹ️'}); aaPaint(); return; }
    SEL[key][step].push({ userId: uid, userNm: nmOf(USERS, uid, 'userid', 'usernm') });
    DIRTY[key] = 1;
    aaPaint();
  });

  /* ═══ 결재 단계(결재선) 설정 — TBL_QPS_APPR_LINE ═══
     ★이 표의 **열이 곧 결재선**이다. 병원 행이 없으면 공통('*') 단계를 쓰고, 여기서 저장하면 그 병원 것이 생긴다.
     ⚠**QPS 전체가 같은 결재선을 쓴다**(점검표 결재란 · 지표분석 결재) — 여기서 바꾸면 그쪽 표시도 함께 바뀐다.
     ⚠**줄이면 뒤 단계가 사라진다** — 그 단계에 이미 지정한 권한은 표에서 안 보이게 된다(자료는 남는다). */
  window.aaLineToggle = function(){
    var box = gel('aaLineBox');
    if (box.style.display !== 'none') { box.style.display = 'none'; aaFit(); return; }
    gel('aaLineTxt').value = stepList().map(function(s){ return s.stepnm; }).join(', ');
    box.style.display = '';
    gel('aaLineTxt').focus();
    aaFit();
  };
  window.aaLineSave = function(){
    var arr = String(val('aaLineTxt') || '').split(',').map(function(s){ return s.trim(); })
                .filter(function(s){ return s; });
    if (!arr.length) { _alertBox('단계를 1개 이상 적으세요.<br><span style="font-size:12px;color:#8a99a3;">예) 담당, 팀장, 부서장, 이사장</span>', {icon:'⚠️'}); return; }
    if (arr.length > 10) { _alertBox('단계는 최대 10개까지입니다.', {icon:'⚠️'}); return; }
    var now = stepList().length;
    _confirmBox({
      msg: '결재 단계를 <b>' + esc(arr.join(' → ')) + '</b> (' + arr.length + '단계) 로 저장합니다.<br><br>' +
           '<span style="font-size:12px;color:#8a99a3;">· <b>QPS 전체가 이 결재선을 씁니다</b> — 점검표 결재란과 지표분석 결재가 함께 바뀝니다.<br>' +
           (arr.length < now
             ? '· <span style="color:#b5443c;"><b>' + (now - arr.length) + '단계가 줄어듭니다</b> — 그 단계에 정해 둔 권한은 표에서 사라집니다.</span>'
             : '· 늘어난 단계는 <b>누구나</b>로 시작합니다 — 이 표에서 결재자를 정하세요.') + '</span>',
      icon:'🔧', okText:'단계 저장',
      onOk: function(){
        var p = {};
        arr.forEach(function(nm, i){ p['step' + (i + 1)] = nm; });
        post('<c:url value="/qps/apprLineSave.do"/>', p).then(function(){
          toast('결재 단계를 저장했습니다(' + arr.length + '단계).');
          gel('aaLineBox').style.display = 'none';
          return aaLoad();
        }).catch(err);
      } });
  };

  window.aaSave = function(){
    var d = val('aaDept');
    if (!d) { _alertBox('부서를 고르세요.', {icon:'⚠️'}); return; }
    var keys = Object.keys(DIRTY);
    if (!keys.length) {
      /* ★막지 않고 **왜 할 일이 없는지 말한다** — 막힌 단추는 「고장 난 단추」로 읽힌다(이 저장소가 두 번 겪은 교훈). */
      _alertBox('바꾼 줄이 없습니다.<br><span style="font-size:12px;color:#8a99a3;">표에서 <b>＋</b> 로 결재자를 넣거나 <b>✕</b> 로 빼면 그 줄에 ● 표시가 붙습니다.</span>', {icon:'ℹ️'});
      return;
    }
    var lines = keys.map(function(k){
      var nm = (k === '*') ? '이 부서 기본' : nmOf(FORMS, k, 'formid', 'formnm');
      var n = 0;
      Object.keys(SEL[k] || {}).forEach(function(s){ n += (SEL[k][s] || []).length; });
      return '· ' + esc(nm) + ' — ' + (n ? (n + '명') : '<span style="color:#b5443c;">지정 없음(누구나)</span>');
    }).join('<br>');

    _confirmBox({
      msg: '<b>' + esc(nmOf(DEPTS, d, 'subcode', 'subcodenm')) + '</b> 의 결재 권한 <b>' + keys.length + '줄</b>을 저장합니다.<br><br>' +
           '<span style="font-size:12px;color:#43555f;">' + lines + '</span>',
      icon:'🔒', okText:'저장',
      onOk: function(){
        /* ★한 줄씩 차례로 — 서버는 「부서(또는 서식) 하나를 통째로 교체」다.
           한 줄이 실패하면 거기서 멈추고 다시 읽는다(어디까지 갔는지 표로 보인다). */
        var i = 0, done = 0;
        var next = function(){
          if (i >= keys.length) {
            toast(done + '줄을 저장했습니다.');
            aaLoad();
            return;
          }
          var k = keys[i++], rows = [];
          Object.keys(SEL[k] || {}).forEach(function(s){
            (SEL[k][s] || []).forEach(function(u){ rows.push({ stepNo: Number(s), userId: u.userId, userNm: u.userNm || '' }); });
          });
          post('<c:url value="/qps/apprAuthSave.do"/>',
               { deptCd: d, formId: (k === '*') ? '' : k, rows: JSON.stringify(rows) })
            .then(function(){ done++; next(); })
            .catch(function(e){ err(e); aaLoad(); });
        };
        next();
      } });
  };

  /**
   * 표 높이 맞추기 — 카드 안에서만 스크롤되게 한다(2026-09-08 사용자 「스크롤로 보이게」).
   * ★고정 calc() 을 쓰지 않는다 — 윈도우 배율·브라우저 줌마다 어긋난다(마감업로드 그리드에서 겪은 함정).
   * ★자리는 **문서 기준**(rect.top + scrollY)으로 잰다 — 화면 기준으로 재면 스크롤할 때마다 표가 자란다.
   */
  /**
   * 표 높이 — ★**15줄까지만 보여 주고** 나머지는 표 안에서 스크롤한다(2026-09-08 사용자 「15개까지 보여주고」).
   * 줄 높이가 저마다 다르므로(기본 줄·이름이 두 줄인 서식) **앞 15줄을 실제로 재서** 더한다.
   * ★화면보다 커지지 않게 한 번 더 자른다 — 작은 노트북에서 표가 화면 밖으로 나가면 안 된다.
   */
  var AA_ROWS = 16;                                               // 기본 줄 + 서식 15줄
  function aaFit(){
    var c = document.querySelector('#qpsApprAuth .aa-card');
    if (!c) return;
    var thead = c.querySelector('thead'), trs = c.querySelectorAll('tbody tr');
    /* ★부서 기본 줄을 머리줄 **바로 밑**에 붙여 둔다 — 머리줄 높이는 글꼴·줌마다 다르므로 실측해서 넣는다 */
    var hh = thead ? thead.offsetHeight : 34;
    var base = c.querySelector('tbody tr.base');
    if (base) [].forEach.call(base.children, function(td){ td.style.top = hh + 'px'; });
    var h = hh + 10;                                              // 머리줄 + 카드 아래 여백
    for (var i = 0; i < trs.length && i < AA_ROWS; i++) h += trs[i].offsetHeight;
    var top = c.getBoundingClientRect().top + (window.pageYOffset || 0);
    var room = window.innerHeight - top - 40;                     // 화면에 남은 자리(아래 여백 40)
    if (h > room) h = room;
    if (h < 260) h = 260;                                         // 너무 낮으면 표 구실을 못 한다
    c.style.maxHeight = h + 'px';
  }
  window.addEventListener('resize', aaFit);
  window.addEventListener('load', aaFit);     // 사이드바·머리띠가 자리를 잡은 뒤 한 번 더

  $(function(){
    aaBase().then(aaFit);
    /* ⚠한 번만 재면 늦다 — 타일 레이아웃이 뒤늦게 자리를 옮긴다(2026-09-08 사용자 캡처: 표가 화면 아래로 이어졌다) */
    setTimeout(aaFit, 400); setTimeout(aaFit, 1200);
  });
})();
</script>
