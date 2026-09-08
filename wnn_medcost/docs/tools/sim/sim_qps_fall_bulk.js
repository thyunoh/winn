// 지표별 연간 분석보고서(qpsFall) 화면 안 일괄 출력(2026-09-08)
// ★이 화면은 목록이 없다 — 「한 지표 × 연도 × 회차(분기·반기)」가 문서 단위이고, 해를 옮기면 수치를 통째로 다시 계산한다.
//   그래서 ①해마다 qfReload ②회차마다 qfReportLoad ③확인창은 맨 처음 한 번 ④못 받은 해·회차는 건너뛴다 를 본다.
const fs = require('fs');
const path = require('path');
const { JSDOM } = require('jsdom');
function grab(s, re, name){ const m = s.match(re); if (!m) throw new Error('못 찾음: ' + name); return m[0]; }
// ⚠작업본은 CRLF 다 — 줄 끝을 먼저 고르게 만든다(안 그러면 `\n  };` 앵커가 \r 때문에 빗나간다)
const S = fs.readFileSync(path.resolve(__dirname, '../../../src/main/webapp/WEB-INF/jsp/main/qpsmgr/qpsFall.jsp'), 'utf8')
            .replace(/\r\n/g, '\n').replace(/<c:url value="([^"]*)"\/>/g, '$1');

let pass = 0, fail = 0;
const ok = (n, c) => { if (c) { pass++; console.log('  ✅', n); } else { fail++; console.log('  ❌', n); } };
const until = f => new Promise(res => { (function t(){ if (f()) return res(); setTimeout(t, 5); })(); });

function build(){
  const dom = new JSDOM(
    '<select id="qfYear"><option value="2027">2027년</option><option value="2026">2026년</option><option value="2025">2025년</option></select>' +
    '<select id="qfPrdKey"><option value="Q1">1/4 분기</option><option value="Q2">2/4 분기</option><option value="Q3">3/4 분기</option>' +
    '<option value="Q4">4/4 분기</option><option value="H1">중간(상반기)</option><option value="H2">최종(하반기)</option></select>' +
    '<div id="qfBulkPrintBox" style="display:none;"><select id="qfBpFrom"></select><select id="qfBpTo"></select>' +
    '<select id="qfBpPrd"><option value="ONE">지금 회차</option><option value="Q" selected>분기</option><option value="A">전부</option></select>' +
    '<span id="qfBpPrdNm"></span><input type="checkbox" id="qfBpDone" checked><button id="qfBpGo"></button><span id="qfBpStat"></span></div>');
  const { window } = dom, { document } = window;
  const state = { reloads: [], rptLoads: [], merges: [], prints: [], failYear: [], failPrd: [], written: [], asks: [], confirmAuto: true };
  const ctx = { window, document, Option: window.Option, Promise, state,
    qpsPrintMerge: (parts, title) => { state.merges.push({ title, bodies: parts.map(x => x.body) }); return parts.length; },
    _confirmBox: (o) => { state.asks.push(o.msg); if (state.confirmAuto) o.onOk(); } };
  const code =
    'var CALC_YY = "", RPT_KEY = "", LAST_RPT = false, curDef = { indinm: "낙상 발생 보고율" }, HOSP_NM = "한마음병원";' +
    '\nfunction year(){ return document.getElementById("qfYear").value; }' +
    '\nfunction esc(s){ return String(s == null ? "" : s); }' +
    // 해 하나를 통째로 다시 읽는다 — 실패하면 CALC_YY 를 안 세운다(앞 해 수치가 남는 상황)
    '\nfunction qfReload(){ var yy = year(); state.reloads.push(yy); CALC_YY = "";' +
    '\n  return new Promise(function(res){ setTimeout(function(){ if (state.failYear.indexOf(yy) < 0) CALC_YY = yy; res(); }, 1); }); }' +
    // 회차 하나의 서술·결재 — state.written 에 있는 회차만 「작성됨」
    '\nfunction qfReportLoad(){ var k = year() + document.getElementById("qfPrdKey").value; state.rptLoads.push(k); RPT_KEY = ""; LAST_RPT = false;' +
    '\n  return new Promise(function(res){ setTimeout(function(){ if (state.failPrd.indexOf(k) < 0) { RPT_KEY = k; LAST_RPT = state.written.indexOf(k) >= 0; } res(); }, 1); }); }' +
    // 인쇄 — 지금 화면에 올라온 해·회차를 찍는다(일괄이면 확인창 없이)
    '\nwindow.qfPrint = function(opts){ var done = (opts && opts.done) || null;' +
    '\n  setTimeout(function(){ var tag = year() + document.getElementById("qfPrdKey").value;' +
    '\n    state.prints.push({ tag: tag, noAsk: !!(opts && opts.noAsk) });' +
    '\n    if (window.QPS_BULK_CB) window.QPS_BULK_CB({ title:"t", css:"@page{ size:A4 portrait; }", body:"doc:" + tag });' +
    '\n    if (done) done(true); }, 1); };' +
    '\nvar qfPrint = window.qfPrint;' +   // 화면에선 전역이라 그냥 불린다 — 시뮬은 별칭을 만들어 준다
    grab(S, /\n  window\.BP = \{ busy:false \};/, 'BP') + '\nvar BP = window.BP;' +
    grab(S, /\n  var BP_PRDS = \{[^\n]*\};/, 'BP_PRDS') +
    grab(S, /\n  function bpFill\(\)\{[\s\S]*?\n  \}/, 'bpFill') +
    grab(S, /\n  function bpPrdNm\(k\)\{[^\n]*\}/, 'bpPrdNm') +
    grab(S, /\n  window\.qfBulkPrintToggle = function\(\)\{[\s\S]*?\n  \};/, 'toggle') +
    grab(S, /\n  window\.qfBulkPrintGo = function\(\)\{[\s\S]*?\n  \};/, 'go') +
    '\nreturn { toggle: window.qfBulkPrintToggle, go: window.qfBulkPrintGo, BP: window.BP };';
  const M = new Function(...Object.keys(ctx), code)(...Object.values(ctx));
  return { M, state, document, $: id => document.getElementById(id) };
}

(async function(){
  const { M, state, $ } = build();
  $('qfYear').value = '2026'; $('qfPrdKey').value = 'Q2';
  state.written = ['2026Q1', '2026Q2', '2026H1', '2025Q4'];

  M.toggle();
  ok('열림 + 연도 칸이 화면 연도 목록(3개)·보던 해 · 지금 회차 안내', $('qfBulkPrintBox').style.display === '' &&
     $('qfBpFrom').options.length === 3 && $('qfBpFrom').value === '2026' && /2\/4 분기/.test($('qfBpPrdNm').textContent));

  M.go(); await until(() => !M.BP.busy);
  ok('분기 4회 · 작성된 회차만 → 2026 Q1·Q2 두 부(H1 은 분기가 아니라 제외)', state.merges[0].bodies.join(',') === 'doc:2026Q1,doc:2026Q2');
  ok('병원 확인은 맨 처음 한 번만 · 인쇄는 확인창 없이', state.asks.length === 1 && state.prints.every(p => p.noAsk) &&
     state.merges[0].title === '낙상 발생 보고율 지표분석보고서_2026년_한마음병원');
  ok('끝나면 보던 해·회차로 되돌리고 자료를 다시 읽는다', $('qfYear').value === '2026' && $('qfPrdKey').value === 'Q2' &&
     state.reloads[state.reloads.length - 1] === '2026');

  $('qfBpPrd').value = 'A'; state.merges.length = 0; state.asks.length = 0;
  M.go(); await until(() => !M.BP.busy);
  ok('분기·반기 6회 → 2026 Q1·Q2·H1 세 부(차례는 Q1~Q4·H1·H2)', state.merges[0].bodies.join(',') === 'doc:2026Q1,doc:2026Q2,doc:2026H1');

  $('qfBpDone').checked = false; state.merges.length = 0;
  M.go(); await until(() => !M.BP.busy);
  ok('체크를 끄면 안 쓴 회차도 6부 전부', state.merges[0].bodies.join(',') === 'doc:2026Q1,doc:2026Q2,doc:2026Q3,doc:2026Q4,doc:2026H1,doc:2026H2');

  $('qfBpDone').checked = true; $('qfBpPrd').value = 'ONE'; state.merges.length = 0;
  M.go(); await until(() => !M.BP.busy);
  ok('지금 고른 회차만(Q2) → 한 부', state.merges[0].bodies.join(',') === 'doc:2026Q2');

  $('qfBpPrd').value = 'Q'; $('qfBpFrom').value = '2025'; $('qfBpTo').value = '2026';
  state.merges.length = 0; state.reloads.length = 0;
  M.go(); await until(() => !M.BP.busy);
  ok('2025~2026 → 해마다 자료를 다시 읽고(2025·2026) 2025Q4 + 2026Q1·Q2 세 부',
     state.merges[0].bodies.join(',') === 'doc:2025Q4,doc:2026Q1,doc:2026Q2' && state.reloads.slice(0, 2).join(',') === '2025,2026');
  ok('제목에 연도 범위', state.merges[0].title === '낙상 발생 보고율 지표분석보고서_2025~2026년_한마음병원');

  state.failYear = ['2025']; state.merges.length = 0;
  M.go(); await until(() => !M.BP.busy);
  ok('2025 수치를 못 받으면 그 해를 통째로 건너뛴다(앞 해 수치가 2025 이름으로 찍히지 않는다)',
     state.merges[0].bodies.join(',') === 'doc:2026Q1,doc:2026Q2');

  state.failYear = []; state.failPrd = ['2026Q1']; state.merges.length = 0;
  M.go(); await until(() => !M.BP.busy);
  ok('회차 서술을 못 받으면 그 회차만 건너뛴다', state.merges[0].bodies.join(',') === 'doc:2025Q4,doc:2026Q2');

  state.failPrd = []; $('qfBpFrom').value = '2027'; $('qfBpTo').value = '2027'; state.merges.length = 0;
  M.go(); await until(() => !M.BP.busy);
  ok('작성된 회차가 없는 해 → 0부 안내 · 단추 되살아남', state.merges.length === 0 &&
     /없습니다/.test($('qfBpStat').textContent) && !$('qfBpGo').disabled);

  $('qfBpFrom').value = '2026'; $('qfBpTo').value = '2025'; state.merges.length = 0;
  M.go(); await until(() => !M.BP.busy);
  ok('뒤집힌 범위를 바로잡는다', $('qfBpFrom').value === '2025' && $('qfBpTo').value === '2026' && state.merges[0].bodies.length === 3);

  state.confirmAuto = false; state.merges.length = 0; state.asks.length = 0;
  M.go();
  await new Promise(r => setTimeout(r, 30));
  ok('확인창에서 취소하면 아무것도 안 돈다', state.asks.length === 1 && state.merges.length === 0 && !M.BP.busy && !$('qfBpGo').disabled);

  ok('소스 — qfPrint 가 noAsk·done 을 받고 qfReload·qfReportLoad 가 프라미스를 돌려준다',
     /window\.qfPrint = function\(opts\)\{/.test(S) && /if \(opts && opts\.noAsk\) \{ out\(\); if \(done\) done\(true\); return; \}/.test(S) &&
     /return indiLoad\(\)\.then\(censusLoad\)/.test(S) && /return post\('\/qps\/reportGet\.do'/.test(S));
  ok('소스 — 해·회차 표식(CALC_YY·RPT_KEY)을 먼저 비우고 성공했을 때만 세운다',
     /CALC_YY = '';   \/\/ ★먼저 비운다/.test(S) && /RPT_KEY = ''; LAST_RPT = false;/.test(S) && /CALC_YY = my;/.test(S) && /RPT_KEY = p\.key;/.test(S));

  console.log('\n통과 ' + pass + ' · 실패 ' + fail);
  process.exit(fail ? 1 : 0);
})();
