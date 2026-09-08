// 불만고충 2종 — 처리대장(대장 1장 + 건별 처리결과, 접수일 월 범위) · 지표분석보고서(연도×반기, 저장된 반기만) 화면 안 일괄 출력(2026-09-08)
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
  const state = { loads: [], merges: [], fail: [], alerts: [], picks: [] };
  const ctx = { window, document, Option: window.Option, Promise, state,
    qpsPrintMerge: (parts, title) => { state.merges.push({ n: parts.length, title, bodies: parts.map(x => x.body), sizes: parts.map(x => (x.css.match(/size:([^;]+)/) || [])[1]) }); return parts.length; },
    _alertBox: m => state.alerts.push(m) };
  const M = new Function(...Object.keys(ctx), code)(...Object.values(ctx));
  return { M, state, document, $: id => document.getElementById(id) };
}

(async function(){
  // ── 1. 처리대장 — 대장 1장 + 건별 처리결과 ───────────────────────────
  {
    const s = src('qpsCmpl');
    const html = '<select id="cmYear">' + YEARS + '</select>' +
      '<div id="cmBulkPrintBox" style="display:none;"><select id="cmBpYear"></select><select id="cmBpFrom"></select><select id="cmBpTo"></select>' +
      '<input type="checkbox" id="cmBpBook" checked><input type="checkbox" id="cmBpAct" checked><button id="cmBpGo"></button><span id="cmBpStat"></span></div>' +
      '<div id="pane1"></div><div id="pane2" style="display:none;"></div><div id="tab1"></div><div id="tab2"></div><table><tbody id="cmBody"></tbody></table>';
    const code = 'var HOSP_NM = "한마음병원", ROWS = [], curSeq = 0;' +
      '\nfunction gel(id){ return document.getElementById(id); }' +
      '\nfunction draw(){ var tb = gel("cmBody"); tb.innerHTML = ""; ROWS.forEach(function(r){ var tr = document.createElement("tr"); tr.setAttribute("data-seq", r.cmplseq); tr.innerHTML = "<td></td>"; tb.appendChild(tr); }); }' +
      '\nfunction cmLoad(){ var y = gel("cmYear").value; state.loads.push(y); return Promise.resolve().then(function(){ ROWS = state.lists[y] || []; draw(); }); }' +
      '\nfunction cmPick(el){ var seq = Number(el.closest("tr").getAttribute("data-seq")); state.picks.push(seq); curSeq = seq; return Promise.resolve().then(function(){ if (state.fail.indexOf(seq) >= 0) return false; if (!(window.BP && BP.busy)) cmTab(2); return true; }); }' +
      '\nfunction cmPrintBook(){ if (window.QPS_BULK_CB) window.QPS_BULK_CB({ title:"t", css:"@page{ size:A4 landscape; }", body:"book:" + gel("cmYear").value + "/" + ROWS.length }); }' +
      '\nfunction cmActPrint(){ if (window.QPS_BULK_CB) window.QPS_BULK_CB({ title:"t", css:"@page{ size:A4 portrait; }", body:"act:" + curSeq }); }' +
      grab(s, /\n  window\.cmTab = function\(n\)\{[\s\S]*?\n  \};/, 'cmTab') + '\nvar cmTab = window.cmTab;' +
      grab(s, /\n  function bpInRange\(r, f, t\)\{[\s\S]*?\n  \}/, 'bpInRange') + grab(s, /\n  function rowOf\(seq\)\{[^\n]*\}/, 'rowOf') + common(s, 'cm') +
      '\nreturn { toggle: window.cmBulkPrintToggle, go: window.cmBulkPrintGo, load: cmLoad, pick: cmPick, BP: window.BP, cur: function(){ return curSeq; } };';
    const { M, state, $ } = build(html, code);
    state.lists = { '2026': [{ cmplseq: 1, recvdt: '2026-01-10', recvmm: '01', hasact: 1 }, { cmplseq: 2, recvdt: '2026-04-05', recvmm: '04', hasact: 0 }, { cmplseq: 3, recvdt: '', recvmm: '07', hasact: 1 }, { cmplseq: 4, recvdt: '2026-11-30', recvmm: '11', hasact: 2 }],
                    '2025': [{ cmplseq: 9, recvdt: '2025-03-03', recvmm: '03', hasact: 1 }] };
    $('cmYear').value = '2026'; await M.load(); await M.pick($('cmBody').rows[3]);   // 4번 건을 보며 탭2
    M.toggle();
    ok('대장 — 열림 + 연도 = 보던 해 · 월 1~12', $('cmBpYear').value === '2026' && $('cmBpFrom').value === '1' && $('cmBpTo').value === '12');
    state.loads.length = 0; state.picks.length = 0;
    M.go(); await until(() => !M.BP.busy);
    ok('대장 — 대장(가로) 뒤 처리결과 있는 1·3(접수월로)·4 세로 3장, hasact 0 인 2 제외', state.merges[0].bodies.join(',') === 'book:2026/4,act:1,act:3,act:4' &&
       state.merges[0].sizes.join(',') === 'A4 landscape,A4 portrait,A4 portrait,A4 portrait');
    ok('대장 — 같은 해라 대장을 다시 안 읽는다 · 끝에 보던 건(4)·탭(2) 복귀', state.loads.length === 0 && state.picks[state.picks.length - 1] === 4 && M.cur() === 4 && $('pane2').style.display === '' &&
       state.merges[0].title === '불만고충처리_2026년_한마음병원');
    $('cmBpFrom').value = '4'; $('cmBpTo').value = '9'; $('cmBpBook').checked = false; state.merges.length = 0;
    M.go(); await until(() => !M.BP.busy);
    ok('대장 — 처리결과만 4~9월 → 3 한 장, 제목에 월 범위', state.merges[0].bodies.join(',') === 'act:3' && state.merges[0].title === '불만고충처리_2026년_4~9월_한마음병원');
    $('cmBpBook').checked = true; $('cmBpAct').checked = false; state.merges.length = 0;
    M.go(); await until(() => !M.BP.busy);
    ok('대장 — 대장만', state.merges[0].bodies.join(',') === 'book:2026/4');
    $('cmBpBook').checked = false; state.merges.length = 0;
    M.go(); await until(() => !M.BP.busy);
    ok('대장 — 둘 다 끄면 경고만', state.merges.length === 0 && state.alerts.length === 1 && !M.BP.busy);
    $('cmBpBook').checked = true; $('cmBpAct').checked = true; $('cmBpYear').value = '2025'; $('cmBpFrom').value = '1'; $('cmBpTo').value = '12';
    state.merges.length = 0; state.loads.length = 0;
    M.go(); await until(() => !M.BP.busy);
    ok('대장 — 다른 해(2025) → 대장 다시 읽어 book+9, 끝에 2026 으로 되돌려 다시 읽고 4번 건 복귀', state.merges[0].bodies.join(',') === 'book:2025/1,act:9' &&
       state.loads.join(',') === '2025,2026' && $('cmYear').value === '2026' && M.cur() === 4 && $('cmBody').rows.length === 4);
    state.fail = [4]; $('cmBpYear').value = '2026'; state.merges.length = 0;
    M.go(); await until(() => !M.BP.busy);
    ok('대장 — 4번 처리결과 읽기 실패 → 건너뜀(앞 건 재인쇄 없음)', state.merges[0].bodies.join(',') === 'book:2026/4,act:1,act:3');
    ok('대장 — cmPick 이 성공/실패 프라미스를 돌려주고 일괄 중 탭 전환 생략(소스)', /return post\('[^']*cmplActGet[^']*'/.test(s) && /if \(!\(window\.BP && BP\.busy\)\) cmTab\(2\);/.test(s) && /catch\(function\(e\)\{ err\(e\); return false; \}\)/.test(s));
  }

  // ── 2. 지표분석보고서 — 연도 × 반기 ──────────────────────────────────
  {
    const s = src('qpsCmplRpt');
    const html = '<select id="crYear">' + YEARS + '</select><select id="crHalf"><option value="1">전반기</option><option value="2">후반기</option></select>' +
      '<div id="crBulkPrintBox" style="display:none;"><label><input type="radio" name="crBpScope" value="F" checked></label><label><input type="radio" name="crBpScope" value="A"></label><span id="crBpHalfNm"></span>' +
      '<select id="crBpFrom"></select><select id="crBpTo"></select><button id="crBpGo"></button><span id="crBpStat"></span></div>';
    const code = 'var HOSP_NM = "한마음병원", LAST_DOC = false;' +
      '\nfunction gel(id){ return document.getElementById(id); }' +
      '\nfunction crLoad(){ var k = gel("crYear").value + ":" + gel("crHalf").value; state.loads.push(k); LAST_DOC = false; return Promise.resolve().then(function(){ if (state.fail.indexOf(k) >= 0) return; LAST_DOC = (state.docs || []).indexOf(k) >= 0; }); }' +
      '\nfunction crPrint(){ if (window.QPS_BULK_CB) window.QPS_BULK_CB({ title:"t", css:"@page{ size:A4 portrait; }", body:"doc:" + gel("crYear").value + ":" + gel("crHalf").value }); }' +
      grab(s, /\n  function crHalfNm\(v\)\{[^\n]*\}/, 'crHalfNm') + common(s, 'cr') +
      '\nreturn { toggle: window.crBulkPrintToggle, go: window.crBulkPrintGo, BP: window.BP };';
    const { M, state, $ } = build(html, code);
    state.docs = ['2025:1', '2025:2', '2026:1'];
    $('crYear').value = '2026'; $('crHalf').value = '2'; M.toggle();
    ok('보고서 — 열림 + 이름표 「후반기」·연도 = 보던 해', /후반기/.test($('crBpHalfNm').textContent) && $('crBpFrom').value === '2026');
    $('crBpFrom').value = '2025'; $('crBpTo').value = '2026';
    M.go(); await until(() => !M.BP.busy);
    ok('보고서 — 이 반기(후반기) 2025~2026 → 저장된 2025 후반기 한 부(2026 후반기는 저장 없음)', state.merges[0].bodies.join(',') === 'doc:2025:2' && state.merges[0].title === '불만고충지표분석_2025~2026년_후반기_한마음병원');
    $('crBulkPrintBox').querySelectorAll('input[name=crBpScope]')[1].checked = true; state.merges.length = 0; state.loads.length = 0;
    M.go(); await until(() => !M.BP.busy);
    ok('보고서 — 전·후반기 모두 → 해마다 전→후 차례로 3부, 복귀(2026 후반기)', state.merges[0].bodies.join(',') === 'doc:2025:1,doc:2025:2,doc:2026:1' &&
       state.loads.join(',') === '2025:1,2025:2,2026:1,2026:2,2026:2' && $('crYear').value === '2026' && $('crHalf').value === '2');
    state.fail = ['2025:2']; state.merges.length = 0;
    M.go(); await until(() => !M.BP.busy);
    ok('보고서 — 2025 후반기 조회 실패 → 앞 반기 값이 남아도 안 찍는다', state.merges[0].bodies.join(',') === 'doc:2025:1,doc:2026:1');
    ok('보고서 — crLoad 가 LAST_DOC 을 먼저 내리고 res.doc 로 올린다(소스)', /LAST_DOC = false;[\s\S]*?cmplRptGet[\s\S]*?LAST_DOC = !!d;/.test(s));
  }

  console.log('\n통과 ' + pass + ' · 실패 ' + fail);
  process.exit(fail ? 1 : 0);
})();
