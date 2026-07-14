<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<%-- 적정성평가 컨설팅 월보고서 : 위너넷 편집·저장·승인 → 거래처 열람·인쇄.
     · 수치(구조/진료/종합·지표표·우선지표)는 /main/select_Eval_Indi.do 로 자동 채움(병원·월별)
     · 문구는 편집영역(.er-editable[data-key]) → /main/saveEvalReport.do 로 저장(override)
     · 승인 시 수치 스냅샷 동결 → 거래처 공개
     모든 스타일/클래스는 #evalReport 하위로 스코프(er- 접두)해 앱 화면과 충돌 방지 --%>

<div id="evalReport">
<style>
  #evalReport{
    --er-paper:#fff; --er-bg:#eef2f7; --er-ink:#1a2332; --er-soft:#44546a;
    --er-line:#d7dfea; --er-line2:#e8eef5; --er-navy:#1e3c72; --er-navy2:#2a5298; --er-navytint:#f2f6fc;
    --er-bad:#c0392b; --er-badtint:#fdecea; --er-good:#2e7d32; --er-goodtint:#eaf5ec;
    --er-amber:#b7791f; --er-ambertint:#fbf3e2;
    background:var(--er-bg); color:var(--er-ink); padding-bottom:50px;
    font-family:"Malgun Gothic","Apple SD Gothic Neo","Noto Sans KR","Segoe UI",sans-serif;
  }
  #evalReport *{ box-sizing:border-box; }
  #evalReport .er-num{ font-variant-numeric:tabular-nums; }

  /* 툴바 */
  #evalReport .er-toolbar{ position:sticky; top:0; z-index:40; display:flex; align-items:center; gap:12px;
    padding:10px 16px; background:#e7edf5; border-bottom:1px solid #cdd8e6; flex-wrap:wrap; }
  #evalReport .er-brand{ font-weight:800; font-size:14px; color:#243247; display:flex; align-items:center; gap:8px; }
  #evalReport .er-brand .er-dot{ width:9px; height:9px; border-radius:50%; background:linear-gradient(135deg,var(--er-navy),var(--er-navy2)); }
  #evalReport .er-role{ font-size:11px; font-weight:700; color:#fff; background:linear-gradient(135deg,var(--er-navy),var(--er-navy2)); padding:3px 9px; border-radius:20px; }
  #evalReport select.er-sel{ font-family:inherit; font-size:13px; padding:6px 8px; border:1px solid #cdd8e6; border-radius:7px; background:#fff; color:#243247; }
  #evalReport .er-hospnm{ font-size:13px; font-weight:700; color:var(--er-navy); }
  #evalReport .er-sp{ flex:1 1 auto; }
  #evalReport .er-status{ display:inline-flex; align-items:center; gap:7px; font-size:12.5px; font-weight:700; padding:5px 12px; border-radius:20px; border:1px solid transparent; }
  #evalReport .er-status .er-sdot{ width:8px; height:8px; border-radius:50%; }
  #evalReport .er-status.er-draft{ background:var(--er-ambertint); color:var(--er-amber); border-color:#ead9b0; }
  #evalReport .er-status.er-draft .er-sdot{ background:var(--er-amber); }
  #evalReport .er-status.er-approved{ background:var(--er-goodtint); color:var(--er-good); border-color:#bfe0c4; }
  #evalReport .er-status.er-approved .er-sdot{ background:var(--er-good); }
  #evalReport .er-btn{ font-family:inherit; font-size:13px; font-weight:700; cursor:pointer; padding:8px 14px; border-radius:8px;
    border:1px solid #cdd8e6; background:#fff; color:#243247; transition:.15s; display:inline-flex; align-items:center; gap:6px; }
  #evalReport .er-btn:hover{ border-color:var(--er-navy2); color:var(--er-navy2); }
  #evalReport .er-btn.er-primary{ background:linear-gradient(135deg,var(--er-navy),var(--er-navy2)); color:#fff; border-color:transparent; }
  #evalReport .er-btn.er-good{ background:linear-gradient(135deg,#2e7d32,#3a9d40); color:#fff; border-color:transparent; }
  #evalReport .er-btn.er-on{ background:var(--er-ambertint); color:var(--er-amber); border-color:#e6cf9e; }
  #evalReport .er-btn:disabled{ opacity:.45; cursor:not-allowed; }

  #evalReport .er-notice{ max-width:880px; margin:16px auto 0; padding:12px 16px; border-radius:10px; background:var(--er-navytint);
    border:1px solid #cfe0f4; color:var(--er-navy); font-size:12.5px; line-height:1.6; }

  /* 지면 */
  #evalReport .er-doc{ padding:22px 14px 40px; display:flex; flex-direction:column; align-items:center; gap:20px; }
  #evalReport .er-page{ width:880px; max-width:100%; background:var(--er-paper); box-shadow:0 6px 26px rgba(28,45,72,.14);
    border-radius:6px; padding:46px 50px; }
  @media (max-width:720px){ #evalReport .er-page{ padding:28px 18px; } }

  /* 편집 */
  #evalReport .er-editable{ outline:none; border-radius:4px; transition:.12s; }
  #evalReport.er-editmode .er-editable{ box-shadow:inset 0 0 0 1px #bcd0ea; background:#f7fbff; cursor:text; }
  #evalReport.er-editmode .er-editable:focus{ box-shadow:inset 0 0 0 2px var(--er-navy2); background:#fff; }

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
  #evalReport .er-eyebrow{ display:flex; align-items:baseline; gap:11px; border-bottom:2px solid var(--er-navy); padding-bottom:8px; margin-bottom:18px; }
  #evalReport .er-rn{ font-size:21px; font-weight:800; color:var(--er-navy); font-family:"Times New Roman",serif; }
  #evalReport .er-stitle{ font-size:17px; font-weight:800; }
  #evalReport .er-subh{ font-size:14px; font-weight:800; color:var(--er-navy2); margin:22px 0 11px; display:flex; align-items:center; gap:8px; }
  #evalReport .er-subh::before{ content:""; width:4px; height:14px; background:var(--er-navy2); border-radius:2px; }

  /* 점수카드 */
  #evalReport .er-cards{ display:grid; grid-template-columns:repeat(3,1fr); gap:13px; }
  @media (max-width:640px){ #evalReport .er-cards{ grid-template-columns:1fr; } }
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
  #evalReport table.er-tbl th, #evalReport table.er-tbl td{ padding:9px 10px; border-bottom:1px solid var(--er-line2); text-align:center; }
  #evalReport table.er-tbl thead th{ background:linear-gradient(135deg,var(--er-navy),var(--er-navy2)); color:#fff; font-weight:700; border-bottom:none; white-space:nowrap; }
  #evalReport table.er-tbl td.er-l, #evalReport table.er-tbl th.er-l{ text-align:left; }
  #evalReport table.er-tbl tr.er-grp td{ background:var(--er-navytint); font-weight:800; color:var(--er-navy); text-align:left; }
  #evalReport table.er-tbl tr.er-sub td{ background:#f4f7fb; font-weight:800; border-top:1.5px solid var(--er-line); }
  #evalReport table.er-tbl tr.er-tot td{ background:#eef3fb; font-weight:800; color:var(--er-navy); border-top:2px solid var(--er-navy); }
  #evalReport .er-b-bad{ color:var(--er-bad); font-weight:800; }
  #evalReport .er-b-good{ color:var(--er-good); font-weight:800; }
  #evalReport .er-zero{ color:#a7b1c0; }
  #evalReport .er-r100{ color:var(--er-good); font-weight:700; }
  #evalReport table.er-grade tr.er-cur td{ background:var(--er-badtint); }
  #evalReport table.er-grade tr.er-cur td:first-child{ color:var(--er-bad); font-weight:800; }
  #evalReport table.er-grade tr.er-goal td{ background:var(--er-ambertint); }
  #evalReport table.er-grade tr.er-goal td:first-child{ color:var(--er-amber); font-weight:800; }

  #evalReport .er-callout{ margin-top:13px; padding:13px 15px; border-radius:10px; border-left:4px solid var(--er-navy2); background:var(--er-navytint); font-size:12.7px; }
  #evalReport .er-callout .er-coh{ font-weight:800; color:var(--er-navy); margin-bottom:5px; }
  #evalReport .er-fn{ font-size:11px; color:var(--er-soft); margin-top:10px; line-height:1.6; }

  #evalReport .er-ind{ border:1px solid var(--er-line); border-radius:11px; padding:14px 16px; margin-top:12px; background:#fff; }
  #evalReport .er-indh{ display:flex; align-items:center; gap:9px; flex-wrap:wrap; margin-bottom:8px; }
  #evalReport .er-indnm{ font-size:13.5px; font-weight:800; }
  #evalReport .er-indsc{ font-size:12px; font-weight:800; color:var(--er-navy2); background:var(--er-navytint); border:1px solid #d5e4f6; padding:2px 9px; border-radius:16px; }
  #evalReport .er-ana{ font-size:12.5px; margin:0; }
  #evalReport .er-ana .er-mk{ color:var(--er-navy2); font-weight:800; margin-right:4px; }
  #evalReport .er-plan{ font-size:12.5px; margin:7px 0 0; padding-top:8px; border-top:1px dashed var(--er-line); }
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

  /* 인쇄: 앱 크롬 숨기고 보고서만 (툴바·안내문 제외) */
  @media print{
    body *{ visibility:hidden !important; }
    #evalReport, #evalReport *{ visibility:visible !important; }
    #evalReport{ position:absolute; left:0; top:0; width:100%; background:#fff; padding:0; }
    #evalReport .er-toolbar, #evalReport .er-notice, #evalReport .er-toast{ display:none !important; }
    #evalReport .er-doc{ padding:0; gap:0; }
    #evalReport .er-page{ box-shadow:none; border-radius:0; width:100%; padding:12mm 14mm; page-break-after:always; }
    #evalReport .er-sec, #evalReport .er-ind, #evalReport .er-rec, #evalReport .er-card, #evalReport table.er-tbl, #evalReport .er-after{ page-break-inside:avoid; }
    @page{ size:A4; margin:0; }
  }
</style>

  <!-- ===== 툴바 ===== -->
  <div class="er-toolbar">
    <span class="er-brand"><span class="er-dot"></span>적정성평가 월간 컨설팅 보고서</span>
    <span id="er-roleTag" class="er-role">위너넷</span>
    <span class="er-hospnm" id="er-hospNm"></span>
    <select id="er-year" class="er-sel"></select>
    <select id="er-month" class="er-sel"></select>
    <button class="er-btn" onclick="erLoad()">🔍 조회</button>
    <span class="er-sp"></span>
    <span id="er-statusBadge" class="er-status er-draft"><span class="er-sdot"></span><span id="er-statusText">작성중</span></span>
    <span id="er-editTools">
      <button id="er-btnEdit" class="er-btn" onclick="erToggleEdit()">✏️ 편집 켜기</button>
      <button id="er-btnSave" class="er-btn er-primary" onclick="erSave()">💾 저장</button>
      <button id="er-btnApprove" class="er-btn er-good" onclick="erApprove()">✔ 승인·거래처 공개</button>
      <input type="file" id="er-pdfFile" accept="application/pdf,.pdf" style="display:none;">
      <button id="er-btnPdf" class="er-btn" onclick="erPickPdf()">📎 PDF 첨부</button>
      <button id="er-btnPdfDel" class="er-btn" style="display:none;" onclick="erDelPdf()">❌ 첨부해제</button>
    </span>
    <a id="er-pdfView" class="er-btn" style="display:none;" href="#">📄 첨부PDF</a>
    <button class="er-btn" onclick="window.print()">🖨️ 인쇄</button>
  </div>

  <div class="er-notice" id="er-notice">
    상단에서 <b>평가년월</b>을 고르고 <b>조회</b>하면 해당 월 자료로 표·점수가 자동으로 채워집니다.
    <b>편집 켜기</b>로 문구를 고친 뒤 <b>저장</b>, <b>승인</b>하면 그 시점 수치가 동결되어 거래처가 열람·인쇄합니다.
    아래한글로 작성한 완성본이 있으면 <b>📎 PDF 첨부</b>로 올리세요 — 첨부 PDF가 있으면 거래처에는 그 파일이 우선 제공됩니다.
  </div>

  <div class="er-notice" id="er-pdfBanner" style="display:none; border-color:#bfe0c4; background:var(--er-goodtint); color:var(--er-good);">
    📄 <b>완성본 PDF가 첨부된 보고서입니다.</b>
    <a id="er-pdfBannerLink" href="#" style="font-weight:800; color:var(--er-good); text-decoration:underline;">PDF 다운로드</a>
  </div>

  <!-- ===== 지면 ===== -->
  <div class="er-doc">
    <!-- PAGE 1 : 표지 + Ⅰ -->
    <div class="er-page">
      <div class="er-ctop er-editable" data-key="cover_top">요양병원 입원급여 적정성평가</div>
      <div class="er-ctitle"><span class="er-editable" data-key="cover_hosp" id="er-coverHosp">○○요양병원</span> 적정성평가 결과 및 등급 향상 컨설팅 보고서</div>
      <div class="er-csub">
        <span class="er-kv">평가대상 <b id="er-coverPeriod">-</b></span>
        <span class="er-kv">현재 종합점수 <b class="er-b-bad er-num" id="er-coverTotal">-</b>점</span>
        <span class="er-kv">→ 목표등급 <b><span class="er-editable" data-key="cover_goal_grade">3등급</span> (<span class="er-editable" data-key="cover_goal_score">78</span>점)</b></span>
        <span class="er-goalbadge">목표 <span class="er-editable" data-key="cover_goal_badge">3등급</span></span>
      </div>
      <div class="er-cmeta">본 보고서는 <b>WinCheck⁺</b> 산출 자료를 기준으로 작성되었습니다. · 작성일 <span class="er-editable" data-key="cover_date" id="er-coverDate">-</span></div>

      <div class="er-sec">
        <div class="er-eyebrow"><span class="er-rn">Ⅰ</span><span class="er-stitle">종합 평가 요약</span></div>
        <div class="er-cards">
          <div class="er-card"><div class="er-clabel">구조영역 <span class="er-cmax">/ 30점</span></div><div class="er-cscore er-num" id="er-cardStruct">-</div><div class="er-cfoot">획득률 <span id="er-rateStruct">-</span></div></div>
          <div class="er-card"><div class="er-clabel">진료영역 <span class="er-cmax">/ 70점</span></div><div class="er-cscore er-num" id="er-cardCare">-</div><div class="er-cfoot">획득률 <span id="er-rateCare">-</span></div></div>
          <div class="er-card er-total"><div class="er-clabel">종합점수 <span class="er-cmax">/ 100점</span></div><div class="er-cscore er-num" id="er-cardTotal">-</div><div class="er-cfoot">현재 <b class="er-b-bad" id="er-curGrade">-</b></div></div>
        </div>
        <div class="er-gapcard"><div class="er-clabel">목표(<span id="er-gapGoalScore">78</span>점)까지 부족 점수</div><div class="er-cscore er-num" id="er-gapScore">-</div></div>

        <div class="er-subh">1. 현재 위치와 목표</div>
        <div class="er-tw">
          <table class="er-tbl er-grade">
            <thead><tr><th class="er-l">등급</th><th>표준화 점수구간</th><th>현황</th></tr></thead>
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
            <thead><tr><th>순위</th><th class="er-l">지표</th><th>영역</th><th>가중치</th><th>현재점수</th><th>부족분</th></tr></thead>
            <tbody id="er-priBody"><!-- JS --></tbody>
          </table>
        </div>
        <div class="er-fn er-editable" data-key="pri_note">※ 부족분 = 가중치(만점) − 현재 획득점수. 가중치가 큰 결과지표의 실적 기록 정상화가 등급 향상의 핵심 지렛대입니다.</div>
      </div>
    </div>

    <!-- PAGE 2 : Ⅱ 상세 분석표 -->
    <div class="er-page">
      <div class="er-sec" style="margin-top:0;">
        <div class="er-eyebrow"><span class="er-rn">Ⅱ</span><span class="er-stitle">영역별·지표별 상세 분석</span></div>
        <div class="er-tw">
          <table class="er-tbl">
            <thead><tr><th class="er-l">지표명</th><th>가중치<br>(만점)</th><th>현황값</th><th>표준화<br>구간</th><th>획득점수</th><th>획득률</th><th>부족분</th></tr></thead>
            <tbody id="er-tbl2Body"><!-- JS --></tbody>
          </table>
        </div>
        <div class="er-fn er-editable" data-key="tbl2_note">※ 표준화 구간은 직전 주기 평가결과 기준(1구간 미흡 ~ 5구간 우수). 획득점수 = 가중치 ÷ 5 × 표준화구간. ※ 항정신성의약품 처방률은 시스템 산출 PI값으로 실제 평가결과와 차이가 있을 수 있습니다(참고용).</div>
      </div>
    </div>

    <!-- PAGE 3 : Ⅲ 지표별 분석 내용 (편집 문구) -->
    <div class="er-page">
      <div class="er-sec" style="margin-top:0;">
        <div class="er-eyebrow"><span class="er-rn">Ⅲ</span><span class="er-stitle">지표별 분석 내용</span></div>
        <p class="er-fn er-editable" data-key="sec3_lead" style="margin-top:0;">각 지표의 산정 근거(분모·분자·현황값 → 표준화구간 → 획득점수)와 지표 정의, 개선 방향을 정리했습니다.</p>
        <div id="er-sec3Body"><!-- 기본 문구는 JS 가 채우고, 저장된 override 가 있으면 덮어씀 --></div>
      </div>
    </div>

    <!-- PAGE 4 : Ⅳ 권고 + Ⅴ 로드맵 (편집 문구) -->
    <div class="er-page">
      <div class="er-sec" style="margin-top:0;">
        <div class="er-eyebrow"><span class="er-rn">Ⅳ</span><span class="er-stitle">우선 개선지표별 권고사항</span></div>
        <div id="er-sec4Body"></div>
      </div>
      <div class="er-sec">
        <div class="er-eyebrow"><span class="er-rn">Ⅴ</span><span class="er-stitle">목표등급 달성 로드맵</span></div>
        <div class="er-callout">
          <div class="er-coh">결론</div>
          <div class="er-editable" data-key="concl">가중치가 큰 결과지표(예: 욕창·ADL 개선)의 실적 기록 정상화만으로 큰 폭의 점수 확보가 가능합니다. 실제 진료·재활은 이뤄지나 개선 판정이 평가표에 기록되지 않아 낮게 산정되는 경우가 많으므로, 추가 인력·비용 없이 기록·평가 절차 개선으로 목표 달성 가능성이 높습니다.</div>
          <div class="er-fn er-editable" data-key="concl_note">※ 단기 실행 우선순위: (1) 결과지표 재평가 기록 절차 정비 → (2) 과정지표 기록 → (3) 퇴원계획(지역연계) 강화.</div>
        </div>
        <div class="er-after"><span class="er-lbl">개선 후 예상 종합점수</span><span class="er-from er-num" id="er-afterFrom">-</span>→<span class="er-val er-num er-editable" data-key="after_score">-</span><span class="er-lbl">( 목표등급 진입 )</span></div>
      </div>
      <div class="er-docfoot er-editable" data-key="footer">본 보고서는 WinCheck⁺ 시스템 산출값을 근거로 작성되었으며, 목표등급은 해당 병원의 설정값 기준입니다. 실제 평가결과는 심평원 최종 산정 기준 및 자료 확정 시점에 따라 달라질 수 있습니다.</div>
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
    alert('월보고서는 준비 중입니다.\n(위너넷 계정인데 이 메시지가 보이면 로그아웃 후 다시 로그인하세요.)');
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

  function toast(m){ var t=el('er-toast'); t.textContent=m; t.classList.add('er-show'); clearTimeout(t._tm); t._tm=setTimeout(function(){t.classList.remove('er-show');},2600); }

  // 화면에 보이는 오류 표시(콘솔 못 볼 때 진단용)
  function showErr(msg){
    var nb=el('er-notice');
    if(nb){ nb.style.background='#fdecea'; nb.style.borderColor='#f0b6ae'; nb.style.color='#a5281b';
            nb.innerHTML='⚠️ 월보고서 초기화 오류: '+esc(msg); }
  }

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
    editables().forEach(function(e){ e.contentEditable = editing?'true':'false'; });
    var b=el('er-btnEdit'); b.textContent=editing?'✏️ 편집 끄기':'✏️ 편집 켜기'; b.classList.toggle('er-on',editing);
    if(editing) toast('편집 모드: 파란 영역의 문구를 직접 고칠 수 있습니다.');
  };

  // ===== 조회: 지표 자동조회 → 표/점수/문구 렌더 → 저장문구 로드 =====
  window.erLoad = function(){
    curYm = el('er-year').value + el('er-month').value;
    if(!hospCd){ toast('로그인 병원 정보가 없습니다.'); return; }
    jQuery.ajax({ url: ctx+'/main/select_Eval_Indi.do', type:'POST', dataType:'json',
      data:{ hosp_cd:hospCd, jobyymm:curYm },
      success:function(res){
        indicators = (res && res.data)? res.data.filter(function(r){ return r.cate_cd!=='99'; }) : [];
        renderAll();
        loadSavedTexts();
      },
      error:function(){ toast('지표 자료 조회 중 오류가 발생했습니다.'); }
    });
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
    var goalScore = goalScoreVal();
    el('er-gapGoalScore').textContent = goalScore;
    el('er-curGrade').textContent = gradeOf(scores.total);
    var gap = goalScore - scores.total;
    el('er-gapScore').textContent = (gap>0?'+':'') + (Math.round(gap*10)/10);
    el('er-afterFrom').textContent = f1(scores.total);
    // 등급표
    var bands=[['1등급','88 ~ 100'],['2등급','79 ~ 87'],['3등급','71 ~ 78'],['4등급','63 ~ 70'],['5등급','63 미만']];
    var cur=gradeOf(scores.total), goalGrade=goalGradeVal();
    el('er-gradeBody').innerHTML = bands.map(function(b){
      var cls = (b[0]===cur)?' class="er-cur"' : (b[0]===goalGrade?' class="er-goal"':'');
      var mark = (b[0]===cur)?('<b class="er-num">'+f1(scores.total)+'점</b>') : (b[0]===goalGrade?'목표 구간':'');
      var nm = b[0] + (b[0]===cur?' (현재)':(b[0]===goalGrade?' (목표)':''));
      return '<tr'+cls+'><td class="er-l">'+nm+'</td><td class="er-num">'+b[1]+'</td><td>'+mark+'</td></tr>';
    }).join('');
    // 우선지표(부족분 상위 6)
    var pri = topGaps(6);
    el('er-priBody').innerHTML = pri.length? pri.map(function(x,i){
      return '<tr><td>'+(i+1)+'</td><td class="er-l">'+esc(x.nm)+'</td><td>'+areaNm(x.fg)+'</td><td class="er-num">'+fnum(x.w)+'</td><td class="er-num">'+f1(x.got)+'</td><td class="er-b-bad er-num">'+f1(x.gap)+'</td></tr>';
    }).join('') : '<tr><td colspan="6" style="color:#a7b1c0;">부족분이 있는 지표가 없습니다.</td></tr>';
    renderTable2();
    renderSec3();
    renderSec4();
  }

  function topGaps(limit){
    return indicators.map(function(r){ return { cd:r.cate_cd, nm:r.cate_nm, fg:r.cate_fg, w:n(r.stdweig), got:n(r.weigval), gap:n(r.stdweig)-n(r.weigval) }; })
                     .filter(function(x){ return x.gap>0.0001; }).sort(function(a,b){ return b.gap-a.gap; }).slice(0, limit||99);
  }

  // Ⅲ 지표별 분석 내용 — 지표별 자동 분석문 + 편집 개선방향(저장 문구 override 는 loadSavedTexts 가 재적용)
  function renderSec3(){
    var order=['10','21','22'], html='';
    order.forEach(function(fg){
      var rows=indicators.filter(function(r){ return r.cate_fg===fg; });
      if(!rows.length) return;
      html += '<div class="er-grplabel">'+grpNm(fg)+'</div>';
      rows.forEach(function(r){
        var w=n(r.stdweig), got=n(r.weigval), gap=w-got, cd=esc(r.cate_cd);
        var full = gap<=0.0001;
        var auto = '현황값 '+esc(fnum(r.cal_val))+' · 표준화 '+(r.s_score?n(r.s_score)+'구간':'-')+' · 가중치 '+fnum(w)+'점 중 '+f1(got)+'점 산정.'+(full?' 현재 최고 수준으로 유지.':'');
        html += '<div class="er-ind">'
              +   '<div class="er-indh"><span class="er-indnm">'+esc(r.cate_nm)+'</span><span class="er-indsc">'+f1(got)+' / '+fnum(w)+'점</span></div>'
              +   '<p class="er-ana er-editable" data-key="ana_'+cd+'"><span class="er-mk">분석</span>'+auto+'</p>'
              +   (full? '' : '<p class="er-plan er-editable" data-key="plan_'+cd+'"><span class="er-mk">개선</span>개선 방향을 입력하세요. (기록·실시 절차 점검, 다음 구간 목표 등)</p>')
              + '</div>';
      });
    });
    el('er-sec3Body').innerHTML = html;
  }

  // Ⅳ 우선 개선지표별 권고사항 — 부족분 상위 지표 자동 블록 + 편집영역
  function renderSec4(){
    var top = topGaps(6), html='';
    if(!top.length){ el('er-sec4Body').innerHTML = '<div class="er-fn">부족분이 있는 지표가 없습니다.</div>'; return; }
    top.forEach(function(x,i){
      var cd=esc(x.cd), isTop=(i<2);
      html += '<div class="er-rec'+(isTop?' er-top':'')+'">'
            +   '<div class="er-rech">'+(i+1)+'. '+esc(x.nm)+' <span class="er-w">· 가중치 '+fnum(x.w)+' · 부족분 '+f1(x.gap)+(isTop?' · 최우선':'')+'</span></div>'
            +   '<div class="er-recrow"><span class="er-lb">현황</span><span class="er-num">'+f1(x.got)+'점 / '+fnum(x.w)+'점</span> ('+areaNm(x.fg)+'지표)</div>'
            +   '<div class="er-recrow er-editable" data-key="recdir_'+cd+'"><span class="er-lb">개선방향</span>개선 방향과 목표 구간을 입력하세요.</div>'
            + '</div>';
    });
    el('er-sec4Body').innerHTML = html;
  }

  function renderTable2(){
    var order=['10','21','22'], html='';
    order.forEach(function(fg){
      var rows=indicators.filter(function(r){ return r.cate_fg===fg; });
      if(!rows.length) return;
      html += '<tr class="er-grp"><td colspan="7">'+grpNm(fg)+'</td></tr>';
      var sw=0,gw=0;
      rows.forEach(function(r){
        var w=n(r.stdweig), got=n(r.weigval), gap=w-got, rate=w>0?Math.round(got/w*100):0;
        sw+=w; gw+=got;
        var gapTd = gap>0.0001? '<td class="er-b-bad er-num">'+f1(gap)+'</td>' : '<td class="er-zero er-num">0</td>';
        var rateTd = rate>=100? '<td class="er-r100 er-num">100%</td>' : '<td class="er-num">'+rate+'%</td>';
        html += '<tr><td class="er-l">'+esc(r.cate_nm)+'</td><td class="er-num">'+fnum(w)+'</td><td class="er-num">'+esc(fnum(r.cal_val))+'</td><td>'+(r.s_score?n(r.s_score)+'구간':'-')+'</td><td class="er-num">'+f1(got)+'</td>'+rateTd+gapTd+'</tr>';
      });
      var subGap=sw-gw;
      html += '<tr class="er-sub"><td class="er-l">'+grpNm(fg)+' 소계</td><td class="er-num">'+fnum(sw)+'</td><td></td><td></td><td class="er-num">'+f1(gw)+'</td><td class="er-num">'+(sw>0?Math.round(gw/sw*100):0)+'%</td><td class="er-b-bad er-num">'+f1(subGap)+'</td></tr>';
    });
    var totW=scores.struct+scores.care>0? indicators.reduce(function(a,r){return a+n(r.stdweig);},0):0;
    var totGot=scores.total, totGap=totW-totGot;
    html += '<tr class="er-tot"><td class="er-l">종합</td><td class="er-num">'+fnum(totW)+'</td><td></td><td></td><td class="er-num">'+f1(totGot)+'</td><td class="er-num">'+(totW>0?Math.round(totGot/totW*100):0)+'%</td><td class="er-b-bad er-num">'+f1(totGap)+'</td></tr>';
    el('er-tbl2Body').innerHTML = html;
  }

  // ===== 저장된 문구/상태 로드 =====
  function loadSavedTexts(){
    jQuery.ajax({ url: ctx+'/main/loadEvalReport.do', type:'POST', dataType:'json',
      data:{ hospCd:hospCd, evalYm:curYm },
      success:function(res){
        var mst = res && res.mst;
        var texts = (res && res.texts) || [];
        // 저장 문구 override 적용
        var map={}; texts.forEach(function(t){ map[t.sectkey]=t.content; });
        editables().forEach(function(e){ var k=e.getAttribute('data-key'); if(map[k]!=null) e.innerHTML=map[k]; });
        setStatus(mst && mst.status ? mst.status : 'DRAFT');
        pdfPath = (mst && mst.pdfpath) ? String(mst.pdfpath) : '';
        updatePdfUi();
        editables().forEach(function(e){ e.contentEditable='false'; });
        editing=false; el('evalReport').classList.remove('er-editmode');
        if(isWinner){ var b=el('er-btnEdit'); b.textContent='✏️ 편집 켜기'; b.classList.remove('er-on'); }
      },
      error:function(){ setStatus('DRAFT'); }
    });
  }

  function collectTexts(){
    var arr=[]; editables().forEach(function(e){ arr.push({ sectKey:e.getAttribute('data-key'), content:e.innerHTML }); }); return arr;
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
  function updatePdfUi(){
    var has = !!pdfPath;
    var dlUrl = has ? (ctx+'/sftp/download.do?filePath='+encodeURIComponent(pdfPath)) : '#';
    var v=el('er-pdfView'); v.style.display = has?'':'none'; v.href=dlUrl;
    if(isWinner){
      el('er-btnPdfDel').style.display = has?'':'none';
      el('er-btnPdf').textContent = has? '📎 PDF 교체' : '📎 PDF 첨부';
    }
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
    jQuery.ajax({ url: ctx+'/main/uploadEvalReportPdf.do', type:'POST', data:fd,
      processData:false, contentType:false, dataType:'json',
      success:function(res){
        if(res && res.result==='OK'){ pdfPath=res.pdfPath||''; updatePdfUi(); toast('PDF가 첨부되었습니다. 거래처에는 이 파일이 우선 제공됩니다.'); }
        else toast('첨부 실패: '+((res&&res.message)||''));
      },
      error:function(){ toast('PDF 업로드 중 오류가 발생했습니다.'); }
    });
  });

  window.erDelPdf = function(){
    if(approved){ toast('승인된 보고서는 변경할 수 없습니다. 승인 취소 후 해제하세요.'); return; }
    if(!confirm('첨부된 PDF 연결을 해제할까요? (파일 자체는 파일서버에 남습니다)')) return;
    jQuery.ajax({ url: ctx+'/main/deleteEvalReportPdf.do', type:'POST', contentType:'application/json', dataType:'json',
      data: JSON.stringify({ hospCd:hospCd, evalYm:curYm }),
      success:function(res){
        if(res && res.result==='OK'){ pdfPath=''; updatePdfUi(); toast('첨부가 해제되었습니다.'); }
        else toast('해제 실패: '+((res&&res.message)||''));
      },
      error:function(){ toast('해제 중 오류가 발생했습니다.'); }
    });
  };

  // 최초 진입 시 자동 조회
  try {
    if(hospCd){ erLoad(); }
    else { showErr('병원 정보를 찾지 못했습니다. 위너넷은 상단 병원검색으로 병원을 선택한 뒤 이용하세요.'); }
  } catch(e){ showErr((e&&e.message)||e); }
});
</script>
