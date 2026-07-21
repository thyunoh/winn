<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<%-- evalReport.jsp — 적정성평가 월간 컨설팅 보고서 (실제 화면). 진입: main/report.do → report.jsp(shim) → 여기.
     위너넷 편집·저장·승인 → 거래처 열람·인쇄.
     · 수치(구조/진료/종합·지표표·우선지표)는 /main/select_Eval_Indi.do 로 자동 채움(병원·월별)
     · 문구는 편집영역(.er-editable[data-key]) → /main/saveEvalReport.do 로 저장(override)
     · 승인 시 수치 스냅샷 동결 → 거래처 공개
     모든 스타일/클래스는 #evalReport 하위로 스코프(er- 접두)해 앱 화면과 충돌 방지 --%>

<div id="evalReport">
<style>
  #evalReport{
    /* ===== 네이비 테마 — 원본 컨설팅 PDF 컨셉(고객 확정 2026-07-15). 변수값만 교체하면 카드·표·섹션·콜아웃 일괄 반영 =====
       부족(red)·달성(green)·목표(amber)는 강조용 유지 */
    --er-paper:#fff; --er-bg:#eef2f7; --er-ink:#1a2332; --er-soft:#44546a;
    --er-line:#d7dfea; --er-line2:#e8eef5; --er-navy:#1e3c72; --er-navy2:#2a5298; --er-navytint:#f2f6fc;
    --er-bad:#c0392b; --er-badtint:#fdecea; --er-good:#2e7d32; --er-goodtint:#eaf5ec;
    --er-amber:#b7791f; --er-ambertint:#fbf3e2;
    background:var(--er-bg); color:var(--er-ink); padding-bottom:50px;
    font-family:"Malgun Gothic","Apple SD Gothic Neo","Noto Sans KR","Segoe UI",sans-serif;
  }
  #evalReport *{ box-sizing:border-box; }
  #evalReport .er-num{ font-variant-numeric:tabular-nums; }

  /* 툴바 — 화면 상단 고정(사이드바 오른쪽·앱 헤더 아래). 흰 카드 + 좌측 포인트 보더. top/left 는 JS(erFixToolbar) 실측 */
  /* 툴바 — 모든 컨트롤 한 줄 고정(nowrap). 화면이 좁으면 줄바꿈 대신 가로 스크롤 */
  #evalReport .er-toolbar{ position:fixed; top:56px; left:280px; right:0; z-index:1020; display:flex; align-items:center; gap:6px;
    padding:8px 10px; background:#fff; border-bottom:1px solid var(--er-line); border-left:4px solid var(--er-navy2);
    flex-wrap:nowrap; overflow-x:auto; overflow-y:visible; white-space:nowrap; box-shadow:0 3px 10px rgba(16,22,29,.08); }
  #evalReport .er-toolbar > *{ flex:0 0 auto; }
  #evalReport .er-brand{ font-weight:800; font-size:13px; color:var(--er-ink); display:flex; align-items:center; gap:6px; white-space:nowrap; }
  #evalReport .er-brand .er-dot{ width:9px; height:9px; border-radius:50%; background:linear-gradient(135deg,var(--er-navy),var(--er-navy2)); }
  #evalReport .er-role{ font-size:11px; font-weight:700; color:#fff; background:linear-gradient(135deg,var(--er-navy),var(--er-navy2)); padding:3px 7px; border-radius:20px; }
  #evalReport select.er-sel{ font-family:inherit; font-size:14.5px; padding:7px 7px; border:1px solid var(--er-line); border-radius:7px; background:#fff; color:var(--er-ink); font-weight:800; }
  #evalReport select.er-sel:hover{ border-color:var(--er-navy2); }
  #evalReport .er-hospnm{ font-size:13px; font-weight:700; color:var(--er-navy); }
  #evalReport .er-sp{ flex:1 1 auto; }
  #evalReport .er-status{ display:inline-flex; align-items:center; gap:6px; font-size:13px; font-weight:800; padding:5px 12px; border-radius:7px; border:1px solid transparent; white-space:nowrap; animation:erBadgeBlink 1.3s ease-in-out infinite; }
  #evalReport .er-status .er-sdot{ width:9px; height:9px; border-radius:50%; }
  @keyframes erBadgeBlink{ 0%,100%{ opacity:1; } 50%{ opacity:.75; } }
  /* 이력 열람 표시 칩(툴바) */
  #evalReport .er-hstinfo{ display:inline-flex; align-items:center; gap:6px; font-size:12.5px; font-weight:800; padding:5px 12px; border-radius:7px;
    background:#eef4fb; color:#1f4e79; border:1px solid #bcd4ec; white-space:nowrap; }
  #evalReport .er-hstinfo .er-hstmeta{ font-weight:600; color:#41668c; }
  #evalReport .er-status.er-draft{ background:var(--er-ambertint); color:var(--er-amber); border-color:#ead9b0; }
  #evalReport .er-status.er-draft .er-sdot{ background:var(--er-amber); }
  #evalReport .er-status.er-approved{ background:#dff3e4; color:#1b6e2f; border-color:#93cfa2; font-weight:900; }
  #evalReport .er-status.er-approved .er-sdot{ background:#1e8a3b; box-shadow:0 0 0 2px #cbebd4; }
  /* 신규(미저장) = 회색 / 저장됨 = 파랑 / 수정중(미저장) = 빨강(저장 필요) */
  #evalReport .er-status.er-new{ background:#eef1f5; color:#7a8698; border-color:#dde3ea; }
  #evalReport .er-status.er-new .er-sdot{ background:#9aa4b2; }
  #evalReport .er-status.er-stored{ background:var(--er-navytint); color:var(--er-navy2); border-color:#cfe0f2; }
  #evalReport .er-status.er-stored .er-sdot{ background:var(--er-navy2); }
  #evalReport .er-status.er-dirty{ background:var(--er-badtint); color:var(--er-bad); border-color:#f0b6ae; }
  #evalReport .er-status.er-dirty .er-sdot{ background:var(--er-bad); }
  /* 버튼 — 기본=흰 아웃라인 / 주요=네이비 솔리드 */
  #evalReport .er-btn{ font-family:inherit; font-size:12.5px; font-weight:700; cursor:pointer; padding:7px 8px; border-radius:6px;
    border:1px solid var(--er-line); background:#fff; color:var(--er-soft); transition:.15s; display:inline-flex; align-items:center; gap:4px; white-space:nowrap; }
  #evalReport .er-btn:hover{ background:var(--er-line2); border-color:var(--er-navy2); color:var(--er-navy); }
  #evalReport .er-btn.er-primary{ background:var(--er-navy2); color:#fff; border-color:transparent; }
  #evalReport .er-btn.er-primary:hover{ background:var(--er-navy); color:#fff; }
  #evalReport .er-btn.er-good{ background:var(--er-good); color:#fff; border-color:transparent; }
  #evalReport .er-btn.er-good:hover{ background:#276b2a; color:#fff; }
  #evalReport .er-btn.er-on{ background:var(--er-ambertint); color:var(--er-amber); border-color:#e6cf9e; }
  #evalReport .er-btn:disabled{ opacity:.45; cursor:not-allowed; }
  /* 저장 진행/완료 구분 — 저장 중(호박색·점멸), 저장완료(초록·불투명) */
  #evalReport .er-btn.er-saving{ background:var(--er-ambertint); color:var(--er-amber); border-color:#e6cf9e; opacity:1 !important; animation:erSavePulse .9s ease-in-out infinite; }
  #evalReport .er-btn.er-saved{ background:var(--er-good); color:#fff; border-color:transparent; opacity:1 !important; }
  @keyframes erSavePulse{ 0%,100%{ opacity:1; } 50%{ opacity:.5; } }
  /* SweetAlert2 다이얼로그 — 앱 통일(assessment '재생성 확인')용 컴팩트 스타일. body 직속이라 스코프 없음. */
  .swal2-popup.er-swal{ padding:10px 16px !important; border-radius:6px; }
  .swal2-popup.er-swal .swal2-title{ font-size:1.05em !important; padding:2px 0 1px !important; margin-top:4px !important; color:#3a4250; }
  .swal2-popup.er-swal .swal2-html-container{ font-size:.92em !important; margin:6px 0 0 !important; color:#525a68; line-height:1.5; }
  .swal2-popup.er-swal .swal2-icon{ width:44px; height:44px; margin:6px auto 12px !important; }
  .swal2-popup.er-swal .swal2-icon .swal2-icon-content{ font-size:1.5em; }
  .swal2-popup.er-swal .swal2-actions{ margin-top:10px; gap:8px; }
  .swal2-popup.er-swal .swal2-styled{ font-size:.9em !important; padding:7px 16px !important; border-radius:5px; box-shadow:none !important; }
  /* PDF 미리보기 모달(.er-modal z-index:1300)·토스트(2000) 위로 — 확인창이 모달 뒤로 깔리지 않게 */
  .swal2-container.er-swal-top{ z-index:3000 !important; }
  #evalReport .er-btn.er-exit{ background:#fdecea; color:var(--er-bad); border-color:#f0b6ae; padding:8px 12px; font-size:13px; font-weight:800; }
  #evalReport .er-btn.er-exit:hover{ background:var(--er-bad); color:#fff; border-color:var(--er-bad); }
  #evalReport .er-btn.er-search{ background:var(--er-navy2); color:#fff; border-color:transparent; }
  #evalReport .er-btn.er-search:hover{ background:var(--er-navy); color:#fff; }
  /* 툴바 그룹/구분선 — 버튼을 기능별로 묶어 정렬 */
  #evalReport .er-group{ display:inline-flex; align-items:center; gap:5px; }
  #evalReport .er-searchbox{ display:inline-flex; align-items:center; gap:4px; padding:3px 5px 3px 6px; background:var(--er-navytint); border:1px solid #d5e4f6; border-radius:9px; }
  #evalReport .er-divider{ width:1px; align-self:stretch; min-height:22px; background:#c7d3e2; margin:0 1px; }
  /* 서식 툴바 — 편집 모드에서만 표시. 선택한 글자에 굵게/밑줄/크기/색/형광 적용(본문 강조용, 양식·테마는 불변) */
  #evalReport .er-fmtbar{ display:none; align-items:center; gap:4px; }
  #evalReport.er-editmode .er-fmtbar{ display:inline-flex; }
  #evalReport .er-fmtbar .er-fbtn{ font-family:inherit; font-size:12px; font-weight:800; cursor:pointer; padding:5px 9px;
    border-radius:6px; border:1px solid var(--er-line); background:#fff; color:var(--er-soft); line-height:1; }
  #evalReport .er-fmtbar .er-fbtn:hover{ border-color:var(--er-navy2); background:var(--er-line2); }
  #evalReport .er-fmtbar .er-fsel{ font-family:inherit; font-size:12px; font-weight:700; padding:4px 3px; max-width:96px;
    border:1px solid var(--er-line); border-radius:6px; background:#fff; color:var(--er-ink); cursor:pointer; }
  #evalReport .er-fmtbar .er-fsel:hover{ border-color:var(--er-navy2); }
  /* 색상 A▾ — A 버튼 밑줄 = 최근 선택 색(답변 에디터 스타일), ▾ = 팔레트 열기 */
  #evalReport .er-fcolor{ position:relative; display:inline-flex; }
  #evalReport .er-fmtbar .er-fA{ border-radius:6px 0 0 6px; border-right:none; }
  #evalReport .er-fmtbar .er-fA b{ display:inline-block; line-height:1.05; border-bottom:3px solid #fff3b0; }
  #evalReport .er-fmtbar .er-fcaret{ border-radius:0 6px 6px 0; padding:5px 5px; }
  #evalReport .er-fpal{ display:none; position:absolute; top:calc(100% + 5px); right:0; z-index:1400; width:172px;
    background:#fff; border:1px solid var(--er-line); border-radius:8px; padding:8px 9px; box-shadow:0 8px 24px rgba(16,22,29,.2);
    white-space:normal; }   /* 툴바 nowrap 상속 차단 — 스와치 줄바꿈 복원 */
  #evalReport .er-fpal.er-open{ display:block; }
  #evalReport .er-fpal .er-fpl{ font-size:10.5px; font-weight:800; color:var(--er-soft); margin:4px 0 3px; }
  #evalReport .er-fpal .er-fsw{ display:inline-block; width:21px; height:21px; border-radius:4px; border:1px solid var(--er-line); cursor:pointer; margin:1px 2px 1px 0; vertical-align:middle; }
  #evalReport .er-fpal .er-fsw:hover{ outline:2px solid var(--er-navy2); }
  /* 툴바 좌측 = 병원명만 상시 표시 — '● 월간 컨설팅 보고서' 제목·역할 뱃지는 숨김(사용자 요청 2026-07-20).
     서식바가 붙는 편집 모드에서도 좌측이 병원명만이라 잘림이 줄어듦. 병원명은 항상 표시. */
  #evalReport .er-brand, #evalReport .er-role{ display:none; }
  #evalReport .er-hospnm{ display:inline; }
  /* 도움말 호버 팝오버 — position:fixed 라 아래 콘텐츠 영역을 밀지 않음(공간 미점유). 좌표는 JS(erHelpShow)가 실측 */
  #evalReport .er-helppop{ display:none; position:fixed; z-index:1500; width:min(700px,92vw);
    background:#fff; border:1px solid #cfe0f4; border-left:4px solid var(--er-navy2); border-radius:10px;
    padding:12px 15px; box-shadow:0 10px 30px rgba(16,22,29,.22); font-size:12.5px; line-height:1.8; color:var(--er-navy); }
  #evalReport .er-helppop b{ color:var(--er-navy); }
  /* 병원(거래처) 열람 모드 — 관리 도구 전부 숨김(조회·인쇄·종료만). JS 가 isWinner 아닐 때 er-hospview 부여 */
  #evalReport.er-hospview #er-statusBadge, #evalReport.er-hospview #er-editTools,
  #evalReport.er-hospview .er-fmtbar, #evalReport.er-hospview .er-wnnonly,
  #evalReport.er-hospview .er-notice{ display:none !important; }

  #evalReport .er-notice{ max-width:880px; margin:16px auto 0; padding:12px 16px; border-radius:10px; background:var(--er-navytint);
    border:1px solid #cfe0f4; color:var(--er-navy); font-size:12.5px; line-height:1.6; }

  /* 지면 */
  #evalReport .er-doc{ padding:22px 14px 40px; display:flex; flex-direction:column; align-items:center; gap:20px; }
  #evalReport .er-page{ width:880px; max-width:100%; background:var(--er-paper); box-shadow:0 6px 26px rgba(28,45,72,.14);
    border-radius:6px; padding:46px 50px; }
  @media (max-width:720px){ #evalReport .er-page{ padding:28px 18px; } }

  /* ===== A4 자동 페이지 분할(WYSIWYG) — 화면 = PDF. 원본 섹션(.er-srcpage)은 숨기고 A4 실측 페이지를 생성 ===== */
  #evalReport .er-autopage{ display:none; }
  #evalReport.er-paged .er-srcpage{ display:none !important; }
  #evalReport.er-paged .er-autopage{ display:block; width:210mm; height:297mm; box-sizing:border-box;
    background:var(--er-paper); box-shadow:0 6px 26px rgba(28,45,72,.14); border-radius:4px; margin:0 auto;
    padding:14mm 15mm; overflow:hidden; }
  #evalReport.er-paged .er-autobody{ overflow:hidden; }
  #evalReport.er-paged .er-autopage.er-cover-page{ display:flex; flex-direction:column; align-items:center; justify-content:center; text-align:center; }
  #evalReport.er-paged .er-doc{ gap:16px; }
  #evalReport.er-paged .er-autopage .er-sec{ margin-top:0; }
  /* 같은 장에 이어지는 섹션 헤더는 넉넉한 간격, 장 맨 위 헤더는 간격 없음 */
  #evalReport.er-paged .er-autobody > .er-eyebrow{ margin-top:34px; }
  #evalReport.er-paged .er-autobody > .er-eyebrow:first-child{ margin-top:0; }

  /* 편집 */
  #evalReport .er-editable{ outline:none; border-radius:4px; transition:.12s; }
  /* 편집 모드: 연한 배경 + 어두운 글자 강제(color) — 목표 뱃지 등 흰 글자 영역이 안 보이던 문제 방지 */
  #evalReport.er-editmode .er-editable{ box-shadow:inset 0 0 0 1px #bcd0ea; background:#f7fbff; color:var(--er-ink); cursor:text; }
  #evalReport.er-editmode .er-editable:focus{ box-shadow:inset 0 0 0 2px var(--er-navy2); background:#fff; color:var(--er-ink); }
  /* PDF 캡처 중: 편집영역 파란 하이라이트 강제 제거(PDF에 파란 배경 안 찍히게) */
  #evalReport.er-pdfcap .er-editable, #evalReport.er-pdfcap .er-editable:focus{ box-shadow:none !important; background:transparent !important; }

  /* ===== 표지(1페이지) — 원본 PDF 맨앞장 형식: 가운데 정렬 한 장 ===== */
  #evalReport .er-page.er-cover{ min-height:1120px; display:flex; flex-direction:column; align-items:center; justify-content:center;
    text-align:center; gap:0; }
  #evalReport .er-cover .er-cover-eyebrow{ font-size:14px; font-weight:800; color:var(--er-navy); letter-spacing:7px; margin-bottom:34px; }
  #evalReport .er-cover .er-cover-title{ font-size:33px; font-weight:800; line-height:1.55; color:var(--er-ink); margin-bottom:46px; }
  #evalReport .er-cover .er-cover-meta1{ font-size:15px; font-weight:700; color:var(--er-soft); margin-bottom:14px; }
  #evalReport .er-cover .er-cover-meta2{ font-size:15.5px; font-weight:700; color:var(--er-ink); margin-bottom:40px; }
  #evalReport .er-cover .er-cover-badge{ display:inline-block; background:linear-gradient(135deg,var(--er-navy),var(--er-navy2));
    color:#fff; font-size:20px; font-weight:800; letter-spacing:2px; padding:16px 46px; border-radius:10px;
    box-shadow:0 6px 18px rgba(30,60,114,.28); margin-bottom:56px; }
  #evalReport .er-cover .er-cover-foot{ font-size:12px; color:var(--er-soft); line-height:1.9; }
  @media print{ #evalReport .er-page.er-cover{ min-height:255mm; } }

  /* 표지 */
  #evalReport .er-ctop{ font-size:12.5px; font-weight:700; color:var(--er-navy2); letter-spacing:1px; }
  #evalReport .er-ctitle{ font-size:25px; font-weight:800; line-height:1.35; margin:10px 0 0; }
  #evalReport .er-csub{ margin:14px 0 0; padding:14px 18px; border-radius:12px; background:var(--er-navytint); border:1px solid #d5e4f6;
    display:flex; flex-wrap:wrap; align-items:center; gap:12px 20px; }
  #evalReport .er-csub .er-kv{ font-size:13px; color:var(--er-soft); }
  #evalReport .er-csub .er-kv b{ color:var(--er-ink); }
  #evalReport .er-goalbadge{ margin-left:auto; font-size:13.5px; font-weight:800; color:#fff; padding:7px 15px; border-radius:22px;
    background:linear-gradient(135deg,var(--er-amber),#d99a3a); white-space:nowrap; }
  #evalReport .er-cmeta{ margin-top:12px; font-size:11.5px; color:var(--er-soft); }

  /* 섹션 */
  #evalReport .er-sec{ margin-top:36px; }
  /* 섹션 제목 = 원본 PDF 네이비 바(흰 글자) */
  #evalReport .er-eyebrow{ display:flex; align-items:center; gap:10px; background:linear-gradient(135deg,var(--er-navy),var(--er-navy2));
    color:#fff; border-radius:8px; padding:10px 16px; margin-bottom:18px; }
  #evalReport .er-rn{ font-size:18px; font-weight:800; color:#fff; font-family:"Times New Roman",serif; }
  #evalReport .er-stitle{ font-size:16px; font-weight:800; color:#fff; }
  #evalReport .er-subh{ font-size:14px; font-weight:800; color:var(--er-navy2); margin:22px 0 11px; display:flex; align-items:center; gap:8px; }
  #evalReport .er-subh::before{ content:""; width:4px; height:14px; background:var(--er-navy2); border-radius:2px; }

  /* 점수카드 — 원본 PDF: 구조/진료/종합/부족 4개 한 줄 */
  #evalReport .er-cards{ display:grid; grid-template-columns:repeat(4,1fr); gap:13px; }
  @media (max-width:720px){ #evalReport .er-cards{ grid-template-columns:repeat(2,1fr); } }
  #evalReport .er-card{ border:1px solid var(--er-line); border-radius:12px; padding:15px 17px; background:#fff; position:relative; overflow:hidden; }
  #evalReport .er-card::before{ content:""; position:absolute; left:0; top:0; bottom:0; width:4px; background:linear-gradient(var(--er-navy),var(--er-navy2)); }
  #evalReport .er-card.er-total::before{ background:linear-gradient(var(--er-bad),#e06055); }
  #evalReport .er-card .er-clabel{ font-size:12px; font-weight:700; color:var(--er-soft); }
  #evalReport .er-card .er-cmax{ font-size:10.5px; color:#8a97a8; font-weight:600; }
  #evalReport .er-card .er-cscore{ font-size:32px; font-weight:800; color:var(--er-navy); margin:3px 0 2px; }
  #evalReport .er-card.er-total .er-cscore{ color:var(--er-bad); }
  #evalReport .er-card .er-cfoot{ font-size:11.5px; font-weight:700; color:var(--er-soft); }
  #evalReport .er-gapcard{ border:1px dashed var(--er-bad); background:var(--er-badtint); border-radius:12px; padding:13px 17px; margin-top:13px; }
  #evalReport .er-gapcard .er-clabel{ color:var(--er-bad); }
  #evalReport .er-gapcard .er-cscore{ font-size:28px; font-weight:800; color:var(--er-bad); }

  /* 표 */
  #evalReport .er-tw{ overflow-x:auto; margin-top:6px; border-radius:10px; border:1px solid var(--er-line); }
  #evalReport table.er-tbl{ width:100%; border-collapse:collapse; font-size:12.5px; min-width:560px; }
  /* 셀 구분선(원본 PDF 그리드) — 가로+세로 전체, 마지막 열은 세로선 없음 */
  #evalReport table.er-tbl th, #evalReport table.er-tbl td{ padding:9px 10px; border-bottom:1px solid var(--er-line); border-right:1px solid var(--er-line); text-align:center; }
  #evalReport table.er-tbl th:last-child, #evalReport table.er-tbl td:last-child{ border-right:none; }
  #evalReport table.er-tbl thead th{ background:linear-gradient(135deg,var(--er-navy),var(--er-navy2)); color:#fff; font-weight:700; border-bottom:none; border-right:1px solid rgba(255,255,255,.28); white-space:nowrap; }
  #evalReport table.er-tbl thead th:last-child{ border-right:none; }
  #evalReport table.er-tbl tr.er-grand td{ border-right:1px solid rgba(255,255,255,.28); }
  #evalReport table.er-tbl tr.er-grand td:last-child{ border-right:none; }
  #evalReport table.er-tbl td.er-l, #evalReport table.er-tbl th.er-l{ text-align:left; }
  #evalReport table.er-tbl tr.er-grp td{ background:var(--er-navytint); font-weight:800; color:var(--er-navy); text-align:left; }
  #evalReport table.er-tbl tr.er-sub td{ background:#f4f7fb; font-weight:800; border-top:1.5px solid var(--er-line); }
  #evalReport table.er-tbl tr.er-tot td{ background:#eef3fb; font-weight:800; color:var(--er-navy); border-top:2px solid var(--er-navy); }
  #evalReport .er-b-bad{ color:var(--er-bad); font-weight:800; }
  #evalReport .er-b-good{ color:var(--er-good); font-weight:800; }
  #evalReport .er-zero{ color:#a7b1c0; }
  #evalReport .er-r100{ color:var(--er-good); font-weight:700; }
  /* 등급표(가로형, 원본 PDF) — 목표 컬럼 강조·현재 점수 표기 */
  #evalReport table.er-grade td.er-goalcell{ background:var(--er-badtint); color:var(--er-bad); font-weight:800; }
  #evalReport table.er-grade td.er-curval{ color:var(--er-bad); font-weight:800; }

  /* Ⅱ 상세표(원본 PDF) — 좌측 영역 세로병합·구간 색상·부족분 강조·종합 진네이비 */
  #evalReport table.er-tbl td.er-area{ background:#eef2f9; color:var(--er-navy); font-weight:800; vertical-align:middle; width:46px; line-height:1.35; }
  #evalReport table.er-tbl td.er-area.er-a21{ background:#eef8f0; color:#2e7d32; }
  #evalReport table.er-tbl td.er-area.er-a22{ background:#eef2f9; }
  #evalReport .er-zc b{ display:block; }
  #evalReport .er-zc .er-zr{ font-size:10.5px; font-weight:700; }
  #evalReport .er-z5{ color:var(--er-good); }
  #evalReport .er-z1{ color:var(--er-bad); }
  #evalReport .er-z3{ color:#c47f17; }
  #evalReport td.er-gaphl{ background:var(--er-badtint); color:var(--er-bad); font-weight:800; }
  #evalReport table.er-tbl tr.er-grand td{ background:var(--er-navy); color:#fff; font-weight:800; letter-spacing:2px; }

  #evalReport .er-callout{ margin-top:13px; padding:13px 15px; border-radius:10px; border-left:4px solid var(--er-navy2); background:var(--er-navytint); font-size:12.7px; }
  #evalReport .er-callout .er-coh{ font-weight:800; color:var(--er-navy); margin-bottom:5px; }
  #evalReport .er-fn{ font-size:11px; color:var(--er-soft); margin-top:10px; line-height:1.6; }

  #evalReport .er-ind{ border:1px solid var(--er-line); border-radius:11px; padding:14px 16px; margin-top:12px; background:#fff; }
  #evalReport .er-indh{ display:flex; align-items:center; gap:9px; flex-wrap:wrap; margin-bottom:8px; }
  #evalReport .er-indnm{ font-size:13.5px; font-weight:800; }
  #evalReport .er-indsc{ font-size:12px; font-weight:800; color:var(--er-navy2); background:var(--er-navytint); border:1px solid #d5e4f6; padding:2px 9px; border-radius:16px; }
  /* Ⅲ 지표 블록 — 원본 PDF 양식: 헤더는 카드 밖, '분석 내용' 전체폭 바(만점=연녹/미달=연파랑) */
  #evalReport .er-indhead{ font-size:13.5px; font-weight:800; margin:18px 0 6px; color:var(--er-ink); }
  #evalReport .er-indbox{ border:1px solid var(--er-line); border-radius:8px; overflow:hidden; background:#fff; }
  #evalReport .er-anabar{ text-align:center; font-weight:800; font-size:12px; padding:6px; border-bottom:1px solid var(--er-line); background:#eaf1fb; color:#2f4e8d; }
  #evalReport .er-indbox.er-full .er-anabar{ background:#e9f6ec; color:#2e7d32; }
  #evalReport .er-indbody{ padding:10px 14px 11px; }
  #evalReport .er-hl-bad{ color:var(--er-bad); font-weight:800; }
  #evalReport .er-def{ color:#7c8798; font-size:11.5px; margin:4px 0 0 13px; }
  #evalReport .er-grplabel.er-g10{ background:var(--er-navy); }
  #evalReport .er-grplabel.er-g21{ background:#1f7a66; }
  #evalReport .er-grplabel.er-g22{ background:#6b3fa0; }
  #evalReport .er-ana{ font-size:12.5px; margin:0; }
  #evalReport .er-ana .er-mk{ color:var(--er-navy2); font-weight:800; margin-right:4px; }
  #evalReport .er-plan{ font-size:12.5px; margin:7px 0 0; color:var(--er-good); font-weight:700; }
  #evalReport .er-plan .er-mk{ color:var(--er-good); font-weight:800; margin-right:4px; }
  #evalReport .er-grplabel{ font-size:12px; font-weight:800; color:#fff; background:linear-gradient(135deg,var(--er-navy),var(--er-navy2)); display:inline-block; padding:4px 12px; border-radius:8px; margin:20px 0 4px; }
  #evalReport .er-rec{ border:1px solid var(--er-line); border-left:4px solid var(--er-navy2); border-radius:10px; padding:13px 16px; margin-top:11px; background:#fff; }
  #evalReport .er-rec.er-top{ border-left-color:var(--er-bad); background:linear-gradient(180deg,#fef7f6,#fff 60%); }
  #evalReport .er-rech{ font-size:13px; font-weight:800; margin-bottom:6px; }
  #evalReport .er-rech .er-w{ font-size:11px; font-weight:700; color:var(--er-soft); }
  #evalReport .er-recrow{ font-size:12.5px; margin:4px 0; }
  #evalReport .er-recrow .er-lb{ display:inline-block; min-width:62px; font-weight:800; color:var(--er-navy2); }
  #evalReport .er-recgoal{ margin-top:6px; padding-top:6px; border-top:1px dashed var(--er-line); font-size:12.5px; color:var(--er-good); font-weight:700; }
  #evalReport .er-after{ margin-top:15px; display:flex; align-items:center; justify-content:center; gap:14px; flex-wrap:wrap;
    padding:16px; border-radius:12px; background:var(--er-goodtint); border:1px solid #bfe0c4; }
  #evalReport .er-after .er-lbl{ font-size:12.5px; font-weight:700; color:var(--er-soft); }
  #evalReport .er-after .er-val{ font-size:28px; font-weight:800; color:var(--er-good); }
  #evalReport .er-after .er-from{ font-size:18px; font-weight:700; color:var(--er-soft); }
  #evalReport .er-docfoot{ font-size:11px; color:var(--er-soft); line-height:1.7; margin-top:24px; padding-top:14px; border-top:1px solid var(--er-line); }

  /* 토스트 — 화면 정가운데(하단 알림바에 안 가리게). z-index 최상위 */
  #evalReport .er-toast{ position:fixed; top:50%; left:50%; transform:translate(-50%,-50%) scale(.96); background:#243247; color:#fff;
    padding:15px 28px; border-radius:12px; font-size:14.5px; font-weight:700; box-shadow:0 12px 40px rgba(0,0,0,.4); opacity:0; pointer-events:none; transition:.2s; z-index:2000; text-align:center; max-width:90vw; }
  #evalReport .er-toast.er-show{ opacity:1; transform:translate(-50%,-50%) scale(1); }

  /* ===== 첨부 PDF 미리보기 모달 ===== */
  #evalReport .er-modal{ position:fixed; inset:0; z-index:1300; background:rgba(16,22,29,.55); display:flex; align-items:center; justify-content:center; padding:20px; }
  #evalReport .er-modal-box{ width:min(1320px,98vw); height:96vh; background:#fff; border-radius:12px; box-shadow:0 14px 46px rgba(0,0,0,.38); display:flex; flex-direction:column; overflow:hidden; }
  #evalReport .er-modal-head{ display:flex; align-items:center; justify-content:space-between; gap:10px; padding:13px 18px; background:var(--er-navytint); border-bottom:1px solid var(--er-line); font-weight:800; color:var(--er-navy); }
  /* 헤더 파일명 — 크게. 길면 말줄임(버튼 안 밀리게 flex 축소 허용) */
  #evalReport #er-pdfModalTitle{ font-size:16.5px; font-weight:800; flex:1 1 auto; min-width:0; overflow:hidden; text-overflow:ellipsis; white-space:nowrap; }
  #evalReport .er-modal-actions{ display:flex; gap:8px; align-items:center; }
  #evalReport .er-modal-body{ flex:1 1 auto; position:relative; min-height:0; background:#525659; }
  #evalReport .er-modal-frame{ position:absolute; inset:0; width:100%; height:100%; border:none; }
  #evalReport .er-modal-loading{ position:absolute; inset:0; display:flex; align-items:center; justify-content:center; color:#e8eef5; font-weight:700; font-size:13.5px; }

  /* ===== 미리보기 모드 — 인쇄 결과를 화면에서 확인 (툴바·안내·편집표시 숨김, 회색 배경 + 흰 A4 지면) ===== */
  #evalReport .er-prevbar{ display:none; }
  #evalReport.er-preview .er-prevbar{ display:flex; align-items:center; gap:8px; position:fixed; top:0; left:0; right:0; z-index:1200;
    background:#243247; color:#fff; padding:9px 18px; box-shadow:0 3px 12px rgba(0,0,0,.28); }
  #evalReport.er-preview .er-prevbar .er-prevbar-t{ font-weight:800; font-size:13.5px; }
  #evalReport.er-preview .er-toolbar, #evalReport.er-preview .er-notice, #evalReport.er-preview #er-pdfBanner{ display:none !important; }
  #evalReport.er-preview{ padding-top:0 !important; background:#6b7a89; }
  #evalReport.er-preview .er-doc{ padding:60px 14px 40px; }
  #evalReport.er-preview .er-editable{ box-shadow:none !important; background:transparent !important; }

  /* 인쇄: 앱 크롬 숨기고 보고서만 (툴바·안내문 제외) */
  @media print{
    body *{ visibility:hidden !important; }
    #evalReport, #evalReport *{ visibility:visible !important; }
    /* 배경색 인쇄 강제 — 브라우저 기본은 배경을 빼고 인쇄해 네이비 헤더가 흰 글자만 남음 */
    #evalReport, #evalReport *{ -webkit-print-color-adjust:exact !important; print-color-adjust:exact !important; }
    /* 그라데이션은 인쇄에서 누락되는 경우가 있어 단색 네이비로 폴백 */
    #evalReport table.er-tbl thead th{ background:var(--er-navy) !important; color:#fff !important; }
    #evalReport .er-eyebrow{ background:var(--er-navy) !important; color:#fff !important; }
    #evalReport .er-eyebrow .er-rn, #evalReport .er-eyebrow .er-stitle{ color:#fff !important; }
    #evalReport table.er-tbl tr.er-grand td{ background:var(--er-navy) !important; color:#fff !important; }
    #evalReport .er-grplabel{ background:var(--er-navy) !important; color:#fff !important; }
    #evalReport .er-grplabel.er-g21{ background:#1f7a66 !important; }
    #evalReport .er-grplabel.er-g22{ background:#6b3fa0 !important; }
    #evalReport .er-cover-badge{ background:var(--er-navy) !important; color:#fff !important; }
    #evalReport .er-role{ background:var(--er-navy) !important; }
    #evalReport{ position:absolute; left:0; top:0; width:100%; background:#fff; padding:0 !important; }
    #evalReport .er-toolbar, #evalReport .er-notice, #evalReport .er-toast, #evalReport .er-modal, #evalReport .er-prevbar{ display:none !important; }
    #evalReport .er-doc{ padding:0; gap:0; }

    /* [기본] A4 분할 모드 — 화면에서 나눈 A4 페이지를 그대로 1시트씩 인쇄(화면=PDF) */
    #evalReport.er-paged .er-srcpage{ display:none !important; }
    #evalReport.er-paged .er-autopage{ display:block !important; width:auto; height:auto;
      box-shadow:none; border-radius:0; margin:0; padding:14mm 15mm; overflow:visible; page-break-after:always; }
    #evalReport.er-paged .er-autopage:last-child{ page-break-after:auto; }
    #evalReport.er-paged .er-autopage.er-cover-page{ min-height:255mm; display:flex; flex-direction:column; align-items:center; justify-content:center; }
    #evalReport.er-paged .er-autobody{ height:auto; overflow:visible; }

    /* [폴백] 분할 안 된 상태(편집 중 인쇄 등) — 연속 흐름, 최소 단위만 안 쪼갬 */
    #evalReport:not(.er-paged) .er-page{ box-shadow:none; border-radius:0; width:100%; padding:8mm 14mm 0; }
    #evalReport:not(.er-paged) .er-page.er-cover{ page-break-after:always; padding:12mm 14mm; }
    #evalReport .er-ind, #evalReport .er-indbox, #evalReport .er-rec, #evalReport .er-card, #evalReport .er-after, #evalReport .er-callout{ page-break-inside:avoid; }
    #evalReport table.er-tbl thead{ display:table-header-group; }
    #evalReport table.er-tbl tr{ page-break-inside:avoid; }
    #evalReport .er-indhead{ page-break-after:avoid; }
    #evalReport .er-eyebrow{ page-break-after:avoid; }
    @page{ size:A4; margin:0; }
  }
</style>

  <!-- ===== 툴바 (기능별 그룹 정렬) ===== -->
  <div class="er-toolbar">
    <!-- 그룹1: 제목·병원 -->
    <span class="er-brand"><span class="er-dot"></span><span class="er-brandtxt">월간 컨설팅 보고서</span></span>
    <span id="er-roleTag" class="er-role">위너넷</span>
    <span class="er-hospnm" id="er-hospNm"></span>
    <span class="er-divider"></span>
    <!-- 그룹2: 평가년월 조회 -->
    <!-- 작업년월 — 들어올 때 선택한 월로 고정 표시(수정 불가). 조회 버튼은 삭제(진입 시 자동 조회). -->
    <span class="er-searchbox" title="작업 년월(들어온 월 고정)">
      <select id="er-year" class="er-sel" disabled></select>
      <select id="er-month" class="er-sel" disabled></select>
    </span>
    <!-- (월보고 목록 버튼 제거 — 좌측 사이드바 '적정성평가 월간보고서' 메뉴로 대체) -->
    <!-- 도움말 — 클릭하면 사용법 안내 배너를 열고/닫음(토글). 마우스오버 시 요약 툴팁도 표시 -->
    <button class="er-btn er-wnnonly" id="er-help" onmouseenter="erHelpShow()" onmouseleave="erHelpHide()" onfocus="erHelpShow()" onblur="erHelpHide()">ℹ️ 도움말</button>

    <span class="er-sp"></span>

    <!-- 그룹3: 상태 + 진행순서대로 [①편집 → ②저장 → ③승인 → ④PDF첨부]. PDF첨부는 승인 후(공개본=PDF 일치). -->
    <span id="er-statusBadge" class="er-status er-draft"><span class="er-sdot"></span><span id="er-statusText">작성중</span></span>
    <!-- 이력 열람 진입 시: 어느 이력을 보는지(유형·작성자·시각) 표시 -->
    <span id="er-hstInfo" class="er-hstinfo" style="display:none;"></span>
    <span id="er-editTools" class="er-group">
      <button id="er-btnEdit" class="er-btn" onclick="erToggleEdit()" title="① 문구를 고치려면 편집을 켜세요">✏️ 편집</button>
      <button id="er-btnSave" class="er-btn er-primary" onclick="erSave()" title="② 수정한 문구·점수를 저장합니다(DB)">💾 저장</button>
      <button id="er-btnApprove" class="er-btn er-good" onclick="erApprove()" title="③ 승인 — 그 시점 수치가 동결되고 거래처에 공개됩니다. 승인 후 ④ PDF첨부가 가능합니다.">✔ 승인</button>
      <span class="er-divider"></span>
      <!-- ④ 첨부 PDF: 승인 후에만 활성. 첨부 전=[📎 PDF첨부] / 첨부 후 보기=[👁 PDF보기]. -->
      <input type="file" id="er-pdfFile" accept="application/pdf,.pdf" style="display:none;">
      <button id="er-btnPdf" class="er-btn" onclick="erPickPdf()" title="④ 승인 후 — 완성본 PDF를 첨부(화면 생성 또는 아래한글 완성본 업로드). 거래처엔 이 PDF가 우선 제공됩니다">📎 PDF첨부</button>
      <a id="er-pdfView" class="er-btn er-primary" style="display:none;" href="#" onclick="erPdfPreview(); return false;" title="첨부된 완성본 PDF 보기(교체는 모달 안 🔍검색)">👁 PDF보기</a>
    </span>
    <!-- 서식 툴(편집 모드 전용) — 답변 에디터(noticd summernote) 구성 참조: B·I·U·지우개 + 글꼴 + 크기 + 색상 A▾.
         문구를 드래그로 선택한 뒤 클릭(버튼 mousedown 취소·select 는 선택영역 저장/복원으로 선택 유지) -->
    <span class="er-fmtbar" id="er-fmtbar" title="문구를 드래그로 선택한 뒤 누르세요">
      <span class="er-divider"></span>
      <button class="er-fbtn" onmousedown="event.preventDefault()" onclick="erFmt('bold')" title="굵게"><b>B</b></button>
      <button class="er-fbtn" onmousedown="event.preventDefault()" onclick="erFmt('italic')" title="기울임"><i>I</i></button>
      <button class="er-fbtn" onmousedown="event.preventDefault()" onclick="erFmt('underline')" title="밑줄"><u>U</u></button>
      <button class="er-fbtn" onmousedown="event.preventDefault()" onclick="erFmt('clear')" title="서식 지우기(굵게·색·형광·크기 제거)">⌫</button>
      <select class="er-fsel" id="er-fontName" style="width:76px;" onchange="erFmt('font', this.value); this.selectedIndex=0;" title="글꼴">
        <option value="">글꼴</option>
        <option value="Malgun Gothic">맑은 고딕</option>
        <option value="Gulim">굴림체</option>
        <option value="Dotum">돋움체</option>
        <option value="Batang">바탕체</option>
        <option value="Arial">Arial</option>
        <option value="Courier New">Courier New</option>
      </select>
      <select class="er-fsel" id="er-fontSize" style="width:56px;" onchange="erFmt('sizepx', this.value); this.selectedIndex=0;" title="글자 크기(px)">
        <option value="">크기</option>
        <option>10</option><option>11</option><option>12</option><option>13</option><option>14</option>
        <option>16</option><option>18</option><option>20</option><option>24</option>
      </select>
      <span class="er-fcolor">
        <button class="er-fbtn er-fA" id="er-fA" onmousedown="event.preventDefault()" onclick="erFmt('color')" title="최근 색 적용"><b>A</b></button>
        <button class="er-fbtn er-fcaret" onmousedown="event.preventDefault()" onclick="erPalToggle()" title="색 선택">▾</button>
        <div class="er-fpal" id="er-fpal">
          <div class="er-fpl">글자색</div>
          <span class="er-fsw" style="background:#1a2332" onmousedown="event.preventDefault()" onclick="erFmtPick('#1a2332',false)" title="검정(기본)"></span>
          <span class="er-fsw" style="background:#c0392b" onmousedown="event.preventDefault()" onclick="erFmtPick('#c0392b',false)" title="빨강"></span>
          <span class="er-fsw" style="background:#e74c3c" onmousedown="event.preventDefault()" onclick="erFmtPick('#e74c3c',false)" title="밝은빨강"></span>
          <span class="er-fsw" style="background:#d81b60" onmousedown="event.preventDefault()" onclick="erFmtPick('#d81b60',false)" title="분홍"></span>
          <span class="er-fsw" style="background:#b7791f" onmousedown="event.preventDefault()" onclick="erFmtPick('#b7791f',false)" title="주황"></span>
          <span class="er-fsw" style="background:#8d6e63" onmousedown="event.preventDefault()" onclick="erFmtPick('#8d6e63',false)" title="갈색"></span>
          <span class="er-fsw" style="background:#2a5298" onmousedown="event.preventDefault()" onclick="erFmtPick('#2a5298',false)" title="네이비"></span>
          <span class="er-fsw" style="background:#3498db" onmousedown="event.preventDefault()" onclick="erFmtPick('#3498db',false)" title="하늘파랑"></span>
          <span class="er-fsw" style="background:#1f7a66" onmousedown="event.preventDefault()" onclick="erFmtPick('#1f7a66',false)" title="청록"></span>
          <span class="er-fsw" style="background:#2e7d32" onmousedown="event.preventDefault()" onclick="erFmtPick('#2e7d32',false)" title="초록"></span>
          <span class="er-fsw" style="background:#6b3fa0" onmousedown="event.preventDefault()" onclick="erFmtPick('#6b3fa0',false)" title="보라"></span>
          <span class="er-fsw" style="background:#7c8798" onmousedown="event.preventDefault()" onclick="erFmtPick('#7c8798',false)" title="회색"></span>
          <div class="er-fpl">형광(배경)</div>
          <span class="er-fsw" style="background:#fff3b0" onmousedown="event.preventDefault()" onclick="erFmtPick('#fff3b0',true)" title="노랑"></span>
          <span class="er-fsw" style="background:#ffd54f" onmousedown="event.preventDefault()" onclick="erFmtPick('#ffd54f',true)" title="진노랑"></span>
          <span class="er-fsw" style="background:#ffe0b2" onmousedown="event.preventDefault()" onclick="erFmtPick('#ffe0b2',true)" title="주황"></span>
          <span class="er-fsw" style="background:#fde2e2" onmousedown="event.preventDefault()" onclick="erFmtPick('#fde2e2',true)" title="분홍"></span>
          <span class="er-fsw" style="background:#daf1db" onmousedown="event.preventDefault()" onclick="erFmtPick('#daf1db',true)" title="연두"></span>
          <span class="er-fsw" style="background:#dbeafe" onmousedown="event.preventDefault()" onclick="erFmtPick('#dbeafe',true)" title="하늘"></span>
          <span class="er-fsw" style="background:#e6dcf5" onmousedown="event.preventDefault()" onclick="erFmtPick('#e6dcf5',true)" title="연보라"></span>
          <span class="er-fsw" style="background:#e8eef5" onmousedown="event.preventDefault()" onclick="erFmtPick('#e8eef5',true)" title="회색"></span>
          <div style="margin-top:6px"><button class="er-fbtn" style="width:100%" onmousedown="event.preventDefault()" onclick="erFmtPick('transparent',true)">형광 지우기</button></div>
        </div>
      </span>
    </span>
    <span class="er-divider"></span>
    <!-- 글자 크기(문서 배율)·미리보기 — 열람용 도구라 거래처(일반병원)에도 노출(er-wnnonly 제거). 가운데 % 클릭 시 100% 복원 -->
    <button class="er-btn" style="padding:8px 7px;" onclick="erZoom(-1)" title="글자 작게">가−</button>
    <button class="er-btn" id="er-zoomPct" onclick="erZoom(0)" title="클릭=100% 복원" style="min-width:44px; padding:8px 6px;">100%</button>
    <button class="er-btn" style="padding:8px 7px;" onclick="erZoom(1)" title="글자 크게">가＋</button>
    <span class="er-divider"></span>
    <!-- 미리보기 하나로 통일 — 미리보기 진입 시 상단바에 '🖨️ 인쇄' 가 있어 툴바 인쇄 버튼은 중복이라 제거(2026-07-20). -->
    <button class="er-btn" onclick="erPreview()" title="인쇄 형태(A4)로 화면에서 확인 — 미리보기 상단의 🖨️ 인쇄(PDF저장)로 출력/PDF저장">👁 미리보기</button>
    <!-- 📄 한글저장(.doc 내보내기) — 사용자 협의 후 결정하기로 하여 버튼 제외(2026-07-20). 기능 erExportDoc 는 유지 → 협의 후 아래 버튼만 다시 살리면 됨:
         <button class="er-btn" onclick="erExportDoc()" title="아래한글·워드에서 열 수 있는 문서(.doc)로 저장합니다(화면 이동 없음)">📄 한글저장</button> -->
    <!-- (툴바 🖨️ 인쇄 버튼 제거 — 미리보기 상단바의 인쇄로 통일) -->
    <!-- 그룹4: 종료 -->
    <span class="er-divider"></span>
    <button class="er-btn er-exit" onclick="erExit()">✕ 종료</button>
  </div>

  <!-- 도움말 호버 팝오버 — 툴바 overflow 밖·position:fixed 라 아래 영역을 차지하지 않음(레이아웃 안 밀림). JS가 좌표 실측 -->
  <div id="er-helpPop" class="er-helppop" onmouseenter="erHelpKeep()" onmouseleave="erHelpHide()"></div>

  <!-- 미리보기 모드 상단 바 (평소 숨김, .er-preview 일 때만 표시) -->
  <div class="er-prevbar">
    <span class="er-prevbar-t">📄 인쇄 미리보기 <span style="font-weight:600; opacity:.8;">— 인쇄하면 이 형태로 출력됩니다</span></span>
    <span style="flex:1 1 auto;"></span>
    <button class="er-btn" onclick="erPrint()" style="padding:9px 24px; font-size:15px; font-weight:800; background:#fff; color:#1e3c72; border-color:#fff; box-shadow:0 2px 8px rgba(0,0,0,.25);">🖨️ 인쇄</button>
    <button class="er-btn er-exit" onclick="erPreviewExit()">✕ 미리보기 닫기</button>
  </div>

  <!-- 안내 배너 — 평소 숨김(사용법은 툴바 'ℹ️ 도움말' 툴팁으로 이동). 초기화 오류 시 showErr 가 이 영역을 표시 -->
  <div class="er-notice" id="er-notice" style="display:none;"></div>

  <div class="er-notice" id="er-pdfBanner" style="display:none; border-color:#bfe0c4; background:var(--er-goodtint); color:var(--er-good);">
    📄 <b>완성본 PDF가 첨부된 보고서입니다.</b>
    <a href="#" onclick="erPdfPreview(); return false;" style="font-weight:800; color:var(--er-good); text-decoration:underline;">화면에서 보기</a> ·
    <a id="er-pdfBannerLink" href="#" style="font-weight:800; color:var(--er-good); text-decoration:underline;">다운로드</a>
  </div>

  <!-- ===== 지면 ===== -->
  <div class="er-doc">
    <!-- PAGE 1 : 표지 (원본 PDF 맨앞장 형식 — 가운데 정렬 한 장, 수치·병원명·목표는 자동 채움) -->
    <div class="er-page er-cover">
      <div class="er-cover-eyebrow er-editable" data-key="cover_top">요양병원 입원급여 적정성평가</div>
      <div class="er-cover-title">
        <span class="er-editable" data-key="cover_hosp" id="er-coverHosp">○○요양병원</span><br>
        적정성평가 결과 및<br>등급 향상 컨설팅 보고서
      </div>
      <div class="er-cover-meta1">평가대상 : <b id="er-coverPeriod">-</b></div>
      <div class="er-cover-meta2">현재 종합점수 <b class="er-b-bad er-num" id="er-coverTotal">-</b>점
        &nbsp;→&nbsp; 목표등급 <b><span class="er-editable" data-key="cover_goal_grade">3등급</span> (<span class="er-editable" data-key="cover_goal_score">78</span>점)</b></div>
      <div class="er-cover-badge">목표등급 <span class="er-editable" data-key="cover_goal_badge">3등급</span></div>
      <div class="er-cover-foot">본 보고서는 <b>WinCheck⁺</b> 산출 자료를 기준으로 작성되었습니다.<br>작성일 : <span class="er-editable" data-key="cover_date" id="er-coverDate">-</span></div>
    </div>

    <!-- PAGE 2 : Ⅰ 종합 평가 요약 (여기부터 본문 시작) -->
    <div class="er-page">
      <div class="er-sec" style="margin-top:0;">
        <div class="er-eyebrow"><span class="er-rn">Ⅰ.</span><span class="er-stitle">종합 평가 요약</span></div>
        <div class="er-cards">
          <div class="er-card"><div class="er-clabel">구조영역 <span class="er-cmax">(30점 만점)</span></div><div class="er-cscore er-num" id="er-cardStruct">-</div><div class="er-cfoot">획득률 <span id="er-rateStruct">-</span></div></div>
          <div class="er-card"><div class="er-clabel">진료영역 <span class="er-cmax">(70점 만점)</span></div><div class="er-cscore er-num" id="er-cardCare">-</div><div class="er-cfoot">획득률 <span id="er-rateCare">-</span></div></div>
          <div class="er-card er-total"><div class="er-clabel">종합점수 <span class="er-cmax">(100점 만점)</span></div><div class="er-cscore er-num" id="er-cardTotal">-</div><div class="er-cfoot">현재 <b class="er-b-bad" id="er-curGrade">-</b></div></div>
          <div class="er-card er-total"><div class="er-clabel"><span id="er-gapGoalGrade">3등급</span> 목표(<span id="er-gapGoalScore">78</span>점)까지</div><div class="er-cscore er-num" id="er-gapScore">-</div><div class="er-cfoot">부족 점수</div></div>
        </div>

        <div class="er-subh">1. 현재 위치와 목표</div>
        <div class="er-tw">
          <table class="er-tbl er-grade">
            <thead id="er-gradeHead"><!-- JS: 등급 컬럼(가로형) --></thead>
            <tbody id="er-gradeBody"><!-- JS --></tbody>
          </table>
        </div>
        <div class="er-callout">
          <div class="er-coh">핵심 진단</div>
          <div class="er-editable" data-key="diag_core">현재 종합점수는 목표 등급 구간에 미치지 못합니다. 안정적인 목표등급 달성·유지를 위해 구간 상단 점수를 목표로 개선이 필요합니다.</div>
          <div class="er-fn er-editable" data-key="diag_note">※ 병원 여건을 고려한 단계적 목표(목표등급) 기준으로 부족분과 개선 로드맵을 산정했습니다.</div>
        </div>

        <div class="er-subh">2. 한눈에 보는 우선 개선지표 <span style="font-weight:600;color:var(--er-soft);font-size:11.5px;">(부족분 큰 순)</span></div>
        <div class="er-tw">
          <table class="er-tbl">
            <thead><tr><th>순위</th><th class="er-l">지표</th><th>영역</th><th>가중치</th><th>현재점수</th><th>부족분</th><th class="er-l">개선 여지</th></tr></thead>
            <tbody id="er-priBody"><!-- JS --></tbody>
          </table>
        </div>
        <div class="er-fn er-editable" data-key="pri_note">※ 부족분 = 가중치(만점) − 현재 획득점수. 가중치가 큰 결과지표의 실적 기록 정상화가 등급 향상의 핵심 지렛대입니다.</div>
      </div>
    </div>

    <!-- PAGE 2 : Ⅱ 상세 분석표 -->
    <div class="er-page">
      <div class="er-sec" style="margin-top:0;">
        <div class="er-eyebrow"><span class="er-rn">Ⅱ.</span><span class="er-stitle">영역별·지표별 상세 분석</span></div>
        <div class="er-tw">
          <table class="er-tbl">
            <thead><tr><th>영역</th><th class="er-l">지표명</th><th>가중치<br>(만점)</th><th>현황값</th><th>표준화<br>구간</th><th>획득<br>점수</th><th>획득률</th><th>부족분</th></tr></thead>
            <tbody id="er-tbl2Body"><!-- JS --></tbody>
          </table>
        </div>
        <div class="er-fn er-editable" data-key="tbl2_note">※ 표준화 구간은 2024년(2주기 6차) 평가결과 기준(1구간 미흡 ~ 5구간 우수). 획득점수 = 가중치 ÷ 5 × 표준화구간.<br>※ 항정신성의약품 처방률은 타 기관의 상병 구성·평균 처방률 확인이 불가하여 시스템 산출 PI값이 실제 평가결과와 차이가 있을 수 있습니다(참고용, 기본 표준화 3구간 산정).<br>※ 유치도뇨관 관련 의무기록(환자별 Foley 삽입·제거 대사)은 병원 EMR/OCS 정보 확인이 필요하여 본 보고서에서는 제외했습니다.</div>
      </div>
    </div>

    <!-- PAGE 3 : Ⅲ 지표별 분석 내용 (편집 문구) -->
    <div class="er-page">
      <div class="er-sec" style="margin-top:0;">
        <div class="er-eyebrow"><span class="er-rn">Ⅲ.</span><span class="er-stitle">지표별 분석 내용</span></div>
        <p class="er-fn er-editable" data-key="sec3_lead" style="margin-top:0;">각 지표의 산정 근거(분모·분자·현황값 → 표준화구간 → 획득점수)와 지표 정의, 개선 방향을 정리했습니다. 점수는 (획득점수 / 가중치 만점) 표기.</p>
        <div id="er-sec3Body"><!-- 기본 문구는 JS 가 채우고, 저장된 override 가 있으면 덮어씀 --></div>
      </div>
    </div>

    <!-- PAGE 4 : Ⅳ 권고 + Ⅴ 로드맵 (편집 문구) -->
    <div class="er-page">
      <div class="er-sec" style="margin-top:0;">
        <div class="er-eyebrow"><span class="er-rn">Ⅳ.</span><span class="er-stitle">우선 개선지표별 권고사항</span></div>
        <div id="er-sec4Body"></div>
      </div>
      <div class="er-sec">
        <div class="er-eyebrow"><span class="er-rn">Ⅴ.</span><span class="er-stitle">목표등급 달성 로드맵</span></div>

        <div class="er-subh">권장 개선 시나리오</div>
        <div class="er-tw">
          <table class="er-tbl">
            <thead><tr><th>단계</th><th class="er-l">개선 지표</th><th>현재</th><th>목표 수준</th><th>현재점수</th><th>목표점수</th><th>상승분</th></tr></thead>
            <tbody id="er-roadBody"><!-- JS: 부족분 상위 지표 자동 시나리오 --></tbody>
          </table>
        </div>
        <div class="er-after"><span class="er-lbl">개선 후 예상 종합점수</span><span class="er-from er-num" id="er-afterFrom">-</span>→<span class="er-val er-num er-editable" data-key="after_score">-</span><span class="er-lbl" id="er-afterGrade"></span></div>

        <div class="er-callout">
          <div class="er-coh">결론</div>
          <div class="er-editable" data-key="concl">가중치가 큰 결과지표(예: 욕창·ADL 개선)의 실적 기록 정상화만으로 큰 폭의 점수 확보가 가능합니다. 실제 진료·재활은 이뤄지나 개선 판정이 평가표에 기록되지 않아 낮게 산정되는 경우가 많으므로, 추가 인력·비용 없이 기록·평가 절차 개선으로 목표 달성 가능성이 높습니다.</div>
          <div class="er-fn er-editable" data-key="concl_note">※ 단기 실행 우선순위: (1) 결과지표 재평가 기록 절차 정비 → (2) 과정지표 기록 → (3) 퇴원계획(지역연계) 강화.</div>
        </div>

        <div class="er-subh">참고 : 현재 vs 목표 점수 비교</div>
        <div class="er-tw">
          <table class="er-tbl">
            <thead><tr><th class="er-l">구분</th><th>현재</th><th>개선 후(목표)</th></tr></thead>
            <tbody id="er-cmpBody"><!-- JS --></tbody>
          </table>
        </div>

        <!-- 총평 — 문서 맨 끝(마무리) 배치. 상세 내용(Ⅰ~Ⅴ)을 먼저 보고 마지막에 종합 논평을 읽는 참조 패턴.
             구어체·핵심 수치만, 조회 시 자동 초안(renderSummary) 생성 후 문단별 편집 가능 -->
        <div class="er-callout" style="margin-top:16px;">
          <div class="er-coh">총평</div>
          <p class="er-editable" data-key="sum_p1" style="margin:0 0 7px;"></p>
          <p class="er-editable" data-key="sum_p2" style="margin:0 0 7px;"></p>
          <p class="er-editable" data-key="sum_p3" style="margin:0 0 7px;"></p>
          <p class="er-editable" data-key="sum_p4" style="margin:0 0 7px;"></p>
          <p class="er-editable" data-key="sum_p5" style="margin:0;"></p>
        </div>
      </div>
      <div class="er-docfoot er-editable" data-key="footer">본 보고서는 WinCheck⁺ 시스템 산출값을 근거로 작성되었으며, 목표등급은 해당 병원의 설정값 기준입니다. 실제 평가결과는 심평원 최종 산정 기준 및 자료 확정 시점에 따라 달라질 수 있습니다.</div>
    </div>
  </div>

  <!-- 첨부 PDF 미리보기 모달 (다운로드 없이 화면에서 바로 보기) -->
  <div id="er-pdfModal" class="er-modal" style="display:none;">
    <div class="er-modal-box">
      <div class="er-modal-head">
        <span id="er-pdfModalTitle">📄 첨부 PDF 미리보기</span>
        <span class="er-modal-actions">
          <!-- 생성-미리보기 모드(저장 전): 파일서버 저장 + 다른 PDF 선택 -->
          <button id="er-pdfGenSaveBtn" class="er-btn er-good" style="display:none;" onclick="erPdfGenUpload()" title="이 PDF를 파일서버에 저장·첨부합니다">📄 파일서버 저장</button>
          <button id="er-pdfPickBtn" class="er-btn" style="display:none;" onclick="document.getElementById('er-pdfFile').click()" title="아래한글 등으로 만든 PDF 파일을 직접 선택">📁 파일 선택</button>
          <!-- 열람 모드(첨부된 PDF 보기): 교체 검색 -->
          <button id="er-pdfModalReplace" class="er-btn" onclick="erPickPdf()" title="다른 PDF로 다시 생성/선택합니다">🔍 검색</button>
          <button class="er-btn" onclick="erPdfClose()">✕ 닫기</button>
        </span>
      </div>
      <div class="er-modal-body">
        <iframe id="er-pdfFrame" class="er-modal-frame" title="첨부 PDF"></iframe>
        <div id="er-pdfLoading" class="er-modal-loading">PDF를 불러오는 중입니다…</div>
      </div>
    </div>
  </div>

  <div id="er-toast" class="er-toast"></div>
</div>

<script>
jQuery(function(){   // $(document).ready — top.jsp 전역(hospid/hospnm)·jQuery 준비 후 실행 (magamFileUpload 패턴)
  "use strict";
  var ctx = (typeof CommonUtil !== 'undefined' && CommonUtil.getContextPath) ? CommonUtil.getContextPath() : '';
  function cookie(n){ var m=document.cookie.match('(^|;)\\s*'+n+'\\s*=\\s*([^;]+)'); return m?decodeURIComponent(m.pop()):''; }

  // 병원코드/병원명 = top.jsp 전역 hospid/hospnm 우선(=getCookie("hospid"), 앱 전체 표준·병원검색 시 갱신),
  //                    없으면 s_hospid 쿠키/sessionStorage 폴백.
  var hospCd = (typeof hospid !== 'undefined' && hospid) ? String(hospid).trim()
             : (cookie('s_hospid') || (sessionStorage.getItem('s_hospid') || '').trim());
  var hospNm = (typeof hospnm !== 'undefined' && hospnm) ? String(hospnm)
             : (cookie('s_hospnm') || sessionStorage.getItem('s_hospnm') || '');
  // 월보고 목록(evalReportList)에서 진입한 경우 — hospCd/hospNm/ym/autoprint 를 sessionStorage 로 넘김.
  //   ★ main.jsp 의 URL 숨김(history.replaceState → /user/dashboard.do)이 쿼리스트링을 지우므로 URL 파라미터는 못 씀.
  //     sessionStorage 는 화면 이동에도 보존됨. 원샷(읽고 즉시 제거) — 메뉴/현황 재진입 시 재사용 방지.
  var _erFromList = false, _erListYear = '', _erOpenYm = '', _erAutoprint = false, _erReadonly = false, _erHstInfo = null;
  (function(){
    var q = location.search;
    var sHosp='', sNm='', sYm='', sAuto='', sRo='', sHst='';
    try{
      sHosp = sessionStorage.getItem('erOpenHospCd') || '';
      sNm   = sessionStorage.getItem('erOpenHospNm') || '';
      sYm   = sessionStorage.getItem('erOpenYm') || '';
      sAuto = sessionStorage.getItem('erOpenAutoprint') || '';
      sRo   = sessionStorage.getItem('erOpenReadonly') || '';
      sHst  = sessionStorage.getItem('erOpenHstInfo') || '';
      _erFromList = (sessionStorage.getItem('erFromList') === '1');
      _erListYear = sessionStorage.getItem('erFromListYear') || '';
      ['erOpenHospCd','erOpenHospNm','erOpenYm','erOpenAutoprint','erOpenReadonly','erOpenHstInfo','erFromList','erFromListYear']
        .forEach(function(k){ sessionStorage.removeItem(k); });   // 원샷 제거
    }catch(e){}
    _erReadonly = (sRo==='1') || /[?&]ro=1/.test(q);   // 이력 열람 = 읽기전용(저장·승인·PDF첨부 잠금)
    if(sHst){ try{ _erHstInfo = JSON.parse(sHst); }catch(e){ _erHstInfo = null; } }
    // hospCd/hospNm : sessionStorage(원값) 우선, 없으면 URL 파라미터(인코딩) 폴백
    if(sHosp){ hospCd = String(sHosp).trim(); }
    else { var ph=(q.match(/[?&]hospCd=([^&]+)/)||[])[1]; if(ph){ try{ hospCd=decodeURIComponent(ph).trim(); }catch(e){ hospCd=ph.trim(); } } }
    if(sNm){ hospNm = sNm; }
    else { var pn=(q.match(/[?&]hospNm=([^&]+)/)||[])[1]; if(pn){ try{ hospNm=decodeURIComponent(pn); }catch(e){ hospNm=pn; } } }
    _erOpenYm    = sYm || (q.match(/[?&]ym=(\d{6})/)||[])[1] || '';
    _erAutoprint = (sAuto==='1') || /[?&]autoprint=1/.test(q);
    if(!_erFromList && /[?&]ret=list/.test(q)) _erFromList = true;   // URL 폴백(주소 안 지워진 환경 대비)
  })();
  // 위너넷 판별 = s_wnn_yn 쿠키 하나만 (wnn_consult/wnn_medcost 양쪽 로그인이 매번 재설정 — 잔존 없음).
  //   s_winconect 는 wnn_consult 로그인이 안 지워 일반병원 재로그인 후에도 잔존 → 오노출 원인이라 제외.
  //   이 시스템은 로그인이 wnn_consult 에서 이뤄져 wnn_medcost 세션에는 로그인 정보가 없음 → 세션(${wnnYn}) 방식 불가.
  //   버튼(assessment)과 동일 기준 — 버튼이 보였으면 여기도 반드시 통과(alert 안 뜸).
  function _ck(n){ try{ if(typeof getCookie==='function') return (getCookie(n)||'').trim(); }catch(e){} return cookie(n); }
  var isWinner = (_ck('s_wnn_yn') === 'Y');
  // [2단계·프로그램 완성 후] 거래처 공개: 컨트롤러가 '해당 병원·월 승인본 있음'을 canView 로 내려주면
  //   allowView = (isWinner || canView) 로 확장. 지금은 1단계라 위너넷만.
  var allowView = isWinner;

  // 1단계: 위너넷 전용 — 위너넷이 아니면(또는 재로그인 전이라 세션이 비었으면) 적정성평가 화면으로 복귀.
/*   if(!allowView){
    alert('월보고서는 준비 중입니다.');
    location.replace('/main/assessment.do');
    return;
  }    */
 
  // 병원(거래처) 열람 모드 — 관리 도구(상태·편집·저장·승인·PDF첨부·서식바)와 안내문을 숨겨 열람 위주로.
  //   조회·글자크기(배율)·미리보기·인쇄·종료는 거래처에도 노출(열람용). 2단계 canView 공개 시 자동 적용.
  if(!isWinner){
    document.getElementById('evalReport').classList.add('er-hospview');
    var _rt=document.getElementById('er-roleTag'); if(_rt) _rt.textContent='열람';
  }

  var editing = false, approved = false, curYm = '', pdfPath = '';
  var indicators = [], scores = { struct:0, care:0, total:0 };
  var _bladderGapN = 0;   // [★6] 배뇨관리(06) '일지 작성했으나 프로그램 미체크(분자제외 우려)' 건수 — 오류점검(assesCheck flag 07) 집계
  var _dashInd = null;    // [C1·C2] 대시보드 지표 SP(dashbordINDICATORS): monthVal(당월)·year_Val(누적)·month_07~12(월별)·hosGrade
  var prevTotal = null;   // 전월 종합점수 — 총평 P1 전월대비용 (7월=새 평가기간 시작·자료 없음이면 null)
  function prevYmOf(ym){ var y=+ym.substring(0,4), m=+ym.substring(4,6)-1; if(m<1){ m=12; y--; } return String(y)+('0'+m).slice(-2); }

  function el(id){ return document.getElementById(id); }   // 주의: jQuery $ 를 가리지 않도록 el 사용
  function esc(s){ return String(s==null?'':s).replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;'); }
  function n(v){ var x = Number(v); return isNaN(x)?0:x; }
  function f1(v){ var x=n(v); return (Math.round(x*10)/10).toFixed(1); }
  function fnum(v){ var x=n(v); return (Math.abs(x-Math.round(x))<0.001)? String(Math.round(x)) : (Math.round(x*100)/100).toString(); }
  function gradeOf(t){ t=n(t); if(t>=88)return'1등급'; if(t>=79)return'2등급'; if(t>=71)return'3등급'; if(t>=63)return'4등급'; return'5등급'; }
  function areaNm(fg){ return fg==='10'?'구조':(fg==='21'?'과정':(fg==='22'?'결과':'')); }
  function grpNm(fg){ return fg==='10'?'구조지표':(fg==='21'?'과정지표':(fg==='22'?'결과지표':'기타')); }

  // ===== 적정성평가 화면(assessment.jsp)과 동일 기준 =====
  var UNIT_PERSON = ['01','02','03'];                         // 명 단위 지표(1인당 환자수) — 나머지는 %
  var DENOM_NM = { '01':'의사', '02':'간호사', '03':'간호인력' };
  var NOT_HEADCOUNT = ['04','08'];                            // 분모가 환자수가 아닌 지표(재직일수율·DUR)

  // ===== 원본 컨설팅 PDF 표준 문구 (지표코드별) — "양식 그대로" 기본값. 편집으로 병원별 덮어쓰기 가능 =====
  // 지표 정의 (Ⅲ 분석 문단에 이어붙음)
  var TPL_DEF = {
    '01':'월평균 재원환자수를 상근 환산 의사 수로 나눈 값. 값이 작을수록 우수(26명 미만 = 5구간).',
    '02':'값이 작을수록 우수(6명 미만 = 5구간).',
    '03':'간호사+간호조무사 등 간호인력 기준 1인당 환자수. 값이 작을수록 우수(3명 미만 = 5구간).',
    '04':'평가대상기간 중 약사 재직일수 비율(100% = 5구간).',
    '05':'유치도뇨관(Foley)을 보유한 환자 비율. 값이 낮을수록 우수(0.5% 미만 = 5구간).',
    '06':'배뇨조절 저하(자주 실금·조절 못함) 환자 중 배뇨관리를 실시한 환자 비율(2026년 2주기 8차 신설). 분자 인정 = ①일정하게 짜여진 배뇨계획+배뇨일지 3일 이상 ②방광훈련프로그램+배뇨일지 3일 이상 ③규칙적 도뇨 중 하나 이상(의료최고도·배뇨관련 루 관리 등 제외).',
    '07':'항정신성의약품 처방 정도(PI, 0.2 미만 = 5구간 / 1.6 이상 = 1구간). ※ 타 기관의 상병 구성·평균 처방률 확인이 불가하여 시스템 산출 PI값은 실제 평가결과와 차이가 있을 수 있으므로 참고용입니다.',
    '08':'매월 심사평가원의 DUR 점검 현황을 확인하여 누락 대상자 관리가 필요하며 점검 결과에 따라 추후 결과 발표 시 점수차가 발생할 수 있음. 확인경로: 요양기관업무포털(biz.hira.or.kr) > 모니터링 > DUR정보 > 기관별 DUR 점검완료현황.',
    '09':'1단계 이상 욕창 보유 환자 중 당일 피부문제 처치를 실시한 환자 비율. (처치 = 압력 줄이는 도구 사용·체위변경·욕창 해결 위한 영양 공급·욕창부위 드레싱 등 4가지 중 수행 시 해당)',
    '10':'당일·전월 모두 고위험군에 해당하는 환자 중 당일 2단계 이상 욕창이 새로 생긴 환자를 확인하는 지표. 값이 낮을수록 우수(0.25% 미만 = 5구간).',
    '11':'2단계 이상 욕창 보유 환자 중 당일 개선된 환자 비율(개선 = 욕창 단계 수가 줄거나 최고단계가 낮아진 경우).',
    '12':'입원 시점 대비 재평가에서 일상생활수행능력이 호전된 환자 비율.',
    '13':'당뇨병 상병 환자 중 HbA1c 검사결과가 적정범위(98% 이상 = 5구간)인 환자 비율.',
    '14':'재원환자 중 181일 이상 장기입원 비율. 값이 낮을수록 우수(20% 미만 = 5구간).',
    '15':'퇴원 환자 중 지역사회(가정 등)로 복귀한 비율. 값이 높을수록 우수(70% 이상 = 5구간).'
  };
  // ▷ 개선 방향 (Ⅲ·Ⅳ 기본 문구)
  var TPL_DIR = {
    '01':'의사 인력 충원이 필요한 구조 항목으로, 우선 의사 재직·근무일수 산정 정확성을 점검.',
    '03':'간호인력 충원 및 근무일수 산정 정확성 점검.',
    '05':'불필요 유지 여부 정기 검토·조기 제거, 간헐적 도뇨(CIC) 전환. 제거 시 제거일자를 평가표에 정확히 입력(누락 시 계속 보유로 집계).',
    '06':'배뇨일지를 작성했어도 배뇨관리계획(일정하게 짜여진 배뇨계획·방광훈련프로그램) 항목 미체크 시 분자에서 누락되므로 평가표 작성기준 우선 재점검. 배뇨일지 7일 미만 작성 시 \'아니오\' 체크 후 실제 작성일수 기재, 배뇨일지에는 실시일자·요실금 여부·배뇨횟수(또는 배뇨량, mL)를 반드시 포함하고 의사·간호기록과 일치하도록 관리.',
    '09':'욕창(피부문제) 처치 4항목(압력분산도구·체위변경·영양공급·창상 드레싱) 중 실시분을 평가표에 정확히 기록. 특히 2단계 이상 압박성 궤양은 염증성 처치(M0121)가 동반 청구되어야 욕창처치 실시로 인정되므로 처치·청구 기록의 일치 여부를 함께 점검.',
    '11':'욕창 발생 환자의 주차별 창상 사정(PUSH tool 등)·호전 여부를 평가표에 반드시 기록. 실제 처치·드레싱은 이뤄지나 개선 기록 누락으로 낮게 산정되는 경우가 많으므로 기록 관리가 핵심.',
    '12':'재활·기능회복 대상 환자의 입원 초기 ADL과 재평가 ADL을 동일 기준으로 기록하여 호전 건 반영. 물리치료·작업치료 실적과 평가표 연동 점검.',
    '14':'퇴원계획 수립·지역연계(재가·시설) 강화로 장기입원 비중 관리.',
    '15':'퇴원 후 재가·시설 연계 실적을 정확히 기록 관리.'
  };
  // Ⅰ-2 우선지표 "개선 여지" 문구
  var TPL_ROOM = {
    '01':'인력 구조 개선 필요', '02':'인력 구조 개선 필요', '03':'인력 구조 개선 필요',
    '05':'감염관리·제거관리', '06':'배뇨관리 기록·실시',
    '11':'최대 개선 여지', '12':'최대 개선 여지',
    '14':'퇴원계획·지역연계 강화', '15':'재가·시설 연계 기록'
  };
  function unitOf(cd){ return UNIT_PERSON.indexOf(cd)>=0 ? '명' : '%'; }
  function calDisp(r){ return esc(fnum(r.cal_val)) + unitOf(r.cate_cd); }   // 현황값 표기(그리드와 동일: 01~03=명, 그 외=%)

  // 5점 구간 기준 — 적정성 화면과 동일하게 TBL_WEVALUE_MST(select_ScoreCriteria.do)에서 로드
  var CRIT = {};
  function buildCriteria(res){
    CRIT = {};
    var LOWER = ['01','02','03','05','07','10','14'];         // 낮을수록 좋은 지표(assessment LOWER_IS_BETTER)
    var rows = (res && res.data) || [];
    CRIT_ALL = {};
    rows.forEach(function(it){
      var cd = it.cate_cd, sc = parseFloat(it.std_score);
      if (sc === 5) {
        CRIT[cd] = { start:parseFloat(it.start_indi), end:parseFloat(it.end_indi),
                     direction: LOWER.indexOf(cd)>=0 ? 'lower' : 'higher' };
      }
      (CRIT_ALL[cd] = CRIT_ALL[cd] || []).push({ s:sc, start:parseFloat(it.start_indi), end:parseFloat(it.end_indi) });
    });
    Object.keys(CRIT_ALL).forEach(function(cd){ CRIT_ALL[cd].sort(function(a,b){ return a.s-b.s; }); });
  }
  var CRIT_ALL = {};   // 전 구간(1~5) 기준 — Ⅳ 표준화 구간 나열용

  // "표준화 구간 : 3.5%↑(1)·2.5~3.5%(2)…(5)" 원본 형식 나열 (기준 미로드 지표는 빈 문자열)
  function zoneListText(cd){
    var a = CRIT_ALL[cd]; if(!a || !a.length) return '';
    var u = unitOf(cd);
    return a.map(function(z){ return fnum(z.start)+'~'+fnum(z.end)+u+'('+z.s+'구간)'; }).join(' · ');
  }

  // Ⅲ 자동 분석문 — PDF 원본 형식: "분모 X 중 분자 Y = Z%로 표준화 N구간(범위), 가중치 W점 중 P점 산정"
  //   미달 지표는 구간·점수 부분 빨강 강조, 만점 지표는 "가중치 W점 만점 산정" (원본 문구)
  function autoAna(r, full){
    var cd=r.cate_cd, w=n(r.stdweig), got=n(r.weigval), dtor=n(r.dtorval), s=n(r.s_score)||0;
    var rng = s ? zoneRange(cd, s) : '';
    var zone = s ? s+'구간'+(rng? '('+rng+')' : '') : '-';
    var lead;
    if (UNIT_PERSON.indexOf(cd)>=0)
      lead = '평균 재원환자 '+esc(fnum(r.ntorval))+'명 ÷ '+DENOM_NM[cd]+' '+esc(fnum(r.dtorval))+'명 = 1인당 <b>'+calDisp(r)+'</b>';
    else if (cd==='04')
      lead = '재직대상 '+esc(fnum(r.dtorval))+'일 중 재직 '+esc(fnum(r.ntorval))+'일 = <b>'+calDisp(r)+'</b>';
    else if (dtor>0)
      lead = '대상 '+esc(fnum(r.dtorval))+'명 중 해당 '+esc(fnum(r.ntorval))+'명 = <b>'+calDisp(r)+'</b>';
    else
      lead = '현황값 <b>'+calDisp(r)+'</b>';
    var conn = /[명일]\s*$/.test(String(calDisp(r))) ? '으로 ' : '로 ';
    var zoneTxt = '표준화 '+zone+', 가중치 '+fnum(w)+(full? '점 만점 산정.' : '점 중 '+f1(got)+'점 산정.');
    return lead + conn + (full? zoneTxt : '<span class="er-hl-bad">'+zoneTxt+'</span>');
  }

  // 5점 구간·도달 힌트 — assessment showIndiSummary 와 동일 계산
  //   · % 지표는 이 병원 분모 기준 명수로 환산한 구간 표시
  //   · fiveZone("+N명"=추가 필요 / "-N명"=감소 필요) 로 필요 인원 안내
  function fiveHint(r){
    var cd=r.cate_cd, c=CRIT[cd], dtor=n(r.dtorval);
    if(!c) return '';
    var range;
    if (UNIT_PERSON.indexOf(cd)>=0 || NOT_HEADCOUNT.indexOf(cd)>=0 || !(dtor>0))
      range = c.start+' ~ '+c.end+unitOf(cd);
    else if (c.direction==='lower')
      range = '0 ~ '+Math.floor(c.end*dtor/100)+'명';
    else
      range = Math.ceil(c.start*dtor/100)+' ~ '+Math.round(dtor)+'명';
    var need='', fz=String(r.fiveZone||'').trim();
    if (fz.charAt(0)==='+') need = ' · 5점 도달까지 '+esc(fz.substring(1))+' 추가 필요';
    else if (fz.charAt(0)==='-') need = ' · 5점 도달까지 '+esc(fz.substring(1))+' 감소 필요';
    return '5점 구간(해당 병원): '+esc(range)+need;
  }

  function toast(m){ var t=el('er-toast'); t.textContent=m; t.classList.add('er-show'); clearTimeout(t._tm); t._tm=setTimeout(function(){t.classList.remove('er-show');},2600); }
  // 버튼 실행 결과/오류/검증 알림 — SweetAlert2(전역 로드) 아이콘 다이얼로그. 라이브러리 없으면 toast 폴백.
  //   icon: 'success' | 'error' | 'warning' | 'info' / opt.title, opt.timer(자동닫힘 ms), opt.done(닫힌 뒤 콜백)
  function erSwal(icon, msg, opt){
    opt = opt || {};
    if(typeof Swal === 'undefined'){ toast(msg); if(opt.done) opt.done(); return; }
    var col = (icon==='error') ? '#e0416b' : (icon==='success') ? '#2e9e5b' : (icon==='warning') ? '#e0a52a' : '#2a7665';
    var c = { icon:icon||'info', text:msg, heightAuto:false, width:380, customClass:{ popup:'er-swal', container:'er-swal-top' },
              confirmButtonText:'확인', confirmButtonColor:col, buttonsStyling:true, allowEnterKey:true };
    if(opt.title) c.title = opt.title;
    if(opt.html){ c.html = opt.html; delete c.text; }
    if(opt.timer){ c.timer = opt.timer; c.timerProgressBar = true; c.showConfirmButton = false; }
    var p = Swal.fire(c);
    if(opt.done) p.then(function(){ opt.done(); });
  }
  // 버튼 실행 '선택(확인/취소)' 다이얼로그 — [확인] 눌렀을 때만 onYes 실행. SweetAlert2 폴백은 window.confirm.
  //   opt: title, icon('question'|'warning'), yes/no(버튼문구), color(확인버튼색)
  function erConfirm(msg, onYes, opt){
    opt = opt || {};
    if(typeof Swal === 'undefined'){ if(window.confirm(msg)){ if(onYes) onYes(); } return; }
    Swal.fire({
      icon: opt.icon || 'question',
      title: opt.title || '확인',
      text: msg,
      heightAuto: false,
      width: 380,
      customClass: { popup:'er-swal', container:'er-swal-top' },
      showCancelButton: true,
      reverseButtons: true,                 // [취소][확인] 순 — 확인이 오른쪽
      focusCancel: !!opt.focusCancel,
      confirmButtonText: opt.yes || '확인',
      cancelButtonText: opt.no || '취소',
      confirmButtonColor: opt.color || '#2a7665',
      cancelButtonColor: '#9aa4b2'
    }).then(function(r){ if(r && r.isConfirmed && onYes) onYes(); });
  }

  // 화면에 보이는 오류 표시(콘솔 못 볼 때 진단용)
  function showErr(msg){
    var nb=el('er-notice');
    if(nb){ nb.removeAttribute('data-mode'); nb.style.display=''; nb.style.background='#fdecea'; nb.style.borderColor='#f0b6ae'; nb.style.color='#a5281b';
            nb.innerHTML='⚠️ 월보고서 초기화 오류: '+esc(msg); }
  }

  // 고정 툴바 위치 실측 — 앱 상단 고정 네비 아래 + 좌측 사이드바 오른쪽(=본문 영역)에 맞춤.
  //   레이아웃 픽셀값을 직접 재므로 사이드바 폭·헤더 높이가 바뀌어도 안전. 창 크기 변경 시 재계산.
  function erFixToolbar(){
    var tb=document.querySelector('#evalReport .er-toolbar'); if(!tb) return;
    var hdr=document.getElementById('top-navbar')||document.getElementById('dashboard-header')||document.querySelector('.navbar.fixed-top');
    var top=hdr? Math.max(0, Math.round(hdr.getBoundingClientRect().bottom)) : 56;
    var sb=document.querySelector('.nav-left-sidebar'), left=0;
    if(sb){ var r=sb.getBoundingClientRect(); if(r.width>0 && r.left<=1) left=Math.round(r.right); }  // 사이드바가 좌측에 보일 때만 그 오른쪽으로
    tb.style.top=top+'px'; tb.style.left=left+'px'; tb.style.right='0';
    el('evalReport').style.paddingTop=(tb.offsetHeight)+'px';   // 고정 툴바에 본문이 가리지 않게 여백
  }
  window.addEventListener('resize', erFixToolbar);

  // ===== 글자 크기(문서 배율) — .er-doc 에 CSS zoom 적용(레이아웃 유지한 채 전체 배율).
  //   0.7~1.4, 0.1 단계. localStorage 저장으로 다음 진입에도 유지. 인쇄에도 그대로 반영됨.
  var _erZoom = 1;
  try{ var zv=parseFloat(localStorage.getItem('er_zoom')); if(zv>=0.7 && zv<=1.4) _erZoom=zv; }catch(e){}
  function erApplyZoom(){
    var d=erDoc(); if(d) d.style.zoom=_erZoom;
    var p=el('er-zoomPct'); if(p) p.textContent=Math.round(_erZoom*100)+'%';
    try{ localStorage.setItem('er_zoom', _erZoom); }catch(e){}
  }
  window.erZoom = function(dir){
    if(dir===0) _erZoom=1;
    else _erZoom=Math.min(1.4, Math.max(0.7, Math.round((_erZoom+dir*0.1)*10)/10));
    erApplyZoom();
  };
  erApplyZoom();   // 진입 시 저장된 배율 복원

  // 종료 → 적정성평가 현황(assessment)으로 복귀.
  //   복귀 진입 시 "재생성 확인" 팝업 없이 기존 자료만 바로 표시하도록 1회용 마커 전달.
  window.erExit = function(){
    try{ sessionStorage.setItem('skipRegenConfirm','1'); }catch(e){}
    // 월보고 목록에서 진입(_erFromList)했으면 종료 시 그 목록으로 복귀(목록 조회 년월 유지), 아니면 적정성평가 현황으로.
    if(_erFromList){
      var backYear = _erListYear || (curYm ? curYm.substring(0,4) : '');
      location.href = ctx + '/main/evalReportList.do' + (backYear ? ('?year=' + encodeURIComponent(backYear)) : '');
    } else {
      location.href = ctx + '/main/assessment.do';
    }
  };

  // 🖨️ 인쇄 — 브라우저 인쇄→'PDF로 저장' 시 기본 파일명은 document.title 을 사용.
  //   → 인쇄 직전 제목을 '{병원명} 적정성평가 보고서(년.월) 목표N등급' 으로 지정하고, 인쇄 종료(afterprint) 후 원복.
  window.erPrint = function(){
    var oldTitle = document.title;
    try{
      var yy=(curYm&&curYm.length>=6)?curYm.substring(0,4):'', mm=(curYm&&curYm.length>=6)?curYm.substring(4,6):'';
      var gg=(typeof goalGradeVal==='function')?goalGradeVal():'';
      document.title = (hospNm||'적정성평가') + ' 적정성평가 보고서' + (yy?('('+yy+'.'+mm+')'):'') + (gg?(' 목표'+gg):'');
    }catch(e){}
    var restore=function(){ try{ document.title=oldTitle; window.removeEventListener('afterprint',restore); }catch(e){} };
    try{ window.addEventListener('afterprint', restore); }catch(e){}
    window.print();
  };

  // 📄 한글저장 — 보고서를 아래한글·워드가 여는 문서(.doc, Word-HTML)로 저장. 화면 이동 없이 Blob 다운로드.
  //   HWP(독점 포맷) 직접 생성은 불가하므로, 아래한글이 잘 여는 Word-HTML(.doc)로 내보냄. 표·문구·점수·색 대부분 유지.
  window.erExportDoc = function(){
    if(!curYm){ toast('먼저 평가년월을 조회하세요.'); return; }
    var src = document.querySelector('#evalReport .er-doc');
    if(!src){ toast('내보낼 보고서 내용이 없습니다.'); return; }
    if(editing) erToggleEdit();                                   // 편집 표시(파란 테두리) 제거 후 내보내기
    // 워드·아래한글은 <style> 의 복합선택자(#evalReport .er-…)·flex/grid·그라데이션을 대부분 무시.
    //   → 라이브 DOM의 '계산된 스타일'을 클론에 인라인 style 로 옮겨(워드가 인라인은 잘 따름) 색·표 테두리·정렬 재현.
    var clone = src.cloneNode(true);
    var PROPS = ['color','background-color','font-weight','font-size','font-family','font-style',
                 'text-align','vertical-align','line-height','white-space',
                 'border-top-width','border-top-style','border-top-color',
                 'border-bottom-width','border-bottom-style','border-bottom-color',
                 'border-left-width','border-left-style','border-left-color',
                 'border-right-width','border-right-style','border-right-color',
                 'padding-top','padding-right','padding-bottom','padding-left'];
    (function inline(s, c){
      if(s.nodeType===1 && c.nodeType===1 && s.tagName){
        var cs = window.getComputedStyle(s), st = c.getAttribute('style') || '';
        PROPS.forEach(function(p){ var v=cs.getPropertyValue(p); if(v) st += p+':'+v+';'; });
        // 그라데이션 배경(네이비 헤더·뱃지 등)은 워드 미지원 → 단색 폴백(흰 글자가 안 보이는 문제 방지)
        var bi = cs.getPropertyValue('background-image');
        if(bi && bi.indexOf('gradient')>=0){
          st += 'background-color:'+(/rgb\(255, 255, 255\)/.test(cs.getPropertyValue('color')) ? '#1e3c72' : '#eef2f9')+';';
        }
        if(c.tagName==='TABLE'){ st += 'border-collapse:collapse;'; }
        if(c.tagName==='IMG' || c.tagName==='SVG'){ /* 유지 */ }
        c.setAttribute('style', st);
        c.removeAttribute('contenteditable'); c.removeAttribute('data-key'); c.removeAttribute('id');
      }
      for(var i=0, sc=s.childNodes, cc=c.childNodes; i<sc.length && i<cc.length; i++) inline(sc[i], cc[i]);
    })(src, clone);
    var body = '<div style="background:#fff;font-family:\'Malgun Gothic\',sans-serif;">' + clone.innerHTML + '</div>';
    var html = '<html xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:w="urn:schemas-microsoft-com:office:word" xmlns="http://www.w3.org/TR/REC-html40">'
             + '<head><meta charset="utf-8"><title>'+esc((hospNm||'적정성평가')+' 컨설팅 보고서')+'</title>'
             + '<style>@page{size:A4;margin:15mm;} body{margin:0;}</style></head><body>'+body+'</body></html>';
    try{
      var blob = new Blob(['﻿'+html], { type:'application/msword' });   // ﻿ = UTF-8 BOM(한글 인코딩)
      var url = URL.createObjectURL(blob);
      var a = document.createElement('a');
      a.href = url;
      a.download = (hospNm||'적정성평가').replace(/[\\/:*?"<>|]/g,'') + '_' + (curYm||'') + '_컨설팅보고서.doc';
      document.body.appendChild(a); a.click(); document.body.removeChild(a);
      setTimeout(function(){ URL.revokeObjectURL(url); }, 1500);
      toast('한글/워드 문서(.doc)로 저장했습니다. 아래한글에서 열어 편집하세요.');
    }catch(e){ toast('문서 저장 중 오류: '+((e&&e.message)||e)); }
  };

  // 월보고 목록 — 저장된 보고서 목록(evalReportList.jsp)으로 이동. 다른 메뉴처럼 사이드바 우측 콘텐츠 영역에 표시(.main 타일).
  //   현재 조회 년월을 넘겨 초기 필터로 사용. 목록에서 행 클릭 → evalReport.do?hospCd=&hospNm=&ym= 로 진입(URL 파라미터가 쿠키보다 우선).
  window.erOpenList = function(){
    var ym = (el('er-year') && el('er-month')) ? (el('er-year').value + el('er-month').value) : (curYm || '');
    location.href = ctx + '/main/evalReportList.do' + (ym ? ('?ym=' + encodeURIComponent(ym)) : '');
  };

  // 도움말 — 버튼에 마우스를 올리면 뜨는 '떠 있는' 팝오버(position:fixed). 아래 콘텐츠 영역을 차지하지 않음.
  function erHelpContent(){
    return '<b>진행 순서</b> <span style="font-weight:600;">(①→②→③→④ · PDF첨부가 마지막)</span><br>'
      +'① <b>조회</b> — 평가년월을 고르면 표·점수가 자동으로 채워집니다.<br>'
      +'② <b>✏️ 편집 → 💾 저장</b> — 문구를 고친 뒤 저장(요약 점수·문구가 DB에 저장).<br>'
      +'③ <b>✔ 승인</b> — 그 시점 수치가 동결되고 거래처에 공개됩니다(내용 확정).<br>'
      +'④ <b>📎 PDF첨부</b> — <b>승인 후</b> 확정본을 PDF로 첨부(화면 생성 또는 아래한글 완성본 업로드). 거래처에는 이 PDF가 우선 제공됩니다.<br>'
      +'<span style="color:var(--er-soft);">※ PDF첨부는 <b>승인해야</b> 가능합니다(공개본과 PDF 일치). 내용을 고치려면 <b>↩ 승인취소</b> 후 다시 진행하세요.</span>';
  }
  var _erHelpTm;
  window.erHelpShow = function(){
    clearTimeout(_erHelpTm);
    var pop=el('er-helpPop'), btn=el('er-help'); if(!pop || !btn) return;
    if(pop.style.display!=='block') pop.innerHTML = erHelpContent();
    pop.style.display='block';
    var r=btn.getBoundingClientRect();
    pop.style.top=(r.bottom+6)+'px';
    pop.style.left=Math.max(8, r.left-20)+'px';
    var pr=pop.getBoundingClientRect();                       // 오른쪽 넘침 보정
    if(pr.right > window.innerWidth-8) pop.style.left=Math.max(8, window.innerWidth-8-pr.width)+'px';
  };
  window.erHelpKeep = function(){ clearTimeout(_erHelpTm); };  // 팝오버 위로 마우스 이동 시 유지
  window.erHelpHide = function(){ _erHelpTm=setTimeout(function(){ var pop=el('er-helpPop'); if(pop) pop.style.display='none'; }, 200); };

  // 미리보기 — 작성 중인 보고서를 인쇄 형태(A4 지면)로 화면에서 확인. 편집 중이면 끄고 진입.
  window.erPreview = function(){
    if(editing) erToggleEdit();
    el('evalReport').classList.add('er-preview');
    window.scrollTo(0,0);
  };
  window.erPreviewExit = function(){ el('evalReport').classList.remove('er-preview'); };

  // ===== A4 자동 페이지 분할(WYSIWYG) =====
  //   원본 섹션(.er-srcpage)은 편집·저장의 원본으로 그대로 두고(숨김), 그 내용을 '복제'해
  //   A4(210×297mm) 실측 페이지(.er-autopage)에 흐름 단위로 담는다. 복제본은 id/data-key/편집속성을
  //   제거해 저장·조회 로직과 충돌하지 않는다. 편집 중에는 분할을 끄고(자연 흐름) 편집이 편하게 한다.
  // [원복 2026-07-15] A4 자동분할 비활성 — 경우의 수(고아페이지·간격·편집동기화)가 많아 일단 끔.
  //   false = 이전 방식: 화면은 섹션 카드 연속, 인쇄는 표지 1장 + 연속 흐름(최소 단위만 page-break-inside:avoid).
  //   재도입 시 true 로만 바꾸면 분할·복제편집 로직 그대로 살아남 (아래 erPaginate 일체).
  var PAGE_ON = false;

  function erDoc(){ return document.querySelector('#evalReport .er-doc'); }
  function erTagSrcPages(){
    var doc=erDoc(); if(!doc) return;
    Array.prototype.forEach.call(doc.querySelectorAll(':scope > .er-page'), function(p){ p.classList.add('er-srcpage'); });
  }

  function erStrip(node){
    if(node.nodeType!==1) return;
    var all=[node].concat(Array.prototype.slice.call(node.querySelectorAll('*')));
    all.forEach(function(e){
      e.removeAttribute('id'); e.removeAttribute('contenteditable');
      // data-key → data-ckey 로 개명: 저장 로직(editables)은 원본만 수집, 복제본은 편집 시 원본으로 동기화
      var k=e.getAttribute('data-key');
      if(k!=null){ e.setAttribute('data-ckey',k); e.removeAttribute('data-key'); }
    });
  }
  function erClone(node){ var c=node.cloneNode(true); erStrip(c); return c; }

  function erCollectUnits(doc){
    var units=[];
    Array.prototype.forEach.call(doc.querySelectorAll(':scope > .er-srcpage'), function(pg){
      if(pg.classList.contains('er-cover')) return;   // 표지는 별도 처리
      Array.prototype.forEach.call(pg.children, function(top){
        if(!top.classList || !top.classList.contains('er-sec')){
          units.push({ nodes:[top], keep:false });    // 섹션 밖 요소(docfoot 등)도 포함
          return;
        }
        Array.prototype.forEach.call(top.children, function(ch){
          var id=ch.id||'';
          if(ch.classList.contains('er-eyebrow')){    // 큰 섹션(Ⅰ~Ⅴ) 헤더 = 항상 새 페이지 시작
            units.push({ nodes:[ch], keep:true, newPage:true });
          } else if(id==='er-sec3Body'){   // Ⅲ: 그룹라벨 / (지표제목+분석박스) 쌍 단위로 분해
            var kids=Array.prototype.slice.call(ch.children);
            for(var i=0;i<kids.length;i++){
              var k=kids[i];
              if(k.classList.contains('er-indhead')){
                var grp=[k];
                if(kids[i+1] && kids[i+1].classList.contains('er-indbox')){ grp.push(kids[i+1]); i++; }
                units.push({ nodes:grp, keep:false });
              } else {
                units.push({ nodes:[k], keep:k.classList.contains('er-grplabel') });
              }
            }
          } else if(id==='er-sec4Body'){   // Ⅳ: 권고 카드 각각
            Array.prototype.forEach.call(ch.children, function(k){ units.push({ nodes:[k], keep:false }); });
          } else {
            units.push({ nodes:[ch], keep:ch.classList.contains('er-subh') });
          }
        });
      });
    });
    return units;
  }

  function erNewPage(doc){
    var p=document.createElement('div'); p.className='er-autopage';
    var b=document.createElement('div'); b.className='er-autobody';
    p.appendChild(b); doc.appendChild(p); return b;
  }
  // 한 페이지가 담을 수 있는 실제 콘텐츠 높이(px) = 페이지 clientHeight − 상하 패딩
  function erCapacity(body){
    var p=body.parentNode, cs=window.getComputedStyle(p);
    return p.clientHeight - parseFloat(cs.paddingTop||0) - parseFloat(cs.paddingBottom||0);
  }
  function erAppendUnit(body,u){
    u._clones=[];
    u.nodes.forEach(function(nd){ var c=erClone(nd); body.appendChild(c); u._clones.push(c); });
  }
  function erRemoveUnit(u){ if(u._clones) u._clones.forEach(function(c){ c.remove(); }); u._clones=[]; }

  window.erPaginate = function(){
    var root=el('evalReport'), doc=erDoc(); if(!doc) return;
    erTagSrcPages();
    Array.prototype.forEach.call(doc.querySelectorAll('.er-autopage'), function(p){ p.remove(); });
    if(!PAGE_ON){ root.classList.remove('er-paged'); return; }
    root.classList.add('er-paged');
    // 표지 페이지(가운데 정렬 그대로 복제)
    var cover=doc.querySelector(':scope > .er-srcpage.er-cover');
    if(cover){
      // er-cover 클래스 유지 — 표지 전용 스타일(.er-cover .er-cover-title 등)이 복제본에도 적용되게
      var cp=document.createElement('div'); cp.className='er-autopage er-cover-page er-cover';
      Array.prototype.forEach.call(cover.children, function(ch){ cp.appendChild(erClone(ch)); });
      doc.appendChild(cp);
    }
    // 본문 흐름 단위 → A4 실측 채우기 (섹션 헤더는 항상 새 페이지 시작)
    var units=erCollectUnits(doc);
    var body=erNewPage(doc), maxH=erCapacity(body);
    units.forEach(function(u){
      // 섹션(Ⅰ~Ⅴ) 헤더: 현재 장의 남은 공간이 45% 미만이면 새 장에서 시작,
      // 충분히 남았으면(직전 섹션 꼬리만 있는 거의 빈 장 등) 같은 장에 간격 두고 이어붙임
      if(u.newPage && body.children.length){
        var remain = maxH - body.scrollHeight;
        if(remain < maxH*0.45){ body=erNewPage(doc); maxH=erCapacity(body); }
      }
      erAppendUnit(body,u);
      var overflow = body.scrollHeight > maxH+1;
      var onlyThis = (body.children.length <= u.nodes.length);
      if(overflow && !onlyThis){                         // 넘치면 다음 페이지로
        erRemoveUnit(u); body=erNewPage(doc); maxH=erCapacity(body); erAppendUnit(body,u);
      } else if(u.keep && !onlyThis && (maxH - body.scrollHeight) < 130){
        // 라벨·소제목이 페이지 맨 아래에 홀로 남지 않게 다음 페이지로 넘김
        erRemoveUnit(u); body=erNewPage(doc); maxH=erCapacity(body); erAppendUnit(body,u);
      }
    });
    erSetCloneEditable();   // 편집 중 재분할 시 편집 가능 상태 유지
  };

  // A4 복제본 편집 지원 — 복제본([data-ckey])을 직접 편집하면 원본([data-key])에 실시간 반영.
  //   저장(collectTexts)·자동스냅샷(AUTO)은 원본 기준 그대로라 저장 로직 무변경.
  function erSetCloneEditable(){
    Array.prototype.forEach.call(document.querySelectorAll('#evalReport .er-autopage [data-ckey]'), function(e){
      e.contentEditable = editing? 'true':'false';
    });
  }
  document.addEventListener('input', function(ev){
    // 편집 대상은 두 형태 — 복제본([data-ckey], A4 미리보기) 또는 원본([data-key], 본문). 둘 다 감지.
    var t = ev.target && ev.target.closest ? ev.target.closest('[data-ckey],.er-editable[data-key]') : null;
    if(!t) return;
    var ck = t.getAttribute('data-ckey');
    if(ck!=null){   // 복제본 편집 → 원본에 실시간 반영
      var src = document.querySelector('#evalReport .er-editable[data-key="'+ck+'"]');
      if(src) src.innerHTML = t.innerHTML;
    }
    markDirty();   // 원본·복제본 어느 쪽을 고쳐도 → '수정중 · 미저장' 표시
  });

  // 첨부 PDF 미리보기 — download.do 가 강제 다운로드(attachment)라 iframe 직접 불가 →
  //   fetch 로 blob 을 받아 application/pdf 로 objectURL 만들어 모달 iframe 에 표시(자바 변경 없음).
  //   재열기 안정화: ① 열 때마다 iframe 을 새 노드로 교체(이전 뷰어 상태 초기화)
  //                 ② objectURL revoke 는 닫을 때가 아니라 '다음 열기'에서(뷰어 사용 중 revoke 로 인한 실패 방지)
  //                 ③ 캐시 회피(no-store + ts 파라미터) ④ 늦게 도착한 이전 fetch 응답 무시(seq)
  var _pdfSeq = 0, _pdfObjUrl = null;
  window.erPdfPreview = function(){
    if(!pdfPath){ toast('첨부된 PDF가 없습니다.'); return; }
    var seq = ++_pdfSeq;
    var name = pdfPath.split('/').pop();
    var dlUrl = ctx+'/sftp/download.do?filePath='+encodeURIComponent(pdfPath)+'&_ts='+Date.now();
    el('er-pdfModalTitle').textContent = '📄 ' + (name || '첨부 PDF');
    // 열람 모드 버튼: 저장/파일선택 숨김, 교체검색(위너넷) 노출
    el('er-pdfGenSaveBtn').style.display='none'; el('er-pdfPickBtn').style.display='none';
    el('er-pdfModalReplace').style.display = isWinner ? '' : 'none';
    // iframe 새로 교체 — 같은 노드 재사용 시 두 번째 열기부터 간헐적으로 렌더 안 되는 문제 방지
    var old = el('er-pdfFrame'), nf = old.cloneNode(false);
    nf.removeAttribute('src');
    old.parentNode.replaceChild(nf, old);
    el('er-pdfLoading').style.display = 'flex';
    el('er-pdfLoading').textContent = 'PDF를 불러오는 중입니다…';
    el('er-pdfModal').style.display = 'flex';
    fetch(dlUrl, { credentials:'same-origin', cache:'no-store' })
      .then(function(r){ if(!r.ok) throw new Error('HTTP '+r.status); return r.blob(); })
      .then(function(b){
        if(seq !== _pdfSeq) return;                       // 이미 닫혔거나 새로 열림 → 무시
        if(_pdfObjUrl) URL.revokeObjectURL(_pdfObjUrl);   // 이전 URL 은 지금(새로 열 때) 정리
        _pdfObjUrl = URL.createObjectURL(new Blob([b], { type:'application/pdf' }));
        el('er-pdfFrame').src = _pdfObjUrl;
        el('er-pdfLoading').style.display = 'none';
      })
      .catch(function(e){
        if(seq !== _pdfSeq) return;
        el('er-pdfLoading').textContent = 'PDF를 불러오지 못했습니다('+(e&&e.message||'오류')+'). 닫고 다시 시도해 주세요.';
      });
  };
  window.erPdfClose = function(){
    _pdfSeq++;                                            // 진행 중 fetch 무효화 (revoke 는 다음 열기에서)
    el('er-pdfModal').style.display = 'none';
  };
  // 오버레이(모달 바깥) 클릭 시 닫기
  // (바깥 클릭으로는 닫지 않음 — 실수로 닫히는 것 방지. 닫기는 ✕ 닫기 버튼 또는 ESC 로만)

  document.addEventListener('keydown', function(e){   // ESC — 미리보기/PDF모달 닫기
    if(e.key!=='Escape') return;
    if(el('er-pdfModal') && el('er-pdfModal').style.display==='flex'){ erPdfClose(); return; }
    if(el('evalReport') && el('evalReport').classList.contains('er-preview')) erPreviewExit();
  });

  // 평가년월 결정: ①URL ?ym=YYYYMM ②적정성평가 화면 sessionStorage(assessment_year/month) ③지난달
  function defaultYm(){
    var qm = (_erOpenYm && /^\d{6}$/.test(_erOpenYm)) ? _erOpenYm : (location.search.match(/[?&]ym=(\d{6})/)||[])[1];
    if(qm) return { y:qm.substring(0,4), m:qm.substring(4,6) };
    var sy=(sessionStorage.getItem('assessment_year')||'').trim();
    var sm=(sessionStorage.getItem('assessment_month')||'').trim();
    if(sy && sm) return { y:sy, m:('0'+sm).slice(-2) };
    var d=new Date(); d=new Date(d.getFullYear(), d.getMonth()-1, 1);   // 지난달
    return { y:String(d.getFullYear()), m:('0'+(d.getMonth()+1)).slice(-2) };
  }

  // 년/월 셀렉트 채우기
  (function initSel(){
    try{
      var y=new Date().getFullYear();
      var ys=el('er-year'), ms=el('er-month');
      if(!ys || !ms){ showErr('셀렉트 요소를 찾지 못했습니다(캐시된 옛 화면일 수 있음 · Ctrl+F5).'); return; }
      var def=defaultYm();
      var minY=Math.min(y-9, parseInt(def.y,10)||y), maxY=Math.max(y, parseInt(def.y,10)||y);   // 넘어온 년도가 범위 밖이어도 포함
      var html=''; for(var yy=maxY; yy>=minY; yy--){ html+='<option value="'+yy+'">'+yy+'</option>'; } ys.innerHTML=html;
      var mh=''; for(var mo=1;mo<=12;mo++){ var mm=('0'+mo).slice(-2); mh+='<option value="'+mm+'">'+mm+'</option>'; } ms.innerHTML=mh;
      ys.value=def.y; ms.value=def.m;
      ys.disabled = true; ms.disabled = true;   // 작업년월은 들어온 월로 고정(수정 불가) — 조회 버튼 없음, 진입 시 자동 조회
      el('er-hospNm').textContent = hospNm ? ('['+hospNm+']') : '';
      if(hospNm) el('er-coverHosp').textContent = hospNm;
      if(!isWinner){                          // 거래처: 편집도구(편집~PDF) 숨김(열람·인쇄만)
        el('er-editTools').style.display='none';
        el('er-roleTag').textContent='거래처';
      }
      if(_erReadonly){                        // 이력 열람(읽기전용): 편집·저장·승인·PDF첨부 전부 숨김 — 열람·인쇄만
        el('er-editTools').style.display='none';
        el('er-roleTag').textContent='이력 열람';
        var _sb=el('er-statusBadge'); if(_sb){ _sb.className='er-status er-new'; }
        var _st=el('er-statusText'); if(_st){ _st.textContent='읽기전용(이력 열람)'; }
        var _hi=el('er-hstInfo');             // 어느 이력을 보는지 칩 표시(유형·작성자·시각)
        if(_hi && _erHstInfo){
          var _lb=esc(_erHstInfo.label||'이력'), _mu=esc(_erHstInfo.user||''), _mt=esc(_erHstInfo.time||'');
          _hi.innerHTML = '📜 이력조회 · '+_lb+' <span class="er-hstmeta">'+((_mu||_mt)?('('+[_mu,_mt].filter(Boolean).join(' · ')+')'):'')+'</span>';
          _hi.style.display='inline-flex';
        }
      }
      erFixToolbar();                         // 툴바 위치 확정
      setTimeout(erFixToolbar, 200);          // 앱 레이아웃(헤더/사이드바) 렌더 후 재보정
    }catch(e){ showErr((e&&e.message)||e); }
  })();

  function editables(){ return document.querySelectorAll('#evalReport .er-editable[data-key]'); }

  // 문서 상태 = 승인됨 / 수정중·미저장(dirty) / 저장됨(DB저장 후 변경없음) / 신규·미저장(저장이력 없음)
  var _erSaved=false, _erDirty=false;
  function updateBadge(){
    var b=el('er-statusBadge'), t=el('er-statusText'); if(!b||!t) return;
    if(_erReadonly){ b.className='er-status er-new'; t.textContent='읽기전용(이력 열람)'; return; }   // 이력 열람 우선
    if(approved){ b.className='er-status er-approved'; t.textContent='승인됨 · 거래처 공개'; return; }
    if(_erDirty){ b.className='er-status er-dirty';  t.textContent='수정중 · 미저장'; return; }
    if(_erSaved){ b.className='er-status er-stored'; t.textContent='저장됨'; return; }
    b.className='er-status er-new'; t.textContent='신규 · 미저장';
  }
  function markDirty(){ if(!approved && !_erDirty){ _erDirty=true; updateBadge(); } }
  function setStatus(st){
    approved = (st==='APPROVED');
    updateBadge();
    if(isWinner){
      el('er-btnApprove').textContent = approved ? '↩ 승인취소' : '✔ 승인';
      el('er-btnApprove').title = approved
        ? '승인을 취소하면 다시 편집이 가능합니다(거래처 공개·PDF첨부 해제)'
        : '③ 승인 — 그 시점 수치가 동결되고 거래처에 공개됩니다. 승인 후 ④ PDF첨부가 가능합니다.';
      el('er-btnEdit').disabled = approved;
      if(approved && editing) erToggleEdit();
    }
    try{ updatePdfUi(); }catch(e){}   // 승인/승인취소에 따라 PDF첨부(재생성) 버튼 노출 갱신
  }

  window.erToggleEdit = function(){
    if(_erReadonly){ erSwal('info','이력 열람(읽기전용)입니다. 편집·저장·승인·PDF첨부는 목록에서 정상 진입해 주세요.'); return; }
    if(approved){ erSwal('warning','승인된 보고서는 편집할 수 없습니다. 승인 취소 후 편집하세요.'); return; }
    editing=!editing;
    el('evalReport').classList.toggle('er-editmode', editing);
    erPaginate();   // A4 분할 유지한 채 재분할 — 편집 종료 시 고친 문구 길이에 맞게 페이지 재배치
    editables().forEach(function(e){ e.contentEditable = editing?'true':'false'; });
    var b=el('er-btnEdit'); b.textContent=editing?'✏️ 편집끄기':'✏️ 편집켜기'; b.classList.toggle('er-on',editing);
    if(editing) toast('편집 모드: 파란 영역의 문구를 직접 고칠 수 있습니다.');
  };

  // ===== 서식 툴 (편집 모드 전용) — 답변 에디터(summernote) 구성 참조: B/I/U/지우개 + 글꼴 + 크기(px) + 색상 A▾.
  //   execCommand 기반(구형 브라우저 호환). 결과는 편집영역 innerHTML 에 인라인으로 남아
  //   저장(override)·재조회·인쇄·거래처 열람에 그대로 반영됨. 편집영역 밖은 contentEditable 이 아니라 불변.
  //   · select(글꼴/크기) 클릭 시 본문 선택이 풀리므로 selectionchange 에서 마지막 선택영역을 저장했다가 복원.
  var _fmtRange=null, _fmtColor='#fff3b0', _fmtColorIsBg=true;   // 기본 = 노랑 형광(답변 에디터 A 초기 표시와 동일)
  document.addEventListener('selectionchange', function(){
    if(!editing) return;
    var sel=window.getSelection();
    if(!sel || !sel.rangeCount) return;
    var nd=sel.anchorNode; if(nd && nd.nodeType===3) nd=nd.parentNode;
    if(nd && nd.closest && nd.closest('#evalReport .er-editable')) _fmtRange=sel.getRangeAt(0).cloneRange();
  });
  function _fmtRestore(){
    try{ if(_fmtRange){ var sel=window.getSelection(); sel.removeAllRanges(); sel.addRange(_fmtRange); } }catch(e){}
  }
  window.erFmt = function(cmd, val){
    if(!editing){ toast('편집 켜기 후, 문구를 드래그로 선택하고 누르세요.'); return; }
    _fmtRestore();
    try{ document.execCommand('styleWithCSS', false, true); }catch(e){}   // <font> 대신 span style 로
    if(cmd==='bold')           document.execCommand('bold');
    else if(cmd==='italic')    document.execCommand('italic');
    else if(cmd==='underline') document.execCommand('underline');
    else if(cmd==='font'){     if(val) document.execCommand('fontName', false, val); }
    else if(cmd==='sizepx'){
      if(val){
        // execCommand fontSize 는 1~7 단계뿐 → 7로 찍은 뒤 <font size="7"> 를 px 스팬으로 치환
        try{ document.execCommand('styleWithCSS', false, false); }catch(e){}
        document.execCommand('fontSize', false, '7');
        var fs=document.querySelectorAll('#evalReport .er-editable font[size="7"]');
        Array.prototype.forEach.call(fs, function(f){
          var sp=document.createElement('span'); sp.style.fontSize=val+'px';
          while(f.firstChild) sp.appendChild(f.firstChild);
          f.parentNode.replaceChild(sp, f);
        });
      }
    }
    else if(cmd==='color'){
      if(_fmtColorIsBg){ if(!document.execCommand('hiliteColor', false, _fmtColor)) document.execCommand('backColor', false, _fmtColor); }
      else document.execCommand('foreColor', false, _fmtColor);
      erPalClose();
    }
    else if(cmd==='clear')     document.execCommand('removeFormat');
  };
  window.erPalToggle = function(){
    var p=el('er-fpal'); if(!p) return;
    if(!p.classList.contains('er-open')){
      // 툴바가 overflow(가로 스크롤) 컨테이너라 absolute 드롭다운이 잘림 → 화면 고정 좌표로 전환해 띄움
      var btn=document.querySelector('#evalReport .er-fcaret');
      if(btn && btn.getBoundingClientRect){
        var rc=btn.getBoundingClientRect();
        p.style.position='fixed'; p.style.top=(rc.bottom+5)+'px';
        p.style.left=Math.max(8, rc.right-172)+'px'; p.style.right='auto';
      }
    }
    p.classList.toggle('er-open');
  };
  window.erPalClose  = function(){ var p=el('er-fpal'); if(p) p.classList.remove('er-open'); };
  window.erFmtPick = function(color, isBg){
    _fmtColor=color; _fmtColorIsBg=!!isBg;
    var a=document.querySelector('#er-fA b');
    if(a) a.style.borderBottomColor = (color==='transparent') ? '#d7dfea' : color;
    erFmt('color');
  };
  document.addEventListener('mousedown', function(ev){   // 팔레트 바깥 클릭 시 닫기
    var p=el('er-fpal');
    if(p && p.classList.contains('er-open') && !(ev.target.closest && ev.target.closest('.er-fcolor'))) erPalClose();
  });

  // ===== 조회: 지표 자료 + 5점구간 기준(적정성 화면과 동일 소스) 동시 로드 → 렌더 → 저장문구 로드 =====
  window.erLoad = function(){
    curYm = el('er-year').value + el('er-month').value;
    if(!hospCd){ erSwal('warning','로그인 병원 정보가 없습니다.'); return; }
    var aIndi = jQuery.ajax({ url: ctx+'/main/select_Eval_Indi.do',     type:'POST', dataType:'json', data:{ hosp_cd:hospCd, jobyymm:curYm } });
    var aCrit = jQuery.ajax({ url: ctx+'/main/select_ScoreCriteria.do', type:'POST', dataType:'json', data:{ jobyymm:curYm } });
    // 전월 지표(총평 P1 전월대비) — 7월은 새 평가기간 시작이라 생략. 조회 실패는 null 로 흡수(본 조회에 영향 없음)
    var aPrev = (curYm.substring(4,6)==='07')
        ? jQuery.Deferred().resolve(null).promise()
        : jQuery.ajax({ url: ctx+'/main/select_Eval_Indi.do', type:'POST', dataType:'json',
                        data:{ hosp_cd:hospCd, jobyymm:prevYmOf(curYm) } })
            .then(function(d){ return d; }, function(){ return jQuery.Deferred().resolve(null).promise(); });
    // [★6] 배뇨관리(06) 보완형용 — 오류점검(assesCheck flag 07 배뇨훈련) '미체크(분자제외)' 건수. 실패는 null 흡수.
    var aBladder = jQuery.ajax({ url: ctx+'/main/select_assesCheck.do', type:'POST', dataType:'json',
                                 data:{ hospCd:hospCd, jobYymm:curYm, jobFlag:'07' } })
        .then(function(d){ return d; }, function(){ return jQuery.Deferred().resolve(null).promise(); });
    // [C1·C2] 당월/누적/월별 점수 — 시스템 SP(dashbordINDICATORS). 뺄셈 근사가 아닌 공식 산출값. 실패는 null 흡수.
    var aDash = jQuery.ajax({ url: ctx+'/main/dashbordINDICATORS.do', type:'POST', dataType:'json',
                              data:{ hosp_cd:hospCd, mg_year:curYm.substring(0,4), mgmonth:curYm.substring(4,6) } })
        .then(function(d){ return d; }, function(){ return jQuery.Deferred().resolve(null).promise(); });
    jQuery.when(aIndi, aCrit, aPrev, aBladder, aDash).done(function(r1, r2, r3, r4, r5){
      var res = r1[0];
      indicators = (res && res.data)? res.data.filter(function(r){ return r.cate_cd!=='99'; }) : [];
      buildCriteria(r2[0]);
      prevTotal = null;
      var pd = (r3 && r3.data) || [], pt = 0, pHas = false;
      pd.forEach(function(r){ if(r.cate_cd!=='99'){ pt += n(r.weigval); if(n(r.weigval)>0) pHas = true; } });
      if(pHas) prevTotal = Math.round(pt*10)/10;
      _bladderGapN = 0;   // '분자제외' 표기된 배뇨 미체크 건만 집계(패드/기저귀 오류는 제외)
      var bd = (r4 && r4[0] && r4[0].data) || [];
      bd.forEach(function(e){ if(String(e.errName||'').indexOf('분자제외')>=0) _bladderGapN++; });
      _dashInd = (r5 && r5[0]) ? r5[0] : null;   // [C1·C2] 당월/누적/월별 점수
      renderAll();
      loadSavedTexts();
    }).fail(function(){ erSwal('error','지표 자료 조회 중 오류가 발생했습니다.', {title:'오류'}); });
  };

  function computeScores(){
    var st=0,md=0,tot=0;
    indicators.forEach(function(r){
      var w=n(r.weigval); tot+=w;
      if(r.cate_fg==='10') st+=w; else if(r.cate_fg==='21'||r.cate_fg==='22') md+=w;
    });
    scores={ struct:st, care:md, total:tot };
  }

  function goalScoreVal(){ var e=document.querySelector('#evalReport [data-key="cover_goal_score"]'); return e? (n(e.textContent)||78):78; }
  function goalGradeVal(){ var e=document.querySelector('#evalReport [data-key="cover_goal_grade"]'); return e? e.textContent.trim():'3등급'; }

  // 차등제 등록(TBL_GRADE_MST) 목표값을 표지의 목표점수/목표등급/뱃지에 반영.
  //   goal = { goalscore, hospgrade }(서버). 목표값은 병원이 직접 등록한 사실값이므로,
  //   저장 override(옛 하드코딩 3등급/78 등)를 무시하고 항상 마스터값으로 덮어씀.
  //   마스터에 값이 없는(미등록) 분기면 아무것도 안 바꿔 기존 표시 유지.
  //   hospgrade 는 숫자('1')로 저장 → '1등급' 표기로 변환.
  function applyGoalDefault(goal){
    if(!goal) return;
    var gs = (goal.goalscore!=null && goal.goalscore!=='') ? fnum(goal.goalscore) : '';
    var hg = (goal.hospgrade!=null && String(goal.hospgrade).trim()!=='') ? String(goal.hospgrade).trim() : '';
    // 목표등급 = 저장된 병원등급(HOSPGRADE) 우선. 등급이 비어 있으면 목표점수로부터 유도(점수/등급 일관성).
    var gradeTxt = hg ? (hg.indexOf('등급')>=0 ? hg : hg+'등급')
                      : (gs!=='' ? gradeOf(goal.goalscore) : '');
    function setVal(key, val){
      if(!val) return;
      var e=document.querySelector('#evalReport [data-key="'+key+'"]');
      if(e){ e.textContent = val; AUTO[key] = e.innerHTML; }   // 자동값 갱신 → 저장 시 편집으로 오인 방지
    }
    setVal('cover_goal_score', gs);
    setVal('cover_goal_grade', gradeTxt);
    setVal('cover_goal_badge', gradeTxt);
  }

  function renderAll(){
    computeScores();
    var period = curYm.substring(0,4)+'년 '+curYm.substring(4,6)+'월';
    el('er-coverPeriod').textContent = period;
    el('er-coverTotal').textContent = f1(scores.total);
    if(!el('er-coverDate').textContent || el('er-coverDate').textContent==='-'){
      var t=new Date(); el('er-coverDate').textContent = t.getFullYear()+'. '+('0'+(t.getMonth()+1)).slice(-2)+'. '+('0'+t.getDate()).slice(-2)+'.';
    }
    el('er-cardStruct').textContent=f1(scores.struct); el('er-cardCare').textContent=f1(scores.care); el('er-cardTotal').textContent=f1(scores.total);
    el('er-rateStruct').textContent = scores.struct>0? (Math.round(scores.struct/30*1000)/10)+'%' : '-';
    el('er-rateCare').textContent   = scores.care>0?   (Math.round(scores.care/70*1000)/10)+'%'   : '-';
    el('er-curGrade').textContent = gradeOf(scores.total);
    el('er-afterFrom').textContent = f1(scores.total);
    renderGoalSummary();   // 목표점수/등급 의존 영역(부족점수·등급표) — 목표값 변경 후 단독 재호출 가능
    // 우선지표(부족분 상위 6)
    var pri = topGaps(6);
    el('er-priBody').innerHTML = pri.length? pri.map(function(x,i){
      var room = (TPL_ROOM[x.cd]||'') + (i<2 ? ' (최우선)' : '');   // 원본 PDF "개선 여지" 문구 + 상위2 최우선
      var gapCls = i<2 ? 'er-gaphl' : 'er-b-bad';                   // 최우선(상위2) 부족분 = 연분홍 배경 강조(원본)
      return '<tr><td>'+(i+1)+'</td><td class="er-l">'+esc(x.nm)+'</td><td>'+areaNm(x.fg)+'</td><td class="er-num">'+fnum(x.w)+'</td><td class="er-num">'+f1(x.got)+'</td><td class="er-num '+gapCls+'">'+f1(x.gap)+'</td><td class="er-l">'+esc(room)+'</td></tr>';
    }).join('') : '<tr><td colspan="7" style="color:#a7b1c0;">부족분이 있는 지표가 없습니다.</td></tr>';
    // ※ 비고(원본 문구 + 실제 수치) — 편집 저장본이 있으면 유지
    if(!savedKeys['pri_note'] && pri.length){
      var totGapAll = indicators.reduce(function(a,r){ return a + Math.max(0, n(r.stdweig)-n(r.weigval)); }, 0);
      var t2 = pri.slice(0,2), t2gap = t2.reduce(function(a,x){ return a+x.gap; }, 0);
      var pe = document.querySelector('#evalReport [data-key="pri_note"]');
      if(pe) pe.textContent = '※ 부족분 = 가중치(만점) − 현재 획득점수. 가중치가 큰 결과지표('+t2.map(function(x){return x.nm;}).join('·')+') '+t2.length+'개 항목만으로 전체 부족분 '+f1(totGapAll)+'점 중 '+f1(t2gap)+'점을 차지 → '+goalGradeVal()+' 달성의 핵심 지렛대입니다.';
    }
    renderTable2();
    renderSec3();
    renderSec4();
    renderSec5();
    captureAuto();   // 자동 생성 문구 스냅샷 — 저장 시 "실제 편집분"만 걸러내는 기준
  }

  // ===== 자동 문구 스냅샷(AUTO) — 렌더 직후의 기본값. 저장 시 이 값과 다른 것(=사용자 편집)만 DB 저장.
  //   (예전엔 자동 문구까지 통째로 저장돼, 다음 조회 때 옛 수치·옛 형식이 새 자동 문구를 덮는 문제가 있었음)
  var AUTO = {};
  function captureAuto(){
    AUTO = {};
    editables().forEach(function(e){ AUTO[e.getAttribute('data-key')] = e.innerHTML; });
  }

  // Ⅴ 권장 개선 시나리오(원본 PDF 형식) — 부족분 상위 4개 자동:
  //   최우선(상위 2)=+2구간, 나머지=+1구간(최대 5구간) 목표 → 상승분·개선 후 예상 종합점수·현재vs목표 비교표 자동 계산
  function renderSec5(){
    var top = topGaps(4), rows='', upStruct=0, upCare=0;
    top.forEach(function(x,i){
      var r=x.r, s=n(r.s_score)||1, tz=Math.min(5, s+(i<2?2:1));
      var tgt=Math.min(x.w, x.w/5*tz), up=Math.max(0, tgt-x.got);
      if(r.cate_fg==='10') upStruct+=up; else upCare+=up;
      rows += '<tr><td>'+(i+1)+(i<2?' <span style="font-size:10px;">핵심</span>':'')+'</td>'
            + '<td class="er-l">'+esc(x.nm)+'</td><td class="er-num">'+calDisp(r)+'</td><td>'+tz+'구간</td>'
            + '<td class="er-num">'+f1(x.got)+'</td><td class="er-num">'+f1(tgt)+'</td><td class="er-b-good er-num">+'+f1(up)+'</td></tr>';
    });
    el('er-roadBody').innerHTML = rows || '<tr><td colspan="7" style="color:#a7b1c0;">개선 대상 지표가 없습니다.</td></tr>';
    var totalUp = upStruct + upCare, after = scores.total + totalUp;
    var afterEl = document.querySelector('#evalReport [data-key="after_score"]');
    if(afterEl) afterEl.textContent = f1(after);
    el('er-afterGrade').textContent = '( +'+f1(totalUp)+' · '+gradeOf(after)+' )';
    el('er-cmpBody').innerHTML =
      '<tr><td class="er-l">구조영역 (30)</td><td class="er-num">'+f1(scores.struct)+'</td><td class="er-num'+(upStruct>0.0001?' er-b-good':'')+'">'+f1(scores.struct+upStruct)+'</td></tr>'
     +'<tr><td class="er-l">진료영역 (70)</td><td class="er-num">'+f1(scores.care)+'</td><td class="er-num'+(upCare>0.0001?' er-b-good':'')+'">'+f1(scores.care+upCare)+'</td></tr>'
     +'<tr class="er-tot"><td class="er-l">종합 (100)</td><td class="er-num">'+f1(scores.total)+'</td><td class="er-b-good er-num">'+f1(after)+'</td></tr>'
     +'<tr class="er-sub"><td class="er-l">등급</td><td class="er-b-bad">'+gradeOf(scores.total)+'</td><td class="'+(parseInt(gradeOf(after),10)<parseInt(gradeOf(scores.total),10)?'er-b-good':'')+'">'+gradeOf(after)+'</td></tr>';
  }

  // 저장된 편집 문구 키 — 자동 문구(핵심진단·비고 등)는 override 가 없을 때만 채움
  var savedKeys = {};

  // 목표점수/목표등급 의존 요약(부족 카드 + 가로 등급표 + 핵심진단 자동문구) — 목표값(DOM) 갱신 후 재호출
  function renderGoalSummary(){
    var goalScore = goalScoreVal(), goalGrade = goalGradeVal();
    el('er-gapGoalScore').textContent = goalScore;
    el('er-gapGoalGrade').textContent = goalGrade;
    var gap = Math.round((goalScore - scores.total)*10)/10;
    el('er-gapScore').textContent = (gap>0?'+':'') + gap;
    var bands=[['1등급','88 ~ 100'],['2등급','79 ~ 87'],['3등급','71 ~ 78'],['4등급','63 ~ 70'],['5등급','63 미만']];
    var cur=gradeOf(scores.total);
    // 가로형(원본 PDF): 헤더=등급, 행1=표준화 점수구간(목표 셀 강조), 행2=병원 현황(현재 등급 칸에 점수)
    el('er-gradeHead').innerHTML = '<tr><th class="er-l">등급</th>'+bands.map(function(b){
      var tag = b[0]===goalGrade?' (목표)':(b[0]===cur?' (현재)':'');
      return '<th>'+b[0]+tag+'</th>';
    }).join('')+'</tr>';
    el('er-gradeBody').innerHTML =
      '<tr><td class="er-l"><b>표준화 점수구간</b></td>'+bands.map(function(b){
        return '<td class="er-num'+(b[0]===goalGrade?' er-goalcell':'')+'">'+b[1]+'</td>';
      }).join('')+'</tr>'
     +'<tr><td class="er-l"><b>'+esc(hospNm||'병원')+' 현황</b></td>'+bands.map(function(b){
        return '<td class="er-num'+(b[0]===cur?' er-curval':'')+'">'+(b[0]===cur? f1(scores.total)+'점' : '')+'</td>';
      }).join('')+'</tr>';
    // 핵심 진단 — 원본 문구에 실제 수치 자동 채움 (편집 저장본이 있으면 유지)
    var curRange = (bands.filter(function(b){ return b[0]===cur; })[0]||['',''])[1];
    if(!savedKeys['diag_core']){
      var e1=document.querySelector('#evalReport [data-key="diag_core"]');
      if(e1){
        e1.innerHTML = (gap>0)
          ? '현재 종합점수 <b class="er-num">'+f1(scores.total)+'점</b>은 <b>'+cur+' 구간('+curRange+')</b>에 해당합니다. 안정적인 <b>'+esc(goalGrade)+' 달성·유지</b>를 위해서는 구간 상단인 <b>'+goalScore+'점</b>을 목표로 하며, 이는 현재 대비 <b class="er-b-bad">+'+gap+'점</b> 향상이 필요합니다.'
          : '현재 종합점수 <b class="er-num">'+f1(scores.total)+'점</b>으로 목표('+esc(goalGrade)+'·'+goalScore+'점) 수준을 충족하고 있습니다. 유지 관리와 상위 등급 도약 여지를 점검하세요.';
        AUTO['diag_core'] = e1.innerHTML;
      }
    }
    if(!savedKeys['diag_note']){
      var e2=document.querySelector('#evalReport [data-key="diag_note"]');
      if(e2){
        e2.textContent = '※ 기존 표준(1등급·88점)을 목표로 하면 부족분이 +'+f1(88-scores.total)+'점으로 과대 산정됩니다. 본 보고서는 병원 여건을 고려한 단계적 목표('+goalGrade+') 기준으로 부족분과 개선 로드맵을 재산정했습니다.';
        AUTO['diag_note'] = e2.innerHTML;
      }
    }
    renderSummary();   // 총평 5문단(sum_p1~p5) 자동 초안 — 목표값 확정 후 생성
  }

  // ===== 총평 자동 초안 (과거 월간보고서 총평 대응 — docs/reports/월간보고서_총평_작성가이드.md §3·§7) =====
  //   문체 확정(2026-07-15 사용자): 구어체("~합니다"), 수치는 핵심(총점·등급·부족분·상승폭)만 간단히.
  //   병원별 편집 저장분(savedKeys)이 있으면 해당 문단은 건드리지 않음. TPL(sum_p1~p5, USE_YN='Y')이
  //   있으면 applyTpls 가 이 초안을 덮음 — 기본 시드는 USE_YN='N'(자동 초안 우선).
  // ===== 개선 시뮬레이션 (담당자 수기 간판 문형) — "N명 추가 개선 시 %→표준화±1→가중치→종합 +Δ" =====
  //   근거: docs/reports/담당자_수기_세밀분석 §2. 화면값(s_score·dtorval·ntorval·stdweig·CRIT_ALL)만으로 조립.
  var IS_LOWER = {'01':1,'02':1,'03':1,'05':1,'07':1,'10':1,'14':1};   // 값이 낮을수록 우수(assessment LOWER_IS_BETTER)
  function simStep(r){
    var cd=r.cate_cd, w=n(r.stdweig), got=n(r.weigval), s=n(r.s_score)||0, dtor=n(r.dtorval), ntor=n(r.ntorval);
    if(!(s>0 && s<5)) return null;                       // 미산정·이미 5점이면 시나리오 없음
    var band=null; (CRIT_ALL[cd]||[]).forEach(function(z){ if(z.s===s+1) band=z; });
    if(!band) return null;
    var dW=w/5, d={ nz:s+1, dW:dW, got:got, newGot:got+dW };
    // 인원 환산은 '결과지표(높을수록 우수)·환자수 분모'만 — 담당자 수기가 명단위 시뮬레이션을 쓰는 범위.
    //   낮을수록 우수(장기입원·유치도뇨관 등)는 '분모 제외/제거기록' 등 다른 서술이라 명-감소 문장 생략(일반 +Δ절만).
    if(UNIT_PERSON.indexOf(cd)<0 && NOT_HEADCOUNT.indexOf(cd)<0 && dtor>0 && !IS_LOWER[cd]){
      var reqN=Math.ceil(band.start*dtor/100), need=reqN-ntor;
      if(need>0){ d.need=need; d.dir='개선'; d.newPct=fnum(Math.round(reqN/dtor*1000)/10); }
    }
    return d;
  }
  // 목표 표준화 tz 도달에 필요한 추가 개선 명수·도달선(%) — 결과지표(높을수록 우수)·환자수 분모만.
  //   담당자 2단계 나열형("4점 = 3명 추가(총 9명, 47.37%), 5점 = 6명 추가(총 12명, 63.16%)") 재현용.
  function simNeed(r, tz){
    var cd=r.cate_cd, dtor=n(r.dtorval), ntor=n(r.ntorval);
    if(UNIT_PERSON.indexOf(cd)>=0 || NOT_HEADCOUNT.indexOf(cd)>=0 || !(dtor>0) || IS_LOWER[cd]) return null;
    var band=null; (CRIT_ALL[cd]||[]).forEach(function(z){ if(z.s===tz) band=z; });
    if(!band) return null;
    var reqN=Math.ceil(band.start*dtor/100), need=reqN-ntor;
    if(need<=0) return null;
    return { need:need, total:reqN, pct:fnum(Math.round(reqN/dtor*10000)/100) };   // 담당자 표기처럼 소수 2자리(47.37%)
  }

  // 총평·권고 삽입용 완결절(경어체, 앞에 지표명·문맥을 붙여 사용)
  function simTail(r){
    var d=simStep(r); if(!d) return null;
    if(d.need) return d.need+'명 추가 '+d.dir+' 시 '+d.newPct+'%로 표준화 '+d.nz+'점·가중치 '+f1(d.newGot)+'점으로 종합점수가 약 +'+f1(d.dW)+'점 상승할 수 있습니다';
    return '표준화 '+d.nz+'점 진입 시 가중치 '+f1(d.newGot)+'점으로 종합점수가 약 +'+f1(d.dW)+'점 상승할 수 있습니다';
  }

  // [★1] '여유 한도 / 하락 경고' 문형 — 낮을수록 우수 %지표(유치도뇨관05·신규욕창10·장기입원14).
  //   simNeed(높을수록 우수, '개선 명수')의 대칭. 담당자 수기 근거(세밀분석 §6-2):
  //   · 제주대림 유치도뇨관 "0.5% 미만(5점) 유지 = 최대 2명 허용, 이미 5명으로 초과"  → (A) 최우수 미달·초과형
  //   · 여수시립 신규욕창   "1명 추가 발생 시 누적 0.31%로 4점 하락"                    → (B) 현재 구간 하락 경고형
  //   화면값(dtorval·ntorval·CRIT_ALL[end]=구간 상한·stdweig)만으로 조립. PI(07)·1인당(01~03)·재직/DUR(04·08)은 제외.
  function simRoomLower(r){
    var cd=r.cate_cd, dtor=n(r.dtorval), ntor=n(r.ntorval), s=n(r.s_score)||0, w=n(r.stdweig);
    if(!IS_LOWER[cd] || UNIT_PERSON.indexOf(cd)>=0 || NOT_HEADCOUNT.indexOf(cd)>=0 || cd==='07' || !(dtor>0) || !(s>=1)) return null;
    var u=unitOf(cd), bandS=null, band5=null;
    (CRIT_ALL[cd]||[]).forEach(function(z){ if(z.s===s) bandS=z; if(z.s===5) band5=z; });
    // (A) 최우수(5점) 미달 — '이미 초과' 형
    if(s<5 && band5){
      var max5=Math.floor(band5.end*dtor/100);
      if(ntor>max5)
        return '누적 분모 '+esc(fnum(dtor))+'명 기준 표준화 5점('+fnum(band5.end)+u+' 미만)에는 '+max5+'명 이하가 요구되나 현재 '+esc(fnum(ntor))+'명으로 초과되어 '+s+'점에 해당하므로, 해당 건의 기록·해제(제거) 관리 강화가 필요합니다';
    }
    // (B) 현재 구간 하락 경고 — 여유 한도형
    if(s>=2 && bandS){
      var maxStay=Math.floor(bandS.end*dtor/100), room=maxStay-ntor, loss=f1(w/5);
      if(room<=0)
        return '현황 '+calDisp(r)+'로 표준화 '+s+'점 구간 상한('+fnum(bandS.end)+u+')에 도달해 있어, 1건만 추가로 발생해도 표준화 '+(s-1)+'점(가중치 −'+loss+'점)으로 하락할 수 있습니다';
      var nextPct=fnum(Math.round((maxStay+1)/dtor*10000)/100);
      return '누적 분모 '+esc(fnum(dtor))+'명 기준 '+maxStay+'명까지 표준화 '+s+'점 유지가 가능하나(현재 '+esc(fnum(ntor))+'명, 여유 '+room+'명), '+(room+1)+'건째 발생 시 '+nextPct+'%로 표준화 '+(s-1)+'점(가중치 −'+loss+'점) 하락할 수 있습니다';
    }
    return null;
  }

  // P3 삽입용 — 낮을수록 우수 지표 중 하락 리스크가 가장 큰(여유 명수 최소) 1개를 골라 경고절 생성
  function roomRiskTxt(){
    var best=null;
    indicators.forEach(function(r){
      var t=simRoomLower(r); if(!t) return;
      var cd=r.cate_cd, dtor=n(r.dtorval), ntor=n(r.ntorval), s=n(r.s_score)||0, bandS=null;
      (CRIT_ALL[cd]||[]).forEach(function(z){ if(z.s===s) bandS=z; });
      var room = bandS ? (Math.floor(bandS.end*dtor/100)-ntor) : 999;
      if(room<0) room=0;
      if(!best || room<best.room) best={ room:room, nm:r.cate_nm, txt:t };
    });
    return best ? (' 아울러 \''+best.nm+'\'은(는) '+best.txt+'.') : '';
  }

  // [C4] 복수지표 합산 상승 + 도달 절대점수 + 등급 결론 (세밀분석 §8-1, 4병원 수렴).
  //   부족분 상위 2지표를 각각 한 단계씩 개선 시 얻는 +Δ점을 합산 → 도달점수·등급. 현재 누적값만으로 조립.
  function sumTopSimTxt(){
    var ts = topGaps(2).filter(function(x){ var d=simStep(x.r); return d && d.dW>0; });
    if(ts.length<2) return '';
    var sum=0, nms=[];
    ts.forEach(function(x){ sum += simStep(x.r).dW; nms.push('\''+x.nm+'\''); });
    var neo = Math.round((scores.total+sum)*10)/10;
    return ' '+nms.join('과(와) ')+'을(를) 함께 한 단계씩 개선할 경우 종합점수는 약 +'+f1(sum)+'점 상승하여 '+f1(neo)+'점('+gradeOf(neo)+') 수준까지 도달할 수 있습니다.';
  }

  // [C9] %p 부족형 — 다음 구간 진입까지 남은 격차를 %p로 (세밀분석 §8-1). 높을수록 우수 %지표(s<5)만.
  function pctShortTxt(r){
    var cd=r.cate_cd, s=n(r.s_score)||0, val=n(r.cal_val);
    if(UNIT_PERSON.indexOf(cd)>=0 || NOT_HEADCOUNT.indexOf(cd)>=0 || IS_LOWER[cd] || cd==='07' || !(s>=1 && s<5)) return null;
    var band=null; (CRIT_ALL[cd]||[]).forEach(function(z){ if(z.s===s+1) band=z; });
    if(!band) return null;
    var gap=Math.round((band.start - val)*100)/100;
    if(gap<=0) return null;
    return '표준화 '+(s+1)+'점 기준('+fnum(band.start)+'%) 대비 약 '+fnum(gap)+'%p 부족';
  }

  // [★4] 전 구간 나열형 — 낮을수록 우수 & '감소가 실제 조치'인 지표(장기입원14·유치도뇨관05)만.
  //   담당자 수기(세밀분석 §6-2, 여수시립 장기입원): 현재보다 우수한 각 구간 도달에 필요한 감소 명수 전부 나열.
  //   신규욕창(10)은 되돌릴 수 없어 제외(하락 경고 simRoomLower로 처리), PI(07)·1인당(01~03)·재직/DUR 제외.
  function simReduceList(r){
    var cd=r.cate_cd, dtor=n(r.dtorval), ntor=n(r.ntorval), s=n(r.s_score)||0;
    if(['05','14'].indexOf(cd)<0 || !(dtor>0) || !(s>=1 && s<5)) return null;
    var u=unitOf(cd), parts=[];
    (CRIT_ALL[cd]||[]).forEach(function(z){
      if(z.s<=s) return;                                  // 현재보다 우수(상위)한 구간만
      var reqN=Math.floor(z.end*dtor/100), cut=ntor-reqN;
      if(cut>0) parts.push('표준화 '+z.s+'점('+fnum(z.end)+u+' 미만) = '+cut+'명 감소');
    });
    return parts.length ? parts.join(' · ') : null;
  }

  // 값→구간(높을수록 우수): 현황값 이상을 만족하는 최고 표준화 구간
  function zoneOfValHigher(cd, val){
    var a=CRIT_ALL[cd]; if(!a) return null;
    var best=null;
    a.forEach(function(z){ if(val>=z.start-1e-9){ if(best==null || z.s>best) best=z.s; } });
    return best;
  }

  // [★6] 배뇨관리(06) '보완형' — 오류점검(assesCheck flag 07)의 '일지 작성했으나 프로그램 미체크(분자제외 우려)' N건을
  //   보완 시 분자 재산정·구간 상향을 조건부(추정)로 안내. 담당자 수기(서울대림·인천사랑 배뇨 보완형)와 동형.
  //   ※ 실제 분자/점수(시스템 값)는 불변 — 문장은 '확인 요망' 조건부 추정. 편집영역(plan_06)에 들어가 수기 수정/덮어쓰기 가능.
  function bladderGapTxt(r){
    if(r.cate_cd!=='06' || !(_bladderGapN>0)) return null;
    var dtor=n(r.dtorval), ntor=n(r.ntorval), s=n(r.s_score)||0;
    if(!(dtor>0)) return null;
    var newN=ntor+_bladderGapN, newPct=Math.round(newN/dtor*10000)/100, nz=zoneOfValHigher('06', newPct);   // 담당자 표기와 동일 소수 2자리(92.75%)
    var tail=(nz!=null && nz>s) ? ('표준화 '+nz+'점으로 상향이 기대됩니다') : '분자 반영률이 개선됩니다';
    return '배뇨일지는 작성되었으나 배뇨(훈련)프로그램 계획 항목 미체크로 분자에서 누락될 우려가 있는 '+_bladderGapN+'건을 평가표에서 보완할 경우, 분자 '+newN+'명('+fnum(newPct)+'%)으로 재산정되어 '+tail+'(오류점검 결과 기준·대상자 적정성 확인 요망)';
  }

  // P2 구조영역 커트라인 경고 — 현황값이 현재 표준화 구간 경계에 근접한 구조지표(하위 구간 하락 리스크)를
  //   1개 골라(경계 비율 최소) 담당자 문형으로: "30명 초과 시 표준화 3점(가중치 −1.7점) 하락" (가이드 §3-P2)
  function structRiskTxt(){
    var best=null;
    indicators.forEach(function(r){
      if(r.cate_fg!=='10') return;
      var cd=r.cate_cd, s=n(r.s_score)||0, w=n(r.stdweig), val=n(r.cal_val);
      if(s<=1) return;
      var band=null; (CRIT_ALL[cd]||[]).forEach(function(z){ if(z.s===s) band=z; });
      if(!band || band.end===band.start) return;   // 단일값 구간(약사 100%=5점 등)은 상시 경계라 경고 제외
      var width=Math.abs(band.end-band.start)||1;
      var margin=(cd==='04') ? (val-band.start) : (band.end-val);   // 04(높을수록 우수)만 하한, 1인당 지표는 상한이 리스크
      if(margin<0) margin=0;
      var th=(UNIT_PERSON.indexOf(cd)>=0) ? 1 : 3;   // 절대 기준: 1인당 지표 1명 / % 지표 3%p 이내 (담당자 사례 29.13 vs 30명)
      if(margin<=th){
        var cand={ nm:r.cate_nm, val:val, s:s, band:band, loss:w/5, cd:cd, ratio:margin/width };
        if(!best || cand.ratio<best.ratio) best=cand;
      }
    });
    if(!best) return '';
    var u=unitOf(best.cd);
    var edge=(best.cd==='04') ? fnum(best.band.start)+u+' 미만' : fnum(best.band.end)+u+' 초과';
    var uJosa=(u==='명') ? '으로' : '로';
    return ' 다만 \''+best.nm+'\'가 현황 '+fnum(best.val)+u+uJosa+' 표준화 '+best.s+'점 구간('+fnum(best.band.start)+'~'+fnum(best.band.end)+u+') 경계에 근접해 있어, '
         + edge+' 시 표준화 '+(best.s-1)+'점(가중치 −'+f1(best.loss)+'점)으로 하락할 수 있으므로 재원환자 수 추이에 맞춘 인력 관리가 필요합니다.';
  }

  // [★5] P2 구조영역 차등제 분기 표기 — curYm 에서 분기 계산(하드코딩 없이 연도 자동 대응).
  //   가이드 §3-P2·§8: 예상=당분기 신고, 실반영=다음 2개 분기(연도 wrap).
  //   2026년 7월(Q3) → "2026년 3분기 예상, 실반영 2026년 4분기·2027년 1분기"(가이드 line 142와 일치).
  //   연말(10~12월)은 확정 국면이라 예상 분기문 생략 → 일반 확정문 사용.
  function structQuarterTxt(){
    if(!curYm || curYm.length<6) return '';
    var y=parseInt(curYm.substring(0,4),10), mo=parseInt(curYm.substring(4,6),10);
    if(!(mo>=1 && mo<=9)) return '';
    var q=Math.ceil(mo/3);
    var q1=q+1, y1=y; if(q1>4){ q1-=4; y1+=1; }
    var q2=q+2, y2=y; if(q2>4){ q2-=4; y2+=1; }
    return ' 구조영역 점수는 '+y+'년 '+q+'분기 차등제 신고내역으로 예상 산정되며, 실제 반영은 '+y1+'년 '+q1+'분기·'+y2+'년 '+q2+'분기 신고 결과로 확정됩니다.';
  }

  function renderSummary(){
    if(!indicators.length) return;
    var gs=goalScoreVal(), gg=goalGradeVal(), gap=Math.round((gs-scores.total)*10)/10;
    var ymTxt = curYm? curYm.substring(0,4)+'년 '+parseInt(curYm.substring(4,6),10)+'월' : '이번 달';
    var fulls = indicators.filter(function(r){ return n(r.stdweig)>0 && (n(r.stdweig)-n(r.weigval))<=0.0001; })
                          .map(function(r){ return r.cate_nm; });
    var tops = topGaps(2);
    var p = {};
    // P1 국면 분기 — 선언 + 전월대비(상승/하락/유지) + 상위등급 격차(경계 국면) + 목표 문장
    //   (담당자 문형: "전월대비 종합점수 4.56점 상승이 되었으며, 3등급과 점수차이는 0.14점")
    var curG = gradeOf(scores.total);
    // [C1] 당월/누적 이원 — 선언을 이원형으로 '병합'(누적 중복 진술 제거 → P1 분량 절감). 시스템 SP monthVal.
    var moNum2 = parseInt(curYm.substring(4,6),10);
    var mVal = _dashInd ? n(_dashInd.monthVal) : 0;
    var mG = mVal>0 ? gradeOf(mVal) : '';
    if(mVal>0 && mG!==curG)
      p.sum_p1 = moNum2+'월 당월 단독 예상점수는 '+f1(mVal)+'점('+mG+')이나, 실제 평가에 반영되는 7~'+moNum2+'월 누적 예상 종합점수는 '+f1(scores.total)+'점으로 '+curG+'에 해당합니다.';
    else
      p.sum_p1 = ymTxt+' 예상 종합점수는 '+f1(scores.total)+'점으로 '+curG+'에 해당합니다.';
    if(prevTotal!=null){
      var pd = Math.round((scores.total-prevTotal)*100)/100;
      if(Math.abs(pd)>=0.05)
        p.sum_p1 += ' 전월('+fnum(prevTotal)+'점) 대비 종합점수가 '+fnum(Math.abs(pd))+'점 '+(pd>0?'상승하였습니다.':'하락하여 원인 지표의 재확인이 필요합니다.');
      else
        p.sum_p1 += ' 전월과 동일한 수준을 유지하고 있습니다.';
    }
    var UPCUT = { '2등급':88, '3등급':79, '4등급':71, '5등급':63 };   // 현재등급 → 상위등급 커트라인(gradeOf 기준)
    if(UPCUT[curG]!=null){
      var upGap = Math.round((UPCUT[curG]-scores.total)*100)/100;
      if(upGap>0 && upGap<=5)
        p.sum_p1 += ' 상위등급('+(parseInt(curG,10)-1)+'등급, '+UPCUT[curG]+'점)과의 점수 차이는 '+fnum(upGap)+'점입니다.';
    }
    p.sum_p1 += ' ' + (gap>0 ? '목표인 '+gg+'('+fnum(gs)+'점)까지는 '+f1(gap)+'점이 더 필요한 상황입니다.'
                             : '목표인 '+gg+'('+fnum(gs)+'점)을 달성한 수준으로, 남은 기간 동안 유지 관리가 중요합니다.');
    // [C2] 월별 종합점수 시계열 — 3개월 이상일 때만(초기월 과밀 방지). 시스템 SP month_07~당월.
    if(_dashInd){
      var ser=[];
      for(var mm=7; mm<=moNum2; mm++){ var mv=n(_dashInd['month_'+('0'+mm).slice(-2)]); if(mv>0) ser.push(mm+'월 '+f1(mv)+'점'); }
      if(ser.length>=3) p.sum_p1 += ' (월별 예상점수 추이 — '+ser.join(', ')+')';
    }
    var sq = structQuarterTxt();   // [★5] 2026 등 차등제 분기 예상/실반영 표기(연말은 '')
    p.sum_p2 = '구조영역은 '+f1(scores.struct)+'점입니다.'
             + structRiskTxt()
             + (sq || ' 실제 점수는 차등제 신고 결과가 합산되어 확정됩니다.')
             + ' 재원환자 수와 인력 추이가 변동되지 않도록 꾸준히 관리해 주시기 바랍니다.';
    p.sum_p3 = '';
    if(fulls.length) p.sum_p3 += '진료영역에서는 '+fulls.slice(0,4).join(', ')+(fulls.length>4?' 등':'')+' 지표가 잘 관리되고 있습니다. ';
    if(tops.length){
      var t=tops[0], s1=simTail(t.r);
      p.sum_p3 += '반면 \''+t.nm+'\'은(는) 개선 여지가 가장 큰 지표로, '
                + (s1 ? s1+'. ' : '표준화 구간을 한 단계 올릴 때마다 약 +'+f1(t.w/5)+'점을 확보할 수 있습니다. ');
      if(tops[1]){
        var s2=simTail(tops[1].r);
        p.sum_p3 += '\''+tops[1].nm+'\'도 '+(s2 ? s2+'.' : '함께 관리해 주시기 바랍니다.');
      }
    }
    if(!p.sum_p3) p.sum_p3 = '진료영역 지표는 전반적으로 안정적으로 관리되고 있습니다.';
    p.sum_p3 += roomRiskTxt();   // [★1] 낮을수록 우수 지표 하락 경고(여유 한도형) 병기
    p.sum_p3 += sumTopSimTxt();  // [C4] 상위 2지표 동시개선 시 도달점수·등급 결론
    // [C11] 연말(12월) 확정 국면 — 잔여 개선 여지 무관하게 점수 확정(세밀분석 §8, 3병원 수렴)
    if(curYm && parseInt(curYm.substring(4,6),10)===12)
      p.sum_p3 += ' 다만 평가가 12월 진료분까지로 종료되는 시점이므로, 남은 개선 여지와 무관하게 현재 점수 수준에서 확정되는 국면임을 감안해 주시기 바랍니다.';
    p.sum_p4 = '항정신성의약품 처방률, DUR 점검률, 지역사회복귀율은 예상값 기준으로 산출되어 최종 평가 결과에 따라 점수가 다소 달라질 수 있습니다. 해당 대상자 관리를 꾸준히 부탁드립니다.';
    // [★2] P5 신뢰도 — 연말(10~12월)은 익년 2~3월 신뢰도 점검 대비형, 그 외는 상시형 (담당자 강남수 12월 vs 평시)
    var moNum = curYm ? parseInt(curYm.substring(4,6),10) : 0;
    if(moNum>=10)
      p.sum_p5 = '신뢰도 점검 결과는 적정성평가에 그대로 반영되므로, 다음 연도 2~3월로 예정된 신뢰도 점검에 대비하여 의무기록과 환자평가표의 불일치 사항을 미리 점검·수정해 주시기 바랍니다.';
    else
      p.sum_p5 = '신뢰도 점검 결과는 적정성평가에 그대로 반영되므로, 의무기록과 환자평가표가 서로 일치하는지 평소에 함께 점검해 주시기 바랍니다.';
    Object.keys(p).forEach(function(k){
      if(savedKeys[k]) return;   // 병원별 편집 저장분 우선
      var e=document.querySelector('#evalReport [data-key="'+k+'"]');
      if(e){ e.textContent = p[k]; AUTO[k] = e.innerHTML; }
    });
  }

  function topGaps(limit){
    return indicators.map(function(r){ return { cd:r.cate_cd, nm:r.cate_nm, fg:r.cate_fg, w:n(r.stdweig), got:n(r.weigval), gap:n(r.stdweig)-n(r.weigval), r:r }; })
                     .filter(function(x){ return x.gap>0.0001; }).sort(function(a,b){ return b.gap-a.gap; }).slice(0, limit||99);
  }

  // Ⅲ 지표별 분석 내용 — 지표별 자동 분석문 + 편집 개선방향(저장 문구 override 는 loadSavedTexts 가 재적용)
  function renderSec3(){
    var order=['10','21','22'], html='';
    order.forEach(function(fg){
      var rows=indicators.filter(function(r){ return r.cate_fg===fg; });
      if(!rows.length) return;
      html += '<div class="er-grplabel er-g'+fg+'">'+grpNm(fg)+'</div>';
      var topCds = topGaps(2).map(function(x){ return x.cd; });   // 최우선(부족분 상위2) — 원본 "◀ 최우선 개선" 표기
      rows.forEach(function(r){
        var w=n(r.stdweig), got=n(r.weigval), gap=w-got, cd=esc(r.cate_cd), s=n(r.s_score)||0;
        var full = gap<=0.0001;
        // 원본 PDF 형식: * 산정문(미달 빨강 강조) / "지표 정의 :" 별도 회색 줄 (+만점 시 유지 문구)
        var auto = autoAna(r, full);
        var defTxt = (TPL_DEF[r.cate_cd] ? esc(TPL_DEF[r.cate_cd]) : '')
                   + (full ? ' 현재 최고 구간으로 추가 개선 여지 없음(유지).' : '');
        // ▷ 개선 방향 : 원본식 "다음구간(+점수)·5구간(+점수)" 자동 + 표준 조치문구 + 필요 인원
        var ups = [];
        if(s>0 && s<5){
          var nz=s+1, rz=zoneRange(r.cate_cd,nz);
          if(rz) ups.push(rz+'('+nz+'구간, +'+f1(w/5)+'점)');
          if(nz<5){ var r5=zoneRange(r.cate_cd,5); if(r5) ups.push(r5+'(5구간, +'+f1(w/5*(5-s))+'점)'); }
        }
        var need='', fz=String(r.fiveZone||'').trim();
        if (fz.charAt(0)==='+') need=' 5점 도달까지 '+esc(fz.substring(1))+' 추가 필요.';
        else if (fz.charAt(0)==='-') need=' 5점 도달까지 '+esc(fz.substring(1))+' 감소 필요.';
        var planTxt = (ups.length? ups.join('·')+'. ' : '') + (TPL_DIR[r.cate_cd]? esc(TPL_DIR[r.cate_cd]) : '') + need;
        var bg = bladderGapTxt(r);   // [★6] 배뇨관리(06) 오류점검 연계 보완문(있으면) — 편집영역이라 수기 수정 가능
        if(bg) planTxt += ' ' + esc(bg) + '.';
        if(!planTxt.trim()) planTxt = '기록·실시 절차를 점검하고 목표 구간을 설정하세요.';
        var topTag = (topCds.indexOf(r.cate_cd)>=0 && !full) ? ' <span style="color:var(--er-bad); font-weight:800; font-size:11.5px;">◀ 최우선 개선</span>' : '';
        html += '<div class="er-indhead">■ '+esc(r.cate_nm)+' <span class="er-indsc">'+f1(got)+' / '+fnum(w)+'점</span>'+topTag+'</div>'
              + '<div class="er-indbox'+(full?' er-full':'')+'">'
              +   '<div class="er-anabar">분석 내용</div>'
              +   '<div class="er-indbody">'
              +     '<p class="er-ana er-editable" data-key="ana_'+cd+'">* '+auto+'</p>'
              +     (defTxt? '<p class="er-def er-editable" data-key="def_'+cd+'">지표 정의 : '+defTxt+'</p>' : '')
              +     (full? '' : '<p class="er-plan er-editable" data-key="plan_'+cd+'"><span class="er-mk">▷ 개선 방향 :</span> '+planTxt+'</p>')
              +   '</div>'
              + '</div>';
      });
    });
    el('er-sec3Body').innerHTML = html;
  }

  // Ⅳ 우선 개선지표별 권고사항 — 부족분 상위 지표 자동 블록 + 편집영역
  function renderSec4(){
    var top = topGaps(6), html='';
    if(!top.length){ el('er-sec4Body').innerHTML = '<div class="er-fn">부족분이 있는 지표가 없습니다.</div>'; return; }
    var CIRC='①②③④⑤⑥⑦⑧⑨⑩';   // 원본 PDF 번호 표기
    top.forEach(function(x,i){
      var cd=esc(x.cd), isTop=(i<2), r=x.r;
      var dtor=n(r.dtorval), s=n(r.s_score)||1;
      // 현황 : 8.7% (46명 중 4명) → 1구간(0.6점)  — 원본 형식
      var stat = '<b class="er-num">'+calDisp(r)+'</b>'
               + (dtor>0? ' ('+esc(fnum(r.dtorval))+' 중 '+esc(fnum(r.ntorval))+')' : '')
               + ' → '+s+'구간(<span class="er-num">'+f1(x.got)+'점</span> / '+fnum(x.w)+'점)';
      var zones = zoneListText(x.cd);
      // 목표 : 한 구간 상승 시 +가중치/5점 (현재 → 목표)
      var step = x.w/5, nz = Math.min(5, s+1), tgt = Math.min(x.w, x.got+step);
      var sd = simStep(r);
      var goalTxt = (s>=5) ? '' : '목표 : '+(sd && sd.need ? esc(sd.need)+'명 '+sd.dir+' → '+esc(sd.newPct)+'%로 ' : '')+nz+'구간 진입 시 <b class="er-num">+'+f1(tgt-x.got)+'점</b> ('+f1(x.got)+' → '+f1(tgt)+')';
      // 5구간까지 2단계 병기(담당자 나열형) — 다음구간이 5구간이 아니면서 명수 환산이 가능한 결과지표만
      if(goalTxt && nz<5){
        var n5 = simNeed(r, 5);
        if(n5) goalTxt += ' · 5구간 = '+esc(n5.need)+'명 추가(총 '+esc(n5.total)+'명, '+esc(n5.pct)+'%) 시 <b class="er-num">+'+f1(x.w-x.got)+'점</b>';
      }
      var dirTxt = TPL_DIR[x.cd] ? esc(TPL_DIR[x.cd]) : '개선 방향과 목표 구간을 입력하세요.';
      var ladder = simReduceList(r);   // [★4] 장기입원·유치도뇨관: 구간별 감소 명수 나열(감소가 실질 조치)
      var roomTxt = ladder ? ('표준화 목표 : '+ladder) : simRoomLower(r);   // 없으면 [★1] 여유 한도/하락 경고
      var pctShort = pctShortTxt(r);   // [C9] 다음 구간까지 %p 부족
      html += '<div class="er-rec'+(isTop?' er-top':'')+'">'
            +   '<div class="er-rech">'+(CIRC[i]||(i+1))+' '+esc(x.nm)+' <span class="er-w">· 가중치 '+fnum(x.w)+' · 부족분 '+f1(x.gap)+(isTop?' · 최우선':'')+'</span></div>'
            +   '<div class="er-recrow"><span class="er-lb">현황</span>'+stat+'</div>'
            +   (zones? '<div class="er-recrow"><span class="er-lb">표준화 구간</span>'+zones+'</div>' : '')
            +   '<div class="er-recrow er-editable" data-key="recdir_'+cd+'"><span class="er-lb">개선방향</span>'+dirTxt+'</div>'
            +   (goalTxt? '<div class="er-recgoal">'+goalTxt+(pctShort? ' · '+pctShort : '')+'</div>' : (pctShort? '<div class="er-recgoal">'+pctShort+'.</div>' : ''))
            +   (roomTxt? '<div class="er-recgoal">'+roomTxt+'.</div>' : '')
            + '</div>';
    });
    el('er-sec4Body').innerHTML = html;
  }

  // 해당 표준화구간(s)의 범위 표기 — 원본 PDF: "(30~34명)" "(6명 미만)" "(3.5% 이상)" "(100%)" 형식
  function zoneRange(cd, s){
    var a = CRIT_ALL[cd]; if(!a) return '';
    var b = null; a.forEach(function(z){ if(z.s===s) b=z; });
    if(!b) return '';
    var u = unitOf(cd), st = b.start, en = b.end;
    var enR = (en % 1 >= 0.9) ? fnum(Math.round(en + 0.5)) : fnum(en);   // 5.99→6, 25.99→26
    if (st <= 0)                          return enR + u + ' 미만';
    if (en >= 999)                        return fnum(st) + u + ' 이상';
    if (u === '%' && st >= 100)           return '100%';
    if (u === '%' && en >= 100)           return fnum(st) + '% 이상';
    return fnum(st) + '~' + enR + u;
  }

  function renderTable2(){
    // 원본 PDF 형식(8컬럼): 영역(세로병합) | 지표명 | 가중치 | 현황값 | 표준화구간(2줄·색) | 획득점수 | 획득률 | 부족분
    var html='';
    function grpRows(fg, label, areaCls){
      var rows=indicators.filter(function(r){ return r.cate_fg===fg; });
      rows.forEach(function(r, idx){
        var w=n(r.stdweig), got=n(r.weigval), gap=w-got, rate=w>0?Math.round(got/w*100):0, s=n(r.s_score)||0;
        var zcls = s>=5?'er-z5':(s<=1?'er-z1':'er-z3');
        var range = s? zoneRange(r.cate_cd, s) : '';
        var zTd = s? '<td class="er-zc '+zcls+'"><b>'+s+'구간</b>'+(range?'<span class="er-zr">('+esc(range)+')</span>':'')+'</td>' : '<td>-</td>';
        // 부족분 강조(연분홍) = 진료지표(과정·결과) 중 부족분 2점 초과 — 원본 강조 패턴
        var hl = (fg!=='10' && gap>2.0001);
        var gapTd = gap>0.0001? '<td class="er-num'+(hl?' er-gaphl':' er-b-bad')+'">'+f1(gap)+'</td>' : '<td class="er-zero er-num">0</td>';
        var rateTd = rate>=100? '<td class="er-r100 er-num">100%</td>' : '<td class="er-num">'+rate+'%</td>';
        var cal = calDisp(r) + (r.cate_cd==='07' ? ' (PI)' : '');
        html += '<tr>'
              + (idx===0? '<td class="er-area '+areaCls+'" rowspan="'+rows.length+'">'+label+'</td>' : '')
              + '<td class="er-l">'+esc(r.cate_nm)+'</td><td class="er-num">'+fnum(w)+'</td><td class="er-num">'+cal+'</td>'
              + zTd + '<td class="er-num">'+f1(got)+'</td>'+rateTd+gapTd+'</tr>';
      });
      return rows;
    }
    function sums(fgs){
      var w=0,g=0;
      indicators.forEach(function(r){ if(fgs.indexOf(r.cate_fg)>=0){ w+=n(r.stdweig); g+=n(r.weigval); } });
      return { w:w, g:g, rate:(w>0?Math.round(g/w*1000)/10:0), gap:w-g };
    }
    grpRows('10','구조<br>지표','');
    var s10=sums(['10']);
    html += '<tr class="er-sub"><td colspan="2">구조영역 소계</td><td class="er-num">'+fnum(s10.w)+'</td><td></td><td></td><td class="er-num">'+f1(s10.g)+'</td><td class="er-num">'+s10.rate+'%</td><td class="er-b-bad er-num">'+f1(s10.gap)+'</td></tr>';
    grpRows('21','과정<br>지표','er-a21');
    grpRows('22','결과<br>지표','er-a22');
    var sMd=sums(['21','22']);
    html += '<tr class="er-sub"><td colspan="2">진료영역(과정+결과) 소계</td><td class="er-num">'+fnum(sMd.w)+'</td><td></td><td></td><td class="er-num">'+f1(sMd.g)+'</td><td class="er-num">'+sMd.rate+'%</td><td class="er-b-bad er-num">'+f1(sMd.gap)+'</td></tr>';
    var sT=sums(['10','21','22']);
    html += '<tr class="er-grand"><td colspan="2">종 합</td><td class="er-num">'+fnum(sT.w)+'</td><td></td><td></td><td class="er-num">'+f1(sT.g)+'</td><td class="er-num">'+sT.rate+'%</td><td class="er-num">'+f1(sT.gap)+'</td></tr>';
    el('er-tbl2Body').innerHTML = html;
  }

  // ===== 저장된 문구/상태 로드 =====
  // ===== 전사 표준문구(TBL_EVAL_REPORT_TPL) 적용 — 우선순위: 병원별 TEXT > TPL > JSP 내장 기본값 =====
  //   · def_XX / dir_XX : Ⅲ·Ⅳ의 지표 정의/개선방향 기본문구(TPL_DEF/TPL_DIR)를 DB값으로 교체 → 섹션 재렌더
  //     (renderSec3/4 가 esc() 처리하므로 DB에는 순수 텍스트로 저장 — HTML 태그 불가)
  //   · 그 외 키 : 화면 편집영역(data-key 일치)의 기본 문구로 주입. {total}{grade}{struct}{care}
  //     {goalGrade}{goalScore}{gap}{hosp}{ym} 자리표시자를 실제 수치로 치환.
  //     AUTO 스냅샷을 함께 갱신하므로 미수정 시 저장 안 됨(병원별 TEXT 로 오염 방지),
  //     savedKeys 마킹으로 자동 문구(renderGoalSummary 등)가 TPL 을 덮지 않음.
  //   · sum_p1~p5 등 화면에 없는 키는 무시(향후 자동 총평용 예비).
  function erFillTpl(s){
    var gs = goalScoreVal();
    return String(s)
      .replace(/\{total\}/g,  f1(scores.total))
      .replace(/\{grade\}/g,  gradeOf(scores.total))
      .replace(/\{struct\}/g, f1(scores.struct))
      .replace(/\{care\}/g,   f1(scores.care))
      .replace(/\{goalGrade\}/g, goalGradeVal())
      .replace(/\{goalScore\}/g, String(gs))
      .replace(/\{gap\}/g,    f1(Math.max(0, gs - scores.total)))
      .replace(/\{hosp\}/g,   esc(hospNm||''))
      .replace(/\{ym\}/g,     curYm? curYm.substring(0,4)+'년 '+curYm.substring(4,6)+'월' : '');
  }
  function applyTpls(tpls){
    if(!tpls || !tpls.length) return;
    var editableTpls=[], reRender=false;
    tpls.forEach(function(t){
      var k=String(t.sectkey||''), c=t.content;
      if(!k || c==null || String(c).trim()==='') return;
      var m=/^(def|dir)_(\d{2})$/.exec(k);
      if(m){
        if(m[1]==='def') TPL_DEF[m[2]]=String(c); else TPL_DIR[m[2]]=String(c);
        reRender=true;
      } else {
        editableTpls.push({ k:k, c:String(c) });
      }
    });
    if(reRender){ renderSec3(); renderSec4(); captureAuto(); }   // DB 문구 반영 후 스냅샷 재확정
    editableTpls.forEach(function(t){
      var e=document.querySelector('#evalReport .er-editable[data-key="'+t.k+'"]');
      if(e){ e.innerHTML=erFillTpl(t.c); AUTO[t.k]=e.innerHTML; savedKeys[t.k]=1; }
    });
  }

  function loadSavedTexts(){
    jQuery.ajax({ url: ctx+'/main/loadEvalReport.do', type:'POST', dataType:'json',
      data:{ hospCd:hospCd, evalYm:curYm },
      success:function(res){
        var mst = res && res.mst;
        var texts = (res && res.texts) || [];
        savedKeys={};
        // ① 목표값 먼저(차등제 마스터) — TPL 자리표시자({goalScore} 등)가 최신 목표를 쓰도록
        applyGoalDefault(res && res.goal);
        // ② 전사 표준문구(TBL_EVAL_REPORT_TPL) — DB 문구가 내장 기본값을 대체
        applyTpls((res && res.tpls) || []);
        // ③ 병원별 저장 문구 override 적용 (+ savedKeys 갱신 — 자동 문구가 저장본을 덮지 않게)
        var map={};
        texts.forEach(function(t){ map[t.sectkey]=t.content; savedKeys[t.sectkey]=1; });
        editables().forEach(function(e){ var k=e.getAttribute('data-key'); if(map[k]!=null) e.innerHTML=map[k]; });
        renderGoalSummary();   // 목표값 확정 후 부족점수/등급표 재계산
        _erSaved = !!mst;      // 저장 이력(MST 행) 존재 여부 → 신규/저장됨 구분
        _erDirty = false;      // 방금 로드 = 변경 없음
        setStatus(mst && mst.status ? mst.status : 'DRAFT');
        pdfPath = (mst && mst.pdfpath) ? String(mst.pdfpath) : '';
        updatePdfUi();
        editables().forEach(function(e){ e.contentEditable='false'; });
        editing=false; el('evalReport').classList.remove('er-editmode');
        if(isWinner){ var b=el('er-btnEdit'); b.textContent='✏️ 편집켜기'; b.classList.remove('er-on'); }
        erPaginate();   // 문구 확정(자동/저장 override 반영) 후 A4 분할
      },
      error:function(){ setStatus('DRAFT'); }
    });
  }

  function collectTexts(){
    // 자동 기본값(AUTO)과 다른 것만 저장 = 사용자가 실제로 편집한 문구만.
    // (자동 문구를 저장하지 않으므로 수치·양식이 바뀌어도 항상 최신 자동 문구가 렌더됨)
    var arr=[];
    editables().forEach(function(e){
      var k=e.getAttribute('data-key'), html=e.innerHTML;
      if(AUTO[k] !== undefined && html === AUTO[k]) return;   // 자동 기본 그대로 → 저장 제외
      arr.push({ sectKey:k, content:html });
    });
    return arr;
  }

  function doSave(onOk, onErr){
    var payload = { hospCd:hospCd, evalYm:curYm, title:(hospNm||'')+' 적정성평가 컨설팅 보고서',
      goalGrade:goalGradeVal(), goalScore:goalScoreVal(),
      structScore:Math.round(scores.struct*10)/10, careScore:Math.round(scores.care*10)/10, totalScore:Math.round(scores.total*10)/10,
      texts:collectTexts() };
    jQuery.ajax({ url: ctx+'/main/saveEvalReport.do', type:'POST', contentType:'application/json', dataType:'json',
      data: JSON.stringify(payload),
      success:function(res){ if(res && res.result==='OK'){ if(onOk) onOk(); } else { erSwal('error','저장 실패: '+((res&&res.message)||''), {title:'오류'}); if(onErr) onErr(); } },
      error:function(){ erSwal('error','저장 중 오류가 발생했습니다.', {title:'오류'}); if(onErr) onErr(); }
    });
  }

  window.erSave = function(){
    if(_erReadonly){ erSwal('info','읽기전용(이력 열람)입니다. 저장할 수 없습니다.'); return; }
    if(!curYm){ erSwal('warning','먼저 평가년월을 조회하세요.'); return; }
    erConfirm('수정한 내용을 저장하시겠습니까?', _erDoSave, { title:'저장', icon:'question', yes:'저장' });
  };
  function _erDoSave(){
    var b = el('er-btnSave');
    if(!b){ doSave(function(){ toast('저장되었습니다.'); }); return; }
    if(b._saving) return;                                   // 중복 클릭 방지
    b._saving = true; b._orig = b._orig || b.innerHTML;
    b.disabled = true; b.classList.remove('er-saved'); b.classList.add('er-saving'); b.innerHTML = '⏳ 저장 중…';
    function restore(){ b.innerHTML = b._orig; b.classList.remove('er-saving','er-saved'); b.disabled = false; b._saving = false; }
    doSave(
      function(){                                           // 완료 — 버튼 '저장완료' 표시 + 간단 토스트
        b.classList.remove('er-saving'); b.classList.add('er-saved'); b.innerHTML = '✅ 저장완료';
        _erSaved = true; _erDirty = false; updateBadge();   // 저장됨 → 뱃지 '저장됨'
        toast('저장되었습니다.');
        clearTimeout(b._rt); b._rt = setTimeout(restore, 1600);
      },
      function(){ restore(); }                              // 실패 → 원복(오류 다이얼로그는 doSave 가 표시)
    );
  }

  window.erApprove = function(){
    if(_erReadonly){ erSwal('info','읽기전용(이력 열람)입니다. 승인할 수 없습니다.'); return; }
    if(!curYm){ erSwal('warning','먼저 평가년월을 조회하세요.'); return; }
    if(approved){
      erConfirm('이 보고서의 승인을 취소하시겠습니까?\n취소하면 거래처 공개가 해제되고 다시 편집할 수 있습니다.',
        _erDoApproveCancel, { title:'승인 취소', icon:'warning', yes:'승인 취소', focusCancel:true });
      return;
    }
    erConfirm('이 보고서를 승인하시겠습니까?\n승인하면 현재 수치가 확정되고 거래처가 열람·인쇄할 수 있습니다.',
      _erDoApprove, { title:'승인', icon:'question', yes:'승인' });
  };
  function _erDoApproveCancel(){
    jQuery.ajax({ url: ctx+'/main/approveEvalReport.do', type:'POST', contentType:'application/json', dataType:'json',
      data: JSON.stringify({ hospCd:hospCd, evalYm:curYm, cancel:'Y' }),
      success:function(res){ if(res && res.result==='OK'){ setStatus('DRAFT'); toast('승인이 취소되었습니다.'); } else erSwal('error','처리 실패: '+((res&&res.message)||''), {title:'오류'}); },
      error:function(){ erSwal('error','승인 처리 중 오류가 발생했습니다.', {title:'오류'}); }
    });
  }
  function _erDoApprove(){
    // 승인: 최신 문구 저장 완료 후 → 승인(수치 스냅샷 동결)
    doSave(function(){
      _erSaved = true; _erDirty = false;   // 승인 전 저장 완료 반영(이후 승인취소 시 '저장됨')
      var snapshot = JSON.stringify({ scores:scores, indicators:indicators, evalYm:curYm });
      jQuery.ajax({ url: ctx+'/main/approveEvalReport.do', type:'POST', contentType:'application/json', dataType:'json',
        data: JSON.stringify({ hospCd:hospCd, evalYm:curYm, cancel:'N', snapshotJson:snapshot }),
        success:function(res){
          if(res && res.result==='OK'){
            setStatus('APPROVED');
            // 승인 완료 → 이제 완성본 PDF 첨부 유도([PDF 첨부] 누르면 바로 생성·첨부 흐름)
            erConfirm('승인되었습니다. 이제 완성본 PDF를 첨부하세요.', function(){ erPickPdf(); },
              { title:'승인 완료', icon:'success', yes:'PDF 첨부', no:'나중에' });
          }
          else erSwal('error','처리 실패: '+((res&&res.message)||''), {title:'오류'});
        },
        error:function(){ erSwal('error','승인 처리 중 오류가 발생했습니다.', {title:'오류'}); }
      });
    });
  }

  // ===== 첨부 PDF (아래한글 완성본 하이브리드) =====
  //  · 툴바: 첨부 전 = [📎 PDF 첨부] / 첨부 후 = [👁 PDF 보기] 하나만 (헷갈림 방지)
  //  · 교체·해제는 '보기' 모달 안에서 (위너넷만)
  function updatePdfUi(){
    var has = !!pdfPath;
    var dlUrl = has ? (ctx+'/sftp/download.do?filePath='+encodeURIComponent(pdfPath)) : '#';
    el('er-pdfView').style.display = has ? '' : 'none';                    // 첨부돼 있으면: 보기 버튼
    // 첨부 버튼 — 위너넷만. PDF첨부는 '승인 후'에만 활성(공개본=PDF 일치 보장). 승인 전엔 비활성+안내.
    //   첨부 전이면 '📎 PDF첨부', 이미 있으면 '📎 PDF 다시첨부' 로 라벨 전환.
    var bp=el('er-btnPdf');
    if(isWinner){
      bp.style.display='';
      bp.disabled = !approved;                                            // 승인해야 첨부 가능
      bp.title = approved ? '완성본 PDF를 생성·업로드합니다(거래처 우선 제공)'
                          : '먼저 ✔승인한 뒤 PDF를 첨부할 수 있습니다.';
      bp.textContent = has ? '📎 PDF 다시첨부' : '📎 PDF첨부';
    } else {
      bp.style.display='none';
    }
    // 모달 안 교체(검색) = 위너넷만 노출
    var mr=el('er-pdfModalReplace');
    if(mr) mr.style.display = isWinner ? '' : 'none';
    // 거래처: 첨부 PDF 우선 안내 배너
    var bn=el('er-pdfBanner');
    if(!isWinner && has){ bn.style.display=''; el('er-pdfBannerLink').href=dlUrl; }
    else bn.style.display='none';
  }

  window.erPickPdf = function(){
    if(_erReadonly){ erSwal('info','읽기전용(이력 열람)입니다. PDF첨부할 수 없습니다.'); return; }
    if(!curYm){ erSwal('warning','먼저 평가년월을 조회하세요.'); return; }
    if(!approved){ erSwal('warning','먼저 ✔승인한 뒤 PDF를 첨부할 수 있습니다.\n(승인해야 거래처 공개본과 PDF가 일치합니다)'); return; }
    // 화면 보고서를 PDF로 생성 → 미리보기 모달로 먼저 보여줌(저장 전). 저장은 모달의 [📄 파일서버 저장] 에서.
    erPdfGenPreview();
  };

  // 화면 보고서(.er-doc) → html2canvas 캡처 → jsPDF A4 PDF 생성 → '미리보기 모달'로 표시(아직 저장 안 함).
  //   적정성 출력(assessment.downloadPDF)과 동일 라이브러리(header.jsp 전역 로드). 화면 그대로 픽셀 재현. 저장은 erPdfGenUpload.
  var _erGenBlob = null, _erGenName = '';
  window.erPdfGenPreview = function(){
    if(!window.jspdf || typeof html2canvas==='undefined'){ erSwal('error','PDF 생성 라이브러리(jsPDF·html2canvas)를 불러오지 못했습니다.', {title:'오류'}); return; }
    var doc9 = document.querySelector('#evalReport .er-doc');
    if(!doc9){ erSwal('warning','보고서 내용이 없습니다. 먼저 조회하세요.'); return; }
    var pages = doc9.querySelectorAll('.er-page');
    if(!pages.length){ erSwal('warning','보고서 페이지가 없습니다.'); return; }
    if(editing) erToggleEdit();
    toast('PDF 생성 중… 잠시만 기다려 주세요.');
    var _root = el('evalReport');
    _root.classList.add('er-pdfcap');                     // 편집영역 파란 하이라이트 제거(캡처용)
    if(document.activeElement && document.activeElement.blur) document.activeElement.blur();   // 포커스 잔상 제거
    var prevZoom = _erZoom; _erZoom = 1; erApplyZoom();   // 배율 1(html2canvas 는 CSS zoom 미지원)
    function restore(){ _root.classList.remove('er-pdfcap'); _erZoom=prevZoom; erApplyZoom(); }
    // ★ 각 .er-page(표지·Ⅰ·Ⅱ·…)를 따로 캡처해 A4 한 장씩 배치 → 섹션 헤더·카드가 페이지 경계에서 잘리지 않음.
    //   페이지가 A4보다 높으면 A4에 맞춰 축소(내용 잘림 없이 전체 표시). scale 1.5 + JPEG 로 속도·용량 최적화.
    var jsPDF = window.jspdf.jsPDF, pdf = new jsPDF('p','mm','a4');
    var pw = pdf.internal.pageSize.getWidth(), ph = pdf.internal.pageSize.getHeight(), mg = 6;
    var iw = pw - mg*2, maxHmm = ph - mg*2, idx = 0;
    // 폴백용 — 캔버스에서 target 위쪽으로 '흰 여백 행'을 찾음(DOM 후보가 없을 때만 사용). 없으면 target.
    function _erWhiteCut(ctx, w, target, lo){
      for(var yy=target; yy>=lo; yy--){
        var row, white=true;
        try{ row = ctx.getImageData(0, yy, w, 1).data; }catch(e){ return target; }
        for(var x=0; x<w; x+=40){ var p=x*4; if(row[p]<245||row[p+1]<245||row[p+2]<245){ white=false; break; } }
        if(white) return yy;
      }
      return target;
    }
    // ★ 페이지 내 '끊어도 되는 지점' = 주요 블록의 시작(top). 지표 제목(.er-indhead)·그룹헤더 등에서만 끊어
    //   제목과 '분석 내용' 박스(.er-indbox)가 갈라지지 않게. sf = CSS px → 캔버스 px 배율.
    //   ★ 헤더(eyebrow/subh/grplabel/indhead) '바로 뒤(=헤더와 다음 블록 사이)'에서는 끊지 않음 →
    //     헤더 top 에서만 끊어 헤더가 뒤따르는 콘텐츠(표 등)와 함께 다음 페이지로 이동(섹션 제목 홀로 남김 방지).
    function _erBreakYs(pg, sf){
      var HEAD = ['er-eyebrow','er-subh','er-grplabel','er-indhead'];
      var sel = '.er-eyebrow, .er-subh, .er-cards, .er-tw, .er-callout, .er-grplabel, .er-indhead, .er-rec, .er-after, .er-fn, .er-docfoot, .er-ind';
      var pTop = pg.getBoundingClientRect().top, items=[], list=pg.querySelectorAll(sel);
      for(var i=0;i<list.length;i++){
        var e=list[i], t=(e.getBoundingClientRect().top - pTop)*sf, isH=false;
        for(var h=0;h<HEAD.length;h++){ if(e.classList.contains(HEAD[h])){ isH=true; break; } }
        items.push({ top:Math.round(t), head:isH });
      }
      items.sort(function(a,b){ return a.top-b.top; });
      var ys=[];
      for(var j=0;j<items.length;j++){
        if(items[j].top<=4) continue;
        if(j>0 && items[j-1].head) continue;   // 직전이 헤더면 이 지점(헤더 다음)에서는 못 끊음
        ys.push(items[j].top);
      }
      return ys;
    }
    function _erAddSlice(canvas, y0, y1){   // 캔버스 [y0,y1) 구간을 A4 한 장으로 추가(원본 폭, 자연 높이)
      var hpx = y1 - y0; if(hpx<=0) return;
      var pc = document.createElement('canvas'); pc.width=canvas.width; pc.height=hpx;
      pc.getContext('2d').drawImage(canvas, 0, y0, canvas.width, hpx, 0, 0, canvas.width, hpx);
      if(idx>0) pdf.addPage();
      pdf.addImage(pc.toDataURL('image/jpeg',0.8), 'JPEG', mg, mg, iw, hpx*iw/canvas.width);
      idx++;
    }
    var chain = Promise.resolve();
    pages.forEach(function(pg){
      chain = chain.then(function(){
        var breaks = _erBreakYs(pg, 1);   // 캡처 전 CSS px 기준(sf 는 canvas 확보 후 보정)
        return html2canvas(pg, { scale:1.3, backgroundColor:'#ffffff', useCORS:true, logging:false }).then(function(canvas){
          var mappedH = canvas.height * iw / canvas.width;   // 전체를 폭 iw 로 놨을 때 mm 높이
          if(mappedH <= maxHmm){                             // 한 장에 들어감 → 축소 없이 그대로
            if(idx>0) pdf.addPage();
            pdf.addImage(canvas.toDataURL('image/jpeg',0.8), 'JPEG', mg, mg, iw, mappedH); idx++;
            return;
          }
          // 길면 → A4 여러 장. DOM 블록 시작 위치에서만 끊음(제목+박스 안 갈라짐). 후보 없으면 여백 폴백.
          var sf = canvas.height / (pg.getBoundingClientRect().height || pg.offsetHeight);   // CSS px → canvas px
          var bys = breaks.map(function(v){ return Math.round(v*sf); });
          var ctx = canvas.getContext('2d'), maxHpx = Math.floor(maxHmm * canvas.width / iw), y = 0, minStep = Math.floor(maxHpx*0.25);
          while(y < canvas.height){
            var limit = y + maxHpx;
            if(limit >= canvas.height){ _erAddSlice(canvas, y, canvas.height); break; }
            var cut = -1;
            for(var i=0;i<bys.length;i++){ var b=bys[i]; if(b>y+minStep && b<=limit) cut=b; else if(b>limit) break; }
            if(cut<0) cut = _erWhiteCut(ctx, canvas.width, limit, Math.max(y+1, limit - Math.floor(maxHpx*0.4)));
            _erAddSlice(canvas, y, cut); y = cut;
          }
        });
      });
    });
    chain.then(function(){
      restore();
      var yy=curYm.substring(0,4), mm=curYm.substring(4,6), gg=(typeof goalGradeVal==='function')?goalGradeVal():'';
      _erGenName = (hospNm||'적정성평가').replace(/[\\/:*?"<>|]/g,'') + ' 적정성평가 보고서('+yy+'.'+mm+') 목표'+gg+'.pdf';
      _erGenBlob = pdf.output('blob');
      _erShowGenPreview();   // 저장 전 미리보기
    }).catch(function(e){ restore(); erSwal('error','PDF 생성 오류: '+((e&&e.message)||e), {title:'오류'}); });
  };

  function _erShowGenPreview(){
    _pdfSeq++;                                             // 진행 중 서버 fetch 무효화
    el('er-pdfModalTitle').textContent = '📄 저장 전 미리보기 — ' + _erGenName;
    var old=el('er-pdfFrame'), nf=old.cloneNode(false); nf.removeAttribute('src'); old.parentNode.replaceChild(nf, old);
    el('er-pdfLoading').style.display='none';
    if(_pdfObjUrl) URL.revokeObjectURL(_pdfObjUrl);
    _pdfObjUrl = URL.createObjectURL(_erGenBlob);
    el('er-pdfFrame').src = _pdfObjUrl;
    el('er-pdfGenSaveBtn').style.display=''; el('er-pdfPickBtn').style.display='';   // 저장/파일선택 노출
    el('er-pdfModalReplace').style.display='none';                                   // 교체검색 숨김
    el('er-pdfModal').style.display='flex';
  }

  // 미리보기에서 [파일서버 저장] → 생성해둔 PDF(_erGenBlob) 업로드(SFTP EVALRPT + PDF_PATH).
  window.erPdfGenUpload = function(){
    if(!_erGenBlob){ erSwal('warning','생성된 PDF가 없습니다. 다시 시도해 주세요.'); return; }
    erConfirm('파일서버에 저장하시겠습니까?', _erDoPdfGenUpload, { title:'PDF 저장', icon:'question', yes:'저장' });
  };
  function _erDoPdfGenUpload(){
    toast('파일서버에 저장 중…');
    var fd = new FormData();
    fd.append('pdfFile', _erGenBlob, _erGenName); fd.append('hospCd', hospCd); fd.append('evalYm', curYm);
    jQuery.ajax({ url: ctx+'/main/uploadEvalReportPdf.do', type:'POST', data:fd, processData:false, contentType:false, dataType:'json',
      success:function(res){
        if(res && res.result==='OK'){ pdfPath=res.pdfPath||''; updatePdfUi(); toast('파일서버에 저장·첨부되었습니다.'); erPdfClose(); }
        else erSwal('error','저장 실패: '+((res&&res.message)||''), {title:'오류'});
      },
      error:function(){ erSwal('error','업로드 중 오류가 발생했습니다.', {title:'오류'}); }
    });
  }

  el('er-pdfFile').addEventListener('change', function(){
    var f = this.files && this.files[0];
    this.value = '';
    if(!f) return;
    if(!/\.pdf$/i.test(f.name)){ erSwal('warning','PDF 파일만 첨부할 수 있습니다.'); return; }
    var fd = new FormData();
    fd.append('pdfFile', f); fd.append('hospCd', hospCd); fd.append('evalYm', curYm);
    toast('PDF 업로드 중...');
    if(el('er-pdfModal').style.display==='flex'){ el('er-pdfLoading').style.display='flex'; el('er-pdfLoading').textContent='새 PDF 업로드 중…'; }
    jQuery.ajax({ url: ctx+'/main/uploadEvalReportPdf.do', type:'POST', data:fd,
      processData:false, contentType:false, dataType:'json',
      success:function(res){
        if(res && res.result==='OK'){
          pdfPath=res.pdfPath||''; updatePdfUi();
          // 미리보기 모달이 열려 있으면(검색으로 교체) 새 PDF 를 그 자리에서 바로 표시
          if(el('er-pdfModal').style.display==='flex'){ erPdfPreview(); toast('교체되었습니다.'); }
          else toast('PDF가 첨부되었습니다. 거래처에는 이 파일이 우선 제공됩니다.');
        }
        else erSwal('error','첨부 실패: '+((res&&res.message)||''), {title:'오류'});
      },
      error:function(){ erSwal('error','PDF 업로드 중 오류가 발생했습니다.', {title:'오류'}); }
    });
  });

  // (첨부 해제 UI 는 2026-07-15 제거 — 교체(검색)로 충분. 서버 /main/deleteEvalReportPdf.do 는 유지되어 있어 필요 시 UI 만 복구하면 됨)

  // 최초 진입 시 자동 조회
  try {
    if(hospCd){ erLoad(); }
    else { showErr('병원 정보를 찾지 못했습니다. 위너넷은 상단 병원검색으로 병원을 선택한 뒤 이용하세요.'); }
  } catch(e){ showErr((e&&e.message)||e); }

  // 월보고 목록에서 '인쇄'로 진입 — 조회·렌더 완료 후 인쇄 대화상자 자동 호출(1회). 제목 형식은 erPrint 가 지정.
  if(hospCd && _erAutoprint){
    setTimeout(function(){ try{ erPrint(); }catch(e){} }, 1800);
  }
});
</script>
