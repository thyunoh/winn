// 만족도 개선활동 결과보고서(연도 목록) · 지표정의서(영역/전체 · 우리 병원만) 화면 안 일괄 출력(2026-09-08)
const fs = require('fs');
const path = require('path');
const { JSDOM } = require('jsdom');
function grab(s, re, name){ const m = s.match(re); if (!m) throw new Error('못 찾음: ' + name); return m[0]; }
function src(f){ return fs.readFileSync(path.resolve(__dirname, '../../../src/main/webapp/WEB-INF/jsp/main/qpsmgr/' + f + '.jsp'), 'utf8'); }

let pass = 0, fail = 0;
const ok = (n, c) => { if (c) { pass++; console.log('  ✅', n); } else { fail++; console.log('  ❌', n); } };
const until = f => new Promise(res => { (function t(){ if (f()) return res(); setTimeout(t, 5); })(); });
const YEARS = '<option value="2027">2027년</option><option value="2026">2026년</option><option value="2025">2025년</option><option value="2024">2024년</option>';
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
  // ── 1. 만족도 개선활동 — 연도 목록형 ────────────────────────────────
  {
    const s = src('qpsSrvImpr');
    const html = '<select id="siYear">' + YEARS + '</select><div id="siBulkPrintBox" style="display:none;">' +
      '<select id="siBpFrom"></select><select id="siBpTo"></select><button id="siBpGo"></button><span id="siBpStat"></span></div>';
    const code = 'var HOSP_NM = "한마음병원", LIST = [], curSeq = 0;' +
      '\nfunction gel(id){ return document.getElementById(id); }' +
      '\nfunction siList(){ var y = gel("siYear").value; state.loads.push(y); return Promise.resolve().then(function(){ LIST = state.lists[y] || []; }); }' +
      '\nfunction siOpen(seq){ return Promise.resolve().then(function(){ if (state.fail.indexOf(seq) < 0) curSeq = seq; }); }' +
      '\nfunction siNew(){ curSeq = 0; }' +
      '\nfunction siPrint(){ if (window.QPS_BULK_CB) window.QPS_BULK_CB({ title:"t", css:"@page{ size:A4 portrait; }", body:"doc:" + curSeq }); }' +
      grab(s, /\n  window\.BP = \{ busy:false \};/, 'BP') + '\nvar BP = window.BP;' +
      grab(s, /\n  function bpFill\(\)\{[\s\S]*?\n  \}/, 'bpFill') +
      grab(s, /\n  window\.siBulkPrintToggle = function\(\)\{[\s\S]*?\n  \};/, 'toggle') +
      grab(s, /\n  window\.siBulkPrintGo = function\(\)\{[\s\S]*?\n  \};/, 'go') +
      '\nreturn { toggle: window.siBulkPrintToggle, go: window.siBulkPrintGo, BP: window.BP, cur: function(){ return curSeq; }, set: function(v){ curSeq = v; } };';
    const { M, state, $ } = build(html, code);
    state.lists = { '2025': [{ imprseq: 5 }], '2026': [{ imprseq: 11 }, { imprseq: 12 }] };
    $('siYear').value = '2026'; M.set(12); M.toggle();
    ok('개선활동 — 열림 + 연도 4개·보던 해', $('siBpFrom').options.length === 4 && $('siBpTo').value === '2026');
    $('siBpFrom').value = '2025'; $('siBpTo').value = '2026';
    M.go(); await until(() => !M.BP.busy);
    ok('개선활동 — 2025~2026 → 5·11·12 세 장, 복귀(2026·#12)', state.merges[0].bodies.join(',') === 'doc:5,doc:11,doc:12' && state.merges[0].title === '만족도개선활동_2025~2026년_한마음병원' &&
       $('siYear').value === '2026' && M.cur() === 12);
    state.fail = [11]; state.merges.length = 0;
    M.go(); await until(() => !M.BP.busy);
    ok('개선활동 — 11 열기 실패 → 건너뜀', state.merges[0].bodies.join(',') === 'doc:5,doc:12');
    state.fail = []; $('siBpFrom').value = '2027'; $('siBpTo').value = '2027'; state.merges.length = 0;
    M.go(); await until(() => !M.BP.busy);
    ok('개선활동 — 빈 해 → 0장 안내', state.merges.length === 0 && /없습니다/.test($('siBpStat').textContent) && !$('siBpGo').disabled);
    ok('개선활동 — siOpen 프라미스 반환 · 일괄 중 siList 생략(소스)', /return post\('[^']*srvImprGet[^']*'/.test(s) && /if \(!\(window\.BP && BP\.busy\)\) siList\(\);/.test(s));
  }

  // ── 2. 지표정의서 — 영역/전체 · 우리 병원만 ─────────────────────────
  {
    const s = src('qpsDef');
    const html = '<select id="qdIndi"></select><div id="qdBulkPrintBox" style="display:none;"><label><input type="radio" name="qdBpScope" value="F" checked></label>' +
      '<label><input type="radio" name="qdBpScope" value="A"></label><span id="qdBpAreaNm"></span><input type="checkbox" id="qdBpOwn"><button id="qdBpGo"></button><span id="qdBpStat"></span></div>';
    const code = 'var HOSP_NM = "한마음병원", LIST = [], INDI_CD = "FALL", curDef = null;' +
      '\nfunction qdLoad(){ var cd = document.getElementById("qdIndi").value; state.loads.push(cd); return Promise.resolve().then(function(){ if (state.fail.indexOf(cd) >= 0) return; INDI_CD = cd; LIST = state.list; curDef = { cd: cd }; }); }' +
      '\nfunction qdPrint(){ if (window.QPS_BULK_CB) window.QPS_BULK_CB({ title:"t", css:"@page{ size:A4 portrait; }", body:"def:" + curDef.cd }); }' +
      grab(s, /\n  window\.BP = \{ busy:false \};/, 'BP') + '\nvar BP = window.BP;' +
      grab(s, /\n  function qid\(id\)\{[^\n]*\}/, 'qid') + grab(s, /\n  function bpAreaOf\(cd\)\{[\s\S]*?\n  \}/, 'bpAreaOf') +
      grab(s, /\n  window\.qdBulkPrintToggle = function\(\)\{[\s\S]*?\n  \};/, 'toggle') +
      grab(s, /\n  window\.qdBulkPrintGo = function\(\)\{[\s\S]*?\n  \};/, 'go') +
      '\nreturn { toggle: window.qdBulkPrintToggle, go: window.qdBulkPrintGo, load: qdLoad, BP: window.BP, cur: function(){ return INDI_CD; }, init: function(){ LIST = state.list; } };';
    const { M, state, $ } = build(html, code);
    state.list = [{ indicd: 'FALL', indinm: '낙상', areanm: '환자안전', defown: 'Y' }, { indicd: 'BEDSORE', indinm: '욕창', areanm: '환자안전', defown: 'N' },
                  { indicd: 'CLAIM', indinm: '불만', areanm: '만족도', defown: 'Y' }, { indicd: 'HAND', indinm: '손위생', areanm: '', defown: 'N' }];
    const Opt = $('qdIndi').ownerDocument.defaultView.Option;
    state.list.forEach(r => $('qdIndi').add(new Opt(r.indinm, r.indicd)));
    M.init(); $('qdIndi').value = 'FALL'; M.toggle();
    ok('정의서 — 열림 + 이름표 = 보던 지표의 영역(환자안전)', $('qdBpAreaNm').textContent === '환자안전');
    M.go(); await until(() => !M.BP.busy);
    ok('정의서 — 이 영역 → 낙상·욕창(공통 기본값 포함) 2장 · 복귀 FALL', state.merges[0].bodies.join(',') === 'def:FALL,def:BEDSORE' && state.merges[0].title === '지표정의서_환자안전_한마음병원' &&
       M.cur() === 'FALL' && state.loads[state.loads.length - 1] === 'FALL');
    $('qdBpOwn').checked = true; state.merges.length = 0;
    M.go(); await until(() => !M.BP.busy);
    ok('정의서 — 이 영역 + 우리 병원만 → 낙상 1장, 제목에 우리병원', state.merges[0].bodies.join(',') === 'def:FALL' && state.merges[0].title === '지표정의서_환자안전_우리병원_한마음병원');
    $('qdBulkPrintBox').querySelectorAll('input[name=qdBpScope]')[1].checked = true; $('qdBpOwn').checked = false; state.merges.length = 0;
    M.go(); await until(() => !M.BP.busy);
    ok('정의서 — 전체 → 목록 차례대로 4장(영역 빈 것은 「기타」로 취급돼도 전체엔 든다)', state.merges[0].bodies.join(',') === 'def:FALL,def:BEDSORE,def:CLAIM,def:HAND' && state.merges[0].title === '지표정의서_전체_한마음병원');
    state.fail = ['CLAIM']; state.merges.length = 0;
    M.go(); await until(() => !M.BP.busy);
    ok('정의서 — CLAIM 읽기 실패 → 건너뜀(앞 정의서 재인쇄 없음)', state.merges[0].bodies.join(',') === 'def:FALL,def:BEDSORE,def:HAND');
    state.fail = []; $('qdBpOwn').checked = true; $('qdIndi').value = 'HAND'; await M.load();   // 화면에서 지표를 고르면 qdLoad 가 돈다
    // 보던 지표가 「기타」 영역이고 이 영역 + 우리 병원만 → 아무것도 없음
    $('qdBulkPrintBox').querySelectorAll('input[name=qdBpScope]')[0].checked = true; state.merges.length = 0;
    M.go(); await until(() => !M.BP.busy);
    ok('정의서 — 조건에 맞는 것 없음 → 0장 안내 · 단추 되살아남', state.merges.length === 0 && /없습니다/.test($('qdBpStat').textContent) && !$('qdBpGo').disabled);
  }

  console.log('\n통과 ' + pass + ' · 실패 ' + fail);
  process.exit(fail ? 1 : 0);
})();
