// 선택 칸(SEL) 가짜 DOM 검증 — 소스 JSP 에서 cell/selOpts/selHtml/noxCls/esc/collect 를 그대로 꺼내 돌린다
const fs = require('fs');
const { JSDOM } = require('jsdom');
const SRC = require('path').resolve(__dirname, '../../../src/main/webapp/WEB-INF/jsp/main/qpsmgr/qpsChk.jsp');
const s = fs.readFileSync(SRC, 'utf8');
function fn(name) {
  const re = new RegExp('\\n  function ' + name + '\\([^)]*\\)\\{[\\s\\S]*?\\n  \\}');
  const m = s.match(re); if (!m) throw new Error('함수 못 찾음: ' + name); return m[0];
}
const dom = new JSDOM('<div id="ckGridWrap"></div>');
const { window } = dom; const { document } = window;
const ctx = { document, window, SIGN_NO: 900, PRDH_NO: 890, SUB_ROW_BASE: 9000, gel: id => document.getElementById(id) };
const code = [fn('esc'), fn('cell'), fn('selOpts'), fn('selHtml'), fn('noxCls'), fn('collect'), fn('ckOxOk')].join('\n');
const f = new Function(...Object.keys(ctx), code + '\nreturn { esc, cell, selOpts, selHtml, noxCls, collect, ckOxOk };');
const M = f(...Object.values(ctx));

let pass = 0, fail = 0;
const ok = (name, c) => { if (c) { pass++; console.log('  ✅', name); } else { fail++; console.log('  ❌', name); } };

// 1. selOpts — SEL 이고 CELL_TXTS 있을 때만
ok('selOpts TEXT → null', M.selOpts({ inputgb: 'TEXT', celltxts: '유,무' }) === null);
ok('selOpts SEL 빈 목록 → null', M.selOpts({ inputgb: 'SEL', celltxts: ' , ' }) === null);
ok('selOpts SEL → 3', JSON.stringify(M.selOpts({ inputgb: 'SEL', celltxts: '유, 무 ,응급' })) === '["유","무","응급"]');

// 2. cell — opts 있으면 select, 없으면 input(종전)
const inp = M.cell(3, 5, 'O', '', 5);
ok('cell 종전 input 그대로', /^<td data-day="5"><input data-r="3" data-c="5" value="O"><\/td>$/.test(inp));
const sel = M.cell(3, 5, '', '', 5, ['유', '무']);
ok('cell select 렌더 + empty', /<td data-day="5"><select data-r="3" data-c="5" class="empty"><option value=""><\/option><option value="유">유<\/option><option value="무">무<\/option><\/select><\/td>/.test(sel));
const sel2 = M.cell(3, 5, '무', '', null, ['유', '무']);
ok('cell select 값 선택됨', /<option value="무" selected>무<\/option>/.test(sel2) && !/class="empty"/.test(sel2));
const sel3 = M.cell(3, 5, '보류', '', null, ['유', '무']);
ok('옛 글자 값은 목록 끝에 살아남음', /<option value="보류" selected>보류<\/option>$/.test(sel3.replace(/<\/select><\/td>$/, '')));
ok('선택지 글자 이스케이프', /<option value="a&amp;b">a&amp;b<\/option>/.test(M.cell(1, 1, '', '', null, ['a&b'])));

// 3. noxCls
ok('noxCls TEXT/NUM → nox, CHECK/SEL → 빈', M.noxCls({ inputgb: 'TEXT' }) === 'nox' && M.noxCls({ inputgb: 'NUM' }) === 'nox' && M.noxCls({ inputgb: 'CHECK' }) === '' && M.noxCls({ inputgb: 'SEL' }) === '');

// 4. collect — select 값이 담기고 빈 select 는 안 담긴다
document.getElementById('ckGridWrap').innerHTML = '<table><tr>' +
  M.cell(1, 1, 'O') + M.cell(1, 2, '', 'ltxt') + M.cell(1, 3, '무', '', null, ['유', '무']) + M.cell(1, 4, '', '', null, ['유', '무']) +
  '<td><input data-rn="1" value="홍길동"></td></tr></table>';
const c = M.collect();
ok('collect: input O + select 무 (빈 select 제외)', JSON.stringify(c.vals) === '[{"rowno":1,"colno":1,"val":"O"},{"rowno":1,"colno":3,"val":"무"}]');
ok('collect: 행 이름', JSON.stringify(c.rows) === '[{"rowno":1,"rownm":"홍길동"}]');
// select 값을 바꾼 뒤 다시 collect
document.querySelector('select[data-c="4"]').value = '유';
ok('collect: 고른 뒤 담김', M.collect().vals.some(v => v.colno === 4 && v.val === '유'));

// 5. ckOxOk — select 와 nox 는 토글 대상 아님
ok('ckOxOk: select 제외', M.ckOxOk(document.querySelector('select[data-c="3"]')) === false);
ok('ckOxOk: O 칸은 대상', M.ckOxOk(document.querySelector('input[data-c="1"]')) === true);
const nx = document.createElement('input'); nx.className = 'nox'; nx.setAttribute('data-r', '3');
ok('ckOxOk: nox 제외', M.ckOxOk(nx) === false);

// 6. 인쇄 변환 — 소스의 변환 구문 그대로(input, select → 글자)
const src = document.querySelector('table'), t = src.cloneNode(true);
const srcEls = src.querySelectorAll('input, select');
t.querySelectorAll('input, select').forEach(function(el, i){ const td = el.parentNode; td.textContent = String((srcEls[i] || el).value || ''); });
ok('인쇄: select 도 글자로(화면 원본 값)', t.textContent === 'O무유홍길동');
ok('인쇄 소스: 원본 차례로 읽음', /var srcEls = src\.querySelectorAll\('input, select'\)/.test(s) && /String\(\(srcEls\[i\] \|\| el\)\.value \|\| ''\)/.test(s));

// 7. 소스 정적 확인 — 여섯 호출 자리 전부 selOpts 를 넘긴다 · dblclick 가드 · change 리스너
ok('호출 자리 selOpts 6곳', (s.match(/selOpts\(r\)\)/g) || []).length === 6);
ok('dblclick SELECT 가드', /t\.tagName === 'SELECT' \|\| t\.tagName === 'OPTION'\) return;/.test(s));
ok("change 리스너 empty 토글", /addEventListener\('change'/.test(s) && /classList\.toggle\('empty', !t\.value\)/.test(s));
ok('collect 셀렉터 select 포함', /#ckGridWrap input\[data-r\], #ckGridWrap select\[data-r\]/.test(s));
ok('인쇄 querySelectorAll input, select', /t\.querySelectorAll\('input, select'\)/.test(s));

console.log('\n통과 ' + pass + ' · 실패 ' + fail);
process.exit(fail ? 1 : 0);
