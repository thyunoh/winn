<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%-- qpsDeptForm.jsp — 부서별 양식 (2026-08-18)

     왜 : 「부서별 양식 저장관리하는 내용만 — 서식 관리(위너넷)는 한눈에 안 들어와서」(사용자).
          서식 관리는 한 서식의 <모든 칸>을 다룬다. 여기는 ***어느 양식이 어느 부서 것인가***만 본다.

     ★★***한 양식은 한 부서다***(사용자 확정 2026-08-18).
       두 부서에서 쓰려면 ***복제해 별도 서식***을 만든다 — 그래서 줄마다 [복제]가 있다.
       (문서 키가 <병원+서식+기간>이라 한 서식을 두 부서가 같이 쓰면 같은 달 문서가 서로 덮인다.)

     ★부서를 옮겨도 **작성한 문서는 흔들리지 않는다**(문서 키에 부서가 없다).
     ⚠공통('*') 서식을 고치므로 **위너넷 전용** — 서버(QpsController.qpsDeptForm)가 병원 계정을 돌려보낸다.
     ★주의: 이 파일 안에서 Deferred EL 표기(샵+중괄호) 금지 --%>

<script src="/asset/js/ui-message.js"></script>

<%-- ★.dashboard-wrapper 는 winn 공통 레이아웃 필수 --%>
<div class="dashboard-wrapper">
<div id="qpsDeptForm">
<style>
  #qpsDeptForm{ background:#f4f6f8; color:#1f2a30; min-height:100%; padding:14px 16px 60px; max-width:100%; overflow-x:hidden; }
  #qpsDeptForm *{ box-sizing:border-box; }
  #qpsDeptForm .df-head{ display:flex; align-items:center; gap:10px; margin-bottom:10px; flex-wrap:wrap; }
  #qpsDeptForm .df-title{ font-size:18px; font-weight:800; color:#20303a; display:flex; align-items:center; gap:8px; }
  #qpsDeptForm .df-dot{ width:10px; height:10px; border-radius:50%; background:linear-gradient(135deg,#1f5a4b,#2a7665); }
  #qpsDeptForm .df-sub{ font-size:12px; color:#6b7c86; }
  #qpsDeptForm .df-spacer{ flex:1; }
  #qpsDeptForm select, #qpsDeptForm input[type=text]{
      border:1px solid #cfd8e0; border-radius:5px; padding:4px 6px; font-family:inherit; font-size:12.5px; background:#fff; }
  #qpsDeptForm .df-btn{ border:1px solid #1f5a4b; background:#1f5a4b; color:#fff; border-radius:6px;
      padding:6px 14px; font-size:13px; font-weight:600; cursor:pointer; white-space:nowrap; }
  #qpsDeptForm .df-btn.mini{ padding:3px 10px; font-size:12px; border-color:#cfd8e0; color:#556570; background:#fff; font-weight:500; }
  #qpsDeptForm .df-note{ background:#f0f7f4; border:1px solid #cfe3da; border-radius:8px; padding:8px 12px;
      font-size:12.5px; color:#1f5a4b; line-height:1.6; margin-bottom:10px; }
  /* 한눈에 — 부서별 수 */
  #qpsDeptForm .df-chips{ display:flex; gap:6px; flex-wrap:wrap; margin-bottom:10px; }
  #qpsDeptForm .df-chip{ border:1px solid #dbe3e8; background:#fff; border-radius:16px; padding:5px 12px;
      font-size:12.5px; color:#43555f; cursor:pointer; display:inline-flex; align-items:center; gap:6px; }
  #qpsDeptForm .df-chip:hover{ background:#f2f7f5; }
  #qpsDeptForm .df-chip.on{ border-color:#1f5a4b; background:#1f5a4b; color:#fff; font-weight:700; }
  #qpsDeptForm .df-chip .n{ font-size:11.5px; color:#8a99a3; }
  #qpsDeptForm .df-chip.on .n{ color:#cfe3da; }
  #qpsDeptForm .df-card{ background:#fff; border:1px solid #e3e9ed; border-radius:10px; padding:12px 14px; overflow-x:auto; }
  #qpsDeptForm table{ border-collapse:collapse; width:100%; min-width:760px; }
  #qpsDeptForm th, #qpsDeptForm td{ border-bottom:1px solid #eef2f5; padding:6px 8px; font-size:12.5px; text-align:left; }
  #qpsDeptForm thead th{ background:#f7fafb; color:#43555f; font-weight:700; white-space:nowrap; border-bottom:1px solid #e3e9ed; }
  #qpsDeptForm tbody tr:hover{ background:#f7fbf9; }
  #qpsDeptForm tr.chg{ background:#fdf6e3; }
  #qpsDeptForm .df-nm{ font-weight:700; color:#20303a; }
  #qpsDeptForm .df-meta{ font-size:11.5px; color:#8a99a3; }
  #qpsDeptForm .df-empty{ color:#8a99a3; font-size:13px; padding:24px; text-align:center; }
  #qpsDeptForm .zz-zoom{ display:inline-flex; gap:4px; align-items:center; margin-left:2px; }
  #qpsDeptForm .zz-zoom button{ border:1px solid #cfd9e0; background:#fff; color:#43555f; border-radius:6px;
                           padding:4px 9px; font-size:13px; font-weight:700; cursor:pointer; }
</style>

<div class="df-head">
  <div class="df-title"><span class="df-dot"></span>부서별 양식
    <span class="df-sub">어느 양식이 어느 부서 것인지만 봅니다</span></div>
  <div class="df-spacer"></div>
  <input type="text" id="dfQ" placeholder="양식 찾기" style="width:150px;" oninput="dfPaint();">
  <span class="df-sub" id="dfChg"></span>
  <button type="button" class="df-btn" onclick="dfSave();">저장</button>
  <span class="zz-zoom">
    <button type="button" onclick="zzZoom(-1);" title="글자 작게">가－</button>
    <button type="button" onclick="zzZoom(1);"  title="글자 크게">가＋</button>
    <button type="button" onclick="zzZoom(0);"  title="처음 크기로">↺</button>
  </span>
</div>

<div class="df-note">
  ★<b>한 양식은 한 부서</b>입니다. 부서를 바꾸면 <b>옮겨집니다</b> — 두 부서에서 같이 쓰려면
  <b>[복제]</b> 로 <b>별도 서식</b>을 만들어 그 부서로 두세요.<br>
  부서를 옮겨도 <b>이미 작성한 문서는 그대로</b>입니다. 서식의 <b>항목·표 모양</b>을 고치는 것은
  <b>[서식 관리]</b> 에서 합니다.
  <span style="color:#b5443c;">⚠복제로 만든 공통 서식은 화면에서 지울 수 없습니다.</span>
</div>

<div class="df-chips" id="dfChips"></div>

<div class="df-card">
  <table>
    <thead><tr>
      <th style="width:44%;">양식</th>
      <th style="width:150px;">분류</th>
      <th style="width:150px;">부서</th>
      <th style="width:80px;"></th>
    </tr></thead>
    <tbody id="dfBody"><tr><td colspan="4" class="df-empty">불러오는 중…</td></tr></tbody>
  </table>
</div>

<script>
(function(){
  var LIST = [], DEPTS = [], CATES = [], RULE = {};
  var ORG = {};          // formid → [부서, 분류]  받은 그대로(바뀐 줄을 가리려면 견줄 것이 있어야 한다)
  var CUR = {};          // formid → [부서, 분류]  화면에서 고친 값
  var curDept = '';

  function gel(id){ return document.getElementById(id); }
  // ★dataType:'json' 필수 — 빠뜨리면 응답이 문자열로 와서 오류 없이 조용히 0건이 된다
  function post(url, data){
    return $.ajax({ url:url, type:'POST', data:data, dataType:'json' }).then(function(res){
      if (res && res.result === 'FAIL') { throw new Error(res.message || '처리에 실패했습니다.'); }
      return res;
    });
  }
  function err(e){ _alertBox((e && e.message) ? e.message : '처리 중 오류가 발생했습니다.', {icon:'❌'}); }
  function esc(s){ return (s==null?'':String(s)).replace(/[&<>"]/g, function(c){
      return ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;'})[c]; }); }
  /* ★Swal 은 프로젝트 표준 — ***창은 작게***(양식 이름이 여러 줄로 접힌다). */
  function toast(text, icon){
    if (!window.Swal) { _alertBox(text, {icon:'✅'}); return; }
    Swal.fire({ icon:icon || 'success', title:text, width:380, padding:'0.9em', timer:1800, showConfirmButton:false });
  }
  function ask(html){
    if (!window.Swal) return Promise.resolve(confirm(String(html).replace(/<[^>]*>/g, '')));
    return Swal.fire({ html:html, width:420, padding:'1em', showCancelButton:true,
                       confirmButtonText:'예', cancelButtonText:'아니오' }).then(function(r){ return !!r.value; });
  }

  window.dfLoad = function(){
    // ★공통('*') 을 본다 — 배정을 정하는 자리다(병원 전용 서식은 그 병원 화면에서 다룬다)
    post('/qps/chkFormList.do', { hospCd:'*', cateCd:'', deptCd:'' }).then(function(res){
      LIST = res.list || [];
      if (!DEPTS.length) { DEPTS = res.dept || []; CATES = res.cate || []; }
      ORG = {}; CUR = {};
      LIST.forEach(function(r){
        ORG[r.formid] = [r.deptcd || '', r.catecd || ''];
        CUR[r.formid] = [r.deptcd || '', r.catecd || ''];
      });
      // 부서별 쓰는 분류 규칙 — 등록 화면과 같은 규칙으로 분류 후보를 좁힌다
      return post('/qps/deptCateList.do', {}).then(function(d){
        RULE = {};
        (d.rules || []).forEach(function(x){ (RULE[x.deptcd] = RULE[x.deptcd] || {})[x.catecd] = true; });
      }).catch(function(){ RULE = {}; });
    }).then(function(){ dfPaint(); }).catch(err);
  };

  function rows(){
    var q = gel('dfQ').value.trim();
    return LIST.filter(function(r){
      if (curDept && (CUR[r.formid] || [])[0] !== curDept) return false;
      if (q && String(r.formnm || '').indexOf(q) < 0 && String(r.formid).indexOf(q.toUpperCase()) < 0) return false;
      return true;
    });
  }
  function chgCnt(){
    var n = 0;
    LIST.forEach(function(r){
      var a = ORG[r.formid] || [], b = CUR[r.formid] || [];
      if (a[0] !== b[0] || a[1] !== b[1]) n++;
    });
    return n;
  }

  /** ★한눈에 — 부서마다 양식이 몇 종인가. ***고친 값 기준***으로 센다(옮기면 바로 숫자가 움직인다) */
  function paintChips(){
    var cnt = {}, tot = 0;
    LIST.forEach(function(r){ var d = (CUR[r.formid] || [])[0] || ''; cnt[d] = (cnt[d] || 0) + 1; tot++; });
    var h = '<button type="button" class="df-chip' + (curDept ? '' : ' on') + '" data-cd="">' +
            '<b>전체</b><span class="n">' + tot + '</span></button>';
    DEPTS.forEach(function(d){
      var n = cnt[d.subcode] || 0;
      h += '<button type="button" class="df-chip' + (curDept === d.subcode ? ' on' : '') + '" data-cd="' + esc(d.subcode) + '">' +
           '<b>' + esc(d.subcodenm) + '</b><span class="n">' + n + '</span></button>';
    });
    gel('dfChips').innerHTML = h;
  }

  /** 분류 후보 — 그 부서에 정해 둔 것만. ★지금 값은 규칙 밖이어도 남긴다(조용히 바뀌면 안 된다) */
  function cateOpts(deptCd, cur){
    var rule = RULE[deptCd], h = '<option value="">— 없음 —</option>';
    CATES.forEach(function(c){
      var ok = !rule || !!rule[c.subcode];
      if (!ok && c.subcode !== cur) return;
      h += '<option value="' + esc(c.subcode) + '"' + (c.subcode === cur ? ' selected' : '') + '>' +
           esc(c.subcodenm) + (ok ? '' : ' (규칙 밖)') + '</option>';
    });
    return h;
  }
  function deptOpts(cur){
    var h = '';
    DEPTS.forEach(function(d){
      h += '<option value="' + esc(d.subcode) + '"' + (d.subcode === cur ? ' selected' : '') + '>' +
           esc(d.subcodenm) + '</option>';
    });
    return h;
  }

  window.dfPaint = function(){
    paintChips();
    var rs = rows(), b = gel('dfBody');
    b.innerHTML = rs.length ? rs.map(function(r){
      var c = CUR[r.formid] || [], o = ORG[r.formid] || [];
      var chg = (c[0] !== o[0] || c[1] !== o[1]);
      return '<tr' + (chg ? ' class="chg"' : '') + ' data-id="' + esc(r.formid) + '">' +
             '<td><span class="df-nm">' + esc(r.formnm) + '</span>' +
             '<div class="df-meta">' + esc(r.formid) + ' · 항목 ' + (r.itemcnt || 0) +
             (chg ? ' · <b>옮김: ' + esc(nmOf(DEPTS, o[0])) + ' → ' + esc(nmOf(DEPTS, c[0])) + '</b>' : '') +
             '</div></td>' +
             '<td><select data-f="cate">' + cateOpts(c[0], c[1]) + '</select></td>' +
             '<td><select data-f="dept">' + deptOpts(c[0]) + '</select></td>' +
             '<td><button type="button" class="df-btn mini" data-copy="1">복제</button></td></tr>';
    }).join('') : '<tr><td colspan="4" class="df-empty">해당하는 양식이 없습니다.</td></tr>';
    var n = chgCnt();
    gel('dfChg').textContent = n ? ('고친 것 ' + n + '종 — 저장 전') : '';
  };
  function nmOf(list, cd){
    for (var i = 0; i < list.length; i++) if (list[i].subcode === cd) return list[i].subcodenm || cd;
    return cd || '(없음)';
  }

  // 부서 칩(위임)
  gel('dfChips').addEventListener('click', function(ev){
    var b = ev.target.closest ? ev.target.closest('.df-chip') : null;
    if (!b) return;
    curDept = b.getAttribute('data-cd') || '';
    dfPaint();
  });

  // 표 안 셀렉트·복제(위임) — 다시 그려도 살아남는다
  gel('dfBody').addEventListener('change', function(ev){
    var s = ev.target;
    if (!s || s.tagName !== 'SELECT') return;
    var tr = s.closest('tr'), id = tr && tr.getAttribute('data-id');
    if (!id) return;
    var f = s.getAttribute('data-f'), c = CUR[id] || ['',''];
    if (f === 'dept') {
      c[0] = s.value;
      // ★부서를 옮기면 그 부서 규칙에 없는 분류는 비운다 — 「규칙 밖」인 채로 굳지 않게
      var rule = RULE[c[0]];
      if (rule && c[1] && !rule[c[1]]) c[1] = '';
    } else { c[1] = s.value; }
    CUR[id] = c;
    dfPaint();
  });
  gel('dfBody').addEventListener('click', function(ev){
    var b = ev.target.closest ? ev.target.closest('[data-copy]') : null;
    if (!b) return;
    var tr = b.closest('tr'), id = tr && tr.getAttribute('data-id');
    if (!id) return;
    dfCopy(id);
  });

  /** ★복제 — 두 부서에서 쓰려면 별도 서식을 만든다(사용자 확정). 이미 있는 chkFormCopy 를 그대로 쓴다. */
  function dfCopy(id){
    var src = LIST.filter(function(r){ return r.formid === id; })[0];
    if (!src) return;
    _confirmBox({
      msg: '<b>' + esc(src.formnm) + '</b> 를 복제합니다.<br>' +
           '<div style="text-align:left;font-size:12.5px;margin-top:8px;">' +
           '새 서식코드 <input type="text" id="dfcId" maxlength="30" style="width:120px;" placeholder="예) CLI002"><br>' +
           '<span style="display:inline-block;margin-top:6px;">새 이름 </span>' +
           '<input type="text" id="dfcNm" maxlength="200" style="width:230px;" value="' + esc(src.formnm) + ' (복제)"><br>' +
           '<span style="display:inline-block;margin-top:6px;">부서 </span>' +
           '<select id="dfcDept">' + deptOpts((CUR[id] || [])[0]) + '</select>' +
           '</div>' +
           '<div style="text-align:left;font-size:11.5px;color:#8a99a3;margin-top:8px;">' +
           '항목까지 그대로 복사됩니다. 복제 뒤 이름·항목은 [서식 관리]에서 고치세요.<br>' +
           '<b style="color:#b5443c;">⚠공통 서식은 화면에서 못 지웁니다</b> — 코드를 확인하고 누르세요.</div>',
      icon: '📋', okText: '복제',
      onOk: function(){
        var neo = ((document.getElementById('dfcId') || {}).value || '').trim().toUpperCase();
        var nm  = ((document.getElementById('dfcNm') || {}).value || '').trim();
        var dep = ((document.getElementById('dfcDept') || {}).value || '').trim();
        if (!neo || !nm) { _alertBox('새 서식코드와 이름을 넣어 주세요.', {icon:'⚠️'}); return; }
        // ★공통('*') 으로 복제한다 — 이 화면은 공통 서식을 다룬다
        post('/qps/chkFormCopy.do', { hospCd:'*', srcFormId:id, newFormId:neo, newFormNm:nm })
          .then(function(){
            return post('/qps/chkFormDeptSave.do',
              { hospCd:'*', rows: JSON.stringify([{ formId:neo, deptCd:dep, cateCd:(CUR[id] || [])[1] || '' }]) });
          })
          .then(function(){ toast('복제했습니다 — ' + neo); dfLoad(); })
          .catch(err);
      } });
  }

  window.dfSave = function(){
    var rows2 = [];
    LIST.forEach(function(r){
      var a = ORG[r.formid] || [], b = CUR[r.formid] || [];
      if (a[0] !== b[0] || a[1] !== b[1]) rows2.push({ formId:r.formid, deptCd:b[0], cateCd:b[1] });
    });
    if (!rows2.length) { toast('고친 것이 없습니다.', 'info'); return; }
    var moved = rows2.filter(function(x){ return (ORG[x.formId] || [])[0] !== x.deptCd; }).length;
    ask('양식 <b>' + rows2.length + '종</b>을 저장합니다' +
        (moved ? ('<br>그중 <b>' + moved + '종</b>은 <b>부서가 옮겨집니다.</b>') : '') +
        '<br><span style="font-size:12px;color:#8a99a3;">이미 작성한 문서는 그대로입니다.</span>').then(function(ok){
      if (!ok) return;
      post('/qps/chkFormDeptSave.do', { hospCd:'*', rows: JSON.stringify(rows2) }).then(function(res){
        toast('저장했습니다 — ' + (res.cnt || 0) + '종');
        dfLoad();
      }).catch(err);
    });
  };

  $(function(){ dfLoad(); });
})();

/* ═══ 글자 크기 (2026-08-18) ═══════════════════════════════════════════════ */
(function(){
  var W = 'qpsDeptForm', ZKEY = 'qpsZoom_' + W;
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
</div><%-- /#qpsDeptForm --%>
</div><%-- /.dashboard-wrapper --%>
