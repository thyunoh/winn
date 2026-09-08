// 격자 사인 칸의 작은 도장(2026-09-08) — 사인 칸에 남는 **이름**으로 도장을 찾아 **종이에만** 찍는다.
// ★확인할 것 : 이름 모으기(중복 없이) · 한 번 물어본 이름은 다시 안 묻는다(없다는 답도 기억) ·
//   꺼 두면 묻지도 않는다 · 서버가 없으면 조용히 넘어간다(이름 그대로 찍힌다).
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
  const dom = new JSDOM('<label><input type="checkbox" id="ckStamp" checked></label><div id="ckGridWrap"></div>');
  const { window } = dom, { document } = window;
  const state = { posts: [], res: { list: [] } };
  const ctx = {
    window, document, state, Promise, Number, String, JSON, Object,
    localStorage: { _m: {}, getItem(k){ return this._m[k] == null ? null : this._m[k]; }, setItem(k, v){ this._m[k] = String(v); } }
  };
  const code =
    'var SIGN_NO = 900;' +
    '\nfunction gel(id){ return document.getElementById(id); }' +
    '\nfunction post(url, data){ state.posts.push({ url: url, data: data });' +
    '\n  if (state.failPost) return Promise.reject(new Error("없는 엔드포인트"));' +
    '\n  return Promise.resolve(state.res); }' +
    grab(S, /\n  var SIGN_IMGS = \{\}, SIGN_ASKED = \{\};/, 'vars') +
    grab(S, /\n  function ckStampOn\(\)\{[\s\S]*?\n  \}/, 'ckStampOn') +
    grab(S, /\n  window\.ckStampSync = function\(\)\{[\s\S]*?\n  \};/, 'ckStampSync') +
    grab(S, /\n  function ckSignNames\(\)\{[\s\S]*?\n  \}/, 'ckSignNames') +
    grab(S, /\n  function ckSignsLoad\(\)\{[\s\S]*?\n  \}/, 'ckSignsLoad') +
    '\nreturn { names: ckSignNames, load: ckSignsLoad, imgs: function(){ return SIGN_IMGS; },' +
    '\n  asked: function(){ return SIGN_ASKED; }, sync: window.ckStampSync, ls: localStorage };';
  const M = new Function(...Object.keys(ctx), code)(...Object.values(ctx));
  return { M, state, document, window };
}

/** 사인 칸(행 900)과 값칸을 섞어 격자를 만든다 — day 는 td 의 data-day */
function grid(document, cells){
  document.getElementById('ckGridWrap').innerHTML = '<table><tr>' + cells.map(function(c){
    return '<td' + (c.day ? (' data-day="' + c.day + '"') : '') + '><input data-r="' + (c.r == null ? 900 : c.r) +
           '" value="' + (c.v || '') + '"></td>';
  }).join('') + '</tr></table>';
}

(async function(){
  const { M, state, document } = build();

  grid(document, [ { v: '김간호', day: 1 }, { v: '박간호', day: 2 }, { v: '김간호', day: 3 },
                   { v: '', day: 4 }, { r: 1, v: '이값칸', day: 5 } ]);
  ok('사인 칸 이름만 · 중복 없이 모은다(값칸·빈 칸 제외)',
     JSON.stringify(M.names()) === JSON.stringify(['김간호', '박간호']));

  state.res = { list: [ { usernm: '김간호', signimg: 'AAA', signmime: 'image/png' } ] };
  await M.load();
  ok('물어본 이름만 서버로 간다', state.posts.length === 1 &&
     state.posts[0].url === '/qps/signNames.do' &&
     JSON.parse(state.posts[0].data.names).map(function(x){ return x.nm; }).join(',') === '김간호,박간호');
  ok('도장이 있는 사람만 그림이 담긴다(데이터 URL)',
     M.imgs()['김간호'] === 'data:image/png;base64,AAA' && M.imgs()['박간호'] === undefined);

  await M.load();
  ok('★한 번 물어본 이름은 다시 안 묻는다 — 도장이 **없다는 답도 기억**한다', state.posts.length === 1);

  grid(document, [ { v: '김간호', day: 1 }, { v: '최간호', day: 2 } ]);
  await M.load();
  ok('새 이름이 생기면 그 이름만 묻는다', state.posts.length === 2 &&
     JSON.parse(state.posts[1].data.names).map(function(x){ return x.nm; }).join(',') === '최간호');

  document.getElementById('ckStamp').checked = false;
  grid(document, [ { v: '한간호', day: 1 } ]);
  await M.load();
  ok('꺼 두면 묻지도 않는다', state.posts.length === 2);

  document.getElementById('ckStamp').checked = true;
  state.failPost = true;
  await M.load();
  ok('★옛 서버(엔드포인트 없음)면 조용히 넘어간다 — 이름 그대로 찍히면 된다', state.posts.length === 3);

  M.sync();
  ok('켜고 끔은 이 브라우저에 기억된다', M.ls.getItem('wnnChkStamp') === '1');
  document.getElementById('ckStamp').checked = false; M.sync();
  ok('끄면 0 으로 남는다', M.ls.getItem('wnnChkStamp') === '0');

  /* ── 소스 검사 : 인쇄 쪽은 격자를 통째로 복제하는 큰 함수라 여기서는 규칙만 확인한다 ── */
  ok('소스 — 인쇄에서 **도장이 있을 때만** 그림으로 바꾼다(없으면 이름 글자)',
     /if \(ckStampOn\(\) && Number\(el\.getAttribute\('data-r'\)\) === SIGN_NO && v && SIGN_IMGS\[v\]\)/.test(S) &&
     /td\.innerHTML = '<img class="stmp"/.test(S));
  ok('소스 — 인쇄 CSS 에 도장 크기(칸 높이에 맞춤)와 색 유지가 있다',
     /img\.stmp\{ height:4\.6mm/.test(S) && /print-color-adjust:exact/.test(S));
  ok('소스 — 낱장 인쇄는 도장을 받아 온 뒤 찍는다(ckPrintGo)',
     /window\.ckPrintGo = function\(\)\{[\s\S]*?ckSignsLoad\(\)[\s\S]*?ckPrint\(\)/.test(S) &&
     /onclick="ckPrintGo\(\);"/.test(S));
  ok('소스 — 일괄 출력도 사진·도장을 기다린 뒤 찍는다',
     /bpPhotosWait\(\)\.then\(ckSignsLoad\)\.then\(function\(\)\{/.test(S));
  ok('소스 — 화면 칸은 그대로 글자다(사인은 글자로 고친다)', !/input.*value=.*SIGN_IMGS/.test(S));

  console.log('\n통과 ' + pass + ' · 실패 ' + fail);
  process.exit(fail ? 1 : 0);
})();
