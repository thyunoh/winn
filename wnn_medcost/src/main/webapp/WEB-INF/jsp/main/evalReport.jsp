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
  #evalReport .er-toolbar{ position:fixed; top:56px; left:280px; right:0; z-index:1020; display:flex; align-items:center; gap:10px;
    padding:9px 16px; background:#fff; border-bottom:1px solid var(--er-line); border-left:4px solid var(--er-navy2); flex-wrap:wrap; box-shadow:0 3px 10px rgba(16,22,29,.08); }
  #evalReport .er-brand{ font-weight:800; font-size:14px; color:var(--er-ink); display:flex; align-items:center; gap:8px; }
  #evalReport .er-brand .er-dot{ width:9px; height:9px; border-radius:50%; background:linear-gradient(135deg,var(--er-navy),var(--er-navy2)); }
  #evalReport .er-role{ font-size:11px; font-weight:700; color:#fff; background:linear-gradient(135deg,var(--er-navy),var(--er-navy2)); padding:3px 9px; border-radius:20px; }
  #evalReport select.er-sel{ font-family:inherit; font-size:13px; padding:6px 8px; border:1px solid var(--er-line); border-radius:7px; background:#fff; color:var(--er-ink); font-weight:700; }
  #evalReport select.er-sel:hover{ border-color:var(--er-navy2); }
  #evalReport .er-hospnm{ font-size:13px; font-weight:700; color:var(--er-navy); }
  #evalReport .er-sp{ flex:1 1 auto; }
  #evalReport .er-status{ display:inline-flex; align-items:center; gap:7px; font-size:12.5px; font-weight:700; padding:5px 12px; border-radius:20px; border:1px solid transparent; }
  #evalReport .er-status .er-sdot{ width:8px; height:8px; border-radius:50%; }
  #evalReport .er-status.er-draft{ background:var(--er-ambertint); color:var(--er-amber); border-color:#ead9b0; }
  #evalReport .er-status.er-draft .er-sdot{ background:var(--er-amber); }
  #evalReport .er-status.er-approved{ background:var(--er-goodtint); color:var(--er-good); border-color:#bfe0c4; }
  #evalReport .er-status.er-approved .er-sdot{ background:var(--er-good); }
  /* 버튼 — 기본=흰 아웃라인 / 주요=네이비 솔리드 */
  #evalReport .er-btn{ font-family:inherit; font-size:13px; font-weight:700; cursor:pointer; padding:8px 14px; border-radius:6px;
    border:1px solid var(--er-line); background:#fff; color:var(--er-soft); transition:.15s; display:inline-flex; align-items:center; gap:6px; }
  #evalReport .er-btn:hover{ background:var(--er-line2); border-color:var(--er-navy2); color:var(--er-navy); }
  #evalReport .er-btn.er-primary{ background:var(--er-navy2); color:#fff; border-color:transparent; }
  #evalReport .er-btn.er-primary:hover{ background:var(--er-navy); color:#fff; }
  #evalReport .er-btn.er-good{ background:var(--er-good); color:#fff; border-color:transparent; }
  #evalReport .er-btn.er-good:hover{ background:#276b2a; color:#fff; }
  #evalReport .er-btn.er-on{ background:var(--er-ambertint); color:var(--er-amber); border-color:#e6cf9e; }
  #evalReport .er-btn:disabled{ opacity:.45; cursor:not-allowed; }
  #evalReport .er-btn.er-exit{ background:#fdecea; color:var(--er-bad); border-color:#f0b6ae; padding:10px 20px; font-size:14px; font-weight:800; }
  #evalReport .er-btn.er-exit:hover{ background:var(--er-bad); color:#fff; border-color:var(--er-bad); }
  #evalReport .er-btn.er-search{ background:var(--er-navy2); color:#fff; border-color:transparent; }
  #evalReport .er-btn.er-search:hover{ background:var(--er-navy); color:#fff; }
  /* 툴바 그룹/구분선 — 버튼을 기능별로 묶어 정렬 */
  #evalReport .er-group{ display:inline-flex; align-items:center; gap:7px; }
  #evalReport .er-searchbox{ display:inline-flex; align-items:center; gap:6px; padding:4px 6px 4px 8px; background:var(--er-navytint); border:1px solid #d5e4f6; border-radius:9px; }
  #evalReport .er-divider{ width:1px; align-self:stretch; min-height:22px; background:#c7d3e2; margin:0 3px; }

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

  #evalReport .er-toast{ position:fixed; bottom:24px; left:50%; transform:translateX(-50%) translateY(20px); background:#243247; color:#fff;
    padding:12px 22px; border-radius:10px; font-size:13px; font-weight:700; box-shadow:0 8px 30px rgba(0,0,0,.28); opacity:0; pointer-events:none; transition:.25s; z-index:90; }
  #evalReport .er-toast.er-show{ opacity:1; transform:translateX(-50%) translateY(0); }

  /* ===== 첨부 PDF 미리보기 모달 ===== */
  #evalReport .er-modal{ position:fixed; inset:0; z-index:1300; background:rgba(16,22,29,.55); display:flex; align-items:center; justify-content:center; padding:20px; }
  #evalReport .er-modal-box{ width:min(1000px,96vw); height:92vh; background:#fff; border-radius:12px; box-shadow:0 14px 46px rgba(0,0,0,.38); display:flex; flex-direction:column; overflow:hidden; }
  #evalReport .er-modal-head{ display:flex; align-items:center; justify-content:space-between; gap:10px; padding:11px 16px; background:var(--er-navytint); border-bottom:1px solid var(--er-line); font-weight:800; color:var(--er-navy); }
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
    <span class="er-brand"><span class="er-dot"></span>월간 컨설팅 보고서</span>
    <span id="er-roleTag" class="er-role">위너넷</span>
    <span class="er-hospnm" id="er-hospNm"></span>
    <span class="er-divider"></span>
    <!-- 그룹2: 평가년월 조회 -->
    <span class="er-searchbox">
      <select id="er-year" class="er-sel"></select>
      <select id="er-month" class="er-sel"></select>
      <button class="er-btn er-search" onclick="erLoad()">🔍 조회</button>
    </span>

    <span class="er-sp"></span>

    <!-- 그룹3: 상태 + 편집/저장/승인/PDF -->
    <span id="er-statusBadge" class="er-status er-draft"><span class="er-sdot"></span><span id="er-statusText">작성중</span></span>
    <span id="er-editTools" class="er-group">
      <button id="er-btnEdit" class="er-btn" onclick="erToggleEdit()">✏️ 편집</button>
      <button id="er-btnSave" class="er-btn er-primary" onclick="erSave()">💾 저장</button>
      <button id="er-btnApprove" class="er-btn er-good" onclick="erApprove()">✔ 승인·공개</button>
      <span class="er-divider"></span>
      <!-- 첨부 PDF: 첨부 전=[📎 PDF 첨부] / 첨부 후=[👁 PDF 보기] 하나만. 교체·해제는 '보기' 모달 안에 있음 -->
      <input type="file" id="er-pdfFile" accept="application/pdf,.pdf" style="display:none;">
      <button id="er-btnPdf" class="er-btn" onclick="erPickPdf()">📎 PDF 첨부</button>
      <a id="er-pdfView" class="er-btn er-primary" style="display:none;" href="#" onclick="erPdfPreview(); return false;">👁 PDF 보기</a>
    </span>
    <span class="er-divider"></span>
    <!-- 글자 크기(문서 배율) — 가운데 % 클릭 시 100% 복원. localStorage 저장(다음 진입 유지), 인쇄에도 반영 -->
    <button class="er-btn" onclick="erZoom(-1)" title="글자 작게">가−</button>
    <button class="er-btn" id="er-zoomPct" onclick="erZoom(0)" title="클릭=100% 복원" style="min-width:52px;">100%</button>
    <button class="er-btn" onclick="erZoom(1)" title="글자 크게">가＋</button>
    <span class="er-divider"></span>
    <button class="er-btn" onclick="erPreview()">👁 미리보기</button>
    <button class="er-btn" onclick="window.print()">🖨️ 인쇄</button>
    <!-- 그룹4: 종료 — 인쇄 바로 옆(구분선만), 조금 크게 -->
    <span class="er-divider"></span>
    <button class="er-btn er-exit" onclick="erExit()">✕ 종료</button>
  </div>

  <!-- 미리보기 모드 상단 바 (평소 숨김, .er-preview 일 때만 표시) -->
  <div class="er-prevbar">
    <span class="er-prevbar-t">📄 인쇄 미리보기 <span style="font-weight:600; opacity:.8;">— 인쇄하면 이 형태로 출력됩니다</span></span>
    <span style="flex:1 1 auto;"></span>
    <button class="er-btn" onclick="window.print()">🖨️ 인쇄</button>
    <button class="er-btn er-exit" onclick="erPreviewExit()">✕ 미리보기 닫기</button>
  </div>

  <div class="er-notice" id="er-notice">
    상단에서 <b>평가년월</b>을 고르고 <b>조회</b>하면 해당 월 자료로 표·점수가 자동으로 채워집니다.
    <b>편집 켜기</b>로 문구를 고친 뒤 <b>저장</b>, <b>승인</b>하면 그 시점 수치가 동결되어 거래처가 열람·인쇄합니다.
    아래한글로 작성한 완성본이 있으면 <b>📎 PDF 첨부</b>로 올리세요 — 첨부 PDF가 있으면 거래처에는 그 파일이 우선 제공됩니다.
  </div>

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
          <button id="er-pdfModalReplace" class="er-btn" onclick="erPickPdf()" title="다른 PDF 파일을 선택하면 바로 이 화면에서 열립니다">🔍 검색</button>
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
  if(!allowView){
    alert('월보고서는 준비 중입니다.');
    location.replace('/main/assessment.do');
    return;
  }

  var editing = false, approved = false, curYm = '', pdfPath = '';
  var indicators = [], scores = { struct:0, care:0, total:0 };

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
    '06':'배뇨장애·유치도뇨관 대상 환자에 대한 배뇨관리(일정한 배뇨/방광훈련/규칙적 도뇨) 실시 비율.',
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
    '06':'대상 환자별 배뇨관리 계획 수립 후 평가표의 배뇨관리 항목(일정한 배뇨·방광훈련·규칙적 도뇨)을 체크·기록. 실제 시행 대비 기록 누락 여부 우선 점검.',
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

  // 화면에 보이는 오류 표시(콘솔 못 볼 때 진단용)
  function showErr(msg){
    var nb=el('er-notice');
    if(nb){ nb.style.background='#fdecea'; nb.style.borderColor='#f0b6ae'; nb.style.color='#a5281b';
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
    location.href = ctx + '/main/assessment.do';
  };

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
    var t = ev.target && ev.target.closest ? ev.target.closest('[data-ckey]') : null;
    if(!t) return;
    var src = document.querySelector('#evalReport .er-editable[data-key="'+t.getAttribute('data-ckey')+'"]');
    if(src) src.innerHTML = t.innerHTML;
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
  el('er-pdfModal').addEventListener('click', function(e){ if(e.target === this) erPdfClose(); });

  document.addEventListener('keydown', function(e){   // ESC — 미리보기/PDF모달 닫기
    if(e.key!=='Escape') return;
    if(el('er-pdfModal') && el('er-pdfModal').style.display==='flex'){ erPdfClose(); return; }
    if(el('evalReport') && el('evalReport').classList.contains('er-preview')) erPreviewExit();
  });

  // 평가년월 결정: ①URL ?ym=YYYYMM ②적정성평가 화면 sessionStorage(assessment_year/month) ③지난달
  function defaultYm(){
    var qm=(location.search.match(/[?&]ym=(\d{6})/)||[])[1];
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
      el('er-hospNm').textContent = hospNm ? ('['+hospNm+']') : '';
      if(hospNm) el('er-coverHosp').textContent = hospNm;
      if(!isWinner){                          // 거래처: 편집도구 숨김(열람·인쇄만)
        el('er-editTools').style.display='none';
        el('er-roleTag').textContent='거래처';
        el('er-notice').textContent='승인된 보고서를 열람·인쇄할 수 있습니다.';
      }
      erFixToolbar();                         // 툴바 위치 확정
      setTimeout(erFixToolbar, 200);          // 앱 레이아웃(헤더/사이드바) 렌더 후 재보정
    }catch(e){ showErr((e&&e.message)||e); }
  })();

  function editables(){ return document.querySelectorAll('#evalReport .er-editable[data-key]'); }

  function setStatus(st){
    approved = (st==='APPROVED');
    var b=el('er-statusBadge'), t=el('er-statusText');
    if(approved){ b.className='er-status er-approved'; t.textContent='승인됨 · 거래처 공개'; }
    else { b.className='er-status er-draft'; t.textContent='작성중'; }
    if(isWinner){
      el('er-btnApprove').textContent = approved ? '↩ 승인 취소' : '✔ 승인·거래처 공개';
      el('er-btnEdit').disabled = approved;
      if(approved && editing) erToggleEdit();
    }
  }

  window.erToggleEdit = function(){
    if(approved){ toast('승인된 보고서는 편집할 수 없습니다. 승인 취소 후 편집하세요.'); return; }
    editing=!editing;
    el('evalReport').classList.toggle('er-editmode', editing);
    erPaginate();   // A4 분할 유지한 채 재분할 — 편집 종료 시 고친 문구 길이에 맞게 페이지 재배치
    editables().forEach(function(e){ e.contentEditable = editing?'true':'false'; });
    var b=el('er-btnEdit'); b.textContent=editing?'✏️ 편집 끄기':'✏️ 편집 켜기'; b.classList.toggle('er-on',editing);
    if(editing) toast('편집 모드: 파란 영역의 문구를 직접 고칠 수 있습니다.');
  };

  // ===== 조회: 지표 자료 + 5점구간 기준(적정성 화면과 동일 소스) 동시 로드 → 렌더 → 저장문구 로드 =====
  window.erLoad = function(){
    curYm = el('er-year').value + el('er-month').value;
    if(!hospCd){ toast('로그인 병원 정보가 없습니다.'); return; }
    var aIndi = jQuery.ajax({ url: ctx+'/main/select_Eval_Indi.do',     type:'POST', dataType:'json', data:{ hosp_cd:hospCd, jobyymm:curYm } });
    var aCrit = jQuery.ajax({ url: ctx+'/main/select_ScoreCriteria.do', type:'POST', dataType:'json', data:{ jobyymm:curYm } });
    jQuery.when(aIndi, aCrit).done(function(r1, r2){
      var res = r1[0];
      indicators = (res && res.data)? res.data.filter(function(r){ return r.cate_cd!=='99'; }) : [];
      buildCriteria(r2[0]);
      renderAll();
      loadSavedTexts();
    }).fail(function(){ toast('지표 자료 조회 중 오류가 발생했습니다.'); });
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
  function renderSummary(){
    if(!indicators.length) return;
    var gs=goalScoreVal(), gg=goalGradeVal(), gap=Math.round((gs-scores.total)*10)/10;
    var ymTxt = curYm? curYm.substring(0,4)+'년 '+parseInt(curYm.substring(4,6),10)+'월' : '이번 달';
    var fulls = indicators.filter(function(r){ return n(r.stdweig)>0 && (n(r.stdweig)-n(r.weigval))<=0.0001; })
                          .map(function(r){ return r.cate_nm; });
    var tops = topGaps(2);
    var p = {};
    p.sum_p1 = ymTxt+' 예상 종합점수는 '+f1(scores.total)+'점으로 '+gradeOf(scores.total)+'에 해당합니다. '
             + (gap>0 ? '목표인 '+gg+'('+fnum(gs)+'점)까지는 '+f1(gap)+'점이 더 필요한 상황입니다.'
                      : '목표인 '+gg+'('+fnum(gs)+'점)를 달성한 수준으로, 남은 기간 동안 유지 관리가 중요합니다.');
    p.sum_p2 = '구조영역은 '+f1(scores.struct)+'점입니다. 실제 점수는 차등제 신고 결과가 합산되어 확정되므로, 재원환자 수와 인력 추이가 변동되지 않도록 꾸준히 관리해 주시기 바랍니다.';
    p.sum_p3 = '';
    if(fulls.length) p.sum_p3 += '진료영역에서는 '+fulls.slice(0,4).join(', ')+(fulls.length>4?' 등':'')+' 지표가 잘 관리되고 있습니다. ';
    if(tops.length){
      var t=tops[0];
      p.sum_p3 += '반면 '+t.nm+'은(는) 개선 여지가 가장 큰 지표로, 표준화 구간을 한 단계 올릴 때마다 약 +'+f1(t.w/5)+'점을 확보할 수 있습니다.'
                + (tops[1]? ' '+tops[1].nm+'도 함께 관리하시면 좋겠습니다.' : '');
    }
    if(!p.sum_p3) p.sum_p3 = '진료영역 지표는 전반적으로 안정적으로 관리되고 있습니다.';
    p.sum_p4 = '항정신성의약품 처방률, DUR 점검률, 지역사회복귀율은 예상값 기준으로 산출되어 최종 평가 결과에 따라 점수가 다소 달라질 수 있습니다. 해당 대상자 관리를 꾸준히 부탁드립니다.';
    p.sum_p5 = '신뢰도 점검 결과는 적정성평가에 그대로 반영되므로, 의무기록과 환자평가표가 서로 일치하는지 함께 점검해 주시기 바랍니다.';
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
      var goalTxt = (s>=5) ? '' : '목표 : '+nz+'구간 진입 시 <b class="er-num">+'+f1(tgt-x.got)+'점</b> ('+f1(x.got)+' → '+f1(tgt)+')';
      var dirTxt = TPL_DIR[x.cd] ? esc(TPL_DIR[x.cd]) : '개선 방향과 목표 구간을 입력하세요.';
      html += '<div class="er-rec'+(isTop?' er-top':'')+'">'
            +   '<div class="er-rech">'+(CIRC[i]||(i+1))+' '+esc(x.nm)+' <span class="er-w">· 가중치 '+fnum(x.w)+' · 부족분 '+f1(x.gap)+(isTop?' · 최우선':'')+'</span></div>'
            +   '<div class="er-recrow"><span class="er-lb">현황</span>'+stat+'</div>'
            +   (zones? '<div class="er-recrow"><span class="er-lb">표준화 구간</span>'+zones+'</div>' : '')
            +   '<div class="er-recrow er-editable" data-key="recdir_'+cd+'"><span class="er-lb">개선방향</span>'+dirTxt+'</div>'
            +   (goalTxt? '<div class="er-recgoal">'+goalTxt+'</div>' : '')
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
        setStatus(mst && mst.status ? mst.status : 'DRAFT');
        pdfPath = (mst && mst.pdfpath) ? String(mst.pdfpath) : '';
        updatePdfUi();
        editables().forEach(function(e){ e.contentEditable='false'; });
        editing=false; el('evalReport').classList.remove('er-editmode');
        if(isWinner){ var b=el('er-btnEdit'); b.textContent='✏️ 편집 켜기'; b.classList.remove('er-on'); }
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

  function doSave(onOk){
    var payload = { hospCd:hospCd, evalYm:curYm, title:(hospNm||'')+' 적정성평가 컨설팅 보고서',
      goalGrade:goalGradeVal(), goalScore:goalScoreVal(),
      structScore:Math.round(scores.struct*10)/10, careScore:Math.round(scores.care*10)/10, totalScore:Math.round(scores.total*10)/10,
      texts:collectTexts() };
    jQuery.ajax({ url: ctx+'/main/saveEvalReport.do', type:'POST', contentType:'application/json', dataType:'json',
      data: JSON.stringify(payload),
      success:function(res){ if(res && res.result==='OK'){ if(onOk) onOk(); } else toast('저장 실패: '+((res&&res.message)||'')); },
      error:function(){ toast('저장 중 오류가 발생했습니다.'); }
    });
  }

  window.erSave = function(){
    if(!curYm){ toast('먼저 평가년월을 조회하세요.'); return; }
    doSave(function(){ toast('저장되었습니다.'); });
  };

  window.erApprove = function(){
    if(!curYm){ toast('먼저 평가년월을 조회하세요.'); return; }
    if(approved){
      // 승인 취소
      jQuery.ajax({ url: ctx+'/main/approveEvalReport.do', type:'POST', contentType:'application/json', dataType:'json',
        data: JSON.stringify({ hospCd:hospCd, evalYm:curYm, cancel:'Y' }),
        success:function(res){ if(res && res.result==='OK'){ setStatus('DRAFT'); toast('승인이 취소되었습니다.'); } else toast('처리 실패: '+((res&&res.message)||'')); },
        error:function(){ toast('승인 처리 중 오류가 발생했습니다.'); }
      });
      return;
    }
    // 승인: 최신 문구 저장 완료 후 → 승인(수치 스냅샷 동결)
    doSave(function(){
      var snapshot = JSON.stringify({ scores:scores, indicators:indicators, evalYm:curYm });
      jQuery.ajax({ url: ctx+'/main/approveEvalReport.do', type:'POST', contentType:'application/json', dataType:'json',
        data: JSON.stringify({ hospCd:hospCd, evalYm:curYm, cancel:'N', snapshotJson:snapshot }),
        success:function(res){
          if(res && res.result==='OK'){ setStatus('APPROVED'); toast('승인되었습니다. 거래처가 열람·인쇄할 수 있습니다.'); }
          else toast('처리 실패: '+((res&&res.message)||''));
        },
        error:function(){ toast('승인 처리 중 오류가 발생했습니다.'); }
      });
    });
  };

  // ===== 첨부 PDF (아래한글 완성본 하이브리드) =====
  //  · 툴바: 첨부 전 = [📎 PDF 첨부] / 첨부 후 = [👁 PDF 보기] 하나만 (헷갈림 방지)
  //  · 교체·해제는 '보기' 모달 안에서 (위너넷만)
  function updatePdfUi(){
    var has = !!pdfPath;
    var dlUrl = has ? (ctx+'/sftp/download.do?filePath='+encodeURIComponent(pdfPath)) : '#';
    el('er-pdfView').style.display = has ? '' : 'none';               // 첨부 후: 보기 버튼
    el('er-btnPdf').style.display  = (isWinner && !has) ? '' : 'none'; // 첨부 전(위너넷): 첨부 버튼
    // 모달 안 교체(검색) = 위너넷만 노출
    var mr=el('er-pdfModalReplace');
    if(mr) mr.style.display = isWinner ? '' : 'none';
    // 거래처: 첨부 PDF 우선 안내 배너
    var bn=el('er-pdfBanner');
    if(!isWinner && has){ bn.style.display=''; el('er-pdfBannerLink').href=dlUrl; }
    else bn.style.display='none';
  }

  window.erPickPdf = function(){
    if(!curYm){ toast('먼저 평가년월을 조회하세요.'); return; }
    if(approved){ toast('승인된 보고서는 변경할 수 없습니다. 승인 취소 후 첨부하세요.'); return; }
    el('er-pdfFile').click();
  };

  el('er-pdfFile').addEventListener('change', function(){
    var f = this.files && this.files[0];
    this.value = '';
    if(!f) return;
    if(!/\.pdf$/i.test(f.name)){ toast('PDF 파일만 첨부할 수 있습니다.'); return; }
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
        else toast('첨부 실패: '+((res&&res.message)||''));
      },
      error:function(){ toast('PDF 업로드 중 오류가 발생했습니다.'); }
    });
  });

  // (첨부 해제 UI 는 2026-07-15 제거 — 교체(검색)로 충분. 서버 /main/deleteEvalReportPdf.do 는 유지되어 있어 필요 시 UI 만 복구하면 됨)

  // 최초 진입 시 자동 조회
  try {
    if(hospCd){ erLoad(); }
    else { showErr('병원 정보를 찾지 못했습니다. 위너넷은 상단 병원검색으로 병원을 선택한 뒤 이용하세요.'); }
  } catch(e){ showErr((e&&e.message)||e); }
});
</script>
