// 월 문서 3종(라운딩·격리일지·유치도뇨) 화면 안 일괄 출력(2026-09-08) — 소스 JSP 에서 달 순회·저장된 달 거르기·복귀 논리를 꺼내 가짜 DOM 으로 돌린다
const fs = require('fs');
const path = require('path');
const { JSDOM } = require('jsdom');
function grab(s, re, name){ const m = s.match(re); if (!m) throw new Error('못 찾음: ' + name); return m[0]; }

let pass = 0, fail = 0;
const ok = (n, c) => { if (c) { pass++; console.log('  ✅', n); } else { fail++; console.log('  ❌', n); } };
const until = f => new Promise(res => { (function t(){ if (f()) return res(); setTimeout(t, 5); })(); });

function harness(cfg){
  const s = fs.readFileSync(path.resolve(__dirname, '../../../src/main/webapp/WEB-INF/jsp/main/qpsmgr/' + cfg.file + '.jsp'), 'utf8');
  const p = cfg.p;
  const bpDef  = grab(s, /\n  window\.BP = \{ busy:false \};/, 'BP');
  const fill   = grab(s, /\n  function bpFill\(\)\{[\s\S]*?\n  \}/, 'bpFill');
  const toggle = grab(s, new RegExp('\\n  window\\.' + p + 'BulkPrintToggle = function\\(\\)\\{[\\s\\S]*?\\n  \\};'), 'toggle');
  const go     = grab(s, new RegExp('\\n  window\\.' + p + 'BulkPrintGo = function\\(\\)\\{[\\s\\S]*?\\n  \\};'), 'go');
  const extra  = cfg.gb ? grab(s, /\n  function \$id\(id\)\{[^\n]*\}/, '$id') + grab(s, /\n  function rdGbNm\(v\)\{[^\n]*\}/, 'rdGbNm') : '';
  const dom = new JSDOM(
    (cfg.gb ? '<select id="rdGb"><option value="Q">질향상·환자안전</option><option value="I">감염관리</option></select>' : '') +
    '<input id="' + p + 'Ym" value="2026-09">' +
    '<div id="' + p + 'BulkPrintBox" style="display:none;">' +
    (cfg.gb ? '<label><input type="radio" name="rdBpScope" value="F" checked></label><label><input type="radio" name="rdBpScope" value="A"></label><span id="rdBpGbNm"></span>' : '') +
    '<select id="' + p + 'BpYear"></select><select id="' + p + 'BpFrom"></select><select id="' + p + 'BpTo"></select>' +
    '<button id="' + p + 'BpGo"></button><span id="' + p + 'BpStat"></span></div>');
  const { window } = dom; const { document } = window;
  const state = { docs: [], loads: [], merges: [], fail: '' };
  const ctx = { window, document, Option: window.Option, Promise, state,
    qpsPrintMerge: (parts, title) => { state.merges.push({ n: parts.length, title, bodies: parts.map(x => x.body) }); return parts.length; } };
  const key = cfg.gb ? '(rdGb() + ":" + ym())' : 'ym()';
  const code =
    'var LAST_DOC = false, HOSP_NM = "한마음병원";' +
    '\nfunction gel(id){ return document.getElementById(id); }' +
    '\nfunction ym(){ return document.getElementById("' + p + 'Ym").value.replace("-", ""); }' +
    (cfg.gb ? '\nfunction rdGb(){ var e = document.getElementById("rdGb"); return e ? e.value : "Q"; }' : '') +
    '\nfunction ' + p + 'Load(){ var k = ' + key + '; state.loads.push(k); LAST_DOC = false;' +
    '\n  return Promise.resolve().then(function(){ if (state.fail === k) return; LAST_DOC = state.docs.indexOf(k) >= 0; }); }' +
    '\nfunction ' + p + 'Print(){ if (window.QPS_BULK_CB) window.QPS_BULK_CB({ title:"t", css:"@page{ size:A4; }", body:"doc:" + ' + key + ' }); }' +
    bpDef + '\nvar BP = window.BP;' + extra + fill + toggle + go +
    '\nreturn { toggle: window.' + p + 'BulkPrintToggle, go: window.' + p + 'BulkPrintGo, BP: window.BP, lastDoc: () => LAST_DOC };';
  const M = new Function(...Object.keys(ctx), code)(...Object.values(ctx));
  return { M, state, document, $: id => document.getElementById(id) };
}

(async function(){
  // ── 격리일지·유치도뇨 : 연도 + 월 범위 ──
  for (const cfg of [{ p:'sl', file:'qpsSecLog', nm:'격리일지' }, { p:'cd', file:'qpsCathDay', nm:'유치도뇨' }]) {
    const { M, state, $ } = harness(cfg), p = cfg.p;
    M.toggle();
    ok(cfg.nm + ' — 열림 + 연도(보던 달의 해)·월 채움', $(p + 'BulkPrintBox').style.display === '' && $(p + 'BpYear').value === '2026' &&
       $(p + 'BpFrom').options.length === 12 && $(p + 'BpFrom').value === '01');
    state.docs = ['202603', '202605', '202611'];
    $(p + 'BpFrom').value = '02'; $(p + 'BpTo').value = '06';
    M.go(); await until(() => !M.BP.busy);
    ok(cfg.nm + ' — 02~06 달을 차례로 열고 저장된 3·5월만 2장', state.loads.slice(0, 5).join(',') === '202602,202603,202604,202605,202606' &&
       state.merges.length === 1 && state.merges[0].bodies.join(',') === 'doc:202603,doc:202605');
    ok(cfg.nm + ' — 끝나면 보던 달(2026-09)로 복귀 + 마지막 로드가 그 달', $(p + 'Ym').value === '2026-09' && state.loads[state.loads.length - 1] === '202609');
    ok(cfg.nm + ' — 제목에 연·월범위', /2026년_2~6월$/.test(state.merges[0].title));
    // 조회 실패한 달은 앞 달 값이 남지 않는다
    state.fail = '202605'; state.merges.length = 0;
    M.go(); await until(() => !M.BP.busy);
    ok(cfg.nm + ' — 5월 조회 실패 → 3월 1장만(앞 달 값이 새지 않는다)', state.merges[0].bodies.join(',') === 'doc:202603');
    state.fail = '';
    // 범위 밖
    $(p + 'BpFrom').value = '07'; $(p + 'BpTo').value = '10'; state.merges.length = 0;
    M.go(); await until(() => !M.BP.busy);
    ok(cfg.nm + ' — 범위 밖 → 0장 안내', state.merges.length === 0 && /없습니다/.test($(p + 'BpStat').textContent));
    // 뒤집힌 범위 바로잡기
    $(p + 'BpFrom').value = '11'; $(p + 'BpTo').value = '10'; state.merges.length = 0;
    M.go(); await until(() => !M.BP.busy);
    ok(cfg.nm + ' — 11~10 은 10~11 로 바로잡아 11월 1장', $(p + 'BpFrom').value === '10' && state.merges[0].bodies.join(',') === 'doc:202611');
  }

  // ── 라운딩 : 구분(이 구분/둘 다) + 연도 + 월 범위 ──
  {
    const { M, state, $ } = harness({ p:'rd', file:'qpsRound', gb:true });
    $('rdGb').value = 'I';
    M.toggle();
    ok('라운딩 — 이름표 = 감염관리', /감염관리/.test($('rdBpGbNm').textContent) && $('rdBpYear').value === '2026');
    state.docs = ['Q:202603', 'I:202603', 'I:202604', 'Q:202608'];
    $('rdBpFrom').value = '03'; $('rdBpTo').value = '04';
    M.go(); await until(() => !M.BP.busy);
    ok('라운딩 — 이 구분(I)만 3~4월 → 2장', state.merges[0].bodies.join(',') === 'doc:I:202603,doc:I:202604');
    ok('라운딩 — 제목에 구분 이름', state.merges[0].title === '라운딩점검표_2026년_3~4월_감염관리_한마음병원');
    ok('라운딩 — 복귀 = 구분 I · 2026-09', $('rdGb').value === 'I' && $('rdYm').value === '2026-09');
    const radios = $('rdBulkPrintBox').querySelectorAll('input[name=rdBpScope]');
    radios[1].checked = true; state.merges.length = 0; state.loads.length = 0;
    M.go(); await until(() => !M.BP.busy);
    ok('라운딩 — 둘 다 → Q 3월 + I 3·4월 = 3장, 구분마다 달을 돈다', state.merges[0].bodies.join(',') === 'doc:Q:202603,doc:I:202603,doc:I:202604' &&
       state.loads.slice(0, 4).join(',') === 'Q:202603,Q:202604,I:202603,I:202604');
    ok('라운딩 — 둘 다 제목', state.merges[0].title === '라운딩점검표_2026년_3~4월_전체_한마음병원');
    ok('라운딩 — 둘 다 뒤에도 보던 구분(I)으로 복귀', $('rdGb').value === 'I');
  }

  console.log('\n통과 ' + pass + ' · 실패 ' + fail);
  process.exit(fail ? 1 : 0);
})();
