<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%--
  일괄 출력 (2026-09-07 사용자 요청 「일괄 작성·일괄 출력·일괄 사인 형태의 업무 위주」)
    요양병원은 전문인력이 모자라 서식을 하나씩 열어 뽑는 방식이 현장에서 안 돌아간다.
    고른 서식을 **한 번에 이어 붙여** 인쇄한다 — 실사 준비 묶음을 한 번의 인쇄로 끝내라는 뜻이다.

  ★어떻게 모으나 : 서식 화면을 숨은 iframe 으로 띄우고 그 화면의 **제 인쇄 함수**를 부른다.
    화면마다 인쇄 조립이 이미 있으니 그걸 그대로 쓴다(같은 결과가 두 벌로 갈리지 않게).
    인쇄 함수는 공통 창구 qpsPrintOut(제목, CSS, 본문) 을 거치는데, 일괄일 때는 창을 띄우지 않고
    이 화면으로 넘겨 준다(sidebar.jsp 의 QPS_BULK 표식).

  ★업무를 벗어나지 않는다 : 자료를 새로 만들거나 고치지 않는다. **화면에 있는 그대로** 모아 인쇄만 한다.
--%>
<div class="dashboard-wrapper">
<style>
  #qpsPrintAll{ padding:14px 16px 24px; }
  #qpsPrintAll h3{ margin:0 0 4px; font-size:18px; font-weight:800; color:#1f5a4b; }
  #qpsPrintAll .sub{ font-size:12.5px; color:#6b7a83; margin-bottom:14px; }
  #qpsPrintAll .card{ border:1px solid #dfe6ea; border-radius:10px; padding:14px 16px; background:#fff; max-width:760px; }
  #qpsPrintAll .row{ display:flex; align-items:center; gap:10px; padding:7px 4px; border-bottom:1px dashed #eef2f4; }
  #qpsPrintAll .row:last-child{ border-bottom:0; }
  #qpsPrintAll .row label{ margin:0; font-size:14px; cursor:pointer; }
  #qpsPrintAll .row .desc{ font-size:12px; color:#8a99a3; margin-left:auto; }
  /* 작성 주기 배지(사용자 2026-09-07) */
  #qpsPrintAll .row .cyc{ margin-left:auto; font-size:11.5px; font-weight:700; color:#3b6ea5; background:#eef4fb; border:1px solid #d7e5f5; border-radius:8px; padding:2px 6px; height:26px; cursor:pointer; }
  #qpsPrintAll .row .desc{ margin-left:10px; min-width:76px; text-align:right; }
  #qpsPrintAll .bar{ margin-top:14px; display:flex; gap:8px; align-items:center; }
  #qpsPrintAll .btn{ height:36px; padding:0 16px; border-radius:8px; border:1px solid #cfd8e0; background:#fff; font-size:13.5px; font-weight:700; cursor:pointer; }
  #qpsPrintAll .btn.go{ background:#1f5a4b; border-color:#1f5a4b; color:#fff; }
  /* 누르는 단추처럼 보이게(사용자 2026-09-07 「실행 버튼이 아닌 것으로 보임」) — 인쇄(초록)와 색을 달리해 헷갈리지 않게 */
  #qpsPrintAll .btn.find{ background:#2f6fb0; border-color:#2f6fb0; color:#fff; }
  #qpsPrintAll .btn.find:hover{ background:#265d95; border-color:#265d95; }
  #qpsPrintAll .btn:disabled{ opacity:.5; cursor:default; }
  #qpsPrintAll .stat{ font-size:12.5px; color:#4a5560; margin-left:6px; }
  #qpsPrintAll .hint{ margin-top:12px; font-size:12px; color:#8a99a3; line-height:1.7; }
  #qpsBulkFrames{ position:fixed; left:-10000px; top:0; width:1200px; height:900px; }
</style>

<div id="qpsPrintAll">
  <h3>🖨 일괄 출력</h3>
  <div class="sub">고른 서식을 한 번에 이어 붙여 인쇄합니다. 화면에 있는 그대로 모을 뿐, 자료를 만들거나 고치지 않습니다.</div>

  <div class="card">
    <div class="bar" style="margin:0 0 10px; padding-bottom:10px; border-bottom:1px solid #e6edf1;">
      <label style="margin:0; font-size:13.5px; font-weight:700;">연도</label>
      <select id="paYear" style="height:34px; border:1px solid #cfd8e0; border-radius:8px; padding:0 8px; font-size:13.5px;" onchange="paYearChanged()"></select>
      <%-- 기간 (2026-09-07) — 한 해에 여러 건 쌓이는 서식(회의록 등)은 기간으로 걸러 건마다 뽑는다.
           소급 등록이라 작성일이 여기저기 흩어진다는 사용자 말에 따라 넣었다. 비워 두면 그 해 전체. --%>
      <label style="margin:0 0 0 8px; font-size:13px; color:#6b7a83;">기간</label>
      <input type="date" id="paFrom" style="height:34px; border:1px solid #cfd8e0; border-radius:8px; padding:0 6px; font-size:13px;" onchange="paYearChanged()">
      <span style="color:#9aa7b0;">~</span>
      <input type="date" id="paTo" style="height:34px; border:1px solid #cfd8e0; border-radius:8px; padding:0 6px; font-size:13px;" onchange="paYearChanged()">
      <button type="button" class="btn find" id="paChk" onclick="paCheck()">🔎 이 해에 작성된 것 찾기</button>
      <span class="stat" id="paChkStat"></span>
    </div>

    <div class="row" style="border-bottom:1px solid #e6edf1;">
      <label><input type="checkbox" id="paAll" onclick="paToggleAll(this)"> <b>전체 고르기</b></label>
      <span class="desc">한 장짜리 서식부터 담았습니다</span>
    </div>
    <div id="paList"></div>

    <div class="bar">
      <button type="button" class="btn go" id="paGo" onclick="paRun()">고른 서식 인쇄</button>
      <button type="button" class="btn" onclick="paClear()">고른 것 지우기</button>
      <span class="stat" id="paStat"></span>
    </div>

    <div class="hint">
      · 서식마다 화면을 열어 그 화면의 인쇄 내용을 그대로 가져옵니다 — 낱장으로 뽑을 때와 같은 모양입니다.<br>
      · 자료가 없는 서식은 빈 양식으로 나옵니다. 빼려면 체크를 풀어 주세요.<br>
      · 서식과 서식 사이는 새 장으로 넘어갑니다.
    </div>
  </div>
</div>
<div id="qpsBulkFrames"></div>

<script>
(function () {
  var CTX = '';
  /* 담을 서식 — url = 그 화면 주소 · fn = 그 화면의 인쇄 함수 이름 · wait = 자료가 들어올 때까지 기다릴 시간(ms)
     ★한 장짜리(머리글·바닥글 없이 나오게 손봐 둔 것)부터 담았다. 여러 장 서식은 확인한 뒤 늘린다. */
  var FORMS = [
    /* ── 계획 · 위원회 ── */
    { key:'minutes', nm:'QPS 위원회 회의록',        url:'/main/qpsMinutes.do',  fn:'qmPrint', listFn:'qmBulkList', cyc:'Q' },
    /* ── 지표 · 분석 ── */
    { key:'def',     nm:'지표 정의서',              url:'/main/qpsDef.do',      fn:'qdPrint', cyc:'Y' },
    /* ── 환자안전 활동 ── */
    { key:'round',   nm:'환자안전관리 라운딩 점검표', url:'/main/qpsRound.do',  fn:'rdPrint', cyc:'M' },
    { key:'rca',     nm:'RCA 근본원인 분석',        url:'/main/qpsRca.do',      fn:'rcPrint', cyc:'S' },
    { key:'fmea',    nm:'FMEA 계획서 · 보고서',     url:'/main/qpsFmea.do',     fn:'fmPrint', cyc:'Y' },
    /* ── QI ── */
    { key:'qiplan',  nm:'QI 활동계획서',            url:'/main/qpsQiPlan.do',   fn:'qpPrint', cyc:'Y' },
    { key:'qirpt',   nm:'QI 중간 · 최종보고서',     url:'/main/qpsQiRpt.do',    fn:'qrPrint', cyc:'H' },
    { key:'qifund',  nm:'활동 자원지원 내역',       url:'/main/qpsQiFund.do',   fn:'qfPrint', cyc:'Y' },
    /* ── 환자만족도 조사 ── */
    { key:'srvplan', nm:'환자만족도 조사계획서',    url:'/main/qpsSrvPlan.do',  fn:'spPrint', cyc:'Y' },
    { key:'srvnote', nm:'환자만족도 조사안내문',    url:'/main/qpsSrvPlan.do',  fn:'spPrintNotice', cyc:'Y' },
    { key:'srvimpr', nm:'개선활동결과보고서',       url:'/main/qpsSrvImpr.do',  fn:'siPrint', cyc:'S' },
    /* ── 불만고충 ── */
    { key:'cmplplan',nm:'불만고충 처리계획서',      url:'/main/qpsCmplPlan.do', fn:'cpPrint', cyc:'Y' },
    { key:'cmplrpt', nm:'불만고충 지표분석보고서',  url:'/main/qpsCmplRpt.do',  fn:'crPrint', cyc:'Q' }
  ];
  FORMS.forEach(function (f) { if (!f.wait) f.wait = 2600; });   // 자료가 들어올 때까지 기다릴 시간

  var gel = function (id) { return document.getElementById(id); };
  function fdef(k) { for (var i = 0; i < FORMS.length; i++) if (FORMS[i].key === k) return FORMS[i]; return null; }
  var parts = {};      // key → {title, css, body}
  var running = false;

  /* 서식별 작성 주기 (사용자 2026-09-07 「매일인지 주인지 월인지 분기인지 연인지 특정인지 확인하게」)
     ★코드는 이미 쓰던 것을 그대로 쓴다 — 점검표 서식(TBL_QPS_CHK_FORM.PRD_GB)과 지표 마스터(CYCLE_GB)가
       D·W·M·Q·H·Y 를 쓰고 있다. 여기에 S(그때그때 — 사건이 나면)를 더했다.
     ★지금 값은 **초기값**이다. 병원마다 다를 수 있으니 확인해 고치고, 굳어지면 설정 표로 뺀다. */
  var CYC = { D:'매일', W:'매주', M:'매월', Q:'분기', H:'반기', Y:'연 1회', S:'그때그때' };
  /* 기간 안에 몇 건이 있어야 하는지 — 빠진 것을 눈에 보이게. 휴일·연기는 따지지 않는 어림수다. */
  function due(cyc, rg) {
    if (!rg || !cyc || cyc === 'S') return 0;
    var a = new Date(rg.f.slice(0,4) + '-' + rg.f.slice(4,6) + '-' + rg.f.slice(6,8));
    var b = new Date(rg.t.slice(0,4) + '-' + rg.t.slice(4,6) + '-' + rg.t.slice(6,8));
    if (isNaN(a) || isNaN(b) || b < a) return 0;
    var days = Math.floor((b - a) / 86400000) + 1;
    var mons = (b.getFullYear() - a.getFullYear()) * 12 + (b.getMonth() - a.getMonth()) + 1;
    if (cyc === 'D') return days;
    if (cyc === 'W') return Math.ceil(days / 7);
    if (cyc === 'M') return mons;
    if (cyc === 'Q') return Math.ceil(mons / 3);
    if (cyc === 'H') return Math.ceil(mons / 6);
    if (cyc === 'Y') return Math.max(1, b.getFullYear() - a.getFullYear() + 1);
    return 0;
  }

  function draw() {
    var h = '';
    FORMS.forEach(function (f) {
      /* 주기는 그 자리에서 고친다 — 고치면 바로 표(TBL_QPS_FORM_CYC)에 저장한다(2026-09-07 「설정 표로 빼줘」) */
      var op = '';
      for (var k in CYC) op += '<option value="' + k + '"' + (f.cyc === k ? ' selected' : '') + '>' + CYC[k] + '</option>';
      h += '<div class="row"><label><input type="checkbox" class="paChk" value="' + f.key + '"> ' + f.nm + '</label>' +
           '<select class="cyc" data-key="' + f.key + '" onchange="paCycSave(this)" title="작성 주기 — 고치면 바로 저장됩니다">' + op + '</select>' +
           '<span class="desc" id="paSt_' + f.key + '">' + (f.note || '') + '</span></div>';   /* 주소(.do)는 안 보인다 — 화면에 쓸 말이 아니다(2026-09-07) */
    });
    gel('paList').innerHTML = h;
  }

  /* 표에 저장된 주기를 먼저 읽어 온다. 표가 비었거나 못 읽으면 화면 기본값 그대로 — 설정 전에도 멀쩡히 돈다. */
  function loadCyc() {
    return fetch(CTX + '/qps/formCycList.do', {
      method: 'POST', credentials: 'same-origin',
      headers: { 'Content-Type': 'application/x-www-form-urlencoded' }, body: ''
    }).then(function (r) { return r.json(); }).then(function (j) {
      ((j && j.list) || []).forEach(function (r) {
        var f = fdef(r.formkey);
        if (f && r.cycgb) f.cyc = String(r.cycgb).toUpperCase();
      });
    }).catch(function () { });
  }
  loadCyc().then(draw);
  draw();   // 표를 읽기 전에도 목록은 보이게

  window.paCycSave = function (sel) {
    var key = sel.getAttribute('data-key'), f = fdef(key);
    if (!f) return;
    f.cyc = sel.value;
    var body = 'formKey=' + encodeURIComponent(key) + '&cycGb=' + encodeURIComponent(sel.value) +
               '&formNm=' + encodeURIComponent(f.nm);
    fetch(CTX + '/qps/formCycSave.do', {
      method: 'POST', credentials: 'same-origin',
      headers: { 'Content-Type': 'application/x-www-form-urlencoded' }, body: body
    }).then(function (r) { return r.json(); }).then(function (j) {
      gel('paChkStat').textContent = (j && j.result === 'OK')
        ? (f.nm + ' 주기를 ' + CYC[sel.value] + '로 저장했습니다.')
        : ('주기 저장 실패 — ' + ((j && j.message) || '표가 아직 없을 수 있습니다(DDL 확인)'));
    }).catch(function () { gel('paChkStat').textContent = '주기 저장 실패 — 통신 오류'; });
  };

  /* 연도 — 올해를 가운데 두고 앞뒤로. 고른 해가 각 서식 화면에 ?yy= 로 넘어간다(2026-09-07) */
  (function () {
    var y = new Date().getFullYear(), sel = gel('paYear');
    for (var i = y + 1; i >= y - 4; i--) sel.add(new Option(i + '년', i));
    sel.value = y;
  })();
  function year() { return gel('paYear').value; }
  function range() {
    var f = gel('paFrom').value || '', t = gel('paTo').value || '';
    return (f || t) ? { f: f.replace(/-/g, ''), t: (t || '9999-12-31').replace(/-/g, '') } : null;
  }

  /* 여러 건 쌓이는 서식은 **건마다 한 장**이다. 기간을 주면 그 기간에 드는 건만 골라 하나씩 뽑는다(2026-09-07).
     목록은 그 화면이 알려 준다(listFn) — 우리가 표를 따로 읽지 않으니 조회 규칙이 두 벌로 갈리지 않는다.
     ★기간을 비우면 종전처럼 화면이 여는 것 하나만(대개 최근 건). */
  function expand(list) {
    var rg = range();
    if (!rg) return Promise.resolve(list.slice());
    var out = [], i = 0;
    return new Promise(function (resolve) {
      var step = function () {
        if (i >= list.length) { resolve(out); return; }
        var f = list[i++];
        if (!f.listFn) { out.push(f); step(); return; }
        askList(f).then(function (rows) {
          var hit = rows.filter(function (r) {
            var d = String(r.dt || '').replace(/-/g, '');
            return d && d >= rg.f && d <= rg.t;
          });
          if (!hit.length) { out.push(Object.assign({}, f, { empty: true })); step(); return; }
          hit.forEach(function (r, k) {
            out.push(Object.assign({}, f, {
              key: f.key + '#' + r.seq,
              nm: f.nm + ' (' + (r.dt || '') + ')',
              url: f.url + (f.url.indexOf('?') < 0 ? '?' : '&') + 'seq=' + r.seq,
              parentKey: f.key, order: k
            }));
          });
          step();
        });
      };
      step();
    });
  }

  /* 그 서식의 목록만 받아 온다 — 화면을 띄워 listFn 을 부른다(인쇄는 안 한다). */
  function askList(f) {
    return new Promise(function (resolve) {
      var box = gel('qpsBulkFrames'), ifr = document.createElement('iframe');
      ifr.style.cssText = 'width:1200px;height:900px;border:0;';
      var done = false;
      var fin = function (rows) {
        if (done) return; done = true;
        setTimeout(function () { try { box.removeChild(ifr); } catch (e) { } }, 200);
        resolve(rows || []);
      };
      ifr.onload = function () {
        var w = ifr.contentWindow, waited = 0;
        var tick = function () {
          if (done) return;
          if (typeof w[f.listFn] === 'function') {
            try { w[f.listFn]().then(function (rows) { fin(rows); }, function () { fin([]); }); }
            catch (e) { fin([]); }
            return;
          }
          waited += 200; if (waited > 6000) return fin([]);
          setTimeout(tick, 200);
        };
        setTimeout(tick, 300);
      };
      ifr.src = CTX + f.url + (f.url.indexOf('?') < 0 ? '?' : '&') + 'yy=' + year();
      box.appendChild(ifr);
      setTimeout(function () { fin([]); }, 12000);
    });
  }
  window.paYearChanged = function () {
    FORMS.forEach(function (f) { var el = gel('paSt_' + f.key); if (el) el.textContent = ''; });
    gel('paChkStat').textContent = '';
  };

  /* 이 해에 작성된 것이 있는지 — 서식마다 화면을 열어 인쇄할 내용이 나오는지 본다.
     ★자료가 없으면 그 화면이 인쇄를 그만두므로 아무것도 안 넘어온다 = 「없음」.
       인쇄와 같은 길로 확인하니, 여기서 「있음」이면 인쇄에도 그대로 나온다. */
  /* 여러 서식을 **한꺼번에** 본다(2026-09-07 「확인 오래 걸림」) — 하나씩 차례로 하면 서식 수만큼 기다림이 쌓인다.
     한 번에 셋씩 : 브라우저·서버에 무리가 없으면서 셋을 나란히 여는 만큼 빨라진다. */
  function pool(list, size, onEach, onDone) {
    var idx = 0, active = 0, fin = 0;
    var next = function () {
      if (fin >= list.length) { onDone(); return; }
      while (active < size && idx < list.length) {
        (function (f) {
          active++;
          grab(f).then(function () { active--; fin++; onEach(f, fin); next(); });
        })(list[idx++]);
      }
    };
    next();
  }

  window.paCheck = function () {
    if (running) return;
    running = true; parts = {}; gel('paChk').disabled = true; gel('paGo').disabled = true;
    FORMS.forEach(function (f) { var el = gel('paSt_' + f.key); if (el) { el.textContent = '…'; el.style.color = ''; } });
    var t0 = Date.now();
    expand(FORMS).then(function (jobs) {
      var found = {};                              // 서식(부모) 별로 몇 건 나왔나 — 기간이면 한 서식이 여러 건이 된다
      pool(jobs, 3, function (f, n) {
        var pk = f.parentKey || f.key, ok = parts[f.key] && parts[f.key].body;
        if (ok) found[pk] = (found[pk] || 0) + 1;
        var el = gel('paSt_' + pk);
        if (el) {
          var need = due(fdef(pk) && fdef(pk).cyc, range());
          el.textContent = found[pk] ? ('✔ ' + found[pk] + '건' + (need ? ' / ' + need : '')) : (need ? '— 0 / ' + need : '— 없음');
          el.style.color = found[pk] ? '#1f5a4b' : '#b0bcc4';
        }
        var cb = document.querySelector('#paList .paChk[value="' + pk + '"]');
        if (cb) cb.checked = !!found[pk];          // 나온 것만 미리 골라 둔다
        gel('paChkStat').textContent = '(' + n + '/' + jobs.length + ') 보는 중 …';
      }, function () {
        running = false; gel('paChk').disabled = false; gel('paGo').disabled = false;
        var forms = 0, docs = 0;
        FORMS.forEach(function (f) { if (found[f.key]) { forms++; docs += found[f.key]; } });
        var rg = range();
        gel('paChkStat').textContent = (rg ? (gel('paFrom').value + ' ~ ' + (gel('paTo').value || '오늘')) : (year() + '년')) +
          ' — 서식 ' + forms + '종 · ' + docs + '건 (' + ((Date.now() - t0) / 1000).toFixed(1) + '초)';
      });
    });
  };

  window.paToggleAll = function (el) {
    var cs = document.querySelectorAll('#paList .paChk');
    for (var i = 0; i < cs.length; i++) cs[i].checked = el.checked;
  };
  window.paClear = function () {
    var cs = document.querySelectorAll('#paList .paChk');
    for (var i = 0; i < cs.length; i++) cs[i].checked = false;
    gel('paAll').checked = false;
    gel('paStat').textContent = '';
  };

  /* 서식 하나 — 숨은 iframe 에 화면을 띄우고, 자료가 들어올 때를 기다렸다가 그 화면의 인쇄 함수를 부른다.
     결과는 sidebar.jsp 의 qpsPrintOut 이 postMessage 로 이 화면에 넘겨 준다. */
  function grab(f) {
    return new Promise(function (resolve) {
      var box = gel('qpsBulkFrames');
      var ifr = document.createElement('iframe');
      ifr.style.cssText = 'width:1200px;height:900px;border:0;';
      var done = false;
      var finish = function () {
        if (done) return; done = true;
        setTimeout(function () { try { box.removeChild(ifr); } catch (e) { } }, 200);
        resolve();
      };
      parts['__wait_' + f.key] = finish;                 // postMessage 가 오면 이걸 부른다
      ifr.onload = function () {
        var w = ifr.contentWindow;
        try { w.QPS_BULK = f.key; } catch (e) { finish(); return; }
        /* 자료가 들어오기를 **조용해질 때까지만** 기다린다(2026-09-07 「확인 오래 걸림」).
           종전에는 서식마다 무조건 2.6초를 기다렸다. 화면이 부르는 조회가 끝나면 더 받아올 것이 없으므로,
           내려받은 것(performance resource)이 늘지 않는 순간을 「다 됐다」로 본다 — 대개 1초 안쪽이다.
           ★못 재는 브라우저면 종전처럼 정해진 시간까지 기다린다. */
        var waited = 0, last = -1, quiet = 0;
        var call = function () {
          if (done) return;
          try {
            if (typeof w[f.fn] === 'function') w[f.fn]();
            else { finish(); return; }
          } catch (e) { finish(); return; }
          setTimeout(finish, 1200);                      // 넘어오지 않으면 그냥 넘어간다
        };
        var tick = function () {
          if (done) return;
          var n = -1;
          try { n = w.performance.getEntriesByType('resource').length; } catch (e) { }
          if (n < 0) { if (waited >= f.wait) return call(); }
          else if (n === last) { quiet++; } else { quiet = 0; last = n; }
          if (quiet >= 2 || waited >= f.wait) return call();   // 200ms 두 번 조용하면 다 온 것
          waited += 200; setTimeout(tick, 200);
        };
        setTimeout(tick, 300);
      };
      ifr.src = CTX + f.url + (f.url.indexOf('?') < 0 ? '?' : '&') + 'yy=' + year();   /* 고른 해로 연다(2026-09-07) */
      box.appendChild(ifr);
      setTimeout(finish, (f.wait || 2600) + 9000);       // 화면이 끝내 안 뜨면
    });
  }

  window.addEventListener('message', function (e) {
    var d = e.data;
    if (!d || d.type !== 'qpsPrintPart') return;
    parts[d.key] = { title: d.title, css: d.css, body: d.body };
    var cb = parts['__wait_' + d.key];
    if (typeof cb === 'function') cb();
  });

  window.paRun = function () {
    if (running) return;
    var picked = [];
    var cs = document.querySelectorAll('#paList .paChk');
    for (var i = 0; i < cs.length; i++) if (cs[i].checked) {
      for (var j = 0; j < FORMS.length; j++) if (FORMS[j].key === cs[i].value) picked.push(FORMS[j]);
    }
    if (!picked.length) { gel('paStat').textContent = '서식을 하나 이상 고르세요.'; return; }

    running = true; parts = {}; gel('paGo').disabled = true; gel('paChk').disabled = true;
    expand(picked).then(function (jobs) {           /* 기간이면 여러 건 서식이 건 단위로 펼쳐진다 */
      pool(jobs, 3, function (f, n) {
        gel('paStat').textContent = '(' + n + '/' + jobs.length + ') 받는 중 …';
      }, function () {
        gel('paChk').disabled = false;
        merge(jobs);                                /* 붙이는 차례는 고른 차례 그대로 — 먼저 끝난 순서가 아니다 */
      });
    });
  };

  /* 모은 것을 한 문서로 — 서식마다 CSS 가 다르므로 각각을 제 CSS 로 감싸고 사이를 새 장으로 넘긴다.
     ★인쇄 CSS 의 @page 는 문서에 하나만 먹는다. 첫 서식의 것을 쓰고, 나머지는 본문 규칙만 살린다. */
  function merge(picked) {
    var got = picked.filter(function (f) { return parts[f.key] && parts[f.key].body; });
    running = false; gel('paGo').disabled = false;
    if (!got.length) { gel('paStat').textContent = '가져온 서식이 없습니다 — 화면에서 낱장으로 먼저 확인해 주세요.'; return; }

    var css = '', bodyAll = '', seen = {};
    got.forEach(function (f, idx) {
      var p = parts[f.key];
      if (!seen[p.css]) { seen[p.css] = 1; css += p.css; }        // 같은 CSS 는 한 번만
      bodyAll += '<div class="qps-part"' + (idx ? ' style="page-break-before:always;"' : '') + '>' + p.body + '</div>';
    });
    css += '.qps-part{ break-inside:auto; }';

    var w = window.open('', '_blank', 'width=980,height=1000');
    if (!w) { gel('paStat').textContent = '팝업이 막혀 인쇄창을 열지 못했습니다 — 주소창 오른쪽에서 허용해 주세요.'; return; }
    w.document.open();
    w.document.write('<!doctype html><html lang="ko"><head><meta charset="utf-8"><title>QPS 일괄 출력</title>' +
                     '<style>' + css + '</style></head><body>' + bodyAll + '</body></html>');
    w.document.close();
    w.focus();
    if (typeof qpsPrintGo === 'function') qpsPrintGo(w, 5000);
    gel('paStat').textContent = got.length + '종을 이어 붙였습니다.' +
      (got.length < picked.length ? ' (' + (picked.length - got.length) + '종은 못 가져왔습니다)' : '');
  };
})();
</script>
</div><%-- /.dashboard-wrapper --%>
