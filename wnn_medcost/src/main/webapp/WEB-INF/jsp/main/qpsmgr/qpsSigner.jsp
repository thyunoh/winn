<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%-- qpsSigner.jsp — 인사 등록 · 사인·도장 (2026-09-09)

     왜 : 사용자 「담당자별 사인(작성해서) 및 도장 관리 필요함」 → 「인사등록도 필요함」.
          도장은 그동안 **로그인 계정 본인만**([🖋 내 도장], 결재란용) 등록할 수 있었다. 그런데 점검표 사인 칸에 이름이 오르는
          사람(근무표의 간호사·조무사)은 대개 **계정이 없다** — 그 사람의 사인 그림을 붙일 길이 없었고, 근무표 사람 콤보도 비었다.
          SUNWOO 는 이 자리에 「사원등록」(사용자코드·사용자명·부서·직책/직급·입사일 + 엑셀 불러오기)이 있었다.

     ── 설계 ─────────────────────────────────────────────────────────────
       · 새 표 없음 — TBL_QPS_SIGN(사람마다 한 장)을 **직원 표**로 넓혔다(사번·직종·직책/직급·부서·입사일·퇴사일·비고·차례).
         직원 표를 따로 두면 「사람」이 두 표에 갈려 근무표·사인·결재가 다른 사람을 가리킨다 — 한 사람 한 줄.
       · 계정이 있으면 그 계정이 USER_ID(결재란 도장과 **같은 줄**), 없으면 서버가 P+12자리를 만든다(ACCT_YN='N').
       · 격자 사인 칸의 도장은 **이름으로** 찾으므로(signNames) 여기서 그려 둔 사인이 종이에 저절로 붙는다.
       · 근무표(qpsDuty) 사람 콤보가 이 명단을 먼저 보여 준다. **퇴사일이 지난 사람은 콤보에서 빠지고** 이 화면도 「퇴사자 포함」을 켜야 보인다.
       · 여러 명은 엑셀에서 열을 복사해 **붙여넣기**로 한 번에(사원등록의 「엑셀 불러오기」 갈음 — 파일 업로드 없이).
     ★결재란(상단 결재 상자·서식 아래 결재란)은 그대로 **로그인 계정 본인만** 찍는다 — 이 화면은 결재를 대신 찍는 곳이 아니다.
     ★고치기 권한 = 자료실과 같은 규칙(서버 canEditLib : 위너넷 · QPS 담당자 · 담당자 없으면 병원관리자). 보기는 병원 전원.
       본인 사인은 종전대로 본인이 올리고 내릴 수 있다.
     ★주민번호·연락처·주소는 받지 않는다(개인정보 최소화).
     ★알림·확인은 ui-message 만(Swal 직접호출 금지). 사인 그리기 창은 qpsChk 의 [🖋 내 도장] 창과 같은 캔버스 규칙.
     ★주의: 이 파일 안에서 Deferred EL 표기(샵+중괄호) 금지 --%>

<script src="/asset/js/ui-message.js"></script>

<div class="dashboard-wrapper">
<div id="qpsSigner">
<style>
  #qpsSigner{ background:#f4f6f8; color:#1f2a30; min-height:100%; padding:14px 16px 60px; max-width:100%; overflow-x:hidden; }
  #qpsSigner *{ box-sizing:border-box; }
  #qpsSigner .sg-head{ display:flex; align-items:center; gap:10px; margin-bottom:10px; flex-wrap:wrap; }
  #qpsSigner .sg-title{ font-size:18px; font-weight:800; color:#20303a; display:flex; align-items:center; gap:8px; }
  #qpsSigner .sg-dot{ width:10px; height:10px; border-radius:50%; background:linear-gradient(135deg,#1f5a4b,#2a7665); }
  #qpsSigner .sg-sub{ font-size:12px; color:#6b7c86; }
  #qpsSigner .sg-spacer{ flex:1; }
  #qpsSigner select, #qpsSigner input[type=text], #qpsSigner input[type=date], #qpsSigner textarea{
      border:1px solid #cfd8e0; border-radius:5px; padding:4px 6px; font-family:inherit; font-size:12.5px; background:#fff; }
  #qpsSigner .sg-btn{ border:1px solid #1f5a4b; background:#1f5a4b; color:#fff; border-radius:6px;
      padding:6px 14px; font-size:13px; font-weight:600; cursor:pointer; white-space:nowrap; }
  #qpsSigner .sg-btn.ghost{ border-color:#cfd8e0; color:#43555f; background:#fff; font-weight:500; }
  #qpsSigner .sg-btn.mini{ padding:3px 10px; font-size:12px; }
  #qpsSigner .sg-btn.warn{ border-color:#e0b4b4; color:#b23b3b; background:#fff; }
  #qpsSigner .sg-note{ background:#f0f7f4; border:1px solid #cfe3da; border-radius:8px; padding:8px 12px;
      font-size:12.5px; color:#1f5a4b; line-height:1.6; margin-bottom:10px; }
  #qpsSigner .sg-bar{ background:#eef4fb; border:1px solid #b9cfe6; border-left:4px solid #2f6fb0;
      border-radius:8px; padding:10px 14px; margin-bottom:10px; display:flex; gap:8px; align-items:center; flex-wrap:wrap; font-size:13px; }
  #qpsSigner .sg-bar b{ color:#2f6fb0; }
  #qpsSigner .sg-bar label{ cursor:pointer; white-space:nowrap; }
  #qpsSigner .sg-form{ background:#fdf7ec; border:1px solid #e6d6b4; border-left:4px solid #c99a3a;
      border-radius:8px; padding:10px 14px; margin-bottom:10px; display:none; gap:8px 12px; align-items:center; flex-wrap:wrap; font-size:12.5px; }
  #qpsSigner .sg-form b{ color:#8a6d2f; }
  #qpsSigner .sg-form span{ white-space:nowrap; }
  #qpsSigner .sg-bulk{ background:#f3f0fa; border:1px solid #d3c9ea; border-left:4px solid #6b4fb3;
      border-radius:8px; padding:10px 14px; margin-bottom:10px; display:none; font-size:12.5px; }
  #qpsSigner .sg-bulk b{ color:#6b4fb3; }
  #qpsSigner .sg-bulk textarea{ width:100%; min-height:90px; font-family:Consolas,monospace; font-size:12px; margin:6px 0; }
  #qpsSigner .sg-bulk table{ min-width:0; }
  #qpsSigner .sg-bulk td.bad{ color:#b23b3b; }
  #qpsSigner .sg-emp{ background:#eef7f2; border:1px solid #bfdccd; border-left:4px solid #2a7665;
      border-radius:8px; padding:10px 14px; margin-bottom:10px; display:none; font-size:12.5px; }
  #qpsSigner .sg-emp b{ color:#2a7665; }
  #qpsSigner .sg-emp table{ min-width:0; }
  #qpsSigner .sg-emp tr.have td{ color:#a9b4bb; }
  #qpsSigner .sg-emp .box{ max-height:280px; overflow:auto; border:1px solid #dbe6df; border-radius:6px; background:#fff; }
  #qpsSigner .sg-card{ background:#fff; border:1px solid #e3e9ed; border-radius:10px; padding:10px 12px; overflow:auto; }
  #qpsSigner table{ border-collapse:collapse; width:100%; min-width:1080px; }
  #qpsSigner th, #qpsSigner td{ border-bottom:1px solid #eef2f5; padding:6px 8px; font-size:12.5px; text-align:left; vertical-align:middle; }
  #qpsSigner thead th{ background:#f7fafb; color:#43555f; font-weight:700; white-space:nowrap; border-bottom:1px solid #e3e9ed; position:sticky; top:0; }
  #qpsSigner td.no{ color:#8a99a3; font-size:11.5px; text-align:right; width:40px; }
  #qpsSigner tr.ret td{ color:#9aa7ae; background:#fafbfc; }
  #qpsSigner .sg-nm{ font-weight:700; color:#20303a; }
  #qpsSigner tr.ret .sg-nm{ color:#8a99a3; text-decoration:line-through; }
  #qpsSigner .sg-acct{ font-size:11px; color:#2f6fb0; background:#eef4fb; border-radius:10px; padding:1px 7px; white-space:nowrap; }
  #qpsSigner .sg-noacct{ font-size:11px; color:#8a99a3; }
  #qpsSigner .sg-ret{ font-size:11px; color:#b23b3b; background:#fbeaea; border-radius:10px; padding:1px 7px; margin-left:4px; white-space:nowrap; }
  #qpsSigner .sg-thumb{ height:40px; max-width:120px; border:1px solid #eef2f5; border-radius:6px; background:#fff; padding:2px; }
  #qpsSigner .sg-empty{ color:#8a99a3; font-size:12px; }
  #qpsSigner .sg-btns{ display:flex; gap:4px; flex-wrap:wrap; }
  <%-- 사인 그리기 창 — qpsChk [🖋 내 도장] 창과 같은 모양. ui-message(10000) 아래에 둔다 --%>
  #qpsSigner .sg-signwrap{ position:fixed; inset:0; background:rgba(20,30,40,.45); z-index:9600;
      display:flex; align-items:center; justify-content:center; }
  #qpsSigner .sg-sign{ background:#fff; border-radius:14px; padding:16px 18px; width:440px; max-width:94vw;
      box-shadow:0 12px 40px rgba(0,0,0,.28); }
  #qpsSigner .sg-sign h4{ margin:0 0 6px; font-size:15px; color:#20303a; }
  #qpsSigner .sg-sign .desc{ font-size:11.5px; color:#8a99a3; line-height:1.6; margin-bottom:8px; }
  #qpsSigner .sg-sign canvas{ border:1px dashed #cfd8e0; border-radius:8px; background:#fff; touch-action:none;
      width:100%; height:130px; display:block; }
  #qpsSigner .sg-sign .now{ border:1px solid #e3e9ed; border-radius:8px; padding:6px; text-align:center; margin-bottom:8px; }
  #qpsSigner .sg-sign .now img{ max-height:60px; max-width:100%; }
  #qpsSigner .sg-sign .btns{ display:flex; gap:6px; justify-content:flex-end; margin-top:10px; flex-wrap:wrap; }
</style>

<div class="sg-head">
  <div class="sg-title"><span class="sg-dot"></span>인사 등록 · 사인·도장
    <span class="sg-sub">직원을 등록하고 <b>사인을 그려 두면</b> 근무표·점검표 사인 칸에 그 사람이 붙습니다</span></div>
  <div class="sg-spacer"></div>
</div>

<div class="sg-note">
  · 계정이 없는 직원도 올립니다. 이름은 <b>점검표에 적는 이름과 같게</b> — 사인 칸 도장은 이름으로 붙습니다. 퇴사일을 적으면 근무표에서 빠집니다.<br>
  <span id="sgPermNote">· 명단·사인 고치기는 <b>QPS 담당자·병원관리자</b>만(결재란은 본인이 [🖋 내 도장]으로).</span>
</div>

<div class="sg-bar">
  <b>부서</b>
  <select id="sgDept" onchange="sgLoad();" style="min-width:150px;"><option value="">전체</option></select>
  <b>찾기</b>
  <input type="text" id="sgFind" style="width:160px;" placeholder="이름·사번·직종·직책" oninput="sgPaint();">
  <label><input type="checkbox" id="sgRet" onchange="sgLoad();"> 퇴사자 포함</label>
  <span class="sg-sub" id="sgCnt"></span>
  <div class="sg-spacer"></div>
  <button type="button" class="sg-btn ghost" id="sgEmpBtn" onclick="sgEmpOpen();"
          title="차등제 인력 신고(면허등록)에 적어 둔 직원을 이름·직종·입사일째 가져옵니다">👩‍⚕️ 면허등록에서 가져오기</button>
  <button type="button" class="sg-btn ghost" id="sgBulkBtn" onclick="sgBulkOpen();">📋 여러 명 붙여넣기</button>
  <button type="button" class="sg-btn" id="sgAddBtn" onclick="sgFormOpen('');">+ 사람 추가</button>
</div>

<div class="sg-form" id="sgForm">
  <b id="sgFormTtl">새 사람</b>
  <span>이름 <input type="text" id="sgNm" style="width:110px;" maxlength="100"></span>
  <span>사번 <input type="text" id="sgEmp" style="width:90px;" maxlength="20"></span>
  <span>직종 <input type="text" id="sgJob" style="width:100px;" maxlength="50" placeholder="간호사·조무사…"></span>
  <span>직책/직급 <input type="text" id="sgPos" style="width:100px;" maxlength="50" placeholder="수간호사·팀장…"></span>
  <span>부서 <select id="sgFDept" style="min-width:130px;"><option value="">(없음)</option></select></span>
  <span id="sgAcctWrap">계정 잇기 <select id="sgAcct" style="min-width:150px;"><option value="">(계정 없음)</option></select></span>
  <span>입사일 <input type="date" id="sgJoin" style="width:140px;"></span>
  <span>퇴사일 <input type="date" id="sgRetire" style="width:140px;"></span>
  <span>차례 <input type="text" id="sgSort" style="width:50px;" value="0"></span>
  <span>비고 <input type="text" id="sgRemark" style="width:200px;" maxlength="200"></span>
  <div class="sg-spacer"></div>
  <button type="button" class="sg-btn" onclick="sgFormSave();">저장</button>
  <button type="button" class="sg-btn ghost mini" onclick="sgFormClose();">닫기</button>
</div>

<div class="sg-bulk" id="sgBulk">
  <b>📋 여러 명 붙여넣기</b> — 엑셀에서 <b>이름 · 사번 · 직종 · 직책/직급 · 부서 · 입사일</b> 순서의 열을 복사해 아래에 붙이세요(탭·쉼표 구분, 이름만 있어도 됩니다).
  첫 줄이 「이름」 같은 머리줄이면 저절로 건너뜁니다. 부서는 이름이나 코드 어느 쪽이든 됩니다. 계정 잇기·사인은 등록 뒤 줄마다.
  <textarea id="sgBulkTxt" placeholder="김간호	N001	간호사	수간호사	간호·병동	2024-03-01&#10;박조무	N002	조무사		간호·병동	2025-07-15" oninput="sgBulkParse();"></textarea>
  <div id="sgBulkPrev"></div>
  <div style="display:flex; gap:6px; margin-top:6px; align-items:center;">
    <span class="sg-sub" id="sgBulkCnt"></span>
    <div class="sg-spacer"></div>
    <button type="button" class="sg-btn" id="sgBulkGo" onclick="sgBulkSave();">등록</button>
    <button type="button" class="sg-btn ghost mini" onclick="sgBulkClose();">닫기</button>
  </div>
</div>

<div class="sg-emp" id="sgEmp">
  <b>👩‍⚕️ 면허등록에서 가져오기</b> — 차등제 <b>인력 신고(면허등록)</b>에 적어 둔 직원입니다. 고른 사람을 <b>이름·직종·입사일</b>째 인사 등록에 넣습니다.
  이미 등록된 이름은 <span style="color:#8a99a3;">회색</span>으로 빠집니다. 부서는 저 표에 없어 여기서 함께 정합니다(뒤에 줄마다 고쳐도 됩니다).
  <div style="display:flex; gap:8px; align-items:center; flex-wrap:wrap; margin:6px 0;">
    <label><input type="checkbox" id="sgEmpAll" onchange="sgEmpCheckAll();"> 전부 고르기</label>
    <span>부서 <select id="sgEmpDept" style="min-width:130px;"><option value="">(없음)</option></select></span>
    <label><input type="checkbox" id="sgEmpRet" onchange="sgEmpPaint();"> 퇴사일 지난 사람도</label>
    <span class="sg-sub" id="sgEmpCnt"></span>
  </div>
  <div id="sgEmpPrev"></div>
  <div style="display:flex; gap:6px; margin-top:6px; align-items:center;">
    <div class="sg-spacer"></div>
    <button type="button" class="sg-btn" id="sgEmpGo" onclick="sgEmpSave();">가져오기</button>
    <button type="button" class="sg-btn ghost mini" onclick="sgEmpClose();">닫기</button>
  </div>
</div>

<div class="sg-card">
  <table>
    <thead><tr>
      <th style="width:40px;">#</th><th>이름</th><th style="width:90px;">사번</th><th style="width:100px;">직종</th><th style="width:100px;">직책/직급</th>
      <th style="width:120px;">부서</th><th style="width:100px;">입사일</th><th style="width:100px;">퇴사일</th>
      <th style="width:130px;">계정</th><th style="width:140px;">사인·도장</th><th style="width:270px;"></th>
    </tr></thead>
    <tbody id="sgBody"><tr><td colspan="11" class="sg-empty">불러오는 중…</td></tr></tbody>
  </table>
</div>

</div>
</div>

<script>
(function(){
  var LIST = [], DEPTS = [], USERS = [], CAN = false, ME = '', LOAD_REQ = 0, BULK = [], EMP = [];
  var SIGN_CV = null, SIGN_CTX = null, SIGN_DRAWN = false, SIGN_FOR = null, SIGN_GB = 'S';

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
  function deptNm(cd){ for (var i = 0; i < DEPTS.length; i++) if (DEPTS[i].subcode === cd) return DEPTS[i].subcodenm; return cd || ''; }
  /** 부서 이름·코드 어느 쪽으로도 코드를 찾는다(붙여넣기용) — 빈 값 '' · 못 찾으면 null */
  function deptCdOf(s){
    s = String(s || '').trim(); if (!s) return '';
    for (var i = 0; i < DEPTS.length; i++) if (DEPTS[i].subcode === s || DEPTS[i].subcode === s.toUpperCase()) return DEPTS[i].subcode;
    for (var j = 0; j < DEPTS.length; j++) if (String(DEPTS[j].subcodenm || '').replace(/\s/g, '') === s.replace(/\s/g, '')) return DEPTS[j].subcode;
    return null;
  }
  function byId(uid){ for (var i = 0; i < LIST.length; i++) if (LIST[i].userid === uid) return LIST[i]; return null; }
  /** YYYYMMDD → yyyy-mm-dd (화면·date 칸), 그 밖의 값은 그대로 */
  function dfmt(s){ s = String(s || ''); return /^\d{8}$/.test(s) ? (s.substr(0, 4) + '-' + s.substr(4, 2) + '-' + s.substr(6, 2)) : s; }

  // ---------- 조회 ----------
  window.sgLoad = function(){
    var my = ++LOAD_REQ;                                   // 순번 가드 — 늦게 온 옛 부서 응답이 덮지 않게
    return post('<c:url value="/qps/signerList.do"/>', { deptCd: val('sgDept'), withRetire: (gel('sgRet') && gel('sgRet').checked) ? 'Y' : 'N' })
    .then(function(res){
      if (my !== LOAD_REQ) return;
      LIST = res.list || []; DEPTS = res.dept || []; USERS = res.users || [];
      CAN = (res.canEdit === 'Y'); ME = res.me || '';
      if (gel('sgDept').options.length <= 1) {
        var o = DEPTS.map(function(d){ return '<option value="' + esc(d.subcode) + '">' + esc(d.subcodenm) + '</option>'; }).join('');
        gel('sgDept').innerHTML = '<option value="">전체</option>' + o;
        gel('sgFDept').innerHTML = '<option value="">(없음)</option>' + o;
      }
      gel('sgAddBtn').style.display = CAN ? '' : 'none';
      gel('sgBulkBtn').style.display = CAN ? '' : 'none';
      gel('sgEmpBtn').style.display = CAN ? '' : 'none';
      gel('sgPermNote').innerHTML = CAN
        ? '· 지금 계정은 명단과 사인을 <b>고칠 수 있습니다</b>.'
        : '· 지금 계정은 <b>보기만</b> 됩니다(QPS 담당자·병원관리자가 고칩니다. 본인 사인은 [🖋 내 도장]).';
      sgPaint();
    }).catch(function(e){ if (my === LOAD_REQ) err(e); });
  };

  window.sgPaint = function(){
    var q = String(val('sgFind') || '').trim().toLowerCase();
    var rows = LIST.filter(function(s){
      if (!q) return true;
      return [s.usernm, s.empno, s.jobnm, s.posnm].some(function(v){ return String(v || '').toLowerCase().indexOf(q) >= 0; });
    });
    var ret = LIST.filter(function(s){ return s.retired === 'Y'; }).length;
    gel('sgCnt').textContent = '명단 ' + LIST.length + '명' + (ret ? (' (퇴사 ' + ret + ')') : '') +
                               ' · 사인 있음 ' + LIST.filter(function(s){ return s.hasimg === 'Y'; }).length + '명';
    if (!rows.length) {
      gel('sgBody').innerHTML = '<tr><td colspan="11" class="sg-empty">' +
        (LIST.length ? '찾는 사람이 없습니다.' : '아직 등록된 직원이 없습니다 — [+ 사람 추가] 또는 [📋 여러 명 붙여넣기]로 시작하세요. 점검표 화면에서 [🖋 내 도장]을 등록한 계정은 여기 저절로 보입니다.') +
        '</td></tr>';
      return;
    }
    gel('sgBody').innerHTML = rows.map(function(s, i){
      var mine = (s.userid === ME), retired = (s.retired === 'Y');
      var img = (s.hasimg === 'Y' && s.signimg)
        ? '<img class="sg-thumb" src="data:' + esc(s.signmime || 'image/png') + ';base64,' + esc(s.signimg) + '" alt="" title="' + (s.signgb === 'D' ? '스캔 도장' : '마우스 서명') + (s.upddttm ? (' · ' + esc(s.upddttm)) : '') + '">'
        : '<span class="sg-empty">없음</span>';
      var acct = (s.acctyn === 'Y') ? '<span class="sg-acct">' + esc(s.userid) + '</span>' : '<span class="sg-noacct">계정 없음</span>';
      var btns = '';
      if (CAN || mine) btns += '<button type="button" class="sg-btn ghost mini" onclick="sgSignOpen(\'' + esc(s.userid) + '\');">🖋 사인 ' + (s.hasimg === 'Y' ? '다시' : '그리기') + '</button>';
      if ((CAN || mine) && s.hasimg === 'Y') btns += '<button type="button" class="sg-btn ghost mini" onclick="sgImgClear(\'' + esc(s.userid) + '\');">그림 내리기</button>';
      if (CAN) btns += '<button type="button" class="sg-btn ghost mini" onclick="sgFormOpen(\'' + esc(s.userid) + '\');">✎ 고치기</button>' +
                       '<button type="button" class="sg-btn warn mini" onclick="sgDel(\'' + esc(s.userid) + '\');">삭제</button>';
      return '<tr' + (retired ? ' class="ret"' : '') + '><td class="no">' + (i + 1) + '</td>' +
             '<td><span class="sg-nm">' + esc(s.usernm) + '</span>' + (retired ? '<span class="sg-ret">퇴직</span>' : '') + '</td>' +
             '<td>' + esc(s.empno || '') + '</td>' +
             '<td>' + esc(s.jobnm || '') + '</td>' +
             '<td>' + esc(s.posnm || '') + '</td>' +
             '<td>' + esc(deptNm(s.deptcd)) + '</td>' +
             '<td>' + esc(dfmt(s.joindt)) + '</td>' +
             '<td>' + esc(dfmt(s.retiredt)) + '</td>' +
             '<td>' + acct + '</td>' +
             '<td>' + img + '</td>' +
             '<td><div class="sg-btns">' + btns + '</div></td></tr>';
    }).join('');
  };

  // ---------- 사람 줄 ----------
  window.sgFormOpen = function(uid){
    sgBulkClose(); sgEmpClose();
    var f = gel('sgForm'), s = uid ? byId(uid) : null;
    f.setAttribute('data-uid', uid || '');
    gel('sgFormTtl').textContent = s ? ('고치기 — ' + s.usernm) : '새 사람';
    gel('sgNm').value = s ? (s.usernm || '') : '';
    gel('sgEmp').value = s ? (s.empno || '') : '';
    gel('sgJob').value = s ? (s.jobnm || '') : '';
    gel('sgPos').value = s ? (s.posnm || '') : '';
    gel('sgFDept').value = s ? (s.deptcd || '') : (val('sgDept') || '');
    gel('sgJoin').value = s ? dfmt(s.joindt) : '';
    gel('sgRetire').value = s ? dfmt(s.retiredt) : '';
    gel('sgSort').value = s ? String(s.sortno || 0) : '0';
    gel('sgRemark').value = s ? (s.remark || '') : '';
    /* 계정 잇기는 **새 사람일 때만** — 이미 만든 줄의 USER_ID 는 바꾸지 않는다(결재 기록·근무표가 그 키를 가리킨다).
       이미 명단에 있는 계정은 뺀다. */
    var have = {}; LIST.forEach(function(x){ have[x.userid] = 1; });
    gel('sgAcct').innerHTML = '<option value="">(계정 없음)</option>' + USERS.filter(function(u){ return !have[u.userid]; })
      .map(function(u){ return '<option value="' + esc(u.userid) + '">' + esc(u.usernm || u.userid) + ' (' + esc(u.userid) + ')</option>'; }).join('');
    gel('sgAcctWrap').style.display = s ? 'none' : '';
    f.style.display = 'flex';
    gel('sgNm').focus();
  };
  window.sgFormClose = function(){ gel('sgForm').style.display = 'none'; };
  /** ★폼에서 부서를 고르면 위 표의 부서 필터가 같은 부서로 따라온다(사용자 「입력시 부서 선택하면 그리드 부서 자동 따라오게」, 2026-09-09).
      안 그러면 다른 부서를 보던 채로 저장해 「등록했는데 안 보인다」가 된다. 저장 뒤에도 같은 규칙(sgFormSave). */
  gel('sgFDept').addEventListener('change', function(){
    if (gel('sgDept').value === this.value) return;
    gel('sgDept').value = this.value;
    sgLoad();                                            // 폼은 열린 채 목록만 그 부서로
  });
  /** 계정을 고르면 이름을 그 계정 이름으로 미리 채운다(이름이 다르면 사인 칸과 안 맞는다) */
  gel('sgAcct').addEventListener('change', function(){
    var uid = this.value; if (!uid) return;
    for (var i = 0; i < USERS.length; i++) if (USERS[i].userid === uid && !val('sgNm')) gel('sgNm').value = USERS[i].usernm || '';
  });
  function formData(uid){
    return { userId: uid, acctUserId: uid ? '' : val('sgAcct'), userNm: String(val('sgNm')).trim(),
             empNo: val('sgEmp'), jobNm: val('sgJob'), posNm: val('sgPos'), deptCd: val('sgFDept'),
             joinDt: val('sgJoin'), retireDt: val('sgRetire'), sortNo: val('sgSort') || '0', remark: val('sgRemark') };
  }
  window.sgFormSave = function(){
    var uid = gel('sgForm').getAttribute('data-uid') || '';
    var d = formData(uid), nm = d.userNm;
    if (!nm) { _alertBox('이름을 적으세요.', {icon:'⚠️'}); gel('sgNm').focus(); return; }
    if (d.joinDt && d.retireDt && d.retireDt < d.joinDt) { _alertBox('퇴사일이 입사일보다 앞섭니다.', {icon:'⚠️'}); gel('sgRetire').focus(); return; }
    /* 같은 이름이 둘이면 사인 칸 도장이 앞 사람 것으로 붙는다 — 미리 알린다(막지는 않는다, 동명이인이 있을 수 있다) */
    var dup = LIST.filter(function(s){ return s.usernm === nm && s.userid !== uid; });
    var go = function(){
      post('<c:url value="/qps/signerSave.do"/>', d).then(function(res){
        toast(uid ? '고쳤습니다.' : '등록했습니다.');
        sgFormClose();
        /* 저장한 사람의 부서로 표를 맞춘다 — 다른 부서를 거른 채면 방금 넣은 사람이 안 보인다 */
        if (d.deptCd && gel('sgDept').value !== d.deptCd) gel('sgDept').value = d.deptCd;
        return sgLoad().then(function(){ if (!uid && res.userId) sgSignOpen(res.userId); });   // 새 사람이면 바로 사인 그리기
      }).catch(err);
    };
    if (dup.length) {
      ask('<b>' + esc(nm) + '</b> 이라는 이름이 이미 <b>' + dup.length + '명</b> 있습니다.<br>' +
          '<span style="font-size:12px;color:#8a99a3;">사인 칸의 도장은 <b>이름</b>으로 찾아 붙습니다 — 같은 이름이면 앞 사람 것이 쓰입니다.<br>동명이인이면 직종·부서로 가르고, 점검표에 적는 이름도 구분해 적어 주세요.</span>',
          { icon:'⚠️', okText:'그래도 등록' }).then(function(ok){ if (ok) go(); });
      return;
    }
    go();
  };
  window.sgDel = function(uid){
    var s = byId(uid); if (!s) return;
    ask('<b>' + esc(s.usernm) + '</b> 님을 명단에서 <b>뺍니다.</b><br>' +
        '<span style="font-size:12px;color:#8a99a3;">이미 찍힌 문서의 이름·결재 기록은 그대로 남고, 앞으로 사인 칸에 그림만 안 붙습니다.<br>' +
        '퇴사한 사람이면 빼지 말고 <b>퇴사일</b>을 적어 두세요(인사 기록이 남습니다).' +
        (s.acctyn === 'Y' ? '<br>계정이 이어진 사람입니다 — 그 계정이 [🖋 내 도장]을 다시 등록하면 되살아납니다.' : '') + '</span>',
        { icon:'⚠️', okText:'빼기', okColor:'#b23b3b' }).then(function(ok){
      if (!ok) return;
      post('<c:url value="/qps/signerDel.do"/>', { userId: uid, what: 'row' })
        .then(function(){ toast('명단에서 뺐습니다.'); sgLoad(); }).catch(err);
    });
  };
  window.sgImgClear = function(uid){
    var s = byId(uid); if (!s) return;
    ask('<b>' + esc(s.usernm) + '</b> 님의 사인 그림만 <b>내립니다</b>(사람은 남습니다).', { icon:'⚠️', okText:'내리기' }).then(function(ok){
      if (!ok) return;
      post('<c:url value="/qps/signerDel.do"/>', { userId: uid, what: 'img' })
        .then(function(){ toast('그림을 내렸습니다.'); sgLoad(); }).catch(err);
    });
  };

  // ---------- 여러 명 붙여넣기 (엑셀 열 복사 → 탭/쉼표 구분, 이름·사번·직종·직책·부서·입사일) ----------
  window.sgBulkOpen = function(){ sgFormClose(); sgEmpClose(); gel('sgBulk').style.display = 'block'; gel('sgBulkTxt').focus(); sgBulkParse(); };
  window.sgBulkClose = function(){ gel('sgBulk').style.display = 'none'; };
  window.sgBulkParse = function(){
    var txt = String(val('sgBulkTxt') || '').replace(/\r\n?/g, '\n');
    var lines = txt.split('\n').map(function(l){ return l.replace(/\s+$/, ''); }).filter(function(l){ return l.trim(); });
    BULK = [];
    lines.forEach(function(l, idx){
      var c = (l.indexOf('\t') >= 0 ? l.split('\t') : l.split(',')).map(function(x){ return String(x || '').trim(); });
      var nm = c[0] || '';
      if (idx === 0 && /^(이름|성명|사원명|사용자명|name)$/i.test(nm)) return;     // 머리줄
      if (!nm) return;
      var dc = deptCdOf(c[4]);
      var join = (c[5] || '').replace(/[^0-9]/g, '');
      var bad = [];
      if (c[4] && dc === null) bad.push('부서 「' + c[4] + '」 없음');
      if (c[5] && join.length !== 8) bad.push('입사일 「' + c[5] + '」');
      if (LIST.some(function(s){ return s.usernm === nm; })) bad.push('같은 이름 있음');
      BULK.push({ userNm: nm, empNo: c[1] || '', jobNm: c[2] || '', posNm: c[3] || '', deptCd: dc || '', deptTxt: c[4] || '',
                  joinDt: c[5] || '', bad: bad, skip: !!((c[4] && dc === null) || (c[5] && join.length !== 8)) });
    });
    var okN = BULK.filter(function(b){ return !b.skip; }).length;
    gel('sgBulkCnt').textContent = BULK.length ? (BULK.length + '줄 · 등록할 수 있는 것 ' + okN + '명' + (BULK.length - okN ? (' · 고쳐야 하는 줄 ' + (BULK.length - okN)) : '')) : '';
    gel('sgBulkPrev').innerHTML = BULK.length ? ('<table><thead><tr><th>#</th><th>이름</th><th>사번</th><th>직종</th><th>직책/직급</th><th>부서</th><th>입사일</th><th>확인</th></tr></thead><tbody>' +
      BULK.map(function(b, i){
        return '<tr><td class="no">' + (i + 1) + '</td><td>' + esc(b.userNm) + '</td><td>' + esc(b.empNo) + '</td><td>' + esc(b.jobNm) + '</td><td>' + esc(b.posNm) + '</td>' +
               '<td>' + esc(b.deptCd ? deptNm(b.deptCd) : b.deptTxt) + '</td><td>' + esc(b.joinDt) + '</td>' +
               '<td class="' + (b.skip ? 'bad' : '') + '">' + (b.bad.length ? esc(b.bad.join(' · ')) + (b.skip ? ' — 건너뜀' : '') : '✓') + '</td></tr>';
      }).join('') + '</tbody></table>') : '';
  };
  window.sgBulkSave = function(){
    var rows = BULK.filter(function(b){ return !b.skip; });
    if (!rows.length) { _alertBox('등록할 줄이 없습니다 — 위 칸에 붙여 넣으세요.', {icon:'ℹ️'}); return; }
    var dups = rows.filter(function(b){ return b.bad.length; }).length;
    ask('<b>' + rows.length + '명</b>을 등록합니다.' + (dups ? ('<br><span style="font-size:12px;color:#b23b3b;">같은 이름이 이미 있는 줄이 ' + dups + '개 — 그대로 새 사람으로 들어갑니다.</span>') : '') +
        '<br><span style="font-size:12px;color:#8a99a3;">계정 잇기·사인은 등록 뒤 줄마다 [✎ 고치기]·[🖋 사인 그리기]로.</span>',
        { icon:'📋', okText:'등록' }).then(function(ok){
      if (!ok) return;
      var done = 0, fails = [];
      gel('sgBulkGo').disabled = true;
      (function next(i){
        if (i >= rows.length) {
          gel('sgBulkGo').disabled = false;
          toast(done + '명 등록' + (fails.length ? (' · ' + fails.length + '명 실패') : ''), fails.length ? 'warn' : 'ok');
          if (fails.length) _alertBox('등록하지 못한 줄:<br>' + fails.map(esc).join('<br>'), {icon:'⚠️'});
          gel('sgBulkTxt').value = ''; sgBulkParse(); sgBulkClose(); sgLoad();
          return;
        }
        var b = rows[i];
        post('<c:url value="/qps/signerSave.do"/>', { userId: '', acctUserId: '', userNm: b.userNm, empNo: b.empNo, jobNm: b.jobNm, posNm: b.posNm,
                                                       deptCd: b.deptCd, joinDt: b.joinDt, retireDt: '', sortNo: String(i + 1), remark: '' })
          .then(function(){ done++; }, function(e){ fails.push(b.userNm + ' — ' + (e && e.message || '실패')); })
          .then(function(){ next(i + 1); });
      })(0);
    });
  };

  // ---------- 면허등록에서 가져오기 (차등제 인력 신고표 TBL_HOSPEMP_MST) ----------
  /* ★두 표를 합치지 않는다 — 저쪽은 「면허 신고」(면허번호+입사일이 키), 이쪽은 「사람 명부」다.
     여기서는 **이름·직종·입퇴사일만 베껴** 온다. 뒤에 저쪽이 바뀌어도 이쪽은 따라가지 않는다(따라가면 사인이 딸려 흔들린다). */
  window.sgEmpOpen = function(){
    sgFormClose(); sgBulkClose();
    gel('sgEmp').style.display = 'block';
    gel('sgEmpDept').innerHTML = gel('sgFDept').innerHTML;
    gel('sgEmpDept').value = val('sgDept') || '';
    gel('sgEmpPrev').innerHTML = '<div class="sg-empty" style="padding:8px;">불러오는 중…</div>';
    gel('sgEmpCnt').textContent = '';
    post('<c:url value="/qps/signerEmpList.do"/>', {}).then(function(res){
      EMP = res.list || [];
      sgEmpPaint();
    }).catch(function(e){
      gel('sgEmpPrev').innerHTML = '<div class="sg-empty" style="padding:8px;">' + esc(e.message || '가져오지 못했습니다.') + '</div>';
    });
  };
  window.sgEmpClose = function(){ gel('sgEmp').style.display = 'none'; };
  /** 면허등록의 퇴사일 — ★`20991231` 같은 **무기한 관용값**은 비운다(그대로 가져오면 인사 카드에 2099년이 남는다) */
  function empRetireDt(e){
    var r = String(e.retiredt || '').replace(/[^0-9]/g, '');
    if (r.length !== 8 || r.substr(0, 4) >= '2090') return '';
    return r;
  }
  function empRetired(e){
    var r = empRetireDt(e);
    if (!r) return false;
    var t = new Date(); var today = t.getFullYear() + ('0' + (t.getMonth() + 1)).slice(-2) + ('0' + t.getDate()).slice(-2);
    return r <= today;
  }
  window.sgEmpPaint = function(){
    var withRet = gel('sgEmpRet').checked;
    var rows = EMP.filter(function(e){ return withRet || !empRetired(e); });
    var can = rows.filter(function(e){ return e.already !== 'Y'; });
    gel('sgEmpCnt').textContent = rows.length
      ? ('면허등록 ' + rows.length + '명 · 가져올 수 있는 사람 ' + can.length + '명' + (rows.length - can.length ? (' · 이미 있음 ' + (rows.length - can.length)) : ''))
      : '';
    if (!rows.length) {
      gel('sgEmpPrev').innerHTML = '<div class="sg-empty" style="padding:8px;">' +
        (EMP.length ? '재직 중인 사람이 없습니다 — 「퇴사일 지난 사람도」를 켜 보세요.'
                    : '면허등록(차등제 인력 신고)에 등록된 직원이 없습니다.') + '</div>';
      return;
    }
    gel('sgEmpPrev').innerHTML = '<div class="box"><table><thead><tr><th style="width:34px;"></th><th>이름</th><th style="width:110px;">직종(면허)</th>' +
      '<th style="width:100px;">입사일</th><th style="width:100px;">퇴사일</th><th style="width:90px;">확인</th></tr></thead><tbody>' +
      rows.map(function(e, i){
        var have = (e.already === 'Y'), ret = empRetired(e);
        return '<tr class="' + (have ? 'have' : '') + '">' +
               '<td>' + (have ? '' : '<input type="checkbox" class="sg-empck" data-nm="' + esc(e.usernm) + '">') + '</td>' +
               '<td>' + esc(e.usernm) + '</td><td>' + esc(e.jobnm || e.lictype || '') + '</td>' +
               '<td>' + esc(dfmt(e.joindt)) + '</td><td>' + esc(dfmt(empRetireDt(e))) + '</td>' +
               '<td>' + (have ? '이미 있음' : (ret ? '<span style="color:#b23b3b;">퇴사</span>' : '✓')) + '</td></tr>';
      }).join('') + '</tbody></table></div>';
    gel('sgEmpAll').checked = false;
  };
  window.sgEmpCheckAll = function(){
    var on = gel('sgEmpAll').checked;
    gel('sgEmpPrev').querySelectorAll('input.sg-empck').forEach(function(c){ c.checked = on; });
  };
  window.sgEmpSave = function(){
    var picked = [].map.call(gel('sgEmpPrev').querySelectorAll('input.sg-empck:checked'), function(c){ return c.getAttribute('data-nm'); });
    if (!picked.length) { _alertBox('가져올 사람을 고르세요.', {icon:'ℹ️'}); return; }
    var dept = val('sgEmpDept');
    var rows = EMP.filter(function(e){ return picked.indexOf(e.usernm) >= 0; });
    ask('<b>' + rows.length + '명</b>을 인사 등록에 넣습니다' + (dept ? (' (부서 <b>' + esc(deptNm(dept)) + '</b>)') : '') + '.<br>' +
        '<span style="font-size:12px;color:#8a99a3;">이름·직종·입사일을 베껴 옵니다 — 사번·직책은 뒤에 [✎ 고치기]로, 사인은 [🖋 사인 그리기]로.<br>' +
        '면허등록이 뒤에 바뀌어도 여기 명단은 따라 바뀌지 않습니다.</span>',
        { icon:'👩‍⚕️', okText:'가져오기' }).then(function(ok){
      if (!ok) return;
      var done = 0, fails = [];
      gel('sgEmpGo').disabled = true;
      (function next(i){
        if (i >= rows.length) {
          gel('sgEmpGo').disabled = false;
          toast(done + '명 가져왔습니다' + (fails.length ? (' · ' + fails.length + '명 실패') : ''), fails.length ? 'warn' : 'ok');
          if (fails.length) _alertBox('가져오지 못한 줄:<br>' + fails.map(esc).join('<br>'), {icon:'⚠️'});
          if (dept) gel('sgDept').value = dept;
          sgEmpClose(); sgLoad();
          return;
        }
        var e = rows[i];
        post('<c:url value="/qps/signerSave.do"/>', {
          userId: '', acctUserId: '', userNm: e.usernm, empNo: '', jobNm: (e.jobnm || ''), posNm: '',
          deptCd: dept, joinDt: (e.joindt || ''), retireDt: empRetireDt(e), sortNo: String(i + 1), remark: '면허등록에서'
        }).then(function(){ done++; }, function(err2){ fails.push(e.usernm + ' — ' + (err2 && err2.message || '실패')); })
          .then(function(){ next(i + 1); });
      })(0);
    });
  };

  // ---------- 사인 그리기 창 (qpsChk [🖋 내 도장] 와 같은 규칙) ----------
  window.sgSignOpen = function(uid){
    var s = byId(uid); if (!s) return;
    SIGN_FOR = uid; SIGN_GB = 'S';
    var now = (s.hasimg === 'Y' && s.signimg)
      ? '<div class="now"><img src="data:' + esc(s.signmime || 'image/png') + ';base64,' + esc(s.signimg) + '" alt="">' +
        '<div style="font-size:11px;color:#8a99a3;margin-top:4px;">지금 등록된 사인 · ' + esc(s.upddttm || '') + '</div></div>'
      : '<div class="now" style="color:#b6bfc6;font-size:12px;">아직 사인이 없습니다 — 사인 칸에는 이름 글자가 찍힙니다.</div>';
    var wrap = document.createElement('div');
    wrap.className = 'sg-signwrap'; wrap.id = 'sgSignWrap';
    wrap.innerHTML =
      '<div class="sg-sign">' +
        '<h4>🖋 ' + esc(s.usernm) + (s.jobnm ? (' · ' + esc(s.jobnm)) : '') + ' — 사인·도장</h4>' +
        '<div class="desc">아래 칸에 <b>마우스(또는 손가락)로 그리거나</b>, <b>스캔한 도장 그림</b>을 올리세요. 사람마다 한 장이며 새로 저장하면 바뀝니다.</div>' +
        now +
        '<canvas id="sgSignCv"></canvas>' +
        '<div style="font-size:11px;color:#8a99a3;margin-top:4px;">위 칸에 그리면 됩니다 · 다시 그리려면 [지우기]</div>' +
        '<div style="margin-top:8px;font-size:12px;">스캔 그림 : <input type="file" id="sgSignFile" accept="image/*"></div>' +
        '<div class="btns">' +
          '<button type="button" class="sg-btn ghost" onclick="sgSignClear();">지우기</button>' +
          '<button type="button" class="sg-btn ghost" onclick="sgSignClose();">닫기</button>' +
          '<button type="button" class="sg-btn" onclick="sgSignSave();">저장</button>' +
        '</div>' +
      '</div>';
    gel('qpsSigner').appendChild(wrap);
    sgSignBind();
  };
  function sgSignBind(){
    SIGN_CV = gel('sgSignCv'); SIGN_DRAWN = false;
    /* ★화면 크기와 그리는 크기를 따로 잡는다(devicePixelRatio) — 안 그러면 저장한 그림이 흐리다 */
    var r = SIGN_CV.getBoundingClientRect(), dpr = window.devicePixelRatio || 1;
    SIGN_CV.width = Math.round(r.width * dpr); SIGN_CV.height = Math.round(r.height * dpr);
    SIGN_CTX = SIGN_CV.getContext('2d');
    SIGN_CTX.scale(dpr, dpr);
    SIGN_CTX.lineWidth = 2.2; SIGN_CTX.lineCap = 'round'; SIGN_CTX.lineJoin = 'round'; SIGN_CTX.strokeStyle = '#1a2b38';
    var down = false;
    function pt(e){
      var b = SIGN_CV.getBoundingClientRect();
      var t = (e.touches && e.touches[0]) ? e.touches[0] : e;
      return { x: t.clientX - b.left, y: t.clientY - b.top };
    }
    function start(e){ down = true; var p = pt(e); SIGN_CTX.beginPath(); SIGN_CTX.moveTo(p.x, p.y); e.preventDefault(); }
    function move(e){ if (!down) return; var p = pt(e); SIGN_CTX.lineTo(p.x, p.y); SIGN_CTX.stroke(); SIGN_DRAWN = true; e.preventDefault(); }
    function end(){ down = false; }
    SIGN_CV.addEventListener('mousedown', start); SIGN_CV.addEventListener('mousemove', move);
    document.addEventListener('mouseup', end);
    SIGN_CV.addEventListener('touchstart', start); SIGN_CV.addEventListener('touchmove', move); SIGN_CV.addEventListener('touchend', end);
    gel('sgSignFile').addEventListener('change', function(){
      var f = this.files && this.files[0]; if (!f) return;
      if (!/^image\//.test(f.type)) { _alertBox('그림 파일만 올릴 수 있습니다.', {icon:'⚠️'}); this.value = ''; return; }
      var fr = new FileReader();
      fr.onload = function(){
        var im = new Image();
        im.onload = function(){
          /* 스캔 원본을 그대로 저장하면 몇 MB — 캔버스 폭에 맞춰 줄여 그린다(사인 칸은 5mm 남짓이다) */
          var b = SIGN_CV.getBoundingClientRect();
          SIGN_CTX.clearRect(0, 0, b.width, b.height);
          var sc = Math.min(b.width / im.width, b.height / im.height, 1);
          var w = im.width * sc, hh = im.height * sc;
          SIGN_CTX.drawImage(im, (b.width - w) / 2, (b.height - hh) / 2, w, hh);
          SIGN_DRAWN = true; SIGN_GB = 'D';
        };
        im.src = fr.result;
      };
      fr.readAsDataURL(f);
    });
  }
  window.sgSignClear = function(){
    if (!SIGN_CTX) return;
    var b = SIGN_CV.getBoundingClientRect();
    SIGN_CTX.clearRect(0, 0, b.width, b.height);
    SIGN_DRAWN = false; SIGN_GB = 'S';
    var f = gel('sgSignFile'); if (f) f.value = '';
  };
  window.sgSignClose = function(){
    var w = gel('sgSignWrap'); if (w && w.parentNode) w.parentNode.removeChild(w);
    SIGN_CV = null; SIGN_CTX = null; SIGN_FOR = null; SIGN_GB = 'S';
  };
  window.sgSignSave = function(){
    if (!SIGN_DRAWN) { _alertBox('그리거나 그림을 올린 뒤 저장하세요.', {icon:'ℹ️'}); return; }
    var url = SIGN_CV.toDataURL('image/png'), uid = SIGN_FOR;
    post('<c:url value="/qps/signerImgSave.do"/>', { userId: uid, signImg: url, signGb: SIGN_GB, signMime: 'image/png' })
      .then(function(){ sgSignClose(); toast('사인을 저장했습니다.'); sgLoad(); }).catch(err);
  };

  $(function(){ sgLoad(); });
})();
</script>
