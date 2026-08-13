<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%-- qpsMinutes.jsp — QPS 서식 1호: 위원회 회의록 (2026-08-09)
     · 서술형 서식 203종의 첫 파일럿 — 서식빌더로 갈지 개별로 갈지 **결정의 근거**가 되는 실물.
     · v1 은 전자결재 없음: 인쇄물에 결재란(빈칸)만 싣는다(지표정의서와 같은 방식).
     · ★주의: 이 파일 안에서 Deferred EL 표기(샵+중괄호) 금지 --%>

<script src="/asset/js/ui-message.js"></script>
<%-- 공통 첨부 위젯 — window.qpsFileBox 정의(회의록·계획서·라운딩 공용) --%>
<%@ include file="/WEB-INF/jsp/main/inc/qpsFileBox.jsp" %>

<div class="dashboard-wrapper">
<div id="qpsMin" data-wnn="<c:out value='${wnnYn}'/>">
<style>
  #qpsMin{ background:#f4f6f8; color:#1f2a30; min-height:100%; padding:14px 16px 50px; max-width:100%; overflow-x:hidden; }
  #qpsMin *{ box-sizing:border-box; }
  #qpsMin .qm-head{ display:flex; align-items:center; gap:10px; margin-bottom:12px; flex-wrap:wrap; }
  #qpsMin .qm-title{ font-size:18px; font-weight:800; color:#20303a; display:flex; align-items:center; gap:8px; }
  #qpsMin .qm-dot{ width:10px; height:10px; border-radius:50%; background:linear-gradient(135deg,#1f5a4b,#2a7665); }
  #qpsMin .qm-sub{ font-size:12px; color:#6b7c86; }
  #qpsMin .qm-hosp{ background:#e7f3ee; color:#1f5a4b; font-size:12px; font-weight:800;
      border:1px solid #cfe3da; border-radius:14px; padding:3px 11px; }
  #qpsMin .qm-spacer{ flex:1; }
  #qpsMin select, #qpsMin input[type=text], #qpsMin input[type=date], #qpsMin textarea{
      border:1px solid #cfd8e0; border-radius:6px; padding:6px 9px; font-family:inherit; font-size:13px;
      background:#fff; width:100%; }
  #qpsMin textarea{ min-height:74px; resize:vertical; line-height:1.6; }
  #qpsMin .qm-btn{ border:1px solid #1f5a4b; background:#1f5a4b; color:#fff; border-radius:6px;
      padding:6px 14px; font-size:13px; font-weight:600; cursor:pointer; white-space:nowrap; }
  #qpsMin .qm-btn.ghost{ background:#fff; color:#1f5a4b; }
  #qpsMin .qm-btn.warn{ background:#fff; color:#b23b3b; border-color:#e0b4b4; }
  #qpsMin .qm-btn:hover{ opacity:.9; }

  #qpsMin .qm-wrap{ display:flex; gap:14px; align-items:flex-start; }
  #qpsMin .qm-left{ width:340px; flex:none; }
  #qpsMin .qm-right{ flex:1; min-width:0; }
  #qpsMin .qm-card{ background:#fff; border:1px solid #e3e9ed; border-radius:10px; padding:14px 16px; }
  #qpsMin .qm-card h4{ margin:0 0 10px; font-size:14px; font-weight:800; color:#20303a; }
  #qpsMin .qm-card h4 .hint{ font-weight:500; font-size:12px; color:#8a99a3; }

  #qpsMin .qm-list{ max-height:560px; overflow:auto; }
  #qpsMin .qm-item{ padding:9px 11px; border:1px solid #eef2f5; border-radius:8px; margin-bottom:7px; cursor:pointer; }
  #qpsMin .qm-item:hover{ border-color:#8fc3b2; background:#f7fbf9; }
  #qpsMin .qm-item.on{ border-color:#1f5a4b; background:#f0f7f4; }
  #qpsMin .qm-item .t{ font-size:13px; font-weight:700; color:#20303a; }
  #qpsMin .qm-item .d{ font-size:11.5px; color:#8a99a3; margin-top:2px; }
  #qpsMin .qm-empty{ color:#8a99a3; font-size:12.5px; padding:16px 6px; text-align:center; }

  #qpsMin .qm-form{ display:grid; grid-template-columns:110px 1fr 110px 1fr; gap:9px 10px; align-items:start; }
  #qpsMin .qm-form .lb{ font-size:12.5px; font-weight:700; color:#43555f; padding-top:8px; }
  #qpsMin .qm-form .full{ grid-column:2 / -1; }
</style>

<div class="qm-head">
  <div class="qm-title"><span class="qm-dot"></span><span id="qmTitle">위원회 회의록</span> <span class="qm-sub">서식 1호</span></div>
  <div class="qm-sub">회의록을 등록하고 A4 로 인쇄합니다 (결재란 포함)</div>
  <span class="qm-hosp">🏥 <c:out value="${hospNm}" default="병원 미확인"/></span>
  <div class="qm-spacer"></div>
  <%-- 위원회 구분(2026-08-10 감염관리 포함) — MEET_GB(정기/임시)와는 다른 축이다.
       목록·저장 모두 이 구분을 타므로 QPS 회의와 감염 회의가 섞이지 않는다. --%>
  <%-- 초기값은 서버가 정한다 — 감염 메뉴(?gb=I)로 들어오면 감염관리위원회로 열린다 --%>
  <select id="qmGb" style="width:auto;" onchange="qmList();" data-init="<c:out value='${formGb}' default='Q'/>">
    <option value="Q">질향상·환자안전</option>
    <option value="I">감염관리</option>
    <%-- QI 활동 회의록 — 원본은 별도 서식처럼 보이지만 틀이 같다(1~6차 실물 대조).
         주제·차수는 회의명에 적는다(예: "낙상 3차"). --%>
    <option value="J">QI 활동</option>
    <%-- RCA 회의록 — 1차·2차 실물 대조 결과 QI 회의록과 골격이 같다(차수별 차이 없음) --%>
    <option value="R">RCA</option>
    <%-- FMEA 회의록 — 골격이 같다. 차수는 회의명에 적는다(예: "낙상 FMEA 3차") --%>
    <option value="F">FMEA</option>
    <%-- ★위원회 3형제(2026-08-12) — 약사 · 영양관리 · 소방안전관리.
         원본 회의록이 우리 화면과 **판박이**라 ***코드값 하나면 끝난다***
         (약국 판정 §3-2 · 영양 판정 §1-4). 조직도·내규는 자료실이다.
         ⚠소방안전관리만 원본에 **하단 조치표**가 하나 더 있다 → 아래 #qmActWrap --%>
    <option value="P">약사</option>
    <option value="N">영양관리</option>
    <option value="S">소방안전관리</option>
  </select>
  <select id="qmYear" style="width:auto;" onchange="qmList();"></select>
  <%-- 저장·인쇄·삭제는 <상단>에 둔다 — QPS 화면 공통(2026-08-10 확정).
       종전에는 폼 맨 아래라 회의록이 길면 끝까지 내려가야 했다. --%>
  <button type="button" class="qm-btn" onclick="qmSave();">저장</button>
  <button type="button" class="qm-btn ghost" onclick="qmPrint();">🖨 인쇄(A4)</button>
  <button type="button" class="qm-btn warn" id="qmDelBtn" onclick="qmDel();" style="display:none;">삭제</button>
</div>

<div class="qm-wrap">
  <div class="qm-left">
    <div class="qm-card">
      <h4>회의록 목록 <span class="hint" id="qmCnt"></span></h4>
      <div class="qm-list" id="qmList"><div class="qm-empty">불러오는 중…</div></div>
      <button type="button" class="qm-btn ghost" style="width:100%; margin-top:6px;" onclick="qmNew();">＋ 새 회의록</button>
    </div>
  </div>

  <div class="qm-right">
    <div class="qm-card">
      <h4>회의록 작성 <span class="hint" id="qmStat"></span></h4>
      <input type="hidden" id="m_minSeq" value="">
      <div class="qm-form">
        <div class="lb">회의일 *</div>   <div><input type="date" id="m_meetDt"></div>
        <div class="lb">회의 구분</div>  <div style="padding-top:7px;">
          <label style="font-size:13px; margin-right:14px;"><input type="radio" name="m_meetGb" value="R"> 정기 회의</label>
          <label style="font-size:13px;"><input type="radio" name="m_meetGb" value="T"> 임시 회의</label></div>
        <div class="lb">회의명 *</div>   <div class="full"><input type="text" id="m_title" maxlength="200" placeholder="예) 2026년 2차 QPS위원회"></div>
        <div class="lb">장소</div>       <div><input type="text" id="m_place" maxlength="100" placeholder="예) 2층 회의실"></div>
        <div class="lb">인원</div>       <div><input type="text" id="m_personnel" maxlength="30" placeholder="예) 11명"></div>
        <%-- 간사 — QI 회의록에 있는 칸. 다른 구분에서는 비워 두면 인쇄물에도 안 나온다 --%>
        <div class="lb">간사</div>       <div><input type="text" id="m_clerkNm" maxlength="50"></div>
        <div class="lb">회의안건</div>   <div class="full"><textarea id="m_agenda" placeholder="1. 2분기 지표 결과 보고&#10;2. 손위생 개선활동 경과"></textarea></div>
        <div class="lb">회의내용</div>   <div class="full">
          <textarea id="m_content" style="min-height:110px;"></textarea>
          <div style="margin-top:4px;">
            <button type="button" class="qm-btn mini" style="padding:3px 10px; font-size:11.5px; background:#fff; color:#1f5a4b;"
                    onclick="qmInsertIndi();">📊 지표 요약 넣기</button>
            <span style="font-size:11.5px; color:#8a99a3;">— 회의일이 속한 분기의 지표 18종 산출값을 본문에 붙입니다
              (이전 시스템의 [지표조회]와 같되, 손입력이 아니라 자동 산출값)</span>
          </div>
        </div>
        <div class="lb">회의결과<br>(결정사항)</div> <div class="full"><textarea id="m_decision"></textarea></div>
        <%-- ★소방안전관리위원회 원본에만 있는 하단 조치표 한 줄(2026-08-12) —
             원본이 「회의구분 | 조치책임부서 | 조치기한 | 사 업 비」 네 칸이다.
             ⚠**위쪽 「회의 구분」(정기/임시)과 다른 칸**이다. 원본이 이름을 겹쳐 쓴 것뿐 —
               합치면 서로를 덮어쓴다. 그래서 라벨에 (조치표)를 붙여 화면에서 갈라 둔다.
             ★다른 위원회 원본에는 이 표가 없으므로 **S 에서만 보인다** —
               ***원본에 없던 칸을 만들지 않는다***(시드에서 지켜 온 규칙 그대로). --%>
        <div class="lb" id="qmActLb" style="display:none;">조치사항</div>
        <div class="full" id="qmActWrap" style="display:none;">
          <div style="display:flex; gap:6px; flex-wrap:wrap;">
            <input type="text" id="m_actGb"   maxlength="100" style="flex:2 1 160px;" placeholder="회의구분">
            <input type="text" id="m_actDept" maxlength="100" style="flex:2 1 140px;" placeholder="조치책임부서">
            <input type="text" id="m_actDue"  maxlength="50"  style="flex:1 1 110px;" placeholder="조치기한">
            <input type="text" id="m_actCost" maxlength="50"  style="flex:1 1 110px;" placeholder="사 업 비">
          </div>
          <div style="font-size:11.5px; color:#8a99a3; margin-top:2px;">
            소방안전관리위원회 원본의 표입니다 — 위쪽 <b>회의 구분(정기/임시)</b>과는 다른 칸입니다.</div>
        </div>
        <div class="lb">첨부자료</div>   <div class="full"><input type="text" id="m_attachTxt" maxlength="500" placeholder="예) 2분기 지표분석보고서 5부"></div>
        <div class="lb">차기 일정</div>  <div class="full"><input type="text" id="m_nextTxt" maxlength="500" placeholder="예) 차기 회의 9월 둘째 주 · 낙상 개선안 보고"></div>
        <div class="lb">참석자 명단</div><div class="full">
          <textarea id="m_members" style="min-height:96px;" placeholder="한 줄에 하나 — 직책: 이름&#10;위원장(병원장): 홍길동&#10;간사(QPS담당자): 김담당&#10;위원(진료과장): 이과장"></textarea>
          <div style="font-size:11.5px; color:#8a99a3; margin-top:2px;">인쇄물의 「참석자 명단」 표가 이 줄들로 만들어집니다(직책 구성은 병원마다 달라 자유 기재).</div></div>
        <div class="lb">참석 요약</div>  <div class="full"><input type="text" id="m_attendees" maxlength="1000" placeholder="(선택) 목록 화면용 한 줄 요약"></div>
        <div class="lb">특이사항</div>   <div class="full"><input type="text" id="m_specialTxt" maxlength="500"></div>
        <div class="lb">첨부파일</div>   <div class="full"><div id="qmFileBox"></div></div>
      </div>
    </div>
  </div>
</div>

<script>
(function(){
  var HOSP_NM = '', apprLine = [], curSeq = 0;
  /** 위원회 구분 — Q=질향상·환자안전, I=감염관리 (2026-08-10) */
  function qmGb(){ var e=document.getElementById('qmGb'); return e ? e.value : 'Q'; }
  // 공통 첨부 위젯 — 회의록(MINUTES) 문서키 = 회의록 SEQ. 문서 저장 전엔 업로드 잠김.
  var fileBox = window.qpsFileBox({ mount:'qmFileBox', refGb:'MINUTES',
      hint:'이 회의록에 붙는 사진·파일', needSaveMsg:'회의록을 먼저 저장하면 첨부할 수 있습니다.' });

  // ★hospCd 를 보내지 않는다(서버가 쿠키를 본다) · dataType:'json' 필수 — QPS 화면 공통 원칙
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

  (function(){
    var y = new Date().getFullYear(), sel = document.getElementById('qmYear');
    for (var i = y + 1; i >= y - 4; i--) sel.add(new Option(i + '년', i));
    sel.value = y;
  })();

  window.qmList = function(){
    var t = document.getElementById('qmTitle');
    if (t) t.textContent = (qmGb()==='I') ? '감염관리위원회 회의록'
                         : (qmGb()==='J') ? '질향상활동(QI) 회의록'
                         : (qmGb()==='R') ? 'RCA 회의록'
                         : (qmGb()==='F') ? 'FMEA 회의록'
                         : (qmGb()==='P') ? '약사위원회 회의록'
                         : (qmGb()==='N') ? '영양관리위원회 회의록'
                         : (qmGb()==='S') ? '소방안전관리위원회 회의록' : '위원회 회의록';
    qmActToggle();   // 위원회를 바꾸면 하단 조치표가 붙거나 사라진다
    return post('/qps/minutesList.do', { formGb: qmGb(), inYear: document.getElementById('qmYear').value }).then(function(res){
      apprLine = res.line || [];
      if (res.hosp) HOSP_NM = res.hosp.hospnm || '';
      var hb = document.querySelector('#qpsMin .qm-hosp');
      if (hb && HOSP_NM) hb.textContent = '🏥 ' + HOSP_NM;
      var list = res.list || [];
      document.getElementById('qmCnt').textContent = list.length ? ('— ' + list.length + '건') : '';
      document.getElementById('qmList').innerHTML = list.length
        ? list.map(function(r){
            return '<div class="qm-item' + (Number(r.minseq) === curSeq ? ' on' : '') + '" onclick="qmOpen(' + r.minseq + ');">' +
                   '<div class="t">' + esc(r.title) + '</div>' +
                   '<div class="d">' + esc(r.meetdt) + (r.place ? (' · ' + esc(r.place)) : '') + '</div></div>';
          }).join('')
        : '<div class="qm-empty">이 해의 회의록이 없습니다.<br>[＋ 새 회의록]으로 시작하세요.</div>';
    }).catch(err);
  };

  /* ★하단 조치표는 **소방안전관리위원회(S)에만** 있다(2026-08-12).
     다른 위원회 원본에는 없는 표라 ***원본에 없던 칸을 만들지 않는다.***
     ⚠뒤에 같은 표를 가진 위원회가 나오면 이 목록에 값을 더한다 — 판단이 한 곳에만 있게. */
  var ACT_GBS = ['S'];
  function qmHasAct(){ return ACT_GBS.indexOf(qmGb()) >= 0; }
  function qmActToggle(){
    var on = qmHasAct();
    var lb = document.getElementById('qmActLb'), wp = document.getElementById('qmActWrap');
    if (lb) lb.style.display = on ? '' : 'none';
    if (wp) wp.style.display = on ? '' : 'none';
  }

  function setGb(v){
    document.querySelectorAll('input[name="m_meetGb"]').forEach(function(r){ r.checked = (r.value === v); });
  }
  function getGb(){
    var r = document.querySelector('input[name="m_meetGb"]:checked');
    return r ? r.value : '';
  }

  window.qmOpen = function(seq){
    post('/qps/minutesGet.do', { minSeq: seq }).then(function(res){
      var d = res.doc || {};
      curSeq = Number(d.minseq || 0);
      // ★★문서의 위원회로 셀렉트를 맞춘다(2026-08-12) — 셀렉트는 **목록 필터도 겸한다.**
      //   맞추지 않으면 「S 문서를 열어 둔 채 셀렉트를 바꾸고 저장」할 때
      //   ***그 위원회에만 있는 칸(조치표)이 조용히 지워진다.*** 검증 중에 실제로 잡았다.
      //   (저장은 `FORM_GB` 를 안 고치므로 문서는 늘 만든 위원회에 남는다 — 화면만 어긋났던 것)
      if (d.formgb) {
        var gsel = document.getElementById('qmGb');
        if (gsel && gsel.value !== d.formgb) { gsel.value = d.formgb; }
      }
      qmActToggle();
      set('m_minSeq', d.minseq); set('m_meetDt', d.meetdt); set('m_title', d.title);
      setGb(d.meetgb || '');
      set('m_place', d.place); set('m_personnel', d.personnel); set('m_clerkNm', d.clerknm);
      set('m_attendees', d.attendees); set('m_members', d.members);
      set('m_agenda', d.agenda); set('m_content', d.content);
      set('m_decision', d.decision); set('m_nextTxt', d.nexttxt);
      set('m_attachTxt', d.attachtxt); set('m_specialTxt', d.specialtxt);
      set('m_actGb', d.actgb); set('m_actDept', d.actdept);
      set('m_actDue', d.actdue); set('m_actCost', d.actcost);
      document.getElementById('qmStat').textContent = '— 저장된 문서 #' + d.minseq;
      document.getElementById('qmDelBtn').style.display = '';
      if (fileBox) fileBox.setKey(d.minseq);
      qmList();
    }).catch(err);
  };

  window.qmNew = function(){
    curSeq = 0;
    ['m_minSeq','m_meetDt','m_title','m_place','m_clerkNm','m_personnel','m_attendees','m_members',
     'm_agenda','m_content','m_decision','m_nextTxt','m_attachTxt','m_specialTxt',
     'm_actGb','m_actDept','m_actDue','m_actCost']
      .forEach(function(id){ set(id, ''); });
    setGb('');
    document.getElementById('qmStat').textContent = '— 새 문서';
    document.getElementById('qmDelBtn').style.display = 'none';
    if (fileBox) fileBox.setKey('');   // 새 문서 = 아직 첨부 불가(저장 후 열림)
    qmList();
  };

  window.qmSave = function(){
    if (!val('m_meetDt')) { _alertBox('회의일을 입력해 주세요.', {icon:'⚠️'}); return; }
    if (!val('m_title'))  { _alertBox('회의명을 입력해 주세요.', {icon:'⚠️'}); return; }
    post('/qps/minutesSave.do', {
      formGb: qmGb(),
      minSeq: val('m_minSeq'), meetDt: val('m_meetDt'), title: val('m_title'), meetGb: getGb(),
      place: val('m_place'), clerkNm: val('m_clerkNm'), personnel: val('m_personnel'),
      attendees: val('m_attendees'), members: val('m_members'),
      agenda: val('m_agenda'), content: val('m_content'),
      decision: val('m_decision'), nextTxt: val('m_nextTxt'),
      attachTxt: val('m_attachTxt'), specialTxt: val('m_specialTxt'),
      // ★하단 조치표 — 표가 안 보이는 위원회에서는 **빈 값으로 보낸다**.
      //   화면에 없는 칸의 옛 값이 남아 있으면 위원회를 바꿔 저장할 때 조용히 따라간다.
      actGb:   qmHasAct() ? val('m_actGb')   : '',
      actDept: qmHasAct() ? val('m_actDept') : '',
      actDue:  qmHasAct() ? val('m_actDue')  : '',
      actCost: qmHasAct() ? val('m_actCost') : ''
    }).then(function(res){
      _toast('저장되었습니다.', 'ok');
      curSeq = Number(res.minSeq || 0);
      set('m_minSeq', curSeq || '');
      if (curSeq) { document.getElementById('qmStat').textContent = '— 저장된 문서 #' + curSeq;
                    document.getElementById('qmDelBtn').style.display = '';
                    if (fileBox) fileBox.setKey(curSeq); }   // 저장 직후부터 첨부 가능
      return qmList();
    }).catch(err);
  };

  window.qmDel = function(){
    if (!val('m_minSeq')) return;
    _confirmBox({ msg:'이 회의록을 삭제할까요?', icon:'⚠️', okText:'삭제', okColor:'#b23b3b',
      onOk: function(){
        post('/qps/minutesDel.do', { minSeq: val('m_minSeq') }).then(function(){
          _toast('삭제되었습니다.', 'ok');
          qmNew();
        }).catch(err);
      }});
  };

  // ---------- 지표 요약 넣기 ----------
  // 회의일이 속한 분기의 18종 산출값을 본문에 텍스트 표로 붙인다.
  // ★서버가 지표 18종을 전부 계산하는 무거운 호출 — 버튼 클릭 때만 부른다.
  window.qmInsertIndi = function(){
    var dt = val('m_meetDt');
    if (!dt) { _alertBox('회의일을 먼저 입력해 주세요 — 그 날짜가 속한 분기의 지표를 가져옵니다.', {icon:'⚠️'}); return; }
    var yy = dt.substring(0, 4), q = Math.floor((Number(dt.substring(5, 7)) - 1) / 3) + 1;
    var prdKey = yy + 'Q' + q;
    _toast('지표를 계산하는 중…', 'info');
    post('/qps/indiSummary.do', { prdKey: prdKey }).then(function(res){
      var list = res.list || [];
      if (!list.length) { _alertBox('지표 자료가 없습니다.', {icon:'⚠️'}); return; }
      var lines = ['── ' + yy + '년 ' + q + '/4분기 지표 요약 (자동 산출) ──'];
      list.forEach(function(r){
        var v = (r.rate == null) ? '-' :
          (Number(r.rate).toFixed(Number(r.decimals == null ? 2 : r.decimals)) + (r.unit || ''));
        var nd = (r.rate == null) ? '' : ' (' + (r.numer == null ? '-' : r.numer) + '/' + (r.denom == null ? '-' : r.denom) + ')';
        lines.push('· ' + r.indinm + ' : ' + v + nd);
      });
      var ta = document.getElementById('m_content');
      ta.value = (ta.value ? (ta.value.replace(/\s+$/, '') + '\n\n') : '') + lines.join('\n') + '\n';
      _toast('지표 ' + list.length + '종을 붙였습니다. 필요 없는 줄은 지우면 됩니다.', 'ok');
    }).catch(err);
  };

  // ---------- 인쇄(A4 1장) — 별도 창 방식(주소 바닥글·앱 CSS 가 안 붙는다) ----------
  var PRINT_CSS =
    '@page{ size:A4 portrait; margin:14mm 14mm 16mm; }' +
    'body{ margin:0; font-family:"맑은 고딕",Malgun Gothic,sans-serif; color:#000; }' +
    '.h1{ font-size:19px; font-weight:800; text-align:center; margin:0 0 3px; }' +
    '.h2{ font-size:12.5px; text-align:center; color:#333; margin:0 0 12px; }' +
    'table{ width:100%; border-collapse:collapse; font-size:11.5px; }' +
    'th,td{ border:1px solid #666; padding:6px 8px; text-align:left; vertical-align:top; line-height:1.7; }' +
    'th{ background:#f0f0f0; font-weight:700; width:88px; white-space:nowrap; }' +
    'td.pre{ white-space:pre-wrap; }' +
    '.appr{ float:right; width:auto; margin:0 0 6px 8px; font-size:10px; }' +
    '.appr th{ width:auto; text-align:center; background:#f2f2f2; padding:2px 6px; }' +
    '.appr td{ height:46px; width:62px; }' +
    '.foot{ margin-top:14px; font-size:11px; text-align:center; }' +
    'tr{ page-break-inside:avoid; }';

  window.qmPrint = function(){
    if (!val('m_title')) { _alertBox('회의록을 먼저 불러오거나 작성해 주세요.', {icon:'⚠️'}); return; }
    // 원본 서식: 제목 옆 상단에 결재란 4단(담당~이사장 = 결재선 그대로)
    var appr = apprLine.length
      ? ('<table class="appr"><thead><tr>' + apprLine.map(function(r){ return '<th>' + esc(r.stepnm) + '</th>'; }).join('') +
         '</tr></thead><tbody><tr>' + apprLine.map(function(){ return '<td></td>'; }).join('') + '</tr></tbody></table>')
      : '';
    var gb = getGb();
    var gbHtml = (gb === 'R' ? '☑' : '☐') + ' 정기 회의&nbsp;&nbsp;&nbsp;' + (gb === 'T' ? '☑' : '☐') + ' 임시 회의';

    // 참석자 명단 — "직책: 이름" 줄들을 2열 표로(원본 3쪽). 콜론이 없으면 이름만 칸에.
    var lines = val('m_members').split('\n').map(function(s){ return s.trim(); }).filter(function(s){ return s; });
    var memHtml = '';
    if (lines.length) {
      var cells = lines.map(function(ln){
        var i = ln.indexOf(':');
        var role = i > -1 ? ln.substring(0, i).trim() : '';
        var nm   = i > -1 ? ln.substring(i + 1).trim() : ln;
        return '<th style="width:110px;">' + esc(role) + '</th><td style="width:150px;">' + esc(nm) + '</td>';
      });
      var trs = '';
      for (var i = 0; i < cells.length; i += 2) {
        trs += '<tr>' + cells[i] + (cells[i + 1] || '<th style="width:110px;"></th><td></td>') + '</tr>';
      }
      trs += '<tr><th>특이사항</th><td colspan="3">' + esc(val('m_specialTxt')) + '</td></tr>';
      memHtml = '<div class="sec" style="margin-top:14px; font-size:13px; font-weight:800;">참석자 명단</div>' +
                '<table><tbody>' + trs + '</tbody></table>';
    }

    function row(l, v, pre){ return '<tr><th>' + esc(l) + '</th><td colspan="3"' + (pre ? ' class="pre"' : '') + '>' + esc(v || '') + '</td></tr>'; }
    var body =
      appr +
      // ★제목은 **고른 위원회**를 따른다(2026-08-12). 종전에는 「QPS위원회 회의록」이 박혀 있어
      //   감염·QI·RCA·FMEA 를 인쇄해도 전부 QPS위원회로 찍혔다. 위원회 3형제를 더하며 같이 고쳤다.
      '<div class="h1">' + esc((document.getElementById('qmTitle') || {}).textContent || '위원회 회의록') + '</div>' +
      '<div class="h2">' + esc(HOSP_NM) + (val('m_title') ? (' · ' + esc(val('m_title'))) : '') + '</div>' +
      '<div style="clear:both;"></div>' +
      '<table><tbody>' +
        '<tr><th>일 시</th><td style="width:34%;">' + esc(val('m_meetDt')) + '</td>' +
            '<th style="width:70px;">회의 구분</th><td>' + gbHtml + '</td></tr>' +
        '<tr><th>장 소</th><td>' + esc(val('m_place')) + '</td>' +
            // QI 회의록은 이 자리가 「간사」다. 간사를 적으면 그것을, 아니면 인원을 낸다.
            '<th>' + (val('m_clerkNm') ? '간 사' : '인 원') + '</th><td>' +
            esc(val('m_clerkNm') || val('m_personnel')) + '</td></tr>' +
        row('회의안건', val('m_agenda'), true) +
        row('회의내용', val('m_content'), true) +
        row('회의결과(결정사항)', val('m_decision'), true) +
        row('첨부자료', val('m_attachTxt')) +
        (val('m_nextTxt') ? row('차기 일정', val('m_nextTxt')) : '') +
      '</tbody></table>' +
      // ★소방안전관리위원회의 하단 조치표 — 원본이 **네 칸 한 줄**이라 그대로 옮긴다.
      //   표가 없는 위원회에서는 아예 안 찍는다.
      (qmHasAct()
        ? ('<table style="margin-top:8px;"><thead><tr>' +
             '<th style="width:auto;text-align:center;">회의구분</th>' +
             '<th style="width:auto;text-align:center;">조치책임부서</th>' +
             '<th style="width:auto;text-align:center;">조치기한</th>' +
             '<th style="width:auto;text-align:center;">사 업 비</th></tr></thead><tbody><tr>' +
             '<td>' + esc(val('m_actGb'))   + '</td><td>' + esc(val('m_actDept')) + '</td>' +
             '<td>' + esc(val('m_actDue'))  + '</td><td>' + esc(val('m_actCost')) + '</td>' +
           '</tr></tbody></table>')
        : '') +
      memHtml +
      '<div class="foot">작성일 : ' + (function(){ var t = new Date();
          return t.getFullYear() + '. ' + (t.getMonth() + 1) + '. ' + t.getDate() + '.'; })() + '</div>';

    var title = ('회의록_' + val('m_title') + '_' + HOSP_NM).replace(/[\\\/:*?"<>|]/g, '-');
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
    var g = document.getElementById('qmGb');
    if (g) { var init = g.getAttribute('data-init'); if (init) g.value = init; }
    qmList();
  });
})();
</script>
</div><%-- /#qpsMin --%>
</div><%-- /.dashboard-wrapper --%>
