<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%-- qpsChkForm.jsp — 점검표 서식 관리(템플릿) (2026-08-11)

     ★★이 화면이 점검표 엔진의 핵심이다.
       간호/병동 메뉴 150여 개 중 실물은 20종뿐이고 나머지는 이름만 있다.
       그런데 그 이름 대부분이 `…점검표 / 점검대장 / 점검일지 / 관리대장`이다 — 같은 격자다.
       ⇒ ***화면을 130개 만들 일이 아니라, 여기서 서식을 등록하면 새 점검표가 생긴다.***

     ★축(AXIS_GB)이 표의 모양을 정한다 — 실물에서 관찰된 것만 둔다(추측으로 늘리지 않는다):
       EQUIP_DAY  기기 N행 × 1~31일    (원심분리기·인퓨전펌프·EKG모니터)
       ITEM_DAY   점검항목 행 × 1~31일  (EKG 일일·E.O gas 일상·네블라이저)
       DAY_ITEM   1~31일 행 × 점검항목 열 (Biological Dry Incubator·의료기기일일)
       ITEM_MONTH 점검항목 행 × 1~12월  (낙상 시설,환경 관리일지)
       LIST       항목 열 × 자유행 대장 (2026-08-12 추가 — 영양초기평가 불량환자 리스트·회수확인서 계열)
                  ★앞의 넷은 「날짜 격자」다. 대장은 날짜 칸이 아예 없고 행이 몇 줄인지도
                    그 달에 가 봐야 안다 — 그래서 행 수를 **문서**가 정한다.
                  ★DDL 은 안 바뀌었다. 셀이 (행,열,값) 하나로 담기기 때문이다.

     ★공통서식('*')은 여기서 못 고친다 — 고치면 **병원 전용 사본**이 만들어진다.
       한 병원이 고친 항목이 공통을 덮으면 전 병원 서식이 바뀐다.

     ★주의: 이 파일 안에서 Deferred EL 표기(샵+중괄호) 금지 --%>

<script src="/asset/js/ui-message.js"></script>

<div class="dashboard-wrapper">
<div id="qpsChkForm" data-wnn="<c:out value='${wnnYn}'/>">
<style>
  #qpsChkForm{ background:#f4f6f8; color:#1f2a30; min-height:100%; padding:14px 16px 60px; max-width:100%; overflow-x:hidden; }
  #qpsChkForm *{ box-sizing:border-box; }
  #qpsChkForm .cf-head{ display:flex; align-items:center; gap:10px; margin-bottom:12px; flex-wrap:wrap; }
  #qpsChkForm .cf-title{ font-size:18px; font-weight:800; color:#20303a; display:flex; align-items:center; gap:8px; }
  #qpsChkForm .cf-dot{ width:10px; height:10px; border-radius:50%; background:linear-gradient(135deg,#1f5a4b,#2a7665); }
  #qpsChkForm .cf-sub{ font-size:12px; color:#6b7c86; }
  #qpsChkForm .cf-hosp{ background:#e7f3ee; color:#1f5a4b; font-size:12px; font-weight:800;
      border:1px solid #cfe3da; border-radius:14px; padding:3px 11px; }
  #qpsChkForm .cf-spacer{ flex:1; }
  #qpsChkForm select, #qpsChkForm input, #qpsChkForm textarea{
      border:1px solid #cfd8e0; border-radius:5px; padding:5px 7px; font-family:inherit; font-size:12.5px; background:#fff; }
  #qpsChkForm textarea{ resize:vertical; line-height:1.55; width:100%; }
  #qpsChkForm .cf-btn{ border:1px solid #1f5a4b; background:#1f5a4b; color:#fff; border-radius:6px;
      padding:6px 14px; font-size:13px; font-weight:600; cursor:pointer; white-space:nowrap; }
  #qpsChkForm .cf-btn.ghost{ background:#fff; color:#1f5a4b; }
  #qpsChkForm .cf-btn.warn{ background:#fff; color:#b23b3b; border-color:#e0b4b4; }
  #qpsChkForm .cf-btn.mini{ padding:2px 9px; font-size:11.5px; border-color:#cfd8e0; color:#556570; background:#fff; }

  #qpsChkForm .cf-wrap{ display:flex; gap:14px; align-items:flex-start; }
  #qpsChkForm .cf-left{ width:340px; flex:none; }
  #qpsChkForm .cf-right{ flex:1; min-width:0; }
  #qpsChkForm .cf-card{ background:#fff; border:1px solid #e3e9ed; border-radius:10px; padding:14px 16px; margin-bottom:12px; }
  #qpsChkForm .cf-card h4{ margin:0 0 10px; font-size:14px; font-weight:800; color:#1f5a4b; }
  #qpsChkForm .cf-card h4 .hint{ font-weight:500; font-size:12px; color:#8a99a3; }
  #qpsChkForm .cf-list{ max-height:560px; overflow:auto; }
  #qpsChkForm .cf-item{ padding:8px 10px; border:1px solid #eef2f5; border-radius:8px; margin-bottom:6px; cursor:pointer; }
  #qpsChkForm .cf-item:hover{ border-color:#8fc3b2; background:#f7fbf9; }
  #qpsChkForm .cf-item.on{ border-color:#1f5a4b; background:#f0f7f4; }
  #qpsChkForm .cf-item .t{ font-size:13px; font-weight:700; color:#20303a; }
  #qpsChkForm .cf-item .d{ font-size:11.5px; color:#8a99a3; margin-top:2px; display:flex; gap:6px; flex-wrap:wrap; }
  #qpsChkForm .tag{ display:inline-block; padding:1px 6px; border-radius:3px; font-size:10.5px; font-weight:700; }
  #qpsChkForm .tag.axis{ background:#eef3f6; color:#43555f; }
  #qpsChkForm .tag.own{ background:#e7f3ee; color:#1f5a4b; }
  #qpsChkForm .tag.std{ background:#f5f0e6; color:#8a6a2b; }
  #qpsChkForm .cf-empty{ color:#8a99a3; font-size:12.5px; padding:16px 6px; text-align:center; }

  #qpsChkForm .cf-form{ display:grid; grid-template-columns:112px 1fr 112px 1fr; gap:9px 10px; align-items:start; }
  #qpsChkForm .cf-form .lb{ font-size:12.5px; font-weight:700; color:#43555f; padding-top:8px; }
  #qpsChkForm .cf-form .full{ grid-column:2 / -1; }
  #qpsChkForm .cf-form input, #qpsChkForm .cf-form select{ width:100%; }
  #qpsChkForm table.ed{ width:100%; border-collapse:collapse; font-size:12px; }
  #qpsChkForm table.ed th{ background:#f2f6f8; border:1px solid #dde5ea; padding:5px 3px; font-weight:700; color:#43555f; }
  #qpsChkForm table.ed td{ border:1px solid #e6ecef; padding:2px; }
  #qpsChkForm table.ed input, #qpsChkForm table.ed select{ width:100%; border:none; background:transparent; padding:4px 3px; font-size:12px; }
  #qpsChkForm table.ed input:focus, #qpsChkForm table.ed select:focus{ background:#f7fbf9; outline:1px solid #8fc3b2; }
  #qpsChkForm .rowdel{ color:#b23b3b; cursor:pointer; font-weight:700; text-align:center; width:26px; }
  #qpsChkForm .movebtn{ color:#556570; cursor:pointer; text-align:center; width:22px; font-size:11px; }
  #qpsChkForm .warnbox{ background:#fff8f2; border:1px solid #f0d9c0; border-radius:6px;
      padding:7px 10px; font-size:12px; color:#8a5a2b; margin-bottom:10px; }
  #qpsChkForm .infobox{ background:#f2f8f5; border:1px solid #cfe3da; border-radius:6px;
      padding:8px 11px; font-size:12px; color:#33564a; margin-bottom:10px; line-height:1.6; }
  #qpsChkForm .prev{ border:1px solid #dfe4ea; border-radius:6px; padding:8px; overflow-x:auto; background:#fcfdfe; }
  #qpsChkForm .prev table{ border-collapse:collapse; font-size:10.5px; }
  #qpsChkForm .prev th, #qpsChkForm .prev td{ border:1px solid #b9c3ca; padding:2px 4px; text-align:center; white-space:nowrap; }
  #qpsChkForm .prev th{ background:#eef3f6; }
  #qpsChkForm .prev td.l{ text-align:left; }
  /* ── 탭 · 글자 크기 (2026-08-15) — 카드가 세로로 쌓여 스크롤이 길다는 지적.
       ★한 화면에 들어가면 **탭을 내지 않는다**(고정으로 달지 않는다).
       ★탭 이름은 카드 제목에서 뽑고, 많으면 이웃끼리 묶어 **최대 4개**. */
  /* ★[2026-08-18 요청] 탭 띠를 **오른쪽으로** 옮겼다 — 왼쪽은 서식 목록이 차지하는 자리라
       탭이 목록 위에 얹혀 있으면 「목록의 제목」처럼 읽힌다. 오른쪽 = 탭이 여는 내용이 있는 쪽이다.
     ⚠아래 .zz-mode 의 margin-left:auto 를 함께 없애야 한다 —
       auto 여백이 남는 자리를 다 먹어 ***justify-content 가 듣지 않는다.*** */
  #qpsChkForm .zz-tabs{ display:flex; gap:6px; margin:0 0 10px; flex-wrap:wrap; align-items:center;
      justify-content:flex-end; }
  #qpsChkForm .zz-tab{ border:1px solid #cfd9e0; background:#f4f7f9; color:#43555f; border-radius:8px 8px 0 0;
                   padding:7px 15px; font-size:13.5px; font-weight:700; cursor:pointer; }
  #qpsChkForm .zz-tab:hover{ background:#e9eff3; }
  #qpsChkForm .zz-tab.on{ background:#1f5a4b; border-color:#1f5a4b; color:#fff; }
  #qpsChkForm .zz-tab.dim{ opacity:.5; }
  /* margin-left:auto 를 뺐다 — 위 .zz-tabs 의 오른쪽 정렬이 듣게 하려는 것이다.
     [서식 정의][점검항목][미리보기] 다음에 [전체 보기] 가 나란히 오른쪽 끝에 선다. */
  #qpsChkForm .zz-mode{ margin-left:8px; border:1px solid #1f5a4b; background:#fff; color:#1f5a4b;
                    border-radius:8px; padding:7px 14px; font-size:13px; font-weight:700; cursor:pointer; }
  #qpsChkForm .zz-mode.on{ background:#1f5a4b; color:#fff; }
  #qpsChkForm .zz-zoom{ display:inline-flex; gap:4px; align-items:center; margin-left:2px; }
  #qpsChkForm .zz-zoom button{ border:1px solid #cfd9e0; background:#fff; color:#43555f; border-radius:6px;
                           padding:4px 9px; font-size:13px; font-weight:700; cursor:pointer; }
  #qpsChkForm .zz-zoom button:hover{ background:#eef3f6; }
</style>

<div class="cf-head">
  <div class="cf-title"><span class="cf-dot"></span>점검표 서식 관리
    <span class="cf-sub">— 여기에 등록하면 [점검표 작성]에 새 서식이 생깁니다</span></div>
  <span class="cf-hosp" id="cfHosp">🏥 <c:out value="${hospNm}" default="병원 미확인"/></span>
  <div class="cf-spacer"></div>
  <%-- 목록 필터. ★새 서식을 쓰는 중이면 아래 폼의 부서·분류도 따라간다(cfFilterChange) --%>
  <select id="cfDept" style="width:auto;" onchange="cfFilterChange();">
    <option value="">전체 부서</option>
  </select>
  <select id="cfCate" style="width:auto;" onchange="cfFilterChange();">
    <option value="">전체 분류</option>
  </select>
  <button type="button" class="cf-btn" onclick="cfSave();">저장</button>
  <button type="button" class="cf-btn ghost" onclick="cfCopy();">📋 복제</button>
  <button type="button" class="cf-btn warn" id="cfDelBtn" onclick="cfDel();" style="display:none;">기본으로 되돌리기</button>
  <span class="cf-sub" id="cfStat"></span>
  <span style="flex:0 0 60px;"></span>
  <%-- 글자 크기 — 이 PC 이 브라우저에만 저장된다 --%>
  <span class="zz-zoom">
    <button type="button" onclick="zzZoom(-1);" title="글자 작게">가－</button>
    <button type="button" onclick="zzZoom(1);"  title="글자 크게">가＋</button>
    <button type="button" onclick="zzZoom(0);"  title="처음 크기로">↺</button>
  </span>
</div>
<%-- ★탭 — 내용이 한 화면을 넘칠 때만 나온다(zzSync 가 재 본다) --%>
<div class="zz-tabs" id="zzTabs" style="display:none;"></div>

<div class="cf-wrap">
  <div class="cf-left">
    <div class="cf-card">
      <h4>서식 목록 <span class="hint" id="cfCnt"></span></h4>
      <%-- ★체크 = 이 병원이 쓰는 서식. 켠 것만 [점검표 작성]에 나온다.
           130종을 모든 병원에 다 보여주면 못 쓴다(정신 폴더 on/off 도 이걸로 푼다). --%>
      <div style="display:flex; gap:6px; align-items:center; margin-bottom:6px; flex-wrap:wrap;">
        <span class="cf-sub" id="cfUseHint" style="flex:1;">체크 = 이 병원이 쓰는 서식</span>
        <button type="button" class="cf-btn mini" onclick="cfUseAll(true);">전체 켬</button>
        <button type="button" class="cf-btn mini" onclick="cfUseAll(false);">전체 끔</button>
        <button type="button" class="cf-btn mini" onclick="cfUseSave();">사용 저장</button>
      </div>
      <div class="cf-list" id="cfListBox"><div class="cf-empty">불러오는 중…</div></div>
      <button type="button" class="cf-btn ghost" style="width:100%; margin-top:6px;" onclick="cfNew();">＋ 새 서식</button>
    </div>
  </div>

  <div class="cf-right">
    <div class="cf-card">
      <h4>서식 정의</h4>
      <%-- ★서식을 만들 때 지켜야 하는 것 — 사용자 지시 2026-08-11 :
           "서식 생성시 주의사항은 데이터 추출 가능이어야 함". 그림처럼 만들면 뽑을 수 없다. --%>
      <div class="warnbox">
        <b>⚠ 서식을 만들 때 — 「나중에 뽑을 수 있는가」를 먼저 보세요.</b><br>
        ① <b>한 칸에 한 가지</b>만 적게 하세요. 「온도/습도」를 한 칸에 받으면 둘 다 못 셉니다 — 항목을 나누세요.<br>
        ② <b>입력 종류를 맞추세요.</b> O/X 칸은 <b>O / X</b> 로 저장됩니다(○·V·1 을 적어도 자동으로 맞춥니다).
        숫자는 <b>숫자</b>, 이름은 <b>글자</b>로 두어야 집계가 됩니다.<br>
        ③ 항목 문구는 <b>원본 그대로</b> — 뽑은 자료의 열 이름이 됩니다.<br>
        <span style="color:#6b7c86;">추출은 [점검표 작성 ▸ 📊 데이터 추출]에서 CSV 로 나옵니다
        (서식·부서·연·월·병동·<b>항목</b>·일·값).</span>
      </div>
      <div class="infobox" id="cfOwnMsg" style="display:none;"></div>
      <div class="cf-form">
        <%-- ★서식코드는 기계용 열쇠다 — 사람은 서식명으로 본다.
             한 번 정하면 **못 바꾼다**(바꾸면 이미 작성한 점검표와 끊긴다) → 고를 때만 readOnly.
             ★새 서식에서 이미 있는 코드를 치면 서버가 막는다(안 막으면 남의 서식을 덮어쓴다). --%>
        <div class="lb">서식코드 *</div>
        <div style="display:flex; gap:6px;">
          <input type="text" id="f_formId" maxlength="30" style="flex:1;"
                 placeholder="영문 대문자·숫자·_ (예: O2TANK)">
          <button type="button" class="cf-btn mini" id="cfAutoBtn" onclick="cfAutoId();"
                  title="자동으로 코드 만들기">자동</button>
        </div>
        <%-- ★부서·분류가 없으면 여기서 바로 추가한다(공통코드 화면으로 나갔다 오지 않게).
             추가만 — 이름 바꾸기·지우기는 공통코드 화면에서(딸린 서식을 봐야 판단할 수 있다). --%>
        <div class="lb">부서 *</div>
        <div style="display:flex; gap:6px;">
          <select id="f_deptCd" style="flex:1;"><option value="">— 선택 —</option></select>
          <button type="button" class="cf-btn mini" onclick="cfCodeAdd('QPS_CHK_DEPT','부서');"
                  title="부서 추가">＋</button>
        </div>

        <div class="lb">분류</div>
        <div class="full" style="display:flex; gap:6px; align-items:center; flex-wrap:wrap;">
          <select id="f_cateCd" style="width:auto; min-width:200px;"><option value="">— 선택 —</option></select>
          <button type="button" class="cf-btn mini" onclick="cfCodeAdd('QPS_CHK_CATE','분류');"
                  title="분류 추가">＋</button>
          <%-- ★[2026-08-18] 분류 후보는 **부서마다 정해 둔 규칙**을 따른다 — 그 규칙을 여기서 바로 연다.
               (규칙이 없는 부서는 전 분류. 정하는 자리를 못 찾아 헤매지 않게 링크를 옆에 둔다.) --%>
          <a href="/main/qpsDeptCate.do" class="cf-sub" style="text-decoration:underline;"
             title="부서마다 고를 수 있는 분류를 정합니다">부서별 분류 정하기</a>
          <span class="cf-sub">부서 = 누가 쓰나 · 분류 = 무엇을 점검하나</span></div>

        <div class="lb">서식명 *</div>
        <div class="full"><input type="text" id="f_formNm" maxlength="200" placeholder="원본 문서명 그대로 (예: O2탱크 점검대장)"></div>

        <div class="lb">표 모양 *</div>
        <div class="full" style="display:flex; gap:8px; align-items:center; flex-wrap:wrap;">
          <select id="f_axisGb" style="width:auto; min-width:340px;" onchange="cfAxisChange();">
            <option value="ITEM_DAY">점검항목(행) × 1~31일(열) — 가장 흔함</option>
            <option value="DAY_ITEM">1~31일(행) × 점검항목(열)</option>
            <option value="EQUIP_DAY">기기 N대(행) × 1~31일(열) — 항목은 표 위 안내로</option>
            <option value="ITEM_MONTH">점검항목(행) × 1~12월(열) — 연 1장</option>
            <option value="LIST">대장 — 항목(열) × 자유행 · 작성자가 행을 늘린다</option>
            <option value="ITEM_COL">점검항목(행) × 고정 열 — 날짜가 없는 점검표(Y/N·결과/조치 …)</option>
          </select>
          <span id="f_equipWrap" style="display:none; font-size:12.5px; color:#43555f;">
            <span id="f_equipLb">기기 행 수</span>
            <input type="number" id="f_equipCnt" min="1" max="50" value="10" style="width:70px;">
          </span>
          <%-- ★격자의 기간 칸이 무엇인가 — 축은 「방향」만 말하고 여기가 「무엇」을 말한다.
               DAY_ITEM + 월 이면 「1~12월 행 × 항목 열」이 되어 새 축이 필요 없다 --%>
          <span id="f_kindWrap" style="display:none; font-size:12.5px; color:#43555f;">
            기간 칸 <select id="f_prdKind" style="width:auto;" onchange="cfAxisChange();">
                      <option value="D">1~31일 (그 달의 날 수)</option>
                      <option value="W">요일 7칸 (월~일)</option>
                      <option value="N">주차 5칸 (1~5주)</option>
                      <option value="M">1~12월</option>
                      <option value="Q">분기 4칸 (1~4분기)</option>
                    </select>
            <%-- ★기간 세분(2026-08-12) — 기간 칸 안을 쪼갠다. D,E,N / 10시,15시 / 상,중,하.
                 값이 서식마다 달라 고정 목록으로는 안 된다 — 서식이 이름을 정한다. --%>
            칸 나누기 <input type="text" id="f_prdSub" maxlength="200" style="width:150px;"
                   placeholder="쉼표로. 예) D,E,N" oninput="cfAxisChange();">
            <span class="cf-sub" id="cfSubHint"></span>
            <%-- ★주기 복합(2026-08-14) — 묶음마다 기간 축이 다른 격자. 진단검사 기기 점검표 10종.
                 「매일 1~31일 / 매주 1~5주 / 매월 한 칸」이 한 장에 세로로 붙은 판이다.
                 묶음 이름은 **항목표의 묶음(GRP_NM)** 을 그대로 쓴다 — 여기서는 축만 정한다. --%>
            <span id="f_grpPrdWrap" style="display:none;">
              주기 복합 <input type="text" id="f_grpPrd" maxlength="300" style="width:230px;"
                     placeholder="묶음&gt;축. 예) 매일&gt;D,매주&gt;N,매월&gt;1" oninput="cfAxisChange();">
              <span class="cf-sub" id="cfGrpPrdHint"></span>
            </span>
            <%-- ★기간 열 머리글 입력 행(2026-08-12) — CCTV·가스보일러의 주차 밑 「-」 칸.
                 서식이 아니라 **문서가 값을 적는** 한 줄이라 켜고 끄기만 서식이 정한다.
                 기간이 열이고 항목이 행인 두 축만(ITEM_DAY·ITEM_MONTH) — cfAxisChange 가 가린다. --%>
            <span id="f_prdHeadWrap" style="display:none;">
              <label style="margin-left:10px;"><input type="checkbox" id="f_prdHeadYn" style="vertical-align:-2px;"
                     onchange="cfAxisChange();"> 기간마다 문서가 적는 머리글 한 줄</label>
              <input type="text" id="f_prdHeadNm" maxlength="60" style="width:130px;"
                     placeholder="줄 이름. 예) 점검자" oninput="cfAxisChange();">
            </span>
          </span>
          <%-- ★대장만 주기를 고른다 — 날짜 격자는 축이 이미 정한다.
               달마다 새로 쓰는 대장(잔여마약류 반납)과 한 해를 이어 쓰는 대장(조제 전/후 감사)이 둘 다 있다 --%>
          <span id="f_prdWrap" style="display:none; font-size:12.5px; color:#43555f;">
            주기 <select id="f_prdGb" style="width:auto;">
                   <option value="M">월 1장 — 연·월로 나눠 씀</option>
                   <option value="Y">연 1장 — 한 해를 이어 씀</option>
                   <option value="H">반기 1장 — 상/하반기</option>
                   <option value="Q">분기 1장 — 1~4분기</option>
                   <option value="W">주 1장 — 월 안에서 1~5주차</option>
                   <option value="D">일 1장 — 날마다 한 장</option>
                 </select>
          </span>
          <%-- ★인쇄만 나눈다. 화면은 한 표 그대로 — 편집은 한 표가 편하고 종이만 원본을 따라간다.
               ★「반으로」가 아니라 「N칸씩 + 방향」이다(2026-08-12) — 15칸·6칸·7칸·좌우가 다 이 하나로 --%>
          <span id="f_splitWrap" style="display:none; font-size:12.5px; color:#43555f;">
            인쇄 나누기
            <select id="f_splitDir" style="width:auto;" onchange="cfAxisChange();">
              <option value="">안 나눔</option>
              <option value="C">열을 끊어 위아래로</option>
              <option value="R">행을 끊어 좌우로</option>
            </select>
            <input type="number" id="f_splitN" min="2" max="99" value="15" style="width:64px;"
                   onchange="cfAxisChange();" oninput="cfAxisChange();"> 칸씩
            <span class="cf-sub" id="cfSplitHint"></span>
          </span>
        </div>

        <%-- ★ITEM_COL 전용 — 이 축은 열을 축이 안 정하므로 서식이 적어야 한다 --%>
        <div class="lb" id="f_colLb" style="display:none;">고정 열 *</div>
        <div class="full" id="f_colWrap" style="display:none;">
          <%-- ★열 이름을 **문서가 정하는** 서식이 있다(MSDS 물질명 · 소방 층·병동, 2종).
               EQUIP_DAY 의 기기명과 같은 일이라 고르는 자리를 열 칸 바로 위에 둔다. --%>
          <select id="f_colSrc" style="width:auto; margin-bottom:4px;" onchange="cfAxisChange();">
            <option value="F">열 이름을 서식이 정함</option>
            <option value="D">열 이름을 문서가 정함 (물질명·층·병동처럼 병원마다 다름)</option>
          </select>
          <input type="text" id="f_colNms" maxlength="600" placeholder="쉼표로. 예) Y,N,비고"
                 oninput="cfAxisChange();"><%-- cfAxisChange 가 cfColHint + renderPrev 를 함께 돈다 --%>
          <div class="cf-sub" id="cfColHint" style="margin-top:3px;"></div>
        </div>

        <%-- ★행 블록 — 한 문서에 표가 여럿, ***열은 같다***(2026-08-12).
             LIST 는 행이 자유라 서식이 블록을 적어야 하고, 항목이 행인 축은 이미 있는
             항목의 「묶음」을 **가로 띠로 그릴지**만 고르면 된다. 그래서 자리가 둘로 갈린다. --%>
        <div class="lb" id="f_blkLb" style="display:none;">행 블록</div>
        <div class="full" id="f_blkWrap" style="display:none;">
          <input type="text" id="f_rowBlks" maxlength="600"
                 placeholder="쉼표로. 예) 병원 근무자&gt;17,배송기사&gt;3,대체인력&gt;3"
                 oninput="cfAxisChange();">
          <div class="cf-sub" id="cfBlkHint" style="margin-top:3px;"></div>
        </div>
        <div class="lb" id="f_bandLb" style="display:none;">묶음 표시</div>
        <div class="full" id="f_bandWrap" style="display:none;">
          <select id="f_rowBlkGb" style="width:auto;" onchange="cfAxisChange();">
            <option value="S">왼쪽 세로 칸</option>
            <option value="B">가로 띠 (표를 가로지르는 머리 행)</option>
          </select>
          <%-- ★묶음 이름을 **문서**가 정하는 서식이 있다(응급 약품 점검 기록부 · 소화기 관리대장 등). --%>
          <select id="f_rowSrc" style="width:auto; margin-left:6px;" onchange="cfAxisChange();">
            <option value="F">묶음 이름을 서식이 정함</option>
            <option value="D">묶음 이름을 문서가 정함 (약품·소화기처럼 병원마다 다름)</option>
          </select>
          <div class="cf-sub" id="cfBandHint" style="margin-top:3px;"></div>
        </div>

        <%-- ★격자 옆에 붙는 칸(2026-08-12) — ***둘로 갈린다.***
             「설명」은 항목마다 늘 같은 글이라 **항목 표**에서 적고, 여기서는 그 열의 이름만 정한다.
             「앞/뒤 칸」은 문서가 달마다 적는 값이라 이름만 여기서 정한다. --%>
        <div class="lb" id="f_sideLb" style="display:none;">격자 옆 칸</div>
        <div class="full" id="f_sideWrap" style="display:none;">
          <div style="display:flex; gap:6px; flex-wrap:wrap;">
            <input type="text" id="f_descNm" maxlength="60" style="flex:1 1 150px;"
                   placeholder="항목 설명 열 이름. 예) 청소방법" oninput="cfAxisChange();">
            <input type="text" id="f_preCols" maxlength="300" style="flex:1 1 150px;"
                   placeholder="앞 칸(쉼표). 예) 수량" oninput="cfAxisChange();">
            <input type="text" id="f_postCols" maxlength="300" style="flex:1 1 150px;"
                   placeholder="뒤 칸(쉼표). 예) 예산,조치사항" oninput="cfAxisChange();">
          </div>
          <%-- ★격자 아래 자유행 표(2026-08-13) — 열 이름은 서식이, 행은 문서가 늘린다.
               멸균기·음용수의 「문제 발생시」 표가 이것이다. 왼쪽 이름 칸은 비우면 안 그린다. --%>
          <div style="display:flex; gap:6px; flex-wrap:wrap; margin-top:4px;">
            <input type="text" id="f_subNm" maxlength="60" style="flex:1 1 150px;"
                   placeholder="아래 표 이름 칸(선택). 예) 문제 발생시">
            <input type="text" id="f_subCols" maxlength="300" style="flex:2 1 220px;"
                   placeholder="아래 자유행 표 열 이름(쉼표). 예) 발생일자,관리번호,문제 발생 내용,처리 결과 보고">
          </div>
          <div class="cf-sub" id="cfSideHint" style="margin-top:3px;"></div>
          <%-- ★고정 띠(항목의 「고정 띠 문구」)가 뒤 칸까지 덮는가 — 근거 3종이 둘로 갈린다 :
               연간 시설물·소방 계획은 예산 칸을 남기고, 소방시설 월 점검표는 상태 칸까지 덮는다. --%>
          <label id="f_spanAllWrap" style="display:none; font-size:12px; margin-top:4px;">
            <input type="checkbox" id="f_spanAllYn" style="vertical-align:-2px;" onchange="cfAxisChange();">
            고정 띠 문구가 뒤 칸까지 덮음 (소방시설 월 점검표처럼)
          </label>
        </div>

        <div class="lb">표 위 안내</div>
        <div class="full"><input type="text" id="f_guideTxt" maxlength="200" placeholder="예) 정상 : O 비정상 : X"></div>
        <div class="lb">상단 자유칸</div>
        <div class="full">
          <input type="text" id="f_headNms" maxlength="600" placeholder="쉼표로. 예) 장비명,모델명,사용부서,점검주기"
                 oninput="cfHeadCount();">
          <div class="cf-sub" id="cfHeadCnt" style="margin-top:3px;">최대 8칸까지. 넘으면 뒤는 안 나옵니다.</div>
        </div>

        <div class="lb">덧붙일 칸</div>
        <div class="full" style="display:flex; gap:16px; flex-wrap:wrap; padding-top:6px;">
          <label style="font-size:12.5px;"><input type="checkbox" id="f_signerYn" style="vertical-align:-2px;"> 점검자 사인 행</label>
          <label style="font-size:12.5px;"><input type="checkbox" id="f_noteYn" style="vertical-align:-2px;"> 특이사항</label>
          <%-- ★칸 이름을 서식이 정한다(2026-08-12) — 조치사항·기타 이상내용. 비면 「특이사항」. --%>
          <input type="text" id="f_noteNm" maxlength="60" style="width:150px;" placeholder="칸 이름(비면 특이사항)">

          <label style="font-size:12.5px;"><input type="checkbox" id="f_fixYn" style="vertical-align:-2px;"> 수리날짜·고장내용</label>
        </div>

        <div class="lb">하단 서명란</div>
        <div><input type="text" id="f_signLine" maxlength="200" placeholder="쉼표. 예) 부서장,원무과장"></div>
        <div class="lb">정렬</div>
        <div><input type="number" id="f_sortNo" value="0" style="width:90px;"></div>

        <div class="lb">하단 ※ 문구</div>
        <div class="full"><textarea id="f_footTxt" rows="2"></textarea></div>
      </div>
    </div>

    <div class="cf-card">
      <h4>점검항목 <span class="hint" id="cfItemHint"></span></h4>
      <table class="ed"><thead><tr>
        <th style="width:34px;">순번</th>
        <th>점검항목</th>
        <%-- ★뜻이 축에 따라 갈린다 — 항목이 열이면 「열 묶음」, 행이면 「행 묶음」. cfAxisChange 가 고쳐 쓴다 --%>
        <th style="width:130px;" id="thGrpNm">묶음</th>
        <%-- ★블록 띠(2026-08-12) — 묶음 위의 **가로 띠** 한 단(혼합형 공기조화설비의 자연환기/기계환기).
             항목이 행인 세 축만. 이어지는 같은 이름이 한 띠가 된다 --%>
        <th style="width:110px;" id="thBlkNm" hidden>블록 띠</th>
        <%-- ★항목마다 늘 같은 글(청소방법·설치 위치). 서식의 「항목 설명 열」을 켜야 보인다 --%>
        <th style="width:150px;" id="thDescTxt" hidden>설명</th>
        <%-- ★고정 띠 문구(2026-08-12) — 값이 있으면 그 행의 격자가 입력칸이 아니라 이 글 한 칸이 된다
             (「매월 1회 실시」·「자동화재탐지 설비와 연동」) --%>
        <th style="width:140px;" id="thSpanTxt" hidden>고정 띠 문구</th>
        <th style="width:90px;">입력</th>
        <th style="width:56px;">단위</th>
        <%-- ★전월복사에서 가져올 열(2026-08-12) — 대장(LIST)만. 자산 목록은 가져오고 점검 결과는 비운다.
             ***켜지 않으면 안 가져온다*** — 지난달 결과가 남으면 「점검했다」로 보이기 때문이다. --%>
        <th style="width:64px;" id="thCarry" hidden>전월<br>복사</th>
        <th style="width:44px;">이동</th>
        <th style="width:26px;"></th>
      </tr></thead><tbody id="tbITEM"></tbody></table>
      <button type="button" class="cf-btn mini" style="margin-top:6px;" onclick="cfAddItem();">＋ 항목 추가</button>
      <button type="button" class="cf-btn mini" onclick="cfPasteOpen();">📥 일괄 붙여넣기</button>
      <button type="button" class="cf-btn mini" onclick="cfExport();">💾 시드 SQL 내보내기</button>
      <span class="cf-sub" style="margin-left:8px;">빈 줄은 저장할 때 버려집니다.</span>

      <%-- ★일괄 붙여넣기 — 130종을 한 줄씩 손으로 넣을 수 없다.
           원본 서식이나 엑셀에서 항목을 복사해 그대로 붙인다. --%>
      <div id="cfPasteBox" style="display:none; margin-top:8px; border:1px solid #dfe4ea; border-radius:6px; padding:10px;">
        <div style="font-size:12.5px; color:#43555f; margin-bottom:6px;">
          <b>한 줄에 항목 하나</b>씩 붙여넣으세요. 엑셀에서 세로로 복사하면 그대로 들어갑니다.<br>
          <span style="color:#8a99a3;">탭이나 <b>|</b> 로 나누면 <b>항목 ▸ 열묶음 ▸ 입력(CHECK/TEXT/NUM) ▸ 단위 ▸ 전월복사(Y)</b> 로 읽습니다.</span>
        </div>
        <textarea id="cfPasteTxt" rows="8" placeholder="전원 상태&#10;외관 및 내부청결 상태 점검&#10;온도|치료실 환경|NUM|℃"></textarea>
        <div style="margin-top:6px; display:flex; gap:8px; align-items:center;">
          <label style="font-size:12.5px;"><input type="checkbox" id="cfPasteAppend" style="vertical-align:-2px;"> 기존 항목 뒤에 덧붙이기(기본은 교체)</label>
          <span style="flex:1;"></span>
          <button type="button" class="cf-btn mini" onclick="cfPasteApply();">넣기</button>
          <button type="button" class="cf-btn mini" onclick="document.getElementById('cfPasteBox').style.display='none';">닫기</button>
        </div>
      </div>

      <%-- ★시드 SQL — 개발 PC 에서 만든 서식을 docs/sql 에 넣어 다른 환경으로 옮긴다 --%>
      <div id="cfSqlBox" style="display:none; margin-top:8px; border:1px solid #dfe4ea; border-radius:6px; padding:10px;">
        <div style="font-size:12.5px; color:#43555f; margin-bottom:6px;">
          아래를 복사해 <b>docs/sql</b> 의 시드 파일에 붙이면 다른 환경에도 같은 서식이 생깁니다.
          <span style="color:#8a99a3;">(HOSP_CD 를 <b>'*'</b> 로 두면 공통 표준 서식이 됩니다)</span>
        </div>
        <textarea id="cfSqlTxt" rows="10" style="font-family:Consolas,monospace; font-size:11.5px;"></textarea>
        <div style="margin-top:6px; display:flex; gap:8px;">
          <span style="flex:1;"></span>
          <button type="button" class="cf-btn mini" onclick="cfSqlCopy();">복사</button>
          <button type="button" class="cf-btn mini" onclick="document.getElementById('cfSqlBox').style.display='none';">닫기</button>
        </div>
      </div>
    </div>

    <div class="cf-card">
      <h4>미리보기 <span class="hint" id="cfPrevHint">— 실제 작성 화면과 같은 모양(앞 5칸만)</span></h4>
      <div style="display:flex; gap:8px; margin-bottom:8px; flex-wrap:wrap;">
        <button type="button" class="cf-btn mini" id="cfPrevWideBtn" onclick="cfPrevWide();">↔ 한 달 전체 보기</button>
        <%-- ★서식 관리와 작성 화면을 오갈 길이 없으면, 만든 서식의 실물을 보려고
             메뉴를 다시 찾아 서식을 또 골라야 한다(2026-08-11 사용자 지적).
             ★새 창으로 연다 — QPS 공통(보고 나서 서식 관리로 돌아와야 한다). --%>
        <button type="button" class="cf-btn ghost" onclick="cfOpenWrite();">🔎 작성 화면에서 보기(새 창)</button>
        <span class="cf-sub" style="align-self:center;">저장한 뒤에 눌러야 바뀐 내용이 보입니다.</span>
      </div>
      <div class="prev" id="cfPrev"></div>
    </div>
  </div>
</div>

<script>
(function(){
  var HOSP_NM = '', CATE = [], DEPT = [], LIST = [], curId = '', curOwn = 'N';

  function gel(id){ return document.getElementById(id); }
  function post(url, data){
    return $.ajax({ url:url, type:'POST', data:data, dataType:'json' }).then(function(res){
      if (res && res.result === 'FAIL') { throw new Error(res.message || '처리에 실패했습니다.'); }
      return res;
    });
  }
  function err(e){ _alertBox((e && e.message) ? e.message : '처리 중 오류가 발생했습니다.', {icon:'❌'}); }
  function esc(s){ return (s==null?'':String(s)).replace(/[&<>"]/g, function(c){
      return ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;'})[c]; }); }
  function val(id){ var e = gel(id); return e ? String(e.value).trim() : ''; }
  function set(id, v){ var e = gel(id); if (e) e.value = (v == null ? '' : v); }
  function chk(id){ var e = gel(id); return (e && e.checked) ? 'Y' : 'N'; }
  function setChk(id, v){ var e = gel(id); if (e) e.checked = (v === 'Y'); }
  function axis(){ return val('f_axisGb') || 'ITEM_DAY'; }

  var AXIS_NM = { ITEM_DAY:'항목 × 일', DAY_ITEM:'일 × 항목', EQUIP_DAY:'기기 × 일',
                  ITEM_MONTH:'항목 × 월', LIST:'대장 (자유행)' };
  // ★항목이 **열**이 되는 축 — 열 묶음(2단 머리글)이 성립하는 곳이 정확히 여기다
  function itemIsCol(a){ return a === 'DAY_ITEM' || a === 'LIST'; }
  // 반달 접기는 일이 열인 축에서만. 체크가 켜져 있어도 다른 축이면 꺼진 것으로 본다(서버도 같게 막는다)
  /** 인쇄 나누기 설정 → {n, dir} 또는 null. 작성 화면(splitOf)과 **같은 규칙**이어야 한다. */
  function splitOf(){
    var dir = val('f_splitDir'), n = Number(val('f_splitN') || 0), a = axis();
    if ((dir !== 'C' && dir !== 'R') || !(n >= 2)) return null;
    // 열 끊기는 격자에 기간 칸이 있어야 뜻이 있다 — LIST·ITEM_COL 은 자를 기준이 없다
    if (dir === 'C' && (a === 'LIST' || a === 'ITEM_COL')) return null;
    return { n:n, dir:dir };
  }
  /**
   * 몇 조각이 되나 — ***작성 화면 `splitRanges()` 와 규칙이 같아야 한다.***
   * 자투리가 1칸이면 앞 조각에 붙는다(31일 15칸씩 → 3조각이 아니라 `1~15 / 16~31` 2조각).
   */
  function splitParts(total, n){
    if (!(total > 0) || !(n >= 2)) return 0;
    var c = Math.ceil(total / n);
    if (c > 1 && total % n === 1) c -= 1;
    return c;
  }
  /**
   * 끊는 대상이 몇 칸인가 — 열이면 기간 칸, 행이면 행 수.
   * ⚠***대장(LIST)의 행은 항목이 아니다*** — 항목은 열이다. 항목 수로 세면
   *   「10칸씩」이 실제 행 수와 아무 상관 없는 숫자가 되어 미리보기가 거짓말을 한다.
   */
  function splitTotal(dir){
    if (dir === 'C') return prevCells(true).length;
    if (axis() === 'LIST') {
      var bd = blkDefs();
      return bd.length ? bd.reduce(function(s, b){ return s + b.n; }, 0)
                       : Math.max(1, Number(val('f_equipCnt') || 10));
    }
    return readItems().length + (chk('f_signerYn') === 'Y' ? 1 : 0);
  }

  /** 미리보기 아래에 붙이는 한 줄 — **화면은 한 표, 종이만 나뉜다**는 것을 알려 준다. */
  function splitNote(){
    var sp = splitOf(); if (!sp) return '';
    var cnt = splitParts(splitTotal(sp.dir), sp.n);
    return '<div style="font-size:10.5px;color:#8a99a3;margin-top:4px;">✂ 인쇄하면 ' +
           (sp.dir === 'C' ? '열' : '행') + ' <b>' + sp.n + '칸씩</b> ' +
           (cnt ? ('<b>' + cnt + '조각</b>으로 ') : '') +
           (sp.dir === 'C' ? '위아래' : '좌우') + '로 나뉘어 찍힙니다(화면은 한 표 그대로).</div>';
  }

  /** 몇 조각이 되는지 적어 준다 — ***「7칸씩」이 5쪽이 된다는 걸 적는 자리에서 알아야 한다.*** */
  window.cfSplitHint = function(){
    var e = gel('cfSplitHint'); if (!e) return;
    var sp = splitOf();
    if (!sp) { e.textContent = ''; return; }
    var total = splitTotal(sp.dir), cnt = splitParts(total, sp.n);
    e.textContent = cnt ? ('→ ' + cnt + '조각 (' + (sp.dir === 'C' ? '기간 칸 ' : '행 ') + total + '개)') : '';
  };
  /** 격자 기간 칸 종류 — 작성 화면(qpsChk.jsp)의 kind() 와 **같은 규칙**이어야 한다. */
  function kindOf(){
    var a = axis();
    if (a === 'LIST' || a === 'ITEM_COL') return '';       // 격자에 기간이 없다
    var k = val('f_prdKind') || '';
    return ('DWNMQ'.indexOf(k) >= 0 && k) ? k : (a === 'ITEM_MONTH' ? 'M' : 'D');
  }
  /* ═══ 주기 복합 (2026-08-14) — 묶음마다 기간 축이 다르다 ═══
     작성 화면(qpsChk.jsp)의 grpPrdList/grpPrdOn 과 **같은 규칙**이어야 한다 — 갈리면 미리보기가 거짓말을 한다. */
  function grpPrdOf(){
    var s = val('f_grpPrd') || '';
    if (!s) return [];
    return s.split(',').map(function(t){
      var p = t.split('>'), nm = String(p[0] || '').trim(), k = String(p[1] || '').trim().toUpperCase();
      if ('DWNMQ1'.indexOf(k) < 0) k = 'D';
      return nm ? { g: nm, k: k } : null;
    }).filter(function(x){ return x; });
  }
  function grpPrdPrevOn(){
    var a = axis();
    return (a === 'ITEM_DAY' || a === 'ITEM_MONTH') && !docGrp() && grpPrdOf().length > 0;
  }
  /** 미리보기용 기간 칸 — 좁게 보여 준다(전체 보기 토글이 켜지면 다 그린다).
   *  ★`kk` 를 주면 그 축으로 — 주기 복합의 구간마다 다른 축을 그릴 때 쓴다. */
  function prevCells(wide, kk){
    var k = kk || kindOf(), i, out = [];
    if (k === '1') return [''];                 // 한 칸 — 주기 복합의 「매월」
    if (k === 'W') { ['월','화','수','목','금','토','일'].forEach(function(t,ix){ out.push(t); }); return out; }
    if (k === 'N') { for (i=1;i<=5;i++) out.push(i+'주'); return out; }
    if (k === 'M') { for (i=1;i<=(wide?12:5);i++) out.push(i+'월'); return out; }
    if (k === 'Q') { for (i=1;i<=4;i++) out.push(i+'분기'); return out; }
    for (i=1;i<=(wide?31:5);i++) out.push(String(i));
    return out;
  }
  /** 미리보기에서 「…」 칸을 붙일까 — 다 그리면 안 붙인다. 요일·주차·분기는 원래 짧아 안 붙인다. */
  function prevTrunc(wide, kk){
    var k = kk || kindOf();
    if (k === 'W' || k === 'N' || k === 'Q' || k === '1') return false;
    return !wide;
  }

  var HEAD_MAX = 8;   // ★DB 컬럼 HEAD1~HEAD8 · 작성 화면의 HEAD_MAX 와 반드시 같아야 한다

  /**
   * 상단 자유칸 수를 세어 보여 준다.
   * ***★넘치면 조용히 버려지는 것이 가장 나쁘다*** — 등록한 사람은 8칸까지만 나온다는 걸 모르고,
   * 병원은 「칸이 사라졌다」고 본다. 그래서 적는 자리에서 바로 알려 준다.
   */
  window.cfHeadCount = function(){
    var n = String(val('f_headNms') || '').split(',')
              .map(function(s){ return s.trim(); }).filter(function(s){ return s; }).length;
    var e = gel('cfHeadCnt');
    if (!e) return;
    if (n > HEAD_MAX) {
      e.style.color = '#b23b3b';
      e.innerHTML = '★<b>' + n + '칸</b>을 적었습니다 — 앞 ' + HEAD_MAX + '칸만 나오고 <b>나머지는 버려집니다.</b>';
    } else {
      e.style.color = '';
      e.textContent = '최대 ' + HEAD_MAX + '칸까지' + (n ? (' · 지금 ' + n + '칸') : '');
    }
  };

  /**
   * ★ITEM_COL 의 고정 열 목록을 푼다. `묶음>열,묶음>열,열` 형태.
   *   작성 화면(qpsChk.jsp)의 colDefs() 와 **같은 규칙**이어야 한다 — 갈리면 미리보기가 거짓말을 한다.
   */
  function colDefs(){
    return String(val('f_colNms') || '').split(',')
      .map(function(s){ return s.trim(); }).filter(function(s){ return s; })
      .map(function(s){
        var i = s.indexOf('>');
        return (i >= 0) ? { g:s.slice(0,i).trim(), n:s.slice(i+1).trim() } : { g:'', n:s };
      });
  }

  /**
   * ★LIST 의 행 블록을 푼다. `이름>기본행수,이름>기본행수`.
   *   작성 화면(qpsChk.jsp)의 blkDefs() 와 **같은 규칙**이어야 한다 — 갈리면 미리보기가 거짓말을 한다.
   */
  function blkDefs(){
    return String(val('f_rowBlks') || '').split(',')
      .map(function(s){ return s.trim(); }).filter(function(s){ return s; })
      .map(function(s){
        var i = s.indexOf('>'), nm = (i >= 0) ? s.slice(0, i).trim() : s, n = (i >= 0) ? Number(s.slice(i + 1)) : 0;
        return { nm:nm, n:(n >= 1 && n <= 999) ? Math.floor(n) : 5 };
      });
  }
  /** 행 블록을 적는 자리에서 바로 표가 몇 개·몇 행인지 보여 준다. */
  window.cfBlkHint = function(){
    var e = gel('cfBlkHint'); if (!e) return;
    var bd = blkDefs();
    if (!bd.length) {
      e.style.color = '';
      e.innerHTML = '비워 두면 표가 <b>하나</b>입니다(지금까지와 같음). ' +
                    '한 장에 표가 여럿이면 <b>이름&gt;기본행수</b> 로 적으세요 — 예) ' +
                    '<b>병원 근무자&gt;17,배송기사&gt;3,대체인력&gt;3</b>';
      return;
    }
    e.style.color = '';
    e.innerHTML = '표 <b>' + bd.length + '개</b> : ' +
      bd.map(function(b){ return '<b>' + esc(b.nm) + '</b>(' + b.n + '행)'; }).join(' · ') +
      ' — 적는 사람이 표마다 행을 더 늘릴 수 있습니다.';
  };

  /** 열 이름을 문서가 정하나 — `ITEM_COL` 만이다(서버 QpsController 와 같은 판단). */
  function docCol(){ return axis() === 'ITEM_COL' && val('f_colSrc') === 'D'; }
  /** 행 **묶음** 이름을 문서가 정하나 — 항목이 행인 세 축(서버와 같은 판단). */
  function docGrp(){
    var a = axis();
    return (a === 'ITEM_DAY' || a === 'ITEM_MONTH' || a === 'ITEM_COL') && val('f_rowSrc') === 'D';
  }

  /** 고정 열을 적는 자리에서 바로 몇 칸인지·묶음이 어떻게 잡히는지 보여 준다. */
  window.cfColHint = function(){
    var e = gel('cfColHint'); if (!e) return;
    if (docCol()) {
      e.style.color = '';
      e.innerHTML = '작성 화면의 <b>머리글이 입력칸</b>이 됩니다 — 병원이 물질명·층·병동을 적습니다.<br>' +
                    '몇 칸을 깔지는 위 <b>기본 열 수</b>가 정합니다(지금 <b>' +
                    (Number(val('f_equipCnt')) || 10) + '칸</b>). ' +
                    '<b>추출 CSV 에는 병원이 적은 이름</b>이 나옵니다.';
      return;
    }
    var cd = colDefs();
    if (!cd.length) {
      e.style.color = '#b23b3b';
      e.innerHTML = '★<b>비어 있습니다.</b> 이 축은 열을 축이 안 정합니다 — 적지 않으면 「점검결과」 한 칸만 나옵니다.<br>' +
                    '예) <b>Y,N,비고</b> · <b>예,아니오,해당없음</b> · <b>결과,조치사항</b><br>' +
                    '2단 머리글이 필요하면 <b>묶음&gt;열</b> — 예) 점검 및 조치&gt;점검결과,점검 및 조치&gt;조치 사항';
      return;
    }
    var gs = [], last = null;
    cd.forEach(function(c){ if (last && last.g === c.g && c.g) last.n++; else { last = {g:c.g,n:1}; gs.push(last); } });
    var grp = gs.filter(function(x){ return x.g; })
                .map(function(x){ return x.g + '(' + x.n + '칸)'; }).join(' · ');
    e.style.color = '';
    e.innerHTML = '열 <b>' + cd.length + '칸</b> : ' +
                  cd.map(function(c){ return esc(c.n); }).join(' | ') +
                  (grp ? ('<br>묶음 : ' + esc(grp)) : '');
  };

  /** 축이 바뀌면 뜻이 달라지는 칸을 안내한다 — 안 하면 「열 묶음」이 왜 안 보이는지 모른다. */
  window.cfAxisChange = function(){
    var a = axis();
    // 행 수 칸은 EQUIP_DAY(기기 대수)와 LIST(처음에 깔아 줄 빈 행 수) 둘 다 쓴다 — 이름만 갈린다
    // ★한 칸(EQUIP_CNT)이 축마다 뜻이 갈린다 — 기기 행 수 / 기본 행 수 / **기본 열 수**.
    //   ***라벨을 안 바꾸면 「기기 행 수」로 읽혀 열 수를 아무도 못 찾는다.***
    var useCnt = (a === 'EQUIP_DAY' || a === 'LIST' || docCol() || docGrp());
    gel('f_equipWrap').style.display = useCnt ? '' : 'none';
    gel('f_equipLb').textContent = docGrp() ? '기본 묶음 수'
                                : docCol()  ? '기본 열 수'
                                : (a === 'LIST') ? '기본 행 수' : '기기 행 수';
    var h = gel('cfItemHint');
    h.textContent = (a === 'EQUIP_DAY') ? '— 이 축에서는 항목이 표 위 안내박스로만 나옵니다(셀은 기기별 일별)'
                  : (a === 'DAY_ITEM')  ? '— 항목이 표의 **열**이 됩니다. 「열 묶음」을 적으면 2단 머리글이 생깁니다'
                  : (a === 'ITEM_MONTH')? '— 항목이 행, 1~12월이 열입니다(연 1장)'
                  : (a === 'LIST')      ? '— 항목이 표의 **열**, 행은 작성자가 늘립니다(날짜 칸이 없는 대장). ' +
                                          '이름·사유는 입력종류를 글(TEXT)로 두세요 — 표시(CHECK)로 두면 한 글자가 O/X 로 바뀝니다'
                  : (a === 'ITEM_COL')  ? '— 항목이 **행**, 열은 아래 「고정 열」에 적은 대로입니다(날짜가 없는 점검표). ' +
                                          '「묶음」을 적으면 2단 행 머리글이 생깁니다'
                                        : '— 항목이 표의 **행**이 됩니다';
    // ★묶음의 뜻이 축에 따라 갈린다 — 항목이 열이면 「열 묶음」(2단 열 머리글),
    //   항목이 행이면 「행 묶음」(2단 행 머리글). EQUIP_DAY 만 항목이 셀에 없어 쓸 데가 없다.
    var useGrp = (a !== 'EQUIP_DAY');
    gel('thGrpNm').textContent = itemIsCol(a) ? '열 묶음' : (useGrp ? '행 묶음' : '묶음');
    document.querySelectorAll('#tbITEM [data-f="grpnm"]').forEach(function(el){
      el.disabled = !useGrp;
      el.placeholder = !useGrp ? '(이 축에선 안 씀)'
                     : itemIsCol(a) ? '예) 치료실 환경' : '예) 엘리베이터';
    });
    // ★기간 칸은 격자에 기간이 있는 축만 고른다(LIST·ITEM_COL 은 기간이 없다)
    var gridPrd = (a !== 'LIST' && a !== 'ITEM_COL');
    gel('f_kindWrap').style.display = gridPrd ? '' : 'none';
    // 기간 세분 안내 — 몇 쪽이 되는지 + ⚠쓰던 서식에 켜면 옛 값이 어긋난다는 경고
    if (gridPrd) {
      var subs = String(val('f_prdSub') || '').split(',').map(function(s){ return s.trim(); })
                   .filter(function(s){ return s; });
      var eS = gel('cfSubHint');
      if (!subs.length) eS.textContent = '';
      else if (subs.length === 1) eS.innerHTML = '<span style="color:#b23b3b;">한 쪽이면 안 나눈 것과 같습니다 — 둘 이상 적으세요.</span>';
      else if (subs.length > 9) eS.innerHTML = '<span style="color:#b23b3b;">최대 9쪽입니다.</span>';
      else eS.innerHTML = '기간마다 <b>' + subs.length + '쪽</b>씩. ' +
        '<span style="color:#b26a00;">⚠이미 기록이 있는 서식에서 나누기를 바꾸면 옛 값이 어긋납니다 — 그때는 새 서식으로 만드세요.</span>';
    }
    // ★주기 복합(2026-08-14) — 기간이 **열**이고 항목이 **행**인 두 축만(서버 grpPrd 범위와 같다)
    var grpPrdOk = (a === 'ITEM_DAY' || a === 'ITEM_MONTH');
    gel('f_grpPrdWrap').style.display = grpPrdOk ? '' : 'none';
    if (grpPrdOk) {
      var secs = String(val('f_grpPrd') || '').split(',').map(function(s){ return s.trim(); })
                   .filter(function(s){ return s; });
      var eG = gel('cfGrpPrdHint'), KN = { D:'1~31일', W:'요일 7칸', N:'주차 5칸', M:'1~12월', Q:'분기 4칸', '1':'한 칸' };
      if (!secs.length) eG.textContent = '';
      else {
        var bad = [], txt = secs.map(function(s){
          var t = s.split('>'), nm = String(t[0] || '').trim(), k = String(t[1] || '').trim().toUpperCase();
          if (!nm || !KN[k]) bad.push(s);
          return nm + '=' + (KN[k] || '?');
        }).join(' · ');
        // ★묶음 이름은 **항목표에 그대로 있어야** 그 구간이 그려진다 — 오타가 제일 흔한 사고다
        var have = {};
        Array.prototype.forEach.call(document.querySelectorAll('#tbITEM [data-f="grpnm"]'), function(el){
          if (String(el.value || '').trim()) have[String(el.value).trim()] = 1;
        });
        var miss = secs.map(function(s){ return String(s.split('>')[0] || '').trim(); })
                       .filter(function(nm){ return nm && !have[nm]; });
        eG.innerHTML = (bad.length
              ? '<span style="color:#b23b3b;">축을 못 알아봅니다 : ' + bad.join(', ') + ' (D·W·N·M·Q·1)</span>'
              : '구간 <b>' + secs.length + '</b>벌 — ' + txt)
          + (miss.length ? '<br><span style="color:#b23b3b;">⚠항목표에 없는 묶음 : ' + miss.join(', ') +
                           ' — 이름이 어긋나면 그 구간이 안 그려집니다.</span>' : '');
      }
    }
    // ★인쇄 나누기는 **어느 축에서나** 뜻이 있다 — 열 끊기는 기간 칸이 있는 축, 행 끊기는 전부.
    //   (종전 「반달 접기」는 ITEM_DAY·EQUIP_DAY + 「일」에서만 보였다.)
    gel('f_splitWrap').style.display = '';
    // 「열을 끊어」는 **기간 칸이 있는 축**만 — LIST·ITEM_COL 은 자를 기준이 없다.
    //   고를 수 있게 두면 저장은 되는데 인쇄만 그대로라 「안 먹는다」로 오해한다 ⇒ 아예 막는다
    var cOpt = gel('f_splitDir').querySelector('option[value="C"]');
    var noCol = (a === 'LIST' || a === 'ITEM_COL');
    cOpt.disabled = noCol; cOpt.style.display = noCol ? 'none' : '';
    if (noCol && val('f_splitDir') === 'C') set('f_splitDir', '');
    cfSplitHint();
    // ★주기는 **격자에 기간이 없는 축**만 고른다(LIST·ITEM_COL) — 날짜 격자축은 축이 정한다
    //   (ITEM_MONTH=연 1장, ITEM_DAY/DAY_ITEM/EQUIP_DAY=월 1장).
    gel('f_prdWrap').style.display = (a === 'LIST' || a === 'ITEM_COL') ? '' : 'none';
    // 고정 열은 ITEM_COL 만 — 다른 축은 열을 축이 정한다
    gel('f_colLb').style.display   = (a === 'ITEM_COL') ? '' : 'none';
    gel('f_colWrap').style.display = (a === 'ITEM_COL') ? '' : 'none';
    // 문서가 열 이름을 정하면 서식의 열 목록은 쓸 데가 없다 — 남겨 두면 「어느 쪽이 이기나」로 헷갈린다
    gel('f_colNms').style.display = docCol() ? 'none' : '';
    if (a === 'ITEM_COL') cfColHint();
    // ★행 블록 — LIST 는 서식이 블록을 적고, 항목이 행인 축은 이미 있는 묶음을 어떻게 그릴지만 고른다.
    //   ***둘을 한 자리에 몰면 「내 축에 없는 칸」이 늘 하나 보인다.*** 그래서 자리를 갈랐다.
    var isList = (a === 'LIST'), itemRowAx = (a !== 'LIST' && a !== 'DAY_ITEM' && a !== 'EQUIP_DAY');
    gel('f_blkLb').style.display   = isList ? '' : 'none';
    gel('f_blkWrap').style.display = isList ? '' : 'none';
    if (isList) cfBlkHint();
    gel('f_bandLb').style.display   = itemRowAx ? '' : 'none';
    gel('f_bandWrap').style.display = itemRowAx ? '' : 'none';
    if (itemRowAx) {
      var hasG = readItems().some(function(r){ return (r.grpnm || '').trim(); });
      // 묶음 이름을 문서가 정하면 표시 방법·항목의 「묶음」 칸은 쓸 데가 없다 — 아예 숨긴다
      var dRow = (val('f_rowSrc') === 'D');
      gel('f_rowBlkGb').style.display = dRow ? 'none' : '';
      gel('cfBandHint').innerHTML = dRow
        ? ('아래 <b>항목</b>이 <b>묶음마다 되풀이</b>됩니다 — 작성 화면의 <b>묶음 칸이 입력칸</b>이 되어 ' +
           '병원이 약품명·소화기 번호를 적습니다.<br>몇 묶음을 깔지는 위 <b>기본 묶음 수</b>가 정합니다(지금 <b>' +
           (Number(val('f_equipCnt')) || 10) + '묶음</b>). 항목의 「묶음」 칸은 쓰지 않습니다.')
        : (hasG
          ? (val('f_rowBlkGb') === 'B' ? '묶음 이름이 표를 가로지르는 머리 행으로 나옵니다(시설물 정기점검처럼).'
                                       : '묶음 이름이 왼쪽 세로 칸으로 나옵니다(지금까지와 같음).')
          : '아래 항목의 「행 묶음」을 적어야 뜻이 있습니다 — 비어 있으면 어느 쪽이든 같습니다.');
    }
    // ★블록 띠·고정 띠 문구 — 항목이 행인 세 축만(작성 화면 renderGrid 와 같은 판단).
    //   숨길 때는 머리글과 몸통 칸을 **같이** 숨긴다 — 한쪽만 빼면 표가 밀린다(설명 칸과 같은 규칙).
    gel('thBlkNm').hidden = !itemRowAx;
    document.querySelectorAll('#tbITEM [data-cell="blknm"]').forEach(function(td){ td.hidden = !itemRowAx; });
    gel('thSpanTxt').hidden = !itemRowAx;
    document.querySelectorAll('#tbITEM [data-cell="spantxt"]').forEach(function(td){ td.hidden = !itemRowAx; });
    gel('f_spanAllWrap').style.display = itemRowAx ? '' : 'none';
    // ★기간 열 머리글 입력 행 — 기간이 **열**이고 항목이 **행**인 두 축만(서버 prdHeadOk 와 같은 판단)
    var phAx = (a === 'ITEM_DAY' || a === 'ITEM_MONTH');
    gel('f_prdHeadWrap').style.display = phAx ? '' : 'none';
    // ★전월복사에서 가져올 열 — 대장(LIST)만. 다른 축은 격자가 그 달의 결과뿐이라 가져올 자산이 없다.
    gel('thCarry').hidden = !isList;
    document.querySelectorAll('#tbITEM [data-cell="carryyn"]').forEach(function(td){ td.hidden = !isList; });
    // ★격자 옆 칸 — 항목이 행인 세 축만(서버 QpsController.sideOk 와 같은 판단이어야 한다)
    var sideAx = (a === 'ITEM_DAY' || a === 'ITEM_MONTH' || a === 'ITEM_COL');
    gel('f_sideLb').style.display   = sideAx ? '' : 'none';
    gel('f_sideWrap').style.display = sideAx ? '' : 'none';
    // 「설명」 칸은 그 열을 켰을 때만 항목 표에 나온다 — 늘 띄우면 안 쓰는 칸이 한 줄 늘 보인다
    var descOn = sideAx && !!val('f_descNm');
    gel('thDescTxt').hidden = !descOn;
    document.querySelectorAll('#tbITEM [data-cell="desctxt"]').forEach(function(td){ td.hidden = !descOn; });
    if (sideAx) {
      var pre = nameList(val('f_preCols')), post = nameList(val('f_postCols'));
      gel('cfSideHint').innerHTML = (descOn || pre.length || post.length)
        ? ('격자 <b>앞</b> ' + (descOn ? ('설명 1칸(<b>' + esc(val('f_descNm')) + '</b>) + ') : '') +
           '입력 ' + pre.length + '칸 · <b>뒤</b> 입력 ' + post.length + '칸' +
           (descOn ? ' — <b>설명</b>은 아래 항목 표에서 적습니다(달마다 다시 치지 않습니다).' : ''))
        : '비워 두면 격자만 나옵니다. <b>설명</b>은 항목마다 늘 같은 글, <b>앞/뒤 칸</b>은 문서가 달마다 적는 값입니다.';
    }
    renderPrev();
  };

  function nameList(s){
    return String(s || '').split(',').map(function(x){ return x.trim(); })
                          .filter(function(x){ return x; });
  }

  function itemRow(r){
    r = r || {};
    var tr = document.createElement('tr');
    tr.innerHTML =
      '<td style="text-align:center;color:#8a99a3;" data-no></td>' +
      '<td><input data-f="itemnm" value="' + esc(r.itemnm) + '" placeholder="점검항목 문구"></td>' +
      '<td><input data-f="grpnm" value="' + esc(r.grpnm) + '"></td>' +
      '<td data-cell="blknm" hidden><input data-f="blknm" value="' + esc(r.blknm) + '" placeholder="예) 자연환기"></td>' +
      '<td data-cell="desctxt" hidden><input data-f="desctxt" value="' + esc(r.desctxt) + '" placeholder="예) 물걸레 소독"></td>' +
      '<td data-cell="spantxt" hidden><input data-f="spantxt" value="' + esc(r.spantxt) + '" placeholder="예) 매월 1회 실시"></td>' +
      '<td><select data-f="inputgb">' +
        '<option value="CHECK"' + (r.inputgb === 'TEXT' || r.inputgb === 'NUM' ? '' : ' selected') + '>O / X</option>' +
        '<option value="TEXT"' + (r.inputgb === 'TEXT' ? ' selected' : '') + '>글자</option>' +
        '<option value="NUM"' + (r.inputgb === 'NUM' ? ' selected' : '') + '>숫자</option>' +
      '</select></td>' +
      '<td><input data-f="unitnm" value="' + esc(r.unitnm) + '" placeholder="℃"></td>' +
      '<td data-cell="carryyn" hidden style="text-align:center;">' +
        '<input type="checkbox" data-f="carryyn"' + (r.carryyn === 'Y' ? ' checked' : '') + '></td>' +
      '<td class="movebtn" onclick="cfMove(this,-1);">▲<br>' +
          '<span onclick="event.stopPropagation();cfMove(this.parentNode,1);">▼</span></td>' +
      '<td class="rowdel" onclick="this.closest(\'tr\').remove(); renumber(); renderPrev();">✕</td>';
    gel('tbITEM').appendChild(tr);
  }
  window.cfAddItem = function(){ itemRow({}); renumber(); cfAxisChange(); };
  window.cfMove = function(td, dir){
    var tr = td.closest('tr'), tb = gel('tbITEM');
    if (dir < 0 && tr.previousElementSibling) tb.insertBefore(tr, tr.previousElementSibling);
    if (dir > 0 && tr.nextElementSibling) tb.insertBefore(tr.nextElementSibling, tr);
    renumber(); renderPrev();
  };
  function renumber(){
    document.querySelectorAll('#tbITEM tr').forEach(function(tr, i){
      var c = tr.querySelector('[data-no]'); if (c) c.textContent = i + 1;
    });
  }
  function readItems(){
    var out = [];
    document.querySelectorAll('#tbITEM tr').forEach(function(tr){
      var r = {};
      tr.querySelectorAll('[data-f]').forEach(function(el){
        // ★체크박스는 value 가 늘 'on' 이다 — 그대로 담으면 CARRY_YN 이 전부 켜진다
        r[el.getAttribute('data-f')] = (el.type === 'checkbox') ? (el.checked ? 'Y' : 'N')
                                                                : String(el.value).trim();
      });
      if (!r.itemnm) return;
      out.push(r);
    });
    return out;
  }

  var PREV_WIDE = false;
  window.cfPrevWide = function(){
    PREV_WIDE = !PREV_WIDE;
    gel('cfPrevWideBtn').textContent = PREV_WIDE ? '↤ 앞 5칸만' : '↔ 한 달 전체 보기';
    gel('cfPrevHint').textContent = PREV_WIDE ? '— 실제 작성 화면과 같은 모양(31칸 전체 · 옆으로 밉니다)'
                                              : '— 실제 작성 화면과 같은 모양(앞 5칸만)';
    renderPrev();
  };
  /** 저장한 서식을 작성 화면(실물)에서 본다 — ★새 창(돌아와야 하므로). */
  window.cfOpenWrite = function(){
    var id = val('f_formId');
    if (!id) { _alertBox('서식을 먼저 고르거나 저장하세요.', {icon:'⚠️'}); return; }
    window.open('<c:url value="/main/qpsChk.do"/>?form=' + encodeURIComponent(id.toUpperCase()), '_blank');
  };

  /** 묶음을 가로 띠로 그리나 — 항목이 행인 축에서만 뜻이 있다(LIST 는 블록이 있으면 언제나 띠). */
  function bandOn(){
    var a = axis();
    return (a !== 'LIST' && a !== 'DAY_ITEM' && a !== 'EQUIP_DAY') && val('f_rowBlkGb') === 'B';
  }
  /** 격자 옆 칸 — 미리보기용. 작성 화면의 sideTh/sideTd 와 **같은 차례**여야 한다. */
  function sideAxOn(){ var a = axis(); return a === 'ITEM_DAY' || a === 'ITEM_MONTH' || a === 'ITEM_COL'; }
  function pvDescNm(){ return sideAxOn() ? val('f_descNm') : ''; }
  function pvPre(){  return sideAxOn() ? nameList(val('f_preCols'))  : []; }
  function pvPost(){ return sideAxOn() ? nameList(val('f_postCols')) : []; }
  function pvSideCnt(){ return (pvDescNm() ? 1 : 0) + pvPre().length + pvPost().length; }
  function pvSideTh(back, rs){
    var sp = (rs > 1) ? (' rowspan="' + rs + '"') : '';
    if (back) return pvPost().map(function(n){ return '<th' + sp + ' style="min-width:64px;">' + esc(n) + '</th>'; }).join('');
    return (pvDescNm() ? ('<th' + sp + ' style="min-width:74px;">' + esc(pvDescNm()) + '</th>') : '') +
           pvPre().map(function(n){ return '<th' + sp + ' style="min-width:56px;">' + esc(n) + '</th>'; }).join('');
  }
  function pvSideTd(r, back){
    if (back) return pvPost().map(function(){ return '<td></td>'; }).join('');
    return (pvDescNm() ? ('<td class="l" style="color:#6b7c86;">' + esc(r ? (r.desctxt || '') : '') + '</td>') : '') +
           pvPre().map(function(){ return '<td></td>'; }).join('');
  }

  /** 표 폭을 가로지르는 블록 머리 행. 작성 화면의 `tr.blk` 와 같은 자리다. */
  function bandTr(nm, span){
    return '<tr><td colspan="' + span + '" class="l" ' +
           'style="background:#e3edf2;font-weight:800;color:#28414c;">' + esc(nm) + '</td></tr>';
  }

  /** ★미리보기 — 작성 화면과 **같은 규칙**으로 그린다. 여기서 모양이 이상하면 작성 화면도 이상하다. */
  function renderPrev(){
    var a = axis(), items = readItems(), box = gel('cfPrev');
    var DAYS = [], MONS = [1,2,3,4,5,6,7,8,9,10,11,12];
    var nd = PREV_WIDE ? 31 : 5;
    for (var k = 1; k <= nd; k++) DAYS.push(k);
    if (!PREV_WIDE) MONS = [1,2,3,4,5];
    // 「…」 칸 — 전체 보기에서는 뒤가 잘리지 않으므로 없앤다.
    // ★머리글과 몸통을 함께 없애야 한다. 한쪽만 빼면 칸 수가 어긋나 표가 밀린다.
    // ★기간 칸은 종류에 따라 다르다(2026-08-12) — 일/요일/주차/월/분기. 한 곳에서만 센다.
    var PCELL = prevCells(PREV_WIDE), TRUNC = prevTrunc(PREV_WIDE);
    var ELLTH = TRUNC ? '<th>…</th>' : '', ELLTD = TRUNC ? '<td></td>' : '';
    var h = '';
    if (a === 'EQUIP_DAY') {
      var n = Math.min(3, Math.max(1, Number(val('f_equipCnt') || 10)));
      h += items.length ? ('<div style="font-size:10.5px;color:#43555f;margin-bottom:4px;">점검항목 : ' +
            items.map(function(r, i){ return (i + 1) + '.' + esc(r.itemnm); }).join(' &nbsp; ') + '</div>') : '';
      h += '<table><thead><tr><th style="min-width:120px;">의료기기</th>' +
           PCELL.map(function(d){ return '<th style="width:26px;">' + esc(d) + '</th>'; }).join('') + ELLTH + '</tr></thead><tbody>';
      for (var i = 1; i <= n; i++) h += '<tr><td class="l">의료기기 ' + i + '</td>' + PCELL.map(function(){ return '<td></td>'; }).join('') + ELLTD + '</tr>';
      if (chk('f_signerYn') === 'Y') h += '<tr><td class="l">점검자 확인란</td>' + PCELL.map(function(){ return '<td></td>'; }).join('') + ELLTD + '</tr>';
      h += '</tbody></table>';
      h += splitNote();
    } else if (grpPrdPrevOn()) {
      // ═══ 주기 복합 — 구간마다 표를 한 벌씩 (2026-08-14) ═══
      //   작성 화면 grpPrdHtml 과 같은 규칙 : 서식에 적힌 순서대로, N 구간엔 날짜 줄, 사인은 맨 아래 한 줄.
      var secs = grpPrdOf(), usedG = {}, drew = 0;
      secs.forEach(function(s){ usedG[s.g] = 1; });
      var secTbl = function(gnm, kk, rows){
        var C = prevCells(PREV_WIDE, kk), tr = prevTrunc(PREV_WIDE, kk);
        var eth = tr ? '<th>…</th>' : '', etd = tr ? '<td></td>' : '';
        var t = '<table style="margin-top:' + (drew++ ? 5 : 0) + 'px;"><thead><tr>' +
                (gnm ? '<th style="width:52px;">구분</th>' : '') +
                '<th style="min-width:180px;">점검 항목</th>' + pvSideTh() +
                C.map(function(d){ return '<th style="width:' + (kk === '1' ? 90 : 30) + 'px;">' + esc(d) + '</th>'; }).join('') +
                eth + pvSideTh(true) + '</tr></thead><tbody>';
        // ★N(주차) 구간은 주마다 날짜 적는 줄이 늘 있다 — 작성 화면과 같은 규칙
        if (kk === 'N') {
          t += '<tr>' + (gnm ? '<td></td>' : '') +
               '<td class="l" style="color:#6b7c86;background:#f7fafb;">' + esc(val('f_prdHeadNm')) + '</td>' + pvSideTd(null) +
               C.map(function(){ return '<td style="background:#f7fafb;"></td>'; }).join('') + etd + pvSideTd(null, true) + '</tr>';
        }
        if (!rows.length) {
          t += '<tr><td class="l" style="color:#b23b3b;">이 묶음의 항목이 없습니다 — 항목표의 묶음 이름을 확인하세요</td>' +
               '<td colspan="' + (C.length + (tr ? 1 : 0) + pvSideCnt() + (gnm ? 1 : 0)) + '"></td></tr>';
        }
        rows.forEach(function(r, i){
          t += '<tr>';
          if (gnm && i === 0) t += '<td class="l" rowspan="' + rows.length + '" style="background:#f4f8fa;">' + esc(gnm) + '</td>';
          t += '<td class="l">' + esc(r.itemnm) + (r.unitnm ? (' (' + esc(r.unitnm) + ')') : '') + '</td>' + pvSideTd(r) +
               C.map(function(){ return '<td></td>'; }).join('') + etd + pvSideTd(r, true) + '</tr>';
        });
        return t + '</tbody></table>';
      };
      secs.forEach(function(s){
        h += secTbl(s.g, s.k, items.filter(function(r){ return String(r.grpnm || '').trim() === s.g; }));
      });
      // ★GRP_PRD 에 없는 묶음은 버리지 않는다(작성 화면과 같다) — 서식 축으로 뒤에 붙인다
      var restI = items.filter(function(r){ return !usedG[String(r.grpnm || '').trim()]; });
      if (restI.length) h += secTbl('', kindOf(), restI);
      if (chk('f_signerYn') === 'Y') {
        var SC = prevCells(PREV_WIDE, secs.length ? secs[0].k : kindOf());
        h += '<table style="margin-top:5px;"><tbody><tr><td class="l" style="min-width:150px;">점검자 확인란</td>' +
             SC.map(function(){ return '<td></td>'; }).join('') +
             (prevTrunc(PREV_WIDE, secs.length ? secs[0].k : kindOf()) ? '<td></td>' : '') + '</tr></tbody></table>';
      }
      h += splitNote();

    } else if (a === 'ITEM_DAY' || a === 'ITEM_MONTH') {
      var cols = PCELL;
      // 행 묶음(2단 행 머리글) — 이어지는 항목의 묶음 이름이 같으면 왼쪽 칸을 합친다
      // ★블록(BLK_NM)이 갈리면 묶음도 끊는다 — 작성 화면과 같은 규칙
      var rg = [], rl = null;
      items.forEach(function(r){
        var gname = r.grpnm || '', bname = r.blknm || '';
        if (rl && rl.g === gname && rl.b === bname) rl.n++; else { rl = { g:gname, b:bname, n:1 }; rg.push(rl); }
      });
      // ★블록 두 단계 — BLK_NM 이 있으면 그것이 띠, GRP_NM 은 세로 칸(작성 화면 renderGrid 와 같다)
      var hasBk = !docGrp() && items.some(function(r){ return (r.blknm || '').trim(); });
      var rband = !docGrp() && !hasBk && bandOn() && rg.some(function(x){ return x.g; });
      var hasRg = docGrp() || (!rband && rg.some(function(x){ return x.g; }));
      var rspan = (hasRg ? 1 : 0) + 1 + cols.length + pvSideCnt() + (TRUNC ? 1 : 0);
      h += '<table><thead><tr>' + (hasRg ? '<th style="width:70px;">묶음</th>' : '') +
           '<th style="min-width:180px;">점검 항목</th>' + pvSideTh() +
           cols.map(function(d){ return '<th style="width:30px;">' + esc(d) + '</th>'; }).join('') + ELLTH +
           pvSideTh(true) + '</tr></thead><tbody>';
      // ★기간 열 머리글 입력 행 — 작성 화면의 890 행. 미리보기는 빈 칸으로 자리만 보여 준다.
      if (chk('f_prdHeadYn') === 'Y') {
        h += '<tr>' + (hasRg ? '<td></td>' : '') +
             '<td class="l" style="color:#6b7c86;background:#f7fafb;">' + esc(val('f_prdHeadNm')) + '</td>' + pvSideTd(null) +
             cols.map(function(){ return '<td style="background:#f7fafb;"></td>'; }).join('') + ELLTD + pvSideTd(null, true) + '</tr>';
      }
      if (!items.length) h += '<tr><td class="l" style="color:#8a99a3;">항목을 추가하세요</td>' + pvSideTd(null) + cols.map(function(){ return '<td></td>'; }).join('') + ELLTD + pvSideTd(null, true) + '</tr>';
      if (docGrp() && items.length) {
        // 묶음 이름을 문서가 적는다 — 미리보기는 앞 2묶음만 보여 준다
        var gcnt = Math.max(1, Number(val('f_equipCnt')) || 10);
        for (var gb = 1; gb <= Math.min(2, gcnt); gb++) {
          items.forEach(function(r, k){
            h += '<tr>';
            if (k === 0) h += '<td class="l" rowspan="' + items.length + '" style="background:#f6f8f9;color:#8a99a3;">( ' + gb + '번 )</td>';
            h += '<td class="l">' + esc(r.itemnm) + '</td>' + pvSideTd(r) +
                 cols.map(function(){ return '<td></td>'; }).join('') + ELLTD + pvSideTd(r, true) + '</tr>';
          });
        }
        if (gcnt > 2) h += '<tr><td colspan="' + rspan + '" class="l" style="color:#8a99a3;">… 모두 ' + gcnt + '묶음</td></tr>';
      } else {
      var gi = 0, gpos = 0, pvBk = null;
      items.forEach(function(r){
        var bn = (r.blknm || '').trim();
        if (hasBk && bn && bn !== pvBk) h += bandTr(bn, rspan);
        pvBk = bn;
        if (rband && gpos === 0 && rg[gi].g) h += bandTr(rg[gi].g, rspan);
        h += '<tr>';
        if (hasRg && gpos === 0) h += '<td class="l" rowspan="' + rg[gi].n + '" style="background:#f6f8f9;font-weight:700;">' + esc(rg[gi].g) + '</td>';
        h += '<td class="l">' + esc(r.itemnm) + '</td>' + pvSideTd(r);
        // ★고정 띠 문구 — 격자를 그 글 한 칸으로 덮는다(작성 화면과 같은 규칙)
        var sp = (r.spantxt || '').trim();
        if (sp) {
          h += '<td colspan="' + (cols.length + (TRUNC ? 1 : 0) + (chk('f_spanAllYn') === 'Y' ? pvPost().length : 0)) +
               '" style="background:#f4f6f8;color:#43555f;">' + esc(sp) + '</td>' +
               (chk('f_spanAllYn') === 'Y' ? '' : pvSideTd(r, true)) + '</tr>';
        } else {
          h += cols.map(function(){ return '<td></td>'; }).join('') + ELLTD + pvSideTd(r, true) + '</tr>';
        }
        if (hasRg || rband) { gpos++; if (gpos >= rg[gi].n) { gi++; gpos = 0; } }
      });
      }
      if (chk('f_signerYn') === 'Y') h += '<tr>' + (hasRg ? '<td></td>' : '') + '<td class="l">점검자 사인</td>' + pvSideTd(null) + cols.map(function(){ return '<td></td>'; }).join('') + ELLTD + pvSideTd(null, true) + '</tr>';
      h += '</tbody></table>';
      h += splitNote();
    } else if (a === 'ITEM_COL') {
      // 항목 행 × 고정 열. 행 묶음 + 열 묶음 둘 다 그린다(작성 화면과 같은 규칙).
      var cd2 = colDefs();
      // 문서가 정하는 열 — 이름 대신 **적을 자리**를 보여 준다(작성 화면에서 머리글이 입력칸이 된다)
      if (docCol()) {
        var ncd = Math.max(1, Math.min(50, Number(val('f_equipCnt')) || 10));
        cd2 = [];
        for (var z = 1; z <= Math.min(6, ncd); z++) cd2.push({ g:'', n:'( ' + z + '번 )' });
        if (ncd > 6) cd2.push({ g:'', n:'… ' + ncd + '칸' });
      }
      if (!cd2.length) cd2 = [{ g:'', n:'(열을 적으세요)' }];
      var cg2 = [], cl2 = null;
      cd2.forEach(function(c){ if (cl2 && cl2.g === c.g && c.g) cl2.n++; else { cl2 = {g:c.g,n:1}; cg2.push(cl2); } });
      var hasCg2 = cg2.some(function(x){ return x.g; });
      var ig2 = [], il2 = null;
      items.forEach(function(r){ var gn = r.grpnm || '', bn2 = r.blknm || '';
        if (il2 && il2.g === gn && il2.b === bn2) il2.n++; else { il2 = {g:gn,b:bn2,n:1}; ig2.push(il2); } });
      // ★블록 두 단계 — BLK_NM 이 있으면 그것이 띠, GRP_NM 은 세로 칸(작성 화면과 같은 규칙)
      var hasBk2 = items.some(function(r){ return (r.blknm || '').trim(); });
      var band2 = !hasBk2 && bandOn() && ig2.some(function(x){ return x.g; });
      var hasIg2 = !band2 && ig2.some(function(x){ return x.g; });
      var colTh2 = cd2.map(function(c){ return '<th style="min-width:60px;">' + esc(c.n) + '</th>'; }).join('');

      h += '<table><thead>';
      if (hasCg2) {
        h += '<tr>' + (hasIg2 ? '<th rowspan="2" style="width:70px;">묶음</th>' : '') +
             '<th rowspan="2" style="min-width:160px;">점검 항목</th>' + pvSideTh(false, 2) +
             cg2.map(function(x){ return '<th colspan="' + x.n + '">' + esc(x.g) + '</th>'; }).join('') +
             pvSideTh(true, 2) + '</tr><tr>' + colTh2 + '</tr>';
      } else {
        h += '<tr>' + (hasIg2 ? '<th style="width:70px;">묶음</th>' : '') +
             '<th style="min-width:160px;">점검 항목</th>' + pvSideTh() + colTh2 + pvSideTh(true) + '</tr>';
      }
      h += '</thead><tbody>';
      if (!items.length) h += '<tr><td class="l" style="color:#8a99a3;">항목을 추가하세요</td>' + pvSideTd(null) +
                              cd2.map(function(){ return '<td></td>'; }).join('') + pvSideTd(null, true) + '</tr>';
      var ci2 = 0, cp2 = 0, pvBk2 = null;
      items.forEach(function(r){
        var bn = (r.blknm || '').trim();
        if (hasBk2 && bn && bn !== pvBk2) h += bandTr(bn, (hasIg2 ? 1 : 0) + 1 + cd2.length + pvSideCnt());
        pvBk2 = bn;
        if (band2 && cp2 === 0 && ig2[ci2].g) h += bandTr(ig2[ci2].g, 1 + cd2.length + pvSideCnt());
        h += '<tr>';
        if (hasIg2 && cp2 === 0) h += '<td class="l" rowspan="' + ig2[ci2].n + '" style="background:#f6f8f9;font-weight:700;">' + esc(ig2[ci2].g) + '</td>';
        h += '<td class="l">' + esc(r.itemnm) + '</td>' + pvSideTd(r);
        var sp2 = (r.spantxt || '').trim();
        if (sp2) {
          h += '<td colspan="' + (cd2.length + (chk('f_spanAllYn') === 'Y' ? pvPost().length : 0)) +
               '" style="background:#f4f6f8;color:#43555f;">' + esc(sp2) + '</td>' +
               (chk('f_spanAllYn') === 'Y' ? '' : pvSideTd(r, true)) + '</tr>';
        } else {
          h += cd2.map(function(){ return '<td></td>'; }).join('') + pvSideTd(r, true) + '</tr>';
        }
        if (hasIg2 || band2) { cp2++; if (cp2 >= ig2[ci2].n) { ci2++; cp2 = 0; } }
      });
      if (chk('f_signerYn') === 'Y')
        h += '<tr>' + (hasIg2 ? '<td></td>' : '') + '<td class="l">점검자 사인</td>' + pvSideTd(null) +
             cd2.map(function(){ return '<td></td>'; }).join('') + pvSideTd(null, true) + '</tr>';
      h += '</tbody></table>';

    } else if (a === 'LIST') {
      // 대장 — 날짜 칸이 없다. 번호 + 항목 열들, 행은 작성 화면에서 늘린다.
      var nr = Math.min(4, Math.max(1, Number(val('f_equipCnt') || 10)));
      var gL = [], lL = null;
      items.forEach(function(r){
        var g = r.grpnm || '';
        if (lL && lL.g === g) lL.n++; else { lL = { g:g, n:1 }; gL.push(lL); }
      });
      // ★전월복사로 가져오는 열은 머리글에 표시한다 — 어느 칸이 따라오는지 **보여야** 한다
      var thL = items.map(function(r){
        return '<th style="min-width:80px;">' + esc(r.itemnm) + (r.unitnm ? ('(' + esc(r.unitnm) + ')') : '') +
               (r.carryyn === 'Y' ? '<br><span style="font-weight:400;color:#2c7a7b;">↩전월</span>' : '') + '</th>';
      }).join('');
      h += '<table><thead>';
      if (gL.some(function(g){ return g.g; })) {
        h += '<tr><th rowspan="2" style="width:34px;">번호</th>' +
             gL.map(function(g){ return '<th colspan="' + g.n + '">' + esc(g.g) + '</th>'; }).join('') +
             '</tr><tr>' + thL + '</tr>';
      } else {
        h += '<tr><th style="width:34px;">번호</th>' +
             (items.length ? thL : '<th style="color:#8a99a3;">항목을 추가하세요</th>') + '</tr>';
      }
      h += '</thead><tbody>';
      // ★행 블록 — 한 장에 표가 여럿(열은 같다). 미리보기는 블록마다 앞 몇 줄만 보여 준다.
      var BD = blkDefs(), spanL = 1 + Math.max(items.length, 1);
      (BD.length ? BD : [null]).forEach(function(b){
        if (b) h += bandTr(b.nm, spanL);
        var cnt = b ? Math.min(3, b.n) : nr;
        for (var q = 1; q <= cnt; q++) {
          h += '<tr><td>' + q + '</td>' +
               (items.length ? items : [0]).map(function(){ return '<td></td>'; }).join('') + '</tr>';
        }
        if (b && b.n > cnt) h += '<tr><td colspan="' + spanL + '" style="color:#8a99a3;">… ' + b.n + '행</td></tr>';
      });
      h += '</tbody></table>' +
           '<div style="font-size:10.5px;color:#8a99a3;margin-top:4px;">' +
           (BD.length ? '＋ 행은 작성 화면에서 <b>표마다</b> 늘립니다. 위 숫자는 새 대장을 열 때 깔아 줄 빈 줄 수입니다.'
                      : '＋ 행은 작성 화면에서 더 늘립니다. 여기 「기본 행 수」는 새 대장을 열 때 깔아 줄 빈 줄 수입니다.') +
           '</div>' + splitNote();
    } else { // DAY_ITEM
      var grps = [], last = null;
      items.forEach(function(r){
        var g = r.grpnm || '';
        if (last && last.g === g) last.n++; else { last = { g:g, n:1 }; grps.push(last); }
      });
      var hasGrp = grps.some(function(g){ return g.g; });
      h += '<table><thead>';
      // ★기간이 행이다. 무엇인지는 기간 칸 종류가 정한다 — 'M' 이면 「1~12월 행 × 항목 열」
      var prdNm = { W:'요일', N:'주차', M:'월', Q:'분기' }[kindOf()] || '일';
      if (hasGrp) {
        h += '<tr><th rowspan="2" style="width:42px;">' + prdNm + '</th>' +
             grps.map(function(g){ return '<th colspan="' + g.n + '">' + esc(g.g) + '</th>'; }).join('') + '</tr><tr>';
      } else {
        h += '<tr><th style="width:42px;">' + prdNm + '</th>';
      }
      if (!items.length) h += '<th style="color:#8a99a3;">항목을 추가하세요</th>';
      items.forEach(function(r){ h += '<th style="min-width:70px;">' + esc(r.itemnm) + (r.unitnm ? ('(' + esc(r.unitnm) + ')') : '') + '</th>'; });
      h += '</tr></thead><tbody>';
      PCELL.forEach(function(d){
        h += '<tr><td>' + esc(d) + '</td>' + (items.length ? items : [0]).map(function(){ return '<td></td>'; }).join('') + '</tr>';
      });
      if (TRUNC) h += '<tr><td>…</td>' + (items.length ? items : [0]).map(function(){ return '<td></td>'; }).join('') + '</tr>';
      h += '</tbody></table>';
    }
    if (chk('f_noteYn') === 'Y') h += '<div style="font-size:10.5px;color:#43555f;margin-top:4px;">' +
      esc(val('f_noteNm') || '특이사항') + ' 칸이 표 아래 붙습니다.</div>';
    if (chk('f_fixYn') === 'Y')  h += '<div style="font-size:10.5px;color:#43555f;">수리날짜 및 고장 발생 내용 칸이 붙습니다.</div>';
    if (val('f_signLine'))       h += '<div style="font-size:10.5px;color:#43555f;">하단 서명란 : ' + esc(val('f_signLine')) + '</div>';
    box.innerHTML = h;
  }
  // 입력하면 바로 미리보기에 반영 — 저장 전에 모양을 확인시킨다
  gel('qpsChkForm').addEventListener('input', function(e){
    if (e.target.closest('#tbITEM') || (e.target.id || '').indexOf('f_') === 0) { renumber(); renderPrev(); }
  });
  gel('qpsChkForm').addEventListener('change', function(e){
    if (e.target.closest('#tbITEM') || (e.target.id || '').indexOf('f_') === 0) renderPrev();
  });

  function codeNm(list, cd){
    for (var i = 0; i < list.length; i++) if (String(list[i].subcode) === String(cd)) return list[i].subcodenm || cd;
    return cd || '';
  }

  window.cfList = function(){
    return post('<c:url value="/qps/chkFormList.do"/>', { cateCd: val('cfCate'), deptCd: val('cfDept') }).then(function(res){
      if (res.hosp) { HOSP_NM = res.hosp.hospnm || ''; gel('cfHosp').textContent = '🏥 ' + HOSP_NM; }
      if (!CATE.length) {
        CATE = res.cate || [];
        [gel('cfCate'), gel('f_cateCd')].forEach(function(sel){
          CATE.forEach(function(c){ sel.add(new Option(c.subcodenm || c.subcode, c.subcode)); });
        });
      }
      if (!DEPT.length) {
        DEPT = res.dept || [];
        [gel('cfDept'), gel('f_deptCd')].forEach(function(sel){
          DEPT.forEach(function(c){ sel.add(new Option(c.subcodenm || c.subcode, c.subcode)); });
        });
      }
      LIST = res.list || [];
      gel('cfCnt').textContent = LIST.length ? ('· ' + LIST.length + '종') : '';
      var onCnt = LIST.filter(function(r){ return r.useyn === 'Y'; }).length;
      gel('cfUseHint').innerHTML = '체크 = 이 병원이 쓰는 서식 <b>' + onCnt + '/' + LIST.length + '</b>';
      var box = gel('cfListBox');
      box.innerHTML = LIST.length
        ? LIST.map(function(r){
            return '<div class="cf-item' + (r.formid === curId ? ' on' : '') + '" onclick="cfOpen(\'' + esc(r.formid) + '\');">' +
                   '<div class="t"><input type="checkbox" class="cfuse" data-id="' + esc(r.formid) + '"' +
                     (r.useyn === 'Y' ? ' checked' : '') + ' onclick="event.stopPropagation();"' +
                     ' style="vertical-align:-2px; margin-right:6px;">' + esc(r.formnm) + '</div>' +
                   '<div class="d" style="padding-left:20px;"><span class="tag axis">' + esc(AXIS_NM[r.axisgb] || r.axisgb) + '</span>' +
                   '<span class="tag ' + (r.own === 'Y' ? 'own">병원 서식' : 'std">기본 서식') + '</span>' +
                   (r.deptcd ? ('<span>' + esc(codeNm(DEPT, r.deptcd)) + '</span>') : '') +
                   '<span>항목 ' + Number(r.itemcnt || 0) + '</span>' +
                   '<span>작성 ' + Number(r.doccnt || 0) + '건</span></div></div>';
          }).join('')
        : '<div class="cf-empty">서식이 없습니다.<br>[＋ 새 서식]으로 만드세요.</div>';
    }).catch(err);
  };

  /**
   * 상단 필터를 바꾸면 목록을 다시 받고, ***새 서식을 쓰는 중이면 폼의 부서·분류도 따라간다.***
   * 「약국」으로 걸러 놓고 새 서식을 만드는데 부서를 또 고르게 하면 빠뜨린다(2026-08-11 사용자 지적).
   *
   * ★★단, <b>저장된 서식을 보고 있을 때는 절대 따라가지 않는다</b> —
   *   목록을 걸러 보려고 필터를 만졌을 뿐인데 <b>그 서식의 부서가 바뀌어</b> 저장되면 사고다.
   * ★'전체'로 되돌릴 때도 폼을 비우지 않는다 — 고르던 값을 지우는 게 더 나쁘다.
   */
  window.cfFilterChange = function(){
    var isNew = !curId;
    var d = val('cfDept'), c = val('cfCate');
    cfList().then(function(){
      if (!isNew) return;
      if (d) set('f_deptCd', d);
      if (c) set('f_cateCd', c);
      cfCateNarrow();                    // 부서가 바뀌었으면 분류 후보도 따라간다(2026-08-18)
    });
  };

  /** 자동 서식코드 — 부서 접두어 + 3자리. 사람이 130종의 코드를 지을 수 없다. */
  //   ★[등록 대장](docs/proposals/판독/QPS_서식등록_대장_2026-08-12.md)의 접두어와 **같아야 한다** —
  //     대장은 COM 으로 세어 두고 화면은 CHK 를 붙이면 대조가 안 된다.
  var DEPT_PRE = { NURSE:'NUR', PHARM:'PHA', NUTRI:'NUT', FACIL:'FAC', LAB:'LAB', INFECT:'INF', COMMON:'COM' };
  window.cfAutoId = function(){
    if (gel('f_formId').readOnly) { _alertBox('이미 저장된 서식의 코드는 바꿀 수 없습니다.<br>' +
        '<span style="color:#6b7c86;font-size:12px;">바꾸면 이미 작성한 점검표와 끊깁니다.</span>', {icon:'⚠️'}); return; }
    var pre = DEPT_PRE[val('f_deptCd')] || 'CHK';
    post('<c:url value="/qps/chkCodeNext.do"/>', { prefix: pre }).then(function(res){
      set('f_formId', res.formId);
      _toast('서식코드 ' + res.formId + ' 를 만들었습니다.', 'ok');
    }).catch(err);
  };

  /** 부서·분류 코드 추가 — ★서식을 만들다 없으면 여기서 바로. 추가한 값이 곧바로 골라진다. */
  window.cfCodeAdd = function(codeCd, what){
    _confirmBox({
      msg: '<b>' + esc(what) + '</b> 를 새로 추가합니다.<br><br>' +
           '<div style="text-align:left;font-size:12.5px;">코드값 <span style="color:#8a99a3;">(영문 대문자·숫자·_)</span><br>' +
           '<input id="ccCd" style="width:100%;padding:5px 7px;border:1px solid #cfd8e0;border-radius:5px;" ' +
           'placeholder="예) RADIO"><br><br>이름<br>' +
           '<input id="ccNm" style="width:100%;padding:5px 7px;border:1px solid #cfd8e0;border-radius:5px;" ' +
           'placeholder="예) 방사선"></div>' +
           '<div style="text-align:left;font-size:11.5px;color:#8a99a3;margin-top:8px;">' +
           '※ 이름 바꾸기·지우기는 [기준정보 ▸ 공통코드]에서 하세요 —<br>' +
           '&nbsp;&nbsp;&nbsp;이미 그 코드를 쓰는 서식이 있으면 지우면 안 됩니다.</div>',
      icon:'🏷', okText:'추가',
      onOk: function(){
        var cd = ((document.getElementById('ccCd') || {}).value || '').trim().toUpperCase();
        var nm = ((document.getElementById('ccNm') || {}).value || '').trim();
        post('<c:url value="/qps/chkCodeAdd.do"/>', { codeCd: codeCd, subCode: cd, subCodeNm: nm })
          .then(function(res){
            var list = res.list || [];
            // 셀렉트를 다시 그린다 — 화면 필터·서식 폼 둘 다
            var pair = (codeCd === 'QPS_CHK_DEPT') ? ['cfDept','f_deptCd','전체 부서'] : ['cfCate','f_cateCd','전체 분류'];
            if (codeCd === 'QPS_CHK_DEPT') DEPT = list; else CATE = list;
            var keepF = val(pair[0]), keepS = val(pair[1]);
            [[pair[0], pair[2]], [pair[1], '— 선택 —']].forEach(function(x){
              var sel = gel(x[0]);
              sel.innerHTML = '<option value="">' + x[1] + '</option>';
              list.forEach(function(c){ sel.add(new Option(c.subcodenm || c.subcode, c.subcode)); });
            });
            gel(pair[0]).value = keepF;
            gel(pair[1]).value = cd || keepS;   // ★방금 넣은 값이 골라지게 — 다시 찾게 하지 않는다
            // ★방금 만든 분류는 아직 어느 부서 규칙에도 없다 ⇒ 「(규칙 밖)」으로 남되 **고른 값은 지켜진다**
            cfCateNarrow();
            _toast(what + ' 「' + nm + '」 를 추가했습니다.', 'ok');
          }).catch(err);
      } });
  };

  window.cfUseAll = function(on){
    document.querySelectorAll('#cfListBox .cfuse').forEach(function(el){ el.checked = !!on; });
  };
  /** ★사용 목록은 **화면에 보이는 것만** 담으면 안 된다 — 부서·분류로 걸러 놓고 저장하면
   *    안 보이던 서식이 통째로 꺼진다. 걸러진 것은 지금 값을 그대로 유지한다. */
  window.cfUseSave = function(){
    var shown = {};
    document.querySelectorAll('#cfListBox .cfuse').forEach(function(el){
      shown[el.getAttribute('data-id')] = el.checked;
    });
    var uses = [];
    LIST.forEach(function(r){
      var on = (r.formid in shown) ? shown[r.formid] : (r.useyn === 'Y');
      if (on) uses.push({ formid: r.formid });
    });
    // 화면에 안 뜬 서식(부서 필터로 걸러진 것)도 켜져 있으면 지켜야 한다 → 전체를 다시 받아 합친다
    post('<c:url value="/qps/chkFormList.do"/>', { cateCd:'', deptCd:'' }).then(function(res){
      var all = res.list || [], keep = {};
      uses.forEach(function(u){ keep[u.formid] = true; });
      all.forEach(function(r){
        if (r.formid in shown) return;              // 지금 화면에서 정한 것은 위에서 이미 반영
        if (r.useyn === 'Y') keep[r.formid] = true; // 안 보이던 것은 그대로 둔다
      });
      var body = Object.keys(keep).map(function(k){ return { formid: k }; });
      return post('<c:url value="/qps/chkUseSave.do"/>', { uses: JSON.stringify(body) });
    }).then(function(){
      _toast('사용 서식을 저장했습니다.', 'ok');
      cfList();
    }).catch(err);
  };

  /** 서식 복제 — 비슷한 점검표가 대부분이라 새로 짜는 것보다 훨씬 빠르다. */
  window.cfCopy = function(){
    if (!curId) { _alertBox('복제할 서식을 먼저 고르세요.', {icon:'⚠️'}); return; }
    var src = curId, srcNm = val('f_formNm');
    _confirmBox({
      msg: '<b>' + esc(srcNm) + '</b> 을(를) 복제합니다.<br><br>' +
           '<div style="text-align:left;font-size:12.5px;">새 서식코드<br>' +
           '<input id="cpId" style="width:100%;padding:5px 7px;border:1px solid #cfd8e0;border-radius:5px;" ' +
           'placeholder="영문 대문자·숫자·_" value="' + esc(src) + '_2"><br><br>새 서식명<br>' +
           '<input id="cpNm" style="width:100%;padding:5px 7px;border:1px solid #cfd8e0;border-radius:5px;" ' +
           'value="' + esc(srcNm) + ' (복사)"></div>',
      icon:'📋', okText:'복제',
      onOk: function(){
        var id = (document.getElementById('cpId') || {}).value || '';
        var nm = (document.getElementById('cpNm') || {}).value || '';
        post('<c:url value="/qps/chkFormCopy.do"/>', { srcFormId: src, newFormId: id, newFormNm: nm })
          .then(function(res){ _toast('복제했습니다.', 'ok'); cfOpen(res.formId); }).catch(err);
      } });
  };

  window.cfPasteOpen = function(){
    gel('cfPasteBox').style.display = '';
    gel('cfPasteTxt').focus();
  };
  window.cfPasteApply = function(){
    var txt = String(gel('cfPasteTxt').value || '');
    var lines = txt.split(/\r?\n/).map(function(s){ return s.trim(); }).filter(function(s){ return s; });
    if (!lines.length) { _alertBox('붙여넣을 내용이 없습니다.', {icon:'⚠️'}); return; }
    if (!gel('cfPasteAppend').checked) gel('tbITEM').innerHTML = '';
    lines.forEach(function(ln){
      // 탭 또는 | 로 나눈다 — 엑셀에서 여러 칸을 복사하면 탭이 들어온다
      var p = ln.split(/\t|\|/).map(function(s){ return s.trim(); });
      var ig = (p[2] || '').toUpperCase();
      itemRow({ itemnm: p[0], grpnm: p[1] || '',
                inputgb: (ig === 'TEXT' || ig === 'NUM') ? ig : 'CHECK',
                unitnm: p[3] || '', carryyn: (p[4] || '').toUpperCase() === 'Y' ? 'Y' : 'N' });
    });
    renumber(); cfAxisChange(); cfHeadCount();
    gel('cfPasteBox').style.display = 'none';
    gel('cfPasteTxt').value = '';
    _toast(lines.length + '개 항목을 넣었습니다. 저장을 눌러야 반영됩니다.', 'ok');
  };

  /** 시드 SQL 내보내기 — 개발 PC 에서 만든 서식을 docs/sql 로 옮긴다(운영은 아웃바운드가 막혀 있다). */
  function q(s){ return (s == null || s === '') ? 'NULL' : ("'" + String(s).replace(/'/g, "''") + "'"); }
  window.cfExport = function(){
    if (!val('f_formId')) { _alertBox('서식을 먼저 고르거나 만드세요.', {icon:'⚠️'}); return; }
    var id = val('f_formId').toUpperCase(), items = readItems();
    var sql =
      '-- ' + val('f_formNm') + ' (' + id + ') — ' + AXIS_NM[axis()] + '\n' +
      "DELETE FROM TBL_QPS_CHK_ITEM WHERE FORM_ID=" + q(id) + " AND HOSP_CD='*';\n" +
      "DELETE FROM TBL_QPS_CHK_FORM WHERE FORM_ID=" + q(id) + " AND HOSP_CD='*';\n" +
      'INSERT INTO TBL_QPS_CHK_FORM\n' +
      ' (FORM_ID,HOSP_CD,FORM_NM,CATE_CD,DEPT_CD,AXIS_GB,PRD_GB,PRD_KIND,PRD_SUB,GRP_PRD,EQUIP_CNT,HALF_YN,SPLIT_N,SPLIT_DIR,GUIDE_TXT,HEAD_NMS,COL_NMS,COL_SRC,ROW_BLK_GB,ROW_BLKS,ROW_SRC,DESC_NM,PRE_COLS,POST_COLS,\n' +
      '  SPAN_ALL_YN,PRD_HEAD_YN,PRD_HEAD_NM,NOTE_NM,\n' +
      '  SIGNER_YN,NOTE_YN,FIX_YN,SIGN_LINE,FOOT_TXT,SORT_NO,USE_YN,REG_USER) VALUES\n' +
      ' (' + q(id) + ",'*'," + q(val('f_formNm')) + ',' + q(val('f_cateCd')) + ',' + q(val('f_deptCd')) + ',' +
        q(axis()) + ',' +
        q(axis() === 'ITEM_MONTH' ? 'Y'
          : ((axis() === 'LIST' || axis() === 'ITEM_COL') ? val('f_prdGb') : 'M')) + ',' +
        (kindOf() ? q(kindOf()) : 'NULL') + ',' +
        q(val('f_prdSub')) + ',' +
        // 주기 복합 — 기간이 열이고 항목이 행인 두 축만(서버 grpPrd 범위와 같게 맞춘다)
        q((axis() === 'ITEM_DAY' || axis() === 'ITEM_MONTH') ? val('f_grpPrd') : '') + ',' +
        (Number(val('f_equipCnt')) || 10) + ',' +
        "'N'," +                                                   // HALF_YN 은 더 이상 쓰지 않는다
        (splitOf() ? splitOf().n : 'NULL') + ',' +
        (splitOf() ? q(splitOf().dir) : 'NULL') + ',' +
        q(val('f_guideTxt')) + ',' + q(val('f_headNms')) + ',' +
        q(axis() === 'ITEM_COL' ? val('f_colNms') : '') + ',' +
        q(docCol() ? 'D' : 'F') + ',' +
        (bandOn() ? "'B'" : 'NULL') + ',' +
        q(axis() === 'LIST' ? val('f_rowBlks') : '') + ',' +
        q(docGrp() ? 'D' : 'F') + ',' +
        q(sideAxOn() ? val('f_descNm') : '') + ',' +
        q(sideAxOn() ? val('f_preCols') : '') + ',' +
        q(sideAxOn() ? val('f_postCols') : '') + ',\n  ' +
        q(sideAxOn() ? chk('f_spanAllYn') : 'N') + ',' +
        q((axis() === 'ITEM_DAY' || axis() === 'ITEM_MONTH') ? chk('f_prdHeadYn') : 'N') + ',' +
        q((axis() === 'ITEM_DAY' || axis() === 'ITEM_MONTH') ? val('f_prdHeadNm') : '') + ',' +
        q(val('f_noteNm')) + ',\n  ' +
        q(chk('f_signerYn')) + ',' + q(chk('f_noteYn')) + ',' + q(chk('f_fixYn')) + ',' +
        q(val('f_signLine')) + ',' + q(val('f_footTxt')) + ',' + (Number(val('f_sortNo')) || 0) + ",'Y','system');\n" +
      'INSERT INTO TBL_QPS_CHK_ITEM (FORM_ID,HOSP_CD,SORT,ITEM_NM,GRP_NM,BLK_NM,DESC_TXT,SPAN_TXT,INPUT_GB,UNIT_NM,CARRY_YN,USE_YN) VALUES\n' +
      items.map(function(r, i){
        return ' (' + q(id) + ",'*'," + (i + 1) + ',' + q(r.itemnm) + ',' + q(r.grpnm) + ',' + q(r.blknm) + ',' +
               q(r.desctxt) + ',' + q(r.spantxt) + ',' + q(r.inputgb || 'CHECK') + ',' + q(r.unitnm) + ',' +
               q(axis() === 'LIST' && r.carryyn === 'Y' ? 'Y' : 'N') + ",'Y')";
      }).join(',\n') + ';\n';
    gel('cfSqlTxt').value = sql;
    gel('cfSqlBox').style.display = '';
  };
  window.cfSqlCopy = function(){
    var t = gel('cfSqlTxt');
    t.select(); t.setSelectionRange(0, 999999);
    try { document.execCommand('copy'); _toast('복사했습니다.', 'ok'); }
    catch (e) { _alertBox('복사에 실패했습니다. 직접 선택해 복사해 주세요.', {icon:'⚠️'}); }
  };

  window.cfOpen = function(id){
    post('<c:url value="/qps/chkFormGet.do"/>', { formId: id }).then(function(res){
      var d = res.form || {};
      curId = d.formid || ''; curOwn = d.own || 'N';
      set('f_formId', d.formid); set('f_formNm', d.formnm);
      set('f_cateCd', d.catecd || ''); set('f_deptCd', d.deptcd || '');
      cfCateNarrow();   // ★옛 서식의 분류가 규칙 밖이어도 값은 그대로 남는다(「(규칙 밖)」으로 보인다)
      set('f_axisGb', d.axisgb || 'ITEM_DAY'); set('f_equipCnt', d.equipcnt || 10);
      // ★옛 `HALF_YN='Y'` 는 「15칸 · 열」과 같다 — 읽는 쪽에서만 물러난다
      var sd = (d.splitdir === 'C' || d.splitdir === 'R') ? d.splitdir : (d.halfyn === 'Y' ? 'C' : '');
      var sn = Number(d.splitn || 0) >= 2 ? d.splitn : (d.halfyn === 'Y' ? 15 : 15);
      set('f_splitDir', sd); set('f_splitN', sn);
      set('f_prdGb', ('YHQMWD'.indexOf(d.prdgb) >= 0 && String(d.prdgb).length === 1) ? d.prdgb : 'M');
      // ★비어 있으면 축에서 유추 — 옛 서식(2026-08-11 12종)이 값 없이도 그대로 그려진다
      set('f_prdSub', d.prdsub);
      set('f_grpPrd', d.grpprd);   // 주기 복합 — 비면 종전대로 격자 한 벌(2026-08-14)
      set('f_prdKind', (d.prdkind && 'DWNMQ'.indexOf(d.prdkind) >= 0) ? d.prdkind
                       : ((d.axisgb === 'ITEM_MONTH') ? 'M' : 'D'));
      set('f_colNms', d.colnms);
      set('f_colSrc', (d.colsrc === 'D') ? 'D' : 'F');
      set('f_rowSrc', (d.rowsrc === 'D') ? 'D' : 'F');
      set('f_rowBlks', d.rowblks);
      set('f_rowBlkGb', (d.rowblkgb === 'B') ? 'B' : 'S');
      set('f_descNm', d.descnm); set('f_preCols', d.precols); set('f_postCols', d.postcols);
      set('f_subNm', d.subnm); set('f_subCols', d.subcols);
      setChk('f_spanAllYn', d.spanallyn); setChk('f_prdHeadYn', d.prdheadyn);
      set('f_prdHeadNm', d.prdheadnm); set('f_noteNm', d.notenm);
      set('f_guideTxt', d.guidetxt); set('f_headNms', d.headnms);
      setChk('f_signerYn', d.signeryn); setChk('f_noteYn', d.noteyn); setChk('f_fixYn', d.fixyn);
      set('f_signLine', d.signline); set('f_footTxt', d.foottxt); set('f_sortNo', d.sortno || 0);
      gel('f_formId').readOnly = true;   // 코드는 못 바꾼다 — 바꾸면 작성분과 끊긴다

      gel('tbITEM').innerHTML = '';
      (res.items || []).forEach(itemRow);
      if (!(res.items || []).length) itemRow({});
      renumber(); cfAxisChange(); cfHeadCount();

      var msg = gel('cfOwnMsg');
      if (curOwn === 'Y') {
        msg.style.display = '';
        msg.innerHTML = '이 서식은 <b>우리 병원 전용</b>입니다. [기본으로 되돌리기]를 누르면 공통 기본서식으로 돌아갑니다.';
        gel('cfDelBtn').style.display = '';
      } else {
        msg.style.display = '';
        msg.innerHTML = '이 서식은 <b>공통 기본서식</b>입니다. ' +
                        '여기서 고쳐 저장하면 <b>우리 병원 전용 사본</b>이 만들어집니다 — 다른 병원에는 영향이 없습니다.';
        gel('cfDelBtn').style.display = 'none';
      }
      gel('cfStat').textContent = '— ' + (d.formnm || '');
      cfList();
    }).catch(err);
  };

  window.cfNew = function(){
    curId = ''; curOwn = 'N';
    ['f_formId','f_formNm','f_guideTxt','f_headNms','f_colNms','f_rowBlks',
     'f_descNm','f_preCols','f_postCols','f_subNm','f_subCols','f_prdHeadNm','f_noteNm','f_signLine','f_footTxt']
      .forEach(function(id){ set(id, ''); });
    set('f_rowBlkGb', 'S'); set('f_colSrc', 'F'); set('f_rowSrc', 'F');
    setChk('f_spanAllYn', 'N'); setChk('f_prdHeadYn', 'N');
    // 상단 필터를 걸어 뒀으면 그 부서·분류로 시작한다(반대 순서는 cfFilterChange 가 맡는다)
    set('f_deptCd', val('cfDept')); set('f_cateCd', val('cfCate'));
    cfCateNarrow();                      // 새 서식은 규칙 안에서만 고른다(2026-08-18)
    set('f_axisGb', 'ITEM_DAY'); set('f_equipCnt', 10); set('f_sortNo', 0); set('f_prdKind', 'D'); set('f_prdSub', '');
    set('f_grpPrd', '');
    setChk('f_signerYn', 'Y'); setChk('f_noteYn', 'Y'); setChk('f_fixYn', 'N');
    set('f_splitDir', ''); set('f_splitN', 15);
    set('f_prdGb', 'M');
    gel('f_formId').readOnly = false;
    gel('tbITEM').innerHTML = ''; [{},{},{}].forEach(itemRow);
    renumber(); cfAxisChange(); cfHeadCount();
    gel('cfOwnMsg').style.display = '';
    gel('cfOwnMsg').innerHTML = '새 서식은 <b>우리 병원 전용</b>으로 만들어집니다. ' +
      '원본 종이 서식의 <b>점검항목을 그대로 적으면</b> 바로 쓸 수 있는 점검표가 됩니다.';
    gel('cfDelBtn').style.display = 'none';
    gel('cfStat').textContent = '— 새 서식';
    cfList();
  };

  window.cfSave = function(){
    if (!val('f_formId')) { _alertBox('서식코드를 입력해 주세요.', {icon:'⚠️'}); return; }
    if (!val('f_formNm')) { _alertBox('서식명을 입력해 주세요.', {icon:'⚠️'}); return; }
    if (!val('f_deptCd')) { _alertBox('부서를 고르세요 — 부서가 없으면 작성 화면에서 서식이 뒤섞입니다.', {icon:'⚠️'}); return; }
    var items = readItems();
    if (!items.length) { _alertBox('점검항목을 하나 이상 등록해 주세요.', {icon:'⚠️'}); return; }
    var go = function(){
      post('<c:url value="/qps/chkFormSave.do"/>', {
        formId: val('f_formId'), formNm: val('f_formNm'),
        cateCd: val('f_cateCd'), deptCd: val('f_deptCd'),
        axisGb: axis(), equipCnt: val('f_equipCnt'),
        splitDir: (splitOf() ? splitOf().dir : ''), splitN: (splitOf() ? splitOf().n : ''),
        prdGb: val('f_prdGb'),     // 서버가 LIST·ITEM_COL 일 때만 쓴다(다른 축은 축이 정한다)
        prdKind: kindOf(),         // 격자 기간 칸 — 서버가 격자 있는 축에서만 쓴다
        prdSub: val('f_prdSub'),   // 기간 세분 — 서버가 격자 있는 축에서만 쓴다
        grpPrd: val('f_grpPrd'),   // 주기 복합 — 서버가 ITEM_DAY·ITEM_MONTH 에서만 쓴다
        colNms: val('f_colNms'),   // 서버가 ITEM_COL 일 때만 쓴다
        colSrc: val('f_colSrc'),   // 열 이름을 서식이 정하나(F) 문서가 정하나(D)
        rowSrc: val('f_rowSrc'),   // 행 묶음 이름을 서식이 정하나(F) 문서가 정하나(D)
        rowBlks: val('f_rowBlks'), // 서버가 LIST 일 때만 쓴다
        rowBlkGb: val('f_rowBlkGb'),
        // 격자 옆 칸 — 서버가 항목이 행인 세 축에서만 쓴다
        descNm: val('f_descNm'), preCols: val('f_preCols'), postCols: val('f_postCols'),
        subNm: val('f_subNm'), subCols: val('f_subCols'),   // 격자 아래 자유행 표(2026-08-13)
        spanAllYn: chk('f_spanAllYn'),   // 고정 띠가 뒤 칸까지 덮나
        prdHeadYn: chk('f_prdHeadYn'), prdHeadNm: val('f_prdHeadNm'),  // 기간 열 머리글 입력 행
        noteNm: val('f_noteNm'),         // 특이사항 칸의 이름(비면 특이사항)
        guideTxt: val('f_guideTxt'), headNms: val('f_headNms'),
        signerYn: chk('f_signerYn'), noteYn: chk('f_noteYn'), fixYn: chk('f_fixYn'),
        signLine: val('f_signLine'), footTxt: val('f_footTxt'), sortNo: val('f_sortNo'),
        // ★새 서식이면 서버가 중복을 막는다 — 안 막으면 남의 서식을 덮어쓴다
        newYn: curId ? 'N' : 'Y',
        items: JSON.stringify(items)
      }).then(function(res){
        _toast('저장되었습니다.', 'ok');
        cfOpen(res.formId);
      }).catch(err);
    };
    // ★기본서식을 고치는 것이면 무엇이 일어나는지 알려주고 간다 — 조용히 사본을 만들면 안 된다
    if (curId && curOwn !== 'Y') {
      _confirmBox({ msg:'공통 기본서식을 고칩니다.<br><b>우리 병원 전용 사본</b>이 만들어집니다.<br>' +
                        '<span style="color:#6b7c86;font-size:12px;">다른 병원에는 영향이 없습니다.</span>',
                    icon:'📋', okText:'저장', onOk: go });
    } else { go(); }
  };

  window.cfDel = function(){
    if (!curId || curOwn !== 'Y') return;
    _confirmBox({ msg:'우리 병원 서식을 지우고 <b>공통 기본서식</b>으로 되돌립니다.<br>' +
                      '<span style="color:#6b7c86;font-size:12px;">이미 작성한 점검표는 지워지지 않습니다.</span>',
      icon:'⚠️', okText:'되돌리기', okColor:'#b23b3b',
      onOk: function(){
        post('<c:url value="/qps/chkFormDelete.do"/>', { formId: curId }).then(function(){
          _toast('기본서식으로 되돌렸습니다.', 'ok');
          cfOpen(curId);
        }).catch(err);
      } });
  };

  /* ═══ 부서별 쓰는 분류 (2026-08-18 · 사용자 결정) ═══════════════════════════
     ★서식을 만들 때 **그 부서가 쓰는 분류만** 고르게 한다 — 부서 14 × 분류 6 = 84칸 중
       실제로 쓰이는 칸은 42뿐이다. 나머지는 ***고르면 0종이 되는 헛 조합***이다.
     ★***정해 둔 것이 없는 부서는 전 분류다*** — 규칙을 안 만들면 지금과 똑같이 돈다
       (막는 장치가 아니라 좁혀 주는 장치. 규칙은 [부서별 쓰는 분류] 화면에서 정한다).
     ★★***이미 그 분류로 등록된 서식의 값은 지우지 않는다*** — 「(규칙 밖)」으로 남겨 둔다.
       안 그러면 뒤에 규칙을 바꾼 날, 옛 서식을 열었다 저장하는 순간 ***분류가 조용히 바뀐다.***
     ⚠규칙은 **여기(등록)에서만** 쓴다 — 보는 화면(사용 서식·작성)은 안 본다. */
  var RULECAT = null;                  // null = 아직 못 받았다(=좁히지 않는다)
  window.cfRuleLoad = function(){
    return post('<c:url value="/qps/deptCateList.do"/>', {}).then(function(res){
      RULECAT = {};
      (res.rules || []).forEach(function(r){ (RULECAT[r.deptcd] = RULECAT[r.deptcd] || {})[r.catecd] = true; });
      cfCateNarrow();
    }).catch(function(){ RULECAT = null; });   // 못 받으면 전 분류 그대로 — 등록을 막지 않는다
  };
  window.cfCateNarrow = function(){
    var sel = gel('f_cateCd');
    if (!sel || !CATE.length || !RULECAT) return;
    var rule = RULECAT[val('f_deptCd')], cur = val('f_cateCd'), keep = false;
    sel.innerHTML = '<option value="">— 선택 —</option>';
    var only = '';
    CATE.forEach(function(c){
      var ok = !rule || !!rule[c.subcode];       // 규칙이 없는 부서 = 전 분류
      if (!ok && c.subcode !== cur) return;      // 규칙 밖은 안 내놓는다(지금 값만 예외)
      sel.add(new Option((c.subcodenm || c.subcode) + (ok ? '' : ' (규칙 밖)'), c.subcode));
      if (c.subcode === cur) keep = true;
      if (ok) only = only ? '*' : c.subcode;     // 규칙 안이 딱 하나면 그 코드가 남는다
    });
    sel.value = keep ? cur : '';
    /* ★기본 분류 (2026-08-18) — ***새 서식이고, 그 부서가 쓰는 분류가 하나뿐이면*** 그것으로 채운다.
       예) 영양은 「환경·시설」 하나다 — 매번 같은 값을 고르게 하지 않는다.
       ⚠***이미 저장된 서식은 건드리지 않는다***(curId 가 있으면 그냥 둔다) — 사람이 안 고른 값이
         조용히 들어갔다가 저장되면, 분류가 바뀐 줄도 모른다. */
    if (!keep && !curId && only && only !== '*') sel.value = only;
  };

  $(function(){
    var dsel = gel('f_deptCd');
    if (dsel) dsel.addEventListener('change', cfCateNarrow);
    cfList().then(function(){
      cfRuleLoad();                                                    // 규칙은 목록 뒤에(CATE 가 있어야 좁힌다)
      if (LIST.length) cfOpen(LIST[0].formid); else cfNew();
    });
  });
})();

  /* ═══ 탭 · 글자 크기 (2026-08-15 · 사용자 요청) ═══════════════════════════
     ★***고정으로 달지 않는다*** — 전부 펼친 높이를 재서 **한 화면을 넘칠 때만** 탭을 낸다.
       창 크기·글자 크기가 바뀌면 다시 잰다.
     ★탭이 **잘게 나뉘지 않게** 이웃 카드를 묶어 최대 4개. 이름은 첫 카드 제목(+「외」).
     ★「전체 보기」는 탭이 아니라 **보기 방식**이라 오른쪽 끝에 따로 둔다.
     ⚠인쇄는 별도 창이라 탭과 무관하다(숨긴 항목도 종이에는 다 나온다). */
  (function(){
    /* ★[2026-08-18 요청] 「좌측 클릭하면 우측이 보여야 한다 · 체크 세 가지만 나누기」
         이 화면은 **왼쪽 목록에서 고르면 오른쪽이 바뀌는 구조**다. 그런데 탭이 카드를 넷으로
         갈라 놓아 ***목록 탭에 있으면 오른쪽이 아예 안 보였다*** — 「눌러도 아무 일이 없다」의 정체다.
       ⇒ ①**서식 목록은 탭에서 뺀다.** 고르는 자리라 늘 보여야 한다(아래 head).
         ②나누는 것은 **서식 정의 · 점검항목 · 미리보기 셋뿐**이다.
         ③기본값은 **전체 보기(-1)**. 나눠 보기를 고르면 그 선택이 저장돼 그대로 남는다.
       ⚠키 이름을 `…Form2` 로 **한 번 갈았다** — 브라우저에 남아 있던 옛 선택(목록 탭=0)이
         새 기본값을 덮어써서 고쳐도 그대로 보이기 때문이다. 갈아 준 만큼 한 번은 초기화된다. */
    var KEY = 'qpsTab_qpsChkForm2', ZKEY = 'qpsZoom_qpsChkForm', cur = -1;
    function cards(){ return [].slice.call(document.querySelectorAll('#qpsChkForm .cf-card')); }
    function nm(c, i){
      var h = c.querySelector('h4');
      if (!h) return '항목 ' + (i + 1);
      var t = h.cloneNode(true), hint = t.querySelector('.hint');
      if (hint) hint.remove();
      return (t.textContent || '').trim().slice(0, 20) || ('항목 ' + (i + 1));
    }
    function fits(cs){
      if (cs.length < 2) return true;
      var prev = cs.map(function(c){ return c.style.display; });
      cs.forEach(function(c){ c.style.display = ''; });
      var h = 0;
      cs.forEach(function(c){ h += c.offsetHeight + 12; });
      cs.forEach(function(c, i){ c.style.display = prev[i]; });
      return h <= (window.innerHeight - 170);
    }
    function sync(){
      var all0 = cards(), box = document.getElementById('zzTabs');
      if (!box || !all0.length) return;
      /* ★첫 카드(서식 목록)는 **탭에서 뺀다** — 여기서 고르면 나머지가 바뀌는 구조라
           숨기면 고를 자리가 없어진다. 나누는 것은 뒤의 셋(정의·항목·미리보기)뿐이다. */
      var head = all0[0], cs = all0.slice(1);
      head.style.display = '';
      if (!cs.length) { box.style.display = 'none'; return; }
      if (fits(all0)) {                     // 한 화면에 들어간다 — 탭이 필요 없다
        box.style.display = 'none';
        cs.forEach(function(c){ c.style.display = ''; });
        return;
      }
      box.style.display = '';
      var MAX = 4, per = Math.ceil(cs.length / MAX), groups = [];
      for (var s0 = 0; s0 < cs.length; s0 += per) groups.push(cs.slice(s0, s0 + per));
      if (cur >= groups.length) cur = 0;
      var all = (cur === -1);
      box.innerHTML = groups.map(function(g, i){
        return '<button type="button" class="zz-tab' + (!all && cur === i ? ' on' : '') +
               (all ? ' dim' : '') + '" onclick="zzTab(' + i + ');">' +
               nm(g[0], 0) + (g.length > 1 ? ' 외' : '') + '</button>';
      }).join('') +
        '<button type="button" class="zz-mode' + (all ? ' on' : '') + '" onclick="zzTab(' +
        (all ? '0' : '-1') + ');">' + (all ? '▤ 나눠 보기' : '☰ 전체 보기') + '</button>';
      groups.forEach(function(g, i){
        g.forEach(function(c){ c.style.display = (all || cur === i) ? '' : 'none'; });
      });
    }
    window.zzTab = function(i){ cur = i; try { localStorage.setItem(KEY, String(i)); } catch (e) {} sync(); };
    function zoom(z){
      z = Math.min(1.6, Math.max(0.8, z));
      var w = document.getElementById('qpsChkForm');
      if (w) w.style.zoom = z.toFixed(2);
      return z;
    }
    window.zzZoom = function(d){
      var w = document.getElementById('qpsChkForm'), c0 = parseFloat(w && w.style.zoom) || 1;
      if (d === 0) { zoom(1); try { localStorage.removeItem(ZKEY); } catch (e) {} setTimeout(sync, 0); return; }
      var z = zoom(c0 + d * 0.1);
      try { localStorage.setItem(ZKEY, String(z)); } catch (e) {}
      setTimeout(sync, 0);
    };
    try {
      var t = parseInt(localStorage.getItem(KEY), 10); if (!isNaN(t)) cur = t;
      var z = parseFloat(localStorage.getItem(ZKEY)); if (z) zoom(z);
    } catch (e) {}
    function boot(){ setTimeout(sync, 0); }
    if (window.jQuery) jQuery(boot); else document.addEventListener('DOMContentLoaded', boot);
    /* ★내용이 **나중에** 채워지면 다시 잰다 (2026-08-15).
       카드 속은 AJAX 로 채우는데 높이는 부팅 직후에 쟀다 — 긴 문서인데도
       「한 화면에 들어간다」로 잘못 보고 탭이 안 나오던 구멍이다.
       ⚠**탭 띠 자신이 바뀐 것은 무시한다** — 안 그러면 재기→그리기→재기 로 서로 부른다. */
    if (window.MutationObserver) {
      var _mw = document.getElementById('qpsChkForm'), _mt;
      if (_mw) new MutationObserver(function(ms){
        var box = document.getElementById('zzTabs');
        for (var i = 0; i < ms.length; i++) {
          if (!box || !box.contains(ms[i].target)) {
            clearTimeout(_mt); _mt = setTimeout(sync, 250); return;
          }
        }
      }).observe(_mw, { childList: true, subtree: true });
    }
    var _t; window.addEventListener('resize', function(){ clearTimeout(_t); _t = setTimeout(sync, 200); });
    window.zzResync = sync;
  })();
</script>
</div><%-- /#qpsChkForm --%>
</div><%-- /.dashboard-wrapper --%>
