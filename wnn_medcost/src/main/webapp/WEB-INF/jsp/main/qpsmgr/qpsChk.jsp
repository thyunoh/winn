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
  /* ── 탭 · 글자 크기 (2026-08-15 사용자 요청) — safeRpt 와 같은 모양·같은 규칙 ──
       ★탭은 **사진칸이 있는 서식에서만** 나온다(없으면 가를 것이 없다).
       ★글자 크기는 `zoom` — CSS 가 px 라 뿌리 font-size 로는 격자가 안 따라 커진다. */
  #qpsChk .ck-tabs{ display:flex; gap:6px; margin:0 0 10px; flex-wrap:wrap; }
  #qpsChk .ck-tab{ border:1px solid #cfd9e0; background:#f4f7f9; color:#43555f; border-radius:8px 8px 0 0;
                   padding:7px 16px; font-size:13.5px; font-weight:700; cursor:pointer; }
  #qpsChk .ck-tab:hover{ background:#e9eff3; }
  #qpsChk .ck-tab.on{ background:#1f5a4b; border-color:#1f5a4b; color:#fff; }
  #qpsChk .ck-zoom{ display:inline-flex; gap:4px; align-items:center; margin-left:2px; }
  #qpsChk .ck-zoom button{ border:1px solid #cfd9e0; background:#fff; color:#43555f; border-radius:6px;
                           padding:4px 9px; font-size:13px; font-weight:700; cursor:pointer; }
  #qpsChk .ck-zoom button:hover{ background:#eef3f6; }
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
  <%-- ★고정 띠(SPAN_TXT) — 격자를 대신하는 미리 찍힌 문구(「매월 1회 실시」). 입력칸이 아니다.
       입력칸과 **눈으로 갈려야** 한다 — 흐린 바탕 + 가운데 글. --%>
  #qpsChk table.gr td.spanfix{ background:#f4f6f8; color:#43555f; text-align:center;
      padding:4px 8px; letter-spacing:-0.2px; white-space:normal; }
  <%-- ★기간 열 머리글 입력 행(890) — 주차 날짜·월별 점검자. 머리글과 몸통 사이의 한 줄이라
       살짝 다른 바탕으로 「서식의 일부」처럼 보이게 한다. --%>
  #qpsChk table.gr tr.prdh > td{ background:#f7fafb; }
  #qpsChk table.gr tr.prdh input{ font-size:11px; color:#33474f; }
  #qpsChk table.gr td input{ width:100%; min-width:30px; border:none; background:transparent;
      text-align:center; padding:4px 2px; font-size:12px; }
  <%-- ★문서가 열 이름을 정하는 서식은 **머리글이 입력칸**이다(MSDS 물질명 · 소방 층·병동).
       머리글인 티가 나야 값 칸과 헷갈리지 않는다 — 굵게 + 밑줄만. --%>
  #qpsChk table.gr th input{ width:100%; min-width:60px; border:none; border-bottom:1px dashed #9fb4bd;
      background:transparent; text-align:center; padding:3px 2px; font-size:12px; font-weight:700;
      color:#1f3d4d; }
  #qpsChk table.gr th input:focus{ background:#eaf5f0; outline:1px solid #8fc3b2; }
  #qpsChk table.gr td input:focus{ background:#eaf5f0; outline:1px solid #8fc3b2; }
  #qpsChk table.gr td.hd input{ text-align:left; }
  <%-- 대장(LIST)의 글자 칸 — 이름·사유가 들어가므로 가운데 정렬이면 읽기 나쁘다 --%>
  #qpsChk table.gr td input.ltxt{ text-align:left; padding-left:6px; }
  #qpsChk table.gr tr.sign td, #qpsChk table.gr tr.sign th{ background:#fbfcfd; }
  #qpsChk .sun{ color:#c0392b; } #qpsChk .sat{ color:#2c6fb5; }
  #qpsChk .hol{ color:#c0392b; text-decoration:underline dotted; }   /* 공휴일(2026-09-02) — 이름은 title 로 */
  /* 셀 고정문(2026-09-02) — 칸 위 글 + 아래 입력칸. 평가표라 글이 길어 칸이 넓고 줄바꿈된다 */
  #qpsChk table.gr td.hasct{ vertical-align:top; min-width:120px; max-width:170px; padding:3px 3px 2px; cursor:pointer; }
  #qpsChk table.gr td.hasct .ck-ct{ font-size:11px; line-height:1.3; color:#43555f; white-space:normal; text-align:left; margin-bottom:2px; }
  #qpsChk table.gr td.hasct input{ text-align:center; }
  #qpsChk .ck-excl{ color:#8a4b12; background:#fff4e5; border:1px solid #f1d9b5; border-radius:4px; padding:2px 8px; font-size:12px; }
  <%-- ★편의 기능 띠 + 손짓 표시 (2026-09-02, SUNWOO 원본 소스 대조로 이식 — 아래 JS 「편의 기능」 절 참고).
       머리글·행 머리에 손 모양을 줘 「누를 수 있다」를 알린다. 이름 칸 빈 행(rowoff)은 흐리게. --%>
  #qpsChk .ck-tools{ display:flex; gap:8px; align-items:center; flex-wrap:wrap; margin-bottom:6px; font-size:12px; color:#556570; }
  #qpsChk .ck-tools .ck-chk{ display:inline-flex; align-items:center; gap:4px; cursor:pointer; user-select:none; font-weight:600; }
  #qpsChk .ck-tools .ck-chk input{ margin:0; }
  #qpsChk .ck-tools .ck-hint{ color:#8a99a3; margin-left:2px; }
  #qpsChk .ck-tools .ck-hint b{ color:#43555f; }
  #qpsChk table.gr thead th[data-day], #qpsChk table.gr thead th[data-col],
  #qpsChk table.gr tbody th.hd, #qpsChk table.gr tbody td.hd, #qpsChk table.gr tr.sign th.hd{ cursor:pointer; }
  #qpsChk table.gr tr.rowoff td input[data-r]{ background:#f3f5f7; color:#9aa7ae; }


  #qpsChk .ck-form{ display:grid; grid-template-columns:110px 1fr 110px 1fr; gap:9px 10px; align-items:start; }
  #qpsChk .ck-form .lb{ font-size:12.5px; font-weight:700; color:#43555f; padding-top:8px; }
  #qpsChk .ck-form .full{ grid-column:2 / -1; }
  #qpsChk .ck-form input{ width:100%; }

  /* 사진칸(2026-08-15) — 서식 PHOTO_NMS 만큼 칸이 열린다(최대 12). safeRpt 사진과 같은 조작감 */
  #qpsChk .ph-grid{ display:grid; grid-template-columns:repeat(auto-fill, minmax(220px, 1fr)); gap:8px; }
  #qpsChk .ph-cell{ position:relative; border:1.5px dashed #cfd8e0; border-radius:8px; background:#fafcfd;
      min-height:130px; display:flex; align-items:center; justify-content:center; cursor:pointer; overflow:hidden; }
  #qpsChk .ph-cell:hover{ border-color:#8fc3b2; background:#f7fbf9; }
  #qpsChk .ph-cell.has{ border-style:solid; background:#fff; }
  #qpsChk .ph-cell img{ max-width:100%; max-height:180px; display:block; }
  #qpsChk .ph-cell .empty{ color:#9aa7ae; font-size:12.5px; text-align:center; line-height:1.7; }
  #qpsChk .ph-cell .no{ position:absolute; left:6px; top:5px; font-size:11px; font-weight:800; color:#8a99a3;
      background:rgba(255,255,255,.85); border-radius:8px; padding:1px 7px; max-width:85%; overflow:hidden;
      text-overflow:ellipsis; white-space:nowrap; }
  #qpsChk .ph-cell .rm{ position:absolute; right:5px; top:5px; border:1px solid #e0b4b4; background:#fff;
      color:#b23b3b; border-radius:6px; font-size:11.5px; padding:2px 8px; cursor:pointer; }
</style>

<div class="ck-head">
  <div class="ck-title"><span class="ck-dot"></span><span id="ckTitle">점검표</span>
    <span class="ck-sub" id="ckAxisNm"></span></div>
  <span class="ck-hosp" id="ckHosp">🏥 <c:out value="${hospNm}" default="병원 미확인"/></span>
  <div class="ck-spacer"></div>
  <button type="button" class="ck-btn" onclick="ckSave();">저장</button>
  <button type="button" class="ck-btn ghost" onclick="ckPrint();">🖨 인쇄(A4 가로)</button>
  <%-- 글자 크기 — 이 PC 이 브라우저에만 저장된다 --%>
  <span class="ck-zoom">
    <button type="button" onclick="ckZoom(-1);" title="글자 작게">가－</button>
    <button type="button" onclick="ckZoom(1);"  title="글자 크게">가＋</button>
    <button type="button" onclick="ckZoom(0);"  title="처음 크기로">↺</button>
  </span>
  <button type="button" class="ck-btn ghost" onclick="ckExtract();">📊 데이터 추출</button>
  <button type="button" class="ck-btn warn" id="ckDelBtn" onclick="ckDel();" style="display:none;">삭제</button>
  <span class="ck-sub" id="ckStat"></span>
  <span style="flex:0 0 60px;"></span>
</div>

<div class="ck-card">
  <div class="ck-bar">
    <%-- ★부서 먼저 — 서식이 130종이 되면 부서로 걸러야 고를 수 있다 --%>
    <span style="font-size:12.5px; font-weight:700; color:#43555f;">부서</span>
    <%-- data-init = 사이드바 「부서별 점검표」에서 넘어온 부서코드(서버가 내려준다) --%>
    <select id="ckDept" style="width:auto;" onchange="ckPickDept();"
            data-init="<c:out value='${chkDeptCd}'/>"><option value="">전체</option></select>
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
    <%-- ★전월 복사 — **틀만** 가져온다(기기명·열 이름·상단 칸). 점검 결과는 안 가져온다.
         저장도 안 한다 — 깔아 주기만 하고 [저장]은 사람이 누른다. --%>
    <button type="button" class="ck-btn ghost" onclick="ckPrevSeed();" title="지난 문서의 기기명·열 이름·상단 칸과 서식이 지정한 자산 열만 가져옵니다(점검 결과는 가져오지 않습니다)">⧉ 전월 복사</button>
    <%-- ★월 생성 — 일 단위 서식만. 없으면 한 달에 [새로 작성]을 31번 눌러야 한다. --%>
    <button type="button" class="ck-btn ghost" id="ckMonthBtn" onclick="ckMonthGen();" style="display:none;">📅 이 달 전체 만들기</button>
  </div>
  <%-- ★탭 (2026-08-15) — 사진칸이 있는 서식에서만 나온다(ckTabSync). 없으면 가를 것이 없다. --%>
  <div class="ck-tabs" id="ckTabs" style="display:none;"></div>
  <div id="ckMainWrap">
  <div id="ckHeadWrap" class="ck-form" style="margin-bottom:10px;"></div>
  <div class="ck-guide" id="ckGuide" style="display:none;"></div>
  <div class="ck-legend" id="ckLegend" style="display:none;"></div>
  <%-- ★대장(LIST) 전용 — 행이 자유라 늘리고 줄이는 손잡이가 필요하다.
       ★표 **밖**에 둔다. 표 안에 두면 인쇄가 격자를 그대로 복사하므로 종이에 버튼이 찍힌다. --%>
  <%-- ★블록이 있으면 이 자리에 **블록마다** 손잡이가 깔린다(ckListBar 를 다시 그린다). --%>
  <div id="ckListBar" class="ck-bar" style="display:none; margin-bottom:6px;"></div>
  <%-- ★편의 기능 띠 (2026-09-02) — SUNWOO 원본 소스(ParentChartMulti.pas)의 사용자 기능을 격자에 얹은 것.
       단추 둘(전체 O · 전체 지움) + 토·일 제외 + 손짓 안내 한 줄. 서식을 고르면 나온다(applyFormUi).
       ★표 **밖**에 둔다 — 표 안에 두면 인쇄가 격자를 그대로 복사하므로 종이에 단추가 찍힌다(ckListBar 와 같은 이유). --%>
  <div id="ckTools" class="ck-tools" style="display:none;">
    <button type="button" class="ck-btn mini" onclick="ckAllOx('O');" title="빈 칸 전부에 O — 이미 적힌 칸은 그대로 둡니다">☑ 전체 O</button>
    <button type="button" class="ck-btn mini" onclick="ckAllOx('');" title="격자 값을 전부 비웁니다(묻고 합니다)">☐ 전체 지움</button>
    <label class="ck-chk" title="전체 O · 일괄 서명에서 토요일·일요일·공휴일 칸은 건너뜁니다"><input type="checkbox" id="ckExclWk" onchange="ckExclWkSave();"> 토·일·공휴일 제외</label>
    <button type="button" class="ck-btn mini" id="ckWeekBtn" style="display:none;" onclick="ckWeekFill(true);" title="주차 머리글에 그 달의 날짜 범위(월~일)를 넣습니다">주차 날짜 채움</button>
    <span id="ckHolBtnWrap" style="display:none;"><a href="/main/qpsHoliday.do" class="ck-sub" style="text-decoration:underline;" title="QPS ▸ 공통 ▸ 기준코드 ▸ 공휴일 관리 — 바로가기">공휴일 관리 →</a></span>
    <span class="ck-excl" id="ckExclNote" style="display:none;" title="서식 옵션 — 평가표라 O 를 찍으면 그 줄의 다른 O 가 지워집니다">한 줄에 O 하나</span>
    <span class="ck-hint">더블클릭 = 칸 <b>빈→O→X</b> · 날짜/열 머리 = <b>세로줄</b> · 항목 = <b>가로줄</b> · 사인 머리 = <b>일괄 서명</b> ·
      <b>Enter</b> = 오른쪽 복사 · <b>Ctrl+Enter</b> = 아래 복사 · <b>이름 빈 줄</b>은 흐리게 표시(입력은 됨) · 날짜 머리 <span class="hol">빨간 점선</span> = 공휴일</span>
  </div>
  <div class="gridwrap" id="ckGridWrap"><div class="ck-empty">서식을 고르세요.</div></div>

  <div id="ckNoteWrap" style="display:none; margin-top:10px;">
    <%-- ★칸 이름은 서식이 정한다(NOTE_NM) — 조치사항·기타 이상내용. 비면 「특이사항」. --%>
    <div id="ckNoteTitle" style="font-size:12.5px; font-weight:700; color:#43555f; margin-bottom:4px;">특이사항</div>
    <textarea id="f_noteTxt" rows="2"></textarea>
  </div>
  <div id="ckFixWrap" style="display:none; margin-top:8px;">
    <div style="font-size:12.5px; font-weight:700; color:#43555f; margin-bottom:4px;">수리날짜 및 고장 발생 내용</div>
    <textarea id="f_fixTxt" rows="2"></textarea>
  </div>
  </div><%-- /#ckMainWrap — 여기까지가 「점검표」 탭 --%>
  <%-- ★사진칸(2026-08-15) — 서식 PHOTO_NMS 가 칸 이름·수를 정한다(납가운 증빙사진·봉인스티커 월별).
       칸 클릭=업로드, 같은 칸 재업로드=교체. safeRpt 사진과 같은 장치. --%>
  <div id="ckPhotoWrap" style="display:none; margin-top:10px;">
    <div style="font-size:12.5px; font-weight:700; color:#43555f; margin-bottom:4px;">사진첨부
      <span style="font-weight:500; color:#8a99a3;">— 칸을 누르면 사진을 올립니다 · 인쇄물에 함께 실립니다</span></div>
    <div class="ph-grid" id="ckPhotoGrid"></div>
    <input type="file" id="ckPhotoInp" accept="image/*" style="display:none;">
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
  /* ═══ 고정 띠 — 격자를 대신하는 미리 찍힌 문구 (2026-08-12) ═══
     연간 시설물·소방 계획의 「매월 1회 실시」, 소방시설 월 점검표의 「자동화재탐지 설비와 연동」.
     항목의 SPAN_TXT 에 글이 있으면 그 행의 격자가 **입력칸이 아니라 그 글 한 칸**이 된다 —
     12칸을 열어 두면 원본에 없던 「점검할 칸」이 생기고, ***「매월 실시」라고 못 박은 것을
     병원이 매달 O 를 찍어야 하는 것으로 바꾼다.*** 뜻을 지키는 장치다.
     ★SPAN_ALL_YN='Y' 면 띠가 **뒤 칸(POST_COLS)까지** 덮는다 — 소방시설 월 점검표는 상태 칸도 덮고,
       연간 계획 둘은 예산 칸을 남긴다. 근거 3종이 정확히 둘로 갈렸다. */
  function spanAll(){ return FORM && FORM.spanallyn === 'Y'; }
  /** 특이사항 칸의 이름 — 서식이 정한다(조치사항·기타 이상내용). 비면 지금까지처럼 「특이사항」. */
  function noteNm(){ return (FORM && String(FORM.notenm || '').trim()) || '특이사항'; }
  /* ═══ 기간 열 머리글 입력 행 (2026-08-12) ═══
     CCTV·가스보일러의 주차 밑 「-」 칸(주차 날짜 범위), 소화기 연대장의 월별 「점검자」.
     서식이 아니라 **문서가 값을 적는** 한 줄이라 셀로 저장한다 — 예약 행 890(사인 900 바로 앞).
     ★기간이 **열**이고 항목이 **행**인 두 축만(서버 chkFormSave 의 prdHeadOk 와 같은 판단). */
  var PRDH_NO = 890;
  function prdHeadOn(){
    var a = axis();
    return FORM && FORM.prdheadyn === 'Y' && (a === 'ITEM_DAY' || a === 'ITEM_MONTH');
  }
  /** 격자 양옆에 몇 칸이 붙나 — 빈 줄·사인 행의 `colspan` 을 맞추는 데 쓴다. */
  function sideCnt(){ return (descNm() ? 1 : 0) + preCols().length + postCols().length; }

  /* ═══ 행 묶음을 **문서가 정하는** 서식 (2026-08-12) ═══
     응급 약품 점검 기록부 · 소화기 관리대장(연) · 월별비치의약품 — 3종.
     판정 문서가 `EQUIP_MONTH` 라 부르던 것인데 ***새 축이 아니었다*** :
       12월 열은 ITEM_MONTH 에, 하위 항목(수량·유효기간·파손유무)은 **행 그룹**에 이미 있고,
       없던 것은 **묶음 이름을 누가 정하나** 하나뿐이었다. ⇒ `ROW_SRC='D'`.
     ★행 번호는 **행 블록과 같은 규칙** — `묶음×1000 + 항목`. 규칙이 하나면 기억할 것도 하나다.
     ★묶음 이름은 `TBL_QPS_CHK_ROW`(기기명과 같은 표)에 담는다 — 세 번째로 뒤집어 쓰는 장치다. */
  function docRow(){
    if (!FORM || FORM.rowsrc !== 'D') return false;
    var a = axis();
    return a === 'ITEM_DAY' || a === 'ITEM_MONTH' || a === 'ITEM_COL';
  }
  /** 묶음을 몇 개 깔까 — 서식의 EQUIP_CNT. ⚠이 칸은 축마다 뜻이 넷이다(기기·행·열·**묶음**). */
  function docGrpCnt(){ return Math.max(1, Math.min(50, Number((FORM && FORM.equipcnt) || 10))); }

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
  function prdCells(kk){
    var k = kk || kind(), out = [], i;
    // ★'1' = 한 칸. 주기 복합의 「매월」 구간이 이것이다 — 그 달 전체가 칸 하나다(2026-08-14)
    if (k === '1') return [{ no:1, label:'', cls:'' }];
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
  /* ═══ 기간 세분 — 기간 칸 **안**의 하위 칸 (2026-08-12) ═══
     근거 8종. `D·E·N`(근무조) · `10시·15시` · `상·중·하` · `15일·30일` — ***값이 제각각이라
     고정 목록으로는 안 된다.*** 그래서 서식이 이름을 정한다(`PRD_SUB`).
     ★`PRD_KIND` 가 「기간이 무엇인가」를 정했듯 `PRD_SUB` 는 「그 안을 몇으로 쪼개나」를 정한다.
     ★번호는 **기간×10 + 쪽** — 쪼개지는 쪽이 열이든 행이든 규칙은 하나다.
       ⚠최대 9쪽. 그리고 ***쓰던 서식에 나중에 켜면 옛 값이 어긋난다***(11 이 「11일」에서 「1일 2쪽」이 된다). */
  function prdSubs(){
    if (!FORM || !FORM.prdsub) return [];
    return String(FORM.prdsub).split(',').map(function(s){ return s.trim(); })
             .filter(function(s){ return s; }).slice(0, 9);
  }
  /** 쪼갠 칸까지 펼친 목록. `prd` 는 원래 기간 번호(인쇄 나누기가 이걸 본다).
   *  ★`kk`(묶음의 기간축)를 주면 <b>기간 세분을 적용하지 않는다</b> — 주기 복합과 PRD_SUB 를
   *    같이 쓰는 근거 서식이 없다. 섞으면 열 번호(기간×10+쪽)가 묶음마다 달라져 값이 어긋난다. */
  function prdFlat(kk){
    var base = prdCells(kk), sub = kk ? [] : prdSubs(), out = [];
    if (!sub.length) return base.map(function(c){ return { no:c.no, prd:c.no, label:c.label, cls:c.cls, sub:'' }; });
    base.forEach(function(c){
      sub.forEach(function(s, j){
        out.push({ no: c.no * 10 + (j + 1), prd: c.no, label: c.label, cls: c.cls, sub: s });
      });
    });
    return out;
  }

  /** 기간 축의 머리글 이름 — 표 왼쪽 위 모서리에 적는다. */
  function prdHeadNm(kk){
    var k = kk || kind();
    return k === '1' ? '' : k === 'W' ? '요일' : k === 'N' ? '주차' : k === 'M' ? '월' : k === 'Q' ? '분기' : '일';
  }

  /* ═══ 주기 복합 — 묶음마다 기간 축이 다른 격자 (2026-08-14) ═══
     근거 10종(진단검사 기기 점검표) : 매일 7행×1~31일 / 매주 5행×1~5주 / 매월 4행×한 칸이
     ***한 장짜리 종이에 세로로 3벌*** 붙어 있다. 판독 : QPS_서식판독_진단검사_2026-08-14.md

     ★새 축을 만들지 않았다 — **묶음 이름은 이미 항목의 GRP_NM 에 있고**(v2 행 그룹),
       없던 것은 「그 묶음이 어떤 기간으로 뻗는가」 하나뿐이라 그것만 서식이 정한다.
         GRP_PRD = '매일>D,매주>N,매월>1'      묶음명 > 기간축
       문법은 COL_NMS 의 `묶음>열`·ROW_BLKS 의 `이름>행수` 와 같은 가족이다.
     ★기간축 글자는 PRD_KIND 와 같다(D W N M Q) + **'1'=한 칸**. 두 곳에서 다른 뜻이면 반드시 헷갈린다.
     ⚠비면 아무것도 안 바뀐다 — 기존 서식 177종은 종전대로 격자 한 벌이다. */
  function grpPrdList(){
    if (!FORM || !FORM.grpprd) return [];
    return String(FORM.grpprd).split(',').map(function(s){
      var t = s.split('>');
      var nm = String(t[0] || '').trim();
      var k  = String(t[1] || '').trim().toUpperCase();
      if ('DWNMQ1'.indexOf(k) < 0) k = 'D';       // 못 알아볼 축은 일 격자로 — 화면이 비지 않게
      return nm ? { g: nm, k: k } : null;
    }).filter(function(x){ return x; });
  }
  /** 주기 복합으로 그릴 것인가 — 기간이 열이고 항목이 행인 두 축만(서버 grpPrd 범위와 같다). */
  function grpPrdOn(){
    var a = axis();
    return (a === 'ITEM_DAY' || a === 'ITEM_MONTH') && !docRow() && grpPrdList().length > 0;
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
  function sideTd(r, g, back, rowNo){
    // ⚠**행 번호를 밖에서 받아야 한다.** `r.sort` 로 두면 묶음을 문서가 정하는 서식에서
    //   묶음이 열여섯이어도 앞/뒤 칸이 **전부 같은 행 번호**를 써서 ***한 칸에 겹쳐 쓴다.***
    //   (2026-08-12 검증에서 실제로 잡았다 — 「비치량」이 16개 약품 모두 row 1 이었다)
    var rw = (rowNo == null) ? (r ? r.sort : 0) : rowNo;
    if (back) {
      return postCols().map(function(nm, j){
        return r ? cell(rw, POST_BASE + j + 1, g(rw, POST_BASE + j + 1), 'ltxt') : '<td></td>';
      }).join('');
    }
    var out = '';
    if (descNm()) out += '<td class="sidetxt">' + (r ? esc(r.desctxt || '') : '') + '</td>';
    return out + preCols().map(function(nm, j){
      return r ? cell(rw, PRE_BASE + j + 1, g(rw, PRE_BASE + j + 1), 'ltxt') : '<td></td>';
    }).join('');
  }

  /** ★표를 그리는 곳은 여기 하나다. 서식이 늘어도 여기만 돈다. */
  function renderGrid(vals, rows, cols){
    var box = gel('ckGridWrap');
    if (!FORM) { box.innerHTML = '<div class="ck-empty">서식을 고르세요.</div>'; return; }
    var V = {};
    (vals || []).forEach(function(v){ V[v.rowno + '_' + v.colno] = v.val; });
    var RN = {};
    (rows || []).forEach(function(r){ RN[r.rowno] = r.rownm; });
    var CN = {};
    (cols || []).forEach(function(c){ CN[c.colno] = c.colnm; });
    function g(r, c){ return V[r + '_' + c] || ''; }

    var a = axis(), h = '', i, d;
    // ★기간 칸은 한 곳(prdCells)에서만 센다 — 머리글·셀이 따로 세면 칸 수가 어긋난다
    var PC = prdCells(), nCol = PC.length;

    if (a === 'ITEM_COL') {
      // ★항목 행 × 날짜가 아닌 고정 열. 열 이름은 서식이 정한다(COL_NMS).
      //   행 그룹은 ITEM_DAY 와 같은 장치를 그대로 쓴다 — 이 축의 서식은 대부분 묶음이 있다.
      // ★열 이름을 **문서가 정하는** 서식이 있다(2026-08-12) — MSDS 물질명 · 소방 층·병동.
      //   `EQUIP_DAY` 의 기기명과 같은 일이 열에서 벌어진 것이라 장치를 뒤집어 쓴다.
      //   이 경우 서식의 COL_NMS 는 안 쓴다 — 칸 수만 서식(EQUIP_CNT)이 정한다.
      var docCol = (FORM.colsrc === 'D');
      var cd = colDefs();
      if (docCol) {
        var nc = Math.max(1, Math.min(50, Number(FORM.equipcnt || 10)));
        cd = [];
        for (i = 1; i <= nc; i++) cd.push({ g:'', n:'' });
      }
      if (!cd.length) cd = [{ g:'', n:'점검결과' }];   // 열을 안 적었으면 한 칸이라도 그린다
      var cg = [], cl = null;
      cd.forEach(function(c){
        if (cl && cl.g === c.g && c.g) cl.n++; else { cl = { g:c.g, n:1 }; cg.push(cl); }
      });
      var hasCg = cg.some(function(x){ return x.g; });
      // 행 묶음 — ★블록(BLK_NM)이 갈리면 묶음도 같이 끊는다. 안 끊으면 이웃 블록의
      //   같은 이름 묶음이 rowspan 으로 이어져 **묶음 칸이 띠를 뚫고 내려간다.**
      var ig = [], il = null;
      ITEMS.forEach(function(r){
        var gn = r.grpnm || '', bn = r.blknm || '';
        if (il && il.g === gn && il.b === bn) il.n++; else { il = { g:gn, b:bn, n:1 }; ig.push(il); }
      });
      // ★블록 두 단계(2026-08-12) — 항목의 BLK_NM 이 있으면 **그것이 가로 띠**가 되고
      //   GRP_NM 은 왼쪽 세로 칸으로 남는다(혼합형 공기조화설비 : 자연환기/기계환기 띠 + 환기시설 묶음).
      //   BLK_NM 이 없으면 옛 방식 그대로 — ROW_BLK_GB='B' 가 GRP_NM 을 띠로 그린다.
      var hasBk = ITEMS.some(function(r){ return String(r.blknm || '').trim(); });
      // ★행 묶음을 **가로 띠**로 그리는 서식이 있다(시설물 정기점검의 「약국」·「조리실」 등, 4종).
      //   담긴 자료는 똑같다 — GRP_NM 이다. ***그리는 방법만 다르다.***
      var band = !hasBk && (FORM.rowblkgb === 'B') && ig.some(function(x){ return x.g; });
      var hasIg = !band && ig.some(function(x){ return x.g; });

      var colTh = function(){
        return cd.map(function(c, k){
          // 문서가 정하는 열이면 머리글 자체가 **입력칸**이다(기기명 칸과 같은 자리)
          // data-col = 그 열의 data-c — 머리글 더블클릭으로 세로줄을 토글할 때 쓴다(2026-09-02)
          if (docCol) return '<th data-col="' + (k + 1) + '" style="min-width:96px;"><input data-cn="' + (k + 1) + '" value="' +
                             esc(CN[k + 1] || '') + '" placeholder="' + (k + 1) + '번"></th>';
          return '<th data-col="' + (k + 1) + '" style="min-width:78px;white-space:normal;">' + esc(c.n) + '</th>';
        }).join('');
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
      var ci = 0, cp = 0, prevBk = null;
      ITEMS.forEach(function(r){
        // ★블록 띠 — BLK_NM 이 바뀌는 자리에 표 폭을 가로지르는 머리 행. 묶음 칸까지 덮는다.
        var bn = String(r.blknm || '').trim();
        if (hasBk && bn && bn !== prevBk)
          h += '<tr class="blk"><td colspan="' + ((hasIg ? 1 : 0) + 1 + cd.length + sideCnt()) + '">' + esc(bn) + '</td></tr>';
        prevBk = bn;
        // 띠 표시 — 묶음이 바뀌는 자리에 표 폭을 가로지르는 머리 행을 넣는다
        if (band && cp === 0 && ig[ci].g) h += '<tr class="blk"><td colspan="' + (1 + cd.length + sideCnt()) + '">' + esc(ig[ci].g) + '</td></tr>';
        h += '<tr>';
        if (hasIg && cp === 0) h += '<th class="rgrp" rowspan="' + ig[ci].n + '">' + esc(ig[ci].g) + '</th>';
        h += '<th class="hd">' + esc(r.itemnm) + (r.unitnm ? (' (' + esc(r.unitnm) + ')') : '') + '</th>';
        h += sideTd(r, g);
        // ★고정 띠 — 문구가 있으면 격자(필요하면 뒤 칸까지)를 그 글 한 칸으로 덮는다. 입력칸이 아니다.
        var sp = String(r.spantxt || '').trim();
        if (sp) {
          h += '<td class="spanfix" colspan="' + (cd.length + (spanAll() ? postCols().length : 0)) + '">' + esc(sp) + '</td>';
          if (!spanAll()) h += sideTd(r, g, true);
          h += '</tr>';
        } else {
          // ★셀 고정문(2026-09-02, 보류서식 최종판정 §3 설계) — 열마다 미리 찍힌 글 + 그 아래 입력칸.
          //   인사고과 평가표(w15)의 10행 × 5열 = 50칸이 저마다 다른 글자. 쉼표로 열 수만큼, 빈 자리는 보통 칸.
          //   글자를 더블클릭해도 그 칸이 토글된다(아래 dblclick ①-2). 인쇄는 격자를 복사하므로 그대로 찍힌다.
          var ct = String(r.celltxts || '').split(',').map(function(s){ return s.trim(); });
          cd.forEach(function(c, k){
            var t = ct[k] || '';
            if (t) h += '<td class="hasct"><div class="ck-ct">' + esc(t) + '</div><input' + ((r.inputgb === 'CHECK') ? '' : ' class="ltxt"') +
                        ' data-r="' + r.sort + '" data-c="' + (k + 1) + '" value="' + esc(g(r.sort, k + 1)) + '"></td>';
            else h += cell(r.sort, k + 1, g(r.sort, k + 1), (r.inputgb === 'CHECK') ? '' : 'ltxt');
          });
          h += sideTd(r, g, true) + '</tr>';
        }
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
        if (rn >= SUB_ROW_BASE) return;   // ★격자 아래 자유행 표(9000대)는 대장 행 수와 무관하다
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
          return '<th data-col="' + r.sort + '" style="min-width:110px;white-space:normal;">' + esc(r.itemnm) +
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
        return ITEMS.map(function(r){ return '<th data-col="' + r.sort + '" style="min-width:88px;white-space:normal;">' + esc(r.itemnm) +
               (r.unitnm ? ('<br>(' + esc(r.unitnm) + ')') : '') + '</th>'; }).join('');
      };
      // 기간 세분이 있으면 왼쪽에 쪽 칸이 하나 더 선다 — 머리글도 그만큼 덮어야 칸수가 맞는다
      var dcs = prdSubs().length ? ' colspan="2"' : '';
      h += '<table class="gr"><thead>';
      if (hasGrp) {
        h += '<tr><th class="hd" rowspan="2"' + dcs + ' style="min-width:52px;">' + prdHeadNm() + '</th>' +
             grps.map(function(x){ return '<th colspan="' + x.n + '">' + esc(x.g) + '</th>'; }).join('') +
             '</tr><tr>' + itemTh() + '</tr>';
      } else {
        h += '<tr><th class="hd"' + dcs + ' style="min-width:52px;">' + prdHeadNm() + '</th>' + itemTh() + '</tr>';
      }
      h += '</thead><tbody>';
      // ★기간 세분 — 기간이 **행**인 축에서는 행이 쪼개진다(냉장고 기록지의 요일 × 10시/15시).
      //   기간 칸은 첫 쪽에서만 나오고 rowspan 으로 덮는다. 쪽 이름 칸이 그 옆에 선다.
      var DPF = prdFlat(), dSub = prdSubs().length;
      if (dSub) {
        DPF.forEach(function(pf, ix){
          h += '<tr>';
          if (ix % dSub === 0) h += '<td class="hd ' + pf.cls + '" data-day="' + pf.prd + '" style="text-align:center;" rowspan="' + dSub + '">' + esc(pf.label) + '</td>';
          h += '<td class="hd" style="text-align:center;min-width:44px;">' + esc(pf.sub) + '</td>';
          ITEMS.forEach(function(r){ h += cell(pf.no, r.sort, g(pf.no, r.sort)); });
          h += '</tr>';
        });
      } else {
      PC.forEach(function(pc){
        h += '<tr><td class="hd ' + pc.cls + '" data-day="' + pc.no + '" style="text-align:center;">' + esc(pc.label) + '</td>';
        ITEMS.forEach(function(r){ h += cell(pc.no, r.sort, g(pc.no, r.sort)); });
        h += '</tr>';
      });
      }
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

    } else if (grpPrdOn()) {
      // ═══ 주기 복합 — 묶음마다 기간 축이 다른 격자를 **한 벌씩** (2026-08-14) ═══
      //   종이가 한 장인데 격자가 세로로 3벌이고 기간이 서로 다르다(매일 31 / 매주 5 / 매월 1).
      //   ***한 표로는 못 그린다*** — 머리글의 열 수가 구간마다 달라서다. 그래서 표를 나눠 붙인다.
      h += grpPrdHtml(g);

    } else {
      // ITEM_DAY / ITEM_MONTH — 항목 행 × 일(또는 월) 열
      // ★행 그룹 — 이어지는 항목의 GRP_NM 이 같으면 왼쪽에 묶음 칸을 세운다(2단 행 머리글).
      //   실물 근거 : 카트및엘리베이터 청소소독(엘리베이터/카트 × 3항목).
      //   ***DAY_ITEM 의 열 묶음과 같은 자료(GRP_NM)를 쓴다*** — 축이 눕히기만 할 뿐 뜻은 하나다.
      var rg = [], rl = null;
      ITEMS.forEach(function(r){
        var gname = r.grpnm || '', bname = r.blknm || '';
        // ★블록이 갈리면 묶음도 끊는다(ITEM_COL 과 같은 이유 — rowspan 이 띠를 뚫으면 안 된다)
        if (rl && rl.g === gname && rl.b === bname) rl.n++; else { rl = { g:gname, b:bname, n:1 }; rg.push(rl); }
      });
      // ★블록 두 단계(BLK_NM) — 있으면 그것이 띠, GRP_NM 은 세로 칸(ITEM_COL 과 같은 장치)
      var hasBk = !docRow() && ITEMS.some(function(r){ return String(r.blknm || '').trim(); });
      // ★같은 GRP_NM 을 **가로 띠**로 그릴 수도 있다(ROW_BLK_GB='B') — ITEM_COL 과 같은 장치다
      var rband = !docRow() && !hasBk && (FORM.rowblkgb === 'B') && rg.some(function(x){ return x.g; });
      // ★묶음을 문서가 정하면 묶음 칸은 **언제나 있다**(거기에 이름을 적는다)
      var hasRg = docRow() || (!rband && rg.some(function(x){ return x.g; }));
      // ★기간 세분 — 기간 칸이 쪼개지면 머리글이 2단이 된다(날짜 줄 + 쪽 이름 줄)
      var PF = prdFlat(), hasSub = prdSubs().length > 0;
      h += '<table class="gr' + (hasRg ? ' hasrg' : '') + '"><thead><tr>' +
           (hasRg ? '<th class="rgrp"' + (hasSub ? ' rowspan="2"' : '') + '>묶음</th>' : '') +
           '<th class="hd"' + (hasSub ? ' rowspan="2"' : '') + '>점검 항목</th>' + sideTh(false, hasSub ? 2 : 1);
      if (hasSub) {
        // 윗줄 = 기간(colspan), 아랫줄 = 쪽 이름. data-day 는 **원래 기간 번호** — 인쇄 나누기가 이걸 본다
        PC.forEach(function(pc){
          h += '<th class="' + pc.cls + '" data-day="' + pc.no + '" colspan="' + prdSubs().length + '">' + esc(pc.label) + '</th>';
        });
        h += sideTh(true, 2) + '</tr><tr>';
        PF.forEach(function(pf){
          h += '<th class="' + pf.cls + '" data-day="' + pf.prd + '" style="min-width:30px;">' + esc(pf.sub) + '</th>';
        });
        h += '</tr>';
      } else {
        PC.forEach(function(pc){
          h += '<th class="' + pc.cls + '" data-day="' + pc.no + '" style="min-width:32px;">' + esc(pc.label) + '</th>';
        });
        h += sideTh(true) + '</tr>';
      }
      h += '</thead><tbody>';
      // ★기간 열 머리글 입력 행(890) — 주차의 날짜 범위·월별 점검자를 **문서가** 적는다.
      //   기간 세분이 있으면 한 기간이 여러 칸이므로 colspan 으로 덮는다(값은 기간마다 하나).
      //   data-day 를 달아야 인쇄 열-끊기가 이 행도 같이 자른다.
      if (prdHeadOn()) {
        h += '<tr class="prdh">' + (hasRg ? '<th class="rgrp"></th>' : '') +
             '<th class="hd">' + esc(String(FORM.prdheadnm || '').trim()) + '</th>' + sideTd(null, g);
        PC.forEach(function(pc){
          h += '<td data-day="' + pc.no + '"' + (hasSub ? (' colspan="' + prdSubs().length + '"') : '') + '>' +
               '<input data-r="' + PRDH_NO + '" data-c="' + pc.no + '" value="' + esc(g(PRDH_NO, pc.no)) + '"></td>';
        });
        h += sideTd(null, g, true) + '</tr>';
      }
      if (!ITEMS.length) h += '<tr><td class="hd" style="color:#8a99a3;">이 서식에 점검항목이 없습니다 — [서식 관리]에서 등록하세요.</td>' +
                              '<td colspan="' + (PF.length + sideCnt()) + '"></td></tr>';
      if (docRow()) {
        // ★묶음 이름을 문서가 적는다 — 묶음 칸이 **입력칸**이고, 그 아래로 서식의 항목이 되풀이된다.
        //   행 번호는 `묶음×1000 + 항목` (행 블록과 같은 규칙).
        for (var db = 1; db <= docGrpCnt(); db++) {
          ITEMS.forEach(function(r, k){
            h += '<tr>';
            if (k === 0) h += '<th class="rgrp" rowspan="' + Math.max(ITEMS.length, 1) + '">' +
                              '<input data-rn="' + db + '" value="' + esc(RN[db] || '') +
                              '" placeholder="' + db + '번"></th>';
            var drw = blkRowNo(db, r.sort);
            h += '<th class="hd">' + esc(r.itemnm) + (r.unitnm ? (' (' + esc(r.unitnm) + ')') : '') + '</th>';
            h += sideTd(r, g, false, drw);
            PF.forEach(function(pf){ h += cell(drw, pf.no, g(drw, pf.no), '', pf.prd); });
            h += sideTd(r, g, true, drw) + '</tr>';
          });
        }
      } else {
      var gi = 0, gpos = 0, rPrevBk = null;   // 지금 몇 번째 묶음인지 / 그 묶음 안에서 몇 번째 행인지
      ITEMS.forEach(function(r){
        // ★블록 띠(BLK_NM) — 바뀌는 자리에 표 폭을 가로지르는 머리 행. 묶음 칸까지 덮는다.
        var bn = String(r.blknm || '').trim();
        if (hasBk && bn && bn !== rPrevBk)
          h += '<tr class="blk"><td colspan="' + ((hasRg ? 1 : 0) + 1 + PF.length + sideCnt()) + '">' + esc(bn) + '</td></tr>';
        rPrevBk = bn;
        if (rband && gpos === 0 && rg[gi].g) h += '<tr class="blk"><td colspan="' + (1 + nCol + sideCnt()) + '">' + esc(rg[gi].g) + '</td></tr>';
        h += '<tr>';
        // 묶음 칸은 그 묶음의 **첫 행에서만** 나오고 나머지 행을 rowspan 으로 덮는다
        if (hasRg && gpos === 0) h += '<th class="rgrp" rowspan="' + rg[gi].n + '">' + esc(rg[gi].g) + '</th>';
        h += '<th class="hd">' + esc(r.itemnm) + (r.unitnm ? (' (' + esc(r.unitnm) + ')') : '') + '</th>';
        h += sideTd(r, g);
        // ★고정 띠 — 문구가 있으면 격자(필요하면 뒤 칸까지)를 그 글 한 칸으로 덮는다. 입력칸이 아니다.
        //   ⚠인쇄 열-끊기(SPLIT_DIR='C')와는 같이 못 쓴다 — 띠 칸에 data-day 가 없어 조각마다 통째로 남는다.
        //     근거 서식(연간 계획 2·소방시설 월)은 전부 끊지 않는 판이라 지금은 부딪히지 않는다.
        var sp = String(r.spantxt || '').trim();
        if (sp) {
          h += '<td class="spanfix" colspan="' + (PF.length + (spanAll() ? postCols().length : 0)) + '">' + esc(sp) + '</td>';
          if (!spanAll()) h += sideTd(r, g, true);
        } else {
          (function(rw){ PF.forEach(function(pf){ h += cell(rw, pf.no, g(rw, pf.no), '', pf.prd); }); })(r.sort);
          h += sideTd(r, g, true);
        }
        h += '</tr>';
        if (hasRg || rband) { gpos++; if (gpos >= rg[gi].n) { gi++; gpos = 0; } }
      });
      }
      if (FORM.signeryn === 'Y') {
        // 사인 행은 어느 묶음에도 속하지 않는다 — 빈 묶음 칸을 하나 둬야 칸 수가 맞는다
        h += '<tr class="sign">' + (hasRg ? '<th class="rgrp"></th>' : '') + '<th class="hd">점검자 사인</th>' +
             sideTd(null, g);
        PF.forEach(function(pf){ h += cell(SIGN_NO, pf.no, g(SIGN_NO, pf.no), '', pf.prd); });
        h += sideTd(null, g, true) + '</tr>';
      }
      h += '</tbody></table>';
    }
    /* ═══ 격자 아래 자유행 표 (2026-08-13) — 서식이 열 이름을, 문서가 행을 늘린다 ═══
       근거 6종 : 멸균기 2(문제 발생시) · U.P.S(경보조치사항) · 학대폭력·음용수(문제 발생시) ·
                 병동 시설/환자 안전 점검 일지(근무시간별 업무사항).
       ★값 자리 = **행 9000+i / 열 j** — 9000대는 이 표의 예약대다.
         LIST 행 블록이 블록×1000+항목을 쓰므로(2000·3000대…) 멀리 떨어뜨렸다.
       ★전월복사는 이 표를 **안 가져온다** — 그 달에 일어난 일이다(서버 carryVals 가 거른다). */
    h += subTableHtml(g);
    box.innerHTML = h;
    ckRowOffSync();   // 이름 칸이 빈 행은 흐리게(2026-09-02 편의 기능) — 표를 새로 그릴 때마다
    ckHolTint(); ckHolLoad().then(ckHolTint);   // 공휴일 색 — 캐시가 있으면 바로, 없으면 받아서(2026-09-02)
    ckWeekFill(false);                          // 주차 머리글이 비어 있으면 그 달의 날짜 범위를 넣는다
  }

  /* ═══ 주기 복합 그리기 (2026-08-14) ═══
     ★값 자리는 손대지 않는다 — 항목(행)이 이미 묶음별로 다르므로 **행번호가 곧 묶음을 가른다.**
       열번호의 뜻만 그 행이 속한 묶음의 축이 정한다(매일 3열=3일 · 매주 3열=3주차).
       ⇒ collect()·전월복사·빈행 정리는 종전 그대로 돈다(전부 행·열 번호만 본다). */
  function grpPrdHtml(g){
    var secs = grpPrdList(), used = {}, h = '';
    secs.forEach(function(s){ used[s.g] = 1; });
    // 서식에 적힌 **순서대로** 그린다 — 종이의 위아래 순서가 그것이다
    secs.forEach(function(s, i){
      var rows = ITEMS.filter(function(r){ return String(r.grpnm || '').trim() === s.g; });
      if (rows.length) h += grpPrdSec(g, s.g, s.k, rows, i === 0);
    });
    // ★GRP_PRD 에 없는 묶음은 **버리지 않는다** — 서식 축으로 뒤에 붙인다.
    //   (서식을 고치다 묶음 이름이 어긋나면 항목이 조용히 사라진다 — 그것이 제일 나쁘다)
    var rest = ITEMS.filter(function(r){ return !used[String(r.grpnm || '').trim()]; });
    if (rest.length) h += grpPrdSec(g, '', kind(), rest, !h);
    // 점검자 확인란 — 종이에서 격자 3벌 **아래 한 줄**이다. 어느 묶음에도 안 속한다.
    //   칸 수는 첫 구간(매일=31칸)에 맞춘다 — 원본이 그렇다.
    if (FORM.signeryn === 'Y') {
      var PCs = prdCells(secs.length ? secs[0].k : kind());
      h += '<table class="gr" style="margin-top:6px;"><tbody><tr class="sign">' +
           '<th class="hd" style="min-width:150px;">점검자 확인란</th>';
      PCs.forEach(function(pc){ h += cell(SIGN_NO, pc.no, g(SIGN_NO, pc.no), '', pc.no); });
      h += '</tr></tbody></table>';
    }
    return h;
  }
  /** 구간 하나 = 표 하나. `k` 가 그 구간의 기간축이다. */
  function grpPrdSec(g, gnm, k, rows, first) {
    var PF = prdFlat(k), one = (k === '1'), h = '';
    h += '<table class="gr hasrg" style="margin-top:' + (first ? 0 : 6) + 'px;"><thead><tr>' +
         (gnm ? '<th class="rgrp" style="min-width:44px;">구분</th>' : '') +
         '<th class="hd">점검 항목</th>' + sideTh(false, 1);
    PF.forEach(function(pf){
      h += '<th class="' + pf.cls + '" data-day="' + pf.prd + '" style="min-width:' + (one ? 110 : 32) + 'px;">' +
           esc(pf.label) + '</th>';
    });
    h += sideTh(true) + '</tr></thead><tbody>';
    /* ★'N'(주차) 구간은 **주마다 날짜를 적는 줄**이 늘 있다 — 실측 10종이 전부 그랬다.
       ⇒ 조각을 넷으로 늘리지 않으려고 「축에 딸린 성질」로 못박았다. 반례가 나오면 그때 칸을 연다.
       ⚠한 서식에 N 구간이 둘이면 890 행이 겹친다. 근거가 없어 지금은 막지 않았다 — 생기면 갈라야 한다. */
    if (k === 'N') {
      h += '<tr class="prdh">' + (gnm ? '<th class="rgrp"></th>' : '') +
           '<th class="hd">' + esc(String(FORM.prdheadnm || '').trim()) + '</th>' + sideTd(null, g);
      PF.forEach(function(pf){
        h += '<td data-day="' + pf.prd + '"><input data-r="' + PRDH_NO + '" data-c="' + pf.no +
             '" value="' + esc(g(PRDH_NO, pf.no)) + '"></td>';
      });
      h += sideTd(null, g, true) + '</tr>';
    }
    rows.forEach(function(r, i){
      h += '<tr>';
      if (gnm && i === 0) h += '<th class="rgrp" rowspan="' + rows.length + '">' + esc(gnm) + '</th>';
      h += '<th class="hd">' + esc(r.itemnm) + (r.unitnm ? (' (' + esc(r.unitnm) + ')') : '') + '</th>';
      h += sideTd(r, g);
      (function(rw){ PF.forEach(function(pf){ h += cell(rw, pf.no, g(rw, pf.no), '', pf.prd); }); })(r.sort);
      h += sideTd(r, g, true) + '</tr>';
    });
    return h + '</tbody></table>';
  }

  var SUB_ROW_BASE = 9000;   // 예약 — 격자 아래 자유행 표(2026-08-13). 890·900·1000/2000대와 한 표에 산다
  function subCols(){
    return (FORM && FORM.subcols) ? String(FORM.subcols).split(',').map(function(s){ return s.trim(); })
                                                        .filter(function(s){ return s; }) : [];
  }
  function subTableHtml(g){
    var sc = subCols();
    if (!sc.length) return '';
    // 저장분의 가장 큰 행번호까지 그리되, 기본 3행 밑으로는 안 내려간다(원본들이 3줄 안팎)
    var maxR = 3;
    for (var r = 1; r <= 30; r++) {
      for (var c = 1; c <= sc.length; c++) if (g(SUB_ROW_BASE + r, c)) { if (r > maxR) maxR = r; break; }
    }
    var h = '<table class="gr sub" style="margin-top:7px;"><thead><tr>';
    if (FORM.subnm) h += '<th rowspan="' + (maxR + 1) + '" style="width:70px;">' + esc(FORM.subnm) + '</th>';
    sc.forEach(function(nm){ h += '<th>' + esc(nm) + '</th>'; });
    h += '</tr></thead><tbody>';
    for (var i = 1; i <= maxR; i++) {
      h += '<tr>';
      sc.forEach(function(nm, j){ h += cell(SUB_ROW_BASE + i, j + 1, g(SUB_ROW_BASE + i, j + 1), 'ltxt'); });
      h += '</tr>';
    }
    h += '</tbody></table>' +
         '<div style="margin-top:3px;"><button type="button" class="ck-btn ghost" style="padding:2px 10px;font-size:11.5px;"' +
         ' onclick="ckSubRowAdd();">＋ 줄 추가</button></div>';
    return h;
  }
  /** 자유행 표에 빈 줄 하나 — 화면만 늘린다. 값 없는 줄은 collect() 가 어차피 안 담는다. */
  window.ckSubRowAdd = function(){
    var t = document.querySelector('#ckGridWrap table.sub tbody');
    if (!t) return;
    var sc = subCols(), n = t.querySelectorAll('tr').length + 1, h = '';
    sc.forEach(function(nm, j){ h += cell(SUB_ROW_BASE + n, j + 1, '', 'ltxt'); });
    var tr = document.createElement('tr'); tr.innerHTML = h; t.appendChild(tr);
    var th = document.querySelector('#ckGridWrap table.sub thead th[rowspan]');
    if (th) th.setAttribute('rowspan', String(n + 1));
  };

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
    // 월 생성은 **일 단위 서식**만 — 다른 주기에 31개를 깔면 목록이 통째로 망가진다(서버도 막는다)
    gel('ckMonthBtn').style.display = (FORM && FORM.prdgb === 'D') ? '' : 'none';
    gel('ckTools').style.display = FORM ? '' : 'none';   // 편의 기능 띠 — 서식이 있을 때만(2026-09-02)
    // 주차 격자(N)에만 [주차 날짜 채움] · 위너넷 계정에만 [공휴일 관리] · 평가표(EXCL_YN)엔 표식
    gel('ckWeekBtn').style.display = (FORM && prdHeadOn() && (kind() === 'N' || /N/.test(String(FORM.grpprd || '')))) ? '' : 'none';
    gel('ckHolBtnWrap').style.display = (gel('qpsChk').getAttribute('data-wnn') === 'Y') ? '' : 'none';
    gel('ckExclNote').style.display = ckExclOn() ? '' : 'none';
    gel('ckNoteWrap').style.display = (FORM && FORM.noteyn === 'Y') ? '' : 'none';
    gel('ckNoteTitle').textContent = noteNm();   // 서식이 정한 칸 이름(조치사항 등)
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
      if (!curSeq) { renderGrid([], []); setPhotos([]); }   // 서식이 바뀌면 사진칸 구성도 갈린다
      else renderPhotos();
    }).catch(err);
  };

  /* ★서식 목록만 조용히 다시 받기(2026-09-02 「F5 눌러야 하네요」) — 다른 화면(우리 병원 사용 서식)에서 서식을 켜고
     돌아오면 열어 둔 작성 화면의 목록은 옛것이다. 탭이 다시 보이거나 창이 포커스를 얻을 때 **목록만** 갱신한다.
     ⚠ckBase 를 그대로 부르면 새 문서일 때 격자를 비운다(입력 중인 값이 날아감) — 그래서 따로 둔다. 같으면 손대지 않는다. */
  var ckFormsAt = 0;
  function ckFormsRefresh(){
    if (document.hidden || Date.now() - ckFormsAt < 3000) return;   // 3초 안에 여러 번 오는 focus/visibility 를 한 번으로
    ckFormsAt = Date.now();
    post('<c:url value="/qps/chkBase.do"/>', { inYear: gel('ckYear').value, formId: '', deptCd: val('ckDept') }).then(function(res){
      var list = res.forms || [], sel = gel('ckForm'), keep = sel.value;
      var cur = [].map.call(sel.options, function(o){ return o.value; }).join('|');
      var nw  = list.map(function(f){ return f.formid; }).join('|');
      if (cur === nw || (!list.length && !FORMS.length)) return;
      FORMS = list; sel.innerHTML = '';
      if (!FORMS.length) sel.add(new Option('— 쓸 수 있는 서식이 없습니다 —', ''));
      FORMS.forEach(function(f){ sel.add(new Option(f.formnm, f.formid)); });
      if (keep && FORMS.some(function(f){ return f.formid === keep; })) sel.value = keep;
      _toast('서식 목록을 새로 받았습니다.', 'ok');
    }, function(){});
  }
  document.addEventListener('visibilitychange', ckFormsRefresh);
  window.addEventListener('focus', ckFormsRefresh);

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
    /* ⚠**블록이 있는 대장은 999행까지다** — 행 번호가 `블록×1000+행`(blkRowNo)이라
       1000행째가 되면 ***다음 블록의 자리로 넘어간다***(1블록 1000행 = 2블록 0행).
       블록이 없는 대장은 행 번호가 그냥 1,2,3… 이라 이 한계가 없다. */
    var want = (LIST_ROWS[k] || 0) + (Number(n) || 1);
    if (blkDefs().length && want > 999) {
      _alertBox('한 표에 999행까지 넣을 수 있습니다.', {icon:'⚠️'});
      return;
    }
    LIST_ROWS[k] = want;
    renderGrid(c.vals, c.rows, c.cols);
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
      if (v.rowno === SIGN_NO || v.rowno >= SUB_ROW_BASE || seen[v.rowno]) return;   // 9000대=자유행 표
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
      return (v.rowno === SIGN_NO || v.rowno >= SUB_ROW_BASE)
             ? v : { rowno: map[v.rowno], colno: v.colno, val: v.val };
    });
    LIST_ROWS = {};                                  // Math.max 가 옛 행 수를 붙잡지 않도록
    renderGrid(moved, c.rows, c.cols);
    // ★「몇 줄 지웠다」로 적지 않는다 — 기본 행 수 아래로는 안 줄어들어 숫자가 사실과 어긋난다.
    _toast('빈 행을 정리했습니다. 값 있는 행 ' + kept + '.', 'ok');
  };

  /* ───── 사진칸 (2026-08-15) ─────────────────────────────────────────────
     서식 PHOTO_NMS(쉼표 이름 목록)가 칸 이름·수를 정한다 — 납가운 증빙사진·봉인스티커 월별.
     ★표시는 fetch→blob→objectURL — /sftp/download.do 가 attachment 강제(safeRpt 사진과 같은 해법). */
  var PHOTOS = {}, _phSlot = 0;
  function photoNms(){
    var s = (FORM && FORM.photonms) ? String(FORM.photonms) : '';
    if (!s.trim()) return [];
    return s.split(',').map(function(x){ return x.trim(); }).filter(function(x){ return x; }).slice(0, 12);
  }
  function renderPhotos(){
    var nms = photoNms(), wrap = gel('ckPhotoWrap');
    if (!nms.length) { wrap.style.display = 'none'; gel('ckPhotoGrid').innerHTML = ''; return; }
    var h = '';
    nms.forEach(function(nm, i){
      var s = i + 1, ph = PHOTOS[s];
      h += '<div class="ph-cell' + (ph ? ' has' : '') + '" onclick="ckPhotoPick(' + s + ');" title="' +
           (ph ? '누르면 이 칸의 사진을 바꿉니다' : '누르면 사진을 올립니다') + '">' +
           '<span class="no">' + esc(nm) + '</span>' +
           (ph
             ? (ph.url ? '<img src="' + ph.url + '" alt="">' : '<span class="empty">불러오는 중…</span>') +
               '<button type="button" class="rm" onclick="ckPhotoDel(event,' + s + ');">✕</button>'
             : '<span class="empty">＋ 사진 올리기</span>') +
           '</div>';
    });
    gel('ckPhotoGrid').innerHTML = h;
    wrap.style.display = '';
    ckTabSync();
  }

  /* ═══ 탭 · 글자 크기 (2026-08-15 — 사용자 요청) ═══════════════════════════
     ★가를 것이 있을 때만 탭을 낸다 — **사진칸이 있는 서식**만이다(격자는 본체라 못 가른다).
       사진칸이 없으면 띠 자체를 숨기고 종전과 똑같이 쭉 보여준다.
     ⚠사진 영역을 숨기는 주체가 둘(서식에 사진칸이 없음 · 탭) — safeRpt 와 같은 규칙으로
       ***탭은 `data-off` 로만 숨긴다.*** */
  var CK_TAB_KEY = 'qpsCkTab', ckTab = 'main';
  function ckHasPhoto(){ return photoNms().length > 0; }
  window.ckTabSync = function(){
    var box = gel('ckTabs'), main = gel('ckMainWrap'), ph = gel('ckPhotoWrap');
    if (!box || !main || !ph) return;
    /* ★사진칸이 있어도 **한 화면에 들어가면** 탭을 내지 않는다(2026-08-15 지적) */
    var card = document.querySelector('#qpsChk .ck-card');
    var fits = card && (card.offsetHeight <= window.innerHeight - 150);
    if (!ckHasPhoto() || (fits && ckTab !== 'photo')) {   // 가를 것이 없다 — 종전 모습 그대로
      box.style.display = 'none';
      main.style.display = '';
      if (ph.getAttribute('data-off') === 'Y') { ph.removeAttribute('data-off'); ph.style.display = ''; }
      return;
    }
    box.style.display = '';
    var tabs = [{ k:'main', nm:'점검표' },
                { k:'photo', nm:'사진 (' + photoNms().length + ')' },
                { k:'all', nm:'전체' }];
    box.innerHTML = tabs.map(function(t){
      return '<button type="button" class="ck-tab' + (t.k === ckTab ? ' on' : '') +
             '" onclick="ckPickTab(\'' + t.k + '\');">' + esc(t.nm) + '</button>';
    }).join('');
    main.style.display = (ckTab === 'photo') ? 'none' : '';
    if (ckTab === 'main') { ph.setAttribute('data-off', 'Y'); ph.style.display = 'none'; }
    else if (ph.getAttribute('data-off') === 'Y') { ph.removeAttribute('data-off'); ph.style.display = ''; }
  };
  window.ckPickTab = function(k){
    ckTab = k;
    try { localStorage.setItem(CK_TAB_KEY, k); } catch (ignore) {}
    ckTabSync();
  };

  /* 글자 크기 — CSS 가 px 라 `zoom` 으로 통째로(격자 칸도 같이 커진다). 인쇄는 새 창이라 무관. */
  var CK_Z_MIN = 0.8, CK_Z_MAX = 1.6, CK_Z_KEY = 'qpsCkZoom';
  function ckApplyZoom(z){
    z = Math.min(CK_Z_MAX, Math.max(CK_Z_MIN, z));
    var c = document.querySelector('#qpsChk .ck-card');
    if (c) c.style.zoom = z.toFixed(2);
    return z;
  }
  window.ckZoom = function(d){
    var c = document.querySelector('#qpsChk .ck-card');
    var cur = parseFloat(c && c.style.zoom) || 1;
    if (d === 0) { ckApplyZoom(1); try { localStorage.removeItem(CK_Z_KEY); } catch (ignore) {} return; }
    var z = ckApplyZoom(cur + d * 0.1);
    try { localStorage.setItem(CK_Z_KEY, String(z)); } catch (ignore) {}
  };
  (function(){                                  // 지난번에 쓰던 값 되살리기
    try {
      var t = localStorage.getItem(CK_TAB_KEY);
      if (t === 'main' || t === 'photo' || t === 'all') ckTab = t;
      var z = parseFloat(localStorage.getItem(CK_Z_KEY));
      if (z) ckApplyZoom(z);
    } catch (ignore) {}
  })();

  function setPhotos(files){
    Object.keys(PHOTOS).forEach(function(k){ try { URL.revokeObjectURL(PHOTOS[k].url); } catch(e){} });
    PHOTOS = {};
    (files || []).forEach(function(f){
      var s = Number(f.fileseq);
      if (s >= 1 && s <= 12) PHOTOS[s] = { filepath:f.filepath, orgnm:f.orgnm, url:'' };
    });
    renderPhotos();
    if (!photoNms().length) return;
    Object.keys(PHOTOS).forEach(function(s){ loadPhotoUrl(Number(s)); });
  }
  function loadPhotoUrl(slot){
    var ph = PHOTOS[slot];
    if (!ph || !ph.filepath) return;
    fetch('/sftp/download.do?filePath=' + encodeURIComponent(ph.filepath))
      .then(function(r){ if (!r.ok) throw new Error(); return r.blob(); })
      .then(function(b){ if (PHOTOS[slot] !== ph) return; ph.url = URL.createObjectURL(b); renderPhotos(); })
      .catch(function(){ /* 못 불러와도 칸은 남긴다 — 다시 열면 재시도 */ });
  }
  window.ckPhotoPick = function(slot){
    if (!curSeq) { _alertBox('점검표를 먼저 저장한 뒤 사진을 붙일 수 있습니다.', {icon:'⚠️'}); return; }
    _phSlot = slot;
    gel('ckPhotoInp').click();
  };
  gel('ckPhotoInp').onchange = function(){
    var f = this.files && this.files[0];
    this.value = '';
    if (!f || !_phSlot || !curSeq) return;
    var fd = new FormData();
    fd.append('chkSeq', curSeq); fd.append('fileSeq', _phSlot); fd.append('file', f);
    $.ajax({ url:'<c:url value="/qps/chkPhotoUpload.do"/>', type:'POST', data:fd,
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
  window.ckPhotoDel = function(ev, slot){
    if (ev) { ev.preventDefault(); ev.stopPropagation(); }
    _confirmBox({ msg:'이 칸의 사진을 지울까요?', icon:'⚠️', okText:'지우기', okColor:'#b23b3b',
      onOk: function(){
        post('<c:url value="/qps/chkPhotoDelete.do"/>', { chkSeq:curSeq, fileSeq:slot }).then(function(){
          if (PHOTOS[slot]) { try { URL.revokeObjectURL(PHOTOS[slot].url); } catch(e){} delete PHOTOS[slot]; }
          renderPhotos();
          _toast('지웠습니다.', 'ok');
        }).catch(err);
      } });
  };
  /** 인쇄용 — 있는 칸만 2칸씩 한 줄(원본 비율 유지). blob URL 은 같은 출처 인쇄창에서 접근된다 */
  function ckPhotoPrintHtml(){
    var nms = photoNms();
    if (!nms.length) return '';
    var cells = [];
    nms.forEach(function(nm, i){
      var ph = PHOTOS[i + 1];
      if (ph && ph.url) cells.push({ nm:nm, url:ph.url });
    });
    if (!cells.length) return '';
    var h = '<table style="margin-top:6px;"><tbody>';
    for (var i = 0; i < cells.length; i += 2) {
      h += '<tr>';
      [cells[i], cells[i + 1]].forEach(function(c){
        h += c ? '<td style="width:50%;text-align:center;vertical-align:middle;padding:4px;">' +
                 '<div style="font-size:9.5px;font-weight:700;margin-bottom:2px;">' + esc(c.nm) + '</div>' +
                 '<img src="' + c.url + '" style="max-width:100%;max-height:80mm;" alt=""></td>'
               : '<td style="width:50%;"></td>';
      });
      h += '</tr>';
    }
    return h + '</tbody></table>';
  }

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
      renderGrid(res.vals || [], res.rows || [], res.cols || []);
      setPhotos(res.files);
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
    setPhotos([]);
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
    // 문서가 정하는 **열** 이름 — 위 행 이름과 같은 방식(2026-08-12)
    var cols = [];
    document.querySelectorAll('#ckGridWrap input[data-cn]').forEach(function(el){
      var v = String(el.value).trim();
      if (!v) return;
      cols.push({ colno: Number(el.getAttribute('data-cn')), colnm: v });
    });
    return { vals: vals, rows: rows, cols: cols };
  }

  /* ═══ 편의 기능 — SUNWOO 원본 소스 대조로 이식 (2026-09-02) ═══
     ★근거 = D:\sunwoo\sunwoo\SmartChart\COM\ParentChartMulti.pas 의 부모 편의기능(InitFunctionValues 12종)과
       CHT/*.pas 1,373개 사용 빈도 : O/X 더블클릭 토글·Enter 복사·일괄 서명 각 61종 · 전체 마킹(chk_all) 300종 ·
       이름 빈 행 잠금(blankDisableLine) 47종 · 토/일·휴일 제외 8~19종. 「검증된 소스라 사용자 위주 기능이 많다」
       (사용자, 2026-09-02) — 그 중 서식 정의를 안 건드리고 격자에 바로 얹을 수 있는 것만 골랐다.
     ★규칙은 SUNWOO 그대로. 단 **둘은 이 화면 원칙을 따른다** :
       ①이미 적힌 값은 덮지 않는다 — 전체 O·일괄 서명은 **빈 칸만** 채운다(SUNWOO 는 덮어쓴다). 전월복사와 같은 원칙.
       ②온습도 「랜덤 채움」(tempHumi, 55종)은 ***일부러 안 옮겼다*** — 측정값을 지어내는 기능이라 점검 기록의 뜻을 해친다.
     ★토글 순서 = 빈→O→X→빈 (ALLQFunc f_switch_flag 의 2단). 3단(△)·4단(○△X●)은 근거 서식이 오면 FORM 칸으로 연다.
     ★대상 = 격자 **값칸**(`input[data-r]` 중 .ltxt 아닌 것)뿐. 사인 행 900·기간 머리 890·자유행 표 9000+·이름 칸(data-rn/cn)·
       글자 칸(.ltxt)은 토글·복사 대상이 아니다 — 글자 칸에 Enter 복사를 허용하면 대장의 이름이 사유 칸으로 번진다
       (SUNWOO 는 칸 **너비**로 걸렀다 — 여기서는 .ltxt 로 가른다).
     ★휴일 = 이 화면이 이미 칠하는 **토·일(dowCls)** 만. SUNWOO 는 t_holiday(공휴일 관리)까지 보는데 WinCheck+ 엔
       그 표가 없다(관리자모듈 대조 08-17 ④ 결정 사안) — 표가 생기면 ckCellOff 한 곳만 넓히면 된다.
     ★표가 다시 그려져도 살아남게 리스너는 #ckGridWrap 에 **한 번만** 건다(위임). */
  var FLIP = { '': 'O', 'O': 'X', 'X': '' };
  function ckFlip(v){ v = String(v || '').trim(); return (v in FLIP) ? FLIP[v] : ''; }   // 그 밖의 글자면 비운다
  /** 토글·복사·전체 마킹의 대상 칸인가 */
  function ckOxOk(inp){
    if (!inp || inp.tagName !== 'INPUT' || !inp.hasAttribute('data-r')) return false;
    if (inp.classList.contains('ltxt') || inp.readOnly) return false;
    var r = Number(inp.getAttribute('data-r'));
    return !(r === SIGN_NO || r === PRDH_NO || r >= SUB_ROW_BASE);
  }
  function ckOxCells(scope){ return [].filter.call((scope || gel('ckGridWrap')).querySelectorAll('input[data-r]'), ckOxOk); }
  /** 그 칸이 토·일·공휴일 칸인가 — 「토·일·공휴일 제외」가 켜져 있을 때만 참. 기간이 열이면 머리글 색, 행이면 행 머리 색을 본다. */
  function ckCellOff(inp){
    var ex = gel('ckExclWk'); if (!ex || !ex.checked) return false;
    var td = inp.closest('td'), tr = inp.closest('tr'), tb = inp.closest('table');
    var d = td ? td.getAttribute('data-day') : null;
    if (d != null) {
      var th = tb ? tb.querySelector('thead th[data-day="' + d + '"]') : null;
      if (th) return /(^|\s)(sat|sun|hol)(\s|$)/.test(th.className);
      var k = kind();                       // 머리글 없는 표(주기 복합의 사인 줄) — 날짜 규칙으로 직접 센다
      if (k === 'D') return !!dowCls(Number(d)).trim() || ckIsHol(Number(d));
      if (k === 'W') return Number(d) >= 6;
      return false;
    }
    var hd = tr ? tr.querySelector('td.hd, th.hd') : null;   // 기간이 **행**인 축(DAY_ITEM) — 행 머리의 색
    return !!(hd && /(^|\s)(sat|sun|hol)(\s|$)/.test(hd.className));
  }
  /** 로그인 사용자 이름 — top.jsp 가 심는 s_usernm 쿠키(다른 QPS 화면과 같은 출처) */
  function ckUserNm(){
    var m = document.cookie.match(/(?:^|;\s*)s_usernm=([^;]*)/);
    try { return m ? decodeURIComponent(m[1]).trim() : ''; } catch (e) { return m ? m[1] : ''; }
  }
  /** 전체 O / 전체 지움 (SUNWOO chk_all). ★O 는 빈 칸만 · 지움은 묻고 한다. */
  window.ckAllOx = function(v){
    var cells = ckOxCells();
    if (!cells.length) { _alertBox('격자가 없습니다.', {icon:'ℹ️'}); return; }
    if (v) {
      if (ckExclOn()) { _alertBox('이 서식은 <b>한 줄에 O 하나</b>(평가표)라 전체 O 는 쓰지 않습니다.<br>칸을 더블클릭하거나 열 머리를 더블클릭해 한 열로 채우세요.', {icon:'ℹ️'}); return; }
      var n = 0;
      cells.forEach(function(el){ if (!String(el.value).trim() && !ckCellOff(el)) { el.value = v; n++; } });
      _toast('빈 칸 ' + n + '개에 ' + v + ' 를 채웠습니다. 이미 적힌 칸은 그대로입니다.', 'ok');
      return;
    }
    _confirmBox({ msg: '격자 값을 <b>전부</b> 비웁니다. 되돌릴 수 없습니다.<br>(이름 칸·글자 칸·사인은 그대로)',
      icon:'⚠️', okText:'비우기', okColor:'#b23b3b',
      onOk: function(){ var n = 0; cells.forEach(function(el){ if (String(el.value).trim()) { el.value = ''; n++; } });
                        _toast(n + '개 칸을 비웠습니다.', 'ok'); } });
  };
  window.ckExclWkSave = function(){ try { localStorage.setItem('qpsChkExclWk', gel('ckExclWk').checked ? 'Y' : 'N'); } catch (e) {} };
  /** 이름 칸(data-rn)이 빈 행은 흐리게만 표시한다 — SUNWOO blankDisableLine(47종)은 비활성+값 삭제. ★잠그지도 지우지도 않는다. */
  function ckRowOffSync(){
    gel('ckGridWrap').querySelectorAll('input[data-rn]').forEach(function(nm){
      var cellEl = nm.closest('th,td'); if (!cellEl) return;
      var tr = cellEl.closest('tr'), n = Number(cellEl.getAttribute('rowspan') || 1), off = !String(nm.value).trim();
      // ★잠그지 않는다 — 흐리게만(2026-09-02 사용자 요청 「잠금 대신 흐리게만」). SUNWOO 는 줄을 비활성하지만
      //   새 서식을 열자마자 전부 회색 잠금이면 낯설다. 입력·토글은 그대로 되고, 이름을 적으면 표시가 풀린다.
      for (var i = 0; i < n && tr; i++, tr = tr.nextElementSibling) tr.classList.toggle('rowoff', off);
    });
  }
  (function(){
    var wrap = gel('ckGridWrap');
    wrap.addEventListener('input', function(ev){
      var t = ev.target; if (!t || !t.hasAttribute) return;
      if (t.hasAttribute('data-rn')) ckRowOffSync();
      if (t.hasAttribute('data-r')) ckExclApply(t);   // 손으로 O 를 쳐도 한 줄 하나 규칙은 같다
    });
    wrap.addEventListener('dblclick', function(ev){
      var t = ev.target; if (!t || !t.closest) return;
      // ① 값칸 — 한 칸 토글 / 사인 칸 — 비어 있으면 내 이름
      if (t.tagName === 'INPUT') {
        if (ckOxOk(t)) { ev.preventDefault(); t.value = ckFlip(t.value); ckExclApply(t); return; }
        if (t.hasAttribute('data-r') && Number(t.getAttribute('data-r')) === SIGN_NO && !String(t.value).trim()) {
          var nm = ckUserNm(); if (nm) { ev.preventDefault(); t.value = nm; }
        }
        return;                              // 이름 칸·글자 칸은 원래대로(글자 선택)
      }
      // ①-2 셀 고정문 칸 — 글자를 더블클릭해도 그 칸이 토글된다(평가표는 글을 읽고 고르는 것이라 글 위를 누른다)
      var ctd = t.closest('td.hasct');
      if (ctd) { var ip = ctd.querySelector('input[data-r]'); if (ckOxOk(ip)) { ev.preventDefault(); ip.value = ckFlip(ip.value); ckExclApply(ip); } return; }
      var th = t.closest('th, td'); if (!th) return;
      var tr = th.closest('tr'), tb = th.closest('table'); if (!tr || !tb) return;
      // ② 사인 행 머리 — 그 줄 일괄 서명(빈 칸만 · 토·일 제외 옵션). SUNWOO signLine 61종
      if (tr.classList.contains('sign') && th.classList.contains('hd')) {
        var nm2 = ckUserNm();
        if (!nm2) { _alertBox('로그인 사용자 이름을 찾지 못했습니다.', {icon:'⚠️'}); return; }
        var k = 0;
        tr.querySelectorAll('input[data-r]').forEach(function(el){
          if (Number(el.getAttribute('data-r')) !== SIGN_NO || String(el.value).trim() || ckCellOff(el)) return;
          el.value = nm2; k++;
        });
        _toast('사인 ' + k + '칸에 「' + nm2 + '」을 넣었습니다. 이미 적힌 칸은 그대로입니다.', 'ok'); return;
      }
      // ③ 머리글(날짜 · 열) — 세로줄 토글. SUNWOO switchFlagLineV
      if (th.tagName === 'TH' && th.closest('thead')) {
        var d = th.getAttribute('data-day'), c = th.getAttribute('data-col'), cells = [];
        if (d != null) cells = [].filter.call(tb.querySelectorAll('td[data-day="' + d + '"] input[data-r]'), ckOxOk);
        else if (c != null) cells = ckOxCells(tb).filter(function(el){ return el.getAttribute('data-c') === c; });
        else return;
        ev.preventDefault(); cells.forEach(function(el){ el.value = ckFlip(el.value); ckExclApply(el); }); return;   // 평가표면 「이 열로 채우기」가 된다
      }
      // ④ 행 머리(항목 · 날짜) — 가로줄 토글. SUNWOO switchFlagLineH. 이름 입력칸이 든 머리(기기명)는 제외(고쳐 쓰는 자리다)
      if (th.classList.contains('hd') && !th.querySelector('input') && !tr.classList.contains('prdh')) {
        if (ckExclOn()) { _toast('이 서식은 한 줄에 O 하나입니다 — 가로줄 토글은 쓰지 않습니다.', 'warn'); return; }
        ev.preventDefault(); ckOxCells(tr).forEach(function(el){ el.value = ckFlip(el.value); });
      }
    });
    // Enter = 오른쪽 복사 · Ctrl+Enter = 아래 복사 (SUNWOO copyLine — 값칸끼리만)
    wrap.addEventListener('keydown', function(ev){
      var t = ev.target; if (ev.key !== 'Enter' || !ckOxOk(t)) return;
      ev.preventDefault();
      var v = t.value, tr = t.closest('tr'), tb = t.closest('table'), c = t.getAttribute('data-c');
      if (ev.ctrlKey) {                       // 아래로 — 같은 표, 같은 열, 이 행 다음부터
        var seen = false;
        [].forEach.call(tb.querySelectorAll('tbody tr'), function(row){
          if (row === tr) { seen = true; return; }
          if (!seen) return;
          [].forEach.call(row.querySelectorAll('input[data-r][data-c="' + c + '"]'), function(el){ if (ckOxOk(el)) { el.value = v; ckExclApply(el); } });
        });
      } else if (ckExclOn()) {                // 평가표는 오른쪽 복사가 뜻이 없다(한 줄에 O 하나) — 아무것도 안 한다
        return;
      } else {                                // 오른쪽으로 — 같은 행, 이 칸 다음부터
        var after = false;
        [].forEach.call(tr.querySelectorAll('input[data-r]'), function(el){
          if (el === t) { after = true; return; }
          if (after && ckOxOk(el)) el.value = v;
        });
      }
    });
    try { if (localStorage.getItem('qpsChkExclWk') === 'Y') gel('ckExclWk').checked = true; } catch (e) {}
  })();

  /* ═══ 델파이 분석 2차 이식 (2026-09-02 오후) — 배타 체크 · 공휴일 · 주차 날짜 ═══
     「그대로가 아니라 개선해서」(사용자) : SUNWOO 는 폼마다 코드로 박았지만 여기서는 **서식 옵션·공용 표**로 푼다. */

  /* ── 행 배타 체크 — SUNWOO 175종 폼의 「같은 Hint 묶음 체크박스는 하나만」. 서식 옵션 EXCL_YN(ITEM_COL) ──
     O 를 찍으면 같은 줄(같은 항목)의 다른 격자 O 를 지운다. 옆 칸(1000+/2000+)·글자 칸은 대상이 아니다.
     X 는 안 건드린다 — 「부적합 X 하나 + 적합 O 하나」가 같이 있는 서식이 있을 수 있어 O 끼리만 배타로 둔다. */
  function ckExclOn(){ return !!(FORM && FORM.exclyn === 'Y' && axis() === 'ITEM_COL'); }
  function ckExclApply(inp){
    if (!ckExclOn() || !ckOxOk(inp) || !/^o$/i.test(String(inp.value).trim())) return;
    var tr = inp.closest('tr'); if (!tr) return;
    [].forEach.call(tr.querySelectorAll('input[data-r]'), function(el){
      if (el === inp || !ckOxOk(el) || Number(el.getAttribute('data-c')) >= PRE_BASE) return;
      if (/^o$/i.test(String(el.value).trim())) el.value = '';
    });
  }

  /* ── 공휴일 — SUNWOO t_holiday 대응. 전 병원 공용 표(TBL_QPS_HOLIDAY), 연 단위로 받아 캐시 ──
     쓰는 곳 : 날짜 머리글 색(.hol, 이름은 title) · 「토·일·공휴일 제외」(전체 O · 일괄 서명).
     ★옛 서버(엔드포인트 없음)면 「공휴일 없음」으로 조용히 넘어간다 — 화면이 서버보다 먼저 배포돼도 안 깨진다. */
  var HOLS = {};                                        // 연 → { 'MMDD': 이름 }
  function ckHolLoad(){
    var y = String(gel('ckYear').value || '');
    if (!/^\d{4}$/.test(y)) return $.Deferred().resolve({}).promise();
    if (HOLS[y]) return $.Deferred().resolve(HOLS[y]).promise();
    return post('<c:url value="/qps/holidayList.do"/>', { year: y }).then(function(res){
      var m = {};
      (res.list || []).forEach(function(h){ var d = String(h.holdt || ''); if (d.length === 8) m[d.slice(4)] = h.holnm || ''; });
      HOLS[y] = m; return m;
    }, function(){ HOLS[y] = {}; return HOLS[y]; });
  }
  function ckHolKey(d){ return ('0' + Number(gel('ckMm').value || 1)).slice(-2) + ('0' + Number(d)).slice(-2); }
  function ckIsHol(d){ var h = HOLS[String(gel('ckYear').value || '')]; return !!(h && h[ckHolKey(d)]); }
  function ckHolNm(d){ var h = HOLS[String(gel('ckYear').value || '')]; return (h && h[ckHolKey(d)]) || ''; }
  /** 날짜 머리(열 머리 th · DAY_ITEM 행 머리 td)에 공휴일 색 — 글자가 날짜 숫자인 머리만(주차 「1주」·요일 「월」은 제외) */
  function ckHolTint(){
    if (!FORM) return;
    [].forEach.call(gel('ckGridWrap').querySelectorAll('thead th[data-day], td.hd[data-day]'), function(el){
      if (!/^\d{1,2}$/.test(el.textContent.trim())) return;
      var d = Number(el.getAttribute('data-day')), on = ckIsHol(d);
      el.classList.toggle('hol', on);
      if (on) el.title = ckHolNm(d); else if (el.title) el.removeAttribute('title');
    });
  }
  /* 등록·삭제 화면은 QPS ▸ 공통 ▸ 기준코드 ▸ 공휴일 관리(qpsHoliday.jsp) — 툴바의 「공휴일 관리 →」가 그리로 간다(위너넷만 보임).
     ★[2026-09-02] 처음엔 이 툴바에 패널을 붙였다가 사용자 지시로 메뉴 화면으로 옮겼다(중복 화면을 두지 않는다). */

  /* ── 주차 날짜 자동 채움 — SUNWOO weekCheck/weekList(35종) 대응 ──
     주차(N) 격자의 기간 머리글(890행)이 비어 있으면 그 달의 날짜 범위를 넣는다. 주 = 월~일,
     1주는 1일부터 첫 일요일까지, 5주는 달 끝까지(6주째가 있어도 5주에 붙인다 — 칸이 다섯이다).
     ★적힌 값은 안 덮는다. [주차 날짜 채움] 단추는 force 로 전부 다시 쓴다. */
  function ckWeekRanges(){
    var y = Number(gel('ckYear').value), m = Number(gel('ckMm').value || 1), last = new Date(y, m, 0).getDate();
    var out = [], start = 1;
    for (var w = 1; w <= 5 && start <= last; w++) {
      var end = start;
      while (end < last && new Date(y, m - 1, end).getDay() !== 0) end++;
      if (w === 5) end = last;
      out.push({ no: w, txt: m + '/' + start + '~' + m + '/' + end });
      start = end + 1;
    }
    return out;
  }
  window.ckWeekFill = function(force){
    if (!FORM || !prdHeadOn()) return;
    var wr = ckWeekRanges(), n = 0;
    [].forEach.call(gel('ckGridWrap').querySelectorAll('table'), function(tb){
      var ths = tb.querySelectorAll('thead th[data-day]');
      if (!ths.length || ![].every.call(ths, function(th){ return /주$/.test(th.textContent.trim()); })) return;   // 주차 격자만
      wr.forEach(function(w){
        var inp = tb.querySelector('input[data-r="' + PRDH_NO + '"][data-c="' + w.no + '"]');
        if (!inp) return;
        if (force || !String(inp.value).trim()) { inp.value = w.txt; n++; }
      });
    });
    if (force) _toast('주차 날짜 ' + n + '칸을 채웠습니다.', 'ok');
  };

  window.ckSave = function(){
    if (!FORM) { _alertBox('서식을 먼저 고르세요.', {icon:'⚠️'}); return; }
    var c = collect();
    // ★주기(prdGb)는 안 보낸다 — **서버가 서식에서 읽는다.** 화면 값을 믿으면 서식과 어긋난 문서가 생긴다.
    var m = { chkSeq: curSeq || '', formId: FORM.formid, inYear: gel('ckYear').value,
              inMm: usesMm() ? gel('ckMm').value : '',
              prdNo: prdNos().length ? gel('ckPrdNo').value : '',
              wardNm: val('f_wardNm'),
              noteTxt: val('f_noteTxt'), fixTxt: val('f_fixTxt'),
              vals: JSON.stringify(c.vals), rows: JSON.stringify(c.rows),
              cols: JSON.stringify(c.cols) };
    // 상단 자유칸 — 없는 칸은 빈 값으로 보낸다(서버가 8개를 다 받는다)
    for (var hi = 1; hi <= HEAD_MAX; hi++) m['head' + hi] = val('f_head' + hi);
    post('<c:url value="/qps/chkSave.do"/>', m).then(function(res){
      _toast('저장되었습니다.', 'ok');
      curSeq = Number(res.chkSeq);
      ckBase().then(function(){ gel('ckDoc').value = String(curSeq); ckPickDoc(); });
    }).catch(err);
  };

  /* ═══ 전월 복사 · 월 생성 (2026-08-12, v3 순서 9) ═══
     ★원본 화면 여럿에 「전월복사」가 있다 — 실제로 많이 쓴다는 뜻이다.
     ★★***그런데 무엇을 복사하느냐가 이 기능의 전부다.***
       지난달 O 가 남아 있으면 화면은 **「점검했다」로 보인다.** 아무도 안 한 점검이 기록이 된다.
       ⇒ **틀만** 가져온다 — 기기 행 이름 · 열 이름 · 상단 자유칸 · 병동.
         격자 값·특이사항·수리내용은 하나도 안 가져온다. 무엇을 가져오는지는 **서버 한 곳**에 적혀 있다.
     ★저장하지 않는다 — 화면에 깔아 주기만 한다. 사람이 보고 [저장]을 눌러야 문서가 생긴다. */
  window.ckPrevSeed = function(){
    if (!FORM) { _alertBox('서식을 먼저 고르세요.', {icon:'⚠️'}); return; }
    post('<c:url value="/qps/chkPrevSeed.do"/>', {
      formId: FORM.formid, inYear: gel('ckYear').value,
      inMm: usesMm() ? gel('ckMm').value : '',
      prdNo: prdNos().length ? gel('ckPrdNo').value : '',
      wardNm: val('f_wardNm')
    }).then(function(res){
      if (res.found !== 'Y') { _alertBox('가져올 지난 점검표가 없습니다.', {icon:'ℹ️'}); return; }
      var d = res.doc || {};
      // ★지금 화면의 격자 값은 **건드리지 않는다** — 적다 말고 눌렀을 때 날아가면 안 된다.
      var c = collect();
      // ★자산 열 값 합치기(2026-08-12) — 서버가 서식이 지목한 열(CARRY_YN='Y')만 골라 준다.
      //   ⚠**빈 칸에만 채운다.** 이미 친 글자를 덮으면 되돌릴 길이 없다 —
      //     collect() 가 값 있는 칸만 담으므로, 거기 없는 자리만 넣으면 된다.
      var have = {};
      c.vals.forEach(function(v){ have[v.rowno + '_' + v.colno] = true; });
      var got = 0;
      (res.vals || []).forEach(function(v){
        if (have[v.rowno + '_' + v.colno]) return;
        c.vals.push(v); got++;
      });
      renderHead(d);                       // 상단 자유칸
      if (!val('f_wardNm')) set('f_wardNm', d.wardnm || '');
      renderGrid(c.vals, res.rows || [], res.cols || []);
      _toast('지난 점검표의 틀을 가져왔습니다 — 기기명·열 이름·상단 칸' +
             (got ? (' + 자산 ' + got + '칸') : '') + '. 점검 결과는 가져오지 않습니다.', 'ok');
    }).catch(err);
  };

  /** 월 생성 — ⚠**이건 저장을 한다.** 그래서 먼저 물어본다. */
  window.ckMonthGen = function(){
    if (!FORM || FORM.prdgb !== 'D') return;
    var yy = gel('ckYear').value, mm = gel('ckMm').value;
    _confirmBox({
      msg: yy + '년 ' + Number(mm) + '월 한 달치 빈 점검표를 만들까요?<br>' +
           '<span style="font-size:12px;color:#6b7c86;">이미 있는 날은 그대로 둡니다. ' +
           '기기명·열 이름·상단 칸은 지난 점검표에서 가져오고, <b>점검 결과는 비어 있습니다.</b></span>',
      icon:'📅', okText:'만들기',
      onOk: function(){
        post('<c:url value="/qps/chkMonthGen.do"/>', {
          formId: FORM.formid, inYear: yy, inMm: mm, wardNm: val('f_wardNm')
        }).then(function(res){
          _toast(res.made + '건을 만들었습니다' +
                 (res.skipped ? (' (이미 있던 ' + res.skipped + '건은 그대로).') : '.') +
                 (res.seeded === 'N' ? ' 가져올 지난 점검표가 없어 틀은 비어 있습니다.' : ''), 'ok');
          ckBase();
        }).catch(err);
      } });
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
    /* ★★종이 폭 맞추기 (2026-08-16) — ***이 한 줄이 없으면 격자가 A4 를 넘는다.***
       인쇄는 **화면 표를 복사**해 쓰는데(따로 그리면 화면과 종이가 갈리므로 일부러 그렇게 했다),
       화면에서 날짜 칸에 박아 둔 `min-width:32px`(마우스로 누를 수 있어야 해서 필요하다)가
       종이까지 따라온다. 31일 × 39px = 1209px 라 A4 가로 안쪽(1055px)을 **16~21% 넘었다.**
       ⇒ 종이에서만 그 최소폭을 푼다. 그러면 `table{width:100%}` 가 남은 폭을 고르게 나눠
         날짜 칸이 약 6mm 로 앉는다(원본 종이와 비슷하다).
       ✅**점검표 309종 전부**를 인쇄 HTML 로 실측해 확인했다 — 고치기 전 122종 초과 → 고친 뒤 0종.
       ⚠화면 쪽 `min-width` 는 **건드리지 말 것**(누르기 어려워진다). 종이에서만 푼다. */
    'table.gr th, table.gr td{ min-width:0 !important; }' +
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
      // ★열 이름 칸(문서가 정하는 열)은 **머리글**이다 — 왼쪽 정렬로 눕히면 안 된다
      var isCn = el.hasAttribute('data-cn');
      td.textContent = String(el.value || '');
      if (!isCn && (isHd || isTxt)) td.className = 'l';
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
    // ★격자 아래 자유행 표(2026-08-13) — 화면 표를 그대로 옮기되 값 있는 줄만 찍는다
    (function(){
      var st = document.querySelector('#ckGridWrap table.sub');
      var sc = subCols();
      if (!st || !sc.length) return;
      var rows = [];
      st.querySelectorAll('tbody tr').forEach(function(tr){
        var cells = [], has = false;
        tr.querySelectorAll('input').forEach(function(el){
          var v = String(el.value || '').trim();
          if (v) has = true;
          cells.push('<td class="l">' + esc(v) + '</td>');
        });
        if (has) rows.push('<tr>' + cells.join('') + '</tr>');
      });
      if (!rows.length) return;
      var hh = '<tr>' + (FORM.subnm ? ('<th rowspan="' + (rows.length + 1) + '">' + esc(FORM.subnm) + '</th>') : '') +
               sc.map(function(nm){ return '<th>' + esc(nm) + '</th>'; }).join('') + '</tr>';
      tail += '<table style="margin-top:6px;"><thead>' + hh + '</thead><tbody>' + rows.join('') + '</tbody></table>';
    })();
    if (FORM.noteyn === 'Y') tail += '<div class="box"><b>' + esc(noteNm()) + '</b><br>' + esc(val('f_noteTxt')) + '</div>';
    if (FORM.fixyn === 'Y')  tail += '<div class="box"><b>수리날짜 및 고장 발생 내용</b><br>' + esc(val('f_fixTxt')) + '</div>';
    if (FORM.foottxt)        tail += '<div style="font-size:9px;margin-top:4px;text-align:left;">' + esc(FORM.foottxt) + '</div>';
    if (FORM.signline) {
      tail += '<div class="sig">' + String(FORM.signline).split(',').map(function(s){
                return '<span>' + esc(s.trim()) + ' _____________ (인)</span>'; }).join('') + '</div>';
    }
    tail += ckPhotoPrintHtml();   // 사진칸(2026-08-15) — 있는 칸만, 2칸씩 한 줄

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
    ckPrintFitDays(w);   // 날짜 칸이 너무 좁아지지 않게 (아래 함수 머리말 참고)

    /* 사진(blob)이 다 그려진 뒤 인쇄창을 띄운다 — 고정 300ms 로는 사진이 빈 채 찍힐 수 있다(safeRpt 전례) */
    var tries = 0;
    (function waitImg(){
      var ok = true, imgs = [];
      try { imgs = w.document.images || []; } catch (e) {}
      for (var i = 0; i < imgs.length; i++) if (!imgs[i].complete) ok = false;
      if (ok || tries++ > 40) { try { w.print(); } catch (e) {} }
      else setTimeout(waitImg, 150);
    })();
  };

  /**
   * ★날짜 칸에 최소 폭을 준다 (2026-08-16) — ***원본 종이를 보고 정한 규칙이다.***
   *
   *   폭 넘침을 고치고 나니(PRINT_CSS 의 `min-width:0`) 이번엔 **날짜 칸이 3.6~4.9mm 로 좁은
   *   서식이 23종** 남았다. 항목 이름이 길면 브라우저가 **첫 칸에 폭을 몰아주기** 때문이다.
   *
   *   ⇒ SUNWOO 원본을 꺼내 대조했다(XR02 낙상·w26 환경관리·RN31 응급키트) —
   *     ***셋 다 31일을 한 줄에 두고 끊지 않으며, 대신 항목 칸을 표의 1/4 안쪽으로 좁게 둔다.***
   *     즉 **날짜에 폭을 주고 글자 칸을 접는 것**이 원본의 방식이다. 그대로 따른다.
   *
   *   ⚠**`SPLIT_N`(15일씩 끊기)은 답이 아니다** — 원본이 끊지 않는다. 끊기는 *원본 종이가 이미
   *     나뉘어 있을 때* 쓰는 장치다(FAC001·NUR007 등 15종). 폭 맞추기 수단으로 쓰면 종이가 달라진다.
   *   ⚠**일률로 「첫 칸 26%」를 주는 방법은 못 쓴다** — 실험해 보니 PHA022 는 3.6→5.1mm 로 좋아지지만
   *     RNL027 은 4.4→3.2mm 로 **되레 나빠졌다**(앞 열이 있는 서식은 남는 폭이 그리로 간다).
   *   ★그래서 **재보고 정한다** — 최소폭을 줘 보고 ***종이를 넘기면 되돌린다.***
   *     넘침 0종을 지키는 것이 좁은 칸을 넓히는 것보다 우선이다(넘치면 잘려 나간다).
   */
  function ckPrintFitDays(w) {
    try {
      var d = w.document;
      /* 종이 안쪽 폭 — A4 가로 297mm − 여백 9mm×2. mm 로 재야 배율에 안 흔들린다. */
      var probe = d.createElement('div');
      probe.style.cssText = 'position:absolute;left:-9999px;top:0;width:279mm;';
      d.body.appendChild(probe);
      var PAGE = probe.offsetWidth;
      probe.parentNode.removeChild(probe);
      if (!PAGE) return;
      var MIN = Math.round(5 * PAGE / 279);          // 한 칸 5mm — ○ 하나 적을 만한 폭

      [].slice.call(d.querySelectorAll('table.gr')).forEach(function (t) {
        if (!t.rows.length) return;
        var days = [].slice.call(t.rows[0].cells).filter(function (c) { return c.hasAttribute('data-day'); });
        if (days.length < 8) return;                  // 날짜 격자가 아니면 손대지 않는다
        var one = days[0].getBoundingClientRect().width / (days[0].colSpan || 1);
        if (one >= MIN) return;                       // 이미 넉넉하다
        days.forEach(function (c) { c.style.width = (MIN * (c.colSpan || 1)) + 'px'; });
        if (t.scrollWidth > PAGE + 2)                 // ★넓히다 종이를 넘겼다 — 되돌린다
          days.forEach(function (c) { c.style.width = ''; });
      });
    } catch (e) { /* 인쇄를 막지 않는다 */ }
  }

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
    renderGrid(c.vals, c.rows, c.cols);
  });

  $(function(){
    // ★[서식 관리]에서 넘어왔으면 그 서식으로 연다. 사용 목록에서 꺼져 있으면 못 고르므로 안내한다.
    var want = (gel('ckForm').getAttribute('data-init') || '').trim();
    // 사이드바 「부서별 점검표」에서 넘어온 부서 — 서식 지정(want)이 있으면 서식이 우선이다
    var wantDept = (gel('ckDept').getAttribute('data-init') || '').trim();
    ckBase().then(function(){
      var sel = gel('ckForm');
      if (want && FORMS.some(function(f){ return f.formid === want; })) sel.value = want;
      else {
        if (want) {
          _alertBox('그 서식은 <b>이 병원 사용 목록에 꺼져</b> 있어 작성 화면에 나오지 않습니다.<br>' +
                    '[서식 관리]의 체크를 켜고 <b>[사용 저장]</b> 을 눌러 주세요.', {icon:'⚠️'});
        }
        var dsel = gel('ckDept');
        for (var i = 0; i < dsel.options.length; i++) {
          if (dsel.options[i].value === wantDept) { dsel.value = wantDept; break; }
        }
      }
      if (FORMS.length && !sel.value) sel.value = FORMS[0].formid;
      return ckBase();
    }).then(function(){
      // 부서로 걸렀으면 서식 목록이 갈렸다 — ⚠셀렉트는 목록이 다시 그려질 때 첫 서식을 저절로
      // 보여주므로 값 비교로는 어긋남이 안 잡힌다. 받아 둔 레이아웃(FORM)과 대조해야 한다.
      var sel = gel('ckForm');
      if (FORMS.length && !FORMS.some(function(f){ return f.formid === sel.value; })) sel.value = FORMS[0].formid;
      if (FORMS.length && (!FORM || FORM.formid !== sel.value)) return ckBase();
    }).then(function(){ renderHead({}); renderGrid([], []); });
  });
})();
</script>
</div><%-- /#qpsChk --%>
</div><%-- /.dashboard-wrapper --%>
