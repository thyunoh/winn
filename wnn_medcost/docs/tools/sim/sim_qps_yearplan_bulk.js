// 연 문서 3종(활동계획서·만족도 조사 계획서·불만고충 처리계획서) 화면 안 일괄 출력(2026-09-08) — 해 순회·저장된 해 거르기·복귀
const fs = require('fs');
const path = require('path');
const { JSDOM } = require('jsdom');
function grab(s, re, name){ const m = s.match(re); if (!m) throw new Error('못 찾음: ' + name); return m[0]; }

let pass = 0, fail = 0;
const ok = (n, c) => { if (c) { pass++; console.log('  ✅', n); } else { fail++; console.log('  ❌', n); } };
const until = f => new Promise(res => { (function t(){ if (f()) return res(); setTimeout(t, 5); })(); });
const YEARS = '<option value="2027">2027년</option><option value="2026">2026년</option><option value="2025">2025년</option><option value="2024">2024년</option>';

function harness(cfg){
  const s = fs.readFileSync(path.resolve(__dirname, '../../../src/main/webapp/WEB-INF/jsp/main/qpsmgr/' + cfg.file + '.jsp'), 'utf8');
  const p = cfg.p;
  const bpDef  = grab(s, /\n  window\.BP = \{ busy:false \};/, 'BP');
  const fill   = grab(s, /\n  function bpFill\(\)\{[\s\S]*?\n  \}/, 'bpFill');
  const toggle = grab(s, new RegExp('\\n  window\\.' + p + 'BulkPrintToggle = function\\(\\)\\{[\\s\\S]*?\\n  \\};'), 'toggle');
  const go     = grab(s, new RegExp('\\n  window\\.' + p + 'BulkPrintGo = function\\(\\)\\{[\\s\\S]*?\\n  \\};'), 'go');
  const extra  = cfg.gb ? grab(s, /\n  function \$id\(id\)\{[^\n]*\}/, '$id') + grab(s, /\n  function plGbNm\(v\)\{[^\n]*\}/, 'plGbNm') : '';
  const dom = new JSDOM(
    (cfg.gb ? '<select id="plGb"><option value="Q">질향상·환자안전</option><option value="I">감염관리</option></select>' : '') +
    '<select id="' + p + 'Year">' + YEARS + '</select>' +
    '<div id="' + p + 'BulkPrintBox" style="display:none;">' +
    (cfg.gb ? '<label><input type="radio" name="plBpScope" value="F" checked></label><label><input type="radio" name="plBpScope" value="A"></label><span id="plBpGbNm"></span>' : '') +
    '<select id="' + p + 'BpFrom"></select><select id="' + p + 'BpTo"></select>' +
    '<button id="' + p + 'BpGo"></button><span id="' + p + 'BpStat"></span></div>');
  const { window } = dom; const { document } = window;
  document.getElementById(p + 'Year').value = '2026';
  const state = { docs: [], loads: [], merges: [], fail: '' };
  const ctx = { window, document, Option: window.Option, Promise, state,
    qpsPrintMerge: (parts, title) => { state.merges.push({ n: parts.length, title, bodies: parts.map(x => x.body) }); return parts.length; } };
  const key = cfg.gb ? '(plGb() + ":" + document.getElementById("plYear").value)' : 'document.getElementById("' + p + 'Year").value';
  const code =
    'var HOSP_NM = "한마음병원";' +
    '\nfunction gel(id){ return document.getElementById(id); }' +
    (cfg.gb ? '\nfunction plGb(){ var e = document.getElementById("plGb"); return e ? e.value : "Q"; }' : '') +
    '\nfunction ' + p + 'Load(){ var k = ' + key + '; state.loads.push(k); LAST_DOC = false;' +
    '\n  return Promise.resolve().then(function(){ if (state.fail === k) return; LAST_DOC = state.docs.indexOf(k) >= 0; }); }' +
    '\nfunction ' + p + 'Print(){ if (window.QPS_BULK_CB) window.QPS_BULK_CB({ title:"t", css:"@page{ size:A4; }", body:"doc:" + ' + key + ' }); }' +
    bpDef + '\nvar BP = window.BP; var LAST_DOC = false;' + extra + fill + toggle + go +
    '\nreturn { toggle: window.' + p + 'BulkPrintToggle, go: window.' + p + 'BulkPrintGo, BP: window.BP };';
  const M = new Function(...Object.keys(ctx), code)(...Object.values(ctx));
  return { M, state, document, $: id => document.getElementById(id) };
}

(async function(){
  for (const cfg of [{ p:'sp', file:'qpsSrvPlan', nm:'만족도 계획서', t:'만족도조사계획서' }, { p:'cp', file:'qpsCmplPlan', nm:'불만고충 계획서', t:'불만고충처리계획서' }]) {
    const { M, state, $ } = harness(cfg), p = cfg.p;
    M.toggle();
    ok(cfg.nm + ' — 열림 + 연도 칸이 화면 연도 목록(4개)·보던 해(2026)', $(p + 'BulkPrintBox').style.display === '' &&
       $(p + 'BpFrom').options.length === 4 && $(p + 'BpFrom').value === '2026' && $(p + 'BpTo').value === '2026');
    state.docs = ['2024', '2026'];
    $(p + 'BpFrom').value = '2024'; $(p + 'BpTo').value = '2027';
    M.go(); await until(() => !M.BP.busy);
    ok(cfg.nm + ' — 2024~2027 오름차순 순회, 저장된 2024·2026 두 부', state.loads.slice(0, 4).join(',') === '2024,2025,2026,2027' &&
       state.merges[0].bodies.join(',') === 'doc:2024,doc:2026');
    ok(cfg.nm + ' — 제목 · 복귀(2026)', state.merges[0].title === cfg.t + '_2024~2027년_한마음병원' && $(p + 'Year').value === '2026' &&
       state.loads[state.loads.length - 1] === '2026');
    state.fail = '2026'; state.merges.length = 0;
    M.go(); await until(() => !M.BP.busy);
    ok(cfg.nm + ' — 2026 조회 실패 → 2024 한 부만', state.merges[0].bodies.join(',') === 'doc:2024');
    state.fail = '';
    $(p + 'BpFrom').value = '2027'; $(p + 'BpTo').value = '2025'; state.merges.length = 0;
    M.go(); await until(() => !M.BP.busy);
    ok(cfg.nm + ' — 뒤집힌 범위 바로잡아 2025~2027 → 2026 한 부, 한 해 제목', $(p + 'BpFrom').value === '2025' && state.merges[0].bodies.join(',') === 'doc:2026');
    $(p + 'BpFrom').value = '2027'; $(p + 'BpTo').value = '2027'; state.merges.length = 0;
    M.go(); await until(() => !M.BP.busy);
    ok(cfg.nm + ' — 저장 없는 해 → 0부 안내', state.merges.length === 0 && /없습니다/.test($(p + 'BpStat').textContent));
  }
  {
    const { M, state, $ } = harness({ p:'pl', file:'qpsPlan', gb:true });
    $('plGb').value = 'I'; M.toggle();
    ok('활동계획서 — 이름표 감염관리 · 연도 기본 = 보던 해', /감염관리/.test($('plBpGbNm').textContent) && $('plBpFrom').value === '2026');
    state.docs = ['Q:2025', 'Q:2026', 'I:2026'];
    $('plBpFrom').value = '2025'; $('plBpTo').value = '2026';
    M.go(); await until(() => !M.BP.busy);
    ok('활동계획서 — 이 구분(I) 2025~2026 → I:2026 한 부', state.merges[0].bodies.join(',') === 'doc:I:2026' &&
       state.merges[0].title === '활동계획서_2025~2026년_감염관리_한마음병원');
    $('plBulkPrintBox').querySelectorAll('input[name=plBpScope]')[1].checked = true; state.merges.length = 0; state.loads.length = 0;
    M.go(); await until(() => !M.BP.busy);
    ok('활동계획서 — 둘 다 → Q 2025·2026 + I 2026 = 3부, 구분마다 해를 돈다', state.merges[0].bodies.join(',') === 'doc:Q:2025,doc:Q:2026,doc:I:2026' &&
       state.loads.slice(0, 4).join(',') === 'Q:2025,Q:2026,I:2025,I:2026');
    ok('활동계획서 — 둘 다 제목 · 복귀(I/2026)', state.merges[0].title === '활동계획서_2025~2026년_전체_한마음병원' && $('plGb').value === 'I' && $('plYear').value === '2026');
  }
  console.log('\n통과 ' + pass + ' · 실패 ' + fail);
  process.exit(fail ? 1 : 0);
})();
