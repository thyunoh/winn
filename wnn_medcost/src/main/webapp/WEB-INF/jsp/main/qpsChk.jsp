<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%-- qpsChk.jsp — 점검표 작성 (2026-08-11)

     ★★이 화면에는 서식별 분기가 **하나도 없다.**
       표는 서버가 준 서식정의(AXIS_GB + 항목)가 그린다. 새 점검표가 생겨도 이 파일은 안 고친다.
       — 사고 유형별 보고서(qpsSafeRpt)에서 쓴 것과 같은 원칙을 격자에 적용한 것.

     ★축 6가지 (실물에서 관찰된 것만)
       ITEM_COL   점검항목 행 × **날짜가 아닌 고정 열** (2026-08-12 추가 — 네 부서 23종. 단일 최대)
                  ★열 이름은 서식이 정한다(COL_NMS). Y/N·예/아니오/해당없음·결과/조치사항·분기가
                    전부 이 하나로 덮인다. ***분기 축을 따로 만들 필요가 없다.***
       EQUIP_DAY  기기 N행 × 1~31일    · 항목은 표 위 안내박스, 기기명은 문서마다 다름
       ITEM_DAY   점검항목 행 × 1~31일
       DAY_ITEM   1~31일 행 × 점검항목 열 (열 묶음 = 2단 머리글)
       ITEM_MONTH 점검항목 행 × 1~12월 (연 1장 — 월 셀렉트가 없다)
       LIST       자유행 대장 — 항목이 열, 행은 작성자가 늘린다 (2026-08-12 추가)
                  ★다른 축은 행 수가 서식이 정하지만 대장은 **그 문서가 정한다.**
                    몇 사람이 걸릴지는 그 달에 가 봐야 안다.

     ★셀 저장은 (행,열,값) — 빈 칸은 저장하지 않는다. 31×16 을 다 넣으면 낭비다.
     ★예약 행/열 900 = 점검자 사인.

     ★주의: 이 파일 안에서 Deferred EL 표기(샵+중괄호) 금지 --%>

<script src="/asset/js/ui-message.js"></script>

<div class="dashboard-wrapper">
<div id="qpsChk" data-wnn="<c:out value='${wnnYn}'/>">
<style>
  #qpsChk{ background:#f4f6f8; color:#1f2a30; min-height:100%; padding:14px 16px 60px; max-width:100%; overflow-x:hidden; }
  #qpsChk *{ box-sizing:border-box; }
  #qpsChk .ck-head{ display:flex; align-items:center; gap:10px; margin-bottom:12px; flex-wrap:wrap; }
  #qpsChk .ck-title{ font-size:18px; font-weight:800; color:#20303a; display:flex; align-items:center; gap:8px; }
  #qpsChk .ck-dot{ width:10px; height:10px; border-radius:50%; background:linear-gradient(135deg,#1f5a4b,#2a7665); }
  #qpsChk .ck-sub{ font-size:12px; color:#6b7c86; }
  #qpsChk .ck-hosp{ background:#e7f3ee; color:#1f5a4b; font-size:12px; font-weight:800;
      border:1px solid #cfe3da; border-radius:14px; padding:3px 11px; }
  #qpsChk .ck-spacer{ flex:1; }
  #qpsChk select, #qpsChk input, #qpsChk textarea{
      border:1px solid #cfd8e0; border-radius:5px; padding:5px 7px; font-family:inherit; font-size:12.5px; background:#fff; }
  #qpsChk textarea{ resize:vertical; line-height:1.55; width:100%; }
  #qpsChk .ck-btn{ border:1px solid #1f5a4b; background:#1f5a4b; color:#fff; border-radius:6px;
      padding:6px 14px; font-size:13px; font-weight:600; cursor:pointer; white-space:nowrap; }
  #qpsChk .ck-btn.ghost{ background:#fff; color:#1f5a4b; }
  #qpsChk .ck-btn.warn{ background:#fff; color:#b23b3b; border-color:#e0b4b4; }
  #qpsChk .ck-btn.mini{ padding:2px 9px; font-size:11.5px; border-color:#cfd8e0; color:#556570; background:#fff; }

  #qpsChk .ck-card{ background:#fff; border:1px solid #e3e9ed; border-radius:10px; padding:14px 16px; margin-bottom:12px; }
  #qpsChk .ck-card h4{ margin:0 0 10px; font-size:14px; font-weight:800; color:#1f5a4b; }
  #qpsChk .ck-card h4 .hint{ font-weight:500; font-size:12px; color:#8a99a3; }
  #qpsChk .ck-bar{ display:flex; gap:8px; align-items:center; flex-wrap:wrap; margin-bottom:10px; }
  #qpsChk .ck-guide{ background:#f2f8f5; border:1px solid #cfe3da; border-radius:6px;
      padding:6px 10px; font-size:12px; color:#33564a; margin-bottom:8px; }
  #qpsChk .ck-legend{ border:1px solid #dde5ea; border-radius:6px; padding:7px 10px; margin-bottom:8px;
      font-size:12px; color:#43555f; display:flex; flex-wrap:wrap; gap:4px 18px; }
  #qpsChk .ck-empty{ color:#8a99a3; font-size:12.5px; padding:20px 6px; text-align:center; }

  #qpsChk .gridwrap{ overflow:auto; max-height:62vh; border:1px solid #dfe4ea; border-radius:6px; }
  #qpsChk table.gr{ border-collapse:separate; border-spacing:0; font-size:12px; background:#fff; }
  #qpsChk table.gr th, #qpsChk table.gr td{ border-right:1px solid #e2e8ec; border-bottom:1px solid #e2e8ec;
      padding:0; text-align:center; white-space:nowrap; }
  #qpsChk table.gr th{ background:#f2f6f8; font-weight:700; color:#43555f; padding:4px 5px; position:sticky; top:0; z-index:2; }
  #qpsChk table.gr thead tr:nth-child(2) th{ top:26px; }
  #qpsChk table.gr th.hd, #qpsChk table.gr td.hd{ position:sticky; left:0; z-index:3; background:#f8fafb;
      text-align:left; padding:4px 7px; min-width:170px; max-width:340px; white-space:normal; line-height:1.4; }
  #qpsChk table.gr th.hd{ z-index:4; }
  <%-- 행 묶음 칸(2단 행 머리글). ★묶음이 있으면 항목 칸이 그만큼 오른쪽으로 밀린다 —
       둘 다 왼쪽 고정이라 자리를 안 밀면 겹쳐서 항목 이름이 가려진다. --%>
  #qpsChk table.gr th.rgrp{ position:sticky; left:0; z-index:5; background:#eef3f6; color:#33564a;
      font-weight:800; min-width:92px; max-width:92px; white-space:normal; line-height:1.35;
      padding:4px 6px; vertical-align:middle; }
  #qpsChk table.gr thead th.rgrp{ top:0; z-index:6; }
  #qpsChk table.gr.hasrg th.hd, #qpsChk table.gr.hasrg td.hd{ left:92px; }
  <%-- ★행 블록의 띠 — 표 폭을 가로지르는 머리 행(▶병원 근무자 / ▶약국 …).
       왼쪽 세로 칸(rgrp)과 **같은 자료(GRP_NM·ROW_BLKS)를 다르게 그린 것**이라 색을 맞춰 둔다. --%>
  #qpsChk table.gr tr.blk > td{ background:#e3edf2; color:#28414c; font-weight:800; text-align:left;
      padding:5px 8px; letter-spacing:-0.2px; position:sticky; left:0; }
  <%-- ★격자 옆에 붙는 칸(항목 설명·예산·조치사항). 날짜 칸과 **눈으로 갈려야** 한다 —
       한 줄로 이어지면 「1일」 옆의 예산이 1일 값처럼 읽힌다. --%>
  #qpsChk table.gr th.side{ background:#eef2f4; color:#33474f; }
  #qpsChk table.gr td.sidetxt{ text-align:left; padding:4px 7px; color:#43555f; background:#fafcfd;
      white-space:normal; line-height:1.4; }
  #qpsChk table.gr td input{ width:100%; min-width:30px; border:none; background:transparent;
      text-align:center; padding:4px 2px; font-size:12px; }
  #qpsChk table.gr td input:focus{ background:#eaf5f0; outline:1px solid #8fc3b2; }
  #qpsChk table.gr td.hd input{ text-align:left; }
  <%-- 대장(LIST)의 글자 칸 — 이름·사유가 들어가므로 가운데 정렬이면 읽기 나쁘다 --%>
  #qpsChk table.gr td input.ltxt{ text-align:left; padding-left:6px; }
  #qpsChk table.gr tr.sign td, #qpsChk table.gr tr.sign th{ background:#fbfcfd; }
  #qpsChk .sun{ color:#c0392b; } #qpsChk .sat{ color:#2c6fb5; }

  #qpsChk .ck-form{ display:grid; grid-template-columns:110px 1fr 110px 1fr; gap:9px 10px; align-items:start; }
  #qpsChk .ck-form .lb{ font-size:12.5px; font-weight:700; color:#43555f; padding-top:8px; }
  #qpsChk .ck-form .full{ grid-column:2 / -1; }
  #qpsChk .ck-form input{ width:100%; }
</style>

<div class="ck-head">
  <div class="ck-title"><span class="ck-dot"></span><span id="ckTitle">점검표</span>
    <span class="ck-sub" id="ckAxisNm"></span></div>
  <span class="ck-hosp" id="ckHosp">🏥 <c:out value="${hospNm}" default="병원 미확인"/></span>
  <div class="ck-spacer"></div>
  <button type="button" class="ck-btn" onclick="ckSave();">저장</button>
  <button type="button" class="ck-btn ghost" onclick="ckPrint();">🖨 인쇄(A4 가로)</button>
  <button type="button" class="ck-btn ghost" onclick="ckExtract();">📊 데이터 추출</button>
  <button type="button" class="ck-btn warn" id="ckDelBtn" onclick="ckDel();" style="display:none;">삭제</button>
  <span class="ck-sub" id="ckStat"></span>
  <span style="flex:0 0 60px;"></span>
</div>

<div class="ck-card">
  <div class="ck-bar">
    <%-- ★부서 먼저 — 서식이 130종이 되면 부서로 걸러야 고를 수 있다 --%>
    <span style="font-size:12.5px; font-weight:700; color:#43555f;">부서</span>
    <select id="ckDept" style="width:auto;" onchange="ckPickDept();"><option value="">전체</option></select>
    <span style="font-size:12.5px; font-weight:700; color:#43555f;">서식</span>
    <%-- data-init = [서식 관리]에서 「작성 화면에서 보기」로 넘어온 서식코드(서버가 내려준다) --%>
    <select id="ckForm" style="min-width:300px;" onchange="ckPickForm();"
            data-init="<c:out value='${chkFormId}'/>"></select>
    <span style="font-size:12.5px; font-weight:700; color:#43555f; margin-left:6px;">연도</span>
    <select id="ckYear" style="width:auto;" onchange="ckBase();"></select>
    <span id="ckMmWrap"><span style="font-size:12.5px; font-weight:700; color:#43555f;">월</span>
      <select id="ckMm" style="width:auto;" onchange="ckPrdNoFill();"></select></span>
    <%-- ★주기 번호 — 반기/분기/주차/일. 주기가 정하는 범위만 채운다(2026-08-12) --%>
    <span id="ckNoWrap" style="display:none;">
      <span id="ckNoLb" style="font-size:12.5px; font-weight:700; color:#43555f;"></span>
      <select id="ckPrdNo" style="width:auto;"></select></span>
    <span style="font-size:12.5px; font-weight:700; color:#43555f; margin-left:6px;">병동</span>
    <input type="text" id="f_wardNm" maxlength="100" placeholder="예) 3병동" style="width:120px;">
    <span class="ck-spacer"></span>
    <select id="ckDoc" style="min-width:220px;" onchange="ckPickDoc();">
      <option value="">— 저장된 점검표 —</option>
    </select>
    <button type="button" class="ck-btn ghost" onclick="ckNew();">＋ 새로 작성</button>
  </div>
  <div id="ckHeadWrap" class="ck-form" style="margin-bottom:10px;"></div>
  <div class="ck-guide" id="ckGuide" style="display:none;"></div>
  <div class="ck-legend" id="ckLegend" style="display:none;"></div>
  <%-- ★대장(LIST) 전용 — 행이 자유라 늘리고 줄이는 손잡이가 필요하다.
       ★표 **밖**에 둔다. 표 안에 두면 인쇄가 격자를 그대로 복사하므로 종이에 버튼이 찍힌다. --%>
  <%-- ★블록이 있으면 이 자리에 **블록마다** 손잡이가 깔린다(ckListBar 를 다시 그린다). --%>
  <div id="ckListBar" class="ck-bar" style="display:none; margin-bottom:6px;"></div>
  <div class="gridwrap" id="ckGridWrap"><div class="ck-empty">서식을 고르세요.</div></div>

  <div id="ckNoteWrap" style="display:none; margin-top:10px;">
    <div style="font-size:12.5px; font-weight:700; color:#43555f; margin-bottom:4px;">특이사항</div>
    <textarea id="f_noteTxt" rows="2"></textarea>
  </div>
  <div id="ckFixWrap" style="display:none; margin-top:8px;">
    <div style="font-size:12.5px; font-weight:700; color:#43555f; margin-bottom:4px;">수리날짜 및 고장 발생 내용</div>
    <textarea id="f_fixTxt" rows="2"></textarea>
  </div>
  <div id="ckFoot" style="display:none; margin-top:8px; font-size:12px; color:#6b7c86;"></div>
</div>

<script>
(function(){
  var HOSP_NM = '', APPR_LINE = [], FORMS = [], FORM = null, ITEMS = [], DOCS = [], curSeq = 0;

  function gel(id){ return document.getElementById(id); }
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
  var AXIS_NM = { ITEM_DAY:'항목 × 일', DAY_ITEM:'일 × 항목', EQUIP_DAY:'기기 × 일',
                  ITEM_MONTH:'항목 × 월', LIST:'대장 (자유행)', ITEM_COL:'항목 × 고정 열' };

  /**
   * ★ITEM_COL 의 고정 열 목록을 푼다. `묶음>열,묶음>열,열` 형태.
   *   ***이어진 같은 묶음끼리 합쳐진다*** — DAY_ITEM 의 열 묶음과 같은 규칙이라 사람이 새로 배울 것이 없다.
   */
  function colDefs(){
    var raw = (FORM && FORM.colnms) ? String(FORM.colnms) : '';
    return raw.split(',').map(function(s){ return s.trim(); }).filter(function(s){ return s; })
              .map(function(s){
                var i = s.indexOf('>');
                return (i >= 0) ? { g: s.slice(0, i).trim(), n: s.slice(i + 1).trim() }
                                : { g: '', n: s };
              });
  }
  /* ═══ 행 블록 — 한 문서에 표가 여럿, ***열은 같다*** (2026-08-12, v3 순서 5) ═══
     근거 6종이 둘로 갈린다 :
       ⓐ 항목이 행인 축(시설 4종) — 블록 이름이 **이미 항목의 GRP_NM 에 있다.**
          저장할 것이 없고 그리는 방법만 다르다 ⇒ `ROW_BLK_GB='B'` 면 왼쪽 세로 칸 대신 **가로 띠**.
       ⓑ LIST(영양 2종) — 행이 사람·품목이라 담을 곳이 없다 ⇒ 서식의 `ROW_BLKS` 가 정한다. */

  /** `이름>기본행수,이름>기본행수` 를 푼다. 숫자가 없으면 기본 5행. */
  function blkDefs(){
    var raw = (FORM && FORM.rowblks) ? String(FORM.rowblks) : '';
    return raw.split(',').map(function(s){ return s.trim(); }).filter(function(s){ return s; })
              .map(function(s){
                var i = s.indexOf('>'), nm = (i >= 0) ? s.slice(0, i).trim() : s, n = (i >= 0) ? Number(s.slice(i + 1)) : 0;
                return { nm: nm, n: (n >= 1 && n <= 999) ? Math.floor(n) : 5 };
              });
  }
  /**
   * 블록 b(1부터)의 i 번째 행 번호 = **b*1000 + i**.
   * ⚠***붙여서 매기면 안 된다.*** 1블록이 17행이라 2블록을 18부터 매기면, 병원이 1블록에
   *   한 사람을 더하는 순간 2블록 전체가 한 칸씩 밀려 **지난달 자료가 어긋난다.**
   * ★읽을 때 1000 미만은 블록 1 로 본다 — 블록 없이 쓰던 서식에 나중에 블록을 붙여도 살아 있게.
   */
  function blkRowNo(b, i){ return b * 1000 + i; }
  function blkOfRow(rn){ return (rn >= 1000) ? Math.floor(rn / 1000) : 1; }

  /* ═══ 항목 앞/뒤 열 — 격자 옆에 붙는 칸 (2026-08-12, v3 순서 7) ═══
     근거 10종이 **둘로 갈린다.** 뭉치면 병원이 매달 같은 글을 다시 친다 :
       ⓐ 항목마다 늘 같은 글(청소방법·항목 설명·설치 위치) → **항목의 속성** `DESC_TXT`.
          그 열의 머리글만 서식이 정한다(`DESC_NM`). 문서는 이 칸을 적지 않는다.
       ⓑ 문서가 적는 값(예산·조치사항·수량·Su/Rt/Lt) → `PRE_COLS`·`POST_COLS` 가 이름을,
          값은 `CHK_VAL` 이 가진다.
     ★열 번호는 **1000 단위로 띄운다** — 앞 열 j = 1000+j, 뒤 열 j = 2000+j.
       ⚠일(1~31) 뒤에 이어 붙이면 2월(28칸)과 3월(31칸)의 「29번 열」이 서로 다른 것을 뜻해
         ***달을 바꾸는 순간 값이 옆으로 옮겨 간다.*** */
  var PRE_BASE = 1000, POST_BASE = 2000;
  /** 앞/뒤 열은 **항목이 행인 세 축**만 — 서버(QpsController.sideOk)와 같은 판단이어야 한다. */
  function sideOk(){ var a = axis(); return a === 'ITEM_DAY' || a === 'ITEM_MONTH' || a === 'ITEM_COL'; }
  function nameList(s){
    return String(s || '').split(',').map(function(x){ return x.trim(); })
                          .filter(function(x){ return x; });
  }
  function descNm(){ return (sideOk() && FORM && FORM.descnm) ? String(FORM.descnm).trim() : ''; }
  function preCols(){  return sideOk() && FORM ? nameList(FORM.precols)  : []; }
  function postCols(){ return sideOk() && FORM ? nameList(FORM.postcols) : []; }
  /** 격자 양옆에 몇 칸이 붙나 — 빈 줄·사인 행의 `colspan` 을 맞추는 데 쓴다. */
  function sideCnt(){ return (descNm() ? 1 : 0) + preCols().length + postCols().length; }

  var SIGN_NO = 900;   // 예약 — 점검자 사인 행(또는 열)
  var HEAD_MAX = 8;    // 상단 자유칸 최대 수. ★DB 컬럼 HEAD1~HEAD8 과 반드시 같아야 한다
  // ★대장의 현재 행 수. 서식이 아니라 **문서**가 정하므로 화면이 들고 있는다(저장은 값이 있는 행만).
  //   ★블록마다 따로 센다 — `{블록번호: 행 수}`. 블록이 없는 서식은 `{1: n}` 하나뿐이다.
  //   하나의 숫자로 두면 블록이 생기는 순간 「어느 표의 행 수인가」가 사라진다.
  var LIST_ROWS = {};

  (function(){
    var y = new Date().getFullYear(), sy = gel('ckYear');
    for (var i = y + 1; i >= y - 4; i--) sy.add(new Option(i + '년', i));
    sy.value = y;
    var sm = gel('ckMm');
    for (var m = 1; m <= 12; m++) sm.add(new Option(m + '월', ('0' + m).slice(-2)));
    sm.value = ('0' + (new Date().getMonth() + 1)).slice(-2);
  })();

  /** 그 달의 날 수 — ★31 로 고정하면 2월에 없는 날짜 칸이 생긴다. */
  function daysInMonth(){
    var y = Number(gel('ckYear').value), m = Number(gel('ckMm').value || 1);
    return new Date(y, m, 0).getDate();
  }
  function dowCls(d){
    if (isMonthly() === false) return '';
    var y = Number(gel('ckYear').value), m = Number(gel('ckMm').value || 1);
    var w = new Date(y, m - 1, d).getDay();
    return w === 0 ? ' sun' : (w === 6 ? ' sat' : '');
  }
  function axis(){ return (FORM && FORM.axisgb) || 'ITEM_DAY'; }

  /* ═══ 문서 단위(주기) — Y연 H반기 Q분기 M월 W주 D일 (2026-08-12) ═══
     ★칸을 낱개로 늘리지 않으려고 (주기 + 번호) 한 쌍으로 뒀다.
       Y : 연            H : 연+번호(1~2)      Q : 연+번호(1~4)
       M : 연+월         W : 연+월+번호(1~5)   D : 연+월+번호(1~그달 날수)
     ★서버(QpsController.prdOf/prdMax)와 **같은 규칙**이어야 한다 — 갈리면 목록이 어긋난다. */
  function prd(){ return (FORM && FORM.prdgb) ? FORM.prdgb : 'M'; }
  function usesMm(){ var g = prd(); return g === 'M' || g === 'W' || g === 'D'; }
  var PRD_LB = { H:'반기', Q:'분기', W:'주차', D:'일' };
  /** 그 주기의 번호 목록. 빈 배열이면 번호를 안 쓴다(연·월). */
  function prdNos(){
    var g = prd(), out = [], i;
    if (g === 'H') return [[1,'상반기'], [2,'하반기']];
    if (g === 'Q') { for (i=1;i<=4;i++) out.push([i, i+'분기']); return out; }
    if (g === 'W') { for (i=1;i<=5;i++) out.push([i, i+'주차']); return out; }
    if (g === 'D') { for (i=1;i<=daysInMonth();i++) out.push([i, i+'일']); return out; }
    return out;
  }
  /**
   * 격자가 「1~31일」로 뻗는가 — <b>표를 그리는 쪽</b> 판단.
   * ★★문서 단위(prd)와는 다른 물음이다(2026-08-12에 갈랐다).
   *   종전엔 `prdgb !== 'Y'` 하나로 둘 다 했는데, 주기가 여섯이 되면서 뜻이 어긋났다 —
   *   예를 들어 <b>반기 단위 ITEM_COL</b> 은 prdgb='H' 라 옛 판단으로는 「일 격자」가 되어 버린다.
   *   ⇒ 격자는 <b>축</b>이 정한다. 1~12월을 쓰는 것은 ITEM_MONTH 뿐이다.
   */
  function isMonthly(){ return axis() !== 'ITEM_MONTH'; }

  /* ═══ 격자의 기간 칸 종류(PRD_KIND) — D일 W요일 N주차 M월 Q분기 (2026-08-12) ═══
     ★★축 이름을 늘리지 않고 **(방향 × 기간 종류)** 로 푼다.
       DAY_ITEM + 'M' 이면 「1~12월 행 × 항목 열」이 되어 MONTH_ITEM 이라는 새 축이 필요 없다.
     ★비면 축에서 유추 — ITEM_MONTH→'M', 그 외→'D'. **없으면 기본값이 아니라 「옛 뜻」이다.**
       그래야 2026-08-11 에 만든 서식 12종이 값 없이도 지금과 똑같이 그려진다. */
  function kind(){
    var k = FORM && FORM.prdkind ? String(FORM.prdkind).toUpperCase() : '';
    if (k && 'DWNMQ'.indexOf(k) >= 0) return k;
    return (axis() === 'ITEM_MONTH') ? 'M' : 'D';
  }
  var WDAY = ['월','화','수','목','금','토','일'];
  /**
   * 기간 칸 목록 → [{no, label, cls}]. ***표를 그리는 곳은 전부 이걸 쓴다*** —
   * 머리글·셀·인쇄가 따로 세면 칸 수가 어긋난다(반달 접기가 그래서 `data-day` 를 쓴다).
   */
  function prdCells(){
    var k = kind(), out = [], i;
    if (k === 'W') {           // 요일 7칸 — 토·일은 색을 준다(날짜 격자와 같은 규칙)
      for (i = 0; i < 7; i++) out.push({ no:i+1, label:WDAY[i], cls:(i===5?'sat':(i===6?'sun':'')) });
      return out;
    }
    if (k === 'N') { for (i=1;i<=5;i++) out.push({ no:i, label:i+'주', cls:'' }); return out; }
    if (k === 'M') { for (i=1;i<=12;i++) out.push({ no:i, label:i+'월', cls:'' }); return out; }
    if (k === 'Q') { for (i=1;i<=4;i++) out.push({ no:i, label:i+'분기', cls:'' }); return out; }
    // D — 그 달의 날 수. ★31 로 고정하면 2월에 없는 날짜 칸이 생긴다
    for (i = 1; i <= daysInMonth(); i++) out.push({ no:i, label:String(i), cls:dowCls(i).trim() });
    return out;
  }
  /** 기간 축의 머리글 이름 — 표 왼쪽 위 모서리에 적는다. */
  function prdHeadNm(){
    var k = kind();
    return k === 'W' ? '요일' : k === 'N' ? '주차' : k === 'M' ? '월' : k === 'Q' ? '분기' : '일';
  }

  /**
   * 셀 하나. day 를 주면 `data-day` 를 단다 — ★인쇄에서 **반달 접기**가 이걸 보고 열을 가른다.
   * 표를 다시 그리지 않고 화면 격자를 복사해 쓰기 때문에, 어느 칸이 며칠인지 표에 적혀 있어야 한다.
   */
  function cell(r, c, v, cls, day){
    return '<td' + (day ? (' data-day="' + day + '"') : '') + '><input' +
           (cls ? (' class="' + cls + '"') : '') +
           ' data-r="' + r + '" data-c="' + c + '" value="' + esc(v) + '"></td>';
  }

  /**
   * 격자 옆 칸의 **머리글**. `back=true` 면 뒤쪽(POST) 것만.
   * @param rs 2단 머리글 표에서 이 칸이 덮어야 할 줄 수(없으면 1줄)
   */
  function sideTh(back, rs){
    var sp = (rs > 1) ? (' rowspan="' + rs + '"') : '';
    if (back) {
      return postCols().map(function(nm){
        return '<th class="side"' + sp + ' style="min-width:96px;white-space:normal;">' + esc(nm) + '</th>';
      }).join('');
    }
    var out = '';
    if (descNm()) out += '<th class="side"' + sp + ' style="min-width:110px;white-space:normal;">' + esc(descNm()) + '</th>';
    return out + preCols().map(function(nm){
      return '<th class="side"' + sp + ' style="min-width:80px;white-space:normal;">' + esc(nm) + '</th>';
    }).join('');
  }
  /**
   * 격자 옆 칸의 **몸통**. `r` 이 없으면 사인 행 — 앞/뒤 칸은 비운다.
   * ★설명 칸은 **입력이 아니다.** 항목의 속성이라 여기서 고치면 이 달만 달라진다 —
   *   서식 관리에서 고쳐야 모든 달이 같이 바뀐다. 그래서 글자로만 찍는다.
   */
  function sideTd(r, g, back){
    if (back) {
      return postCols().map(function(nm, j){
        return r ? cell(r.sort, POST_BASE + j + 1, g(r.sort, POST_BASE + j + 1), 'ltxt') : '<td></td>';
      }).join('');
    }
    var out = '';
    if (descNm()) out += '<td class="sidetxt">' + (r ? esc(r.desctxt || '') : '') + '</td>';
    return out + preCols().map(function(nm, j){
      return r ? cell(r.sort, PRE_BASE + j + 1, g(r.sort, PRE_BASE + j + 1), 'ltxt') : '<td></td>';
    }).join('');
  }

  /** ★표를 그리는 곳은 여기 하나다. 서식이 늘어도 여기만 돈다. */
  function renderGrid(vals, rows){
    var box = gel('ckGridWrap');
    if (!FORM) { box.innerHTML = '<div class="ck-empty">서식을 고르세요.</div>'; return; }
    var V = {};
    (vals || []).forEach(function(v){ V[v.rowno + '_' + v.colno] = v.val; });
    var RN = {};
    (rows || []).forEach(function(r){ RN[r.rowno] = r.rownm; });
    function g(r, c){ return V[r + '_' + c] || ''; }

    var a = axis(), h = '', i, d;
    // ★기간 칸은 한 곳(prdCells)에서만 센다 — 머리글·셀이 따로 세면 칸 수가 어긋난다
    var PC = prdCells(), nCol = PC.length;

    if (a === 'ITEM_COL') {
      // ★항목 행 × 날짜가 아닌 고정 열. 열 이름은 서식이 정한다(COL_NMS).
      //   행 그룹은 ITEM_DAY 와 같은 장치를 그대로 쓴다 — 이 축의 서식은 대부분 묶음이 있다.
      var cd = colDefs();
      if (!cd.length) cd = [{ g:'', n:'점검결과' }];   // 열을 안 적었으면 한 칸이라도 그린다
      var cg = [], cl = null;
      cd.forEach(function(c){
        if (cl && cl.g === c.g && c.g) cl.n++; else { cl = { g:c.g, n:1 }; cg.push(cl); }
      });
      var hasCg = cg.some(function(x){ return x.g; });
      // 행 묶음
      var ig = [], il = null;
      ITEMS.forEach(function(r){
        var gn = r.grpnm || '';
        if (il && il.g === gn) il.n++; else { il = { g:gn, n:1 }; ig.push(il); }
      });
      // ★행 묶음을 **가로 띠**로 그리는 서식이 있다(시설물 정기점검의 「약국」·「조리실」 등, 4종).
      //   담긴 자료는 똑같다 — GRP_NM 이다. ***그리는 방법만 다르다.***
      var band = (FORM.rowblkgb === 'B') && ig.some(function(x){ return x.g; });
      var hasIg = !band && ig.some(function(x){ return x.g; });

      var colTh = function(){
        return cd.map(function(c){ return '<th style="min-width:78px;white-space:normal;">' + esc(c.n) + '</th>'; }).join('');
      };
      h += '<table class="gr' + (hasIg ? ' hasrg' : '') + '"><thead>';
      if (hasCg) {
        // ★2단 머리글에서는 옆 칸도 두 줄을 덮어야 한다 — 안 그러면 아랫줄이 한 칸씩 밀린다
        h += '<tr>' + (hasIg ? '<th class="rgrp" rowspan="2">묶음</th>' : '') +
             '<th class="hd" rowspan="2">점검 항목</th>' + sideTh(false, 2) +
             cg.map(function(x){ return '<th colspan="' + x.n + '">' + esc(x.g) + '</th>'; }).join('') +
             sideTh(true, 2) + '</tr><tr>' + colTh() + '</tr>';
      } else {
        h += '<tr>' + (hasIg ? '<th class="rgrp">묶음</th>' : '') +
             '<th class="hd">점검 항목</th>' + sideTh() + colTh() + sideTh(true) + '</tr>';
      }
      h += '</thead><tbody>';
      if (!ITEMS.length) h += '<tr><td class="hd" style="color:#8a99a3;">이 서식에 점검항목이 없습니다 — [서식 관리]에서 등록하세요.</td>' +
                              '<td colspan="' + (cd.length + sideCnt()) + '"></td></tr>';
      var ci = 0, cp = 0;
      ITEMS.forEach(function(r){
        // 띠 표시 — 묶음이 바뀌는 자리에 표 폭을 가로지르는 머리 행을 넣는다
        if (band && cp === 0 && ig[ci].g) h += '<tr class="blk"><td colspan="' + (1 + cd.length + sideCnt()) + '">' + esc(ig[ci].g) + '</td></tr>';
        h += '<tr>';
        if (hasIg && cp === 0) h += '<th class="rgrp" rowspan="' + ig[ci].n + '">' + esc(ig[ci].g) + '</th>';
        h += '<th class="hd">' + esc(r.itemnm) + (r.unitnm ? (' (' + esc(r.unitnm) + ')') : '') + '</th>';
        h += sideTd(r, g);
        cd.forEach(function(c, k){ h += cell(r.sort, k + 1, g(r.sort, k + 1), (r.inputgb === 'CHECK') ? '' : 'ltxt'); });
        h += sideTd(r, g, true) + '</tr>';
        if (hasIg || band) { cp++; if (cp >= ig[ci].n) { ci++; cp = 0; } }
      });
      if (FORM.signeryn === 'Y') {
        h += '<tr class="sign">' + (hasIg ? '<th class="rgrp"></th>' : '') + '<th class="hd">점검자 사인</th>' +
             sideTd(null, g);
        cd.forEach(function(c, k){ h += cell(SIGN_NO, k + 1, g(SIGN_NO, k + 1)); });
        h += sideTd(null, g, true) + '</tr>';
      }
      h += '</tbody></table>';

    } else if (a === 'LIST') {
      // ★대장 — 항목이 열, 행은 자유. 「1일~31일」이 아니라 「1번째 사람/건」이다.
      //   ⇒ 행 수를 서식이 못 정한다. 저장분에 들어 있는 가장 큰 행번호부터 다시 그린다.
      //   ★행 블록이 있으면 **블록마다** 따로 센다(2026-08-12).
      var BD = blkDefs(), nblk = BD.length || 1;
      var maxIn = {};                                  // 블록 → 저장분의 가장 큰 순번
      Object.keys(V).forEach(function(k){
        var rn = Number(k.split('_')[0]);
        if (rn === SIGN_NO) return;
        var b = BD.length ? blkOfRow(rn) : 1;
        var seq = (BD.length && rn >= 1000) ? (rn % 1000) : rn;
        if (b >= 1 && b <= nblk && seq > (maxIn[b] || 0)) maxIn[b] = seq;
      });
      // 서식의 기본 행 수(블록이 있으면 `이름>수`, 없으면 EQUIP_CNT)보다 적게 그리지 않는다
      for (var b = 1; b <= nblk; b++) {
        var base = BD.length ? BD[b - 1].n : Number(FORM.equipcnt || 10);
        LIST_ROWS[b] = Math.max(maxIn[b] || 0, LIST_ROWS[b] || 0, base, 1);
      }
      // 열 묶음(GRP_NM)은 DAY_ITEM 과 똑같이 성립한다 — 대장도 **항목이 열**이기 때문이다
      var lg = [], ll = null;
      ITEMS.forEach(function(r){
        var gname = r.grpnm || '';
        if (ll && ll.g === gname) ll.n++; else { ll = { g:gname, n:1 }; lg.push(ll); }
      });
      var NOCOL = '<th class="hd" style="min-width:46px;max-width:46px;">번호</th>';
      // ★블록 안 function 선언은 브라우저마다 끌어올림이 갈린다 — 변수에 담는다
      var itemTh = function(){
        return ITEMS.map(function(r){
          return '<th style="min-width:110px;white-space:normal;">' + esc(r.itemnm) +
                 (r.unitnm ? ('<br>(' + esc(r.unitnm) + ')') : '') + '</th>';
        }).join('');
      };
      h += '<table class="gr"><thead>';
      if (lg.some(function(x){ return x.g; })) {
        h += '<tr><th class="hd" rowspan="2" style="min-width:46px;max-width:46px;">번호</th>' +
             lg.map(function(x){ return '<th colspan="' + x.n + '">' + esc(x.g) + '</th>'; }).join('') +
             '</tr><tr>' + itemTh() + '</tr>';
      } else {
        h += '<tr>' + NOCOL +
             (ITEMS.length ? itemTh()
                           : '<th style="min-width:260px;white-space:normal;color:#8a99a3;">' +
                             '이 서식에 항목이 없습니다 — [서식 관리]에서 등록하세요.</th>') + '</tr>';
      }
      h += '</thead><tbody>';
      var span = 1 + Math.max(ITEMS.length, 1);        // 띠 행이 가로지를 칸 수
      for (var bi = 1; bi <= nblk; bi++) {
        // ★블록 머리 = **표 폭을 가로지르는 띠**. 원본이 그렇게 생겼다(▶병원 근무자 / ▶배송기사).
        if (BD.length) h += '<tr class="blk"><td colspan="' + span + '">' + esc(BD[bi - 1].nm) + '</td></tr>';
        for (i = 1; i <= LIST_ROWS[bi]; i++) {
          var rno = BD.length ? blkRowNo(bi, i) : i;   // 블록이 없으면 옛 번호 그대로
          h += '<tr><td class="hd" style="text-align:center;min-width:46px;max-width:46px;">' + i + '</td>';
          if (!ITEMS.length) h += '<td></td>';
          // ★표시칸(CHECK)만 가운데 정렬. 이름·사유가 가운데 오면 읽기 나쁘다
          ITEMS.forEach(function(r){
            h += cell(rno, r.sort, g(rno, r.sort), (r.inputgb === 'CHECK') ? '' : 'ltxt');
          });
          h += '</tr>';
        }
      }
      h += '</tbody></table>';

    } else if (a === 'DAY_ITEM') {
      // ★기간 행 × 항목 열. 기간이 무엇인지는 PRD_KIND 가 정한다 —
      //   'D'면 1~31일(원래), 'M'이면 **1~12월 행**(냉·난방 필터 청소 점검일지),
      //   'W'면 월~일, 'N'이면 1~5주차. ***MONTH_ITEM 이라는 새 축이 필요 없다.***
      var grps = [], last = null;
      ITEMS.forEach(function(r){
        var gname = r.grpnm || '';
        if (last && last.g === gname) last.n++; else { last = { g:gname, n:1 }; grps.push(last); }
      });
      var hasGrp = grps.some(function(x){ return x.g; });
      var itemTh = function(){
        return ITEMS.map(function(r){ return '<th style="min-width:88px;white-space:normal;">' + esc(r.itemnm) +
               (r.unitnm ? ('<br>(' + esc(r.unitnm) + ')') : '') + '</th>'; }).join('');
      };
      h += '<table class="gr"><thead>';
      if (hasGrp) {
        h += '<tr><th class="hd" rowspan="2" style="min-width:52px;">' + prdHeadNm() + '</th>' +
             grps.map(function(x){ return '<th colspan="' + x.n + '">' + esc(x.g) + '</th>'; }).join('') +
             '</tr><tr>' + itemTh() + '</tr>';
      } else {
        h += '<tr><th class="hd" style="min-width:52px;">' + prdHeadNm() + '</th>' + itemTh() + '</tr>';
      }
      h += '</thead><tbody>';
      PC.forEach(function(pc){
        h += '<tr><td class="hd ' + pc.cls + '" style="text-align:center;">' + esc(pc.label) + '</td>';
        ITEMS.forEach(function(r){ h += cell(pc.no, r.sort, g(pc.no, r.sort)); });
        h += '</tr>';
      });
      h += '</tbody></table>';

    } else if (a === 'EQUIP_DAY') {
      // 기기 N행 × 1~31일. ★기기명은 문서마다 다르다(병동마다 장비가 다르다).
      var n = Number(FORM.equipcnt || 10);
      h += '<table class="gr"><thead><tr><th class="hd">의료기기</th>';
      PC.forEach(function(pc){
        h += '<th class="' + pc.cls + '" data-day="' + pc.no + '" style="min-width:32px;">' + esc(pc.label) + '</th>';
      });
      h += '</tr></thead><tbody>';
      for (i = 1; i <= n; i++) {
        h += '<tr><td class="hd"><input data-rn="' + i + '" value="' + esc(RN[i] || '') +
             '" placeholder="의료기기 ' + i + '"></td>';
        (function(rw){ PC.forEach(function(pc){ h += cell(rw, pc.no, g(rw, pc.no), '', pc.no); }); })(i);
        h += '</tr>';
      }
      if (FORM.signeryn === 'Y') {
        h += '<tr class="sign"><th class="hd">점검자 확인란</th>';
        PC.forEach(function(pc){ h += cell(SIGN_NO, pc.no, g(SIGN_NO, pc.no), '', pc.no); });
        h += '</tr>';
      }
      h += '</tbody></table>';

    } else {
      // ITEM_DAY / ITEM_MONTH — 항목 행 × 일(또는 월) 열
      // ★행 그룹 — 이어지는 항목의 GRP_NM 이 같으면 왼쪽에 묶음 칸을 세운다(2단 행 머리글).
      //   실물 근거 : 카트및엘리베이터 청소소독(엘리베이터/카트 × 3항목).
      //   ***DAY_ITEM 의 열 묶음과 같은 자료(GRP_NM)를 쓴다*** — 축이 눕히기만 할 뿐 뜻은 하나다.
      var rg = [], rl = null;
      ITEMS.forEach(function(r){
        var gname = r.grpnm || '';
        if (rl && rl.g === gname) rl.n++; else { rl = { g:gname, n:1 }; rg.push(rl); }
      });
      // ★같은 GRP_NM 을 **가로 띠**로 그릴 수도 있다(ROW_BLK_GB='B') — ITEM_COL 과 같은 장치다
      var rband = (FORM.rowblkgb === 'B') && rg.some(function(x){ return x.g; });
      var hasRg = !rband && rg.some(function(x){ return x.g; });
      h += '<table class="gr' + (hasRg ? ' hasrg' : '') + '"><thead><tr>' +
           (hasRg ? '<th class="rgrp">묶음</th>' : '') +
           '<th class="hd">점검 항목</th>' + sideTh();
      PC.forEach(function(pc){
        h += '<th class="' + pc.cls + '" data-day="' + pc.no + '" style="min-width:32px;">' + esc(pc.label) + '</th>';
      });
      h += sideTh(true) + '</tr></thead><tbody>';
      if (!ITEMS.length) h += '<tr><td class="hd" style="color:#8a99a3;">이 서식에 점검항목이 없습니다 — [서식 관리]에서 등록하세요.</td>' +
                              '<td colspan="' + (nCol + sideCnt()) + '"></td></tr>';
      var gi = 0, gpos = 0;   // 지금 몇 번째 묶음인지 / 그 묶음 안에서 몇 번째 행인지
      ITEMS.forEach(function(r){
        if (rband && gpos === 0 && rg[gi].g) h += '<tr class="blk"><td colspan="' + (1 + nCol + sideCnt()) + '">' + esc(rg[gi].g) + '</td></tr>';
        h += '<tr>';
        // 묶음 칸은 그 묶음의 **첫 행에서만** 나오고 나머지 행을 rowspan 으로 덮는다
        if (hasRg && gpos === 0) h += '<th class="rgrp" rowspan="' + rg[gi].n + '">' + esc(rg[gi].g) + '</th>';
        h += '<th class="hd">' + esc(r.itemnm) + (r.unitnm ? (' (' + esc(r.unitnm) + ')') : '') + '</th>';
        h += sideTd(r, g);
        (function(rw){ PC.forEach(function(pc){ h += cell(rw, pc.no, g(rw, pc.no), '', pc.no); }); })(r.sort);
        h += sideTd(r, g, true);
        h += '</tr>';
        if (hasRg || rband) { gpos++; if (gpos >= rg[gi].n) { gi++; gpos = 0; } }
      });
      if (FORM.signeryn === 'Y') {
        // 사인 행은 어느 묶음에도 속하지 않는다 — 빈 묶음 칸을 하나 둬야 칸 수가 맞는다
        h += '<tr class="sign">' + (hasRg ? '<th class="rgrp"></th>' : '') + '<th class="hd">점검자 사인</th>' +
             sideTd(null, g);
        PC.forEach(function(pc){ h += cell(SIGN_NO, pc.no, g(SIGN_NO, pc.no), '', pc.no); });
        h += sideTd(null, g, true) + '</tr>';
      }
      h += '</tbody></table>';
    }
    box.innerHTML = h;
  }

  function renderHead(doc){
    doc = doc || {};
    // ★상단 자유칸은 8개까지(2026-08-12). 4개였을 때 9종이 오직 이 칸 때문에 밀려났다.
    //   ⚠상단 칸은 **줄지어 늘어놓는 것**밖에 못 한다 — 칸 위치까지 원본을 따라가야 하는
    //     법정·의뢰 서식은 8칸이 들어가도 여전히 개별 화면이다.
    var wrap = gel('ckHeadWrap'), nms = (FORM && FORM.headnms) ? String(FORM.headnms).split(',') : [];
    nms = nms.map(function(s){ return s.trim(); }).filter(function(s){ return s; }).slice(0, HEAD_MAX);
    if (!nms.length) { wrap.innerHTML = ''; wrap.style.display = 'none'; return; }
    wrap.style.display = '';
    wrap.innerHTML = nms.map(function(nm, i){
      return '<div class="lb">' + esc(nm) + '</div><div><input type="text" id="f_head' + (i + 1) +
             '" maxlength="200" value="' + esc(doc['head' + (i + 1)]) + '"></div>';
    }).join('');
  }

  function applyFormUi(){
    gel('ckTitle').textContent = FORM ? FORM.formnm : '점검표';
    gel('ckAxisNm').textContent = FORM ? ('— ' + (AXIS_NM[FORM.axisgb] || FORM.axisgb)) : '';
    var gd = gel('ckGuide');
    if (FORM && FORM.guidetxt) { gd.style.display = ''; gd.textContent = FORM.guidetxt; } else gd.style.display = 'none';
    // EQUIP_DAY 는 점검항목이 표 위 안내박스로만 나온다(셀은 기기별 일별)
    var lg = gel('ckLegend');
    if (FORM && FORM.axisgb === 'EQUIP_DAY' && ITEMS.length) {
      lg.style.display = '';
      lg.innerHTML = '<b style="margin-right:6px;">점검항목</b>' +
        ITEMS.map(function(r, i){ return '<span>' + (i + 1) + '. ' + esc(r.itemnm) + '</span>'; }).join('');
    } else lg.style.display = 'none';
    // ★기간 칸은 **문서 단위**가 정한다 — 연·반기·분기는 월이 없고, 주·일은 월+번호를 쓴다
    gel('ckMmWrap').style.display = usesMm() ? '' : 'none';
    ckPrdNoFill();
    // 대장만 행 손잡이가 보인다 — 다른 축은 행 수를 서식이 정하므로 늘릴 일이 없다
    var lb = gel('ckListBar');
    lb.style.display = (FORM && FORM.axisgb === 'LIST') ? '' : 'none';
    if (FORM && FORM.axisgb === 'LIST') lb.innerHTML = listBarHtml();
    gel('ckNoteWrap').style.display = (FORM && FORM.noteyn === 'Y') ? '' : 'none';
    gel('ckFixWrap').style.display  = (FORM && FORM.fixyn === 'Y') ? '' : 'none';
    var ft = gel('ckFoot');
    if (FORM && FORM.foottxt) { ft.style.display = ''; ft.textContent = FORM.foottxt; } else ft.style.display = 'none';
  }

  /**
   * 기간 번호 셀렉트를 그 주기에 맞춰 채운다. 연·월이면 감춘다.
   * ★고르던 값은 지킨다 — 월을 바꿨다고 「3주차」가 1주차로 튀면 쓰기 나쁘다.
   *   단 범위를 벗어나면(2월 31일 → 28일) 마지막 값으로 당긴다.
   */
  window.ckPrdNoFill = function(){
    var wrap = gel('ckNoWrap'), sel = gel('ckPrdNo'), list = prdNos();
    if (!list.length) { wrap.style.display = 'none'; return; }
    wrap.style.display = '';
    gel('ckNoLb').textContent = PRD_LB[prd()] || '';
    var keep = Number(sel.value || 0);
    sel.innerHTML = '';
    list.forEach(function(x){ sel.add(new Option(x[1], x[0])); });
    // 처음이면 1, 범위를 넘으면 마지막(2월에 31일을 고르고 있었으면 28일로), 그 밖엔 그대로
    var pick = (keep < 1) ? 1 : (keep > list.length ? list.length : keep);
    sel.value = String(pick);
  };

  /** 저장된 문서 하나를 목록에 어떻게 적을까 — 「8월 3주차」·「하반기」처럼 사람이 읽게. */
  function docPrdLabel(d){
    var g = d.prdgb || 'M', no = Number(d.prdno || 0);
    var mm = d.inmm ? (Number(d.inmm) + '월') : '';
    if (g === 'Y') return '연간';
    if (g === 'H') return (no === 2 ? '하반기' : '상반기');
    if (g === 'Q') return no + '분기';
    if (g === 'W') return mm + ' ' + no + '주차';
    if (g === 'D') return mm + ' ' + no + '일';
    return mm || '연간';
  }

  window.ckBase = function(){
    return post('<c:url value="/qps/chkBase.do"/>', {
      inYear: gel('ckYear').value, formId: val('ckForm'), deptCd: val('ckDept')
    }).then(function(res){
      if (res.hosp) { HOSP_NM = res.hosp.hospnm || ''; gel('ckHosp').textContent = '🏥 ' + HOSP_NM; }
      APPR_LINE = res.line || [];
      // ★부서를 바꾸면 서식 목록이 통째로 바뀐다 — 캐시하면 안 된다
      FORMS = res.forms || [];
      var sel = gel('ckForm'), keep = sel.value;
      sel.innerHTML = '';
      if (!FORMS.length) sel.add(new Option('— 쓸 수 있는 서식이 없습니다 —', ''));
      FORMS.forEach(function(f){ sel.add(new Option(f.formnm, f.formid)); });
      // 부서를 바꿔도 고르던 서식이 그 부서에 있으면 그대로 둔다
      if (keep && FORMS.some(function(f){ return f.formid === keep; })) sel.value = keep;
      if (gel('ckDept').options.length <= 1) {
        (res.dept || []).forEach(function(c){ gel('ckDept').add(new Option(c.subcodenm || c.subcode, c.subcode)); });
      }
      FORM = res.form || null;
      ITEMS = res.items || [];
      DOCS = res.list || [];
      var ds = gel('ckDoc');
      ds.innerHTML = '<option value="">— 저장된 점검표 (' + DOCS.length + ') —</option>';
      DOCS.forEach(function(d){
        // ★주기마다 표기가 다르다 — 「8월 3주차」·「하반기」·「2분기」
        var nm = docPrdLabel(d) + (d.wardnm ? (' · ' + d.wardnm) : '') +
                 (d.head1 ? (' · ' + d.head1) : '');
        ds.add(new Option(nm, d.chkseq));
      });
      ds.value = curSeq ? String(curSeq) : '';
      applyFormUi();
      if (!curSeq) renderGrid([], []);
    }).catch(err);
  };

  /** 부서를 바꾸면 서식 목록이 갈린다 — 고르던 서식이 그 부서에 없으면 첫 서식으로 옮긴다. */
  window.ckPickDept = function(){
    ckBase().then(function(){
      if (FORMS.length && !FORMS.some(function(f){ return f.formid === val('ckForm'); })) {
        gel('ckForm').value = FORMS[0].formid;
      }
      ckPickForm();
    });
  };

  window.ckPickForm = function(){
    curSeq = 0;
    LIST_ROWS = {};           // ★서식이 바뀌면 행 수도 처음부터 — 안 그러면 앞 대장의 행 수가 따라온다
    gel('ckStat').textContent = '';
    gel('ckDelBtn').style.display = 'none';
    set('f_wardNm', ''); set('f_noteTxt', ''); set('f_fixTxt', '');
    ckBase().then(function(){ renderHead({}); renderGrid([], []); });
  };

  /**
   * 대장 행 손잡이 — ★블록이 있으면 **블록마다** 나온다.
   * ⚠표 **밖**에 둔다. 표 안에 두면 인쇄가 격자를 그대로 복사하므로 종이에 버튼이 찍힌다.
   */
  function listBarHtml(){
    var BD = blkDefs();
    if (!BD.length) {
      return '<button type="button" class="ck-btn mini" onclick="ckRowAdd(1);">＋ 행 추가</button>' +
             '<button type="button" class="ck-btn mini" onclick="ckRowAdd(5);">＋ 5행</button>' +
             '<button type="button" class="ck-btn mini" onclick="ckRowTrim();">− 빈 행 정리</button>' +
             '<span class="ck-sub">대장은 행을 자유롭게 늘립니다. 가운데 행을 없애려면 <b>그 행을 비우고</b> [빈 행 정리].</span>';
    }
    return BD.map(function(b, i){
             return '<button type="button" class="ck-btn mini" onclick="ckRowAdd(1,' + (i + 1) + ');">＋ ' +
                    esc(b.nm) + '</button>';
           }).join('') +
           '<button type="button" class="ck-btn mini" onclick="ckRowTrim();">− 빈 행 정리</button>' +
           '<span class="ck-sub">표가 ' + BD.length + '개입니다. 늘릴 표의 이름을 누르세요.</span>';
  }

  /** 대장 행 늘리기 — ★값은 지우지 않는다. 지금 화면의 입력을 걷어 다시 그린다. */
  window.ckRowAdd = function(n, b){
    if (!FORM || FORM.axisgb !== 'LIST') return;
    var c = collect(), k = Number(b) || 1;
    LIST_ROWS[k] = (LIST_ROWS[k] || 0) + (Number(n) || 1);
    renderGrid(c.vals, c.rows);
  };

  /**
   * 빈 행 정리 — 값이 하나도 없는 행을 없애고 번호를 1부터 다시 매긴다.
   * ★가운데 행을 지우는 길이기도 하다(그 행을 비우고 누르면 아래가 올라온다).
   * ★번호를 다시 매기지 않으면 1·2·5·9 처럼 구멍이 남아 추출 CSV 의 행번호가 뜻을 잃는다.
   */
  window.ckRowTrim = function(){
    if (!FORM || FORM.axisgb !== 'LIST') return;
    // ★블록이 있으면 **블록 안에서만** 다시 매긴다 — 블록을 넘겨 당기면 사람이 다른 표로 옮겨 간다
    var BD = blkDefs(), c = collect(), seen = {}, byBlk = {};
    c.vals.forEach(function(v){
      if (v.rowno === SIGN_NO || seen[v.rowno]) return;
      seen[v.rowno] = true;
      var b = BD.length ? blkOfRow(v.rowno) : 1;
      (byBlk[b] = byBlk[b] || []).push(v.rowno);
    });
    var map = {}, kept = 0;
    Object.keys(byBlk).forEach(function(b){
      byBlk[b].sort(function(x, y){ return x - y; });
      byBlk[b].forEach(function(r, i){ map[r] = BD.length ? blkRowNo(Number(b), i + 1) : (i + 1); });
      kept += byBlk[b].length;
    });
    var moved = c.vals.map(function(v){
      return (v.rowno === SIGN_NO) ? v : { rowno: map[v.rowno], colno: v.colno, val: v.val };
    });
    LIST_ROWS = {};                                  // Math.max 가 옛 행 수를 붙잡지 않도록
    renderGrid(moved, c.rows);
    // ★「몇 줄 지웠다」로 적지 않는다 — 기본 행 수 아래로는 안 줄어들어 숫자가 사실과 어긋난다.
    _toast('빈 행을 정리했습니다. 값 있는 행 ' + kept + '.', 'ok');
  };

  window.ckPickDoc = function(){
    var seq = val('ckDoc');
    if (!seq) { ckNew(); return; }
    post('<c:url value="/qps/chkGet.do"/>', { chkSeq: seq }).then(function(res){
      var d = res.doc || {};
      curSeq = Number(d.chkseq || 0);
      LIST_ROWS = {};   // ★행 수는 이 문서가 정한다 — 앞 문서의 행 수를 물려받으면 빈 행이 딸려 온다
      set('ckYear', d.inyear || gel('ckYear').value);
      if (d.inmm) set('ckMm', d.inmm);
      // ★번호는 목록을 다시 채운 **뒤에** 넣는다 — 먼저 넣으면 채우면서 지워진다
      ckPrdNoFill();
      if (d.prdno) set('ckPrdNo', String(d.prdno));
      set('f_wardNm', d.wardnm); set('f_noteTxt', d.notetxt); set('f_fixTxt', d.fixtxt);
      renderHead(d);
      renderGrid(res.vals || [], res.rows || []);
      gel('ckStat').textContent = '— 저장분 #' + d.chkseq;
      gel('ckDelBtn').style.display = '';
    }).catch(err);
  };

  window.ckNew = function(){
    curSeq = 0;
    LIST_ROWS = {};
    gel('ckDoc').value = '';
    set('f_noteTxt', ''); set('f_fixTxt', '');
    renderHead({});
    renderGrid([], []);
    gel('ckStat').textContent = '— 새 점검표';
    gel('ckDelBtn').style.display = 'none';
  };

  function collect(){
    var vals = [], rows = [];
    document.querySelectorAll('#ckGridWrap input[data-r]').forEach(function(el){
      var v = String(el.value).trim();
      if (!v) return;                       // ★빈 칸은 안 담는다
      vals.push({ rowno: Number(el.getAttribute('data-r')), colno: Number(el.getAttribute('data-c')), val: v });
    });
    document.querySelectorAll('#ckGridWrap input[data-rn]').forEach(function(el){
      var v = String(el.value).trim();
      if (!v) return;
      rows.push({ rowno: Number(el.getAttribute('data-rn')), rownm: v });
    });
    return { vals: vals, rows: rows };
  }

  window.ckSave = function(){
    if (!FORM) { _alertBox('서식을 먼저 고르세요.', {icon:'⚠️'}); return; }
    var c = collect();
    // ★주기(prdGb)는 안 보낸다 — **서버가 서식에서 읽는다.** 화면 값을 믿으면 서식과 어긋난 문서가 생긴다.
    var m = { chkSeq: curSeq || '', formId: FORM.formid, inYear: gel('ckYear').value,
              inMm: usesMm() ? gel('ckMm').value : '',
              prdNo: prdNos().length ? gel('ckPrdNo').value : '',
              wardNm: val('f_wardNm'),
              noteTxt: val('f_noteTxt'), fixTxt: val('f_fixTxt'),
              vals: JSON.stringify(c.vals), rows: JSON.stringify(c.rows) };
    // 상단 자유칸 — 없는 칸은 빈 값으로 보낸다(서버가 8개를 다 받는다)
    for (var hi = 1; hi <= HEAD_MAX; hi++) m['head' + hi] = val('f_head' + hi);
    post('<c:url value="/qps/chkSave.do"/>', m).then(function(res){
      _toast('저장되었습니다.', 'ok');
      curSeq = Number(res.chkSeq);
      ckBase().then(function(){ gel('ckDoc').value = String(curSeq); ckPickDoc(); });
    }).catch(err);
  };

  window.ckDel = function(){
    if (!curSeq) return;
    _confirmBox({ msg:'이 점검표를 삭제할까요?', icon:'⚠️', okText:'삭제', okColor:'#b23b3b',
      onOk: function(){
        post('<c:url value="/qps/chkDelete.do"/>', { chkSeq: curSeq }).then(function(){
          _toast('삭제되었습니다.', 'ok'); curSeq = 0; ckBase().then(ckNew);
        }).catch(err);
      } });
  };

  // ---------- 인쇄 ----------
  // ★A4 **가로**다. 31칸 격자는 세로로는 안 들어간다.
  var PRINT_CSS =
    '@page{ size:A4 landscape; margin:9mm; }' +
    'body{ margin:0; font-family:"맑은 고딕",Malgun Gothic,sans-serif; color:#000; }' +
    '.h1{ font-size:16px; font-weight:800; text-align:center; margin:0 0 6px; }' +
    '.meta{ font-size:11px; margin:0 0 6px; display:flex; gap:14px; flex-wrap:wrap; }' +
    'table{ width:100%; border-collapse:collapse; font-size:9px; }' +
    'th,td{ border:1px solid #666; padding:2px 3px; text-align:center; height:17px; }' +
    'th{ background:#eee; font-weight:700; }' +
    'td.l,th.l{ text-align:left; white-space:normal; }' +
    '.appr{ float:right; width:auto; margin:0 0 4px 8px; font-size:9px; }' +
    '.appr td{ height:34px; width:52px; }' +
    '.box{ border:1px solid #666; padding:4px 6px; font-size:9.5px; margin-top:4px;' +
    '      white-space:pre-wrap; text-align:left; min-height:24px; }' +
    '.sig{ margin-top:8px; font-size:10px; text-align:right; }' +
    '.sig span{ display:inline-block; margin-left:26px; }' +
    /* 행을 끊어 좌우로 놓을 때 — 조각을 가로로 나란히. ★조각이 3개 이상이면 줄바꿈해 이어 붙는다 */
    '.splitrow{ display:flex; gap:6px; align-items:flex-start; flex-wrap:wrap; }' +
    '.splitcol{ flex:1 1 0; min-width:0; }' +
    '.splitcol table{ width:100%; }';

  function apprHtml(){
    if (!APPR_LINE.length) return '';
    return '<table class="appr"><thead><tr>' + APPR_LINE.map(function(r){ return '<th>' + esc(r.stepnm) + '</th>'; }).join('') +
           '</tr></thead><tbody><tr>' + APPR_LINE.map(function(){ return '<td></td>'; }).join('') + '</tr></tbody></table>';
  }

  /* ═══ 인쇄 배치 — 「N칸씩 + 방향」 (2026-08-12, v3 순서 6) ═══
     ★종전 「반달 접기」는 1~15 / 16~31 하나만 됐다. 실물은 넷이다 —
       15칸(카트및엘리베이터) · 6칸(U.P.S 1~6월) · 7칸(욕창예방 **5쪽**) · 행을 좌우로(의료가스).
     ⇒ **끊는 수와 방향만** 서식이 정하면 넷이 한 장치로 풀린다.
     ★표를 다시 그리지 않고 **복사해서 잘라낸다** — 따로 만들면 화면과 종이가 갈린다. */

  /** 끊는 설정 → {n, dir} 또는 null. ★옛 `HALF_YN='Y'` 는 「15칸 · 열」과 같다. */
  function splitOf(){
    if (!FORM) return null;
    var n = Number(FORM.splitn || 0), dir = (FORM.splitdir || '').toUpperCase();
    if (!(n >= 2) || (dir !== 'C' && dir !== 'R')) {
      if (FORM.halfyn === 'Y') { n = 15; dir = 'C'; }   // 옛 서식 호환
      else return null;
    }
    // 열을 끊으려면 격자에 기간 칸(data-day)이 있어야 한다 — LIST·ITEM_COL 은 자를 기준이 없다
    if (dir === 'C' && (FORM.axisgb === 'LIST' || FORM.axisgb === 'ITEM_COL')) return null;
    return { n:n, dir:dir };
  }

  /**
   * total 칸을 n 칸씩 끊은 **조각 경계**. → `[{from,to}, ...]`
   *
   * ★***자투리가 1칸이면 앞 조각에 붙인다.*** 31일을 15칸씩 끊으면 15·15·**1** 이 되는데,
   *   1칸짜리 종이는 어떤 서식에서도 쓸모가 없다. 붙이면 `1~15 / 16~31` — 원본 그대로다.
   *   (7칸씩은 자투리가 3칸이라 그대로 둔다 → 욕창예방 **5쪽**이 맞다.)
   * ★작성 화면과 서식 관리 화면이 **같은 답**을 내야 한다 — 미리보기의 「몇 조각」이 종이와 갈리면
   *   적는 사람이 숫자를 못 믿는다. 관리 화면 `splitParts()` 와 규칙이 같다.
   */
  function splitRanges(total, n){
    var out = [], from;
    for (from = 1; from <= total; from += n) out.push({ from:from, to:Math.min(from + n - 1, total) });
    if (out.length > 1 && out[out.length - 1].to - out[out.length - 1].from === 0) {
      out[out.length - 2].to = out[out.length - 1].to;
      out.pop();
    }
    return out;
  }

  /** 표를 복사해 **기간 열**을 [from..to] 만 남긴다. 머리글·몸통에 함께 붙은 `data-day` 로 자른다. */
  function cutCols(src, from, to){
    var c = src.cloneNode(true);
    c.querySelectorAll('[data-day]').forEach(function(el){
      var d = Number(el.getAttribute('data-day'));
      if (d < from || d > to) el.parentNode.removeChild(el);
    });
    return c;
  }
  /**
   * 표를 복사해 **몸통 행**을 [from..to](1부터) 만 남긴다. 머리글은 그대로 둔다.
   * ⚠rowspan 이 걸린 묶음 칸은 잘리면 칸 수가 어긋난다 — 자른 조각에서는 rowspan 을 접는다.
   */
  function cutRows(src, from, to){
    var c = src.cloneNode(true);
    var body = c.querySelector('tbody'); if (!body) return c;
    var rows = Array.prototype.slice.call(body.rows);
    // ★조각이 블록 **중간**에서 시작하면 그 조각에 블록 이름이 없다 — 「어느 표의 행인지」가 사라진다.
    //   ⇒ 이 조각 앞쪽에서 가장 가까운 띠를 찾아 **맨 위에 다시 얹는다.**
    var carry = null;
    for (var k = 0; k < from - 1 && k < rows.length; k++) {
      if (rows[k].classList.contains('blk')) carry = rows[k];
    }
    if (carry && !rows[from - 1].classList.contains('blk')) {
      body.insertBefore(carry.cloneNode(true), rows[from - 1]);
      rows = Array.prototype.slice.call(body.rows);
      to++; // 얹은 줄만큼 뒤로 민다 — 안 밀면 조각마다 한 줄씩 사라진다
    }
    rows.forEach(function(tr, i){ if (i + 1 < from || i + 1 > to) tr.parentNode.removeChild(tr); });
    // ★조각 **끝**에 남은 띠는 걷어낸다 — 아래에 아무 행도 없는 블록 머리만 찍힌다(빈 제목).
    //   다음 조각이 그 띠를 다시 얹으므로 잃는 것은 없다.
    while (body.rows.length && body.rows[body.rows.length - 1].classList.contains('blk')) {
      body.deleteRow(body.rows.length - 1);
    }
    // 남은 조각 안에서 넘치는 rowspan 을 줄인다
    var left = body.rows.length;
    Array.prototype.forEach.call(body.rows, function(tr, i){
      Array.prototype.forEach.call(tr.cells, function(td){
        if (td.rowSpan > 1 && i + td.rowSpan > left) td.rowSpan = left - i;
      });
    });
    return c;
  }

  window.ckPrint = function(){
    if (!FORM) { _alertBox('서식을 먼저 고르세요.', {icon:'⚠️'}); return; }
    // ★인쇄는 화면 격자를 그대로 옮긴다 — 따로 만들면 화면과 종이가 갈린다
    var src = document.querySelector('#ckGridWrap table.gr');
    if (!src) { _alertBox('표가 없습니다.', {icon:'⚠️'}); return; }
    var t = src.cloneNode(true);
    // 입력칸은 값만 남긴다(종이에 네모를 찍지 않는다)
    t.querySelectorAll('input').forEach(function(el){
      var td = el.parentNode, isHd = td.classList.contains('hd');
      // 대장의 글자 칸은 종이에서도 왼쪽 정렬 — 이름·사유가 가운데 오면 읽기 나쁘다
      var isTxt = el.classList.contains('ltxt');
      td.textContent = String(el.value || '');
      if (isHd || isTxt) td.className = 'l';
    });
    t.querySelectorAll('th.hd').forEach(function(el){ el.className = 'l'; });

    // ★인쇄 배치 — N칸(행)씩 끊는다. 조각이 2개일 수도, 5개일 수도 있다(욕창예방은 7일씩 5쪽).
    var sp = splitOf(), grid;
    if (!sp) {
      grid = t.outerHTML;
    } else if (sp.dir === 'C') {
      // 열을 끊어 **위아래**로. 마지막 조각은 남는 만큼만(2월이면 16~28).
      grid = splitRanges(prdCells().length, sp.n).map(function(r){
        return cutCols(t, r.from, r.to).outerHTML;
      }).join('<div style="height:7px;"></div>');
    } else {
      // 행을 끊어 **좌우**로. 머리글은 조각마다 복사된다(cutRows 가 thead 를 남긴다).
      var nrow = t.querySelectorAll('tbody tr').length;
      grid = '<div class="splitrow">' + splitRanges(nrow, sp.n).map(function(r){
        return '<div class="splitcol">' + cutRows(t, r.from, r.to).outerHTML + '</div>';
      }).join('') + '</div>';
    }

    // ★기간 표기는 주기를 따른다 — 「2026년 8월 3주차」·「2026년 하반기」
    var yy = gel('ckYear').value;
    var prdTxt = docPrdLabel({ prdgb: prd(), prdno: (prdNos().length ? gel('ckPrdNo').value : ''),
                               inmm: (usesMm() ? gel('ckMm').value : '') });
    var meta = '<div class="meta"><span><b>병동</b> ' + esc(val('f_wardNm') || '') + '</span>' +
               '<span><b>기간</b> ' + esc(yy) + '년 ' + esc(prdTxt) + '</span>';
    var nms = (FORM.headnms || '').split(',').map(function(s){ return s.trim(); }).filter(function(s){ return s; });
    nms.slice(0, HEAD_MAX).forEach(function(nm, i){
      var v = val('f_head' + (i + 1));
      if (v) meta += '<span><b>' + esc(nm) + '</b> ' + esc(v) + '</span>';
    });
    meta += '</div>';

    var legend = '';
    if (FORM.axisgb === 'EQUIP_DAY' && ITEMS.length)
      legend = '<div class="box"><b>점검항목</b> &nbsp;' +
               ITEMS.map(function(r, i){ return (i + 1) + '. ' + esc(r.itemnm); }).join(' &nbsp; ') + '</div>';
    var guide = FORM.guidetxt ? ('<div style="font-size:10px;text-align:right;margin-bottom:3px;">' + esc(FORM.guidetxt) + '</div>') : '';

    var tail = '';
    if (FORM.noteyn === 'Y') tail += '<div class="box"><b>특이사항</b><br>' + esc(val('f_noteTxt')) + '</div>';
    if (FORM.fixyn === 'Y')  tail += '<div class="box"><b>수리날짜 및 고장 발생 내용</b><br>' + esc(val('f_fixTxt')) + '</div>';
    if (FORM.foottxt)        tail += '<div style="font-size:9px;margin-top:4px;text-align:left;">' + esc(FORM.foottxt) + '</div>';
    if (FORM.signline) {
      tail += '<div class="sig">' + String(FORM.signline).split(',').map(function(s){
                return '<span>' + esc(s.trim()) + ' _____________ (인)</span>'; }).join('') + '</div>';
    }

    var body = apprHtml() + '<div class="h1">' + esc(FORM.formnm) + '</div><div style="clear:both;"></div>' +
               meta + legend + guide + grid + tail;

    var title = (FORM.formnm + '_' + yy + prdTxt + '_' + (val('f_wardNm') || '') + '_' + HOSP_NM).replace(/[\\\/:*?"<>|]/g, '-');
    var w = window.open('', '_blank', 'width=1200,height=900');
    if (!w) { _alertBox('팝업이 차단되어 인쇄창을 열지 못했습니다.<br>주소창 오른쪽의 팝업 차단을 허용해 주세요.', {icon:'⚠️'}); return; }
    w.document.open();
    w.document.write('<!doctype html><html lang="ko"><head><meta charset="utf-8"><title>' + esc(title) +
      '</title><style>' + PRINT_CSS + '</style></head><body>' + body + '</body></html>');
    w.document.close();
    w.focus();
    setTimeout(function(){ try { w.print(); } catch (e) { } }, 300);
  };

  /**
   * ★★데이터 추출 — 점검표를 전산화한 뜻이 여기 있다.
   *   격자를 **평면 한 줄씩** 받아 CSV 로 내려준다. 축이 무엇이든 열은 늘 같다 :
   *     서식 · 부서 · 연 · 월 · 병동 · 항목 · 묶음 · 일 · 값
   *   ⇒ 엑셀 피벗으로 「이 달 부적합 건수」·「항목별 미점검」이 바로 나온다.
   *   ★값이 O/X 로 정규화되어 저장되기 때문에 세어진다(서버 normChk).
   */
  window.ckExtract = function(){
    var yy = gel('ckYear').value;
    _confirmBox({
      msg: '<b>' + esc(yy) + '년</b> 점검 자료를 CSV 로 내려받습니다.<br><br>' +
           '<div style="text-align:left;font-size:12.5px;">' +
           '<label><input type="radio" name="exsc" value="F" checked> 지금 고른 서식만' +
           (FORM ? (' <span style="color:#6b7c86;">(' + esc(FORM.formnm) + ')</span>') : '') + '</label><br>' +
           '<label><input type="radio" name="exsc" value="D"> 이 부서 전체</label><br>' +
           '<label><input type="radio" name="exsc" value="A"> 전 서식</label></div>',
      icon:'📊', okText:'내려받기',
      onOk: function(){
        var sc = (document.querySelector('input[name=exsc]:checked') || {}).value || 'F';
        var q = { inYear: yy };
        if (sc === 'F') { if (!FORM) { _alertBox('서식을 먼저 고르세요.', {icon:'⚠️'}); return; } q.formId = FORM.formid; }
        if (sc === 'D') q.deptCd = val('ckDept');
        post('<c:url value="/qps/chkExtract.do"/>', q).then(function(res){
          var rows = res.rows || [];
          if (!rows.length) { _alertBox('내려받을 자료가 없습니다.<br>먼저 점검표를 저장해 주세요.', {icon:'⚠️'}); return; }
          // ★'일' 이 축마다 뜻이 다르다 — ITEM_DAY/EQUIP_DAY=일, ITEM_MONTH=월, LIST=행번호,
          //   ITEM_COL=**열번호**. 머리글에 '일/행/열'로 적고 「축」열을 함께 내린다.
          //   안 그러면 대장의 1,2,3 을 1일,2일,3일로 읽는다(엑셀에서는 되돌릴 길이 없다).
          // ★ITEM_COL 은 번호만으로는 뜻이 없어 서버가 **열 이름**을 함께 준다(colnm).
          // ★「표」 = 행 블록 이름(대장에 표가 여럿일 때). 이게 없으면 「3번째 사람」이
          //   어느 표의 3번째인지 CSV 에서 사라진다 — 오류 없이 조용히 뜻만 잃는다.
          var head = ['서식코드','서식명','부서','축','연도','월','병동','표','항목','묶음','설명','단위','열','일/행/열','값'];
          function c(v){
            var s = (v == null) ? '' : String(v);
            return /[",\n]/.test(s) ? ('"' + s.replace(/"/g, '""') + '"') : s;
          }
          var csv = head.join(',') + '\n' + rows.map(function(r){
            return [r.formid, r.formnm, r.deptcd, (AXIS_NM[r.axisgb] || r.axisgb), r.inyear, r.inmm, r.wardnm,
                    r.blknm, r.itemnm, r.grpnm, r.desctxt, r.unitnm, r.colnm, r.dayno, r.val].map(c).join(',');
          }).join('\n');
          // ★엑셀이 UTF-8 CSV 를 못 알아보고 한글을 깬다 — BOM 을 붙여야 한다
          var blob = new Blob(['﻿' + csv], { type:'text/csv;charset=utf-8;' });
          var a = document.createElement('a');
          a.href = URL.createObjectURL(blob);
          a.download = ('점검표_' + yy + '_' + (sc === 'F' ? FORM.formnm : (sc === 'D' ? '부서' : '전체')) +
                        '_' + HOSP_NM).replace(/[\\\/:*?"<>|]/g, '-') + '.csv';
          document.body.appendChild(a); a.click();
          setTimeout(function(){ URL.revokeObjectURL(a.href); a.remove(); }, 1000);
          var s = res.summary || [];
          var ng = s.reduce(function(t, x){ return t + Number(x.ngcnt || 0); }, 0);
          _toast(rows.length + '줄을 내려받았습니다.' + (ng ? (' 부적합(X) ' + ng + '건.') : ''), 'ok');
        }).catch(err);
      } });
  };

  // 월을 바꾸면 날 수가 달라진다 — 값은 지우지 않고 표만 다시 그린다
  gel('ckMm').addEventListener('change', function(){
    var c = collect();
    renderGrid(c.vals, c.rows);
  });

  $(function(){
    // ★[서식 관리]에서 넘어왔으면 그 서식으로 연다. 사용 목록에서 꺼져 있으면 못 고르므로 안내한다.
    var want = (gel('ckForm').getAttribute('data-init') || '').trim();
    ckBase().then(function(){
      var sel = gel('ckForm');
      if (want && FORMS.some(function(f){ return f.formid === want; })) sel.value = want;
      else if (want) {
        _alertBox('그 서식은 <b>이 병원 사용 목록에 꺼져</b> 있어 작성 화면에 나오지 않습니다.<br>' +
                  '[서식 관리]의 체크를 켜고 <b>[사용 저장]</b> 을 눌러 주세요.', {icon:'⚠️'});
      }
      if (FORMS.length && !sel.value) sel.value = FORMS[0].formid;
      return ckBase();
    }).then(function(){ renderHead({}); renderGrid([], []); });
  });
})();
</script>
</div><%-- /#qpsChk --%>
</div><%-- /.dashboard-wrapper --%>
