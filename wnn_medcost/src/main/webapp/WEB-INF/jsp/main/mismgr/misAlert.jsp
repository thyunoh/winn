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
  지난달 <b>청구 샘파일·입퇴원현황·환자평가표·자료생성</b>, 이번 분기 <b>차등제 신고값</b>, 평가표 <b>자가점검</b>, <b>고정비·병상 수</b>를 로그인할 때마다 점검합니다.
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

  $(function(){ maLoad(); });
})();
</script>
</div><%-- /#misAlert --%>
</div><%-- /.dashboard-wrapper --%>
