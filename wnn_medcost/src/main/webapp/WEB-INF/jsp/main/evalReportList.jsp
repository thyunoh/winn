<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%-- evalReportList.jsp — 적정성평가 월간 컨설팅 보고서 '목록' 화면.
     · 앱 표준 그리드(DataTables 2.1.8 + Buttons: 복사/엑셀/출력)로 통일 — header.jsp 전역 로드.
     · 상단 도메인 필터(평가년도=서버조회 / 평가월·병원·상태·첨부=클라 필터) → 결과를 DataTable 에 주입.
     · 검색(자료검색)·정렬·페이징·복사/엑셀/출력은 DataTables 담당. 행 더블클릭 → 해당 병원·월 보고서.
     · 주의: 이 파일 안에서 Deferred EL 표기(샵 + 중괄호) 금지 — 변환에러로 빈 화면(content 타일) 유발 --%>

<%-- 알림·확인 공통 컴포넌트(_alertBox/_confirmBox) — konet_vsweb 로그인 화면과 같은 모양(작은 창 + 넓은 파란 버튼).
     CSS·DOM 을 스스로 주입하므로 이 한 줄이면 된다. --%>
<script src="/asset/js/ui-message.js"></script>

<div id="evalReportList">
<style>
  /* 글꼴은 앱 기본(body)을 상속 — 다른 화면 그리드와 통일 */
  #evalReportList{ background:#f4f6f8; color:#1f2a30; min-height:100%; padding:14px 16px 50px; font-family:inherit; }
  #evalReportList table.dataTable, #evalReportList .erl-search, #evalReportList select.erl-sel{ font-family:inherit; }
  #evalReportList *{ box-sizing:border-box; }

  /* 헤더 */
  #evalReportList .erl-head{ display:flex; align-items:center; gap:10px; margin-bottom:12px; }
  #evalReportList .erl-title{ font-size:18px; font-weight:800; color:#20303a; display:flex; align-items:center; gap:8px; }
  #evalReportList .erl-title .erl-dot{ width:10px; height:10px; border-radius:50%; background:linear-gradient(135deg,#1f5a4b,#2a7665); }
  #evalReportList .erl-role{ font-size:11px; font-weight:700; color:#fff; background:linear-gradient(135deg,#1f5a4b,#2a7665); padding:3px 9px; border-radius:20px; }

  /* 검색 바 (도메인 필터) */
  #evalReportList .erl-search{ display:flex; flex-wrap:wrap; align-items:center; gap:8px; padding:10px 12px; background:#fff;
    border:1px solid #e2e7ea; border-left:4px solid #2a7665; border-radius:8px; box-shadow:0 2px 6px rgba(16,22,29,.05); margin-bottom:12px; }
  #evalReportList .erl-search label{ font-size:12.5px; font-weight:800; color:#54636c; }
  #evalReportList select.erl-sel{ font-family:inherit; font-size:13px; padding:6px 8px; border:1px solid #d5dbdf; border-radius:6px; background:#fff; color:#1f2a30; font-weight:700; }
  #evalReportList select.erl-sel:hover{ border-color:#2a7665; }
  #evalReportList select.erl-hosp{ min-width:220px; }
  #evalReportList .erl-btn{ font-family:inherit; font-size:13px; font-weight:800; cursor:pointer; padding:7px 14px; border-radius:6px;
    border:1px solid transparent; background:#2a7665; color:#fff; }
  #evalReportList .erl-btn:hover{ background:#1f5a4b; }

  /* 그리드 내 뱃지/셀 */
  #evalReportList .erl-grade{ display:inline-block; font-size:11px; font-weight:800; color:#fff; padding:1px 7px; border-radius:12px; margin-left:3px;
    background:linear-gradient(135deg,#1f5a4b,#2a7665); }
  #evalReportList .erl-hospnm{ font-weight:800; color:#1f5a4b; }
  #evalReportList .erl-total{ font-weight:800; color:#1f7a66; }
  #evalReportList .erl-st{ display:inline-flex; align-items:center; gap:5px; font-size:11.5px; font-weight:800; padding:3px 9px; border-radius:14px; border:1px solid transparent; }
  #evalReportList .erl-st .erl-sd{ width:7px; height:7px; border-radius:50%; }
  #evalReportList .erl-st.erl-draft{ background:#fbf3e2; color:#b7791f; border-color:#ead9b0; }
  #evalReportList .erl-st.erl-draft .erl-sd{ background:#b7791f; }
  #evalReportList .erl-st.erl-appr{ background:#eaf5ec; color:#2e7d32; border-color:#bfe0c4; }
  #evalReportList .erl-st.erl-appr .erl-sd{ background:#2e7d32; }
  #evalReportList .erl-pdf{ font-weight:800; color:#2e7d32; }
  /* 메일발송 / 열람 현황 (위너넷 화면 전용 컬럼) */
  #evalReportList .erl-mailbtn{ font-family:inherit; font-size:12px; font-weight:800; cursor:pointer; padding:3px 9px;
    border-radius:6px; border:1px solid #1e3c72; background:#1e3c72; color:#fff; line-height:1.5; white-space:nowrap; }
  #evalReportList .erl-mailbtn:hover{ background:#16305e; }
  #evalReportList .erl-sentinfo{ margin-top:2px; font-size:11px; color:#6b7a89; white-space:nowrap; }
  #evalReportList .erl-nosend{ margin-top:2px; font-size:11px; color:#9aa7b3; white-space:nowrap; }
  /* 관리자 전용 도움말 */
  #evalReportList .erl-help{ font-family:inherit; font-size:12.5px; font-weight:800; cursor:pointer; padding:6px 12px;
    border-radius:6px; border:1px solid #d5dbdf; background:#fff; color:#54636c; }
  #evalReportList .erl-help:hover{ border-color:#2a7665; color:#2a7665; background:#f2f8f6; }
  .erl-guide{ text-align:left; font-size:13px; line-height:1.75; color:#37475a; }
  .erl-guide h4{ margin:14px 0 6px; font-size:13.5px; color:#1f5a4b; }
  .erl-guide h4:first-child{ margin-top:0; }
  .erl-guide ol{ margin:0; padding-left:18px; }
  .erl-guide code{ background:#f3f6f9; border:1px solid #e2e8ef; border-radius:4px; padding:1px 5px; font-size:12px; }
  .erl-guide .warn{ margin-top:10px; padding:8px 10px; background:#fdf6e3; border:1px solid #ecd9a8; border-radius:6px; font-size:12.5px; color:#8a5a00; }
  /* 개발자용 상세 — 기본은 접힘 */
  .erl-guide details.erl-dev{ margin:14px 0 6px; border:1px solid #e2e8ef; border-radius:6px; background:#fafcfe; padding:8px 10px; }
  .erl-guide details.erl-dev > summary{ cursor:pointer; font-size:13.5px; font-weight:800; color:#1f5a4b; list-style:none; }
  .erl-guide details.erl-dev > summary::-webkit-details-marker{ display:none; }
  .erl-guide details.erl-dev > summary::before{ content:'▸ '; color:#7b8a99; }
  .erl-guide details.erl-dev[open] > summary::before{ content:'▾ '; }
  .erl-guide details.erl-dev > summary span{ font-weight:600; font-size:12px; color:#8a97a4; }
  .erl-guide details.erl-dev[open]{ background:#fff; }
  .erl-guide details.erl-dev > *:not(summary){ margin-top:8px; }
  #evalReportList .erl-read{ font-weight:800; color:#2e7d32; }
  #evalReportList .erl-noread{ color:#9aa7b3; }
  /* 발송 창 */
  #erl-mailModal{ position:fixed; inset:0; z-index:1400; background:rgba(16,22,29,.55); display:none; align-items:center; justify-content:center; padding:20px; }
  #erl-mailModal .erl-mbox{ width:min(720px,96vw); max-height:92vh; background:#fff; border-radius:12px; box-shadow:0 14px 46px rgba(0,0,0,.38); display:flex; flex-direction:column; overflow:hidden; }
  /* 글자 크기 — 발송창은 담당자가 읽고 고치는 화면이라 목록보다 한 단계 크게(2026-07-29 요청) */
  #erl-mailModal .erl-mhead{ display:flex; align-items:center; justify-content:space-between; gap:10px; padding:14px 18px;
    background:#eef4fb; border-bottom:1px solid #d7e2f0; font-weight:800; color:#1e3c72; font-size:17px; }
  #erl-mailModal .erl-mbody{ padding:14px 18px; overflow:auto; font-size:14px; }
  /* 라벨은 안내용이라 작게, 입력 내용(실제 보낼 문장)은 진하게 — 시선이 내용으로 가게(2026-07-29 요청) */
  #erl-mailModal label{ display:block; font-size:13.5px; font-weight:800; color:#5b6b80; margin:12px 0 4px; }
  #erl-mailModal input[type=text], #erl-mailModal textarea{ width:100%; padding:7px 10px; font-size:15px; border:1px solid #cfd8e6; border-radius:6px; font-family:inherit; }
  #erl-mailModal textarea{ line-height:1.75; resize:vertical; }
  /* 제목·내용 = 실제 보낼 문장. 크기는 작게 두되 색·굵기를 올려 또렷하게 */
  /* ★ 아래 세 줄은 위의 '#erl-mailModal input[type=text] / textarea' 규칙(우선순위가 더 높음)을 이겨야 하므로
       반드시 #erl-mailModal 을 앞에 붙여 쓸 것. id 만 쓰면(#erl-mailSubject) 무시된다(2026-07-29 실제 발생). */
  #erl-mailModal #erl-mailTo{ font-size:13px; color:#1b2733; font-weight:600; }
  #erl-mailModal #erl-mailSubject{ font-size:13px; color:#1b2733; font-weight:600; }
  #erl-mailModal #erl-mailBody{ font-size:13px; color:#1b2733; font-weight:600; min-height:250px; line-height:1.7; }
  /* 주소록(설정 영역)과 그 아래 '실제 보낼 내용' 을 시각적으로 분리 */
  #erl-mailModal .erl-msect{ margin-top:12px; padding:10px 12px 12px; background:#f5f8fc;
    border:1px solid #dde6f0; border-radius:8px; }
  /* 구분선 — 가운데 '보낼 내용' 글자를 얹은 선. 위(설정)와 아래(발송 내용)를 확실히 가른다 */
  #erl-mailModal .erl-mdiv{ display:flex; align-items:center; gap:10px; margin:20px 0 4px; }
  #erl-mailModal .erl-mdiv::before, #erl-mailModal .erl-mdiv::after{ content:''; flex:1 1 auto; height:2px; background:#c9d6e5; }
  #erl-mailModal .erl-mdiv span{ flex:0 0 auto; font-size:12.5px; font-weight:800; color:#1e3c72;
    background:#eef4fb; border:1px solid #c9d6e5; border-radius:999px; padding:2px 12px; }
  #erl-mailModal .erl-mdiv + label{ margin-top:8px; }
  #erl-mailModal .erl-msect .erl-addrbox{ background:#fff; }
  /* 일괄등록 창 — 발송창과 같은 모달 스타일을 그대로 쓴다 */
  #erl-bulkModal{ position:fixed; inset:0; z-index:1400; background:rgba(16,22,29,.55); display:none; align-items:center; justify-content:center; padding:20px; }
  #erl-bulkModal .erl-mbox{ max-height:92vh; background:#fff; border-radius:12px; box-shadow:0 14px 46px rgba(0,0,0,.38); display:flex; flex-direction:column; overflow:hidden; }
  #erl-bulkModal .erl-mhead{ display:flex; align-items:center; justify-content:space-between; gap:10px; padding:14px 18px;
    background:#eef4fb; border-bottom:1px solid #d7e2f0; font-weight:800; color:#1e3c72; font-size:17px; }
  #erl-bulkModal .erl-mbody{ padding:14px 18px; overflow:auto; font-size:14px; }
  #erl-bulkModal label{ display:block; font-size:13.5px; font-weight:800; color:#5b6b80; margin:12px 0 4px; }
  #erl-bulkModal input[type=text], #erl-bulkModal textarea{ width:100%; padding:7px 10px; font-size:13px; border:1px solid #cfd8e6; border-radius:6px; font-family:inherit; }
  #erl-bulkModal textarea{ line-height:1.6; resize:vertical; }
  #erl-bulkModal .erl-msect{ margin-top:8px; padding:10px 12px 12px; background:#f5f8fc; border:1px solid #dde6f0; border-radius:8px; }
  #erl-bulkModal .erl-mdiv{ display:flex; align-items:center; gap:10px; margin:18px 0 6px; }
  #erl-bulkModal .erl-mdiv::before, #erl-bulkModal .erl-mdiv::after{ content:''; flex:1 1 auto; height:2px; background:#c9d6e5; }
  #erl-bulkModal .erl-mdiv span{ flex:0 0 auto; font-size:12.5px; font-weight:800; color:#1e3c72;
    background:#eef4fb; border:1px solid #c9d6e5; border-radius:999px; padding:2px 12px; }
  #erl-bulkNote{ margin-top:8px; font-size:12.5px; color:#8a5a00; }
  .erl-bulkprev{ max-height:230px; overflow:auto; border:1px solid #dfe6ef; border-radius:8px; background:#fbfdff; padding:6px 8px; font-size:12.5px; color:#5b6b80; }
  table.erl-btbl{ width:100%; border-collapse:collapse; font-size:12.5px; background:#fff; }
  table.erl-btbl th{ background:#eef3f8; color:#37475a; font-weight:800; border:1px solid #e3eaf2; padding:4px 8px; white-space:nowrap; }
  table.erl-btbl td{ border:1px solid #eef2f7; padding:4px 8px; color:#1b2733; white-space:nowrap; }
  table.erl-btbl tr.erl-bad td{ background:#fdf3f2; }
  table.erl-btbl .del{ border:none; background:none; color:#c0392b; cursor:pointer; font-size:12px; padding:0 4px; }
  table.erl-btbl .edt{ border:none; background:none; color:#1e3c72; cursor:pointer; font-size:13px; padding:0 4px; font-weight:800; }
  table.erl-btbl .edt:hover{ color:#0f2550; }
  /* 직접 입력 줄 — 칸마다 머리글(라벨)을 달아 무엇을 넣는지 구분되게 */
  #erl-bulkModal .erl-btn{ white-space:nowrap; }   /* 버튼 글자가 줄바꿈되지 않게 */

  /* SweetAlert 알림창 — 모양은 다른 화면(assessment 등)과 같은 SweetAlert2 기본 스타일을 그대로 쓴다.
     여기서는 겹침만 고친다: 기본 z-index(1060)가 이 화면 모달(1400)보다 낮아 알림창이 뒤로 깔렸다.
     ※ swal 은 body 바로 아래에 그려지므로 #evalReportList 안에 넣으면 안 먹는다(스코프 밖에 둘 것). */
  .swal2-container{ z-index:3000 !important; }   /* 이 화면의 다른 코드가 Swal 을 쓸 때 대비(모달 1400 위로) */
  #erl-bulkModal .erl-brow{ display:flex; gap:10px; flex-wrap:wrap; align-items:flex-start; }
  #erl-bulkModal .erl-brow label{ margin:0 0 3px; font-size:12.5px; color:#37475a; }
  #erl-bulkModal .erl-inhospnm{ margin-top:4px; font-size:12px; color:#9aa7b3; white-space:nowrap; }
  /* 병원 검색 팝업 — 입력칸 바로 아래 작게 뜬다 */
  #erl-hospPop{ display:none; position:absolute; top:100%; left:0; z-index:1500; width:330px; max-width:88vw;
    background:#fff; border:1px solid #c9d6e5; border-radius:8px; box-shadow:0 10px 26px rgba(16,22,29,.22); padding:8px; }
  #erl-hospPop.on{ display:block; }
  #erl-hospPop .hp-head{ display:flex; align-items:center; justify-content:space-between; font-size:12.5px; font-weight:800; color:#1e3c72; margin-bottom:6px; }
  #erl-hospPop .hp-head button{ border:none; background:none; cursor:pointer; color:#7b8a99; font-size:13px; }
  #erl-hospPop .hp-list{ max-height:230px; overflow:auto; margin-top:6px; border-top:1px solid #eef2f7; }
  #erl-hospPop .hp-row{ display:flex; gap:8px; align-items:center; padding:5px 4px; cursor:pointer; border-bottom:1px dashed #eef2f7; font-size:12.5px; }
  #erl-hospPop .hp-row:hover{ background:#eef4fb; }
  #erl-hospPop .hp-row .cd{ flex:0 0 78px; color:#6b7a89; font-variant-numeric:tabular-nums; }
  #erl-hospPop .hp-row .nm{ flex:1 1 auto; color:#1b2733; font-weight:700; }
  #erl-hospPop .hp-none{ padding:10px 4px; font-size:12.5px; color:#9aa7b3; }
  #erl-bulkModal .erl-inhospnm.ok{ color:#2e7d32; font-weight:800; }
  #erl-bulkModal .erl-inhospnm.ng{ color:#c0392b; font-weight:800; }
  /* 대량 등록(엑셀·붙여넣기) — 기본 접힘 */
  #erl-bulkModal details.erl-bdev{ margin-top:10px; border:1px solid #e2e8ef; border-radius:8px; background:#fafcfe; padding:8px 10px; }
  #erl-bulkModal details.erl-bdev > summary{ cursor:pointer; font-size:13px; font-weight:800; color:#1f5a4b; list-style:none; }
  #erl-bulkModal details.erl-bdev > summary::-webkit-details-marker{ display:none; }
  #erl-bulkModal details.erl-bdev > summary::before{ content:'▸ '; color:#7b8a99; }
  #erl-bulkModal details.erl-bdev[open] > summary::before{ content:'▾ '; }
  #erl-bulkModal details.erl-bdev > summary span{ font-weight:600; font-size:12px; color:#8a97a4; }
  #erl-mailModal .erl-btn{ font-size:14px; padding:8px 15px; }
  #erl-mailNote{ margin-top:10px; font-size:13.5px; color:#8a5a00; white-space:pre-line; }
  /* 주소록 */
  #evalReportList .erl-addrbox{ border:1px solid #dfe6ef; border-radius:8px; padding:6px 10px; max-height:150px; overflow:auto; background:#fbfdff; }
  #evalReportList .erl-addrrow{ display:flex; align-items:center; gap:8px; padding:5px 0; font-size:14.5px; border-bottom:1px dashed #eef2f7; }
  #evalReportList .erl-addrrow:last-child{ border-bottom:none; }
  #evalReportList .erl-addrrow .nm{ color:#37475a; font-weight:700; min-width:90px; }
  #evalReportList .erl-addrrow .em{ color:#1e3c72; flex:1 1 auto; word-break:break-all; }
  #evalReportList .erl-addrrow .del{ border:none; background:none; color:#c0392b; cursor:pointer; font-size:12px; padding:0 4px; }
  #evalReportList .erl-addrempty{ font-size:13.5px; color:#9aa7b3; padding:7px 0; }
  #evalReportList .erl-addradd{ display:flex; gap:6px; margin-top:7px; flex-wrap:wrap; }
  #evalReportList .erl-candbox{ margin-top:7px; font-size:13px; color:#5b6b80; display:flex; gap:6px; flex-wrap:wrap; align-items:center; }
  #evalReportList .erl-cand{ border:1px dashed #b9c9de; background:#fff; border-radius:999px; padding:3px 10px; cursor:pointer; color:#1e3c72; }
  #evalReportList .erl-cand:hover{ background:#eef4fb; }
  /* [위너넷] 기관기호 앞 이력확장 토글(+/−) + 이력 child row */
  #evalReportList .erl-exp{ display:inline-block; width:16px; height:16px; line-height:14px; text-align:center; margin-right:5px;
    border:1px solid #9aa4a0; border-radius:3px; background:#fff; color:#333; font-weight:800; font-size:12px; cursor:pointer; vertical-align:middle; }
  #evalReportList .erl-exp:hover{ background:#e9f4f3; border-color:#2a7665; color:#2a7665; }
  #evalReportList tr.erl-open > td{ background:#f2f8f6 !important; }
  #evalReportList .erl-hstbox{ padding:9px 12px; background:#f7fbfa; border:1px solid #d9e6e2; border-radius:6px; }
  #evalReportList .erl-hsttit{ font-size:12.5px; font-weight:800; color:#1f5a4b; margin-bottom:7px; }
  #evalReportList .erl-hstsub{ font-weight:600; color:#6a7a75; font-size:11.5px; }
  #evalReportList .erl-hsttbl{ width:auto; border-collapse:collapse; font-size:12px; background:#fff; }
  #evalReportList .erl-hsttbl th, #evalReportList .erl-hsttbl td{ border:1px solid #e0e6e4; padding:5px 16px; text-align:center; white-space:nowrap; }
  #evalReportList .erl-hsttbl thead th{ background:#eef3f1; color:#334; font-weight:700; }
  #evalReportList .erl-hsttbl tbody{ cursor:pointer; }
  #evalReportList .erl-hstrow:hover td{ background:#eaf5f0; }
  #evalReportList .erl-hstrow.erl-hstsel td{ background:#fff5d6; }                 /* 돌아왔을 때 선택했던 이력 강조 */
  #evalReportList .erl-hstrow.erl-hstsel:hover td{ background:#ffefc0; }
  #evalReportList .erl-selmark{ color:#c47f17; font-weight:800; font-size:11px; margin-left:6px; }
  #evalReportList .erl-hstappr{ color:#2e7d32; }   /* ✔ 승인 */
  #evalReportList .erl-hstcncl{ color:#c0392b; }   /* ↩ 승인취소 */
  /* 선택유지 — 돌아온(마지막 연) 행 강조 */
  #evalReportList table.dataTable tbody tr.erl-selrow > td{ background:#fff5d6 !important; }
  #evalReportList table.dataTable tbody tr.erl-selrow > td:first-child{ box-shadow:inset 3px 0 0 #e0a52a; }
  #evalReportList .erl-hstempty{ color:#6a7a75; font-size:12px; }
  #evalReportList .erl-hstlink{ color:#2a7665; font-weight:800; text-decoration:none; margin-left:6px; }
  #evalReportList .erl-hstlink:hover{ text-decoration:underline; }

  /* DataTables — 표준 스킨. 헤더=연한 회색, 그리드 폰트 살짝 크게 */
  #evalReportList table.dataTable{ font-size:14px; }
  #evalReportList table.dataTable tbody tr{ cursor:pointer; }
  #evalReportList table.dataTable tbody td{ padding-top:4px; padding-bottom:4px; }
  #evalReportList table.dataTable thead th{ padding-top:6px; padding-bottom:6px; }
  /* 헤더색은 앱 표준(addstyle.css: table.dataTable thead th { background:#E9F4F3 })을 그대로 사용 — 오버라이드 안 함 */
  #evalReportList .erl-note{ margin-top:12px; font-size:11.5px; color:#54636c; line-height:1.6; }
  /* DataTables 컨트롤(버튼·자료검색·정보·페이징) 글자 조금 크게 — 신/구 클래스 모두 */
  #evalReportList .dt-buttons .dt-button{ font-weight:700; font-size:14px; padding:6px 14px; }
  #evalReportList .dataTables_filter, #evalReportList div.dt-search,
  #evalReportList .dataTables_filter input, #evalReportList div.dt-search input{ font-size:14px; }
  #evalReportList .dataTables_filter input, #evalReportList div.dt-search input{ padding:5px 8px; }
  #evalReportList .dataTables_info, #evalReportList div.dt-info,
  #evalReportList .dataTables_paginate, #evalReportList div.dt-paging{ font-size:13.5px; }
  #evalReportList .dataTables_paginate .paginate_button, #evalReportList div.dt-paging .dt-paging-button{ font-size:13.5px; }
</style>

  <div class="erl-head">
    <span class="erl-title"><span class="erl-dot"></span>적정성평가 월간보고서 — 목록</span>
    <span class="erl-role" id="erl-role">위너넷</span>
  </div>

  <div class="erl-search">
    <label>평가년도</label>
    <select id="erl-year" class="erl-sel" onchange="erlLoad()"></select>
    <label style="margin-left:6px;">평가월</label>
    <select id="erl-month" class="erl-sel" onchange="erlFilter()"><option value="">전체</option></select>
    <label style="margin-left:6px;">병원</label>
    <%-- 병원을 고르면 월이 '전체'로 풀린다(그 병원 연간 이력 보기) → erlHospChange --%>
    <select id="erl-hosp" class="erl-sel erl-hosp" onchange="erlHospChange()"><option value="">전체 병원</option></select>
    <label style="margin-left:6px;">상태</label>
    <select id="erl-status" class="erl-sel" onchange="erlFilter()">
      <option value="">전체</option>
      <option value="DRAFT">작성중</option>
      <option value="APPROVED">승인됨</option>
    </select>
    <label style="margin-left:6px;">첨부</label>
    <select id="erl-pdf" class="erl-sel" onchange="erlFilter()">
      <option value="">전체</option>
      <option value="Y">있음</option>
      <option value="N">없음</option>
    </select>
    <button class="erl-btn" onclick="erlLoad()">🔍 검색</button>
    <%-- 관리자(위너넷) 전용 도움말 — 메일 발송 설정(구글 앱 비밀번호) 안내. 병원 화면에서는 JS 가 숨긴다 --%>
    <button type="button" class="erl-help" id="erl-bulkBtn" style="margin-left:auto; display:none;"
            onclick="erlBulkOpen()" title="병원별 수신자 메일주소를 화면 입력 또는 엑셀로 등록">📥 메일주소 일괄등록</button>
    <button type="button" class="erl-help" id="erl-helpBtn" style="display:none;"
            onclick="erlHelp()" title="메일 발송을 위한 구글 계정 설정 방법">ℹ️ 메일 발송 설정 도움말</button>
  </div>

  <table id="erl-grid" class="display nowrap stripe hover cell-border order-column" style="width:100%">
    <thead>
      <tr>
        <%-- ★ th 개수는 아래 DataTables columns 개수와 반드시 같아야 한다(다르면 그리드가 통째로 오류) --%>
        <th>번호</th><th>기관기호</th><th>병원명</th><th>평가월</th><th>종합점수</th>
        <th>구조</th><th>진료</th><th>목표</th><th>상태</th><th>첨부</th>
        <th>메일</th><th>메일열람</th><th>문서열람</th>
        <th>작성자</th><th>승인자</th><th>승인일시</th><th>수정일</th>
      </tr>
    </thead>
  </table>

  <%-- 메일주소 일괄등록 창 — 엑셀 파일 또는 붙여넣기로 여러 병원 수신자를 한 번에 등록(관리자 전용).
       형식: 요양기관기호 | 이메일 | 이름/직책(선택). 같은 병원+주소는 중복 등록되지 않고 이름만 갱신된다. --%>
  <div id="erl-bulkModal">
    <div class="erl-mbox" style="width:min(860px,96vw)">
      <div class="erl-mhead">
        <span>📥 메일주소 일괄등록</span>
        <span>
          <button id="erl-bulkSaveBtn" class="erl-btn" onclick="erlBulkSave()">💾 등록</button>
          <button class="erl-btn" onclick="erlBulkClose()">✕ 닫기</button>
        </span>
      </div>
      <div class="erl-mbody">
        <div style="font-size:13.5px; color:#5b6b80;">
          기관기호를 입력하면 <b>병원명이 자동으로 표시</b>됩니다. 한 건씩 <b>추가</b>한 뒤 마지막에 <b>등록</b>을 누르세요.
        </div>

        <%-- 직접 입력 — 기관기호(자동완성) · 이메일 · 성함을 칸을 나눠 받는다 --%>
        <div class="erl-msect">
          <div class="erl-brow">
            <div style="flex:1 1 190px; position:relative;">
              <label style="margin-top:0;">요양기관기호</label>
              <div style="display:flex; gap:4px; flex-wrap:nowrap;">
                <input id="erl-inHosp" type="text" placeholder="예) 11223344" style="flex:1 1 auto; min-width:0;"
                       oninput="erlInHospNm()" onkeydown="if(event.keyCode===13){document.getElementById('erl-inEmail').focus();}">
                <button type="button" class="erl-btn" style="flex:0 0 auto; padding:7px 10px;"
                        onclick="erlHospPickOpen()" title="병원 검색">🔍</button>
              </div>
              <div id="erl-inHospNm" class="erl-inhospnm">기관기호 입력 또는 🔍 검색</div>

              <%-- 병원 검색 팝업 — 이미 받아둔 병원 목록에서 이름·기호로 걸러 고른다(서버 조회 없음) --%>
              <div id="erl-hospPop" class="erl-hpop">
                <div class="hp-head">
                  <span>병원 검색</span>
                  <button type="button" onclick="erlHospPickClose()">✕</button>
                </div>
                <input id="erl-hospPopQ" type="text" placeholder="병원명 또는 기관기호" oninput="erlHospPickRender()"
                       onkeydown="if(event.keyCode===27){erlHospPickClose();}">
                <div id="erl-hospPopList" class="hp-list"></div>
              </div>
            </div>
            <div style="flex:2 1 220px;">
              <label style="margin-top:0;">이메일</label>
              <input id="erl-inEmail" type="text" placeholder="name@domain.com"
                     onkeydown="if(event.keyCode===13){document.getElementById('erl-inName').focus();}">
            </div>
            <div style="flex:1 1 140px;">
              <label style="margin-top:0;">성함 / 직책</label>
              <input id="erl-inName" type="text" placeholder="예) 김간호 팀장"
                     onkeydown="if(event.keyCode===13){erlBulkAdd();}">
            </div>
            <div style="flex:0 0 auto; align-self:flex-end;">
              <button type="button" class="erl-btn" onclick="erlBulkAdd()">＋ 추가</button>
            </div>
          </div>
        </div>

        <%-- 엑셀 파일 — 한 번에 많이 넣을 때만 사용(기본 접힘) --%>
        <details class="erl-bdev">
          <summary>엑셀 파일로 한 번에 넣기 <span>(대량 등록용 — 눌러서 펼치기)</span></summary>
          <label>엑셀 파일 (.xlsx / .csv)
            <span style="font-weight:600; color:#6b7a89;">— A열 기관기호 · B열 이메일 · C열 성함 순서여야 합니다</span></label>
          <div style="display:flex; gap:8px; align-items:center; flex-wrap:wrap;">
            <input type="file" id="erl-bulkFile" accept=".xlsx,.xls,.csv" onchange="erlBulkFile(this)" style="font-size:13px; flex:1 1 auto;">
            <button type="button" class="erl-btn" onclick="erlBulkSample()" title="양식 엑셀 파일을 내려받습니다">⬇ 양식 받기</button>
          </div>
        </details>

        <div class="erl-mdiv"><span>등록할 내용</span></div>
        <div id="erl-bulkPreview" class="erl-bulkprev">엑셀을 올리거나 붙여넣은 뒤 [확인하기]를 누르세요.</div>
        <div id="erl-bulkNote"></div>

        <div class="erl-mdiv"><span>등록 현황 (관리)</span></div>
        <%-- 검색줄 — 버튼이 줄바꿈되지 않도록 폭 고정(flex:0 0 auto + nowrap) --%>
        <div style="display:flex; gap:6px; align-items:center; margin-bottom:6px; flex-wrap:nowrap;">
          <input id="erl-addrFind" type="text" placeholder="병원명 · 기관기호 · 이메일 검색"
                 style="flex:1 1 auto; min-width:0;" onkeydown="if(event.keyCode===13){erlAddrAllLoad();}">
          <button type="button" class="erl-btn" style="flex:0 0 auto; white-space:nowrap;" onclick="erlAddrAllLoad()">🔍 조회</button>
        </div>
        <div id="erl-addrAllBox" class="erl-bulkprev"></div>
      </div>
    </div>
  </div>

  <%-- 메일 발송 창 — 목록에서 바로 보낸다(승인 + 첨부 있는 건만 버튼이 뜬다).
       제목·본문 기본값은 서버(evalReportMailForm.do)가 표준문구(TBL_EVAL_REPORT_TPL)에 점수를 채워 내려준다. --%>
  <div id="erl-mailModal">
    <div class="erl-mbox">
      <div class="erl-mhead">
        <span>✉ 월보고서 메일 발송 <span id="erl-mailWho" style="font-weight:700; font-size:15px; opacity:.85;"></span></span>
        <span>
          <button id="erl-mailSendBtn" class="erl-btn" onclick="erlMailSend()">📨 보내기</button>
          <button class="erl-btn" onclick="erlMailClose()">✕ 닫기</button>
        </span>
      </div>
      <div class="erl-mbody">
        <div style="font-size:13.5px; color:#5b6b80;">승인된 보고서의 <b>첨부 PDF</b>가 그대로 첨부됩니다. 여러 명은 <b>콤마(,)</b>로 구분하세요.</div>

        <%-- 주소록 — 이 병원에 등록해 둔 수신자. 창을 열면 전부 선택된 상태로 시작한다(수신자 고정 운영).
             체크를 바꾸면 아래 '받는 사람'이 자동으로 다시 채워진다.
             ★ 아래 '실제 보낼 내용(받는사람·제목·내용)' 과 헷갈리지 않게 회색 박스로 묶어 구분한다. --%>
        <%-- 등록된 수신자가 2명 이상일 때만 선택 목록을 보여준다(1명이면 자동 선택).
             주소 추가·삭제는 [📥 메일주소 일괄등록] 에서 하므로 여기엔 두지 않는다. --%>
        <div class="erl-msect" id="erl-addrSect" style="display:none;">
          <label style="margin-top:0;">수신자 선택 <span style="font-weight:600; color:#6b7a89;">(체크한 주소로 보냅니다)</span></label>
          <div id="erl-addrBox" class="erl-addrbox"></div>
        </div>

        <%-- 설정(주소록) / 실제 보낼 내용 경계 — 한눈에 보이게 제목 붙은 구분선 --%>
        <div class="erl-mdiv"><span>보낼 내용</span></div>

        <label for="erl-mailTo">받는 사람</label>
        <input id="erl-mailTo" type="text" placeholder="hospital@example.com, staff@example.com">
        <label for="erl-mailSubject">제목</label>
        <input id="erl-mailSubject" type="text">
        <label for="erl-mailBody">내용</label>
        <textarea id="erl-mailBody" rows="11"></textarea>
        <div id="erl-mailNote"></div>
      </div>
    </div>
  </div>

<script>
jQuery(function(){
  "use strict";
  var ctx = (typeof CommonUtil !== 'undefined' && CommonUtil.getContextPath) ? CommonUtil.getContextPath() : '';
  function cookie(n){ var m=document.cookie.match('(^|;)\\s*'+n+'\\s*=\\s*([^;]+)'); return m?decodeURIComponent(m.pop()):''; }
  function _ck(n){ try{ if(typeof getCookie==='function') return (getCookie(n)||'').trim(); }catch(e){} return cookie(n); }
  function el(id){ return document.getElementById(id); }
  function esc(s){ return String(s==null?'':s).replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;'); }
  /* onclick 속성 안에 넣는 JS 문자열용 — 따옴표·역슬래시 제거.
     ※ 같은 이름(sj)의 지역 함수가 hstHtml 안에 따로 있다. 그리드 render 등 바깥에서는 반드시 이 _sj 를 쓸 것
       (바깥에서 sj 를 부르면 ReferenceError 로 그리드가 통째로 비어 보인다 — 2026-07-29 실제 발생) */
  function _sj(v){ return String(v==null?'':v).replace(/[\\'"]/g,''); }

  /* 알림 — 보고서 화면(erSwal/erConfirm)과 같은 SweetAlert2 방식. Swal 은 header.jsp 에서 전역 로드.
     라이브러리가 없으면 기본 alert/confirm 으로 떨어져 동작은 유지된다. */
  /* 알림·확인 — konet_vsweb 로그인 화면과 같은 공통 컴포넌트(/asset/js/ui-message.js) 사용.
     _alertBox(확인 1버튼) / _confirmBox(취소·확인 2버튼). 넓은 파란 버튼 · 작은 창이 이 시스템 표준.
     라이브러리가 없으면 기본 alert/confirm 으로 떨어져 동작은 유지된다. */
  function _erlIcon(icon){
    return (icon==='error') ? '❌' : (icon==='success') ? '✅' : (icon==='warning') ? '⚠️' : (icon==='question') ? '❓' : 'ℹ️';
  }
  function erlSwal(icon, msg, opt){
    opt = opt || {};
    var body = opt.html ? opt.html : String(msg==null?'':msg).replace(/\n/g,'<br>');
    if(typeof window._alertBox !== 'function'){ alert(String(msg||'').replace(/<[^>]*>/g,'')); if(opt.done) opt.done(); return; }
    window._alertBox(body, { icon:_erlIcon(icon), okColor:(icon==='error'?'red':'blue'), onOk:opt.done });
  }
  function erlConfirm(msg, onYes, opt){
    opt = opt || {};
    var body = String(msg==null?'':msg).replace(/\n/g,'<br>');   // 줄바꿈 허용(HTML 태그도 그대로 씀)
    if(typeof window._confirmBox !== 'function'){ if(window.confirm(String(msg||''))){ if(onYes) onYes(); } return; }
    window._confirmBox({ msg:body, icon:_erlIcon(opt.icon||'question'), okText:(opt.yes||'확인'),
                         okColor:'blue', onOk:onYes });
  }
  function n(v){ var x=Number(v); return isNaN(x)?0:x; }
  function f1(v){ return (Math.round(n(v)*10)/10).toFixed(1); }
  function gradeOf(t){ t=n(t); if(t>=88)return'1등급'; if(t>=79)return'2등급'; if(t>=71)return'3등급'; if(t>=63)return'4등급'; return'5등급'; }
  // 사용자명 디코딩 — escape() 방식(%uXXXX) 한글. unescape 는 %XX·%uXXXX 둘 다 처리(decodeURIComponent 는 %uXXXX 불가).
  function decUser(v){
    if(v==null || v==='') return '';
    var s=String(v);
    try{ if(/%u[0-9a-fA-F]{4}|%[0-9a-fA-F]{2}/.test(s)) return unescape(s); }catch(e){}
    return s;
  }

  var isWinner = (_ck('s_wnn_yn') === 'Y');
  var ownHospCd = (typeof hospid !== 'undefined' && hospid) ? String(hospid).trim() : (_ck('s_hospid') || '');
  var ownHospNm = (typeof hospnm !== 'undefined' && hospnm) ? String(hospnm) : (_ck('s_hospnm') || '');
  if(!isWinner){ var rt=el('erl-role'); if(rt) rt.textContent='거래처'; }
  // 메일 발송 설정 도움말 — 관리자(위너넷)에게만 노출
  if(isWinner && MAIL_UI_ON){          // 메일 기능이 켜져 있을 때만 관리자 버튼 노출
    var hb=el('erl-helpBtn'); if(hb) hb.style.display='';
    var bb=el('erl-bulkBtn'); if(bb) bb.style.display='';
  }

  var _hospPicked = false;
  try{ _hospPicked = (sessionStorage.getItem('hospPicked')==='1'); if(_hospPicked) sessionStorage.removeItem('hospPicked'); }catch(e){}

  var HOSP_NM = {};   // hosp_cd → hosp_nm (응답에 병원명 없을 때 폴백)

  /* ★ 메일 기능 노출 스위치 — 운영 배포·검증 전까지 화면에서 감춘다(2026-07-29 요청).
       false 이면 ① 📥 메일주소 일괄등록 버튼 ② ℹ️ 메일 발송 설정 도움말 버튼 ③ 목록의 '메일'(발송/재발송) 칸
       세 가지가 모두 숨겨진다. 서버·DB 기능은 그대로 살아 있으므로 true 로만 바꾸면 즉시 다시 나온다. */
  var MAIL_UI_ON = false;

  var CUR_MM = ('0' + (new Date().getMonth()+1)).slice(-2);   // 당월(MM) — 평가월 기본 선택값
  function defaultYear(){
    var qy=(location.search.match(/[?&]year=(\d{4})/)||[])[1]; if(qy) return qy;
    var qm=(location.search.match(/[?&]ym=(\d{6})/)||[])[1]; if(qm) return qm.substring(0,4);
    return String(new Date().getFullYear());
  }

  (function initSel(){
    var y=new Date().getFullYear(), defY=parseInt(defaultYear(),10)||y;
    var minY=Math.min(y-9, defY), maxY=Math.max(y, defY);
    var yh=''; for(var yy=maxY; yy>=minY; yy--){ yh+='<option value="'+yy+'">'+yy+'</option>'; }
    el('erl-year').innerHTML=yh; el('erl-year').value=String(defY);
    var mh='<option value="">전체</option>';
    for(var mo=1;mo<=12;mo++){ var mm=('0'+mo).slice(-2); mh+='<option value="'+mm+'">'+mm+'월</option>'; }
    el('erl-month').innerHTML=mh;
    /* 평가월 기본값 = 당월. 전체 병원을 볼 때는 이번 달 것만 보는 게 기본 작업 흐름이라(2026-07-29 요청).
       URL 로 특정 년월을 지정해 들어온 경우(ym=YYYYMM)에는 그 월을 그대로 쓴다. */
    var qm=(location.search.match(/[?&]ym=(\d{6})/)||[])[1];
    el('erl-month').value = qm ? qm.substring(4,6) : CUR_MM;
  })();

  /* 병원 선택이 바뀔 때 — 특정 병원을 고르면 그 병원의 '그 해 전체' 를 보도록 월을 전체로 풀고,
     전체 병원으로 돌아오면 다시 당월만 본다. */
  window.erlHospChange = function(){
    var hosp = el('erl-hosp') ? el('erl-hosp').value : '';
    var mo   = el('erl-month');
    if(mo) mo.value = hosp ? '' : CUR_MM;
    erlFilter();
  };

  // 병원 셀렉트 — 위너넷=전체 목록, 거래처=본인 병원만(고정)
  (function initHosp(){
    var sel=el('erl-hosp');
    if(!isWinner){
      sel.innerHTML='<option value="'+esc(ownHospCd)+'">'+esc(ownHospNm||ownHospCd)+'</option>';
      sel.value=ownHospCd; sel.disabled=true;
      if(ownHospCd) HOSP_NM[ownHospCd]=ownHospNm||ownHospCd;
      return;
    }
    jQuery.ajax({ url:ctx+'/main/select_HospitalMst.do', type:'POST', dataType:'json', data:{ hosp_cd:'' },
      success:function(res){
        var arr=(res&&res.data)||[], html='<option value="">전체 병원</option>';
        arr.forEach(function(h){
          var cd=h.hosp_cd||h.HOSP_CD||'', nm=h.hosp_nm||h.HOSP_NM||cd; if(!cd) return;
          HOSP_NM[cd]=nm; html+='<option value="'+esc(cd)+'">'+esc(nm)+'</option>';
        });
        sel.innerHTML=html;
        if(_hospPicked && ownHospCd){
          var found=false; for(var i=0;i<sel.options.length;i++){ if(sel.options[i].value===ownHospCd){ found=true; break; } }
          if(!found){ HOSP_NM[ownHospCd]=ownHospNm||ownHospCd; var o=document.createElement('option'); o.value=ownHospCd; o.textContent=(ownHospNm||ownHospCd); sel.appendChild(o); }
          sel.value=ownHospCd;
        }
      }
    });
  })();

  function stCell(st){
    if(st==='APPROVED') return '<span class="erl-st erl-appr"><span class="erl-sd"></span>승인됨</span>';
    return '<span class="erl-st erl-draft"><span class="erl-sd"></span>작성중</span>';
  }
  function scoreRender(d,t){ if(t==='display'){ return (d==null||d==='')?'-':f1(d); } return (d==null||d==='')?0:n(d); }

  // ===== DataTable (앱 표준 그리드) =====
  var LAST = [], DT = null, _erlSel = null;   // _erlSel = 돌아왔을 때 선택유지할 행(hospcd·evalym)
  function buildGrid(){
    DT = jQuery('#erl-grid').DataTable({
      data: [],
      language: {
        search: "&nbsp;자 료 검 색 : ",
        emptyTable: "조회된 월보고서가 없습니다. (조건을 바꿔 다시 검색하세요)",
        zeroRecords: "일치하는 보고서가 없습니다.",
        info: "현재 _START_ - _END_ / 총 _TOTAL_건",
        infoEmpty: "0건",
        infoFiltered: "( _MAX_건 중 필터 )",
        paginate: { next:"다음", previous:"이전" }
      },
      dom: '<"row"<"col-sm-7"B><"col-sm-5"f>>t<"row mt-2"<"col-sm-6"i><"col-sm-6"p>>',
      lengthChange: false,
      pageLength: 20,
      ordering: true,
      order: [],                          // 서버 정렬 순서 유지(사용자가 헤더 클릭 시 재정렬)
      autoWidth: false,
      buttons: [
        { extend:'copy',       text:'복사.', exportOptions:{ format:{ body:_stripTags } } },
        { extend:'excelHtml5', text:'엑셀.', title:'적정성평가 월간보고서',
          filename:function(){ return '적정성평가_월간보고서_'+(el('erl-year')?el('erl-year').value:''); },
          exportOptions:{ format:{ body:_stripTags } } },
        { extend:'print',      text:'출력.', title:'적정성평가 월간보고서', autoPrint:true,
          exportOptions:{ format:{ body:_stripTags } } }
      ],
      columns: [
        { title:'번호', data:null, orderable:false, className:'dt-center', render:function(d,t,r,meta){ return meta.row+1; } },
        { title:'기관기호', data:'hospcd', className:'dt-center', render:function(d,t,r){
            var code=esc(d||'');
            if(t!=='display') return code;
            // 위너넷 & 변경이력(hstcnt)이 있는 행만 기관기호 앞 [+] 확장. 이력 없으면 [+] 미표시.
            var hasHst = isWinner && (Number(r.hstcnt)||0) > 0;
            return hasHst ? ('<span class="erl-exp" title="변경 이력 펼치기">+</span>'+code) : code;
          } },
        { title:'병원명', data:'hospnm', render:function(d,t,r){ var nm=d||HOSP_NM[r.hospcd]||r.hospcd||''; return (t==='display')?('<span class="erl-hospnm">'+esc(nm)+'</span>'):esc(nm); } },
        { title:'평가월', data:'evalym', className:'dt-center', render:function(d){ var ym=String(d||''); return ym.length===6?(ym.substring(0,4)+'.'+ym.substring(4,6)):esc(ym); } },
        { title:'종합점수', data:'totalscore', className:'dt-center', render:function(d,t){ if(t==='display'){ return (d==null||d==='')?'-':('<span class="erl-total">'+f1(d)+'</span> <span class="erl-grade">'+gradeOf(d)+'</span>'); } return (d==null||d==='')?0:n(d); } },
        { title:'구조', data:'structscore', className:'dt-center', render:scoreRender },
        { title:'진료', data:'carescore', className:'dt-center', render:scoreRender },
        { title:'목표', data:null, className:'dt-center', render:function(d,t,r){ return (r.goalgrade?esc(r.goalgrade):'')+((r.goalscore!=null&&r.goalscore!=='')?(' ('+f1(r.goalscore)+')'):''); } },
        { title:'상태', data:'status', className:'dt-center', render:function(d,t){ if(t==='display') return stCell(d); return (d==='APPROVED')?'승인됨':'작성중'; } },
        { title:'첨부', data:'haspdf', className:'dt-center', render:function(d,t){ var has=(d==='Y'); if(t==='display') return has?'<span class="erl-pdf">📎 있음</span>':'-'; return has?'있음':'-'; } },
        /* 메일발송 — 위너넷만. 승인됨 + 첨부 있음 일 때만 보낼 수 있다(작성중 문서가 병원에 나가지 않게).
           이미 보냈으면 보낸 일시·횟수를 보여주고, 다시 보내기도 같은 버튼으로 한다. */
        { title:'메일', data:null, className:'dt-center', orderable:false, visible:MAIL_UI_ON, render:function(d,t,r){
            if(t!=='display') return (r.senddttm||'');
            var can = (r.status==='APPROVED') && (r.haspdf==='Y');
            var sent = (Number(r.sendcnt)||0) > 0;
            /* 병원(거래처) 화면 — 보고서가 메일로 왔는지만 알려준다.
               발송 버튼·수신자 주소·재발송은 관리자 몫이라 보여주지 않는다. */
            if(!isWinner){
              if(!sent) return '<span class="erl-noread">-</span>';
              return '<span class="erl-read">📧 발송됨</span><div class="erl-sentinfo">'+esc(r.senddttm||'')+'</div>';
            }
            // 보낸 건 = 보낸 일시(+횟수) / 안 보낸 건 = '미발송' 을 글자로 분명히 (버튼만 보여 보낸 걸로 오해하지 않게)
            var info = sent
                 ? ('<div class="erl-sentinfo" title="'+esc(r.sendemail||'')+'">'+esc(r.senddttm||'')
                    + ((Number(r.sendcnt)||0)>1 ? (' ('+r.sendcnt+'회)') : '') + '</div>')
                 : '<div class="erl-nosend">미발송</div>';
            if(!can) return info;   // 승인 전이거나 첨부가 없으면 버튼 없이 상태만
            var oc = "erlMailOpen('"+_sj(r.hospcd)+"','"+_sj(r.evalym)+"','"+_sj(r.hospnm||HOSP_NM[r.hospcd]||r.hospcd)+"')";
            return '<button type="button" class="erl-mailbtn" onclick="'+oc+'">'+(sent?'↻ 재발송':'✉ 발송')+'</button>'+info;
          } },
        /* 메일열람 — 보낸 메일을 열었는지(본문 1×1 추적 이미지)만 반영한다. 문서열람과 섞지 않는다
           (2026-07-29 사용자 확정: 문서·메일 별도). 이미지 차단 시 열어도 '미확인'으로 남는 건 감수. */
        { title:'메일열람', data:null, className:'dt-center', visible:isWinner, render:function(d,t,r){
            if(t!=='display') return (r.mailreaddttm||'');
            // 아직 안 보낸 건은 열람을 따질 대상이 아니므로 '발송 전'으로 분명히 구분한다
            if((Number(r.sendcnt)||0)===0) return '<span class="erl-noread">발송 전</span>';
            if(r.mailreadyn!=='Y') return '<span class="erl-noread" title="아직 열지 않았거나, 수신자가 이미지 표시를 차단한 경우입니다">미확인</span>';
            return '<span class="erl-read">열람</span><div class="erl-sentinfo">'+esc(r.mailreaddttm||'')
                 + ((Number(r.mailreadcnt)||0)>1 ? (' ('+r.mailreadcnt+'회)') : '') + '</div>';
          } },
        /* 문서열람 — 병원이 WinCheck+ 에서 보고서 화면을 연 기록(확실). 메일 본문의 '보고서 보기' 링크로
           들어와 열어도 여기에 남는다. 위너넷 열람은 기록하지 않는다. */
        { title:'문서열람', data:null, className:'dt-center', visible:isWinner, render:function(d,t,r){
            if(t!=='display') return (r.readdttm||'');
            if(r.readyn!=='Y') return '<span class="erl-noread">미열람</span>';
            return '<span class="erl-read">읽음</span><div class="erl-sentinfo">'+esc(r.readdttm||'')
                 + ((Number(r.readcnt)||0)>1 ? (' ('+r.readcnt+'회)') : '') + '</div>';
          } },
        { title:'작성자', data:'reguser', className:'dt-center', render:function(d){ return esc(decUser(d))||'-'; } },
        { title:'승인자', data:null, className:'dt-center', render:function(d,t,r){ return (r.status==='APPROVED')?(esc(decUser(r.approveuser))||'-'):'-'; } },
        { title:'승인일시', data:null, className:'dt-center', render:function(d,t,r){ return (r.status==='APPROVED')?esc(r.approvedttm||'-'):'-'; } },
        { title:'수정일', data:'upddttm', className:'dt-center', render:function(d){ return esc(d||'')||'-'; } }
      ]
    });
    // 번호 열 — 페이지·정렬에 맞춰 표시순번(1..N)으로 다시 매김
    DT.on('draw.dt', function(){
      var info=DT.page.info();
      DT.column(0,{ order:'applied', page:'current' }).nodes().each(function(cell,i){ cell.innerHTML = info.start + i + 1; });
      // 선택유지 — 돌아온 행 강조(정렬·페이지 바뀌어도 draw 마다 재적용)
      jQuery('#erl-grid tbody tr').removeClass('erl-selrow');
      if(_erlSel){
        DT.rows({ page:'current' }).every(function(){
          var d=this.data();
          if(d && String(d.hospcd)===String(_erlSel.hospcd) && String(d.evalym)===String(_erlSel.evalym)) jQuery(this.node()).addClass('erl-selrow');
        });
      }
    });
    // 행 더블클릭 → 해당 병원·월 보고서로 이동(편집 가능)
    jQuery('#erl-grid tbody').on('dblclick','tr', function(){
      var d=DT.row(this).data(); if(d) goReport(d.hospcd, d.hospnm||HOSP_NM[d.hospcd]||d.hospcd, d.evalym, false, false);
    });
    // [위너넷] 기관기호 앞 [+] → 변경이력 child row 펼침/접힘
    jQuery('#erl-grid tbody').on('click','td .erl-exp', function(ev){
      ev.stopPropagation();
      var tog=jQuery(this), tr=tog.closest('tr'), row=DT.row(tr), d=row.data();
      if(row.child.isShown()){ row.child.hide(); tr.removeClass('erl-open'); tog.text('+').attr('title','변경 이력 펼치기'); return; }
      tog.text('…');
      jQuery.ajax({ url:ctx+'/main/listEvalReportHst.do', type:'POST', dataType:'json',
        data:{ hospCd:d.hospcd, evalYm:d.evalym },
        success:function(res){
          var list=(res&&res.result==='OK')?(res.list||[]):[];
          // 표시 대상(문구·PDF)이 없으면 펼치지 않고 [+] 자체를 제거 — 빈 박스도 안 띄움
          if(!hstShownCnt(list)){ tog.remove(); tr.removeClass('erl-open'); return; }
          row.child(hstHtml(list, d)).show(); tr.addClass('erl-open'); tog.text('−').attr('title','변경 이력 접기');
        },
        error:function(){ row.child('<div class="erl-hstbox erl-hstempty">이력 조회 중 오류가 발생했습니다.</div>').show(); tr.addClass('erl-open'); tog.text('−'); }
      });
    });
  }
  // 목록에 표시할 이력 건수 — 승인/취소는 제외(문구·PDF만). 0이면 [+] 자체를 없앤다.
  function hstShownCnt(list){
    var c=0;
    for(var i=0;i<(list?list.length:0);i++){ var t=String(list[i].hsttype||''); if(t!=='APPROVE' && t!=='CANCEL') c++; }
    return c;
  }
  // 변경이력 child row 내용 — 클릭하면 그 보고서를 '읽기전용'으로 연다(저장·승인·PDF첨부 불가)
  //   selKey(시각) 이 주어지면 그 이력 행을 강조(돌아왔을 때 어디 선택했는지 표시)
  function hstHtml(list, d, selKey){
    var nm = d.hospnm||HOSP_NM[d.hospcd]||d.hospcd;
    if(!list || !list.length){ return '<div class="erl-hstbox erl-hstempty">변경 이력이 없습니다.</div>'; }
    // 같은 (작성자·시각) 이벤트는 한 행으로 묶고 유형(문구 저장·PDF 변경)을 합친다.
    // 그룹핑 규칙 — '문구 저장 + PDF 변경'은 한 저장 동작이므로 같은 시각·작성자면 한 줄로 묶는다.
    //   반면 '승인 / 승인취소'는 각각 독립 이벤트라 절대 묶지 않는다(승인취소 → 수정 → 재승인 순서 보존).
    var groups=[], idx={};
    for(var i=0;i<list.length;i++){
      var h=list[i], ty=String(h.hsttype||''), key;
      // 이력 표시 대상 = '내용(문구) 변경' + 'PDF 변경' 만. 승인/취소는 DB에는 남기되 목록에서는 제외.
      //   (다시 보이게 하려면 아래 continue 한 줄만 제거)
      if(ty==='APPROVE' || ty==='CANCEL') continue;
      if(ty==='APPROVE' || ty==='CANCEL') key = ty+'#'+(h.hstseq||i);                 // 항상 개별 행
      else                                key = 'SAVE|'+(h.regdttm||'')+'|'+(h.reguser||'');
      if(idx[key]==null){ idx[key]=groups.length; groups.push({ regdttm:h.regdttm, reguser:h.reguser, text:false, pdf:false, appr:false, cncl:false, seq:'', pdfpath:'' }); }
      var g=groups[idx[key]];
      if(ty==='PDF')          { g.pdf=true;  if(!g.pdfpath) g.pdfpath=h.pdfpath||''; }  // 그 시점 PDF 경로(보기용)
      else if(ty==='APPROVE') { g.appr=true; }                                          // 승인 이벤트
      else if(ty==='CANCEL')  { g.cncl=true; }                                          // 승인취소 이벤트
      else                    { g.text=true; if(!g.seq) g.seq=h.hstseq||''; }           // 문구 스냅샷 SEQ(재현용)
    }
    // 표시 대상(문구·PDF)이 하나도 없으면 빈 표를 만들지 않는다(승인/취소만 있는 경우 등)
    if(!groups.length){ return '<div class="erl-hstbox erl-hstempty">변경 이력이 없습니다.</div>'; }
    var sj=function(v){ return String(v==null?'':v).replace(/[\\'"]/g,''); };   // onclick JS 문자열 안전
    var rows='';
    for(var j=0;j<groups.length;j++){
      var gg=groups[j], parts=[], plain=[];   // parts=표시용(HTML) / plain=보고서 칩 전달용(순수 텍스트)
      if(gg.text){ parts.push('✎ 문구 저장');                          plain.push('✎ 문구 저장'); }
      if(gg.pdf) { parts.push('📎 PDF 변경');                          plain.push('📎 PDF 변경'); }
      if(gg.appr){ parts.push('<b class="erl-hstappr">✔ 승인</b>');     plain.push('✔ 승인'); }
      if(gg.cncl){ parts.push('<b class="erl-hstcncl">↩ 승인취소</b>'); plain.push('↩ 승인취소'); }
      var label=plain.join(' · '), uu=decUser(gg.reguser)||'-';
      var selCls = (selKey && String(gg.regdttm)===String(selKey)) ? ' erl-hstsel' : '';   // 선택했던 이력 강조
      // 이력 = '그 저장 직전(이전) 내용' — 그 행이 보관한 스냅샷을 그대로 사용.
      //   (최신 행을 눌러도 마지막 저장 '직전' 내용이 나온다. 최종본은 이력이 아니라 현재 보고서에 있음)
      var snapSeq = gg.seq || '';
      // PDF만 바뀐 이력(문구 스냅샷 없음) → '그 시각에 유효했던 문구'는 그 이후 첫 문구저장 이력에 보관돼 있다.
      //   (HST 는 덮어쓰기 직전 스냅샷이므로, 더 최신 행의 스냅샷 = 이 시점의 문구). 없으면 현재 문구가 그 시점 문구.
      if(!snapSeq){ for(var k=j-1;k>=0;k--){ if(groups[k].seq){ snapSeq=groups[k].seq; break; } } }
      // 행 클릭 → 그 이력 정보(유형·작성자·시각)까지 넘겨 읽기전용으로 연다
      var oc="erlOpenRO('"+sj(d.hospcd)+"','"+sj(nm)+"','"+sj(d.evalym)+"','"+sj(label)+"','"+sj(uu)+"','"+sj(gg.regdttm)+"','"+sj(snapSeq)+"','"+sj(gg.pdfpath)+"')";
      rows += '<tr class="erl-hstrow'+selCls+'" onclick="'+oc+'"><td>'+(j+1)+'</td><td>'+parts.join(' · ')+(selCls?' <span class="erl-selmark">◀ 선택</span>':'')+'</td>'
            + '<td>'+esc(uu)+'</td><td>'+esc(gg.regdttm||'')+'</td></tr>';
    }
    return '<div class="erl-hstbox">'
         + '<div class="erl-hsttit">📜 변경 이력 <span class="erl-hstsub">('+groups.length+'건) · 행을 클릭하면 <b>읽기전용</b>으로 열람(저장·승인·PDF첨부 불가)</span></div>'
         + '<table class="erl-hsttbl"><thead><tr><th>#</th><th>유형</th><th>작성자</th><th>시각</th></tr></thead>'
         + '<tbody>'+rows+'</tbody></table></div>';
  }
  // 읽기전용 열기 — 선택한 이력 정보(라벨·작성자·시각)를 sessionStorage 로 넘겨 보고서 상단에 표시.
  //   + erlExpand: 돌아왔을 때 그 행을 다시 펼치고 선택 이력을 강조하기 위한 상태(원샷).
  window.erlOpenRO = function(hospCd, hospNm, ym, label, user, time, hstSeq, hstPdf){
    try{
      // hstSeq = 그 시점 문구 스냅샷 / hstPdf = 그 시점 첨부 PDF 경로(있으면 이력 열람에서 그 PDF 보기)
      sessionStorage.setItem('erOpenHstInfo', JSON.stringify({ label:label||'', user:user||'', time:time||'', seq:hstSeq||'', pdf:hstPdf||'' }));
      sessionStorage.setItem('erlExpand', JSON.stringify({ hospcd:hospCd, evalym:ym, selKey:time||'' }));
    }catch(e){}
    goReport(hospCd, hospNm, ym, false, true);
  };
  // 목록으로 돌아왔을 때: 저장된 펼침 상태(erlExpand)가 있으면 그 행을 다시 펼치고 선택 이력 강조(1회 소비)
  function restoreExpand(){
    var raw=''; try{ raw=sessionStorage.getItem('erlExpand')||''; }catch(e){}
    if(!raw) return;
    var st=null; try{ st=JSON.parse(raw); }catch(e){}
    try{ sessionStorage.removeItem('erlExpand'); }catch(e){}   // 원샷
    if(!st || !st.hospcd || !st.evalym || !DT) return;
    var target=null;
    DT.rows({page:'current'}).every(function(){
      var d=this.data();
      if(d && String(d.hospcd)===String(st.hospcd) && String(d.evalym)===String(st.evalym)){ target=this; return false; }
    });
    if(!target) return;
    var tr=jQuery(target.node()), tog=tr.find('td .erl-exp');
    if(!tog.length || target.child.isShown()) return;
    var d=target.data();
    jQuery.ajax({ url:ctx+'/main/listEvalReportHst.do', type:'POST', dataType:'json', data:{ hospCd:d.hospcd, evalYm:d.evalym },
      success:function(res){
        var list=(res&&res.result==='OK')?(res.list||[]):[];
        if(!hstShownCnt(list)){ tog.remove(); return; }        // 표시할 이력 없으면 [+] 제거
        target.child(hstHtml(list, d, st.selKey)).show(); tr.addClass('erl-open'); tog.text('−').attr('title','변경 이력 접기');
        var sel = tr.next().find('.erl-hstsel')[0]; if(sel && sel.scrollIntoView){ try{ sel.scrollIntoView({block:'center'}); }catch(e){} }
      }
    });
  }
  function _stripTags(data){
    if(data==null) return '';
    if(typeof data!=='string') return data;
    return data.indexOf('<')!==-1 ? data.replace(/<[^>]*>/g,'').trim() : data;
  }

  // 로드된 목록(LAST=그 해 전체)에서 병원·월·상태·첨부로 필터 → 그리드 주입(자료검색·정렬·페이징은 DataTables)
  window.erlFilter = function(){
    if(!DT) return;
    var mo=el('erl-month')?el('erl-month').value:'', hosp=el('erl-hosp')?el('erl-hosp').value:'',
        stt=el('erl-status')?el('erl-status').value:'', pf=el('erl-pdf')?el('erl-pdf').value:'';
    var rows=LAST.filter(function(r){
      if(hosp && String(r.hospcd||'')!==hosp) return false;
      if(mo){ var ym=String(r.evalym||''); if(ym.substring(4,6)!==mo) return false; }
      if(stt){ var s=(r.status==='APPROVED')?'APPROVED':'DRAFT'; if(s!==stt) return false; }
      if(pf){ var has=(r.haspdf==='Y')?'Y':'N'; if(has!==pf) return false; }
      return true;
    });
    DT.clear(); DT.rows.add(rows); DT.draw();
  };

  window.erlLoad = function(){
    var yr = el('erl-year').value;
    var hosp = isWinner ? '' : (ownHospCd||'');   // 위너넷=전체 로드(클라 필터), 거래처=본인(서버도 강제)
    jQuery.ajax({ url:ctx+'/main/listEvalReport.do', type:'POST', dataType:'json', data:{ evalYear:yr, hospCd:hosp },
      success:function(res){
        LAST = (res && res.result==='OK') ? (res.list||[]) : [];
        erlFilter();
        try{ restoreExpand(); }catch(e){}   // 보고서에서 돌아온 경우 펼침 복원
      },
      error:function(){ LAST=[]; erlFilter(); }
    });
  };

  /* ===== 메일주소 일괄등록 / 등록 현황 관리 — 위너넷 전용 =====
     입력은 두 갈래(엑셀 파일 · 붙여넣기)지만 파싱 결과는 같은 _bulkRows 로 모아 한 번에 저장한다.
     열 순서: 요양기관기호 | 이메일 | 이름(선택). 첫 줄이 머리글이면 자동으로 건너뛴다. */
  var _bulkRows = [];
  window.erlBulkOpen = function(){
    _bulkRows = [];
    var _bt=el('erl-bulkText'), _bf=el('erl-bulkFile');
    if(_bt) _bt.value=''; if(_bf) _bf.value='';
    el('erl-inHosp').value=''; el('erl-inEmail').value=''; el('erl-inName').value='';
    el('erl-inHospNm').textContent='기관기호를 입력하세요'; el('erl-inHospNm').className='erl-inhospnm';
    erlBulkPreview();
    el('erl-bulkNote').textContent='';
    erlHospPickClose();
    el('erl-bulkModal').style.display='flex';
    erlAddrAllLoad();
    setTimeout(function(){ el('erl-inHosp').focus(); }, 100);
  };
  /* 병원 검색 팝업 — 이미 받아둔 HOSP_NM(기호→병원명) 에서 걸러 고른다. 서버 조회가 없어 즉시 반응한다. */
  window.erlHospPickOpen = function(){
    el('erl-hospPop').classList.add('on');
    el('erl-hospPopQ').value = (el('erl-inHosp').value||'').trim();
    erlHospPickRender();
    setTimeout(function(){ el('erl-hospPopQ').focus(); }, 50);
  };
  window.erlHospPickClose = function(){ var p=el('erl-hospPop'); if(p) p.classList.remove('on'); };
  window.erlHospPickRender = function(){
    var q=((el('erl-hospPopQ').value)||'').trim().toLowerCase();
    var codes=Object.keys(HOSP_NM).sort(function(a,b){ return (HOSP_NM[a]||'').localeCompare(HOSP_NM[b]||''); });
    var h='', n=0;
    codes.forEach(function(cd){
      var nm=HOSP_NM[cd]||'';
      if(q && cd.toLowerCase().indexOf(q)<0 && nm.toLowerCase().indexOf(q)<0) return;
      if(n++ >= 200) return;                                  // 너무 많으면 앞부분만(검색해서 좁히도록)
      h += '<div class="hp-row" onclick="erlHospPickSel(\''+_sj(cd)+'\')">'
         +   '<span class="cd">'+esc(cd)+'</span><span class="nm">'+esc(nm)+'</span></div>';
    });
    el('erl-hospPopList').innerHTML = h || '<div class="hp-none">검색 결과가 없습니다.</div>';
  };
  window.erlHospPickSel = function(cd){
    el('erl-inHosp').value = cd;
    erlInHospNm();
    erlHospPickClose();
    el('erl-inEmail').focus();
  };

  /* 기관기호 → 병원명 표시. 목록에 없는 기호면 빨갛게 알려준다 */
  window.erlInHospNm = function(){
    var cd=(el('erl-inHosp').value||'').trim(), box=el('erl-inHospNm');
    if(!cd){ box.textContent='기관기호를 입력하세요'; box.className='erl-inhospnm'; return; }
    var nm=HOSP_NM[cd];
    if(nm){ box.textContent='✔ '+nm; box.className='erl-inhospnm ok'; }
    else   { box.textContent='등록된 병원이 아닙니다'; box.className='erl-inhospnm ng'; }
  };
  /* 한 건 추가 — 목록(_bulkRows)에 쌓고 입력칸을 비워 다음 건을 바로 넣게 한다 */
  window.erlBulkAdd = function(){
    var cd=(el('erl-inHosp').value||'').trim();
    var em=(el('erl-inEmail').value||'').trim();
    var nm=(el('erl-inName').value||'').trim();
    if(!cd){ el('erl-bulkNote').textContent='요양기관기호를 입력하세요.'; el('erl-inHosp').focus(); return; }
    if(em.indexOf('@')<1){ el('erl-bulkNote').textContent='이메일 형식이 올바르지 않습니다.'; el('erl-inEmail').focus(); return; }
    var dup=_bulkRows.some(function(r){ return r.hospCd===cd && r.email.toLowerCase()===em.toLowerCase(); });
    if(dup){ el('erl-bulkNote').textContent='이미 목록에 있는 주소입니다.'; return; }
    _bulkRows.push({ hospCd:cd, email:em, addrNm:nm });
    el('erl-inEmail').value=''; el('erl-inName').value='';   // 기관기호는 남겨 같은 병원 여러 명을 이어서 넣게
    el('erl-bulkNote').textContent='';
    erlBulkPreview();
    el('erl-inEmail').focus();
  };
  window.erlBulkDel = function(i){ _bulkRows.splice(i,1); erlBulkPreview(); };
  window.erlBulkClose = function(){ el('erl-bulkModal').style.display='none'; };

  /* 엑셀·붙여넣기 — 화면 입력과 같은 _bulkRows 로 모아 한 번에 저장한다.
     열 순서: 기관기호 | 이메일 | 성함. 머리글로 보이는 첫 줄은 건너뛴다. */
  function _bulkPush(out, cd, em, nm){
    cd=String(cd==null?'':cd).trim(); em=String(em==null?'':em).trim(); nm=String(nm==null?'':nm).trim();
    if(!cd && !em) return;
    if(em.indexOf('@')<1 && /기관|기호|이메일|메일|주소|이름|성함/.test(cd+em)) return;   // 머리글 줄
    out.push({ hospCd:cd, email:em, addrNm:nm });
  }
  /* 양식 엑셀 내려받기 — 열 순서를 맞춘 빈 양식(예시 2줄 포함) */
  window.erlBulkSample = function(){
    if(typeof XLSX==='undefined'){ erlSwal('warning','엑셀 라이브러리를 불러오지 못했습니다.'); return; }
    var aoa=[['요양기관기호','이메일','성함/직책'],
             ['11223344','hospital@example.com','김간호 팀장'],
             ['11282347','staff@example.com','']];
    var wb=XLSX.utils.book_new();
    XLSX.utils.book_append_sheet(wb, XLSX.utils.aoa_to_sheet(aoa), '수신자');
    XLSX.writeFile(wb, '메일수신자_등록양식.xlsx');
  };
  window.erlBulkFile = function(input){
    var f=input.files && input.files[0]; if(!f) return;
    if(typeof XLSX==='undefined'){ el('erl-bulkNote').textContent='엑셀 라이브러리를 불러오지 못했습니다. 붙여넣기를 이용하세요.'; return; }
    var fr=new FileReader();
    fr.onload=function(e){
      try{
        var wb=XLSX.read(new Uint8Array(e.target.result), {type:'array'});
        var ws=wb.Sheets[wb.SheetNames[0]];
        var aoa=XLSX.utils.sheet_to_json(ws, {header:1, raw:false, defval:''});
        var out=[]; aoa.forEach(function(r){ _bulkPush(out, r[0], r[1], r[2]); });
        // 이메일이 하나도 없으면 양식이 다른 파일이다 — 그대로 담으면 '형식오류' 수백 건이 쌓인다
        var mails = out.filter(function(r){ return r.email.indexOf('@')>0; }).length;
        if(!mails){
          input.value='';
          erlSwal('warning','이 파일에서 이메일을 찾지 못했습니다.\nA열 기관기호 · B열 이메일 · C열 성함 순서인지 확인하세요.\n[⬇ 양식 받기] 로 양식을 내려받을 수 있습니다.', {title:'양식이 다릅니다'});
          return;
        }
        out.forEach(function(r){
          if(!_bulkRows.some(function(x){ return x.hospCd===r.hospCd && x.email.toLowerCase()===r.email.toLowerCase(); })) _bulkRows.push(r);
        });
        erlBulkPreview();
      }catch(err){ el('erl-bulkNote').textContent='엑셀을 읽지 못했습니다: '+err.message; }
    };
    fr.readAsArrayBuffer(f);
  };

  /* 미리보기 — 등록 전에 기관기호가 실제 병원인지, 이메일 형식이 맞는지 표시한다.
     HOSP_NM 은 병원 셀렉트를 채울 때 이미 받아둔 목록이라 추가 조회가 필요 없다. */
  function erlBulkPreview(){
    if(!_bulkRows.length){ el('erl-bulkPreview').innerHTML='<div class="erl-addrempty">아직 담긴 내용이 없습니다. 위에서 [＋ 추가] 하거나 엑셀 파일을 고르세요. 여기 담긴 것만 [💾 등록] 으로 저장됩니다.</div>'; return; }
    var okN=0, ngN=0, h='<table class="erl-btbl"><thead><tr><th>기관기호</th><th>병원명</th><th>이메일</th><th>성함/직책</th><th>확인</th><th></th></tr></thead><tbody>';
    _bulkRows.forEach(function(r, i){
      var nm=HOSP_NM[r.hospCd]||'';
      var bad = (!r.hospCd || r.email.indexOf('@')<1) ? '형식오류' : (nm ? '' : '기관기호 없음');
      if(bad) ngN++; else okN++;
      h += '<tr class="'+(bad?'erl-bad':'')+'"><td>'+esc(r.hospCd)+'</td><td>'+esc(nm||'-')+'</td><td>'+esc(r.email)+'</td><td>'+esc(r.addrNm||'')+'</td>'
         + '<td>'+(bad? '<span style="color:#c0392b">'+bad+'</span>' : '<span style="color:#2e7d32">확인</span>')+'</td>'
         + '<td><button type="button" class="del" title="목록에서 빼기" onclick="erlBulkDel('+i+')">✕</button></td></tr>';
    });
    h += '</tbody></table>';
    el('erl-bulkPreview').innerHTML = h;
    el('erl-bulkNote').textContent = '총 '+_bulkRows.length+'건 · 등록 가능 '+okN+'건'
      + (ngN? (' · 확인 필요 '+ngN+'건 (기관기호가 목록에 없거나 이메일 형식 오류)') : '');
  }
  window.erlBulkSave = function(){
    if(!_bulkRows.length){ el('erl-bulkNote').textContent='등록할 자료가 없습니다. 먼저 [확인하기]를 누르세요.'; return; }
    var valid=_bulkRows.filter(function(r){ return r.hospCd && r.email.indexOf('@')>0; });
    if(!valid.length){ el('erl-bulkNote').textContent='형식이 맞는 행이 없습니다.'; return; }
    erlConfirm(valid.length+'건을 주소록에 등록할까요?\n(같은 병원의 같은 주소는 중복 등록되지 않고 이름만 갱신됩니다)', function(){
      var btn=el('erl-bulkSaveBtn'); btn.disabled=true; btn.textContent='💾 등록 중…';
      jQuery.ajax({ url:ctx+'/main/evalMailAddrBulk.do', type:'POST', contentType:'application/json', dataType:'json',
        data: JSON.stringify(valid),
        success:function(r){
          btn.disabled=false; btn.textContent='💾 등록';
          if(!r || r.result!=='OK'){ erlSwal('error',(r&&r.message)?r.message:'등록에 실패했습니다.'); return; }
          _bulkRows=[];
          var _bt2=el('erl-bulkText'), _bf2=el('erl-bulkFile');
          if(_bt2) _bt2.value=''; if(_bf2) _bf2.value='';
          erlBulkPreview();
          el('erl-bulkNote').textContent='';
          erlAddrAllLoad();
          erlSwal('success','등록 '+r.okCnt+'건'+((r.ngCnt||0)? (' · 실패 '+r.ngCnt+'건') : ''), {title:'일괄등록 완료'});
        },
        error:function(){ btn.disabled=false; btn.textContent='💾 등록'; erlSwal('error','서버 통신 오류로 등록하지 못했습니다.'); }
      });
    });
  };
  /* 등록 현황 — 전체 병원의 주소록. 여기서 바로 지울 수 있다(소프트 삭제) */
  window.erlAddrAllLoad = function(){
    var q=(el('erl-addrFind')?el('erl-addrFind').value:'')||'';
    jQuery.ajax({ url:ctx+'/main/evalMailAddrAll.do', type:'POST', dataType:'json', data:{ findData:q },
      success:function(r){
        var list=(r&&r.result==='OK')?(r.list||[]):[];
        if(!list.length){ el('erl-addrAllBox').innerHTML='<div class="erl-addrempty">등록된 주소가 없습니다.</div>'; return; }
        var h='<table class="erl-btbl"><thead><tr><th>기관기호</th><th>병원명</th><th>이름/직책</th><th>이메일</th><th>수정일</th><th>수정</th><th>삭제</th></tr></thead><tbody>';
        list.forEach(function(a){
          var oc = "erlAddrEdit('"+_sj(a.hospcd)+"','"+_sj(a.email)+"','"+_sj(a.addrnm||'')+"')";
          h += '<tr><td>'+esc(a.hospcd)+'</td><td>'+esc(a.hospnm||'-')+'</td><td>'+esc(a.addrnm||'')+'</td><td>'+esc(a.email)+'</td>'
             + '<td>'+esc(a.upddttm||'')+'</td>'
             + '<td><button type="button" class="edt" title="이 주소를 위 입력칸으로 불러와 고칩니다" onclick="'+oc+'">✎</button></td>'
             + '<td><button type="button" class="del" title="삭제" onclick="erlAddrAllDel('+Number(a.addrseq)+')">✕</button></td></tr>';
        });
        el('erl-addrAllBox').innerHTML = h+'</tbody></table>';
      },
      error:function(){ el('erl-addrAllBox').innerHTML='<div class="erl-addrempty">조회 중 오류가 발생했습니다.</div>'; }
    });
  };
  /* 등록된 주소 수정 — 값을 위 입력칸으로 불러온다.
     이름/직책만 고쳐 [＋추가]→[등록] 하면 같은 병원+같은 이메일이라 새 행이 생기지 않고 이름만 갱신된다.
     이메일 자체를 바꾸려면 기존 것을 ✕ 로 지우고 새로 등록해야 한다(이메일이 키라서). */
  window.erlAddrEdit = function(hospCd, email, addrNm){
    el('erl-inHosp').value = hospCd; erlInHospNm();
    el('erl-inEmail').value = email;
    el('erl-inName').value  = addrNm;
    el('erl-bulkNote').textContent = '';   // 안내문 없이 값만 불러온다(사용자 요청 — 문구가 길어 화면이 복잡)
    el('erl-inName').focus();
    try{ el('erl-inName').select(); }catch(e){}
  };
  window.erlAddrAllDel = function(addrSeq){
    erlConfirm('이 주소를 주소록에서 뺄까요?', function(){
      jQuery.ajax({ url:ctx+'/main/evalMailAddrDel.do', type:'POST', dataType:'json', data:{ addrSeq:addrSeq, hospCd:'' },
        success:function(){ erlAddrAllLoad(); },
        error:function(){ erlSwal('error','삭제 중 오류가 발생했습니다.'); }
      });
    });
  };

  /* 메일 발송 설정 도움말 — 위너넷에게만 보인다(버튼 노출은 아래 초기화에서 처리).
     담당자가 바뀌거나 앱 비밀번호를 다시 발급할 때 참고하도록 화면에 남겨 둔다. */
  window.erlHelp = function(){
    var html =
      '<div class="erl-guide">'
      + '<h4>1. 왜 앱 비밀번호가 필요한가</h4>'
      + '구글은 프로그램이 계정 비밀번호로 메일 보내는 것을 막습니다. 그래서 <b>앱 비밀번호</b>(프로그램 전용 16자리)를 따로 발급받아야 합니다.'
      + '<h4>2. 발급 방법</h4>'
      + '<ol>'
      +   '<li>보낼 구글 계정으로 로그인한 뒤 <b>2단계 인증</b>을 켭니다.<br><code>https://myaccount.google.com/signinoptions/twosv</code></li>'
      +   '<li><code>https://myaccount.google.com/apppasswords</code> 접속</li>'
      +   '<li>앱 이름은 아무거나(예: WinCheck) 입력 후 <b>만들기</b></li>'
      +   '<li><code>abcd efgh ijkl mnop</code> 형태의 16자리가 나옵니다 → <b>공백을 빼고</b> 복사<br>'
      +       '<span style="color:#8a5a00">이 화면을 닫으면 다시 볼 수 없습니다. 잃어버리면 새로 발급하면 됩니다.</span></li>'
      + '</ol>'
      // 서버 설정은 개발자·운영담당 몫이라 기본은 접어 둔다(필요할 때만 펼침)
      + '<details class="erl-dev"><summary>3. 서버 설정 <span>(개발자용 — 눌러서 펼치기)</span></summary>'
      +   '<code>WEB-INF/classes/mail.properties</code> 의 값을 채우고 <b>톰캣을 재시작</b>합니다.'
      +   '<ol>'
      +     '<li><code>mail.enabled=true</code></li>'
      +     '<li><code>mail.smtp.user</code> = 보내는 구글 계정 주소</li>'
      +     '<li><code>mail.smtp.password</code> = 앱 비밀번호 16자리(공백 없이)</li>'
      +     '<li><code>mail.from</code> = user 와 같은 주소</li>'
      +   '</ol>'
      +   '구글 기준 <code>host=smtp.gmail.com / port=587 / ssl=false</code> 는 이미 설정돼 있습니다.'
      + '</details>'
      + '</div>';
    // 도움말은 내용이 길어 넓은 창이 필요하므로 Swal 을 그대로 쓴다(알림·확인은 _alertBox/_confirmBox 사용)
    if(typeof Swal === 'undefined'){ alert('메일 발송 설정: mail.properties 에 구글 계정·앱 비밀번호를 넣고 톰캣을 재시작하세요.'); return; }
    Swal.fire({ title:'메일 발송 설정 도움말', html:html, width:680, heightAuto:false,
                confirmButtonText:'닫기' });
  };

  /* ===== 메일 발송 (목록에서 바로) — 위너넷 전용 =====
     · 대상은 '승인됨 + 첨부 있음' 뿐(버튼 자체가 그때만 그려지고, 서버에서도 다시 막는다).
     · 제목·본문 기본값은 서버가 표준문구(mail_subject/mail_body)에 점수를 채워 내려준다.
     · 받는 사람은 수동 입력. 마지막 발송 주소가 있으면 그대로 제안한다(이메일 별도 관리 붙기 전까지). */
  var _erlMail = null;
  window.erlMailOpen = function(hospCd, evalYm, hospNm){
    _erlMail = { hospCd:hospCd, evalYm:evalYm, hospNm:hospNm };
    el('erl-mailWho').textContent = '— ' + (hospNm||'') + ' ' + (String(evalYm).length===6 ? (evalYm.substring(0,4)+'.'+evalYm.substring(4,6)) : evalYm);
    el('erl-mailTo').value=''; el('erl-mailSubject').value=''; el('erl-mailBody').value='';
    el('erl-mailNote').textContent = '기본 문구를 불러오는 중…';
    el('erl-mailModal').style.display = 'flex';
    jQuery.ajax({ url:ctx+'/main/evalReportMailForm.do', type:'POST', dataType:'json',
      data:{ hospCd:hospCd, evalYm:evalYm, hospNm:hospNm||'' },
      success:function(r){
        if(!r || r.result!=='OK'){ el('erl-mailNote').textContent = (r&&r.message)?r.message:'기본 문구를 불러오지 못했습니다.'; return; }
        el('erl-mailSubject').value = r.subject||'';
        el('erl-mailBody').value    = r.content||'';
        // 주소록이 있으면 전부 선택해 '받는 사람'을 채우고, 비어 있으면 마지막 발송 주소를 제안
        erlAddrRender(r.addrs||[], r.cands||[], true);
        if(!(r.addrs||[]).length) el('erl-mailTo').value = r.lastEmail||'';
        el('erl-mailNote').textContent = (r.hasPdf==='Y') ? '' : '첨부된 PDF가 없습니다. 보고서 화면에서 [📎 PDF첨부] 후 보내세요.';
      },
      error:function(){ el('erl-mailNote').textContent = '기본 문구 조회 중 오류가 발생했습니다.'; }
    });
  };
  window.erlMailClose = function(){ el('erl-mailModal').style.display='none'; };

  /* 수신자 — 등록된 주소가
       0건 : 선택 영역 숨김. [받는 사람]에 직접 입력하거나 마지막 발송 주소를 쓴다
       1건+: 선택 영역 표시(전부 체크된 상태 = 자동 선택). 체크를 바꾸면 [받는 사람]이 다시 만들어진다
             ※ 1건이어도 누구에게 가는지 눈으로 확인되게 보여준다(2026-07-29 요청) */
  function erlAddrRender(list, cands, checkAll){
    var sect=el('erl-addrSect'), box=el('erl-addrBox');
    if(!list.length){ sect.style.display='none'; box.innerHTML=''; return; }
    sect.style.display='';
    var html='';
    list.forEach(function(a){
      html += '<div class="erl-addrrow">'
           +   '<input type="checkbox" class="erl-addrchk" value="'+esc(a.email)+'"'+(checkAll?' checked':'')+' onchange="erlAddrSync()">'
           +   '<span class="nm">'+(a.addrnm? esc(a.addrnm) : '&nbsp;')+'</span>'
           +   '<span class="em">'+esc(a.email)+'</span>'
           + '</div>';
    });
    box.innerHTML = html;
    erlAddrSync();
  }
  /* 체크된 주소 → '받는 사람' 입력칸 (직접 입력한 주소는 유지하지 않고 체크 기준으로 다시 만든다) */
  window.erlAddrSync = function(){
    var picked=[];
    jQuery('#erl-addrBox .erl-addrchk:checked').each(function(){ picked.push(this.value); });
    if(picked.length) el('erl-mailTo').value = picked.join(', ');
  };
  /* 발송창에서는 주소를 더하거나 지우지 않는다 — 관리는 [📥 메일주소 일괄등록] 창에서만(2026-07-29 확정) */
  window.erlMailSend = function(){
    if(!_erlMail) return;
    var to=(el('erl-mailTo').value||'').trim();
    if(!to){ el('erl-mailNote').textContent='받는 사람 주소를 입력하세요.'; el('erl-mailTo').focus(); return; }
    // 실제로 나가는 작업이라 보내기 전에 '어느 병원 · 어느 주소'인지 눈으로 확인시킨다
    var ym = String(_erlMail.evalYm||''); ym = (ym.length===6) ? (ym.substring(0,4)+'.'+ym.substring(4,6)) : ym;
    erlConfirm('<b style="font-size:17px">' + esc(_erlMail.hospNm||'') + '</b><br>'
             + '<span style="color:#6b7a89">' + esc(ym) + ' 월보고서</span><br><br>'
             + esc(to) + '<br>로 보낼까요?',
             function(){ _erlMailDoSend(to); });
  };
  function _erlMailDoSend(to){
    var btn=el('erl-mailSendBtn'); btn.disabled=true; btn.textContent='📨 보내는 중…';
    var html = String(el('erl-mailBody').value||'').replace(/\n/g,'<br>');   // 줄바꿈만 살려 HTML 메일로
    jQuery.ajax({ url:ctx+'/main/sendEvalReportMail.do', type:'POST', contentType:'application/json', dataType:'json',
      data: JSON.stringify({ hospCd:_erlMail.hospCd, evalYm:_erlMail.evalYm, to:to,
                             subject:el('erl-mailSubject').value, content:html }),
      success:function(r){
        btn.disabled=false; btn.textContent='📨 보내기';
        if(r && r.result==='OK'){
          erlMailClose(); erlLoad();
          erlSwal('success','메일을 보냈습니다.\n' + to);   // 제목 없이 본문만(사용자 요청)
        } else {
          var msg = (r&&r.message)?r.message:'발송에 실패했습니다.';
          el('erl-mailNote').textContent = msg;      // 창 안에도 사유를 남겨 바로 고쳐 다시 보낼 수 있게
          erlSwal('error', msg, {title:'발송 실패'});
        }
      },
      error:function(){
        btn.disabled=false; btn.textContent='📨 보내기';
        el('erl-mailNote').textContent='서버 통신 오류로 보내지 못했습니다.';
        erlSwal('error','서버 통신 오류로 보내지 못했습니다.', {title:'발송 실패'});
      }
    });
  };

  function reportUrl(hospCd, hospNm, ym, autoprint){
    return ctx + '/main/evalReport.do?hospCd=' + encodeURIComponent(hospCd)
         + '&hospNm=' + encodeURIComponent(hospNm||'')
         + '&ym=' + encodeURIComponent(ym) + '&ret=list' + (autoprint ? '&autoprint=1' : '');
  }
  function goReport(hospCd, hospNm, ym, autoprint, readonly){
    if(!hospCd) return;
    try{
      sessionStorage.setItem('erOpenHospCd', hospCd);
      sessionStorage.setItem('erOpenHospNm', hospNm||'');
      sessionStorage.setItem('erOpenYm', ym||'');
      sessionStorage.setItem('erOpenAutoprint', autoprint ? '1' : '');
      sessionStorage.setItem('erOpenReadonly', readonly ? '1' : '');   // 이력 열람 = 읽기전용(저장·승인·PDF첨부 잠금)
      sessionStorage.setItem('erlSelRow', JSON.stringify({ hospcd:hospCd, evalym:ym }));   // 돌아왔을 때 이 행 선택유지·강조
      sessionStorage.setItem('erFromList', '1');
      sessionStorage.setItem('erFromListYear', el('erl-year').value);
    }catch(e){}
    location.href = reportUrl(hospCd, hospNm, ym, autoprint) + (readonly ? '&ro=1' : '');
  }
  window.erlOpen = function(hospCd, hospNm, ym){ goReport(hospCd, hospNm, ym, false, false); };

  // 레이아웃 보정 — 좌측 사이드바(fixed/absolute)가 콘텐츠를 덮을 때 그만큼 우측으로 민다.
  function erlFixLayout(){
    var root=el('evalReportList'); if(!root) return;
    var sb=document.querySelector('.nav-left-sidebar'), left=0;
    if(sb){ var pos=''; try{ pos=getComputedStyle(sb).position; }catch(e){}
      if(pos==='fixed'||pos==='absolute'){ var r=sb.getBoundingClientRect(); if(r.width>0 && r.left<=1) left=Math.round(r.right); } }
    root.style.paddingLeft=(left ? (left+16) : 16)+'px';
    if(DT){ try{ DT.columns.adjust(); }catch(e){} }
  }
  window.addEventListener('resize', erlFixLayout);

  // 보고서에서 돌아온 경우 선택유지할 행(원샷) — buildGrid 의 draw 핸들러가 강조
  try{ var _ssel=sessionStorage.getItem('erlSelRow'); if(_ssel){ _erlSel=JSON.parse(_ssel); sessionStorage.removeItem('erlSelRow'); } }catch(e){}

  // 초기화 — 그리드 생성 후 조회
  buildGrid();
  erlLoad();
  // 선택 행으로 스크롤(로드·그리기 후)
  if(_erlSel){ setTimeout(function(){ var n=document.querySelector('#evalReportList tr.erl-selrow'); if(n && n.scrollIntoView){ try{ n.scrollIntoView({block:'center'}); }catch(e){} } }, 400); }
  erlFixLayout(); setTimeout(erlFixLayout,200); setTimeout(erlFixLayout,600);
});
</script>
</div>
