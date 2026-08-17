<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%--
  ═══ 사용자 ↔ 담당 부서 (2026-08-15 · 사용자 요청) ═══════════════════════════
  담당자가 **제 부서 점검표만** 보게 한다. 부서가 15개라 전부 보이면 제 것을 못 찾는다.

  ★★***등록이 없으면 「전 부서」다*** — 이 화면을 한 번도 안 써도 지금과 똑같이 돌아간다.
     막는 장치가 아니라 **좁혀 주는 장치**다(도입하는 날 업무가 멈추면 안 된다).
  ★★***계정 종류로 가르지 않는다***(사용자 지시 2026-08-15) — 관리자도 업무(부서)를 지정할 수 있고,
     지정하면 그대로 걸린다. 규칙이 하나여야 화면과 서버가 어긋나지 않는다.
  ★부서를 하나도 안 고르고 [적용]하면 그 사람은 **전 부서로 되돌아간다** — 해제 기능이 따로 없는 이유.
  ★★***화면 원칙(사용자 지적 2026-08-15)*** : ***자주 쓰는 것을 먼저, 편의 기능은 그 뒤에.***
     처음엔 복사·여러 명 일괄을 주 기능과 **같은 자리**에 두었더니
     「지금 누구에게 적용되는 건가」가 헷갈렸다 ⇒ 아래처럼 **갈랐다** :
      · **주 기능** — 왼쪽에서 **한 사람**을 누르면 그 사람 담당이 체크되어 나온다 → 고치고 [저장]
      · **편의 기능**(접어 둠) — **복사 하나뿐**. 보고 있는 사람의 담당을 받을 사람 한 명에게.
  ⚠「여러 사람 선택」은 만들었다가 **뺐다**(사용자 지적 : 의미 없음) — 고를 것이 하나여야 헷갈리지 않는다.
--%>
<div class="dashboard-wrapper">
<div id="qpsUserDept">
<style>
  #qpsUserDept{ padding:14px 16px 24px; font-size:13.5px; color:#2b3a42; }
  #qpsUserDept .ud-head{ display:flex; align-items:center; gap:10px; flex-wrap:wrap; margin-bottom:12px; }
  #qpsUserDept .ud-title{ font-size:19px; font-weight:800; color:#1f5a4b; display:flex; align-items:center; gap:8px; }
  #qpsUserDept .ud-dot{ width:9px; height:9px; border-radius:50%; background:#1f5a4b; display:inline-block; }
  #qpsUserDept .ud-sub{ font-size:12.5px; color:#6b7c86; }
  #qpsUserDept .ud-spacer{ flex:1; }
  #qpsUserDept .ud-btn{ border:1px solid #1f5a4b; background:#1f5a4b; color:#fff; border-radius:6px;
                        padding:6px 14px; font-size:13px; font-weight:700; cursor:pointer; }
  #qpsUserDept .ud-btn.ghost{ background:#fff; color:#1f5a4b; }
  #qpsUserDept .ud-btn:hover{ opacity:.9; }
  #qpsUserDept .ud-wrap{ display:flex; gap:14px; align-items:flex-start; }
  #qpsUserDept .ud-card{ background:#fff; border:1px solid #e3e9ed; border-radius:10px; padding:14px 16px; }
  #qpsUserDept .ud-left{ flex:0 0 420px; }
  #qpsUserDept .ud-right{ flex:1; min-width:0; }
  #qpsUserDept h4{ font-size:14px; font-weight:800; color:#1f5a4b; margin:0 0 8px; }
  #qpsUserDept h4 .hint{ font-weight:500; font-size:12px; color:#8a99a3; margin-left:6px; }
  #qpsUserDept table{ width:100%; border-collapse:collapse; }
  #qpsUserDept th, #qpsUserDept td{ border:1px solid #e3e9ed; padding:6px 8px; font-size:13px; }
  #qpsUserDept th{ background:#f4f7f9; color:#43555f; font-weight:700; }
  #qpsUserDept tbody tr:hover{ background:#f7fbfd; }
  #qpsUserDept tr.urow{ cursor:pointer; }
  /* 지금 고쳐 보고 있는 사람 — 오른쪽 칸이 누구 것인지 한눈에 */
  #qpsUserDept tr.urow.on{ background:#eaf4f0; box-shadow:inset 3px 0 0 #1f5a4b; }
  #qpsUserDept tr.urow.on td{ font-weight:700; }
  #qpsUserDept .u-dept{ color:#1f5a4b; font-weight:700; }
  #qpsUserDept .u-all{ color:#8a99a3; }
  #qpsUserDept .dept-grid{ display:grid; grid-template-columns:repeat(auto-fill, minmax(160px, 1fr)); gap:6px; }
  #qpsUserDept .dept-grid label{ display:flex; align-items:center; gap:6px; border:1px solid #e3e9ed;
                                 border-radius:6px; padding:7px 9px; cursor:pointer; }
  #qpsUserDept .dept-grid label:hover{ background:#f4f7f9; }
  #qpsUserDept .note{ background:#fffdf3; border:1px solid #f0e3b8; border-radius:8px; padding:9px 11px;
                      font-size:12.5px; color:#6b5b2a; margin-bottom:10px; }
  #qpsUserDept .stat{ font-size:12.5px; color:#1f5a4b; font-weight:700; margin-left:8px; }
  /* 복사 — ①에서 ②로 간다는 것이 눈에 보이게 */
  #qpsUserDept .ud-copy{ display:flex; gap:10px; align-items:flex-end; flex-wrap:wrap; }
  #qpsUserDept .ud-copy-box{ flex:0 1 250px; min-width:190px; }
  #qpsUserDept .ud-copy-lb{ font-size:12px; font-weight:700; color:#1f5a4b; margin-bottom:3px; }
  #qpsUserDept .ud-copy-lb span{ font-weight:400; color:#8a99a3; }
  #qpsUserDept .ud-copy-ar{ font-size:17px; color:#1f5a4b; padding-bottom:5px; }
  #qpsUserDept .ud-copy-src{ border:1px solid #cfd9e0; border-radius:6px; padding:8px 12px; background:#f7fbfd;
                             color:#1f5a4b; white-space:nowrap; }
  #qpsUserDept .ud-copy-src.none{ color:#8a99a3; background:#fafbfc; }
  #qpsUserDept .ud-copy-box{ flex:1 1 300px; }
  #qpsUserDept .ud-list{ border:1px solid #cfd9e0; border-radius:6px; background:#fff;
                         max-height:190px; overflow:auto; }
  #qpsUserDept .ud-list label{ display:flex; align-items:center; gap:7px; padding:6px 9px;
                               border-bottom:1px solid #f0f4f6; cursor:pointer; font-size:12.8px; }
  #qpsUserDept .ud-list label:last-child{ border-bottom:0; }
  #qpsUserDept .ud-list label:hover{ background:#f4f7f9; }
  #qpsUserDept .ud-list .d{ color:#8a99a3; font-size:11.5px; margin-left:auto; white-space:nowrap; }
  /* 고르는 칸이 눈에 띄어야 「목록에서 고르는 것」임을 안다 */
  #qpsUserDept .ud-list input{ width:15px; height:15px; flex:0 0 auto; }
  #qpsUserDept .ud-list label:has(input:checked){ background:#eaf4f0; font-weight:700; }
  /* -- 글자 크기 (2026-08-18 요청) : QI 계획서(qpsQiPlan)와 같은 모양.같은 조작 */
  #qpsUserDept .zz-zoom{ display:inline-flex; gap:4px; align-items:center; margin-left:2px; margin-right:14px; }
  #qpsUserDept .zz-zoom button{ border:1px solid #cfd9e0; background:#fff; color:#43555f; border-radius:6px;
                        padding:4px 9px; font-size:13px; font-weight:700; cursor:pointer; }
  #qpsUserDept .zz-zoom button:hover{ background:#eef3f6; }
</style>
<%-- ★확인창을 작게 (2026-08-15 사용자 지적) — 기본 Swal 은 아이콘·여백이 커서 부서 이름이 여러 줄로 접힌다.
     ⚠`#qpsUserDept` 안에 두면 안 먹는다 — Swal 창은 <body> 바로 밑에 붙어 이 영역 **밖**이다. --%>
<style>
  .ud-swal{ font-size:13.5px !important; border-radius:10px !important; }
  .ud-swal .swal2-title{ font-size:15px !important; padding:0 0 4px !important; }
  .ud-swal .swal2-icon{ width:2.4em !important; height:2.4em !important; margin:.4em auto .5em !important; }
  .ud-swal .swal2-icon .swal2-icon-content{ font-size:1.5em !important; }
  .ud-swal .swal2-html-container{ font-size:13.5px !important; line-height:1.65 !important; margin:.3em 0 0 !important; }
  .ud-swal .swal2-actions{ margin:.9em 0 .2em !important; gap:6px; }
  .ud-swal .swal2-styled{ font-size:13px !important; padding:.45em 1.3em !important; }
  .ud-swal-t{ font-size:14.5px !important; font-weight:700 !important; }
  .ud-swal-h b{ color:#1f5a4b; }
</style>

<div class="ud-head">
  <div class="ud-title"><span class="ud-dot"></span>사용자별 담당 부서
    <span class="ud-sub">— 담당자가 제 부서 점검표만 보게 합니다</span></div>
  <span class="ud-sub">🏥 <c:out value="${hospNm}" default="병원 미확인"/></span>
  <div class="ud-spacer"></div>
  <span class="stat" id="udStat"></span>
  <span style="flex:0 0 12px;"></span>
  <%-- 글자 크기 - 이 PC 이 브라우저에만 저장된다 --%>
  <span class="zz-zoom">
    <button type="button" onclick="zzZoom(-1);" title="글자 작게">가－</button>
    <button type="button" onclick="zzZoom(1);"  title="글자 크게">가＋</button>
    <button type="button" onclick="zzZoom(0);"  title="처음 크기로">↺</button>
  </span>
</div>

<%-- ★안내는 **모르면 틀리는 것**만 남긴다(사용자 지적 2026-08-15) —
     설명조 문장(「막는 장치가 아니라…」 따위)은 읽는 사람에게 할 일을 주지 않는다.
     남긴 두 줄은 각각 「등록 안 하면 어떻게 되나」·「해제는 어떻게 하나」로, 둘 다 화면에 안 드러난다. --%>
<div class="note">
  <b>등록하지 않은 사람은 전 부서</b>를 봅니다 · 부서를 <b>모두 해제하고 저장</b>하면 다시 전 부서가 됩니다.
</div>

<div class="ud-wrap">
  <div class="ud-left ud-card">
    <h4>사용자 <span class="hint">— 이름을 누르면 오른쪽에서 고칩니다</span></h4>
    <table>
      <thead><tr>
        <th style="width:110px;">이름</th><th style="width:100px;">ID</th><th>담당 부서</th>
      </tr></thead>
      <tbody id="udUserBody"><tr><td colspan="4" style="text-align:center; color:#8a99a3;">불러오는 중…</td></tr></tbody>
    </table>
  </div>

  <div class="ud-right">
    <%-- ═══ 주 기능 — 한 사람의 담당을 보고 고친다 (거의 언제나 이것만 쓴다) ═══ --%>
    <div class="ud-card">
      <h4 id="udWho">담당 부서 <span class="hint">— 왼쪽에서 사용자를 고르세요</span></h4>
      <div class="dept-grid" id="udDeptBox"></div>
      <%-- 고르는 단추(전부·해제)는 왼쪽, **저장은 오른쪽 끝** — 복사 줄과 같은 규칙 --%>
      <div style="margin-top:12px; display:flex; gap:8px; align-items:center;">
        <button type="button" class="ud-btn ghost" onclick="udPick(1);">전부</button>
        <button type="button" class="ud-btn ghost" onclick="udPick(0);">해제</button>
        <span class="ud-sub" id="udPickMsg" style="overflow:hidden; text-overflow:ellipsis; white-space:nowrap;"></span>
        <button type="button" class="ud-btn" id="udSaveBtn" onclick="udSave();" disabled
                style="margin-left:auto; flex:0 0 auto;">✔ 저장</button>
      </div>
    </div>

    <%-- ═══ 편의 기능 — 접어 둔다(가끔 쓴다) ═══
         ★★[2026-08-15 최종] ***간단하게.*** 사용자 지적을 그대로 반영했다 :
            · 「여러 사람 선택 기능은 의미 없음」 ⇒ **없앴다**(왼쪽 표의 체크칸도 함께 걷었다)
            · 「선택한 사람 → 우측에서 고른 사람으로 복사」 ⇒ 원본은 **지금 보고 있는 사람**,
              고를 것은 **받을 사람 하나**뿐이다. 헷갈릴 자리가 없다. --%>
    <div class="ud-card" style="margin-top:12px;">
      <h4 style="cursor:pointer; margin:0;" onclick="udMoreToggle();">
        <span id="udMoreArrow">▸</span> 편의 기능
        <span class="hint">— 새 직원에게 전임자 담당을 그대로 복사</span>
      </h4>
      <div id="udMoreBox" style="display:none; margin-top:10px;">
        <div class="ud-copy">
          <div class="ud-copy-box" style="flex:0 0 auto;">
            <div class="ud-copy-lb">복사할 내용 <span>(지금 보고 있는 사람)</span></div>
            <div class="ud-copy-src" id="udCopySrc">— 왼쪽에서 사용자를 고르세요 —</div>
          </div>
          <div class="ud-copy-ar">➜</div>
          <div class="ud-copy-box">
            <div class="ud-copy-lb">받을 사람 <span>— 한 명 고르세요</span></div>
            <div class="ud-list" id="udCopyToBox"></div>
          </div>
        </div>
        <%-- ★한 줄로 — 옵션·안내는 왼쪽, **실행 단추는 오른쪽 끝**(사용자 지적 2026-08-15).
             단추가 맨 앞에 있으면 「무엇을 정하기도 전에 누르는 자리」로 읽힌다. --%>
        <div style="margin-top:8px; display:flex; gap:10px; align-items:center;">
          <label style="display:flex; align-items:center; gap:5px; font-size:12.5px; color:#43555f; white-space:nowrap;">
            <input type="checkbox" id="udAddMode"> 기존 담당에 <b>더하기</b>
            <span class="ud-sub">(끄면 덮어씀)</span>
          </label>
          <span class="ud-sub" id="udCopyMsg" style="overflow:hidden; text-overflow:ellipsis; white-space:nowrap;"></span>
          <button type="button" class="ud-btn" id="udCopyBtn" onclick="udCopyApply();"
                  style="margin-left:auto; flex:0 0 auto;">↧ 복사</button>
        </div>
      </div>
    </div>
  </div>
</div>

<script>
(function(){
  var USERS = [], DEPTS = [];
  var CUR = '';        // 지금 보고 있는 사람(주 기능)
  function gel(id){ return document.getElementById(id); }
  function esc(s){ return (s==null?'':String(s)).replace(/[&<>"]/g, function(c){
    return { '&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;' }[c]; }); }
  function post(url, data){
    return new Promise(function(res, rej){
      $.ajax({ url:url, type:'POST', data:data, dataType:'json' }).then(res, function(x){ rej(x); });
    });
  }
  function nmOf(cd){
    for (var i = 0; i < DEPTS.length; i++) if (DEPTS[i].subcode === cd) return DEPTS[i].subcodenm || cd;
    return cd;
  }
  function chosenDepts(){
    return [].slice.call(document.querySelectorAll('#udDeptBox input:checked'))
             .map(function(b){ return b.value; });
  }

  function render(){
    // 부서 칸
    // ★부서 체크가 바뀌면 복사 안내도 같이 갱신된다(복사할 내용이 이 칸이므로)
    gel('udDeptBox').innerHTML = DEPTS.map(function(d){
      /* 「공통은 누구에게나 보인다」는 안내문에서 빼고 **그 칸 자체에** 적는다 —
         설명은 쓰이는 자리에 있어야 읽힌다. */
      var com = (d.subcode === 'COMMON');
      return '<label' + (com ? ' title="공통 서식(MSDS 등)은 체크와 무관하게 누구에게나 보입니다"' : '') + '>' +
             '<input type="checkbox" onchange="udCopyMsg();" value="' + esc(d.subcode) + '">' +
             esc(d.subcodenm || d.subcode) +
             (com ? '<span style="margin-left:auto; font-size:11px; color:#8a99a3;">모두 보임</span>' : '') +
             '</label>';
    }).join('');
    // 사용자 표
    gel('udUserBody').innerHTML = USERS.length ? USERS.map(function(u){
      var cds = (u.deptcds || '').split(',').filter(function(x){ return x; });
      var txt = cds.length ? '<span class="u-dept">' + cds.map(nmOf).map(esc).join(' · ') + '</span>'
                           : '<span class="u-all">전 부서 (등록 없음)</span>';
      return '<tr class="urow' + (u.userid === CUR ? ' on' : '') + '" onclick="udPickUser(\'' + esc(u.userid) + '\');">' +
             '<td>' + esc(u.usernm || '') + '</td><td>' + esc(u.userid) + '</td><td>' + txt + '</td></tr>';
    }).join('') : '<tr><td colspan="4" style="text-align:center; color:#8a99a3;">사용자가 없습니다.</td></tr>';
    /* 복사 — 받을 사람은 **보고 있는 사람만 뺀 전원**. 계정 종류로 가르지 않는다.
       ★①은 라디오(한 명) · ②는 체크(여러 명) — 모양만 봐도 몇 명을 고르는지 안다. */
    /* ⚠회색 글씨가 무슨 뜻인지 안 보인다는 지적(2026-08-15) — **「담당 N개」로 적고**
       전체 이름은 마우스를 올리면 나온다(잘린 이름 줄을 그대로 두면 라벨 없는 글씨가 된다). */
    udCopyToRender();
    var reg = USERS.filter(function(u){ return (u.deptcds || '').length; }).length;
    gel('udStat').textContent = '사용자 ' + USERS.length + '명 · 담당 등록 ' + reg + '명';
  }

  function setDeptChecks(cds){
    [].slice.call(document.querySelectorAll('#udDeptBox input')).forEach(function(x){
      x.checked = cds.indexOf(x.value) >= 0;
    });
  }
  /** ═══ 주 기능 — 왼쪽에서 한 사람을 고르면 **그 사람 담당**이 체크되어 나온다.
      그대로 고쳐서 [저장] 하면 끝. 거의 언제나 이것만 쓴다. */
  window.udPickUser = function(id){
    CUR = id;
    var u = null;
    USERS.forEach(function(x){ if (x.userid === id) u = x; });
    if (!u) return;
    var cds = (u.deptcds || '').split(',').filter(function(x){ return x; });
    setDeptChecks(cds);
    gel('udWho').innerHTML = '<b>' + esc(u.usernm || id) + '</b> 의 담당 부서 ' +
      '<span class="hint">— ' + (cds.length ? '지금 ' + cds.length + '개' : '지금 등록 없음(전 부서)') + '</span>';
    /* ★관리자도 **부서를 지정할 수 있다**(사용자 지시 2026-08-15) — 계정 종류로 막지 않는다.
       등록이 없으면 전 부서라는 규칙은 모두에게 같다. */
    gel('udSaveBtn').disabled = false;
    gel('udPickMsg').textContent = '';
    // 고른 사람 줄에 표시
    [].slice.call(document.querySelectorAll('#udUserBody tr.urow')).forEach(function(tr){
      tr.classList.remove('on');
    });
    var rows = document.querySelectorAll('#udUserBody tr.urow');
    for (var i = 0; i < USERS.length && i < rows.length; i++) if (USERS[i].userid === id) rows[i].classList.add('on');
    udCopyToRender();   // 보고 있는 사람은 「받을 사람」 목록에서 뺀다
    udCopyMsg();
  };

  /* ═══ 편의 기능 — 접어 둔다(가끔 쓴다). 켤 때만 왼쪽에 체크칸이 나온다. ═══ */
  window.udMoreToggle = function(){
    var b = gel('udMoreBox'), on = b.style.display === 'none';
    b.style.display = on ? '' : 'none';
    gel('udMoreArrow').textContent = on ? '▾' : '▸';
    // 펼칠 때 **쓸 수 있는 상태인지** 바로 알린다 — 한 명뿐이면 복사가 성립하지 않는다
    if (on) {
      var n = USERS.length;
      if (n < 2) say('직원이 ' + n + '명이라 복사할 수 없습니다 — 두 명 이상이어야 합니다.', 'info');
    }
  };
  window.udPick = function(on){
    [].slice.call(document.querySelectorAll('#udDeptBox input')).forEach(function(x){ x.checked = !!on; });
  };
  /* ── 알림 — 프로젝트 표준인 SweetAlert(Swal). 라이브러리가 없으면 기본 창으로 내려간다.
       ★창을 **작게** 쓴다(사용자 지적) — 기본값은 아이콘·여백이 커서 부서 이름이 몇 줄로 접힌다.
         폭 `ud-swal` 로 넓히고(부서가 15개까지 온다) 아이콘은 없애거나 작게.
       ⚠***JS 주석 안에 `--` + `%>` 를 쓰지 말 것*** — JSP 가 거기서 주석을 닫아 버린다(실제로 겪음). */
  function say(text, icon){
    if (!window.Swal) { alert(text); return; }
    Swal.fire({ icon:icon || 'info', title:text, width:380, padding:'0.9em',
                timer:1600, showConfirmButton:false,
                customClass:{ popup:'ud-swal', title:'ud-swal-t' } });
  }
  function ask(html){
    if (!window.Swal) return Promise.resolve(confirm(String(html).replace(/<[^>]*>/g, '')));
    return Swal.fire({ html:html, width:460, padding:'1em',
                       showCancelButton:true, confirmButtonText:'예', cancelButtonText:'아니오',
                       customClass:{ popup:'ud-swal', htmlContainer:'ud-swal-h' } })
               .then(function(r){ return !!r.value; });
  }

  /** 받을 사람 — **한 명**(라디오). 「여러 명」은 만들었다가 뺐다(사용자 지적 : 의미 없음). */
  function copyTo(){
    var r = document.querySelector('#udCopyToBox input.udct:checked');
    return r ? r.value : '';
  }
  function uOf(id){ var f = null; USERS.forEach(function(u){ if (u.userid === id) f = u; }); return f; }

  /** ②「적용할 대상자」 목록 — ★**원본으로 고른 사람은 빼고** 그린다.
      자기에게 자기를 복사할 일은 없고, 목록에 남아 있으면 「골랐는데 왜 안 되나」가 된다.
      ⚠받을 사람이 하나도 없으면(=일반 사용자가 한 명뿐인 병원) **왜 비었는지 적는다.** */
  function udCopyToRender(){
    var box = gel('udCopyToBox');
    /* ★고를 수 있는 사람만 남긴다(사용자 지적 2026-08-15) — 고를 수 없는 줄을 늘어놓으면
       목록만 길어지고 읽을 것이 없다. **왜 비었는지**는 비었을 때만 적는다. */
    var list = USERS.filter(function(u){ return u.userid !== CUR; });
    if (!list.length) {
      box.innerHTML = '<div style="padding:10px; color:#b8860b; font-size:12px; line-height:1.6;">' +
        '복사받을 <b>다른 직원</b>이 없습니다 —<br>[요양기관등록 ▸ 사용자등록] 에서 직원을 더 등록하세요.</div>';
      return;
    }
    box.innerHTML = list.map(function(u){
      var cds = (u.deptcds || '').split(',').filter(function(x){ return x; });
      var now = cds.length ? '담당 ' + cds.length + '개' : '전 부서';
      return '<label title="' + (cds.length ? '지금 담당 : ' + esc(cds.map(nmOf).join(' · ')) : '등록 없음') + '">' +
             '<input type="radio" name="udct" class="udct" value="' + esc(u.userid) + '" onchange="udCopyMsg();">' +
             esc(u.usernm || u.userid) + '<span class="d">' + now + '</span></label>';
    }).join('');
  }

  /** 복사를 쓸 수 없는 상태면 **받을 사람 목록과 단추를 함께 잠근다** — 누를 수 있는데 안 되는 자리를 안 만든다. */
  function udCopyLock(lock){
    var box = gel('udCopyToBox'), btn = gel('udCopyBtn'), add = gel('udAddMode');
    if (box) { box.style.opacity = lock ? '.45' : ''; box.style.pointerEvents = lock ? 'none' : ''; }
    if (btn) btn.disabled = !!lock;
    if (add) add.disabled = !!lock;
  }

  /** 복사 줄의 「복사할 내용」·안내를 지금 상태로 다시 적는다.
      ★복사할 내용 = **지금 보고 있는 사람 + 위 체크칸** — 고를 것은 「받을 사람」 하나뿐이다. */
  window.udCopyMsg = function(){
    var src = gel('udCopySrc'), msg = gel('udCopyMsg');
    if (!src || !msg) return;
    var to = copyTo(), pick = chosenDepts();
    if (!CUR) {
      src.textContent = '— 왼쪽에서 사용자를 고르세요 —';
      src.className = 'ud-copy-src none';
      msg.textContent = '';
      udCopyLock(true);
      return;
    }
    var s0 = uOf(CUR);
    src.className = 'ud-copy-src';
    udCopyLock(false);
    src.innerHTML = '<b>' + esc(s0 ? (s0.usernm || CUR) : CUR) + '</b> 의 담당 <b>' + pick.length + '개</b>';
    if (!pick.length) { msg.innerHTML = '위 <b>담당 부서</b> 칸에서 줄 부서를 고르세요.'; return; }
    if (!to) { msg.textContent = '받을 사람을 한 명 고르세요.'; return; }
    var t0 = uOf(to);
    msg.innerHTML = '<b>' + esc(t0 ? (t0.usernm || to) : to) + '</b> 에게 줍니다.';
  };

  /** ★**보고 있는 사람의 담당(위 체크칸)** 을 **받을 사람 한 명**에게 준다. 이 자리에서 저장까지 끝난다. */
  window.udCopyApply = function(){
    if (!CUR) { say('왼쪽에서 사용자를 먼저 고르세요.', 'info'); return; }
    var to = copyTo();
    if (!to) { say('받을 사람을 한 명 고르세요.', 'info'); return; }
    if (to === CUR) { say('같은 사람입니다 — 다른 사람을 고르세요.', 'info'); return; }
    var s0 = uOf(CUR), t0 = uOf(to);
    var cds = chosenDepts();                       // ★위 체크칸이 곧 복사할 내용(한 군데서만 고른다)
    if (!cds.length) { say('위 [담당 부서] 칸에서 줄 부서를 고르세요.', 'info'); return; }
    var nm = cds.map(nmOf);
    var what = esc(nm.slice(0, 6).join(' · ')) + (nm.length > 6 ? ' <b>외 ' + (nm.length - 6) + '개</b>' : '');
    var add = gel('udAddMode').checked;
    ask('<b>' + esc(s0.usernm || CUR) + '</b> 의 담당 <b>' + nm.length + '개</b> 를' +
        '<div style="margin:.2em 0 .5em;">' + what + '</div>' +
        '<b>' + esc(t0 ? (t0.usernm || to) : to) + '</b> 에게 ' +
        (add ? '<b>더합니다</b>' : '<b>그대로 줍니다</b>') + '.' +
        (add ? '<div style="color:#6b7c86; margin-top:.3em;">받는 사람의 기존 담당은 그대로 둡니다.</div>'
             : '<div style="color:#c0392b; margin-top:.3em;">받는 사람의 기존 담당은 지워집니다.</div>')
    ).then(function(yes){
      if (!yes) return;
      post('<c:url value="/qps/userDeptSave.do"/>',
           { userIds: to, deptCds: cds.join(','), addMode: add ? 'Y' : 'N' })
        .then(function(r){
          say(((r && r.message) || '복사했습니다.').replace(/\*\*/g, ''), 'success');
          load(null);
        }, function(){ say('복사에 실패했습니다.', 'error'); });
    });
  };

  /** 주 기능 — 지금 보고 있는 한 사람의 담당을 저장한다. */
  window.udSave = function(){
    var users = CUR ? [CUR] : [];
    var depts = chosenDepts();
    var add = false;                 // 주 기능은 언제나 「이 체크대로」 — 더하기는 복사에만 있다
    if (!users.length) { say('왼쪽에서 사용자를 고르세요.', 'info'); return; }
    if (add && !depts.length) { say('더할 부서를 고르세요.', 'info'); return; }
    var nms = USERS.filter(function(u){ return users.indexOf(u.userid) >= 0; })
                   .map(function(u){ return u.usernm || u.userid; });
    var who = esc(nms.slice(0, 3).join(', ')) + (nms.length > 3 ? ' 외 ' + (nms.length - 3) + '명' : '');
    /* ★무엇이 어떻게 바뀌는지 **묻는 창에서 보여준다** — 덮어쓰기는 되돌리기가 없다.
       ⚠부서가 15개까지 오므로 **다 늘어놓지 않는다** — 6개까지만 적고 나머지는 「외 N개」. */
    var nm = depts.map(nmOf);
    var what = esc(nm.slice(0, 6).join(' · ')) + (nm.length > 6 ? ' <b>외 ' + (nm.length - 6) + '개</b>' : '');
    var line = '<div style="margin:.2em 0 .5em;">' + what + ' <span style="color:#8a99a3;">(' + nm.length + '개)</span></div>';
    var html = add
      ? '<b>' + who + '</b> 에게 다음을 <b>더합니다</b>' + line +
        '<span style="color:#6b7c86;">기존 담당은 그대로 둡니다.</span>'
      : depts.length
        ? '<b>' + who + '</b> 의 담당을 다음으로 <b>바꿉니다</b>' + line +
          '<span style="color:#c0392b;">기존 담당은 지워집니다.</span>'
        : '<b>' + who + '</b> 을(를) <b>전 부서</b>로 되돌립니다.' +
          '<div style="color:#6b7c86; margin-top:.3em;">부서를 하나도 고르지 않았습니다.</div>';
    ask(html).then(function(yes){
      if (!yes) return;
      post('<c:url value="/qps/userDeptSave.do"/>',
           { userIds: users.join(','), deptCds: depts.join(','), addMode: add ? 'Y' : 'N' })
        .then(function(r){
          var m = ((r && r.message) || '적용했습니다.').replace(/\*\*/g, '');
          gel('udPickMsg').textContent = m;
          say(m, 'success');
          load(null);                     // 다시 읽어도 보던 사람은 그대로 둔다(연달아 고치기 좋게)
        }, function(){ say('적용에 실패했습니다.', 'error'); });
    });
  };

  /** @param keep 다시 골라 둘 사용자 ID 들 — 적용 뒤 이어서 고치기 좋게 선택을 되살린다. */
  function load(keep){
    post('<c:url value="/qps/userDeptBase.do"/>', {}).then(function(r){
      USERS = (r && r.users) || [];
      DEPTS = (r && r.dept) || [];
      render();
      if (CUR) udPickUser(CUR);            // 방금 저장된 담당이 그대로 보이게
    }, function(){ gel('udUserBody').innerHTML =
      '<tr><td colspan="4" style="text-align:center; color:#c0392b;">불러오지 못했습니다.</td></tr>'; });
  }
  $(function(){ load(); });
})();

/* === 글자 크기 (2026-08-18 요청) ==========================================
   QI 계획서(qpsQiPlan)의 zzZoom 과 **같은 규칙** - 0.8~1.6배, 0.1 단위, ↺ 는 처음 크기.
   ★고른 크기는 **이 PC 이 브라우저에만** 남는다(localStorage). 키는 화면마다 따로 둔다. */
(function(){
  var W = 'qpsUserDept', ZKEY = 'qpsZoom_' + W;
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
</div><%-- /#qpsUserDept --%>
</div><%-- /.dashboard-wrapper --%>
