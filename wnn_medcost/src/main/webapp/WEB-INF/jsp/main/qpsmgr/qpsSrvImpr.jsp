<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%-- qpsSrvImpr.jsp — 만족도 개선활동 결과보고서 (만족도 사이클 #6, 2026-08-11)

     원본은 `(원무)` `(원무2)` `(간호)` `(영양)` 4종이 따로 있지만 ***서식은 하나다.***
     실측(2026-08-10)에서 확인된 것 : 이름 뒤 숫자(원무2)는 연번이 아니라 <유형이 다르다>는 표시다.
       (원무)=병원 의료 관련 · (원무2)=시설 및 환경 · (간호)=간병 서비스 관련 · (영양)=유형 비어 있음
     ⇒ 저장 단위는 **연도 × 부서 × 유형**. 목록에서 골라 쓰는 여러 장짜리 문서다.

     ★유형은 코드 고정이 아니다 — 「선택 + 직접입력」 둘 다 받는다((영양) 버전은 비어 있다).
     ★개선사진은 v1 에서 **문서 단위 공통 첨부**(REF_GB='SRVIMPR')로 둔다.
       원본은 표의 마지막 칸이 사진이지만, 행마다 업로드 위젯을 띄우는 비용이 크다.

     ★주의: 이 파일 안에서 Deferred EL 표기(샵+중괄호) 금지 --%>

<script src="/asset/js/ui-message.js"></script>
<%@ include file="/WEB-INF/jsp/main/inc/qpsFileBox.jsp" %>

<div class="dashboard-wrapper">
<div id="qpsSrvImpr" data-wnn="<c:out value='${wnnYn}'/>">
<style>
  #qpsSrvImpr{ background:#f4f6f8; color:#1f2a30; min-height:100%; padding:14px 16px 60px; max-width:100%; overflow-x:hidden; }
  #qpsSrvImpr *{ box-sizing:border-box; }
  #qpsSrvImpr .si-head{ display:flex; align-items:center; gap:10px; margin-bottom:12px; flex-wrap:wrap; }
  #qpsSrvImpr .si-title{ font-size:18px; font-weight:800; color:#20303a; display:flex; align-items:center; gap:8px; }
  #qpsSrvImpr .si-dot{ width:10px; height:10px; border-radius:50%; background:linear-gradient(135deg,#1f5a4b,#2a7665); }
  #qpsSrvImpr .si-sub{ font-size:12px; color:#6b7c86; }
  #qpsSrvImpr .si-hosp{ background:#e7f3ee; color:#1f5a4b; font-size:12px; font-weight:800;
      border:1px solid #cfe3da; border-radius:14px; padding:3px 11px; }
  #qpsSrvImpr .si-spacer{ flex:1; }
  #qpsSrvImpr select, #qpsSrvImpr input[type=text], #qpsSrvImpr input[type=date], #qpsSrvImpr textarea{
      border:1px solid #cfd8e0; border-radius:6px; padding:6px 9px; font-family:inherit; font-size:13px; background:#fff; width:100%; }
  #qpsSrvImpr textarea{ min-height:78px; resize:vertical; line-height:1.6; }
  #qpsSrvImpr .si-btn{ border:1px solid #1f5a4b; background:#1f5a4b; color:#fff; border-radius:6px;
      padding:6px 14px; font-size:13px; font-weight:600; cursor:pointer; white-space:nowrap; }
  #qpsSrvImpr .si-btn.ghost{ background:#fff; color:#1f5a4b; }
  #qpsSrvImpr .si-btn.warn{ background:#fff; color:#b23b3b; border-color:#e0b4b4; }
  #qpsSrvImpr .si-btn.mini{ padding:2px 9px; font-size:11.5px; border-color:#cfd8e0; color:#556570; background:#fff; }

  #qpsSrvImpr .si-wrap{ display:flex; gap:14px; align-items:flex-start; }
  #qpsSrvImpr .si-left{ width:300px; flex:none; }
  #qpsSrvImpr .si-right{ flex:1; min-width:0; }
  #qpsSrvImpr .si-card{ background:#fff; border:1px solid #e3e9ed; border-radius:10px; padding:14px 16px; margin-bottom:12px; }
  #qpsSrvImpr .si-card h4{ margin:0 0 10px; font-size:14px; font-weight:800; color:#1f5a4b; }
  #qpsSrvImpr .si-card h4 .hint{ font-weight:500; font-size:12px; color:#8a99a3; }

  #qpsSrvImpr .si-list{ max-height:520px; overflow:auto; }
  #qpsSrvImpr .si-item{ padding:9px 11px; border:1px solid #eef2f5; border-radius:8px; margin-bottom:7px; cursor:pointer; }
  #qpsSrvImpr .si-item:hover{ border-color:#8fc3b2; background:#f7fbf9; }
  #qpsSrvImpr .si-item.on{ border-color:#1f5a4b; background:#f0f7f4; }
  #qpsSrvImpr .si-item .t{ font-size:13px; font-weight:700; color:#20303a; }
  #qpsSrvImpr .si-item .d{ font-size:11.5px; color:#8a99a3; margin-top:2px; }
  #qpsSrvImpr .si-empty{ color:#8a99a3; font-size:12.5px; padding:16px 6px; text-align:center; }

  #qpsSrvImpr .si-form{ display:grid; grid-template-columns:110px 1fr 110px 1fr; gap:9px 10px; align-items:start; }
  #qpsSrvImpr .si-form .lb{ font-size:12.5px; font-weight:700; color:#43555f; padding-top:8px; }
  #qpsSrvImpr .si-form .full{ grid-column:2 / -1; }
  #qpsSrvImpr table.ed{ width:100%; border-collapse:collapse; font-size:12.5px; }
  #qpsSrvImpr table.ed th{ background:#f2f6f8; border:1px solid #dde5ea; padding:5px 6px; font-weight:700; color:#43555f; }
  #qpsSrvImpr table.ed td{ border:1px solid #e6ecef; padding:3px; vertical-align:top; }
  #qpsSrvImpr table.ed input, #qpsSrvImpr table.ed textarea{ width:100%; border:none; background:transparent; padding:4px 5px; min-height:0; }
  #qpsSrvImpr table.ed textarea{ min-height:46px; }
  #qpsSrvImpr .rowdel{ color:#b23b3b; cursor:pointer; font-weight:700; text-align:center; width:26px; }
  /* ── 탭 · 글자 크기 (2026-08-15) — 카드가 세로로 쌓여 스크롤이 길다는 지적.
       ★한 화면에 들어가면 **탭을 내지 않는다**(고정으로 달지 않는다).
       ★탭 이름은 카드 제목에서 뽑고, 많으면 이웃끼리 묶어 **최대 4개**. */
  #qpsSrvImpr .zz-tabs{ display:flex; gap:6px; margin:0 0 10px; flex-wrap:wrap; align-items:center; }
  #qpsSrvImpr .zz-tab{ border:1px solid #cfd9e0; background:#f4f7f9; color:#43555f; border-radius:8px 8px 0 0;
                   padding:7px 15px; font-size:13.5px; font-weight:700; cursor:pointer; }
  #qpsSrvImpr .zz-tab:hover{ background:#e9eff3; }
  #qpsSrvImpr .zz-tab.on{ background:#1f5a4b; border-color:#1f5a4b; color:#fff; }
  #qpsSrvImpr .zz-tab.dim{ opacity:.5; }
  #qpsSrvImpr .zz-mode{ margin-left:auto; border:1px solid #1f5a4b; background:#fff; color:#1f5a4b;
                    border-radius:8px; padding:7px 14px; font-size:13px; font-weight:700; cursor:pointer; }
  #qpsSrvImpr .zz-mode.on{ background:#1f5a4b; color:#fff; }
  #qpsSrvImpr .zz-zoom{ display:inline-flex; gap:4px; align-items:center; margin-left:2px; }
  #qpsSrvImpr .zz-zoom button{ border:1px solid #cfd9e0; background:#fff; color:#43555f; border-radius:6px;
                           padding:4px 9px; font-size:13px; font-weight:700; cursor:pointer; }
  #qpsSrvImpr .zz-zoom button:hover{ background:#eef3f6; }
</style>

<div class="si-head">
  <div class="si-title"><span class="si-dot"></span>만족도 개선활동 결과보고서
    <span class="si-sub">부서 × 유형으로 여러 장</span></div>
  <span class="si-hosp" id="siHosp">🏥 <c:out value="${hospNm}" default="병원 미확인"/></span>
  <div class="si-spacer"></div>
  <select id="siYear" style="width:auto;" onchange="siList();"></select>
  <button type="button" class="si-btn" onclick="siSave();">저장</button>
  <button type="button" class="si-btn ghost" onclick="siPrint();">🖨 인쇄(A4)</button>
  <button type="button" class="si-btn warn" id="siDelBtn" onclick="siDel();" style="display:none;">삭제</button>
  <span class="si-sub" id="siStat"></span>
  <span style="flex:0 0 60px;"></span>
  <%-- 글자 크기 — 이 PC 이 브라우저에만 저장된다 --%>
  <span class="zz-zoom">
    <button type="button" onclick="zzZoom(-1);" title="글자 작게">가－</button>
    <button type="button" onclick="zzZoom(1);"  title="글자 크게">가＋</button>
    <button type="button" onclick="zzZoom(0);"  title="처음 크기로">↺</button>
  </span>
</div>
<%-- ★탭 — 내용이 한 화면을 넘칠 때만 나온다(zzSync 가 재 본다) --%>
<div class="zz-tabs" id="zzTabs" style="display:none;"></div>

<div class="si-wrap">
  <div class="si-left">
    <div class="si-card">
      <h4>보고서 목록 <span class="hint" id="siCnt"></span></h4>
      <div class="si-list" id="siListBox"><div class="si-empty">불러오는 중…</div></div>
      <button type="button" class="si-btn ghost" style="width:100%; margin-top:6px;" onclick="siNew();">＋ 새 보고서</button>
    </div>
  </div>

  <div class="si-right">
    <div class="si-card">
      <h4>개선활동 <span class="hint">— 인쇄물 결재란은 결재선 단계만큼 빈칸으로 나갑니다</span></h4>
      <input type="hidden" id="f_imprSeq" value="">
      <div class="si-form">
        <div class="lb">부서명 *</div>  <div><input type="text" id="f_deptNm" maxlength="60" placeholder="원무 · 간호 · 영양 …"></div>
        <div class="lb">유형</div>
        <div>
          <%-- 선택 + 직접입력. ★(영양) 버전은 유형이 비어 있고 자유 문구를 쓴다 — 코드로 고정하면 안 된다 --%>
          <input type="text" id="f_typeNm" maxlength="100" list="siTypeList" placeholder="목록에서 고르거나 직접 적습니다(비워 둘 수 있음)">
          <datalist id="siTypeList"></datalist>
        </div>
        <div class="lb">보고일</div>    <div><input type="date" id="f_rptDt"></div>
        <div class="lb">개선일시</div>  <div><input type="date" id="f_imprDt"></div>
        <div class="lb">주제</div>      <div class="full"><input type="text" id="f_topic" maxlength="300"></div>
        <div class="lb">문제진술</div>  <div class="full"><textarea id="f_problem"></textarea></div>
        <div class="lb">현상파악 및<br>원인분석</div> <div class="full"><textarea id="f_analysis"></textarea></div>
        <div class="lb">개선 대책안</div> <div class="full"><textarea id="f_planTxt"></textarea></div>
      </div>
    </div>

    <div class="si-card">
      <h4>개선방안 적용 · Action · 개선지속 <span class="hint">— 유형을 비우면 위의 유형이 들어갑니다</span></h4>
      <table class="ed"><thead><tr>
        <th style="width:150px;">유형</th><th>의료서비스만족도 문제점</th><th>개선활동</th><th style="width:26px;"></th>
      </tr></thead><tbody id="itBody"></tbody></table>
      <button type="button" class="si-btn mini" style="margin-top:6px;" onclick="siItAdd();">＋ 행 추가</button>
    </div>

    <div class="si-card">
      <h4>개선사진 · 첨부파일 <span class="hint">— 원본 표의 「개선사진」 칸을 문서 단위 첨부로 대신합니다</span></h4>
      <div id="siFileBox"></div>
    </div>
  </div>
</div>

<script>
(function(){
  var curSeq = 0, HOSP_NM = '', APPR_LINE = [];

  var fileBox = window.qpsFileBox({ mount:'siFileBox', refGb:'SRVIMPR',
      hint:'개선 전·후 사진', needSaveMsg:'보고서를 먼저 저장하면 사진을 붙일 수 있습니다.' });

  function gel(id){ return document.getElementById(id); }   // ★$ 로 짓지 말 것 — jQuery 가 가려진다
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

  (function(){
    var y = new Date().getFullYear(), sel = gel('siYear');
    for (var i = y + 1; i >= y - 4; i--) sel.add(new Option(i + '년', i));
    sel.value = y;
  })();

  /* 유형 목록 — 코드가 없거나 조회가 실패해도 화면은 그대로 쓴다(직접입력이라 목록은 거들 뿐).
     ★codeList.do 는 QPS_ 전체를 한 번에 주고 응답 키는 codes 다(list 아님). */
  function loadTypes(){
    post('<c:url value="/qps/codeList.do"/>', {}).then(function(res){
      var rows = (res && res.codes && res.codes.QPS_SRVIMPR_TYPE) || [];
      gel('siTypeList').innerHTML = rows.map(function(c){
        return '<option value="' + esc(c.subcode) + '">' + esc(c.subcodenm) + '</option>';
      }).join('');
    }).catch(function(){ /* 목록이 없어도 직접입력으로 동작한다 */ });
  }

  function itAdd(r){
    r = r || {};
    var tr = document.createElement('tr');
    tr.innerHTML =
      '<td><input type="text" data-f="typenm" value="' + esc(r.typenm) + '"></td>' +
      '<td><textarea data-f="problem">' + esc(r.problem) + '</textarea></td>' +
      '<td><textarea data-f="actiontxt">' + esc(r.actiontxt) + '</textarea></td>' +
      '<td class="rowdel" onclick="this.closest(\'tr\').remove();">✕</td>';
    gel('itBody').appendChild(tr);
  }
  window.siItAdd = function(){ itAdd({}); };

  function collectItems(){
    var out = [], sort = 0;
    document.querySelectorAll('#itBody tr').forEach(function(tr){
      var r = { sort: sort + 1 };
      tr.querySelectorAll('[data-f]').forEach(function(el){ r[el.getAttribute('data-f')] = String(el.value).trim(); });
      if (r.typenm || r.problem || r.actiontxt) { out.push(r); sort++; }
    });
    return out;
  }

  window.siList = function(){
    return post('<c:url value="/qps/srvImprList.do"/>', { inYear: gel('siYear').value }).then(function(res){
      if (res.hosp) { HOSP_NM = res.hosp.hospnm || ''; gel('siHosp').textContent = '🏥 ' + HOSP_NM; }
      APPR_LINE = res.line || [];
      var list = res.list || [], box = gel('siListBox');
      gel('siCnt').textContent = list.length ? ('· ' + list.length + '건') : '';
      if (!list.length) { box.innerHTML = '<div class="si-empty">보고서가 없습니다.<br>[＋ 새 보고서]로 만드세요.</div>'; return; }
      box.innerHTML = list.map(function(r){
        return '<div class="si-item' + (Number(r.imprseq) === curSeq ? ' on' : '') + '" onclick="siOpen(' + r.imprseq + ');">' +
               '<div class="t">' + esc(r.deptnm || '(부서 없음)') + (r.typenm ? ' · ' + esc(r.typenm) : '') + '</div>' +
               '<div class="d">' + esc(r.topic || '') + (r.upddttm ? ' · 수정 ' + esc(r.upddttm) : '') + '</div></div>';
      }).join('');
    }).catch(err);
  };

  window.siOpen = function(seq){
    post('<c:url value="/qps/srvImprGet.do"/>', { imprSeq: seq }).then(function(res){
      var d = res.doc || {};
      curSeq = Number(d.imprseq || 0);
      set('f_imprSeq', d.imprseq); set('f_deptNm', d.deptnm); set('f_typeNm', d.typenm);
      set('f_topic', d.topic); set('f_problem', d.problem); set('f_analysis', d.analysis);
      set('f_planTxt', d.plantxt); set('f_imprDt', d.imprdt); set('f_rptDt', d.rptdt);
      gel('itBody').innerHTML = '';
      (res.items || []).forEach(itAdd);
      if (!(res.items || []).length) itAdd({});
      gel('siStat').textContent = '— 저장된 보고서 #' + d.imprseq;
      gel('siDelBtn').style.display = '';
      if (fileBox) fileBox.setKey(d.imprseq);
      siList();
    }).catch(err);
  };

  window.siNew = function(){
    curSeq = 0;
    ['f_imprSeq','f_deptNm','f_typeNm','f_topic','f_problem','f_analysis','f_planTxt','f_imprDt','f_rptDt']
      .forEach(function(id){ set(id, ''); });
    gel('itBody').innerHTML = '';
    itAdd({}); itAdd({});
    gel('siStat').textContent = '— 새 보고서';
    gel('siDelBtn').style.display = 'none';
    if (fileBox) fileBox.setKey('');     // 저장 전엔 첨부 잠금
    siList();
  };

  window.siSave = function(){
    if (!val('f_deptNm')) { _alertBox('부서명을 입력해 주세요.', {icon:'⚠️'}); return; }
    post('<c:url value="/qps/srvImprSave.do"/>', {
      imprSeq: val('f_imprSeq'), inYear: gel('siYear').value,
      deptNm: val('f_deptNm'), typeNm: val('f_typeNm'), topic: val('f_topic'),
      problem: val('f_problem'), analysis: val('f_analysis'), planTxt: val('f_planTxt'),
      imprDt: val('f_imprDt'), rptDt: val('f_rptDt'),
      items: JSON.stringify(collectItems())
    }).then(function(res){
      _toast('저장되었습니다.', 'ok');
      siOpen(res.imprSeq);
    }).catch(err);
  };

  window.siDel = function(){
    if (!curSeq) return;
    _confirmBox({ msg:'이 보고서를 삭제할까요?', icon:'⚠️', okText:'삭제', okColor:'#b23b3b',
      onOk: function(){
        post('<c:url value="/qps/srvImprDelete.do"/>', { imprSeq: curSeq }).then(function(){
          _toast('삭제되었습니다.', 'ok');
          siNew();
        }).catch(err);
      } });
  };

  // ---------- 인쇄(A4 1장) — 별도 창(QPS 공통 방식) ----------
  var PRINT_CSS =
    '@page{ size:A4 portrait; margin:12mm 12mm 14mm; }' +
    'body{ margin:0; font-family:"맑은 고딕",Malgun Gothic,sans-serif; color:#000; }' +
    '.h1{ font-size:18px; font-weight:800; text-align:center; margin:0 0 10px; letter-spacing:1px; }' +
    'table{ width:100%; border-collapse:collapse; font-size:10.5px; margin-bottom:6px; }' +
    'th,td{ border:1px solid #666; padding:5px 6px; text-align:center; vertical-align:middle; line-height:1.6; }' +
    'th{ background:#efefef; font-weight:700; }' +
    'td.l{ text-align:left; } td.pre{ text-align:left; white-space:pre-wrap; min-height:44px; }' +
    '.appr{ float:right; width:auto; margin:0 0 6px 8px; font-size:10px; }' +
    '.appr th{ padding:2px 6px; } .appr td{ height:44px; width:60px; }' +
    'tr{ page-break-inside:avoid; }';

  function apprHtml(){
    if (!APPR_LINE.length) return '';
    var h = '<table class="appr"><thead><tr>';
    APPR_LINE.forEach(function(r){ h += '<th>' + esc(r.stepnm) + '</th>'; });
    h += '</tr></thead><tbody><tr>';
    APPR_LINE.forEach(function(){ h += '<td></td>'; });
    return h + '</tr></tbody></table>';
  }

  window.siPrint = function(){
    var yy = gel('siYear').value, headType = val('f_typeNm');
    function row(lb, v){ return '<tr><th style="width:110px;">' + lb + '</th><td class="pre" colspan="3">' + esc(v) + '</td></tr>'; }

    var items = collectItems();
    var tbl = '<table><thead><tr><th style="width:120px;">유형</th>' +
      '<th>의료서비스만족도 문제점</th><th>개선활동</th></tr></thead><tbody>' +
      (items.length ? items : [{}]).map(function(r){
        // 행 유형이 비면 머리의 유형을 쓴다 — 원본은 표 안에 유형이 찍혀 나온다
        return '<tr><td>' + esc(r.typenm || headType) + '</td>' +
               '<td class="pre">' + esc(r.problem || '') + '</td>' +
               '<td class="pre">' + esc(r.actiontxt || '') + '</td></tr>';
      }).join('') + '</tbody></table>';

    var body = apprHtml() +
      '<div class="h1">' + esc(yy) + '년 의료서비스 만족도 개선활동 결과보고서</div>' +
      '<div style="clear:both;"></div>' +
      '<table><tbody>' +
        '<tr><th style="width:110px;">부서명</th><td class="l" style="width:33%;">' + esc(val('f_deptNm')) + '</td>' +
            '<th style="width:110px;">보고일</th><td class="l">' + esc(val('f_rptDt')) + '</td></tr>' +
        row('주제', val('f_topic')) +
        row('문제진술', val('f_problem')) +
        row('현상파악 및 원인분석', val('f_analysis')) +
        row('개선 대책안', val('f_planTxt')) +
        '<tr><th>개선방안 적용<br>Action · 개선지속</th><td class="l" colspan="3">개선일시 &nbsp;' +
          esc(val('f_imprDt')) + '</td></tr>' +
      '</tbody></table>' + tbl +
      '<div style="font-size:10px;color:#444;margin-top:4px;">※ 개선사진은 첨부파일로 관리합니다.</div>';

    var title = ('만족도개선활동_' + yy + '_' + val('f_deptNm') + '_' + headType).replace(/[\\\/:*?"<>|]/g, '-');
    var w = window.open('', '_blank', 'width=900,height=1000');
    if (!w) { _alertBox('팝업이 차단되어 인쇄창을 열지 못했습니다.<br>주소창 오른쪽의 팝업 차단을 허용해 주세요.', {icon:'⚠️'}); return; }
    w.document.open();
    w.document.write('<!doctype html><html lang="ko"><head><meta charset="utf-8"><title>' + esc(title) +
      '</title><style>' + PRINT_CSS + '</style></head><body>' + body + '</body></html>');
    w.document.close();
    w.focus();
    setTimeout(function(){ try { w.print(); } catch (e) { } }, 300);
  };

  $(function(){ loadTypes(); siNew(); });
})();

  /* ═══ 탭 · 글자 크기 (2026-08-15 · 사용자 요청) ═══════════════════════════
     ★***고정으로 달지 않는다*** — 전부 펼친 높이를 재서 **한 화면을 넘칠 때만** 탭을 낸다.
       창 크기·글자 크기가 바뀌면 다시 잰다.
     ★탭이 **잘게 나뉘지 않게** 이웃 카드를 묶어 최대 4개. 이름은 첫 카드 제목(+「외」).
     ★「전체 보기」는 탭이 아니라 **보기 방식**이라 오른쪽 끝에 따로 둔다.
     ⚠인쇄는 별도 창이라 탭과 무관하다(숨긴 항목도 종이에는 다 나온다). */
  (function(){
    var KEY = 'qpsTab_qpsSrvImpr', ZKEY = 'qpsZoom_qpsSrvImpr', cur = 0;
    function cards(){ return [].slice.call(document.querySelectorAll('#qpsSrvImpr .si-card')); }
    function nm(c, i){
      var h = c.querySelector('h4');
      if (!h) return '항목 ' + (i + 1);
      var t = h.cloneNode(true), hint = t.querySelector('.hint');
      if (hint) hint.remove();
      return (t.textContent || '').trim().slice(0, 20) || ('항목 ' + (i + 1));
    }
    function fits(cs){
      if (cs.length < 2) return true;
      var prev = cs.map(function(c){ return c.style.display; });
      cs.forEach(function(c){ c.style.display = ''; });
      var h = 0;
      cs.forEach(function(c){ h += c.offsetHeight + 12; });
      cs.forEach(function(c, i){ c.style.display = prev[i]; });
      return h <= (window.innerHeight - 170);
    }
    function sync(){
      var cs = cards(), box = document.getElementById('zzTabs');
      if (!box || !cs.length) return;
      if (fits(cs)) {                       // 한 화면에 들어간다 — 탭이 필요 없다
        box.style.display = 'none';
        cs.forEach(function(c){ c.style.display = ''; });
        return;
      }
      box.style.display = '';
      var MAX = 4, per = Math.ceil(cs.length / MAX), groups = [];
      for (var s0 = 0; s0 < cs.length; s0 += per) groups.push(cs.slice(s0, s0 + per));
      if (cur >= groups.length) cur = 0;
      var all = (cur === -1);
      box.innerHTML = groups.map(function(g, i){
        return '<button type="button" class="zz-tab' + (!all && cur === i ? ' on' : '') +
               (all ? ' dim' : '') + '" onclick="zzTab(' + i + ');">' +
               nm(g[0], 0) + (g.length > 1 ? ' 외' : '') + '</button>';
      }).join('') +
        '<button type="button" class="zz-mode' + (all ? ' on' : '') + '" onclick="zzTab(' +
        (all ? '0' : '-1') + ');">' + (all ? '▤ 나눠 보기' : '☰ 전체 보기') + '</button>';
      groups.forEach(function(g, i){
        g.forEach(function(c){ c.style.display = (all || cur === i) ? '' : 'none'; });
      });
    }
    window.zzTab = function(i){ cur = i; try { localStorage.setItem(KEY, String(i)); } catch (e) {} sync(); };
    function zoom(z){
      z = Math.min(1.6, Math.max(0.8, z));
      var w = document.getElementById('qpsSrvImpr');
      if (w) w.style.zoom = z.toFixed(2);
      return z;
    }
    window.zzZoom = function(d){
      var w = document.getElementById('qpsSrvImpr'), c0 = parseFloat(w && w.style.zoom) || 1;
      if (d === 0) { zoom(1); try { localStorage.removeItem(ZKEY); } catch (e) {} setTimeout(sync, 0); return; }
      var z = zoom(c0 + d * 0.1);
      try { localStorage.setItem(ZKEY, String(z)); } catch (e) {}
      setTimeout(sync, 0);
    };
    try {
      var t = parseInt(localStorage.getItem(KEY), 10); if (!isNaN(t)) cur = t;
      var z = parseFloat(localStorage.getItem(ZKEY)); if (z) zoom(z);
    } catch (e) {}
    function boot(){ setTimeout(sync, 0); }
    if (window.jQuery) jQuery(boot); else document.addEventListener('DOMContentLoaded', boot);
    /* ★내용이 **나중에** 채워지면 다시 잰다 (2026-08-15).
       카드 속은 AJAX 로 채우는데 높이는 부팅 직후에 쟀다 — 긴 문서인데도
       「한 화면에 들어간다」로 잘못 보고 탭이 안 나오던 구멍이다.
       ⚠**탭 띠 자신이 바뀐 것은 무시한다** — 안 그러면 재기→그리기→재기 로 서로 부른다. */
    if (window.MutationObserver) {
      var _mw = document.getElementById('qpsSrvImpr'), _mt;
      if (_mw) new MutationObserver(function(ms){
        var box = document.getElementById('zzTabs');
        for (var i = 0; i < ms.length; i++) {
          if (!box || !box.contains(ms[i].target)) {
            clearTimeout(_mt); _mt = setTimeout(sync, 250); return;
          }
        }
      }).observe(_mw, { childList: true, subtree: true });
    }
    var _t; window.addEventListener('resize', function(){ clearTimeout(_t); _t = setTimeout(sync, 200); });
    window.zzResync = sync;
  })();
</script>
</div><%-- /#qpsSrvImpr --%>
</div><%-- /.dashboard-wrapper --%>
