<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%-- misPatient.jsp — 경영고객관리 › 기존환자 (2026-10-15 · 기준 = 환자평가표)
     · 기준 : 환자평가표의 최근 평가월 입원 건. 같은 입원(생년월일 6 + 입원일)이 입퇴원현황에 있으면 재원/퇴원과 퇴원일을 붙인다.
     · 상태 : 재원(IN) · 퇴원(OUT, 퇴원일 표시) · 입퇴원 기록 없음(NONE).
     · 보호자 연락처는 병원자료엑셀연계, 상담은 신규환자 고객관리에서 생년월일 6 + 이름으로 맞춘다.
     · 조회 전용(새로 적는 칸 없음).
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
  #misPatient select{ border:1px solid #cfd8e0; border-radius:6px; padding:5px 8px; font-size:12px; background:#fff; font-family:inherit; }
  #misPatient .mp-btn{ border:1px solid #cfd9e0; background:#fff; color:#43555f; border-radius:6px; padding:5px 11px; font-size:12.5px; font-weight:700; cursor:pointer; text-decoration:none; white-space:nowrap; }
  #misPatient .mp-btn:hover{ background:#eef3f6; }
  #misPatient .mp-note{ background:#fff; border:1px solid #e3e9ed; border-radius:10px; padding:9px 14px; font-size:12.5px; color:#43555f; margin:10px 0 12px; line-height:1.6; }
  #misPatient .mp-chips{ display:flex; gap:8px; flex-wrap:wrap; margin-bottom:10px; }
  #misPatient .mp-chip{ background:#fff; border:1px solid #e3e9ed; border-radius:10px; padding:8px 12px; min-width:118px; text-align:left; cursor:pointer; font-family:inherit; }
  #misPatient .mp-chip:hover{ border-color:#9fc7b8; }
  #misPatient .mp-chip b{ display:block; font-size:19px; color:#1f5a4b; }
  #misPatient .mp-chip b.bad{ color:#b23b3b; }
  #misPatient .mp-chip b.warn{ color:#9a6a00; }
  #misPatient .mp-chip span{ font-size:11.5px; color:#6b7c86; }
  #misPatient .mp-bar{ display:flex; gap:10px; align-items:center; flex-wrap:wrap; margin-bottom:8px; font-size:11.5px; color:#43555f; }
  #misPatient #mpCount{ font-size:11.5px; color:#6b7c86; }
  #misPatient .mp-tabs{ display:flex; gap:6px; margin:0 0 8px; }
  #misPatient .mp-tab{ background:#eef2f5; border:1px solid #d5dee5; border-radius:8px; padding:7px 14px; font-size:12.5px; font-weight:700; color:#55646e; cursor:pointer; font-family:inherit; }
  #misPatient .mp-tab:hover{ background:#e2e9ee; }
  #misPatient .mp-tab.on{ background:#1f5a4b; border-color:#1f5a4b; color:#fff; box-shadow:0 1px 3px rgba(31,90,75,.25); }
  #misPatient .mp-tab b{ font-size:11.5px; font-weight:800; margin-left:4px; color:inherit; }
  #misPatient .mp-tab-note{ font-size:11.5px; color:#6b7c86; margin:-2px 0 8px; }
  /* 목록은 20명 높이만큼 보이고 나머지는 카드 안에서 스크롤(머리줄 고정) — 2026-10-15 */
  /* 안쪽 여백(padding)을 두면 스크롤된 행이 머리줄 위 여백에 보여 머리줄이 떠 보인다 → 여백은 표 바깥 래퍼가 맡는다 (2026-10-15) */
  #misPatient .mp-card{ background:#fff; border:1px solid #e3e9ed; border-radius:12px; padding:0; overflow-x:auto; overflow-y:auto; max-height:740px; }
  #misPatient thead th{ position:sticky; top:0; z-index:2; background:#f2f6f8; box-shadow:0 1px 0 #dde5ea; }
  #misPatient table{ width:100%; border-collapse:collapse; font-size:12.5px; min-width:900px; }
  #misPatient th{ background:#f2f6f8; color:#43555f; font-weight:800; padding:7px 8px; border-bottom:1px solid #dde5ea; text-align:left; white-space:nowrap; }
  #misPatient td{ padding:7px 8px; border-bottom:1px solid #eef2f5; vertical-align:middle; }
  #misPatient td.num{ text-align:right; font-variant-numeric:tabular-nums; }
  #misPatient .mp-tag{ display:inline-block; font-size:10.5px; font-weight:800; border-radius:8px; padding:0 6px; margin-left:4px; vertical-align:1px; white-space:nowrap; }
  #misPatient .mp-tag.bad{ background:#fde7e7; color:#b23b3b; }
  #misPatient .mp-tag.warn{ background:#fdf3d8; color:#8a5d00; }
  #misPatient .mp-tag.long{ background:#e6eefb; color:#2a4f8a; }
  #misPatient .mp-tag.new{ background:#e6f4ee; color:#1f5a4b; }
  #misPatient .mp-tag.in{ background:#e6f4ee; color:#1f5a4b; }
  #misPatient .mp-tag.out{ background:#eef1f3; color:#55646e; }
  #misPatient .mp-tag.none{ background:#fdf3d8; color:#8a5d00; }
  #misPatient .mp-none{ color:#b23b3b; font-weight:700; }
  #misPatient .mp-dim{ color:#8a99a3; }
  #misPatient .mp-empty{ padding:24px; text-align:center; color:#8a99a3; }
  #misPatient .mp-foot{ font-size:11.5px; color:#6b7c86; margin-top:8px; line-height:1.6; }
</style>

<div class="mp-head">
  <div class="mp-title"><span class="mp-dot"></span> 입퇴원환자 <span class="mp-sub">— 환자평가표 입원 건 기준 · 재원·퇴원·연락처·상담을 한눈에</span></div>
  <span class="mp-hosp" id="mpHosp"></span>
  <span class="mp-spacer"></span>
  <button type="button" class="mp-btn" id="mpXlsx" title="지금 보이는 목록을 엑셀 파일로">엑셀 저장</button>
  <button type="button" class="mp-btn" id="mpReload">↻ 다시 보기</button>
</div>

<div class="mp-note">
  기준은 <b>최근 평가월의 환자평가표 입원 건</b>입니다. 같은 입원(생년월일 6 + 입원일)이 <b>입퇴원현황</b>에 있으면 재원/퇴원과 퇴원일을 함께 보여 줍니다.
  입퇴원 기록이 없는 건은 「기록 없음」으로 표시합니다(입퇴원현황 업로드 누락 가능). 보호자 연락처는 <b>병원자료엑셀연계</b>, 상담은 <b>신규환자 고객관리</b>에서 생년월일 6 + 이름으로 맞춘 것입니다.
</div>

<div class="mp-chips">
  <button type="button" class="mp-chip" data-f="in"><b id="mpIn">–</b><span>재원 (입퇴원현황 기준)</span></button>
  <button type="button" class="mp-chip" data-f="out"><b id="mpOut">–</b><span>퇴원 확인</span></button>
  <button type="button" class="mp-chip" data-f="none"><b id="mpNone">–</b><span>입퇴원 기록 없음</span></button>
  <button type="button" class="mp-chip" data-f="long"><b id="mpLong">–</b><span>장기입원 (재원 181일↑)</span></button>
  <button type="button" class="mp-chip" data-f="notel"><b id="mpNoTel">–</b><span>보호자 연락처 없음</span></button>
  <button type="button" class="mp-chip" data-f="fresh"><b id="mpFresh">–</b><span>재원 3일 이내</span></button>
  <button type="button" class="mp-chip" data-f="inlead"><b id="mpInLead">–</b><span>상담 연결됨</span></button>
</div>

<div class="mp-tabs">
  <button type="button" class="mp-tab on" data-tab="eval">평가표 기준<b id="mpTabEval">–</b></button>
  <button type="button" class="mp-tab" data-tab="ipo">입원리스트만 있는 재원 (최근 6개월)<b id="mpTabIpo">–</b></button>
</div>
<div class="mp-tab-note" id="mpTabNote">환자평가표에 있는 입원 건 — 입퇴원현황과 맞춰 재원·퇴원을 보여 줍니다.</div>

<div class="mp-bar">
  <input type="text" id="mpKw" placeholder="이름 또는 등록번호 일부">
  <label>정렬
    <select id="mpSort">
      <option value="stay">재원 먼저 · 재원일수 많은 순</option>
      <option value="recent">입원일 최근순</option>
      <option value="name">성명순</option>
    </select>
  </label>
  <label><input type="checkbox" id="mpLongOnly"> 장기입원만</label>
  <label><input type="checkbox" id="mpNoTelOnly"> 보호자 연락처 없는 분만</label>
  <span id="mpCount"></span>
</div>

<div class="mp-card">
  <table>
    <thead><tr>
      <th style="width:44px;">번호</th><th>성명</th><th>등록번호</th><th>입원일</th><th>상태</th><th style="text-align:right;">재원일수</th>
      <th>환자군</th><th>평가표 작성일</th><th>보호자</th><th>연락처</th><th>상담 단계</th>
    </tr></thead>
    <tbody id="mpBody"><tr><td colspan="11" class="mp-empty">불러오는 중…</td></tr></tbody>
  </table>
</div>
<div class="mp-foot">
  장기입원 = 재원 181일 이상(적정성 장기입원 지표 대상). 90일 이내 재입원의 이전 입원일수 합산은 아직 반영하지 않습니다.
  환자군 = A 의료최고도 · B 의료고도 · C 의료중도 · D 의료경도 · E 선택입원군(환자평가표 기준).
  재원일수 = 재원은 오늘까지, 퇴원은 입원~퇴원일까지. 상담 단계는 신규환자 고객관리의 마지막 단계이며, 「상담 연결됨」은 같은 생년월일 6 + 이름으로 상담 기록이 있는 경우입니다.
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
  // 환자군(환자평가표 PAT_CLASS 첫 글자) — 요양병원 환자분류체계 순서(의료최고도~선택입원군)를 A~E 로 본다(2026-10-15)
  var CLS_NM = { A:'의료최고도', B:'의료고도', C:'의료중도', D:'의료경도', E:'선택입원군' };
  function clsName(c){ var k = String(c||'').charAt(0).toUpperCase(); return CLS_NM[k] || ''; }
  var STAGE = { '10':'상담', '20':'방문', '30':'입원 결정', '40':'입원', '50':'퇴원 후' };
  var STATUS = { IN:'재원', OUT:'퇴원', NONE:'기록 없음' };
  var FILTER = 'all';   // 칩 — all · in · out · none · long · notel · fresh · inlead

  var ALL = [];   // 평가표 기준 목록
  var IPO = [];   // 입원리스트만 있는 재원 목록 (평가표에 같은 입원이 없는 건)
  var TAB = 'eval';
  function src(){ return TAB === 'ipo' ? IPO : ALL; }
  function fillChips(list){
    var c = { in:0, out:0, none:0, long:0, notel:0, fresh:0, inlead:0 };
    list.forEach(function(p){
      var st = p.ipstatus || 'NONE';
      if (st === 'IN') c.in++; else if (st === 'OUT') c.out++; else c.none++;
      if (p.isLong) c.long++;
      if (!p.hasTel) c.notel++;
      if (st === 'IN' && Number(p.staydays||0) <= 3) c.fresh++;
      if (p.hasLead) c.inlead++;
    });
    g('mpIn').textContent = num(c.in);
    g('mpOut').textContent = num(c.out);
    g('mpNone').textContent = num(c.none);
    g('mpNone').className = c.none > 0 ? 'warn' : '';
    g('mpLong').textContent = num(c.long);
    g('mpLong').className = c.long > 0 ? 'warn' : '';
    g('mpNoTel').textContent = num(c.notel);
    g('mpNoTel').className = c.notel > 0 ? 'bad' : '';
    g('mpFresh').textContent = num(c.fresh);
    g('mpInLead').textContent = num(c.inlead);
  }
  function visible(){
    var kw = g('mpKw').value.trim().toLowerCase();
    var sort = g('mpSort').value;
    var longOnly = g('mpLongOnly').checked, noTelOnly = g('mpNoTelOnly').checked;
    var rows = src().filter(function(p){
      var st = p.ipstatus || 'NONE';
      if (FILTER === 'in' && st !== 'IN') return false;
      if (FILTER === 'out' && st !== 'OUT') return false;
      if (FILTER === 'none' && st !== 'NONE') return false;
      if (FILTER === 'long' && !p.isLong) return false;
      if (FILTER === 'notel' && p.hasTel) return false;
      if (FILTER === 'fresh' && !(st === 'IN' && Number(p.staydays||0) <= 3)) return false;
      if (FILTER === 'inlead' && !p.hasLead) return false;
      if (longOnly && !p.isLong) return false;
      if (noTelOnly && p.hasTel) return false;
      if (!kw) return true;
      return String(p.patnm||'').toLowerCase().indexOf(kw) >= 0 || String(p.chartno||'').toLowerCase().indexOf(kw) >= 0;
    });
    var rank = { IN:0, NONE:1, OUT:2 };
    rows.sort(function(a, b){
      var ra = rank[a.ipstatus||'NONE'], rb = rank[b.ipstatus||'NONE'];
      if (sort === 'recent') return String(b.ipdt).localeCompare(String(a.ipdt));
      if (sort === 'name') return String(a.patnm||'').localeCompare(String(b.patnm||''), 'ko');
      return (ra - rb) || (Number(b.staydays||0) - Number(a.staydays||0)) || String(b.ipdt).localeCompare(String(a.ipdt));
    });
    return rows;
  }
  function statusCell(p){
    var st = p.ipstatus || 'NONE';
    if (st === 'IN') return '<span class="mp-tag in">재원</span>';
    if (st === 'OUT') return '<span class="mp-tag out">퇴원 ' + esc(dtFmt(p.outdt)) + '</span>';
    return '<span class="mp-tag none">기록 없음</span>';
  }
  function render(){
    var rows = visible();
    fillChips(src());
    g('mpCount').textContent = rows.length + '명 표시 (전체 ' + src().length + '명)';
    document.querySelectorAll('#misPatient .mp-chip').forEach(function(b){ b.style.borderColor = b.getAttribute('data-f') === FILTER ? '#1f5a4b' : ''; });
    document.querySelectorAll('#misPatient .mp-tab').forEach(function(b){ b.classList.toggle('on', b.getAttribute('data-tab') === TAB); });
    g('mpTabNote').textContent = TAB === 'ipo'
      ? '최근 6개월 안에 입원했고 입퇴원현황에는 재원인데 환자평가표에 같은 입원이 없는 건입니다. 평가 작성이 빠졌거나 평가 대상이 아닌지 확인하세요.'
      : '환자평가표에 있는 입원 건 — 입퇴원현황과 맞춰 재원·퇴원을 보여 줍니다.';
    if (!rows.length) {
      g('mpBody').innerHTML = '<tr><td colspan="11" class="mp-empty">' + (src().length ? '조건에 맞는 환자가 없습니다.' : (TAB === 'ipo' ? '입원리스트에만 있는 재원 환자가 없습니다.' : '환자평가표 입원 건이 없습니다. 평가표를 올렸는지 확인하세요.')) + '</td></tr>';
      return;
    }
    g('mpBody').innerHTML = rows.map(function(p, i){
      var st = p.ipstatus || 'NONE';
      var fresh = (st === 'IN' && Number(p.staydays||0) <= 3) ? '<span class="mp-tag new">신규</span>' : '';
      var longTag = p.isLong ? '<span class="mp-tag long">장기</span>' : '';
      var noTel = p.hasTel ? '' : '<span class="mp-tag bad">연락처 없음</span>';
      return '<tr>' +
        '<td class="num">' + (i + 1) + '</td>' +
        '<td><b>' + esc(p.patnm) + '</b>' + fresh + '</td>' +
        '<td>' + (p.chartno ? esc(p.chartno) : '<span class="mp-dim">—</span>') + '</td>' +
        '<td>' + esc(dtFmt(p.ipdt)) + '</td>' +
        '<td>' + statusCell(p) + '</td>' +
        '<td class="num">' + (p.staydays != null ? num(p.staydays) + '일' : '<span class="mp-dim">—</span>') + longTag + '</td>' +
        '<td>' + (p.patclass ? esc(p.patclass) + ' <span class="mp-dim">' + esc(clsName(p.patclass)) + '</span>' : '<span class="mp-dim">—</span>') + '</td>' +
        '<td>' + (p.docdt ? esc(dtFmt(p.docdt)) : (TAB === 'ipo' ? '<span class="mp-tag warn">평가표 없음</span>' : '<span class="mp-dim">—</span>')) + '</td>' +
        '<td>' + (p.guardnm ? esc(p.guardnm) : '<span class="mp-none">—</span>') + '</td>' +
        '<td>' + (p.tel ? esc(p.tel) : '<span class="mp-none">없음</span>') + noTel + '</td>' +
        '<td>' + (p.stage ? esc(STAGE[String(p.stage)] || p.stage) : '<span class="mp-dim">—</span>') + '</td>' +
        '</tr>';
    }).join('');
  }

  /* 엑셀 — 지금 보이는 목록 그대로. xlsx 는 header.jsp 가 defer 로 싣는다 → 아직 안 왔으면 안내만 */
  g('mpXlsx').onclick = function(){
    if (typeof XLSX === 'undefined') { _alertBox('엑셀 기능을 아직 불러오지 못했습니다. 잠시 뒤 다시 눌러 주세요.', {icon:'⚠️'}); return; }
    var rows = visible();
    var data = [['번호','성명','등록번호','입원일','상태','퇴원일','재원일수','장기입원','환자군','평가표 작성일','보호자','연락처','상담 단계']];
    rows.forEach(function(p, i){
      data.push([i + 1, p.patnm, p.chartno || '', dtFmt(p.ipdt), STATUS[p.ipstatus || 'NONE'], dtFmt(p.outdt), p.staydays != null ? Number(p.staydays) : '', p.isLong ? 'Y' : '', p.patclass ? p.patclass + ' ' + clsName(p.patclass) : '', dtFmt(p.docdt), p.guardnm || '', p.tel || '', p.stage ? (STAGE[String(p.stage)] || p.stage) : '']);
    });
    var wb = XLSX.utils.book_new();
    XLSX.utils.book_append_sheet(wb, XLSX.utils.aoa_to_sheet(data), '기존환자');
    var nm = (root.getAttribute('data-nm') || 'hosp').replace(/[\\\/:*?"<>|]/g, '_');
    XLSX.writeFile(wb, '기존환자_' + nm + '_' + new Date().toISOString().slice(0,10) + '.xlsx');
  };

  function load(){
    g('mpBody').innerHTML = '<tr><td colspan="11" class="mp-empty">불러오는 중…</td></tr>';
    post('/mis/patList.do', {}).then(function(d){
      ALL = d.pats || [];
      IPO = d.ipOnly || [];
      g('mpHosp').textContent = root.getAttribute('data-nm') || '';
      g('mpTabEval').textContent = num(ALL.length);
      g('mpTabIpo').textContent = num(IPO.length);
      render();
    }).catch(function(e){
      g('mpBody').innerHTML = '<tr><td colspan="11" class="mp-empty" style="color:#b23b3b;">불러오지 못했습니다. ' + esc(e && e.message) + '</td></tr>';
      err(e);
    });
  }

  document.querySelectorAll('#misPatient .mp-tab').forEach(function(b){
    b.onclick = function(){ TAB = b.getAttribute('data-tab'); FILTER = 'all'; render(); };
  });
  document.querySelectorAll('#misPatient .mp-chip').forEach(function(b){
    b.onclick = function(){ FILTER = (FILTER === b.getAttribute('data-f')) ? 'all' : b.getAttribute('data-f'); render(); };
  });
  g('mpKw').oninput = render;
  g('mpSort').onchange = render;
  g('mpLongOnly').onchange = render;
  g('mpNoTelOnly').onchange = render;
  g('mpReload').onclick = load;
  load();
})();
</script>
</div>
</div>
