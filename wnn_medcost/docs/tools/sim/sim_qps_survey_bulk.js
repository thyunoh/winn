// 만족도 조사(qpsSurvey) 화면 안 일괄 출력(2026-09-08) — 연도×조사 순회 · 보고서 2종 고르기 · 콜백→프라미스 다리 · 복귀
// ★이 화면만 구조가 다르다 : post 가 콜백이고 인쇄물이 화면 칸을 읽는다. 그래서 「열고 → 찍는다」 차례가 실제로 지켜지는지를 본다.
const fs = require('fs');
const path = require('path');
const { JSDOM } = require('jsdom');
function grab(s, re, name){ const m = s.match(re); if (!m) throw new Error('못 찾음: ' + name); return m[0]; }
const S = fs.readFileSync(path.resolve(__dirname, '../../../src/main/webapp/WEB-INF/jsp/main/qpsmgr/qpsSurvey.jsp'), 'utf8')
            .replace(/<c:url value="([^"]*)"\/>/g, '$1');

let pass = 0, fail = 0;
const ok = (n, c) => { if (c) { pass++; console.log('  ✅', n); } else { fail++; console.log('  ❌', n); } };
const until = f => new Promise(res => { (function t(){ if (f()) return res(); setTimeout(t, 5); })(); });

function build(){
  const dom = new JSDOM(
    '<select id="svYear"><option value="2027">2027년</option><option value="2026">2026년</option><option value="2025">2025년</option></select>' +
    '<select id="svList"></select>' +
    '<div id="svBulkPrintBox" style="display:none;"><select id="svBpFrom"></select><select id="svBpTo"></select>' +
    '<input type="checkbox" id="svBpRpt" checked><input type="checkbox" id="svBpIndi" checked>' +
    '<button id="btnSvBpGo"></button><span id="svBpStat"></span></div>');
  const { window } = dom, { document } = window;
  const state = { lists: {}, docs: {}, loads: [], opens: [], merges: [], failYear: [], failOpen: [], failPrint: [], says: [], drawn: [] };
  const ctx = { window, document, Option: window.Option, Promise, state,
    qpsPrintMerge: (parts, title) => { state.merges.push({ title, bodies: parts.map(x => x.body) }); return parts.length; } };
  const code =
    'var HAND = {}, DEF = [], AREA = {}, curSurvey = 0, LOAD_REQ = 0, CUR = null;' +
    '\nfunction gel(id){ return document.getElementById(id); }' +
    '\nfunction esc(s){ return String(s == null ? "" : s); }' +
    '\nfunction say(m){ state.says.push(m); }' +
    '\nfunction hospNm(){ return "한마음병원"; }' +
    '\nfunction drawQuestions(){ state.drawn.push(gel("svYear").value); }' +
    '\nfunction applySurveyDoc(r){ CUR = r.doc; }' +   // 인쇄물이 읽는 화면 칸 = 여기서 채워진다
    // 서버 흉내 — surveyBase(해별 목록) · surveyGet(조사 1건). 실패는 fail 콜백으로만 알린다(알림 안 띄움).
    '\nfunction post(url, data, cb, failCb){ setTimeout(function(){' +
    '\n  if (/surveyBase/.test(url)) { var y = String(data.inYear); state.loads.push(y);' +
    '\n    if (state.failYear.indexOf(y) >= 0) return failCb ? failCb() : say("fail");' +
    '\n    return cb({ result:"OK", def:[{areacd:"A", areanm:"진료", qno:1, sort:1, qnm:"문항"}], list: state.lists[y] || [] }); }' +
    '\n  if (/surveyGet/.test(url)) { var id = Number(data.surveyId); state.opens.push(id);' +
    '\n    if (state.failOpen.indexOf(id) >= 0) return failCb ? failCb() : say("fail");' +
    '\n    return cb({ result:"OK", doc: state.docs[id], ans: [] }); }' +
    '\n  cb({ result:"OK" }); }, 1); }' +
    // 인쇄 — 실제 화면처럼 「지금 화면에 올라온 조사」를 찍는다. 못 읽은 조사는 done(false).
    '\nHAND.btnSvPrint = function(done){ setTimeout(function(){' +
    '\n  if (!CUR || state.failPrint.indexOf(CUR.surveyid) >= 0) { if (done) done(false); return; }' +
    '\n  if (window.QPS_BULK_CB) window.QPS_BULK_CB({ title:"t", css:"@page{ size:A4 portrait; }", body:"rpt:" + gel("svYear").value + ":" + CUR.surveynm });' +
    '\n  if (done) done(true); }, 1); };' +
    '\nHAND.btnSvPrint2 = function(done){ setTimeout(function(){' +
    '\n  if (!CUR) { if (done) done(false); return; }' +
    '\n  if (window.QPS_BULK_CB) window.QPS_BULK_CB({ title:"t", css:"@page{ size:A4 portrait; }", body:"indi:" + gel("svYear").value + ":" + CUR.surveynm });' +
    '\n  if (done) done(true); }, 1); };' +
    '\nHAND.svList = function(){ curSurvey = Number((this && this.value != null) ? this.value : gel("svList").value) || 0;' +
    '\n  state.restored = { year: gel("svYear").value, survey: curSurvey }; };' +
    grab(S, /\n  window\.BP = \{ busy:false \};/, 'BP') + '\nvar BP = window.BP;' +
    grab(S, /\n  function bpFill\(\)\{[\s\S]*?\n  \}/, 'bpFill') +
    grab(S, /\n  HAND\.btnSvBulk = function\(\)\{[\s\S]*?\n  \};/, 'btnSvBulk') +
    grab(S, /\n  HAND\.btnSvBpClose = function\(\)\{[^\n]*\};/, 'btnSvBpClose') +
    grab(S, /\n  function bpPost\(url, data\)\{[\s\S]*?\n  \}/, 'bpPost') +
    grab(S, /\n  function bpYear\(yy\)\{[\s\S]*?\n  \}/, 'bpYear') +
    grab(S, /\n  function bpOpen\(id\)\{[\s\S]*?\n  \}/, 'bpOpen') +
    grab(S, /\n  function bpPrint\(fn\)\{[^\n]*\}/, 'bpPrint') +
    grab(S, /\n  HAND\.btnSvBpGo = function\(\)\{[\s\S]*?\n  \};/, 'btnSvBpGo') +
    '\nreturn { toggle: HAND.btnSvBulk, close: HAND.btnSvBpClose, go: HAND.btnSvBpGo, BP: window.BP,' +
    '\n  setCur: function(y, id){ gel("svYear").value = y; curSurvey = id; } };';
  const M = new Function(...Object.keys(ctx), code)(...Object.values(ctx));
  return { M, state, document, $: id => document.getElementById(id) };
}

(async function(){
  const { M, state, $ } = build();
  state.lists = { '2026': [{ surveyid: 11, inyear: '2026', seq: 1, surveynm: '상반기', anscnt: 30 },
                           { surveyid: 12, inyear: '2026', seq: 2, surveynm: '하반기', anscnt: 25 }],
                  '2025': [{ surveyid: 5, inyear: '2025', seq: 1, surveynm: '2025조사', anscnt: 40 }],
                  '2027': [] };
  state.docs = { 11: { surveyid: 11, surveynm: '상반기' }, 12: { surveyid: 12, surveynm: '하반기' }, 5: { surveyid: 5, surveynm: '2025조사' } };
  M.setCur('2026', 12);
  M.toggle();
  ok('열림 + 연도 칸이 화면 연도 목록(3개)·보던 해(2026)', $('svBulkPrintBox').style.display === '' &&
     $('svBpFrom').options.length === 3 && $('svBpFrom').value === '2026' && $('svBpTo').value === '2026');

  $('svBpFrom').value = '2025'; $('svBpTo').value = '2026';
  M.go(); await until(() => !M.BP.busy);
  ok('2025~2026 · 두 보고서 → 조사마다 조사결과 다음 지표분석, 해 오름차순 6부',
     state.merges[0].bodies.join(',') === 'rpt:2025:2025조사,indi:2025:2025조사,rpt:2026:상반기,indi:2026:상반기,rpt:2026:하반기,indi:2026:하반기');
  ok('제목 · 보던 해·조사로 복귀', state.merges[0].title === '만족도조사_2025~2026년_한마음병원' &&
     state.restored && state.restored.year === '2026' && state.restored.survey === 12 && $('svBpStat').textContent.indexOf('6부') >= 0);
  ok('해마다 문항을 다시 그린다(연도별 문항이 다를 수 있다)', state.drawn.join(',') === '2025,2026,2026');

  $('svBpIndi').checked = false; state.merges.length = 0;
  M.go(); await until(() => !M.BP.busy);
  ok('조사결과 보고서만 → 3부', state.merges[0].bodies.join(',') === 'rpt:2025:2025조사,rpt:2026:상반기,rpt:2026:하반기');

  $('svBpRpt').checked = false; $('svBpIndi').checked = true; state.merges.length = 0;
  M.go(); await until(() => !M.BP.busy);
  ok('지표분석 보고서만 → 3부', state.merges[0].bodies.join(',') === 'indi:2025:2025조사,indi:2026:상반기,indi:2026:하반기');

  $('svBpIndi').checked = false; state.merges.length = 0; state.says.length = 0;
  M.go();
  ok('둘 다 끄면 경고만 하고 안 돈다', state.merges.length === 0 && state.says.length === 1 && !M.BP.busy);

  $('svBpRpt').checked = true; $('svBpIndi').checked = true;
  $('svBpFrom').value = '2027'; $('svBpTo').value = '2027'; state.merges.length = 0;
  M.go(); await until(() => !M.BP.busy);
  ok('조사 없는 해 → 0부 안내 · 단추 되살아남', state.merges.length === 0 && /없습니다/.test($('svBpStat').textContent) && !$('btnSvBpGo').disabled);

  $('svBpFrom').value = '2026'; $('svBpTo').value = '2026'; state.failOpen = [11]; state.merges.length = 0;
  M.go(); await until(() => !M.BP.busy);
  ok('11 못 열림 → 건너뛴다(앞 조사가 그 자리에 찍히지 않는다)', state.merges[0].bodies.join(',') === 'rpt:2026:하반기,indi:2026:하반기');

  state.failOpen = []; state.failPrint = [12]; state.merges.length = 0;
  M.go(); await until(() => !M.BP.busy);
  ok('12 의 조사결과 인쇄 실패 → 그 장만 빠지고 순회는 이어진다(멈추지 않음)',
     state.merges[0].bodies.join(',') === 'rpt:2026:상반기,indi:2026:상반기,indi:2026:하반기');

  state.failPrint = []; $('svBpFrom').value = '2025'; $('svBpTo').value = '2026'; state.failYear = ['2025']; state.merges.length = 0;
  M.go(); await until(() => !M.BP.busy);
  ok('2025 목록 조회 실패 → 그 해만 건너뛰고 2026 은 찍는다',
     state.merges[0].bodies.join(',') === 'rpt:2026:상반기,indi:2026:상반기,rpt:2026:하반기,indi:2026:하반기');

  state.failYear = []; $('svBpFrom').value = '2026'; $('svBpTo').value = '2025'; state.merges.length = 0;
  M.go(); await until(() => !M.BP.busy);
  ok('뒤집힌 범위를 바로잡는다', $('svBpFrom').value === '2025' && $('svBpTo').value === '2026' && state.merges[0].bodies.length === 6);

  M.close();
  ok('닫기', $('svBulkPrintBox').style.display === 'none');

  ok('소스 — post·prepPrint 에 fail 이 붙고 인쇄 함수가 done 을 부른다', /function post\(url, data, cb, fail\)\{/.test(S) &&
     /function prepPrint\(cb, fail\)\{/.test(S) && /HAND\.btnSvPrint = function\(done\)\{/.test(S) && /HAND\.btnSvPrint2 = function\(done\)\{/.test(S));
  ok('소스 — loadBase 에 순번 가드 · bpYear 가 그 순번을 올려 옛 응답을 무효로', /if \(my !== LOAD_REQ\) return;/.test(S) && /\+\+LOAD_REQ;   \/\/ ★날아가는 중인 loadBase/.test(S));

  console.log('\n통과 ' + pass + ' · 실패 ' + fail);
  process.exit(fail ? 1 : 0);
})();
