<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%-- qpsDeptForm.jsp — 부서별 양식 (2026-08-18)

     왜 : 「부서별 양식 저장관리하는 내용만 — 서식 관리(위너넷)는 한눈에 안 들어와서」(사용자).
          서식 관리는 한 서식의 <모든 칸>을 다룬다. 여기는 ***어느 양식이 어느 부서 것인가***만 본다.

     ★★***한 양식은 한 부서다***(사용자 확정 2026-08-18).
       두 부서에서 쓰려면 ***복제해 별도 서식***을 만든다 — 그래서 줄마다 [복제]가 있다.
       (문서 키가 <병원+서식+기간>이라 한 서식을 두 부서가 같이 쓰면 같은 달 문서가 서로 덮인다.)

     ★부서를 옮겨도 **작성한 문서는 흔들리지 않는다**(문서 키에 부서가 없다).
     ⚠공통('*') 서식을 고치므로 **위너넷 전용** — 서버(QpsController.qpsDeptForm)가 병원 계정을 돌려보낸다.
     ★주의: 이 파일 안에서 Deferred EL 표기(샵+중괄호) 금지 --%>

<script src="/asset/js/ui-message.js"></script>

<%-- ★.dashboard-wrapper 는 winn 공통 레이아웃 필수 --%>
<div class="dashboard-wrapper">
<div id="qpsDeptForm">
<style>
  #qpsDeptForm{ background:#f4f6f8; color:#1f2a30; min-height:100%; padding:14px 16px 60px; max-width:100%; overflow-x:hidden; }
  #qpsDeptForm *{ box-sizing:border-box; }
  #qpsDeptForm .df-head{ display:flex; align-items:center; gap:10px; margin-bottom:10px; flex-wrap:wrap; }
  #qpsDeptForm .df-title{ font-size:18px; font-weight:800; color:#20303a; display:flex; align-items:center; gap:8px; }
  #qpsDeptForm .df-dot{ width:10px; height:10px; border-radius:50%; background:linear-gradient(135deg,#1f5a4b,#2a7665); }
  #qpsDeptForm .df-sub{ font-size:12px; color:#6b7c86; }
  #qpsDeptForm .df-spacer{ flex:1; }
  #qpsDeptForm select, #qpsDeptForm input[type=text]{
      border:1px solid #cfd8e0; border-radius:5px; padding:4px 6px; font-family:inherit; font-size:12.5px; background:#fff; }
  #qpsDeptForm .df-btn{ border:1px solid #1f5a4b; background:#1f5a4b; color:#fff; border-radius:6px;
      padding:6px 14px; font-size:13px; font-weight:600; cursor:pointer; white-space:nowrap; }
  #qpsDeptForm .df-btn.mini{ padding:3px 10px; font-size:12px; border-color:#cfd8e0; color:#556570; background:#fff; font-weight:500; }
  #qpsDeptForm .df-note{ background:#f0f7f4; border:1px solid #cfe3da; border-radius:8px; padding:8px 12px;
      font-size:12.5px; color:#1f5a4b; line-height:1.6; margin-bottom:10px; }
  /* ═══ 복사 띠 (2026-09-08 사용자 「어디 것을 어디로 복사해서 쓴다가 핵심이라고」) ═══
     이 화면의 일은 **복사**다 — 「한 양식은 한 부서」라서, 다른 부서도 쓰려면 복사해 그 부서에 두는 것.
     종전에는 복사가 줄 끝 작은 [복제] 단추 하나였고 부서 셀렉트(옮기기)가 주인처럼 보였다. 자리를 바꿨다. */
  #qpsDeptForm .df-copy{ background:#eef4fb; border:1px solid #b9cfe6; border-left:4px solid #2f6fb0;
      border-radius:8px; padding:10px 14px; margin-bottom:10px; }
  #qpsDeptForm .df-copy .ln{ display:flex; align-items:center; gap:8px; flex-wrap:wrap; font-size:13px; color:#1f2a37; }
  #qpsDeptForm .df-copy b{ color:#2f6fb0; }
  #qpsDeptForm .df-copy select{ height:30px; font-size:13px; }
  #qpsDeptForm .df-copy .go{ border:1px solid #2f6fb0; background:#2f6fb0; color:#fff; border-radius:6px;
      padding:6px 16px; font-size:13px; font-weight:700; cursor:pointer; }
  #qpsDeptForm .df-copy .go:disabled{ opacity:.5; cursor:default; }
  /* 이동 — 복사(파랑 채움)와 **다른 동작**이라 테두리만 준다(자리를 옮길 뿐 늘지 않는다) */
  #qpsDeptForm .df-copy .move{ border:1px solid #b99a4a; background:#fff; color:#8a6d1f; border-radius:6px;
      padding:6px 14px; font-size:13px; font-weight:700; cursor:pointer; }
  #qpsDeptForm .df-copy .move:disabled{ opacity:.5; cursor:default; }
  #qpsDeptForm .df-copy .hint{ margin-top:5px; font-size:11.5px; color:#5a6b7a; }
  #qpsDeptForm .df-pick{ width:16px; height:16px; cursor:pointer; }
  /* 작성 건수 — 옮기거나 복사할 때 영향을 가늠하는 유일한 재료다 */
  #qpsDeptForm .df-doc{ font-size:11px; font-weight:700; border-radius:8px; padding:1px 7px; margin-left:6px;
      background:#eef2f5; color:#8a99a3; }
  #qpsDeptForm .df-doc.has{ background:#e7f0fa; color:#2f6fb0; }
  /* 한눈에 — 부서별 수 */
  #qpsDeptForm .df-chips{ display:flex; gap:6px; flex-wrap:wrap; margin-bottom:10px; }
  #qpsDeptForm .df-chip{ border:1px solid #dbe3e8; background:#fff; border-radius:16px; padding:5px 12px;
      font-size:12.5px; color:#43555f; cursor:pointer; display:inline-flex; align-items:center; gap:6px; }
  #qpsDeptForm .df-chip:hover{ background:#f2f7f5; }
  #qpsDeptForm .df-chip.on{ border-color:#1f5a4b; background:#1f5a4b; color:#fff; font-weight:700; }
  #qpsDeptForm .df-chip .n{ font-size:11.5px; color:#8a99a3; }
  #qpsDeptForm .df-chip.on .n{ color:#cfe3da; }
  /* ★고른 수 — 복사 띠와 같은 파랑으로, 부서 수(회색)와 눈에 띄게 가른다(2026-09-08).
     고름은 부서를 옮겨도 남으므로 「지금 안 보이는 부서에 골라 둔 것」이 여기서 보여야 한다. */
  #qpsDeptForm .df-chip .p{ font-size:11px; font-weight:700; color:#fff; background:#2f6fb0;
      border-radius:8px; padding:0 6px; line-height:16px; }
  #qpsDeptForm .df-chip.on .p{ background:#fff; color:#1f5a4b; }
  #qpsDeptForm .df-pickoff{ font-size:11.5px; color:#5a6b7a; }
  #qpsDeptForm .df-card{ background:#fff; border:1px solid #e3e9ed; border-radius:10px; padding:12px 14px; overflow-x:auto; }
  /* 표 위 저장 줄 — 복사 띠(파랑)와 색을 달리해 「다른 업무」임을 보인다 */
  #qpsDeptForm .df-tbar{ display:flex; align-items:center; gap:8px; flex-wrap:wrap; margin-bottom:10px;
      padding:7px 10px; background:#faf8f3; border:1px solid #e8e0cf; border-left:4px solid #b99a4a; border-radius:8px; }
  #qpsDeptForm .df-tbar .ttl{ font-size:12.5px; color:#6b5a2e; }
  #qpsDeptForm .df-tbar .ttl b{ color:#8a6d1f; }
  #qpsDeptForm table{ border-collapse:collapse; width:100%; min-width:760px; }
  #qpsDeptForm th, #qpsDeptForm td{ border-bottom:1px solid #eef2f5; padding:6px 8px; font-size:12.5px; text-align:left; }
  #qpsDeptForm thead th{ background:#f7fafb; color:#43555f; font-weight:700; white-space:nowrap; border-bottom:1px solid #e3e9ed; }
  #qpsDeptForm tbody tr:hover{ background:#f7fbf9; }
  #qpsDeptForm tr.chg{ background:#fdf6e3; }
  #qpsDeptForm .df-nm{ font-weight:700; color:#20303a; }
  /* 부서는 **읽기 전용** — 이동은 위 띠 한 곳에서만(2026-09-08). 콤보가 아님을 한눈에 보이게 글자로 둔다. */
  #qpsDeptForm .df-deptro{ display:inline-block; padding:3px 9px; border-radius:12px;
      background:#f2f6f9; color:#43555f; font-size:12px; }
  #qpsDeptForm .df-meta{ font-size:11.5px; color:#8a99a3; }
  #qpsDeptForm .df-empty{ color:#8a99a3; font-size:13px; padding:24px; text-align:center; }
  #qpsDeptForm .zz-zoom{ display:inline-flex; gap:4px; align-items:center; margin-left:2px; }
  #qpsDeptForm .zz-zoom button{ border:1px solid #cfd9e0; background:#fff; color:#43555f; border-radius:6px;
                           padding:4px 9px; font-size:13px; font-weight:700; cursor:pointer; }
</style>

<div class="df-head">
  <div class="df-title"><span class="df-dot"></span>부서 양식 복사 · 이동
    <span class="df-sub">어느 부서 것을 어느 부서로 <b>복사</b>하거나 <b>옮길지</b> 정합니다</span></div>
  <div class="df-spacer"></div>
  <input type="text" id="dfQ" placeholder="양식 찾기" style="width:150px;" oninput="dfPaint();">
  <span class="zz-zoom">
    <button type="button" onclick="zzZoom(-1);" title="글자 작게">가－</button>
    <button type="button" onclick="zzZoom(1);"  title="글자 크게">가＋</button>
    <button type="button" onclick="zzZoom(0);"  title="처음 크기로">↺</button>
  </span>
</div>

<%-- ★안내는 **두 동작을 갈라** 적는다(2026-09-08) — 사용자가 「복사와 저장 차이」를 세 번 물었다.
     늘어나는가(복사) · 자리만 옮기는가(이동) 를 첫 줄에서 못 박는다. --%>
<div class="df-note">
  ★<b>한 양식은 한 부서</b>입니다. 그래서 다른 부서도 쓰려면 <b>복사</b>해 그 부서에 둡니다 — 이 화면의 주된 일입니다.<br>
  · <b>[서식 복사]</b> = <b>하나가 둘이 됩니다.</b> 원본은 그 부서에 그대로 두고 대상 부서에 사본을 만듭니다.<br>
  · <b>[서식 부서 이동]</b> = <b>자리만 옮깁니다.</b> 새로 생기지 않고 <b>원래 부서에서는 사라집니다</b> — 잘못 배정된 것을 바로잡을 때만 쓰세요.<br>
  둘 다 <b>누르는 즉시 반영</b>되고, <b>이미 작성한 문서는 어느 쪽이든 그대로</b>입니다.
  서식의 <b>항목·표 모양</b>은 <b>[서식 관리]</b> 에서 고칩니다.
  <span style="color:#b5443c;">⚠복사로 만든 공통 서식은 화면에서 지울 수 없습니다 — 코드를 확인하고 누르세요.</span>
</div>

<%-- ★복사 띠 — 이 화면의 주 동작. 「어디 것을(고른 양식) → 어디로(대상 부서)」 를 한 줄로 읽히게 둔다. --%>
<div class="df-copy">
  <div class="ln">
    <b>📋 서식 복사 · 부서 이동</b>
    <span>고른 양식</span><b id="dfPickN">0종</b>
    <%-- ★고른 것은 부서를 옮겨도 남는다(코드로 기억) — 지금 표에 안 보이는 몫을 여기에 적어 준다(2026-09-08) --%>
    <span class="df-pickoff" id="dfPickOff"></span>
    <%-- ★고른 것만 모아 보기(2026-09-08 사용자 「그렇다고 선택한 내용만 보여주는 것도 아니고」) —
         고름은 여러 부서에 걸치므로 **담은 것을 한 표에서 확인하고** 복사할 수 있어야 한다. --%>
    <button type="button" class="df-btn mini" id="dfPickOnly" onclick="dfPickOnlyToggle();">선택내용 모아보기</button>
    <span>→ 대상 부서</span>
    <select id="dfToDept"></select>
    <button type="button" class="go" id="dfCopyGo" onclick="dfCopyMany();" disabled
            title="고른 양식을 대상 부서에 하나 더 만듭니다 — 원본은 그대로 남습니다.">서식 복사</button>
    <%-- ★같은 고르기·같은 대상 부서로 **이동**도 여기서(2026-09-08 사용자 「복사 옆에 부서 이동으로 만드는 게 더 직관적이지 않을까요」).
         종전에는 이동만 「표의 부서 콤보를 바꾸고 → 표 위 저장」이라 **길이 달라** 계속 헷갈렸다.
         이제 두 동작이 **한 줄에서 갈린다** : 복사=늘리기 / 이동=자리 옮기기. --%>
    <button type="button" class="move" id="dfMoveGo" onclick="dfMoveMany();" disabled
            title="고른 양식을 대상 부서로 옮깁니다 — 새로 생기지 않고 원래 부서에서는 사라집니다.">서식 부서 이동</button>
    <button type="button" class="df-btn mini" onclick="dfPickClear();">고른 것 지우기</button>
    <span class="df-sub" id="dfCopyStat" style="margin-left:6px;"></span>
  </div>
  <div class="hint">표에서 <b>왼쪽 칸을 체크</b>해 여러 양식을 한 번에 처리합니다.
    고른 것은 <b>부서를 옮겨 다녀도 남습니다</b> — 무엇을 담았는지는 <b>[선택내용 모아보기]</b> 로 확인하세요.<br>
    · <b>[서식 복사]</b> — 항목·표까지 그대로 복사되고 <b>새 서식코드는 대상 부서 규칙으로 자동</b>으로 붙습니다(누르기 전에 목록으로 보여 드립니다).
    이름은 원본 그대로 둡니다. 한 종만 코드·이름을 직접 정하려면 줄 오른쪽 <b>[복사…]</b> 를 쓰세요.<br>
    · <b>[서식 부서 이동]</b> — 코드·이름·항목 그대로 <b>부서만</b> 바뀝니다. 이미 그 부서인 것은 세지 않습니다.<br>
    ★<b>둘 다 누르는 즉시 반영됩니다</b> — 표 위의 <b>[분류 변경 반영]</b> 을 따로 누를 필요가 없습니다.
    그 단추는 <b>표에서 분류를 바꿨을 때</b>만 씁니다.</div>
</div>

<div class="df-chips" id="dfChips"></div>

<div class="df-card">
  <%-- ★저장 단추는 **표 위**에 둔다(2026-09-08 사용자 「여러 부서 자료 선택 후 복사인데 과정이 하나 더 있는 느낌」).
       머리줄에 두었더니 복사 흐름(고르기 → 대상 부서 → 복사) 옆에 붙어 **복사에 필요한 단계처럼** 읽혔다.
       이 단추가 맡는 것은 **표의 분류·부서 칸을 바꾼 것**(=옮기기)뿐이라, 그 칸이 있는 표 위가 제자리다. --%>
  <%-- ★이 줄은 **분류 전용**이다(2026-09-08) — 부서 이동은 위 띠 한 곳으로 모았으므로 여기 이름에 「부서」가 들어가면 안 된다. --%>
  <div class="df-tbar">
    <span class="ttl">✎ 표에서 <b>분류</b>를 바꿨다면</span>
    <span class="df-sub" id="dfChg"></span>
    <button type="button" class="df-btn" id="dfSaveBtn" onclick="dfSave();"
            title="표의 분류 칸에서 바꾼 것만 반영합니다. 부서를 옮기려면 위 [서식 부서 이동] 을 쓰세요.">분류 변경 반영</button>
    <span class="df-sub" style="color:#8a99a3;">부서를 옮기려면 위 <b>[서식 부서 이동]</b></span>
  </div>
  <table>
    <thead><tr>
      <th style="width:34px;"><input type="checkbox" class="df-pick" id="dfPickAll" onclick="dfPickAllToggle(this);" title="보이는 양식을 모두 고릅니다"></th>
      <th style="width:42%;">양식</th>
      <th style="width:150px;">분류</th>
      <th style="width:150px;">부서 <span style="font-weight:400;color:#8a99a3;">(옮기려면 위 [서식 부서 이동])</span></th>
      <th style="width:92px;"></th>
    </tr></thead>
    <tbody id="dfBody"><tr><td colspan="5" class="df-empty">불러오는 중…</td></tr></tbody>
  </table>
</div>

<script>
(function(){
  var LIST = [], DEPTS = [], CATES = [], RULE = {};
  var SEL = {};          // formid → 고름(복사 대상). ★다시 그려도 살아남게 화면 밖에 둔다(2026-09-08)
  var PICK_ONLY = false; // 고른 것만 보기(부서 칩 무시) — 담은 것을 확인하고 복사하라고(2026-09-08)
  var ORG = {};          // formid → [부서, 분류]  받은 그대로(바뀐 줄을 가리려면 견줄 것이 있어야 한다)
  var CUR = {};          // formid → [부서, 분류]  화면에서 고친 값
  var curDept = '';

  function gel(id){ return document.getElementById(id); }
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
  /* ★알림·확인은 **프로젝트 표준 ui-message.js** 를 쓴다(2026-09-08 사용자 「alert 메시지 기존 사용자(방식)으로 해줘」).
     ⛔종전에는 이 화면만 **Swal 을 직접** 불러 다른 QPS 화면과 모양이 달랐다 — 상시 방침(CLAUDE.md 머리)에 어긋난다.
     ★부르는 자리는 그대로 두고 **속만 갈아 끼운다** — `toast(글, 종류)` · `ask(html) → Promise<boolean>`. */
  function toast(text, icon){
    var t = (icon === 'info') ? 'info' : (icon === 'warn' || icon === 'warning') ? 'warn' : 'ok';
    if (window._toast) { _toast(text, t); return; }
    _alertBox(text, { icon: (t === 'ok') ? '✅' : 'ℹ️' });
  }
  /** 확인창 — 두 번째 인자로 아이콘·확인 단추 이름을 바꾼다(이동은 「옮기기」처럼 **할 일을 단추에** 적는다) */
  function ask(html, opts){
    opts = opts || {};
    return new Promise(function(resolve){
      _confirmBox({ msg: html, icon: opts.icon || '❓', okText: opts.okText || '예',
                    onOk: function(){ resolve(true); }, onCancel: function(){ resolve(false); } });
    });
  }

  window.dfLoad = function(){
    // ★공통('*') 을 본다 — 배정을 정하는 자리다(병원 전용 서식은 그 병원 화면에서 다룬다)
    post('/qps/chkFormList.do', { hospCd:'*', cateCd:'', deptCd:'' }).then(function(res){
      LIST = res.list || [];
      if (!DEPTS.length) { DEPTS = res.dept || []; CATES = res.cate || []; }
      ORG = {}; CUR = {};
      LIST.forEach(function(r){
        ORG[r.formid] = [r.deptcd || '', r.catecd || ''];
        CUR[r.formid] = [r.deptcd || '', r.catecd || ''];
      });
      // 부서별 쓰는 분류 규칙 — 등록 화면과 같은 규칙으로 분류 후보를 좁힌다
      return post('/qps/deptCateList.do', {}).then(function(d){
        RULE = {};
        (d.rules || []).forEach(function(x){ (RULE[x.deptcd] = RULE[x.deptcd] || {})[x.catecd] = true; });
      }).catch(function(){ RULE = {}; });
    }).then(function(){ fillToDept(); dfPaint(); }).catch(err);
  };

  /** 복사 띠의 대상 부서 — 한 번만 채운다(다시 그려도 고른 값이 남게) */
  function fillToDept(){
    var s = gel('dfToDept');
    if (s.options.length) return;
    s.innerHTML = '<option value="">— 고르세요 —</option>' + deptOpts('');
    s.addEventListener('change', paintPick);
  }

  function rows(){
    var q = gel('dfQ').value.trim();
    return LIST.filter(function(r){
      /* ★「고른 것만 보기」 — 담은 것은 여러 부서에 걸치므로 이때는 부서 칩을 무시한다(찾기는 그대로 건다) */
      if (PICK_ONLY) { if (!SEL[r.formid]) return false; }
      else if (curDept && (CUR[r.formid] || [])[0] !== curDept) return false;
      if (q && String(r.formnm || '').indexOf(q) < 0 && String(r.formid).indexOf(q.toUpperCase()) < 0) return false;
      return true;
    });
  }
  /** 표에서 바꿀 수 있는 것은 **분류뿐**이다(부서는 읽기 전용 — 이동은 위 띠에서) */
  function chgCnt(){
    var n = 0;
    LIST.forEach(function(r){
      var a = ORG[r.formid] || [], b = CUR[r.formid] || [];
      if (a[1] !== b[1]) n++;
    });
    return n;
  }

  /** ★한눈에 — 부서마다 양식이 몇 종인가. ***고친 값 기준***으로 센다(옮기면 바로 숫자가 움직인다) */
  function paintChips(){
    var cnt = {}, tot = 0, sel = {}, selTot = 0;
    LIST.forEach(function(r){
      var d = (CUR[r.formid] || [])[0] || '';
      cnt[d] = (cnt[d] || 0) + 1; tot++;
      /* ★고른 것도 부서마다 센다 — 고름은 부서를 옮겨도 남으므로 「어디에 몇 종 골라 뒀는지」가 안 보이면 헷갈린다(2026-09-08) */
      if (SEL[r.formid]) { sel[d] = (sel[d] || 0) + 1; selTot++; }
    });
    var pick = function(n){ return n ? '<span class="p">✔' + n + '</span>' : ''; };
    /* 「고른 것만 보기」 중에는 어느 칩도 켜지 않는다 — 부서로 보고 있지 않기 때문 */
    var h = '<button type="button" class="df-chip' + (!PICK_ONLY && !curDept ? ' on' : '') + '" data-cd="">' +
            '<b>전체</b><span class="n">' + tot + '</span>' + pick(selTot) + '</button>';
    DEPTS.forEach(function(d){
      var n = cnt[d.subcode] || 0;
      h += '<button type="button" class="df-chip' + (!PICK_ONLY && curDept === d.subcode ? ' on' : '') + '" data-cd="' + esc(d.subcode) + '">' +
           '<b>' + esc(d.subcodenm) + '</b><span class="n">' + n + '</span>' + pick(sel[d.subcode] || 0) + '</button>';
    });
    gel('dfChips').innerHTML = h;
  }

  /** 그 부서의 분류 규칙 밖인가 — 규칙이 없는 부서는 무엇이든 된다(=false) */
  function offRule(deptCd, cateCd){
    var rule = RULE[deptCd];
    return !!(rule && cateCd && !rule[cateCd]);
  }

  /** 분류 후보 — 그 부서에 정해 둔 것만. ★지금 값은 규칙 밖이어도 남긴다(조용히 바뀌면 안 된다) */
  function cateOpts(deptCd, cur){
    var rule = RULE[deptCd], h = '<option value="">— 없음 —</option>';
    CATES.forEach(function(c){
      var ok = !rule || !!rule[c.subcode];
      if (!ok && c.subcode !== cur) return;
      h += '<option value="' + esc(c.subcode) + '"' + (c.subcode === cur ? ' selected' : '') + '>' +
           esc(c.subcodenm) + (ok ? '' : ' (규칙 밖)') + '</option>';
    });
    return h;
  }
  function deptOpts(cur){
    var h = '';
    DEPTS.forEach(function(d){
      h += '<option value="' + esc(d.subcode) + '"' + (d.subcode === cur ? ' selected' : '') + '>' +
           esc(d.subcodenm) + '</option>';
    });
    return h;
  }

  window.dfPaint = function(){
    paintChips();
    var rs = rows(), b = gel('dfBody');
    b.innerHTML = rs.length ? rs.map(function(r){
      var c = CUR[r.formid] || [], o = ORG[r.formid] || [];
      var chg = (c[1] !== o[1]);   /* 부서는 표에서 못 바꾼다 — 남는 변경은 분류뿐 */
      var dc = Number(r.doccnt || 0);
      return '<tr' + (chg ? ' class="chg"' : '') + ' data-id="' + esc(r.formid) + '">' +
             '<td><input type="checkbox" class="df-pick" data-pick="1"' + (SEL[r.formid] ? ' checked' : '') + '></td>' +
             '<td><span class="df-nm">' + esc(r.formnm) + '</span>' +
             '<span class="df-doc' + (dc ? ' has' : '') + '">' + (dc ? ('작성 ' + dc + '건') : '작성 없음') + '</span>' +
             '<div class="df-meta">' + esc(r.formid) + ' · 항목 ' + (r.itemcnt || 0) +
             (chg ? ' · <b>분류 바꿈: ' + esc(nmOf(CATES, o[1])) + ' → ' + esc(nmOf(CATES, c[1])) + '</b>' : '') +
             /* 규칙 밖 분류를 조용히 지우지 않으므로(2026-09-08), 눈에 보이게 알려 준다 */
             (offRule(c[0], c[1]) ? ' · <span style="color:#b5443c;">분류 「' + esc(nmOf(CATES, c[1])) +
                                    '」는 이 부서 규칙 밖 — 그대로 두거나 다시 고르세요</span>' : '') +
             '</div></td>' +
             '<td><select data-f="cate">' + cateOpts(c[0], c[1]) + '</select></td>' +
             /* ★부서는 **읽기 전용**(2026-09-08 사용자 「핵심은 선택하고 복사할지, 부서 이동을 할지 아닌가요」) —
                표에서도 바꿀 수 있게 두면 **이동하는 길이 둘**이 되어 「바꾼 대로 적용」이 무슨 뜻인지 헷갈린다.
                이동은 위 띠의 [서식 부서 이동] 한 길로 모았다. */
             '<td><span class="df-deptro">' + esc(nmOf(DEPTS, c[0])) + '</span></td>' +
             '<td><button type="button" class="df-btn mini" data-copy="1" title="이 한 종만 — 코드·이름을 직접 정해 복사합니다">복사…</button></td></tr>';
    }).join('') : ('<tr><td colspan="5" class="df-empty">' +
        (PICK_ONLY ? '고른 양식이 없습니다 — 표 왼쪽 칸을 체크해 담으세요.' : '해당하는 양식이 없습니다.') + '</td></tr>');
    var n = chgCnt();
    gel('dfChg').textContent = n ? ('분류를 바꾼 것 ' + n + '종 — 아직 반영 전') : '';
    /* 고친 것이 없으면 흐리게 둬서 「지금 눌러야 하나」를 없앤다(2026-09-08).
       ⚠**disabled 로 막지 않는다**(같은 날 사용자 「1번 누르면 아무 동작하지 않는데요」) —
       막아 두면 눌러도 onclick 이 아예 안 걸려 **고장 난 단추로 읽힌다.** 눌리게 두고 왜 할 일이 없는지 말해 준다. */
    var sb = gel('dfSaveBtn');
    if (sb) {
      sb.disabled = false; sb.style.opacity = n ? '' : '.55';
      sb.textContent = n ? ('분류 변경 반영 (' + n + '종)') : '분류 변경 반영';
    }
    paintPick();
  };

  /* ── 복사 고르기 ─────────────────────────────────────────────── */
  function picked(){ return LIST.filter(function(r){ return SEL[r.formid]; }); }
  function paintPick(){
    var p = picked(), to = gel('dfToDept').value;
    gel('dfPickN').textContent = p.length + '종';
    gel('dfCopyGo').disabled = !(p.length && to);
    /* 이동 = 이미 그 부서인 것을 빼고 셈한다 — 옮길 것이 없는데 켜 두면 눌러도 아무 일이 없다 */
    var mv = to ? p.filter(function(r){ return (CUR[r.formid] || [])[0] !== to; }).length : 0;
    var mb = gel('dfMoveGo');
    if (mb) { mb.disabled = !mv; mb.textContent = mv ? ('서식 부서 이동 (' + mv + '종)') : '서식 부서 이동'; }
    // 보이는 줄이 다 골라졌는가 — 머리 체크를 맞춘다
    var rs = rows(), on = rs.filter(function(r){ return SEL[r.formid]; }).length;
    var all = gel('dfPickAll'); if (all) all.checked = !!rs.length && on === rs.length;
    /* ★지금 표에 안 보이는 고름을 적어 준다 — [복사]는 「보이는 것」이 아니라 「고른 것 전부」를 옮긴다(2026-09-08) */
    var off = gel('dfPickOff');
    if (off) {
      var hid = p.length - on;
      off.textContent = PICK_ONLY ? '(선택내용만 모아 보는 중)' : (hid > 0 ? ('(이 표에 ' + on + '종 · 다른 부서 ' + hid + '종)') : '');
    }
    var po = gel('dfPickOnly');
    if (po) {
      po.textContent = PICK_ONLY ? '↩ 부서별로 보기' : '선택내용 모아보기';
      po.style.background = PICK_ONLY ? '#2f6fb0' : '';
      po.style.color = PICK_ONLY ? '#fff' : '';
      po.style.borderColor = PICK_ONLY ? '#2f6fb0' : '';
    }
  }
  window.dfPickClear = function(){ SEL = {}; PICK_ONLY = false; gel('dfCopyStat').textContent = ''; dfPaint(); };
  /** 고른 것만 보기 ↔ 부서별 보기 */
  window.dfPickOnlyToggle = function(){
    if (!PICK_ONLY && !picked().length) {
      _alertBox('아직 고른 양식이 없습니다.<br>표 왼쪽 칸을 체크하면 여기에서 <b>고른 것만 모아</b> 볼 수 있습니다.', {icon:'ℹ️'});
      return;
    }
    PICK_ONLY = !PICK_ONLY;
    dfPaint();
  };
  window.dfPickAllToggle = function(el){
    rows().forEach(function(r){ if (el.checked) SEL[r.formid] = 1; else delete SEL[r.formid]; });
    dfPaint();
  };
  function nmOf(list, cd){
    for (var i = 0; i < list.length; i++) if (list[i].subcode === cd) return list[i].subcodenm || cd;
    return cd || '(없음)';
  }

  // 부서 칩(위임)
  gel('dfChips').addEventListener('click', function(ev){
    var b = ev.target.closest ? ev.target.closest('.df-chip') : null;
    if (!b) return;
    curDept = b.getAttribute('data-cd') || '';
    PICK_ONLY = false;   /* 부서를 고르면 「고른 것만 보기」에서 나온다 — 두 보기가 겹치면 무엇을 보는지 흐려진다 */
    dfPaint();
  });

  // 표 안 셀렉트·복제(위임) — 다시 그려도 살아남는다
  gel('dfBody').addEventListener('change', function(ev){
    var s = ev.target;
    // 복사 고르기(체크) — 다시 그려도 살아남게 SEL 에 적는다
    if (s && s.getAttribute && s.getAttribute('data-pick')) {
      var tr0 = s.closest('tr'), id0 = tr0 && tr0.getAttribute('data-id');
      if (!id0) return;
      if (s.checked) SEL[id0] = 1; else delete SEL[id0];
      paintPick();
      paintChips();   /* 체크만 바꿔도 칩의 ✔수가 따라와야 한다 — 표는 다시 그리지 않는다(체크가 튄다) */
      return;
    }
    if (!s || s.tagName !== 'SELECT') return;
    var tr = s.closest('tr'), id = tr && tr.getAttribute('data-id');
    if (!id) return;
    /* ★표에 남은 콤보는 **분류뿐**이다(부서는 읽기 전용 — 이동은 위 띠에서).
       ⚠분류가 그 부서 규칙 밖이어도 ***조용히 비우지 않는다***(2026-09-08 실측으로 고침) —
         전에는 부서를 바꾸면 분류를 지워, 부서만 옮겼는데 분류까지 사라졌다(공통 서식 LAB001 로 확인).
         규칙 밖 값은 셀렉트가 「(규칙 밖)」으로 남기고 줄 밑에 빨간 글로 알린다. */
    if (s.getAttribute('data-f') !== 'cate') return;
    var c = CUR[id] || ['',''];
    c[1] = s.value;
    CUR[id] = c;
    dfPaint();
  });
  gel('dfBody').addEventListener('click', function(ev){
    var b = ev.target.closest ? ev.target.closest('[data-copy]') : null;
    if (!b) return;
    var tr = b.closest('tr'), id = tr && tr.getAttribute('data-id');
    if (!id) return;
    dfCopy(id);
  });

  /* ═══ 여러 양식을 한 부서로 복사 (2026-09-08 — 이 화면의 주 동작) ═══
     ★새 서식코드는 **대상 부서의 규칙**으로 자동으로 만든다 — 사람이 10종을 손으로 짓는 것이 이 업무의 진짜 고통이었다.
       규칙 = 그 부서에서 가장 많이 쓰인 「영문 접두 + 숫자」 꼴을 찾아 **다음 번호**를 붙인다(예: RNL027 → RNL030).
       그런 꼴이 하나도 없으면 원본코드 뒤에 부서 코드를 붙인다(예: NUR069_RENAL) — 규칙이 없는 부서에서도 막히지 않게.
     ★복사 전에 **무엇이 어떤 코드로 생기는지 목록으로 보여 준다**(코드를 되돌릴 수 없으므로). */
  function nextCode(deptCd, srcId, taken){
    var pat = {}, max = {};
    LIST.forEach(function(r){
      if ((CUR[r.formid] || [])[0] !== deptCd) return;
      var m = String(r.formid).match(/^([A-Z]+)(\d+)$/);
      if (!m) return;
      pat[m[1]] = (pat[m[1]] || 0) + 1;
      var n = Number(m[2]), w = m[2].length;
      if (!max[m[1]] || n > max[m[1]].n) max[m[1]] = { n: n, w: w };
    });
    var best = null;
    Object.keys(pat).forEach(function(p){ if (!best || pat[p] > pat[best]) best = p; });
    if (best) {
      var n2 = max[best].n, w2 = max[best].w;
      for (var k = 0; k < 999; k++) {
        n2++;
        var cd = best + String(n2).padStart(w2, '0');
        if (!taken[cd]) return cd;
      }
    }
    var alt = (srcId + '_' + deptCd).replace(/[^A-Z0-9_]/g, '').slice(0, 30);
    var i2 = 1, cd2 = alt;
    while (taken[cd2]) { cd2 = (alt + i2).slice(0, 30); i2++; }
    return cd2;
  }
  window.dfCopyMany = function(){
    var p = picked(), to = gel('dfToDept').value;
    if (!p.length || !to) return;
    var same = p.filter(function(r){ return (CUR[r.formid] || [])[0] === to; });
    if (same.length === p.length) {
      _alertBox('고른 양식이 이미 <b>' + esc(nmOf(DEPTS, to)) + '</b> 것입니다.<br>다른 부서를 고르세요.', {icon:'⚠️'});
      return;
    }
    var taken = {};
    LIST.forEach(function(r){ taken[r.formid] = 1; });
    var plan = [];
    p.forEach(function(r){
      if ((CUR[r.formid] || [])[0] === to) return;      // 이미 그 부서 것은 건너뛴다
      var cd = nextCode(to, r.formid, taken);
      taken[cd] = 1;
      plan.push({ src: r.formid, nm: r.formnm, cate: (CUR[r.formid] || [])[1] || '', neo: cd });
    });
    if (!plan.length) return;
    var listHtml = plan.slice(0, 12).map(function(x){
      return '<div style="margin:2px 0;">· ' + esc(x.nm) + ' <span style="color:#8a99a3;">' + esc(x.src) + '</span> → <b>' + esc(x.neo) + '</b></div>';
    }).join('') + (plan.length > 12 ? ('<div style="color:#8a99a3;">… 그 밖 ' + (plan.length - 12) + '종</div>') : '');
    _confirmBox({
      msg: '<b>' + esc(nmOf(DEPTS, to)) + '</b> 로 <b>' + plan.length + '종</b>을 복사합니다.<br>' +
           '<div style="text-align:left;font-size:12px;margin-top:8px;max-height:210px;overflow:auto;">' + listHtml + '</div>' +
           '<div style="text-align:left;font-size:11.5px;color:#8a99a3;margin-top:8px;">' +
           '원본은 그대로 있습니다(복사입니다). 항목·표까지 복사되고 이름은 원본 그대로 둡니다.<br>' +
           '<b style="color:#b5443c;">⚠공통 서식은 화면에서 못 지웁니다</b> — 코드를 확인하고 누르세요.</div>',
      icon: '📋', okText: '복사',
      onOk: function(){ runCopy(plan, to); }
    });
  };
  function runCopy(plan, to){
    var i = 0, made = [], failed = [];
    gel('dfCopyGo').disabled = true;
    var step = function(){
      if (i >= plan.length) {
        // 복사된 것들을 한 번에 대상 부서로 배정한다(분류는 원본 것을 물려준다)
        var rows2 = made.map(function(x){ return { formId: x.neo, deptCd: to, cateCd: x.cate }; });
        var done = function(){
          SEL = {};
          gel('dfCopyStat').textContent = made.length + '종 복사' + (failed.length ? (' · ' + failed.length + '종 실패') : '');
          if (failed.length) _alertBox('복사하지 못한 것 ' + failed.length + '종 :<br>' + esc(failed.join(', ')), {icon:'⚠️'});
          else toast(made.length + '종을 ' + nmOf(DEPTS, to) + ' 로 복사했습니다.');
          dfLoad();
        };
        if (!rows2.length) { gel('dfCopyGo').disabled = false; done(); return; }
        post('/qps/chkFormDeptSave.do', { hospCd:'*', rows: JSON.stringify(rows2) })
          .then(done, function(){ done(); });
        return;
      }
      var x = plan[i++];
      gel('dfCopyStat').textContent = '(' + i + '/' + plan.length + ') ' + x.nm + ' 복사 중 …';
      post('/qps/chkFormCopy.do', { hospCd:'*', srcFormId:x.src, newFormId:x.neo, newFormNm:x.nm })
        .then(function(){ made.push(x); step(); }, function(){ failed.push(x.src); step(); });
    };
    step();
  }

  /** ★한 종만 — 코드·이름을 직접 정해 복사한다(여러 종은 위 복사 띠가 자동으로 붙인다). */
  function dfCopy(id){
    var src = LIST.filter(function(r){ return r.formid === id; })[0];
    if (!src) return;
    _confirmBox({
      msg: '<b>' + esc(src.formnm) + '</b> 를 복제합니다.<br>' +
           '<div style="text-align:left;font-size:12.5px;margin-top:8px;">' +
           '새 서식코드 <input type="text" id="dfcId" maxlength="30" style="width:120px;" placeholder="예) CLI002"><br>' +
           '<span style="display:inline-block;margin-top:6px;">새 이름 </span>' +
           '<input type="text" id="dfcNm" maxlength="200" style="width:230px;" value="' + esc(src.formnm) + ' (복제)"><br>' +
           '<span style="display:inline-block;margin-top:6px;">부서 </span>' +
           '<select id="dfcDept">' + deptOpts((CUR[id] || [])[0]) + '</select>' +
           '</div>' +
           '<div style="text-align:left;font-size:11.5px;color:#8a99a3;margin-top:8px;">' +
           '항목까지 그대로 복사됩니다. 복제 뒤 이름·항목은 [서식 관리]에서 고치세요.<br>' +
           '<b style="color:#b5443c;">⚠공통 서식은 화면에서 못 지웁니다</b> — 코드를 확인하고 누르세요.</div>',
      icon: '📋', okText: '복제',
      onOk: function(){
        var neo = ((document.getElementById('dfcId') || {}).value || '').trim().toUpperCase();
        var nm  = ((document.getElementById('dfcNm') || {}).value || '').trim();
        var dep = ((document.getElementById('dfcDept') || {}).value || '').trim();
        if (!neo || !nm) { _alertBox('새 서식코드와 이름을 넣어 주세요.', {icon:'⚠️'}); return; }
        // ★공통('*') 으로 복제한다 — 이 화면은 공통 서식을 다룬다
        post('/qps/chkFormCopy.do', { hospCd:'*', srcFormId:id, newFormId:neo, newFormNm:nm })
          .then(function(){
            return post('/qps/chkFormDeptSave.do',
              { hospCd:'*', rows: JSON.stringify([{ formId:neo, deptCd:dep, cateCd:(CUR[id] || [])[1] || '' }]) });
          })
          .then(function(){ toast('복제했습니다 — ' + neo); dfLoad(); })
          .catch(err);
      } });
  }

  /* ═══ 고른 것을 대상 부서로 **옮긴다** (2026-09-08) ═══════════════════════
     ★복사와 나란히 두되 **다른 일**임을 확인창에서 못 박는다 — 원래 부서에서 사라진다.
     ★분류는 **그대로 물려준다**(대상 부서 규칙 밖이어도 비우지 않는다 — 표에서 부서를 바꿀 때와 같은 원칙).
     ★작성 문서가 있는 서식은 **몇 건이 함께 자리를 옮기는지** 확인창에 적는다(문서는 지워지지 않는다). */
  window.dfMoveMany = function(){
    var to = gel('dfToDept').value;
    if (!to) { _alertBox('옮길 <b>대상 부서</b>를 고르세요.', {icon:'ℹ️'}); return; }
    var p = picked().filter(function(r){ return (CUR[r.formid] || [])[0] !== to; });
    if (!p.length) { _alertBox('옮길 것이 없습니다 — 고른 양식이 이미 그 부서입니다.', {icon:'ℹ️'}); return; }
    var toNm = nmOf(DEPTS, to), docs = 0;
    var list = p.slice(0, 12).map(function(r){
      var from = nmOf(DEPTS, (CUR[r.formid] || [])[0]);
      var dc = Number(r.doccnt || 0); docs += dc;
      return '· ' + esc(r.formnm) + ' <span style="color:#8a99a3;">' + esc(r.formid) + ' · ' + esc(from) + ' → ' + esc(toNm) + '</span>' +
             (dc ? ' <span style="color:#b5443c;">작성 ' + dc + '건</span>' : '');
    }).join('<br>');
    p.forEach(function(r){ if (p.indexOf(r) >= 12) docs += Number(r.doccnt || 0); });
    ask('<b>' + esc(toNm) + '</b> 로 <b>' + p.length + '종</b>을 <b>옮깁니다.</b>' +
        '<div style="text-align:left;font-size:12.5px;margin-top:8px;">' + list +
        (p.length > 12 ? ('<br><span style="color:#8a99a3;">… 외 ' + (p.length - 12) + '종</span>') : '') + '</div>' +
        '<div style="text-align:left;font-size:11.5px;color:#8a99a3;margin-top:8px;">' +
        '<b style="color:#b5443c;">복사가 아닙니다</b> — 원래 부서에서는 사라집니다.<br>' +
        '이미 작성한 문서는 지워지지 않고 새 부서 자리에서 보입니다.' +
        (docs ? ('<br>옮기는 양식의 작성 문서 <b>' + docs + '건</b>도 함께 자리를 옮깁니다.') : '') +
        '</div>', { icon:'➡️', okText:'부서 이동' }).then(function(ok){
      if (!ok) return;
      var rows2 = p.map(function(r){ return { formId:r.formid, deptCd:to, cateCd:(CUR[r.formid] || [])[1] || '' }; });
      post('/qps/chkFormDeptSave.do', { hospCd:'*', rows: JSON.stringify(rows2) }).then(function(res){
        SEL = {}; PICK_ONLY = false;
        gel('dfCopyStat').textContent = (res.cnt || rows2.length) + '종 이동';
        toast(rows2.length + '종을 ' + toNm + ' 로 옮겼습니다.');
        dfLoad();
      }).catch(err);
    });
  };

  window.dfSave = function(){
    var rows2 = [];
    LIST.forEach(function(r){
      var a = ORG[r.formid] || [], b = CUR[r.formid] || [];
      if (a[0] !== b[0] || a[1] !== b[1]) rows2.push({ formId:r.formid, deptCd:b[0], cateCd:b[1] });
    });
    /* ★할 일이 없을 때도 **반드시 말해 준다**(2026-09-08 사용자 「1번 누르면 아무 동작하지 않는데요」).
       ★특히 **체크만 해 두고 이 단추를 누른 경우** — 그건 복사하려는 것이므로 [복사] 쪽으로 안내한다.
         (체크 = 복사 고르기 / 이 단추 = 표에서 바꾼 분류·부서 반영 — 둘은 상관이 없다) */
    if (!rows2.length) {
      var p = picked().length;
      if (p) {
        /* ★안내만 하고 끝내지 않는다(2026-09-08 사용자 「확인 누르면 두 개가 모아져서 보여지는 것 아닌가요」) —
           체크만 해 두고 이 단추를 눌렀다는 건 **담은 것을 다루려는 것**이다. 확인이 곧 「모아 보기」가 되게 한다. */
        _alertBox('이 단추는 표에서 <b>분류를 바꾼 것</b>만 반영합니다.<br>' +
                  '고른 <b>' + p + '종</b>은 위쪽 <b>[서식 복사]</b>·<b>[서식 부서 이동]</b> 으로 처리합니다.<br>' +
                  '<span style="font-size:12px;color:#8a99a3;">확인을 누르면 선택한 ' + p + '종을 한 표에 모아 보여 드립니다.</span>',
          { icon:'ℹ️', okText:'선택내용 모아보기 (' + p + '종)',
            onOk: function(){
              PICK_ONLY = true;
              dfPaint();
              var box = document.querySelector('#qpsDeptForm .df-copy');
              if (box && box.scrollIntoView) box.scrollIntoView({ block:'center' });
            } });
        return;
      }
      _alertBox('반영할 것이 없습니다 — <b>바꾼 분류가 없습니다.</b><br>' +
                '표의 <b>분류</b> 칸을 바꾼 뒤에 누르세요.<br>' +
                '<span style="font-size:12px;color:#8a99a3;">복사·이동은 이 단추가 아니라 위쪽 [서식 복사]·[서식 부서 이동] 입니다.</span>',
        { icon:'ℹ️' });
      return;
    }
    var moved = rows2.filter(function(x){ return (ORG[x.formId] || [])[0] !== x.deptCd; }).length;
    ask('표에서 <b>분류를 바꾼 ' + rows2.length + '종</b>을 반영합니다' +
        (moved ? ('<br>그중 <b>' + moved + '종</b>은 <b>부서가 옮겨집니다.</b>') : '') +
        '<br><span style="font-size:12px;color:#8a99a3;">이미 작성한 문서는 그대로입니다.</span>').then(function(ok){
      if (!ok) return;
      post('/qps/chkFormDeptSave.do', { hospCd:'*', rows: JSON.stringify(rows2) }).then(function(res){
        toast('분류를 반영했습니다 — ' + (res.cnt || 0) + '종');
        dfLoad();
      }).catch(err);
    });
  };

  $(function(){ dfLoad(); });
})();

/* ═══ 글자 크기 (2026-08-18) ═══════════════════════════════════════════════ */
(function(){
  var W = 'qpsDeptForm', ZKEY = 'qpsZoom_' + W;
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
</div><%-- /#qpsDeptForm --%>
</div><%-- /.dashboard-wrapper --%>
