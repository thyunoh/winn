// assessment.jsp runCreate 의 success 처리기를 꺼내 응답 4가지로 태운다
const fs = require('fs');
const s = fs.readFileSync(require('path').join(__dirname, '../../../src/main/webapp/WEB-INF/jsp/main/assessment.jsp'), 'utf8').replace(/\r\n/g, '\n');
const a = s.indexOf('url: "/main/create_Eval_Indi.do"'); const b = s.indexOf('success: function(response) {', a); const e = s.indexOf('error: function(xhr, status, error) {', b);
const fnSrc = s.substring(b + 'success: '.length, s.lastIndexOf('},', e) + 1);
let pass = 0, fail = 0; const ok = (c, m) => { c ? pass++ : (fail++, console.log('FAIL', m)); };
function run(resp, wnn, hasAlertBox) {
  const st = { alerts: [], swal: [], reloaded: 0, boxHtml: 'x', waitDisp: 'block', timers: [] };
  const box = { set innerHTML(v) { st.boxHtml = v; }, get innerHTML() { return st.boxHtml; } };
  const waitingCreate = { style: { set display(v) { st.waitDisp = v; }, get display() { return st.waitDisp; } } };
  const window = hasAlertBox ? { _alertBox: (m, o) => st.alerts.push([m, o]) } : {};
  const env = { finished: false, revealTimer: null, clearInterval() {}, names: ['a', 'b'], shown: 0, render() {}, elapsedSec: () => 3,
    setTimeout: (f) => { st.timers.push(f); }, getCookie: () => (wnn ? 'Y' : 'N'), Swal: { fire: (o) => st.swal.push(o) },
    loadFivePointCriteria() { st.reloaded++; }, Indicater_DataList() { st.reloaded++; }, jobyymm: '202609', box, waitingCreate, window };
  const f = new Function(...Object.keys(env), 'return (' + fnSrc + ');')(...Object.values(env));
  f(resp); return st;
}
let r = run({ DTO: {}, error_code: '90000', error_mess: '자료생성 중 오류가 발생해 저장되지 않았습니다.', error_detail: "SQLSTATE=HY000, MESSAGE=Illegal mix <x>" }, true, true);
ok(r.alerts.length === 1 && r.swal.length === 0, '위너넷 실패 → ui-message 알림 1번');
ok(/자료생성에 실패/.test(r.alerts[0][0]) && /Illegal mix &lt;x&gt;/.test(r.alerts[0][0]) && /\[90000\]/.test(r.alerts[0][0]), '위너넷은 원문(이스케이프됨)·코드 보임');
ok(r.alerts[0][1].okColor === 'red', '빨간 단추');
ok(r.waitDisp === 'none' && r.boxHtml === '' && r.reloaded === 2 && r.timers.length === 0, '진행 표시 거두고 이전 자료 다시 표시 · 「완료」 안 뜸');
r = run({ error_code: '90000', error_mess: '오류', error_detail: 'SQLSTATE=HY000' }, false, true);
ok(r.alerts.length === 1 && !/SQLSTATE/.test(r.alerts[0][0]), '병원 계정에는 원문 안 보임');
r = run({ error_code: '99999', error_mess: '서버 오류', error_detail: 'x' }, true, false);
ok(r.swal.length === 1 && /실패/.test(r.swal[0].html), 'ui-message 없으면 Swal 폴백');
r = run({ DTO: { errcode: '0' } }, true, true);
ok(r.alerts.length === 0 && /완료되었습니다/.test(r.boxHtml) && r.timers.length === 1, '성공(오류코드 없음) → 종전대로 완료');
r = run({ error_code: '0' }, true, true);
ok(r.alerts.length === 0 && /완료되었습니다/.test(r.boxHtml), "error_code '0' 은 성공");
console.log('통과', pass, '실패', fail); process.exit(fail ? 1 : 0);
