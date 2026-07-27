<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%--
  업무매뉴얼 (위너넷 전용) — 2026-07-27
    · 구성 원칙(사용자 요청): 로그인부터 화면 순서대로 자연스럽게 흐르는 <사용법> 중심.
      규칙·이론은 최소로 두고, "어디로 들어가서 무엇을 누르고 무엇을 확인하는지"를 적는다.
    · 단계 카드(홈) → 그 화면 사용법 → 하단 '이전/다음 단계'로 흐름이 이어진다. 검색은 언제든 가능.
    · 권한: '적정성평가 월간보고서'와 동일 — 사이드바 메뉴는 위너넷만 보이고, 화면에서도 wnnYn 으로 막는다.
    · ★.dashboard-wrapper 로 감싸야 한다(margin-left:264px, style.css:1951). 없으면 고정 사이드바 뒤로 잘린다.
    · ★기능이 늘어나면 STEPS / EXTRA 배열에 한 줄 추가하면 끝(JSP만 수정 → 재빌드 불필요).
--%>
<style>
  .wm-wrap{ padding:16px 20px 30px; color:#28323c; max-width:100%; box-sizing:border-box; }
  .wm-wrap *{ box-sizing:border-box; max-width:100%; }
  .wm-head{ display:flex; align-items:center; gap:10px; flex-wrap:wrap; }
  .wm-head h2{ font-size:20px; font-weight:800; margin:0; color:#1f3b73; }
  .wm-badge{ font-size:11.5px; font-weight:700; color:#1f3b73; background:#e8eefb; border:1px solid #c7d6f2; border-radius:10px; padding:1px 8px; }
  .wm-desc{ font-size:13px; color:#6b7a89; margin:4px 0 13px; line-height:1.7; }

  .wm-search{ margin-bottom:16px; padding:13px 15px; background:linear-gradient(180deg,#f4f8fd,#eef4fb); border:1px solid #d8e4f2; border-radius:12px; }
  .wm-search .rowin{ display:flex; gap:8px; flex-wrap:wrap; align-items:center; }
  .wm-search input[type=text]{ height:40px; flex:1 1 240px; max-width:440px; border:1px solid #c3d3e6; border-radius:9px; padding:0 13px; font-size:14.5px; }
  .wm-search input[type=text]:focus{ outline:none; border-color:#1f3b73; box-shadow:0 0 0 3px rgba(31,59,115,.12); }
  .wm-quick{ margin-top:8px; font-size:12.5px; color:#6b7a89; display:flex; gap:6px; flex-wrap:wrap; align-items:center; }
  .wm-quick b{ color:#37475a; margin-right:2px; }
  .wm-quick span.q{ cursor:pointer; background:#fff; border:1px solid #cfdcec; border-radius:14px; padding:3px 10px; color:#1f3b73; font-weight:600; }
  .wm-quick span.q:hover{ background:#1f3b73; color:#fff; border-color:#1f3b73; }
  .wm-btn{ height:40px; padding:0 14px; border:1px solid #1f3b73; background:#fff; color:#1f3b73; border-radius:9px; font-size:13.5px; font-weight:700; cursor:pointer; }
  .wm-btn.sm{ height:34px; padding:0 12px; font-size:12.5px; }
  .wm-btn.solid{ background:#1f3b73; color:#fff; }
  .wm-btn:disabled{ opacity:.4; cursor:default; }

  .wm-crumb{ display:flex; align-items:center; gap:7px; flex-wrap:wrap; font-size:13px; color:#6b7a89; margin-bottom:10px; min-height:32px; }
  .wm-crumb a{ color:#1f3b73; font-weight:700; cursor:pointer; }
  .wm-crumb a:hover{ text-decoration:underline; }
  .wm-crumb .sep{ color:#b6c0c9; }
  .wm-crumb .cur{ font-weight:800; color:#28323c; }

  .wm-ask{ font-size:15px; font-weight:800; color:#37475a; margin:2px 0 4px; }
  .wm-askd{ font-size:12.5px; color:#9aa7b3; margin-bottom:11px; }

  /* 홈 — 단계 카드(화면 흐름) */
  .wm-flow{ display:flex; flex-wrap:wrap; gap:10px; }
  .wm-fc{ flex:1 1 250px; min-width:230px; background:#fff; border:1px solid #dfe7ee; border-radius:12px; padding:14px 15px 13px; cursor:pointer; position:relative;
          box-shadow:0 1px 2px rgba(31,59,115,.05); animation:wmFadeUp .45s cubic-bezier(.22,.9,.25,1) both;
          transition:border-color .18s ease, box-shadow .18s ease, transform .18s ease; }
  .wm-fc:hover{ border-color:#1f3b73; box-shadow:0 6px 16px rgba(31,59,115,.16); transform:translateY(-3px); }
  .wm-fc .no{ display:inline-flex; align-items:center; justify-content:center; width:26px; height:26px; border-radius:50%;
              background:#1f3b73; color:#fff; font-size:13px; font-weight:800; }
  .wm-fc .ico{ font-size:19px; margin-left:6px; }
  .wm-fc .nm{ display:block; font-size:15px; font-weight:800; color:#1f3b73; margin:8px 0 3px; }
  .wm-fc .sub{ display:block; font-size:12.5px; color:#6b7a89; line-height:1.65; }

  /* 필요할 때 보는 화면 */
  .wm-rows{ display:flex; flex-direction:column; gap:8px; }
  .wm-row{ display:flex; align-items:center; gap:10px; background:#fff; border:1px solid #dfe7ee; border-radius:10px; padding:12px 14px; cursor:pointer;
           animation:wmFadeUp .4s cubic-bezier(.22,.9,.25,1) both;
           transition:border-color .16s ease, box-shadow .16s ease, transform .16s ease, background .16s ease; }
  .wm-row:hover{ border-color:#1f3b73; background:#f7faff; box-shadow:0 3px 10px rgba(31,59,115,.12); transform:translateX(3px); }
  .wm-row .tt{ flex:1; min-width:0; font-size:14px; font-weight:700; color:#28323c; }
  .wm-row .tt small{ display:block; font-size:12px; font-weight:400; color:#9aa7b3; margin-top:2px; }
  .wm-row .arw{ flex:0 0 auto; color:#1f3b73; font-size:16px; font-weight:800; }
  .wm-row .stp{ flex:0 0 auto; font-size:11px; font-weight:700; color:#1f3b73; background:#eaf0fa; border-radius:9px; padding:2px 8px; }

  /* 본문 */
  /* 좌측은 좁아졌으니 글자·여백도 한 단계 줄인다(내용이 화면을 덜 차지하게) */
  .wm-view{ border:1px solid #e0e6ea; border-radius:12px; background:#fff; padding:14px 15px 15px; overflow-wrap:break-word;
            animation:wmSlideIn .36s cubic-bezier(.22,.9,.25,1) both; }
  .wm-view h3{ font-size:16.5px; font-weight:800; color:#1f3b73; margin:0 0 2px; }
  .wm-view .meta{ font-size:11.5px; color:#9aa7b3; margin-bottom:10px; }
  .wm-view .go{ display:inline-block; margin-left:7px; font-size:11.5px; font-weight:700; color:#137a6c; border:1px solid #bfe0d8; background:#f2fbf8; border-radius:7px; padding:1px 8px; text-decoration:none; }
  .wm-path{ font-size:12px; background:#f2f7fd; border:1px solid #dbe7f5; border-radius:8px; padding:7px 10px; margin-bottom:10px; color:#37475a; line-height:1.6; }
  .wm-path b{ color:#1f3b73; }
  .wm-sec{ margin:10px 0 0; padding:9px 11px 10px; background:#f9fbfc; border:1px solid #eaf0f4; border-left:3px solid #1f3b73; border-radius:8px;
           animation:wmFadeUp .42s cubic-bezier(.22,.9,.25,1) both; }
  .wm-sec > b{ display:block; font-size:12.5px; color:#37475a; margin-bottom:4px; }
  .wm-sec ul{ margin:0; padding:0; list-style:none; }
  .wm-sec li{ position:relative; padding-left:13px; font-size:12.5px; line-height:1.7; }
  .wm-sec li:before{ content:''; position:absolute; left:0; top:.72em; width:5px; height:5px; border-radius:50%; background:#8fa8cf; }
  .wm-sec li b{ color:#1f3b73; }
  .wm-sec:nth-of-type(2){ animation-delay:.09s; } .wm-sec:nth-of-type(3){ animation-delay:.17s; }
  .wm-sec:nth-of-type(n+4){ animation-delay:.24s; }
  .wm-note{ margin-top:13px; padding:11px 14px; background:#fdf6e8; border:1px solid #f0dfb8; border-left:4px solid #d9a227; border-radius:9px; font-size:13px; color:#8a6414; line-height:1.8; }
  .wm-nav{ display:flex; gap:8px; flex-wrap:wrap; margin-top:18px; padding-top:14px; border-top:1px solid #eef2f5; }
  .wm-nav .sp{ flex:1; }

  /* 순서대로 하는 일 = 번호 단계 */
  .wm-steps{ counter-reset:wmS; margin-top:3px; }
  .wm-stp{ position:relative; padding:0 0 11px 34px; animation:wmFadeUp .44s cubic-bezier(.22,.9,.25,1) both; }
  .wm-stp:before{ counter-increment:wmS; content:counter(wmS); position:absolute; left:0; top:0; width:24px; height:24px; border-radius:50%;
                  background:#1f3b73; color:#fff; font-size:12.5px; font-weight:800; display:flex; align-items:center; justify-content:center; }
  .wm-stp:after{ content:''; position:absolute; left:11px; top:26px; bottom:0; width:2px; background:#dde5ef; }
  .wm-stp:last-child{ padding-bottom:0; }
  .wm-stp:last-child:after{ display:none; }
  .wm-stp .t{ font-size:13.5px; line-height:1.75; color:#28323c; }
  .wm-stp:nth-child(2){ animation-delay:.07s; } .wm-stp:nth-child(3){ animation-delay:.14s; }
  .wm-stp:nth-child(4){ animation-delay:.21s; } .wm-stp:nth-child(n+5){ animation-delay:.27s; }

  /* ── 마우스를 대면 뜻이 뜨는 말 (2026-07-27) — 어려운 용어에 점선을 깔고 설명 풍선을 붙인다 ── */
  .wm-t{ position:relative; border-bottom:1px dashed #7f9cc9; cursor:help; }
  .wm-t:hover{ background:#eef4fb; }
  .wm-t:hover::after{
    content:attr(data-tip); position:absolute; left:0; bottom:calc(100% + 9px); z-index:60;
    width:max-content; max-width:330px; white-space:normal; text-align:left;
    background:#28323c; color:#fff; font-size:12.5px; font-weight:400; line-height:1.7;
    padding:9px 12px; border-radius:9px; box-shadow:0 8px 22px rgba(0,0,0,.24);
    animation:wmTipIn .16s ease both; }
  .wm-t:hover::before{ content:''; position:absolute; left:13px; bottom:calc(100% + 3px); z-index:61;
    border:6px solid transparent; border-top-color:#28323c; animation:wmTipIn .16s ease both; }
  @keyframes wmTipIn{ from{ opacity:0; transform:translateY(5px); } to{ opacity:1; transform:none; } }
  .wm-tiphint{ font-size:12px; color:#9aa7b3; margin:-4px 0 12px; }
  .wm-tiphint u{ border-bottom:1px dashed #7f9cc9; text-decoration:none; }

  /* ── 좌: 사용법 / 우: 실제 화면 작게 보기 (2026-07-27) ─────────────────────────────
        오른쪽은 그 단계의 실제 화면을 그대로 띄워 축소한 것이다(같은 서버·같은 로그인이라 그대로 보인다).
        폭이 좁아지면(1200px 이하) 위아래로 쌓이게 한다. */
  /* 좌:우 = 약 4:6 — 사용법이 화면을 다 먹지 않게 좌측을 절반 이하로 묶고, 실제 화면 쪽에 자리를 준다 */
  /* ★두 영역을 '완전히 분리된 두 패널'로 — 각각 테두리·머리띠를 가진 별개 창처럼 보이게 한다 */
  .wm-split{ display:flex; gap:18px; align-items:flex-start; }
  .wm-split .lft, .wm-split .rgt{ background:#fff; border-radius:12px; overflow:hidden;
                                  box-shadow:0 2px 10px rgba(31,59,115,.08); }
  .wm-split .lft{ flex:0 1 40%; min-width:300px; border:2px solid #c9d8ea; }
  .wm-split .rgt{ flex:1 1 58%; min-width:340px; position:sticky; top:10px; border:2px solid #bfdcd2; }
  .wm-vline{ flex:0 0 3px; align-self:stretch; border-radius:2px;
             background:repeating-linear-gradient(180deg,#dfe6ef 0 8px,transparent 8px 14px); }
  /* 패널 머리띠 — 색을 채워서 두 영역이 확실히 갈리게 */
  .wm-panehd{ display:flex; align-items:center; gap:6px; font-size:12.5px; font-weight:800; letter-spacing:.2px;
              padding:9px 13px; margin:0; }
  .wm-panehd span{ font-weight:400; }
  .wm-panehd.lf{ background:#eaf1fb; color:#1f3b73; border-bottom:1px solid #d5e2f3; }
  .wm-panehd.lf span{ color:#6f8ab5; }
  .wm-panehd.rg{ background:#eaf6f2; color:#0f6b5c; border-bottom:1px solid #cfe6de; }
  .wm-panehd.rg span{ color:#5b978b; }
  .wm-panehd .gap{ flex:1; }
  /* 패널 안쪽에서는 본문·미리보기 자체 테두리를 없앤다(테두리 이중으로 겹치지 않게) */
  .wm-split .lft .wm-view{ border:0; border-radius:0; box-shadow:none; padding:13px 14px 15px; }
  .wm-split .rgt .wm-prev{ border:0; border-radius:0; box-shadow:none; animation:none; }
  .wm-split .rgt .wm-prev .hd{ display:none; }
  .wm-prev{ border:1px solid #dfe7ee; border-radius:12px; background:#fff; overflow:hidden;
            box-shadow:0 1px 2px rgba(31,59,115,.05); animation:wmFadeUp .45s cubic-bezier(.22,.9,.25,1) both; animation-delay:.1s; }
  .wm-prev .hd{ display:flex; align-items:center; gap:6px; padding:8px 11px; background:#f3f6fa;
                border-bottom:1px solid #e6ebf0; font-size:12.5px; font-weight:800; color:#37475a; }
  .wm-prev .bd{ position:relative; overflow:hidden; background:#f7f9fb; }
  .wm-prev iframe{ border:0; transform-origin:0 0; display:block; background:#fff; }
  .wm-prev .none{ padding:30px 20px; text-align:center; color:#9aa7b3; font-size:12.5px; line-height:1.9; }
  .wm-prev .tipbar{ padding:7px 11px; font-size:11.5px; color:#9aa7b3; border-top:1px solid #eef2f5; background:#fcfdfe; }
  @media (max-width:1200px){
    .wm-split{ display:block; }
    .wm-split .rgt{ margin-top:14px; position:static; min-width:0; }
    .wm-vline{ display:none; }
  }

  .wm-hit{ font-size:13px; color:#37475a; margin-bottom:10px; }
  .wm-hl{ background:#fff3a3; font-weight:700; animation:wmPop .3s ease both; }
  .wm-empty{ padding:28px; text-align:center; color:#9aa7b3; font-size:13.5px; line-height:1.9; border:1px dashed #dfe7ee; border-radius:12px; background:#fff; }
  .wm-deny{ margin:40px auto; max-width:520px; text-align:center; padding:28px; border:1px solid #f0c9c2; background:#fff7f6; border-radius:12px; color:#a5372a; font-size:14px; line-height:1.8; }

  @keyframes wmFadeUp{ from{ opacity:0; transform:translateY(14px); } to{ opacity:1; transform:none; } }
  @keyframes wmSlideIn{ from{ opacity:0; transform:translateX(24px); } to{ opacity:1; transform:none; } }
  @keyframes wmPop{ 0%{ background:#ffe14d; } 100%{ background:#fff3a3; } }
  .wm-head, .wm-search{ animation:wmFadeUp .42s cubic-bezier(.22,.9,.25,1) both; }
  .wm-search{ animation-delay:.07s; }
  .wm-btn{ transition:transform .12s ease, box-shadow .12s ease, background .15s ease, color .15s ease; }
  .wm-btn:hover:not(:disabled){ transform:translateY(-1px); box-shadow:0 3px 9px rgba(31,59,115,.18); }
  @media (prefers-reduced-motion: reduce){
    .wm-head,.wm-search,.wm-fc,.wm-row,.wm-view,.wm-sec,.wm-stp,.wm-hl{ animation:none !important; }
    .wm-btn,.wm-fc,.wm-row{ transition:none !important; }
  }
</style>

<div class="dashboard-wrapper">
 <div class="dashboard-ecommerce">
  <div class="container-fluid dashboard-content">

<c:choose>
<c:when test="${wnnYn ne 'Y'}">
  <div class="wm-deny">
    <div style="font-size:34px">🔒</div>
    <b>업무매뉴얼은 위너넷 담당자 전용 화면입니다.</b><br>
    권한이 필요하시면 위너넷으로 문의해 주세요.
  </div>
</c:when>
<c:otherwise>

<div class="wm-wrap">
  <div class="wm-head">
    <h2>📘 업무매뉴얼</h2>
    <span class="wm-badge">위너넷 전용</span>
  </div>
  <div class="wm-desc"><b>WinCheck+ 사용법</b>입니다. 로그인부터 화면 순서대로, <b>병원에서 직접 하는 일</b>을 적어 두었습니다. 카드를 누르면 그 화면 사용법이 나오고, 아래 <b>다음 단계</b>로 계속 이어집니다.</div>

  <div class="wm-search">
    <div class="rowin">
      <input type="text" id="wmQ" placeholder="🔍 찾는 말을 넣어 보세요 — 예) 배뇨관리, 오류점검, 총평"
             oninput="wmRender()" onkeydown="if(event.keyCode===13)wmRender()">
      <button class="wm-btn" onclick="wmHome()">처음으로</button>
    </div>
    <div class="wm-quick" id="wmQuick"></div>
  </div>

  <div class="wm-tiphint">💡 <u>점선이 있는 말</u>에 마우스를 대면 뜻이 나옵니다. 카드에 마우스를 대면 그 화면에서 하는 일이 미리 보입니다.</div>
  <div class="wm-crumb" id="wmCrumb"></div>
  <div id="wmMain"></div>
</div>

<script>
/* ══ 화면 흐름 — 로그인부터 순서대로. 새 화면이 생기면 이 배열에 한 줄 추가하면 된다 ══════════
     ico·nm·sub = 카드 표시 / path = 들어가는 길(왼쪽 메뉴 경로) / screen = 바로가기 주소
     use  = [{h:소제목, li:[...]}]  ← li 를 'S:' 로 시작하면 번호 단계로 그려진다
     note = 주의문 · tags = 검색용 별칭                                                        */
var STEPS = [
 { ico:'🔑', nm:'로그인', sub:'요양기관기호 · ID · 비밀번호로 접속', tags:'로그인 접속 비밀번호 계정 요양기관기호 아이디찾기 회원가입 winner797',
   path:'<b>http://www.winner797.co.kr</b> → 로그인',
   use:[{h:'로그인에 넣는 것은 세 가지입니다', li:[
      'S:<b>요양기관기호</b>',
      'S:<b>ID</b> — 이메일 주소입니다.',
      'S:<b>비밀번호</b>']},
    {h:'처음이거나 기억나지 않을 때', li:[
      '<b>처음 이용하는 기관</b> — 의뢰서 회신 후 <b>회원가입</b>을 하면 로그인할 수 있습니다.',
      '예전에 <b>WinCheck 를 쓰신 적이 있으면</b> 그 계정을 그대로 쓰시면 됩니다.',
      '아이디·비밀번호가 기억나지 않으면 로그인 화면의 <b>아이디 찾기 / 비밀번호 초기화</b>를 이용하세요.']}] },

 { ico:'📤', nm:'자료 올리기', sub:'SAM 파일과 입원환자현황 올리기', tags:'자료올리기 업로드 SAM 청구 환자평가표 입원환자현황 검은박스',
   path:'왼쪽 메뉴 <b>자료올리기 › 청구.평가 업로드</b>', screen:'/main/magamFileUpload.do',
   use:[{h:'순서', li:[
      'S:올릴 <b>연월</b>을 고릅니다.',
      'S:<b>청구 SAM 파일</b> 또는 <b>환자평가표</b>를 골라 올립니다.',
      'S:화면의 <b>세 번째 검은색 박스</b>가 <b>입원환자현황</b>을 올리는 자리입니다.',
      'S:올린 뒤 결과 표시를 확인합니다 — 파일 종류와 버전이 맞는지 자동으로 확인됩니다.',
      'S:이상이 없으면 다음 단계(대시보드)에서 점수를 봅니다.']},
    {h:'무엇을 올리면 무엇을 볼 수 있나', li:[
      '<b>환자평가표 SAM</b> → 월별·연간 <b>예상점수</b>와 <b>대상자</b>를 볼 수 있습니다.',
      '<b>청구 SAM 파일</b> → 항정신성 처방률(상병·처방률), 당뇨 HbA1c의 <b>청구명세서상 당뇨상병 기재</b>를 점검합니다.',
      '<b>입원환자현황</b> → 퇴원환자 확인과 <b>다음 월 평가 대상자</b>를 볼 수 있습니다.']}],
   note:'청구 SAM 과 입원환자현황은 필수는 아니지만, 올리지 않으면 점수 예측과 대상자 확인이 어렵습니다 — 세 가지 모두 올리시는 것을 권합니다.' },

 { ico:'📊', nm:'대시보드', sub:'당월 점수와 연간 예상점수 보기', tags:'대시보드 dashboard 첫화면 당월 연간 예상점수',
   path:'왼쪽 메뉴 <b>DashBoard</b>', screen:'/user/dashboard.do',
   use:[{h:'보는 방법', li:[
      '<b>전월·당월 자료를 올린 뒤</b> 들어오면, <b>당월 점수</b>와 <b>연간 예상점수</b>가 한 페이지에 나옵니다.',
      '이번 달에 무엇부터 챙길지 여기서 가늠하고 다음 화면으로 넘어갑니다.']},
    {h:'점수가 안 보이면', li:[
      '자료를 아직 안 올렸거나(<b>2단계</b>), 구조영역 등록이 안 된 경우입니다(<b>4단계</b> 참고).']}] },

 { ico:'🧾', nm:'적정성평가 현황', sub:'지표별 점수와 대상자 확인·관리', tags:'적정성평가 현황 assessment 대상자 보기 구조영역 차등제 목표점수 진료영역',
   path:'왼쪽 메뉴 <b>적정성-평가 현황</b>', screen:'/main/assessment.do',
   use:[{h:'순서', li:[
      'S:<b>연월</b>을 맞추고 조회하면 당월 예상점수와 지표별 점수가 나옵니다.',
      'S:지표 오른쪽 <b>(보기)</b> 를 눌러 대상자를 확인합니다 — <b>개선 대상자 · 결과 대상자 · 다음 월 대상자</b>.',
      'S:환자 줄을 두 번 누르면 <b>환자평가표</b> 내용을 볼 수 있습니다.']},
    {h:'★구조영역은 먼저 등록해야 점수가 나옵니다', li:[
      '구조영역 오른쪽 <b>(보기)</b> 에서 <b>목표 점수</b>와 <b>차등제 신고 결과</b>를 등록하세요.',
      '등록하기 전에는 구조영역 점수가 비어 있습니다.']},
    {h:'진료영역 점수가 나오는 조건', li:[
      '<b>환자평가표 · 청구 SAM · 입원환자현황</b>을 올리면 예상점수가 산출됩니다.',
      '지표별 점수 기준은 <b>2024년 적정성평가 결과 발표</b>를 따릅니다.',
      'DUR 점검률은 <b>만점</b>으로, 항정신성 처방률·지역사회복귀율은 <b>평균값</b>으로 넣어 계산합니다(실제 값은 최종 평가에서 확정).']},
    {h:'여기서 꼭 챙길 것', li:[
      '<b>개선 대상자</b> — 이번 달에 관리하면 점수가 오를 수 있는 환자입니다.',
      '<b>다음 월 대상자</b> — 미리 준비하면 다음 달 점수가 달라집니다.',
      '대상자에는 있는데 인정에서 빠진 환자는 대개 <b>평가표 항목 미체크</b>입니다.']}] },

 { ico:'✅', nm:'평가 점검 (기록 확인)', sub:'빠진 기록 찾아 평가표 고치기', tags:'점검 assesCheck 오류 확인 평가표 수정 분자제외 배뇨 욕창 유치도뇨관',
   path:'왼쪽 메뉴 <b>적정성-평가 점검</b>', screen:'/main/assesCheck.do',
   use:[{h:'순서', li:[
      'S:<b>연월</b>을 맞추고 점검 <b>구분</b>을 골라 조회합니다.',
      'S:나온 목록에서 <b>어떤 기록이 어긋났는지</b> 확인합니다.',
      'S:해당 환자의 <b>환자평가표·기록</b>을 고칩니다.',
      'S:고친 자료를 <b>다시 올리면</b>(2단계) 점수에 반영됩니다.']},
    {h:'실제로 했는데 점수에 안 들어간 경우가 많습니다', li:[
      '처치·관리는 했는데 <b>평가표 체크나 기록이 빠져</b> 인정에서 제외된 건입니다.',
      '평가표만 보완해도 인정되는 사람이 늘어 점수가 오를 수 있습니다.']},
    {h:'자주 나오는 것', li:[
      '<b>배뇨관리</b> — 배뇨일지는 썼는데 ‘배뇨훈련·방광훈련프로그램’ 항목이 미체크된 경우. 일지가 7일 미만이면 작성 여부를 <b>‘아니오’</b>로 하고 실제 작성일수를 적습니다.',
      '<b>유치도뇨관</b> — 제거했는데 <b>제거일자</b>를 안 넣어 계속 보유로 잡히는 경우.',
      '<b>욕창처치</b> — 영양공급을 했는데 평가표의 <b>‘피부문제 해결을 위한 영양공급’</b> 항목이 미체크된 경우.']}] },

 { ico:'🛒', nm:'적정성 Simulation', sub:'기간을 골라 종합 예상점수 보기', tags:'시뮬레이션 simulation 기간 누적 종합 예상점수 평균',
   path:'왼쪽 메뉴 <b>적정성-Simulation</b>', screen:'/main/simulation.do',
   use:[{h:'순서', li:[
      'S:<b>기간</b>을 고릅니다 — 평가 시작월(7월)부터 <b>12월까지</b>, 또는 <b>보고 싶은 월까지</b>.',
      'S:조회하면 현재 기준 <b>종합 예상점수</b>가 나옵니다.',
      'S:지표별로 다음 점수까지 얼마가 남았는지 확인해 관리 계획을 세웁니다.']},
    {h:'★오해하기 쉬운 부분', li:[
      '적정성평가 점수는 <b>월별 점수의 평균이 아닙니다.</b>',
      '평가 시작월(7월)부터 <b>평가 대상자가 쌓인 비율</b>로 산출됩니다.',
      '그래서 초반이 낮아도 이후 관리로 회복될 수 있고, 후반에 나빠지면 누적 전체가 내려갑니다.']}] },

 { ico:'📄', nm:'월간보고서 보기', sub:'위너넷이 작성한 분석 보고서 확인', tags:'월간보고서 evalReport 총평 권고 열람 인쇄 보고서',
   path:'왼쪽 메뉴 <b>적정성평가 월간보고서</b>', screen:'/main/evalReportList.do',
   use:[{h:'보는 방법', li:[
      '목록에서 <b>평가월</b>을 골라 보고서를 엽니다.',
      '위너넷 담당자가 작성·승인한 <b>총평과 개선 권고</b>가 들어 있습니다.',
      '필요하면 <b>인쇄</b>해서 원내 공유·회의 자료로 쓰실 수 있습니다.']},
    {h:'보고서는 이렇게 읽으세요', li:[
      '<b>예상점수와 등급</b> — 지금 위치',
      '<b>구조영역</b> — 인력(의사·간호사·간호인력·약사) 관련 코멘트',
      '<b>잘 관리되는 지표</b> / <b>올릴 수 있는 지표</b> — 무엇을 하면 몇 점 오르는지',
      '<b>기록 신뢰도</b> — 어떤 기록을 맞춰야 하는지']}],
   note:'항정신성 처방률·DUR 점검률·지역사회복귀율은 예상값이라, 최종 평가 결과에 따라 종합점수가 다소 달라질 수 있습니다.' },

 { ico:'💬', nm:'문의하기', sub:'막히면 여기로', tags:'문의 1:1 자주하는질문 FAQ 상담 전화 답변 원격지원',
   path:'홈페이지 <b>메인화면</b>의 <b>1:1 문의하기</b> · <b>자주하는 질문</b>',
   use:[{h:'순서', li:[
      'S:먼저 <b>자주하는 질문</b>에서 같은 사례가 있는지 봅니다.',
      'S:없으면 <b>1:1 문의하기</b>로 남깁니다.',
      'S:답변은 <b>근무일 기준 2일 이내</b>에 등록됩니다.']},
    {h:'급할 때', li:[
      '전화 <b>02-6953-2452</b> / <b>010-2439-7971</b> (위너넷 컨설팅 사업부)',
      '화면을 함께 봐야 하면 <b>원격지원상담</b>을 이용할 수 있습니다.']}] }
];

/* 흐름과 별개로, 필요할 때 보는 내용 */
var EXTRA = [
 { ico:'📌', nm:'WinCheck+ 는 어떤 프로그램인가', sub:'무엇을 해주는 프로그램인지', tags:'WinCheck 소개 프로그램 안내 2주기 8차 접속링크 기능',
   path:'참고 — 프로그램 소개',
   use:[{h:'프로그램', li:[
      '<b>WinCheck+</b> — 요양병원 적정성평가 <b>예상점수 관리 프로그램</b>입니다.',
      '<b>2026년 2주기 8차</b> 적정성평가 관리를 위해 운영됩니다.',
      'SAM 파일을 올리는 것만으로 <b>실시간 예상점수와 평가 대상자</b>를 확인할 수 있는 웹 시스템입니다.',
      '접속 <b>http://www.winner797.co.kr</b> — 언제 어디서나 이용 가능합니다.']},
    {h:'이용 절차는 세 가지뿐입니다', li:[
      'S:<b>회원가입 및 로그인</b>',
      'S:<b>자료 업로드</b> (SAM 파일 등)',
      'S:<b>예상점수 확인 및 대상자 현황 확인</b>']},
    {h:'해주는 일', li:[
      '월별·연간 적정성평가 예상점수 <b>자동 계산</b>',
      '지표별 <b>평가 대상자</b> 확인',
      '<b>개선 대상자</b>와 <b>다음 월 평가 대상자</b> 확인',
      '평가 대상자 현황과 지표별 관리 지원']}] },

 { ico:'📈', nm:'진료비 분석·통계', sub:'필요할 때 보는 통계 화면', tags:'진료비 분석 통계 건당진료비 약제비율 진료지표',
   path:'왼쪽 메뉴 <b>진료비-분석 현황</b> · <b>분야별통계</b>', screen:'/main/total_Report.do',
   use:[{h:'무엇이 있나', li:[
      '진료실적통계 — 일당·건당진료비, 진료과별·전문의별, 다빈도상병, 유형별',
      '진료대비 약제비율 — 정액환자(비청구분/전체)·행위환자·전체환자',
      '진료지표 · 항목별 건당진료비 구성']},
    {h:'언제 보나', li:['적정성평가와 별개로 병원 진료비 구조를 살펴볼 때 이용합니다.']}] },

 { ico:'📅', nm:'매월 이렇게 하시면 됩니다', sub:'한 달 루틴 요약', tags:'루틴 매월 순서 요약 체크리스트 월별',
   path:'참고 — 월 단위 요약',
   use:[{h:'매월 반복', li:[
      'S:<b>자료 올리기</b> — 청구 SAM · 환자평가표 · 입원환자현황',
      'S:<b>대시보드</b>에서 당월·연간 예상점수 확인',
      'S:<b>적정성평가 현황</b>에서 개선 대상자·다음 월 대상자 확인',
      'S:<b>평가 점검</b>에서 빠진 기록을 찾아 평가표 수정 → 다시 올리기',
      'S:<b>Simulation</b>으로 남은 기간 목표 점검',
      'S:<b>월간보고서</b>로 위너넷 분석 확인']},
    {h:'놓치지 마세요', li:[
      '구조영역은 <b>목표 점수·차등제 신고 결과</b>를 등록해야 점수가 나옵니다.',
      '기록만 보완해도 오르는 점수가 매월 있습니다 — <b>평가 점검</b>을 습관처럼 보세요.']}] }
];

var QUICK = ['로그인','SAM 파일','자료 올리기','구조영역','대상자','평가 점검','배뇨관리','문의'];
var ALL = [];   // STEPS + EXTRA 를 한 배열로(검색·이동 공용). isStep=흐름 단계 여부
STEPS.forEach(function(x,i){ x.isStep=true;  x.no=i+1; ALL.push(x); });
EXTRA.forEach(function(x)  { x.isStep=false;             ALL.push(x); });

var _sel = null;
function wmEsc(s){ return String(s==null?'':s).replace(/[&<>"]/g,function(c){return {'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;'}[c];}); }
function wmQv(){ return (document.getElementById('wmQ').value||'').trim(); }
function wmPlain(m){
  var t=m.nm+' '+(m.sub||'')+' '+(m.tags||'')+' '+(m.path||'');
  (m.use||[]).forEach(function(s){ t+=' '+(s.h||'')+' '+((s.li||[]).join(' ')); });
  return (t+' '+(m.note||'')).replace(/<[^>]+>/g,' ').replace(/^S:/g,' ');
}
function wmHits(){
  var q=wmQv().toLowerCase(), out=[];
  ALL.forEach(function(m,i){ if(!q || wmPlain(m).toLowerCase().indexOf(q)>=0) out.push(i); });
  return out;
}
function wmHome(){ _sel=null; document.getElementById('wmQ').value=''; wmRender(); }
function wmGo(i){ _sel=i; wmRender(); window.scrollTo(0,0); }
function wmSetQ(t){ document.getElementById('wmQ').value=t; _sel=null; wmRender(); }

function wmRender(){
  var q=wmQv(), main=document.getElementById('wmMain'), crumb=document.getElementById('wmCrumb');
  var qk=document.getElementById('wmQuick');
  if(qk && !qk.innerHTML) qk.innerHTML='<b>자주 찾는 말</b>'+QUICK.map(function(t){
      return '<span class="q" onclick="wmSetQ(\''+wmEsc(t)+'\')">'+wmEsc(t)+'</span>'; }).join('');

  var cb='<a onclick="wmHome()">🏠 처음</a>';
  if(q) cb+=' <span class="sep">›</span> <span class="cur">검색 ‘'+wmEsc(q)+'’</span>';
  else if(_sel!=null){
    var m=ALL[_sel];
    cb+=' <span class="sep">›</span> <span class="cur">'+(m.isStep?('단계 '+m.no+'. '):'')+wmEsc(m.nm)+'</span>';
  }
  crumb.innerHTML=cb;

  if(q){
    var hits=wmHits();
    var h='<div class="wm-hit">‘<b>'+wmEsc(q)+'</b>’ 검색 결과 <b>'+hits.length+'</b>건'+(hits.length?' — 누르면 사용법이 나옵니다':'')+'</div>';
    h += hits.length ? wmRowsHtml(hits)
                     : '<div class="wm-empty">찾는 내용이 없습니다.<br>더 짧은 말로 찾아보세요(예: ‘배뇨’, ‘총평’).</div>';
    if(_sel!=null && hits.indexOf(_sel)>=0) h+='<div style="margin-top:12px">'+wmSplit(_sel, q)+'</div>';
    main.innerHTML=h; wmPrevFit(); return;
  }
  if(_sel!=null){ main.innerHTML=wmSplit(_sel, ''); wmPrevFit(); return; }

  // 홈 — 흐름 카드 + 필요할 때 보는 화면
  var hh='<div class="wm-ask">이 순서로 진행합니다</div>'
       + '<div class="wm-askd">카드를 누르면 그 화면 사용법이 나옵니다. 아래 <b>다음 단계</b> 버튼으로 계속 이어집니다.</div>'
       + '<div class="wm-flow">';
  STEPS.forEach(function(s,i){
    // 카드에도 마우스를 대면 그 화면에서 하는 일이 뜬다(첫 묶음의 앞 두 줄 요약)
    var tip=[]; ((s.use&&s.use[0]&&s.use[0].li)||[]).slice(0,3).forEach(function(x){
      tip.push('· '+String(x).replace(/^S:/,'').replace(/<[^>]+>/g,'')); });
    hh+='<div class="wm-fc wm-t" data-tip="'+wmEsc(tip.join('\n')||s.sub)+'" style="animation-delay:'+(i*55)+'ms" onclick="wmGo('+i+')">'
      + '<span class="no">'+(i+1)+'</span><span class="ico">'+s.ico+'</span>'
      + '<span class="nm">'+wmEsc(s.nm)+'</span><span class="sub">'+wmEsc(s.sub)+'</span></div>';
  });
  hh+='</div><div class="wm-ask" style="margin-top:22px">필요할 때 보는 화면</div><div class="wm-askd">흐름과 상관없이 그때그때 들어가는 곳입니다.</div>';
  var ex=[]; ALL.forEach(function(m,i){ if(!m.isStep) ex.push(i); });
  main.innerHTML=hh+wmRowsHtml(ex);
}

function wmRowsHtml(idx){
  var h='<div class="wm-rows">';
  idx.forEach(function(i,k){
    var m=ALL[i];
    h+='<div class="wm-row" style="animation-delay:'+Math.min(k*45,360)+'ms" onclick="wmGo('+i+')">'
     + (m.isStep?('<span class="stp">단계 '+m.no+'</span>'):'<span class="stp" style="background:#f1f5f9;color:#6b7a89">참고</span>')
     + '<span class="tt">'+m.ico+' '+wmEsc(m.nm)+'<small>'+wmEsc(m.sub||'')+'</small></span>'
     + '<span class="arw">›</span></div>';
  });
  return h+'</div>';
}

/* ══ 마우스를 대면 뜻이 뜨는 말 ═══════════════════════════════════════════════════════
     어려운 말에 점선을 깔고 설명 풍선을 붙인다. 새 용어는 여기 한 줄만 추가하면 된다.
     · 본문의 <글자>에만 넣는다(태그·속성은 건드리지 않음) — 태그가 깨지면 화면이 무너지므로.
     · 같은 말이 여러 번 나오면 <처음 한 번만> 표시한다(점선이 도배되면 오히려 읽기 나쁨).      */
var TERMS = {
 '요양기관기호':'심사평가원에서 기관마다 부여한 번호입니다. 로그인할 때 필요합니다.',
 'SAM 파일':'심사평가원 자료를 내려받은 파일입니다. 이 파일을 올리면 점수와 대상자가 자동으로 계산됩니다.',
 '환자평가표':'환자 상태를 항목별로 체크해 제출하는 표입니다. 실제로 했더라도 여기 체크가 빠지면 점수에서 빠집니다.',
 '입원환자현황':'입원·퇴원 명단입니다. 퇴원환자와 다음 달 평가 대상자를 알 수 있습니다.',
 '구조영역':'의사·간호사·간호인력·약사 등 인력으로 매겨지는 점수입니다.',
 '진료영역':'환자 진료 과정과 결과로 매겨지는 점수입니다.',
 '차등제 신고':'인력 현황을 심사평가원에 신고하는 제도입니다. 이 신고 결과로 구조영역 점수가 확정됩니다.',
 '개선 대상자':'이번 달에 관리하면 점수가 오를 수 있는 환자입니다.',
 '다음 월 대상자':'다음 달 평가에 들어올 환자입니다. 미리 준비하면 다음 달 점수가 달라집니다.',
 '결과 대상자':'이번 달 평가 결과에 이미 반영된 환자입니다.',
 '배뇨일지':'배뇨 시간·횟수 등을 적는 기록지입니다.',
 '항정신성의약품 처방률':'항정신성 약을 처방받은 환자 비율입니다. 낮을수록 점수에 유리합니다.',
 'DUR 점검률':'처방할 때 의약품 안전점검을 거친 비율입니다.',
 '지역사회복귀율':'퇴원 후 집이나 시설로 돌아간 환자 비율입니다.',
 '유치도뇨관':'소변을 빼기 위해 몸에 넣어 두는 관(Foley)입니다.',
 '욕창처치':'욕창에 대해 압력분산·체위변경·영양공급·드레싱 등을 실시하는 것입니다.',
 '평가 대상자':'그 지표의 평가에 포함되는 환자입니다.'
};
var _TKEYS = Object.keys(TERMS).sort(function(a,b){ return b.length-a.length; });   // 긴 말 먼저(부분 겹침 방지)
/* ★한 번에(single pass) 바꾼다. 용어를 하나 넣은 뒤 그 결과를 다시 훑으면,
     설명 문구 안에 든 다른 용어까지 감싸서 data-tip 속성이 깨진다
     (예: '입원환자현황' 설명에 '평가 대상자'가 들어 있다 — 실제로 태그가 깨졌다). */
var _TRE = new RegExp('(' + _TKEYS.map(function(k){ return k.replace(/[.*+?^{}$()|[\]\\]/g,'\\$&'); }).join('|') + ')', 'g');
function wmTip(html){
  var used = {};
  return html.replace(/>([^<]+)</g, function(all, txt){
    return '>' + txt.replace(_TRE, function(m){
      if(used[m]) return m;                       // 같은 말은 처음 한 번만
      used[m] = 1;
      return '<span class="wm-t" data-tip="' + wmEsc(TERMS[m]) + '">' + m + '</span>';
    }) + '<';
  });
}
/* ══ 오른쪽 '실제 화면 작게 보기' ═══════════════════════════════════════════════════
     그 단계의 화면을 그대로 띄워 축소한다. 같은 서버·같은 로그인이라 실제 내용이 보인다.
      · 폭에 맞춰 배율을 계산한다(가로 1440px 기준으로 그려 축소) — 배율 고정이면 화면이 잘린다.
      · sandbox 로 <상위 창 이동>을 막는다. 안쪽 화면이 top.location 을 건드려도 매뉴얼이 튕기지 않게.
      · 미리보기가 없는 단계(로그인·문의 등)는 안내만 둔다.                                   */
function wmPrevHtml(m){
  if(!m || !m.screen){
    return '<div class="wm-prev"><div class="hd">🖥 실제 화면</div>'
         + '<div class="none">이 단계는 미리 보여줄 화면이 없습니다.<br>(로그인·문의·참고 내용)</div></div>';
  }
  return '<div class="wm-prev">'
       + '<div class="hd">미리보기<span style="flex:1"></span>'
       + '<a class="go" href="'+m.screen+'" target="_blank">크게 열기 ↗</a></div>'
       + '<div class="bd" id="wmPrevBd">'
       + '<iframe id="wmPrevIf" src="'+m.screen+'" scrolling="no" sandbox="allow-same-origin allow-scripts allow-forms"></iframe>'
       + '</div>'
       + '<div class="tipbar">지금 로그인한 상태로 보이는 실제 화면입니다. 조회 조건에 따라 내용이 비어 있을 수 있습니다.</div></div>';
}
function wmPrevFit(){
  var bd=document.getElementById('wmPrevBd'), f=document.getElementById('wmPrevIf');
  if(!bd || !f) return;
  var W=1440, H=1080;
  var s=Math.max(0.26, Math.min(0.85, (bd.clientWidth||560)/W));   // 좌측을 줄인 만큼 오른쪽이 넓어져 상한을 올림
  f.style.width=W+'px'; f.style.height=H+'px'; f.style.transform='scale('+s+')';
  bd.style.height=Math.round(H*s)+'px';
}
window.addEventListener('resize', wmPrevFit);
// 좌(사용법) + 우(실제 화면) 한 덩이로 감싼다
function wmSplit(i, q){
  var m=ALL[i];
  return '<div class="wm-split">'
       + '<div class="lft"><div class="wm-panehd lf">📖 사용법 <span>— 순서대로 따라 하세요</span></div>'
       +   wmViewHtml(i,q)+'</div>'
       + '<div class="wm-vline"></div>'
       + '<div class="rgt"><div class="wm-panehd rg">🖥 실제 화면 <span>'
       +   (m && m.screen ? '— 지금 이 화면을 작게 줄인 것입니다' : '— 이 단계는 보여줄 화면이 없습니다')+'</span>'
       +   '<span class="gap"></span>'
       +   (m && m.screen ? '<a class="go" href="'+m.screen+'" target="_blank">크게 열기 ↗</a>' : '')
       +   '</div>'
       +   wmPrevHtml(m)+'</div></div>';
}
function wmHl(html, q){
  if(!q) return html;
  return html.replace(/>([^<]+)</g, function(all, txt){
    return '>' + txt.replace(new RegExp('('+q.replace(/[.*+?^{}$()|[\]\\]/g,'\\$&')+')','gi'),'<span class="wm-hl">$1</span>') + '<';
  });
}
function wmViewHtml(i, q){
  var m=ALL[i];
  var h='<div class="wm-view">'
      + '<h3>'+(m.isStep?('단계 '+m.no+'. '):'')+m.ico+' '+wmEsc(m.nm)
      + (m.screen?('<a class="go" href="'+m.screen+'">화면 열기 ↗</a>'):'')+'</h3>'
      + '<div class="meta">'+wmEsc(m.sub||'')+'</div>';
  if(m.path) h+='<div class="wm-path">📍 <b>들어가는 길</b> — '+m.path+'</div>';
  (m.use||[]).forEach(function(s){
    if(!s || !s.h) return;
    h+='<div class="wm-sec"><b>'+wmEsc(s.h)+'</b>';
    var lis=s.li||[], steps=lis.length && String(lis[0]).indexOf('S:')===0;
    if(steps){
      h+='<div class="wm-steps">';
      lis.forEach(function(x){ h+='<div class="wm-stp"><div class="t">'+String(x).replace(/^S:/,'')+'</div></div>'; });
      h+='</div>';
    } else {
      h+='<ul>'; lis.forEach(function(x){ h+='<li>'+String(x).replace(/^S:/,'')+'</li>'; }); h+='</ul>';
    }
    h+='</div>';
  });
  if(m.note) h+='<div class="wm-note">⚠ '+m.note+'</div>';
  // 흐름 이동 — 이전/다음 단계
  h+='<div class="wm-nav">';
  if(m.isStep){
    var pi=m.no-2, ni=m.no;
    h+='<button class="wm-btn sm" '+(pi>=0?('onclick="wmGo('+pi+')"'):'disabled')+'>‹ 이전 단계'+(pi>=0?(' — '+wmEsc(STEPS[pi].nm)):'')+'</button>';
    h+='<button class="wm-btn sm solid" '+(ni<STEPS.length?('onclick="wmGo('+ni+')"'):'disabled')+'>'+(ni<STEPS.length?('다음 단계 — '+wmEsc(STEPS[ni].nm)+' ›'):'마지막 단계입니다')+'</button>';
  }
  h+='<span class="sp"></span><button class="wm-btn sm" onclick="wmHome()">🏠 처음으로</button></div></div>';
  // 뜻풀이 먼저 넣고 그 위에 검색 강조 — 순서를 바꾸면 강조 태그 때문에 용어가 안 잡힌다
  return wmHl(wmTip(h), q);
}
wmRender();
</script>

</c:otherwise>
</c:choose>

  </div>
 </div>
</div>
