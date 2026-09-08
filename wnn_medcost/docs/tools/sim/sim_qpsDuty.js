// 근무표 화면(qpsDuty.jsp, 2026-09-08) — 사람 × 1~31일 격자 · 붓 · 패턴 · 합계 · 저장 payload · 마감 · 전월 가져오기
// ★페이지 통째 방식 : JSP 의 본문 HTML 과 인라인 스크립트를 그대로 태운다(함수만 떼면 화면과 갈린다).
const fs = require('fs');
const path = require('path');
const { JSDOM } = require('jsdom');

const S = fs.readFileSync(path.resolve(__dirname, '../../../src/main/webapp/WEB-INF/jsp/main/qpsmgr/qpsDuty.jsp'), 'utf8')
            .replace(/\r\n/g, '\n');
let pass = 0, fail = 0;
const ok = (n, c) => { if (c) { pass++; console.log('  ✅', n); } else { fail++; console.log('  ❌', n); } };
const until = f => new Promise(res => { (function t(){ if (f()) return res(); setTimeout(t, 5); })(); });

// ── 화면 HTML(스타일·스크립트 제외) 와 인라인 스크립트를 뽑는다
const body = S.split('</style>')[1].split('<script>')[0].replace(/<%--[\s\S]*?--%>/g, '');
// ⚠따옴표를 덧붙이지 말 것 — 소스가 이미 '…' 안에 넣어 두었다(붙이면 URL 이 "…" 째로 온다)
const code = S.match(/<script>\n([\s\S]*?)<\/script>/)[1].replace(/<c:url value="([^"]*)"\/>/g, '$1');

function build(){
  const dom = new JSDOM('<div id="wrap">' + body + '</div>', { pretendToBeVisual: true });
  const { window } = dom, { document } = window;
  const state = { posts: [], alerts: [], asks: [], toasts: [], prints: [], res: {}, confirmAuto: true };
  const $ = function(fn){ if (typeof fn === 'function') state.ready = fn; return { }; };
  $.post = function(url, data, cb){
    state.posts.push({ url, data });
    const r = state.res[url] ? state.res[url](data) : { result: 'OK' };
    setTimeout(() => cb(r), 0);
    return { fail: function(){ return this; } };
  };
  const ctx = {
    window, document, $, Option: window.Option, Promise, state, Date: window.Date, Math, JSON, Number, String, Object, Array,
    _alertBox: (m) => state.alerts.push(m),
    _confirmBox: (o) => { state.asks.push(o.msg); if (state.confirmAuto) o.onOk(); else if (o.onCancel) o.onCancel(); },
    _toast: (m) => state.toasts.push(m),
    qpsPrintOut: (t, css, html) => state.prints.push({ t, css, html }),
    setTimeout: window.setTimeout.bind(window), setInterval: window.setInterval.bind(window)
  };
  /* ⚠화면의 toast() 는 **window._toast 가 있는지**를 본다 — 인자로만 넘기면 알림으로 떨어진다(실제로 겪음) */
  window._alertBox = ctx._alertBox; window._confirmBox = ctx._confirmBox; window._toast = ctx._toast;
  /* ★`with (window)` 로 태운다 — 화면은 `window.dtLoad = …` 로 만들고 `dtLoad()` 로 부른다.
     브라우저는 window 속성이 곧 전역이라 그냥 되지만, 시뮬의 Function 스코프에서는 안 보인다. */
  new Function(...Object.keys(ctx), 'with (window) {\n' + code + '\n}')(...Object.values(ctx));
  return { window, document, state, $: id => document.getElementById(id) };
}

const SHIFTS = [ {subcode:'D',subcodenm:'주간'}, {subcode:'E',subcodenm:'오후'}, {subcode:'N',subcodenm:'야간'},
                 {subcode:'O',subcodenm:'휴무'}, {subcode:'V',subcodenm:'휴가'}, {subcode:'R',subcodenm:'대체휴무'} ];
const DEPTS = [ {subcode:'NURSE',subcodenm:'간호·병동'}, {subcode:'LAB',subcodenm:'진단검사'} ];
const USERS = [ {userid:'u1',usernm:'김간호'}, {userid:'u2',usernm:'박간호'}, {userid:'u3',usernm:'이간호'} ];

(async function(){
  const { window, document, state, $ } = build();
  // 서버 응답 — 근무표 없음(빈 달)
  state.res['/qps/holidayList.do'] = () => ({ result:'OK', list:[{ holdt:'20260301', holnm:'삼일절' }] });
  state.res['/qps/dutyGet.do'] = (d) => {
    const key = d.deptCd + '|' + d.wardNm + '|' + d.dutyYm;
    if (key === 'NURSE||2026-02') return { result:'OK', dept:DEPTS, shifts:SHIFTS, users:USERS, wards:['3층'],
      duty:{ dutyseq:7, lockyn:'N', upddttm:'2026-02-20 10:00', upduser:'admin' },
      rows:[{ rowno:1, userid:'u1', usernm:'김간호', jobnm:'간호사', sortno:1 },
            { rowno:2, userid:'u2', usernm:'박간호', jobnm:'조무사', sortno:2 }],
      vals:[{ rowno:1, dayno:1, shiftcd:'D' }, { rowno:1, dayno:2, shiftcd:'N' }, { rowno:2, dayno:1, shiftcd:'O' }] };
    return { result:'OK', dept:DEPTS, shifts:SHIFTS, users:USERS, wards:['3층'], duty:null, rows:[], vals:[] };
  };
  state.res['/qps/dutySave.do'] = () => ({ result:'OK', dutySeq: 9 });
  state.res['/qps/dutyLock.do'] = () => ({ result:'OK' });

  state.ready();                                   // $(function(){ ... }) 실행
  await until(() => $('dtHead').innerHTML.length > 0);

  $('dtYear').value = '2026'; $('dtMm').value = '03';
  await window.dtLoad();
  ok('부서 셀렉트를 서버 목록으로 채운다', $('dtDept').options.length === 2 && $('dtDept').value === 'NURSE');
  ok('그 달 날짜만큼 열이 선다(2026-03 = 31일)', $('dtHead').querySelectorAll('th').length === 31 + 4);
  ok('토·일·공휴일 머리에 표시가 붙는다(3/1 = 일·삼일절)',
     /class="hol"[^>]*title="삼일절"/.test($('dtHead').innerHTML) && /class="sun"/.test($('dtHead').innerHTML));
  ok('기호 팔레트 = 지움 + 공통코드 6종', $('dtPal').querySelectorAll('button').length === 7);
  ok('아직 저장 전이면 그렇게 알린다', /저장 전/.test($('dtInfo').textContent));

  // ── 사람 추가
  $('dtUser').value = 'u1'; window.dtAddBlank();
  $('dtUser').value = 'u2'; window.dtAddBlank();
  ok('직원을 고르면 이름이 들어간 줄이 선다', $('dtBody').querySelectorAll('tr[data-rn]').length === 2 &&
     $('dtBody').querySelector('input[data-f=usernm]').value === '김간호');
  $('dtUser').value = 'u1'; state.alerts.length = 0; window.dtAddBlank();
  ok('같은 사람을 두 번 넣지 않는다', $('dtBody').querySelectorAll('tr[data-rn]').length === 2 && state.alerts.length === 1);

  // ── 붓으로 칠하기
  const pal = $('dtPal').querySelectorAll('button');
  pal[1].dispatchEvent(new window.MouseEvent('click', { bubbles:true }));      // D
  ok('붓을 들면 그 기호가 켜진다', pal[1].classList.contains('on') && /붓: D/.test($('dtStat').textContent));
  const c1 = $('dtBody').querySelector('input.dc[data-rn="1"][data-d="1"]');
  c1.dispatchEvent(new window.MouseEvent('mousedown', { bubbles:true }));
  const c2 = $('dtBody').querySelector('input.dc[data-rn="1"][data-d="2"]');
  c2.dispatchEvent(new window.MouseEvent('mouseover', { bubbles:true }));      // 끌어서 이어 칠하기
  ok('칸을 눌러(끌어) 칠한다', c1.value === 'D' && c2.value === 'D');
  document.dispatchEvent(new window.MouseEvent('mouseup', { bubbles:true }));
  const c3 = $('dtBody').querySelector('input.dc[data-rn="1"][data-d="3"]');
  c3.dispatchEvent(new window.MouseEvent('mouseover', { bubbles:true }));
  ok('마우스를 놓으면 칠하기가 멎는다', c3.value === '');

  // ── 더블클릭 = 기호 돌려가며
  c3.dispatchEvent(new window.MouseEvent('dblclick', { bubbles:true }));
  const first = c3.value;
  c3.dispatchEvent(new window.MouseEvent('dblclick', { bubbles:true }));
  ok('더블클릭하면 기호가 차례로 바뀐다', first === 'D' && c3.value === 'E');

  // ── 반복 패턴
  $('dtPat').value = 'DDNNOO';
  window.dtPatRow($('dtBody').querySelectorAll('tr[data-rn]')[1].querySelector('button[title="반복 패턴 채우기"]'));
  const r2 = [].map.call($('dtBody').querySelectorAll('tr[data-rn]')[1].querySelectorAll('input.dc'), e => e.value);
  ok('반복 패턴이 1일부터 되풀이된다', r2.slice(0, 8).join('') === 'DDNNOODD' && r2.length === 31);

  // ── 합계 (휴무 O·휴가 V·대체휴무 R 은 근무일수에서 뺀다)
  ok('근무일수는 쉬는 기호를 뺀다', $('dtBody').querySelectorAll('tr[data-rn]')[1].querySelector('td[data-sum]').textContent ===
     String(r2.filter(v => v && ['O','V','R'].indexOf(v) < 0).length));
  ok('바닥에 그날 근무 인원이 선다', /그날 근무 인원/.test($('dtFoot').innerHTML));

  // ── 저장 payload
  state.posts.length = 0;
  window.dtSave();
  await until(() => state.posts.some(p => p.url === '/qps/dutySave.do'));
  const sent = state.posts.find(p => p.url === '/qps/dutySave.do').data;
  const rows = JSON.parse(sent.rows), vals = JSON.parse(sent.vals);
  ok('저장은 부서·병동·연월과 함께 간다', sent.deptCd === 'NURSE' && sent.dutyYm === '2026-03');
  ok('차례(sortNo)는 화면에 보이는 순서 — 사인 매치가 이 순서로 고른다',
     rows.length === 2 && rows[0].sortNo === 1 && rows[1].sortNo === 2 && rows[0].userNm === '김간호');
  ok('빈 칸은 값으로 보내지 않는다', vals.every(v => v.shiftCd) && vals.some(v => v.rowNo === 1 && v.dayNo === 1 && v.shiftCd === 'D'));

  // ── 이름 없는 줄
  state.posts.length = 0; state.alerts.length = 0;
  [].forEach.call($('dtBody').querySelectorAll('input[data-f=usernm]'), e => { e.value = ''; });
  window.dtSave();
  ok('이름이 하나도 없으면 저장하지 않고 알린다', !state.posts.length && state.alerts.length === 1);

  // ── 전월 가져오기
  //   ⚠앞선 저장이 부르는 **재조회가 끝난 뒤**에 눌러야 한다 — 저장 직후엔 화면이 서버 값으로 다시 그려진다.
  await new Promise(r => setTimeout(r, 60));
  state.confirmAuto = true; state.toasts.length = 0;
  $('dtMm').value = '03';
  window.dtPrev('all');
  await until(() => state.toasts.length > 0);
  ok('전월(2026-02) 사람과 근무를 가져온다', $('dtBody').querySelectorAll('tr[data-rn]').length === 2 &&
     $('dtBody').querySelector('input.dc[data-rn="1"][data-d="2"]').value === 'N' &&
     /2026-02 에서 2명/.test(state.toasts[0]));
  ok('가져온 것은 아직 저장 전이라고 말한다', /저장/.test(state.toasts[0]));

  // ── 마감
  state.res['/qps/dutyGet.do'] = () => ({ result:'OK', dept:DEPTS, shifts:SHIFTS, users:USERS, wards:['3층'],
    duty:{ dutyseq:7, lockyn:'Y', lockdttm:'2026-03-31 18:00', upddttm:'2026-03-31 18:00', upduser:'admin' },
    rows:[{ rowno:1, userid:'u1', usernm:'김간호', jobnm:'간호사', sortno:1 }],
    vals:[{ rowno:1, dayno:1, shiftcd:'D' }] });
  await window.dtLoad();
  ok('마감된 근무표는 값이 보이되 못 고친다', $('dtBody').querySelector('input.dc').readOnly === true &&
     /마감됨/.test($('dtLockBox').textContent));
  state.posts.length = 0; state.alerts.length = 0;
  window.dtSave();
  ok('마감 중에는 저장하지 않고 이유를 말한다', !state.posts.some(p => p.url === '/qps/dutySave.do') && state.alerts.length === 1);

  // ── 인쇄
  state.prints.length = 0;
  window.dtPrint();
  ok('인쇄는 공통 창구(qpsPrintOut)로 · 가로 A4 · 기호 범례를 붙인다', state.prints.length === 1 &&
     /A4 landscape/.test(state.prints[0].css) && /근무 기호 : D=주간/.test(state.prints[0].html));

  ok('소스 — 조회에 순번 가드가 있다(늦게 온 옛 응답이 새 달을 덮지 않게)',
     /var my = \+\+LOAD_REQ;/.test(S) && /if \(my !== LOAD_REQ\) return;/.test(S));
  ok('소스 — 붓은 처음엔 안 들려 있다(BRUSH = null)', /var BRUSH = null/.test(S));

  console.log('\n통과 ' + pass + ' · 실패 ' + fail);
  process.exit(fail ? 1 : 0);
})();
