<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%-- qpsFmea.jsp — FMEA 계획서 · 보고서 (2026-08-11)

     ★★보고서가 계획서를 포함한다(보고서 2·3면 = 계획서 내용).
       ⇒ 한 화면 + 문서구분(P=계획서 / R=보고서). 보고서를 고르면 뒤 섹션이 더 열린다.
     ★투약보고서(5면)는 낙상(12면)의 축약판 — ***섹션을 비우면 인쇄에서 빠진다.***
       주제마다 화면을 만들지 않는다.
     ★FMEA 회의록은 이 화면에 없다 — 서식 1호에 구분 F 로 흡수했다(차수는 회의명에).

     ★★산식 (원본 인쇄물에 박혀 있다)
        위험도점수 = 발생가능성 × 심각성
        RPN        = 심각성 × 발생가능성 × 발견가능성
     ⚠CI 는 산식이 인쇄돼 있지 않다 → `심각성 × 발생가능성` 으로 셈하되 **화면에 「추정」이라고 밝힌다.**
       조용히 틀린 값을 내는 것이 가장 나쁘다. 서버도 같은 산식으로 다시 셈한다.

     ★주의: 이 파일 안에서 Deferred EL 표기(샵+중괄호) 금지 --%>

<script src="/asset/js/ui-message.js"></script>
<%@ include file="/WEB-INF/jsp/main/inc/qpsFileBox.jsp" %>

<div class="dashboard-wrapper">
<div id="qpsFmea" data-wnn="<c:out value='${wnnYn}'/>">
<style>
  #qpsFmea{ background:#f4f6f8; color:#1f2a30; min-height:100%; padding:14px 16px 60px; max-width:100%; overflow-x:hidden; }
  #qpsFmea *{ box-sizing:border-box; }
  #qpsFmea .fm-head{ display:flex; align-items:center; gap:10px; margin-bottom:12px; flex-wrap:wrap; }
  #qpsFmea .fm-title{ font-size:18px; font-weight:800; color:#20303a; display:flex; align-items:center; gap:8px; }
  #qpsFmea .fm-dot{ width:10px; height:10px; border-radius:50%; background:linear-gradient(135deg,#1f5a4b,#2a7665); }
  #qpsFmea .fm-sub{ font-size:12px; color:#6b7c86; }
  #qpsFmea .fm-hosp{ background:#e7f3ee; color:#1f5a4b; font-size:12px; font-weight:800;
      border:1px solid #cfe3da; border-radius:14px; padding:3px 11px; }
  #qpsFmea .fm-spacer{ flex:1; }
  #qpsFmea select, #qpsFmea input, #qpsFmea textarea{
      border:1px solid #cfd8e0; border-radius:5px; padding:5px 7px; font-family:inherit; font-size:12.5px; background:#fff; }
  #qpsFmea textarea{ resize:vertical; line-height:1.55; width:100%; }
  #qpsFmea .fm-btn{ border:1px solid #1f5a4b; background:#1f5a4b; color:#fff; border-radius:6px;
      padding:6px 14px; font-size:13px; font-weight:600; cursor:pointer; white-space:nowrap; }
  #qpsFmea .fm-btn.ghost{ background:#fff; color:#1f5a4b; }
  #qpsFmea .fm-btn.warn{ background:#fff; color:#b23b3b; border-color:#e0b4b4; }
  #qpsFmea .fm-btn.mini{ padding:2px 9px; font-size:11.5px; border-color:#cfd8e0; color:#556570; background:#fff; }

  #qpsFmea .fm-wrap{ display:flex; gap:14px; align-items:flex-start; }
  #qpsFmea .fm-left{ width:250px; flex:none; }
  #qpsFmea .fm-right{ flex:1; min-width:0; }
  #qpsFmea .fm-card{ background:#fff; border:1px solid #e3e9ed; border-radius:10px; padding:14px 16px; margin-bottom:12px; }
  #qpsFmea .fm-card h4{ margin:0 0 10px; font-size:14px; font-weight:800; color:#1f5a4b; }
  #qpsFmea .fm-card h4 .hint{ font-weight:500; font-size:12px; color:#8a99a3; }
  #qpsFmea .fm-card h4 .no{ display:inline-block; padding:1px 7px; background:#1f5a4b; color:#fff;
      border-radius:4px; font-size:11.5px; margin-right:6px; }
  #qpsFmea .fm-list{ max-height:480px; overflow:auto; }
  #qpsFmea .fm-item{ padding:8px 10px; border:1px solid #eef2f5; border-radius:8px; margin-bottom:6px; cursor:pointer; }
  #qpsFmea .fm-item:hover{ border-color:#8fc3b2; background:#f7fbf9; }
  #qpsFmea .fm-item.on{ border-color:#1f5a4b; background:#f0f7f4; }
  #qpsFmea .fm-item .t{ font-size:13px; font-weight:700; color:#20303a; }
  #qpsFmea .fm-item .d{ font-size:11.5px; color:#8a99a3; margin-top:2px; }
  #qpsFmea .fm-empty{ color:#8a99a3; font-size:12.5px; padding:16px 6px; text-align:center; }

  #qpsFmea .fm-form{ display:grid; grid-template-columns:110px 1fr 110px 1fr; gap:9px 10px; align-items:start; }
  #qpsFmea .fm-form .lb{ font-size:12.5px; font-weight:700; color:#43555f; padding-top:8px; }
  #qpsFmea .fm-form .full{ grid-column:2 / -1; }
  #qpsFmea .fm-form input{ width:100%; }
  #qpsFmea table.ed{ width:100%; border-collapse:collapse; font-size:12px; }
  #qpsFmea table.ed th{ background:#f2f6f8; border:1px solid #dde5ea; padding:5px 3px; font-weight:700; color:#43555f; }
  #qpsFmea table.ed td{ border:1px solid #e6ecef; padding:2px; }
  #qpsFmea table.ed input, #qpsFmea table.ed select{ width:100%; border:none; background:transparent; padding:4px 3px; font-size:12px; }
  #qpsFmea table.ed input:focus, #qpsFmea table.ed select:focus{ background:#f7fbf9; outline:1px solid #8fc3b2; }
  #qpsFmea table.ed td.calc{ background:#f7fbf9; font-weight:800; text-align:center; }
  #qpsFmea table.ed input[type=checkbox]{
      -webkit-appearance:checkbox !important; appearance:auto !important;
      width:15px !important; height:15px !important; margin:4px auto !important; display:block !important;
      opacity:1 !important; visibility:visible !important; position:static !important; cursor:pointer; }
  #qpsFmea .rowdel{ color:#b23b3b; cursor:pointer; font-weight:700; text-align:center; width:26px; }
  #qpsFmea .scale{ display:flex; gap:10px; flex-wrap:wrap; }
  #qpsFmea .scale table{ border-collapse:collapse; font-size:11px; }
  #qpsFmea .scale th, #qpsFmea .scale td{ border:1px solid #dfe4ea; padding:3px 6px; }
  #qpsFmea .scale th{ background:#f2f6f8; }
  #qpsFmea .warnbox{ background:#fff8f2; border:1px solid #f0d9c0; border-radius:6px;
      padding:7px 10px; font-size:12px; color:#8a5a2b; margin-bottom:8px; }
  /* ── 탭 · 글자 크기 (2026-08-15) — 카드가 세로로 쌓여 스크롤이 길다는 지적.
       ★한 화면에 들어가면 **탭을 내지 않는다**(고정으로 달지 않는다).
       ★탭 이름은 카드 제목에서 뽑고, 많으면 이웃끼리 묶어 **최대 4개**. */
  #qpsFmea .zz-tabs{ display:flex; gap:6px; margin:0 0 10px; flex-wrap:wrap; align-items:center; }
  #qpsFmea .zz-tab{ border:1px solid #cfd9e0; background:#f4f7f9; color:#43555f; border-radius:8px 8px 0 0;
                   padding:7px 15px; font-size:13.5px; font-weight:700; cursor:pointer; }
  #qpsFmea .zz-tab:hover{ background:#e9eff3; }
  #qpsFmea .zz-tab.on{ background:#1f5a4b; border-color:#1f5a4b; color:#fff; }
  #qpsFmea .zz-tab.dim{ opacity:.5; }
  #qpsFmea .zz-mode{ margin-left:auto; border:1px solid #1f5a4b; background:#fff; color:#1f5a4b;
                    border-radius:8px; padding:7px 14px; font-size:13px; font-weight:700; cursor:pointer; }
  #qpsFmea .zz-mode.on{ background:#1f5a4b; color:#fff; }
  #qpsFmea .zz-zoom{ display:inline-flex; gap:4px; align-items:center; margin-left:2px; }
  #qpsFmea .zz-zoom button{ border:1px solid #cfd9e0; background:#fff; color:#43555f; border-radius:6px;
                           padding:4px 9px; font-size:13px; font-weight:700; cursor:pointer; }
  #qpsFmea .zz-zoom button:hover{ background:#eef3f6; }
</style>

<div class="fm-head">
  <div class="fm-title"><span class="fm-dot"></span><span id="fmTitle">FMEA 계획서</span>
    <span class="fm-sub">주제별 1부</span></div>
  <span class="fm-hosp" id="fmHosp">🏥 <c:out value="${hospNm}" default="병원 미확인"/></span>
  <div class="fm-spacer"></div>
  <select id="fmGb" style="width:auto;" onchange="fmGbChange();">
    <option value="P">계획서</option>
    <option value="R">보고서</option>
  </select>
  <select id="fmYear" style="width:auto;" onchange="fmLoad();"></select>
  <button type="button" class="fm-btn" onclick="fmSave();">저장</button>
  <button type="button" class="fm-btn ghost" onclick="fmPrint();">🖨 인쇄(A4)</button>
  <button type="button" class="fm-btn warn" id="fmDelBtn" onclick="fmDel();" style="display:none;">삭제</button>
  <span class="fm-sub" id="fmStat"></span>
  <span style="flex:0 0 60px;"></span>
  <%-- 글자 크기 — 이 PC 이 브라우저에만 저장된다 --%>
  <span class="zz-zoom">
    <button type="button" onclick="zzZoom(-1);" title="글자 작게">가－</button>
    <button type="button" onclick="zzZoom(1);"  title="글자 크게">가＋</button>
    <button type="button" onclick="zzZoom(0);"  title="처음 크기로">↺</button>
  </span>
</div>
<%-- ★탭 — 내용이 한 화면을 넘칠 때만 나온다(zzSync 가 재 본다) --%>
<div class="zz-tabs" id="zzTabs" style="display:none;"></div>

<div class="fm-wrap">
  <div class="fm-left">
    <div class="fm-card">
      <h4>문서 목록 <span class="hint" id="fmCnt"></span></h4>
      <div class="fm-list" id="fmListBox"><div class="fm-empty">불러오는 중…</div></div>
      <button type="button" class="fm-btn ghost" style="width:100%; margin-top:6px;" onclick="fmNew();">＋ 새 문서</button>
    </div>
    <div class="fm-card" id="cardScale">
      <h4>점수 척도 <span class="hint">— 원본 기준</span></h4>
      <div id="fmScaleBox" style="font-size:11px;"></div>
    </div>
  </div>

  <div class="fm-right">
    <div class="fm-card">
      <h4>기본</h4>
      <input type="hidden" id="f_fmeSeq" value="">
      <div class="fm-form">
        <div class="lb">작성날짜</div> <div><input type="date" id="f_writeDt"></div>
        <div class="lb">작성자</div>   <div><input type="text" id="f_writerNm" maxlength="60" placeholder="QPS전담자"></div>
        <div class="lb">주제 *</div>
        <div class="full" style="display:flex; gap:8px; flex-wrap:wrap;">
          <select id="f_indiCd" style="width:250px;" onchange="fmPickIndi();">
            <option value="">— 지표에서 고르기 (없으면 직접 입력) —</option>
          </select>
          <input type="text" id="f_topicNm" maxlength="200" placeholder="주제 (예: 낙상예방활동)" style="flex:1; min-width:200px;">
        </div>
        <div class="lb" id="lbPurpose">목적</div> <div class="full"><textarea id="f_purpose" rows="3"></textarea></div>
      </div>
    </div>

    <div class="fm-card">
      <h4>팀 운영 <span class="hint">— 인쇄물에서는 원본처럼 가로 4벌 표로 조립됩니다</span></h4>
      <table class="ed" style="max-width:520px;"><thead><tr>
        <th style="width:110px;">구분</th><th>성명</th><th style="width:26px;"></th>
      </tr></thead><tbody id="tbTEAM"></tbody></table>
      <button type="button" class="fm-btn mini" style="margin-top:6px;" onclick="fmAddTeam();">＋ 행 추가</button>
    </div>

    <div class="fm-card">
      <h4>추진계획 및 활동일정
        <span class="hint">— 기간 열 이름을 쉼표로 적으면 그대로 열이 됩니다(원본은 「7~8월, 9월, 10월」)</span></h4>
      <div style="margin-bottom:8px;">
        <input type="text" id="f_prdHead" style="width:100%; max-width:520px;"
               placeholder="7~8월,9월,10월" onchange="renderSched();">
      </div>
      <div style="overflow-x:auto;"><table class="ed" style="min-width:700px;"><thead><tr id="schedHead"></tr></thead>
        <tbody id="tbSCHED"></tbody></table></div>
      <button type="button" class="fm-btn mini" style="margin-top:6px;" onclick="fmAddSched();">＋ 행 추가</button>
    </div>

    <%-- ───────── 보고서에서만 ───────── --%>
    <div class="fm-card rptonly">
      <h4><span class="no">1</span>고위험 프로세스 선정 · 위험도평가
        <span class="hint">— 위험도점수 = 발생가능성 × 심각성 (자동)</span></h4>
      <div class="fm-form" style="margin-bottom:10px;">
        <div class="lb">FMEA 진행 단계</div> <div class="full"><textarea id="f_stepTxt" rows="2"></textarea></div>
        <div class="lb">RCA와 다른점</div>  <div class="full"><textarea id="f_rcaDiff" rows="2"></textarea></div>
        <div class="lb">고위험 프로세스<br>선정</div> <div class="full"><textarea id="f_hiriskTxt" rows="3"></textarea></div>
      </div>
      <table class="ed"><thead><tr>
        <th style="width:34px;">NO</th><th>FMEA 주제</th>
        <th style="width:80px;">사건<br>보고건수</th><th style="width:80px;">발생<br>가능성</th>
        <th style="width:80px;">영향·<br>심각성</th><th style="width:80px;">위험도<br>점수</th>
        <th style="width:110px;">선정결과</th><th style="width:26px;"></th>
      </tr></thead><tbody id="tbRISK"></tbody></table>
      <button type="button" class="fm-btn mini" style="margin-top:6px;" onclick="fmAddRisk();">＋ 행 추가</button>
    </div>

    <div class="fm-card rptonly">
      <h4><span class="no">2</span>프로세스 맵 · 핵심지표</h4>
      <div class="fm-form">
        <div class="lb">프로세스 맵</div>
        <div class="full"><textarea id="f_procmapTxt" rows="3" placeholder="단계 흐름을 글로 적습니다. 그림은 첨부로."></textarea></div>
        <div class="lb">핵심지표 및<br>활동 목표</div> <div class="full"><textarea id="f_goalTxt" rows="2"></textarea></div>
      </div>
    </div>

    <%-- ★이 표가 FMEA 의 핵심 산출물이다 --%>
    <div class="fm-card rptonly">
      <h4><span class="no">3</span>FMEA Work Sheet
        <span class="hint">— RPN = 심각성 × 발생가능성 × 발견가능성 (자동) · 순위는 저장 시 매겨집니다</span></h4>
      <div class="warnbox">
        ⚠ <b>CI</b> 는 원본 인쇄물에 산식이 없어 <b>심각성 × 발생가능성</b>으로 셈합니다(추정).
        원본에서 확인되면 고쳐야 합니다.
      </div>
      <div style="overflow-x:auto;"><table class="ed" style="min-width:1180px;"><thead>
        <tr><th rowspan="2" style="width:110px;">Process(단계)</th>
            <th rowspan="2" style="min-width:170px;">가능한 고장유형</th>
            <th rowspan="2" style="min-width:170px;">가능한 원인</th>
            <th rowspan="2" style="min-width:150px;">잠재적인 영향</th>
            <th colspan="5" style="background:#eef3f6;">사전(개선 전)</th>
            <th colspan="5" style="background:#f2f6f8;">사후(개선 후)</th>
            <th rowspan="2" style="width:26px;"></th></tr>
        <tr><th style="width:52px;">발생</th><th style="width:52px;">심각</th><th style="width:52px;">발견</th>
            <th style="width:52px;">RPN</th><th style="width:46px;">CI</th>
            <th style="width:52px;">발생</th><th style="width:52px;">심각</th><th style="width:52px;">발견</th>
            <th style="width:52px;">RPN</th><th style="width:46px;">CI</th></tr>
      </thead><tbody id="tbSHEET"></tbody></table></div>
      <button type="button" class="fm-btn mini" style="margin-top:6px;" onclick="fmAddSheet();">＋ 행 추가</button>
    </div>

    <div class="fm-card rptonly">
      <h4><span class="no">4</span>근본원인 규명</h4>
      <div class="fm-form">
        <div class="lb">분석할 단계</div>       <div class="full"><textarea id="f_rootStep" rows="2"></textarea></div>
        <div class="lb">인적요인</div>          <div class="full"><textarea id="f_rootHr" rows="2"></textarea></div>
        <div class="lb">시설 및 환경요인</div>  <div class="full"><textarea id="f_rootEnv" rows="2"></textarea></div>
        <div class="lb">시스템요인</div>        <div class="full"><textarea id="f_rootSys" rows="2"></textarea></div>
        <div class="lb">fishbone</div>
        <div class="full"><textarea id="f_fishboneTxt" rows="2" placeholder="그림은 첨부로, 여기는 설명"></textarea></div>
      </div>
    </div>

    <div class="fm-card rptonly">
      <h4><span class="no">5</span>개선계획 · 검증 · 결론</h4>
      <div class="fm-form">
        <div class="lb">개선계획 및<br>구체적 방안</div> <div class="full"><textarea id="f_imprTxt" rows="3"></textarea></div>
      </div>
      <table class="ed" style="margin:8px 0;"><thead><tr>
        <th>개선 내용</th><th style="width:200px;">비고</th><th style="width:26px;"></th>
      </tr></thead><tbody id="tbIMPR"></tbody></table>
      <button type="button" class="fm-btn mini" onclick="fmAddImpr();">＋ 행 추가</button>
      <div class="fm-form" style="margin-top:10px;">
        <div class="lb">새로운 프로세스<br>분석과 검증</div> <div class="full"><textarea id="f_verifyTxt" rows="3"></textarea></div>
        <div class="lb">결론</div>          <div class="full"><textarea id="f_conclTxt" rows="3"></textarea></div>
        <div class="lb">추후 관리계획</div> <div class="full"><textarea id="f_nextTxt" rows="2"></textarea></div>
        <div class="lb">결과의 전달<br>및 공유</div> <div class="full"><textarea id="f_shareTxt" rows="2"></textarea></div>
      </div>
    </div>

    <div class="fm-card">
      <h4>첨부파일 <span class="hint">— 프로세스 맵 · fishbone 그림 · 사진</span></h4>
      <div id="fmFileBox"></div>
    </div>
  </div>
</div>

<script>
(function(){
  var HOSP_NM = '', APPR_LINE = [], INDI = [], SCALE = {}, curSeq = 0;

  var fileBox = window.qpsFileBox({ mount:'fmFileBox', refGb:'FMEA',
      hint:'프로세스 맵·fishbone·사진', needSaveMsg:'문서를 먼저 저장하면 첨부할 수 있습니다.' });

  function gel(id){ return document.getElementById(id); }   // ★$ 로 짓지 말 것
  function post(url, data){
    return $.ajax({ url:url, type:'POST', data:data, dataType:'json' }).then(function(res){
      if (res && res.result === 'FAIL') { throw new Error(res.message || '처리에 실패했습니다.'); }
      return res;
    });
  }
  function err(e){ _alertBox((e && e.message) ? e.message : '처리 중 오류가 발생했습니다.', {icon:'❌'}); }
  function esc(s){ return (s==null?'':String(s)).replace(/[&<>"]/g, function(c){
      return ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;'})[c]; }); }
  function val(id){ var e = gel(id); return e ? String(e.value).trim() : ''; }
  function set(id, v){ var e = gel(id); if (e) e.value = (v == null ? '' : v); }
  function gb(){ return gel('fmGb').value || 'P'; }
  function n(v){ var x = Number(v); return (v === '' || v == null || isNaN(x)) ? null : x; }

  (function(){
    var y = new Date().getFullYear(), sel = gel('fmYear');
    for (var i = y + 1; i >= y - 4; i--) sel.add(new Option(i + '년', i));
    sel.value = y;
  })();

  /** 계획서는 앞 세 카드만, 보고서는 전부. 원본에서 보고서가 계획서를 포함하기 때문. */
  window.fmGbChange = function(){
    var r = (gb() === 'R');
    gel('fmTitle').textContent = r ? 'FMEA 보고서' : 'FMEA 계획서';
    document.querySelectorAll('#qpsFmea .rptonly').forEach(function(el){ el.style.display = r ? '' : 'none'; });
    gel('cardScale').style.display = r ? '' : 'none';
    fmLoad();
  };

  // ── 척도표 ─────────────────────────────────────────────────────────
  function renderScale(){
    var box = gel('fmScaleBox'), NM = { SEVER:'심각도', OCCUR:'발생가능성', DETECT:'발견가능성' };
    var h = '';
    ['SEVER','OCCUR','DETECT'].forEach(function(k){
      var rows = SCALE[k] || [];
      if (!rows.length) return;
      h += '<div style="margin-bottom:8px;"><b>' + NM[k] + '</b><table style="width:100%;border-collapse:collapse;">' +
           rows.map(function(r){
             return '<tr><td style="border:1px solid #dfe4ea;width:26px;text-align:center;">' + r.score +
                    '</td><td style="border:1px solid #dfe4ea;padding:2px 4px;">' + esc(r.desctxt) + '</td></tr>';
           }).join('') + '</table></div>';
    });
    box.innerHTML = h || '<div class="fm-empty">척도가 없습니다.</div>';
  }
  /** 점수 셀렉트 — 척도에 있는 점수만 고르게 한다(임의 숫자로 RPN 이 흐려지지 않게) */
  function scaleSel(k, name, v){
    var rows = SCALE[k] || [];
    var h = '<select data-f="' + name + '"><option value=""></option>';
    rows.forEach(function(r){
      h += '<option value="' + r.score + '"' + (String(v) === String(r.score) ? ' selected' : '') + '>' + r.score + '</option>';
    });
    return h + '</select>';
  }

  // ── 행 ─────────────────────────────────────────────────────────────
  function teamRow(r){
    r = r || {};
    var tr = document.createElement('tr'); tr.setAttribute('data-sect','TEAM');
    tr.innerHTML = '<td><input data-f="grp" value="' + esc(r.grp) + '" placeholder="팀장·간사·팀원"></td>' +
      '<td><input data-f="c1" value="' + esc(r.c1) + '"></td>' +
      '<td class="rowdel" onclick="this.closest(\'tr\').remove();">✕</td>';
    gel('tbTEAM').appendChild(tr);
  }
  function prdCols(){
    var s = val('f_prdHead');
    var a = s ? s.split(',').map(function(x){ return x.trim(); }).filter(function(x){ return x; }) : [];
    return a.length ? a.slice(0, 8) : ['7~8월','9월','10월'];   // 원본 기본값
  }
  function schedRow(r){
    r = r || {};
    var cols = prdCols(), m = '';
    for (var i = 1; i <= cols.length; i++) {
      var k = 'm0' + i;
      m += '<td><input type="checkbox" data-f="' + k + '"' + (r[k] === 'Y' ? ' checked' : '') + '></td>';
    }
    var tr = document.createElement('tr'); tr.setAttribute('data-sect','SCHED');
    tr.innerHTML = '<td><input data-f="c1" value="' + esc(r.c1) + '"></td>' + m +
      '<td><input data-f="c2" value="' + esc(r.c2) + '"></td>' +
      '<td class="rowdel" onclick="this.closest(\'tr\').remove();">✕</td>';
    gel('tbSCHED').appendChild(tr);
  }
  window.renderSched = function(){
    // 기간 열이 바뀌면 표를 다시 그린다 — 값은 보존한다
    var keep = [];
    document.querySelectorAll('#tbSCHED tr').forEach(function(tr){ keep.push(readRow(tr)); });
    var cols = prdCols();
    gel('schedHead').innerHTML = '<th style="min-width:180px;">활동</th>' +
      cols.map(function(c){ return '<th style="width:70px;">' + esc(c) + '</th>'; }).join('') +
      '<th style="min-width:160px;">세부내용</th><th style="width:26px;"></th>';
    gel('tbSCHED').innerHTML = '';
    (keep.length ? keep : DEF_SCHED).forEach(schedRow);
  };
  function riskRow(r){
    r = r || {};
    var tr = document.createElement('tr'); tr.setAttribute('data-sect','RISK');
    tr.innerHTML = '<td style="text-align:center;color:#8a99a3;" data-no></td>' +
      '<td><input data-f="c1" value="' + esc(r.c1) + '"></td>' +
      '<td><input data-f="n1" value="' + esc(r.n1 == null ? '' : r.n1) + '" style="text-align:center;"></td>' +
      '<td><input data-f="n2" value="' + esc(r.n2 == null ? '' : r.n2) + '" style="text-align:center;" placeholder="1~5"></td>' +
      '<td><input data-f="n3" value="' + esc(r.n3 == null ? '' : r.n3) + '" style="text-align:center;" placeholder="1~5"></td>' +
      '<td class="calc" data-risk>' + (r.n4 == null ? '' : r.n4) + '</td>' +
      '<td><input data-f="c2" value="' + esc(r.c2) + '"></td>' +
      '<td class="rowdel" onclick="this.closest(\'tr\').remove(); recalc();">✕</td>';
    gel('tbRISK').appendChild(tr);
  }
  function imprRow(r){
    r = r || {};
    var tr = document.createElement('tr'); tr.setAttribute('data-sect','IMPR');
    tr.innerHTML = '<td><input data-f="c1" value="' + esc(r.c1) + '"></td>' +
      '<td><input data-f="c2" value="' + esc(r.c2) + '"></td>' +
      '<td class="rowdel" onclick="this.closest(\'tr\').remove();">✕</td>';
    gel('tbIMPR').appendChild(tr);
  }
  function sheetRow(r){
    r = r || {};
    var tr = document.createElement('tr'); tr.setAttribute('data-sheet','1');
    tr.innerHTML =
      '<td><input data-f="stepnm" value="' + esc(r.stepnm) + '"></td>' +
      '<td><input data-f="modenm" value="' + esc(r.modenm) + '"></td>' +
      '<td><input data-f="causenm" value="' + esc(r.causenm) + '"></td>' +
      '<td><input data-f="effectnm" value="' + esc(r.effectnm) + '"></td>' +
      '<td>' + scaleSel('OCCUR','aoccur', r.aoccur) + '</td>' +
      '<td>' + scaleSel('SEVER','asever', r.asever) + '</td>' +
      '<td>' + scaleSel('DETECT','adetect', r.adetect) + '</td>' +
      '<td class="calc" data-arpn>' + (r.arpn == null ? '' : r.arpn) + '</td>' +
      '<td class="calc" data-aci>' + (r.aci == null ? '' : r.aci) + '</td>' +
      '<td>' + scaleSel('OCCUR','boccur', r.boccur) + '</td>' +
      '<td>' + scaleSel('SEVER','bsever', r.bsever) + '</td>' +
      '<td>' + scaleSel('DETECT','bdetect', r.bdetect) + '</td>' +
      '<td class="calc" data-brpn>' + (r.brpn == null ? '' : r.brpn) + '</td>' +
      '<td class="calc" data-bci>' + (r.bci == null ? '' : r.bci) + '</td>' +
      '<td class="rowdel" onclick="this.closest(\'tr\').remove();">✕</td>';
    gel('tbSHEET').appendChild(tr);
  }
  window.fmAddTeam  = function(){ teamRow({}); };
  window.fmAddSched = function(){ schedRow({}); };
  window.fmAddRisk  = function(){ riskRow({}); recalc(); };
  window.fmAddImpr  = function(){ imprRow({}); };
  window.fmAddSheet = function(){ sheetRow({}); };

  var DEF_TEAM = [{grp:'팀장'},{grp:'간사'},{grp:'팀원'},{grp:'팀원'}];
  // 원본 계획서의 고정 11행
  var DEF_SCHED = ['주제선정, 팀 구성','FMEA에 대한 교육','활동계획 수립','Process map','Brain stoming',
                   'FMEA sheet 작성','RPN값 근본원인도출','프로세스 개선계획수립','Pilot test',
                   '프로세스적용 및 효과평가',''].map(function(t){ return { c1:t }; });

  function readRow(tr){
    var r = {};
    tr.querySelectorAll('[data-f]').forEach(function(el){
      r[el.getAttribute('data-f')] = (el.type === 'checkbox') ? (el.checked ? 'Y' : '') : String(el.value).trim();
    });
    return r;
  }

  /** 화면에서도 즉시 셈한다. ★서버가 저장 때 같은 산식으로 다시 셈하므로 두 값이 어긋날 수 없다. */
  window.recalc = function(){
    document.querySelectorAll('#tbRISK tr').forEach(function(tr, i){
      var r = readRow(tr), o = n(r.n2), s = n(r.n3);
      var c = tr.querySelector('[data-risk]'); if (c) c.textContent = (o == null || s == null) ? '' : (o * s);
      var no = tr.querySelector('[data-no]'); if (no) no.textContent = i + 1;
    });
    document.querySelectorAll('#tbSHEET tr').forEach(function(tr){
      var r = readRow(tr);
      function put(sel, v){ var c = tr.querySelector(sel); if (c) c.textContent = (v == null ? '' : v); }
      var ao = n(r.aoccur), as = n(r.asever), ad = n(r.adetect);
      put('[data-arpn]', (ao == null || as == null || ad == null) ? null : as * ao * ad);
      put('[data-aci]',  (ao == null || as == null) ? null : as * ao);
      var bo = n(r.boccur), bs = n(r.bsever), bd = n(r.bdetect);
      put('[data-brpn]', (bo == null || bs == null || bd == null) ? null : bs * bo * bd);
      put('[data-bci]',  (bo == null || bs == null) ? null : bs * bo);
    });
  };
  gel('qpsFmea').addEventListener('input',  function(e){ if (e.target.closest('#tbRISK,#tbSHEET')) recalc(); });
  gel('qpsFmea').addEventListener('change', function(e){ if (e.target.closest('#tbRISK,#tbSHEET')) recalc(); });

  function collectItems(){
    var out = [];
    ['TEAM','SCHED','RISK','IMPR'].forEach(function(sect){
      var sort = 0;
      document.querySelectorAll('#tb' + sect + ' tr').forEach(function(tr){
        var r = readRow(tr); r.sect = sect;
        var has = Object.keys(r).some(function(k){ return k !== 'sect' && r[k] !== '' && r[k] != null; });
        if (!has) return;
        r.sort = ++sort;
        out.push(r);
      });
    });
    return out;
  }
  function collectSheet(){
    var out = [], sort = 0;
    document.querySelectorAll('#tbSHEET tr').forEach(function(tr){
      var r = readRow(tr);
      var has = Object.keys(r).some(function(k){ return r[k] !== '' && r[k] != null; });
      if (!has) return;
      r.sort = ++sort;
      out.push(r);
    });
    return out;
  }

  window.fmPickIndi = function(){
    var cd = val('f_indiCd');
    if (!cd) return;
    for (var i = 0; i < INDI.length; i++) {
      if (String(INDI[i].indicd) === cd) { if (!val('f_topicNm')) set('f_topicNm', INDI[i].indinm); break; }
    }
  };

  window.fmLoad = function(){
    return post('<c:url value="/qps/fmeaBase.do"/>', { inYear: gel('fmYear').value, docGb: gb() }).then(function(res){
      if (res.hosp) { HOSP_NM = res.hosp.hospnm || ''; gel('fmHosp').textContent = '🏥 ' + HOSP_NM; }
      APPR_LINE = res.line || [];
      INDI = res.indi || [];
      SCALE = {};
      (res.scale || []).forEach(function(r){ (SCALE[r.scalegb] = SCALE[r.scalegb] || []).push(r); });
      renderScale();
      var sel = gel('f_indiCd'), keep = sel.value;
      sel.innerHTML = '<option value="">— 지표에서 고르기 (없으면 직접 입력) —</option>';
      INDI.forEach(function(d){ sel.add(new Option(d.indinm, d.indicd)); });
      sel.value = keep;

      var list = res.list || [], box = gel('fmListBox');
      gel('fmCnt').textContent = list.length ? ('· ' + list.length + '건') : '';
      box.innerHTML = list.length
        ? list.map(function(r){
            return '<div class="fm-item' + (Number(r.fmeseq) === curSeq ? ' on' : '') + '" onclick="fmOpen(' + r.fmeseq + ');">' +
                   '<div class="t">' + esc(r.topicnm || '(주제 없음)') + '</div>' +
                   '<div class="d">' + esc(r.writedt || '') + '</div></div>';
          }).join('')
        : '<div class="fm-empty">문서가 없습니다.<br>[＋ 새 문서]로 만드세요.</div>';
    }).catch(err);
  };

  var TXT = ['f_writeDt','f_writerNm','f_topicNm','f_purpose','f_prdHead','f_stepTxt','f_rcaDiff',
             'f_hiriskTxt','f_goalTxt','f_procmapTxt','f_rootStep','f_rootHr','f_rootEnv','f_rootSys',
             'f_fishboneTxt','f_imprTxt','f_verifyTxt','f_conclTxt','f_nextTxt','f_shareTxt'];

  window.fmOpen = function(seq){
    post('<c:url value="/qps/fmeaGet.do"/>', { fmeSeq: seq }).then(function(res){
      var d = res.doc || {};
      curSeq = Number(d.fmeseq || 0);
      if (d.docgb && d.docgb !== gb()) {
        gel('fmGb').value = d.docgb;
        var r = (d.docgb === 'R');
        gel('fmTitle').textContent = r ? 'FMEA 보고서' : 'FMEA 계획서';
        document.querySelectorAll('#qpsFmea .rptonly').forEach(function(el){ el.style.display = r ? '' : 'none'; });
        gel('cardScale').style.display = r ? '' : 'none';
      }
      set('f_fmeSeq', d.fmeseq); set('f_indiCd', d.indicd || '');
      set('f_writeDt', d.writedt); set('f_writerNm', d.writernm); set('f_topicNm', d.topicnm);
      set('f_purpose', d.purpose); set('f_prdHead', d.prdhead);
      set('f_stepTxt', d.steptxt); set('f_rcaDiff', d.rcadiff); set('f_hiriskTxt', d.hirisktxt);
      set('f_goalTxt', d.goaltxt); set('f_procmapTxt', d.procmaptxt); set('f_rootStep', d.rootstep);
      set('f_rootHr', d.roothr); set('f_rootEnv', d.rootenv); set('f_rootSys', d.rootsys);
      set('f_fishboneTxt', d.fishbonetxt); set('f_imprTxt', d.imprtxt); set('f_verifyTxt', d.verifytxt);
      set('f_conclTxt', d.concltxt); set('f_nextTxt', d.nexttxt); set('f_shareTxt', d.sharetxt);

      var items = res.items || [];
      function by(s){ return items.filter(function(r){ return r.sect === s; }); }
      gel('tbTEAM').innerHTML = ''; gel('tbRISK').innerHTML = ''; gel('tbIMPR').innerHTML = '';
      (by('TEAM').length ? by('TEAM') : DEF_TEAM).forEach(teamRow);
      (by('RISK').length ? by('RISK') : [{},{},{}]).forEach(riskRow);
      (by('IMPR').length ? by('IMPR') : [{},{}]).forEach(imprRow);
      gel('tbSCHED').innerHTML = '';
      gel('schedHead').innerHTML = '';
      var sc = by('SCHED');
      var cols = prdCols();
      gel('schedHead').innerHTML = '<th style="min-width:180px;">활동</th>' +
        cols.map(function(c){ return '<th style="width:70px;">' + esc(c) + '</th>'; }).join('') +
        '<th style="min-width:160px;">세부내용</th><th style="width:26px;"></th>';
      (sc.length ? sc : DEF_SCHED).forEach(schedRow);

      gel('tbSHEET').innerHTML = '';
      var sh = res.sheet || [];
      (sh.length ? sh : [{},{},{}]).forEach(sheetRow);
      recalc();
      gel('fmStat').textContent = '— 저장된 문서 #' + d.fmeseq;
      gel('fmDelBtn').style.display = '';
      if (fileBox) fileBox.setKey(d.fmeseq);
      fmLoad();
    }).catch(err);
  };

  window.fmNew = function(){
    curSeq = 0;
    set('f_fmeSeq', ''); set('f_indiCd', '');
    TXT.forEach(function(id){ set(id, ''); });
    gel('tbTEAM').innerHTML = ''; DEF_TEAM.forEach(teamRow);
    gel('tbRISK').innerHTML = ''; [{},{},{}].forEach(riskRow);
    gel('tbIMPR').innerHTML = ''; [{},{}].forEach(imprRow);
    gel('tbSHEET').innerHTML = ''; [{},{},{}].forEach(sheetRow);
    gel('tbSCHED').innerHTML = '';   // ★먼저 비운다 — renderSched 는 남은 행의 값을 보존하므로
    renderSched();
    recalc();
    gel('fmStat').textContent = '— 새 문서';
    gel('fmDelBtn').style.display = 'none';
    if (fileBox) fileBox.setKey('');
    fmLoad();
  };

  window.fmSave = function(){
    if (!val('f_topicNm')) { _alertBox('주제를 입력해 주세요.', {icon:'⚠️'}); return; }
    var m = { fmeSeq: val('f_fmeSeq'), inYear: gel('fmYear').value, docGb: gb(),
              indiCd: val('f_indiCd'), topicNm: val('f_topicNm'),
              writeDt: val('f_writeDt'), writerNm: val('f_writerNm'), purpose: val('f_purpose'),
              prdHead: val('f_prdHead') || prdCols().join(','),
              stepTxt: val('f_stepTxt'), rcaDiff: val('f_rcaDiff'), hiriskTxt: val('f_hiriskTxt'),
              goalTxt: val('f_goalTxt'), procmapTxt: val('f_procmapTxt'), rootStep: val('f_rootStep'),
              rootHr: val('f_rootHr'), rootEnv: val('f_rootEnv'), rootSys: val('f_rootSys'),
              fishboneTxt: val('f_fishboneTxt'), imprTxt: val('f_imprTxt'), verifyTxt: val('f_verifyTxt'),
              conclTxt: val('f_conclTxt'), nextTxt: val('f_nextTxt'), shareTxt: val('f_shareTxt'),
              items: JSON.stringify(collectItems()), sheet: JSON.stringify(collectSheet()) };
    post('<c:url value="/qps/fmeaSave.do"/>', m).then(function(res){
      _toast('저장되었습니다.', 'ok');
      fmOpen(res.fmeSeq);
    }).catch(err);
  };

  window.fmDel = function(){
    if (!curSeq) return;
    _confirmBox({ msg:'이 문서를 삭제할까요?', icon:'⚠️', okText:'삭제', okColor:'#b23b3b',
      onOk: function(){
        post('<c:url value="/qps/fmeaDelete.do"/>', { fmeSeq: curSeq }).then(function(){
          _toast('삭제되었습니다.', 'ok'); fmNew();
        }).catch(err);
      } });
  };

  // ---------- 인쇄 — 빈 섹션은 빠진다(투약보고서처럼 축약판이 자연스럽게 나온다) ----------
  var PRINT_CSS =
    '@page{ size:A4 portrait; margin:11mm; }' +
    'body{ margin:0; font-family:"맑은 고딕",Malgun Gothic,sans-serif; color:#000; }' +
    '.h1{ font-size:17px; font-weight:800; text-align:center; margin:0 0 8px; letter-spacing:1px; }' +
    '.sec{ font-size:12.5px; font-weight:800; margin:10px 0 4px; padding-bottom:2px; border-bottom:1.5px solid #333; }' +
    'table{ width:100%; border-collapse:collapse; font-size:9.5px; margin-bottom:5px; }' +
    'th,td{ border:1px solid #666; padding:3px 4px; text-align:center; vertical-align:middle; line-height:1.5; }' +
    'th{ background:#efefef; font-weight:700; }' +
    'td.l{ text-align:left; } td.pre{ text-align:left; white-space:pre-wrap; }' +
    '.appr{ float:right; width:auto; margin:0 0 4px 8px; font-size:9.5px; }' +
    '.appr th{ padding:2px 6px; } .appr td{ height:40px; width:56px; }' +
    '.brk{ page-break-before:always; } tr{ page-break-inside:avoid; }';

  function apprHtml(){
    if (!APPR_LINE.length) return '';
    var h = '<table class="appr"><thead><tr>';
    APPR_LINE.forEach(function(r){ h += '<th>' + esc(r.stepnm) + '</th>'; });
    h += '</tr></thead><tbody><tr>';
    APPR_LINE.forEach(function(){ h += '<td></td>'; });
    return h + '</tr></tbody></table>';
  }
  /** 값이 있을 때만 낸다 — 이것이 투약보고서(축약판)를 자동으로 만들어 준다. */
  function secTxt(title, v){
    return v ? ('<div class="sec">' + title + '</div><div style="border:1px solid #666;padding:5px 7px;' +
                'font-size:9.5px;white-space:pre-wrap;text-align:left;">' + esc(v) + '</div>') : '';
  }

  window.fmPrint = function(){
    var yy = gel('fmYear').value, isR = (gb() === 'R');
    var items = collectItems(), sheet = collectSheet();
    function by(s){ return items.filter(function(r){ return r.sect === s; }); }

    // 팀 — 가로 4벌
    var team = by('TEAM'), trs = '';
    for (var i = 0; i < team.length; i += 4) {
      var tds = '';
      for (var k = 0; k < 4; k++) {
        var m = team[i + k];
        tds += '<th style="width:7%;">' + (m ? esc(m.grp) : '') + '</th><td style="width:18%;">' + (m ? esc(m.c1) : '') + '</td>';
      }
      trs += '<tr>' + tds + '</tr>';
    }
    var teamTbl = trs ? ('<div class="sec">팀 운영</div><table><tbody>' + trs + '</tbody></table>') : '';

    // 활동일정
    var cols = prdCols(), sched = by('SCHED');
    var schedTbl = sched.length ? ('<div class="sec">추진계획 및 활동일정</div><table><thead><tr><th>활동</th>' +
      cols.map(function(c){ return '<th style="width:52px;">' + esc(c) + '</th>'; }).join('') +
      '<th style="width:130px;">세부내용</th></tr></thead><tbody>' +
      sched.map(function(r){
        var m = '';
        for (var j = 1; j <= cols.length; j++) m += '<td>' + (r['m0' + j] === 'Y' ? '●' : '') + '</td>';
        return '<tr><td class="l">' + esc(r.c1) + '</td>' + m + '<td class="l">' + esc(r.c2) + '</td></tr>';
      }).join('') + '</tbody></table>') : '';

    // 위험도평가
    var risk = by('RISK');
    var riskTbl = risk.length ? ('<div class="sec">고위험 프로세스 선정 — 위험도평가</div>' +
      '<table><thead><tr><th style="width:26px;">NO</th><th>FMEA 주제</th><th style="width:60px;">사건<br>보고건수</th>' +
      '<th style="width:56px;">발생<br>가능성</th><th style="width:56px;">영향·<br>심각성</th>' +
      '<th style="width:56px;">위험도<br>점수</th><th style="width:80px;">선정결과</th></tr></thead><tbody>' +
      risk.map(function(r, i){
        var o = Number(r.n2), s = Number(r.n3);
        var sc = (isNaN(o) || isNaN(s) || r.n2 === '' || r.n3 === '') ? '' : (o * s);
        return '<tr><td>' + (i + 1) + '</td><td class="l">' + esc(r.c1) + '</td><td>' + esc(r.n1) + '</td>' +
               '<td>' + esc(r.n2) + '</td><td>' + esc(r.n3) + '</td><td><b>' + sc + '</b></td>' +
               '<td>' + esc(r.c2) + '</td></tr>';
      }).join('') + '</tbody></table>') : '';

    // Work Sheet
    var shTbl = sheet.length ? ('<div class="brk"></div><div class="sec">FMEA Work Sheet</div>' +
      '<table><thead><tr><th rowspan="2" style="width:70px;">Process</th><th rowspan="2">고장유형</th>' +
      '<th rowspan="2">원인</th><th rowspan="2">영향</th>' +
      '<th colspan="5">사전</th><th colspan="5">사후</th></tr>' +
      '<tr><th style="width:30px;">발생</th><th style="width:30px;">심각</th><th style="width:30px;">발견</th>' +
      '<th style="width:34px;">RPN</th><th style="width:30px;">CI</th>' +
      '<th style="width:30px;">발생</th><th style="width:30px;">심각</th><th style="width:30px;">발견</th>' +
      '<th style="width:34px;">RPN</th><th style="width:30px;">CI</th></tr></thead><tbody>' +
      sheet.map(function(r){
        function mul(a, b, c){
          var x = Number(a), y = Number(b), z = (c == null ? 1 : Number(c));
          if (a === '' || b === '' || isNaN(x) || isNaN(y) || (c != null && (c === '' || isNaN(z)))) return '';
          return x * y * z;
        }
        return '<tr><td class="l">' + esc(r.stepnm) + '</td><td class="l">' + esc(r.modenm) + '</td>' +
               '<td class="l">' + esc(r.causenm) + '</td><td class="l">' + esc(r.effectnm) + '</td>' +
               '<td>' + esc(r.aoccur) + '</td><td>' + esc(r.asever) + '</td><td>' + esc(r.adetect) + '</td>' +
               '<td><b>' + mul(r.asever, r.aoccur, r.adetect) + '</b></td><td>' + mul(r.asever, r.aoccur) + '</td>' +
               '<td>' + esc(r.boccur) + '</td><td>' + esc(r.bsever) + '</td><td>' + esc(r.bdetect) + '</td>' +
               '<td><b>' + mul(r.bsever, r.boccur, r.bdetect) + '</b></td><td>' + mul(r.bsever, r.boccur) + '</td></tr>';
      }).join('') + '</tbody></table>' +
      '<div style="font-size:9px;color:#555;">RPN = 심각성 × 발생가능성 × 발견가능성 &nbsp;/&nbsp; ' +
      'CI = 심각성 × 발생가능성 <b>(추정 산식)</b></div>') : '';

    var impr = by('IMPR');
    var imprTbl = impr.length ? ('<div class="sec">개선계획</div><table><thead><tr><th>개선 내용</th>' +
      '<th style="width:150px;">비고</th></tr></thead><tbody>' +
      impr.map(function(r){ return '<tr><td class="l">' + esc(r.c1) + '</td><td class="l">' + esc(r.c2) + '</td></tr>'; }).join('') +
      '</tbody></table>') : '';

    var body = apprHtml() +
      '<div class="h1">' + esc(yy) + ' 년 FMEA ' + (isR ? '보고서' : '계획서') + '</div><div style="clear:both;"></div>' +
      '<table><tbody><tr><th style="width:80px;">주제</th><td class="l">' + esc(val('f_topicNm')) + '</td>' +
        '<th style="width:70px;">작성날짜</th><td style="width:100px;">' + esc(val('f_writeDt')) + '</td></tr>' +
        '<tr><th>작성자</th><td class="l" colspan="3">' + esc(val('f_writerNm')) + '</td></tr></tbody></table>' +
      secTxt('목적', val('f_purpose')) +
      teamTbl + schedTbl +
      (isR ? (secTxt('FMEA 진행 단계', val('f_stepTxt')) + secTxt('RCA와 다른점', val('f_rcaDiff')) +
              secTxt('고위험 프로세스 선정', val('f_hiriskTxt')) + riskTbl +
              secTxt('프로세스 맵', val('f_procmapTxt')) + secTxt('핵심지표 및 활동 목표', val('f_goalTxt')) +
              shTbl +
              secTxt('근본원인 — 분석할 단계', val('f_rootStep')) +
              secTxt('근본원인 — 인적요인', val('f_rootHr')) +
              secTxt('근본원인 — 시설 및 환경요인', val('f_rootEnv')) +
              secTxt('근본원인 — 시스템요인', val('f_rootSys')) +
              secTxt('fishbone', val('f_fishboneTxt')) +
              secTxt('개선계획 및 구체적 방안', val('f_imprTxt')) + imprTbl +
              secTxt('새로운 프로세스의 분석과 검증', val('f_verifyTxt')) +
              secTxt('결론', val('f_conclTxt')) + secTxt('추후 관리계획', val('f_nextTxt')) +
              secTxt('결과의 전달 및 공유', val('f_shareTxt')))
           : '') +
      '<div style="font-size:9px;color:#444;margin-top:4px;">※ 프로세스 맵·fishbone 그림은 첨부파일로 관리합니다.</div>';

    var title = ('FMEA' + (isR ? '보고서' : '계획서') + '_' + yy + '_' + val('f_topicNm') + '_' + HOSP_NM)
                .replace(/[\\\/:*?"<>|]/g, '-');
    var w = window.open('', '_blank', 'width=1000,height=1000');
    if (!w) { _alertBox('팝업이 차단되어 인쇄창을 열지 못했습니다.<br>주소창 오른쪽의 팝업 차단을 허용해 주세요.', {icon:'⚠️'}); return; }
    w.document.open();
    w.document.write('<!doctype html><html lang="ko"><head><meta charset="utf-8"><title>' + esc(title) +
      '</title><style>' + PRINT_CSS + '</style></head><body>' + body + '</body></html>');
    w.document.close();
    w.focus();
    setTimeout(function(){ try { w.print(); } catch (e) { } }, 300);
  };

  $(function(){
    // 계획서로 시작 — 보고서 카드는 숨긴 채로
    document.querySelectorAll('#qpsFmea .rptonly').forEach(function(el){ el.style.display = 'none'; });
    gel('cardScale').style.display = 'none';
    fmLoad().then(function(){ fmNew(); });
  });
})();

  /* ═══ 탭 · 글자 크기 (2026-08-15 · 사용자 요청) ═══════════════════════════
     ★***고정으로 달지 않는다*** — 전부 펼친 높이를 재서 **한 화면을 넘칠 때만** 탭을 낸다.
       창 크기·글자 크기가 바뀌면 다시 잰다.
     ★탭이 **잘게 나뉘지 않게** 이웃 카드를 묶어 최대 4개. 이름은 첫 카드 제목(+「외」).
     ★「전체 보기」는 탭이 아니라 **보기 방식**이라 오른쪽 끝에 따로 둔다.
     ⚠인쇄는 별도 창이라 탭과 무관하다(숨긴 항목도 종이에는 다 나온다). */
  (function(){
    var KEY = 'qpsTab_qpsFmea', ZKEY = 'qpsZoom_qpsFmea', cur = 0;
    function cards(){ return [].slice.call(document.querySelectorAll('#qpsFmea .fm-card')); }
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
      var w = document.getElementById('qpsFmea');
      if (w) w.style.zoom = z.toFixed(2);
      return z;
    }
    window.zzZoom = function(d){
      var w = document.getElementById('qpsFmea'), c0 = parseFloat(w && w.style.zoom) || 1;
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
      var _mw = document.getElementById('qpsFmea'), _mt;
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
</div><%-- /#qpsFmea --%>
</div><%-- /.dashboard-wrapper --%>
