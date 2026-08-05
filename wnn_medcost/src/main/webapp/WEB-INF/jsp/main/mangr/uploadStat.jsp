<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--
  청구·평가 업로드(현황) — 2026-08-05 요청
    · 사이드바 [자료올리기 ▸ 청구.평가 업로드] 바로 아래. 위너넷 관리자 전용(컨트롤러에서도 막는다).
    · 보는 법 :
        - 병원 [전체]   → 연도와 <월>을 골라, 그 달에 <어느 병원이 얼마나 올렸는지>를 병원별로 본다.
                          ★병원을 합산하지 않는다(2026-08-05 지적).
        - 병원을 고르면 → 그 병원의 그 해 자료를 <최근 월부터> 전부. (월 고르기는 꺼진다)
    · 칸    : 병원 · 월 · 유형(건강보험/의료급여) · 구분(청구서/환자평가표/입퇴원현황) · 건수 · 금액(청구)
    · 서식  : <월간보고서 목록(evalReportList.jsp)>과 같은 것을 쓴다(2026-08-05 요청) —
              검색 바(흰 카드 + 왼쪽 청록 띠 + 작은 라벨 + 청록 [검색])와
              DataTables `display nowrap stripe hover cell-border order-column` + 복사./엑셀./출력. + 자료 검색.
              DataTables·jQuery 는 tiles/main/header.jsp 에서 이미 읽어 온다(여기서 또 불러오지 말 것).
              병원 찾기는 그리드 자체 [자료 검색] 칸을 쓴다 — 따로 만들면 두 벌이 된다.
              ★thead 의 th 개수와 columns 개수는 반드시 같아야 한다(다르면 그리드가 통째로 오류).
    · 기준  : <지금 살아 있는 자료>다(업로드 이력이 아니다). 재업로드로 지워진 옛 자료는 빠진다.
              환자평가표·입퇴원현황은 청구금액이 없는 자료라 금액칸이 '-' 다.
    · 서버  : /main/select_UploadStat.do · /main/select_UploadStatHosp.do (Magam_SQL.xml)
--%>
<link href="/css/winmc/style_comm.css?v=126" rel="stylesheet">
<style>
  /* 머리·검색 바 — 월간보고서 목록(evalReportList.jsp)의 서식을 그대로 따랐다.
     ★글꼴은 지정하지 않는다(2026-08-05 요청 "동일한 폰트") — 자료올리기 그리드처럼
       테마 기본 글꼴·크기를 그대로 물려받아야 두 화면이 같아 보인다. */
  #usWrap{ color:#28323c; }
  #usWrap .us-head{ display:flex; align-items:center; gap:8px; margin-bottom:10px; }
  #usWrap .us-title{ display:flex; align-items:center; gap:8px; font-size:17px; font-weight:800; color:#1f2a30; }
  #usWrap .us-dot{ width:10px; height:10px; border-radius:50%; background:linear-gradient(135deg,#1f5a4b,#2a7665); }
  #usWrap .us-role{ font-size:11px; font-weight:700; color:#fff; background:linear-gradient(135deg,#1f5a4b,#2a7665);
                    padding:3px 9px; border-radius:20px; }
  #usWrap .us-search{ display:flex; flex-wrap:wrap; align-items:center; gap:8px; padding:10px 12px; background:#fff;
    border:1px solid #e2e7ea; border-left:4px solid #2a7665; border-radius:8px; box-shadow:0 2px 6px rgba(16,22,29,.05); margin-bottom:12px; }
  /* ★검색 바 요소는 높이를 <한 값>으로 맞춘다 (2026-08-05 요청 "높이 정렬") —
       테마 CSS(style_comm.css)가 label 에 테두리·여백을 주고 있어 그냥 두면 칸마다 높이가 들쭉날쭉하다.
       라벨은 글자만 남기고(테두리 제거), 라벨·셀렉트·버튼 모두 같은 높이로 세로 가운데 맞춤. */
  #usWrap .us-search{ align-items:center; }
  #usWrap .us-search label,
  #usWrap select.us-sel,
  #usWrap .us-combo,               /* ★병원 콤보(div)도 같은 높이로 — select 에만 걸면 24px 로 주저앉는다 */
  #usWrap .us-btn{ height:32px; box-sizing:border-box; margin:0; vertical-align:middle; }
  /* 콤보는 select 가 아니라 div 라 테두리·글자 서식을 따로 준다(겉모습은 select 와 같게) */
  #usWrap .us-combo{ padding:0 8px; border:1px solid #d5dbdf; border-radius:6px; background:#fff;
                     color:#1f2a30; font-size:13px; font-weight:700; font-family:inherit; }
  #usWrap .us-search label{ display:inline-flex; align-items:center; font-size:12.5px; font-weight:800; color:#54636c;
                            border:0; background:none; padding:0; }
  #usWrap select.us-sel{ display:inline-flex; align-items:center; font-family:inherit; font-size:13px; padding:0 8px;
                         border:1px solid #d5dbdf; border-radius:6px; background:#fff; color:#1f2a30; font-weight:700; }
  #usWrap select.us-sel:hover{ border-color:#2a7665; }
  #usWrap select.us-sel:disabled{ background:#f1f4f6; color:#9aa6ad; border-color:#e2e7ea; }
  #usWrap select.us-hosp, #usWrap .us-hosp{ min-width:220px; }
  /* 병원 콤보 — 겉모습은 select 그대로, 펼치면 검색칸이 달린 목록이 뜬다 */
  #usWrap .us-combo{ position:relative; display:inline-flex; align-items:center; justify-content:space-between;
                     gap:6px; cursor:pointer; user-select:none; outline:none; }
  #usWrap .us-combo:focus{ border-color:#2a7665; box-shadow:0 0 0 3px rgba(42,118,101,.13); }
  #usWrap .us-combo > span:first-child{ overflow:hidden; text-overflow:ellipsis; white-space:nowrap; }
  #usWrap .us-combo .us-caret{ flex:0 0 auto; color:#8b979e; font-size:11px; }
  #usWrap .us-combo-panel{ display:none; position:absolute; left:-1px; top:34px; z-index:50; width:calc(100% + 2px);
    background:#fff; border:1px solid #cfdad6; border-radius:8px; box-shadow:0 8px 22px rgba(16,22,29,.16); padding:8px; }
  #usWrap .us-combo.open .us-combo-panel{ display:block; }
  #usWrap .us-combo-panel input{ width:100%; height:30px; box-sizing:border-box; padding:0 9px; font-size:13px;
    border:1px solid #d5dbdf; border-radius:6px; font-family:inherit; }
  #usWrap .us-combo-panel input:focus{ outline:none; border-color:#2a7665; }
  #usWrap .us-combo-panel ul{ list-style:none; margin:6px 0 0; padding:0; max-height:260px; overflow-y:auto; }
  #usWrap .us-combo-panel li{ padding:6px 9px; border-radius:6px; font-size:13px; font-weight:700; color:#1f2a30;
    white-space:nowrap; overflow:hidden; text-overflow:ellipsis; }
  #usWrap .us-combo-panel li:hover, #usWrap .us-combo-panel li.on{ background:#eaf5f1; color:#1f5a4b; }
  #usWrap .us-combo-panel li.all{ border-bottom:1px solid #eef2f0; border-radius:0; margin-bottom:4px; color:#54636c; }
  #usWrap .us-combo-panel .none{ padding:10px 9px; font-size:12.5px; color:#9aa6ad; }
  #usWrap .us-btn{ display:inline-flex; align-items:center; font-family:inherit; font-size:13px; font-weight:800;
    cursor:pointer; padding:0 14px; border-radius:6px; border:1px solid transparent; background:#2a7665; color:#fff; }
  #usWrap .us-btn:hover{ background:#1f5a4b; }
  #usWrap .us-note{ margin-left:auto; font-size:12px; font-weight:700; color:#8b979e; }
  /* 조회 중 진행 표시 — 전체 병원은 병원 89곳을 훑어 1~2초 걸린다(2026-08-05 요청).
     막대가 좌우로 오가서 "멈춘 게 아니라 도는 중"임을 알린다. */
  #usWrap .us-busy{ display:inline-flex; align-items:center; gap:8px; height:32px; margin-left:10px;
                    font-size:12.5px; font-weight:800; color:#2a7665; }
  #usWrap .us-busy:before{ content:''; width:120px; height:6px; border-radius:3px; background:#e3ebe8; overflow:hidden;
                           background-image:linear-gradient(90deg,#2a7665,#7fc9b6); background-repeat:no-repeat;
                           background-size:40% 100%; animation:usBusyMove 1s ease-in-out infinite; }
  @keyframes usBusyMove{ 0%{ background-position:-10% 0; } 100%{ background-position:110% 0; } }
  /* 그리드 — 글자·여백은 자료올리기 그리드와 같게(테마 기본). 따로 키우거나 줄이지 않는다.
     ★스크롤 영역 높이는 JS(usFit)가 <실측>으로 잡는다 — 여기 값은 그 전까지 쓰는 초기값일 뿐이다.
       고정 px 로 두면 상단 헤더 높이가 화면마다 달라 페이징이 화면 밖으로 밀린다. */
  #usTable_wrapper div.dataTables_scrollBody,
  #usTable_wrapper div.dt-scroll-body{ height: max(240px, calc(100vh - 415px)); }
  /* ★그리드는 흰 바탕 (2026-08-05 요청) — 줄이 적을 때 아래로 남는 빈 자리까지 흰색으로.
       그냥 두면 바탕(회색)이 비쳐 표가 중간에서 끊긴 것처럼 보인다. */
  #usTable_wrapper{ background:#fff; border:1px solid #e2e7ea; border-radius:8px; padding:8px 10px 4px; }
  #usTable_wrapper div.dataTables_scrollBody,
  #usTable_wrapper div.dt-scroll-body,
  #usTable_wrapper div.dt-scroll-head,
  #usTable_wrapper div.dt-scroll-foot,
  #usTable, #usTable tbody, #usTable tbody tr{ background:#fff; }
  #usTable tfoot th{ background:#f2f6f5; color:#1f5a4b; font-weight:800; border-top:2px solid #cfdbd7; }
  /* 구분을 색으로 갈라 한눈에 — 청구서/환자평가표/입퇴원현황 */
  #usTable .gb1{ color:#1e3c72; font-weight:800; }
  #usTable .gb2{ color:#c2410c; font-weight:800; }
  #usTable .gb3{ color:#1f5a4b; font-weight:800; }
  #usTable td.hosp{ font-weight:800; color:#1f5a4b; }
  /* 월(·병원)이 바뀌는 줄 — 굵은 선으로 끊어 준다 (2026-08-05 요청 "월별 구분 표시") */
  #usTable tbody tr.us-mline > td{ border-top:2px solid #b9cfc8 !important; }
  #usTable td.num{ text-align:right; }
  #usTable td.file{ text-align:left; color:#54636c; }
  /* 두 번 이상 올린 달 — 이력과 실제 건수가 어긋나 보이는 자리라 눈에 띄게 */
  #usTable .up-many{ display:inline-block; font-weight:800; color:#b7791f; background:#fbf3e2;
                     border:1px solid #ead9b0; border-radius:12px; padding:0 8px; }
</style>

<div class="dashboard-wrapper">
  <div class="container-fluid dashboard-content" style="padding-bottom:8px;">
    <div id="usWrap">

      <div class="us-head">
        <span class="us-title"><span class="us-dot"></span>샘파일 업로드 현황</span>
        <span class="us-role">위너넷</span>
      </div>

      <div class="us-search">
        <label>자료년도</label>
        <select id="usYear" class="us-sel"></select>
        <label style="margin-left:6px;">자료월</label>
        <%-- 월 : 전체 병원을 볼 때만 쓴다. 병원을 고르면 '그 해 최근 월부터 전부'라 꺼진다 --%>
        <select id="usMonth" class="us-sel"></select>
        <label style="margin-left:6px;">병원</label>
        <%-- 병원 고르기 — <콤보 모양·크기는 그대로>, 펼치면 목록 <맨 위에 검색칸>이 있다
             (2026-08-05 요청 "병원콤보는 기존 사이즈에 상단검색 기능").
             병원이 89곳이라 훑는 것보다 몇 글자 치는 편이 빠르다. select2 같은 라이브러리는 이 앱에 없어 직접 만들었다.
             고른 값(요양기호)은 숨은 칸 #usHosp 에 담긴다 — 조회는 그 값만 본다. --%>
        <div id="usHospBox" class="us-sel us-hosp us-combo" tabindex="0">
          <span id="usHospText">전체 병원</span><span class="us-caret">▾</span>
          <div id="usHospPanel" class="us-combo-panel">
            <input type="text" id="usHospQ" placeholder="병원명 검색…" autocomplete="off">
            <ul id="usHospUl"></ul>
          </div>
        </div>
        <input type="hidden" id="usHosp" value="">
        <button type="button" class="us-btn" onclick="usLoad()">🔍 검색</button>
        <span id="usBusy" class="us-busy" style="display:none">불러오는 중…</span>
        <span class="us-note">지금 살아 있는 자료 기준 (재업로드로 지워진 옛 자료는 빠집니다)</span>
      </div>

      <table id="usTable" class="display nowrap stripe hover cell-border order-column" style="width:100%">
        <thead>
          <tr>
            <%-- ★th 개수 = 아래 DataTables columns 개수. 다르면 그리드가 통째로 오류난다 --%>
            <th>병원</th><th>월</th><th>유형</th><th>구분</th><th>건수</th><th>총액(진료비)</th><th>청구액</th>
            <th>올린횟수</th><th>최근 작업일시</th><th>작업자</th><th>버전</th><th>작업-KEY</th><th>파일명</th>
          </tr>
        </thead>
        <%-- 합계 줄은 두지 않는다 (2026-08-05 요청 "합계 제거") — 병원·구분이 뒤섞인 합이라 뜻이 옅고,
             자리만 차지해 표가 짧아진다. 되살리려면 tfoot 과 footerCallback 을 함께 넣으면 된다. --%>
      </table>

    </div>
  </div>
</div>

<script type="text/javascript">
/* =====================================================================
   청구·평가 업로드(현황) — 전역 이름은 us* 로 통일(다른 화면 스크립트와 겹치지 않게)
   ===================================================================== */
(function(){
  var API = { list:'/main/select_UploadStat.do', hosp:'/main/select_UploadStatHosp.do' };
  var usDt = null;                                   /* DataTable 객체 — 한 번만 만들고 자료만 갈아 끼운다 */

  function el(id){ return document.getElementById(id); }
  /* 복사·엑셀·출력으로 내보낼 때 셀 안의 태그(<span class="gb1">…)를 걷어 낸다 — 안 그러면 태그가 그대로 찍힌다 */
  function _stripTags(d){ return (d==null) ? '' : String(d).replace(/<[^>]*>/g, ''); }
  function esc(s){ return String(s==null?'':s).replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;'); }
  function num(v){ var n=Number(v||0); return isNaN(n) ? '0' : n.toLocaleString(); }
  /* 월 표기 : 202607 → 2026-07 (형식이 다르면 원문 그대로) */
  function ym(v){ var s=String(v||''); return /^\d{6}$/.test(s) ? s.substring(0,4)+'-'+s.substring(4,6) : s; }

  function post(url, params, ok){
    var body=[];
    for (var k in params) if (params[k]!=null && params[k]!=='') body.push(encodeURIComponent(k)+'='+encodeURIComponent(params[k]));
    fetch(url, { method:'POST', credentials:'same-origin',
                 headers:{ 'Content-Type':'application/x-www-form-urlencoded; charset=UTF-8' },
                 body: body.join('&') })
      .then(function(r){ return r.json(); })
      .then(function(j){ ok(j||{}); })
      .catch(function(){ ok({ result:'FAIL', list:[] }); });
  }

  /* 연도 — 올해부터 5년 전까지. 월은 [전체]와 01~12. */
  (function(){
    var y=new Date().getFullYear(), h='';
    for (var i=0;i<5;i++) h += '<option value="'+(y-i)+'">'+(y-i)+'년</option>';
    el('usYear').innerHTML=h;
    var m='<option value="">전체 월</option>';
    for (var k=1;k<=12;k++){ var v=(k<10?'0':'')+k; m += '<option value="'+v+'">'+v+'월</option>'; }
    el('usMonth').innerHTML=m;
  })();

  /* ── 병원 콤보 (겉모습은 select, 펼치면 위에 검색칸) ─────────────────────
       고른 값은 숨은 칸 #usHosp(요양기호)에, 보이는 글자는 #usHospText 에 넣는다. */
  var HOSPS = [];
  /* 상단 [병원검색]으로 고른 병원이 쿠키(s_hospid)에 있다 — 사이드바도 같은 값을 본다 */
  function getCookie(nm){
    var m = ('; '+document.cookie).split('; '+nm+'=');
    return (m.length===2) ? decodeURIComponent(m.pop().split(';').shift()) : '';
  }
  /* ★들어오면 <지금 접속한 병원>부터 보여 준다 (2026-08-05 요청 "병원검색하면 일단 그병원검색").
       상단 [병원검색]으로 병원을 바꾸고 이 화면에 오면 그 병원 자료가 먼저 뜬다. 전체는 콤보에서 고르면 된다.
     ★조회는 여기서 <한 번만> 부른다 — 화면 뜨자마자 부르면 전체(1~2초)를 조회한 뒤
       병원 기본값으로 또 조회해 두 번 도는 꼴이 된다. */
  post(API.hosp, {}, function(j){
    HOSPS = (j.list||[]);
    var cur = String(getCookie('s_hospid')||'').trim();
    if (cur){
      var hit = HOSPS.filter(function(h){ return String(h.hospCd)===cur; })[0];
      if (hit){ el('usHosp').value = hit.hospCd; el('usHospText').textContent = hit.hospNm; }
    }
    usHospDraw('');
    usLoad();
  });

  function usHospDraw(q){
    q = (q||'').trim().toLowerCase();
    var cur = el('usHosp').value, h = '<li class="all" data-cd="">전체 병원</li>';
    var n = 0;
    for (var i=0;i<HOSPS.length;i++){
      var o = HOSPS[i], nm = String(o.hospNm||''), cd = String(o.hospCd||'');
      /* 병원명·요양기호 둘 다로 찾을 수 있게 */
      if (q && (nm.toLowerCase().indexOf(q) < 0 && cd.indexOf(q) < 0)) continue;
      h += '<li'+(cd===cur?' class="on"':'')+' data-cd="'+esc(cd)+'">'+esc(nm)+'</li>';
      n++;
    }
    if (!n && q) h += '<div class="none">찾는 병원이 없습니다.</div>';
    el('usHospUl').innerHTML = h;
  }
  function usHospOpen(on){
    var box = el('usHospBox');
    box.classList.toggle('open', on);
    if (on){ el('usHospQ').value=''; usHospDraw(''); setTimeout(function(){ el('usHospQ').focus(); }, 0); }
  }
  function usHospPick(cd, nm){
    el('usHosp').value = cd || '';
    el('usHospText').textContent = cd ? nm : '전체 병원';
    usHospOpen(false);
    usLoad();                                   /* 고르면 바로 조회 — [검색]을 또 누르지 않게 */
  }
  el('usHospBox').addEventListener('click', function(e){
    if (e.target.closest('#usHospPanel')) return;              /* 패널 안쪽 클릭은 여닫지 않는다 */
    usHospOpen(!el('usHospBox').classList.contains('open'));
  });
  el('usHospQ').addEventListener('input', function(){ usHospDraw(this.value); });
  el('usHospQ').addEventListener('keydown', function(e){
    if (e.keyCode===13){                                        /* Enter = 걸러진 첫 병원 */
      var li = el('usHospUl').querySelector('li:not(.all)') || el('usHospUl').querySelector('li');
      if (li) usHospPick(li.getAttribute('data-cd'), li.textContent);
      e.preventDefault();
    } else if (e.keyCode===27){ usHospOpen(false); }
  });
  el('usHospUl').addEventListener('click', function(e){
    var li = e.target.closest('li'); if (!li) return;
    usHospPick(li.getAttribute('data-cd'), li.textContent);
  });
  document.addEventListener('click', function(e){               /* 바깥을 누르면 닫는다 */
    if (!e.target.closest('#usHospBox')) usHospOpen(false);
  });

  function usHospCd(){ return el('usHosp').value || ''; }

  /* ★병원을 골라도 월 고르기는 <그대로 쓴다> (2026-08-05 요청 "선택병원일때도 전체 및 월선택").
       전에는 병원을 고르면 월을 꺼 버렸는데, 그러면 "이 병원의 그 달만" 보는 길이 막힌다.
       월 = [전체 월] 이면 그 해 전부를 최근 월부터, 월을 고르면 그 달만 — 전체/개별 병원 모두 같은 규칙. */

  /* 표 안쪽(스크롤 영역) 높이를 <실측>으로 잡는다 (2026-08-05 "하단 페이징 안 보임").
       calc(100vh - 고정px) 로 잡으면 상단 헤더·알림바 높이가 화면마다 달라 페이징이 화면 밖으로 밀린다.
       실제 시작 위치를 재서 <창 높이 − 시작위치 − 아래여유> 로 잡는다. 아래여유 = 합계줄 + 정보/페이징 + 여백.
       (evalReportList·qnacd 의 fitHeight 와 같은 방식) */
  var US_BOTTOM = 108;
  function usFit(){
    var b = document.querySelector('#usTable_wrapper div.dt-scroll-body, #usTable_wrapper div.dataTables_scrollBody');
    if (!b) return;
    var h = Math.max(200, Math.round(window.innerHeight - b.getBoundingClientRect().top - US_BOTTOM));
    b.style.height = h + 'px';
    b.style.maxHeight = h + 'px';
  }
  window.addEventListener('resize', usFit);

  /* ── 그리드 (자료올리기 화면과 같은 DataTables) ─────────────────────
       · 병원칸이 맨 앞. 한 병원만 볼 때는 같은 이름이 반복될 뿐이라 칸을 감춘다.
       · 정렬은 서버가 준 차례(최근 월 → 병원명)를 그대로 둔다(order:[]). 머리글을 누르면 다시 정렬된다.
       · 합계는 <걸러진 줄> 기준으로 다시 잡는다 — 검색칸으로 병원을 추려도 숫자가 맞아야 한다. */
  function usGrid(){
    if (usDt) return usDt;
    usDt = $('#usTable').DataTable({
      language: {
        search: "&nbsp;자 료 검 색 : ",
        emptyTable: "올라온 자료가 없습니다. (조건을 바꿔 다시 검색하세요)",
        zeroRecords: "일치하는 병원이 없습니다.",
        info: "현재 _START_ - _END_ / 총 _TOTAL_건",
        infoEmpty: "0건",
        infoFiltered: "( _MAX_건 중 필터 )",
        loadingRecords: "대기중...",
        processing: "잠시만 기다려 주세요...",
        paginate: { next:"다음", previous:"이전" }
      },
      data: [],
      columns: [
        { title:'병원',       data:'hospNm', className:'hosp',
          render:function(d,t,r){ return t==='display' ? esc(d||r.hospCd||'') : (d||''); } },
        { title:'월',         data:'ym',      className:'dt-center',
          render:function(d,t){ return t==='display' ? ym(d) : d; } },
        { title:'유형',       data:'insurNm', className:'dt-center' },
        { title:'구분',       data:'gubun',   className:'dt-center',
          render:function(d,t){
            if (t!=='display') return d;
            var c = (d==='청구서') ? 'gb1' : (d==='환자평가표' ? 'gb2' : 'gb3');
            return '<span class="'+c+'">'+esc(d)+'</span>';
          } },
        { title:'건수',        data:'cnt',    className:'num',
          render:function(d,t){ return t==='display' ? num(d)+' 건' : Number(d||0); } },
        { title:'총액(진료비)', data:'totAmt', className:'num',
          render:function(d,t){ return t==='display' ? (Number(d||0) ? num(d)+' 원' : '-') : Number(d||0); } },
        { title:'청구액',      data:'amt',    className:'num',
          render:function(d,t){ return t==='display' ? (Number(d||0) ? num(d)+' 원' : '-') : Number(d||0); } },
        /* ── 여기부터는 <업로드 이력> — 건수·금액(살아 있는 자료)과 달리 '언제·누가·무엇으로 올렸나' ── */
        { title:'올린횟수',    data:'upCnt',  className:'dt-center',
          render:function(d,t){
            var n = Number(d||0);
            if (t!=='display') return n;
            /* 두 번 이상 올린 달은 눈에 띄게 — 이력과 실제 건수가 어긋나 보이는 원인이 대개 여기다 */
            return n>1 ? '<span class="up-many">'+n+'회</span>' : (n ? n+'회' : '-');
          } },
        { title:'최근 작업일시', data:'lastDt', className:'dt-center',
          render:function(d,t){ return t==='display' ? esc(String(d||'').replace('T',' ').substring(0,19)) : (d||''); } },
        { title:'작업자',      data:'lastUser', className:'dt-center',
          render:function(d,t){ return t==='display' ? esc(d||'-') : (d||''); } },
        { title:'버전',        data:'lastVer', className:'dt-center',
          render:function(d,t){ return t==='display' ? esc(d||'-') : (d||''); } },
        { title:'작업-KEY',    data:'lastKey', className:'dt-center',
          render:function(d,t){ return t==='display' ? esc(d||'-') : (d||''); } },
        { title:'파일명',      data:'lastFile', className:'file',
          render:function(d,t){ return t==='display' ? esc(d||'-') : (d||''); } }
      ],
      order: [],                        /* 서버가 준 차례(최근 월 → 병원명) 유지. 머리글을 누르면 다시 정렬 */
      autoWidth: false,
      ordering: true,
      lengthChange: false,
      pageLength: 100,                  /* 표 안에서 스크롤되므로 한 쪽을 넉넉히 — 페이지를 자주 넘길 일이 없다 */
      scrollX: true,
      scrollY: 'max(240px, calc(100vh - 415px))',
      scrollCollapse: false,            /* 줄이 적어도 높이를 유지 → 페이징 자리가 움직이지 않는다 */
      rowCallback: function(row){ $(row).find('td').css('padding','3px'); },   /* 자료올리기 그리드와 같은 행 높이 */
      dom: '<"row"<"col-sm-7"B><"col-sm-5"f>>t<"row mt-2"<"col-sm-6"i><"col-sm-6"p>>',
      buttons: [
        { extend:'copy',       text:'복사.', exportOptions:{ format:{ body:_stripTags } } },
        { extend:'excelHtml5', text:'엑셀.', title:'샘파일 업로드 현황',
          filename: function(){
            return '샘파일_업로드현황_' + (el('usYear') ? el('usYear').value : '')
                 + ((el('usMonth') && el('usMonth').value) ? el('usMonth').value : '');
          },
          exportOptions:{ format:{ body:_stripTags } } },
        { extend:'print',      text:'출력.', title:'샘파일 업로드 현황', autoPrint:true,
          exportOptions:{ format:{ body:_stripTags } } }
      ],
      /* 병원명 묶어 보이기 — 위 줄과 같은 병원이면 이름을 비운다(2026-08-05 요청).
         ★그릴 때마다 다시 계산한다 — 정렬·검색으로 차례가 바뀌어도 묶음이 어긋나지 않는다.
         ★내려받기(복사·엑셀·출력)는 화면이 아니라 <자료>를 쓰므로 병원명이 모든 줄에 그대로 들어간다. */
      drawCallback: function(){
        var api = this.api(), prev = null, prevYm = null;
        /* ★반드시 <자료>에서 이름을 다시 읽어 넣는다. 화면 글자를 보고 판단하면,
             한 번 비운 칸이 그대로 남아 있어(그리드가 줄을 다시 만들지 않는다)
             정렬을 바꾸는 순간 병원명이 통째로 사라진다 — 실제로 겪었다(2026-08-05). */
        usFit();                                      /* 그릴 때마다 표 높이를 화면에 맞춘다 */
        api.rows({ page:'current', order:'applied', search:'applied' }).every(function(){
          var d = this.data() || {}, nm = String(d.hospNm || d.hospCd || ''), ymv = String(d.ym || '');
          var tr = $(this.node()), td = tr.find('td.hosp').first();
          if (!td.length) return;
          /* 월(또는 병원)이 바뀌는 첫 줄에 구분선 — 한 병원에서 월이 여러 개 이어질 때
             어디서 달이 바뀌는지 눈으로 끊어 보게 한다(2026-08-05 요청 "월별 구분 표시").
             맨 첫 줄에는 선을 긋지 않는다(머리글과 붙어 두 줄로 보인다). */
          var newHosp = (nm !== prev), newYm = (newHosp || ymv !== prevYm);
          tr.toggleClass('us-mline', !!(newYm && prevYm !== null));
          if (newHosp){ td.text(nm).removeClass('hosp-cont'); prev = nm; }
          else        { td.text('').addClass('hosp-cont'); }
          prevYm = ymv;
        });
      }
    });
    return usDt;
  }

  window.usLoad = function(){
    var year = el('usYear').value,
        month= el('usMonth').value,          /* 전체·개별 병원 모두 같은 규칙 — 비었으면 그 해 전부 */
        hosp = usHospCd();
    var dt = usGrid();
    /* 진행 표시 — 전체 병원은 89곳을 훑어 1~2초 걸린다(2026-08-05 요청 "전체병원일때 진행바") */
    el('usBusy').style.display = '';
    post(API.list, { mgYear:year, mgMonth:month, hospCd:hosp }, function(j){
      el('usBusy').style.display = 'none';
      /* 병원칸은 <한 병원만 볼 때도> 보여 준다(2026-08-05 요청) — 어느 병원을 보고 있는지가
         화면·인쇄물에 남아야 한다. 반복되는 이름은 drawCallback 이 묶어 준다. */
      dt.clear();
      if (j.result==='OK' && (j.list||[]).length) dt.rows.add(j.list);
      dt.columns.adjust().draw();
    });
  };

  /* 첫 조회는 위 병원목록 콜백에서 부른다(접속 병원을 먼저 넣어야 하므로). 여기서 또 부르지 않는다. */
})();
</script>
