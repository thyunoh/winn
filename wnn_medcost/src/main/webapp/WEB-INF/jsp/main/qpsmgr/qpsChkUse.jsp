<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%-- qpsChkUse.jsp — 우리 병원 사용 서식 (2026-08-18)

     왜 : 서식(공통 '*')은 위너넷이 등록하지만, <어느 병원이 어느 서식을 쓸지>는 병원별이다.
          그 스위치가 있던 [서식 관리]는 위너넷 전용이라 병원이 스스로 켤 수 없었다.
       ⇒ ***켜고 끄기만 하는*** 이 화면을 따로 둔다. 서식을 만들거나 고치는 기능은 넣지 않는다.

     ★병원과 위너넷이 <같은 화면>을 쓴다 — 병원이 못 하면 우리가 대신 켜 줘야 하는데,
       화면을 따로 두면 두 벌을 만들고 두 벌을 고치게 된다.
       · 병원   : 자기 병원 것만. 병원 칸이 없다.
       · 위너넷 : 맨 위에 <병원코드> 칸이 하나 더 뜬다.
     ⚠막는 것은 화면이 아니라 서버다 — QpsController.hospCd() 가 s_wnn_yn='Y' 일 때만
       파라미터 hospCd 를 받고, 아니면 로그인 쿠키의 병원을 강제한다.

     ★★거르기는 <화면에서만> 한다 — 목록은 처음 한 번 전부 받아 두고 눌러서 좁힐 뿐이다.
       ***부서를 걸러 놓고 저장했다가 안 보이던 서식이 통째로 꺼지는 사고***를 막는 유일한 방법이다.
       (서식 관리의 cfUseSave 는 저장 직전에 전체를 다시 받아 합치는 방식으로 같은 문제를 푼다.)

     ★주의: 이 파일 안에서 Deferred EL 표기(샵+중괄호) 금지 --%>

<script src="/asset/js/ui-message.js"></script>

<%-- ★.dashboard-wrapper 는 winn 공통 레이아웃 필수 --%>
<div class="dashboard-wrapper">
<div id="qpsChkUse" data-wnn="<c:out value='${wnnYn}'/>">
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
  #qpsChkUse .cu-btn.ghost{ background:#fff; color:#1f5a4b; }
  #qpsChkUse .cu-btn.mini{ padding:3px 10px; font-size:12px; border-color:#cfd8e0; color:#556570; background:#fff; }
  #qpsChkUse .cu-note{ background:#f0f7f4; border:1px solid #cfe3da; border-radius:8px; padding:9px 12px;
      font-size:12.5px; color:#1f5a4b; line-height:1.6; margin-bottom:12px; }
  #qpsChkUse .cu-wnn{ background:#fdf6e3; border:1px solid #e8d9a8; border-radius:8px; padding:8px 12px;
      font-size:12.5px; color:#7a5c1f; margin-bottom:12px; display:flex; align-items:center; gap:8px; flex-wrap:wrap; }
  #qpsChkUse .cu-card{ background:#fff; border:1px solid #e3e9ed; border-radius:10px; padding:14px 16px; }
  #qpsChkUse .cu-bar{ display:flex; gap:8px; align-items:center; flex-wrap:wrap; margin-bottom:10px; }
  #qpsChkUse .cu-list{ display:grid; grid-template-columns:repeat(auto-fill,minmax(300px,1fr)); gap:6px; }
  #qpsChkUse .cu-item{ border:1px solid #e3e9ed; border-radius:8px; padding:8px 10px; display:flex; gap:8px; align-items:flex-start; }
  #qpsChkUse .cu-item:hover{ background:#f7fbf9; }
  #qpsChkUse .cu-item.on{ border-color:#8fc3b2; background:#f7fbf9; }
  #qpsChkUse .cu-item input{ margin-top:2px; }
  #qpsChkUse .cu-nm{ font-size:13px; font-weight:700; color:#20303a; }
  #qpsChkUse .cu-meta{ font-size:11.5px; color:#8a99a3; margin-top:2px; }
  #qpsChkUse .cu-empty{ color:#8a99a3; font-size:13px; padding:24px; text-align:center; }
  #qpsChkUse .zz-zoom{ display:inline-flex; gap:4px; align-items:center; margin-left:2px; margin-right:14px; }
  #qpsChkUse .zz-zoom button{ border:1px solid #cfd9e0; background:#fff; color:#43555f; border-radius:6px;
                           padding:4px 9px; font-size:13px; font-weight:700; cursor:pointer; }
  #qpsChkUse .zz-zoom button:hover{ background:#eef3f6; }
</style>

<div class="cu-head">
  <div class="cu-title"><span class="cu-dot"></span>우리 병원 사용 서식 <span class="cu-sub">점검표 작성에 나올 서식을 고릅니다</span></div>
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

<div class="cu-note">
  체크한 서식만 <b>[점검표 작성]</b> 화면의 서식 목록에 나옵니다. 여기서 켜고 꺼도
  <b>이미 작성한 자료는 지워지지 않습니다</b> — 목록에 보이고 안 보이고만 달라집니다.
</div>

<%-- ★위너넷일 때만 — 병원이 못 하면 우리가 대신 켜 준다 --%>
<c:if test="${wnnYn eq 'Y'}">
<div class="cu-wnn">
  <b>위너넷</b> — 다른 병원 대신 설정하려면 병원코드를 넣고 [불러오기] 를 누르세요.
  <input type="text" id="cuHospCd" placeholder="병원코드(요양기관기호)" style="width:170px;">
  <button type="button" class="cu-btn mini" onclick="cuLoad();">불러오기</button>
  <span class="cu-sub" id="cuWho">— 지금은 <b>내 병원</b></span>
</div>
</c:if>

<div class="cu-card">
  <div class="cu-bar">
    <select id="cuDept" onchange="cuPaint();"><option value="">전체 부서</option></select>
    <select id="cuCate" onchange="cuPaint();"><option value="">전체 분류</option></select>
    <input type="text" id="cuQ" placeholder="서식명 찾기" style="width:200px;" oninput="cuPaint();">
    <button type="button" class="cu-btn mini" onclick="cuAll(true);">보이는 것 전체 켬</button>
    <button type="button" class="cu-btn mini" onclick="cuAll(false);">보이는 것 전체 끔</button>
    <span class="cu-sub" id="cuCnt"></span>
  </div>
  <div class="cu-list" id="cuList"><div class="cu-empty">불러오는 중…</div></div>
</div>

<script>
(function(){
  var LIST  = [];     // ★전체 서식. 한 번만 받는다 — 거르기는 화면에서만 한다
  var USE   = {};     // formid → true/false. 화면 체크 상태를 여기 모은다
  var DEPTS = [], CATES = [];   // 셀렉트 원본(공통코드). 서로 좁힐 때마다 여기서 다시 짓는다

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
  /** 위너넷이 다른 병원을 고른 경우에만 병원코드를 함께 보낸다(서버가 권한을 다시 본다) */
  function hospParam(){
    var el = gel('cuHospCd');
    return (el && el.value.trim()) ? { hospCd: el.value.trim() } : {};
  }
  /** ★★한쪽을 고르면 다른 쪽 칸도 함께 좁힌다 (2026-08-18 사용자 지적)
      「부서를 골랐는데 분류 칸은 6개 그대로」 — 서식은 부서에 묶여 있으므로
      그 부서에 없는 분류를 남겨 두면 ***고르는 순간 0종이 되는 헛 선택지***가 된다.
      ⚠각 칸의 후보는 **자기 조건을 뺀 나머지**로 센다 — 자기 조건까지 넣으면 고른 하나만 남는다.
      ⚠지금 고른 값은 0종이어도 지우지 않는다(칸이 저 혼자 바뀌면 「내가 안 골랐는데」가 된다). */
  function put(sel, codes, cnt, cur, allNm){
    var total = 0, h, keep = false;
    Object.keys(cnt).forEach(function(k){ total += cnt[k]; });
    h = '<option value="">' + allNm + ' (' + total + ')</option>';
    (codes || []).forEach(function(r){
      var n = cnt[r.subcode] || 0;
      if (!n && r.subcode !== cur) return;          // 0종은 아예 안 내놓는다
      if (r.subcode === cur) keep = true;
      h += '<option value="' + esc(r.subcode) + '">' + esc(r.subcodenm) + ' (' + n + ')</option>';
    });
    sel.innerHTML = h;
    sel.value = keep ? cur : '';
  }
  function refillSel(){
    var d = gel('cuDept').value, c = gel('cuCate').value, q = gel('cuQ').value.trim();
    function pass(r, skip){
      if (skip !== 'd' && d && r.deptcd !== d) return false;
      if (skip !== 'c' && c && r.catecd !== c) return false;
      if (q && String(r.formnm || '').indexOf(q) < 0) return false;
      return true;
    }
    var dc = {}, cc = {};
    LIST.forEach(function(r){
      if (pass(r, 'd')) dc[r.deptcd] = (dc[r.deptcd] || 0) + 1;
      if (pass(r, 'c')) cc[r.catecd] = (cc[r.catecd] || 0) + 1;
    });
    put(gel('cuDept'), DEPTS, dc, d, '전체 부서');
    put(gel('cuCate'), CATES, cc, c, '전체 분류');
  }

  window.cuLoad = function(){
    var p = hospParam(); p.cateCd = ''; p.deptCd = '';    // ★언제나 전체를 받는다
    post('/qps/chkFormList.do', p).then(function(res){
      LIST = res.list || [];
      USE = {};
      LIST.forEach(function(r){ USE[r.formid] = (r.useyn === 'Y'); });
      if (!DEPTS.length) { DEPTS = res.dept || []; CATES = res.cate || []; }
      var who = gel('cuWho');
      if (who) {
        var hc = (gel('cuHospCd') || {}).value;
        who.innerHTML = (hc && hc.trim()) ? ('— 지금은 <b>' + esc(hc.trim()) + '</b>') : '— 지금은 <b>내 병원</b>';
      }
      cuPaint();
    }).catch(err);
  };

  /** 화면 거르기 — ★목록을 다시 받지 않는다. USE 는 전체를 그대로 들고 있는다 */
  function visible(){
    var d = gel('cuDept').value, c = gel('cuCate').value, q = gel('cuQ').value.trim();
    return LIST.filter(function(r){
      if (d && r.deptcd !== d) return false;
      if (c && r.catecd !== c) return false;
      if (q && String(r.formnm || '').indexOf(q) < 0) return false;
      return true;
    });
  }

  window.cuPaint = function(){
    refillSel();                       // ★먼저 칸을 좁힌다 — 그린 뒤에 하면 한 박자 늦게 따라온다
    var rows = visible(), box = gel('cuList');
    box.innerHTML = rows.length ? rows.map(function(r){
      var on = !!USE[r.formid];
      return '<label class="cu-item' + (on ? ' on' : '') + '">' +
             '<input type="checkbox" data-id="' + esc(r.formid) + '"' + (on ? ' checked' : '') + '>' +
             '<span><span class="cu-nm">' + esc(r.formnm) + '</span>' +
             '<span class="cu-meta">' + esc(r.formid) + ' · 항목 ' + (r.itemcnt || 0) +
             (r.doccnt ? (' · 작성 ' + r.doccnt + '건') : '') + '</span></span></label>';
    }).join('') : '<div class="cu-empty">해당하는 서식이 없습니다.</div>';
    var onCnt = 0;
    LIST.forEach(function(r){ if (USE[r.formid]) onCnt++; });
    gel('cuCnt').textContent = '보이는 것 ' + rows.length + '종 · 켜 둔 것 ' + onCnt + ' / 전체 ' + LIST.length + '종';
  };

  // 체크는 USE 에 담는다 — 다시 그려도 살아남는다(위임)
  gel('cuList').addEventListener('change', function(ev){
    var cb = ev.target;
    if (!cb || cb.type !== 'checkbox') return;
    USE[cb.getAttribute('data-id')] = cb.checked;
    var it = cb.closest('.cu-item'); if (it) it.classList.toggle('on', cb.checked);
    cuPaint();
  });

  /** ★「보이는 것」만 바꾼다 — 안 보이는 서식은 건드리지 않는다(그게 이 버튼 이름의 뜻이다) */
  window.cuAll = function(on){
    visible().forEach(function(r){ USE[r.formid] = on; });
    cuPaint();
  };

  window.cuSave = function(){
    // ★전체(LIST)를 훑어 보낸다 — 걸러서 안 보이던 서식도 그대로 지켜진다
    var uses = [];
    LIST.forEach(function(r){ if (USE[r.formid]) uses.push({ formid: r.formid }); });
    var p = hospParam();
    p.uses = JSON.stringify(uses);
    post('/qps/chkUseSave.do', p).then(function(){
      _alertBox('저장했습니다.\n켜 둔 서식 ' + uses.length + '종이 [점검표 작성] 목록에 나옵니다.', {icon:'✅'});
      cuLoad();
    }).catch(err);
  };

  $(function(){ cuLoad(); });
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
