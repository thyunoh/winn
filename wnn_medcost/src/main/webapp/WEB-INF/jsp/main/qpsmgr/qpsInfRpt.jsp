<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%-- qpsInfRpt.jsp — 감염종합보고 (2026-08-10)
     원본 3종을 한 서식으로 묶었다(사용자 확정). 골격이 같기 때문 —
       P 감염관리 개선활동 계획 수립 : 기안서 + 첨부
       D 감염관리 개선활동 수행      : 기안서 + 교육결과 + 참석자 명단 + 첨부
       E 손위생 교육 결과 보고서     : 교육결과 + 참여위원 서명 + 첨부
     · 종류를 바꾸면 <쓰지 않는 칸은 숨긴다> — 표를 나누는 대신 칸을 감춘다.
     · ★주의: 이 파일 안에서 Deferred EL 표기(샵+중괄호) 금지 --%>

<script src="/asset/js/ui-message.js"></script>
<%@ include file="/WEB-INF/jsp/main/inc/qpsFileBox.jsp" %>

<div class="dashboard-wrapper">
<div id="qpsInfRpt" data-wnn="<c:out value='${wnnYn}'/>">
<style>
  #qpsInfRpt{ background:#f4f6f8; color:#1f2a30; min-height:100%; padding:14px 16px 60px; max-width:100%; overflow-x:hidden; }
  #qpsInfRpt *{ box-sizing:border-box; }
  #qpsInfRpt .ir-head{ display:flex; align-items:center; gap:10px; margin-bottom:12px; flex-wrap:wrap; }
  #qpsInfRpt .ir-title{ font-size:18px; font-weight:800; color:#20303a; display:flex; align-items:center; gap:8px; }
  #qpsInfRpt .ir-dot{ width:10px; height:10px; border-radius:50%; background:linear-gradient(135deg,#1f5a4b,#2a7665); }
  #qpsInfRpt .ir-sub{ font-size:12px; color:#6b7c86; }
  #qpsInfRpt .ir-hosp{ background:#e7f3ee; color:#1f5a4b; font-size:12px; font-weight:800;
      border:1px solid #cfe3da; border-radius:14px; padding:3px 11px; }
  #qpsInfRpt .ir-spacer{ flex:1; }
  #qpsInfRpt select, #qpsInfRpt input[type=text], #qpsInfRpt input[type=date], #qpsInfRpt textarea{
      border:1px solid #cfd8e0; border-radius:6px; padding:6px 9px; font-family:inherit; font-size:13px; background:#fff; width:100%; }
  #qpsInfRpt textarea{ min-height:80px; resize:vertical; line-height:1.6; }
  #qpsInfRpt .ir-btn{ border:1px solid #1f5a4b; background:#1f5a4b; color:#fff; border-radius:6px;
      padding:6px 14px; font-size:13px; font-weight:600; cursor:pointer; white-space:nowrap; }
  #qpsInfRpt .ir-btn.ghost{ background:#fff; color:#1f5a4b; }
  #qpsInfRpt .ir-btn.warn{ background:#fff; color:#b23b3b; border-color:#e0b4b4; }
  #qpsInfRpt .ir-btn.mini{ padding:2px 9px; font-size:11.5px; border-color:#cfd8e0; color:#556570; background:#fff; }

  #qpsInfRpt .ir-wrap{ display:flex; gap:14px; align-items:flex-start; }
  #qpsInfRpt .ir-left{ width:320px; flex:none; }
  #qpsInfRpt .ir-right{ flex:1; min-width:0; }
  #qpsInfRpt .ir-card{ background:#fff; border:1px solid #e3e9ed; border-radius:10px; padding:14px 16px; margin-bottom:12px; }
  #qpsInfRpt .ir-card h4{ margin:0 0 10px; font-size:14px; font-weight:800; color:#1f5a4b; }
  #qpsInfRpt .ir-card h4 .hint{ font-weight:500; font-size:12px; color:#8a99a3; }

  #qpsInfRpt .ir-list{ max-height:520px; overflow:auto; }
  #qpsInfRpt .ir-item{ padding:9px 11px; border:1px solid #eef2f5; border-radius:8px; margin-bottom:7px; cursor:pointer; }
  #qpsInfRpt .ir-item:hover{ border-color:#8fc3b2; background:#f7fbf9; }
  #qpsInfRpt .ir-item.on{ border-color:#1f5a4b; background:#f0f7f4; }
  #qpsInfRpt .ir-item .t{ font-size:13px; font-weight:700; color:#20303a; }
  #qpsInfRpt .ir-item .d{ font-size:11.5px; color:#8a99a3; margin-top:2px; }
  #qpsInfRpt .ir-empty{ color:#8a99a3; font-size:12.5px; padding:16px 6px; text-align:center; }

  #qpsInfRpt .ir-form{ display:grid; grid-template-columns:100px 1fr 100px 1fr; gap:9px 10px; align-items:start; }
  #qpsInfRpt .ir-form .lb{ font-size:12.5px; font-weight:700; color:#43555f; padding-top:8px; }
  #qpsInfRpt .ir-form .full{ grid-column:2 / -1; }
  #qpsInfRpt table.ed{ width:100%; border-collapse:collapse; font-size:12.5px; }
  #qpsInfRpt table.ed th{ background:#f2f6f8; border:1px solid #dde5ea; padding:5px 6px; font-weight:700; color:#43555f; }
  #qpsInfRpt table.ed td{ border:1px solid #e6ecef; padding:3px; }
  #qpsInfRpt table.ed input{ width:100%; border:none; background:transparent; padding:4px 5px; }
  #qpsInfRpt .rowdel{ color:#b23b3b; cursor:pointer; font-weight:700; text-align:center; width:26px; }
  /* ── 탭 · 글자 크기 (2026-08-15) — 카드가 세로로 쌓여 스크롤이 길다는 지적.
       ★한 화면에 들어가면 **탭을 내지 않는다**(고정으로 달지 않는다).
       ★탭 이름은 카드 제목에서 뽑고, 많으면 이웃끼리 묶어 **최대 4개**. */
  #qpsInfRpt .zz-tabs{ display:flex; gap:6px; margin:0 0 10px; flex-wrap:wrap; align-items:center; }
  #qpsInfRpt .zz-tab{ border:1px solid #cfd9e0; background:#f4f7f9; color:#43555f; border-radius:8px 8px 0 0;
                   padding:7px 15px; font-size:13.5px; font-weight:700; cursor:pointer; }
  #qpsInfRpt .zz-tab:hover{ background:#e9eff3; }
  #qpsInfRpt .zz-tab.on{ background:#1f5a4b; border-color:#1f5a4b; color:#fff; }
  #qpsInfRpt .zz-tab.dim{ opacity:.5; }
  #qpsInfRpt .zz-mode{ margin-left:auto; border:1px solid #1f5a4b; background:#fff; color:#1f5a4b;
                    border-radius:8px; padding:7px 14px; font-size:13px; font-weight:700; cursor:pointer; }
  #qpsInfRpt .zz-mode.on{ background:#1f5a4b; color:#fff; }
  #qpsInfRpt .zz-zoom{ display:inline-flex; gap:4px; align-items:center; margin-left:2px; }
  #qpsInfRpt .zz-zoom button{ border:1px solid #cfd9e0; background:#fff; color:#43555f; border-radius:6px;
                           padding:4px 9px; font-size:13px; font-weight:700; cursor:pointer; }
  #qpsInfRpt .zz-zoom button:hover{ background:#eef3f6; }
</style>

<div class="ir-head">
  <div class="ir-title"><span class="ir-dot"></span><span id="irTitle">감염관리 개선활동 계획 수립</span>
    <span class="ir-sub">감염종합보고</span></div>
  <span class="ir-hosp">🏥 <c:out value="${hospNm}" default="병원 미확인"/></span>
  <div class="ir-spacer"></div>
  <%-- 종류·년도는 오른쪽에 두되 <가장자리에서 들여> 놓는다.
       화면이 가로로 넘치는 구조라 맨 끝에 붙이면 잘린다(2026-08-10 실제로 겪음).
       아래 빈 칸(irPad)이 그만큼 안쪽으로 밀어 준다. --%>
  <select id="irGb" style="width:auto;" onchange="irList();">
    <option value="P">감염관리 개선활동 계획 수립</option>
    <option value="D">감염관리 개선활동 수행</option>
    <option value="E">손위생 교육 결과 보고서</option>
  </select>
  <select id="irYear" style="width:auto;" onchange="irList();"></select>
  <%-- 저장·삭제는 <상단>에 둔다 — QPS 화면 공통(2026-08-10 확정).
       종전에는 문서 맨 아래라 긴 서식에서 끝까지 내려가야 했다. --%>
  <button type="button" class="ir-btn" onclick="irSave();">저장</button>
  <button type="button" class="ir-btn warn" id="irDelBtn" onclick="irDel();" style="display:none;">삭제</button>
  <span class="ir-sub" id="irStat"></span>
  <span id="irPad" style="flex:0 0 96px;"></span>
  <%-- 글자 크기 — 이 PC 이 브라우저에만 저장된다 --%>
  <span class="zz-zoom">
    <button type="button" onclick="zzZoom(-1);" title="글자 작게">가－</button>
    <button type="button" onclick="zzZoom(1);"  title="글자 크게">가＋</button>
    <button type="button" onclick="zzZoom(0);"  title="처음 크기로">↺</button>
  </span>
</div>
<%-- ★탭 — 내용이 한 화면을 넘칠 때만 나온다(zzSync 가 재 본다) --%>
<div class="zz-tabs" id="zzTabs" style="display:none;"></div>

<div class="ir-wrap">
  <div class="ir-left">
    <div class="ir-card">
      <h4>문서 목록 <span class="hint" id="irCnt"></span></h4>
      <div class="ir-list" id="irListBox"><div class="ir-empty">불러오는 중…</div></div>
      <button type="button" class="ir-btn ghost" style="width:100%; margin-top:6px;" onclick="irNew();">＋ 새 문서</button>
    </div>
  </div>

  <div class="ir-right">
    <div class="ir-card" id="cardDraft">
      <h4>기안서 <span class="hint">— 인쇄물 결재란은 담당·과장·부장·원장 4칸</span></h4>
      <input type="hidden" id="f_rptSeq" value="">
      <div class="ir-form">
        <div class="lb">작성일 *</div>  <div><input type="date" id="f_rptDt"></div>
        <div class="lb">문서분류</div>  <div><input type="text" id="f_docCls" maxlength="60"></div>
        <div class="lb">문서번호</div>  <div><input type="text" id="f_docNo" maxlength="60"></div>
        <div class="lb">기안일자</div>  <div><input type="date" id="f_draftDt"></div>
        <div class="lb">기안자</div>    <div><input type="text" id="f_drafter" maxlength="50"></div>
        <div class="lb">부서</div>      <div><input type="text" id="f_deptNm" maxlength="60"></div>
        <div class="lb">위원장</div>    <div><input type="text" id="f_chairNm" maxlength="50"></div>
        <div class="lb">실장</div>      <div><input type="text" id="f_roomNm" maxlength="50"></div>
        <div class="lb">협조부서</div>  <div><input type="text" id="f_coopNm" maxlength="100"></div>
        <div class="lb">수신</div>      <div><input type="text" id="f_recvNm" maxlength="100"></div>
        <div class="lb">참조</div>      <div><input type="text" id="f_refNm" maxlength="100"></div>
        <div class="lb">발송일자</div>  <div><input type="date" id="f_sendDt"></div>
        <div class="lb">제목 *</div>    <div class="full"><input type="text" id="f_title" maxlength="200"></div>
        <div class="lb">본문</div>      <div class="full"><textarea id="f_body" style="min-height:140px;"></textarea></div>
      </div>
    </div>

    <div class="ir-card" id="cardEdu">
      <h4>교육 결과 <span class="hint">— 개선활동 수행·손위생 교육 결과 보고서에서 씁니다</span></h4>
      <div class="ir-form">
        <div class="lb">교육일시</div>   <div class="full"><input type="text" id="f_eduDt" maxlength="60" placeholder="예) 2026-08-05 14:00 ~ 15:00"></div>
        <div class="lb">교육자</div>     <div><input type="text" id="f_eduTeacher" maxlength="60"></div>
        <div class="lb">교육대상자</div> <div><input type="text" id="f_eduTarget" maxlength="200"></div>
        <div class="lb">주제</div>       <div class="full"><input type="text" id="f_eduTopic" maxlength="200"></div>
        <div class="lb">교육 결과</div>  <div class="full"><textarea id="f_eduBody" style="min-height:120px;"></textarea></div>
      </div>
    </div>

    <div class="ir-card" id="cardMem">
      <h4>참석자·서명 명단 <span class="hint">— 인쇄물의 서명란이 이 행들로 만들어집니다</span></h4>
      <table class="ed"><thead><tr>
        <th style="width:110px;">역할</th><th style="width:160px;">소속</th><th>성명</th><th style="width:26px;"></th>
      </tr></thead><tbody id="memBody"></tbody></table>
      <button type="button" class="ir-btn mini" style="margin-top:6px;" onclick="irMemAdd();">＋ 행 추가</button>
    </div>

    <div class="ir-card">
      <h4>첨부파일 <span class="hint">— 사진·근거자료</span></h4>
      <div id="irFileBox"></div>
    </div>

  </div>
</div>

<script>
(function(){
  var curSeq = 0, memIdx = 0;
  var GB_NM = { P:'감염관리 개선활동 계획 수립', D:'감염관리 개선활동 수행', E:'손위생 교육 결과 보고서' };
  function gb(){ var e=document.getElementById('irGb'); return e ? e.value : 'P'; }

  // 공통 첨부 — 감염종합보고(INFRPT) 문서키 = 문서 SEQ(저장 후 열림)
  var fileBox = window.qpsFileBox({ mount:'irFileBox', refGb:'INFRPT',
      hint:'사진·근거자료', needSaveMsg:'문서를 먼저 저장하면 첨부할 수 있습니다.' });

  // ★hospCd 를 보내지 않는다(서버가 쿠키를 본다) · dataType:'json' 필수 — QPS 화면 공통 원칙
  function post(url, data){
    return $.ajax({ url:url, type:'POST', data:data, dataType:'json' }).then(function(res){
      if (res && res.result === 'FAIL') { throw new Error(res.message || '처리에 실패했습니다.'); }
      return res;
    });
  }
  function err(e){ try{ _alertBox((e && e.message) || '처리 중 오류가 발생했습니다.', {icon:'❌'}); }catch(x){ alert(e && e.message); } }
  function esc(s){ return (s==null?'':String(s)).replace(/[&<>"]/g, function(c){
      return ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;'})[c]; }); }
  function val(id){ var e=document.getElementById(id); return e ? String(e.value).trim() : ''; }
  function set(id, v){ var e=document.getElementById(id); if(e) e.value = (v==null?'':v); }

  (function(){
    var y = new Date().getFullYear(), sel = document.getElementById('irYear');
    for (var i=y+1; i>=y-3; i--) sel.add(new Option(i+'년', i));
    sel.value = y;
  })();

  /* 종류에 따라 안 쓰는 칸을 감춘다 — 표를 나누지 않고 칸을 숨기는 쪽이 유지가 쉽다.
       P 계획수립 = 기안서만 / D 수행 = 기안서+교육+명단 / E 교육결과 = 교육+명단 */
  function applyGb(){
    var g = gb();
    document.getElementById('irTitle').textContent = GB_NM[g] || '감염종합보고';
    document.getElementById('cardDraft').style.display = (g === 'E') ? 'none' : '';
    document.getElementById('cardEdu').style.display   = (g === 'P') ? 'none' : '';
    document.getElementById('cardMem').style.display   = (g === 'P') ? 'none' : '';
  }

  function memAdd(r){
    r = r || {};
    var tb = document.getElementById('memBody');
    var tr = document.createElement('tr');
    tr.innerHTML =
      '<td><input type="text" data-f="rolenm" value="' + esc(r.rolenm) + '" placeholder="위원장 등"></td>' +
      '<td><input type="text" data-f="deptnm" value="' + esc(r.deptnm) + '"></td>' +
      '<td><input type="text" data-f="memnm" value="' + esc(r.memnm) + '"></td>' +
      '<td class="rowdel" onclick="this.closest(\'tr\').remove();">✕</td>';
    tb.appendChild(tr);
    memIdx++;
  }
  window.irMemAdd = function(){ memAdd({}); };

  function collectMem(){
    var out = [], sort = 0;
    document.querySelectorAll('#memBody tr').forEach(function(tr){
      var r = { sort: ++sort };
      tr.querySelectorAll('[data-f]').forEach(function(el){ r[el.getAttribute('data-f')] = String(el.value).trim(); });
      if (r.rolenm || r.deptnm || r.memnm) out.push(r);
    });
    return out;
  }

  window.irList = function(){
    applyGb();
    return post('/qps/infRptList.do', { rptGb: gb(), inYear: document.getElementById('irYear').value })
      .then(function(res){
        var list = res.list || [], box = document.getElementById('irListBox');
        document.getElementById('irCnt').textContent = list.length ? ('· ' + list.length + '건') : '';
        if (!list.length){ box.innerHTML = '<div class="ir-empty">문서가 없습니다.</div>'; return; }
        box.innerHTML = list.map(function(r){
          return '<div class="ir-item' + (Number(r.rptseq) === curSeq ? ' on' : '') + '" onclick="irOpen(' + r.rptseq + ');">' +
                 '<div class="t">' + esc(r.title || '(제목 없음)') + '</div>' +
                 '<div class="d">' + esc(r.rptdt) + (r.upddttm ? ' · 수정 ' + esc(r.upddttm) : '') + '</div></div>';
        }).join('');
      }).catch(err);
  };

  window.irOpen = function(seq){
    post('/qps/infRptGet.do', { rptSeq: seq }).then(function(res){
      var d = res.doc || {};
      curSeq = Number(d.rptseq || 0);
      set('f_rptSeq', d.rptseq); set('f_rptDt', d.rptdt); set('f_title', d.title);
      set('f_docCls', d.doccls); set('f_docNo', d.docno); set('f_draftDt', d.draftdt);
      set('f_drafter', d.drafter); set('f_deptNm', d.deptnm); set('f_chairNm', d.chairnm);
      set('f_roomNm', d.roomnm); set('f_coopNm', d.coopnm); set('f_recvNm', d.recvnm);
      set('f_refNm', d.refnm); set('f_sendDt', d.senddt); set('f_body', d.body);
      set('f_eduDt', d.edudt); set('f_eduTeacher', d.eduteacher); set('f_eduTarget', d.edutarget);
      set('f_eduTopic', d.edutopic); set('f_eduBody', d.edubody);
      document.getElementById('memBody').innerHTML = '';
      (res.members || []).forEach(memAdd);
      document.getElementById('irStat').textContent = '— 저장된 문서 #' + d.rptseq;
      document.getElementById('irDelBtn').style.display = '';
      if (fileBox) fileBox.setKey(d.rptseq);
      irList();
    }).catch(err);
  };

  window.irNew = function(){
    curSeq = 0;
    ['f_rptSeq','f_rptDt','f_title','f_docCls','f_docNo','f_draftDt','f_drafter','f_deptNm','f_chairNm',
     'f_roomNm','f_coopNm','f_recvNm','f_refNm','f_sendDt','f_body','f_eduDt','f_eduTeacher',
     'f_eduTarget','f_eduTopic','f_eduBody'].forEach(function(id){ set(id, ''); });
    document.getElementById('memBody').innerHTML = '';
    document.getElementById('irStat').textContent = '— 새 문서';
    document.getElementById('irDelBtn').style.display = 'none';
    if (fileBox) fileBox.setKey('');   // 저장 전엔 첨부 잠금
    irList();
  };

  window.irSave = function(){
    if (!val('f_rptDt')) { _alertBox('작성일을 입력해 주세요.', {icon:'⚠️'}); return; }
    post('/qps/infRptSave.do', {
      rptSeq: val('f_rptSeq'), rptGb: gb(), rptDt: val('f_rptDt'), title: val('f_title'),
      docCls: val('f_docCls'), docNo: val('f_docNo'), draftDt: val('f_draftDt'),
      drafter: val('f_drafter'), deptNm: val('f_deptNm'), chairNm: val('f_chairNm'),
      roomNm: val('f_roomNm'), coopNm: val('f_coopNm'), recvNm: val('f_recvNm'),
      refNm: val('f_refNm'), sendDt: val('f_sendDt'), body: val('f_body'),
      eduDt: val('f_eduDt'), eduTeacher: val('f_eduTeacher'), eduTarget: val('f_eduTarget'),
      eduTopic: val('f_eduTopic'), eduBody: val('f_eduBody'),
      members: JSON.stringify(collectMem())
    }).then(function(res){
      curSeq = Number(res.rptSeq || 0);
      set('f_rptSeq', curSeq);
      document.getElementById('irStat').textContent = '— 저장된 문서 #' + curSeq;
      document.getElementById('irDelBtn').style.display = '';
      if (fileBox) fileBox.setKey(curSeq);   // 저장 직후부터 첨부 가능
      _toast('저장되었습니다.', 'ok');
      irList();
    }).catch(err);
  };

  window.irDel = function(){
    if (!curSeq) return;
    _confirmBox({ msg:'이 문서를 삭제할까요?', icon:'⚠️', okText:'삭제', okColor:'#b23b3b',
      onOk: function(){
        post('/qps/infRptDelete.do', { rptSeq: curSeq }).then(function(){
          _toast('삭제되었습니다.', 'ok'); irNew();
        }).catch(err);
      } });
  };

  applyGb();
  irNew();
})();

  /* ═══ 탭 · 글자 크기 (2026-08-15 · 사용자 요청) ═══════════════════════════
     ★***고정으로 달지 않는다*** — 전부 펼친 높이를 재서 **한 화면을 넘칠 때만** 탭을 낸다.
       창 크기·글자 크기가 바뀌면 다시 잰다.
     ★탭이 **잘게 나뉘지 않게** 이웃 카드를 묶어 최대 4개. 이름은 첫 카드 제목(+「외」).
     ★「전체 보기」는 탭이 아니라 **보기 방식**이라 오른쪽 끝에 따로 둔다.
     ⚠인쇄는 별도 창이라 탭과 무관하다(숨긴 항목도 종이에는 다 나온다). */
  (function(){
    var KEY = 'qpsTab_qpsInfRpt', ZKEY = 'qpsZoom_qpsInfRpt', cur = 0;
    function cards(){ return [].slice.call(document.querySelectorAll('#qpsInfRpt .ir-card')); }
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
      var w = document.getElementById('qpsInfRpt');
      if (w) w.style.zoom = z.toFixed(2);
      return z;
    }
    window.zzZoom = function(d){
      var w = document.getElementById('qpsInfRpt'), c0 = parseFloat(w && w.style.zoom) || 1;
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
      var _mw = document.getElementById('qpsInfRpt'), _mt;
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
</div>
</div><%-- /.dashboard-wrapper --%>
