<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%-- qpsInfStaff.jsp — 감염관리 전담자 (2026-08-10)
     원본은 문서 3개(임명장 / 자격 및 경력 / 직무기술서)지만 <같은 사람의 서류 한 벌>이다.
     한 사람을 등록하면 세 서류가 같이 채워지므로 탭으로 나눠 담고, 인쇄만 3장으로 나눈다.
     ★원본 「자격 및 경력」의 PDF 탭(수료증 보관)은 공통 첨부로 대체한다 — 별도 기능이 아니다.
     ★주의: 이 파일 안에서 Deferred EL 표기(샵+중괄호) 금지 --%>

<script src="/asset/js/ui-message.js"></script>
<%@ include file="/WEB-INF/jsp/main/inc/qpsFileBox.jsp" %>

<div class="dashboard-wrapper">
<div id="qpsInfStaff" data-wnn="<c:out value='${wnnYn}'/>">
<style>
  #qpsInfStaff{ background:#f4f6f8; color:#1f2a30; min-height:100%; padding:14px 16px 60px; max-width:100%; overflow-x:hidden; }
  #qpsInfStaff *{ box-sizing:border-box; }
  #qpsInfStaff .st-head{ display:flex; align-items:center; gap:10px; margin-bottom:12px; flex-wrap:wrap; }
  #qpsInfStaff .st-title{ font-size:18px; font-weight:800; color:#20303a; display:flex; align-items:center; gap:8px; }
  #qpsInfStaff .st-dot{ width:10px; height:10px; border-radius:50%; background:linear-gradient(135deg,#1f5a4b,#2a7665); }
  #qpsInfStaff .st-sub{ font-size:12px; color:#6b7c86; }
  #qpsInfStaff .st-hosp{ background:#e7f3ee; color:#1f5a4b; font-size:12px; font-weight:800;
      border:1px solid #cfe3da; border-radius:14px; padding:3px 11px; }
  #qpsInfStaff .st-spacer{ flex:1; }
  #qpsInfStaff select, #qpsInfStaff input, #qpsInfStaff textarea{
      border:1px solid #cfd8e0; border-radius:6px; padding:6px 9px; font-family:inherit; font-size:13px; background:#fff; width:100%; }
  #qpsInfStaff textarea{ min-height:90px; resize:vertical; line-height:1.6; }
  #qpsInfStaff .st-btn{ border:1px solid #1f5a4b; background:#1f5a4b; color:#fff; border-radius:6px;
      padding:6px 14px; font-size:13px; font-weight:600; cursor:pointer; white-space:nowrap; width:auto; }
  #qpsInfStaff .st-btn.ghost{ background:#fff; color:#1f5a4b; }
  #qpsInfStaff .st-btn.warn{ background:#fff; color:#b23b3b; border-color:#e0b4b4; }
  #qpsInfStaff .st-btn.mini{ padding:2px 9px; font-size:11.5px; border-color:#cfd8e0; color:#556570; background:#fff; }
  #qpsInfStaff .st-wrap{ display:flex; gap:14px; align-items:flex-start; }
  #qpsInfStaff .st-left{ width:280px; flex:none; }
  #qpsInfStaff .st-right{ flex:1; min-width:0; }
  #qpsInfStaff .st-card{ background:#fff; border:1px solid #e3e9ed; border-radius:10px; padding:14px 16px; margin-bottom:12px; }
  #qpsInfStaff .st-card h4{ margin:0 0 10px; font-size:14px; font-weight:800; color:#1f5a4b; }
  #qpsInfStaff .st-card h4 .hint{ font-weight:500; font-size:12px; color:#8a99a3; }
  #qpsInfStaff .st-item{ padding:9px 11px; border:1px solid #eef2f5; border-radius:8px; margin-bottom:7px; cursor:pointer; }
  #qpsInfStaff .st-item:hover{ border-color:#8fc3b2; background:#f7fbf9; }
  #qpsInfStaff .st-item.on{ border-color:#1f5a4b; background:#f0f7f4; }
  #qpsInfStaff .st-item .t{ font-size:13px; font-weight:700; }
  #qpsInfStaff .st-item .d{ font-size:11.5px; color:#8a99a3; margin-top:2px; }
  #qpsInfStaff .st-empty{ color:#8a99a3; font-size:12.5px; padding:16px 6px; text-align:center; }
  #qpsInfStaff .st-tabs{ display:flex; gap:6px; margin-bottom:10px; }
  #qpsInfStaff .st-tab{ padding:6px 16px; border:1px solid #cfd8e0; border-radius:7px; background:#fff;
      font-size:13px; font-weight:700; color:#5a6a73; cursor:pointer; }
  #qpsInfStaff .st-tab.on{ background:#1f5a4b; border-color:#1f5a4b; color:#fff; }
  #qpsInfStaff .fm{ display:grid; grid-template-columns:110px 1fr 110px 1fr; gap:9px 10px; align-items:start; }
  #qpsInfStaff .fm .lb{ font-size:12.5px; font-weight:700; color:#43555f; padding-top:8px; }
  #qpsInfStaff .fm .full{ grid-column:2 / -1; }
  #qpsInfStaff table.ed{ width:100%; border-collapse:collapse; font-size:12.5px; }
  #qpsInfStaff table.ed th{ background:#f2f6f8; border:1px solid #dde5ea; padding:5px 6px; font-weight:700; color:#43555f; }
  #qpsInfStaff table.ed td{ border:1px solid #e6ecef; padding:3px; }
  #qpsInfStaff table.ed input, #qpsInfStaff table.ed textarea{ border:none; background:transparent; padding:4px 5px; min-height:auto; }
  #qpsInfStaff .rowdel{ color:#b23b3b; cursor:pointer; font-weight:700; text-align:center; width:26px; }
  /* -- 글자 크기 (2026-08-18 요청) : QI 계획서(qpsQiPlan)와 같은 모양.같은 조작 */
  #qpsInfStaff .zz-zoom{ display:inline-flex; gap:4px; align-items:center; margin-left:2px; margin-right:14px; }
  #qpsInfStaff .zz-zoom button{ border:1px solid #cfd9e0; background:#fff; color:#43555f; border-radius:6px;
                        padding:4px 9px; font-size:13px; font-weight:700; cursor:pointer; }
  #qpsInfStaff .zz-zoom button:hover{ background:#eef3f6; }
</style>

<div class="st-head">
  <div class="st-title"><span class="st-dot"></span>감염관리 전담자</div>
  <span class="st-hosp">🏥 <c:out value="${hospNm}" default="병원 미확인"/></span>
  <div class="st-spacer"></div>
  <button type="button" class="st-btn" onclick="stSave();">저장</button>
  <button type="button" class="st-btn ghost" onclick="stNew();">＋ 새 전담자</button>
  <button type="button" class="st-btn warn" id="stDelBtn" onclick="stDel();" style="display:none;">삭제</button>
  <span class="st-sub" id="stStat"></span>
  <span style="flex:0 0 12px;"></span>
  <span style="flex:0 0 12px;"></span>
  <%-- 글자 크기 - 이 PC 이 브라우저에만 저장된다 --%>
  <span class="zz-zoom">
    <button type="button" onclick="zzZoom(-1);" title="글자 작게">가－</button>
    <button type="button" onclick="zzZoom(1);"  title="글자 크게">가＋</button>
    <button type="button" onclick="zzZoom(0);"  title="처음 크기로">↺</button>
  </span>
</div>

<div class="st-wrap">
  <div class="st-left">
    <div class="st-card">
      <h4>전담자 목록</h4>
      <div id="stList"><div class="st-empty">불러오는 중…</div></div>
    </div>
  </div>

  <div class="st-right">
    <div class="st-tabs">
      <div class="st-tab on" id="tab1" onclick="stTab(1);">임명장</div>
      <div class="st-tab" id="tab2" onclick="stTab(2);">자격 및 경력</div>
      <div class="st-tab" id="tab3" onclick="stTab(3);">직무기술서</div>
    </div>

    <input type="hidden" id="f_stfSeq" value="">

    <div class="st-card" id="card1">
      <h4>임명장 <span class="hint">— 인쇄물에 소속·직위·성명과 날짜가 들어갑니다</span></h4>
      <div class="fm">
        <div class="lb">성명 *</div> <div><input type="text" id="f_stfNm" maxlength="50"></div>
        <div class="lb">소속</div>   <div><input type="text" id="f_deptNm" maxlength="60"></div>
        <div class="lb">직위</div>   <div><input type="text" id="f_position" maxlength="60"></div>
        <div class="lb">임명일</div> <div><input type="date" id="f_apptDt"></div>
      </div>
    </div>

    <div class="st-card" id="card2" style="display:none;">
      <h4>자격 및 경력</h4>
      <div class="fm">
        <div class="lb">직종</div>      <div class="full"><input type="text" id="f_jobKind" maxlength="60"></div>
        <div class="lb">경력 사항</div> <div class="full"><textarea id="f_careerTxt"></textarea></div>
      </div>
      <div style="margin-top:12px;">
        <div style="font-size:13px; font-weight:800; color:#20303a; margin-bottom:6px;">교육이수 사항</div>
        <table class="ed"><thead><tr>
          <th style="width:200px;">교육 주관</th><th>과정명</th>
          <th style="width:130px;">교육일</th><th style="width:120px;">교육기간</th><th style="width:26px;"></th>
        </tr></thead><tbody id="eduBody"></tbody></table>
        <button type="button" class="st-btn mini" style="margin-top:6px;" onclick="stEduAdd();">＋ 행 추가</button>
        <span class="st-sub" style="margin-left:8px;">수료증 파일은 아래 첨부에 올리시면 됩니다.</span>
      </div>
    </div>

    <div class="st-card" id="card3" style="display:none;">
      <h4>직무기술서</h4>
      <div class="fm">
        <div class="lb">입사일</div>        <div><input type="date" id="f_joinDt"></div>
        <div class="lb">직급</div>          <div><input type="text" id="f_rankNm" maxlength="60"></div>
        <div class="lb">현 부서 배치일</div><div><input type="date" id="f_deptDt"></div>
        <div class="lb">현 직무 시작일</div><div><input type="date" id="f_dutyDt"></div>
        <div class="lb">작성일자</div>      <div><input type="date" id="f_writeDt"></div>
        <div></div><div></div>
      </div>
      <div style="margin-top:12px;">
        <div style="font-size:13px; font-weight:800; color:#20303a; margin-bottom:6px;">단위 업무</div>
        <table class="ed"><thead><tr>
          <th style="width:150px;">단위 업무명</th><th>주요 업무내용</th><th style="width:110px;">업무 주기</th><th style="width:26px;"></th>
        </tr></thead><tbody id="dutyBody"></tbody></table>
        <button type="button" class="st-btn mini" style="margin-top:6px;" onclick="stDutyAdd();">＋ 행 추가</button>
      </div>
      <div style="margin-top:14px;">
        <div style="font-size:13px; font-weight:800; color:#20303a; margin-bottom:6px;">자격요건</div>
        <div class="fm">
          <div class="lb">학력수준</div>     <div class="full"><input type="text" id="f_eduLevel" maxlength="200" placeholder="필수 / 권장 / 전문분야"></div>
          <div class="lb">전공학과</div>     <div class="full"><input type="text" id="f_majorTxt" maxlength="200" placeholder="무관 / 1순위 / 2순위"></div>
          <div class="lb">면허 및 자격</div> <div class="full"><input type="text" id="f_licenseTxt" maxlength="200" placeholder="필수 / 권장"></div>
          <div class="lb">경력요건</div>     <div class="full"><input type="text" id="f_careerReq" maxlength="200" placeholder="필수 / 권장"></div>
        </div>
      </div>
    </div>

    <div class="st-card">
      <h4>첨부파일 <span class="hint">— 수료증·자격증 등</span></h4>
      <div id="stFileBox"></div>
    </div>
  </div>
</div>

<script>
(function(){
  var curSeq = 0;
  /* 원본 직무기술서의 단위업무 5종 — 고정 항목이라 새 전담자에 미리 깔아 준다 */
  var DUTY_DEF = ['감염관리 계획수립 및 평가','감염관리','감염관리 교육','지표관리','직원감염관리'];

  var fileBox = window.qpsFileBox({ mount:'stFileBox', refGb:'INFSTAFF',
      hint:'수료증·자격증', needSaveMsg:'전담자를 먼저 저장하면 첨부할 수 있습니다.' });

  // ★hospCd 를 보내지 않는다(서버가 쿠키를 본다) · dataType:'json' 필수 — QPS 화면 공통 원칙
  function post(url, data){
    return $.ajax({ url:url, type:'POST', data:data, dataType:'json' }).then(function(res){
      if (res && res.result === 'FAIL') { throw new Error(res.message || '처리에 실패했습니다.'); }
      return res;
    });
  }
  function err(e){ try{ _alertBox((e && e.message) || '처리 중 오류가 발생했습니다.', {icon:'❌'}); }catch(x){ alert(e && e.message); } }
  function esc(s){ return (s==null?'':String(s)).replace(/[&<>"]/g, function(c){
      return ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;'})[c]; }); }
  function val(id){ var e=document.getElementById(id); return e ? String(e.value).trim() : ''; }
  function set(id, v){ var e=document.getElementById(id); if(e) e.value = (v==null?'':v); }

  window.stTab = function(n){
    for (var i=1;i<=3;i++){
      document.getElementById('card'+i).style.display = (i===n) ? '' : 'none';
      document.getElementById('tab'+i).className = 'st-tab' + (i===n ? ' on' : '');
    }
  };

  function eduAdd(r){
    r = r || {};
    var tr = document.createElement('tr');
    tr.innerHTML =
      '<td><input type="text" data-f="orgnm" value="' + esc(r.orgnm) + '"></td>' +
      '<td><input type="text" data-f="crsnm" value="' + esc(r.crsnm) + '"></td>' +
      '<td><input type="text" data-f="edudt" value="' + esc(r.edudt) + '"></td>' +
      '<td><input type="text" data-f="eduterm" value="' + esc(r.eduterm) + '"></td>' +
      '<td class="rowdel" onclick="this.closest(\'tr\').remove();">✕</td>';
    document.getElementById('eduBody').appendChild(tr);
  }
  window.stEduAdd = function(){ eduAdd({}); };

  function dutyAdd(r){
    r = r || {};
    var tr = document.createElement('tr');
    tr.innerHTML =
      '<td><input type="text" data-f="dutynm" value="' + esc(r.dutynm) + '"></td>' +
      '<td><textarea data-f="dutytxt" style="min-height:52px;">' + esc(r.dutytxt) + '</textarea></td>' +
      '<td><input type="text" data-f="dutycyc" value="' + esc(r.dutycyc) + '"></td>' +
      '<td class="rowdel" onclick="this.closest(\'tr\').remove();">✕</td>';
    document.getElementById('dutyBody').appendChild(tr);
  }
  window.stDutyAdd = function(){ dutyAdd({}); };

  function collect(sel){
    var out = [], sort = 0;
    document.querySelectorAll(sel + ' tr').forEach(function(tr){
      var r = { sort: ++sort };
      tr.querySelectorAll('[data-f]').forEach(function(el){ r[el.getAttribute('data-f')] = String(el.value).trim(); });
      out.push(r);
    });
    return out;
  }

  window.stList = function(){
    return post('/qps/infStaffList.do', {}).then(function(res){
      var list = res.list || [], box = document.getElementById('stList');
      if (!list.length){ box.innerHTML = '<div class="st-empty">등록된 전담자가 없습니다.</div>'; return; }
      box.innerHTML = list.map(function(r){
        return '<div class="st-item' + (Number(r.stfseq)===curSeq ? ' on' : '') + '" onclick="stOpen(' + r.stfseq + ');">' +
               '<div class="t">' + esc(r.stfnm) + '</div>' +
               '<div class="d">' + esc(r.deptnm||'') + (r.position ? ' · ' + esc(r.position) : '') + '</div></div>';
      }).join('');
    }).catch(err);
  };

  window.stOpen = function(seq){
    post('/qps/infStaffGet.do', { stfSeq: seq }).then(function(res){
      var d = res.doc || {};
      curSeq = Number(d.stfseq || 0);
      set('f_stfSeq', d.stfseq); set('f_stfNm', d.stfnm); set('f_deptNm', d.deptnm);
      set('f_position', d.position); set('f_apptDt', d.apptdt);
      set('f_jobKind', d.jobkind); set('f_careerTxt', d.careertxt);
      set('f_joinDt', d.joindt); set('f_rankNm', d.ranknm); set('f_deptDt', d.deptdt);
      set('f_dutyDt', d.dutydt); set('f_writeDt', d.writedt);
      set('f_eduLevel', d.edulevel); set('f_majorTxt', d.majortxt);
      set('f_licenseTxt', d.licensetxt); set('f_careerReq', d.careerreq);
      document.getElementById('eduBody').innerHTML = '';
      (res.edus || []).forEach(eduAdd);
      if (!(res.edus || []).length) for (var i=0;i<5;i++) eduAdd({});
      document.getElementById('dutyBody').innerHTML = '';
      var du = res.duties || [];
      if (du.length) du.forEach(dutyAdd);
      else DUTY_DEF.forEach(function(n){ dutyAdd({ dutynm:n }); });
      document.getElementById('stStat').textContent = '— 저장됨 #' + d.stfseq;
      document.getElementById('stDelBtn').style.display = '';
      if (fileBox) fileBox.setKey(d.stfseq);
      stList();
    }).catch(err);
  };

  window.stNew = function(){
    curSeq = 0;
    ['f_stfSeq','f_stfNm','f_deptNm','f_position','f_apptDt','f_jobKind','f_careerTxt','f_joinDt',
     'f_rankNm','f_deptDt','f_dutyDt','f_writeDt','f_eduLevel','f_majorTxt','f_licenseTxt','f_careerReq']
      .forEach(function(id){ set(id, ''); });
    document.getElementById('eduBody').innerHTML = '';
    for (var i=0;i<5;i++) eduAdd({});
    document.getElementById('dutyBody').innerHTML = '';
    DUTY_DEF.forEach(function(n){ dutyAdd({ dutynm:n }); });   // 원본 고정 5업무를 미리 깔아 준다
    document.getElementById('stStat').textContent = '— 새 전담자';
    document.getElementById('stDelBtn').style.display = 'none';
    if (fileBox) fileBox.setKey('');
    stTab(1); stList();
  };

  window.stSave = function(){
    if (!val('f_stfNm')) { _alertBox('성명을 입력해 주세요.', {icon:'⚠️'}); stTab(1); return; }
    post('/qps/infStaffSave.do', {
      stfSeq: val('f_stfSeq'), stfNm: val('f_stfNm'), deptNm: val('f_deptNm'),
      position: val('f_position'), apptDt: val('f_apptDt'),
      jobKind: val('f_jobKind'), careerTxt: val('f_careerTxt'),
      joinDt: val('f_joinDt'), rankNm: val('f_rankNm'), deptDt: val('f_deptDt'),
      dutyDt: val('f_dutyDt'), writeDt: val('f_writeDt'),
      eduLevel: val('f_eduLevel'), majorTxt: val('f_majorTxt'),
      licenseTxt: val('f_licenseTxt'), careerReq: val('f_careerReq'),
      edus: JSON.stringify(collect('#eduBody')),
      duties: JSON.stringify(collect('#dutyBody'))
    }).then(function(res){
      curSeq = Number(res.stfSeq || 0);
      set('f_stfSeq', curSeq);
      document.getElementById('stStat').textContent = '— 저장됨 #' + curSeq;
      document.getElementById('stDelBtn').style.display = '';
      if (fileBox) fileBox.setKey(curSeq);
      _toast('저장되었습니다.', 'ok');
      stList();
    }).catch(err);
  };

  window.stDel = function(){
    if (!curSeq) return;
    _confirmBox({ msg:'이 전담자 서류를 삭제할까요?', icon:'⚠️', okText:'삭제', okColor:'#b23b3b',
      onOk: function(){ post('/qps/infStaffDelete.do', { stfSeq: curSeq })
        .then(function(){ _toast('삭제되었습니다.', 'ok'); stNew(); }).catch(err); } });
  };

  stNew();
})();

/* === 글자 크기 (2026-08-18 요청) ==========================================
   QI 계획서(qpsQiPlan)의 zzZoom 과 **같은 규칙** - 0.8~1.6배, 0.1 단위, ↺ 는 처음 크기.
   ★고른 크기는 **이 PC 이 브라우저에만** 남는다(localStorage). 키는 화면마다 따로 둔다. */
(function(){
  var W = 'qpsInfStaff', ZKEY = 'qpsZoom_' + W;
  /* ⚠**같은 화면이 두 벌 붙어 있을 수 있다**(주소 숨김 구조 - content 를 갈아끼운다).
     getElementById 는 「첫 번째 = 보이지 않는 사본」을 잡아 ***눌러도 아무 일이 없다.***
     ⇒ querySelectorAll 로 **붙어 있는 사본 전부**에 건다. */
  function els(){ return [].slice.call(document.querySelectorAll('#' + W)); }
  function zoom(z){
    z = Math.min(1.6, Math.max(0.8, z));
    els().forEach(function(w){ w.style.zoom = z.toFixed(2); });
    return z;
  }
  window.zzZoom = function(d){
    var e0 = els()[0], c0 = parseFloat(e0 && e0.style.zoom) || 1;
    if (d === 0) { zoom(1); try { localStorage.removeItem(ZKEY); } catch (e) {} return; }
    var z = zoom(c0 + d * 0.1);
    try { localStorage.setItem(ZKEY, String(z)); } catch (e) {}
  };
  try { var z = parseFloat(localStorage.getItem(ZKEY)); if (z) zoom(z); } catch (e) {}
})();
</script>
</div>
</div><%-- /.dashboard-wrapper --%>
