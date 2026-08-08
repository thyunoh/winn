<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%-- qpsFall.jsp — QPS 낙상 지표 파일럿 (2026-08-08)
     · 근거: SUNWOO DB 실측. 산식 = 낙상보고건수(Level2 이상) ÷ 총재원일수 × 1,000 (‰)
     · SUNWOO 는 지표분석보고서에 사람이 '0.67‰' 를 타이핑했다. 여기서는 서버가 계산한다.
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
     data-indicd="<c:out value='${indiCd}' default='FALL'/>" data-incidgb="<c:out value='${incidGb}' default='FALL'/>">
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

  /* 지표 정의 박스 */
  #qpsFall .qf-def{ background:#f7fbf9; border:1px solid #d9e8e2; border-radius:8px; padding:10px 12px; font-size:13px; line-height:1.7; }
  #qpsFall .qf-def b{ color:#1f5a4b; }
  #qpsFall .qf-def .qf-formula{ font-family:Consolas,monospace; background:#fff; border:1px solid #d9e8e2;
      border-radius:5px; padding:2px 7px; display:inline-block; }
  #qpsFall .qf-warn{ background:#fff8f0; border:1px solid #f0dcc0; color:#8a5a20; border-radius:8px;
      padding:9px 12px; font-size:13px; margin-bottom:12px; }
  #qpsFall #qfChart{ width:100%; height:300px; }

  /* ★저장 안내(_toast) 위치 — 이 화면에서만 화면 '중앙'으로 올린다(2026-08-08 요청).
       공용 ui-message.js 는 bottom:34px 인데, 하단의 Q&A 말풍선·질문등록 배너에 가려
       "저장되었습니다"가 안 보였다. #qpsFall 접두어를 붙이지 않았지만 이 규칙은
       **이 JSP 가 로드된 화면에만** 적용되므로 다른 화면은 그대로다(공용 파일은 안 건드림).
       ※함께 고친 것: _toast 타입을 'success' → 'ok' 로. 공용 컴포넌트가 아는 값은
         ok/warn/err/info 뿐이라 'success' 는 배경색이 안 붙어 흰 글자만 떴다(=안 보였다). */
  .toast-wrap{ top:50% !important; bottom:auto !important; transform:translate(-50%,-50%) !important; }
  .toast-item{ font-size:16px !important; padding:14px 26px !important; }
</style>

<div class="qf-head">
  <div class="qf-title"><span class="qf-dot"></span>QPS
    <c:out value="${indiNm}" default="지표"/></div>
  <div class="qf-sub">사고보고 → 재원일수 → 분기 지표 자동산출</div>
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
</div>

<div class="qf-tabs">
  <div class="qf-tab on" data-pane="p1" onclick="qfTab('p1');">📋 낙상 사고보고</div>
  <div class="qf-tab"    data-pane="p4" onclick="qfTab('p4');" style="display:none;">🧼 관찰 입력</div>
  <div class="qf-tab"    data-pane="p2" onclick="qfTab('p2');">🛏 재원일수(분모)</div>
  <div class="qf-tab"    data-pane="p3" onclick="qfTab('p3');">📈 지표분석</div>
</div>

<!-- ================= 탭1 : 사고보고 ================= -->
<div class="qf-pane on" id="p1">
  <div class="qf-card">
    <h4>낙상 사고 등록 <span class="qf-hint">— 위해등급 Level 2 이상만 지표 분자에 들어간다</span></h4>
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
        <label>환자 (등록번호·성명)</label>
        <div style="display:flex; gap:5px;">
          <input type="text" id="f_ptNo" maxlength="30" autocomplete="off" style="flex:1; min-width:0;"
                 placeholder="직접 입력 또는 [찾기]"
                 onkeydown="qfPatKey(event);" oninput="qfPatSearch();" onfocus="qfPatSearch(true);">
          <button type="button" class="qf-btn ghost" style="padding:5px 10px; white-space:nowrap;"
                  onclick="qfPatOpen();">🔍 찾기</button>
        </div>
        <div id="qfPatBox" class="qf-pick"></div>
        <div id="qfPatInfo" class="qf-pickinfo"></div>
      </div>
      <div><label>성별</label>
        <select id="f_ptSex"><option value="">선택</option><option value="M">남</option><option value="F">여</option></select></div>
      <div><label>나이</label><input type="number" id="f_ptAge" min="0" max="120"></div>
      <div><label>위해등급 (분자기준)</label>
        <select id="f_levelCd">
          <option value="">선택</option>
          <option value="LV1">Level 1 (위해없음)</option>
          <option value="LV2">Level 2 (경미)</option>
          <option value="LV3">Level 3 (중등도)</option>
          <option value="LV4">Level 4 (중증)</option>
          <option value="LV5">Level 5 (사망)</option>
        </select></div>

      <div><label>낙상유형</label>
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
    <h4>관찰 기록 등록 <span class="qf-hint">— 분자=수행건수, 분모=관찰건수(수행률 = 수행÷관찰 ×100)</span></h4>
    <input type="hidden" id="m_monSeq" value="">
    <div class="qf-form">
      <div><label>관찰일 *</label><input type="date" id="m_obsDt"></div>
      <div><label>병동</label><input type="text" id="m_wardCd" maxlength="20"></div>
      <div><label>직군</label>
        <select id="m_jobGb"><option value="">선택</option>
          <option>의사</option><option>간호사</option><option>간호조무사</option><option>물리치료사</option><option>기타</option></select></div>
      <div><label>순간(moment)</label>
        <select id="m_momentCd"><option value="">선택</option>
          <option>환자 접촉 전</option><option>청결/무균 처치 전</option><option>체액 노출 후</option>
          <option>환자 접촉 후</option><option>환자 주변 접촉 후</option></select></div>
      <div><label>관찰건수 (분모) *</label><input type="number" id="m_obsCnt" min="0"></div>
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
        <thead><tr><th>관찰일</th><th>병동</th><th>직군</th><th>순간</th><th>관찰</th><th>수행</th><th>수행률</th><th>관찰자</th><th>수정일시</th></tr></thead>
        <tbody></tbody>
      </table>
    </div>
  </div>
</div>

<!-- ================= 탭2 : 분모 ================= -->
<div class="qf-pane" id="p2">
  <div class="qf-card">
    <h4>월별 총재원일수 <span class="qf-hint">— 지표의 분모(해당 월 일일 재원환자 수의 합)</span></h4>
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
      <button type="button" class="qf-btn ghost" onclick="qfCensusCalc();">⚙ 입퇴원 자료로 자동계산</button>
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
        <thead><tr><th>구분</th><th>분자(건)</th><th>분모(재원일수)</th><th>발생률</th></tr></thead>
        <tbody id="qfQtrBody"></tbody>
      </table>
    </div>
  </div>

  <div class="qf-card">
    <h4>추이</h4>
    <div id="qfChart"></div>
  </div>

  <div class="qf-card">
    <h4>분류별 집계 <span class="qf-hint">— 사고보고에서 자동 집계(분자와 같은 기준)</span></h4>
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
      <button type="button" class="qf-btn" onclick="qfReportSave();">서술 저장</button>
      <span class="qf-sub">분석·개선계획을 남겨둘 때만 누르면 됩니다. 안 눌러도 지표 수치에는 영향이 없습니다.</span>
    </div>
  </div>
</div>

<script>
(function(){
  var $root   = document.getElementById('qpsFall');
  var HOSP_CD = $root.getAttribute('data-hospcd') || '';
  var INDI_CD = $root.getAttribute('data-indicd')  || 'FALL';
  var INCID_GB= $root.getAttribute('data-incidgb') || INDI_CD;
  var MONTHS  = ['01','02','03','04','05','06','07','08','09','10','11','12'];
  // ★incidRaw 는 모듈 스코프여야 한다 — 행 클릭 핸들러는 한 번만 붙는데,
  //   목록을 다시 불러올 때마다 새 배열을 지역변수에 담으면 핸들러가 낡은 배열을 계속 본다(선택 시 옛 자료).
  var dtIncid = null, chart = null, curDef = null, incidRaw = [];
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
  function err(e){ _alertBox((e && e.message) ? e.message : '처리 중 오류가 발생했습니다.', {icon:'error'}); }
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
    if (!val('f_occurDt')) { _alertBox('발생일자를 입력해 주세요.', {icon:'warning'}); return; }
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
    if (!val('f_incidSeq')) { _alertBox('목록에서 삭제할 사고를 먼저 선택해 주세요.', {icon:'warning'}); return; }
    _confirmBox({ msg:'선택한 사고 보고를 삭제할까요?', icon:'warning', okText:'삭제', okColor:'#b23b3b',
      onOk: function(){
        post('/qps/incidentDelete.do', { incidSeq: val('f_incidSeq') }).then(function(){
          _toast('삭제되었습니다.', 'ok');
          qfIncidentClear();
          return incidLoad();
        }).then(indiLoad).catch(err);
      }});
  };

  // ---------- 탭2 : 분모 ----------
  function censusLoad(){
    var head = document.getElementById('qfCensusHead'), body = document.getElementById('qfCensusBody');
    head.innerHTML = '<th style="width:90px;">구분</th>' + MONTHS.map(function(m){ return '<th>' + Number(m) + '월</th>'; }).join('');
    body.innerHTML = '<td style="background:#f2f6f8; font-weight:700;">재원일수</td>' +
      MONTHS.map(function(m){
        return '<td><input type="number" id="c_m' + m + '" min="0" style="width:100%; text-align:right;"></td>';
      }).join('');
    return post('/qps/censusGet.do', { censusGb:'INDAYS', inYear: year() }).then(function(res){
      var c = res.census || {};
      MONTHS.forEach(function(m){ set('c_m' + m, c['m' + m]); });
    });
  }
  // ---------- 탭4 : 관찰 입력 (손위생 등 MONITOR) ----------
  function monitorLoad(){
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
    if (!val('m_obsDt')) { _alertBox('관찰일자를 입력해 주세요.', {icon:'warning'}); return; }
    if (!val('m_obsCnt')) { _alertBox('관찰건수(분모)를 입력해 주세요.', {icon:'warning'}); return; }
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
    if (!val('m_monSeq')) { _alertBox('목록에서 삭제할 기록을 먼저 선택해 주세요.', {icon:'warning'}); return; }
    _confirmBox({ msg:'선택한 관찰 기록을 삭제할까요?', icon:'warning', okText:'삭제', okColor:'#b23b3b',
      onOk: function(){
        post('/qps/monitorDelete.do', { monSeq: val('m_monSeq') }).then(function(){
          _toast('삭제되었습니다.', 'ok'); qfMonitorClear();
          return monitorLoad();
        }).then(indiLoad).catch(err);
      }});
  };

  // 자동산출 — 서버가 입퇴원 자료로 계산한 값을 칸에 채운다. 저장은 사람이 [저장]으로.
  window.qfCensusCalc = function(){
    post('/qps/censusCalc.do', { inYear: year() }).then(function(res){
      MONTHS.forEach(function(m){ set('c_m' + m, res['m' + m]); });
      _toast('입원 ' + num(res.stays || 0) + '건으로 계산했습니다. 값 확인 후 [저장]을 누르세요.', 'info');
    }).catch(err);
  };

  window.qfCensusSave = function(){
    var p = { censusGb:'INDAYS', inYear: year() };
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
      // ★지표 유형(numersrc)에 따라 탭 구성이 다르다:
      //   INCIDENT(낙상) = 사고보고 + 재원일수 + 지표분석
      //   PATVAL(욕창)   = 재원일수 + 지표분석 (입력 없음)
      //   MONITOR(손위생)= 관찰입력 + 지표분석 (재원일수 안 씀 — 분모가 관찰건수)
      var src = curDef.numersrc || 'INCIDENT';
      var isPatval  = (src === 'PATVAL');
      var isMonitor = (src === 'MONITOR');
      show('#qpsFall .qf-tab[data-pane="p1"]', src === 'INCIDENT');   // 사고보고
      show('#qpsFall .qf-tab[data-pane="p4"]', isMonitor);           // 관찰입력
      show('#qpsFall .qf-tab[data-pane="p2"]', !isMonitor);          // 재원일수(관찰형은 불필요)
      var bkCard = document.getElementById('qfBreak');
      if (bkCard) bkCard.closest('.qf-card').style.display = isPatval ? 'none' : '';
      // 첫 탭이 자기 유형과 안 맞으면 알맞은 탭으로 이동
      if (isMonitor && !document.querySelector('#qpsFall .qf-tab.on[data-pane="p4"]')
                    && !document.querySelector('#qpsFall .qf-tab.on[data-pane="p3"]')) qfTab('p4');
      if (isPatval  &&  document.querySelector('#qpsFall .qf-tab.on[data-pane="p1"]')) qfTab('p3');
      if (isMonitor) monitorLoad();
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
          warn.innerHTML = '관찰 기록이 없습니다. <b>[관찰 입력]</b> 탭에서 먼저 등록해 주세요.';
        } else {
          warn.style.display = (res.hasCensus === 'Y') ? 'none' : 'block';
          warn.innerHTML = '재원일수(분모)가 등록되지 않았습니다. <b>[재원일수(분모)]</b> 탭에서 먼저 입력해 주세요.';
        }
      }
    });
  }
  function unit(def){ return (def && def.unit) ? def.unit : '‰'; }
  // 발생률은 소수자리를 고정해 찍는다 — JSON 숫자 1.00 은 JS 에서 1 이 되어 '1‰' 로 보였다(2026-08-08).
  function fmtRate(v, def){
    if (v == null) return '-';
    var d = (def && def.decimals != null) ? Number(def.decimals) : 2;
    return Number(v).toFixed(d);
  }
  function renderDef(d){
    var box = document.getElementById('qfDef');
    if (!d || !d.indinm) {
      box.innerHTML = '지표 마스터(TBL_QPS_INDI_MST)에 <b>FALL</b> 행이 없습니다. DDL 시드를 먼저 적용해 주세요.';
      return;
    }
    box.innerHTML =
      '<div><b>' + esc(d.indinm) + '</b> — ' + esc(d.definition || '') + '</div>' +
      '<div>분자 : ' + esc(d.numerdesc || '-') + '</div>' +
      '<div>분모 : ' + esc(d.denomdesc || '-') + '</div>' +
      '<div>산식 : <span class="qf-formula">분자 ÷ 분모 × ' + num(d.multiplier || 1000) + ' = ' + esc(unit(d)) + '</span></div>' +
      '<div>주기 : ' + esc(d.cyclegb === 'Q' ? '분기별' : (d.cyclegb || '')) +
        ' · 자료원 : ' + esc(d.sourcenm || '-') + ' · 담당 : ' + esc(d.ownernm || '-') + '</div>';
  }
  function renderMonths(ms, def){
    document.getElementById('qfMonHead').innerHTML =
      '<th style="width:130px;">구분</th>' + ms.map(function(m){ return '<th>' + Number(m.mm) + '월</th>'; }).join('');
    document.getElementById('qfMonNumer').innerHTML =
      '<td style="background:#f2f6f8; font-weight:700;">분자(건)</td>' +
      ms.map(function(m){ return '<td class="num">' + num(m.numer) + '</td>'; }).join('');
    document.getElementById('qfMonDenom').innerHTML =
      '<td style="background:#f2f6f8; font-weight:700;">분모(재원일수)</td>' +
      ms.map(function(m){ return '<td class="num">' + (m.denom ? num(m.denom) : '-') + '</td>'; }).join('');
    document.getElementById('qfMonRate').innerHTML =
      '<td style="background:#f2f6f8; font-weight:700;">발생률(' + esc(unit(def)) + ')</td>' +
      ms.map(function(m){ return '<td class="num">' + fmtRate(m.rate, def) + '</td>'; }).join('');
  }
  function renderRollup(qs, hs, yr, def){
    var rows = [];
    qs.forEach(function(q, i){ rows.push([(i+1) + '/4 분기', q]); });
    if (hs[0]) rows.push(['상반기', hs[0]]);
    if (hs[1]) rows.push(['하반기', hs[1]]);
    if (yr)    rows.push(['연간',   yr]);
    document.getElementById('qfQtrBody').innerHTML = rows.map(function(r){
      var o = r[1];
      return '<tr' + (r[0] === '연간' ? ' class="qf-sum"' : '') + '>' +
             '<td>' + esc(r[0]) + '</td>' +
             '<td class="num">' + num(o.numer) + '</td>' +
             '<td class="num">' + (o.denom ? num(o.denom) : '-') + '</td>' +
             '<td class="num"><b>' + (o.rate == null ? '-' : (fmtRate(o.rate, def) + ' ' + esc(unit(def)))) + '</b></td></tr>';
    }).join('');
  }
  function renderChart(ms, def){
    var el = document.getElementById('qfChart');
    if (typeof echarts === 'undefined' || !el) return;
    if (!chart) chart = echarts.init(el);
    chart.setOption({
      tooltip: { trigger:'axis' },
      legend:  { data:['발생률(' + unit(def) + ')','건수'] },
      grid:    { left:50, right:50, top:40, bottom:30 },
      xAxis:   { type:'category', data: ms.map(function(m){ return Number(m.mm) + '월'; }) },
      yAxis: [ { type:'value', name: unit(def) }, { type:'value', name:'건' } ],
      series: [
        { name:'발생률(' + unit(def) + ')', type:'line', smooth:true, connectNulls:false,
          data: ms.map(function(m){ return m.rate == null ? null : Number(m.rate); }),
          itemStyle:{ color:'#1f5a4b' } },
        { name:'건수', type:'bar', yAxisIndex:1, barWidth:14,
          data: ms.map(function(m){ return m.numer; }),
          itemStyle:{ color:'rgba(42,118,101,.35)' } }
      ]
    });
  }
  var AXIS_NM = { PLACE:'발생장소', DAMAGE:'손상유형', TYPE:'사고유형', DEPT:'보고부서', AGE:'연령대', TIME:'시간대' };
  var AXIS_MON = { JOB:'직군', WARD:'병동', MOMENT:'순간(moment)' };
  function renderBreak(bd){
    var wrap = document.getElementById('qfBreak'), html = '';
    var isMon = (curDef && curDef.numersrc === 'MONITOR');
    var axes = isMon ? AXIS_MON : AXIS_NM;
    Object.keys(axes).forEach(function(k){
      var list = bd[k] || [];
      var cols = isMon ? 3 : 2;
      html += '<table class="qf-grid" style="width:auto; min-width:' + (isMon ? 240 : 180) + 'px;">' +
              '<thead><tr><th colspan="' + cols + '">' + axes[k] + '</th></tr></thead>';
      if (isMon) html += '<thead><tr><th></th><th>수행/관찰</th><th>수행률</th></tr></thead>';
      html += '<tbody>';
      if (!list.length) html += '<tr><td colspan="' + cols + '" style="color:#8a99a3;">자료 없음</td></tr>';
      else list.forEach(function(r){
        if (isMon) {
          html += '<tr><td>' + esc(r.code) + '</td><td class="num">' + num(r.numer) + ' / ' + num(r.denom) + '</td>' +
                  '<td class="num">' + (r.rate == null ? '-' : r.rate + '%') + '</td></tr>';
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
  })();
  function prdOf(){ var k = document.getElementById('qfPrdKey').value; return { gb: k.charAt(0), key: year() + k }; }
  window.qfReportLoad = function(){
    var p = prdOf();
    post('/qps/reportGet.do', { indiCd: INDI_CD, prdGb: p.gb, prdKey: p.key }).then(function(res){
      var r = res.report || {};
      set('r_act1', r.act1txt); set('r_act2', r.act2txt); set('r_act3', r.act3txt); set('r_act4', r.act4txt);
      set('r_analysis', r.analysistxt); set('r_plan', r.plantxt);
      document.getElementById('qfRptStat').textContent = r.upddttm ? ('최종수정 ' + r.upddttm) : '작성 전';
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

  // ---------- 초기 로드 ----------
  window.qfReload = function(){
    incidLoad().then(censusLoad).then(indiLoad).then(qfReportLoad).catch(err);
  };
  $(function(){ qfReload(); });
})();
</script>
</div><%-- /#qpsFall --%>
</div><%-- /.dashboard-wrapper --%>
