// B9 병동 고르기·필터·빈 병동 확인 — 소스 JSP 에서 ckDocFill / ckWardForm / ckSave 를 꺼내 가짜 DOM 으로 돌린다
const fs = require('fs');
const { JSDOM } = require('jsdom');
const SRC = require('path').resolve(__dirname, '../../../src/main/webapp/WEB-INF/jsp/main/qpsmgr/qpsChk.jsp');
const s = fs.readFileSync(SRC, 'utf8');
function grab(re, name){ const m = s.match(re); if (!m) throw new Error('못 찾음: ' + name); return m[0]; }
const docFill = grab(/\n  window\.ckDocFill = function\(\)\{[\s\S]*?\n  \};/, 'ckDocFill');
const wardForm = grab(/\n  function ckWardForm\(\)\{[\s\S]*?\n  \}/, 'ckWardForm');
const save = grab(/\n  window\.ckSave = function\(\)\{[\s\S]*?\n  \};/, 'ckSave');
// ckBase 안의 병동 채우기 부분만
const fill = grab(/\n      WARDS = \(res\.wards[\s\S]*?ckDocFill\(\);/, 'ckBase 병동 채우기');

const dom = new JSDOM('<input id="f_wardNm" list="ckWardList"><datalist id="ckWardList"></datalist><select id="ckWardF" style="display:none;"></select><select id="ckDoc"></select><select id="ckYear"><option value="2026" selected>2026</option></select><select id="ckMm"><option value="08" selected>08</option></select>');
const { window } = dom; const { document } = window;
const state = { confirms: [], posts: [], toasts: [] };
const ctx = {
  window, document, Option: window.Option, gel: id => document.getElementById(id), val: id => { const el = document.getElementById(id); return el ? String(el.value || '').trim() : ''; },
  esc: v => String(v == null ? '' : v).replace(/[&<>"]/g, c => ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;'})[c]),
  docPrdLabel: d => (d.inmm ? (Number(d.inmm) + '월') : '연간'),
  _alertBox: () => {}, _toast: m => state.toasts.push(m), err: () => {},
  _confirmBox: o => { state.confirms.push(o); },
  collect: () => ({ vals: [], rows: [], cols: [] }), usesMm: () => true, prdNos: () => [], HEAD_MAX: 8,
  post: (u, m) => { state.posts.push({ u, m }); return { then: f => { f({ chkSeq: 7 }); return { catch: () => {} }; } }; },
  ckBase: () => ({ then: f => {} }), ckPickDoc: () => {},
};
// 실제 페이지에선 window.x 가 곧 전역이다 — Function 안에선 아니므로 별칭을 둔다
const code = 'var WARDS = [], DOCS = [], FORM = null, curSeq = 0, ckWardAskedFor = null;' + wardForm + docFill + save +
  '\nvar ckDocFill = window.ckDocFill, ckSave = window.ckSave;' +
  '\nfunction setState(o){ if (o.DOCS) DOCS = o.DOCS; if (o.FORM !== undefined) FORM = o.FORM; if (o.curSeq !== undefined) curSeq = o.curSeq; if (o.reset) ckWardAskedFor = null; }' +
  '\nfunction baseFill(res){ var keepW = "", wf, seen, wl;' + fill.replace(/\n      var wf = gel\('ckWardF'\), keepW = wf\.value, seen = \{\}, wl = \[\];/, '\n      wf = gel("ckWardF"); keepW = wf.value; seen = {}; wl = [];') + ' }' +
  '\nreturn { setState, baseFill, ckDocFill: window.ckDocFill, ckSave: window.ckSave, ckWardForm, askedFor: () => ckWardAskedFor };';
const M = new Function(...Object.keys(ctx), code)(...Object.values(ctx));

let pass = 0, fail = 0;
const ok = (n, c) => { if (c) { pass++; console.log('  ✅', n); } else { fail++; console.log('  ❌', n); } };
const opts = id => [...document.getElementById(id).options].map(o => o.value);

// 1. 병동 datalist + 필터 항목
const DOCS = [
  { chkseq: 1, inmm: '08', wardnm: '3병동' }, { chkseq: 2, inmm: '08', wardnm: '5병동' }, { chkseq: 3, inmm: '08', wardnm: '' },
  { chkseq: 4, inmm: '09', wardnm: '3병동' },
];
M.setState({ DOCS, FORM: { formid: 'X', deptcd: 'FACIL' }, curSeq: 0 });
M.baseFill({ wards: ['5병동', ' 3병동 ', '', null, '외래'] });
ok('datalist = 병원 병동값(다듬은 것)', opts('ckWardList').join(',') === '5병동,3병동,외래');
ok('필터 = 전체 + 3병동,5병동 + 병동 없음', opts('ckWardF').join(',') === ',3병동,5병동,(없음)' && document.getElementById('ckWardF').style.display === '');
ok('목록 전체 4', opts('ckDoc').length === 5 && /\(4\)/.test(document.getElementById('ckDoc').options[0].text));

// 2. 필터 동작
document.getElementById('ckWardF').value = '3병동'; M.ckDocFill();
ok('3병동 필터 → 2건, 「2/4」 표시', opts('ckDoc').join(',') === ',1,4' && /\(2\/4\)/.test(document.getElementById('ckDoc').options[0].text));
document.getElementById('ckWardF').value = '(없음)'; M.ckDocFill();
ok('병동 없음 필터 → 1건', opts('ckDoc').join(',') === ',3');
M.setState({ curSeq: 2 }); document.getElementById('ckWardF').value = '3병동'; M.ckDocFill();
ok('열어 둔 문서(5병동)가 필터에 빠지면 셀렉트만 빈 줄', document.getElementById('ckDoc').value === '');
document.getElementById('ckWardF').value = ''; M.ckDocFill();
ok('필터 해제 → 열어 둔 문서 다시 선택', document.getElementById('ckDoc').value === '2');
// 다시 baseFill 해도 고른 필터 유지
document.getElementById('ckWardF').value = '5병동'; M.baseFill({ wards: [] });
ok('목록 갱신 뒤 필터 유지', document.getElementById('ckWardF').value === '5병동');

// 3. 병동 없는 서식이면 필터 숨김
M.setState({ DOCS: [{ chkseq: 9, inmm: '01', wardnm: '' }] }); M.baseFill({ wards: [] });
ok('병동 없는 서식 → 필터 숨김, 목록 1', document.getElementById('ckWardF').style.display === 'none' && opts('ckDoc').length === 2);

// 4. 빈 병동 확인
M.setState({ DOCS: [], FORM: { formid: 'F', deptcd: 'FACIL' }, curSeq: 0, reset: true });
document.getElementById('f_wardNm').value = '';
state.confirms.length = 0; state.posts.length = 0; M.ckSave();
ok('시설 서식·병동 문서 없음 → 안 묻고 저장', state.confirms.length === 0 && state.posts.length === 1);
M.setState({ FORM: { formid: 'N1', deptcd: 'NURSE' }, curSeq: 0, reset: true });
state.confirms.length = 0; state.posts.length = 0; M.ckSave();
ok('간호 서식·빈 병동 → 묻고 멈춤', state.confirms.length === 1 && state.posts.length === 0 && /병동 없이/.test(state.confirms[0].msg));
state.confirms[0].onOk();
ok('「병동 없이 저장」 → 저장 1건, 저장된 문서(7)로 표시가 옮겨 간다', state.posts.length === 1 && M.askedFor() === 7);
state.confirms.length = 0; state.posts.length = 0; M.ckSave();
ok('같은 새 문서 두 번째 저장 → 안 묻는다', state.confirms.length === 0 && state.posts.length === 1);
M.setState({ FORM: { formid: 'F2', deptcd: 'FACIL' }, DOCS: [{ chkseq: 1, inmm: '08', wardnm: '3병동' }], curSeq: 0, reset: true });
state.confirms.length = 0; state.posts.length = 0; M.ckSave();
ok('시설 서식이라도 다른 문서가 병동을 적었으면 묻는다', state.confirms.length === 1);
state.confirms[0].onCancel();
ok('취소 → 저장 안 함, 병동 칸 포커스', state.posts.length === 0 && document.activeElement === document.getElementById('f_wardNm'));
document.getElementById('f_wardNm').value = '3병동'; state.confirms.length = 0; state.posts.length = 0; M.ckSave();
ok('병동 적으면 안 묻고 저장(wardNm 전송)', state.confirms.length === 0 && state.posts.length === 1 && state.posts[0].m.wardNm === '3병동');

console.log('\n통과 ' + pass + ' · 실패 ' + fail);
process.exit(fail ? 1 : 0);
