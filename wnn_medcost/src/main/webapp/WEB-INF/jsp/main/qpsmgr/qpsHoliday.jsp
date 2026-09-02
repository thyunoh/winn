<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%-- qpsHoliday.jsp — 기준코드 › 공휴일 관리 (2026-09-02)
     · 메뉴 : QPS ▸ 공통 ▸ 기준코드 ▸ 공휴일 관리 (사용자 지시 「QPS 공통에 기준코드로 공휴일 관리 서브로」).
     · 전 병원 공용 한 벌(TBL_QPS_HOLIDAY). 점검표 작성 화면이 「토·일·공휴일 제외」(전체 O · 일괄 서명)와
       날짜 머리글 색에 쓴다 — SUNWOO t_holiday 대응(델파이 소스 대조 2026-09-02).
     · 보는 것은 모두 · 등록·삭제는 위너넷만(화면은 data-wnn 으로 숨기고, 서버 holidaySave/Del 이 다시 막는다).
     · 토·일은 넣지 않는다(화면이 날짜로 안다). 대체공휴일·임시공휴일은 여기에 넣는다.
     · ★주의: 이 파일 안에서 Deferred EL 표기(샵+중괄호) 금지 --%>

<script src="/asset/js/ui-message.js"></script>

<div class="dashboard-wrapper">
<div id="qpsHoliday" data-wnn="<c:out value='${wnnYn}'/>">
<style>
  #qpsHoliday{ background:#f4f6f8; color:#1f2a30; min-height:100%; padding:14px 16px 50px; max-width:100%; overflow-x:hidden; }
  #qpsHoliday *{ box-sizing:border-box; }
  #qpsHoliday .qh-head{ display:flex; align-items:center; gap:10px; margin-bottom:12px; flex-wrap:wrap; }
  #qpsHoliday .qh-title{ font-size:18px; font-weight:800; color:#20303a; display:flex; align-items:center; gap:8px; }
  #qpsHoliday .qh-dot{ width:10px; height:10px; border-radius:50%; background:linear-gradient(135deg,#1f5a4b,#2a7665); }
  #qpsHoliday .qh-sub{ font-size:12px; color:#6b7c86; font-weight:400; }
  #qpsHoliday .qh-hosp{ background:#e7f3ee; color:#1f5a4b; font-size:12px; font-weight:800;
      border:1px solid #cfe3da; border-radius:14px; padding:3px 11px; }
  #qpsHoliday .qh-spacer{ flex:1; }
  #qpsHoliday select, #qpsHoliday input{ border:1px solid #cfd8e0; border-radius:6px; padding:5px 8px; font-size:13px; background:#fff; font-family:inherit; }
  #qpsHoliday .qh-note{ background:#fff; border:1px solid #e3e9ed; border-radius:10px; padding:10px 14px; font-size:12.5px; color:#43555f; margin-bottom:12px; line-height:1.6; }
  #qpsHoliday .qh-note b{ color:#20303a; }
  #qpsHoliday .qh-card{ background:#fff; border:1px solid #e3e9ed; border-radius:10px; padding:6px 8px; max-width:720px; }
  #qpsHoliday table{ width:100%; border-collapse:collapse; font-size:13px; }
  #qpsHoliday th{ background:#f2f6f8; font-weight:700; color:#43555f; padding:8px 10px; border-bottom:1px solid #dde5ea; text-align:left; white-space:nowrap; }
  #qpsHoliday td{ padding:7px 10px; border-bottom:1px solid #eef2f5; }
  #qpsHoliday td.dow{ color:#6b7c86; font-size:12px; }
  #qpsHoliday td.dow.sat{ color:#2c6fb5; } #qpsHoliday td.dow.sun{ color:#c0392b; }
  #qpsHoliday .qh-empty{ color:#8a99a3; font-size:13px; padding:22px; text-align:center; }
  #qpsHoliday .qh-btn{ border:1px solid #cfd9e0; background:#fff; color:#43555f; border-radius:6px; padding:4px 10px; font-size:12.5px; font-weight:700; cursor:pointer; }
  #qpsHoliday .qh-btn:hover{ background:#eef3f6; }
  #qpsHoliday .qh-btn.pri{ background:#1f5a4b; color:#fff; border-color:#1f5a4b; }
  #qpsHoliday .qh-btn.pri:hover{ background:#2a7665; }
  #qpsHoliday .qh-btn.del{ color:#b23b3b; }
  #qpsHoliday .qh-add{ display:flex; align-items:center; gap:8px; flex-wrap:wrap; margin-top:12px; max-width:720px;
      background:#fff; border:1px solid #e3e9ed; border-radius:10px; padding:10px 14px; }
  #qpsHoliday .qh-cnt{ font-size:12px; color:#6b7c86; margin-left:6px; }
</style>

<div class="qh-head">
  <div class="qh-title"><span class="qh-dot"></span>공휴일 관리 <span class="qh-sub">— 기준코드 · 전 병원 공용</span></div>
  <span class="qh-hosp">🏥 <c:out value='${hospNm}'/></span>
  <span class="qh-spacer"></span>
  <label style="font-size:13px;color:#43555f;">연도 <select id="qhYear" onchange="qhLoad();"></select></label>
  <span class="qh-cnt" id="qhCnt"></span>
</div>

<div class="qh-note">
  점검표 작성 화면이 이 목록을 씁니다 — <b>「토·일·공휴일 제외」</b>를 켜면 [전체 O]·일괄 서명이 이 날짜를 건너뛰고,
  날짜 머리글에 <span style="color:#c0392b;text-decoration:underline dotted;">빨간 점선</span>으로 표시됩니다.
  토·일은 넣지 않아도 됩니다(화면이 날짜로 압니다). <b>대체공휴일·임시공휴일</b>은 여기에 넣어 두세요.
  <span id="qhWnnNote" style="display:none;">같은 날짜를 다시 등록하면 이름만 바뀝니다.</span>
  <span id="qhHospNote" style="display:none;">등록·삭제는 위너넷 담당자가 합니다 — 빠진 날이 있으면 알려 주세요.</span>
</div>

<div class="qh-card">
  <table>
    <thead><tr><th style="width:130px;">날짜</th><th style="width:60px;">요일</th><th>이름</th><th style="width:70px;"></th></tr></thead>
    <tbody id="qhBody"><tr><td colspan="4" class="qh-empty">불러오는 중…</td></tr></tbody>
  </table>
</div>

<div class="qh-add" id="qhAdd" style="display:none;">
  <b style="font-size:13px;color:#20303a;">추가</b>
  <input type="date" id="qhDt" style="width:auto;">
  <input type="text" id="qhNm" placeholder="이름 (예: 추석, 대체공휴일)" maxlength="50" style="width:220px;">
  <button type="button" class="qh-btn pri" onclick="qhAdd();">등록</button>
</div>

<script>
(function(){
  var DOW = ['일','월','화','수','목','금','토'];
  function gel(id){ return document.getElementById(id); }
  function esc(s){ return (s==null?'':String(s)).replace(/[&<>"]/g, function(c){ return ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;'})[c]; }); }
  function post(url, data){
    return $.ajax({ url:url, type:'POST', data:data, dataType:'json' }).then(function(res){
      if (res && res.result === 'FAIL') { throw new Error(res.message || '처리에 실패했습니다.'); }
      return res;
    });
  }
  function err(e){ _alertBox((e && e.message) ? e.message : '처리 중 오류가 발생했습니다.', {icon:'❌'}); }
  var WNN = gel('qpsHoliday').getAttribute('data-wnn') === 'Y';

  (function(){
    var y = new Date().getFullYear(), sy = gel('qhYear');
    for (var i = y - 1; i <= y + 2; i++) sy.add(new Option(i + '년', i));
    sy.value = y;
    gel('qhAdd').style.display = WNN ? '' : 'none';
    gel('qhWnnNote').style.display = WNN ? '' : 'none';
    gel('qhHospNote').style.display = WNN ? 'none' : '';
  })();

  window.qhLoad = function(){
    var y = gel('qhYear').value;
    post('<c:url value="/qps/holidayList.do"/>', { year: y }).then(function(res){
      var list = res.list || [], h = '';
      list.forEach(function(r){
        var d = String(r.holdt || ''); if (d.length !== 8) return;
        var dt = new Date(Number(d.slice(0,4)), Number(d.slice(4,6)) - 1, Number(d.slice(6))), w = dt.getDay();
        h += '<tr><td>' + d.slice(0,4) + '-' + d.slice(4,6) + '-' + d.slice(6) + '</td>' +
             '<td class="dow' + (w === 0 ? ' sun' : (w === 6 ? ' sat' : '')) + '">' + DOW[w] + '</td>' +
             '<td>' + esc(r.holnm) + '</td>' +
             '<td>' + (WNN ? '<button type="button" class="qh-btn del" onclick="qhDel(\'' + d + '\',\'' + esc(r.holnm).replace(/'/g, '&#39;') + '\');">삭제</button>' : '') + '</td></tr>';
      });
      if (!h) h = '<tr><td colspan="4" class="qh-empty">' + esc(y) + '년에 등록된 공휴일이 없습니다.</td></tr>';
      gel('qhBody').innerHTML = h;
      gel('qhCnt').textContent = list.length ? list.length + '일' : '';
      // 추가 칸의 날짜 기본값을 고른 해로
      if (WNN && !gel('qhDt').value) gel('qhDt').value = y + '-01-01';
    }).catch(function(e){
      gel('qhBody').innerHTML = '<tr><td colspan="4" class="qh-empty">' + esc((e && e.message) || '불러오지 못했습니다.') + '</td></tr>';
    });
  };
  window.qhAdd = function(){
    var dt = String(gel('qhDt').value || '').replace(/-/g, ''), nm = String(gel('qhNm').value || '').trim();
    if (!/^\d{8}$/.test(dt)) { _alertBox('날짜를 고르세요.', {icon:'⚠️'}); return; }
    if (!nm) { _alertBox('공휴일 이름을 적어 주세요.', {icon:'⚠️'}); gel('qhNm').focus(); return; }
    post('<c:url value="/qps/holidaySave.do"/>', { holDt: dt, holNm: nm }).then(function(){
      _toast(dt.slice(0,4) + '-' + dt.slice(4,6) + '-' + dt.slice(6) + ' 「' + nm + '」 등록했습니다.', 'ok');
      gel('qhNm').value = '';
      if (gel('qhYear').value !== dt.slice(0,4)) gel('qhYear').value = dt.slice(0,4);   // 다른 해를 넣었으면 그 해로 옮겨 보여 준다
      qhLoad();
    }).catch(err);
  };
  window.qhDel = function(dt, nm){
    _confirmBox({ msg: dt.slice(0,4) + '-' + dt.slice(4,6) + '-' + dt.slice(6) + ' 「' + esc(nm) + '」을 지웁니다.<br>모든 병원의 점검표에서 이 날이 평일로 돌아갑니다.',
      icon:'⚠️', okText:'삭제', okColor:'#b23b3b',
      onOk: function(){ post('<c:url value="/qps/holidayDel.do"/>', { holDt: dt }).then(function(){ _toast('지웠습니다.', 'ok'); qhLoad(); }).catch(err); } });
  };
  $(function(){ qhLoad(); });
})();
</script>
</div><%-- /#qpsHoliday --%>
</div><%-- /.dashboard-wrapper --%>
