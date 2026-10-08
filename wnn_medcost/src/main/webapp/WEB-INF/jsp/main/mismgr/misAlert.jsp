<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%-- misAlert.jsp — 경영관리(MIS) › 업무 알림 (2026-10-08, 제안서 ③ 업무 자동화 1차)
     · 「오늘 챙길 일」 알림판 : 서버(/mis/alertGet.do)가 지난달 자료(청구·입퇴원·평가표·자료생성)·이번 분기 차등제·평가표 자가점검·고정비·병상 수를 점검해 준다.
       위너넷이 전화로 챙기던 일을 화면이 대신한다. 문자·메일 발송은 2차(담당자 등록 뒤).
     · 인력 변동 시뮬레이션 : 최신 차등제 신고값 + 구조영역(01~03) 표준화 구간(TBL_WEVALUE_MST)으로 「간호사를 1명 더 뽑으면 몇 점」을 바로 계산한다.
       구간 판정은 자료생성(SP_EVALUATION_INDICATORS_REGISTER)과 같은 표(START_INDI~END_INDI → STD_SCORE), 가중치 = WE_VALUE × 표준화점수 ÷ 5.
     · ★주의: 이 파일 안에서 Deferred EL 표기(샵+중괄호) 금지 --%>

<script src="/asset/js/ui-message.js"></script>

<div class="dashboard-wrapper">
<div id="misAlert" data-wnn="<c:out value='${wnnYn}'/>" data-hosp="<c:out value='${hospCd}'/>">
<style>
  #misAlert{ background:#f4f6f8; color:#1f2a30; min-height:100%; padding:14px 16px 50px; max-width:100%; overflow-x:hidden; }
  #misAlert *{ box-sizing:border-box; }
  #misAlert .ma-head{ display:flex; align-items:center; gap:10px; margin-bottom:12px; flex-wrap:wrap; }
  #misAlert .ma-title{ font-size:18px; font-weight:800; color:#20303a; display:flex; align-items:center; gap:8px; }
  #misAlert .ma-dot{ width:10px; height:10px; border-radius:50%; background:linear-gradient(135deg,#1f5a4b,#2a7665); }
  #misAlert .ma-sub{ font-size:12px; color:#6b7c86; font-weight:400; }
  #misAlert .ma-hosp{ background:#e7f3ee; color:#1f5a4b; font-size:12px; font-weight:800; border:1px solid #cfe3da; border-radius:14px; padding:3px 11px; }
  #misAlert .ma-spacer{ flex:1; }
  #misAlert input{ border:1px solid #cfd8e0; border-radius:6px; padding:4px 6px; font-size:13px; background:#fff; font-family:inherit; text-align:right; width:70px; font-variant-numeric:tabular-nums; }
  #misAlert #maSim th, #misAlert #maSim td{ padding:5px 6px; }   /* 8칸이라 좁게 — 마지막 칸이 잘리던 것(2026-10-08 사용자 캡처) */
  #misAlert .ma-btn{ border:1px solid #cfd9e0; background:#fff; color:#43555f; border-radius:6px; padding:5px 11px; font-size:12.5px; font-weight:700; cursor:pointer; }
  #misAlert .ma-btn:hover{ background:#eef3f6; }
  #misAlert .ma-note{ background:#fff; border:1px solid #e3e9ed; border-radius:10px; padding:10px 14px; font-size:12.5px; color:#43555f; margin-bottom:12px; line-height:1.6; }
  #misAlert .ma-grid{ display:grid; grid-template-columns:1fr 1.15fr; gap:12px; }   /* 시뮬레이션 표가 8칸이라 오른쪽을 더 넓게 */
  @media (max-width:1000px){ #misAlert .ma-grid{ grid-template-columns:1fr; } }
  #misAlert .ma-grid > *{ min-width:0; }
  #misAlert .ma-card{ background:#fff; border:1px solid #e3e9ed; border-radius:10px; padding:12px 14px; }
  #misAlert .ma-card h4{ margin:0 0 10px; font-size:13px; color:#43555f; font-weight:700; display:flex; gap:8px; align-items:center; flex-wrap:wrap; }
  #misAlert .ma-card h4 .sp{ flex:1; }
  #misAlert .cnt{ font-size:11px; font-weight:700; border-radius:10px; padding:1px 8px; }
  #misAlert .cnt.bad{ background:#fde5e3; color:#b23b3b; } #misAlert .cnt.warn{ background:#fbeadb; color:#b45f1c; } #misAlert .cnt.ok{ background:#e7f3ee; color:#1f5a4b; } #misAlert .cnt.info{ background:#eef2f5; color:#43555f; }
  #misAlert .alerts{ display:flex; flex-direction:column; gap:8px; }
  #misAlert .alert{ display:grid; grid-template-columns:auto 1fr auto; gap:12px; align-items:center; border:1px solid #e3e9ed; border-radius:8px; padding:9px 12px; font-size:13.5px; background:#fff; }
  #misAlert .alert .ic{ width:9px; height:36px; border-radius:4px; }
  #misAlert .alert .ic.warn{ background:#d9772b; } #misAlert .alert .ic.bad{ background:#c0463f; } #misAlert .alert .ic.ok{ background:#2f8f5b; } #misAlert .alert .ic.info{ background:#6b7c86; }
  #misAlert .alert b{ display:block; color:#20303a; }
  #misAlert .alert .d{ font-size:12px; color:#6b7c86; }
  #misAlert .alert.ok b{ color:#43555f; font-weight:600; }
  #misAlert .alert .act{ font-size:12.5px; font-weight:700; color:#1f5a4b; white-space:nowrap; text-decoration:none; }
  #misAlert .alert .act:hover{ text-decoration:underline; }
  #misAlert table{ width:100%; border-collapse:collapse; font-size:13px; }
  #misAlert th{ background:#f2f6f8; font-weight:700; color:#43555f; padding:7px 9px; border-bottom:1px solid #dde5ea; text-align:left; white-space:nowrap; }
  #misAlert td{ padding:6px 9px; border-bottom:1px solid #eef2f5; vertical-align:middle; white-space:nowrap; }
  #misAlert .ma-wrap{ overflow-x:auto; }
  #misAlert td.n, #misAlert th.n{ text-align:right; font-variant-numeric:tabular-nums; }
  #misAlert .up{ color:#2f8f5b; font-weight:700; } #misAlert .down{ color:#c0463f; font-weight:700; }
  #misAlert .small{ font-size:12px; color:#6b7c86; }
  #misAlert .ma-empty{ color:#8a99a3; font-size:13px; padding:18px; text-align:center; }
  #misAlert .zone{ display:inline-block; min-width:34px; text-align:center; border-radius:10px; padding:1px 7px; font-size:11.5px; font-weight:700; background:#eef2f5; color:#43555f; }
  #misAlert .zone.z5{ background:#e7f3ee; color:#1f5a4b; } #misAlert .zone.z1{ background:#fde5e3; color:#b23b3b; }
</style>

<div class="ma-head">
  <div class="ma-title"><span class="ma-dot"></span>업무 알림 <span class="ma-sub">— 오늘 챙길 일 · 자료가 올라왔는지 서버가 점검</span></div>
  <span class="ma-hosp">🏥 <c:out value='${hospNm}'/></span>
  <span class="ma-spacer"></span>
  <span class="small" id="maDate"></span>
  <button type="button" class="ma-btn" onclick="maLoad();">다시 점검</button>
</div>

<div class="ma-note">
  지난달 <b>청구 샘파일·입퇴원현황·환자평가표·자료생성</b>, 이번 분기 <b>차등제 신고값</b>, 평가표 <b>자가점검</b>, <b>고정비·병상 수</b>, 고객관리의 <b>연락 예정일·퇴원 안부 연락</b>을 로그인할 때마다 점검합니다.
  빨강은 기한이 지났거나 점수에 바로 영향이 있는 것, 주황은 곧 해야 할 것, 초록은 끝난 것입니다. 문자·메일로 받는 기능은 담당자 등록 뒤 붙입니다.
</div>

<div class="ma-grid">
  <div class="ma-card">
    <h4>오늘 챙길 일 <span class="sp"></span><span id="maCnt"></span></h4>
    <div class="alerts" id="maList"><div class="ma-empty">점검하는 중…</div></div>
  </div>
  <div class="ma-card">
    <h4>인력 변동 시뮬레이션 <span class="small">— "한 명 더 뽑으면 몇 점?"</span></h4>
    <div class="small" id="maSimBase" style="margin-bottom:8px;"></div>
    <div class="ma-wrap"><table id="maSim"><tbody><tr><td class="ma-empty">불러오는 중…</td></tr></tbody></table></div>
    <div class="small" style="margin-top:8px;">「인력 바꿔 보기」에 넣는 숫자는 <b>인력 수(명)</b>입니다. 1인당 환자 수 = 평균환자 ÷ 인력 수(둘째 자리 반올림) — 인력을 늘리면 1인당 환자가 <b>줄어</b> 점수가 오릅니다(낮을수록 좋은 지표). 구간·점수는 적정성평가 산출과 같은 표준화 구간표(TBL_WEVALUE_MST)로 계산합니다. 숫자를 바꾸면 바로 다시 계산되고, 저장하지 않습니다.</div>
  </div>
</div>

<%-- ③-2 문자·메일 알림 (2026-10-08) — 받는 사람 · 미리보기 · 지금 보내기 · 발송 이력. 자동 발송은 서버(MisNotiScheduler, 평일 08:30). --%>
<div class="ma-card" style="margin-top:12px;" id="maNoti">
  <h4>문자·메일로 받기 <span class="small">— 로그인하지 않은 날도 「급함·할 일」이 담당자에게 간다</span><span class="sp"></span>
    <span id="maNotiStat" class="small"></span>
    <button type="button" class="ma-btn" onclick="maNotiPreview();">미리보기</button>
    <button type="button" class="ma-btn" onclick="maNotiSend();" style="background:#1f5a4b;color:#fff;border-color:#1f5a4b;">지금 보내기</button></h4>
  <div class="ma-grid" style="grid-template-columns:1.25fr 1fr;">
    <div>
      <div class="small" style="margin-bottom:6px;"><b>알림 받는 사람</b> — 메일·문자 중 하나는 켜야 합니다. 「자동」은 평일 아침 08:30 에 서버가 보내는 주기, 「단계」는 급함만 받을지 할 일까지 받을지.</div>
      <div class="ma-wrap"><table id="maNotiUsers"><tbody><tr><td class="ma-empty">불러오는 중…</td></tr></tbody></table></div>
      <div class="ma-nform" id="maNotiForm">
        <input type="hidden" id="nfSeq" value="">
        <label>이름 <input type="text" id="nfName" maxlength="50" style="width:90px;text-align:left;"></label>
        <label>역할 <input type="text" id="nfRole" maxlength="50" placeholder="행정실장" style="width:90px;text-align:left;"></label>
        <label>메일 <input type="text" id="nfEmail" maxlength="100" style="width:190px;text-align:left;"></label>
        <label>휴대폰 <input type="text" id="nfTel" maxlength="30" placeholder="010-0000-0000" style="width:120px;text-align:left;"></label>
        <label><input type="checkbox" id="nfMail" checked> 메일</label>
        <label><input type="checkbox" id="nfSms"> 문자</label>
        <label>자동 <select id="nfAuto"><option value="W">매주 월요일</option><option value="D">매일(평일)</option><option value="N">수동만</option></select></label>
        <label>단계 <select id="nfLevel"><option value="warn">급함 + 할 일</option><option value="bad">급함만</option></select></label>
        <button type="button" class="ma-btn" onclick="maNotiSave();" style="background:#1f5a4b;color:#fff;border-color:#1f5a4b;" id="nfSaveBtn">추가</button>
        <button type="button" class="ma-btn" onclick="maNotiNew();">새로</button>
      </div>
      <div class="small" id="maNotiCand" style="margin-top:6px;"></div>
    </div>
    <div>
      <div class="small" style="margin-bottom:6px;"><b>최근 발송 이력</b> — 실패·건너뜀도 남깁니다(왜 안 왔는지의 답).</div>
      <div class="ma-wrap" style="max-height:300px;overflow:auto;"><table id="maNotiLogs"><tbody><tr><td class="ma-empty">—</td></tr></tbody></table></div>
    </div>
  </div>
  <div id="maNotiPv" style="display:none;margin-top:10px;border-top:1px dashed #cfd9e0;padding-top:10px;">
    <div class="small" style="margin-bottom:6px;"><b>미리보기</b> — 지금 보내면 이렇게 갑니다(급함·할 일만 담깁니다). <span id="maPvSubj"></span></div>
    <div class="ma-grid" style="grid-template-columns:1.4fr 1fr;">
      <iframe id="maPvFrame" style="width:100%;height:320px;border:1px solid #e3e9ed;border-radius:8px;background:#fff;"></iframe>
      <div><div class="small" style="margin-bottom:4px;">문자(SMS/LMS) 글 <span id="maPvSmsLen"></span></div><pre id="maPvSms" style="white-space:pre-wrap;font-family:inherit;font-size:13px;background:#f7f9fa;border:1px solid #e3e9ed;border-radius:8px;padding:10px;margin:0;min-height:120px;"></pre></div>
    </div>
  </div>
</div>

<style>
  #misAlert .ma-nform{ display:flex; flex-wrap:wrap; gap:6px 10px; align-items:center; margin-top:8px; font-size:12.5px; color:#43555f; background:#f7f9fa; border:1px solid #e3e9ed; border-radius:8px; padding:8px 10px; }
  #misAlert .ma-nform label{ display:flex; align-items:center; gap:4px; margin:0; }
  #misAlert .ma-nform select{ border:1px solid #cfd8e0; border-radius:6px; padding:3px 4px; font-size:12.5px; background:#fff; }
  #misAlert .pill{ display:inline-block; border-radius:10px; padding:1px 7px; font-size:11px; font-weight:700; background:#eef2f5; color:#43555f; }
  #misAlert .pill.on{ background:#e7f3ee; color:#1f5a4b; } #misAlert .pill.off{ background:#fde5e3; color:#b23b3b; } #misAlert .pill.skip{ background:#fbeadb; color:#b45f1c; }
  #misAlert .cand{ display:inline-block; margin:2px 4px 2px 0; border:1px solid #cfd9e0; border-radius:12px; padding:2px 9px; cursor:pointer; background:#fff; font-size:12px; }
  #misAlert .cand:hover{ background:#eef3f6; }
  #misAlert #maNotiUsers td{ white-space:normal; }
</style>

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
  var root = gel('misAlert'), WNN = root.getAttribute('data-wnn') === 'Y';
  function hospCd(){
    try { if (WNN && typeof getCookie === 'function') { var h = (getCookie('s_hospid') || '').trim(); if (h) return h; } } catch(e){}
    return root.getAttribute('data-hosp');
  }
  function withHosp(p){ if (WNN) p.hospCd = hospCd(); return p; }
  function n2(v){ return Number(v||0).toFixed(2); }
  function r2(v){ return Math.round(Number(v||0) * 100) / 100; }   // 둘째 자리 반올림 — 등록 SP 의 현황값과 같은 자리에서 구간을 가른다

  window.maLoad = function(){
    var d = new Date(); gel('maDate').textContent = d.getFullYear() + '년 ' + (d.getMonth()+1) + '월 ' + d.getDate() + '일 기준';
    post('<c:url value="/mis/alertGet.do"/>', withHosp({})).then(function(res){
      var list = res.alerts || [], h = '', bad = 0, warn = 0, ok = 0, info = 0;
      var order = { bad:0, warn:1, info:2, ok:3 };
      list.sort(function(a, b){ return (order[a.level]||9) - (order[b.level]||9); });
      list.forEach(function(a){
        if (a.level === 'bad') bad++; else if (a.level === 'warn') warn++; else if (a.level === 'ok') ok++; else info++;
        h += '<div class="alert ' + esc(a.level) + '"><div class="ic ' + esc(a.level) + '"></div><div><b>' + esc(a.title) + '</b>' + (a.desc ? '<span class="d">' + esc(a.desc) + '</span>' : '') + '</div>'
           + (a.href ? '<a class="act" href="' + esc(a.href) + '">' + esc(a.act || '열기 →') + '</a>' : '<span></span>') + '</div>';
      });
      gel('maList').innerHTML = h || '<div class="ma-empty">점검할 항목이 없습니다.</div>';
      gel('maCnt').innerHTML = (bad ? '<span class="cnt bad">급함 ' + bad + '</span> ' : '') + (warn ? '<span class="cnt warn">할 일 ' + warn + '</span> ' : '') + (info ? '<span class="cnt info">참고 ' + info + '</span> ' : '') + (ok ? '<span class="cnt ok">완료 ' + ok + '</span>' : '');
    }).catch(function(e){ gel('maList').innerHTML = '<div class="ma-empty">' + esc((e && e.message) || '점검하지 못했습니다.') + '</div>'; });
    post('<c:url value="/mis/simGet.do"/>', withHosp({})).then(function(res){ SIM = res; simRender(); })
      .catch(function(e){ gel('maSim').innerHTML = '<tbody><tr><td class="ma-empty">' + esc((e && e.message) || '불러오지 못했습니다.') + '</td></tr></tbody>'; });
  };

  /* ── 인력 시뮬레이션 ── */
  var SIM = null;
  var ROWS = [ { cd:'01', nm:'의사', key:'doccount' }, { cd:'02', nm:'간호사', key:'nurcount' }, { cd:'03', nm:'간호인력', key:'nurscnt' } ];
  function zonesOf(cd){ return (SIM.zones||[]).filter(function(z){ return z.catecode === cd; }); }
  function judge(cd, ratio){
    var zs = zonesOf(cd);
    for (var i = 0; i < zs.length; i++) { if (ratio >= Number(zs[i].startindi) && ratio <= Number(zs[i].endindi)) return zs[i]; }
    return null;
  }
  function pointOf(z){ return z ? Math.floor(Number(z.wevalue) * Number(z.stdscore) / 5 * 100 + 1e-6) / 100 : 0; }   // 가중치 = WE_VALUE × 표준화 ÷ 5 (둘째 자리 절삭 — 등록 SP 와 같음). +1e-6 : 8.5×3÷5=5.1 이 부동소수점으로 5.09 가 되던 것
  function needFor5(cd, pat){
    var zs = zonesOf(cd).filter(function(z){ return Number(z.stdscore) === 5; });
    if (!zs.length || !pat) return null;
    var top = Number(zs[0].endindi);          // 5점 구간의 상한(1인당 환자수) — 이 이하라야 5점
    return Math.ceil(pat / top * 100) / 100;  // 필요한 인력 수(소수 둘째 자리 올림)
  }
  function zoneTag(z){
    if (!z) return '<span class="zone">구간 없음</span>';
    var s = Number(z.stdscore);
    return '<span class="zone z' + s + '">' + s + '점 구간</span> <b>' + n2(pointOf(z)) + '점</b>';
  }
  function simRender(){
    var g = SIM.grade;
    if (!g) { gel('maSim').innerHTML = '<tbody><tr><td class="ma-empty">차등제 신고값이 없어 계산할 수 없습니다. 적정성평가 화면에서 분기 신고값을 먼저 넣어 주세요.</td></tr></tbody>'; return; }
    var pat = Number(g.patcount || 0);
    gel('maSimBase').innerHTML = '기준 = <b>' + esc(g.startyy) + '년 ' + esc(g.qterflag) + '분기 신고값</b> · 평균환자 <b>' + n2(pat) + '명</b>';
    var h = '<thead><tr><th>구조영역<br><span style="font-weight:400">1인당 환자수</span></th><th class="n">지금<br><span style="font-weight:400">인력(명)</span></th><th class="n">1인당<br><span style="font-weight:400">↓낮을수록 좋음</span></th><th>구간·점수</th><th class="n">바꿔 보기<br><span style="font-weight:400">인력(명)</span></th><th class="n">1인당</th><th>구간·점수</th><th class="n">5점 되려면<br><span style="font-weight:400">필요 인력(명)</span></th></tr></thead><tbody>';
    ROWS.forEach(function(r){
      var cur = Number(g[r.key] || 0), ratio = cur ? r2(pat / cur) : 0, z = judge(r.cd, ratio);
      var need = needFor5(r.cd, pat);
      h += '<tr data-cd="' + r.cd + '" data-cur="' + cur + '">'
         + '<td><b>' + r.nm + '</b></td><td class="n">' + n2(cur) + '</td><td class="n">' + n2(ratio) + '</td><td>' + zoneTag(z) + '</td>'
         + '<td class="n"><input type="text" class="simIn" value="' + n2(cur) + '"></td><td class="n simR">' + n2(ratio) + '</td><td class="simZ">' + zoneTag(z) + '</td>'
         + '<td class="n">' + (need == null ? '—' : (need <= cur ? '<span class="up">지금 5점</span>' : n2(need) + '명 <span class="small">(+' + n2(need - cur) + ')</span>')) + '</td></tr>';
    });
    gel('maSim').innerHTML = h + '</tbody>';
    $('#maSim .simIn').on('input change', function(){ simCalc(this.closest('tr')); });
  }
  function simCalc(tr){
    var cd = tr.getAttribute('data-cd'), cur = Number(tr.getAttribute('data-cur')), pat = Number(SIM.grade.patcount || 0);
    var v = Number(String(tr.querySelector('.simIn').value).replace(/[^0-9.]/g, '')) || 0;
    var ratio = v ? r2(pat / v) : 0, z = judge(cd, ratio), z0 = judge(cd, cur ? r2(pat / cur) : 0);
    tr.querySelector('.simR').textContent = n2(ratio);
    var diff = pointOf(z) - pointOf(z0);
    tr.querySelector('.simZ').innerHTML = zoneTag(z) + (diff ? ' <span class="' + (diff > 0 ? 'up' : 'down') + '">' + (diff > 0 ? '+' : '') + n2(diff) + '</span>' : '');
  }

  /* ── 문자·메일 알림 (2026-10-08) ── */
  var NB = null;
  var AUTO_NM = { D:'매일(평일)', W:'매주 월요일', N:'수동만' };
  function fmtDt(s){ s = String(s||''); return s.length >= 16 ? s.slice(5,16).replace('T',' ') : s; }
  window.maNotiLoad = function(){
    post('<c:url value="/mis/notiBoard.do"/>', withHosp({})).then(function(res){
      NB = res;
      gel('maNotiStat').innerHTML = '메일 ' + (res.mailReady ? '<span class="pill on">준비됨</span>' : '<span class="pill off" title="' + esc(res.mailReason) + '">설정 없음</span>')
        + ' 문자 ' + (res.smsReady ? '<span class="pill on">준비됨</span>' : '<span class="pill skip" title="' + esc(res.smsReason) + '">설정 없음</span>')
        + ' 자동 ' + (res.autoEnabled ? '<span class="pill on">평일 08:30</span>' : '<span class="pill" title="서버 설정 noti.auto.enabled 가 꺼져 있습니다 — 운영 서버에서만 켭니다">꺼짐</span>');
      var us = res.users || [], h = '<thead><tr><th>이름</th><th>역할</th><th>메일</th><th>휴대폰</th><th>채널</th><th>자동</th><th>단계</th><th></th></tr></thead><tbody>';
      if (!us.length) h += '<tr><td colspan="8" class="ma-empty">아직 등록된 사람이 없습니다. 아래에서 추가하거나 계정에서 가져오세요.</td></tr>';
      us.forEach(function(u){
        var off = u.useyn !== 'Y';
        h += '<tr' + (off ? ' style="opacity:.5"' : '') + '><td><b>' + esc(u.name) + '</b>' + (off ? ' <span class="pill">사용 안 함</span>' : '') + '</td><td>' + esc(u.rolenm||'') + '</td><td>' + esc(u.email||'') + '</td><td>' + esc(u.tel||'') + '</td>'
           + '<td>' + (u.mailyn === 'Y' ? '<span class="pill on">메일</span> ' : '') + (u.smsyn === 'Y' ? '<span class="pill on">문자</span>' : '') + '</td>'
           + '<td>' + esc(AUTO_NM[u.autogb] || u.autogb) + '</td><td>' + (u.minlevel === 'bad' ? '급함만' : '급함+할 일') + '</td>'
           + '<td style="white-space:nowrap"><button type="button" class="ma-btn" style="padding:2px 7px" onclick="maNotiEdit(' + u.notiseq + ')">수정</button> '
           + '<button type="button" class="ma-btn" style="padding:2px 7px" onclick="maNotiSendOne(' + u.notiseq + ')" title="이 사람에게만 지금 보내기">보내기</button> '
           + '<button type="button" class="ma-btn" style="padding:2px 7px;color:#b23b3b" onclick="maNotiDel(' + u.notiseq + ')">삭제</button></td></tr>';
      });
      gel('maNotiUsers').innerHTML = h + '</tbody>';
      var cs = res.candidates || [], c = '';
      cs.forEach(function(x, i){ if (!x.email && !x.tel) return; c += '<span class="cand" onclick="maNotiPick(' + i + ')" title="누르면 아래 칸에 채워집니다">' + esc(x.name) + ' <span style="color:#6b7c86">' + esc(x.email || x.tel) + '</span></span>'; });
      gel('maNotiCand').innerHTML = c ? '<b>계정에서 가져오기</b> (누르면 칸에 채워집니다 — 계정 표는 바뀌지 않습니다) ' + c : '';
      var ls = res.logs || [], l = '<thead><tr><th>시각</th><th>채널</th><th>받는 사람</th><th>결과</th><th>비고</th></tr></thead><tbody>';
      if (!ls.length) l += '<tr><td colspan="5" class="ma-empty">아직 보낸 적이 없습니다.</td></tr>';
      ls.forEach(function(g){
        var cls = g.result === 'OK' ? 'on' : g.result === 'FAIL' ? 'off' : 'skip', nm = g.result === 'OK' ? '보냄' : g.result === 'FAIL' ? '실패' : '건너뜀';
        l += '<tr><td>' + esc(fmtDt(g.sentdttm)) + '</td><td>' + (g.channel === 'MAIL' ? '메일' : '문자') + '</td><td title="' + esc(g.toaddr||'') + '">' + esc(g.toname||'') + '<div class="small">' + esc(g.toaddr||'') + '</div></td>'
           + '<td><span class="pill ' + cls + '">' + nm + '</span></td><td class="small" style="white-space:normal;max-width:240px">' + esc(g.errmsg||'') + (g.sentby === 'auto' ? ' <span class="pill">자동</span>' : '') + '</td></tr>';
      });
      gel('maNotiLogs').innerHTML = l + '</tbody>';
    }).catch(function(e){ gel('maNotiUsers').innerHTML = '<tbody><tr><td class="ma-empty">' + esc((e && e.message) || '불러오지 못했습니다.') + '</td></tr></tbody>'; });
  };
  window.maNotiNew = function(){
    gel('nfSeq').value = ''; gel('nfName').value = ''; gel('nfRole').value = ''; gel('nfEmail').value = ''; gel('nfTel').value = '';
    gel('nfMail').checked = true; gel('nfSms').checked = false; gel('nfAuto').value = 'W'; gel('nfLevel').value = 'warn'; gel('nfSaveBtn').textContent = '추가';
  };
  window.maNotiEdit = function(seq){
    var u = (NB.users||[]).filter(function(x){ return String(x.notiseq) === String(seq); })[0]; if (!u) return;
    gel('nfSeq').value = u.notiseq; gel('nfName').value = u.name || ''; gel('nfRole').value = u.rolenm || ''; gel('nfEmail').value = u.email || ''; gel('nfTel').value = u.tel || '';
    gel('nfMail').checked = u.mailyn === 'Y'; gel('nfSms').checked = u.smsyn === 'Y'; gel('nfAuto').value = u.autogb || 'W'; gel('nfLevel').value = u.minlevel || 'warn'; gel('nfSaveBtn').textContent = '수정 저장';
    gel('nfName').focus();
  };
  window.maNotiPick = function(i){
    var x = (NB.candidates||[])[i]; if (!x) return;
    maNotiNew(); gel('nfName').value = x.name || ''; gel('nfEmail').value = x.email || ''; gel('nfTel').value = x.tel || '';
    gel('nfMail').checked = !!x.email; gel('nfSms').checked = false; gel('nfName').focus();
  };
  window.maNotiSave = function(){
    var p = { notiSeq: gel('nfSeq').value, name: gel('nfName').value.trim(), roleNm: gel('nfRole').value.trim(), email: gel('nfEmail').value.trim(), tel: gel('nfTel').value.trim(),
              mailYn: gel('nfMail').checked ? 'Y' : 'N', smsYn: gel('nfSms').checked ? 'Y' : 'N', autoGb: gel('nfAuto').value, minLevel: gel('nfLevel').value, useYn: 'Y' };
    if (!p.name) { _alertBox('이름을 적어 주세요.', {icon:'⚠️'}); gel('nfName').focus(); return; }
    if (p.mailYn !== 'Y' && p.smsYn !== 'Y') { _alertBox('메일·문자 중 하나는 켜야 합니다.', {icon:'⚠️'}); return; }
    post('<c:url value="/mis/notiUserSave.do"/>', withHosp(p)).then(function(){ _toast(p.name + ' 님을 ' + (p.notiSeq ? '고쳤습니다.' : '추가했습니다.'), 'ok'); maNotiNew(); maNotiLoad(); })
      .catch(function(e){ _alertBox(esc((e && e.message) || '저장하지 못했습니다.'), {icon:'❌'}); });
  };
  window.maNotiDel = function(seq){
    var u = (NB.users||[]).filter(function(x){ return String(x.notiseq) === String(seq); })[0]; if (!u) return;
    _confirmBox({ msg: esc(u.name) + ' 님을 받는 사람에서 지웁니다.', icon:'🗑️', okText:'삭제', okColor:'#b23b3b',
      onOk: function(){ post('<c:url value="/mis/notiUserDel.do"/>', withHosp({ notiSeq: seq })).then(function(){ _toast('지웠습니다.', 'ok'); maNotiLoad(); }).catch(function(e){ _alertBox(esc(e.message), {icon:'❌'}); }); } });
  };
  window.maNotiPreview = function(){
    post('<c:url value="/mis/notiPreview.do"/>', withHosp({})).then(function(res){
      gel('maNotiPv').style.display = '';
      gel('maPvSubj').innerHTML = '제목: <b>' + esc(res.subject) + '</b> · 급함 ' + res.bad + ' · 할 일 ' + res.warn;
      gel('maPvFrame').srcdoc = '<!DOCTYPE html><html><head><meta charset="utf-8"></head><body style="margin:12px;background:#fff;">' + res.html + '</body></html>';
      gel('maPvSms').textContent = res.sms; gel('maPvSmsLen').textContent = '(' + res.smsBytes + '바이트 — ' + (res.smsBytes > 90 ? 'LMS' : 'SMS') + ')';
      gel('maNotiPv').scrollIntoView({ behavior:'smooth', block:'nearest' });
    }).catch(function(e){ _alertBox(esc((e && e.message) || '미리보기를 만들지 못했습니다.'), {icon:'❌'}); });
  };
  function sendResult(res){
    var lines = (res.rows||[]).map(function(r){ var nm = r.result === 'OK' ? '✅ 보냄' : r.result === 'FAIL' ? '❌ 실패' : '⏭ 건너뜀'; return nm + ' · ' + (r.channel === 'MAIL' ? '메일' : '문자') + ' · ' + esc(r.name) + ' ' + esc(r.to) + (r.message ? '<div class="small" style="margin-left:18px">' + esc(r.message) + '</div>' : ''); });
    _alertBox('<div style="text-align:left;font-size:13px;line-height:1.6">' + (lines.length ? lines.join('<br>') : '보낼 사람이 없습니다.') + '</div>', { icon: res.fail ? '⚠️' : (res.ok ? '📨' : 'ℹ️') });
    maNotiLoad();
  }
  window.maNotiSend = function(){
    var n = (NB && NB.users ? NB.users.filter(function(u){ return u.useyn === 'Y'; }).length : 0);
    if (!n) { _alertBox('받는 사람을 먼저 등록해 주세요.', {icon:'⚠️'}); return; }
    _confirmBox({ msg: '등록된 ' + n + '명에게 지금 「급함·할 일」을 보냅니다.<br>(설정이 없는 채널은 건너뛰고 이력에 남깁니다)', icon:'📨', okText:'보내기',
      onOk: function(){ post('<c:url value="/mis/notiSend.do"/>', withHosp({})).then(sendResult).catch(function(e){ _alertBox(esc(e.message), {icon:'❌'}); }); } });
  };
  window.maNotiSendOne = function(seq){
    var u = (NB.users||[]).filter(function(x){ return String(x.notiseq) === String(seq); })[0]; if (!u) return;
    _confirmBox({ msg: esc(u.name) + ' 님에게만 지금 보냅니다.', icon:'📨', okText:'보내기',
      onOk: function(){ post('<c:url value="/mis/notiSend.do"/>', withHosp({ notiSeq: seq })).then(sendResult).catch(function(e){ _alertBox(esc(e.message), {icon:'❌'}); }); } });
  };

  $(function(){ maLoad(); maNotiLoad(); });
})();
</script>
</div><%-- /#misAlert --%>
</div><%-- /.dashboard-wrapper --%>
