// 보고서(safeRpt) 반복행 「직원 이름 열」(NAME_COLS, 2026-09-09)
// ★확인할 것 : 서식이 켠 **그 열에만** 인사 등록 명단이 붙는다 · 켜지 않은 열(환자·가족·외부 봉사자)엔 안 붙는다 ·
//   [＋ 행 추가]로 **뒤에 생긴 행에도** 붙는다 · 벌마다 따로 켠다 · 단벌(FORM)도 된다 ·
//   옛 문서 구제 벌(no=0)도 열 정의를 물려받는다 · 명단이 비거나 옛 서버면 조용히 종전대로 자유 입력.
const fs = require('fs');
const path = require('path');
const { JSDOM } = require('jsdom');
function grab(s, re, name){ const m = s.match(re); if (!m) throw new Error('못 찾음: ' + name); return m[0]; }
// ⚠작업본은 CRLF — 줄 끝을 고르게 만들어야 `\n  }` 앵커가 맞는다
const S = fs.readFileSync(path.resolve(__dirname, '../../../src/main/webapp/WEB-INF/jsp/main/qpsmgr/qpsSafeRpt.jsp'), 'utf8')
            .replace(/\r\n/g, '\n').replace(/<c:url value="([^"]*)"\/>/g, '$1');

let pass = 0, fail = 0;
const ok = (n, c) => { if (c) { pass++; console.log('  ✅', n); } else { fail++; console.log('  ❌', n); } };

function build(){
  const dom = new JSDOM('<div id="qpsSafeRpt"><div id="cardRow"></div><div id="srRowBox"></div><span id="srRowNm"></span></div>');
  const { window } = dom, { document } = window;
  const state = { posts: [], res: { list: [] }, FORM: {}, SUBS: [] };
  const ctx = { window, document, state, Promise, Number, String, Object, Array };
  const code =
    '\nfunction gel(id){ return document.getElementById(id); }' +
    '\nfunction esc(s){ return (s==null?"":String(s)).replace(/[&<>"]/g, function(c){' +
    '\n  return ({"&":"&amp;","<":"&lt;",">":"&gt;","\\"":"&quot;"})[c]; }); }' +
    '\nfunction srTabSync(){}' +
    '\nvar MIN_ROWS = 3;' +
    '\nvar FORM = state.FORM, SUBS = state.SUBS;' +
    '\nfunction post(url, data){ state.posts.push({ url: url, data: data });' +
    '\n  if (state.failPost) return Promise.reject(new Error("없는 엔드포인트"));' +
    '\n  return Promise.resolve(state.res); }' +
    grab(S, /\n  function subCols\(\)\{[\s\S]*?\n  \}/, 'subCols') +
    grab(S, /\n  function nameColSet\(s\)\{[\s\S]*?\n  \}/, 'nameColSet') +
    grab(S, /\n  function subDefs\(\)\{[\s\S]*?\n  \}/, 'subDefs') +
    grab(S, /\n  function withLegacySet\(defs, byset\)\{[\s\S]*?\n  \}/, 'withLegacySet') +
    grab(S, /\n  function splitRowVals\(vals\)\{[\s\S]*?\n  \}/, 'splitRowVals') +
    grab(S, /\n  function renderRows\(vals\)\{[\s\S]*?\n  \}/, 'renderRows') +
    grab(S, /\n  var SR_NAMES = null;/, 'SR_NAMES') +
    grab(S, /\n  function srNamePickSync\(\)\{[\s\S]*?\n  \}/, 'srNamePickSync') +
    grab(S, /\n  function rowHtml\(nCol, v, names\)\{[\s\S]*?\n  \}/, 'rowHtml') +
    grab(S, /\n  function namesOfBox\(box\)\{[\s\S]*?\n  \}/, 'namesOfBox') +
    grab(S, /\n  window\.srRowAdd = function\(btn\)\{[\s\S]*?\n  \};/, 'srRowAdd') +
    '\nreturn { renderRows: renderRows, subDefs: subDefs, nameColSet: nameColSet,' +
    '\n         rowAdd: window.srRowAdd, setForm: function(f){ FORM = state.FORM = f; },' +
    '\n         setSubs: function(s){ SUBS = state.SUBS = s; } };';
  const M = new Function(...Object.keys(ctx), code)(...Object.values(ctx));
  return { M, state, document, window };
}
const tick = () => new Promise(r => setTimeout(r, 5));
const cellsOf = (document, sub) => [].slice.call(
  document.querySelectorAll('#srRowBox .rowset[data-sub="' + sub + '"] tbody tr:first-child input'));

(async function(){
  console.log('▶ 보고서 반복행 직원 이름 열 (qpsSafeRpt)');

  // ── 벌(SUBS) — 혈액 반납 신청서처럼 일부 열만 직원 이름
  {
    const B = build();
    B.M.setSubs([ { subno: 1, subnm: '혈액', subcols: '제제명,혈액번호,담당간호사,담당의사', namecols: '3,4' } ]);
    B.state.res = { list: [ { usernm: '김간호', jobnm: '간호사' }, { usernm: '박의사', jobnm: '의사' } ] };
    B.M.renderRows([]);
    await tick();
    const c = cellsOf(B.document, 1);
    ok('켠 열(3·4)에만 명단이 붙는다', c.length === 4 &&
       c[0].getAttribute('list') === null && c[1].getAttribute('list') === null &&
       c[2].getAttribute('list') === 'srNmList' && c[3].getAttribute('list') === 'srNmList');
    ok('명단을 한 번 묻는다 — 부서로 좁히지 않는다(보고서는 부서가 자유 글자)',
       B.state.posts.length === 1 && B.state.posts[0].url === '/qps/signerPicks.do' && B.state.posts[0].data.deptCd === '');
    const dl = B.document.getElementById('srNmList');
    ok('datalist 에 이름·직종이 담긴다', !!dl && dl.querySelectorAll('option').length === 2 &&
       dl.querySelector('option').value === '김간호' && /간호사/.test(dl.innerHTML));
    ok('★입력을 막지 않는다 — 명단에 없는 이름도 칠 수 있다',
       c[2].tagName === 'INPUT' && !c[2].readOnly && !c[2].disabled);

    // [＋ 행 추가]
    const box = B.document.querySelector('.rowset[data-sub="1"]');
    const btn = { closest: () => box };
    B.M.rowAdd(btn);
    const last = [].slice.call(box.querySelectorAll('tbody tr')).pop().querySelectorAll('input');
    ok('★[＋ 행 추가]로 뒤에 생긴 행에도 붙는다', last[2].getAttribute('list') === 'srNmList' &&
       last[0].getAttribute('list') === null);
  }

  // ── 켜지 않은 유형(환자·가족·외부 봉사자 열)
  {
    const B = build();
    B.M.setSubs([ { subno: 3, subnm: '가족사항', subcols: '관계,성명,생년월일' } ]);   // NAME_COLS 없음
    B.state.res = { list: [ { usernm: '김간호', jobnm: '간호사' } ] };
    B.M.renderRows([]);
    await tick();
    const c = cellsOf(B.document, 3);
    ok('★★켜지 않으면 「성명」 열이라도 안 붙는다(가족·환자·외부인 자리)',
       c.every(e => e.getAttribute('list') === null));
    ok('이름 열이 없으면 명단을 묻지도 않는다', B.state.posts.length === 0 && !B.document.getElementById('srNmList'));
  }

  // ── 벌마다 따로
  {
    const B = build();
    B.M.setSubs([ { subno: 1, subnm: '의사별', subcols: '담당의사,퇴원환자 수', namecols: '1' },
                  { subno: 2, subnm: '병동별', subcols: '병동,퇴원환자 수' } ]);
    B.state.res = { list: [ { usernm: '박의사', jobnm: '의사' } ] };
    B.M.renderRows([]);
    await tick();
    ok('벌1은 붙고 벌2는 안 붙는다(같은 유형 안에서도 벌마다 따로)',
       cellsOf(B.document, 1)[0].getAttribute('list') === 'srNmList' &&
       cellsOf(B.document, 2)[0].getAttribute('list') === null);
  }

  // ── 단벌(FORM)
  {
    const B = build();
    B.M.setForm({ subnm: '상담', subcols: '상담 근로자,내용', namecols: '1' });
    B.state.res = { list: [ { usernm: '한보건', jobnm: '보건관리자' } ] };
    B.M.renderRows([]);
    await tick();
    const c = cellsOf(B.document, 0);
    ok('단벌(FORM.SUB_COLS)도 켤 수 있다', c[0].getAttribute('list') === 'srNmList' && c[1].getAttribute('list') === null);
  }

  // ── 옛 문서 구제 벌(no=0)
  {
    const B = build();
    B.M.setForm({ subcols: '담당간호사,비고', namecols: '1' });
    B.M.setSubs([ { subno: 1, subnm: '새 벌', subcols: '담당간호사,비고', namecols: '1' } ]);
    B.state.res = { list: [ { usernm: '김간호', jobnm: '간호사' } ] };
    B.M.renderRows([ { rowno: 1, colno: 1, val: '옛이름' } ]);          // 벌 번호 없는 옛 값
    await tick();
    ok('옛 문서 구제 벌(0)도 열 정의를 물려받아 명단이 붙는다',
       !!B.document.querySelector('.rowset[data-sub="0"]') &&
       cellsOf(B.document, 0)[0].getAttribute('list') === 'srNmList');
  }

  // ── 인사 등록이 빈 병원 / 옛 서버
  {
    const B = build();
    B.M.setSubs([ { subno: 1, subcols: '담당의사,비고', namecols: '1' } ]);
    B.state.res = { list: [] };
    B.M.renderRows([]); await tick();
    ok('인사 등록이 비면 datalist 를 만들지 않는다 — 칸은 그대로 자유 입력',
       B.state.posts.length === 1 && !B.document.getElementById('srNmList'));
  }
  {
    const B = build();
    B.M.setSubs([ { subno: 1, subcols: '담당의사,비고', namecols: '1' } ]);
    B.state.failPost = true;
    let died = false;
    try { B.M.renderRows([]); await tick(); } catch (e) { died = true; }
    ok('★옛 서버(엔드포인트 없음)면 조용히 넘어간다 — 화면이 죽지 않는다', !died && !B.document.getElementById('srNmList'));
  }

  // ── 열 번호 파싱
  {
    const B = build();
    const n = B.M.nameColSet({ namecols: ' 5, 6 ,7,8 ' });
    ok('열 번호는 공백을 지우고 읽는다', n[5] && n[6] && n[7] && n[8] && !n[1]);
    ok('빈 값·0·글자는 무시한다', Object.keys(B.M.nameColSet({ namecols: '' })).length === 0 &&
       Object.keys(B.M.nameColSet({ namecols: '0,x, ' })).length === 0 &&
       Object.keys(B.M.nameColSet(null)).length === 0);
  }

  console.log('\n통과 ' + pass + ' · 실패 ' + fail);
  process.exit(fail ? 1 : 0);
})();
