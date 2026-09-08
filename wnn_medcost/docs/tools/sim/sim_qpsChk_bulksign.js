// 점검표 화면 안 ✍ 일괄 사인(2026-09-08) — 여러 문서의 **빈 사인 칸만** 내 이름으로 채워 저장
// ★일괄 출력과 달리 **자료를 고쳐 저장한다** — 그래서 ①묻고 ②빈 칸만 ③채울 칸 없으면 저장조차 안 하는지를 본다.
const fs = require('fs');
const path = require('path');
const { JSDOM } = require('jsdom');
function grab(s, re, name){ const m = s.match(re); if (!m) throw new Error('못 찾음: ' + name); return m[0]; }
// ⚠작업본은 CRLF — 줄 끝을 고르게 만들어야 `\n  };` 앵커가 맞는다
const S = fs.readFileSync(path.resolve(__dirname, '../../../src/main/webapp/WEB-INF/jsp/main/qpsmgr/qpsChk.jsp'), 'utf8')
            .replace(/\r\n/g, '\n').replace(/<c:url value="([^"]*)"\/>/g, '$1');

let pass = 0, fail = 0;
const ok = (n, c) => { if (c) { pass++; console.log('  ✅', n); } else { fail++; console.log('  ❌', n); } };
const until = f => new Promise(res => { (function t(){ if (f()) return res(); setTimeout(t, 5); })(); });

function build(){
  const dom = new JSDOM(
    '<select id="ckYear"><option value="2026" selected>2026년</option></select>' +
    '<select id="ckForm"></select><select id="ckDoc"></select><select id="ckDept"></select>' +
    '<select id="ckWardF"><option value="">전체</option><option value="3층">3층</option><option value="(없음)">병동 없음</option></select>' +
    '<div id="ckBulkSignBox" style="display:none;">' +
    '<label><input type="radio" name="ckBsScope" value="F" checked></label><label><input type="radio" name="ckBsScope" value="D"></label>' +
    '<span id="ckBsFormNm"></span><span id="ckBsDeptNm"></span><span id="ckBsYear"></span>' +
    '<select id="ckBsFrom"></select><select id="ckBsTo"></select><span id="ckBsNm"></span>' +
    '<button id="ckBsGo"></button><span id="ckBsStat"></span></div>' +
    '<div id="ckGridWrap"></div>');
  const { window } = dom, { document } = window;
  const state = { bases: [], picks: [], saves: [], asks: [], alerts: [], toasts: [],
                  failPick: [], failSave: [], docsOf: {}, cells: {}, excl: false };
  const ctx = { window, document, Option: window.Option, Promise, state };
  const code =
    'var FORM = null, FORMS = [], DOCS = [], curSeq = 0, SIGN_NO = 900;' +
    '\nfunction gel(id){ return document.getElementById(id); }' +
    '\nfunction val(id){ var e = gel(id); return e ? String(e.value).trim() : ""; }' +
    '\nfunction esc(s){ return String(s == null ? "" : s); }' +
    '\nfunction deptNmOf(cd){ return cd === "NUR" ? "간호" : cd; }' +
    '\nfunction ckUserNm(){ return state.userNm; }' +
    // 토·일·공휴일 제외 — 화면 설정을 따른다. 시뮬은 칸에 off 표시가 있으면 제외로 본다.
    '\nfunction ckCellOff(el){ return state.excl && el.getAttribute("data-off") === "1"; }' +
    '\nfunction _confirmBox(o){ state.asks.push(o.msg); if (state.confirmAuto !== false) o.onOk(); }' +
    '\nfunction _alertBox(m){ state.alerts.push(m); } function _toast(m){ state.toasts.push(m); }' +
    '\nfunction bpInRange(d, yy, f, t){ if (String(d.inyear||"") !== String(yy)) return false;' +
    '\n  var m = String(d.inmm||"").replace(/\\D/g,""); if (!m) return true; if (m.length < 2) m = "0" + m; return m >= f && m <= t; }' +
    // ckBase — 고른 서식의 문서 목록을 DOCS 에 싣는다
    '\nfunction ckBase(){ var fid = gel("ckForm").value; state.bases.push(fid);' +
    '\n  return Promise.resolve().then(function(){ FORM = { formid: fid, formnm: "서식" + fid }; DOCS = (state.docsOf[fid] || []).slice(); }); }' +
    // ckPickDoc — 그 문서의 격자를 그린다(사인 칸 = data-r=900)
    '\nfunction ckPickDoc(){ var seq = Number(gel("ckDoc").value); state.picks.push(seq);' +
    '\n  return Promise.resolve().then(function(){ if (state.failPick.indexOf(seq) >= 0) return; curSeq = seq;' +
    '\n    var cs = state.cells[seq] || [];' +
    '\n    gel("ckGridWrap").innerHTML = cs.map(function(c, i){' +
    '\n      return "<input data-r=\\"" + (c.sign === false ? 1 : 900) + "\\" data-i=\\"" + i + "\\"" +' +
    '\n             (c.off ? " data-off=\\"1\\"" : "") + " value=\\"" + (c.v || "") + "\\">"; }).join(""); }); }' +
    '\nfunction ckNew(){ curSeq = 0; }' +
    // ckSave(quiet) — 저장된 사인 값을 state 에 남긴다
    '\nfunction ckSave(opts){ var seq = curSeq;' +
    '\n  if (state.failSave.indexOf(seq) >= 0) return Promise.reject(new Error("저장 실패"));' +
    '\n  var vals = [].map.call(gel("ckGridWrap").querySelectorAll("input[data-r=\'900\']"), function(el){ return el.value; });' +
    '\n  state.saves.push({ seq: seq, quiet: !!(opts && opts.quiet), signs: vals });' +
    '\n  return Promise.resolve({ chkSeq: seq }); }' +
    grab(S, /\n  window\.BS = \{ busy:false \};/, 'BS') + '\nvar BS = window.BS; var BP = { busy:false }; window.BP = BP;' +
    grab(S, /\n  function bsMonths\(\)\{[\s\S]*?\n  \}/, 'bsMonths') +
    grab(S, /\n  function bsFill\(nm\)\{[\s\S]*?\n  \}/, 'bsFill') +
    grab(S, /\n  window\.ckBulkSignToggle = function\(\)\{[\s\S]*?\n  \};/, 'toggle') +
    grab(S, /\n  window\.ckBulkSignGo = function\(\)\{[\s\S]*?\n  \};/, 'go') +
    '\nreturn { toggle: window.ckBulkSignToggle, go: window.ckBulkSignGo, BS: window.BS,' +
    '\n  setUp: function(fid, seq){ gel("ckForm").value = fid; return ckBase().then(function(){ FORMS = state.formList || [FORM];' +
    '\n    gel("ckDoc").value = String(seq); return ckPickDoc(); }); } };';
  const M = new Function(...Object.keys(ctx), code)(...Object.values(ctx));
  return { M, state, document, $: id => document.getElementById(id) };
}
function opt(sel, vals){ vals.forEach(v => sel.add(new sel.ownerDocument.defaultView.Option(v, v))); }

(async function(){
  const { M, state, $, document } = build();
  opt($('ckForm'), ['F1', 'F2']); opt($('ckDoc'), ['11', '12', '13', '21']);
  state.userNm = '홍길동';
  state.docsOf = {
    F1: [{ chkseq: 11, inyear: '2026', inmm: '03', wardnm: '3층' },
         { chkseq: 12, inyear: '2026', inmm: '05', wardnm: '' },
         { chkseq: 13, inyear: '2026', inmm: '09', wardnm: '3층' }],
    F2: [{ chkseq: 21, inyear: '2026', inmm: '04', wardnm: '3층' }]
  };
  state.cells = {
    11: [{ v: '' }, { v: '' }, { v: '김간호' }],          // 빈 2 · 이미 적힌 1
    12: [{ v: '' }, { v: '', off: true }],                // 빈 2(하나는 토·일 칸)
    13: [{ v: '이간호' }, { v: '박간호' }],                // 이미 다 서명 — 저장하면 안 된다
    21: [{ v: '' }, { v: '', sign: false }]               // 사인 칸 1 + 사인 아닌 칸 1
  };
  state.formList = [{ formid: 'F1', formnm: '서식F1' }, { formid: 'F2', formnm: '서식F2' }];

  await M.setUp('F1', 11);
  M.toggle();
  ok('열림 + 이름·연도·월 범위 기본값', $('ckBulkSignBox').style.display === '' && $('ckBsNm').textContent === '홍길동' &&
     $('ckBsYear').textContent === '2026' && $('ckBsFrom').value === '01' && $('ckBsTo').value === '12');

  state.confirmAuto = false;
  M.go();
  await new Promise(r => setTimeout(r, 30));
  ok('실행 전에 반드시 묻는다 · 취소하면 아무것도 저장하지 않는다', state.asks.length === 1 && /빈 사인 칸만/.test(state.asks[0]) &&
     state.saves.length === 0 && !M.BS.busy);

  state.confirmAuto = true; state.asks.length = 0;
  M.go(); await until(() => !M.BS.busy);
  ok('이 서식만 · 그 해 전체 → 11·12 저장(13 은 이미 다 서명이라 저장 안 함)',
     state.saves.map(s => s.seq).join(',') === '11,12');
  ok('빈 칸만 채우고 이미 적힌 사인은 안 덮는다', JSON.stringify(state.saves[0].signs) === JSON.stringify(['홍길동', '홍길동', '김간호']));
  ok('저장은 조용한 모드(quiet) 로 부른다 — 낱장 저장의 토스트·재조회가 안 돈다', state.saves.every(s => s.quiet) && state.toasts.length === 1);
  ok('결과 안내 · 원래 서식·문서로 복귀', /2건에 사인 4칸/.test($('ckBsStat').textContent) &&
     $('ckForm').value === 'F1' && state.picks[state.picks.length - 1] === 11);

  state.saves.length = 0; state.excl = true;
  M.go(); await until(() => !M.BS.busy);
  ok('「토·일·공휴일 제외」가 켜져 있으면 그 칸은 건너뛴다(12 는 한 칸만)',
     JSON.stringify(state.saves.find(s => s.seq === 12).signs) === JSON.stringify(['홍길동', '']));

  state.excl = false; state.saves.length = 0;
  $('ckBsFrom').value = '04'; $('ckBsTo').value = '06';
  M.go(); await until(() => !M.BS.busy);
  ok('월 범위 4~6 → 5월 문서(12)만', state.saves.map(s => s.seq).join(',') === '12');

  state.saves.length = 0; $('ckBsFrom').value = '01'; $('ckBsTo').value = '12';
  $('ckWardF').value = '(없음)';
  M.go(); await until(() => !M.BS.busy);
  ok('「이 서식만」은 병동 필터를 따른다(병동 없음 → 12)', state.saves.map(s => s.seq).join(',') === '12');

  state.saves.length = 0; $('ckWardF').value = '';
  $('ckBulkSignBox').querySelectorAll('input[name=ckBsScope]')[1].checked = true;
  M.go(); await until(() => !M.BS.busy);
  ok('이 부서 서식 전부 → F1·F2 를 차례로 돌아 11·12·21 저장', state.saves.map(s => s.seq).join(',') === '11,12,21' &&
     state.bases.slice(-3, -1).join(',') === 'F1,F2');
  ok('사인 칸이 아닌 값칸(data-r≠900)은 건드리지 않는다', JSON.stringify(state.saves.find(s => s.seq === 21).signs) === JSON.stringify(['홍길동']));

  $('ckBulkSignBox').querySelectorAll('input[name=ckBsScope]')[0].checked = true;
  state.saves.length = 0; state.failPick = [11];
  M.go(); await until(() => !M.BS.busy);
  ok('못 연 문서는 건너뛴다(앞 문서에 서명하지 않는다)', state.saves.map(s => s.seq).join(',') === '12');

  state.failPick = []; state.saves.length = 0; state.failSave = [11];
  M.go(); await until(() => !M.BS.busy);
  ok('저장이 실패해도 순회는 이어 간다', state.saves.map(s => s.seq).join(',') === '12' && !M.BS.busy && !$('ckBsGo').disabled);

  state.failSave = []; state.saves.length = 0;
  state.cells = { 11: [{ v: '가' }], 12: [{ v: '나' }], 13: [{ v: '다' }] };
  M.go(); await until(() => !M.BS.busy);
  ok('채울 칸이 하나도 없으면 저장조차 하지 않는다(수정일시를 안 건드린다)', state.saves.length === 0 &&
     /없었습니다/.test($('ckBsStat').textContent));

  state.userNm = '';
  $('ckBulkSignBox').style.display = 'none'; state.alerts.length = 0;
  M.toggle();
  ok('로그인 이름이 없으면 열지 않고 알린다', $('ckBulkSignBox').style.display === 'none' && state.alerts.length === 1);

  ok('소스 — ckSave 가 quiet 를 받아 저장만 하고 프라미스를 돌려준다', /window\.ckSave = function\(opts\)\{/.test(S) &&
     /if \(quiet\) return res;/.test(S) && /return post\('\/qps\/chkSave\.do'/.test(S));
  ok('소스 — 일괄 출력·일괄 사인 중엔 작성 현황을 다시 읽지 않는다', /\(window\.BS && window\.BS\.busy\)/.test(S));

  console.log('\n통과 ' + pass + ' · 실패 ' + fail);
  process.exit(fail ? 1 : 0);
})();
