<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%-- qpsFall.jsp — QPS 낙상 지표 파일럿 (2026-08-08)
     · 근거: 기존 프로그램 DB 실측. 산식 = 낙상보고건수(Level2 이상) ÷ 총재원일수 × 1,000 (‰)
     · 기존 프로그램은 지표분석보고서에 사람이 '0.67‰' 를 타이핑했다. 여기서는 서버가 계산한다.
     · 탭 3개: ①사고보고 입력 ②재원일수(분모) ③지표분석(자동집계+차트+서술)
     · 라이브러리는 header.jsp 전역 로드분(jQuery/DataTables/ECharts) 사용
     · ★주의: 이 파일 안에서 Deferred EL 표기(샵+중괄호) 금지 — 변환에러로 content 타일이 빈 화면이 된다 --%>

<%-- 알림·확인 공통(_alertBox/_confirmBox/_toast) — CSS 를 스스로 주입하므로 이 한 줄이면 된다 --%>
<script src="/asset/js/ui-message.js"></script>
<%-- ECharts 는 header.jsp 전역 로드분이 아니다(적정성평가 화면들도 안 쓴다) → 이 화면에서만 로드 --%>
<script src="/asset/js/echarts/echarts.min.js"></script>

<%-- ★[반드시 유지] .dashboard-wrapper 로 감싼다 — sidebar.jsp 가 이 클래스에만 margin-left:280px 을 준다.
     이걸 빼면 화면이 left:0 에서 시작해 **왼쪽 280px 이 좌측 메뉴에 가려진다**
     (2026-08-08 실제 발생: 입력폼 첫 칸 '발생일자·환자등록번호·낙상유형'이 안 보였다.
      evalCompare.jsp 가 2026-07-28 에 겪은 것과 같은 원인).
     스크롤이 밀린 것처럼 보이지만 페이지 scrollX 는 0 이다 — 가려진 것과 밀린 것을 혼동하지 말 것. --%>
<div class="dashboard-wrapper">
<%-- data-indicd / data-incidgb : 지표를 URL(?indi=CODE)로 받는다 — 지표가 늘어도 화면은 이 하나다 --%>
<div id="qpsFall" data-hospcd="<c:out value='${hospCd}'/>" data-wnn="<c:out value='${wnnYn}'/>"
     data-indicd="<c:out value='${indiCd}' default='FALL'/>" data-incidgb="<c:out value='${incidGb}' default='FALL'/>"
     data-prd="<c:out value='${prdKey}'/>">
<style>
  #qpsFall{ background:#f4f6f8; color:#1f2a30; min-height:100%; padding:14px 16px 50px; font-family:inherit; max-width:100%; overflow-x:hidden; }
  #qpsFall *{ box-sizing:border-box; }
  #qpsFall .qf-head{ display:flex; align-items:center; gap:10px; margin-bottom:12px; flex-wrap:wrap; }
  #qpsFall .qf-title{ font-size:18px; font-weight:800; color:#20303a; display:flex; align-items:center; gap:8px; }
  #qpsFall .qf-dot{ width:10px; height:10px; border-radius:50%; background:linear-gradient(135deg,#1f5a4b,#2a7665); }
  #qpsFall .qf-sub{ font-size:12px; color:#6b7c86; }
  #qpsFall .qf-spacer{ flex:1; }
  #qpsFall .qf-hosp{ background:#e7f3ee; color:#1f5a4b; font-size:12px; font-weight:800;
      border:1px solid #cfe3da; border-radius:14px; padding:3px 11px; }
  #qpsFall select, #qpsFall input[type=text], #qpsFall input[type=number], #qpsFall input[type=date],
  #qpsFall textarea{
      border:1px solid #cfd8e0; border-radius:6px; padding:5px 8px; font-family:inherit; font-size:13px; background:#fff; }
  #qpsFall input[type=date]{ width:100%; }
  #qpsFall textarea{ width:100%; min-height:84px; resize:vertical; }
  #qpsFall .qf-btn{ border:1px solid #1f5a4b; background:#1f5a4b; color:#fff; border-radius:6px;
      padding:6px 14px; font-size:13px; font-weight:600; cursor:pointer; }
  #qpsFall .qf-btn.ghost{ background:#fff; color:#1f5a4b; }
  #qpsFall .qf-btn.warn{ background:#fff; color:#b23b3b; border-color:#e0b4b4; }
  #qpsFall .qf-btn:hover{ opacity:.9; }

  /* 탭 */
  #qpsFall .qf-tabs{ display:flex; gap:4px; border-bottom:2px solid #dfe6ea; margin-bottom:14px; }
  #qpsFall .qf-tab{ padding:9px 18px; cursor:pointer; font-size:14px; font-weight:600; color:#6b7c86;
      border:1px solid transparent; border-bottom:none; border-radius:8px 8px 0 0; margin-bottom:-2px; }
  #qpsFall .qf-tab.on{ background:#fff; color:#1f5a4b; border-color:#dfe6ea; border-bottom:2px solid #fff; }
  #qpsFall .qf-pane{ display:none; }
  #qpsFall .qf-pane.on{ display:block; }

  /* 카드 */
  #qpsFall .qf-card{ background:#fff; border:1px solid #e3e9ed; border-radius:10px; padding:14px 16px; margin-bottom:14px; }
  #qpsFall .qf-card h4{ margin:0 0 10px; font-size:14px; font-weight:800; color:#20303a; display:flex; align-items:center; gap:6px; }
  #qpsFall .qf-card h4 .qf-hint{ font-weight:500; font-size:12px; color:#8a99a3; }

  /* 표 */
  #qpsFall table.qf-grid{ width:100%; border-collapse:collapse; font-size:13px; }
  #qpsFall table.qf-grid th, #qpsFall table.qf-grid td{ border:1px solid #e0e6ea; padding:6px 8px; text-align:center; }
  #qpsFall table.qf-grid th{ background:#f2f6f8; font-weight:700; color:#43555f; }
  #qpsFall table.qf-grid td.num{ text-align:right; font-variant-numeric:tabular-nums; }
  #qpsFall table.qf-grid tr.qf-sum td{ background:#f7fbf9; font-weight:800; }
  #qpsFall .qf-scroll{ max-width:100%; overflow-x:auto; }

  /* 입력 폼 */
  #qpsFall .qf-form{ display:grid; grid-template-columns:repeat(4, minmax(150px,1fr)); gap:10px 14px; }
  #qpsFall .qf-form label{ display:block; font-size:12px; color:#6b7c86; margin-bottom:3px; font-weight:600; }
  #qpsFall .qf-form .full{ grid-column:1 / -1; }
  #qpsFall .qf-form input, #qpsFall .qf-form select{ width:100%; }

  /* 환자 입력검색 후보 목록 */
  #qpsFall .qf-pick{ display:none; position:absolute; z-index:50; left:0; right:0; top:100%;
      background:#fff; border:1px solid #cfd8e0; border-radius:6px; box-shadow:0 6px 18px rgba(0,0,0,.12);
      max-height:260px; overflow-y:auto; margin-top:2px; }
  #qpsFall .qf-pick.on{ display:block; }
  #qpsFall .qf-pick .qf-pi{ padding:6px 9px; font-size:13px; cursor:pointer; border-bottom:1px solid #f0f4f6; }
  #qpsFall .qf-pick .qf-pi:last-child{ border-bottom:none; }
  #qpsFall .qf-pick .qf-pi.sel, #qpsFall .qf-pick .qf-pi:hover{ background:#eef6f3; }
  #qpsFall .qf-pick .qf-pi .nm{ font-weight:700; color:#20303a; }
  #qpsFall .qf-pick .qf-pi .sub{ color:#7b8b95; font-size:11px; margin-left:6px; }
  #qpsFall .qf-pick .qf-pi .inh{ color:#1f5a4b; font-weight:700; font-size:11px; margin-left:6px; }
  #qpsFall .qf-pick .qf-none{ padding:8px 9px; font-size:12px; color:#8a99a3; }
  #qpsFall .qf-pickinfo{ font-size:11px; color:#1f5a4b; margin-top:3px; min-height:14px; }

  /* 환자 찾기 팝업 — 이름을 모를 때 훑어보는 용도(입력검색과 둘 다 둔다) */
  #qpsFall .qf-modal{ display:none; position:fixed; inset:0; z-index:1000; background:rgba(20,32,40,.42); }
  #qpsFall .qf-modal.on{ display:flex; align-items:center; justify-content:center; }
  #qpsFall .qf-mbox{ background:#fff; border-radius:12px; width:min(720px, 92vw); max-height:82vh;
      display:flex; flex-direction:column; box-shadow:0 18px 50px rgba(0,0,0,.28); overflow:hidden; }
  #qpsFall .qf-mhead{ padding:13px 16px; border-bottom:1px solid #e3e9ed; display:flex; align-items:center; gap:8px; }
  #qpsFall .qf-mhead b{ font-size:15px; color:#20303a; }
  #qpsFall .qf-mhead .x{ margin-left:auto; cursor:pointer; color:#8a99a3; font-size:20px; line-height:1; padding:0 4px; }
  #qpsFall .qf-msearch{ padding:11px 16px; border-bottom:1px solid #eef2f5; display:flex; gap:6px; }
  #qpsFall .qf-msearch input{ flex:1; }
  #qpsFall .qf-mbody{ overflow-y:auto; padding:0 4px 8px; }
  #qpsFall .qf-mbody table{ width:100%; border-collapse:collapse; font-size:13px; }
  /* 행 간격은 좁게 — 한 화면에 더 많이 보이는 게 고르기 편하다(2026-08-08 요청) */
  #qpsFall .qf-mbody th{ position:sticky; top:0; background:#f2f6f8; color:#43555f; font-weight:700;
      padding:5px 8px; border-bottom:1px solid #e0e6ea; text-align:left; font-size:12px; white-space:nowrap; }
  #qpsFall .qf-mbody td{ padding:3px 8px; border-bottom:1px solid #f4f7f9; line-height:1.35; white-space:nowrap; }
  #qpsFall .qf-mbody tr{ cursor:pointer; }
  #qpsFall .qf-mbody tr.sel td, #qpsFall .qf-mbody tbody tr:hover td{ background:#eef6f3; }
  #qpsFall .qf-badge{ background:#e7f3ee; color:#1f5a4b; font-size:11px; font-weight:700; border-radius:10px; padding:1px 7px; }
  #qpsFall .qf-mfoot{ padding:9px 16px; border-top:1px solid #eef2f5; font-size:12px; color:#7b8b95; }

  /* 지표 정의 박스 — ★2줄 고정(2026-08-09 요청). 5줄짜리는 화면 위쪽을 너무 먹어
       정작 봐야 할 월별 집계·분기표가 밀렸다. 첫 줄=지표명·정의, 둘째 줄=분자·분모·산식·주기 한 줄. */
  #qpsFall .qf-def{ background:#f7fbf9; border:1px solid #d9e8e2; border-radius:8px; padding:7px 11px; font-size:13px; line-height:1.55; }
  #qpsFall .qf-def b{ color:#1f5a4b; }
  #qpsFall .qf-def .qf-d1{ font-size:13.5px; }
  #qpsFall .qf-def .qf-d2{ color:#4a5c66; font-size:12.5px; margin-top:2px; }
  #qpsFall .qf-def .qf-d2 b{ color:#6b7c86; font-weight:700; margin-right:3px; }
  #qpsFall .qf-def .qf-sep{ color:#c3d3da; margin:0 7px; }
  #qpsFall .qf-def .qf-formula{ font-family:Consolas,monospace; background:#fff; border:1px solid #d9e8e2;
      border-radius:5px; padding:0 5px; display:inline-block; }
  #qpsFall .qf-warn{ background:#fff8f0; border:1px solid #f0dcc0; color:#8a5a20; border-radius:8px;
      padding:9px 12px; font-size:13px; margin-bottom:12px; }

  /* 결재 — 상태 배지와 서명칸 */
  #qpsFall .qf-badge{ font-size:12px; font-weight:800; border-radius:12px; padding:3px 12px; }
  #qpsFall .qf-badge.st-draft  { background:#eef2f5; color:#6b7c86; }
  #qpsFall .qf-badge.st-submit { background:#fdf3e2; color:#a2701f; }
  #qpsFall .qf-badge.st-reject { background:#fdeaea; color:#b23b3b; }
  #qpsFall .qf-badge.st-confirm{ background:#e4f3ea; color:#1f7a52; }
  #qpsFall #qfApprTbl td.sign{ height:56px; vertical-align:middle; line-height:1.45; }
  #qpsFall #qfApprTbl td.sign .nm{ font-weight:800; color:#20303a; font-size:13px; }
  #qpsFall #qfApprTbl td.sign .dt{ font-size:11px; color:#8a99a3; }
  #qpsFall #qfApprTbl td.sign.wait{ background:#fffdf7; }
  #qpsFall #qfApprTbl td.sign.wait .nm{ color:#b58a3a; font-weight:700; font-size:12px; }
  #qpsFall #qfChart{ width:100%; height:300px; }

  /* ★저장 안내(_toast) 위치 — 이 화면에서만 화면 '중앙'으로 올린다(2026-08-08 요청).
       공용 ui-message.js 는 bottom:34px 인데, 하단의 Q&A 말풍선·질문등록 배너에 가려
       "저장되었습니다"가 안 보였다. #qpsFall 접두어를 붙이지 않았지만 이 규칙은
       **이 JSP 가 로드된 화면에만** 적용되므로 다른 화면은 그대로다(공용 파일은 안 건드림).
       ※함께 고친 것: _toast 타입을 'success' → 'ok' 로. 공용 컴포넌트가 아는 값은
         ok/warn/err/info 뿐이라 'success' 는 배경색이 안 붙어 흰 글자만 떴다(=안 보였다). */
  .toast-wrap{ top:50% !important; bottom:auto !important; transform:translate(-50%,-50%) !important; }
  .toast-item{ font-size:16px !important; padding:14px 26px !important; }

  /* 인쇄물 CSS 는 JS 상수(PRINT_CSS)로 옮겼다 — 인쇄를 '별도 창'에서 하기 때문(아래 doPrint 주석 참고) */
  /* -- 글자 크기 (2026-08-18 요청) : QI 계획서(qpsQiPlan)와 같은 모양.같은 조작 */
  #qpsFall .zz-zoom{ display:inline-flex; gap:4px; align-items:center; margin-left:2px; margin-right:14px; }
  #qpsFall .zz-zoom button{ border:1px solid #cfd9e0; background:#fff; color:#43555f; border-radius:6px;
                        padding:4px 9px; font-size:13px; font-weight:700; cursor:pointer; }
  #qpsFall .zz-zoom button:hover{ background:#eef3f6; }
</style>

<div class="qf-head">
  <div class="qf-title"><span class="qf-dot"></span>QPS
    <c:out value="${indiNm}" default="지표"/></div>
  <%-- 흐름 안내는 지표 유형마다 다르다(관찰형은 재원일수를 안 쓴다) → indiLoad 에서 다시 쓴다 --%>
  <div class="qf-sub" id="qfFlow">사고보고 → 재원일수 → 분기 지표 자동산출</div>
  <%-- 대상 병원 — ★서버가 실제로 조회하는 병원을 그대로 찍는다(컨트롤러가 쿠키 s_hospid 로 조회).
       브라우저에서 쿠키를 읽어 표시하면 서버 기준과 어긋나도 알 수가 없다(2026-08-08 실제로 헤맸다).
       입원환자 건수까지 같이 보여주므로 '자료가 없어서 안 나오는 것'인지 한눈에 구분된다. --%>
  <span id="qfHospNm" class="qf-hosp"
        title="상단 [병원검색]으로 바꾸면 이 화면 자료도 그 병원으로 바뀝니다.">🏥
    <c:out value="${hospNm}" default="병원 미확인"/>
    (<c:out value="${hospCd}"/>) · 입원자료 <c:out value="${ipwonCnt}"/>건</span>
  <div class="qf-spacer"></div>
  <select id="qfYear"></select>
  <button type="button" class="qf-btn ghost" onclick="qfReload();">↻ 새로고침</button>
  <span style="flex:0 0 12px;"></span>
  <%-- 글자 크기 - 이 PC 이 브라우저에만 저장된다 --%>
  <span class="zz-zoom">
    <button type="button" onclick="zzZoom(-1);" title="글자 작게">가－</button>
    <button type="button" onclick="zzZoom(1);"  title="글자 크게">가＋</button>
    <button type="button" onclick="zzZoom(0);"  title="처음 크기로">↺</button>
  </span>
</div>

<div class="qf-tabs">
  <%-- 탭·폼 문구는 지표마다 다르다(낙상/투약오류/자살자해…) → incidSetupUi 가 지표코드로 바꿔 쓴다.
       여기 적힌 '낙상'은 마스터를 못 읽었을 때의 최후 기본값일 뿐이다. --%>
  <div class="qf-tab on" data-pane="p1" onclick="qfTab('p1');" id="qfTabIncid">📋 낙상 사고보고</div>
  <div class="qf-tab"    data-pane="p4" onclick="qfTab('p4');" style="display:none;">🧼 관찰 입력</div>
  <div class="qf-tab"    data-pane="p5" onclick="qfTab('p5');" style="display:none;">✍ 월별 입력</div>
  <div class="qf-tab"    data-pane="p2" onclick="qfTab('p2');">🛏 재원일수(분모)</div>
  <div class="qf-tab"    data-pane="p3" onclick="qfTab('p3');">📈 지표분석</div>
</div>

<!-- ================= 탭5 : 월별 수기입력 (MANUAL 지표) =================
     원천이 위너넷 안에 없는 지표 — 병원이 대장(신체보호대 사용대장·TAT 관리대장·
     불만고충 처리대장·설문결과)을 보고 월별 숫자를 옮겨 적는다. -->
<div class="qf-pane" id="p5">
  <div class="qf-card">
    <h4 id="qfManTitle">월별 입력 <span class="qf-hint">— 대장·설문 결과를 월별로 옮겨 적는다</span></h4>
    <div class="qf-scroll">
      <table class="qf-grid" style="min-width:860px;">
        <thead><tr id="qfManHead"></tr></thead>
        <tbody>
          <tr id="qfManNumer"></tr>
          <tr id="qfManDenom"></tr>
        </tbody>
      </table>
    </div>
    <div style="margin-top:12px; display:flex; gap:8px; align-items:center; flex-wrap:wrap;">
      <button type="button" class="qf-btn" onclick="qfManualSave();">저장</button>
      <span class="qf-sub" id="qfManHint">비워두면 그 달은 '자료 없음'(지표 '-', 0과 구분).</span>
    </div>
  </div>
</div>

<!-- ================= 탭1 : 사고보고 ================= -->
<div class="qf-pane on" id="p1">
  <div class="qf-card">
    <h4 id="qfIncidTitle">낙상 사고 등록 <span class="qf-hint">— 위해등급 Level 2 이상만 지표 분자에 들어간다</span></h4>
    <input type="hidden" id="f_incidSeq" value="">
    <div class="qf-form">
      <%-- 달력 선택(2026-08-08 요청) — 브라우저 내장 date. 값이 YYYY-MM-DD 라 저장(REPLACE '-')·
           환자검색 baseDt·목록 재로드(occurdtfmt) 모두 기존 코드와 그대로 호환된다. --%>
      <div><label>발생일자 *</label><input type="date" id="f_occurDt"></div>
      <div><label>발생시각</label><input type="text" id="f_occurTm" placeholder="HHMM" maxlength="4"></div>
      <div><label>병동</label><input type="text" id="f_wardCd" maxlength="20"></div>
      <div><label>보고부서</label><input type="text" id="f_rptDept" maxlength="50"></div>

      <%-- 환자 = 위너넷 입원환자(TBL_IPWON_INFO) 입력검색. 등록번호·성명 아무거나 치면 후보가 뜬다.
           고르면 성명·성별·나이·병동이 자동으로 채워진다. 목록에 없는 대상(외래 등)은 직접 입력해도 된다. --%>
      <div style="position:relative;">
        <%-- 직원안전사고는 대상이 환자가 아니다 → 라벨을 바꾸고 입원환자 [찾기]는 감춘다(incidSetupUi) --%>
        <label id="qfPtLab">환자 (등록번호·성명)</label>
        <div style="display:flex; gap:5px;">
          <input type="text" id="f_ptNo" maxlength="30" autocomplete="off" style="flex:1; min-width:0;"
                 placeholder="직접 입력 또는 [찾기]"
                 onkeydown="qfPatKey(event);" oninput="qfPatSearch();" onfocus="qfPatSearch(true);">
          <button type="button" class="qf-btn ghost" id="qfPtFindBtn" style="padding:5px 10px; white-space:nowrap;"
                  onclick="qfPatOpen();">🔍 찾기</button>
        </div>
        <div id="qfPatBox" class="qf-pick"></div>
        <div id="qfPatInfo" class="qf-pickinfo"></div>
      </div>
      <div><label>성별</label>
        <select id="f_ptSex"><option value="">선택</option><option value="M">남</option><option value="F">여</option></select></div>
      <div><label>나이</label><input type="number" id="f_ptAge" min="0" max="120"></div>
      <div><label id="qfLevelLab">위해등급 (분자기준)</label>
        <select id="f_levelCd">
          <option value="">선택</option>
          <option value="LV1">Level 1 (위해없음)</option>
          <option value="LV2">Level 2 (경미)</option>
          <option value="LV3">Level 3 (중등도)</option>
          <option value="LV4">Level 4 (중증)</option>
          <option value="LV5">Level 5 (사망)</option>
        </select></div>

      <%-- 하위유형 목록은 지표마다 다르다 → incidSetupUi 가 통째로 갈아 끼운다(여기 값은 낙상 기본) --%>
      <div><label id="qfSubLab">낙상유형</label>
        <select id="f_subtypeCd"><option value="">선택</option>
          <option>침대</option><option>보행중</option><option>휠체어</option><option>화장실</option><option>의자</option><option>기타</option></select></div>
      <div><label>발생장소</label>
        <select id="f_placeCd"><option value="">선택</option>
          <option>병실</option><option>복도</option><option>화장실</option><option>치료실</option><option>검사실</option><option>기타</option></select></div>
      <div><label>손상유형</label>
        <select id="f_damageCd"><option value="">선택</option>
          <option>없음</option><option>찰과상</option><option>열상</option><option>타박상</option><option>골절</option><option>기타</option></select></div>
      <div><label>보고자</label><input type="text" id="f_rptUser" maxlength="50"></div>

      <div class="full"><label>발생경위</label><textarea id="f_causeTxt" style="min-height:56px;"></textarea></div>
      <div class="full"><label>조치사항</label><textarea id="f_actionTxt" style="min-height:56px;"></textarea></div>
    </div>
    <div style="margin-top:12px; display:flex; gap:8px;">
      <button type="button" class="qf-btn" onclick="qfIncidentSave();">저장</button>
      <button type="button" class="qf-btn ghost" onclick="qfIncidentClear();">신규</button>
      <button type="button" class="qf-btn warn" onclick="qfIncidentDelete();">삭제</button>
    </div>
  </div>

  <div class="qf-card">
    <h4>사고 목록 <span class="qf-hint">— 행을 클릭하면 위 폼에 불러온다</span></h4>
    <div class="qf-scroll">
      <table id="qfIncidTbl" class="display compact" style="width:100%">
        <thead><tr>
          <th>발생일</th><th>시각</th><th>병동</th><th>성명</th><th>등록번호</th><th>성별</th><th>나이</th>
          <th>등급</th><th>유형</th><th>장소</th><th>손상</th><th>보고부서</th><th>수정일시</th>
        </tr></thead>
        <tbody></tbody>
      </table>
    </div>
  </div>
</div>

<%-- 환자 찾기 팝업 — 이름을 모를 때 훑어보는 용도. 입력검색과 같은 엔드포인트를 쓴다. --%>
<%-- ★배경(어두운 곳)을 눌러도 닫히지 않는다 — 고르는 중에 잘못 눌러 창이 사라지면 처음부터 다시다.
     닫는 길은 **[선택](행 클릭·Enter) 아니면 [×]·ESC** 둘뿐이다(2026-08-08 요청). --%>
<div class="qf-modal" id="qfPatModal">
  <div class="qf-mbox">
    <div class="qf-mhead">
      <b>🔍 환자 찾기</b>
      <%-- ★'위너넷 입원환자 자료' 라고 쓰면 틀린다 — 실제로는 **선택된 병원**의 입원환자다.
           상단 [병원검색]으로 바뀌는 값이라 반드시 병원명을 찍는다(2026-08-08 지적). --%>
      <span class="qf-sub" id="qfPatModalSub"><c:out value="${hospNm}" default="선택 병원"/> 입원환자 자료</span>
      <span class="x" onclick="qfPatModalClose();" title="닫기(ESC)">&times;</span>
    </div>
    <div class="qf-msearch">
      <input type="text" id="qfPatKw" placeholder="이름·등록번호 앞부분 — 비워두면 최근 입원환자"
             onkeydown="qfPatModalKey(event);" oninput="qfPatModalSearch();">
      <button type="button" class="qf-btn" onclick="qfPatModalSearch(true);">검색</button>
    </div>
    <div class="qf-mbody">
      <table>
        <thead><tr><th>성명</th><th>등록번호</th><th>병동/병실</th><th>성별</th><th>나이</th><th>입원일</th><th>상태</th></tr></thead>
        <tbody id="qfPatRows"></tbody>
      </table>
    </div>
    <div class="qf-mfoot" id="qfPatFoot">행을 클릭하면 선택됩니다. ↑↓ 이동 · Enter 선택 · ESC 닫기</div>
  </div>
</div>

<!-- ================= 탭4 : 관찰 입력 (손위생 등 MONITOR 지표) ================= -->
<div class="qf-pane" id="p4">
  <div class="qf-card">
    <%-- ★'순간(moment)'은 손위생(WHO 5 moments) 전용이다 — 격리·강박에서는 칸도 분류표도 감춘다.
         분모의 이름도 다르다: 손위생=관찰건수 / 격리·강박=시행건수(마스터 DENOM_DESC 와 맞춘다). --%>
    <h4>관찰 기록 등록 <span class="qf-hint" id="qfMonFormHint">— 분자=수행건수, 분모=관찰건수(수행률 = 수행÷관찰 ×100)</span></h4>
    <input type="hidden" id="m_monSeq" value="">
    <div class="qf-form">
      <div><label>관찰일 *</label><input type="date" id="m_obsDt"></div>
      <div><label>병동</label><input type="text" id="m_wardCd" maxlength="20"></div>
      <div><label>직군</label>
        <select id="m_jobGb"><option value="">선택</option>
          <option>의사</option><option>간호사</option><option>간호조무사</option><option>물리치료사</option><option>기타</option></select></div>
      <div id="m_momentWrap"><label>순간(moment)</label>
        <select id="m_momentCd"><option value="">선택</option>
          <option>환자 접촉 전</option><option>청결/무균 처치 전</option><option>체액 노출 후</option>
          <option>환자 접촉 후</option><option>환자 주변 접촉 후</option></select></div>
      <div><label id="m_obsCntLab">관찰건수 (분모) *</label><input type="number" id="m_obsCnt" min="0"></div>
      <div><label>수행건수 (분자) *</label><input type="number" id="m_passCnt" min="0"></div>
      <div><label>관찰자</label><input type="text" id="m_observer" maxlength="50"></div>
      <div class="full"><label>비고</label><textarea id="m_note" style="min-height:56px;"></textarea></div>
    </div>
    <div style="margin-top:12px; display:flex; gap:8px;">
      <button type="button" class="qf-btn" onclick="qfMonitorSave();">저장</button>
      <button type="button" class="qf-btn ghost" onclick="qfMonitorClear();">신규</button>
      <button type="button" class="qf-btn warn" onclick="qfMonitorDelete();">삭제</button>
    </div>
  </div>
  <div class="qf-card">
    <h4>관찰 목록 <span class="qf-hint">— 행을 클릭하면 위 폼에 불러온다</span></h4>
    <div class="qf-scroll">
      <table id="qfMonTbl" class="display compact" style="width:100%">
        <thead><tr><th>관찰일</th><th>병동</th><th>직군</th><th>순간</th><th id="qfMonThObs">관찰</th><th>수행</th><th>수행률</th><th>관찰자</th><th>수정일시</th></tr></thead>
        <tbody></tbody>
      </table>
    </div>
  </div>
</div>

<!-- ================= 탭2 : 분모 ================= -->
<div class="qf-pane" id="p2">
  <div class="qf-card">
    <%-- ★분모의 종류는 지표마다 다르다(마스터 DENOM_GB): INDAYS=총재원일수 / STAFF=직원수.
         제목·라벨·저장구분을 지표에 맞춰 바꾸지 않으면 직원안전사고처럼 STAFF 분모를 쓰는 지표는
         재원일수 칸에 저장돼 **영원히 분모 0(지표 '-')** 이 된다(2026-08-09 발견). --%>
    <h4 id="qfCensusTitle">월별 총재원일수 <span class="qf-hint">— 지표의 분모(해당 월 일일 재원환자 수의 합)</span></h4>
    <div class="qf-scroll">
      <table class="qf-grid" style="min-width:760px;">
        <thead><tr id="qfCensusHead"></tr></thead>
        <tbody><tr id="qfCensusBody"></tr></tbody>
      </table>
    </div>
    <div style="margin-top:12px; display:flex; gap:8px; align-items:center; flex-wrap:wrap;">
      <button type="button" class="qf-btn" onclick="qfCensusSave();">저장</button>
      <%-- 자동산출(2026-08-08) — 칸만 채우고 저장은 사람이 한다. 재원중 환자는 오늘까지만 세므로
           자료 마지막 월 이후는 부풀 수 있다 → 확인 후 저장이 전제. --%>
      <button type="button" class="qf-btn ghost" id="qfCensusCalcBtn" onclick="qfCensusCalc();">⚙ 입퇴원 자료로 자동계산</button>
      <span class="qf-sub" id="qfCensusHint">비워두면 그 달은 '자료 없음'(지표 '-', 발생 0과 구분).
        자동계산 기준: 입원일 포함·퇴원일 제외, 재원중은 오늘까지 — 값 확인 후 [저장].</span>
    </div>
  </div>
</div>

<!-- ================= 탭3 : 지표분석 ================= -->
<div class="qf-pane" id="p3">
  <div id="qfNoCensus" class="qf-warn" style="display:none;">
    재원일수(분모)가 등록되지 않았습니다. <b>[재원일수(분모)]</b> 탭에서 먼저 입력해 주세요.
  </div>

  <div class="qf-card">
    <h4>지표 정의</h4>
    <div class="qf-def" id="qfDef">불러오는 중…</div>
  </div>

  <div class="qf-card">
    <h4>월별 집계 <span class="qf-hint">— 분자·분모에서 서버가 산출한 값(수기입력 아님)</span></h4>
    <div class="qf-scroll">
      <table class="qf-grid" style="min-width:900px;">
        <thead><tr id="qfMonHead"></tr></thead>
        <tbody>
          <tr id="qfMonNumer"></tr>
          <tr id="qfMonDenom"></tr>
          <tr id="qfMonRate"></tr>
        </tbody>
      </table>
    </div>
  </div>

  <div class="qf-card">
    <h4>분기·반기·연간</h4>
    <div class="qf-scroll">
      <table class="qf-grid" style="min-width:600px;">
        <thead><tr id="qfQtrHead"></tr></thead>
        <tbody id="qfQtrBody"></tbody>
      </table>
    </div>
  </div>

  <div class="qf-card">
    <h4>추이</h4>
    <div id="qfChart"></div>
  </div>

  <div class="qf-card">
    <h4>분류별 집계 <span class="qf-hint" id="qfBreakHint">— 사고보고에서 자동 집계(분자와 같은 기준)</span></h4>
    <div id="qfBreak" class="qf-scroll" style="display:flex; gap:14px; flex-wrap:wrap;"></div>
  </div>

  <div class="qf-card">
    <%-- ★"저장 버튼이 있으니 눌러야 하나?" 로 헷갈렸다(2026-08-08 지적).
         위 수치는 저장 대상이 아니고(매번 산출), 여기 '글'만 저장된다는 걸 제목에서 못 박는다. --%>
    <h4>지표분석보고서 — 서술만 작성
      <span class="qf-hint">위 수치는 저장하지 않아도 됩니다. 매번 다시 계산됩니다.</span></h4>
    <div style="display:flex; gap:10px; align-items:center; margin-bottom:10px;">
      <label style="font-size:12px; color:#6b7c86; font-weight:600;">기간</label>
      <select id="qfPrdKey" onchange="qfReportLoad();"></select>
      <span class="qf-sub" id="qfRptStat"></span>
    </div>
    <div class="qf-form">
      <div><label>개선활동 1</label><input type="text" id="r_act1"></div>
      <div><label>개선활동 2</label><input type="text" id="r_act2"></div>
      <div><label>개선활동 3</label><input type="text" id="r_act3"></div>
      <div><label>개선활동 4</label><input type="text" id="r_act4"></div>
      <div class="full"><label>분석</label><textarea id="r_analysis"></textarea></div>
      <div class="full"><label>개선계획</label><textarea id="r_plan"></textarea></div>
    </div>
    <div style="margin-top:12px; display:flex; align-items:center; gap:10px;">
      <button type="button" class="qf-btn" id="qfRptSaveBtn" onclick="qfReportSave();">서술 저장</button>
      <span class="qf-sub">분석·개선계획을 남겨둘 때만 누르면 됩니다. 안 눌러도 지표 수치에는 영향이 없습니다.</span>
    </div>
  </div>

  <%-- ================= 결재 =================
       ★'결재'는 승인 절차다(決裁) — 요금 결제(決濟)가 아니다.
       ★단계 수는 마스터(TBL_QPS_APPR_LINE)가 정한다. 기본 4단계(담당·팀장·부서장·이사장)이고
         병원이 줄이면 그 병원 행만 바꾸면 된다 — 화면·자바는 안 고친다. --%>
  <div class="qf-card">
    <h4>결재 <span class="qf-hint" id="qfApprHint">— 상신하면 단계별로 승인합니다. 결재 중에는 서술을 고칠 수 없습니다.</span></h4>

    <div style="display:flex; align-items:center; gap:10px; flex-wrap:wrap; margin-bottom:10px;">
      <span id="qfApprStatus" class="qf-badge">작성중</span>
      <span class="qf-sub" id="qfApprGuide"></span>
      <div class="qf-spacer" style="flex:1;"></div>
      <button type="button" class="qf-btn"       id="qfBtnSubmit"  onclick="qfApprAct('SUBMIT');">상신</button>
      <button type="button" class="qf-btn ghost" id="qfBtnCancel"  onclick="qfApprAct('CANCEL');">상신 회수</button>
      <button type="button" class="qf-btn"       id="qfBtnApprove" onclick="qfApprAct('APPROVE');">승인</button>
      <button type="button" class="qf-btn warn"  id="qfBtnReject"  onclick="qfApprAct('REJECT');">반려</button>
      <button type="button" class="qf-btn warn"  id="qfBtnReopen"  onclick="qfApprAct('REOPEN');">확정 취소</button>
      <button type="button" class="qf-btn ghost" id="qfBtnLine"    onclick="qfApprLineEdit();">결재선 설정</button>
      <button type="button" class="qf-btn ghost" id="qfBtnPrint"   onclick="qfPrint();">🖨 인쇄(A4)</button>
    </div>

    <div class="qf-scroll">
      <table class="qf-grid" id="qfApprTbl" style="min-width:520px; max-width:760px;">
        <thead><tr id="qfApprHead"></tr></thead>
        <tbody><tr id="qfApprBody"></tr></tbody>
      </table>
    </div>

    <div style="margin-top:10px;">
      <div class="qf-sub" style="margin-bottom:4px;">결재 이력</div>
      <div class="qf-scroll">
        <table class="qf-grid" style="min-width:620px;">
          <thead><tr><th style="width:150px;">일시</th><th style="width:90px;">단계</th><th style="width:90px;">동작</th><th style="width:110px;">처리자</th><th>사유·비고</th></tr></thead>
          <tbody id="qfApprHist"></tbody>
        </table>
      </div>
    </div>
  </div>
</div>

<script>
(function(){
  var $root   = document.getElementById('qpsFall');
  var HOSP_CD = $root.getAttribute('data-hospcd') || '';
  var INDI_CD = $root.getAttribute('data-indicd')  || 'FALL';
  var INCID_GB= $root.getAttribute('data-incidgb') || INDI_CD;
  var WNN_YN  = $root.getAttribute('data-wnn')     || 'N';   // 위너넷 여부 — 결재선 설정 버튼 노출에 쓴다
  // ★인쇄물에 찍을 병원명 — 화면 로드값이 아니라 **매 조회마다 서버 응답(indiCalc.hosp)** 으로 갱신한다.
  //   로드 시점 값을 쓰면 병원을 바꾼 뒤 새로고침 없이 인쇄할 때 옛 병원명이 찍힌다.
  var HOSP_NM = '';
  var MONTHS  = ['01','02','03','04','05','06','07','08','09','10','11','12'];
  // ★incidRaw 는 모듈 스코프여야 한다 — 행 클릭 핸들러는 한 번만 붙는데,
  //   목록을 다시 불러올 때마다 새 배열을 지역변수에 담으면 핸들러가 낡은 배열을 계속 본다(선택 시 옛 자료).
  var dtIncid = null, chart = null, curDef = null, incidRaw = [], lastCalc = null;
  var dtMon = null, monRaw = [];   // 관찰형(손위생) 목록

  // ---------- 공통 ----------
  // ★hospCd 를 보내지 않는다 — 서버가 매 요청마다 쿠키(s_hospid)를 본다.
  //   상단 [병원검색]으로 병원을 바꾸면 쿠키가 바뀌므로 **자동으로 그 병원 자료가 나온다**.
  //   화면이 로드 시점 값을 들고 있으면 병원을 바꿔도 옛 병원을 계속 조회한다(2026-08-08 실제 발생).
  //   ★dataType:'json' 을 반드시 명시한다 — 서버가 Content-Type 을 application/json 으로
  //     내려주지 않으면 jQuery 가 응답을 **문자열 그대로** 준다. 그러면 res.list 가 undefined 라
  //     "데이터는 왔는데 화면은 0건" 이 된다(2026-08-08 실제 발생, 원인 찾는 데 오래 걸렸다).
  function post(url, data){
    return $.ajax({ url: url, type: 'POST', data: data, dataType: 'json' }).then(function(res){
      if (res && res.result === 'FAIL') { throw new Error(res.message || '처리에 실패했습니다.'); }
      return res;
    });
  }
  function err(e){ _alertBox((e && e.message) ? e.message : '처리 중 오류가 발생했습니다.', {icon:'❌'}); }
  function val(id){ var el = document.getElementById(id); return el ? el.value.trim() : ''; }
  function set(id, v){ var el = document.getElementById(id); if (el) el.value = (v == null ? '' : v); }
  function year(){ return document.getElementById('qfYear').value; }
  function esc(s){ return (s==null?'':String(s)).replace(/[&<>"]/g, function(c){
      return ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;'})[c]; }); }
  function num(v){ return (v==null||v==='') ? '' : Number(v).toLocaleString(); }
  function show(sel, on){ var el = document.querySelector(sel); if (el) el.style.display = on ? '' : 'none'; }

  // 년도 셀렉트
  (function(){
    var sel = document.getElementById('qfYear'), y = new Date().getFullYear();
    for (var i = y + 1; i >= y - 4; i--) sel.add(new Option(i + '년', i));
    sel.value = y;
    // ★함수를 감싸서 '호출 시점'에 찾게 한다 — qfReload 는 이 아래에서 정의되므로
    //   여기서 이름을 그대로 쓰면 ReferenceError 가 나고 **이 스크립트 전체가 중단**된다
    //   (그러면 [찾기]·탭·저장까지 전부 죽는다. 2026-08-08 실제 발생).
    sel.onchange = function(){ qfReload(); };
  })();

  // ---------- 탭 ----------
  window.qfTab = function(id){
    $('#qpsFall .qf-tab').removeClass('on');
    $('#qpsFall .qf-tab[data-pane="' + id + '"]').addClass('on');
    $('#qpsFall .qf-pane').removeClass('on');
    $('#' + id).addClass('on');
    if (id === 'p3' && chart) setTimeout(function(){ chart.resize(); }, 30);
  };

  // ---------- 탭1 : 사고보고 ----------
  // ★사고보고형은 낙상 말고도 5종이 더 있다(환자안전·투약·학대폭력·자살자해·직원안전).
  //   화면이 '낙상'으로 하드코딩돼 있으면 투약오류를 열어도 '낙상 사고 등록 / 낙상유형 : 침대·휠체어'가
  //   나온다 — 관찰형에서 겪은 것과 같은 문제라 같은 방식으로 지표코드에 따라 갈아 끼운다.
  //   ※등급 정책(2026-08-09 확정): 낙상만 Level 2 이상, 나머지는 전건. 판정은 서버(마스터 MIN_LEVEL)가
  //     하고 여기서는 '무엇이 분자에 들어가는지'를 안내만 한다.
  var INCID_UI = {
    FALL:       { nm:'낙상',          subLab:'낙상유형', tab:'낙상 사고보고', title:'낙상 사고 등록',
                  subs:['침대','보행중','휠체어','화장실','의자','기타'] },
    PTSAFE:     { nm:'환자안전사고',  subLab:'사고유형',
                  subs:['낙상','투약','자살·자해','수혈','검사·시술','감염','질식','탈원','기타'] },
    MEDICATION: { nm:'투약오류',      subLab:'오류유형',
                  subs:['처방','조제','투여','모니터링','기타'] },
    ABUSE:      { nm:'학대·폭력사건', subLab:'사건유형',
                  subs:['신체적','언어적·정서적','성적','방임','환자간','보호자','기타'] },
    SUICIDE:    { nm:'자살·자해',     subLab:'유형',
                  subs:['자해','자살시도','자살','기타'] },
    STAFFSAFE:  { nm:'직원안전사고',  subLab:'사고유형', person:'직원',
                  subs:['주사침 자상','감염노출','낙상','근골격계','폭행·폭언','화학물질','기타'] }
  };
  function incidSetupUi(def){
    var u = INCID_UI[INDI_CD] || { nm: (def && def.indinm) ? def.indinm : '사고', subLab:'유형', subs:['기타'] };
    var minLv  = (def && def.minlevel != null && String(def.minlevel) !== '') ? String(def.minlevel) : '';
    var isStaff = (u.person === '직원');

    var tab = document.getElementById('qfTabIncid');
    if (tab) tab.textContent = '📋 ' + (u.tab || (u.nm + ' 보고'));
    var ttl = document.getElementById('qfIncidTitle');
    if (ttl) ttl.innerHTML = esc(u.title || (u.nm + ' 등록')) + ' <span class="qf-hint">— ' +
      (minLv ? ('위해등급 Level ' + esc(minLv) + ' 이상만 지표 분자에 들어간다')
             : '보고된 전건이 지표 분자에 들어간다(위해등급은 분석용)') + '</span>';
    var lvLab = document.getElementById('qfLevelLab');
    if (lvLab) lvLab.textContent = minLv ? '위해등급 (분자기준)' : '위해등급';

    var subLab = document.getElementById('qfSubLab');
    if (subLab) subLab.textContent = u.subLab;
    var sub = document.getElementById('f_subtypeCd');
    if (sub) {
      // 유형 목록: 공통코드(QPS_SUB_지표코드)가 있으면 그것, 없으면 하드코딩 폴백(u.subs)
      var rows = codeRows('QPS_SUB_' + INDI_CD);
      var items = rows.length ? rows
                : u.subs.map(function(s){ return { subcode: s, subcodenm: s }; });
      var keep = sub.value;                       // 수정 중이던 값은 지키고 목록만 교체
      sub.innerHTML = '<option value="">선택</option>' +
        items.map(function(r){ return '<option value="' + esc(r.subcode) + '">' + esc(r.subcodenm) + '</option>'; }).join('');
      if (keep) {
        var has = items.some(function(r){ return String(r.subcode) === keep; });
        if (!has) sub.insertAdjacentHTML('beforeend', '<option>' + esc(keep) + '</option>');
        sub.value = keep;
      }
    }
    // 직원안전사고는 대상이 직원이라 입원환자 검색이 성립하지 않는다
    var ptLab = document.getElementById('qfPtLab');
    if (ptLab) ptLab.textContent = isStaff ? '대상 직원 (성명·사번)' : '환자 (등록번호·성명)';
    show('#qfPtFindBtn', !isStaff);
    var ptIn = document.getElementById('f_ptNo');
    if (ptIn) ptIn.placeholder = isStaff ? '직접 입력' : '직접 입력 또는 [찾기]';
  }
  function incidLoad(){
    return post('/qps/incidentList.do', { incidGb: INCID_GB, inYear: year() }).then(function(res){
      var rows = (res.list || []).map(function(r){
        return [ r.occurdtfmt || r.occurdt, r.occurtm || '', r.wardcd || '', r.ptnm || '', r.ptno || '',
                 r.ptsex === 'M' ? '남' : (r.ptsex === 'F' ? '여' : ''), r.ptage == null ? '' : r.ptage,
                 (r.levelcd || '').replace('LV','Level '), r.subtypecd || '', r.placecd || '',
                 r.damagecd || '', r.rptdept || '', r.upddttm || '' ];
      });
      incidRaw = res.list || [];
      if (dtIncid) { dtIncid.clear(); dtIncid.rows.add(rows); dtIncid.draw(false); }
      else {
        dtIncid = $('#qfIncidTbl').DataTable({
          data: rows, pageLength: 10, order: [[0,'desc']],
          language: { emptyTable: '등록된 사고가 없습니다.', search: '검색:', lengthMenu: '_MENU_ 건씩',
                      info: '전체 _TOTAL_ 건 중 _START_–_END_', paginate: { previous: '이전', next: '다음' } }
        });
        $('#qfIncidTbl tbody').on('click', 'tr', function(){
          var idx = dtIncid.row(this).index();
          if (idx != null && incidRaw[idx]) fillForm(incidRaw[idx]);
        });
      }
    });
  }
  function fillForm(r){
    set('f_incidSeq', r.incidseq);
    set('f_occurDt', r.occurdtfmt || r.occurdt);
    set('f_occurTm', r.occurtm); set('f_wardCd', r.wardcd); set('f_rptDept', r.rptdept);
    set('f_ptNo', r.ptno); set('f_ptSex', r.ptsex); set('f_ptAge', r.ptage);
    set('f_levelCd', r.levelcd); set('f_subtypeCd', r.subtypecd);
    set('f_placeCd', r.placecd); set('f_damageCd', r.damagecd);
    set('f_causeTxt', r.causetxt); set('f_actionTxt', r.actiontxt); set('f_rptUser', r.rptuser);
  }
  // ---------- 환자 입력검색 (위너넷 입원환자 연계) ----------
  // ★환자 자료를 QPS 가 따로 갖지 않는다 — TBL_IPWON_INFO 에서 고르고 등록번호만 저장한다.
  //   주민번호는 서버 SQL 안에서만 쓰이고 내려오지 않는다(성별·나이만 파생돼 온다).
  var patTimer = null, patList = [], patSel = -1;
  function patBox(){ return document.getElementById('qfPatBox'); }
  function patClose(){ patBox().classList.remove('on'); patSel = -1; }
  function patInfo(txt, warn){
    var el = document.getElementById('qfPatInfo');
    el.textContent = txt || '';
    el.style.color = warn ? '#b23b3b' : '#1f5a4b';
  }
  // onFocus=true 로 부르면 빈 칸이어도 최근 입원환자를 바로 펼친다
  //   — "무엇을 쳐야 하는지" 몰라 검색이 안 되는 것처럼 보였던 문제(2026-08-08 사용자 지적) 대응.
  window.qfPatSearch = function(onFocus){
    // 직원안전사고의 대상은 입원환자가 아니다 — 입력검색 자체를 돌리지 않는다(엉뚱한 환자가 뜬다)
    if (INDI_CD === 'STAFFSAFE') return;
    patInfo('');
    var kw = val('f_ptNo');
    if (patTimer) clearTimeout(patTimer);
    if (!kw.length && !onFocus) { patClose(); return; }
    var box = patBox();
    box.innerHTML = '<div class="qf-none">찾는 중…</div>';   // 응답 전에도 반응이 보이게
    box.classList.add('on');
    // 한 글자마다 때리지 않는다(입력 중에는 250ms 모아서 한 번)
    patTimer = setTimeout(function(){
      post('/qps/patientSearch.do', { keyword: kw, baseDt: val('f_occurDt') }).then(function(res){
        patList = res.list || [];
        if (!patList.length) {
          box.innerHTML = '<div class="qf-none">' +
            (kw ? ('&#39;' + esc(kw) + '&#39; 로 찾은 입원환자가 없습니다.') : '등록된 입원환자 자료가 없습니다.') +
            '<br>이 칸에 직접 입력해도 저장됩니다.</div>';
        } else {
          box.innerHTML = patList.map(function(p, i){
            var ward = p.wardnm || p.roomnm || '';
            var sex  = p.ptsex === 'M' ? '남' : (p.ptsex === 'F' ? '여' : '');
            var sub  = [ward, sex + (p.ptage != null ? (' ' + p.ptage + '세') : ''), '입원 ' + fmtDt(p.ipwondt)]
                       .filter(function(s){ return s && s.trim(); }).join(' · ');
            return '<div class="qf-pi" data-i="' + i + '" onclick="qfPatPick(' + i + ');">' +
                   '<span class="nm">' + esc(p.ptnm || '') + '</span>' +
                   '<span class="sub">' + esc(p.ptno) + '</span>' +
                   (p.inhospyn === 'Y' ? '<span class="inh">재원중</span>' : '') +
                   '<div class="sub" style="margin:1px 0 0 0;">' + esc(sub) + '</div></div>';
          }).join('');
        }
        box.classList.add('on');
        patSel = -1;
      }).catch(function(e){
        // 실패해도 '찾는 중…' 이 남아 있으면 안 된다 — 왜 안 되는지 칸 안에서 알려준다
        box.innerHTML = '<div class="qf-none">환자 조회에 실패했습니다. 직접 입력해도 저장됩니다.</div>';
        box.classList.add('on');
        err(e);
      });
    }, 250);
  };
  function fmtDt(d){ return (d && d.length === 8) ? (d.substr(0,4) + '-' + d.substr(4,2) + '-' + d.substr(6,2)) : (d || ''); }
  window.qfPatPick = function(i){
    var p = patList[i];
    if (!p) return;
    set('f_ptNo', p.ptno);
    if (p.ptsex) set('f_ptSex', p.ptsex);
    if (p.ptage != null) set('f_ptAge', p.ptage);
    var ward = p.wardnm || p.roomnm || '';
    if (ward && !val('f_wardCd')) set('f_wardCd', ward);
    patClose();
    patInfo('✓ ' + (p.ptnm || '') + ' · ' + (ward || '병동미상') +
            (p.inhospyn === 'Y' ? ' · 재원중' : ' · 퇴원 ' + fmtDt(p.tewondt)),
            p.inhospyn !== 'Y');
  };
  window.qfPatKey = function(ev){
    var box = patBox();
    if (!box.classList.contains('on')) return;
    var items = box.querySelectorAll('.qf-pi');
    if (ev.key === 'ArrowDown' || ev.key === 'ArrowUp') {
      ev.preventDefault();
      if (!items.length) return;
      patSel += (ev.key === 'ArrowDown' ? 1 : -1);
      if (patSel < 0) patSel = items.length - 1;
      if (patSel >= items.length) patSel = 0;
      for (var i = 0; i < items.length; i++) items[i].classList.toggle('sel', i === patSel);
      items[patSel].scrollIntoView({ block: 'nearest' });
    } else if (ev.key === 'Enter') {
      if (patSel >= 0) { ev.preventDefault(); qfPatPick(patSel); }
    } else if (ev.key === 'Escape') {
      // 한글 조합 중 ESC 는 IME 취소이므로 조합 중이면 건드리지 않는다
      if (!ev.isComposing) { ev.preventDefault(); patClose(); }
    }
  };
  document.addEventListener('click', function(ev){
    if (!ev.target.closest || !ev.target.closest('#qfPatBox, #f_ptNo')) patClose();
  });

  // ---------- 환자 찾기 팝업 ([찾기] 버튼) ----------
  // 입력검색은 '아는 환자를 빨리', 이 팝업은 '이름을 몰라 훑어볼 때'. 둘 다 같은 엔드포인트를 쓴다.
  var mList = [], mSel = -1, mTimer = null;
  window.qfPatOpen = function(){
    document.getElementById('qfPatModal').classList.add('on');
    // ★검색어를 비우고 연다 — 칸에 남아 있던 글자로 검색하면 '눌러도 아무도 안 뜨는' 상태가 된다
    //   (2026-08-08 실제: 칸의 '노효' 로 검색돼 0건이었다). 훑어보는 게 이 팝업의 목적이다.
    var kw = document.getElementById('qfPatKw');
    kw.value = '';
    setTimeout(function(){ kw.focus(); }, 30);
    qfPatModalSearch(true);
  };
  window.qfPatModalClose = function(){
    document.getElementById('qfPatModal').classList.remove('on');
    mSel = -1;
  };
  // ESC 는 팝업 어디에 포커스가 있든 먹어야 한다 — 행을 클릭한 뒤엔 검색칸 밖이라
  // input 의 onkeydown 만으로는 안 닫힌다.
  document.addEventListener('keydown', function(ev){
    if (ev.key !== 'Escape' || ev.isComposing) return;          // 한글 조합 중 ESC 는 IME 취소
    var m = document.getElementById('qfPatModal');
    if (m && m.classList.contains('on')) { ev.preventDefault(); qfPatModalClose(); }
  });
  window.qfPatModalSearch = function(now){
    if (mTimer) clearTimeout(mTimer);
    var run = function(){
      var kw = document.getElementById('qfPatKw').value.trim();
      document.getElementById('qfPatRows').innerHTML =
        '<tr><td colspan="7" style="color:#8a99a3;">찾는 중…</td></tr>';
      post('/qps/patientSearch.do', { keyword: kw, baseDt: val('f_occurDt') }).then(function(res){
        mList = res.list || [];
        mSel = -1;
        var body = document.getElementById('qfPatRows');
        if (!mList.length) {
          body.innerHTML = '<tr><td colspan="7" style="color:#8a99a3;">' +
            (kw ? ('&#39;' + esc(kw) + '&#39; 로 찾은 입원환자가 없습니다.') : '등록된 입원환자 자료가 없습니다.') +
            '</td></tr>';
        } else {
          body.innerHTML = mList.map(function(p, i){
            return '<tr data-i="' + i + '" onclick="qfPatModalPick(' + i + ');">' +
                   '<td><b>' + esc(p.ptnm || '') + '</b></td>' +
                   '<td>' + esc(p.ptno) + '</td>' +
                   '<td>' + esc(p.wardnm || p.roomnm || '-') + '</td>' +
                   '<td>' + (p.ptsex === 'M' ? '남' : (p.ptsex === 'F' ? '여' : '-')) + '</td>' +
                   '<td>' + (p.ptage != null ? (p.ptage + '세') : '-') + '</td>' +
                   '<td>' + esc(fmtDt(p.ipwondt)) + '</td>' +
                   '<td>' + (p.inhospyn === 'Y' ? '<span class="qf-badge">재원중</span>'
                                                : ('퇴원 ' + esc(fmtDt(p.tewondt)))) + '</td></tr>';
          }).join('');
        }
        // 서버가 '무슨 병원에서 무슨 글자로' 찾았는지 그대로 보여준다 —
        // 0건일 때 원인(병원이 다른지 / 글자가 깨졌는지 / 진짜 없는지)을 추측 없이 가른다.
        var h = res.hosp || {};
        var diag = '[' + (h.hospnm || res.hospCd || '?') + ' · 입원자료 ' + (h.ipwoncnt != null ? h.ipwoncnt : '?') + '건' +
                   ' · 검색어 "' + (res.echoKw || '') + '"]';
        document.getElementById('qfPatFoot').textContent =
          (mList.length ? (mList.length + '건 — 행을 클릭하면 선택. ↑↓ 이동 · Enter 선택 · [×]·ESC 로 닫기 ')
                        : '결과 없음 — 이름·등록번호의 앞부분으로 찾습니다. 직접 입력해도 저장됩니다. ') + diag;
      }).catch(function(e){
        document.getElementById('qfPatRows').innerHTML =
          '<tr><td colspan="7" style="color:#b23b3b;">조회에 실패했습니다.</td></tr>';
        err(e);
      });
    };
    if (now) run(); else mTimer = setTimeout(run, 250);
  };
  window.qfPatModalPick = function(i){
    var p = mList[i];
    if (!p) return;
    qfPatModalClose();
    patList = mList;          // 선택 후 안내문구를 입력검색과 같은 함수로 그린다
    qfPatPick(i);
  };
  window.qfPatModalKey = function(ev){
    var rows = document.querySelectorAll('#qfPatRows tr[data-i]');
    if (ev.key === 'ArrowDown' || ev.key === 'ArrowUp') {
      ev.preventDefault();
      if (!rows.length) return;
      mSel += (ev.key === 'ArrowDown' ? 1 : -1);
      if (mSel < 0) mSel = rows.length - 1;
      if (mSel >= rows.length) mSel = 0;
      for (var i = 0; i < rows.length; i++) rows[i].classList.toggle('sel', i === mSel);
      rows[mSel].scrollIntoView({ block: 'nearest' });
    } else if (ev.key === 'Enter') {
      ev.preventDefault();
      if (mSel >= 0) qfPatModalPick(mSel); else qfPatModalSearch(true);
    } else if (ev.key === 'Escape') {
      if (!ev.isComposing) { ev.preventDefault(); qfPatModalClose(); }   // 한글 조합 중 ESC 는 IME 취소
    }
  };

  window.qfIncidentClear = function(){
    ['f_incidSeq','f_occurDt','f_occurTm','f_wardCd','f_rptDept','f_ptNo','f_ptSex','f_ptAge',
     'f_levelCd','f_subtypeCd','f_placeCd','f_damageCd','f_causeTxt','f_actionTxt','f_rptUser']
      .forEach(function(id){ set(id, ''); });
    patClose(); patInfo('');
  };
  window.qfIncidentSave = function(){
    if (!val('f_occurDt')) { _alertBox('발생일자를 입력해 주세요.', {icon:'⚠️'}); return; }
    post('/qps/incidentSave.do', {
      incidGb: INCID_GB, incidSeq: val('f_incidSeq'),
      occurDt: val('f_occurDt'), occurTm: val('f_occurTm'), wardCd: val('f_wardCd'),
      rptDept: val('f_rptDept'), ptNo: val('f_ptNo'), ptSex: val('f_ptSex'), ptAge: val('f_ptAge'),
      levelCd: val('f_levelCd'), subtypeCd: val('f_subtypeCd'), placeCd: val('f_placeCd'),
      damageCd: val('f_damageCd'), causeTxt: val('f_causeTxt'), actionTxt: val('f_actionTxt'),
      rptUser: val('f_rptUser')
    }).then(function(){
      _toast('저장되었습니다.', 'ok');
      qfIncidentClear();
      return incidLoad();
    }).then(indiLoad).catch(err);
  };
  window.qfIncidentDelete = function(){
    if (!val('f_incidSeq')) { _alertBox('목록에서 삭제할 사고를 먼저 선택해 주세요.', {icon:'⚠️'}); return; }
    _confirmBox({ msg:'선택한 사고 보고를 삭제할까요?', icon:'⚠️', okText:'삭제', okColor:'#b23b3b',
      onOk: function(){
        post('/qps/incidentDelete.do', { incidSeq: val('f_incidSeq') }).then(function(){
          _toast('삭제되었습니다.', 'ok');
          qfIncidentClear();
          return incidLoad();
        }).then(indiLoad).catch(err);
      }});
  };

  // ---------- 탭2 : 분모 ----------
  // ★분모 구분은 지표 마스터(DENOM_GB)가 정한다 — INDAYS(총재원일수) / STAFF(직원수).
  //   이 함수는 indiLoad 뒤에 돌아야 curDef 를 볼 수 있다(qfReload 순서 주의).
  function denomGb(){ return (curDef && curDef.denomgb) ? curDef.denomgb : 'INDAYS'; }
  function denomNm(){ return denomGb() === 'STAFF' ? '직원수' : '재원일수'; }
  function censusLoad(){
    var gb = denomGb(), isStaff = (gb === 'STAFF');
    var head = document.getElementById('qfCensusHead'), body = document.getElementById('qfCensusBody');
    var ttl = document.getElementById('qfCensusTitle');
    if (ttl) ttl.innerHTML = isStaff
      ? '월별 직원수 <span class="qf-hint">— 지표의 분모(해당 월 재직 직원 수)</span>'
      : '월별 총재원일수 <span class="qf-hint">— 지표의 분모(해당 월 일일 재원환자 수의 합)</span>';
    // 직원수는 입퇴원 자료로 계산할 수 없다 → 자동계산 버튼·안내를 감춘다
    show('#qfCensusCalcBtn', !isStaff);
    var hint = document.getElementById('qfCensusHint');
    if (hint) hint.textContent = isStaff
      ? "비워두면 그 달은 '자료 없음'(지표 '-', 발생 0과 구분). 직원수는 인사자료 기준으로 직접 입력합니다."
      : "비워두면 그 달은 '자료 없음'(지표 '-', 발생 0과 구분). 자동계산 기준: 입원일 포함·퇴원일 제외, 재원중은 오늘까지 — 값 확인 후 [저장].";
    var tab = document.querySelector('#qpsFall .qf-tab[data-pane="p2"]');
    if (tab) tab.textContent = isStaff ? '👥 직원수(분모)' : '🛏 재원일수(분모)';

    head.innerHTML = '<th style="width:90px;">구분</th>' + MONTHS.map(function(m){ return '<th>' + Number(m) + '월</th>'; }).join('');
    body.innerHTML = '<td style="background:#f2f6f8; font-weight:700;">' + denomNm() + '</td>' +
      MONTHS.map(function(m){
        return '<td><input type="number" id="c_m' + m + '" min="0" style="width:100%; text-align:right;"></td>';
      }).join('');
    return post('/qps/censusGet.do', { censusGb: gb, inYear: year() }).then(function(res){
      var c = res.census || {};
      MONTHS.forEach(function(m){ set('c_m' + m, c['m' + m]); });
    });
  }
  // ---------- 탭4 : 관찰 입력 (손위생 등 MONITOR) ----------
  // ★같은 관찰형이라도 손위생과 격리·강박은 말이 다르다.
  //   손위생 = WHO 5 moments 를 '관찰'한다 / 격리·강박 = 지침대로 '시행'했는지를 본다.
  //   순간(moment) 칸을 격리·강박에 그대로 두면 늘 빈 값이라 분류표에 '미상' 축만 생긴다(2026-08-09 확인).
  var USE_MOMENT = (INDI_CD === 'HANDWASH');
  var DENOM_WORD = USE_MOMENT ? '관찰건수' : '시행건수';
  function monitorSetupUi(){
    show('#m_momentWrap', USE_MOMENT);
    var lab = document.getElementById('m_obsCntLab');
    if (lab) lab.textContent = DENOM_WORD + ' (분모) *';
    var th = document.getElementById('qfMonThObs');
    if (th) th.textContent = USE_MOMENT ? '관찰' : '시행';
    var hint = document.getElementById('qfMonFormHint');
    if (hint) hint.textContent = '— 분자=수행건수, 분모=' + DENOM_WORD +
      '(수행률 = 수행÷' + (USE_MOMENT ? '관찰' : '시행') + ' ×100)';
  }
  function monitorLoad(){
    monitorSetupUi();
    return post('/qps/monitorList.do', { indiCd: INDI_CD, inYear: year() }).then(function(res){
      monRaw = res.list || [];
      var rows = monRaw.map(function(r){
        return [ r.obsdtfmt || r.obsdt, r.wardcd || '', r.jobgb || '', r.momentcd || '',
                 r.obscnt == null ? '' : r.obscnt, r.passcnt == null ? '' : r.passcnt,
                 (r.ratepct == null ? '-' : r.ratepct + '%'), r.observer || '', r.upddttm || '' ];
      });
      if (dtMon) { dtMon.clear(); dtMon.rows.add(rows); dtMon.draw(false); }
      else {
        dtMon = $('#qfMonTbl').DataTable({
          data: rows, pageLength: 10, order: [[0,'desc']],
          language: { emptyTable: '등록된 관찰 기록이 없습니다.', search: '검색:', lengthMenu: '_MENU_ 건씩',
                      info: '전체 _TOTAL_ 건 중 _START_–_END_', paginate: { previous: '이전', next: '다음' } }
        });
        $('#qfMonTbl tbody').on('click', 'tr', function(){
          var idx = dtMon.row(this).index();
          if (idx != null && monRaw[idx]) monFill(monRaw[idx]);
        });
      }
      // 순간 열은 손위생에서만 — 폭 재계산까지 시켜야 머리글이 어긋나지 않는다(2번째 인자 생략)
      if (dtMon) dtMon.column(3).visible(USE_MOMENT);
    });
  }
  function monFill(r){
    set('m_monSeq', r.monseq); set('m_obsDt', r.obsdtfmt || r.obsdt); set('m_wardCd', r.wardcd);
    set('m_jobGb', r.jobgb); set('m_momentCd', r.momentcd); set('m_obsCnt', r.obscnt);
    set('m_passCnt', r.passcnt); set('m_observer', r.observer); set('m_note', r.note);
  }
  window.qfMonitorClear = function(){
    ['m_monSeq','m_obsDt','m_wardCd','m_jobGb','m_momentCd','m_obsCnt','m_passCnt','m_observer','m_note']
      .forEach(function(id){ set(id, ''); });
  };
  window.qfMonitorSave = function(){
    if (!val('m_obsDt')) { _alertBox('관찰일자를 입력해 주세요.', {icon:'⚠️'}); return; }
    if (!val('m_obsCnt')) { _alertBox(DENOM_WORD + '(분모)를 입력해 주세요.', {icon:'⚠️'}); return; }
    // ★수행 > 관찰(시행)이면 수행률이 100%를 넘는다 — 오타를 여기서 잡는다(서버에도 같은 가드가 있다).
    var obsN = Number(val('m_obsCnt')), passN = Number(val('m_passCnt') || 0);
    if (!(obsN > 0)) { _alertBox(DENOM_WORD + '(분모)는 1 이상이어야 합니다.', {icon:'⚠️'}); return; }
    if (passN > obsN) {
      _alertBox('수행건수(' + passN + ')가 ' + DENOM_WORD + '(' + obsN + ')보다 많습니다. 다시 확인해 주세요.',
                {icon:'⚠️'});
      return;
    }
    post('/qps/monitorSave.do', {
      indiCd: INDI_CD, monSeq: val('m_monSeq'), obsDt: val('m_obsDt'), wardCd: val('m_wardCd'),
      jobGb: val('m_jobGb'), momentCd: val('m_momentCd'), obsCnt: val('m_obsCnt'),
      passCnt: val('m_passCnt'), observer: val('m_observer'), note: val('m_note')
    }).then(function(){
      _toast('저장되었습니다.', 'ok'); qfMonitorClear();
      return monitorLoad();
    }).then(indiLoad).catch(err);
  };
  window.qfMonitorDelete = function(){
    if (!val('m_monSeq')) { _alertBox('목록에서 삭제할 기록을 먼저 선택해 주세요.', {icon:'⚠️'}); return; }
    _confirmBox({ msg:'선택한 관찰 기록을 삭제할까요?', icon:'⚠️', okText:'삭제', okColor:'#b23b3b',
      onOk: function(){
        post('/qps/monitorDelete.do', { monSeq: val('m_monSeq') }).then(function(){
          _toast('삭제되었습니다.', 'ok'); qfMonitorClear();
          return monitorLoad();
        }).then(indiLoad).catch(err);
      }});
  };

  // ---------- 탭5 : 월별 수기입력 (MANUAL) ----------
  // 분자는 늘 수기다. 분모는 지표에 따라 갈린다 —
  //   DENOM_GB 가 있으면(신체보호대=재원일수) 분모 줄을 감추고 [재원일수] 탭을 쓰게 하고,
  //   없으면(TAT·재택복귀·불만고충·만족도) 분모도 여기서 같이 적는다.
  function manualDenomIsManual(){ return !(curDef && curDef.denomgb); }
  // ★TAT 는 정규/응급을 나눠 본다(이전 시스템 보고서 실물이 그랬다). 축 상세는 **선택 입력** —
  //   지표 산출은 총계 행만 읽으므로, 상세를 안 적어도 지표는 그대로 나온다.
  var MANUAL_AXES = { TATIMG:['정규','응급'], TATLAB:['정규','응급'] };
  function manualAxes(){ return MANUAL_AXES[INDI_CD] || []; }
  function manualLoad(){
    var d = curDef || {};
    var numNm = d.numerdesc || '분자', denNm = d.denomdesc || '분모';
    var ttl = document.getElementById('qfManTitle');
    if (ttl) ttl.innerHTML = esc(d.indinm || '월별 입력') +
      ' <span class="qf-hint">— ' + esc(d.sourcenm || '대장·설문 결과') + '을(를) 보고 월별로 옮겨 적는다</span>';
    var hint = document.getElementById('qfManHint');
    if (hint) hint.textContent = manualDenomIsManual()
      ? "비워두면 그 달은 '자료 없음'(지표 '-', 0과 구분). 분자·분모를 함께 저장합니다."
      : "비워두면 그 달은 '자료 없음'. 이 지표의 분모는 재원일수라 [재원일수(분모)] 탭에서 관리합니다.";

    document.getElementById('qfManHead').innerHTML =
      '<th style="width:210px;">구분</th>' + MONTHS.map(function(m){ return '<th>' + Number(m) + '월</th>'; }).join('');
    document.getElementById('qfManNumer').innerHTML =
      '<td style="background:#f2f6f8; font-weight:700; text-align:left;">분자 · ' + esc(numNm) + '</td>' +
      MONTHS.map(function(m){
        return '<td><input type="number" id="n_m' + m + '" min="0" style="width:100%; text-align:right;"></td>';
      }).join('');
    var denRow = document.getElementById('qfManDenom');
    if (manualDenomIsManual()) {
      denRow.style.display = '';
      denRow.innerHTML =
        '<td style="background:#f2f6f8; font-weight:700; text-align:left;">분모 · ' + esc(denNm) + '</td>' +
        MONTHS.map(function(m){
          return '<td><input type="number" id="d_m' + m + '" min="0" style="width:100%; text-align:right;"></td>';
        }).join('');
    } else {
      denRow.style.display = 'none';
      denRow.innerHTML = '';
    }
    // 축 상세 행(정규/응급 × 분자/분모) — 총계 행 아래에 붙인다. 기존 행은 지우고 다시 그린다.
    var tb = denRow.parentNode;
    Array.prototype.slice.call(tb.querySelectorAll('tr.qf-axrow')).forEach(function(tr){ tr.remove(); });
    manualAxes().forEach(function(ax, ai){
      ['n', 'd'].forEach(function(kind){
        var tr = document.createElement('tr');
        tr.className = 'qf-axrow';
        tr.innerHTML =
          '<td style="background:#fbfcfd; text-align:left; padding-left:18px; color:#5b6b74;">└ ' +
            esc(ax) + ' · ' + (kind === 'n' ? '분자' : '분모') + ' <span class="qf-hint">(선택)</span></td>' +
          MONTHS.map(function(m){
            return '<td><input type="number" id="ax' + ai + kind + '_m' + m + '" min="0"' +
                   ' style="width:100%; text-align:right; background:#fbfcfd;"></td>';
          }).join('');
        tb.appendChild(tr);
      });
    });
    return post('/qps/manualGet.do', { indiCd: INDI_CD, inYear: year() }).then(function(res){
      var n = res.numer || {}, dm = res.denom || {};
      MONTHS.forEach(function(m){
        set('n_m' + m, n['m' + m]);
        if (manualDenomIsManual()) set('d_m' + m, dm['m' + m]);
      });
      (res.axes || []).forEach(function(r){
        var ai = manualAxes().indexOf(r.axiscd);
        if (ai < 0) return;
        var kind = (r.valgb === 'DENOM') ? 'd' : 'n';
        MONTHS.forEach(function(m){ set('ax' + ai + kind + '_m' + m, r['m' + m]); });
      });
    });
  }
  window.qfManualSave = function(){
    // 총계(분자→분모) 저장 후 축 상세를 순서대로 저장한다 — upsert 라 몇 번을 불러도 행은 하나씩이다
    var calls = [];
    var pn = { indiCd: INDI_CD, inYear: year(), valGb: 'NUMER' };
    MONTHS.forEach(function(m){ pn['m' + m] = val('n_m' + m); });
    calls.push(pn);
    if (manualDenomIsManual()) {
      var pd = { indiCd: INDI_CD, inYear: year(), valGb: 'DENOM' };
      MONTHS.forEach(function(m){ pd['m' + m] = val('d_m' + m); });
      calls.push(pd);
    }
    manualAxes().forEach(function(ax, ai){
      [['n', 'NUMER'], ['d', 'DENOM']].forEach(function(k){
        var p = { indiCd: INDI_CD, inYear: year(), valGb: k[1], axisCd: ax };
        MONTHS.forEach(function(m){ p['m' + m] = val('ax' + ai + k[0] + '_m' + m); });
        calls.push(p);
      });
    });
    var chain = Promise.resolve();
    calls.forEach(function(p){ chain = chain.then(function(){ return post('/qps/manualSave.do', p); }); });
    chain.then(function(){
      _toast('저장되었습니다.', 'ok');
      return indiLoad();
    }).catch(err);
  };

  // ---------- 확정값(동결) 병합 ----------
  // ★최종승인된 기간은 **화면 표·차트·인쇄물 모두 동결값**으로 보여준다(2026-08-09).
  //   인쇄만 동결값이면 화면과 인쇄물이 서로 다른 숫자를 보여 "어느 쪽이 맞느냐"가 된다.
  //   동결이 없는 기간·달은 실시간 산출값 그대로다.
  function frozenMap(){
    var m = {};
    if (apprState && apprState.frozen === 'Y') {
      (apprState.stat || []).forEach(function(s){ m[s.prdgb + '|' + s.prdkey] = s; });
    }
    return m;
  }
  function mergedMonths(fb){
    var ms = (lastCalc && lastCalc.months) || [];
    return ms.map(function(m){
      var f = fb['M|' + year() + m.mm];
      return f ? { mm: m.mm, numer: f.numer, denom: f.denom, rate: f.rate } : m;
    });
  }
  function mergedRollup(fb, gb, key, o){
    var f = fb[gb + '|' + key];
    return f ? { key: (o && o.key), numer: f.numer, denom: f.denom, rate: f.rate } : o;
  }
  // 결재 상태가 확정이면 분석 표·차트를 동결값으로 다시 그린다(기간을 바꾸면 반대 방향으로도 되돌린다)
  function applyFrozenToView(){
    if (!lastCalc || !curDef) return;
    var fb = frozenMap();
    var ms = mergedMonths(fb);
    renderMonths(ms, curDef);
    var qs = (lastCalc.quarters || []).map(function(q, i){ return mergedRollup(fb, 'Q', year() + 'Q' + (i + 1), q); });
    var hs = (lastCalc.halves || []).map(function(h, i){ return mergedRollup(fb, 'H', year() + 'H' + (i + 1), h); });
    var yr = mergedRollup(fb, 'Y', year(), lastCalc.year);
    renderRollup(qs, hs, yr, curDef);
    renderChart(ms, curDef);
  }

  // 축별 집계표(분석 탭) — 정규/응급 각 축의 분기·연간 율을 상세 행에서 계산해 분류 카드 자리에 그린다
  function renderManualAxisBreak(){
    var box = document.getElementById('qfBreak');
    if (!box) return;
    post('/qps/manualGet.do', { indiCd: INDI_CD, inYear: year() }).then(function(res){
      var byAxis = {};   // axis -> { n:[12], d:[12] }
      (res.axes || []).forEach(function(r){
        var a = byAxis[r.axiscd] || (byAxis[r.axiscd] = { n:[], d:[] });
        var arr = (r.valgb === 'DENOM') ? a.d : a.n;
        MONTHS.forEach(function(m, i){ arr[i] = Number(r['m' + m] || 0); });
      });
      function sum(arr, from, to){ var s = 0; for (var i = from; i < to; i++) s += (arr[i] || 0); return s; }
      var COLS = [['1/4', 0, 3], ['2/4', 3, 6], ['3/4', 6, 9], ['4/4', 9, 12], ['연간', 0, 12]];
      var axes = manualAxes().filter(function(ax){ return byAxis[ax]; });
      if (!axes.length) {
        box.innerHTML = '<div class="qf-sub">정규·응급 상세가 아직 없습니다 — <b>[월별 입력]</b> 탭의 상세(선택) 행에 적으면 여기에 집계됩니다.</div>';
        return;
      }
      var html = '<div class="qf-scroll"><table class="qf-grid" style="min-width:560px;"><thead><tr>' +
        '<th style="width:90px;">구분</th>' +
        COLS.map(function(c){ return '<th>' + c[0] + (c[0] === '연간' ? '' : ' 분기') + '</th>'; }).join('') +
        '</tr></thead><tbody>' +
        axes.map(function(ax){
          var a = byAxis[ax];
          return '<tr><td style="background:#f2f6f8; font-weight:700;">' + esc(ax) + '</td>' +
            COLS.map(function(c){
              var n = sum(a.n, c[1], c[2]), d = sum(a.d, c[1], c[2]);
              var cell = d > 0
                ? (num(n) + ' / ' + num(d) + ' = <b>' + fmtRate(n * Number(curDef.multiplier || 100) / d, curDef) + esc(unit(curDef)) + '</b>')
                : '-';
              return '<td class="num">' + cell + '</td>';
            }).join('') + '</tr>';
        }).join('') +
        '</tbody></table></div>';
      box.innerHTML = html;
    }).catch(function(){ box.innerHTML = ''; });
  }

  // 자동산출 — 서버가 입퇴원 자료로 계산한 값을 칸에 채운다. 저장은 사람이 [저장]으로.
  window.qfCensusCalc = function(){
    post('/qps/censusCalc.do', { inYear: year() }).then(function(res){
      MONTHS.forEach(function(m){ set('c_m' + m, res['m' + m]); });
      _toast('입원 ' + num(res.stays || 0) + '건으로 계산했습니다. 값 확인 후 [저장]을 누르세요.', 'info');
    }).catch(err);
  };

  window.qfCensusSave = function(){
    var p = { censusGb: denomGb(), inYear: year() };   // ★지표가 쓰는 분모 구분으로 저장(INDAYS/STAFF)
    MONTHS.forEach(function(m){ p['m' + m] = val('c_m' + m); });
    post('/qps/censusSave.do', p).then(function(){
      _toast('저장되었습니다.', 'ok');
      return indiLoad();
    }).catch(err);
  };

  // ---------- 탭3 : 지표분석 ----------
  function indiLoad(){
    return post('/qps/indiCalc.do', {
      indiCd: INDI_CD, incidGb: INCID_GB, inYear: year(),
      fromDt: year() + '0101', toDt: year() + '1231'
    }).then(function(res){
      curDef = res.indi || {};
      lastCalc = res;                 // 인쇄물이 이 값을 그대로 쓴다(다시 계산하지 않는다)
      // ★병원 배지를 매번 서버 응답으로 다시 쓴다 — 상단 [병원검색]으로 병원을 바꾸면
      //   숫자는 바로 새 병원 것이 되는데 배지·인쇄물만 옛 병원으로 남는 문제가 있었다(2026-08-09).
      if (res.hosp) {
        HOSP_NM = res.hosp.hospnm || '';
        var badge = document.getElementById('qfHospNm');
        if (badge) badge.innerHTML = '🏥 ' + esc(HOSP_NM) + ' (' + esc(res.hosp.hospcd || '') + ')' +
                   ' · 입원자료 ' + num(res.hosp.ipwoncnt || 0) + '건';
      }
      // ★지표 유형(numersrc)에 따라 탭 구성이 다르다:
      //   INCIDENT(낙상) = 사고보고 + 재원일수 + 지표분석
      //   PATVAL(욕창)   = 재원일수 + 지표분석 (입력 없음)
      //   MONITOR(손위생)= 관찰입력 + 지표분석 (재원일수 안 씀 — 분모가 관찰건수)
      var src = curDef.numersrc || 'INCIDENT';
      var isPatval  = (src === 'PATVAL');
      var isMonitor = (src === 'MONITOR');
      var isManual  = (src === 'MANUAL');
      // CMPL = 불만고충 처리대장에서 분자·분모를 통째로 집계한다(2026-08-11 수기입력에서 전환).
      // 이 화면에는 입력 탭이 없다 — 자료는 [불만고충 ▸ 처리대장] 에서 적는다.
      var isCmpl    = (src === 'CMPL');
      // SRV = 만족도 설문에서 분자(점수합)·분모(만점합)를 통째로 집계한다(2026-08-11 수기입력에서 전환).
      // 이 화면에도 입력 탭이 없다 — 자료는 [환자만족도 조사 ▸ 설문지·조사결과] 에서 적는다.
      var isSrv     = (src === 'SRV');
      // 분모 탭은 '재원일수·직원수를 쓰는 지표'에만 필요하다 —
      // 관찰형은 분모가 관찰건수, 대장형은 접수건수, 설문형은 만점합, 수기형도 DENOM_GB 가 없으면 월별 입력 탭에서 적는다.
      var needCensus = !isMonitor && !isCmpl && !isSrv && !(isManual && !curDef.denomgb);
      show('#qpsFall .qf-tab[data-pane="p1"]', src === 'INCIDENT');   // 사고보고
      show('#qpsFall .qf-tab[data-pane="p4"]', isMonitor);           // 관찰입력
      show('#qpsFall .qf-tab[data-pane="p5"]', isManual);            // 월별 수기입력
      show('#qpsFall .qf-tab[data-pane="p2"]', needCensus);          // 재원일수·직원수
      // 분류별 집계는 '사고 행'이 있어야 성립한다 — 평가표형·수기형은 빈 표 6개가 고장처럼 보인다.
      // 단 TAT 처럼 축(정규/응급)이 있는 수기형은 이 카드를 **축별 집계표**로 재활용한다.
      var hasAxes = isManual && manualAxes().length > 0;
      var bkCard = document.getElementById('qfBreak');
      if (bkCard) bkCard.closest('.qf-card').style.display =
          (((isPatval || isManual) && !hasAxes) || isCmpl || isSrv) ? 'none' : '';
      if (hasAxes) {
        var bkHint2 = document.getElementById('qfBreakHint');
        if (bkHint2) bkHint2.textContent = '— 정규·응급별 집계(월별 입력 탭의 상세 행에서 계산. 상세 미입력 시 빈 표)';
        renderManualAxisBreak();
      }
      // 화면 머리 흐름 안내·분류표 설명도 유형에 맞춘다(관찰형은 재원일수를 안 쓴다)
      var flow = document.getElementById('qfFlow');
      if (flow) flow.textContent = isMonitor ? '관찰 입력 → 분기 지표 자동산출 (수행 ÷ 관찰)'
                                 : isPatval  ? '환자평가표에서 자동집계 → 분기 지표 자동산출'
                                 : isCmpl    ? '불만고충 처리대장에서 자동집계 → 분기 지표 자동산출 (처리 ÷ 접수)'
                                 : isSrv     ? '만족도 설문 응답에서 자동집계 → 조사 종료월에 반영 (점수합 ÷ 만점합)'
                                 : isManual  ? '월별 입력(대장·설문) → 분기 지표 자동산출'
                                             : '사고보고 → 재원일수 → 분기 지표 자동산출';
      var bkHint = document.getElementById('qfBreakHint');
      if (bkHint) bkHint.textContent = isMonitor ? '— 관찰기록에서 자동 집계(직군·병동·순간별 수행률)'
                                                 : '— 사고보고에서 자동 집계(분자와 같은 기준)';
      // 첫 탭이 자기 유형과 안 맞으면 알맞은 탭으로 이동
      if (isMonitor && !document.querySelector('#qpsFall .qf-tab.on[data-pane="p4"]')
                    && !document.querySelector('#qpsFall .qf-tab.on[data-pane="p3"]')) qfTab('p4');
      if (isPatval  &&  document.querySelector('#qpsFall .qf-tab.on[data-pane="p1"]')) qfTab('p3');
      if (isManual && !document.querySelector('#qpsFall .qf-tab.on[data-pane="p5"]')
                   && !document.querySelector('#qpsFall .qf-tab.on[data-pane="p3"]')) qfTab('p5');
      // 대장형은 입력 탭이 아예 없다 — 바로 지표분석으로 보낸다(빈 탭에 떨어지면 고장처럼 보인다)
      if ((isCmpl || isSrv) && !document.querySelector('#qpsFall .qf-tab.on[data-pane="p3"]')) qfTab('p3');
      if (isMonitor) monitorLoad();
      if (isManual)  manualLoad();
      if (src === 'INCIDENT') incidSetupUi(curDef);   // 탭·제목·유형목록·대상 라벨을 지표에 맞춘다
      renderDef(curDef);
      renderMonths(res.months || [], curDef);
      renderRollup(res.quarters || [], res.halves || [], res.year, curDef);
      renderChart(res.months || [], curDef);
      renderBreak(res.breakdown || {});
      // 관찰형은 분모가 관찰건수라 재원일수 경고를 띄우지 않는다(다른 안내로 대체)
      var warn = document.getElementById('qfNoCensus');
      if (warn) {
        if (isMonitor) {
          warn.style.display = (res.hasCensus === 'Y') ? 'none' : 'block';
          warn.innerHTML = (USE_MOMENT ? '관찰' : '시행') + ' 기록이 없습니다. <b>[관찰 입력]</b> 탭에서 먼저 등록해 주세요.';
        } else if (isSrv) {
          warn.style.display = (res.hasCensus === 'Y') ? 'none' : 'block';
          warn.innerHTML = '집계할 만족도 응답이 없습니다. <b>[환자만족도 조사 ▸ 설문지·조사결과]</b>' +
                           ' 에서 응답을 등록하고, <b>조사 종료일</b>이 채워져 있는지 확인해 주세요' +
                           ' — 종료월 기준으로 지표에 반영됩니다.';
        } else if (isManual && !curDef.denomgb) {
          warn.style.display = (res.hasCensus === 'Y') ? 'none' : 'block';
          warn.innerHTML = '월별 값이 등록되지 않았습니다. <b>[월별 입력]</b> 탭에서 분자·분모를 먼저 적어 주세요.';
        } else {
          var dn = (curDef && curDef.denomgb === 'STAFF') ? '직원수' : '재원일수';
          warn.style.display = (res.hasCensus === 'Y') ? 'none' : 'block';
          warn.innerHTML = dn + '(분모)가 등록되지 않았습니다. <b>[' + dn + '(분모)]</b> 탭에서 먼저 입력해 주세요.';
        }
      }
    });
  }
  function unit(def){ return (def && def.unit) ? def.unit : '‰'; }
  // ★지표 유형별 표 라벨 — 관찰형(손위생·격리·강박)은 분자=수행건수, 분모=관찰건수, 값=수행률이다.
  //   낙상 라벨을 그대로 두면 손위생 화면에 '분모(재원일수)'·'발생률'이 찍혀 전혀 다른 지표로 읽힌다.
  function labelsOf(def){
    if (def && def.numersrc === 'MONITOR')
      return { numer:'분자(수행건수)', denom:'분모(' + DENOM_WORD + ')', rate:'수행률',
               bar: DENOM_WORD, barKey:'denom' };
    // 대장형(불만고충)은 분자·분모가 무엇인지 확실하다 — 이름을 박아 준다
    if (def && def.numersrc === 'CMPL')
      return { numer:'분자(처리건수)', denom:'분모(접수건수)', rate:'처리율',
               bar:'접수건수', barKey:'denom' };
    // 설문형(만족도)도 분자·분모가 확실하다. ★분모는 '응답자 수'가 아니라 만점합(응답문항수×5)이다 —
    //   이름을 안 박으면 담당자가 응답자 수로 읽고 숫자가 이상하다고 본다.
    if (def && def.numersrc === 'SRV')
      return { numer:'분자(점수합)', denom:'분모(만점합)', rate:'만족도',
               bar:'만점합', barKey:'denom' };
    // 수기형은 지표마다 분자·분모의 정체가 달라(충족건수/전체건수, 복귀자/퇴원자…) 이름을 박지 않는다
    if (def && def.numersrc === 'MANUAL' && !def.denomgb)
      return { numer:'분자', denom:'분모', rate:(def.unit === '%' ? '비율' : '발생률'),
               bar:'분모', barKey:'denom' };
    var dn = (def && def.denomgb === 'STAFF') ? '직원수' : '재원일수';
    return { numer:'분자(건)', denom:'분모(' + dn + ')', rate:'발생률', bar:'건수', barKey:'numer' };
  }
  // 발생률은 소수자리를 고정해 찍는다 — JSON 숫자 1.00 은 JS 에서 1 이 되어 '1‰' 로 보였다(2026-08-08).
  function fmtRate(v, def){
    if (v == null) return '-';
    var d = (def && def.decimals != null) ? Number(def.decimals) : 2;
    return Number(v).toFixed(d);
  }
  function renderDef(d){
    var box = document.getElementById('qfDef');
    if (!d || !d.indinm) {
      box.innerHTML = '지표 마스터(TBL_QPS_INDI_MST)에 <b>' + esc(INDI_CD) + '</b> 행이 없습니다. DDL 시드를 먼저 적용해 주세요.';
      return;
    }
    // ★2줄 — 첫 줄은 '무엇을 재는 지표인가', 둘째 줄은 '어떻게 재는가'. 나머지는 줄바꿈으로 흘린다.
    var cyc = d.cyclegb === 'Q' ? '분기별' : (d.cyclegb === 'H' ? '반기별' : (d.cyclegb === 'Y' ? '연 1회' : (d.cyclegb || '')));
    var p = [];
    p.push('<b>분자</b>' + esc(d.numerdesc || '-'));
    p.push('<b>분모</b>' + esc(d.denomdesc || '-'));
    p.push('<span class="qf-formula">분자÷분모×' + num(d.multiplier || 1000) + ' = ' + esc(unit(d)) + '</span>');
    if (d.targetval != null && d.targetval !== '')
      p.push('<b>목표</b>' + esc(String(Number(d.targetval))) + esc(unit(d)));
    if (cyc)         p.push(esc(cyc));
    if (d.sourcenm)  p.push(esc(d.sourcenm));
    if (d.ownernm)   p.push(esc(d.ownernm));
    box.innerHTML =
      '<div class="qf-d1"><b>' + esc(d.indinm) + '</b>' +
        (d.definition ? ' — ' + esc(d.definition) : '') + '</div>' +
      '<div class="qf-d2">' + p.join('<span class="qf-sep">·</span>') + '</div>';
  }
  function renderMonths(ms, def){
    var lab = labelsOf(def);
    document.getElementById('qfMonHead').innerHTML =
      '<th style="width:130px;">구분</th>' + ms.map(function(m){ return '<th>' + Number(m.mm) + '월</th>'; }).join('');
    // ★관찰형은 관찰을 안 한 달의 분자 0 이 '수행 0건'으로 읽힌다 — 분모가 없으면 분자도 '-'.
    //   (사고형은 반대다. 재원일수만 있고 사고가 없으면 '0건'이 사실이므로 0 을 그대로 찍는다.)
    var monZeroDash = (def && def.numersrc === 'MONITOR');
    document.getElementById('qfMonNumer').innerHTML =
      '<td style="background:#f2f6f8; font-weight:700;">' + lab.numer + '</td>' +
      ms.map(function(m){
        return '<td class="num">' + ((monZeroDash && !m.denom) ? '-' : num(m.numer)) + '</td>'; }).join('');
    document.getElementById('qfMonDenom').innerHTML =
      '<td style="background:#f2f6f8; font-weight:700;">' + lab.denom + '</td>' +
      ms.map(function(m){ return '<td class="num">' + (m.denom ? num(m.denom) : '-') + '</td>'; }).join('');
    document.getElementById('qfMonRate').innerHTML =
      '<td style="background:#f2f6f8; font-weight:700;">' + lab.rate + '(' + esc(unit(def)) + ')</td>' +
      ms.map(function(m){ return '<td class="num">' + fmtRate(m.rate, def) + '</td>'; }).join('');
  }
  function renderRollup(qs, hs, yr, def){
    var lab = labelsOf(def);
    document.getElementById('qfQtrHead').innerHTML =
      '<th>구분</th><th>' + lab.numer + '</th><th>' + lab.denom + '</th><th>' + lab.rate + '</th>';
    var rows = [];
    qs.forEach(function(q, i){ rows.push([(i+1) + '/4 분기', q]); });
    if (hs[0]) rows.push(['상반기', hs[0]]);
    if (hs[1]) rows.push(['하반기', hs[1]]);
    if (yr)    rows.push(['연간',   yr]);
    document.getElementById('qfQtrBody').innerHTML = rows.map(function(r){
      var o = r[1], mz = (def && def.numersrc === 'MONITOR' && !o.denom);   // 관찰 없는 기간은 분자도 '-'
      return '<tr' + (r[0] === '연간' ? ' class="qf-sum"' : '') + '>' +
             '<td>' + esc(r[0]) + '</td>' +
             '<td class="num">' + (mz ? '-' : num(o.numer)) + '</td>' +
             '<td class="num">' + (o.denom ? num(o.denom) : '-') + '</td>' +
             '<td class="num"><b>' + (o.rate == null ? '-' : (fmtRate(o.rate, def) + ' ' + esc(unit(def)))) + '</b></td></tr>';
    }).join('');
  }
  function renderChart(ms, def){
    var el = document.getElementById('qfChart');
    if (typeof echarts === 'undefined' || !el) return;
    if (!chart) chart = echarts.init(el);
    // 관찰형은 막대가 '수행건수'면 수행률과 같은 이야기를 두 번 하는 셈이라 **관찰건수(분모)**를 세운다.
    var lab = labelsOf(def), rateNm = lab.rate + '(' + unit(def) + ')';
    chart.setOption({
      tooltip: { trigger:'axis' },
      legend:  { data:[rateNm, lab.bar] },
      grid:    { left:50, right:50, top:40, bottom:30 },
      xAxis:   { type:'category', data: ms.map(function(m){ return Number(m.mm) + '월'; }) },
      yAxis: [ { type:'value', name: unit(def) }, { type:'value', name:'건' } ],
      series: [
        { name: rateNm, type:'line', smooth:true, connectNulls:false,
          data: ms.map(function(m){ return m.rate == null ? null : Number(m.rate); }),
          itemStyle:{ color:'#1f5a4b' } },
        { name: lab.bar, type:'bar', yAxisIndex:1, barWidth:14,
          data: ms.map(function(m){ return m[lab.barKey]; }),
          itemStyle:{ color:'rgba(42,118,101,.35)' } }
      ]
    }, true);   // notMerge — 지표를 바꿔 legend 이름이 달라질 때 옛 계열이 남지 않게
  }
  // ★HARM(사고분류)은 위해등급을 셋으로 묶은 것 — 원본 지표분석보고서의 「사고분류」 표다.
  //   묶음은 서버(selectBreakdown)에서 한다. 화면·인쇄물이 각자 묶으면 둘이 갈릴 수 있다.
  var AXIS_NM = { PLACE:'발생장소', DAMAGE:'손상유형', TYPE:'사고유형', DEPT:'보고부서', AGE:'연령대', TIME:'시간대',
                  HARM:'사고분류(위해등급)' };
  var AXIS_MON = { JOB:'직군', WARD:'병동', MOMENT:'순간(moment)' };
  function renderBreak(bd){
    var wrap = document.getElementById('qfBreak'), html = '';
    var isMon = (curDef && curDef.numersrc === 'MONITOR');
    var axes = isMon ? AXIS_MON : AXIS_NM;
    Object.keys(axes).forEach(function(k){
      if (isMon && k === 'MOMENT' && !USE_MOMENT) return;   // 격리·강박엔 순간 개념이 없다('미상' 축만 생긴다)
      var list = bd[k] || [];
      var cols = isMon ? 3 : 2;
      html += '<table class="qf-grid" style="width:auto; min-width:' + (isMon ? 240 : 180) + 'px;">' +
              '<thead><tr><th colspan="' + cols + '">' + axes[k] + '</th></tr></thead>';
      if (isMon) html += '<thead><tr><th></th><th>수행/관찰</th><th>수행률</th></tr></thead>';
      html += '<tbody>';
      if (!list.length) html += '<tr><td colspan="' + cols + '" style="color:#8a99a3;">자료 없음</td></tr>';
      else list.forEach(function(r){
        if (isMon) {
          // ★소수자리를 고정하지 않으면 90.0 이 '90%', 87.8 은 '87.8%' 로 섞여 찍힌다
          //   (JSON 의 90.0 이 JS 에서 90 이 되는 것 — 낙상 때 겪은 것과 같은 함정)
          html += '<tr><td>' + esc(r.code) + '</td><td class="num">' + num(r.numer) + ' / ' + num(r.denom) + '</td>' +
                  '<td class="num">' + (r.rate == null ? '-' : fmtRate(r.rate, curDef) + '%') + '</td></tr>';
        } else {
          html += '<tr><td>' + esc(r.code) + '</td><td class="num">' + num(r.cnt) + '</td></tr>';
        }
      });
      html += '</tbody></table>';
    });
    wrap.innerHTML = html;
  }

  // 보고서(서술)
  (function(){
    var sel = document.getElementById('qfPrdKey');
    ['Q1','Q2','Q3','Q4','H1','H2'].forEach(function(k){
      var nm = k.charAt(0) === 'Q' ? (k.charAt(1) + '/4 분기') : (k === 'H1' ? '중간(상반기)' : '최종(하반기)');
      sel.add(new Option(nm, k));
    });
    // 기간 딥링크(?prd=Q2) — 현황판에서 넘어올 때 그 기간이 바로 열리게. 잘못된 값이면 무시.
    var prd = ($root.getAttribute('data-prd') || '').toUpperCase();
    if (prd && ['Q1','Q2','Q3','Q4','H1','H2'].indexOf(prd) >= 0) sel.value = prd;
  })();
  function prdOf(){ var k = document.getElementById('qfPrdKey').value; return { gb: k.charAt(0), key: year() + k }; }
  window.qfReportLoad = function(){
    var p = prdOf();
    post('/qps/reportGet.do', { indiCd: INDI_CD, prdGb: p.gb, prdKey: p.key }).then(function(res){
      var r = res.report || {};
      set('r_act1', r.act1txt); set('r_act2', r.act2txt); set('r_act3', r.act3txt); set('r_act4', r.act4txt);
      set('r_analysis', r.analysistxt); set('r_plan', r.plantxt);
      document.getElementById('qfRptStat').textContent = r.upddttm ? ('최종수정 ' + r.upddttm) : '작성 전';
      return apprLoad();   // 기간이 바뀌면 결재 상태도 그 기간 것으로 바뀐다
    }).catch(err);
  };
  window.qfReportSave = function(){
    var p = prdOf();
    post('/qps/reportSave.do', {
      indiCd: INDI_CD, prdGb: p.gb, prdKey: p.key,
      title: (curDef && curDef.indinm ? curDef.indinm : '낙상') + ' 지표분석보고서',
      act1Txt: val('r_act1'), act2Txt: val('r_act2'), act3Txt: val('r_act3'), act4Txt: val('r_act4'),
      analysisTxt: val('r_analysis'), planTxt: val('r_plan')
    }).then(function(){ _toast('보고서가 저장되었습니다.', 'ok'); qfReportLoad(); }).catch(err);
  };

  // ---------- 결재 ----------
  // ★결재(決裁) = 승인 절차. 요금 결제(決濟)가 아니다.
  //   단계 수는 서버(TBL_QPS_APPR_LINE)가 정한다 — 화면은 받은 만큼 칸을 그린다.
  var apprState = null;
  var ST_NM = { DRAFT:'작성중', SUBMIT:'결재중', REJECT:'반려', CONFIRM:'최종승인' };
  // ★이미 DB 에 %uB9C8%uC2A4%uD130 형태로 저장된 옛 이력이 있다(서버는 고쳤지만 과거 행은 그대로).
  //   화면에서 한 번 더 풀어 준다 — escape()(%uXXXX)와 표준(%XX) 모두.
  function decNm(s){
    if (s == null) return '';
    s = String(s);
    if (s.indexOf('%') < 0) return s;
    try { if (/%u[0-9a-f]{4}/i.test(s)) return unescape(s); } catch(e){}
    try { return decodeURIComponent(s); } catch(e){ return s; }
  }
  // ★서명칸에는 **현재 회차의 승인만** 찍는다 — 이력에는 지난 회차(반려·확정취소 전)의 승인도
  //   다 남아 있어서, 그대로 그리면 재상신 직후인데 서명 4개가 이미 차 있는 것처럼 보인다
  //   ("1단계 차례입니다" 와 어긋남 — 2026-08-09 실사용 지적).
  //   이력은 시간순이므로, 승인이 아닌 동작(상신·반려·회수·확정취소)이 나올 때마다 새 회차로 비운다.
  function signMapOf(hist){
    var m = {};
    (hist || []).forEach(function(h){
      if (h.actgb === 'APPROVE') m[Number(h.stepno)] = h;
      else m = {};
    });
    return m;
  }

  function apprLoad(){
    var p = prdOf();
    return post('/qps/apprGet.do', { indiCd: INDI_CD, prdGb: p.gb, prdKey: p.key }).then(function(res){
      apprState = res;
      renderAppr(res);
      applyFrozenToView();   // 확정 기간이면 표·차트를 동결값으로(아니면 실시간값으로 되돌림)
    });
  }
  function renderAppr(s){
    var line = s.line || [], cur = Number(s.curStep || 0), last = Number(s.lastStep || line.length);
    var st = s.status || 'DRAFT';
    var hist = s.hist || [];

    var badge = document.getElementById('qfApprStatus');
    badge.className = 'qf-badge st-' + st.toLowerCase();
    badge.textContent = ST_NM[st] || st;

    var guide = document.getElementById('qfApprGuide');
    guide.innerHTML =
        st === 'DRAFT'   ? '작성이 끝나면 [상신]을 누르세요.'
      : st === 'SUBMIT'  ? ((cur + 1) + '단계 ' + esc(stepNm(line, cur + 1) || '') + ' 결재 차례입니다.')
      : st === 'REJECT'  ? '반려되었습니다. 수정 후 다시 상신하세요.'
      // ★최종승인 시점에 수치를 동결한다 — 이후 원천이 바뀌어도 제출한 값은 안 변한다.
      :                    ('모든 단계가 승인되었습니다.' + (s.frozen === 'Y'
                              ? ' <b style="color:#1f7a52;">이 기간 수치는 확정(동결)되었습니다</b> — 화면 표·인쇄물 모두 확정값으로 표시됩니다.'
                              : ''));

    // 결재선 칸 — 단계별 서명(이름·일시). **현재 회차**의 승인만 채운다.
    var signBy = signMapOf(hist);
    // 머리글에 단계 번호 + 진행 표시(✔완료 · ▶차례) — "어디까지 했는지"가 칸을 안 읽어도 보이게
    document.getElementById('qfApprHead').innerHTML =
      line.map(function(r){
        var n = Number(r.stepno);
        var mark = signBy[n] ? ' <span style="color:#1f7a52;">✔</span>'
                 : (st === 'SUBMIT' && n === cur + 1) ? ' <span style="color:#b58a3a;">▶</span>' : '';
        return '<th>' + n + '. ' + esc(r.stepnm) + mark + '</th>';
      }).join('') || '<th>결재선 없음</th>';
    document.getElementById('qfApprBody').innerHTML =
      line.map(function(r){
        var n = Number(r.stepno), h = signBy[n];
        if (h) return '<td class="sign"><div class="nm">' + esc(decNm(h.actnm) || h.actuser || '') + '</div>' +
                      '<div class="dt">' + esc(h.actdttm || '') + '</div></td>';
        var waiting = (st === 'SUBMIT' && n === cur + 1);
        return '<td class="sign' + (waiting ? ' wait' : '') + '">' +
               (waiting ? '<div class="nm">결재 대기</div>' : '') + '</td>';
      }).join('') || '<td class="sign">결재선이 설정되어 있지 않습니다.</td>';

    // 버튼 — 상태에 맞는 것만 보인다(할 수 없는 걸 눌러 오류를 보는 일이 없게)
    show('#qfBtnSubmit',  st === 'DRAFT' || st === 'REJECT');
    show('#qfBtnCancel',  st === 'SUBMIT' && cur === 0);
    show('#qfBtnApprove', st === 'SUBMIT');
    show('#qfBtnReject',  st === 'SUBMIT');
    show('#qfBtnReopen',  st === 'CONFIRM');        // 최종승인 뒤 되돌리는 유일한 길 — 사유 필수, 이력에 남는다
    show('#qfBtnLine',    WNN_YN === 'Y');          // 결재선 설정은 관리자(위너넷)만

    // 결재 중·최종승인이면 서술 저장을 막는다(서버에도 같은 가드가 있다)
    var lock = (st === 'SUBMIT' || st === 'CONFIRM');
    var sb = document.getElementById('qfRptSaveBtn');
    if (sb) { sb.disabled = lock; sb.style.opacity = lock ? .45 : 1; sb.style.cursor = lock ? 'not-allowed' : 'pointer'; }
    var hint = document.getElementById('qfApprHint');
    if (hint) hint.textContent = lock
      ? '— ' + (st === 'SUBMIT' ? '결재 중이라 서술을 고칠 수 없습니다(회수하면 가능).' : '최종 승인된 문서는 수정할 수 없습니다.')
      : '— 상신하면 단계별로 승인합니다. 결재 중에는 서술을 고칠 수 없습니다.';

    document.getElementById('qfApprHist').innerHTML = hist.length
      ? hist.map(function(h){
          var act = h.actgb === 'SUBMIT' ? '상신' : h.actgb === 'APPROVE' ? '승인'
                  : h.actgb === 'REJECT' ? '반려' : h.actgb === 'CANCEL' ? '회수'
                  : h.actgb === 'REOPEN' ? '확정취소' : esc(h.actgb);
          return '<tr><td>' + esc(h.actdttm || '') + '</td>' +
                 '<td>' + (h.stepno > 0 ? (h.stepno + '. ' + esc(h.stepnm || '')) : '-') + '</td>' +
                 '<td>' + act + '</td>' +
                 '<td>' + esc(decNm(h.actnm) || h.actuser || '') + '</td>' +
                 '<td style="text-align:left;">' + esc(h.note || '') + '</td></tr>';
        }).join('')
      : '<tr><td colspan="5" style="color:#8a99a3;">결재 이력이 없습니다.</td></tr>';
  }
  function stepNm(line, no){
    for (var i = 0; i < line.length; i++) if (Number(line[i].stepno) === no) return line[i].stepnm;
    return '';
  }

  window.qfApprAct = function(act){
    var p = prdOf(), s = apprState || {};
    var cur = Number(s.curStep || 0);
    var msg = act === 'SUBMIT'  ? '이 보고서를 결재 상신할까요? 상신 후에는 서술을 고칠 수 없습니다.'
            : act === 'CANCEL'  ? '상신을 회수할까요? 다시 수정할 수 있게 됩니다.'
            : act === 'APPROVE' ? ((cur + 1) + '단계 ' + (stepNm(s.line || [], cur + 1) || '') + ' 승인할까요?')
            : act === 'REOPEN'  ? '최종승인을 취소할까요? 확정(동결)된 수치가 풀리고 처음부터 다시 결재해야 합니다.'
            :                     '반려할까요? 처음부터 다시 결재해야 합니다.';
    var doIt = function(note){
      post('/qps/apprAct.do', {
        indiCd: INDI_CD, prdGb: p.gb, prdKey: p.key,
        actGb: act, stepNo: (act === 'APPROVE' ? (cur + 1) : ''), note: note || ''
      }).then(function(){
        _toast(act === 'SUBMIT' ? '상신되었습니다.' : act === 'APPROVE' ? '승인되었습니다.'
             : act === 'REJECT' ? '반려되었습니다.'
             : act === 'REOPEN' ? '최종승인이 취소되었습니다. 수정 후 다시 상신하세요.' : '회수되었습니다.', 'ok');
        return apprLoad();
      }).then(qfReportLoad).catch(err);
    };
    if (act === 'REJECT' || act === 'REOPEN') {
      // 반려·확정취소는 사유가 남아야 한다 — 확정본을 되돌리는 일은 특히 근거가 필요하다
      var q = act === 'REJECT' ? '반려 사유를 입력해 주세요.' : '확정 취소 사유를 입력해 주세요.';
      var note = window.prompt(q, '');
      if (note === null) return;
      if (!note.trim()) { _alertBox(q, {icon:'⚠️'}); return; }
      doIt(note.trim());
      return;
    }
    _confirmBox({ msg: msg, icon: (act === 'CANCEL' ? '⚠️' : '❓'),
      okText: (act === 'SUBMIT' ? '상신' : act === 'APPROVE' ? '승인' : '회수'),
      onOk: function(){ doIt(''); } });
  };

  // 결재선 설정 — 단계 이름을 순서대로. 비우면 그 단계는 사라진다(2단계로 줄이려면 뒤 둘을 비운다).
  window.qfApprLineEdit = function(){
    var line = (apprState && apprState.line) || [];
    var cur = line.map(function(r){ return r.stepnm; }).join(', ');
    var v = window.prompt(
      '결재 단계를 순서대로 쉼표로 구분해 입력하세요.\n' +
      '예) 담당, 팀장, 부서장, 이사장\n' +
      '2단계로 줄이려면  담당, 승인  처럼 적으면 됩니다.', cur || '담당, 팀장, 부서장, 이사장');
    if (v === null) return;
    var arr = v.split(',').map(function(s){ return s.trim(); }).filter(function(s){ return s; });
    if (!arr.length) { _alertBox('단계를 1개 이상 입력해 주세요.', {icon:'⚠️'}); return; }
    if (arr.length > 10) { _alertBox('단계는 최대 10개까지입니다.', {icon:'⚠️'}); return; }
    var p = {};
    arr.forEach(function(nm, i){ p['step' + (i + 1)] = nm; });
    post('/qps/apprLineSave.do', p).then(function(){
      _toast('결재선이 저장되었습니다(' + arr.length + '단계).', 'ok');
      return apprLoad();
    }).catch(err);
  };

  // ---------- 인쇄(A4) ----------
  // ★인쇄는 **별도 창**에서 한다(2026-08-09 확정). 화면 안에서 print CSS 로 앱을 숨기는 방식은
  //   ①종이 아래에 `localhost:8080/user/dashboard.do` 같은 **주소 바닥글**이 그대로 찍히고
  //   ②앱 CSS 가 인쇄물에 스며든다. 빈 문서(about:blank)에 우리 서식만 써 넣으면 둘 다 사라진다.
  //   (날짜·페이지번호까지 없애려면 인쇄 창의 [머리글 및 바닥글] 체크를 끄면 된다 — 브라우저 설정)
  var PRINT_CSS =
    '@page{ size:A4 portrait; margin:12mm 12mm 14mm; }' +
    'body{ margin:0; font-family:"맑은 고딕",Malgun Gothic,sans-serif; color:#000; }' +
    '.qp-h1{ font-size:19px; font-weight:800; text-align:center; letter-spacing:-.3px; margin:0 0 3px; }' +
    '.qp-h2{ font-size:12.5px; text-align:center; color:#333; margin:0 0 12px; }' +
    '.qp-sec{ font-size:13px; font-weight:800; margin:14px 0 5px; padding-bottom:3px; border-bottom:1.5px solid #333; }' +
    'table{ width:100%; border-collapse:collapse; font-size:11px; }' +
    'th,td{ border:1px solid #666; padding:3px 4px; text-align:center; }' +
    'th{ background:#eee; font-weight:700; }' +
    'td.l{ text-align:left; }' +
    '.qp-def td{ text-align:left; }' +
    '.qp-def th{ width:78px; background:#f2f2f2; }' +
    '.qp-appr{ float:right; width:auto; border-collapse:collapse; font-size:10px; margin:0 0 6px 8px; }' +
    '.qp-appr th{ background:#f2f2f2; padding:2px 6px; font-size:10px; }' +
    '.qp-appr td{ height:46px; width:62px; vertical-align:middle; padding:2px; }' +
    '.qp-appr td .nm{ font-size:11px; font-weight:700; }' +
    '.qp-appr td .dt{ font-size:8.5px; color:#444; }' +
    '.qp-txt{ border:1px solid #666; padding:6px 8px; font-size:11px; min-height:56px;' +
    '         white-space:pre-wrap; line-height:1.6; text-align:left; }' +
    '.qp-foot{ margin-top:16px; font-size:11px; text-align:center; }' +
    '.qp-chart{ width:100%; max-height:230px; object-fit:contain; }' +
    /* ★강제 페이지 나눔을 쓰지 않는다 — 1장 아래가 통째로 비는 원인이었다(2026-08-09 지적).
         내용이 자연스럽게 흐르다 넘칠 때만 다음 장으로 가고, 표·분석박스만 잘리지 않게 잡는다. */
    '.qp-nobreak{ page-break-inside:avoid; }' +
    'table{ page-break-inside:avoid; }' +
    '.qp-txt{ page-break-inside:avoid; }';

  function prdLabel(){
    var k = document.getElementById('qfPrdKey').value;
    return year() + '년 ' + (k.charAt(0) === 'Q' ? (k.charAt(1) + '/4 분기')
                           : (k === 'H1' ? '상반기(중간)' : '하반기(최종)'));
  }
  // 제목·파일명용 — '/' 가 파일명에 못 쓰는 글자라 '1/4 분기' 를 '1분기' 로 쓴다
  // (그냥 지우면 '14 분기' 가 되어 이상해진다 — 2026-08-09 실제 발생)
  function prdLabelPlain(){
    var k = document.getElementById('qfPrdKey').value;
    return year() + '년 ' + (k.charAt(0) === 'Q' ? (k.charAt(1) + '분기')
                           : (k === 'H1' ? '상반기' : '하반기'));
  }
  function today(){
    var d = new Date();
    return d.getFullYear() + '. ' + (d.getMonth() + 1) + '. ' + d.getDate() + '.';
  }
  window.qfPrint = function(){
    if (!lastCalc || !curDef || !curDef.indinm) { _alertBox('지표를 먼저 불러온 뒤 인쇄해 주세요.', {icon:'⚠️'}); return; }
    var d = curDef, lab = labelsOf(d), ms = lastCalc.months || [];

    // ★확정(동결)된 기간이면 동결값으로 찍는다 — 화면 표(applyFrozenToView)와 같은 헬퍼를 쓴다
    var fb = frozenMap();
    var useFrozen = Object.keys(fb).length > 0;
    ms = mergedMonths(fb);

    // TAT 는 정규/응급 상세가 있으면 인쇄물에도 축별 표를 싣는다 — 자료를 받아온 뒤 본문을 만든다
    var goPrint = function(axesRows){

    // 결재란 — 결재선 단계만큼 칸을 만들고 **현재 회차** 승인에서 이름·일시를 채운다(화면과 같은 규칙)
    var s = apprState || {}, line = s.line || [], hist = s.hist || [];
    var signBy = signMapOf(hist);
    var apprHtml = '';
    if (line.length) {
      apprHtml = '<table class="qp-appr"><thead><tr>' +
        line.map(function(r){ return '<th>' + esc(r.stepnm) + '</th>'; }).join('') +
        '</tr></thead><tbody><tr>' +
        line.map(function(r){
          var h = signBy[Number(r.stepno)];
          return '<td>' + (h ? ('<div class="nm">' + esc(decNm(h.actnm) || h.actuser || '') + '</div>' +
                                '<div class="dt">' + esc((h.actdttm || '').substring(0, 10)) + '</div>') : '') + '</td>';
        }).join('') + '</tr></tbody></table>';
    }

    // 월별 집계
    var mHtml = '<table><thead><tr><th style="width:86px;">구분</th>' +
      ms.map(function(m){ return '<th>' + Number(m.mm) + '월</th>'; }).join('') + '</tr></thead><tbody>' +
      '<tr><th>' + lab.numer + '</th>' + ms.map(function(m){
          return '<td>' + ((d.numersrc === 'MONITOR' && !m.denom) ? '-' : num(m.numer)) + '</td>'; }).join('') + '</tr>' +
      '<tr><th>' + lab.denom + '</th>' + ms.map(function(m){ return '<td>' + (m.denom ? num(m.denom) : '-') + '</td>'; }).join('') + '</tr>' +
      '<tr><th>' + lab.rate + '(' + esc(unit(d)) + ')</th>' + ms.map(function(m){ return '<td>' + fmtRate(m.rate, d) + '</td>'; }).join('') + '</tr>' +
      '</tbody></table>';

    // 분기·반기·연간
    var rows = [];
    (lastCalc.quarters || []).forEach(function(q, i){
      rows.push([(i + 1) + '/4 분기', mergedRollup(fb, 'Q', year() + 'Q' + (i + 1), q)]); });
    if ((lastCalc.halves || [])[0]) rows.push(['상반기', mergedRollup(fb, 'H', year() + 'H1', lastCalc.halves[0])]);
    if ((lastCalc.halves || [])[1]) rows.push(['하반기', mergedRollup(fb, 'H', year() + 'H2', lastCalc.halves[1])]);
    if (lastCalc.year) rows.push(['연간', mergedRollup(fb, 'Y', year(), lastCalc.year)]);

    // 축별(정규/응급) 표 — 상세가 있을 때만 Ⅲ 표 아래 덧붙는다(화면 축별 집계와 같은 계산)
    var axisHtml = '';
    (function(){
      var byAxis = {};
      (axesRows || []).forEach(function(r){
        var a = byAxis[r.axiscd] || (byAxis[r.axiscd] = { n:[], d:[] });
        var arr = (r.valgb === 'DENOM') ? a.d : a.n;
        MONTHS.forEach(function(m, i){ arr[i] = Number(r['m' + m] || 0); });
      });
      var axes = manualAxes().filter(function(ax){ return byAxis[ax]; });
      if (!axes.length) return;
      function sum(arr, from, to){ var s = 0; for (var i = from; i < to; i++) s += (arr[i] || 0); return s; }
      var COLS = [['1/4 분기', 0, 3], ['2/4 분기', 3, 6], ['3/4 분기', 6, 9], ['4/4 분기', 9, 12], ['연간', 0, 12]];
      axisHtml = '<div style="margin-top:8px; font-size:10.5px; font-weight:700;">▪ 정규·응급별 집계</div>' +
        '<table class="qp-nobreak"><thead><tr><th style="width:70px;">구분</th>' +
        COLS.map(function(c){ return '<th>' + c[0] + '</th>'; }).join('') + '</tr></thead><tbody>' +
        axes.map(function(ax){
          var a = byAxis[ax];
          return '<tr><th>' + esc(ax) + '</th>' + COLS.map(function(c){
            var n = sum(a.n, c[1], c[2]), dd = sum(a.d, c[1], c[2]);
            return '<td>' + (dd > 0 ? (num(n) + '/' + num(dd) + ' = ' +
                   fmtRate(n * Number(d.multiplier || 100) / dd, d) + esc(unit(d))) : '-') + '</td>';
          }).join('') + '</tr>';
        }).join('') + '</tbody></table>';
    })();
    // ★목표 충족 판정 — 목표값(TARGET_VAL) + 목표방향(GOAL_DIR)이 둘 다 있어야 셈한다.
    //   방향이 없으면 절반이 거꾸로 판정된다(낙상은 이하가 충족, 손위생은 이상이 충족).
    //   목표가 비어 있으면 열 자체를 내지 않는다 — 빈 칸만 있는 열은 「판정을 못 했다」를 숨긴다.
    var tgt = (d.targetval == null || d.targetval === '') ? null : Number(d.targetval);
    var dirH = (d.goaldir === 'H');
    var hasTgt = (tgt != null && !isNaN(tgt));
    function judge(rate){
      if (!hasTgt || rate == null) return '-';
      var ok = dirH ? (Number(rate) >= tgt) : (Number(rate) <= tgt);
      return ok ? '<b>충족</b>' : '미충족';
    }
    var tgtHead = hasTgt
      ? ('<th style="width:78px;">목표 ' + (dirH ? '≥' : '≤') + ' ' + fmtRate(tgt, d) + esc(unit(d)) + '</th>')
      : '';
    var qHtml = '<table><thead><tr><th>구분</th><th>' + lab.numer + '</th><th>' + lab.denom + '</th><th>' + lab.rate + '</th>' +
      tgtHead + '</tr></thead><tbody>' +
      rows.map(function(r){
        var o = r[1], mz = (d.numersrc === 'MONITOR' && !o.denom);
        return '<tr><td>' + esc(r[0]) + '</td><td>' + (mz ? '-' : num(o.numer)) + '</td>' +
               '<td>' + (o.denom ? num(o.denom) : '-') + '</td>' +
               '<td><b>' + (o.rate == null ? '-' : (fmtRate(o.rate, d) + ' ' + esc(unit(d)))) + '</b></td>' +
               (hasTgt ? ('<td>' + judge(o.rate) + '</td>') : '') + '</tr>';
      }).join('') + '</tbody></table>' +
      (hasTgt ? '' : '<div style="font-size:9px;color:#666;">※ 목표값이 등록되지 않아 충족 여부를 표시하지 않았습니다 ' +
                     '— [지표정의서]에서 목표값과 목표방향을 먼저 등록하세요.</div>');

    // 분류별 집계 — 화면의 6축 + 사고분류. ★사고보고형에만 성립한다(평가표형·대장형은 사고 행이 없다).
    var brkHtml = '', harmHtml = '';
    (function(){
      if (d.numersrc !== 'INCIDENT') return;
      var bd = (lastCalc && lastCalc.breakdown) || {};
      function axTbl(key, nm){
        var list = bd[key] || [];
        if (!list.length) return '';
        var tot = list.reduce(function(s, r){ return s + Number(r.cnt || 0); }, 0);
        return '<table class="qp-nobreak" style="width:32%; float:left; margin:0 1% 6px 0;">' +
               '<thead><tr><th colspan="3">' + esc(nm) + '</th></tr>' +
               '<tr><th>구분</th><th style="width:34px;">건수</th><th style="width:40px;">비율</th></tr></thead><tbody>' +
               list.map(function(r){
                 var c = Number(r.cnt || 0);
                 return '<tr><td class="l">' + esc(r.code) + '</td><td>' + num(c) + '</td>' +
                        '<td>' + (tot ? (Math.round(c / tot * 1000) / 10) + '%' : '-') + '</td></tr>';
               }).join('') +
               '<tr><td class="l"><b>계</b></td><td><b>' + num(tot) + '</b></td><td></td></tr>' +
               '</tbody></table>';
      }
      harmHtml = axTbl('HARM', '사고분류(위해등급)');
      var six = ['TYPE','PLACE','TIME','DAMAGE','AGE','DEPT'].map(function(k){ return axTbl(k, AXIS_NM[k]); }).join('');
      if (six) brkHtml = six + '<div style="clear:both;"></div>';
      if (harmHtml) harmHtml = harmHtml + '<div style="clear:both;"></div>';
    })();

    // 차트 — 캔버스를 이미지로 떠서 넣는다(숨긴 영역에서는 다시 그릴 수 없다)
    var chartHtml = '';
    try {
      if (chart) chartHtml = '<img class="qp-chart" src="' + chart.getDataURL({ pixelRatio: 2, backgroundColor: '#fff' }) + '">';
    } catch (e) { chartHtml = ''; }

    var acts = [val('r_act1'), val('r_act2'), val('r_act3'), val('r_act4')].filter(function(a){ return a; });
    // ★병원명은 배지 글자를 긁지 않고 서버 응답값(HOSP_NM)을 쓴다 —
    //   배지를 파싱하면 병원코드·입원건수까지 딸려 오고, 무엇보다 화면 로드 시점 값이라 병원을 바꾸면 틀린다.
    var hosp = HOSP_NM || (lastCalc.hosp && lastCalc.hosp.hospnm) || '';

    // ★절 번호는 세어서 붙인다 — 섹션이 조건부로 빠지는데(분류표·추이) 번호를 손으로 박으면
    //   'Ⅲ 다음에 Ⅴ' 같은 구멍이 생긴다.
    var RN = ['','Ⅰ','Ⅱ','Ⅲ','Ⅳ','Ⅴ','Ⅵ','Ⅶ','Ⅷ','Ⅸ','Ⅹ'], secNo = 0;
    function sec(t){ secNo++; return '<div class="qp-sec">' + (RN[secNo] || secNo) + '. ' + t + '</div>'; }

    var cyc = (d.cyclegb === 'Q') ? '분기별' : (d.cyclegb === 'H') ? '반기별' : (d.cyclegb === 'Y') ? '연 1회' : (d.cyclegb || '-');

    var body =
      '<div>' +
        apprHtml +
        '<div class="qp-h1">' + esc(d.indinm) + ' 지표분석보고서</div>' +
        '<div class="qp-h2">' + esc(hosp) + ' · ' + esc(prdLabel()) + '</div>' +
        '<div style="clear:both;"></div>' +

        sec('지표 정의') +
        '<table class="qp-def qp-nobreak"><tbody>' +
          '<tr><th>지표명</th><td colspan="3">' + esc(d.indinm) + '</td></tr>' +
          '<tr><th>지표정의</th><td colspan="3">' + esc(d.definition || '-') + '</td></tr>' +
          '<tr><th>분자</th><td colspan="3">' + esc(d.numerdesc || '-') + '</td></tr>' +
          '<tr><th>분모</th><td colspan="3">' + esc(d.denomdesc || '-') + '</td></tr>' +
          '<tr><th>산식</th><td>분자 ÷ 분모 × ' + num(d.multiplier || 1000) + ' = ' + esc(unit(d)) + '</td>' +
              '<th>목표값</th><td>' + (hasTgt ? ((dirH ? '≥ ' : '≤ ') + fmtRate(tgt, d) + ' ' + esc(unit(d))) : '-') + '</td></tr>' +
        '</tbody></table>' +

        // ★모니터링 블록 — 원본 보고서가 「누가·얼마나 자주·무엇으로 모으고 어디에 보고하는가」를
        //   한 덩어리로 보여준다. 정의서에 흩어져 있던 필드를 여기 모았다.
        sec('모니터링') +
        '<table class="qp-def qp-nobreak"><tbody>' +
          '<tr><th>자료수집원</th><td>' + esc(d.sourcenm || '-') + '</td>' +
              '<th>수집·분석방법</th><td>' + esc(d.methodnm || '-') + '</td></tr>' +
          '<tr><th>측정주기</th><td>' + esc(cyc) + '</td>' +
              '<th>보고주기</th><td>' + esc(d.rptcycle || '-') + '</td></tr>' +
          '<tr><th>관리담당자</th><td>' + esc(d.ownernm || '-') + '</td>' +
              '<th>담당부서</th><td>' + esc(d.deptnm || '-') + '</td></tr>' +
          '<tr><th>보고범위</th><td colspan="3">' + esc(d.rptscope || '-') + '</td></tr>' +
        '</tbody></table>' +

        sec('월별 집계') + mHtml +
        sec('분기 · 반기 · 연간') + qHtml + axisHtml +
        (harmHtml ? (sec('사고분류') + harmHtml) : '') +
        (chartHtml ? (sec('추이') + '<div class="qp-nobreak">' + chartHtml + '</div>') : '') +
      '</div>' +

      (brkHtml ? ('<div>' + sec('분류별 집계') +
                  '<div style="font-size:9px;color:#555;margin-bottom:4px;">※ 기간 내 보고 건을 기준으로 집계 ' +
                  '— 분자와 같은 기준입니다.</div>' + brkHtml + '</div>') : '') +

      '<div>' +
        sec('분석') +
        '<div class="qp-txt">' + esc(val('r_analysis') || '') + '</div>' +
        sec('개선계획') +
        '<div class="qp-txt">' + esc(val('r_plan') || '') + '</div>' +
        (acts.length ? (sec('개선활동') + '<table><tbody>' +
            acts.map(function(a, i){ return '<tr><th style="width:70px;">' + (i + 1) + '</th><td class="l">' + esc(a) + '</td></tr>'; }).join('') +
          '</tbody></table>') : '') +
        '<div class="qp-foot">작성일 : ' + today() +
          (useFrozen ? ' · 이 수치는 최종승인 시점에 확정(동결)된 값입니다' : '') + '</div>' +
      '</div>';

    // ★제출물이라 어느 병원으로 나가는지 한 번 확인시킨다 —
    //   위너넷 계정은 여러 병원을 오가므로 "병원을 안 바꾸고 인쇄"가 실제로 일어난다(2026-08-09 지적).
    _confirmBox({
      msg: '<b>' + esc(hosp || '(병원 미확인)') + '</b> 기준으로 인쇄합니다.<br>' +
           esc(d.indinm) + ' · ' + esc(prdLabel()) + '<br><br>' +
           '<span style="color:#6b7c86;font-size:12px;">다른 병원이면 상단 [병원검색]에서 바꾼 뒤 다시 인쇄하세요.<br>' +
           '인쇄창이 새 창으로 열립니다. 종이 위·아래의 <b>날짜·페이지번호</b>까지 없애려면<br>' +
           '인쇄 설정의 <b>[추가 설정] → [머리글 및 바닥글]</b> 체크를 끄세요.</span>',
      icon: '🖨', okText: '인쇄',
      onOk: function(){ doPrint(body, (d.indinm || '지표') + ' 지표분석보고서_' + (hosp || '') + '_' + prdLabelPlain()); }
    });
    };   // /goPrint

    // 축 상세가 있는 지표만 자료를 받아온다(실패해도 축 표 없이 인쇄는 진행)
    if (curDef.numersrc === 'MANUAL' && manualAxes().length > 0) {
      post('/qps/manualGet.do', { indiCd: INDI_CD, inYear: year() })
        .then(function(r){ goPrint(r.axes || []); })
        .catch(function(){ goPrint([]); });
    } else {
      goPrint([]);
    }
  };

  // 별도 창에서 인쇄 — 제목(머리글)은 우리가 정하고, 주소 바닥글은 about:blank 라 사라진다.
  // 'PDF로 저장' 을 고르면 이 제목이 **파일명 기본값**이 된다.
  function doPrint(bodyHtml, title){
    var w = window.open('', '_blank', 'width=900,height=1000');
    if (!w) { _alertBox('팝업이 차단되어 인쇄창을 열지 못했습니다.<br>주소창 오른쪽의 팝업 차단을 허용해 주세요.', {icon:'⚠️'}); return; }
    var safe = String(title).replace(/[\\\/:*?"<>|]/g, '-');   // 파일명에 못 쓰는 글자
    w.document.open();
    w.document.write('<!doctype html><html lang="ko"><head><meta charset="utf-8">' +
      '<title>' + esc(safe) + '</title><style>' + PRINT_CSS + '</style></head><body>' + bodyHtml + '</body></html>');
    w.document.close();
    w.focus();
    // 차트 이미지가 붙은 뒤에 인쇄 — 바로 부르면 그림이 빈 채로 나갈 수 있다
    setTimeout(function(){
      try { w.print(); } catch (e) { }
    }, 400);
  }

  // ---------- 공통코드 ----------
  // selectbox 목록(위해등급·유형·직군·순간)은 공통코드(CODE_GB='Q')에서 온다 —
  // 기준정보 화면에서 행을 추가하면 배포 없이 항목이 는다.
  // ★코드가 비어 있거나 조회가 실패해도 화면은 **기존 하드코딩 목록으로 그대로 동작**한다(폴백).
  var CODES = {};
  function codeRows(cd){ return CODES[cd] || []; }
  // 값 보존 재구성 — 수정 중이던 값이 목록에 없으면 항목으로 덧붙인다(옛 자료가 조용히 지워지지 않게)
  function fillSel(id, rows){
    var sel = document.getElementById(id);
    if (!sel || !rows.length) return;
    var keep = sel.value;
    sel.innerHTML = '<option value="">선택</option>' +
      rows.map(function(r){ return '<option value="' + esc(r.subcode) + '">' + esc(r.subcodenm) + '</option>'; }).join('');
    if (keep) {
      var has = rows.some(function(r){ return String(r.subcode) === keep; });
      if (!has) sel.insertAdjacentHTML('beforeend', '<option>' + esc(keep) + '</option>');
      sel.value = keep;
    }
  }
  function applyCodes(){
    fillSel('f_levelCd',  codeRows('QPS_LEVEL'));
    fillSel('f_placeCd',  codeRows('QPS_PLACE'));
    fillSel('f_damageCd', codeRows('QPS_DAMAGE'));
    fillSel('m_jobGb',    codeRows('QPS_JOB'));
    fillSel('m_momentCd', codeRows('QPS_MOMENT'));
  }

  // ---------- 초기 로드 ----------
  // ★indiLoad 를 맨 앞에 둔다 — 분모 탭(censusLoad)이 지표 마스터의 DENOM_GB(INDAYS/STAFF)를
  //   봐야 하기 때문. 순서를 되돌리면 직원안전사고가 다시 재원일수 칸에 저장된다(2026-08-09).
  // ★공통코드를 그보다 먼저 받는다 — incidSetupUi(유형 목록)·관찰 폼이 코드를 본다.
  //   실패해도 catch 로 삼키고 진행한다(코드는 폴백이 있는 부가물이라 화면을 막으면 안 된다).
  window.qfReload = function(){
    indiLoad().then(censusLoad).then(incidLoad).then(qfReportLoad).catch(err);
  };
  $(function(){
    post('/qps/codeList.do', {}).then(function(res){ CODES = res.codes || {}; applyCodes(); })
      .catch(function(){ CODES = {}; })
      .then(function(){ qfReload(); });
  });
})();

/* === 글자 크기 (2026-08-18 요청) ==========================================
   QI 계획서(qpsQiPlan)의 zzZoom 과 **같은 규칙** - 0.8~1.6배, 0.1 단위, ↺ 는 처음 크기.
   ★고른 크기는 **이 PC 이 브라우저에만** 남는다(localStorage). 키는 화면마다 따로 둔다. */
(function(){
  var W = 'qpsFall', ZKEY = 'qpsZoom_' + W;
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
</div><%-- /#qpsFall --%>
</div><%-- /.dashboard-wrapper --%>
