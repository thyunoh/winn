<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%-- misLead.jsp — 경영고객관리 › 신규환자 고객관리 (2026-10-08 제안서 ④, 2026-10-12 달력 중심으로 개편)
     · 달력이 기본 화면: 날짜마다 연락·방문·입원·퇴원·안부 일정이 보인다. 날짜를 누르면 오른쪽에 그 날의 일정이 나온다.
     · 일정을 누르면 아래 작업 칸이 열린다. 작업 칸은 환자의 단계(상담→방문→입원 결정→입원→퇴원 후)에 맞춰 필요한 칸만 보이고,
       「다음 단계로 넘기기」가 그 흐름을 잇는다. 화면 값은 서버 API(leadSave·leadStage·leadLog…)를 그대로 쓴다.
     · 입원·퇴원은 입퇴원현황이 올라오면 서버가 자동으로 단계를 맞춘다(생년월일 6 + 이름). 알림은 ui-message.
     · ★주의: 이 파일 안에서 Deferred EL 표기(샵+중괄호) 금지 --%>

<script src="/asset/js/ui-message.js"></script>
<script src="/asset/js/mis-split.js"></script>
<script src="/asset/js/xlsx-style.bundle.js"></script>

<div class="dashboard-wrapper">
<div id="misLead" data-wnn="<c:out value='${wnnYn}'/>" data-hosp="<c:out value='${hospCd}'/>" data-nm="<c:out value='${hospNm}'/>">
<style>
  #misLead{ background:#f4f6f8; color:#1f2a30; min-height:100%; padding:14px 16px 50px; max-width:100%; overflow-x:hidden; }
  #misLead *{ box-sizing:border-box; }
  #misLead .ml-head{ display:flex; align-items:center; gap:10px; margin-bottom:10px; flex-wrap:wrap; }
  #misLead .ml-title{ font-size:18px; font-weight:800; color:#20303a; display:flex; align-items:center; gap:8px; }
  #misLead .ml-dot{ width:10px; height:10px; border-radius:50%; background:linear-gradient(135deg,#1f5a4b,#2a7665); }
  #misLead .ml-sub{ font-size:12px; color:#6b7c86; font-weight:400; }
  #misLead .ml-hosp{ background:#e7f3ee; color:#1f5a4b; font-size:12px; font-weight:800; border:1px solid #cfe3da; border-radius:14px; padding:3px 11px; }
  #misLead .ml-spacer{ flex:1; }
  #misLead select, #misLead input, #misLead textarea{ border:1px solid #cfd8e0; border-radius:6px; padding:5px 8px; font-size:13px; background:#fff; font-family:inherit; }
  #misLead textarea{ width:100%; min-height:56px; resize:vertical; }
  #misLead .ml-btn{ border:1px solid #cfd9e0; background:#fff; color:#43555f; border-radius:6px; padding:5px 11px; font-size:12.5px; font-weight:700; cursor:pointer; white-space:nowrap; }
  #misLead .ml-btn:hover{ background:#eef3f6; }
  #misLead .ml-btn.pri{ background:#1f5a4b; color:#fff; border-color:#1f5a4b; }
  #misLead .ml-btn.pri:hover{ background:#2a7665; }
  #misLead .ml-btn.del{ color:#b23b3b; }
  #misLead .ml-btn.sm{ padding:2px 8px; font-size:12px; }
  #misLead .ml-btn.rec{ background:#b23b3b; color:#fff; border-color:#b23b3b; animation:mlRec 1s ease-in-out infinite; }
  @keyframes mlRec{ 0%,100%{ opacity:1; } 50%{ opacity:.55; } }
  #misLead .ml-tabs{ display:flex; gap:6px; margin:4px 0 12px; flex-wrap:wrap; }
  #misLead .ml-tab{ border:1px solid #cfd9e0; background:#fff; color:#43555f; border-radius:8px; padding:7px 14px; font-size:13px; font-weight:700; cursor:pointer; }
  #misLead .ml-tab.on{ background:#1f5a4b; color:#fff; border-color:#1f5a4b; }
  #misLead .ml-card{ background:#fff; border:1px solid #e3e9ed; border-radius:10px; padding:12px 14px; min-width:0; }
  #misLead .ml-card h4{ margin:0 0 10px; font-size:13px; color:#43555f; font-weight:700; display:flex; gap:8px; align-items:center; flex-wrap:wrap; }
  #misLead .ml-card h4 .sp{ flex:1; }
  #misLead .small{ font-size:12px; color:#6b7c86; }
  #misLead .ml-empty{ color:#8a99a3; font-size:13px; padding:18px; text-align:center; }
  #misLead .badge{ font-size:11px; font-weight:700; border-radius:10px; padding:1px 7px; background:#eef2f5; color:#43555f; }
  #misLead .badge.ok{ background:#e7f3ee; color:#1f5a4b; }
  #misLead .badge.warn{ background:#fbeadb; color:#b45f1c; }

  /* 필터 칩 (단계) */
  #misLead .ml-chips{ display:flex; gap:6px; flex-wrap:wrap; margin-bottom:10px; align-items:center; }
  #misLead .ml-chip{ border:1px solid #cfd9e0; background:#fff; color:#43555f; border-radius:999px; padding:4px 12px; font-size:12.5px; font-weight:700; cursor:pointer; }
  #misLead .ml-chip b{ font-weight:800; color:#20303a; margin-left:4px; }
  #misLead .ml-chip.on{ background:#20303a; color:#fff; border-color:#20303a; }
  #misLead .ml-chip.on b{ color:#fff; }
  #misLead .ml-chip .od{ display:inline-block; margin-left:5px; background:#b23b3b; color:#fff; border-radius:9px; padding:0 6px; font-size:11px; }

  /* 달력 + 오늘 일정 */
  #misLead .ml-calwrap{ display:grid; grid-template-columns:minmax(0,1.6fr) minmax(0,1fr); gap:12px; align-items:start; }
  @media (max-width:1000px){ #misLead .ml-calwrap{ grid-template-columns:1fr; } }
  #misLead .ml-calhd{ display:flex; align-items:center; gap:8px; margin-bottom:8px; }
  #misLead .ml-calhd b{ font-size:16px; color:#20303a; min-width:120px; text-align:center; }
  #misLead .ml-cgrid{ display:grid; grid-template-columns:repeat(7,minmax(0,1fr)); gap:4px; }
  #misLead .ml-cw{ text-align:center; font-size:12px; font-weight:700; color:#6b7c86; padding:4px 0; }
  #misLead .ml-cw:first-child{ color:#b23b3b; }
  #misLead .ml-cd{ border:1px solid #e6ecf0; border-radius:6px; min-height:96px; padding:4px 4px 3px; background:#fff; cursor:pointer; min-width:0; overflow:hidden; }
  #misLead .ml-cd:hover{ border-color:#1f5a4b; }
  #misLead .ml-cd.out{ background:transparent; border-color:transparent; cursor:default; }
  #misLead .ml-cd.today{ border-color:#1f5a4b; box-shadow:inset 0 0 0 1px #1f5a4b; }
  #misLead .ml-cd.sel{ background:#eef7f3; border-color:#2a7665; }
  #misLead .ml-dn{ font-size:12px; font-weight:700; color:#43555f; margin-bottom:2px; }
  #misLead .ml-cd:first-child .ml-dn{ color:#b23b3b; }
  #misLead .ml-ev{ font-size:11px; line-height:1.35; border-radius:4px; padding:1px 4px; margin-top:2px; white-space:nowrap; overflow:hidden; text-overflow:ellipsis; color:#fff; }
  #misLead .ml-more{ font-size:11px; color:#6b7c86; margin-top:2px; }
  #misLead .k-call{ background:#2f6fa3; } #misLead .k-visit{ background:#1f5a4b; } #misLead .k-admitplan{ background:#b45f1c; }
  #misLead .k-admit{ background:#0f5132; } #misLead .k-disch{ background:#6b7c86; } #misLead .k-anbu{ background:#b23b3b; }
  #misLead .k-todo{ background:#6b5b95; }
  #misLead .ml-legend{ display:flex; gap:10px; flex-wrap:wrap; margin-top:8px; font-size:12px; color:#43555f; }
  #misLead .ml-legend i{ display:inline-block; width:10px; height:10px; border-radius:3px; margin-right:4px; vertical-align:-1px; }
  #misLead .ml-agh{ font-size:15px; font-weight:800; color:#20303a; margin-bottom:6px; }
  #misLead .ml-agsub{ font-size:12px; color:#6b7c86; margin-bottom:8px; }
  #misLead .ml-q{ width:100%; margin-bottom:8px; }
  #misLead .ml-ag{ display:flex; gap:8px; align-items:center; border:1px solid #e6ecf0; border-radius:8px; padding:7px 9px; margin-bottom:6px; cursor:pointer; background:#fff; font-size:13px; min-width:0; }
  #misLead .ml-ag:hover{ border-color:#1f5a4b; }
  #misLead .ml-ag.sel{ border:2px solid #1f5a4b; }
  #misLead .ml-ag .kd{ font-size:11px; color:#fff; border-radius:4px; padding:1px 6px; white-space:nowrap; }
  #misLead .ml-ag .nm{ font-weight:800; color:#20303a; white-space:nowrap; }
  #misLead .ml-ag .tx{ color:#6b7c86; font-size:12px; overflow:hidden; text-overflow:ellipsis; white-space:nowrap; min-width:0; }
  #misLead .ml-ag .late{ color:#b23b3b; font-weight:800; font-size:11.5px; margin-left:auto; white-space:nowrap; }
  #misLead .ml-aglist{ max-height:520px; overflow:auto; padding-right:2px; }

  /* 작업 칸 */
  #misLead .ml-work{ margin-top:12px; scroll-margin-top:70px; }
  #misLead .ml-wh{ display:flex; align-items:center; gap:10px; flex-wrap:wrap; margin-bottom:8px; }
  #misLead .ml-wh .nm{ font-size:17px; font-weight:800; color:#20303a; }
  #misLead .ml-flow{ display:flex; align-items:center; gap:4px; flex-wrap:wrap; margin:6px 0 10px; font-size:12px; }
  #misLead .ml-fp{ border:1px solid #d7dfe5; border-radius:999px; padding:2px 10px; color:#8a99a3; background:#fff; }
  #misLead .ml-fp.pass{ color:#1f5a4b; border-color:#cfe3da; background:#e7f3ee; }
  #misLead .ml-fp.cur{ color:#fff; background:#1f5a4b; border-color:#1f5a4b; font-weight:800; }
  #misLead .ml-flow i{ font-style:normal; color:#b0bcc4; }
  #misLead .ml-guide{ background:#f7faf9; border:1px solid #d9e8e1; border-radius:8px; padding:8px 12px; font-size:12.5px; line-height:1.7; color:#43555f; margin-bottom:10px; }
  #misLead .ml-guide b{ color:#1f5a4b; margin-right:4px; }
  #misLead .ml-info{ border:1px solid #e3e9ed; border-radius:8px; padding:6px 10px; margin-bottom:10px; background:#fbfcfd; }
  #misLead .ml-info summary{ cursor:pointer; font-weight:700; font-size:13px; color:#43555f; }
  #misLead .ml-frm{ display:grid; grid-template-columns:90px 1fr 90px 1fr; gap:6px 8px; align-items:center; font-size:13px; margin-top:8px; }
  @media (max-width:700px){ #misLead .ml-frm{ grid-template-columns:90px 1fr; } }
  #misLead .ml-frm label, #misLead .ml-lb{ color:#43555f; font-weight:700; font-size:12.5px; }
  #misLead .ml-frm .full{ grid-column:2 / -1; }
  #misLead .ml-frm input, #misLead .ml-frm select{ width:100%; }
  #misLead .ml-tools{ display:flex; gap:6px; align-items:center; margin-top:4px; flex-wrap:wrap; }
  #misLead .ml-sec{ border-top:1px dashed #e3e9ed; padding-top:10px; margin-top:10px; }
  #misLead .ml-sec h5{ margin:0 0 6px; font-size:13px; color:#20303a; }
  #misLead .ml-pair{ display:grid; grid-template-columns:130px 1fr; gap:6px 8px; align-items:center; font-size:13px; }
  #misLead .ml-pair2{ display:flex; gap:12px; flex-wrap:wrap; align-items:flex-end; }
  #misLead .ml-fld{ display:flex; flex-direction:column; gap:3px; min-width:150px; }
  #misLead .ml-fld.wide{ flex:1; min-width:240px; }
  #misLead .ml-fld input{ width:100%; }
  #misLead .ml-lbrow{ display:flex; align-items:center; gap:6px; }
  #misLead .ml-line{ display:flex; gap:10px; flex-wrap:wrap; align-items:flex-end; }
  #misLead .ml-line .ml-fld{ min-width:150px; }
  #misLead .ml-line .ml-fld.wide{ flex:1; min-width:260px; }
  #misLead .ml-row1{ display:flex; gap:6px; margin-bottom:6px; }
  #misLead .ml-row1 input{ flex:1; }
  #misLead .ml-foot{ display:flex; gap:8px; flex-wrap:wrap; align-items:center; margin-top:14px; padding-top:10px; border-top:1px solid #e3e9ed; }
  #misLead .ml-foot .ml-sp{ flex:1; }
  #misLead .logs{ font-size:12.5px; margin-top:6px; max-height:200px; overflow:auto; border-top:1px dashed #dde5ea; padding-top:6px; }
  #misLead .logs div{ padding:3px 0; border-bottom:1px solid #f1f4f6; }
  #misLead .logs .d{ color:#6b7c86; margin-right:6px; font-variant-numeric:tabular-nums; }
  #misLead .ml-cost{ margin-top:10px; border:1px solid #dde5ea; border-radius:8px; padding:6px 10px; background:#f8fafb; }
  #misLead .ml-cost summary{ cursor:pointer; font-weight:700; font-size:13px; color:#1f5a4b; }
  #misLead .ml-cost-row{ display:flex; gap:8px; align-items:center; flex-wrap:wrap; margin:8px 0 6px; font-size:12.5px; }
  #misLead .ml-cost-row label{ font-weight:700; color:#43555f; }
  #misLead .ml-cost-row select, #misLead .ml-cost-row input{ width:auto; }
  #misLead .ml-cost-tbl{ border-collapse:collapse; font-size:12.5px; }
  #misLead .ml-cost-tbl th, #misLead .ml-cost-tbl td{ padding:3px 12px 3px 0; text-align:right; }
  #misLead .ml-cost-tbl td:first-child, #misLead .ml-cost-tbl th:first-child{ text-align:left; color:#43555f; }
  #misLead .ml-note{ background:#fff; border:1px solid #e3e9ed; border-radius:10px; padding:9px 14px; font-size:12.5px; color:#43555f; margin-bottom:12px; line-height:1.6; }

  /* 표 (유입 분석 · 퇴원 안부) */
  #misLead table{ width:100%; border-collapse:collapse; font-size:13px; }
  #misLead th{ background:#f2f6f8; font-weight:700; color:#43555f; padding:7px 9px; border-bottom:1px solid #dde5ea; text-align:left; white-space:nowrap; }
  #misLead td{ padding:6px 9px; border-bottom:1px solid #eef2f5; vertical-align:middle; }
  #misLead td.n, #misLead th.n{ text-align:right; font-variant-numeric:tabular-nums; }
  #misLead .ml-wrap{ overflow-x:auto; }
  #misLead .ml-follow{ max-height:560px; overflow:auto; }
  #misLead .ml-follow thead th{ position:sticky; top:0; z-index:1; }
  #misLead #mlFollow th, #misLead #mlFollow td{ white-space:nowrap; }
  #misLead #mlFollow td.memo{ width:100%; }
  #misLead tr.done td{ color:#8a99a3; }
  #misLead .ml-pane[hidden]{ display:none; }
  #misLead .ml-help{ margin-bottom:12px; border-color:#cfe3da; background:#f7faf9; }
  #misLead .ml-help[hidden]{ display:none; }
  #misLead .ml-help h4{ font-size:14px; color:#1f5a4b; }
  #misLead .ml-help h5{ margin:12px 0 4px; font-size:13px; color:#20303a; }
  #misLead .ml-help p, #misLead .ml-help li{ font-size:12.5px; line-height:1.7; color:#43555f; margin:2px 0; }
  #misLead .ml-help ul{ margin:0; padding-left:18px; }
  #misLead .ml-help .ml-hk{ display:inline-block; font-size:11px; color:#fff; border-radius:4px; padding:1px 6px; margin-right:4px; }
  #misLead .ml-help .ml-hb{ display:inline-block; font-size:12px; font-weight:700; border:1px solid #cfd9e0; background:#fff; border-radius:6px; padding:1px 8px; margin-right:4px; }
</style>

<div class="ml-head">
  <div class="ml-title"><span class="ml-dot"></span>신규환자 고객관리 <span class="ml-sub">— 달력으로 연락·방문·입원 일정을 보고, 날짜마다 단계를 넘긴다</span></div>
  <span class="ml-hosp">🏥 <c:out value='${hospNm}'/></span>
  <span class="ml-spacer"></span>
  <button type="button" class="ml-btn" onclick="mlHelp();" title="이 화면의 쓰는 법">❓ 도움말</button>
  <button type="button" class="ml-btn" onclick="mlExcel();" title="상담 목록(종결 포함)과 퇴원 안부 연락 표를 엑셀 파일로">엑셀출력</button>
  <button type="button" class="ml-btn" onclick="mlReconcile();" title="상담 목록을 다시 읽고 입퇴원현황과 다시 대조합니다 — 다른 창에서 입퇴원현황을 올린 뒤 누르세요">입퇴원현황 다시 대조</button>
</div>

<div class="ml-tabs">
  <button type="button" class="ml-tab on" data-tab="cal" onclick="mlTab('cal')">달력 · 고객 관리</button>
  <button type="button" class="ml-tab" data-tab="follow" onclick="mlTab('follow')">퇴원 안부 연락</button>
  <button type="button" class="ml-tab" data-tab="stat" onclick="mlTab('stat')">유입 경로 분석</button>
</div>

<%-- ───────── 도움말 (도움말 단추로 열고 닫는다) ───────── --%>
<div id="mlHelp" class="ml-card ml-help" hidden>
  <h4>도움말 — 신규환자 고객관리 쓰는 법 <span class="sp"></span><button type="button" class="ml-btn sm" onclick="mlHelp();">닫기</button></h4>

  <h5>1. 화면 구성</h5>
  <ul>
    <li><b>달력</b>(왼쪽 위): 날짜마다 그 날의 일정이 색 칩으로 보입니다. 날짜 칸을 누르면 오른쪽 목록이 그 날 일정으로 바뀝니다.</li>
    <li><b>오른쪽 목록</b>: 선택한 날의 일정, 또는 이름 검색 결과가 나옵니다. 환자를 누르면 아래 작업 칸이 열립니다.</li>
    <li><b>작업 칸</b>(아래): 그 환자의 단계에 맞는 칸만 나옵니다. 위쪽 흐름 줄에서 지금 어느 단계인지 보입니다.</li>
    <li><b>단계 칩</b>(달력 위): 전체·상담·방문·입원 결정·입원·퇴원 후·종결 가운데 하나만 골라 봅니다. 숫자는 그 단계 환자 수입니다.</li>
  </ul>

  <h5>2. 달력의 일정 색</h5>
  <ul>
    <li><span class="ml-hk k-call">연락</span>다음 연락 날짜(상담·방문·입원 예정·입원 단계에서 잡은 날짜).</li>
    <li><span class="ml-hk k-visit">방문</span>방문 예정일 또는 방문일.</li>
    <li><span class="ml-hk k-admitplan">입원 예정</span>입원 결정 단계의 입원 예정일.</li>
    <li><span class="ml-hk k-admit">입원</span>입원일. 입퇴원현황에 올라오면 자동으로 찍힙니다.</li>
    <li><span class="ml-hk k-disch">퇴원</span>퇴원일. 입퇴원현황에 올라오면 자동으로 찍힙니다.</li>
    <li><span class="ml-hk k-anbu">안부</span>퇴원 7일째. 안부 연락을 할 날입니다.</li>
    <li><span class="ml-hk k-todo">할 일</span>입원 중 다음 할 일의 기한.</li>
    <li>지난 날짜의 연락·방문 칩은 흐리게 보이고, 목록에는 「지남」이 붙습니다.</li>
  </ul>

  <h5>3. 상담부터 퇴원 후까지 순서</h5>
  <ul>
    <li><b>상담</b>: 전화·방문 상담을 받으면 접수합니다. 방문 날짜를 정해 「방문으로 넘기기」를 누릅니다.</li>
    <li><b>방문</b>: 방문 내용을 이력에 적습니다. 입원 의사가 확인되면 「입원 결정으로 넘기기」를 누릅니다.</li>
    <li><b>입원 결정</b>: 입원 예정일과 준비할 일을 관리합니다. 입원이 정해지면 「입원으로 넘기기」를 누릅니다.</li>
    <li><b>입원</b>: 입원 중 보호자 상담을 관리합니다. 퇴원하면 「퇴원 후로 넘기기」를 누릅니다.</li>
    <li><b>퇴원 후</b>: 7일째에 안부 연락을 하고 결과를 저장합니다. 재입원을 원하면 「재입원 상담 새로 접수」를 누릅니다.</li>
    <li>끝난 상담은 「종결」을 누르고 사유를 고릅니다. 종결하면 달력에서 빠지고 종결 목록에 남습니다.</li>
  </ul>

  <h5>4. 작업 칸의 단추</h5>
  <ul>
    <li><span class="ml-hb">저장</span>지금 단계 그대로 입력한 내용만 저장합니다.</li>
    <li><span class="ml-hb">다음 단계로 넘기기 →</span>입력한 내용을 저장하고 다음 단계로 옮깁니다. 달력에서 날짜가 그 단계의 일정으로 바뀝니다.</li>
    <li><span class="ml-hb">← 이전</span>잘못 넘겼을 때 한 단계 되돌립니다.</li>
    <li><span class="ml-hb">＋ 이 날짜로 상담 접수</span>달력에서 고른 날을 상담일로 해서 새 상담을 적습니다.</li>
    <li>🎤 음성은 말로 받아 적습니다(크롬·엣지). ✨ AI 정리는 적은 글을 기록체로 줄입니다. 되돌리려면 [↩ 원문]을 누릅니다.</li>
  </ul>

  <h5>5. 자동으로 이어지는 것</h5>
  <ul>
    <li>생년월일 6자리와 이름을 적어 두면, 입퇴원현황이 올라올 때 입원과 퇴원이 자동으로 확인되고 단계도 앞으로 옮겨집니다.</li>
    <li>입퇴원현황을 다른 창에서 올린 뒤에는 상단 「입퇴원현황 다시 대조」를 누르세요.</li>
    <li>연락 날짜가 지나면 업무 알림에 뜹니다. 퇴원 안부 연락은 「퇴원 안부 연락」 탭에서도 같은 환자를 봅니다.</li>
  </ul>

  <h5>6. 자주 묻는 것</h5>
  <ul>
    <li><b>환자가 목록에 안 보여요</b>: 종결된 상담은 달력에서 빠집니다. 「종결」 칩이나 검색에서 찾을 수 있습니다.</li>
    <li><b>입원이 자동으로 안 찍혀요</b>: 생년월일을 적었는지, 이름이 입퇴원현황과 같은지 확인하세요.</li>
    <li><b>저장이 안 돼요</b>: 환자 이름과 생년월일 6자리(YYMMDD)를 확인하세요.</li>
  </ul>
</div>

<%-- ───────── 달력 화면 (기본) ───────── --%>
<div id="mlPaneCal" class="ml-pane">
  <div class="ml-chips" id="mlChips"></div>
  <div class="ml-calwrap" data-split="lead.cal">
    <div class="ml-card">
      <div id="mlCal"></div>
      <div class="ml-legend">
        <span><i class="k-call"></i>연락 예정</span><span><i class="k-visit"></i>방문</span><span><i class="k-admitplan"></i>입원 예정</span>
        <span><i class="k-admit"></i>입원</span><span><i class="k-disch"></i>퇴원</span><span><i class="k-anbu"></i>안부 연락(퇴원 7일째)</span><span><i class="k-todo"></i>할 일(입원 중 다음 할 일)</span>
      </div>
    </div>
    <div class="ml-card">
      <input type="text" id="mlQ" class="ml-q" placeholder="환자 이름으로 찾기 (전체 단계)" oninput="mlSearch();">
      <div id="mlAgenda"></div>
      <div style="margin-top:8px;display:flex;gap:6px;align-items:center;flex-wrap:wrap;">
        <button type="button" class="ml-btn pri" onclick="mlNewAt('10');">＋ 새 상담 접수</button>
        <span class="small">또는 단계를 골라 바로 접수</span>
        <select id="mlNewStage" title="이미 그 단계에 있는 환자를 바로 적을 때 고르세요">
          <option value="20">방문</option><option value="30">입원 결정</option><option value="40" selected>입원</option><option value="50">퇴원 후</option>
        </select>
        <button type="button" class="ml-btn" onclick="mlNewAt(document.getElementById('mlNewStage').value);">＋ 바로 접수</button>
      </div>
    </div>
  </div>
  <div class="ml-work ml-card" id="mlWork"></div>
</div>

<%-- ───────── 퇴원 안부 연락 ───────── --%>
<div id="mlPaneFollow" class="ml-pane ml-card" hidden>
  <h4>퇴원 환자 안부 연락 <span class="sp"></span><label class="small">최근 <select id="mlFollowDays" onchange="mlFollow();"><option value="30">30일</option><option value="60" selected>60일</option><option value="90">90일</option></select> 퇴원</label></h4>
  <div class="ml-wrap ml-follow"><table id="mlFollow"><tbody><tr><td class="ml-empty">불러오는 중…</td></tr></tbody></table></div>
  <div class="small" style="margin-top:6px;">입퇴원현황의 퇴원 건입니다. 연락하고 결과를 고르면 저장됩니다. 「재입원 희망」은 재입원 상담으로 이어 받을 수 있습니다.</div>
</div>

<%-- ───────── 유입 경로 분석 ───────── --%>
<div id="mlPaneStat" class="ml-pane ml-card" hidden>
  <h4>유입 경로별 상담 → 입원 <span class="sp"></span><label class="small"><input type="radio" name="mlStatRng" value="m" checked onchange="mlStats();"> 이번 달</label> <label class="small"><input type="radio" name="mlStatRng" value="q" onchange="mlStats();"> 최근 3달</label></h4>
  <div class="ml-wrap"><table id="mlStat"></table></div>
  <div class="small" style="margin-top:6px;">입원 = 단계가 입원·퇴원 후인 상담. 어떤 경로가 실제 입원으로 이어지는지 보고 홍보에 씁니다.</div>
</div>

<script>
(function(){
  function gel(id){ return document.getElementById(id); }
  function esc(s){ return (s==null?'':String(s)).replace(/[&<>"]/g, function(c){ return ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;'})[c]; }); }
  function pad(n){ return (n < 10 ? '0' : '') + n; }
  function post(url, data){
    return $.ajax({ url:url, type:'POST', data:data, dataType:'json' }).then(function(res){
      if (res && res.result === 'FAIL') { throw new Error(res.message || '처리에 실패했습니다.'); }
      return res;
    });
  }
  function err(e){ _alertBox((e && e.message) ? e.message : '처리 중 오류가 발생했습니다.', {icon:'❌'}); }
  var root = gel('misLead'), WNN = root.getAttribute('data-wnn') === 'Y';
  function hospCd(){
    try { if (WNN && typeof getCookie === 'function') { var h = (getCookie('s_hospid') || '').trim(); if (h) return h; } } catch(e){}
    return root.getAttribute('data-hosp');
  }
  function withHosp(p){ if (WNN) p.hospCd = hospCd(); return p; }

  var URL_LIST = '<c:url value="/mis/leadList.do"/>', URL_SAVE = '<c:url value="/mis/leadSave.do"/>', URL_STAGE = '<c:url value="/mis/leadStage.do"/>',
      URL_LOG = '<c:url value="/mis/leadLog.do"/>', URL_DEL = '<c:url value="/mis/leadDel.do"/>', URL_LOGDEL = '<c:url value="/mis/leadLogDel.do"/>', URL_FOLLOW = '<c:url value="/mis/followList.do"/>',
      URL_FSAVE = '<c:url value="/mis/followSave.do"/>', URL_COST = '<c:url value="/mis/classCost.do"/>', URL_AI = '<c:url value="/mis/aiSummary.do"/>';

  var STAGES = [['10','상담'],['20','방문'],['30','입원 결정'],['40','입원'],['50','퇴원 후']];
  var CHIPS = [['all','전체']].concat(STAGES, [['90','종결']]);
  var CH = { INTRO:'지인·환자 소개', TRANS:'타 병원 전원', WEB:'인터넷 검색', ADS:'광고·현수막', ETC:'기타' };
  var RESULTS = [['HOME','잘 지냄'],['READMIT','재입원 희망'],['OTHER','타 병원 입원'],['NOANS','연락 안 됨'],['ETC','기타']];
  var CLOSE_RSN = ['타 병원 입원','보류','연락 안 됨','기타'];
  var KIND = { call:{nm:'연락', c:'k-call'}, visit:{nm:'방문', c:'k-visit'}, admitplan:{nm:'입원 예정', c:'k-admitplan'},
               admit:{nm:'입원', c:'k-admit'}, disch:{nm:'퇴원', c:'k-disch'}, anbu:{nm:'안부', c:'k-anbu'}, todo:{nm:'할 일', c:'k-todo'} };
  var DOW = ['일','월','화','수','목','금','토'];
  // 단계마다 작업 칸에 보이는 칸 (plan·admit·next 는 라벨, null 이면 숨김)
  var ST = { '10':{plan:'방문 예정일', admit:null, next:'다음 연락'}, '20':{plan:'방문일', admit:null, next:'다음 할 일'},
             '30':{plan:'입원 예정일', admit:'입원일(확정 시)', next:'준비할 일'}, '40':{plan:null, admit:'입원일', next:'다음 할 일'},
             '50':{plan:null, admit:null, next:null}, '90':{plan:null, admit:null, next:null} };
  var NEXT_LBL = { '10':'방문으로 넘기기', '20':'입원 결정으로 넘기기', '30':'입원으로 넘기기', '40':'퇴원 후로 넘기기' };
  var HINT = { '10':'상담 접수', '20':'방문 날짜·내용', '30':'입원 예정·준비', '40':'입원 중 관리', '50':'퇴원 후 안부', '90':'끝난 상담' };
  var GUIDE = {
    '10': { do:'전화·방문 상담을 받으면 이름·생년월일·보호자·연락처·경로를 적습니다. 상태·요구는 🎤 말로 받아 적고 ✨ 로 정리할 수 있습니다.',
            next:'방문 날짜를 정해 「방문으로 넘기기」를 누르면 달력에 방문 일정이 올라갑니다.',
            auto:'생년월일을 적어 두면 입퇴원현황이 올라올 때 입원이 자동으로 확인됩니다. 연락 날짜가 지나면 업무 알림에 뜹니다.' },
    '20': { do:'방문 날짜와 방문 후 내용을 기록합니다.',
            next:'입원 의사가 확인되면 「입원 결정으로 넘기기」를 누릅니다.',
            auto:'방문 날짜는 달력에 보입니다.' },
    '30': { do:'입원 예정일과 준비할 일(보호자 서류·병실 등)을 관리합니다.',
            next:'입원일이 정해지면 「입원으로 넘기기」를 누릅니다.',
            auto:'입퇴원현황에 입원이 올라오면 자동으로 「입원」이 되고 달력에 입원일이 찍힙니다.' },
    '40': { do:'입원 중 보호자 상담과 다음 할 일을 관리합니다.',
            next:'퇴원하면 「퇴원 후로 넘기기」를 눌러 안부 연락 단계로 넘깁니다.',
            auto:'입퇴원현황에 퇴원이 올라오면 자동으로 「퇴원 후」가 되고 달력에 퇴원일이 찍힙니다.' },
    '50': { do:'퇴원 7일째부터 안부 연락을 하고 결과를 남깁니다.',
            next:'재입원을 원하면 「재입원 상담 새로 접수」로 이어 받고, 끝나면 종결합니다.',
            auto:'퇴원 7일째 날짜에 달력의 안부 연락 표시가 뜹니다. 같은 환자는 「퇴원 안부 연락」 탭에서도 봅니다.' },
    '90': { do:'종결된 상담입니다. 이력만 볼 수 있습니다.', next:'다시 열면 상담부터 이어갈 수 있습니다.', auto:'' }
  };

  var D = null, CUR = null, TODAY = '', FILTER = 'all', VY = 0, VM = 0, SELDAY = '', QUERY = '', FOLLOW = [];
  var COST = null, COST_REQ = false;

  /* ── 날짜 도우미 (yyyymmdd 문자열) ── */
  function d8(s){ s = String(s||'').replace(/-/g,''); return s.length === 8 ? s : ''; }
  function dLbl(s){ s = d8(s); return s ? s.slice(0,4) + '-' + s.slice(4,6) + '-' + s.slice(6) : ''; }
  function dMD(s){ s = d8(s); return s ? Number(s.slice(4,6)) + '/' + Number(s.slice(6)) : ''; }
  function dIn(s){ return dLbl(s); }
  function ymd(y, m, d){ return String(y) + pad(m) + pad(d); }
  function parts(s){ return { y:Number(s.slice(0,4)), m:Number(s.slice(4,6)), d:Number(s.slice(6)) }; }
  function addDays(s, n){ var p = parts(s), t = new Date(p.y, p.m-1, p.d + n); return ymd(t.getFullYear(), t.getMonth()+1, t.getDate()); }
  function daysBetween(a, b){ a = d8(a); b = d8(b); if (!a || !b) return null; var da = new Date(parts(a).y, parts(a).m-1, parts(a).d), db = new Date(parts(b).y, parts(b).m-1, parts(b).d); return Math.round((db - da) / 86400000); }
  function dowOf(s){ var p = parts(s); return DOW[new Date(p.y, p.m-1, p.d).getDay()]; }
  function stageNm(c){ for (var i = 0; i < STAGES.length; i++) if (STAGES[i][0] === c) return STAGES[i][1]; return c === '90' ? '종결' : c; }
  function stageIdx(c){ for (var i = 0; i < STAGES.length; i++) if (STAGES[i][0] === c) return i; return -1; }
  function leads(){ return (D && D.leads) || []; }
  function findLead(seq){ var r = leads().filter(function(x){ return String(x.leadseq) === String(seq); })[0]; return r || null; }
  /* 작업 칸 입력값 — 칸이 화면에 있으면 화면 값, 없으면 CUR 값(저장 때 빠지지 않게) */
  function fv(id, dflt){ var e = gel(id); return e ? e.value : (dflt == null ? '' : String(dflt)); }

  /* ── 일정 만들기: 리드의 날짜 칸을 달력 일정으로 ── */
  /* 환자 한 명의 달력 일정(단계 필터와 무관) */
  function eventsOf(l){
    var out = [];
    if (l.stage === '90') return out;
    function add(dt, kind){ var k = d8(dt); if (k) out.push({ date:k, kind:kind, l:l }); }
    if (l.stage === '10') { add(l.nextdt, 'call'); add(l.plandt, 'visit'); }
    if (l.stage === '20') { add(l.plandt, 'visit'); add(l.nextdt, 'call'); }
    if (l.stage === '30') { add(l.plandt, 'admitplan'); add(l.nextdt, 'call'); }
    if (l.stage === '40') { add(l.admitdt, 'admit'); add(l.nextdt, 'todo'); }   /* 입원 단계의 다음 할 일 날짜는 「할 일」로 표시한다 */
    if (l.stage === '50') { add(l.dischdt, 'disch'); if (d8(l.dischdt)) add(addDays(d8(l.dischdt), 7), 'anbu'); }
    return out;
  }
  function buildEvents(){
    var out = [];
    leads().forEach(function(l){
      if (FILTER !== 'all' && l.stage !== FILTER) return;
      out = out.concat(eventsOf(l));
    });
    return out;
  }
  /* 단계 필터에 든 환자 중 이 달 달력에 안 나오는 환자: 날짜가 없거나, 날짜가 다른 달에만 있는 경우 (대상자가 안 보이는 일을 막는다) */
  function undatedLeads(){
    var ym = String(VY) + pad(VM);
    return leads().filter(function(l){
      if (l.stage === '90') return false;
      if (FILTER !== 'all' && l.stage !== FILTER) return false;
      return !eventsOf(l).some(function(e){ return e.date.slice(0, 6) === ym; });
    });
  }
  function isLate(e){ return e.date < TODAY && (e.kind === 'call' || e.kind === 'visit' || e.kind === 'admitplan' || e.kind === 'anbu' || e.kind === 'todo'); }

  /* ── 상단 단계 칩 ── */
  function renderChips(){
    var cnt = {}, od = 0;
    leads().forEach(function(l){ cnt[l.stage] = (cnt[l.stage] || 0) + 1; if (l.stage === '10' && d8(l.nextdt) && d8(l.nextdt) <= TODAY) od++; });
    var total = leads().filter(function(l){ return l.stage !== '90'; }).length;
    gel('mlChips').innerHTML = CHIPS.map(function(c){
      var n = c[0] === 'all' ? total : (cnt[c[0]] || 0);
      return '<button type="button" class="ml-chip' + (FILTER === c[0] ? ' on' : '') + '" onclick="mlFilter(\'' + c[0] + '\');">' + esc(c[1]) + '<b>' + n + '</b>' + (c[0] === '10' && od ? '<span class="od">연락 ' + od + '</span>' : '') + '</button>';
    }).join('');
  }

  /* ── 달력 ── */
  function renderCal(){
    var by = {}; buildEvents().forEach(function(e){ (by[e.date] = by[e.date] || []).push(e); });
    var first = new Date(VY, VM-1, 1).getDay(), last = new Date(VY, VM, 0).getDate();
    var h = '<div class="ml-calhd"><button type="button" class="ml-btn sm" onclick="mlMonth(-1);">‹</button><b>' + VY + '년 ' + VM + '월</b>' +
            '<button type="button" class="ml-btn sm" onclick="mlMonth(1);">›</button><button type="button" class="ml-btn sm" onclick="mlToday();">오늘</button></div>';
    h += '<div class="ml-cgrid">' + DOW.map(function(w){ return '<div class="ml-cw">' + w + '</div>'; }).join('');
    var i, d;
    for (i = 0; i < first; i++) h += '<div class="ml-cd out"></div>';
    for (d = 1; d <= last; d++) {
      var k = ymd(VY, VM, d), list = by[k] || [];
      h += '<div class="ml-cd' + (k === TODAY ? ' today' : '') + (k === SELDAY ? ' sel' : '') + '" onclick="mlDay(\'' + k + '\');">' +
           '<div class="ml-dn">' + d + '</div>' +
           list.slice(0, 3).map(function(e){ return '<div class="ml-ev ' + KIND[e.kind].c + '"' + (isLate(e) ? ' style="opacity:.75"' : '') + '>' + esc(KIND[e.kind].nm) + ' ' + esc(e.l.patnm) + '</div>'; }).join('') +
           (list.length > 3 ? '<div class="ml-more">+' + (list.length - 3) + '건 더</div>' : '') + '</div>';
    }
    var rest = (7 - ((first + last) % 7)) % 7;
    for (i = 0; i < rest; i++) h += '<div class="ml-cd out"></div>';
    h += '</div>';
    gel('mlCal').innerHTML = h;
  }

  /* ── 오른쪽: 선택한 날의 일정 · 검색 ── */
  function agendaItem(l, kind, extra){
    var sel = CUR && String(CUR.leadseq) === String(l.leadseq);
    return '<div class="ml-ag' + (sel ? ' sel' : '') + '" onclick="mlPick(\'' + esc(l.leadseq) + '\');">' +
           (kind ? '<span class="kd ' + KIND[kind].c + '">' + KIND[kind].nm + '</span>' : '<span class="kd" style="background:#6b7c86">' + esc(stageNm(l.stage)) + '</span>') +
           '<span class="nm">' + esc(l.patnm) + '</span>' +
           '<span class="tx">' + esc(stageNm(l.stage)) + (l.guardnm ? ' · ' + esc(l.guardnm) + (l.guardrel ? '(' + esc(l.guardrel) + ')' : '') : '') + (l.tel ? ' · ' + esc(l.tel) : '') + '</span>' +
           (extra || '') + '</div>';
  }
  function renderAgenda(){
    var box = gel('mlAgenda'), q = String(gel('mlQ') ? gel('mlQ').value : '').trim();
    if (q) {
      var hits = leads().filter(function(l){ return String(l.patnm || '').indexOf(q) >= 0; });
      box.innerHTML = '<div class="ml-agh">「' + esc(q) + '」 검색 결과 <span class="small">' + hits.length + '명</span></div>' +
        (hits.length ? '<div class="ml-aglist">' + hits.map(function(l){ return agendaItem(l, null, ''); }).join('') + '</div>' : '<div class="ml-empty">찾는 환자가 없습니다. 상담 접수로 새로 적을 수 있습니다.</div>');
      return;
    }
    if (FILTER === '90') {   /* 종결 칩: 달력에는 안 나오므로 종결 환자 목록을 보여 준다 */
      var closed = leads().filter(function(l){ return l.stage === '90'; });
      box.innerHTML = '<div class="ml-agh">종결된 상담 <span class="small">' + closed.length + '명</span></div>' +
        '<div class="ml-agsub">종결 사유를 함께 보여 줍니다. 누르면 아래에서 내용을 보고 다시 열 수 있습니다.</div>' +
        (closed.length ? '<div class="ml-aglist">' + closed.map(function(l){ return agendaItem(l, null, '<span class="tx" style="margin-left:auto;white-space:nowrap;">' + esc(l.closersn || '사유 없음') + '</span>'); }).join('') + '</div>'
                       : '<div class="ml-empty">종결된 상담이 없습니다.</div>');
      return;
    }
    var day = SELDAY || TODAY, ev = buildEvents().filter(function(e){ return e.date === day; });
    var order = { call:0, visit:1, admitplan:2, admit:3, disch:4, anbu:5, todo:6 };
    ev.sort(function(a, b){ return order[a.kind] - order[b.kind]; });
    var p = parts(day);
    var h = '<div class="ml-agh">' + p.m + '월 ' + p.d + '일 (' + dowOf(day) + ')' + (day === TODAY ? ' <span class="badge ok">오늘</span>' : '') + '</div>' +
            '<div class="ml-agsub">' + (ev.length ? ev.length + '건의 일정 · 누르면 아래에서 작업합니다' : '이 날 일정이 없습니다') + (FILTER !== 'all' ? ' · 단계 필터 적용 중' : '') + '</div>';
    h += '<div class="ml-aglist">' + ev.map(function(e){ return agendaItem(e.l, e.kind, isLate(e) ? '<span class="late">지남</span>' : ''); }).join('') + '</div>';
    h += '<div style="margin-top:8px;"><button type="button" class="ml-btn sm" onclick="mlNewAt(\'10\', {contactdt:\'' + day + '\'});">＋ 이 날짜로 상담 접수</button></div>';
    var und = undatedLeads();
    if (und.length) {
      h += '<div class="ml-agh" style="margin-top:14px;font-size:14px;">이 달에 날짜가 없는 환자 <span class="small">' + und.length + '명</span></div>' +
           '<div class="ml-agsub">입원일이나 예정일을 적으면 달력에 표시됩니다. 누르면 아래에서 바로 적을 수 있습니다.</div>' +
           '<div class="ml-aglist">' + und.map(function(l){ return agendaItem(l, null, ''); }).join('') + '</div>';
    }
    box.innerHTML = h;
  }

  /* ── 작업 칸 ── */
  /* 칸마다 ✕ — 그 칸만 지운다 (환자 기록 전체를 지우지 않는다) */
  function clearBtn(id, tip){ return '<button type="button" class="ml-btn sm" style="margin-left:4px;color:#b23b3b;" onclick="mlClearField(\'' + id + '\');" title="' + esc(tip) + '">✕ 지우기</button>'; }
  function clearBtnIds(ids, tip){ return '<button type="button" class="ml-btn sm" style="color:#b23b3b;margin-left:auto;" onclick="mlClearFields([\'' + ids.join("','") + '\']);" title="' + esc(tip) + '">✕ 지우기</button>'; }
  function dateField(id, label, tip){ return '<div class="ml-fld"><label class="ml-lb">' + esc(label) + '</label><input type="date" id="' + id + '"' + (tip ? ' title="' + esc(tip) + '"' : '') + '></div>'; }
  function dateRaw(id){ return '<input type="date" id="' + id + '">'; }
  function nextInputs(){ return '<input type="date" id="lfNextDt"><input type="text" id="lfNextMemo" maxlength="200">'; }
  /* 일정 한 줄: 방문일(입원 예정일·입원일) · 다음 할 일 날짜 · 내용 을 좌우로 나란히 */
  function stageForm(s){
    var t = ST[s] || {}, parts = [], sink = '';
    if (t.plan) parts.push(dateField('lfPlan', t.plan));
    if (t.admit) parts.push(dateField('lfAdmit', t.admit, '입퇴원현황이 올라오면 자동으로 채워집니다'));
    if (t.next) {
      parts.push(dateField('lfNextDt', t.next + ' 날짜'));
      parts.push('<div class="ml-fld wide"><label class="ml-lb">' + esc(t.next) + ' 내용</label><input type="text" id="lfNextMemo" maxlength="200" placeholder="예) 방문 약속 잡기 · 보호자 재통화"></div>');
    }
    var vis = parts.length ? '<div class="ml-sec"><h5>일정</h5><div class="ml-line">' + parts.join('') + '</div></div>' : '';
    if (!t.plan) sink += dateRaw('lfPlan');
    if (!t.admit) sink += dateRaw('lfAdmit');
    if (!t.next) sink += nextInputs();
    return vis + '<div hidden>' + sink + '</div>';
  }
  function infoBlock(open){
    return '<details class="ml-info" id="mlInfo"' + (open ? ' open' : '') + '><summary>접수 정보 <span class="small">' +
      (open ? '이름·생년월일·보호자·연락처를 적습니다' : '보호자·연락처·상태를 고치려면 펼치세요') + '</span></summary><div class="ml-frm">' +
      '<label>환자 이름 *</label><input type="text" id="lfNm" maxlength="50">' +
      '<label>생년월일 6</label><input type="text" id="lfBirth" maxlength="6" placeholder="YYMMDD">' +
      '<label>성별</label><select id="lfGender"><option value="">—</option><option value="M">남</option><option value="F">여</option></select>' +
      '<label>상담일</label><input type="date" id="lfContact">' +
      '<label>보호자</label><input type="text" id="lfGuard" maxlength="50" placeholder="이름">' +
      '<label>관계</label><input type="text" id="lfRel" maxlength="20" placeholder="아들·딸·배우자">' +
      '<label>연락처</label><input type="text" id="lfTel" maxlength="30">' +
      '<label>유입 경로</label><select id="lfChannel"><option value="INTRO">지인·환자 소개</option><option value="TRANS">타 병원 전원</option><option value="WEB">인터넷 검색</option><option value="ADS">광고·현수막</option><option value="ETC">기타</option></select>' +
      '<label>상태·요구</label><div class="full"><textarea id="lfCond" maxlength="300" placeholder="예) 뇌졸중 재활, 보행 불편, 2인실 희망"></textarea>' +
      '<div class="ml-tools"><button type="button" class="ml-btn sm" onclick="mlVoice(\'lfCond\', this)">🎤 음성</button><button type="button" class="ml-btn sm" onclick="mlAi(\'cond\', this)">✨ AI 정리</button><span class="small">말로 받아 적고, AI 가 상태·요구·확인할 것으로 정리합니다</span></div></div>' +
      '</div></details>';
  }
  function costBlock(){
    return '<details class="ml-cost" id="mlCost" ontoggle="if(this.open){mlCostInit();}"><summary>💰 예상 비용 안내 <span class="small">— 본원 최근 청구의 환자군별 1인 1일 진료비로, 보호자 물음에 바로 답할 때</span></summary>' +
           '<div id="mlCostBody"><div class="small">펼치면 불러옵니다.</div></div></details>';
  }
  function logsBlock(){
    return '<div class="ml-sec"><h5>상담 이력</h5><div class="ml-row1">' +
           '<input type="text" id="lfLogMemo" maxlength="500" placeholder="통화·방문 내용을 적고 Enter" onkeydown="if(event.key===\'Enter\'){mlLogAdd();}">' +
           '<button type="button" class="ml-btn" onclick="mlVoice(\'lfLogMemo\', this)" title="말로 받아 적기(크롬·엣지)">🎤 음성</button>' +
           '<button type="button" class="ml-btn" onclick="mlAi(\'log\', this)" title="적은 글을 기록체 한두 문장으로">✨ AI 정리</button>' +
           '<button type="button" class="ml-btn" onclick="mlLogAdd();">기록</button></div><div class="logs" id="mlLogs"></div></div>';
  }
  function anbuBlock(){
    return '<div class="ml-sec"><h5>퇴원 후 안부 연락</h5><div class="ml-pair">' +
           '<label class="ml-lb">결과</label><select id="lfFwRes"><option value="">— 아직 연락 전</option>' + RESULTS.map(function(x){ return '<option value="' + x[0] + '">' + x[1] + '</option>'; }).join('') + '</select>' +
           '<label class="ml-lb">메모</label><input type="text" id="lfFwMemo" maxlength="300"></div>' +
           '<div class="small" style="margin-top:6px;">퇴원 7일째부터 연락합니다. 저장하면 「퇴원 안부 연락」 탭에도 같이 반영됩니다.</div>' +
           '<div style="margin-top:6px;"><button type="button" class="ml-btn" onclick="mlFollowSave();">안부 결과 저장</button></div></div>';
  }
  function dischBlock(l){
    var dd = daysBetween(d8(l.dischdt), TODAY);
    return '<div class="ml-sec"><h5>퇴원</h5><div class="ml-pair2">' +
           '<div class="ml-fld"><span class="ml-lb">퇴원일</span><b>' + (l.dischdt ? esc(dLbl(l.dischdt)) : '입퇴원현황 대기') + '</b></div>' +
           '<div class="ml-fld"><span class="ml-lb">퇴원 후 경과</span><b>' + (dd == null ? '—' : dd + '일째' + (dd >= 7 ? ' · 연락할 때' : '')) + '</b></div></div></div>';
  }
  function flowStrip(s){
    var idx = stageIdx(s);
    if (s === '90') return '<div class="ml-flow"><span class="ml-fp cur">종결</span></div>';
    return '<div class="ml-flow">' + STAGES.map(function(st, i){
      return '<span class="ml-fp' + (i < idx ? ' pass' : (i === idx ? ' cur' : '')) + '">' + (i < idx ? '✓ ' : '') + esc(st[1]) + '</span>' + (i < STAGES.length - 1 ? '<i>›</i>' : '');
    }).join('') + '</div>';
  }
  function guideBox(s){
    var g = GUIDE[s]; if (!g) return '';
    return '<div class="ml-guide"><div><b>지금 할 일</b>' + esc(g.do) + '</div><div><b>다음으로 넘어가는 때</b>' + esc(g.next) + '</div>' +
           (g.auto ? '<div><b>자동으로 이어지는 것</b>' + esc(g.auto) + '</div>' : '') + '</div>';
  }
  function footerHtml(s, isNew){
    var idx = stageIdx(s), b = '';
    if (s === '90') {
      b = '<button type="button" class="ml-btn pri" onclick="mlMove(\'10\');">다시 열고 상담부터</button>';
    } else {
      b += '<button type="button" class="ml-btn" onclick="mlMove(\'' + s + '\');">저장</button>';
      if (idx > 0) b += '<button type="button" class="ml-btn" onclick="mlMove(\'' + STAGES[idx-1][0] + '\');">← 이전: ' + esc(STAGES[idx-1][1]) + '</button>';
      if (idx < STAGES.length - 1) {
        b += '<button type="button" class="ml-btn pri" onclick="mlMove(\'' + STAGES[idx+1][0] + '\');">' + NEXT_LBL[s] + ' →</button>';
      } else {
        b += '<button type="button" class="ml-btn" onclick="mlReadmit();">재입원 상담 새로 접수</button>';
        b += '<select id="mlCloseSel">' + CLOSE_RSN.map(function(r){ return '<option value="' + esc(r) + '">' + esc(r) + '</option>'; }).join('') + '</select>';
        b += '<button type="button" class="ml-btn del" onclick="mlClose();">종결</button>';
      }
    }
    if (!isNew) b += '<span class="ml-sp"></span><button type="button" class="ml-btn del sm" onclick="mlDel();">환자 기록 전부 지우기</button>';
    return '<div class="ml-foot">' + b + '</div>';
  }
  function bodyFor(s, l){
    var h = '';
    if (s === '10' || s === '20') h += '';
    if (s === '50') h += dischBlock(l);
    h += stageForm(s);
    if (s === '50') h += anbuBlock();
    if (s === '90') h += '<div class="ml-sec"><h5>종결</h5><div class="small">사유: ' + esc(l.closersn || '—') + '</div></div>';
    if (s === '10' || s === '20') h += costBlock();
    h += logsBlock();
    return h;
  }
  function renderWork(){
    var W = gel('mlWork');
    if (!CUR) {
      W.innerHTML = '<div class="ml-wh"><span class="nm">환자를 고르면 여기서 작업합니다</span></div>' +
        '<div class="ml-guide"><div><b>흐름</b>상담 → 방문 → 입원 결정 → 입원 → 퇴원 후. 달력의 일정이나 오른쪽 목록에서 환자를 누르면 그 환자의 단계에 맞는 칸이 열립니다.</div>' +
        '<div><b>자동으로 이어지는 것</b>입퇴원현황이 올라오면 입원·퇴원이 자동으로 표시되고, 퇴원 7일째에는 안부 연락 일정이 달력에 뜹니다.</div></div>';
      return;
    }
    var isNew = !CUR.leadseq, s = CUR.stage || '10';
    var head = '<div class="ml-wh"><span class="nm">' + esc(CUR.patnm || '새 상담 접수') + '</span>' +
               (CUR.birth6 ? '<span class="small">' + esc(CUR.birth6) + (CUR.gender ? ' · ' + (CUR.gender === 'M' ? '남' : '여') : '') + '</span>' : '') +
               '<span class="badge ' + (s === '40' || s === '50' ? 'ok' : '') + '">' + esc(stageNm(s)) + '</span>' +
               (CUR.matchyn === 'Y' ? '<span class="badge ok">입퇴원현황 확인</span>' : '') +
               (isNew ? '<span class="small">저장하면 이 단계에 들어갑니다</span>' : '') + '</div>';
    W.innerHTML = head + flowStrip(s) + guideBox(s) + infoBlock(s === '10' || isNew) + bodyFor(s, CUR) + footerHtml(s, isNew);
    fillFields(CUR);
    if (COST && gel('mlCost') && gel('mlCost').open) mlCostFill();
    if (isNew) gel('mlLogs').innerHTML = '<div class="small">저장하면 이력을 적을 수 있습니다.</div>'; else loadLogs();
    if (s === '50') fillAnbu(CUR);
  }
  function fillFields(l){
    function set(id, v){ var e = gel(id); if (e) e.value = v == null ? '' : v; }
    set('lfNm', l.patnm); set('lfBirth', l.birth6); set('lfGender', l.gender); set('lfContact', dIn(l.contactdt) || dIn(TODAY));
    set('lfGuard', l.guardnm); set('lfRel', l.guardrel); set('lfTel', l.tel); set('lfChannel', l.channel || 'INTRO'); set('lfCond', l.condmemo);
    set('lfNextDt', dIn(l.nextdt)); set('lfNextMemo', l.nextmemo); set('lfPlan', dIn(l.plandt)); set('lfAdmit', dIn(l.admitdt));
  }
  function fillAnbu(l){
    var row = FOLLOW.filter(function(r){ return r.birth6 === l.birth6 && String(r.ipdt) === String(d8(l.admitdt)); })[0];
    if (gel('lfFwRes')) gel('lfFwRes').value = row && row.resultcd ? row.resultcd : '';
    if (gel('lfFwMemo')) gel('lfFwMemo').value = row && row.memo ? row.memo : '';
  }

  /* ── 저장 · 단계 넘기기 ── */
  function checkForm(){
    var nm = String(fv('lfNm', CUR.patnm)).trim();
    if (!nm) { _alertBox('환자 이름을 적어 주세요.', {icon:'⚠️'}); if (gel('lfNm')) gel('lfNm').focus(); return false; }
    var b = String(fv('lfBirth', CUR.birth6)).replace(/[^0-9]/g, '');
    if (b && b.length !== 6) { _alertBox('생년월일은 6자리(YYMMDD)입니다.', {icon:'⚠️'}); if (gel('lfBirth')) gel('lfBirth').focus(); return false; }
    return true;
  }
  function leadPayload(stage){
    return withHosp({
      leadSeq: CUR && CUR.leadseq ? CUR.leadseq : '',
      patNm: String(fv('lfNm', CUR.patnm)).trim(), birth6: String(fv('lfBirth', CUR.birth6)).replace(/[^0-9]/g, ''),
      gender: fv('lfGender', CUR.gender), contactDt: d8(fv('lfContact', CUR.contactdt)),
      guardNm: fv('lfGuard', CUR.guardnm), guardRel: fv('lfRel', CUR.guardrel), tel: fv('lfTel', CUR.tel),
      channel: fv('lfChannel', CUR.channel || 'INTRO'), condMemo: fv('lfCond', CUR.condmemo),
      stage: stage, planDt: d8(fv('lfPlan', CUR.plandt)), nextDt: d8(fv('lfNextDt', CUR.nextdt)), nextMemo: fv('lfNextMemo', CUR.nextmemo),
      admitDt: d8(fv('lfAdmit', CUR.admitdt)), dischDt: CUR.dischdt || '', closeRsn: CUR.closersn || ''
    });
  }
  /* 저장하고 next 단계로 넘긴다. next 가 현재와 같으면 저장만. closeRsn 이 있으면 종결. */
  window.mlMove = function(next, closeRsn){
    if (!CUR || !checkForm()) return;
    var cur = CUR.stage || '10';
    /* 단계를 옮기면 이전 단계의 「다음 연락」 날짜와 내용은 지운다 (입원이 된 뒤에도 연락으로 남는 일을 막는다) */
    if (next !== cur) { if (gel('lfNextDt')) gel('lfNextDt').value = ''; if (gel('lfNextMemo')) gel('lfNextMemo').value = ''; }
    post(URL_SAVE, leadPayload(cur)).then(function(res){
      var id = res.leadSeq || CUR.leadseq;
      if (next === cur && !closeRsn) return id;
      var q = withHosp({ leadSeq: id, stage: next });
      if (closeRsn) { q.closeRsn = closeRsn; q.memo = '종결'; }
      return post(URL_STAGE, q).then(function(){ return id; });
    }).then(function(id){
      if (next !== cur) _toast('「' + stageNm(next) + '」 단계로 넘겼습니다.', 'ok');
      else _toast('저장했습니다.', 'ok');
      CUR = { leadseq: id };
      mlLoad();
    }).catch(err);
  };
  window.mlClose = function(){
    var rsn = gel('mlCloseSel') ? gel('mlCloseSel').value : '기타';
    _confirmBox({ msg: '<b>' + esc(CUR.patnm) + '</b> 상담을 종결합니다. 사유: ' + esc(rsn) + '<br>종결하면 달력에서 사라지고 종결 목록에 남습니다.', icon:'⚠️', okText:'종결', okColor:'#b23b3b',
      onOk: function(){ mlMove('90', rsn); } });
  };
  /* 칸 하나를 비우고 바로 저장한다. 아직 저장 전인 새 상담이면 칸만 비운다. */
  window.mlClearFields = function(ids){
    var any = false;
    ids.forEach(function(id){ var el = gel(id); if (el) { el.value = ''; any = true; } });
    if (!any || !CUR || !CUR.leadseq) return;
    mlMove(CUR.stage || '10');   /* 한 번만 저장한다 */
  };
  window.mlClearField = function(id){ mlClearFields([id]); };
  /* 이력 한 줄 삭제 — 상담 기록은 그대로 둔다 */
  window.mlLogDel = function(logSeq){
    if (!CUR || !CUR.leadseq) return;
    _confirmBox({ msg: '이 이력 한 줄을 지웁니다. 상담 기록은 그대로 남습니다.', icon:'🗑️', okText:'지우기', okColor:'#b23b3b',
      onOk: function(){ post(URL_LOGDEL, withHosp({ leadSeq: CUR.leadseq, logSeq: logSeq })).then(function(res){ paintLogs(res.logs || []); _toast('이력 한 줄을 지웠습니다.', 'ok'); }).catch(err); } });
  };
  /* 환자 기록 전체 삭제 — 이력까지 모두 지운다. 한 줄씩 지우려면 취소하고 칸의 ✕ 를 쓴다. */
  window.mlDel = function(){
    if (!CUR || !CUR.leadseq) return;
    _confirmBox({ msg: '<b>' + esc(CUR.patnm) + '</b> 환자의 상담 기록과 이력을 <b>모두</b> 지웁니다.<br>한 줄이나 한 칸만 지우려면 취소하고 해당 칸의 ✕ 를 누르세요. 되돌릴 수 없습니다.', icon:'🗑️', okText:'전부 지우기', okColor:'#b23b3b',
      onOk: function(){ post(URL_DEL, withHosp({ leadSeq: CUR.leadseq })).then(function(){ _toast('환자 기록을 지웠습니다.', 'ok'); CUR = null; mlLoad(); }).catch(err); } });
  };
  /* 재입원 상담 — 퇴원 환자의 기본 정보를 옮겨 새 상담(10 단계)을 연다. 기존 기록은 그대로 둔다. */
  window.mlReadmit = function(){
    if (!CUR) return;
    var memo = '재입원 희망 — 이전 입원 ' + (dLbl(CUR.admitdt) || '?') + ' ~ ' + (dLbl(CUR.dischdt) || '?');
    mlNewAt('10', { patnm:CUR.patnm, birth6:CUR.birth6, gender:CUR.gender, guardnm:CUR.guardnm, guardrel:CUR.guardrel, tel:CUR.tel, channel:CUR.channel || 'INTRO', condmemo:memo });
    _toast('재입원 상담 칸을 열었습니다. 연락 날짜를 정해 저장하세요.', 'ok');
  };
  window.mlFollowSave = function(){
    if (!CUR || !CUR.leadseq) return;
    if (!d8(CUR.dischdt)) { _alertBox('퇴원일이 아직 입퇴원현황에 없습니다. 퇴원이 올라오면 저장할 수 있습니다.', {icon:'⚠️'}); return; }
    var res = fv('lfFwRes', ''), done = res ? 'Y' : 'N';
    post(URL_FSAVE, withHosp({ birth6: CUR.birth6, ipwonDt: d8(CUR.admitdt), tewonDt: d8(CUR.dischdt), doneYn: done, resultCd: res, memo: fv('lfFwMemo', '') }))
      .then(function(){ _toast('안부 연락을 저장했습니다.', 'ok'); mlFollow(); }).catch(err);
  };

  /* ── 상세 이력 ── */
  function loadLogs(){
    post(URL_LOG, withHosp({ leadSeq: CUR.leadseq })).then(function(res){ paintLogs(res.logs || []); }).catch(function(){ if (gel('mlLogs')) gel('mlLogs').innerHTML = ''; });
  }
  function paintLogs(logs){
    if (!gel('mlLogs')) return;
    gel('mlLogs').innerHTML = logs.length ? logs.map(function(g){ return '<div><span class="d">' + dLbl(g.logdt) + '</span><span class="badge">' + esc(stageNm(g.stage)) + '</span> ' + esc(g.memo) + ' <span class="small">' + esc(g.reguser || '') + '</span>' +
      ' <button type="button" class="ml-btn sm" style="color:#b23b3b;padding:0 6px;" onclick="mlLogDel(' + Number(g.logseq) + ');" title="이 이력 한 줄만 지웁니다">✕</button></div>'; }).join('') : '<div class="small">아직 이력이 없습니다.</div>';
  }
  window.mlLogAdd = function(){
    if (!CUR || !CUR.leadseq) { _alertBox('먼저 상담을 저장해 주세요.', {icon:'⚠️'}); return; }
    var m = String(gel('lfLogMemo').value || '').trim(); if (!m) return;
    post(URL_LOG, withHosp({ leadSeq: CUR.leadseq, memo: m })).then(function(res){ gel('lfLogMemo').value = ''; paintLogs(res.logs || []); }).catch(err);
  };

  /* ── 달력 · 선택 · 필터 ── */
  window.mlMonth = function(n){
    VM += n; if (VM < 1) { VM = 12; VY--; } if (VM > 12) { VM = 1; VY++; }
    renderCal();
  };
  window.mlToday = function(){ var p = parts(TODAY); VY = p.y; VM = p.m; SELDAY = TODAY; renderCal(); renderAgenda(); };
  window.mlDay = function(k){ SELDAY = k; renderCal(); renderAgenda(); };
  window.mlFilter = function(s){ FILTER = s; renderChips(); renderCal(); renderAgenda(); };
  window.mlSearch = function(){ renderAgenda(); };
  window.mlPick = function(seq){
    var l = findLead(seq); if (!l) return;
    CUR = l; renderAgenda(); renderWork();
    try { gel('mlWork').scrollIntoView({ behavior:'smooth', block:'start' }); } catch(e){}
  };
  /* 새 상담 접수 — prefill 로 날짜·보호자 등을 미리 채울 수 있다(재입원·달력 날짜 접수) */
  window.mlNewAt = function(stage, prefill){
    stage = String(stage || '10'); if (stageIdx(stage) < 0) stage = '10';
    CUR = Object.assign({ leadseq:'', stage:stage, channel:'INTRO', contactdt:TODAY }, prefill || {});
    CUR.leadseq = ''; CUR.stage = stage;
    renderAgenda(); renderWork();
    try { gel('mlWork').scrollIntoView({ behavior:'smooth', block:'start' }); gel('lfNm').focus(); } catch(e){}
  };

  /* ── 도움말 열고 닫기 ── */
  window.mlHelp = function(){
    var box = gel('mlHelp'), open = box.hasAttribute('hidden');
    if (open) box.removeAttribute('hidden'); else box.setAttribute('hidden', '');
    if (open) { try { box.scrollIntoView({ behavior:'smooth', block:'start' }); } catch(e){} }
  };

  /* ── 탭 ── */
  window.mlTab = function(t){
    var tabs = document.querySelectorAll('#misLead .ml-tab');
    for (var i = 0; i < tabs.length; i++) tabs[i].classList.toggle('on', tabs[i].getAttribute('data-tab') === t);
    gel('mlPaneCal').hidden = t !== 'cal'; gel('mlPaneFollow').hidden = t !== 'follow'; gel('mlPaneStat').hidden = t !== 'stat';
    if (t === 'follow') mlFollow();
    if (t === 'stat') mlStats();
  };

  /* ── 불러오기 ── */
  window.mlLoad = function(done){
    post(URL_LIST, withHosp({})).then(function(res){
      D = res; TODAY = res.today || TODAY;
      if (!VY) { var p = parts(TODAY); VY = p.y; VM = p.m; }
      if (!SELDAY) SELDAY = TODAY;
      if (CUR && CUR.leadseq) CUR = findLead(CUR.leadseq);
      renderChips(); renderCal(); renderAgenda(); renderWork();
      mlStats();
      if (done) done(res);
    }).catch(function(e){ gel('mlCal').innerHTML = '<div class="ml-empty">' + esc((e && e.message) || '불러오지 못했습니다.') + '</div>'; });
    mlFollow();
  };
  /* 입퇴원현황과 다시 대조 — 단계가 바뀐 환자 수를 알려 준다 (아무 반응이 없던 것을 막는다) */
  window.mlReconcile = function(){
    var before = {};
    leads().forEach(function(l){ before[l.leadseq] = l.stage + '|' + (l.matchyn || '') + '|' + (l.admitdt || '') + '|' + (l.dischdt || ''); });
    mlLoad(function(res){
      var changed = 0;
      (res.leads || []).forEach(function(l){
        var was = before[l.leadseq];
        if (was !== undefined && was !== (l.stage + '|' + (l.matchyn || '') + '|' + (l.admitdt || '') + '|' + (l.dischdt || ''))) changed++;
      });
      var cnt = {};
      (res.leads || []).forEach(function(l){ cnt[l.stage] = (cnt[l.stage] || 0) + 1; });
      _alertBox(changed ? '대조 완료 · 단계나 입퇴원 날짜가 바뀐 환자 ' + changed + '명 (입원 ' + (cnt['40'] || 0) + ' · 퇴원 후 ' + (cnt['50'] || 0) + ')' : '대조 완료 · 바뀐 환자는 없습니다 (입원 ' + (cnt['40'] || 0) + ' · 퇴원 후 ' + (cnt['50'] || 0) + ')', {icon:'🔄'});
    });
  };

  /* ── 유입 경로 분석 ── */
  window.mlStats = function(){
    if (!D) return;
    var rng = $('input[name="mlStatRng"]:checked').val(), rows = (rng === 'q' ? D.stats3 : D.stats) || [];
    var map = {}; rows.forEach(function(r){ map[r.channel] = r; });
    var h = '<thead><tr><th>유입 경로</th><th class="n">상담</th><th class="n">입원</th><th class="n">전환율</th></tr></thead><tbody>', tl = 0, ta = 0;
    Object.keys(CH).forEach(function(k){ var r = map[k], l = r ? Number(r.leads) : 0, a = r ? Number(r.admits) : 0; tl += l; ta += a; h += '<tr><td>' + CH[k] + '</td><td class="n">' + l + '</td><td class="n">' + a + '</td><td class="n">' + (l ? Math.round(a/l*100) + '%' : '—') + '</td></tr>'; });
    h += '<tr><td><b>합계</b></td><td class="n"><b>' + tl + '</b></td><td class="n"><b>' + ta + '</b></td><td class="n"><b>' + (tl ? Math.round(ta/tl*100) + '%' : '—') + '</b></td></tr></tbody>';
    gel('mlStat').innerHTML = h;
  };

  /* ── 퇴원 안부 연락 ── */
  window.mlFollow = function(){
    post(URL_FOLLOW, withHosp({ days: gel('mlFollowDays').value })).then(function(res){
      var list = res.list || [], today = res.today, h = '<thead><tr><th class="n" style="width:42px">No</th><th>퇴원일</th><th>환자</th><th class="n">재원일수</th><th>퇴원 후 경과</th><th>연락</th><th>결과</th><th>메모</th></tr></thead><tbody>';
      FOLLOW = list;
      list.forEach(function(r, i){
        var dd = daysBetween(r.twdt, today), done = r.doneyn === 'Y';
        var key = 'birth6=' + esc(r.birth6) + '&ipwonDt=' + esc(r.ipdt) + '&tewonDt=' + esc(r.twdt);
        h += '<tr class="' + (done ? 'done' : '') + '" data-key="' + key + '"><td class="n small">' + (i + 1) + '</td><td>' + dLbl(r.twdt) + '</td><td><b>' + esc(r.patnm) + '</b> <span class="small">' + esc(r.birth6) + '</span>' + (r.readmitdt ? ' <span class="badge ok">' + dMD(r.readmitdt) + ' 재입원</span>' : '')
           + (r.guardtel || r.tel ? '<br><span class="small" title="병원자료엑셀연계로 올린 연락처">📞 ' + (r.guardtel ? esc((r.guardnm || '보호자') + (r.guardrel ? '(' + r.guardrel + ')' : '')) + ' ' + esc(r.guardtel) : '환자 ' + esc(r.tel)) + '</span>' : '') + '</td>'
           + '<td class="n">' + esc(r.staydays) + '일</td><td>' + (dd >= 7 && !done && !r.readmitdt ? '<span class="badge warn">' + dd + '일째 · 연락</span>' : dd + '일') + '</td>'
           + '<td><label><input type="checkbox" class="fwDone"' + (done ? ' checked' : '') + '> ' + (done && r.donedt ? dLbl(r.donedt) : '함') + '</label></td>'
           + '<td><select class="fwRes"><option value="">—</option>' + RESULTS.map(function(x){ return '<option value="' + x[0] + '"' + (r.resultcd === x[0] ? ' selected' : '') + '>' + x[1] + '</option>'; }).join('') + '</select></td>'
           + '<td class="memo"><input type="text" class="fwMemo" maxlength="300" value="' + esc(r.memo || '') + '" style="width:100%;min-width:120px;"></td></tr>';
      });
      if (!list.length) h += '<tr><td colspan="8" class="ml-empty">최근 ' + esc(res.days) + '일 안에 퇴원한 환자가 없습니다(입퇴원현황 기준).</td></tr>';
      gel('mlFollow').innerHTML = h + '</tbody>';
      $('#mlFollow .fwDone, #mlFollow .fwRes').on('change', function(){ fwSave(this.closest('tr')); });
      $('#mlFollow .fwMemo').on('change', function(){ fwSave(this.closest('tr')); });
    }).catch(function(e){ gel('mlFollow').innerHTML = '<tbody><tr><td class="ml-empty">' + esc((e && e.message) || '불러오지 못했습니다.') + '</td></tr></tbody>'; });
  };
  function fwSave(tr){
    var q = {}; tr.getAttribute('data-key').split('&').forEach(function(kv){ var a = kv.split('='); q[a[0]] = decodeURIComponent(a[1] || ''); });
    var done = tr.querySelector('.fwDone').checked, res = tr.querySelector('.fwRes').value, memo = tr.querySelector('.fwMemo').value;
    if (res && !done) { tr.querySelector('.fwDone').checked = true; done = true; }
    post(URL_FSAVE, withHosp({ birth6: q.birth6, ipwonDt: q.ipwonDt, tewonDt: q.tewonDt, doneYn: done ? 'Y' : 'N', resultCd: res, memo: memo }))
      .then(function(){ tr.className = done ? 'done' : ''; if (res === 'READMIT') _toast('재입원 희망 — 달력에서 그 환자를 찾아 재입원 상담을 여세요.', 'ok'); }).catch(err);
  }

  /* ── 예상 비용 안내 · 음성 입력 · AI 정리 ── */
  var CLS_NM = { A:'A군 (의료최고도)', B:'B군 (의료고도)', C:'C군 (의료중도)', D:'D군 (의료경도)', E:'E군 (선택입원)' };
  function won(v){ return Math.round(Number(v || 0)).toLocaleString('ko-KR') + '원'; }
  function manWon(v){ return Math.round(Number(v || 0) / 10000).toLocaleString('ko-KR') + '만원'; }
  function ymL(ym){ return ym ? Number(String(ym).slice(0, 4)) + '년 ' + Number(String(ym).slice(4, 6)) + '월' : ''; }
  window.mlCostInit = function(){
    if (COST || COST_REQ) { mlCostFill(); return; }
    COST_REQ = true;
    post(URL_COST, withHosp({})).then(function(res){ COST = res; mlCostFill(); }).catch(function(e){ COST = { ok:false, reason:(e && e.message) || '불러오지 못했습니다.' }; mlCostFill(); });
  };
  window.mlCostFill = function(){
    var b = gel('mlCostBody'); if (!b || !COST) return;
    var rows = COST.rows || [];
    if (!COST.ok || !rows.length) { b.innerHTML = '<div class="small">' + esc(COST.reason || '자료가 없습니다.') + '</div>'; return; }
    var sel = gel('mlCostCls'), cur = sel ? sel.value : '', days = gel('mlCostDays') ? gel('mlCostDays').value : 30;
    var opts = rows.map(function(r){ return '<option value="' + esc(r.cls) + '">' + esc(CLS_NM[r.cls] || r.cls) + ' — 1일 ' + won(r.perday) + '</option>'; }).join('');
    b.innerHTML = '<div class="ml-cost-row"><label>환자군</label><select id="mlCostCls" onchange="mlCostCalc();">' + opts + '</select>' +
      '<label>입원일수</label><input type="number" id="mlCostDays" min="1" max="365" value="' + esc(days) + '" oninput="mlCostCalc();" style="width:70px;">' +
      '<span class="small">기준 ' + esc(ymL(COST.fromYm)) + ' ~ ' + esc(ymL(COST.toYm)) + ' 청구</span></div>' +
      '<div id="mlCostOut"></div>' +
      '<textarea id="mlCostTxt" readonly style="min-height:78px;margin-top:6px;font-size:12.5px;"></textarea>' +
      '<div style="display:flex;gap:6px;margin-top:4px;flex-wrap:wrap;"><button type="button" class="ml-btn" onclick="mlCostCopy();">🔗 안내문 복사</button><button type="button" class="ml-btn" onclick="mlCostToLog();">이력에 기록</button><span class="small">보호자에게 문자·카톡으로 바로 보낼 수 있는 글</span></div>';
    var s2 = gel('mlCostCls');
    if (cur && rows.some(function(r){ return r.cls === cur; })) s2.value = cur; else if (rows.some(function(r){ return r.cls === 'C'; })) s2.value = 'C';
    mlCostCalc();
  };
  window.mlCostCalc = function(){
    var rows = (COST && COST.rows) || [], cls = gel('mlCostCls').value, d = Math.max(1, Math.min(365, Number(gel('mlCostDays').value || 30)));
    var r = rows.filter(function(x){ return x.cls === cls; })[0]; if (!r) return;
    var tot = Number(r.perday) * d, self = Number(r.selfday) * d, pub = Number(r.claimday) * d;
    gel('mlCostOut').innerHTML = '<table class="ml-cost-tbl"><tr><th></th><th>1일</th><th>' + d + '일</th></tr>' +
      '<tr><td>총진료비</td><td>' + won(r.perday) + '</td><td><b>' + won(tot) + '</b></td></tr>' +
      '<tr><td>본인부담(급여)</td><td>' + won(r.selfday) + '</td><td><b>' + won(self) + '</b></td></tr>' +
      '<tr><td>공단부담</td><td>' + won(r.claimday) + '</td><td>' + won(pub) + '</td></tr></table>' +
      '<div class="small">본원 ' + esc(CLS_NM[cls] || cls) + ' 환자 ' + esc(String(r.pats)) + '명 · 입원일수 ' + Number(r.admdays).toLocaleString('ko-KR') + '일 평균. 비급여(상급병실·간병비·식대 일부 등)는 청구에 없어 별도.</div>';
    gel('mlCostTxt').value = '[' + (root.getAttribute('data-nm') || '') + '] 입원 비용 안내 (최근 청구 기준 · ' + (CLS_NM[cls] || cls) + ')\n' +
      '· 1일 진료비 약 ' + manWon(r.perday) + ' (본인부담 약 ' + manWon(r.selfday) + ')\n' +
      '· ' + d + '일 기준 총 약 ' + manWon(tot) + ', 본인부담 약 ' + manWon(self) + '\n' +
      '· 환자군은 입원 후 환자평가표로 정해지며, 비급여(상급병실·간병비 등)는 별도입니다. 실제 금액은 상태에 따라 달라질 수 있습니다.';
  };
  window.mlCostCopy = function(){
    var ta = gel('mlCostTxt'), t = ta ? ta.value : ''; if (!t) return;
    function done(){ _toast('안내문을 복사했습니다. 문자·카톡에 붙여 넣으세요.', 'ok'); }
    function fb(){ ta.select(); try { document.execCommand('copy'); done(); } catch(e){ _alertBox('복사하지 못했습니다.', {icon:'❌'}); } }
    if (navigator.clipboard && navigator.clipboard.writeText) navigator.clipboard.writeText(t).then(done, fb); else fb();
  };
  window.mlCostToLog = function(){
    if (!CUR || !CUR.leadseq) { _alertBox('먼저 상담을 저장해 주세요.', {icon:'⚠️'}); return; }
    var cls = gel('mlCostCls').value, d = Number(gel('mlCostDays').value || 30), rows = (COST && COST.rows) || [], r = rows.filter(function(x){ return x.cls === cls; })[0]; if (!r) return;
    var m = '비용 안내 — ' + (CLS_NM[cls] || cls) + ' 기준 1일 약 ' + manWon(r.perday) + '(본인부담 ' + manWon(r.selfday) + '), ' + d + '일 약 ' + manWon(Number(r.perday) * d);
    post(URL_LOG, withHosp({ leadSeq: CUR.leadseq, memo: m })).then(function(res){ paintLogs(res.logs || []); _toast('이력에 적었습니다.', 'ok'); }).catch(err);
  };
  /* 음성 입력 — 브라우저 Web Speech(크롬·엣지). 녹음 파일은 남기지 않고 글자로만 바꾼다. 한 번 더 누르면 멈춘다. */
  var REC = null, REC_BTN = null;
  window.mlVoice = function(targetId, btn){
    var SR = window.SpeechRecognition || window.webkitSpeechRecognition;
    if (!SR) { _alertBox('이 브라우저는 음성 입력을 지원하지 않습니다. 크롬·엣지에서 쓰세요.', {icon:'🎤'}); return; }
    if (REC) { try { REC.stop(); } catch(e){} return; }
    var el = gel(targetId), base = String(el.value || '').trim(), rec = new SR();
    rec.lang = 'ko-KR'; rec.interimResults = true; rec.continuous = true;
    rec.onresult = function(ev){ var fin = '', tmp = ''; for (var i = 0; i < ev.results.length; i++) { if (ev.results[i].isFinal) fin += ev.results[i][0].transcript; else tmp += ev.results[i][0].transcript; } el.value = (base ? base + ' ' : '') + fin + (tmp ? ' ' + tmp : ''); };
    rec.onerror = function(ev){ if (ev.error === 'not-allowed' || ev.error === 'service-not-allowed') _alertBox('마이크 사용이 막혀 있습니다. 주소창의 마이크 권한을 허용해 주세요.', {icon:'🎤'}); };
    rec.onend = function(){ REC = null; if (REC_BTN) { REC_BTN.classList.remove('rec'); REC_BTN.textContent = '🎤 음성'; REC_BTN = null; } el.value = String(el.value || '').replace(/\s+$/, ''); };
    REC = rec; REC_BTN = btn; btn.classList.add('rec'); btn.textContent = '⏹ 멈춤';
    try { rec.start(); } catch(e){ rec.onend(); }
  };
  /* AI 정리 — 이력은 기록체 한두 문장, 상태·요구는 세 줄로. 실패하면 원문 그대로, 성공해도 [↩ 원문]으로 되돌릴 수 있다. */
  window.mlAi = function(kind, btn){
    var id = kind === 'cond' ? 'lfCond' : 'lfLogMemo', el = gel(id), t = String(el.value || '').trim();
    if (t.length < 5) { _alertBox('정리할 글을 먼저 적거나 🎤 음성으로 말해 주세요.', {icon:'✨'}); return; }
    var old = btn.textContent; btn.disabled = true; btn.textContent = '정리 중…';
    post(URL_AI, withHosp({ kind: kind, text: t })).then(function(res){
      if (res && res.ok && res.text) {
        el.value = res.text; _toast('AI 가 정리했습니다. 되돌리려면 [↩ 원문].', 'ok');
        btn.textContent = '↩ 원문'; btn.onclick = function(){ el.value = t; btn.textContent = old; btn.onclick = function(){ mlAi(kind, btn); }; };
      } else { _alertBox((res && res.reason) || 'AI 정리를 받지 못했습니다. 적은 글은 그대로 있습니다.', {icon:'✨'}); btn.textContent = old; }
    }).catch(function(e){ err(e); btn.textContent = old; }).always(function(){ btn.disabled = false; });
  };

  /* ── 엑셀 — 매출장 양식: 가운데 큰 제목 · 조회 정보 줄 · 연한 파랑 머리글 · 모든 칸 얇은 테두리 (스타일 지원 xlsx-style) ── */
  window.mlExcel = function(){
    var XS = window.XLSXS;
    if (!XS || !XS.utils || !XS.utils.encode_cell) { _alertBox('엑셀 모듈을 아직 불러오지 못했습니다. 잠시 뒤 다시 눌러 주세요.', {icon:'⏳'}); return; }
    try {
      var head = ['단계','환자','생년월일','성별','보호자','관계','연락처','상담일','유입 경로','상태·요구','다음 할 일','내용','방문·입원 예정','입원일','퇴원일','입퇴원현황 확인','종결 사유'];
      var widths = [70,80,70,44,70,56,100,74,80,220,74,170,90,74,74,70,120];
      var span = head.length, d = new Date(), ymd = d.getFullYear() + '-' + pad(d.getMonth()+1) + '-' + pad(d.getDate());
      var line = { style: 'thin', color: { rgb: '000000' } };
      var box = { top: line, bottom: line, left: line, right: line };
      var sTitle = { font: { bold: true, sz: 16 }, alignment: { horizontal: 'center', vertical: 'center' } };
      var sMeta = { font: { sz: 10 }, alignment: { horizontal: 'left', vertical: 'center' } };
      var sSection = { font: { bold: true, sz: 12 }, alignment: { horizontal: 'left', vertical: 'center' } };
      var sHead = { font: { bold: true, sz: 10 }, fill: { patternType: 'solid', fgColor: { rgb: 'DDEBF7' } }, border: box,
                    alignment: { horizontal: 'center', vertical: 'center', wrapText: true } };
      var sBody = { font: { sz: 10 }, border: box, alignment: { vertical: 'center' } };
      function cell(v, s){ return { v: (v == null ? '' : String(v)), t: 's', s: s }; }
      function blankRow(){ var r = []; for (var i = 0; i < span; i++) r.push(cell('', null)); return r; }
      function titleRow(text, s){ var r = blankRow(); r[0] = cell(text, s); return r; }

      var aoa = [], merges = [];
      aoa.push(titleRow('[신규환자 고객관리 목록]', sTitle)); merges.push({ s: { r: 0, c: 0 }, e: { r: 0, c: span - 1 } });
      aoa.push(titleRow('출력일 : ' + ymd + ' · 상담 전체(종결 포함) · ' + (root.getAttribute('data-nm') || ''), sMeta)); merges.push({ s: { r: 1, c: 0 }, e: { r: 1, c: span - 1 } });
      aoa.push(blankRow());
      aoa.push(head.map(function(h){ return cell(h, sHead); }));
      leads().forEach(function(l){
        var vals = [stageNm(l.stage), l.patnm||'', l.birth6||'', l.gender==='M'?'남':l.gender==='F'?'여':'', l.guardnm||'', l.guardrel||'', l.tel||'',
                    dLbl(l.contactdt), CH[l.channel]||l.channel||'', l.condmemo||'', dLbl(l.nextdt), l.nextmemo||'', dLbl(l.plandt),
                    dLbl(l.admitdt), dLbl(l.dischdt), l.matchyn==='Y'?'Y':'', l.closersn||''];
        aoa.push(vals.map(function(v){ return cell(v, sBody); }));
      });
      aoa.push(blankRow());
      aoa.push(titleRow('[퇴원 환자 안부 연락]', sSection)); merges.push({ s: { r: aoa.length - 1, c: 0 }, e: { r: aoa.length - 1, c: span - 1 } });
      Array.prototype.forEach.call((gel('mlFollow') ? gel('mlFollow').querySelectorAll('tr') : []), function(tr){
        var cells = Array.prototype.map.call(tr.children, function(c){ return c.textContent.replace(/\s+/g, ' ').trim(); });
        if (!cells.length) return;
        var isHead = !!tr.querySelector('th');
        aoa.push(cells.map(function(v){ return cell(v, isHead ? sHead : sBody); }));
      });

      var ws = XS.utils.aoa_to_sheet(aoa);
      ws['!cols'] = widths.map(function(w){ return { wch: Math.round(w / 7) }; });
      ws['!merges'] = merges;
      ws['!rows'] = [{ hpt: 30 }, { hpt: 18 }, { hpt: 8 }, { hpt: 30 }];
      var wb = XS.utils.book_new();
      XS.utils.book_append_sheet(wb, ws, '신규환자');
      var nm = (root.getAttribute('data-nm') || '').replace(/[\\\/:*?"<>|]/g, '_');
      XS.writeFile(wb, '신규환자_' + nm + '_' + d.getFullYear() + pad(d.getMonth()+1) + pad(d.getDate()) + '.xlsx');
    } catch(e){ err(e); }
  };

  /* 달력 칸 클릭은 일정 목록을 바꾼다. 오른쪽 목록의 환자 클릭은 작업 칸을 연다. */
  $(function(){ mlLoad(); });
})();
</script>
</div><%-- /#misLead --%>
</div>
