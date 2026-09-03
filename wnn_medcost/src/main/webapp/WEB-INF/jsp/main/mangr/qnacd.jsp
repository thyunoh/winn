<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%-- 알림·확인 = 가입신청 승인 화면과 같은 ui-message (사용자 2026-08-26 「가입신청에서 쓰는 메시지로」) --%>
<script src="/asset/js/ui-message.js"></script>
<script src="/asset/js/ui-split.js"></script>
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
<!-- qnacd-build 2026-08-05i : 검색창 실시간 영타→한글 -->
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
                 border-bottom:1px solid #eef3f9; position:relative; }   /* 수정 체크를 오른쪽 끝에 절대배치(2026-08-26) */
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
  /* [✎ 관리자 등록] — 관리자가 이 화면에서 넣은 질문만 모아 본다 (2026-08-26) */
  #qnaCats .it.adm .nm{ color:#5b6c80; }
  #qnaCats .it.adm.on{ background:#f0f3f7; border-left-color:#5b6c80; }
  #qnaCats .sub{ display:block; padding:5px 14px 5px 26px; cursor:pointer; font-size:.92em; color:#5b6c80; }
  #qnaCats .sub:hover{ background:#f4f8fd; color:#1746a2; }
  #qnaCats .sub.on{ background:#f0f4fa; color:#1746a2; font-weight:700; }
  #qnaCats .sub .n{ float:right; font-size:.85em; color:#a3b2c5; }

  /* ── 가운데: 질문 목록 ── */
  #qnaListCard{ flex:0 0 clamp(340px, 27%, 500px); }
  #qnaSearchBox{ padding:9px 12px; border-bottom:1px solid #eef3f9; display:flex; gap:6px; }
  /* 검색창 배경 연한 하늘색 + 클릭(포커스) 시 한글 입력모드(ime-mode 지원 브라우저) — 2026-08-05 요청 */
  #qnaSearchBox input{ flex:1; height:2.7em; border:1px solid #cfdcec; border-radius:9px; padding:0 12px; font-size:.97em;
                       background:#eaf6ff; ime-mode:active; }
  #qnaSearchBox input:focus{ outline:none; border-color:#1f6feb; box-shadow:0 0 0 3px rgba(31,111,235,.13); background:#eaf6ff; }
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
  /* 관리자가 이 화면에서 등록한 질문 표시 (2026-08-26 「관리자등록내용 표시도 되는지」) —
     ★색 체계를 건드리지 않는다: 파랑=위너넷 확정 · 초록=심평원 원문 · 주황=AI 참고답변.
       「누가 넣었나」는 신뢰 등급이 아니라 관리용 꼬리표라 <회색>으로 따로 둔다. */
  #qnaList .qi .adm{ flex:0 0 auto; font-size:.72em; font-weight:700; color:#7d8fa5;
                     background:#f0f3f7; border:1px solid #dde4ec; border-radius:5px; padding:1px 5px; line-height:1.6; }
  /* 줄별 작업 단추 — 편집 도구를 켰을 때만 나온다 (2026-08-26 「수정아이콘 직관적으로」)
     ★종전에는 ✏·🗑·☆ 이모지뿐이었다. 두 가지가 문제였다(실화면 확인) :
       ① ✏ 는 글자꼴(text presentation)로 그려져 <가로줄 －> 처럼 보인다 — 연필로 안 읽힌다.
       ② 🗑 은 <질문을 지운다>로 읽히는데, 실제로는 자주 목록에서 내리는 것뿐이다.
          진짜 삭제는 수정 창 안의 [질문 삭제] 다 — 뜻이 정반대로 전달될 수 있었다.
     ⇒ 무엇을 하는 단추인지 <글자로> 적는다. 아이콘 하나로 줄이려다 뜻이 어긋나는 것보다 낫다. */
  #qnaList .qi .act{ flex:0 0 auto; display:flex; gap:5px; align-items:flex-start; }
  #qnaList .qi .act .ic{ display:inline-block; font-size:13px; line-height:1.6; cursor:pointer;
                         opacity:.8; transition:opacity .12s, transform .12s; }
  #qnaList .qi .act .ic:hover{ opacity:1; transform:scale(1.18); }
  /* [수정]만 <글꼴이 아니라 그림(SVG)> — 사용자가 모양을 지정했다 (2026-08-26).
     ★이모지·기호 글자는 그 PC 글꼴에 그림이 있어야 나온다. 없으면 네모(두부)이거나
       글자꼴로 그려져 가로줄처럼 보인다(✏ 로 실제 겪은 것). SVG 는 글꼴을 안 타서 늘 같은 모양이다.
     색은 currentColor 라 아래 두 줄만 바꾸면 되고, 크기는 em 이라 [가－/가＋] 를 따라 같이 커진다. */
  #qnaList .qi .act .ic.draw{ color:#5b6c80; opacity:1; }
  #qnaList .qi .act .ic.draw:hover{ color:#1f6feb; }
  #qnaList .qi .act .ic svg{ display:block; margin-top:2px; }
  /* 방금 등록·수정·올린 줄을 잠깐 노랗게 (2026-08-26 요청 「등록후 어느위치하였는지 확인필요」) —
     저장하면 목록이 다시 그려질 뿐이라 새 질문이 어디로 갔는지 알 수 없었다. */
  #qnaList .qi.justsaved{ animation:qnaSaved 2.6s ease-out 1; }
  @keyframes qnaSaved{ 0%,60%{ background:#fff3cd; box-shadow:inset 3px 0 0 #e2a400; }
                       100%{ background:transparent; box-shadow:none; } }

  /* ── 우: 답변 ── */
  #qnaDocCard{ flex:1 1 auto; min-width:0; }
  /* 여백을 넉넉히 — 글이 카드 테두리에 붙어 답답하다는 피드백(2026-08-04 "너무 타이트").
     우측 44px ≈ 1cm 남짓, 줄간격도 한 단계 띄움. */
  #qnaDoc{ padding:20px 44px 32px 28px; line-height:2.0; }
  #qnaDoc .txt{ margin-top:6px; }
  #qnaDoc .cat{ display:inline-block; font-size:.8em; font-weight:700; color:#1746a2; background:#eaf1fd;
                border:1px solid #d3e0f7; border-radius:9px; padding:1px 8px; margin-bottom:8px; }
  #qnaDoc .cat.doc{ color:#0f6b5c; background:#f2fbf8; border-color:#bfe0d8; }
  /* 「누가 넣었나」 꼬리표 — 신뢰 등급 색(파랑·초록·주황)과 섞이지 않게 회색 (2026-08-26) */
  #qnaDoc .cat.adm{ color:#5b6c80; background:#f0f3f7; border-color:#d8e0ea; margin-left:5px; }
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

  /* ── AI 참고답변 (2026-08-06) — 등록된 자료에서 못 찾았을 때만 나온다 ──
       ★확정 답변과 <한눈에 구별>돼야 한다. 위너넷 확정 답변은 파랑, 심평원 원문은 초록,
         AI 는 주황이다. 색·배지·꼬리말 셋 다 빼지 말 것 — 병원이 이걸 확정답으로 알고
         청구·평가에 반영하면 실제 손해가 난다. */
  #qnaDoc .cat.ai{ color:#a35a00; background:#fff6ea; border-color:#f0d3ac; }
  #qnaDoc .aitx{ margin-top:4px; white-space:pre-wrap; }
  #qnaDoc .aiwarn{ margin-top:14px; padding:9px 12px; background:#fff8ef; border:1px solid #f0d3ac;
                   border-radius:8px; font-size:.88em; color:#8a5a1a; line-height:1.75; }
  #qnaDoc .aiwarn b{ color:#a35a00; }

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
    <div id="qnaWrap" data-split="가로" data-split-key="qnacd.body">

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
          <%-- id = 저장 직후 <어디에 들어갔는지·검색으로 잡히는지>를 여기에 적는다 (2026-08-26) --%>
          <span class="c" id="qnaDocSub">눌러 보신 질문의 내용이 여기에 표시됩니다</span>
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

<%-- 자주하는 질문 등록·수정 모달 (위너넷 관리자만, 2026-08-26) — 저장은 TBL_QNA_KB(TOP_YN·TOP_NO) --%>
<div id="qtopModal" style="display:none; position:fixed; inset:0; background:rgba(20,30,45,.4); z-index:9990;">
  <%-- 폭 넓게(사용자 2026-08-26 「좌우 넓게」) — 답변 원문이 길어 680px 로는 줄이 잘게 꺾였다 --%>
  <div style="position:absolute; left:50%; top:50%; transform:translate(-50%,-50%); width:960px; max-width:96vw;
              background:#fff; border-radius:12px; padding:22px 24px; box-shadow:0 12px 40px rgba(0,0,0,.25);">
    <h3 id="qtopTt" style="margin:0 0 14px; font-size:19px; color:#1d3557;">자주하는 질문 등록</h3>
    <%-- 글자 크기 15px대로 통일 — 기본 상속이 작아 「글자가 너무 작음」(사용자 2026-08-26) --%>
    <div style="display:flex; gap:10px; margin-bottom:10px; align-items:center;">
      <label style="font-size:15px; color:#556;">분류</label>
      <select id="qtopCat" style="flex:1; padding:8px 10px; border:1px solid #cdd6e0; border-radius:6px; font-size:15px;"></select>
      <%-- 순서는 자동(사용자 2026-08-26) — 신규는 맨 뒤, 수정은 원래 자리 유지. 칸은 숨기고 값만 쓴다 --%>
      <input id="qtopNo" type="number" min="0" style="display:none;">
    </div>
    <input id="qtopTitle" placeholder="질문 제목" style="width:100%; padding:10px 12px; margin-bottom:10px; font-size:15.5px;
           border:1px solid #cdd6e0; border-radius:6px; box-sizing:border-box;">
    <%-- 답변 = 서식 편집기(사용자 2026-08-26 「이런식을 할 수 있게」) — 굵게·색 등을 눈에 보이는 대로 쓰고 HTML 로 저장한다.
         기존 답변의 <b> 가 날글자로 보이던 것도 여기서 실제 굵게로 열린다. --%>
    <div style="border:1px solid #cdd6e0; border-radius:6px; overflow:hidden;">
      <div style="display:flex; gap:4px; padding:6px 8px; background:#f6f8fb; border-bottom:1px solid #e3e9f0; flex-wrap:wrap;">
        <button type="button" onclick="qtopCmd('bold')"      title="굵게"     style="width:34px; height:30px; border:1px solid #d4dce5; background:#fff; border-radius:5px; cursor:pointer; font-weight:800;">B</button>
        <button type="button" onclick="qtopCmd('italic')"    title="기울임"   style="width:34px; height:30px; border:1px solid #d4dce5; background:#fff; border-radius:5px; cursor:pointer; font-style:italic; font-weight:700;">I</button>
        <button type="button" onclick="qtopCmd('underline')" title="밑줄"     style="width:34px; height:30px; border:1px solid #d4dce5; background:#fff; border-radius:5px; cursor:pointer; text-decoration:underline; font-weight:700;">U</button>
        <span style="width:1px; background:#dbe3ec; margin:2px 4px;"></span>
        <button type="button" onclick="qtopCmd('foreColor','#d43a2f')"   title="빨강 글자" style="width:34px; height:30px; border:1px solid #d4dce5; background:#fff; border-radius:5px; cursor:pointer; color:#d43a2f; font-weight:800;">가</button>
        <button type="button" onclick="qtopCmd('foreColor','#1d4ed8')"   title="파랑 글자" style="width:34px; height:30px; border:1px solid #d4dce5; background:#fff; border-radius:5px; cursor:pointer; color:#1d4ed8; font-weight:800;">가</button>
        <button type="button" onclick="qtopCmd('foreColor','#111111')"   title="검정 글자" style="width:34px; height:30px; border:1px solid #d4dce5; background:#fff; border-radius:5px; cursor:pointer; color:#111; font-weight:800;">가</button>
        <button type="button" onclick="qtopCmd('hiliteColor','#fff176')" title="형광펜"   style="width:34px; height:30px; border:1px solid #d4dce5; background:#fff176; border-radius:5px; cursor:pointer; font-weight:800;">가</button>
        <span style="width:1px; background:#dbe3ec; margin:2px 4px;"></span>
        <button type="button" onclick="qtopCmd('fontSize','5')" title="글자 크게"   style="height:30px; padding:0 10px; border:1px solid #d4dce5; background:#fff; border-radius:5px; cursor:pointer; font-weight:700;">가＋</button>
        <button type="button" onclick="qtopCmd('fontSize','3')" title="보통 크기"   style="height:30px; padding:0 10px; border:1px solid #d4dce5; background:#fff; border-radius:5px; cursor:pointer;">가</button>
        <button type="button" onclick="qtopCmd('removeFormat')" title="서식 지우기" style="height:30px; padding:0 10px; border:1px solid #d4dce5; background:#fff; border-radius:5px; cursor:pointer;">지우개</button>
      </div>
      <%-- 세로도 넓게(사용자 2026-08-26) — 화면 높이의 55% (작은 화면에서도 280px 확보) --%>
      <div id="qtopBody" contenteditable="true" style="width:100%; height:55vh; min-height:280px; overflow-y:auto; padding:12px;
           box-sizing:border-box; font-size:15px; line-height:1.7; outline:none; background:#fff;"></div>
    </div>
    <div style="display:flex; margin-top:14px; align-items:center;">
      <%-- 완전 삭제 — 수정으로 열었을 때만 보인다. 분류·검색·자주 목록 어디에서도 내려간다 (2026-08-26) --%>
      <button type="button" id="qtopDelBtn" onclick="qnaKbDelGo()" style="display:none; background:#fff; color:#b23b3b;
              border:1px solid #d7a5a5; border-radius:6px; padding:8px 18px; cursor:pointer; font-size:14px;">질문 삭제</button>
      <span style="flex:1;"></span>
      <button type="button" onclick="qnaTopSaveGo()" style="background:#2563eb; color:#fff; border:0; border-radius:6px;
              padding:8px 22px; cursor:pointer; font-size:14px;">저장</button>
      <button type="button" onclick="qnaTopClose()" style="background:#fff; color:#556; border:1px solid #cdd6e0;
              border-radius:6px; padding:8px 18px; cursor:pointer; font-size:14px; margin-left:6px;">닫기</button>
    </div>
  </div>
</div>

<script>
/* =====================================================================
   적정성평가 Q&A 자료 (관리자 화면)
     · 전역 이름은 모두 qna* 로 통일한다(사이드바·다른 화면 스크립트와 겹치지 않게).
   ===================================================================== */
(function(){
  var API = { init:'/mangr/qnaInit.do', list:'/mangr/qnaList.do', get:'/mangr/qnaGet.do',
              search:'/mangr/qnaSearch.do', ask:'/mangr/qnaAsk.do' };
  var CATS = [], TOP = [], LIST = [], CUR = { cat:'__HOT__', sub:'', kb:0, fold:false }, MODE = 'cat';
  /* 자주하는 질문 편집(2026-08-26) — 위너넷 관리자에게만 보인다. 서버(qnaTopSave.do)도 다시 막는다.
     ★[수정] 체크를 켰을 때만 등록 버튼·줄 아이콘이 나온다(사용자 「수정여부 체크하면 활성화」) —
       평소에는 일반 병원과 같은 깔끔한 목록으로 보고, 고칠 때만 켠다. */
  /* ★★이 화면의 편집 도구는 <Ctrl+Alt+Q 를 눌렀을 때만> 보인다 (2026-08-26 사용자 확정).
       · 관리자라도 처음 들어오면 [수정] 체크가 안 보인다 — 평소에는 병원과 같은 깔끔한 화면으로 본다.
       · Ctrl+Alt+Q 를 누르면 [수정] 체크와 [관리자 등록] 분류가 나타난다.
     ⚠★일반 병원 사용자에게는 <어떤 키를 눌러도> 안 나온다 — 아래 핸들러 첫 줄이 ADMIN 이 아니면 즉시 돌아간다.
       가르는 것은 서버가 내려주는 qnaAdmin 뿐이고, 저장·삭제 엔드포인트도 서버에서 따로 막는다.
     ※사이드바 [신규병원 가입신청]의 Ctrl+Alt+R 과는 <다른 기능>이다 — 그쪽은 관리자에게 상시 노출로 바꿨다. */
  /* ★2026-08-31 「Ctrl+Alt+Q 없이 관리자 보이게」 — _qtopKeyOn 을 처음부터 켠다.
       위너넷 관리자면 [수정] 체크·[관리자 등록] 분류가 바로 보인다(키 리스너는 무해해서 남겨 둔다). */
  var ADMIN = '${qnaAdmin}' === 'Y', _qtopId = null, _qtopEditOn = false, _qtopKeyOn = true;
  document.addEventListener('keydown', function(e){
    if (!ADMIN || _qtopKeyOn) return;                 /* 이미 켜져 있으면 아무 일도 하지 않는다 */
    if (e.ctrlKey && e.altKey && (e.key === 'q' || e.key === 'Q')){
      e.preventDefault();
      _qtopKeyOn = true;
      renderCats();                                   /* [관리자 등록] 분류가 함께 나타난다 */
      if (MODE === 'hot') el('qnaListTt').innerHTML = hotTitle();
      renderList(true);
      if (window._toast) _toast('관리자 편집 도구를 켰습니다 — [수정] 체크를 켜면 줄마다 고칠 수 있습니다', 'info');
    }
  });
  function hotTitle(){
    if (!ADMIN || !_qtopKeyOn) return '자주하는 질문';
    /* 체크·등록 버튼은 제목과 <같은 줄 오른쪽 끝>에(사용자 2026-08-26) — 제목 옆에 두면 줄이 꺾여 내려갔다.
       머리줄(.qhd)을 기준으로 절대배치한다(아래 CSS 의 position:relative). */
    return '자주하는 질문'
      + '<span style="position:absolute; right:14px; top:5px; display:flex; gap:8px; align-items:center;">'
      + (_qtopEditOn
          ? '<button type="button" onclick="qnaTopEdit(0)" style="background:#2563eb; color:#fff; position:relative; top:-3px;'
            + ' border:0; border-radius:6px; padding:3px 12px; font-size:12.5px; cursor:pointer;">＋ 질문 등록</button>'
          : '')
      + '<label style="font-size:12.5px; color:#556; cursor:pointer; font-weight:600; white-space:nowrap;">'
      +   '<input type="checkbox"' + (_qtopEditOn ? ' checked' : '') + ' onchange="qnaTopEditMode(this.checked)"'
      +   ' style="vertical-align:-2px; margin-right:3px; cursor:pointer;">수정</label>'
      + '</span>';
  }
  window.qnaTopEditMode = function(on){
    _qtopEditOn = !!on;
    /* ★제목을 다시 쓰는 것은 자주하는 질문 목록일 때만 — hotTitle() 은 '자주하는 질문' 이라는
         글자를 품고 있어서, 분류·검색 목록에서 부르면 그 목록 이름을 덮어쓴다.
       ★목록은 <어느 모드에서나> 다시 그린다 — 줄 아이콘이 모든 목록에 붙기 때문이다. */
    if (MODE === 'hot') el('qnaListTt').innerHTML = hotTitle();
    renderList(true);                       // 아이콘 표시만 갱신 — 보던 자리를 지킨다
  };

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
  /* 이 화면에서 관리자가 등록한 질문인가 (2026-08-26 「관리자등록내용 표시도 되는지」)
       판별 두 가지를 OR 로 본다 — 서버는 안 고쳤고 목록·검색·상세가 모두 이 두 칸을 이미 내려준다.
         · SRC_TYPE='WNN'   ← insertQnaTop 이 박는 값 (IN=위너넷 확정지식 / PDF=심평원 원문)
         · KB_CODE 'WNNFAQ-' ← 같은 곳에서 만드는 코드 접두
       둘 중 하나만 봐도 되지만, 나중에 한쪽 규칙이 바뀌어도 표시가 조용히 사라지지 않게 둘 다 본다. */
  function isAdminKb(x){
    return !!x && (x.srcType === 'WNN' || /^WNNFAQ-/.test(String(x.kbCode == null ? '' : x.kbCode)));
  }
  var _admCnt = -1;   /* [✎ 관리자 등록] 옆 건수 — 한 번 모아 본 뒤에만 안다(-1 = 아직 모름) */
  /* [수정] 아이콘 그림 — 사용자가 지정한 모양(겹친 두 사각형), 2026-08-26.
     선만 있는 그림이라 stroke 를 currentColor 로 두면 CSS 색을 그대로 따라간다. */
  var ICO_EDIT = '<svg viewBox="0 0 24 24" width="1.05em" height="1.05em" fill="none" stroke="currentColor"'
               + ' stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">'
               + '<rect x="9" y="9" width="11" height="11" rx="2"></rect>'
               + '<path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"></path></svg>';
  /* [빼기] 아이콘 — 휴지통도 같은 선 굵기의 그림으로 (2026-08-26 사용자 「선 그림으로 맞추기」).
     이모지 🗑 는 PC 글꼴에 기대지만 이건 어디서나 같은 모양·같은 크기로 나온다. */
  var ICO_DEL  = '<svg viewBox="0 0 24 24" width="1.05em" height="1.05em" fill="none" stroke="currentColor"'
               + ' stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">'
               + '<path d="M3 6h18"></path>'
               + '<path d="M8 6V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path>'
               + '<path d="M19 6l-1 14a2 2 0 0 1-2 2H8a2 2 0 0 1-2-2L5 6"></path>'
               + '<path d="M10 11v6"></path><path d="M14 11v6"></path></svg>';
  function el(id){ return document.getElementById(id); }
  function findCat(id){ for(var i=0;i<CATS.length;i++) if(CATS[i].catId===id) return CATS[i]; return null; }

  /* ── 좌: 분류 ── */
  function renderCats(){
    var h = '<div class="g">많이 찾는 것</div>'
          + '<div class="it hot' + (CUR.cat==='__HOT__' ? ' on' : '') + '" onclick="qnaCat(\'__HOT__\')">'
          +   '<span class="nm">🔥 자주하는 질문</span><span class="n">' + TOP.length + '</span></div>'
          /* 관리자가 넣은 질문만 모아 보기 — 편집 도구(Ctrl+Alt+Q)를 켰을 때만 나온다.
             ★자료가 지금까지는 스크립트로 적재됐고 앞으로는 이 화면에서 손으로 쌓인다(2026-08-26).
               그러면 「내가 넣은 것이 어디까지인가」를 볼 자리가 반드시 필요해진다. */
          + (ADMIN && _qtopKeyOn
              ? '<div class="it adm' + (CUR.cat==='__ADM__' ? ' on' : '') + '" onclick="qnaCat(\'__ADM__\')"'
                + ' title="이 화면에서 등록·수정한 질문만 최근 순으로 모아 봅니다">'
                + '<span class="arw"></span><span class="nm">📝 관리자 등록</span>'
                + '<span class="n">' + (_admCnt < 0 ? '' : _admCnt) + '</span></div>'
              : ''), i, j;
    /* IN(사내 확정답변) 분류는 별도 그룹 제목 없이 "많이 찾는 것" 아래로 통합(2026-08-05 사용자 요청) */
    var grp = [['IN',''], ['PDF','심사평가원 원문']];
    for (j=0;j<grp.length;j++){
      var any = false;
      for (i=0;i<CATS.length;i++){
        var c = CATS[i];
        if (c.srcType !== grp[j][0] || !c.qCnt) continue;
        if (!any){ if (grp[j][1]) h += '<div class="g">' + grp[j][1] + '</div>'; any = true; }
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

  /* ── 가운데: 질문 목록 ──
       keepScroll=true 면 스크롤 위치를 그대로 둔다.
       ★질문을 고를 때도 목록을 다시 그리는데(선택 표시 갱신), 그때마다 맨 위로 튀어
         "아래쪽 질문을 누르면 목록이 위로 올라가는" 현상이 있었다(2026-08-10 지적).
         맨 위로 가야 하는 건 <목록 자체가 바뀔 때>(분류 변경·검색)뿐이다. */
  function renderList(keepScroll){
    var box = el('qnaList'), h = '', i;
    var keep = keepScroll ? box.scrollTop : 0;
    el('qnaListCnt').innerHTML = LIST.length ? LIST.length + '건' : '';
    if (!LIST.length){ box.innerHTML = '<div class="empty">해당하는 질문이 없습니다.</div>'; return; }
    for (i=0;i<LIST.length;i++){
      var x = LIST[i];
      h += '<div class="qi' + (String(CUR.kb)===String(x.kbId) ? ' on' : '') + '" onclick="qnaOpen(' + x.kbId + ')">'
         +   '<span class="no' + (MODE==='hot' ? ' rank' : '') + '">' + (i+1) + '</span>'
         +   '<span class="tx">' + esc(x.shortTitle || x.title) + '</span>'
         /* 관리자가 넣은 줄에 꼬리표 — 편집 도구를 켰을 때만. 병원 사용자 화면은 그대로다.
            ★[관리자 등록] 모아 보기에서는 안 붙인다 — 거긴 전부 관리자 등록분이라 뻔하다. */
         + (ADMIN && _qtopKeyOn && MODE !== 'adm' && isAdminKb(x)
             ? '<span class="adm" title="이 화면에서 관리자가 등록한 질문입니다">관리자</span>' : '')
         /* 「n회」 조회수 표기는 내리기로 확정(2026-08-05 사용자 요청) */
         /* 줄별 작업 아이콘 — 줄 클릭(답변 열기)과 섞이지 않게 전파를 끊는다.
            ★★어느 목록에서나 [수정]·[빼기] <같은 그림·같은 동작> 이다 (2026-08-26 사용자
              「동일한 기능으로, 별표 기능 없애고」). 종전에 분류·검색 목록에만 있던
              ⭐[자주 등록](목록에 올리는 반대 동작)은 없앴다 — 같은 자리에서 어떤 목록이냐에 따라
              올리기와 내리기가 뒤바뀌면 손이 기억한 자리를 못 믿게 된다.
            ★[빼기]는 <모든 줄에> 나온다 (2026-08-26 사용자 「그런 구분 없이 두 개 아이콘 나오게」) —
              한때 <자주하는 질문에 올라 있는 줄에만> 보이게 했더니, 줄마다 아이콘 수가 달라
              「왜 어떤 것은 수정만 있나」로 읽혔다. 줄이 가지런한 쪽을 택한다.
              자주 목록에 없는 줄에서 눌러도 <아무것도 망가지지 않는다> — 이미 내려가 있는 것을
              한 번 더 내리는 셈이라 그대로다(TOP_YN='N' → 'N').
            ⚠[빼기]의 뜻은 <삭제가 아니라 자주 목록에서 내리기>다. 진짜 삭제는 수정 창 안 [질문 삭제] 뿐이다.
            ★★심사평가원 원문(SRC_TYPE='PDF')에는 아무 아이콘도 안 붙인다 (2026-08-26 사용자 요청) —
              그건 우리가 쓴 글이 아니라 <받아 적은 원문>이라 고칠 대상이 아니다. [수정] 체크를 켜도 마찬가지.
              위너넷 확정지식(IN)과 관리자 등록분(WNN)만 손댈 수 있다. */
         + (ADMIN && _qtopEditOn && x.srcType !== 'PDF'
             ? '<span class="act">'
               + '<span class="ic draw" onclick="event.stopPropagation();qnaTopEdit(' + x.kbId + ')"'
                 + ' title="이 질문의 제목·답변 내용을 고칩니다">' + ICO_EDIT + '</span>'
               + '<span class="ic draw" onclick="event.stopPropagation();qnaTopDelGo(' + x.kbId + ')"'
                 + ' title="자주하는 질문 목록에서 뺍니다 — 질문·답변은 분류와 검색에 그대로 남습니다">'
                 + ICO_DEL + '</span>'
               + '</span>'
             : '')
         + '</div>';
    }
    box.innerHTML = h;
    box.scrollTop = keep;
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
    /* ★초록(원문)은 심평원 PDF 에만 준다 (2026-08-26 수정) —
         종전 `srcType !== 'IN'` 은 관리자가 이 화면에서 등록한 글(SRC_TYPE='WNN')까지
         <심평원 원문>으로 칠했다. 위너넷이 쓴 답을 원문으로 보이게 하면 안 된다. */
    var doc = (kb.srcType !== 'IN' && kb.srcType !== 'WNN');
    var cat = (kb.catNm || '') + (kb.subNm ? ' › ' + kb.subNm : '');
    var h = '<span class="cat' + (doc ? ' doc' : '') + '">' + esc(cat || (doc ? '심평원 원문' : '위너넷')) + '</span>'
          /* 누가 넣었는지는 관리자에게만 — 병원 사용자에게는 뜻 없는 정보다 */
          + (ADMIN && isAdminKb(kb) ? '<span class="cat adm">📝 관리자 등록</span>' : '')
          + '<h3>' + esc(kb.title) + '</h3>';
    var body = String(kb.body == null ? '' : kb.body);

    if (kb.kind === 'HTML'){
      /* 관리자 편집기(자주하는 질문)가 서식 그대로 저장한 답변 — 그대로 보여 준다 (2026-08-26) */
      h += '<div style="line-height:1.8;">' + body + '</div>';
    } else if (kb.kind === 'CARD'){
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
    /* 검색으로 들어온 답변에는 <빠져나갈 길>을 준다 (2026-08-06) —
         낱말이 걸려 그럴듯한 항목이 1등으로 잡혔지만 실제로는 딴 얘기인 경우가 있다.
         그때 사용자가 직접 AI 참고답변으로 넘어갈 수 있어야 한다. */
    if (MODE === 'search' && el('qnaQ').value.replace(/^\s+|\s+$/g,''))
      h += '<div class="go" style="margin-top:12px">'
         + '<a onclick="qnaAskCur()">찾는 답이 아닌가요? AI에게 물어보기</a></div>';
    el('qnaDoc').innerHTML = h;
    el('qnaDoc').parentNode.scrollTop = 0;
  }

  /* 처음 화면 — 짧은 안내만. ★분류 목록은 넣지 않는다(왼쪽 기둥에 이미 있다, 2026-08-04) */
  function renderGuide(){
    var tot = 0, i;
    for (i=0;i<CATS.length;i++) tot += (CATS[i].qCnt || 0);
    el('qnaDoc').innerHTML =
        '<h3>WinCheck 실무 Q&amp;A 자료</h3>'   /* 명칭 2026-08-10 변경 — 적정성평가로 한정되지 않는다 */
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
    CUR.cat = id; CUR.sub = ''; CUR.fold = false;
    MODE = (id === '__HOT__') ? 'hot' : (id === '__ADM__' ? 'adm' : 'cat');
    renderCats();
    if (id === '__HOT__'){
      el('qnaListTt').innerHTML = hotTitle();
      LIST = TOP; renderList(); return;
    }
    if (id === '__ADM__'){ qnaAdmList(); return; }
    var c = findCat(id);
    el('qnaListTt').innerHTML = c ? esc(c.catNm) : '질문 목록';
    el('qnaList').innerHTML = '<div class="empty">불러오는 중…</div>';
    post(API.list, { catId:id }, function(j){ LIST = j.list || []; renderList(); },
                                 function(){ el('qnaList').innerHTML = '<div class="empty">목록을 불러오지 못했습니다.</div>'; });
  };
  /* ── [✎ 관리자 등록] 모아 보기 (2026-08-26) ──────────────────────────
       관리자가 이 화면에서 넣은 질문만 <최근 등록 순>으로 모은다.
       ★서버는 안 고쳤다 — 대분류(12개)별 목록을 <한꺼번에 띄워> 받아 화면에서 거른다.
         목록 조회는 본문을 빼고 제목만 오므로(selectQnaKbList) 가볍다.
       ⚠등록분이 많아져 이 방식이 무거워지면 <서버 조회 한 방>으로 바꿀 것 —
         Mangr_SQL.xml 의 selectQnaKbList 에 `AND K.SRC_TYPE='WNN'` 갈래를 더하면 된다(WAR 재빌드).
       ★중분류(SUB_ID)로는 안 걸린다 — 등록 SQL 이 SUB_ID 를 안 채우기 때문에
         대분류 CAT_ID 로만 훑어야 빠지는 것이 없다. */
  function qnaAdmList(){
    el('qnaListTt').innerHTML = '📝 관리자 등록';
    el('qnaList').innerHTML = '<div class="empty">관리자가 등록한 질문을 모으는 중…</div>';
    var got = [], left = CATS.length, i;
    if (!left){ LIST = []; _admCnt = 0; renderList(); return; }
    function done(){
      /* KB_ID 는 IDENTITY 라 큰 쪽이 나중에 넣은 것 — 방금 등록한 것이 맨 위로 온다 */
      got.sort(function(a,b){ return Number(b.kbId) - Number(a.kbId); });
      LIST = got; _admCnt = got.length;
      renderCats();                       /* 분류 항목 옆 건수 갱신 */
      renderList();
      if (!got.length)
        el('qnaList').innerHTML = '<div class="empty">이 화면에서 등록한 질문이 아직 없습니다.</div>';
    }
    for (i=0;i<CATS.length;i++){
      (function(c){
        post(API.list, { catId:c.catId }, function(j){
          var l = j.list || [], n;
          for (n=0;n<l.length;n++) if (isAdminKb(l[n])){ l[n].catId = c.catId; l[n].catNm = c.catNm; got.push(l[n]); }
          if (--left === 0) done();
        }, function(){ if (--left === 0) done(); });
      })(CATS[i]);
    }
  }
  window.qnaSub = function(subId){
    CUR.sub = subId; MODE = 'cat';
    renderCats();
    el('qnaList').innerHTML = '<div class="empty">불러오는 중…</div>';
    post(API.list, { catId:CUR.cat, subId:subId }, function(j){ LIST = j.list || []; renderList(); },
                                                   function(){ el('qnaList').innerHTML = '<div class="empty">목록을 불러오지 못했습니다.</div>'; });
  };
  window.qnaOpen = function(kbId){
    CUR.kb = kbId;
    /* 다른 질문을 열면 「방금 등록…」 안내는 지운다 — 저장 확인 문구가 계속 남아 있으면 안 된다 */
    el('qnaDocSub').innerHTML = '눌러 보신 질문의 내용이 여기에 표시됩니다';
    renderList(true);   // 선택 표시만 갱신 — 보고 있던 자리를 지킨다
    el('qnaDoc').innerHTML = '<div class="guide">불러오는 중…</div>';
    post(API.get, { kbId:kbId, askType:(MODE==='search' ? 'TYPE' : 'PICK') }, function(j){
      if (!j || !j.found || !j.kb){ el('qnaDoc').innerHTML = '<h3>내용을 찾지 못했습니다</h3>'; return; }
      renderDoc(j.kb);
      for (var i=0;i<TOP.length;i++) if (String(TOP[i].kbId) === String(kbId)) TOP[i].hitCnt = (TOP[i].hitCnt||0) + 1;
    }, function(){ el('qnaDoc').innerHTML = '<h3>내용을 불러오지 못했습니다</h3>'; });
  };
  /* ── 영타 → 한글(두벌식) 자동 변환 (2026-08-05 요청 "클릭하면 한글로 변환") ──
       크롬은 보안상 웹페이지가 한/영 키 상태를 바꿀 수 없다(ime-mode 미지원, 실제 확인).
       대신 <영문 그대로 검색해서 결과가 없으면> 두벌식 자판 기준으로 한글로 바꿔 다시 찾는다.
       예) qosy → 배뇨 · dyrckd → 욕창.  DUR·ADL 같은 진짜 영문 검색은 1차에서 잡히므로 그대로 둔다. */
  var E2K={q:'ㅂ',Q:'ㅃ',w:'ㅈ',W:'ㅉ',e:'ㄷ',E:'ㄸ',r:'ㄱ',R:'ㄲ',t:'ㅅ',T:'ㅆ',a:'ㅁ',s:'ㄴ',d:'ㅇ',f:'ㄹ',g:'ㅎ',z:'ㅋ',x:'ㅌ',c:'ㅊ',v:'ㅍ',
           k:'ㅏ',o:'ㅐ',i:'ㅑ',O:'ㅒ',j:'ㅓ',p:'ㅔ',u:'ㅕ',P:'ㅖ',h:'ㅗ',y:'ㅛ',n:'ㅜ',b:'ㅠ',m:'ㅡ',l:'ㅣ'};
  var CHO='ㄱㄲㄴㄷㄸㄹㅁㅂㅃㅅㅆㅇㅈㅉㅊㅋㅌㅍㅎ',
      JUNG='ㅏㅐㅑㅒㅓㅔㅕㅖㅗㅘㅙㅚㅛㅜㅝㅞㅟㅠㅡㅢㅣ',
      JONG=' ㄱㄲㄳㄴㄵㄶㄷㄹㄺㄻㄼㄽㄾㄿㅀㅁㅂㅄㅅㅆㅇㅈㅊㅋㅌㅍㅎ';
  var VMIX={'ㅗㅏ':'ㅘ','ㅗㅐ':'ㅙ','ㅗㅣ':'ㅚ','ㅜㅓ':'ㅝ','ㅜㅔ':'ㅞ','ㅜㅣ':'ㅟ','ㅡㅣ':'ㅢ'};
  var JMIX={'ㄱㅅ':'ㄳ','ㄴㅈ':'ㄵ','ㄴㅎ':'ㄶ','ㄹㄱ':'ㄺ','ㄹㅁ':'ㄻ','ㄹㅂ':'ㄼ','ㄹㅅ':'ㄽ','ㄹㅌ':'ㄾ','ㄹㅍ':'ㄿ','ㄹㅎ':'ㅀ','ㅂㅅ':'ㅄ'};
  var JSPLIT={'ㄳ':'ㄱㅅ','ㄵ':'ㄴㅈ','ㄶ':'ㄴㅎ','ㄺ':'ㄹㄱ','ㄻ':'ㄹㅁ','ㄼ':'ㄹㅂ','ㄽ':'ㄹㅅ','ㄾ':'ㄹㅌ','ㄿ':'ㄹㅍ','ㅀ':'ㄹㅎ','ㅄ':'ㅂㅅ'};
  function engToKor(s){
    var out='', cho=-1, jung=-1, jong=0, i, ch, ja;
    function flush(){
      if (cho>=0 && jung>=0) out += String.fromCharCode(0xAC00 + (cho*21+jung)*28 + jong);
      else if (cho>=0) out += CHO.charAt(cho);
      else if (jung>=0) out += JUNG.charAt(jung);
      cho=-1; jung=-1; jong=0;
    }
    for (i=0;i<s.length;i++){
      ch = s.charAt(i); ja = E2K[ch] || E2K[ch.toLowerCase()];
      if (!ja){ flush(); out += ch; continue; }
      var ci = CHO.indexOf(ja), vi = JUNG.indexOf(ja);
      if (ci >= 0){                                       /* 자음 */
        if (cho >= 0 && jung >= 0){                       /* 받침 자리 */
          if (jong === 0){
            var gi = JONG.indexOf(ja);
            if (gi > 0) jong = gi; else { flush(); cho = ci; }   /* ㄸㅃㅉ 는 받침 불가 */
          } else {
            var mix = JMIX[JONG.charAt(jong) + ja];
            if (mix) jong = JONG.indexOf(mix); else { flush(); cho = ci; }
          }
        } else { flush(); cho = ci; }                     /* 새 초성 */
      } else {                                            /* 모음 */
        if (cho >= 0 && jung >= 0 && jong > 0){           /* 받침을 다음 글자 초성으로 넘긴다 */
          var jc = JONG.charAt(jong), sp = JSPLIT[jc], mv;
          if (sp){ jong = JONG.indexOf(sp.charAt(0)); mv = sp.charAt(1); }
          else { jong = 0; mv = jc; }
          flush(); cho = CHO.indexOf(mv); jung = vi;
        } else if (jung >= 0 && jong === 0){              /* 복모음 시도 */
          var vm = VMIX[JUNG.charAt(jung) + ja];
          if (vm) jung = JUNG.indexOf(vm); else { flush(); jung = vi; }
        } else jung = vi;                                 /* 초성 뒤 or 첫 모음 */
      }
    }
    flush();
    return out;
  }
  /* ★<입력칸을 고쳐 쓰지 않는다> (2026-08-06 사용자 확정) —
       종전에는 치는 즉시 영타를 한글로 바꿔 칸에 써 넣었다(qnaTypeKo). 두 가지가 문제였다.
         · 사용자가 친 글자를 화면에서 몰래 바꾸는 셈이라 보안·신뢰상 좋지 않다.
         · 그 때문에 되돌림(한글→영타) 재검색이 필요했고, 그게 <한글로 제대로 친 질문>까지
           뒤집어 버렸다 — "오늘날씨" 가 'dhsmf skfTlsms' 로 검색된 사고.
       이제 칸은 친 그대로 두고, <검색할 때만> 영타를 한글로 바꿔 한 번 더 찾는다.
       그래서 한/영 상태를 안 바꾸고 영어로 쳐도 한글 자료가 나온다(qosy → 배뇨).
       ★한글→영타 역변환(korToEng)은 필요 없어져 제거했다. 되살리지 말 것. */

  /* _q    = 이번에 실제로 찾을 말(비우면 입력칸 그대로)
     _orig = 사용자가 처음 친 질문. AI 에는 반드시 이걸 넘긴다 —
             자판을 바꿔 찾은 말을 넘기면 AI 가 알아볼 수 없는 글자를 받는다. */
  window.qnaSearch = function(_q, _retry, _orig){
    var typed = el('qnaQ').value.replace(/^\s+|\s+$/g,'');
    var q = _q || typed;
    if (!q){ qnaCat(CUR.cat); return; }
    var qAI = _orig || typed || q;
    MODE = 'search';
    el('qnaListTt').innerHTML = '검색 · ' + esc(q)
      + (q === typed ? '' : ' <span style="font-weight:400;color:#8494a8">(' + esc(typed) + ' 로 입력)</span>');
    el('qnaList').innerHTML = '<div class="empty">찾는 중…</div>';
    post(API.search, { q:q, listCnt:30 }, function(j){
      LIST = j.list || [];
      /* 영어로 친 것을 두벌식 한글로 바꿔 한 번 더 (재시도 1회 한정 — _retry 로 무한 반복 차단).
           · 먼저 <친 그대로> 찾는다 — DUR·ADL 처럼 자료에 진짜 영문으로 적힌 말이 있기 때문.
           · 그래도 없으면 자판을 바꿔 본다 (qosy → 배뇨).
           ★입력칸은 건드리지 않는다. 무엇으로 찾았는지는 목록 제목에 보여 준다. */
      if (!LIST.length && !_retry && /^[A-Za-z0-9 ]+$/.test(q)){
        var alt = engToKor(q);
        if (alt && alt !== q){ window.qnaSearch(alt, 1, qAI); return; }
      }
      renderList();
      /* ★1등을 펼칠지, AI 로 넘길지는 <서버의 weak 판정>을 따른다 (2026-08-06).
           "0건이면 AI" 로는 AI 가 영영 안 뜬다 — ngram 이 '오래'·'점수' 같은 조각에도 걸려
           엉뚱한 항목이 수십 건 잡히기 때문(실제로 겪은 것: "소변줄 오래 꽂으면 점수 깎이나요"
           → 30건, 1등이 '업로드가 너무 오래 걸립니다'). 목록은 그대로 두어 사용자가 직접 고를 수도 있게 한다. */
      if (LIST.length && !j.weak) qnaOpen(LIST[0].kbId);
      else qnaAskAI(qAI);
    }, function(){ el('qnaList').innerHTML = '<div class="empty">검색하지 못했습니다.</div>'; });
  };

  /* ── 등록된 자료에서 못 찾았을 때 : AI 참고답변 (2026-08-06) ──────────────
       sejong_app 혈당 Q&A 와 같은 방식 — <KB 검색 0건일 때만> 서버가 LLM 을 부른다.
       · 서버가 가까운 지식 몇 건을 근거로 넣어 주고, 자료 밖 창작은 막아 둔다.
       · 키 미설정·호출 실패·타임아웃이면 <조용히> 종전 안내문구로 돌아간다 — 오류창 금지.
       · 같은 질문은 다시 안 부른다(캐시). 무료 등급 호출수·응답시간 아끼기. */
  var ASKED = {};
  function askGuideHtml(){
    return '<h3>등록된 내용에서는 답을 찾지 못했습니다</h3>'
         + '<ul><li><b>짧은 낱말</b>로 다시 찾아보세요. 예) "배뇨일지", "욕창 처치", "격리실"</li>'
         + '<li>물어보신 내용은 기록으로 남아 다음 지식 보완에 반영됩니다.</li></ul>';
  }
  function renderAI(q, r){
    var h = '<span class="cat ai">AI 참고답변</span>'
          + '<h3>' + esc(q) + '</h3>'
          + '<div class="aitx">' + esc(r.answer) + '</div>';
    if (r.refs && r.refs.length){                    /* 근거로 삼은 자료 — 눌러서 원문 확인 */
      var rr = '';
      for (var i=0;i<r.refs.length;i++)
        rr += '<span onclick="qnaOpen(' + r.refs[i].kbId + ')">' + esc(r.refs[i].title) + '</span>';
      h += '<div class="rel">' + rr + '</div>';
    }
    h += '<div class="aiwarn"><b>※ 확정 답변이 아닙니다.</b> 등록된 자료에 없는 질문이라 '
       + 'AI 가 참고용으로 정리한 내용입니다. 청구·평가에 반영하기 전에 반드시 '
       + '<b>위너넷 1:1 문의</b>로 확인하세요.</div>'
       + '<div class="go">';
    /* 현장 용어를 공식 용어로 바꿔 본 결과 — 그 말로 <자료를 직접> 다시 찾아볼 수 있게 한다.
       (예: '소변줄' 로 물으면 '유치도뇨관 유지기간 배뇨관리' 가 온다) */
    if (r.alt) h += '<a onclick="qnaReSearch(\'' + esc(r.alt).replace(/'/g,'') + '\')">'
                  + '이 용어로 자료 찾기 · ' + esc(r.alt) + '</a>';
    h += '<a onclick="qnaGo(\'asq\',1)">1:1 문의하기</a></div>';
    el('qnaDoc').innerHTML = h;
    el('qnaDoc').parentNode.scrollTop = 0;
  }
  /* AI 가 바꿔 준 공식 용어로 <자료를 직접> 다시 찾는다 (KB 검색이지 AI 호출이 아니다) */
  window.qnaReSearch = function(alt){
    el('qnaQ').value = alt;
    window.qnaSearch();
  };
  /* 답변칸의 [찾는 답이 아닌가요?] 버튼용 — 검색칸에 있는 질문 그대로 AI 에 넘긴다 */
  window.qnaAskCur = function(){
    var qq = el('qnaQ').value.replace(/^\s+|\s+$/g,'');
    if (qq) qnaAskAI(qq);
  };
  function qnaAskAI(q){
    if (ASKED[q]){ renderAI(q, ASKED[q]); return; }
    el('qnaDoc').innerHTML = '<div class="guide">등록된 자료에 없는 질문입니다. AI 가 정리하는 중…</div>';
    post(API.ask, { q:q }, function(j){
      if (j && j.ok && j.answer){ ASKED[q] = j; renderAI(q, j); }
      else el('qnaDoc').innerHTML = askGuideHtml();       /* 미설정·실패 → 종전 안내 */
    }, function(){ el('qnaDoc').innerHTML = askGuideHtml(); });
  }
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

  /* ── 최초 적재 — 자주 목록 편집 후에도 다시 부른다(2026-08-26) ──
       after = 다시 그린 <뒤에> 할 일. 저장 확인(qnaVerify)이 이 자리로 들어온다 —
       TOP·CATS 가 새로 채워진 뒤라야 방금 넣은 질문을 찾을 수 있다. */
  function qnaReloadInit(after){
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
      el('qnaListTt').innerHTML = hotTitle();
      LIST = TOP; MODE = 'hot'; CUR.cat = '__HOT__'; CUR.sub = '';
      renderList();
      if (typeof after === 'function') after();
    }, function(){
      el('qnaCats').innerHTML = '<div class="empty" style="padding:16px 14px;color:#a3b2c5">'
        + '지식 자료를 불러오지 못했습니다.</div>';
    });
  }
  qnaReloadInit();

  /* ── 등록·수정 직후 확인 (2026-08-26 요청 「등록후 어느위치하였는지」·「확인차원에서 검색」) ──────
       종전에는 저장하면 목록만 다시 그려서, 방금 넣은 질문이 <어디로 갔는지>도
       <검색으로 잡히는지>도 알 수 없었다. 이제 저장하면 곧바로
         ① 검색창에 그 제목을 넣고 <사용자가 치는 것과 똑같은 검색 API> 를 태운다
         ② 결과 몇 번째로 잡혔는지 짚어 주고 그 줄을 노랗게 번쩍인 뒤 답변을 펼친다
         ③ 검색에 안 잡히면 <경고>하고, 대신 등록한 분류 목록에서 자리를 찾아 보여 준다
       ★②가 아니라 ③이 뜨면 그 질문은 병원 사용자가 검색으로 못 찾는다는 뜻이다
         (KEYWORDS 가 비어 제목에 없는 말로는 안 걸린다) — 제목을 실제 물어볼 말로 고치거나
         KEYWORDS 를 채워야 한다. */
  function rowFind(list, kbId, title){
    for (var i=0;i<list.length;i++){
      if (kbId){ if (String(list[i].kbId) === String(kbId)) return i; }
      else if (title && (list[i].title === title || list[i].shortTitle === title)) return i;
    }
    return -1;
  }
  /* 그 줄로 스크롤 → 노랗게 번쩍 → 답변 펼침 → 머리줄·토스트에 자리 표시.
     ★qnaOpen 이 목록을 다시 그리므로 <먼저 열고 그 다음에> 줄을 집어야 한다 — 순서를 바꾸면
       방금 붙인 강조가 재렌더에 지워진다. */
  function flashRow(idx, kbId, msg, bad){
    qnaOpen(kbId);
    var box = el('qnaList'), row = box.children[idx];
    if (row){
      /* 그 줄이 목록 한가운데 오게. 음수는 0 으로 — 브라우저가 알아서 자르기는 하지만 뜻을 분명히 둔다 */
      box.scrollTop = Math.max(0, box.scrollTop + row.getBoundingClientRect().top
                                - box.getBoundingClientRect().top
                                - box.clientHeight / 2 + row.offsetHeight / 2);
      row.className += ' justsaved';
    }
    el('qnaDocSub').innerHTML = (bad ? '⚠ ' : '') + esc(msg);
    /* 토스트 갈래 이름은 ui-message.js 의 CSS 그대로 — ok/warn/err/info (success·error 는 없는 이름이라 색이 안 붙는다) */
    if (window._toast) _toast(msg, bad ? 'warn' : 'ok');
  }
  /* 검색에서 못 찾았을 때 — 등록한 분류 목록에서라도 자리를 알려 준다 */
  function verifyByCat(kbId, title, catId, head){
    if (!catId){ el('qnaDocSub').innerHTML = '⚠ ' + esc(head); if (window._toast) _toast(head, 'warn'); return; }
    var c = findCat(catId);
    CUR.cat = catId; CUR.sub = ''; CUR.fold = false; MODE = 'cat';
    renderCats();
    el('qnaListTt').innerHTML = c ? esc(c.catNm) : '질문 목록';
    el('qnaList').innerHTML = '<div class="empty">불러오는 중…</div>';
    post(API.list, { catId:catId }, function(j){
      LIST = j.list || []; renderList();
      var k = rowFind(LIST, kbId, title);
      if (k < 0){ el('qnaDocSub').innerHTML = '⚠ ' + esc(head); if (window._toast) _toast(head, 'warn'); return; }
      flashRow(k, LIST[k].kbId, head + ' · [' + (c ? c.catNm : '분류') + '] ' + (k + 1) + '번째에 있습니다', true);
    }, function(){ el('qnaDocSub').innerHTML = '⚠ ' + esc(head); if (window._toast) _toast(head, 'warn'); });
  }
  function qnaVerify(kbId, title, catId, what){
    if (!title){ verifyByCat(kbId, title, catId, what); return; }
    el('qnaQ').value = title;              /* 검색창에도 남긴다 — 관리자가 그대로 다시 눌러 볼 수 있게 */
    MODE = 'search';
    el('qnaListTt').innerHTML = '검색 · ' + esc(title);
    el('qnaList').innerHTML = '<div class="empty">등록한 내용을 검색으로 확인하는 중…</div>';
    post(API.search, { q:title, listCnt:30 }, function(j){
      LIST = j.list || [];
      var idx = rowFind(LIST, kbId, title);
      if (idx < 0){                        /* 검색으로는 못 찾는다 — 이게 알려야 할 신호다 */
        verifyByCat(kbId, title, catId, what + ' · 그런데 이 제목으로 검색하면 안 나옵니다');
        return;
      }
      renderList();
      var c = findCat(catId);
      flashRow(idx, LIST[idx].kbId,
               what + ' · 검색 ' + (idx + 1) + '번째로 확인됨'
             + (c ? ' (분류: ' + c.catNm + ')' : ''));
    }, function(){ verifyByCat(kbId, title, catId, what); });
  }

  /* ── 자주하는 질문 편집(위너넷 관리자, 2026-08-26) ──
       kbId=0 → 신규 등록 · kbId>0 → 수정(본문은 qnaGet 으로 채운다). 빼기는 지정만 푼다(지식은 남는다). */
  window.qnaTopEdit = function(kbId){
    if (!ADMIN) return;
    /* 분류는 직접 고르게 한다(사용자 2026-08-26 「선택으로 하고 선택하게」) — 첫 항목이 몰래 들어가는 것 방지 */
    var i, h = '<option value="">-- 분류를 선택하세요 --</option>';
    for (i=0;i<CATS.length;i++) h += '<option value="' + esc(CATS[i].catId) + '">' + esc(CATS[i].catNm) + '</option>';
    el('qtopCat').innerHTML = h;
    el('qtopDelBtn').style.display = kbId ? '' : 'none';   // 완전 삭제는 수정으로 열었을 때만
    if (kbId){
      _qtopId = kbId;
      el('qtopTt').innerHTML = '질문 수정';
      var x = null;
      for (i=0;i<TOP.length;i++) if (String(TOP[i].kbId) === String(kbId)) x = TOP[i];
      el('qtopTitle').value = x ? (x.title || '') : '';
      el('qtopNo').value    = x ? (x.topNo || 0) : 0;
      if (x && x.catId) el('qtopCat').value = x.catId;
      el('qtopBody').innerHTML = '불러오는 중…';
      post(API.get, { kbId:kbId, askType:'EDIT' }, function(j){
        var kb = (j && j.kb) ? j.kb : null;
        /* 편집기는 HTML 로 보고 저장한다 — 기존 plain 답변(QA·CARD 등)은 개행을 <br> 로 바꿔 연다.
           안에 섞여 있던 <b>…</b> 는 여기서 실제 굵게로 보인다(사용자 「기존 것도 이렇게 됨」 해결). */
        var b = kb ? String(kb.body || '') : '';
        el('qtopBody').innerHTML = (kb && kb.kind === 'HTML') ? b : b.replace(/\r?\n/g, '<br>');
        if (kb && kb.title) el('qtopTitle').value = kb.title;
      }, function(){ el('qtopBody').innerHTML = ''; });
    } else {
      _qtopId = null;
      el('qtopTt').innerHTML = '자주하는 질문 등록';
      el('qtopTitle').value = ''; el('qtopBody').innerHTML = '';
      el('qtopNo').value = TOP.length + 1;
    }
    el('qtopModal').style.display = '';
  };
  window.qnaTopClose = function(){ el('qtopModal').style.display = 'none'; };
  /* 알림·확인 — 가입신청 승인 화면과 같은 ui-message. 없으면 브라우저 기본으로 폴백 */
  function qask(msg, okText, onOk){
    if (window._uiMessageLoaded && typeof window._confirmBox === 'function'){
      _confirmBox({ msg:msg, icon:'❓', okText:okText, okColor:'blue', onOk:onOk });
    } else if (confirm(msg.replace(/<br\s*\/?>/gi, '\n').replace(/<[^>]+>/g, ''))) onOk();
  }
  function qmsg(msg){
    if (window._uiMessageLoaded && typeof window._alertBox === 'function') _alertBox(msg, { icon:'⚠️' });
    else alert(msg.replace(/<br\s*\/?>/gi, '\n').replace(/<[^>]+>/g, ''));
  }
  /* 편집기 툴바 — 고른 글자에 서식을 입힌다(관리자 전용 화면이라 execCommand 로 충분) */
  window.qtopCmd = function(cmd, val){
    el('qtopBody').focus();
    try { document.execCommand('styleWithCSS', false, true); } catch(ignore){}
    document.execCommand(cmd, false, val || null);
  };
  window.qnaTopSaveGo = function(){
    var t = el('qtopTitle').value.trim(), b = el('qtopBody').innerHTML.trim();
    if (!el('qtopBody').innerText.trim()) b = '';   // 서식만 남고 글이 없으면 빈 것으로 본다
    if (!el('qtopCat').value){ qmsg('분류를 선택하세요.'); el('qtopCat').focus(); return; }
    if (!t){ qmsg('질문 제목을 입력하세요.'); el('qtopTitle').focus(); return; }
    if (!b){ qmsg('답변 내용을 입력하세요.'); el('qtopBody').focus(); return; }
    /* 저장 뒤 확인에 쓸 값은 <창을 닫기 전에> 붙잡아 둔다 — 닫으면 입력칸이 비고 _qtopId 도 다음 편집에 덮인다.
       신규는 kbId 를 모르므로(서버가 안 돌려준다) 제목으로 찾는다 — 방금 저장한 그 제목이다. */
    var vId = _qtopId || '', vCat = el('qtopCat').value, vWhat = _qtopId ? '수정했습니다' : '등록했습니다';
    post('/mangr/qnaTopSave.do',
         { kbId:(_qtopId || ''), title:t, body:b, catId:vCat, topNo:(el('qtopNo').value || '0') },
         function(j){
           if (j.error_code !== '0'){ qmsg(j.error_message || '저장하지 못했습니다.'); return; }
           qnaTopClose();
           qnaReloadInit(function(){ qnaVerify(vId, t, vCat, vWhat); });
         },
         function(){ qmsg('저장하지 못했습니다.'); });
  };
  /* ★[⭐ 자주 등록]은 없앴다 (2026-08-26 사용자 「별표 기능 없애고」) — 목록마다 같은 자리에서
       올리기·내리기가 뒤바뀌지 않게 하려는 것. 새 질문은 등록하면 <자동으로> 자주하는 질문에
       올라간다(insertQnaTop 이 TOP_YN='Y' 로 넣는다).
     ⚠그래서 지금은 <한 번 뺀 질문을 화면에서 다시 올릴 길이 없다>. 서버 쪽 /mangr/qnaTopAdd.do
       와 서비스는 그대로 살려 뒀으니, 되올리기가 필요해지면 수정 창에 「자주하는 질문에 표시」
       체크 하나만 붙이면 된다(화면만 고치면 됨). */
  /* 완전 삭제 — 분류·검색·자주 목록 모두에서 내린다([빼기]와 다르다) */
  window.qnaKbDelGo = function(){
    if (!_qtopId) return;
    qask('이 질문을 <b>완전히 삭제</b>할까요?<br>분류·검색·자주하는 질문 어디에서도 안 나오게 됩니다.', '삭제', function(){
      post('/mangr/qnaKbDel.do', { kbId:_qtopId }, function(j){
        if (j.error_code !== '0'){ qmsg(j.error_message || '삭제하지 못했습니다.'); return; }
        qnaTopClose(); qnaReloadInit();
      }, function(){ qmsg('삭제하지 못했습니다.'); });
    });
  };
  window.qnaTopDelGo = function(kbId){
    /* [빼기] 아이콘은 모든 줄에 붙지만, 자주 목록에 없는 질문은 뺄 것이 없다.
       ★확인창을 띄웠다가 아무 일도 안 일어나면 <눌렀는데 먹통>으로 읽힌다 — 그 전에 사실대로 알린다.
         (아이콘을 줄마다 다르게 보이지 않게 하면서도, 무슨 일이 있었는지는 감추지 않는다) */
    if (rowFind(TOP, kbId, '') < 0){
      if (window._toast) _toast('이 질문은 자주하는 질문에 없습니다 — 뺄 것이 없습니다', 'info');
      return;
    }
    qask('<b>자주하는 질문</b>에서 뺄까요?<br>질문·답변 자체는 분류·검색에 그대로 남습니다.', '빼기', function(){
      post('/mangr/qnaTopDel.do', { kbId:kbId }, function(j){
        if (j.error_code !== '0'){ qmsg(j.error_message || '빼지 못했습니다.'); return; }
        qnaReloadInit();
      }, function(){ qmsg('빼지 못했습니다.'); });
    });
  };
})();
</script>
