<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%-- qpsDuty.jsp — 근무표 (2026-09-08)

     왜 : 사용자 「근무표에 따른 사인도 매치가 되어야 하고」 · 「근무표는 SUNWOO 에도 있었음」 · 「더 효율적으로」.
          지금 일괄 사인은 **내 이름**으로 빈 칸을 채운다. 종이 점검표의 사인 칸은 **그날 근무한 사람**이다.

     ── SUNWOO 원본(D:\SUNWOO\SUNWOO) 과 다르게 한 것 ─────────────────────
       ① 표를 둘(t_duty + t_duty_group)에서 **셋(머리·사람·값)**으로 — 사람 줄이 곧 그 달의 근무조 명단이다.
          명단을 따로 관리하면 두 곳이 반드시 어긋난다.
       ② 근무 기호를 **공통코드 QPS_DUTY_SHIFT** 로 — 원본은 사인 SQL 에 병동 이름이 박혀 있다(그 병원 전용).
       ③ 날짜마다 여럿이면 **적은 차례(SORT_NO)** 로 고른다 — 원본의 `ORDER BY user_id DESC` 는 우연이다.
       ④ 원본에 없는 **전월 가져오기 · 패턴 채우기 · 기호 붓**을 넣었다(사용자 「더 효율적으로」).

     ★알림·확인은 ui-message(_alertBox/_confirmBox/_toast)만 — Swal 직접호출 금지(상시 방침).
     ★조회 함수에는 **순번 가드**(LOAD_REQ) — 늦게 온 옛 응답이 새 달의 격자를 덮으면 안 된다(2026-09-08 규칙).
     ★주의: 이 파일 안에서 Deferred EL 표기(샵+중괄호) 금지 --%>

<script src="/asset/js/ui-message.js"></script>

<div class="dashboard-wrapper">
<div id="qpsDuty">
<style>
  #qpsDuty{ background:#f4f6f8; color:#1f2a30; min-height:100%; padding:14px 16px 60px; max-width:100%; overflow-x:hidden; }
  #qpsDuty *{ box-sizing:border-box; }
  #qpsDuty .dt-head{ display:flex; align-items:center; gap:10px; margin-bottom:10px; flex-wrap:wrap; }
  #qpsDuty .dt-title{ font-size:18px; font-weight:800; color:#20303a; display:flex; align-items:center; gap:8px; }
  #qpsDuty .dt-dot{ width:10px; height:10px; border-radius:50%; background:linear-gradient(135deg,#1f5a4b,#2a7665); }
  #qpsDuty .dt-sub{ font-size:12px; color:#6b7c86; }
  #qpsDuty .dt-spacer{ flex:1; }
  #qpsDuty select, #qpsDuty input[type=text]{
      border:1px solid #cfd8e0; border-radius:5px; padding:4px 6px; font-family:inherit; font-size:12.5px; background:#fff; }
  #qpsDuty .dt-btn{ border:1px solid #1f5a4b; background:#1f5a4b; color:#fff; border-radius:6px;
      padding:6px 14px; font-size:13px; font-weight:600; cursor:pointer; white-space:nowrap; }
  #qpsDuty .dt-btn.ghost{ border-color:#cfd8e0; color:#43555f; background:#fff; font-weight:500; }
  #qpsDuty .dt-btn.mini{ padding:3px 10px; font-size:12px; }
  #qpsDuty .dt-note{ background:#f0f7f4; border:1px solid #cfe3da; border-radius:8px; padding:8px 12px;
      font-size:12.5px; color:#1f5a4b; line-height:1.6; margin-bottom:10px; }
  #qpsDuty .dt-bar{ background:#eef4fb; border:1px solid #b9cfe6; border-left:4px solid #2f6fb0;
      border-radius:8px; padding:10px 14px; margin-bottom:8px; display:flex; gap:8px; align-items:center; flex-wrap:wrap; font-size:13px; }
  #qpsDuty .dt-bar b{ color:#2f6fb0; }
  #qpsDuty .dt-tools{ background:#fdf7ec; border:1px solid #e6d6b4; border-left:4px solid #c99a3a;
      border-radius:8px; padding:8px 14px; margin-bottom:10px; display:flex; gap:8px; align-items:center; flex-wrap:wrap; font-size:12.5px; }
  #qpsDuty .dt-pal{ display:flex; gap:4px; flex-wrap:wrap; }
  #qpsDuty .dt-pal button{ border:1px solid #cfd8e0; background:#fff; border-radius:5px; padding:3px 8px;
      font-size:12px; cursor:pointer; color:#43555f; min-width:34px; }
  #qpsDuty .dt-pal button.on{ border-color:#c99a3a; background:#c99a3a; color:#fff; font-weight:700; }
  #qpsDuty .dt-card{ background:#fff; border:1px solid #e3e9ed; border-radius:10px; padding:10px 12px; overflow-x:auto; }
  <%-- ⚠날짜가 31칸이라 **폭을 못 박지 않으면 성명·직종 칸이 눌려 「김:」 처럼 잘린다**(2026-09-08 실측).
       표 폭을 내용대로 두고(min-width) 두 열은 왼쪽에 붙여 둔다 — 가로로 밀어도 누구 줄인지 남아야 한다. --%>
  #qpsDuty table.dt{ border-collapse:separate; border-spacing:0; width:100%; min-width:1240px; }
  #qpsDuty table.dt th, #qpsDuty table.dt td{ border:1px solid #e3e9ed; border-width:0 1px 1px 0; padding:2px 3px;
      font-size:12px; text-align:center; background:#fff; }
  #qpsDuty table.dt thead th{ background:#f7fafb; color:#43555f; font-weight:700; white-space:nowrap;
      position:sticky; top:0; z-index:3; border-top:1px solid #e3e9ed; }
  #qpsDuty table.dt th:first-child, #qpsDuty table.dt td:first-child{ position:sticky; left:0; z-index:2; }
  #qpsDuty table.dt th:nth-child(2), #qpsDuty table.dt td:nth-child(2){ position:sticky; left:110px; z-index:2;
      box-shadow:1px 0 0 #e3e9ed; }
  #qpsDuty table.dt thead th:first-child, #qpsDuty table.dt thead th:nth-child(2){ z-index:4; }
  #qpsDuty table.dt tfoot th:first-child{ z-index:2; }
  #qpsDuty table.dt td[data-sum], #qpsDuty table.dt th:nth-last-child(-n+2){ white-space:nowrap; }
  #qpsDuty table.dt th.sat, #qpsDuty table.dt th.sat span{ color:#2f6fb0; }
  #qpsDuty table.dt th.sun, #qpsDuty table.dt th.hol, #qpsDuty table.dt th.sun span, #qpsDuty table.dt th.hol span{ color:#b5443c; }
  #qpsDuty table.dt th.hol{ border-bottom:2px dotted #b5443c; }
  #qpsDuty table.dt td.off{ background:#fbf3f3; }
  #qpsDuty table.dt td.satc{ background:#f3f7fb; }
  #qpsDuty .nmc{ width:110px; min-width:110px; max-width:110px; } #qpsDuty .jobc{ width:86px; min-width:86px; max-width:86px; }
  #qpsDuty table.dt td.nmc, #qpsDuty table.dt td.jobc{ text-align:left; }
  #qpsDuty input.dnm, #qpsDuty input.djob{ width:100%; border:0; padding:3px 4px; font-size:12px; background:transparent; }
  #qpsDuty input.dc{ width:26px; border:0; padding:2px 0; text-align:center; font-size:12px; background:transparent;
      text-transform:uppercase; font-weight:600; color:#1f5a4b; }
  #qpsDuty input.dc:focus, #qpsDuty input.dnm:focus, #qpsDuty input.djob:focus{ outline:2px solid #9fc4e6; background:#fff; }
  #qpsDuty td.sumc{ font-weight:700; color:#20303a; background:#f7fafb; }
  #qpsDuty .rowbtn{ border:0; background:transparent; color:#8a99a3; cursor:pointer; font-size:13px; line-height:1; padding:1px 3px; }
  #qpsDuty .rowbtn:hover{ color:#b5443c; }
  #qpsDuty .dt-empty{ color:#8a99a3; font-size:12.5px; padding:14px; text-align:center; }
  #qpsDuty .dt-lock{ background:#fdecea; border:1px solid #f0c4bd; color:#b5443c; border-radius:6px; padding:4px 10px; font-size:12.5px; }
  #qpsDuty .dt-stat{ font-size:12px; color:#6b7c86; }
  #qpsDuty table.dt tfoot th, #qpsDuty table.dt tfoot td{ background:#f7fafb; font-size:11.5px; color:#43555f; }
</style>

<div class="dt-head">
  <div class="dt-title"><span class="dt-dot"></span>근무표
    <span class="dt-sub">부서·병동마다 <b>한 달 근무</b>를 적습니다 — 점검표 일괄 사인이 이것을 읽습니다</span></div>
  <div class="dt-spacer"></div>
</div>

<div class="dt-note">
  ★<b>적어 두면 점검표 사인이 「그날 근무자」로 채워집니다</b> — 점검표 작성 화면의 [✍ 일괄 사인]에서 고릅니다.<br>
  · 근무 기호는 <b>공통코드(QPS_DUTY_SHIFT)</b>입니다 — 병원마다 다르면 [관리(설정) ▸ 기준코드 ▸ 공통코드]에서 고칩니다.<br>
  · <b>휴무·휴가·대체휴무(O·V·R)는 근무자가 아닙니다</b> — 그날 사인 후보에서 빠집니다.<br>
  · 같은 날 여럿이면 <b>이 표에 적은 차례</b>(위에서부터)로 첫 사람이 뽑힙니다 — ↑↓ 로 차례를 바꿉니다.
</div>

<div class="dt-bar">
  <b>부서</b><select id="dtDept" onchange="dtDeptChange();" style="min-width:130px;"></select>
  <b>연월</b>
  <select id="dtYear" onchange="dtLoad();" style="width:88px;"></select>
  <select id="dtMm" onchange="dtLoad();" style="width:70px;"></select>
  <b>병동·근무조</b>
  <input type="text" id="dtWard" list="dtWardList" style="width:130px;" placeholder="(안 나누면 비움)" onchange="dtLoad();">
  <datalist id="dtWardList"></datalist>
  <span class="dt-stat" id="dtInfo"></span>
  <div class="dt-spacer"></div>
  <span id="dtLockBox"></span>
  <%-- ⚠저장 단추는 **띠 안**에 둔다 — 화면 오른쪽 위는 고정 요소(자주 쓰는 메뉴·문의 단추)가 덮는다(2026-09-08). --%>
  <button type="button" class="dt-btn ghost mini" onclick="dtPrint();">🖨 인쇄</button>
  <button type="button" class="dt-btn" id="dtSaveBtn" onclick="dtSave();">저장</button>
</div>

<div class="dt-tools">
  <b>사람</b>
  <select id="dtUser" style="min-width:170px;"><option value="">— 사람 고르기 —</option></select>
  <button type="button" class="dt-btn ghost mini" onclick="dtAddBlank();">+ 빈 줄</button>
  <a href="/main/qpsSigner.do" class="dt-sub" style="color:#1f5a4b; font-weight:600;" title="계정 없는 직원도 인사 등록에 올리면 고를 수 있고, 사인을 그려 두면 사인 칸에 그림이 붙습니다. 퇴사일이 지난 사람은 빠집니다">인사 등록 →</a>
  <span class="dt-sub">|</span>
  <button type="button" class="dt-btn ghost mini" onclick="dtPrev('rows');">전월 사람 가져오기</button>
  <button type="button" class="dt-btn ghost mini" onclick="dtPrev('all');">전월 통째 복사</button>
  <span class="dt-sub">|</span>
  <b>기호 붓</b><span class="dt-pal" id="dtPal"></span>
  <span class="dt-sub">|</span>
  <b>반복 패턴</b><input type="text" id="dtPat" style="width:120px;" placeholder="예: DDNNOO" title="줄 오른쪽 [패턴] 을 누르면 1일부터 이 순서로 되풀이해 채웁니다">
  <div class="dt-spacer"></div>
  <span class="dt-stat" id="dtStat"></span>
</div>

<div class="dt-card">
  <table class="dt">
    <thead id="dtHead"></thead>
    <tbody id="dtBody"><tr><td class="dt-empty" colspan="40">부서를 고르세요.</td></tr></tbody>
    <tfoot id="dtFoot"></tfoot>
  </table>
</div>

</div>
</div>

<script>
(function(){
  var DEPTS = [], SHIFTS = [], USERS = [], SIGNERS = [], WARDS = [], HOLS = {}, LOCK = 'N', HAS = false;
  /* ★붓은 **처음엔 안 들려 있다**(null) — '' 로 두면 지우개를 든 채로 시작해 칸을 누르면 값이 지워진다. */
  var BRUSH = null, PAINT = false, LOAD_REQ = 0;

  function gel(id){ return document.getElementById(id); }
  function val(id){ var e = gel(id); return e ? e.value : ''; }
  function esc(s){ return String(s == null ? '' : s).replace(/[&<>"']/g, function(c){
    return ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'})[c]; }); }
  function err(e){ _alertBox((e && e.message) ? e.message : '처리 중 오류가 발생했습니다.', {icon:'❌'}); }
  function toast(t, k){ if (window._toast) { _toast(t, k || 'ok'); return; } _alertBox(t, {icon:'✅'}); }
  function ask(html, opts){
    return new Promise(function(res){
      _confirmBox({ msg:html, icon:(opts && opts.icon) || '❓', okText:(opts && opts.okText) || '예',
                    okColor:(opts && opts.okColor), onOk:function(){ res(true); }, onCancel:function(){ res(false); } });
    });
  }
  function post(url, data){
    return new Promise(function(res, rej){
      $.post(url, data, function(r){ if (r && r.result === 'OK') res(r); else rej(new Error((r && r.message) || '실패')); }, 'json')
       .fail(function(){ rej(new Error('서버에 연결하지 못했습니다.')); });
    });
  }
  function ym(){ return val('dtYear') + '-' + val('dtMm'); }
  function daysIn(){ var y = Number(val('dtYear')), m = Number(val('dtMm')); return new Date(y, m, 0).getDate(); }
  function dow(d){ return new Date(Number(val('dtYear')), Number(val('dtMm')) - 1, d).getDay(); }   // 0=일
  function holKey(d){ return val('dtMm') + ('0' + d).slice(-2); }
  function isHol(d){ var h = HOLS[val('dtYear')]; return !!(h && h[holKey(d)]); }
  function holNm(d){ var h = HOLS[val('dtYear')]; return (h && h[holKey(d)]) || ''; }
  /** 쉬는 기호인가 — 근무자로 세지 않는다(서버 selectDutyDayNames 와 같은 목록). */
  function isOff(cd){ return ['O','V','R'].indexOf(String(cd || '').toUpperCase()) >= 0; }

  // ---------- 기준자료 ----------
  function fillYm(){
    var y = gel('dtYear'), m = gel('dtMm');
    if (y.options.length) return;
    var now = new Date(), cy = now.getFullYear();
    for (var i = cy + 1; i >= cy - 3; i--) y.add(new Option(i + '년', String(i)));
    for (var k = 1; k <= 12; k++) m.add(new Option(k + '월', ('0' + k).slice(-2)));
    y.value = String(cy); m.value = ('0' + (now.getMonth() + 1)).slice(-2);
  }
  function fillHols(){
    var y = val('dtYear');
    if (HOLS[y]) return Promise.resolve(HOLS[y]);
    return post('<c:url value="/qps/holidayList.do"/>', { year: y }).then(function(res){
      var m = {};
      (res.list || []).forEach(function(h){ var d = String(h.holdt || ''); if (d.length === 8) m[d.slice(4)] = h.holnm || ''; });
      HOLS[y] = m; return m;
    }, function(){ HOLS[y] = {}; return HOLS[y]; });   // 옛 서버(엔드포인트 없음)면 공휴일 없이 간다
  }
  function palPaint(){
    gel('dtPal').innerHTML =
      '<button type="button" data-cd="" title="지우개 — 칸을 비웁니다">지움</button>' +
      SHIFTS.map(function(s){
        return '<button type="button" data-cd="' + esc(s.subcode) + '" title="' + esc(s.subcodenm) + '">' + esc(s.subcode) + '</button>';
      }).join('');
    palOn();
  }
  function palOn(){
    [].forEach.call(gel('dtPal').querySelectorAll('button'), function(b){
      b.classList.toggle('on', BRUSH !== null && b.getAttribute('data-cd') === BRUSH);
    });
  }
  function shiftNm(cd){
    for (var i = 0; i < SHIFTS.length; i++) if (SHIFTS[i].subcode === String(cd).toUpperCase()) return SHIFTS[i].subcodenm;
    return '';
  }

  // ---------- 조회 ----------
  window.dtDeptChange = function(){ gel('dtWard').value = ''; return dtLoad(); };

  window.dtLoad = function(){
    var my = ++LOAD_REQ;                                  // ★순번 가드 — 늦게 온 옛 응답이 새 달을 덮지 않게
    var d = val('dtDept');
    return fillHols().then(function(){
      return post('<c:url value="/qps/dutyGet.do"/>', { deptCd: d, wardNm: val('dtWard'), dutyYm: ym() });
    }).then(function(res){
      if (my !== LOAD_REQ) return;
      DEPTS = res.dept || DEPTS; SHIFTS = res.shifts || SHIFTS; USERS = res.users || USERS;
      WARDS = res.wards || [];
      if (!gel('dtDept').options.length) {
        gel('dtDept').innerHTML = DEPTS.map(function(x){
          return '<option value="' + esc(x.subcode) + '">' + esc(x.subcodenm) + '</option>'; }).join('');
        if (!DEPTS.length) gel('dtDept').innerHTML = '<option value="">(부서 없음)</option>';
      }
      /* ★사람 콤보 = **인사 등록 직원**(관리(설정) ▸ 인사 등록 · 사인·도장, 퇴직자 제외)이 먼저, 명단에 없는 계정 직원이 그 뒤(2026-09-09).
         계정 없는 간호사·조무사도 명단에 올리면 여기서 고를 수 있고, 사인 그림이 있으면 그날 근무자 사인에 그림이 붙는다. */
      SIGNERS = res.signers || SIGNERS;
      if (!gel('dtUser').options.length || gel('dtUser').options.length === 1) {
        var inS = {};
        var g1 = SIGNERS.map(function(s){ inS[s.userid] = 1;
          return '<option value="' + esc(s.userid) + '">' + esc(s.usernm || s.userid) + (s.jobnm ? (' · ' + esc(s.jobnm)) : '') +
                 (s.hasimg === 'Y' ? ' ✎' : '') + '</option>'; }).join('');
        var g2 = USERS.filter(function(u){ return !inS[u.userid]; }).map(function(u){
          return '<option value="' + esc(u.userid) + '">' + esc(u.usernm || u.userid) + '</option>'; }).join('');
        gel('dtUser').innerHTML = '<option value="">— 사람 고르기 —</option>' +
          (g1 ? ('<optgroup label="인사 등록 직원 (✎ = 사인 있음)">' + g1 + '</optgroup>') : '') +
          (g2 ? ('<optgroup label="계정 직원 (명단에 없음)">' + g2 + '</optgroup>') : '');
      }
      if (!gel('dtPal').children.length) palPaint();
      gel('dtWardList').innerHTML = WARDS.map(function(w){ return '<option value="' + esc(w) + '"></option>'; }).join('');

      var head = res.duty || null;
      HAS = !!head; LOCK = head ? String(head.lockyn || 'N') : 'N';
      dtHeadPaint();
      dtRowsPaint(res.rows || [], res.vals || []);
      dtLockPaint(head);
      gel('dtInfo').textContent = head
        ? ('저장됨 · 마지막 수정 ' + (head.upddttm || '') + ' ' + (head.upduser || ''))
        : '아직 저장 전입니다.';
      dtSum();
    }).catch(function(e){ if (my === LOAD_REQ) err(e); });
  };

  function dtLockPaint(head){
    var b = gel('dtLockBox');
    if (!HAS) { b.innerHTML = ''; gel('dtSaveBtn').textContent = '저장'; return; }
    if (LOCK === 'Y') {
      b.innerHTML = '<span class="dt-lock">🔒 마감됨 ' + esc((head && head.lockdttm) || '') + '</span> ' +
                    '<button type="button" class="dt-btn ghost mini" onclick="dtLock(\'N\');">마감 풀기</button>';
      gel('dtSaveBtn').textContent = '마감됨';
    } else {
      b.innerHTML = '<button type="button" class="dt-btn ghost mini" onclick="dtLock(\'Y\');">🔒 마감</button>';
      gel('dtSaveBtn').textContent = '저장';
    }
  }

  // ---------- 격자 ----------
  function dtHeadPaint(){
    var last = daysIn(), h = '<tr><th class="nmc">성명</th><th class="jobc">직종</th>';
    for (var d = 1; d <= last; d++) {
      var w = dow(d), cls = isHol(d) ? 'hol' : (w === 0 ? 'sun' : (w === 6 ? 'sat' : ''));
      var wd = ['일','월','화','수','목','금','토'][w];
      h += '<th class="' + cls + '"' + (isHol(d) ? (' title="' + esc(holNm(d)) + '"') : '') + '>' +
           d + '<br><span style="font-size:10px;font-weight:500;">' + wd + '</span></th>';
    }
    h += '<th style="width:44px;">근무</th><th style="width:62px;">차례</th></tr>';
    gel('dtHead').innerHTML = h;
  }

  function rowHtml(r, vmap){
    var last = daysIn(), rn = r.rowno;
    var h = '<tr data-rn="' + rn + '" data-uid="' + esc(r.userid || '') + '">' +
            '<td class="nmc"><input class="dnm" data-f="usernm" value="' + esc(r.usernm || '') + '"></td>' +
            '<td class="jobc"><input class="djob" data-f="jobnm" value="' + esc(r.jobnm || '') + '"></td>';
    for (var d = 1; d <= last; d++) {
      var w = dow(d), cls = isHol(d) ? 'off' : (w === 0 ? 'off' : (w === 6 ? 'satc' : ''));
      var v = vmap[rn + '_' + d] || '';
      h += '<td class="' + cls + '"><input class="dc" data-rn="' + rn + '" data-d="' + d + '" maxlength="3" value="' + esc(v) + '"></td>';
    }
    h += '<td class="sumc" data-sum="' + rn + '">0</td>' +
         '<td><button type="button" class="rowbtn" title="위로" onclick="dtMove(this,-1);">▲</button>' +
             '<button type="button" class="rowbtn" title="아래로" onclick="dtMove(this,1);">▼</button>' +
             '<button type="button" class="rowbtn" title="반복 패턴 채우기" onclick="dtPatRow(this);">✎</button>' +
             '<button type="button" class="rowbtn" title="이 줄 지우기" onclick="dtDelRow(this);">✕</button></td></tr>';
    return h;
  }

  function dtRowsPaint(rows, vals){
    var vmap = {};
    (vals || []).forEach(function(v){ vmap[v.rowno + '_' + v.dayno] = v.shiftcd; });
    if (!rows.length) {
      gel('dtBody').innerHTML = '<tr><td class="dt-empty" colspan="' + (daysIn() + 4) + '">' +
        '아직 사람이 없습니다 — 위에서 <b>직원을 고르거나</b> [+ 빈 줄]을 누르세요.' +
        (HAS ? '' : ' 전월 근무표가 있으면 [전월 사람 가져오기]가 빠릅니다.') + '</td></tr>';
    } else {
      gel('dtBody').innerHTML = rows.map(function(r){ return rowHtml(r, vmap); }).join('');
    }
    dtReadonly();
  }

  /** 마감이면 손대지 못하게 — 값은 그대로 보여 준다(감추면 「사라졌다」가 된다). */
  function dtReadonly(){
    var ro = (LOCK === 'Y');
    [].forEach.call(gel('dtBody').querySelectorAll('input'), function(i){ i.readOnly = ro; });
    [].forEach.call(gel('dtBody').querySelectorAll('.rowbtn'), function(b){ b.disabled = ro; b.style.opacity = ro ? .35 : 1; });
  }

  function nextRowNo(){
    var mx = 0;
    [].forEach.call(gel('dtBody').querySelectorAll('tr[data-rn]'), function(tr){
      mx = Math.max(mx, Number(tr.getAttribute('data-rn')) || 0); });
    return mx + 1;
  }
  function addRow(uid, nm, job){
    var body = gel('dtBody');
    if (!body.querySelector('tr[data-rn]')) body.innerHTML = '';
    var tmp = document.createElement('tbody');
    tmp.innerHTML = rowHtml({ rowno: nextRowNo(), userid: uid || '', usernm: nm || '', jobnm: job || '' }, {});
    body.appendChild(tmp.firstChild);
    dtReadonly(); dtSum();
  }
  window.dtAddBlank = function(){
    if (lockGuard()) return;
    var uid = val('dtUser');
    if (uid) {
      var nm = '', job = '';
      /* 담당자 명단이 먼저(직종까지 따라온다) — 없으면 계정 직원 */
      for (var s = 0; s < SIGNERS.length; s++) if (SIGNERS[s].userid === uid) { nm = SIGNERS[s].usernm || uid; job = SIGNERS[s].jobnm || ''; }
      if (!nm) for (var i = 0; i < USERS.length; i++) if (USERS[i].userid === uid) nm = USERS[i].usernm || uid;
      if (dupUser(uid)) { _alertBox('<b>' + esc(nm) + '</b> 님은 이미 표에 있습니다.', {icon:'ℹ️'}); return; }
      addRow(uid, nm, job);
      gel('dtUser').value = '';
      return;
    }
    addRow('', '', '');
  };
  function dupUser(uid){
    var f = false;
    [].forEach.call(gel('dtBody').querySelectorAll('tr[data-rn]'), function(tr){
      if (tr.getAttribute('data-uid') === uid) f = true; });
    return f;
  }
  window.dtDelRow = function(btn){
    if (lockGuard()) return;
    var tr = btn.closest('tr'); if (!tr) return;
    tr.parentNode.removeChild(tr);
    if (!gel('dtBody').querySelector('tr[data-rn]')) dtRowsPaint([], []);
    dtSum();
  };
  window.dtMove = function(btn, dir){
    if (lockGuard()) return;
    var tr = btn.closest('tr'); if (!tr) return;
    if (dir < 0 && tr.previousElementSibling) tr.parentNode.insertBefore(tr, tr.previousElementSibling);
    if (dir > 0 && tr.nextElementSibling) tr.parentNode.insertBefore(tr.nextElementSibling, tr);
  };

  /** 반복 패턴 — 1일부터 되풀이해 채운다. ★빈 칸만이 아니라 **그 줄을 다시 짠다**(패턴은 덮어쓰는 것이 뜻이다). */
  window.dtPatRow = function(btn){
    if (lockGuard()) return;
    var pat = String(val('dtPat') || '').toUpperCase().replace(/[\s,]/g, '');
    if (!pat) { _alertBox('위 <b>반복 패턴</b> 칸에 기호를 적으세요.<br><span style="color:#6b7c86;font-size:12px;">예: <b>DDNNOO</b> — 주간·주간·야간·야간·휴무·휴무를 되풀이합니다.</span>', {icon:'ℹ️'}); return; }
    var tr = btn.closest('tr'); if (!tr) return;
    var cells = tr.querySelectorAll('input.dc');
    [].forEach.call(cells, function(c, i){ c.value = pat.charAt(i % pat.length); });
    dtSum();
  };

  // ---------- 붓·입력 ----------
  gel('dtPal').addEventListener('click', function(ev){
    var b = ev.target.closest ? ev.target.closest('button') : null;
    if (!b) return;
    var cd = b.getAttribute('data-cd');
    BRUSH = (BRUSH === cd) ? null : cd;                 // 다시 누르면 붓을 내린다
    palOn();
    gel('dtStat').textContent = (BRUSH === null) ? '' :
      (BRUSH ? ('붓: ' + BRUSH + (shiftNm(BRUSH) ? ' (' + shiftNm(BRUSH) + ')' : '') + ' — 칸을 눌러 칠합니다')
             : '붓: 지움 — 칸을 눌러 비웁니다');
  });
  /** 붓이 들려 있으면 칸을 눌러(끌어) 칠한다 — 근무표는 같은 기호를 여럿에 넣는 일이 대부분이다. */
  gel('dtBody').addEventListener('mousedown', function(ev){
    var t = ev.target;
    if (!t.classList || !t.classList.contains('dc') || BRUSH === null || LOCK === 'Y') return;
    PAINT = true; t.value = BRUSH; dtSum(); ev.preventDefault();
  });
  gel('dtBody').addEventListener('mouseover', function(ev){
    var t = ev.target;
    if (!PAINT || !t.classList || !t.classList.contains('dc') || BRUSH === null) return;
    t.value = BRUSH; dtSum();
  });
  document.addEventListener('mouseup', function(){ PAINT = false; });
  /** 더블클릭 = 기호 돌려가며 넣기(빈→D→E→N→…→빈). 붓을 안 들었을 때 쓰는 길. */
  gel('dtBody').addEventListener('dblclick', function(ev){
    var t = ev.target;
    if (!t.classList || !t.classList.contains('dc') || LOCK === 'Y') return;
    var cur = String(t.value || '').toUpperCase(), list = SHIFTS.map(function(s){ return s.subcode; });
    var i = list.indexOf(cur);
    t.value = (i < 0) ? (list[0] || '') : ((i + 1 >= list.length) ? '' : list[i + 1]);
    dtSum();
  });
  gel('dtBody').addEventListener('input', function(ev){
    var t = ev.target;
    if (!t.classList) return;
    if (t.classList.contains('dc')) {
      t.value = String(t.value || '').toUpperCase();
      dtSum();
    }
  });
  /** Enter·→ = 오른쪽 칸으로, ← = 왼쪽 칸으로(점검표 격자와 같은 손버릇). */
  gel('dtBody').addEventListener('keydown', function(ev){
    var t = ev.target;
    if (!t.classList || !t.classList.contains('dc')) return;
    var move = 0;
    if (ev.key === 'Enter' || ev.key === 'ArrowRight') move = 1;
    else if (ev.key === 'ArrowLeft') move = -1;
    else if (ev.key === 'ArrowDown') move = 100;
    else if (ev.key === 'ArrowUp') move = -100;
    if (!move) return;
    ev.preventDefault();
    var rn = Number(t.getAttribute('data-rn')), d = Number(t.getAttribute('data-d')), to;
    if (Math.abs(move) === 100) to = nextRowCell(t, move > 0 ? 1 : -1, d);
    else to = gel('dtBody').querySelector('input.dc[data-rn="' + rn + '"][data-d="' + (d + move) + '"]');
    if (to) { to.focus(); to.select(); }
  });
  function nextRowCell(el, dir, d){
    var tr = el.closest('tr');
    var nx = (dir > 0) ? tr.nextElementSibling : tr.previousElementSibling;
    return nx ? nx.querySelector('input.dc[data-d="' + d + '"]') : null;
  }

  // ---------- 합계 ----------
  function dtSum(){
    var last = daysIn(), perDay = {};
    [].forEach.call(gel('dtBody').querySelectorAll('tr[data-rn]'), function(tr){
      var n = 0;
      [].forEach.call(tr.querySelectorAll('input.dc'), function(c){
        var v = String(c.value || '').trim().toUpperCase();
        if (!v || isOff(v)) return;
        n++; var d = c.getAttribute('data-d'); perDay[d] = (perDay[d] || 0) + 1;
      });
      var s = tr.querySelector('td[data-sum]');
      if (s) s.textContent = n;
    });
    var h = '<tr><th colspan="2">그날 근무 인원</th>';
    for (var d = 1; d <= last; d++) h += '<td>' + (perDay[d] || '') + '</td>';
    h += '<th></th><th></th></tr>';
    gel('dtFoot').innerHTML = gel('dtBody').querySelector('tr[data-rn]') ? h : '';
  }

  // ---------- 저장·마감 ----------
  function lockGuard(){
    if (LOCK !== 'Y') return false;
    _alertBox('이 근무표는 <b>마감</b>되었습니다.<br>고치려면 위 [마감 풀기]를 먼저 누르세요.', {icon:'🔒'});
    return true;
  }
  function collect(){
    var rows = [], vals = [], no = 0;
    [].forEach.call(gel('dtBody').querySelectorAll('tr[data-rn]'), function(tr){
      var rn = Number(tr.getAttribute('data-rn'));
      var nm = String((tr.querySelector('input[data-f=usernm]') || {}).value || '').trim();
      if (!nm) return;                                   // 이름 없는 줄은 저장하지 않는다
      no++;
      rows.push({ rowNo: rn, userId: tr.getAttribute('data-uid') || '', userNm: nm,
                  jobNm: String((tr.querySelector('input[data-f=jobnm]') || {}).value || '').trim(),
                  sortNo: no });                          // ★차례 = 화면에 보이는 순서(사인 매치가 이 순서로 고른다)
      [].forEach.call(tr.querySelectorAll('input.dc'), function(c){
        var v = String(c.value || '').trim().toUpperCase();
        if (!v) return;
        vals.push({ rowNo: rn, dayNo: Number(c.getAttribute('data-d')), shiftCd: v });
      });
    });
    return { rows: rows, vals: vals };
  }
  window.dtSave = function(){
    if (lockGuard()) return;
    if (!val('dtDept')) { _alertBox('부서를 고르세요.', {icon:'⚠️'}); return; }
    var c = collect();
    if (!c.rows.length) { _alertBox('저장할 사람이 없습니다.<br><span style="color:#6b7c86;font-size:12px;">직원을 고르거나 [+ 빈 줄]로 이름을 적으세요.</span>', {icon:'⚠️'}); return; }
    /* ★모르는 기호가 있으면 미리 알린다 — 저장은 막지 않는다(병원이 제 기호를 쓸 수 있다). */
    var known = {}, unknown = {};
    SHIFTS.forEach(function(s){ known[s.subcode] = 1; });
    c.vals.forEach(function(v){ if (!known[v.shiftCd]) unknown[v.shiftCd] = 1; });
    var uk = Object.keys(unknown);
    var go = function(){
      post('<c:url value="/qps/dutySave.do"/>', {
        deptCd: val('dtDept'), wardNm: val('dtWard'), dutyYm: ym(),
        rows: JSON.stringify(c.rows), vals: JSON.stringify(c.vals)
      }).then(function(){
        toast(c.rows.length + '명 · 근무 ' + c.vals.length + '칸을 저장했습니다.', 'ok');
        dtLoad();
      }).catch(err);
    };
    if (uk.length) {
      ask('공통코드에 없는 기호가 있습니다 — <b>' + esc(uk.join(', ')) + '</b><br><br>' +
          '<span style="color:#6b7c86;font-size:12px;">그대로 저장해도 됩니다. 다만 <b>사인 매치</b>에서는 ' +
          '휴무 기호(O·V·R)가 아닌 것은 모두 <b>근무</b>로 봅니다.</span>',
          { icon:'⚠️', okText:'그대로 저장' }).then(function(ok){ if (ok) go(); });
      return;
    }
    go();
  };

  window.dtLock = function(y){
    var on = (y === 'Y');
    ask(on ? '이 근무표를 <b>마감</b>할까요?<br><span style="color:#6b7c86;font-size:12px;">마감하면 고칠 수 없습니다(풀 수 있습니다).</span>'
           : '<b>마감을 풀까요?</b>',
        { icon: on ? '🔒' : '🔓', okText: on ? '마감' : '마감 풀기' }).then(function(ok){
      if (!ok) return;
      post('<c:url value="/qps/dutyLock.do"/>', { deptCd: val('dtDept'), wardNm: val('dtWard'), dutyYm: ym(), lockYn: y })
        .then(function(){ toast(on ? '마감했습니다.' : '마감을 풀었습니다.', 'ok'); dtLoad(); }).catch(err);
    });
  };

  /**
   * 전월에서 가져오기 — 원본 SUNWOO 에는 없다(사용자 「더 효율적으로」).
   *   mode 'rows' = 사람 줄만(근무는 달마다 다르다) · 'all' = 근무 값까지 통째로.
   * ★지금 표에 사람이 있으면 **묻고 바꾼다** — 말없이 덮으면 적어 둔 것이 사라진다.
   */
  window.dtPrev = function(mode){
    if (lockGuard()) return;
    if (!val('dtDept')) { _alertBox('부서를 고르세요.', {icon:'⚠️'}); return; }
    var y = Number(val('dtYear')), m = Number(val('dtMm'));
    var py = (m === 1) ? (y - 1) : y, pm = (m === 1) ? 12 : (m - 1);
    var pym = py + '-' + ('0' + pm).slice(-2);
    var has = !!gel('dtBody').querySelector('tr[data-rn]');
    var run = function(){
      /* ★★순번을 올려 **날아가던 조회 응답을 버린다** — 저장 직후의 재조회가 늦게 오면
         방금 가져온 전월 명단을 서버의 빈 달로 덮어쓴다(시뮬에서 실제로 잡았다). */
      LOAD_REQ++;
      post('<c:url value="/qps/dutyGet.do"/>', { deptCd: val('dtDept'), wardNm: val('dtWard'), dutyYm: pym })
        .then(function(res){
          var rows = res.rows || [];
          if (!rows.length) { _alertBox('<b>' + esc(pym) + '</b> 근무표가 없습니다.', {icon:'ℹ️'}); return; }
          dtRowsPaint(rows, (mode === 'all') ? (res.vals || []) : []);
          dtSum();
          toast(pym + ' 에서 ' + rows.length + '명' + (mode === 'all' ? '과 근무를' : '을') + ' 가져왔습니다. 확인 후 [저장]을 누르세요.', 'ok');
        }).catch(err);
    };
    if (!has) { run(); return; }
    ask('지금 표의 <b>사람과 근무가 전월 것으로 바뀝니다.</b><br>' +
        '<span style="color:#6b7c86;font-size:12px;">아직 저장하지 않은 것은 사라집니다. 저장 전이라 되돌리려면 다시 [저장]하지 말고 화면을 다시 불러오세요.</span>',
        { icon:'⚠️', okText:'가져오기' }).then(function(ok){ if (ok) run(); });
  };

  // ---------- 인쇄 ----------
  window.dtPrint = function(){
    var last = daysIn();
    var head = '<tr><th>성명</th><th>직종</th>';
    for (var d = 1; d <= last; d++) {
      var w = dow(d), cls = (isHol(d) || w === 0) ? ' class="sun"' : (w === 6 ? ' class="sat"' : '');
      head += '<th' + cls + '>' + d + '<br>' + ['일','월','화','수','목','금','토'][w] + '</th>';
    }
    head += '<th>근무</th></tr>';
    var body = '';
    [].forEach.call(gel('dtBody').querySelectorAll('tr[data-rn]'), function(tr){
      var nm = String((tr.querySelector('input[data-f=usernm]') || {}).value || '').trim();
      if (!nm) return;
      body += '<tr><td>' + esc(nm) + '</td><td>' + esc(String((tr.querySelector('input[data-f=jobnm]') || {}).value || '')) + '</td>';
      [].forEach.call(tr.querySelectorAll('input.dc'), function(c){ body += '<td>' + esc(String(c.value || '')) + '</td>'; });
      body += '<td>' + esc((tr.querySelector('td[data-sum]') || {}).textContent || '') + '</td></tr>';
    });
    if (!body) { _alertBox('인쇄할 근무표가 없습니다.', {icon:'ℹ️'}); return; }
    /* ★바닥의 「그날 근무 인원」도 종이에 싣는다 — 근무표를 눈으로 볼 때 제일 먼저 세는 줄이다 */
    var foot = gel('dtFoot').querySelector('tr');
    if (foot) {
      body += '<tr>' + [].map.call(foot.children, function(c, i){
        return '<th' + (i === 0 ? ' colspan="2"' : '') + '>' + esc(c.textContent.trim()) + '</th>';
      }).slice(0, last + 2).join('') + '</tr>';
    }
    var leg = SHIFTS.map(function(s){ return s.subcode + '=' + s.subcodenm; }).join(' · ');
    var css = 'body{font-family:"맑은 고딕",sans-serif;font-size:11px;margin:0;}' +
              'h1{font-size:16px;text-align:center;margin:0 0 6px;}' +
              '.meta{font-size:11px;text-align:center;margin:0 0 6px;}' +
              'table{width:100%;border-collapse:collapse;table-layout:fixed;}' +
              'th,td{border:1px solid #333;padding:2px 1px;text-align:center;font-size:9px;}' +
              'th{background:#eee;} th.sun{color:#b5443c;} th.sat{color:#2f6fb0;}' +
              'td:first-child,th:first-child{width:70px;} td:nth-child(2),th:nth-child(2){width:56px;}' +
              '.leg{font-size:9px;color:#333;margin-top:6px;}' +
              '@page{ size:A4 landscape; margin:9mm; }';
    var dnm = gel('dtDept').options[gel('dtDept').selectedIndex];
    qpsPrintOut('근무표', css,
      '<h1>근무표</h1>' +
      '<div class="meta">' + esc(dnm ? dnm.text : '') + (val('dtWard') ? (' · ' + esc(val('dtWard'))) : '') +
      ' · ' + esc(val('dtYear')) + '년 ' + Number(val('dtMm')) + '월</div>' +
      '<table>' + head + body + '</table>' +
      '<div class="leg">근무 기호 : ' + esc(leg) + ' (O·V·R 은 근무일수에서 뺍니다)</div>');
  };

  // ---------- 시작 ----------
  $(function(){
    fillYm();
    /* 첫 호출은 부서 목록을 받아 채우고, 그 부서로 한 번 더 읽는다(부서가 정해져야 근무표가 있다) */
    dtLoad().then(function(){
      if (val('dtDept')) return dtLoad();
    });
  });
})();
</script>
