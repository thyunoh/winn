<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%-- qpsChkForm.jsp — 점검표 서식 관리(템플릿) (2026-08-11)

     ★★이 화면이 점검표 엔진의 핵심이다.
       간호/병동 메뉴 150여 개 중 실물은 20종뿐이고 나머지는 이름만 있다.
       그런데 그 이름 대부분이 `…점검표 / 점검대장 / 점검일지 / 관리대장`이다 — 같은 격자다.
       ⇒ ***화면을 130개 만들 일이 아니라, 여기서 서식을 등록하면 새 점검표가 생긴다.***

     ★축(AXIS_GB)이 표의 모양을 정한다 — 실물에서 관찰된 4가지만 둔다(추측으로 늘리지 않는다):
       EQUIP_DAY  기기 N행 × 1~31일    (원심분리기·인퓨전펌프·EKG모니터)
       ITEM_DAY   점검항목 행 × 1~31일  (EKG 일일·E.O gas 일상·네블라이저)
       DAY_ITEM   1~31일 행 × 점검항목 열 (Biological Dry Incubator·의료기기일일)
       ITEM_MONTH 점검항목 행 × 1~12월  (낙상 시설,환경 관리일지)

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
</style>

<div class="cf-head">
  <div class="cf-title"><span class="cf-dot"></span>점검표 서식 관리
    <span class="cf-sub">— 여기에 등록하면 [점검표 작성]에 새 서식이 생깁니다</span></div>
  <span class="cf-hosp" id="cfHosp">🏥 <c:out value="${hospNm}" default="병원 미확인"/></span>
  <div class="cf-spacer"></div>
  <select id="cfCate" style="width:auto;" onchange="cfList();">
    <option value="">전체 분류</option>
  </select>
  <button type="button" class="cf-btn" onclick="cfSave();">저장</button>
  <button type="button" class="cf-btn warn" id="cfDelBtn" onclick="cfDel();" style="display:none;">기본으로 되돌리기</button>
  <span class="cf-sub" id="cfStat"></span>
  <span style="flex:0 0 60px;"></span>
</div>

<div class="cf-wrap">
  <div class="cf-left">
    <div class="cf-card">
      <h4>서식 목록 <span class="hint" id="cfCnt"></span></h4>
      <div class="cf-list" id="cfListBox"><div class="cf-empty">불러오는 중…</div></div>
      <button type="button" class="cf-btn ghost" style="width:100%; margin-top:6px;" onclick="cfNew();">＋ 새 서식</button>
    </div>
  </div>

  <div class="cf-right">
    <div class="cf-card">
      <h4>서식 정의</h4>
      <div class="infobox" id="cfOwnMsg" style="display:none;"></div>
      <div class="cf-form">
        <div class="lb">서식코드 *</div>
        <div><input type="text" id="f_formId" maxlength="30" placeholder="영문 대문자·숫자·_ (예: O2TANK)"></div>
        <div class="lb">분류</div>
        <div><select id="f_cateCd"><option value="">— 선택 —</option></select></div>

        <div class="lb">서식명 *</div>
        <div class="full"><input type="text" id="f_formNm" maxlength="200" placeholder="원본 문서명 그대로 (예: O2탱크 점검대장)"></div>

        <div class="lb">표 모양 *</div>
        <div class="full" style="display:flex; gap:8px; align-items:center; flex-wrap:wrap;">
          <select id="f_axisGb" style="width:auto; min-width:340px;" onchange="cfAxisChange();">
            <option value="ITEM_DAY">점검항목(행) × 1~31일(열) — 가장 흔함</option>
            <option value="DAY_ITEM">1~31일(행) × 점검항목(열)</option>
            <option value="EQUIP_DAY">기기 N대(행) × 1~31일(열) — 항목은 표 위 안내로</option>
            <option value="ITEM_MONTH">점검항목(행) × 1~12월(열) — 연 1장</option>
          </select>
          <span id="f_equipWrap" style="display:none; font-size:12.5px; color:#43555f;">
            기기 행 수 <input type="number" id="f_equipCnt" min="1" max="50" value="10" style="width:70px;">
          </span>
        </div>

        <div class="lb">표 위 안내</div>
        <div class="full"><input type="text" id="f_guideTxt" maxlength="200" placeholder="예) 정상 : O 비정상 : X"></div>
        <div class="lb">상단 자유칸</div>
        <div class="full"><input type="text" id="f_headNms" maxlength="300" placeholder="쉼표로. 예) 장비명,모델명,사용부서,점검주기"></div>

        <div class="lb">덧붙일 칸</div>
        <div class="full" style="display:flex; gap:16px; flex-wrap:wrap; padding-top:6px;">
          <label style="font-size:12.5px;"><input type="checkbox" id="f_signerYn" style="vertical-align:-2px;"> 점검자 사인 행</label>
          <label style="font-size:12.5px;"><input type="checkbox" id="f_noteYn" style="vertical-align:-2px;"> 특이사항</label>
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
        <th style="width:130px;">열 묶음</th>
        <th style="width:90px;">입력</th>
        <th style="width:56px;">단위</th>
        <th style="width:44px;">이동</th>
        <th style="width:26px;"></th>
      </tr></thead><tbody id="tbITEM"></tbody></table>
      <button type="button" class="cf-btn mini" style="margin-top:6px;" onclick="cfAddItem();">＋ 항목 추가</button>
      <span class="cf-sub" style="margin-left:8px;">빈 줄은 저장할 때 버려집니다.</span>
    </div>

    <div class="cf-card">
      <h4>미리보기 <span class="hint">— 실제 작성 화면과 같은 모양(앞 5칸만)</span></h4>
      <div class="prev" id="cfPrev"></div>
    </div>
  </div>
</div>

<script>
(function(){
  var HOSP_NM = '', CATE = [], LIST = [], curId = '', curOwn = 'N';

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

  var AXIS_NM = { ITEM_DAY:'항목 × 일', DAY_ITEM:'일 × 항목', EQUIP_DAY:'기기 × 일', ITEM_MONTH:'항목 × 월' };

  /** 축이 바뀌면 뜻이 달라지는 칸을 안내한다 — 안 하면 「열 묶음」이 왜 안 보이는지 모른다. */
  window.cfAxisChange = function(){
    var a = axis();
    gel('f_equipWrap').style.display = (a === 'EQUIP_DAY') ? '' : 'none';
    var h = gel('cfItemHint');
    h.textContent = (a === 'EQUIP_DAY') ? '— 이 축에서는 항목이 표 위 안내박스로만 나옵니다(셀은 기기별 일별)'
                  : (a === 'DAY_ITEM')  ? '— 항목이 표의 **열**이 됩니다. 「열 묶음」을 적으면 2단 머리글이 생깁니다'
                  : (a === 'ITEM_MONTH')? '— 항목이 행, 1~12월이 열입니다(연 1장)'
                                        : '— 항목이 표의 **행**이 됩니다';
    // 열 묶음은 DAY_ITEM 에서만 뜻이 있다
    document.querySelectorAll('#tbITEM [data-f="grpnm"]').forEach(function(el){
      el.disabled = (a !== 'DAY_ITEM');
      el.placeholder = (a === 'DAY_ITEM') ? '예) 치료실 환경' : '(이 축에선 안 씀)';
    });
    renderPrev();
  };

  function itemRow(r){
    r = r || {};
    var tr = document.createElement('tr');
    tr.innerHTML =
      '<td style="text-align:center;color:#8a99a3;" data-no></td>' +
      '<td><input data-f="itemnm" value="' + esc(r.itemnm) + '" placeholder="점검항목 문구"></td>' +
      '<td><input data-f="grpnm" value="' + esc(r.grpnm) + '"></td>' +
      '<td><select data-f="inputgb">' +
        '<option value="CHECK"' + (r.inputgb === 'TEXT' || r.inputgb === 'NUM' ? '' : ' selected') + '>O / X</option>' +
        '<option value="TEXT"' + (r.inputgb === 'TEXT' ? ' selected' : '') + '>글자</option>' +
        '<option value="NUM"' + (r.inputgb === 'NUM' ? ' selected' : '') + '>숫자</option>' +
      '</select></td>' +
      '<td><input data-f="unitnm" value="' + esc(r.unitnm) + '" placeholder="℃"></td>' +
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
      tr.querySelectorAll('[data-f]').forEach(function(el){ r[el.getAttribute('data-f')] = String(el.value).trim(); });
      if (!r.itemnm) return;
      out.push(r);
    });
    return out;
  }

  /** ★미리보기 — 작성 화면과 **같은 규칙**으로 그린다. 여기서 모양이 이상하면 작성 화면도 이상하다. */
  function renderPrev(){
    var a = axis(), items = readItems(), box = gel('cfPrev');
    var DAYS = [1,2,3,4,5], MONS = [1,2,3,4,5];
    var h = '';
    if (a === 'EQUIP_DAY') {
      var n = Math.min(3, Math.max(1, Number(val('f_equipCnt') || 10)));
      h += items.length ? ('<div style="font-size:10.5px;color:#43555f;margin-bottom:4px;">점검항목 : ' +
            items.map(function(r, i){ return (i + 1) + '.' + esc(r.itemnm); }).join(' &nbsp; ') + '</div>') : '';
      h += '<table><thead><tr><th style="min-width:120px;">의료기기</th>' +
           DAYS.map(function(d){ return '<th style="width:26px;">' + d + '</th>'; }).join('') + '<th>…</th></tr></thead><tbody>';
      for (var i = 1; i <= n; i++) h += '<tr><td class="l">의료기기 ' + i + '</td>' + DAYS.map(function(){ return '<td></td>'; }).join('') + '<td></td></tr>';
      if (chk('f_signerYn') === 'Y') h += '<tr><td class="l">점검자 확인란</td>' + DAYS.map(function(){ return '<td></td>'; }).join('') + '<td></td></tr>';
      h += '</tbody></table>';
    } else if (a === 'ITEM_DAY' || a === 'ITEM_MONTH') {
      var cols = (a === 'ITEM_MONTH') ? MONS : DAYS, suf = (a === 'ITEM_MONTH') ? '월' : '';
      h += '<table><thead><tr><th style="min-width:180px;">' + (a === 'ITEM_MONTH' ? '시설 점검' : '일') + '</th>' +
           cols.map(function(d){ return '<th style="width:30px;">' + d + suf + '</th>'; }).join('') + '<th>…</th></tr></thead><tbody>';
      if (!items.length) h += '<tr><td class="l" style="color:#8a99a3;">항목을 추가하세요</td>' + cols.map(function(){ return '<td></td>'; }).join('') + '<td></td></tr>';
      items.forEach(function(r){
        h += '<tr><td class="l">' + esc(r.itemnm) + '</td>' + cols.map(function(){ return '<td></td>'; }).join('') + '<td></td></tr>';
      });
      if (chk('f_signerYn') === 'Y') h += '<tr><td class="l">점검자 사인</td>' + cols.map(function(){ return '<td></td>'; }).join('') + '<td></td></tr>';
      h += '</tbody></table>';
    } else { // DAY_ITEM
      var grps = [], last = null;
      items.forEach(function(r){
        var g = r.grpnm || '';
        if (last && last.g === g) last.n++; else { last = { g:g, n:1 }; grps.push(last); }
      });
      var hasGrp = grps.some(function(g){ return g.g; });
      h += '<table><thead>';
      if (hasGrp) {
        h += '<tr><th rowspan="2" style="width:34px;">일</th>' +
             grps.map(function(g){ return '<th colspan="' + g.n + '">' + esc(g.g) + '</th>'; }).join('') + '</tr><tr>';
      } else {
        h += '<tr><th style="width:34px;">일</th>';
      }
      if (!items.length) h += '<th style="color:#8a99a3;">항목을 추가하세요</th>';
      items.forEach(function(r){ h += '<th style="min-width:70px;">' + esc(r.itemnm) + (r.unitnm ? ('(' + esc(r.unitnm) + ')') : '') + '</th>'; });
      h += '</tr></thead><tbody>';
      DAYS.forEach(function(d){
        h += '<tr><td>' + d + '</td>' + (items.length ? items : [0]).map(function(){ return '<td></td>'; }).join('') + '</tr>';
      });
      h += '<tr><td>…</td>' + (items.length ? items : [0]).map(function(){ return '<td></td>'; }).join('') + '</tr>';
      h += '</tbody></table>';
    }
    if (chk('f_noteYn') === 'Y') h += '<div style="font-size:10.5px;color:#43555f;margin-top:4px;">특이사항 칸이 표 아래 붙습니다.</div>';
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

  window.cfList = function(){
    return post('<c:url value="/qps/chkFormList.do"/>', { cateCd: val('cfCate') }).then(function(res){
      if (res.hosp) { HOSP_NM = res.hosp.hospnm || ''; gel('cfHosp').textContent = '🏥 ' + HOSP_NM; }
      if (!CATE.length) {
        CATE = res.cate || [];
        [gel('cfCate'), gel('f_cateCd')].forEach(function(sel){
          CATE.forEach(function(c){ sel.add(new Option(c.subcodenm || c.codenm || c.subcode, c.subcode)); });
        });
      }
      LIST = res.list || [];
      gel('cfCnt').textContent = LIST.length ? ('· ' + LIST.length + '종') : '';
      var box = gel('cfListBox');
      box.innerHTML = LIST.length
        ? LIST.map(function(r){
            return '<div class="cf-item' + (r.formid === curId ? ' on' : '') + '" onclick="cfOpen(\'' + esc(r.formid) + '\');">' +
                   '<div class="t">' + esc(r.formnm) + '</div>' +
                   '<div class="d"><span class="tag axis">' + esc(AXIS_NM[r.axisgb] || r.axisgb) + '</span>' +
                   '<span class="tag ' + (r.own === 'Y' ? 'own">병원 서식' : 'std">기본 서식') + '</span>' +
                   '<span>항목 ' + Number(r.itemcnt || 0) + '</span>' +
                   '<span>작성 ' + Number(r.doccnt || 0) + '건</span></div></div>';
          }).join('')
        : '<div class="cf-empty">서식이 없습니다.<br>[＋ 새 서식]으로 만드세요.</div>';
    }).catch(err);
  };

  window.cfOpen = function(id){
    post('<c:url value="/qps/chkFormGet.do"/>', { formId: id }).then(function(res){
      var d = res.form || {};
      curId = d.formid || ''; curOwn = d.own || 'N';
      set('f_formId', d.formid); set('f_formNm', d.formnm); set('f_cateCd', d.catecd || '');
      set('f_axisGb', d.axisgb || 'ITEM_DAY'); set('f_equipCnt', d.equipcnt || 10);
      set('f_guideTxt', d.guidetxt); set('f_headNms', d.headnms);
      setChk('f_signerYn', d.signeryn); setChk('f_noteYn', d.noteyn); setChk('f_fixYn', d.fixyn);
      set('f_signLine', d.signline); set('f_footTxt', d.foottxt); set('f_sortNo', d.sortno || 0);
      gel('f_formId').readOnly = true;   // 코드는 못 바꾼다 — 바꾸면 작성분과 끊긴다

      gel('tbITEM').innerHTML = '';
      (res.items || []).forEach(itemRow);
      if (!(res.items || []).length) itemRow({});
      renumber(); cfAxisChange();

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
    ['f_formId','f_formNm','f_guideTxt','f_headNms','f_signLine','f_footTxt'].forEach(function(id){ set(id, ''); });
    set('f_cateCd', ''); set('f_axisGb', 'ITEM_DAY'); set('f_equipCnt', 10); set('f_sortNo', 0);
    setChk('f_signerYn', 'Y'); setChk('f_noteYn', 'Y'); setChk('f_fixYn', 'N');
    gel('f_formId').readOnly = false;
    gel('tbITEM').innerHTML = ''; [{},{},{}].forEach(itemRow);
    renumber(); cfAxisChange();
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
    var items = readItems();
    if (!items.length) { _alertBox('점검항목을 하나 이상 등록해 주세요.', {icon:'⚠️'}); return; }
    var go = function(){
      post('<c:url value="/qps/chkFormSave.do"/>', {
        formId: val('f_formId'), formNm: val('f_formNm'), cateCd: val('f_cateCd'),
        axisGb: axis(), equipCnt: val('f_equipCnt'),
        guideTxt: val('f_guideTxt'), headNms: val('f_headNms'),
        signerYn: chk('f_signerYn'), noteYn: chk('f_noteYn'), fixYn: chk('f_fixYn'),
        signLine: val('f_signLine'), footTxt: val('f_footTxt'), sortNo: val('f_sortNo'),
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

  $(function(){ cfList().then(function(){ if (LIST.length) cfOpen(LIST[0].formid); else cfNew(); }); });
})();
</script>
</div><%-- /#qpsChkForm --%>
</div><%-- /.dashboard-wrapper --%>
