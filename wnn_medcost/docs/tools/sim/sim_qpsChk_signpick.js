// 점검표 사인 칸 「이름 고르기」(2026-09-09) — 인사 등록 명단을 <datalist> 로 붙여 고를 수도, 그대로 칠 수도 있게 한다.
// ★확인할 것 : 사인 칸에만 붙는다 · 부서로 좁혀 묻는다 · 명단이 비면 아무것도 안 한다(자유 입력 그대로) ·
//   옛 서버(엔드포인트 없음)면 조용히 넘어간다 · 부서가 그대로면 다시 묻지 않는다 · **입력을 막지 않는다**(datalist 는 고르기일 뿐).
const fs = require('fs');
const path = require('path');
const { JSDOM } = require('jsdom');
function grab(s, re, name){ const m = s.match(re); if (!m) throw new Error('못 찾음: ' + name); return m[0]; }
// ⚠작업본은 CRLF — 줄 끝을 고르게 만들어야 `\n  }` 앵커가 맞는다
const S = fs.readFileSync(path.resolve(__dirname, '../../../src/main/webapp/WEB-INF/jsp/main/qpsmgr/qpsChk.jsp'), 'utf8')
            .replace(/\r\n/g, '\n').replace(/<c:url value="([^"]*)"\/>/g, '$1');

let pass = 0, fail = 0;
const ok = (n, c) => { if (c) { pass++; console.log('  ✅', n); } else { fail++; console.log('  ❌', n); } };

function build(){
  const dom = new JSDOM('<div id="qpsChk"><div id="ckGridWrap"></div></div>');
  const { window } = dom, { document } = window;
  const state = { posts: [], res: { list: [] }, FORM: { deptcd: 'NURSE' }, screenDept: '' };
  const ctx = { window, document, state, Promise, Number, String, JSON, Object, Array };
  const code =
    'var SIGN_NO = 900;' +
    '\nfunction gel(id){ return document.getElementById(id); }' +
    '\nfunction esc(s){ return (s==null?"":String(s)).replace(/[&<>"]/g, function(c){' +
    '\n  return ({"&":"&amp;","<":"&lt;",">":"&gt;","\\"":"&quot;"})[c]; }); }' +
    '\nvar FORM = state.FORM;' +
    '\nfunction val(id){ return state.screenDept; }' +
    '\nfunction post(url, data){ state.posts.push({ url: url, data: data });' +
    '\n  if (state.failPost) return Promise.reject(new Error("없는 엔드포인트"));' +
    '\n  return Promise.resolve(state.res); }' +
    grab(S, /\n  function ckFormDept\(\)\{[\s\S]*?\n  \}/, 'ckFormDept') +
    grab(S, /\n  var PICK_NAMES = null, PICK_DEPT = null;/, 'PICK vars') +
    grab(S, /\n  function ckSignPickLoad\(\)\{[\s\S]*?\n  \}/, 'ckSignPickLoad') +
    grab(S, /\n  window\.ckSignPickSync = function\(\)\{[\s\S]*?\n  \};/, 'ckSignPickSync') +
    '\nreturn { sync: window.ckSignPickSync, setForm: function(f){ FORM = f; } };';
  const M = new Function(...Object.keys(ctx), code)(...Object.values(ctx));
  return { M, state, document, window };
}

/** 사인 칸(행 900)과 값칸을 섞어 격자를 만든다 */
function grid(document, cells){
  document.getElementById('ckGridWrap').innerHTML = '<table><tr>' + cells.map(function(c){
    return '<td><input data-r="' + (c.r == null ? 900 : c.r) + '" value="' + (c.v || '') + '"></td>';
  }).join('') + '</tr></table>';
}
const dl = (document) => document.getElementById('ckSignNmList');
const signCells = (document) => [].filter.call(document.querySelectorAll('#ckGridWrap input[data-r]'),
                                               e => Number(e.getAttribute('data-r')) === 900);

(async function(){
  console.log('▶ 점검표 사인 칸 이름 고르기 (qpsChk)');
  const { M, state, document } = build();

  // ── 사인 칸이 있는 서식
  grid(document, [ { v: '' }, { v: '' }, { r: 1, v: '값칸' } ]);
  state.res = { list: [ { usernm: '김간호', jobnm: '간호사', hasimg: 'Y' },
                        { usernm: '박조무', jobnm: '조무사', hasimg: 'N' } ] };
  await M.sync();
  ok('명단을 부서로 좁혀 묻는다(서식 부서)', state.posts.length === 1 &&
     state.posts[0].url === '/qps/signerPicks.do' && state.posts[0].data.deptCd === 'NURSE');
  ok('datalist 가 서고 이름·직종이 담긴다(사인 있는 사람은 ✎)', !!dl(document) &&
     dl(document).querySelectorAll('option').length === 2 &&
     dl(document).querySelector('option').value === '김간호' &&
     /간호사 ✎/.test(dl(document).innerHTML) && /조무사/.test(dl(document).innerHTML));
  ok('★사인 칸에만 붙는다 — 값칸은 그대로 자유 입력', signCells(document).every(e => e.getAttribute('list') === 'ckSignNmList') &&
     document.querySelector('#ckGridWrap input[data-r="1"]').getAttribute('list') === null);
  ok('★입력을 막지 않는다 — 그냥 input 이라 명단에 없는 이름도 칠 수 있다',
     signCells(document)[0].tagName === 'INPUT' && !signCells(document)[0].readOnly && !signCells(document)[0].disabled);

  // ── 같은 부서면 다시 묻지 않는다
  grid(document, [ { v: '' } ]);
  await M.sync();
  ok('부서가 그대로면 다시 묻지 않고 붙이기만 한다', state.posts.length === 1 &&
     signCells(document)[0].getAttribute('list') === 'ckSignNmList');

  // ── 부서가 바뀌면 다시 묻는다
  M.setForm({ deptcd: 'COMMON' }); state.screenDept = 'LAB';
  state.res = { list: [ { usernm: '이검사', jobnm: '임상병리사', hasimg: 'N' } ] };
  grid(document, [ { v: '' } ]);
  await M.sync();
  ok('부서가 바뀌면 그 부서로 다시 묻고 목록을 갈아 끼운다', state.posts.length === 2 &&
     state.posts[1].data.deptCd === 'LAB' && dl(document).querySelectorAll('option').length === 1 &&
     dl(document).querySelector('option').value === '이검사');

  // ── 사인 칸이 없는 서식
  {
    const B = build();
    grid(B.document, [ { r: 1, v: '값칸' }, { r: 2, v: '값칸' } ]);
    await B.M.sync();
    ok('사인 칸이 없는 서식은 묻지도 않는다', B.state.posts.length === 0 && !dl(B.document));
  }

  // ── 인사 등록이 빈 병원
  {
    const B = build();
    B.state.res = { list: [] };
    grid(B.document, [ { v: '' } ]);
    await B.M.sync();
    ok('인사 등록이 비면 datalist 를 만들지 않는다 — 종전대로 자유 입력', B.state.posts.length === 1 && !dl(B.document) &&
       signCells(B.document)[0].getAttribute('list') === null);
  }

  // ── 옛 서버
  {
    const B = build();
    B.state.failPost = true;
    grid(B.document, [ { v: '' } ]);
    let died = false;
    try { await B.M.sync(); } catch (e) { died = true; }
    ok('★옛 서버(엔드포인트 없음)면 조용히 넘어간다 — 화면이 죽지 않는다', !died && !dl(B.document));
  }

  /* ── 소스 검사 ── */
  ok('소스 — 표를 새로 그릴 때마다 붙인다(renderGrid 끝)', /ckSignPickSync\(\);\s+\/\/ 사인 칸에 인사 등록 이름 고르기/.test(S));
  ok('소스 — datalist 는 화면 안에 둔다(사본이 둘일 때 섞이지 않게)', /gel\('qpsChk'\) \|\| document\.body/.test(S));

  console.log('\n통과 ' + pass + ' · 실패 ' + fail);
  process.exit(fail ? 1 : 0);
})();
