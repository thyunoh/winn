<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%--
  적정성평가 Q&A — 자료 찾아보기 (2026-08-04)
    · 지식 TBL_QNA_KB · 카테고리 TBL_QNA_CAT · 질문로그 TBL_QNA_LOG
      서버 /mangr/qnaInit.do · qnaList.do · qnaGet.do · qnaSearch.do
    · 화면 전체를 쓰는 [왼쪽 분류] · [가운데 질문목록] · [오른쪽 답변] 3단.
      ★채팅식이 아니다(2026-08-04 사용자 확정). 자료를 찾아 읽는 화면이다.
    · 종전의 우측하단 플로팅 챗(tiles/main/qnaChat.jsp)은 이 화면으로 대체되어 제거됐다.
    · 메뉴: 사이드바 <적정성평가 Q&A 자료> — 위너넷(s_wnn_yn='Y') 에게만 보인다.
    · 지식을 고치려면 TBL_QNA_KB 를 수정하면 된다(화면 배포 불필요).
--%>
<%-- 빌드 표식 — 화면에 안 보인다(주석). 브라우저에서 Ctrl+U 로 소스를 열어 이 글자를 찾으면
     지금 뜬 화면이 <새 파일인지 옛 화면인지> 바로 안다. 확인이 끝나면 지워도 된다. --%>
<!-- qnacd-build 2026-08-05e : pop mode by window.name -->
<link href="/css/winmc/style_comm.css?v=126" rel="stylesheet">
<script>
  /* 말풍선으로 열렸으면 <그리기 전에> 표시를 붙인다 — 늦게 붙이면 껍데기가 번쩍 보였다 사라진다.
     ★판별은 location.search 로 하면 안 된다 (2026-08-05 실제로 당함) —
       head.jsp 의 <주소 숨김> 스크립트가 본문보다 먼저 돌면서 주소를 /user/dashboard.do 로
       바꿔 버려, 여기서는 ?pop=1 이 이미 지워져 있다. 대신 두 가지를 본다:
       ① window.name — 말풍선이 창 이름을 'wnnQnaDoc' 으로 고정해 연다. 주소 숨김의 영향을 안 받는다.
       ② sessionStorage._realPath — 주소 숨김 스크립트가 지우기 <전의 진짜 주소>를 저장해 둔 값. */
  try{
    var _rp = '';
    try{ _rp = sessionStorage.getItem('_realPath') || ''; }catch(ig){}
    if (window.name === 'wnnQnaDoc' || /[?&]pop=1/.test(location.search) || /[?&]pop=1/.test(_rp))
      document.body.className += ' qna-pop';
  }catch(e){}
</script>
<style>
  /* 화면 높이를 꽉 채운다 — 목록이 길어 스크롤이 화면 안에서 돌아야 한다 */
  /* ★기준 글자크기 — 안쪽 글자는 전부 em 이라 이 값만 바꾸면 화면 전체가 같이 커진다.
       2026-08-04 사용자 요청 "표시화면 조금만 확대" 로 13.5px → 14.6px.
       더 키우거나 줄이는 것은 답변 머리줄의 가－ / 가＋ 로 (아래 QNA_FS 와 같은 값 유지). */
  /* height 는 아래 fitHeight() 가 <실측>으로 다시 잡는다. 여기 값은 그 전까지 쓰는 초기값.
     ★우측 여백 제거는 <이 style 블록에서 !important 로> 해야 한다 (2026-08-05) —
       winn-notebook.css 가 `body .dashboard-content{ padding:… !important }` 를 폭 ≤1500px·높이 ≤900px 에
       걸어 두었다. inline style 은 !important 선언을 <이기지 못한다> — 그래서 컨테이너에 직접 써 넣어도
       팝업(1500×950)에서는 그대로 여백이 남았다(실제로 겪음). 같은 특이성이라도 나중에 선언한 쪽이 이기므로
       화면 자체 style 에 !important 로 적는다.
     ★우측 여백은 <감싸는 컨테이너에서> 없앤다 (2026-08-05 요청 "우측까지 꽉차야 합니다") —
       .dashboard-content 의 padding-right(기본 30px · 노트북 14px · 좁은 화면 10px)가 남아 답변 칸
       오른쪽에 흰 띠가 생겼다. 종전엔 margin-right:-12px 로 그만큼만 파고들었는데(2026-08-04 "우측 0.3cm 확대"),
       화면 폭에 따라 여백 값이 달라져 딱 맞지 않는다. 아래 컨테이너 inline style 에 padding-right:0 을 주고
       여기 음수 마진은 0 으로 되돌렸다 — 어느 폭에서도 오른쪽 끝까지 찬다. */
  /* 이 화면에서만 오른쪽 여백 0 — 위 주석대로 !important 가 필요하다(노트북 CSS 를 이겨야 한다) */
  body .container-fluid.dashboard-content{ padding-right:0 !important; }

  /* ── 팝업(말풍선)으로 열렸을 때 : Q&A 만 꽉 차게 (2026-08-05 요청 "해당 화면만 떠야") ──
       말풍선이 ?pop=1 을 붙여 연다. 그때 body 에 qna-pop 클래스가 붙고(아래 스크립트),
       상단바·좌측메뉴·하단 알림바를 감춰 <이 화면 하나>만 전폭·전高로 쓴다.
       ★tiles 레이아웃(자바·뷰정의)은 건드리지 않았다 — 같은 화면이 메뉴로도(주소 직접) 열릴 수 있어
         화면 쪽에서 모드만 가르는 것이 안전하다. !important 는 테마가 margin-left 를 세게 잡고 있어서다. */
  body.qna-pop .dashboard-header, body.qna-pop #dashboard-header,
  body.qna-pop .nav-left-sidebar,
  body.qna-pop #todayAsqBar{ display:none !important; }   /* 하단 질문등록 알림바 */
  body.qna-pop .dashboard-wrapper, body.qna-pop .dashboard-main-wrapper .main-content{ margin-left:0 !important; }
  body.qna-pop .container-fluid.dashboard-content{ padding:10px 0 8px 12px !important; }
  /* 높이는 !important 를 붙이지 않는다 — 실측(fitHeight)이 inline 으로 다시 잡는데, !important 면 그걸 이겨 버린다 */
  body.qna-pop #qnaWrap{ height:calc(100vh - 60px); }   /* 첫 그림용 초기값 */
  #qnaWrap{ display:flex; gap:12px; height:calc(100vh - 165px); min-height:360px; margin-right:0;
            font-family:"Noto Sans KR","Malgun Gothic","맑은 고딕",sans-serif; color:#28323c; font-size:14.6px; }
  #qnaWrap .qcard{ background:#fff; border:1px solid #e3ebf5; border-radius:12px; display:flex; flex-direction:column;
                   min-height:0; overflow:hidden; box-shadow:0 1px 3px rgba(23,70,162,.05); }
  #qnaWrap .qhd{ flex:0 0 auto; display:flex; align-items:baseline; gap:8px; padding:11px 14px 9px;
                 border-bottom:1px solid #eef3f9; }
  #qnaWrap .qhd .t{ font-size:1.02em; font-weight:800; color:#1746a2; }
  #qnaWrap .qhd .c{ flex:1; min-width:0; font-size:.85em; font-weight:600; color:#a3b2c5;
                    white-space:nowrap; overflow:hidden; text-overflow:ellipsis; }
  #qnaWrap .qhd .fz{ flex:0 0 auto; display:flex; gap:4px; }
  #qnaWrap .qhd .fz button{ min-width:2.2em; padding:2px 6px; border:1px solid #dde7f4; border-radius:6px;
                            background:#f7fafd; color:#5b6c80; font-size:.82em; font-weight:700; cursor:pointer; }
  #qnaWrap .qhd .fz button:hover{ background:#1f6feb; border-color:#1f6feb; color:#fff; }
  #qnaWrap .qbody{ flex:1 1 auto; overflow-y:auto; min-height:0; }
  #qnaWrap .qbody::-webkit-scrollbar{ width:9px; }
  #qnaWrap .qbody::-webkit-scrollbar-thumb{ background:#cbd8e8; border-radius:5px; }

  /* ── 좌: 분류 ──
       ★답변 영역은 대개 남아돌고 목록 쪽이 좁아 제목이 잘렸다 → 좌·중 칼럼을 오른쪽으로
         넓혀 잡는다(2026-08-04 사용자 요청 "우측으로"). 답변은 남는 폭을 받는다. */
  #qnaCatCard{ flex:0 0 305px; }
  #qnaCats .g{ padding:9px 8px 3px 14px; font-size:.82em; font-weight:800; color:#a3b2c5; letter-spacing:.3px; }
  #qnaCats .it{ display:flex; align-items:center; gap:8px; padding:7px 14px; cursor:pointer; border-left:3px solid transparent; }
  #qnaCats .it:hover{ background:#f4f8fd; }
  #qnaCats .it.on{ background:#eef4fe; border-left-color:#1746a2; }
  #qnaCats .it .arw{ flex:0 0 auto; width:.9em; color:#a3b2c5; font-weight:800; font-size:.85em; }
  #qnaCats .it.on .arw{ color:#1746a2; }
  #qnaCats .it .nm{ flex:1; min-width:0; font-weight:700; }
  #qnaCats .it.on .nm{ color:#1746a2; }
  #qnaCats .it .n{ flex:0 0 auto; font-size:.84em; font-weight:700; color:#8ba0bb; }
  #qnaCats .it.doc .nm{ color:#2f6b5f; }
  #qnaCats .it.doc.on{ background:#eefaf6; border-left-color:#0f6b5c; }
  #qnaCats .it.hot .nm{ color:#c2410c; }
  #qnaCats .it.hot.on{ background:#fdf1ea; border-left-color:#c2410c; }
  #qnaCats .sub{ display:block; padding:5px 14px 5px 26px; cursor:pointer; font-size:.92em; color:#5b6c80; }
  #qnaCats .sub:hover{ background:#f4f8fd; color:#1746a2; }
  #qnaCats .sub.on{ background:#f0f4fa; color:#1746a2; font-weight:700; }
  #qnaCats .sub .n{ float:right; font-size:.85em; color:#a3b2c5; }

  /* ── 가운데: 질문 목록 ── */
  #qnaListCard{ flex:0 0 clamp(340px, 27%, 500px); }
  #qnaSearchBox{ padding:9px 12px; border-bottom:1px solid #eef3f9; display:flex; gap:6px; }
  #qnaSearchBox input{ flex:1; height:2.7em; border:1px solid #cfdcec; border-radius:9px; padding:0 12px; font-size:.97em; }
  #qnaSearchBox input:focus{ outline:none; border-color:#1f6feb; box-shadow:0 0 0 3px rgba(31,111,235,.13); }
  #qnaSearchBox button{ flex:0 0 auto; height:2.7em; padding:0 15px; border:none; border-radius:9px;
                        background:#1f6feb; color:#fff; font-weight:800; cursor:pointer; }
  #qnaSearchBox button:hover{ background:#1655c0; }
  #qnaList .qi{ display:flex; gap:9px; padding:9px 13px; cursor:pointer; border-bottom:1px solid #f2f6fb; line-height:1.5; }
  #qnaList .qi:hover{ background:#f4f8fd; }
  #qnaList .qi.on{ background:#eef4fe; }
  #qnaList .qi .no{ flex:0 0 auto; width:1.8em; text-align:center; font-weight:800; color:#b7c4d4; font-size:.9em; }
  #qnaList .qi.on .tx, #qnaList .qi:hover .tx{ color:#1746a2; }
  #qnaList .qi .tx{ flex:1; min-width:0; font-weight:600; }
  #qnaList .qi .hc{ flex:0 0 auto; font-size:.8em; color:#b7c4d4; }
  #qnaList .qi:nth-child(-n+3) .no.rank{ color:#e2564a; }
  #qnaList .empty{ padding:16px 14px; color:#a3b2c5; }

  /* ── 우: 답변 ── */
  #qnaDocCard{ flex:1 1 auto; min-width:0; }
  /* 여백을 넉넉히 — 글이 카드 테두리에 붙어 답답하다는 피드백(2026-08-04 "너무 타이트").
     우측 44px ≈ 1cm 남짓, 줄간격도 한 단계 띄움. */
  #qnaDoc{ padding:20px 44px 32px 28px; line-height:2.0; }
  #qnaDoc .txt{ margin-top:6px; }
  #qnaDoc .cat{ display:inline-block; font-size:.8em; font-weight:700; color:#1746a2; background:#eaf1fd;
                border:1px solid #d3e0f7; border-radius:9px; padding:1px 8px; margin-bottom:8px; }
  #qnaDoc .cat.doc{ color:#0f6b5c; background:#f2fbf8; border-color:#bfe0d8; }
  #qnaDoc h3{ font-size:1.22em; font-weight:800; color:#1746a2; margin:2px 0 16px; line-height:1.45; }
  #qnaDoc ul{ margin:2px 0 0; padding:0; list-style:none; }
  #qnaDoc li{ position:relative; padding-left:13px; margin:5px 0; }
  #qnaDoc li:before{ content:''; position:absolute; left:0; top:.78em; width:4px; height:4px; border-radius:50%; background:#8ba7d4; }
  #qnaDoc b{ color:#1746a2; }
  /* ── 본문 들여쓰기 (2026-08-04 사용자 요청 "들여쓰기 원칙으로") ──
       원문을 통짜(pre-wrap)로 흘리면 ①·1.·가.·1) 같은 조 구조가 안 보인다.
       줄마다 머리기호로 단계를 정해 들여쓰고, <내어쓰기>로 둘째 줄부터는
       기호 안쪽에 맞춰 접히게 한다(법령 조판 방식). */
  #qnaDoc .txt .ln{ text-indent:-1.15em; margin:2px 0; }
  #qnaDoc .txt .lv0{ padding-left:1.15em; }
  #qnaDoc .txt .lv1{ padding-left:2.35em; }
  #qnaDoc .txt .lv2{ padding-left:3.55em; }
  #qnaDoc .txt .lv3{ padding-left:4.75em; }
  #qnaDoc .txt .lv4{ padding-left:5.95em; }
  #qnaDoc .txt .lv5{ padding-left:7.15em; }
  #qnaDoc .txt .gap{ height:.6em; }
  #qnaDoc .pre{ padding:10px 12px; background:#fbfcfe; border:1px solid #e6edf6; border-radius:8px;
                font-family:Consolas,"D2Coding",monospace; font-size:.86em; line-height:1.55;
                white-space:pre; overflow-x:auto; }
  #qnaDoc .src{ margin-top:14px; padding-top:9px; border-top:1px dashed #dfe8f3; font-size:.86em; color:#8494a8; }
  #qnaDoc .go{ display:flex; flex-wrap:wrap; gap:6px; margin-top:9px; }
  #qnaDoc .go a{ font-size:.88em; font-weight:700; color:#0f6b5c; background:#f2fbf8; border:1px solid #bfe0d8;
                 border-radius:8px; padding:3px 11px; text-decoration:none; cursor:pointer; }
  #qnaDoc .go a:hover{ background:#0f6b5c; color:#fff; border-color:#0f6b5c; }
  #qnaDoc .go a .ext{ opacity:.6; font-size:.9em; }   /* ↗ = 새 창(이 화면은 그대로 남는다) */
  #qnaDoc .rel{ display:flex; flex-wrap:wrap; gap:6px; margin-top:9px; }
  #qnaDoc .rel span{ font-size:.88em; font-weight:600; color:#1746a2; background:#fff; border:1px solid #cfdcec;
                     border-radius:12px; padding:3px 11px; cursor:pointer; }
  #qnaDoc .rel span:hover{ background:#1746a2; color:#fff; border-color:#1746a2; }
  #qnaDoc .guide{ color:#8494a8; }

  /* ── 칸 사이 경계 끌기 (2026-08-05 요청) — [분류|목록] · [목록|답변] 폭을 손으로 맞춘다 ──
       손잡이 자체는 <폭 0> 이고 양옆 12px 틈(gap) 한가운데에 선다.
       · margin -6px 두 번 = 손잡이가 끼어들며 늘어난 gap 한 벌(12px)을 되돌린 것 → 칸 간격은 그대로 12px.
       · 실제로 잡히는 자리는 :before 로 넓혀 둔 12px (폭 0 짜리는 못 집는다).
       · :after = 평소에 보이는 흐린 세로선. 있는 줄 알아야 끌어 본다. */
  #qnaWrap .qsplit{ flex:0 0 0; width:0; margin:0 -6px; position:relative; cursor:col-resize; z-index:3; }
  #qnaWrap .qsplit:before{ content:''; position:absolute; top:0; bottom:0; left:-6px; width:12px; }
  #qnaWrap .qsplit:after{ content:''; position:absolute; top:14px; bottom:14px; left:-1.5px; width:3px;
                          border-radius:2px; background:#e3ebf5; transition:background .12s; }
  #qnaWrap .qsplit:hover:after, #qnaWrap .qsplit.on:after{ background:#1f6feb; }

  @media (max-width:1100px){
    #qnaWrap{ flex-wrap:wrap; height:auto; }
    /* !important = 끌어서 저장해 둔 폭(인라인 flex)이 세로로 쌓이는 배치를 깨지 않게 */
    #qnaCatCard, #qnaListCard{ flex:1 1 100% !important; max-height:300px; }
    #qnaDocCard{ flex:1 1 100% !important; min-height:420px; }
    #qnaWrap .qsplit{ display:none; }
  }
</style>

<div class="dashboard-wrapper">
  <%-- padding-right:0 = 3단이 화면 오른쪽 끝까지 차게 (2026-08-05). 이 화면에만 준다 --%>
  <div class="container-fluid dashboard-content" style="padding-bottom:8px; padding-right:0;">
    <div id="qnaWrap">

      <div class="qcard" id="qnaCatCard">
        <div class="qhd"><span class="t">질문 분류</span><span class="c" id="qnaTotCnt"></span></div>
        <div class="qbody" id="qnaCats"></div>
      </div>

      <%-- 칸 폭 조절 손잡이 (2026-08-05 요청) — 끌면 왼쪽 칸의 폭이 바뀌고 답변칸이 나머지를 받는다 --%>
      <div class="qsplit" data-col="cat" title="끌면 좌우 폭이 바뀝니다 · 두 번 누르면 원래 폭"></div>

      <div class="qcard" id="qnaListCard">
        <div id="qnaSearchBox">
          <input type="text" id="qnaQ" placeholder="검색어를 입력하세요… 예) 배뇨일지" autocomplete="off"
                 onkeydown="if(event.keyCode===13){qnaSearch();return false;}">
          <button type="button" onclick="qnaSearch()">검색</button>
        </div>
        <div class="qhd"><span class="t" id="qnaListTt">질문 목록</span><span class="c" id="qnaListCnt"></span></div>
        <div class="qbody" id="qnaList"></div>
      </div>

      <div class="qsplit" data-col="list" title="끌면 좌우 폭이 바뀝니다 · 두 번 누르면 원래 폭"></div>

      <div class="qcard" id="qnaDocCard">
        <div class="qhd">
          <span class="t">답변</span>
          <span class="c">눌러 보신 질문의 내용이 여기에 표시됩니다</span>
          <%-- 글자 크기 — 화면 전체(#qnaWrap)의 기준 크기를 바꾼다. 고른 값은 다음에도 유지된다. --%>
          <span class="fz">
            <button type="button" onclick="qnaFont(-1)" title="글자 작게">가－</button>
            <button type="button" onclick="qnaFont(1)"  title="글자 크게">가＋</button>
            <button type="button" onclick="qnaFont(0)"  title="처음 크기로">↺</button>
          </span>
        </div>
        <div class="qbody"><div id="qnaDoc"></div></div>
      </div>

    </div>
  </div>
</div>

<script>
/* =====================================================================
   적정성평가 Q&A 자료 (관리자 화면)
     · 전역 이름은 모두 qna* 로 통일한다(사이드바·다른 화면 스크립트와 겹치지 않게).
   ===================================================================== */
(function(){
  var API = { init:'/mangr/qnaInit.do', list:'/mangr/qnaList.do', get:'/mangr/qnaGet.do', search:'/mangr/qnaSearch.do' };
  var CATS = [], TOP = [], LIST = [], CUR = { cat:'__HOT__', sub:'', kb:0, fold:false }, MODE = 'cat';

  function post(url, params, ok, fail){
    var body = [];
    for (var k in params) if (params[k] != null && params[k] !== '')
      body.push(encodeURIComponent(k) + '=' + encodeURIComponent(params[k]));
    fetch(url, { method:'POST', credentials:'same-origin',
                 headers:{ 'Content-Type':'application/x-www-form-urlencoded; charset=UTF-8' },
                 body: body.join('&') })
      .then(function(r){ return r.json(); })
      .then(function(j){ ok(j || {}); })
      .catch(function(e){ if (fail) fail(e); });
  }
  function esc(s){ return String(s==null?'':s).replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;'); }
  function el(id){ return document.getElementById(id); }
  function findCat(id){ for(var i=0;i<CATS.length;i++) if(CATS[i].catId===id) return CATS[i]; return null; }

  /* ── 좌: 분류 ── */
  function renderCats(){
    var h = '<div class="g">많이 찾는 것</div>'
          + '<div class="it hot' + (CUR.cat==='__HOT__' ? ' on' : '') + '" onclick="qnaCat(\'__HOT__\')">'
          +   '<span class="nm">🔥 자주하는 질문</span><span class="n">' + TOP.length + '</span></div>', i, j;
    var grp = [['IN','위너넷 확정 답변'], ['PDF','심사평가원 원문']];
    for (j=0;j<grp.length;j++){
      var any = false;
      for (i=0;i<CATS.length;i++){
        var c = CATS[i];
        if (c.srcType !== grp[j][0] || !c.qCnt) continue;
        if (!any){ h += '<div class="g">' + grp[j][1] + '</div>'; any = true; }
        var hasSub = !!(c.subs && c.subs.length);
        var open = (CUR.cat === c.catId && !CUR.fold);
        h += '<div class="it' + (c.srcType==='PDF' ? ' doc' : '') + (CUR.cat===c.catId ? ' on' : '') + '"'
           + ' title="' + esc(c.catDesc || '') + '" onclick="qnaCat(\'' + c.catId + '\')">'
           +   (hasSub ? '<span class="arw">' + (open ? '▾' : '▸') + '</span>' : '<span class="arw"></span>')
           +   '<span class="nm">' + esc(c.catNm) + '</span><span class="n">' + c.qCnt + '</span></div>';
        if (open && hasSub){
          h += '<div class="sub' + (CUR.sub ? '' : ' on') + '" onclick="qnaSub(\'\')">전체</div>';
          for (var k=0;k<c.subs.length;k++){
            var s = c.subs[k];
            if (!s.qCnt) continue;
            h += '<div class="sub' + (CUR.sub===s.catId ? ' on' : '') + '" onclick="qnaSub(\'' + s.catId + '\')">'
               + esc(s.catNm) + '<span class="n">' + s.qCnt + '</span></div>';
          }
        }
      }
    }
    el('qnaCats').innerHTML = h;
  }

  /* ── 가운데: 질문 목록 ── */
  function renderList(){
    var box = el('qnaList'), h = '', i;
    el('qnaListCnt').innerHTML = LIST.length ? LIST.length + '건' : '';
    if (!LIST.length){ box.innerHTML = '<div class="empty">해당하는 질문이 없습니다.</div>'; return; }
    for (i=0;i<LIST.length;i++){
      var x = LIST[i];
      h += '<div class="qi' + (String(CUR.kb)===String(x.kbId) ? ' on' : '') + '" onclick="qnaOpen(' + x.kbId + ')">'
         +   '<span class="no' + (MODE==='hot' ? ' rank' : '') + '">' + (i+1) + '</span>'
         +   '<span class="tx">' + esc(x.shortTitle || x.title) + '</span>'
         /* 「n회」 조회수 표기는 내리기로 확정(2026-08-05 사용자 요청) — 순위 계산(HIT_CNT)은 그대로 쓰고 숫자만 안 보인다 */
         + '</div>';
    }
    box.innerHTML = h;
    box.scrollTop = 0;
  }

  /* 원문 본문 → 단계별 들여쓰기 (법령 조판 원칙)
       줄 첫머리 기호로 단계를 정한다: 제N조·[별표] > ①② > 1. > 가. > 1) > 가)
       기호 없는 줄(이어지는 문장·비고 등)은 직전 단계를 따라간다. */
  function fmtDoc(body){
    var lv = 0, out = [];
    String(body == null ? '' : body).split('\n').forEach(function(raw){
      var t = raw.trim();
      if (!t){ out.push('<div class="gap"></div>'); return; }
      var l;
      /* 조 제목은 "제N조(제목)" 꼴만 — "제3조의4에 따른…" 같은 인용은 이어지는 문장이다 */
      if (/^(제\d+조(의\d+)?\s*\(|\[별표|\[별지|\[출처\]|\[질의\])/.test(t)) l = 0;
      else if (/^[①-⑮]/.test(t)) l = 1;
      else if (/^[○◦□▣]/.test(t)) l = 1;
      else if (/^\d{1,2}\.\s/.test(t)) l = 2;
      else if (/^[가-힣]\.\s/.test(t)) l = 3;
      else if (/^\d{1,2}\)\s/.test(t)) l = 4;
      else if (/^[가-힣]\)\s/.test(t)) l = 5;
      else if (/^[▸※☞]/.test(t)) l = Math.max(lv, 1);
      else if (/^[-·–—]/.test(t)) l = Math.min(lv + 1, 5);
      else l = lv;                                   /* 이어지는 문장은 직전 단계 유지 */
      lv = l;
      out.push('<div class="ln lv' + l + '">' + esc(t) + '</div>');
    });
    return '<div class="txt">' + out.join('') + '</div>';
  }

  /* ── 우: 답변 ── */
  function renderDoc(kb){
    var doc = (kb.srcType !== 'IN');
    var cat = (kb.catNm || '') + (kb.subNm ? ' › ' + kb.subNm : '');
    var h = '<span class="cat' + (doc ? ' doc' : '') + '">' + esc(cat || (doc ? '심평원 원문' : '위너넷')) + '</span>'
          + '<h3>' + esc(kb.title) + '</h3>';
    var body = String(kb.body == null ? '' : kb.body);

    if (kb.kind === 'CARD'){
      var ls = body.split('\n');
      h += '<ul>';
      for (var i=0;i<ls.length;i++) if (ls[i].replace(/\s/g,'')) h += '<li>' + ls[i] + '</li>';
      h += '</ul>';
    } else if (kb.kind === 'RAW'){
      h += '<div class="pre">' + esc(body) + '</div>';
    } else {
      h += fmtDoc(body);
    }
    /* 근거 표기는 <심평원 원문(PDF)에만> 붙인다 (2026-08-05 사용자 요청) —
         위너넷 확정 답변(IN)의 근거는 내부 출처(카톡 정리 등)라 병원에 보일 필요가 없다.
         DB(SRC_NM)는 지우지 않고 화면에서만 가린다 — 출처 기록은 관리용으로 남긴다. */
    if (doc && kb.srcNm) h += '<div class="src"><b>근거</b> · ' + esc(kb.srcNm) + '</div>';

    var go = [];
    try { go = kb.goJson ? JSON.parse(kb.goJson) : []; } catch(ignore){ go = []; }
    if (go && go.length){
      h += '<div class="go">';
      for (var g=0; g<go.length; g++)
        h += '<a title="' + (go[g].s ? '이 화면 위에 창으로 열립니다' : '새 창으로 열립니다 — 이 화면은 그대로 남습니다') + '"'
           + ' onclick="qnaGo(\'' + go[g].u + '\',' + (go[g].s ? 1 : 0) + ')">'
           + esc(go[g].n) + (go[g].s ? '' : ' <span class="ext">↗</span>') + '</a>';
      h += '</div>';
    }
    if (kb.rel && kb.rel.length){
      var rr = '';
      for (var j=0;j<kb.rel.length;j++)
        rr += '<span onclick="qnaOpen(' + kb.rel[j].kbId + ')">' + esc(kb.rel[j].title) + '</span>';
      if (rr) h += '<div class="rel">' + rr + '</div>';
    }
    el('qnaDoc').innerHTML = h;
    el('qnaDoc').parentNode.scrollTop = 0;
  }

  /* 처음 화면 — 짧은 안내만. ★분류 목록은 넣지 않는다(왼쪽 기둥에 이미 있다, 2026-08-04) */
  function renderGuide(){
    var tot = 0, i;
    for (i=0;i<CATS.length;i++) tot += (CATS[i].qCnt || 0);
    el('qnaDoc').innerHTML =
        '<h3>적정성평가 Q&amp;A 자료</h3>'
      + '<ul><li>왼쪽에서 <b>분류</b>를 고르거나, 가운데 검색창에 <b>짧은 낱말</b>로 찾으시면 됩니다. 예) 배뇨일지 · 욕창 처치 · 격리실</li>'
      + '<li>질문을 누르면 이 자리에 답변이 펼쳐집니다.</li></ul>'
      + '<div class="src">모두 <b>' + tot + '건</b> · 위너넷이 확정한 실무 답변과 '
      + '심사평가원 「2022 요양병원 수가 실무교육자료」 원문으로 구성돼 있습니다.</div>';
  }

  /* ── 동작 ── */
  /* 분류 클릭 — 같은 분류를 다시 누르면 <펼친 중분류를 접는다>(2026-08-04 사용자 요청).
     접기만 하고 질문 목록은 그대로 두어, 접었다고 보던 목록이 사라지지 않게 한다. */
  window.qnaCat = function(id){
    if (CUR.cat === id && id !== '__HOT__'){
      var c0 = findCat(id);
      if (c0 && c0.subs && c0.subs.length){ CUR.fold = !CUR.fold; renderCats(); return; }
    }
    CUR.cat = id; CUR.sub = ''; CUR.fold = false; MODE = (id === '__HOT__') ? 'hot' : 'cat';
    renderCats();
    if (id === '__HOT__'){
      el('qnaListTt').innerHTML = '자주하는 질문';
      LIST = TOP; renderList(); return;
    }
    var c = findCat(id);
    el('qnaListTt').innerHTML = c ? esc(c.catNm) : '질문 목록';
    el('qnaList').innerHTML = '<div class="empty">불러오는 중…</div>';
    post(API.list, { catId:id }, function(j){ LIST = j.list || []; renderList(); },
                                 function(){ el('qnaList').innerHTML = '<div class="empty">목록을 불러오지 못했습니다.</div>'; });
  };
  window.qnaSub = function(subId){
    CUR.sub = subId; MODE = 'cat';
    renderCats();
    el('qnaList').innerHTML = '<div class="empty">불러오는 중…</div>';
    post(API.list, { catId:CUR.cat, subId:subId }, function(j){ LIST = j.list || []; renderList(); },
                                                   function(){ el('qnaList').innerHTML = '<div class="empty">목록을 불러오지 못했습니다.</div>'; });
  };
  window.qnaOpen = function(kbId){
    CUR.kb = kbId;
    renderList();
    el('qnaDoc').innerHTML = '<div class="guide">불러오는 중…</div>';
    post(API.get, { kbId:kbId, askType:(MODE==='search' ? 'TYPE' : 'PICK') }, function(j){
      if (!j || !j.found || !j.kb){ el('qnaDoc').innerHTML = '<h3>내용을 찾지 못했습니다</h3>'; return; }
      renderDoc(j.kb);
      for (var i=0;i<TOP.length;i++) if (String(TOP[i].kbId) === String(kbId)) TOP[i].hitCnt = (TOP[i].hitCnt||0) + 1;
    }, function(){ el('qnaDoc').innerHTML = '<h3>내용을 불러오지 못했습니다</h3>'; });
  };
  window.qnaSearch = function(){
    var q = el('qnaQ').value.replace(/^\s+|\s+$/g,'');
    if (!q){ qnaCat(CUR.cat); return; }
    MODE = 'search';
    el('qnaListTt').innerHTML = '검색 · ' + esc(q);
    el('qnaList').innerHTML = '<div class="empty">찾는 중…</div>';
    post(API.search, { q:q, listCnt:30 }, function(j){
      LIST = j.list || [];
      renderList();
      if (LIST.length) qnaOpen(LIST[0].kbId);       /* 검색은 1등을 바로 펼쳐 준다 */
      else el('qnaDoc').innerHTML = '<h3>등록된 내용에서는 답을 찾지 못했습니다</h3>'
           + '<ul><li><b>짧은 낱말</b>로 다시 찾아보세요. 예) "배뇨일지", "욕창 처치", "격리실"</li>'
           + '<li>물어보신 내용은 기록으로 남아 다음 지식 보완에 반영됩니다.</li></ul>';
    }, function(){ el('qnaList').innerHTML = '<div class="empty">검색하지 못했습니다.</div>'; });
  };
  /* 관련화면 열기
       ★이 화면을 떠나지 않는다 (2026-08-04 사용자 요청) —
         종전엔 location.href 로 넘어가 버려서, 안내대로 화면을 열어 보고 나면
         Q&A 로 돌아오려고 메뉴를 다시 찾아야 했다.
         · 적정성평가·오류점검 같은 <업무화면>은 <새 창>으로 띄운다.
         · 1:1 문의·자주하는 질문은 사이드바의 그 버튼과 똑같이 <모달>로 띄운다(같은 창, 이동 없음).
           함수가 없는 경우에만 새 창으로 대체한다. */
  window.qnaGo = function(u, isSupport){
    if (!isSupport){ window.open(u, '_blank'); return; }
    try{
      if (u === 'asq' && typeof window.fnasq_main === 'function'){ window.fnasq_main(); return; }
      if (u === 'faq' && typeof window.loadFaqData === 'function'){ window.loadFaqData(); return; }
    }catch(ignore){}
    window.open((u === 'asq') ? '/mangr/asqcd.do' : '/mangr/faqcd.do', '_blank');
  };

  /* ── 높이 = 화면 바닥까지 실측으로 채운다 ──────────────────
       ★고정 calc(100vh - NNNpx) 로 잡으면 안 된다 — 윈도우 배율·브라우저 줌마다 어긋나
         아래쪽에 빈 띠가 남거나 하단 알림바에 가려진다(마감업로드 그리드에서 겪은 것과 같은 문제).
       실제 시작 위치를 재서 <창 높이 − 시작위치 − 아래여백> 으로 잡는다.
       BOTTOM_RESERVE = 화면 맨 아래 <질문등록 알림바>에 가리지 않을 만큼의 여유. */
  var BOTTOM_RESERVE = 44;
  function fitHeight(){
    var w = el('qnaWrap');
    if (!w) return;
    var r = w.getBoundingClientRect();
    var top = r.top + (window.scrollY || window.pageYOffset || 0);   /* 화면기준이 아니라 문서기준 */
    var h = window.innerHeight - top - BOTTOM_RESERVE;
    w.style.height = Math.max(360, Math.round(h)) + 'px';
  }
  window.addEventListener('resize', fitHeight);
  fitHeight();
  setTimeout(fitHeight, 200);      /* 상단 메뉴·알림바가 늦게 잡히는 경우 대비 */
  setTimeout(fitHeight, 800);

  /* ── 칸 폭 조절 : [분류|목록] · [목록|답변] 경계 끌기 (2026-08-05 요청) ──────────
       · 폭은 <왼쪽 칸>에만 준다(flex-basis). 답변칸은 flex:1 이라 남는 폭을 알아서 받는다.
         두 칸을 같이 건드리면 합이 안 맞아 답변칸이 튄다.
       · 고른 폭은 localStorage 에 남는다(브라우저별) — 다음에 들어와도 그대로.
       · 답변칸이 MIN_DOC 아래로 눌리지 않게 끄는 동안 막고, 창을 줄였을 때도 다시 앉힌다
         (좁은 창에서 저장해 둔 폭을 그대로 쓰면 답변칸이 사라진다).
       · 두 번 누르면(dblclick) 그 칸만 처음 폭으로 되돌린다. */
  var COL_KEY = 'qnaColW', MIN_COL = 180, MIN_DOC = 320, COL_GAP = 24;   /* gap 12px × 2 */
  function colLoad(){ try{ var v = JSON.parse(localStorage.getItem(COL_KEY) || '{}'); return (v && typeof v === 'object') ? v : {}; }catch(ignore){ return {}; } }
  function colSave(o){ try{ localStorage.setItem(COL_KEY, JSON.stringify(o)); }catch(ignore){} }
  function colCard(k){ return el(k === 'cat' ? 'qnaCatCard' : 'qnaListCard'); }
  function colLayout(){
    var wrap = el('qnaWrap'); if (!wrap) return;
    var cat = el('qnaCatCard'), lst = el('qnaListCard'), o = colLoad();
    cat.style.flex = o.cat  ? '0 0 ' + o.cat  + 'px' : '';        /* 저장값 없으면 CSS 기본 폭 */
    lst.style.flex = o.list ? '0 0 ' + o.list + 'px' : '';
    if (window.innerWidth <= 1100) return;                        /* 세로로 쌓이는 폭 — CSS 에 맡긴다 */
    var cw = cat.getBoundingClientRect().width, lw = lst.getBoundingClientRect().width;
    var room = wrap.clientWidth - COL_GAP - MIN_DOC;
    if (cw + lw <= room) return;
    var over = cw + lw - room;                                    /* 넘친 만큼 목록 → 분류 순으로 줄인다 */
    var nl = Math.max(MIN_COL, lw - over); over -= (lw - nl);
    var nc = Math.max(MIN_COL, cw - over);
    lst.style.flex = '0 0 ' + Math.round(nl) + 'px';
    cat.style.flex = '0 0 ' + Math.round(nc) + 'px';
  }
  function colDrag(sp){
    var key = sp.getAttribute('data-col'), t = colCard(key);
    sp.addEventListener('pointerdown', function(e){
      if (window.innerWidth <= 1100) return;
      e.preventDefault();
      var x0 = e.clientX, w0 = t.getBoundingClientRect().width;
      var max = w0 + el('qnaDocCard').getBoundingClientRect().width - MIN_DOC;   /* 답변칸이 버틸 만큼까지 */
      try{ sp.setPointerCapture(e.pointerId); }catch(ignore){}   /* 못 걸어도 끌기는 되게 */
      sp.classList.add('on');
      document.body.style.userSelect = 'none'; document.body.style.cursor = 'col-resize';
      function mv(ev){
        t.style.flex = '0 0 ' + Math.max(MIN_COL, Math.min(Math.round(w0 + ev.clientX - x0), Math.round(max))) + 'px';
      }
      function up(){
        sp.removeEventListener('pointermove', mv);
        sp.removeEventListener('pointerup', up);
        sp.removeEventListener('pointercancel', up);
        sp.classList.remove('on');
        document.body.style.userSelect = ''; document.body.style.cursor = '';
        var o = colLoad(); o[key] = Math.round(t.getBoundingClientRect().width); colSave(o);
      }
      sp.addEventListener('pointermove', mv);
      sp.addEventListener('pointerup', up);
      sp.addEventListener('pointercancel', up);
    });
    sp.addEventListener('dblclick', function(){ var o = colLoad(); delete o[key]; colSave(o); colLayout(); });
  }
  Array.prototype.forEach.call(document.querySelectorAll('#qnaWrap .qsplit'), colDrag);
  colLayout();
  window.addEventListener('resize', colLayout);

  /* ── 글자 크기 (가－ / 가＋ / ↺) ────────────────────────────
       #qnaWrap 의 기준 크기만 바꾼다 — 안쪽은 전부 em 이라 화면 전체가 따라 커진다.
       ★QNA_FS 는 CSS 의 #qnaWrap font-size 와 같은 값이어야 ↺(처음 크기)가 맞는다. */
  var QNA_FS = 14.6, QNA_FS_MIN = 11, QNA_FS_MAX = 22, QNA_KEY = 'qnaFs';
  function applyFont(px){
    px = Math.min(QNA_FS_MAX, Math.max(QNA_FS_MIN, px));
    document.getElementById('qnaWrap').style.fontSize = px.toFixed(1) + 'px';
    return px;
  }
  window.qnaFont = function(d){
    var cur = parseFloat((el('qnaWrap').style.fontSize || '')) || QNA_FS;
    if (d === 0){
      applyFont(QNA_FS);
      try{ localStorage.removeItem(QNA_KEY); }catch(ignore){}
      return;
    }
    var px = applyFont(cur + d * 0.8);
    try{ localStorage.setItem(QNA_KEY, String(px)); }catch(ignore){}
  };
  (function(){
    var v = null;
    try{ v = localStorage.getItem(QNA_KEY); }catch(ignore){}
    if (v) applyFont(parseFloat(v) || QNA_FS);
  })();

  /* ── 최초 적재 ── */
  post(API.init, { topCnt:20 }, function(j){
    var raw = j.cats || [], i, tot = 0;
    TOP = j.top || [];
    CATS = [];
    for (i=0;i<raw.length;i++) if (!raw[i].pCatId){ raw[i].subs = []; CATS.push(raw[i]); }
    for (i=0;i<raw.length;i++){
      if (!raw[i].pCatId) continue;
      var p = findCat(raw[i].pCatId);
      if (p) p.subs.push(raw[i]);
    }
    for (i=0;i<CATS.length;i++) tot += (CATS[i].qCnt || 0);
    el('qnaTotCnt').innerHTML = tot + '건';
    renderCats();
    renderGuide();
    el('qnaListTt').innerHTML = '자주하는 질문';
    LIST = TOP; MODE = 'hot';
    renderList();
  }, function(){
    el('qnaCats').innerHTML = '<div class="empty" style="padding:16px 14px;color:#a3b2c5">'
      + '지식 자료를 불러오지 못했습니다.</div>';
  });
})();
</script>
