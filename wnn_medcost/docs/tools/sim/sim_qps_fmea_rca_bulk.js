// FMEA(구분×연도 목록)·RCA(연도 + 발생일 월 범위) 화면 안 일괄 출력(2026-09-08) — 순회·거르기·실패 건너뜀·복귀
const fs = require('fs');
const path = require('path');
const { JSDOM } = require('jsdom');
function grab(s, re, name){ const m = s.match(re); if (!m) throw new Error('못 찾음: ' + name); return m[0]; }
function src(f){ return fs.readFileSync(path.resolve(__dirname, '../../../src/main/webapp/WEB-INF/jsp/main/qpsmgr/' + f + '.jsp'), 'utf8'); }

let pass = 0, fail = 0;
const ok = (n, c) => { if (c) { pass++; console.log('  ✅', n); } else { fail++; console.log('  ❌', n); } };
const until = f => new Promise(res => { (function t(){ if (f()) return res(); setTimeout(t, 5); })(); });
const YEARS = '<option value="2027">2027년</option><option value="2026">2026년</option><option value="2025">2025년</option><option value="2024">2024년</option>';
function common(s, p){
  return grab(s, /\n  window\.BP = \{ busy:false \};/, 'BP') + '\nvar BP = window.BP;' +
         grab(s, /\n  function bpFill\(\)\{[\s\S]*?\n  \}/, 'bpFill') +
         grab(s, new RegExp('\\n  window\\.' + p + 'BulkPrintToggle = function\\(\\)\\{[\\s\\S]*?\\n  \\};'), 'toggle') +
         grab(s, new RegExp('\\n  window\\.' + p + 'BulkPrintGo = function\\(\\)\\{[\\s\\S]*?\\n  \\};'), 'go');
}
function build(html, code){
  const dom = new JSDOM(html); const { window } = dom; const { document } = window;
  const state = { lists: {}, loads: [], merges: [], fail: [], alerts: [] };
  const ctx = { window, document, Option: window.Option, Promise, state,
    qpsPrintMerge: (parts, title) => { state.merges.push({ n: parts.length, title, bodies: parts.map(x => x.body) }); return parts.length; },
    _alertBox: m => state.alerts.push(m) };
  const M = new Function(...Object.keys(ctx), code)(...Object.values(ctx));
  return { M, state, document, $: id => document.getElementById(id) };
}

(async function(){
  // ── 1. FMEA — 구분(P/R)×연도 ─────────────────────────────────────────
  {
    const s = src('qpsFmea');
    const html = '<div id="qpsFmea"><select id="fmGb"><option value="P">계획서</option><option value="R">보고서</option></select><select id="fmYear">' + YEARS + '</select>' +
      '<div id="fmBulkPrintBox" style="display:none;"><label><input type="radio" name="fmBpScope" value="F" checked></label><label><input type="radio" name="fmBpScope" value="A"></label><span id="fmBpGbNm"></span>' +
      '<select id="fmBpFrom"></select><select id="fmBpTo"></select><button id="fmBpGo"></button><span id="fmBpStat"></span></div>' +
      '<span id="fmTitle"></span><div class="rptonly"></div><div id="cardScale"></div></div>';
    const code = 'var HOSP_NM = "한마음병원", LIST = [], curSeq = 0;' +
      '\nfunction gel(id){ return document.getElementById(id); } function gb(){ return gel("fmGb").value || "P"; }' +
      '\nfunction fmLoad(){ var k = gb() + ":" + gel("fmYear").value; state.loads.push(k); return Promise.resolve().then(function(){ LIST = state.lists[k] || []; }); }' +
      '\nfunction fmOpen(seq){ return Promise.resolve().then(function(){ if (state.fail.indexOf(seq) < 0) curSeq = seq; }); }' +
      '\nfunction fmNew(){ curSeq = 0; }' +
      '\nfunction fmPrint(){ if (window.QPS_BULK_CB) window.QPS_BULK_CB({ title:"t", css:"@page{ size:A4 portrait; }", body:"doc:" + curSeq + "/" + gb() + "/" + gel("fmTitle").textContent }); }' +
      grab(s, /\n  function fmGbNm\(v\)\{[^\n]*\}/, 'fmGbNm') + common(s, 'fm') +
      '\nreturn { toggle: window.fmBulkPrintToggle, go: window.fmBulkPrintGo, BP: window.BP, cur: function(){ return curSeq; } };';
    const { M, state, $ } = build(html, code);
    state.lists = { 'P:2026': [{ fmeseq: 11 }, { fmeseq: 12 }], 'R:2026': [{ fmeseq: 21 }], 'P:2025': [{ fmeseq: 5 }] };
    $('fmGb').value = 'R'; $('fmYear').value = '2026'; M.toggle();
    ok('FMEA — 열림 + 이름표 「보고서」·연도 4개·보던 해', /보고서/.test($('fmBpGbNm').textContent) && $('fmBpFrom').options.length === 4 && $('fmBpTo').value === '2026');
    M.go(); await until(() => !M.BP.busy);
    ok('FMEA — 이 구분(R) 2026 → 21 한 부, 카드 표시(제목)도 보고서로 맞춰 찍힘', state.merges[0].bodies.join(',') === 'doc:21/R/FMEA 보고서' &&
       state.merges[0].title === 'FMEA_2026년_보고서_한마음병원');
    $('fmBulkPrintBox').querySelectorAll('input[name=fmBpScope]')[1].checked = true;
    $('fmBpFrom').value = '2025'; $('fmBpTo').value = '2026'; state.merges.length = 0; state.loads.length = 0;
    M.go(); await until(() => !M.BP.busy);
    ok('FMEA — 둘 다 2025~2026 → P 2025·2026 뒤 R 2026 = 4부, 계획서 장은 계획서 제목', state.merges[0].bodies.join(',') === 'doc:5/P/FMEA 계획서,doc:11/P/FMEA 계획서,doc:12/P/FMEA 계획서,doc:21/R/FMEA 보고서' &&
       state.loads.slice(0, 4).join(',') === 'P:2025,P:2026,R:2025,R:2026');
    ok('FMEA — 둘 다 제목 · 복귀(R/2026) · 열려 있던 것 없어 새 문서', state.merges[0].title === 'FMEA_2025~2026년_계획서·보고서_한마음병원' && $('fmGb').value === 'R' && $('fmYear').value === '2026' && M.cur() === 0);
    state.fail = [11]; state.merges.length = 0;
    M.go(); await until(() => !M.BP.busy);
    ok('FMEA — 11 열기 실패 → 건너뛴다', state.merges[0].bodies.map(b => b.split('/')[0]).join(',') === 'doc:5,doc:12,doc:21');
    state.fail = []; $('fmBpFrom').value = '2027'; $('fmBpTo').value = '2027'; state.merges.length = 0;
    M.go(); await until(() => !M.BP.busy);
    ok('FMEA — 빈 해 → 0부 안내', state.merges.length === 0 && /없습니다/.test($('fmBpStat').textContent) && !$('fmBpGo').disabled);
    ok('FMEA — fmOpen 프라미스 반환 · 일괄 중 fmLoad 생략(소스)', /return post\('[^']*fmeaGet[^']*'/.test(s) && /if \(!\(window\.BP && BP\.busy\)\) fmLoad\(\);/.test(s));
  }

  // ── 2. RCA — 연도 + 발생일 월 범위 ───────────────────────────────────
  {
    const s = src('qpsRca');
    const html = '<select id="rcYear">' + YEARS + '</select>' +
      '<div id="rcBulkPrintBox" style="display:none;"><select id="rcBpYear"></select><select id="rcBpFrom"></select><select id="rcBpTo"></select><button id="rcBpGo"></button><span id="rcBpStat"></span></div>';
    const code = 'var HOSP_NM = "한마음병원", LIST = [], curSeq = 0;' +
      '\nfunction gel(id){ return document.getElementById(id); }' +
      '\nfunction rcLoad(){ var y = gel("rcYear").value; state.loads.push(y); return Promise.resolve().then(function(){ LIST = state.lists[y] || []; }); }' +
      '\nfunction rcOpen(seq){ return Promise.resolve().then(function(){ if (state.fail.indexOf(seq) < 0) curSeq = seq; }); }' +
      '\nfunction rcNew(){ curSeq = 0; }' +
      '\nfunction rcPrint(){ if (window.QPS_BULK_CB) window.QPS_BULK_CB({ title:"t", css:"@page{ size:A4 portrait; }", body:"doc:" + curSeq }); }' +
      grab(s, /\n  function bpInRange\(r, f, t\)\{[\s\S]*?\n  \}/, 'bpInRange') + common(s, 'rc') +
      '\nreturn { toggle: window.rcBulkPrintToggle, go: window.rcBulkPrintGo, BP: window.BP, cur: function(){ return curSeq; } };';
    const { M, state, $ } = build(html, code);
    state.lists = { '2026': [{ rcaseq: 1, occurdt: '2026-01-15' }, { rcaseq: 2, occurdt: '20260420' }, { rcaseq: 3, occurdt: '2026-09-02' }, { rcaseq: 4, occurdt: '' }], '2025': [{ rcaseq: 9, occurdt: '2025-12-31' }] };
    $('rcYear').value = '2026'; M.toggle();
    ok('RCA — 열림 + 연도 = 보던 해 · 월 1~12 기본', $('rcBpYear').value === '2026' && $('rcBpFrom').value === '1' && $('rcBpTo').value === '12' && $('rcBpFrom').options.length === 12);
    M.go(); await until(() => !M.BP.busy);
    ok('RCA — 그 해 전부 → 발생일 있는 1·2·3(하이픈·무하이픈 다 읽음), 발생일 없는 4 제외', state.merges[0].bodies.join(',') === 'doc:1,doc:2,doc:3' && state.merges[0].title === 'RCA근본원인분석_2026년_한마음병원');
    $('rcBpFrom').value = '4'; $('rcBpTo').value = '9'; state.merges.length = 0;
    M.go(); await until(() => !M.BP.busy);
    ok('RCA — 4~9월 → 2·3 두 부, 제목에 월 범위', state.merges[0].bodies.join(',') === 'doc:2,doc:3' && state.merges[0].title === 'RCA근본원인분석_2026년_4~9월_한마음병원');
    $('rcBpFrom').value = '9'; $('rcBpTo').value = '4'; state.merges.length = 0;
    M.go(); await until(() => !M.BP.busy);
    ok('RCA — 뒤집힌 범위 바로잡음', $('rcBpFrom').value === '4' && $('rcBpTo').value === '9' && state.merges[0].bodies.join(',') === 'doc:2,doc:3');
    $('rcBpYear').value = '2025'; $('rcBpFrom').value = '1'; $('rcBpTo').value = '12'; state.merges.length = 0; state.fail = [9];
    M.go(); await until(() => !M.BP.busy);
    ok('RCA — 다른 해(2025) 골라 돌리고 9 열기 실패 → 0부 안내 · 보던 해(2026) 복귀', state.merges.length === 0 && /없습니다/.test($('rcBpStat').textContent) && $('rcYear').value === '2026' && state.loads[state.loads.length - 1] === '2026');
    state.fail = []; $('rcBpFrom').value = '2'; $('rcBpTo').value = '3'; $('rcBpYear').value = '2026'; state.merges.length = 0;
    M.go(); await until(() => !M.BP.busy);
    ok('RCA — 2~3월 = 해당 없음 → 0부', state.merges.length === 0 && !M.BP.busy && !$('rcBpGo').disabled);
    ok('RCA — rcOpen 프라미스 반환 · 일괄 중 rcLoad 생략(소스)', /return post\('[^']*rcaGet[^']*'/.test(s) && /if \(!\(window\.BP && BP\.busy\)\) rcLoad\(\);/.test(s));
  }

  console.log('\n통과 ' + pass + ' · 실패 ' + fail);
  process.exit(fail ? 1 : 0);
})();
