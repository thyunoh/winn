<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%-- qpsInfPat.jsp — 감염병환자 월별 리스트 (2026-08-10)
     원본: 병원+년월 1부. 표(입원일·확인일·질환유형·환자·원내발생·조치결과) + 하단 발생자 통계 3칸.
     ★환자 칸은 [찾기]로 위너넷 입원환자(TBL_IPWON_INFO)에서 고른다 — QPS 는 환자를 따로 등록하지 않는다.
       주민번호는 받지 않는다. 성별·연령은 검색 결과로 온 값만 채운다(낙상 화면과 같은 원칙).
     ★주의: 이 파일 안에서 Deferred EL 표기(샵+중괄호) 금지 --%>

<script src="/asset/js/ui-message.js"></script>
<%@ include file="/WEB-INF/jsp/main/inc/qpsFileBox.jsp" %>

<div class="dashboard-wrapper">
<div id="qpsInfPat" data-wnn="<c:out value='${wnnYn}'/>">
<style>
  #qpsInfPat{ background:#f4f6f8; color:#1f2a30; min-height:100%; padding:14px 16px 60px; max-width:100%; overflow-x:hidden; }
  #qpsInfPat *{ box-sizing:border-box; }
  #qpsInfPat .ip-head{ display:flex; align-items:center; gap:10px; margin-bottom:12px; flex-wrap:wrap; }
  #qpsInfPat .ip-title{ font-size:18px; font-weight:800; color:#20303a; display:flex; align-items:center; gap:8px; }
  #qpsInfPat .ip-dot{ width:10px; height:10px; border-radius:50%; background:linear-gradient(135deg,#1f5a4b,#2a7665); }
  #qpsInfPat .ip-sub{ font-size:12px; color:#6b7c86; }
  #qpsInfPat .ip-hosp{ background:#e7f3ee; color:#1f5a4b; font-size:12px; font-weight:800;
      border:1px solid #cfe3da; border-radius:14px; padding:3px 11px; }
  #qpsInfPat .ip-spacer{ flex:1; }
  #qpsInfPat select, #qpsInfPat input{ border:1px solid #cfd8e0; border-radius:6px; padding:5px 8px;
      font-family:inherit; font-size:12.5px; background:#fff; }
  #qpsInfPat .ip-btn{ border:1px solid #1f5a4b; background:#1f5a4b; color:#fff; border-radius:6px;
      padding:6px 14px; font-size:13px; font-weight:600; cursor:pointer; white-space:nowrap; }
  #qpsInfPat .ip-btn.ghost{ background:#fff; color:#1f5a4b; }
  #qpsInfPat .ip-btn.mini{ padding:2px 9px; font-size:11.5px; border-color:#cfd8e0; color:#556570; background:#fff; }
  #qpsInfPat .ip-card{ background:#fff; border:1px solid #e3e9ed; border-radius:10px; padding:14px 16px; margin-bottom:12px; }
  #qpsInfPat .ip-card h4{ margin:0 0 10px; font-size:14px; font-weight:800; color:#1f5a4b; }
  #qpsInfPat .ip-card h4 .hint{ font-weight:500; font-size:12px; color:#8a99a3; }
  #qpsInfPat table.ed{ width:100%; border-collapse:collapse; font-size:12.5px; }
  #qpsInfPat table.ed th{ background:#f2f6f8; border:1px solid #dde5ea; padding:5px 6px; font-weight:700; color:#43555f; }
  #qpsInfPat table.ed td{ border:1px solid #e6ecef; padding:3px; }
  #qpsInfPat table.ed input{ width:100%; border:none; background:transparent; padding:4px 5px; }
  #qpsInfPat table.ed select{ width:100%; border:none; background:transparent; padding:3px; font-size:12px; }
  #qpsInfPat .rowdel{ color:#b23b3b; cursor:pointer; font-weight:700; text-align:center; width:26px; }
  #qpsInfPat .stat{ display:grid; grid-template-columns:120px 1fr 120px 1fr; gap:8px 10px; align-items:center; }
  #qpsInfPat .stat .lb{ font-size:12.5px; font-weight:700; color:#43555f; }
</style>

<div class="ip-head">
  <div class="ip-title"><span class="ip-dot"></span>감염병환자 월별 리스트</div>
  <span class="ip-hosp">🏥 <c:out value="${hospNm}" default="병원 미확인"/></span>
  <div class="ip-spacer"></div>
  <input type="month" id="ipYm" style="width:auto;" onchange="ipLoad();">
  <button type="button" class="ip-btn" onclick="ipSave();">저장</button>
  <button type="button" class="ip-btn ghost" onclick="ipAdd();">＋ 행 추가</button>
  <span class="ip-sub" id="ipStat"></span>
  <span style="flex:0 0 96px;"></span>
</div>

<div class="ip-card">
  <div style="overflow-x:auto;">
  <table class="ed" style="min-width:1080px;"><thead><tr>
    <th style="width:44px;">no</th><th style="width:120px;">입원일</th><th style="width:120px;">확인일</th>
    <th style="min-width:180px;">감염성질환 유형</th>
    <%-- 등록번호는 10자리 + [찾기] 버튼이 한 칸에 들어간다. 좁으면 번호가 잘린다(2026-08-10 지적) --%>
    <th style="width:170px;">등록번호</th><th style="width:90px;">이름</th>
    <th style="width:56px;">성별</th><th style="width:56px;">연령</th>
    <th style="width:96px;">원내발생</th><th style="min-width:200px;">조치결과</th><th style="width:26px;"></th>
  </tr></thead><tbody id="ipBody"></tbody></table>
  </div>
  <button type="button" class="ip-btn mini" style="margin-top:6px;" onclick="ipAdd();">＋ 행 추가</button>
  <span class="ip-sub" style="margin-left:8px;">환자 칸은 [찾기]로 입원환자에서 고릅니다.</span>
</div>

<div class="ip-card">
  <h4>발생자 통계</h4>
  <div class="stat">
    <div class="lb">혈액매개주의</div> <div><input type="text" id="s_blood" maxlength="200" style="width:100%;"></div>
    <div class="lb">다제내성균</div>   <div><input type="text" id="s_mdro" maxlength="200" style="width:100%;"></div>
    <div class="lb">결핵</div>         <div><input type="text" id="s_tb" maxlength="200" style="width:100%;"></div>
    <div></div><div></div>
  </div>
</div>

<div class="ip-card">
  <h4>첨부파일 <span class="hint">— 근거자료</span></h4>
  <div id="ipFileBox"></div>
</div>

<script>
(function(){
  var rowIdx = 0;
  var fileBox = window.qpsFileBox({ mount:'ipFileBox', refGb:'INFPAT',
      hint:'근거자료', needSaveMsg:'년월을 선택하면 첨부할 수 있습니다.' });

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
  function ym(){ return document.getElementById('ipYm').value.replace('-',''); }
  function fmtDt(d){ return (d && d.length === 8) ? (d.substr(0,4)+'-'+d.substr(4,2)+'-'+d.substr(6,2)) : (d || ''); }

  (function(){
    var d = new Date();
    document.getElementById('ipYm').value = d.getFullYear()+'-'+('0'+(d.getMonth()+1)).slice(-2);
  })();

  function addRow(r){
    r = r || {};
    var id = ++rowIdx;
    var tr = document.createElement('tr');
    tr.innerHTML =
      '<td class="rowdel" style="color:#8a99a3; font-weight:600;">' + id + '</td>' +
      '<td><input type="date" data-f="indt" value="' + esc(r.indt) + '"></td>' +
      '<td><input type="date" data-f="chkdt" value="' + esc(r.chkdt) + '"></td>' +
      '<td><input type="text" data-f="disease" value="' + esc(r.disease) + '"></td>' +
      '<td style="display:flex; gap:3px; align-items:center;">' +
        '<input type="text" data-f="patno" value="' + esc(r.patno) + '" style="flex:1;">' +
        '<button type="button" class="ip-btn mini" onclick="ipFind(this);">찾기</button></td>' +
      '<td><input type="text" data-f="patnm" value="' + esc(r.patnm) + '"></td>' +
      '<td><input type="text" data-f="sexnm" value="' + esc(r.sexnm) + '"></td>' +
      '<td><input type="text" data-f="ageval" value="' + esc(r.ageval) + '"></td>' +
      '<td><select data-f="inhosp">' +
        ['','예','아니오'].map(function(v){
          return '<option value="'+v+'"'+(String(r.inhosp||'')===v?' selected':'')+'>'+(v||'-')+'</option>'; }).join('') +
        '</select></td>' +
      '<td><input type="text" data-f="acttxt" value="' + esc(r.acttxt) + '"></td>' +
      '<td class="rowdel" onclick="this.closest(\'tr\').remove(); ipRenum();">✕</td>';
    document.getElementById('ipBody').appendChild(tr);
  }
  window.ipAdd = function(){ addRow({}); };
  window.ipRenum = function(){
    var n = 0;
    document.querySelectorAll('#ipBody tr').forEach(function(tr){ tr.cells[0].textContent = ++n; });
    rowIdx = n;
  };

  /* 환자 찾기 — 낙상 화면과 같은 입력검색을 쓴다(TBL_IPWON_INFO).
     이름 일부만 넣어도 되고, 고르면 등록번호·이름·성별·연령이 한 번에 채워진다. */
  window.ipFind = function(btn){
    var tr = btn.closest('tr');
    var kw0  = tr.querySelector('[data-f="patno"]').value.trim() || tr.querySelector('[data-f="patnm"]').value.trim();
    var base = (tr.querySelector('[data-f="chkdt"]').value || tr.querySelector('[data-f="indt"]').value || '').replace(/-/g,'');
    var list = [];

    /* ★검색창을 팝업 <안에> 둔다 — 처음엔 표 칸의 값으로 찾지만,
       원하는 사람이 안 나오면 팝업을 닫고 표에 다시 입력할 게 아니라 여기서 바로 다시 찾는다
       (2026-08-10 지적). 입력 후 잠시 멈추거나 Enter 를 누르면 다시 조회한다. */
    var h =
      '<div style="text-align:left;">' +
        '<input type="text" id="ipfKw" placeholder="이름 또는 등록번호 일부" value="' + esc(kw0) + '" ' +
          'style="width:100%; border:1px solid #cfd8e0; border-radius:6px; padding:7px 9px; font-size:13px; margin-bottom:8px;">' +
        '<div id="ipfList" style="max-height:300px; overflow:auto;"></div>' +
      '</div>';
    _alertBox(h, { icon:'🔍', okText:'닫기' });

    function render(rows){
      list = rows || [];
      var box = document.getElementById('ipfList');
      if (!box) return;
      if (!list.length){
        box.innerHTML = '<div style="color:#8a99a3; font-size:12.5px; padding:14px 4px; text-align:center;">' +
                        '찾는 환자가 없습니다. 이름이나 등록번호 일부로 다시 찾아보세요.</div>';
        return;
      }
      /* 표시는 낙상 화면과 같은 규칙 — 성별 M/F 는 <남/여>로. 병동·입원일도 보여야 동명이인을 가른다. */
      box.innerHTML = list.map(function(p, i){
        var sex  = p.ptsex === 'M' ? '남' : (p.ptsex === 'F' ? '여' : '');
        var ward = p.wardnm || p.roomnm || '';
        var sub  = [ward, sex + (p.ptage != null ? (' ' + p.ptage + '세') : ''),
                    p.ipwondt ? ('입원 ' + fmtDt(p.ipwondt)) : '']
                   .filter(function(s){ return s && s.trim(); }).join(' · ');
        return '<div class="ipf" data-i="'+i+'" style="padding:7px 9px; border:1px solid #eef2f5; border-radius:7px; margin-bottom:5px; cursor:pointer;">' +
               '<b>' + esc(p.ptnm) + '</b> <span style="color:#8a99a3;">' + esc(p.ptno) + '</span>' +
               (p.inhospyn === 'Y' ? ' <span style="color:#1f5a4b; font-size:11px; font-weight:700;">재원중</span>' : '') +
               '<div style="color:#8a99a3; font-size:11.5px; margin-top:1px;">' + esc(sub) + '</div></div>';
      }).join('');
      box.querySelectorAll('.ipf').forEach(function(el){
        el.onclick = function(){
          var p = list[Number(el.getAttribute('data-i'))];
          /* 서버가 돌려주는 이름은 ptno·ptnm·ptsex·ptage 다(낙상 화면과 같은 검색 API) */
          tr.querySelector('[data-f="patno"]').value  = p.ptno || '';
          tr.querySelector('[data-f="patnm"]').value  = p.ptnm || '';
          tr.querySelector('[data-f="ageval"]').value = (p.ptage == null ? '' : p.ptage);
          /* 성별은 화면·인쇄 모두 한글로 담는다 — M/F 로 저장하면 표에 그대로 찍힌다 */
          tr.querySelector('[data-f="sexnm"]').value =
            (p.ptsex === 'M') ? '남' : (p.ptsex === 'F' ? '여' : '');
          var btnOk = document.getElementById('confirmOk'); if (btnOk) btnOk.click();   // 고르면 닫기
        };
      });
    }

    function search(kw){
      var box = document.getElementById('ipfList');
      if (box) box.innerHTML = '<div style="color:#8a99a3; font-size:12.5px; padding:14px 4px; text-align:center;">찾는 중…</div>';
      post('/qps/patientSearch.do', { keyword: kw, baseDt: base })
        .then(function(res){ render(res.list || []); })
        .catch(function(e){ render([]); err(e); });
    }

    setTimeout(function(){
      var inp = document.getElementById('ipfKw');
      if (inp){
        inp.focus();
        var t = null;
        inp.oninput = function(){ clearTimeout(t); t = setTimeout(function(){ search(inp.value.trim()); }, 250); };
        inp.onkeydown = function(e){ if (e.key === 'Enter'){ clearTimeout(t); search(inp.value.trim()); } };
      }
      search(kw0);
    }, 60);
  };

  function collect(){
    var out = [], sort = 0;
    document.querySelectorAll('#ipBody tr').forEach(function(tr){
      var r = { sort: ++sort };
      tr.querySelectorAll('[data-f]').forEach(function(el){ r[el.getAttribute('data-f')] = String(el.value).trim(); });
      out.push(r);
    });
    return out;
  }

  window.ipLoad = function(){
    if (fileBox) fileBox.setKey(ym());
    return post('/qps/infPatGet.do', { ipatYm: ym() }).then(function(res){
      var d = res.doc || {};
      document.getElementById('s_blood').value = d.stblood || '';
      document.getElementById('s_mdro').value  = d.stmdro  || '';
      document.getElementById('s_tb').value    = d.sttb    || '';
      document.getElementById('ipBody').innerHTML = ''; rowIdx = 0;
      var items = res.items || [];
      if (items.length) items.forEach(addRow);
      else for (var i=0;i<12;i++) addRow({});   // 원본이 12행 서식 — 빈 표로 시작하지 않게
      document.getElementById('ipStat').textContent = d.ipatseq ? ('— 저장됨 #' + d.ipatseq) : '— 새 문서';
    }).catch(err);
  };

  window.ipSave = function(){
    post('/qps/infPatSave.do', {
      ipatYm: ym(),
      stBlood: document.getElementById('s_blood').value.trim(),
      stMdro:  document.getElementById('s_mdro').value.trim(),
      stTb:    document.getElementById('s_tb').value.trim(),
      items: JSON.stringify(collect())
    }).then(function(){ _toast('저장되었습니다.', 'ok'); return ipLoad(); }).catch(err);
  };

  ipLoad();
})();
</script>
</div>
</div><%-- /.dashboard-wrapper --%>
