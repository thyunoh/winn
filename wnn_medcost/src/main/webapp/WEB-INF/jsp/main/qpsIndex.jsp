<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%-- qpsIndex.jsp — QPS 지표 현황 (2026-08-09)
     · QPS 의 첫 화면. 지표 18종을 **영역별**로 보여주고 클릭해서 각 지표로 들어간다.
     · 사이드바에 지표를 하나씩 늘어놓지 않는 이유 = 18종이면 메뉴가 화면을 다 먹고,
       앞으로 붙을 지표정의서·분석보고서·서식이 들어갈 자리가 없다.
     · 카드에 '입력 자료 유무'를 함께 찍는다 — 담당자가 가장 먼저 알고 싶은 것이 "어디가 비었나"다.
     · ★주의: 이 파일 안에서 Deferred EL 표기(샵+중괄호) 금지 — 변환에러로 content 타일이 빈 화면이 된다 --%>

<script src="/asset/js/ui-message.js"></script>

<%-- ★[반드시 유지] .dashboard-wrapper — sidebar.jsp 가 이 클래스에만 margin-left:280px 을 준다.
     빼면 화면 왼쪽 280px 이 좌측 메뉴에 가려진다(qpsFall.jsp 와 같은 함정). --%>
<div class="dashboard-wrapper">
<div id="qpsIndex" data-hospcd="<c:out value='${hospCd}'/>" data-wnn="<c:out value='${wnnYn}'/>">
<style>
  #qpsIndex{ background:#f4f6f8; color:#1f2a30; min-height:100%; padding:14px 16px 50px; max-width:100%; overflow-x:hidden; }
  #qpsIndex *{ box-sizing:border-box; }
  #qpsIndex .qi-head{ display:flex; align-items:center; gap:10px; margin-bottom:14px; flex-wrap:wrap; }
  #qpsIndex .qi-title{ font-size:18px; font-weight:800; color:#20303a; display:flex; align-items:center; gap:8px; }
  #qpsIndex .qi-dot{ width:10px; height:10px; border-radius:50%; background:linear-gradient(135deg,#1f5a4b,#2a7665); }
  #qpsIndex .qi-sub{ font-size:12px; color:#6b7c86; }
  #qpsIndex .qi-spacer{ flex:1; }
  #qpsIndex .qi-hosp{ background:#e7f3ee; color:#1f5a4b; font-size:12px; font-weight:800;
      border:1px solid #cfe3da; border-radius:14px; padding:3px 11px; }
  #qpsIndex select{ border:1px solid #cfd8e0; border-radius:6px; padding:5px 8px; font-size:13px; background:#fff; }

  /* 영역 묶음 */
  #qpsIndex .qi-area{ margin-bottom:18px; }
  #qpsIndex .qi-areahead{ display:flex; align-items:baseline; gap:9px; margin:0 2px 8px; }
  #qpsIndex .qi-areanm{ font-size:14px; font-weight:800; color:#1f5a4b; }
  #qpsIndex .qi-areacnt{ font-size:11.5px; color:#8a99a3; }
  #qpsIndex .qi-line{ flex:1; height:1px; background:#e0e7ea; }

  /* 지표 카드 */
  #qpsIndex .qi-grid{ display:grid; grid-template-columns:repeat(auto-fill, minmax(268px,1fr)); gap:10px; }
  #qpsIndex .qi-card{ background:#fff; border:1px solid #e3e9ed; border-radius:10px; padding:12px 13px;
      cursor:pointer; transition:border-color .12s, box-shadow .12s, transform .12s; display:flex; flex-direction:column; gap:6px; }
  #qpsIndex .qi-card:hover{ border-color:#8fc3b2; box-shadow:0 4px 14px rgba(31,90,75,.10); transform:translateY(-1px); }
  #qpsIndex .qi-nm{ font-size:13.5px; font-weight:750; color:#20303a; line-height:1.35; }
  #qpsIndex .qi-formula{ font-size:11.5px; color:#7b8b95; font-family:Consolas,monospace; }
  #qpsIndex .qi-foot{ display:flex; align-items:center; gap:6px; flex-wrap:wrap; margin-top:2px; }
  #qpsIndex .qi-tag{ font-size:10.5px; font-weight:700; border-radius:4px; padding:1px 6px;
      background:#eef2f5; color:#6b7c86; }
  #qpsIndex .qi-state{ font-size:11px; font-weight:700; border-radius:10px; padding:1px 8px; margin-left:auto; }
  #qpsIndex .qi-state.on{ background:#e4f3ea; color:#1f7a52; }
  #qpsIndex .qi-state.auto{ background:#e7eff8; color:#2f5f96; }
  #qpsIndex .qi-state.off{ background:#f3f5f6; color:#94a3ab; }

  #qpsIndex .qi-note{ background:#f7fbf9; border:1px solid #d9e8e2; border-radius:8px;
      padding:8px 11px; font-size:12.5px; color:#4a5c66; line-height:1.6; margin-bottom:14px; }
  #qpsIndex .qi-note b{ color:#1f5a4b; }
  #qpsIndex .qi-empty{ color:#8a99a3; font-size:13px; padding:20px; text-align:center; }
</style>

<div class="qi-head">
  <div class="qi-title"><span class="qi-dot"></span>QPS 지표 현황</div>
  <div class="qi-sub">지표를 눌러 입력·분석 화면으로 이동합니다</div>
  <span class="qi-hosp">🏥 <c:out value="${hospNm}" default="병원 미확인"/></span>
  <div class="qi-spacer"></div>
  <select id="qiYear" onchange="qiLoad();"></select>
</div>

<div class="qi-note">
  <b>자료 표시</b> — <span class="qi-state on" style="margin:0;">입력됨</span> 그 해에 입력된 자료가 있음 ·
  <span class="qi-state auto" style="margin:0;">자동집계</span> 환자평가표에서 자동으로 산출(입력 불필요) ·
  <span class="qi-state off" style="margin:0;">입력 전</span> 아직 자료가 없어 지표가 '-' 로 나옴
</div>

<div id="qiBody"><div class="qi-empty">불러오는 중…</div></div>

<script>
(function(){
  var $root = document.getElementById('qpsIndex');

  // ★hospCd 를 보내지 않는다 — 서버가 매 요청 쿠키(s_hospid)를 본다.
  //   상단 [병원검색]으로 병원을 바꾸면 자동으로 그 병원 자료가 나온다(qpsFall.jsp 와 같은 원칙).
  //   ★dataType:'json' 필수 — 빠뜨리면 응답이 문자열로 와서 조용히 0건이 된다.
  function post(url, data){
    return $.ajax({ url:url, type:'POST', data:data, dataType:'json' }).then(function(res){
      if (res && res.result === 'FAIL') { throw new Error(res.message || '처리에 실패했습니다.'); }
      return res;
    });
  }
  function esc(s){ return (s==null?'':String(s)).replace(/[&<>"]/g, function(c){
      return ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;'})[c]; }); }
  function year(){ return document.getElementById('qiYear').value; }

  (function(){
    var sel = document.getElementById('qiYear'), y = new Date().getFullYear();
    for (var i = y + 1; i >= y - 4; i--) sel.add(new Option(i + '년', i));
    sel.value = y;
  })();

  var SRC_NM = { INCIDENT:'사고보고', PATVAL:'평가표 자동', MONITOR:'관찰기록', MANUAL:'월별 수기' };

  // 입력 상태 — 원천마다 '자료가 있다'의 뜻이 다르다.
  //   ★수기형은 한 해에 분자·분모 두 행뿐이라 건수를 찍으면 '입력됨 2' 처럼 뜻 없는 숫자가 된다
  //     → 수기형은 숫자 없이 '입력됨' 만(2026-08-09).
  function stateOf(r){
    if (r.numersrc === 'PATVAL')   return { cls:'auto', txt:'자동집계' };
    if (r.numersrc === 'MANUAL')   return Number(r.mancnt||0) > 0
                                        ? { cls:'on', txt:'입력됨' } : { cls:'off', txt:'입력 전' };
    var n = (r.numersrc === 'MONITOR') ? Number(r.moncnt||0) : Number(r.incidcnt||0);
    return n > 0 ? { cls:'on', txt:'입력됨 ' + n } : { cls:'off', txt:'입력 전' };
  }

  window.qiLoad = function(){
    post('/qps/indiList.do', { inYear: year() }).then(function(res){
      var list = res.list || [], body = document.getElementById('qiBody');
      if (!list.length) { body.innerHTML = '<div class="qi-empty">지표 마스터가 비어 있습니다. DDL 시드를 먼저 적용해 주세요.</div>'; return; }
      var html = '', curArea = null, open = false;
      list.forEach(function(r){
        if (r.areanm !== curArea) {
          if (open) html += '</div></div>';
          curArea = r.areanm;
          var cnt = list.filter(function(x){ return x.areanm === curArea; }).length;
          html += '<div class="qi-area"><div class="qi-areahead">' +
                  '<span class="qi-areanm">' + esc(curArea) + '</span>' +
                  '<span class="qi-areacnt">' + cnt + '종</span>' +
                  '<span class="qi-line"></span></div><div class="qi-grid">';
          open = true;
        }
        var st = stateOf(r);
        var mul = Number(r.multiplier || 1000).toLocaleString();
        // 목표값이 있으면 산식 옆에 — 담당자가 현황에서 바로 "우리 목표가 얼마였지"를 본다
        var tgt = (r.targetval == null || r.targetval === '') ? ''
                : ' · 목표 ' + Number(r.targetval) + esc(r.unit || '');
        html += '<div class="qi-card" onclick="qiGo(\'' + esc(r.indicd) + '\');">' +
                '<div class="qi-nm">' + esc(r.indinm) + '</div>' +
                '<div class="qi-formula">분자 ÷ 분모 × ' + mul + ' = ' + esc(r.unit || '') + tgt + '</div>' +
                '<div class="qi-foot">' +
                  '<span class="qi-tag">' + esc(SRC_NM[r.numersrc] || r.numersrc || '-') + '</span>' +
                  '<span class="qi-tag">' + (r.cyclegb === 'Q' ? '분기' : (r.cyclegb === 'H' ? '반기' : (r.cyclegb === 'Y' ? '연간' : esc(r.cyclegb||'')))) + '</span>' +
                  // 정의서를 아직 안 채운 지표는 표시해 준다 — 인증 제출 전에 병원이 채워야 할 목록이 된다
                  (r.defown === 'Y' ? '<span class="qi-tag" style="background:#e4f3ea;color:#1f7a52;">정의서 작성</span>'
                                    : '<span class="qi-tag" style="color:#b58a3a;background:#fdf3e2;">정의서 미작성</span>') +
                  '<span class="qi-state ' + st.cls + '">' + esc(st.txt) + '</span>' +
                '</div></div>';
      });
      if (open) html += '</div></div>';
      body.innerHTML = html;
    }).catch(function(e){
      document.getElementById('qiBody').innerHTML =
        '<div class="qi-empty">' + esc((e && e.message) || '불러오지 못했습니다.') + '</div>';
    });
  };
  window.qiGo = function(cd){ location.href = '/main/qpsFall.do?indi=' + encodeURIComponent(cd); };

  $(function(){ qiLoad(); });
})();
</script>
</div><%-- /#qpsIndex --%>
</div><%-- /.dashboard-wrapper --%>
