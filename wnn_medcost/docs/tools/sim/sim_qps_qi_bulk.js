// QI 4종(계획서·보고서·주제선정·자원지원) 화면 안 일괄 출력(2026-09-08) — 목록 순회·수치 대기·집계표/기준표 선택·저장된 해 거르기·복귀
const fs = require('fs');
const path = require('path');
const { JSDOM } = require('jsdom');
function grab(s, re, name){ const m = s.match(re); if (!m) throw new Error('못 찾음: ' + name); return m[0]; }
function src(f){ return fs.readFileSync(path.resolve(__dirname, '../../../src/main/webapp/WEB-INF/jsp/main/qpsmgr/' + f + '.jsp'), 'utf8'); }

let pass = 0, fail = 0;
const ok = (n, c) => { if (c) { pass++; console.log('  ✅', n); } else { fail++; console.log('  ❌', n); } };
const until = f => new Promise(res => { (function t(){ if (f()) return res(); setTimeout(t, 5); })(); });
const YEARS = '<option value="2027">2027년</option><option value="2026">2026년</option><option value="2025">2025년</option><option value="2024">2024년</option>';
const box = (p, inner) => '<select id="' + p + 'Year">' + YEARS + '</select><div id="' + p + 'BulkPrintBox" style="display:none;">' + (inner || '') +
  '<select id="' + p + 'BpFrom"></select><select id="' + p + 'BpTo"></select><button id="' + p + 'BpGo"></button><span id="' + p + 'BpStat"></span></div>';
function common(s, p){
  return grab(s, /\n  window\.BP = \{ busy:false \};/, 'BP') + '\nvar BP = window.BP;' +
         grab(s, /\n  function bpFill\(\)\{[\s\S]*?\n  \}/, 'bpFill') +
         grab(s, new RegExp('\\n  window\\.' + p + 'BulkPrintToggle = function\\(\\)\\{[\\s\\S]*?\\n  \\};'), 'toggle') +
         grab(s, new RegExp('\\n  window\\.' + p + 'BulkPrintGo = function\\(\\)\\{[\\s\\S]*?\\n  \\};'), 'go');
}
function build(html, code, extraCtx){
  const dom = new JSDOM(html); const { window } = dom; const { document } = window;
  const state = { lists: {}, loads: [], merges: [], fail: [], opened: [], alerts: [] };
  const ctx = Object.assign({ window, document, Option: window.Option, Promise, state,
    qpsPrintMerge: (parts, title) => { state.merges.push({ n: parts.length, title, bodies: parts.map(x => x.body) }); return parts.length; },
    _alertBox: m => state.alerts.push(m) }, extraCtx || {});
  const M = new Function(...Object.keys(ctx), code)(...Object.values(ctx));
  return { M, state, document, $: id => document.getElementById(id) };
}

(async function(){
  // ── 1. QI 계획서 — 연도 목록형 ─────────────────────────────────────────────
  {
    const s = src('qpsQiPlan');
    const code = 'var HOSP_NM = "한마음병원", LIST = [], curSeq = 0;' +
      '\nfunction gel(id){ return document.getElementById(id); }' +
      '\nfunction qpList(){ var y = gel("qpYear").value; state.loads.push(y); return Promise.resolve().then(function(){ LIST = state.lists[y] || []; }); }' +
      '\nfunction qpOpen(seq){ state.opened.push(seq); return Promise.resolve().then(function(){ if (state.fail.indexOf(seq) < 0) curSeq = seq; }); }' +
      '\nfunction qpNew(){ curSeq = 0; }' +
      '\nfunction qpPrint(){ if (window.QPS_BULK_CB) window.QPS_BULK_CB({ title:"t", css:"@page{ size:A4; }", body:"doc:" + curSeq }); }' +
      common(s, 'qp') + '\nreturn { toggle: window.qpBulkPrintToggle, go: window.qpBulkPrintGo, BP: window.BP, cur: function(){ return curSeq; } };';
    const { M, state, $ } = build(box('qp'), code);
    $('qpYear').value = '2026'; M.toggle();
    ok('계획서 — 열림 + 연도 칸 4개·보던 해(2026)', $('qpBulkPrintBox').style.display === '' && $('qpBpFrom').options.length === 4 && $('qpBpTo').value === '2026');
    state.lists = { '2025': [{ qipseq: 11 }], '2026': [{ qipseq: 21 }, { qipseq: 22 }, { qipseq: 23 }] };
    $('qpBpFrom').value = '2025'; $('qpBpTo').value = '2026';
    M.go(); await until(() => !M.BP.busy);
    ok('계획서 — 2025~2026 → 4부(주제별)·오름차순', state.merges[0].bodies.join(',') === 'doc:11,doc:21,doc:22,doc:23' && state.loads.slice(0, 2).join(',') === '2025,2026');
    ok('계획서 — 제목 · 보던 해로 복귀 + 새 계획서(열린 것 없었음)', state.merges[0].title === 'QI활동계획서_2025~2026년_한마음병원' && $('qpYear').value === '2026' && M.cur() === 0);
    state.fail = [22]; state.merges.length = 0; $('qpBpFrom').value = '2026';
    M.go(); await until(() => !M.BP.busy);
    ok('계획서 — 22 열기 실패 → 건너뛰고 21·23 만(앞 문서 재인쇄 없음)', state.merges[0].bodies.join(',') === 'doc:21,doc:23');
    state.fail = []; state.merges.length = 0; $('qpBpFrom').value = '2027'; $('qpBpTo').value = '2027';
    M.go(); await until(() => !M.BP.busy);
    ok('계획서 — 빈 해 → 0부 안내 · 단추 되살아남', state.merges.length === 0 && /없습니다/.test($('qpBpStat').textContent) && !$('qpBpGo').disabled);
    ok('계획서 — qpOpen 이 프라미스를 돌려주고 일괄 중엔 목록 재조회를 건너뛴다(소스)', /return post\('[^']*qiPlanGet[^']*'/.test(s) && /if \(!\(window\.BP && BP\.busy\)\) qpList\(\);/.test(s));
  }

  // ── 2. QI 보고서 — 종류×연도 목록형, 진짜 qrOpen·qrPickIndi 로 「수치 온 뒤 인쇄」 확인 ──
  {
    const s = src('qpsQiRpt');
    const open = grab(s, /\n  window\.qrOpen = function\(seq\)\{[\s\S]*?\n  \};/, 'qrOpen');
    const pick = grab(s, /\n  window\.qrPickIndi = function\(\)\{[\s\S]*?\n  \};/, 'qrPickIndi');
    const gbnm = grab(s, /\n  function qrGbNm\(v\)\{[^\n]*\}/, 'qrGbNm');
    const html = '<select id="qrGb"><option value="M">중간</option><option value="F">최종</option></select>' + box('qr',
      '<label><input type="radio" name="qrBpScope" value="F" checked></label><label><input type="radio" name="qrBpScope" value="A"></label><span id="qrBpGbNm"></span>') +
      '<div id="qrTitle"></div><div id="qrActLb"></div><div id="cardEffect"></div><div id="cardConcl"></div><div id="cardNote"></div><div id="qrStat"></div><div id="qrDelBtn"></div>' +
      '<table><tbody id="tbTEAM"></tbody><tbody id="tbIMPR"></tbody></table><select id="f_indiCd"></select>';
    const code = 'var HOSP_NM = "한마음병원", LIST = [], curSeq = 0, INDI = [{indicd:"FALL", indinm:"낙상"}], CALC = null, QBD = [], DEF_TEAM = [{}], fileBox = null, F = {};' +
      '\nfunction gel(id){ return document.getElementById(id); } function gb(){ return gel("qrGb").value; }' +
      '\nfunction set(id, v){ F[id] = v == null ? "" : String(v); } function val(id){ return F[id] || ""; }' +
      '\nfunction teamRow(){} function imprRow(){} function renderStat(){} function err(e){ state.errs = (state.errs || 0) + 1; }' +
      '\nfunction post(url, p){ state.posts.push(url.replace(/^.*\\//, "") + ":" + JSON.stringify(p));' +
      '\n  if (/qiRptGet/.test(url)) return new Promise(function(r, j){ var d = state.docs[p.qirSeq]; if (!d) return j(new Error("없음")); r({ doc: { qirseq: p.qirSeq, rptgb: d.gb, indicd: d.indi, topicnm: d.nm }, items: [] }); });' +
      '\n  if (/indiCalc/.test(url)) return new Promise(function(r){ setTimeout(function(){ r({ indi: { unit: "%" }, calcYear: p.inYear }); }, 15); });' +
      '\n  if (/indiBreakQtr/.test(url)) return new Promise(function(r){ setTimeout(function(){ r({ quarters: [1, 2] }); }, 15); });' +
      '\n  return Promise.resolve({}); }' +
      '\nfunction qrList(){ var k = gb() + ":" + gel("qrYear").value; state.loads.push(k); return Promise.resolve().then(function(){ LIST = state.lists[k] || []; }); }' +
      '\nfunction qrNew(){ curSeq = 0; }' +
      '\nfunction qrPrint(){ if (window.QPS_BULK_CB) window.QPS_BULK_CB({ title:"t", css:"@page{ size:A4; }", body:"doc:" + curSeq + "/" + gb() + "/" + (CALC ? "calc" + CALC.calcYear : "none") + "/q" + QBD.length }); }' +
      pick + open + '\nvar qrPickIndi = window.qrPickIndi, qrOpen = window.qrOpen;' + gbnm + common(s, 'qr') +
      '\nreturn { toggle: window.qrBulkPrintToggle, go: window.qrBulkPrintGo, open: window.qrOpen, BP: window.BP, cur: function(){ return curSeq; } };';
    const { M, state, $ } = build(html, code);
    state.posts = [];
    state.docs = { 31: { gb: 'M', indi: 'FALL', nm: '낙상' }, 32: { gb: 'M', indi: '', nm: '직접' }, 41: { gb: 'F', indi: 'FALL', nm: '낙상' }, 51: { gb: 'M', indi: 'FALL', nm: '옛것' } };
    state.lists = { 'M:2026': [{ qirseq: 31 }, { qirseq: 32 }], 'F:2026': [{ qirseq: 41 }], 'M:2025': [{ qirseq: 51 }] };
    $('qrGb').value = 'F'; $('qrYear').value = '2026'; M.toggle();
    ok('보고서 — 열림 + 이름표 「최종보고서」·보던 해', /최종보고서/.test($('qrBpGbNm').textContent) && $('qrBpFrom').value === '2026');
    M.go(); await until(() => !M.BP.busy);
    ok('보고서 — 이 종류(F) 2026 → 41 한 부, 수치(calc2026·분기 2)가 온 뒤 찍혔다', state.merges[0].bodies.join(',') === 'doc:41/F/calc2026/q2' &&
       state.merges[0].title === 'QI활동보고서_2026년_최종보고서_한마음병원');
    ok('보고서 — 일괄 중 qrOpen 은 목록 재조회를 안 한다(loads = F:2026 + 복귀 1회)', state.loads.join(',') === 'F:2026,F:2026');
    $('qrBulkPrintBox').querySelectorAll('input[name=qrBpScope]')[1].checked = true;
    $('qrBpFrom').value = '2025'; $('qrBpTo').value = '2026'; state.merges.length = 0; state.loads.length = 0;
    M.go(); await until(() => !M.BP.busy);
    ok('보고서 — 중간·최종 모두 2025~2026 → M 2025·2026, F 2026 = 4부, 지표 없는 32 는 수치 없이', state.merges[0].bodies.join(',') === 'doc:51/M/calc2025/q2,doc:31/M/calc2026/q2,doc:32/M/none/q0,doc:41/F/calc2026/q2' &&
       state.loads.slice(0, 4).join(',') === 'M:2025,M:2026,F:2025,F:2026');
    ok('보고서 — 둘 다 제목 · 복귀(F/2026) · 열려 있던 것 없어 새 보고서', state.merges[0].title === 'QI활동보고서_2025~2026년_중간·최종_한마음병원' && $('qrGb').value === 'F' && $('qrYear').value === '2026' && M.cur() === 0);
    state.lists['F:2026'] = [{ qirseq: 41 }, { qirseq: 99 }]; state.merges.length = 0;
    $('qrBulkPrintBox').querySelectorAll('input[name=qrBpScope]')[0].checked = true; $('qrBpFrom').value = '2026';
    M.go(); await until(() => !M.BP.busy);
    ok('보고서 — 없는 문서 99(조회 실패) 는 건너뛴다', state.merges[0].bodies.join(',') === 'doc:41/F/calc2026/q2' && state.errs >= 1);
    // 평소 qrOpen 은 종전대로(수치 + 목록 재조회)
    state.loads.length = 0; await M.open(31); await until(() => state.loads.length > 0);
    ok('보고서 — 평소 qrOpen 은 목록을 다시 부른다', state.loads[0] === 'M:2026' && M.cur() === 31);
  }

  // ── 3. 주제선정 — 집계표 + 평가위원별 기준표 ─────────────────────────────
  {
    const s = src('qpsQiTopic');
    const tab = grab(s, /\n  window\.qtTab = function\(n\)\{[\s\S]*?\n  \};/, 'qtTab');
    const html = box('qt', '<input type="checkbox" id="qtBpRoll" checked><input type="checkbox" id="qtBpEach" checked>') +
      '<div id="pane1"></div><div id="pane2" style="display:none;"></div><div id="tab1"></div><div id="tab2"></div>';
    const code = 'var HOSP_NM = "한마음병원", LIST = [], curSeq = 0, ROLL = [];' +
      '\nfunction gel(id){ return document.getElementById(id); }' +
      '\nfunction qtLoad(){ var y = gel("qtYear").value; state.loads.push(y); return Promise.resolve().then(function(){ LIST = state.lists[y] || []; ROLL = LIST.length ? [1] : []; }); }' +
      '\nfunction qtOpen(seq){ return Promise.resolve().then(function(){ if (state.fail.indexOf(seq) < 0) curSeq = seq; }); }' +
      '\nfunction qtNew(){ curSeq = 0; }' +
      '\nfunction qtPrint(){ var roll = gel("pane2").style.display !== "none"; if (window.QPS_BULK_CB) window.QPS_BULK_CB({ title:"t", css: roll ? "@page{ size:A4 landscape; }" : "@page{ size:A4; }", body: roll ? ("roll:" + gel("qtYear").value) : ("doc:" + curSeq) }); }' +
      tab + '\nvar qtTab = window.qtTab;' + common(s, 'qt') + '\nreturn { toggle: window.qtBulkPrintToggle, go: window.qtBulkPrintGo, tab: window.qtTab, BP: window.BP, cur: function(){ return curSeq; } };';
    const { M, state, $ } = build(html, code);
    state.lists = { '2025': [{ qitseq: 5 }], '2026': [{ qitseq: 7 }, { qitseq: 8 }] };
    $('qtYear').value = '2026'; M.tab(2); M.toggle();
    $('qtBpFrom').value = '2025'; $('qtBpTo').value = '2027';
    M.go(); await until(() => !M.BP.busy);
    ok('주제선정 — 해마다 집계표 뒤 기준표: roll25·5 · roll26·7·8, 빈 2027 은 아무것도 없음', state.merges[0].bodies.join(',') === 'roll:2025,doc:5,roll:2026,doc:7,doc:8');
    ok('주제선정 — 제목 · 보던 해·탭(집계표) 으로 복귀', state.merges[0].title === 'QPS주제선정_2025~2027년_한마음병원' && $('qtYear').value === '2026' && $('pane2').style.display === '' && $('pane1').style.display === 'none');
    $('qtBpRoll').checked = false; state.merges.length = 0;
    M.go(); await until(() => !M.BP.busy);
    ok('주제선정 — 기준표만', state.merges[0].bodies.join(',') === 'doc:5,doc:7,doc:8');
    $('qtBpRoll').checked = true; $('qtBpEach').checked = false; state.merges.length = 0;
    M.go(); await until(() => !M.BP.busy);
    ok('주제선정 — 집계표만(기준표 있는 해만)', state.merges[0].bodies.join(',') === 'roll:2025,roll:2026');
    $('qtBpRoll').checked = false; state.merges.length = 0;
    M.go(); await until(() => !M.BP.busy);
    ok('주제선정 — 둘 다 끄면 경고만, 안 돈다', state.merges.length === 0 && state.alerts.length === 1 && !M.BP.busy);
    $('qtBpRoll').checked = true; $('qtBpEach').checked = true; state.fail = [7]; state.merges.length = 0; M.tab(1);
    M.go(); await until(() => !M.BP.busy);
    ok('주제선정 — 7 열기 실패 → 건너뜀 · 원래 탭(기준표)으로 복귀', state.merges[0].bodies.join(',') === 'roll:2025,doc:5,roll:2026,doc:8' && $('pane1').style.display === '');
    ok('주제선정 — qtOpen 프라미스 반환 · 일괄 중 qtLoad 생략(소스)', /return post\('[^']*qiTopicGet[^']*'/.test(s) && /if \(!\(window\.BP && BP\.busy\)\) qtLoad\(\);/.test(s));
  }

  // ── 4. 자원지원 — 연 1부 ────────────────────────────────────────────────
  {
    const s = src('qpsQiFund');
    const code = 'var HOSP_NM = "한마음병원", LAST_DOC = false;' +
      '\nfunction gel(id){ return document.getElementById(id); }' +
      '\nfunction qfLoad(){ var y = gel("qfYear").value; state.loads.push(y); LAST_DOC = false; return Promise.resolve().then(function(){ if (state.fail.indexOf(y) >= 0) return; LAST_DOC = (state.docs || []).indexOf(y) >= 0; }); }' +
      '\nfunction qfPrint(){ if (window.QPS_BULK_CB) window.QPS_BULK_CB({ title:"t", css:"@page{ size:A4; }", body:"doc:" + gel("qfYear").value }); }' +
      common(s, 'qf') + '\nreturn { toggle: window.qfBulkPrintToggle, go: window.qfBulkPrintGo, BP: window.BP };';
    const { M, state, $ } = build(box('qf'), code);
    $('qfYear').value = '2026'; M.toggle();
    state.docs = ['2024', '2026']; $('qfBpFrom').value = '2024'; $('qfBpTo').value = '2027';
    M.go(); await until(() => !M.BP.busy);
    ok('자원지원 — 2024~2027 중 저장된 2024·2026 두 부 · 복귀(2026)', state.merges[0].bodies.join(',') === 'doc:2024,doc:2026' &&
       state.merges[0].title === 'QI자원지원내역_2024~2027년_한마음병원' && $('qfYear').value === '2026');
    state.fail = ['2026']; state.merges.length = 0;
    M.go(); await until(() => !M.BP.busy);
    ok('자원지원 — 2026 조회 실패 → 앞 해 값이 남아도 안 찍는다(LAST_DOC 먼저 내림)', state.merges[0].bodies.join(',') === 'doc:2024');
    ok('자원지원 — qfLoad 가 LAST_DOC 을 먼저 내리고 res.doc 로 올린다(소스)', /LAST_DOC = false;[\s\S]*?qiFundGet[\s\S]*?LAST_DOC = !!d;/.test(s));
  }

  console.log('\n통과 ' + pass + ' · 실패 ' + fail);
  process.exit(fail ? 1 : 0);
})();
