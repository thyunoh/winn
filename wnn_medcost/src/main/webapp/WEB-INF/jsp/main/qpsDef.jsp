<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%-- qpsDef.jsp — QPS 지표정의서 편집 (2026-08-09)
     · 정의서는 산식이 인쇄된 문서가 아니라 **병원이 채우는 빈 양식**이다(산식채록 §0.1).
       이 화면이 곧 그 서식을 대체한다.
     · ★저장은 항상 '그 병원 행'에만 한다 — 공통 기본값('*')은 안 바뀐다.
       아직 안 고친 병원은 공통값을 그대로 보고, [되돌리기]로 언제든 공통값으로 돌아간다.
     · ★산식을 이루는 값(분자원천·분모구분·상수·등급기준)은 여기서 못 고친다 —
       문구를 다듬다 집계 방식이 바뀌면 지표가 조용히 틀어진다. 그건 우리가 관리한다.
     · ★주의: 이 파일 안에서 Deferred EL 표기(샵+중괄호) 금지 --%>

<script src="/asset/js/ui-message.js"></script>

<div class="dashboard-wrapper">
<div id="qpsDef" data-hospcd="<c:out value='${hospCd}'/>" data-wnn="<c:out value='${wnnYn}'/>"
     data-indicd="<c:out value='${indiCd}'/>">
<style>
  #qpsDef{ background:#f4f6f8; color:#1f2a30; min-height:100%; padding:14px 16px 50px; max-width:100%; overflow-x:hidden; }
  #qpsDef *{ box-sizing:border-box; }
  #qpsDef .qd-head{ display:flex; align-items:center; gap:10px; margin-bottom:12px; flex-wrap:wrap; }
  #qpsDef .qd-title{ font-size:18px; font-weight:800; color:#20303a; display:flex; align-items:center; gap:8px; }
  #qpsDef .qd-dot{ width:10px; height:10px; border-radius:50%; background:linear-gradient(135deg,#1f5a4b,#2a7665); }
  #qpsDef .qd-sub{ font-size:12px; color:#6b7c86; }
  #qpsDef .qd-hosp{ background:#e7f3ee; color:#1f5a4b; font-size:12px; font-weight:800;
      border:1px solid #cfe3da; border-radius:14px; padding:3px 11px; }
  #qpsDef .qd-spacer{ flex:1; }
  #qpsDef select, #qpsDef input[type=text], #qpsDef input[type=number], #qpsDef textarea{
      border:1px solid #cfd8e0; border-radius:6px; padding:5px 8px; font-family:inherit; font-size:13px;
      background:#fff; width:100%; }
  #qpsDef textarea{ min-height:52px; resize:vertical; line-height:1.55; }
  #qpsDef .qd-btn{ border:1px solid #1f5a4b; background:#1f5a4b; color:#fff; border-radius:6px;
      padding:6px 14px; font-size:13px; font-weight:600; cursor:pointer; white-space:nowrap; }
  #qpsDef .qd-btn.ghost{ background:#fff; color:#1f5a4b; }
  #qpsDef .qd-btn.warn{ background:#fff; color:#b23b3b; border-color:#e0b4b4; }
  #qpsDef .qd-btn:hover{ opacity:.9; }

  #qpsDef .qd-card{ background:#fff; border:1px solid #e3e9ed; border-radius:10px; padding:14px 16px; margin-bottom:14px; }
  #qpsDef .qd-card h4{ margin:0 0 10px; font-size:14px; font-weight:800; color:#20303a; display:flex; align-items:center; gap:6px; }
  #qpsDef .qd-card h4 .hint{ font-weight:500; font-size:12px; color:#8a99a3; }

  /* 양식 — 라벨 왼쪽 고정폭 표 형태(정의서 원본과 같은 인상) */
  #qpsDef .qd-form{ display:grid; grid-template-columns:118px 1fr 118px 1fr; gap:8px 10px; align-items:start; }
  #qpsDef .qd-form .lb{ font-size:12.5px; font-weight:700; color:#43555f; padding-top:7px; }
  #qpsDef .qd-form .full{ grid-column:2 / -1; }
  #qpsDef .qd-form .row{ grid-column:1 / -1; height:1px; background:#eef2f5; margin:3px 0; }
  #qpsDef .ro{ background:#f4f7f9 !important; color:#5b6b74; }
  #qpsDef .qd-note{ font-size:11.5px; color:#8a99a3; margin-top:3px; }

  #qpsDef .qd-own{ font-size:11.5px; font-weight:800; border-radius:10px; padding:2px 9px; }
  #qpsDef .qd-own.y{ background:#e4f3ea; color:#1f7a52; }
  #qpsDef .qd-own.n{ background:#eef2f5; color:#6b7c86; }
  #qpsDef .qd-empty{ color:#8a99a3; font-size:13px; padding:24px; text-align:center; }
</style>

<div class="qd-head">
  <div class="qd-title"><span class="qd-dot"></span>지표정의서</div>
  <div class="qd-sub">병원이 채우는 양식입니다 — 저장하면 이 병원 정의서가 됩니다</div>
  <span class="qd-hosp" id="qdHosp">🏥 <c:out value="${hospNm}" default="병원 미확인"/></span>
  <div class="qd-spacer"></div>
  <select id="qdIndi" style="width:auto; min-width:230px;" onchange="qdLoad();"></select>
  <span id="qdOwn" class="qd-own n">공통 기본값</span>
  <%-- 저장·인쇄는 <상단>에 둔다 — QPS 화면 공통(2026-08-10 확정) --%>
  <button type="button" class="qd-btn" onclick="qdSave();">저장</button>
  <button type="button" class="qd-btn ghost" onclick="qdPrint();">🖨 인쇄(A4)</button>
</div>

<div id="qdBody" style="display:none;">
  <div class="qd-card">
    <h4>지표정의서 <span class="hint" id="qdUpd"></span></h4>
    <div class="qd-form">
      <div class="lb">해당영역</div>      <div><input type="text" id="d_area" class="ro" readonly></div>
      <div class="lb">주관부서</div>      <div><input type="text" id="d_deptNm" maxlength="50" placeholder="예) 감염관리실"></div>

      <div class="lb">지표명 *</div>      <div><input type="text" id="d_indiNm" maxlength="100"></div>
      <div class="lb">담당자</div>        <div><input type="text" id="d_ownerNm" maxlength="50" placeholder="예) 감염관리담당자"></div>

      <div class="lb">선정배경</div>      <div class="full"><textarea id="d_background" placeholder="이 지표를 왜 관리하는지 — 인증기준·전년도 결과·원내 문제 등"></textarea></div>

      <div class="lb">지표정의</div>      <div class="full"><textarea id="d_definition" placeholder="무엇을 재는 지표인지 한 문장으로"></textarea></div>

      <div class="row"></div>

      <div class="lb">분자</div>          <div class="full"><textarea id="d_numerDesc" style="min-height:44px;"></textarea></div>
      <div class="lb">분모</div>          <div class="full"><textarea id="d_denomDesc" style="min-height:44px;"></textarea></div>

      <div class="lb">산식</div>          <div><input type="text" id="d_formula" class="ro" readonly>
                                              <div class="qd-note">산식·상수·집계방식은 화면에서 바꾸지 않습니다(위너넷 관리).</div></div>
      <div class="lb">산출주기</div>      <div><input type="text" id="d_cycle" class="ro" readonly></div>

      <div class="lb">포함기준</div>      <div class="full"><textarea id="d_includeTxt" placeholder="분자·분모에 넣는 대상"></textarea></div>
      <div class="lb">제외기준</div>      <div class="full"><textarea id="d_excludeTxt" placeholder="분자·분모에서 빼는 대상"></textarea></div>

      <div class="row"></div>

      <div class="lb">목표값</div>        <div><input type="number" id="d_targetVal" step="0.01" placeholder="예) 95"></div>
      <div class="lb">이전값</div>        <div><input type="number" id="d_prevVal" step="0.01" placeholder="예) 88.4"></div>

      <div class="lb">목표값 근거</div>   <div class="full"><input type="text" id="d_targetBase" maxlength="100" placeholder="의료기관인증 / 학회 권고 / 전년도 실적 / 타기관 비교 / 기타"></div>

      <div class="lb">자료출처</div>      <div><input type="text" id="d_sourceNm" maxlength="100" placeholder="예) 손위생 모니터링 점검표"></div>
      <div class="lb">자료분석</div>      <div><input type="text" id="d_methodNm" maxlength="100" placeholder="예) 직접관찰법"></div>

      <div class="lb">보고주기</div>      <div><input type="text" id="d_rptCycle" maxlength="20" placeholder="월 / 분기 / 반기 / 년"></div>
      <div class="lb">보고범위</div>      <div><input type="text" id="d_rptScope" maxlength="100" placeholder="예) QPS위원회, 감염관리위원회"></div>

      <div class="lb">성과공유</div>      <div class="full"><input type="text" id="d_shareTxt" maxlength="300" placeholder="공유 대상·방법 — 예) 전 직원, 게시판·부서회의"></div>
      <div class="lb">비고</div>          <div class="full"><textarea id="d_note" style="min-height:44px;"></textarea></div>
    </div>

    <div style="margin-top:14px; display:flex; gap:8px; align-items:center; flex-wrap:wrap;">
      <%-- 저장·인쇄는 상단으로 옮겼다(2026-08-10). 아래에는 이 화면 고유 동작만 남긴다. --%>
      <button type="button" class="qd-btn ghost" onclick="qdGoIndi();">지표 화면으로</button>
      <button type="button" class="qd-btn warn" id="qdResetBtn" onclick="qdReset();">공통값으로 되돌리기</button>
      <span class="qd-sub" id="qdSaveHint">저장하면 이 병원 전용 정의서가 만들어집니다(다른 병원에 영향 없음).</span>
    </div>
  </div>
</div>

<div id="qdEmpty" class="qd-empty">지표를 고르면 정의서가 나타납니다.</div>

<script>
(function(){
  var $root   = document.getElementById('qpsDef');
  var INDI_CD = $root.getAttribute('data-indicd') || '';
  var WNN_YN  = $root.getAttribute('data-wnn') || 'N';
  var curDef = null, apprLine = [], HOSP_NM = '';

  // ★hospCd 를 보내지 않는다 — 서버가 매 요청 쿠키(s_hospid)를 본다(다른 QPS 화면과 같은 원칙).
  //   ★dataType:'json' 필수 — 빠뜨리면 응답이 문자열로 와서 조용히 실패한다.
  function post(url, data){
    return $.ajax({ url:url, type:'POST', data:data, dataType:'json' }).then(function(res){
      if (res && res.result === 'FAIL') { throw new Error(res.message || '처리에 실패했습니다.'); }
      return res;
    });
  }
  function err(e){ _alertBox((e && e.message) ? e.message : '처리 중 오류가 발생했습니다.', {icon:'❌'}); }
  function val(id){ var el = document.getElementById(id); return el ? String(el.value).trim() : ''; }
  function set(id, v){ var el = document.getElementById(id); if (el) el.value = (v == null ? '' : v); }
  function esc(s){ return (s==null?'':String(s)).replace(/[&<>"]/g, function(c){
      return ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;'})[c]; }); }
  function num(v){ return (v==null||v==='') ? '' : Number(v).toLocaleString(); }
  function cycNm(c){ return c === 'Q' ? '분기별' : c === 'H' ? '반기별' : c === 'Y' ? '연 1회' : (c || ''); }

  window.qdLoad = function(){
    var cd = document.getElementById('qdIndi').value || INDI_CD;
    if (!cd) { document.getElementById('qdBody').style.display = 'none';
               document.getElementById('qdEmpty').style.display = ''; return; }
    INDI_CD = cd;
    return post('/qps/indiDefGet.do', { indiCd: cd, inYear: new Date().getFullYear() }).then(function(res){
      var d = res.def || {};
      curDef = d;
      apprLine = res.line || [];
      if (res.hosp) {
        HOSP_NM = res.hosp.hospnm || '';
        var b = document.getElementById('qdHosp');
        if (b) b.textContent = '🏥 ' + HOSP_NM;
      }
      fillIndiSelect(res.list || [], cd);

      set('d_area', d.areanm);        set('d_deptNm', d.deptnm);
      set('d_indiNm', d.indinm);      set('d_ownerNm', d.ownernm);
      set('d_background', d.background);
      set('d_definition', d.definition);
      set('d_numerDesc', d.numerdesc); set('d_denomDesc', d.denomdesc);
      set('d_formula', '분자 ÷ 분모 × ' + num(d.multiplier || 1000) + ' = ' + (d.unit || ''));
      set('d_cycle', cycNm(d.cyclegb));
      set('d_includeTxt', d.includetxt); set('d_excludeTxt', d.excludetxt);
      set('d_targetVal', d.targetval);   set('d_prevVal', d.prevval);
      set('d_targetBase', d.targetbase);
      set('d_sourceNm', d.sourcenm);     set('d_methodNm', d.methodnm);
      set('d_rptCycle', d.rptcycle);     set('d_rptScope', d.rptscope);
      set('d_shareTxt', d.sharetxt);     set('d_note', d.note);

      var own = (d.own === 'Y');
      var ownEl = document.getElementById('qdOwn');
      ownEl.className = 'qd-own ' + (own ? 'y' : 'n');
      ownEl.textContent = own ? '우리 병원 정의서' : '공통 기본값';
      document.getElementById('qdUpd').textContent = own && d.upddttm ? ('최종수정 ' + d.upddttm) : '';
      // 아직 우리 병원 정의서가 없으면 되돌릴 것도 없다
      var rb = document.getElementById('qdResetBtn');
      if (rb) rb.style.display = own ? '' : 'none';

      document.getElementById('qdBody').style.display = '';
      document.getElementById('qdEmpty').style.display = 'none';
    }).catch(err);
  };

  function fillIndiSelect(list, cd){
    var sel = document.getElementById('qdIndi');
    if (sel.options.length && sel.getAttribute('data-filled') === 'Y') { sel.value = cd; return; }
    sel.innerHTML = '';
    var curArea = null, grp = null;
    (list || []).forEach(function(r){
      if (r.areanm !== curArea) {
        curArea = r.areanm;
        grp = document.createElement('optgroup');
        grp.label = curArea;
        sel.appendChild(grp);
      }
      var o = new Option(r.indinm, r.indicd);
      grp.appendChild(o);
    });
    sel.setAttribute('data-filled', 'Y');
    sel.value = cd;
  }

  window.qdSave = function(){
    if (!val('d_indiNm')) { _alertBox('지표명은 필수입니다.', {icon:'⚠️'}); return; }
    post('/qps/indiDefSave.do', {
      indiCd: INDI_CD,
      indiNm: val('d_indiNm'), definition: val('d_definition'),
      numerDesc: val('d_numerDesc'), denomDesc: val('d_denomDesc'),
      sourceNm: val('d_sourceNm'), methodNm: val('d_methodNm'),
      ownerNm: val('d_ownerNm'), deptNm: val('d_deptNm'),
      background: val('d_background'), includeTxt: val('d_includeTxt'), excludeTxt: val('d_excludeTxt'),
      targetVal: val('d_targetVal'), prevVal: val('d_prevVal'), targetBase: val('d_targetBase'),
      rptCycle: val('d_rptCycle'), rptScope: val('d_rptScope'),
      shareTxt: val('d_shareTxt'), note: val('d_note')
    }).then(function(){
      _toast('저장되었습니다.', 'ok');
      return qdLoad();
    }).catch(err);
  };

  window.qdReset = function(){
    _confirmBox({ msg:'이 병원 정의서를 지우고 <b>공통 기본값</b>으로 되돌릴까요?<br>' +
                      '<span style="color:#6b7c86;font-size:12px;">입력한 내용은 사라집니다.</span>',
      icon:'⚠️', okText:'되돌리기', okColor:'#b23b3b',
      onOk: function(){
        post('/qps/indiDefReset.do', { indiCd: INDI_CD }).then(function(){
          _toast('공통 기본값으로 되돌렸습니다.', 'ok');
          return qdLoad();
        }).catch(err);
      }});
  };

  window.qdGoIndi = function(){ location.href = '/main/qpsFall.do?indi=' + encodeURIComponent(INDI_CD); };

  // ---------- 인쇄(A4 정의서 1장) ----------
  // 지표분석보고서와 같은 방식 — 별도 창에 서식만 써 넣는다(앱 CSS·주소 바닥글이 안 붙는다).
  var PRINT_CSS =
    '@page{ size:A4 portrait; margin:14mm 14mm 16mm; }' +
    'body{ margin:0; font-family:"맑은 고딕",Malgun Gothic,sans-serif; color:#000; }' +
    '.h1{ font-size:19px; font-weight:800; text-align:center; margin:0 0 3px; }' +
    '.h2{ font-size:12.5px; text-align:center; color:#333; margin:0 0 12px; }' +
    'table{ width:100%; border-collapse:collapse; font-size:11px; }' +
    'th,td{ border:1px solid #666; padding:5px 6px; text-align:left; vertical-align:top; }' +
    'th{ background:#f0f0f0; font-weight:700; width:96px; white-space:nowrap; }' +
    '.appr{ float:right; width:auto; margin:0 0 6px 8px; font-size:10px; }' +
    '.appr th{ width:auto; text-align:center; background:#f2f2f2; padding:2px 6px; }' +
    '.appr td{ height:46px; width:62px; }' +
    '.foot{ margin-top:14px; font-size:11px; text-align:center; }' +
    'tr{ page-break-inside:avoid; }';

  window.qdPrint = function(){
    if (!curDef) { _alertBox('지표를 먼저 불러온 뒤 인쇄해 주세요.', {icon:'⚠️'}); return; }
    var d = curDef;
    var appr = apprLine.length
      ? ('<table class="appr"><thead><tr>' + apprLine.map(function(r){ return '<th>' + esc(r.stepnm) + '</th>'; }).join('') +
         '</tr></thead><tbody><tr>' + apprLine.map(function(){ return '<td></td>'; }).join('') + '</tr></tbody></table>')
      : '';
    function row(l, v){ return '<tr><th>' + esc(l) + '</th><td>' + esc(v || '') + '</td></tr>'; }
    var body =
      appr +
      '<div class="h1">지표정의서</div>' +
      '<div class="h2">' + esc(HOSP_NM) + '</div>' +
      '<div style="clear:both;"></div>' +
      '<table><tbody>' +
        row('해당영역', val('d_area')) +
        row('주관부서', val('d_deptNm')) +
        row('담당자',   val('d_ownerNm')) +
        row('지표명',   val('d_indiNm')) +
        row('선정배경', val('d_background')) +
        row('지표정의', val('d_definition')) +
        row('분자',     val('d_numerDesc')) +
        row('분모',     val('d_denomDesc')) +
        row('산식',     val('d_formula')) +
        row('포함기준', val('d_includeTxt')) +
        row('제외기준', val('d_excludeTxt')) +
        row('목표값',   val('d_targetVal') + (val('d_targetVal') ? (d.unit || '') : '')) +
        row('이전값',   val('d_prevVal') + (val('d_prevVal') ? (d.unit || '') : '')) +
        row('목표값 근거', val('d_targetBase')) +
        row('자료출처', val('d_sourceNm')) +
        row('자료분석', val('d_methodNm')) +
        row('산출주기', val('d_cycle')) +
        row('보고주기', val('d_rptCycle')) +
        row('보고범위', val('d_rptScope')) +
        row('성과공유', val('d_shareTxt')) +
        row('비고',     val('d_note')) +
      '</tbody></table>' +
      '<div class="foot">작성일 : ' + (function(){ var t = new Date();
          return t.getFullYear() + '. ' + (t.getMonth() + 1) + '. ' + t.getDate() + '.'; })() + '</div>';

    var title = ('지표정의서_' + val('d_indiNm') + '_' + HOSP_NM).replace(/[\\\/:*?"<>|]/g, '-');
    var w = window.open('', '_blank', 'width=900,height=1000');
    if (!w) { _alertBox('팝업이 차단되어 인쇄창을 열지 못했습니다.<br>주소창 오른쪽의 팝업 차단을 허용해 주세요.', {icon:'⚠️'}); return; }
    w.document.open();
    w.document.write('<!doctype html><html lang="ko"><head><meta charset="utf-8"><title>' + esc(title) +
      '</title><style>' + PRINT_CSS + '</style></head><body>' + body + '</body></html>');
    w.document.close();
    w.focus();
    setTimeout(function(){ try { w.print(); } catch (e) { } }, 300);
  };

  $(function(){
    // 지표가 지정돼 있으면 바로 열고, 없으면 목록만 채워 고르게 한다
    post('/qps/indiDefGet.do', { indiCd: INDI_CD || 'FALL', inYear: new Date().getFullYear() })
      .then(function(res){
        fillIndiSelect(res.list || [], INDI_CD || 'FALL');
        if (!INDI_CD) INDI_CD = 'FALL';
        document.getElementById('qdIndi').value = INDI_CD;
        return qdLoad();
      }).catch(err);
  });
})();
</script>
</div><%-- /#qpsDef --%>
</div><%-- /.dashboard-wrapper --%>
