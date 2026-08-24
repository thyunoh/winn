<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%-- join_apply.jsp — 신규병원 가입신청 모달 (2026-08-19)
     · LoginWinCT.jsp 에서 <jsp:include> 로 끌어다 쓴다. 기존 회원가입(#mainModal)과 같은 방식이다.
       ★직접 열리는 페이지가 아니다 — 로그인 화면의 [신규병원 가입신청] 이 이 모달을 띄운다.
     · 기존 [회원가입]은 **등록된 병원의 사용자 등록**이라 계약이 없으면 막힌다.
       신규 기관은 그 길로 못 들어오므로 이 모달이 그 앞단이다.

     · ★화면 양식은 **의뢰서(HWP) 서식을 그대로** 옮긴다.
         - 표(라벨칸 + 입력칸) 형태, 항목 순서도 의뢰서 그대로
         - 「* 노란색 바탕은 반드시 작성 부탁드립니다」 — 필수칸을 **노란 바탕**으로
     · 탭 3개 = 의뢰서 서식 3종. 저장도 이 세 분류 그대로 나뉜다.
         ① [서식1] 컨설팅 의뢰서       → TBL_JOIN_REQ (+ TBL_JOIN_MGR)
         ② [서식2] 원격접속·DB접근 동의 → TBL_JOIN_AGREE
         ③ [서식3] 개인정보 수집·이용   → TBL_JOIN_AGREE
     · 보기는 탭 하나뿐이다. 이어 보여주는 스크롤 방식은 헷갈려 뺐다(2026-08-19).
     · 동의 항목은 TBL_AGREE_MST 에서 AJAX 로 읽어 FORM_NO 기준으로 탭에 나눠 붙인다.
       ★받는 동의는 TBL_AGREE_MST.USE_YN 이 정한다. 현재 서식2·서식3 둘뿐(AGREE_USE_FIX_20260819.sql).
     · 전산프로그램 정보(MASTER)·심평원 인증서암호를 **받는다**(2026-08-19 결정).
       위너넷 직원이 그 병원의 심사청구까지 대행하므로 업무상 필요한 접속정보다.
       저장 위치·방식은 기존 계약정보(TBL_HOSPCONT_MST)와 같고, 승인 시 그리로 옮긴다.
     · 주소는 카카오(다음) 우편번호 서비스로 넣는다 — 우편번호·주소칸은 readonly, 상세주소만 직접 입력.
     · ★주의: 이 파일 안에서 Deferred EL 표기(샵+중괄호) 금지 --%>

<%-- 카카오(다음) 우편번호 서비스 — wnn_medcost hospcd.jsp 와 같은 것을 쓴다.
     ★거기서는 .embed() 로 별도 모달에 넣었지만, 여기는 이미 모달 안이라 모달을 겹치면 꼬인다.
       그래서 .open() 으로 자체 레이어를 띄운다. --%>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

<div class="modal fade" id="joinModal" tabindex="-1" data-backdrop="static"
     data-keyboard="false" aria-hidden="true" role="dialog">
  <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable" role="document"
       style="max-width: 1000px;">
    <div class="modal-content rounded-3 shadow-lg">

      <div class="modal-header" style="background:#003366; padding:11px 16px;">
        <div style="display:flex; align-items:center; gap:10px; width:100%; flex-wrap:wrap;">
          <h5 class="modal-title" style="color:#fff; font-weight:800; font-size:17px; margin:0;">
            신규병원 가입신청
          </h5>
          <span style="color:#cfe0f0; font-size:12px;">① 신청 → ② 위너넷 검토 → ③ 승인 → ④ 계약등록</span>
          <div style="flex:1;"></div>
          <%-- [가입신청]은 **위 한 곳에만** 둔다(2026-08-19 지정).
               기존 회원가입 모달(#mainModal)도 저장 버튼이 위에 있어 조작감이 같다. --%>
          <button type="button" class="btn btn-light rounded px-3 py-1"
                  style="font-size:13px; font-weight:700;" onclick="jaSubmit();">
            가입신청 <i class="far fa-edit"></i>
          </button>
          <button type="button" class="btn btn-outline-light rounded px-3 py-1"
                  style="font-size:13px;" data-dismiss="modal" onclick="jaClose();">
            닫기 <i class="fas fa-times"></i>
          </button>
        </div>
      </div>

      <div class="modal-body" id="joinModalBody" style="padding:0;">
      <div id="joinModal_in">
<style>
  #joinModal_in{ background:#f4f6f8; color:#1f2a30; padding:11px 13px 13px; font-family:inherit; }
  #joinModal_in *{ box-sizing:border-box; }

  /* ── 안내 띠 */
  #joinModal_in .ja-guide{ background:#f2f8f5; border:1px solid #cfe3da; border-radius:6px;
      padding:7px 10px; font-size:12px; color:#33564a; margin-bottom:7px; line-height:1.5; }
  #joinModal_in .ja-warn{ background:#fff6f5; border:1px solid #f0d3d0; border-radius:6px;
      padding:8px 11px; font-size:12.5px; color:#8a3b36; margin-bottom:9px; line-height:1.6; }
  #joinModal_in .ja-must{ font-size:11.5px; color:#8a6d00; margin:0 0 6px; font-weight:700; }
  #joinModal_in .ja-must i{ display:inline-block; width:13px; height:13px; background:#fff6c9;
      border:1px solid #e0cf85; vertical-align:-2px; margin-right:4px; }

  /* ── 탭 · 보기전환 · 글자 크기
       ★글자 크기는 `zoom` — CSS 가 px 라 뿌리 font-size 로는 표 칸이 안 따라 커진다. */
  #joinModal_in .ja-tabs{ display:flex; gap:6px; margin:0 0 8px; flex-wrap:wrap; align-items:center; }
  #joinModal_in .ja-tab{ border:1px solid #cfd9e0; background:#f4f7f9; color:#43555f; border-radius:8px 8px 0 0;
                         padding:7px 14px; font-size:13px; font-weight:700; cursor:pointer; }
  #joinModal_in .ja-tab:hover{ background:#e9eff3; }
  #joinModal_in .ja-tab.on{ background:#1f5a4b; border-color:#1f5a4b; color:#fff; }
  #joinModal_in .ja-tab .bad{ color:#d9534f; margin-left:4px; font-weight:900; }
  #joinModal_in .ja-tab.on .bad{ color:#ffd7d5; }
  #joinModal_in .ja-tools{ display:inline-flex; gap:4px; align-items:center; margin-left:auto; }
  #joinModal_in .ja-tools button{ border:1px solid #cfd9e0; background:#fff; color:#43555f; border-radius:6px;
                                  padding:3px 9px; font-size:12.5px; font-weight:700; cursor:pointer; }
  #joinModal_in .ja-tools button:hover{ background:#eef3f6; }
  #joinModal_in .ja-tools button.on{ background:#1f5a4b; border-color:#1f5a4b; color:#fff; }
  #joinModal_in .ja-tools .sep{ width:1px; height:18px; background:#dbe3e8; margin:0 4px; }

  /* ── 카드 */
  #joinModal_in .ja-card{ background:#fff; border:1px solid #e3e9ed; border-radius:10px;
                          padding:10px 12px; margin-bottom:8px; }
  #joinModal_in .ja-card h4{ margin:0 0 7px; font-size:13.5px; font-weight:800; color:#1f5a4b;
                             display:flex; align-items:center; gap:6px; flex-wrap:wrap; }
  #joinModal_in .ja-card h4 .hint{ font-weight:500; font-size:12px; color:#8a99a3; }
  #joinModal_in .ja-pane{ display:none; }
  #joinModal_in .ja-pane.on{ display:block; }

  /* ── 의뢰서 표 : 라벨칸 + 입력칸. 필수는 노란 바탕 ───────────────── */
  #joinModal_in table.ja-sheet{ width:100%; border-collapse:collapse; font-size:12.5px; background:#fff;
                                table-layout:fixed; }
  #joinModal_in table.ja-sheet th{ background:#eef2f5; border:1px solid #c8d2d9; padding:4px 8px;
      text-align:left; font-weight:700; color:#3a4a53; white-space:nowrap; line-height:1.35; }
  #joinModal_in table.ja-sheet td{ border:1px solid #c8d2d9; padding:3px 5px; vertical-align:middle; }
  #joinModal_in table.ja-sheet th .rq{ color:#d9534f; font-weight:900; }
  #joinModal_in table.ja-sheet td.mid{ text-align:center; background:#fafcfd; font-weight:700; color:#43555f; }
  #joinModal_in table.ja-sheet td.lock{ background:#f3f5f7; color:#8a99a3; font-size:11.5px; }

  #joinModal_in input[type=text], #joinModal_in input[type=password],
  #joinModal_in select, #joinModal_in textarea{
      width:100%; border:1px solid #d7dee3; border-radius:4px; padding:4px 7px;
      font-family:inherit; font-size:12.5px; background:#fff; }
  #joinModal_in input.must, #joinModal_in select.must{ background:#fff6c9; }   /* 노란 바탕 = 필수 */
  #joinModal_in input:focus, #joinModal_in select:focus, #joinModal_in textarea:focus{
      outline:none; border-color:#1f5a4b; box-shadow:0 0 0 2px rgba(31,90,75,.12); }
  #joinModal_in input[readonly], #joinModal_in input:disabled{ background:#f3f5f7; color:#8a99a3; }
  /* readonly 필수칸이 생기면 회색에 묻히지 않게 노란 바탕을 유지한다 */
  #joinModal_in input.must[readonly]{ background:#fff6c9; color:#3a4a53; }
  /* 총 관리자 '직책' 은 자동으로 채워지지만 필수가 아니다 —
     readonly 회색을 그대로 두면 못 쓰는 칸처럼 보여 흰 바탕으로 돌린다(2026-08-19 지적) */
  #joinModal_in #ja_mgr0Job[readonly]{ background:#fff; color:#3a4a53; }
  #joinModal_in textarea{ min-height:52px; resize:vertical; }
  #joinModal_in .ja-inline{ display:flex; gap:5px; align-items:center; }
  #joinModal_in .ja-inline input{ flex:1; }
  #joinModal_in .ja-inline .lbl{ font-size:12px; color:#6b7c86; white-space:nowrap; }
  /* 안내문 자리를 미리 비워두면 그 줄만 키가 커져 표가 어긋난다(2026-08-19 지적).
     → 내용이 있을 때만 자리를 차지하게 한다. */
  #joinModal_in .ja-msg{ font-size:11.5px; margin-top:2px; line-height:1.3; }
  #joinModal_in .ja-msg:empty{ display:none; margin:0; }
  #joinModal_in .ja-msg.ok{ color:#1f5a4b; font-weight:700; }
  #joinModal_in .ja-msg.no{ color:#d9534f; font-weight:700; }
  #joinModal_in .ja-btn{ border:1px solid #1f5a4b; background:#1f5a4b; color:#fff; border-radius:5px;
      padding:5px 11px; font-size:12px; font-weight:600; cursor:pointer; white-space:nowrap; }
  #joinModal_in .ja-btn.ghost{ background:#fff; color:#1f5a4b; }
  #joinModal_in .ja-btn:hover{ opacity:.9; }
  #joinModal_in .ja-chk{ display:inline-flex; align-items:center; gap:4px; margin-right:12px;
      font-size:12.5px; color:#3a4a53; white-space:nowrap; }
  #joinModal_in input[type=checkbox], #joinModal_in input[type=radio]{
      width:15px; height:15px; accent-color:#1f5a4b; cursor:pointer; }

  /* ── 동의서 본문 · 체크 */
  #joinModal_in .ja-doc{ border:1px solid #c8d2d9; background:#fff;
      padding:12px 14px; font-size:12.5px; color:#3a4a53; line-height:1.85;
      white-space:pre-wrap; max-height:44vh; overflow-y:auto; margin-bottom:9px; }
  #joinModal_in .ja-doc.empty{ color:#8a99a3; text-align:center; padding:24px 6px; white-space:normal; }
  #joinModal_in .ja-agrbar{ display:flex; align-items:center; gap:9px; padding:9px 12px;
      background:#f2f8f5; border:1px solid #cfe3da; border-radius:8px; margin-bottom:8px; }
  #joinModal_in .ja-agrbar label{ margin:0; font-size:13px; font-weight:800; color:#1f5a4b; cursor:pointer; }
  #joinModal_in .ja-agrbar .ess{ color:#d9534f; font-size:11.5px; font-weight:800; }
  #joinModal_in .ja-agrbar .opt{ color:#8a99a3; font-size:11.5px; font-weight:800; }
  /* 서명란 — 의뢰서 서식 그대로 : 문구 / 날짜 / 요양기관명·대표자(인)·주소 / 위너넷 귀하 */
  #joinModal_in .ja-sign{ background:#fafcfd; border:1px solid #c8d2d9;
      padding:13px; font-size:12.5px; color:#43555f; text-align:center; }
  #joinModal_in .ja-sign .sg-txt{ font-weight:700; color:#20303a; margin-bottom:9px; }
  #joinModal_in .ja-sign .sg-date{ margin-bottom:9px; letter-spacing:1px; }
  /* 서명 상자 — 배치는 의뢰서 서식(왼쪽 2줄 + 오른쪽 대표자 세로병합),
     보이는 스타일은 위 입력표와 같게(회색 라벨칸 + 연한 테두리). */
  #joinModal_in .ja-sign .sg-box{ width:100%; border-collapse:collapse; margin:0 auto; font-size:12.5px; }
  #joinModal_in .ja-sign .sg-box th{ background:#eef2f5; border:1px solid #c8d2d9; padding:7px 9px;
      text-align:left; font-weight:700; color:#3a4a53; white-space:nowrap; }
  #joinModal_in .ja-sign .sg-box td{ border:1px solid #c8d2d9; padding:7px 10px; text-align:left;
      vertical-align:middle; height:32px; background:#fff; }
  #joinModal_in .ja-sign .sg-box b{ font-weight:700; color:#20303a; }
  /* 도장·사인 자리 — 불러온 그림을 「(인)」 위에 얹는다 */
  #joinModal_in .ja-sign .sg-sealbox{ position:relative; display:inline-block; float:right;
      min-width:52px; height:52px; margin-left:8px; }
  #joinModal_in .ja-sign .sg-seal{ color:#8a99a3; position:absolute; right:6px; top:16px; }
  #joinModal_in .ja-sign .sg-sealbox img{ position:absolute; right:0; top:0;
      max-width:52px; max-height:52px; }
  #joinModal_in .ja-sign .sg-sealbtn{ display:block; clear:both; padding-top:6px; text-align:right; }
  #joinModal_in .ja-sign .sg-sealbtn button{ margin-left:4px; }
  #joinModal_in .ja-sign .sg-to{ margin-top:10px; font-weight:700; color:#20303a; }
  #joinModal_in .ja-sign .sg-note{ margin-top:9px; font-size:11px; color:#8a99a3; }
  #joinModal_in .ja-sign b{ color:#20303a; }

  @media (max-width: 900px){
    #joinModal_in table.ja-sheet{ table-layout:auto; }
    #joinModal_in table.ja-sheet th{ white-space:normal; }
  }
</style>

<div class="ja-guide">
  <b>이미 등록된 병원</b>이라면 이 창이 아니라 <b>[회원가입]</b>을 이용하세요.
</div>

<%-- ★2026-08-24 프로세스 변경 — 신청 단계는 <요양기관기호 · 요양기관명 · 신청자정보> 만 받는다.
     나머지(전화번호·주소·대표자·전산프로그램·인증서암호·담당자표·목표점수 …)와 동의서 2종·대표자 도장은
     ***승인 후 병원이 로그인해서*** 「동의서 제출」 화면(wnn_medcost joinDocs.do)에서 채운다.
     ⇒ 탭 3개(의뢰서·원격접속동의·개인정보동의) 폐기. 이 창은 한 장짜리다. --%>
<div class="ja-tabs" id="jaTabs">
  <span class="ja-tools">
    <%-- 글자 크기 — 이 PC 이 브라우저에만 저장된다 --%>
    <button type="button" onclick="jaZoom(-1);" title="글자 작게">가－</button>
    <button type="button" onclick="jaZoom(1);"  title="글자 크게">가＋</button>
    <button type="button" onclick="jaZoom(0);"  title="처음 크기로">↺</button>
  </span>
</div>

<div id="jaZoomBox">
<form id="joinForm" name="joinForm" method="post" onsubmit="return false;">
  <%-- 대표자 도장·사인을 담는 이미지 칸. 파일 탐색기로 불러온 그림을 그대로 얹는다.
       base64 본문만 보낸다(data URL 접두어는 떼고). --%>
  <input type="file" id="ja_sealFile" accept="image/*" style="display:none;">
  <input type="hidden" id="ja_sealImg"  name="sealImg"  value="">
  <input type="hidden" id="ja_sealMime" name="sealMime" value="">
  <input type="hidden" id="ja_sealNm"   name="sealNm"   value="">

  <!-- ① [서식1] 컨설팅 의뢰서 ------------------------------------------------ -->
  <div class="ja-pane on" data-pane="f1">

    <div class="ja-card">
      <h4>컨설팅 의뢰서</h4>
      <p class="ja-must"><i></i>노란색 바탕은 반드시 작성 부탁드립니다.</p>

      <table class="ja-sheet">
        <colgroup>
          <col style="width:120px;"><col><col style="width:130px;"><col>
        </colgroup>
        <tbody>
          <tr>
            <th>병원명 <span class="rq">*</span></th>
            <td><input type="text" id="ja_hospNm" name="hospNm" class="must" maxlength="100" onkeyup="jaSignSync();"></td>
            <th>요양기관기호 <span class="rq">*</span></th>
            <td>
              <div class="ja-inline">
                <input type="text" id="ja_hospCd" name="hospCd" class="must" maxlength="8"
                       oninput="if(this.value.length>8) this.value=this.value.substring(0,8);"
                       onchange="jaHospReset();">
                <button type="button" class="ja-btn ghost" onclick="jaHospChk();">확인</button>
              </div>
              <div class="ja-msg" id="ja_hospCdMsg"></div>
            </td>
          </tr>
        </tbody>
      </table>
    </div>

    <div class="ja-card">
      <h4>신청자 · 로그인 계정 <span class="hint">승인되면 이 이메일이 로그인 ID 가 됩니다</span></h4>
      <table class="ja-sheet">
        <colgroup>
          <col style="width:120px;"><col><col style="width:120px;"><col>
        </colgroup>
        <tbody>
          <tr>
            <%-- 이메일 줄은 colspan 으로 표 전체를 쓴다. 그냥 두면 입력칸만 늘어나
                 도메인·중복확인이 저 멀리 오른쪽 끝에 떨어져 한 줄로 안 읽힌다(2026-08-19 지적).
                 → 세 요소를 왼쪽에 붙여 한 덩어리로 두고, 남는 폭은 뒤에 흘린다. --%>
            <th>이메일 (ID) <span class="rq">*</span></th>
            <td colspan="3">
              <div class="ja-inline" style="justify-content:flex-start;">
                <input type="text" id="ja_email" name="email" class="must" maxlength="100"
                       placeholder="winner@hospital.co.kr"
                       style="flex:0 1 300px;" onchange="jaEmailReset();">
                <select id="ja_emailList" style="flex:0 0 130px;" onchange="jaEmailDomain();">
                  <option value="">직접입력</option>
                  <c:forEach var="row" items="${commList}">
                    <option value="<c:out value='${row.subCode}'/>"><c:out value="${row.subCodeNm}"/></option>
                  </c:forEach>
                </select>
                <button type="button" class="ja-btn ghost" onclick="jaEmailChk();">중복확인</button>
                <span style="flex:1;"></span>
              </div>
              <div class="ja-msg" id="ja_emailMsg"></div>
            </td>
          </tr>
          <tr>
            <th>비밀번호 <span class="rq">*</span></th>
            <td><input type="password" id="ja_passWd" name="passWd" class="must" maxlength="30" placeholder="4자 이상"></td>
            <th>비밀번호 확인 <span class="rq">*</span></th>
            <td><input type="password" id="ja_afPassWd" name="afPassWd" class="must" maxlength="30">
                <div class="ja-msg" id="ja_pwdMsg"></div></td>
          </tr>
          <tr>
            <th>신청자 성명 <span class="rq">*</span></th>
            <td><input type="text" id="ja_mbrNm" name="mbrNm" class="must" maxlength="50"></td>
            <th>직위</th>
            <td><input type="text" id="ja_jobNm" name="jobNm" maxlength="50" placeholder="예: 원무과장"></td>
          </tr>
          <tr>
            <th>연락처 <span class="rq">*</span></th>
            <td><input type="text" id="ja_mbrTel" name="mbrTel" class="must" maxlength="50"></td>
            <%-- 가입(신청)일자는 **오늘로 고정**. 화면 값은 보여주기용이고,
                 실제 저장은 서버가 NOW() 로 넣는다(TBL_JOIN_REQ.REQ_DTTM) — 화면 값을 믿지 않는다. --%>
            <th>가입일자</th>
            <td><input type="text" id="ja_joinDt" maxlength="10" readonly></td>
          </tr>
          <tr>
            <th>비 고</th>
            <td colspan="3">
              <textarea id="ja_bigo" name="bigo" maxlength="500"
                        placeholder="위너넷에게 전달하고자 하는 내용을 적어 주세요."></textarea>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>

</form>
</div><%-- /jaZoomBox --%>
</div><%-- /joinModal_in --%>
      </div><%-- /modal-body --%>

      <%-- 하단에는 [가입신청]을 두지 않는다(2026-08-19 지정) — 신청은 위 버튼 하나로.
           미입력 안내는 남긴다. 무엇이 비었는지 알려주는 역할은 버튼과 별개다. --%>
      <div class="modal-footer" style="padding:9px 16px; justify-content:flex-start; gap:10px;">
        <span id="ja_lack" style="font-size:12.5px; font-weight:700; color:#d9534f;"></span>
      </div>

    </div>
  </div>
</div>

<script>
(function(){
  "use strict";

  var CTX         = '<c:out value="${pageContext.request.contextPath}"/>';
  var JA_Z_KEY    = 'wnnJoinZoom';
  /* ★[2026-08-20 요청] 기본 글자 크기를 **한 단계(0.1) 크게** 시작한다 — 1.0 → 1.1.
     병원이 직접 쓰는 화면이라 처음부터 크게 보이는 편이 낫다(관리자쪽 joinReq.jsp 도 같이 올렸다).
     [↺ 처음 크기로] 도 이 값으로 돌아간다. ⚠조절은 JA_Z_DEF 한 줄. 저장된 개인 설정이 있으면 그게 먼저다. */
  var JA_Z_MIN = 0.8, JA_Z_MAX = 1.6, JA_Z_DEF = 1.1;

  var hospOk  = false;      // 요양기관기호 확인 통과
  var emailOk = false;      // 이메일 중복확인 통과
  var AGREES  = [];         // TBL_AGREE_MST 에서 읽은 동의 항목
  var loaded  = false;

  function gel(id){ return document.getElementById(id); }
  function val(id){ var e = gel(id); return e ? String(e.value || '').trim() : ''; }
  function esc(s){
    return String(s == null ? '' : s)
      .replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;')
      .replace(/"/g,'&quot;').replace(/'/g,'&#39;');
  }

  /* ── 알림 : SweetAlert 컴팩트 (width 380 · 아이콘 48px) ─────────────── */
  function jaMsg(icon, title, text){
    if (window.Swal) {
      Swal.fire({ icon:icon, title:title, text:text || '', width:380,
                  customClass:{ icon:'ja-swal-icon', container:'ja-swal-top', popup:'ja-swal-pop' },
                  confirmButtonText:'확인', confirmButtonColor:'#1f5a4b' });
    } else { alert(title + (text ? '\n' + text : '')); }
  }
  function jaConfirm(title, text, onYes){
    if (window.Swal) {
      Swal.fire({ icon:'question', title:title, text:text || '', width:380,
                  customClass:{ icon:'ja-swal-icon', container:'ja-swal-top', popup:'ja-swal-pop' },
                  showCancelButton:true, confirmButtonText:'신청', cancelButtonText:'취소',
                  confirmButtonColor:'#1f5a4b' })
          .then(function(r){ if (r.isConfirmed) onYes(); });
    } else { if (confirm(title)) onYes(); }
  }
  /* Swal 아이콘 축소 + 모달(z-index 1050) 위로 올리기 */
  (function(){
    var st = document.createElement('style');
    st.textContent = '.ja-swal-icon{ width:48px !important; height:48px !important;'
                   + ' font-size:24px !important; border-width:3px !important; margin:12px auto 6px !important; }'
                   + '.ja-swal-icon .swal2-icon-content{ font-size:28px !important; }'
                   + '.ja-swal-top{ z-index:2000 !important; }'
                   /* 제목 글자가 기본 30px 이라 380 폭에서 너무 크다(2026-08-19 지적) */
                   + '.ja-swal-pop .swal2-title{ font-size:15px !important; font-weight:700 !important;'
                   + ' line-height:1.5 !important; padding:0 10px 4px !important; color:#20303a !important; }'
                   + '.ja-swal-pop .swal2-html-container, .ja-swal-pop #swal2-html-container{'
                   + ' font-size:13px !important; line-height:1.6 !important; margin:4px 10px 0 !important; }'
                   + '.ja-swal-pop .swal2-actions{ margin-top:12px !important; }'
                   + '.ja-swal-pop .swal2-styled{ font-size:13px !important; padding:6px 20px !important; }';
    document.head.appendChild(st);
  })();

  /* ── 탭 — 한 번에 하나만 보인다.
       전체를 이어 보여주는 스크롤 보기는 어디가 어디인지 헷갈려 뺐다(2026-08-19). */
  var jaTab = 'f1';
  window.jaPickTab = function(k){
    jaTab = k;
    jaTabSync();
    var bd = gel('joinModalBody'); if (bd) bd.scrollTop = 0;
  };
  function jaTabMark(){
    var tabs = document.querySelectorAll('#joinModal_in .ja-tab');
    for (var i = 0; i < tabs.length; i++) {
      tabs[i].classList.toggle('on', tabs[i].getAttribute('data-pane') === jaTab);
    }
  }
  function jaTabSync(){
    jaTabMark();
    var panes = document.querySelectorAll('#joinModal_in .ja-pane');
    for (var j = 0; j < panes.length; j++) {

      panes[j].classList.toggle('on', panes[j].getAttribute('data-pane') === jaTab);
    }
    jaLackSync();
  }

  /* ── 글자 크기 — CSS 가 px 라 `zoom` 으로 통째로 키운다 ─────────────── */
  function jaApplyZoom(z){
    z = Math.min(JA_Z_MAX, Math.max(JA_Z_MIN, z));
    var b = gel('jaZoomBox');
    if (b) b.style.zoom = z.toFixed(2);
    return z;
  }
  window.jaZoom = function(d){
    var b = gel('jaZoomBox');
    var cur = parseFloat(b && b.style.zoom) || JA_Z_DEF;
    if (d === 0) { jaApplyZoom(JA_Z_DEF); try { localStorage.removeItem(JA_Z_KEY); } catch (ignore) {} return; }
    var z = jaApplyZoom(cur + d * 0.1);
    try { localStorage.setItem(JA_Z_KEY, String(z)); } catch (ignore) {}
  };

  /* ── 동의 항목 : FORM_NO 로 탭에 나눠 붙인다 ───────────────────── */
  function jaLoadAgree(){
    $.ajax({
      type: 'post', url: CTX + '/join/joinAgreeList.do', dataType: 'json',
      success: function(data){
        if (data.error_code !== '0') { jaMsg('error','동의서를 불러오지 못했습니다', data.error_msg); return; }
        AGREES = data.agreeList || [];
        jaRenderAgree();
        loaded = true;
      },
      error: function(){ jaMsg('error','동의서를 불러오지 못했습니다','잠시 후 다시 시도해 주세요.'); }
    });
  }
  function agrHtml(a, idx){
    var ess = (a.essYn === 'Y');
    return '<div class="ja-agrbar">'
         + '<input type="hidden" name="agreeList[' + idx + '].agreeCd" value="' + esc(a.agreeCd) + '">'
         + '<input type="hidden" name="agreeList[' + idx + '].verNo"  value="' + esc(a.verNo) + '">'
         + '<input type="hidden" name="agreeList[' + idx + '].readYn" id="ja_read' + idx + '" value="N">'
         + '<input type="checkbox" class="ja-agrchk" id="ja_agr' + idx + '"'
         + ' name="agreeList[' + idx + '].agreeYn" value="Y" data-ess="' + esc(a.essYn) + '"'
         + ' onchange="jaLackSync();">'
         + '<label for="ja_agr' + idx + '">'
         + (ess ? '<span class="ess">[필수]</span> ' : '<span class="opt">[선택]</span> ')
         + esc(a.agreeNm) + ' 에 동의합니다</label>'
         + '</div>';
  }
  function jaRenderAgree(){
    /* 서식 번호로 탭에 나눈다. 서식에 안 딸린 항목은 이 화면에서 다루지 않는다
       — 무엇을 받을지는 TBL_AGREE_MST.USE_YN 으로 정한다(AGREE_USE_FIX_20260819.sql). */
    var f1 = [], f2 = [], f3 = [];
    for (var i = 0; i < AGREES.length; i++) {
      var a = AGREES[i], fn = String(a.formNo || '');
      if      (fn.indexOf('1') >= 0) f1.push({ a:a, i:i });
      else if (fn.indexOf('2') >= 0) f2.push({ a:a, i:i });
      else if (fn.indexOf('3') >= 0) f3.push({ a:a, i:i });
    }
    function put(boxId, arr){
      var box = gel(boxId); if (!box) return;
      box.innerHTML = arr.map(function(o){ return agrHtml(o.a, o.i); }).join('');
    }
    put('jaAgrF1', f1); put('jaAgrF2', f2); put('jaAgrF3', f3);
    var f1Card = gel('jaF1AgrCard');
    if (f1Card) f1Card.style.display = f1.length ? '' : 'none';

    function doc(boxId, arr){
      var box = gel(boxId); if (!box) return;
      var txt = arr.length ? String(arr[0].a.agreeText || '') : '';
      if (txt.trim() === '') {
        box.className = 'ja-doc empty';
        box.textContent = '등록된 동의서 본문이 없습니다. 위너넷 담당자에게 문의해 주세요.';
      } else {
        box.className = 'ja-doc';
        box.textContent = txt;
        for (var k = 0; k < arr.length; k++) {
          var r = gel('ja_read' + arr[k].i);
          if (r) r.value = 'Y';                 // 전문을 펼쳐 보여 주므로 열람으로 본다
        }
      }
    }
    doc('jaDocF1', f1); doc('jaDocF2', f2); doc('jaDocF3', f3);
    jaLackSync();
  }

  /* ── 요양기관기호 확인 ──────────────────────────────────────────── */
  window.jaHospReset = function(){
    hospOk = false;
    var m = gel('ja_hospCdMsg'); if (m) { m.className = 'ja-msg'; m.textContent = ''; }
    jaLackSync();
  };
  window.jaHospChk = function(){
    var cd = val('ja_hospCd'), m = gel('ja_hospCdMsg');
    if (cd === '') { jaMsg('warning','요양기관기호를 입력하세요.'); gel('ja_hospCd').focus(); return; }
    if (cd.length > 8) { jaMsg('warning','요양기관기호는 8자를 넘을 수 없습니다.'); gel('ja_hospCd').focus(); return; }
    $.ajax({
      type: 'post', url: CTX + '/join/joinHospChk.do', data: { hospCd: cd }, dataType: 'json',
      success: function(data){
        if (data.error_code !== '0') { jaMsg('error','확인 실패', data.error_msg); return; }
        if (data.hospCnt > 0) {
          hospOk = false; m.className = 'ja-msg no';
          m.textContent = '이미 등록된 요양기관입니다' + (data.hospNmDb ? ' (' + data.hospNmDb + ')' : '') + '.';
          jaMsg('info','이미 등록된 요양기관입니다',
                '신규 가입신청 대상이 아닙니다. 창을 닫고 [회원가입]으로 사용자만 등록하세요.');
        } else if (data.reqCnt > 0) {
          hospOk = false; m.className = 'ja-msg no';
          m.textContent = '이미 접수된 가입신청이 있습니다.';
          jaMsg('info','이미 접수된 신청이 있습니다','처리 결과를 기다려 주세요.');
        } else {
          hospOk = true; m.className = 'ja-msg ok';
          m.textContent = '신규 가입신청이 가능한 요양기관기호입니다.';
        }
        jaLackSync();
      },
      error: function(){ jaMsg('error','확인 실패','잠시 후 다시 시도해 주세요.'); }
    });
  };

  /* ── 이메일 ────────────────────────────────────────────────────── */
  window.jaEmailReset = function(){
    emailOk = false;
    var m = gel('ja_emailMsg'); if (m) { m.className = 'ja-msg'; m.textContent = ''; }
    jaMgrSync(); jaLackSync();
  };
  window.jaEmailDomain = function(){
    var dm = val('ja_emailList'); if (dm === '') return;
    var e = gel('ja_email'), id = String(e.value || '').split('@')[0];
    e.value = (id || 'user') + '@' + dm;
    jaEmailReset();
  };
  window.jaEmailChk = function(){
    var em = val('ja_email').toLowerCase(), m = gel('ja_emailMsg');
    if (em === '') { jaMsg('warning','이메일을 입력하세요.'); gel('ja_email').focus(); return; }
    if (em.indexOf('@') < 1 || em.indexOf('.') < 0) { jaMsg('warning','이메일 형식이 아닙니다.'); return; }
    gel('ja_email').value = em;
    $.ajax({
      type: 'post', url: CTX + '/join/joinEmailChk.do', data: { email: em }, dataType: 'json',
      success: function(data){
        if (data.error_code !== '0') { jaMsg('error','확인 실패', data.error_msg); return; }
        if (data.userCnt > 0 || data.reqCnt > 0) {
          emailOk = false; m.className = 'ja-msg no';
          m.textContent = (data.userCnt > 0) ? '이미 사용 중인 이메일입니다.'
                                             : '이 이메일로 접수된 신청이 이미 있습니다.';
        } else {
          emailOk = true; m.className = 'ja-msg ok';
          m.textContent = '사용 가능한 이메일입니다.';
        }
        jaMgrSync(); jaLackSync();
      },
      error: function(){ jaMsg('error','확인 실패','잠시 후 다시 시도해 주세요.'); }
    });
  };

  /* ── 총 관리자 = 신청자 자동 · 동의서 하단 기관표시 자동 ─────────── */
  /* 총 관리자 = 신청자 자동.
     ★예전에는 readonly 라 손으로 못 고쳤다 — 총 관리자가 신청자와 다른 사람이면 적을 방법이 없었다(2026-08-19 지적).
       이제 직접 칠 수 있고, 자동 채움은 **비어 있거나 앞서 자동으로 넣은 값 그대로일 때만** 덮어쓴다.
       손으로 고친 값은 신청자 정보를 바꿔도 지워지지 않는다. */
  var MGR_AUTO = {};
  window.jaMgrSync = function(){
    var map = { ja_mgr0Nm:'ja_mbrNm', ja_mgr0Tel:'ja_mbrTel', ja_mgr0Mail:'ja_email', ja_mgr0Job:'ja_jobNm' };
    for (var k in map) {
      if (!Object.prototype.hasOwnProperty.call(map, k)) continue;
      var t = gel(k); if (!t) continue;
      var cur = String(t.value || '').trim();
      if (cur !== '' && cur !== (MGR_AUTO[k] || '')) continue;   // 손으로 고친 값은 그대로 둔다
      var v = val(map[k]);
      t.value = v;
      MGR_AUTO[k] = v;
    }
  };
  window.jaSignSync = function(){
    function put(cls, v){
      var els = document.querySelectorAll('#joinModal_in ' + cls);
      for (var i = 0; i < els.length; i++) els[i].textContent = (v === '' ? '-' : v);
    }
    put('.ja-sgHosp', val('ja_hospNm'));
    put('.ja-sgCeo',  val('ja_hospCeo'));
    var ad = val('ja_hospAddr') + (val('ja_hospExtradr') ? ' ' + val('ja_hospExtradr') : '');
    put('.ja-sgAddr', ad.trim());
  };

  /* ── 주소검색 (카카오/다음 우편번호) ─────────────────────────────
     wnn_medcost hospcd.jsp 와 같은 서비스. 거기는 .embed() 로 모달에 넣었지만
     여기는 이미 모달 안이라 겹치면 꼬인다 → .open() 으로 자체 레이어를 띄운다.
     ★우편번호·주소칸은 readonly — 손으로 고치면 우편번호와 주소가 어긋난다.
       상세주소만 직접 적는다. */
  window.jaAddrSearch = function(){
    if (typeof daum === 'undefined' || !daum.Postcode) {
      jaMsg('error','주소검색을 열 수 없습니다','인터넷 연결을 확인해 주세요.');
      return;
    }
    new daum.Postcode({
      oncomplete: function(data){
        var addr = (data.userSelectedType === 'R') ? data.roadAddress : data.jibunAddress;
        var extra = '';
        if (data.userSelectedType === 'R') {
          if (data.bname && /[동|로|가]$/g.test(data.bname)) extra += data.bname;
          if (data.buildingName && data.apartment === 'Y') {
            extra += (extra !== '' ? ', ' + data.buildingName : data.buildingName);
          }
          if (extra !== '') extra = ' (' + extra + ')';
        }
        gel('ja_zipCd').value    = data.zonecode;
        gel('ja_hospAddr').value = addr + extra;
        jaSignSync(); jaLackSync();
        var ex = gel('ja_hospExtradr'); if (ex) ex.focus();
      }
    }).open();
  };

  /* 희망 서비스 — 둘 다 고를 수 있다. 값은 기존 계약구분 판정 규칙과 같게 담는다
     ('A' 둘 다 / '1' 진료비분석 / '2' 적정성평가 / '' 미선택). */
  window.jaConactSync = function(){
    var c1 = gel('ja_conact1'), c2 = gel('ja_conact2'), h = gel('ja_conactGb');
    if (!c1 || !c2 || !h) return;
    h.value = (c1.checked && c2.checked) ? 'A'
            : c1.checked ? '1'
            : c2.checked ? '2' : '';
  };

  /* ── 도장·사인 이미지 ────────────────────────────────────────────
     파일 탐색기로 그림을 불러와 동의서 「(인)」 자리에 얹는다.
     ★원본 그대로 보내면 폰카 사진이 수 MB 라 폼 전송이 막힌다 →
       캔버스로 가로 400px 이하로 줄이고 PNG(투명 유지)로 바꿔 보낸다. */
  var SEAL_MAX = 400;
  /* 큰 사진은 줄이는 데 잠깐 걸린다 — 버튼으로 진행 중임을 알린다(아무 반응 없으면 두 번 누른다) */
  function jaSealBusy(on){
    var bs = document.querySelectorAll('#joinModal_in .sg-sealbtn button');
    for (var i = 0; i < bs.length; i++) {
      bs[i].disabled = on;
      if (/불러오기|처리 중/.test(bs[i].textContent)) bs[i].textContent = on ? '처리 중…' : '직인 불러오기';
    }
  }
  window.jaSealPick = function(){ var f = gel('ja_sealFile'); if (f) { f.value = ''; f.click(); } };
  window.jaSealClear = function(){
    gel('ja_sealImg').value = ''; gel('ja_sealMime').value = ''; gel('ja_sealNm').value = '';
    var im = document.querySelectorAll('#joinModal_in .ja-sealimg');
    for (var i = 0; i < im.length; i++) { im[i].removeAttribute('src'); im[i].style.display = 'none'; }
    var sl = document.querySelectorAll('#joinModal_in .sg-seal');
    for (var j = 0; j < sl.length; j++) sl[j].style.visibility = '';
    var db = document.querySelectorAll('#joinModal_in .ja-sealdel');
    for (var k = 0; k < db.length; k++) db[k].style.display = 'none';
    if (window.jaLackSync) jaLackSync();
  };
  function jaSealApply(dataUrl){
    var im = document.querySelectorAll('#joinModal_in .ja-sealimg');
    for (var i = 0; i < im.length; i++) { im[i].src = dataUrl; im[i].style.display = ''; }
    // 그림이 올라오면 「(인)」 글자는 감춘다 — 겹쳐 보이면 지저분하다
    var sl = document.querySelectorAll('#joinModal_in .sg-seal');
    for (var j = 0; j < sl.length; j++) sl[j].style.visibility = 'hidden';
    var db = document.querySelectorAll('#joinModal_in .ja-sealdel');
    for (var k = 0; k < db.length; k++) db[k].style.display = '';
    gel('ja_sealImg').value  = dataUrl.substring(dataUrl.indexOf(',') + 1);   // base64 본문만
    gel('ja_sealMime').value = 'image/png';
    jaLackSync();
  }
  (function(){
    var f = gel('ja_sealFile'); if (!f) return;
    f.addEventListener('change', function(){
      var file = f.files && f.files[0]; if (!file) return;
      if (file.size > 10 * 1024 * 1024) { jaMsg('warning','그림이 너무 큽니다','10MB 이하로 올려 주세요.'); return; }
      gel('ja_sealNm').value = file.name;
      jaSealBusy(true);
      /* ★FileReader.readAsDataURL 로 읽지 않는다.
         원본(폰카 사진 수 MB)을 통째로 base64 문자열로 만든 뒤에야 그림을 그리기 시작해서
         몇 초씩 멈춘다. createObjectURL 은 그 변환 없이 바로 디코딩한다 —
         base64 는 400px 로 줄인 뒤 딱 한 번만 만든다. */
      var url = URL.createObjectURL(file);
      var img = new Image();
      img.onload = function(){
        var w = img.width, h = img.height;
        if (w > SEAL_MAX) { h = Math.round(h * SEAL_MAX / w); w = SEAL_MAX; }
        var cv = document.createElement('canvas');
        cv.width = w; cv.height = h;
        cv.getContext('2d').drawImage(img, 0, 0, w, h);
        URL.revokeObjectURL(url);
        jaSealApply(cv.toDataURL('image/png'));
        jaSealBusy(false);
      };
      img.onerror = function(){
        URL.revokeObjectURL(url);
        jaSealBusy(false);
        jaMsg('error','그림을 읽지 못했습니다','PNG·JPG 파일인지 확인해 주세요.');
      };
      img.src = url;
    });
  })();

  /* [삭제 2026-08-19] 가입신청 화면의 PDF 저장 기능을 뺐다.
     문서는 승인 뒤 병원이 **로그인해서** 만들고 올린다(wnn_medcost /join/joinDocs.do).
     신청 단계에서 만든 PDF 는 승인 전 내용이라 서명본으로 쓸 수 없었다. */

  /* PC 사용여부 — 고른 항목에 딸린 칸만 연다 */
  window.jaPcUseSync = function(){
    var r = document.querySelector('#joinModal_in input[name="pcUseGb"]:checked');
    var gb = r ? r.value : '';
    var t = gel('ja_pcUseTime'), d = gel('ja_pcUseStdt');
    t.disabled = (gb !== '2'); if (t.disabled) t.value = '';
    d.disabled = (gb !== '3'); if (d.disabled) d.value = '';
  };

  /* ── 미입력 표시 ───────────────────────────────────────────────── */
  function agrLack(pane){
    var box = document.querySelector('#joinModal_in .ja-pane[data-pane="' + pane + '"]');
    if (!box) return false;
    var cs = box.querySelectorAll('.ja-agrchk');
    for (var i = 0; i < cs.length; i++) {
      if (cs[i].getAttribute('data-ess') === 'Y' && !cs[i].checked) return true;
    }
    return false;
  }
  /* 필수 항목 — **항목 하나씩** 적는다.
     예전에는 탭 단위로 "미입력 : 컨설팅 의뢰서" 만 나와서 무엇이 빠졌는지 알 수 없었다(2026-08-19 지적).
     이제 바닥에 빠진 항목 이름이 그대로 나온다. */
  /* ★2026-08-24 — 신청 단계 필수는 <요양기관기호(확인) · 병원명 · 신청자정보> 뿐이다.
     대표자·주소·전산프로그램·인증서암호·담당자표·목표점수·동의서·도장은 승인 후 화면으로 옮겼다. */
  var LACK = [
    { pane:'f1', nm:'요양기관기호 확인', chk:function(){ return !hospOk; } },
    { pane:'f1', nm:'병원명',           chk:function(){ return val('ja_hospNm')===''; } },
    { pane:'f1', nm:'이메일 중복확인',  chk:function(){ return !emailOk; } },
    { pane:'f1', nm:'비밀번호',         chk:function(){ return val('ja_passWd')==='' || val('ja_afPassWd')===''
                                                            || val('ja_passWd') !== val('ja_afPassWd'); } },
    { pane:'f1', nm:'신청자 성명',      chk:function(){ return val('ja_mbrNm')===''; } },
    { pane:'f1', nm:'연락처',           chk:function(){ return val('ja_mbrTel')===''; } }
  ];
  window.jaLackSync = function(){
    var names = [], badPane = {};
    for (var i = 0; i < LACK.length; i++) {
      if (!LACK[i].chk()) continue;
      names.push(LACK[i].nm);
      badPane[LACK[i].pane] = true;
    }
    // 탭 머리의 ● 는 그 탭에 빠진 항목이 하나라도 있으면 붙인다
    var tabs = document.querySelectorAll('#joinModal_in .ja-tab');
    for (var t = 0; t < tabs.length; t++) {
      var bad = !!badPane[tabs[t].getAttribute('data-pane')];
      var mark = tabs[t].querySelector('.bad');
      if (bad && !mark) { var s = document.createElement('span'); s.className='bad'; s.textContent='●'; tabs[t].appendChild(s); }
      if (!bad && mark) mark.remove();
    }
    var box = gel('ja_lack');
    if (box) {
      if (names.length) {
        // 다 늘어놓으면 한 줄을 넘어가 못 읽는다 — 앞 5개만 보이고 나머지는 건수로
        var head = names.slice(0, 5).join(' · ');
        box.style.color = '#d9534f';
        box.textContent = '미입력 : ' + head + (names.length > 5 ? ' 외 ' + (names.length - 5) + '건' : '');
      } else {
        box.style.color = '#1f5a4b';
        box.textContent = '입력이 모두 끝났습니다. 신청하실 수 있습니다.';
      }
    }
    var pm = gel('ja_pwdMsg');
    if (pm) {
      if (val('ja_passWd') === '' && val('ja_afPassWd') === '') { pm.className='ja-msg'; pm.textContent=''; }
      else if (val('ja_passWd') !== val('ja_afPassWd'))         { pm.className='ja-msg no'; pm.textContent='서로 다릅니다.'; }
      else                                                       { pm.className='ja-msg ok'; pm.textContent='일치합니다.'; }
    }
  };

  /* ── 열기 · 닫기 ───────────────────────────────────────────────── */
  window.fnJoinApply = function(){
    gel('joinForm').reset();
    hospOk = false; emailOk = false;
    ['ja_hospCdMsg','ja_emailMsg','ja_pwdMsg'].forEach(function(id){
      var m = gel(id); if (m) { m.className='ja-msg'; m.textContent=''; }
    });
    // 가입일자 = 오늘 (표시용. 저장은 서버 NOW())
    var _t = new Date();
    var _dt = _t.getFullYear() + '-' + ('0'+(_t.getMonth()+1)).slice(-2) + '-' + ('0'+_t.getDate()).slice(-2);
    var _jd = gel('ja_joinDt'); if (_jd) _jd.value = _dt;
    // 동의서 서명란 날짜도 오늘 (의뢰서 서식의 「2026 년  월  일」 자리)
    function _put(cls, v){ var e = document.querySelectorAll('#joinModal_in ' + cls);
      for (var i = 0; i < e.length; i++) e[i].textContent = v; }
    _put('.ja-sgY', String(_t.getFullYear()));
    _put('.ja-sgM', String(_t.getMonth() + 1));
    _put('.ja-sgD', String(_t.getDate()));

    /* ★2026-08-24 — 동의서·도장·전산프로그램·담당자표가 이 창에서 빠졌다.
         그 칸들을 만지던 초기화(jaLoadAgree·jaSealClear·jaPcUseSync·jaConactSync·jaMgrSync·jaSignSync)는
         없는 요소를 건드려 <스크립트가 통째로 멈춘다>. 실제로 jaPcUseSync 에서 터졌다. 전부 뺀다. */

    /* ★열 때는 **항상 [컨설팅 의뢰서]부터** 시작한다.
       마지막에 보던 탭을 되살리면 동의서가 먼저 열려 신청서를 건너뛰게 된다.
       (글자 크기는 그대로 되살린다 — 그건 사람마다 고정해 두는 값이다) */
    jaTab = 'f1';
    try {
      var z = parseFloat(localStorage.getItem(JA_Z_KEY));
      jaApplyZoom(z || JA_Z_DEF);          // 저장해 둔 개인 설정이 없으면 기본(한 단계 큰) 크기로 시작
    } catch (ignore) { jaApplyZoom(JA_Z_DEF); }
    jaTabSync();

    $('#joinModal').modal('show');
  };
  window.jaClose = function(){ $('#joinModal').modal('hide'); };

  /* ── 제출 ──────────────────────────────────────────────────────── */
  function go(pane){ jaPickTab(pane); }
  window.jaSubmit = function(){
    /* ★2026-08-24 — 신청 단계 검사는 여섯 가지뿐이다.
         나머지 항목·동의서·도장은 승인 후 「동의서 제출」 화면에서 받고, 거기가 끝나야 메뉴가 열린다. */
    if (!hospOk)                     { jaMsg('warning','요양기관기호 [확인]을 눌러 주세요.'); return; }
    if (val('ja_hospNm') === '')     { jaMsg('warning','병원명을 입력하세요.'); gel('ja_hospNm').focus(); return; }
    if (!emailOk)                    { jaMsg('warning','이메일 [중복확인]을 눌러 주세요.'); return; }
    if (val('ja_passWd').length < 4) { jaMsg('warning','비밀번호는 4자 이상이어야 합니다.'); gel('ja_passWd').focus(); return; }
    if (val('ja_passWd') !== val('ja_afPassWd')) { jaMsg('warning','비밀번호가 서로 다릅니다.'); gel('ja_afPassWd').focus(); return; }
    if (val('ja_mbrNm') === '')      { jaMsg('warning','신청자 성명을 입력하세요.'); gel('ja_mbrNm').focus(); return; }
    if (val('ja_mbrTel') === '')     { jaMsg('warning','연락처를 입력하세요.'); gel('ja_mbrTel').focus(); return; }

    jaMgrSync();
    var formData = $("form[name='joinForm']").serialize();

    jaConfirm('가입신청을 접수할까요?', '접수 후 위너넷 담당자가 확인하고 연락드립니다.', function(){
      $.ajax({
        type: 'post', url: CTX + '/join/joinReqSaveAct.do', data: formData, dataType: 'json',
        success: function(data){
          if (data.error_code !== '0') { jaMsg('error','신청하지 못했습니다', data.error_msg); return; }
          jaClose();
          if (window.Swal) {
            Swal.fire({ icon:'success', title:'가입신청이 접수되었습니다', width:380,
                        html:'신청번호 <b>' + (data.reqNo || '') + '</b><br>'
                           + '<span style="font-size:12.5px;color:#6b7c86;">'
                           + '위너넷 담당자가 확인 후 연락드립니다.<br>'
                           + '승인·계약 등록이 끝나면 로그인하실 수 있습니다.</span>',
                        customClass:{ icon:'ja-swal-icon', container:'ja-swal-top', popup:'ja-swal-pop' },
                        confirmButtonText:'확인', confirmButtonColor:'#1f5a4b' });
          } else {
            alert('가입신청이 접수되었습니다. 신청번호 : ' + (data.reqNo || ''));
          }
        },
        error: function(){ jaMsg('error','신청하지 못했습니다','잠시 후 다시 시도해 주세요.'); }
      });
    });
  };

  $(function(){
    ['ja_mbrNm','ja_mbrTel','ja_jobNm','ja_email'].forEach(function(id){
      var e = gel(id); if (e) e.addEventListener('input', function(){ jaMgrSync(); jaLackSync(); });
    });
    ['ja_hospNm','ja_hospCeo','ja_hospTel','ja_hospAddr','ja_passWd','ja_afPassWd'].forEach(function(id){
      var e = gel(id); if (e) e.addEventListener('input', jaLackSync);
    });
    // 총 관리자 칸을 손으로 고칠 때도 미입력 안내가 따라간다
    ['ja_mgr0Nm','ja_mgr0Tel','ja_mgr0Mail','ja_mgr2Nm','ja_mgr2Tel','ja_mgr2Mail'].forEach(function(id){
      var e = gel(id); if (e) e.addEventListener('input', jaLackSync);
    });
  });
})();
</script>
