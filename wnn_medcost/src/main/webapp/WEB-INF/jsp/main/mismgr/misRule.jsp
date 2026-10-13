<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%-- misRule.jsp — 경영고객관리 › 병원 내규·안내문 (2026-10-12)
     · 내규 조회 : 병원이 올린 내규 본문에서만 찾아 답한다(근거 없으면 AI 를 부르지 않는다). 내규는 목록·편집·삭제.
     · 안내문 초안 : 신규 환자·보호자용 안내문 두 안. 금액·날짜·연락처는 빈칸으로 둔다. 💾 저장으로 보관하고 목록에서 다시 연다.
     · 알림은 ui-message. 주의: 이 파일 안에서 Deferred EL 표기(샵+중괄호) 금지 --%>

<script src="/asset/js/ui-message.js"></script>

<div class="dashboard-wrapper">
<div id="misRule" data-wnn="<c:out value='${wnnYn}'/>" data-hosp="<c:out value='${hospCd}'/>" data-nm="<c:out value='${hospNm}'/>">
<style>
  #misRule{ background:#f4f6f8; color:#1f2a30; min-height:100%; padding:14px 16px 50px; max-width:100%; overflow-x:hidden; }
  #misRule *{ box-sizing:border-box; }
  #misRule .mr-head{ display:flex; align-items:center; gap:10px; margin-bottom:12px; flex-wrap:wrap; }
  #misRule .mr-title{ font-size:18px; font-weight:800; color:#20303a; }
  #misRule .mr-hosp{ background:#e7f3ee; color:#1f5a4b; font-size:12px; font-weight:800; border:1px solid #cfe3da; border-radius:14px; padding:3px 11px; }
  #misRule .mr-tabs{ display:flex; gap:6px; margin-bottom:12px; }
  #misRule .mr-tab{ border:1px solid #cfd9e0; background:#fff; color:#43555f; border-radius:8px; padding:7px 14px; font-size:13px; font-weight:800; cursor:pointer; }
  #misRule .mr-tab.on{ background:#1f5a4b; color:#fff; border-color:#1f5a4b; }
  #misRule .mr-card{ background:#fff; border:1px solid #e3e9ed; border-radius:10px; padding:12px 14px; min-width:0; margin-bottom:12px; }
  #misRule .mr-card h4{ margin:0 0 10px; font-size:13.5px; color:#20303a; font-weight:800; display:flex; gap:8px; align-items:center; flex-wrap:wrap; }
  #misRule .mr-card h4 small{ font-weight:400; color:#6b7c86; font-size:12px; }
  #misRule .sp{ flex:1; }
  #misRule .mr-row{ display:flex; gap:8px; align-items:center; flex-wrap:wrap; }
  #misRule input, #misRule select, #misRule textarea{ border:1px solid #cfd8e0; border-radius:6px; padding:6px 9px; font-size:13.5px; background:#fff; font-family:inherit; color:#1f2a30; }
  #misRule input[type=text], #misRule input:not([type]){ flex:1; min-width:180px; }
  #misRule textarea{ width:100%; min-height:90px; resize:vertical; line-height:1.55; }
  #misRule .mr-lbl{ display:block; font-size:12.5px; color:#43555f; font-weight:700; margin:8px 0 4px; }
  #misRule .mr-grid{ display:grid; grid-template-columns:1fr 1fr; gap:10px; }
  #misRule .mr-grid label{ font-size:12.5px; color:#43555f; font-weight:700; display:flex; flex-direction:column; gap:4px; }
  #misRule .mr-btn{ border:1px solid #cfd9e0; background:#fff; color:#43555f; border-radius:6px; padding:6px 13px; font-size:12.5px; font-weight:700; cursor:pointer; white-space:nowrap; }
  #misRule .mr-btn:hover{ background:#eef3f6; }
  #misRule .mr-btn.pri{ background:#1f5a4b; color:#fff; border-color:#1f5a4b; }
  #misRule .mr-btn.pri:hover{ background:#2a7665; }
  #misRule .mr-btn.del{ color:#b23b3b; }
  #misRule .mr-btn.sm{ padding:3px 9px; font-size:12px; }
  #misRule .mr-split{ display:grid; grid-template-columns:minmax(220px,300px) 1fr; gap:12px; align-items:start; }
  @media (max-width:900px){ #misRule .mr-split{ grid-template-columns:1fr; } #misRule .mr-grid{ grid-template-columns:1fr; } }
  #misRule .mr-item{ border:1px solid #e3e9ed; border-radius:8px; padding:8px 10px; margin-bottom:6px; cursor:pointer; background:#fbfcfd; display:flex; flex-direction:column; gap:2px; }
  #misRule .mr-item:hover{ background:#f0f6f3; }
  #misRule .mr-item.on{ border-color:#2a7665; background:#e7f3ee; }
  #misRule .mr-item b{ font-size:13px; color:#20303a; }
  #misRule .mr-item span{ font-size:11.5px; color:#6b7c86; }
  #misRule .mr-empty{ color:#6b7c86; font-size:12.5px; padding:10px 2px; line-height:1.6; }
  #misRule .mr-wait{ color:#6b7c86; font-size:13px; padding:8px 2px; }
  #misRule .mr-warn{ background:#fff7e6; border:1px solid #f1d9a6; color:#7a5a12; border-radius:8px; padding:9px 12px; font-size:13px; line-height:1.6; }
  #misRule .mr-answer{ background:#f3f8f6; border:1px solid #cfe3da; border-radius:8px; padding:10px 12px; font-size:13.5px; line-height:1.7; color:#1f2a30; }
  #misRule .mr-refs{ margin-top:8px; font-size:12px; color:#6b7c86; }
  #misRule .mr-draft{ border:1px solid #e3e9ed; border-radius:8px; padding:10px 12px; margin-top:10px; background:#fbfcfd; }
  #misRule .mr-dh{ display:flex; align-items:center; gap:8px; margin-bottom:6px; font-size:13px; color:#20303a; }
  #misRule .mr-dh .sp{ flex:1; }
  #misRule .mr-pre{ margin:0; white-space:pre-wrap; word-break:keep-all; font-family:inherit; font-size:14px; line-height:1.75; color:#1f2a30; }
  #misRule .mr-helpbtn{ margin-left:auto; border:1px solid #cfd9e0; background:#fff; color:#1f5a4b; border-radius:8px; padding:7px 13px; font-size:13px; font-weight:800; cursor:pointer; }
  #misRule .mr-helpbtn:hover{ background:#eef3f6; }
  #misRule .mr-help{ background:#fbfdfc; border:1px solid #cfe3da; border-radius:10px; padding:12px 16px; margin-bottom:12px; font-size:13px; line-height:1.7; color:#1f2a30; }
  #misRule .mr-help-in b{ color:#1f5a4b; }
  #misRule .mr-help ol{ margin:6px 0 0; padding-left:20px; }
  #misRule .mr-help li{ margin-bottom:6px; }
  #misRule .mr-doc{ min-height:340px; line-height:1.7; font-size:14px; resize:vertical; }
  #misRule .mr-title-in{ width:100%; margin:6px 0 4px; font-weight:700; }
  #misRule .mr-item.mr-flash{ animation: mrFlash 2.4s ease-out 1; }
  @keyframes mrFlash { 0% { background:#ffe9a8; box-shadow:0 0 0 3px #f5c542; } 100% { background:#fbfcfd; box-shadow:none; } }
  #misRule .mr-loading{ display:flex; align-items:center; gap:10px; background:#eef7f3; border:1px solid #bfdccf; border-radius:8px; padding:12px 14px; margin-top:10px; font-size:13.5px; font-weight:700; color:#1f5a4b; }
  #misRule .mr-spin{ width:16px; height:16px; flex:0 0 auto; border:2px solid #bfdccf; border-top-color:#1f5a4b; border-radius:50%; animation: mrSpin .8s linear infinite; }
  @keyframes mrSpin { to { transform: rotate(360deg); } }
  #misRule #mrDrafts{ display:grid; grid-template-columns:repeat(2,minmax(0,1fr)); gap:12px; align-items:start; }
  #misRule #mrDrafts > .mr-draft{ margin-top:0; min-width:0; }
  #misRule #mrDrafts > .mr-loading, #misRule #mrDrafts > .mr-warn, #misRule #mrDrafts > .mr-empty{ grid-column:1 / -1; }
  @media (max-width:900px){ #misRule #mrDrafts{ grid-template-columns:1fr; } }
  #misRule #mrDrafts > .mr-draft.mr-wide{ grid-column:1 / -1; }
  #misRule #mrDrafts .mr-draft.mr-wide .mr-doc{ min-height:600px; font-size:16px; }
  #misRule .mr-note-tog{ border:none; background:none; padding:6px 0; font-size:12.5px; font-weight:700; color:#43555f; cursor:pointer; }
  #misRule .mr-note-tog:hover{ color:#1f5a4b; }
</style>

<div class="mr-head">
  <div class="mr-title">📚 병원 내규 · 안내문</div>
  <span class="mr-hosp"><c:out value="${hospNm}"/></span>
</div>

<div class="mr-tabs">
  <button type="button" class="mr-tab on" data-tab="rule">📚 내규 조회</button>
  <button type="button" class="mr-tab" data-tab="leaf">✉ 안내문 초안</button>
  <button type="button" class="mr-helpbtn" id="mrHelpBtn">❔ 도움말</button>
</div>
<!-- 도움말 — 누른 탭의 설명만 보인다 -->
<div id="mrHelp" class="mr-help" hidden>
  <div id="mrHelpRule" class="mr-help-in">
    <b>내규 조회 도움말</b>
    <ol>
      <li><b>하는 일</b> : 병원이 등록한 내규에서 질문에 맞는 내용을 찾아 답합니다.</li>
      <li><b>찾는 순서</b> : ① 질문의 낱말과 겹치는 내규를 고릅니다(AI 사용 안 함) → ② 겹치는 내규가 없으면 "찾지 못했습니다"라고만 보여 줍니다(AI 사용 안 함) → ③ 있으면 그 내규 본문만 AI가 읽고 답을 정리합니다.</li>
      <li><b>AI가 하는 일</b> : 찾아 낸 내규 본문을 읽고 답을 문장으로 정리하는 것까지입니다. 내규 밖을 찾아보거나 없는 규정을 만들지 않습니다.</li>
      <li><b>쓰는 법</b> : 「＋ 새 내규」 → 이름과 본문 붙여 넣기 → [저장] → 위쪽 칸에 질문.</li>
      <li><b>주의</b> : 본문에 금액·기한이 있어야 답할 수 있습니다. 제목만 있으면 답이 나오지 않습니다. 이름·주민번호는 AI에 보내기 전에 가려지지만, 본문에 넣지 않는 것이 안전합니다.</li>
    </ol>
  </div>
  <div id="mrHelpLeaf" class="mr-help-in" hidden>
    <b>안내문 초안 도움말</b>
    <ol>
      <li><b>하는 일</b> : 신규 환자·보호자에게 나눠 줄 안내문 초안을 두 안으로 만듭니다. 문장은 AI가 씁니다.</li>
      <li><b>쓰는 법</b> : 대상·주제 고르기 → 추가로 담을 내용(선택) 입력 → [초안 만들기] → 마음에 드는 안의 [복사] → 한글·워드·홍보물에 붙여 넣기.</li>
      <li><b>AI가 하지 않는 일</b> : 금액·날짜·전화번호·주소를 채우지 않습니다. 그 자리는 [ ] 빈칸으로 남으니 직접 채우세요.</li>
      <li><b>저장</b> : 💾 저장으로 이름을 붙여 보관합니다. 아래 「저장한 안내문」에서 다시 열어 고치거나 지울 수 있습니다. 복사는 글자만 복사됩니다.</li>
      <li><b>확인</b> : AI 초안이므로 담당자가 한 번 읽고 확인한 뒤 나눠 주세요. 의료 판단이나 처방 내용은 들어가지 않습니다.</li>
    </ol>
  </div>
</div>


<!-- ═══ 내규 조회 ═══ -->
<div id="mrPaneRule">
  <div class="mr-card">
    <h4>내규에 물어보기 <small>병원이 등록한 내규 본문에서만 찾아 답합니다. 등록된 내용이 없으면 답하지 않습니다.</small></h4>
    <div class="mr-row">
      <input type="text" id="mrQ" maxlength="300" placeholder="예) 경조사비는 얼마 지급하나요?">
      <button type="button" class="mr-btn pri" id="mrAskBtn">찾아보기</button>
    </div>
    <div id="mrAns" class="mr-wait" hidden></div>
  </div>

  <div class="mr-split">
    <div class="mr-card">
      <h4>등록된 내규 <span class="sp"></span><button type="button" class="mr-btn sm pri" id="mrNewBtn">＋ 새 내규</button></h4>
      <div id="mrItems"><div class="mr-empty">불러오는 중…</div></div>
    </div>
    <div class="mr-card">
      <h4 id="mrEdTitle">새 내규</h4>
      <input type="text" id="mrTitle" maxlength="200" placeholder="내규 이름 (예: 경조사비 지급 규정)" style="width:100%;">
      <textarea id="mrBody" style="margin-top:8px;" placeholder="내규 본문을 붙여 넣으세요. 줄바꿈은 그대로 저장됩니다."></textarea>
      <div class="mr-row" style="margin-top:8px;">
        <span class="sp"></span>
        <button type="button" class="mr-btn del" id="mrDelBtn" hidden>삭제</button>
        <button type="button" class="mr-btn pri" id="mrSaveBtn">저장</button>
      </div>
    </div>
  </div>
</div>

<!-- ═══ 안내문 초안 ═══ -->
<div id="mrPaneLeaf" hidden>
  <div class="mr-card">
    <h4>안내문 초안 <small>개인정보·금액·연락처는 넣지 않고 빈칸으로 둡니다. 💾 저장하면 아래 목록에서 다시 열어 고칠 수 있습니다.</small></h4>
    <div class="mr-grid">
      <label>대상
        <select id="mrAud">
          <option>신규 입원 환자</option>
          <option>환자 보호자</option>
          <option>면회 오시는 분</option>
        </select>
      </label>
      <label>주제
        <select id="mrTop">
          <option>입원 안내</option>
          <option>입원 준비물 안내</option>
          <option>면회 안내</option>
          <option>외출·외박 안내</option>
          <option>입원 비용 안내(금액은 빈칸)</option>
        </select>
      </label>
    </div>
    <div class="mr-row" style="justify-content:flex-end;margin-top:4px;">
      <button type="button" class="mr-btn pri" id="mrDraftBtn">초안 만들기</button>
      <button type="button" class="mr-btn" id="mrDraftClose" hidden>✕ 닫기</button>
    </div>
    <button type="button" class="mr-note-tog" id="mrNoteTog" aria-expanded="false">▸ 추가로 담을 내용 (선택)</button>
    <div id="mrNoteBox" hidden>
      <textarea id="mrNote" maxlength="500" placeholder="예) 면회는 오후 2시~6시, 1인 1보호자"></textarea>
    </div>
    <div id="mrDrafts"></div>
  </div>
  <div class="mr-card">
    <h4>저장한 안내문 <span class="sp"></span><small>눌러서 열면 고쳐 저장하거나 지울 수 있습니다.</small></h4>
    <div id="mrLeafList"><div class="mr-empty">불러오는 중…</div></div>
    <div id="mrLeafView" hidden style="margin-top:12px;">
      <input type="text" id="mrLeafTitle" maxlength="200" style="width:100%;">
      <textarea id="mrLeafBody" class="mr-doc" style="margin-top:8px;"></textarea>
      <div class="mr-row" style="margin-top:8px;">
        <span class="sp"></span>
        <button type="button" class="mr-btn del" id="mrLeafDel">삭제</button>
        <button type="button" class="mr-btn" id="mrLeafCopy">복사</button>
        <button type="button" class="mr-btn pri" id="mrLeafSave">고쳐 저장</button>
      </div>
    </div>
  </div>
</div>

</div>
</div>

<script>
(function(){
  var WRAP = document.getElementById('misRule');
  if (!WRAP) return;
  var WNN = WRAP.getAttribute('data-wnn') === 'Y';
  var HOSP = WRAP.getAttribute('data-hosp');
  var LIST = [];
  var CUR = null;          // 고르고 있는 내규 { ruleSeq }
  var DRAFTS = [];

  function gel(id){ return document.getElementById(id); }
  function esc(s){ return String(s == null ? '' : s).replace(/[&<>"']/g, function(c){ return {'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c]; }); }
  function withHosp(p){ if (WNN) p.hospCd = HOSP; return p; }
  function post(url, data){
    return $.ajax({ url: url, type: 'POST', data: withHosp(data), dataType: 'json' }).then(function(res){
      if (!res || res.result !== 'OK') throw new Error((res && res.message) || '처리 중 오류가 발생했습니다.');
      return res;
    });
  }
  function err(e){ _alertBox((e && e.message) ? e.message : '처리 중 오류가 발생했습니다.', {icon:'❌'}); }

  /* ── 탭 ── */
  document.querySelectorAll('#misRule .mr-tab').forEach(function(t){
    t.onclick = function(){
      document.querySelectorAll('#misRule .mr-tab').forEach(function(x){ x.classList.remove('on'); });
      t.classList.add('on');
      var k = t.getAttribute('data-tab');
      gel('mrPaneRule').hidden = (k !== 'rule');
      gel('mrPaneLeaf').hidden = (k !== 'leaf');
      gel('mrHelpRule').hidden = (k !== 'rule');
      gel('mrHelpLeaf').hidden = (k !== 'leaf');
    };
  });

  gel('mrHelpBtn').onclick = function(){ gel('mrHelp').hidden = !gel('mrHelp').hidden; };

  /* ── 내규 목록 · 편집 ── */
  function drawList(){
    if (!LIST.length) { gel('mrItems').innerHTML = '<div class="mr-empty">아직 등록된 내규가 없습니다. ＋ 새 내규를 눌러 본문을 붙여 넣으세요.</div>'; return; }
    var h = '';
    LIST.forEach(function(r){
      var on = CUR && String(CUR.ruleSeq) === String(r.ruleSeq) ? ' on' : '';
      h += '<div class="mr-item' + on + '" data-seq="' + esc(r.ruleSeq) + '"><b>' + esc(r.title) + '</b><span>' + esc(r.upddttm) + '</span></div>';
    });
    gel('mrItems').innerHTML = h;
  }
  function loadList(){
    return post('<c:url value="/mis/ruleList.do"/>', {}).then(function(res){ LIST = res.list || []; drawList(); }).catch(err);
  }
  function setEditor(r){
    CUR = r ? { ruleSeq: r.ruleSeq } : null;
    gel('mrTitle').value = r ? (r.title || '') : '';
    gel('mrBody').value = r ? (r.body || '') : '';
    gel('mrEdTitle').textContent = r ? '내규 고치기' : '새 내규';
    gel('mrDelBtn').hidden = !r;
    drawList();
  }
  gel('mrItems').addEventListener('click', function(e){
    var it = e.target.closest ? e.target.closest('.mr-item') : null;
    if (!it) return;
    var seq = it.getAttribute('data-seq');
    var hit = LIST.filter(function(x){ return String(x.ruleSeq) === seq; })[0];
    if (hit) setEditor(hit);
  });
  gel('mrNewBtn').onclick = function(){ setEditor(null); gel('mrTitle').focus(); };
  gel('mrSaveBtn').onclick = function(){
    var t = gel('mrTitle').value.trim();
    if (!t) { _alertBox('내규 이름을 적어 주세요.', {icon:'⚠️'}); gel('mrTitle').focus(); return; }
    post('<c:url value="/mis/ruleSave.do"/>', { ruleSeq: CUR ? CUR.ruleSeq : 0, title: t, body: gel('mrBody').value })
      .then(function(res){ _toast('저장했습니다.', 'ok'); CUR = { ruleSeq: res.ruleSeq }; gel('mrEdTitle').textContent = '내규 고치기'; gel('mrDelBtn').hidden = false; return loadList(); })
      .catch(err);
  };
  gel('mrDelBtn').onclick = function(){
    if (!CUR) return;
    _confirmBox({ msg: '이 내규를 지울까요? 목록에서 빠지고 AI 답변에도 쓰이지 않습니다.', icon: '🗑️', okText: '지우기', okColor: '#b23b3b',
      onOk: function(){
        post('<c:url value="/mis/ruleDel.do"/>', { ruleSeq: CUR.ruleSeq })
          .then(function(){ _toast('지웠습니다.', 'ok'); setEditor(null); return loadList(); })
          .catch(err);
      } });
  };

  /* ── 내규에 물어보기 ── */
  function ask(){
    var q = gel('mrQ').value.trim();
    if (q.length < 2) { _alertBox('질문을 두 글자 이상 적어 주세요.', {icon:'⚠️'}); return; }
    var box = gel('mrAns');
    box.hidden = false; box.className = 'mr-wait'; box.innerHTML = '내규를 찾아보는 중입니다…';
    post('<c:url value="/mis/ruleAsk.do"/>', { q: q }).then(function(res){
      if (!res.ok) { box.className = 'mr-warn'; box.innerHTML = esc(res.reason || '질문을 다시 확인해 주세요.'); return; }
      var h = '';
      if (res.answer) { h += '<div class="mr-answer">' + esc(res.answer).replace(/\n/g, '<br>') + '</div>'; }
      else { h += '<div class="mr-warn">AI 답변을 받지 못했습니다. 아래 근거 내규를 직접 보세요.</div>'; }
      if (res.refs && res.refs.length) h += '<div class="mr-refs">근거 내규 : ' + res.refs.map(function(t){ return esc(t); }).join(' · ') + '</div>';
      box.className = ''; box.innerHTML = h;
    }).catch(function(e){ box.className = 'mr-warn'; box.innerHTML = esc(e.message); });
  }
  gel('mrAskBtn').onclick = ask;
  gel('mrQ').addEventListener('keydown', function(e){ if (e.key === 'Enter') ask(); });

  // 추가 내용 칸 접기·펼치기 (접혀 있어도 입력한 내용은 초안 만들기에 그대로 간다)
  gel('mrNoteTog').onclick = function(){
    var box = gel('mrNoteBox');
    var open = box.hidden;
    box.hidden = !open;
    this.setAttribute('aria-expanded', open ? 'true' : 'false');
    this.textContent = (open ? '▾ ' : '▸ ') + '추가로 담을 내용 (선택)';
  };

  /* ── 안내문 초안 · 저장 ── */
  var LEAF_LIST_URL = '<c:url value="/mis/leafList.do"/>';
  var LEAF_GET_URL = '<c:url value="/mis/leafGet.do"/>';
  var LEAF_SAVE_URL = '<c:url value="/mis/leafSave.do"/>';
  var LEAF_DEL_URL = '<c:url value="/mis/leafDel.do"/>';
  var LEAF_CUR = null;      // 열어 둔 저장 안내문 번호
  var LEAF_FLASH = null;    // 방금 저장한 안내문 번호(목록에서 강조한다)
  var LEAF_ROWS = [];       // 저장 목록(화면 표시용)

  // 마크다운 기호(**, #, ---, 목록 *)를 걷어 낸 평문으로 바꾼다.
  function plainText(src){
    var out = String(src == null ? '' : src).split('\n').map(function(line){
      var t = line.replace(/\*\*(.+?)\*\*/g, '$1').replace(/__(.+?)__/g, '$1').replace(/`([^`]+)`/g, '$1');
      t = t.replace(/^\s*[#]{1,6}\s*/, '');
      t = t.replace(/^\s*[\*\-]\s+/, '· ');
      return t.replace(/\s+$/, '');
    });
    return out.filter(function(line){ return !/^\s*(-{3,}|\*{3,}|_{3,})\s*$/.test(line); })
      .join('\n').replace(/\n{3,}/g, '\n\n').trim();
  }
  function draftTa(i){ return gel('mrDrafts').querySelector('textarea[data-ed="' + i + '"]'); }
  function draftTitle(i){ return gel('mrDrafts').querySelector('input[data-title="' + i + '"]'); }

  // 복사 — 글자만 복사한다(기존 방식)
  function copyText(txt){
    txt = String(txt || '').replace(/\n{3,}/g, '\n\n').trim();
    if (!txt) return;
    if (navigator.clipboard && navigator.clipboard.writeText) {
      navigator.clipboard.writeText(txt).then(function(){ _toast('복사했습니다.', 'ok'); },
        function(){ _alertBox('복사하지 못했습니다. 글을 직접 골라 복사해 주세요.', {icon:'⚠️'}); });
    } else {
      _alertBox('이 브라우저에서는 자동 복사가 안 됩니다. 글을 직접 골라 복사해 주세요.', {icon:'⚠️'});
    }
  }
  function copyDraft(i){ var ta = draftTa(i); copyText(ta ? ta.value : ''); }

  // 초안을 이름을 붙여 저장한다. 빈칸 [ ] 이 남아 있으면 한 번 묻는다(막지는 않는다). 저장 중에는 한 번만 보낸다.
  var LEAF_BUSY = false;
  function removeDraftCard(card){
    if (!card) return;
    var box = card.parentNode;
    card.remove();
    if (box && !box.querySelector('.mr-draft')) {
      box.innerHTML = '';
      gel('mrDraftClose').hidden = true;
    }
  }
  function saveDraft(i){
    if (LEAF_BUSY) return;
    var ta = draftTa(i), ti = draftTitle(i);
    var body = ta ? ta.value.replace(/\n{3,}/g, '\n\n').trim() : '';
    var title = ti ? ti.value.trim() : '';
    if (!body) { _alertBox('저장할 글이 없습니다.', {icon:'⚠️'}); return; }
    if (!title) { _alertBox('저장 이름을 적어 주세요.', {icon:'⚠️'}); if (ti) ti.focus(); return; }
    var card = ta ? ta.closest('.mr-draft') : null;
    function release(){ LEAF_BUSY = false; }
    function go(){
      LEAF_BUSY = true;
      post(LEAF_SAVE_URL, { leafSeq: 0, title: title, audience: ti.getAttribute('data-aud') || '', topic: ti.getAttribute('data-top') || '', body: body })
        .then(function(res){ _toast('저장했습니다.', 'ok'); LEAF_FLASH = res.leafSeq; removeDraftCard(card); return loadLeafList().then(function(){ openLeaf(res.leafSeq); }); })
        .catch(err)
        .always(release);
    }
    if (/\[\s*\]/.test(body)) {
      _confirmBox({ msg: '아직 채우지 않은 빈칸 [ ] 이 남아 있습니다. 그래도 저장할까요?', icon: '⚠️', okText: '저장', onOk: go, onCancel: release });
    } else { go(); }
  }

  var DRAFT_URL = '<c:url value="/mis/leafletDraft.do"/>';
  gel('mrDraftBtn').onclick = function(){
    var btn = this;
    if (btn.disabled) return;
    var box = gel('mrDrafts');
    var t0 = Date.now();
    btn.disabled = true;
    box.innerHTML = '<div class="mr-loading" id="mrWait"><span class="mr-spin"></span><span class="mr-loading-txt">초안을 만드는 중입니다… 0초</span></div>';
    // 경과 초를 보여 준다 — 보통 10~40초 걸리므로 그동안 이 메뉴를 떠나지 않도록 안내한다
    var timer = setInterval(function(){
      var w = gel('mrWait');
      if (w) w.querySelector('.mr-loading-txt').textContent = '초안을 만드는 중입니다… ' + Math.round((Date.now() - t0) / 1000) + '초 (보통 10~40초 걸립니다. 끝날 때까지 이 화면에 머물러 주세요.)';
    }, 1000);
    var aud = gel('mrAud').value, top = gel('mrTop').value;
    post(DRAFT_URL, { audience: aud, topic: top, note: gel('mrNote').value.trim() })
      .then(function(res){
        if (!res.ok || !res.drafts || !res.drafts.length) { box.innerHTML = '<div class="mr-warn">' + esc(res.reason || 'AI 초안을 받지 못했습니다.') + '</div>'; return; }
        var list = res.drafts.map(plainText);
        box.innerHTML = list.map(function(d, i){
          return '<div class="mr-draft"><div class="mr-dh"><b>' + (i + 1) + '안</b><span class="sp"></span>'
            + '<button type="button" class="mr-btn sm" data-save="' + i + '">💾 저장</button>'
            + '<button type="button" class="mr-btn sm" data-zoom="' + i + '">⤢ 크게</button>'
            + '<button type="button" class="mr-btn sm pri" data-copy="' + i + '">복사</button></div>'
            + '<input type="text" class="mr-title-in" data-title="' + i + '" maxlength="200">'
            + '<textarea class="mr-doc" data-ed="' + i + '"></textarea></div>';
        }).join('');
        // 값은 속성으로 넣는다(HTML 로 쓰면 특수문자가 깨진다)
        box.querySelectorAll('textarea.mr-doc').forEach(function(ta, i){ ta.value = list[i]; });
        box.querySelectorAll('input[data-title]').forEach(function(ti){
          ti.value = aud + ' · ' + top;
          ti.setAttribute('data-aud', aud); ti.setAttribute('data-top', top);
        });
      })
      .catch(function(e){ box.innerHTML = '<div class="mr-warn">' + esc(e.message) + '</div>'; })
      .always(function(){ clearInterval(timer); btn.disabled = false; gel('mrDraftClose').hidden = !gel('mrDrafts').innerHTML; });
  };

  // 초안 닫기 — 저장하지 않은 글이 있으면 한 번 묻는다
  function closeDrafts(){
    gel('mrDrafts').innerHTML = '';
    gel('mrDraftClose').hidden = true;
  }
  gel('mrDraftClose').onclick = function(){
    if (gel('mrDrafts').querySelector('textarea.mr-doc')) {
      _confirmBox({ msg: '저장하지 않은 초안이 있습니다. 닫으면 고친 글이 사라집니다. 닫을까요?', icon: '⚠️', okText: '닫기', okColor: '#b23b3b', onOk: closeDrafts });
    } else { closeDrafts(); }
  };

  gel('mrDrafts').addEventListener('click', function(e){
    var t = e.target;
    var s = t.getAttribute ? t.getAttribute('data-save') : null;
    if (s !== null) { saveDraft(Number(s)); return; }
    var z = t.getAttribute ? t.getAttribute('data-zoom') : null;
    if (z !== null) {
      var card = t.closest('.mr-draft');
      card.classList.toggle('mr-wide');
      t.textContent = card.classList.contains('mr-wide') ? '⤡ 줄이기' : '⤢ 크게';
      return;
    }
    var k = t.getAttribute ? t.getAttribute('data-copy') : null;
    if (k !== null) copyDraft(Number(k));
  });

  /* 저장한 안내문 목록 · 열어서 고치기 */
  // 방금 저장한 항목을 목록 위치로 옮겨 잠깐 강조한다
  function flashLeaf(){
    if (!LEAF_FLASH) return;
    var box = gel('mrLeafList');
    var el = box.querySelector('[data-leaf="' + LEAF_FLASH + '"]');
    LEAF_FLASH = null;
    if (!el) return;
    el.classList.add('mr-flash');
    box.parentNode.scrollIntoView({ behavior: 'smooth', block: 'center' });
    setTimeout(function(){ el.classList.remove('mr-flash'); }, 2600);
  }

  function loadLeafList(){
    return post(LEAF_LIST_URL, {}).then(function(res){ LEAF_ROWS = res.list || []; drawLeafList(); flashLeaf(); }).catch(err);
  }
  function drawLeafList(){
    var box = gel('mrLeafList');
    if (!LEAF_ROWS.length) { box.innerHTML = '<div class="mr-empty">저장한 안내문이 없습니다. 초안 옆 💾 저장을 누르면 여기에 모입니다.</div>'; return; }
    box.innerHTML = LEAF_ROWS.map(function(r){
      var on = LEAF_CUR && String(LEAF_CUR) === String(r.leafSeq) ? ' on' : '';
      var sub = [r.audience, r.topic, r.upddttm].filter(function(x){ return !!x; }).join(' · ');
      return '<div class="mr-item' + on + '" data-leaf="' + esc(r.leafSeq) + '"><b>' + esc(r.title) + '</b><span>' + esc(sub) + '</span></div>';
    }).join('');
  }
  gel('mrLeafList').addEventListener('click', function(e){
    var it = e.target.closest ? e.target.closest('.mr-item') : null;
    if (it) openLeaf(it.getAttribute('data-leaf'));
  });
  function openLeaf(seq){
    post(LEAF_GET_URL, { leafSeq: seq }).then(function(res){
      var r = res.leaf;
      if (!r) return;
      LEAF_CUR = r.leafSeq;
      gel('mrLeafTitle').value = r.title || '';
      gel('mrLeafBody').value = r.body || '';
      gel('mrLeafView').hidden = false;
      drawLeafList();
    }).catch(err);
  }
  gel('mrLeafCopy').onclick = function(){ copyText(gel('mrLeafBody').value); };
  gel('mrLeafSave').onclick = function(){
    if (!LEAF_CUR) return;
    var title = gel('mrLeafTitle').value.trim();
    var body = gel('mrLeafBody').value.replace(/\n{3,}/g, '\n\n').trim();
    if (!title) { _alertBox('저장 이름을 적어 주세요.', {icon:'⚠️'}); return; }
    if (!body) { _alertBox('글이 비어 있습니다.', {icon:'⚠️'}); return; }
    post(LEAF_SAVE_URL, { leafSeq: LEAF_CUR, title: title, body: body })
      .then(function(res){ _toast('고쳐 저장했습니다.', 'ok'); LEAF_FLASH = res.leafSeq || LEAF_CUR; return loadLeafList(); })
      .catch(err);
  };
  gel('mrLeafDel').onclick = function(){
    if (!LEAF_CUR) return;
    _confirmBox({ msg: '이 저장 안내문을 지울까요?', icon: '🗑️', okText: '지우기', okColor: '#b23b3b',
      onOk: function(){
        post(LEAF_DEL_URL, { leafSeq: LEAF_CUR })
          .then(function(){ _toast('지웠습니다.', 'ok'); LEAF_CUR = null; gel('mrLeafView').hidden = true; return loadLeafList(); })
          .catch(err);
      } });
  };
  loadLeafList();

  loadList();
})();
</script>
