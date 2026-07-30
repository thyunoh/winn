<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--
  적정성평가 Q&A 챗봇 (전 화면 플로팅) — 2026-07-29
    · 목적: 적정성평가·청구명세서·환자평가표 작성·평가기준 문의가 위너넷으로 몰리는 것을 화면에서 먼저 받아낸다.
    · 방식: 외부 API 없음. 아래 KB(지식카드) 안에서만 답한다 — 근거는 전부 사내 확정 자료다.
        · 지표 정의/개선방향  : evalReport.jsp TPL_DEF / TPL_DIR
        · 표준화구간·가중치   : assessment.jsp _STD_RANGE_DATA (2주기 6차)
        · 욕창 처치 산정규칙   : docs/욕창처치율_산정규칙.md
        · 유치도뇨관 14일 규칙 : docs/유치도뇨관_14일초과_산정규칙.md
        · 샘파일 버전매칭     : docs/파일검증_버전매칭규칙.md
        · 오류점검 코드 A~N   : assesCheck.jsp errType 라벨 + Magam_SQL.xml select_assesCheck
      ★ 없는 내용을 지어내지 않는다. 못 찾으면 후보를 보여주고, 그래도 아니면 1:1 문의로 넘긴다.
    · 배치: tiles main.jsp 에서 1회 include → .main/* 전 화면에 뜬다. 컨트롤러·DB·메뉴 등록 불필요.
    · 배포: JSP 파일 교체만. WAR 재빌드·톰캣 재기동 불필요.
    · 지식 추가/수정: 아래 WQA_KB 배열에 카드 한 개 추가하면 끝.
        {id, c:분류, t:대표질문, k:[동의어키워드], a:[답변줄], src:'근거', go:[{n,u}], rel:[연관id]}
--%>
<style>
  /* ── 글자체 = sejong-web 과 동일한 Noto Sans KR ────────────
       sejong-web(asset/css/reset.css)의 @font-face 방식을 그대로 따르되,
       ★경로는 이 프로젝트에 실제로 있는 /asset/fonts/ 바로 아래를 쓴다.
         (reset.css 가 가리키는 /asset/fonts/NotoSansKr/ 폴더는 이 프로젝트엔 없다 — 폴더명이 NotoSanKr 다.
          그 파일을 그대로 쓰면 폰트가 적용되지 않으니 경로를 바꾸지 말 것.)                        */
  @font-face{ font-family:"Noto Sans KR"; font-style:normal; font-weight:400; font-display:swap;
              src:url(/asset/fonts/NotoSansKR-Regular.woff2) format("woff2"),
                  url(/asset/fonts/NotoSansKR-Regular.woff) format("woff"); }
  @font-face{ font-family:"Noto Sans KR"; font-style:normal; font-weight:500; font-display:swap;
              src:url(/asset/fonts/NotoSansKR-Medium.woff2) format("woff2"),
                  url(/asset/fonts/NotoSansKR-Medium.woff) format("woff"); }
  @font-face{ font-family:"Noto Sans KR"; font-style:normal; font-weight:700; font-display:swap;
              src:url(/asset/fonts/NotoSansKR-Bold.woff2) format("woff2"),
                  url(/asset/fonts/NotoSansKR-Bold.woff) format("woff"); }
  @font-face{ font-family:"Noto Sans KR"; font-style:normal; font-weight:900; font-display:swap;
              src:url(/asset/fonts/NotoSansKR-Black.woff2) format("woff2"),
                  url(/asset/fonts/NotoSansKR-Black.woff) format("woff"); }

  /* ── 플로팅 버튼 ───────────────────────────────────────── */
  #wqaFab{ position:fixed; right:22px; bottom:22px; z-index:12000; display:flex; align-items:center; gap:8px;
           height:50px; padding:0 18px 0 15px; border:none; border-radius:26px; cursor:pointer;
           background:linear-gradient(135deg,#1f6feb,#1746a2); color:#fff; font-size:15.5px; font-weight:700;
           font-family:"Noto Sans KR","Malgun Gothic","맑은 고딕","Apple SD Gothic Neo",sans-serif;
           box-shadow:0 6px 18px rgba(23,70,162,.34); transition:transform .15s ease, box-shadow .15s ease; }
  #wqaFab:hover{ transform:translateY(-2px); box-shadow:0 10px 24px rgba(23,70,162,.42); }
  #wqaFab .ic{ font-size:19px; }
  #wqaFab.wqa-hide{ display:none; }

  /* ── 패널 ─────────────────────────────────────────────── */
  #wqaPanel{ position:fixed; right:22px; bottom:22px; z-index:12001; width:560px; max-width:calc(100vw - 30px);
             height:780px; max-height:calc(100vh - 70px); display:none; flex-direction:column;
             background:#f4f7fb; border:1px solid #d3dfef; border-radius:14px; overflow:hidden;
             box-shadow:0 18px 44px rgba(20,40,80,.28); color:#28323c;
             font-family:"Noto Sans KR","Malgun Gothic","맑은 고딕","Apple SD Gothic Neo",sans-serif;
             font-size:15px; }   /* ★기준 글자크기 — 안쪽은 전부 em 이라 이 값만 바뀌면 같이 커진다 */
  #wqaPanel input, #wqaPanel button{ font-family:inherit; }

  /* ── 크기 조절 = 테두리 드래그 ────────────────────────────
       패널이 우측하단에 고정돼 있으므로 왼쪽 테두리(폭)·위쪽 테두리(높이)·좌상단 모서리(둘 다)를 잡아 끈다.
       조절한 크기는 세션에 저장돼 다음 화면에서도 유지된다.                                     */
  .wqa-rz{ position:absolute; z-index:3; }
  .wqa-rz-l{ left:0; top:0; bottom:0; width:7px; cursor:ew-resize; }
  .wqa-rz-t{ left:0; right:0; top:0; height:7px; cursor:ns-resize; }
  .wqa-rz-tl{ left:0; top:0; width:16px; height:16px; cursor:nwse-resize; z-index:4; }
  .wqa-rz-tl:after{ content:''; position:absolute; left:4px; top:4px; width:7px; height:7px;
                    border-left:2px solid #b7c8de; border-top:2px solid #b7c8de; border-radius:2px 0 0 0; }
  #wqaPanel.wqa-rzing{ user-select:none; }
  #wqaPanel.wqa-rzing #wqaLog{ pointer-events:none; }
  #wqaPanel.wqa-open{ display:flex; animation:wqaUp .26s cubic-bezier(.22,.9,.25,1) both; }
  @keyframes wqaUp{ from{ opacity:0; transform:translateY(18px) scale(.98);} to{ opacity:1; transform:none;} }

  #wqaPanel .wqa-hd{ flex:0 0 auto; display:flex; align-items:center; gap:8px; padding:11px 13px;
                     background:#fff; border-bottom:1px solid #e2eaf4; }
  #wqaPanel .wqa-hd .tt{ flex:1; min-width:0; font-size:1.1em; font-weight:800; color:#1746a2; }
  /* 부제는 한 줄 고정 — 두 줄로 접히면 헤더가 밀려 버튼과 겹친다 */
  #wqaPanel .wqa-hd .tt small{ display:block; font-size:.8em; font-weight:600; color:#93a2b5; margin-top:1px;
                               white-space:nowrap; overflow:hidden; text-overflow:ellipsis; }
  #wqaPanel .wqa-hd button{ flex:0 0 auto; border:none; background:transparent; color:#5b6c80; cursor:pointer;
                            font-size:.83em; font-weight:700; padding:4px 6px; border-radius:6px; }
  #wqaPanel .wqa-hd button:hover{ background:#eef3fa; color:#1746a2; }
  /* 글자 축소·확대 버튼 — 헤더가 좁으므로 작게 */
  #wqaPanel .wqa-hd button.fz{ min-width:2.1em; padding:3px 5px; border:1px solid #dde7f4; background:#f7fafd; }
  #wqaPanel .wqa-hd button.fz:hover{ background:#1f6feb; border-color:#1f6feb; color:#fff; }
  #wqaPanel .wqa-hd .x{ font-size:1.14em; line-height:1; }

  #wqaLog{ flex:1 1 auto; overflow-y:auto; padding:14px 13px 6px; }
  #wqaLog::-webkit-scrollbar{ width:8px; }
  #wqaLog::-webkit-scrollbar-thumb{ background:#cbd8e8; border-radius:4px; }

  /* ★질문·답변 좌우 배치 (2026-07-30 사용자 확정: **질문 왼쪽 · 답변 오른쪽**) —
       말풍선 폭이 97%면 한 줄을 다 먹어 어느 쪽 정렬인지 안 보인다 → 86%로 줄여 방향이 읽히게 유지. */
  .wqa-row{ display:flex; justify-content:flex-end; margin-bottom:11px; animation:wqaIn .24s ease both; }   /* 답변 = 오른쪽 */
  .wqa-row.me{ justify-content:flex-start; }                                                                 /* 질문 = 왼쪽 */
  @keyframes wqaIn{ from{ opacity:0; transform:translateY(7px);} to{ opacity:1; transform:none;} }
  .wqa-bub{ max-width:86%; padding:10px 13px; border-radius:13px; font-size:1em; line-height:1.8;
            background:#fff; border:1px solid #dfe8f3; color:#28323c; box-shadow:0 1px 2px rgba(23,70,162,.05);
            overflow-wrap:anywhere; word-break:break-word; }
  .wqa-row.me .wqa-bub{ background:#1f6feb; border-color:#1f6feb; color:#fff; font-weight:600; }
  /* 이전 질문 — 한 줄로 접어 둔다(누르면 그 답변이 펼쳐진다) */
  .wqa-hist{ display:flex; align-items:center; gap:7px; margin:0 0 7px; padding:6px 11px; cursor:pointer;
             background:#eef3fa; border:1px solid #dde7f4; border-radius:10px; font-size:.87em; color:#5b6c80;
             transition:background .14s ease, border-color .14s ease; }
  .wqa-hist:hover{ background:#e3ecf9; border-color:#c7d8ee; }
  .wqa-hist.op{ background:#e3ecf9; border-color:#c7d8ee; }
  .wqa-hist .arw{ flex:0 0 auto; color:#8ba0bb; font-weight:800; }
  .wqa-hist .q{ flex:1; min-width:0; font-weight:700; color:#37475a;
                white-space:nowrap; overflow:hidden; text-overflow:ellipsis; }
  /* 질문 개별 삭제 ✕ — 접힌 줄에서는 오른쪽 끝, 최근 질문에서는 말풍선 **오른쪽**(질문이 왼쪽 배치로 바뀌어 ✕도 뒤로) */
  .wqa-hist .del{ flex:0 0 auto; color:#adbcce; font-weight:700; padding:0 2px 0 6px; }
  .wqa-hist .del:hover{ color:#e2564a; }
  .wqa-row.me{ align-items:center; gap:7px; }
  .wqa-row.me .wqa-qdel{ order:2; }   /* 마크업(✕ 먼저)은 그대로 두고 순서만 뒤로 — 왼쪽 말풍선 뒤에 ✕ */
  .wqa-qdel{ flex:0 0 auto; width:1.55em; height:1.55em; line-height:1.5em; text-align:center; cursor:pointer;
             border-radius:50%; background:#fff; border:1px solid #dfe8f3; color:#9aabc0; font-size:.8em; font-weight:700;
             opacity:.5; transition:opacity .15s ease, color .15s ease, border-color .15s ease; }
  .wqa-row.me:hover .wqa-qdel{ opacity:1; }
  .wqa-qdel:hover{ color:#e2564a; border-color:#f0c2bc; }
  /* 이전 질문과 최근 문답을 가르는 선 */
  .wqa-nowline{ display:flex; align-items:center; gap:9px; margin:11px 0 9px; color:#a3b2c5; font-size:.78em; font-weight:700; }
  .wqa-nowline:before, .wqa-nowline:after{ content:''; flex:1; height:1px; background:#dde7f4; }

  .wqa-bub b{ color:#1746a2; }
  .wqa-row.me .wqa-bub b{ color:#fff; }
  .wqa-bub .h{ display:block; font-size:1.07em; font-weight:800; color:#1746a2; margin-bottom:5px; }
  .wqa-bub ul{ margin:2px 0 0; padding:0; list-style:none; }
  .wqa-bub li{ position:relative; padding-left:12px; margin:3px 0; }
  .wqa-bub li:before{ content:''; position:absolute; left:0; top:.74em; width:4px; height:4px; border-radius:50%; background:#8ba7d4; }
  .wqa-bub .cat{ display:inline-block; font-size:.77em; font-weight:700; color:#1746a2; background:#eaf1fd;
                 border:1px solid #d3e0f7; border-radius:9px; padding:1px 7px; margin-bottom:6px; }
  .wqa-bub table{ width:100%; border-collapse:collapse; margin-top:6px; font-size:.87em; }
  .wqa-bub th,.wqa-bub td{ border:1px solid #e2eaf4; padding:3px 6px; text-align:center; }
  .wqa-bub th{ background:#f3f7fd; color:#37475a; font-weight:700; }

  /* 근거 · 관련화면 */
  .wqa-src{ margin-top:8px; padding-top:7px; border-top:1px dashed #dfe8f3; font-size:.83em; color:#8494a8; line-height:1.6; }
  .wqa-src b{ color:#6b7a8d; }
  .wqa-go{ display:flex; flex-wrap:wrap; gap:5px; margin-top:7px; }
  .wqa-go a{ font-size:.87em; font-weight:700; color:#0f6b5c; background:#f2fbf8; border:1px solid #bfe0d8;
             border-radius:8px; padding:2px 9px; text-decoration:none; cursor:pointer; }
  .wqa-go a:hover{ background:#0f6b5c; color:#fff; border-color:#0f6b5c; }
  /* 답을 못 찾았을 때의 1:1 문의 — 눈에 띄는 기본 버튼 */
  .wqa-go a.pri{ background:#1f6feb; border-color:#1f6feb; color:#fff; padding:4px 13px; }
  .wqa-go a.pri:hover{ background:#1655c0; border-color:#1655c0; }
  .wqa-rel{ display:flex; flex-wrap:wrap; gap:5px; margin-top:7px; }
  .wqa-rel span{ font-size:.87em; font-weight:600; color:#1746a2; background:#fff; border:1px solid #cfdcec;
                 border-radius:12px; padding:2px 9px; cursor:pointer; }
  .wqa-rel span:hover{ background:#1746a2; color:#fff; border-color:#1746a2; }

  /* 입력부 */
  .wqa-ft{ flex:0 0 auto; background:#fff; border-top:1px solid #e2eaf4; padding:9px 11px 10px; }
  .wqa-in{ display:flex; gap:7px; }
  .wqa-in input{ flex:1; height:2.8em; border:1px solid #cfdcec; border-radius:9px; padding:0 13px; font-size:.97em; }
  .wqa-in input:focus{ outline:none; border-color:#1f6feb; box-shadow:0 0 0 3px rgba(31,111,235,.13); }
  .wqa-in button{ flex:0 0 auto; height:2.8em; padding:0 18px; border:none; border-radius:9px; background:#1f6feb;
                  color:#fff; font-size:.97em; font-weight:800; cursor:pointer; }
  .wqa-in button:hover{ background:#1655c0; }
  /* 질문 유형(분류) 줄 */
  .wqa-cats{ display:flex; flex-wrap:wrap; gap:5px; margin-top:9px; }
  .wqa-cats span{ font-size:.87em; font-weight:700; color:#1746a2; background:#fff; border:1px solid #cfdcec;
                  border-radius:13px; padding:4px 12px; cursor:pointer; }
  .wqa-cats span:hover{ background:#e8f0fd; }
  .wqa-cats span.on{ background:#1746a2; color:#fff; border-color:#1746a2; }
  .wqa-cats span .n{ opacity:.65; font-weight:600; margin-left:4px; }
  /* 선택한 분류의 질문 목록 — 길면 이 영역만 스크롤 */
  .wqa-chips{ display:flex; flex-wrap:wrap; gap:5px; margin-top:7px; max-height:8.6em; overflow-y:auto; }
  .wqa-chips::-webkit-scrollbar{ width:7px; }
  .wqa-chips::-webkit-scrollbar-thumb{ background:#cbd8e8; border-radius:4px; }
  .wqa-chips span{ font-size:.87em; font-weight:600; color:#37475a; background:#f4f7fb; border:1px solid #dfe8f3;
                   border-radius:13px; padding:4px 11px; cursor:pointer; }
  .wqa-chips span:hover{ background:#1f6feb; color:#fff; border-color:#1f6feb; }
  .wqa-chips span.on{ background:#1746a2; color:#fff; border-color:#1746a2; }

  @media (max-width:560px){
    #wqaPanel{ right:8px; left:8px; width:auto; height:calc(100vh - 80px); }
    .wqa-rz{ display:none; }        /* 좁은 화면에선 전체폭이라 테두리 조절 불필요 */
  }
  @media (prefers-reduced-motion: reduce){
    #wqaPanel.wqa-open,.wqa-row{ animation:none !important; }
    #wqaFab{ transition:none !important; }
  }
</style>

<button id="wqaFab" type="button" onclick="wqaOpen()" title="적정성평가 궁금한 점을 물어보세요">
  <span class="ic">💬</span><span>적정성평가 Q&amp;A</span>
</button>

<div id="wqaPanel">
  <%-- 테두리(왼쪽·위쪽·좌상단 모서리)를 끌어 크기를 조절한다 --%>
  <div class="wqa-rz wqa-rz-l"  title="좌우 크기 조절"></div>
  <div class="wqa-rz wqa-rz-t"  title="위아래 크기 조절"></div>
  <div class="wqa-rz wqa-rz-tl" title="크기 조절"></div>

  <div class="wqa-hd">
    <div class="tt">💬 적정성평가 Q&amp;A<small>지표 · 평가표 · 청구업로드 · 오류점검</small></div>
    <button type="button" class="fz" onclick="wqaFont(-1)" title="글자 작게">가－</button>
    <button type="button" class="fz" onclick="wqaFont(1)"  title="글자 크게">가＋</button>
    <button type="button" onclick="wqaReset()" title="창 크기·글자크기를 처음 상태로">↺ 원위치</button>
    <button type="button" onclick="wqaClear()" title="대화 전체 삭제">🗑 전체 삭제</button>
    <button type="button" class="x" onclick="wqaClose()" title="닫기">✕</button>
  </div>

  <div id="wqaLog"></div>

  <div class="wqa-ft">
    <div class="wqa-in">
      <input type="text" id="wqaQ" placeholder="질문을 입력하세요…  예) 배뇨관리 분자 인정 조건"
             onkeydown="if(event.keyCode===13){wqaSend();return false;}" autocomplete="off">
      <button type="button" onclick="wqaSend()">전송</button>
    </div>
    <%-- 질문 유형(분류) → 그 분류의 질문 목록. 타이핑 없이 눌러서 찾는 경로 --%>
    <div class="wqa-cats"  id="wqaCats"></div>
    <div class="wqa-chips" id="wqaChips"></div>
  </div>
</div>

<script>
/* =====================================================================
   적정성평가 Q&A — 지식카드(KB) + 검색형 답변 엔진
     · 답은 아래 WQA_KB 안에서만 나온다(외부 통신 없음).
     · 카드 추가법: WQA_KB 에 {id,c,t,k,a,src,go,rel} 한 줄 추가.
   ===================================================================== */
(function(){
  if (window.__wqaInit) return; window.__wqaInit = true;

  /* ── 화면 링크 (사이드바와 동일 경로) ── */
  var GO_ASSES  = { n:'적정성평가 화면',   u:'/main/assessment.do' };
  var GO_CHECK  = { n:'오류점검',          u:'/main/assesCheck.do' };
  var GO_UPLOAD = { n:'청구·평가 업로드',  u:'/main/magamFileUpload.do' };
  var GO_SIM    = { n:'병원검색(시뮬레이션)', u:'/main/simulation.do' };
  var GO_REPORT = { n:'월간보고서',        u:'/main/evalReportList.do' };
  /* ★1:1 문의·자주하는 질문은 화면 이동이 아니라 <사이드바의 그 버튼과 똑같은 모달>을 띄운다.
       sidebar.jsp 의 fnasq_main() / loadFaqData() 를 그대로 호출한다(top.jsp 가 전 화면에 sidebar 를 포함).
       함수가 없으면 예전처럼 화면 이동으로 자동 대체된다.                                        */
  var GO_ASQ    = { n:'1:1 문의하기',      u:'asq', s:1 };
  var GO_FAQ    = { n:'자주하는 질문',     u:'faq', s:1 };

  /* ── 지식카드 ──────────────────────────────────────────
       c(분류): 지표 | 평가표 | 청구 | 점검 | 사용법                       */
  var WQA_KB = [

  /* ───────── 지표 · 평가기준 ───────── */
  { id:'ind-list', c:'지표', t:'적정성평가 지표는 모두 몇 개이고 무엇인가요?',
    k:['지표목록','지표몇개','전체지표','지표종류','평가지표','구조지표','과정지표','결과지표','지표가뭐'],
    a:['<b>구조영역 4 + 진료영역(과정·결과)</b> 으로 구성됩니다.',
       '<b>구조지표</b> — 의사 1인당 환자수 · 간호사 1인당 환자수 · 간호인력 1인당 환자수 · 약사 재직일수율',
       '<b>과정지표</b> — 유치도뇨관이 있는 환자분율 · 배뇨관리 · 항정신성의약품 처방률 · DUR 점검률 · 욕창 처치를 실시한 환자분율',
       '<b>결과지표</b> — 욕창이 새로 생긴 환자분율 · 욕창 개선 환자분율 · ADL 개선 환자분율 · HbA1c 적정범위 환자분율 · 장기입원(181일 이상) 환자분율 · 지역사회 복귀율',
       '각 지표의 <b>표준화구간과 가중치</b>는 적정성평가 화면 상단 <b>[표준화구간]</b> 버튼에서 표로 확인하실 수 있습니다.'],
    src:'적정성평가 화면 표준화구간표(2주기 6차) · 월간보고서 지표 정의',
    go:[GO_ASSES], rel:['ind-score','ind-weight'] },

  { id:'ind-weight', c:'지표', t:'지표별 가중치와 5점 구간이 어떻게 되나요?',
    k:['가중치','표준화구간','5점구간','구간표','몇점','점수구간','배점'],
    a:['2주기 6차 기준 <b>가중치 · 5점(최고구간) 기준</b>입니다.',
       '의사 1인당 8.5점(26명 미만) · 간호사 1인당 8.5점(6명 미만) · 간호인력 1인당 7.5점(3명 미만) · 약사 재직일수율 5.5점(100%)',
       '유치도뇨관 6점(0.5% 미만) · 항정신성 3점(0.2PI 미만) · DUR 3점(97% 이상) · 욕창처치 2점(95% 이상)',
       '신규욕창 4.4점(0.25% 미만) · <b>욕창개선 17.6점(60% 이상)</b> · <b>ADL개선 12점(45% 이상)</b> · <b>HbA1c 12점(98% 이상)</b> · 장기입원 5점(20% 미만) · 지역사회복귀 5점(70% 이상)',
       '가중치가 큰 <b>욕창개선·ADL개선·HbA1c</b> 세 지표가 종합점수를 좌우합니다. 여기부터 관리하시는 것이 효율적입니다.'],
    src:'적정성평가 화면 [표준화구간] 버튼 — 2024년(2주기 6차) 지표별 표준화 점수구간·가중치표',
    go:[GO_ASSES], rel:['ind-score','ind-list'] },

  { id:'ind-score', c:'지표', t:'종합점수는 어떻게 계산되나요?',
    k:['종합점수','점수계산','산출점수','점수산정','계산식','등급'],
    a:['<b>산출점수 = 가중치 ÷ 5 × 표준화구간</b> 입니다.',
       '예) 욕창개선(가중치 17.6)이 표준화 4구간이면 → 17.6 ÷ 5 × 4 = <b>14.08점</b>',
       '각 지표 산출점수를 모두 더한 값이 <b>종합점수</b>이고, 종합점수로 등급이 결정됩니다.',
       '현황값이 구간 경계에 걸쳐 있으면 환자 <b>1~2명 차이로 구간이 바뀌어</b> 점수가 크게 움직입니다. 병원검색(시뮬레이션) 화면에서 <b>5점 도달까지 몇 명 필요한지</b> 확인하실 수 있습니다.'],
    src:'적정성평가 화면 산출점수 계산식(가중치/5×구간)',
    go:[GO_SIM, GO_ASSES], rel:['ind-weight','use-sim'] },

  { id:'ind-goal', c:'지표', t:'목표점수·목표등급이 보고서와 다르게 나옵니다',
    k:['목표점수','목표등급','차등제','goal','등급이다름','보고서목표'],
    a:['월간보고서 표지의 목표점수·목표등급은 <b>차등제 등록 화면에 저장된 값</b>을 그대로 가져옵니다.',
       '값을 바꾸시려면 <b>적정성평가 화면의 차등제(목표등급) 등록</b>에서 해당 <b>연도·분기</b>의 목표점수와 병원등급을 수정하고 저장해 주세요.',
       '보고서 화면에서 목표점수를 직접 고쳐 저장해도, 다음에 열면 <b>차등제 등록값으로 되돌아갑니다</b>(등록값이 원본이기 때문입니다).',
       '해당 분기 등록 자료가 없으면 목표가 표시되지 않습니다 — 분기별로 저장돼 있는지 확인해 주세요.'],
    src:'월간보고서 목표점수·목표등급 = 차등제 등록(연도·분기) 연계 규칙',
    go:[GO_ASSES, GO_REPORT], rel:['use-report'] },

  { id:'ind-01', c:'지표', t:'의사 1인당 환자수는 어떻게 산정되나요?',
    k:['의사1인당','의사인당','의사수','의사인력','01지표'],
    a:['<b>월평균 재원환자수 ÷ 상근 환산 의사 수</b> 입니다. 값이 <b>작을수록</b> 우수합니다.',
       '5점 구간은 <b>26명 미만</b>, 26~30명 4점, 30~34명 3점, 34~38명 2점, 38명 이상 1점(가중치 8.5점).',
       '점수가 낮게 나오면 먼저 <b>의사 재직·근무일수 산정이 정확한지</b> 점검해 보세요. 실제 근무일수가 누락돼 인원이 적게 잡히는 경우가 많습니다.',
       '경계(예: 30명)에 걸쳐 있으면 재원환자수 변동만으로도 구간이 떨어질 수 있어 재원환자 추이에 맞춘 인력관리가 필요합니다.'],
    src:'지표 정의(월간보고서) · 표준화구간표 2주기 6차',
    go:[GO_ASSES], rel:['ind-02','ind-03'] },

  { id:'ind-02', c:'지표', t:'간호사 1인당 환자수 기준이 궁금합니다',
    k:['간호사1인당','간호사수','간호사인력','02지표'],
    a:['<b>월평균 재원환자수 ÷ 간호사 수</b> 이며 값이 <b>작을수록</b> 우수합니다.',
       '5점 <b>6명 미만</b> · 4점 6~9명 · 3점 9~12명 · 2점 12~15명 · 1점 15명 이상 (가중치 8.5점).',
       '간호인력 1인당 환자수(간호사+간호조무사)와는 <b>별개 지표</b>이니 혼동하지 마세요.'],
    src:'지표 정의(월간보고서) · 표준화구간표 2주기 6차',
    go:[GO_ASSES], rel:['ind-03','ind-01'] },

  { id:'ind-03', c:'지표', t:'간호인력 1인당 환자수는 누구를 포함하나요?',
    k:['간호인력','간호조무사','03지표','간호인력1인당'],
    a:['<b>간호사 + 간호조무사 등 간호인력</b> 기준 1인당 환자수입니다. 값이 <b>작을수록</b> 우수합니다.',
       '5점 <b>3명 미만</b> · 4점 3~4명 · 3점 4~5명 · 2점 5~6명 · 1점 6명 이상 (가중치 7.5점).',
       '인력 충원과 함께 <b>근무일수 산정의 정확성</b>을 먼저 점검하시는 것이 빠른 개선 방법입니다.'],
    src:'지표 정의(월간보고서) · 표준화구간표 2주기 6차',
    go:[GO_ASSES], rel:['ind-02','ind-01'] },

  { id:'ind-04', c:'지표', t:'약사 재직일수율은 무엇인가요?',
    k:['약사','재직일수','약사재직','04지표'],
    a:['<b>평가대상기간 중 약사가 재직한 일수의 비율</b>입니다.',
       '5점 <b>100%</b> · 4점 80~100% · 3점 60~80% · 2점 40~60% · 1점 40% 미만 (가중치 5.5점).',
       '재직일 산정 자료(근무일수)가 정확히 반영됐는지 확인해 주세요.'],
    src:'지표 정의(월간보고서) · 표준화구간표 2주기 6차',
    go:[GO_ASSES], rel:['ind-01'] },

  { id:'ind-05', c:'지표', t:'유치도뇨관이 있는 환자분율은 어떻게 산정되나요?',
    k:['유치도뇨관','도뇨관','foley','폴리','유치도뇨','05지표','도뇨관분율'],
    a:['<b>유치도뇨관(Foley)을 보유한 환자 비율</b>이며 값이 <b>낮을수록</b> 우수합니다.',
       '5점 <b>0.5% 미만</b> · 4점 0.5~1.5% · 3점 1.5~2.5% · 2점 2.5~3.5% · 1점 3.5% 이상 (가중치 6점).',
       '개선 방향: 불필요한 유지 여부를 정기적으로 검토해 <b>조기 제거</b>하고, 가능한 경우 간헐적 도뇨(CIC)로 전환합니다.',
       '⚠ 제거하셨으면 <b>평가표에 제거일자를 반드시 입력</b>해 주세요. 제거일자가 비어 있으면 계속 보유로 집계됩니다.'],
    src:'지표 정의·개선방향(월간보고서) · 표준화구간표 2주기 6차',
    go:[GO_ASSES, GO_CHECK], rel:['ind-05-14','pat-cath-out','chk-d'] },

  { id:'ind-05-14', c:'지표', t:'유치도뇨관 14일 초과는 어떤 기준으로 판정하나요?',
    k:['14일초과','14일','연속유지','재삽입','유지기간','도뇨관14'],
    a:['심평원 기준은 <b>통산 일수가 아니라 연속 유지기간</b>입니다.',
       '① 유치도뇨관 삽입 후 <b>월별 유지기간이 14일을 초과</b>하면 분자에 해당합니다.',
       '② <b>제거 당일 또는 다음날 재삽입하면 유지(연속)로 간주</b>합니다. 즉 공백 0~1일은 이어진 것으로 봅니다.',
       '③ 반대로 <b>제거 후 2일 이상 공백</b> 뒤 재삽입하면 연속이 끊기고 새 유지기간으로 다시 셉니다.',
       '판정 기간은 <b>전월 평가표 작성일 다음날 ~ 당월 평가표 작성일</b>이며, 시작일이 입원일자보다 이르면 <b>입원일자</b>부터 셉니다.',
       '예) 5/11~5/22(12일) → 4일 공백 → 5/26~6/07(13일) = 최대 연속 13일 → <b>14일 초과 아님</b>.'],
    src:'심평원 산출식 답변("월별 유지기간 14일 초과" · "당일·다음날 재삽입은 유지 간주") · 사내 산정규칙 문서',
    go:[GO_ASSES], rel:['ind-05','pat-cath-out','chk-d'] },

  { id:'ind-06', c:'지표', t:'배뇨관리 지표는 어떤 경우에 분자로 인정되나요?',
    k:['배뇨관리','배뇨','06지표','배뇨훈련','분자인정','실금'],
    a:['분모는 <b>배뇨조절 저하(자주 실금·조절 못함) 환자</b>이고, 분자는 그중 배뇨관리를 실시한 환자입니다.',
       '분자 인정은 다음 <b>셋 중 하나 이상</b>입니다.',
       '① <b>일정하게 짜여진 배뇨계획</b> + 배뇨일지 <b>3일 이상</b>',
       '② <b>방광훈련프로그램</b> + 배뇨일지 <b>3일 이상</b>',
       '③ <b>규칙적 도뇨</b> (이 항목은 배뇨일지 일수 요건이 없습니다)',
       '의료최고도·배뇨 관련 루(장루 등) 관리 대상자는 제외됩니다.',
       '⚠ 가장 흔한 누락: 배뇨일지는 작성했는데 <b>배뇨계획/방광훈련 항목을 체크하지 않아</b> 분자에서 빠지는 경우입니다.'],
    src:'지표 정의·개선방향(월간보고서) · 배뇨관리 분자 인정 로직',
    go:[GO_ASSES, GO_CHECK], rel:['pat-diary','pat-urmark','chk-h'] },

  { id:'ind-07', c:'지표', t:'항정신성의약품 처방률(PI)은 무엇인가요?',
    k:['항정신성','처방률','pi','07지표','정신과약'],
    a:['상병 구성을 보정한 <b>처방지표(PI)</b>로 산출합니다. 값이 <b>낮을수록</b> 우수합니다.',
       '5점 <b>0.2PI 미만</b> · 3점 0.2~1.6PI · 1점 1.6PI 이상 (가중치 3점).',
       '⚠ 타 기관의 상병 구성·평균 처방률은 확인이 불가하므로, <b>프로그램이 산출한 PI 값은 실제 평가결과와 차이가 있을 수 있습니다</b>. 참고용으로 보시기 바랍니다.',
       '적정성평가 화면에서 항정신성 처방 대상자의 <b>다빈도 상병순위</b>를 함께 확인하실 수 있습니다.'],
    src:'지표 정의(월간보고서) · 표준화구간표 2주기 6차',
    go:[GO_ASSES], rel:['ind-weight'] },

  { id:'ind-08', c:'지표', t:'DUR 점검률은 어디서 확인하나요?',
    k:['dur','점검률','의약품안전사용','08지표','두알'],
    a:['5점 <b>97% 이상</b> · 4점 92~97% · 3점 87~92% · 2점 82~87% · 1점 82% 미만 (가중치 3점).',
       '<b>매월 심사평가원의 DUR 점검 현황을 직접 확인</b>하시고 누락 대상자를 관리하셔야 합니다.',
       '확인경로: <b>요양기관업무포털(biz.hira.or.kr) → 모니터링 → DUR정보 → 기관별 DUR 점검완료현황</b>',
       '점검 결과에 따라 추후 결과 발표 시 점수 차이가 발생할 수 있는 지표입니다.'],
    src:'지표 정의(월간보고서) — DUR 확인경로 포함',
    go:[GO_ASSES], rel:['ind-weight'] },

  { id:'ind-09', c:'지표', t:'욕창 처치를 실시한 환자분율의 처치 인정 기준은?',
    k:['욕창처치','처치율','09지표','욕창처치인정','드레싱','체위변경','영양공급'],
    a:['분모는 <b>전월 욕창(1~4단계) 보유 + 당월 계속입원 평가</b> 대상자이고, 분자는 적절한 처치를 실시한 환자입니다.',
       '처치 4항목: <b>① 압력을 줄여주는 도구(에어매트리스 등) ② 체위변경 ③ 영양·수분 공급 ④ 피부궤양 드레싱</b>',
       '<b>욕창이 유지(2·3·4단계)</b>인 경우 → ①②③④ <b>4가지 모두</b> 필요',
       '<b>1단계 또는 완치</b>인 경우 → 개방창이 없으므로 드레싱 제외, <b>①②③ 3가지 모두</b> 필요',
       '⚠ 가장 흔한 탈락 사유는 <b>영양공급 항목 미체크</b>입니다. 완치·1단계여도 영양이 빠지면 미처치로 집계됩니다.',
       '2단계 이상 압박성 궤양은 <b>염증성 처치(M0121) 청구</b>가 동반돼야 처치 실시로 인정되므로 처치기록과 청구내역을 함께 점검하세요.'],
    src:'욕창 처치율 산정규칙(사내 확정) · 심평원 환자평가표 작성 매뉴얼(1단계=피부 균열 없음)',
    go:[GO_ASSES, GO_CHECK], rel:['pat-press','ind-11','chk-j'] },

  { id:'ind-10', c:'지표', t:'욕창이 새로 생긴 환자분율은 어떻게 보나요?',
    k:['신규욕창','새로생긴','욕창발생','10지표'],
    a:['<b>당월·전월 모두 고위험군</b>인 환자 중 <b>당월에 2단계 이상 욕창이 새로 생긴</b> 환자를 보는 지표입니다.',
       '값이 <b>낮을수록</b> 우수하며 5점 <b>0.25% 미만</b> · 4점 0.25~0.5% · 3점 0.5~0.75% · 2점 0.75~1% · 1점 1% 이상 (가중치 4.4점).',
       '오류점검의 <b>[I] 욕창 발생일 확인</b> 항목으로 발생일 기재 오류를 미리 걸러내실 수 있습니다.'],
    src:'지표 정의(월간보고서) · 표준화구간표 2주기 6차',
    go:[GO_ASSES, GO_CHECK], rel:['ind-11','chk-codes'] },

  { id:'ind-11', c:'지표', t:'욕창 개선 환자분율은 무엇이 개선인가요?',
    k:['욕창개선','11지표','개선환자','호전'],
    a:['<b>2단계 이상 욕창 보유 환자 중 당월 개선된 환자 비율</b>입니다. 개선 = <b>욕창 단계 수가 줄었거나 최고단계가 낮아진</b> 경우.',
       '5점 <b>60% 이상</b> · 4점 45~60% · 3점 30~45% · 2점 15~30% · 1점 15% 미만.',
       '<b>가중치 17.6점으로 전체 지표 중 가장 큽니다</b> — 여기서 한 구간만 올라가도 종합점수가 크게 바뀝니다.',
       '개선 방향: 주차별 창상 사정(PUSH tool 등)과 호전 여부를 <b>평가표에 반드시 기록</b>하세요. 실제 처치는 하는데 <b>개선 기록 누락</b>으로 낮게 산정되는 사례가 가장 많습니다.'],
    src:'지표 정의·개선방향(월간보고서) · 표준화구간표 2주기 6차',
    go:[GO_ASSES], rel:['ind-09','ind-weight'] },

  { id:'ind-12', c:'지표', t:'ADL(일상생활수행능력) 개선 환자분율 기준은?',
    k:['adl','일상생활','12지표','일상생활수행능력','adl개선'],
    a:['<b>입원 시점 대비 재평가에서 일상생활수행능력이 호전된 환자 비율</b>입니다.',
       '5점 <b>45% 이상</b> · 4점 35~45% · 3점 25~35% · 2점 15~25% · 1점 15% 미만 (가중치 12점).',
       '개선 방향: 입원 초기 ADL과 재평가 ADL을 <b>동일한 기준으로</b> 기록해야 호전 건이 정상 반영됩니다.',
       '물리치료·작업치료 실적과 평가표 기록이 연동되는지 점검해 주세요. 오류점검의 <b>[K] ADL 점수 점검</b>도 함께 확인하시면 좋습니다.'],
    src:'지표 정의·개선방향(월간보고서) · 표준화구간표 2주기 6차',
    go:[GO_ASSES, GO_CHECK], rel:['chk-codes','ind-weight'] },

  { id:'ind-13', c:'지표', t:'HbA1c 적정범위 환자분율은 어떻게 되나요?',
    k:['hba1c','당화혈색소','당뇨','13지표','당뇨병'],
    a:['<b>당뇨병 상병 환자 중 HbA1c 검사결과가 적정범위인 환자 비율</b>입니다.',
       '5점 <b>98% 이상</b> · 4점 92~98% · 3점 86~92% · 2점 80~86% · 1점 80% 미만 (가중치 12점).',
       '기준이 98%로 매우 높아 <b>검사결과 미입력·검사일자 오류 몇 건</b>만으로 구간이 떨어집니다.',
       '오류점검의 <b>[M] 검사결과 입력 · [N] 검사일자 확인</b> 항목을 매월 확인해 주세요.'],
    src:'지표 정의(월간보고서) · 표준화구간표 2주기 6차 · 오류점검 코드표',
    go:[GO_ASSES, GO_CHECK], rel:['chk-codes','ind-weight'] },

  { id:'ind-14', c:'지표', t:'장기입원 환자분율을 낮추는 방법이 있나요?',
    k:['장기입원','181일','14지표','장기','입원기간'],
    a:['<b>재원환자 중 181일 이상 장기입원 비율</b>이며 <b>낮을수록</b> 우수합니다. 5점 <b>20% 미만</b> (가중치 5점).',
       '기본 방향은 <b>퇴원계획 수립과 지역연계(재가·시설) 강화</b>입니다.',
       '⚠ 실무 팁: <b>의료경도 또는 선택입원군</b> 대상자가 1개월 이상 <b>의료중도 이상</b>으로 산정되면 장기입원환자분율의 <b>분모·분자에서 제외</b>되어 점수 향상이 가능합니다. 환자군 변동 여부를 지속적으로 확인·관리하세요.'],
    src:'지표 정의·개선방향(월간보고서) · 표준화구간표 2주기 6차',
    go:[GO_ASSES], rel:['ind-15','pat-class'] },

  { id:'ind-15', c:'지표', t:'지역사회 복귀율은 무엇인가요?',
    k:['지역사회','복귀율','15지표','퇴원','가정복귀'],
    a:['<b>퇴원 환자 중 지역사회(가정 등)로 복귀한 비율</b>이며 <b>높을수록</b> 우수합니다.',
       '5점 <b>70% 이상</b> · 4점 55~70% · 3점 40~55% · 2점 25~40% · 1점 25% 미만 (가중치 5점).',
       '퇴원 후 재가·시설 연계 실적을 <b>정확히 기록·관리</b>하는 것이 핵심입니다.',
       '※ 최종 점수 산출 시 DUR 점검율·장기입원환자분율과 함께 현황값 변동에 따라 종합점수에 영향이 생길 수 있는 지표입니다.'],
    src:'지표 정의·개선방향(월간보고서) · 표준화구간표 2주기 6차',
    go:[GO_ASSES], rel:['ind-14'] },

  /* ───────── 환자평가표 작성 ───────── */
  { id:'pat-evaltype', c:'평가표', t:'평가구분 1·2·3은 각각 무슨 뜻인가요?',
    k:['평가구분','evaltype','입원평가','계속입원','이전평가표','1234구분'],
    a:['<b>1 · 입원 평가</b> — 입원 시점에 실시하는 평가',
       '<b>2 · 계속 입원 중인 환자 평가</b> — 이미 입원 중인 환자의 정기 평가',
       '<b>3 · 이전 환자평가표를 적용하는 경우</b>',
       '⚠ 자주 나는 오류 두 가지입니다.',
       '· <b>당월 입원환자가 아닌데 입원평가(1)로 체크</b>한 경우',
       '· <b>당월에 이미 입원평가가 있는데 또 입원평가로 체크</b>한 경우',
       '오류점검 화면의 <b>[A] 평가구분</b> 코드로 확인하실 수 있습니다.'],
    src:'심평원 환자평가표 명세서식(2024.7.1.~) · 오류점검 코드 A 분류',
    go:[GO_CHECK, GO_ASSES], rel:['chk-codes','pat-docdt'] },

  { id:'pat-docdt', c:'평가표', t:'평가표 작성일이 왜 중요한가요?',
    k:['작성일','docdt','평가표작성일','작성일자','기준일'],
    a:['작성일은 <b>어느 달 평가에 반영되는지</b>를 가르는 기준입니다.',
       '유치도뇨관 등의 점검은 <b>전월 평가표 작성일 다음날 ~ 당월 평가표 작성일</b> 구간만 검증합니다.',
       '즉 <b>당월 작성일 이후에 발생한 오더</b>는 다음 달 평가에서 반영되므로 이번 달 오류로 잡지 않습니다.',
       '반대로 <b>전월 작성일 이전 오더</b>는 전월 평가에서 반영됐어야 하는 건이라 역시 제외됩니다.',
       '작성일이 잘못 들어가면 정상 건이 오류로 잡히거나 실제 오류가 누락되니 <b>[B] 작성일자</b> 점검을 함께 확인해 주세요.'],
    src:'유치도뇨관 크로스체크 검증기간 규칙 · 오류점검 코드 B 분류',
    go:[GO_CHECK], rel:['chk-d','pat-evaltype'] },

  { id:'pat-diary', c:'평가표', t:'배뇨일지는 며칠을 작성해야 하나요?',
    k:['배뇨일지','일지','7일','3일','일지작성','배뇨일지작성'],
    a:['분자 인정 기준은 <b>배뇨일지 3일 이상</b> + 배뇨계획 또는 방광훈련 체크입니다.',
       '<b>7일 미만</b>으로 작성한 경우에는 <b>\'아니오\'로 체크한 뒤 실제 작성일수를 기재</b>해 주세요.',
       '배뇨일지에는 <b>실시일자 · 요실금 여부 · 배뇨횟수(또는 배뇨량 mL)</b>가 반드시 포함돼야 하며, 의사·간호기록과 일치해야 합니다.',
       '<b>규칙적 도뇨</b>를 실시하는 환자는 일지 일수 요건 없이 인정됩니다.'],
    src:'배뇨관리 지표 개선방향(월간보고서) · 배뇨관리 분자 인정 로직',
    go:[GO_ASSES], rel:['ind-06','pat-urmark','chk-h'] },

  { id:'pat-urmark', c:'평가표', t:'배뇨관리 화면의 ●, ○, 빈칸 표시는 무슨 뜻인가요?',
    k:['동그라미','●','○','관리항목','표시','마크','빈칸'],
    a:['적정성평가 배뇨관리(06) 그리드의 관리항목 표시입니다.',
       '<b>● (채운 원)</b> — 항목을 체크했고 배뇨일지도 <b>3일 이상</b> = <b>분자 인정</b>',
       '<b>○ (빈 원)</b> — ① 체크는 했으나 일지가 3일 미만(1~2일·미기재) 이거나 ② 일지는 있는데 배뇨계획·방광훈련 <b>둘 다 미체크</b>(체크 누락 의심)',
       '<b>빈칸</b> — 일지도 없고 체크도 없는, 관리가 이뤄지지 않은 환자',
       '<b>규칙적 도뇨</b>는 일수 요건이 없어 체크만 있으면 ● 로 표시됩니다.',
       '○ 로 표시된 환자부터 확인하시면 <b>점수를 놓치고 있는 대상자</b>를 빠르게 찾을 수 있습니다.'],
    src:'적정성평가 06.배뇨관리 관리항목 3단계 표시 규칙',
    go:[GO_ASSES], rel:['ind-06','pat-diary'] },

  { id:'pat-cath-out', c:'평가표', t:'유치도뇨관 삽입·제거일자는 어떻게 입력하나요?',
    k:['삽입일자','제거일자','캣인','cat_in','도뇨관입력','제거일'],
    a:['삽입/제거일자는 <b>최대 10쌍</b>까지 입력할 수 있고 형식은 <b>YYYYMMDD</b>, 공란은 <b>00000000</b> 입니다.',
       '⚠ 제거하셨는데 <b>제거일자를 비워 두면 계속 보유</b>로 집계되어 지표가 나빠집니다.',
       '재삽입한 경우 <b>새 쌍(다음 회차)에 삽입일자</b>를 넣어 주세요. 앞 회차 제거일자를 지우고 덮어쓰면 유지기간이 잘못 계산됩니다.',
       '같은 환자·같은 달에 <b>평가표가 2건 이상</b> 있으면 계산이 중복되어 이상한 값(음수 공백일 등)이 나오므로 중복 평가표는 정리해 주세요.'],
    src:'환자평가표 삽입/제거일자 항목 규격 · 유치도뇨관 산정규칙 문서',
    go:[GO_ASSES, GO_CHECK], rel:['ind-05-14','chk-d'] },

  { id:'pat-press', c:'평가표', t:'욕창 처치 항목은 무엇을 체크해야 하나요?',
    k:['욕창체크','처치항목','압력도구','에어매트','영양','피부궤양','드레싱체크'],
    a:['평가표의 욕창(피부문제) 처치 4항목입니다.',
       '<b>① 압력을 줄여주는 도구 사용</b> — 에어매트리스·에어쿠션·물침대',
       '<b>② 체위변경</b> — 2시간마다, <b>간호사가 직접 또는 주도</b>한 경우만 인정',
       '<b>③ 피부문제 해결을 위한 영양·수분 공급</b> — 의사 처방에 따른 적절한 영양·고단백 치료',
       '<b>④ 피부궤양 드레싱</b> — 실시한 경우에 표시',
       '⚠ 실제로는 영양공급을 하고 있는데 <b>③ 항목만 체크가 빠져</b> 미처치로 집계되는 사례가 매우 많습니다. 체중 대비 필요열량 이상으로 영양이 공급된 대상자가 있으면 항목을 보완해 주세요.'],
    src:'욕창 처치율 산정규칙(사내 확정) · 지표 개선방향(월간보고서)',
    go:[GO_ASSES], rel:['ind-09','ind-11','chk-j'] },

  { id:'pat-class', c:'평가표', t:'환자군 분류가 지표에 영향을 주나요?',
    k:['환자군','patclass','의료최고도','의료중도','선택입원군','분류'],
    a:['네, 여러 지표의 <b>분모 대상 판정</b>에 직접 영향을 줍니다.',
       '<b>장기입원환자분율</b> — 의료경도·선택입원군 대상자가 1개월 이상 <b>의료중도 이상</b>으로 산정되면 분모·분자에서 제외되어 점수가 올라갈 수 있습니다.',
       '<b>배뇨관리</b> — 의료최고도, 배뇨 관련 루 관리 대상자는 제외됩니다.',
       '오류점검의 <b>[C] 환자군 분류</b> 항목에서 분류 오류를 확인하실 수 있습니다.'],
    src:'지표 개선방향(월간보고서) · 배뇨관리 제외 조건 · 오류점검 코드 C 분류',
    go:[GO_CHECK, GO_ASSES], rel:['ind-14','ind-06','chk-codes'] },

  { id:'pat-view', c:'평가표', t:'환자별 평가표 원본을 화면에서 볼 수 있나요?',
    k:['평가표조회','원본보기','환자평가표조회','평가표보기'],
    a:['볼 수 있습니다. 적정성평가 화면에서 대상자 목록을 조회하면 상단 버튼 영역에 <b>[환자평가표 조회]</b> 버튼이 표시됩니다.',
       '해당 환자의 평가표 항목값을 그대로 확인할 수 있어, 지표에서 왜 빠졌는지 원인을 바로 찾으실 때 유용합니다.'],
    src:'적정성평가 화면 환자평가표 조회 기능',
    go:[GO_ASSES], rel:['chk-codes'] },

  /* ───────── 청구명세서 · 자료 올리기 ───────── */
  { id:'up-what', c:'청구', t:'매월 무슨 파일을 올려야 하나요?',
    k:['업로드','올리기','파일','샘파일','청구파일','자료올리기','뭘올려'],
    a:['<b>청구·평가 업로드</b> 화면에서 월별로 두 가지를 올리십니다.',
       '<b>① 청구샘파일</b> — 청구 프로그램에서 생성된 명세서 자료(GHP·CAR·REP 계열 또는 C/M/K/D/H 계열 파일 세트)',
       '<b>② 환자평가표</b> — 적정성평가 지표 산출의 기준 자료',
       '올리신 뒤 <b>적정성평가 화면에서 「월 자료생성」</b>을 실행해야 지표 점수가 만들어집니다. 업로드만으로는 점수가 갱신되지 않습니다.',
       '심평원에 제출한 뒤의 파일은 암호화되어 사용이 어려우므로 <b>제출 전 원본</b>을 올려 주세요.'],
    src:'청구·평가 업로드 화면 사용 흐름',
    go:[GO_UPLOAD, GO_ASSES], rel:['up-ver','use-create'] },

  { id:'up-ver', c:'청구', t:'샘파일 버전은 어떻게 확인·매칭되나요?',
    k:['버전','samfver','버전매칭','h010','파일버전','버전오류'],
    a:['파일 유형에 따라 버전을 읽는 위치가 다릅니다.',
       '<b>확장자 파일(GHP·CAR·REP 계열)</b> — 그 파일 <b>첫 줄 앞 3자리</b>가 버전',
       '<b>C/M 계열 파일 세트</b> — 파일명이 <b>가장 작은 파일</b>(예 M010.1)의 첫 줄 앞 3자리',
       '<b>K/D/H 계열 파일 세트</b> — 함께 선택되는 <b>H010</b> 파일의 첫 줄 앞 3자리',
       '버전+길이가 모두 맞으면 정상, 길이만 다르면 <b>길이오류</b>로 표시됩니다. 이 경우 청구 프로그램의 샘파일 생성 버전을 확인해 주세요.'],
    src:'파일 검증 · 버전 매칭 규칙(사내 문서)',
    go:[GO_UPLOAD], rel:['up-what','up-err'] },

  { id:'up-err', c:'청구', t:'업로드 중 오류번호(90000·45000·30000)가 떴습니다',
    k:['90000','45000','30000','업로드오류','업로드실패','오류번호','실패'],
    a:['현재 버전에서는 대부분 해결된 항목이지만, 다시 발생하면 아래를 확인해 주세요.',
       '<b>공통</b> — 같은 파일을 다시 올려 보시고, 그래도 같은 번호가 나오면 <b>파일명·월·오류번호</b>를 1:1 문의로 알려주세요. 서버 로그로 정확한 원인을 확인해 드립니다.',
       '<b>90000</b> — 대용량 파일(수만 줄) 적재 중 발생했던 오류로, 배치 적재 방식으로 개선됐습니다.',
       '<b>45000</b> — 파일 내용 처리 중 발생하던 오류로, 처리 프로시저 수정으로 해결됐습니다.',
       '⚠ 오류가 나면 <b>해당 월 자료가 부분만 올라간 상태</b>일 수 있으니, 원인 해결 후 <b>다시 업로드 → 자료생성</b> 순서로 진행해 주세요.'],
    src:'샘파일 업로드 처리 개선 이력(대용량 배치 적재 · 프로시저 수정)',
    go:[GO_UPLOAD, GO_ASQ], rel:['up-time','use-ask'] },

  { id:'up-time', c:'청구', t:'업로드가 너무 오래 걸립니다',
    k:['느림','느려','늦어','오래걸','한참걸','시간','속도','업로드시간','한참','진행바','멈춰'],
    a:['처리 속도는 개선된 상태입니다. 참고 기준은 다음과 같습니다.',
       '<b>1만 7천 줄 규모 청구파일</b> — 약 10초 내외',
       '<b>환자평가표(수백 줄)</b> — 약 2초 내외',
       '이보다 현저히 오래 걸리거나 진행바가 100%에서 멈춘 채 끝나지 않으면, <b>파일명·줄 수·시간대</b>를 1:1 문의로 알려주세요.',
       '업로드 중에는 창을 닫지 마시고 완료 메시지를 확인해 주세요.'],
    src:'샘파일 업로드 처리속도 개선 측정값',
    go:[GO_UPLOAD, GO_ASQ], rel:['up-err'] },

  { id:'up-pick', c:'청구', t:'파일선택과 폴더선택은 어떻게 다른가요?',
    k:['폴더선택','파일선택','폴더','트리','골라서'],
    a:['<b>파일선택</b> — 올릴 파일을 직접 하나씩 고릅니다.',
       '<b>폴더선택</b> — 폴더를 통째로 지정하면 그 안의 파일이 <b>트리와 체크박스</b>로 표시되어, 필요한 청구파일만 골라 올릴 수 있습니다.',
       '어느 방식이든 업로드 처리 결과는 같습니다. 파일이 여러 세트로 나뉜 C/M/K/D/H 계열은 폴더선택이 편합니다.'],
    src:'청구·평가 업로드 화면 폴더선택(트리) 기능',
    go:[GO_UPLOAD], rel:['up-what','up-ver'] },

  { id:'up-close', c:'청구', t:'월 카드의 잠김/열림 표시는 무슨 뜻인가요?',
    k:['잠김','열림','마감','자물쇠','월마감','마감완료'],
    a:['업로드 화면의 월 카드에 표시되는 <b>마감 상태</b>입니다.',
       '<b>마감완료(잠김)</b> — 해당 월 자료가 확정된 상태입니다. 자료를 다시 올리시려면 잠금을 여신 뒤 진행하셔야 합니다.',
       '<b>열림</b> — 업로드·수정이 가능한 상태입니다.',
       '마감된 월의 자료를 다시 올리면 <b>지표 점수가 바뀔 수 있으니</b>, 이미 보고서를 발송한 월이라면 담당자와 확인 후 진행해 주세요.'],
    src:'청구·평가 업로드 화면 월별 마감 상태 표시',
    go:[GO_UPLOAD], rel:['up-what','use-create'] },

  /* ───────── 오류점검 ───────── */
  { id:'chk-codes', c:'점검', t:'오류점검 코드(A~N)는 각각 무슨 뜻인가요?',
    k:['오류코드','errtype','a1','b1','c1','코드표','점검코드','점검항목'],
    a:['오류점검 화면의 코드 첫 글자가 점검 영역을 뜻합니다.',
       '<b>A</b> 평가구분 · <b>B</b> 작성일자 · <b>C</b> 환자군 분류',
       '<b>D</b> 삽입일자 · <b>E</b> 제거일자 · <b>F</b> 삽입기간 · <b>G</b> 삽입·제거일자 <span style="color:#8494a8">(유치도뇨관)</span>',
       '<b>H1</b> 소변조절못함 · <b>H2</b> 기저귀사용 · <b>H3</b> 배뇨계획',
       '<b>I</b> 욕창 발생일 확인 · <b>J</b> 욕창 과거력·처치 확인',
       '<b>K</b> ADL 점수 점검 · <b>L</b> 행동증상 점검',
       '<b>M</b> 검사결과 입력 · <b>N</b> 검사일자 확인 <span style="color:#8494a8">(당뇨)</span>',
       '목록에서 코드에 마우스를 올리시면 상세 설명이 표시됩니다.'],
    src:'오류점검 화면 코드 분류표',
    go:[GO_CHECK], rel:['chk-h','chk-d','chk-j'] },

  { id:'chk-h', c:'점검', t:'H3(배뇨계획) 오류는 왜 뜨나요?',
    k:['h3','h1','h2','배뇨계획오류','소변조절','기저귀'],
    a:['<b>H3</b> 은 <b>배뇨일지는 작성했는데 배뇨훈련 프로그램이 체크되지 않아</b> 분자에서 빠질 우려가 있는 대상자입니다.',
       '즉 실제로는 관리하고 계신데 <b>항목 체크만 빠져 점수를 놓치는</b> 경우를 미리 잡아 주는 점검입니다.',
       '<b>규칙적 도뇨</b>를 체크하신 환자는 일수 요건 없이 인정되므로 H3 대상에서 제외됩니다.',
       '<b>H1</b>(소변조절못함) · <b>H2</b>(기저귀사용)는 배뇨 관련 항목 간 기재가 서로 맞는지 확인하는 점검입니다.'],
    src:'오류점검 배뇨 관련 점검 조건(H1·H2·H3)',
    go:[GO_CHECK, GO_ASSES], rel:['ind-06','pat-diary','chk-codes'] },

  { id:'chk-d', c:'점검', t:'유치도뇨관 오더와 평가표 크로스체크는 어떤 기준인가요?',
    k:['크로스체크','오더','d3','d4','d6','m0060','수가','오더대조'],
    a:['수가 오더(M0060)와 평가표 기재를 대조해 다음을 잡아냅니다.',
       '<b>D3</b> 오더는 있는데 평가표에 기재가 없음 · <b>D4</b> 오더 삽입일과 평가표 개시일이 다름 · <b>D6</b> 평가표에는 있는데 해당 오더가 없음',
       '검증 기간은 <b>전월 평가표 작성일 다음날 ~ 당월 평가표 작성일</b> 입니다.',
       '따라서 <b>당월 작성일 이후 오더</b>(다음 달 평가 반영분)와 <b>전월 작성일 이전 오더</b>(전월 평가 반영분)는 오류로 잡지 않습니다.',
       '<b>당월 평가표가 아예 없는 환자</b>는 수가가 있어도 점검 대상에서 제외됩니다.',
       '목록에서 행을 클릭하시면 우측에 그 환자의 <b>수가 오더 내역</b>이 표시됩니다.'],
    src:'유치도뇨관 크로스체크 검증기간 규칙(작성일 기준) · 오류점검 D 블록',
    go:[GO_CHECK], rel:['pat-docdt','ind-05','chk-codes'] },

  { id:'chk-j', c:'점검', t:'J(욕창처치 확인) 오류는 무엇을 보라는 뜻인가요?',
    k:['j1','j2','j3','j4','j5','욕창과거력','욕창점검','욕창오류'],
    a:['<b>J1</b> 은 <b>욕창 과거력</b> 기재 확인, <b>J2~J5</b> 는 <b>욕창처치 기재</b> 확인입니다.',
       '처치는 하고 있으나 <b>평가표 항목(압력도구·체위변경·영양공급·드레싱) 체크가 빠진</b> 경우를 잡아내는 점검입니다.',
       '특히 <b>영양공급 미체크</b>가 가장 흔하니 이 항목부터 확인해 주세요.',
       '2단계 이상 압박성 궤양은 <b>염증성 처치(M0121) 청구</b>가 동반돼야 처치로 인정되므로 청구내역도 함께 보셔야 합니다.'],
    src:'오류점검 욕창 관련 점검(J 블록) · 욕창 처치율 산정규칙',
    go:[GO_CHECK, GO_ASSES], rel:['ind-09','pat-press','chk-codes'] },

  { id:'chk-how', c:'점검', t:'오류점검은 언제, 어떻게 돌리나요?',
    k:['오류점검','점검하기','언제','점검방법','오류확인'],
    a:['순서는 <b>① 청구·평가 업로드 → ② 적정성평가 「월 자료생성」 → ③ 오류점검</b> 입니다.',
       '오류점검 화면에서 월을 선택하고 조회하면 대상자별 <b>코드·점검내용·상세내용</b>이 표로 나옵니다.',
       '표시되는 항목은 <b>확정된 오류가 아니라 확인이 필요한 건</b>입니다. 실제 기록과 대조해 판단하신 뒤 평가표를 보완해 주세요.',
       '평가표를 수정하신 뒤에는 <b>자료생성을 다시 실행</b>해야 지표 점수에 반영됩니다.'],
    src:'오류점검 화면 사용 흐름',
    go:[GO_CHECK, GO_ASSES], rel:['use-create','chk-codes'] },

  /* ───────── 프로그램 사용법 ───────── */
  { id:'use-create', c:'사용법', t:'평가표를 고쳤는데 점수가 그대로입니다',
    k:['점수안바뀜','안바뀜','안바뀌','안바뀝','반영안됨','자료생성','재생성','그대로','갱신','안변함',
       '고쳤는데','수정했는데','수정해도','재실행','다시생성','점수변화없','저장했는데'],
    a:['좌측 <b>지표 분모/분자·점수는 「월 자료생성」을 실행한 시점에 저장된 값</b>입니다. 평가표만 고치면 화면 숫자는 바뀌지 않습니다.',
       '<b>적정성평가 화면에서 해당 월 「자료생성」을 다시 실행</b>해 주세요. 그러면 점수가 새로 계산됩니다.',
       '반면 <b>우측 대상자 목록(그리드)</b>은 조회할 때마다 실시간으로 읽으므로 수정 즉시 반영됩니다.',
       '👉 좌측 점수와 우측 목록이 서로 안 맞으면 <b>대부분 자료생성을 다시 안 하신 경우</b>입니다.'],
    src:'지표 점수 저장 방식(자료생성 시점 저장) — 산정규칙 문서 공통 주의사항',
    go:[GO_ASSES], rel:['chk-how','up-what'] },

  { id:'use-sim', c:'사용법', t:'5점까지 몇 명이 더 필요한지 볼 수 있나요?',
    k:['시뮬레이션','몇명','5점도달','필요인원','병원검색','목표'],
    a:['볼 수 있습니다. <b>병원검색(시뮬레이션)</b> 화면과 적정성평가 지표 요약에서 확인하십니다.',
       '지표별로 <b>5점 구간에 해당하는 인원 범위</b>와 <b>5점 도달까지 추가/감소가 필요한 인원</b>이 표시됩니다.',
       '가중치가 큰 <b>욕창개선(17.6) · ADL개선(12) · HbA1c(12)</b> 부터 보시면 같은 노력으로 종합점수를 가장 많이 올릴 수 있습니다.',
       '월간보고서에도 개선 시 예상되는 <b>종합점수 상승폭</b>이 함께 정리됩니다.'],
    src:'적정성평가·시뮬레이션 5점 구간 환산 기능 · 월간보고서 개선 시나리오',
    go:[GO_SIM, GO_ASSES], rel:['ind-score','use-report'] },

  { id:'use-report', c:'사용법', t:'월간보고서는 어떻게 만들고 내보내나요?',
    k:['월간보고서','보고서','pdf','승인','보고서출력','컨설팅보고서'],
    a:['<b>월간보고서</b> 메뉴에서 병원·월을 선택해 보고서를 여십니다.',
       '표지·총평·지표별 분석·권고 등 <b>편집영역</b>은 화면에서 직접 수정하고 저장하실 수 있습니다.',
       '<b>승인</b>하시면 곧바로 PDF가 생성되고 미리보기가 열립니다. 미리보기에서 <b>[파일서버 저장]</b> 또는 <b>[닫기]</b>로 저장 여부를 결정하시면 됩니다.',
       'PDF는 <b>구조지표·과정지표·결과지표 그룹별로 페이지가 나뉘어</b> 출력됩니다.',
       '목표점수·목표등급은 차등제 등록값을 따라가므로, 값이 다르면 차등제 등록을 먼저 수정해 주세요.'],
    src:'월간보고서 승인·PDF 생성 흐름',
    go:[GO_REPORT], rel:['ind-goal','use-sim'] },

  { id:'use-range', c:'사용법', t:'표준화구간표를 화면에서 볼 수 있나요?',
    k:['표준화구간표','구간표보기','기준표','구간버튼'],
    a:['적정성평가 화면 상단의 <b>[표준화구간]</b> 버튼을 누르시면 <b>지표별 표준화 점수구간·가중치표</b>가 팝업으로 열립니다.',
       '구분(구조·과정·결과) · 지표 · 가중치 · 표준화구간(5~1) · 산출점수가 한 표에 정리돼 있습니다.'],
    src:'적정성평가 화면 표준화구간 조회 팝업',
    go:[GO_ASSES], rel:['ind-weight','ind-score'] },

  { id:'use-ask', c:'사용법', t:'여기서 답을 못 찾으면 어떻게 문의하나요?',
    k:['문의','1:1','상담','전화','도움','문의하기','담당자'],
    a:['<b>1:1 문의하기</b>에 남겨 주시면 위너넷 담당자가 확인 후 답변드립니다. 답변이 등록되면 로그인 시 알림으로 표시됩니다.',
       '문의하실 때 <b>병원명 · 대상 월 · 환자(생년월일) · 화면명 · 오류메시지</b>를 함께 적어 주시면 훨씬 빠르게 확인됩니다.',
       '<b>자주하는 질문</b>에도 그동안 등록된 답변이 정리돼 있습니다.',
       '화면을 함께 보며 확인이 필요하면 <b>원격지원상담</b>을 이용하실 수 있습니다.'],
    src:'고객지원 메뉴(1:1 문의·자주하는 질문·원격지원상담)',
    go:[GO_ASQ, GO_FAQ], rel:['chk-how'] }
  ];

  /* ── 질문 유형(분류) ──────────────────────────────────────
       타이핑보다 <유형을 골라 누르는> 쪽이 실제 사용에 유용하다(2026-07-29 사용자 요청).
       분류를 누르면 그 분류의 질문이 전부 버튼으로 깔리고, 누르면 바로 답이 나온다.
       분류 키는 지식카드의 c 값과 같다 — 카드를 추가하면 자동으로 목록에 들어온다.          */
  var CATS = [
    { k:'지표',   n:'지표·평가기준' },
    { k:'평가표', n:'환자평가표 작성' },
    { k:'청구',   n:'청구·업로드' },
    { k:'점검',   n:'오류점검' },
    { k:'사용법', n:'프로그램 사용법' }
  ];
  var CAT_CUR = '지표';

  /* ── 검색 엔진 ────────────────────────────────────────
       외부 형태소 분석기가 없으므로 (1) 동의어 키워드 포함 여부 (2) 글자 2-gram 겹침 으로 점수를 매긴다.
       한국어 조사·띄어쓰기 편차에 비교적 강하다.                                        */
  function norm(s){ return String(s==null?'':s).toLowerCase().replace(/[\s,.?!·\-_()\[\]{}'"~:;/]/g, ''); }
  function grams(s){ var a=[],i; for(i=0;i<s.length-1;i++) a.push(s.substr(i,2)); return a; }
  function overlap(qa, ta){
    if(!qa.length || !ta.length) return 0;
    var m={}, i, hit=0;
    for(i=0;i<ta.length;i++) m[ta[i]]=1;
    for(i=0;i<qa.length;i++) if(m[qa[i]]) hit++;
    return hit / qa.length;
  }
  function score(q, e){
    var nq = norm(q), s = 0, i, k;
    if(!nq) return 0;
    for(i=0;i<e.k.length;i++){
      k = norm(e.k[i]);
      if(!k) continue;
      if(nq.indexOf(k) >= 0) s += (k.length >= 3 ? 6 : 4);          // 질문 안에 키워드가 들어 있음
      else if(k.indexOf(nq) >= 0 && nq.length >= 2) s += 3;          // 키워드 앞부분만 친 경우
    }
    s += overlap(grams(nq), grams(norm(e.t))) * 7;                   // 대표질문과 글자 겹침
    s += overlap(grams(nq), grams(norm(e.a.join('')))) * 2;          // 답변 본문 겹침(보조)
    return s;
  }
  function search(q){
    var r = [], i, sc;
    for(i=0;i<WQA_KB.length;i++){
      sc = score(q, WQA_KB[i]);
      if(sc > 0) r.push({ e:WQA_KB[i], s:sc });
    }
    r.sort(function(a,b){ return b.s - a.s; });
    return r;
  }
  function byId(id){ for(var i=0;i<WQA_KB.length;i++) if(WQA_KB[i].id===id) return WQA_KB[i]; return null; }

  /* ── 렌더 ── */
  function esc(s){ return String(s==null?'':s).replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;'); }
  var log = function(){ return document.getElementById('wqaLog'); };

  /* ★대화 구조 (2026-07-29 사용자 확정)
       답변이 세부적이라 그대로 쌓으면 화면이 길어져 방금 물어본 답을 찾기 어렵다.
       → <최신 문답 1건은 펼침 + 이전 질문은 한 줄로 접기>. 접힌 줄을 누르면 그 답변이 다시 펼쳐진다.
       HIST = [{q:질문, a:답변HTML, o:펼침여부}] · 최대 MAX_HIST 건까지만 보관(오래된 것부터 버림). */
  var HIST = [], MAX_HIST = 12;

  function greetHtml(){
    return '<div class="wqa-row"><div class="wqa-bub">'
      + '안녕하세요! <b>적정성평가</b> 궁금한 점을 질문해 주세요.<br>'
      + '<span style="color:#8494a8;font-size:.87em">아래 버튼을 누르거나 직접 입력하시면 됩니다.</span>'
      + '</div></div>';
  }

  function render(){
    var h = '', i, last = HIST.length - 1;
    if(!HIST.length){ log().innerHTML = greetHtml(); save(); return; }   /* ★save 필수 — 빼면 마지막 1건을 지워도 세션에 남아 되살아난다 */

    for(i=0;i<last;i++){                                  // 이전 질문 — 접힌 한 줄
      h += '<div class="wqa-hist' + (HIST[i].o ? ' op' : '') + '" onclick="wqaTog(' + i + ')">'
         +   '<span class="arw">' + (HIST[i].o ? '▾' : '▸') + '</span>'
         +   '<span class="q">' + esc(HIST[i].q) + '</span>'
         +   '<span class="del" title="이 질문 지우기" onclick="event.stopPropagation();wqaDel(' + i + ')">✕</span>'
         + '</div>';
      if(HIST[i].o) h += '<div class="wqa-row"><div class="wqa-bub">' + HIST[i].a + '</div></div>';
    }
    if(last > 0) h += '<div class="wqa-nowline"><span>최근 질문</span></div>';

    h += '<div class="wqa-row me">'
       +   '<span class="wqa-qdel" title="이 질문 지우기" onclick="wqaDel(' + last + ')">✕</span>'
       +   '<div class="wqa-bub">' + esc(HIST[last].q) + '</div></div>'
       + '<div class="wqa-row" id="wqaLastA"><div class="wqa-bub">' + HIST[last].a + '</div></div>';
    log().innerHTML = h;

    /* 답변이 길어 아래로 붙이면 마지막 줄부터 보인다 → 최신 답변 '첫 줄'이 보이도록 맞춘다 */
    var a = document.getElementById('wqaLastA');
    log().scrollTop = a ? Math.max(0, a.offsetTop - 44) : log().scrollHeight;
    save();
  }

  /* ★이력에 쌓는 것은 <입력창에 직접 쓰고 전송한 질문>뿐이다 (2026-07-29 사용자 확정).
       빠른질문·연관질문 버튼으로 본 것은 그때 화면에만 보이고, 다음 질문을 하면 목록에 남기지 않고 사라진다.
       t:true = 전송으로 물어본 질문 / t:false = 버튼으로 띄운 것                                  */
  function add(q, a, typed){
    HIST = HIST.filter(function(e){ return e.t; });     // 버튼으로 띄웠던 직전 건은 이력에 남기지 않는다
    HIST.push({ q:q, a:a, o:false, t:!!typed });
    while(HIST.length > MAX_HIST) HIST.shift();
    render();
  }

  function cardHtml(e){
    var h = '<span class="cat">' + esc(e.c) + '</span><span class="h">' + esc(e.t) + '</span><ul>';
    for(var i=0;i<e.a.length;i++) h += '<li>' + e.a[i] + '</li>';
    h += '</ul>';
    if(e.src) h += '<div class="wqa-src"><b>근거</b> · ' + esc(e.src) + '</div>';
    if(e.go && e.go.length){
      h += '<div class="wqa-go">';
      for(var g=0;g<e.go.length;g++){
        var fn = e.go[g].s ? 'wqaSupport' : 'wqaGo';
        h += '<a onclick="' + fn + '(\'' + e.go[g].u + '\')">→ ' + esc(e.go[g].n) + '</a>';
      }
      h += '</div>';
    }
    if(e.rel && e.rel.length){
      var rr = '';
      for(var j=0;j<e.rel.length;j++){
        var re = byId(e.rel[j]);
        if(re) rr += '<span onclick="wqaPick(\'' + re.id + '\')">' + esc(re.t) + '</span>';
      }
      if(rr) h += '<div class="wqa-rel">' + rr + '</div>';
    }
    return h;
  }

  /* 질문 → 답변 HTML (화면에 붙이지 않고 문자열만 만든다) */
  function answerHtml(q){
    var r = search(q), top = r.length ? r[0] : null;

    if(top && top.s >= 5.5) return cardHtml(top.e);

    if(r.length && r[0].s >= 2){
      var h = '이 중에 찾으시는 내용이 있으신가요?<div class="wqa-rel">';
      for(var i=0;i<Math.min(3,r.length);i++) h += '<span onclick="wqaPick(\'' + r[i].e.id + '\')">' + esc(r[i].e.t) + '</span>';
      h += '</div>'
         + '<div class="wqa-go"><a onclick="wqaSupport(\'asq\')">→ 찾는 내용이 없으면 1:1 문의하기</a></div>';
      return h;
    }
    /* 답을 못 찾았을 때 — 얼버무리지 말고 <1:1 문의>로 확실히 넘긴다 (2026-07-29 사용자 요청) */
    return ('<span class="h">등록된 내용에서는 답을 찾지 못했습니다</span>'
       + '<ul>'
       + '<li>확실하지 않은 답을 드리지 않기 위해 <b>확인된 내용만</b> 답변드리고 있습니다.</li>'
       + '<li>이 질문은 <b>위너넷 담당자에게 1:1 문의</b>로 남겨 주세요. 근무일 기준 <b>2일 이내</b>에 답변이 등록되고, 등록되면 <b>로그인 시 알림</b>으로 표시됩니다.</li>'
       + '<li>문의 내용에는 <b>방금 하신 질문을 그대로</b> 적으시고 <b>병원명 · 대상 월 · 환자(생년월일) · 화면명 · 오류메시지</b>를 함께 적어 주시면 훨씬 빠르게 확인됩니다.</li>'
       + '</ul>'
       + '<div class="wqa-go"><a class="pri" onclick="wqaSupport(\'asq\')">✉ 1:1 문의하기</a>'
       +                    '<a onclick="wqaSupport(\'faq\')">→ 자주하는 질문 찾아보기</a></div>'
       + '<div class="wqa-src">아래 내용은 바로 답변드릴 수 있습니다 — 필요하시면 눌러 보세요.</div>'
       + '<div class="wqa-rel">'
       + '<span onclick="wqaPick(\'ind-list\')">지표 전체 보기</span>'
       + '<span onclick="wqaPick(\'chk-codes\')">오류점검 코드</span>'
       + '<span onclick="wqaPick(\'use-create\')">점수가 안 바뀔 때</span>'
       + '</div>');
  }

  /* ── 대화 저장(화면을 이동해도 이어짐) ── */
  function save(){
    try{ sessionStorage.setItem('wqaHist', JSON.stringify(HIST)); }catch(ignore){}
  }
  function restore(){
    var v = null;
    try{ v = sessionStorage.getItem('wqaHist'); }catch(ignore){}
    if(v){ try{ HIST = JSON.parse(v) || []; }catch(ignore){ HIST = []; } }
    render();
  }

  /* ── 공개 함수 ── */
  window.wqaOpen = function(){
    document.getElementById('wqaPanel').classList.add('wqa-open');
    document.getElementById('wqaFab').classList.add('wqa-hide');
    try{ sessionStorage.setItem('wqaOpen','1'); }catch(ignore){}
    setTimeout(function(){ var i=document.getElementById('wqaQ'); if(i) i.focus(); }, 60);
  };
  window.wqaClose = function(){
    document.getElementById('wqaPanel').classList.remove('wqa-open');
    document.getElementById('wqaFab').classList.remove('wqa-hide');
    try{ sessionStorage.setItem('wqaOpen','0'); }catch(ignore){}
  };
  /* ── 테두리 드래그로 크기 조절 ────────────────────────────
       패널은 right/bottom 고정이므로 왼쪽으로 끌면 폭이, 위로 끌면 높이가 늘어난다.
       조절값은 인라인 style 로 들어가고 세션에 저장돼 화면을 옮겨도 유지된다.                */
  var RZ_MIN_W = 380, RZ_MIN_H = 420;
  function rzMaxW(){ return window.innerWidth  - 40; }
  function rzMaxH(){ return window.innerHeight - 40; }
  function clamp(v, lo, hi){ return v < lo ? lo : (v > hi ? hi : v); }

  /* ★창 크기와 글자 크기는 서로 무관하다 (2026-07-29 사용자 확정).
       · 창을 넓히면 글자는 그대로 두고 <넓어진 폭만큼 글이 채워진다>(줄바꿈만 달라짐).
       · 글자 크기는 헤더의 가－ / 가＋ 로만 바꾼다.
       (예전엔 폭에 비례해 글자가 커져서, 넓히면 글자만 커지고 담기는 양은 그대로였다) */
  var RZ_BASE_F = 15, RZ_MIN_F = 11, RZ_MAX_F = 30;
  var FZ = 1, FZ_MIN = 0.7, FZ_MAX = 1.8, FZ_STEP = 0.1;

  function applyFont(){
    document.getElementById('wqaPanel').style.fontSize =
      clamp(RZ_BASE_F * FZ, RZ_MIN_F, RZ_MAX_F).toFixed(2) + 'px';
  }
  function applySize(w, h){
    var p = document.getElementById('wqaPanel');
    if(w) p.style.width  = clamp(w, RZ_MIN_W, rzMaxW()) + 'px';
    if(h) p.style.height = clamp(h, RZ_MIN_H, rzMaxH()) + 'px';
  }

  /* 글자 축소(-1)·확대(+1) — 창 크기는 그대로 두고 글자만 조절한다 */
  window.wqaFont = function(d){
    FZ = clamp(Math.round((FZ + d * FZ_STEP) * 10) / 10, FZ_MIN, FZ_MAX);
    applyFont();
    try{ sessionStorage.setItem('wqaFz', String(FZ)); }catch(ignore){}
  };
  /* 창 크기·글자크기를 처음 상태(560×780, 15px)로 되돌린다 */
  window.wqaReset = function(){
    var p = document.getElementById('wqaPanel');
    p.style.width = ''; p.style.height = ''; p.style.fontSize = '';
    FZ = 1;
    try{ sessionStorage.removeItem('wqaSize'); sessionStorage.removeItem('wqaFz'); }catch(ignore){}
  };
  function bindResize(el, useW, useH){
    if(!el) return;
    el.addEventListener('mousedown', function(ev){
      ev.preventDefault();
      var p = document.getElementById('wqaPanel'), r = p.getBoundingClientRect();
      var sx = ev.clientX, sy = ev.clientY, sw = r.width, sh = r.height;
      p.classList.add('wqa-rzing');
      function mv(e){
        applySize(useW ? sw + (sx - e.clientX) : 0,
                  useH ? sh + (sy - e.clientY) : 0);
      }
      function up(){
        document.removeEventListener('mousemove', mv);
        document.removeEventListener('mouseup', up);
        p.classList.remove('wqa-rzing');
        var rr = p.getBoundingClientRect();
        try{ sessionStorage.setItem('wqaSize', Math.round(rr.width) + ',' + Math.round(rr.height)); }catch(ignore){}
      }
      document.addEventListener('mousemove', mv);
      document.addEventListener('mouseup', up);
    });
  }
  function restoreSize(){
    var v = null, f = null;
    try{ v = sessionStorage.getItem('wqaSize'); f = sessionStorage.getItem('wqaFz'); }catch(ignore){}
    if(f){ FZ = clamp(parseFloat(f) || 1, FZ_MIN, FZ_MAX); applyFont(); }   // 글자배율은 창 크기와 별개로 복원
    if(v){ var a = v.split(','); applySize(parseInt(a[0],10), parseInt(a[1],10)); }
  }
  window.wqaClear = function(){
    HIST = [];
    try{ sessionStorage.removeItem('wqaHist'); }catch(ignore){}
    render();
  };
  window.wqaTog = function(i){                 // 접힌 이전 질문 펼치기/접기
    if(!HIST[i]) return;
    HIST[i].o = !HIST[i].o;
    render();
  };
  window.wqaDel = function(i){                 // 그 질문 1건만 지우기(✕)
    if(!HIST[i]) return;
    HIST.splice(i, 1);
    render();                                  // 마지막 1건을 지우면 인사말로 돌아간다
  };
  window.wqaSend = function(){
    var i = document.getElementById('wqaQ'), q = i.value.replace(/^\s+|\s+$/g,'');
    if(!q) return;
    i.value = '';
    add(q, answerHtml(q), true);                 // 전송 = 이력에 남는다
  };
  window.wqaAsk = function(q){ add(q, answerHtml(q), false); };      // 빠른질문 버튼 = 안 남는다
  window.wqaPick = function(id){
    var e = byId(id);
    if(!e) return;
    add(e.t, cardHtml(e), false);                                   // 연관질문 버튼 = 안 남는다
  };
  window.wqaGo = function(u){ location.href = u; };

  /* 고객지원 연결 — 사이드바의 [1:1 문의하기]/[자주하는 질문] 버튼과 동일하게 모달을 띄운다.
     · asq → fnasq_main()  (sidebar.jsp #asq_main_tab 모달)
     · faq → loadFaqData() (sidebar.jsp #faqModal 모달)
       ★검색어를 넘기지 않는다 — loadFaqData(keyword) 는 질문내용 LIKE 검색이라
         "…어떻게 문의하나요" 같은 문장을 넘기면 걸리는 게 없어 목록이 빈 채로 열린다(2026-07-29 확인).
         사이드바 버튼과 똑같이 전체 목록을 띄우고, 검색은 모달 안에서 하시게 둔다.
     함수를 못 찾으면(구버전 화면 등) 해당 화면으로 이동해 동작이 끊기지 않게 한다. */
  /* ★모달을 띄울 때 챗을 <닫지> 않는다 — 잠깐 감췄다가 모달을 닫으면 보던 대화 그대로 되살린다.
       (챗 패널 z-index 가 모달보다 높아 그냥 두면 모달을 덮는다. 예전엔 wqaClose() 로 닫아버려
        문의 버튼만 누르면 대화가 사라졌다 — 2026-07-29 사용자 보고)                            */
  function withModal(sel, fn){
    var p = document.getElementById('wqaPanel'), back = function(){ p.style.display = ''; };
    p.style.display = 'none';
    try{ fn(); }catch(err){ back(); throw err; }
    try{
      if(window.jQuery) window.jQuery(sel).off('hidden.bs.modal.wqa').one('hidden.bs.modal.wqa', back);
      else setTimeout(back, 400);
    }catch(ignore){ setTimeout(back, 400); }
  }
  window.wqaSupport = function(kind){
    try{
      if(kind === 'asq' && typeof window.fnasq_main === 'function'){ withModal('#asq_main_tab', window.fnasq_main); return; }
      if(kind === 'faq' && typeof window.loadFaqData === 'function'){ withModal('#faqModal', window.loadFaqData); return; }
    }catch(ignore){}
    location.href = (kind === 'asq') ? '/mangr/asqcd.do' : '/mangr/faqcd.do';
  };

  /* ── 질문 유형 렌더 ──
       위: 분류 버튼(건수 표시) / 아래: 그 분류의 질문 버튼. 질문을 누르면 wqaPick 으로 바로 답이 나온다. */
  function catCount(k){ var n=0,i; for(i=0;i<WQA_KB.length;i++) if(WQA_KB[i].c===k) n++; return n; }
  function renderCats(){
    var h = '', i;
    for(i=0;i<CATS.length;i++)
      h += '<span class="' + (CATS[i].k===CAT_CUR ? 'on' : '') + '" onclick="wqaCat(\'' + CATS[i].k + '\')">'
         + esc(CATS[i].n) + '<span class="n">' + catCount(CATS[i].k) + '</span></span>';
    document.getElementById('wqaCats').innerHTML = h;

    var q = '', e;
    for(i=0;i<WQA_KB.length;i++){
      e = WQA_KB[i];
      if(e.c !== CAT_CUR) continue;
      q += '<span onclick="wqaPick(\'' + e.id + '\')">' + esc(e.t.replace(/[?？]$/,'')) + '</span>';
    }
    document.getElementById('wqaChips').innerHTML = q;
    document.getElementById('wqaChips').scrollTop = 0;
  }
  window.wqaCat = function(k){ CAT_CUR = k; renderCats(); };

  /* ── 초기화 ── */
  function init(){
    renderCats();
    restore();
    bindResize(document.querySelector('.wqa-rz-l'),  true,  false);
    bindResize(document.querySelector('.wqa-rz-t'),  false, true);
    bindResize(document.querySelector('.wqa-rz-tl'), true,  true);
    restoreSize();
    window.addEventListener('resize', function(){          // 브라우저 창이 줄면 패널도 화면 안으로
      var p = document.getElementById('wqaPanel');
      if(p.style.width || p.style.height) applySize(parseInt(p.style.width,10), parseInt(p.style.height,10));
    });
    try{
      if(sessionStorage.getItem('wqaOpen') === '1') wqaOpen();
    }catch(ignore){}
  }
  if(document.readyState === 'loading') document.addEventListener('DOMContentLoaded', init);
  else init();
})();
</script>
