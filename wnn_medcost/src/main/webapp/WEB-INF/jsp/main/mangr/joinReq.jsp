<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<script src="/asset/js/ui-message.js"></script>

<%-- joinReq.jsp — 신규병원 가입신청 확인·승인 (위너넷 관리자) 2026-08-19 / wnn_consult
     · 신청은 wnn_consult 로그인 화면의 [신규병원 가입신청]에서 들어온다. 여기서 확인·승인한다.
     · ★위너넷 관리자(MAIN_GU='1') 전용 — 메뉴도 감추지만 컨트롤러에서도 막는다.
     · 화면은 QPS 개념 : #joinReq 로 스코프 잡은 CSS · 목록/상세 2단 · 글자 크기 조절.
     · ★[반드시 유지] .dashboard-wrapper 로 감싼다 — sidebar.jsp 가 이 클래스에만 margin-left 를 준다.
       빼면 화면 왼쪽이 좌측 메뉴에 가려진다(scrollX 는 0이라 “밀림”으로 오진하기 쉽다).
     · ★주의: 이 파일 안에서 Deferred EL 표기(샵+중괄호) 금지 — 변환에러로 content 타일이 빈 화면이 된다 --%>

<div class="dashboard-wrapper">
<div id="joinReq" data-gu="<c:out value='${sessionScope.s_main_gu}'/>">
<style>
  #joinReq{ background:#f4f6f8; color:#1f2a30; min-height:100%; padding:14px 16px 50px; font-family:inherit;
            max-width:100%; overflow-x:hidden; }
  #joinReq *{ box-sizing:border-box; }

  #joinReq .jr-head{ display:flex; align-items:center; gap:10px; margin-bottom:12px; flex-wrap:wrap; }
  #joinReq .jr-title{ font-size:18px; font-weight:800; color:#20303a; display:flex; align-items:center; gap:8px; }
  #joinReq .jr-dot{ width:10px; height:10px; border-radius:50%; background:linear-gradient(135deg,#1f5a4b,#2a7665); }
  #joinReq .jr-sub{ font-size:12px; color:#6b7c86; }
  #joinReq .jr-spacer{ flex:1; }
  #joinReq .jr-zoom{ display:inline-flex; gap:4px; align-items:center; }
  #joinReq .jr-zoom button{ border:1px solid #cfd9e0; background:#fff; color:#43555f; border-radius:6px;
                            padding:4px 9px; font-size:13px; font-weight:700; cursor:pointer; }
  #joinReq .jr-zoom button:hover{ background:#eef3f6; }

  #joinReq .jr-btn{ border:1px solid #1f5a4b; background:#1f5a4b; color:#fff; border-radius:6px;
      padding:6px 14px; font-size:13px; font-weight:600; cursor:pointer; white-space:nowrap; }
  #joinReq .jr-btn.ghost{ background:#fff; color:#1f5a4b; }
  /* 반려는 되돌릴 수 없다. 승인 바로 옆에 비슷한 모양으로 두면 눌러야 할 것을 잘못 누른다
     (2026-08-19 "승인 눌렀는데 반려창" 신고). 색을 확실히 나누고 사이를 벌린다. */
  #joinReq .jr-btn.warn{ background:#fff; color:#b23b3b; border:1px solid #b23b3b; }
  #joinReq #jrCfmBtn{ margin-right:26px; }
  /* 버튼 크기를 서로 맞춘다(2026-08-19) — 닫기만 작으면 눌러야 할 것이 헷갈린다 */
  #joinReq .jr-card h4 .jr-btn{ min-width:84px; text-align:center; }
  #joinReq .jr-btn.mini{ padding:3px 10px; font-size:11.5px; border-color:#cfd8e0; color:#556570; background:#fff; }
  #joinReq .jr-btn:hover{ opacity:.9; }

  #joinReq .jr-bar{ display:flex; gap:8px; align-items:center; flex-wrap:wrap; margin-bottom:10px; }
  #joinReq select, #joinReq input[type=text]{ border:1px solid #cfd8e0; border-radius:6px; padding:5px 9px;
      font-family:inherit; font-size:13px; background:#fff; }

  #joinReq .jr-card{ background:#fff; border:1px solid #e3e9ed; border-radius:10px; padding:13px 15px; margin-bottom:12px; }
  #joinReq .jr-card h4{ margin:0 0 10px; font-size:14px; font-weight:800; color:#1f5a4b;
                        display:flex; align-items:center; gap:6px; flex-wrap:wrap; }
  #joinReq .jr-card h4 .hint{ font-weight:500; font-size:12px; color:#8a99a3; }
  #joinReq .jr-card h4 .hint{ margin-right:14px; }

  /* 목록 */
  #joinReq table.jr-grid{ width:100%; border-collapse:collapse; font-size:13px; }
  #joinReq table.jr-grid th, #joinReq table.jr-grid td{ border:1px solid #e0e6ea; padding:6px 8px; text-align:center; }
  #joinReq table.jr-grid th{ background:#f2f6f8; font-weight:700; color:#43555f; white-space:nowrap; }
  #joinReq table.jr-grid td.l{ text-align:left; }
  #joinReq table.jr-grid tbody tr{ cursor:pointer; }
  #joinReq table.jr-grid tbody tr:hover td{ background:#eef6f3; }
  #joinReq table.jr-grid tbody tr.sel td{ background:#e7f3ee; }
  #joinReq .jr-scroll{ max-width:100%; overflow-x:auto; }
  #joinReq .jr-empty{ color:#8a99a3; font-size:12.5px; padding:22px 6px; text-align:center; }

  /* 상태 배지 */
  #joinReq .st{ display:inline-block; border-radius:12px; padding:2px 10px; font-size:11.5px; font-weight:800; white-space:nowrap; }
  #joinReq .st.s10{ background:#e7f0fb; color:#2f5c96; }
  #joinReq .st.s20{ background:#fff3d9; color:#8a6d00; }
  #joinReq .st.s30{ background:#e7f3ee; color:#1f5a4b; }
  #joinReq .st.s40{ background:#eef7f2; color:#1f5a4b; border:1px solid #cfe6da; }
  #joinReq .st.s90{ background:#fdeaea; color:#a33; }

  /* 상세 : 의뢰서와 같은 라벨칸+값칸 표 */
  #joinReq table.jr-sheet{ width:100%; border-collapse:collapse; font-size:12.5px; table-layout:fixed; }
  #joinReq table.jr-sheet th{ background:#eef2f5; border:1px solid #c8d2d9; padding:5px 9px;
      text-align:left; font-weight:700; color:#3a4a53; white-space:nowrap; }
  #joinReq table.jr-sheet td{ border:1px solid #c8d2d9; padding:5px 9px; color:#20303a; word-break:break-all; }
  #joinReq .jr-seal{ max-width:90px; max-height:90px; border:1px solid #e0e6ea; background:#fff; }
  #joinReq .jr-none{ color:#8a99a3; }
  #joinReq .jr-detail{ display:none; }
  #joinReq .jr-detail.on{ display:block; }

  /* ── 상단 고정 · 하단만 스크롤 (2026-08-19 요청) ─────────────────────
     목록에서 다른 건을 고를 때마다 페이지 전체가 오르내리면 목록을 다시 찾아야 한다.
     검색·목록은 제자리에 두고 상세만 자체 스크롤시킨다.
     높이는 vh 에서 상단(검색+목록+여백)을 뺀 값 — 목록이 길어지면 아래에서 다시 잰다. */
  #joinReq{ display:flex; flex-direction:column; height:calc(100vh - 92px);
            overflow:hidden; padding-bottom:14px; }
  #joinReq #jrZoomBox{ display:flex; flex-direction:column; flex:1 1 auto; min-height:0; }
  #joinReq .jr-top{ flex:0 0 auto; }
  #joinReq .jr-detail.on{ flex:1 1 auto; overflow-y:auto; overflow-x:hidden;
            padding-right:4px; scrollbar-width:thin; }
  #joinReq .jr-detail.on::-webkit-scrollbar{ width:9px; }
  #joinReq .jr-detail.on::-webkit-scrollbar-thumb{ background:#c8d3db; border-radius:5px; }
  /* 목록이 많아도 상단이 화면을 다 먹지 않게 */
  #joinReq .jr-scroll{ max-height:38vh; overflow-y:auto; }
  #joinReq .jr-grid thead th{ position:sticky; top:0; z-index:2; }
</style>

<div class="jr-head">
  <div class="jr-title"><span class="jr-dot"></span>신규병원 가입신청
    <span class="jr-sub">위너넷 관리자 전용 — 신청 확인 후 승인하면 병원·계약을 등록한다</span>
  </div>
  <div class="jr-spacer"></div>
  <span class="jr-zoom">
    <button type="button" onclick="jrZoom(-1);" title="글자 작게">가－</button>
    <button type="button" onclick="jrZoom(1);"  title="글자 크게">가＋</button>
    <button type="button" onclick="jrZoom(0);"  title="처음 크기로">↺</button>
  </span>
</div>

<div id="jrZoomBox">

  <div class="jr-top">
  <div class="jr-card">
    <div class="jr-bar">
      <%-- ★[2026-08-20 요청] 기본은 **전체 상태** — 사용자가 고르지 않는 한 걸러 두지 않는다.
           종전 기본이 「접수」라 ***승인하는 순간 그 줄이 목록에서 사라져*** "없어졌다/안 된다" 로 읽혔다.
           (계약관리에 다녀오거나 화면을 다시 열 때도 접수만 보였다.) --%>
      <select id="jrStat" onchange="jrList();">
        <option value="" selected>전체 상태</option>
        <option value="10">접수</option>
        <option value="20">검토중</option>
        <option value="30">승인</option>
        <option value="40">동의서제출</option>
        <option value="90">반려</option>
      </select>
      <input type="text" id="jrKey" placeholder="요양기관기호 · 병원명 · 이메일" style="width:260px;"
             onkeydown="if(event.keyCode===13) jrList();">
      <button type="button" class="jr-btn" onclick="jrList();">조회</button>
      <span class="jr-sub" id="jrCnt"></span>
    </div>

    <div class="jr-scroll">
      <table class="jr-grid">
        <colgroup>
          <col style="width:70px;"><col style="width:108px;"><col style="width:110px;"><col>
          <col style="width:110px;"><col style="width:130px;"><col style="width:180px;">
          <col style="width:70px;"><col style="width:130px;"><col style="width:96px;">
        </colgroup>
        <thead>
          <%-- ★[2026-08-20] 「계약」 칸 신설 — 승인된 줄에서 **목록에서 바로** 계약관리로 간다.
               종전에는 단추가 상세 패널 안에만 있어, 목록만 보고 "그런 기능이 없다"고 읽혔다. --%>
          <tr><th>신청번호</th><th>상태</th><th>요양기관기호</th><th>병원명</th><th>대표자</th>
              <th>전화번호</th><th>신청자 이메일</th><th>도장</th><th>신청일시</th><th>계약</th></tr>
        </thead>
        <tbody id="jrBody">
          <tr><td colspan="10" class="jr-empty">조회를 눌러 주세요.</td></tr>
        </tbody>
      </table>
    </div>
  </div>
  </div>

  <div class="jr-detail" id="jrDetail">
    <div class="jr-card">
      <h4>신청 내용 <span class="hint" id="jrDetailSub"></span>
        <span class="jr-spacer"></span>
        <%-- 승인/반려는 접수(10)·검토중(20) 일 때만 보인다. 이미 처리된 건은 버튼이 없다. --%>
        <button type="button" class="jr-btn"      id="jrCfmBtn" onclick="jrConfirm();" style="display:none;">승인</button>
        <button type="button" class="jr-btn warn" id="jrRjtBtn" onclick="jrReject();"  style="display:none;">반려</button>
        <%-- ★[2026-08-20 요청] 승인된 건은 여기서 바로 [계약관리]로 간다 —
             종전에는 "계약은 [계약관리] 화면에서 등록합니다" 라고 글로만 안내해 사용자가 메뉴를 다시 찾아
             그 병원을 검색해야 했다. 이 단추는 그 병원을 **미리 골라 둔 채로** 계약관리를 연다. --%>
        <button type="button" class="jr-btn" id="jrContBtn" onclick="jrGoCont();" style="display:none;">계약정보 입력</button>
        <button type="button" class="jr-btn warn" id="jrRbkBtn" onclick="jrRollback();" style="display:none;">승인취소</button>
        <button type="button" class="jr-btn ghost" id="jrRjtCancelBtn" onclick="jrRjtCancel();" style="display:none;">반려취소</button>
        <button type="button" class="jr-btn warn" id="jrCancelBtn" onclick="jrReqCancel();" style="display:none;">가입취소</button>
        <button type="button" class="jr-btn ghost" onclick="jrClose();">닫기</button>
      </h4>
      <div id="jrDone" style="display:none; margin-bottom:9px; font-size:12.5px;"></div>
      <div id="jrInfo"></div>
    </div>

    <div class="jr-card">
      <h4>담당자</h4>
      <div class="jr-scroll"><div id="jrMgr"></div></div>
    </div>

    <div class="jr-card">
      <h4>동의 내역 <span class="hint">동의 시점의 본문 버전·IP 가 함께 남는다</span></h4>
      <div id="jrAgree"></div>
    </div>
  </div>

</div><%-- /jrZoomBox --%>
</div><%-- /joinReq --%>

<%-- ══════════════════════════════════════════════════════════════════════════
     계약정보 입력창                                                  2026-08-21
     ★[요청] 계약 입력을 **계약관리(hospcd.jsp)로 넘기지 않는다** — 여기서 바로 넣는다.
       종전에는 /user/hospcd.do 로 화면을 옮겨 그 병원을 고르고 모달을 열었는데
       ①보던 신청을 잃고 ②계약관리 화면의 그리드·패널 준비에 매달려 "못 찾아간다"가 반복됐다.
     · 계약은 **두 가지를 한 창에서 함께** 넣는다 — 적정성평가 · 진료비 분석.
       (TBL_HOSPCONT_MST 는 CONACT_GB 별로 한 행. 구분 코드·이름은 공통코드에서 받아 온다)
     · **전산프로그램 정보(프로그램명·ID·PW)는 신청서에서 끌어온다** —
       신청 때 이미 받은 값(TBL_JOIN_REQ.OCS_*)을 계약(TBL_HOSPCONT_MST.OCS_*)에 옮겨
       적던 수작업을 없앤다.
     · ★서버는 손대지 않았다 — 계약관리가 쓰던 것을 그대로 쓴다(JSP 교체만으로 반영된다) :
       /user/hospCdList.do · /user/hospContList.do · /user/hospContInsert.do ·
       /user/hospContUpdate.do · /user/hospContDelete.do · /base/commList.do
     ═════════════════════════════════════════════════════════════════════════ --%>
<div id="jrcMask" style="display:none;">
<style>
  /* 위너넷 고정요소(자주쓰는메뉴 12000 · 문의버튼 12000 · 오늘의평가 9999) 보다 위여야 한다 */
  /* ⚠Swal(확인·알림창)은 기본 z-index 1060 — 이 창(12500) 뒤에 깔려 안 보인다.
     저장 확인창이 누를 수 없게 숨으므로 반드시 이 창보다 위로 올린다(화면 전체 공통 — 무해). */
  body .swal2-container{ z-index:13000 !important; }
  #jrcMask{ position:fixed; inset:0; background:rgba(20,32,38,.45); z-index:12500;
            display:flex; align-items:center; justify-content:center; }
  #jrcMask *{ box-sizing:border-box; font-family:inherit; }
  #jrcMask .jrc-win{ background:#f4f6f8; width:min(820px, 96vw); max-height:92vh;
            border-radius:10px; box-shadow:0 12px 40px rgba(0,0,0,.35); display:flex; flex-direction:column; }
  #jrcMask .jrc-head{ display:flex; align-items:center; gap:10px; flex-wrap:wrap;
            padding:11px 14px; background:#1f5a4b; color:#fff; border-radius:10px 10px 0 0; }
  #jrcMask .jrc-t{ font-size:15px; font-weight:800; }
  #jrcMask .jrc-hosp{ font-size:13px; opacity:.95; }
  #jrcMask .jrc-cd{ background:rgba(255,255,255,.18); border-radius:10px; padding:1px 8px; font-size:12px; margin-left:5px; }
  #jrcMask .jrc-sp{ flex:1; }
  #jrcMask .jrc-btn{ border:1px solid #fff; background:#fff; color:#1f5a4b; border-radius:6px;
            padding:6px 16px; font-size:13px; font-weight:700; cursor:pointer; min-width:76px; }
  #jrcMask .jrc-btn.ghost{ background:transparent; color:#fff; }
  #jrcMask .jrc-btn:disabled{ opacity:.5; cursor:not-allowed; }
  #jrcMask .jrc-body{ padding:12px 14px 16px; overflow-y:auto; }

  #jrcMask .jrc-none{ color:#8a99a3; }

  /* ★[2026-08-21] 두 계약을 좌우 나열 → 탭으로 분리(사용자 지시 「두 개 탭을 분리」).
     ⚠숨은 탭의 입력칸도 DOM 에 그대로 있다 — 저장(jrcSave)은 종전대로 두 구분을 함께 본다. */
  #jrcMask .jrc-cols{ display:block; }
  #jrcMask .jrc-tabs{ display:flex; gap:6px; margin-bottom:10px; }
  #jrcMask .jrc-tab{ border:1px solid #cfd9e0; background:#eef2f5; color:#5a6b76; border-radius:8px;
            padding:9px 22px; font-size:14px; font-weight:700; cursor:pointer;
            display:flex; align-items:center; gap:8px; }
  #jrcMask .jrc-tab.on{ background:#1f5a4b; border-color:#1f5a4b; color:#fff; }
  /* 탭 점 = 그 구분의 「계약 등록/수정」 체크 상태 — 안 보이는 탭이 켜져 있는지 한눈에 */
  #jrcMask .jrc-tdot{ width:9px; height:9px; border-radius:50%; background:#c3ced6; flex:0 0 auto; }
  #jrcMask .jrc-sec{ display:none; background:#fff; border:1px solid #dde5ea; border-radius:9px; overflow:hidden; }
  #jrcMask .jrc-sec.on{ display:block; }
  #jrcMask .jrc-sech{ display:flex; align-items:center; gap:8px; flex-wrap:wrap;
            padding:8px 11px; background:#f2f6f8; border-bottom:1px solid #e2e9ee; }
  #jrcMask .jrc-sech label{ margin:0; font-size:13px; color:#2b3c45; cursor:pointer; display:flex; align-items:center; gap:6px; }
  #jrcMask .jrc-sech b{ font-size:14px; color:#1f5a4b; }
  #jrcMask .jrc-badge{ font-size:11.5px; font-weight:800; border-radius:11px; padding:2px 9px; }
  #jrcMask .jrc-badge.new{ background:#e7f0fb; color:#2f5c96; }
  #jrcMask .jrc-badge.upd{ background:#fff3d9; color:#8a6d00; }
  #jrcMask .jrc-secb{ padding:9px 11px 11px; }
  #jrcMask .jrc-sec.off .jrc-secb{ opacity:.45; }

  #jrcMask table.jrc-tb{ width:100%; border-collapse:collapse; font-size:12.5px; table-layout:fixed; }
  #jrcMask table.jrc-tb th{ background:#f6f8f9; border:1px solid #dde5ea; padding:4px 8px;
            text-align:left; font-weight:700; color:#43555f; width:88px; white-space:nowrap; }
  #jrcMask table.jrc-tb td{ border:1px solid #dde5ea; padding:3px 6px; }
  #jrcMask table.jrc-tb th.grp{ width:auto; background:#eef5f2; color:#1f5a4b; }
  #jrcMask table.jrc-tb th.grp .hint{ font-weight:500; color:#7b8a93; margin-left:6px; }
  #jrcMask table.jrc-tb input[type=text], #jrcMask table.jrc-tb input[type=date], #jrcMask table.jrc-tb select{
            width:100%; border:1px solid #cfd8e0; border-radius:5px; padding:4px 7px;
            font-size:12.5px; background:#fff; color:#20303a; }
  #jrcMask table.jrc-tb input:disabled, #jrcMask table.jrc-tb select:disabled{ background:#f1f4f6; color:#8a99a3; }
  #jrcMask table.jrc-tb label{ margin:0; font-size:12.5px; display:flex; align-items:center; gap:5px; cursor:pointer; }
  #jrcMask .jrc-mini{ border:1px solid #cfd8e0; background:#fff; color:#43555f; border-radius:5px;
            padding:2px 9px; font-size:11.5px; font-weight:700; cursor:pointer; margin-left:6px; }
  #jrcMask .jrc-mini.warn{ border-color:#d3a3a3; color:#a33; }
  #jrcMask .jrc-hist{ font-size:11.5px; color:#7b8a93; margin-top:6px; line-height:1.7; }
  #jrcMask .jrc-hint{ font-size:11.5px; color:#7b8a93; margin-top:7px; line-height:1.7; }
  /* ui-message 알림·확인(.cfm-backdrop, z-10000)이 이 창 오버레이(12500) 뒤에 깔리지 않게 +
     폭 480px(2026-08-21 「좌우 넓히고 위아래 축소」 — 340px 기본에서는 날짜가 줄바꿈된다).
     ⚠ui-message 자체(공용 파일)는 건드리지 않는다 — 이 화면에서만 덮는다. */
  body #confirmBackdrop{ z-index:13000 !important; }
  body #confirmBackdrop .cfm-box{ width:480px; max-width:94vw; padding:20px 24px 16px; }
  body #confirmBackdrop .cfm-icon{ margin-bottom:8px; }
  body #confirmBackdrop .cfm-msg{ margin-bottom:16px; }
  /* _jrAsk 진행 계열 단추(승인·반려취소) — ui-message 기본은 빨강/파랑뿐이라 teal 을 이 화면에서 더한다 */
  .cfm-btn-ok.jr-ok-teal{ background:#1f5a4b; }
  .cfm-btn-ok.jr-ok-teal:hover{ background:#17453a; }
</style>
  <div class="jrc-win">
    <div class="jrc-head">
      <span class="jrc-t">계약정보 입력</span>
      <span class="jrc-hosp" id="jrcHosp"></span>
      <span class="jrc-sp"></span>
      <button type="button" class="jrc-btn" id="jrcSaveBtn" onclick="jrcSave();">저장</button>
      <button type="button" class="jrc-btn ghost" onclick="jrcClose();">닫기</button>
    </div>
    <div class="jrc-body">
      <div class="jrc-cols" id="jrcCols"></div>
      <div class="jrc-hint">
        ※ 프로그램 사용기간은 <b>승인일자 ~ 중지일자</b> 로 판정합니다 — 비워 두면 계약 시작·종료일과 같게 저장합니다.<br>
        ※ <b>운영사용</b> 은 컨설팅 산출물(월보고서 등)은 받지 않고 프로그램만 쓰는 병원 표시입니다.
      </div>
    </div>
  </div>
</div>

<script>
(function(){
  "use strict";

  /* ★[2026-08-20 요청] 기본 글자 크기를 **한 단계(0.1) 크게** 시작한다 — 1.0 → 1.1.
     [↺ 처음 크기로] 도 1.0 이 아니라 이 값으로 돌아간다(사용자가 아는 '처음'은 이제 1.1 이다).
     ⚠더 키우거나 되돌릴 곳은 JR_Z_DEF 한 줄이다. 저장해 둔 개인 설정(localStorage)이 있으면 그게 먼저다. */
  var JR_Z_KEY = 'wnnJoinReqZoom', Z_MIN = 0.8, Z_MAX = 1.6, JR_Z_DEF = 1.1;
  var CUR = null;   // 지금 펼친 신청번호
  var CUR_HOSP = ''; // 그 신청의 요양기관기호 — [계약정보 입력] 이 계약관리로 넘길 값(2026-08-20)

  /* ★★[2026-08-21 최종] 알림·확인 = ui-message.js — 코네트 물류(konet_vsweb)와 같은
     흰 카드+아이콘+색 버튼 (사용자 확정 「계약정보 관련 메세지 sejong_vsweb 있는 내용으로」).
     이 파일 맨 위에서 /asset/js/ui-message.js 를 이미 싣고 있었는데 ***여기 지역 함수가
     같은 이름으로 전역을 가리고 있었다*** — 이제 지역 함수는 전역으로 위임만 한다.
     · 그 전 판(messageBox·small-swal)은 「기존 스타일로」 지시로 만든 것 — 이 확정으로 대체됐다.
     · ui-message 가 없는 곳(wnn_consult 로 복사될 때)은 Swal(jr-swal) → alert 순 폴백.
     ⚠ui-message 의 확인창(.cfm-backdrop)은 z-10000 이라 계약정보 입력창(12500) 뒤에 깔린다 —
       jrcMask 의 style 블록이 13000 으로 올리고, 폭도 480px 로 넓힌다(날짜 줄바꿈 방지). */
  function _alertBox(msg){
    var h = String(msg == null ? '' : msg).replace(/\n/g, '<br>');
    if (typeof window._alertBox === 'function') { window._alertBox(h); return; }
    if (window.Swal) Swal.fire({ title:h, width:480, customClass:{ popup:'jr-swal' },
                                 confirmButtonText:'확인', confirmButtonColor:'#1f5a4b' });
    else alert(msg);
  }
  function _confirmBox(msg, onYes){
    var h = String(msg == null ? '' : msg).replace(/\n/g, '<br>');
    if (typeof window._confirmBox === 'function') { window._confirmBox({ msg:h, onOk:onYes }); return; }
    if (window.Swal) {
      Swal.fire({ icon:'question', title:'확인', html:h,
                  showCancelButton:true, confirmButtonText:'예', cancelButtonText:'아니오' })
        .then(function(r){ if (r.isConfirmed) onYes(); });
    } else { if (confirm(String(msg))) onYes(); }
  }

  /* ── 승인·반려류 큰 창도 같은 모양으로 (2026-08-21 「전부 다 이 스타일로」) ──────
     ui-message 에는 입력칸이 없어 이 화면 전용 _jrAsk 를 둔다 — ui-message 가 주입하는
     CSS 클래스(.cfm-backdrop/.cfm-box…)를 그대로 빌려 쓰므로 모양이 완전히 같다(공용 파일 무수정).
     opts = { icon, title, msg(HTML), input, placeholder, requiredMsg,
              okText, okColor('red' 위험 | 'teal' 진행 | 'blue'), cancelText, onOk(입력값) }
     ui-message 가 안 실린 환경(wnn_consult 복사 시)은 종전 Swal 입력창으로 폴백. */
  function _jrAsk(o){
    o = o || {};
    if (!window._uiMessageLoaded) {
      if (!window.Swal) { _alertBox('확인창을 열 수 없습니다.'); return; }
      Swal.fire({
        icon:(o.okColor === 'red' ? 'warning' : 'question'),
        title:o.title || '', html:o.msg || '',
        input:(o.input ? 'text' : undefined), inputPlaceholder:o.placeholder || '',
        width:460, customClass:{ popup:'jr-swal', icon:'jr-swal-icon' },
        showCancelButton:true, confirmButtonText:o.okText || '확인',
        cancelButtonText:o.cancelText || '취소',
        confirmButtonColor:(o.okColor === 'red' ? '#b23b3b' : '#1f5a4b'),
        inputValidator:function(v){
          if (o.input && (!v || String(v).trim() === '')) return o.requiredMsg || '내용을 입력하세요.';
          return null;
        }
      }).then(function(r){ if (r.isConfirmed && typeof o.onOk === 'function') o.onOk(o.input ? String(r.value).trim() : ''); });
      return;
    }
    var old = gel('jrAskBd'); if (old && old.parentNode) old.parentNode.removeChild(old);
    var bd = document.createElement('div');
    bd.id = 'jrAskBd'; bd.className = 'cfm-backdrop';
    bd.style.display = 'flex'; bd.style.zIndex = '13000';
    bd.innerHTML = ''
      + '<div class="cfm-box" style="width:480px; max-width:94vw; padding:20px 24px 16px;">'
      +   '<div class="cfm-icon" style="margin-bottom:8px;">' + (o.icon || '❓') + '</div>'
      +   '<div style="font-size:17px; font-weight:800; color:#20303a; margin-bottom:10px;">' + (o.title || '') + '</div>'
      +   '<div class="cfm-msg" style="text-align:left; font-size:14.5px; line-height:1.8; margin-bottom:14px;">' + (o.msg || '') + '</div>'
      +   (o.input
          ? '<input type="text" id="jrAskIn" placeholder="' + (o.placeholder || '') + '"'
            + ' style="width:100%; height:38px; border:1px solid #cfd8e0; border-radius:8px; padding:0 10px; font-size:14px; margin-bottom:4px;">'
            + '<div id="jrAskErr" style="display:none; color:#b23b3b; font-size:12.5px; text-align:left; margin:2px 0 6px;"></div>'
          : '')
      +   '<div class="cfm-actions" style="margin-top:10px;">'
      +     '<button type="button" class="cfm-btn cfm-btn-cancel" id="jrAskNo">' + (o.cancelText || '취소') + '</button>'
      +     '<button type="button" class="cfm-btn cfm-btn-ok'
      +       (o.okColor === 'blue' ? ' cfm-ok-blue' : '') + (o.okColor === 'teal' ? ' jr-ok-teal' : '')
      +       '" id="jrAskOk">' + (o.okText || '확인') + '</button>'
      +   '</div>'
      + '</div>';
    document.body.appendChild(bd);
    function close(){ if (bd.parentNode) bd.parentNode.removeChild(bd); }
    gel('jrAskNo').onclick = close;
    bd.onclick = function(e){ if (e.target === bd) close(); };
    gel('jrAskOk').onclick = function(){
      var v = '';
      if (o.input) {
        v = String(gel('jrAskIn').value || '').trim();
        if (!v) {
          var er = gel('jrAskErr');
          er.textContent = o.requiredMsg || '내용을 입력하세요.';
          er.style.display = ''; gel('jrAskIn').focus(); return;
        }
      }
      close();
      if (typeof o.onOk === 'function') o.onOk(v);
    };
    if (o.input) setTimeout(function(){ var e = gel('jrAskIn'); if (e) e.focus(); }, 60);
  }
  (function(){
    var st = document.createElement('style');
    st.textContent = '.jr-swal .swal2-title{ font-size:19px !important; font-weight:700 !important;'
                   + ' line-height:1.6 !important; white-space:pre-line; padding:4px 14px 6px !important; }'
                   + '.jr-swal .swal2-styled{ font-size:15px !important; padding:8px 26px !important; }'
                   + '.jr-swal-icon{ width:48px !important; height:48px !important; font-size:24px !important;'
                   + ' border-width:3px !important; margin:12px auto 6px !important; }';
    document.head.appendChild(st);
  })();

  function gel(id){ return document.getElementById(id); }
  function esc(s){
    return String(s == null ? '' : s)
      .replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;')
      .replace(/"/g,'&quot;').replace(/'/g,'&#39;');
  }
  function nv(s){ return (s == null || String(s).trim() === '') ? '<span class="jr-none">-</span>' : esc(s); }

  /* 글자 크기 — CSS 가 px 라 `zoom` 으로 통째로 키운다(QPS 화면과 같은 규칙) */
  function jrApplyZoom(z){
    z = Math.min(Z_MAX, Math.max(Z_MIN, z));
    var b = gel('jrZoomBox'); if (b) b.style.zoom = z.toFixed(2);
    return z;
  }
  window.jrZoom = function(d){
    var b = gel('jrZoomBox');
    var cur = parseFloat(b && b.style.zoom) || JR_Z_DEF;
    if (d === 0) { jrApplyZoom(JR_Z_DEF); try { localStorage.removeItem(JR_Z_KEY); } catch (ignore) {} return; }
    var z = jrApplyZoom(cur + d * 0.1);
    try { localStorage.setItem(JR_Z_KEY, String(z)); } catch (ignore) {}
  };

  /* ── 목록 ─────────────────────────────────────────────────────── */
  window.jrList = function(){
    $.ajax({
      type:'post', url:'/join/joinReqList.do', dataType:'json',
      data:{ reqStat: gel('jrStat').value, hospCd: gel('jrKey').value },
      success:function(d){
        if (d.error_code !== '0') { _alertBox(d.error_msg || '목록을 불러오지 못했습니다.'); return; }
        var L = d.resultList || [];
        gel('jrCnt').textContent = L.length + '건';
        if (!L.length) {
          gel('jrBody').innerHTML = '<tr><td colspan="10" class="jr-empty">신청 내역이 없습니다.</td></tr>';
          jrClose(); return;
        }
        gel('jrBody').innerHTML = L.map(function(r){
          return '<tr data-no="' + esc(r.reqNo) + '" onclick="jrInfo(' + esc(r.reqNo) + ');">'
               + '<td>' + esc(r.reqNo) + '</td>'
               + '<td><span class="st s' + esc(r.reqStat) + '">' + esc(r.reqStatNm || r.reqStat) + '</span></td>'
               + '<td>' + nv(r.hospCd) + '</td>'
               + '<td class="l">' + nv(r.hospNm) + '</td>'
               + '<td>' + nv(r.hospCeo) + '</td>'
               + '<td>' + nv(r.hospTel) + '</td>'
               + '<td class="l">' + nv(r.email) + '</td>'
               + '<td>' + (r.sealNm === 'Y' ? '있음' : '<span class="jr-none">없음</span>') + '</td>'
               + '<td>' + nv(r.reqDttm) + '</td>'
               /* 계약 — 승인된 줄에만 단추. 줄 클릭(상세 열기)과 겹치지 않게 stopPropagation. */
               + '<td>' + ((r.reqStat === '30' || r.reqStat === '40') && r.hospCd
                   ? '<button type="button" class="jr-btn" style="padding:2px 9px;font-size:12px;"'
                     + ' onclick="event.stopPropagation(); jrGoContRow(\'' + esc(r.hospCd) + '\',' + esc(r.reqNo) + ');"'
                     + ' title="계약정보 입력창을 엽니다 — 화면은 그대로 있습니다">계약입력</button>'
                   : '<span class="jr-none">-</span>') + '</td>'
               + '</tr>';
        }).join('');
      },
      error:function(){ _alertBox('목록을 불러오지 못했습니다.'); }
    });
  };

  /* ── 상세 ─────────────────────────────────────────────────────── */
  var MGR = { '1':'총 관리자', '2':'간호과', '3':'심사과', '4':'전산담당', '9':'기타' };
  var PCU = { '1':'단독사용 가능', '2':'단독불가', '3':'PC사용 시작일 지정' };
  var CON = { '1':'진료비 분석', '2':'적정성평가', 'A':'진료비 분석 + 적정성평가' };

  window.jrInfo = function(no){
    $.ajax({
      type:'post', url:'/join/joinReqInfo.do', dataType:'json', data:{ reqNo: no },
      success:function(d){
        if (d.error_code !== '0') { _alertBox(d.error_msg || '상세를 불러오지 못했습니다.'); return; }
        var i = d.info || {};
        CUR = no;

        var rows = document.querySelectorAll('#joinReq table.jr-grid tbody tr');
        for (var k = 0; k < rows.length; k++) {
          rows[k].classList.toggle('sel', rows[k].getAttribute('data-no') === String(no));
        }
        gel('jrDetailSub').textContent = '신청번호 ' + no + ' · ' + (i.reqDttm || '') + ' 접수';

        var addr = (i.hospAddr || '') + (i.hospExtradr ? ' ' + i.hospExtradr : '');
        var seal = i.sealImg
          ? '<img class="jr-seal" src="data:' + esc(i.sealMime || 'image/png') + ';base64,' + esc(i.sealImg) + '" alt="도장">'
            + '<div style="font-size:11px;color:#8a99a3;margin-top:3px;">' + esc(i.sealNm || '') + '</div>'
          : '<span class="jr-none">없음</span>';

        gel('jrInfo').innerHTML =
          '<table class="jr-sheet">'
          + '<colgroup><col style="width:130px;"><col><col style="width:130px;"><col><col style="width:110px;"><col style="width:120px;"></colgroup>'
          + '<tr><th>병원명</th><td>' + nv(i.hospNm) + '</td>'
          +     '<th>요양기관기호</th><td>' + nv(i.hospCd) + '</td>'
          +     '<th rowspan="4">대표자 도장</th><td rowspan="4" style="text-align:center;">' + seal + '</td></tr>'
          + '<tr><th>대표자</th><td>' + nv(i.hospCeo) + '</td>'
          +     '<th>사업자등록번호</th><td>' + nv(i.busiNum) + '</td></tr>'
          + '<tr><th>전화번호</th><td>' + nv(i.hospTel) + '</td>'
          +     '<th>FAX</th><td>' + nv(i.hospFax) + '</td></tr>'
          + '<tr><th>주소</th><td colspan="3">' + nv((i.zipCd ? '(' + i.zipCd + ') ' : '') + addr) + '</td></tr>'
          + '<tr><th>병상수</th><td>' + nv(i.wardcnt) + '</td>'
          +     '<th>희망 서비스</th><td colspan="3">' + nv(CON[i.conactGb] || i.conactGb) + '</td></tr>'
          + '<tr><th>전산프로그램</th><td colspan="5">'
          +     '프로그램명 ' + nv(i.ocsCompany) + ' &nbsp;·&nbsp; ID ' + nv(i.ocsUserId)
          +     ' &nbsp;·&nbsp; PW ' + nv(i.ocsUserPw) + '</td></tr>'
          + '<tr><th>심평원 인증서암호</th><td>' + nv(i.hiraCertPw) + '</td>'
          +     '<th>PC 사용여부</th><td colspan="3">' + nv(PCU[i.pcUseGb] || i.pcUseGb)
          +     (i.pcUseTime ? ' (가능시간 ' + esc(i.pcUseTime) + ')' : '')
          +     (i.pcUseStdt ? ' (시작일 ' + esc(i.pcUseStdt) + ')' : '') + '</td></tr>'
          + '<tr><th>환자평가표<br>작성완료일</th><td>' + (i.asqDay ? '매월 ' + esc(i.asqDay) + '일' : '<span class="jr-none">-</span>')
          +     (i.asqBigo ? ' (' + esc(i.asqBigo) + ')' : '') + '</td>'
          +     '<th>적정성평가 목표</th><td colspan="3">' + nv(i.evalGoal) + '</td></tr>'
          + '<tr><th>신청자</th><td>' + nv(i.mbrNm) + (i.jobNm ? ' / ' + esc(i.jobNm) : '') + '</td>'
          +     '<th>연락처</th><td>' + nv(i.mbrTel) + '</td>'
          +     '<th>신청 IP</th><td>' + nv(i.regIp) + '</td></tr>'
          + '<tr><th>이메일 (로그인 ID)</th><td>' + nv(i.email) + '</td>'
          +     '<th>비밀번호</th><td colspan="3">'
          +     (i.passYn === 'Y'
              ? '25CF25CF25CF25CF25CF25CF25CF25CF <span style="font-size:11.5px;color:#8a99a3;">설정됨 — 단방향 암호화라 원문은 볼 수 없습니다</span>'
              : '<span class="jr-none">미설정</span>') + '</td></tr>'
          + '<tr><th>비 고</th><td colspan="5">' + nv(i.bigo) + '</td></tr>'
          + '</table>';

        var M = d.mgrList || [];
        gel('jrMgr').innerHTML = !M.length
          ? '<div class="jr-empty">담당자 정보가 없습니다.</div>'
          : '<table class="jr-grid"><thead><tr><th style="width:110px;">구분</th><th>부서</th><th>직책</th>'
            + '<th>성명</th><th>전화번호</th><th>이메일 주소</th></tr></thead><tbody>'
            + M.map(function(m){
                return '<tr style="cursor:default;"><td>' + esc(MGR[m.mgrGb] || m.mgrGb) + '</td>'
                     + '<td>' + nv(m.deptNm) + '</td><td>' + nv(m.jobNm) + '</td>'
                     + '<td>' + nv(m.mgrNm) + '</td><td>' + nv(m.mgrTel) + '</td>'
                     + '<td class="l">' + nv(m.email) + '</td></tr>';
              }).join('')
            + '</tbody></table>';

        var A = d.agreeList || [];
        gel('jrAgree').innerHTML = !A.length
          ? '<div class="jr-empty">동의 내역이 없습니다.</div>'
          : '<table class="jr-grid"><thead><tr><th>서식</th><th class="l">동의서</th><th style="width:70px;">필수</th>'
            + '<th style="width:70px;">동의</th><th style="width:70px;">열람</th>'
            + '<th style="width:80px;">버전</th><th style="width:150px;">동의 IP</th><th style="width:110px;">동의자</th></tr></thead><tbody>'
            + A.map(function(a){
                return '<tr style="cursor:default;"><td>' + nv(a.formNo) + '</td>'
                     + '<td class="l">' + nv(a.agreeNmTxt || a.agreeCd) + '</td>'
                     + '<td>' + (a.essYn === 'Y' ? '필수' : '선택') + '</td>'
                     + '<td>' + (a.agreeYn === 'Y' ? '<b style="color:#1f5a4b;">동의</b>' : '<b style="color:#d9534f;">미동의</b>') + '</td>'
                     + '<td>' + (a.readYn === 'Y' ? '열람' : '<span class="jr-none">-</span>') + '</td>'
                     + '<td>' + nv(a.verNo) + '</td><td>' + nv(a.agreeIp) + '</td><td>' + nv(a.agreeNm) + '</td></tr>';
              }).join('')
            + '</tbody></table>';

        // 처리 가능한 상태(접수·검토중)에서만 승인/반려 버튼을 낸다
        var open = (i.reqStat === '10' || i.reqStat === '20');
        gel('jrCfmBtn').style.display = open ? '' : 'none';
        gel('jrRjtBtn').style.display = open ? '' : 'none';
        // 승인취소는 승인된 건(30·40)에서만 — 되돌릴 게 있어야 한다
        gel('jrRbkBtn').style.display = (i.reqStat === '30' || i.reqStat === '40') ? '' : 'none';
        /* [2026-08-20] 계약정보 입력 — **단추는 늘 보이고, 승인 전에는 눌리지 않게** 한다.
           ⚠감춰 두면 "그런 기능이 없다" 로 읽힌다(2026-08-20 지적). 왜 못 쓰는지를 단추가 말해야 한다.
           승인 전에는 병원이 아직 만들어지지 않아 계약관리에서 찾을 수 없다(승인 때 병원·사용자·회원이 생긴다). */
        CUR_HOSP = i.hospCd || '';
        var contOk = (i.reqStat === '30' || i.reqStat === '40') && !!CUR_HOSP;
        var cbtn = gel('jrContBtn');
        cbtn.style.display = '';
        cbtn.disabled      = !contOk;
        cbtn.style.opacity = contOk ? '' : '.45';
        cbtn.style.cursor  = contOk ? '' : 'not-allowed';
        cbtn.title = contOk
          ? '계약정보 입력창을 엽니다 — 적정성평가·진료비 분석 계약을 여기서 바로 넣습니다'
          : '승인 후에 쓸 수 있습니다 — 승인해야 병원이 만들어집니다.';
        // 반려취소는 반려건(90)에서만 — 접수로 되돌린다
        gel('jrRjtCancelBtn').style.display = (i.reqStat === '90') ? '' : 'none';
        // 신청 전체취소는 접수(10)에서만 — 아무것도 안 만들어진 단계다
        gel('jrCancelBtn').style.display = (i.reqStat === '10') ? '' : 'none';

        var done = gel('jrDone');
        if (i.reqStat === '30') {
          done.style.display = '';
          done.style.color = '#1f5a4b';
          done.innerHTML = '<b>승인 완료</b> — ' + esc(i.cfmDttm || '') + ' · 처리자 ' + esc(i.cfmUser || '')
                         + ' &nbsp;|&nbsp; 계약은 위 <b>[계약정보 입력]</b> 을 누르면 이 자리에서 바로 넣을 수 있습니다.';
        } else if (i.reqStat === '90') {
          done.style.display = '';
          done.style.color = '#a33';
          done.innerHTML = '<b>반려</b> — ' + esc(i.cfmDttm || '') + ' · 처리자 ' + esc(i.cfmUser || '')
                         + '<br>사유 : ' + esc(i.rjtRsn || '');
        } else {
          done.style.display = 'none';
        }

        gel('jrDetail').classList.add('on');
        gel('jrDetail').scrollTop = 0;   // 상세는 자체 스크롤 — 페이지를 움직이지 않는다
      },
      error:function(){ _alertBox('상세를 불러오지 못했습니다.'); }
    });
  };

  /* ── 계약정보 입력 (2026-08-21 개편) ────────────────
     ★종전에는 계약관리(/user/hospcd.do)로 **화면을 옮겨** 그 병원을 골라 모달을 열었다.
       이제는 이 화면에서 바로 **계약정보 입력창**을 띄운다(아래 jrcOpen).
       · 화면이 바뀌지 않아 보던 신청을 잃지 않는다.
       · 계약 두 가지(적정성평가·진료비 분석)를 한 창에서 함께 넣는다.
       · 전산프로그램 정보는 신청서 값을 그대로 끌어와 채운다. */
  /* 목록의 [계약입력] — 상세를 열지 않고 그 줄 값으로 바로 연다 */
  window.jrGoContRow = function(hospCd, reqNo){
    if (!hospCd) { _alertBox('요양기관기호가 없어 계약정보를 열 수 없습니다.'); return; }
    jrcOpen(hospCd, reqNo || '');
  };

  window.jrGoCont = function(){
    if (!CUR_HOSP) { _alertBox('요양기관기호가 없어 계약정보를 열 수 없습니다.'); return; }
    if (gel('jrContBtn') && gel('jrContBtn').disabled) {
      _alertBox('아직 <b>승인 전</b>입니다.<br>승인해야 병원이 만들어지고 계약을 넣을 수 있습니다.'); return;
    }
    jrcOpen(CUR_HOSP, CUR);
  };

  /* ── 승인 · 반려 ──────────────────────────────────────────────── */
  window.jrConfirm = function(){
    if (!CUR) return;
    _jrAsk({
      icon:'❓', title:'신청번호 ' + CUR + ' 승인',
      msg:'승인신청을 완료하고 <b>계약정보</b>를 입력하세요.',
      okText:'승인', okColor:'teal', cancelText:'취소',
      onOk:function(){
        $.ajax({
          type:'post', url:'/join/joinReqCfm.do', dataType:'json', data:{ reqNo: CUR },
          success:function(d){
            if (d.error_code !== '0') { _alertBox(d.error_msg || '승인하지 못했습니다.'); return; }
            // 완료 알림 없음(2026-08-19 요청) — 상태가 승인으로 바뀌는 게 화면에 보인다
            var no = CUR; jrList(); setTimeout(function(){ jrInfo(no); }, 500);
          },
          error:function(){ _alertBox('승인하지 못했습니다.'); }
        });
      }
    });
  };

  /* 반려 사유 입력 — 브라우저 prompt() 는 주소(localhost:8080)가 그대로 노출되고
     승인/반려 어느 쪽인지도 안 보인다(2026-08-19 지적). SweetAlert 입력창으로 받는다. */
  window.jrReject = function(){
    if (!CUR) return;
    _jrAsk({
      icon:'⚠️', title:'신청번호 ' + CUR + ' 반려',
      msg:'이 신청을 <b>반려</b>합니다. 승인 신청을 원하면 <b>다시 신청</b>하면 됩니다.',
      input:true, placeholder:'반려 사유 (신청 이력에 남습니다)', requiredMsg:'반려 사유를 입력하세요.',
      okText:'반려', okColor:'red', cancelText:'취소',
      onOk:function(v){ jrRejectExec(v); }
    });
  };

  /* ── 가입취소(신청 전체취소) ────────────────────────────────────────────────
     접수 단계라 병원·계정이 아직 없다. 신청서를 목록에서 내리고 이력만 남긴다.
     행을 지우지 않으므로 나중에 무엇이 취소됐는지 추적할 수 있다. */
  window.jrReqCancel = function(){
    if (!CUR) return;
    _jrAsk({
      icon:'⚠️', title:'신청번호 ' + CUR + ' 가입취소',
      msg:'이 신청을 <b>취소</b>합니다. 다시 할 경우 <b>요양기관에서 다시 입력</b>해야 합니다.',
      input:true, placeholder:'취소 사유 (신청 이력에 남습니다)', requiredMsg:'취소 사유를 입력하세요.',
      okText:'가입취소', okColor:'red', cancelText:'닫기',
      onOk:function(v){
        $.ajax({
          type:'post', url:'/join/joinReqCancel.do', dataType:'json',
          data:{ reqNo: CUR, rjtRsn: v },
          success:function(d){
            if (d.error_code !== '0') { _alertBox(d.error_msg || '취소하지 못했습니다.'); return; }
            jrClose(); jrList();
          },
          error:function(){ _alertBox('취소하지 못했습니다.'); }
        });
      }
    });
  };

  /* ── 반려취소 ──────────────────────────────────────────────────────
     반려는 병원·사용자를 만들지 않으므로 지울 것이 없다. 상태만 접수로 되돌린다. */
  window.jrRjtCancel = function(){
    if (!CUR) return;
    _jrAsk({
      icon:'❓', title:'신청번호 ' + CUR + ' 반려취소',
      msg:'반려를 <b>접수</b> 상태로 되돌립니다. 반려 사유는 지워집니다.<br>'
        + '되돌린 뒤 다시 승인하거나 다시 반려할 수 있습니다.',
      okText:'반려취소', okColor:'teal', cancelText:'닫기',
      onOk:function(){
        $.ajax({
          type:'post', url:'/join/joinReqRjtCancel.do', dataType:'json', data:{ reqNo: CUR },
          success:function(d){
            if (d.error_code !== '0') { _alertBox(d.error_msg || '반려를 취소하지 못했습니다.'); return; }
            // 완료 알림 없음 — 목록·상세가 바로 접수 상태로 바뀐다
            var no = CUR; jrList(); setTimeout(function(){ jrInfo(no); }, 500);
          },
          error:function(){ _alertBox('반려를 취소하지 못했습니다.'); }
        });
      }
    });
  };

  /* ── 승인취소(롤백) ────────────────────────────────────────────────
     병원·사용자를 지우는 되돌릴 수 없는 처리다. 무엇이 지워지는지 먼저 보여주고,
     사유를 받는다. 계약이 있거나 사용자가 늘었으면 서버가 거부한다. */
  window.jrRollback = function(){
    if (!CUR) return;
    _jrAsk({
      icon:'⚠️', title:'신청번호 ' + CUR + ' 승인취소',
      /* 문구 간결화(2026-08-21 지시) — 세부는 서버가 지키고 막히면 그때 서버 안내가 뜬다.
         ★계약도 함께 지워진다(JoinServiceImpl.rollback 의 delContFromReq) — 「계약이 있으면
         취소 불가」 안내줄은 사실과 달라 뺐다(2026-08-21 「계약내용도 취소되어야 하고 이 메세지는 제외」). */
      msg:'승인으로 만든 <b>병원·계정·계약이 지워지고</b>, 신청은 <b>접수</b>로 돌아갑니다.',
      input:true, placeholder:'취소 사유 (신청 이력에 남습니다)', requiredMsg:'취소 사유를 입력하세요.',
      okText:'승인취소', okColor:'red', cancelText:'닫기',
      onOk:function(v){
        $.ajax({
          type:'post', url:'/join/joinReqRollback.do', dataType:'json',
          data:{ reqNo: CUR, rjtRsn: v },
          success:function(d){
            if (d.error_code !== '0') { _alertBox(d.error_msg || '승인취소하지 못했습니다.'); return; }
            // 완료 알림은 뺀다(2026-08-19 요청) — 목록·상세가 바로 접수 상태로 바뀌어 눈에 보인다
            var no = CUR; jrList(); setTimeout(function(){ jrInfo(no); }, 500);
          },
          error:function(){ _alertBox('승인취소하지 못했습니다.'); }
        });
      }
    });
  };

  function jrRejectExec(rsn){
    $.ajax({
      type:'post', url:'/join/joinReqRjt.do', dataType:'json', data:{ reqNo: CUR, rjtRsn: rsn },
      success:function(d){
        if (d.error_code !== '0') { _alertBox(d.error_msg || '반려하지 못했습니다.'); return; }
        // 완료 알림 없음 — 상태가 반려로 바뀌는 게 화면에 보인다
        var no = CUR; jrList(); setTimeout(function(){ jrInfo(no); }, 500);
      },
      error:function(){ _alertBox('반려하지 못했습니다.'); }
    });
  };

  window.jrClose = function(){
    CUR = null;
    gel('jrDetail').classList.remove('on');
    var rows = document.querySelectorAll('#joinReq table.jr-grid tbody tr');
    for (var k = 0; k < rows.length; k++) rows[k].classList.remove('sel');
  };

  /* ══ 계약정보 입력창 (2026-08-21) ═══════════════════════════════════════════
     계약관리 화면으로 넘기지 않고 **여기서** 계약을 넣는다. 한 창에서 계약 두 가지
     (적정성평가 · 진료비 분석)를 함께 다루고, 전산프로그램 정보는 신청서에서 끌어온다.

     ★서버 무변경 — 계약관리가 쓰던 엔드포인트를 그대로 쓴다. 그래서 이 화면은
       JSP 교체만으로 반영된다(WAR 재빌드 불필요).
     ⚠응답 본문이 JSON 이 아니라 "OK" 라 dataType 은 반드시 'text' 로 받는다
       (json 으로 받으면 정상 저장인데도 파싱 실패로 오류처럼 보인다).                */
  var JRC = null;                                    // 지금 창에 올라와 있는 병원·신청 정보
  var JRC_CODES = null;                              // 공통코드(CONACT_GB) — 한 번만 받아 둔다
  var JRC_GB_DEF = [ { gb:'2', nm:'적정성평가' }, { gb:'1', nm:'진료비 분석' } ];

  function jrcCookie(nm){
    var p = ('; ' + document.cookie).split('; ' + nm + '=');
    try { return (p.length === 2) ? decodeURIComponent(p.pop().split(';').shift()) : ''; }
    catch (ignore) { return ''; }
  }
  /* 화면(input[type=date])은 yyyy-mm-dd · DB 는 yyyymmdd — 오갈 때 이 둘로만 바꾼다 */
  function jrcS2D(s){
    s = String(s == null ? '' : s).replace(/[^0-9]/g, '');
    return /^[0-9]{8}$/.test(s) ? (s.substring(0,4) + '-' + s.substring(4,6) + '-' + s.substring(6,8)) : '';
  }
  function jrcD2S(v){ return String(v == null ? '' : v).replace(/[^0-9]/g, ''); }
  function jrcToday(){
    var d = new Date(), m = ('0' + (d.getMonth()+1)).slice(-2), q = ('0' + d.getDate()).slice(-2);
    return String(d.getFullYear()) + m + q;
  }
  function jrcVal(id){ var e = gel(id); return e ? String(e.value || '').trim() : ''; }

  /* 계약구분은 공통코드가 정본이다 — 코드값을 화면에 박아 두면 코드가 늘 때 어긋난다.
     못 받으면 기본 두 가지로 간다(창이 안 열리는 것보다 낫다). */
  function jrcCodes(cb){
    if (JRC_CODES) { cb(JRC_CODES); return; }
    $.ajax({
      type:'post', url:'/base/commList.do', dataType:'json',
      data:{ listGb:['Z'], listCd:['CONACT_GB'] },
      success:function(d){
        var L = ((d && d.data) ? d.data : [])
                  .filter(function(x){ return String(x.codeCd) === 'CONACT_GB'; })
                  .map(function(x){ return { gb:String(x.subCode), nm:String(x.subCodeNm || '') }; });
        JRC_CODES = L.length ? L : JRC_GB_DEF;
        /* 적정성평가(2)를 앞에 — 대부분 이 계약부터 넣는다 */
        JRC_CODES.sort(function(a,b){ return (a.gb === '2' ? 0 : 1) - (b.gb === '2' ? 0 : 1); });
        cb(JRC_CODES);
      },
      error:function(){ JRC_CODES = JRC_GB_DEF; cb(JRC_CODES); }
    });
  }

  function jrcPick(r){ return (r && r.length === 3 && r[2] && r[2].readyState) ? r[0] : r; }

  /* 창 열기 — 요양기관기호로 병원(UUID·가입일)·기존 계약을, 신청번호로 신청서 값을 받는다 */
  window.jrcOpen = function(hospCd, reqNo){
    if (!hospCd) { _alertBox('요양기관기호가 없어 계약정보를 열 수 없습니다.'); return; }
    JRC = { hospCd:String(hospCd).trim(), reqNo:(reqNo || ''), hospNm:'', hospUuid:'', joinDt:'',
            req:{}, conts:{}, cnts:{}, gbs:[], tab:'' };
    gel('jrcHosp').innerHTML = '';
    gel('jrcCols').innerHTML = '';
    gel('jrcMask').style.display = 'flex';

    jrcCodes(function(codes){
      JRC.gbs = codes;
      var qHosp = $.ajax({ type:'post', url:'/user/hospCdList.do',   dataType:'json', data:{ hospCd:JRC.hospCd } });
      var qCont = $.ajax({ type:'post', url:'/user/hospContList.do', dataType:'json', data:{ hospCd:JRC.hospCd } });
      var qReq  = JRC.reqNo
                ? $.ajax({ type:'post', url:'/join/joinReqInfo.do',  dataType:'json', data:{ reqNo:JRC.reqNo } })
                : $.Deferred().resolve(null).promise();

      $.when(qHosp, qCont, qReq).done(function(rh, rc, rq){
        var H = jrcPick(rh), C = jrcPick(rc), R = jrcPick(rq);
        var row = (H && H.data && H.data.length) ? H.data[0] : null;
        if (!row) {
          jrcClose();
          _alertBox('요양기관기호 ' + hospCd + ' 의 병원 정보를 찾지 못했습니다.\n가입신청이 승인되었는지 확인해 주세요.');
          return;
        }
        JRC.hospNm   = row.hospNm   || '';
        JRC.hospUuid = row.hospUuid || '';
        JRC.joinDt   = jrcD2S(row.joinDt);

        /* 기존 계약 — 구분마다 **가장 최근 건**을 수정 대상으로 삼는다(목록이 START_DT DESC) */
        ((C && C.data) ? C.data : []).forEach(function(c){
          var g = String(c.conactGb || '');
          if (!g) return;
          JRC.cnts[g] = (JRC.cnts[g] || 0) + 1;
          if (!JRC.conts[g]) JRC.conts[g] = c;
        });

        JRC.req = (R && R.error_code === '0' && R.info) ? R.info : {};
        jrcRender();
      }).fail(function(){
        jrcClose();
        _alertBox('계약정보를 불러오지 못했습니다.');
      });
    });
  };

  window.jrcClose = function(){
    gel('jrcMask').style.display = 'none';
    JRC = null;
  };

  function jrcRender(){
    var q = JRC.req || {};
    gel('jrcHosp').innerHTML = esc(JRC.hospNm)
      + '<span class="jrc-cd">' + esc(JRC.hospCd) + '</span>'
      + (JRC.reqNo ? '<span class="jrc-cd">신청번호 ' + esc(JRC.reqNo) + '</span>' : '');


    /* 탭 띠 — 카드 두 장을 한 장씩 보여 준다(2026-08-21 「두 개 탭을 분리」) */
    var tabs = '<div class="jrc-tabs">' + JRC.gbs.map(function(g){
      return '<button type="button" class="jrc-tab" id="jrcTabBtn_' + g.gb + '"'
           + ' onclick="jrcTab(\'' + g.gb + '\');">'
           + '<span class="jrc-tdot" id="jrcTabDot_' + g.gb + '"></span>' + esc(g.nm) + '</button>';
    }).join('') + '</div>';
    gel('jrcCols').innerHTML = tabs + JRC.gbs.map(jrcSecHtml).join('');
    JRC.gbs.forEach(function(g){ jrcFill(g); });
    /* 처음 보여 줄 탭 : 보던 탭 > 기존 계약이 있는 구분 > 체크된 구분 > 첫 구분 */
    var cur = JRC.tab;
    if (!cur || !gel('jrcSec_' + cur)) {
      var byEx = JRC.gbs.filter(function(g){ return !!JRC.conts[g.gb]; })[0];
      var byOn = JRC.gbs.filter(function(g){ var e = gel('jrcOn_' + g.gb); return e && e.checked; })[0];
      cur = (byEx || byOn || JRC.gbs[0]).gb;
    }
    jrcTab(cur);
  }

  function jrcSecHtml(g){
    var b = g.gb;
    return ''
      + '<div class="jrc-sec" id="jrcSec_' + b + '">'
      +   '<div class="jrc-sech">'
      +     '<label><input type="checkbox" id="jrcOn_' + b + '" onchange="jrcToggle(\'' + b + '\');">'
      +     '<b>' + esc(g.nm) + '</b> <span id="jrcOnTx_' + b + '">계약 등록</span></label>'
      +     '<span class="jrc-badge new" id="jrcMode_' + b + '">신규</span>'
      +     '<span style="flex:1"></span>'
      +     '<button type="button" class="jrc-mini warn" id="jrcDel_' + b + '" style="display:none;"'
      +       ' onclick="jrcDrop(\'' + b + '\');">계약 삭제</button>'
      +   '</div>'
      +   '<div class="jrc-secb">'
      +     '<table class="jrc-tb">'
      +       '<colgroup><col style="width:88px;"><col><col style="width:88px;"><col></colgroup>'
      +       '<tr><th>계약시작일</th><td><input type="date" id="jrcSt_' + b + '" onchange="jrcSyncDt(\'' + b + '\');"></td>'
      +           '<th>계약종료일</th><td><input type="date" id="jrcEd_' + b + '" onchange="jrcSyncDt(\'' + b + '\');"></td></tr>'
      +       '<tr><th>승인일자</th><td><input type="date" id="jrcAc_' + b + '" onchange="jrcManual(this);"></td>'
      +           '<th>중지일자</th><td><input type="date" id="jrcCl_' + b + '" onchange="jrcManual(this);"></td></tr>'
      +       '<tr><th>사용구분</th><td><select id="jrcUse_' + b + '"><option value="Y">사용</option><option value="N">미사용</option></select></td>'
      +           '<th>운영사용</th><td><label><input type="checkbox" id="jrcNor_' + b + '"> 프로그램만 사용</label></td></tr>'
      +       '<tr><th>세부내용</th><td colspan="3"><input type="text" id="jrcCon_' + b + '" placeholder="계약 세부내용"></td></tr>'
      +       '<tr><th class="grp" colspan="4">전산프로그램 정보</th></tr>'
      +       '<tr><th>프로그램명</th><td><input type="text" id="jrcPgm_' + b + '"></td>'
      +           '<th>아이디</th><td><input type="text" id="jrcPid_' + b + '"></td></tr>'
      +       '<tr><th>패스워드</th><td colspan="3"><input type="text" id="jrcPpw_' + b + '"></td></tr>'
      +       '<tr><th class="grp" colspan="4">계약 담당</th></tr>'
      +       '<tr><th>담당자</th><td><input type="text" id="jrcMgr_' + b + '"></td>'
      +           '<th>담당전화</th><td><input type="text" id="jrcTel_' + b + '"></td></tr>'
      +     '</table>'
      +     '<div class="jrc-hist" id="jrcHist_' + b + '"></div>'
      +   '</div>'
      + '</div>';
  }

  /* 칸 채우기 — 기존 계약이 있으면 그 값, 없으면 신청서·가입일에서 만든 기본값 */
  function jrcFill(g){
    var b = g.gb, ex = JRC.conts[b] || null, q = JRC.req || {};
    var st = ex ? jrcD2S(ex.startDt) : (JRC.joinDt || jrcToday());
    var ed = ex ? jrcD2S(ex.endDt)   : '20991231';

    gel('jrcSt_' + b).value  = jrcS2D(st);
    gel('jrcEd_' + b).value  = jrcS2D(ed);
    gel('jrcAc_' + b).value  = jrcS2D(ex ? ex.acceptDt : st);
    gel('jrcCl_' + b).value  = jrcS2D(ex ? ex.closeDt  : ed);
    gel('jrcUse_' + b).value = (ex && ex.useYn === 'N') ? 'N' : 'Y';
    gel('jrcNor_' + b).checked = !!(ex && ex.norYn === 'Y');
    gel('jrcCon_' + b).value = ex ? (ex.conContent || '') : '';

    /* 전산프로그램 정보 — 기존 계약 값이 우선, 비어 있으면 신청서 값 */
    gel('jrcPgm_' + b).value = (ex && ex.ocsCompany) ? ex.ocsCompany : (q.ocsCompany || '');
    gel('jrcPid_' + b).value = (ex && ex.ocsUserId)  ? ex.ocsUserId  : (q.ocsUserId  || '');
    gel('jrcPpw_' + b).value = (ex && ex.ocsUserPw)  ? ex.ocsUserPw  : (q.ocsUserPw  || '');

    gel('jrcMgr_' + b).value = (ex && ex.conUserId)  ? ex.conUserId  : (q.mbrNm || '');
    gel('jrcTel_' + b).value = (ex && ex.conUserTel) ? ex.conUserTel : (q.mbrTel || '');

    var mode = gel('jrcMode_' + b);
    mode.className   = 'jrc-badge ' + (ex ? 'upd' : 'new');
    mode.textContent = ex ? '기존 계약' : '신규';
    gel('jrcOnTx_' + b).textContent  = ex ? '계약 수정' : '계약 등록';
    gel('jrcDel_' + b).style.display = ex ? '' : 'none';

    gel('jrcHist_' + b).innerHTML = ex
      ? ('등록된 계약 ' + esc(JRC.cnts[b]) + '건 — 가장 최근 건('
         + esc(jrcS2D(ex.startDt)) + ' ~ ' + esc(jrcS2D(ex.endDt)) + ')을 수정합니다.')
      : '아직 이 구분의 계약이 없습니다.';

    /* 처음 체크 상태 : 기존 계약이 있으면 켠다. 없으면 **신청서의 희망 서비스**를 따른다
       (희망이 A 면 둘 다). 신청서 없이 열었으면 꺼 둔 채로 고르게 한다. */
    var want = String(q.conactGb || '');
    gel('jrcOn_' + b).checked = ex ? true : (want === 'A' || want === b);
    jrcToggle(b);
  }

  window.jrcTab = function(b){
    if (JRC) JRC.tab = b;
    var gbs = JRC ? JRC.gbs : [];
    gbs.forEach(function(g){
      var on  = (g.gb === b);
      var sec = gel('jrcSec_' + g.gb);    if (sec) sec.classList.toggle('on', on);
      var btn = gel('jrcTabBtn_' + g.gb); if (btn) btn.classList.toggle('on', on);
    });
  };

  window.jrcToggle = function(b){
    var on  = gel('jrcOn_' + b).checked;
    var sec = gel('jrcSec_' + b);
    sec.classList.toggle('off', !on);
    var f = sec.querySelectorAll('.jrc-secb input, .jrc-secb select');
    for (var i = 0; i < f.length; i++) f[i].disabled = !on;
    /* 탭 점 — 체크된 구분은 초록(안 보이는 탭의 상태도 띠에서 보이게) */
    var d = gel('jrcTabDot_' + b);
    if (d) d.style.background = on ? '#2ecc71' : '#c3ced6';
  };

  window.jrcManual = function(el){ if (el) el.setAttribute('data-man', '1'); };

  /* 승인·중지일자는 계약 시작·종료일을 따라간다 — 사람이 직접 고친 칸(data-man)은 그대로 둔다.
     ⚠이 두 값이 프로그램 사용기간 판정에 쓰인다(어긋나면 로그인해도 화면이 안 열린다). */
  window.jrcSyncDt = function(b){
    var ac = gel('jrcAc_' + b), cl = gel('jrcCl_' + b);
    if (ac.getAttribute('data-man') !== '1') ac.value = gel('jrcSt_' + b).value;
    if (cl.getAttribute('data-man') !== '1') cl.value = gel('jrcEd_' + b).value;
  };

  /* [신청서 값 넣기] 단추는 2026-08-21 지시로 뺐다 — 값이 어차피 자동으로 채워진다.
     함수는 남겨 둔다(단추만 되넣으면 부활). */
  window.jrcPullPgm = function(b){
    var q = JRC ? (JRC.req || {}) : {};
    if (!JRC || !JRC.reqNo) { _alertBox('신청서를 함께 열지 않아 가져올 값이 없습니다.'); return; }
    gel('jrcPgm_' + b).value = q.ocsCompany || '';
    gel('jrcPid_' + b).value = q.ocsUserId  || '';
    gel('jrcPpw_' + b).value = q.ocsUserPw  || '';
  };

  /* ── 저장 ─────────────────────────────────────────────────────── */
  function jrcBusy(on){
    var b = gel('jrcSaveBtn');
    if (b) { b.disabled = !!on; b.textContent = on ? '저장 중…' : '저장'; }
  }
  function jrcPost(url, arr, ok, ng){
    $.ajax({ type:'POST', url:url, data:JSON.stringify(arr),
             contentType:'application/json', dataType:'text' })
     .done(function(){ ok(); })
     .fail(function(x){ ng(x); });
  }
  function jrcWho(){
    return { user: jrcCookie('s_userid') || jrcCookie('s_hospid') || 'admin',
             ip:   jrcCookie('s_connip') || '' };
  }

  window.jrcSave = function(){
    if (!JRC) return;
    var who = jrcWho(), list = [], errs = [];

    JRC.gbs.forEach(function(g){
      var b = g.gb;
      if (!gel('jrcOn_' + b).checked) return;
      var st = jrcD2S(jrcVal('jrcSt_' + b)), ed = jrcD2S(jrcVal('jrcEd_' + b));
      if (!st || !ed) { errs.push(g.nm + ' : 계약 시작일·종료일을 넣어 주세요.'); return; }
      if (st > ed)    { errs.push(g.nm + ' : 계약 종료일이 시작일보다 빠릅니다.'); return; }
      var ac = jrcD2S(jrcVal('jrcAc_' + b)) || st;
      var cl = jrcD2S(jrcVal('jrcCl_' + b)) || ed;
      var ex = JRC.conts[b] || null;

      list.push({
        nm : g.nm,
        gb : b,
        dto: { hospCd:JRC.hospCd, hospUuid:JRC.hospUuid, conactGb:b,
               startDt:st, endDt:ed, acceptDt:ac, closeDt:cl, joinDt:JRC.joinDt,
               useYn:(jrcVal('jrcUse_' + b) || 'Y'),
               norYn:(gel('jrcNor_' + b).checked ? 'Y' : 'N'),
               conContent:jrcVal('jrcCon_' + b),
               conUserId:jrcVal('jrcMgr_' + b),
               conUserTel:jrcVal('jrcTel_' + b),
               /* 이메일 칸은 화면에서 뺐다(2026-08-21) — 기존 계약의 값을 그대로 물려 지워지지 않게 한다 */
               conEmail:((ex && ex.conEmail) ? ex.conEmail : ''),
               ocsCompany:jrcVal('jrcPgm_' + b),
               ocsUserId:jrcVal('jrcPid_' + b),
               ocsUserPw:jrcVal('jrcPpw_' + b),
               regUser:who.user, updUser:who.user, regIp:who.ip, updIp:who.ip },
        old: ex ? { hospCd:JRC.hospCd, startDt:jrcD2S(ex.startDt),
                    endDt:jrcD2S(ex.endDt), conactGb:b } : null
      });
    });

    if (errs.length)  { _alertBox(errs.join('\n')); return; }
    if (!list.length) { _alertBox('저장할 계약을 하나 이상 골라 주세요.'); return; }

    var sum = list.map(function(it){
      return '· ' + it.nm + ' ' + jrcS2D(it.dto.startDt) + ' ~ ' + jrcS2D(it.dto.endDt)
           + (it.old ? ' (기존 계약 수정)' : ' (신규 등록)');
    }).join('\n');
    _confirmBox('아래 내용으로 저장합니다.\n\n' + sum, function(){
      jrcBusy(true); jrcRun(list, 0);
    });
  };

  function jrcRun(list, i){
    if (i >= list.length) {
      jrcBusy(false);
      /* 성공 알림은 띄우지 않는다(2026-08-21 「마지막 결과확인 없애기」) —
         창이 다시 그려져 「기존 계약」 배지·등록 건수로 결과가 보인다. 실패 때만 알린다. */
      jrcReload();
      return;
    }
    var it   = list[i];
    var next = function(){ jrcRun(list, i + 1); };
    var fail = function(x){
      jrcBusy(false);
      _alertBox(it.nm + ' 계약을 저장하지 못했습니다.\n'
              + ((x && x.status === 400) ? '같은 기간·구분의 계약이 이미 있습니다.'
                                         : '잠시 후 다시 시도해 주세요.'));
      jrcReload();
    };

    if (!it.old) { jrcPost('/user/hospContInsert.do', [it.dto], next, fail); return; }

    /* 기간이 그대로면 계약관리와 같은 방식(옛 행 내리고 새로 넣기)을 서버 한 번에 맡긴다 */
    if (it.old.startDt === it.dto.startDt && it.old.endDt === it.dto.endDt) {
      jrcPost('/user/hospContUpdate.do', [it.dto], next, fail); return;
    }
    /* ★기간이 바뀌면 새 행을 **먼저 넣고** 옛 행을 내린다 — 순서를 바꾸면 넣기가 실패했을 때
       옛 행은 이미 내려간 뒤라 계약이 통째로 사라진다. */
    jrcPost('/user/hospContInsert.do', [it.dto], function(){
      jrcPost('/user/hospContDelete.do',
        [{ keyhospCd:it.old.hospCd, keystartDt:it.old.startDt,
           keyendDt:it.old.endDt,   keyconactGb:it.old.conactGb,
           updUser:it.dto.updUser,  updIp:it.dto.updIp }], next, fail);
    }, fail);
  }

  /* 기존 계약 내리기(계약관리의 삭제와 같은 소프트 삭제 — ACTION_YN 을 N 으로) */
  window.jrcDrop = function(b){
    if (!JRC) return;
    var ex = JRC.conts[b]; if (!ex) return;
    var who = jrcWho();
    var nm  = (JRC.gbs.filter(function(g){ return g.gb === b; })[0] || {}).nm || b;
    _confirmBox(nm + ' 계약(' + jrcS2D(ex.startDt) + ' ~ ' + jrcS2D(ex.endDt) + ')을 삭제합니다.\n계속할까요?', function(){
      jrcBusy(true);
      jrcPost('/user/hospContDelete.do',
        [{ keyhospCd:JRC.hospCd, keystartDt:jrcD2S(ex.startDt),
           keyendDt:jrcD2S(ex.endDt), keyconactGb:b, updUser:who.user, updIp:who.ip }],
        function(){ jrcBusy(false); jrcReload(); },   /* 성공 알림 없음 — 위와 같은 지시 */
        function(){ jrcBusy(false); _alertBox('계약을 삭제하지 못했습니다.'); });
    });
  };

  /* 저장·삭제 뒤 그 병원의 계약을 다시 읽어 창을 새로 그린다(창은 열어 둔 채로 결과를 보여 준다) */
  function jrcReload(){
    if (!JRC) return;
    var hc = JRC.hospCd;
    $.ajax({ type:'post', url:'/user/hospContList.do', dataType:'json', data:{ hospCd:hc },
      success:function(C){
        if (!JRC || JRC.hospCd !== hc) return;          // 그 사이 창이 바뀌었으면 그만둔다
        JRC.conts = {}; JRC.cnts = {};
        ((C && C.data) ? C.data : []).forEach(function(c){
          var g = String(c.conactGb || ''); if (!g) return;
          JRC.cnts[g] = (JRC.cnts[g] || 0) + 1;
          if (!JRC.conts[g]) JRC.conts[g] = c;
        });
        jrcRender();
      },
      error:function(){ /* 다시 읽지 못해도 저장은 끝난 상태다 — 창의 값은 그대로 둔다 */ }
    });
  }

  /* ESC 로 닫기 — 창이 떠 있을 때만 */
  document.addEventListener('keydown', function(e){
    var m = gel('jrcMask');
    if (e.keyCode === 27 && m && m.style.display !== 'none') jrcClose();
  });

  $(function(){
    try {
      var z = parseFloat(localStorage.getItem(JR_Z_KEY));
      jrApplyZoom(z || JR_Z_DEF);          // 저장해 둔 개인 설정이 없으면 기본(한 단계 큰) 크기로 시작
    } catch (ignore) { jrApplyZoom(JR_Z_DEF); }
    jrList();

    /* [2026-08-20] 계약관리에서 [◀ 가입신청으로] 로 돌아오면 `?reqNo=` 를 달고 온다 —
       보던 신청을 **다시 펼쳐 준다.** 목록 조회가 끝나야 줄을 고를 수 있어 잠깐 기다린다
       (승인·반려 뒤 다시 펼치는 곳들과 같은 방식 : jrList() → 0.5초 → jrInfo()).
       ★★주소만 보면 안 된다 — tiles 템플릿 main.jsp 가 <head> 에서 주소를 '/user/dashboard.do' 로
         바꿔치기하며 **쿼리스트링을 지운다.** 지우기 전에 담아 둔 sessionStorage('_realPath') 를 함께 본다
         (hospcd.jsp 의 같은 주석·sidebar.jsp 의 qpsdev 스위치와 같은 함정). */
    try {
      var src = (window.location.search || '') + '|' + (sessionStorage.getItem('_realPath') || '');
      var m = /[?&]reqNo=([0-9]+)/.exec(src);
      if (m) setTimeout(function(){ jrInfo(m[1]); }, 500);
    } catch (ignore) {}
  });
})();
</script>
</div><%-- /.dashboard-wrapper --%>
