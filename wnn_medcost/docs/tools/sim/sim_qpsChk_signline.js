// 서식 아래 결재란(SIGN_LINE, 2026-09-08) — 종이 아래쪽 「점검자 ______ (인)」 자리를 화면에서 찍는다.
// ★위 결재 상자(병원 결재선)와 **같은 표**에 예약 대역 901~910 으로 담는다.
// 볼 것 : 자리는 서식이 정한다 · 찍힌 자리는 도장/이름 · 빈 자리는 **빈 줄 그대로**(손도장) ·
//         내가 찍은 것만 취소 · 남이 찍은 칸은 알림 · 새 문서면 상자가 사라진다.
const fs = require('fs');
const path = require('path');
const { JSDOM } = require('jsdom');
function grab(s, re, name){ const m = s.match(re); if (!m) throw new Error('못 찾음: ' + name); return m[0]; }
const S = fs.readFileSync(path.resolve(__dirname, '../../../src/main/webapp/WEB-INF/jsp/main/qpsmgr/qpsChk.jsp'), 'utf8')
            .replace(/\r\n/g, '\n').replace(/<c:url value="([^"]*)"\/>/g, '$1');

let pass = 0, fail = 0;
const ok = (n, c) => { if (c) { pass++; console.log('  ✅', n); } else { fail++; console.log('  ❌', n); } };

function build(){
  const dom = new JSDOM('<div id="ckApprBox"></div><div id="ckSlineBox"></div>');
  const { window } = dom, { document } = window;
  const state = { posts: [], asks: [], alerts: [], toasts: [], askAuto: true, res: {} };
  const ctx = { window, document, state, Promise, Number, String, Object };
  const code =
    'var curSeq = 7, FORM = { formid:"F1", signline:"점검자,관리자" };' +
    '\nvar APPR_BOX = [], APPR_ME = "u1", SLINE_BOX = [];' +
    '\nfunction gel(id){ return document.getElementById(id); }' +
    '\nfunction esc(s){ return String(s == null ? "" : s); }' +
    '\nfunction err(e){ state.alerts.push("ERR " + (e && e.message)); }' +
    '\nfunction _alertBox(m){ state.alerts.push(m); }' +
    '\nfunction _toast(m){ state.toasts.push(m); }' +
    '\nfunction ckAsk(msg, o){ state.asks.push(msg); return Promise.resolve(state.askAuto); }' +
    '\nfunction ckApprPaint(){ }' +
    '\nfunction apprFit(b){ return b; }' +
    '\nfunction post(url, data){ state.posts.push({ url: url, data: data });' +
    '\n  if (state.failPost) return Promise.reject(new Error("실패"));' +
    '\n  return Promise.resolve(state.res); }' +
    grab(S, /\n  function apprTake\(res\)\{[\s\S]*?\n  \}/, 'apprTake') +
    grab(S, /\n  function ckSlinePaint\(\)\{[\s\S]*?\n  \}/, 'ckSlinePaint') +
    grab(S, /\n  document\.getElementById\('ckSlineBox'\)\.addEventListener\('click', function\(ev\)\{[\s\S]*?\n  \}\);/, 'click') +
    '\nreturn { take: apprTake, paint: ckSlinePaint, box: function(){ return SLINE_BOX; },' +
    '\n  setMe: function(v){ APPR_ME = v; }, setSeq: function(v){ curSeq = v; } };';
  const M = new Function(...Object.keys(ctx), code)(...Object.values(ctx));
  return { M, state, document, window };
}

const RES = () => ({
  me: 'u1',
  box: [ { stepno: 1, stepnm: '담당' } ],
  sline: [ { stepno: 901, stepnm: '점검자', userid: 'u1', usernm: '김간호',
             signimg: 'AAA', signmime: 'image/png', apprdt: '2026-09-08', apprdttm: '2026-09-08 10:00', can: 'Y' },
           { stepno: 902, stepnm: '관리자', can: 'Y' } ]
});

(async function(){
  const { M, state, document, window } = build();
  M.take(RES());
  const box = document.getElementById('ckSlineBox');
  ok('서식이 정한 자리만큼 칸이 선다(점검자·관리자)', box.querySelectorAll('.ck-apst').length === 2 &&
     /서식 결재란/.test(box.textContent));
  ok('찍힌 자리는 도장 그림 — ★날짜 줄은 없다(사용자 「일자는 들어가면 안 됩니다」)',
     /<img src="data:image\/png;base64,AAA"/.test(box.innerHTML) && !box.querySelector('.ft'));
  ok('내가 찍은 칸은 표시가 다르다(mine)', /class="ck-apst mine"/.test(box.innerHTML));
  ok('빈 자리는 「비어 있음」', /비어 있음/.test(box.innerHTML));
  ok('안내는 종이의 뜻을 말한다(비우면 빈 줄 = 손도장)', /빈 줄로 나갑니다/.test(box.textContent));

  // 빈 칸을 눌러 서명
  state.res = RES(); state.res.sline[1].userid = 'u1'; state.res.sline[1].usernm = '김간호'; state.res.sline[1].signimg = 'BBB';
  box.querySelectorAll('.ck-apst')[1].dispatchEvent(new window.MouseEvent('click', { bubbles: true }));
  await new Promise(r => setTimeout(r, 20));
  ok('빈 자리를 누르면 묻고 → 서명한다', state.asks.length === 1 && /내 도장/.test(state.asks[0]) &&
     state.posts.length === 1 && state.posts[0].url === '/qps/chkApprSave.do' &&
     state.posts[0].data.stepNo === 902 && state.posts[0].data.stepNm === '관리자');
  ok('서명 뒤 상자가 다시 그려진다', /BBB/.test(box.innerHTML) && state.toasts[0] === '서명했습니다.');

  // 내가 찍은 칸 → 취소
  state.res = RES(); state.res.sline[0] = { stepno: 901, stepnm: '점검자', can: 'Y' };
  box.querySelectorAll('.ck-apst')[0].dispatchEvent(new window.MouseEvent('click', { bubbles: true }));
  await new Promise(r => setTimeout(r, 20));
  ok('내가 찍은 칸은 눌러 취소한다', /취소/.test(state.asks[1]) &&
     state.posts[1].url === '/qps/chkApprDel.do' && state.posts[1].data.stepNo === 901);

  // 남이 찍은 칸
  const r2 = RES(); r2.sline[0].userid = 'u9'; r2.sline[0].usernm = '박간호';
  M.take(r2);
  state.alerts.length = 0; state.posts.length = 0;
  box.querySelectorAll('.ck-apst')[0].dispatchEvent(new window.MouseEvent('click', { bubbles: true }));
  await new Promise(r => setTimeout(r, 20));
  ok('★남이 찍은 칸은 건드리지 않는다 — 알리고 끝', state.posts.length === 0 &&
     /박간호/.test(state.alerts[0]) && /그 사람이 취소해야/.test(state.alerts[0]));

  // 자리가 없는 서식 · 새 문서
  M.take({ me: 'u1', box: [], sline: [] });
  ok('서식이 결재란을 안 쓰면 상자가 없다', box.style.display === 'none' && box.innerHTML === '');
  M.take(RES()); M.setSeq(0); M.paint();
  ok('새 문서(저장 전)에는 안 나온다 — 찍을 문서가 없다', box.style.display === 'none');

  /* ── 소스 검사 — 인쇄와 서버 규칙 ── */
  ok('소스 — 인쇄는 서명한 자리만 도장, 빈 자리는 빈 줄 그대로',
     /var d = \(SLINE_BOX \|\| \[\]\)\.filter\(function\(x\)\{ return Number\(x\.stepno\) === \(900 \+ 1 \+ i\); \}\)\[0\];/.test(S) &&
     /_____________ \(인\)/.test(S) && /img class="sigimg"/.test(S));
  ok('소스 — 인쇄 CSS 에 도장 크기·색 유지', /\.sig img\.sigimg\{ height:9mm/.test(S) && /print-color-adjust:exact/.test(S));
  ok('소스 — 인쇄에도 날짜를 안 찍는다(sigdt 없음)', !/class="sigdt"/.test(S));
  ok('소스 — 두 상자는 한 응답으로 함께 세운다(apprTake)',
     /SLINE_BOX = res\.sline \|\| \[\];/.test(S) && (S.match(/apprTake\(res\);/g) || []).length >= 3);

  console.log('\n통과 ' + pass + ' · 실패 ' + fail);
  process.exit(fail ? 1 : 0);
})();
