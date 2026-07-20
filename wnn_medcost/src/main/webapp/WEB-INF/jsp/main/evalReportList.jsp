<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%-- evalReportList.jsp — 적정성평가 월간 컨설팅 보고서 '목록' 화면.
     · 진입: evalReport.jsp 툴바 [📋 월보고 목록] → location.href=main/evalReportList.do?ym=YYYYMM (사이드바 우측 콘텐츠, 향후 메뉴로도 편입)
     · 조회조건: 평가년월 + 병원(위너넷=전체 검색, 거래처=본인 병원만) → /main/listEvalReport.do
     · 행 [열기] → evalReport.do?hospCd=&hospNm=&ym=  (해당 병원·월 보고서 열람/인쇄)
                [인쇄] → 위 URL + &autoprint=1 (조회·렌더 후 인쇄 대화상자 자동)
     · 모든 스타일/클래스는 #evalReportList 하위로 스코프(erl- 접두)해 앱 화면과 충돌 방지
     · 주의: 이 파일 안에서 Deferred EL 표기(샵 + 중괄호) 금지 — 변환에러로 빈 화면(content 타일) 유발 --%>

<div id="evalReportList">
<style>
  #evalReportList{
    /* 청록(teal) 그리드 테마 — 앱 표준 teal(#2a7665, list-group-item-info)에 맞춤. navy 변수명은 유지하되 값만 teal 로 교체 */
    --erl-bg:#eef2f2; --erl-ink:#1a2a26; --erl-soft:#4a5b57; --erl-line:#e3e7e6; --erl-line2:#eef2f0;
    --erl-navy:#1f5a4b; --erl-navy2:#2a7665; --erl-navytint:#eef7f4; --erl-paper:#fff;
    --erl-bad:#c0392b; --erl-good:#2e7d32; --erl-goodtint:#eaf5ec; --erl-amber:#b7791f; --erl-ambertint:#fbf3e2;
    background:var(--erl-bg); color:var(--erl-ink); min-height:100%; padding:16px 18px 60px;
    font-family:"Malgun Gothic","Apple SD Gothic Neo","Noto Sans KR","Segoe UI",sans-serif;
  }
  #evalReportList *{ box-sizing:border-box; }
  #evalReportList .erl-num{ font-variant-numeric:tabular-nums; }

  /* 헤더 */
  #evalReportList .erl-head{ display:flex; align-items:center; gap:10px; margin-bottom:14px; }
  #evalReportList .erl-title{ font-size:18px; font-weight:800; color:var(--erl-ink); display:flex; align-items:center; gap:8px; }
  #evalReportList .erl-title .erl-dot{ width:10px; height:10px; border-radius:50%; background:linear-gradient(135deg,var(--erl-navy),var(--erl-navy2)); }
  #evalReportList .erl-role{ font-size:11px; font-weight:700; color:#fff; background:linear-gradient(135deg,var(--erl-navy),var(--erl-navy2)); padding:3px 9px; border-radius:20px; }

  /* 검색 바 */
  #evalReportList .erl-search{ display:flex; flex-wrap:wrap; align-items:center; gap:8px; padding:12px 14px; background:#fff;
    border:1px solid var(--erl-line); border-left:4px solid var(--erl-navy2); border-radius:10px; box-shadow:0 3px 10px rgba(16,22,29,.06); margin-bottom:14px; }
  #evalReportList .erl-search label{ font-size:12.5px; font-weight:800; color:var(--erl-soft); margin-right:2px; }
  #evalReportList select.erl-sel, #evalReportList input.erl-inp{ font-family:inherit; font-size:13px; padding:6px 8px;
    border:1px solid var(--erl-line); border-radius:7px; background:#fff; color:var(--erl-ink); font-weight:700; }
  #evalReportList select.erl-sel:hover{ border-color:var(--erl-navy2); }
  #evalReportList select.erl-hosp{ min-width:220px; }
  #evalReportList .erl-btn{ font-family:inherit; font-size:13px; font-weight:800; cursor:pointer; padding:7px 14px; border-radius:7px;
    border:1px solid var(--erl-line); background:#fff; color:var(--erl-soft); transition:.15s; display:inline-flex; align-items:center; gap:5px; white-space:nowrap; }
  #evalReportList .erl-btn:hover{ background:var(--erl-line2); border-color:var(--erl-navy2); color:var(--erl-navy); }
  #evalReportList .erl-btn.erl-primary{ background:var(--erl-navy2); color:#fff; border-color:transparent; }
  #evalReportList .erl-btn.erl-primary:hover{ background:var(--erl-navy); color:#fff; }
  #evalReportList .erl-btn.erl-sm{ padding:5px 10px; font-size:12px; }
  #evalReportList .erl-btn.erl-open{ background:var(--erl-navy2); color:#fff; border-color:transparent; }
  #evalReportList .erl-btn.erl-open:hover{ background:var(--erl-navy); }
  #evalReportList .erl-sp{ flex:1 1 auto; }
  #evalReportList .erl-count{ font-size:12.5px; font-weight:700; color:var(--erl-soft); }
  #evalReportList .erl-count b{ color:var(--erl-navy); }

  /* 표 */
  #evalReportList .erl-tw{ overflow-x:auto; border-radius:10px; border:1px solid var(--erl-line); background:#fff; box-shadow:0 3px 10px rgba(16,22,29,.05); }
  #evalReportList table.erl-tbl{ width:100%; border-collapse:collapse; font-size:12.5px; min-width:920px; }
  #evalReportList table.erl-tbl th, #evalReportList table.erl-tbl td{ padding:9px 10px; border-bottom:1px solid var(--erl-line); text-align:center; white-space:nowrap; }
  #evalReportList table.erl-tbl thead th{ background:var(--erl-navy2); color:#fff; font-weight:700; position:sticky; top:0;
    border-top:3px solid #17493c; border-right:1px solid rgba(255,255,255,.18); }
  #evalReportList table.erl-tbl thead th:last-child{ border-right:none; }
  #evalReportList table.erl-tbl td.erl-l{ text-align:left; }
  #evalReportList table.erl-tbl tbody tr{ cursor:pointer; }
  #evalReportList table.erl-tbl tbody tr:hover{ background:var(--erl-navytint); }
  #evalReportList .erl-hospnm{ font-weight:800; color:var(--erl-navy); }
  #evalReportList .erl-code{ font-size:12.5px; font-weight:700; color:var(--erl-ink); }   /* 기관기호 — 병원명과 같은 크기 */
  #evalReportList .erl-total{ font-size:14px; font-weight:800; color:#1f7a66; }
  #evalReportList .erl-grade{ display:inline-block; font-size:11px; font-weight:800; color:#fff; padding:1px 7px; border-radius:12px; margin-left:4px;
    background:linear-gradient(135deg,var(--erl-navy),var(--erl-navy2)); }
  #evalReportList .erl-st{ display:inline-flex; align-items:center; gap:5px; font-size:11.5px; font-weight:800; padding:3px 9px; border-radius:16px; border:1px solid transparent; }
  #evalReportList .erl-st .erl-sd{ width:7px; height:7px; border-radius:50%; }
  #evalReportList .erl-st.erl-draft{ background:var(--erl-ambertint); color:var(--erl-amber); border-color:#ead9b0; }
  #evalReportList .erl-st.erl-draft .erl-sd{ background:var(--erl-amber); }
  #evalReportList .erl-st.erl-appr{ background:var(--erl-goodtint); color:var(--erl-good); border-color:#bfe0c4; }
  #evalReportList .erl-st.erl-appr .erl-sd{ background:var(--erl-good); }
  #evalReportList .erl-pdf{ font-size:12px; font-weight:800; color:var(--erl-good); }
  #evalReportList .erl-pdf.erl-no{ color:#b7c0cd; font-weight:600; }
  #evalReportList .erl-acts{ display:inline-flex; gap:6px; }
  #evalReportList .erl-empty{ padding:44px 20px; text-align:center; color:var(--erl-soft); font-size:13.5px; font-weight:700; }
  #evalReportList .erl-empty .erl-em-sub{ font-size:12px; font-weight:600; color:#8a97a8; margin-top:6px; }
  #evalReportList .erl-note{ margin-top:12px; font-size:11.5px; color:var(--erl-soft); line-height:1.6; }
</style>

  <div class="erl-head">
    <span class="erl-title"><span class="erl-dot"></span>적정성평가 월간보고서 — 목록</span>
    <span class="erl-role" id="erl-role">위너넷</span>
  </div>

  <div class="erl-search">
    <label>평가년도</label>
    <select id="erl-year" class="erl-sel" onchange="erlLoad()"></select>
    <label style="margin-left:8px;">병원</label>
    <!-- 병원 선택 즉시 그 병원만 조회, '전체 병원' 선택 시 전체 (관리자). 거래처는 본인 병원 고정(disabled) -->
    <select id="erl-hosp" class="erl-sel erl-hosp" onchange="erlLoad()"><option value="">전체 병원</option></select>
    <button class="erl-btn erl-primary" onclick="erlLoad()">🔍 검색</button>
    <!-- 위너넷 전용: 조회된 목록에서 병원코드·병원명으로 즉시 필터(전체 병원 조회 시 병원 찾기용). 거래처는 숨김 -->
    <span id="erl-kwbox"><input id="erl-kw" type="text" class="erl-inp" placeholder="병원코드·병원명 검색" onkeyup="erlFilter()" style="width:180px;"><button class="erl-btn erl-sm" onclick="document.getElementById('erl-kw').value='';erlFilter();" title="검색어 지우기" style="margin-left:4px;">✕</button></span>
    <span class="erl-sp"></span>
    <span class="erl-count" id="erl-count"></span>
  </div>

  <div class="erl-tw">
    <table class="erl-tbl">
      <thead>
        <tr>
          <th style="width:44px;">번호</th>
          <th style="width:100px;">기관기호</th>
          <th class="erl-l">병원명</th>
          <th style="width:78px;">평가월</th>
          <th style="width:120px;">종합점수</th>
          <th style="width:70px;">구조</th>
          <th style="width:70px;">진료</th>
          <th style="width:96px;">목표</th>
          <th style="width:100px;">상태</th>
          <th style="width:56px;">첨부</th>
          <th style="width:84px;">작성자</th>
          <th style="width:84px;">승인자</th>
          <th style="width:120px;">승인일시</th>
          <th style="width:120px;">수정일</th>
        </tr>
      </thead>
      <tbody id="erl-body">
        <tr><td colspan="14" class="erl-empty">검색 버튼을 눌러 목록을 조회하세요.</td></tr>
      </tbody>
    </table>
  </div>

  <div class="erl-note">
    ※ 저장/승인된 보고서만 표시됩니다. 조회조건은 <b>평가년도</b>이며 그 해의 <b>모든 월</b>이 표시됩니다(월 무관). <b>행을 더블클릭</b>하면 해당 병원·월의 보고서로 이동하고, 인쇄는 보고서 화면의 <b>[인쇄]</b> 버튼으로 하세요.
  </div>

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
  // 사용자명 디코딩 — 쿠키/DB에 escape() 방식(%uXXXX)으로 저장된 한글(예: %uB9C8%uC2A4%uD130 → 마스터).
  //   unescape 는 %XX·%uXXXX 둘 다 처리(decodeURIComponent 는 %uXXXX 불가). 인코딩 흔적 없으면 원값 유지.
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

  // 병원검색으로 방금 병원을 선택하고 넘어왔는지(top.jsp 표식) — 1회 소비. true 면 콤보를 접속 병원으로 세팅.
  var _hospPicked = false;
  try{ _hospPicked = (sessionStorage.getItem('hospPicked')==='1'); if(_hospPicked) sessionStorage.removeItem('hospPicked'); }catch(e){}

  // 병원명 캐시(hosp_cd → hosp_nm) — 목록 응답에 병원명이 없을 때 폴백
  var HOSP_NM = {};

  // 기본 년도 — ?year=YYYY 우선, 없으면 ?ym=YYYYMM 의 년도, 없으면 올해. (조회조건은 '년도만' — 월 무관하게 그 해 전월 표시)
  function defaultYear(){
    var qy=(location.search.match(/[?&]year=(\d{4})/)||[])[1];
    if(qy) return qy;
    var qm=(location.search.match(/[?&]ym=(\d{6})/)||[])[1];
    if(qm) return qm.substring(0,4);
    return String(new Date().getFullYear());
  }

  (function initSel(){
    var y=new Date().getFullYear(), defY=parseInt(defaultYear(),10)||y;
    var minY=Math.min(y-9, defY), maxY=Math.max(y, defY);
    var yh=''; for(var yy=maxY; yy>=minY; yy--){ yh+='<option value="'+yy+'">'+yy+'</option>'; }
    el('erl-year').innerHTML=yh;
    el('erl-year').value=String(defY);
  })();

  // 병원 셀렉트 — 위너넷=전체 목록(select_HospitalMst.do), 거래처=본인 병원만(고정)
  (function initHosp(){
    var sel=el('erl-hosp');
    if(!isWinner){
      sel.innerHTML='<option value="'+esc(ownHospCd)+'">'+esc(ownHospNm||ownHospCd)+'</option>';
      sel.value=ownHospCd; sel.disabled=true;
      if(ownHospCd) HOSP_NM[ownHospCd]=ownHospNm||ownHospCd;
      var kb=el('erl-kwbox'); if(kb) kb.style.display='none';   // 거래처는 병원 검색 불필요(본인 병원만)
      return;   // 초기 조회는 하단 tail 에서(erlLoad 정의 이후)
    }
    jQuery.ajax({ url:ctx+'/main/select_HospitalMst.do', type:'POST', dataType:'json', data:{ hosp_cd:'' },
      success:function(res){
        var arr=(res&&res.data)||[], html='<option value="">전체 병원</option>';
        arr.forEach(function(h){
          var cd=h.hosp_cd||h.HOSP_CD||'', nm=h.hosp_nm||h.HOSP_NM||cd;
          if(!cd) return;
          HOSP_NM[cd]=nm;
          html+='<option value="'+esc(cd)+'">'+esc(nm)+'</option>';
        });
        sel.innerHTML=html;   // 관리자 기본 = '전체 병원'(value=''). 병원을 고르면 onchange 로 그 병원만 조회.
        // 단, 병원검색으로 방금 병원을 선택하고 넘어온 경우엔 콤보를 그 접속 병원으로 세팅 → 그 병원만 조회.
        if(_hospPicked && ownHospCd){
          var found=false;
          for(var i=0;i<sel.options.length;i++){ if(sel.options[i].value===ownHospCd){ found=true; break; } }
          if(!found){
            HOSP_NM[ownHospCd]=ownHospNm||ownHospCd;
            var o=document.createElement('option'); o.value=ownHospCd; o.textContent=(ownHospNm||ownHospCd); sel.appendChild(o);
          }
          sel.value=ownHospCd;
          erlLoad();   // 접속 병원 기준 조회 (tail 조회는 이 경우 건너뜀 — 레이스 방지)
        }
      }
    });
  })();

  function stCell(st){
    if(st==='APPROVED') return '<span class="erl-st erl-appr"><span class="erl-sd"></span>승인됨</span>';
    return '<span class="erl-st erl-draft"><span class="erl-sd"></span>작성중</span>';
  }

  function render(list){
    var tb=el('erl-body');
    if(!list || !list.length){
      tb.innerHTML='<tr><td colspan="14" class="erl-empty">조회된 월보고서가 없습니다.'
                 +'<div class="erl-em-sub">선택한 년월에 저장/승인된 보고서가 없습니다. 년월·병원 조건을 바꿔 다시 검색하세요.</div></td></tr>';
      el('erl-count').innerHTML='';
      return;
    }
    var html='';
    list.forEach(function(r,i){
      var cd=r.hospcd||'', nm=r.hospnm||HOSP_NM[cd]||cd, ym=String(r.evalym||'');
      var ymTxt = ym.length===6 ? (ym.substring(0,4)+'.'+ym.substring(4,6)) : esc(ym);
      var total=r.totalscore, tg = (total==null||total==='') ? '-' : (f1(total)+'<span class="erl-grade">'+gradeOf(total)+'</span>');
      var struct=(r.structscore==null||r.structscore==='')?'-':f1(r.structscore);
      var care=(r.carescore==null||r.carescore==='')?'-':f1(r.carescore);
      var goal=(r.goalgrade? esc(r.goalgrade):'')+((r.goalscore!=null&&r.goalscore!=='')?(' ('+f1(r.goalscore)+')'):'');
      var pdf = (r.haspdf==='Y') ? '<span class="erl-pdf">📎 있음</span>' : '<span class="erl-pdf erl-no">-</span>';
      var reg = esc(decUser(r.reguser)) || '-';
      var appUser = esc(decUser(r.approveuser));
      var appDt = esc(r.approvedttm||'');
      var appUserTd = (r.status==='APPROVED' && appUser) ? appUser : '-';
      var appDtTd = (r.status==='APPROVED' && appDt) ? appDt : '-';
      var upd = esc(r.upddttm||'')||'-';
      var arg = "'"+esc(cd).replace(/'/g,"") +"','"+ esc(nm).replace(/'/g,"") +"','"+ esc(ym) +"'";
      html += '<tr ondblclick="erlOpen('+arg+')" title="더블클릭하면 보고서로 이동합니다">'
            +   '<td class="erl-num">'+(i+1)+'</td>'
            +   '<td><span class="erl-code">'+esc(cd)+'</span></td>'
            +   '<td class="erl-l"><span class="erl-hospnm">'+esc(nm)+'</span></td>'
            +   '<td>'+ymTxt+'</td>'
            +   '<td class="erl-total erl-num">'+tg+'</td>'
            +   '<td class="erl-num">'+struct+'</td>'
            +   '<td class="erl-num">'+care+'</td>'
            +   '<td>'+ (goal||'-') +'</td>'
            +   '<td>'+stCell(r.status)+'</td>'
            +   '<td>'+pdf+'</td>'
            +   '<td>'+reg+'</td>'
            +   '<td>'+appUserTd+'</td>'
            +   '<td class="erl-num" style="font-size:11.5px;color:var(--erl-soft);">'+appDtTd+'</td>'
            +   '<td class="erl-num" style="font-size:11.5px;color:var(--erl-soft);">'+upd+'</td>'
            + '</tr>';
    });
    tb.innerHTML=html;
    var kw=(el('erl-kw')&&el('erl-kw').value)?el('erl-kw').value.trim():'';
    el('erl-count').innerHTML = kw
      ? ('검색 <b>'+list.length+'</b> / 전체 '+LAST.length+'건')
      : ('총 <b>'+list.length+'</b>건');
  }

  // 조회된 목록(LAST)에서 병원코드·병원명으로 즉시 필터(위너넷 전체병원 조회 시 병원 찾기). 서버 재조회 없음.
  var LAST = [];
  window.erlFilter = function(){
    var kw=(el('erl-kw')?el('erl-kw').value:'').trim().toLowerCase();
    if(!kw){ render(LAST); return; }
    render(LAST.filter(function(r){
      var cd=String(r.hospcd||'').toLowerCase();
      var nm=String(r.hospnm||HOSP_NM[r.hospcd]||'').toLowerCase();
      return cd.indexOf(kw)>=0 || nm.indexOf(kw)>=0;
    }));
  };

  window.erlLoad = function(){
    var yr = el('erl-year').value;              // 조회조건 = 년도만(월 무관, 그 해 전체 월 표시)
    var hosp = el('erl-hosp').value || '';
    el('erl-body').innerHTML='<tr><td colspan="14" class="erl-empty">조회 중…</td></tr>';
    jQuery.ajax({ url:ctx+'/main/listEvalReport.do', type:'POST', dataType:'json', data:{ evalYear:yr, hospCd:hosp },
      success:function(res){
        if(res && res.result==='OK'){ LAST = res.list||[]; erlFilter(); }   // 로드분 보관 후 현재 검색어로 필터 적용
        else { LAST=[]; el('erl-body').innerHTML='<tr><td colspan="14" class="erl-empty">조회 실패: '+esc((res&&res.message)||'')+'</td></tr>'; }
      },
      error:function(){ LAST=[]; el('erl-body').innerHTML='<tr><td colspan="14" class="erl-empty">조회 중 오류가 발생했습니다.</td></tr>'; }
    });
  };

  // 보고서로 이동 — URL 파라미터(hospCd/hospNm/ym)가 evalReport.jsp 에서 쿠키보다 우선 적용됨.
  //   ret=list : 보고서 화면 [종료] 시 이 목록으로 되돌아오게 하는 표식(evalReport.erExit 에서 사용)
  function reportUrl(hospCd, hospNm, ym, autoprint){
    return ctx + '/main/evalReport.do?hospCd=' + encodeURIComponent(hospCd)
         + '&hospNm=' + encodeURIComponent(hospNm||'')
         + '&ym=' + encodeURIComponent(ym)
         + '&ret=list'
         + (autoprint ? '&autoprint=1' : '');
  }
  // 보고서로 이동 — hospCd/hospNm/ym/autoprint 와 '목록에서 진입' 표식을 sessionStorage 로 넘김.
  //   (main.jsp URL 숨김이 쿼리스트링을 지우므로 URL 만으로는 전달 불가 → sessionStorage 사용. URL 파라미터는 폴백)
  function goReport(hospCd, hospNm, ym, autoprint){
    if(!hospCd) return;
    try{
      sessionStorage.setItem('erOpenHospCd', hospCd);
      sessionStorage.setItem('erOpenHospNm', hospNm||'');
      sessionStorage.setItem('erOpenYm', ym||'');
      sessionStorage.setItem('erOpenAutoprint', autoprint ? '1' : '');
      sessionStorage.setItem('erFromList', '1');
      sessionStorage.setItem('erFromListYear', el('erl-year').value);   // 종료 시 이 년도로 목록 복귀
    }catch(e){}
    location.href = reportUrl(hospCd, hospNm, ym, autoprint);
  }
  window.erlOpen  = function(hospCd, hospNm, ym){ goReport(hospCd, hospNm, ym, false); };
  // (목록 인쇄 버튼 제거 — 보고서로 들어가 그 화면의 [인쇄] 버튼으로 인쇄)

  // 레이아웃 보정 — 좌측 사이드바(.nav-left-sidebar)가 fixed/absolute 오버레이라 콘텐츠가 그 아래로 깔림.
  //   evalReport 툴바(erFixToolbar)와 동일 기준으로 사이드바 오른쪽만큼 목록을 우측으로 민다(사이드바 폭 변동·접힘에도 안전).
  //   사이드바가 in-flow(static/relative)면 이미 밀려 있으므로 보정 안 함(이중 여백 방지).
  function erlFixLayout(){
    var root=document.getElementById('evalReportList'); if(!root) return;
    var sb=document.querySelector('.nav-left-sidebar'), left=0;
    if(sb){
      var pos=''; try{ pos=getComputedStyle(sb).position; }catch(e){}
      if(pos==='fixed' || pos==='absolute'){
        var r=sb.getBoundingClientRect();
        if(r.width>0 && r.left<=1) left=Math.round(r.right);
      }
    }
    root.style.paddingLeft=(left ? (left+18) : 18)+'px';
  }
  window.addEventListener('resize', erlFixLayout);
  erlFixLayout();
  setTimeout(erlFixLayout, 200);    // 사이드바가 비동기로 렌더된 뒤 재보정
  setTimeout(erlFixLayout, 600);

  // 진입 시 자동 조회 — 관리자=전체 병원(콤보 기본 value=''), 거래처=본인 병원. 병원 선택은 onchange 로 즉시 반영.
  //   단, 위너넷이 병원검색으로 방금 병원을 골라 넘어온 경우엔 initHosp 성공 콜백에서 조회하므로 여기선 건너뜀(레이스 방지).
  if(!(isWinner && _hospPicked)) erlLoad();
});
</script>
</div>
