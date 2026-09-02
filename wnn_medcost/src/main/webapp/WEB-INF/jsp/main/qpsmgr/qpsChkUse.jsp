<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%-- qpsChkUse.jsp — 우리 병원 사용 서식 (2026-08-18)

     ★★[2026-08-18 사용자 확정] ***여기 하나로 통일한다.***
       · 서식을 <만드는> 것은 종전대로 위너넷 [서식 관리] — 거기서 부서·기본 분류를 정한다.
       · 병원은 이 화면에서 ***부서별로 맞는 서식을 골라 켠다.*** 그것이 곧 그 병원의 점검표 목록이다.
       ⇒ 별도의 「부서 관리」 화면은 만들지 않는다(같은 일을 두 자리에서 하게 된다).

     ★★[2026-08-18 사용자 지시] 화면은 <세 칸>이다 :
       ┌─ 좌 : 부서 목록 (부서마다 <쓰는 수 / 전체 수>)
       ├─ 가운데 : 그 부서가 ***쓰는*** 서식 — [빼기]
       └─ 우 : ***전체 양식*** — [추가]. ***어느 부서 양식인지 뱃지로 보여준다.***

     ⚠★***양식의 부서는 서식이 이미 가진 값이다***(서식 관리에서 정한다).
       그래서 <다른 부서> 양식을 추가하면 켜지기는 하되 ***그 부서 목록에 들어간다*** —
       가운데(지금 고른 부서)에는 안 나타난다. 그것을 모르면 「추가했는데 사라졌다」가 되므로
       추가한 순간 어디로 갔는지 알려 준다.

     ★★거르기·옮기기는 <화면에서만> 한다 — 목록은 처음 한 번 전부 받아 두고, 저장할 때
       ***전체를 훑어 보낸다.*** 그래야 걸러서 안 보이던 서식이 통째로 꺼지지 않는다.

     ⚠막는 것은 화면이 아니라 서버다 — QpsController.hospCd() 가 s_wnn_yn='Y' 일 때만
       파라미터 hospCd 를 받고, 아니면 로그인 쿠키의 병원을 강제한다.
     ★주의: 이 파일 안에서 Deferred EL 표기(샵+중괄호) 금지 --%>

<script src="/asset/js/ui-message.js"></script>

<%-- ★.dashboard-wrapper 는 winn 공통 레이아웃 필수 --%>
<div class="dashboard-wrapper">
<div id="qpsChkUse" data-wnn="<c:out value='${wnnYn}'/>" data-dept="<c:out value='${chkDeptCd}'/>">
<style>
  #qpsChkUse{ background:#f4f6f8; color:#1f2a30; min-height:100%; padding:14px 16px 60px; max-width:100%; overflow-x:hidden; }
  #qpsChkUse *{ box-sizing:border-box; }
  #qpsChkUse .cu-head{ display:flex; align-items:center; gap:10px; margin-bottom:12px; flex-wrap:wrap; }
  #qpsChkUse .cu-title{ font-size:18px; font-weight:800; color:#20303a; display:flex; align-items:center; gap:8px; }
  #qpsChkUse .cu-dot{ width:10px; height:10px; border-radius:50%; background:linear-gradient(135deg,#1f5a4b,#2a7665); }
  #qpsChkUse .cu-sub{ font-size:12px; color:#6b7c86; }
  #qpsChkUse .cu-hosp{ background:#e7f3ee; color:#1f5a4b; font-size:12px; font-weight:800;
      border:1px solid #cfe3da; border-radius:14px; padding:3px 11px; }
  #qpsChkUse .cu-spacer{ flex:1; }
  #qpsChkUse select, #qpsChkUse input[type=text]{
      border:1px solid #cfd8e0; border-radius:5px; padding:5px 7px; font-family:inherit; font-size:12.5px; background:#fff; }
  #qpsChkUse .cu-btn{ border:1px solid #1f5a4b; background:#1f5a4b; color:#fff; border-radius:6px;
      padding:6px 14px; font-size:13px; font-weight:600; cursor:pointer; white-space:nowrap; }
  #qpsChkUse .cu-btn.mini{ padding:3px 10px; font-size:12px; border-color:#cfd8e0; color:#556570; background:#fff; font-weight:500; }
  #qpsChkUse .cu-note{ background:#f0f7f4; border:1px solid #cfe3da; border-radius:8px; padding:9px 12px;
      font-size:12.5px; color:#1f5a4b; line-height:1.6; margin-bottom:12px; }
  #qpsChkUse .cu-help{ width:20px; height:20px; line-height:1; border-radius:50%; border:1px solid #cfd8e0;
      background:#fff; color:#6b7c86; font-size:12px; font-weight:800; cursor:pointer; padding:0; }
  #qpsChkUse .cu-help:hover, #qpsChkUse .cu-help.on{ background:#1f5a4b; border-color:#1f5a4b; color:#fff; }
  #qpsChkUse .cu-wnn{ background:#fdf6e3; border:1px solid #e8d9a8; border-radius:8px; padding:8px 12px;
      font-size:12.5px; color:#7a5c1f; margin-bottom:12px; display:flex; align-items:center; gap:8px; flex-wrap:wrap; }

  /* ── 세 칸 ─────────────────────────────────────────────────────── */
  #qpsChkUse .cu-3{ display:grid; grid-template-columns:210px minmax(0,1fr) minmax(0,1fr); gap:10px; align-items:start; }
  @media (max-width:1100px){ #qpsChkUse .cu-3{ grid-template-columns:1fr; } }
  #qpsChkUse .cu-col{ background:#fff; border:1px solid #e3e9ed; border-radius:10px; display:flex; flex-direction:column; min-height:320px; }
  #qpsChkUse .cu-ch{ padding:9px 12px; border-bottom:1px solid #eef2f5; display:flex; align-items:center;
      gap:8px; flex-wrap:wrap; }
  #qpsChkUse .cu-ct{ font-size:13px; font-weight:800; color:#20303a; }
  #qpsChkUse .cu-cb{ padding:8px; overflow-y:auto; max-height:62vh; }

  /* 좌 : 부서 */
  #qpsChkUse .cu-dept{ display:flex; align-items:center; gap:6px; padding:7px 10px; border-radius:7px;
      font-size:12.5px; color:#43555f; cursor:pointer; border:1px solid transparent; }
  #qpsChkUse .cu-dept:hover{ background:#f2f7f5; }
  #qpsChkUse .cu-dept.on{ background:#1f5a4b; border-color:#1f5a4b; color:#fff; font-weight:700; }
  #qpsChkUse .cu-dept b{ flex:1; font-weight:inherit; }
  #qpsChkUse .cu-dept .n{ font-size:11.5px; color:#8a99a3; }
  #qpsChkUse .cu-dept.on .n{ color:#cfe3da; }
  #qpsChkUse .cu-dept.none .n{ color:#b5443c; font-weight:700; }   /* 한 종도 안 쓰는 부서 */
  #qpsChkUse .cu-dept.on.none .n{ color:#ffd9d5; }

  /* 가운데·우 : 서식 줄 */
  #qpsChkUse .cu-row{ display:flex; align-items:flex-start; gap:8px; padding:7px 9px; border:1px solid #eef2f5;
      border-radius:8px; margin-bottom:5px; }
  #qpsChkUse .cu-row:hover{ background:#f7fbf9; }
  #qpsChkUse .cu-row .t{ flex:1; min-width:0; }
  #qpsChkUse .cu-nm{ font-size:13px; font-weight:700; color:#20303a; word-break:keep-all; }
  #qpsChkUse .cu-meta{ font-size:11.5px; color:#8a99a3; margin-top:2px; }
  #qpsChkUse .cu-badge{ display:inline-block; background:#eef3f6; color:#43555f; border-radius:9px;
      padding:1px 7px; font-size:11px; font-weight:700; margin-right:4px; }
  #qpsChkUse .cu-badge.other{ background:#fdf1e3; color:#8a5a1f; }   /* 다른 부서 양식 */
  #qpsChkUse .cu-badge.base{ background:#e7f3ee; color:#1f5a4b; }    /* 기본 세트에 든 양식 */
  #qpsChkUse .cu-badge.add{ background:#eaf1fb; color:#2c5a8a; }     /* 병원이 더한 것 */
  #qpsChkUse .cu-badge.off{ background:#fdf3f3; color:#b5443c; }     /* 병원이 뺀 것 */
  #qpsChkUse .cu-badge.use{ background:#1f5a4b; color:#fff; }        /* 우측에 나온 「쓰는 중」 */
  #qpsChkUse .cu-row.used{ background:#f7fbf9; border-color:#dfeae5; }
  #qpsChkUse .cu-state{ padding:7px 12px; font-size:12px; line-height:1.6; border-bottom:1px solid #eef2f5;
      background:#f7fafb; color:#43555f; }
  #qpsChkUse .cu-state b{ color:#1f5a4b; }
  #qpsChkUse .cu-state.chg{ background:#fdf6e3; color:#7a5c1f; }
  #qpsChkUse .cu-state.chg b{ color:#7a5c1f; }
  #qpsChkUse .cu-state.def{ background:#e7f3ee; color:#1f5a4b; }
  #qpsChkUse .cu-mv{ border:1px solid #cfd8e0; background:#fff; color:#1f5a4b; border-radius:6px;
      padding:3px 9px; font-size:12px; font-weight:700; cursor:pointer; white-space:nowrap; }
  #qpsChkUse .cu-mv:hover{ background:#eef7f3; }
  #qpsChkUse .cu-mv.del{ color:#b5443c; }
  #qpsChkUse .cu-mv.del:hover{ background:#fdf3f3; }
  /* 우측 부서 묶음 머리 — 차례는 공통코드 고정 */
  #qpsChkUse .cu-grp{ display:flex; align-items:center; gap:6px; padding:6px 4px 4px; margin-top:6px;
      border-bottom:1px solid #e7edf1; font-size:12px; font-weight:800; color:#1f5a4b; }
  #qpsChkUse .cu-grp:first-child{ margin-top:0; }
  #qpsChkUse .cu-grp .n{ font-weight:600; color:#8a99a3; }
  #qpsChkUse .cu-empty{ color:#8a99a3; font-size:12.5px; padding:26px 10px; text-align:center; line-height:1.7; }
  #qpsChkUse .zz-zoom{ display:inline-flex; gap:4px; align-items:center; margin-left:2px; margin-right:14px; }
  #qpsChkUse .zz-zoom button{ border:1px solid #cfd9e0; background:#fff; color:#43555f; border-radius:6px;
                           padding:4px 9px; font-size:13px; font-weight:700; cursor:pointer; }
  #qpsChkUse .zz-zoom button:hover{ background:#eef3f6; }
</style>

<div class="cu-head">
  <div class="cu-title"><span class="cu-dot"></span>우리 병원 사용 서식 <span class="cu-sub">부서별로 쓸 점검표를 고릅니다</span>
    <button type="button" class="cu-help" id="cuHelpBtn" onclick="cuHelp();" title="쓰는 법 보기">?</button></div>
  <span class="cu-hosp" id="cuHosp">🏥 <c:out value="${hospNm}" default="병원 미확인"/></span>
  <div class="cu-spacer"></div>
  <button type="button" class="cu-btn" onclick="cuSave();">저장</button>
  <span class="cu-sub" id="cuStat"></span>
  <span style="flex:0 0 12px;"></span>
  <%-- 글자 크기 — 이 PC 이 브라우저에만 저장된다 --%>
  <span class="zz-zoom">
    <button type="button" onclick="zzZoom(-1);" title="글자 작게">가－</button>
    <button type="button" onclick="zzZoom(1);"  title="글자 크게">가＋</button>
    <button type="button" onclick="zzZoom(0);"  title="처음 크기로">↺</button>
  </span>
</div>

<%-- ★[2026-08-18 사용자 지적] 안내문이 **자리를 너무 차지한다** ⇒ 접어 두고 [?] 로 편다.
     ***지우지는 않는다*** — 처음 쓰는 사람에게는 이 설명이 화면의 절반이다.
     편 상태는 이 PC 이 브라우저에 기억된다(한 번 읽고 접으면 계속 접힌 채). --%>
<div class="cu-note" id="cuNote" style="display:none;">
  왼쪽에서 <b>부서</b>를 고르고, 오른쪽 <b>추가할 양식</b>(아직 안 쓰는 것)에서 <b>[＋추가]</b> 하면
  가운데 <b>쓰는 서식</b>이 됩니다.
  빼려면 가운데에서 <b>[－빼기]</b>. 다 고르고 <b>[저장]</b> 을 누르세요.<br>
  ★가운데는 <b>위너넷이 정한 기본 설정</b>으로 시작합니다 — <b>그대로 쓰셔도 되고</b>, 우리 병원에 맞게 고치셔도 됩니다.
  고친 것은 <b>[기본으로 되돌리기]</b> 로 언제든 되돌릴 수 있습니다.<br>
  여기서 켜고 꺼도 <b>이미 작성한 자료는 지워지지 않습니다</b>. 서식을 <b>새로 만들거나 고치는 것</b>은
  위너넷 <b>[서식 관리]</b>에서 합니다.
</div>

<%-- ★위너넷일 때만 — 병원이 못 하면 우리가 대신 켜 준다 --%>
<c:if test="${wnnYn eq 'Y'}">
<%-- ★위너넷은 <두 가지>를 손본다 (2026-08-18) :
     ⓐ**기본 설정** — 전 병원이 처음에 쓰는 세트(HOSP_CD='*'). 병원이 아무것도 안 하면 이것으로 돈다.
     ⓑ**한 병원 설정** — 병원이 못 하면 대신 켜 준다. --%>
<div class="cu-wnn">
  <b>위너넷</b>
  <label style="cursor:pointer;"><input type="checkbox" id="cuDefMode" onchange="cuModeChg();">
    <b>기본 설정</b>(전 병원 공통) 편집</label>
  <span id="cuHospBox">
    · 다른 병원 대신 설정 :
    <input type="text" id="cuHospCd" placeholder="병원코드(요양기관기호)" style="width:170px;">
  </span>
  <button type="button" class="cu-btn mini" onclick="cuLoad();">불러오기</button>
  <span class="cu-sub" id="cuWho">— 지금은 <b>내 병원</b></span>
</div>
</c:if>

<div class="cu-3">
  <%-- 좌 : 부서 --%>
  <div class="cu-col">
    <div class="cu-ch"><span class="cu-ct">부서</span><span class="cu-sub" id="cuDeptSum"></span></div>
    <div class="cu-cb" id="cuDepts"></div>
  </div>

  <%-- 가운데 : 쓰는 서식 --%>
  <div class="cu-col">
    <div class="cu-ch">
      <span class="cu-ct" id="cuMidTitle">쓰는 서식</span>
      <span class="cu-sub" id="cuMidCnt"></span>
      <div class="cu-spacer"></div>
      <%-- ★[2026-08-18 사용자 지시] 가운데에도 찾기 — 쓰는 서식이 300종을 넘으면 눈으로 못 찾는다 --%>
      <input type="text" id="cuQM" placeholder="서식 찾기" style="width:120px;" oninput="cuPaint();">
      <button type="button" class="cu-btn mini" id="cuResetBtn" onclick="cuReset();"
              style="display:none;">기본으로 되돌리기</button>
      <button type="button" class="cu-btn mini" onclick="cuAll(false);">전체 빼기</button>
    </div>
    <%-- ★지금이 「기본 그대로」인지 「우리 병원이 고친 상태」인지 — 모르면 왜 이렇게 보이는지 알 수 없다 --%>
    <div class="cu-state" id="cuState"></div>
    <div class="cu-cb" id="cuMid"></div>
  </div>

  <%-- 우 : 전체 양식 --%>
  <div class="cu-col">
    <%-- ★[2026-08-18 사용자 지적] 「전체 양식」이라 적어 두고 ***아직 안 쓰는 것만*** 보여주고 있었다.
         (309종을 이미 쓰는 병원에서 「전체 양식 5종」으로 보인다 — 이름이 사실과 어긋난다.)
         ⇒ 이름을 **「추가할 양식」**으로 바꾸고, 전체가 몇 종인지는 숫자로 같이 적는다. --%>
    <div class="cu-ch">
      <span class="cu-ct">추가할 양식</span>
      <span class="cu-sub" id="cuRightCnt"></span>
      <div class="cu-spacer"></div>
      <label class="cu-sub" style="cursor:pointer;">
        <input type="checkbox" id="cuOnlyDept" onchange="cuPaint();"> 고른 부서 것만</label>
      <input type="text" id="cuQ" placeholder="양식 찾기" style="width:130px;" oninput="cuPaint();">
      <button type="button" class="cu-btn mini" onclick="cuAll(true);">보이는 것 전체 추가</button>
    </div>
    <div class="cu-cb" id="cuRight"></div>
  </div>
</div>

<script>
(function(){
  var LIST  = [];     // ★전체 서식. 한 번만 받는다 — 옮기기는 화면에서만 한다
  var USE   = {};     // formid → true/false. 화면 상태를 여기 모은다
  var DEPTS = [], DNM = {}, CNM = {};
  var curDept = '';   // 고른 부서('' = 전체)
  var SAVED   = {};     // 서버에서 받은 그대로 — 「아직 저장 전」인지 가리는 데 쓴다
  var OWNSET  = false;  // 이 병원이 직접 정한 적이 있는가(false = 기본 세트를 그대로 쓰는 중)
  var DEFMODE = false;  // 위너넷이 <기본 세트> 자체를 편집하는 중인가

  function gel(id){ return document.getElementById(id); }   // ★$ 로 짓지 말 것
  // ★dataType:'json' 필수 — 빠뜨리면 응답이 문자열로 와서 오류 없이 조용히 0건이 된다
  function post(url, data){
    return $.ajax({ url:url, type:'POST', data:data, dataType:'json' }).then(function(res){
      if (res && res.result === 'FAIL') { throw new Error(res.message || '처리에 실패했습니다.'); }
      return res;
    });
  }
  function err(e){ _alertBox((e && e.message) ? e.message : '처리 중 오류가 발생했습니다.', {icon:'❌'}); }
  function esc(s){ return (s==null?'':String(s)).replace(/[&<>"]/g, function(c){
      return ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;'})[c]; }); }
  /* ★Swal 은 프로젝트 표준 — ***창은 작게***(부서·서식 이름이 여러 줄로 접힌다).
     ⚠Swal 창은 body 바로 밑에 붙으므로 #qpsChkUse 안에 CSS 를 두면 안 먹는다 → 인라인 옵션으로 준다. */
  function toast(text, icon){
    if (!window.Swal) return;
    Swal.fire({ icon:icon || 'info', title:text, width:380, padding:'0.9em',
                timer:2200, showConfirmButton:false });
  }
  /** 위너넷이 다른 병원(또는 ★기본 세트 '*')을 고른 경우에만 병원코드를 보낸다.
      ⚠막는 것은 서버다 — hospCd() 가 s_wnn_yn='Y' 일 때만 이 값을 받는다. */
  function hospParam(){
    if (DEFMODE) return { hospCd: '*' };            // ★'*' = 전 병원 공통 기본 세트
    var el = gel('cuHospCd');
    return (el && el.value.trim()) ? { hospCd: el.value.trim() } : {};
  }
  /** 위너넷 : [기본 설정] 켜고 끄기 */
  window.cuModeChg = function(){
    DEFMODE = !!(gel('cuDefMode') && gel('cuDefMode').checked);
    var box = gel('cuHospBox'); if (box) box.style.display = DEFMODE ? 'none' : '';
    cuLoad();
  };

  window.cuLoad = function(){
    var p = hospParam(); p.cateCd = ''; p.deptCd = '';    // ★언제나 전체를 받는다
    post('/qps/chkFormList.do', p).then(function(res){
      LIST = res.list || [];
      USE = {};
      LIST.forEach(function(r){ USE[r.formid] = (r.useyn === 'Y'); });
      SAVED = {};                                   // ★받은 그대로를 따로 둔다 — 「아직 저장 전」을 가리려면 견줄 것이 있어야 한다
      LIST.forEach(function(r){ SAVED[r.formid] = (r.useyn === 'Y'); });
      OWNSET = (res.ownSet === 'Y');
      if (!DEPTS.length) {
        DEPTS = res.dept || [];
        DEPTS.forEach(function(d){ DNM[d.subcode] = d.subcodenm || d.subcode; });
        // ★부서·분류는 **서식 관리에서 만든 값 그대로**다 — 여기서는 이름만 붙여 보여준다
        (res.cate || []).forEach(function(c){ CNM[c.subcode] = c.subcodenm || c.subcode; });
      }
      var who = gel('cuWho');
      if (who) {
        var hc = (gel('cuHospCd') || {}).value;
        who.innerHTML = DEFMODE ? '— 지금은 <b>기본 설정(전 병원)</b>'
                      : (hc && hc.trim()) ? ('— 지금은 <b>' + esc(hc.trim()) + '</b>')
                      : '— 지금은 <b>내 병원</b>';
      }
      cuPaint();
    }).catch(err);
  };

  /** 가운데 = 고른 부서에서 <쓰는> 것.
      ⚠찾기(cuQM)는 **보여줄 때만** 걸러야 한다 — 우측 목록을 정하는 `inMid` 는 찾기 없이 센다.
        안 그러면 글자를 치는 순간 가운데에서 빠진 줄이 우측에 나타나 「두 군데 있는」 것처럼 보인다. */
  function midRows(useQ){
    var q = useQ ? gel('cuQM').value.trim() : '';
    return LIST.filter(function(r){
      if (!USE[r.formid]) return false;
      if (curDept && r.deptcd !== curDept) return false;
      if (q && String(r.formnm || '').indexOf(q) < 0) return false;
      return true;
    });
  }
  /** 우 = ★***가운데에 없는 것 전부***를 부서별로 묶어 보여준다 (2026-08-18 사용자 지시 3번에 걸쳐 다듬음).
      · 「전체를 보여주고 그룹핑해서 — 해당 부서는 아니지만 갖다 쓸 경우」 ⇒ **다른 부서 양식도 보여준다**
      · 「가운데 없는 것만 보여주기」 ⇒ ***가운데에 이미 있는 줄은 빼서*** 같은 것이 두 번 안 보이게
      · 「우측이 안 보이네요」(약국 36/36 을 다 쓰는 상태) ⇒ **안 쓰는 것만 걸러 두면 칸이 텅 빈다**
      ⇒ 규칙 하나로 정리 : ***지금 가운데에 그려진 줄만 빼고 나머지 전부.***
        (전체 부서를 보는 중이면 가운데가 「쓰는 것 전부」라 우측은 자연히 안 쓰는 것만 남는다.)
      ★이미 쓰는 양식은 「쓰는 중」으로 알리고 단추가 [－빼기]가 된다 — 우측에서도 끌 수 있다. */
  function rightRows(){
    var q = gel('cuQ').value.trim(), onlyD = gel('cuOnlyDept').checked;
    var inMid = {};
    midRows().forEach(function(r){ inMid[r.formid] = true; });
    return LIST.filter(function(r){
      if (inMid[r.formid]) return false;               // ★가운데에 있는 줄은 우측에 없다
      if (onlyD && curDept && r.deptcd !== curDept) return false;
      if (q && String(r.formnm || '').indexOf(q) < 0) return false;
      return true;
    });
  }

  function rowHtml(r, side){
    /* ★분류는 <서식 관리에서 만든 값 그대로> 보여준다 — 이 화면에서 정하지 않는다.
       ★우측 줄에도 부서 뱃지를 남긴다(묶음 머리를 지나쳐 읽어도 어디 것인지 보이게).
         고른 부서와 다르면 색을 달리해 눈에 걸리게 한다. */
    var badge = '';
    if (side === 'R') {
      var other = curDept && r.deptcd !== curDept;
      badge = '<span class="cu-badge' + (other ? ' other' : '') + '">' + esc(DNM[r.deptcd] || r.deptcd) + '</span>';
    }
    /* ★기본 세트와 견준 표시 (2026-08-18) — ***기본 설정을 편집할 때는 달지 않는다***(자기 자신과 견줄 수 없다).
       · 가운데(쓰는 것) : 기본에 있으면 「기본」 · 기본에 없으면 「추가」
       · 우측(안 쓰는 것) : 기본에 있는데 뺐으면 「기본에서 뺌」 */
    if (!DEFMODE) {
      var inDef = (r.defyn === 'Y');
      if (side === 'M') badge += inDef ? '<span class="cu-badge base">기본</span>'
                                       : '<span class="cu-badge add">추가</span>';
      else if (inDef)   badge += '<span class="cu-badge off">기본에서 뺌</span>';
    }
    // ★우측에는 <다른 부서의 쓰는 양식>도 함께 나온다 — 「쓰는 중」으로 알리고 단추를 [－빼기]로 바꾼다
    var used = (side === 'R') && !!USE[r.formid];
    if (used) badge += '<span class="cu-badge use">쓰는 중</span>';
    var cate = r.catecd ? (' · ' + esc(CNM[r.catecd] || r.catecd)) : '';
    // ★단추가 스스로 무엇을 하는지 말한다(data-go) — 칸으로 판단하지 않는다
    var btn = (side === 'M' || used)
      ? '<button type="button" class="cu-mv del" data-go="off">－ 빼기</button>'
      : '<button type="button" class="cu-mv" data-go="on">＋ 추가</button>';
    return '<div class="cu-row' + (used ? ' used' : '') + '" data-id="' + esc(r.formid) + '">' +
           '<div class="t">' + badge + '<span class="cu-nm">' + esc(r.formnm) + '</span>' +
           '<div class="cu-meta">' + esc(r.formid) + cate + ' · 항목 ' + (r.itemcnt || 0) +
           (r.doccnt ? (' · 작성 ' + r.doccnt + '건') : '') + '</div></div>' + btn +
           '</div>';
  }

  /** ★우측은 ***부서별로 묶어*** 보여준다 (2026-08-18 사용자 지시 : 「가장 우측은 기본 부서별 설정 고정」).
      ⚠묶음 차례는 **공통코드 차례 고정**이다 — 고른 부서를 위로 끌어올리지 않는다.
        자리가 움직이면 「아까 거기 있던 것」을 다시 찾게 된다. */
  function groupHtml(rows){
    var by = {};
    rows.forEach(function(r){ (by[r.deptcd] = by[r.deptcd] || []).push(r); });
    var h = '';
    DEPTS.forEach(function(d){
      var g = by[d.subcode];
      if (!g || !g.length) return;
      h += '<div class="cu-grp"><span>' + esc(d.subcodenm) + '</span>' +
           '<span class="n">' + g.length + '종</span></div>';
      h += g.map(function(r){ return rowHtml(r, 'R'); }).join('');
      delete by[d.subcode];
    });
    // 공통코드에 없는 부서코드가 붙은 양식 — 조용히 숨기면 「목록에 없는 서식」이 된다
    Object.keys(by).forEach(function(cd){
      h += '<div class="cu-grp"><span>' + esc(cd) + '</span><span class="n">' + by[cd].length + '종</span></div>';
      h += by[cd].map(function(r){ return rowHtml(r, 'R'); }).join('');
    });
    return h;
  }

  function paintDepts(){
    var cnt = {}, on = 0, tot = 0;
    LIST.forEach(function(r){
      var a = cnt[r.deptcd] = cnt[r.deptcd] || [0, 0];
      a[1]++; tot++;
      if (USE[r.formid]) { a[0]++; on++; }
    });
    var h = '<div class="cu-dept' + (curDept ? '' : ' on') + '" data-cd="">' +
            '<b>전체</b><span class="n">' + on + '/' + tot + '</span></div>';
    DEPTS.forEach(function(d){
      var a = cnt[d.subcode];
      if (!a) return;                                   // ★양식이 없는 부서는 줄을 안 만든다
      h += '<div class="cu-dept' + (curDept === d.subcode ? ' on' : '') + (a[0] === 0 ? ' none' : '') +
           '" data-cd="' + esc(d.subcode) + '">' +
           '<b>' + esc(d.subcodenm) + '</b><span class="n">' + a[0] + '/' + a[1] + '</span></div>';
    });
    gel('cuDepts').innerHTML = h;
    gel('cuDeptSum').textContent = '쓰는 것 ' + on + ' / 전체 ' + tot + '종';
  }

  /** ★지금 화면이 기본과 얼마나 다른가 — 「왜 이렇게 보이나」에 답하는 자리다.
      ⚠**저장 전 화면 상태**로 센다(사람이 방금 고친 것도 포함) — 저장하면 그대로 굳는다. */
  function paintState(){
    var box = gel('cuState'), btn = gel('cuResetBtn');
    if (DEFMODE) {                                   // 기본 세트를 편집하는 중
      box.className = 'cu-state def';
      box.innerHTML = '<b>기본 설정(전 병원 공통)</b> 을 고치는 중입니다. ' +
                      '여기서 켠 것이 <b>병원이 아무것도 안 했을 때</b>의 목록이 됩니다.';
      if (btn) btn.style.display = 'none';
      return;
    }
    var add = 0, off = 0, dirty = 0;
    LIST.forEach(function(r){
      var on = !!USE[r.formid], inDef = (r.defyn === 'Y');
      if (on && !inDef) add++;
      if (!on && inDef) off++;
      if (on !== !!SAVED[r.formid]) dirty++;          // ★서버에 있는 것과 다른가 = 아직 저장 전
    });
    // ★저장 단추를 띠 안에도 둔다(2026-09-02 「옮기고 상단 저장 버튼을 실행해야 하네요」) — 더하기/빼기 한 자리 바로 옆에서 저장한다
    var tail = dirty ? ' <b>아직 저장 전입니다</b>(고친 것 ' + dirty + '종). ' +
                       '<button type="button" class="cu-btn mini" style="margin-left:6px;border-color:#1f5a4b;color:#1f5a4b;font-weight:700;" onclick="cuSave();">지금 저장</button>' : '';
    if (!add && !off) {
      box.className = dirty ? 'cu-state chg' : 'cu-state def';
      box.innerHTML = (OWNSET ? '지금 목록이 <b>기본 설정과 같습니다.</b>'
                              : '<b>기본 설정 그대로</b> 쓰는 중입니다 — 이대로 두어도 됩니다.') + tail;
    } else {
      box.className = 'cu-state chg';
      box.innerHTML = '기본과 다릅니다 — <b>더한 것 ' + add + '종</b> · <b>뺀 것 ' + off + '종</b>.' + tail;
    }
    if (btn) btn.style.display = (OWNSET || add || off) ? '' : 'none';
  }

  window.cuPaint = function(){
    paintDepts(); paintState();
    var mid = midRows(true), right = rightRows();
    gel('cuMidTitle').textContent = (curDept ? (DNM[curDept] || curDept) + ' — 쓰는 서식' : '쓰는 서식(전체 부서)');
    var midAll = midRows(false).length;
    gel('cuMidCnt').textContent = (mid.length === midAll) ? (mid.length + '종')
                                                          : (mid.length + '종 / ' + midAll + '종');
    gel('cuMid').innerHTML = mid.length ? mid.map(function(r){ return rowHtml(r, 'M'); }).join('')
      : '<div class="cu-empty">' + (gel('cuQM').value.trim()
          ? '찾는 서식이 없습니다.'
          : '아직 고른 서식이 없습니다.<br>오른쪽 <b>추가할 양식</b>에서 [＋추가] 하세요.') + '</div>';
    // ★「전체 5종」으로 읽히지 않게 — 보이는 수 · 그중 안 쓰는 것 · 전체를 같이 적는다
    var off = 0;
    right.forEach(function(r){ if (!USE[r.formid]) off++; });
    gel('cuRightCnt').textContent = right.length + '종 (안 쓰는 것 ' + off + ') · 전체 ' + LIST.length + '종';
    gel('cuRight').innerHTML = right.length ? groupHtml(right)
      : '<div class="cu-empty">더 추가할 양식이 없습니다.</div>';
  };

  /* 추가·빼기 (위임) — 다시 그려도 살아남는다.
     ★★***다른 부서 양식을 추가하면 그 부서 목록으로 간다*** — 양식의 부서는 서식이 가진 값이라
       여기서 바꾸지 않는다. 모르면 「추가했는데 사라졌다」가 되므로 어디로 갔는지 알려 준다. */
  function move(box, defOn){
    gel(box).addEventListener('click', function(ev){
      var b = ev.target.closest ? ev.target.closest('.cu-mv') : null;
      if (!b) return;
      var row = b.closest('.cu-row'), id = row && row.getAttribute('data-id');
      if (!id) return;
      // ★단추가 스스로 말한다 — 우측에도 [－빼기]가 섞이므로 칸으로 판단하면 안 된다
      var g = b.getAttribute('data-go');
      var on = g ? (g === 'on') : defOn;
      USE[id] = on;
      if (on && curDept) {
        var r = LIST.filter(function(x){ return x.formid === id; })[0];
        if (r && r.deptcd !== curDept) {
          toast('이 양식은 「' + (DNM[r.deptcd] || r.deptcd) + '」 것입니다.\n그 부서 목록에 들어갔습니다.');
        }
      }
      cuPaint();
    });
  }
  move('cuRight', true);
  move('cuMid', false);

  // 부서 고르기(위임)
  gel('cuDepts').addEventListener('click', function(ev){
    var b = ev.target.closest ? ev.target.closest('.cu-dept') : null;
    if (!b) return;
    curDept = b.getAttribute('data-cd') || '';
    cuPaint();
  });

  /** ★「보이는 것」만 바꾼다 — 안 보이는 양식은 건드리지 않는다 */
  window.cuAll = function(on){
    (on ? rightRows() : midRows()).forEach(function(r){ USE[r.formid] = on; });
    cuPaint();
  };

  function doSave(uses, msg){
    var p = hospParam();
    p.uses = JSON.stringify(uses);
    return post('/qps/chkUseSave.do', p).then(function(){
      _alertBox(msg, {icon:'✅'});
      cuLoad();
    }).catch(err);
  }

  window.cuSave = function(){
    // ★전체(LIST)를 훑어 보낸다 — 걸러서 안 보이던 서식도 그대로 지켜진다
    var uses = [];
    LIST.forEach(function(r){ if (USE[r.formid]) uses.push({ formid: r.formid }); });
    /* ⚠***한 종도 안 켜고 저장하면 지정이 지워져 기본으로 되돌아간다.***
       그것이 [기본으로 되돌리기]와 같은 동작이라, 모르고 누르면 「전부 뺐는데 그대로네」가 된다 ⇒ 먼저 알린다. */
    if (!uses.length && !DEFMODE) { cuReset(); return; }
    doSave(uses, DEFMODE
      ? ('기본 설정을 저장했습니다.\n' + uses.length + '종이 전 병원의 처음 목록이 됩니다.')
      : ('저장했습니다.\n쓰는 서식 ' + uses.length + '종이 [점검표 작성] 목록에 나옵니다.'));
  };

  /** ★기본으로 되돌리기 = 이 병원 지정을 지운다 — 그러면 기본 세트를 따라간다 */
  window.cuReset = function(){
    if (DEFMODE) return;
    var ask = window.Swal
      ? Swal.fire({ html:'우리 병원 지정을 지우고 <b>기본 설정</b>을 따릅니다.<br>계속할까요?',
                    width:400, padding:'1em', showCancelButton:true,
                    confirmButtonText:'예', cancelButtonText:'아니오' }).then(function(r){ return !!r.value; })
      : Promise.resolve(confirm('우리 병원 지정을 지우고 기본 설정을 따릅니다. 계속할까요?'));
    ask.then(function(ok){
      if (!ok) return;
      doSave([], '기본 설정으로 되돌렸습니다.');
    });
  };

  /** 도움말 접고 펴기 — ★상태를 기억한다(한 번 읽고 접으면 계속 접힌 채) */
  var HKEY = 'qpsChkUseHelp';
  window.cuHelp = function(){
    var n = gel('cuNote'), on = (n.style.display === 'none');
    n.style.display = on ? '' : 'none';
    gel('cuHelpBtn').classList.toggle('on', on);
    try { sessionStorage.setItem(HKEY, on ? 'Y' : 'N'); } catch (e) {}
  };

  $(function(){
    // ★사이드바에서 부서를 달고 들어온 경우 — 주소 숨김 때문에 서버가 모델로 내려 준다
    var d = (gel('qpsChkUse').getAttribute('data-dept') || '').trim();
    if (d) curDept = d;
    try { if (sessionStorage.getItem(HKEY) === 'Y') cuHelp(); } catch (e) {}
    cuLoad();
  });
})();

/* ═══ 글자 크기 (2026-08-18) ═══════════════════════════════════════════════ */
(function(){
  var W = 'qpsChkUse', ZKEY = 'qpsZoom_' + W;
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
</div><%-- /#qpsChkUse --%>
</div><%-- /.dashboard-wrapper --%>
