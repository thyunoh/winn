<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%-- qpsSafeRpt.jsp — 사고 유형별 보고서 (보고서 폴더, 2026-08-11)

     원본 트리 10종. 실측 8종 대조 결과 ***골격은 같고 체크박스 묶음만 통째로 다르다.***
     ⇒ 지표 18종을 화면 하나로 처리한 방식 그대로 :
        **공통 골격은 화면 하나, 체크박스 묶음은 데이터(항목표)로.**
        이 화면에는 유형별 분기가 없다 — 서버가 준 항목표(def)를 순회해 그릴 뿐이다.
        서식이 늘어도 TBL_QPS_SAFERPT_DEF·_USE 에 행을 넣으면 끝난다.

     ★★사고 원천은 TBL_QPS_INCIDENT 재사용. 사고를 고르면 환자·일시·장소가 채워진다 —
       ***같은 사고를 지표용·보고서용으로 두 번 입력하게 만들지 않는다.***

     ★근접오류는 없다(원본도 준비중 메뉴) · 라운딩 점검표는 서식 3호 · 정신은 별도 과제.
     ★주의: 이 파일 안에서 Deferred EL 표기(샵+중괄호) 금지 --%>

<script src="/asset/js/ui-message.js"></script>
<%@ include file="/WEB-INF/jsp/main/inc/qpsFileBox.jsp" %>

<div class="dashboard-wrapper">
<div id="qpsSafeRpt" data-wnn="<c:out value='${wnnYn}'/>">
<style>
  #qpsSafeRpt{ background:#f4f6f8; color:#1f2a30; min-height:100%; padding:14px 16px 60px; max-width:100%; overflow-x:hidden; }
  #qpsSafeRpt *{ box-sizing:border-box; }
  #qpsSafeRpt .sr-head{ display:flex; align-items:center; gap:10px; margin-bottom:12px; flex-wrap:wrap; }
  #qpsSafeRpt .sr-title{ font-size:18px; font-weight:800; color:#20303a; display:flex; align-items:center; gap:8px; }
  #qpsSafeRpt .sr-dot{ width:10px; height:10px; border-radius:50%; background:linear-gradient(135deg,#1f5a4b,#2a7665); }
  #qpsSafeRpt .sr-sub{ font-size:12px; color:#6b7c86; }
  #qpsSafeRpt .sr-hosp{ background:#e7f3ee; color:#1f5a4b; font-size:12px; font-weight:800;
      border:1px solid #cfe3da; border-radius:14px; padding:3px 11px; }
  #qpsSafeRpt .sr-spacer{ flex:1; }
  #qpsSafeRpt select, #qpsSafeRpt input, #qpsSafeRpt textarea{
      border:1px solid #cfd8e0; border-radius:5px; padding:5px 7px; font-family:inherit; font-size:12.5px; background:#fff; }
  #qpsSafeRpt textarea{ resize:vertical; line-height:1.55; width:100%; }
  #qpsSafeRpt .sr-btn{ border:1px solid #1f5a4b; background:#1f5a4b; color:#fff; border-radius:6px;
      padding:6px 14px; font-size:13px; font-weight:600; cursor:pointer; white-space:nowrap; }
  #qpsSafeRpt .sr-btn.ghost{ background:#fff; color:#1f5a4b; }
  #qpsSafeRpt .sr-btn.warn{ background:#fff; color:#b23b3b; border-color:#e0b4b4; }

  #qpsSafeRpt .sr-wrap{ display:flex; gap:14px; align-items:flex-start; }
  #qpsSafeRpt .sr-left{ width:260px; flex:none; }
  #qpsSafeRpt .sr-right{ flex:1; min-width:0; max-width:1000px; }
  #qpsSafeRpt .sr-card{ background:#fff; border:1px solid #e3e9ed; border-radius:10px; padding:14px 16px; margin-bottom:12px; }
  #qpsSafeRpt .sr-card h4{ margin:0 0 10px; font-size:14px; font-weight:800; color:#1f5a4b; }
  #qpsSafeRpt .sr-card h4 .hint{ font-weight:500; font-size:12px; color:#8a99a3; }
  #qpsSafeRpt .sr-list{ max-height:520px; overflow:auto; }
  #qpsSafeRpt .sr-item{ padding:8px 10px; border:1px solid #eef2f5; border-radius:8px; margin-bottom:6px; cursor:pointer; }
  #qpsSafeRpt .sr-item:hover{ border-color:#8fc3b2; background:#f7fbf9; }
  #qpsSafeRpt .sr-item.on{ border-color:#1f5a4b; background:#f0f7f4; }
  #qpsSafeRpt .sr-item .t{ font-size:13px; font-weight:700; color:#20303a; }
  #qpsSafeRpt .sr-item .d{ font-size:11.5px; color:#8a99a3; margin-top:2px; }
  #qpsSafeRpt .sr-empty{ color:#8a99a3; font-size:12.5px; padding:16px 6px; text-align:center; }

  #qpsSafeRpt .sr-form{ display:grid; grid-template-columns:110px 1fr 110px 1fr; gap:9px 10px; align-items:start; }
  #qpsSafeRpt .sr-form .lb{ font-size:12.5px; font-weight:700; color:#43555f; padding-top:8px; }
  #qpsSafeRpt .sr-form .full{ grid-column:2 / -1; }
  #qpsSafeRpt .sr-form input{ width:100%; }

  /* 체크 묶음 — 항목표에서 그린다 */
  #qpsSafeRpt .grp{ border:1px solid #e6ecef; border-radius:8px; padding:9px 11px; margin-bottom:8px; }
  #qpsSafeRpt .grp .gn{ font-size:12.5px; font-weight:800; color:#43555f; margin-bottom:6px; }
  #qpsSafeRpt .grp label{ display:inline-flex; align-items:center; gap:4px; margin:0 14px 6px 0; font-size:12.5px; }
  #qpsSafeRpt .grp input[type=checkbox], #qpsSafeRpt .grp input[type=radio]{
      -webkit-appearance:auto !important; appearance:auto !important;
      width:15px !important; height:15px !important; margin:0 !important; display:inline-block !important;
      opacity:1 !important; visibility:visible !important; position:static !important; cursor:pointer; }
  #qpsSafeRpt .grp input.etc{ width:130px; padding:2px 6px; font-size:12px; }
</style>

<div class="sr-head">
  <div class="sr-title"><span class="sr-dot"></span><span id="srTitle">환자안전사고 보고서</span>
    <span class="sr-sub">사고 유형별</span></div>
  <span class="sr-hosp" id="srHosp">🏥 <c:out value="${hospNm}" default="병원 미확인"/></span>
  <div class="sr-spacer"></div>
  <%-- ★유형 — 이 셀렉트가 바뀌면 체크 묶음이 통째로 갈린다(항목표에서 다시 받아 그린다) --%>
  <select id="srGb" style="width:auto;" onchange="srLoad();"></select>
  <select id="srYear" style="width:auto;" onchange="srLoad();"></select>
  <button type="button" class="sr-btn" onclick="srSave();">저장</button>
  <button type="button" class="sr-btn ghost" onclick="srPrint();">🖨 인쇄(A4)</button>
  <button type="button" class="sr-btn warn" id="srDelBtn" onclick="srDel();" style="display:none;">삭제</button>
  <span class="sr-sub" id="srStat"></span>
  <span style="flex:0 0 60px;"></span>
</div>

<div class="sr-wrap">
  <div class="sr-left">
    <div class="sr-card">
      <h4>보고서 목록 <span class="hint" id="srCnt"></span></h4>
      <div class="sr-list" id="srListBox"><div class="sr-empty">불러오는 중…</div></div>
      <button type="button" class="sr-btn ghost" style="width:100%; margin-top:6px;" onclick="srNew();">＋ 새 보고서</button>
    </div>
  </div>

  <div class="sr-right">
    <div class="sr-card">
      <h4>대상 · 발생 <span class="hint">— [사고에서 가져오기]로 이미 등록한 사고를 골라 채울 수 있습니다</span></h4>
      <input type="hidden" id="f_srpSeq" value="">
      <input type="hidden" id="f_incidSeq" value="">
      <div style="margin-bottom:10px; display:flex; gap:8px; align-items:center; flex-wrap:wrap;">
        <%-- ★사고를 고르면 대상·일시·장소가 채워진다. 같은 사고를 두 번 입력하지 않으려는 장치다. --%>
        <select id="f_incidPick" style="min-width:320px;"><option value="">— 등록된 사고에서 가져오기 —</option></select>
        <button type="button" class="sr-btn ghost" onclick="srUseIncid();">↧ 가져오기</button>
        <span class="sr-sub" id="srIncidMsg"></span>
      </div>
      <div class="sr-form">
        <div class="lb">발생일 *</div>  <div><input type="date" id="f_occurDt"></div>
        <div class="lb">발생시각</div>  <div><input type="text" id="f_occurTm" maxlength="5" placeholder="14:30"></div>
        <div class="lb">보고일</div>    <div><input type="date" id="f_rptDt"></div>
        <div class="lb">발생장소</div>  <div><input type="text" id="f_place" maxlength="200"></div>
        <div class="lb" id="lbTargetNm">성명</div>  <div><input type="text" id="f_targetNm" maxlength="60"></div>
        <div class="lb" id="lbTargetNo">등록번호</div> <div><input type="text" id="f_targetNo" maxlength="40"></div>
        <div class="lb">부서</div>      <div><input type="text" id="f_deptNm" maxlength="60"></div>
        <div class="lb">직위</div>      <div><input type="text" id="f_positionNm" maxlength="60"></div>
        <div class="lb" id="lbAdmit">입원일</div> <div><input type="date" id="f_admitDt"></div>
        <div class="lb" id="lbDiag">진단명</div>  <div><input type="text" id="f_diagNm" maxlength="200"></div>
      </div>
    </div>

    <%-- ★체크 묶음 — 항목표(def)에서 그린다. 이 화면에 유형별 분기가 없다. --%>
    <div class="sr-card" id="cardChk">
      <h4>구분 <span class="hint" id="srChkHint">— 유형에 따라 항목이 바뀝니다</span></h4>
      <div id="srChkBox"></div>
    </div>

    <div class="sr-card">
      <h4>사건개요 (육하원칙) <span class="hint">— 안 쓰는 서식은 비워 두면 인쇄물에도 안 나옵니다</span></h4>
      <div class="sr-form">
        <div class="lb">언제</div>   <div><input type="text" id="f_wWhen" maxlength="300"></div>
        <div class="lb">누가</div>   <div><input type="text" id="f_wWho" maxlength="300"></div>
        <div class="lb">어디서</div> <div><input type="text" id="f_wWhere" maxlength="300"></div>
        <div class="lb">무엇을</div> <div><input type="text" id="f_wWhat" maxlength="500"></div>
        <div class="lb">어떻게</div> <div class="full"><input type="text" id="f_wHow" maxlength="500"></div>
        <div class="lb">왜</div>     <div class="full"><input type="text" id="f_wWhy" maxlength="500"></div>
      </div>
    </div>

    <div class="sr-card">
      <h4>서술</h4>
      <div class="sr-form">
        <div class="lb">사건경위</div>   <div class="full"><textarea id="f_summary" rows="3"></textarea></div>
        <div class="lb">활력징후</div>   <div class="full"><textarea id="f_vitalTxt" rows="2"></textarea></div>
        <div class="lb">신체손상정도<br>· 결과</div> <div class="full"><textarea id="f_injuryTxt" rows="2"></textarea></div>
        <div class="lb">치료내용<br>· 진료내역</div> <div class="full"><textarea id="f_treatTxt" rows="3"></textarea></div>
        <div class="lb">문제원인<br>· 발생원인</div> <div class="full"><textarea id="f_causeTxt" rows="3"></textarea></div>
        <div class="lb">개선방안<br>· 처리결과</div> <div class="full"><textarea id="f_planTxt" rows="3"></textarea></div>
        <div class="lb">비고</div>       <div class="full"><textarea id="f_note" rows="2"></textarea></div>
      </div>
    </div>

    <div class="sr-card">
      <h4>사진 · 첨부파일</h4>
      <div id="srFileBox"></div>
    </div>
  </div>
</div>

<script>
(function(){
  var HOSP_NM = '', APPR_LINE = [], DEF = [], GBS = [], curSeq = 0;

  var fileBox = window.qpsFileBox({ mount:'srFileBox', refGb:'SAFERPT',
      hint:'사고 관련 사진·자료', needSaveMsg:'보고서를 먼저 저장하면 첨부할 수 있습니다.' });

  function gel(id){ return document.getElementById(id); }   // ★$ 로 짓지 말 것
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
  function gb(){ return gel('srGb').value || 'PTSAFE'; }
  function gbNm(){ for (var i=0;i<GBS.length;i++) if (GBS[i].subcode === gb()) return GBS[i].subcodenm; return '사고 보고서'; }

  (function(){
    var y = new Date().getFullYear(), sel = gel('srYear');
    for (var i = y + 1; i >= y - 4; i--) sel.add(new Option(i + '년', i));
    sel.value = y;
  })();

  /** 직원 대상 서식이면 라벨을 바꾼다 — 환자 등록번호를 직원에게 물으면 안 된다. */
  function applyLabels(){
    var staff = (gb() === 'STAFF' || gb() === 'INFEXP' || gb() === 'HAZMAT' || gb() === 'HARASS' || gb() === 'SECU');
    gel('lbTargetNm').textContent = staff ? '직원 성명' : '환자 성명';
    gel('lbTargetNo').textContent = staff ? '사번' : '등록번호';
    gel('lbAdmit').style.opacity = staff ? '.4' : '1';
    gel('lbDiag').style.opacity  = staff ? '.4' : '1';
    gel('srTitle').textContent = gbNm();
  }

  /** ★체크 묶음을 항목표에서 그린다. 유형별 하드코딩이 없다. */
  function renderChk(sel){
    sel = sel || {};   // { grpcd: { items:[], etc:{item:txt} } }
    var box = gel('srChkBox');
    if (!DEF.length) {
      box.innerHTML = '<div class="sr-empty">이 서식에는 체크 항목이 없습니다.<br>' +
                      '<span style="font-size:11.5px;">항목을 늘리려면 기준정보의 사고 보고서 항목표에 행을 넣으면 됩니다.</span></div>';
      gel('cardChk').style.display = '';
      return;
    }
    var groups = [], byGrp = {};
    DEF.forEach(function(d){
      if (!byGrp[d.grpcd]) { byGrp[d.grpcd] = { cd:d.grpcd, nm:d.grpnm, multi:(d.multiyn === 'Y'), items:[] }; groups.push(byGrp[d.grpcd]); }
      byGrp[d.grpcd].items.push(d);
    });
    box.innerHTML = groups.map(function(g){
      var picked = (sel[g.cd] && sel[g.cd].items) || [];
      var etcs   = (sel[g.cd] && sel[g.cd].etc) || {};
      var h = '<div class="grp"><div class="gn">' + esc(g.nm) +
              (g.multi ? '' : ' <span style="font-weight:500;color:#8a99a3;">(하나만)</span>') + '</div>';
      g.items.forEach(function(it){
        var on = picked.indexOf(it.itemnm) >= 0;
        h += '<label><input type="' + (g.multi ? 'checkbox' : 'radio') + '"' +
             (g.multi ? '' : ' name="rd_' + esc(g.cd) + '"') +
             ' data-grp="' + esc(g.cd) + '" data-item="' + esc(it.itemnm) + '"' + (on ? ' checked' : '') + '>' +
             esc(it.itemnm);
        if (it.etcyn === 'Y') {
          h += ' <input class="etc" type="text" data-etc="' + esc(g.cd) + '|' + esc(it.itemnm) + '" value="' +
               esc(etcs[it.itemnm] || '') + '" placeholder="내용">';
        }
        h += '</label>';
      });
      return h + '</div>';
    }).join('');
    gel('cardChk').style.display = '';
  }

  function collectChk(){
    var out = [];
    document.querySelectorAll('#srChkBox [data-grp]').forEach(function(el){
      if (!el.checked) return;
      var g = el.getAttribute('data-grp'), it = el.getAttribute('data-item');
      var etcEl = document.querySelector('#srChkBox [data-etc="' + g + '|' + it + '"]');
      out.push({ grpcd:g, itemnm:it, etctxt: etcEl ? String(etcEl.value).trim() : '' });
    });
    return out;
  }
  function chkToSel(rows){
    var sel = {};
    (rows || []).forEach(function(r){
      if (!sel[r.grpcd]) sel[r.grpcd] = { items:[], etc:{} };
      sel[r.grpcd].items.push(r.itemnm);
      if (r.etctxt) sel[r.grpcd].etc[r.itemnm] = r.etctxt;
    });
    return sel;
  }

  window.srLoad = function(){
    return post('<c:url value="/qps/safeRptBase.do"/>', { inYear: gel('srYear').value, rptGb: gb() }).then(function(res){
      if (res.hosp) { HOSP_NM = res.hosp.hospnm || ''; gel('srHosp').textContent = '🏥 ' + HOSP_NM; }
      APPR_LINE = res.line || [];
      DEF = res.def || [];
      applyLabels();
      renderChk({});
      var list = res.list || [], box = gel('srListBox');
      gel('srCnt').textContent = list.length ? ('· ' + list.length + '건') : '';
      box.innerHTML = list.length
        ? list.map(function(r){
            return '<div class="sr-item' + (Number(r.srpseq) === curSeq ? ' on' : '') + '" onclick="srOpen(' + r.srpseq + ');">' +
                   '<div class="t">' + esc(r.targetnm || '(대상 없음)') + '</div>' +
                   '<div class="d">' + esc(r.occurdt || '') + (r.deptnm ? ' · ' + esc(r.deptnm) : '') + '</div></div>';
          }).join('')
        : '<div class="sr-empty">보고서가 없습니다.<br>[＋ 새 보고서]로 만드세요.</div>';
    }).catch(err);
  };

  window.srOpen = function(seq){
    post('<c:url value="/qps/safeRptGet.do"/>', { srpSeq: seq }).then(function(res){
      var d = res.doc || {};
      curSeq = Number(d.srpseq || 0);
      if (d.rptgb && d.rptgb !== gb()) { gel('srGb').value = d.rptgb; applyLabels(); }
      set('f_srpSeq', d.srpseq); set('f_incidSeq', d.incidseq || '');
      set('f_occurDt', d.occurdt); set('f_occurTm', d.occurtm); set('f_rptDt', d.rptdt);
      set('f_place', d.place); set('f_targetNm', d.targetnm); set('f_targetNo', d.targetno);
      set('f_deptNm', d.deptnm); set('f_positionNm', d.positionnm);
      set('f_admitDt', d.admitdt); set('f_diagNm', d.diagnm);
      set('f_wWhen', d.wwhen); set('f_wWho', d.wwho); set('f_wWhere', d.wwhere);
      set('f_wWhat', d.wwhat); set('f_wHow', d.whow); set('f_wWhy', d.wwhy);
      set('f_summary', d.summary); set('f_vitalTxt', d.vitaltxt); set('f_injuryTxt', d.injurytxt);
      set('f_treatTxt', d.treattxt); set('f_causeTxt', d.causetxt); set('f_planTxt', d.plantxt);
      set('f_note', d.note);
      gel('srIncidMsg').textContent = d.incidseq ? ('사고 #' + d.incidseq + ' 와 연결됨') : '';
      renderChk(chkToSel(res.chks));
      gel('srStat').textContent = '— 저장된 보고서 #' + d.srpseq;
      gel('srDelBtn').style.display = '';
      if (fileBox) fileBox.setKey(d.srpseq);
      srListRefresh();
    }).catch(err);
  };
  function srListRefresh(){
    document.querySelectorAll('#srListBox .sr-item').forEach(function(el){ el.classList.remove('on'); });
    var m = document.querySelector('#srListBox .sr-item[onclick*="(' + curSeq + ')"]');
    if (m) m.classList.add('on');
  }

  window.srNew = function(){
    curSeq = 0;
    ['f_srpSeq','f_incidSeq','f_occurDt','f_occurTm','f_rptDt','f_place','f_targetNm','f_targetNo',
     'f_deptNm','f_positionNm','f_admitDt','f_diagNm','f_wWhen','f_wWho','f_wWhere','f_wWhat',
     'f_wHow','f_wWhy','f_summary','f_vitalTxt','f_injuryTxt','f_treatTxt','f_causeTxt',
     'f_planTxt','f_note'].forEach(function(id){ set(id, ''); });
    gel('srIncidMsg').textContent = '';
    renderChk({});
    gel('srStat').textContent = '— 새 보고서';
    gel('srDelBtn').style.display = 'none';
    if (fileBox) fileBox.setKey('');
    srListRefresh();
  };

  /* ★사고 목록 — 이미 등록한 사고를 골라 대상·일시·장소를 채운다.
     같은 사고를 두 번 입력하게 만들지 않으려는 것이 이 서식의 핵심 설계다.
     사고가 없어도 화면은 그대로 쓴다(직접 입력). */
  var INCID = [];
  function loadIncid(){
    post('<c:url value="/qps/incidentList.do"/>', { inYear: gel('srYear').value }).then(function(res){
      INCID = res.list || [];
      var sel = gel('f_incidPick');
      sel.innerHTML = '<option value="">— 등록된 사고에서 가져오기 —</option>';
      INCID.forEach(function(r){
        var t = (r.patnm || '(이름 없음)') + ' · ' + (r.occurdt || '') + (r.place ? ' · ' + r.place : '');
        sel.add(new Option(t, r.incidseq));
      });
      if (!INCID.length) sel.options[0].text = '— 등록된 사고가 없습니다 (직접 입력) —';
    }).catch(function(){ INCID = []; });
  }
  window.srUseIncid = function(){
    var seq = val('f_incidPick');
    if (!seq) { _alertBox('가져올 사고를 먼저 고르세요.', {icon:'⚠️'}); return; }
    var r = null;
    for (var i = 0; i < INCID.length; i++) if (String(INCID[i].incidseq) === seq) { r = INCID[i]; break; }
    if (!r) return;
    set('f_incidSeq', seq);
    var dt = String(r.occurdt || '').replace(/-/g, '');
    if (dt.length === 8) set('f_occurDt', dt.substr(0,4) + '-' + dt.substr(4,2) + '-' + dt.substr(6,2));
    if (r.patnm) set('f_targetNm', r.patnm);
    if (r.place) set('f_place', r.place);
    gel('srIncidMsg').textContent = '사고 #' + seq + ' 에서 가져왔습니다.';
  };

  window.srSave = function(){
    if (!val('f_occurDt')) { _alertBox('발생일을 입력해 주세요.', {icon:'⚠️'}); return; }
    post('<c:url value="/qps/safeRptSave.do"/>', {
      srpSeq: val('f_srpSeq'), inYear: gel('srYear').value, rptGb: gb(),
      incidSeq: val('f_incidSeq'),
      occurDt: val('f_occurDt'), occurTm: val('f_occurTm'), rptDt: val('f_rptDt'), place: val('f_place'),
      targetNm: val('f_targetNm'), targetNo: val('f_targetNo'), deptNm: val('f_deptNm'),
      positionNm: val('f_positionNm'), admitDt: val('f_admitDt'), diagNm: val('f_diagNm'),
      wWhen: val('f_wWhen'), wWho: val('f_wWho'), wWhere: val('f_wWhere'),
      wWhat: val('f_wWhat'), wHow: val('f_wHow'), wWhy: val('f_wWhy'),
      summary: val('f_summary'), vitalTxt: val('f_vitalTxt'), injuryTxt: val('f_injuryTxt'),
      treatTxt: val('f_treatTxt'), causeTxt: val('f_causeTxt'), planTxt: val('f_planTxt'), note: val('f_note'),
      chks: JSON.stringify(collectChk())
    }).then(function(res){
      _toast('저장되었습니다.', 'ok');
      return srLoad().then(function(){ srOpen(res.srpSeq); });
    }).catch(err);
  };

  window.srDel = function(){
    if (!curSeq) return;
    _confirmBox({ msg:'이 보고서를 삭제할까요?', icon:'⚠️', okText:'삭제', okColor:'#b23b3b',
      onOk: function(){
        post('<c:url value="/qps/safeRptDelete.do"/>', { srpSeq: curSeq }).then(function(){
          _toast('삭제되었습니다.', 'ok'); srNew(); srLoad();
        }).catch(err);
      } });
  };

  // ---------- 인쇄 ----------
  var PRINT_CSS =
    '@page{ size:A4 portrait; margin:12mm; }' +
    'body{ margin:0; font-family:"맑은 고딕",Malgun Gothic,sans-serif; color:#000; }' +
    '.h1{ font-size:17px; font-weight:800; text-align:center; margin:0 0 8px; letter-spacing:1px; }' +
    'table{ width:100%; border-collapse:collapse; font-size:10px; margin-bottom:5px; }' +
    'th,td{ border:1px solid #666; padding:4px 5px; text-align:center; vertical-align:middle; line-height:1.55; }' +
    'th{ background:#efefef; font-weight:700; }' +
    'td.l{ text-align:left; } td.pre{ text-align:left; white-space:pre-wrap; }' +
    '.appr{ float:right; width:auto; margin:0 0 4px 8px; font-size:9.5px; }' +
    '.appr th{ padding:2px 6px; } .appr td{ height:42px; width:58px; }' +
    'tr{ page-break-inside:avoid; }';

  function apprHtml(){
    if (!APPR_LINE.length) return '';
    var h = '<table class="appr"><thead><tr>';
    APPR_LINE.forEach(function(r){ h += '<th>' + esc(r.stepnm) + '</th>'; });
    h += '</tr></thead><tbody><tr>';
    APPR_LINE.forEach(function(){ h += '<td></td>'; });
    return h + '</tr></tbody></table>';
  }

  window.srPrint = function(){
    // 체크는 ☑/☐ 로 낸다 — 종이 서식과 같은 모양
    var sel = {};
    collectChk().forEach(function(c){
      if (!sel[c.grpcd]) sel[c.grpcd] = {};
      sel[c.grpcd][c.itemnm] = c.etctxt || true;
    });
    var byGrp = {}, groups = [];
    DEF.forEach(function(d){
      if (!byGrp[d.grpcd]) { byGrp[d.grpcd] = { cd:d.grpcd, nm:d.grpnm, items:[] }; groups.push(byGrp[d.grpcd]); }
      byGrp[d.grpcd].items.push(d);
    });
    var chkRows = groups.map(function(g){
      var line = g.items.map(function(it){
        var v = sel[g.cd] && sel[g.cd][it.itemnm];
        var etc = (typeof v === 'string' && v) ? ('( ' + esc(v) + ' )') : (it.etcyn === 'Y' ? '(　　)' : '');
        return (v ? '☑ ' : '☐ ') + esc(it.itemnm) + ' ' + etc;
      }).join(' &nbsp; ');
      return '<tr><th style="width:110px;">' + esc(g.nm) + '</th><td class="l">' + line + '</td></tr>';
    }).join('');

    function row(lb, v){ return v ? ('<tr><th style="width:110px;">' + lb + '</th><td class="pre" colspan="3">' + esc(v) + '</td></tr>') : ''; }
    var six = [['언제', val('f_wWhen')], ['누가', val('f_wWho')], ['어디서', val('f_wWhere')],
               ['무엇을', val('f_wWhat')], ['어떻게', val('f_wHow')], ['왜', val('f_wWhy')]]
              .filter(function(x){ return x[1]; });

    var body = apprHtml() +
      '<div class="h1">' + esc(gbNm()) + '</div><div style="clear:both;"></div>' +
      '<table><tbody>' +
        '<tr><th style="width:110px;">발생일시</th><td class="l" style="width:32%;">' +
          esc(val('f_occurDt')) + ' ' + esc(val('f_occurTm')) + '</td>' +
          '<th style="width:90px;">보고일</th><td class="l">' + esc(val('f_rptDt')) + '</td></tr>' +
        '<tr><th>' + esc(gel('lbTargetNm').textContent) + '</th><td class="l">' + esc(val('f_targetNm')) + '</td>' +
          '<th>' + esc(gel('lbTargetNo').textContent) + '</th><td class="l">' + esc(val('f_targetNo')) + '</td></tr>' +
        '<tr><th>부서 / 직위</th><td class="l">' + esc(val('f_deptNm')) + ' ' + esc(val('f_positionNm')) + '</td>' +
          '<th>발생장소</th><td class="l">' + esc(val('f_place')) + '</td></tr>' +
        (val('f_admitDt') || val('f_diagNm')
          ? '<tr><th>입원일</th><td class="l">' + esc(val('f_admitDt')) + '</td>' +
            '<th>진단명</th><td class="l">' + esc(val('f_diagNm')) + '</td></tr>' : '') +
      '</tbody></table>' +
      (chkRows ? '<table><tbody>' + chkRows + '</tbody></table>' : '') +
      (six.length ? '<table><tbody><tr><th style="width:110px;" rowspan="' + six.length + '">사건개요</th>' +
          six.map(function(x, i){
            return (i === 0 ? '' : '<tr>') + '<th style="width:70px;">' + x[0] + '</th><td class="l" colspan="2">' +
                   esc(x[1]) + '</td>' + (i === 0 ? '</tr>' : '</tr>');
          }).join('') + '</tbody></table>' : '') +
      '<table><tbody>' +
        row('사건경위', val('f_summary')) + row('활력징후', val('f_vitalTxt')) +
        row('신체손상정도·결과', val('f_injuryTxt')) + row('치료내용·진료내역', val('f_treatTxt')) +
        row('문제원인·발생원인', val('f_causeTxt')) + row('개선방안·처리결과', val('f_planTxt')) +
        row('비고', val('f_note')) +
      '</tbody></table>';

    var title = (gbNm() + '_' + val('f_occurDt') + '_' + val('f_targetNm') + '_' + HOSP_NM).replace(/[\\\/:*?"<>|]/g, '-');
    var w = window.open('', '_blank', 'width=900,height=1000');
    if (!w) { _alertBox('팝업이 차단되어 인쇄창을 열지 못했습니다.<br>주소창 오른쪽의 팝업 차단을 허용해 주세요.', {icon:'⚠️'}); return; }
    w.document.open();
    w.document.write('<!doctype html><html lang="ko"><head><meta charset="utf-8"><title>' + esc(title) +
      '</title><style>' + PRINT_CSS + '</style></head><body>' + body + '</body></html>');
    w.document.close();
    w.focus();
    setTimeout(function(){ try { w.print(); } catch (e) { } }, 300);
  };

  // 유형 목록은 공통코드에서 — 유형이 늘어도 화면을 안 고친다
  $(function(){
    post('<c:url value="/qps/codeList.do"/>', {}).then(
      function(res){ GBS = (res && res.codes && res.codes.QPS_SAFERPT_GB) || []; step2(); },
      function(){ GBS = []; step2(); }
    );
    function step2(){
      var sel = gel('srGb');
      sel.innerHTML = GBS.length
        ? GBS.map(function(c){ return '<option value="' + esc(c.subcode) + '">' + esc(c.subcodenm) + '</option>'; }).join('')
        : '<option value="PTSAFE">환자안전사고 보고서</option>';
      srNew();
      srLoad();
      loadIncid();
    }
  });
})();
</script>
</div><%-- /#qpsSafeRpt --%>
</div><%-- /.dashboard-wrapper --%>
