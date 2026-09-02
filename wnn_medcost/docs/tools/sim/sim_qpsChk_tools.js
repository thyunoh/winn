/* qpsChk.jsp 「편의 기능」+「2차 이식(배타·공휴일·주차)」 블록을 배포 파일에서 그대로 꺼내 가짜 DOM 으로 검증 (2026-09-02)
   — 프로젝트 관행(배포 JSP 함수를 Node 로 태우기)과 같은 방식. */
const fs = require('fs');
const { JSDOM } = require('jsdom');

const JSP = require('path').resolve(__dirname, '../../../src/main/webapp/WEB-INF/jsp/main/qpsmgr/qpsChk.jsp');
const src = fs.readFileSync(JSP, 'utf8');
const a = src.indexOf('/* ═══ 편의 기능 — SUNWOO'), b = src.indexOf('window.ckSave = function');
if (a < 0 || b < 0) throw new Error('블록 표식을 못 찾음');
const block = src.slice(a, b).replace(/<c:url value="([^"]*)"\/>/g, '$1');   // JSTL 은 경로 글자로

const html = `<!doctype html><body><div id="qpsChk" data-wnn="Y">
<select id="ckYear"><option value="2026" selected>2026</option><option value="2027">2027</option></select>
<select id="ckMm"><option value="09" selected>09</option><option value="02">02</option></select>
<div id="ckTools" style="display:none"><input type="checkbox" id="ckExclWk"><button id="ckWeekBtn"></button><span id="ckHolBtnWrap"></span><span id="ckExclNote"></span></div>
<div id="ckHolPanel" style="display:none"></div>
<div id="ckGridWrap">
 <table class="gr" id="T1"><thead><tr>
   <th class="hd">점검 항목</th><th class="side">설명</th>
   <th data-day="1">1</th><th data-day="5">5</th><th class="sat" data-day="6">6</th><th class="sun" data-day="7">7</th><th data-day="24">24</th><th data-day="25">25</th>
   <th class="side">비고</th></tr></thead><tbody>
  <tr class="prdh"><th class="hd">기간</th><td></td>
   <td data-day="1"><input data-r="890" data-c="1"></td><td data-day="5"><input data-r="890" data-c="5"></td>
   <td data-day="6"><input data-r="890" data-c="6"></td><td data-day="7"><input data-r="890" data-c="7"></td><td data-day="24"><input data-r="890" data-c="24"></td><td data-day="25"><input data-r="890" data-c="25"></td><td></td></tr>
  <tr id="R1"><th class="hd">소독</th><td><input class="ltxt" data-r="1" data-c="1001" value="설명"></td>
   <td data-day="1"><input data-r="1" data-c="1" value=""></td><td data-day="5"><input data-r="1" data-c="5" value=""></td>
   <td data-day="6"><input data-r="1" data-c="6" value=""></td><td data-day="7"><input data-r="1" data-c="7" value="X"></td>
   <td data-day="24"><input data-r="1" data-c="24" value=""></td><td data-day="25"><input data-r="1" data-c="25" value=""></td>
   <td><input class="ltxt" data-r="1" data-c="2001" value=""></td></tr>
  <tr id="R2"><th class="hd">청소</th><td><input class="ltxt" data-r="2" data-c="1001" value=""></td>
   <td data-day="1"><input data-r="2" data-c="1" value=""></td><td data-day="5"><input data-r="2" data-c="5" value="O"></td>
   <td data-day="6"><input data-r="2" data-c="6" value=""></td><td data-day="7"><input data-r="2" data-c="7" value=""></td>
   <td data-day="24"><input data-r="2" data-c="24" value=""></td><td data-day="25"><input data-r="2" data-c="25" value=""></td>
   <td><input class="ltxt" data-r="2" data-c="2001" value=""></td></tr>
  <tr class="sign"><th class="hd">점검자 사인</th><td></td>
   <td data-day="1"><input data-r="900" data-c="1" value=""></td><td data-day="5"><input data-r="900" data-c="5" value="김철수"></td>
   <td data-day="6"><input data-r="900" data-c="6" value=""></td><td data-day="7"><input data-r="900" data-c="7" value=""></td>
   <td data-day="24"><input data-r="900" data-c="24" value=""></td><td data-day="25"><input data-r="900" data-c="25" value=""></td><td></td></tr>
 </tbody></table>
 <table class="gr" id="T2"><thead><tr><th class="hd">번호</th><th data-col="1">결과</th><th data-col="2">조치</th></tr></thead><tbody>
  <tr><td class="hd">1</td><td><input data-r="1" data-c="1" value=""></td><td><input class="ltxt" data-r="1" data-c="2" value=""></td></tr>
  <tr><td class="hd">2</td><td><input data-r="2" data-c="1" value="O"></td><td><input class="ltxt" data-r="2" data-c="2" value=""></td></tr>
 </tbody></table>
 <table class="gr" id="T3"><thead><tr><th class="hd">의료기기</th><th data-day="1">1</th></tr></thead><tbody>
  <tr id="E1"><td class="hd"><input data-rn="1" value=""></td><td data-day="1"><input data-r="1" data-c="1" value="O"></td></tr>
  <tr id="E2"><td class="hd"><input data-rn="2" value="심전도기"></td><td data-day="1"><input data-r="2" data-c="1" value=""></td></tr>
 </tbody></table>
 <table class="gr" id="T4"><tbody><tr><td><input data-r="9001" data-c="1" value=""></td></tr></tbody></table>
 <!-- 평가표(ITEM_COL) : 상/중/하 + 뒤 글자칸 -->
 <table class="gr" id="T5"><thead><tr><th class="hd">항목</th><th data-col="1">상</th><th data-col="2">중</th><th data-col="3">하</th><th class="side">비고</th></tr></thead><tbody>
  <tr id="X1"><th class="hd">근태</th><td><input data-r="1" data-c="1" value=""></td><td><input data-r="1" data-c="2" value=""></td><td><input data-r="1" data-c="3" value=""></td><td><input class="ltxt" data-r="1" data-c="2001" value=""></td></tr>
  <tr id="X2"><th class="hd">협조</th><td><input data-r="2" data-c="1" value="O"></td><td><input data-r="2" data-c="2" value=""></td><td><input data-r="2" data-c="3" value=""></td><td><input class="ltxt" data-r="2" data-c="2001" value=""></td></tr>
  <tr id="X3"><th class="hd">성과</th><td><input data-r="3" data-c="1" value=""></td><td><input data-r="3" data-c="2" value="O"></td><td><input data-r="3" data-c="3" value=""></td><td><input class="ltxt" data-r="3" data-c="2001" value=""></td></tr>
 </tbody></table>
 <!-- 주차 격자 -->
 <table class="gr" id="T6"><thead><tr><th class="hd">항목</th><th data-day="1">1주</th><th data-day="2">2주</th><th data-day="3">3주</th><th data-day="4">4주</th><th data-day="5">5주</th></tr></thead><tbody>
  <tr class="prdh"><th class="hd">날짜</th><td data-day="1"><input data-r="890" data-c="1" value=""></td><td data-day="2"><input data-r="890" data-c="2" value="적어둔 값"></td><td data-day="3"><input data-r="890" data-c="3" value=""></td><td data-day="4"><input data-r="890" data-c="4" value=""></td><td data-day="5"><input data-r="890" data-c="5" value=""></td></tr>
  <tr><th class="hd">점검</th><td data-day="1"><input data-r="1" data-c="1"></td><td data-day="2"><input data-r="1" data-c="2"></td><td data-day="3"><input data-r="1" data-c="3"></td><td data-day="4"><input data-r="1" data-c="4"></td><td data-day="5"><input data-r="1" data-c="5"></td></tr>
 </tbody></table>
 <!-- DAY_ITEM 행 머리 -->
 <table class="gr" id="T7"><thead><tr><th>일</th><th>항목A</th></tr></thead><tbody>
  <tr><td class="hd" data-day="24">24</td><td><input data-r="24" data-c="1"></td></tr>
  <tr><td class="hd" data-day="25">25</td><td><input data-r="25" data-c="1"></td></tr>
 </tbody></table>
</div></div></body>`;

const dom = new JSDOM(html, { url: 'http://localhost/' });
const { window } = dom, document = window.document;
document.cookie = 's_usernm=' + encodeURIComponent('홍길동');
const log = { alert: [], toast: [], confirm: 0, post: [] };
let HOLIDAYS = [{ holdt: '20260924', holnm: '추석 연휴' }, { holdt: '20260925', holnm: '추석' }];
const thenable = v => ({ then(ok, fail){ let r; try { r = ok ? ok(v) : v; } catch (e) { r = fail ? fail(e) : undefined; } return thenable(r); }, catch(){ return this; } });
const $ = { Deferred(){ let v; return { resolve(x){ v = x; return this; }, promise(){ return thenable(v); } }; } };
const stubs = {
  gel: id => document.getElementById(id),
  kind: () => (FORMV.prdkind || 'D'),
  dowCls: d => { const w = new Date(2026, 8, d).getDay(); return w === 0 ? ' sun' : (w === 6 ? ' sat' : ''); },
  axis: () => FORMV.axisgb,
  prdHeadOn: () => FORMV.prdheadyn === 'Y' && (FORMV.axisgb === 'ITEM_DAY' || FORMV.axisgb === 'ITEM_MONTH'),
  SIGN_NO: 900, PRDH_NO: 890, SUB_ROW_BASE: 9000, PRE_BASE: 1000,
  val: id => { const e = document.getElementById(id); return e ? String(e.value).trim() : ''; },
  esc: s => String(s == null ? '' : s).replace(/[&<>"]/g, c => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;' })[c]),
  err: e => log.alert.push('ERR ' + (e && e.message)),
  post: (url, data) => { log.post.push(url + ' ' + JSON.stringify(data)); if (/holidayList/.test(url)) return thenable({ list: HOLIDAYS }); return thenable({ result: 'OK' }); },
  _alertBox: m => log.alert.push(m), _toast: m => log.toast.push(m), _confirmBox: o => { log.confirm++; o.onOk(); },
  localStorage: { _m: {}, getItem(k){ return this._m[k] == null ? null : this._m[k]; }, setItem(k, v){ this._m[k] = String(v); } },
  $,
};
let FORMV = { formid: 'X', axisgb: 'ITEM_DAY', prdkind: 'D', exclyn: 'N', prdheadyn: 'N', grpprd: '' };
const fn = new Function('window', 'document', 'FORM', ...Object.keys(stubs),
  block + '\n;return { ckFlip, ckOxOk, ckCellOff, ckRowOffSync, ckExclOn, ckExclApply, ckHolLoad, ckHolTint, ckIsHol, ckWeekRanges };');
// FORM 은 참조로 넘겨 테스트마다 속성을 바꾼다
const api = fn(window, document, FORMV, ...Object.values(stubs));

const $q = s => document.querySelector(s);
const $$ = s => [...document.querySelectorAll(s)];
const inp = (t, r, c) => $q(`#${t} input[data-r="${r}"][data-c="${c}"]`);
const dbl = el => el.dispatchEvent(new window.MouseEvent('dblclick', { bubbles: true, cancelable: true }));
const key = (el, ctrl) => el.dispatchEvent(new window.KeyboardEvent('keydown', { key: 'Enter', ctrlKey: !!ctrl, bubbles: true, cancelable: true }));
const typeIn = (el, v) => { el.value = v; el.dispatchEvent(new window.Event('input', { bubbles: true })); };
let pass = 0, fail = 0;
const ok = (name, cond, note) => { (cond ? pass++ : fail++); console.log((cond ? '  ✅ ' : '  ❌ ') + name + (note ? '  ' + note : '')); };

console.log('■ ① 셀 더블클릭 토글');
const c11 = inp('T1', 1, 1);
dbl(c11); ok('빈→O', c11.value === 'O');
dbl(c11); ok('O→X', c11.value === 'X');
dbl(c11); ok('X→빈', c11.value === '');
console.log('■ ② 글자 칸·기간 머리·자유행은 토글 안 됨');
const lt = inp('T1', 1, 1001); dbl(lt); ok('ltxt 그대로', lt.value === '설명');
const p1 = inp('T1', 890, 1); dbl(p1); ok('890 그대로', p1.value === '');
const s9 = inp('T4', 9001, 1); dbl(s9); ok('9000+ 그대로', s9.value === '');
console.log('■ ③ 사인 칸 더블클릭');
const sg1 = inp('T1', 900, 1); dbl(sg1); ok('빈 사인칸 → 내 이름', sg1.value === '홍길동');
const sg5 = inp('T1', 900, 5); dbl(sg5); ok('적힌 사인칸 유지', sg5.value === '김철수');
console.log('■ ④ 날짜 머리 더블클릭 = 세로줄');
inp('T1', 1, 5).value = ''; inp('T1', 2, 5).value = 'O';
dbl($q('#T1 thead th[data-day="5"]'));
ok('1행 5일 빈→O', inp('T1', 1, 5).value === 'O'); ok('2행 5일 O→X', inp('T1', 2, 5).value === 'X');
ok('890·사인 행 그대로', inp('T1', 890, 5).value === '' && inp('T1', 900, 5).value === '김철수');
console.log('■ ⑤ data-col 머리 더블클릭');
dbl($q('#T2 thead th[data-col="1"]'));
ok('T2 1행 빈→O · 2행 O→X · ltxt 무관', inp('T2', 1, 1).value === 'O' && inp('T2', 2, 1).value === 'X' && inp('T2', 1, 2).value === '');
console.log('■ ⑥ 항목 머리 더블클릭 = 가로줄');
$$('#R2 input[data-r]').forEach(e => e.value = ''); inp('T1', 2, 1001).value = 'memo';
dbl($q('#R2 th.hd'));
ok('2행 값칸 전부 O · 옆 글자칸 유지', [1, 5, 6, 7, 24, 25].every(c => inp('T1', 2, c).value === 'O') && inp('T1', 2, 1001).value === 'memo');
console.log('■ ⑦ 사인 행 머리 더블클릭 = 일괄 서명 (빈 칸만 · 토·일 제외)');
$$('#T1 tr.sign input').forEach(e => { if (e.getAttribute('data-c') !== '5') e.value = ''; });
$q('#ckExclWk').checked = true;
dbl($q('#T1 tr.sign th.hd'));
ok('1일 채움 · 5일 유지 · 토(6)·일(7) 건너뜀', inp('T1', 900, 1).value === '홍길동' && inp('T1', 900, 5).value === '김철수' && inp('T1', 900, 6).value === '' && inp('T1', 900, 7).value === '');
console.log('■ ⑧ Enter = 오른쪽 복사');
$$('#R1 input[data-r]').forEach(e => e.value = ''); inp('T1', 1, 1001).value = '설명';
const c15 = inp('T1', 1, 5); c15.value = 'X'; key(c15, false);
ok('오른쪽 복사 · 왼쪽·글자칸 그대로', inp('T1', 1, 6).value === 'X' && inp('T1', 1, 7).value === 'X' && inp('T1', 1, 1).value === '' && inp('T1', 1, 2001).value === '');
console.log('■ ⑨ Ctrl+Enter = 아래 복사');
$$('#T1 input[data-r]').forEach(e => { if (e.getAttribute('data-c') === '1') e.value = ''; }); inp('T1', 900, 1).value = '홍길동';
const c11b = inp('T1', 1, 1); c11b.value = 'O'; key(c11b, true);
ok('2행 복사 · 890·사인 그대로', inp('T1', 2, 1).value === 'O' && inp('T1', 890, 1).value === '' && inp('T1', 900, 1).value === '홍길동');
console.log('■ ⑩ 전체 O / 전체 지움');
$$('#ckGridWrap input[data-r]').forEach(e => { if (api.ckOxOk(e)) e.value = ''; });
inp('T1', 1, 5).value = 'X'; $q('#ckExclWk').checked = true;
window.ckAllOx('O');
ok('빈 칸 O · 적힌 X 유지 · 토·일 비움', inp('T1', 1, 1).value === 'O' && inp('T2', 1, 1).value === 'O' && inp('T1', 1, 5).value === 'X' && inp('T1', 1, 6).value === '' && inp('T1', 2, 7).value === '');
window.ckAllOx('');
ok('지움 = confirm 후 전부 빈 · 사인·글자칸 유지', log.confirm === 1 && $$('#ckGridWrap input[data-r]').filter(api.ckOxOk).every(e => e.value === '') && inp('T1', 900, 1).value === '홍길동' && inp('T1', 1, 1001).value === '설명');
console.log('■ ⑪ 이름 칸 빈 행 = 흐리게만');
api.ckRowOffSync();
ok('E1 rowoff · readOnly 아님 · E2 정상', !inp('T3', 1, 1).readOnly && $q('#E1').classList.contains('rowoff') && !$q('#E2').classList.contains('rowoff'));
inp('T3', 1, 1).value = ''; dbl(inp('T3', 1, 1)); ok('흐린 행도 토글 됨', inp('T3', 1, 1).value === 'O');
const nm = $q('#T3 input[data-rn="1"]'); typeIn(nm, '체온계'); ok('이름 채우면 표시 풀림', !$q('#E1').classList.contains('rowoff'));
console.log('■ ⑫ ckCellOff — 머리글 없는 표는 dowCls 로');
const t4 = document.createElement('table'); t4.className = 'gr'; t4.innerHTML = '<tbody><tr class="sign"><td data-day="6"><input data-r="900" data-c="6"></td></tr></tbody>';
$q('#ckGridWrap').appendChild(t4); $q('#ckExclWk').checked = true;
ok('thead 없는 표의 6일(2026-09-06 일요일) = 휴일', api.ckCellOff(t4.querySelector('input')) === true);
t4.querySelector('td').setAttribute('data-day', '7'); ok('7일(월요일)은 아님', api.ckCellOff(t4.querySelector('input')) === false);

console.log('■ ⑬ 행 배타 체크(EXCL_YN, ITEM_COL) — 한 줄에 O 하나');
FORMV.axisgb = 'ITEM_COL'; FORMV.exclyn = 'Y';
ok('ckExclOn', api.ckExclOn() === true);
dbl(inp('T5', 1, 1)); ok('X1 상=O', inp('T5', 1, 1).value === 'O');
dbl(inp('T5', 1, 2)); ok('X1 중=O 찍으면 상 지워짐', inp('T5', 1, 2).value === 'O' && inp('T5', 1, 1).value === '');
inp('T5', 1, 3).value = 'X'; dbl(inp('T5', 1, 1)); ok('X 는 안 건드림(O 끼리만 배타)', inp('T5', 1, 1).value === 'O' && inp('T5', 1, 3).value === 'X' && inp('T5', 1, 2).value === '');
typeIn(inp('T5', 2, 3), 'O'); ok('손으로 O 쳐도 그 줄 다른 O 지워짐', inp('T5', 2, 3).value === 'O' && inp('T5', 2, 1).value === '');
inp('T5', 3, 2001).value = '비고글'; typeIn(inp('T5', 3, 3), 'o'); ok('소문자 o 도 O 로 봄 · 뒤 글자칸 안 건드림', inp('T5', 3, 2).value === '' && inp('T5', 3, 2001).value === '비고글');
dbl($q('#T5 thead th[data-col="2"]'));   // 열 머리 = 그 열로 채우기
ok('열 머리 더블클릭 → 그 열 O · 각 줄의 다른 O 지워짐', [1, 2, 3].every(r => inp('T5', r, 2).value === 'O' && inp('T5', r, 1).value === '' && (inp('T5', r, 3).value === '' || inp('T5', r, 3).value === 'X')));
const before = [1, 2, 3].map(c => inp('T5', 1, c).value).join('|'); const tc = log.toast.length;
dbl($q('#X1 th.hd')); ok('가로줄 토글은 안 함(토스트)', [1, 2, 3].map(c => inp('T5', 1, c).value).join('|') === before && log.toast.length === tc + 1);
inp('T5', 1, 1).value = 'O'; inp('T5', 1, 2).value = ''; key(inp('T5', 1, 1), false); ok('Enter 오른쪽 복사 안 됨', inp('T5', 1, 2).value === '' && inp('T5', 1, 3).value !== 'O');
inp('T5', 2, 1).value = ''; inp('T5', 2, 2).value = 'O'; key(inp('T5', 1, 1), true); ok('Ctrl+Enter 아래 복사 → 아래 줄의 다른 O 지워짐', inp('T5', 2, 1).value === 'O' && inp('T5', 2, 2).value === '' && inp('T5', 3, 1).value === 'O');
const ac = log.alert.length; window.ckAllOx('O'); ok('전체 O 는 안내만', log.alert.length === ac + 1 && inp('T5', 1, 2).value === '' );
FORMV.exclyn = 'N';
$$('#T5 input[data-r]').forEach(e => { if (Number(e.getAttribute('data-c')) < 1000) e.value = ''; });
dbl(inp('T5', 1, 1)); dbl(inp('T5', 1, 2)); ok('EXCL_YN=N 이면 둘 다 O', inp('T5', 1, 1).value === 'O' && inp('T5', 1, 2).value === 'O');
FORMV.axisgb = 'ITEM_DAY';

console.log('■ ⑭ 공휴일 — 색 · 제외');
let got; api.ckHolLoad().then(m => { got = m; });
ok('연 단위 받아 캐시(9월 24·25)', got && got['0924'] === '추석 연휴' && got['0925'] === '추석' && log.post.some(p => /holidayList.*2026/.test(p)));
api.ckHolTint();
ok('열 머리 25 에 hol + title', $q('#T1 thead th[data-day="25"]').classList.contains('hol') && $q('#T1 thead th[data-day="25"]').title === '추석');
ok('DAY_ITEM 행 머리 25 도 hol · 1 은 아님', $q('#T7 td.hd[data-day="25"]').classList.contains('hol') && !$q('#T1 thead th[data-day="1"]').classList.contains('hol'));
ok('주차 머리(1주)는 안 칠함', !$q('#T6 thead th[data-day="1"]').classList.contains('hol'));
$q('#ckExclWk').checked = true;
ok('ckCellOff : 25일 칸 = 제외 · 24일 도 제외 · 5일 은 아님', api.ckCellOff(inp('T1', 1, 25)) && api.ckCellOff(inp('T1', 1, 24)) && !api.ckCellOff(inp('T1', 1, 5)));
$$('#T1 input[data-r]').forEach(e => { if (api.ckOxOk(e)) e.value = ''; });
window.ckAllOx('O'); ok('전체 O 가 공휴일 칸을 건너뜀', inp('T1', 1, 25).value === '' && inp('T1', 1, 24).value === '' && inp('T1', 1, 1).value === 'O');
$$('#T1 tr.sign input').forEach(e => e.value = ''); dbl($q('#T1 tr.sign th.hd'));
ok('일괄 서명이 공휴일 칸을 건너뜀', inp('T1', 900, 25).value === '' && inp('T1', 900, 1).value === '홍길동');
$q('#ckExclWk').checked = false; ok('제외 끄면 공휴일도 대상', !api.ckCellOff(inp('T1', 1, 25)));
ok('머리글 없는 표 폴백도 공휴일 봄', (() => { $q('#ckExclWk').checked = true; t4.querySelector('td').setAttribute('data-day', '25'); return api.ckCellOff(t4.querySelector('input')) === true; })());

console.log('■ ⑮ 주차 날짜 자동 채움');
FORMV.prdheadyn = 'Y'; FORMV.prdkind = 'N';
const wr = api.ckWeekRanges();
ok('2026-09 : 5주 = 1~6 · 7~13 · 14~20 · 21~27 · 28~30', wr.map(w => w.txt).join(' ') === '9/1~9/6 9/7~9/13 9/14~9/20 9/21~9/27 9/28~9/30', wr.map(w => w.txt).join(' '));
window.ckWeekFill(false);
ok('빈 칸만 채움 · 적어둔 값 유지', inp('T6', 890, 1).value === '9/1~9/6' && inp('T6', 890, 2).value === '적어둔 값' && inp('T6', 890, 5).value === '9/28~9/30');
ok('날짜 격자(T1)의 890 은 안 건드림', inp('T1', 890, 1).value === '');
window.ckWeekFill(true); ok('force 면 전부 다시 씀', inp('T6', 890, 2).value === '9/7~9/13');
$q('#ckMm').value = '02'; $q('#ckYear').value = '2027';
const wr2 = api.ckWeekRanges(); ok('2027-02(월요일 시작·28일) : 4주', wr2.map(w => w.txt).join(' ') === '2/1~2/7 2/8~2/14 2/15~2/21 2/22~2/28', wr2.map(w => w.txt).join(' '));
$q('#ckMm').value = '09'; $q('#ckYear').value = '2026';

console.log('\n결과 : 통과 ' + pass + ' · 실패 ' + fail + '   (alert ' + log.alert.length + ' · toast ' + log.toast.length + ' · post ' + log.post.length + ')');
process.exit(fail ? 1 : 0);
