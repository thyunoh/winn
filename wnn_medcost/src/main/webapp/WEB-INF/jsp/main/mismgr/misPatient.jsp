<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%-- misPatient.jsp — 경영고객관리 › 원무 환자고객 (2026-10-15)
     · 지금 입원해 있는 환자 명단(입퇴원현황에서 퇴원일이 빈 입원 건).
     · 원무가 챙길 것을 바로 본다: 보호자 연락처가 없는 사람 · 입원 3일 이내 신규 · 상담 연결 여부.
     · 보호자·상담은 생년월일 6 + 이름으로 맞춘다(병원자료엑셀연계의 연락처, 신규환자 고객관리의 상담).
     · 새로 적는 칸은 없다(조회 전용). 상담 관리는 신규환자 고객관리에서.
     · ★주의: 이 파일 안에서 Deferred EL 표기(샵+중괄호) 금지 --%>

<script src="/asset/js/ui-message.js"></script>

<div class="dashboard-wrapper">
<div id="misPatient" data-wnn="<c:out value='${wnnYn}'/>" data-hosp="<c:out value='${hospCd}'/>" data-nm="<c:out value='${hospNm}'/>">
<style>
  #misPatient{ background:#f4f6f8; color:#1f2a30; min-height:100%; padding:14px 16px 50px; max-width:100%; overflow-x:hidden; }
  #misPatient *{ box-sizing:border-box; }
  #misPatient .mp-head{ display:flex; align-items:center; gap:10px; margin-bottom:6px; flex-wrap:wrap; }
  #misPatient .mp-title{ font-size:18px; font-weight:800; color:#20303a; display:flex; align-items:center; gap:8px; }
  #misPatient .mp-dot{ width:10px; height:10px; border-radius:50%; background:linear-gradient(135deg,#1f5a4b,#2a7665); }
  #misPatient .mp-sub{ font-size:12px; color:#6b7c86; font-weight:400; }
  #misPatient .mp-hosp{ background:#e7f3ee; color:#1f5a4b; font-size:12px; font-weight:800; border:1px solid #cfe3da; border-radius:14px; padding:3px 11px; }
  #misPatient .mp-spacer{ flex:1; }
  #misPatient input[type=text]{ border:1px solid #cfd8e0; border-radius:6px; padding:5px 9px; font-size:13px; background:#fff; font-family:inherit; min-width:200px; }
  #misPatient .mp-btn{ border:1px solid #cfd9e0; background:#fff; color:#43555f; border-radius:6px; padding:5px 11px; font-size:12.5px; font-weight:700; cursor:pointer; text-decoration:none; white-space:nowrap; }
  #misPatient .mp-btn:hover{ background:#eef3f6; }
  #misPatient .mp-note{ background:#fff; border:1px solid #e3e9ed; border-radius:10px; padding:9px 14px; font-size:12.5px; color:#43555f; margin:10px 0 12px; line-height:1.6; }
  #misPatient .mp-chips{ display:flex; gap:8px; flex-wrap:wrap; margin-bottom:10px; }
  #misPatient .mp-chip{ background:#fff; border:1px solid #e3e9ed; border-radius:10px; padding:8px 12px; min-width:130px; }
  #misPatient .mp-chip b{ display:block; font-size:19px; color:#1f5a4b; }
  #misPatient .mp-chip b.bad{ color:#b23b3b; }
  #misPatient .mp-chip span{ font-size:11.5px; color:#6b7c86; }
  #misPatient .mp-bar{ display:flex; gap:10px; align-items:center; flex-wrap:wrap; margin-bottom:8px; font-size:12.5px; color:#43555f; }
  #misPatient .mp-card{ background:#fff; border:1px solid #e3e9ed; border-radius:12px; padding:12px 14px; overflow-x:auto; }
  #misPatient table{ width:100%; border-collapse:collapse; font-size:12.5px; min-width:760px; }
  #misPatient th{ background:#f2f6f8; color:#43555f; font-weight:800; padding:7px 8px; border-bottom:1px solid #dde5ea; text-align:left; white-space:nowrap; }
  #misPatient td{ padding:7px 8px; border-bottom:1px solid #eef2f5; vertical-align:middle; }
  #misPatient td.num{ text-align:right; font-variant-numeric:tabular-nums; }
  #misPatient .mp-tag{ display:inline-block; font-size:10.5px; font-weight:800; border-radius:8px; padding:0 6px; margin-left:4px; vertical-align:1px; }
  #misPatient .mp-tag.bad{ background:#fde7e7; color:#b23b3b; }
  #misPatient .mp-tag.new{ background:#e6f4ee; color:#1f5a4b; }
  #misPatient .mp-none{ color:#b23b3b; font-weight:700; }
  #misPatient .mp-empty{ padding:24px; text-align:center; color:#8a99a3; }
</style>

<div class="mp-head">
  <div class="mp-title"><span class="mp-dot"></span> 원무 환자고객 <span class="mp-sub">— 지금 입원 중인 환자 · 연락처와 상담 연결을 한눈에</span></div>
  <span class="mp-hosp" id="mpHosp"></span>
  <span class="mp-spacer"></span>
  <button type="button" class="mp-btn" id="mpReload">↻ 다시 보기</button>
</div>

<div class="mp-note">
  입퇴원현황에서 <b>퇴원일이 비어 있는 입원 건</b>을 재원으로 본다(가장 최근에 올라온 입퇴원 자료 기준).
  보호자 연락처는 <b>병원자료엑셀연계</b>의 환자·보호자 연락처, 상담 연결은 <b>신규환자 고객관리</b>의 상담에서 생년월일 6 + 이름으로 맞춘 것이다.
</div>

<div class="mp-chips">
  <div class="mp-chip"><b id="mpTotal">–</b><span>재원 환자</span></div>
  <div class="mp-chip"><b id="mpNoTel">–</b><span>보호자 연락처 없음</span></div>
  <div class="mp-chip"><b id="mpFresh">–</b><span>입원 3일 이내</span></div>
  <div class="mp-chip"><b id="mpInLead">–</b><span>상담 연결됨</span></div>
</div>

<div class="mp-bar">
  <input type="text" id="mpKw" placeholder="이름 또는 등록번호 일부">
  <label><input type="checkbox" id="mpNoTelOnly"> 보호자 연락처 없는 분만</label>
  <span id="mpCount"></span>
</div>

<div class="mp-card">
  <table>
    <thead><tr>
      <th style="width:44px;">번호</th><th>성명</th><th>등록번호</th><th>입원일</th><th style="text-align:right;">재원일수</th>
      <th>보호자</th><th>연락처</th><th>상담 단계</th>
    </tr></thead>
    <tbody id="mpBody"><tr><td colspan="8" class="mp-empty">불러오는 중…</td></tr></tbody>
  </table>
</div>

<script>
(function(){
  var root = document.getElementById('misPatient');
  var WNN = root.getAttribute('data-wnn') === 'Y';
  function g(id){ return document.getElementById(id); }
  function esc(s){ return (s==null?'':String(s)).replace(/[&<>"]/g, function(c){ return ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;'})[c]; }); }
  function num(n){ return Number(n||0).toLocaleString(); }
  function dtFmt(s){ s = String(s||'').replace(/[^0-9]/g,''); return s.length === 8 ? s.slice(0,4) + '.' + s.slice(4,6) + '.' + s.slice(6,8) : ''; }
  function err(e){ _alertBox((e && e.message) ? e.message : '처리 중 오류가 발생했습니다.', {icon:'❌'}); }
  function post(url, data){
    if (WNN) {
      var h = '';
      try { h = (getCookie('s_hospid') || '').trim(); } catch(e){}
      data.hospCd = h || root.getAttribute('data-hosp');
    }
    return $.ajax({ url:url, type:'POST', data:data, dataType:'json' }).then(function(res){
      if (res && res.result === 'FAIL') throw new Error(res.message || '처리에 실패했습니다.');
      return res;
    });
  }
  var STAGE = { '10':'상담', '20':'방문', '30':'입원 결정', '40':'입원', '50':'퇴원 후' };

  var ALL = [];
  function render(){
    var kw = g('mpKw').value.trim().toLowerCase();
    var only = g('mpNoTelOnly').checked;
    var rows = ALL.filter(function(p){
      if (only && p.hasTel) return false;
      if (!kw) return true;
      return String(p.patnm||'').toLowerCase().indexOf(kw) >= 0 || String(p.chartno||'').toLowerCase().indexOf(kw) >= 0;
    });
    g('mpCount').textContent = rows.length + '명 표시 (전체 ' + ALL.length + '명)';
    if (!rows.length) {
      g('mpBody').innerHTML = '<tr><td colspan="8" class="mp-empty">' + (ALL.length ? '조건에 맞는 환자가 없습니다.' : '재원 환자 자료가 없습니다. 입퇴원현황을 올렸는지 확인하세요.') + '</td></tr>';
      return;
    }
    g('mpBody').innerHTML = rows.map(function(p, i){
      var fresh = Number(p.staydays||0) <= 3 ? '<span class="mp-tag new">신규</span>' : '';
      var noTel = p.hasTel ? '' : '<span class="mp-tag bad">연락처 없음</span>';
      return '<tr>' +
        '<td class="num">' + (i + 1) + '</td>' +
        '<td><b>' + esc(p.patnm) + '</b>' + fresh + '</td>' +
        '<td>' + esc(p.chartno) + '</td>' +
        '<td>' + esc(dtFmt(p.ipdt)) + '</td>' +
        '<td class="num">' + num(p.staydays) + '일</td>' +
        '<td>' + (p.guardnm ? esc(p.guardnm) : '<span class="mp-none">—</span>') + '</td>' +
        '<td>' + (p.tel ? esc(p.tel) : '<span class="mp-none">없음</span>') + noTel + '</td>' +
        '<td>' + (p.stage ? esc(STAGE[String(p.stage)] || p.stage) : '—') + '</td>' +
        '</tr>';
    }).join('');
  }

  function load(){
    g('mpBody').innerHTML = '<tr><td colspan="8" class="mp-empty">불러오는 중…</td></tr>';
    post('/mis/patList.do', {}).then(function(d){
      ALL = d.pats || [];
      g('mpHosp').textContent = root.getAttribute('data-nm') || '';
      g('mpTotal').textContent = num(d.total);
      g('mpNoTel').textContent = num(d.noTel);
      g('mpNoTel').className = Number(d.noTel||0) > 0 ? 'bad' : '';
      g('mpFresh').textContent = num(d.fresh);
      g('mpInLead').textContent = num(d.inLead);
      render();
    }).catch(function(e){
      g('mpBody').innerHTML = '<tr><td colspan="8" class="mp-empty" style="color:#b23b3b;">불러오지 못했습니다. ' + esc(e && e.message) + '</td></tr>';
      err(e);
    });
  }

  g('mpKw').oninput = render;
  g('mpNoTelOnly').onchange = render;
  g('mpReload').onclick = load;
  load();
})();
</script>
</div>
</div>
