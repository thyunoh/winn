<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%-- qpsLib.jsp — QPS 자료실 (2026-08-10)
     · 서식(회의록·계획서·라운딩)과 달리 **본문 입력이 없다** — 조직도·내규처럼 파일 자체가 자료인 것들.
     · 왼쪽 분류 = 공통코드 QPS_LIB. 분류의 SUB_CODE 가 그대로 첨부의 문서키(REF_GB='LIBRARY').
       ★그래서 코드의 SUB_CODE 를 바꾸면 그 분류에 올린 파일이 미아가 된다(DDL 주석에도 적어 둠).
     · 첨부 UI 는 서식 3종과 같은 위젯 하나를 쓴다 — 분류를 누르면 setKey() 로 갈아끼운다.
     · ★주의: 이 파일 안에서 Deferred EL 표기(샵+중괄호) 금지 --%>

<script src="/asset/js/ui-message.js"></script>
<script src="/asset/js/ui-split.js"></script>
<%-- 공통 첨부 위젯 — window.qpsFileBox 정의 --%>
<%@ include file="/WEB-INF/jsp/main/inc/qpsFileBox.jsp" %>

<style>
  #qpsLib{ background:#f4f6f8; color:#1f2a30; min-height:100%; padding:14px 16px 60px; max-width:100%; overflow-x:hidden; }
  #qpsLib .ql-top{ display:flex; align-items:center; gap:9px; margin-bottom:12px; flex-wrap:wrap; }
  #qpsLib .ql-dot{ width:10px; height:10px; border-radius:50%; background:linear-gradient(135deg,#1f5a4b,#2a7665); }
  #qpsLib .ql-tit{ font-size:17px; font-weight:800; letter-spacing:-.3px; }
  #qpsLib .ql-sub{ font-size:12px; color:#8a99a3; }
  #qpsLib .ql-badge{ font-size:11.5px; font-weight:700; color:#1f5a4b; background:#e8f2ef;
      border:1px solid #cfe3dc; border-radius:11px; padding:2px 9px; }

  #qpsLib .ql-wrap{ display:flex; gap:13px; align-items:flex-start; }
  #qpsLib .ql-side{ width:250px; flex:none; background:#fff; border:1px solid #e0e6ea; border-radius:11px; padding:9px; }
  #qpsLib .ql-side h4{ font-size:12px; color:#8a99a3; font-weight:700; margin:3px 4px 8px; }
  #qpsLib .ql-item{ display:flex; align-items:center; gap:7px; padding:9px 10px; border-radius:8px;
      cursor:pointer; font-size:13px; font-weight:600; color:#33454f; }
  #qpsLib .ql-item:hover{ background:#f1f5f7; }
  #qpsLib .ql-item.on{ background:#1f5a4b; color:#fff; }
  #qpsLib .ql-item .nm{ flex:1; min-width:0; overflow:hidden; text-overflow:ellipsis; white-space:nowrap; }
  #qpsLib .ql-item .cnt{ font-size:11.5px; font-weight:700; color:#8a99a3; }
  #qpsLib .ql-item.on .cnt{ color:#cfe3dc; }

  #qpsLib .ql-main{ flex:1; min-width:0; background:#fff; border:1px solid #e0e6ea; border-radius:11px; padding:14px 16px; }
  #qpsLib .ql-mtit{ font-size:14.5px; font-weight:800; color:#20303a; margin-bottom:3px; }
  #qpsLib .ql-mdesc{ font-size:12px; color:#8a99a3; margin-bottom:12px; }
  #qpsLib .ql-empty{ font-size:13px; color:#9aa7ae; padding:22px 4px; text-align:center; }
  #qpsLib .ql-sp{ flex:1; }
  #qpsLib .ql-mgrbtn{ border:1px solid #cfd8dd; background:#fff; color:#33454f; border-radius:6px;
      padding:5px 12px; font-size:12.5px; font-weight:700; cursor:pointer; }
  #qpsLib .ql-mgrbtn:hover{ background:#f1f5f7; }
  #qpsLib .ql-ro{ font-size:11.5px; font-weight:700; color:#8a6d3b; background:#fcf5e6;
      border:1px solid #ecdcb8; border-radius:11px; padding:2px 9px; }

  /* 담당자 지정 — 화면 안 작은 대화상자(SweetAlert 아님: 목록 체크가 필요해서) */
  #qlMgrDim{ display:none; position:fixed; inset:0; background:rgba(20,30,36,.38); z-index:1200; }
  #qlMgrBox{ position:absolute; top:50%; left:50%; transform:translate(-50%,-50%);
      width:420px; max-width:92vw; background:#fff; border-radius:12px; padding:17px 19px;
      box-shadow:0 12px 40px rgba(0,0,0,.22); }
  #qlMgrBox h3{ font-size:15px; font-weight:800; color:#20303a; margin:0 0 4px; }
  #qlMgrBox .d{ font-size:12px; color:#8a99a3; margin-bottom:11px; line-height:1.55; }
  #qlMgrBox .ul{ max-height:270px; overflow:auto; border:1px solid #e6ecef; border-radius:8px; padding:5px; }
  #qlMgrBox .u{ display:flex; align-items:center; gap:9px; padding:7px 9px; border-radius:6px; font-size:13px; }
  #qlMgrBox .u:hover{ background:#f5f8f9; }
  #qlMgrBox .u input{ width:15px; height:15px; }
  #qlMgrBox .u .gu{ font-size:11px; color:#9aa7ae; }
  #qlMgrBox .btns{ display:flex; justify-content:center; gap:8px; margin-top:14px; }
  #qlMgrBox .btns button{ border-radius:7px; padding:7px 18px; font-size:13px; font-weight:700; cursor:pointer; }
  #qlMgrBox .ok{ border:1px solid #1f5a4b; background:#1f5a4b; color:#fff; }
  #qlMgrBox .no{ border:1px solid #cfd8dd; background:#fff; color:#5a6a73; }
  /* -- 글자 크기 (2026-08-18 요청) : QI 계획서(qpsQiPlan)와 같은 모양.같은 조작 */
  #qpsLib .zz-zoom{ display:inline-flex; gap:4px; align-items:center; margin-left:2px; margin-right:14px; }
  #qpsLib .zz-zoom button{ border:1px solid #cfd9e0; background:#fff; color:#43555f; border-radius:6px;
                        padding:4px 9px; font-size:13px; font-weight:700; cursor:pointer; }
  #qpsLib .zz-zoom button:hover{ background:#eef3f6; }
</style>

<%-- ★.dashboard-wrapper 는 winn 공통 레이아웃 필수 — 빼면 왼쪽 264px 이 사이드바에 가려지고 좌우가 잘린다 --%>
<div class="dashboard-wrapper">
<div id="qpsLib">
  <div class="ql-top">
    <span class="ql-dot"></span>
    <span class="ql-tit">자료실</span>
    <span class="ql-sub">조직도 · 규정 · 인증자료 보관</span>
    <c:if test="${wnnYn eq 'Y'}"><span class="ql-badge">위너넷</span></c:if>
    <span class="ql-ro" id="qlRo" style="display:none;">보기 전용 — QPS 담당자만 수정</span>
    <span class="ql-sp"></span>
    <button type="button" class="ql-mgrbtn" id="qlMgrBtn" style="display:none;" onclick="qlMgrOpen();">담당자 지정</button>
  <span style="flex:0 0 12px;"></span>
  <%-- 글자 크기 - 이 PC 이 브라우저에만 저장된다 --%>
  <span class="zz-zoom">
    <button type="button" onclick="zzZoom(-1);" title="글자 작게">가－</button>
    <button type="button" onclick="zzZoom(1);"  title="글자 크게">가＋</button>
    <button type="button" onclick="zzZoom(0);"  title="처음 크기로">↺</button>
  </span>
  </div>

  <div class="ql-wrap" data-split="가로" data-split-key="lib.body">
    <div class="ql-side">
      <h4>분류</h4>
      <div id="qlCats"><div class="ql-empty" style="padding:12px 4px;">불러오는 중…</div></div>
    </div>
    <div class="ql-main">
      <div class="ql-mtit" id="qlTit">분류를 선택하세요</div>
      <div class="ql-mdesc" id="qlDesc">왼쪽에서 분류를 고르면 그 분류의 자료가 보입니다.</div>
      <div id="qlFileBox"></div>
    </div>
  </div>
</div>
</div><%-- /.dashboard-wrapper --%>

<%-- 대화상자는 position:fixed 라 래퍼 밖에 둔다(래퍼 안이면 좌측 여백만큼 밀린다) --%>
<div id="qlMgrDim">
  <div id="qlMgrBox">
    <h3>QPS 담당자 지정</h3>
    <div class="d">
      체크한 사람만 자료실에 파일을 <b>올리고 지울 수</b> 있습니다. 보기·내려받기는 병원 전원 가능합니다.<br>
      <span style="color:#b07d2b;">아무도 지정하지 않으면 병원 관리자가 대신 수정합니다.</span>
    </div>
    <div class="ul" id="qlMgrList"></div>
    <div class="btns">
      <button type="button" class="ok" onclick="qlMgrSave();">저장</button>
      <button type="button" class="no" onclick="qlMgrClose();">취소</button>
    </div>
  </div>
</div>

<script>
(function(){
  var cats = [], curCd = '', counts = {}, users = [];

  // 공통 첨부 위젯 — 자료실(LIBRARY). 문서키 = 분류코드라 분류를 고르는 즉시 열린다(저장 개념 없음).
  // 권한(canEdit)은 서버에서 늦게 오므로 일단 잠가 두고 mgrList 응답으로 푼다 —
  // 반대로 열어 두면 권한 없는 사람에게 [파일 추가]가 잠깐 보였다 사라진다.
  var fileBox = window.qpsFileBox({ mount:'qlFileBox', refGb:'LIBRARY',
      hint:'이 분류에 보관되는 파일', needSaveMsg:'왼쪽에서 분류를 먼저 선택하세요.',
      canEdit:false, readOnlyMsg:'보기 전용 — QPS 담당자만 올리고 지울 수 있습니다.',
      onChange: function(){ reloadCounts(); } });

  // ★hospCd 를 보내지 않는다(서버가 쿠키를 본다) · dataType:'json' 필수 — QPS 화면 공통 원칙
  function post(url, data){
    return $.ajax({ url:url, type:'POST', data:data, dataType:'json' }).then(function(res){
      if (res && res.result === 'FAIL') { throw new Error(res.message || '처리에 실패했습니다.'); }
      return res;
    });
  }
  function err(e){ try { _alertBox((e && e.message) || '처리 중 오류가 발생했습니다.', {icon:'⚠️'}); }
                   catch(x){ alert((e && e.message) || '오류'); } }
  function esc(s){ return (s==null?'':String(s)).replace(/[&<>"]/g, function(c){
      return ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;'})[c]; }); }

  function drawCats(){
    var box = document.getElementById('qlCats');
    if (!cats.length){ box.innerHTML = '<div class="ql-empty" style="padding:12px 4px;">분류가 없습니다.</div>'; return; }
    box.innerHTML = cats.map(function(c){
      var n = counts[c.subcode];
      return '<div class="ql-item' + (c.subcode === curCd ? ' on' : '') + '" data-cd="' + esc(c.subcode) + '">' +
               '<span class="nm">' + esc(c.subcodenm) + '</span>' +
               '<span class="cnt">' + (n ? n : '') + '</span>' +
             '</div>';
    }).join('');
    Array.prototype.forEach.call(box.querySelectorAll('.ql-item'), function(el){
      el.onclick = function(){ pick(el.getAttribute('data-cd')); };
    });
  }

  function pick(cd){
    curCd = cd || '';
    var c = null;
    for (var i=0;i<cats.length;i++) if (cats[i].subcode === curCd) c = cats[i];
    document.getElementById('qlTit').textContent = c ? c.subcodenm : '분류를 선택하세요';
    document.getElementById('qlDesc').textContent = c
      ? '이 분류에 보관된 자료입니다. 파일을 올리면 병원 전체가 같은 자료를 봅니다.'
      : '왼쪽에서 분류를 고르면 그 분류의 자료가 보입니다.';
    drawCats();
    if (fileBox) fileBox.setKey(curCd);
  }

  function reloadCounts(){
    post('/qps/fileCounts.do', { refGb:'LIBRARY' }).then(function(res){
      counts = res.counts || {}; drawCats();
    }).catch(function(){ /* 배지는 부가정보 — 실패해도 화면은 쓴다 */ });
  }

  // ── 권한 ─────────────────────────────────────────────────────────
  // 권한 사유별 안내 — "왜 되는지/왜 안 되는지"를 그대로 적는다.
  // 위너넷 계정에 '보기 전용'이라 써 놓고 버튼은 살아 있으면 모순으로 보인다(2026-08-10 지적).
  var PERM = {
    WNN:   { badge:'위너넷 계정 — 지원 목적 수정 가능', hint:'위너넷 계정이라 수정할 수 있습니다(지원 목적).' },
    MGR:   { badge:'',                                  hint:'QPS 담당자 — 이 분류에 보관되는 파일' },
    ADMIN: { badge:'담당자 미지정 — 병원 관리자가 수정', hint:'담당자가 지정되지 않아 병원 관리자가 수정합니다.' },
    NOMGR: { badge:'보기 전용 — 담당자 미지정',          hint:'담당자가 아직 없습니다. 병원 관리자에게 지정을 요청해 주세요.' },
    NONE:  { badge:'보기 전용 — QPS 담당자만 수정',      hint:'보기 전용 — QPS 담당자만 올리고 지울 수 있습니다.' }
  };

  function loadPerm(){
    return post('/qps/mgrList.do', {}).then(function(res){
      users = res.users || [];
      var p = PERM[res.why] || PERM.NONE;
      if (fileBox) fileBox.setEditable(!!res.canEdit, p.hint);
      var ro = document.getElementById('qlRo');
      ro.textContent = p.badge;
      ro.style.display = p.badge ? '' : 'none';
      // 위너넷·관리자 대행은 '경고'가 아니라 '알림' — 보기전용(주황)과 색을 구분한다.
      ro.style.background  = res.canEdit ? '#eef4f8' : '#fcf5e6';
      ro.style.borderColor = res.canEdit ? '#d3e0e9' : '#ecdcb8';
      ro.style.color       = res.canEdit ? '#4a6577' : '#8a6d3b';
      document.getElementById('qlMgrBtn').style.display = res.canMgr ? '' : 'none';
    });
  }

  window.qlMgrOpen = function(){
    var box = document.getElementById('qlMgrList');
    box.innerHTML = users.length ? users.map(function(u){
      var gu = ({'1':'위너넷관리자','2':'위너넷사용자','3':'병원관리자','4':'병원사용자'})[String(u.maingu)] || '';
      return '<label class="u"><input type="checkbox" value="' + esc(u.userid) + '"' +
             (u.mgryn === 'Y' ? ' checked' : '') + '>' +
             '<span>' + esc(u.usernm || u.userid) + '</span>' +
             '<span class="gu">' + esc(gu) + '</span></label>';
    }).join('') : '<div class="ql-empty" style="padding:14px 4px;">사용자가 없습니다.</div>';
    document.getElementById('qlMgrDim').style.display = 'block';
  };
  window.qlMgrClose = function(){ document.getElementById('qlMgrDim').style.display = 'none'; };
  window.qlMgrSave = function(){
    var ids = [];
    Array.prototype.forEach.call(document.querySelectorAll('#qlMgrList input:checked'),
        function(c){ ids.push(c.value); });
    post('/qps/mgrSave.do', { userIds: ids.join(',') }).then(function(){
      try { _toast(ids.length ? (ids.length + '명을 담당자로 지정했습니다.') : '담당자 지정을 모두 해제했습니다.'); } catch(e){}
      qlMgrClose();
      loadPerm();   // 내 권한도 바뀔 수 있다(스스로를 뺀 경우)
    }).catch(err);
  };

  function init(){
    loadPerm().catch(function(){ /* 권한 조회 실패 = 보기 전용 유지 */ });
    post('/qps/codeList.do', {}).then(function(res){
      var all = (res.codes || {});
      cats = all['QPS_LIB'] || [];
      drawCats();
      reloadCounts();
      if (cats.length) pick(cats[0].subcode);   // 첫 분류를 열어 둔다 — 빈 화면으로 시작하지 않게
    }).catch(err);
  }

  if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', init);
  else init();
})();

/* === 글자 크기 (2026-08-18 요청) ==========================================
   QI 계획서(qpsQiPlan)의 zzZoom 과 **같은 규칙** - 0.8~1.6배, 0.1 단위, ↺ 는 처음 크기.
   ★고른 크기는 **이 PC 이 브라우저에만** 남는다(localStorage). 키는 화면마다 따로 둔다. */
(function(){
  var W = 'qpsLib', ZKEY = 'qpsZoom_' + W;
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
