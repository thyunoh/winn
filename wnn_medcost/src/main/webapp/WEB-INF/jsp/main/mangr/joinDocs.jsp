<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%--
  신규병원 — 승인 후 동의서 원본 제출                                    2026-08-19

  승인(30)만으로는 프로그램을 쓸 수 없다. 이 화면에서 서명·날인한 동의서를 올려야
  상태가 40 이 되고, 위너넷이 계약을 넣으면 메뉴가 열린다.

  · 조회는 전부 쿠키의 요양기관기호로만 한다 → 자기 병원 것만 보인다.
  · 파일은 기존 /sftp/fileupload.do 를 그대로 쓴다(계약 폴더 <기호>/1/C).
    계약관리 화면의 파일 목록에 같이 뜨게 하려고 폴더 규칙을 맞춘다.
--%>
<div class="dashboard-wrapper">
<div id="joinDocs">

<style>
  #joinDocs{ padding:16px 18px 40px; font-size:13px; color:#243746; }
  #joinDocs .jd-head{ display:flex; align-items:center; gap:10px; margin-bottom:14px; }
  #joinDocs .jd-head h3{ font-size:19px; font-weight:700; margin:0; color:#1f5a4b; }
  /* ★2026-08-24 — 단계 표시를 「동의서 제출」 제목 선상으로 올리고 <작게>.
     종전에는 전체 폭 띠(flex:1·padding 9px)라 한 줄을 통째로 먹었다. */
  #joinDocs .jd-step{ display:flex; gap:0; margin-left:16px; }   /* 2026-08-24 : 좌측(제목 옆) 배치 */
  #joinDocs .jd-step div{ text-align:center; padding:4px 12px; font-size:11.5px; white-space:nowrap;
      background:#f2f5f7; color:#8a97a2; border:1px solid #e2e8ed; border-right:0; }
  #joinDocs .jd-step div:first-child{ border-radius:6px 0 0 6px; }
  #joinDocs .jd-step div:last-child{ border-right:1px solid #e2e8ed; border-radius:0 6px 6px 0; }
  #joinDocs .jd-step div.on{ background:#1f5a4b; color:#fff; border-color:#1f5a4b; font-weight:600; }
  #joinDocs .jd-step div.done{ background:#e8f1ee; color:#1f5a4b; font-weight:600; }
  #joinDocs .jd-card{ border:1px solid #e2e8ed; border-radius:8px; background:#fff;
      padding:16px 18px; margin-bottom:14px; }
  /* ★2026-08-24 — 원래 신규가입 화면(join_apply)의 표시 규칙을 가져온다:
     탭 3개 + 노란 바탕 필수칸 + 빠진 항목 있는 탭 ● 표시 */
  #joinDocs .jd-tabs{ display:flex; gap:6px; margin:0 0 12px; }
  #joinDocs .jd-tab{ border:1px solid #cfd9e0; background:#f4f7f9; color:#43555f; border-radius:8px 8px 0 0;
            padding:9px 20px; font-size:13.5px; font-weight:700; cursor:pointer; }
  #joinDocs .jd-tab:hover{ background:#e9eff3; }
  #joinDocs .jd-tab.on{ background:#1f5a4b; border-color:#1f5a4b; color:#fff; }
  #joinDocs .jd-tab .bad{ color:#d9534f; margin-left:4px; font-weight:900; }
  #joinDocs .jd-tab.on .bad{ color:#ffd7d5; }
  #joinDocs .jd-pane{ display:none; }
  #joinDocs .jd-pane.on{ display:block; }
  #joinDocs .jd-in.jd-must, #joinDocs select.jd-must{ background:#fff6c9; }   /* 노란 바탕 = 필수 */
  #joinDocs .rq{ color:#d9534f; font-weight:900; }
  #joinDocs .jd-mustnote{ font-size:11.5px; color:#8a6d00; font-weight:700; margin:0 0 8px; }
  #joinDocs .jd-mustnote i{ display:inline-block; width:13px; height:13px; background:#fff6c9;
            border:1px solid #e3d59a; border-radius:3px; vertical-align:-2px; margin-right:5px; }
  /* 2026-08-24 「동의서 내용 폭을 넓게 — 제출 카드 아래까지」 — 카드 폭 가득 + 고정 높이라
     좌우 두 상자의 아래끝이 나란히 떨어진다(복구 때 유실됐던 규칙의 확장판) */
  #joinDocs .jd-doc{ width:100%; height:520px; max-height:none; overflow:auto; white-space:pre-wrap; background:#fafcfb;
            border:1px solid #e2e8ed; border-radius:6px; padding:10px 12px;
            font-size:12.5px; line-height:1.7; color:#4a5a64; }
  #joinDocs .jd-doc.empty{ color:#98a6b0; }
  #joinDocs .jd-agritem{ padding:7px 2px 1px; font-size:13px; }
  /* 동의서 2등분 — 두 카드를 좌우로. 좁은 화면(1100px 미만)에서는 위아래로
     ⚠2026-08-24 복구 때 한 번 유실됐던 규칙 — 없으면 두 동의서가 세로로 쌓인다 */
  #joinDocs .jd-agr2col{ display:flex; gap:14px; align-items:stretch; }
  #joinDocs .jd-agr2col > .jd-card{ flex:1 1 0; min-width:0; }
  @media (max-width:1100px){ #joinDocs .jd-agr2col{ flex-direction:column; } }
  /* ★2026-08-24 추가 — 표 안의 묶음 제목(전산프로그램 정보 등)과 동의서 본문 상자 */
  #joinDocs .jd-tb th.jd-grp{ background:#eef4f2; color:#1f5a4b; font-weight:800; text-align:left; }
  #joinDocs .jd-agrdoc{ margin-top:6px; max-height:150px; overflow:auto; white-space:pre-wrap;
            background:#fafcfb; border:1px solid #e2e8ed; border-radius:6px; padding:8px 10px;
            font-size:12px; line-height:1.65; color:#4a5a64; }
  #joinDocs .jd-card h4{ font-size:14.5px; font-weight:700; margin:0 0 10px; color:#1f5a4b;
      display:flex; align-items:center; gap:6px; }
  #joinDocs .jd-btn.mini{ padding:4px 12px; font-size:12px; }
  #joinDocs td input.jd-in{ width:100%; border:1px solid #b9c8d2; border-radius:4px;
      padding:4px 7px; font-size:12.5px; font-family:inherit; }
  #joinDocs td input.jd-in:focus{ outline:none; border-color:#1f5a4b; }
  /* ★2026-08-24 「콤보 위아래 폭 조금 확대」 — select 는 위 규칙(input 한정)을 못 받아
       브라우저 기본 모양으로 납작하게 나왔다. 같은 테두리에 세로 여백을 input 보다 1px 더 준다. */
  #joinDocs td select.jd-in{ border:1px solid #b9c8d2; border-radius:4px;
      padding:5px 6px; font-size:12.5px; font-family:inherit; background:#fff; }
  #joinDocs td select.jd-in:focus{ outline:none; border-color:#1f5a4b; }
  #joinDocs table.jd-tb{ width:100%; border-collapse:collapse; }
  #joinDocs table.jd-tb th, #joinDocs table.jd-tb td{ border:1px solid #e2e8ed; padding:7px 10px;
      font-size:12.5px; text-align:left; }
  #joinDocs table.jd-tb th{ background:#f7f9fa; width:130px; font-weight:600; color:#48606f; }
  #joinDocs .jd-drop{ border:2px dashed #b9c8d2; border-radius:8px; padding:26px 14px;
      text-align:center; color:#7b8b97; background:#fbfcfd; cursor:pointer; }
  #joinDocs .jd-drop.on{ border-color:#1f5a4b; background:#f1f7f5; color:#1f5a4b; }
  #joinDocs .jd-file{ margin-top:10px; font-size:12.5px; }
  #joinDocs .jd-btn{ border:1px solid #1f5a4b; background:#1f5a4b; color:#fff; border-radius:6px;
      padding:8px 20px; font-size:13.5px; font-weight:600; cursor:pointer; }
  #joinDocs .jd-btn.ghost{ background:#fff; color:#1f5a4b; }
  #joinDocs .jd-btn[disabled]{ background:#b9c8d2; border-color:#b9c8d2; cursor:not-allowed; }
  #joinDocs .jd-note{ font-size:12px; color:#7b8b97; line-height:1.7; margin-top:8px; }
  #joinDocs .jd-ok{ color:#1f5a4b; font-weight:700; }
  #joinDocs .jd-wait{ color:#c07a2a; font-weight:700; }
  /* ★2026-08-24 「가입신청 쪽 메시지 스타일로」 — join_apply(ja-swal-*)와 같은 컴팩트 규격.
       아이콘 48px·테두리 3px·제목 15px·본문 13px·버튼 13px. (메모리: Swal 은 항상 width 380·아이콘 48px) */
  .jd-swal{ font-size:13px !important; }
  .jd-swal .swal2-icon{ width:48px !important; height:48px !important;
      font-size:24px !important; border-width:3px !important; margin:12px auto 6px !important; }
  .jd-swal .swal2-icon .swal2-icon-content{ font-size:28px !important; }
  .jd-swal .swal2-title{ font-size:15px !important; font-weight:700 !important;
      line-height:1.5 !important; padding:0 10px 4px !important; color:#20303a !important; }
  .jd-swal .swal2-html-container, .jd-swal #swal2-html-container{
      font-size:13px !important; line-height:1.6 !important; margin:4px 10px 0 !important; }
  .jd-swal .swal2-actions{ margin-top:12px !important; }
  .jd-swal .swal2-styled{ font-size:13px !important; padding:6px 20px !important; }
</style>

<div class="jd-head">
  <%-- ★[2026-08-20 요청] 화면·단계 이름을 「신청서 제출」 → **「동의서 제출」** 로.
       상태값 40 의 이름도 이미 '동의서제출'(joinReq.jsp 상태 콤보)이라 그쪽과도 맞는다.
       PDF 쪽 이름도 함께 바꿨다(2026-08-20 «신청서 PDF도 동의서로») —
       단추 「동의서 PDF 만들기」·「동의서 미리보기」·파일명 `동의서_<기호>_<신청번호>.pdf`.
       ⚠**문서 1장째의 제목(위너넷 적정성 컨설팅 의뢰서 / 신규병원 가입신청서)은 그대로 둔다** —
         그건 서식 자체의 이름이다(2·3장이 동의서). 바꾸려면 서식 문구를 고치는 것이라 별도 확인이 필요하다. --%>
  <h3>동의서 제출</h3>
  <span style="font-size:12.5px; color:#7b8b97;" id="jdSub"></span>
  <%-- ★[2026-08-20 요청] 글자 축소·확대 — 가입신청 화면(joinReq.jsp)·신청서(join_apply.jsp)와 같은 조작.
       오른쪽 끝에 붙인다(.jd-head 가 flex 라 margin-left:auto 로 민다). --%>
  <div class="jd-step">
    <div class="done">① 가입신청</div>
    <div class="done">② 위너넷 승인</div>
    <div class="on" id="jdStep3">③ 동의서 제출</div>
    <div id="jdStep4">④ 사용시작</div>
  </div>
  <span id="jdZoomBtns" style="margin-left:auto; white-space:nowrap;">
    <button type="button" class="jd-btn ghost mini" onclick="jdZoom(-1);" title="글자 작게">가－</button>
    <button type="button" class="jd-btn ghost mini" onclick="jdZoom(1);"  title="글자 크게">가＋</button>
    <button type="button" class="jd-btn ghost mini" onclick="jdZoom(0);"  title="처음 크기로">↺</button>
  </span>
</div>

<%-- 글자 크기가 걸리는 범위 — 머리줄(제목·단추)은 빼고 **본문만** 키운다 --%>
<div id="jdZoomBox">


<%-- ★2026-08-24 요청 「3가지 탭으로, 필수표시는 원래 신규가입처럼」 —
     원래 신규가입 화면(join_apply.jsp)의 모양을 그대로 가져온다:
     탭 3개(컨설팅 의뢰서 · 원격접속·DB접근 동의 · 개인정보 수집·이용 동의) +
     노란 바탕 필수칸 + 빠진 항목이 있는 탭에 ● 표시.
     입력 표는 「한 줄 3등분」(라벨+입력 3쌍) — 같은 날 요청. --%>
<div class="jd-tabs" id="jdTabs">
  <button type="button" class="jd-tab on" data-pane="f1" onclick="jdPickTab('f1');">컨설팅 의뢰서</button>
  <%-- ★2026-08-24 「두 개 탭을 하나로, 2등분」 — 동의서 둘을 한 탭에서 좌우로 나란히 --%>
  <button type="button" class="jd-tab"    data-pane="f2" onclick="jdPickTab('f2');">원격접속·DB접근 / 개인정보 동의</button>
  <%-- ★2026-08-24 「표시부분으로 이동」+「좌측으로」 — 수정·저장·취소를 탭 줄, 탭 바로 옆에.
       어느 탭에서든 보이므로 동의 탭의 도장 교체도 여기서 [수정]을 누르면 된다. --%>
  <span style="margin-left:14px; display:flex; gap:6px; align-items:center;">
    <button type="button" class="jd-btn ghost mini" id="jdEditBtn" onclick="jdEdit(true);">수정</button>
    <button type="button" class="jd-btn mini"       id="jdSaveBtn" onclick="jdSave();"   style="display:none;">저장</button>
    <button type="button" class="jd-btn ghost mini" id="jdCancelBtn" onclick="jdEdit(false);" style="display:none;">취소</button>
  </span>
</div>

<!-- ① 컨설팅 의뢰서 : 신청 내용 + 담당자 + 의뢰서 동의 -->
<div class="jd-pane on" data-pane="f1">

<div class="jd-card">
  <h4>신청 내용</h4>
  <p class="jd-mustnote"><i></i>노란색 바탕은 반드시 작성 부탁드립니다.</p>
  <%-- 한 줄 3등분 — 라벨+입력 3쌍(6칸). 주소·비고처럼 긴 칸만 colspan 으로 넓힌다. --%>
  <table class="jd-tb">
    <colgroup>
      <col style="width:110px;"><col><col style="width:110px;"><col><col style="width:110px;"><col>
    </colgroup>
    <tbody id="jdInfo">
      <tr><td colspan="6" style="text-align:center; color:#8a97a2;">불러오는 중…</td></tr>
    </tbody>
  </table>
</div>

<%-- ★2026-08-24 프로세스 변경 — 담당자 표가 신청 화면에서 이리로 옮겨 왔다.
     총 관리자·심사과는 성명·전화번호·이메일까지 필수다(제출 때 서버가 다시 본다). --%>
<div class="jd-card">
  <h4>담당자 <span style="font-size:12px; font-weight:500; color:#8a99a3;">총 관리자·심사과는 필수</span></h4>
  <%-- ★2026-08-24 「두 개씩(두 줄로) 표시」 — 4구분을 한 줄에 둘씩. 표가 절반으로 짧아진다. --%>
  <table class="jd-tb">
    <colgroup>
      <%-- 2026-08-24 : 이메일 조금 넓게(13%)·전화번호 조금 축소(8.5%) --%>
      <col style="width:90px;"><col><col><col style="width:9%;"><col style="width:8.5%;"><col style="width:13%;">
      <col style="width:90px;"><col><col><col style="width:9%;"><col style="width:8.5%;"><col style="width:13%;">
    </colgroup>
    <thead>
      <tr><th></th><th>부서</th><th>직책</th><th>성명</th><th>전화번호</th><th>이메일 주소</th>
          <th></th><th>부서</th><th>직책</th><th>성명</th><th>전화번호</th><th>이메일 주소</th></tr>
    </thead>
    <tbody id="jdMgr">
      <tr><td colspan="12" style="text-align:center; color:#8a97a2;">불러오는 중…</td></tr>
    </tbody>
  </table>
</div>

<%-- [서식1] 자체에 대한 동의 — 등록돼 있을 때만 보인다(원래 신규가입과 같은 규칙) --%>
<div class="jd-card" id="jdAgrCardF1" style="display:none;">
  <h4>의뢰서 동의</h4>
  <div id="jdDocF1" class="jd-doc"></div>
  <div id="jdAgrF1"></div>
</div>

</div><!-- /f1 -->

<%-- 대표자 도장 파일 선택 — 화면에는 안 보이고 [직인 불러오기] 가 대신 누른다 --%>
<input type="file" id="jd_sealFile" accept="image/*" style="display:none;" onchange="jdSealFile(this);">

<!-- ② 동의서 — 원격접속·DB접근 + 개인정보를 한 탭에서 좌우 2등분 (2026-08-24) -->
<div class="jd-pane" data-pane="f2">
<div class="jd-agr2col">
  <div class="jd-card">
    <%-- ★2026-08-24 — 「전체 동의」를 동의서 제목과 같은 선상 <우측>에 표시.
         체크하면 오른쪽(개인정보) 카드의 동의까지 함께 켜진다. --%>
    <h4 style="display:flex; align-items:center;">원격접속 및 DB접근에 관한 동의서
      <label style="margin:0 0 0 auto; font-size:13px; font-weight:700; color:#1f5a4b; cursor:pointer; white-space:nowrap;">
        <input type="checkbox" id="jdAgrAll" onchange="jdAgrAll(this.checked);"> 전체 동의
      </label>
    </h4>
    <div id="jdDocF2" class="jd-doc empty">동의서를 불러오는 중입니다…</div>
    <div id="jdAgrF2"></div>
    <%-- 대표자 도장 — 원래 신규가입처럼 동의서(서식2) 자리에서 받는다 --%>
    <div id="jdSealBox" style="margin-top:12px; padding-top:10px; border-top:1px dashed #dfe7ec;"></div>
  </div>
  <div class="jd-card">
    <h4>개인정보 수집 및 이용에 관한 동의서</h4>
    <div id="jdDocF3" class="jd-doc empty">동의서를 불러오는 중입니다…</div>
    <div id="jdAgrF3"></div>
  </div>
</div>
</div><!-- /f2 -->

<div class="jd-card" id="jdUpBox">
  <h4>동의서 제출</h4>
  <%-- ★2026-08-24 「같은 선상으로」 — [PDF 만들기]·미입력 안내·[제출]을 한 줄에 --%>
  <div style="display:flex; align-items:center; gap:12px;">
    <button type="button" class="jd-btn" id="jdMakeBtn" onclick="jdMakePdf();" style="flex:0 0 auto;">동의서 PDF 만들기</button>
    <span id="jdLack" style="font-size:12.5px; font-weight:700; color:#d9534f;"></span>
    <span style="flex:1;"></span>
    <button type="button" class="jd-btn" id="jdSubmit" onclick="jdSubmit();" disabled style="flex:0 0 auto;">제출</button>
  </div>
  <div class="jd-file" id="jdFileList"></div>
  <div class="jd-note">
    신청내용·동의내역과 <b>신규가입 때 등록하신 대표자 도장</b>이 그대로 들어간 PDF 가 만들어집니다.
    따로 인쇄해 서명·날인하실 필요 없습니다.<br>
    제출하시면 <b>바로 프로그램을 사용하실 수 있습니다.</b>
  </div>
</div>

<%-- PDF 생성용 : 화면 밖에 문서를 그려두고 html2canvas 로 캡처한다.
     display:none 이면 캡처가 빈 화면이 되므로 화면 밖으로 밀어낸다. --%>

<%-- 만든 PDF 미리보기 — 확인하고 그 자리에서 제출한다 --%>
<div id="jdPv" style="display:none; position:fixed; inset:0; z-index:1800;
     background:rgba(20,30,36,.55); align-items:center; justify-content:center;">
  <div style="background:#fff; border-radius:10px; width:min(880px,94vw); height:88vh;
       display:flex; flex-direction:column; overflow:hidden; box-shadow:0 10px 40px rgba(0,0,0,.3);">
    <div style="display:flex; align-items:center; gap:10px; padding:11px 16px;
         border-bottom:1px solid #e2e8ed;">
      <b style="font-size:14.5px; color:#1f5a4b;">동의서 미리보기</b>
      <span id="jdPvNm" style="font-size:12px; color:#7b8b97;"></span>
      <span style="flex:1;"></span>
      <button type="button" class="jd-btn" onclick="jdPvSubmit();">제출</button>
      <button type="button" class="jd-btn ghost" onclick="jdPvClose();">닫기</button>
    </div>
    <iframe id="jdPvFrame" style="flex:1; width:100%; border:0; background:#525659;"></iframe>
  </div>
</div>
<iframe id="jdPrintFrame" style="position:fixed; right:0; bottom:0; width:0; height:0; border:0;"></iframe>

<%-- ★2026-08-24 「주소검색 카카오 기능추가」 — 신규가입 화면(join_apply)과 같은 다음 우편번호 API --%>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<%-- ★2026-08-24 「승인하는 화면 메시지 스타일로」 — 표준 ui-message.js(joinReq 와 동일) --%>
<script src="/asset/js/ui-message.js"></script>
<script type="text/javascript">
(function(){
  var PICKED = [];      /* 고른 파일 */
  var HOSP   = '<c:out value="${hospCd}"/>';
  var REQNO  = null;
  var INFO   = null;      /* 인쇄용 — 마지막으로 불러온 신청내용 */
  var AGREE  = [];
  var MGRS   = [];
  var AGRMST = [];        /* ★2026-08-24 동의서 마스터 — 승인 후 이 화면에서 동의를 받는다 */
  var CONTGBS = [];      /* ★2026-08-24 승인이 만든 계약의 구분 목록 — 희망 서비스 미리 체크용 */
  var SEALNEW = null;     /* 새로 올린 대표자 도장 { img, mime, nm } — 저장 때만 보낸다 */
  var PDF_BLOB = null, PDF_NAME = '';   /* 방금 만든 동의서 PDF */

  function gel(id){ return document.getElementById(id); }
  function esc(s){ return String(s == null ? '' : s)
      .replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;'); }
  function nv(s){ return (s == null || s === '') ? '<span style="color:#b9c8d2;">-</span>' : esc(s); }

  function box(msg, icon){
    /* ★2026-08-24 「승인하는 화면 메시지 스타일로」 — 표준 ui-message.js(흰 카드+아이콘) 우선.
         joinReq(승인 화면)와 같은 모양. 안 실린 환경은 Swal(jd-swal) → alert 폴백. */
    if (window._uiMessageLoaded && typeof window._alertBox === 'function'){
      var ic = (icon === 'warning') ? '⚠️' : (icon === 'error') ? '❌' : (icon === 'success') ? '✅' : 'ℹ️';
      window._alertBox(String(msg == null ? '' : msg).replace(/\n/g, '<br>'), { icon: ic });
      return;
    }
    if (window.Swal) Swal.fire({ icon: icon || undefined, title:String(msg), width:380,
        customClass:{ popup:'jd-swal' }, confirmButtonText:'확인', confirmButtonColor:'#1f5a4b' });
    else alert(msg);
  }

  /* ── 내 병원 승인건 ─────────────────────────────────────────────── */
  function jdInfo(){
    $.ajax({
      type:'post', url:'/join/joinDocsInfo.do', dataType:'json',
      success:function(d){
        if (d.error_code !== '0'){ box(d.error_msg || '조회하지 못했습니다.'); return; }
        var i = d.info;
        if (!i){
          gel('jdInfo').innerHTML =
            '<tr><td colspan="8" style="text-align:center; color:#8a97a2; padding:22px;">'
          + '승인된 가입신청이 없습니다. 위너넷 승인 후에 이용하실 수 있습니다.</td></tr>';
          gel('jdUpBox').style.display = 'none';
          gel('jdEditBtn').style.display = 'none';
          return;
        }
        REQNO = i.reqNo; INFO = i;
        gel('jdSub').innerHTML = esc(i.hospNm || '') + ' (' + esc(i.hospCd || '') + ')';

        var submitted = (i.docYn === 'Y');


        /* 동의내역 — 최초 로그인 때 "무엇에 동의했는지" 를 보여준다 */
        AGREE = d.agreeList || []; MGRS = d.mgrList || []; AGRMST = d.agreeMst || []; CONTGBS = d.contGbs || [];
        jdPaint(false);   /* 담당자·동의내역을 받은 뒤에 그린다 */
        jdAgrPaint();   /* ★2026-08-24 — 마스터 기준으로 그린다(신청 때 동의를 안 받으므로 내역이 비어 있다) */
        jdLackSync();
        if (submitted){
          gel('jdStep3').className = 'done';
          gel('jdStep4').className = 'on';
          gel('jdUpBox').innerHTML =
              '<h4>제출 완료</h4>'
            + '<div style="padding:14px 4px; line-height:1.9;">'
            + '동의서가 접수되었습니다. <b>이제 프로그램을 사용하실 수 있습니다.</b><br>'
            + '<span style="font-size:12px; color:#7b8b97;">'
            + '제출일시 ' + esc(i.docDttm || '') + ' · 파일 ' + esc(i.docFileNm || '') + '</span></div>';
        }
      },
      error:function(){ box('조회하지 못했습니다.'); }
    });
  }

  /* ── 신청 내용 그리기 : 보기 / 수정 두 모드 ────────────────────────
     고칠 수 있는 것은 문서에 찍히는 병원정보 7가지뿐이다.
     요양기관기호(키)·이메일(로그인 ID)·비밀번호는 승인으로 만들어진 병원·계정과
     묶여 있어 손대면 어긋난다. */
  var EDIT = false;

  /* ★2026-08-24 저장 오류(Data too long for 'ASQ_DAY') 재발 방지 —
       입력칸마다 <DB 컬럼 길이>를 maxlength 로 건다. 숫자칸은 숫자만 받는다.
       (컬럼: ASQ_DAY varchar(2) · PC_USE_STDT varchar(8, YYYYMMDD) · WARDCNT int …) */
  var MAXLEN = { hospNm:100, hospCeo:20, hospTel:20, hospFax:20, busiNum:20, zipCd:20,
                 hospAddr:200, hospExtradr:200, wardcnt:6, ocsCompany:100, ocsUserId:20,
                 ocsUserPw:50, hiraCertPw:50, asqDay:2, asqBigo:100, evalGoal:100,
                 pcUseTime:50, pcUseStdt:10 };
  var NUMONLY = { asqDay:1, wardcnt:1 };
  /* must=true 면 노란 바탕(필수) — 원래 신규가입의 .must 와 같은 표시 (2026-08-24) */
  function ip(id, val, ph, must){
    return '<input type="text" class="jd-in' + (must ? ' jd-must' : '') + '" id="jd_' + id + '"'
         + (MAXLEN[id] ? ' maxlength="' + MAXLEN[id] + '"' : '')
         + (NUMONLY[id] ? ' oninput="this.value=this.value.replace(/[^0-9]/g,\x27\x27);"' : '')
         + ' value="' + esc(val == null ? '' : val) + '"' + (ph ? ' placeholder="' + ph + '"' : '') + '>';
  }

  /* 대표자 도장 — 신규가입 때 올린 이미지를 그대로 쓴다 */
  /* 담당자 요약 — 도장 옆 칸. 접수담당자(신청자)를 맨 위에 함께 보여준다 */
  function jdMgrText(){
    var i = INFO, out = [];

    if (i && (i.mbrNm || i.email)){
      var a = [];
      if (i.jobNm)  a.push(esc(i.jobNm));
      if (i.mbrTel) a.push(esc(i.mbrTel));
      if (i.email)  a.push(esc(i.email));
      out.push('<div style="padding:1px 0; line-height:1.45;"><b>접수담당자</b> ' + esc(i.mbrNm || '')
             + (a.length ? ' <span style="color:#7b8b97;">· ' + a.join(' · ') + '</span>' : '')
             + '</div>');
    }

    for (var n = 0; n < MGRS.length; n++){
      var m = MGRS[n], t = [];
      if (m.deptNm) t.push(esc(m.deptNm));
      if (m.jobNm)  t.push(esc(m.jobNm));
      if (m.mgrTel) t.push(esc(m.mgrTel));
      if (m.email || m.mgrEmail) t.push(esc(m.email || m.mgrEmail));
      out.push('<div style="padding:1px 0; line-height:1.45;"><b>' + esc(m.mgrGbNm || m.mgrGb || '') + '</b> '
             + esc(m.mgrNm || '') + (t.length ? ' <span style="color:#7b8b97;">· '
             + t.join(' · ') + '</span>' : '') + '</div>');
    }

    return out.length ? out.join('') : '<span style="color:#b9c8d2;">없음</span>';
  }

  function jdSealTag(px){
    var i = INFO;
    if (!i || !i.sealImg) return '<span style="color:#b9c8d2;">없음</span>';
    return '<img src="data:' + (i.sealMime || 'image/png') + ';base64,' + i.sealImg
         + '" style="width:' + px + 'px; height:auto;">';
  }

  window.jdPaint = function(edit){
    if (typeof edit === 'boolean') EDIT = !!edit;
    var i = INFO; if (!i) return;
    var submitted = (i.docYn === 'Y');
    var v = function(id, val){ return EDIT ? ip(id, val) : nv(val); };

    /* ★2026-08-24 — 필수칸 표시는 원래 신규가입(join_apply)과 같게:
         수정 모드 = <노란 바탕> + 라벨 * , 보기 모드 = 빈 값이면 빨간 「미입력」 */
    var need = function(id, val, label){
      if (EDIT) return ip(id, val, null, true);
      return (val == null || String(val).trim() === '')
           ? '<span class="jd-wait">' + esc(label || '미입력') + '</span>' : esc(val);
    };
    var RQ = ' <span class="rq">*</span>';
    /* ★2026-08-24(정정) — 암호 표시는 <신청자 로그인 비밀번호>다. 병원 전산프로그램 PW·인증서암호는
         위너넷·병원이 실제 값을 확인해야 하는 정보라 평문으로 되돌렸다(「병원 패스워드가 아니고」). */
    var secret = function(id, val){
      if (EDIT) return '<input type="password" class="jd-in jd-must" id="jd_' + id + '" autocomplete="new-password" value="' + esc(val == null ? '' : val) + '">';
      return (val == null || String(val).trim() === '')
           ? '<span class="jd-wait">미입력</span>' : '●●●●●●●●';
    };


    /* 주소 — 한 줄에 우편번호·주소·상세주소를 함께(원래 신규가입과 같은 모양) */
    var addr;
    if (EDIT){
      addr = '<div style="display:flex; gap:6px;">'
           + '<input type="text" class="jd-in" id="jd_zipCd" maxlength="20" placeholder="우편번호" style="flex:0 0 90px;" value="' + esc(i.zipCd || '') + '">'
           + '<button type="button" class="jd-btn ghost mini" style="flex:0 0 auto; white-space:nowrap;" onclick="jdAddrSearch();">주소검색</button>'
           + '<input type="text" class="jd-in jd-must" id="jd_hospAddr" maxlength="200" placeholder="주소" style="flex:1.4;" value="' + esc(i.hospAddr || '') + '">'
           + '<input type="text" class="jd-in" id="jd_hospExtradr" maxlength="200" placeholder="상세주소(건물·층·호)" style="flex:1;" value="' + esc(i.hospExtradr || '') + '">'
           + '</div>';
    } else {
      addr = (String(i.hospAddr || '').trim() === '')
           ? '<span class="jd-wait">미입력</span>'
           : esc(((i.zipCd ? '(' + i.zipCd + ') ' : '') + (i.hospAddr || '') + ' ' + (i.hospExtradr || '')).trim());
    }

    /* ★2026-08-24 「여기는 네줄로」 — 한 줄 4등분(라벨+입력 4쌍, 8칸).
         종전 3등분은 넓은 화면에서 입력칸이 늘어져 보였다. 주소·비고만 colspan 으로 넓힌다. */
    gel('jdInfo').innerHTML =
        '<tr><th>병원명' + RQ + '</th><td>' + need('hospNm', i.hospNm) + '</td>'
      + '<th>요양기관기호</th><td>' + nv(i.hospCd) + '</td>'
      + '<th>전화번호' + RQ + '</th><td>' + need('hospTel', i.hospTel) + '</td>'
      + '<th>FAX</th><td>' + v('hospFax', i.hospFax) + '</td></tr>'   /* 2026-08-24 : 대표자↔FAX 자리 교체 */
      + '<tr><th>사업자등록번호</th><td>' + v('busiNum', i.busiNum) + '</td>'
      + '<th>대표자' + RQ + '</th><td>' + need('hospCeo', i.hospCeo) + '</td>'
      + '<th>병상수</th><td>' + v('wardcnt', i.wardcnt) + '</td>'
      + '<th>희망 서비스' + RQ + '</th><td>' + jdConactCell(i) + '</td></tr>'
      + '<tr><th>주소' + RQ + '</th><td colspan="7">' + addr + '</td></tr>'
      + '<tr><th class="jd-grp" colspan="8">전산프로그램 정보 (MASTER)</th></tr>'
      + '<tr><th>프로그램명' + RQ + '</th><td>' + need('ocsCompany', i.ocsCompany) + '</td>'
      + '<th>프로그램 ID' + RQ + '</th><td>' + need('ocsUserId', i.ocsUserId) + '</td>'
      + '<th>프로그램 PW' + RQ + '</th><td>' + need('ocsUserPw', i.ocsUserPw) + '</td>'
      + '<th>심평원<br>인증서암호' + RQ + '</th><td>' + need('hiraCertPw', i.hiraCertPw) + '</td></tr>'
      + '<tr><th class="jd-grp" colspan="8">평가 · 서비스</th></tr>'
      + '<tr><th>환자평가표<br>작성완료일' + RQ + '</th><td>' + need('asqDay', i.asqDay, '미입력(매월 N일)') + '</td>'
      + '<th>작성완료일 비고</th><td>' + v('asqBigo', i.asqBigo) + '</td>'
      + '<th>적정성평가<br>목표점수·등급' + RQ + '</th><td>' + need('evalGoal', i.evalGoal, '미입력(예: 1등급 / 90점)') + '</td>'
      + '<th>동의서</th><td>'
      + (submitted
          ? '<span class="jd-ok">제출완료</span> · ' + nv(i.docDttm)
          : '<span class="jd-wait">미제출</span>')
      + '</td></tr>'
      + '<tr><th>PC 사용여부</th><td>' + jdPcCell(i) + '</td>'
      + '<th>PC 사용 시작일</th><td>' + v('pcUseStdt', i.pcUseStdt) + '</td>'
      + '<th>신청일시</th><td>' + nv(i.reqDttm) + '</td>'
      + '<th>승인일시</th><td>' + nv(i.cfmDttm) + '</td></tr>'
      /* ★2026-08-24 「신청자내용 보여주세요」 — 신청 때 받은 신청자·로그인 계정.
         이메일이 로그인 ID 이고 계정과 묶여 있어 <읽기전용>이다. */
      + '<tr><th class="jd-grp" colspan="8">신청자 · 로그인 계정</th></tr>'
      + '<tr><th>신청자 성명</th><td>' + nv(i.mbrNm) + '</td>'
      + '<th>직위</th><td>' + nv(i.jobNm) + '</td>'
      + '<th>연락처</th><td>' + nv(i.mbrTel) + '</td>'
      + '<th>이메일 (ID)</th><td>' + nv(i.email) + '</td></tr>'
      /* 신청자 로그인 비밀번호 — 암호화 저장이라 원문은 없다. <설정됨> 표시만 ●●● 로. */
      + '<tr><th>비밀번호</th><td>●●●●●●●●</td>'
      + '<th>비 고</th><td colspan="5">' + nv(i.bigo) + '</td></tr>';

    jdMgrPaint();
    jdAgrPaint();   /* 수정⇄보기 전환에 맞춰 동의 체크박스 활성/잠금 다시 그림 (2026-08-24) */
    jdSealPaint();

    gel('jdEditBtn').style.display   = EDIT ? 'none' : '';
    gel('jdSaveBtn').style.display   = EDIT ? '' : 'none';
    gel('jdCancelBtn').style.display = EDIT ? '' : 'none';
    jdLackSync();
  };


  /* ══ 2026-08-24 프로세스 변경으로 이 화면이 받게 된 항목들 ═══════════════════
     신청은 요양기관기호·요양기관명·신청자정보만 받는다. 나머지는 승인 후 여기서 채우고,
     동의서까지 제출해야 사이드바 메뉴가 열린다(joinDocsSubmit 이 서버에서 다시 본다). */

  /* 희망 서비스 — 1.진료비분석 2.적정성평가 A.둘 다.
     ★2026-08-24 「둘 중 하나 체크 필수 · 승인 시 되어 있는지 확인하고 체크」 —
       신청서 값(conactGb)이 비어 있으면 <승인이 만든 계약의 구분(CONTGBS)>으로 미리 체크한다. */
  function jdConactEff(i){
    var g = String((i && i.conactGb) || '');
    if (g !== '') return g;
    var h1 = CONTGBS.indexOf('1') >= 0, h2 = CONTGBS.indexOf('2') >= 0;
    return (h1 && h2) ? 'A' : h1 ? '1' : h2 ? '2' : '';
  }
  function jdConactCell(i){
    var g = jdConactEff(i);
    if (!EDIT){
      var t = (g === 'A') ? '진료비 분석 + 적정성평가' : (g === '1') ? '진료비 분석' : (g === '2') ? '적정성평가' : '';
      return t ? esc(t) : '<span class="jd-wait">미선택</span>';
    }
    var c1 = (g === '1' || g === 'A') ? ' checked' : '';
    var c2 = (g === '2' || g === 'A') ? ' checked' : '';
    return '<label style="margin-right:12px;"><input type="checkbox" id="jd_conact1"' + c1 + ' onchange="jdLackSync();"> 진료비 분석</label>'
         + '<label><input type="checkbox" id="jd_conact2"' + c2 + ' onchange="jdLackSync();"> 적정성평가</label>';
  }
  /* 화면의 체크 두 개 → 저장값 한 글자 */
  function jdConactVal(){
    var a = gel('jd_conact1'), b = gel('jd_conact2');
    if (!a || !b) return jdConactEff(INFO);
    if (a.checked && b.checked) return 'A';
    if (a.checked) return '1';
    if (b.checked) return '2';
    return '';
  }

  /* PC 사용여부 — 1.단독사용 가능 2.단독불가(가능시간) 3.사용 시작일 지정 */
  var PC_NM = { '1':'단독사용 가능', '2':'단독불가', '3':'PC사용 시작일 지정' };
  function jdPcCell(i){
    var g = String(i.pcUseGb || '');
    if (!EDIT){
      var t = PC_NM[g] || '';
      if (g === '2' && i.pcUseTime) t += ' (' + i.pcUseTime + ')';
      return t ? esc(t) : '<span style="color:#b9c8d2;">-</span>';
    }
    var o = ['', '1', '2', '3'].map(function(k){
      return '<option value="' + k + '"' + (k === g ? ' selected' : '') + '>'
           + (k === '' ? '선택 안 함' : PC_NM[k]) + '</option>';
    }).join('');
    return '<select class="jd-in" id="jd_pcUseGb" style="max-width:150px;">' + o + '</select>'
         + ' <input type="text" class="jd-in" id="jd_pcUseTime" style="max-width:140px;"'
         + ' placeholder="가능시간" value="' + esc(i.pcUseTime || '') + '">';
  }

  /* 대표자 도장 — 신청 때 받던 것을 여기로 옮겼다. 새로 고르면 SEALNEW 에 담아 두고 저장 때 보낸다.
     ⚠base64 <본문만> 보낸다(data URL 접두어는 뗀다). 해시는 서버가 원본에서 다시 계산한다. */
  function jdSealCell(){
    var src = (SEALNEW && SEALNEW.img) ? ('data:' + SEALNEW.mime + ';base64,' + SEALNEW.img)
            : (!SEALNEW && INFO && INFO.sealImg) ? ('data:' + (INFO.sealMime || 'image/png') + ';base64,' + INFO.sealImg)
            : '';
    var img = src ? '<img src="' + src + '" style="width:72px; height:auto; vertical-align:middle;" onerror="jdSealBroken();">'
                  : '<span class="jd-wait">미등록</span>';
    if (!EDIT) return img;
    return img
         + ' <button type="button" class="jd-btn ghost mini" onclick="jdSealPick();">직인 불러오기</button>'
         + (src ? ' <button type="button" class="jd-btn ghost mini" onclick="jdSealClear();">지우기</button>' : '');
  }
  /* ★2026-08-24 — 저장돼 있어도 <깨진> 도장(이중 인코딩 시절 저장분)은 미등록으로 되돌린다.
       깨진 값이 "있음"으로 판정되면 도장 안내가 안 떠서 빈 (인) PDF 까지 조용히 진행된다. */
  window.jdSealBroken = function(){
    if (INFO) INFO.sealImg = '';
    SEALNEW = null;
    jdPaint(EDIT);
    box('등록된 대표자 도장 이미지가 손상되어 있습니다.\n직인·사인을 다시 올려 주세요.', 'warning');
  };
  window.jdSealPick = function(){ var f = gel('jd_sealFile'); if (f){ f.value = ''; f.click(); } };
  window.jdSealClear = function(){ SEALNEW = { img:'', mime:'', nm:'' }; jdPaint(EDIT); };
  window.jdSealFile = function(el){
    var f = el && el.files && el.files[0]; if (!f) return;
    if (f.size > 3 * 1024 * 1024){ box('직인 이미지가 너무 큽니다(3MB 이하).', 'warning'); return; }
    var r = new FileReader();
    r.onload = function(){
      var s = String(r.result || '');
      var p = s.indexOf(',');                       /* data:image/png;base64,XXXX → XXXX 만 */
      SEALNEW = { img: p >= 0 ? s.substring(p + 1) : s, mime: f.type || 'image/png', nm: f.name || '' };
      jdPaint(EDIT);
      /* ★2026-08-24 「도장 첨가 메시지」 — 올려도 조용해서 된 건지 알 수 없었다 */
      box('대표자 도장을 불러왔습니다.\n[저장] 을 눌러야 반영됩니다.', 'success');
    };
    r.onerror = function(){ box('도장 이미지를 읽지 못했습니다. 파일을 다시 골라 주세요.', 'error'); };
    r.readAsDataURL(f);
  };

  /* ── 담당자 표 — 신청 때 받던 4구분을 여기로 옮겼다 ─────────────────
     구분 코드는 총관리자(1)·간호과(2)·심사과(3)·전산담당(4). 총관리자·심사과가 필수다.
     ⚠MGR_SEQ 는 서버가 매긴다. 화면은 <구분당 한 줄>만 다룬다(종전 신청서와 같은 모양). */
  var MGR_GBS = [ {gb:'1', nm:'총 관리자', ess:true}, {gb:'2', nm:'간호과', ess:false},
                  {gb:'3', nm:'심사과',   ess:true}, {gb:'4', nm:'전산담당', ess:false} ];
  function mgrOf(gb){
    for (var n = 0; n < MGRS.length; n++) if (String(MGRS[n].mgrGb) === gb) return MGRS[n];
    return {};
  }
  function jdMgrPaint(){
    var t = gel('jdMgr'); if (!t) return;
    var cell = function(gb, key, val){
      /* 총관리자(1)·심사과(3)의 성명·전화·이메일은 필수 — 노란 바탕 (2026-08-24) */
      var must = (gb === '1' || gb === '3') && (key === 'Nm' || key === 'Tel' || key === 'Mail');
      return EDIT ? '<input type="text" class="jd-in' + (must ? ' jd-must' : '') + '" id="jd_mgr' + gb + '_' + key + '" value="' + esc(val || '') + '" oninput="jdLackSync();">'
                  : nv(val);
    };
    /* ★2026-08-24 「두 개씩 표시」 — 한 줄에 구분 둘(총관리자·간호과 / 심사과·전산담당) */
    var half = function(g){
      var m = mgrOf(g.gb);
      var lack = g.ess && !EDIT && (!m.mgrNm || !m.mgrTel || !(m.email || m.mgrEmail));
      return '<th>' + esc(g.nm) + (g.ess ? ' <span class="rq">*</span>' : '') + '</th>'
           + '<td>' + cell(g.gb, 'Dept', m.deptNm) + '</td>'
           + '<td>' + cell(g.gb, 'Job',  m.jobNm)  + '</td>'
           + '<td>' + (lack ? '<span class="jd-wait">미입력</span>' : cell(g.gb, 'Nm', m.mgrNm)) + '</td>'
           + '<td>' + cell(g.gb, 'Tel',  m.mgrTel) + '</td>'
           + '<td>' + cell(g.gb, 'Mail', m.email || m.mgrEmail) + '</td>';
    };
    t.innerHTML = '<tr>' + half(MGR_GBS[0]) + half(MGR_GBS[1]) + '</tr>'
                + '<tr>' + half(MGR_GBS[2]) + half(MGR_GBS[3]) + '</tr>';
  }
  /* 화면 → 서버로 보낼 담당자 목록. 다 빈 줄은 빼고 보낸다(빈 담당자가 쌓이지 않게). */
  function jdMgrData(d){
    var n = 0;
    MGR_GBS.forEach(function(g){
      var get = function(k){ var e = gel('jd_mgr' + g.gb + '_' + k); return e ? e.value.trim() : ''; };
      var nm = get('Nm'), tel = get('Tel'), mail = get('Mail'), dept = get('Dept'), job = get('Job');
      if (!nm && !tel && !mail && !dept && !job) return;
      d['mgrList[' + n + '].mgrGb']  = g.gb;
      d['mgrList[' + n + '].deptNm'] = dept;
      d['mgrList[' + n + '].jobNm']  = job;
      d['mgrList[' + n + '].mgrNm']  = nm;
      d['mgrList[' + n + '].mgrTel'] = tel;
      d['mgrList[' + n + '].email']  = mail;
      n++;
    });
    return n;
  }

  /* ── 동의서 — 신청 때 받던 것을 여기로 옮겼다 ─────────────────────
     TBL_JOIN_AGREE 에 행이 없는 상태로 넘어오므로, 마스터(AGRMST)를 기준으로 그린다.
     이미 동의한 항목은 일시를 보여주고 체크를 없앤다(동의를 무를 수 있게 만들지 않는다). */
  function agrDone(cd){
    for (var n = 0; n < AGREE.length; n++)
      if (String(AGREE[n].agreeCd) === String(cd) && AGREE[n].agreeYn === 'Y') return AGREE[n];
    return null;
  }
  /* ── 탭 — 원래 신규가입(join_apply)과 같은 조작. 빠진 항목이 있는 탭에 ● ── */
  window.jdPickTab = function(k){
    var tabs = document.querySelectorAll('#joinDocs .jd-tab');
    for (var t = 0; t < tabs.length; t++) tabs[t].classList.toggle('on', tabs[t].getAttribute('data-pane') === k);
    var panes = document.querySelectorAll('#joinDocs .jd-pane');
    for (var p = 0; p < panes.length; p++) panes[p].classList.toggle('on', panes[p].getAttribute('data-pane') === k);
  };
  function jdTabMark(badPane){
    var tabs = document.querySelectorAll('#joinDocs .jd-tab');
    for (var t = 0; t < tabs.length; t++){
      var bad = !!badPane[tabs[t].getAttribute('data-pane')];
      var mark = tabs[t].querySelector('.bad');
      if (bad && !mark){ var s = document.createElement('span'); s.className = 'bad'; s.textContent = '●'; tabs[t].appendChild(s); }
      if (!bad && mark) mark.remove();
    }
  }

  /* ★2026-08-24 「주소검색 카카오 기능추가」 — 신규가입 화면(jaAddrSearch)과 같은 다음 우편번호 API.
     선택하면 우편번호·주소를 채우고 상세주소로 커서를 옮긴다. */
  window.jdAddrSearch = function(){
    if (typeof daum === 'undefined' || !daum.Postcode){
      box('주소검색을 열 수 없습니다. 인터넷 연결을 확인해 주세요.', 'error');
      return;
    }
    new daum.Postcode({
      oncomplete: function(data){
        var addr = (data.userSelectedType === 'R') ? data.roadAddress : data.jibunAddress;
        var extra = '';
        if (data.userSelectedType === 'R'){
          if (data.bname && /[동|로|가]$/g.test(data.bname)) extra += data.bname;
          if (data.buildingName && data.apartment === 'Y')
            extra += (extra !== '' ? ', ' + data.buildingName : data.buildingName);
          if (extra !== '') extra = ' (' + extra + ')';
        }
        var z = gel('jd_zipCd'), a = gel('jd_hospAddr');
        if (z) z.value = data.zonecode;
        if (a) a.value = addr + extra;
        jdLackSync();
        var ex = gel('jd_hospExtradr'); if (ex) ex.focus();
      }
    }).open();
  };

  /* 대표자 도장 — 원래 신규가입처럼 동의서(서식2) 자리에서 받는다 */
  function jdSealPaint(){
    var b = gel('jdSealBox'); if (!b) return;
    b.innerHTML = '<b style="font-size:13px; color:#1f5a4b;">대표자 도장·사인 <span class="rq">*</span></b>&nbsp;&nbsp;'
      + jdSealCell()
      + (EDIT ? '' : ' <span style="font-size:12px; color:#8a99a3;">— 바꾸려면 [컨설팅 의뢰서] 탭의 [수정] 을 누른 뒤 여기서 불러오세요.</span>');
  }

  function jdAgrPaint(){
    /* 서식 번호(FORM_NO)로 탭에 나눈다 — 원래 신규가입(jaRenderAgree)과 같은 규칙.
       ★수정⇄보기 전환 때 다시 그리므로, 그리기 전 체크 상태를 떠 두었다가 되살린다
         (안 그러면 체크만 하고 저장 안 한 동의가 전환 순간 풀린다). */
    var prev = {};
    var old = document.querySelectorAll('#joinDocs .jd-agr');
    for (var o = 0; o < old.length; o++) prev[old[o].getAttribute('data-cd')] = old[o].checked;

    var f1 = [], f2 = [], f3 = [];
    for (var n = 0; n < AGRMST.length; n++){
      var a = AGRMST[n], fn = String(a.formNo || '');
      if      (fn.indexOf('1') >= 0) f1.push(a);
      else if (fn.indexOf('2') >= 0) f2.push(a);
      else if (fn.indexOf('3') >= 0) f3.push(a);
    }
    function item(a){
      var done = agrDone(a.agreeCd);
      var ess = (a.essYn === 'Y') ? ' <span class="rq">(필수)</span>' : ' <span style="color:#8a99a3;">(선택)</span>';
      /* ★2026-08-24 「체크표시, 수정 시에는 활성화」 —
           보기 모드 = 체크된 채 잠금(무를 수 없음을 보여준다).
           수정 모드 = 활성 체크박스. <해제한 채 저장하면 동의가 철회(N)로 저장>되고,
           필수면 다시 체크해야 제출된다(서버 upsert 가 AGREE_YN 을 덮는다). */
      if (done && !EDIT)
        return '<div class="jd-agritem"><label style="margin:0;"><input type="checkbox" checked disabled> '
             + esc(a.agreeNm || a.agreeCd) + ' 에 동의함</label>' + ess
             + ' <span style="color:#7b8b97; font-size:12px;">· ' + esc(done.agreeDttm || '') + '</span></div>';
      if (done)
        return '<div class="jd-agritem"><label><input type="checkbox" class="jd-agr" checked'
             + ' data-done="1" data-cd="' + esc(a.agreeCd) + '" data-ver="' + esc(a.verNo) + '"'
             + ' data-nm="' + esc(a.agreeNm) + '" data-ess="' + esc(a.essYn) + '"'
             + ' onchange="jdLackSync();"> ' + esc(a.agreeNm || a.agreeCd) + ' 에 동의함</label>' + ess
             + ' <span style="color:#7b8b97; font-size:12px;">· ' + esc(done.agreeDttm || '') + '</span></div>';
      return '<div class="jd-agritem"><label><input type="checkbox" class="jd-agr"'
           + ' data-cd="' + esc(a.agreeCd) + '" data-ver="' + esc(a.verNo) + '"'
           + ' data-nm="' + esc(a.agreeNm) + '" data-ess="' + esc(a.essYn) + '"'
           + ' onchange="jdLackSync();"> ' + esc(a.agreeNm || a.agreeCd) + ' 내용을 확인하였으며 동의합니다.</label>' + ess + '</div>';
    }
    function put(docId, boxId, arr){
      var doc = gel(docId), box2 = gel(boxId);
      if (!doc || !box2) return;
      var txt = arr.length ? String(arr[0].agreeText || '') : '';
      if (txt.trim() === ''){ doc.className = 'jd-doc empty'; doc.textContent = '등록된 동의서 본문이 없습니다. 위너넷 담당자에게 문의해 주세요.'; }
      else { doc.className = 'jd-doc'; doc.textContent = txt; }
      var h = ''; for (var k = 0; k < arr.length; k++) h += item(arr[k]);
      box2.innerHTML = h;
    }
    put('jdDocF2', 'jdAgrF2', f2);
    put('jdDocF3', 'jdAgrF3', f3);
    var c1 = gel('jdAgrCardF1');
    if (c1){ c1.style.display = f1.length ? '' : 'none'; if (f1.length) put('jdDocF1', 'jdAgrF1', f1); }
    /* 떠 둔 체크 상태 되살리기 — data-cd 로 같은 항목을 찾는다 */
    var now = document.querySelectorAll('#joinDocs .jd-agr');
    for (var r = 0; r < now.length; r++){
      var cd0 = now[r].getAttribute('data-cd');
      if (Object.prototype.hasOwnProperty.call(prev, cd0)) now[r].checked = prev[cd0];
    }
  }

  /* 화면 → 서버로 보낼 동의 목록.
     새로 체크한 것 = 동의(Y). ★수정 모드에서 <완료였던 것을 해제>하면 철회(N)로 보낸다(2026-08-24)
     — 서버 insertJoinAgree 가 ON DUPLICATE 로 AGREE_YN 을 덮는다. 둘 다 아니면 안 보낸다. */
  function jdAgrData(d){
    var cs = document.querySelectorAll('#joinDocs .jd-agr'), n = 0;
    for (var k = 0; k < cs.length; k++){
      var yn = cs[k].checked ? 'Y' : (cs[k].getAttribute('data-done') === '1' ? 'N' : '');
      if (yn === '') continue;
      d['agreeList[' + n + '].agreeCd'] = cs[k].getAttribute('data-cd');
      d['agreeList[' + n + '].verNo']   = cs[k].getAttribute('data-ver');
      d['agreeList[' + n + '].agreeNm'] = cs[k].getAttribute('data-nm');
      d['agreeList[' + n + '].agreeYn'] = yn;
      d['agreeList[' + n + '].readYn']  = 'Y';        /* 전문을 펼쳐 보여 주므로 열람으로 본다 */
      n++;
    }
    return n;
  }
  /* ★2026-08-24 「모두 동의」 — 남은 동의 체크를 한 번에. 이미 동의 완료된 항목은 잠겨 있어 안 건드린다. */
  window.jdAgrAll = function(on){
    var cs = document.querySelectorAll('#joinDocs .jd-agr');
    for (var n = 0; n < cs.length; n++) cs[n].checked = !!on;
    jdLackSync();
  };
  /* 개별 체크 ↔ 모두 동의 상태 맞춤 — jdLackSync 가 부른다.
     체크할 것이 하나도 안 남았으면(전부 동의 완료) 켠 채 잠근다. */
  function jdAgrAllSync(){
    var all = gel('jdAgrAll'); if (!all) return;
    var cs = document.querySelectorAll('#joinDocs .jd-agr');
    if (!cs.length){ all.checked = AGRMST.length > 0; all.disabled = true; return; }
    all.disabled = false;
    var every = true;
    for (var n = 0; n < cs.length; n++) if (!cs[n].checked){ every = false; break; }
    all.checked = every;
  }

  /* 아직 비어 있는 항목 — 서버(joinDocsSubmit 의 lackOf)와 <같은 순서·같은 이름>이다.
     두 곳의 이름이 다르면 "화면은 다 찼다는데 서버가 막는다"가 된다.
     탭별로 모아 빠진 항목이 있는 탭에 ● 를 붙인다(원래 신규가입과 같은 표시). */
  window.jdLackSync = function(){
    var i = INFO; if (!i) return [];
    var g = function(id, cur){ var e = gel('jd_' + id); return e ? e.value.trim() : String(cur == null ? '' : cur); };
    var names = [], badPane = {};
    var add = function(pane, nm){ names.push(nm); badPane[pane] = true; };

    [['hospNm','병원명'],['hospCeo','대표자'],['hospTel','전화번호'],['hospAddr','주소'],
     ['ocsCompany','전산프로그램명'],['ocsUserId','전산프로그램 ID'],['ocsUserPw','전산프로그램 PW'],
     ['hiraCertPw','심평원 인증서암호'],['asqDay','환자평가표 작성완료일'],['evalGoal','적정성평가 목표']
    ].forEach(function(p){ if (g(p[0], i[p[0]]) === '') add('f1', p[1]); });

    [['1','총 관리자'], ['3','심사과']].forEach(function(p){
      var m = mgrOf(p[0]);
      var get = function(k){ var e = gel('jd_mgr' + p[0] + '_' + k); return e ? e.value.trim() : null; };
      var nm  = get('Nm')   !== null ? get('Nm')   : (m.mgrNm  || '');
      var tel = get('Tel')  !== null ? get('Tel')  : (m.mgrTel || '');
      var ml  = get('Mail') !== null ? get('Mail') : (m.email || m.mgrEmail || '');
      if (!nm || !tel || !ml) add('f1', '담당자(' + p[1] + ')');
    });

    /* 희망 서비스 — 둘 중 하나는 체크해야 한다(2026-08-24). 수정 중엔 체크 상태, 아니면 유효값으로 본다. */
    if ((gel('jd_conact1') ? jdConactVal() : jdConactEff(i)) === '') add('f1', '희망 서비스');

    var hasSeal = SEALNEW ? !!SEALNEW.img : !!i.sealImg;
    if (!hasSeal) add('f2', '대표자 도장·사인');

    for (var n = 0; n < AGRMST.length; n++){
      var a = AGRMST[n];
      if (a.essYn !== 'Y') continue;
      /* ★수정 모드에서 완료 동의를 해제할 수 있게 되어(2026-08-24), 화면 체크박스가 있으면 그 상태가 우선 */
      var c = document.querySelector('.jd-agr[data-cd="' + a.agreeCd + '"]');
      var ok = c ? c.checked : !!agrDone(a.agreeCd);
      if (ok) continue;
      var fn = String(a.formNo || '');
      add(fn.indexOf('1') >= 0 ? 'f1' : 'f2', '동의 — ' + (a.agreeNm || a.agreeCd));
    }

    jdTabMark(badPane);
    jdAgrAllSync();

    var b = gel('jdLack');
    if (b){
      if (names.length){
        b.style.color = '#d9534f';
        b.textContent = '아직 비어 있음 : ' + names.slice(0, 5).join(' · ')
                      + (names.length > 5 ? ' 외 ' + (names.length - 5) + '건' : '');
      } else {
        b.style.color = '#1f5a4b';
        b.textContent = '입력이 모두 끝났습니다. 동의서를 만들어 제출하시면 메뉴가 열립니다.';
      }
    }
    return names;
  };
  /* 수정 시작 / 취소 */
  window.jdEdit = function(on){ jdPaint(!!on); };

  /* 저장 — 고친 뒤에는 PDF 를 다시 만들어 올려야 내용이 맞는다 */
  window.jdSave = function(){
    if (!INFO) return;
    var g = function(id){ var e = gel('jd_' + id); return e ? e.value.trim() : ''; };
    /* ★2026-08-24 「각 항목 입력 해당 메시지」 — 저장 때도 필수를 <항목별로> 본다.
         전화번호를 안 넣었는데 「수정했습니다」가 떠서 다 된 줄 알게 되던 것.
         빠진 첫 항목을 콕 집어 알리고 그 칸으로 커서를 옮긴다(원래 신규가입 jaSubmit 방식).
         ⇒ 중간 저장은 안 된다 — 필수를 다 채워야 저장된다(사용자 요청). */
    var fc = function(id){ var e = gel('jd_' + id); if (e) e.focus(); };
    var needChk = [
      ['hospNm',     '병원명을 입력하세요.'],
      ['hospCeo',    '대표자를 입력하세요.'],
      ['hospTel',    '전화번호를 입력하세요.'],
      ['hospAddr',   '주소를 입력하세요.'],
      ['ocsCompany', '전산프로그램명을 입력하세요.'],
      ['ocsUserId',  '전산프로그램 ID 를 입력하세요.'],
      ['ocsUserPw',  '전산프로그램 PW 를 입력하세요.'],
      ['hiraCertPw', '심평원 인증서암호를 입력하세요.'],
      ['asqDay',     '환자평가표 작성완료일(매월 N일)을 입력하세요.'],
      ['evalGoal',   '적정성평가 목표점수·등급을 입력하세요.']
    ];
    for (var ck = 0; ck < needChk.length; ck++){
      if (g(needChk[ck][0]) === ''){ box(needChk[ck][1], 'warning'); fc(needChk[ck][0]); return; }
    }
    if (jdConactVal() === ''){ box('희망 서비스(진료비 분석·적정성평가)를 선택하세요.', 'warning'); return; }
    var mgrNms = { '1':'총 관리자', '3':'심사과' };
    for (var gb in mgrNms){
      if (!Object.prototype.hasOwnProperty.call(mgrNms, gb)) continue;
      var mg = function(k){ var e = gel('jd_mgr' + gb + '_' + k); return e ? e.value.trim() : ''; };
      if (mg('Nm') === '' || mg('Tel') === '' || mg('Mail') === ''){
        box('담당자 — ' + mgrNms[gb] + '의 성명·전화번호·이메일을 입력하세요.', 'warning');
        var f1st = ['Nm','Tel','Mail'].filter(function(k){ return mg(k) === ''; })[0];
        var fe = gel('jd_mgr' + gb + '_' + f1st); if (fe) fe.focus();
        return;
      }
    }
    if (SEALNEW ? !SEALNEW.img : !(INFO && INFO.sealImg)){   /* 지우기 상태도 미등록 처리(2026-08-24) */
      box('대표자 도장·사인을 올려 주세요.\n[원격접속·DB접근 / 개인정보 동의] 탭의 [직인 불러오기] 를 눌러 주세요.', 'warning');
      return;
    }
    var data = {
      hospNm:g('hospNm'), hospCeo:g('hospCeo'), busiNum:g('busiNum'),
      hospTel:g('hospTel'), hospFax:g('hospFax'), zipCd:g('zipCd'),
      hospAddr:g('hospAddr'), hospExtradr:g('hospExtradr'), wardcnt:g('wardcnt'),
      /* 2026-08-24 에 신청 화면에서 옮겨 온 항목 */
      ocsCompany:g('ocsCompany'), ocsUserId:g('ocsUserId'), ocsUserPw:g('ocsUserPw'),
      hiraCertPw:g('hiraCertPw'), asqDay:g('asqDay'), asqBigo:g('asqBigo'),
      evalGoal:g('evalGoal'), conactGb:jdConactVal(),
      pcUseGb:g('pcUseGb'), pcUseTime:g('pcUseTime'), pcUseStdt:g('pcUseStdt').replace(/-/g,'')   /* 컬럼 varchar(8)=YYYYMMDD */
    };
    /* 대표자 도장 — 새로 고른 때만 보낸다. 안 보내면 서버 SQL 이 기존 값을 지켜 준다.
       [지우기] 를 눌렀으면 SEALNEW.img 가 빈 문자열이라 역시 안 보낸다(지우기는 화면 표시만). */
    if (SEALNEW && SEALNEW.img){
      data.sealImg  = SEALNEW.img;
      data.sealMime = SEALNEW.mime;
      data.sealNm   = SEALNEW.nm;
    }
    jdMgrData(data);      /* mgrList[n].* */
    jdAgrData(data);      /* agreeList[n].* — 새로 체크한 동의만 */

    gel('jdSaveBtn').disabled = true;
    $.ajax({
      type:'post', url:'/join/joinDocsSave.do', dataType:'json', data:data,
      success:function(d){
        gel('jdSaveBtn').disabled = false;
        if (d.error_code !== '0'){ box(d.error_msg || '수정하지 못했습니다.'); return; }
        EDIT = false;
        SEALNEW = null;   /* 저장됐으니 서버값을 다시 받아 쓴다 */
        jdInfo();
        /* ★2026-08-24 — 표준 ui-message(승인 화면과 동일). 없으면 아래 Swal 폴백 */
        if (window._uiMessageLoaded){
          _alertBox('수정했습니다.<br>바뀐 내용으로 <b>동의서 PDF 를 다시 만들어</b> 올려 주세요.', { icon:'✅' });
          return;
        }
        if (window.Swal){
          Swal.fire({ icon:'success', title:'수정했습니다', width:380,
            html:'<div style="font-size:13px; line-height:1.7;">'
               + '바뀐 내용으로 <b>동의서 PDF 를 다시 만들어</b> 올려 주세요.</div>',
            customClass:{ popup:'jd-swal' }, confirmButtonText:'확인', confirmButtonColor:'#1f5a4b' });
        }
      },
      error:function(){ gel('jdSaveBtn').disabled = false; box('수정하지 못했습니다.'); }
    });
  };

  /* ── 파일 고르기 ────────────────────────────────────────────────── */
  /* 올릴 것 목록 — 만든 PDF 가 있으면 그것이 먼저다 */
  function render(){
    var list = [];
    if (PDF_BLOB) list.push({ name: PDF_NAME, size: PDF_BLOB.size, made: true });
    for (var k = 0; k < PICKED.length; k++) list.push({ name: PICKED[k].name, size: PICKED[k].size });

    if (!list.length){ gel('jdFileList').innerHTML = ''; gel('jdSubmit').disabled = true; return; }
    gel('jdFileList').innerHTML = list.map(function(f, n){
      return '<div style="padding:4px 0;">· ' + esc(f.name)
           + ' <span style="color:#7b8b97;">(' + Math.round(f.size/1024) + 'KB)</span>'
           + (f.made ? ' <span class="jd-ok" style="font-size:12px;">방금 만듦</span>' : '')
           + ' <a href="javascript:void(0);" onclick="jdDel(' + (f.made ? -1 : n - (PDF_BLOB ? 1 : 0)) + ');"'
           + ' style="color:#b23b3b; margin-left:6px;">삭제</a></div>';
    }).join('');
    gel('jdSubmit').disabled = false;
  }
  window.jdDel = function(n){
    if (n < 0){ PDF_BLOB = null; PDF_NAME = ''; } else PICKED.splice(n, 1);
    render();
  };

  function add(list){
    for (var n = 0; n < list.length; n++){
      var f = list[n];
      if (f.size > 20 * 1024 * 1024){ box(esc(f.name) + ' 은 20MB 를 넘습니다.', 'warning'); continue; }
      PICKED.push(f);
    }
    render();
  }

  /* 끌어놓기 자리는 없앴다(PDF 를 화면에서 만들므로).
     따로 만든 파일을 올리고 싶을 때를 대비해, 요소가 있을 때만 연결한다. */
  if (gel('jdDrop')){
    gel('jdDrop').onclick = function(){ gel('jdFile').click(); };
    gel('jdFile').onchange = function(){ add(this.files); this.value = ''; };
    gel('jdDrop').ondragover  = function(e){ e.preventDefault(); this.classList.add('on'); };
    gel('jdDrop').ondragleave = function(){ this.classList.remove('on'); };
    gel('jdDrop').ondrop = function(e){
      e.preventDefault(); this.classList.remove('on');
      if (e.dataTransfer && e.dataTransfer.files) add(e.dataTransfer.files);
    };
  }

  /* ── 제출 : 파일이 올라간 뒤에만 상태를 바꾼다.
        순서를 바꾸면 "제출됨인데 파일이 없는" 상태가 남는다. ─────────── */
  window.jdSubmit = function(){
    if (!REQNO) return;
    /* ★2026-08-24 — 올릴 파일이 없으면 조용히 끝나던 것 → 무엇을 해야 하는지 알려 준다 */
    if (!PICKED.length && !PDF_BLOB){ box('동의서 PDF 를 먼저 만들어 주세요.', 'warning'); return; }
    /* ★2026-08-24 — 제출 전에 <다 채웠는지> 먼저 본다. 서버(joinDocsSubmit)도 같은 검사를 다시 한다.
         수정 모드로 열어 둔 채면 저장부터 하게 막는다(입력칸의 값은 저장 전엔 신청서에 없다). */
    if (EDIT){ box('수정 중입니다. 먼저 [저장] 을 눌러 주세요.', 'warning'); return; }
    /* ★2026-08-24 「도장 안 올렸으면 직인·사인 올리라는 메시지」 — 콕 집어 알린다 */
    if (SEALNEW ? !SEALNEW.img : !(INFO && INFO.sealImg)){   /* 지우기 상태도 미등록 처리(2026-08-24) */
      box('동의서에 찍을 대표자 직인·사인을 올려 주세요.\n[원격접속·DB접근 / 개인정보 동의] 탭의 [직인 불러오기] 로 올릴 수 있습니다.', 'warning');
      return;
    }
    var lack = jdLackSync();
    if (lack && lack.length){ box('아직 비어 있는 항목이 있습니다 — ' + lack[0], 'warning'); return; }

    var go = function(){
      var fd = new FormData();
      if (PDF_BLOB) fd.append('file', PDF_BLOB, PDF_NAME);
      for (var n = 0; n < PICKED.length; n++) fd.append('file', PICKED[n]);
      fd.append('hospCd',  HOSP);
      fd.append('fileGb',  'C');      /* 계약 폴더 — 계약관리 목록에 같이 뜬다 */
      fd.append('notiSeq', '1');
      fd.append('regUser', '');
      fd.append('regIp',   '');

      gel('jdSubmit').disabled = true;
      gel('jdSubmit').innerHTML = '올리는 중…';

      $.ajax({
        type:'post', url:'/sftp/fileupload.do', data:fd,
        processData:false, contentType:false,
        success:function(){
          var nm = (PDF_BLOB ? [PDF_NAME] : []).concat(PICKED.map(function(f){ return f.name; })).join(', ');
          $.ajax({
            type:'post', url:'/join/joinDocsSubmit.do', dataType:'json', data:{ docFileNm: nm },
            success:function(d){
              gel('jdSubmit').innerHTML = '제출';
              if (d.error_code !== '0'){
                gel('jdSubmit').disabled = false;
                box(d.error_msg || '제출하지 못했습니다.');
                return;
              }
              /* ★2026-08-24 — 표준 ui-message. [확인] 을 눌러야 대시보드로 간다
                 (사이드바 잠금은 페이지 로드 때 판정 — 2026-08-19).
                 ⚠바깥 클릭으로 닫으면 이동하지 않는다 — 그때는 F5 로 메뉴가 풀린다. */
              if (window._uiMessageLoaded){
                _alertBox('제출했습니다.<br>이제 <b>프로그램을 사용하실 수 있습니다.</b>',
                          { icon:'✅', onOk:function(){ location.href = '/user/dashboard.do'; } });
                return;
              }
              if (window.Swal){
                Swal.fire({ icon:'success', title:'제출했습니다', width:380,
                  html:'<div style="font-size:13px; line-height:1.7;">'
                     + '이제 <b>프로그램을 사용하실 수 있습니다.</b></div>',
                  customClass:{ popup:'jd-swal' }, confirmButtonText:'확인', confirmButtonColor:'#1f5a4b'
                /* 제출이 끝나면 화면을 다시 연다.
                   사이드바 잠금은 페이지가 뜰 때 한 번 판정하므로, 이 자리에서 다시
                   불러오지 않으면 "제출했는데 메뉴가 그대로"가 된다(2026-08-19). */
                }).then(function(){ location.href = '/user/dashboard.do'; });
              } else { location.href = '/user/dashboard.do'; }
            },
            error:function(){
              gel('jdSubmit').disabled = false; gel('jdSubmit').innerHTML = '제출';
              box('제출하지 못했습니다.');
            }
          });
        },
        error:function(){
          gel('jdSubmit').disabled = false; gel('jdSubmit').innerHTML = '제출';
          box('파일을 올리지 못했습니다. 잠시 후 다시 시도해 주세요.');
        }
      });
    };

    /* ★2026-08-24 — 확인창도 표준 ui-message(승인 화면과 동일). 없으면 Swal→confirm 폴백 */
    if (window._uiMessageLoaded && typeof window._confirmBox === 'function'){
      _confirmBox({ msg:'제출하면 바로 프로그램을 사용하실 수 있습니다.', icon:'📄',
                    okText:'제출', okColor:'blue', onOk:go });
      return;
    }
    if (window.Swal){
      Swal.fire({ icon:'question', title:'동의서 제출',
        html:'<div style="font-size:13px; line-height:1.7;">제출하면 바로 프로그램을 사용하실 수 있습니다.</div>',
        width:380, customClass:{ popup:'jd-swal' },
        showCancelButton:true, confirmButtonText:'제출', cancelButtonText:'취소',
        confirmButtonColor:'#1f5a4b'
      }).then(function(r){ if (r.isConfirmed) go(); });
    } else if (confirm('제출하시겠습니까?')) go();
  };

  /* ── 신청서 만들기 : 서식 3장을 그대로 낸다 ─────────────────────────
     신규가입 화면의 텝 3개(① 컨설팅 의뢰서 ② 원격접속·DB접근 동의서
     ③ 개인정보 수집·이용 동의서)와 같은 구성으로, 한 장씩 나눠 인쇄한다.
     동의서 본문은 TBL_AGREE_MST 의 원문을 그대로 쓴다 — 화면과 문서가
     다른 글을 쓰면 서명받은 문서의 근거가 흔들린다.

     window.open 은 팝업차단에 막혀 숨긴 iframe 으로 띄우고,
     @page margin:0 으로 브라우저가 넣는 날짜·주소 머리말/꼬리말을 없앤다. */
  function jdBuildDoc(){
    if (!INFO){ box('신청내용을 먼저 불러와 주세요.'); return null; }
    var i = INFO;

    var row = function(l1, v1, l2, v2){
      return '<tr><th>' + l1 + '</th><td>' + nv(v1) + '</td>'
           + '<th>' + l2 + '</th><td>' + nv(v2) + '</td></tr>';
    };
    var wide = function(l, v){
      return '<tr><th>' + l + '</th><td colspan="3">' + nv(v) + '</td></tr>';
    };

    var addr = (i.zipCd ? '(' + esc(i.zipCd) + ') ' : '')
             + esc(i.hospAddr || '') + ' ' + esc(i.hospExtradr || '');

    var pcTxt = i.pcUseGb === '1' ? '단독사용 가능'
              : i.pcUseGb === '2' ? '단독사용 불가' + (i.pcUseTime ? ' (' + esc(i.pcUseTime) + ')' : '')
              : i.pcUseGb === '3' ? '사용시작일 지정' + (i.pcUseStdt ? ' (' + esc(i.pcUseStdt) + ')' : '')
              : '';
    var svcTxt = i.conactGb === '1' ? '진료비 분석'
               : i.conactGb === '2' ? '적정성 평가'
               : i.conactGb === 'A' ? '진료비 분석 · 적정성 평가' : '';

    var mgr = MGRS.length
      ? MGRS.map(function(m){
          return '<tr><td>' + nv(m.mgrGbNm || m.mgrGb) + '</td><td>' + nv(m.deptNm) + '</td>'
               + '<td>' + nv(m.jobNm) + '</td><td>' + nv(m.mgrNm) + '</td>'
               + '<td>' + nv(m.mgrTel) + '</td><td>' + nv(m.mgrEmail || m.email) + '</td></tr>';
        }).join('')
      : '<tr><td colspan="6">담당자 없음</td></tr>';

    var seal = i.sealImg
      ? '<img class="seal" src="data:' + (i.sealMime || 'image/png') + ';base64,' + i.sealImg + '">'
      : '<span class="noseal">(서명 또는 인)</span>';

    var today = (i.cfmDttm || i.reqDttm || '').substring(0, 10);

    /* 서명란 — 의뢰서 서식 그대로.
       문구 / 날짜(년·월·일) / 왼쪽 두 줄(요양기관명·주소) + 오른쪽 대표자(인) 세로병합 /
       「위너넷 귀하」. 신규가입 화면(join_apply.jsp)의 .ja-sign 과 같은 배치다. */
    var ymd = String(today || '').split('-');
    var signBlock = function(txt){
      return '<div class="sg-txt">' + esc(txt) + '</div>'
           + '<div class="sg-date">' + nv(ymd[0]) + '년 &nbsp;&nbsp;' + nv(ymd[1])
           + '월 &nbsp;&nbsp;' + nv(ymd[2]) + '일</div>'
           + '<table class="ja-sheet sg-box">'
           + '<colgroup><col style="width:110px;"><col>'
           + '<col style="width:90px;"><col style="width:26%;"></colgroup>'
           + '<tr>'
           + '<th>요양기관명</th><td>' + nv(i.hospNm) + '</td>'
           + '<th rowspan="2">대표자</th>'
           + '<td rowspan="2" class="sg-ceo">' + nv(i.hospCeo)
           + '<span class="sg-sealbox">' + seal + '</span></td>'
           + '</tr>'
           + '<tr><th>주&nbsp;&nbsp;&nbsp;&nbsp;소</th><td>' + addr + '</td></tr>'
           + '</table>'
           + '<div class="sg-to">위너넷 &nbsp;귀하</div>';
    };

    /* ② ③ 동의서 — 본문 + 동의여부 + 서명 */
    var agreePage = function(a, no){
      var body = a.contents
        ? '<div class="body">' + esc(a.contents) + '</div>'
        : '<div class="body empty">본문이 등록되어 있지 않습니다.</div>';
      return '<div class="page">'
           + '<h1>' + esc(a.agreeNmTxt || a.agreeCd) + '</h1>'
           + '<div class="sub">' + (a.essYn === 'Y' ? '필수 동의' : '선택 동의')
           + ' · 버전 ' + esc(a.verNo == null ? '1' : a.verNo) + '</div>'
           + body
           + '<table class="ja-sheet agr"><tr>'
           + '<th style="width:120px;">동의 여부</th>'
           + '<td>' + (a.agreeYn === 'Y' ? '<b>동의합니다</b>' : '동의하지 않습니다')
           + '</td>'
           + '<th style="width:100px;">동의일시</th><td>' + nv(a.agreeDttm) + '</td>'
           + '</tr></table>'
           + ''
           + signBlock('위와 같이 ' + (a.agreeNmTxt || '') + ' 내용에 동의합니다.')
           + '</div>';
    };

    var pages = '';

    /* ── 1장 : 컨설팅 의뢰서 — 신규가입 화면의 .ja-sheet 서식 그대로 ──
       라벨칸(th) + 값칸(td) 3쌍, 필수는 라벨에 빨간 * 와 노란 바탕.
       화면에서 입력하던 자리에 값이 들어간 모양이라 서식과 나란히 놓아도 같다. */
    var q = function(v){ return (v == null || v === '') ? '' : esc(v); };
    var TH  = function(l, rq){ return '<th>' + l + (rq ? ' <span class="rq">*</span>' : '') + '</th>'; };
    var TD  = function(v, rq, span){
      return '<td' + (span ? ' colspan="' + span + '"' : '') + (rq ? ' class="must"' : '') + '>'
           + q(v) + '</td>';
    };
    var cell = function(l, v, rq){ return TH(l, rq) + TD(v, rq); };

    pages +=
        '<div class="page">'
      + '<h1>위너넷 적정성 컨설팅 의뢰서</h1>'
      + '<div class="sub">신규병원 가입신청서</div>'

      + '<table class="ja-sheet"><colgroup>'
      + '<col style="width:132px;"><col><col style="width:118px;"><col>'
      + '<col style="width:100px;"><col></colgroup><tbody>'

      + '<tr>' + cell('병원명', i.hospNm, 1)
              + cell('요양기관기호', i.hospCd, 1)
              + cell('전화번호', i.hospTel, 1) + '</tr>'

      + '<tr>' + TH('주소', 1) + TD(addr, 1, 5) + '</tr>'

      + '<tr>' + cell('대표자', i.hospCeo, 1)
              + cell('사업자등록번호', i.busiNum)
              + cell('FAX', i.hospFax) + '</tr>'

      + '<tr>' + cell('병상수', i.wardcnt)
              + TH('희망 서비스') + TD(svcTxt, 0, 3) + '</tr>'

      + '<tr><th class="grp" colspan="6">전산프로그램 정보 (MASTER)</th></tr>'
      + '<tr>' + cell('프로그램명', i.ocsCompany, 1)
              + cell('프로그램 ID', i.ocsUserId)
              + cell('PC 사용여부', pcTxt) + '</tr>'
      + '<tr>' + TH('심평원 인증서암호', 1) + TD(i.hiraCertPw, 1, 5) + '</tr>'

      + '<tr><th class="grp" colspan="6">평가 일정</th></tr>'
      + '<tr>' + cell('환자평가표 작성완료일', i.asqDay ? '매월 ' + i.asqDay + '일' : '', 1)
              + cell('적정성평가 목표', i.evalGoal, 1)
              + cell('작성 비고', i.asqBigo) + '</tr>'


      + '</tbody></table>'

      + '<h2>담당자</h2>'
      + '<table class="ja-sheet"><tbody>'
      + '<tr><th style="width:90px;">구분</th><th style="width:100px;">부서</th>'
      + '<th style="width:90px;">직책</th><th style="width:90px;">성명</th>'
      + '<th style="width:115px;">전화번호</th><th>이메일 주소</th></tr>' + mgr
      + '</tbody></table>'


      /* 접수담당자 — 담당자 표 아래, 비고 위(2026-08-19 요청) */
      + '<h2>접수담당자 (신청자)</h2>'
      + '<table class="ja-sheet"><colgroup>'
      + '<col style="width:132px;"><col><col style="width:118px;"><col></colgroup><tbody>'
      + '<tr>' + cell('성명', i.mbrNm, 1) + cell('직책', i.jobNm) + '</tr>'
      + '<tr>' + cell('연락처', i.mbrTel, 1) + cell('접수일시', i.reqDttm) + '</tr>'
      + '<tr>' + TH('이메일 (로그인 ID)', 1) + TD(i.email, 1, 3) + '</tr>'
      + '</tbody></table>'
      + '<h2>비고</h2>'
      + '<div class="memo">' + q(i.bigo) + '</div>'
      + '</div>';

    /* ── 2·3장 : 동의서 ───────────────────────────────────────── */

    for (var n = 0; n < AGREE.length; n++) pages += agreePage(AGREE[n], n + 2);
    var html =
        '<html><head><meta charset="utf-8"><title>동의서</title><style>'
      + '@page{ size:A4; margin:0; }'
      + 'body{ font-family:"맑은 고딕","Malgun Gothic",sans-serif; font-size:12px; color:#000;'
      + '      margin:0; background:#fff; }'
      + '.page{ padding:15mm 14mm; page-break-after:always; break-after:page; }'
      + '.page:last-child{ page-break-after:auto; break-after:auto; }'
      + 'h1{ font-size:19px; text-align:center; margin:0 0 4px; letter-spacing:3px; }'
      + '.sub{ text-align:center; font-size:11px; color:#555; margin-bottom:12px; }'
      + 'h2{ font-size:12.5px; margin:13px 0 5px; }'
      + 'table{ width:100%; border-collapse:collapse; }'
      + 'th,td{ border:1px solid #000; padding:5px 7px; font-size:11px; text-align:center;'
      + '       word-break:break-all; }'
      + 'th{ background:#f2f2f2; }'
      + 'table.ja-sheet{ table-layout:fixed; margin-bottom:4px; }'
      + 'table.ja-sheet th{ background:#eef2f5; text-align:left; font-weight:700;'
      + ' color:#3a4a53; padding:5px 8px; white-space:normal; line-height:1.35; }'
      + 'table.ja-sheet th.grp{ background:#dde5ea; text-align:center; }'
      + 'table.ja-sheet td{ text-align:left; padding:5px 7px; height:22px; }'
      + 'table.ja-sheet td.must{ background:#fff6c9; }'
      + '.rq{ color:#d9534f; font-weight:900; }'
      + '.body{ border:1px solid #000; padding:9px 11px; font-size:10.5px; line-height:1.75;'
      + '       white-space:pre-wrap; height:150mm; overflow:hidden; }'
      + '.body.empty{ color:#777; height:auto; }'
      + 'table.agr{ margin-top:10px; }'
      + 'table.agr td{ text-align:left; }'
      + '.note{ margin-top:12px; font-size:11px; line-height:1.9; }'
      + '.memo{ border:1px solid #000; padding:9px 11px; font-size:11px; line-height:1.8;'
      + ' min-height:26mm; white-space:pre-wrap; }'
      + '.sg-txt{ margin-top:16px; font-weight:700; }'
      + '.sg-date{ margin:8px 0 9px; letter-spacing:1px; }'
      + 'table.sg-box td{ text-align:left; height:34px; }'
      + 'td.sg-ceo{ height:64px; vertical-align:middle; position:relative; }'
      + '.sg-sealbox{ float:right; margin-right:6px; }'
      + '.sg-to{ margin-top:10px; font-weight:700; }'
      + '.seal{ width:80px; height:auto; vertical-align:middle; }'
      + '.noseal{ color:#555; }'
      + '</style></head><body>' + pages + '</body></html>';

    return { html: html, pages: pages };
  }

  /* ── 미리보기 · 인쇄 : 숨긴 iframe 으로 띄운다 ──────────────────────
     window.open 은 팝업차단에 막힌다. @page margin:0 으로 브라우저가 넣는
     날짜·주소 머리말/꼬리말을 없앤다. */
  window.jdPrint = function(){
    var d = jdBuildDoc(); if (!d) return;
    var fr = gel('jdPrintFrame');
    var doc = fr.contentWindow.document;
    doc.open(); doc.write(d.html); doc.close();
    setTimeout(function(){ fr.contentWindow.focus(); fr.contentWindow.print(); }, 400);
  };

  /* ── 동의서 PDF 만들기 ──────────────────────────────────────────
     월간보고서와 같은 방식이다 — 화면 밖에 문서를 그려 html2canvas 로 장마다
     캡처하고 jsPDF 로 A4 에 얹는다. 서버에 만들 필요도, 인쇄해서 스캔할 필요도 없다.
     도장은 신규가입 때 등록한 이미지가 문서에 이미 들어가 있다. */
  /* ── 만든 PDF 미리보기 ─────────────────────────────────────────
     월간보고서와 같은 흐름이다 — 만들고 눈으로 확인한 뒤 그 자리에서 올린다.
     blob URL 은 닫을 때 반드시 해제한다(안 하면 메모리에 남는다). */
  var PV_URL = null;

  function jdPvOpen(){
    if (!PDF_BLOB) return;
    if (PV_URL) URL.revokeObjectURL(PV_URL);
    PV_URL = URL.createObjectURL(PDF_BLOB);
    gel('jdPvNm').innerHTML = esc(PDF_NAME) + ' · ' + Math.round(PDF_BLOB.size/1024) + 'KB';
    gel('jdPvFrame').src = PV_URL;
    gel('jdPv').style.display = 'flex';
  }

  window.jdPvClose = function(){
    gel('jdPv').style.display = 'none';
    gel('jdPvFrame').src = 'about:blank';
    if (PV_URL){ URL.revokeObjectURL(PV_URL); PV_URL = null; }
  };

  window.jdPvSubmit = function(){ jdPvClose(); jdSubmit(); };

  window.jdMakePdf = function(){
    /* ★2026-08-24 「도장·PDF 안 올리면 오류 메시지」 — 미완성 상태로 만들면
         (인) 자리가 빈 PDF 가 조용히 만들어졌다. 남은 항목을 알려 주고 막는다. */
    if (EDIT){ box('수정 중입니다. 먼저 [저장] 을 눌러 주세요.', 'warning'); return; }
    /* ★2026-08-24 「도장 안 올렸으면 직인·사인 올리라는 메시지」 — 콕 집어 알린다 */
    if (SEALNEW ? !SEALNEW.img : !(INFO && INFO.sealImg)){   /* 지우기 상태도 미등록 처리(2026-08-24) */
      box('동의서에 찍을 대표자 직인·사인을 올려 주세요.\n[원격접속·DB접근 / 개인정보 동의] 탭의 [직인 불러오기] 로 올릴 수 있습니다.', 'warning');
      return;
    }
    var lack = jdLackSync();
    if (lack && lack.length){
      box('아직 비어 있는 항목이 있습니다 — ' + lack.slice(0, 3).join(' · ')
        + (lack.length > 3 ? ' 외 ' + (lack.length - 3) + '건' : ''), 'warning');
      return;
    }

    var d = jdBuildDoc(); if (!d) return;

    if (!window.jspdf || typeof html2canvas === 'undefined'){
      box('PDF 생성 라이브러리를 불러오지 못했습니다.', 'error'); return;
    }

    var btn = gel('jdMakeBtn');
    btn.disabled = true; btn.innerHTML = '만드는 중…';

    var box0 = gel('jdDocBox');
    box0.innerHTML =
        '<style>' + d.html.replace(/^[\s\S]*<style>/, '').replace(/<\/style>[\s\S]*$/, '') + '</style>'
      + d.pages;

    var sheets = box0.querySelectorAll('.page');
    var jsPDF = window.jspdf.jsPDF, pdf = new jsPDF('p', 'mm', 'a4');
    var W = 210, H = 297, n = 0;

    var next = function(){
      if (n >= sheets.length){
        try {
          PDF_BLOB = pdf.output('blob');
          PDF_NAME = '동의서_' + (INFO.hospCd || '') + '_' + (INFO.reqNo || '') + '.pdf';
          PICKED = [];                       // 직접 고른 파일보다 방금 만든 것이 우선이다
          render();
          jdPvOpen();
        } catch (e) {
          box('PDF 를 만들지 못했습니다.', 'error');
        }
        box0.innerHTML = '';
        btn.disabled = false; btn.innerHTML = '동의서 PDF 만들기';
        return;
      }

      html2canvas(sheets[n], { scale: 2, backgroundColor: '#ffffff', useCORS: true, scrollX: 0, scrollY: 0,   /* 스크롤 상태 캡처 밀림 방지(2026-08-24) */
                               width: sheets[n].offsetWidth, windowWidth: sheets[n].offsetWidth })
        .then(function(cv){
          var img = cv.toDataURL('image/jpeg', 0.92);
          var h = cv.height * W / cv.width;
          if (n > 0) pdf.addPage();
          pdf.addImage(img, 'JPEG', 0, 0, W, Math.min(h, H));
          n++; next();
        })
        .catch(function(){
          box0.innerHTML = '';
          btn.disabled = false; btn.innerHTML = '동의서 PDF 만들기';
          box('PDF 를 만들지 못했습니다.', 'error');
        });
    };
    next();
  };

  jdInfo();
})();
</script>

</div><%-- /jdZoomBox --%>

<%-- PDF 생성용 : A4 실제 폭(210mm)으로 그려야 인쇄와 같은 줄바꿈이 된다.
     ★2026-08-24 「PDF 우측 이동·잘림」 — 이 상자가 jdZoomBox(zoom 1.1) <안>에 있어서
       실제 렌더 폭이 210mm×배율이 되고, html2canvas 는 210mm 만 떠서 오른쪽이 잘렸다.
       zoom 영역 <밖>에 둔다. 화면 밖(left:-9999px)이라 사용자에겐 안 보인다. --%>
<div id="jdDocBox" style="position:fixed; left:-9999px; top:0; width:210mm; background:#fff;"></div>

<script>
/* ★[2026-08-20 요청] 글자 축소·확대 — 가입신청(joinReq.jsp jrZoom)과 **같은 규칙**으로 맞춘다.
     한 번에 0.1 · 0.8~1.6 · 기본 1.1 · [↺]는 기본값으로 · 이 PC 이 브라우저에만 기억.
   ★CSS 가 px 라 뿌리 font-size 로는 표 칸이 안 따라 커진다 ⇒ `zoom` 으로 통째로 키운다(같은 이유·같은 방법). */
(function(){
  var KEY = 'wnnJoinDocsZoom', Z_MIN = 0.8, Z_MAX = 1.6, Z_DEF = 1.1;
  function box(){ return document.getElementById('jdZoomBox'); }
  function apply(z){
    z = Math.min(Z_MAX, Math.max(Z_MIN, z));
    var b = box(); if (b) b.style.zoom = z.toFixed(2);
    return z;
  }
  window.jdZoom = function(d){
    var b = box();
    var cur = parseFloat(b && b.style.zoom) || Z_DEF;
    if (d === 0) { apply(Z_DEF); try { localStorage.removeItem(KEY); } catch (ignore) {} return; }
    var z = apply(cur + d * 0.1);
    try { localStorage.setItem(KEY, String(z)); } catch (ignore) {}
  };
  function init(){
    var z = NaN;
    try { z = parseFloat(localStorage.getItem(KEY)); } catch (ignore) {}
    apply(z || Z_DEF);          // 저장해 둔 개인 설정이 없으면 기본(한 단계 큰) 크기로 시작
  }
  if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', init);
  else init();
})();
</script>

</div>
</div>
