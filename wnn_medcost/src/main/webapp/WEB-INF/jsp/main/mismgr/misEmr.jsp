<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%-- misEmr.jsp — 경영고객관리 › 병원자료엑셀연계 (2026-10-11)
     · 닥터스(Doctors) EMR 과 직접 연계가 안 돼 병원이 EMR 에서 엑셀로 내려받아 올린다. 자료 여섯 가지(삭감은 같은 날 추가 — 청구는 기존 샘파일이 있어 받지 않고, 삭감을 그 샘파일 명세서와 매칭한다) :
       수납대장(PAY) · 행위별 통계(ACT) · 삭감 내역(CUT) · 입퇴원현황(IPWON) · 환자·보호자 연락처(CONTACT) · 직원·근무(STAFF).
     · 견본 양식이 없다 ⇒ 엑셀 머리글 ↔ 필드를 화면이 자동 추천하고 사람이 고친다. 맞춘 것은 병원·자료별로 기억(TBL_MIS_EMR_MAP)해 다음 달엔 그대로.
     · 저장 : PAY·ACT·CUT·STAFF = 고른 연월 통째 대체 · CONTACT = 병원 단위 최신본 대체 · IPWON = 기존 입원현황 업로드(/main/saveExcelDatas.do)와 같은 길(그 달 대체).
     · 엑셀 읽기 = SheetJS(header.jsp 가 defer 로 싣는다). 알림은 ui-message.
     · ★주의: 이 파일 안에서 Deferred EL 표기(샵+중괄호)와 JS 템플릿 문자열의 달러+중괄호 금지(JSP EL 이 먹는다) --%>

<script src="/asset/js/ui-message.js"></script>

<div class="dashboard-wrapper">
<div id="misEmr" data-wnn="<c:out value='${wnnYn}'/>" data-hosp="<c:out value='${hospCd}'/>">
<style>
  #misEmr{ background:#f4f6f8; color:#1f2a30; min-height:100%; padding:14px 16px 50px; max-width:100%; overflow-x:hidden; }
  #misEmr *{ box-sizing:border-box; }
  #misEmr .me-head{ display:flex; align-items:center; gap:10px; margin-bottom:12px; flex-wrap:wrap; }
  #misEmr .me-title{ font-size:18px; font-weight:800; color:#20303a; display:flex; align-items:center; gap:8px; }
  #misEmr .me-dot{ width:10px; height:10px; border-radius:50%; background:linear-gradient(135deg,#1f5a4b,#2a7665); }
  #misEmr .me-sub{ font-size:12px; color:#6b7c86; font-weight:400; }
  #misEmr .me-hosp{ background:#e7f3ee; color:#1f5a4b; font-size:12px; font-weight:800; border:1px solid #cfe3da; border-radius:14px; padding:3px 11px; }
  #misEmr .me-spacer{ flex:1; }
  #misEmr select, #misEmr input[type=text], #misEmr input[type=number]{ border:1px solid #cfd8e0; border-radius:6px; padding:5px 8px; font-size:13px; background:#fff; font-family:inherit; }
  #misEmr .me-btn{ border:1px solid #cfd9e0; background:#fff; color:#43555f; border-radius:6px; padding:5px 11px; font-size:12.5px; font-weight:700; cursor:pointer; white-space:nowrap; }
  #misEmr .me-btn:hover{ background:#eef3f6; }
  #misEmr .me-btn.pri{ background:#1f5a4b; color:#fff; border-color:#1f5a4b; }
  #misEmr .me-btn.pri:hover{ background:#2a7665; }
  #misEmr .me-btn:disabled{ opacity:.45; cursor:default; }
  #misEmr .me-note{ background:#fff; border:1px solid #e3e9ed; border-radius:10px; padding:10px 14px; font-size:12.5px; color:#43555f; margin-bottom:12px; line-height:1.6; }
  #misEmr .me-cards{ display:grid; grid-template-columns:repeat(6,1fr); gap:10px; margin-bottom:12px; }   /* 6종(삭감 추가 2026-10-11) */
  @media (max-width:1400px){ #misEmr .me-cards{ grid-template-columns:repeat(3,1fr); } }
  @media (max-width:1100px){ #misEmr .me-cards{ grid-template-columns:repeat(3,1fr); } }
  @media (max-width:760px){ #misEmr .me-cards{ grid-template-columns:repeat(2,1fr); } }
  #misEmr .me-cardx{ background:#fff; border:1px solid #e3e9ed; border-radius:10px; padding:10px 12px; cursor:pointer; min-width:0; }
  #misEmr .me-cardx:hover{ border-color:#9cc6b7; }
  #misEmr .me-cardx.on{ border:2px solid #1f5a4b; background:#f3faf7; padding:9px 11px; }
  #misEmr .me-cardx .l{ font-size:12.5px; font-weight:800; color:#20303a; display:flex; gap:6px; align-items:center; }
  #misEmr .me-cardx .v{ font-size:12px; color:#43555f; margin-top:4px; line-height:1.5; overflow-wrap:anywhere; }
  #misEmr .me-card{ background:#fff; border:1px solid #e3e9ed; border-radius:10px; padding:12px 14px; min-width:0; margin-bottom:12px; }
  #misEmr .me-card h4{ margin:0 0 8px; font-size:13.5px; color:#20303a; font-weight:800; display:flex; align-items:center; gap:8px; flex-wrap:wrap; }
  #misEmr .me-card h4 .sp{ flex:1; }
  #misEmr .drop{ border:2px dashed #b9cdc5; border-radius:10px; padding:16px; text-align:center; color:#43555f; font-size:13px; background:#fafcfb; }
  #misEmr .drop.over{ background:#e7f3ee; border-color:#1f5a4b; }
  #misEmr table{ width:100%; border-collapse:collapse; font-size:12.5px; }
  #misEmr th{ background:#f2f6f8; font-weight:700; color:#43555f; padding:6px 8px; border-bottom:1px solid #dde5ea; text-align:left; white-space:nowrap; }
  #misEmr td{ padding:5px 8px; border-bottom:1px solid #eef2f5; vertical-align:middle; }
  #misEmr td.n, #misEmr th.n{ text-align:right; font-variant-numeric:tabular-nums; }
  #misEmr tr.sum td{ font-weight:800; background:#f7faf9; }
  #misEmr tr.skip td{ color:#9aa7af; text-decoration:line-through; }
  #misEmr .wrap{ overflow:auto; max-height:420px; }
  #misEmr .wrap thead th{ position:sticky; top:0; z-index:1; }
  #misEmr .small{ font-size:12px; color:#6b7c86; }
  #misEmr .badge{ font-size:11px; font-weight:700; border-radius:10px; padding:1px 7px; background:#eef3f6; color:#43555f; white-space:nowrap; }
  #misEmr .badge.ok{ background:#e7f3ee; color:#1f5a4b; }
  #misEmr .badge.mem{ background:#e6eefb; color:#1a56c4; }
  #misEmr .badge.warn{ background:#fbeadb; color:#b45f1c; }
  #misEmr .badge.bad{ background:#fbe3e3; color:#b23b3b; }
  #misEmr .req{ color:#c0463f; font-weight:800; }
  #misEmr .samp{ color:#6b7c86; font-size:12px; max-width:420px; overflow:hidden; text-overflow:ellipsis; white-space:nowrap; }
  #misEmr .bar{ display:flex; gap:10px; align-items:center; flex-wrap:wrap; font-size:12.5px; margin-bottom:8px; }
  #misEmr .grid2{ display:grid; grid-template-columns:1fr 1fr; gap:12px; }
  #misEmr .grid2 > *{ min-width:0; }
  @media (max-width:1000px){ #misEmr .grid2{ grid-template-columns:1fr; } }
  #misEmr .empty{ color:#8a99a3; font-size:13px; padding:16px; text-align:center; }
</style>

<div class="me-head">
  <div class="me-title"><span class="me-dot"></span>병원자료엑셀연계 <span class="me-sub">— 닥터스 EMR 에서 내려받은 엑셀을 올립니다</span></div>
  <span class="me-hosp">🏥 <c:out value='${hospNm}'/></span>
  <span class="me-spacer"></span>
  <label style="font-size:13px;color:#43555f;">대상 연월 <select id="meYm" onchange="meLoad();"></select></label>
</div>

<div class="me-note">
  EMR 에서 자료를 <b>엑셀로 내려받아</b> 아래에 끌어 놓거나 [엑셀 파일 고르기]를 누르세요. 양식이 병원마다 달라 <b>엑셀 머리글과 항목을 한 번 맞춰 주면</b>(자동 추천 → 틀린 것만 고침) 다음 달부터는 기억한 맞춤으로 바로 올라갑니다.
  같은 달을 다시 올리면 <b>그 달 자료를 통째로 바꿉니다</b>(연락처는 올릴 때마다 최신본으로 바꿈). 합계·소계·빈 줄은 저절로 뺍니다.
</div>

<div class="me-cards" id="meCards"></div>

<div class="me-card">
  <h4><span id="meTabTitle">—</span> <span class="small" id="meTabDesc"></span><span class="sp"></span>
    <input type="file" id="meFile" accept=".xls,.xlsx,.csv,.htm,.html" style="display:none" onchange="meFilePick(this.files);">
    <button type="button" class="me-btn pri" onclick="document.getElementById('meFile').click();">📂 엑셀 파일 고르기</button></h4>
  <div class="drop" id="meDrop">엑셀 파일(.xls · .xlsx · .csv)을 여기에 끌어 놓으세요 — <span id="meDropHint"></span></div>

  <div id="meMapBox" style="display:none;margin-top:12px;">
    <div class="bar">
      <b id="meFileNm"></b>
      <label>시트 <select id="meSheet" onchange="meSheetChg();"></select></label>
      <label>머리글 줄 <input type="number" id="meHdr" min="1" max="50" style="width:64px" onchange="meHdrChg();"></label>
      <span class="small" id="meHdrNote"></span>
      <span class="me-spacer" style="flex:1"></span>
      <button type="button" class="me-btn" onclick="meMapAuto();" title="기억한 맞춤을 무시하고 머리글 이름으로 다시 추천합니다">자동 추천 다시</button>
      <button type="button" class="me-btn" onclick="meMapSaveOnly();" title="올리지 않고 맞춤만 기억합니다">맞춤만 기억</button>
    </div>
    <div class="grid2">
      <div>
        <div class="small" style="margin-bottom:4px;">① 항목 ↔ 엑셀 머리글 맞추기 <span id="meReqNote"></span></div>
        <div class="wrap" style="max-height:460px;"><table id="meMapTbl"></table></div>
      </div>
      <div>
        <div class="small" style="margin-bottom:4px;">② 미리보기 (앞 30줄) <span id="meCnt"></span></div>
        <div class="wrap" style="max-height:460px;"><table id="mePrev"></table></div>
        <div style="display:flex;gap:8px;justify-content:flex-end;margin-top:10px;align-items:center;flex-wrap:wrap;">
          <span class="small" id="meSaveNote"></span>
          <button type="button" class="me-btn" onclick="meCancel();">취소</button>
          <button type="button" class="me-btn pri" id="meSaveBtn" onclick="meSave();">저장</button>
        </div>
      </div>
    </div>
  </div>
</div>

<div class="grid2">
  <div class="me-card">
    <h4>올린 자료 요약 <span class="small" id="meSumLbl"></span><span class="sp"></span>
      <button type="button" class="me-btn" id="meRowsBtn" onclick="meRows();">올린 줄 보기</button></h4>
    <div id="meSum"><div class="empty">불러오는 중…</div></div>
  </div>
  <div class="me-card">
    <h4>올린 이력 <span class="small">(최근 60건)</span></h4>
    <div class="wrap" style="max-height:300px;"><table id="meHist"></table></div>
  </div>
</div>
<div class="me-card" id="meRowsCard" style="display:none;">
  <h4>올린 줄 <span class="small" id="meRowsLbl"></span><span class="sp"></span>
    <button type="button" class="me-btn" onclick="meRowsXls();">엑셀출력</button>
    <button type="button" class="me-btn" onclick="document.getElementById('meRowsCard').style.display='none';">닫기</button></h4>
  <div class="wrap" style="max-height:520px;"><table id="meRowsTbl"></table></div>
</div>

<script>
(function(){
  function gel(id){ return document.getElementById(id); }
  function esc(s){ return (s==null?'':String(s)).replace(/[&<>"]/g, function(c){ return ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;'})[c]; }); }
  function chk(res){ if (res && res.result === 'FAIL') { throw new Error(res.message || '처리에 실패했습니다.'); } return res; }
  function post(url, data){ return $.ajax({ url:url, type:'POST', data:data, dataType:'json' }).then(chk); }
  function postJson(url, obj){ return $.ajax({ url:url, type:'POST', contentType:'application/json; charset=UTF-8', data:JSON.stringify(obj), dataType:'json' }).then(chk); }
  function err(e){ _alertBox((e && e.message) ? e.message : (e && e.responseText ? '서버 오류가 발생했습니다.' : '처리 중 오류가 발생했습니다.'), {icon:'❌'}); }
  var root = gel('misEmr'), WNN = root.getAttribute('data-wnn') === 'Y';
  function hospCd(){
    try { if (WNN && typeof getCookie === 'function') { var h = (getCookie('s_hospid') || '').trim(); if (h) return h; } } catch(e){}
    return root.getAttribute('data-hosp');
  }
  function userId(){ try { return (typeof getCookie === 'function' ? (getCookie('s_userid') || '') : '').trim(); } catch(e){ return ''; } }
  function withHosp(p){ if (WNN) p.hospCd = hospCd(); return p; }
  function num(v){ return Number(v||0).toLocaleString('ko-KR'); }
  function eok(v){ v = Number(v||0); return Math.abs(v) >= 100000000 ? (v/100000000).toFixed(2) + '억' : (Math.abs(v) >= 10000 ? (v/10000).toFixed(0) + '만' : num(v)); }
  function ymLbl(ym){ return ym ? (ym.slice(0,4) + '년 ' + Number(ym.slice(4,6)) + '월') : ''; }
  function addYm(ym, n){ var y = Number(ym.slice(0,4)), m = Number(ym.slice(4,6)) - 1 + n; y += Math.floor(m/12); m = ((m%12)+12)%12; return y + String(m+1).padStart(2,'0'); }
  function d8Lbl(s){ s = String(s||''); return s.length === 8 ? s.slice(0,4) + '-' + s.slice(4,6) + '-' + s.slice(6,8) : s; }

  /* ── 자료 다섯 가지 — 필드(k 키 · l 이름 · t 형식 · kw 머리글 후보) ──
     t : text 글자 · date 날짜 · amt 금액(정수) · num 숫자 · birth 생년월일/주민 · raw 그대로(입퇴원 주민번호)
     req : 「묶음 중 하나는 맞춰야 한다」 목록 */
  var KW_CHART = ['차트번호','챠트번호','차트No','환자번호','환자ID','등록번호','Chart','차번'];
  var KW_NAME  = ['환자명','수진자명','환자이름','성명','이름','환자성명','수진자'];
  var KW_BIRTH = ['생년월일','주민번호','주민등록번호','생일'];
  var KW_IO    = ['입원/외래','입/외','입외','외래/입원','진료구분','입원구분','입원외래'];
  var KW_DEPT  = ['진료과','진료과목','진료과명','과'];
  var TYPES = {
    PAY: { nm:'수납대장', icon:'💳', perMonth:true, desc:'수납·진료비 내역 — 환자별 총진료비·본인부담·비급여·수납·미수',
      req:[['chartno','patNm'],['totAmt','paidAmt','selfAmt','nonpayAmt']],
      f:[ {k:'payDt',l:'수납일',t:'date',kw:['수납일','수납일자','수납일시','영수일','영수일자','진료일','진료일자','일자','날짜']},
          {k:'chartno',l:'차트번호',t:'text',kw:KW_CHART}, {k:'patNm',l:'환자명',t:'text',kw:KW_NAME},
          {k:'birth6',l:'생년월일(주민번호 앞)',t:'birth',kw:KW_BIRTH}, {k:'inoutGb',l:'입원/외래',t:'text',kw:KW_IO},
          {k:'insurNm',l:'보험유형',t:'text',kw:['보험유형','환자유형','보험구분','보험','자격','보종','유형']},
          {k:'deptNm',l:'진료과',t:'text',kw:KW_DEPT},
          {k:'totAmt',l:'총진료비',t:'amt',kw:['총진료비','진료비총액','진료비합계','진료비','총액','총금액']},
          {k:'insAmt',l:'공단부담',t:'amt',kw:['공단부담금','공단부담','보험자부담','청구액','조합부담','공단']},
          {k:'selfAmt',l:'본인부담(급여)',t:'amt',kw:['본인부담금','본인부담액','본인부담','환자부담금','환자부담','급여본인부담']},
          {k:'nonpayAmt',l:'비급여',t:'amt',kw:['비급여금액','비급여액','비급여총액','비급여']},
          {k:'paidAmt',l:'수납액',t:'amt',kw:['수납금액','수납액','받은금액','입금액','영수액','납부액','수납']},
          {k:'unpaidAmt',l:'미수액',t:'amt',kw:['미수금','미수액','미수','미납액','미납']},
          {k:'payMethod',l:'수납방법',t:'text',kw:['수납방법','결제방법','결제수단','수납구분','카드/현금']},
          {k:'memo',l:'비고',t:'text',kw:['비고','메모']} ] },
    ACT: { nm:'행위별 통계', icon:'📊', perMonth:true, desc:'행위 분류(진찰료·입원료·투약·처치·검사…)별 횟수·금액 — 무엇으로 진료비가 나오는지',
      req:[['actGb'],['actCnt','totAmt']],
      f:[ {k:'actGb',l:'행위 분류',t:'text',kw:['행위분류','처방분류','진료항목','행위구분','대분류','중분류','분류','항목명','항목','행위','구분','항']},
          {k:'payGb',l:'급여구분',t:'text',kw:['급여구분','급여/비급여','급/비','보험구분','급여']},
          {k:'inoutGb',l:'입원/외래',t:'text',kw:KW_IO}, {k:'deptNm',l:'진료과',t:'text',kw:KW_DEPT},
          {k:'unitPrice',l:'단가',t:'amt',kw:['단가','수가금액']},
          {k:'actCnt',l:'횟수(수량)',t:'num',kw:['실시횟수','처방횟수','횟수','건수','총량','총투여량','사용량','수량']},
          {k:'patCnt',l:'환자 수',t:'num',kw:['실인원','환자수','인원수','환자건수','인원']},
          {k:'totAmt',l:'금액',t:'amt',kw:['총금액','합계금액','금액','진료비','총액','합계']},
          {k:'insAmt',l:'공단부담',t:'amt',kw:['공단부담금','공단부담','청구액','보험자부담']},
          {k:'selfAmt',l:'본인부담',t:'amt',kw:['본인부담금','본인부담액','본인부담']},
          {k:'memo',l:'비고',t:'text',kw:['비고','메모']} ] },
    CUT: { nm:'삭감 내역', icon:'✂', perMonth:true, desc:'종별 › 지급처별 삭감·불능·조정(환자별 아님) — 대상 연월 = 진료(청구) 연월. 그 달 청구 샘파일과 종별·지급처로 맞춰 감액률을 봅니다',
      req:[['cutAmt'],['jongNm','assCd','assNm','claimNo']],
      f:[ {k:'claimNo',l:'청구번호(접수번호)',t:'text',kw:['청구번호','접수번호']},
          {k:'jongNm',l:'종별',t:'text',kw:['보험자종별','보험종별','청구종별','보험구분','보험유형','종별','서식']},
          {k:'assCd',l:'지급처 코드',t:'text',kw:['지급처코드','보장기관기호','보장기관코드','지급기관코드','보험자코드','기관기호','기관코드']},
          {k:'assNm',l:'지급처명',t:'text',kw:['지급처명','보장기관명','지급기관명','보험자명','보험사','지급처','기관명']},
          {k:'cutGb',l:'구분(삭감·불능·조정)',t:'text',kw:['삭감구분','조정구분','감액구분','처리구분','결정구분','구분']},
          {k:'inoutGb',l:'입원/외래',t:'text',kw:KW_IO},
          {k:'resultDt',l:'심결 통보일',t:'date',kw:['심결통보일','심사결과통보일','결과통보일','통보일자','통보일','심사일자','결정일자']},
          {k:'cutRsnCd',l:'조정 사유 코드',t:'text',kw:['조정사유코드','삭감사유코드','사유코드','조정코드']},
          {k:'cutRsn',l:'조정(삭감) 사유',t:'text',kw:['조정사유','삭감사유','조정내역','사유']},
          {k:'claimAmt',l:'청구액',t:'amt',kw:['청구금액','청구액']},
          {k:'cutAmt',l:'삭감액',t:'amt',kw:['조정금액','삭감금액','조정액','삭감액','감액']},
          {k:'objGb',l:'이의신청',t:'text',kw:['이의신청여부','이의신청결과','이의신청','이의']},
          {k:'memo',l:'비고',t:'text',kw:['비고','메모']} ] },
    IPWON: { nm:'입퇴원현황', icon:'🛏', perMonth:true, desc:'입원현황 업로드와 같은 자리(입퇴원현황)에 저장 — 적정성평가·자동 매칭이 이 자료를 봅니다',
      req:[['patname'],['ipwondt'],['juminno']],
      f:[ {k:'chartno',l:'차트번호',t:'text',kw:KW_CHART}, {k:'patname',l:'수진자명',t:'text',kw:KW_NAME},
          {k:'juminno',l:'주민번호',t:'raw',kw:['주민등록번호','주민번호','생년월일']},
          {k:'ipwondt',l:'입원일',t:'date',kw:['입원일자','입원일','입원날짜','최초입원일','실입원일','Admission']},
          {k:'ipwontm',l:'입원시간',t:'text',kw:['입원시간']},
          {k:'tewondt',l:'퇴원일',t:'date',kw:['퇴원일자','퇴원일','퇴원날짜','실퇴원일','Discharge']},
          {k:'tewontm',l:'퇴원시간',t:'text',kw:['퇴원시간']},
          {k:'docname',l:'의사',t:'text',kw:['주치의','진료의','의사성명','의사명','의사']},
          {k:'dept_nm',l:'진료과',t:'text',kw:KW_DEPT},
          {k:'insurnm',l:'환자유형',t:'text',kw:['환자유형','보험유형','보험','자격','보종','유형']},
          {k:'word_nm',l:'병동',t:'text',kw:['병동']}, {k:'room_nm',l:'병실',t:'text',kw:['병실','호실']} ] },
    CONTACT: { nm:'환자·보호자 연락처', icon:'📞', perMonth:false, desc:'올릴 때마다 최신본으로 바꿈 — 신규환자 고객관리의 퇴원 안부 연락에 보호자 연락처로 붙습니다',
      req:[['chartno','patNm']],
      f:[ {k:'chartno',l:'차트번호',t:'text',kw:KW_CHART}, {k:'patNm',l:'환자명',t:'text',kw:KW_NAME},
          {k:'birth6',l:'생년월일(주민번호 앞)',t:'birth',kw:KW_BIRTH},
          {k:'gender',l:'성별',t:'text',kw:['성별','남/여','성']},
          {k:'tel',l:'환자 연락처',t:'text',kw:['환자연락처','환자전화','휴대폰','핸드폰','휴대전화','전화번호','연락처']},
          {k:'guardNm',l:'보호자',t:'text',kw:['보호자성명','보호자명','보호자']},
          {k:'guardRel',l:'보호자 관계',t:'text',kw:['보호자관계','관계']},
          {k:'guardTel',l:'보호자 연락처',t:'text',kw:['보호자연락처','보호자전화','보호자휴대폰','보호자핸드폰','보호자전화번호']},
          {k:'addr',l:'주소',t:'text',kw:['주소','거주지']}, {k:'memo',l:'비고',t:'text',kw:['비고','메모']} ] },
    STAFF: { nm:'직원·근무', icon:'👥', perMonth:true, desc:'직원 명단과 그 달 근무 — 직종별 인원·근무일·야간·인건비',
      req:[['empNo','empNm']],
      f:[ {k:'empNo',l:'사번',t:'text',kw:['사원번호','직원번호','사원코드','사번']},
          {k:'empNm',l:'성명',t:'text',kw:['직원명','사원명','성명','이름']},
          {k:'jobNm',l:'직종',t:'text',kw:['직종','직군','직렬','직위','직책','면허']},
          {k:'deptNm',l:'부서',t:'text',kw:['근무부서','부서','소속','병동']},
          {k:'workGb',l:'근무 형태',t:'text',kw:['근무형태','고용형태','근무구분','고용구분','계약구분']},
          {k:'joinDt',l:'입사일',t:'date',kw:['입사일자','입사일','채용일']},
          {k:'retireDt',l:'퇴사일',t:'date',kw:['퇴사일자','퇴사일','퇴직일']},
          {k:'workDays',l:'근무일수',t:'num',kw:['근무일수','출근일수','근무일']},
          {k:'workHours',l:'근무시간',t:'num',kw:['총근무시간','근무시간','근로시간']},
          {k:'nightCnt',l:'야간 근무',t:'num',kw:['야간횟수','야간근무','나이트','야간']},
          {k:'payAmt',l:'급여(인건비)',t:'amt',kw:['총지급액','지급총액','급여총액','지급액','인건비','급여']},
          {k:'memo',l:'비고',t:'text',kw:['비고','메모']} ] }
  };
  var ORDER = ['PAY','ACT','CUT','IPWON','CONTACT','STAFF'];
  var TAB = 'PAY';
  try { var t0 = localStorage.getItem('misEmrTab'); if (TYPES[t0]) TAB = t0; } catch(e){}
  var PAGE = null;            // emrGet 응답
  var X = null;               // 읽은 엑셀 { name, wb, sheet, aoa, hdr(0부터), cols[{i,name}] }
  var MAP = {}, MAPSRC = {};  // 필드키 → 머리글 이름 / 'mem' 기억 · 'auto' 자동

  (function(){
    var now = new Date(), cur = now.getFullYear() + String(now.getMonth()+1).padStart(2,'0'), s = gel('meYm');
    for (var i = 0; i < 30; i++) { var ym = addYm(cur, -i); s.add(new Option(ymLbl(ym), ym)); }
    s.value = addYm(cur, -1);
  })();

  /* ═══ 화면 자료 ═══ */
  window.meLoad = function(){
    post('<c:url value="/mis/emrGet.do"/>', withHosp({ ym: gel('meYm').value })).then(function(res){
      PAGE = res; renderCards(); renderTab(); renderSum(); renderHist();
      if (X) { applySaved(false); renderMap(); }
    }).catch(function(e){ gel('meSum').innerHTML = '<div class="empty">' + esc((e && e.message) || '불러오지 못했습니다.') + '</div>'; });
  };
  function sumOf(list, k){ var s = 0; (list||[]).forEach(function(r){ s += Number(r[k]||0); }); return s; }
  /* 삭감률 = 삭감액 ÷ 청구액. 분모 = 그 달 청구 샘파일 명세서 청구액(sam). 샘파일이 없으면 삭감 줄에 적힌 청구액(그 항목들 것뿐이라 높게 나온다). 둘 다 없으면 null */
  function cutRateBase(){
    var c = Number((PAGE && PAGE.sam || {}).claimamt || 0); if (c > 0) return { amt:c, src:'sam' };
    var k = sumOf(PAGE && PAGE.cut, 'claimamt'); if (k > 0) return { amt:k, src:'cut' };
    return null;
  }
  /* 삭감 ↔ 샘파일 — 종별 › 지급처 단위(SWCHMISU 와 같은 결). 서버가 볼 때마다 센다 : CLAIM 청구번호 → ASS 종별+지급처 → JONG 종별 → '' 미매칭 */
  var MATCH_LBL = { CLAIM:'청구번호', ASS:'종별+지급처', JONG:'종별', '':'미매칭' };
  var JONG_LBL = { HB:'건강보험', BH:'의료급여', BO:'보훈', JB:'자동차보험', SJ:'산재', '?':'매칭 안 됨' };
  function jongLbl(j){ j = j || ''; return JONG_LBL[j] || (j ? '종별 ' + j.replace(/^T/, '') : '—'); }
  function matchLbl(g){ g = g || ''; return '<span class="badge ' + (g === 'CLAIM' ? 'ok' : (g === '' ? 'bad' : 'mem')) + '">' + (MATCH_LBL[g] || g) + '</span>'; }
  function assLbl(r){ if (r.jong === '?') return '<span class="small">종별·지급처를 못 찾은 삭감</span>';
    if (!r.ass) return r.jong === 'HB' ? '공단' : '<span class="small">(지급처 없음)</span>';
    return esc(r.ass) + (r.assnm ? ' <span class="small">' + esc(r.assnm) + '</span>' : ''); }
  function rateTd(cut, base){ return '<td class="n">' + (base > 0 ? (cut / base * 100).toFixed(2) + '%' : '—') + '</td>'; }
  /* 종별 › 지급처 표 — 종별마다 소계 줄, 그 아래 지급처 줄(지급처가 하나뿐이고 빈 값이면 소계만) */
  function groupHtml(){
    var sam = PAGE.sam || {}, gs = PAGE.cutGroup || [];
    if (!Number(sam.cnt || 0) && !gs.length) return '';
    var byJ = {}, order = [];
    gs.forEach(function(r){ if (!byJ[r.jong]) { byJ[r.jong] = []; order.push(r.jong); } byJ[r.jong].push(r); });
    var rows = [], T = { samcnt:0, samclaim:0, cutd:0, cutn:0, cuta:0 };
    order.forEach(function(j){
      var list = byJ[j], s = { samcnt:0, samclaim:0, cutd:0, cutn:0, cuta:0 };
      list.forEach(function(r){ for (var k in s) s[k] += Number(r[k] || 0); });
      for (var k in T) T[k] += s[k];
      var cutAll = s.cutd + s.cutn + s.cuta, unm = j === '?';
      rows.push('<tr class="sum"' + (unm ? ' style="color:#b23b3b"' : '') + '><td>' + esc(jongLbl(j)) + (list.length > 1 ? ' <span class="small">지급처 ' + list.length + '</span>' : '') + '</td>'
        + '<td class="n">' + (unm ? '—' : num(s.samcnt)) + '</td><td class="n">' + (unm ? '—' : num(s.samclaim)) + '</td>'
        + '<td class="n">' + num(s.cutd) + '</td><td class="n">' + num(s.cutn) + '</td><td class="n">' + num(s.cuta) + '</td><td class="n">' + num(cutAll) + '</td>' + (unm ? '<td class="n">—</td>' : rateTd(cutAll, s.samclaim)) + '</tr>');
      if (unm || (list.length === 1 && !list[0].ass)) return;
      list.forEach(function(r){
        var c = Number(r.cutd||0) + Number(r.cutn||0) + Number(r.cuta||0);
        rows.push('<tr><td style="padding-left:22px">' + assLbl(r) + '</td><td class="n">' + num(r.samcnt) + '</td><td class="n">' + num(r.samclaim) + '</td>'
          + '<td class="n">' + num(r.cutd) + '</td><td class="n">' + num(r.cutn) + '</td><td class="n">' + num(r.cuta) + '</td><td class="n">' + num(c) + '</td>' + rateTd(c, Number(r.samclaim||0)) + '</tr>');
      });
    });
    var all = T.cutd + T.cutn + T.cuta;
    rows.push('<tr class="sum"><td>합계</td><td class="n">' + num(T.samcnt) + '</td><td class="n">' + num(T.samclaim) + '</td><td class="n">' + num(T.cutd) + '</td><td class="n">' + num(T.cutn) + '</td><td class="n">' + num(T.cuta) + '</td><td class="n">' + num(all) + '</td>' + rateTd(all, T.samclaim) + '</tr>');
    return '<div class="small" style="margin:10px 0 4px;font-weight:700;color:#43555f;">종별 › 지급처 — 청구 샘파일(' + ymLbl(PAGE.ym) + ') 과 대조</div>'
      + (Number(sam.cnt || 0) ? '' : '<div class="bar"><span class="badge warn">' + ymLbl(PAGE.ym) + ' 청구 샘파일이 없습니다</span><span class="small">샘파일을 올리면 종별·지급처별 청구액과 맞춰 봅니다.</span></div>')
      + tbl([{l:'종별 › 지급처'},{l:'명세서',n:1},{l:'청구액',n:1},{l:'삭감',n:1},{l:'불능',n:1},{l:'조정',n:1},{l:'감액 계',n:1},{l:'감액률',n:1}], rows)
      + '<div class="small" style="margin-top:4px;">지급처 = 명세서 보장기관기호(의료급여는 시군구, 건강보험은 공단 한 곳). 구분 글자가 「불능」이면 불능, 「조정·환수·공제」면 조정, 그 밖(빈 칸 포함)은 삭감으로 셉니다.</div>';
  }
  function cutRate(){ var b = cutRateBase(); return b ? sumOf(PAGE.cut, 'cutamt') / b.amt * 100 : null; }
  function cardTxt(gb){
    if (!PAGE) return '…';
    if (gb === 'PAY') { var p = PAGE.pay || []; if (!p.length) return '<span class="badge warn">이 달 없음</span>';
      return num(sumOf(p,'cnt')) + '줄 · 총진료비 ' + eok(sumOf(p,'totamt')) + '<br>수납 ' + eok(sumOf(p,'paidamt')) + ' · 미수 ' + eok(sumOf(p,'unpaidamt')); }
    if (gb === 'ACT') { var a = PAGE.act || []; if (!a.length) return '<span class="badge warn">이 달 없음</span>';
      return '분류 ' + a.length + '가지 · 금액 ' + eok(sumOf(a,'totamt')) + '<br>횟수 ' + num(sumOf(a,'actcnt')); }
    if (gb === 'CUT') { var k = PAGE.cut || []; if (!k.length) return '<span class="badge warn">이 달 없음</span>';
      var cr = cutRate(), um = (PAGE.cutGroup || []).filter(function(r){ return r.jong === '?'; })[0];
      return num(sumOf(k,'cnt')) + '줄 · 감액 ' + eok(sumOf(k,'cutamt')) + (cr == null ? '' : '<br>감액률 ' + cr.toFixed(2) + '%') + (um ? ' <span class="badge bad">미매칭 ' + num(um.cutcnt) + '</span>' : ''); }
    if (gb === 'IPWON') { var w = PAGE.ipwon || {}; if (!Number(w.cnt||0)) return '<span class="badge warn">이 달 없음</span>';
      return num(w.cnt) + '줄 · 입원 ' + num(w.incnt) + ' · 퇴원 ' + num(w.outcnt) + (Number(w.nojumin||0) ? '<br><span class="badge bad">주민번호 없음 ' + num(w.nojumin) + '</span>' : ''); }
    if (gb === 'CONTACT') { var c = PAGE.contact || {}; if (!Number(c.cnt||0)) return '<span class="badge warn">올린 적 없음</span>';
      return num(c.cnt) + '명 · 보호자 연락처 ' + num(c.guardcnt) + '<br><span class="small">최신 ' + esc(c.regdttm || '') + '</span>'; }
    if (gb === 'STAFF') { var s = PAGE.staff || []; if (!s.length) return '<span class="badge warn">이 달 없음</span>';
      return num(sumOf(s,'cnt')) + '명 · 직종 ' + s.length + '가지<br>인건비 ' + eok(sumOf(s,'payamt')); }
    return '';
  }
  function renderCards(){
    gel('meCards').innerHTML = ORDER.map(function(gb){
      var T = TYPES[gb];
      return '<div class="me-cardx' + (gb === TAB ? ' on' : '') + '" onclick="meTab(\'' + gb + '\')"><div class="l">' + T.icon + ' ' + esc(T.nm) + '</div><div class="v">' + cardTxt(gb) + '</div></div>';
    }).join('');
  }
  window.meTab = function(gb){
    if (!TYPES[gb] || gb === TAB) return;
    if (X) { _confirmBox({ msg:'읽어 둔 엑셀(' + X.name + ')을 닫고 「' + TYPES[gb].nm + '」(으)로 바꿉니다.', icon:'❓', okText:'바꾸기', onOk:function(){ meCancel(); go(); } }); return; }
    go();
    function go(){ TAB = gb; try { localStorage.setItem('misEmrTab', gb); } catch(e){} gel('meRowsCard').style.display = 'none'; renderCards(); renderTab(); renderSum(); renderHist(); }
  };
  function renderTab(){
    var T = TYPES[TAB];
    gel('meTabTitle').textContent = T.icon + ' ' + T.nm + ' 올리기';
    gel('meTabDesc').textContent = '— ' + T.desc;
    gel('meDropHint').textContent = T.perMonth ? (ymLbl(gel('meYm').value) + ' 자료로 들어갑니다(같은 달은 바뀜)') : '병원 전체 최신본으로 바뀝니다';
    gel('meRowsBtn').style.display = TAB === 'IPWON' ? 'none' : '';
  }
  function tbl(head, rows){ return '<table><thead><tr>' + head.map(function(h){ return '<th' + (h.n ? ' class="n"' : '') + '>' + esc(h.l) + '</th>'; }).join('') + '</tr></thead><tbody>' + rows.join('') + '</tbody></table>'; }
  function renderSum(){
    if (!PAGE) return;
    var T = TYPES[TAB], h = '';
    gel('meSumLbl').textContent = T.perMonth ? ('— ' + ymLbl(PAGE.ym)) : '— 최신본';
    if (TAB === 'PAY') {
      var p = PAGE.pay || [];
      if (!p.length) h = '<div class="empty">' + ymLbl(PAGE.ym) + ' 수납대장을 아직 올리지 않았습니다.</div>';
      else { var rr = p.map(function(r){ return '<tr><td>' + esc(r.inoutgb) + '</td><td class="n">' + num(r.cnt) + '</td><td class="n">' + num(r.pats) + '</td><td class="n">' + num(r.totamt) + '</td><td class="n">' + num(r.selfamt) + '</td><td class="n">' + num(r.nonpayamt) + '</td><td class="n">' + num(r.paidamt) + '</td><td class="n">' + num(r.unpaidamt) + '</td></tr>'; });
        rr.push('<tr class="sum"><td>합계</td><td class="n">' + num(sumOf(p,'cnt')) + '</td><td class="n">—</td><td class="n">' + num(sumOf(p,'totamt')) + '</td><td class="n">' + num(sumOf(p,'selfamt')) + '</td><td class="n">' + num(sumOf(p,'nonpayamt')) + '</td><td class="n">' + num(sumOf(p,'paidamt')) + '</td><td class="n">' + num(sumOf(p,'unpaidamt')) + '</td></tr>');
        h = tbl([{l:'구분'},{l:'줄',n:1},{l:'환자',n:1},{l:'총진료비',n:1},{l:'본인부담',n:1},{l:'비급여',n:1},{l:'수납',n:1},{l:'미수',n:1}], rr)
          + '<div class="small" style="margin-top:6px;">비급여·수납·미수는 청구 샘파일에 없는 숫자입니다. 고정경비 화면의 「추가수익」에 비급여 합계를 적으면 추정 손익에 들어갑니다.</div>'; }
    } else if (TAB === 'ACT') {
      var a = PAGE.act || [];
      if (!a.length) h = '<div class="empty">' + ymLbl(PAGE.ym) + ' 행위별 통계를 아직 올리지 않았습니다.</div>';
      else { var tot = sumOf(a,'totamt');
        var r1 = a.map(function(r){ var pct = tot ? (Number(r.totamt||0) / tot * 100) : 0;
          return '<tr><td>' + esc(r.actgb) + (Number(r.items) > 1 ? ' <span class="small" title="입원·외래·급여구분 등으로 나뉜 줄을 합쳤습니다">(' + num(r.items) + '줄)</span>' : '') + '</td><td class="n">' + num(r.actcnt) + '</td><td class="n">' + num(r.totamt) + '</td><td class="n">' + num(r.insamt) + '</td><td class="n">' + num(r.selfamt) + '</td><td class="n">' + pct.toFixed(1) + '%</td></tr>'; });
        r1.push('<tr class="sum"><td>합계</td><td class="n">' + num(sumOf(a,'actcnt')) + '</td><td class="n">' + num(tot) + '</td><td class="n">' + num(sumOf(a,'insamt')) + '</td><td class="n">' + num(sumOf(a,'selfamt')) + '</td><td class="n">100%</td></tr>');
        h = tbl([{l:'행위 분류'},{l:'횟수',n:1},{l:'금액',n:1},{l:'공단',n:1},{l:'본인부담',n:1},{l:'비중',n:1}], r1); }
    } else if (TAB === 'CUT') {
      var k = PAGE.cut || [];
      if (!k.length) h = '<div class="empty">' + ymLbl(PAGE.ym) + ' 삭감 내역을 아직 올리지 않았습니다.</div>' + groupHtml();
      else { var ct = sumOf(k,'cutamt'), base = cutRateBase();
        var rk = k.map(function(r){ var pct = ct ? (Number(r.cutamt||0) / ct * 100) : 0;
          return '<tr><td>' + esc(r.cutrsn) + (r.cutrsncd && r.cutrsncd !== r.cutrsn ? ' <span class="small">' + esc(r.cutrsncd) + '</span>' : '') + '</td><td class="n">' + num(r.cnt) + '</td><td class="n">' + num(r.cutamt) + '</td><td class="n">' + pct.toFixed(1) + '%</td></tr>'; });
        rk.push('<tr class="sum"><td>합계</td><td class="n">' + num(sumOf(k,'cnt')) + '</td><td class="n">' + num(ct) + '</td><td class="n">100%</td></tr>');
        var unm = (PAGE.cutGroup || []).filter(function(r){ return r.jong === '?'; })[0];
        h = '<div class="bar"><b>감액률 ' + (base ? (ct / base.amt * 100).toFixed(2) + '%' : '—') + '</b><span class="small">'
          + (base ? '= 감액(삭감·불능·조정) ' + num(ct) + ' ÷ ' + (base.src === 'sam' ? '그 달 청구 샘파일 청구액 ' : '삭감 줄에 적힌 청구액 ') + num(base.amt) + (base.src === 'cut' ? ' — 그 달 청구 샘파일을 올리면 전체 청구액으로 다시 셉니다' : '') : '그 달 청구 샘파일(또는 삭감 줄의 청구액)이 없어 감액률을 못 셉니다') + '</span></div>'
          + (unm ? '<div class="small" style="color:#b23b3b;margin-bottom:6px;">매칭 안 된 삭감 ' + num(unm.cutcnt) + '줄 — 진료 연월이 다르거나 종별·지급처 코드·청구번호 칸이 맞춰지지 않았을 수 있습니다. [올린 줄 보기]에서 줄마다 확인하세요.</div>' : '')
          + groupHtml()
          + '<div class="small" style="margin:10px 0 4px;font-weight:700;color:#43555f;">조정(삭감) 사유별</div>'
          + tbl([{l:'조정(삭감) 사유'},{l:'줄',n:1},{l:'감액',n:1},{l:'비중',n:1}], rk); }
    } else if (TAB === 'IPWON') {
      var w = PAGE.ipwon || {};
      h = !Number(w.cnt||0) ? '<div class="empty">' + ymLbl(PAGE.ym) + ' 입퇴원현황이 없습니다.</div>'
        : tbl([{l:'줄',n:1},{l:'그 달 입원',n:1},{l:'그 달 퇴원',n:1},{l:'주민번호 없음',n:1}], ['<tr><td class="n">' + num(w.cnt) + '</td><td class="n">' + num(w.incnt) + '</td><td class="n">' + num(w.outcnt) + '</td><td class="n">' + num(w.nojumin) + '</td></tr>'])
          + '<div class="small" style="margin-top:6px;">마감자료관리의 입원현황 업로드와 같은 자료입니다 — 어느 쪽에서 올려도 그 달 입퇴원현황이 바뀝니다. 줄 보기는 입원현황 화면에서.</div>';
    } else if (TAB === 'CONTACT') {
      var c = PAGE.contact || {};
      h = !Number(c.cnt||0) ? '<div class="empty">연락처를 아직 올리지 않았습니다.</div>'
        : tbl([{l:'환자',n:1},{l:'환자 연락처',n:1},{l:'보호자 연락처',n:1},{l:'생년월일 있음',n:1},{l:'올린 때'}], ['<tr><td class="n">' + num(c.cnt) + '</td><td class="n">' + num(c.telcnt) + '</td><td class="n">' + num(c.guardcnt) + '</td><td class="n">' + num(c.birthcnt) + '</td><td>' + esc(c.regdttm || '') + '</td></tr>'])
          + '<div class="small" style="margin-top:6px;">신규환자 고객관리 › 퇴원 안부 연락 목록에 생년월일+이름이 맞는 환자의 보호자 연락처가 붙습니다(생년월일이 없는 줄은 붙지 않습니다).</div>';
    } else if (TAB === 'STAFF') {
      var s = PAGE.staff || [];
      if (!s.length) h = '<div class="empty">' + ymLbl(PAGE.ym) + ' 직원·근무 자료를 아직 올리지 않았습니다.</div>';
      else { var rs = s.map(function(r){ return '<tr><td>' + esc(r.jobnm) + '</td><td class="n">' + num(r.cnt) + '</td><td class="n">' + num(r.retired) + '</td><td class="n">' + num(r.workdays) + '</td><td class="n">' + num(r.nightcnt) + '</td><td class="n">' + num(r.payamt) + '</td></tr>'; });
        rs.push('<tr class="sum"><td>합계</td><td class="n">' + num(sumOf(s,'cnt')) + '</td><td class="n">' + num(sumOf(s,'retired')) + '</td><td class="n">' + num(sumOf(s,'workdays')) + '</td><td class="n">' + num(sumOf(s,'nightcnt')) + '</td><td class="n">' + num(sumOf(s,'payamt')) + '</td></tr>');
        h = tbl([{l:'직종'},{l:'인원',n:1},{l:'그 전 달 이전 퇴사',n:1},{l:'근무일',n:1},{l:'야간',n:1},{l:'인건비',n:1}], rs); }
    }
    gel('meSum').innerHTML = h;
  }
  function renderHist(){
    if (!PAGE) return;
    var list = (PAGE.uploads || []).filter(function(r){ return r.datagb === TAB; });
    gel('meHist').innerHTML = !list.length ? '<tbody><tr><td class="empty">이 자료를 올린 이력이 없습니다.</td></tr></tbody>'
      : '<thead><tr><th>올린 때</th><th>연월</th><th>파일</th><th class="n">저장</th><th class="n">뺀 줄</th><th class="n">바뀐 옛 줄</th><th>사람</th></tr></thead><tbody>'
        + list.map(function(r){ return '<tr><td>' + esc(r.regdttm) + '</td><td>' + (r.ym ? ymLbl(r.ym) : '최신본') + '</td><td class="samp" title="' + esc(r.filenm) + '">' + esc(r.filenm) + '</td><td class="n">' + num(r.rowcnt) + '</td><td class="n">' + num(r.skipcnt) + '</td><td class="n">' + num(r.delcnt) + '</td><td>' + esc(r.reguser || '') + '</td></tr>'; }).join('') + '</tbody>';
  }

  /* ═══ 엑셀 읽기 ═══ */
  function needXlsx(cb, n){
    if (window.XLSX && XLSX.read) return cb();
    if ((n||0) > 50) { _alertBox('엑셀 읽기 도구를 불러오지 못했습니다 — 새로고침 뒤 다시 해 주세요.', {icon:'❌'}); return; }
    setTimeout(function(){ needXlsx(cb, (n||0) + 1); }, 100);
  }
  var drop = gel('meDrop');
  ['dragenter','dragover'].forEach(function(ev){ drop.addEventListener(ev, function(e){ e.preventDefault(); drop.classList.add('over'); }); });
  ['dragleave','drop'].forEach(function(ev){ drop.addEventListener(ev, function(e){ e.preventDefault(); drop.classList.remove('over'); }); });
  drop.addEventListener('drop', function(e){ if (e.dataTransfer && e.dataTransfer.files) meFilePick(e.dataTransfer.files); });

  window.meFilePick = function(files){
    var f = files && files[0];
    gel('meFile').value = '';
    if (!f) return;
    needXlsx(function(){
      var rd = new FileReader();
      rd.onload = function(ev){
        try {
          var wb = XLSX.read(new Uint8Array(ev.target.result), { type:'array', cellDates:true });
          if (!wb.SheetNames.length) throw new Error('시트가 없습니다.');
          X = { name:f.name, wb:wb };
          var s = gel('meSheet'); s.innerHTML = '';
          wb.SheetNames.forEach(function(n){ s.add(new Option(n, n)); });
          // 줄이 가장 많은 시트를 먼저
          var best = wb.SheetNames[0], bc = -1;
          wb.SheetNames.forEach(function(n){ var ws = wb.Sheets[n], r = ws && ws['!ref'] ? XLSX.utils.decode_range(ws['!ref']) : null, c = r ? (r.e.r - r.s.r) : 0; if (c > bc) { bc = c; best = n; } });
          s.value = best;
          gel('meFileNm').textContent = '📄 ' + f.name;
          loadSheet(true);
          gel('meMapBox').style.display = '';
        } catch(e2){ X = null; _alertBox('엑셀을 읽지 못했습니다 — ' + (e2.message || e2), {icon:'❌'}); }
      };
      rd.onerror = function(){ _alertBox('파일을 읽지 못했습니다.', {icon:'❌'}); };
      rd.readAsArrayBuffer(f);
    });
  };
  window.meSheetChg = function(){ loadSheet(true); };
  window.meHdrChg = function(){ var v = Number(gel('meHdr').value); if (!X || !(v >= 1)) return; X.hdr = Math.min(v - 1, Math.max(0, X.aoa.length - 1)); buildCols(); applySaved(true); renderMap(); };
  function norm(s){ return String(s == null ? '' : s).toLowerCase().replace(/[\s_\-\/().·:]/g, ''); }
  function loadSheet(autoHdr){
    var ws = X.wb.Sheets[gel('meSheet').value];
    X.aoa = XLSX.utils.sheet_to_json(ws, { header:1, raw:true, defval:'', blankrows:false });
    var saved = savedMap();
    X.hdr = 0;
    if (saved && saved.hdrrow && Number(saved.hdrrow) >= 1 && Number(saved.hdrrow) <= X.aoa.length) X.hdr = Number(saved.hdrrow) - 1;
    else if (autoHdr) X.hdr = guessHdr();
    buildCols(); applySaved(true); renderMap();
  }
  /* 머리글 줄 찾기 — 앞 20줄 중 이 자료의 머리글 후보와 맞는 칸이 가장 많은 줄(동점이면 먼저). 다 0 이면 글자 칸이 가장 많은 줄 */
  function guessHdr(){
    var T = TYPES[TAB], kws = [];
    T.f.forEach(function(f){ f.kw.forEach(function(k){ kws.push(norm(k)); }); });
    var best = 0, bs = -1, best2 = 0, bs2 = -1;
    for (var r = 0; r < Math.min(20, X.aoa.length); r++) {
      var row = X.aoa[r] || [], sc = 0, tx = 0;
      row.forEach(function(v){ if (typeof v !== 'string' || !v.trim()) return; tx++; var n = norm(v); if (kws.some(function(k){ return k.length >= 2 && (n === k || n.indexOf(k) >= 0); })) sc++; });
      if (sc > bs) { bs = sc; best = r; }
      if (tx > bs2) { bs2 = tx; best2 = r; }
    }
    return bs > 0 ? best : best2;
  }
  function colLetter(i){ var s = ''; i++; while (i > 0) { var m = (i - 1) % 26; s = String.fromCharCode(65 + m) + s; i = Math.floor((i - 1) / 26); } return s; }
  function buildCols(){
    var row = X.aoa[X.hdr] || [], width = 0, seen = {};
    for (var r = X.hdr; r < Math.min(X.aoa.length, X.hdr + 200); r++) width = Math.max(width, (X.aoa[r] || []).length);
    X.cols = [];
    for (var i = 0; i < width; i++) {
      var nm = String(row[i] == null ? '' : (isDate(row[i]) ? fmtDate(row[i], '-') : row[i])).replace(/\s+/g, ' ').trim();
      if (!nm) nm = '(' + colLetter(i) + '열)';
      if (seen[nm]) { seen[nm]++; nm = nm + '(' + seen[nm] + ')'; } else seen[nm] = 1;
      X.cols.push({ i:i, name:nm });
    }
    gel('meHdr').value = X.hdr + 1;
    gel('meHdrNote').textContent = '자료 ' + Math.max(0, X.aoa.length - X.hdr - 1) + '줄 · 칸 ' + X.cols.length + '개';
  }
  function colIdx(name){ for (var i = 0; i < X.cols.length; i++) if (X.cols[i].name === name) return X.cols[i].i; return -1; }

  /* ═══ 맞춤 ═══ */
  function savedMap(){
    var m = (PAGE && PAGE.maps || []).filter(function(r){ return r.datagb === TAB; })[0];
    if (!m) return null;
    try { return { map: JSON.parse(m.mapjson || '{}'), hdrrow: m.hdrrow, upd: m.upddttm }; } catch(e){ return null; }
  }
  function applySaved(useSaved){
    var T = TYPES[TAB], used = {};
    MAP = {}; MAPSRC = {};
    var sv = useSaved ? savedMap() : null;
    if (sv) T.f.forEach(function(f){ var c = sv.map[f.k]; if (c && colIdx(c) >= 0 && !used[c]) { MAP[f.k] = c; MAPSRC[f.k] = 'mem'; used[c] = 1; } });
    // 정확히 같은 이름 먼저(필드 차례대로)
    T.f.forEach(function(f){
      if (MAP[f.k]) return;
      for (var j = 0; j < f.kw.length; j++) { var k = norm(f.kw[j]);
        for (var i = 0; i < X.cols.length; i++) { var c = X.cols[i]; if (!used[c.name] && norm(c.name) === k) { MAP[f.k] = c.name; MAPSRC[f.k] = 'auto'; used[c.name] = 1; return; } } }
    });
    // 그다음 「들어 있음」 — 긴 후보 낱말부터(「보호자연락처」가 「연락처」보다 먼저 자리 잡게)
    var cand = [];
    T.f.forEach(function(f){ if (MAP[f.k]) return; f.kw.forEach(function(kw){ var k = norm(kw); if (k.length < 2) return;
      X.cols.forEach(function(c){ if (!used[c.name] && norm(c.name).indexOf(k) >= 0) cand.push({ f:f.k, c:c.name, l:k.length, cl:norm(c.name).length }); }); }); });
    cand.sort(function(a, b){ return (b.l - a.l) || (a.cl - b.cl); });
    cand.forEach(function(x){ if (!MAP[x.f] && !used[x.c]) { MAP[x.f] = x.c; MAPSRC[x.f] = 'auto'; used[x.c] = 1; } });
  }
  window.meMapAuto = function(){ if (!X) return; applySaved(false); renderMap(); };
  window.meMapChg = function(sel){ var k = sel.getAttribute('data-k'); if (sel.value) { MAP[k] = sel.value; MAPSRC[k] = ''; } else { delete MAP[k]; delete MAPSRC[k]; } renderMap(); };
  function sample(name){
    var ci = colIdx(name), out = [];
    if (ci < 0) return '';
    for (var r = X.hdr + 1; r < X.aoa.length && out.length < 3; r++) { var v = (X.aoa[r] || [])[ci]; if (v === '' || v == null) continue; out.push(isDate(v) ? fmtDate(v, '-') : String(v)); }
    return out.join(' · ');
  }
  function reqMissing(){
    var T = TYPES[TAB], miss = [];
    T.req.forEach(function(g){ if (!g.some(function(k){ return !!MAP[k]; })) miss.push(g.map(function(k){ return fieldOf(k).l; }).join(' 또는 ')); });
    return miss;
  }
  function fieldOf(k){ return TYPES[TAB].f.filter(function(f){ return f.k === k; })[0]; }
  function isReq(k){ return TYPES[TAB].req.some(function(g){ return g.indexOf(k) >= 0; }); }
  function renderMap(){
    if (!X) return;
    var T = TYPES[TAB], usedBy = {};
    Object.keys(MAP).forEach(function(k){ usedBy[MAP[k]] = k; });
    var opts = function(k){ return '<option value="">— 없음 —</option>' + X.cols.map(function(c){ var by = usedBy[c.name]; return '<option value="' + esc(c.name) + '"' + (MAP[k] === c.name ? ' selected' : '') + '>' + esc(c.name) + (by && by !== k ? ' (' + esc(fieldOf(by).l) + ' 에 씀)' : '') + '</option>'; }).join(''); };
    gel('meMapTbl').innerHTML = '<thead><tr><th>항목</th><th>엑셀 머리글</th><th></th><th>엑셀 값 예</th></tr></thead><tbody>'
      + T.f.map(function(f){
        var src = MAPSRC[f.k] === 'mem' ? '<span class="badge mem" title="지난번에 맞춘 대로">기억</span>' : (MAPSRC[f.k] === 'auto' ? '<span class="badge ok" title="머리글 이름으로 추천">추천</span>' : '');
        return '<tr><td>' + (isReq(f.k) ? '<span class="req">*</span> ' : '') + esc(f.l) + '</td><td><select data-k="' + f.k + '" onchange="meMapChg(this)" style="max-width:220px">' + opts(f.k) + '</select></td><td>' + src + '</td><td class="samp" title="' + esc(MAP[f.k] ? sample(MAP[f.k]) : '') + '">' + esc(MAP[f.k] ? sample(MAP[f.k]) : '') + '</td></tr>';
      }).join('') + '</tbody>';
    var miss = reqMissing();
    gel('meReqNote').innerHTML = miss.length ? '<span class="badge bad">맞춰야 함 : ' + esc(miss.join(' / ')) + '</span>' : '<span class="badge ok">필수 항목 맞춤 완료</span>';
    renderPrev();
  }

  /* ═══ 값 바꾸기 ═══ */
  function isDate(v){ return Object.prototype.toString.call(v) === '[object Date]'; }
  function fmtDate(d, sep){ return d.getFullYear() + sep + String(d.getMonth()+1).padStart(2,'0') + sep + String(d.getDate()).padStart(2,'0'); }
  function toDate8(v){
    if (v === '' || v == null) return '';
    if (isDate(v) && !isNaN(v.getTime())) return fmtDate(v, '');
    if (typeof v === 'number') { if (v > 20000 && v < 80000) { var d = new Date(Math.round((v - 25569) * 86400000)); return d.getUTCFullYear() + String(d.getUTCMonth()+1).padStart(2,'0') + String(d.getUTCDate()).padStart(2,'0'); } v = String(v); }
    var s = String(v).trim().split(/[\sT]/)[0], m;
    if ((m = s.match(/^(\d{4})[-./년]\s*(\d{1,2})[-./월]\s*(\d{1,2})/))) return m[1] + m[2].padStart(2,'0') + m[3].padStart(2,'0');
    if ((m = s.match(/^(\d{4})(\d{2})(\d{2})$/))) return s;
    if ((m = s.match(/^(\d{2})[-./](\d{1,2})[-./](\d{1,2})$/))) return '20' + m[1] + m[2].padStart(2,'0') + m[3].padStart(2,'0');
    if ((m = s.match(/^(\d{1,2})\/(\d{1,2})\/(\d{2,4})$/))) { var y = m[3].length === 2 ? ((Number(m[3]) < 50 ? '20' : '19') + m[3]) : m[3]; return y + m[1].padStart(2,'0') + m[2].padStart(2,'0'); }
    return '';
  }
  function toAmt(v){
    if (v === '' || v == null) return '';
    if (typeof v === 'number') return isFinite(v) ? v : '';
    var s = String(v).trim(), neg = /^\(.*\)$/.test(s) || /^[-−]/.test(s);
    s = s.replace(/[^0-9.]/g, '');
    if (!s || isNaN(Number(s))) return '';
    return neg ? -Number(s) : Number(s);
  }
  function conv(f, v){
    if (f.t === 'date') { var d = toDate8(v); return TAB === 'IPWON' ? (d ? d.slice(0,4) + '-' + d.slice(4,6) + '-' + d.slice(6,8) : '') : d; }
    if (f.t === 'amt' || f.t === 'num') return toAmt(v);
    if (f.t === 'birth') { if (isDate(v)) return fmtDate(v, '-'); if (typeof v === 'number') { var s = String(Math.round(v)); return s.length === 5 ? '0' + s : s; } return String(v == null ? '' : v).trim(); }
    if (isDate(v)) return fmtDate(v, '-');
    return String(v == null ? '' : v).trim();
  }
  var SUM_RX = /^\[?\s*(합\s*계|소\s*계|총\s*계|누\s*계|total|subtotal)\s*\]?\s*$/i, SUM_RX2 = /(합\s*계|소\s*계|총\s*계)\s*\]?\s*$/, LBL_RX = /^(인원|건수|총진료일|총\s*인원|합\s*계|소\s*계|총\s*계|총합|총계)\s*[:：]/;
  function skipWhy(row){
    var ne = 0;
    for (var i = 0; i < row.length; i++) { var v = row[i]; if (v === '' || v == null) continue; ne++;
      if (typeof v === 'string') { var t = v.trim(); if (SUM_RX.test(t) || LBL_RX.test(t) || (t.length <= 20 && SUM_RX2.test(t))) return '합계'; } }
    return ne ? '' : '빈 줄';
  }
  /* 읽은 엑셀 → 저장할 줄. keyMiss = 필수 묶음(첫 번째)이 비어 빠지는 줄 */
  function buildRows(){
    var T = TYPES[TAB], out = [], skip = 0, keyMiss = 0, idx = {};
    T.f.forEach(function(f){ if (MAP[f.k]) idx[f.k] = colIdx(MAP[f.k]); });
    var key0 = T.req[0];
    for (var r = X.hdr + 1; r < X.aoa.length; r++) {
      var row = X.aoa[r] || [];
      if (skipWhy(row)) { skip++; continue; }
      var o = {};
      T.f.forEach(function(f){ if (idx[f.k] != null && idx[f.k] >= 0) o[f.k] = conv(f, row[idx[f.k]]); });
      if (!key0.some(function(k){ return o[k] !== '' && o[k] != null; })) { keyMiss++; continue; }
      o._r = r + 1;
      out.push(o);
    }
    return { rows:out, skip:skip, keyMiss:keyMiss };
  }
  function renderPrev(){
    var T = TYPES[TAB], b = buildRows(), fs = T.f.filter(function(f){ return MAP[f.k]; });
    X.built = b;
    gel('meCnt').innerHTML = '저장할 줄 <b>' + num(b.rows.length) + '</b> · 합계·빈 줄 ' + num(b.skip) + (b.keyMiss ? ' · <span class="badge warn">' + esc(T.req[0].map(function(k){ return fieldOf(k).l; }).join('·')) + ' 없음 ' + num(b.keyMiss) + '</span>' : '');
    gel('mePrev').innerHTML = !fs.length ? '<tbody><tr><td class="empty">왼쪽에서 항목을 맞추면 여기에 보입니다.</td></tr></tbody>'
      : '<thead><tr><th class="n">엑셀 줄</th>' + fs.map(function(f){ return '<th' + (f.t === 'amt' || f.t === 'num' ? ' class="n"' : '') + '>' + esc(f.l) + '</th>'; }).join('') + '</tr></thead><tbody>'
        + b.rows.slice(0, 30).map(function(o){ return '<tr><td class="n small">' + o._r + '</td>' + fs.map(function(f){ var v = o[f.k];
            if (f.t === 'amt' || f.t === 'num') return '<td class="n">' + (v === '' ? '<span class="small">—</span>' : num(v)) + '</td>';
            if (f.t === 'date' && TAB !== 'IPWON') return '<td>' + (v ? d8Lbl(v) : (MAP[f.k] ? '<span class="badge warn">날짜?</span>' : '')) + '</td>';
            return '<td>' + esc(v) + '</td>'; }).join('') + '</tr>'; }).join('') + '</tbody>';
    var miss = reqMissing(), dis = !!miss.length || !b.rows.length;
    gel('meSaveBtn').disabled = dis;
    gel('meSaveBtn').textContent = T.perMonth ? (ymLbl(gel('meYm').value) + ' 로 저장') : '최신본으로 저장';
    gel('meSaveNote').textContent = miss.length ? '필수 항목을 맞춰 주세요' : (!b.rows.length ? '저장할 줄이 없습니다' : '');
  }
  window.meCancel = function(){ X = null; MAP = {}; MAPSRC = {}; gel('meMapBox').style.display = 'none'; gel('meMapTbl').innerHTML = ''; gel('mePrev').innerHTML = ''; };

  function mapPayload(){ var m = {}; Object.keys(MAP).forEach(function(k){ m[k] = MAP[k]; }); return m; }
  window.meMapSaveOnly = function(){
    if (!X) return;
    postJson('<c:url value="/mis/emrMapSave.do"/>', withHosp({ dataGb:TAB, map:mapPayload(), hdrRow:X.hdr + 1 }))
      .then(function(){ _toast('맞춤을 기억했습니다 — 다음에 같은 양식을 올리면 그대로 맞춰집니다.', 'success'); meLoad(); }).catch(err);
  };

  /* ═══ 저장 ═══ */
  function oldCnt(){
    if (!PAGE) return 0;
    if (TAB === 'PAY') return sumOf(PAGE.pay, 'cnt');
    if (TAB === 'ACT') return sumOf(PAGE.act, 'items');   // items = 그 달 저장된 줄 수(분류별 합)
    if (TAB === 'CUT') return sumOf(PAGE.cut, 'cnt');
    if (TAB === 'STAFF') return sumOf(PAGE.staff, 'cnt');
    if (TAB === 'CONTACT') return Number((PAGE.contact || {}).cnt || 0);
    if (TAB === 'IPWON') return Number((PAGE.ipwon || {}).cnt || 0);
    return 0;
  }
  window.meSave = function(){
    if (!X || !X.built) return;
    var T = TYPES[TAB], b = X.built, ym = gel('meYm').value, old = oldCnt();
    if (reqMissing().length || !b.rows.length) return;
    var badDate = 0;
    T.f.forEach(function(f){ if (f.t === 'date' && MAP[f.k]) b.rows.forEach(function(o){ if (!o[f.k]) badDate++; }); });
    var msg = '<b>' + esc(T.nm) + '</b> ' + num(b.rows.length) + '줄을 ' + (T.perMonth ? ('<b>' + ymLbl(ym) + '</b> 자료로') : '<b>최신본</b>으로') + ' 저장합니다.'
      + (old ? '<br>이미 올린 ' + (T.perMonth ? '같은 달 ' : '') + '자료 ' + num(old) + '줄은 지우고 바꿉니다.' : '')
      + (b.skip ? '<br><span style="color:#6b7c86">합계·빈 줄 ' + num(b.skip) + '줄은 뺍니다.</span>' : '')
      + (b.keyMiss ? '<br><span style="color:#b45f1c">' + esc(T.req[0].map(function(k){ return fieldOf(k).l; }).join('·')) + ' 이(가) 빈 ' + num(b.keyMiss) + '줄은 뺍니다.</span>' : '')
      + (badDate ? '<br><span style="color:#b45f1c">날짜를 못 읽은 칸 ' + num(badDate) + '개는 비워 둡니다.</span>' : '');
    if (TAB === 'IPWON') {
      var noJ = b.rows.filter(function(o){ return !String(o.juminno || '').trim(); }).length;
      if (noJ) msg += '<br><span style="color:#b23b3b">주민번호가 없는 ' + num(noJ) + '줄은 적정성평가·자동 매칭에서 환자를 못 찾습니다.</span>';
    }
    _confirmBox({ msg:msg, icon:'💾', okText:'저장', onOk:function(){ TAB === 'IPWON' ? saveIpwon(b, ym) : saveMis(b, ym); } });
  };
  function strip(o){ var r = {}; Object.keys(o).forEach(function(k){ if (k !== '_r') r[k] = o[k]; }); return r; }
  function busy(on){ var bt = gel('meSaveBtn'); bt.disabled = on; if (on) bt.textContent = '저장 중…'; }
  function saveMis(b, ym){
    busy(true);
    postJson('<c:url value="/mis/emrSave.do"/>', withHosp({ dataGb:TAB, ym:ym, fileNm:X.name, skipCnt:b.skip + b.keyMiss, rows:b.rows.map(strip), map:mapPayload(), hdrRow:X.hdr + 1 }))
      .then(function(res){
        _alertBox(TYPES[TAB].nm + ' ' + num(res.saved) + '줄을 저장했습니다.' + (res.deleted ? ' (옛 자료 ' + num(res.deleted) + '줄은 바뀜)' : ''), {icon:'✅'});
        meCancel(); meLoad();
      }).catch(function(e){ busy(false); renderPrev(); err(e); });
  }
  /* 입퇴원 = 기존 입원현황 업로드 길(/main/saveExcelDatas.do) — 줄 모양도 그 화면(saveIpwonWithMapping)과 같게 */
  function saveIpwon(b, ym){
    busy(true);
    var now = new Date(), p2 = function(n){ return String(n).padStart(2,'0'); };
    var jobdt = now.getFullYear() + p2(now.getMonth()+1) + p2(now.getDate()) + p2(now.getHours()) + p2(now.getMinutes()) + p2(now.getSeconds());
    var hc = hospCd(), uid = userId();
    var datas = b.rows.map(function(o, i){
      var d = { hosp_cd:hc, jobyymm:ym, seq_num:i + 1, file_nm:X.name, jobs_dt:jobdt, reg_user:uid };
      TYPES.IPWON.f.forEach(function(f){ if (MAP[f.k]) d[f.k] = o[f.k] == null ? '' : String(o[f.k]); });
      return d;
    });
    $.ajax({ url:'/main/saveExcelDatas.do', type:'POST', contentType:'application/json', data:JSON.stringify(datas), dataType:'json' }).then(function(res){
      if (!res || String(res.error_code) !== '0') throw new Error((res && res.error_mess) || '입퇴원현황 저장에 실패했습니다.');
      return postJson('<c:url value="/mis/emrIpwonLog.do"/>', withHosp({ ym:ym, fileNm:X.name, rowCnt:datas.length, skipCnt:b.skip + b.keyMiss, map:mapPayload(), hdrRow:X.hdr + 1 }))
        .catch(function(){ /* 이력·맞춤 기억 실패는 저장 결과와 무관 */ });
    }).then(function(){
      _alertBox('입퇴원현황 ' + num(datas.length) + '줄을 ' + ymLbl(ym) + ' 자료로 저장했습니다.', {icon:'✅'});
      meCancel(); meLoad();
    }).catch(function(e){ busy(false); renderPrev(); err(e); });
  }

  /* ═══ 올린 줄 보기 ═══ */
  var ROWCOLS = {
    PAY: [['paydt','수납일','d'],['chartno','차트번호'],['patnm','환자명'],['birth6','생년월일'],['inoutgb','입원/외래'],['insurnm','보험'],['deptnm','진료과'],['totamt','총진료비','n'],['insamt','공단','n'],['selfamt','본인부담','n'],['nonpayamt','비급여','n'],['paidamt','수납','n'],['unpaidamt','미수','n'],['paymethod','수납방법'],['memo','비고']],
    ACT: [['actgb','행위 분류'],['paygb','급여구분'],['inoutgb','입원/외래'],['deptnm','진료과'],['unitprice','단가','n'],['actcnt','횟수','n'],['patcnt','환자 수','n'],['totamt','금액','n'],['insamt','공단','n'],['selfamt','본인부담','n'],['memo','비고']],
    CUT: [['claimno','청구번호'],['jongnm','종별(엑셀)'],['cjong','종별(판정)','j'],['asscd','지급처 코드'],['assnm','지급처명'],['cutgb','구분'],['inoutgb','입원/외래'],['resultdt','통보일','d'],['cutrsncd','사유 코드'],['cutrsn','사유'],['claimamt','청구액','n'],['cutamt','삭감액','n'],['objgb','이의신청'],['matchgb','샘파일 매칭','m'],['samclaimamt','샘파일 청구액','n'],['memo','비고']],
    CONTACT: [['chartno','차트번호'],['patnm','환자명'],['birth6','생년월일'],['gender','성별'],['tel','환자 연락처'],['guardnm','보호자'],['guardrel','관계'],['guardtel','보호자 연락처'],['addr','주소'],['memo','비고']],
    STAFF: [['empno','사번'],['empnm','성명'],['jobnm','직종'],['deptnm','부서'],['workgb','근무 형태'],['joindt','입사일','d'],['retiredt','퇴사일','d'],['workdays','근무일','n'],['workhours','근무시간','n'],['nightcnt','야간','n'],['payamt','급여','n'],['memo','비고']]
  };
  window.meRows = function(){
    if (!ROWCOLS[TAB]) return;
    var ym = gel('meYm').value, cols = ROWCOLS[TAB];
    post('<c:url value="/mis/emrRows.do"/>', withHosp({ dataGb:TAB, ym:ym })).then(function(res){
      var list = res.list || [];
      gel('meRowsLbl').textContent = '— ' + TYPES[TAB].nm + (TYPES[TAB].perMonth ? ' · ' + ymLbl(ym) : ' · 최신본') + ' · ' + num(list.length) + '줄' + (list.length >= 3000 ? ' (앞 3,000줄만)' : '');
      gel('meRowsTbl').innerHTML = !list.length ? '<tbody><tr><td class="empty">올린 줄이 없습니다.</td></tr></tbody>'
        : '<thead><tr><th class="n">No</th>' + cols.map(function(c){ return '<th' + (c[2] === 'n' ? ' class="n"' : '') + '>' + esc(c[1]) + '</th>'; }).join('') + '</tr></thead><tbody>'
          + list.map(function(r, i){ return '<tr><td class="n small">' + (i+1) + '</td>' + cols.map(function(c){ var v = r[c[0]];
              if (c[2] === 'm') return '<td>' + matchLbl(v) + '</td>';
              if (c[2] === 'j') return '<td>' + esc(jongLbl(v)) + '</td>';
              return c[2] === 'n' ? '<td class="n">' + (v == null ? '' : num(v)) + '</td>' : '<td>' + esc(c[2] === 'd' ? d8Lbl(v) : (v == null ? '' : v)) + '</td>'; }).join('') + '</tr>'; }).join('') + '</tbody>';
      gel('meRowsCard').style.display = '';
      gel('meRowsCard').scrollIntoView({ behavior:'smooth', block:'start' });
    }).catch(err);
  };
  window.meRowsXls = function(){
    needXlsx(function(){
      var wb = XLSX.utils.book_new();
      XLSX.utils.book_append_sheet(wb, XLSX.utils.table_to_sheet(gel('meRowsTbl'), { raw:false }), TYPES[TAB].nm.replace(/[\\\/?*\[\]:]/g, ''));
      XLSX.writeFile(wb, 'EMR_' + TYPES[TAB].nm.replace(/[^가-힣A-Za-z0-9]/g, '') + '_' + (TYPES[TAB].perMonth ? gel('meYm').value : '최신본') + '.xlsx');
    });
  };

  renderTab();
  meLoad();
})();
</script>
</div>
</div>
