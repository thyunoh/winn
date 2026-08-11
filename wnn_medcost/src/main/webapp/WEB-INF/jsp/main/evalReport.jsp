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
<%-- ★ 이 스크립트는 반드시 본문 markup 보다 '먼저' 와야 한다(2026-08-03).
     아래쪽 초기화 스크립트에서 er-pdfonly 를 붙이면 브라우저가 이미 본문을 한 번 그린 뒤라
     거래처 화면에 편집화면(본문)이 번쩍 스쳤다 사라진다. 여기서 첫 페인트 전에 붙여 깜박임을 없앤다.
     정본=승인 PDF 기준이라 거래처는 본문 화면 자체를 보지 않는다. --%>
<script>
  (function(){
    try{
      var m=document.cookie.match(/(?:^|;\s*)s_wnn_yn=([^;]*)/);
      var wnn=(m?decodeURIComponent(m[1]):'');
      if(wnn!=='Y'){ document.getElementById('evalReport').classList.add('er-hospview','er-pdfonly'); }
    }catch(e){}
  })();
</script>
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
  /* 아이콘 축소 — 상자(width/height)만 줄이면 안 된다.
     swal2 아이콘은 상자만 5em(=80px)이고 내부(체크선·X선·원호)는 전부 em 좌표라
     상자를 44px 로 줄여도 선은 80px 기준 자리에 그대로 그려진다. 그래서 원 밖으로
     삐져나오고 두 선이 서로 겹쳐 ✕ 처럼 보였다(2026-07-22 '승인 완료' 체크표시 깨짐).
     라이브러리가 주는 --swal2-icon-zoom 으로 내부까지 통째로 줄인다. 80px × .55 = 44px. */
  .swal2-popup.er-swal .swal2-icon{ --swal2-icon-zoom:.55; margin:6px auto 12px !important; }
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
  /* 위너넷용 안내문만 숨긴다 — 거래처에게 필요한 두 가지(PDF 배너 · 거래처 안내문)는 예외.
     ★ 예외를 빼먹으면 본문(er-pdfonly)까지 감춘 뒤 화면이 통째로 비어 버린다(2026-08-03 수정). */
  #evalReport.er-hospview .er-notice:not(#er-pdfBanner):not(.er-hospmsg){ display:none !important; }
  /* 거래처 = '승인 시점 PDF'만 제공(2026-08-03 확정). 본문 화면은 열 때마다 최신 재계산이라
     승인본과 달라질 수 있어 아예 감춘다 → 남는 건 PDF 보기·다운로드 배너와 안내문뿐. */
  #evalReport.er-pdfonly .er-doc{ display:none !important; }
  #evalReport.er-pdfonly #er-notice.er-hospmsg{ display:block !important; }
  /* 뷰어가 화면을 꽉 채우므로 배너는 한 줄로 얇게(다운로드 링크만 남기는 용도) */
  /* PDF 가 화면에 그대로 펼쳐지므로 안내 배너는 뺀다(2026-08-03 요청) — '화면에서 보기'는 이미 보고 있고,
     다운로드·인쇄는 PDF 뷰어 자체 툴바(우측 ⬇·🖨)에 있어 중복이다. 뷰어가 화면을 더 넓게 쓴다. */
  #evalReport.er-pdfonly #er-pdfBanner{ display:none !important; }
  #evalReport.er-pdfonly .er-doconly{ display:none !important; }   /* 본문이 없으니 배율·미리보기도 숨김 */
  /* 거래처 인라인 PDF 뷰어 — 화면 높이를 채워 바로 읽히게(모달·클릭 없이) */
  /* 폭은 width:100% 대신 '좌우 여백'으로 잡는다 — 100% + 테두리·부모 패딩이면 가로가 넘쳐
     화면이 옆으로 밀리고 좌측 메뉴 스크롤바가 문서 위로 끼어 보인다(2026-08-03). */
  #evalReport.er-pdfonly{ overflow-x:hidden; }
  #er-hospPdfWrap{ margin:6px 10px 0; }
  /* 배너를 뺐으니 뷰어가 툴바 바로 아래부터 시작한다 — 높이도 그만큼 되찾는다 */
  #evalReport.er-pdfonly #er-hospPdfFrame{ height:calc(100vh - 96px); }
  #er-hospPdfMsg{ padding:14px; text-align:center; color:#5b6b7f; font-size:14px; }
  #er-hospPdfFrame{ display:none; width:100%; box-sizing:border-box; height:calc(100vh - 130px);
                    min-height:560px; border:1px solid #d8dfe8; background:#fff; }
  @media print{ #er-hospPdfWrap{ display:none !important; } }

  #evalReport .er-notice{ max-width:880px; margin:16px auto 0; padding:12px 16px; border-radius:10px; background:var(--er-navytint);
    border:1px solid #cfe0f4; color:var(--er-navy); font-size:12.5px; line-height:1.6; }

  /* ===== 운영사용(TBL_HOSPCONT_MST.NOR_YN, 적정성평가 계약 기준) =====
     NOR_YN='Y'(사용운영만 하는 병원)이면 마지막 장(Ⅳ 로드맵 + 총평)을 통째로 감춘다.
     위너넷 관리자 화면에도 동일 적용(사용자 확정) — 관리자가 만든 인쇄·PDF에도 안 들어가게.
     인쇄에도 같은 규칙이 그대로 적용되고, PDF 생성은 숨은 .er-page 를 건너뛴다(erPdfGenPreview). */
  #evalReport.er-norec #er-page4{ display:none !important; }
  @media print{ #evalReport.er-norec #er-page4{ display:none !important; } }
  /* '{병원명} — 사용운영만 하는 병원' 배지 — 위너넷에게만(er-wnnonly), 눈에 띄게 깜박임. 인쇄·PDF에는 안 나감 */
  #evalReport .er-usebadge{ display:none; align-items:center; gap:5px; padding:4px 10px; border-radius:999px;
    background:#fff3cd; border:1px solid #f0c36d; color:#8a5a00; font-size:12px; font-weight:800; white-space:nowrap;
    animation:erUseBlink 2.2s ease-in-out infinite; }
  #evalReport .er-usebadge.er-on{ display:inline-flex; }
  /* 깜박임은 약하게 — 켜짐/꺼짐(steps)이 아니라 천천히 옅어졌다 돌아오는 정도(2026-07-29 사용자 요청) */
  @keyframes erUseBlink{ 50%{ opacity:.62; } }
  @media print{ #evalReport .er-usebadge{ display:none !important; } }
  #evalReport.er-pdfcap .er-usebadge{ display:none !important; }

  /* 지면 */
  #evalReport .er-doc{ padding:22px 14px 40px; display:flex; flex-direction:column; align-items:center; gap:20px; }
  #evalReport .er-page{ width:880px; max-width:100%; background:var(--er-paper); box-shadow:0 6px 26px rgba(28,45,72,.14);
    border-radius:6px; padding:46px 50px; }
  @media (max-width:720px){ #evalReport .er-page{ padding:28px 18px; } }

  /* ===== A4 자동 페이지 분할(WYSIWYG) — 화면 = PDF. 원본 섹션(.er-srcpage)은 숨기고 A4 실측 페이지를 생성 ===== */
  #evalReport .er-autopage{ display:none; }
  #evalReport.er-paged .er-srcpage{ display:none !important; }
  #evalReport.er-paged .er-autopage{ display:block; width:210mm; height:297mm; box-sizing:border-box; position:relative;
    background:var(--er-paper); box-shadow:0 6px 26px rgba(28,45,72,.14); border-radius:4px; margin:0 auto;
    padding:14mm 15mm; overflow:hidden; }
  /* 장 번호표(보기 모드) — 각 A4 오른쪽 위 'N장'. 인쇄·PDF캡처·편집(화면밖 복제) 어디에도 안 찍힘 */
  .er-pgnum{ position:absolute; top:5mm; right:7mm; font-size:11px; font-weight:800; color:#7c8a99;
             background:#eef2f7; border:1px solid #dbe3ec; border-radius:999px; padding:1px 9px; pointer-events:none; }
  @media print{ .er-pgnum{ display:none !important; } }
  body.er-capturing .er-pgnum{ display:none !important; }
  #evalReport.er-preview .er-pgnum{ display:none !important; }   /* 인쇄 미리보기 화면에서도 숨김 */
  #evalReport.er-paged .er-autobody{ overflow:hidden; }
  /* A4 복제본 안의 의무기록 그림 — 세로가 페이지를 넘지 않게 상한을 둔다.
     넘치면 아래가 잘려 사라지므로, 폭 축소(erShrinkToFit)와 함께 이중으로 막는다 */
  #evalReport.er-paged .er-autobody img{ max-height:250mm; object-fit:contain; }
  /* 그림 사이 여백을 줄여 한 장에 더 담기게(빈 공간 낭비 방지) */
  #evalReport.er-paged .er-autobody .er-mrbody img{ margin-bottom:6px; }
  #evalReport.er-paged .er-autopage.er-cover-page{ display:flex; flex-direction:column; align-items:center; justify-content:center; text-align:center; }
  #evalReport.er-paged .er-doc{ gap:16px; }
  #evalReport.er-paged .er-autopage .er-sec{ margin-top:0; }
  /* 같은 장에 이어지는 섹션 헤더는 넉넉한 간격, 장 맨 위 헤더는 간격 없음 */
  #evalReport.er-paged .er-autobody > .er-eyebrow{ margin-top:34px; }
  #evalReport.er-paged .er-autobody > .er-eyebrow:first-child{ margin-top:0; }
  /* ★편집 중(2026-08-03): 화면엔 원본(자연 흐름)을 그대로 두고 A4 복제본은 화면 밖에서 레이아웃만 유지 —
       복제본에서 계산한 장 경계를 원본 위에 'N장 시작' 표지로 띄우기 위함(_erGuideSync) */
  #evalReport.er-paged.er-editmode .er-srcpage{ display:block !important; }
  #evalReport.er-paged.er-editmode .er-autopage{ position:absolute !important; left:-99999px !important; top:0 !important;
    visibility:hidden !important; box-shadow:none !important; }
  /* 새 장 지정 줄의 '전체 폭 점선'(2026-08-03) — 요소 테두리로는 좁은 라벨(결과지표 등)에서 점선이
     안 보여서, 페이지 폭만큼 오버레이로 그린다. 알약과 함께 생성·제거(_mrSyncPgMarks) */
  .er-pgdash{ position:fixed; z-index:1388; height:0; border-top:2px dashed #c8342f; pointer-events:none; opacity:.9; }
  @media print{ .er-pgdash{ display:none !important; } }
  body.er-capturing .er-pgdash{ display:none !important; }
  /* 장 경계 표지(파란 알약) — 편집 중에만. 저장·인쇄에 안 섞인다(body 직속 fixed) */
  .er-pgline{ position:fixed; z-index:1385; background:#1746a2; color:#fff; font-size:11px; font-weight:800;
              padding:2px 9px; border-radius:999px; box-shadow:0 2px 6px rgba(0,0,0,.25);
              pointer-events:none; white-space:nowrap; opacity:.92; }
  @media print{ .er-pgline{ display:none !important; } }
  body.er-capturing .er-pgline{ display:none !important; }
  /* '⤒ 여기부터 새 장' 알약의 ✕ 취소(2026-08-03) — 알약을 눌러 바로 해제.
     기본 정의(아래쪽)가 pointer-events:none 이라 !important 로 눌러 쓴다 */
  .er-pgmark{ pointer-events:auto !important; cursor:pointer; }
  .er-pgmark .x{ margin-left:6px; font-weight:900; opacity:.85; }
  .er-pgmark:hover{ background:#a72a25; }

  /* 편집 */
  #evalReport .er-editable{ outline:none; border-radius:4px; transition:.12s; }
  /* ===== Ⅵ. 의무기록 점검 결과 — 외부 문서 붙여넣기 영역 ===== */
  /* 편집용 UI(툴바)는 화면에서만 — 인쇄·PDF·미리보기에서는 감춘다 */
  #evalReport .er-noprint{ display:none; }
  #evalReport.er-editmode .er-noprint{ display:block; }
  #evalReport.er-preview .er-noprint{ display:none !important; }
  /* ※ display:flex 를 무조건 주면 안 된다 — 위 .er-noprint{display:none} 과 우선순위가 같은데
        이 규칙이 뒤에 있어 숨김을 항상 이겨서, 편집을 꺼도 툴바가 그대로 보였다(2026-07-22). */
  #evalReport .er-mrbar{ display:none; align-items:center; gap:8px; flex-wrap:wrap;
                         background:#f4f7fb; border:1px dashed #b9c9de; border-radius:8px; padding:8px 12px; margin-bottom:10px; }
  #evalReport.er-editmode .er-mrbar{ display:flex; }
  #evalReport.er-preview .er-mrbar{ display:none !important; }
  #evalReport .er-mrhint{ font-size:12px; color:#5b6b80; margin-right:auto; }
  #evalReport .er-zoom{ display:inline-flex; align-items:center; gap:2px; }
  #evalReport .er-zoom .er-btn{ padding:3px 8px; min-width:30px; }
  #evalReport .er-zoom .er-zoomlbl{ min-width:58px; font-variant-numeric:tabular-nums; }
  /* 붙인 내용 — 원본 서식(표·굵기·색)은 그대로 두고 폭만 넘치지 않게 한다 */
  #evalReport .er-mrbody{ min-height:60px; }
  #evalReport.er-editmode .er-mrbody{ min-height:120px; border:1px dashed #cfd8e6; border-radius:8px; padding:8px; }
  #evalReport .er-mrph{ padding:18px; text-align:center; color:#5b6b80; font-size:12.5px; line-height:1.9;
                        background:#f7fbff; border:1px dashed #b9c9de; border-radius:8px; margin-bottom:8px; }
  #evalReport .er-mrbody table{ max-width:100%; border-collapse:collapse; }
  #evalReport .er-mrbody img{ max-width:100%; height:auto; display:block; margin:0 auto 10px; }
  /* 그림 개별 크기조절 — 편집 중에만 클릭 대상임을 알린다 */
  #evalReport.er-editmode .er-mrbody img{ cursor:pointer; }
  #evalReport.er-editmode .er-mrbody img:hover{ outline:1px dashed #b9c9de; outline-offset:2px; }
  /* 선택 표시도 얇게 — 손잡이가 선 위에 얹히는 편집기 느낌 */
  #evalReport .er-mrbody img.er-imgsel{ outline:1.5px solid var(--er-navy); outline-offset:1px; }
  /* ⤓ 새 장에서 시작 — 인쇄·PDF에서 이 그림 앞에서 페이지를 끊는다 */
  #evalReport .er-mrbody img.er-pgbreak{ break-before:page; page-break-before:always; margin-top:14px; }
  /* 본문 블록(지표 제목·소제목·장 제목)에도 새 장 지정 가능(2026-08-03) — 편집 중 Alt+클릭 토글 */
  #evalReport .er-doc .er-pgbreak{ break-before:page; page-break-before:always; }
  #evalReport.er-editmode .er-doc .er-pgbreak:not(img){ border-top:2px dashed #c8342f; padding-top:6px; }
  @media print { #evalReport .er-doc .er-pgbreak:not(img){ border-top:none !important; padding-top:0 !important; } }
  /* '여기부터 새 장' 표지 알약 — 편집 중 er-pgbreak 그림 위에 띄워 눈으로 확인(2026-08-03 요청).
     body 직속(저장 대상인 mr_body 밖)이라 문서에 안 섞이고, 인쇄·캡처에서는 숨긴다. */
  .er-pgmark{ position:fixed; z-index:1390; background:#c8342f; color:#fff; font-size:11px; font-weight:800;
              padding:2px 9px; border-radius:999px; box-shadow:0 2px 6px rgba(0,0,0,.25);
              pointer-events:none; white-space:nowrap; }
  @media print{ .er-pgmark{ display:none !important; } }
  body.er-capturing .er-pgmark{ display:none !important; }
  /* 편집 중에는 어디서 끊기는지 점선으로 보여준다(인쇄에는 안 나감) */
  #evalReport.er-editmode .er-mrbody img.er-pgbreak{ border-top:2px dashed #c8342f; padding-top:10px; }
  /* ★편집을 켠 채 브라우저 메뉴(Ctrl+P)로 바로 인쇄하는 경우까지 방어 — er-editmode 규칙이
       특이도가 더 높아 아래 무력화가 지려면 editmode 셀렉터로도 한 번 더 꺼야 한다(2026-08-03 PDF 점선 유출) */
  @media print { #evalReport .er-mrbody img.er-pgbreak,
                 #evalReport.er-editmode .er-mrbody img.er-pgbreak{ border-top:none !important; padding-top:0 !important; } }
  #evalReport .er-imgbar{ position:fixed; z-index:1400; transform:translateX(-50%);
                          display:flex; gap:3px; align-items:center; background:#fff;
                          border:1px solid var(--er-line); border-radius:8px; padding:4px 6px;
                          box-shadow:0 6px 20px rgba(31,42,55,.22); }
  #evalReport .er-imgbar .er-btn{ padding:3px 8px; min-width:30px; }
  #evalReport .er-imgbar .er-zoomlbl{ min-width:52px; text-align:center; font-variant-numeric:tabular-nums; }
  /* 크기조절 손잡이 3개 — 모서리(비율유지) · 오른쪽(가로) · 아래(세로).
     문서 편집기(구글독스·워드)와 같은 작고 단정한 흰 사각 점.
     예전엔 22px 남색 덩어리 + 흰 테두리라 표 위에 얹히면 투박했다(2026-07-22). */
  .er-hnd{ position:fixed; z-index:1600; box-sizing:border-box; width:10px; height:10px;
           background:#fff; border:1.5px solid var(--er-navy); border-radius:2px;
           box-shadow:0 1px 3px rgba(31,56,100,.30);
           transition:transform .12s ease, background .12s ease; }
  /* 보기는 10px 로 작게, 잡히는 범위는 넉넉하게 — 작아서 못 잡는 일이 없도록 */
  .er-hnd::before{ content:''; position:absolute; inset:-7px; }
  .er-hnd:hover, .er-hnd:active{ background:var(--er-navy); transform:scale(1.3); }
  #er-imgHandle { cursor:nwse-resize; }
  #er-imgHandleW{ cursor:ew-resize; }
  #er-imgHandleL{ cursor:ew-resize; }
  #er-imgHandleH{ cursor:ns-resize; }
  /* 편집 UI는 인쇄·PDF캡처에 절대 찍히면 안 된다 — 모든 경로를 막는다.
     ※ er-noprint 는 평소엔 숨지만 er-editmode 에서 display:block 으로 되살아난다.
        편집을 켠 채로 캡처·인쇄되면 그게 그대로 찍히므로 여기서 다시 눌러 둔다. */
  @media print { .er-hnd, #er-imgBar, #er-cropModal { display:none !important; }
                 #evalReport .er-noprint { display:none !important; } }
  body.er-capturing #evalReport .er-noprint { display:none !important; }
  #evalReport.er-pdfcap ~ .er-hnd, #evalReport.er-pdfcap ~ #er-imgBar { display:none !important; }
  body.er-capturing .er-hnd, body.er-capturing #er-imgBar, body.er-capturing #er-cropModal { display:none !important; }
  body.er-capturing #evalReport .er-mrbody img.er-imgsel{ outline:none !important; }
  body.er-capturing #evalReport.er-editmode .er-mrbody{ border:none !important; padding:0 !important; }
  #evalReport .er-mrbody td, #evalReport .er-mrbody th{ word-break:break-word; }
  /* ↔ 폭맞춤 — 아래한글 표는 고정폭이라 붙이면 오른쪽이 비는데, 켜면 본문 폭까지 늘린다 */
  #evalReport .er-mrbody.er-mrfit table{ width:100% !important; }
  #evalReport .er-mrbody.er-mrfit img{ width:100%; }
  #evalReport .er-btn.er-on{ background:var(--er-navy); color:#fff; border-color:var(--er-navy); }
  /* 잘라오기 창 */
  /* 잘라오기 창 — 배경을 덮지 않는 '떠 있는 창'. 제목줄을 잡고 끌어 옮긴다.
     듀얼모니터·보고서와 나란히 놓고 보려면 위치를 바꿀 수 있어야 한다(2026-07-22 요청). */
  #er-cropModal{ position:fixed; inset:auto; z-index:1500; background:none; display:none; padding:0; }
  #er-cropModal.er-open{ display:block; }
  #er-cropModal .er-modal-box{ position:fixed; width:min(980px,88vw); height:min(820px,86vh); margin:0;
                               box-shadow:0 18px 60px rgba(0,0,0,.45); border:1px solid #b9c9de; }
  /* 버튼이 많아 한 줄에 안 들어가면 잘려서 '창으로 빼기' 가 안 보인다 → 줄바꿈 허용 */
  #er-cropModal .er-modal-head{ cursor:move; user-select:none; flex-wrap:wrap; padding:9px 12px; }
  #er-cropModal .er-modal-head .er-btn{ cursor:pointer; padding:4px 9px; font-size:12px; }
  #er-cropModal .er-modal-actions{ flex-wrap:wrap; gap:5px; }
  /* 하단 상태줄 — 안내 + 가끔 쓰는 기능(전체 넣기) */
  #er-cropModal .er-cropfoot{ flex:0 0 auto; display:flex; align-items:center; gap:10px;
                              padding:7px 12px; background:#f4f7fb; border-top:1px solid var(--er-line); }
  #er-cropModal .er-crophint{ margin-right:auto; font-size:12px; color:#5b6b80; }
  #er-cropModal .er-cropfoot .er-btn{ padding:4px 9px; font-size:12px; }
  #er-cropTitle{ font-size:12.5px; max-width:100%; overflow:hidden; text-overflow:ellipsis; white-space:nowrap; }
  #evalReport .er-cropbody{ overflow:auto; background:#3a3f45; padding:14px; display:block; text-align:center; }
  #evalReport .er-cropwrap{ position:relative; display:inline-block; vertical-align:top; }
  #evalReport .er-cropwrap canvas{ display:block; box-shadow:0 4px 18px rgba(0,0,0,.45);
                                   cursor:crosshair; user-select:none; -webkit-user-drag:none; background:#fff; }
  #evalReport .er-croprect{ position:absolute; border:2px dashed #ffd166; background:rgba(255,209,102,.18); pointer-events:none; }
  /* 편집 모드: 연한 배경 + 어두운 글자 강제(color) — 목표 뱃지 등 흰 글자 영역이 안 보이던 문제 방지 */
  #evalReport.er-editmode .er-editable{ box-shadow:inset 0 0 0 1px #bcd0ea; background:#f7fbff; color:var(--er-ink); cursor:text; }
  #evalReport.er-editmode .er-editable:focus{ box-shadow:inset 0 0 0 2px var(--er-navy2); background:#fff; color:var(--er-ink); }
  /* Ⅳ 권고사항의 개선방향(recdir_*)은 편집 대상이 아니다(2026-07-29) — 편집모드에서도 편집영역처럼 보이지 않게 */
  #evalReport.er-editmode .er-editable[data-key^="recdir_"]{ box-shadow:none; background:transparent; cursor:default; }
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
  /* 위 여백 확보(2026-08-03 요청, "조금만 밑으로" 재조정 28→42px) — 목표등급 줄과 유의사항 박스 사이 */
  #evalReport .er-cover .er-cover-noteswrap{ width:725px; max-width:100%; margin:42px auto 0; }
  #evalReport .er-cover .er-cover-notes{ width:100%; margin:0; border:1.5px solid #4a5568; border-radius:2px;
    padding:16px 20px 18px; text-align:left; font-size:14px; font-weight:400; line-height:1.95; letter-spacing:0.3px; color:var(--er-ink); }
  #evalReport .er-cover .er-cnotes-title{ font-weight:900; font-size:16px; color:#111; margin-bottom:8px; }
  #evalReport .er-cover .er-cnotes-list li b{ font-weight:900; font-size:15px; color:#111; }
  #evalReport .er-cover .er-cnotes-list{ list-style:none; margin:0 0 0 6px; padding:0; }
  /* 항목 사이 한 칸 간격(2026-08-03 요청) — <br> 를 걷어내니 다닥다닥 붙어 보여 구분마다 띄운다 */
  #evalReport .er-cover .er-cnotes-list li{ position:relative; padding-left:15px; margin-bottom:11px; }
  #evalReport .er-cover .er-cnotes-list li:last-child{ margin-bottom:0; }
  #evalReport .er-cover .er-cnotes-box{ margin:18px auto 0; max-width:760px;
    text-align:center; font-weight:900; font-size:13px; color:#111; line-height:1.8; }
  #evalReport .er-cover .er-cover-datetop{ margin:14px 0 4px; text-align:right;
    font-size:12.5px; font-weight:700; color:var(--er-soft); }
  #evalReport .er-cover .er-cover-logo{ margin-top:24px; }
  #evalReport .er-cover .er-cover-logo img{ height:30px; }
  #evalReport .er-cover .er-cnotes-list li::before{ content:'▪'; position:absolute; left:0; top:0; }
  #evalReport .er-cover .er-cover-foot{ margin-top:26px; font-size:12px; color:var(--er-soft); line-height:1.9; }
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
  /* Ⅱ 표 열폭 — '부족점검' 열 제거(7컬럼)로 남은 폭을 전부 '지표명' 이 흡수해 표가 우측 끝까지 꽉 차게.
     table-layout:fixed 라 thead 의 th 폭이 열폭을 결정(tbody 는 rowspan/colspan 이라 nth-child 로 잡으면 어긋남).
     지표명(2번째)만 폭 미지정 = 나머지 폭 전부 차지. 폭 조정 시 아래 6개 px 만 손대면 된다. */
  #evalReport table.er-tbl2{ table-layout:fixed; width:100%; }
  #evalReport table.er-tbl2 thead th:nth-child(1){ width:46px; }
  #evalReport table.er-tbl2 thead th:nth-child(3){ width:78px; }
  #evalReport table.er-tbl2 thead th:nth-child(4){ width:96px; }
  #evalReport table.er-tbl2 thead th:nth-child(5){ width:110px; }
  #evalReport table.er-tbl2 thead th:nth-child(6){ width:74px; }
  #evalReport table.er-tbl2 thead th:nth-child(7){ width:86px; }
  #evalReport table.er-tbl2 td.er-l{ word-break:keep-all; }   /* 긴 지표명은 어절 단위 줄바꿈 */
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
  /* 평가기간 누적 실적(2026-08-10) — 당월 문장과 <같은 줄이되 구분>되게.
     2026-08-11 검수: 편집 없이 자동 산출되는 고정 문장이라 당월 문장과 확실히 구분되게 '*' + 파랑 + 굵게. */
  #evalReport .er-cum{ display:inline-block; margin-top:2px; color:var(--er-navy2); font-weight:700; }
  #evalReport .er-def{ color:#7c8798; font-size:11.5px; margin:4px 0 0 13px; }
  #evalReport .er-grplabel.er-g10{ background:var(--er-navy); }
  #evalReport .er-grplabel.er-g21{ background:#1f7a66; }
  #evalReport .er-grplabel.er-g22{ background:#6b3fa0; }
  #evalReport .er-ana{ font-size:12.5px; margin:0; }
  #evalReport .er-ana .er-mk{ color:var(--er-navy2); font-weight:800; margin-right:4px; }
  #evalReport .er-plan{ font-size:12.5px; margin:7px 0 0; color:var(--er-good); font-weight:700; line-height:160%; }   /* 줄간격 160% (2026-07-30 요청) */
  #evalReport .er-plan .er-mk{ color:var(--er-good); font-weight:800; margin-right:4px; }
  #evalReport .er-grplabel{ font-size:12px; font-weight:800; color:#fff; background:linear-gradient(135deg,var(--er-navy),var(--er-navy2)); display:inline-block; padding:4px 12px; border-radius:8px; margin:20px 0 4px; }
  #evalReport .er-rec{ border:1px solid var(--er-line); border-left:4px solid var(--er-navy2); border-radius:10px; padding:13px 16px; margin-top:11px; background:#fff; }
  #evalReport .er-rec.er-top{ border-left-color:var(--er-bad); background:linear-gradient(180deg,#fef7f6,#fff 60%); }
  #evalReport .er-rech{ font-size:13px; font-weight:800; margin-bottom:6px; }
  #evalReport .er-rech .er-w{ font-size:11px; font-weight:700; color:var(--er-soft); }
  #evalReport .er-recrow{ font-size:12.5px; margin:4px 0; }
  #evalReport .er-recrow .er-lb{ display:inline-block; min-width:62px; font-weight:800; color:var(--er-navy2); }
  #evalReport .er-recgoal{ margin-top:6px; padding-top:6px; border-top:1px dashed var(--er-line); font-size:12.5px; color:var(--er-good); font-weight:700; }
  /* Ⅲ 분석내용 안 '목표 :' 줄 — Ⅳ 권고 통합분(2026-08-03). er-recgoal 과 같은 모양 */
  #evalReport .er-indbody .er-goal{ margin:6px 0 0; padding-top:6px; border-top:1px dashed var(--er-line); font-size:12.5px; color:var(--er-good); font-weight:700; }
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
  /* z-index 1300→1700 (2026-08-03) — 새 장 알약(1390)·장 경계 표지(1385)·그림 조절바(1400)·손잡이(1600)가
     전부 fixed 라 모달 '위로' 뚫고 올라왔다(편집 중 PDF보기에 표시 겹침). 모달은 항상 최상위. */
  #evalReport .er-modal{ position:fixed; inset:0; z-index:1700; background:rgba(16,22,29,.55); display:flex; align-items:center; justify-content:center; padding:20px; }
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
    /* ★표 행이 페이지 경계에서 반 토막 나는 것 방지 (2026-08-03)
         종전에는 선택자가 `table.er-tbl` 이라 **보고서가 직접 만든 표 5개에만** 걸렸다.
         Ⅵ 의무기록에 아래한글·워드에서 복사해 붙인 표에는 er-tbl 클래스가 없어 무방비였고,
         그래서 대상자 한 행의 윗줄만 앞장에 남고 나머지가 뒷장으로 넘어가 읽을 수 없었다.
         → 선택자를 보고서 안 '모든 표'로 넓힌다. 표 자체는 계속 쪼개져야 하므로(여러 장짜리 표)
           table 은 break-inside:auto, 자르지 말아야 할 최소 단위인 tr 에만 avoid 를 건다.
         ※ thead/tfoot 이 있는 표만 머리행이 장마다 반복된다. 워드·아래한글에서 붙인 표는
           보통 thead 없이 tr 만 오므로 머리행 반복은 안 된다(행 잘림은 이 규칙으로 해결됨). */
    #evalReport table{ page-break-inside:auto; break-inside:auto; }
    #evalReport table thead{ display:table-header-group; }
    #evalReport table tfoot{ display:table-footer-group; }
    #evalReport table tr{ page-break-inside:avoid; break-inside:avoid; }
    #evalReport table td, #evalReport table th{ page-break-inside:avoid; break-inside:avoid; }

    /* ★★인쇄 컨테이너를 flex 에서 block 으로 (2026-08-03) — '⤓ 새 장에서'가 안 듣던 진짜 원인.
         .er-doc 는 화면 가운데 정렬 때문에 display:flex 인데(위 149行), 인쇄 CSS 에서 padding·gap 만
         고치고 flex 는 그대로 뒀다. 브라우저는 **flex 컨테이너 안에서는 페이지 나눔 지정을 무시**한다
         (break-before/after/inside 전부). 그래서 img.er-pgbreak 의 break-before:page 도,
         Ⅲ 그룹라벨의 break-before:page 도, 카드의 page-break-inside:avoid 도 다 무시되고 있었다.
         인쇄에서는 .er-page 가 width:100% 라 가운데 정렬이 필요 없으므로 block 으로 되돌리면 된다. */
    #evalReport .er-doc{ display:block !important; }

    /* ★붙인 그림이 한 장보다 길면 페이지 경계에서 그대로 썰린다(2026-08-03 사용자 확인).
         화면용 규칙(199行)은 max-width 만 있고 세로 제한이 없다. 높이 제한 로직(erShrinkToFit·
         .er-autobody img{max-height:250mm})은 A4 자동분할(PAGE_ON) 전용이라 지금은 동작하지 않는다.
         → 인쇄에서만 한 장 높이로 상한을 둔다. max-width 와 함께 걸려 비율은 그대로 유지된다.
         ※ 아주 긴 표 그림은 글씨가 작아지므로, 그런 경우는 표를 나눠 캡처해 각각 붙이고
           '⤓ 새 장에서'를 지정하는 편이 읽기 좋다. */
    #evalReport .er-mrbody img{ max-height:250mm; break-inside:avoid; page-break-inside:avoid; }
    #evalReport .er-indhead{ page-break-after:avoid; }
    #evalReport .er-eyebrow{ page-break-after:avoid; }
    /* 구조지표/과정지표/결과지표 그룹은 각각 새 페이지에서 시작 (첫 그룹은 Ⅲ 헤더와 같은 장) */
    #evalReport #er-sec3Body .er-grplabel{ break-before:page; page-break-before:always; }
    #evalReport #er-sec3Body .er-grplabel:first-child{ break-before:auto; page-break-before:auto; }
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
    <%-- 사용운영만 하는 병원 — 적정성평가 계약의 NOR_YN='Y' (=Ⅳ 이하 비공개 대상)일 때 켜짐.
         위너넷 화면에만 보이는 표시(er-wnnonly). 문구·표시 여부는 JS erApplyNorYn 에서 확정. --%>
    <span class="er-usebadge er-wnnonly" id="er-useBadge"
          title="계약정보의 '운영사용'이 체크된 병원입니다. 이 보고서는 Ⅳ 목표등급 달성 로드맵 이하(총평 포함)가 화면·인쇄·PDF 어디에도 나오지 않습니다."></span>

    <span class="er-sp"></span>

    <!-- 그룹3: 상태 + 진행순서대로 [①편집 → ②저장 → ③승인 → ④PDF첨부]. PDF첨부는 승인 후(공개본=PDF 일치). -->
    <span id="er-statusBadge" class="er-status er-draft"><span class="er-sdot"></span><span id="er-statusText">작성중</span></span>
    <%-- 화면 코드 버전 — 브라우저가 옛 캐시를 보는지 즉시 판별용(지원 문의 시 이 값을 알려주세요) --%>
    <span id="er-ver" style="font-size:10px;color:#b7c0cc;align-self:center;" title="화면 코드 버전">v0722i</span>
    <!-- 이력 열람 진입 시: 어느 이력을 보는지(유형·작성자·시각) 표시 -->
    <span id="er-hstInfo" class="er-hstinfo" style="display:none;"></span>
    <span id="er-editTools" class="er-group">
      <button id="er-btnEdit" class="er-btn" onclick="erToggleEdit()" title="① 문구를 고치려면 편집을 켜세요 (Ⅴ 의무기록 장도 이때 나타납니다)">✏️ 편집</button>
      <!-- '🩺 의무기록' 버튼은 뺐다(2026-07-22 요청) — 누르면 탐색기가 강제로 열려,
           파일은 안 열고 넣어둔 그림만 손보려 할 때 걸리적거렸다. 편집켜기로 창구를 하나로 모은다:
           편집을 켜면 erMrToggleSec 이 Ⅵ 장을 띄우고, 탐색기는 그 장의 [📂 탐색기 열기]로만 연다. -->
      <button id="er-btnSave" class="er-btn er-primary" onclick="erSave()" title="② 수정한 문구·점수를 저장합니다(DB)">💾 저장</button>
      <button id="er-btnApprove" class="er-btn er-good" onclick="erApprove()" title="③ 승인 — 그 시점 수치가 동결되고 거래처에 공개됩니다. 승인 후 ④ PDF첨부가 가능합니다.">✔ 승인</button>
      <span class="er-divider"></span>
      <!-- ④ 첨부 PDF: 승인 후에만 활성. 첨부 전=[📎 PDF첨부] / 첨부 후 보기=[👁 PDF보기]. -->
      <input type="file" id="er-pdfFile" accept="application/pdf,.pdf" style="display:none;">
      <button id="er-btnPdf" class="er-btn" onclick="erPickPdf()" title="④ 승인 후 — 완성본 PDF를 첨부(화면 생성 또는 아래한글 완성본 업로드). 거래처엔 이 PDF가 우선 제공됩니다">📎 PDF첨부</button>
      <a id="er-pdfView" class="er-btn er-primary" style="display:none;" href="#" onclick="erPdfPreview(); return false;" title="첨부된 완성본 PDF 보기(교체는 모달 안 🔍검색)">👁 PDF보기</a>
      <%-- ⑤ 메일발송 — 첨부해 둔 PDF 를 그대로 붙여 병원에 보낸다. 위너넷만, 첨부가 있을 때만 노출(updatePdfUi) --%>
      <button id="er-btnMail" class="er-btn er-wnnonly" style="display:none;" onclick="erMailOpen()"
              title="⑤ 첨부된 PDF를 메일로 보냅니다. 받는 사람은 발송 창에서 입력합니다">✉ 메일발송</button>
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
    <%-- er-doconly = 본문 화면이 있어야 뜻이 있는 도구. 거래처(er-pdfonly, 본문 감춤)에서는 숨긴다. --%>
    <button class="er-btn er-doconly" style="padding:8px 7px;" onclick="erZoom(-1)" title="글자 작게">가−</button>
    <button class="er-btn er-doconly" id="er-zoomPct" onclick="erZoom(0)" title="클릭=100% 복원" style="min-width:44px; padding:8px 6px;">100%</button>
    <button class="er-btn er-doconly" style="padding:8px 7px;" onclick="erZoom(1)" title="글자 크게">가＋</button>
    <span class="er-divider er-doconly"></span>
    <!-- 미리보기 하나로 통일 — 미리보기 진입 시 상단바에 '🖨️ 인쇄' 가 있어 툴바 인쇄 버튼은 중복이라 제거(2026-07-20). -->
    <button class="er-btn er-doconly" onclick="erPreview()" title="인쇄 형태(A4)로 화면에서 확인 — 미리보기 상단의 🖨️ 인쇄(PDF저장)로 출력/PDF저장">👁 미리보기</button>
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

  <!-- [승인본 불일치 경고] 운영 기준(2026-08-03): 정본 = 승인 시점 PDF · 화면 = 최신 진단치.
       승인 후 수치가 달라지면 담당자가 먼저 알도록 여기 경고를 띄운다(같으면 안 뜸). -->
  <div class="er-notice" id="er-apprDiff" style="display:none; border-color:#f0c36d; background:#fff8e6; color:#8a5a00;"></div>

  <div class="er-notice" id="er-pdfBanner" style="display:none; border-color:#bfe0c4; background:var(--er-goodtint); color:var(--er-good);">
    📄 <b>완성본 PDF가 첨부된 보고서입니다.</b>
    <a href="#" onclick="erPdfPreview(); return false;" style="font-weight:800; color:var(--er-good); text-decoration:underline;">화면에서 보기</a> ·
    <a id="er-pdfBannerLink" href="#" style="font-weight:800; color:var(--er-good); text-decoration:underline;">다운로드</a>
  </div>

  <%-- 거래처 전용 인라인 PDF 뷰어 — 클릭 없이 승인 확정본을 바로 펼쳐 준다(2026-08-03).
       본문(.er-doc)은 er-pdfonly 로 감춰져 있으므로 병원 화면에는 이 뷰어가 문서 자리를 대신한다. --%>
  <div id="er-hospPdfWrap" style="display:none;">
    <div id="er-hospPdfMsg">PDF를 불러오는 중입니다…</div>
    <iframe id="er-hospPdfFrame" title="적정성평가 월간 컨설팅 보고서(승인 확정본)"></iframe>
  </div>

  <!-- ===== 지면 ===== -->
  <div class="er-doc">
    <!-- PAGE 1 : 표지 (원본 PDF 맨앞장 형식 — 가운데 정렬 한 장, 수치·병원명·목표는 자동 채움) -->
    <div class="er-page er-cover">
      <div class="er-cover-eyebrow er-editable" data-key="cover_top">요양병원 입원급여 적정성평가</div>
      <div class="er-cover-title">
        <span class="er-editable" data-key="cover_hosp" id="er-coverHosp">○○요양병원</span><br>
        적정성평가 월별 보고서
      </div>
      <div class="er-cover-meta1">평가대상 : <b id="er-coverPeriod">-</b></div>
      <div class="er-cover-meta2">목표등급 <b><span class="er-editable" data-key="cover_goal_grade">3등급</span> (<span class="er-editable" data-key="cover_goal_score">78</span>점)</b>
        &nbsp;→&nbsp; 현재 종합점수 <b class="er-b-bad er-num" id="er-coverTotal">-</b>점</div>
      <div class="er-cover-noteswrap">
      <div class="er-cover-datetop">작성일 : <span class="er-editable" data-key="cover_date" id="er-coverDate">-</span></div>
      <div class="er-cover-notes er-editable" data-key="cover_notes">
        <div class="er-cnotes-title">■ 보고서 산출 기준 및 유의사항</div>
        <ul class="er-cnotes-list">
          <%-- 수동 <br> 제거(2026-08-03 요청 "우측 빈 공간 채우기") — 줄을 손으로 끊으니 오른쪽이 비었다. 폭에 맞춰 자연 줄바꿈 --%>
          <li>본 보고서에서 제시하는 현황값 및 분석 결과는 병원 제공 자료를 기반으로 산출한 추정값으로, 심사평가원 최종 집계 결과에 따라 일부 수치는 변동될 수 있습니다.</li>
          <li>예상 종합점수는 <b>‘2주기 6차 적정성평가 기준’의 지표별 표준화 구간을 적용</b>하여 산출한 값으로, 심사평가원 최종 집계 과정에서 표준화 구간이 재설정될 경우 최종 결과와 차이가 발생할 수 있습니다.</li>
          <li>진료영역_유치도뇨관 환자분율 지표는 고‧저위험군 구성비에 따른 가중치 적용 지표로, 본 보고서에서는 고‧저위험군 가중치를 1:1로 가정한 추정값을 제시하였으며, 해당 가중치는 심사평가원 최종 집계 시 확정됨에 따라 최종 결과와 차이가 발생할 수 있습니다.</li>
          <li>진료영역_항정신성의약품 처방률 지표는 2026년 7월부터 2027년 6월까지의 1년 평가기간을 기준으로 산출되므로, 평가기간 종료 시점까지 처방률 변동이 발생하지 않도록 지속적인 관리가 필요합니다.</li>
          <li>2026년도 적정성평가 결과는 2028년 6월 발표 예정으로, 최종 점수 산출 시 ‘DUR 점검율’, ‘장기입원환자분율’, ‘지역사회복귀율’ 지표의 현황값 변동에 따라 종합점수에 일부 영향이 발생할 수 있습니다.</li>
        </ul>
      </div>
      </div>
      <div class="er-cnotes-box er-editable" data-key="cover_notes_footer">※ 본 보고서는 심사평가원 공식 결과를 대체하지 않으며,<br>적정성평가 대응을 위한 사전 분석 및 내부 검토 자료로 활용하시기 바랍니다.</div>
      <div class="er-cover-logo"><img src="${pageContext.request.contextPath}/images/winct/wincheck.jpg" alt="위너넷 WinCheck+"></div>
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
          <div class="er-editable" data-key="diag_core">현재 종합점수는 목표 등급 구간에 미치지 못함. 안정적인 목표등급 달성·유지를 위해 구간 상단 점수를 목표로 개선이 필요함.</div>
          <div class="er-fn er-editable" data-key="diag_note">※ 병원 여건을 고려한 단계적 목표(목표등급) 기준으로 부족점수와 개선 로드맵을 산정함.</div>
        </div>

        <%-- 순서 설명은 제목과 한 줄로(2026-07-30) — 다 적으면 두 줄로 꺾여 '우선 개선지표' 제목이 갈라져 보였다.
             자세한 순서는 hover(title)로. --%>
        <%-- 순서 나열 괄호는 뺐다(2026-08-03 요청) — 표 자체가 순위순이라 중복 정보. 근거는 툴팁으로만 남긴다 --%>
        <div class="er-subh" style="white-space:nowrap;"
          title="우선순위: 욕창개선 → ADL → HbA1c → 배뇨관리 → 유치도뇨관 → 구조영역(다음 표준화 구간 근접순) → 장기입원 → 항정 → 지역사회복귀">2. 한눈에 보는 우선 개선지표</div>
        <div class="er-tw">
          <table class="er-tbl">
            <thead><tr><th>순위</th><th class="er-l">지표</th><th>영역</th><th>가중치</th><th>현재점수</th><th>부족점수</th><th class="er-l">개선 여지</th></tr></thead>
            <tbody id="er-priBody"><!-- JS --></tbody>
          </table>
        </div>
        <div class="er-fn er-editable" data-key="pri_note">※ 부족점수 = 가중치(만점) − 현재 획득점수. 가중치가 큰 결과지표의 실적 기록 정상화가 등급 향상의 핵심 지렛대임.</div>
      </div>
    </div>

    <!-- PAGE 2 : Ⅱ 상세 분석표 -->
    <div class="er-page">
      <div class="er-sec" style="margin-top:0;">
        <div class="er-eyebrow"><span class="er-rn">Ⅱ.</span><span class="er-stitle">영역별·지표별 상세 분석</span></div>
        <div class="er-tw">
          <table class="er-tbl er-tbl2">
            <%-- [2026-07-28 사용자 확정] '부족점검'(옛 '획득률', 값=획득/가중치 %) 열 제외 → 7컬럼.
                 되살릴 때는 여기 th 와 renderTable2() 의 rateTd·소계 rate 칸을 함께 넣어야 칸 수가 맞는다. --%>
            <thead><tr><th>영역</th><th class="er-l">지표명</th><th>가중치<br>(만점)</th><th>현황값</th><th>표준화<br>구간</th><th>획득<br>점수</th><th>부족점수</th></tr></thead>
            <tbody id="er-tbl2Body"><!-- JS --></tbody>
          </table>
        </div>
        <%-- 2026-07-30 사용자 요청: '유치도뇨관 관련 의무기록(Foley) 제외' 문구 삭제 (종전 세 번째 ※ 줄) --%>
        <div class="er-fn er-editable" data-key="tbl2_note">※ 표준화 구간은 2024년(2주기 6차) 평가결과 기준(1구간 미흡 ~ 5구간 우수). 획득점수 = 가중치 ÷ 5 × 표준화구간.<br>※ 항정신성의약품 처방률은 타 기관의 상병 구성·평균 처방률 확인이 불가하여 시스템 산출 PI값이 실제 평가결과와 차이가 있을 수 있습니다(참고용, 기본 표준화 3구간 산정).</div>
      </div>
    </div>

    <!-- PAGE 3 : Ⅲ 지표별 분석 내용 (편집 문구) -->
    <div class="er-page">
      <div class="er-sec" style="margin-top:0;">
        <div class="er-eyebrow"><span class="er-rn">Ⅲ.</span><span class="er-stitle">지표별 분석 내용</span></div>
        <p class="er-fn er-editable" data-key="sec3_lead" style="margin-top:0;">각 지표별 산정근거 (분모 · 분자 · 현황값 → 표준화구간 → 획득점수), 지표의 개선방향을 정리함.</p>
        <div id="er-sec3Body"><!-- 기본 문구는 JS 가 채우고, 저장된 override 가 있으면 덮어씀 --></div>
      </div>
    </div>

    <!-- PAGE 4 : Ⅳ 로드맵 + 총평 (편집 문구)
         ※ 종전의 'Ⅳ 우선 개선지표별 권고사항' 장은 2026-08-03 삭제 — 고유 내용(목표 줄)은 Ⅲ 분석내용에 통합됨.
         id 는 운영사용(NOR_YN) 아닌 병원에게 이 장을 통째로 감추는 데 쓴다(.er-norec) -->
    <div class="er-page" id="er-page4">
      <div class="er-sec" style="margin-top:0;">
        <div class="er-eyebrow"><span class="er-rn">Ⅳ.</span><span class="er-stitle">목표등급 달성 로드맵</span></div>

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
          <div class="er-editable" data-key="concl">가중치가 큰 결과지표(예: 욕창·ADL 개선)의 실적 기록 정상화만으로 큰 폭의 점수 확보가 가능함. 실제 진료·재활은 이뤄지나 개선 판정이 평가표에 기록되지 않아 낮게 산정되는 경우가 많으므로, 추가 인력·비용 없이 기록·평가 절차 개선으로 목표 달성 가능성이 높음.</div>
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

      <!-- ═══════════════════════════════════════════════════════════════════
           Ⅵ. 의무기록 점검 결과 — 외부 작성분 붙여넣기 (2026-07-22 신설)
             · 담당자가 간호기록·경과기록 원문을 직접 읽고 아래한글 등으로 작성한다.
               우리 DB(평가표)만으로는 만들 수 없어 자동 생성이 불가하다.
             · ★점검 항목·표 양식이 병원마다 다르고, 있을 수도 없을 수도 있다
               → 시스템에 양식을 두지 않고 '붙여넣기 영역' 하나만 둔다.
               아래한글·워드에서 표째 복사 → Ctrl+V 하면 서식 그대로 들어온다.
             · 저장 = data-key="mr_body" innerHTML 통째 → 기존 저장 경로 그대로(서버 무변경).
             · 내용이 없으면 섹션째 숨긴다(erMrToggleSec) — 빈 장이 인쇄되지 않게.
           ═══════════════════════════════════════════════════════════════════ -->
      <div class="er-sec" id="er-sec6">
        <div class="er-eyebrow"><span class="er-rn">Ⅴ.</span><span class="er-stitle">의무기록 점검 결과</span></div>
        <div class="er-fn er-editable" data-key="mr_intro" style="margin:0 0 12px;">평가표와 의무기록(간호기록·경과기록)을 대조하여 확인된 작성오류임. 아래 내용은 <b>평가표 수정</b> 및 <b>기록 보완</b>이 필요한 건으로, 수정 시 해당 지표 점수가 회복될 수 있음.</div>

        <!-- ★붙여넣기 영역 — 점검 항목·양식이 병원마다 달라서 시스템에 양식을 못 박는다.
             아래한글·워드에서 표째로 복사해 그대로 Ctrl+V. 서식(표·굵기·색)이 함께 붙는다.
             전체가 하나의 편집영역(data-key=mr_body)이라 붙인 내용이 통째로 저장·복원된다. -->
        <div class="er-noprint er-mrbar">
          <span class="er-mrhint">아래한글·워드에서 <b>표째 복사</b> 후 아래 영역에 <b>Ctrl+V</b> · 그림은 <b>클릭</b>해서 크기 조절 · 여러 장은 <b>Ctrl+클릭</b>으로 함께 선택</span>
          <span class="er-zoom">
            <button type="button" class="er-btn" onclick="erMrZoomStep(event,-1)" title="붙인 내용 축소 5% — Shift+클릭 = 1% 미세조절 (그림을 아무것도 고르지 않았을 때는 Ctrl+마우스휠도 됩니다)">➖</button>
            <button type="button" class="er-btn er-zoomlbl" id="er-mrZoomLbl" onclick="erMrZoomInput()" title="클릭 → 배율(%)을 숫자로 직접 입력 (100 = 원래 크기)">100%</button>
            <button type="button" class="er-btn" onclick="erMrZoomStep(event,1)" title="붙인 내용 확대 5% — Shift+클릭 = 1% 미세조절">➕</button>
          </span>
          <button type="button" class="er-btn" onclick="erMrFit()" id="er-mrFitBtn" title="붙인 표를 본문 폭에 맞춰 늘립니다(오른쪽 빈 공간 제거)">↔ 폭맞춤</button>
          <!-- '전체 비우기'는 뺐다(2026-07-22 요청) — 한 번에 다 날아가 사고가 나기 쉽고,
               그림별 삭제(그림 클릭 → 🗑)와 실행취소로 충분하다. erMrClear 함수는 남겨둠. -->
          <button type="button" class="er-btn" id="er-mrUndoBtn" onclick="erMrUndo()" title="방금 한 작업을 되돌립니다 (Ctrl+Z)" disabled>↩ 실행취소</button>
          <!-- 탐색기는 '누를 때만' 열린다 — 파일은 안 열고 넣어둔 그림만 손보는 경우가 많다 -->
          <button type="button" class="er-btn er-good" onclick="erMrPickFile()" title="PDF·이미지 파일을 열어 필요한 부분만 잘라 넣습니다">📂 탐색기 열기</button>
        </div>
        <!-- 안내문은 er-mrBody 밖에 둔다 — 안에 넣으면 저장 내용(mr_body)에 섞인다 -->
        <div id="er-mrPh" class="er-mrph er-noprint" style="display:none">
          위 <b>📂 탐색기 열기</b> 로 PDF·이미지를 열어 필요한 부분을 잘라 넣거나,<br>
          아래한글·워드에서 <b>표째 복사</b> 후 이 아래를 클릭하고 <b>Ctrl+V</b> 하세요.
        </div>
        <div id="er-mrBody" class="er-editable er-mrbody" data-key="mr_body"></div>
      </div>

      <%-- 문서 각주(면책 문구) — 이 장(#er-page4)이 통째로 감춰지는 '사용운영만 하는 병원'에서도 남아야 하므로
           erApplyNorYn 이 앞 장 끝으로 옮긴다(원래 자리 = 이 장의 맨 끝). --%>
      <div class="er-docfoot er-editable" id="er-docFoot" data-key="footer">본 보고서는 WinCheck⁺ 시스템 산출값을 근거로 작성되었으며, 목표등급은 해당 병원의 설정값 기준입니다. 실제 평가결과는 심평원 최종 산정 기준 및 자료 확정 시점에 따라 달라질 수 있습니다.</div>
    </div>
  </div>

  <!-- 넣은 그림 크기 조절바 — 그림을 클릭하면 그 위에 떠서 개별로 줄이고 늘린다 -->
  <div id="er-imgBar" class="er-imgbar er-noprint" style="display:none">
    <button class="er-btn" onclick="erImgSize(event.shiftKey?-1:-5)" title="그림 축소 5% — Shift+클릭 = 1% 미세조절">➖</button>
    <button class="er-btn er-zoomlbl" id="er-imgSzLbl" onclick="erImgSizeInput()" title="클릭 → 크기(%)를 숫자로 직접 입력 · 여러 장 선택 중이면 전부 같은 크기로 맞춰집니다">100%</button>
    <button class="er-btn" onclick="erImgSize(event.shiftKey?1:5)" title="그림 확대 5% — Shift+클릭 = 1% 미세조절">➕</button>
    <button class="er-btn" onclick="erImgRatio()" title="처음 넣었을 때의 크기·비율로 되돌립니다">↺ 원래대로</button>
    <!-- 화살표 = 현재 상태(2026-08-03 요청): ⤓(아래) = 미지정 / ⤒(위) = 지정됨. _mrBrkBtnSync 가 갱신 -->
    <button class="er-btn" id="er-imgBrkBtn" onclick="erImgBreak()" title="이 그림부터 새 장(페이지)에서 시작합니다. 지정된 그림에서 다시 누르면 해제됩니다">⤓ 새 장에서</button>
    <button class="er-btn" onclick="erImgDel()" title="이 그림 삭제" style="color:#c0392b">🗑</button>
    <!-- ✕ 닫기 (2026-08-03 요청) — 선택 해제 = 조절바·손잡이 닫힘. 빈 곳 클릭과 같은 동작을 버튼으로 제공
         (조절바가 위 편집 툴바를 가리는 위치에 뜨면 '빈 곳'을 찾기 번거로웠다) -->
    <button class="er-btn" onclick="erImgBarClose()" title="조절바 닫기 (그림 선택 해제)" style="font-weight:800">✕</button>
  </div>
  <!-- 그림 크기조절 손잡이 3개 — 오른쪽(가로) · 아래(세로) · 모서리(비율유지).
       ※ .er-noprint 를 붙이지 않는다 — 그 규칙은 display 를 강제로 바꿔 손잡이를 숨겨버린다.
          인쇄 숨김은 @media print 로 따로 처리. -->
  <div id="er-imgHandle"  class="er-hnd" style="display:none" title="끌어서 가로·세로 함께 조절 (비율 유지)"></div>
  <div id="er-imgHandleW" class="er-hnd" style="display:none" title="좌우로 끌어 가로만 조절"></div>
  <!-- 왼쪽 손잡이(2026-08-03 요청) — 그림이 가운데 정렬이라 끌면 양쪽이 함께 늘고 줄어든다 -->
  <div id="er-imgHandleL" class="er-hnd" style="display:none" title="좌우로 끌어 가로만 조절 (가운데 정렬이라 양쪽이 함께 늘고 줄어듭니다)"></div>
  <div id="er-imgHandleH" class="er-hnd" style="display:none" title="위아래로 끌어 세로만 조절"></div>

  <!-- ✂ 파일에서 잘라오기 — ★반드시 보고서(.er-doc) 밖에 둔다.
       안에 두면 A4 자동분할이 이 영역을 복제해 같은 id 가 둘이 되고,
       코드가 숨겨진 원본을 잡아 캔버스·드래그가 먹지 않는다(2026-07-22 수정). -->
  <input type="file" id="er-mrFile" accept="application/pdf,image/*" style="display:none">

  <!-- 잘라오기 창 — PDF/이미지를 그려놓고 마우스로 영역을 끌어 선택 → 그 부분만 삽입 -->
  <div id="er-cropModal" class="er-modal er-noprint" style="display:none">
    <div class="er-modal-box" style="height:94vh">
      <div class="er-modal-head">
        <button class="er-btn er-good" onclick="erCropPopout()"
                title="브라우저 밖 별도 창으로 뺍니다.&#10;다른 모니터로 옮기거나 크게 키워 보고서와 나란히 놓고 작업할 수 있습니다."
                style="flex:0 0 auto;margin-right:8px">🗗 창으로 빼기 <b style="font-weight:700">(클릭하세요)</b></button>
        <span id="er-cropTitle" title="이 줄을 잡고 끌면 창을 옮길 수 있습니다">✥ 마우스로 끌어 선택</span>
        <span class="er-modal-actions">
          <span id="er-cropPager" style="display:none">
            <span class="er-btn er-zoomlbl" id="er-cropPgLbl" style="cursor:default" title="스크롤해서 원하는 페이지로 이동하세요">1 / 1</span>
          </span>
          <span class="er-zoom">
            <button class="er-btn" onclick="erCropZoom(-1)" title="축소">➖</button>
            <button class="er-btn er-zoomlbl" id="er-cropZoomLbl" onclick="erCropZoomFit()" title="클릭 → 창 높이에 맞추기">맞춤</button>
            <button class="er-btn" onclick="erCropZoom(1)" title="확대 — 크게 보고 정확히 자를 때 (Ctrl+휠도 됩니다)">➕</button>
          </span>
          <button class="er-btn er-good" id="er-cropOk" onclick="erCropInsert()" disabled title="선택한 영역만 보고서에 넣습니다. 넣어도 이 창은 열려 있어 계속 잘라 넣을 수 있습니다">✔ 선택영역 넣기</button>
          <button class="er-btn" onclick="erCropAll()" title="문서 전체를 장(페이지)마다 그림 1개씩 모두 넣습니다. 필요 없는 장은 넣은 뒤 🗑 로 지우면 됩니다">📄 전체 넣기</button>
          <button class="er-btn" onclick="erMrPickFile()" title="다른 파일 열기">📂 다른 파일</button>
          <button class="er-btn" onclick="erCropClose()">✕ 닫기</button>
        </span>
      </div>
      <!-- 전 페이지를 세로로 이어 붙인 캔버스 1장 — 페이지 버튼 없이 스크롤로 오간다 -->
      <div class="er-modal-body er-cropbody" id="er-cropStage">
        <div class="er-cropwrap" id="er-cropWrap">
          <canvas id="er-cropCanvas"></canvas>
          <div class="er-croprect" id="er-cropRect" style="display:none"></div>
        </div>
      </div>
      <!-- '전체 넣기' 2026-07-22 제거 → 2026-07-23 사용자 요청으로 재추가(확인창 포함). -->
      <div class="er-cropfoot">
        <span class="er-crophint">💡 필요한 부분을 <b>마우스로 끌어</b> 선택 → <b>✔ 선택영역 넣기</b> · 여러 번 반복할 수 있습니다</span>
      </div>
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

  <%-- 메일 발송 창 — 받는 사람은 수동 입력(이메일 별도 관리가 붙으면 여기 기본값을 그 목록에서 채우면 된다).
       제목·본문 기본값은 표준문구(TBL_EVAL_REPORT_TPL 의 mail_subject / mail_body)에서 오고,
       {hosp}{ym}{total}{grade}{goalGrade}{goalScore}{gap} 자리표시자가 실제 값으로 치환된다. --%>
  <div id="er-mailModal" class="er-modal er-noprint" style="display:none;">
    <div class="er-modal-box" style="width:min(720px,96vw); height:auto; max-height:92vh;">
      <div class="er-modal-head">
        <span>✉ 월보고서 메일 발송 <span id="er-mailWho" style="font-weight:600; font-size:12.5px; opacity:.8;"></span></span>
        <span class="er-modal-actions">
          <button id="er-mailSendBtn" class="er-btn er-good" onclick="erMailSend()">📨 보내기</button>
          <button class="er-btn" onclick="erMailClose()">✕ 닫기</button>
        </span>
      </div>
      <div style="padding:14px 18px; background:#fff; overflow:auto;">
        <div style="font-size:12.5px; color:#5b6b80; margin-bottom:10px;">
          첨부해 둔 <b>완성본 PDF</b>가 그대로 첨부됩니다. 여러 명에게 보내려면 주소를 <b>콤마(,)</b>로 구분하세요.
        </div>
        <label style="display:block; font-size:12.5px; font-weight:800; color:#37475a; margin:0 0 4px;">받는 사람</label>
        <input id="er-mailTo" type="text" placeholder="hospital@example.com, staff@example.com"
               style="width:100%; height:34px; padding:4px 9px; font-size:13.5px; border:1px solid #cfd8e6; border-radius:6px;">
        <label style="display:block; font-size:12.5px; font-weight:800; color:#37475a; margin:12px 0 4px;">제목</label>
        <input id="er-mailSubject" type="text"
               style="width:100%; height:34px; padding:4px 9px; font-size:13.5px; border:1px solid #cfd8e6; border-radius:6px;">
        <label style="display:block; font-size:12.5px; font-weight:800; color:#37475a; margin:12px 0 4px;">내용</label>
        <textarea id="er-mailBody" rows="8"
               style="width:100%; padding:7px 9px; font-size:13.5px; line-height:1.7; border:1px solid #cfd8e6; border-radius:6px; resize:vertical;"></textarea>
        <div id="er-mailNote" style="margin-top:10px; font-size:12px; color:#8a5a00;"></div>
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
    /* ★F5(새로고침) 복원 — 목록이 넘긴 원샷 컨텍스트는 위에서 이미 지워졌으므로,
       F5 를 누르면 기본값(자기 코드·지난달)으로 열려 보던 보고서가 '사라진 것처럼' 보였다.
       새로고침으로 판정되고 명시 컨텍스트(원샷·URL)가 없으면 직전에 보던 병원·월(erCurCtx)을 복원.
       메뉴로 정상 재진입한 경우는 navigate 판정이라 기존 동작(기본값) 그대로다(2026-07-22). */
    /* ★마지막 보고서 복원 — F5 를 누르면 원샷 컨텍스트가 없어 기본값(지난달)로 열리며
       보던 7월 보고서가 '사라진 것처럼' 보였다(2026-07-22).
       처음엔 performance 의 reload 판정을 썼지만 이 앱은 URL 가림(replaceState)·내부 재이동이
       있어 판정이 어긋난다 → 판정을 버리고 규칙으로 대체:
         명시 컨텍스트(목록 원샷·URL 파라미터)가 없고, 병원 선택(cookie s_hospid)이
         기억 시점과 그대로면 = 같은 흐름의 재로드 → 직전 보고서(병원·월)를 복원.
       병원검색으로 다른 병원을 고르면 쿠키가 달라져 복원하지 않는다(기본값 유지). */
    try{
      var curRaw=sessionStorage.getItem('erCurCtx')||'null';
      var ckNow=(cookie('s_hospid')||'').trim();
      try{ console.log('[복원] 판정: sHosp="'+sHosp+'" sYm="'+sYm+'" url파라미터='+/[?&](hospCd|ym)=/.test(q)
        +' 읽기전용='+_erReadonly+' 쿠키병원="'+ckNow+'" 기억값='+curRaw); }catch(e){}
      if(!sHosp && !sYm && !/[?&](hospCd|ym)=/.test(q) && !_erReadonly){
        var cur=JSON.parse(curRaw);
        if(cur && cur.hospCd && /^\d{6}$/.test(cur.ym||'') && String(cur.ck||'')===ckNow){
          hospCd=String(cur.hospCd).trim();
          if(cur.hospNm) hospNm=cur.hospNm;
          _erOpenYm=cur.ym;
          try{ console.log('[복원] → '+hospCd+' '+cur.ym+' 보고서로 복원'); }catch(e){}
        }
      }
    }catch(e){ try{ console.warn('[복원] 예외', e); }catch(e2){} }
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
    // 거래처는 본문 화면을 안 준다(정본=승인 PDF). ★조회가 끝난 뒤 감추면 본문이 잠깐 보였다 사라져
    //   깜박임이 생기므로 여기서 '처음부터' 감춘다(2026-08-03).
    document.getElementById('evalReport').classList.add('er-pdfonly');
    var _rt=document.getElementById('er-roleTag'); if(_rt) _rt.textContent='열람';
    // 조회(loadEvalReport)가 실패하면 norYn 을 못 받는다 → 병원 화면은 받기 전까지 '숨김'으로 둔다(노출 사고 방지).
    //   조회에 성공하면 erApplyNorYn 이 실제 값으로 다시 판단해 일반 계약 병원에는 그대로 보인다.
    document.getElementById('evalReport').classList.add('er-norec');
  }

  /* ===== 운영사용(NOR_YN, 적정성평가 계약 CONACT_GB='2') =====
     'Y' = '사용운영만 하는 병원'(계약정보의 운영사용 체크 = 보고서는 안 받고 프로그램만 사용)
        → 마지막 장(Ⅳ 로드맵·총평)을 숨긴다. 화면·인쇄·PDF·문서저장 모두 동일.
        ★ 위너넷 관리자 화면에서도 숨긴다(2026-07-29 사용자 확정) — 관리자가 만든 인쇄·PDF에도 안 들어가
          유출 경로가 남지 않게. 대신 관리자도 그 병원의 Ⅳ 이하를 볼 수 없다.
        + 상단에 '{병원명} — 사용운영만 하는 병원' 깜박이 배지(위너넷 화면에만).
     'Y' 아님 = 일반 계약 → 지금까지처럼 전부 공개.
     값은 loadEvalReport.do 응답(res.norYn). */
  var norYn = 'N', _norLoaded = false;   // 조회 전 기본값 'N'. 배지는 값을 받은 뒤에만 띄운다
  function erApplyNorYn(){
    var root = el('evalReport'); if(!root) return;
    var norOnly = (norYn === 'Y');                       // 사용운영만 하는 병원 = Ⅳ 이하 비공개 대상
    root.classList.toggle('er-norec', norOnly);          // 위너넷·병원 구분 없이 동일 적용
    /* 문서 각주(면책 문구)는 감출 때도 남긴다 — 원래 자리가 감춰지는 장(#er-page4)의 맨 끝이라
       그대로 두면 같이 사라진다. 감출 때는 앞 장(Ⅲ) 끝으로 옮기고, 아니면 원위치로 되돌린다. */
    var ft = el('er-docFoot'), p4 = el('er-page4');
    if(ft && p4){
      if(norOnly){
        var prev = p4.previousElementSibling;
        if(prev && prev.classList.contains('er-page') && ft.parentNode !== prev) prev.appendChild(ft);
      } else if(ft.parentNode !== p4){
        p4.appendChild(ft);                              // 원위치 = 마지막 장의 맨 끝
      }
    }
    var b = el('er-useBadge');
    if(b){
      var nm = hospNm || (el('er-hospNm') ? el('er-hospNm').textContent.replace(/^\[|\]$/g,'') : '');
      b.textContent = '🟠 ' + (nm ? nm + ' — ' : '') + '사용운영만 하는 병원';
      b.classList.toggle('er-on', _norLoaded && norOnly);
    }
  }

  /* ===== 메일 발송 문구 =====
     기본값은 표준문구(TBL_EVAL_REPORT_TPL: mail_subject / mail_body). DB에 없으면 아래 내장값을 쓴다.
     담당자가 발송 창에서 그때그때 고칠 수 있고, 상시 문구를 바꾸려면 TPL 테이블 값을 고친다. */
  var TPL_MAIL = {
    subject: '[{hosp}] {ym} 적정성평가 월간 컨설팅 보고서',
    body: '안녕하십니까. {hosp} 담당자님.\n\n{ym} 적정성평가 월간 컨설팅 보고서를 보내드립니다.\n'
        + '첨부된 PDF를 확인해 주시고, 문의사항은 회신 주시기 바랍니다.\n\n'
        + '· 현재 종합점수 : {total}점 ({grade})\n· 목표 : {goalGrade} ({goalScore}점) · 부족점수 {gap}점\n\n감사합니다.\nWinCheck⁺ 드림'
  };

  var editing = false, approved = false, curYm = '', pdfPath = '';
  var indicators = [], scores = { struct:0, care:0, total:0 };
  var _bladderGapN = 0;   // [★6] 배뇨관리(06) '일지 작성했으나 프로그램 미체크(분자제외 우려)' 건수 — 오류점검(assesCheck flag 07) 집계
  /* [보완1] P5 의무기록 신뢰도 '영역별' 문구 선택용 — 오류점검 건수(라이브러리 202607 Part 4).
     ⚠flag 번호 ≠ 지표코드: flag02→유치도뇨관(05) · flag03→신규욕창(10) · flag04→욕창관리(09·11) · flag07→배뇨관리(06). */
  var _errFoleyN = 0;     // 유치도뇨관 오류 건수(flag 02)
  var _errSoreN  = 0;     // 욕창 오류 건수(flag 03 신규발생 + flag 04 욕창관리)
  var _errBladN  = 0;     // 배뇨 오류 건수(flag 07 전체 — '분자제외'뿐 아니라 패드·기저귀 오류 포함)
  var _dashInd = null;    // [C1·C2] 대시보드 지표 SP(dashbordINDICATORS): monthVal(당월)·year_Val(누적)·month_07~12(월별)·hosGrade
  /* [N1 2026-08-05] 항정신성(07) <전월 실측 처방률> — 2026-07 정답지 27건 중 10곳 이상이
       "7월 청구자료 미업로드로 표준화 3점 가정하였으나, 6월 처방률은 56.16%로 표준화 1점 구간" 문형을 쓴다.
       당월 처방률은 청구(SAM) 업로드 전이라 알 수 없어 3점 가정인데, <전월 실측>으로 방향을 미리 알려주는 것.
       원천 = select_CategoryList.do cateCd='07'(전월) — 환자별 psyOrderYn('●') 비율. 실패·0명이면 null(문장 생략). */
  var _psyPrev = null;    // { from:'202607', to:'202611', n:●수, d:인월합, rate:% } — 7월 보고서만 전월 단월
  var prevTotal = null;   // 전월 종합점수 — 총평 P1 전월대비용 (7월=새 평가기간 시작·자료 없음이면 null)
  function prevYmOf(ym){ var y=+ym.substring(0,4), m=+ym.substring(4,6)-1; if(m<1){ m=12; y--; } return String(y)+('0'+m).slice(-2); }

  function el(id){ return document.getElementById(id); }   // 주의: jQuery $ 를 가리지 않도록 el 사용
  function esc(s){ return String(s==null?'':s).replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;'); }
  function n(v){ var x = Number(v); return isNaN(x)?0:x; }
  function f1(v){ var x=n(v); return (Math.round(x*10)/10).toFixed(1); }
  function fnum(v){ var x=n(v); return (Math.abs(x-Math.round(x))<0.001)? String(Math.round(x)) : (Math.round(x*100)/100).toString(); }
  /* 등급 구간(2026-07-30 사용자 확정): 87↑=1 / 79~87미만=2 / 74~79미만=3 / 64~74미만=4 / 64미만=5
     (종전 88/79/71/63 에서 변경 — evalReportList.jsp·MagamController.gradeOfScore 와 반드시 같이 고칠 것) */
  function gradeOf(t){ t=n(t); if(t>=87)return'1등급'; if(t>=79)return'2등급'; if(t>=74)return'3등급'; if(t>=64)return'4등급'; return'5등급'; }
  function areaNm(fg){ return fg==='10'?'구조':(fg==='21'?'과정':(fg==='22'?'결과':'')); }
  function grpNm(fg){ return fg==='10'?'구조지표':(fg==='21'?'과정지표':(fg==='22'?'결과지표':'기타')); }

  // ===== 적정성평가 화면(assessment.jsp)과 동일 기준 =====
  var UNIT_PERSON = ['01','02','03'];                         // 명 단위 지표(1인당 환자수) — 나머지는 %
  var DENOM_NM = { '01':'의사', '02':'간호사', '03':'간호인력' };
  var NOT_HEADCOUNT = ['04','08'];                            // 분모가 환자수가 아닌 지표(재직일수율·DUR)

  /* ── 산정근거 문장의 분모·분자 이름 (2026-08-10 요청) ───────────────────────
     종전 "대상 43명 중 해당 3명" 은 무엇이 대상이고 무엇이 해당인지 알 수 없었다.
     지표마다 분모·분자의 뜻이 다르므로 이름을 지표코드별로 붙인다.
     ★개선형(11 욕창개선·12 ADL개선)은 "…중 N명 개선되어" 로 말이 달라진다. */
  var DEN_NM2 = {
    '05':'평가대상자', '06':'배뇨관리 대상자', '09':'욕창 보유 환자',
    '10':'욕창 고위험군 환자', '11':'욕창 개선대상자', '12':'ADL 개선대상자',
    '13':'당뇨병 상병 환자', '14':'평가대상자', '15':'퇴원 환자'
  };
  var NUM_NM2 = {
    '05':'유치도뇨관 14일 초과 대상자', '06':'배뇨관리 실시 환자', '09':'욕창 처치 실시 환자',
    '10':'2단계 이상 욕창이 새로 발생한 환자', '11':'개선', '12':'개선',
    '13':'적정범위 환자', '14':'181일 이상 장기입원 환자', '15':'지역사회 복귀 환자'
  };
  var IS_IMPROVE = { '11':1, '12':1 };                        // "…중 N명 개선되어" 형식

  /** 보고서 대상 월 — "7월". 산정근거 문장 앞에 붙여 어느 달 실적인지 드러낸다. */
  function ymLabel(){
    var y = String(curYm || '');
    return (y.length >= 6) ? parseInt(y.substring(4,6),10) + '월' : '';
  }
  var _cum = null;     // { from:'202607', to:'202609', map:{ '05':{dtor,ntor,cal,weig} } } — 평가기간 누적
  /** 누적 기간 표기 — "7~9월" (같은 해라 연도는 생략) */
  function cumLabel(){
    if (!_cum) return '';
    var a = parseInt(_cum.from.substring(4,6),10), b = parseInt(_cum.to.substring(4,6),10);
    return (a===b) ? a+'월' : a+'~'+b+'월';
  }
  /** 가중치점수 → 표준화점수. 구간 한 칸 = 가중치/5 이므로 되짚을 수 있다(01~15 공통). */
  function zoneOfWeig(w, got){ return (w>0) ? Math.round(got/(w/5)) : 0; }

  // ===== 원본 컨설팅 PDF 표준 문구 (지표코드별) — "양식 그대로" 기본값. 편집으로 병원별 덮어쓰기 가능 =====
  // 지표 정의 (Ⅲ 분석 문단에 이어붙음)
  var TPL_DEF = {
    '01':'월평균 재원환자수를 상근 환산 의사 수로 나눈 값. 값이 작을수록 우수(26명 미만 = 5구간).',
    '02':'값이 작을수록 우수(6명 미만 = 5구간).',
    '03':'간호사+간호조무사 등 간호인력 기준 1인당 환자수. 값이 작을수록 우수(3명 미만 = 5구간).',
    '04':'평가대상기간 중 약사 재직일수 비율(100% = 5구간).',
    /* 2026-08-10 문구 확정(요구사항 185~198행) — 지표 정의에는 기관별 분석 결과(현재 점수·구간·개선 여지)를 넣지 않는다. */
    '05':'전월 평가표 작성일로부터 유치도뇨관 삽입기간이 연속 14일을 초과한 대상자의 비율로, 연속 14일을 초과하지 않도록 관리함. 불필요한 유치도뇨관은 조기 제거하고, 재삽입이 필요한 경우 제거 후 2일이 지난 뒤 재삽입될 수 있도록 관리가 필요함.',
    '06':'배뇨조절이 저하된 환자(자주 실금함·조절 못함) 중 배뇨관리를 실시한 환자의 비율. ① 일정하게 짜여진 배뇨계획에 따른 배뇨일지 3일 이상 작성, ② 방광훈련프로그램 시행 및 배뇨일지 3일 이상 작성, ③ 규칙적 도뇨 시행 중 1개 이상을 충족한 경우 분자로 인정함. 단, 의료최고도 및 배뇨 관련 루 관리 대상 등은 제외함.',
    '07':'환자의 상병 구성을 보정하여 타 기관 대비 항정신성의약품 처방 수준을 평가하는 지표(PI)로, 값이 낮을수록 우수함(0.2 미만 = 5구간 / 1.6 이상 = 1구간). ※ 타 기관의 상병 구성 및 평균 처방률을 확인할 수 없어 WinCheck에서 산출된 PI값은 실제 평가결과와 차이가 있을 수 있으며 참고용으로 활용함. 기관 자체 처방률 기준으로는 10% 이하 시 5구간, 40% 이상 시 1구간 수준으로 참고하여 관리함.',
    '08':'매월 심사평가원의 DUR 점검 현황을 확인하여 누락 대상자 관리가 필요하며 점검 결과에 따라 추후 결과 발표 시 점수차가 발생할 수 있음. 확인경로: 요양기관업무포털(biz.hira.or.kr) > 모니터링 > DUR정보 > 기관별 DUR 점검완료현황.',
    '09':'1단계 이상 욕창을 보유한 환자 중 피부문제 처치를 적절히 실시한 환자의 비율. 압력을 줄이는 도구 사용, 체위변경, 욕창 해결을 위한 영양공급, 욕창부위 드레싱의 4개 항목을 모두 충족한 경우 처치 실시로 인정함. 단, 1단계 욕창은 드레싱을 시행하지 않아도 드레싱을 실시한 것으로 간주하여 평가함.',
    '10':'해당 월 평가와 전월 평가를 모두 받은 욕창 고위험군 환자 중 전월에 비해 2단계 이상의 욕창이 새로 발생한 환자의 비율을 평가하는 지표.',
    '11':'2단계 이상 욕창 보유 환자 중 당일 개선된 환자 비율(개선 = 욕창 단계 수가 줄거나 최고단계가 낮아진 경우).',
    '12':'전월과 당월 의료최고도·선택입원군 및 10개 항목이 완전 자립이거나 감독 필요인 경우는 제외한 대상자 중, 전월 대비 10개 항목의 기능 정도가 2점 이상 개선된 환자의 비율.',
    '13':'당뇨병 상병 환자 중 HbA1c 검사결과가 적정범위(4% 이상 ~ 8.5% 미만)에 해당하는 환자의 비율을 평가하는 지표임.',
    '14':'평가 대상기간 동안 입원 중인 환자 중 입원기간이 181일 이상인 환자의 비율을 평가하는 지표로, 값이 낮을수록 우수함. 단, 평가기간(7~12월) 중 1개월이라도 의료최고도·의료고도·의료중도에 해당하는 환자는 평가대상에서 제외함.',
    '15':'지역사회 복귀율은 심평원 및 행정안전부 자료 등을 연계하여 산출되는 지표로, 기관 자체 자료만으로는 정확한 결과값을 산출하기 어려워 WinCheck에서는 임의로 표준화 3점, 가중치 3점으로 적용함.'
  };
  /* 지표명 표기 교정 (2026-08-10, 2026-08-11 '14' 추가) — DB 지표명이 줄임말이고 괄호가 지워져
     ('장기입원(181일 이상)'→'장기입원181일 이상') 읽기 나쁘다. 보고서에서만 바로잡는다. */
  var NM_FIX = { '12':'일상생활수행능력(ADL) 개선환자분율', '14':'장기입원 환자분율' };
  function indiNm(r){ return NM_FIX[r.cate_cd] || r.cate_nm; }
  // ▷ 개선 방향 (Ⅲ·Ⅳ 기본 문구)
  var TPL_DIR = {
    '01':'의사 인력 충원이 필요한 구조 항목으로, 우선 의사 재직·근무일수 산정 정확성을 점검.',
    '03':'간호인력 충원 및 근무일수 산정 정확성 점검.',
    '05':'불필요 유지 여부 정기 검토·조기 제거, 간헐적 도뇨(CIC) 전환. 제거 시 제거일자를 평가표에 정확히 입력(누락 시 계속 보유로 집계).',
    '06':'배뇨관리계획(일정하게 짜여진 배뇨계획·방광훈련프로그램) 체크 여부와 배뇨일지 작성 여부를 우선 점검하고, 배뇨일지의 실시일자·요실금 여부·배뇨횟수 또는 배뇨량을 의사·간호기록과 일치하도록 관리함.',
    '09':'욕창(피부문제) 처치 4항목(압력분산도구·체위변경·영양공급·창상 드레싱) 중 실시분을 평가표에 정확히 기록. 특히 2단계 이상 압박성 궤양은 염증성 처치(M0121)가 동반 청구되어야 욕창처치 실시로 인정되므로 처치·청구 기록의 일치 여부를 함께 점검. 미실시로 집계된 대상자 중 체중 대비 필요 열량 이상으로 영양공급이 이뤄진 사례가 있으면 평가표의 \'피부문제 해결을 위한 영양공급\' 항목을 보완하여 처치 대상자로 반영(항목 미체크만으로 분자에서 빠져 최고 점수를 놓치는 경우가 많음).',
    '11':'욕창 단계 및 개수의 변화를 지속적으로 확인하고, 욕창 처치 및 경과관리를 통해 개선될 수 있도록 관리함. 전월 대비 욕창 단계 수 감소 또는 최고단계 하향 여부를 평가표에 정확히 반영하여 실제 개선 대상자가 누락되지 않도록 점검함.',
    /* '12'(ADL) 개선방향은 2026-08-10 요청으로 <내렸다> — "재활·기능회복…물리치료·작업치료 연동" 문구가 나오지 않게. */
    '13':'당뇨병 상병 환자의 HbA1c 검사 시행 여부 및 검사결과를 지속적으로 확인하고, 검사 누락 및 평가표 미반영 대상자가 발생하지 않도록 관리함. 적정범위를 벗어난 환자는 혈당관리 및 추적검사를 통해 적정범위 유지 여부를 점검함.',
    '14':'장기입원 환자의 퇴원 가능 여부 및 지역사회 연계 가능성을 지속적으로 검토하고, 환자 상태를 정확하게 평가하여 의료필요도에 따른 환자분류가 적정하게 반영되도록 관리함.',
    '15':'퇴원 환자 중 타 의료기관으로 전원·이송한 경우에는 퇴원수납 및 청구심사 시 진료결과를 ‘이송’ 또는 ‘회송’으로 정확히 입력하고, 사망한 경우에는 ‘사망’으로 입력하여 실제 퇴원결과가 정확하게 반영되도록 관리가 필요함.'
  };
  // Ⅰ-2 우선지표 "개선 여지" 문구
  var TPL_ROOM = {
    '01':'인력 구조 개선 필요', '02':'인력 구조 개선 필요', '03':'인력 구조 개선 필요',
    '05':'연속적인 14일이 되지 않도록 관리',   /* 종전 '감염관리·제거관리' — 2026-07-30 사용자 확정(14일 초과 산정규칙과 연결) */
    '06':'배뇨관리 기록·실시',
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
  // 절단형 상한(19.99·5.99·0.49·0.24 …)을 실제 경계값(20·6·0.5·0.25)으로 — '미만' 표기용 (2026-07-23 사용자 확정)
  //   기준: 소수 2자리 값의 끝자리가 9 또는 4(경계−0.01 절단형)일 때만 +0.01. 정수·정확 경계(100, 30 등)는 그대로.
  function bndUp(en){
    var c = Math.round(en*100);
    if (Math.abs(en*100 - c) > 1e-6 || c % 100 === 0) return en;   // 소수 3자리 이상·정수는 그대로
    var d = c % 10;
    if (d === 9 || d === 4) return Math.round((en + 0.01)*100)/100; // x.99·x.x9·x.24형 → +0.01
    if (d === 0 && Math.floor(c/10) % 10 === 9) return Math.round((en + 0.1)*10)/10;  // x.9형(소수1자리) → +0.1 (구 enR 규칙 계승)
    return en;
  }
  function zoneListText(cd){
    var a = CRIT_ALL[cd]; if(!a || !a.length) return '';
    var u = unitOf(cd);
    return a.map(function(z){
      var st=z.start, en=z.end, bnd=bndUp(en), txt;
      if (en >= 999)        txt = fnum(st)+u+' 이상';                 // 6~9999.99명 → 6명 이상
      else if (bnd !== en)  txt = fnum(st)+'~'+fnum(bnd)+u+' 미만';   // 0~19.99% → '0~20% 미만' (2026-08-11 검수: 단위를 '미만' 앞으로)
      else                  txt = fnum(st)+'~'+fnum(en)+u;
      return txt+'('+z.s+'구간)';
    }).join(' · ');
  }

  /* Ⅲ 자동 분석문 (2026-08-10 형식 확정)
       "7월 평가대상자 43명 중 유치도뇨관 14일 초과 대상자 3명으로 6.98%,
        표준화 1구간(3.5% 이상)에 해당하여 가중치 3점 중 0.6점 산정."
     ★바뀐 점 두 가지
       ① 분모·분자에 <이름>을 붙인다 — 종전 "대상 N명 중 해당 N명"은 뜻이 드러나지 않았다.
       ② 가중치는 <언제나> "W점 중 P점" — 5점 구간이라도 '만점'이라는 말을 쓰지 않는다(표기 통일). */
  function autoAna(r, full){
    var cd=r.cate_cd, w=n(r.stdweig), got=n(r.weigval), dtor=n(r.dtorval), s=n(r.s_score)||0;
    var rng = s ? zoneRange(cd, s) : '';
    var zone = s ? s+'점 구간'+(rng? '('+rng+')' : '') : '-';   /* 표기 통일: '표준화 2점 구간(60~80미만%)' (2026-08-10) */
    var ym = ymLabel(), pre = ym ? ym+' ' : '';
    var lead, conn;
    if (UNIT_PERSON.indexOf(cd)>=0) {
      lead = pre+'평균 재원환자 '+esc(fnum(r.ntorval))+'명 ÷ '+DENOM_NM[cd]+' '+esc(fnum(r.dtorval))+'명 = 1인당 <b>'+calDisp(r)+'</b>';
      conn = '으로 ';
    } else if (cd==='04') {
      lead = pre+'재직대상 '+esc(fnum(r.dtorval))+'일 중 재직 '+esc(fnum(r.ntorval))+'일 = <b>'+calDisp(r)+'</b>';
      conn = '로 ';
    } else if (dtor>0) {
      var dn = DEN_NM2[cd] || '대상', nn = NUM_NM2[cd] || '해당';
      if (IS_IMPROVE[cd])
        lead = pre+dn+' '+esc(fnum(r.dtorval))+'명 중 '+esc(fnum(r.ntorval))+'명 개선되어 <b>'+calDisp(r)+'</b>';
      else
        lead = pre+dn+' '+esc(fnum(r.dtorval))+'명 중 '+nn+' '+esc(fnum(r.ntorval))+'명으로 <b>'+calDisp(r)+'</b>';
      conn = ', ';
    } else {
      lead = pre+'현황값 <b>'+calDisp(r)+'</b>';
      conn = '로 ';
    }
    var zoneTxt = '표준화 '+zone+'에 해당하여 가중치 '+fnum(w)+'점 중 '+f1(got)+'점 산정.';
    return lead + conn + (full? zoneTxt : '<span class="er-hl-bad">'+zoneTxt+'</span>') + cumAna(r);
  }

  /* 평가기간 누적 실적 한 줄 (2026-08-10 요청) — 당월 문장 뒤에 <별도 산출값>으로 붙는다.
       "7~9월 누적 평가대상자 120명 중 유치도뇨관 14일 초과 대상자 5명으로 4.17%,
        표준화 2구간에 해당하여 가중치 3점 중 1.2점 산정."
     ★당월과 분모·분자·현황값·표준화구간·가중치를 <각각> 계산한다(당월 점수를 누적에 쓰지 않는다).
       7월 보고서는 누적=당월이라 붙이지 않는다. */
  function cumAna(r){
    if (!_cum) return '';
    var cd=r.cate_cd, c=_cum.map[cd];
    if (!c || !(c.dtor>0)) return '';
    if (UNIT_PERSON.indexOf(cd)>=0 || cd==='04' || cd==='07' || cd==='08') return '';   // 인력·항정·DUR 은 누적 개념이 다르다
    var w = n(r.stdweig), s = zoneOfWeig(w, c.weig);
    var rng = s ? zoneRange(cd, s) : '';
    var zone = s ? s+'점 구간'+(rng? '('+rng+')' : '') : '-';   /* 표기 통일: '표준화 2점 구간(60~80미만%)' (2026-08-10) */
    var dn = DEN_NM2[cd] || '대상', nn = NUM_NM2[cd] || '해당';
    var val = fnum(c.cal) + unitOf(cd);
    var body = IS_IMPROVE[cd]
      ? cumLabel()+' 누적 '+dn+' '+esc(fnum(c.dtor))+'명 중 '+esc(fnum(c.ntor))+'명 개선되어 <b>'+esc(val)+'</b>, '
      : cumLabel()+' 누적 '+dn+' '+esc(fnum(c.dtor))+'명 중 '+nn+' '+esc(fnum(c.ntor))+'명으로 <b>'+esc(val)+'</b>, ';
    return ' <span class="er-cum">* '+body+'표준화 '+zone+'에 해당하여 가중치 '+fnum(w)+'점 중 '+f1(c.weig)+'점 산정.</span>';
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
    }).then(function(r){
      if(r && r.isConfirmed){ if(onYes) onYes(); }
      else if(opt.onNo){ opt.onNo(); }          // 취소·ESC — 초안 폐기 등 '아니오'에도 할 일이 있는 경우
    });
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
    /* ★인쇄 전 편집 강제 종료 (2026-08-03) — 편집 켠 채 인쇄하면 편집 전용 표시
         (er-pgbreak 빨간 점선, '⤒ 여기부터 새 장' 알약, 파란 편집영역 테두리)가 PDF 에 그대로 찍혔다.
         PDF 화면생성(erPdfGenPreview)은 이미 _erEditOff 를 타는데 인쇄 버튼만 빠져 있었다. */
    _erEditOff();
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
    _erEditOff();                                                 // 편집 표시(파란 테두리)·툴바 제거 후 내보내기
    // 워드·아래한글은 <style> 의 복합선택자(#evalReport .er-…)·flex/grid·그라데이션을 대부분 무시.
    //   → 라이브 DOM의 '계산된 스타일'을 클론에 인라인 style 로 옮겨(워드가 인라인은 잘 따름) 색·표 테두리·정렬 재현.
    var clone = src.cloneNode(true);
    // 화면에서 감춘 장(운영사용 아닌 병원의 Ⅳ 이하)은 문서로도 내보내지 않는다 —
    //   아래 인라인화 목록(PROPS)에 display 가 없어 클론만 두면 숨김이 풀린 채 저장된다.
    if(el('evalReport').classList.contains('er-norec')){
      var _p4=clone.querySelector('#er-page4'); if(_p4 && _p4.parentNode) _p4.parentNode.removeChild(_p4);
    }
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
    _erEditOff();
    el('evalReport').classList.add('er-preview');
    window.scrollTo(0,0);
  };
  window.erPreviewExit = function(){ el('evalReport').classList.remove('er-preview'); };

  // ===== A4 자동 페이지 분할(WYSIWYG) =====
  //   원본 섹션(.er-srcpage)은 편집·저장의 원본으로 그대로 두고(숨김), 그 내용을 '복제'해
  //   A4(210×297mm) 실측 페이지(.er-autopage)에 흐름 단위로 담는다. 복제본은 id/data-key/편집속성을
  //   제거해 저장·조회 로직과 충돌하지 않는다. 편집 중에는 분할을 끄고(자연 흐름) 편집이 편하게 한다.
  /* [재가동 2026-08-03 사용자 요청 "A4에 맞게 잘려서 보여지기"] — 화면 = A4 = 인쇄/PDF(WYSIWYG).
       7/15에 껐던 사유(편집동기화 경우의 수)는 '편집 중엔 분할 해제'로 회피한다:
         · 보기 모드  = A4 실측 페이지로 잘라 표시 (인쇄·PDF도 이 장들을 1:1로 씀)
         · 편집 켜면 = 자연 흐름으로 풀림(원본 직접 편집 — 그림 조절·서식툴 전부 종전대로)
         · 편집 끄면 = 다시 A4 로 잘림
       복제본 실시간 편집(data-ckey 동기화) 경로는 남아 있으나 이 구성에선 쓰이지 않는다. */
  var PAGE_ON = true;

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
    /* Ⅵ 의무기록 — 넣은 내용이 없으면 '제목·안내문까지 통째로' 빼서 그 장이 아예 안 나오게 한다.
       화면(display:none)만으로는 부족하다 — A4 분할은 원본을 복제하므로 숨김 여부를 보지 않아
       빈 제목만 있는 장이 인쇄된다(2026-07-22). */
    //   단, 편집 중에는 남겨둔다 — 붙여넣을 자리가 있어야 하니까. 인쇄·PDF는 편집을 끈 상태로 만든다.
    var skipMr = !_mrHasContent() && !editing;
    // 운영사용 아닌 병원(.er-norec)의 마지막 장(#er-page4 = 로드맵·총평) — 복제하면 id 가 벗겨져
    // 숨김 CSS(#er-page4)가 안 먹으므로, 아예 흐름 단위에서 제외한다(2026-08-03 A4 재가동 대비)
    var skipRec = document.getElementById('evalReport').classList.contains('er-norec');
    Array.prototype.forEach.call(doc.querySelectorAll(':scope > .er-srcpage'), function(pg){
      if(pg.classList.contains('er-cover')) return;   // 표지는 별도 처리
      if(skipRec && pg.id==='er-page4') return;       // 로드맵·총평 비공개 병원
      Array.prototype.forEach.call(pg.children, function(top){
        if(top.id==='er-sec6' && skipMr) return;      // Ⅵ 의무기록 — 넣은 내용 없으면 장째 제외
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
          } else if(id==='er-mrBody'){
            /* Ⅵ 의무기록 — 붙인 그림·표를 하나씩 흐름단위로 쪼갠다.
               그래야 그림 하나가 통째로 한 장에 들어가고, '⤓ 새 장에서'(er-pgbreak) 표시가 있으면
               그 그림부터 새 장에서 시작한다(2026-07-22). */
            Array.prototype.forEach.call(ch.children, function(k){
              units.push({ nodes:[k], keep:false, hardBreak:!!(k.classList && k.classList.contains('er-pgbreak')) });
            });
          } else {
            units.push({ nodes:[ch], keep:ch.classList.contains('er-subh') });
          }
        });
      });
    });
    // Alt+클릭 '새 장' 표시(er-pgbreak)가 붙은 블록 = 화면 A4 분할에서도 강제 새 장(2026-08-03)
    units.forEach(function(u){
      if(!u.hardBreak) u.hardBreak = u.nodes.some(function(nd){
        return nd.classList && nd.classList.contains('er-pgbreak');
      });
    });
    return units;
  }

  // 장 번호표(2026-08-03 "편집 끄기 해도 페이지 표시") — 보기 모드 A4 장마다 'N장' 칩. 인쇄·PDF캡처엔 안 찍힘
  function _erPgNum(p, doc){
    var no = doc.querySelectorAll('.er-autopage').length;   // appendChild 후 호출 → 자기 자신 포함 개수 = 장 번호
    /* er-noprint 를 붙이면 안 된다 — 그 클래스는 '편집 모드에서만 표시'라 보기 모드에서 숨는다(2026-08-03).
       인쇄·캡처 숨김은 .er-pgnum 자체 규칙(@media print · body.er-capturing)으로 처리 */
    var t=document.createElement('div'); t.className='er-pgnum'; t.textContent=no+'장';
    p.appendChild(t);
  }
  function erNewPage(doc){
    var p=document.createElement('div'); p.className='er-autopage';
    var b=document.createElement('div'); b.className='er-autobody';
    p.appendChild(b); doc.appendChild(p); _erPgNum(p, doc); return b;
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

  /* 한 장에 안 들어가는 그림을 페이지 안쪽으로 줄인다.
     .er-autobody 는 overflow:hidden 이라 넘치는 부분이 '잘려 사라진다' —
     잘라온 표가 반쯤 잘리면 읽을 수 없으므로, 들어갈 때까지 폭을 낮춘다.
     ※ 복제본(A4 미리보기)만 줄인다. 원본(mr_body)의 사용자 지정 크기는 건드리지 않는다. */
  function erShrinkToFit(body, maxH){
    var imgs=body.querySelectorAll('img'); if(!imgs.length) return;
    for(var step=0; step<14 && body.scrollHeight > maxH+1; step++){
      Array.prototype.forEach.call(imgs, function(im){
        var w=parseFloat(im.style.width);
        if(!w){ w = im.getBoundingClientRect().width / (body.clientWidth||1) * 100; }
        im.style.width = Math.max(12, w*0.92) + '%';
        if(im.style.height && im.style.height!=='auto') im.style.height='auto';   // 비율 유지로 되돌림
      });
    }
  }

  window.erPaginate = function(){
    var root=el('evalReport'), doc=erDoc(); if(!doc) return;
    erTagSrcPages();
    Array.prototype.forEach.call(doc.querySelectorAll('.er-autopage'), function(p){ p.remove(); });
    /* 편집 중에도 분할 계산은 돌린다(2026-08-03 "어디까지 A4인지 사용자는 몰라서") —
         화면은 원본(자연 흐름)을 보여주되(아래 er-editmode CSS 가 A4 복제본을 화면 밖으로 치움),
         복제본 레이아웃에서 얻은 '장 시작 블록' 목록(_erPageStarts)으로 원본 위에 경계 표지를 띄운다. */
    if(!PAGE_ON){ root.classList.remove('er-paged'); return; }
    root.classList.add('er-paged');
    // 표지 페이지(가운데 정렬 그대로 복제)
    var cover=doc.querySelector(':scope > .er-srcpage.er-cover');
    if(cover){
      // er-cover 클래스 유지 — 표지 전용 스타일(.er-cover .er-cover-title 등)이 복제본에도 적용되게
      var cp=document.createElement('div'); cp.className='er-autopage er-cover-page er-cover';
      Array.prototype.forEach.call(cover.children, function(ch){ cp.appendChild(erClone(ch)); });
      doc.appendChild(cp); _erPgNum(cp, doc);
    }
    // 본문 흐름 단위 → A4 실측 채우기 (섹션 헤더는 항상 새 페이지 시작)
    var units=erCollectUnits(doc);
    _erPageStarts=[];                                  // [경계 표지] 각 장의 '첫 원본 블록' 기록
    var _markStart=true;
    var body=erNewPage(doc), maxH=erCapacity(body);
    var curUnits=[];                                   // 현재 장에 실린 흐름 단위(고아 헤더 판정용)
    units.forEach(function(u){
      // 섹션(Ⅰ~Ⅴ) 헤더: 현재 장의 남은 공간이 45% 미만이면 새 장에서 시작,
      // 충분히 남았으면(직전 섹션 꼬리만 있는 거의 빈 장 등) 같은 장에 간격 두고 이어붙임
      // 사용자가 '⤓ 새 장에서' 로 지정한 것 = 남은 공간과 무관하게 무조건 새 장에서 시작
      if(u.hardBreak && body.children.length){ body=erNewPage(doc); maxH=erCapacity(body); curUnits=[]; _markStart=true; }
      else if(u.newPage && body.children.length){
        var remain = maxH - body.scrollHeight;
        if(remain < maxH*0.45){ body=erNewPage(doc); maxH=erCapacity(body); curUnits=[]; _markStart=true; }
      }
      erAppendUnit(body,u);
      var overflow = body.scrollHeight > maxH+1;
      var onlyThis = (body.children.length <= u.nodes.length);
      if(overflow && !onlyThis){                         // 넘치면 다음 페이지로
        /* ★고아 헤더 방지(2026-08-03 다온 3장 실사고 / 2026-08-11 확장)
             '헤더류(keep = 그룹라벨·소제목·섹션제목)' 뒤에 올 본문이 안 들어가면, 종전에는 본문만
             다음 장으로 가고 헤더가 홀로 남았다. 실제로 4장 끝에 <과정지표> 라벨만 덩그러니 남고
             유치도뇨관 지표는 5장으로 넘어갔다(2026-08-11 보고).
             → 장 <끝에 매달린 헤더들>을 본문과 함께 다음 장으로 옮긴다. 헤더뿐이던 장은 지운다.
             ※종전 코드는 '장 전체가 헤더일 때'만 처리해, 앞에 다른 지표가 실린 장의 꼬리 라벨은 못 잡았다. */
        erRemoveUnit(u);
        var tail=[];
        while(curUnits.length && curUnits[curUnits.length-1].keep) tail.unshift(curUnits.pop());
        tail.forEach(erRemoveUnit);
        if(curUnits.length===0 && tail.length){                  // 그 장이 통째로 헤더뿐이었다 → 빈 장 제거
          var emptyPg=body.parentNode; if(emptyPg && emptyPg.parentNode) emptyPg.parentNode.removeChild(emptyPg);
          if(_erPageStarts.length) _erPageStarts.pop();          // 지운 빈 장의 시작 기록 회수
        }
        body=erNewPage(doc); maxH=erCapacity(body); curUnits=[];
        if(tail.length){
          tail.forEach(function(h){ erAppendUnit(body,h); curUnits.push(h); });
          _erPageStarts.push(tail[0].nodes[0]); _markStart=false;
        } else {
          _markStart=true;
        }
        erAppendUnit(body,u);
        onlyThis = (body.children.length <= u.nodes.length); overflow = body.scrollHeight > maxH+1;
      } else if(u.keep && !onlyThis && (maxH - body.scrollHeight) < 130){
        // 라벨·소제목이 페이지 맨 아래에 홀로 남지 않게 다음 페이지로 넘김
        erRemoveUnit(u); body=erNewPage(doc); maxH=erCapacity(body); curUnits=[]; erAppendUnit(body,u);
        _markStart=true;
      }
      curUnits.push(u);
      if(_markStart){ _erPageStarts.push(u.nodes[0]); _markStart=false; }
      /* ★혼자서도 한 장을 넘는 그림 = 잘려서 사라진다(.er-autobody 는 overflow:hidden).
         페이지에 들어갈 때까지 그림을 줄인다. 잘라온 표는 통째로 보여야 읽을 수 있다(2026-07-22). */
      if(overflow && onlyThis) erShrinkToFit(body, maxH);
    });
    erSetCloneEditable();   // 편집 중 재분할 시 편집 가능 상태 유지
    try{ _erGuideSync(); }catch(e){}                   // [경계 표지] 편집 중이면 원본 위에 'N장 시작' 표시
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
    // 이력 열람이면 그 시점 PDF(_erHstInfo.pdf) 우선, 아니면 현재 첨부(pdfPath)
    var vpath = (_erReadonly && _erHstInfo && _erHstInfo.pdf) ? _erHstInfo.pdf : pdfPath;
    if(!vpath){ erSwal('warning','첨부된 PDF가 없습니다.'); return; }
    var seq = ++_pdfSeq;
    var name = vpath.split('/').pop();
    var dlUrl = ctx+'/sftp/download.do?filePath='+encodeURIComponent(vpath)+'&_ts='+Date.now();
    el('er-pdfModalTitle').textContent = (_erReadonly && _erHstInfo && _erHstInfo.pdf)
      ? ('📄 이력 PDF — ' + (name||'') + ' (' + ((_erHstInfo.time)||'') + ')')
      : ('📄 ' + (name || '첨부 PDF'));
    // 열람 모드 버튼: 저장/파일선택 숨김, 교체검색(위너넷·읽기전용 아님)만 노출
    el('er-pdfGenSaveBtn').style.display='none'; el('er-pdfPickBtn').style.display='none';
    el('er-pdfModalReplace').style.display = (isWinner && !_erReadonly) ? '' : 'none';
    // iframe 새로 교체 — 같은 노드 재사용 시 두 번째 열기부터 간헐적으로 렌더 안 되는 문제 방지
    var old = el('er-pdfFrame'), nf = old.cloneNode(false);
    nf.removeAttribute('src');
    old.parentNode.replaceChild(nf, old);
    el('er-pdfLoading').style.display = 'flex';
    el('er-pdfLoading').textContent = 'PDF를 불러오는 중입니다…';
    el('er-pdfModal').style.display = 'flex';
    try{ _mrSyncPgMarks(); }catch(e){}   // 모달 위로 새 장·경계 표지가 겹치지 않게 걷음
    fetch(dlUrl, { credentials:'same-origin', cache:'no-store' })
      .then(function(r){ if(!r.ok) throw new Error('HTTP '+r.status); return r.blob(); })
      .then(function(b){
        if(seq !== _pdfSeq) return;                       // 이미 닫혔거나 새로 열림 → 무시
        if(_pdfObjUrl) URL.revokeObjectURL(_pdfObjUrl);   // 이전 URL 은 지금(새로 열 때) 정리
        _pdfObjUrl = URL.createObjectURL(new Blob([b], { type:'application/pdf' }));
        _erPdfApplyZoom();                            // 배율(#zoom) 프래그먼트를 붙여 src 설정
        el('er-pdfLoading').style.display = 'none';
      })
      .catch(function(e){
        if(seq !== _pdfSeq) return;
        el('er-pdfLoading').textContent = 'PDF를 불러오지 못했습니다('+(e&&e.message||'오류')+'). 닫고 다시 시도해 주세요.';
      });
  };
  /* 거래처 화면: 승인 확정본 PDF 를 클릭 없이 화면에 바로 펼친다(2026-08-03).
     모달(erPdfPreview)과 달리 페이지 안에 심어 두므로 닫아서 백지가 되는 일이 없다.
     다운로드와 같은 경로를 blob 으로 받아 objectURL 로 띄운다(자바·권한 로직 변경 없음). */
  var _hospPdfUrl = null;
  function _erHospPdfShow(){
    var wrap = el('er-hospPdfWrap'); if(!wrap) return;
    var fr = el('er-hospPdfFrame'), msg = el('er-hospPdfMsg');
    if(!pdfPath || norYn==='Y'){ wrap.style.display='none'; return; }   // 미첨부·PDF 미제공 병원 → 안내문만
    wrap.style.display='block'; fr.style.display='none';
    msg.style.display='block'; msg.textContent='보고서를 불러오는 중입니다…';
    fetch(ctx+'/sftp/download.do?filePath='+encodeURIComponent(pdfPath)+'&_ts='+Date.now(),
          { credentials:'same-origin', cache:'no-store' })
      .then(function(r){ if(!r.ok) throw new Error('HTTP '+r.status); return r.blob(); })
      .then(function(b){
        if(_hospPdfUrl) URL.revokeObjectURL(_hospPdfUrl);
        _hospPdfUrl = URL.createObjectURL(new Blob([b], { type:'application/pdf' }));
        fr.src = _hospPdfUrl + '#zoom=page-width';
        fr.style.display='block'; msg.style.display='none';
      })
      .catch(function(e){
        msg.textContent = '보고서를 불러오지 못했습니다('+((e&&e.message)||'오류')+'). 위 [다운로드]로 받아 보시거나 잠시 후 다시 시도해 주세요.';
      });
  }

  window.erPdfClose = function(){
    _pdfSeq++;                                            // 진행 중 fetch 무효화 (revoke 는 다음 열기에서)
    el('er-pdfModal').style.display = 'none';
    try{ _mrSyncPgMarks(); }catch(e){}                    // 모달 닫힘 → 새 장·경계 표지 복원
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
      if(_erReadonly){                        // 이력 열람(읽기전용): 편집·저장·승인·PDF첨부만 숨김 — 👁PDF보기·인쇄는 허용
        ['er-btnEdit','er-btnSave','er-btnApprove','er-btnPdf'].forEach(function(id){ var b=el(id); if(b) b.style.display='none'; });
        el('er-roleTag').textContent='이력 열람';
        var _sb=el('er-statusBadge'); if(_sb){ _sb.className='er-status er-new'; }
        var _st=el('er-statusText'); if(_st){ _st.textContent='읽기전용(이력 열람)'; }
        var _hi=el('er-hstInfo');             // 어느 이력을 보는지 칩 표시(유형·작성자·시각)
        if(_hi && _erHstInfo){
          var _lb=esc(_erHstInfo.label||'이력'), _mu=esc(_erHstInfo.user||''), _mt=esc(_erHstInfo.time||'');
          // 스냅샷(seq)이 없는 = 가장 최신 이력 → 그 시각의 결과물이 곧 현재 문구
          var _sfx = _erHstInfo.seq ? '' : ' · 현재(최신) 문구';
          _hi.innerHTML = '📜 이력 열람 · '+_lb+' <span class="er-hstmeta">'+((_mu||_mt)?('('+[_mu,_mt].filter(Boolean).join(' · ')+')'):'')+_sfx+'</span>';
          _hi.style.display='inline-flex';
        }
      }
      erFixToolbar();                         // 툴바 위치 확정
      setTimeout(erFixToolbar, 200);          // 앱 레이아웃(헤더/사이드바) 렌더 후 재보정
    }catch(e){ showErr((e&&e.message)||e); }
  })();

  function editables(){ return document.querySelectorAll('#evalReport .er-editable[data-key]'); }
  /* Ⅳ 우선 개선지표별 권고사항의 '개선방향'(recdir_*) 은 Ⅲ 의 개선방향과 헷갈린다는 사용자 확정(2026-07-29)에 따라
     위너넷·병원 누구도 편집하지 못한다. 저장된 문구의 표시와 수집(editables)은 그대로 두고 '편집 켜기'에서만 뺀다
     — 지표별 기본문구는 TPL_DIR(TBL_EVAL_REPORT_TPL dir_XX)로 관리한다. */
  function _erNoEditKey(e){ return (e.getAttribute('data-key')||'').indexOf('recdir_') === 0; }
  function editablesEdit(){ return Array.prototype.filter.call(editables(), function(e){ return !_erNoEditKey(e); }); }

  /* ── Ⅵ. 의무기록 점검 결과 — 담당자 수기 입력 (2026-07-22) ─────────────────
     ★점검 항목은 달마다 달라진다(유치도뇨관·욕창·배뇨 외에 다른 항목이 생길 수 있음).
       그래서 항목을 고정하지 않고 '소제목 + 표' 묶음을 추가·삭제·개명할 수 있게 했다.
     저장 = 컨테이너(#er-mrBody[data-key=mr_body]) innerHTML 통째로 →
       기존 경로(collectTexts/saveEvalReport)를 그대로 타므로 서버·DB 변경이 없다.
       항목 구성 자체가 그 달 보고서에 함께 저장된다. */
  function _mrHasContent(){
    var b=el('er-mrBody'); if(!b) return false;
    return !!(b.querySelector('table,img,p,div,li') || (b.textContent||'').trim());
  }
  /* ★내용이 있을 때만 Ⅵ 섹션을 보인다(2026-07-22 확정).
     점검 항목·양식은 병원마다 다르고 있을 수도 없을 수도 있다 → 시스템에 양식을 두지 않는다.
     편집 중에는 붙여넣어야 하므로 항상 보이고, 보기·인쇄에서만 숨긴다. */
  function erMrToggleSec(){
    var sec=el('er-sec6'); if(!sec) return;
    var show = _mrHasContent() || editing;
    sec.style.display = show ? '' : 'none';
    /* 비었을 때 편집 중이면 '여기에 넣으세요' 안내를 띄운다 —
       빈 칸만 있으면 어디에 붙여야 할지 알 수 없다. 안내는 내용이 아니므로 저장에 안 섞이게 별도 요소로 둔다. */
    var b=el('er-mrBody'), ph=el('er-mrPh');
    if(ph) ph.style.display = (editing && b && !_mrHasContent()) ? 'block' : 'none';
  }
  /* ── 되돌리기 (2026-07-22) ────────────────────────────────────────────────
     '비우기'는 이 장을 통째로 지운다. 여러 장 넣다가 마지막 하나만 취소하고 싶을 때
     쓸 수 없어, 넣기 직전 상태를 쌓아두고 한 단계씩 되돌린다. */
  var _mrUndo = [];
  function _mrSnap(){                                   // 바꾸기 직전 상태 저장
    var b=el('er-mrBody'); if(!b) return;
    _mrUndo.push(b.innerHTML);
    if(_mrUndo.length>20) _mrUndo.shift();              // 오래된 것부터 버림(메모리 보호)
    _mrUndoSync();
  }
  function _mrUndoSync(){
    var u=el('er-mrUndoBtn'); if(u) u.disabled = !_mrUndo.length;
  }
  /* 크기조절(➖➕ 연타)용 스냅샷 — 같은 동작이 1.2초 안에 이어지면 한 단계로 묶는다.
     클릭마다 쌓으면 ➖ 열 번에 실행취소도 열 번이라 되돌리기가 고역이고 20칸이 금방 찬다. */
  var _mrSnapKey='', _mrSnapAt=0;
  function _mrSnapOnce(key){
    var now=Date.now();
    if(key===_mrSnapKey && (now-_mrSnapAt)<1200){ _mrSnapAt=now; return; }
    _mrSnapKey=key; _mrSnapAt=now; _mrSnap();
  }
  window.erMrUndo = function(){
    if(!_mrCanEdit(false)) return;                 // 편집켜기 상태에서만 작동
    if(!_mrUndo.length) return;
    var b=el('er-mrBody'); if(!b) return;
    b.innerHTML=_mrUndo.pop();
    _mrSnapKey='';                               // 묶음 초기화 — 되돌린 직후의 조절은 새 단계로
    _mrDeselect(); _mrUndoSync(); markDirty(); erMrToggleSec();
    try{ erPaginate(); }catch(e){}
    toast('되돌렸습니다.');
  };
  /* F5·창닫기 보호 — 편집분이 미저장(dirty)이면 브라우저 확인창을 띄운다.
     그림을 잔뜩 넣고 저장 전에 무심코 F5 → 전부 소실되는 사고 방지(2026-07-22). */
  window.addEventListener('beforeunload', function(ev){
    if(!_erDirty || _erReadonly) return;
    ev.preventDefault(); ev.returnValue='';   // 표준 — 문구는 브라우저 기본 확인창이 표시
  });
  /* F5·Ctrl+R 차단(2026-07-22 요청) — 이 화면은 새로고침하면 보던 병원·월이 초기화되어
     '내용이 사라진' 것처럼 보인다. 키보드 새로고침은 막고 안내한다.
     브라우저 툴바의 새로고침 버튼까지는 못 막지만, 그 경우는 erCurCtx 복원이 받친다.
     보고서 화면이 실제로 보일 때만 작동 — 다른 화면에서는 F5 정상. */
  document.addEventListener('keydown', function(ev){
    if(ev.key!=='F5' && !(ev.ctrlKey && (ev.key==='r'||ev.key==='R'))) return;
    var er=document.getElementById('evalReport');
    if(!er || !er.offsetParent) return;                  // 화면에 없으면(숨김 포함) 관여 안 함
    ev.preventDefault(); ev.stopPropagation();
    toast('이 화면에서는 새로고침(F5)을 쓰지 않습니다. 다시 조회하려면 상단 년·월을 선택하세요.');
  }, true);
  // Ctrl+Z — 의무기록 영역에서만
  document.addEventListener('keydown', function(ev){
    if(!(ev.ctrlKey && (ev.key==='z'||ev.key==='Z'))) return;
    var b=el('er-mrBody'); if(!b || !editing) return;
    if(!ev.target || !ev.target.closest || !ev.target.closest('#er-mrBody, .er-mrbar')) return;
    if(!_mrUndo.length) return;
    ev.preventDefault(); erMrUndo();
  });

  window.erMrClear = function(){
    var b=el('er-mrBody'); if(!b) return;
    var n=b.querySelectorAll('img').length, t=b.querySelectorAll('table').length;
    var what=[]; if(n) what.push('그림 '+n+'개'); if(t) what.push('표 '+t+'개');
    if(!what.length && !(b.textContent||'').trim()){ toast('지울 내용이 없습니다.'); return; }
    erConfirm('<b>이 장의 내용을 모두 지웁니다.</b><br>'
      + (what.length ? '<span style="color:#c0392b">'+what.join(' · ')+'</span> 가 사라집니다.<br>' : '')
      + '<span style="color:#8a97a3;font-size:12px">하나만 취소하려면 ↩ 실행취소를, 그림 하나만 지우려면 그림을 클릭해 🗑 을 쓰세요.</span>',
      function(){
        _mrSnap();                                      // 비우기도 되돌릴 수 있게
        b.innerHTML=''; _mrDeselect(); markDirty(); erMrToggleSec();
        try{ erPaginate(); }catch(e){}
        toast('비웠습니다. ↩ 실행취소로 되돌릴 수 있습니다.');
      }, { title:'전체 비우기', icon:'warning', yes:'모두 지우기' });
  };

  /* ── 붙인 내용 확대/축소 ───────────────────────────────────────────────
     아래한글·워드에서 복사한 표는 원본 글자크기가 제각각이라 그대로 붙으면
     너무 크거나 작다. 원본 서식은 건드리지 않고 zoom 으로만 배율을 준다
     (transform:scale 은 뒤 여백이 남아 A4 분할이 어긋난다 — zoom 은 레이아웃도 같이 줄어든다). */
  var _mrZoom = 100, _MR_ZMIN = 30, _MR_ZMAX = 200, _MR_ZSTEP = 5;   // 5%씩
  function _erMrApplyZoom(){
    var b=el('er-mrBody'); if(b) b.style.zoom = (_mrZoom/100);
    var lb=el('er-mrZoomLbl'); if(lb) lb.textContent = _mrZoom + '%';
    try{ erPaginate(); }catch(e){}                        // 배율이 바뀌면 A4 장수도 달라진다
  }
  window.erMrZoom = function(d){
    _mrZoom=Math.min(_MR_ZMAX, Math.max(_MR_ZMIN, _mrZoom + d*_MR_ZSTEP));
    _erMrApplyZoom(); markDirty();
  };
  window.erMrZoomReset = function(){ _mrZoom=100; _erMrApplyZoom(); markDirty(); };
  /* 단위가 5%뿐이라 "미세하게 안 맞는" 경우를 못 잡았다(2026-08-03) —
     ① Shift+클릭 = 1% 미세조절  ② % 라벨 클릭 = 숫자로 직접 입력 */
  window.erMrZoomStep = function(ev, sign){
    var step = (ev && ev.shiftKey) ? 1 : _MR_ZSTEP;
    _mrZoom = Math.min(_MR_ZMAX, Math.max(_MR_ZMIN, _mrZoom + sign*step));
    _erMrApplyZoom(); markDirty();
  };
  // 숫자 입력 공통 — SweetAlert2 입력창(없으면 prompt 폴백). cb(정수) 는 유효값일 때만 호출
  function _erAskNum(title, cur, min, max, cb){
    var apply=function(v){ var n=parseInt(v,10); if(isFinite(n)){ cb(Math.min(max, Math.max(min, n))); } };
    if(typeof Swal==='undefined'){ var r=window.prompt(title+' ('+min+'~'+max+')', cur); if(r!=null) apply(r); return; }
    Swal.fire({ title:title, input:'number', inputValue:cur, inputAttributes:{min:min, max:max, step:1},
                heightAuto:false, width:380, customClass:{ popup:'er-swal', container:'er-swal-top' },
                showCancelButton:true, confirmButtonText:'적용', cancelButtonText:'취소', confirmButtonColor:'#2a7665' })
        .then(function(res){ if(res.isConfirmed && res.value!=null && res.value!=='') apply(res.value); });
  }
  window.erMrZoomInput = function(){
    _erAskNum('붙인 내용 배율(%)', _mrZoom, _MR_ZMIN, _MR_ZMAX, function(n){
      _mrZoom=n; _erMrApplyZoom(); markDirty();
    });
  };
  // Ctrl + 휠 = 붙인 내용 확대/축소 (그 영역 위에서만)
  document.addEventListener('wheel', function(ev){
    if(!ev.ctrlKey) return;
    /* ★그림을 골라 둔 상태에서는 Ctrl+휠을 확대/축소로 쓰지 않는다 (2026-08-03).
         Ctrl 은 그림 여러 장 고르기(Ctrl+클릭)에도 쓰인다. 그래서 Ctrl 을 누른 채 휠을 굴려
         다음 그림으로 내려가면 확대/축소가 걸려 "글자가 커졌다 작아졌다" 했다.
         고른 그림이 있으면 = 지금 고르는 중이라는 뜻이므로 휠은 그냥 스크롤로 흘려보낸다.
         (확대/축소는 조절바 ➖ ➕ 로 그대로 가능하고, 빈 곳을 눌러 선택을 풀면 Ctrl+휠도 되살아난다) */
    if(_mrSelImg || _mrSelSet.length) return;
    var b=el('er-mrBody'); if(!b || !ev.target || !ev.target.closest) return;
    if(!ev.target.closest('#er-mrBody') && !ev.target.closest('.er-mrbar')) return;
    ev.preventDefault(); erMrZoom(ev.deltaY<0 ? 1 : -1);
  }, { passive:false });

  // 붙여넣기 직후 — 섹션 표시·페이지 재분할. 서식은 그대로 두고(원본 표 모양 유지) 폭만 넘치지 않게 한다
  function _erMrBindPaste(){
    var b=el('er-mrBody'); if(!b || b._mrBound) return; b._mrBound=1;
    b.addEventListener('paste', function(){
      _mrSnap();                                 // 붙여넣기 직전 상태 저장
      setTimeout(function(){ markDirty(); erMrToggleSec(); try{ erPaginate(); }catch(e){} }, 30);
    });
    b.addEventListener('input', function(){ erMrToggleSec(); });
  }
  // ↔ 폭맞춤 — 아래한글 표는 고정폭이라 붙이면 오른쪽이 빈다. 켜면 본문 폭까지 늘린다
  window.erMrFit = function(){
    var b=el('er-mrBody'); if(!b) return;
    var on=b.classList.toggle('er-mrfit');
    var btn=el('er-mrFitBtn'); if(btn) btn.classList.toggle('er-on', on);
    markDirty(); try{ erPaginate(); }catch(e){}
  };

  /* ── 📂 파일에서 잘라오기 (2026-07-22) ────────────────────────────────────
     PDF·이미지를 화면에 그려놓고 마우스로 영역을 끌어 그 부분만 그림으로 넣는다.
     아래한글 원본을 통째로 옮기기 어렵거나(서식 깨짐) 일부만 필요할 때 쓴다.
     PDF 는 pdf.js 로 페이지를 캔버스에 렌더 → 같은 캔버스에서 잘라낸다(2배 확대 렌더로 선명도 확보). */
  var _crop = { canvas:null, ctx:null, img:null, pdf:null, page:1, pages:1, sx:0, sy:0, ex:0, ey:0, on:false, has:false };
  window.erMrPickFile = function(){
    if(!_mrCanEdit(false)) return;                 // 편집켜기 상태에서만 — 툴바와 같은 잠금
    el('er-mrFile').value=''; el('er-mrFile').click();
  };

  /* 상단 '🩺 의무기록' 버튼과 erMrGo 는 뺐다(2026-07-22 요청).
     탐색기를 강제로 열어서, 파일은 안 열고 넣어둔 그림만 손보려 할 때 방해가 됐다.
     이제 창구는 '✏️ 편집' 하나 — 편집을 켜면 erMrToggleSec 이 Ⅵ 장을 띄우고,
     탐색기는 그 장의 [📂 탐색기 열기] 를 눌렀을 때만 열린다. */

  /* 창 열기 — 위치는 지난번 자리를 기억한다(듀얼모니터에서 매번 옮기지 않게).
     처음에는 화면 오른쪽에 붙여 띄운다: 왼쪽 보고서를 보면서 잘라 넣는 흐름. */
  var _cropPos = null;
  function _cropOpen(){
    var m=el('er-cropModal'), box=m.querySelector('.er-modal-box');
    _mrDeselect();                                   // 그림 손잡이가 창 위에 겹쳐 뜨지 않게
    m.classList.add('er-open'); m.style.display='block';
    if(!_cropPos){
      var w=box.offsetWidth||900, h=box.offsetHeight||600;
      _cropPos={ left:Math.max(8, window.innerWidth-w-24), top:Math.max(8, (window.innerHeight-h)/2) };
    }
    _cropClamp(); _cropPlace();
  }
  function _cropPlace(){
    var box=el('er-cropModal').querySelector('.er-modal-box');
    box.style.left=_cropPos.left+'px'; box.style.top=_cropPos.top+'px';
  }
  /* 창이 화면 밖으로 나가 제목줄(=이동 손잡이)과 버튼을 못 잡는 일을 막는다.
     ★왼쪽으로는 절대 넘기지 않는다 — 넘기면 제목줄 왼쪽이 잘려 '창으로 빼기' 버튼이 사라진다. */
  function _cropClamp(){
    var box=el('er-cropModal').querySelector('.er-modal-box');
    var w=box.offsetWidth||900, h=box.offsetHeight||600;
    _cropPos.left=Math.min(Math.max(0, _cropPos.left), Math.max(0, window.innerWidth  - w));
    _cropPos.top =Math.min(Math.max(0, _cropPos.top ), Math.max(0, window.innerHeight - h));
  }
  window.erCropClose = function(){
    var m=el('er-cropModal'); m.classList.remove('er-open'); m.style.display='none';
    _crop.pdf=null; _crop.img=null; _crop.tops=null;
  };
  // 제목줄 드래그 = 창 이동
  (function bindCropDrag(){
    var m=el('er-cropModal'); if(!m) return;
    var head=m.querySelector('.er-modal-head'); if(!head) return;
    var dg=false, ox=0, oy=0;
    head.addEventListener('mousedown', function(ev){
      if(ev.target.closest('button')) return;              // 버튼 클릭은 이동 아님
      dg=true; ox=ev.clientX-_cropPos.left; oy=ev.clientY-_cropPos.top; ev.preventDefault();
    });
    document.addEventListener('mousemove', function(ev){
      if(!dg) return; _cropPos.left=ev.clientX-ox; _cropPos.top=ev.clientY-oy; _cropClamp(); _cropPlace();
    });
    document.addEventListener('mouseup', function(){ dg=false; });
    window.addEventListener('resize', function(){ if(_cropPos){ _cropClamp(); _cropPlace(); } });
  })();

  /* 표시 배율 — 캔버스 원본 픽셀은 그대로 두고 CSS 폭만 바꾼다.
     원본을 크게 유지해야 잘라낸 그림이 선명하고, 표시만 줄이면 창 안에서 보기 편하다.
     0 = 창 높이에 맞춤(자동). */
  var _cropZoom = 65, _CROP_ZMIN = 20, _CROP_ZMAX = 300, _CROP_ZSTEP = 5;   // 기본 65% · 5%씩 조절
  function _cropApplyZoom(){
    var c=el('er-cropCanvas'), st=el('er-cropStage'); if(!c || !c.width) return;
    var z=_cropZoom;
    if(!z){                                                    // 맞춤 = 창 높이에 들어가는 배율
      var avail=Math.max(120, st.clientHeight-28);
      z=Math.max(10, Math.min(100, Math.floor(avail/c.height*100)));
    }
    c.style.width=Math.round(c.width*z/100)+'px'; c.style.height='auto';
    var lb=el('er-cropZoomLbl'); if(lb) lb.textContent = _cropZoom ? (_cropZoom+'%') : '맞춤';
    _cropReset();
  }
  window.erCropZoom = function(d){
    var cur=_cropZoom||100;                                  // '맞춤' 상태에서 누르면 100% 기준으로
    _cropZoom=Math.min(_CROP_ZMAX, Math.max(_CROP_ZMIN, cur + d*_CROP_ZSTEP));
    _cropApplyZoom();
  };
  window.erCropZoomFit = function(){ _cropZoom=0; _cropApplyZoom(); };

  function _cropDrawImage(img){
    var c=el('er-cropCanvas');
    c.width=img.width; c.height=img.height;                    // 원본 해상도 그대로 보관
    c.getContext('2d').drawImage(img,0,0);
    _cropApplyZoom();
  }
  /* PDF 전 페이지를 세로로 이어 붙여 캔버스 1장으로 만든다.
     페이지 버튼으로 오가면 '5p 표 + 6p 표'처럼 걸친 부분을 한 번에 못 자른다.
     한 장으로 이으면 스크롤만으로 어디든 가고, 페이지 경계를 넘겨 잘라낼 수도 있다. */
  var _CROP_SC = 2.5, _CROP_GAP = 16;                          // 2.5배 렌더 = 잘라낸 그림이 흐리지 않게
  function _cropRenderPdfAll(){
    if(!_crop.pdf) return;
    var pdf=_crop.pdf, n=pdf.numPages, vps=[], tot=0, maxW=0;
    el('er-cropTitle').textContent='✂ 페이지를 그리는 중… ('+n+'장)';
    var chain=Promise.resolve();
    for(var i=1;i<=n;i++){
      (function(pn){ chain=chain.then(function(){
        return pdf.getPage(pn).then(function(pg){
          var vp=pg.getViewport({ scale:_CROP_SC });
          vps.push({ pg:pg, vp:vp, y:tot });
          tot += Math.ceil(vp.height) + _CROP_GAP; maxW=Math.max(maxW, Math.ceil(vp.width));
        });
      }); })(i);
    }
    chain.then(function(){
      var c=el('er-cropCanvas'); c.width=maxW; c.height=Math.max(1, tot-_CROP_GAP);
      var g=c.getContext('2d'); g.fillStyle='#fff'; g.fillRect(0,0,c.width,c.height);
      var seq=Promise.resolve();
      vps.forEach(function(o, idx){
        seq=seq.then(function(){
          g.save(); g.translate(Math.round((maxW-o.vp.width)/2), o.y);           // 폭 다르면 가운데
          return o.pg.render({ canvasContext:g, viewport:o.vp }).promise.then(function(){
            g.restore();
            if(idx < vps.length-1){                                             // 페이지 경계선
              g.fillStyle='#c8ccd2'; g.fillRect(0, o.y+o.vp.height+_CROP_GAP/2-1, c.width, 2); g.fillStyle='#fff';
            }
            el('er-cropTitle').textContent='✂ 페이지를 그리는 중… ('+(idx+1)+'/'+vps.length+')';
          });
        });
      });
      return seq.then(function(){
        _crop.tops = vps.map(function(o){ return o.y; });
        el('er-cropPgLbl').textContent='1 / '+vps.length;
        el('er-cropTitle').textContent='✂ '+(_crop.name||'')+' — 필요한 부분을 마우스로 끌어 선택하세요 (스크롤로 이동)';
        _cropApplyZoom();
        _cropBindScrollPage();
      });
    }).catch(function(){ erSwal('error','PDF 페이지를 그리지 못했습니다.',{title:'오류'}); });
  }
  // 스크롤 위치로 '몇 번째 장을 보고 있는지' 표시만 갱신
  function _cropBindScrollPage(){
    var st=el('er-cropStage'), c=el('er-cropCanvas');
    if(!st || st._pgBound) return; st._pgBound=1;
    st.addEventListener('scroll', function(){
      if(!_crop.tops || !_crop.tops.length || !c.height) return;
      var ratio=c.getBoundingClientRect().height/c.height;           // 표시배율
      var mid=(st.scrollTop + st.clientHeight/2)/ratio;
      var p=1; for(var i=0;i<_crop.tops.length;i++){ if(mid >= _crop.tops[i]) p=i+1; }
      el('er-cropPgLbl').textContent = p+' / '+_crop.tops.length;
    });
  }
  function _cropReset(){ _crop.has=false; el('er-cropRect').style.display='none'; el('er-cropOk').disabled=true; }

  el('er-mrFile').addEventListener('change', function(){
    var f=this.files && this.files[0]; if(!f) return;
    el('er-cropPager').style.display='none';
    if(f.type==='application/pdf'){
      if(!window.pdfjsLib){ erSwal('error','PDF 표시 라이브러리(pdf.js)를 불러오지 못했습니다. 이미지로 저장한 뒤 시도해 주세요.',{title:'오류'}); return; }
      f.arrayBuffer().then(function(buf){
        pdfjsLib.getDocument({ data:buf }).promise.then(function(pdf){
          _crop.pdf=pdf; _crop.pages=pdf.numPages; _crop.name=f.name;
          el('er-cropPager').style.display = pdf.numPages>1 ? '' : 'none';
          _cropOpen(); _cropRenderPdfAll();          // 전 페이지를 한 장으로 이어 그린다
        }).catch(function(){ erSwal('error','PDF를 열지 못했습니다.',{title:'오류'}); });
      });
    } else if(/^image\//.test(f.type)){
      var img=new Image();
      img.onload=function(){ el('er-cropTitle').textContent='✂ '+f.name+' — 필요한 부분을 마우스로 끌어 선택하세요';
                             _cropOpen(); _cropDrawImage(img); URL.revokeObjectURL(img.src); };
      img.src=URL.createObjectURL(f);
    } else erSwal('warning','PDF 또는 이미지 파일만 열 수 있습니다.');
  });

  // 캔버스 위에서 드래그 = 영역 선택
  (function bindCrop(){
    var wrap=el('er-cropWrap'), c=el('er-cropCanvas'), r=el('er-cropRect');
    if(!wrap||!c) return;
    function pos(ev){ var b=c.getBoundingClientRect(); return { x:ev.clientX-b.left, y:ev.clientY-b.top }; }
    function draw(){
      var x=Math.min(_crop.sx,_crop.ex), y=Math.min(_crop.sy,_crop.ey);
      var w=Math.abs(_crop.ex-_crop.sx), h=Math.abs(_crop.ey-_crop.sy);
      r.style.cssText='position:absolute;left:'+x+'px;top:'+y+'px;width:'+w+'px;height:'+h+'px;'
                    + 'border:2px dashed #ffd166;background:rgba(255,209,102,.18);pointer-events:none;display:block';
    }
    c.addEventListener('mousedown', function(ev){
      ev.preventDefault();                       // 캔버스 드래그가 '이미지 끌기'로 새지 않게
      var p=pos(ev); _crop.on=true; _crop.sx=_crop.ex=p.x; _crop.sy=_crop.ey=p.y; draw();
    });
    /* ★드래그 중 가장자리 자동 스크롤 (2026-08-03 "선택하고 아래로 내리면 스크롤되면서 선택되게").
         종전에는 보이는 범위까지만 선택됐다 — 커서가 뷰어(er-cropStage) 아래·위 가장자리(36px 안)에
         닿으면 그 방향으로 계속 스크롤하며 선택을 늘린다. 가장자리에 가까울수록 빠르게(4~28px/frame).
         좌표(_crop.sx…)는 캔버스 기준이라 스크롤돼도 어긋나지 않는다 — 매 프레임 pos() 재계산만 하면 된다. */
    var _acEv=null, _acRAF=0;
    function _autoScrollTick(){
      _acRAF=0;
      if(!_crop.on || !_acEv) return;
      var st=el('er-cropStage'); if(!st) return;
      var b=st.getBoundingClientRect(), E=36, dy=0, dx=0;
      if(_acEv.clientY > b.bottom-E) dy = Math.min(28, 4 + (_acEv.clientY-(b.bottom-E)));
      else if(_acEv.clientY < b.top+E) dy = -Math.min(28, 4 + ((b.top+E)-_acEv.clientY));
      if(_acEv.clientX > b.right-E)  dx = Math.min(28, 4 + (_acEv.clientX-(b.right-E)));
      else if(_acEv.clientX < b.left+E) dx = -Math.min(28, 4 + ((b.left+E)-_acEv.clientX));
      if(dy){ var t0=st.scrollTop;  st.scrollTop  = t0+dy; if(st.scrollTop===t0)  dy=0; }   // 끝에 닿으면 정지
      if(dx){ var l0=st.scrollLeft; st.scrollLeft = l0+dx; if(st.scrollLeft===l0) dx=0; }
      if(dy || dx){
        var p=pos(_acEv); _crop.ex=p.x; _crop.ey=p.y; draw();   // 스크롤로 캔버스가 움직였으니 좌표 갱신
        _acRAF=requestAnimationFrame(_autoScrollTick);
      }
    }
    // 캔버스를 벗어나도 이어지게 document 에 건다(가장자리까지 선택할 때 필요)
    document.addEventListener('mousemove', function(ev){
      if(!_crop.on) return; ev.preventDefault(); var p=pos(ev); _crop.ex=p.x; _crop.ey=p.y; draw();
      _acEv=ev;
      if(!_acRAF) _acRAF=requestAnimationFrame(_autoScrollTick);
    });
    document.addEventListener('mouseup', function(){
      _acEv=null; if(_acRAF){ cancelAnimationFrame(_acRAF); _acRAF=0; }
      if(!_crop.on) return; _crop.on=false;
      var w=Math.abs(_crop.ex-_crop.sx), h=Math.abs(_crop.ey-_crop.sy);
      _crop.has = (w>8 && h>8); el('er-cropOk').disabled = !_crop.has;
      if(!_crop.has) r.style.display='none';
    });
    c.addEventListener('dragstart', function(ev){ ev.preventDefault(); });
    // Ctrl + 휠 = 확대/축소
    el('er-cropStage').addEventListener('wheel', function(ev){
      if(!ev.ctrlKey) return; ev.preventDefault(); erCropZoom(ev.deltaY<0 ? 1 : -1);
    }, { passive:false });
  })();

  /* 잘라낸 조각의 '실제 크기'에 맞춰 초기 폭을 정한다(2026-07-22).
     무조건 100%로 넣으면 작게 잘라낸 조각까지 본문 폭 가득 늘어나 글자가 뭉개진다.
     A4 본문 폭 ≒ 180mm ≒ 680px 기준으로, 원본 픽셀이 그보다 작으면 그 비율만큼만. */
  function _mrInitWidth(px){
    var base = 680 * (_CROP_SC/2);               // 2.5배 렌더분 보정
    return Math.min(100, Math.max(25, Math.round(px/base*100)));
  }
  function _mrAppendImg(dataUrl, natW){
    var b=el('er-mrBody'); if(!b) return null;
    _mrSnap();                                   // 넣기 직전 상태 저장 → ↩ 실행취소로 하나씩 되돌림
    var im=document.createElement('img');
    im.src=dataUrl; im.alt='의무기록 점검 내용'; im.className='er-mrimg';
    var w0=_mrInitWidth(natW||680);
    im.style.width=w0+'%';
    im.setAttribute('data-w0', w0);              // ↺ 원래대로 의 기준 — mr_body innerHTML 에 같이 저장된다
    b.appendChild(im); return im;
  }
  function _cropInsertCanvas(cv){
    var im=_mrAppendImg(cv.toDataURL('image/png'), cv.width);
    markDirty(); erMrToggleSec();
    try{ erPaginate(); }catch(e){}
    // ★창을 닫지 않는다 — 5·6·7페이지를 이어서 잘라 넣을 때 매번 파일을 다시 고르는 불편을 없앤다
    if(im) toast('넣었습니다 ('+_mrImgW(im)+'%). 창은 열어두었으니 이어서 잘라 넣으세요.');
    _cropReset();
  }

  /* ── 넣은 그림 개별 크기 조절 (2026-07-22) ────────────────────────────────
     영역 전체 배율(➖100%➕)과 별개로, 그림 하나하나를 다른 크기로 둘 수 있어야 한다
     (표 하나는 크게, 참고 그림은 작게 등). 그림을 클릭하면 그 그림 위에 조절바가 뜬다. */
  /* 그림 선택 — _mrSelImg 는 '대표'(마지막에 누른 것, 조절바·손잡이 기준),
     _mrSelSet 은 함께 선택된 전체다. 종전에는 대표 하나뿐이라 새로 누르면 앞엣것이 그냥 풀렸다
     ("연속선택이 아니고 이전 것 무시하고 진행됨", 2026-08-03).
     · 그냥 클릭 = 하나만 선택(기존 동작 그대로)
     · Ctrl(⌘)·Shift + 클릭 = 선택에 더하기/빼기 → 스크롤해 내려가며 여러 장을 모을 수 있다
     · 조절바 버튼(➖ ➕ ↺ ⤓ 🗑)은 선택된 전체에 한 번에 적용된다
     · 2장 이상일 때 끌기 손잡이는 감춘다 — 어느 그림 기준인지 모호해지므로 버튼으로만 조절 */
  var _mrSelImg = null, _mrSelSet = [];
  function _mrSel(){ return _mrSelSet.length ? _mrSelSet : (_mrSelImg ? [_mrSelImg] : []); }
  function _mrSelAdd(im){ if(im && _mrSelSet.indexOf(im)<0){ _mrSelSet.push(im); im.classList.add('er-imgsel'); } }
  function _mrSelClear(){ _mrSelSet.forEach(function(x){ x.classList.remove('er-imgsel'); }); _mrSelSet=[]; }
  /* 그림을 만질 수 있는 상태인가 — 본문 글자와 똑같은 잠금 규칙을 적용한다.
     승인된 보고서는 er-btnEdit 이 잠기지만 그림은 클릭만으로 조절바가 떠서
     크기변경·삭제가 됐다(2026-07-22). 승인취소해야 손댈 수 있게 막는다. */
  function _mrCanEdit(quiet){
    if(_erReadonly){ if(!quiet) erSwal('info','읽기전용(이력 열람)입니다.'); return false; }
    if(approved){ if(!quiet) erSwal('warning','승인된 보고서는 수정할 수 없습니다.\n↩ 승인취소 후 진행하세요.'); return false; }
    if(!editing){ if(!quiet) erSwal('info','✎ 편집을 켠 뒤 수정할 수 있습니다.'); return false; }
    return true;
  }
  function _mrImgW(im){ return Math.round(parseFloat(im.style.width) || 100); }
  window.erImgSize = function(d){
    var sel=_mrSel(); if(!sel.length) return;
    if(!_mrCanEdit(false)) return;
    _mrSnapOnce('size');                         // 크기조절도 ↩ 실행취소 대상(2026-07-22)
    var w=100;
    sel.forEach(function(im){                    // 선택된 전체에 같은 증감폭 적용(각자 현재 크기 기준)
      w=Math.min(100, Math.max(20, _mrImgW(im)+d)); im.style.width=w+'%';
    });
    var lb=el('er-imgSzLbl'); if(lb) lb.textContent=_mrImgW(_mrSelImg||sel[0])+'%';
    markDirty(); _mrPlaceImgBar(); try{ erPaginate(); }catch(e){}
  };
  /* % 라벨 클릭 = 정확한 크기 직접 입력 (2026-08-03 "조절이 너무 미세하게 안 맞는다").
     여러 장을 Ctrl+클릭으로 잡고 입력하면 전부 같은 폭이 되어 '두 그림 크기 맞추기'가 한 번에 끝난다. */
  window.erImgSizeInput = function(){
    var sel=_mrSel(); if(!sel.length) return;
    if(!_mrCanEdit(false)) return;
    _erAskNum(sel.length>1 ? ('그림 '+sel.length+'장 크기(%) — 전부 같은 크기로') : '그림 크기(%)',
              _mrImgW(_mrSelImg||sel[0]), 15, 100, function(n){
      _mrSnapOnce('size');
      sel.forEach(function(im){ im.style.width=n+'%'; if(im.style.height && im.style.height!=='auto') im.style.height='auto'; });
      var lb=el('er-imgSzLbl'); if(lb) lb.textContent=n+'%';
      markDirty(); _mrPlaceImgBar(); try{ erPaginate(); }catch(e){}
    });
  };
  /* ⤓ 새 장에서 시작 (2026-07-22) — 그림 앞에서 페이지를 끊는다.
     표 여러 개를 넣으면 A4 경계에 걸쳐 두 장에 나뉘어 읽기 나쁘다.
     이 표시가 있는 그림은 항상 새 장 맨 위에서 시작한다.
     클래스로만 표시하므로 mr_body innerHTML 에 그대로 저장된다(서버 무변경). */
  /* '여기부터 새 장' 표지 알약 — 편집 중 화면에서 er-pgbreak 그림마다 위에 띄운다.
       mr_body 안에 넣으면 저장 HTML 에 섞이므로 body 직속 + position:fixed 로 띄우고
       스크롤·리사이즈·토글 때마다 다시 그린다(조절바와 같은 방식). */
  var _pgMarks=[], _erPageStarts=[], _erGuides=[];
  // PDF 미리보기 등 모달이 떠 있으면 표지·점선을 걷는다 — fixed 라 모달 '위에' 겹쳐 보였다(2026-08-03)
  function _erOverlayBlocked(){
    var pm=el('er-pdfModal'), cm=el('er-cropModal');
    return (pm && pm.style.display==='flex') || (cm && cm.style.display==='flex');
  }
  function _mrSyncPgMarks(){
    _pgMarks.forEach(function(m){ m.remove(); }); _pgMarks=[];
    if(!editing || _erOverlayBlocked()) return;
    // Ⅵ 그림뿐 아니라 본문 블록(지표 제목 등)의 새 장 표시도 함께(2026-08-03 "이미지 말고 이 내용도")
    Array.prototype.forEach.call(document.querySelectorAll('#evalReport .er-doc .er-pgbreak'), function(im){
      if(im.closest && im.closest('.er-autopage')) return;   // 화면 밖 A4 복제본(클래스가 복사됨)은 제외
      var r=im.getBoundingClientRect();
      if(r.width<2 || r.top<0 || r.top>window.innerHeight) return;   // 앵커(블록 위 변)가 화면 밖이면 숨김 — 종전 bottom 기준은 위로 스크롤되면 클램프로 창 맨 위에 들러붙었다(2026-08-03)
      var m=document.createElement('div'); m.className='er-pgmark';
      m.innerHTML='⤒ 여기부터 새 장<span class="x">✕</span>';
      m.title='클릭하면 새 장 지정이 해제됩니다';
      // ✕ 취소(2026-08-03 요청) — 알약을 눌러 바로 해제(그림·글 블록 공통)
      m.addEventListener('click', function(ev){
        ev.preventDefault(); ev.stopPropagation();
        im.classList.remove('er-pgbreak');
        _mrBrkBtnSync(false);
        toast('새 장 시작을 해제했습니다.');
        _mrSyncPgMarks(); try{ erPaginate(); }catch(e){}
      });
      document.body.appendChild(m);
      /* 점선·알약을 '페이지 폭' 기준으로 — 좁은 라벨(결과지표 등)도 넓은 박스와 같은 모양(2026-08-03).
         조상 탐색은 수동 루프(+.er-doc 폴백)로 — closest 가 못 찾는 경우에도 반드시 전체 폭이 잡히게 */
      var pg=null, anc=im.parentElement;
      while(anc && anc!==document.body){
        if(anc.classList && (anc.classList.contains('er-srcpage') || anc.classList.contains('er-page'))){ pg=anc; break; }
        anc=anc.parentElement;
      }
      if(!pg) pg=document.querySelector('#evalReport .er-doc');
      var pr = pg ? pg.getBoundingClientRect() : r;
      var lx = Math.round(pr.left + 24), lw = Math.max(60, Math.round(pr.width - 48));
      var dash=document.createElement('div'); dash.className='er-pgdash';
      dash.style.left = lx+'px'; dash.style.width = lw+'px';
      dash.style.top  = Math.round(Math.max(4, r.top-1))+'px';
      document.body.appendChild(dash); _pgMarks.push(dash);
      m.style.left=Math.round(Math.max(4, pr.left + pr.width/2 - m.offsetWidth/2))+'px';
      m.style.top =Math.round(Math.max(4, r.top-9))+'px';
      _pgMarks.push(m);
    });
    try{ _erGuideSync(); }catch(e){}
  }
  /* [경계 표지] 편집 중 '몇 장에서 시작하는 블록인지'를 원본 위에 파란 알약으로 표시(2026-08-03).
       erPaginate 가 화면 밖 A4 복제본을 채우며 기록한 _erPageStarts(각 장의 첫 원본 블록)를 그대로 쓰므로
       보이는 위치 = 실제 인쇄·PDF의 장 시작과 동일하다. 사용자는 이걸 보고 Alt+클릭/⤓ 로 조정하면 된다. */
  function _erGuideSync(){
    _erGuides.forEach(function(g){ g.remove(); }); _erGuides=[];
    if(!editing || !PAGE_ON || _erOverlayBlocked()) return;
    var root=el('evalReport'); if(!root || !root.classList.contains('er-paged')) return;
    var coverN = document.querySelector('#evalReport .er-doc > .er-srcpage.er-cover') ? 1 : 0;
    _erPageStarts.forEach(function(nd, i){
      if(!nd || !nd.getBoundingClientRect) return;
      var r=nd.getBoundingClientRect();
      if(r.width<2 || r.top<0 || r.top>window.innerHeight) return;
      var g=document.createElement('div'); g.className='er-pgline';
      g.textContent='📄 '+(i+1+coverN)+'장 시작';
      document.body.appendChild(g);
      g.style.left=Math.round(Math.max(4, r.left+8))+'px';
      /* 블록 <위쪽 여백>에 얹는다 — 종전 `r.top-9` 는 알약이 블록에 절반쯤 걸쳐
         '■ 유치도뇨관이 있는 환자분율' 같은 제목 글자를 가렸다(2026-08-11 지적). */
      g.style.top =Math.round(Math.max(4, r.top - g.offsetHeight - 2))+'px';
      _erGuides.push(g);
    });
  }
  /* ★본문 블록에도 '새 장에서' (2026-08-03 요청) — 편집 중 지표 제목(■)·소제목·장 제목을
       Alt+클릭 하면 그 블록부터 새 장에서 시작/해제 토글. 인쇄(break-before)와 PDF(강제 분할) 모두 적용.
       ※그림과 달리 저장 대상(innerHTML 오버라이드)이 아니라서 재조회하면 풀린다 —
         인쇄·PDF 직전에 지정해 쓰는 용도. */
  document.addEventListener('click', function(ev){
    if(!editing || !ev.altKey) return;
    /* 아무 데서나 지정 가능(2026-08-03) — 클릭 지점에서 '분할 단위 블록'까지 거슬러 올라가 표시한다.
         분할 단위 = 섹션(er-sec)·Ⅲ목록(er-sec3Body)·의무기록(er-mrBody)·페이지의 '직계 자식' 블록.
         문단 안 어디를 눌러도 그 문단이 속한 블록(지표 박스 등) 단위로 새 장이 걸린다. 표지는 제외. */
    if(!(ev.target && ev.target.closest)) return;
    var t = ev.target.closest('#evalReport .er-srcpage *');
    if(!t || ev.target.closest('#evalReport .er-cover')) return;
    while(t && t !== document.body){
      var p = t.parentElement;
      if(p && (p.classList.contains('er-sec') || p.id === 'er-sec3Body' || p.id === 'er-mrBody'
               || p.classList.contains('er-srcpage'))) break;
      t = p;
    }
    if(!t || t === document.body) return;
    /* 클릭이 블록 사이 '여백'에 떨어지면 t 가 컨테이너 자체가 된다(er-sec3Body 등) —
       그대로 표시하면 목록 전체 위 변에 알약이 붙어 엉뚱해 보인다(2026-08-03 "과정지표 눌렀는데 위에 뜸").
       → 컨테이너면 클릭한 세로 위치에 걸치는(없으면 바로 아래) 자식 블록으로 내려서 건다. */
    if(t.id === 'er-sec3Body' || t.id === 'er-mrBody' || t.classList.contains('er-sec') || t.classList.contains('er-srcpage')){
      /* 판정은 엄격하게(오차 없음) — 블록 '안'을 눌렀을 때만 그 블록. 블록 사이 여백이면 무조건
         '아래' 블록에 건다: '새 장' = "이 블록부터 새 장" 이므로 여백 클릭의 의도는 다음 블록이다
         (2026-08-03 "과정지표 위를 클릭했는데 그 위(약사 박스)로 감" — ±6px 오차가 위 블록을 잡던 것). */
      var pick = null, below = null;
      Array.prototype.forEach.call(t.children, function(ch){
        var rc = ch.getBoundingClientRect();
        if(ev.clientY >= rc.top && ev.clientY <= rc.bottom) pick = pick || ch;
        else if(!below && rc.top > ev.clientY) below = ch;
      });
      t = pick || below;
      if(!t) return;
    }
    ev.preventDefault(); ev.stopPropagation();
    var on = t.classList.toggle('er-pgbreak');
    _mrSyncPgMarks(); try{ erPaginate(); }catch(e){}
    toast(on ? '이 블록부터 새 장에서 시작합니다. (알약 ✕ 또는 Alt+클릭으로 해제)' : '새 장 시작을 해제했습니다.');
  }, true);
  /* 문구를 타이핑으로 고치면 길이가 변해 장 경계가 밀리는데, 종전에는 재계산이 안 돌아
     파란 'N장 시작' 표지가 실제와 어긋났다("매칭 안 됨") — 입력 멈춘 뒤 0.6초에 재분할·표지 갱신 */
  var _erRepagT = null;
  document.addEventListener('input', function(ev){
    if(!editing || !PAGE_ON) return;
    if(!(ev.target && ev.target.closest && ev.target.closest('#evalReport .er-srcpage'))) return;
    clearTimeout(_erRepagT);
    _erRepagT = setTimeout(function(){ try{ erPaginate(); }catch(e){} }, 600);
  });
  // 버튼 화살표 = 현재 상태(2026-08-03 요청): 지정됨 = ⤒(위, "이미 새 장") / 미지정 = ⤓(아래, "누르면 새 장으로")
  function _mrBrkBtnSync(on){
    var b=el('er-imgBrkBtn'); if(!b) return;
    b.classList.toggle('er-on', on);
    b.textContent = (on ? '⤒' : '⤓') + ' 새 장에서';
  }
  window.erImgBreak = function(){
    var sel=_mrSel(); if(!sel.length) return;
    if(!_mrCanEdit(false)) return;
    _mrSnap();                                   // 되돌리기 대상
    // 대표의 상태를 뒤집어 전체를 그 상태로 맞춘다(섞여 있어도 한 번에 정리됨)
    var on=!(_mrSelImg||sel[0]).classList.contains('er-pgbreak');
    sel.forEach(function(im){ im.classList.toggle('er-pgbreak', on); });
    _mrBrkBtnSync(on);
    markDirty(); _mrPlaceImgBar(); _mrSyncPgMarks(); try{ erPaginate(); }catch(e){}
    var n=sel.length>1 ? ('그림 '+sel.length+'장을 ') : '이 그림부터 ';
    toast(on ? (n+'새 장에서 시작합니다.') : '새 장 시작을 해제했습니다.');
  };
  /* ↺ 원래대로 — 넣었을 때의 크기·비율로 되돌린다.
     예전엔 style.height 만 'auto' 로 지웠는데, 세로를 안 건드리고 가로만 늘린 경우에는
     height 가 이미 auto 라 눌러도 아무 일이 없었다("비율복원 안됩니다", 2026-07-22).
     이제 넣을 때 기록해 둔 data-w0(처음 폭 %)까지 되돌리고, 무엇을 했는지 알려준다. */
  window.erImgRatio = function(){
    var sel=_mrSel(); if(!sel.length) return;
    if(!_mrCanEdit(false)) return;
    _mrSnap();                                   // 되돌리기 대상
    var changed=false;
    sel.forEach(function(im){
      if(im.style.height && im.style.height!=='auto'){ im.style.height='auto'; changed=true; }
      im.removeAttribute('height'); im.removeAttribute('width');   // 붙여넣은 그림의 크기 속성도 정리
      var w0=parseFloat(im.getAttribute('data-w0'));
      if(!w0 && im.naturalWidth) w0=_mrInitWidth(im.naturalWidth); // 예전에 넣어 기록이 없는 그림
      if(w0 && Math.abs(_mrImgW(im)-w0) >= 1){ im.style.width=Math.round(w0)+'%'; changed=true; }
    });
    var rep=_mrSelImg||sel[0];
    var lb=el('er-imgSzLbl'); if(lb) lb.textContent=_mrImgW(rep)+'%';
    if(!changed){ _mrUndo.pop(); _mrUndoSync(); toast('이미 처음 넣었을 때의 크기입니다.'); return; }   // 방금 쌓은 무의미 스냅샷 회수
    markDirty(); _mrPlaceImgBar(); try{ erPaginate(); }catch(e){}
    toast(sel.length>1 ? ('그림 '+sel.length+'장을 처음 크기·비율로 되돌렸습니다.')
                       : ('처음 크기('+_mrImgW(rep)+'%)·비율로 되돌렸습니다.'));
  };
  /* 그림 선택 해제 — 조절바·손잡이를 모두 감춘다.
     잘라오기 창이나 별도 창을 띄우면 그 위에 손잡이가 겹쳐 떠 있어 방해된다(2026-07-22). */
  // Ctrl+P(브라우저 메뉴 인쇄)는 erPrint 를 안 거친다 — 인쇄 직전 이벤트에서 '새 장' 알약을 확실히 걷는다
  window.addEventListener('beforeprint', function(){
    try{ Array.prototype.forEach.call(document.querySelectorAll('.er-pgmark'), function(m){ m.remove(); }); _pgMarks=[]; }catch(e){}
  });
  // ✕ 닫기 버튼 — 선택 해제와 동일(조절바·손잡이·새장 표지 정리). Esc 키로도 닫힌다.
  window.erImgBarClose = function(){ _mrDeselect(); };
  document.addEventListener('keydown', function(ev){
    if(ev.key==='Escape' && _mrSelImg) _mrDeselect();
  });
  function _mrDeselect(){
    _mrSelClear();
    if(_mrSelImg){ _mrSelImg.classList.remove('er-imgsel'); _mrSelImg=null; }
    var ib=el('er-imgBar'); if(ib) ib.style.display='none';
    ['er-imgHandle','er-imgHandleW','er-imgHandleL','er-imgHandleH'].forEach(function(id){
      var h=el(id); if(h) h.style.display='none';
    });
  }
  window.erImgDel = function(){
    var sel=_mrSel(); if(!sel.length) return;
    if(!_mrCanEdit(false)) return;
    var n=sel.length;
    erConfirm(n>1 ? ('선택한 그림 '+n+'장을 지우시겠습니까?') : '이 그림을 지우시겠습니까?', function(){
      _mrSnap();                                 // ↩ 실행취소로 되살릴 수 있게
      sel.forEach(function(im){ im.remove(); });
      _mrDeselect();
      markDirty(); erMrToggleSec(); try{ erPaginate(); }catch(e){}
      toast((n>1 ? (n+'장을 지웠습니다.') : '지웠습니다.')+' ↩ 실행취소로 되돌릴 수 있습니다.');
    }, { title:'그림 삭제', icon:'warning', yes:'삭제' });
  };
  function _mrPlaceImgBar(){
    var bar=el('er-imgBar'); if(!bar || !_mrSelImg) return;
    var r=_mrSelImg.getBoundingClientRect();
    /* ★선택한 그림이 스크롤로 화면 밖에 나가면 조절바를 감춘다 (2026-08-03 "스크롤 하면서 선택이 안 됨").
         종전에는 display:flex 를 무조건 켜고 top 을 Math.max(8,…) 로만 눌렀다. 그래서 그림이 위로
         사라져도 조절바가 화면 맨 위(8px)에 계속 떠 있었고, position:fixed · z-index 1400 이라
         그 아래에 있는 그림·본문이 클릭으로 잡히지 않았다(조절바가 클릭을 가로챔).
         손잡이(_mrPlaceHandle)는 이미 같은 조건으로 숨고 있었는데 조절바만 빠져 있었다. */
    if(r.width<2 || r.bottom<0 || r.top>window.innerHeight){ bar.style.display='none'; _mrPlaceHandle(); return; }
    bar.style.display='flex';
    /* 가로도 화면 안으로 당긴다 — transform:translateX(-50%) 라 좌우 끝에서는 절반이 잘려 나간다 */
    var halfW=(bar.offsetWidth||160)/2;
    var cx=Math.min(window.innerWidth-halfW-6, Math.max(halfW+6, r.left+r.width/2));
    bar.style.left=Math.round(cx)+'px';
    bar.style.top =Math.round(Math.max(8, r.top-40))+'px';
    // 2장 이상 골랐으면 개수를 함께 보여준다 — 버튼이 전체에 적용된다는 신호
    var _n=_mrSelSet.length;
    var lb=el('er-imgSzLbl'); if(lb) lb.textContent=(_n>1 ? (_n+'장 · ') : '')+_mrImgW(_mrSelImg)+'%';
    _mrBrkBtnSync(_mrSelImg.classList.contains('er-pgbreak'));  // '새 장에서' 눌림 상태·화살표(⤓/⤒) 반영
    _mrPlaceHandle();
  }
  /* ── 마우스로 끌어 크기 조절 (2026-07-22) ─────────────────────────────────
     그림 오른쪽 아래에 손잡이를 띄우고 끌면 폭이 바뀐다. 버튼(➖➕)보다 직관적이고
     원하는 크기에 한 번에 맞출 수 있다. 폭(%)만 바꾸고 높이는 auto — 비율이 유지된다. */
  function _mrPlaceHandle(){
    var hC=el('er-imgHandle'), hW=el('er-imgHandleW'), hL=el('er-imgHandleL'), hH=el('er-imgHandleH');
    if(!hC) return;
    var hide=function(){ [hC,hW,hL,hH].forEach(function(x){ if(x) x.style.display='none'; }); };
    if(!_mrSelImg){ hide(); return; }
    // 2장 이상 선택 = 어느 그림 기준으로 끄는지 모호하므로 손잡이는 감춘다(버튼으로만 조절)
    if(_mrSelSet.length>1){ hide(); return; }
    var r=_mrSelImg.getBoundingClientRect();
    if(r.width<2 || r.bottom<0 || r.top>window.innerHeight){ hide(); return; }   // 화면 밖
    /* 그림이 화면보다 길면 오른쪽 아래가 화면 밖으로 나가 손잡이를 잡을 수 없다.
       → 보이는 범위 안으로 끌어와 항상 잡히게 한다(2026-07-22). */
    var vb=Math.min(r.bottom, window.innerHeight-6);         // 보이는 아래끝
    var vr=Math.min(r.right,  window.innerWidth -6);         // 보이는 오른쪽끝
    var vmid=(Math.max(r.top,0)+vb)/2;                        // 보이는 세로 중앙
    /* 손잡이는 10px 정사각 — 선택 테두리 '위에 걸치게' 절반(5px)만 당긴다. */
    var HH=5;
    hC.style.display='block';                                 // 오른쪽 아래 모서리 = 비율유지
    hC.style.left=Math.round(Math.max(4, vr-HH))+'px';
    hC.style.top =Math.round(Math.max(4, vb-HH))+'px';
    // 그림이 짧으면 '오른쪽 가운데'와 '모서리'가 겹쳐 지저분해진다 → 겹칠 땐 감춘다
    if(hW){ hW.style.display=(vb-vmid < 16) ? 'none' : 'block';
      hW.style.left=Math.round(Math.max(4, vr-HH))+'px';
      hW.style.top =Math.round(Math.max(4, vmid-HH))+'px'; }
    // 왼쪽 가운데 — 오른쪽과 같은 규칙으로 배치. 그림 왼쪽이 화면 밖이면 보이는 범위로 당긴다.
    if(hL){ var vl=Math.max(r.left, 6);
      hL.style.display=(vb-vmid < 16 || vr-vl < 40) ? 'none' : 'block';   // 너무 좁으면 좌우가 붙어 지저분
      hL.style.left=Math.round(Math.max(4, vl-HH))+'px';
      hL.style.top =Math.round(Math.max(4, vmid-HH))+'px'; }
    if(hH){ hH.style.display='block';                         // 아래 가운데 = 세로 조절
      hH.style.left=Math.round(Math.max(4, (Math.max(r.left,0)+vr)/2-HH))+'px';
      hH.style.top =Math.round(Math.max(4, vb-HH))+'px'; }
  }
  /* 손잡이 3개 — 모서리(비율유지) / 오른쪽(가로만) / 아래(세로만).
     가로는 부모 폭 대비 %, 세로는 px 로 준다(폭이 바뀌어도 지정한 높이가 유지되게).
     mode: 'wh' | 'w' | 'h' */
  function _bindHnd(id, mode){
    var h=el(id); if(!h) return;
    var on=false, x0=0, y0=0, w0=0, h0=0, box0=1;
    h.addEventListener('mousedown', function(ev){
      if(!_mrSelImg) return;
      if(!_mrCanEdit(true)){ _mrDeselect(); return; }    // 승인됨/읽기전용이면 끌어도 안 바뀐다(조용히)
      _mrSnap();                                         // 드래그 한 번 = 실행취소 한 단계
      ev.preventDefault(); ev.stopPropagation();
      on=true; x0=ev.clientX; y0=ev.clientY;
      var r=_mrSelImg.getBoundingClientRect(); w0=r.width; h0=r.height;
      var p=_mrSelImg.parentNode;
      box0=(p && p.clientWidth) ? p.clientWidth : w0;
      document.body.style.userSelect='none';
    });
    document.addEventListener('mousemove', function(ev){
      if(!on || !_mrSelImg) return;
      if(mode!=='h'){                                        // 가로
        /* 왼쪽 손잡이(wl): 그림이 가운데 정렬(margin:0 auto)이라 폭이 Δ 늘면 왼쪽 변은 Δ/2 만 움직인다.
           손잡이가 커서를 그대로 따라오게 하려면 폭 변화를 2배로 잡고 부호를 뒤집어야 한다.
           (왼쪽으로 끌면 clientX 가 줄고 → 폭은 늘어야 하므로 −2배) */
        var dx=(ev.clientX-x0);
        var w=(mode==='wl') ? Math.max(40, w0 - dx*2) : Math.max(40, w0 + dx);
        var pct=Math.min(100, Math.max(15, Math.round(w/box0*100)));
        _mrSelImg.style.width=pct+'%';
        var lb=el('er-imgSzLbl'); if(lb) lb.textContent=pct+'%';
        if(mode==='wh') _mrSelImg.style.height='auto';       // 모서리 = 비율 유지
      }
      if(mode==='h'){                                        // 세로만
        var hh=Math.max(30, h0 + (ev.clientY-y0));
        _mrSelImg.style.height=Math.round(hh)+'px';
      }
      _mrPlaceImgBar();
    });
    document.addEventListener('mouseup', function(){
      if(!on) return; on=false; document.body.style.userSelect='';
      markDirty(); try{ erPaginate(); }catch(e){}             // 크기 확정 후 A4 재분할
    });
  }
  _bindHnd('er-imgHandle','wh'); _bindHnd('er-imgHandleW','w'); _bindHnd('er-imgHandleL','wl'); _bindHnd('er-imgHandleH','h');
  /* ★안전장치 — 손잡이를 끄는 동안 body 에 user-select:none 을 걸어 두는데(위 mousedown),
       창 밖에서 버튼을 떼거나 Alt+Tab 으로 빠져나가면 mouseup 을 못 받아 그 상태가 그대로 남는다.
       그러면 이후로 본문을 드래그해도 선택이 안 잡혀 '복사가 안 되는' 것처럼 보인다.
       창이 포커스를 잃거나 탭이 가려질 때 무조건 풀어 준다. */
  window.addEventListener('blur', function(){ document.body.style.userSelect=''; });
  document.addEventListener('visibilitychange', function(){ if(document.hidden) document.body.style.userSelect=''; });
  function _mrBindImgSelect(){
    var b=el('er-mrBody'); if(!b || b._imgBound) return; b._imgBound=1;
    b.addEventListener('click', function(ev){
      var im=(ev.target && ev.target.tagName==='IMG') ? ev.target : null;
      // 승인·읽기전용·편집꺼짐이면 아예 선택되지 않는다(조절바·손잡이도 안 뜬다).
      // ★조용히(quiet=true) — 보기 중에 그림을 클릭할 때마다 안내창이 떠서 성가셨다(2026-07-22)
      if(im && !_mrCanEdit(true)){ _mrDeselect(); return; }
      if(!im){ _mrDeselect(); return; }
      var add = ev.ctrlKey || ev.metaKey || ev.shiftKey;      // 더하기 선택
      if(add){
        var i=_mrSelSet.indexOf(im);
        if(i>=0){                                            // 이미 골라둔 것 → 빼기
          im.classList.remove('er-imgsel'); _mrSelSet.splice(i,1);
          if(_mrSelImg===im) _mrSelImg=_mrSelSet[_mrSelSet.length-1] || null;
          if(!_mrSelSet.length){ _mrDeselect(); return; }
        } else {
          if(!_mrSelSet.length && _mrSelImg) _mrSelAdd(_mrSelImg);   // 앞서 하나만 잡혀 있던 것도 집합에 편입
          _mrSelAdd(im); _mrSelImg=im;
        }
      } else {
        _mrSelClear();
        if(_mrSelImg) _mrSelImg.classList.remove('er-imgsel');
        _mrSelImg=im; im.classList.add('er-imgsel');
      }
      _mrPlaceImgBar();
    });
    // 스크롤·리사이즈하면 조절바·'새 장' 표지 위치도 따라간다
    window.addEventListener('scroll', function(){ if(_mrSelImg) _mrPlaceImgBar(); _mrSyncPgMarks(); }, true);
    window.addEventListener('resize', function(){ if(_mrSelImg) _mrPlaceImgBar(); _mrSyncPgMarks(); });
  }
  window.erCropInsert = function(){
    if(!_crop.has) return;
    var c=el('er-cropCanvas'), b=c.getBoundingClientRect();
    // 화면에서 끈 좌표(표시 픽셀) → 캔버스 원본 픽셀. 배율이 걸려 있으므로 반드시 보정한다
    var rx=c.width/b.width, ry=c.height/b.height;
    var x=Math.min(_crop.sx,_crop.ex)*rx, y=Math.min(_crop.sy,_crop.ey)*ry;
    var w=Math.abs(_crop.ex-_crop.sx)*rx, h=Math.abs(_crop.ey-_crop.sy)*ry;
    var out=document.createElement('canvas'); out.width=Math.max(1,Math.round(w)); out.height=Math.max(1,Math.round(h));
    out.getContext('2d').drawImage(c, x, y, w, h, 0, 0, out.width, out.height);
    _cropInsertCanvas(out);
  };
  /* 전체 넣기 — PDF 여러 장이면 '장별로 잘라' 여러 그림으로 넣는다.
     한 장짜리 긴 그림으로 넣으면 A4 분할 때 중간이 잘려 읽을 수 없다. */
  /* ── 🗗 창으로 빼기 (2026-07-22) ─────────────────────────────────────────
     브라우저 안 떠 있는 창은 브라우저 영역 밖으로 못 나간다(듀얼모니터에 못 걸침).
     그래서 window.open 으로 '진짜 별도 창'을 띄우고 캔버스를 그대로 옮겨 그린다.
     그 창에서 영역을 끌어 선택 → postMessage 로 잘라낸 그림을 부모(이 화면)에 보낸다. */
  var _cropWin=null;
  window.erCropPopout = function(){
    var c=el('er-cropCanvas'); if(!c || !c.width){ erSwal('warning','먼저 파일을 여세요.'); return; }
    var w=window.open('', 'erCrop', 'width=1100,height=900,left=60,top=40,menubar=no,toolbar=no,location=no,status=no,resizable=yes,scrollbars=yes');
    if(!w){ erSwal('warning','팝업이 차단되었습니다.<br>주소창 오른쪽의 <b>팝업 차단 아이콘</b>을 눌러 이 사이트의 팝업을 허용한 뒤 다시 시도해 주세요.',{title:'팝업 차단'}); return; }
    _cropWin=w;
    var tops=JSON.stringify(_crop.tops||[]), gap=_CROP_GAP, name=(_crop.name||'').replace(/</g,'');
    w.document.write(
      '<!doctype html><html><head><meta charset="utf-8"><title>✂ '+name+'</title><style>'
      +'html,body{margin:0;height:100%;font-family:"맑은 고딕",Malgun Gothic,sans-serif;background:#3a3f45;color:#fff}'
      +'#bar{position:sticky;top:0;z-index:5;display:flex;gap:6px;align-items:center;padding:8px 12px;background:#1f3864;font-size:13px}'
      +'#bar b{margin-right:auto;font-weight:700}'
      +'button{border:1px solid #7f93b5;background:#fff;color:#1f3864;border-radius:6px;padding:5px 10px;cursor:pointer;font-size:12.5px;font-weight:700}'
      +'button:disabled{opacity:.45;cursor:default}'
      +'#stage{overflow:auto;height:calc(100% - 76px);padding:12px;text-align:center}'
      +'#foot{position:fixed;left:0;right:0;bottom:0;height:34px;display:flex;align-items:center;gap:10px;'
      +'padding:0 12px;background:#f4f7fb;color:#5b6b80;font-size:12px;border-top:1px solid #d5dde8}'
      +'#foot span{margin-right:auto}'
      +'#wrap{position:relative;display:inline-block}'
      +'canvas{display:block;background:#fff;box-shadow:0 4px 18px rgba(0,0,0,.5);cursor:crosshair;user-select:none}'
      +'#rect{position:absolute;border:2px dashed #ffd166;background:rgba(255,209,102,.18);pointer-events:none;display:none}'
      +'</style></head><body>'
      +'<div id="bar"><b>✂ '+name+' — 필요한 부분을 마우스로 끌어 선택하세요</b>'
      +'<button onclick="zoom(-1)">➖</button><span id="zl" style="min-width:52px;text-align:center">맞춤</span>'
      +'<button onclick="zoom(1)">➕</button>'
      +'<button id="ok" disabled onclick="sendSel()">✔ 선택영역 넣기</button>'
      +'<button onclick="sendAll()" title="문서 전체를 장마다 그림 1개씩 모두 넣습니다">📄 전체 넣기</button>'
      +'<button onclick="window.close()">✕ 닫기</button></div>'
      +'<div id="stage"><div id="wrap"><canvas id="cv"></canvas><div id="rect"></div></div></div>'
      +'<div id="foot"><span>💡 필요한 부분을 <b>마우스로 끌어</b> 선택 → <b>✔ 선택영역 넣기</b> · 여러 번 반복할 수 있습니다</span></div>'
      +'<script>'
      +'var TOPS='+tops+', GAP='+gap+', Z=65, ZMIN=20, ZMAX=300, ZS=5;'
      +'var cv=document.getElementById("cv"), rc=document.getElementById("rect"), st=document.getElementById("stage");'
      +'var sx=0,sy=0,ex=0,ey=0,on=false,has=false;'
      +'function apply(){var z=Z; if(!z){var a=Math.max(120,st.clientHeight-24); z=Math.max(10,Math.min(100,Math.floor(a/cv.height*100)));}'
      +'cv.style.width=Math.round(cv.width*z/100)+"px";cv.style.height="auto";'
      +'document.getElementById("zl").textContent=Z?Z+"%":"맞춤";reset();}'
      +'function zoom(d){Z=Math.min(ZMAX,Math.max(ZMIN,(Z||100)+d*ZS));apply();}'
      +'function reset(){has=false;rc.style.display="none";document.getElementById("ok").disabled=true;}'
      +'function pos(e){var b=cv.getBoundingClientRect();return{x:e.clientX-b.left,y:e.clientY-b.top};}'
      +'function draw(){var x=Math.min(sx,ex),y=Math.min(sy,ey),w=Math.abs(ex-sx),h=Math.abs(ey-sy);'
      +'rc.style.cssText="position:absolute;left:"+x+"px;top:"+y+"px;width:"+w+"px;height:"+h+"px;'
      +'border:2px dashed #ffd166;background:rgba(255,209,102,.18);pointer-events:none;display:block";}'
      +'cv.addEventListener("mousedown",function(e){e.preventDefault();var p=pos(e);on=true;sx=ex=p.x;sy=ey=p.y;draw();});'
      +'document.addEventListener("mousemove",function(e){if(!on)return;var p=pos(e);ex=p.x;ey=p.y;draw();});'
      +'document.addEventListener("mouseup",function(){if(!on)return;on=false;'
      +'has=(Math.abs(ex-sx)>8&&Math.abs(ey-sy)>8);document.getElementById("ok").disabled=!has;if(!has)rc.style.display="none";});'
      +'st.addEventListener("wheel",function(e){if(!e.ctrlKey)return;e.preventDefault();zoom(e.deltaY<0?1:-1);},{passive:false});'
      +'function cut(x,y,w,h){var o=document.createElement("canvas");o.width=Math.max(1,Math.round(w));o.height=Math.max(1,Math.round(h));'
      +'o.getContext("2d").drawImage(cv,x,y,w,h,0,0,o.width,o.height);return {d:o.toDataURL("image/png"),w:o.width};}'
      +'function sendSel(){if(!has)return;var b=cv.getBoundingClientRect(),rx=cv.width/b.width,ry=cv.height/b.height;'
      +'var o=cut(Math.min(sx,ex)*rx,Math.min(sy,ey)*ry,Math.abs(ex-sx)*rx,Math.abs(ey-sy)*ry);'
      +'window.opener.postMessage({t:"erCrop",imgs:[o]},"*");reset();}'   /* 창은 그대로 — 이어서 잘라 넣는다 */
      +'function sendAll(){var n=(TOPS&&TOPS.length>1)?TOPS.length:1;'
      +'if(!confirm("전체 "+n+"장을 각각 넣으시겠습니까?\\n장마다 그림 1개로 들어가며, 필요 없는 장은 넣은 뒤 지울 수 있습니다."))return;var a=[];'
      +'if(TOPS&&TOPS.length>1){for(var i=0;i<TOPS.length;i++){var y=TOPS[i],h=(i+1<TOPS.length?TOPS[i+1]-GAP:cv.height)-y;'
      +'if(h>0)a.push(cut(0,y,cv.width,h));}}else a.push({d:cv.toDataURL("image/png"),w:cv.width});'
      +'window.opener.postMessage({t:"erCrop",imgs:a},"*");}'
      +'window.addEventListener("resize",function(){if(!Z)apply();});'
      +'<\/script></body></html>');
    w.document.close();
    // 캔버스 내용을 새 창으로 복사 (문서가 준비된 뒤)
    var tryDraw=function(){
      var t=w.document.getElementById('cv');
      if(!t){ setTimeout(tryDraw, 60); return; }
      t.width=c.width; t.height=c.height;
      t.getContext('2d').drawImage(c,0,0);
      if(w.apply) w.apply();
    };
    tryDraw();
    erCropClose();                                   // 안쪽 창은 닫는다 — 별도 창으로 옮겼으므로
    _mrDeselect();                                   // 그림 손잡이도 정리(별도 창 위에 겹쳐 뜨지 않게)
    toast('별도 창으로 열었습니다. 다른 모니터로 옮겨 쓰실 수 있습니다.');
  };
  // 별도 창에서 보낸 그림 받기 — 우리가 연 그 창에서 온 것만 받는다(다른 탭·사이트 메시지 무시)
  window.addEventListener('message', function(ev){
    if(!_cropWin || ev.source !== _cropWin) return;
    var d=ev.data; if(!d || d.t!=='erCrop' || !d.imgs || !d.imgs.length) return;
    d.imgs.forEach(function(o){ _mrAppendImg(o.d || o, o.w || 680); });   // 잘라낸 실제 폭에 맞춰 배치
    markDirty(); erMrToggleSec(); try{ erPaginate(); }catch(e){}
    toast(d.imgs.length+'장을 넣었습니다. 창은 열려 있으니 이어서 잘라 넣으세요.');
  });

  window.erCropAll = function(){
    var c=el('er-cropCanvas'), tops=_crop.tops;
    if(!tops || tops.length<2){ _cropInsertCanvas(c); return; }
    erConfirm('전체 <b>'+tops.length+'장</b>을 각각 넣으시겠습니까?<br>'
      + '<span style="color:#8a97a3;font-size:12px">장마다 그림 1개로 들어갑니다. 필요 없는 장은 넣은 뒤 🗑 로 지우면 됩니다.</span>',
      function(){
        for(var i=0;i<tops.length;i++){
          var y=tops[i], h=(i+1<tops.length ? tops[i+1]-_CROP_GAP : c.height) - y;
          if(h<=0) continue;
          var out=document.createElement('canvas'); out.width=c.width; out.height=Math.round(h);
          out.getContext('2d').drawImage(c, 0, y, c.width, h, 0, 0, out.width, out.height);
          _mrAppendImg(out.toDataURL('image/png'), out.width);
        }
        markDirty(); erMrToggleSec(); erCropClose();   // 전체 넣기는 할 일이 끝났으므로 닫는다
        try{ erPaginate(); }catch(e){}
        toast(tops.length+'장을 넣었습니다. 그림을 클릭하면 크기 조절·삭제할 수 있습니다.');
      }, { title:'전체 넣기', icon:'question', yes:'넣기' });
  };

  function erMrInit(){
    _erMrBindPaste(); _mrBindImgSelect(); _mrDeselect();
    _mrUndo=[]; _mrUndoSync();          // 다른 보고서를 열면 되돌리기 이력은 초기화
    _erMrApplyZoom();      // 저장분이 있으면 그대로 두고 배율만 적용
    var btn=el('er-mrFitBtn'), b=el('er-mrBody');
    if(btn && b) btn.classList.toggle('er-on', b.classList.contains('er-mrfit'));
    erMrToggleSec();
  }

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
  function markDirty(){
    if(!approved && !_erDirty){ _erDirty=true; updateBadge(); }
    _draftSave();          // 수정할 때마다 브라우저 초안 자동 보관 — F5 근본 보호(2026-07-22)
  }

  /* ── 미저장 초안 자동보관 (F5 근본해결, 2026-07-22) ─────────────────────────
     beforeunload 경고는 무시할 수 있어 근본 보호가 못 된다. 모든 수정은 markDirty 를
     지나므로 그때마다 편집분을 브라우저 IndexedDB 에 보관하고, 같은 보고서를 다시 열면
     복구를 제안한다. 그림(base64)이 수 MB 라 localStorage(약 5MB)로는 부족 → IndexedDB.
     · 키 = 병원+평가월 → 다른 보고서와 안 섞임        · 💾 저장 성공 시 초안 삭제
     · 복구를 거절하면 초안 삭제(매번 다시 묻지 않게)   · 읽기전용(이력 열람)은 제외 */
  var _draftDb=null, _draftTm=null;
  function _draftOpen(cb){
    if(_draftDb){ cb(_draftDb); return; }
    try{
      var rq=indexedDB.open('wnnEvalReportDraft',1);
      rq.onupgradeneeded=function(){ rq.result.createObjectStore('drafts'); };
      rq.onsuccess=function(){ _draftDb=rq.result; cb(_draftDb); };
      rq.onerror=function(){ cb(null); };
    }catch(e){ cb(null); }
  }
  function _draftKey(){ return hospCd+'_'+curYm; }
  function _draftPut(key){
    _draftOpen(function(db){
      if(!db){ try{ console.warn('[초안] 브라우저 저장소(IndexedDB)를 열 수 없습니다'); }catch(e){} return; }
      try{
        var texts=collectTexts();
        var rq=db.transaction('drafts','readwrite').objectStore('drafts').put({ ts:Date.now(), texts:texts }, key);
        rq.onsuccess=function(){ try{ console.log('[초안] 보관됨 '+key+' ('+texts.length+'개 영역)'); }catch(e){} };
      }catch(e){ try{ console.warn('[초안] 보관 실패', e); }catch(e2){} }
    });
  }
  /* ★즉시 기록 + 마무리 기록(leading + trailing).
     처음엔 0.8초 뒤에만 기록했는데, 그림을 넣고 곧바로 F5 하면 기록 전에 페이지가 죽어
     초안이 안 남았다. '나가기 직전(pagehide) 기록'도 실측 결과 커밋 전에 죽어 소용없음
     → 수정 순간 바로 한 번 쓰고(선두), 연속 수정은 0.8초 묶어 마지막 상태를 다시 쓴다. */
  var _draftLastPut=0;
  function _draftSave(){
    if(_erReadonly || !curYm){ try{ console.log('[초안] 보관 생략 (읽기전용='+_erReadonly+', curYm="'+curYm+'")'); }catch(e){} return; }
    var key=_draftKey();                                  // 예약 시점의 보고서 키로 고정 — 월 전환 직후
    var now=Date.now();
    if(now-_draftLastPut>1000){ _draftLastPut=now; _draftPut(key); }   // 선두 — 즉시 기록
    clearTimeout(_draftTm);                               // 지연 실행이 다른 보고서 키에 쓰는 것 방지
    _draftTm=setTimeout(function(){                       // 마무리 — 연타가 멎은 뒤 최종 상태 기록
      _draftTm=null;
      if(key!==_draftKey()) return;
      _draftLastPut=Date.now(); _draftPut(key);
    }, 800);
  }
  _draftOpen(function(){});                               // 사전열기 — 첫 기록이 즉시 커밋되게
  function _draftClear(){
    clearTimeout(_draftTm); _draftTm=null;
    _draftOpen(function(db){
      if(!db) return;
      try{ db.transaction('drafts','readwrite').objectStore('drafts').delete(_draftKey()); }catch(e){}
    });
  }
  function _draftCheck(){
    if(_erReadonly || !curYm) return;
    _draftOpen(function(db){
      if(!db) return;
      try{
        var rq=db.transaction('drafts').objectStore('drafts').get(_draftKey());
        rq.onsuccess=function(){
          var d=rq.result;
          try{ console.log('[초안] 확인 '+_draftKey()+' → '+(d?('있음('+new Date(d.ts).toLocaleTimeString()+')'):'없음')); }catch(e){}
          if(!d || !d.texts || !d.texts.length) return;
          var diff=d.texts.some(function(t){              // 서버 저장분과 같은 초안이면 조용히 정리
            var e=document.querySelector('#evalReport .er-editable[data-key="'+t.sectKey+'"]');
            return e && e.innerHTML !== t.content;
          });
          if(!diff){ _draftClear(); return; }
          var w=new Date(d.ts), hh=('0'+w.getHours()).slice(-2), mm=('0'+w.getMinutes()).slice(-2);
          erConfirm('저장하지 않은 작업분이 브라우저에 남아 있습니다.\n(마지막 수정 '+(w.getMonth()+1)+'/'+w.getDate()+' '+hh+':'+mm+')\n복구하시겠습니까?',
            function(){
              d.texts.forEach(function(t){
                var e=document.querySelector('#evalReport .er-editable[data-key="'+t.sectKey+'"]');
                if(e) e.innerHTML=t.content;
              });
              _erDirty=true; updateBadge();               // markDirty 를 안 거침 — 초안 재저장 불필요
              erMrToggleSec(); try{ erPaginate(); }catch(e){}
              toast('복구했습니다. 내용 확인 후 💾 저장을 눌러 주세요.');
            },
            { title:'미저장 작업분 복구', icon:'question', yes:'복구', no:'버리기',
              onNo:function(){ _draftClear(); toast('초안을 버렸습니다.'); } });
        };
      }catch(e){}
    });
  }
  function setStatus(st){
    approved = (st==='APPROVED');
    updateBadge();
    if(isWinner){
      el('er-btnApprove').textContent = approved ? '↩ 승인취소' : '✔ 승인';
      el('er-btnApprove').title = approved
        ? '승인을 취소하면 다시 편집이 가능합니다(거래처 공개·PDF첨부 해제)'
        : '③ 승인 — 그 시점 수치가 동결되고 거래처에 공개됩니다. 승인 후 ④ PDF첨부가 가능합니다.';
      el('er-btnEdit').disabled = approved;
      if(approved) _erEditOff();   // 승인 순간 편집모드·그림 조절바·손잡이를 모두 거둔다
    }
    try{ updatePdfUi(); }catch(e){}   // 승인/승인취소에 따라 PDF첨부(재생성) 버튼 노출 갱신
  }

  /* 편집 무조건 끄기 — erToggleEdit 은 맨 앞에서 approved/읽기전용이면 return 한다.
     그래서 '승인 직후'와 'PDF 생성 직전'(PDF는 승인해야만 가능)에 erToggleEdit 을 불러도
     편집모드가 안 꺼졌고, er-editmode 가 남은 채 캡처돼 📂파일에서 잘라오기 툴바가
     PDF에 그대로 찍혔다(2026-07-22). 이 자리들은 이 함수를 쓴다. */
  function _erEditOff(){
    try{ _mrDeselect(); }catch(e){}
    if(!editing) return;
    editing=false;
    el('evalReport').classList.remove('er-editmode');
    try{ erMrToggleSec(); }catch(e){}
    editablesEdit().forEach(function(e){ e.contentEditable='false'; });
    var b=el('er-btnEdit'); if(b){ b.textContent='✏️ 편집켜기'; b.classList.remove('er-on'); }
    try{ erPaginate(); }catch(e){}
    try{ _mrSyncPgMarks(); }catch(e){}   // '새 장' 표지 제거(편집 꺼짐 → editing=false 라 전부 걷힘)
  }
  window.erToggleEdit = function(){
    if(_erReadonly){ erSwal('info','이력 열람(읽기전용)입니다. 편집·저장·승인·PDF첨부는 목록에서 정상 진입해 주세요.'); return; }
    if(approved){ erSwal('warning','승인된 보고서는 편집할 수 없습니다. 승인 취소 후 편집하세요.'); return; }
    editing=!editing;
    el('evalReport').classList.toggle('er-editmode', editing);
    erMrToggleSec();   // Ⅵ — 편집 중에는 비어 있어도 보여야 붙여넣을 수 있다
    if(!editing) _mrDeselect();   // 편집 끄면 그림 선택·손잡이도 정리
    erPaginate();   // A4 분할 유지한 채 재분할 — 편집 종료 시 고친 문구 길이에 맞게 페이지 재배치
    editablesEdit().forEach(function(e){ e.contentEditable = editing?'true':'false'; });   // Ⅳ 권고(recdir_*)는 제외
    var b=el('er-btnEdit'); b.textContent=editing?'✏️ 편집끄기':'✏️ 편집켜기'; b.classList.toggle('er-on',editing);
    try{ _mrSyncPgMarks(); }catch(e){}   // 편집 켜면 '⤒ 여기부터 새 장' 표지 표시, 끄면 걷힘
    // 편집켜기 안내 토스트는 뺐다(2026-08-03 요청) — 매번 떠서 성가심. 사용법은 버튼 툴팁·mrbar 힌트로 충분.
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
    /* 지금 보는 보고서(병원·월) 기억 — F5 하면 목록이 넘겨준 원샷 컨텍스트가 사라져
       기본값(자기 코드·지난달)으로 열리며 '내용이 사라진' 것처럼 보였다(2026-07-22).
       이력 열람(읽기전용)은 일회성 화면이라 기억하지 않는다. */
    if(!_erReadonly){
      try{ sessionStorage.setItem('erCurCtx', JSON.stringify({ hospCd:hospCd, hospNm:hospNm, ym:curYm, ck:(cookie('s_hospid')||'').trim() }));
           console.log('[조회] '+hospCd+' '+curYm+' — 컨텍스트 기억'); }catch(e){}
    }
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
    // [보완1] P5 영역별 신뢰도 문구용 — 유치도뇨관(flag02)·신규욕창(03)·욕창관리(04) 오류 건수. 서버 변경 없음(같은 엔드포인트).
    function _aChk(flag){
      return jQuery.ajax({ url: ctx+'/main/select_assesCheck.do', type:'POST', dataType:'json',
                           data:{ hospCd:hospCd, jobYymm:curYm, jobFlag:flag } })
        .then(function(d){ return d; }, function(){ return jQuery.Deferred().resolve(null).promise(); });
    }
    var aFoley=_aChk('02'), aSore1=_aChk('03'), aSore2=_aChk('04');
    /* [N1] 항정(07) 실측 처방률 — 환자 목록(●=처방)에서 비율. 실패는 null 흡수.
         ★기간 = 다른 지표와 <동일한 기준>, 7월부터 누적 (2026-08-05 사용자 확정 "항정만 평가기간도 동일한 기준으로 이야기").
           · 7월 보고서 : 평가기간 자료가 아직 없어 전월(6월) 단월 — 정답지 27건 전부 이 방식
           · 8월~12월  : 당해 7월 ~ 전월을 월별로 모두 조회해 합산(분자·분모 인월 합) — 누적 처방률 */
    var _psyMonths = (function(){
      var mo = parseInt(curYm.substring(4,6),10), y = curYm.substring(0,4), a = [];
      if (mo <= 7) a.push(prevYmOf(curYm));
      else for (var m=7; m<mo; m++) a.push(y+('0'+m).slice(-2));
      return a;
    })();
    function _psyFetch(ym){
      return jQuery.ajax({ url: ctx+'/main/select_CategoryList.do', type:'POST', dataType:'json',
                           data:{ hospCd:hospCd, jobYymm:ym, cateCd:'07' } })
        .then(function(d){ return d; }, function(){ return jQuery.Deferred().resolve(null).promise(); });
    }
    /* [누적] 평가기간(당해 7월 ~ 당월) 누적 실적 — 2026-08-10 요청
         ★당월 표준화점수를 누적값에 그대로 쓰면 안 된다. 당월이 5점이어도 누적은 4점 이하일 수 있다.
           그래서 <분모·분자를 기간 합산>해 현황값·표준화구간·가중치를 따로 산출한다.
         select_Hosp_Indi 가 이미 SUM(DTORVAL)/SUM(NTORVAL) 기준으로 cal_avg·weigavg 를 돌려준다
         (EVALUATION_INDICATORS_VALUE — 월별 평균이 아니라 합산 기준. 새 쿼리를 만들지 않는다).
         7월 보고서는 누적=당월이라 조회하지 않는다. */
    var _cumFrom = curYm.substring(0,4)+'07';
    var aCum = (parseInt(curYm.substring(4,6),10) <= 7)
        ? jQuery.Deferred().resolve(null).promise()
        : jQuery.ajax({ url: ctx+'/main/select_Hosp_Indi.do', type:'POST', dataType:'json', traditional:true,
                        data:{ hosp_cd:[hospCd], stryymm:_cumFrom, endyymm:curYm } })
            .then(function(d){ return d; }, function(){ return jQuery.Deferred().resolve(null).promise(); });

    /* [전월 누적] 2026-08-11 — 종합점수를 누적 기준으로 바꿨으므로 전월 대비 비교도 <전월 누적>이라야 맞다.
         (종전엔 '전월 단월 합' 과 비교해, 누적으로 바꾸면 매달 큰 폭 상승/하락으로 잘못 읽힌다.)
       전월이 7월보다 앞이면(=당월 7월) 누적 자체가 없다. */
    var _prevYm = prevYmOf(curYm);
    var aPrevCum = (parseInt(curYm.substring(4,6),10) <= 7)
        ? jQuery.Deferred().resolve(null).promise()
        : jQuery.ajax({ url: ctx+'/main/select_Hosp_Indi.do', type:'POST', dataType:'json', traditional:true,
                        data:{ hosp_cd:[hospCd], stryymm:_cumFrom, endyymm:_prevYm } })
            .then(function(d){ return d; }, function(){ return jQuery.Deferred().resolve(null).promise(); });

    var aPsy = jQuery.when.apply(jQuery, _psyMonths.map(_psyFetch)).then(function(){
      var args = Array.prototype.slice.call(arguments);   // 값만 온다(위 then 이 이미 벗겼다) — 1개든 여러 개든 같은 모양
      var pn=0, pd=0;
      args.forEach(function(res){
        var data = (res && res.data) ? res.data : null;
        if (data) data.forEach(function(e){ pd++; if(String(e.psyOrderYn||'')==='●') pn++; });
      });
      return (pd>0) ? { from:_psyMonths[0], to:_psyMonths[_psyMonths.length-1],
                        n:pn, d:pd, rate:Math.round(pn/pd*10000)/100 } : null;
    });
    jQuery.when(aIndi, aCrit, aPrev, aBladder, aDash, aFoley, aSore1, aSore2, aPsy, aCum, aPrevCum).done(function(r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11){
      var res = r1[0];
      indicators = (res && res.data)? res.data.filter(function(r){ return r.cate_cd!=='99'; }) : [];
      buildCriteria(r2[0]);
      /* 전월 종합점수 — 당월과 <같은 잣대>로 만든다(2026-08-11):
           누적 대상 지표는 전월까지의 누적 가중치, 누적을 안 쓰는 지표(인력·약사·항정·DUR)는 전월 단월 가중치. */
      prevTotal = null;
      var pcMap = {};
      var pcData = (r11 && r11[0] && r11[0].data) || (r11 && r11.data) || null;
      if (pcData && pcData.length){
        pcData.forEach(function(e){
          if (!e || !e.cate_cd || e.cate_cd==='99') return;
          pcMap[e.cate_cd] = { dtor:n(e.ntortot), ntor:n(e.dtortot), weig:n(e.weigavg) };   // ★dtortot·ntortot 은 이름과 반대
        });
      }
      var pd = (r3 && r3.data) || [], pt = 0, pHas = false;
      pd.forEach(function(r){
        if(r.cate_cd==='99') return;
        var pc = (cumApplies(r.cate_cd) && pcMap[r.cate_cd] && pcMap[r.cate_cd].dtor>0) ? pcMap[r.cate_cd] : null;
        var v = pc ? n(pc.weig) : n(r.weigval);
        pt += v; if(v>0) pHas = true;
      });
      if(pHas) prevTotal = Math.round(pt*10)/10;
      _bladderGapN = 0;   // '분자제외' 표기된 배뇨 미체크 건만 집계(패드/기저귀 오류는 제외)
      var bd = (r4 && r4[0] && r4[0].data) || [];
      bd.forEach(function(e){ if(String(e.errName||'').indexOf('분자제외')>=0) _bladderGapN++; });
      _dashInd = (r5 && r5[0]) ? r5[0] : null;   // [C1·C2] 당월/누적/월별 점수
      // [보완1] 영역별 오류 건수 — 조회 실패(null)는 0으로 흡수 → 그 영역 문단은 생략된다
      var _cnt=function(rr){ var d=(rr && rr[0] && rr[0].data) || []; return d.length; };
      _errBladN  = bd.length;
      _errFoleyN = _cnt(r6);
      _errSoreN  = _cnt(r7) + _cnt(r8);
      /* [N1] 항정 실측 처방률 — aPsy 가 이미 {from,to,n,d,rate} 로 합산해 준다(대상 0명이면 null → 문장 생략) */
      _psyPrev = r9 || null;
      /* [누적] 지표코드별 누적 실적을 담아 둔다 — autoAna 가 당월 문장 뒤에 한 줄 더 붙인다 */
      _cum = null;
      var cdData = (r10 && r10[0] && r10[0].data) || (r10 && r10.data) || null;
      if (cdData && cdData.length){
        _cum = { from:_cumFrom, to:curYm, map:{} };
        cdData.forEach(function(e){
          if (!e || !e.cate_cd || e.cate_cd==='99') return;
          /* ★함정: select_Hosp_Indi 의 dtortot·ntortot 은 <이름과 반대>다.
             01~04(인력)만 이름대로이고, 나머지 지표는 dtortot=분자합·ntortot=분모합이다
             (매퍼 CASE 문에서 뒤집어 담는다 — 2026-08-10 실데이터로 확인). 여기서 바로잡아 담는다. */
          _cum.map[e.cate_cd] = { dtor:n(e.ntortot), ntor:n(e.dtortot), cal:n(e.cal_avg), weig:n(e.weigavg) };
        });
      }
      renderAll();
      loadSavedTexts();
    }).fail(function(){ erSwal('error','지표 자료 조회 중 오류가 발생했습니다.', {title:'오류'}); });
  };

  /* 종합·구조·진료 점수 — 2026-08-11 부터 <평가기간 누적> 기준(gotOf). 표지 예상 종합점수·등급의 원천이다. */
  function computeScores(){
    var st=0,md=0,tot=0;
    indicators.forEach(function(r){
      var w=gotOf(r); tot+=w;
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
  /* 구조영역 라벨 옆 '신고 기준' 표기(2026-07-30) — 차등제 마스터의 신고년도·분기.
     renderSec3 가 goal 도착 전에 먼저 그려질 수 있어, 자리(id)만 만들고 여기서 채운다. */
  var _erGoal = null;
  function _erQtagTxt(){
    if(!_erGoal) return '';
    var y=String(_erGoal.startyy||'').trim(), q=String(_erGoal.qterflag||'').trim();
    return (y && q) ? ('*'+y+'년 '+q+'분기 신고 기준 산출') : '';
  }
  function applyGoalDefault(goal){
    if(!goal) return;
    _erGoal = goal;
    var _tg=document.getElementById('erG10Qtag'); if(_tg) _tg.textContent=_erQtagTxt();
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
      // 구조지표는 필요 인력 수치(staffNeed)를 우선 표기 — 「57일 추가 인력 필요(최소 1인 이상)」(2026-07-30)
      var room = (x.fg==='10' ? (staffNeed(x) || TPL_ROOM[x.cd] || '') : (TPL_ROOM[x.cd]||'')) + (i<2 ? ' (최우선)' : '');
      var gapCls = i<2 ? 'er-gaphl' : 'er-b-bad';                   // 최우선(상위2) 부족분 = 연분홍 배경 강조(원본)
      return '<tr><td>'+(i+1)+'</td><td class="er-l">'+esc(x.nm)+'</td><td>'+areaNm(x.fg)+'</td><td class="er-num">'+fnum(x.w)+'</td><td class="er-num">'+f1(x.got)+'</td><td class="er-num '+gapCls+'">'+f1(x.gap)+'</td><td class="er-l">'+esc(room)+'</td></tr>';
    }).join('') : '<tr><td colspan="7" style="color:#a7b1c0;">부족점수가 있는 지표가 없음.</td></tr>';
    // ※ 비고(원본 문구 + 실제 수치) — 편집 저장본이 있으면 유지
    if(!savedKeys['pri_note'] && pri.length){
      var totGapAll = indicators.reduce(function(a,r){ return a + Math.max(0, n(r.stdweig)-gotOf(r)); }, 0);
      var t2 = pri.slice(0,2), t2gap = t2.reduce(function(a,x){ return a+x.gap; }, 0);
      var pe = document.querySelector('#evalReport [data-key="pri_note"]');
      if(pe) pe.textContent = '※ 부족점수 = 가중치(만점) − 현재 획득점수. 가중치가 큰 결과지표('+t2.map(function(x){return x.nm;}).join('·')+') '+t2.length+'개 항목만으로 전체 부족점수 '+f1(totGapAll)+'점 중 '+f1(t2gap)+'점을 차지 → '+goalGradeVal()+' 달성의 핵심 지렛대임.';
    }
    renderTable2();
    renderSec3();
    renderSec5();
    captureAuto();   // 자동 생성 문구 스냅샷 — 저장 시 "실제 편집분"만 걸러내는 기준
  }

  // ===== 자동 문구 스냅샷(AUTO) — 렌더 직후의 기본값. 저장 시 이 값과 다른 것(=사용자 편집)만 DB 저장.
  //   (예전엔 자동 문구까지 통째로 저장돼, 다음 조회 때 옛 수치·옛 형식이 새 자동 문구를 덮는 문제가 있었음)
  var AUTO = {};
  function captureAuto(){
    AUTO = {};
    editables().forEach(function(e){
      var k=e.getAttribute('data-key');
      /* ★mr_body(Ⅵ 의무기록)는 절대 넣지 않는다 — 자동 생성 문구가 아니라 순수 사용자 자료다.
         넣으면 재렌더 후 captureAuto 가 '넣어둔 그림'을 자동값으로 오인 → 저장에서 제외
         → 서버가 DELETE 후 재INSERT 라 DB 행까지 지워져 F5 하면 통째로 사라졌다(2026-07-22). */
      if(k==='mr_body') return;
      AUTO[k] = e.innerHTML;
    });
  }

  // Ⅴ 권장 개선 시나리오(원본 PDF 형식) — 부족분 상위 4개 자동:
  //   최우선(상위 2)=+2구간, 나머지=+1구간(최대 5구간) 목표 → 상승분·개선 후 예상 종합점수·현재vs목표 비교표 자동 계산
  function renderSec5(){
    var top = topGaps(4), rows='', upStruct=0, upCare=0;
    top.forEach(function(x,i){
      var r=x.r, s=sOf(r)||1, tz=Math.min(5, s+(i<2?2:1));
      var tgt=Math.min(x.w, x.w/5*tz), up=Math.max(0, tgt-x.got);
      if(r.cate_fg==='10') upStruct+=up; else upCare+=up;
      rows += '<tr><td>'+(i+1)+(i<2?' <span style="font-size:10px;">핵심</span>':'')+'</td>'
            + '<td class="er-l">'+esc(x.nm)+'</td><td class="er-num">'+calDispOf(r)+'</td><td>'+tz+'구간</td>'
            + '<td class="er-num">'+f1(x.got)+'</td><td class="er-num">'+f1(tgt)+'</td><td class="er-b-good er-num">+'+f1(up)+'</td></tr>';
    });
    el('er-roadBody').innerHTML = rows || '<tr><td colspan="7" style="color:#a7b1c0;">개선 대상 지표가 없음.</td></tr>';
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

  /* 저장된 편집 문구가 <옛 수치를 박제하고 있는지> 판정 (2026-08-11)
       — 저장본이 있으면 자동 문구를 안 만드는데, 그 문장에 점수가 적혀 있으면 값이 바뀌어도 그대로 남는다.
         실제로 카드는 73.4점(4등급)인데 핵심 진단은 "종합점수 75.2점은 3등급" 이라고 말했다(보고서 28).
     ★판정은 <그 수치를 말하고 있을 때만> 한다:
        · 문장에 `종합점수 NN점` 같은 표현이 아예 없으면  → 손대지 않는다(점수를 뺀 채 다듬은 문장 보존)
        · 있는데 지금 값과 다르면                        → 옛 값 박제로 보고 자동 문구로 다시 만든다
        · 있고 값도 같으면                               → 다듬은 문장 그대로 둔다
     ※0.05 이내 차이는 같은 값으로 본다(소수 첫째 자리 반올림 표기 때문). */
  function _staleNum(el, re, val){
    if(!el) return false;
    var m = re.exec(el.textContent || '');
    if(!m) return false;
    return Math.abs(parseFloat(m[1]) - n(val)) > 0.05;
  }

  // 목표점수/목표등급 의존 요약(부족 카드 + 가로 등급표 + 핵심진단 자동문구) — 목표값(DOM) 갱신 후 재호출
  function renderGoalSummary(){
    var goalScore = goalScoreVal(), goalGrade = goalGradeVal();
    el('er-gapGoalScore').textContent = goalScore;
    el('er-gapGoalGrade').textContent = goalGrade;
    var gap = Math.round((goalScore - scores.total)*10)/10;
    el('er-gapScore').textContent = gap>0 ? '+'+gap : '0';   // 목표 초과 달성(음수)은 0으로 표시 (2026-07-23 사용자)
    var bands=[['1등급','87 ~ 100'],['2등급','79 ~ 87 미만'],['3등급','74 ~ 79 미만'],['4등급','64 ~ 74 미만'],['5등급','64 미만']];   // 2026-07-30 구간 변경
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
    /* 핵심 진단 — 원본 문구에 실제 수치 자동 채움.
       ★2026-08-11: 편집 저장본이 있어도 <문장 속 종합점수가 지금 값과 다르면> 다시 만든다.
         점수는 병원이 고칠 성질의 값이 아니라 산출된 사실값이다. 종전에는 저장본을 그대로 둬서
         카드는 73.4점(4등급)인데 문장은 75.2점(3등급)이라고 말하는 일이 생겼다(실제 보고서 28).
         문장을 다듬어 저장한 경우라도 <점수만 맞으면> 그 문장을 그대로 둔다. */
    var curRange = (bands.filter(function(b){ return b[0]===cur; })[0]||['',''])[1];
    var _dcEl = document.querySelector('#evalReport [data-key="diag_core"]');
    var _dcStale = !!(!approved && savedKeys['diag_core'] && _staleNum(_dcEl, /종합점수\s*([\d.]+)\s*점/, scores.total));
    if(!savedKeys['diag_core'] || _dcStale){
      var e1=_dcEl;
      if(e1){
        e1.innerHTML = (gap>0)
          ? '현재 종합점수 <b class="er-num">'+f1(scores.total)+'점</b>은 <b>'+cur+' 구간('+curRange+')</b>에 해당함. 안정적인 <b>'+esc(goalGrade)+' 달성·유지</b>를 위해서는 구간 상단인 <b>'+goalScore+'점</b>을 목표로 하며, 이는 현재 대비 <b class="er-b-bad">+'+gap+'점</b> 향상이 필요함.'
          : '현재 종합점수 <b class="er-num">'+f1(scores.total)+'점</b>으로 목표('+esc(goalGrade)+'·'+goalScore+'점) 수준을 충족하고 있음. 유지 관리와 상위 등급 도약 여지에 대한 점검이 필요함.';
        AUTO['diag_core'] = e1.innerHTML;
      }
    }
    /* 같은 이유로 각주(부족점수)도 수치가 어긋나면 다시 만든다 */
    var _dnEl = document.querySelector('#evalReport [data-key="diag_note"]');
    var _dnStale = !!(!approved && savedKeys['diag_note'] && _staleNum(_dnEl, /\+\s*([\d.]+)\s*점/, 87-scores.total));
    if(!savedKeys['diag_note'] || _dnStale){
      var e2=_dnEl;
      if(e2){
        e2.textContent = '※ 기존 표준(1등급·87점)을 목표로 하면 부족점수가 +'+f1(87-scores.total)+'점으로 과대 산정됨. 본 보고서는 병원 여건을 고려한 단계적 목표('+goalGrade+') 기준으로 부족점수와 개선 로드맵을 재산정함.';
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
    /* 누적 기준(2026-08-11) — 총평·권고의 "N명 개선 시 +Δ점" 도 평가에 반영되는 누적 분모·분자로 따진다 */
    var cd=r.cate_cd, w=n(r.stdweig), got=gotOf(r), s=sOf(r), c=cumOf(r);
    var dtor=c? n(c.dtor) : n(r.dtorval), ntor=c? n(c.ntor) : n(r.ntorval);
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
    var cd=r.cate_cd, _c=cumOf(r);
    var dtor=_c? n(_c.dtor) : n(r.dtorval), ntor=_c? n(_c.ntor) : n(r.ntorval);   // 누적 기준(2026-08-11)
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
    if(d.need) return d.need+'명 추가 '+d.dir+' 시 '+d.newPct+'%로 표준화 '+d.nz+'점·가중치 '+f1(d.newGot)+'점으로 종합점수가 약 +'+f1(d.dW)+'점 상승 가능함';
    return '표준화 '+d.nz+'점 진입 시 가중치 '+f1(d.newGot)+'점으로 종합점수가 약 +'+f1(d.dW)+'점 상승 가능함';
  }

  // [★1] '여유 한도 / 하락 경고' 문형 — 낮을수록 우수 %지표(유치도뇨관05·신규욕창10·장기입원14).
  //   simNeed(높을수록 우수, '개선 명수')의 대칭. 담당자 수기 근거(세밀분석 §6-2):
  //   · 제주대림 유치도뇨관 "0.5% 미만(5점) 유지 = 최대 2명 허용, 이미 5명으로 초과"  → (A) 최우수 미달·초과형
  //   · 여수시립 신규욕창   "1명 추가 발생 시 누적 0.31%로 4점 하락"                    → (B) 현재 구간 하락 경고형
  //   화면값(dtorval·ntorval·CRIT_ALL[end]=구간 상한·stdweig)만으로 조립. PI(07)·1인당(01~03)·재직/DUR(04·08)은 제외.
  function simRoomLower(r){
    var cd=r.cate_cd, _c=cumOf(r), s=sOf(r), w=n(r.stdweig);                       // 누적 기준(2026-08-11)
    var dtor=_c? n(_c.dtor) : n(r.dtorval), ntor=_c? n(_c.ntor) : n(r.ntorval);
    if(!IS_LOWER[cd] || UNIT_PERSON.indexOf(cd)>=0 || NOT_HEADCOUNT.indexOf(cd)>=0 || cd==='07' || !(dtor>0) || !(s>=1)) return null;
    var u=unitOf(cd), bandS=null, band5=null;
    (CRIT_ALL[cd]||[]).forEach(function(z){ if(z.s===s) bandS=z; if(z.s===5) band5=z; });
    // (A) 최우수(5점) 미달 — '이미 초과' 형
    if(s<5 && band5){
      var max5=Math.floor(band5.end*dtor/100);
      if(ntor>max5)
        return '누적 분모 '+esc(fnum(dtor))+'명 기준 표준화 5점('+fnum(bndUp(band5.end))+u+' 미만)에는 '+max5+'명 이하가 요구되나 현재 '+esc(fnum(ntor))+'명으로 초과되어 '+s+'점에 해당하므로, 해당 건의 기록·해제(제거) 관리 강화가 필요함';
    }
    // (B) 현재 구간 하락 경고 — 여유 한도형
    if(s>=2 && bandS){
      var maxStay=Math.floor(bandS.end*dtor/100), room=maxStay-ntor, loss=f1(w/5);
      if(room<=0)
        return '현황 '+calDispOf(r)+'로 표준화 '+s+'점 구간 상한('+fnum(bandS.end)+u+')에 도달해 있어, 1건만 추가로 발생해도 표준화 '+(s-1)+'점(가중치 −'+loss+'점)으로 하락할 수 있음';
      var nextPct=fnum(Math.round((maxStay+1)/dtor*10000)/100);
      return '누적 분모 '+esc(fnum(dtor))+'명 기준 '+maxStay+'명까지 표준화 '+s+'점 유지가 가능하나(현재 '+esc(fnum(ntor))+'명, 여유 '+room+'명), '+(room+1)+'건째 발생 시 '+nextPct+'%로 표준화 '+(s-1)+'점(가중치 −'+loss+'점) 하락할 수 있음';
    }
    return null;
  }

  // P3 삽입용 — 낮을수록 우수 지표 중 하락 리스크가 가장 큰(여유 명수 최소) 1개를 골라 경고절 생성
  function roomRiskTxt(){
    var best=null;
    indicators.forEach(function(r){
      var t=simRoomLower(r); if(!t) return;
      var cd=r.cate_cd, _c=cumOf(r), s=sOf(r), bandS=null;                          // 누적 기준(2026-08-11)
      var dtor=_c? n(_c.dtor) : n(r.dtorval), ntor=_c? n(_c.ntor) : n(r.ntorval);
      (CRIT_ALL[cd]||[]).forEach(function(z){ if(z.s===s) bandS=z; });
      var room = bandS ? (Math.floor(bandS.end*dtor/100)-ntor) : 999;
      if(room<0) room=0;
      if(!best || room<best.room) best={ room:room, nm:indiNm(r), txt:t };
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
    return ' '+nms.join('과(와) ')+'을(를) 함께 한 단계씩 개선할 경우 종합점수는 약 +'+f1(sum)+'점 상승하여 '+f1(neo)+'점('+gradeOf(neo)+') 수준까지 도달 가능함.';
  }

  /* [보완3] 등급 상향 '개선 우선순위' 블록 — 라이브러리 202607 Part 5-2.
       담당자는 목표까지 부족점수가 큰 병원에 순위를 수치로 제시한다:
         "목표까지 11.5점 부족 — 1순위 욕창개선 4점 구간 → +3.2점(최소 2명) / 2순위 ADL → +2.4점(최소 7명)
          / 3순위 간호인력 → +1.5점 / 총 획득 가능 7.1점 → 2등급 가능(82.6점)"
       topGaps 순위(진료영역 → 구조영역 → 지역사회복귀율)를 그대로 써서 진료지표가 앞에, 구조지표가 뒤에 온다.
       C4(sumTopSimTxt, 상위 2지표 동시개선)와 결론이 겹치므로 이 블록이 나오면 C4는 생략한다.
       부족점수 3점 미만이면 순위를 늘어놓을 국면이 아니라 '' 반환(기존 C4 유지). */
  function goalRankTxt(){
    var gs=goalScoreVal(), gap=Math.round((gs-scores.total)*10)/10;
    if(!(gap>=3)) return '';
    var ts=topGaps(3).filter(function(x){ var d=simStep(x.r); return d && d.dW>0; });
    if(ts.length<2) return '';
    var sum=0, parts=[];
    ts.forEach(function(x,i){
      var d=simStep(x.r); sum+=d.dW;
      parts.push((i+1)+'순위 \''+x.nm+'\' 표준화 '+d.nz+'점 구간 진입(+'+f1(d.dW)+'점'+(d.need? ', 최소 '+d.need+'명 개선':'')+')');
    });
    var neo=Math.round((scores.total+sum)*10)/10;
    return ' 목표까지 '+f1(gap)+'점이 부족한 상황으로, 개선 우선순위는 '+parts.join(' · ')
         + '이며, 모두 확보할 경우 약 +'+f1(sum)+'점으로 '+f1(neo)+'점('+gradeOf(neo)+') 수준까지 도달 가능함.';
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

  /* ▷ 점수 상향 목표 (2026-08-10 확정 / 2026-08-11 서술 보강) — 종전 '목표 :' + '표준화 목표 :' 두 줄이 겹쳐 한 줄로 합쳤다.
       "14일 초과 대상자 2명 감소(분모 129명, 분자 3명→1명, 2.33%→0.78%) 시 표준화 2점→3점 구간 진입 → 가중치 +1.2점(0.6→1.8점), …"
     ★2026-08-11 검수(박혜련) 지시 — 결과만 축약하지 말고 <현황(분모·분자·현황값) → 목표 표준화점수 →
       추가 개선 인원 → 개선 후 분모·분자·현황값 → 가중치 상승분> 이 한 줄에 모두 드러나게 쓴다.
     ★분자의 뜻에 맞는 말을 쓴다 — 개선/추가/실시/감소/제외를 지표마다 달리한다(’○명 개선’ 일괄 금지).
     ★장기입원(14)은 대상자가 빠지면 <분모·분자에서 함께> 빠진다. 분자만 빼면 현황값이 틀린다. */
  /* did/more = 여력 안내문용 (2026-08-11) — "…명이 <did>되어 있어 추가 <more> 가능한 대상자는 최대 N명".
     act('추가 개선')를 그대로 쓰면 "추가 개선되어 있어 추가 추가 개선" 이 된다. 개선·실시형(lower:false)만 필요. */
  var GOAL_VERB = {
    '05':{ noun:'14일 초과 대상자', act:'감소', lower:true },
    '06':{ noun:'',                 act:'실시', lower:false, did:'실시', more:'실시' },
    '09':{ noun:'욕창 처치 실시 환자', act:'추가', lower:false, did:'실시', more:'실시' },
    '10':{ noun:'신규 발생 환자',   act:'감소', lower:true },
    '11':{ noun:'개선 대상자',      act:'추가 개선', lower:false, did:'개선', more:'개선' },
    '12':{ noun:'개선 대상자',      act:'추가 개선', lower:false, did:'개선', more:'개선' },
    '13':{ noun:'적정범위 환자',    act:'추가', lower:false, did:'적정범위에 해당', more:'적정범위 도달' },
    '14':{ noun:'장기입원 대상자',  act:'제외', lower:true, both:true }
  };
  var NO_GOAL = { '07':1, '08':1, '15':1 };   // 고정값·참고용 지표는 목표를 적지 않는다(188·189·198행)

  /** 목표 구간 band 에 닿는 데 필요한 인원. 닿을 수 없거나 이미 넘었으면 null.
      ★구간 경계는 '미만/이상'이라 등호를 넣으면 한 명이 모자란다 — ceil-1 / ceil 로 맞춘다.
      ★both(장기입원)은 대상자가 <분모·분자에서 함께> 빠져 비율이 같이 움직인다.
        (분자−c)/(분모−c) < 상한 을 c 에 대해 풀어야 한다. 분모를 고정해 두고 계산하면
        3명이어야 할 것이 1명으로 나온다(2026-08-10 검토 중 발견). */
  function reqCnt(v, band, dtor, ntor){
    var c, E = 1e-9;
    if(v.both){
      var p = band.end/100;
      if(!(p < 1)) return null;
      c = Math.floor((ntor - p*dtor)/(1-p) + E) + 1;
      if(c > ntor) return null;                                    // 분자를 넘겨 뺄 수는 없다
    } else if(v.lower){
      var maxN = Math.ceil(band.end*dtor/100 - E) - 1;             // 그 구간에 남길 수 있는 최대 분자
      c = ntor - maxN;
    } else {
      var needN = Math.ceil(band.start*dtor/100 - E);              // 그 구간에 들려면 필요한 최소 분자
      if(needN > dtor) return null;                                // 분모를 넘길 수 없다
      c = needN - ntor;
    }
    return (c>0) ? c : null;
  }

  /* 누적 실적(있으면) — 평가는 평가기간 합산으로 산정되므로 목표 계산의 기준자료다.
       cumAna 와 같은 제외 규칙: 인력(01~03)·약사(04)·항정(07)·DUR(08)은 누적 개념이 달라 당월을 쓴다.
       7월 보고서는 _cum 자체가 없다(누적=당월). */
  function cumApplies(cd){
    return !(UNIT_PERSON.indexOf(cd)>=0 || cd==='04' || cd==='07' || cd==='08');
  }
  function cumOf(r){
    if(!_cum) return null;
    if(!cumApplies(r.cate_cd)) return null;
    var c=_cum.map[r.cate_cd];
    return (c && c.dtor>0) ? c : null;
  }

  /* ★★2026-08-11 검수 확정 — 보고서의 <점수 기준>은 평가기간 누적이다 ★★
       적정성평가 점수는 7월~당월 합산으로 정해진다. 종전에는 지표 획득점수·종합점수·등급을 <당월> 기준으로
       보여 줘, ADL 처럼 당월 12.0/12(5구간)인데 누적은 9.6/12(4구간)인 지표가 만점으로 보였다.
       (검수표: "ADL 개선환자분율 12.0 / 12점" → "9.6 / 12점")
       아래 4개가 그 <기준 전환>의 창구다 — 화면 어디든 이 함수만 쓰면 누적 기준이 된다.
     ※누적 개념이 다른 인력(01~03)·약사(04)·항정(07)·DUR(08) 과 7월 보고서(누적=당월)는
       cumOf 가 null 이라 자동으로 당월값이 쓰인다. */
  function gotOf(r){ var c=cumOf(r); return c? n(c.weig) : n(r.weigval); }
  function sOf(r){   var c=cumOf(r); return c? zoneOfWeig(n(r.stdweig), n(c.weig)) : (n(r.s_score)||0); }
  function calValOf(r){ var c=cumOf(r); return c? n(c.cal) : n(r.cal_val); }
  function calDispOf(r){ return fnum(calValOf(r)) + unitOf(r.cate_cd); }

  /* ★2026-08-11 검수(박혜련): "점수 상향 목표는 해당월 기준이 아니라 <누적값에서의 상향값>으로 계산".
       평가 점수는 평가기간(7월~당월) 합산으로 정해지므로, 필요 인원·진입 구간·가중치를 전부 누적 분모·분자로 따진다.
       예) 당월 17명 중 4명(23.53%)이라도 누적은 32명 중 5명(15.63%) — 목표는 누적 32명 기준으로 잡아야 한다.
     ★한 달에 할 수 있는 양에는 한계가 있다 — 당월 남은 대상자(분모−분자)를 <상한>으로 함께 안내한다.
       상한을 넘는 구간은 이번 달에 닿을 수 없으므로 나열에서 뺀다(못 할 목표를 적지 않는다). */
  function goalUp(r){
    var cd=r.cate_cd, v=GOAL_VERB[cd];
    if(!v || NO_GOAL[cd]) return '';
    var w=n(r.stdweig), c=cumOf(r);
    var mD=n(r.dtorval), mN=n(r.ntorval);                       // 당월 분모·분자
    var dtor, ntor, s, got, cumYn=false;
    if(c){ dtor=c.dtor; ntor=c.ntor; got=c.weig; s=zoneOfWeig(w, c.weig); cumYn=true; }
    else { dtor=mD; ntor=mN; got=n(r.weigval); s=n(r.s_score)||0; }
    if(!(dtor>0) || !(s>=1 && s<5)) return '';
    var nm = cumYn ? '누적 ' : '';
    /* 이번 달에 더 할 수 있는 최대치 — 개선·실시형만 센다(감소형은 '이미 발생한 건'이라 여력 개념이 다르다) */
    var cap = (!v.lower && mD>0) ? Math.max(0, mD-mN) : null;
    var step=w/5, parts=[];
    /* ★상위 구간을 <전부> 따져 보고, 같은 인원으로 여러 구간에 닿으면 <가장 높은 구간>으로 합친다
       (2026-08-10 비고: "동일한 개선 인원으로 여러 구간 진입이 가능하면 도달 가능한 가장 높은 구간으로 통합 표기").
       예) 3명 감소로 4점·5점에 모두 닿으면 "3명 감소 … 5점 구간" 한 번만 적는다. */
    var byCnt = {}, over=null;
    (CRIT_ALL[cd]||[]).forEach(function(z){
      if(!(z.s>s && z.s<=5)) return;
      var q = reqCnt(v, z, dtor, ntor);
      if(q==null) return;
      /* 당월 여력을 넘는 구간은 이번 달에 못 닿는다 — 나열에서 빼고, '최대 얼마까지 가능한지'만 따로 적는다 */
      if(cap!=null && q>cap){ if(over==null || z.s<over) over=z.s; return; }
      if(byCnt[q]==null || z.s > byCnt[q]) byCnt[q] = z.s;
    });
    var targets = Object.keys(byCnt).map(Number).sort(function(a,b){ return a-b; });
    targets.forEach(function(cntKey){
      var tz = byCnt[cntKey], band=null;
      (CRIT_ALL[cd]||[]).forEach(function(z){ if(z.s===tz) band=z; });
      if(!band) return;
      var cnt = cntKey, newD = dtor, newN;
      if(v.lower){
        newN = ntor - cnt;
        if(v.both) newD = dtor - cnt;                    // ★장기입원: 분모에서도 같이 제외
      } else {
        newN = ntor + cnt;
      }
      var pct = (newD>0) ? Math.round(newN/newD*10000)/100 : 0;
      var curPct = Math.round(ntor/dtor*10000)/100;
      var newGot = Math.min(w, got + step*(tz-s));
      var head = nm + (v.noun ? v.noun+' ' : '') + fnum(cnt) + '명 ' + v.act;
      var mid  = v.both ? '(분자/분모 '+fnum(ntor)+'/'+fnum(dtor)+'명 → '+fnum(newN)+'/'+fnum(newD)+'명, '+fnum(curPct)+'%→'+fnum(pct)+'%)'
                        : '(분모 '+fnum(dtor)+'명, 분자 '+fnum(ntor)+'명→'+fnum(newN)+'명, '+fnum(curPct)+'%→'+fnum(pct)+'%)';
      parts.push(head+mid+' 시 표준화 '+s+'점→'+tz+'점 구간 진입 → 가중치 +'+f1(newGot-got)+'점('+f1(got)+'→'+f1(newGot)+'점)');
    });
    /* 여력 안내 — "이번 달 대상자 N명 중 M명은 이미 …되어 있어 더 할 수 있는 건 최대 K명" +
       그 K명을 다 했을 때 닿는 누적 구간·가중치. 검수 요청 문형(2026-08-11). */
    var lead='';
    if(cap!=null && mD>0 && v.did){
      var capN = ntor + cap, capPct = (dtor>0)? Math.round(capN/dtor*10000)/100 : 0;
      var capZ = zoneOfValFor(cd, capPct), capGot = (capZ!=null)? Math.min(w, got + step*Math.max(0, capZ-s)) : got;
      var subj = nm + (v.noun || NUM_NM2[cd] || '분자');
      lead = ymLabel()+' '+(DEN_NM2[cd]||'대상')+' '+fnum(mD)+'명 중 현재 '+fnum(mN)+'명이 '+v.did
           + '되어 있어 추가 '+v.more+' 가능한 대상자는 최대 '+fnum(cap)+'명임.';
      if(cap>0 && capZ!=null && capZ>s)
        lead += ' '+fnum(cap)+'명 전원 추가 '+v.more+' 시 '+subj+'는 '+fnum(ntor)+'명→'+fnum(capN)+'명('+fnum(capPct)+'%)으로 상승하여 '
             +  '표준화 '+capZ+'점 구간에 해당하며, 가중치 '+f1(capGot)+'점까지 상승 가능(+'+f1(capGot-got)+'점)함.';
      else if(cap===0) lead += ' 당월 대상자는 모두 반영되어 있어 추가 상승은 다음 달 실적으로 가능함.';
      else if(over!=null) lead += ' 남은 여력으로는 표준화 '+over+'점 구간에 닿지 않아, 다음 달 실적과 함께 관리가 필요함.';
    }
    if(!parts.length) return lead || '';
    return (lead? lead+' ' : '') + parts.join(', ')+'.';
  }
  /* 현황값 → 표준화 구간(지표 방향 자동) — 개선·실시형은 '이상', 감소형은 '이하'로 판정 */
  function zoneOfValFor(cd, val){
    var a=CRIT_ALL[cd]; if(!a) return null;
    var best=null;
    a.forEach(function(z){ if(val>=z.start-1e-9 && val<=z.end+1e-9){ best=z.s; } });
    return best;
  }

  /* [★4] 전 구간 나열형 — 낮을수록 우수 & '감소가 실제 조치'인 지표(장기입원14·유치도뇨관05)만.
       담당자 수기(세밀분석 §6-2, 여수시립 장기입원): 현재보다 우수한 각 구간 도달에 필요한 감소 명수 전부 나열.
       신규욕창(10)은 되돌릴 수 없어 제외(하락 경고 simRoomLower로 처리), PI(07)·1인당(01~03)·재직/DUR 제외.
     ※현재 <미사용> — 2026-08-10 에 '목표 :' + '표준화 목표 :' 두 줄을 goalUp() 한 줄로 합치면서 호출이 빠졌다.
       되살릴 때를 대비해 계산만 goalUp 과 같은 reqCnt() 로 맞춰 둔다(아래 2026-08-11 수정 참고).
     ★2026-08-11 검수(박혜련): 장기입원은 <분자에서만 빼면 안 된다>. 의료중도 이상으로 전환되면
       그 환자는 분모·분자에서 함께 빠지므로 현황값·표준화점수를 다시 산출해야 한다.
       종전 `floor(end*분모/100)` 은 분모를 고정해 필요 인원이 적게 나왔다(35명 중 22명 → 3점 2명·4점 9명·5점 16명,
       실제로는 3명·14명·19명). GOAL_VERB 의 both 플래그를 쓰는 reqCnt() 로 교체한다. */
  function simReduceList(r){
    var cd=r.cate_cd, _c=cumOf(r), s=sOf(r);                                        // 누적 기준(2026-08-11)
    var dtor=_c? n(_c.dtor) : n(r.dtorval), ntor=_c? n(_c.ntor) : n(r.ntorval);
    if(['05','14'].indexOf(cd)<0 || !(dtor>0) || !(s>=1 && s<5)) return null;
    var v=GOAL_VERB[cd]; if(!v) return null;
    var u=unitOf(cd), parts=[];
    (CRIT_ALL[cd]||[]).forEach(function(z){
      if(z.s<=s) return;                                  // 현재보다 우수(상위)한 구간만
      var cut=reqCnt(v, z, dtor, ntor);
      if(cut==null) return;
      var newN=ntor-cut, newD=v.both? (dtor-cut) : dtor;  // ★both(장기입원) = 분모에서도 같이 제외
      var pct=(newD>0)? Math.round(newN/newD*10000)/100 : 0;
      parts.push('표준화 '+z.s+'점('+fnum(bndUp(z.end))+u+' 미만) = '+cut+'명 '+v.act
               + '(' + fnum(newN)+'/'+fnum(newD)+'명, '+fnum(pct)+'%)');
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
    var tail=(nz!=null && nz>s) ? ('표준화 '+nz+'점으로 상향이 기대됨') : '분자 반영률이 개선됨';
    return '배뇨일지는 작성되었으나 배뇨(훈련)프로그램 계획 항목 미체크로 분자에서 누락될 우려가 있는 '+_bladderGapN+'건을 평가표에서 보완할 경우, 분자 '+newN+'명('+fnum(newPct)+'%)으로 재산정되어 '+tail+'(오류점검 결과 기준·대상자 적정성 확인 요망)';
  }

  /* [보완1] P5 의무기록 신뢰도 — '영역별 일치관리' 문구 (라이브러리 202607 Part 4 · 28건 공통 구조).
       담당자 총평은 도입문("…보완이 필요한 사례가 확인됨") 뒤에 유치도뇨관·욕창·배뇨관리 영역별 관리문을 붙인다.
       오류점검(assesCheck)에서 실제로 오류가 잡힌 영역만 골라 넣는다 — 없는 영역까지 나열하면 사실과 어긋나고
       분량만 늘어난다. 세 영역 모두 오류가 없거나 조회 실패면 '' → 기존 상시/연말 일반문만 남는다. */
  function recordRelTxt(){
    var areas=[], secs=[];
    if(_errFoleyN>0){ areas.push('유치도뇨관');
      secs.push('유치도뇨관은 Foley 삽입·교체·제거일과 환자평가표, 의사지시, 간호기록, M0060 및 재료대 산정 내역이 서로 일치하도록 관리가 필요함.'); }
    if(_errSoreN>0){ areas.push('욕창');
      secs.push('욕창은 상태·단계·크기, 피부문제 처치, 체위변경, 영양공급(처방 칼로리와 실제 제공 칼로리)·체중기록과 환자평가표가 의무기록과 일치하도록 관리하고, 동일 부위에 여러 병변이 있는 경우 위치를 구분하여 촬영해 사진·경과기록·간호기록·평가표가 서로 일치하는지 점검이 필요함.'); }
    if(_errBladN>0){ areas.push('배뇨관리');
      secs.push('배뇨관리는 배뇨일지를 7일 미만 작성한 경우 환자평가표의 배뇨일지 작성 여부를 \'아니오\'로 체크하고 실제 작성일수를 기재하며, 의사기록·간호기록·배뇨일지·환자평가표가 서로 일치하도록 관리가 필요함. 배뇨훈련 오더의 시행기간·시간 간격과 배뇨일지 작성기간을 일치시키고, 배뇨일지에 의료인 서명이 누락되지 않았는지 점검이 필요함.'); }
    if(!secs.length) return '';
    return '의무기록 신뢰도 점검 결과 '+areas.join('·')+' 관련 기록에서 일부 보완이 필요한 사례가 확인됨. '+secs.join(' ')+' ';
  }

  // P2 구조영역 커트라인 경고 — 현황값이 현재 표준화 구간 경계에 근접한 구조지표(하위 구간 하락 리스크)를
  //   1개 골라(경계 비율 최소) 담당자 문형으로: "30명 초과 시 표준화 3점(가중치 −1.7점) 하락" (가이드 §3-P2)
  var _structRiskCd = null;   // [보완2] 하락경고로 이미 언급한 구조지표 — structUpTxt 가 같은 지표를 다시 쓰지 않게
  function structRiskTxt(){
    var best=null;
    _structRiskCd = null;
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
    _structRiskCd = best.cd;
    var u=unitOf(best.cd);
    var edge=(best.cd==='04') ? fnum(best.band.start)+u+' 미만' : fnum(bndUp(best.band.end))+u+' 초과';
    var uJosa=(u==='명') ? '으로' : '로';
    var bndE=bndUp(best.band.end);
    return ' 다만 \''+best.nm+'\'가 현황 '+fnum(best.val)+u+uJosa+' 표준화 '+best.s+'점 구간('+fnum(best.band.start)+'~'+(bndE!==best.band.end? fnum(bndE)+u+' 미만' : fnum(best.band.end)+u)+') 경계에 근접해 있어, '
         + edge+' 시 표준화 '+(best.s-1)+'점(가중치 −'+f1(best.loss)+'점)으로 하락할 수 있으므로 재원환자 수 추이에 맞춘 인력 관리가 필요함.';
  }

  /* [보완2] P2 구조영역 '상위 구간 진입 여지' — 라이브러리 202607 Part 2-2 ③ (라온힐·청라백세 등 공통 문형).
       structRiskTxt(하락 경고)의 반대 방향으로, 담당자 총평의 핵심 문장인데 그동안 없었다:
         "의사 1인당 환자수는 현재 표준화 3점 구간으로, 30명 미만으로 개선할 경우 가중치 1.7점 향상이 가능함"
       구조지표(cate_fg='10') 중 표준화 5점 미만이고 가중치 상승폭(w/5)이 가장 큰 1개를 고른다.
        · 1인당 환자수(01~03·낮을수록 우수) → 다음 상위 구간의 상한 기준 'N명 미만'(bndUp = 구간 상한→미만 경계)
        · 재직일수율(04·높을수록 우수)       → 다음 상위 구간의 하한 기준 'N% 이상'
        · 하락 경고에 이미 쓰인 지표는 제외 — 같은 지표에 상반된 두 문장이 붙으면 읽기 나쁘다. */
  function structUpTxt(){
    var best=null;
    indicators.forEach(function(r){
      if(r.cate_fg!=='10') return;
      var cd=r.cate_cd, s=n(r.s_score)||0, w=n(r.stdweig);
      if(!(s>=1 && s<5) || !(w>0) || cd===_structRiskCd) return;
      var nb=null; (CRIT_ALL[cd]||[]).forEach(function(z){ if(z.s===s+1) nb=z; });
      if(!nb) return;
      var cand={ cd:cd, nm:r.cate_nm, s:s, dW:w/5, nb:nb };
      if(!best || cand.dW>best.dW) best=cand;
    });
    if(!best) return '';
    var u=unitOf(best.cd);
    var edge = IS_LOWER[best.cd] ? (fnum(bndUp(best.nb.end))+u+' 미만으로 개선할 경우')
                                 : (fnum(best.nb.start)+u+' 이상으로 개선할 경우');
    return ' \''+best.nm+'\'은(는) 현재 표준화 '+best.s+'점 구간으로, '+edge+' 가중치 약 +'+f1(best.dW)+'점 향상이 가능하므로, 차등제 신고 시 인력 배치 수준을 관리하여 상위 표준화점수 구간 진입 검토가 필요함.';
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
    return ' 구조영역 점수는 '+y+'년 '+q+'분기 차등제 신고내역으로 예상 산정되며, 실제 반영은 '+y1+'년 '+q1+'분기·'+y2+'년 '+q2+'분기 신고 결과로 확정됨.';
  }

  function renderSummary(){
    if(!indicators.length) return;
    var gs=goalScoreVal(), gg=goalGradeVal(), gap=Math.round((gs-scores.total)*10)/10;
    var ymTxt = curYm? curYm.substring(0,4)+'년 '+parseInt(curYm.substring(4,6),10)+'월' : '이번 달';
    var fulls = indicators.filter(function(r){ return n(r.stdweig)>0 && (n(r.stdweig)-gotOf(r))<=0.0001; })
                          .map(function(r){ return indiNm(r); });
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
      p.sum_p1 = moNum2+'월 당월 단독 예상점수는 '+f1(mVal)+'점('+mG+')이나, 실제 평가에 반영되는 7~'+moNum2+'월 누적 예상 종합점수는 '+f1(scores.total)+'점으로 '+curG+'에 해당함.';
    else
      p.sum_p1 = ymTxt+' 예상 종합점수는 '+f1(scores.total)+'점으로 '+curG+'에 해당함.';
    if(prevTotal!=null){
      var pd = Math.round((scores.total-prevTotal)*100)/100;
      if(Math.abs(pd)>=0.05)
        p.sum_p1 += ' 전월('+fnum(prevTotal)+'점) 대비 종합점수가 '+fnum(Math.abs(pd))+'점 '+(pd>0?'상승함.':'하락하여 원인 지표의 재확인이 필요함.');
      else
        p.sum_p1 += ' 전월과 동일한 수준을 유지하고 있음.';
    }
    var UPCUT = { '2등급':87, '3등급':79, '4등급':74, '5등급':64 };   // 현재등급 → 상위등급 커트라인(gradeOf 기준 · 2026-07-30 구간 변경)
    if(UPCUT[curG]!=null){
      var upGap = Math.round((UPCUT[curG]-scores.total)*100)/100;
      if(upGap>0 && upGap<=5)
        p.sum_p1 += ' 상위등급('+(parseInt(curG,10)-1)+'등급, '+UPCUT[curG]+'점)과의 점수 차이는 '+fnum(upGap)+'점으로 확인됨.';
    }
    p.sum_p1 += ' ' + (gap>0 ? '목표인 '+gg+'('+fnum(gs)+'점)까지는 '+f1(gap)+'점이 더 필요한 상황임.'
                             : '목표인 '+gg+'('+fnum(gs)+'점)을 달성한 수준으로, 남은 기간 동안 유지 관리가 필요함.');
    /* [C2] 월별 종합점수 시계열 — ★8~9월에만 표시(2026-08-03, 2025 정답지 318건 전수 근거).
         종전에는 '3개월 이상이면 항상' 이라 10~12월에도 붙었는데, 정답지는 10월부터 전 병원이
         이 나열을 버리고 누적 단문으로 축약한다(4개 그룹 독립 확인 — 8~9월 집중, 10월 이후 소멸).
         누적 개월이 2~3개일 때만 월별 등락을 보여줄 실익이 있다는 담당자 판단으로 보인다. */
    if(_dashInd && moNum2>=8 && moNum2<=9){
      var ser=[];
      for(var mm=7; mm<=moNum2; mm++){ var mv=n(_dashInd['month_'+('0'+mm).slice(-2)]); if(mv>0) ser.push(mm+'월 '+f1(mv)+'점'); }
      if(ser.length>=2) p.sum_p1 += ' (월별 예상점수 추이 — '+ser.join(', ')+')';
    }
    var sq = structQuarterTxt();   // [★5] 2026 등 차등제 분기 예상/실반영 표기(연말은 '')
    p.sum_p2 = '구조영역은 '+f1(scores.struct)+'점으로 확인됨.'
             + structRiskTxt()
             + structUpTxt()      // [보완2] 상위 구간 진입 여지(하락 경고와 다른 지표에서 1개)
             + (sq || ' 실제 점수는 차등제 신고 결과가 합산되어 확정됨.')
             + ' 재원환자 수와 인력 추이가 변동되지 않도록 꾸준한 관리가 필요함.';
    p.sum_p3 = '';
    if(fulls.length) p.sum_p3 += '진료영역에서는 '+fulls.slice(0,4).join(', ')+(fulls.length>4?' 등':'')+' 지표가 잘 관리되고 있음. ';
    if(tops.length){
      var t=tops[0], s1=simTail(t.r);
      p.sum_p3 += '반면 \''+t.nm+'\'은(는) 개선 여지가 가장 큰 지표로, '
                + (s1 ? s1+'. ' : '표준화 구간을 한 단계 올릴 때마다 약 +'+f1(t.w/5)+'점 확보가 가능함. ');
      if(tops[1]){
        var s2=simTail(tops[1].r);
        p.sum_p3 += '\''+tops[1].nm+'\'도 '+(s2 ? s2+'.' : '함께 관리가 필요함.');
      }
    }
    if(!p.sum_p3) p.sum_p3 = '진료영역 지표는 전반적으로 안정적으로 관리되고 있음.';
    p.sum_p3 += roomRiskTxt();   // [★1] 낮을수록 우수 지표 하락 경고(여유 한도형) 병기
    // [보완3] 부족점수가 크면 '개선 우선순위' 블록으로, 작으면 기존 C4(상위 2지표 동시개선)로 — 결론이 겹쳐 둘 중 하나만
    var _rank = goalRankTxt();
    p.sum_p3 += _rank || sumTopSimTxt();
    /* [N12 2026-08-05] 2024 구간 기준 산정 유보 + 10~20% 여유 관리 권장 — 2026-07 정답지 27건 중 15곳+ 반복(세밀분석 §9).
         배뇨관리(06)는 2026 신설이라 2024 구간이 없어 "…을 제외한 지표에" 를 붙인다(서온·중화·청암·전남제일 동일).
         12월은 확정 국면이라 생략(아래 C11 확정문과 상충). */
    if(!(curYm && parseInt(curYm.substring(4,6),10)===12))
      p.sum_p3 += ' 현재 예상점수는 배뇨관리 실시 환자분율을 제외한 지표에 2024년도 결과발표 표준화 구간을 적용하여 산정한 결과이므로, 향후 표준화 구간 변동 가능성을 고려하여 상위 등급을 안정적으로 확보하기 위해서는 주요 지표를 해당 구간보다 약 10~20% 이상 여유 있게 관리하는 것을 권장함.';
    // [C11] 연말(12월) 확정 국면 — 잔여 개선 여지 무관하게 점수 확정(세밀분석 §8, 3병원 수렴)
    if(curYm && parseInt(curYm.substring(4,6),10)===12)
      p.sum_p3 += ' 다만 평가가 12월 진료분까지로 종료되는 시점이므로, 남은 개선 여지와 무관하게 현재 점수 수준에서 확정되는 국면임.';
    p.sum_p4 = '항정신성의약품 처방률, DUR 점검률, 지역사회복귀율은 예상값 기준으로 산출되어 최종 평가 결과에 따라 점수가 다소 달라질 수 있음.';
    // [P4 항정 리스크 2026-07-24] 가이드 §3-P4 line63/95 명시 문형 — 지표07(항정신성) 화면값(s_score·stdweig)만으로
    //   "40% 초과 시 표준화 1점 구간 하락 → 가중치 약 −(W/5×(S−1))점 감소" 조립(청구% 불필요, draft 안전).
    //   정답지 검증: 07=표준화3구간·가중치3점 → −1.2점(계요 47.88% 6월 → 1점구간 가중치 1.2점 감소와 일치).
    var api07 = indicators.filter(function(r){ return r.cate_cd==='07'; })[0];
    if(api07){
      var aS=n(api07.s_score)||0, aW=n(api07.stdweig);
      /* [N1 2026-08-05] 전월 <실측> 처방률이 있으면 가정문 대신 실측 문형 — 2026-07 정답지 27건 수렴 1위.
           표준화 구간: 10% 미만=5점 / 10~40%=3점 / 40% 이상=1점 (정답지 전건 동일 명기).
           방향별 문형(정답지 그대로):
             1점 구간 → "동일 수준 산정 시 −Δ점 감소 예상 … 장기·중복 처방 검토"(중화·태종대·청암·무지개·시흥더봄·이푸른)
             5점 구간 → "해당 수준 유지 시 +Δ점 추가 상승 가능"(강동스마일)
             3점 구간 → 현 가정과 같아 수치만 병기.  Δ = W/5 × |실측구간 − 현재구간|. */
      if(_psyPrev && aW>0 && aS>=1){
        var pBand = (_psyPrev.rate < 10) ? 5 : (_psyPrev.rate < 40 ? 3 : 1);
        /* 기간 표기 — 7월 보고서는 "6월", 8월은 "7월", 9월~ 는 "7~N월"(같은 해라 연도 표기는 앞에 한 번) */
        var pmF = parseInt(_psyPrev.from.substring(4,6),10), pmT = parseInt(_psyPrev.to.substring(4,6),10);
        var pmLbl = (pmF===pmT) ? pmF+'월' : pmF+'~'+pmT+'월';
        var pHead = ' 항정신성의약품 처방률은 당월 청구자료 확정 전으로 표준화 '+aS+'점 구간으로 예상하여 산정하였으나, '
                  + _psyPrev.from.substring(0,4)+'년 '+pmLbl+' 처방률은 '+f1(_psyPrev.rate)+'%로 표준화 '+pBand+'점 구간에 해당함.';
        var pDelta = f1(aW/5*Math.abs(pBand-aS));
        if(pBand < aS){
          var aBoot2=topGaps(1)[0];
          p.sum_p4 += pHead+' 동일한 수준으로 산정될 경우 가중치점수 약 −'+pDelta+'점 감소 가능성이 있으므로, 불필요한 장기·중복 처방 여부와 처방의 적정성을 지속적으로 검토하여 처방률을 관리할 필요가 있음.'
                    + (aBoot2 ? ' 아울러 점수 감소 가능성을 고려하여 \''+aBoot2.nm+'\' 등 실제 개선 가능한 지표의 점수를 추가 확보하는 것이 중요함.' : '');
        } else if(pBand > aS){
          p.sum_p4 += pHead+' 해당 수준을 유지할 경우 가중치점수 약 +'+pDelta+'점 추가 상승이 가능함.';
        } else {
          p.sum_p4 += pHead;
        }
      } else if(aS>1 && aW>0){
        var aDrop=f1(aW/5*(aS-1));                 // 1점 구간 하락 시 감소 가중치
        var aBoot=topGaps(1)[0];                    // 보완 우선(부족점수 최대) 지표
        p.sum_p4 += ' 특히 항정신성의약품 처방률은 전국 기관 기준으로 최종 산정되는 지표로, 처방률이 40%를 초과하여 표준화 1점 구간으로 산정될 경우 가중치 약 −'+aDrop+'점 하락이 예상되므로, 불필요한 장기·중복 처방을 정기적으로 점검하고'
                  + (aBoot ? ' \''+aBoot.nm+'\' 등 부족점수가 큰 지표를 우선 관리하여 점수 감소 보완이 필요함.' : ' 처방 적정성의 지속적인 관리가 필요함.');
      }
    }
    p.sum_p4 += ' 해당 대상자에 대한 지속적인 관리가 요구됨.';
    /* [★2] P5 신뢰도 — ★12월에만 '익년 2~3월 점검 대비형', 그 외(7~11월)는 상시형.
         종전 기준은 10~12월이었으나 2025 정답지 318건에서 대비형은 12월 전용이다
         (12월 보고서 9/9·8/8·5/5·5/5 전건, 10~11월은 상시형 유지 — 4개 그룹 독립 확인).
         10·11월에 미리 붙이면 담당자 문서보다 두 달 이른 안내가 된다. */
    var moNum = curYm ? parseInt(curYm.substring(4,6),10) : 0;
    // [보완1] 오류점검에서 잡힌 영역(유치도뇨관·욕창·배뇨관리)의 일치관리 문구를 앞에 붙인다(라이브러리 Part 4)
    p.sum_p5 = recordRelTxt();
    if(moNum===12)
      p.sum_p5 += '신뢰도 점검 결과는 적정성평가에 그대로 반영되므로, 다음 연도 2~3월로 예정된 신뢰도 점검에 대비하여 의무기록과 환자평가표의 불일치 사항을 미리 점검·수정하여야 함.';
    else
      p.sum_p5 += '신뢰도 점검 결과는 적정성평가에 그대로 반영되므로, 의무기록과 환자평가표가 서로 일치하는지 평소에 함께 점검이 필요함.';
    Object.keys(p).forEach(function(k){
      if(savedKeys[k]) return;   // 병원별 편집 저장분 우선
      var e=document.querySelector('#evalReport [data-key="'+k+'"]');
      if(e){ e.textContent = p[k]; AUTO[k] = e.innerHTML; }
    });
  }

  /* ★구조영역 '개선 여지' 를 수치로(2026-07-30 사용자 요청 — "몇 명을 충원해야 하는지 92일 기준으로").
       표기 확정: 「57일 추가 인력 필요(최소 1인 이상)」 형태.
     [산출 — 병원 담당자가 GPT 로 검산하던 그 계산을 그대로 구현]
       01~03(환자수÷인력수, 낮을수록 좋음 · 분기 92일 기준):
         총재원일수   = 평균재원환자수(ntorval) × 92
         목표근무일수 = 총재원일수 ÷ 다음구간 경계 B   (예: 30명 미만 → B=30)
         추가일수     = ⌈목표근무일수 − 현재인력수(dtorval)×92⌉ · 인원 = ⌈추가일수÷92⌉
         검산: 재원 201.18명·의사 6.09명·B=30 → 616.95−560.28 = 56.67 → 「57일 추가 인력 필요(최소 1인 이상)」 ✓
       04(약사재직일수율 %, 높을수록 좋음): 추가재직일수 = ⌈(다음구간 하한% − 현황%)÷100 × 재직대상일수(dtorval)⌉
     계산 불가(만점·기준 미로드·분모 0)면 '' 를 돌려 기존 문구(TPL_ROOM)로 폴백한다. */
  function staffNeed(x){
    var r=x.r, s=n(r.s_score)||0, zones=CRIT_ALL[x.cd];
    if(x.fg!=='10' || !zones || s<=0 || s>=5) return '';
    var nz=null; zones.forEach(function(z){ if(z.s===s+1) nz=z; });
    if(!nz) return '';
    var DAYS=92;   // 분기 기준일수(사용자 지정 — SP 의 분기 산정과 동일한 92일)
    if(x.cd==='04'){
      var tgt=n(r.dtorval), got04=n(r.ntorval), B4=n(nz.start);
      if(!(tgt>0) || !(B4>0)) return '';
      var addDays4=Math.ceil(B4/100*tgt - got04);
      if(addDays4<=0) return '';
      return addDays4+'일 추가 재직 필요';
    }
    var P=n(r.ntorval), S=n(r.dtorval), B=bndUp(n(nz.end));
    if(!(P>0) || !(S>0) || !(B>0)) return '';
    var addDays=Math.ceil(P*DAYS/B - S*DAYS);
    if(addDays<=0) return '';
    var ppl=Math.max(1, Math.ceil(addDays/DAYS));
    return addDays+'일 추가 인력 필요(최소 '+ppl+'인 이상)';
  }

  function topGaps(limit){
    /* ★순위 고정(2026-07-30 사용자 확정 — 2026-07-23 의 '진료→구조→지역사회·부족점수 큰 순' 을 대체):
         1 욕창개선(11) → 2 ADL(12) → 3 당뇨HbA1c(13) → 4 배뇨관리(06) → 5 유치도뇨관(05)
         → 6 구조영역(01~04) → 7 장기입원(14) → 8 항정처방률(07) → 9 지역사회복귀율(15)
       · 구조영역 안에서는 **다음 표준화 구간에 가장 근접한 지표부터**(사용자: "실질적으로 먼저 올릴 수 있는
         지표 우선"). 근접도 = 현황값에서 다음 구간 경계까지의 거리 ÷ 현황값(단위가 명·%로 섞여 있어 상대거리로 비교).
       · 목록에 없는 지표(08 DUR · 09 욕창처치 · 10 욕창새로생김)는 맨 뒤에 부족점수 큰 순으로 붙는다. */
    var RANK = { '11':1, '12':2, '13':3, '06':4, '05':5, '14':7, '07':8, '15':9 };   // 구조(01~04)=6, 미지정=10
    var LOW2 = { '01':1, '02':1, '03':1, '05':1, '07':1, '10':1, '14':1 };           // 값이 낮을수록 좋은 지표
    function rankOf(x){ return RANK[x.cd] || (x.fg==='10' ? 6 : 10); }
    // 구조지표 근접도 — 다음 구간(s+1) 경계까지 얼마나 가까운가. 계산 불가(만점·기준 없음)는 맨 뒤.
    function structProx(x){
      var s = sOf(x.r), val = calValOf(x.r);
      var zones = CRIT_ALL[x.cd];
      if (!zones || s<=0 || s>=5) return 9e9;
      var nz=null; zones.forEach(function(z){ if(z.s===s+1) nz=z; });
      if (!nz) return 9e9;
      var dist = LOW2[x.cd] ? (val - nz.end) : (nz.start - val);   // 낮을수록 좋은 지표는 다음 구간 상한까지 내려갈 거리
      if (!(dist > 0)) return 0;                                    // 이미 경계 위 = 가장 근접
      return dist / Math.max(Math.abs(val), 0.01);
    }
    return indicators.map(function(r){ return { cd:r.cate_cd, nm:indiNm(r), fg:r.cate_fg, w:n(r.stdweig), got:gotOf(r), gap:n(r.stdweig)-gotOf(r), r:r }; })
                     .filter(function(x){ return x.gap>0.0001; })
                     .sort(function(a,b){
                       var ra=rankOf(a), rb=rankOf(b);
                       if (ra!==rb) return ra-rb;
                       if (ra===6){ var d=structProx(a)-structProx(b); if (d) return d; }   // 구조끼리 = 근접순
                       return b.gap-a.gap;                                                  // 그 외 동순위 = 부족점수 큰 순
                     }).slice(0, limit||99);
  }

  // Ⅲ 지표별 분석 내용 — 지표별 자동 분석문 + 편집 개선방향(저장 문구 override 는 loadSavedTexts 가 재적용)
  function renderSec3(){
    var order=['10','21','22'], html='';
    order.forEach(function(fg){
      var rows=indicators.filter(function(r){ return r.cate_fg===fg; });
      if(!rows.length) return;
      html += '<div class="er-grplabel er-g'+fg+'">'+grpNm(fg)+'</div>';
      /* 구조영역 라벨 옆 = 차등제 신고 기준(2026-07-30 요청) — 예) *2026년 3분기 신고 기준 산출.
         값은 차등제 마스터(goal.startyy/qterflag)에서. 로드 순서상 renderSec3 가 먼저 돌 수 있어
         id 를 달아 두고 applyGoalDefault 가 값 도착 시 채운다. */
      if(fg==='10') html += ' <span id="erG10Qtag" style="font-size:11.5px;font-weight:700;color:var(--er-soft);">'+_erQtagTxt()+'</span>';
      var topCds = topGaps(2).map(function(x){ return x.cd; });   // 최우선(부족분 상위2) — 원본 "◀ 최우선 개선" 표기
      rows.forEach(function(r){
        /* 점수·구간·만점 판정은 <누적> 기준(2026-08-11 검수). 단 분석문 첫 줄은 '당월 실적' 문장이므로
           빨강 강조 여부(fullM)만 당월 만점으로 따진다 — 누적으로 판단하면 당월 만점인 달도 빨갛게 나온다. */
        var w=n(r.stdweig), got=gotOf(r), gap=w-got, cd=esc(r.cate_cd), s=sOf(r);
        var full = gap<=0.0001;
        var fullM = (w - n(r.weigval))<=0.0001;
        // 원본 PDF 형식: * 산정문(미달 빨강 강조) / "지표 정의 :" 별도 회색 줄 (+만점 시 유지 문구)
        var auto = autoAna(r, fullM);
        /* 지표 정의에는 기관별 분석 결과(현재 점수·구간·개선 여지)를 넣지 않는다(2026-08-10 요청).
           "현재 최고 구간으로 추가 개선 여지 없음"은 아래 <점수 상향 목표> 줄로 옮겼다. */
        var defTxt = (TPL_DEF[r.cate_cd] ? esc(TPL_DEF[r.cate_cd]) : '');
        /* ▷ 개선 방향 = <관리해야 할 내용>만. 구간·점수·필요 인원은 점수 상향 목표 줄이 맡는다
           (종전에는 개선 방향에도 "2구간 +0.6점 … 5점 도달까지 3명" 이 붙어 목표 줄과 겹쳤다). */
        var planTxt = (TPL_DIR[r.cate_cd]? esc(TPL_DIR[r.cate_cd]) : '');
        var bg = bladderGapTxt(r);   // [★6] 배뇨관리(06) 오류점검 연계 보완문(있으면) — 편집영역이라 수기 수정 가능
        if(bg) planTxt += ' ' + esc(bg) + '.';
        /* 항정(07)·ADL(12)은 개선 방향을 <내리기로> 확정했다(188·194행).
           기본 안내문으로 되채우면 내린 뜻이 사라지므로, 되채움 대상에서 뺀다. */
        var noPlan = (cd==='07') || (cd==='12');
        if(!planTxt.trim() && !noPlan) planTxt = '기록·실시 절차를 점검하고 목표 구간을 설정하세요.';
        /* [2026-07-30 사용자 요청 묶음]
           · 구조영역(fg 10) = 지표정의·개선방향 줄 삭제 — 분기(신고) 단위라 3개월 내내 같아 매월 반복이 무의미.
             라벨 옆 '*{년} {분기} 신고 기준 산출' 표기가 그 자리를 대신한다.
           · DUR(08) = 분석 문구를 확정 문구로 교체(100% 가정 산정 + 점검 안내 + 확인 경로). 정의·개선방향 없음. */
        var noDefPlan = (fg==='10') || (cd==='08');
        if (cd==='08'){
          /* DUR(08) 고정문 — 2026-08-10 서식 요청: 첫 줄만 굵게, '다만,'부터 빨간 글씨. */
          auto = '<b>DUR 점검률을 100%로 가정하여 가중치 '+fnum(w)+'점을 산정함.</b><br>'
               + '<span class="er-hl-bad" style="font-weight:400;">다만, 매월 심사평가원의 DUR 점검완료 현황을 확인하여 DUR 점검 누락 대상자를 지속적으로 관리하여야 하며, 점검 결과에 따라 최종 평가 결과 발표 시 점수 차이가 발생할 수 있음.</span><br>'
               + '<span style="font-weight:400; color:var(--er-soft);">• 확인 경로: 요양기관업무포털 → 모니터링 → DUR정보 → 기관별 DUR 점검완료현황 → 처방전 조회 및 취소</span>';   /* 확인 경로 — 빨강 아님, 진하지 않게(2026-08-10) */
        }
        /* [2026-08-03] Ⅳ 권고사항 통합 — 별도 장이던 권고의 고유 내용(목표 완결문·5구간 병기·%p부족·
             감소 사다리/여유 한도)을 분석내용 박스 안 '목표 :' 줄로 옮기고 Ⅳ장은 삭제했다(사용자 요청).
             현황·개선방향은 이 박스에 이미 있어 중복이라 목표 줄만 가져온다. 만점·구조(fg10)·DUR(08)은 제외. */
        /* ▷ 점수 상향 목표 — 한 줄로 통합(2026-08-10). 5점 지표는 '유지' 한 줄만 남긴다. */
        var goalHtml='';
        if(!noDefPlan && !NO_GOAL[cd]){
          if(full){
            goalHtml = '<p class="er-goal er-editable" data-key="goal_'+cd+'"><span class="er-mk">▷ 점수 상향 목표 :</span> 현재 최고 구간으로 추가 개선 여지 없음(유지).</p>';
          } else {
            var gUp = goalUp(r);
            if(gUp) goalHtml = '<p class="er-goal er-editable" data-key="goal_'+cd+'"><span class="er-mk">▷ 점수 상향 목표 :</span> '+gUp+'</p>';
          }
        }
        var topTag = (topCds.indexOf(r.cate_cd)>=0 && !full) ? ' <span style="color:var(--er-bad); font-weight:800; font-size:11.5px;">◀ 최우선 개선</span>' : '';
        html += '<div class="er-indhead">■ '+esc(indiNm(r))+' <span class="er-indsc"><span class="'+(full?'er-b-good':'er-b-bad')+'">'+f1(got)+'</span> / '+fnum(w)+'점</span>'+topTag+'</div>'
              + '<div class="er-indbox'+(full?' er-full':'')+'">'
              +   '<div class="er-anabar">분석 내용</div>'
              +   '<div class="er-indbody">'
              +     '<p class="er-ana er-editable" data-key="ana_'+cd+'">* '+auto+'</p>'
              +     ((defTxt && !noDefPlan)? '<p class="er-def er-editable" data-key="def_'+cd+'">지표 정의 : '+defTxt+'</p>' : '')
              +     ((full || noDefPlan || !planTxt.trim())? '' : '<p class="er-plan er-editable" data-key="plan_'+cd+'"><span class="er-mk">▷ 개선 방향 :</span> '+planTxt+'</p>')
              +     goalHtml
              +   '</div>'
              + '</div>';
      });
    });
    el('er-sec3Body').innerHTML = html;
  }


  // 해당 표준화구간(s)의 범위 표기 — 원본 PDF: "(30~34명)" "(6명 미만)" "(3.5% 이상)" "(100%)" 형식
  function zoneRange(cd, s){
    var a = CRIT_ALL[cd]; if(!a) return '';
    var b = null; a.forEach(function(z){ if(z.s===s) b=z; });
    if(!b) return '';
    var u = unitOf(cd), st = b.start, en = b.end, bnd = bndUp(en);   // 절단 상한 → 실제 경계(29.99→30, 0.49→0.5)
    if (st <= 0)                          return fnum(bnd) + u + ' 미만';
    if (en >= 999)                        return fnum(st) + u + ' 이상';
    if (u === '%' && st >= 100)           return '100%';
    if (u === '%' && en >= 100)           return fnum(st) + '% 이상';
    // 26~29.99명 → '26~30명 미만' (2026-07-23 '미만' 통일 / 2026-08-11 검수: 단위를 '미만' 앞에 둔다 — '30~34미만명' 은 오타처럼 읽힌다)
    return fnum(st) + '~' + (bnd !== en ? fnum(bnd)+u+' 미만' : fnum(en)+u);
  }

  function renderTable2(){
    // 7컬럼: 영역(세로병합) | 지표명 | 가중치 | 현황값 | 표준화구간(2줄·색) | 획득점수 | 부족점수
    //   ※ 옛 '부족점검'(획득률 %) 열은 2026-07-28 사용자 확정으로 제외. thead 도 같이 7칸이다.
    var html='';
    function grpRows(fg, label, areaCls){
      var rows=indicators.filter(function(r){ return r.cate_fg===fg; });
      rows.forEach(function(r, idx){
        var w=n(r.stdweig), got=gotOf(r), gap=w-got, s=sOf(r);   // 누적 기준(2026-08-11)
        var zcls = s>=5?'er-z5':(s<=1?'er-z1':'er-z3');
        var range = s? zoneRange(r.cate_cd, s) : '';
        var zTd = s? '<td class="er-zc '+zcls+'"><b>'+s+'구간</b>'+(range?'<span class="er-zr">('+esc(range)+')</span>':'')+'</td>' : '<td>-</td>';
        // 부족분 강조(연분홍) = 진료지표(과정·결과) 중 부족분 2점 초과 — 원본 강조 패턴
        var hl = (fg!=='10' && gap>2.0001);
        var gapTd = gap>0.0001? '<td class="er-num'+(hl?' er-gaphl':' er-b-bad')+'">'+f1(gap)+'</td>' : '<td class="er-zero er-num">0</td>';
        var cal = calDispOf(r) + (r.cate_cd==='07' ? ' (PI)' : '');
        html += '<tr>'
              + (idx===0? '<td class="er-area '+areaCls+'" rowspan="'+rows.length+'">'+label+'</td>' : '')
              + '<td class="er-l">'+esc(indiNm(r))+'</td><td class="er-num">'+fnum(w)+'</td><td class="er-num">'+cal+'</td>'
              + zTd + '<td class="er-num">'+f1(got)+'</td>'+gapTd+'</tr>';
      });
      return rows;
    }
    function sums(fgs){
      var w=0,g=0;
      indicators.forEach(function(r){ if(fgs.indexOf(r.cate_fg)>=0){ w+=n(r.stdweig); g+=gotOf(r); } });
      return { w:w, g:g, gap:w-g };
    }
    grpRows('10','구조<br>지표','');
    var s10=sums(['10']);
    html += '<tr class="er-sub"><td colspan="2">구조영역 소계</td><td class="er-num">'+fnum(s10.w)+'</td><td></td><td></td><td class="er-num">'+f1(s10.g)+'</td><td class="er-b-bad er-num">'+f1(s10.gap)+'</td></tr>';
    grpRows('21','과정<br>지표','er-a21');
    grpRows('22','결과<br>지표','er-a22');
    var sMd=sums(['21','22']);
    html += '<tr class="er-sub"><td colspan="2">진료영역(과정+결과) 소계</td><td class="er-num">'+fnum(sMd.w)+'</td><td></td><td></td><td class="er-num">'+f1(sMd.g)+'</td><td class="er-b-bad er-num">'+f1(sMd.gap)+'</td></tr>';
    var sT=sums(['10','21','22']);
    html += '<tr class="er-grand"><td colspan="2">종 합</td><td class="er-num">'+fnum(sT.w)+'</td><td></td><td></td><td class="er-num">'+f1(sT.g)+'</td><td class="er-num">'+f1(sT.gap)+'</td></tr>';
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
      // 메일 문구(mail_subject / mail_body) — 문서 편집영역이 아니라 발송 창의 기본값으로 쓴다
      if(k==='mail_subject'){ TPL_MAIL.subject = String(c); return; }
      if(k==='mail_body'){    TPL_MAIL.body    = String(c); return; }
      var m=/^(def|dir)_(\d{2})$/.exec(k);
      if(m){
        if(m[1]==='def') TPL_DEF[m[2]]=String(c); else TPL_DIR[m[2]]=String(c);
        reRender=true;
      } else {
        editableTpls.push({ k:k, c:String(c) });
      }
    });
    if(reRender){ renderSec3(); captureAuto(); }   // DB 문구 반영 후 스냅샷 재확정
    editableTpls.forEach(function(t){
      var e=document.querySelector('#evalReport .er-editable[data-key="'+t.k+'"]');
      if(e){ e.innerHTML=erFillTpl(t.c); AUTO[t.k]=e.innerHTML; savedKeys[t.k]=1; }
    });
  }

  // 표지 뱃지(cover_goal_badge)는 목표등급(cover_goal_grade)의 재표기일 뿐 —
  //   저장 override 는 등급만 남고 뱃지는 자동값이라 '본문 1등급 / 뱃지 4등급' 처럼 어긋날 수 있어 항상 동기화한다.
  function syncGoalBadge(){
    var g=document.querySelector('#evalReport [data-key="cover_goal_grade"]');
    var b=document.querySelector('#evalReport [data-key="cover_goal_badge"]');
    if(g && b){ var t=(g.textContent||'').trim(); if(t) b.textContent=t; }
  }

  // 이력 스냅샷의 목표등급·목표점수를 화면에 되돌림 — applyGoalDefault(현재 차등제 마스터)가 덮어쓴 값을 정정.
  //   표지 본문(cover_goal_grade/score)과 뱃지(cover_goal_badge)를 함께 맞춰 '1등급/3등급 혼재'를 없앤다.
  function applySnapshotGoal(meta){
    if(!meta) return;
    var gs = (meta.goalscore!=null && String(meta.goalscore)!=='') ? String(meta.goalscore) : '';
    var gg = (meta.goalgrade!=null && String(meta.goalgrade).trim()!=='') ? String(meta.goalgrade).trim() : '';
    if(gg && gg.indexOf('등급')<0) gg = gg + '등급';
    function setVal(key, val){
      if(!val) return;
      var e=document.querySelector('#evalReport [data-key="'+key+'"]');
      if(e) e.textContent = val;
    }
    setVal('cover_goal_score', gs);
    setVal('cover_goal_grade', gg);
    setVal('cover_goal_badge', gg);
    try{ renderGoalSummary(); }catch(e){}   // 그 시점 목표 기준으로 부족점수·등급표 재계산
  }

  // 이력 열람(읽기전용) + 스냅샷 SEQ 가 있으면 → 그 시점 '저장 직전' 문구(TEXTS_JSON)로 본문을 덮어써 재현.
  //   ※ 문구만 스냅샷 대상 — 점수·표 등 수치는 현재 데이터로 계산됨(그 시점 문구 + 현재 수치).
  function applyHstSnapshot(){
    if(!(_erReadonly && _erHstInfo && _erHstInfo.seq)) return;
    jQuery.ajax({ url: ctx+'/main/loadEvalReportHst.do', type:'POST', dataType:'json',
      data:{ hstSeq:_erHstInfo.seq, hospCd:hospCd, evalYm:curYm },
      success:function(res){
        var h = res && res.hst;
        if(!(res && res.result==='OK')){
          erSwal('warning','이력 스냅샷을 불러오지 못했습니다.\n'+((res&&res.message)||'')+'\n(서버 재빌드가 필요할 수 있습니다)');
          return;
        }
        if(!h || !h.textsjson){
          erSwal('info','이 이력에는 문구 스냅샷이 없습니다(PDF 변경만 있는 이력). 현재 문구를 표시합니다.');
          return;
        }
        var arr=null; try{ arr = JSON.parse(h.textsjson); }catch(e){ arr=null; }
        if(!arr || !arr.length){ erSwal('info','이 이력의 문구 스냅샷이 비어 있습니다. 현재 문구를 표시합니다.'); return; }
        var map={}, meta=null;
        arr.forEach(function(t){
          if(!t || t.sectkey==null) return;
          if(t.sectkey==='__meta'){ try{ meta = JSON.parse(t.content); }catch(e){} return; }   // 그 시점 목표·점수
          map[t.sectkey]=t.content;
        });
        // ★ 스냅샷에 있는 항목은 그 값으로, '없는 항목은 자동문구(AUTO)로 되돌린다'.
        //   되돌리지 않으면 현재 저장문구(최종본)가 화면에 그대로 남아 '이력에 최종본이 보이는' 착시가 생긴다.
        editables().forEach(function(e){
          var k=e.getAttribute('data-key');
          if(map[k]!=null)            e.innerHTML = map[k];        // 그 시점 저장 문구
          else if(AUTO[k]!==undefined) e.innerHTML = AUTO[k];      // 그 시점엔 저장분 없음 = 자동문구 상태
        });
        if(meta) applySnapshotGoal(meta);              // ★ 문구 적용 뒤 목표등급·점수를 그 시점 값으로 되돌림
        editables().forEach(function(e){ e.contentEditable='false'; });
        erPaginate();                                  // 스냅샷 문구로 재분할
        var hi=el('er-hstInfo');                       // 칩에 '그 시각 작업 내용' 표기
        if(hi){ hi.innerHTML = '📜 이력 열람 · ' + esc(_erHstInfo.label||'') +
                ' <span class="er-hstmeta">(' + esc(_erHstInfo.time||'') + ' 저장 직전 내용)</span>'; hi.style.display='inline-flex'; }
      },
      error:function(xhr){
        erSwal('error','이력 스냅샷 조회 실패 (HTTP '+((xhr&&xhr.status)||'?')+').\n서버 재빌드(Java·XML) 후 다시 시도해 주세요.', {title:'오류'});
      }
    });
  }

  /* [승인본 불일치 경고] 운영 기준(2026-08-03 확정): 정본 = 승인 시점 PDF, 화면 = 최신 진단치.
       승인 후 평가표 추가·자료 재생성으로 수치가 달라지면, 담당자가 병원 응대 전에 알 수 있게
       승인 스냅샷(snapshotjson.scores.total)과 현재 계산을 비교해 경고를 띄운다. 같으면 안 뜸.
       갱신 절차 = 승인취소 → 재승인 → PDF 재생성(화면생성) → 저장. */
  function _erApproveDiff(mst){
    var bn=el('er-apprDiff'); if(!bn) return;
    bn.style.display='none'; bn.innerHTML='';
    try{
      if(!isWinner || !mst || mst.status!=='APPROVED' || !mst.snapshotjson || !scores) return;
      var snap=JSON.parse(mst.snapshotjson);
      if(!snap || !snap.scores) return;
      var r2=function(v){ return Math.round(n(v)*100)/100; };
      var oT=r2(snap.scores.total), cT=r2(scores.total);
      var oS=r2(snap.scores.struct), cS=r2(scores.struct);
      var oC=r2(snap.scores.care),   cC=r2(scores.care);
      if(!(oT>0)) return;

      /* 지표별 대조 — 승인 당시 스냅샷의 indicators 와 현재 indicators 를 지표코드로 맞춰본다.
         점수(weigval)뿐 아니라 산출값(calDisp)도 같이 보여야 '무엇이 왜 바뀌었는지'가 보인다.
         승인 후 새로 생긴/사라진 지표도 잡는다(자료 재적재로 지표가 통째로 생기는 경우가 있음). */
      var oM={}, seen={}, rows=[];
      (snap.indicators||[]).forEach(function(r){ if(r && r.cate_cd!=null) oM[String(r.cate_cd)]=r; });
      var calOf=function(r){ try{ return r? String(calDisp(r)) : '-'; }catch(e){ return '-'; } };
      (indicators||[]).forEach(function(cr){
        var cd=String(cr.cate_cd); seen[cd]=1;
        var or_=oM[cd];
        var ov=or_? r2(or_.weigval) : null, cv=r2(cr.weigval);
        var oc=calOf(or_), cc=calOf(cr);
        if(or_ && Math.abs(ov-cv)<0.005 && oc===cc) return;      // 점수·산출값 둘 다 같으면 표시 안 함
        rows.push({ nm:(indiNm(cr)||cd), oc:(or_?oc:'-'), cc:cc, ov:ov, cv:cv, add:!or_ });
      });
      Object.keys(oM).forEach(function(cd){
        if(seen[cd]) return;
        var or_=oM[cd];
        rows.push({ nm:(indiNm(or_)||cd), oc:calOf(or_), cc:'-', ov:r2(or_.weigval), cv:null, del:true });
      });

      if(Math.abs(cT-oT)<0.05 && !rows.length) return;           // 완전 동일 → 배너 없음

      var dT=r2(cT-oT), sgn=function(d){ return (d>0?'▲ +':(d<0?'▼ ':'')) + f1(Math.abs(d)); };
      var h = '⚠️ <b>승인('+esc(mst.approvedttm||'')+') 이후 수치가 달라졌습니다</b> — 종합 '
            + '<b>'+f1(oT)+'점('+gradeOf(oT)+')</b> → <b>'+f1(cT)+'점('+gradeOf(cT)+')</b>'
            + (Math.abs(dT)>=0.005 ? ' <b>('+sgn(dT)+'점)</b>' : '')
            + (gradeOf(oT)!==gradeOf(cT) ? ' <b>· 등급 변동</b>' : '')
            + ' <a href="#" id="er-apprMore" style="color:#8a5a00;text-decoration:underline;font-weight:800;">변경내용 보기</a>';
      h += '<div id="er-apprDetail" style="display:none;margin-top:8px;">'
         + '<div style="margin-bottom:4px;">구조 '+f1(oS)+' → '+f1(cS)+'점 · 의료(과정·결과) '+f1(oC)+' → '+f1(cC)+'점</div>';
      if(rows.length){
        h += '<table style="width:100%;border-collapse:collapse;font-size:.92em;">'
           + '<tr style="background:#fdf0d0;"><th style="border:1px solid #e2c589;padding:3px 6px;text-align:left;">지표</th>'
           + '<th style="border:1px solid #e2c589;padding:3px 6px;">승인 당시</th>'
           + '<th style="border:1px solid #e2c589;padding:3px 6px;">현재</th>'
           + '<th style="border:1px solid #e2c589;padding:3px 6px;">증감</th></tr>';
        rows.forEach(function(x){
          var tag = x.add? ' <b>(승인 후 생성)</b>' : (x.del? ' <b>(사라짐)</b>' : '');
          var d = (x.ov!=null && x.cv!=null)? r2(x.cv-x.ov) : null;
          h += '<tr><td style="border:1px solid #e2c589;padding:3px 6px;">'+esc(x.nm)+tag+'</td>'
             + '<td style="border:1px solid #e2c589;padding:3px 6px;text-align:center;">'+esc(x.oc)+(x.ov!=null?' · '+f1(x.ov)+'점':'')+'</td>'
             + '<td style="border:1px solid #e2c589;padding:3px 6px;text-align:center;">'+esc(x.cc)+(x.cv!=null?' · '+f1(x.cv)+'점':'')+'</td>'
             + '<td style="border:1px solid #e2c589;padding:3px 6px;text-align:center;">'+(d==null?'-':(Math.abs(d)<0.005?'-':sgn(d)+'점'))+'</td></tr>';
        });
        h += '</table>';
      } else {
        h += '<div>지표별 점수는 그대로이고 합계만 달라졌습니다(반올림·가중치 확인 필요).</div>';
      }
      h += '<div style="margin-top:6px;">거래처에는 <b>승인 당시 PDF</b>가 제공되고 있습니다. 현재 수치로 갱신하려면 '
         + '<b>승인취소 → 재승인 → PDF 재생성(화면생성) → 저장</b> 순으로 진행하십시오.</div></div>';
      bn.innerHTML=h;
      bn.style.display='block';
      var mo=el('er-apprMore');
      if(mo) mo.onclick=function(ev){ ev.preventDefault();
        var d=el('er-apprDetail'); if(!d) return;
        var on=(d.style.display==='none'); d.style.display=on?'block':'none';
        mo.textContent=on?'변경내용 닫기':'변경내용 보기';
      };
    }catch(e){}
  }

  function loadSavedTexts(){
    jQuery.ajax({ url: ctx+'/main/loadEvalReport.do', type:'POST', dataType:'json',
      data:{ hospCd:hospCd, evalYm:curYm },
      success:function(res){
        var mst = res && res.mst;
        var texts = (res && res.texts) || [];
        savedKeys={};
        norYn = (res && res.norYn) ? String(res.norYn) : 'N';   // 운영사용 여부 → Ⅳ 이하 공개/숨김 + 배지
        _norLoaded = true;
        erApplyNorYn();
        // ① 목표값 먼저(차등제 마스터) — TPL 자리표시자({goalScore} 등)가 최신 목표를 쓰도록
        applyGoalDefault(res && res.goal);
        // ② 전사 표준문구(TBL_EVAL_REPORT_TPL) — DB 문구가 내장 기본값을 대체
        applyTpls((res && res.tpls) || []);
        // ③ 병원별 저장 문구 override 적용 (+ savedKeys 갱신 — 자동 문구가 저장본을 덮지 않게)
        var map={};
        texts.forEach(function(t){ map[t.sectkey]=t.content; savedKeys[t.sectkey]=1; });
        editables().forEach(function(e){ var k=e.getAttribute('data-key'); if(map[k]!=null) e.innerHTML=map[k]; });
        // ★ 목표등급·목표점수는 '차등제 마스터'가 우선 — 저장된 옛 목표 문구(override)를 현재 등록값으로 정정.
        //   (등급을 수정하면 보고서에 그 수정값이 반영되어야 함. 이력 열람은 뒤에서 스냅샷 메타가 다시 덮어씀)
        applyGoalDefault(res && res.goal);
        syncGoalBadge();       // 본문 목표등급과 표지 뱃지 일치(혼재 방지)
        /* ★승인 여부를 <renderGoalSummary 앞에서> 확정한다 (2026-08-11) —
             핵심 진단의 '옛 점수 자동 갱신'(_staleNum)이 이 값을 본다. setStatus 는 아래(배지·버튼까지
             함께 갱신)에서 다시 부르지만, 그때는 이미 문구가 만들어진 뒤라 승인본이 덮여 버린다.
           ※승인본은 확정본이므로 수치가 달라져도 문장을 손대지 않는다 —
             달라진 사실은 _erApproveDiff 배너가 위너넷에게 따로 알려 준다. */
        approved = !!(mst && mst.status === 'APPROVED');
        renderGoalSummary();   // 목표값 확정 후 부족점수/등급표 재계산
        _erSaved = !!mst;      // 저장 이력(MST 행) 존재 여부 → 신규/저장됨 구분
        _erDirty = false;      // 방금 로드 = 변경 없음
        setStatus(mst && mst.status ? mst.status : 'DRAFT');
        pdfPath = (mst && mst.pdfpath) ? String(mst.pdfpath) : '';
        updatePdfUi();
        _erApproveDiff(mst);   // [정본=PDF 기준] 승인 후 수치 변동 시 위너넷에 경고 배너
        /* [정본=PDF 기준 · 2026-08-03 사용자 확정] 병원(거래처)에는 본문 '화면'을 주지 않는다 —
             화면은 열 때마다 최신 재계산이라 승인 PDF 와 달라질 수 있고, 그 차이가 그대로 병원에
             보이면 "보고서와 다르다" 혼선이 된다. 거래처는 승인 시점 PDF(👁 PDF보기)만 본다.
             편집은 이미 er-hospview 로 막혀 있고, 여기서 본문 자체를 감춰 열람 권한도 주지 않는다.
             ※ NOR_YN='Y'(사용운영만) 병원은 PDF 도 안 주므로(2026-07-29 규칙) 안내만 남긴다.
             ※ 1단계는 위너넷만 진입하므로 지금은 동작 없음 — 2단계 공개 시 자동 적용되는 안전장치. */
        if(!isWinner){
          var _nb9 = el('er-notice');
          if(_nb9 && !(pdfPath && norYn!=='Y')){
            _nb9.classList.add('er-hospmsg');                     // er-hospview 의 .er-notice 숨김을 이 건만 해제
            _nb9.textContent = '승인 확정본(PDF) 준비 중입니다. 준비되면 이 화면에서 열람하실 수 있습니다.';
          } else if(_nb9){ _nb9.classList.remove('er-hospmsg'); }
          _erHospPdfShow();                                       // 첨부본이 있으면 클릭 없이 바로 펼침
        }
        editables().forEach(function(e){ e.contentEditable='false'; });
        editing=false; el('evalReport').classList.remove('er-editmode');
        if(isWinner){ var b=el('er-btnEdit'); b.textContent='✏️ 편집켜기'; b.classList.remove('er-on'); }
        erMrInit();     // Ⅵ 의무기록 표 — 저장분이 없으면 '해당 없음' 안내행
        erPaginate();   // 문구 확정(자동/저장 override 반영) 후 A4 분할
        applyHstSnapshot();   // 이력 열람이면 그 시점 문구로 덮어써 재현
        _draftCheck();  // 미저장 초안이 남아 있으면 복구 제안 (F5 근본 보호)
        /* 문서 열람 기록 — 일반병원(거래처)이 볼 때만 남긴다(위너넷 열람은 서버에서도 SKIP).
           저장된 보고서(mst)가 있을 때만 기록 = 아직 만들지 않은 달을 '읽음'으로 만들지 않는다. */
        if(!isWinner && mst && !_erReadonly){
          jQuery.ajax({ url: ctx+'/main/markEvalReportRead.do', type:'POST', dataType:'json',
                        data:{ hospCd:hospCd, evalYm:curYm } });
        }
      },
      error:function(){ setStatus('DRAFT'); _draftCheck(); }   // 저장분 조회가 실패해도 초안 복구는 제안
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
    // dirty = 사용자가 실제로 편집했는지(화면이 확실히 앎). 서버는 이 값이 true 일 때만 변경이력을 남긴다.
    //   HTML 재직렬화 차이로 서버 문자열 비교가 어긋나 '안 바뀐 저장'이 이력을 만드는 문제를 원천 차단.
    var payload = { hospCd:hospCd, evalYm:curYm, title:(hospNm||'')+' 적정성평가 컨설팅 보고서',
      goalGrade:goalGradeVal(), goalScore:goalScoreVal(),
      structScore:Math.round(scores.struct*10)/10, careScore:Math.round(scores.care*10)/10, totalScore:Math.round(scores.total*10)/10,
      dirty: !!_erDirty,
      texts:collectTexts() };
    jQuery.ajax({ url: ctx+'/main/saveEvalReport.do', type:'POST', contentType:'application/json', dataType:'json',
      data: JSON.stringify(payload),
      success:function(res){ if(res && res.result==='OK'){ _draftClear(); if(onOk) onOk(); } else { erSwal('error','저장 실패: '+((res&&res.message)||''), {title:'오류'}); if(onErr) onErr(); } },
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
      success:function(res){ if(res && res.result==='OK'){
          /* 승인이 풀렸으니 '승인본은 건드리지 않는다'로 막아 뒀던 자동 갱신(핵심 진단의 옛 종합점수)을
             <그 자리에서> 반영한다. 안 그러면 화면을 나갔다 다시 들어와야 바뀐다(2026-08-11 확인).
             ★알림은 <실제로 바뀐 게 있을 때만> 그렇게 말한다 — 안 바뀌었는데 '갱신했다'고 하면 거짓말이 된다. */
          var _dcTxt = function(){ var e=document.querySelector('#evalReport [data-key="diag_core"]'); return e? (e.textContent||'') : ''; };
          var _before = _dcTxt();
          setStatus('DRAFT');
          try{ renderGoalSummary(); }catch(e){}
          toast(_dcTxt() !== _before
                ? '승인이 취소되었습니다. 종합점수가 달라져 핵심 진단 문구를 현재 값으로 갱신했습니다.'
                : '승인이 취소되었습니다.');
        } else erSwal('error','처리 실패: '+((res&&res.message)||''), {title:'오류'}); },
      error:function(){ erSwal('error','승인 처리 중 오류가 발생했습니다.', {title:'오류'}); }
    });
  }
  function _erDoApprove(){
    // ★ 승인 시 '미저장 변경(_erDirty)이 있을 때만' 저장한다.
    //   무조건 저장하면 내용이 그대로여도 서버가 이력 1건을 만들 수 있고(HTML 미세차이로 비교가 어긋남),
    //   그 이력에는 '최종본'이 담겨 이력 최신 줄이 최종본으로 보이는 문제가 생긴다.
    if(_erDirty){ doSave(function(){ _erSaved=true; _erDirty=false; _erApproveCall(); }); }
    else { _erApproveCall(); }
  }
  function _erApproveCall(){
    var snapshot = JSON.stringify({ scores:scores, indicators:indicators, evalYm:curYm });
    jQuery.ajax({ url: ctx+'/main/approveEvalReport.do', type:'POST', contentType:'application/json', dataType:'json',
      data: JSON.stringify({ hospCd:hospCd, evalYm:curYm, cancel:'N', snapshotJson:snapshot }),
      success:function(res){
        if(res && res.result==='OK'){
          setStatus('APPROVED');
          // 승인 완료 → 묻지 않고 바로 PDF 생성·미리보기로 진행(2026-07-23 사용자 확정)
          //   — 미리보기 모달에 [📄 파일서버 저장]/[✕ 닫기]가 있어 저장 여부는 거기서 결정하면 된다.
          toast('승인되었습니다.');
          erPickPdf();
        }
        else erSwal('error','처리 실패: '+((res&&res.message)||''), {title:'오류'});
      },
      error:function(){ erSwal('error','승인 처리 중 오류가 발생했습니다.', {title:'오류'}); }
    });
  }

  // ===== 첨부 PDF (아래한글 완성본 하이브리드) =====
  //  · 툴바: 첨부 전 = [📎 PDF 첨부] / 첨부 후 = [👁 PDF 보기] 하나만 (헷갈림 방지)
  //  · 교체·해제는 '보기' 모달 안에서 (위너넷만)
  function updatePdfUi(){
    var has = !!pdfPath;
    var dlUrl = has ? (ctx+'/sftp/download.do?filePath='+encodeURIComponent(pdfPath)) : '#';
    var vb = el('er-pdfView');
    vb.style.display = has ? '' : 'none';                                   // 첨부돼 있으면: 보기 버튼
    if(_erReadonly){                                                       // 이력 열람: 첨부·교체는 잠그고 '보기'만 허용
      var hpdf = (_erHstInfo && _erHstInfo.pdf) ? _erHstInfo.pdf : '';
      el('er-btnPdf').style.display='none';
      var mr0=el('er-pdfModalReplace'); if(mr0) mr0.style.display='none';
      vb.style.display = (hpdf || has) ? '' : 'none';                      // 이력 PDF가 있으면 현재 첨부가 없어도 보기 가능
      vb.textContent = hpdf ? '👁 이력 PDF보기' : '👁 PDF보기';
      vb.title = hpdf ? '이 이력 시점의 첨부 PDF를 봅니다' : '현재 첨부된 PDF를 봅니다';
      return;
    }
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
    //   ★ 사용운영만 하는 병원(NOR_YN='Y')은 Ⅳ 이하가 비공개다. 이 규칙이 생기기 전에 첨부된 PDF 에는
    //     Ⅳ 이하가 들어 있을 수 있으므로 병원에게 링크를 주지 않는다(2026-07-29).
    var bn=el('er-pdfBanner');
    if(!isWinner && has && norYn!=='Y'){ bn.style.display=''; el('er-pdfBannerLink').href=dlUrl; }
    else bn.style.display='none';
    if(!isWinner && norYn==='Y'){ vb.style.display='none'; }   // 👁 PDF보기 버튼도 동일 이유로 숨김
    // ⑤ 메일발송 — 위너넷 + 승인됨 + 첨부 PDF 가 있을 때만 (작성중 문서가 병원에 나가지 않게)
    var bm=el('er-btnMail'); if(bm) bm.style.display = (isWinner && approved && has) ? '' : 'none';
  }

  /* ===== 메일 발송 (첨부 PDF 를 그대로 보냄) — 위너넷 전용 ===== */
  window.erMailOpen = function(){
    if(!isWinner){ return; }
    if(!curYm){ erSwal('warning','먼저 평가년월을 조회하세요.'); return; }
    if(!approved){ erSwal('warning','승인된 보고서만 메일로 보낼 수 있습니다.\n먼저 ✔승인하세요.'); return; }
    if(!pdfPath){ erSwal('warning','첨부된 PDF가 없습니다.\n승인 후 [📎 PDF첨부]를 먼저 진행하세요.'); return; }
    el('er-mailWho').textContent = '— ' + (hospNm||'') + ' ' + (curYm? curYm.substring(0,4)+'.'+curYm.substring(4,6) : '');
    // 마지막 발송 주소가 있으면 그대로 다시 제안(이메일 별도 관리가 붙기 전까지의 수동 운용)
    if(!el('er-mailTo').value) el('er-mailTo').value = _erLastSendEmail || '';
    el('er-mailSubject').value = erFillTpl(TPL_MAIL.subject);
    el('er-mailBody').value    = erFillTpl(TPL_MAIL.body);
    el('er-mailNote').textContent = '';
    el('er-mailModal').style.display = 'flex';
  };
  window.erMailClose = function(){ el('er-mailModal').style.display='none'; };
  var _erLastSendEmail = '';
  window.erMailSend = function(){
    var to = (el('er-mailTo').value||'').trim();
    if(!to){ el('er-mailNote').textContent = '받는 사람 주소를 입력하세요.'; el('er-mailTo').focus(); return; }
    var btn = el('er-mailSendBtn');
    btn.disabled = true; btn.textContent = '📨 보내는 중…';
    // 본문은 줄바꿈만 <br> 로 바꿔 HTML 메일로 보낸다(태그 입력은 그대로 살림 — 담당자가 링크 등을 넣을 수 있게)
    var html = String(el('er-mailBody').value||'').replace(/\n/g,'<br>');
    jQuery.ajax({
      url: ctx+'/main/sendEvalReportMail.do', type:'POST', contentType:'application/json', dataType:'json',
      data: JSON.stringify({ hospCd:hospCd, evalYm:curYm, to:to, subject:el('er-mailSubject').value, content:html }),
      success:function(r){
        btn.disabled=false; btn.textContent='📨 보내기';
        if(r && r.result==='OK'){
          _erLastSendEmail = to;
          erMailClose();
          erSwal('success','메일을 보냈습니다.\n' + to);
        } else {
          el('er-mailNote').textContent = (r && r.message) ? r.message : '발송에 실패했습니다.';
        }
      },
      error:function(){ btn.disabled=false; btn.textContent='📨 보내기'; el('er-mailNote').textContent='서버 통신 오류로 보내지 못했습니다.'; }
    });
  };

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
    /* 편집 UI(툴바·그림 조절바·손잡이)가 그대로 캡처되면 PDF에 찍힌다 → 반드시 먼저 정리.
       PDF는 승인 후에만 가능해서 erToggleEdit 은 여기서 안 먹는다 → _erEditOff 사용(2026-07-22). */
    _erEditOff();
    erCropClose();                                        // 잘라오기 창이 열려 있으면 닫는다
    /* A4 분할 모드(er-paged)면 화면의 A4 장(.er-autopage)을 그대로 1:1 캡처 — 화면 = PDF.
       ★반드시 _erEditOff 뒤에서 잡는다 — 편집을 끄는 순간 erPaginate 가 분할을 켜며 원본(.er-page)이
         숨겨지므로, 앞에서 잡으면 숨은 원본을 캡처해 빈 PDF 가 된다(2026-08-03 A4 재가동). */
    var _paged9 = el('evalReport').classList.contains('er-paged');
    var pages = doc9.querySelectorAll(_paged9 ? '.er-autopage' : '.er-page');
    if(!pages.length){ erSwal('warning','보고서 페이지가 없습니다.'); return; }
    toast('PDF 생성 중… 잠시만 기다려 주세요.');
    var _root = el('evalReport');
    _root.classList.add('er-pdfcap');                     // 편집영역 파란 하이라이트 제거(캡처용)
    document.body.classList.add('er-capturing');          // 손잡이·조절바 숨김(보고서 밖에 있어 er-pdfcap 로는 안 잡힘)
    if(document.activeElement && document.activeElement.blur) document.activeElement.blur();   // 포커스 잔상 제거
    var prevZoom = _erZoom; _erZoom = 1; erApplyZoom();   // 배율 1(html2canvas 는 CSS zoom 미지원)
    function restore(){ _root.classList.remove('er-pdfcap'); document.body.classList.remove('er-capturing'); _erZoom=prevZoom; erApplyZoom(); }
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
      /* ★er-indbox 를 후보에 넣어야 그룹라벨이 산다 — 없으면 라벨의 '직전 후보'가 지표제목(헤더)이 되어
         '헤더 바로 뒤 분할 금지' 규칙에 라벨이 후보에서 제외됨(구조/과정/결과 분리 안 되던 원인, 2026-07-23).
         er-ana/def/plan(문단 시작)도 후보 — 긴 분석박스가 문장 중간이 아닌 문단 사이에서 잘리게.
         er-anabar('분석 내용' 바)는 헤더 취급 — 바로 뒤(첫 문단 앞)에서 끊겨 바만 페이지 끝에 남는 것 방지. */
      var HEAD = ['er-eyebrow','er-subh','er-grplabel','er-indhead','er-anabar'];
      /* ★Ⅵ 의무기록에 붙인 그림·표(.er-mrbody 직계)도 분할 후보에 넣는다(2026-08-03).
           종전 목록에 없어서 ① 긴 Ⅵ 페이지는 '흰 여백 폴백'으로 그림 한복판이 잘리고,
           ② '⤓ 새 장에서'(er-pgbreak)를 지정해도 PDF(화면 생성=html2canvas 경로)에서는
           아무 효과가 없었다 — 인쇄 CSS(break-before:page)는 window.print() 에만 적용되기 때문. */
      /* ★er-ana/def/plan(박스 안 문단)을 후보에서 제외(2026-08-03) — 문단 사이를 자르게 두니
           지표 박스가 테두리째 두 장으로 갈라져 보기 흉했다(지역사회복귀율 하단 고아 블록).
           이제 절단은 '지표 박스 사이'에서만 — 박스 하나가 통째로 다음 장으로 넘어간다. */
      var sel = '.er-eyebrow, .er-subh, .er-cards, .er-tw, .er-callout, .er-grplabel, .er-indhead, .er-rec, .er-after, .er-fn, .er-docfoot, .er-ind, .er-indbox, .er-anabar, .er-mrbody > img, .er-mrbody > table, .er-mrbody > p, .er-mrbody > div';
      var pTop = pg.getBoundingClientRect().top, items=[], list=pg.querySelectorAll(sel);
      for(var i=0;i<list.length;i++){
        var e=list[i], t=(e.getBoundingClientRect().top - pTop)*sf, isH=false;
        for(var h=0;h<HEAD.length;h++){ if(e.classList.contains(HEAD[h])){ isH=true; break; } }
        // ★ 그룹라벨(구조지표/과정지표/결과지표)은 '강제 분할점' — 항상 새 A4 페이지에서 시작(2026-07-23)
        //   '⤓ 새 장에서'(er-pgbreak) 그림도 강제 분할점 — 단 grp 의 '첫 번째 제외' 규칙과 무관해야 하므로 brk 로 따로 든다
        items.push({ top:Math.round(t), head:isH, grp:e.classList.contains('er-grplabel'),
                     brk:e.classList.contains('er-pgbreak') });
      }
      items.sort(function(a,b){ return a.top-b.top; });
      // 첫 그룹라벨(구조지표)은 Ⅲ 헤더·안내문과 같은 장에 남아야 하므로 강제 분할 제외 — 2번째부터만 강제
      var ys=[], grpSeen=0;
      for(var j=0;j<items.length;j++){
        var isGrp=items[j].grp; if(isGrp) grpSeen++;
        if(items[j].top<=4) continue;
        if(j>0 && items[j-1].head) continue;   // 직전이 헤더면 이 지점(헤더 다음)에서는 못 끊음
        // 블록 시작보다 5px 위(위쪽 여백 구간)에서 끊음 — 정확히 top에서 끊으면 테두리·그림자 1~2px가
        // 이전 장 끝에 얇은 선으로 남음(총평 박스 상단 선 잔상, 2026-07-23)
        // '⤓ 새 장에서' 그림(brk)은 위치와 무관하게 강제 분할 — 그룹라벨의 '첫 번째 제외' 규칙과 별개
        ys.push({ top:Math.max(1, items[j].top-5), force:(isGrp && grpSeen>1) || !!items[j].brk });
      }
      return ys;
    }
    function _erAddSlice(canvas, y0, y1, topMm){   // 캔버스 [y0,y1) 구간을 A4 한 장으로 추가(원본 폭, 자연 높이). topMm=상단 배치 위치(기본 mg)
      var hpx = y1 - y0; if(hpx<=0) return;
      var pc = document.createElement('canvas'); pc.width=canvas.width; pc.height=hpx;
      pc.getContext('2d').drawImage(canvas, 0, y0, canvas.width, hpx, 0, 0, canvas.width, hpx);
      if(idx>0) pdf.addPage();
      pdf.addImage(pc.toDataURL('image/jpeg',0.8), 'JPEG', mg, (topMm==null? mg : topMm), iw, hpx*iw/canvas.width);
      idx++;
    }
    /* ★진행속도 개선 (2026-08-03) — 종전에는 장(.er-page)마다 html2canvas 를 따로 불렀다.
         html2canvas 는 호출할 때마다 '문서 전체'를 복제한 뒤 그 요소만 그리므로, 장이 10개면
         (붙여넣은 대용량 그림까지 포함한) 문서 복제 + 이미지 디코드가 10번 반복됐다 — 이게 느림의 주범.
         → 보고서 전체(.er-doc)를 '한 번만' 캡처하고, 큰 캔버스에서 장별 영역을 잘라 쓴다.
           복제·렌더 1회라 장 수가 늘어도 캡처 비용이 거의 늘지 않는다. 장별 처리 로직은 종전 그대로.
         · onclone: 장의 그림자·둥근모서리를 지우고 배경 흰색 — 장 경계를 정확히 잘라도 종전
           per-page 캡처(backgroundColor 흰색)와 같은 결과가 되게.
         · capScale: 캔버스 한 변 상한(~32,767px) 보호 — 문서가 아주 길면 배율을 그만큼만 낮춘다. */
    // 캡처된 '장 캔버스' → A4 배치(종전 per-page 로직 그대로 함수로 묶음 — 전체캡처/폴백 양쪽에서 공용)
    function _erProcPage(pg, canvas){
      var breaks = _erBreakYs(pg, 1);
      var mappedH = canvas.height * iw / canvas.width;   // 전체를 폭 iw 로 놨을 때 mm 높이
      if(mappedH <= maxHmm){                             // 한 장에 들어감 → 축소 없이 그대로
        if(idx>0) pdf.addPage();
        pdf.addImage(canvas.toDataURL('image/jpeg',0.8), 'JPEG', mg, mg, iw, mappedH); idx++;
        return;
      }
      // 길면 → A4 여러 장. DOM 블록 시작 위치에서만 끊음(제목+박스 안 갈라짐). 후보 없으면 여백 폴백.
      var sf = canvas.height / (pg.getBoundingClientRect().height || pg.offsetHeight);   // CSS px → canvas px
      var bys = breaks.map(function(v){ return { top:Math.round(v.top*sf), force:v.force }; });
      var ctx = canvas.getContext('2d'), maxHpx = Math.floor(maxHmm * canvas.width / iw), y = 0, minStep = Math.floor(maxHpx*0.25);
      // ★ 이어지는 장(중간에서 잘려 넘어온 페이지)은 상단에 14mm 여백 — 대분류 시작 장처럼 답답하지 않게(2026-07-23)
      var contMm = 14, contPx = Math.floor(contMm * canvas.width / iw);
      while(y < canvas.height){
        var topMm = (y>0? mg+contMm : mg);
        var limit = y + maxHpx - (y>0? contPx : 0);   // 여백만큼 담는 양도 줄여 하단 넘침 방지
        // ★ 절단선을 근처 '완전한 흰 여백 줄'로 스냅 — 후보 top에서 그대로 자르면 다음 블록의
        //   테두리·그림자 1~2px 이 이전 장 끝에 얇은 조각으로 남는다(총평 박스 잔상, 2026-07-23)
        var snapWhite = function(t){ return _erWhiteCut(ctx, canvas.width, t, Math.max(y+1, t-60)); };
        // ★ 그룹라벨(구조지표/과정지표/결과지표)이 이 장 범위 안에 있으면 남은 공간과 무관하게 그 앞에서 끊는다
        var fc = -1;
        for(var i0=0;i0<bys.length;i0++){ var b0=bys[i0]; if(b0.force && b0.top>y+8 && b0.top<limit){ fc=b0.top; break; } }
        if(fc>=0){ fc=snapWhite(fc); _erAddSlice(canvas, y, fc, topMm); y = fc; continue; }
        if(limit >= canvas.height){ _erAddSlice(canvas, y, canvas.height, topMm); break; }
        var cut = -1;
        for(var i=0;i<bys.length;i++){ var b=bys[i]; if(b.top>y+minStep && b.top<=limit) cut=b.top; else if(b.top>limit) break; }
        cut = (cut<0) ? _erWhiteCut(ctx, canvas.width, limit, Math.max(y+1, limit - Math.floor(maxHpx*0.4)))
                      : snapWhite(cut);
        _erAddSlice(canvas, y, cut, topMm); y = cut;
      }
    }
    // [폴백] 종전 '장별 캡처' — 전체 캡처가 실패하면 이 길로 자동 전환(느리지만 확실)
    function _erLegacyCapture(){
      pdf = new jsPDF('p','mm','a4'); idx = 0;   // 실패 도중 담긴 장이 있을 수 있어 처음부터 다시
      var c2 = Promise.resolve();
      pages.forEach(function(pg){
        if(!pg.getClientRects().length) return;
        c2 = c2.then(function(){
          return html2canvas(pg, { scale:1.3, backgroundColor:'#ffffff', useCORS:true, logging:false })
            .then(function(cv){ _erProcPage(pg, cv); });
        });
      });
      return c2;
    }
    var docRect = doc9.getBoundingClientRect();
    var capScale = Math.min(1.3, 30000 / Math.max(1, doc9.scrollHeight));
    var chain = html2canvas(doc9, { scale:capScale, backgroundColor:'#ffffff', useCORS:true, logging:false,
      onclone:function(d){
        var dd=d.querySelector('#evalReport .er-doc'); if(dd) dd.style.background='#ffffff';
        Array.prototype.forEach.call(d.querySelectorAll('#evalReport .er-page, #evalReport .er-autopage'), function(p){
          p.style.boxShadow='none'; p.style.borderRadius='0';
        });
      }
    }).then(function(big){
      // 캔버스 한계를 넘으면 브라우저가 '빈(0×0 또는 그리기 실패) 캔버스'를 조용히 돌려준다 → 폴백으로
      if(!big || !(big.width>10) || !(big.height>10)) throw new Error('전체 캡처 캔버스가 비어 있음');
      var sfX = big.width / (docRect.width||1), sfY = big.height / (docRect.height||1);
      pages.forEach(function(pg){
        // 숨긴 장(운영사용 아닌 병원의 Ⅳ 이하 = #er-page4)은 PDF에도 넣지 않는다.
        if(!pg.getClientRects().length) return;
        var pr = pg.getBoundingClientRect();
        var sx=Math.max(0, Math.round((pr.left-docRect.left)*sfX)),
            sy=Math.max(0, Math.round((pr.top -docRect.top )*sfY)),
            sw=Math.min(big.width -sx, Math.round(pr.width *sfX)),
            sh=Math.min(big.height-sy, Math.round(pr.height*sfY));
        if(sw<=0 || sh<=0) return;
        var canvas=document.createElement('canvas'); canvas.width=sw; canvas.height=sh;
        canvas.getContext('2d').drawImage(big, sx, sy, sw, sh, 0, 0, sw, sh);
        _erProcPage(pg, canvas);
      });
    }).catch(function(e){
      console.warn('[PDF] 전체 캡처 실패 → 종전 장별 캡처로 폴백:', e);
      toast('PDF 생성 중… (호환 모드)');
      return _erLegacyCapture();
    });
    chain.then(function(){
      restore();
      var yy=curYm.substring(0,4), mm=curYm.substring(4,6), gg=(typeof goalGradeVal==='function')?goalGradeVal():'';
      _erGenName = (hospNm||'적정성평가').replace(/[\\/:*?"<>|]/g,'') + ' 적정성평가 보고서('+yy+'.'+mm+') 목표'+gg+'.pdf';
      _erGenBlob = pdf.output('blob');
      _erShowGenPreview();   // 저장 전 미리보기
    }).catch(function(e){ restore(); erSwal('error','PDF 생성 오류: '+((e&&e.message)||e), {title:'오류'}); });
  };

  function _erPdfApplyZoom(){ var f=el('er-pdfFrame'); if(f && _pdfObjUrl) f.src=_pdfObjUrl; }

  function _erShowGenPreview(){
    _pdfSeq++;                                             // 진행 중 서버 fetch 무효화
    el('er-pdfModalTitle').textContent = '📄 저장 전 미리보기 — ' + _erGenName;
    var old=el('er-pdfFrame'), nf=old.cloneNode(false); nf.removeAttribute('src'); old.parentNode.replaceChild(nf, old);
    el('er-pdfLoading').style.display='none';
    if(_pdfObjUrl) URL.revokeObjectURL(_pdfObjUrl);
    _pdfObjUrl = URL.createObjectURL(_erGenBlob);
    _erPdfApplyZoom();                                                               // 배율(#zoom) 프래그먼트를 붙여 src 설정
    el('er-pdfGenSaveBtn').style.display=''; el('er-pdfPickBtn').style.display='';   // 저장/파일선택 노출
    el('er-pdfModalReplace').style.display='none';                                   // 교체검색 숨김
    el('er-pdfModal').style.display='flex';
    try{ _mrSyncPgMarks(); }catch(e){}   // 모달 위 표지 걷음(2026-08-03)
  }

  // 미리보기에서 [파일서버 저장] → 생성해둔 PDF(_erGenBlob) 업로드(SFTP EVALRPT + PDF_PATH).
  window.erPdfGenUpload = function(){
    if(!_erGenBlob){ erSwal('warning','생성된 PDF가 없습니다. 다시 시도해 주세요.'); return; }
    /* [2026-08-03] "저장하시겠습니까?" 확인창 제거 — 승인→생성→미리보기→저장 사슬에서 마지막 군더더기.
         [📄 파일서버 저장] 버튼을 누른 것 자체가 의사표시고, 미리보기로 내용도 이미 확인한 뒤다.
         잘못 저장해도 다시 생성·교체(🔍 검색)가 되고 이전 파일은 이력으로 남는다(HST). */
    _erDoPdfGenUpload();
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
