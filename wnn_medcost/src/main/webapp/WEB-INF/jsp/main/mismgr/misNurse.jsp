<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%-- misNurse.jsp — 경영고객관리 › 간호사 관리 (2026-10-15)
     · 요양병원은 인력 변동이 잦고 관리 인력이 부족하다는 전제. 그래서 이 화면은 두 가지만 본다.
         ① 인력 변동 기록 — 입사 · 퇴사 · 이동을 날짜별로 적는다(새 표 TBL_MIS_STAFF_CHG).
         ② 인력 판정 — 재원 환자 수 ÷ 간호사 수 = 1인당 환자 수, 5점 구간 상한과 비교해 필요 인원·부족 인원을 낸다.
     · 재직 명단은 직원 자료(병원자료엑셀연계 › 직원·근무, TBL_MIS_EMR_STAFF)에서 읽는다. 없으면 변동 기록의 입사 − 퇴사로 추정.
     · 1인당 환자 수 기준은 인력 시뮬레이션과 같다(간호사 구간 TBL_WEVALUE_MST, 5점 구간의 상한).
     · 지운 기록은 사라지지 않고 표식만 바뀐다.
     · 알림은 ui-message. ★주의: 이 파일 안에서 Deferred EL 표기(샵+중괄호) 금지 --%>

<script src="/asset/js/ui-message.js"></script>

<div class="dashboard-wrapper">
<div id="misNurse" data-wnn="<c:out value='${wnnYn}'/>" data-hosp="<c:out value='${hospCd}'/>" data-nm="<c:out value='${hospNm}'/>">
<style>
  #misNurse{ background:#f4f6f8; color:#1f2a30; min-height:100%; padding:14px 16px 50px; max-width:100%; overflow-x:hidden; }
  #misNurse *{ box-sizing:border-box; }
  #misNurse .mn-head{ display:flex; align-items:center; gap:10px; margin-bottom:6px; flex-wrap:wrap; }
  #misNurse .mn-title{ font-size:18px; font-weight:800; color:#20303a; display:flex; align-items:center; gap:8px; }
  #misNurse .mn-dot{ width:10px; height:10px; border-radius:50%; background:linear-gradient(135deg,#1f5a4b,#2a7665); }
  #misNurse .mn-sub{ font-size:12px; color:#6b7c86; font-weight:400; }
  #misNurse .mn-hosp{ background:#e7f3ee; color:#1f5a4b; font-size:12px; font-weight:800; border:1px solid #cfe3da; border-radius:14px; padding:3px 11px; }
  #misNurse .mn-spacer{ flex:1; }
  #misNurse input, #misNurse select{ border:1px solid #cfd8e0; border-radius:6px; padding:5px 8px; font-size:13px; background:#fff; font-family:inherit; }
  #misNurse .mn-btn{ border:1px solid #cfd9e0; background:#fff; color:#43555f; border-radius:6px; padding:5px 11px; font-size:12.5px; font-weight:700; cursor:pointer; white-space:nowrap; }
  #misNurse .mn-btn:hover{ background:#eef3f6; }
  #misNurse .mn-btn.pri{ background:#1f5a4b; color:#fff; border-color:#1f5a4b; }
  #misNurse .mn-btn.pri:hover{ background:#2a7665; }
  #misNurse .mn-btn.del{ color:#b23b3b; padding:2px 8px; font-size:12px; }
  #misNurse .mn-note{ background:#fff; border:1px solid #e3e9ed; border-radius:10px; padding:9px 14px; font-size:12.5px; color:#43555f; margin:10px 0 12px; line-height:1.6; }
  #misNurse .mn-note.warn{ background:#fff7e6; border-color:#f1d9a6; color:#7a5a12; }
  #misNurse .mn-judge{ display:grid; grid-template-columns:repeat(auto-fit,minmax(150px,1fr)); gap:8px; margin-bottom:12px; }
  #misNurse .mn-jbox{ background:#fff; border:1px solid #e3e9ed; border-radius:10px; padding:10px 12px; }
  #misNurse .mn-jbox span{ display:block; font-size:11.5px; color:#6b7c86; }
  #misNurse .mn-jbox b{ font-size:20px; color:#1f5a4b; }
  #misNurse .mn-jbox b.bad{ color:#b23b3b; }
  #misNurse .mn-jbox b small{ font-size:12px; color:#6b7c86; margin-left:3px; font-weight:700; }
  #misNurse .mn-cols{ display:grid; grid-template-columns:minmax(0,1fr) minmax(0,1.25fr); gap:12px; align-items:start; }
  @media (max-width:1000px){ #misNurse .mn-cols{ grid-template-columns:1fr; } }
  #misNurse .mn-card{ background:#fff; border:1px solid #e3e9ed; border-radius:12px; padding:12px 14px; min-width:0; }
  #misNurse .mn-card h4{ margin:0 0 8px; font-size:13px; color:#43555f; font-weight:800; display:flex; gap:8px; align-items:center; flex-wrap:wrap; }
  #misNurse .mn-card h4 .sp{ flex:1; }
  #misNurse .mn-scroll{ overflow-x:auto; max-height:420px; overflow-y:auto; }
  #misNurse table{ width:100%; border-collapse:collapse; font-size:12.5px; }
  #misNurse th{ background:#f2f6f8; color:#43555f; font-weight:800; padding:6px 7px; border-bottom:1px solid #dde5ea; text-align:left; white-space:nowrap; position:sticky; top:0; }
  #misNurse td{ padding:6px 7px; border-bottom:1px solid #eef2f5; vertical-align:middle; }
  #misNurse .mn-tag{ display:inline-block; font-size:10.5px; font-weight:800; border-radius:8px; padding:0 6px; }
  #misNurse .mn-tag.in{ background:#e6f4ee; color:#1f5a4b; }
  #misNurse .mn-tag.out{ background:#fde7e7; color:#b23b3b; }
  #misNurse .mn-tag.move{ background:#eef3f6; color:#43555f; }
  #misNurse .mn-form{ display:grid; grid-template-columns:repeat(auto-fit,minmax(130px,1fr)); gap:8px; align-items:end; }
  #misNurse .mn-form label{ display:flex; flex-direction:column; gap:3px; font-size:11.5px; color:#6b7c86; font-weight:700; }
  #misNurse .mn-form .wide{ grid-column:1 / -1; }
  #misNurse .mn-form input, #misNurse .mn-form select{ width:100%; }
  #misNurse .mn-empty{ padding:18px; text-align:center; color:#8a99a3; font-size:12.5px; }
</style>

<div class="mn-head">
  <div class="mn-title"><span class="mn-dot"></span> 간호사 관리 <span class="mn-sub">— 인력 변동 기록 · 1인당 환자 수 · 부족 인원</span></div>
  <span class="mn-hosp" id="mnHosp"></span>
  <span class="mn-spacer"></span>
  <button type="button" class="mn-btn" id="mnReload">↻ 다시 보기</button>
</div>

<div class="mn-judge" id="mnJudge"><div class="mn-jbox"><span>불러오는 중</span><b>–</b></div></div>
<div class="mn-note" id="mnNote" hidden></div>

<div class="mn-cols">

  <!-- 왼쪽: 재직 명단 -->
  <div class="mn-card">
    <h4>재직 간호 인력 명단 <span class="sp"></span><span class="mn-sub" id="mnRosterCnt"></span></h4>
    <div class="mn-scroll">
      <table>
        <thead><tr><th>성명</th><th>직종</th><th>병동·부서</th><th>입사일</th></tr></thead>
        <tbody id="mnRoster"><tr><td colspan="4" class="mn-empty">불러오는 중…</td></tr></tbody>
      </table>
    </div>
  </div>

  <!-- 오른쪽: 인력 변동 기록 -->
  <div class="mn-card">
    <h4>인력 변동 기록 <span class="sp"></span><span class="mn-sub">입사 · 퇴사 · 이동을 날짜별로</span></h4>
    <div class="mn-form">
      <label>변동일<input type="date" id="mnDt"></label>
      <label>구분
        <select id="mnGb">
          <option value="IN">입사</option>
          <option value="OUT">퇴사</option>
          <option value="MOVE">이동</option>
        </select>
      </label>
      <label>성명<input type="text" id="mnNm" maxlength="50" placeholder="예) 홍길동"></label>
      <label>직종
        <select id="mnJob">
          <option value="간호사">간호사</option>
          <option value="간호조무사">간호조무사</option>
          <option value="요양보호사">요양보호사</option>
          <option value="기타">기타</option>
        </select>
      </label>
      <label>병동·부서<input type="text" id="mnWard" maxlength="30" placeholder="예) A1병동"></label>
      <label class="wide">메모<input type="text" id="mnMemo" maxlength="200" placeholder="사유 등 (선택)"></label>
      <div class="wide" style="text-align:right;"><button type="button" class="mn-btn pri" id="mnSave">＋ 기록 저장</button></div>
    </div>
    <div class="mn-scroll" style="margin-top:10px; max-height:320px;">
      <table>
        <thead><tr><th>변동일</th><th>구분</th><th>성명</th><th>직종</th><th>병동</th><th>메모</th><th></th></tr></thead>
        <tbody id="mnChgs"><tr><td colspan="7" class="mn-empty">불러오는 중…</td></tr></tbody>
      </table>
    </div>
  </div>
</div>

<script>
(function(){
  var root = document.getElementById('misNurse');
  var WNN = root.getAttribute('data-wnn') === 'Y';
  function g(id){ return document.getElementById(id); }
  function esc(s){ return (s==null?'':String(s)).replace(/[&<>"]/g, function(c){ return ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;'})[c]; }); }
  function num(n){ return Number(n||0).toLocaleString(); }
  function dtFmt(s){ s = String(s||'').replace(/[^0-9]/g,''); return s.length === 8 ? s.slice(0,4) + '.' + s.slice(4,6) + '.' + s.slice(6,8) : ''; }
  function todayIso(){
    var d = new Date(), m = ('0' + (d.getMonth() + 1)).slice(-2), day = ('0' + d.getDate()).slice(-2);
    return d.getFullYear() + '-' + m + '-' + day;
  }
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
  var GB = { IN:'입사', OUT:'퇴사', MOVE:'이동' };

  function drawJudge(d){
    var sh = Number(d.short||0), top = Number(d.top||0);
    var grade = d.headSrc === 'grade';
    var none = d.headSrc === 'none';
    var cnt = function(v){ return v == null ? '–' : num(v) + '<small>명</small>'; };
    var boxes = [
      ['간호사 재직' + (grade ? ' (신고)' : ''), grade ? (d.headcountRaw == null ? '–' : d.headcountRaw + '<small>명</small>') : cnt(d.headcount), false],
      [grade ? '평균 재원 (신고)' : '재원 환자', grade ? (d.census == null ? '–' : d.census + '<small>명</small>') : cnt(d.pats), false],
      ['1인당 환자 수', (d.ratio != null ? d.ratio + '<small>명</small>' : '–'), false],
      ['5점 구간 상한', (top > 0 ? top + '<small>명</small>' : '–'), false],
      ['필요 인원', cnt(d.required), false],
      ['부족 인원', none || d.short == null ? '–' : (sh > 0 ? num(sh) + '<small>명</small>' : '없음'), sh > 0]
    ];
    g('mnJudge').innerHTML = boxes.map(function(b){
      return '<div class="mn-jbox"><span>' + b[0] + '</span><b class="' + (b[2] ? 'bad' : '') + '">' + b[1] + '</b></div>';
    }).join('');
    var notes = [];
    if (grade) notes.push('구조영역 기준 — ' + (d.headLabel || '차등제 신고') + '의 간호사 ' + d.headcountRaw + '명, 평균 재원 ' + d.census + '명으로 적정성 1인당 환자수와 같은 계산입니다.');
    else notes.push('차등제 신고값이 없어 구조영역 간호사 수를 계산할 수 없습니다. 차등제 신고(병원 정보 › 차등제)를 입력하면 자동으로 계산됩니다.');
    if (!top) notes.push('간호사 구간 기준(5점 구간 상한)을 찾지 못해 필요 인원을 계산하지 못했습니다.');
    if (sh > 0) notes.push((grade ? '평균 재원' : '지금 재원 환자') + ' 기준으로 간호사가 ' + sh + '명 더 필요합니다(5점 기준). 충원 계획을 함께 적어 두세요.');
    var nb = g('mnNote');
    nb.hidden = !notes.length;
    nb.className = 'mn-note' + (notes.length ? ' warn' : '');
    nb.innerHTML = notes.map(esc).join('<br>');
  }

  function drawRoster(d){
    var rs = d.roster || [];
    g('mnRosterCnt').textContent = '간호사 ' + num(d.nurses) + '명 · 간호조무사 등 ' + num(d.aides) + '명';
    g('mnRoster').innerHTML = rs.length ? rs.map(function(r){
      return '<tr><td><b>' + esc(r.empnm) + '</b></td><td>' + esc(r.jobnm) + '</td><td>' + esc(r.deptnm) + '</td><td>' + esc(dtFmt(r.joindt)) + '</td></tr>';
    }).join('') : '<tr><td colspan="4" class="mn-empty">직원 명단이 없습니다. 병원자료엑셀연계에서 직원·근무 자료를 올리면 여기에 나옵니다.</td></tr>';
  }

  function drawChgs(d){
    var cs = d.chgs || [];
    g('mnChgs').innerHTML = cs.length ? cs.map(function(c){
      var gb = String(c.chggb||'');
      return '<tr>' +
        '<td>' + esc(dtFmt(c.chgdt)) + '</td>' +
        '<td><span class="mn-tag ' + gb.toLowerCase() + '">' + (GB[gb] || esc(gb)) + '</span></td>' +
        '<td><b>' + esc(c.staffnm) + '</b></td>' +
        '<td>' + esc(c.jobnm) + '</td>' +
        '<td>' + esc(c.wardnm) + '</td>' +
        '<td>' + esc(c.memo) + '</td>' +
        '<td><button type="button" class="mn-btn del" data-seq="' + esc(c.chgseq) + '">지우기</button></td>' +
        '</tr>';
    }).join('') : '<tr><td colspan="7" class="mn-empty">이 해에 적은 변동 기록이 없습니다.</td></tr>';
  }

  function load(){
    post('/mis/nurseGet.do', {}).then(function(d){
      g('mnHosp').textContent = root.getAttribute('data-nm') || '';
      drawJudge(d);
      drawRoster(d);
      drawChgs(d);
    }).catch(function(e){
      g('mnChgs').innerHTML = '<tr><td colspan="7" class="mn-empty" style="color:#b23b3b;">불러오지 못했습니다. ' + esc(e && e.message) + '</td></tr>';
      err(e);
    });
  }

  g('mnSave').onclick = function(){
    var data = {
      chgDt: g('mnDt').value,
      chgGb: g('mnGb').value,
      staffNm: g('mnNm').value,
      jobNm: g('mnJob').value,
      wardNm: g('mnWard').value,
      memo: g('mnMemo').value
    };
    if (!data.chgDt) { _alertBox('변동일을 적어 주세요.', {icon:'📅'}); return; }
    if (!data.staffNm.trim()) { _alertBox('성명을 적어 주세요.', {icon:'✏️'}); return; }
    post('/mis/nurseSave.do', data).then(function(){
      _toast('변동 기록을 저장했습니다.', 'info');
      g('mnNm').value = '';
      g('mnMemo').value = '';
      load();
    }).catch(err);
  };

  g('mnChgs').onclick = function(ev){
    var b = ev.target.closest && ev.target.closest('button[data-seq]');
    if (!b) return;
    var seq = b.getAttribute('data-seq');
    _confirmBox({
      msg: '이 변동 기록을 지울까요?<br><span style="font-size:12px;color:#6b7c86;">지운 기록은 사라지지 않고 목록에서만 숨겨집니다.</span>',
      icon: '🗑', okText: '지우기', okColor: '#b23b3b',
      onOk: function(){
        post('/mis/nurseDel.do', { chgSeq: seq }).then(function(){
          _toast('지웠습니다.', 'info');
          load();
        }).catch(err);
      }
    });
  };

  g('mnDt').value = todayIso();
  g('mnReload').onclick = load;
  load();
})();
</script>
</div>
</div>
