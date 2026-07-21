<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%-- evalReportList.jsp — 적정성평가 월간 컨설팅 보고서 '목록' 화면.
     · 앱 표준 그리드(DataTables 2.1.8 + Buttons: 복사/엑셀/출력)로 통일 — header.jsp 전역 로드.
     · 상단 도메인 필터(평가년도=서버조회 / 평가월·병원·상태·첨부=클라 필터) → 결과를 DataTable 에 주입.
     · 검색(자료검색)·정렬·페이징·복사/엑셀/출력은 DataTables 담당. 행 더블클릭 → 해당 병원·월 보고서.
     · 주의: 이 파일 안에서 Deferred EL 표기(샵 + 중괄호) 금지 — 변환에러로 빈 화면(content 타일) 유발 --%>

<div id="evalReportList">
<style>
  /* 글꼴은 앱 기본(body)을 상속 — 다른 화면 그리드와 통일 */
  #evalReportList{ background:#f4f6f8; color:#1f2a30; min-height:100%; padding:14px 16px 50px; font-family:inherit; }
  #evalReportList table.dataTable, #evalReportList .erl-search, #evalReportList select.erl-sel{ font-family:inherit; }
  #evalReportList *{ box-sizing:border-box; }

  /* 헤더 */
  #evalReportList .erl-head{ display:flex; align-items:center; gap:10px; margin-bottom:12px; }
  #evalReportList .erl-title{ font-size:18px; font-weight:800; color:#20303a; display:flex; align-items:center; gap:8px; }
  #evalReportList .erl-title .erl-dot{ width:10px; height:10px; border-radius:50%; background:linear-gradient(135deg,#1f5a4b,#2a7665); }
  #evalReportList .erl-role{ font-size:11px; font-weight:700; color:#fff; background:linear-gradient(135deg,#1f5a4b,#2a7665); padding:3px 9px; border-radius:20px; }

  /* 검색 바 (도메인 필터) */
  #evalReportList .erl-search{ display:flex; flex-wrap:wrap; align-items:center; gap:8px; padding:10px 12px; background:#fff;
    border:1px solid #e2e7ea; border-left:4px solid #2a7665; border-radius:8px; box-shadow:0 2px 6px rgba(16,22,29,.05); margin-bottom:12px; }
  #evalReportList .erl-search label{ font-size:12.5px; font-weight:800; color:#54636c; }
  #evalReportList select.erl-sel{ font-family:inherit; font-size:13px; padding:6px 8px; border:1px solid #d5dbdf; border-radius:6px; background:#fff; color:#1f2a30; font-weight:700; }
  #evalReportList select.erl-sel:hover{ border-color:#2a7665; }
  #evalReportList select.erl-hosp{ min-width:220px; }
  #evalReportList .erl-btn{ font-family:inherit; font-size:13px; font-weight:800; cursor:pointer; padding:7px 14px; border-radius:6px;
    border:1px solid transparent; background:#2a7665; color:#fff; }
  #evalReportList .erl-btn:hover{ background:#1f5a4b; }

  /* 그리드 내 뱃지/셀 */
  #evalReportList .erl-grade{ display:inline-block; font-size:11px; font-weight:800; color:#fff; padding:1px 7px; border-radius:12px; margin-left:3px;
    background:linear-gradient(135deg,#1f5a4b,#2a7665); }
  #evalReportList .erl-hospnm{ font-weight:800; color:#1f5a4b; }
  #evalReportList .erl-total{ font-weight:800; color:#1f7a66; }
  #evalReportList .erl-st{ display:inline-flex; align-items:center; gap:5px; font-size:11.5px; font-weight:800; padding:3px 9px; border-radius:14px; border:1px solid transparent; }
  #evalReportList .erl-st .erl-sd{ width:7px; height:7px; border-radius:50%; }
  #evalReportList .erl-st.erl-draft{ background:#fbf3e2; color:#b7791f; border-color:#ead9b0; }
  #evalReportList .erl-st.erl-draft .erl-sd{ background:#b7791f; }
  #evalReportList .erl-st.erl-appr{ background:#eaf5ec; color:#2e7d32; border-color:#bfe0c4; }
  #evalReportList .erl-st.erl-appr .erl-sd{ background:#2e7d32; }
  #evalReportList .erl-pdf{ font-weight:800; color:#2e7d32; }

  /* DataTables — 표준 스킨. 헤더=연한 회색, 그리드 폰트 살짝 크게 */
  #evalReportList table.dataTable{ font-size:14px; }
  #evalReportList table.dataTable tbody tr{ cursor:pointer; }
  #evalReportList table.dataTable tbody td{ padding-top:4px; padding-bottom:4px; }
  #evalReportList table.dataTable thead th{ padding-top:6px; padding-bottom:6px; }
  /* 헤더색은 앱 표준(addstyle.css: table.dataTable thead th { background:#E9F4F3 })을 그대로 사용 — 오버라이드 안 함 */
  #evalReportList .erl-note{ margin-top:12px; font-size:11.5px; color:#54636c; line-height:1.6; }
  /* DataTables 컨트롤(버튼·자료검색·정보·페이징) 글자 조금 크게 — 신/구 클래스 모두 */
  #evalReportList .dt-buttons .dt-button{ font-weight:700; font-size:14px; padding:6px 14px; }
  #evalReportList .dataTables_filter, #evalReportList div.dt-search,
  #evalReportList .dataTables_filter input, #evalReportList div.dt-search input{ font-size:14px; }
  #evalReportList .dataTables_filter input, #evalReportList div.dt-search input{ padding:5px 8px; }
  #evalReportList .dataTables_info, #evalReportList div.dt-info,
  #evalReportList .dataTables_paginate, #evalReportList div.dt-paging{ font-size:13.5px; }
  #evalReportList .dataTables_paginate .paginate_button, #evalReportList div.dt-paging .dt-paging-button{ font-size:13.5px; }
</style>

  <div class="erl-head">
    <span class="erl-title"><span class="erl-dot"></span>적정성평가 월간보고서 — 목록</span>
    <span class="erl-role" id="erl-role">위너넷</span>
  </div>

  <div class="erl-search">
    <label>평가년도</label>
    <select id="erl-year" class="erl-sel" onchange="erlLoad()"></select>
    <label style="margin-left:6px;">평가월</label>
    <select id="erl-month" class="erl-sel" onchange="erlFilter()"><option value="">전체</option></select>
    <label style="margin-left:6px;">병원</label>
    <select id="erl-hosp" class="erl-sel erl-hosp" onchange="erlFilter()"><option value="">전체 병원</option></select>
    <label style="margin-left:6px;">상태</label>
    <select id="erl-status" class="erl-sel" onchange="erlFilter()">
      <option value="">전체</option>
      <option value="DRAFT">작성중</option>
      <option value="APPROVED">승인됨</option>
    </select>
    <label style="margin-left:6px;">첨부</label>
    <select id="erl-pdf" class="erl-sel" onchange="erlFilter()">
      <option value="">전체</option>
      <option value="Y">있음</option>
      <option value="N">없음</option>
    </select>
    <button class="erl-btn" onclick="erlLoad()">🔍 검색</button>
  </div>

  <table id="erl-grid" class="display nowrap stripe hover cell-border order-column" style="width:100%">
    <thead>
      <tr>
        <th>번호</th><th>기관기호</th><th>병원명</th><th>평가월</th><th>종합점수</th>
        <th>구조</th><th>진료</th><th>목표</th><th>상태</th><th>첨부</th>
        <th>작성자</th><th>승인자</th><th>승인일시</th><th>수정일</th>
      </tr>
    </thead>
  </table>


<script>
jQuery(function(){
  "use strict";
  var ctx = (typeof CommonUtil !== 'undefined' && CommonUtil.getContextPath) ? CommonUtil.getContextPath() : '';
  function cookie(n){ var m=document.cookie.match('(^|;)\\s*'+n+'\\s*=\\s*([^;]+)'); return m?decodeURIComponent(m.pop()):''; }
  function _ck(n){ try{ if(typeof getCookie==='function') return (getCookie(n)||'').trim(); }catch(e){} return cookie(n); }
  function el(id){ return document.getElementById(id); }
  function esc(s){ return String(s==null?'':s).replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;'); }
  function n(v){ var x=Number(v); return isNaN(x)?0:x; }
  function f1(v){ return (Math.round(n(v)*10)/10).toFixed(1); }
  function gradeOf(t){ t=n(t); if(t>=88)return'1등급'; if(t>=79)return'2등급'; if(t>=71)return'3등급'; if(t>=63)return'4등급'; return'5등급'; }
  // 사용자명 디코딩 — escape() 방식(%uXXXX) 한글. unescape 는 %XX·%uXXXX 둘 다 처리(decodeURIComponent 는 %uXXXX 불가).
  function decUser(v){
    if(v==null || v==='') return '';
    var s=String(v);
    try{ if(/%u[0-9a-fA-F]{4}|%[0-9a-fA-F]{2}/.test(s)) return unescape(s); }catch(e){}
    return s;
  }

  var isWinner = (_ck('s_wnn_yn') === 'Y');
  var ownHospCd = (typeof hospid !== 'undefined' && hospid) ? String(hospid).trim() : (_ck('s_hospid') || '');
  var ownHospNm = (typeof hospnm !== 'undefined' && hospnm) ? String(hospnm) : (_ck('s_hospnm') || '');
  if(!isWinner){ var rt=el('erl-role'); if(rt) rt.textContent='거래처'; }

  var _hospPicked = false;
  try{ _hospPicked = (sessionStorage.getItem('hospPicked')==='1'); if(_hospPicked) sessionStorage.removeItem('hospPicked'); }catch(e){}

  var HOSP_NM = {};   // hosp_cd → hosp_nm (응답에 병원명 없을 때 폴백)

  function defaultYear(){
    var qy=(location.search.match(/[?&]year=(\d{4})/)||[])[1]; if(qy) return qy;
    var qm=(location.search.match(/[?&]ym=(\d{6})/)||[])[1]; if(qm) return qm.substring(0,4);
    return String(new Date().getFullYear());
  }

  (function initSel(){
    var y=new Date().getFullYear(), defY=parseInt(defaultYear(),10)||y;
    var minY=Math.min(y-9, defY), maxY=Math.max(y, defY);
    var yh=''; for(var yy=maxY; yy>=minY; yy--){ yh+='<option value="'+yy+'">'+yy+'</option>'; }
    el('erl-year').innerHTML=yh; el('erl-year').value=String(defY);
    var mh='<option value="">전체</option>';
    for(var mo=1;mo<=12;mo++){ var mm=('0'+mo).slice(-2); mh+='<option value="'+mm+'">'+mm+'월</option>'; }
    el('erl-month').innerHTML=mh;
    var qm=(location.search.match(/[?&]ym=(\d{6})/)||[])[1];
    el('erl-month').value = qm ? qm.substring(4,6) : '';
  })();

  // 병원 셀렉트 — 위너넷=전체 목록, 거래처=본인 병원만(고정)
  (function initHosp(){
    var sel=el('erl-hosp');
    if(!isWinner){
      sel.innerHTML='<option value="'+esc(ownHospCd)+'">'+esc(ownHospNm||ownHospCd)+'</option>';
      sel.value=ownHospCd; sel.disabled=true;
      if(ownHospCd) HOSP_NM[ownHospCd]=ownHospNm||ownHospCd;
      return;
    }
    jQuery.ajax({ url:ctx+'/main/select_HospitalMst.do', type:'POST', dataType:'json', data:{ hosp_cd:'' },
      success:function(res){
        var arr=(res&&res.data)||[], html='<option value="">전체 병원</option>';
        arr.forEach(function(h){
          var cd=h.hosp_cd||h.HOSP_CD||'', nm=h.hosp_nm||h.HOSP_NM||cd; if(!cd) return;
          HOSP_NM[cd]=nm; html+='<option value="'+esc(cd)+'">'+esc(nm)+'</option>';
        });
        sel.innerHTML=html;
        if(_hospPicked && ownHospCd){
          var found=false; for(var i=0;i<sel.options.length;i++){ if(sel.options[i].value===ownHospCd){ found=true; break; } }
          if(!found){ HOSP_NM[ownHospCd]=ownHospNm||ownHospCd; var o=document.createElement('option'); o.value=ownHospCd; o.textContent=(ownHospNm||ownHospCd); sel.appendChild(o); }
          sel.value=ownHospCd;
        }
      }
    });
  })();

  function stCell(st){
    if(st==='APPROVED') return '<span class="erl-st erl-appr"><span class="erl-sd"></span>승인됨</span>';
    return '<span class="erl-st erl-draft"><span class="erl-sd"></span>작성중</span>';
  }
  function scoreRender(d,t){ if(t==='display'){ return (d==null||d==='')?'-':f1(d); } return (d==null||d==='')?0:n(d); }

  // ===== DataTable (앱 표준 그리드) =====
  var LAST = [], DT = null;
  function buildGrid(){
    DT = jQuery('#erl-grid').DataTable({
      data: [],
      language: {
        search: "&nbsp;자 료 검 색 : ",
        emptyTable: "조회된 월보고서가 없습니다. (조건을 바꿔 다시 검색하세요)",
        zeroRecords: "일치하는 보고서가 없습니다.",
        info: "현재 _START_ - _END_ / 총 _TOTAL_건",
        infoEmpty: "0건",
        infoFiltered: "( _MAX_건 중 필터 )",
        paginate: { next:"다음", previous:"이전" }
      },
      dom: '<"row"<"col-sm-7"B><"col-sm-5"f>>t<"row mt-2"<"col-sm-6"i><"col-sm-6"p>>',
      lengthChange: false,
      pageLength: 20,
      ordering: true,
      order: [],                          // 서버 정렬 순서 유지(사용자가 헤더 클릭 시 재정렬)
      autoWidth: false,
      buttons: [
        { extend:'copy',       text:'복사.', exportOptions:{ format:{ body:_stripTags } } },
        { extend:'excelHtml5', text:'엑셀.', title:'적정성평가 월간보고서',
          filename:function(){ return '적정성평가_월간보고서_'+(el('erl-year')?el('erl-year').value:''); },
          exportOptions:{ format:{ body:_stripTags } } },
        { extend:'print',      text:'출력.', title:'적정성평가 월간보고서', autoPrint:true,
          exportOptions:{ format:{ body:_stripTags } } }
      ],
      columns: [
        { title:'번호', data:null, orderable:false, className:'dt-center', render:function(d,t,r,meta){ return meta.row+1; } },
        { title:'기관기호', data:'hospcd', className:'dt-center' },
        { title:'병원명', data:'hospnm', render:function(d,t,r){ var nm=d||HOSP_NM[r.hospcd]||r.hospcd||''; return (t==='display')?('<span class="erl-hospnm">'+esc(nm)+'</span>'):esc(nm); } },
        { title:'평가월', data:'evalym', className:'dt-center', render:function(d){ var ym=String(d||''); return ym.length===6?(ym.substring(0,4)+'.'+ym.substring(4,6)):esc(ym); } },
        { title:'종합점수', data:'totalscore', className:'dt-center', render:function(d,t){ if(t==='display'){ return (d==null||d==='')?'-':('<span class="erl-total">'+f1(d)+'</span> <span class="erl-grade">'+gradeOf(d)+'</span>'); } return (d==null||d==='')?0:n(d); } },
        { title:'구조', data:'structscore', className:'dt-center', render:scoreRender },
        { title:'진료', data:'carescore', className:'dt-center', render:scoreRender },
        { title:'목표', data:null, className:'dt-center', render:function(d,t,r){ return (r.goalgrade?esc(r.goalgrade):'')+((r.goalscore!=null&&r.goalscore!=='')?(' ('+f1(r.goalscore)+')'):''); } },
        { title:'상태', data:'status', className:'dt-center', render:function(d,t){ if(t==='display') return stCell(d); return (d==='APPROVED')?'승인됨':'작성중'; } },
        { title:'첨부', data:'haspdf', className:'dt-center', render:function(d,t){ var has=(d==='Y'); if(t==='display') return has?'<span class="erl-pdf">📎 있음</span>':'-'; return has?'있음':'-'; } },
        { title:'작성자', data:'reguser', className:'dt-center', render:function(d){ return esc(decUser(d))||'-'; } },
        { title:'승인자', data:null, className:'dt-center', render:function(d,t,r){ return (r.status==='APPROVED')?(esc(decUser(r.approveuser))||'-'):'-'; } },
        { title:'승인일시', data:null, className:'dt-center', render:function(d,t,r){ return (r.status==='APPROVED')?esc(r.approvedttm||'-'):'-'; } },
        { title:'수정일', data:'upddttm', className:'dt-center', render:function(d){ return esc(d||'')||'-'; } }
      ]
    });
    // 번호 열 — 페이지·정렬에 맞춰 표시순번(1..N)으로 다시 매김
    DT.on('draw.dt', function(){
      var info=DT.page.info();
      DT.column(0,{ order:'applied', page:'current' }).nodes().each(function(cell,i){ cell.innerHTML = info.start + i + 1; });
    });
    // 행 더블클릭 → 해당 병원·월 보고서로 이동
    jQuery('#erl-grid tbody').on('dblclick','tr', function(){
      var d=DT.row(this).data(); if(d) goReport(d.hospcd, d.hospnm||HOSP_NM[d.hospcd]||d.hospcd, d.evalym, false);
    });
  }
  function _stripTags(data){
    if(data==null) return '';
    if(typeof data!=='string') return data;
    return data.indexOf('<')!==-1 ? data.replace(/<[^>]*>/g,'').trim() : data;
  }

  // 로드된 목록(LAST=그 해 전체)에서 병원·월·상태·첨부로 필터 → 그리드 주입(자료검색·정렬·페이징은 DataTables)
  window.erlFilter = function(){
    if(!DT) return;
    var mo=el('erl-month')?el('erl-month').value:'', hosp=el('erl-hosp')?el('erl-hosp').value:'',
        stt=el('erl-status')?el('erl-status').value:'', pf=el('erl-pdf')?el('erl-pdf').value:'';
    var rows=LAST.filter(function(r){
      if(hosp && String(r.hospcd||'')!==hosp) return false;
      if(mo){ var ym=String(r.evalym||''); if(ym.substring(4,6)!==mo) return false; }
      if(stt){ var s=(r.status==='APPROVED')?'APPROVED':'DRAFT'; if(s!==stt) return false; }
      if(pf){ var has=(r.haspdf==='Y')?'Y':'N'; if(has!==pf) return false; }
      return true;
    });
    DT.clear(); DT.rows.add(rows); DT.draw();
  };

  window.erlLoad = function(){
    var yr = el('erl-year').value;
    var hosp = isWinner ? '' : (ownHospCd||'');   // 위너넷=전체 로드(클라 필터), 거래처=본인(서버도 강제)
    jQuery.ajax({ url:ctx+'/main/listEvalReport.do', type:'POST', dataType:'json', data:{ evalYear:yr, hospCd:hosp },
      success:function(res){
        LAST = (res && res.result==='OK') ? (res.list||[]) : [];
        erlFilter();
      },
      error:function(){ LAST=[]; erlFilter(); }
    });
  };

  function reportUrl(hospCd, hospNm, ym, autoprint){
    return ctx + '/main/evalReport.do?hospCd=' + encodeURIComponent(hospCd)
         + '&hospNm=' + encodeURIComponent(hospNm||'')
         + '&ym=' + encodeURIComponent(ym) + '&ret=list' + (autoprint ? '&autoprint=1' : '');
  }
  function goReport(hospCd, hospNm, ym, autoprint){
    if(!hospCd) return;
    try{
      sessionStorage.setItem('erOpenHospCd', hospCd);
      sessionStorage.setItem('erOpenHospNm', hospNm||'');
      sessionStorage.setItem('erOpenYm', ym||'');
      sessionStorage.setItem('erOpenAutoprint', autoprint ? '1' : '');
      sessionStorage.setItem('erFromList', '1');
      sessionStorage.setItem('erFromListYear', el('erl-year').value);
    }catch(e){}
    location.href = reportUrl(hospCd, hospNm, ym, autoprint);
  }
  window.erlOpen = function(hospCd, hospNm, ym){ goReport(hospCd, hospNm, ym, false); };

  // 레이아웃 보정 — 좌측 사이드바(fixed/absolute)가 콘텐츠를 덮을 때 그만큼 우측으로 민다.
  function erlFixLayout(){
    var root=el('evalReportList'); if(!root) return;
    var sb=document.querySelector('.nav-left-sidebar'), left=0;
    if(sb){ var pos=''; try{ pos=getComputedStyle(sb).position; }catch(e){}
      if(pos==='fixed'||pos==='absolute'){ var r=sb.getBoundingClientRect(); if(r.width>0 && r.left<=1) left=Math.round(r.right); } }
    root.style.paddingLeft=(left ? (left+16) : 16)+'px';
    if(DT){ try{ DT.columns.adjust(); }catch(e){} }
  }
  window.addEventListener('resize', erlFixLayout);

  // 초기화 — 그리드 생성 후 조회
  buildGrid();
  erlLoad();
  erlFixLayout(); setTimeout(erlFixLayout,200); setTimeout(erlFixLayout,600);
});
</script>
</div>
