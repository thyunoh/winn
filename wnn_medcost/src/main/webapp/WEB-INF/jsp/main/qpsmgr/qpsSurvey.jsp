<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%--
  환자만족도 조사 — 설문지 / 응답 / 집계
  ★이 화면만 저장 단위가 다르다 : 응답자 1인 = 1건.
  ★문항은 TBL_QPS_SRV_DEF 를 순회해 그린다. 20개를 여기에 박지 않는다.
  ★배점 역전 주의 : 보기 표시는 매우만족→매우불만족 순이지만 값은 5→1 이다.
--%>
<%-- 공통 알림·확인 컴포넌트. ★이걸 안 실으면 _alertBox 가 없어 브라우저 기본 alert 로 떨어진다. --%>
<script src="/asset/js/ui-message.js"></script>

<div class="dashboard-wrapper">
<div id="qpsSurvey" style="padding:16px 96px 40px 16px;">

  <div style="display:flex;align-items:center;gap:10px;margin-bottom:12px;flex-wrap:wrap;">
    <h2 style="margin:0;font-size:19px;font-weight:700;">의료서비스 만족도 조사</h2>
    <span style="color:#888;font-size:13px;">${hospNm}</span>
    <%-- ★화면 버전 표식. 브라우저가 옛 스크립트를 붙잡고 있는지 눈으로 바로 확인한다. --%>
    <span style="color:#1a73e8;font-size:11px;border:1px solid #cfe0f7;border-radius:3px;padding:1px 5px;">v13</span>
    <span style="flex:1"></span>
    <select id="svYear" style="height:32px;padding:0 8px;"></select>
    <select id="svList" style="height:32px;padding:0 8px;min-width:220px;"></select>
    <button type="button" class="btn-nw" id="btnSvNew">새 조사</button>
    <button type="button" class="btn-sv" id="btnSvSave">조사정보 저장</button>
    <button type="button" class="btn-sv" id="btnAnsSaveTop" style="display:none">이 응답 저장</button>
    <button type="button" class="btn-pr" id="btnSvPrint">🖨 조사결과 보고서</button>
    <button type="button" class="btn-pr" id="btnSvPrint2">🖨 지표분석 보고서</button>
  <span style="flex:0 0 12px;"></span>
  <%-- 글자 크기 - 이 PC 이 브라우저에만 저장된다 --%>
  <span class="zz-zoom">
    <button type="button" onclick="zzZoom(-1);" title="글자 작게">가－</button>
    <button type="button" onclick="zzZoom(1);"  title="글자 크게">가＋</button>
    <button type="button" onclick="zzZoom(0);"  title="처음 크기로">↺</button>
  </span>
  </div>

  <!-- 탭 -->
  <div id="svTabs" style="display:flex;gap:6px;margin-bottom:12px;border-bottom:2px solid #dfe4ea;">
    <button type="button" class="svtab on" data-tab="info">조사 개요</button>
    <button type="button" class="svtab"    data-tab="ans">설문 응답</button>
    <button type="button" class="svtab"    data-tab="stat">집계 결과</button>
  </div>

  <!-- ── 조사 개요 ─────────────────────────────────────────────── -->
  <div class="svpane" id="pane-info">
    <table class="svtbl">
      <colgroup><col style="width:140px"><col><col style="width:140px"><col></colgroup>
      <tr><th>조사명</th><td colspan="3"><input id="f_surveynm" class="ipt" style="width:100%" placeholder="예) 입원환자 의료서비스 만족도"></td></tr>
      <tr><th>조사기간</th><td><input id="f_frdt" class="ipt" type="date"> ~ <input id="f_todt" class="ipt" type="date"></td>
          <th>조사대상 및 인원</th><td><input id="f_target" class="ipt" style="width:100%"></td></tr>
      <tr><th>조사방법</th><td><input id="f_method" class="ipt" style="width:100%"></td>
          <th>조사요원</th><td><input id="f_staff" class="ipt" style="width:100%"></td></tr>
      <tr><th>통계방법</th><td colspan="3"><input id="f_statmethod" class="ipt" style="width:100%"></td></tr>
      <tr><th>조사의 목적</th><td colspan="3"><textarea id="f_purpose" class="ipt" rows="3" style="width:100%"></textarea></td></tr>
      <tr><th>조사의 목표</th><td colspan="3"><textarea id="f_goal" class="ipt" rows="3" style="width:100%"></textarea></td></tr>
      <tr><th>조사의 활용</th><td colspan="3"><textarea id="f_useplan" class="ipt" rows="3" style="width:100%"></textarea></td></tr>
    </table>
    <p class="hint">※ 만족지수 산출기준 — 매우만족 5점 / 만족 4점 / 보통 3점 / 불만족 2점 / 매우불만족 1점</p>

    <%-- 보고서 서술 — 집계 9면은 자동이고, 보고서에서 사람이 쓰는 칸은 이것뿐이다.
         개선사항은 한 줄 = 구분|문제점|처리결과 (인쇄에서 3열 표로 조립) --%>
    <h4 style="margin:16px 0 6px;font-size:14px;background:#eef3f8;padding:7px 10px;border-left:3px solid #1a73e8;">
      보고서 서술 <span style="font-weight:400;font-size:12px;color:#888;">— 조사결과·지표분석 보고서 인쇄에 실립니다</span></h4>
    <table class="svtbl">
      <colgroup><col style="width:170px"><col></colgroup>
      <tr><th>개선사항<br><span style="font-weight:400;font-size:11px;color:#888;">줄당: 구분|문제점|처리결과</span></th>
          <td><textarea id="f_imprtxt" class="ipt" rows="3" style="width:100%"
              placeholder="시설 및 환경|주차공간 부족 불만|외부 주차장 계약(3월)&#10;간병 서비스|호출 응답 지연|병동별 응답시간 모니터링"></textarea></td></tr>
      <tr><th>개선 전략 및 실행<br><span style="font-weight:400;font-size:11px;color:#888;">지표분석 보고서</span></th>
          <td><textarea id="f_strategytxt" class="ipt" rows="3" style="width:100%"></textarea></td></tr>
      <tr><th>결론 및 제언<br><span style="font-weight:400;font-size:11px;color:#888;">지표분석 보고서</span></th>
          <td><textarea id="f_concltxt" class="ipt" rows="3" style="width:100%"></textarea></td></tr>
      <tr><th>증진활동 평가 및<br>추후 활동계획<br><span style="font-weight:400;font-size:11px;color:#888;">지표분석 보고서</span></th>
          <td><textarea id="f_nextacttxt" class="ipt" rows="3" style="width:100%"></textarea></td></tr>
    </table>
  </div>

  <!-- ── 설문 응답 ─────────────────────────────────────────────── -->
  <div class="svpane" id="pane-ans" style="display:none;">
    <div style="display:flex;gap:14px;align-items:flex-start;">
      <!-- 응답 목록 -->
      <div style="width:280px;flex:none;">
        <div style="display:flex;gap:6px;margin-bottom:6px;">
          <button type="button" class="btn-nw" id="btnAnsNew" style="flex:1">＋ 새 응답</button>
          <button type="button" class="btn-dl" id="btnAnsDel">삭제</button>
        </div>
        <div id="ansList" class="ansbox"></div>
        <p class="hint" id="ansCnt">응답 0건</p>
      </div>

      <!-- 설문지 -->
      <div style="flex:1;min-width:0;">
        <%-- ★저장 버튼은 위에 둔다. 아래에만 있으면 문항 20개를 지나야 보여서
             「저장이 안 된다」로 오인하기 쉽다(상단 「조사정보 저장」과 헷갈린다). --%>
        <p class="hint" style="margin:0 0 8px;">※ 응답자 1명 = 1건입니다. 입력 후 위쪽 「이 응답 저장」을 누르세요.</p>
        <table class="svtbl" style="margin-bottom:10px;">
          <colgroup><col style="width:90px"><col><col style="width:70px"><col><col style="width:70px"><col></colgroup>
          <tr>
            <th>번호</th><td><input id="a_ansno" class="ipt" style="width:70px;background:#f5f5f5" type="number" readonly placeholder="자동"></td>
            <th>작성자</th><td><select id="a_writer" class="ipt"></select></td>
            <th>성별</th><td><select id="a_sex" class="ipt"></select></td>
          </tr>
          <tr><th>연령대</th><td colspan="5"><select id="a_age" class="ipt"></select></td></tr>
        </table>

        <div id="qWrap"></div>

        <table class="svtbl" style="margin-top:10px;">
          <tr><th style="width:140px">기타의견 및 건의사항</th>
              <td><textarea id="a_etc" class="ipt" rows="3" style="width:100%"></textarea></td></tr>
        </table>
        <div style="text-align:right;margin-top:10px;">
          <button type="button" class="btn-sv" id="btnAnsSave">이 응답 저장</button>
        </div>
      </div>
    </div>
  </div>

  <!-- ── 집계 결과 ─────────────────────────────────────────────── -->
  <div class="svpane" id="pane-stat" style="display:none;">
    <div style="text-align:right;margin-bottom:8px;">
      <label style="font-size:13px;"><input type="checkbox" id="chkScore"> 점수 상세 보기</label>
    </div>
    <div id="statWrap"><p class="hint">조사를 선택하면 집계가 표시됩니다.</p></div>
  </div>

</div>
</div>

<style>
#qpsSurvey .svtab{padding:8px 18px;border:0;background:transparent;font-size:14px;color:#666;cursor:pointer;border-bottom:2px solid transparent;margin-bottom:-2px;}
#qpsSurvey .svtab.on{color:#1a73e8;font-weight:700;border-bottom-color:#1a73e8;}
#qpsSurvey .svtbl{width:100%;border-collapse:collapse;background:#fff;}
#qpsSurvey .svtbl th,#qpsSurvey .svtbl td{border:1px solid #dfe4ea;padding:7px 9px;font-size:13px;text-align:left;vertical-align:middle;}
#qpsSurvey .svtbl th{background:#f6f8fa;font-weight:600;color:#444;}
#qpsSurvey .ipt{border:1px solid #ccc;border-radius:3px;padding:5px 7px;font-size:13px;box-sizing:border-box;}
#qpsSurvey .hint{color:#888;font-size:12px;margin:6px 0 0;}
#qpsSurvey button[class^=btn-]{height:32px;padding:0 14px;border:0;border-radius:4px;color:#fff;font-size:13px;cursor:pointer;}
#qpsSurvey .btn-sv{background:#1a73e8;} #qpsSurvey .btn-nw{background:#00897b;}
#qpsSurvey .btn-dl{background:#e53935;} #qpsSurvey .btn-pr{background:#607d8b;}
#qpsSurvey .ansbox{border:1px solid #dfe4ea;height:520px;overflow:auto;background:#fff;}
#qpsSurvey .ansrow{padding:7px 10px;border-bottom:1px solid #eee;font-size:13px;cursor:pointer;}
#qpsSurvey .ansrow:hover{background:#f2f7ff;} #qpsSurvey .ansrow.on{background:#e3f0ff;font-weight:600;}
#qpsSurvey .qarea{margin-bottom:14px;}
#qpsSurvey .qarea h4{margin:0 0 6px;font-size:14px;background:#eef3f8;padding:7px 10px;border-left:3px solid #1a73e8;}
#qpsSurvey .qtbl{width:100%;border-collapse:collapse;}
#qpsSurvey .qtbl th,#qpsSurvey .qtbl td{border:1px solid #dfe4ea;padding:6px;font-size:13px;}
#qpsSurvey .qtbl th{background:#f6f8fa;font-weight:600;font-size:12px;text-align:center;}
#qpsSurvey .qtbl td.qn{text-align:left;}
#qpsSurvey .qtbl td.sc{text-align:center;width:78px;}
/* ★공통 CSS 가 라디오를 감추거나 커스텀 스타일로 바꿔도 여기서는 기본 라디오를 되살린다.
      (감춰지면 「문항은 보이는데 고를 수가 없다」는 증상이 된다) */
#qpsSurvey .qtbl input[type=radio]{
  -webkit-appearance:radio !important; appearance:auto !important;
  display:inline-block !important; position:static !important;
  width:16px !important; height:16px !important; margin:0 !important;
  opacity:1 !important; visibility:visible !important; clip:auto !important; cursor:pointer;
}
#qpsSurvey .bar{height:14px;background:#1a73e8;border-radius:2px;display:inline-block;vertical-align:middle;}
#qpsSurvey .statt{width:100%;border-collapse:collapse;margin-bottom:8px;}
#qpsSurvey .statt th,#qpsSurvey .statt td{border:1px solid #dfe4ea;padding:5px 7px;font-size:12px;text-align:center;}
#qpsSurvey .statt th{background:#f6f8fa;} #qpsSurvey .statt td.nm{text-align:left;}
  /* -- 글자 크기 (2026-08-18 요청) : QI 계획서(qpsQiPlan)와 같은 모양.같은 조작 */
  #qpsSurvey .zz-zoom{ display:inline-flex; gap:4px; align-items:center; margin-left:2px; margin-right:14px; }
  #qpsSurvey .zz-zoom button{ border:1px solid #cfd9e0; background:#fff; color:#43555f; border-radius:6px;
                        padding:4px 9px; font-size:13px; font-weight:700; cursor:pointer; }
  #qpsSurvey .zz-zoom button:hover{ background:#eef3f6; }
</style>

<script>
(function(){
  var SCALE = [                    // ★표시 순서는 매우만족→매우불만족, 값(배점)은 5→1
    {v:5,nm:'매우만족'}, {v:4,nm:'만족'}, {v:3,nm:'보통'}, {v:2,nm:'불만족'}, {v:1,nm:'매우불만족'}
  ];
  var DEF = [], AREA = {}, curSurvey = 0, curAns = 0, ansCache = [];
  var HAND = {};   // 버튼 핸들러 모음 — 아래 위임에서 호출한다
  var userCleared = false;   // 사용자가 「— 조사 선택 —」을 직접 고른 상태

  /* ★★화면이 두 벌 이상 붙어 있을 수 있다(주소 숨김 구조 — content 를 갈아끼운다).
       그때 document.getElementById 는 「첫 번째=보이지 않는 사본」을 잡는다.
       그래서 핸들러가 죽은 사본에 걸리고, 사용자가 누르는 버튼은 아무 반응이 없다.
       ※ 탭만 멀쩡했던 이유 : querySelectorAll 로 등록해 두 사본 모두에 걸렸기 때문.
       ⇒ 모든 조회를 「가장 마지막에 붙은 내 화면」 안으로 한정한다. */
  var _roots = document.querySelectorAll('#qpsSurvey');
  var root   = null;
  for (var _i = _roots.length - 1; _i >= 0; _i--) {          // 뒤에서부터, 「실제로 보이는」 사본을 고른다
    if (_roots[_i].offsetParent !== null) { root = _roots[_i]; break; }
  }
  if (!root) root = _roots[_roots.length - 1] || document;   // 전부 숨김이면 마지막
  function gel(id){ return root.querySelector('[id="' + id + '"]'); }
  function qsa(sel){ return root.querySelectorAll(sel); }
  var UID = 'sv' + _roots.length + '_';
  function esc(s){ return String(s==null?'':s).replace(/[&<>"]/g,function(c){
    return {'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;'}[c]; }); }
  function num(v){ return (v==null||v==='')?null:Number(v); }
  function show(v){ return (v==null||v==='')?'-':v; }   // ★응답 0건이면 '-' (원본의 NAN/0.0 은 따르지 않음)

  /* ★알림은 반드시 감싸서 쓴다.
     _alertBox 가 없거나 던지면 그 뒤 로직(목록 갱신 등)이 통째로 중단돼
     「저장이 안 된 것처럼」 보인다. 실제로는 저장돼 있다. */
  function say(msg, icon){
    try { _alertBox(msg, {icon: icon || '✅'}); } catch(e) { try { alert(msg); } catch(x) {} }
  }
  /* ★_confirmBox 는 콜백을 인자로 받지 않는다. opts.onOk 로 넘겨야 한다. */
  function ask(msg, cb){
    try { _confirmBox(msg, {icon:'❓', onOk:cb}); } catch(e) { if (confirm(msg)) cb(); }
  }

  function post(url, data, cb){
    $.ajax({ url:url, type:'POST', data:data, dataType:'json',
      success:function(r){
        if (r && r.result==='OK') { try { cb(r); } catch(e){ say('화면 처리 중 오류: '+e.message,'❌'); } }
        else say((r && (r.message || r.msg)) || '처리 중 오류가 발생했습니다.', '❌');
      },
      error:function(){ say('통신 오류가 발생했습니다.', '❌'); } });
  }

  /* ── 연도 셀렉트 ── */
  (function(){
    var y = new Date().getFullYear(), h = '';
    for (var i = y+1; i >= y-5; i--) h += '<option value="'+i+'">'+i+'년</option>';
    gel('svYear').innerHTML = h; gel('svYear').value = y;
  })();

  /* ── 탭 ── */


  /* ── 코드 ──────────────────────────────────────────────────────
     codeList.do 는 QPS_ 코드를 「한 번에」 내려준다. 코드군마다 부르지 않는다. */
  var CODE = {};
  function loadCodes(cb){
    post('<c:url value="/qps/codeList.do"/>', {}, function(r){
      CODE = r.codes || {};      // ★서버가 이미 코드군별로 묶어서 준다(키: codes)
      cb && cb();
    });
  }
  function fillCode(sel, codeCd){
    var L = CODE[codeCd] || [], h = '<option value=""></option>';
    for (var i=0;i<L.length;i++) h += '<option value="'+esc(L[i].subcode)+'">'+esc(L[i].subcodenm)+'</option>';
    sel.innerHTML = h;
  }
  function codeNm(codeCd, sub){
    var L = CODE[codeCd] || [];
    for (var i=0;i<L.length;i++) if (String(L[i].subcode) === String(sub)) return L[i].subcodenm;
    return (sub==null||sub==='') ? '(미기재)' : sub;
  }

  /* ── 초기 로드 ── */
  function loadBase(){
    post('<c:url value="/qps/surveyBase.do"/>', {inYear:gel('svYear').value}, function(r){
      DEF = r.def || [];
      AREA = {};
      DEF.forEach(function(d){ if(!AREA[d.areacd]) AREA[d.areacd] = {nm:d.areanm, qs:[]}; AREA[d.areacd].qs.push(d); });
      drawQuestions();
      var L = r.list||[], h = '<option value="">— 조사 선택 —</option>';
      for (var i=0;i<L.length;i++)
        h += '<option value="'+L[i].surveyid+'">'+esc(L[i].inyear)+'-'+L[i].seq+' '
           + esc(L[i].surveynm||'(무제)')+' ('+(L[i].anscnt||0)+'건)</option>';
      gel('svList').innerHTML = h;
      /* ★조사를 「자동으로」 하나 열어 둔다.
         선택 안 된 상태로 두면 드롭다운은 「— 조사 선택 —」인데 집계는 나오는 식으로
         화면끼리 어긋나 보인다. 목록의 첫(=최신) 조사를 잡고 내용까지 불러온다. */
      if (curSurvey) {
        gel('svList').value = curSurvey;
      } else if (L.length && !userCleared) {
        gel('svList').value = L[0].surveyid;
      }
      var want = gel('svList').value;
      if (want && HAND.svList) HAND.svList.call(gel('svList'));
      if (want) {
        setTimeout(function(){ if (gel('svList')) gel('svList').value = want; }, 0);
        setTimeout(function(){ if (gel('svList')) gel('svList').value = want; }, 400);
      }
    });
  }

  /* ── 설문 문항 그리기 (★DEF 순회 — 하드코딩 없음) ── */
  function drawQuestions(){
    var h = '';
    Object.keys(AREA).sort().forEach(function(ac){
      var a = AREA[ac];
      h += '<div class="qarea"><h4>'+esc(ac)+'. '+esc(a.nm||'')+'</h4><table class="qtbl"><tr><th>문항</th>';
      SCALE.forEach(function(s){ h += '<th>'+s.nm+'<br>'+s.v+'점</th>'; });
      h += '</tr>';
      a.qs.forEach(function(q){
        h += '<tr><td class="qn">'+q.qno+') '+esc(q.qnm)+'</td>';
        SCALE.forEach(function(s){
          h += '<td class="sc"><input type="radio" name="'+UID+'q_'+q.sort+'" value="'+s.v+'"></td>';
        });
        h += '</tr>';
      });
      h += '</table></div>';
    });
    gel('qWrap').innerHTML = h || '<p class="hint">문항이 없습니다.</p>';
  }

  /* ── 조사 선택 ──────────────────────────────────────────────────
     ★브라우저는 새로고침 때 select 값을 「복원」하지만 onchange 는 발동하지 않는다.
       그래서 화면엔 조사가 선택돼 보이는데 curSurvey 는 0 인 상태가 생긴다.
       → 저장·집계처럼 curSurvey 가 필요한 시점마다 select 에서 다시 읽어 맞춘다.
       (이걸 안 하면 「선택했는데 먼저 선택하라고 한다」는 증상이 된다) */
  /* 조사 번호 확보 — 화면에 선택돼 보여도 내부 상태가 비어 있는 경우가 있어
     (브라우저가 select 값만 복원하고 change 는 안 쏜다) 목록 첫 조사로 보정한다.
     ★저장·집계 어디서든 같은 규칙을 쓰도록 한 곳에 모은다. */
  function ensureSurvey(){
    syncSurvey();
    if (!curSurvey) {
      var o = qsa('#svList option');
      for (var i=0;i<o.length;i++) if (o[i].value) { gel('svList').value = o[i].value; curSurvey = Number(o[i].value); break; }
    }
    return curSurvey;
  }

  function syncSurvey(){
    var v = Number(gel('svList').value || 0);
    if (v && v !== curSurvey) { curSurvey = v; return true; }   // 복원된 값 반영
    if (!v) curSurvey = 0;
    return false;
  }

  HAND.svList = function(){
    curSurvey = Number(this.value||0);
    userCleared = !curSurvey;
    if (!curSurvey){
      /* 「— 조사 선택 —」로 되돌리면 세 탭을 모두 비운다.
         집계만 남으면 「선택 안 했는데 수치가 보인다」가 되어 혼란스럽다. */
      clearInfo(); clearAnsForm();
      gel('ansList').innerHTML = '';
      gel('ansCnt').textContent = '응답 0건';
      gel('statWrap').innerHTML = '<p class=\"hint\">조사를 선택하면 집계가 표시됩니다.</p>';
      return;
    }
    post('<c:url value="/qps/surveyGet.do"/>', {surveyId:curSurvey}, function(r){
      var d = r.doc||{};
      gel('f_surveynm').value = d.surveynm||''; gel('f_purpose').value = d.purpose||'';
      gel('f_goal').value = d.goal||'';         gel('f_useplan').value = d.useplan||'';
      gel('f_target').value = d.target||'';     gel('f_method').value = d.method||'';
      gel('f_staff').value = d.staff||'';       gel('f_statmethod').value = d.statmethod||'';
      gel('f_frdt').value = fmtDt(d.frdt);      gel('f_todt').value = fmtDt(d.todt);
      gel('f_imprtxt').value = d.imprtxt||'';   gel('f_strategytxt').value = d.strategytxt||'';
      gel('f_concltxt').value = d.concltxt||''; gel('f_nextacttxt').value = d.nextacttxt||'';
      drawAnsList(r.ans||[]);
      var onStat = gel('pane-stat') && gel('pane-stat').style.display !== 'none';
      if (onStat) loadStat();
    });
  };
  function fmtDt(s){ return (s&&s.length===8) ? s.substr(0,4)+'-'+s.substr(4,2)+'-'+s.substr(6,2) : ''; }
  function rawDt(s){ return (s||'').replace(/-/g,''); }
  function clearInfo(){
    ['f_surveynm','f_purpose','f_goal','f_useplan','f_target','f_method','f_staff','f_statmethod','f_frdt','f_todt',
     'f_imprtxt','f_strategytxt','f_concltxt','f_nextacttxt']
      .forEach(function(id){ gel(id).value=''; });
  }

  HAND.svYear = function(){ curSurvey=0; loadBase(); clearInfo(); gel('ansList').innerHTML=''; };

  /* ── 조사 신규/저장 ── */
  /* ★「새 조사」는 누르는 즉시 서버에 회차를 만든다.
     예전처럼 「빈 화면을 만들어 두고 저장 때 신규 판정」하면
     드롭다운에 남은 값 때문에 기존 조사 수정으로 새는 일이 생긴다.
     먼저 만들어 목록에 띄우면 차수(2026-N)가 바로 눈에 보이고 상태가 꼬이지 않는다. */
  HAND.btnSvNew = function(){
    // ★"입력한 게 없어졌다" 오인 방지 — 새 조사는 빈 화면으로 시작하는 게 정상이고,
    //   이전 조사는 상단 드롭다운에 그대로 남아 언제든 다시 열 수 있다는 것을 분명히 알린다.
    ask('올해(' + gel('svYear').value + '년) 새 조사를 만들까요?<br>' +
        '<span style="color:#6b7c86;font-size:12px;">지금 보던 조사와 응답은 지워지지 않습니다 — 상단 목록에서 다시 열 수 있습니다.</span>', function(){
      post('<c:url value="/qps/surveySave.do"/>',
           { surveyId:'', inYear:gel('svYear').value, surveynm:'(제목 없음)' },
           function(r){
             curSurvey = r.surveyId;
             clearInfo(); clearAnsForm();
             gel('ansList').innerHTML=''; gel('ansCnt').textContent = '응답 0건';
             gel('f_surveynm').value = '(제목 없음)';
             loadBase();
             say('새 조사를 만들었습니다. 조사명을 채운 뒤 「조사정보 저장」을 누르세요.', 'ℹ️');
           });
    });
  };

  HAND.btnSvSave = function(){
    var p = { surveyId:curSurvey, inYear:gel('svYear').value, seq:1,
      surveynm:gel('f_surveynm').value, purpose:gel('f_purpose').value, goal:gel('f_goal').value,
      useplan:gel('f_useplan').value, target:gel('f_target').value, method:gel('f_method').value,
      staff:gel('f_staff').value, statmethod:gel('f_statmethod').value,
      frdt:rawDt(gel('f_frdt').value), todt:rawDt(gel('f_todt').value),
      imprtxt:gel('f_imprtxt').value, strategytxt:gel('f_strategytxt').value,
      concltxt:gel('f_concltxt').value, nextacttxt:gel('f_nextacttxt').value };
    post('<c:url value="/qps/surveySave.do"/>', p, function(r){
      curSurvey = r.surveyId; say('저장되었습니다.'); loadBase();
    });
  };

  /* ── 응답 목록 ── */
  function drawAnsList(list){
    ansCache = list;
    var h = '';
    list.forEach(function(a){
      h += '<div class="ansrow" data-id="'+a.ansid+'">'
         + '#'+(a.ansno||'')+'  <span style="color:#888">'+esc(a.regdt||'')+'</span></div>';
    });
    gel('ansList').innerHTML = h || '<p class="hint" style="padding:10px">응답이 없습니다.</p>';
    gel('ansCnt').textContent = '응답 '+list.length+'건';

  }

  function selectAns(ansId, el){
    curAns = ansId;
    Array.prototype.forEach.call(gel('ansList').querySelectorAll('.ansrow'), function(x){ x.classList.remove('on'); });
    if (el) el.classList.add('on');
    var a = null;
    for (var i=0;i<ansCache.length;i++) if (ansCache[i].ansid == ansId) a = ansCache[i];
    if (a){
      gel('a_ansno').value = a.ansno||''; gel('a_writer').value = a.writercd||'';
      gel('a_sex').value = a.sexcd||'';   gel('a_age').value = a.agecd||'';
      gel('a_etc').value = a.etcopn||'';
    }
    clearRadios();
    post('<c:url value="/qps/surveyAnsGet.do"/>', {ansId:ansId}, function(r){
      (r.items||[]).forEach(function(it){
        if (it.score == null) return;
        var el2 = root.querySelector('#qWrap input[name="'+UID+'q_'+it.qsort+'"][value="'+it.score+'"]');
        if (el2) el2.checked = true;
      });
    });
  }
  /* 응답 입력폼 전체 초기화 — 「새 조사」·「새 응답」이 함께 쓴다.
     ★이걸 빠뜨리면 새 조사로 넘어가도 앞 응답의 체크가 남아 그대로 저장된다. */
  function clearAnsForm(){
    curAns = 0;
    gel('a_ansno').value = '';
    gel('a_writer').value = ''; gel('a_sex').value = ''; gel('a_age').value = '';
    gel('a_etc').value = '';
    clearRadios();
    var rows = qsa('.ansrow');
    for (var i=0;i<rows.length;i++) rows[i].classList.remove('on');
  }

  function clearRadios(){
    Array.prototype.forEach.call(gel('qWrap').querySelectorAll('input[type=radio]'), function(r){ r.checked = false; });
  }

  /* ★「새 응답」은 폼만 비운다. 조사 선택 여부는 저장할 때 따진다.
       여기서 막으면 「눌러도 아무 일이 없다」로 보여 원인을 찾기 어렵다.
       번호도 화면에서 매기지 않는다 — 저장 시 서버가 MAX+1 로 부여한다. */
  HAND.btnAnsNew = function(){
    syncSurvey();
    clearAnsForm();
  };

  /* 진단 표시 — 저장이 「눌렸는지 / 어디서 멈췄는지」 화면에서 바로 보이게 한다. */
  HAND.btnAnsSave = function(){
    if (!ensureSurvey()) return say('먼저 「새 조사」로 조사를 만들어 주세요.', '⚠️');
    var items = [];
    DEF.forEach(function(q){
      var c = root.querySelector('#qWrap input[name="'+UID+'q_'+q.sort+'"]:checked');
      items.push({ qsort:q.sort, score: c ? Number(c.value) : null });   // 무응답은 null
    });
    var p = { surveyId:curSurvey, ansId:curAns, ansno:gel('a_ansno').value,
              writercd:gel('a_writer').value, sexcd:gel('a_sex').value, agecd:gel('a_age').value,
              etcopn:gel('a_etc').value, items: JSON.stringify(items) };
    post('<c:url value="/qps/surveyAnsSave.do"/>', p, function(r){
      /* ★저장하면 곧바로 다음 응답을 받을 수 있게 폼을 비운다.
         설문지를 여러 장 연달아 입력하는 화면이라, 매번 「새 응답」을 누르게 하면 번거롭다.
         (방금 저장한 내용은 왼쪽 목록에서 눌러 다시 볼 수 있다.) */
      clearAnsForm();
      say('저장되었습니다. 이어서 다음 응답을 입력하세요.');
      post('<c:url value="/qps/surveyGet.do"/>', {surveyId:curSurvey}, function(r2){
        drawAnsList(r2.ans||[]);
        refreshListCaption((r2.ans||[]).length);
      });
    });
  };

  /* ★상단 드롭다운의 「(N건)」을 응답 저장·삭제 때 같이 갱신한다.
     캡션은 loadBase 때 박힌 글자라, 안 고치면 응답을 저장해도 「(0건)」이 남아
     **저장이 안 된 것처럼 보인다**(2026-08-10 실사용 지적 — "입력한 게 없어짐" 오인의 원인). */
  function refreshListCaption(cnt){
    var o = root.querySelector('#svList option[value="' + curSurvey + '"]');
    if (o) o.text = o.text.replace(/\(\d+건\)\s*$/, '(' + cnt + '건)');
  }

  HAND.btnAnsDel = function(){
    if (!curAns) return say('삭제할 응답을 선택하세요.');
    ask('선택한 응답을 삭제하시겠습니까?', function(){
      post('<c:url value="/qps/surveyAnsDelete.do"/>', {ansId:curAns}, function(){
        curAns = 0;
        post('<c:url value="/qps/surveyGet.do"/>', {surveyId:curSurvey}, function(r2){
          drawAnsList(r2.ans||[]);
          refreshListCaption((r2.ans||[]).length);
        });
      });
    });
  };

  /* ── 집계 ─────────────────────────────────────────────────────
     ★수치는 서버에서 계산해 내려온다. 화면은 그리기만 한다.
       (산식 : 점수합/총점*100 = 백분율, 점수합/응답수 = 평균점) */
  function loadStat(){
    ensureSurvey();
    if (!curSurvey){ gel('statWrap').innerHTML = '<p class="hint">조사를 선택하면 집계가 표시됩니다.</p>'; return; }
    post('<c:url value="/qps/surveyStat.do"/>', {surveyId:curSurvey}, function(r){ drawStat(r); });
  }

  function drawStat(r){
    var det = gel('chkScore').checked;
    var byQ = {}; (r.item||[]).forEach(function(x){ byQ[x.qsort] = x; });
    var byA = {}; (r.area||[]).forEach(function(x){ byA[x.areacd] = x; });
    var t = r.total || {};
    var h = '';

    h += '<table class="statt"><tr><th style="width:160px">전체 응답</th><td>'+show(t.anscnt)+'명</td>'
       + '<th style="width:160px">의료서비스 만족도 전체 평균</th><td><b>'+show(t.pct)+'</b> % / <b>'+show(t.avgp)+'</b> 점</td></tr></table>';

    // 영역 요약 (지표분석 보고서 1p 요약표)
    h += '<table class="statt"><tr><th>구분</th>';
    Object.keys(AREA).sort().forEach(function(ac){ h += '<th>'+esc(AREA[ac].nm||ac)+'</th>'; });
    h += '</tr><tr><td class="nm">평균점수</td>';
    Object.keys(AREA).sort().forEach(function(ac){
      var a = byA[ac]||{}; h += '<td>'+show(a.pct)+' %<br><span style="color:#888">'+show(a.avgp)+' 점</span></td>';
    });
    h += '</tr></table>';

    // 응답자 분포
    h += profTable('성별',   r.profSEX,    'QPS_SRV_SEX')
       + profTable('연령대', r.profAGE,    'QPS_SRV_AGE')
       + profTable('작성자', r.profWRITER, 'QPS_SRV_WRITER');

    // 문항별 블록 (★DEF 순회)
    Object.keys(AREA).sort().forEach(function(ac){
      var a = AREA[ac];
      h += '<div class="qarea"><h4>'+esc(ac)+'. '+esc(a.nm||'')+'</h4><table class="statt"><tr><th class="nm">문항</th>';
      SCALE.forEach(function(s){ h += '<th>'+s.nm+'<br>('+s.v+')</th>'; });
      h += '<th>응답수</th>'+(det?'<th>점수합/총점</th>':'')+'<th>백분율</th><th>만족도</th><th style="width:170px">분포</th></tr>';
      a.qs.forEach(function(q){
        var s = byQ[q.sort]||{};
        h += '<tr><td class="nm">'+q.qno+') '+esc(q.qnm)+'</td>';
        [s.n5,s.n4,s.n3,s.n2,s.n1].forEach(function(n, i){
          var cnt = Number(n||0), tot = Number(s.cnt||0);
          h += '<td>'+cnt+(det&&cnt?'<br><span style="color:#888">'+cnt+'×'+SCALE[i].v+'='+(cnt*SCALE[i].v)+'</span>':'')+'</td>';
        });
        h += '<td>'+show(s.cnt)+'</td>';
        if (det) h += '<td>'+show(s.sumscore)+' / '+show(s.totscore)+'</td>';
        h += '<td><b>'+show(s.pct)+'</b> %</td><td>'+show(s.avgp)+' 점</td>';
        h += '<td>'+bar(s.pct)+'</td></tr>';
      });
      h += '</table></div>';
    });

    // 기타의견
    var op = r.opinion||[];
    h += '<div class="qarea"><h4>기타의견 및 건의사항</h4>';
    if (!op.length) h += '<p class="hint" style="padding:6px">등록된 의견이 없습니다.</p>';
    else { h += '<table class="statt">';
      op.forEach(function(o){ h += '<tr><td style="width:60px">#'+esc(o.ansno||'')+'</td><td class="nm">'+esc(o.etcopn)+'</td></tr>'; });
      h += '</table>'; }
    h += '</div>';

    gel('statWrap').innerHTML = h;
  }

  function bar(pct){
    if (pct == null || pct === '') return '-';
    var w = Math.max(0, Math.min(100, Number(pct)));
    return '<span class="bar" style="width:'+w+'%"></span> <span style="font-size:11px;color:#888">'+w+'%</span>';
  }

  function profTable(title, rows, codeCd){
    var L = rows||[]; if (!L.length) return '';
    var sum = 0; L.forEach(function(x){ sum += Number(x.cnt||0); });
    var h = '<table class="statt"><tr><th class="nm" style="width:120px">'+title+'</th>';
    L.forEach(function(x){ h += '<th>'+esc(codeNm(codeCd, x.cd))+'</th>'; });
    h += '<th>합계</th></tr><tr><td class="nm">빈도(명)</td>';
    L.forEach(function(x){ h += '<td>'+x.cnt+'</td>'; });
    h += '<td>'+sum+'</td></tr><tr><td class="nm">비율(%)</td>';
    L.forEach(function(x){ h += '<td>'+(sum? (Math.round(Number(x.cnt)/sum*1000)/10) : '-')+'</td>'; });
    h += '<td>'+(sum?100:'-')+'</td></tr></table>';
    return h;
  }

  HAND.chkScore = loadStat;

  /* ── 인쇄 2종 — 별도 창 방식(앱 CSS·주소 바닥글이 안 붙는다. QPS 공통 패턴) ──
     조사결과 보고서(원본 12p) / 지표분석 보고서(원본 10p).
     ★집계 수치는 인쇄 직전에 서버에서 새로 받는다 — 화면 DOM 을 긁지 않는다(어긋남 방지).
     ★결재란은 결재선(apprGet, 지표 SATISFY·연간)에서, 지표 프레임은 정의서(indiDefGet)에서 가져온다. */
  var PRINT_CSS =
    '@page{ size:A4 portrait; margin:12mm 12mm 14mm; }' +
    'body{ margin:0; font-family:"맑은 고딕",Malgun Gothic,sans-serif; color:#000; }' +
    '.cover{ text-align:center; padding-top:45mm; page-break-after:always; }' +
    '.cover .t{ font-size:24px; font-weight:800; line-height:1.5; }' +
    '.cover .h{ font-size:14px; margin-top:14mm; }' +
    '.h1{ font-size:17px; font-weight:800; margin:0 0 8px; }' +
    '.sec{ font-size:13px; font-weight:800; margin:12px 0 5px; padding-bottom:3px; border-bottom:1.5px solid #333; }' +
    'table{ width:100%; border-collapse:collapse; font-size:10.5px; margin-bottom:6px; }' +
    'th,td{ border:1px solid #666; padding:4px 5px; text-align:center; vertical-align:middle; line-height:1.55; }' +
    'th{ background:#efefef; font-weight:700; }' +
    'td.l{ text-align:left; }' +
    'td.pre{ text-align:left; white-space:pre-wrap; }' +
    '.appr{ float:right; width:auto; margin:0 0 6px 8px; font-size:10px; }' +
    '.appr th{ padding:2px 6px; } .appr td{ height:44px; width:60px; }' +
    '.bar{ display:inline-block; height:9px; background:#555; vertical-align:middle; }' +
    '.barbox{ display:inline-block; width:90px; background:#e5e5e5; vertical-align:middle; }' +
    'tr{ page-break-inside:avoid; } .qarea{ page-break-inside:avoid; }';

  function pShow(v){ return (v==null||v==='') ? '-' : v; }
  function pBar(pct){
    if (pct == null || pct === '') return '-';
    var w = Math.max(0, Math.min(100, Number(pct)));
    return '<span class="barbox"><span class="bar" style="width:'+w+'%"></span></span>';
  }
  function doPrintWin(title, body){
    var w = window.open('', '_blank', 'width=900,height=1000');
    if (!w) { say('팝업이 차단되어 인쇄창을 열지 못했습니다. 주소창 오른쪽의 팝업 차단을 허용해 주세요.', '⚠️'); return; }
    w.document.open();
    w.document.write('<!doctype html><html lang="ko"><head><meta charset="utf-8"><title>' +
      esc(title.replace(/[\\\/:*?"<>|]/g, '-')) + '</title><style>' + PRINT_CSS + '</style></head><body>' + body + '</body></html>');
    w.document.close();
    w.focus();
    setTimeout(function(){ try { w.print(); } catch(e){} }, 300);
  }
  function apprHtml(line){
    if (!line || !line.length) return '';
    var h = '<table class="appr"><thead><tr>';
    line.forEach(function(r){ h += '<th>' + esc(r.stepnm) + '</th>'; });
    h += '</tr></thead><tbody><tr>';
    line.forEach(function(){ h += '<td></td>'; });
    return h + '</tr></tbody></table>';
  }
  // 응답자 분포 표(빈도/비율) — 성별·연령·작성자 공용
  function profHtml(title, rows, codeCd){
    var L = rows || []; if (!L.length) return '';
    var sum = 0; L.forEach(function(x){ sum += Number(x.cnt||0); });
    var h = '<table><tr><th style="width:90px;">' + esc(title) + '</th>';
    L.forEach(function(x){ h += '<th>' + esc(codeNm(codeCd, x.cd)) + '</th>'; });
    h += '<th>합계</th></tr><tr><td>빈도(명)</td>';
    L.forEach(function(x){ h += '<td>' + x.cnt + '</td>'; });
    h += '<td>' + sum + '</td></tr><tr><td>비율(%)</td>';
    L.forEach(function(x){ h += '<td>' + (sum ? (Math.round(Number(x.cnt)/sum*1000)/10) : '-') + '</td>'; });
    return h + '<td>' + (sum ? 100 : '-') + '</td></tr></table>';
  }
  // 영역별 문항 집계 블록(DEF 순회 — 하드코딩 없음)
  function areaBlocksHtml(r){
    var byQ = {}; (r.item||[]).forEach(function(x){ byQ[x.qsort] = x; });
    var h = '';
    Object.keys(AREA).sort().forEach(function(ac){
      var a = AREA[ac];
      h += '<div class="qarea"><div class="sec">' + esc(ac) + '. ' + esc(a.nm||'') + '</div>' +
           '<table><tr><th class="l">문항</th>';
      SCALE.forEach(function(s){ h += '<th style="width:44px;">' + s.nm + '<br>(' + s.v + ')</th>'; });
      h += '<th style="width:40px;">응답</th><th style="width:52px;">백분율</th><th style="width:44px;">만족도</th><th style="width:100px;">분포</th></tr>';
      a.qs.forEach(function(q){
        var s = byQ[q.sort] || {};
        h += '<tr><td class="l">' + q.qno + ') ' + esc(q.qnm) + '</td>';
        [s.n5,s.n4,s.n3,s.n2,s.n1].forEach(function(n){ h += '<td>' + Number(n||0) + '</td>'; });
        h += '<td>' + pShow(s.cnt) + '</td><td><b>' + pShow(s.pct) + '</b>%</td>' +
             '<td>' + pShow(s.avgp) + '점</td><td>' + pBar(s.pct) + '</td></tr>';
      });
      h += '</table></div>';
    });
    return h;
  }
  // 개선사항 표 — 줄당 "구분|문제점|처리결과"
  function imprHtml(){
    var lines = (gel('f_imprtxt').value||'').split('\n').map(function(s){ return s.trim(); }).filter(function(s){ return s; });
    if (!lines.length) return '';
    var h = '<div class="sec">의료서비스 만족도 조사 개선사항</div>' +
      '<table><tr><th style="width:110px;">구분</th><th>문제점</th><th>처리결과</th></tr>';
    lines.forEach(function(ln){
      var p = ln.split('|');
      h += '<tr><td>' + esc(p[0]||'') + '</td><td class="l">' + esc(p[1]||'') + '</td><td class="l">' + esc(p[2]||'') + '</td></tr>';
    });
    return h + '</table>';
  }
  function scaleHtml(){
    return '<table><tr><th style="width:90px;">구분</th>' +
      SCALE.map(function(s){ return '<th>' + s.nm + '</th>'; }).join('') + '</tr><tr><td>배점</td>' +
      SCALE.map(function(s){ return '<td><b>' + s.v + '점</b></td>'; }).join('') + '</tr></table>';
  }
  // [조사의 내용] — 영역|관련 문항(자동 생성: 문항표에서)
  function contentHtml(){
    var h = '<table><tr><th style="width:200px;">구분</th><th>관련 문항</th></tr>';
    Object.keys(AREA).sort().forEach(function(ac){
      var a = AREA[ac], qs = a.qs || [];
      var rng = qs.length ? (qs[0].qno + '번 ~ ' + qs[qs.length-1].qno + '번 (' + qs.length + '문항)') : '-';
      h += '<tr><td class="l">' + esc(ac) + '. ' + esc(a.nm||'') + '</td><td class="l">' + rng + '</td></tr>';
    });
    return h + '</table>';
  }
  function ov(id){ return esc(gel(id).value || ''); }
  function period(){ return (gel('f_frdt').value||'') + ' ~ ' + (gel('f_todt').value||''); }
  function hospNm(){ return '${hospNm}'; }

  // 인쇄 공통 준비 — 집계 + 결재선을 받아 cb(stat, line)
  function prepPrint(cb){
    ensureSurvey();
    if (!curSurvey) { say('조사를 먼저 선택해 주세요.', '⚠️'); return; }
    post('<c:url value="/qps/surveyStat.do"/>', {surveyId:curSurvey}, function(r){
      post('<c:url value="/qps/apprGet.do"/>', {indiCd:'SATISFY', prdGb:'Y', prdKey:gel('svYear').value}, function(a){
        cb(r, (a && a.line) || []);
      });
    });
  }

  /* ① 조사결과 보고서 (원본 12p) — 표지 / 목적·개요·산출기준 / 내용·활용 / 분포 / 문항 집계 / 개선사항 */
  HAND.btnSvPrint = function(){
    prepPrint(function(r, line){
      var yy = gel('svYear').value;
      var body =
        '<div class="cover"><div class="t">' + esc(yy) + ' 년도<br>' +
          (ov('f_surveynm') || '의료서비스 만족도') + '<br>조사 결과 보고서</div>' +
          '<div class="h">' + esc(hospNm()) + '</div></div>' +
        apprHtml(line) +
        '<div class="h1">' + esc(yy) + '년 ' + (ov('f_surveynm') || '의료서비스 만족도') + ' 조사 결과 보고서</div>' +
        '<div style="clear:both;"></div>' +
        '<div class="sec">조사의 목적</div><div class="pre" style="border:1px solid #666;padding:5px 7px;font-size:10.5px;white-space:pre-wrap;text-align:left;">' + ov('f_purpose') + '</div>' +
        '<div class="sec">조사의 목표</div><div style="border:1px solid #666;padding:5px 7px;font-size:10.5px;white-space:pre-wrap;text-align:left;">' + ov('f_goal') + '</div>' +
        '<div class="sec">조사 개요</div>' +
        '<table>' +
          '<tr><th style="width:110px;">조사기간</th><td class="l">' + esc(period()) + '</td><th style="width:110px;">조사대상 및 인원</th><td class="l">' + ov('f_target') + '</td></tr>' +
          '<tr><th>조사방법</th><td class="l">' + ov('f_method') + '</td><th>조사요원</th><td class="l">' + ov('f_staff') + '</td></tr>' +
          '<tr><th>통계방법</th><td class="l" colspan="3">' + ov('f_statmethod') + '</td></tr>' +
        '</table>' +
        '<div class="sec">만족지수 산출기준</div>' + scaleHtml() +
        '<div class="sec">조사의 내용</div>' + contentHtml() +
        '<div class="sec">조사의 활용</div><div style="border:1px solid #666;padding:5px 7px;font-size:10.5px;white-space:pre-wrap;text-align:left;">' + ov('f_useplan') + '</div>' +
        '<div class="sec">응답자 분포</div>' +
        profHtml('성별', r.profSEX, 'QPS_SRV_SEX') +
        profHtml('연령대', r.profAGE, 'QPS_SRV_AGE') +
        profHtml('작성자', r.profWRITER, 'QPS_SRV_WRITER') +
        '<table><tr><th style="width:140px;">전체 응답</th><td>' + pShow((r.total||{}).anscnt) + ' 명</td>' +
        '<th style="width:170px;">의료서비스 만족도 전체 평균</th><td><b>' + pShow((r.total||{}).pct) + '</b> % / <b>' +
        pShow((r.total||{}).avgp) + '</b> 점</td></tr></table>' +
        areaBlocksHtml(r) +
        imprHtml();
      doPrintWin(yy + '_만족도조사결과보고서_' + hospNm(), body);
    });
  };

  /* ② 지표분석 보고서 (원본 10p) — 지표 프레임(정의서 재사용) + 현황·영역요약 + 집계 + 서술 3칸 + 개선사항 */
  HAND.btnSvPrint2 = function(){
    prepPrint(function(r, line){
      post('<c:url value="/qps/indiDefGet.do"/>', {indiCd:'SATISFY'}, function(dr){
        var d = (dr && dr.def) || {};
        var yy = gel('svYear').value, t = r.total || {};
        var byA = {}; (r.area||[]).forEach(function(x){ byA[x.areacd] = x; });
        var areaSum = '<table><tr><th style="width:90px;">구분</th>';
        Object.keys(AREA).sort().forEach(function(ac){ areaSum += '<th>' + esc(AREA[ac].nm||ac) + '</th>'; });
        areaSum += '</tr><tr><td>평균점수</td>';
        Object.keys(AREA).sort().forEach(function(ac){
          var a = byA[ac] || {};
          areaSum += '<td><b>' + pShow(a.pct) + '</b> %<br>' + pShow(a.avgp) + ' 점</td>';
        });
        areaSum += '</tr></table>';
        function txt(id){ return '<div style="border:1px solid #666;padding:5px 7px;font-size:10.5px;white-space:pre-wrap;text-align:left;min-height:40px;">' + ov(id) + '</div>'; }
        var body =
          apprHtml(line) +
          '<div class="h1">' + esc(yy) + '년 의료서비스 만족도 지표분석 보고서</div>' +
          '<div style="clear:both;"></div>' +
          '<div class="sec">지표 정의</div>' +
          '<table>' +
            '<tr><th style="width:90px;">지표명</th><td class="l" colspan="3">' + esc(d.indinm||'환자만족도(의료서비스)') + '</td></tr>' +
            '<tr><th>지표정의</th><td class="l" colspan="3">' + esc(d.definition||'') + '</td></tr>' +
            '<tr><th>분자정의</th><td class="l" colspan="3">' + esc(d.numerdesc||'') + '</td></tr>' +
            '<tr><th>분모정의</th><td class="l" colspan="3">' + esc(d.denomdesc||'') + '</td></tr>' +
            '<tr><th>목표</th><td class="l">의료서비스 만족도 ' + (d.targetval != null && d.targetval !== '' ? (Number(d.targetval) + esc(d.unit||'%')) : '____') + ' 이상</td>' +
            '<th style="width:90px;">기간</th><td class="l">' + esc(period()) + '</td></tr>' +
            '<tr><th>지표관리자</th><td class="l">' + esc(d.ownernm||'') + '</td><th>모니터링 주기</th><td class="l">' + esc(d.rptcycle||'연 1회') + '</td></tr>' +
            '<tr><th>자료수집</th><td class="l">' + (ov('f_method') || esc(d.sourcenm||'')) + '</td><th>통계기법과 도구</th><td class="l">' + ov('f_statmethod') + '</td></tr>' +
          '</table>' +
          '<div class="sec">현황</div>' +
          '<table><tr><th style="width:90px;">년</th><th>응답 수</th><th>의료서비스 만족도 평균</th></tr>' +
          '<tr><td>' + esc(yy) + '</td><td>' + pShow(t.anscnt) + ' 명</td><td><b>' + pShow(t.pct) + '</b> % / <b>' + pShow(t.avgp) + '</b> 점</td></tr></table>' +
          '<div class="sec">지표 분석 — 영역별 평균</div>' + areaSum +
          profHtml('성별', r.profSEX, 'QPS_SRV_SEX') +
          profHtml('연령대', r.profAGE, 'QPS_SRV_AGE') +
          areaBlocksHtml(r) +
          '<div class="sec">개선 전략 및 실행</div>' + txt('f_strategytxt') +
          '<div class="sec">결론 및 제언</div>' + txt('f_concltxt') +
          '<div class="sec">증진활동 평가 및 추후 활동계획</div>' + txt('f_nextacttxt') +
          imprHtml();
        doPrintWin(yy + '_만족도지표분석보고서_' + hospNm(), body);
      });
    });
  };

  /* ── 이벤트 위임 ────────────────────────────────────────────────
     ★버튼마다 onclick 을 걸면, 화면 사본이 여럿일 때 「등록된 버튼」과
       「사용자가 누르는 버튼」이 달라져 클릭이 통째로 무시된다.
       (증상: 번호 자동입력도 저장도 아무 반응 없음. 에러조차 안 난다.)
     ⇒ document 한 곳에서 받고, 클릭이 일어난 사본을 그 순간의 root 로 삼는다.
       이러면 사본이 몇 개든, 어느 쪽을 눌러도 항상 동작한다. */
  function closestEl(el, sel){
    while (el && el !== document) {
      if (el.matches && el.matches(sel)) return el;
      el = el.parentNode;
    }
    return null;
  }

  document.addEventListener('click', function(e){
    var host = closestEl(e.target, '#qpsSurvey');
    if (!host) return;
    root = host;                                   // ★클릭이 난 사본으로 맞춘다

    var tab = closestEl(e.target, '.svtab');
    if (tab) {
      var arr = qsa('.svtab');
      for (var i = 0; i < arr.length; i++) arr[i].classList.remove('on');
      tab.classList.add('on');
      ['info','ans','stat'].forEach(function(k){
        var pane = gel('pane-' + k);
        if (pane) pane.style.display = (k === tab.getAttribute('data-tab')) ? '' : 'none';
      });
      /* ★탭마다 필요한 버튼만 남긴다.
         개요=조사정보 저장 / 응답=이 응답 저장 / 집계=조회 전용(저장·새 조사 없음) */
      var tb   = tab.getAttribute('data-tab');
      var isAns = (tb === 'ans'), isStat = (tb === 'stat');
      var bSv = gel('btnSvSave'), bAns = gel('btnAnsSaveTop'), bNew = gel('btnSvNew');
      if (bSv)  bSv.style.display  = (isAns || isStat) ? 'none' : '';
      if (bAns) bAns.style.display = isAns ? '' : 'none';
      if (bNew) bNew.style.display = isStat ? 'none' : '';
      if (tab.getAttribute('data-tab') === 'stat') loadStat();
      return;
    }

    var row = closestEl(e.target, '.ansrow');
    if (row) { selectAns(Number(row.getAttribute('data-id')), row); return; }

    var btn = closestEl(e.target, 'button');
    if (btn && btn.id) {
      var key = (btn.id === 'btnAnsSaveTop') ? 'btnAnsSave' : btn.id;
      if (HAND[key]) { HAND[key](); return; }
    }
  });

  document.addEventListener('change', function(e){
    var host = closestEl(e.target, '#qpsSurvey');
    if (!host) return;
    root = host;
    if (e.target.id === 'svList')  { HAND.svList  && HAND.svList.call(e.target);  return; }
    if (e.target.id === 'svYear')  { HAND.svYear  && HAND.svYear.call(e.target);  return; }
    if (e.target.id === 'chkScore'){ HAND.chkScore && HAND.chkScore();            return; }
  });

  /* ── 시작 ── */
  loadCodes(function(){
    fillCode(gel('a_writer'), 'QPS_SRV_WRITER');
    fillCode(gel('a_sex'),    'QPS_SRV_SEX');
    fillCode(gel('a_age'),    'QPS_SRV_AGE');
  });
  loadBase();
})();

/* === 글자 크기 (2026-08-18 요청) ==========================================
   QI 계획서(qpsQiPlan)의 zzZoom 과 **같은 규칙** - 0.8~1.6배, 0.1 단위, ↺ 는 처음 크기.
   ★고른 크기는 **이 PC 이 브라우저에만** 남는다(localStorage). 키는 화면마다 따로 둔다. */
(function(){
  var W = 'qpsSurvey', ZKEY = 'qpsZoom_' + W;
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
