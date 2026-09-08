// 회의록 화면 안 일괄 출력(2026-09-08) — 소스 JSP 에서 범위·회의일·정기/임시·수집·복귀 논리를 꺼내 가짜 DOM 으로 돌린다
const fs = require('fs');
const { JSDOM } = require('jsdom');
const SRC = require('path').resolve(__dirname, '../../../src/main/webapp/WEB-INF/jsp/main/qpsmgr/qpsMinutes.jsp');
const s = fs.readFileSync(SRC, 'utf8');
function grab(re, name){ const m = s.match(re); if (!m) throw new Error('못 찾음: ' + name); return m[0]; }
const bpDef   = grab(/\n  window\.BP = \{ busy:false \};/, 'BP');
const idfn    = grab(/\n  function \$id\(id\)\{[^\n]*\}/, '$id');
const months  = grab(/\n  function bpMonths\(\)\{[\s\S]*?\n  \}/, 'bpMonths');
const gbNm    = grab(/\n  function qmGbNm\(v\)\{[^\n]*\}/, 'qmGbNm');
const gbAll   = grab(/\n  function qmGbAll\(\)\{[^\n]*\}/, 'qmGbAll');
const toggle  = grab(/\n  window\.qmBulkPrintToggle = function\(\)\{[\s\S]*?\n  \};/, 'qmBulkPrintToggle');
const inRange = grab(/\n  function bpInRange\(r, f, t\)\{[\s\S]*?\n  \}/, 'bpInRange');
const go      = grab(/\n  window\.qmBulkPrintGo = function\(\)\{[\s\S]*?\n  \};/, 'qmBulkPrintGo');

const dom = new JSDOM(
  '<span id="qmTitle">질향상·환자안전위원회 회의록</span>' +
  '<select id="qmGb"><option value="Q">질향상·환자안전</option><option value="I">감염관리</option><option value="S">소방안전관리</option></select>' +
  '<select id="qmYear"><option value="2026" selected>2026</option></select>' +
  '<div id="qmBulkPrintBox" style="display:none;">' +
  '<label><input type="radio" name="qmBpScope" value="F" checked></label><label><input type="radio" name="qmBpScope" value="A"></label>' +
  '<span id="qmBpGbNm"></span><span id="qmBpAllNm"></span><b id="qmBpYear"></b>' +
  '<select id="qmBpFrom"></select><select id="qmBpTo"></select>' +
  '<select id="qmBpMeet"><option value="">전부</option><option value="R">정기</option><option value="T">임시</option></select>' +
  '<button id="qmBpGo"></button><span id="qmBpStat"></span></div>');
const { window } = dom; const { document } = window;
const state = { lists: {}, meet: {}, loads: [], opens: [], news: 0, failSeq: 0, merges: [] };
const ctx = {
  window, document, Option: window.Option, Promise,
  qpsPrintMerge: (parts, title) => { state.merges.push({ n: parts.length, title, bodies: parts.map(p => p.body) }); return parts.length; },
  state,
};
const code =
  'var LIST = [], curSeq = 0, HOSP_NM = "한마음병원", curMeet = "";' +
  '\nfunction qmGb(){ var e = document.getElementById("qmGb"); return e ? e.value : "Q"; }' +
  '\nfunction getGb(){ return curMeet; }' +
  '\nfunction qmList(){ state.loads.push(qmGb()); return Promise.resolve().then(function(){ LIST = state.lists[qmGb()] || []; }); }' +
  '\nfunction qmOpen(seq){ state.opens.push(Number(seq)); return Promise.resolve().then(function(){ if (state.failSeq !== Number(seq)) { curSeq = Number(seq); curMeet = state.meet[seq] || ""; } }); }' +
  '\nfunction qmNew(){ state.news++; curSeq = 0; }' +
  '\nfunction qmPrint(){ if (window.QPS_BULK_CB) window.QPS_BULK_CB({ title:"t", css:"@page{ size:A4 portrait; }", body:"doc" + curSeq }); }' +
  bpDef + '\nvar BP = window.BP;' + idfn + months + gbNm + gbAll + toggle + inRange + go +
  '\nreturn { bpInRange, toggle: window.qmBulkPrintToggle, go: window.qmBulkPrintGo, BP: window.BP, cur: () => curSeq, setCur: v => { curSeq = v; } };';
const M = new Function(...Object.keys(ctx), code)(...Object.values(ctx));

let pass = 0, fail = 0;
const ok = (n, c) => { if (c) { pass++; console.log('  ✅', n); } else { fail++; console.log('  ❌', n); } };
const until = f => new Promise(res => { (function t(){ if (f()) return res(); setTimeout(t, 5); })(); });
const $ = id => document.getElementById(id);

(async function(){
  ok('회의일 4월 · 03~06 → 담김', M.bpInRange({ meetdt:'2026-04-10' }, '03', '06') === true);
  ok('회의일 9월 · 03~06 → 빠짐', M.bpInRange({ meetdt:'2026-09-01' }, '03', '06') === false);
  ok('회의일 없음 → 담김', M.bpInRange({ meetdt:'' }, '03', '06') === true);

  $('qmGb').value = 'I';
  M.toggle();
  ok('열림 + 월 12칸 + 이름표(감염관리 · 3종)', $('qmBulkPrintBox').style.display === '' && $('qmBpFrom').options.length === 12 &&
     /감염관리/.test($('qmBpGbNm').textContent) && /3종/.test($('qmBpAllNm').textContent) && $('qmBpMeet').value === '');
  M.toggle();
  ok('다시 누르면 닫힘', $('qmBulkPrintBox').style.display === 'none');

  // 이 위원회만 · 회의일 범위 · 정기만
  state.lists = { I: [{ minseq: 21, meetdt: '2026-02-01' }, { minseq: 22, meetdt: '2026-05-05' }, { minseq: 23, meetdt: '2026-05-20' }, { minseq: 24, meetdt: '2026-11-11' }] };
  state.meet = { 21: 'R', 22: 'R', 23: 'T', 24: 'R' };
  M.setCur(22); M.toggle();
  $('qmBpFrom').value = '02'; $('qmBpTo').value = '06'; $('qmBpMeet').value = 'R';
  state.loads.length = 0; state.opens.length = 0; state.merges.length = 0;
  M.go();
  await until(() => !M.BP.busy);
  ok('범위 02~06 · 정기만 → 21·22 두 장(임시 23 제외, 11월 24 제외)', state.merges.length === 1 && state.merges[0].n === 2 &&
     state.merges[0].bodies.join(',') === 'doc21,doc22');
  ok('제목 = 위원회_연_월범위_정기_병원', state.merges[0].title === '질향상·환자안전위원회 회의록_2026년_2~6월_정기_한마음병원');
  ok('끝나면 보던 회의록(22)로 복귀', $('qmGb').value === 'I' && state.opens[state.opens.length - 1] === 22 && M.cur() === 22);
  ok('출력 단추 다시 활성', $('qmBpGo').disabled === false);

  // 임시만
  $('qmBpMeet').value = 'T'; state.merges.length = 0;
  M.go(); await until(() => !M.BP.busy);
  ok('임시만 → 23 한 장', state.merges[0].n === 1 && state.merges[0].bodies[0] === 'doc23');

  // 못 연 문서 건너뜀
  $('qmBpMeet').value = ''; state.failSeq = 22; state.merges.length = 0; M.setCur(0);
  M.go(); await until(() => !M.BP.busy);
  ok('실패 1건 건너뜀 → 2장(21·23)', state.merges[0].n === 2 && state.merges[0].bodies.join(',') === 'doc21,doc23');
  ok('보던 문서 없었으면 새 문서로 복귀', state.news >= 1);
  state.failSeq = 0;

  // 전체 위원회
  state.lists = { Q: [{ minseq: 1, meetdt: '2026-01-01' }], I: [{ minseq: 2, meetdt: '2026-01-02' }], S: [] };
  state.meet = { 1: 'R', 2: 'T' };
  document.querySelector('input[name=qmBpScope][value=A]').checked = true;
  $('qmBpFrom').value = '01'; $('qmBpTo').value = '12'; $('qmBpMeet').value = '';
  state.loads.length = 0; state.merges.length = 0; M.setCur(0);
  M.go(); await until(() => !M.BP.busy);
  ok('전체 3위원회 순회(복귀 포함 4회 로드) → 2장', state.merges[0].n === 2 && state.loads.length === 4 && state.loads.slice(0,3).join(',') === 'Q,I,S');
  ok('전체 제목', state.merges[0].title === '위원회 회의록 전체_2026년_한마음병원');

  console.log('\n통과 ' + pass + ' · 실패 ' + fail);
  process.exit(fail ? 1 : 0);
})();
