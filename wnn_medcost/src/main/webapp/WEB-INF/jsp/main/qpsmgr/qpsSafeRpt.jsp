<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%-- qpsSafeRpt.jsp — 사고 유형별 보고서 (보고서 폴더, 2026-08-11)

     원본 트리 10종. 실측 8종 대조 결과 ***골격은 같고 체크박스 묶음만 통째로 다르다.***
     ⇒ 지표 18종을 화면 하나로 처리한 방식 그대로 :
        **공통 골격은 화면 하나, 체크박스 묶음은 데이터(항목표)로.**
        이 화면에는 유형별 분기가 없다 — 서버가 준 항목표(def)를 순회해 그릴 뿐이다.
        서식이 늘어도 TBL_QPS_SAFERPT_DEF·_USE 에 행을 넣으면 끝난다.

     ★★사고 원천은 TBL_QPS_INCIDENT 재사용. 사고를 고르면 환자·일시·장소가 채워진다 —
       ***같은 사고를 지표용·보고서용으로 두 번 입력하게 만들지 않는다.***

     ★근접오류는 없다(원본도 준비중 메뉴) · 라운딩 점검표는 서식 3호 · 정신은 별도 과제.
     ★주의: 이 파일 안에서 Deferred EL 표기(샵+중괄호) 금지 --%>

<script src="/asset/js/ui-message.js"></script>
<%@ include file="/WEB-INF/jsp/main/inc/qpsFileBox.jsp" %>

<div class="dashboard-wrapper">
<div id="qpsSafeRpt" data-wnn="<c:out value='${wnnYn}'/>">
<style>
  #qpsSafeRpt{ background:#f4f6f8; color:#1f2a30; min-height:100%; padding:14px 16px 60px; max-width:100%; overflow-x:hidden; }
  #qpsSafeRpt *{ box-sizing:border-box; }
  #qpsSafeRpt .sr-head{ display:flex; align-items:center; gap:10px; margin-bottom:12px; flex-wrap:wrap; }
  #qpsSafeRpt .sr-title{ font-size:18px; font-weight:800; color:#20303a; display:flex; align-items:center; gap:8px; }
  #qpsSafeRpt .sr-dot{ width:10px; height:10px; border-radius:50%; background:linear-gradient(135deg,#1f5a4b,#2a7665); }
  #qpsSafeRpt .sr-sub{ font-size:12px; color:#6b7c86; }
  #qpsSafeRpt .sr-hosp{ background:#e7f3ee; color:#1f5a4b; font-size:12px; font-weight:800;
      border:1px solid #cfe3da; border-radius:14px; padding:3px 11px; }
  #qpsSafeRpt .sr-spacer{ flex:1; }
  #qpsSafeRpt select, #qpsSafeRpt input, #qpsSafeRpt textarea{
      border:1px solid #cfd8e0; border-radius:5px; padding:5px 7px; font-family:inherit; font-size:12.5px; background:#fff; }
  #qpsSafeRpt textarea{ resize:vertical; line-height:1.55; width:100%; }
  #qpsSafeRpt .sr-btn{ border:1px solid #1f5a4b; background:#1f5a4b; color:#fff; border-radius:6px;
      padding:6px 14px; font-size:13px; font-weight:600; cursor:pointer; white-space:nowrap; }
  #qpsSafeRpt .sr-btn.ghost{ background:#fff; color:#1f5a4b; }
  #qpsSafeRpt .sr-btn.warn{ background:#fff; color:#b23b3b; border-color:#e0b4b4; }

  #qpsSafeRpt .sr-wrap{ display:flex; gap:14px; align-items:flex-start; }
  #qpsSafeRpt .sr-left{ width:260px; flex:none; }
  #qpsSafeRpt .sr-right{ flex:1; min-width:0; max-width:1000px; }
  #qpsSafeRpt .sr-card{ background:#fff; border:1px solid #e3e9ed; border-radius:10px; padding:14px 16px; margin-bottom:12px; }
  /* ── 탭 (2026-08-15) — 카드 7장이 세로로 쌓여 스크롤이 길다는 지적. 묶어서 한 번에 한 묶음만 보인다.
       ★「전체」 탭을 남겨 둔다 — 종전처럼 쭉 훑고 싶은 사람도 있다(기본은 「기본」). */
  #qpsSafeRpt .sr-tabs{ display:flex; gap:6px; margin:0 0 10px; flex-wrap:wrap; }
  #qpsSafeRpt .sr-tab{ border:1px solid #cfd9e0; background:#f4f7f9; color:#43555f; border-radius:8px 8px 0 0;
                       padding:7px 16px; font-size:13.5px; font-weight:700; cursor:pointer; }
  #qpsSafeRpt .sr-tab:hover{ background:#e9eff3; }
  #qpsSafeRpt .sr-tab.on{ background:#1f5a4b; border-color:#1f5a4b; color:#fff; }
  #qpsSafeRpt .sr-tab .n{ font-weight:400; opacity:.75; margin-left:5px; font-size:12px; }
  /* ── 글자 크기 (2026-08-15) — SUNWOO 의 [폰트 확대/축소] 와 같은 자리.
       ★CSS 가 px 로 짜여 있어 뿌리 font-size 를 키워도 안 따라온다 ⇒ `zoom` 으로 통째로 키운다.
         격자·칸 너비까지 같이 커져 원본 프로그램과 같은 느낌이 된다. 인쇄는 새 창이라 영향 없다. */
  #qpsSafeRpt .sr-zoom{ display:inline-flex; gap:4px; align-items:center; margin-left:2px; }
  #qpsSafeRpt .sr-zoom button{ border:1px solid #cfd9e0; background:#fff; color:#43555f; border-radius:6px;
                               padding:4px 9px; font-size:13px; font-weight:700; cursor:pointer; }
  #qpsSafeRpt .sr-zoom button:hover{ background:#eef3f6; }
  #qpsSafeRpt .sr-card h4{ margin:0 0 10px; font-size:14px; font-weight:800; color:#1f5a4b; }
  #qpsSafeRpt .sr-card h4 .hint{ font-weight:500; font-size:12px; color:#8a99a3; }
  #qpsSafeRpt .sr-list{ max-height:520px; overflow:auto; }
  #qpsSafeRpt .sr-item{ padding:8px 10px; border:1px solid #eef2f5; border-radius:8px; margin-bottom:6px; cursor:pointer; }
  #qpsSafeRpt .sr-item:hover{ border-color:#8fc3b2; background:#f7fbf9; }
  #qpsSafeRpt .sr-item.on{ border-color:#1f5a4b; background:#f0f7f4; }
  #qpsSafeRpt .sr-item .t{ font-size:13px; font-weight:700; color:#20303a; }
  #qpsSafeRpt .sr-item .d{ font-size:11.5px; color:#8a99a3; margin-top:2px; }
  #qpsSafeRpt .sr-empty{ color:#8a99a3; font-size:12.5px; padding:16px 6px; text-align:center; }

  #qpsSafeRpt .sr-form{ display:grid; grid-template-columns:110px 1fr 110px 1fr; gap:9px 10px; align-items:start; }
  #qpsSafeRpt .sr-form .lb{ font-size:12.5px; font-weight:700; color:#43555f; padding-top:8px; }
  #qpsSafeRpt .sr-form .full{ grid-column:2 / -1; }
  #qpsSafeRpt .sr-form input{ width:100%; }

  /* 체크 묶음 — 항목표에서 그린다 */
  #qpsSafeRpt .grp{ border:1px solid #e6ecef; border-radius:8px; padding:9px 11px; margin-bottom:8px; }
  #qpsSafeRpt .grp .gn{ font-size:12.5px; font-weight:800; color:#43555f; margin-bottom:6px; }
  #qpsSafeRpt .grp label{ display:inline-flex; align-items:center; gap:4px; margin:0 14px 6px 0; font-size:12.5px; }
  #qpsSafeRpt .grp input[type=checkbox], #qpsSafeRpt .grp input[type=radio]{
      -webkit-appearance:auto !important; appearance:auto !important;
      width:15px !important; height:15px !important; margin:0 !important; display:inline-block !important;
      opacity:1 !important; visibility:visible !important; position:static !important; cursor:pointer; }
  #qpsSafeRpt .grp input.etc{ width:130px; padding:2px 6px; font-size:12px; }

  /* 반복행 표 (SUB_COLS, 2026-08-14) — 서식이 열 이름을 정하고 행은 문서가 늘린다 */
  #qpsSafeRpt .rowtbl{ width:100%; border-collapse:collapse; font-size:12.5px; }
  #qpsSafeRpt .rowtbl th, #qpsSafeRpt .rowtbl td{ border:1px solid #e0e7ec; padding:4px 6px; }
  #qpsSafeRpt .rowtbl th{ background:#f5f8fa; font-weight:700; color:#43555f; font-size:12px; }
  #qpsSafeRpt .rowtbl td{ padding:3px 4px; }
  #qpsSafeRpt .rowtbl input{ width:100%; border:0; padding:3px 4px; font-size:12.5px; background:transparent; }
  #qpsSafeRpt .rowtbl input:focus{ outline:1px solid #8fc3b2; border-radius:3px; background:#fff; }
  #qpsSafeRpt .rowtbl td.del{ width:34px; text-align:center; padding:0; }
  #qpsSafeRpt .rowtbl td.del button{ border:0; background:none; color:#b23b3b; cursor:pointer; font-size:13px; padding:4px 6px; }
  /* 반복행 표 여러 벌(2026-08-15) — 벌마다 이름 띠 + 자기 [행 추가] */
  #qpsSafeRpt .rowset{ margin-bottom:12px; }
  #qpsSafeRpt .rowset:last-child{ margin-bottom:0; }
  #qpsSafeRpt .rs-h{ font-size:12.5px; font-weight:800; color:#1f5a4b; background:#f0f7f4;
      border:1px solid #dcebe4; border-bottom:0; border-radius:7px 7px 0 0; padding:5px 10px; }
  #qpsSafeRpt .rs-add{ margin-top:6px; padding:3px 10px; font-size:12px; }

  /* 사진첨부 (PHOTO_YN, 2026-08-14) — 2×2 고정 칸. 칸을 누르면 올리고, 같은 칸에 또 올리면 교체 */
  #qpsSafeRpt .ph-grid{ display:grid; grid-template-columns:1fr 1fr; gap:8px; max-width:560px; }
  #qpsSafeRpt .ph-cell{ position:relative; border:1.5px dashed #cfd8e0; border-radius:8px; background:#fafcfd;
      min-height:150px; display:flex; align-items:center; justify-content:center; cursor:pointer; overflow:hidden; }
  #qpsSafeRpt .ph-cell:hover{ border-color:#8fc3b2; background:#f7fbf9; }
  #qpsSafeRpt .ph-cell.has{ border-style:solid; background:#fff; }
  #qpsSafeRpt .ph-cell img{ max-width:100%; max-height:210px; display:block; }  /* 원본 비율 유지 — 칸에 안 맞춘다 */
  #qpsSafeRpt .ph-cell .empty{ color:#9aa7ae; font-size:12.5px; text-align:center; line-height:1.7; }
  #qpsSafeRpt .ph-cell .no{ position:absolute; left:6px; top:5px; font-size:11px; font-weight:800; color:#8a99a3;
      background:rgba(255,255,255,.85); border-radius:8px; padding:1px 7px; }
  #qpsSafeRpt .ph-cell .rm{ position:absolute; right:5px; top:5px; border:1px solid #e0b4b4; background:#fff;
      color:#b23b3b; border-radius:6px; font-size:11.5px; padding:2px 8px; cursor:pointer; }
  #qpsSafeRpt .ph-note{ font-size:11.5px; color:#a06a2c; background:#fdf6ec; border:1px solid #f0dfc4;
      border-radius:7px; padding:6px 10px; margin-bottom:9px; }
</style>

<div class="sr-head">
  <div class="sr-title"><span class="sr-dot"></span><span id="srTitle">환자안전사고 보고서</span>
    <span class="sr-sub">사고 유형별</span></div>
  <span class="sr-hosp" id="srHosp">🏥 <c:out value="${hospNm}" default="병원 미확인"/></span>
  <div class="sr-spacer"></div>
  <%-- ★유형 — 이 셀렉트가 바뀌면 체크 묶음이 통째로 갈린다(항목표에서 다시 받아 그린다)
       data-init = 사이드바 계열 링크에서 넘어온 유형코드(서버가 내려준다) --%>
  <select id="srGb" style="width:auto;" onchange="srLoad();"
          data-init="<c:out value='${srGbInit}'/>"></select>
  <select id="srYear" style="width:auto;" onchange="srLoad();"></select>
  <button type="button" class="sr-btn" onclick="srSave();">저장</button>
  <button type="button" class="sr-btn ghost" onclick="srPrint();">🖨 인쇄(A4)</button>
  <button type="button" class="sr-btn warn" id="srDelBtn" onclick="srDel();" style="display:none;">삭제</button>
  <%-- 글자 크기 — 이 PC 이 브라우저에만 저장된다(localStorage) --%>
  <span class="sr-zoom">
    <button type="button" onclick="srZoom(-1);" title="글자 작게">가－</button>
    <button type="button" onclick="srZoom(1);"  title="글자 크게">가＋</button>
    <button type="button" onclick="srZoom(0);"  title="처음 크기로">↺</button>
  </span>
  <span class="sr-sub" id="srStat"></span>
  <span style="flex:0 0 60px;"></span>
</div>

<div class="sr-wrap">
  <div class="sr-left">
    <div class="sr-card">
      <h4>보고서 목록 <span class="hint" id="srCnt"></span></h4>
      <div class="sr-list" id="srListBox"><div class="sr-empty">불러오는 중…</div></div>
      <button type="button" class="sr-btn ghost" style="width:100%; margin-top:6px;" onclick="srNew();">＋ 새 보고서</button>
    </div>
  </div>

  <div class="sr-right">
    <%-- ★탭 (2026-08-15) — data-tab 이 카드의 묶음이다. 유형마다 숨는 카드가 있으므로
         **보이는 카드가 하나도 없는 탭은 띠에서 빠진다**(srTabSync 가 매번 다시 센다). --%>
    <div class="sr-tabs" id="srTabs"></div>

    <div class="sr-card" data-tab="base">
      <h4>대상 · 발생 <span class="hint">— [사고에서 가져오기]로 이미 등록한 사고를 골라 채울 수 있습니다</span></h4>
      <input type="hidden" id="f_srpSeq" value="">
      <input type="hidden" id="f_incidSeq" value="">
      <div style="margin-bottom:10px; display:flex; gap:8px; align-items:center; flex-wrap:wrap;">
        <%-- ★사고를 고르면 대상·일시·장소가 채워진다. 같은 사고를 두 번 입력하지 않으려는 장치다. --%>
        <select id="f_incidPick" style="min-width:320px;"><option value="">— 등록된 사고에서 가져오기 —</option></select>
        <button type="button" class="sr-btn ghost" onclick="srUseIncid();">↧ 가져오기</button>
        <span class="sr-sub" id="srIncidMsg"></span>
      </div>
      <%-- ★data-lbl = 라벨 오버라이드 키(FORM.LBL_JSON, 2026-08-14) — 값 '-' 는 그 칸을 화면·인쇄에서 숨긴다.
           교육 보고서(EDURPT)·상담일지 계열이 사고 라벨을 제 이름으로 바꿔 쓴다. 비면 지금 그대로. --%>
      <div class="sr-form">
        <div class="lb" data-lbl="occurDt">발생일 *</div>  <div><input type="date" id="f_occurDt"></div>
        <div class="lb" data-lbl="occurTm">발생시각</div>  <div><input type="text" id="f_occurTm" maxlength="5" placeholder="14:30"></div>
        <div class="lb" data-lbl="rptDt">보고일</div>    <div><input type="date" id="f_rptDt"></div>
        <div class="lb" data-lbl="place">발생장소</div>  <div><input type="text" id="f_place" maxlength="200"></div>
        <div class="lb" id="lbTargetNm" data-lbl="targetNm">성명</div>  <div><input type="text" id="f_targetNm" maxlength="60"></div>
        <div class="lb" id="lbTargetNo" data-lbl="targetNo">등록번호</div> <div><input type="text" id="f_targetNo" maxlength="40"></div>
        <div class="lb" data-lbl="deptNm">부서</div>      <div><input type="text" id="f_deptNm" maxlength="60"></div>
        <div class="lb" data-lbl="positionNm">직위</div>      <div><input type="text" id="f_positionNm" maxlength="60"></div>
        <div class="lb" id="lbAdmit" data-lbl="admitDt">입원일</div> <div><input type="date" id="f_admitDt"></div>
        <div class="lb" id="lbDiag" data-lbl="diagNm">진단명</div>  <div><input type="text" id="f_diagNm" maxlength="200"></div>
      </div>
    </div>

    <%-- ★체크 묶음 — 항목표(def)에서 그린다. 이 화면에 유형별 분기가 없다. --%>
    <div class="sr-card" data-tab="base" id="cardChk">
      <h4>구분 <span class="hint" id="srChkHint">— 유형에 따라 항목이 바뀝니다</span></h4>
      <div id="srChkBox"></div>
    </div>

    <%-- ★반복행 표 — 서식이 열 이름을 정하고 행은 문서가 늘린다.
         단벌 = FORM.SUB_COLS(종전) · 여러 벌 = TBL_QPS_SAFERPT_SUB(2026-08-15, 인사기록카드 9벌 등).
         정의가 없는 유형이 대부분이라 이 카드는 기본으로 숨어 있다. --%>
    <div class="sr-card" data-tab="body" id="cardRow" style="display:none;">
      <h4><span id="srRowNm">품목</span> <span class="hint">— 줄이 모자라면 각 표의 [＋ 행 추가]</span></h4>
      <div id="srRowBox"></div>
    </div>

    <div class="sr-card" data-tab="body" id="cardSix">
      <h4>사건개요 (육하원칙) <span class="hint">— 안 쓰는 서식은 비워 두면 인쇄물에도 안 나옵니다</span></h4>
      <div class="sr-form">
        <div class="lb" data-lbl="wWhen">언제</div>   <div><input type="text" id="f_wWhen" maxlength="300"></div>
        <div class="lb" data-lbl="wWho">누가</div>   <div><input type="text" id="f_wWho" maxlength="300"></div>
        <div class="lb" data-lbl="wWhere">어디서</div> <div><input type="text" id="f_wWhere" maxlength="300"></div>
        <div class="lb" data-lbl="wWhat">무엇을</div> <div><input type="text" id="f_wWhat" maxlength="500"></div>
        <div class="lb" data-lbl="wHow">어떻게</div> <div class="full"><input type="text" id="f_wHow" maxlength="500"></div>
        <div class="lb" data-lbl="wWhy">왜</div>     <div class="full"><input type="text" id="f_wWhy" maxlength="500"></div>
      </div>
    </div>

    <div class="sr-card" data-tab="body">
      <h4>서술</h4>
      <div class="sr-form">
        <div class="lb" data-lbl="summary">사건경위</div>   <div class="full"><textarea id="f_summary" rows="3"></textarea></div>
        <div class="lb" data-lbl="vitalTxt">활력징후</div>   <div class="full"><textarea id="f_vitalTxt" rows="2"></textarea></div>
        <div class="lb" data-lbl="injuryTxt">신체손상정도<br>· 결과</div> <div class="full"><textarea id="f_injuryTxt" rows="2"></textarea></div>
        <div class="lb" data-lbl="treatTxt">치료내용<br>· 진료내역</div> <div class="full"><textarea id="f_treatTxt" rows="3"></textarea></div>
        <div class="lb" data-lbl="causeTxt">문제원인<br>· 발생원인</div> <div class="full"><textarea id="f_causeTxt" rows="3"></textarea></div>
        <div class="lb" data-lbl="planTxt">개선방안<br>· 처리결과</div> <div class="full"><textarea id="f_planTxt" rows="3"></textarea></div>
        <div class="lb" data-lbl="note">비고</div>       <div class="full"><textarea id="f_note" rows="2"></textarea></div>
      </div>
    </div>

    <%-- ★사진첨부 — 서식(TBL_QPS_SAFERPT_FORM.PHOTO_YN='Y')이 켠 유형에서만 보인다.
         칸(1~4)이 인쇄물 2×2 의 고정 자리다. 상담일지 계열·직원 교육 결과 보고서가 쓴다(설계 §①). --%>
    <div class="sr-card" data-tab="file" id="cardPhoto" style="display:none;">
      <h4>사진첨부 <span class="hint">— 칸을 누르면 사진을 올립니다 · 인쇄물에 2×2로 실립니다</span></h4>
      <div class="ph-note">⚠ 환자·직원의 얼굴 등 개인정보가 식별되는 사진은 동의 없이 올리지 마세요.</div>
      <div class="ph-grid" id="srPhotoGrid"></div>
      <input type="file" id="srPhotoInp" accept="image/*" style="display:none;">
    </div>

    <div class="sr-card" data-tab="file">
      <h4>사진 · 첨부파일</h4>
      <div id="srFileBox"></div>
    </div>
  </div>
</div>

<script>
(function(){
  // FORM = 유형별 설정(반복행 표·서명란·정형문구). 설정이 없는 유형이 대부분이라 {} 가 정상이다.
  // SUBS = 반복행 표 여러 벌 정의(2026-08-15). 빈 배열이면 FORM 단벌 규칙 그대로.
  var HOSP_NM = '', APPR_LINE = [], DEF = [], GBS = [], curSeq = 0, FORM = {}, SUBS = [];

  var fileBox = window.qpsFileBox({ mount:'srFileBox', refGb:'SAFERPT',
      hint:'사고 관련 사진·자료', needSaveMsg:'보고서를 먼저 저장하면 첨부할 수 있습니다.' });

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
  function gb(){ return gel('srGb').value || 'PTSAFE'; }
  function gbNm(){ for (var i=0;i<GBS.length;i++) if (GBS[i].subcode === gb()) return GBS[i].subcodenm; return '사고 보고서'; }

  (function(){
    var y = new Date().getFullYear(), sel = gel('srYear');
    for (var i = y + 1; i >= y - 4; i--) sel.add(new Option(i + '년', i));
    sel.value = y;
  })();

  /* ── 라벨 오버라이드 (FORM.LBL_JSON, 2026-08-14) ──────────────────────────
       본문 26칸의 <이름>만 서식이 바꾼다 — 교육 보고서·상담일지 계열은 칸은 맞는데 이름이 사고 서식이다.
       키 = data-lbl. 값 '-' = 그 칸을 화면·인쇄에서 숨긴다. 비면 기본 라벨 그대로(기존 유형 무영향). */
  var DEF_LBL = null;
  function lblMap(){ try { return (FORM && FORM.lbljson) ? (JSON.parse(FORM.lbljson) || {}) : {}; } catch(e){ return {}; } }
  function L(key, dv){ var v = lblMap()[key]; return (v && v !== '-') ? v : dv; }
  function lblHidden(key){ return lblMap()[key] === '-'; }

  /** 라벨 일괄 적용 — 직원 대상 서식 보정(환자 등록번호를 직원에게 물으면 안 된다) + LBL_JSON 오버라이드 */
  function applyLabels(){
    var staff = (gb() === 'STAFF' || gb() === 'INFEXP' || gb() === 'HAZMAT' || gb() === 'HARASS' || gb() === 'SECU');
    /* 첫 호출 때 원본 라벨을 담아 둔다 — 유형을 오가면 기본으로 되돌아와야 한다 */
    if (!DEF_LBL){ DEF_LBL = {}; document.querySelectorAll('#qpsSafeRpt .lb[data-lbl]').forEach(function(e){
      DEF_LBL[e.getAttribute('data-lbl')] = e.innerHTML; }); }
    var m = lblMap();
    document.querySelectorAll('#qpsSafeRpt .lb[data-lbl]').forEach(function(e){
      var k = e.getAttribute('data-lbl'), v = m[k];
      e.innerHTML = (v && v !== '-') ? esc(v) : DEF_LBL[k];
      var hide = (v === '-'), sib = e.nextElementSibling;   // 라벨 뒤 값 칸도 같이 숨긴다
      e.style.display = hide ? 'none' : '';
      if (sib) sib.style.display = hide ? 'none' : '';
    });
    if (staff){   // LBL_JSON 이 그 칸을 정하지 않았을 때만 — 서식이 정한 이름이 우선이다
      if (!m.targetNm) gel('lbTargetNm').textContent = '직원 성명';
      if (!m.targetNo) gel('lbTargetNo').textContent = '사번';
    }
    gel('lbAdmit').style.opacity = staff ? '.4' : '1';
    gel('lbDiag').style.opacity  = staff ? '.4' : '1';
    /* 사건개요 — 여섯 칸을 전부 숨긴 서식(교육 등)은 카드째 걷는다 */
    var six = ['wWhen','wWho','wWhere','wWhat','wHow','wWhy'];
    gel('cardSix').style.display = six.every(function(k){ return m[k] === '-'; }) ? 'none' : '';
    gel('srTitle').textContent = gbNm();
    srTabSync();          // 카드가 숨거나 나타나면 탭 띠도 다시 센다
  }

  /* ═══ 탭 · 글자 크기 (2026-08-15 — 사용자 요청) ═══════════════════════════
     ★탭 = 카드의 `data-tab` 묶음. **유형마다 숨는 카드가 있으므로** 띠는 그때그때 다시 그린다
       (보이는 카드가 없는 묶음은 띠에서 뺀다 — 눌러도 빈 화면이 되는 탭을 만들지 않는다).
     ★「전체」를 남겨 둔다 — 쭉 훑어 읽던 사람의 방식을 뺏지 않는다.
     ⚠카드를 숨기는 주체가 둘이다(유형별 `display:none` · 탭) — 섞이면 「분명 있는데 안 보인다」가 된다.
       ⇒ ***탭은 `data-off` 로만 숨긴다.*** 유형이 숨긴 카드는 탭이 켜도 그대로 숨어 있다. */
  var SR_TABS = [{ k:'base', nm:'기본' }, { k:'body', nm:'본문' },
                 { k:'file', nm:'사진 · 첨부' }, { k:'all', nm:'전체' }];
  var SR_TAB_KEY = 'qpsSrTab', srTab = 'base';
  function srCards(){ return [].slice.call(document.querySelectorAll('#qpsSafeRpt .sr-right .sr-card')); }
  /** ★내용이 **한 화면에 들어가면 탭을 내지 않는다**(2026-08-15 지적).
      전부 펼친 높이를 재고 원래대로 돌려놓는다 — 그림이 그려지기 전이라 깜빡이지 않는다. */
  function srFits(cards){
    var live = cards.filter(function(c){ return !srHiddenByType(c); });
    if (live.length < 2) return true;
    var prev = live.map(function(c){ return c.style.display; });
    live.forEach(function(c){ c.style.display = ''; });
    var h = 0;
    live.forEach(function(c){ h += c.offsetHeight + 12; });
    live.forEach(function(c, i){ c.style.display = prev[i]; });
    return h <= (window.innerHeight - 170);
  }
  function srTabSync(){
    var cards = srCards(), box = gel('srTabs');
    if (!box) return;
    if (srFits(cards)) {                    // 한 화면에 들어간다 — 탭 없이 그대로
      box.style.display = 'none';
      cards.forEach(function(c){
        if (c.getAttribute('data-off') === 'Y') { c.removeAttribute('data-off'); c.style.display = ''; }
      });
      return;
    }
    box.style.display = '';
    // 묶음별로 「유형이 안 숨긴 카드」가 몇 장인지
    var live = {};
    cards.forEach(function(c){
      var k = c.getAttribute('data-tab') || 'base';
      live[k] = (live[k] || 0) + (srHiddenByType(c) ? 0 : 1);
    });
    var shown = SR_TABS.filter(function(t){ return t.k === 'all' || live[t.k] > 0; });
    if (!shown.some(function(t){ return t.k === srTab; })) srTab = shown.length ? shown[0].k : 'all';
    box.innerHTML = shown.map(function(t){
      return '<button type="button" class="sr-tab' + (t.k === srTab ? ' on' : '') +
             '" onclick="srPickTab(\'' + t.k + '\');">' + t.nm +
             (t.k === 'all' ? '' : '<span class="n">' + (live[t.k] || 0) + '</span>') + '</button>';
    }).join('');
    srApplyTab();
  }
  /** 유형이 숨긴 카드인가 — 탭이 켜도 이건 안 보여야 한다 */
  function srHiddenByType(c){ return c.getAttribute('data-off') !== 'Y' && c.style.display === 'none'; }
  function srApplyTab(){
    srCards().forEach(function(c){
      var k = c.getAttribute('data-tab') || 'base';
      var off = !(srTab === 'all' || srTab === k);
      if (off) {
        if (!srHiddenByType(c)) { c.setAttribute('data-off', 'Y'); c.style.display = 'none'; }
      } else if (c.getAttribute('data-off') === 'Y') {
        c.removeAttribute('data-off'); c.style.display = '';
      }
    });
  }
  window.srPickTab = function(k){
    srTab = k;
    try { localStorage.setItem(SR_TAB_KEY, k); } catch (ignore) {}
    srTabSync();
  };

  /* 글자 크기 — CSS 가 px 라 `zoom` 으로 통째로 키운다(격자 칸도 같이 커진다). */
  var SR_Z_MIN = 0.8, SR_Z_MAX = 1.6, SR_Z_KEY = 'qpsSrZoom';
  function srApplyZoom(z){
    z = Math.min(SR_Z_MAX, Math.max(SR_Z_MIN, z));
    var w = document.querySelector('#qpsSafeRpt .sr-wrap');
    if (w) w.style.zoom = z.toFixed(2);
    return z;
  }
  window.srZoom = function(d){
    var w = document.querySelector('#qpsSafeRpt .sr-wrap');
    var cur = parseFloat(w && w.style.zoom) || 1;
    if (d === 0) { srApplyZoom(1); try { localStorage.removeItem(SR_Z_KEY); } catch (ignore) {}
                   setTimeout(srTabSync, 0); return; }
    var z = srApplyZoom(cur + d * 0.1);
    try { localStorage.setItem(SR_Z_KEY, String(z)); } catch (ignore) {}
    setTimeout(srTabSync, 0);              // 글자가 커지면 넘치는지 다시 잰다
  };

  /** ★체크 묶음을 항목표에서 그린다. 유형별 하드코딩이 없다. */
  function renderChk(sel){
    sel = sel || {};   // { grpcd: { items:[], etc:{item:txt} } }
    var box = gel('srChkBox');
    if (!DEF.length) {
      box.innerHTML = '<div class="sr-empty">이 서식에는 체크 항목이 없습니다.<br>' +
                      '<span style="font-size:11.5px;">항목을 늘리려면 기준정보의 사고 보고서 항목표에 행을 넣으면 됩니다.</span></div>';
      gel('cardChk').style.display = '';
      return;
    }
    var groups = [], byGrp = {};
    DEF.forEach(function(d){
      if (!byGrp[d.grpcd]) { byGrp[d.grpcd] = { cd:d.grpcd, nm:d.grpnm, multi:(d.multiyn === 'Y'), items:[] }; groups.push(byGrp[d.grpcd]); }
      byGrp[d.grpcd].items.push(d);
    });
    box.innerHTML = groups.map(function(g){
      var picked = (sel[g.cd] && sel[g.cd].items) || [];
      var etcs   = (sel[g.cd] && sel[g.cd].etc) || {};
      var h = '<div class="grp"><div class="gn">' + esc(g.nm) +
              (g.multi ? '' : ' <span style="font-weight:500;color:#8a99a3;">(하나만)</span>') + '</div>';
      g.items.forEach(function(it){
        var on = picked.indexOf(it.itemnm) >= 0;
        h += '<label><input type="' + (g.multi ? 'checkbox' : 'radio') + '"' +
             (g.multi ? '' : ' name="rd_' + esc(g.cd) + '"') +
             ' data-grp="' + esc(g.cd) + '" data-item="' + esc(it.itemnm) + '"' + (on ? ' checked' : '') + '>' +
             esc(it.itemnm);
        if (it.etcyn === 'Y') {
          h += ' <input class="etc" type="text" data-etc="' + esc(g.cd) + '|' + esc(it.itemnm) + '" value="' +
               esc(etcs[it.itemnm] || '') + '" placeholder="내용">';
        }
        h += '</label>';
      });
      return h + '</div>';
    }).join('');
    gel('cardChk').style.display = '';
  }

  function collectChk(){
    var out = [];
    document.querySelectorAll('#srChkBox [data-grp]').forEach(function(el){
      if (!el.checked) return;
      var g = el.getAttribute('data-grp'), it = el.getAttribute('data-item');
      var etcEl = document.querySelector('#srChkBox [data-etc="' + g + '|' + it + '"]');
      out.push({ grpcd:g, itemnm:it, etctxt: etcEl ? String(etcEl.value).trim() : '' });
    });
    return out;
  }
  function chkToSel(rows){
    var sel = {};
    (rows || []).forEach(function(r){
      if (!sel[r.grpcd]) sel[r.grpcd] = { items:[], etc:{} };
      sel[r.grpcd].items.push(r.itemnm);
      if (r.etctxt) sel[r.grpcd].etc[r.itemnm] = r.etctxt;
    });
    return sel;
  }

  /* ───── 반복행 표 (2026-08-14 · 2026-08-15 여러 벌) ──────────────────────
     서식이 열 이름을 정하고 행은 문서가 늘린다 — 점검표 엔진과 같은 규칙.
     ★여러 벌(TBL_QPS_SAFERPT_SUB)이 있으면 그것이 FORM 단벌(SUB_COLS)을 이긴다.
       값 자리 = ***ROW_NO = 벌번호×1000 + 행번호***(1001·2001…). 단벌은 종전대로 1~999 —
       LIST 의 블록 규칙(블록×1000)과 같은 발상이라 옛 문서·옛 유형이 하나도 안 바뀐다. */
  var MIN_ROWS = 3;
  function subCols(){
    var s = (FORM && FORM.subcols) ? String(FORM.subcols) : '';
    if (!s.trim()) return [];
    return s.split(',').map(function(x){ return x.trim(); }).filter(function(x){ return x; });
  }
  /** 벌 정의 [{no,nm,cols[]}] — no=0 은 단벌(옛 규칙, 값 1~999) */
  function subDefs(){
    if (SUBS && SUBS.length) {
      return SUBS.map(function(s){
        var cols = String(s.subcols || '').split(',').map(function(x){ return x.trim(); }).filter(function(x){ return x; });
        return { no: Number(s.subno) || 0, nm: s.subnm || '', cols: cols };
      }).filter(function(s){ return s.no >= 1 && s.no <= 9 && s.cols.length; });
    }
    var c = subCols();
    return c.length ? [{ no: 0, nm: (FORM && FORM.subnm) ? FORM.subnm : '', cols: c }] : [];
  }
  /* ★★[2026-08-15] 옛 단벌 문서 구제 — ***안 그리면 조용히 지워진다.***
     유형에 벌(SUBS)이 **뒤늦게** 생기면, 그 전에 저장된 문서의 행은 벌 번호가 없어(ROW_NO 1~999)
     `byset[0]` 에 담긴다. 그런데 defs 는 1~9 뿐이라 **화면에 안 나오고**, 그 상태로 저장하면
     collectRows 가 그 값을 안 담아 ***삭제 후 재삽입에서 사라진다***(실데이터 유실).
     ⇒ 벌 0 에 값이 있으면 **맨 앞에 한 벌 더** 붙인다. 화면에 그려지면 collectRows 가
       `data-sub="0"` 으로 다시 담으므로 저장해도 남고, 인쇄에도 나온다.
       열 이름은 옛 단벌 정의(FORM.SUB_COLS)를 쓰고, 없으면 첫 벌의 열을 빌린다
       (칸 수만 맞으면 값은 제자리에 들어간다).
     ⚠**화면과 인쇄가 같은 판단을 해야 한다** — 그래서 함수 하나로 둔다.
       (인쇄는 `splitRowVals(collectRows())` 로 화면 값을 다시 가르므로, 여기를 안 거치면
        화면엔 보이는데 종이에서만 빠진다.)
     ※지금은 QPS 가 병원에 안 열려 있어 실데이터가 없다 — **정식 오픈 뒤를 위한 안전장치**다. */
  function withLegacySet(defs, byset){
    if (!defs.length || defs[0].no === 0) return defs;               // 단벌 유형은 그대로
    if (!byset[0] || !Object.keys(byset[0]).length) return defs;     // 옛 값이 없으면 그대로
    var oldCols = subCols();
    return [{ no: 0, nm: '이전 자료 (벌 구분 전에 적은 내용)',
              cols: oldCols.length ? oldCols : defs[0].cols }].concat(defs);
  }
  /** 값을 벌별로 가른다 — 1000대의 몫이 벌, 나머지가 행(0~999 는 단벌) */
  function splitRowVals(vals){
    var byset = {};
    (vals || []).forEach(function(v){
      var rn = Number(v.rowno) || 0, s = Math.floor(rn / 1000), r = s ? (rn % 1000) : rn;
      if (!byset[s]) byset[s] = {};
      if (!byset[s][r]) byset[s][r] = {};
      byset[s][r][Number(v.colno)] = v.val == null ? '' : v.val;
    });
    return byset;
  }
  /** @param vals 서버가 준 [{rowno,colno,val}] — 없으면 빈 표를 그린다. */
  function renderRows(vals){
    var defs = subDefs();
    if (!defs.length) { gel('cardRow').style.display = 'none'; gel('srRowBox').innerHTML = ''; srTabSync(); return; }
    gel('srRowNm').textContent = (defs.length === 1 && defs[0].nm) ? defs[0].nm : '세부 내역';
    var byset = splitRowVals(vals);
    defs = withLegacySet(defs, byset);
    var h = '';
    defs.forEach(function(d){
      var grid = byset[d.no] || {}, maxRow = 0;
      Object.keys(grid).forEach(function(r){ r = Number(r); if (r > maxRow) maxRow = r; });
      var n = Math.max(maxRow, MIN_ROWS);
      h += '<div class="rowset" data-sub="' + d.no + '">' +
           (defs.length > 1 ? '<div class="rs-h">' + esc(d.nm || ('표 ' + d.no)) + '</div>' : '') +
           '<table class="rowtbl"><thead><tr>' +
           d.cols.map(function(c){ return '<th>' + esc(c) + '</th>'; }).join('') +
           '<th class="del"></th></tr></thead><tbody>';
      for (var r = 1; r <= n; r++) h += rowHtml(d.cols.length, grid[r] || {});
      h += '</tbody></table>' +
           '<button type="button" class="sr-btn ghost rs-add" onclick="srRowAdd(this);">＋ 행 추가</button></div>';
    });
    gel('srRowBox').innerHTML = h;
    gel('cardRow').style.display = '';
    srTabSync();
  }
  function rowHtml(nCol, v){
    var h = '<tr>';
    for (var c = 1; c <= nCol; c++) h += '<td><input type="text" maxlength="500" value="' + esc(v[c] || '') + '"></td>';
    return h + '<td class="del"><button type="button" onclick="srRowDel(this);" title="이 행 지우기">✕</button></td></tr>';
  }
  window.srRowAdd = function(btn){
    var box = (btn && btn.closest) ? btn.closest('.rowset') : null;   // 자기 벌의 표에만 행을 더한다
    var tb = box ? box.querySelector('tbody') : document.querySelector('#srRowBox tbody');
    if (!tb) return;
    /* ⚠**한 벌은 999행까지다** — 행 번호가 `벌×1000+행` 이라 1000행째가 되면
       ***다음 벌의 자리로 넘어간다***(1벌 1000행 = 2벌 0행). 종이 서식에 999행이 필요한 일은
       없지만, 막아 두지 않으면 눌린 만큼 조용히 옆 벌을 덮어쓴다. */
    if (tb.rows.length >= 999) { _alertBox('한 표에 999행까지 넣을 수 있습니다.', {icon:'⚠️'}); return; }
    var nCol = tb.parentNode.querySelectorAll('thead th').length - 1;  // 마지막 칸은 ✕ 열
    tb.insertAdjacentHTML('beforeend', rowHtml(nCol, {}));
  };
  window.srRowDel = function(btn){
    var tr = btn.closest('tr'), tb = tr.parentNode;
    if (tb.rows.length <= 1) {   // 마지막 한 줄은 지우지 않고 비운다 — 표가 통째로 사라지면 다시 못 넣는다
      tr.querySelectorAll('input').forEach(function(i){ i.value = ''; });
      return;
    }
    tr.remove();
  };
  /** 빈 행은 버린다 — 안 그러면 눈에 안 보이는 빈 줄이 그대로 저장된다. 번호는 벌별로 다시 매긴다. */
  function collectRows(){
    var out = [];
    document.querySelectorAll('#srRowBox .rowset').forEach(function(box){
      var sub = Number(box.getAttribute('data-sub')) || 0, n = 0;
      box.querySelectorAll('tbody tr').forEach(function(tr){
        var cells = [].map.call(tr.querySelectorAll('input'), function(i){ return String(i.value).trim(); });
        if (!cells.some(function(x){ return x; })) return;
        n++;
        var rn = sub ? (sub * 1000 + n) : n;
        cells.forEach(function(v, i){ if (v) out.push({ rowno:rn, colno:i + 1, val:v }); });
      });
    });
    return out;
  }

  /* ───── 사진첨부 (2026-08-14 · 설계 §①) ─────────────────────────────────
     서식(PHOTO_YN='Y')이 켠 유형에서만 카드가 보인다. 칸(1~4) = 인쇄물 2×2 의 고정 자리.
     ★표시는 fetch→blob→objectURL 로 한다 — /sftp/download.do 가 attachment 강제라
       <img src> 로 바로 걸면 안 보인다(월보고서 PDF 미리보기와 같은 사정·같은 해법). */
  var PHOTOS = {}, _phSlot = 0;
  function photoOn(){ return FORM && FORM.photoyn === 'Y'; }
  function renderPhotos(){
    var card = gel('cardPhoto');
    if (!photoOn()) { card.style.display = 'none'; gel('srPhotoGrid').innerHTML = ''; srTabSync(); return; }
    card.style.display = '';
    srTabSync();
    var h = '';
    for (var i = 1; i <= 4; i++) {
      var ph = PHOTOS[i];
      h += '<div class="ph-cell' + (ph ? ' has' : '') + '" onclick="srPhotoPick(' + i + ');" title="' +
           (ph ? '누르면 이 칸의 사진을 바꿉니다' : '누르면 사진을 올립니다') + '">' +
           '<span class="no">' + i + '</span>' +
           (ph
             ? (ph.url ? '<img src="' + ph.url + '" alt="">' : '<span class="empty">불러오는 중…</span>') +
               '<button type="button" class="rm" onclick="srPhotoDel(event,' + i + ');">✕ 지우기</button>'
             : '<span class="empty">＋ 사진 올리기</span>') +
           '</div>';
    }
    gel('srPhotoGrid').innerHTML = h;
  }
  /** 서버 목록([{fileseq,filepath,orgnm}]) → 상태 반영 + 표시용 blob 로드 */
  function setPhotos(files){
    Object.keys(PHOTOS).forEach(function(k){ try { URL.revokeObjectURL(PHOTOS[k].url); } catch(e){} });
    PHOTOS = {};
    (files || []).forEach(function(f){
      var s = Number(f.fileseq);
      if (s >= 1 && s <= 4) PHOTOS[s] = { filepath:f.filepath, orgnm:f.orgnm, url:'' };
    });
    renderPhotos();
    if (!photoOn()) return;
    Object.keys(PHOTOS).forEach(function(s){ loadPhotoUrl(Number(s)); });
  }
  function loadPhotoUrl(slot){
    var ph = PHOTOS[slot];
    if (!ph || !ph.filepath) return;
    fetch('/sftp/download.do?filePath=' + encodeURIComponent(ph.filepath))
      .then(function(r){ if (!r.ok) throw new Error(); return r.blob(); })
      .then(function(b){ if (PHOTOS[slot] !== ph) return; ph.url = URL.createObjectURL(b); renderPhotos(); })
      .catch(function(){ /* 못 불러와도 칸은 남긴다 — 다시 열면 재시도된다 */ });
  }
  window.srPhotoPick = function(slot){
    if (!curSeq) { _alertBox('보고서를 먼저 저장한 뒤 사진을 붙일 수 있습니다.', {icon:'⚠️'}); return; }
    _phSlot = slot;
    gel('srPhotoInp').click();
  };
  gel('srPhotoInp').onchange = function(){
    var f = this.files && this.files[0];
    this.value = '';
    if (!f || !_phSlot || !curSeq) return;
    var fd = new FormData();
    fd.append('srpSeq', curSeq); fd.append('fileSeq', _phSlot); fd.append('file', f);
    $.ajax({ url:'<c:url value="/qps/safeRptPhotoUpload.do"/>', type:'POST', data:fd,
             processData:false, contentType:false, dataType:'json' })
      .then(function(res){
        if (res && res.result === 'FAIL') { _alertBox(res.message || '업로드에 실패했습니다.', {icon:'❌'}); return; }
        PHOTOS[Number(res.fileseq)] = { filepath:res.filepath, orgnm:res.orgnm, url:'' };
        renderPhotos();
        loadPhotoUrl(Number(res.fileseq));
        _toast('사진을 올렸습니다.', 'ok');
      })
      .fail(function(){ _alertBox('업로드 중 오류가 발생했습니다.', {icon:'❌'}); });
  };
  window.srPhotoDel = function(ev, slot){
    if (ev) { ev.preventDefault(); ev.stopPropagation(); }   // 칸 클릭(업로드)으로 번지지 않게
    _confirmBox({ msg:'이 칸의 사진을 지울까요?', icon:'⚠️', okText:'지우기', okColor:'#b23b3b',
      onOk: function(){
        post('<c:url value="/qps/safeRptPhotoDelete.do"/>', { srpSeq:curSeq, fileSeq:slot }).then(function(){
          if (PHOTOS[slot]) { try { URL.revokeObjectURL(PHOTOS[slot].url); } catch(e){} delete PHOTOS[slot]; }
          renderPhotos();
          _toast('지웠습니다.', 'ok');
        }).catch(err);
      } });
  };

  window.srLoad = function(){
    return post('<c:url value="/qps/safeRptBase.do"/>', { inYear: gel('srYear').value, rptGb: gb() }).then(function(res){
      if (res.hosp) { HOSP_NM = res.hosp.hospnm || ''; gel('srHosp').textContent = '🏥 ' + HOSP_NM; }
      APPR_LINE = res.line || [];
      DEF = res.def || [];
      FORM = res.form || {};   // 유형이 바뀌면 반복행 표의 열 구성도 통째로 갈린다
      SUBS = res.subs || [];   // 반복행 표 여러 벌(있으면 FORM 단벌을 이긴다)
      applyLabels();
      renderChk({});
      renderRows([]);
      setPhotos([]);           // 유형이 바뀌면 사진 카드도 서식(PHOTO_YN)에 맞춰 켜고 끈다
      var list = res.list || [], box = gel('srListBox');
      gel('srCnt').textContent = list.length ? ('· ' + list.length + '건') : '';
      box.innerHTML = list.length
        ? list.map(function(r){
            return '<div class="sr-item' + (Number(r.srpseq) === curSeq ? ' on' : '') + '" onclick="srOpen(' + r.srpseq + ');">' +
                   '<div class="t">' + esc(r.targetnm || '(대상 없음)') + '</div>' +
                   '<div class="d">' + esc(r.occurdt || '') + (r.deptnm ? ' · ' + esc(r.deptnm) : '') + '</div></div>';
          }).join('')
        : '<div class="sr-empty">보고서가 없습니다.<br>[＋ 새 보고서]로 만드세요.</div>';
    }).catch(err);
  };

  window.srOpen = function(seq){
    post('<c:url value="/qps/safeRptGet.do"/>', { srpSeq: seq }).then(function(res){
      var d = res.doc || {};
      curSeq = Number(d.srpseq || 0);
      if (d.rptgb && d.rptgb !== gb()) { gel('srGb').value = d.rptgb; applyLabels(); }
      set('f_srpSeq', d.srpseq); set('f_incidSeq', d.incidseq || '');
      set('f_occurDt', d.occurdt); set('f_occurTm', d.occurtm); set('f_rptDt', d.rptdt);
      set('f_place', d.place); set('f_targetNm', d.targetnm); set('f_targetNo', d.targetno);
      set('f_deptNm', d.deptnm); set('f_positionNm', d.positionnm);
      set('f_admitDt', d.admitdt); set('f_diagNm', d.diagnm);
      set('f_wWhen', d.wwhen); set('f_wWho', d.wwho); set('f_wWhere', d.wwhere);
      set('f_wWhat', d.wwhat); set('f_wHow', d.whow); set('f_wWhy', d.wwhy);
      set('f_summary', d.summary); set('f_vitalTxt', d.vitaltxt); set('f_injuryTxt', d.injurytxt);
      set('f_treatTxt', d.treattxt); set('f_causeTxt', d.causetxt); set('f_planTxt', d.plantxt);
      set('f_note', d.note);
      gel('srIncidMsg').textContent = d.incidseq ? ('사고 #' + d.incidseq + ' 와 연결됨') : '';
      renderChk(chkToSel(res.chks));
      renderRows(res.rows);
      setPhotos(res.files);
      gel('srStat').textContent = '— 저장된 보고서 #' + d.srpseq;
      gel('srDelBtn').style.display = '';
      if (fileBox) fileBox.setKey(d.srpseq);
      srListRefresh();
    }).catch(err);
  };
  function srListRefresh(){
    document.querySelectorAll('#srListBox .sr-item').forEach(function(el){ el.classList.remove('on'); });
    var m = document.querySelector('#srListBox .sr-item[onclick*="(' + curSeq + ')"]');
    if (m) m.classList.add('on');
  }

  window.srNew = function(){
    curSeq = 0;
    ['f_srpSeq','f_incidSeq','f_occurDt','f_occurTm','f_rptDt','f_place','f_targetNm','f_targetNo',
     'f_deptNm','f_positionNm','f_admitDt','f_diagNm','f_wWhen','f_wWho','f_wWhere','f_wWhat',
     'f_wHow','f_wWhy','f_summary','f_vitalTxt','f_injuryTxt','f_treatTxt','f_causeTxt',
     'f_planTxt','f_note'].forEach(function(id){ set(id, ''); });
    gel('srIncidMsg').textContent = '';
    renderChk({});
    renderRows([]);
    setPhotos([]);
    gel('srStat').textContent = '— 새 보고서';
    gel('srDelBtn').style.display = 'none';
    if (fileBox) fileBox.setKey('');
    srListRefresh();
  };

  /* ★사고 목록 — 이미 등록한 사고를 골라 대상·일시·장소를 채운다.
     같은 사고를 두 번 입력하게 만들지 않으려는 것이 이 서식의 핵심 설계다.
     사고가 없어도 화면은 그대로 쓴다(직접 입력). */
  var INCID = [];
  function loadIncid(){
    post('<c:url value="/qps/incidentList.do"/>', { inYear: gel('srYear').value }).then(function(res){
      INCID = res.list || [];
      var sel = gel('f_incidPick');
      sel.innerHTML = '<option value="">— 등록된 사고에서 가져오기 —</option>';
      INCID.forEach(function(r){
        var t = (r.patnm || '(이름 없음)') + ' · ' + (r.occurdt || '') + (r.place ? ' · ' + r.place : '');
        sel.add(new Option(t, r.incidseq));
      });
      if (!INCID.length) sel.options[0].text = '— 등록된 사고가 없습니다 (직접 입력) —';
    }).catch(function(){ INCID = []; });
  }
  window.srUseIncid = function(){
    var seq = val('f_incidPick');
    if (!seq) { _alertBox('가져올 사고를 먼저 고르세요.', {icon:'⚠️'}); return; }
    var r = null;
    for (var i = 0; i < INCID.length; i++) if (String(INCID[i].incidseq) === seq) { r = INCID[i]; break; }
    if (!r) return;
    set('f_incidSeq', seq);
    var dt = String(r.occurdt || '').replace(/-/g, '');
    if (dt.length === 8) set('f_occurDt', dt.substr(0,4) + '-' + dt.substr(4,2) + '-' + dt.substr(6,2));
    if (r.patnm) set('f_targetNm', r.patnm);
    if (r.place) set('f_place', r.place);
    gel('srIncidMsg').textContent = '사고 #' + seq + ' 에서 가져왔습니다.';
  };

  window.srSave = function(){
    if (!val('f_occurDt')) { _alertBox('발생일을 입력해 주세요.', {icon:'⚠️'}); return; }
    post('<c:url value="/qps/safeRptSave.do"/>', {
      srpSeq: val('f_srpSeq'), inYear: gel('srYear').value, rptGb: gb(),
      incidSeq: val('f_incidSeq'),
      occurDt: val('f_occurDt'), occurTm: val('f_occurTm'), rptDt: val('f_rptDt'), place: val('f_place'),
      targetNm: val('f_targetNm'), targetNo: val('f_targetNo'), deptNm: val('f_deptNm'),
      positionNm: val('f_positionNm'), admitDt: val('f_admitDt'), diagNm: val('f_diagNm'),
      wWhen: val('f_wWhen'), wWho: val('f_wWho'), wWhere: val('f_wWhere'),
      wWhat: val('f_wWhat'), wHow: val('f_wHow'), wWhy: val('f_wWhy'),
      summary: val('f_summary'), vitalTxt: val('f_vitalTxt'), injuryTxt: val('f_injuryTxt'),
      treatTxt: val('f_treatTxt'), causeTxt: val('f_causeTxt'), planTxt: val('f_planTxt'), note: val('f_note'),
      chks: JSON.stringify(collectChk()),
      rows: JSON.stringify(collectRows())
    }).then(function(res){
      _toast('저장되었습니다.', 'ok');
      return srLoad().then(function(){ srOpen(res.srpSeq); });
    }).catch(err);
  };

  window.srDel = function(){
    if (!curSeq) return;
    _confirmBox({ msg:'이 보고서를 삭제할까요?', icon:'⚠️', okText:'삭제', okColor:'#b23b3b',
      onOk: function(){
        post('<c:url value="/qps/safeRptDelete.do"/>', { srpSeq: curSeq }).then(function(){
          _toast('삭제되었습니다.', 'ok'); srNew(); srLoad();
        }).catch(err);
      } });
  };

  // ---------- 인쇄 ----------
  var PRINT_CSS =
    '@page{ size:A4 portrait; margin:12mm; }' +
    'body{ margin:0; font-family:"맑은 고딕",Malgun Gothic,sans-serif; color:#000; }' +
    '.h1{ font-size:17px; font-weight:800; text-align:center; margin:0 0 8px; letter-spacing:1px; }' +
    'table{ width:100%; border-collapse:collapse; font-size:10px; margin-bottom:5px; }' +
    'th,td{ border:1px solid #666; padding:4px 5px; text-align:center; vertical-align:middle; line-height:1.55; }' +
    'th{ background:#efefef; font-weight:700; }' +
    'td.l{ text-align:left; } td.pre{ text-align:left; white-space:pre-wrap; }' +
    '.appr{ float:right; width:auto; margin:0 0 4px 8px; font-size:9.5px; }' +
    '.appr th{ padding:2px 6px; } .appr td{ height:42px; width:58px; }' +
    'tr{ page-break-inside:avoid; }' +
    /* 하단 서명란·정형문구 — qpsChk.jsp 와 같은 모양으로 맞춘다(두 엔진이 달라 보이면 안 된다) */
    '.foot{ font-size:9.5px; margin:6px 0 2px; text-align:left; }' +
    '.sig{ margin-top:10px; text-align:right; font-size:10.5px; }' +
    '.sig span{ margin-left:22px; white-space:nowrap; }' +
    /* 사진첨부 2×2 — 원본 비율 유지·칸 안 맞춤(원본 서식이 그렇다). 칸 하나가 A4 반 폭이라 78mm 상한 */
    '.ph td{ width:50%; height:60mm; text-align:center; vertical-align:middle; }' +
    '.ph img{ max-width:100%; max-height:58mm; }';

  function apprHtml(){
    if (!APPR_LINE.length) return '';
    var h = '<table class="appr"><thead><tr>';
    APPR_LINE.forEach(function(r){ h += '<th>' + esc(r.stepnm) + '</th>'; });
    h += '</tr></thead><tbody><tr>';
    APPR_LINE.forEach(function(){ h += '<td></td>'; });
    return h + '</tr></tbody></table>';
  }

  /** 인쇄용 반복행 표 — 벌마다 한 표씩, 화면과 달리 **빈 행·빈 벌은 빼고** 찍는다.
      벌 이름은 왼쪽 이름 칸을 rowspan 으로 세운다(qpsChk.jsp 의 자유행 표와 같은 모양). */
  function rowTblHtml(){
    var defs = subDefs();
    if (!defs.length) return '';
    var byset = splitRowVals(collectRows());
    defs = withLegacySet(defs, byset);   // 화면과 같은 판단 — 옛 단벌 값도 종이에 나온다
    var h = '';
    defs.forEach(function(d){
      var grid = byset[d.no] || {}, maxRow = 0;
      Object.keys(grid).forEach(function(r){ r = Number(r); if (r > maxRow) maxRow = r; });
      if (!maxRow) return;   // 안 쓴 벌은 종이에 안 나온다
      var body = '';
      for (var r = 1; r <= maxRow; r++) {
        body += '<tr>' + (d.nm && r === 1 ? '<th style="width:110px;" rowspan="' + maxRow + '">' + esc(d.nm) + '</th>' : '');
        for (var c = 1; c <= d.cols.length; c++) body += '<td class="l">' + esc((grid[r] || {})[c] || '') + '</td>';
        body += '</tr>';
      }
      h += '<table><thead><tr>' + (d.nm ? '<th style="width:110px;"></th>' : '') +
           d.cols.map(function(c){ return '<th>' + esc(c) + '</th>'; }).join('') +
           '</tr></thead><tbody>' + body + '</tbody></table>';
    });
    return h;
  }

  /** 인쇄용 사진 2×2 — 있는 칸만 줄 단위로 찍는다(3·4번이 비면 아랫줄 없음).
      ★blob URL 을 그대로 쓴다 — 인쇄창은 이 창이 연 같은 출처 창이라 접근된다. */
  function photoTblHtml(){
    if (!photoOn()) return '';
    var cell = function(s){ var p = PHOTOS[s]; return '<td>' + (p && p.url ? '<img src="' + p.url + '" alt="">' : '') + '</td>'; };
    var top = PHOTOS[1] || PHOTOS[2], bot = PHOTOS[3] || PHOTOS[4];
    if (!top && !bot) return '';
    var body = '';
    if (top) body += '<tr><th style="width:110px;" rowspan="' + (bot ? 2 : 1) + '">사진첨부</th>' + cell(1) + cell(2) + '</tr>';
    if (bot) body += '<tr>' + (top ? '' : '<th style="width:110px;">사진첨부</th>') + cell(3) + cell(4) + '</tr>';
    return '<table class="ph"><tbody>' + body + '</tbody></table>';
  }

  window.srPrint = function(){
    // 체크는 ☑/☐ 로 낸다 — 종이 서식과 같은 모양
    var sel = {};
    collectChk().forEach(function(c){
      if (!sel[c.grpcd]) sel[c.grpcd] = {};
      sel[c.grpcd][c.itemnm] = c.etctxt || true;
    });
    var byGrp = {}, groups = [];
    DEF.forEach(function(d){
      if (!byGrp[d.grpcd]) { byGrp[d.grpcd] = { cd:d.grpcd, nm:d.grpnm, items:[] }; groups.push(byGrp[d.grpcd]); }
      byGrp[d.grpcd].items.push(d);
    });
    var chkRows = groups.map(function(g){
      var line = g.items.map(function(it){
        var v = sel[g.cd] && sel[g.cd][it.itemnm];
        var etc = (typeof v === 'string' && v) ? ('( ' + esc(v) + ' )') : (it.etcyn === 'Y' ? '(　　)' : '');
        return (v ? '☑ ' : '☐ ') + esc(it.itemnm) + ' ' + etc;
      }).join(' &nbsp; ');
      return '<tr><th style="width:110px;">' + esc(g.nm) + '</th><td class="l">' + line + '</td></tr>';
    }).join('');

    function row(lb, v){ return v ? ('<tr><th style="width:110px;">' + lb + '</th><td class="pre" colspan="3">' + esc(v) + '</td></tr>') : ''; }
    /* 서술 칸 — 라벨 오버라이드를 따르고, 숨긴 칸('-')은 값이 있어도 찍지 않는다 */
    function rowL(key, dv, id){ return lblHidden(key) ? '' : row(esc(L(key, dv)), val(id)); }
    var six = [[L('wWhen','언제'), val('f_wWhen')], [L('wWho','누가'), val('f_wWho')], [L('wWhere','어디서'), val('f_wWhere')],
               [L('wWhat','무엇을'), val('f_wWhat')], [L('wHow','어떻게'), val('f_wHow')], [L('wWhy','왜'), val('f_wWhy')]]
              .filter(function(x){ return x[1]; });

    /* 머리표 — [라벨,값] 짝을 모아 한 줄에 둘씩. 숨긴 칸은 짝 자체를 안 만든다(LBL_JSON '-') */
    var lm = lblMap(), hp = [];
    if (!lblHidden('occurDt'))
      hp.push([L('occurDt','발생일시'), (val('f_occurDt') + ' ' + val('f_occurTm')).trim()]);
    if (!lblHidden('rptDt'))    hp.push([L('rptDt','보고일'), val('f_rptDt')]);
    if (!lblHidden('targetNm')) hp.push([gel('lbTargetNm').textContent, val('f_targetNm')]);
    if (!lblHidden('targetNo')) hp.push([gel('lbTargetNo').textContent, val('f_targetNo')]);
    if (!lm.deptNm && !lm.positionNm)   // 기본 서식은 종전대로 '부서 / 직위' 한 칸
      hp.push(['부서 / 직위', (val('f_deptNm') + ' ' + val('f_positionNm')).trim()]);
    else {
      if (!lblHidden('deptNm'))     hp.push([L('deptNm','부서'), val('f_deptNm')]);
      if (!lblHidden('positionNm')) hp.push([L('positionNm','직위'), val('f_positionNm')]);
    }
    if (!lblHidden('place')) hp.push([L('place','발생장소'), val('f_place')]);
    if (!lblHidden('admitDt') && val('f_admitDt')) hp.push([L('admitDt','입원일'), val('f_admitDt')]);
    if (!lblHidden('diagNm') && val('f_diagNm'))   hp.push([L('diagNm','진단명'), val('f_diagNm')]);
    var headRows = '';
    for (var hi = 0; hi < hp.length; hi += 2) {
      var ha = hp[hi], hb = hp[hi + 1];
      headRows += '<tr><th style="width:110px;">' + esc(ha[0]) + '</th>' +
                  (hb ? '<td class="l" style="width:32%;">' + esc(ha[1]) + '</td>' +
                        '<th style="width:90px;">' + esc(hb[0]) + '</th><td class="l">' + esc(hb[1]) + '</td>'
                      : '<td class="l" colspan="3">' + esc(ha[1]) + '</td>') + '</tr>';
    }

    var body = apprHtml() +
      '<div class="h1">' + esc(gbNm()) + '</div><div style="clear:both;"></div>' +
      '<table><tbody>' + headRows + '</tbody></table>' +
      (chkRows ? '<table><tbody>' + chkRows + '</tbody></table>' : '') +
      (six.length ? '<table><tbody><tr><th style="width:110px;" rowspan="' + six.length + '">사건개요</th>' +
          six.map(function(x, i){
            return (i === 0 ? '' : '<tr>') + '<th style="width:70px;">' + x[0] + '</th><td class="l" colspan="2">' +
                   esc(x[1]) + '</td>' + (i === 0 ? '</tr>' : '</tr>');
          }).join('') + '</tbody></table>' : '') +
      rowTblHtml() +
      '<table><tbody>' +
        rowL('summary','사건경위','f_summary') + rowL('vitalTxt','활력징후','f_vitalTxt') +
        rowL('injuryTxt','신체손상정도·결과','f_injuryTxt') + rowL('treatTxt','치료내용·진료내역','f_treatTxt') +
        rowL('causeTxt','문제원인·발생원인','f_causeTxt') + rowL('planTxt','개선방안·처리결과','f_planTxt') +
        rowL('note','비고','f_note') +
      '</tbody></table>' +
      photoTblHtml() +
      // 정형문구·서명란은 값이 없다 — 서식이 정한 글자를 그대로 찍는 인쇄 전용 요소다
      (FORM.foottxt ? '<div class="foot">' + esc(FORM.foottxt) + '</div>' : '') +
      (FORM.signline
        ? '<div class="sig">' + String(FORM.signline).split(',').map(function(s){
            return '<span>' + esc(s.trim()) + ' _____________ (인)</span>'; }).join('') + '</div>'
        : '');

    var title = (gbNm() + '_' + val('f_occurDt') + '_' + val('f_targetNm') + '_' + HOSP_NM).replace(/[\\\/:*?"<>|]/g, '-');
    var w = window.open('', '_blank', 'width=900,height=1000');
    if (!w) { _alertBox('팝업이 차단되어 인쇄창을 열지 못했습니다.<br>주소창 오른쪽의 팝업 차단을 허용해 주세요.', {icon:'⚠️'}); return; }
    w.document.open();
    w.document.write('<!doctype html><html lang="ko"><head><meta charset="utf-8"><title>' + esc(title) +
      '</title><style>' + PRINT_CSS + '</style></head><body>' + body + '</body></html>');
    w.document.close();
    w.focus();
    /* 사진(blob)이 다 그려진 뒤 인쇄창을 띄운다 — 300ms 고정 대기로는 사진이 빈 채 찍힐 수 있다.
       6초(40×150ms)를 넘기면 그냥 연다(사진 하나 못 불러왔다고 인쇄를 막지 않는다). */
    var tries = 0;
    (function waitImg(){
      var ok = true, imgs = [];
      try { imgs = w.document.images || []; } catch (e) {}
      for (var i = 0; i < imgs.length; i++) if (!imgs[i].complete) ok = false;
      if (ok || tries++ > 40) { try { w.print(); } catch (e) {} }
      else setTimeout(waitImg, 150);
    })();
  };

  // 유형 목록은 공통코드에서 — 유형이 늘어도 화면을 안 고친다
  $(function(){
    /* 지난번에 쓰던 탭·글자 크기를 되살린다(이 PC 이 브라우저에만 저장) —
       ★탭 띠는 카드가 그려진 뒤 srTabSync 가 다시 세므로 값만 미리 넣어 둔다. */
    try {
      var t = localStorage.getItem(SR_TAB_KEY);
      if (t && SR_TABS.some(function(x){ return x.k === t; })) srTab = t;
      var z = parseFloat(localStorage.getItem(SR_Z_KEY));
      if (z) srApplyZoom(z);
    } catch (ignore) {}
    srTabSync();
    var _srT; window.addEventListener('resize', function(){ clearTimeout(_srT); _srT = setTimeout(srTabSync, 200); });
    post('<c:url value="/qps/codeList.do"/>', {}).then(
      function(res){ GBS = (res && res.codes && res.codes.QPS_SAFERPT_GB) || []; step2(); },
      function(){ GBS = []; step2(); }
    );
    function step2(){
      var sel = gel('srGb');
      if (GBS.length) {
        // ★계열 묶음(optgroup) — SORT 대역이 곧 계열이다(시드 등록 규약 : 1~19 사고 ·
        //   20대 보건 · 31~ 인사/총무 · 51~ 의무기록 · 71~ 영양 · 73~ 사회복지 · 91~ 검진결과).
        //   새 유형은 대역 안 SORT 로 등록하면 화면 수정 없이 제 묶음에 들어온다.
        var BANDS = [
          [ 1,  9, '사고 · 안전 보고서'],
          [10, 19, '의약품 · 혈액'],
          [20, 30, '교육 · 보건관리'],
          [31, 50, '인사 · 원무 · 총무'],
          [51, 70, '의무기록 · 정보보호'],
          [71, 72, '영양'],
          [73, 90, '사회복지 · 프로그램'],
          [91, 99, '검진 · 접종 결과보고서']];
        var html = '', rest = GBS.slice();
        BANDS.forEach(function(b){
          var grp = rest.filter(function(c){ var s = Number(c.sort); return s >= b[0] && s <= b[1]; });
          if (!grp.length) return;
          rest = rest.filter(function(c){ return grp.indexOf(c) < 0; });
          html += '<optgroup label="' + esc(b[2]) + '">' +
                  grp.map(function(c){ return '<option value="' + esc(c.subcode) + '">' + esc(c.subcodenm) + '</option>'; }).join('') +
                  '</optgroup>';
        });
        // sort 를 안 내려주는 옛 서버(재기동 전)면 전부 여기로 온다 — 종전처럼 평평하게
        if (rest.length) {
          html += rest.map(function(c){ return '<option value="' + esc(c.subcode) + '">' + esc(c.subcodenm) + '</option>'; }).join('');
        }
        sel.innerHTML = html;
      } else {
        sel.innerHTML = '<option value="PTSAFE">환자안전사고 보고서</option>';
      }
      // 사이드바 계열 링크로 들어왔으면 그 유형으로 연다
      var init = (sel.getAttribute('data-init') || '').trim();
      if (init && GBS.some(function(c){ return c.subcode === init; })) sel.value = init;
      srNew();
      srLoad();
      loadIncid();
    }
  });
})();
</script>
</div><%-- /#qpsSafeRpt --%>
</div><%-- /.dashboard-wrapper --%>
