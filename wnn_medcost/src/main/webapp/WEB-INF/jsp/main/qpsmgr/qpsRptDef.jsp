<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%-- qpsRptDef.jsp — 기준코드 › 보고서 체크 묶음 관리 (2026-09-02 밤)
     · 메뉴 : QPS ▸ 관리(설정) ▸ 기준코드 ▸ 보고서 체크 묶음.
     · 대상 : TBL_QPS_SAFERPT_DEF(묶음·항목) + TBL_QPS_SAFERPT_USE(유형이 쓰는 묶음·차례). 보고서·서식 화면의 「구분」 카드가 이걸 읽어 그린다.
     · 왼쪽 = 유형(보고서 76종 + 맨 위 「공유 묶음」), 오른쪽 = 그 유형이 쓰는 묶음 카드(이름·라디오/여럿·차례·쓰기) + 항목 표(기타 글자칸·차례·사용).
     · ★못 바꾸는 것 : 묶음 코드 · 항목 글자 — 작성분(TBL_QPS_SAFERPT_CHK)이 그 글자로 저장돼 있다. 내림 = 「사용」 끄기, 새 글자 = 새 항목.
     · ★공유 묶음('*' — 직종·처방·의식상태 …)은 여러 유형이 같이 쓴다 — 고치면 전부 바뀐다(카드에 경고).
     · 보는 것은 모두 · 고치는 것은 위너넷만(data-wnn 으로 숨기고 서버가 다시 막는다).
     · ★주의: 이 파일 안에서 Deferred EL 표기(샵+중괄호) 금지 --%>

<script src="/asset/js/ui-message.js"></script>

<div class="dashboard-wrapper">
<div id="qpsRptDef" data-wnn="<c:out value='${wnnYn}'/>">
<style>
  #qpsRptDef{ background:#f4f6f8; color:#1f2a30; min-height:100%; padding:14px 16px 50px; max-width:100%; overflow-x:hidden; }
  #qpsRptDef *{ box-sizing:border-box; }
  #qpsRptDef .rd-head{ display:flex; align-items:center; gap:10px; margin-bottom:12px; flex-wrap:wrap; }
  #qpsRptDef .rd-title{ font-size:18px; font-weight:800; color:#20303a; display:flex; align-items:center; gap:8px; }
  #qpsRptDef .rd-dot{ width:10px; height:10px; border-radius:50%; background:linear-gradient(135deg,#1f5a4b,#2a7665); }
  #qpsRptDef .rd-sub{ font-size:12px; color:#6b7c86; font-weight:400; }
  #qpsRptDef .rd-hosp{ background:#e7f3ee; color:#1f5a4b; font-size:12px; font-weight:800; border:1px solid #cfe3da; border-radius:14px; padding:3px 11px; }
  #qpsRptDef .rd-spacer{ flex:1; }
  #qpsRptDef input, #qpsRptDef select{ border:1px solid #cfd8e0; border-radius:5px; padding:4px 7px; font-size:12.5px; background:#fff; font-family:inherit; }
  #qpsRptDef .rd-note{ background:#fff; border:1px solid #e3e9ed; border-radius:10px; padding:9px 14px; font-size:12.5px; color:#43555f; margin-bottom:12px; line-height:1.6; }
  #qpsRptDef .rd-note b{ color:#20303a; }
  #qpsRptDef .rd-body{ display:flex; gap:12px; align-items:flex-start; }
  #qpsRptDef .rd-left{ width:330px; flex:0 0 330px; background:#fff; border:1px solid #e3e9ed; border-radius:10px; overflow:hidden; position:sticky; top:8px; }
  #qpsRptDef .rd-left .hd{ padding:8px 12px; font-size:12.5px; font-weight:700; color:#43555f; background:#f2f6f8; border-bottom:1px solid #dde5ea; }
  #qpsRptDef #rdTypes{ max-height:calc(100vh - 300px); min-height:240px; overflow-y:auto; }
  #qpsRptDef .rd-ty{ padding:7px 12px; border-bottom:1px solid #eef2f5; cursor:pointer; font-size:12.5px; display:flex; gap:8px; align-items:center; }
  #qpsRptDef .rd-ty:hover{ background:#f7fbf9; }
  #qpsRptDef .rd-ty.on{ background:#e7f3ee; }
  #qpsRptDef .rd-ty.shared{ background:#fff8e6; }
  #qpsRptDef .rd-ty.shared.on{ background:#ffefc2; }
  #qpsRptDef .rd-ty .nm{ flex:1; font-weight:700; color:#20303a; }
  #qpsRptDef .rd-ty .cd{ font-size:11px; color:#8a99a3; font-family:Consolas,monospace; }
  #qpsRptDef .rd-ty .n{ font-size:11.5px; color:#6b7c86; white-space:nowrap; }
  #qpsRptDef .rd-ty .n.zero{ color:#c0c9cf; }
  #qpsRptDef .rd-right{ flex:1; min-width:0; }
  #qpsRptDef .rd-rhead{ display:flex; align-items:center; gap:8px; flex-wrap:wrap; margin-bottom:8px; background:#fff; border:1px solid #e3e9ed; border-radius:10px; padding:10px 12px; }
  #qpsRptDef .rd-rhead .t{ font-size:14px; font-weight:800; color:#20303a; }
  #qpsRptDef .rd-cd{ font-family:Consolas,monospace; font-size:12px; color:#43555f; }
  #qpsRptDef #rdCards{ max-height:calc(100vh - 360px); min-height:200px; overflow-y:auto; padding-right:2px; }
  #qpsRptDef .rd-card{ background:#fff; border:1px solid #e3e9ed; border-radius:10px; margin-bottom:10px; overflow:hidden; }
  #qpsRptDef .rd-card.off{ opacity:.6; }
  #qpsRptDef .rd-card > .gh{ display:flex; align-items:center; gap:8px; flex-wrap:wrap; padding:8px 12px; background:#f2f6f8; border-bottom:1px solid #dde5ea; font-size:12.5px; }
  #qpsRptDef .rd-card > .gh .gcd{ font-family:Consolas,monospace; font-size:11.5px; color:#6b7c86; min-width:80px; }
  #qpsRptDef .rd-card > .gh input[data-g="grpnm"]{ width:200px; font-weight:700; }
  #qpsRptDef .rd-card > .gh input.num{ width:52px; text-align:center; }
  #qpsRptDef .rd-card > .gh .badge{ font-size:11px; font-weight:800; border-radius:10px; padding:2px 8px; }
  #qpsRptDef .rd-card > .gh .badge.sh{ background:#ffefc2; color:#7a5a00; border:1px solid #f1d98a; }
  #qpsRptDef .rd-card > .gh .badge.own{ background:#e7f3ee; color:#1f5a4b; border:1px solid #cfe3da; }
  #qpsRptDef .rd-card > .gh .warn{ font-size:11.5px; color:#8a4b12; }
  #qpsRptDef .rd-card > .gh .sp{ flex:1; }
  #qpsRptDef table{ width:100%; border-collapse:collapse; font-size:12.5px; }
  #qpsRptDef th{ background:#fafcfd; font-weight:700; color:#43555f; padding:5px 8px; border-bottom:1px solid #e3e9ed; text-align:left; white-space:nowrap; }
  #qpsRptDef td{ padding:3px 8px; border-bottom:1px solid #eef2f5; vertical-align:middle; }
  #qpsRptDef td input[type=text]{ width:100%; }
  #qpsRptDef td input.num{ width:56px; text-align:center; }
  #qpsRptDef tr.off td{ color:#a8b4bb; background:#fafbfc; }
  #qpsRptDef tr.off td input{ color:#a8b4bb; }
  #qpsRptDef tr.new td{ background:#fffbea; }
  #qpsRptDef tr.dirty td:first-child{ border-left:3px solid #e0a23a; }
  #qpsRptDef .rd-btn{ border:1px solid #cfd9e0; background:#fff; color:#43555f; border-radius:6px; padding:4px 10px; font-size:12px; font-weight:700; cursor:pointer; white-space:nowrap; }
  #qpsRptDef .rd-btn:hover{ background:#eef3f6; }
  #qpsRptDef .rd-btn.pri{ background:#1f5a4b; color:#fff; border-color:#1f5a4b; }
  #qpsRptDef .rd-btn.pri:hover{ background:#2a7665; }
  #qpsRptDef .rd-btn.mini{ padding:2px 8px; font-size:11.5px; }
  #qpsRptDef .rd-empty{ color:#8a99a3; font-size:13px; padding:22px; text-align:center; }
  #qpsRptDef .rd-foot{ display:flex; gap:8px; align-items:center; flex-wrap:wrap; background:#fff; border:1px dashed #cfd9e0; border-radius:10px; padding:9px 12px; font-size:12.5px; margin-top:4px; }
  #qpsRptDef .rd-foot .lb{ font-weight:700; color:#43555f; }
  #qpsRptDef .card-foot{ padding:5px 12px 8px; }
  #qpsRptDef .uses{ font-size:11.5px; color:#6b7c86; }
</style>

<div class="rd-head">
  <div class="rd-title"><span class="rd-dot"></span>보고서 체크 묶음 <span class="rd-sub">— 기준코드 · 보고서·서식 「구분」 선택지 · 전 병원 공용</span></div>
  <span class="rd-hosp">🏥 <c:out value='${hospNm}'/></span>
  <span class="rd-spacer"></span>
  <input type="text" id="rdFind" placeholder="유형·묶음·항목 찾기" style="width:200px;" oninput="rdPaintTypes();">
</div>

<div class="rd-note">
  보고서·서식 화면에서 유형마다 나오는 <b>체크 선택지</b>(사고유형·손상종류·직종 …)입니다. 묶음의 <b>이름·라디오/여럿·차례·쓰기</b>와 항목의 <b>기타 글자칸·차례·사용</b>을 고치고, 항목·묶음을 더합니다.
  <b>묶음 코드와 항목 글자는 못 바꿉니다</b> — 작성된 보고서가 그 글자로 저장돼 있습니다. 빼려면 「사용」을 끄고, 글자를 바꾸려면 새 항목을 더하세요.
  <b>공유 묶음</b>(직종·처방 …)은 여러 유형이 같이 씁니다 — 고치면 전부 바뀝니다.
  <span id="rdHospNote" style="display:none;">고치는 것은 위너넷 담당자가 합니다 — 바꿀 것이 있으면 알려 주세요.</span>
</div>

<div class="rd-body">
  <div class="rd-left">
    <div class="hd">유형 <span id="rdTyCnt" class="rd-sub"></span></div>
    <div id="rdTypes"><div class="rd-empty">불러오는 중…</div></div>
  </div>
  <div class="rd-right">
    <div class="rd-rhead">
      <span class="t" id="rdTitle">유형을 고르세요</span>
      <span class="rd-cd" id="rdCode"></span>
      <span class="rd-sub" id="rdSum"></span>
      <span class="rd-spacer"></span>
      <span id="rdTopBtns" style="display:none;">
        <button type="button" class="rd-btn pri" onclick="rdSaveAll();">고친 것 저장</button>
      </span>
    </div>
    <div id="rdCards"><div class="rd-empty">왼쪽에서 유형을 고르세요.</div></div>
    <div class="rd-foot" id="rdFoot" style="display:none;">
      <span class="lb">＋ 새 묶음</span>
      <input type="text" id="rdNewCd" placeholder="묶음 코드(영문 대문자)" maxlength="30" style="width:170px;font-family:Consolas,monospace;">
      <input type="text" id="rdNewNm" placeholder="묶음 이름" maxlength="100" style="width:180px;">
      <select id="rdNewMulti"><option value="N">하나만(라디오)</option><option value="Y">여럿(체크)</option></select>
      <input type="text" id="rdNewItems" placeholder="항목들을 쉼표로 (예: 유,무,기타)" style="width:260px;">
      <button type="button" class="rd-btn" onclick="rdNewGrp();">만들기</button>
      <span id="rdAttachWrap" style="display:inline-flex;gap:6px;align-items:center;margin-left:14px;">
        <span class="lb">공유 묶음 붙이기</span>
        <select id="rdAttach" style="min-width:160px;"></select>
        <button type="button" class="rd-btn" onclick="rdAttachGrp();">붙이기</button>
      </span>
    </div>
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
  var URL_LIST = '<c:url value="/qps/rdefList.do"/>', URL_ITEM = '<c:url value="/qps/rdefSave.do"/>',
      URL_GRP = '<c:url value="/qps/rdefGrpSave.do"/>', URL_USE = '<c:url value="/qps/rdefUseSave.do"/>';
  var WNN = gel('qpsRptDef').getAttribute('data-wnn') === 'Y';
  var TYPES = [], DEF = [], USE = [], CUR = '';
  var SHARED = '*';
  gel('rdHospNote').style.display = WNN ? 'none' : '';

  /* 묶음 뼈대 — DEF 행을 (유형, 묶음코드) 로 모은다. 유형이 쓰는 묶음은 USE 가 정한다(공유 '*' 것도 같이). */
  function grpsOf(gb){
    var by = {};
    DEF.forEach(function(d){
      if (d.rptgb !== gb) return;
      if (!by[d.grpcd]) by[d.grpcd] = { cd:d.grpcd, nm:d.grpnm, multi:d.multiyn, own:gb, items:[] };
      by[d.grpcd].items.push(d);
    });
    return by;
  }
  function usesOfShared(cd){ return USE.filter(function(u){ return u.grpcd === cd && u.useyn === 'Y'; }).map(function(u){ return u.rptgb; }); }
  function tyNm(gb){ var t = TYPES.filter(function(x){ return x.subcode === gb; })[0]; return t ? t.subcodenm : gb; }
  function useCnt(gb){ return USE.filter(function(u){ return u.rptgb === gb && u.useyn === 'Y'; }).length; }

  window.rdLoad = function(keep){
    post(URL_LIST, {}).then(function(res){
      TYPES = res.types || []; DEF = res.def || []; USE = res.use || [];
      rdPaintTypes();
      if (keep && CUR) rdPick(CUR); else if (!CUR && TYPES.length) rdPick(TYPES[0].subcode);
    }).catch(function(e){ gel('rdTypes').innerHTML = '<div class="rd-empty">' + esc(e.message || '불러오지 못했습니다.') + '</div>'; });
  };
  window.rdPaintTypes = function(){
    var q = String(gel('rdFind').value || '').trim().toLowerCase(), h = '', n = 0;
    var hitDef = function(gb){ return DEF.some(function(d){ return d.rptgb === gb && (String(d.grpnm).toLowerCase().indexOf(q) >= 0 || String(d.itemnm).toLowerCase().indexOf(q) >= 0 || String(d.grpcd).toLowerCase().indexOf(q) >= 0); }); };
    var shN = Object.keys(grpsOf(SHARED)).length;
    if (!q || '공유'.indexOf(q) >= 0 || hitDef(SHARED)) {
      n++;
      h += '<div class="rd-ty shared' + (CUR === SHARED ? ' on' : '') + '" onclick="rdPick(\'*\');">' +
           '<span class="nm">공유 묶음<br><span class="cd">* — 여러 유형이 같이 쓰는 것</span></span><span class="n">' + shN + '묶음</span></div>';
    }
    TYPES.forEach(function(t){
      var hit = !q || String(t.subcode).toLowerCase().indexOf(q) >= 0 || String(t.subcodenm || '').toLowerCase().indexOf(q) >= 0 || hitDef(t.subcode) ||
                USE.some(function(u){ return u.rptgb === t.subcode && u.useyn === 'Y' && hitDef.call(null, SHARED) && DEF.some(function(d){ return d.rptgb === SHARED && d.grpcd === u.grpcd && (String(d.grpnm).toLowerCase().indexOf(q) >= 0 || String(d.itemnm).toLowerCase().indexOf(q) >= 0); }); });
      if (!hit) return; n++;
      var c = useCnt(t.subcode);
      h += '<div class="rd-ty' + (t.subcode === CUR ? ' on' : '') + '" onclick="rdPick(\'' + esc(t.subcode) + '\');">' +
           '<span class="nm' + (t.useyn === 'N' ? ' none' : '') + '">' + esc(t.subcodenm) + '<br><span class="cd">' + esc(t.subcode) + '</span></span>' +
           '<span class="n' + (c ? '' : ' zero') + '">' + c + '묶음</span></div>';
    });
    gel('rdTypes').innerHTML = h || '<div class="rd-empty">맞는 유형이 없습니다.</div>';
    gel('rdTyCnt').textContent = n + '개';
  };

  window.rdPick = function(gb){
    CUR = gb; rdPaintTypes();
    var shared = (gb === SHARED);
    gel('rdTitle').textContent = shared ? '공유 묶음' : tyNm(gb);
    gel('rdCode').textContent = gb;
    gel('rdTopBtns').style.display = WNN ? '' : 'none';
    gel('rdFoot').style.display = WNN ? '' : 'none';
    gel('rdAttachWrap').style.display = (WNN && !shared) ? '' : 'none';
    var own = grpsOf(gb), sh = grpsOf(SHARED), cards = [];
    if (shared) {
      Object.keys(own).sort().forEach(function(cd){ cards.push({ g: own[cd], use: null }); });
    } else {
      USE.filter(function(u){ return u.rptgb === gb; }).sort(function(a, b){ return (a.sort - b.sort) || (a.grpcd < b.grpcd ? -1 : 1); }).forEach(function(u){
        var g = own[u.grpcd] || sh[u.grpcd];
        if (!g) g = { cd:u.grpcd, nm:'(항목 없음)', multi:'Y', own:gb, items:[] };   // USE 만 있고 DEF 가 없는 것도 보인다(감사 ⑨)
        cards.push({ g: g, use: u });
      });
      // DEF 에는 있는데 USE 에 안 걸린 이 유형 전용 묶음 — 안 쓰는 상태로 보여 준다
      Object.keys(own).sort().forEach(function(cd){
        if (!USE.some(function(u){ return u.rptgb === gb && u.grpcd === cd; })) cards.push({ g: own[cd], use: { rptgb: gb, grpcd: cd, sort: 99, useyn: 'N' }, noUse: true });
      });
    }
    var h = '';
    cards.forEach(function(c){ h += cardHtml(c.g, c.use, shared, c.noUse); });
    gel('rdCards').innerHTML = h || '<div class="rd-empty">' + (shared ? '공유 묶음이 없습니다.' : '이 유형은 체크 묶음을 쓰지 않습니다 — 아래에서 만들거나 공유 묶음을 붙이세요.') + '</div>';
    var nItem = 0; cards.forEach(function(c){ nItem += c.g.items.filter(function(i){ return i.useyn === 'Y'; }).length; });
    gel('rdSum').textContent = cards.length + '묶음 · 항목 ' + nItem;
    // 붙일 수 있는 공유 묶음 = 아직 이 유형 USE 에 없는 것
    if (!shared) {
      var opt = '';
      Object.keys(sh).sort().forEach(function(cd){
        if (USE.some(function(u){ return u.rptgb === gb && u.grpcd === cd; })) return;
        opt += '<option value="' + esc(cd) + '">' + esc(sh[cd].nm) + ' (' + esc(cd) + ')</option>';
      });
      gel('rdAttach').innerHTML = opt || '<option value="">(붙일 공유 묶음 없음)</option>';
    }
  };

  function cardHtml(g, u, sharedView, noUse){
    var isSh = (g.own === SHARED), dis = WNN ? '' : ' disabled';
    var off = u ? (u.useyn !== 'Y') : false;
    var h = '<div class="rd-card' + (off ? ' off' : '') + '" data-own="' + esc(g.own) + '" data-cd="' + esc(g.cd) + '">' +
      '<div class="gh"><span class="gcd">' + esc(g.cd) + '</span>' +
      (isSh ? '<span class="badge sh">공유</span>' : (sharedView ? '' : '<span class="badge own">전용</span>')) +
      '<input type="text" data-g="grpnm" value="' + esc(g.nm) + '" maxlength="100"' + dis + ' oninput="rdGDirty(this);">' +
      '<select data-g="multiyn"' + dis + ' onchange="rdGDirty(this);"><option value="N"' + (g.multi === 'N' ? ' selected' : '') + '>하나만</option><option value="Y"' + (g.multi === 'N' ? '' : ' selected') + '>여럿</option></select>' +
      (u ? ('<span>차례 <input type="text" class="num" data-g="usesort" value="' + esc(u.sort) + '"' + dis + ' oninput="rdGDirty(this);"></span>' +
            '<label><input type="checkbox" data-g="useyn"' + (off ? '' : ' checked') + dis + ' onchange="rdGDirty(this);"> 이 유형에서 씀</label>')
         : ('<span class="uses">쓰는 유형 : ' + (usesOfShared(g.cd).map(tyNm).join(' · ') || '없음') + '</span>')) +
      (isSh && !sharedView ? '<span class="warn">⚠ 공유 — 이름·항목을 고치면 ' + usesOfShared(g.cd).length + '개 유형이 같이 바뀝니다</span>' : '') +
      (noUse ? '<span class="warn">연결 없음(USE) — 「씀」을 켜고 저장하면 붙습니다</span>' : '') +
      '<span class="sp"></span>' +
      (WNN ? '<button type="button" class="rd-btn mini" onclick="rdGrpSave(this);">묶음 저장</button>' : '') +
      '</div>';
    h += '<table><thead><tr><th>항목</th><th style="width:90px;">기타 글자칸</th><th style="width:70px;">차례</th><th style="width:60px;">사용</th><th style="width:70px;"></th></tr></thead><tbody>';
    if (!g.items.length) h += '<tr><td colspan="5" class="rd-empty">항목이 없습니다.</td></tr>';
    g.items.forEach(function(it){ h += itemHtml(it, false); });
    h += '</tbody></table>';
    if (WNN) h += '<div class="card-foot"><button type="button" class="rd-btn mini" onclick="rdItemAdd(this);">＋ 항목</button></div>';
    return h + '</div>';
  }
  function itemHtml(it, isNew){
    var off = it.useyn === 'N', dis = WNN ? '' : ' disabled';
    return '<tr class="' + (off ? 'off' : '') + (isNew ? ' new' : '') + '" data-item="' + esc(it.itemnm) + '">' +
      '<td>' + (isNew ? '<input type="text" data-f="itemnm" maxlength="200" placeholder="항목 글자">' : esc(it.itemnm)) + '</td>' +
      '<td style="text-align:center;"><input type="checkbox" data-f="etcyn"' + (it.etcyn === 'Y' ? ' checked' : '') + dis + ' onchange="rdDirty(this);"></td>' +
      '<td><input type="text" class="num" data-f="sort" value="' + esc(it.sort) + '"' + dis + ' oninput="rdDirty(this);"></td>' +
      '<td style="text-align:center;"><input type="checkbox" data-f="useyn"' + (off ? '' : ' checked') + dis + ' onchange="rdDirty(this);"></td>' +
      '<td>' + (WNN ? '<button type="button" class="rd-btn mini" onclick="rdItemSave(this);">저장</button>' : '') + '</td></tr>';
  }
  window.rdDirty = function(el){ var tr = el.closest('tr'); tr.classList.add('dirty'); tr.classList.toggle('off', !tr.querySelector('[data-f="useyn"]').checked); };
  window.rdGDirty = function(el){ el.closest('.rd-card').classList.add('gdirty'); };
  window.rdItemAdd = function(btn){
    var card = btn.closest('.rd-card'), body = card.querySelector('tbody');
    if (body.querySelector('.rd-empty')) body.innerHTML = '';
    var rows = body.querySelectorAll('tr').length;
    var tb = document.createElement('tbody'); tb.innerHTML = itemHtml({ itemnm:'', etcyn:'N', sort: rows + 1, useyn:'Y' }, true);
    body.appendChild(tb.firstElementChild); body.lastElementChild.classList.add('dirty');
    body.lastElementChild.querySelector('[data-f="itemnm"]').focus();
  };
  function cardHead(card){
    var u = card.querySelector('[data-g="useyn"]');
    return { rptGb: card.getAttribute('data-own'), grpCd: card.getAttribute('data-cd'),
             grpNm: String(card.querySelector('[data-g="grpnm"]').value).trim(), multiYn: card.querySelector('[data-g="multiyn"]').value,
             useSort: u ? (String(card.querySelector('[data-g="usesort"]').value).trim() || '99') : null, useYn: u ? (u.checked ? 'Y' : 'N') : null };
  }
  function readItem(tr){
    var card = tr.closest('.rd-card'), hd = cardHead(card), nm = tr.querySelector('[data-f="itemnm"]');
    return { rptGb: hd.rptGb, grpCd: hd.grpCd, grpNm: hd.grpNm, multiYn: hd.multiYn,
             itemNm: nm ? String(nm.value).trim() : tr.getAttribute('data-item'),
             etcYn: tr.querySelector('[data-f="etcyn"]').checked ? 'Y' : 'N',
             sort: String(tr.querySelector('[data-f="sort"]').value).trim() || '99',
             useYn: tr.querySelector('[data-f="useyn"]').checked ? 'Y' : 'N' };
  }
  /* 차례로 보낸다(한 줄 실패하면 거기서 멈추고 다시 읽는다) */
  function runSeq(jobs, done){
    var i = 0, n = 0;
    (function next(){
      if (i >= jobs.length) { done(n); return; }
      var j = jobs[i++];
      post(j.url, j.data).then(function(){ n++; next(); }).catch(function(e){ err(e); rdLoad(true); });
    })();
  }
  function grpJobs(card){
    var hd = cardHead(card), jobs = [];
    if (!hd.grpNm) { _alertBox('묶음 이름을 적어 주세요.', {icon:'⚠️'}); return null; }
    var hasItems = !!card.querySelector('tbody tr[data-item]:not(.new)');
    if (hasItems) jobs.push({ url: URL_GRP, data: { rptGb: hd.rptGb, grpCd: hd.grpCd, grpNm: hd.grpNm, multiYn: hd.multiYn } });
    if (hd.useYn !== null && CUR !== SHARED) jobs.push({ url: URL_USE, data: { rptGb: CUR, grpCd: hd.grpCd, sort: hd.useSort, useYn: hd.useYn } });
    return jobs;
  }
  function itemJobs(trs){
    var list = trs.map(readItem), bad = list.filter(function(r){ return !r.itemNm; });
    if (bad.length) { _alertBox('항목 글자를 적어 주세요.', {icon:'⚠️'}); return null; }
    return list.map(function(r){ return { url: URL_ITEM, data: r }; });
  }
  window.rdGrpSave = function(btn){
    var card = btn.closest('.rd-card'), jobs = grpJobs(card); if (!jobs) return;
    var its = itemJobs([].slice.call(card.querySelectorAll('tbody tr.dirty'))); if (!its) return;
    runSeq(jobs.concat(its), function(n){ _toast('묶음을 저장했습니다.' + (its.length ? (' 항목 ' + its.length + '건') : ''), 'ok'); rdLoad(true); });
  };
  window.rdItemSave = function(btn){
    var jobs = itemJobs([btn.closest('tr')]); if (!jobs) return;
    runSeq(jobs, function(){ _toast('항목을 저장했습니다.', 'ok'); rdLoad(true); });
  };
  window.rdSaveAll = function(){
    var jobs = [], cards = [].slice.call(gel('rdCards').querySelectorAll('.rd-card'));
    for (var i = 0; i < cards.length; i++) {
      var c = cards[i];
      if (c.classList.contains('gdirty')) { var gj = grpJobs(c); if (!gj) return; jobs = jobs.concat(gj); }
      var trs = [].slice.call(c.querySelectorAll('tbody tr.dirty'));
      if (trs.length) { var ij = itemJobs(trs); if (!ij) return; jobs = jobs.concat(ij); }
    }
    if (!jobs.length) { _toast('고친 것이 없습니다.', 'ok'); return; }
    runSeq(jobs, function(n){ _toast(n + '건 저장했습니다.', 'ok'); rdLoad(true); });
  };
  /* 새 묶음 — 공유 화면이면 '*' 소유, 유형 화면이면 그 유형 전용 + USE 연결 */
  window.rdNewGrp = function(){
    var cd = String(gel('rdNewCd').value || '').trim().toUpperCase(), nm = String(gel('rdNewNm').value || '').trim();
    var multi = gel('rdNewMulti').value, items = String(gel('rdNewItems').value || '').split(',').map(function(s){ return s.trim(); }).filter(function(s){ return s; });
    if (!/^[A-Z0-9_]{1,30}$/.test(cd)) { _alertBox('묶음 코드는 영문 대문자·숫자·_ 1~30자입니다.', {icon:'⚠️'}); return; }
    if (!nm) { _alertBox('묶음 이름을 적어 주세요.', {icon:'⚠️'}); return; }
    if (!items.length) { _alertBox('항목을 하나 이상 쉼표로 적어 주세요.', {icon:'⚠️'}); return; }
    var own = CUR === SHARED ? SHARED : CUR;
    if (DEF.some(function(d){ return d.rptgb === own && d.grpcd === cd; })) { _alertBox('이미 있는 묶음 코드입니다.', {icon:'⚠️'}); return; }
    var jobs = items.map(function(it, i){ return { url: URL_ITEM, data: { rptGb: own, grpCd: cd, grpNm: nm, multiYn: multi, itemNm: it, etcYn: /기타/.test(it) ? 'Y' : 'N', sort: i + 1, useYn: 'Y' } }; });
    if (own !== SHARED) jobs.push({ url: URL_USE, data: { rptGb: own, grpCd: cd, sort: useCnt(own) + 1, useYn: 'Y' } });
    runSeq(jobs, function(){ _toast('묶음을 만들었습니다.', 'ok'); gel('rdNewCd').value = ''; gel('rdNewNm').value = ''; gel('rdNewItems').value = ''; rdLoad(true); });
  };
  window.rdAttachGrp = function(){
    var cd = gel('rdAttach').value; if (!cd || CUR === SHARED) return;
    runSeq([{ url: URL_USE, data: { rptGb: CUR, grpCd: cd, sort: useCnt(CUR) + 1, useYn: 'Y' } }], function(){ _toast('공유 묶음을 붙였습니다.', 'ok'); rdLoad(true); });
  };
  $(function(){ rdLoad(false); });
})();
</script>
</div><%-- /#qpsRptDef --%>
</div><%-- /.dashboard-wrapper --%>
