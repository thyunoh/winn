// 불만고충 처리대장 ✨ 분류 추천 (TypeSafe Choice 2문, 2026-09-28)
// ★확인할 것 : 내용 칸을 떠나면(change) 요청 · 빈 유형·민원인구분에만 채우고 연보라 표시 · 사람이 고른 값은 안 덮음 ·
//   문턱(0.6) 아래·NONE 은 비워 둠 · 사람이 바꾸면 표시 제거 후 다시 안 덮음 · 글을 고치면 AI 값은 갱신(안 맞으면 거둠) ·
//   짧은 글·둘 다 사람이 고른 행은 요청 없음 · 행마다 한 번에 한 요청 · 실패는 조용히 · 기다리는 동안 글이 바뀌면 옛 답 버림.
const fs = require('fs');
const path = require('path');
const { JSDOM } = require('jsdom');
function grab(s, re, name){ const m = s.match(re); if (!m) throw new Error('못 찾음: ' + name); return m[0]; }
const S = fs.readFileSync(path.resolve(__dirname, '../../../src/main/webapp/WEB-INF/jsp/main/qpsmgr/qpsCmpl.jsp'), 'utf8')
            .replace(/\r\n/g, '\n').replace(/<c:url value="([^"]*)"\/>/g, '$1');

let pass = 0, fail = 0;
const ok = (n, c) => { if (c) { pass++; console.log('  ✅', n); } else { fail++; console.log('  ❌', n); } };

function build(){
  const dom = new JSDOM('<div id="qpsCmpl"><table><tbody id="cmBody"></tbody></table></div>');
  const { window } = dom, { document } = window;
  const state = { posts: [], res: null, fail: false, hold: null };
  function jq(p){ const t = { then(a, b){ return jq(p.then(a, b)); }, always(f){ p.then(f, f); return t; } }; return t; }
  const CODES = { QPS_CMPL_TYPE: [{subcode:'01',subcodenm:'시설 및 환경'},{subcode:'02',subcodenm:'친절'},{subcode:'03',subcodenm:'식사'},{subcode:'99',subcodenm:'기타'}],
                  QPS_CMPL_PERSON: [{subcode:'01',subcodenm:'입원환자'},{subcode:'02',subcodenm:'보호자'},{subcode:'99',subcodenm:'기타'}] };
  const ctx = { window, document, state, Promise, Number, String, Array, Math, Object, CODES };
  const code =
    '\nfunction gel(id){ return document.getElementById(id); }' +
    '\nfunction esc(s){ return (s==null?"":String(s)).replace(/[&<>"]/g, function(c){ return ({"&":"&amp;","<":"&lt;",">":"&gt;","\\"":"&quot;"})[c]; }); }' +
    '\nfunction paintRow(){}' +
    '\nfunction post(url, data){ state.posts.push({ url: url, data: data });' +
    '\n  if (state.hold) return jq(new Promise(function(res, rej){ state.hold.push(function(){ state.fail ? rej(new Error("x")) : res(state.res); }); }));' +
    '\n  return jq(state.fail ? Promise.reject(new Error("통신 실패")) : Promise.resolve(state.res)); }' +
    grab(S, /\n  function codeOpts\(grp, cd\)\{[\s\S]*?\n  \}/, 'codeOpts') +
    '\nfunction rowHtml(r){ r = r || {}; return "<td><select data-f=\\"typecd\\">" + codeOpts("QPS_CMPL_TYPE", r.typecd) + "</select></td>"' +
    '\n  + "<td><select data-f=\\"personcd\\">" + codeOpts("QPS_CMPL_PERSON", r.personcd) + "</select></td><td><input data-f=\\"content\\" value=\\"" + esc(r.content) + "\\"></td>"; }' +
    '\nfunction addRow(r){ var tr = document.createElement("tr"); tr.innerHTML = rowHtml(r); gel("cmBody").appendChild(tr); return tr; }' +
    grab(S, /\n  gel\(\x27qpsCmpl\x27\)\.addEventListener\(\x27change\x27, function\(e\)\{[\s\S]*?\n  \}\);/, 'change 리스너') +
    grab(S, /\n  var CM_SG_MIN = [\s\S]*?\n  window\.cmSuggestRow = function\(tr\)\{[\s\S]*?\n  \};/, '분류 추천 블록') +
    '\nvar cmSuggestRow = window.cmSuggestRow;' +   // ★Function 안에선 window.x 가 맨이름으로 안 잡힌다(README 함정) — 별칭
    '\nreturn { addRow: addRow };';
  const api = new Function(...Object.keys(ctx), 'jq', code)(...Object.values(ctx), jq);
  const fire = (el, type) => el.dispatchEvent(new window.Event(type, { bubbles: true }));
  return { window, document, state, api, fire };
}
const tick = () => new Promise(r => setTimeout(r, 5));
const q = (tr, f) => tr.querySelector('[data-f=' + f + ']');

(async () => {
  // ① 내용을 적고 떠나면 요청 → 빈 유형·민원인구분에 채우고 표시
  { const t = build(); const tr = t.api.addRow({});
    q(tr,'content').value = '병실이 너무 춥고 화장실이 더럽다'; t.state.res = { ok:true, type:{code:'01',nm:'시설 및 환경',p:0.91,choice:'01'}, person:{code:'02',nm:'보호자',p:0.75,choice:'02'} };
    t.fire(q(tr,'content'), 'change'); await tick();
    ok('요청 본문에 내용이 실린다', t.state.posts.length === 1 && t.state.posts[0].data.text === '병실이 너무 춥고 화장실이 더럽다' && /cmplSuggest/.test(t.state.posts[0].url));
    ok('빈 유형에 채우고 연보라 표시', q(tr,'typecd').value === '01' && q(tr,'typecd').classList.contains('aifill') && /AI 추천 91%/.test(q(tr,'typecd').title));
    ok('빈 민원인구분에도 채운다', q(tr,'personcd').value === '02' && q(tr,'personcd').classList.contains('aifill'));
    // ② 사람이 유형을 바꾸면 표시가 사라지고, 글을 고쳐도 다시 안 덮는다
    q(tr,'typecd').value = '03'; t.fire(q(tr,'typecd'), 'change');
    ok('사람이 바꾸면 표시 제거', !q(tr,'typecd').classList.contains('aifill') && !q(tr,'typecd').title);
    q(tr,'content').value = '밥이 너무 짜고 식었다'; t.state.res = { ok:true, type:{code:'01',nm:'시설',p:0.9,choice:'01'}, person:{code:'01',nm:'입원환자',p:0.9,choice:'01'} };
    t.fire(q(tr,'content'), 'change'); await tick();
    ok('사람이 고른 유형은 안 덮고, AI 가 채운 민원인구분은 갱신', q(tr,'typecd').value === '03' && q(tr,'personcd').value === '01' && t.state.posts.length === 2); }
  // ③ 문턱 아래·NONE 은 비워 둔다 · 예전 AI 값은 안 맞으면 거둔다
  { const t = build(); const tr = t.api.addRow({});
    q(tr,'content').value = '뭔가 불편했다'; t.state.res = { ok:true, type:{code:'99',nm:'기타',p:0.45,choice:'99'}, person:{code:'02',nm:'보호자',p:0.9,choice:'NONE'} };
    t.fire(q(tr,'content'), 'change'); await tick();
    ok('0.6 아래는 비워 둔다', q(tr,'typecd').value === '');
    ok('NONE 이 1등이면 비워 둔다', q(tr,'personcd').value === '');
    t.state.res = { ok:true, type:{code:'02',nm:'친절',p:0.8,choice:'02'}, person:{code:'01',nm:'입원환자',p:0.7,choice:'01'} };
    q(tr,'content').value = '간호사가 불친절했다'; t.fire(q(tr,'content'), 'change'); await tick();
    ok('다음 글에서 채워진다', q(tr,'typecd').value === '02' && q(tr,'personcd').value === '01');
    t.state.res = { ok:true, type:{code:'02',nm:'친절',p:0.3,choice:'02'}, person:{code:'01',nm:'입원환자',p:0.2,choice:'NONE'} };
    q(tr,'content').value = '음'; t.fire(q(tr,'content'), 'change'); await tick();
    ok('짧은 글(4자 미만)은 요청하지 않는다', t.state.posts.length === 2 && q(tr,'typecd').value === '02');
    q(tr,'content').value = '그냥 그랬다'; t.fire(q(tr,'content'), 'change'); await tick();
    ok('새 글에 안 맞으면 AI 값을 거둔다(사람 값이 아니므로)', q(tr,'typecd').value === '' && q(tr,'personcd').value === '' && !q(tr,'typecd').classList.contains('aifill')); }
  // ④ 둘 다 사람이 골라 둔 행은 요청조차 하지 않는다
  { const t = build(); const tr = t.api.addRow({ typecd:'01', personcd:'02' });
    q(tr,'content').value = '병실이 춥다'; t.fire(q(tr,'content'), 'change'); await tick();
    ok('둘 다 골라 둔 행은 요청 없음', t.state.posts.length === 0); }
  // ⑤ 실패(ok=false·통신)는 조용히, 칸 그대로
  { const t = build(); const tr = t.api.addRow({});
    q(tr,'content').value = '병실이 춥다'; t.state.res = { ok:false, reason:'키 없음' }; t.fire(q(tr,'content'), 'change'); await tick();
    ok('ok=false 면 칸 그대로', q(tr,'typecd').value === '' && !tr.getAttribute('data-sg-busy'));
    t.state.fail = true; t.fire(q(tr,'content'), 'change'); await tick(); await tick();
    ok('통신 실패도 조용히 · busy 해제', q(tr,'typecd').value === '' && !tr.getAttribute('data-sg-busy') && t.state.posts.length === 2); }
  // ⑥ 행마다 한 번에 한 요청 · 기다리는 동안 글이 바뀌면 옛 답을 버린다
  { const t = build(); const tr = t.api.addRow({}); t.state.hold = [];
    q(tr,'content').value = '병실이 춥다'; t.fire(q(tr,'content'), 'change'); t.fire(q(tr,'content'), 'change');
    ok('연속 change 에도 요청은 하나', t.state.posts.length === 1 && tr.getAttribute('data-sg-busy') === '1');
    q(tr,'content').value = '밥이 식었다';                      // 답을 기다리는 동안 글이 바뀜
    t.state.res = { ok:true, type:{code:'01',nm:'시설',p:0.95,choice:'01'}, person:{code:'01',nm:'입원환자',p:0.9,choice:'01'} };
    t.state.hold.forEach(f => f()); await tick(); await tick();
    ok('글이 바뀌었으면 옛 답을 버린다 · busy 해제', q(tr,'typecd').value === '' && !tr.getAttribute('data-sg-busy')); }
  // ⑦ 목록에 없는 코드는 넣지 않는다
  { const t = build(); const tr = t.api.addRow({});
    q(tr,'content').value = '병실이 춥다'; t.state.res = { ok:true, type:{code:'77',nm:'없는코드',p:0.95,choice:'77'}, person:{} };
    t.fire(q(tr,'content'), 'change'); await tick();
    ok('목록에 없는 코드는 넣지 않는다', q(tr,'typecd').value === ''); }

  console.log(`\n${pass} 통과 / ${fail} 실패`);
  process.exit(fail ? 1 : 0);
})().catch(e => { console.error(e); process.exit(1); });
