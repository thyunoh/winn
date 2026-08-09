<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%-- qpsRpt.jsp — 지표분석보고서 현황판 (2026-08-09)
     · 선택 기간의 18종 보고서를 작성·결재 상태와 함께 한 화면에.
       QPS 담당자 = "어느 보고서가 안 됐나" / 결재자 = "내가 승인할 문서가 있나".
     · 행을 누르면 그 지표의 분석 탭으로 간다(기간 딥링크 ?prd= 포함 — 고른 기간이 그대로 열린다).
     · ★주의: 이 파일 안에서 Deferred EL 표기(샵+중괄호) 금지 --%>

<script src="/asset/js/ui-message.js"></script>

<div class="dashboard-wrapper">
<div id="qpsRpt" data-wnn="<c:out value='${wnnYn}'/>">
<style>
  #qpsRpt{ background:#f4f6f8; color:#1f2a30; min-height:100%; padding:14px 16px 50px; max-width:100%; overflow-x:hidden; }
  #qpsRpt *{ box-sizing:border-box; }
  #qpsRpt .qr-head{ display:flex; align-items:center; gap:10px; margin-bottom:12px; flex-wrap:wrap; }
  #qpsRpt .qr-title{ font-size:18px; font-weight:800; color:#20303a; display:flex; align-items:center; gap:8px; }
  #qpsRpt .qr-dot{ width:10px; height:10px; border-radius:50%; background:linear-gradient(135deg,#1f5a4b,#2a7665); }
  #qpsRpt .qr-sub{ font-size:12px; color:#6b7c86; }
  #qpsRpt .qr-hosp{ background:#e7f3ee; color:#1f5a4b; font-size:12px; font-weight:800;
      border:1px solid #cfe3da; border-radius:14px; padding:3px 11px; }
  #qpsRpt .qr-spacer{ flex:1; }
  #qpsRpt select{ border:1px solid #cfd8e0; border-radius:6px; padding:5px 8px; font-size:13px; background:#fff; }

  /* 요약 타일 */
  #qpsRpt .qr-tiles{ display:flex; gap:10px; margin-bottom:14px; flex-wrap:wrap; }
  #qpsRpt .qr-tile{ background:#fff; border:1px solid #e3e9ed; border-radius:10px; padding:10px 16px; min-width:110px; }
  #qpsRpt .qr-tile .n{ font-size:22px; font-weight:800; }
  #qpsRpt .qr-tile .k{ font-size:11.5px; color:#6b7c86; margin-top:1px; }
  #qpsRpt .qr-tile.confirm .n{ color:#1f7a52; }
  #qpsRpt .qr-tile.submit  .n{ color:#a2701f; }
  #qpsRpt .qr-tile.reject  .n{ color:#b23b3b; }
  #qpsRpt .qr-tile.none    .n{ color:#94a3ab; }

  /* 표 */
  #qpsRpt .qr-card{ background:#fff; border:1px solid #e3e9ed; border-radius:10px; padding:6px 8px; }
  #qpsRpt table{ width:100%; border-collapse:collapse; font-size:13px; }
  #qpsRpt th{ background:#f2f6f8; font-weight:700; color:#43555f; padding:8px 10px; border-bottom:1px solid #dde5ea;
      text-align:left; white-space:nowrap; }
  #qpsRpt td{ padding:8px 10px; border-bottom:1px solid #eef2f5; }
  #qpsRpt tbody tr{ cursor:pointer; }
  #qpsRpt tbody tr:hover{ background:#f7fbf9; }
  #qpsRpt .qr-area{ font-size:11px; color:#8a99a3; }
  #qpsRpt .qr-nm{ font-weight:700; color:#20303a; }
  #qpsRpt .st{ font-size:11.5px; font-weight:800; border-radius:11px; padding:2px 10px; white-space:nowrap; }
  #qpsRpt .st.draft  { background:#eef2f5; color:#6b7c86; }
  #qpsRpt .st.submit { background:#fdf3e2; color:#a2701f; }
  #qpsRpt .st.reject { background:#fdeaea; color:#b23b3b; }
  #qpsRpt .st.confirm{ background:#e4f3ea; color:#1f7a52; }
  #qpsRpt .st.none   { background:#f7f8f9; color:#a8b4bb; }
  #qpsRpt .qr-write{ font-size:11.5px; color:#2f5f96; }
  #qpsRpt .qr-empty{ color:#8a99a3; font-size:13px; padding:22px; text-align:center; }
</style>

<div class="qr-head">
  <div class="qr-title"><span class="qr-dot"></span>지표분석보고서 현황</div>
  <div class="qr-sub">행을 누르면 그 지표의 분석·결재 화면으로 이동합니다</div>
  <span class="qr-hosp">🏥 <c:out value="${hospNm}" default="병원 미확인"/></span>
  <div class="qr-spacer"></div>
  <select id="qrYear" onchange="qrLoad();"></select>
  <select id="qrPrd" onchange="qrLoad();"></select>
</div>

<div class="qr-tiles" id="qrTiles"></div>

<div class="qr-card">
  <table>
    <thead><tr>
      <th style="width:120px;">영역</th><th>지표</th>
      <th style="width:90px;">서술</th><th style="width:120px;">결재 상태</th>
      <th style="width:100px;">진행</th><th style="width:110px;">최종수정</th>
    </tr></thead>
    <tbody id="qrBody"><tr><td colspan="6" class="qr-empty">불러오는 중…</td></tr></tbody>
  </table>
</div>

<script>
(function(){
  // ★hospCd 를 보내지 않는다(서버가 쿠키를 본다) · dataType:'json' 필수 — QPS 화면 공통 원칙
  function post(url, data){
    return $.ajax({ url:url, type:'POST', data:data, dataType:'json' }).then(function(res){
      if (res && res.result === 'FAIL') { throw new Error(res.message || '처리에 실패했습니다.'); }
      return res;
    });
  }
  function esc(s){ return (s==null?'':String(s)).replace(/[&<>"]/g, function(c){
      return ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;'})[c]; }); }

  (function(){
    var y = new Date().getFullYear(), sy = document.getElementById('qrYear');
    for (var i = y + 1; i >= y - 4; i--) sy.add(new Option(i + '년', i));
    sy.value = y;
    var sp = document.getElementById('qrPrd');
    ['Q1','Q2','Q3','Q4','H1','H2'].forEach(function(k){
      var nm = k.charAt(0) === 'Q' ? (k.charAt(1) + '/4 분기') : (k === 'H1' ? '중간(상반기)' : '최종(하반기)');
      sp.add(new Option(nm, k));
    });
    // 기본 기간 = 지금 날짜가 속한 분기 — 담당자가 보통 보는 것은 '이번 분기'다
    sp.value = 'Q' + (Math.floor(new Date().getMonth() / 3) + 1);
  })();

  var ST = { DRAFT:  { cls:'draft',   nm:'작성중' },
             SUBMIT: { cls:'submit',  nm:'결재중' },
             REJECT: { cls:'reject',  nm:'반려' },
             CONFIRM:{ cls:'confirm', nm:'최종승인' } };

  window.qrLoad = function(){
    var prd = document.getElementById('qrPrd').value;
    var key = document.getElementById('qrYear').value + prd;
    post('/qps/rptStatusList.do', { prdKey: key }).then(function(res){
      var list = res.list || [], lastStep = (res.line || []).length;
      var cnt = { CONFIRM:0, SUBMIT:0, REJECT:0, DRAFT:0, NONE:0 };

      var html = '', curArea = null;
      list.forEach(function(r){
        var st = r.status ? (ST[r.status] || ST.DRAFT) : { cls:'none', nm:'작성 전' };
        cnt[r.status ? (ST[r.status] ? r.status : 'DRAFT') : 'NONE']++;
        var prog = (r.status === 'SUBMIT') ? (r.curstep + '/' + lastStep + ' 단계')
                 : (r.status === 'CONFIRM') ? (lastStep + '/' + lastStep + ' 완료') : '-';
        html += '<tr onclick="qrGo(\'' + esc(r.indicd) + '\');">' +
          '<td class="qr-area">' + (r.areanm !== curArea ? esc(r.areanm) : '') + '</td>' +
          '<td class="qr-nm">' + esc(r.indinm) + '</td>' +
          '<td>' + (r.writeyn === 'Y' ? '<span class="qr-write">작성됨</span>' : '<span style="color:#a8b4bb;">-</span>') + '</td>' +
          '<td><span class="st ' + st.cls + '">' + st.nm + '</span></td>' +
          '<td>' + prog + '</td>' +
          '<td style="color:#8a99a3; font-size:12px;">' + esc(r.upddttm || '-') + '</td></tr>';
        curArea = r.areanm;
      });
      document.getElementById('qrBody').innerHTML =
        html || '<tr><td colspan="6" class="qr-empty">지표 마스터가 비어 있습니다.</td></tr>';

      document.getElementById('qrTiles').innerHTML =
        '<div class="qr-tile"><div class="n">' + list.length + '</div><div class="k">전체 지표</div></div>' +
        '<div class="qr-tile confirm"><div class="n">' + cnt.CONFIRM + '</div><div class="k">최종승인</div></div>' +
        '<div class="qr-tile submit"><div class="n">' + cnt.SUBMIT + '</div><div class="k">결재중</div></div>' +
        '<div class="qr-tile reject"><div class="n">' + cnt.REJECT + '</div><div class="k">반려</div></div>' +
        '<div class="qr-tile none"><div class="n">' + (cnt.DRAFT + cnt.NONE) + '</div><div class="k">작성중·작성 전</div></div>';
    }).catch(function(e){
      document.getElementById('qrBody').innerHTML =
        '<tr><td colspan="6" class="qr-empty">' + esc((e && e.message) || '불러오지 못했습니다.') + '</td></tr>';
    });
  };
  window.qrGo = function(cd){
    location.href = '/main/qpsFall.do?indi=' + encodeURIComponent(cd) +
                    '&prd=' + encodeURIComponent(document.getElementById('qrPrd').value);
  };
  $(function(){ qrLoad(); });
})();
</script>
</div><%-- /#qpsRpt --%>
</div><%-- /.dashboard-wrapper --%>
