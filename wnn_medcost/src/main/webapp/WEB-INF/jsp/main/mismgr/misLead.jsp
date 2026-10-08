<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%-- misLead.jsp — 경영관리(MIS) › 신규환자 고객관리 (2026-10-08, 제안서 ④)
     · 상담(전화·방문) → 방문 → 입원 결정 → 입원 → 퇴원 후 단계 관리판. 카드 클릭 = 상세·이력·단계 이동.
     · 입원·퇴원은 입퇴원현황으로 **자동 확인**(생년월일 6 + 이름) — 관리판을 열 때마다 서버가 대조한다(leadList).
     · 유입 경로별 상담·입원 전환(이번 달 / 최근 3달) · 퇴원 환자 안부 연락 목록(최근 60일 퇴원, 연락 결과 기록).
     · 알림은 ui-message. 입력칸이 있는 창(상담 접수·종결 사유)은 화면 안 패널로 둔다(_confirmBox 엔 입력칸이 없다).
     · ★주의: 이 파일 안에서 Deferred EL 표기(샵+중괄호) 금지 --%>

<script src="/asset/js/ui-message.js"></script>
<script src="/asset/js/mis-split.js"></script>

<div class="dashboard-wrapper">
<div id="misLead" data-wnn="<c:out value='${wnnYn}'/>" data-hosp="<c:out value='${hospCd}'/>" data-nm="<c:out value='${hospNm}'/>">
<style>
  #misLead{ background:#f4f6f8; color:#1f2a30; min-height:100%; padding:14px 16px 50px; max-width:100%; overflow-x:hidden; }
  #misLead *{ box-sizing:border-box; }
  #misLead .ml-head{ display:flex; align-items:center; gap:10px; margin-bottom:12px; flex-wrap:wrap; }
  #misLead .ml-title{ font-size:18px; font-weight:800; color:#20303a; display:flex; align-items:center; gap:8px; }
  #misLead .ml-dot{ width:10px; height:10px; border-radius:50%; background:linear-gradient(135deg,#1f5a4b,#2a7665); }
  #misLead .ml-sub{ font-size:12px; color:#6b7c86; font-weight:400; }
  #misLead .ml-hosp{ background:#e7f3ee; color:#1f5a4b; font-size:12px; font-weight:800; border:1px solid #cfe3da; border-radius:14px; padding:3px 11px; }
  #misLead .ml-spacer{ flex:1; }
  #misLead select, #misLead input, #misLead textarea{ border:1px solid #cfd8e0; border-radius:6px; padding:5px 8px; font-size:13px; background:#fff; font-family:inherit; }
  #misLead textarea{ width:100%; min-height:56px; resize:vertical; }
  #misLead .ml-btn{ border:1px solid #cfd9e0; background:#fff; color:#43555f; border-radius:6px; padding:5px 11px; font-size:12.5px; font-weight:700; cursor:pointer; white-space:nowrap; }
  #misLead .ml-btn:hover{ background:#eef3f6; }
  #misLead .ml-btn.pri{ background:#1f5a4b; color:#fff; border-color:#1f5a4b; }
  #misLead .ml-btn.pri:hover{ background:#2a7665; }
  #misLead .ml-btn.del{ color:#b23b3b; }
  #misLead .ml-btn.sm{ padding:2px 8px; font-size:12px; }
  #misLead .ml-note{ background:#fff; border:1px solid #e3e9ed; border-radius:10px; padding:10px 14px; font-size:12.5px; color:#43555f; margin-bottom:12px; line-height:1.6; }
  #misLead .ml-card{ background:#fff; border:1px solid #e3e9ed; border-radius:10px; padding:12px 14px; min-width:0; }
  #misLead .ml-card h4{ margin:0 0 10px; font-size:13px; color:#43555f; font-weight:700; display:flex; gap:8px; align-items:center; flex-wrap:wrap; }
  #misLead .ml-card h4 .sp{ flex:1; }
  /* 관리판 */
  #misLead .pipe{ display:grid; grid-template-columns:repeat(5,1fr); gap:8px; }
  @media (max-width:1100px){ #misLead .pipe{ grid-template-columns:repeat(2,1fr); } }
  #misLead .col{ border:1px solid #e3e9ed; border-radius:8px; padding:8px; min-width:0; background:#f7f9fa; min-height:160px; }
  #misLead .col .h{ display:flex; justify-content:space-between; font-size:13px; font-weight:700; margin-bottom:6px; color:#20303a; }
  #misLead .col{ cursor:pointer; }                                       /* 빈 곳 클릭 = 그 단계로 접수 */
  #misLead .col .addhint{ color:#8a99a3; font-size:12px; text-align:center; padding:10px 4px 4px; border:1px dashed transparent; border-radius:6px; }
  #misLead .col:hover .addhint{ color:#1f5a4b; border-color:#cfe3da; background:#fff; }
  #misLead .col .h span{ background:#fff; border:1px solid #dde5ea; border-radius:999px; padding:0 7px; font-variant-numeric:tabular-nums; }
  #misLead .pcard{ background:#fff; border:1px solid #e3e9ed; border-radius:6px; padding:7px 9px; font-size:12.5px; margin-top:6px; line-height:1.45; cursor:pointer; }
  #misLead .pcard:hover{ border-color:#1f5a4b; }
  #misLead .pcard.sel{ border:2px solid #1f5a4b; }
  #misLead .pcard b{ display:block; font-size:13px; color:#20303a; }
  #misLead .pcard .r{ color:#6b7c86; display:block; }
  #misLead .pcard .auto{ color:#1f5a4b; font-weight:700; display:block; }
  #misLead .pcard .due{ color:#b23b3b; font-weight:700; display:block; }
  #misLead .pcard .due.ok{ color:#b45f1c; }
  /* 상세 패널 */
  #misLead .ml-grid{ display:grid; grid-template-columns:1fr 1fr; gap:12px; margin-top:12px; }
  @media (max-width:1000px){ #misLead .ml-grid{ grid-template-columns:1fr; } }
  #misLead .ml-grid > *{ min-width:0; }
  #misLead .frm{ display:grid; grid-template-columns:90px 1fr 90px 1fr; gap:6px 8px; align-items:center; font-size:13px; }
  @media (max-width:700px){ #misLead .frm{ grid-template-columns:90px 1fr; } }
  #misLead .frm label{ color:#43555f; font-weight:700; font-size:12.5px; }
  #misLead .frm .full{ grid-column:2 / -1; }
  #misLead .frm input, #misLead .frm select{ width:100%; }
  #misLead .stages{ display:flex; gap:6px; flex-wrap:wrap; margin-top:8px; }
  #misLead .logs{ font-size:12.5px; margin-top:8px; max-height:220px; overflow:auto; border-top:1px dashed #dde5ea; padding-top:6px; }
  #misLead .logs div{ padding:3px 0; border-bottom:1px solid #f1f4f6; }
  #misLead .logs .d{ color:#6b7c86; margin-right:6px; font-variant-numeric:tabular-nums; }
  #misLead .badge{ font-size:11px; font-weight:700; border-radius:10px; padding:1px 7px; background:#eef2f5; color:#43555f; }
  #misLead .badge.ok{ background:#e7f3ee; color:#1f5a4b; }
  #misLead #mlDetailTtl{ font-size:16px; color:#20303a; }                       /* 상세 제목 조금 크게(사용자 2026-10-08 「조금 크게」) */
  #misLead #mlDetailTtl .badge{ font-size:12.5px; padding:2px 10px; }
  #misLead .badge.warn{ background:#fbeadb; color:#b45f1c; }
  #misLead table{ width:100%; border-collapse:collapse; font-size:13px; }
  #misLead th{ background:#f2f6f8; font-weight:700; color:#43555f; padding:7px 9px; border-bottom:1px solid #dde5ea; text-align:left; white-space:nowrap; }
  #misLead td{ padding:6px 9px; border-bottom:1px solid #eef2f5; vertical-align:middle; }
  #misLead td.n, #misLead th.n{ text-align:right; font-variant-numeric:tabular-nums; }
  #misLead .ml-wrap{ overflow-x:auto; }
  #misLead .ml-follow{ max-height:420px; overflow:auto; }                       /* 퇴원 목록이 길어 페이지가 늘어나던 것 → 안에서 스크롤(2026-10-08 사용자) */
  #misLead .ml-follow thead th{ position:sticky; top:0; z-index:1; }
  #misLead #mlFollow th, #misLead #mlFollow td{ white-space:nowrap; }   /* 퇴원일·연락함이 두 줄로 접히던 것(2026-10-08) — 메모 칸이 남는 폭을 쓰고, 좁으면 가로 스크롤 */
  #misLead #mlFollow td.memo{ width:100%; }
  #misLead .ml-grid2{ grid-template-columns:0.8fr 1.2fr; }              /* 유입 경로 표(왼쪽)는 좁게, 안부 연락(오른쪽)은 넓게(사용자 「좌측도 조금 축소」) */
  #misLead .ml-empty{ color:#8a99a3; font-size:13px; padding:18px; text-align:center; }
  #misLead .small{ font-size:12px; color:#6b7c86; }
  #misLead tr.done td{ color:#8a99a3; }
</style>

<div class="ml-head">
  <div class="ml-title"><span class="ml-dot"></span>신규환자 고객관리 <span class="ml-sub">— 상담에서 입원까지, 입원 여부는 입퇴원현황으로 자동 확인</span></div>
  <span class="ml-hosp">🏥 <c:out value='${hospNm}'/></span>
  <span class="ml-spacer"></span>
  <button type="button" class="ml-btn" onclick="mlExcel();" title="상담 목록(종결 포함)과 퇴원 안부 연락 표를 엑셀 파일로">엑셀출력</button>
  <button type="button" class="ml-btn" onclick="mlLoad();" title="상담 목록을 다시 읽고 입퇴원현황과 다시 대조합니다 — 다른 창에서 입퇴원현황을 올린 뒤 누르세요">입퇴원현황 다시 대조</button>
</div>

<div class="ml-note">
  전화·방문 상담을 받으면 관리판의 <b>「상담」 칸을 눌러</b> 이름·생년월일·보호자·경로를 적습니다(1분). 이미 입원한 환자를 뒤늦게 적을 때는 「입원」 칸을 누르면 그 단계로 바로 저장됩니다. 단계는 카드를 눌러 옮기고, <b>입원·퇴원은 입퇴원현황이 올라오면 자동으로</b> 표시됩니다(생년월일 6자리와 이름으로 맞춥니다 — 생년월일을 적어야 자동 확인이 됩니다).
  주민번호 전체는 받지 않습니다.
</div>

<div class="ml-card">
  <h4>상담 ~ 입원 관리판 <span class="small" id="mlCnt"></span><span class="sp"></span><span class="small">카드를 누르면 아래에 상세가 열립니다</span></h4>
  <div class="pipe" id="mlPipe"><div class="ml-empty">불러오는 중…</div></div>
  <div class="small" style="margin-top:8px;" id="mlClosed"></div>
</div>

<div class="ml-grid" data-split="lead.main" data-vsplit="lead.top">
  <div class="ml-card" id="mlDetail" style="display:none;">
    <h4 id="mlDetailTtl">상담 상세</h4>
    <div class="frm">
      <label>환자 이름 *</label><input type="text" id="lfNm" maxlength="50">
      <label>생년월일 6</label><input type="text" id="lfBirth" maxlength="6" placeholder="YYMMDD">
      <label>성별</label><select id="lfGender"><option value="">—</option><option value="M">남</option><option value="F">여</option></select>
      <label>상담일</label><input type="date" id="lfContact">
      <label>보호자</label><input type="text" id="lfGuard" maxlength="50" placeholder="이름">
      <label>관계</label><input type="text" id="lfRel" maxlength="20" placeholder="아들·딸·배우자">
      <label>연락처</label><input type="text" id="lfTel" maxlength="30">
      <label>유입 경로</label><select id="lfChannel"><option value="INTRO">지인·환자 소개</option><option value="TRANS">타 병원 전원</option><option value="WEB">인터넷 검색</option><option value="ADS">광고·현수막</option><option value="ETC">기타</option></select>
      <label>상태·요구</label><div class="full"><textarea id="lfCond" maxlength="300" placeholder="예) 뇌졸중 재활, 보행 불편, 2인실 희망"></textarea></div>
      <label>다음 할 일</label><input type="date" id="lfNextDt">
      <label>내용</label><input type="text" id="lfNextMemo" maxlength="200" placeholder="예) 방문 약속 잡기 · 보호자 재통화">
      <label>방문·입원 예정</label><input type="date" id="lfPlan">
      <label>입원일</label><input type="date" id="lfAdmit" title="입퇴원현황이 올라오면 자동으로 채워집니다">
    </div>
    <div class="stages" id="mlStages"></div>
    <div style="display:flex;gap:8px;flex-wrap:wrap;margin-top:10px;align-items:center;">
      <button type="button" class="ml-btn pri" onclick="mlSave();">저장</button>
      <button type="button" class="ml-btn" onclick="mlCloseDetail();">닫기</button>
      <span class="ml-spacer"></span>
      <button type="button" class="ml-btn del" id="mlDelBtn" onclick="mlDel();">삭제</button>
    </div>
  </div>
  <div class="ml-card" id="mlLogCard" style="display:none;">
    <h4>상담 이력</h4>
    <div style="display:flex;gap:6px;">
      <input type="text" id="lfLogMemo" maxlength="500" placeholder="통화·방문 내용을 적고 Enter" style="flex:1;" onkeydown="if(event.key==='Enter'){mlLogAdd();}">
      <button type="button" class="ml-btn" onclick="mlLogAdd();">기록</button>
    </div>
    <div class="logs" id="mlLogs"></div>
  </div>
</div>

<div class="ml-grid ml-grid2" data-split="lead.follow" data-vsplit="lead.follow">
  <div class="ml-card">
    <h4>유입 경로별 상담 → 입원 <span class="sp"></span><label class="small"><input type="radio" name="mlStatRng" value="m" checked onchange="mlStats();"> 이번 달</label> <label class="small"><input type="radio" name="mlStatRng" value="q" onchange="mlStats();"> 최근 3달</label></h4>
    <div class="ml-wrap"><table id="mlStat"></table></div>
    <div class="small" style="margin-top:6px;">입원 = 단계가 입원·퇴원 후인 상담. 어떤 경로가 실제 입원으로 이어지는지 보고 홍보에 씁니다.</div>
  </div>
  <div class="ml-card">
    <h4>퇴원 환자 안부 연락 <span class="sp"></span><label class="small">최근 <select id="mlFollowDays" onchange="mlFollow();"><option value="30">30일</option><option value="60" selected>60일</option><option value="90">90일</option></select> 퇴원</label></h4>
    <div class="ml-wrap ml-follow"><table id="mlFollow"><tbody><tr><td class="ml-empty">불러오는 중…</td></tr></tbody></table></div>
    <div class="small" style="margin-top:6px;">입퇴원현황의 퇴원 건입니다. 연락하고 결과를 고르면 저장됩니다. 「재입원 희망」은 상담 접수로 이어집니다.</div>
  </div>
</div>

<script>
(function(){
  function gel(id){ return document.getElementById(id); }
  function esc(s){ return (s==null?'':String(s)).replace(/[&<>"]/g, function(c){ return ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;'})[c]; }); }
  function post(url, data){
    return $.ajax({ url:url, type:'POST', data:data, dataType:'json' }).then(function(res){
      if (res && res.result === 'FAIL') { throw new Error(res.message || '처리에 실패했습니다.'); }
      return res;
    });
  }
  function err(e){ _alertBox((e && e.message) ? e.message : '처리 중 오류가 발생했습니다.', {icon:'❌'}); }
  var root = gel('misLead'), WNN = root.getAttribute('data-wnn') === 'Y';
  function hospCd(){
    try { if (WNN && typeof getCookie === 'function') { var h = (getCookie('s_hospid') || '').trim(); if (h) return h; } } catch(e){}
    return root.getAttribute('data-hosp');
  }
  function withHosp(p){ if (WNN) p.hospCd = hospCd(); return p; }
  var STAGES = [ ['10','상담'], ['20','방문'], ['30','입원 결정'], ['40','입원'], ['50','퇴원 후'] ];
  var CH = { INTRO:'지인·환자 소개', TRANS:'타 병원 전원', WEB:'인터넷 검색', ADS:'광고·현수막', ETC:'기타' };
  var RESULTS = [ ['HOME','잘 지냄'], ['READMIT','재입원 희망'], ['OTHER','타 병원 입원'], ['NOANS','연락 안 됨'], ['ETC','기타'] ];
  var D = null, CUR = null, TODAY = '';
  function d8(s){ s = String(s||'').replace(/-/g,''); return s.length === 8 ? s : ''; }
  function dLbl(s){ s = d8(s); return s ? s.slice(0,4) + '-' + s.slice(4,6) + '-' + s.slice(6) : ''; }
  function dMD(s){ s = d8(s); return s ? Number(s.slice(4,6)) + '/' + Number(s.slice(6)) : ''; }
  function dIn(s){ s = d8(s); return s ? s.slice(0,4) + '-' + s.slice(4,6) + '-' + s.slice(6) : ''; }
  function stageNm(c){ for (var i = 0; i < STAGES.length; i++) if (STAGES[i][0] === c) return STAGES[i][1]; return c === '90' ? '종결' : c; }
  function daysBetween(a, b){ a = d8(a); b = d8(b); if (!a || !b) return null; var da = new Date(a.slice(0,4), a.slice(4,6)-1, a.slice(6)), db = new Date(b.slice(0,4), b.slice(4,6)-1, b.slice(6)); return Math.round((db - da) / 86400000); }

  window.mlLoad = function(){
    post('<c:url value="/mis/leadList.do"/>', withHosp({})).then(function(res){ D = res; TODAY = res.today; render(); mlStats(); if (CUR) { var f = (D.leads||[]).filter(function(x){ return String(x.leadseq) === String(CUR.leadseq); })[0]; if (f) openDetail(f); } })
      .catch(function(e){ gel('mlPipe').innerHTML = '<div class="ml-empty">' + esc((e && e.message) || '불러오지 못했습니다.') + '</div>'; });
    mlFollow();
  };

  function render(){
    var leads = D.leads || [], h = '', total = 0;
    STAGES.forEach(function(st){
      var list = leads.filter(function(l){ return l.stage === st[0]; }); total += list.length;
      h += '<div class="col" data-stage="' + st[0] + '" title="빈 곳을 누르면 「' + st[1] + '」 단계로 바로 접수합니다"><div class="h">' + st[1] + ' <span>' + list.length + '</span></div>';
      list.forEach(function(l){
        var due = '';
        if (l.stage === '50' && l.dischdt) { var dd = daysBetween(l.dischdt, TODAY); due = '<span class="due' + (dd >= 7 ? '' : ' ok') + '">퇴원 ' + dd + '일째' + (dd >= 7 ? ' · 안부 연락' : '') + '</span>'; }
        else if (l.nextdt) { var nd = daysBetween(TODAY, l.nextdt); due = '<span class="due' + (nd > 0 ? ' ok' : '') + '">' + (nd < 0 ? '지남 ' : nd === 0 ? '오늘 ' : 'D-' + nd + ' ') + esc(l.nextmemo || '다음 할 일') + '</span>'; }
        h += '<div class="pcard' + (CUR && String(CUR.leadseq) === String(l.leadseq) ? ' sel' : '') + '" data-seq="' + esc(l.leadseq) + '">'
           + '<b>' + esc(l.patnm) + (l.birth6 ? ' <span class="small">' + esc(l.birth6) + '</span>' : '') + (l.guardnm ? ' <span class="small">· ' + esc(l.guardnm) + (l.guardrel ? '(' + esc(l.guardrel) + ')' : '') + '</span>' : '') + '</b>'
           + '<span class="r">' + dMD(l.contactdt) + ' 상담 · ' + esc(CH[l.channel] || l.channel) + (l.condmemo ? ' · ' + esc(String(l.condmemo).slice(0, 24)) : '') + '</span>'
           + (l.admitdt ? '<span class="' + (l.matchyn === 'Y' ? 'auto' : 'r') + '">' + (l.matchyn === 'Y' ? '✔ ' : '') + dMD(l.admitdt) + ' 입원' + (l.dischdt ? ' → ' + dMD(l.dischdt) + ' 퇴원' : '') + (l.matchyn === 'Y' ? ' (입퇴원현황 확인)' : '') + '</span>' : (l.plandt ? '<span class="r">' + dMD(l.plandt) + ' 예정</span>' : ''))
           + due + '</div>';
      });
      // 빈 칸을 눌러도 아무 일이 없던 것(사용자 2026-10-08 「클릭하면 해당 폼 안 뜸」) → 칸마다 「＋ 접수」 안내, 빈 곳 클릭 = 그 단계로 새 상담
      h += '<div class="addhint">' + (list.length ? '＋ 이 단계로 접수' : '＋ 눌러서 「' + st[1] + '」 단계로 바로 접수') + '</div>';
      h += '</div>';
    });
    gel('mlPipe').innerHTML = h;
    var closed = leads.filter(function(l){ return l.stage === '90'; });
    gel('mlClosed').innerHTML = closed.length ? '종결 ' + closed.length + '건(최근 60일): ' + closed.map(function(l){ return '<a href="#" data-seq="' + esc(l.leadseq) + '" class="mlClosedLink">' + esc(l.patnm) + (l.closersn ? '(' + esc(l.closersn) + ')' : '') + '</a>'; }).join(' · ') : '';
    gel('mlCnt').textContent = '진행 중 ' + total + '건';
    $('#mlPipe .pcard').on('click', function(){ var s = this.getAttribute('data-seq'); var l = leads.filter(function(x){ return String(x.leadseq) === s; })[0]; if (l) openDetail(l); });
    $('#mlPipe .col').on('click', function(e){ if (e.target.closest('.pcard')) return; mlNewAt(this.getAttribute('data-stage')); });
    $('#mlClosed .mlClosedLink').on('click', function(ev){ ev.preventDefault(); var s = this.getAttribute('data-seq'); var l = leads.filter(function(x){ return String(x.leadseq) === s; })[0]; if (l) openDetail(l); });
  }

  function openDetail(l){
    CUR = l;
    gel('mlDetail').style.display = ''; gel('mlLogCard').style.display = '';
    gel('mlDetailTtl').innerHTML = (l.leadseq ? '상담 상세 · <b>' + esc(l.patnm) + '</b> <span class="badge' + (l.stage === '40' || l.stage === '50' ? ' ok' : '') + '">' + esc(stageNm(l.stage)) + '</span>' + (l.matchyn === 'Y' ? ' <span class="badge ok">입퇴원현황 확인</span>' : '') : '새 상담 접수');
    gel('lfNm').value = l.patnm || ''; gel('lfBirth').value = l.birth6 || ''; gel('lfGender').value = l.gender || '';
    gel('lfContact').value = dIn(l.contactdt) || dIn(TODAY); gel('lfGuard').value = l.guardnm || ''; gel('lfRel').value = l.guardrel || ''; gel('lfTel').value = l.tel || '';
    gel('lfChannel').value = l.channel || 'INTRO'; gel('lfCond').value = l.condmemo || '';
    gel('lfNextDt').value = dIn(l.nextdt); gel('lfNextMemo').value = l.nextmemo || ''; gel('lfPlan').value = dIn(l.plandt); gel('lfAdmit').value = dIn(l.admitdt);
    var st = '';
    if (l.leadseq) {
      STAGES.forEach(function(s){ st += '<button type="button" class="ml-btn sm' + (s[0] === l.stage ? ' pri' : '') + '" onclick="mlStage(\'' + s[0] + '\')">' + s[1] + '</button>'; });
      st += '<button type="button" class="ml-btn sm" style="color:#b23b3b" onclick="mlStage(\'90\')">종결</button>';
    }
    gel('mlStages').innerHTML = st;
    gel('mlDelBtn').style.display = l.leadseq ? '' : 'none';
    if (l.leadseq) loadLogs(); else gel('mlLogs').innerHTML = '<div class="small">저장하면 이력을 적을 수 있습니다.</div>';
    $('#mlPipe .pcard').removeClass('sel'); $('#mlPipe .pcard[data-seq="' + l.leadseq + '"]').addClass('sel');
    try { gel('mlDetail').scrollIntoView({ behavior:'smooth', block:'nearest' }); } catch(e){}
  }
  window.mlNew = function(){ mlNewAt('10'); };
  /* 관리판의 칸을 눌러 그 단계로 바로 접수 — 이미 입원한 환자를 뒤늦게 적을 때(입원·퇴원 후) 상담부터 네 번 누를 필요가 없다 */
  window.mlNewAt = function(stage){
    stage = String(stage || '10'); if (!STAGES.some(function(s){ return s[0] === stage; })) stage = '10';
    openDetail({ leadseq:'', stage: stage, channel:'INTRO', contactdt:TODAY });
    gel('mlDetailTtl').innerHTML = '새 상담 접수 · <span class="badge' + (stage === '40' || stage === '50' ? ' ok' : '') + '">' + esc(stageNm(stage)) + '</span> 단계로 저장됩니다'
      + (stage === '40' || stage === '50' ? ' <span class="small">— 입원일을 적어 두세요(입퇴원현황이 올라오면 자동으로 맞춰집니다)</span>' : '');
    gel('lfNm').focus();
    gel('mlDetail').scrollIntoView({ behavior:'smooth', block:'nearest' });
  };
  window.mlCloseDetail = function(){ CUR = null; gel('mlDetail').style.display = 'none'; gel('mlLogCard').style.display = 'none'; $('#mlPipe .pcard').removeClass('sel'); };

  window.mlSave = function(){
    var nm = String(gel('lfNm').value || '').trim(); if (!nm) { _alertBox('환자 이름을 적어 주세요.', {icon:'⚠️'}); gel('lfNm').focus(); return; }
    var b = String(gel('lfBirth').value || '').replace(/[^0-9]/g, ''); if (b && b.length !== 6) { _alertBox('생년월일은 6자리(YYMMDD)입니다.', {icon:'⚠️'}); gel('lfBirth').focus(); return; }
    var p = withHosp({ leadSeq: CUR && CUR.leadseq ? CUR.leadseq : '', patNm: nm, birth6: b, gender: gel('lfGender').value, contactDt: d8(gel('lfContact').value),
      guardNm: gel('lfGuard').value, guardRel: gel('lfRel').value, tel: gel('lfTel').value, channel: gel('lfChannel').value, condMemo: gel('lfCond').value,
      stage: CUR && CUR.stage ? CUR.stage : '10', planDt: d8(gel('lfPlan').value), nextDt: d8(gel('lfNextDt').value), nextMemo: gel('lfNextMemo').value,
      admitDt: d8(gel('lfAdmit').value), dischDt: CUR && CUR.dischdt ? CUR.dischdt : '', closeRsn: CUR && CUR.closersn ? CUR.closersn : '' });
    post('<c:url value="/mis/leadSave.do"/>', p).then(function(res){ _toast('저장했습니다.', 'ok'); CUR = { leadseq: res.leadSeq, stage: p.stage }; mlLoad(); }).catch(err);
  };
  window.mlStage = function(stage){
    if (!CUR || !CUR.leadseq) return;
    if (stage === CUR.stage) return;
    var nm = stageNm(stage);
    if (stage === '90') {
      var rsn = '';
      _confirmBox({ msg: '<b>' + esc(CUR.patnm) + '</b> 상담을 종결합니다.<br>사유를 아래 이력 칸에 적어 두면 좋습니다(타 병원 입원·보류·사망 등).', icon:'⚠️', okText:'종결', okColor:'#b23b3b',
        onOk: function(){ post('<c:url value="/mis/leadStage.do"/>', withHosp({ leadSeq: CUR.leadseq, stage: '90', closeRsn: rsn, memo: '종결' })).then(function(){ _toast('종결했습니다.', 'ok'); CUR.stage = '90'; mlLoad(); }).catch(err); } });
      return;
    }
    post('<c:url value="/mis/leadStage.do"/>', withHosp({ leadSeq: CUR.leadseq, stage: stage })).then(function(){ _toast('「' + nm + '」 단계로 옮겼습니다.', 'ok'); CUR.stage = stage; mlLoad(); }).catch(err);
  };
  window.mlDel = function(){
    if (!CUR || !CUR.leadseq) return;
    _confirmBox({ msg: '<b>' + esc(CUR.patnm) + '</b> 상담 기록을 지웁니다. 되돌릴 수 없습니다.', icon:'🗑️', okText:'삭제', okColor:'#b23b3b',
      onOk: function(){ post('<c:url value="/mis/leadDel.do"/>', withHosp({ leadSeq: CUR.leadseq })).then(function(){ _toast('지웠습니다.', 'ok'); mlCloseDetail(); mlLoad(); }).catch(err); } });
  };
  function loadLogs(){
    post('<c:url value="/mis/leadLog.do"/>', withHosp({ leadSeq: CUR.leadseq })).then(function(res){ paintLogs(res.logs || []); }).catch(function(){ gel('mlLogs').innerHTML = ''; });
  }
  function paintLogs(logs){
    gel('mlLogs').innerHTML = logs.length ? logs.map(function(g){ return '<div><span class="d">' + dLbl(g.logdt) + '</span><span class="badge">' + esc(stageNm(g.stage)) + '</span> ' + esc(g.memo) + ' <span class="small">' + esc(g.reguser || '') + '</span></div>'; }).join('') : '<div class="small">아직 이력이 없습니다.</div>';
  }
  window.mlLogAdd = function(){
    if (!CUR || !CUR.leadseq) { _alertBox('먼저 상담을 저장해 주세요.', {icon:'⚠️'}); return; }
    var m = String(gel('lfLogMemo').value || '').trim(); if (!m) return;
    post('<c:url value="/mis/leadLog.do"/>', withHosp({ leadSeq: CUR.leadseq, memo: m })).then(function(res){ gel('lfLogMemo').value = ''; paintLogs(res.logs || []); }).catch(err);
  };

  window.mlStats = function(){
    if (!D) return;
    var rng = $('input[name="mlStatRng"]:checked').val(), rows = (rng === 'q' ? D.stats3 : D.stats) || [];
    var map = {}; rows.forEach(function(r){ map[r.channel] = r; });
    var h = '<thead><tr><th>유입 경로</th><th class="n">상담</th><th class="n">입원</th><th class="n">전환율</th></tr></thead><tbody>', tl = 0, ta = 0;
    Object.keys(CH).forEach(function(k){ var r = map[k], l = r ? Number(r.leads) : 0, a = r ? Number(r.admits) : 0; tl += l; ta += a; h += '<tr><td>' + CH[k] + '</td><td class="n">' + l + '</td><td class="n">' + a + '</td><td class="n">' + (l ? Math.round(a/l*100) + '%' : '—') + '</td></tr>'; });
    h += '<tr><td><b>합계</b></td><td class="n"><b>' + tl + '</b></td><td class="n"><b>' + ta + '</b></td><td class="n"><b>' + (tl ? Math.round(ta/tl*100) + '%' : '—') + '</b></td></tr></tbody>';
    gel('mlStat').innerHTML = h;
  };

  window.mlFollow = function(){
    post('<c:url value="/mis/followList.do"/>', withHosp({ days: gel('mlFollowDays').value })).then(function(res){
      var list = res.list || [], today = res.today, h = '<thead><tr><th class="n" style="width:42px">No</th><th>퇴원일</th><th>환자</th><th class="n">재원일수</th><th>퇴원 후 경과</th><th>연락</th><th>결과</th><th>메모</th></tr></thead><tbody>';
      list.forEach(function(r, i){
        var dd = daysBetween(r.twdt, today), done = r.doneyn === 'Y';
        var key = 'birth6=' + esc(r.birth6) + '&ipwonDt=' + esc(r.ipdt) + '&tewonDt=' + esc(r.twdt);
        h += '<tr class="' + (done ? 'done' : '') + '" data-key="' + key + '"><td class="n small">' + (i + 1) + '</td><td>' + dLbl(r.twdt) + '</td><td><b>' + esc(r.patnm) + '</b> <span class="small">' + esc(r.birth6) + '</span>' + (r.readmitdt ? ' <span class="badge ok">' + dMD(r.readmitdt) + ' 재입원</span>' : '') + '</td>'
           + '<td class="n">' + esc(r.staydays) + '일</td><td>' + (dd >= 7 && !done && !r.readmitdt ? '<span class="badge warn">' + dd + '일째 · 연락</span>' : dd + '일') + '</td>'
           + '<td><label><input type="checkbox" class="fwDone"' + (done ? ' checked' : '') + '> ' + (done && r.donedt ? dLbl(r.donedt) : '함') + '</label></td>'
           + '<td><select class="fwRes"><option value="">—</option>' + RESULTS.map(function(x){ return '<option value="' + x[0] + '"' + (r.resultcd === x[0] ? ' selected' : '') + '>' + x[1] + '</option>'; }).join('') + '</select></td>'
           + '<td class="memo"><input type="text" class="fwMemo" maxlength="300" value="' + esc(r.memo || '') + '" style="width:100%;min-width:120px;"></td></tr>';
      });
      if (!list.length) h += '<tr><td colspan="8" class="ml-empty">최근 ' + esc(res.days) + '일 안에 퇴원한 환자가 없습니다(입퇴원현황 기준).</td></tr>';
      gel('mlFollow').innerHTML = h + '</tbody>';
      $('#mlFollow .fwDone, #mlFollow .fwRes').on('change', function(){ fwSave(this.closest('tr')); });
      $('#mlFollow .fwMemo').on('change', function(){ fwSave(this.closest('tr')); });
    }).catch(function(e){ gel('mlFollow').innerHTML = '<tbody><tr><td class="ml-empty">' + esc((e && e.message) || '불러오지 못했습니다.') + '</td></tr></tbody>'; });
  };
  function fwSave(tr){
    var q = {}; tr.getAttribute('data-key').split('&').forEach(function(kv){ var a = kv.split('='); q[a[0]] = decodeURIComponent(a[1] || ''); });
    var done = tr.querySelector('.fwDone').checked, res = tr.querySelector('.fwRes').value, memo = tr.querySelector('.fwMemo').value;
    if (res && !done) { tr.querySelector('.fwDone').checked = true; done = true; }
    post('<c:url value="/mis/followSave.do"/>', withHosp({ birth6: q.birth6, ipwonDt: q.ipwonDt, tewonDt: q.tewonDt, doneYn: done ? 'Y' : 'N', resultCd: res, memo: memo }))
      .then(function(){ tr.className = done ? 'done' : ''; if (res === 'READMIT') _toast('재입원 희망 — 관리판 「상담」 칸을 눌러 이어서 적어 두세요.', 'ok'); }).catch(err);
  }

  /* 엑셀(2026-10-08) — 시트 1 상담 목록(화면에 있는 것 = 진행 중 + 최근 60일 종결), 시트 2 퇴원 안부 연락(표 그대로). xlsx 는 header.jsp 가 defer 로 싣는다 */
  window.mlExcel = function(){
    if (typeof XLSX === 'undefined') { _alertBox('엑셀 모듈을 아직 불러오지 못했습니다. 잠시 뒤 다시 눌러 주세요.', {icon:'⏳'}); return; }
    try {
      var leads = (D && D.leads) || [], aoa = [['단계','환자','생년월일','성별','보호자','관계','연락처','상담일','유입 경로','상태·요구','다음 할 일','내용','방문·입원 예정','입원일','퇴원일','입퇴원현황 확인','종결 사유']];
      leads.forEach(function(l){ aoa.push([stageNm(l.stage), l.patnm||'', l.birth6||'', l.gender==='M'?'남':l.gender==='F'?'여':'', l.guardnm||'', l.guardrel||'', l.tel||'', dLbl(l.contactdt), CH[l.channel]||l.channel||'', l.condmemo||'', dLbl(l.nextdt), l.nextmemo||'', dLbl(l.plandt), dLbl(l.admitdt), dLbl(l.dischdt), l.matchyn==='Y'?'Y':'', l.closersn||'']); });
      var ws = XLSX.utils.aoa_to_sheet(aoa); ws['!cols'] = [{wch:8},{wch:10},{wch:9},{wch:5},{wch:10},{wch:7},{wch:14},{wch:11},{wch:12},{wch:36},{wch:11},{wch:24},{wch:12},{wch:11},{wch:11},{wch:8},{wch:20}];
      var wb = XLSX.utils.book_new(); XLSX.utils.book_append_sheet(wb, ws, '상담 목록');
      XLSX.utils.book_append_sheet(wb, XLSX.utils.table_to_sheet(gel('mlFollow'), {raw:false}), '퇴원 안부 연락');
      var nm = (root.getAttribute('data-nm') || '').replace(/[\\\/:*?"<>|]/g, '_'), d = new Date();
      XLSX.writeFile(wb, '고객관리_' + nm + '_' + d.getFullYear() + String(d.getMonth()+1).padStart(2,'0') + String(d.getDate()).padStart(2,'0') + '.xlsx');
    } catch(e){ err(e); }
  };

  $(function(){ mlLoad(); });
})();
</script>
</div><%-- /#misLead --%>
</div><%-- /.dashboard-wrapper --%>
