<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%--
  일괄 출력 (2026-09-07 사용자 요청 「일괄 작성·일괄 출력·일괄 사인 형태의 업무 위주」)
    요양병원은 전문인력이 모자라 서식을 하나씩 열어 뽑는 방식이 현장에서 안 돌아간다.
    고른 서식을 **한 번에 이어 붙여** 인쇄한다 — 실사 준비 묶음을 한 번의 인쇄로 끝내라는 뜻이다.

  ★어떻게 모으나 : 서식 화면을 숨은 iframe 으로 띄우고 그 화면의 **제 인쇄 함수**를 부른다.
    화면마다 인쇄 조립이 이미 있으니 그걸 그대로 쓴다(같은 결과가 두 벌로 갈리지 않게).
    인쇄 함수는 공통 창구 qpsPrintOut(제목, CSS, 본문) 을 거치는데, 일괄일 때는 창을 띄우지 않고
    이 화면으로 넘겨 준다(sidebar.jsp 의 QPS_BULK 표식).

  ★업무를 벗어나지 않는다 : 자료를 새로 만들거나 고치지 않는다. **화면에 있는 그대로** 모아 인쇄만 한다.
--%>
<div class="dashboard-wrapper">
<style>
  #qpsPrintAll{ padding:14px 16px 24px; }
  #qpsPrintAll h3{ margin:0 0 4px; font-size:18px; font-weight:800; color:#1f5a4b; }
  #qpsPrintAll .sub{ font-size:12.5px; color:#6b7a83; margin-bottom:14px; }
  #qpsPrintAll .card{ border:1px solid #dfe6ea; border-radius:10px; padding:14px 16px; background:#fff; max-width:1080px; }
    /* 묶음 머리 (2026-09-07 서식 36종) */
  #qpsPrintAll .grp{ display:flex; align-items:center; gap:8px; margin:12px 0 2px; padding:4px 4px 3px;
                      border-bottom:1px solid #dfe6ea; font-size:12.5px; font-weight:800; color:#1f5a4b; }
  #qpsPrintAll .grp:first-child{ margin-top:2px; }
  #qpsPrintAll .grp{ cursor:pointer; user-select:none; }
  #qpsPrintAll .grp:hover{ background:#f7fafb; }
  /* 접기 표시는 눈에 띄게 — 누르는 곳이라는 것이 보여야 한다(사용자 2026-09-07 「화살표 크게」) */
  #qpsPrintAll .grp .ar{ width:16px; color:#2f6fb0; font-size:15px; line-height:1; text-align:center; }
  /* 묶음 속은 한 칸 들여쓴다 — 머리와 줄이 같은 자리에 서면 어디에 딸린 줄인지 안 보인다(「해당내용 안쪽으로」) */
  #qpsPrintAll .gbox{ margin:0 0 2px 16px; padding-left:10px; border-left:2px solid #e6edf1; }
  #qpsPrintAll .gbox .row{ padding-left:6px; }
  #qpsPrintAll .grp .gn{ font-size:12.5px; }
  #qpsPrintAll .gc{ margin-left:8px; font-size:11px; font-weight:600; color:#8a99a3; }
  #qpsPrintAll .gc.has{ color:#2f6fb0; }
  #qpsPrintAll .gsel{ margin-left:auto; height:22px; padding:0 8px; border:1px solid #cfd8e0; border-radius:6px;
                       background:#f7fafb; font-size:11.5px; font-weight:700; color:#4a5560; cursor:pointer; }
  #qpsPrintAll .gsel:hover{ background:#eef4fb; border-color:#b9cfe6; color:#2f6fb0; }
  #qpsPrintAll .gfind{ margin-left:auto; height:22px; padding:0 8px; border:1px solid #b9cfe6; border-radius:6px;
                        background:#eef4fb; font-size:11.5px; font-weight:700; color:#2f6fb0; cursor:pointer; }
  #qpsPrintAll .gfind:hover{ background:#dce9f7; }
  #qpsPrintAll .gfind:disabled, #qpsPrintAll .gsel:disabled{ opacity:.55; cursor:default; }
  #qpsPrintAll .gsel.on{ background:#1f5a4b; border-color:#1f5a4b; color:#fff; }
  #qpsPrintAll .gsel{ margin-left:6px; }
#qpsPrintAll .row{ display:flex; align-items:center; gap:10px; padding:7px 4px; border-bottom:1px dashed #eef2f4; }
  #qpsPrintAll .row:last-child{ border-bottom:0; }
  #qpsPrintAll .row label{ margin:0; font-size:14px; cursor:pointer; flex:0 0 360px; }
  #qpsPrintAll .row .desc{ font-size:12px; color:#8a99a3; margin-left:auto; }
  /* 작성 주기 배지(사용자 2026-09-07) */
  #qpsPrintAll .row .cyc{ font-size:11.5px; font-weight:700; color:#3b6ea5; background:#eef4fb; border:1px solid #d7e5f5; border-radius:8px; padding:2px 6px; height:26px; cursor:pointer; }
  #qpsPrintAll .row .desc{ margin-left:10px; min-width:76px; text-align:right; }
  #qpsPrintAll .row .desc:last-child{ margin-right:auto; }
  #qpsPrintAll .bar{ margin-top:14px; display:flex; gap:8px; align-items:center; }
  #qpsPrintAll .btn{ height:36px; padding:0 16px; border-radius:8px; border:1px solid #cfd8e0; background:#fff; font-size:13.5px; font-weight:700; cursor:pointer; }
  #qpsPrintAll .btn.go{ background:#1f5a4b; border-color:#1f5a4b; color:#fff; }
  /* 누르는 단추처럼 보이게(사용자 2026-09-07 「실행 버튼이 아닌 것으로 보임」) — 인쇄(초록)와 색을 달리해 헷갈리지 않게 */
  #qpsPrintAll .btn.find{ background:#2f6fb0; border-color:#2f6fb0; color:#fff; }
  #qpsPrintAll .btn.find:hover{ background:#265d95; border-color:#265d95; }
  #qpsPrintAll .btn:disabled{ opacity:.5; cursor:default; }
  #qpsPrintAll .stat{ font-size:12.5px; color:#4a5560; margin-left:6px; flex:1 1 auto; min-width:180px; }
  #qpsPrintAll .hint{ margin-top:12px; font-size:12px; color:#8a99a3; line-height:1.7; }
  /* 두 길 안내 띠 (2026-09-08) — 등록 화면 일괄 출력과 역할이 갈린다는 것을 첫 화면에서 알린다 */
  #qpsPrintAll .way{ max-width:1080px; margin:0 0 12px; padding:9px 12px; border:1px solid #d7e5f5;
                     border-left:4px solid #2f6fb0; border-radius:8px; background:#f4f9ff;
                     font-size:12.5px; color:#3b4c57; line-height:1.65; }
  #qpsPrintAll .way b{ color:#2f6fb0; }
  /* 그 등록 화면으로 보내는 바로가기 — 여러 건은 거기서 조건 걸어 뽑는다 */
  #qpsPrintAll .row .goscr{ height:24px; padding:0 9px; border:1px solid #cfd8e0; border-radius:6px;
                            background:#fff; font-size:11.5px; font-weight:700; color:#4a5560;
                            cursor:pointer; white-space:nowrap; }
  #qpsPrintAll .row .goscr:hover{ background:#eef4fb; border-color:#b9cfe6; color:#2f6fb0; }
  #qpsBulkFrames{ position:fixed; left:-10000px; top:0; width:1200px; height:900px; }

  /* ═══ 업무 모드 (2026-09-08 사용자 「주기랑 찾기는 작성 현황으로 옮겨줘」) ═══
     이 화면에는 성격이 다른 두 업무가 섞여 있었다 :
       · 📋 작성 현황 = 어느 서식을 얼마나 썼나 · 주기는 무엇인가 · 빠진 것은 없나   (찾기 · 주기)
       · 🖨 묶음 인쇄 = 고른 서식을 한 벌로 뽑는다                                  (고르기 · 인쇄)
     ⚠**화면을 둘로 쪼개지는 않았다** — 서식 표 127종과 iframe 기계(frameSrc·grab·message)를
       두 벌로 두면 한쪽만 고쳐 반드시 어긋난다(이 저장소가 여러 번 겪은 함정).
     ⇒ 기계는 한 벌로 두고 **메뉴와 보이는 것만** 업무별로 가른다(`?mode=stat` · 아래 CSS).
     ★새 메뉴는 자바 없이 붙는다 — JSP 가 `param.mode` 를 그대로 읽는다(서버가 받은 요청이라 주소 숨김과 무관). */
  #qpsPrintAll.m-stat  .paChk,                        /* 현황에는 고르기·인쇄가 없다 */
  #qpsPrintAll.m-stat  #paAllLb,
  #qpsPrintAll.m-stat  .gsel,
  #qpsPrintAll.m-stat  #paBar,
  #qpsPrintAll.m-stat  #wayPrint,
  #qpsPrintAll.m-stat  #hintPrint,
  #qpsPrintAll.m-stat  #h3Print,
  #qpsPrintAll.m-stat  #subPrint,
  #qpsPrintAll.m-print .cyc,                          /* 인쇄에는 주기·찾기가 없다 */
  #qpsPrintAll.m-print #paChk,
  #qpsPrintAll.m-print .gfind,
  #qpsPrintAll.m-print .desc,
  #qpsPrintAll.m-print #wayStat,
  #qpsPrintAll.m-print #hintStat,
  #qpsPrintAll.m-print #h3Stat,
  #qpsPrintAll.m-print #subStat{ display:none !important; }

  /* 업무 탭 — 메뉴를 둘로 내면 이름이 닮아 중복으로 읽힌다(2026-09-08 사용자 지적) ⇒ 메뉴는 하나, 여기서 가른다 */
  #qpsPrintAll .modes{ display:flex; gap:6px; margin:0 0 12px; border-bottom:2px solid #dfe4ea; }
  #qpsPrintAll .modes button{ border:1px solid #cfd9e0; border-bottom:0; background:#f4f7f9; color:#43555f;
      border-radius:8px 8px 0 0; padding:7px 16px; font-size:13.5px; font-weight:700; cursor:pointer; }
  #qpsPrintAll .modes button:hover{ background:#e9eff3; }
  #qpsPrintAll.m-print .modes button[data-m="print"],
  #qpsPrintAll.m-stat  .modes button[data-m="stat"]{ background:#1f5a4b; border-color:#1f5a4b; color:#fff; }
</style>

<%-- 모드 — 주소의 ?mode=stat 이면 「작성 현황」, 아니면 「묶음 인쇄」. 서버가 받은 파라미터라 그대로 읽힌다. --%>
<c:set var="paMode" value="${param.mode eq 'stat' ? 'stat' : 'print'}"/>

<div id="qpsPrintAll" class="m-${paMode}">
  <h3 id="h3Print">🖨 서식 묶음 인쇄</h3>
  <h3 id="h3Stat">📋 서식 작성 현황</h3>
  <%-- ★두 길을 첫 줄에서 갈라 준다(2026-09-08) — 등록 화면마다 [🖨 일괄 출력] 이 생기면서
       「같은 이름의 기능이 두 군데」가 됐다. 무엇을 어디서 하는지 여기서 못 박지 않으면
       라운딩 12달치를 이 화면에서 뽑으려다 1장만 나오는 식으로 헛돈다. --%>
  <div class="sub" id="subPrint">서식 <b>종류를 가로질러</b> 한 벌로 묶어 인쇄합니다 — 실사·인증 준비용입니다.
    화면에 있는 그대로 모을 뿐, 자료를 만들거나 고치지 않습니다.</div>
  <div class="sub" id="subStat">어느 서식을 <b>얼마나 썼는지</b> · 작성 주기가 무엇인지 · 빠진 것은 없는지 봅니다.
    보기만 할 뿐, 자료를 만들거나 고치지 않습니다.</div>

  <%-- 업무 탭 — 성격이 다른 두 업무를 여기서 가른다(메뉴는 한 줄). 서식 표·기계는 한 벌이라 탭만 바뀐다. --%>
  <div class="modes">
    <button type="button" data-m="print" onclick="paMode('print');">🖨 묶음 인쇄</button>
    <button type="button" data-m="stat"  onclick="paMode('stat');">📋 작성 현황</button>
  </div>
  <div class="way" id="wayPrint">
    <b>한 서식의 여러 건</b>(라운딩 3~7월 · 회의록 정기만 · QI 보고서 중간·최종 …)은
    <b>그 등록 화면의 [🖨 일괄 출력]</b> 이 훨씬 잘합니다 — 업무 조건(기간·구분·회차)으로 걸러 뽑습니다.
    아래 서식 줄 오른쪽 <b>[화면에서 →]</b> 로 바로 갑니다.
  </div>
  <div class="way" id="wayStat">
    <b>[🔎 찾기]</b> 는 서식마다 화면을 한 번씩 열어 보므로 <b>서식 수만큼 시간이 듭니다</b> — 묶음 머리의 [🔎 찾기] 로 한 묶음씩 보는 편이 빠릅니다.
    <b>주기</b>는 그 자리에서 고치면 바로 저장됩니다. 뽑는 것은 <b>[🖨 서식 묶음 인쇄]</b> 메뉴에서 합니다.
  </div>

  <div class="card">
    <div class="bar" style="margin:0 0 10px; padding-bottom:10px; border-bottom:1px solid #e6edf1;">
      <label style="margin:0; font-size:13.5px; font-weight:700;">연도</label>
      <select id="paYear" style="height:34px; border:1px solid #cfd8e0; border-radius:8px; padding:0 8px; font-size:13.5px;" onchange="paYearChanged(true)"></select>
      <%-- 기간 (2026-09-07) — 한 해에 여러 건 쌓이는 서식(회의록 등)은 기간으로 걸러 건마다 뽑는다.
           소급 등록이라 작성일이 여기저기 흩어진다는 사용자 말에 따라 넣었다. 비워 두면 그 해 전체. --%>
      <label style="margin:0 0 0 8px; font-size:13px; color:#6b7a83;">기간</label>
      <input type="date" id="paFrom" style="height:34px; border:1px solid #cfd8e0; border-radius:8px; padding:0 6px; font-size:13px;" onchange="paYearChanged()">
      <span style="color:#9aa7b0;">~</span>
      <input type="date" id="paTo" style="height:34px; border:1px solid #cfd8e0; border-radius:8px; padding:0 6px; font-size:13px;" onchange="paYearChanged()">
      <button type="button" class="btn find" id="paChk" onclick="paCheck()" title="펼쳐 놓은 묶음만 봅니다 — 다 접혀 있으면 점검표를 뺀 전부. 묶음마다 [🔎 찾기] 로 하나씩 볼 수도 있습니다">🔎 펼친 묶음에서 찾기</button>
      <span class="stat" id="paChkStat"></span>
    </div>

    <div class="row" style="border-bottom:1px solid #e6edf1;">
      <label id="paAllLb"><input type="checkbox" id="paAll" onclick="paToggleAll(this)"> <b>전체 고르기</b></label>
      <button type="button" class="gsel" onclick="paAllGrp(true)" style="margin-left:auto;">⌄ 전체 펼치기</button>
      <button type="button" class="gsel" onclick="paAllGrp(false)">⌃ 전체 접기</button>
      <span class="desc">한 장짜리 서식부터 담았습니다</span>
    </div>
    <div id="paList"></div>

    <div class="bar" id="paBar">
      <button type="button" class="btn go" id="paGo" onclick="paRun()">고른 서식 묶어 인쇄</button>
      <button type="button" class="btn" onclick="paClear()">고른 것 지우기</button>
      <span class="stat" id="paStat"></span>
    </div>

    <div class="hint" id="hintPrint">
      · 서식마다 화면을 열어 그 화면의 인쇄 내용을 그대로 가져옵니다 — 낱장으로 뽑을 때와 같은 모양입니다.<br>
      · <b>서식 하나에 한 장씩</b> 담깁니다(그 화면이 지금 보여 주는 것). 한 서식을 <b>여러 건</b> 뽑으려면
        오른쪽 <b>[화면에서 →]</b> 로 그 화면에 가서 [🖨 일괄 출력] 을 쓰세요 — 회의록만 이 화면에서도 기간 안 여러 건을 담습니다.<br>
      · 자료가 없는 서식은 빈 양식으로 나옵니다. 빼려면 체크를 풀어 주세요.<br>
      · 서식과 서식 사이는 새 장으로 넘어갑니다.
    </div>
    <div class="hint" id="hintStat">
      · <b>찾기</b> 는 그 서식의 화면을 열어 「인쇄할 내용이 나오는가」로 봅니다 — 나오면 <b>작성됨</b>입니다(인쇄와 같은 길이라 결과가 어긋나지 않습니다).<br>
      · <b>주기</b> 는 그 서식을 얼마나 자주 써야 하는지입니다(매일·매주·매월·분기·반기·연 1회·그때그때). 고르면 바로 저장되어 다음에도 그대로 나옵니다.<br>
      · 점검표는 서식이 수십 종이라 서버가 한 번에 세어 줍니다 — 묶음 머리의 [🔎 찾기] 로 보세요.<br>
      · 자세한 문서 목록·작성자·최근 작성일은 <b>점검표 작성 화면의 [📋 작성 현황]</b> 에서 봅니다(점검표 전용).
    </div>
  </div>
</div>
<div id="qpsBulkFrames"></div>

<script>
(function () {
  var CTX = '';
  /* 담을 서식 — grp = 묶음 이름(사이드바 차례) · url = 그 화면 주소 · fn = 그 화면의 인쇄 함수 이름
     · listFn = 한 해에 여러 건 쌓이는 서식이 스스로 알려 주는 목록 · cyc = 주기 기본값(표에 값이 있으면 표가 이긴다)
     ★회의록은 화면 하나에 위원회만 다르다(?gb=) — 실사에서는 위원회별로 한 묶음씩 필요하다. */
  var FORMS = [
    /* ── 계획 · 위원회 ── */
    { grp:'계획 · 위원회', key:'plan',     nm:'연간 활동계획서',            url:'/main/qpsPlan.do',            fn:'plPrint', cyc:'Y' },
    { grp:'계획 · 위원회', key:'minutes',  nm:'QPS 위원회 회의록',          url:'/main/qpsMinutes.do',         fn:'qmPrint', listFn:'qmBulkList', cyc:'Q' },
    { grp:'계획 · 위원회', key:'min_M',    nm:'다학제 평가팀 회의록',       url:'/main/qpsMinutes.do?gb=M',    fn:'qmPrint', listFn:'qmBulkList', cyc:'Q' },
    { grp:'계획 · 위원회', key:'min_K',    nm:'다학제 평가팀(개최) 회의록', url:'/main/qpsMinutes.do?gb=K',    fn:'qmPrint', listFn:'qmBulkList', cyc:'Q' },
    { grp:'계획 · 위원회', key:'min_W',    nm:'운영위원회 회의록',          url:'/main/qpsMinutes.do?gb=W',    fn:'qmPrint', listFn:'qmBulkList', cyc:'Q' },
    { grp:'계획 · 위원회', key:'min_C',    nm:'중독연구소 운영위 회의록',   url:'/main/qpsMinutes.do?gb=C',    fn:'qmPrint', listFn:'qmBulkList', cyc:'Q' },
    { grp:'계획 · 위원회', key:'min_H',    nm:'인사위원회 회의록',          url:'/main/qpsMinutes.do?gb=H',    fn:'qmPrint', listFn:'qmBulkList', cyc:'Q' },
    { grp:'계획 · 위원회', key:'min_P',    nm:'약사위원회 회의록',          url:'/main/qpsMinutes.do?gb=P',    fn:'qmPrint', listFn:'qmBulkList', cyc:'Q' },
    { grp:'계획 · 위원회', key:'min_N',    nm:'영양관리위원회 회의록',      url:'/main/qpsMinutes.do?gb=N',    fn:'qmPrint', listFn:'qmBulkList', cyc:'Q' },
    { grp:'계획 · 위원회', key:'min_S',    nm:'소방안전관리위원회 회의록',  url:'/main/qpsMinutes.do?gb=S',    fn:'qmPrint', listFn:'qmBulkList', cyc:'Q' },
    { grp:'계획 · 위원회', key:'min_I',    nm:'감염관리위원회 회의록',      url:'/main/qpsMinutes.do?gb=I',    fn:'qmPrint', listFn:'qmBulkList', cyc:'Q' },

    /* ── 지표 · 분석 ── */
    { grp:'지표 · 분석', key:'def',        nm:'지표 정의서',                url:'/main/qpsDef.do',             fn:'qdPrint', cyc:'Y' },
    { grp:'지표 · 분석', key:'fall',       nm:'낙상 지표 분석',             url:'/main/qpsFall.do',            fn:'qfPrint', cyc:'Q' },

    /* ── 환자안전 활동 ── */
    { grp:'환자안전 활동', key:'round',    nm:'환자안전관리 라운딩 점검표', url:'/main/qpsRound.do',           fn:'rdPrint', cyc:'M' },
    { grp:'환자안전 활동', key:'seclog',   nm:'격리 · 강박 시행일지',       url:'/main/qpsSecLog.do',          fn:'slPrint', cyc:'M' },
    { grp:'환자안전 활동', key:'cathday',  nm:'유치도뇨관 월별 기록지',     url:'/main/qpsCathDay.do',         fn:'cdPrint', cyc:'M' },
    { grp:'환자안전 활동', key:'rca',      nm:'RCA 근본원인 분석',          url:'/main/qpsRca.do',             fn:'rcPrint', cyc:'S' },
    { grp:'환자안전 활동', key:'min_R',    nm:'RCA 회의록',                 url:'/main/qpsMinutes.do?gb=R',    fn:'qmPrint', listFn:'qmBulkList', cyc:'S' },
    { grp:'환자안전 활동', key:'fmea',     nm:'FMEA 계획서 · 보고서',       url:'/main/qpsFmea.do',            fn:'fmPrint', cyc:'Y' },
    { grp:'환자안전 활동', key:'min_F',    nm:'FMEA 회의록',                url:'/main/qpsMinutes.do?gb=F',    fn:'qmPrint', listFn:'qmBulkList', cyc:'Y' },
    { grp:'환자안전 활동', key:'saferpt',  nm:'사고 · 안전 보고서',         url:'/main/qpsSafeRpt.do',         fn:'srPrint', cyc:'S' },

    /* ── QI ── */
    { grp:'QI', key:'qitopic',  nm:'QI 주제선정 · 우선순위',   url:'/main/qpsQiTopic.do',  fn:'qtPrint', cyc:'Y' },
    { grp:'QI', key:'qiplan',   nm:'QI 활동계획서',            url:'/main/qpsQiPlan.do',   fn:'qpPrint', cyc:'Y' },
    { grp:'QI', key:'min_J',    nm:'QI 회의록',                url:'/main/qpsMinutes.do?gb=J', fn:'qmPrint', listFn:'qmBulkList', cyc:'Q' },
    { grp:'QI', key:'qirpt',    nm:'QI 중간 · 최종보고서',     url:'/main/qpsQiRpt.do',    fn:'qrPrint', cyc:'H' },
    { grp:'QI', key:'qifund',   nm:'활동 자원지원 내역',       url:'/main/qpsQiFund.do',   fn:'qfPrint', cyc:'Y' },

    /* ── 환자만족도 조사 ── */
    { grp:'환자만족도 조사', key:'srvplan', nm:'환자만족도 조사계획서',   url:'/main/qpsSrvPlan.do', fn:'spPrint',       cyc:'Y' },
    { grp:'환자만족도 조사', key:'srvnote', nm:'환자만족도 조사안내문',   url:'/main/qpsSrvPlan.do', fn:'spPrintNotice', cyc:'Y' },
    { grp:'환자만족도 조사', key:'srvrpt',  nm:'만족도 조사결과 보고서',  url:'/main/qpsSurvey.do',  fn:'svPrintRpt',    cyc:'Y' },
    { grp:'환자만족도 조사', key:'srvindi', nm:'만족도 지표분석 보고서',  url:'/main/qpsSurvey.do',  fn:'svPrintIndi',   cyc:'Y' },
    { grp:'환자만족도 조사', key:'srvimpr', nm:'개선활동결과보고서',      url:'/main/qpsSrvImpr.do', fn:'siPrint',       cyc:'S' },

    /* ── 불만고충 ── */
    { grp:'불만고충', key:'cmplplan', nm:'불만고충 처리계획서',      url:'/main/qpsCmplPlan.do', fn:'cpPrint',      cyc:'Y' },
    { grp:'불만고충', key:'cmplbook', nm:'불만고충 처리대장',        url:'/main/qpsCmpl.do',     fn:'cmPrintBook',  cyc:'M' },
    { grp:'불만고충', key:'cmplact',  nm:'개선활동 처리결과',        url:'/main/qpsCmpl.do',     fn:'cmActPrint',   cyc:'S' },
    { grp:'불만고충', key:'cmplrpt',  nm:'불만고충 지표분석보고서',  url:'/main/qpsCmplRpt.do',  fn:'crPrint',      cyc:'Q' },

    /* ── 점검표 ── */
    { grp:'점검표', key:'chk', nm:'점검표 작성', url:'/main/qpsChk.do', fn:'ckPrint', cyc:'M' }
  ];
  FORMS.forEach(function (f) { if (!f.wait) f.wait = 2600; });   // 자료가 들어올 때까지 기다릴 시간

  var gel = function (id) { return document.getElementById(id); };
  function fdef(k) { for (var i = 0; i < FORMS.length; i++) if (FORMS[i].key === k) return FORMS[i]; return null; }
  var parts = {};      // key → {title, css, body}
  var running = false;

  /* 서식별 작성 주기 (사용자 2026-09-07 「매일인지 주인지 월인지 분기인지 연인지 특정인지 확인하게」)
     ★코드는 이미 쓰던 것을 그대로 쓴다 — 점검표 서식(TBL_QPS_CHK_FORM.PRD_GB)과 지표 마스터(CYCLE_GB)가
       D·W·M·Q·H·Y 를 쓰고 있다. 여기에 S(그때그때 — 사건이 나면)를 더했다.
     ★지금 값은 **초기값**이다. 병원마다 다를 수 있으니 확인해 고치고, 굳어지면 설정 표로 뺀다. */
  var CYC = { D:'매일', W:'매주', M:'매월', Q:'분기', H:'반기', Y:'연 1회', S:'그때그때' };
  /* 기간 안에 몇 건이 있어야 하는지 — 빠진 것을 눈에 보이게. 휴일·연기는 따지지 않는 어림수다. */
  function due(cyc, rg) {
    if (!rg || !cyc || cyc === 'S') return 0;
    var a = new Date(rg.f.slice(0,4) + '-' + rg.f.slice(4,6) + '-' + rg.f.slice(6,8));
    var b = new Date(rg.t.slice(0,4) + '-' + rg.t.slice(4,6) + '-' + rg.t.slice(6,8));
    if (isNaN(a) || isNaN(b) || b < a) return 0;
    var days = Math.floor((b - a) / 86400000) + 1;
    var mons = (b.getFullYear() - a.getFullYear()) * 12 + (b.getMonth() - a.getMonth()) + 1;
    if (cyc === 'D') return days;
    if (cyc === 'W') return Math.ceil(days / 7);
    if (cyc === 'M') return mons;
    if (cyc === 'Q') return Math.ceil(mons / 3);
    if (cyc === 'H') return Math.ceil(mons / 6);
    if (cyc === 'Y') return Math.max(1, b.getFullYear() - a.getFullYear() + 1);
    return 0;
  }

  /* 목록 — 서식이 100종을 넘는다(코드표에서 오는 사고·안전 계열 78종 포함).
     다 펼쳐 두면 못 쓴다(2026-09-07 「펼쳐진 상태」) → **묶음은 접어 두고**, 머리를 누르면 펴진다.
       · 머리에 그 묶음의 종수와 고른 수를 적는다 — 접힌 채로도 무엇이 골라졌는지 보인다.
       · [모두] 는 펴지 않고 그 묶음만 고른다(같은 단추로 켜고 끈다).
       · 「찾기」로 작성된 것이 나오면 그 묶음만 저절로 펴 준다(아래 paOpenGrp). */
  var GRP_OPEN = {};        // 묶음 이름 → 펴져 있나

  function draw() {
    var h = '', grp = null, gi = -1, byGrp = [];
    FORMS.forEach(function (f) {
      if (f.grp !== grp) { grp = f.grp; gi++; byGrp.push({ nm: grp, n: 0 }); }
      byGrp[gi].n++;
    });

    grp = null; gi = -1;
    FORMS.forEach(function (f) {
      if (f.grp !== grp) {
        if (gi >= 0) h += '</div>';
        grp = f.grp; gi++;
        var open = !!GRP_OPEN[grp];
        h += '<div class="grp' + (open ? ' on' : '') + '" data-grp="' + grp + '" onclick="paToggleGrp(this)">' +
               '<span class="ar">' + (open ? '▾' : '▸') + '</span>' +
               '<span class="gn">' + grp + '</span>' +
               '<span class="gc" id="paGc_' + gi + '" data-grp="' + grp + '">' + byGrp[gi].n + '종</span>' +
               '<button type="button" class="gfind" onclick="paFindGrp(event, this)" data-grp="' + grp + '" title="이 묶음만 작성된 것을 찾습니다">🔎 찾기</button>' +
               '<button type="button" class="gsel" onclick="paPickGrp(event, this)" data-grp="' + grp + '" title="이 묶음을 한 번에 고르거나 풉니다">☑ 선택</button>' +
             '</div>' +
             '<div class="gbox" data-grp="' + grp + '"' + (open ? '' : ' hidden') + '>';
      }
      /* 주기는 그 자리에서 고친다 — 고치면 바로 표(TBL_QPS_FORM_CYC)에 저장한다(2026-09-07 「설정 표로 빼줘」) */
      var op = '';
      for (var k in CYC) op += '<option value="' + k + '"' + (f.cyc === k ? ' selected' : '') + '>' + CYC[k] + '</option>';
      h += '<div class="row"><label><input type="checkbox" class="paChk" data-grp="' + f.grp + '" value="' + f.key + '" onclick="paCount()"> ' + f.nm + '</label>' +
           '<select class="cyc" data-key="' + f.key + '" onchange="paCycSave(this)" title="작성 주기 — 고치면 바로 저장됩니다">' + op + '</select>' +
           '<span class="desc" id="paSt_' + f.key + '">' + (f.note || '') + '</span>' +
           /* ★그 등록 화면으로 — 여러 건은 거기서 업무 조건으로 걸러 뽑는다(2026-09-08) */
           '<button type="button" class="goscr" data-key="' + f.key + '" onclick="paGoScreen(event, this)"' +
           ' title="이 서식의 등록 화면을 새 창으로 엽니다 — 여러 건은 그 화면의 [🖨 일괄 출력] 으로 뽑으세요">화면에서 →</button>' +
           '</div>';   /* 주소(.do)는 안 보인다 — 화면에 쓸 말이 아니다(2026-09-07) */
    });
    if (gi >= 0) h += '</div>';
    gel('paList').innerHTML = h;
    paCount();
    /* 「전체 고르기」 체크는 목록을 다시 그리면 풀린다 — 셈과 맞춰 둔다 */
    var all = document.querySelectorAll('#paList .paChk'), onAll = 0;
    for (var q = 0; q < all.length; q++) if (all[q].checked) onAll++;
    gel('paAll').checked = all.length && onAll === all.length;
    if (running) paBusy(true);          // 찾는 중에 목록을 다시 그렸으면 잠금을 되살린다
  }

  /* 묶음마다 「n종 · m 고름」 — 접힌 채로도 고른 것이 보이게 */
  window.paCount = function () {
    var gs = document.querySelectorAll('#paList .gc');
    for (var i = 0; i < gs.length; i++) {
      var g = gs[i].getAttribute('data-grp');
      var cs = document.querySelectorAll('#paList .paChk[data-grp="' + g + '"]');
      var on = 0;
      for (var j = 0; j < cs.length; j++) if (cs[j].checked) on++;
      gs[i].textContent = cs.length + '종' + (on ? ' · ' + on + ' 고름' : '');
      gs[i].className = 'gc' + (on ? ' has' : '');
      /* [모두] 는 켜고 끄는 단추다 — 다 골라져 있으면 이름이 [해제] 로 바뀐다(사용자 2026-09-07) */
      var bt = document.querySelector('#paList .gsel[data-grp="' + g + '"]');
      if (bt) { var full = cs.length && on === cs.length; bt.textContent = full ? '☐ 해제' : '☑ 선택'; bt.className = 'gsel' + (full ? ' on' : ''); }
    }
  };

  window.paToggleGrp = function (hd) {
    var g = hd.getAttribute('data-grp');
    GRP_OPEN[g] = !GRP_OPEN[g];
    paOpenGrp(g, GRP_OPEN[g]);
  };

  function paOpenGrp(g, open) {
    GRP_OPEN[g] = !!open;
    var hd = document.querySelector('#paList .grp[data-grp="' + g + '"]');
    var bx = document.querySelector('#paList .gbox[data-grp="' + g + '"]');
    if (bx) bx.hidden = !open;
    if (hd) { hd.className = 'grp' + (open ? ' on' : ''); var a = hd.querySelector('.ar'); if (a) a.textContent = open ? '▾' : '▸'; }
  }

  /* ★[화면에서 →] — 그 서식의 등록 화면을 연다(2026-09-08).
     까닭 : 이 화면은 **서식 하나에 한 장**만 담는다(그 화면이 지금 보여 주는 것). 한 서식의 **여러 건**은
     2026-09-08 에 등록 화면 21곳마다 붙인 [🖨 일괄 출력] 이 업무 조건(기간·구분·회차)으로 걸러 훨씬 잘 뽑는다.
     여기서 길을 터 주지 않으면 「라운딩 12달치가 왜 1장만 나오나」로 헛돈다.
     ★새 창으로 연다 — 고르던 체크를 잃지 않는다(Q&A 화면에서 확정한 규약과 같다).
     ★고른 해를 ?yy= 로 넘긴다 — 각 화면의 qpsPickYear 가 읽는다(frameSrc 와 같은 규약). */
  /* 업무 탭 — 보이는 것만 바꾼다(서식 표·iframe 기계는 한 벌이라 다시 읽을 것이 없다).
     ★찾는 중에는 바꾸지 않는다 — 진행 표시가 다른 탭으로 사라져 「멈춘 것처럼」 보인다. */
  window.paMode = function (m) {
    if (running) { gel('paChkStat').textContent = '찾는 중입니다 — 끝난 뒤에 옮겨 주세요.'; return; }
    var root = gel('qpsPrintAll');
    root.className = (m === 'stat') ? 'm-stat' : 'm-print';
  };

  window.paGoScreen = function (ev, btn) {
    if (ev && ev.stopPropagation) ev.stopPropagation();
    var f = fdef(btn.getAttribute('data-key'));
    if (!f) return;
    var s = CTX + f.url + (f.url.indexOf('?') < 0 ? '?' : '&') + 'yy=' + year();
    window.open(s, '_blank');
  };

  /* 묶음 하나만 고르기 — 이미 다 골라져 있으면 푼다. 머리를 누른 것으로 번지지 않게 이벤트를 멈춘다. */
  window.paPickGrp = function (ev, btn) {
    if (ev && ev.stopPropagation) ev.stopPropagation();
    var g = btn.getAttribute('data-grp');
    var cs = document.querySelectorAll('#paList .paChk[data-grp="' + g + '"]');
    var allOn = true;
    for (var i = 0; i < cs.length; i++) if (!cs[i].checked) { allOn = false; break; }
    for (var j = 0; j < cs.length; j++) cs[j].checked = !allOn;
    paCount();
  };

  /* 표에 저장된 주기를 먼저 읽어 온다. 표가 비었거나 못 읽으면 화면 기본값 그대로 — 설정 전에도 멀쩡히 돈다. */
  function loadCyc() {
    return fetch(CTX + '/qps/formCycList.do', {
      method: 'POST', credentials: 'same-origin',
      headers: { 'Content-Type': 'application/x-www-form-urlencoded' }, body: ''
    }).then(function (r) { return r.json(); }).then(function (j) {
      ((j && j.list) || []).forEach(function (r) {
        var f = fdef(r.formkey);
        if (f && r.cycgb) f.cyc = String(r.cycgb).toUpperCase();
      });
    }).catch(function () { });
  }
  /* 사고·안전 보고서 78종 — 화면 하나에 유형(?gb=)만 다르다. 코드표(QPS_SAFERPT_GB)에서 읽어 온다.
     ★코드로 박지 않는 까닭 : 서식이 늘면 코드표에 한 줄 넣는 것으로 끝나야 한다(그 화면의 규약과 같다).
     ★계열 묶음은 SORT 대역이 정한다 — 그 화면(qpsSafeRpt.jsp)의 BANDS 와 같은 값이다. 한쪽만 고치면 어긋난다. */
  var SR_BANDS = [
    [ 1,  9, '사고 · 안전 보고서'],
    [10, 19, '의약품 · 혈액'],
    [20, 30, '교육 · 보건관리'],
    [31, 50, '인사 · 원무 · 총무'],
    [51, 70, '의무기록 · 정보보호'],
    [71, 72, '영양'],
    [73, 90, '사회복지 · 프로그램'],
    [91, 99, '검진 · 접종 결과보고서']];
  function srBand(s) {
    s = Number(s); if (isNaN(s)) s = 99;
    for (var i = 0; i < SR_BANDS.length; i++) if (s >= SR_BANDS[i][0] && s <= SR_BANDS[i][1]) return SR_BANDS[i][2];
    return '그 밖의 서식';
  }
  function loadSafe() {
    return fetch(CTX + '/qps/codeList.do', {
      method: 'POST', credentials: 'same-origin',
      headers: { 'Content-Type': 'application/x-www-form-urlencoded' }, body: ''
    }).then(function (r) { return r.json(); }).then(function (j) {
      var cs = (j && j.codes && j.codes.QPS_SAFERPT_GB) || [];
      if (!cs.length) return;
      /* 붙박이로 넣어 둔 대표 한 줄은 뺀다 — 아래에서 유형마다 한 줄로 다시 깐다 */
      for (var i = FORMS.length - 1; i >= 0; i--) if (FORMS[i].key === 'saferpt') FORMS.splice(i, 1);
      var add = cs.map(function (c) {
        return { grp: srBand(c.sort), key: 'sr_' + c.subcode, nm: c.subcodenm,
                 url: '/main/qpsSafeRpt.do?gb=' + encodeURIComponent(c.subcode), fn: 'srPrint', cyc: 'S' };
      });
      /* 묶음이 흩어지지 않게 대역 차례로 붙인다 */
      var order = SR_BANDS.map(function (b) { return b[2]; }).concat(['그 밖의 서식']);
      add.sort(function (a, b) { return order.indexOf(a.grp) - order.indexOf(b.grp); });
      FORMS = FORMS.concat(add);

      /* 점검표 — 부서 공통 서식이 315종이다. 줄로 다 깔면 목록이 무너지므로 **부서마다 한 줄**로 담고,
         인쇄할 때 그 부서의 서식·저장분을 화면이 스스로 펼쳐 넘긴다(multi = 여러 장 온다).
         ★부서 목록도 코드표(QPS_CHK_DEPT)에서 읽는다 — 부서가 늘어도 화면을 안 고친다. */
      var ds = (j && j.codes && j.codes.QPS_CHK_DEPT) || [];
      if (ds.length) {
        for (var k = FORMS.length - 1; k >= 0; k--) if (FORMS[k].key === 'chk') FORMS.splice(k, 1);
        FORMS = FORMS.concat(ds.map(function (d) {
          return { grp: '점검표', key: 'chk_' + d.subcode, nm: d.subcodenm + ' 점검표',
                   url: '/main/qpsChk.do?dept=' + encodeURIComponent(d.subcode),
                   fn: 'ckBulkPrint', multi: true, cyc: 'M' };
        }));
      }
    }).catch(function () { });
  }

  /* 목록은 두 번 그린다 — 표·코드표를 못 읽어도 붙박이 서식은 먼저 보이게 */
  draw();
  loadSafe().then(loadCyc).then(draw);   // 서식을 다 채운 뒤 표의 주기를 입힌다(차례가 중요하다)

  window.paCycSave = function (sel) {
    var key = sel.getAttribute('data-key'), f = fdef(key);
    if (!f) return;
    f.cyc = sel.value;
    var body = 'formKey=' + encodeURIComponent(key) + '&cycGb=' + encodeURIComponent(sel.value) +
               '&formNm=' + encodeURIComponent(f.nm);
    fetch(CTX + '/qps/formCycSave.do', {
      method: 'POST', credentials: 'same-origin',
      headers: { 'Content-Type': 'application/x-www-form-urlencoded' }, body: body
    }).then(function (r) { return r.json(); }).then(function (j) {
      gel('paChkStat').textContent = (j && j.result === 'OK')
        ? (f.nm + ' 주기를 ' + CYC[sel.value] + '로 저장했습니다.')
        : ('주기 저장 실패 — ' + ((j && j.message) || '표가 아직 없을 수 있습니다(DDL 확인)'));
    }).catch(function () { gel('paChkStat').textContent = '주기 저장 실패 — 통신 오류'; });
  };

  /* 연도 — 올해를 가운데 두고 앞뒤로. 고른 해가 각 서식 화면에 ?yy= 로 넘어간다(2026-09-07) */
  (function () {
    var y = new Date().getFullYear(), sel = gel('paYear');
    for (var i = y + 1; i >= y - 4; i--) sel.add(new Option(i + '년', i));
    sel.value = y;
  })();

  /* 기간 기본값(사용자 2026-09-07 「일자 기본 셋팅해줘」) — 고른 해의 1월 1일부터.
     올해면 끝은 오늘까지(앞날에 쓴 서식은 없다), 지난 해면 12월 31일까지.
     ★기간이 비면 화면이 여는 것 하나만 나온다. 소급 등록한 건까지 담기려면 채워져 있어야 한다. */
  function setYearRange() {
    var y = +gel('paYear').value, now = new Date(), p = function (n) { return (n < 10 ? '0' : '') + n; };
    gel('paFrom').value = y + '-01-01';
    gel('paTo').value = (y === now.getFullYear())
      ? (y + '-' + p(now.getMonth() + 1) + '-' + p(now.getDate()))
      : (y + '-12-31');
  }
  setYearRange();   // 화면을 열면 곧바로 그 해가 들어가 있게
  function year() { return gel('paYear').value; }
  function range() {
    var f = gel('paFrom').value || '', t = gel('paTo').value || '';
    return (f || t) ? { f: f.replace(/-/g, ''), t: (t || '9999-12-31').replace(/-/g, '') } : null;
  }

  /* 여러 건 쌓이는 서식은 **건마다 한 장**이다. 기간을 주면 그 기간에 드는 건만 골라 하나씩 뽑는다(2026-09-07).
     목록은 그 화면이 알려 준다(listFn) — 우리가 표를 따로 읽지 않으니 조회 규칙이 두 벌로 갈리지 않는다.
     ★기간을 비우면 종전처럼 화면이 여는 것 하나만(대개 최근 건). */
  function expand(list) {
    var rg = range();
    if (!rg) return Promise.resolve(list.slice());
    var out = [], i = 0;
    return new Promise(function (resolve) {
      var step = function () {
        if (i >= list.length) { resolve(out); return; }
        var f = list[i++];
        if (!f.listFn) { out.push(f); step(); return; }
        askList(f).then(function (rows) {
          var hit = rows.filter(function (r) {
            var d = String(r.dt || '').replace(/-/g, '');
            return d && d >= rg.f && d <= rg.t;
          });
          if (!hit.length) { out.push(Object.assign({}, f, { empty: true })); step(); return; }
          hit.forEach(function (r, k) {
            out.push(Object.assign({}, f, {
              key: f.key + '#' + r.seq,
              nm: f.nm + ' (' + (r.dt || '') + ')',
              url: f.url + (f.url.indexOf('?') < 0 ? '?' : '&') + 'seq=' + r.seq,
              parentKey: f.key, order: k
            }));
          });
          step();
        });
      };
      step();
    });
  }

  /* 그 서식의 목록만 받아 온다 — 화면을 띄워 listFn 을 부른다(인쇄는 안 한다). */
  function askList(f) {
    return new Promise(function (resolve) {
      var box = gel('qpsBulkFrames'), ifr = document.createElement('iframe');
      ifr.style.cssText = 'width:1200px;height:900px;border:0;';
      var done = false;
      var fin = function (rows) {
        if (done) return; done = true;
        setTimeout(function () { try { box.removeChild(ifr); } catch (e) { } }, 200);
        resolve(rows || []);
      };
      ifr.onload = function () {
        var w = ifr.contentWindow, waited = 0;
        var tick = function () {
          if (done) return;
          if (typeof w[f.listFn] === 'function') {
            try { w[f.listFn]().then(function (rows) { fin(rows); }, function () { fin([]); }); }
            catch (e) { fin([]); }
            return;
          }
          waited += 200; if (waited > 6000) return fin([]);
          setTimeout(tick, 200);
        };
        setTimeout(tick, 150);
      };
      ifr.src = frameSrc(f);
      box.appendChild(ifr);
      setTimeout(function () { fin([]); }, 12000);
    });
  }
  window.paYearChanged = function (fromYear) {
    if (fromYear) setYearRange();   // 연도를 바꾼 경우만 기간을 다시 잡는다(직접 고친 날짜는 그대로 둔다)
    FORMS.forEach(function (f) { var el = gel('paSt_' + f.key); if (el) el.textContent = ''; });
    gel('paChkStat').textContent = '';
  };

  /* 이 해에 작성된 것이 있는지 — 서식마다 화면을 열어 인쇄할 내용이 나오는지 본다.
     ★자료가 없으면 그 화면이 인쇄를 그만두므로 아무것도 안 넘어온다 = 「없음」.
       인쇄와 같은 길로 확인하니, 여기서 「있음」이면 인쇄에도 그대로 나온다. */
  /* 여러 서식을 **한꺼번에** 본다(2026-09-07 「확인 오래 걸림」) — 하나씩 차례로 하면 서식 수만큼 기다림이 쌓인다.
     한 번에 셋씩 : 브라우저·서버에 무리가 없으면서 셋을 나란히 여는 만큼 빨라진다. */
  function pool(list, size, onEach, onDone) {
    var idx = 0, active = 0, fin = 0;
    var next = function () {
      if (fin >= list.length) { onDone(); return; }
      while (active < size && idx < list.length) {
        (function (f) {
          active++;
          grab(f).then(function () { active--; fin++; onEach(f, fin); next(); });
        })(list[idx++]);
      }
    };
    next();
  }

  /* 작성된 것 찾기 — 서식마다 화면을 한 번씩 열어 보므로 **서식 수만큼 시간이 든다.**
     서식이 127종이 되고 나니 전부 보는 데 너무 오래 걸린다(사용자 2026-09-07 「너무 오래 걸림」).
     ⇒ ①묶음마다 [찾기] 를 달아 **한 묶음씩** 볼 수 있게 하고,
       ②위쪽 단추는 **펴 놓은 묶음만** 본다(다 접혀 있으면 전부).
       ③한꺼번에 여는 창을 3 → 5 로 늘린다(더 늘리면 화면이 버벅인다).
     ★점검표는 화면 하나가 그 부서의 서식을 모두 도는 구조라 훨씬 무겁다 — 묶음 [찾기] 로만 본다. */
  /* 점검표 「작성됨」은 서버가 한 번에 센다 (2026-09-07 「너무 오래 걸림」).
     다른 서식은 화면을 열어 봐야 알지만, 점검표는 부서마다 서식이 수십 종이라 그 방식이 안 맞는다.
     ★건수만 센다 — 인쇄는 종전대로 화면이 조립한다(판정과 인쇄가 갈리지 않게, 건수는 「빠진 것 찾기」 용도). */
  function chkCount() {
    paBusy(true, '점검표', '세는 중 …');
    return fetch(CTX + '/qps/chkCntByDept.do', {
      method: 'POST', credentials: 'same-origin',
      headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
      body: 'inYear=' + encodeURIComponent(year())
    }).then(function (r) { return r.json(); }).then(function (j) {
      var by = {};
      ((j && j.list) || []).forEach(function (r) { by['chk_' + String(r.deptcd || '').toUpperCase()] = Number(r.cnt || 0); });
      var n = 0;
      FORMS.forEach(function (f) {
        if (f.grp !== '점검표') return;
        var c = by[f.key] || 0, el = gel('paSt_' + f.key);
        if (el) {
          el.textContent = c ? ('✔ ' + c + '건') : '— 없음';
          el.style.color = c ? '#1f5a4b' : '#b0bcc4';
        }
        var cb = document.querySelector('#paList .paChk[value="' + f.key + '"]');
        if (cb) cb.checked = !!c;
        if (c) n += c;
      });
      paCount();
      paBusy(false);
      gel('paChkStat').textContent = '점검표 — ' + year() + '년 작성분 ' + n + '건';
    }).catch(function () { paBusy(false); gel('paChkStat').textContent = '점검표 건수를 못 받았습니다 — 톰캣 재기동이 필요할 수 있습니다.'; });
  }

  /* 찾는 동안 단추를 잠그고, **누른 묶음 머리에** 진행을 적는다 (2026-09-07 「찾기 바로 작동 안 함」).
     종전에는 저 위 한 줄에만 적혀 누른 티가 안 났고, 이미 돌고 있으면 아무 말 없이 무시했다. */
  function paBusy(on, grp, txt) {
    var bs = document.querySelectorAll('#paList .gfind, #paList .gsel, #paAll');
    for (var i = 0; i < bs.length; i++) bs[i].disabled = !!on;
    gel('paChk').disabled = !!on;
    gel('paGo').disabled = !!on;
    var gs = document.querySelectorAll('#paList .gfind');
    for (var j = 0; j < gs.length; j++) {
      var g = gs[j].getAttribute('data-grp');
      if (on && grp && g === grp) gs[j].textContent = txt || '보는 중 …';
      else if (!on) gs[j].textContent = '🔎 찾기';
    }
  }

  window.paCheck = function (onlyGrp) {
    if (running) { gel('paChkStat').textContent = '이미 찾는 중입니다 — 끝나면 다시 눌러 주세요.'; return; }
    var list = FORMS.filter(function (f) {
      if (onlyGrp) return f.grp === onlyGrp;
      if (f.grp === '점검표') return false;                 // 무거운 묶음은 제 [찾기] 로만
      var open = Object.keys(GRP_OPEN).some(function (g) { return GRP_OPEN[g]; });
      return open ? !!GRP_OPEN[f.grp] : true;
    });
    if (!list.length) { gel('paChkStat').textContent = '볼 서식이 없습니다.'; return; }

    running = true; parts = {}; TM = [];
    paBusy(true, onlyGrp, '보는 중 0/' + list.length);
    list.forEach(function (f) { var el = gel('paSt_' + f.key); if (el) { el.textContent = '…'; el.style.color = ''; } });
    var t0 = Date.now();
    expand(list).then(function (jobs) {
      var found = {};                              // 서식(부모) 별로 몇 건 나왔나 — 기간이면 한 서식이 여러 건이 된다
      pool(jobs, 8, function (f, n) {
        var pk = f.parentKey || f.key, ok = (parts[f.key] || []).length;   /* 한 화면이 여러 장을 넘길 수 있다(점검표) */
        if (ok) found[pk] = (found[pk] || 0) + ok;
        var el = gel('paSt_' + pk);
        if (el) {
          var need = due(fdef(pk) && fdef(pk).cyc, range());
          el.textContent = found[pk] ? ('✔ ' + found[pk] + '건' + (need ? ' / ' + need : '')) : (need ? '— 0 / ' + need : '— 없음');
          el.style.color = found[pk] ? '#1f5a4b' : '#b0bcc4';
        }
        var cb = document.querySelector('#paList .paChk[value="' + pk + '"]');
        if (cb) cb.checked = !!found[pk];          // 나온 것만 미리 골라 둔다
        /* 작성된 것이 있는 묶음은 저절로 펴 준다 — 접힌 채로 두면 무엇이 나왔는지 못 본다(2026-09-07) */
        if (found[pk]) { var ff = fdef(pk); if (ff) paOpenGrp(ff.grp, true); }
        paCount();
        paBusy(true, onlyGrp, '보는 중 ' + n + '/' + jobs.length);
        gel('paChkStat').textContent = (onlyGrp ? (onlyGrp + ' ') : '') + '(' + n + '/' + jobs.length + ') 보는 중 …';
      }, function () {
        running = false; paBusy(false);
        var forms = 0, docs = 0;
        list.forEach(function (f) { if (found[f.key]) { forms++; docs += found[f.key]; } });
        var rg = range();
        /* 어디에 시간이 갔는지 함께 적는다 — 「오래 걸린다」를 짐작으로 고치지 않으려고(2026-09-07) */
        var avg = function (k) { return TM.length ? (TM.reduce(function (s, x) { return s + (x[k] || 0); }, 0) / TM.length / 1000).toFixed(1) : '0'; };
        gel('paChkStat').textContent = (onlyGrp ? (onlyGrp + ' — ') : '') +
          (rg ? (gel('paFrom').value + ' ~ ' + (gel('paTo').value || '오늘')) : (year() + '년')) +
          ' — 서식 ' + forms + '종 · ' + docs + '건 (' + ((Date.now() - t0) / 1000).toFixed(1) + '초)' +
          ' · 한 서식 평균 : 화면 열기 ' + avg('load') + '초 → 조회 ' + avg('call') + '초 → 마침 ' + avg('all') + '초';
      });
    });
  };

  /* 묶음 머리의 [찾기] — 그 묶음만 본다. 머리 클릭(접기)으로 번지지 않게 멈춘다. */
  window.paFindGrp = function (ev, btn) {
    if (ev && ev.stopPropagation) ev.stopPropagation();
    var g = btn.getAttribute('data-grp');
    paOpenGrp(g, true);
    if (g === '점검표') { chkCount(); return; }   // 점검표는 서버가 한 번에 센다
    paCheck(g);
  };

  /* 전체 펼치기 · 접기 (사용자 2026-09-07) — 묶음이 12개라 하나씩 누르기 번거롭다.
     ★위쪽 [이 기간에 작성된 것 찾기] 는 **펴 놓은 묶음만** 본다. 그래서 이 두 단추가 곧 「어디까지 볼지」이기도 하다. */
  window.paAllGrp = function (open) {
    var hs = document.querySelectorAll('#paList .grp');
    for (var i = 0; i < hs.length; i++) paOpenGrp(hs[i].getAttribute('data-grp'), open);
  };

  window.paToggleAll = function (el) {
    var cs = document.querySelectorAll('#paList .paChk');
    for (var i = 0; i < cs.length; i++) cs[i].checked = el.checked;
    paCount();
  };
  window.paClear = function () {
    var cs = document.querySelectorAll('#paList .paChk');
    for (var i = 0; i < cs.length; i++) cs[i].checked = false;
    gel('paAll').checked = false;
    gel('paStat').textContent = '';
  };

  /* 서식 하나 — 숨은 iframe 에 화면을 띄우고, 자료가 들어올 때를 기다렸다가 그 화면의 인쇄 함수를 부른다.
     결과는 sidebar.jsp 의 qpsPrintOut 이 postMessage 로 이 화면에 넘겨 준다. */
  /* 화면을 여는 주소 — 고른 해와 **기간**을 넘긴다.
     기간은 여러 장을 스스로 골라 넘기는 화면(점검표)이 쓴다. 모르는 화면은 그냥 무시한다(2026-09-07). */
  function frameSrc(f) {
    var s = CTX + f.url + (f.url.indexOf('?') < 0 ? '?' : '&') + 'yy=' + year();
    var fr = gel('paFrom').value, to = gel('paTo').value;
    if (fr) s += '&from=' + fr;
    if (to) s += '&to=' + to;
    return s;
  }

  /* 구간별 시간을 모은다 — 「찾기가 왜 오래 걸리나」를 짐작이 아니라 재서 말하려고(2026-09-07).
     열기 = 화면(JSP+CSS+JS)이 뜰 때까지 · 조회 = 그 화면이 제 자료를 받아올 때까지 · 넘김 = 인쇄물이 넘어올 때까지 */
  var TM = [];
  function grab(f) {
    return new Promise(function (resolve) {
      var tA = Date.now(), tLoad = 0, tCall = 0;
      var box = gel('qpsBulkFrames');
      var ifr = document.createElement('iframe');
      ifr.style.cssText = 'width:1200px;height:900px;border:0;';
      var done = false;
      var finish = function () {
        if (done) return; done = true;
        TM.push({ load: tLoad, call: tCall, all: Date.now() - tA });
        setTimeout(function () { try { box.removeChild(ifr); } catch (e) { } }, 200);
        resolve();
      };
      parts['__wait_' + f.key] = finish;                 // postMessage 가 오면 이걸 부른다
      ifr.onload = function () {
        tLoad = Date.now() - tA;
        var w = ifr.contentWindow;
        try { w.QPS_BULK = f.key; } catch (e) { finish(); return; }
        /* 자료가 들어오기를 **조용해질 때까지만** 기다린다(2026-09-07 「확인 오래 걸림」).
           종전에는 서식마다 무조건 2.6초를 기다렸다. 화면이 부르는 조회가 끝나면 더 받아올 것이 없으므로,
           내려받은 것(performance resource)이 늘지 않는 순간을 「다 됐다」로 본다 — 대개 1초 안쪽이다.
           ★못 재는 브라우저면 종전처럼 정해진 시간까지 기다린다. */
        var waited = 0, last = -1, quiet = 0;
        var call = function () {
          if (done) return;
          try {
            tCall = Date.now() - tA;
            if (typeof w[f.fn] === 'function') w[f.fn]();
            else { finish(); return; }
          } catch (e) { finish(); return; }
          /* 여러 장 서식은 화면이 「다 넘겼다」고 알려 줄 때까지 기다린다 — 여기서 끊으면 첫 장만 온다 */
          if (!f.multi) setTimeout(finish, 800);         // 넘어오지 않으면 그냥 넘어간다(자료 없는 서식이 대부분이라 이 시간이 곧 총시간이다)
        };
        var tick = function () {
          if (done) return;
          var n = -1;
          try { n = w.performance.getEntriesByType('resource').length; } catch (e) { }
          if (n < 0) { if (waited >= f.wait) return call(); }
          else if (n === last) { quiet++; } else { quiet = 0; last = n; }
          if (quiet >= 2 || waited >= f.wait) return call();   // 200ms 두 번 조용하면 다 온 것
          waited += 200; setTimeout(tick, 200);
        };
        setTimeout(tick, 300);
      };
      ifr.src = frameSrc(f);
      box.appendChild(ifr);
      setTimeout(finish, f.multi ? 180000 : (f.wait || 2600) + 9000);   // 화면이 끝내 안 뜨면(여러 장 서식은 넉넉히)
    });
  }

  /* 받는 곳 — 한 화면이 인쇄물을 **여러 장** 넘길 수 있다(점검표는 부서의 서식 수만큼, 2026-09-07).
     그래서 key 마다 배열로 쌓는다. 한 장짜리는 오던 대로 첫 장에서 끝낸다 —
     여러 장 서식(multi)만 「더 안 오면」 끝낸다(1.2초 조용하면 다 온 것). */
  var partTmr = {};
  window.addEventListener('message', function (e) {
    var d = e.data;
    if (!d) return;
    if (d.type === 'qpsPrintDone') {          // 화면이 「다 넘겼다」고 알려 온다(여러 장 서식)
      var cb0 = parts['__wait_' + d.key];
      clearTimeout(partTmr[d.key]);
      if (typeof cb0 === 'function') cb0();
      return;
    }
    if (d.type !== 'qpsPrintPart') return;
    (parts[d.key] = parts[d.key] || []).push({ title: d.title, css: d.css, body: d.body });
    var cb = parts['__wait_' + d.key];
    if (typeof cb !== 'function') return;
    var f = fdef(d.key) || {};
    if (!f.multi) { cb(); return; }
    clearTimeout(partTmr[d.key]);
    partTmr[d.key] = setTimeout(cb, 5000);   // 알림을 놓쳤을 때의 안전망
  });

  window.paRun = function () {
    if (running) return;
    var picked = [];
    var cs = document.querySelectorAll('#paList .paChk');
    for (var i = 0; i < cs.length; i++) if (cs[i].checked) {
      for (var j = 0; j < FORMS.length; j++) if (FORMS[j].key === cs[i].value) picked.push(FORMS[j]);
    }
    if (!picked.length) { gel('paStat').textContent = '서식을 하나 이상 고르세요.'; return; }

    running = true; parts = {}; gel('paGo').disabled = true; gel('paChk').disabled = true;
    expand(picked).then(function (jobs) {           /* 기간이면 여러 건 서식이 건 단위로 펼쳐진다 */
      pool(jobs, 3, function (f, n) {
        gel('paStat').textContent = '(' + n + '/' + jobs.length + ') 받는 중 …';
      }, function () {
        gel('paChk').disabled = false;
        merge(jobs);                                /* 붙이는 차례는 고른 차례 그대로 — 먼저 끝난 순서가 아니다 */
      });
    });
  };

  /* 모은 것을 한 문서로 — 서식마다 CSS 가 다르므로 각각을 제 CSS 로 감싸고 사이를 새 장으로 넘긴다.

     ★여백과 「바닥의 about:blank」(사용자 2026-09-07 「아래부분 아직 있네요」)
       브라우저는 @page 여백 자리에 날짜·주소·쪽수를 제가 찍는다. 자리가 없으면 안 찍는다 —
       그래서 @page 여백을 0 으로 두고(낱장 서식에서 이미 확인된 방법), 종이 여백은 우리가 만든다.
       한 장짜리가 아니라 여러 장으로 넘어가는 서식도 있으므로 padding 으로는 안 된다(첫 장에만 붙는다).
       표의 thead·tfoot 은 인쇄 때 **장마다 되풀이**되므로, 위아래 12mm 를 그것으로 띄운다.
       좌우 10mm 는 칸(td) 의 padding 이라 어차피 장마다 그대로 붙는다.
       ★서식과 서식 사이는 표 단위로 끊는다 — 칸 안에서의 page-break 는 브라우저마다 잘 안 듣는다. */
  function merge(picked) {
    var got = picked.filter(function (f) { return (parts[f.key] || []).length; });
    running = false; gel('paGo').disabled = false;
    if (!got.length) { gel('paStat').textContent = '가져온 서식이 없습니다 — 화면에서 낱장으로 먼저 확인해 주세요.'; return; }

    var css = '', bodyAll = '', seen = {}, sheets = 0;
    got.forEach(function (f) {
      /* 한 서식이 여러 장일 수 있다(점검표는 부서의 서식마다 한 장) — 장마다 표 하나 */
      (parts[f.key] || []).forEach(function (p) {
        /* 서식이 들고 온 @page 는 버린다 — 문서에 하나만 먹는데다 여백은 아래에서 다시 잡는다 */
        var pc = String(p.css || '').replace(/@page[^{]*\{[^}]*\}/g, '');
        if (!seen[pc]) { seen[pc] = 1; css += pc; }               // 같은 CSS 는 한 번만
        bodyAll += '<table class="qps-sheet"' + (sheets++ ? ' style="page-break-before:always;"' : '') + '>' +
                     '<thead><tr><td><div class="qps-vsp"></div></td></tr></thead>' +
                     '<tbody><tr><td><div class="qps-part">' + p.body + '</div></td></tr></tbody>' +
                     '<tfoot><tr><td><div class="qps-vsp"></div></td></tr></tfoot>' +
                   '</table>';
      });
    });
    /* 아래 규칙은 서식 CSS 뒤에 붙여 우리가 이기게 한다 */
    css += '.qps-part{ break-inside:auto; }' +
           '@page{ size:A4 portrait; margin:0; }' +
           'html,body{ margin:0 !important; padding:0 !important; }' +
           '.qps-sheet{ width:100%; border-collapse:collapse; }' +
           '.qps-sheet > thead > tr > td, .qps-sheet > tfoot > tr > td{ padding:0; border:0; }' +
           '.qps-sheet > tbody > tr > td{ padding:0 10mm; border:0; }' +
           '.qps-vsp{ height:12mm; }';

    var w = window.open('', '_blank', 'width=980,height=1000');
    if (!w) { gel('paStat').textContent = '팝업이 막혀 인쇄창을 열지 못했습니다 — 주소창 오른쪽에서 허용해 주세요.'; return; }
    w.document.open();
    w.document.write('<!doctype html><html lang="ko"><head><meta charset="utf-8"><title>QPS 일괄 출력</title>' +
                     '<style>' + css + '</style></head><body>' + bodyAll + '</body></html>');
    w.document.close();
    w.focus();
    if (typeof qpsPrintGo === 'function') qpsPrintGo(w, 5000);
    gel('paStat').textContent = got.length + '종 · ' + sheets + '장을 이어 붙였습니다.' +
      (got.length < picked.length ? ' (' + (picked.length - got.length) + '종은 못 가져왔습니다)' : '');
  };
})();
</script>
</div><%-- /.dashboard-wrapper --%>
