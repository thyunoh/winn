<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%-- qpsRca.jsp — RCA 환자 안전사고 근본원인 분석 보고서 (2026-08-11)

     원본 1면. ***FMEA 보다 훨씬 단순하다 — 표 하나에 5단계, 계산이 없다.***
     항목이 고정이라 항목표(DEF)가 필요 없다(사고 보고서와 다른 점).

     ★원본 좌측의 라디오 1~4 는 「한 해에 여러 건」이라는 뜻일 뿐이라 옮기지 않는다.
       목록으로 풀고 건수를 막지 않는다(불만고충 처리결과서의 「1~14」 와 같은 판단).
     ★환자 정보는 사고(TBL_QPS_INCIDENT)에서 가져온다 — 두 번 입력하지 않는다.
     ★RCA 회의록은 이 화면에 없다 — 서식 1호(회의록)에 구분 R 로 흡수했다.

     ★주의: 이 파일 안에서 Deferred EL 표기(샵+중괄호) 금지 --%>

<script src="/asset/js/ui-message.js"></script>
<%@ include file="/WEB-INF/jsp/main/inc/qpsFileBox.jsp" %>

<div class="dashboard-wrapper">
<div id="qpsRca" data-wnn="<c:out value='${wnnYn}'/>">
<style>
  #qpsRca{ background:#f4f6f8; color:#1f2a30; min-height:100%; padding:14px 16px 60px; max-width:100%; overflow-x:hidden; }
  #qpsRca *{ box-sizing:border-box; }
  #qpsRca .rc-head{ display:flex; align-items:center; gap:10px; margin-bottom:12px; flex-wrap:wrap; }
  #qpsRca .rc-title{ font-size:18px; font-weight:800; color:#20303a; display:flex; align-items:center; gap:8px; }
  #qpsRca .rc-dot{ width:10px; height:10px; border-radius:50%; background:linear-gradient(135deg,#1f5a4b,#2a7665); }
  #qpsRca .rc-sub{ font-size:12px; color:#6b7c86; }
  #qpsRca .rc-hosp{ background:#e7f3ee; color:#1f5a4b; font-size:12px; font-weight:800;
      border:1px solid #cfe3da; border-radius:14px; padding:3px 11px; }
  #qpsRca .rc-spacer{ flex:1; }
  #qpsRca select, #qpsRca input, #qpsRca textarea{
      border:1px solid #cfd8e0; border-radius:5px; padding:5px 7px; font-family:inherit; font-size:12.5px; background:#fff; }
  #qpsRca textarea{ resize:vertical; line-height:1.55; width:100%; }
  #qpsRca .rc-btn{ border:1px solid #1f5a4b; background:#1f5a4b; color:#fff; border-radius:6px;
      padding:6px 14px; font-size:13px; font-weight:600; cursor:pointer; white-space:nowrap; }
  #qpsRca .rc-btn.ghost{ background:#fff; color:#1f5a4b; }
  #qpsRca .rc-btn.warn{ background:#fff; color:#b23b3b; border-color:#e0b4b4; }

  #qpsRca .rc-wrap{ display:flex; gap:14px; align-items:flex-start; }
  #qpsRca .rc-left{ width:250px; flex:none; }
  #qpsRca .rc-right{ flex:1; min-width:0; max-width:980px; }
  #qpsRca .rc-card{ background:#fff; border:1px solid #e3e9ed; border-radius:10px; padding:14px 16px; margin-bottom:12px; }
  #qpsRca .rc-card h4{ margin:0 0 10px; font-size:14px; font-weight:800; color:#1f5a4b; }
  #qpsRca .rc-card h4 .hint{ font-weight:500; font-size:12px; color:#8a99a3; }
  #qpsRca .rc-card h4 .step{ display:inline-block; padding:1px 7px; background:#1f5a4b; color:#fff;
      border-radius:4px; font-size:11.5px; margin-right:6px; }
  #qpsRca .rc-list{ max-height:520px; overflow:auto; }
  #qpsRca .rc-item{ padding:8px 10px; border:1px solid #eef2f5; border-radius:8px; margin-bottom:6px; cursor:pointer; }
  #qpsRca .rc-item:hover{ border-color:#8fc3b2; background:#f7fbf9; }
  #qpsRca .rc-item.on{ border-color:#1f5a4b; background:#f0f7f4; }
  #qpsRca .rc-item .t{ font-size:13px; font-weight:700; color:#20303a; }
  #qpsRca .rc-item .d{ font-size:11.5px; color:#8a99a3; margin-top:2px; }
  #qpsRca .rc-empty{ color:#8a99a3; font-size:12.5px; padding:16px 6px; text-align:center; }

  #qpsRca .rc-form{ display:grid; grid-template-columns:110px 1fr 110px 1fr; gap:9px 10px; align-items:start; }
  #qpsRca .rc-form .lb{ font-size:12.5px; font-weight:700; color:#43555f; padding-top:8px; }
  #qpsRca .rc-form .full{ grid-column:2 / -1; }
  #qpsRca .rc-form input{ width:100%; }
</style>

<div class="rc-head">
  <div class="rc-title"><span class="rc-dot"></span>환자 안전사고 근본원인 분석 보고서
    <span class="rc-sub">RCA · 5단계</span></div>
  <span class="rc-hosp" id="rcHosp">🏥 <c:out value="${hospNm}" default="병원 미확인"/></span>
  <div class="rc-spacer"></div>
  <select id="rcYear" style="width:auto;" onchange="rcLoad();"></select>
  <button type="button" class="rc-btn" onclick="rcSave();">저장</button>
  <button type="button" class="rc-btn ghost" onclick="rcPrint();">🖨 인쇄(A4)</button>
  <button type="button" class="rc-btn warn" id="rcDelBtn" onclick="rcDel();" style="display:none;">삭제</button>
  <span class="rc-sub" id="rcStat"></span>
  <span style="flex:0 0 60px;"></span>
</div>

<div class="rc-wrap">
  <div class="rc-left">
    <div class="rc-card">
      <h4>보고서 목록 <span class="hint" id="rcCnt"></span></h4>
      <div class="rc-list" id="rcListBox"><div class="rc-empty">불러오는 중…</div></div>
      <button type="button" class="rc-btn ghost" style="width:100%; margin-top:6px;" onclick="rcNew();">＋ 새 보고서</button>
    </div>
  </div>

  <div class="rc-right">
    <div class="rc-card">
      <h4>대상 <span class="hint">— 등록된 사고를 고르면 환자·일시·장소가 채워집니다</span></h4>
      <input type="hidden" id="f_rcaSeq" value="">
      <input type="hidden" id="f_incidSeq" value="">
      <div style="margin-bottom:10px; display:flex; gap:8px; align-items:center; flex-wrap:wrap;">
        <select id="f_incidPick" style="min-width:320px;"><option value="">— 등록된 사고에서 가져오기 —</option></select>
        <button type="button" class="rc-btn ghost" onclick="rcUseIncid();">↧ 가져오기</button>
        <span class="rc-sub" id="rcIncidMsg"></span>
      </div>
      <div class="rc-form">
        <div class="lb">호실</div>      <div><input type="text" id="f_roomNm" maxlength="40"></div>
        <div class="lb">이름</div>      <div><input type="text" id="f_patNm" maxlength="60"></div>
        <div class="lb">등록번호</div>  <div><input type="text" id="f_patNo" maxlength="40"></div>
        <div class="lb">성별/나이</div> <div><input type="text" id="f_sexAge" maxlength="40" placeholder="여 / 82"></div>
      </div>
    </div>

    <div class="rc-card">
      <h4><span class="step">1단계</span>문제 확인</h4>
      <div class="rc-form">
        <div class="lb">발생일시 *</div>
        <div style="display:flex; gap:6px;">
          <input type="date" id="f_occurDt" style="flex:1;">
          <input type="text" id="f_occurTm" maxlength="5" placeholder="14:30" style="width:90px;">
        </div>
        <div class="lb">발생장소</div>  <div><input type="text" id="f_occurPl" maxlength="200"></div>
        <div class="lb">문제요약</div>  <div class="full"><textarea id="f_problem" rows="3"></textarea></div>
      </div>
    </div>

    <div class="rc-card">
      <h4><span class="step">2단계</span>현황 파악</h4>
      <div class="rc-form">
        <div class="lb">과정(Process)<br>분석 및 문제 확인</div>
        <div class="full"><textarea id="f_processTxt" rows="4"></textarea></div>
      </div>
    </div>

    <div class="rc-card">
      <h4><span class="step">3단계</span>관련요인 분석</h4>
      <div class="rc-form">
        <div class="lb">인적자원<br>— 개인</div>   <div class="full"><textarea id="f_hrPerson" rows="2"></textarea></div>
        <div class="lb">인적자원<br>— 교육</div>   <div class="full"><textarea id="f_hrEdu" rows="2"></textarea></div>
        <div class="lb">시스템<br>— 과정</div>     <div class="full"><textarea id="f_syProc" rows="2"></textarea></div>
        <div class="lb">시스템<br>— 장비</div>     <div class="full"><textarea id="f_syEquip" rows="2"></textarea></div>
        <div class="lb">시스템<br>— 환경</div>     <div class="full"><textarea id="f_syEnv" rows="2"></textarea></div>
        <div class="lb">시스템<br>— 의사소통</div> <div class="full"><textarea id="f_syComm" rows="2"></textarea></div>
        <div class="lb">시스템<br>— 기타</div>     <div class="full"><textarea id="f_syEtc" rows="2"></textarea></div>
      </div>
    </div>

    <div class="rc-card">
      <h4><span class="step">4단계</span>개선활동</h4>
      <div class="rc-form">
        <div class="lb">인적자원</div>      <div class="full"><textarea id="f_actHr" rows="3"></textarea></div>
        <div class="lb">시스템(System)</div> <div class="full"><textarea id="f_actSy" rows="3"></textarea></div>
        <div class="lb">기타</div>          <div class="full"><textarea id="f_actEtc" rows="2"></textarea></div>
      </div>
    </div>

    <div class="rc-card">
      <h4><span class="step">5단계</span>결과평가</h4>
      <textarea id="f_resultTxt" rows="4"></textarea>
      <div class="rc-form" style="margin-top:10px;">
        <div class="lb">작성일</div>  <div><input type="date" id="f_writeDt"></div>
        <div class="lb">작성자</div>  <div><input type="text" id="f_writerNm" maxlength="60"></div>
      </div>
    </div>

    <div class="rc-card">
      <h4>첨부파일</h4>
      <div id="rcFileBox"></div>
    </div>
  </div>
</div>

<script>
(function(){
  var HOSP_NM = '', APPR_LINE = [], INCID = [], curSeq = 0;

  var fileBox = window.qpsFileBox({ mount:'rcFileBox', refGb:'RCA',
      hint:'근거자료', needSaveMsg:'보고서를 먼저 저장하면 첨부할 수 있습니다.' });

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

  (function(){
    var y = new Date().getFullYear(), sel = gel('rcYear');
    for (var i = y + 1; i >= y - 4; i--) sel.add(new Option(i + '년', i));
    sel.value = y;
  })();

  function loadIncid(){
    post('<c:url value="/qps/incidentList.do"/>', { inYear: gel('rcYear').value }).then(function(res){
      INCID = res.list || [];
      var sel = gel('f_incidPick');
      sel.innerHTML = '<option value="">— 등록된 사고에서 가져오기 —</option>';
      INCID.forEach(function(r){
        sel.add(new Option((r.patnm || '(이름 없음)') + ' · ' + (r.occurdt || '') +
                           (r.place ? ' · ' + r.place : ''), r.incidseq));
      });
      if (!INCID.length) sel.options[0].text = '— 등록된 사고가 없습니다 (직접 입력) —';
    }).catch(function(){ INCID = []; });
  }
  window.rcUseIncid = function(){
    var seq = val('f_incidPick');
    if (!seq) { _alertBox('가져올 사고를 먼저 고르세요.', {icon:'⚠️'}); return; }
    var r = null;
    for (var i = 0; i < INCID.length; i++) if (String(INCID[i].incidseq) === seq) { r = INCID[i]; break; }
    if (!r) return;
    set('f_incidSeq', seq);
    var dt = String(r.occurdt || '').replace(/-/g, '');
    if (dt.length === 8) set('f_occurDt', dt.substr(0,4) + '-' + dt.substr(4,2) + '-' + dt.substr(6,2));
    if (r.patnm) set('f_patNm', r.patnm);
    if (r.place) set('f_occurPl', r.place);
    gel('rcIncidMsg').textContent = '사고 #' + seq + ' 에서 가져왔습니다.';
  };

  window.rcLoad = function(){
    return post('<c:url value="/qps/rcaList.do"/>', { inYear: gel('rcYear').value }).then(function(res){
      if (res.hosp) { HOSP_NM = res.hosp.hospnm || ''; gel('rcHosp').textContent = '🏥 ' + HOSP_NM; }
      APPR_LINE = res.line || [];
      var list = res.list || [], box = gel('rcListBox');
      gel('rcCnt').textContent = list.length ? ('· ' + list.length + '건') : '';
      box.innerHTML = list.length
        ? list.map(function(r){
            return '<div class="rc-item' + (Number(r.rcaseq) === curSeq ? ' on' : '') + '" onclick="rcOpen(' + r.rcaseq + ');">' +
                   '<div class="t">' + esc(r.patnm || '(대상 없음)') + '</div>' +
                   '<div class="d">' + esc(r.occurdt || '') + (r.occurpl ? ' · ' + esc(r.occurpl) : '') + '</div></div>';
          }).join('')
        : '<div class="rc-empty">보고서가 없습니다.<br>[＋ 새 보고서]로 만드세요.</div>';
    }).catch(err);
  };

  var FIELDS = ['f_rcaSeq','f_incidSeq','f_roomNm','f_patNm','f_patNo','f_sexAge','f_occurDt','f_occurTm',
                'f_occurPl','f_problem','f_processTxt','f_hrPerson','f_hrEdu','f_syProc','f_syEquip',
                'f_syEnv','f_syComm','f_syEtc','f_actHr','f_actSy','f_actEtc','f_resultTxt',
                'f_writeDt','f_writerNm'];

  window.rcOpen = function(seq){
    post('<c:url value="/qps/rcaGet.do"/>', { rcaSeq: seq }).then(function(res){
      var d = res.doc || {};
      curSeq = Number(d.rcaseq || 0);
      set('f_rcaSeq', d.rcaseq); set('f_incidSeq', d.incidseq || '');
      set('f_roomNm', d.roomnm); set('f_patNm', d.patnm); set('f_patNo', d.patno); set('f_sexAge', d.sexage);
      set('f_occurDt', d.occurdt); set('f_occurTm', d.occurtm); set('f_occurPl', d.occurpl);
      set('f_problem', d.problem); set('f_processTxt', d.processtxt);
      set('f_hrPerson', d.hrperson); set('f_hrEdu', d.hredu);
      set('f_syProc', d.syproc); set('f_syEquip', d.syequip); set('f_syEnv', d.syenv);
      set('f_syComm', d.sycomm); set('f_syEtc', d.syetc);
      set('f_actHr', d.acthr); set('f_actSy', d.actsy); set('f_actEtc', d.actetc);
      set('f_resultTxt', d.resulttxt); set('f_writeDt', d.writedt); set('f_writerNm', d.writernm);
      gel('rcIncidMsg').textContent = d.incidseq ? ('사고 #' + d.incidseq + ' 와 연결됨') : '';
      gel('rcStat').textContent = '— 저장된 보고서 #' + d.rcaseq;
      gel('rcDelBtn').style.display = '';
      if (fileBox) fileBox.setKey(d.rcaseq);
      rcLoad();
    }).catch(err);
  };

  window.rcNew = function(){
    curSeq = 0;
    FIELDS.forEach(function(id){ set(id, ''); });
    gel('rcIncidMsg').textContent = '';
    gel('rcStat').textContent = '— 새 보고서';
    gel('rcDelBtn').style.display = 'none';
    if (fileBox) fileBox.setKey('');
    rcLoad();
  };

  window.rcSave = function(){
    if (!val('f_occurDt')) { _alertBox('발생일시를 입력해 주세요.', {icon:'⚠️'}); return; }
    post('<c:url value="/qps/rcaSave.do"/>', {
      rcaSeq: val('f_rcaSeq'), inYear: gel('rcYear').value, incidSeq: val('f_incidSeq'),
      roomNm: val('f_roomNm'), patNm: val('f_patNm'), patNo: val('f_patNo'), sexAge: val('f_sexAge'),
      occurDt: val('f_occurDt'), occurTm: val('f_occurTm'), occurPl: val('f_occurPl'),
      problem: val('f_problem'), processTxt: val('f_processTxt'),
      hrPerson: val('f_hrPerson'), hrEdu: val('f_hrEdu'), syProc: val('f_syProc'),
      syEquip: val('f_syEquip'), syEnv: val('f_syEnv'), syComm: val('f_syComm'), syEtc: val('f_syEtc'),
      actHr: val('f_actHr'), actSy: val('f_actSy'), actEtc: val('f_actEtc'),
      resultTxt: val('f_resultTxt'), writeDt: val('f_writeDt'), writerNm: val('f_writerNm')
    }).then(function(res){
      _toast('저장되었습니다.', 'ok');
      rcOpen(res.rcaSeq);
    }).catch(err);
  };

  window.rcDel = function(){
    if (!curSeq) return;
    _confirmBox({ msg:'이 보고서를 삭제할까요?', icon:'⚠️', okText:'삭제', okColor:'#b23b3b',
      onOk: function(){
        post('<c:url value="/qps/rcaDelete.do"/>', { rcaSeq: curSeq }).then(function(){
          _toast('삭제되었습니다.', 'ok'); rcNew();
        }).catch(err);
      } });
  };

  // ---------- 인쇄(A4 1장) — 원본처럼 단계|항목|내용 3열 ----------
  var PRINT_CSS =
    '@page{ size:A4 portrait; margin:12mm; }' +
    'body{ margin:0; font-family:"맑은 고딕",Malgun Gothic,sans-serif; color:#000; }' +
    '.h1{ font-size:17px; font-weight:800; text-align:center; margin:0 0 10px; letter-spacing:1px; }' +
    'table{ width:100%; border-collapse:collapse; font-size:10px; }' +
    'th,td{ border:1px solid #666; padding:4px 5px; text-align:center; vertical-align:middle; line-height:1.55; }' +
    'th{ background:#efefef; font-weight:700; }' +
    'td.l{ text-align:left; } td.pre{ text-align:left; white-space:pre-wrap; }' +
    '.appr{ float:right; width:auto; margin:0 0 6px 8px; font-size:9.5px; }' +
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

  window.rcPrint = function(){
    function r1(step, rows, span){
      // 단계 칸은 세로 병합 — 원본 배치 그대로
      return rows.map(function(x, i){
        return '<tr>' + (i === 0 ? '<th rowspan="' + span + '" style="width:80px;">' + step + '</th>' : '') +
               '<th style="width:130px;">' + x[0] + '</th><td class="pre">' + esc(x[1]) + '</td></tr>';
      }).join('');
    }
    var s3 = [['인적자원 — 개인', val('f_hrPerson')], ['인적자원 — 교육', val('f_hrEdu')],
              ['시스템 — 과정(Process)', val('f_syProc')], ['시스템 — 장비', val('f_syEquip')],
              ['시스템 — 환경', val('f_syEnv')], ['시스템 — 의사소통', val('f_syComm')],
              ['시스템 — 기타', val('f_syEtc')]];
    var body = apprHtml() +
      '<div class="h1">환자 안전사고 근본원인 분석 보고서</div><div style="clear:both;"></div>' +
      '<table><tbody>' +
        '<tr><th style="width:80px;">호실</th><td>' + esc(val('f_roomNm')) + '</td>' +
          '<th style="width:60px;">이름</th><td>' + esc(val('f_patNm')) + '</td>' +
          '<th style="width:70px;">등록번호</th><td>' + esc(val('f_patNo')) + '</td>' +
          '<th style="width:70px;">성별/나이</th><td>' + esc(val('f_sexAge')) + '</td></tr>' +
      '</tbody></table>' +
      '<table><tbody>' +
        r1('1단계<br>문제 확인', [['발생일시', val('f_occurDt') + ' ' + val('f_occurTm')],
                                 ['발생장소', val('f_occurPl')],
                                 ['문제요약', val('f_problem')]], 3) +
        r1('2단계<br>현황 파악', [['과정(Process)분석 및 문제 확인', val('f_processTxt')]], 1) +
        r1('3단계<br>관련요인 분석', s3, s3.length) +
        r1('4단계<br>개선활동', [['인적자원', val('f_actHr')], ['시스템(System)', val('f_actSy')],
                                ['기타', val('f_actEtc')]], 3) +
        '<tr><th style="width:80px;">5단계<br>결과평가</th><td class="pre" colspan="2" style="height:70px;">' +
          esc(val('f_resultTxt')) + '</td></tr>' +
      '</tbody></table>' +
      '<div style="text-align:left;font-size:10px;margin-top:8px;">작성일 : ' + esc(val('f_writeDt')) +
      ' &nbsp;&nbsp; 작성자 : ' + esc(val('f_writerNm')) + '</div>';

    var title = ('RCA근본원인분석_' + val('f_occurDt') + '_' + val('f_patNm') + '_' + HOSP_NM).replace(/[\\\/:*?"<>|]/g, '-');
    var w = window.open('', '_blank', 'width=900,height=1000');
    if (!w) { _alertBox('팝업이 차단되어 인쇄창을 열지 못했습니다.<br>주소창 오른쪽의 팝업 차단을 허용해 주세요.', {icon:'⚠️'}); return; }
    w.document.open();
    w.document.write('<!doctype html><html lang="ko"><head><meta charset="utf-8"><title>' + esc(title) +
      '</title><style>' + PRINT_CSS + '</style></head><body>' + body + '</body></html>');
    w.document.close();
    w.focus();
    setTimeout(function(){ try { w.print(); } catch (e) { } }, 300);
  };

  $(function(){ rcNew(); loadIncid(); });
})();
</script>
</div><%-- /#qpsRca --%>
</div><%-- /.dashboard-wrapper --%>
