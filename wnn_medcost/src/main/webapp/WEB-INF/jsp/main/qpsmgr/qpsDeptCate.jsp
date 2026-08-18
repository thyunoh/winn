<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%-- qpsDeptCate.jsp — 부서별 쓰는 분류 (2026-08-18)

     왜 : 서식 1건에는 <부서 1개 + 분류 1개>가 붙는데, 실제로 쓰이는 조합은
          부서 14 x 분류 6 = 84칸 중 42칸뿐이다. 나머지 절반은 고르면 0종이 되는 헛 조합이다.
          그 규칙을 사람이 정해 두는 화면이다.

     ★★정해 둔 것이 없는 부서는 <전 분류>다 — 빈 표는 지금과 똑같이 돈다.
       ***막는 장치가 아니라 좁혀 주는 장치***다(사용자별 담당 부서와 같은 규칙).
     ★적용 지점은 <서식 등록 화면 하나뿐>이다. 보는 화면(우리 병원 사용 서식·점검표 작성)은
       이 규칙을 안 본다 — 규칙과 자료가 어긋나는 날 ***서식이 목록에서 사라지는 것***을 막는다.
       ⇒ 그래서 이 화면은 <규칙>과 <실제 서식 종수>를 나란히 보여준다. 어긋난 칸은 색으로 뜬다.

     ★위너넷 전용 — 병원 계정은 서버가 작성 화면으로 돌려보낸다(QpsController.qpsDeptCate).
     ★주의: 이 파일 안에서 Deferred EL 표기(샵+중괄호) 금지 --%>

<script src="/asset/js/ui-message.js"></script>

<%-- ★.dashboard-wrapper 는 winn 공통 레이아웃 필수 --%>
<div class="dashboard-wrapper">
<div id="qpsDeptCate">
<style>
  #qpsDeptCate{ background:#f4f6f8; color:#1f2a30; min-height:100%; padding:14px 16px 60px; max-width:100%; overflow-x:hidden; }
  #qpsDeptCate *{ box-sizing:border-box; }
  #qpsDeptCate .dq-head{ display:flex; align-items:center; gap:10px; margin-bottom:12px; flex-wrap:wrap; }
  #qpsDeptCate .dq-title{ font-size:18px; font-weight:800; color:#20303a; display:flex; align-items:center; gap:8px; }
  #qpsDeptCate .dq-dot{ width:10px; height:10px; border-radius:50%; background:linear-gradient(135deg,#1f5a4b,#2a7665); }
  #qpsDeptCate .dq-sub{ font-size:12px; color:#6b7c86; }
  #qpsDeptCate .dq-spacer{ flex:1; }
  #qpsDeptCate .dq-btn{ border:1px solid #1f5a4b; background:#1f5a4b; color:#fff; border-radius:6px;
      padding:6px 14px; font-size:13px; font-weight:600; cursor:pointer; white-space:nowrap; }
  #qpsDeptCate .dq-btn.mini{ padding:3px 10px; font-size:12px; border-color:#cfd8e0; color:#556570; background:#fff; font-weight:500; }
  #qpsDeptCate .dq-note{ background:#f0f7f4; border:1px solid #cfe3da; border-radius:8px; padding:9px 12px;
      font-size:12.5px; color:#1f5a4b; line-height:1.7; margin-bottom:12px; }
  #qpsDeptCate .dq-card{ background:#fff; border:1px solid #e3e9ed; border-radius:10px; padding:12px 14px; overflow-x:auto; }
  #qpsDeptCate table{ border-collapse:collapse; width:100%; min-width:820px; }
  #qpsDeptCate th, #qpsDeptCate td{ border:1px solid #e3e9ed; padding:6px 8px; font-size:12.5px; text-align:center; }
  #qpsDeptCate thead th{ background:#f7fafb; color:#43555f; font-weight:700; white-space:nowrap; }
  #qpsDeptCate td.dq-dept{ text-align:left; white-space:nowrap; font-weight:700; color:#20303a; }
  #qpsDeptCate td.dq-dept small{ font-weight:400; color:#8a99a3; margin-left:4px; }
  #qpsDeptCate tbody tr:hover{ background:#f7fbf9; }
  #qpsDeptCate .dq-cell{ display:flex; flex-direction:column; align-items:center; gap:1px; cursor:pointer; }
  #qpsDeptCate .dq-n{ font-size:11px; color:#8a99a3; }
  #qpsDeptCate .dq-n.zero{ color:#cfd8e0; }
  #qpsDeptCate td.on{ background:#f0f7f4; }
  #qpsDeptCate td.warn{ background:#fdf3f3; }        /* 규칙에 없는데 서식이 있는 칸 */
  #qpsDeptCate td.warn .dq-n{ color:#b5443c; font-weight:700; }
  #qpsDeptCate .dq-all{ background:#eef3f6; color:#43555f; border-radius:10px; padding:1px 8px; font-size:11px; font-weight:700; }
  #qpsDeptCate .dq-legend{ font-size:12px; color:#6b7c86; margin-top:10px; line-height:1.8; }
  #qpsDeptCate .dq-legend i{ display:inline-block; width:11px; height:11px; border:1px solid #e3e9ed; vertical-align:-1px; margin-right:3px; }
  #qpsDeptCate .dq-swal{ font-size:13px; }
  #qpsDeptCate .zz-zoom{ display:inline-flex; gap:4px; align-items:center; margin-left:2px; }
  #qpsDeptCate .zz-zoom button{ border:1px solid #cfd9e0; background:#fff; color:#43555f; border-radius:6px;
                           padding:4px 9px; font-size:13px; font-weight:700; cursor:pointer; }
</style>

<div class="dq-head">
  <div class="dq-title"><span class="dq-dot"></span>부서별 쓰는 분류
    <span class="dq-sub">서식을 새로 만들 때 고를 수 있는 분류를 부서마다 정해 둡니다</span></div>
  <div class="dq-spacer"></div>
  <button type="button" class="dq-btn mini" onclick="dqFit();">지금 서식대로 맞추기</button>
  <button type="button" class="dq-btn" onclick="dqSave();">저장</button>
  <span class="zz-zoom">
    <button type="button" onclick="zzZoom(-1);" title="글자 작게">가－</button>
    <button type="button" onclick="zzZoom(1);"  title="글자 크게">가＋</button>
    <button type="button" onclick="zzZoom(0);"  title="처음 크기로">↺</button>
  </span>
</div>

<div class="dq-note">
  ★<b>한 칸도 안 고른 부서는 「전 분류」</b>입니다 — 정하지 않으면 지금과 똑같이 돕니다(막는 장치가 아니라 <b>좁혀 주는 장치</b>).
  모두 지우면 그 부서는 전 분류로 되돌아갑니다.<br>
  이 규칙은 <b>[서식 관리]에서 새 서식을 만들 때만</b> 적용됩니다.
  <b>이미 등록된 서식은 어느 화면에서도 사라지지 않습니다</b> — 숫자는 지금 등록된 서식 종수입니다.
</div>

<div class="dq-card">
  <table id="dqTbl"><thead></thead><tbody><tr><td>불러오는 중…</td></tr></tbody></table>
  <div class="dq-legend">
    <i style="background:#f0f7f4;"></i>정한 칸 ·
    <i style="background:#fdf3f3;"></i><b>어긋난 칸</b> — 규칙에는 없는데 <b>서식이 이미 있습니다</b>(그 서식은 그대로 쓰입니다) ·
    <span class="dq-all">전 분류</span> 아무것도 안 정한 부서
  </div>
</div>

<script>
(function(){
  var DEPTS = [], CATES = [];
  var RULE = {};      // deptCd → { cateCd:true }   사람이 정해 둔 것
  var CNT  = {};      // deptCd → { cateCd:종수 }   지금 등록된 서식

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
  /* ★Swal 은 프로젝트 표준. ***창은 작게*** — 크게 두면 부서 이름이 여러 줄로 접힌다.
     ⚠Swal 창은 body 바로 밑에 붙으므로 #qpsDeptCate 안에 CSS 를 두면 안 먹는다 → 인라인으로 준다. */
  function toast(text, icon){
    if (!window.Swal) { _alertBox(text, {icon:'✅'}); return; }
    Swal.fire({ icon:icon || 'success', title:text, width:380, padding:'0.9em',
                timer:1700, showConfirmButton:false });
  }
  function ask(html){
    if (!window.Swal) return Promise.resolve(confirm(String(html).replace(/<[^>]*>/g, '')));
    return Swal.fire({ html:html, width:400, padding:'1em', showCancelButton:true,
                       confirmButtonText:'예', cancelButtonText:'아니오' })
               .then(function(r){ return !!r.value; });
  }

  window.dqLoad = function(){
    post('/qps/deptCateList.do', {}).then(function(res){
      DEPTS = res.dept || []; CATES = res.cate || [];
      RULE = {}; CNT = {};
      (res.rules || []).forEach(function(r){
        (RULE[r.deptcd] = RULE[r.deptcd] || {})[r.catecd] = true;
      });
      (res.cnts || []).forEach(function(r){
        (CNT[r.deptcd] = CNT[r.deptcd] || {})[r.catecd] = Number(r.cnt) || 0;
      });
      dqPaint();
    }).catch(err);
  };

  /** ★부서 목록은 공통코드 차례 그대로다 — 사이드바·셀렉트와 같은 차례여야 눈이 안 헷갈린다 */
  window.dqPaint = function(){
    var t = gel('dqTbl'), h = '<tr><th style="text-align:left;">부서</th>';
    CATES.forEach(function(c){ h += '<th>' + esc(c.subcodenm) + '</th>'; });
    h += '<th>서식</th><th>정한 분류</th></tr>';
    t.tHead.innerHTML = h;

    var body = '';
    DEPTS.forEach(function(d){
      var dc = d.subcode, rule = RULE[dc] || {}, cnt = CNT[dc] || {};
      var ruleN = 0, formN = 0;
      CATES.forEach(function(c){ if (rule[c.subcode]) ruleN++; formN += (cnt[c.subcode] || 0); });
      body += '<tr data-dept="' + esc(dc) + '">';
      body += '<td class="dq-dept">' + esc(d.subcodenm) + '<small>' + esc(dc) + '</small></td>';
      CATES.forEach(function(c){
        var on = !!rule[c.subcode], n = cnt[c.subcode] || 0;
        // ★어긋난 칸 = 규칙엔 없는데 서식이 있다. 색으로만 알린다 — 고치는 것은 사람이 정한다
        var cls = on ? 'on' : (n > 0 ? 'warn' : '');
        body += '<td class="' + cls + '"><label class="dq-cell">' +
                '<input type="checkbox" data-dept="' + esc(dc) + '" data-cate="' + esc(c.subcode) + '"' +
                (on ? ' checked' : '') + '>' +
                '<span class="dq-n' + (n ? '' : ' zero') + '">' + (n || '·') + '</span></label></td>';
      });
      body += '<td class="dq-n">' + (formN || '·') + '</td>';
      body += '<td>' + (ruleN ? (ruleN + '개') : '<span class="dq-all">전 분류</span>') + '</td>';
      body += '</tr>';
    });
    t.tBodies[0].innerHTML = body || '<tr><td>부서 공통코드가 없습니다.</td></tr>';
  };

  // 체크는 RULE 에 담는다 — 다시 그려도 살아남는다(위임)
  gel('dqTbl').addEventListener('change', function(ev){
    var cb = ev.target;
    if (!cb || cb.type !== 'checkbox') return;
    var d = cb.getAttribute('data-dept'), c = cb.getAttribute('data-cate');
    RULE[d] = RULE[d] || {};
    if (cb.checked) RULE[d][c] = true; else delete RULE[d][c];
    dqPaint();
  });

  /** ★「지금 서식대로 맞추기」 — 서식이 1종이라도 있는 칸을 그대로 규칙으로 삼는다.
      처음 한 번 채우는 데 쓴다(기본값). ***서식이 0종인 칸은 꺼진다*** — 앞으로 만들 분류는 손으로 켠다. */
  window.dqFit = function(){
    ask('지금 <b>등록된 서식이 있는 칸</b>을 그대로 규칙으로 삼습니다.<br>' +
        '<b>서식이 0종인 칸은 꺼집니다.</b> 계속할까요?').then(function(ok){
      if (!ok) return;
      RULE = {};
      Object.keys(CNT).forEach(function(d){
        Object.keys(CNT[d]).forEach(function(c){ if (CNT[d][c] > 0) (RULE[d] = RULE[d] || {})[c] = true; });
      });
      dqPaint();
      toast('맞췄습니다. 확인하고 [저장] 을 누르세요.', 'info');
    });
  };

  window.dqSave = function(){
    /* ★화면에 있던 부서를 **모두** 보낸다 — 체크를 다 지운 부서도 보내야
       「전 분류로 되돌림」이 서버에 전달된다(안 보내면 옛 규칙이 그대로 남는다). */
    var rows = [], allOff = [];
    DEPTS.forEach(function(d){
      var r = RULE[d.subcode] || {}, cs = Object.keys(r);
      if (!cs.length) allOff.push(d.subcodenm);
      rows.push({ deptCd: d.subcode, cates: cs.join(',') });
    });
    var msg = '부서별 분류 규칙을 저장합니다.';
    if (allOff.length) {
      var names = allOff.slice(0, 6).join(', ') + (allOff.length > 6 ? (' 외 ' + (allOff.length - 6) + '개') : '');
      msg += '<br><br><b>' + esc(names) + '</b> 은(는) 정한 분류가 없어<br><b>전 분류</b>로 열립니다.';
    }
    ask(msg).then(function(ok){
      if (!ok) return;
      post('/qps/deptCateSave.do', { rows: JSON.stringify(rows) }).then(function(){
        toast('저장했습니다.');
        dqLoad();
      }).catch(err);
    });
  };

  $(function(){ dqLoad(); });
})();

/* ═══ 글자 크기 (2026-08-18) ═══════════════════════════════════════════════ */
(function(){
  var W = 'qpsDeptCate', ZKEY = 'qpsZoom_' + W;
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
</div><%-- /#qpsDeptCate --%>
</div><%-- /.dashboard-wrapper --%>
