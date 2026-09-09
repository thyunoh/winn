// 인사 등록 · 사인·도장 화면(qpsSigner.jsp, 2026-09-09) — 명단 · 권한 · 찾기 · 퇴사자 포함 · 사람 추가/고치기(인사 칸) ·
//   동명이인 경고 · 여러 명 붙여넣기 · 사인 그리기 저장 · 그림 내리기 · 삭제 · 순번 가드
// ★페이지 통째 방식(sim_qpsDuty 와 같음) : 본문 HTML + 인라인 스크립트를 그대로 태운다.
const fs = require('fs');
const path = require('path');
const { JSDOM } = require('jsdom');

const S = fs.readFileSync(path.resolve(__dirname, '../../../src/main/webapp/WEB-INF/jsp/main/qpsmgr/qpsSigner.jsp'), 'utf8')
            .replace(/\r\n/g, '\n');
let pass = 0, fail = 0;
const ok = (n, c) => { if (c) { pass++; console.log('  ✅', n); } else { fail++; console.log('  ❌', n); } };
const until = f => new Promise(res => { (function t(){ if (f()) return res(); setTimeout(t, 5); })(); });
const tick = (ms) => new Promise(res => setTimeout(res, ms || 20));

/* 래퍼 div#qpsSigner 가 <style> 앞에 있다 — 인라인 <script> 앞까지 통째로 잡고 style·JSP 지시자·주석만 뗀다 */
const body = S.split('<script>')[0].replace(/<%--[\s\S]*?--%>/g, '').replace(/<%@[\s\S]*?%>/g, '')
              .replace(/<style>[\s\S]*?<\/style>/, '').replace(/<script src=[^>]*><\/script>/, '');
const code = S.match(/<script>\n([\s\S]*?)<\/script>/)[1].replace(/<c:url value="([^"]*)"\/>/g, '$1');

function build(){
  const dom = new JSDOM('<div id="wrap">' + body + '</div>', { pretendToBeVisual: true });
  const { window } = dom, { document } = window;
  const state = { posts: [], alerts: [], asks: [], toasts: [], res: {}, confirmAuto: true, delay: {} };
  /* jsdom 은 캔버스가 없다 — 그리기 호출을 기록만 하는 스텁 */
  const cv = { calls: [] };
  window.HTMLCanvasElement.prototype.getContext = function(){
    const c = {};
    ['scale','beginPath','moveTo','lineTo','stroke','clearRect','drawImage'].forEach(k => { c[k] = function(){ cv.calls.push(k); }; });
    return c;
  };
  window.HTMLCanvasElement.prototype.toDataURL = function(){ return 'data:image/png;base64,QUJD'; };
  const $ = function(fn){ if (typeof fn === 'function') state.ready = fn; return { }; };
  $.post = function(url, data, cb){
    state.posts.push({ url, data });
    const r = state.res[url] ? state.res[url](data) : { result: 'OK' };
    setTimeout(() => cb(r), state.delay[url] || 0);
    return { fail: function(){ return this; } };
  };
  const ctx = {
    window, document, $, Promise, state, Date: window.Date, Math, JSON, Number, String, Object, Array,
    Image: window.Image, FileReader: window.FileReader,
    _alertBox: (m, o) => state.alerts.push(m),
    _confirmBox: (o) => { state.asks.push(o); if (state.confirmAuto) o.onOk(); else if (o.onCancel) o.onCancel(); },
    _toast: (m) => state.toasts.push(m),
    setTimeout: window.setTimeout.bind(window), setInterval: window.setInterval.bind(window)
  };
  window._alertBox = ctx._alertBox; window._confirmBox = ctx._confirmBox; window._toast = ctx._toast;
  new Function(...Object.keys(ctx), 'with (window) {\n' + code + '\n}')(...Object.values(ctx));
  return { window, document, state, cv, $: id => document.getElementById(id) };
}

const DEPTS = [ {codecd:'QPS_CHK_DEPT', subcode:'NURSE', subcodenm:'간호·병동'}, {codecd:'QPS_CHK_DEPT', subcode:'LAB', subcodenm:'진단검사'} ];
const USERS = [ {userid:'admin', usernm:'마스터'}, {userid:'nurse1', usernm:'김간호'}, {userid:'lab1', usernm:'이검사'} ];
function LIST(){
  return [
    { userid:'nurse1', usernm:'김간호', empno:'N001', jobnm:'간호사', posnm:'수간호사', deptcd:'NURSE', acctyn:'Y', sortno:1, joindt:'20240301', retiredt:null, remark:null, retired:'N',
      hasimg:'Y', signimg:'QUJD', signmime:'image/png', signgb:'S', upddttm:'2026-09-09 10:00' },
    { userid:'P1A2B3C4D5E6', usernm:'박조무', empno:'N002', jobnm:'조무사', posnm:null, deptcd:'NURSE', acctyn:'N', sortno:2, joindt:'20250715', retiredt:null, remark:'야간 전담', retired:'N',
      hasimg:'N', signimg:null, signmime:'image/png', signgb:null, upddttm:'2026-09-09 10:05' },
    { userid:'lab1', usernm:'이검사', empno:null, jobnm:'임상병리사', posnm:null, deptcd:'LAB', acctyn:'Y', sortno:1, joindt:null, retiredt:null, remark:null, retired:'N',
      hasimg:'N', signimg:null, signmime:'image/png', signgb:null, upddttm:null },
    { userid:'PRETIRED0001', usernm:'최퇴사', empno:'N000', jobnm:'간호사', posnm:null, deptcd:'NURSE', acctyn:'N', sortno:9, joindt:'20200101', retiredt:'20260131', remark:null, retired:'Y',
      hasimg:'Y', signimg:'QUJD', signmime:'image/png', signgb:'D', upddttm:'2025-12-01 09:00' }
  ];
}

(async function(){
  console.log('▶ 인사 등록 · 사인·도장 (qpsSigner)');
  const { window, document, state, cv, $ } = build();
  let canEdit = 'Y', me = 'admin';
  state.res['/qps/signerList.do'] = (d) => ({ result:'OK', canEdit, me, dept: DEPTS, users: USERS,
    list: LIST().filter(s => (!d.deptCd || s.deptcd === d.deptCd) && (d.withRetire === 'Y' || s.retired !== 'Y')) });
  state.res['/qps/signerSave.do'] = (d) => ({ result:'OK', userId: d.userId || 'PNEW00000001' });
  state.res['/qps/signerImgSave.do'] = () => ({ result:'OK' });
  state.res['/qps/signerDel.do'] = () => ({ result:'OK' });
  state.res['/qps/signerEmpList.do'] = () => ({ result:'OK', list: [
    { usernm:'김간호', lictype:'05', jobnm:'간호사',   joindt:'20240301', retiredt:'',         already:'Y' },   // 이미 인사 등록에 있음
    { usernm:'정면허', lictype:'05', jobnm:'간호사',   joindt:'20230102', retiredt:'',         already:'N' },
    { usernm:'오면허', lictype:'06', jobnm:'간호조무사', joindt:'20220401', retiredt:'20991231', already:'N' },   // 무기한 관용값
    { usernm:'구면허', lictype:'03', jobnm:'약사',     joindt:'20200101', retiredt:'20250630', already:'N' }    // 퇴사일 지남
  ] });

  state.ready();
  await until(() => $('sgBody').querySelectorAll('tr').length === 3);
  ok('명단 3명이 표에 선다(퇴직자는 기본 제외)', $('sgBody').querySelectorAll('tr').length === 3 && !/최퇴사/.test($('sgBody').textContent));
  ok('부서 셀렉트를 서버 목록으로 채운다(전체 + 2)', $('sgDept').options.length === 3 && $('sgFDept').options.length === 3);
  ok('사번·직종·직책·입사일이 칸에 실린다(YYYYMMDD → yyyy-mm-dd)', /N001/.test($('sgBody').textContent) && /수간호사/.test($('sgBody').textContent) &&
     /2024-03-01/.test($('sgBody').textContent) && /2025-07-15/.test($('sgBody').textContent));
  ok('사인 있는 사람은 그림, 없는 사람은 「없음」', $('sgBody').querySelectorAll('img.sg-thumb').length === 1 && /없음/.test($('sgBody').innerHTML));
  ok('계정 없는 사람은 「계정 없음」·계정 있으면 아이디 배지', $('sgBody').querySelectorAll('.sg-noacct').length === 1 &&
     $('sgBody').querySelectorAll('.sg-acct').length === 2);
  ok('건수 띠 = 명단 3명 · 사인 있음 1명', /명단 3명/.test($('sgCnt').textContent) && /사인 있음 1명/.test($('sgCnt').textContent));
  ok('고칠 수 있는 계정이면 [+ 사람 추가]·[여러 명 붙여넣기]·고치기·삭제 단추가 보인다', $('sgAddBtn').style.display === '' && $('sgBulkBtn').style.display === '' &&
     $('sgBody').querySelectorAll('button').length === 4 + 3 + 3);   // 김간호 4(사인·내리기·고치기·삭제), 나머지 3씩
  ok('권한 문구가 「고칠 수 있습니다」', /고칠 수 있습니다/.test($('sgPermNote').textContent));

  // ── 퇴사자 포함
  $('sgRet').checked = true; await window.sgLoad(); await tick();
  ok('「퇴사자 포함」을 켜면 퇴직자가 회색 줄·「퇴직」 배지로 보이고 건수에 (퇴사 1)', $('sgBody').querySelectorAll('tr').length === 4 &&
     $('sgBody').querySelectorAll('tr.ret').length === 1 && /퇴직/.test($('sgBody').querySelector('tr.ret').textContent) &&
     /2026-01-31/.test($('sgBody').querySelector('tr.ret').textContent) && /\(퇴사 1\)/.test($('sgCnt').textContent));
  ok('요청에 withRetire=Y 가 실린다', state.posts.filter(p => p.url === '/qps/signerList.do').pop().data.withRetire === 'Y');
  $('sgRet').checked = false; await window.sgLoad(); await tick();

  // ── 찾기(이름·사번·직종·직책)
  $('sgFind').value = 'n002'; window.sgPaint();
  ok('사번으로도 거른다', $('sgBody').querySelectorAll('tr').length === 1 && /박조무/.test($('sgBody').textContent));
  $('sgFind').value = '수간호'; window.sgPaint();
  ok('직책으로도 거른다', $('sgBody').querySelectorAll('tr').length === 1 && /김간호/.test($('sgBody').textContent));
  $('sgFind').value = '없는사람'; window.sgPaint();
  ok('못 찾으면 안내 한 줄', /찾는 사람이 없습니다/.test($('sgBody').textContent));
  $('sgFind').value = ''; window.sgPaint();

  // ── 부서 필터 + 순번 가드(늦게 온 옛 응답 버림)
  state.delay['/qps/signerList.do'] = 40;
  $('sgDept').value = 'LAB'; const p1 = window.sgLoad();
  state.delay['/qps/signerList.do'] = 0;
  $('sgDept').value = 'NURSE'; const p2 = window.sgLoad();
  await Promise.all([p1, p2]); await tick(60);
  ok('부서를 연달아 바꾸면 마지막 부서(간호 2명)만 남는다 — 늦게 온 진단검사 응답은 버림',
     $('sgBody').querySelectorAll('tr').length === 2 && !/이검사/.test($('sgBody').textContent));
  $('sgDept').value = ''; await window.sgLoad(); await tick();

  // ── 사람 추가 폼
  window.sgFormOpen('');
  ok('새 사람 폼이 열리고 계정 잇기가 보인다', $('sgForm').style.display === 'flex' && $('sgAcctWrap').style.display === '' &&
     /새 사람/.test($('sgFormTtl').textContent));
  ok('계정 잇기 목록은 명단에 없는 계정만(admin 하나)', $('sgAcct').options.length === 2 && $('sgAcct').options[1].value === 'admin');
  $('sgAcct').value = 'admin'; $('sgAcct').dispatchEvent(new window.Event('change'));
  ok('계정을 고르면 그 계정 이름이 미리 채워진다', $('sgNm').value === '마스터');
  $('sgNm').value = ''; state.alerts.length = 0; window.sgFormSave();
  ok('이름이 비면 저장하지 않고 알린다', state.alerts.length === 1 && state.posts.filter(p => p.url === '/qps/signerSave.do').length === 0);
  $('sgNm').value = '마스터'; $('sgJoin').value = '2026-05-01'; $('sgRetire').value = '2026-04-01'; state.alerts.length = 0; window.sgFormSave();
  ok('퇴사일이 입사일보다 앞서면 저장하지 않고 알린다', state.alerts.length === 1 && /앞섭니다/.test(state.alerts[0]) &&
     state.posts.filter(p => p.url === '/qps/signerSave.do').length === 0);
  $('sgRetire').value = ''; $('sgEmp').value = 'A007'; $('sgJob').value = '관리자'; $('sgPos').value = '팀장'; $('sgFDept').value = 'LAB'; $('sgSort').value = '5'; $('sgRemark').value = '겸임';
  state.posts.length = 0; window.sgFormSave();
  await until(() => state.posts.some(p => p.url === '/qps/signerSave.do'));
  const sv = state.posts.find(p => p.url === '/qps/signerSave.do').data;
  ok('저장 payload = 계정·이름·사번·직종·직책·부서·입사일·차례·비고(userId 는 비어 새 사람)', sv.userId === '' && sv.acctUserId === 'admin' &&
     sv.userNm === '마스터' && sv.empNo === 'A007' && sv.jobNm === '관리자' && sv.posNm === '팀장' && sv.deptCd === 'LAB' &&
     sv.joinDt === '2026-05-01' && sv.retireDt === '' && sv.sortNo === '5' && sv.remark === '겸임');
  await tick(40);
  ok('저장 뒤 폼이 닫히고 토스트', $('sgForm').style.display === 'none' && state.toasts.some(t => /등록했습니다/.test(t)));

  // ── 폼 부서 → 표 부서 필터 따라오기 (사용자 「입력시 부서 선택하면 그리드 부서 자동 따라오게」)
  window.sgFormOpen('');
  $('sgFDept').value = 'LAB'; $('sgFDept').dispatchEvent(new window.Event('change')); await tick(30);
  ok('폼에서 부서를 고르면 위 표 필터가 그 부서로 바뀌고 목록이 그 부서만', $('sgDept').value === 'LAB' &&
     $('sgBody').querySelectorAll('tr').length === 1 && /이검사/.test($('sgBody').textContent) && $('sgForm').style.display === 'flex');
  $('sgNm').value = '새간호'; $('sgFDept').value = 'NURSE'; $('sgFDept').dispatchEvent(new window.Event('change')); await tick(30);
  $('sgDept').value = 'LAB';                                        // 사용자가 필터를 다시 딴 데로 옮겨 놓은 상황
  state.posts.length = 0; window.sgFormSave(); await tick(60);
  ok('저장하면 표 필터가 저장한 사람의 부서(간호)로 맞춰진다', $('sgDept').value === 'NURSE' &&
     state.posts.filter(p => p.url === '/qps/signerList.do').pop().data.deptCd === 'NURSE');
  window.sgSignClose(); $('sgDept').value = ''; await window.sgLoad(); await tick();

  // ── 동명이인 경고
  window.sgFormOpen(''); $('sgNm').value = '김간호'; state.asks.length = 0; state.confirmAuto = false; state.posts.length = 0;
  window.sgFormSave(); await tick();
  ok('같은 이름이 있으면 확인창을 띄우고, 취소하면 저장하지 않는다', state.asks.length === 1 && /이미/.test(state.asks[0].msg) &&
     state.posts.filter(p => p.url === '/qps/signerSave.do').length === 0);
  state.confirmAuto = true; window.sgFormClose();

  // ── 고치기 폼 : 계정 잇기 숨김, 인사 칸까지 채움
  window.sgFormOpen('P1A2B3C4D5E6');
  ok('고치기 폼은 값을 채우고 계정 잇기를 숨긴다', $('sgNm').value === '박조무' && $('sgEmp').value === 'N002' && $('sgJob').value === '조무사' &&
     $('sgFDept').value === 'NURSE' && $('sgJoin').value === '2025-07-15' && $('sgRemark').value === '야간 전담' &&
     $('sgAcctWrap').style.display === 'none' && /고치기 — 박조무/.test($('sgFormTtl').textContent));
  $('sgRetire').value = '2026-09-30';
  state.posts.length = 0; window.sgFormSave();
  await until(() => state.posts.some(p => p.url === '/qps/signerSave.do'));
  ok('고치기 저장은 userId 를 싣고 acctUserId 는 비우며 퇴사일이 실린다', state.posts[0].data.userId === 'P1A2B3C4D5E6' &&
     state.posts[0].data.acctUserId === '' && state.posts[0].data.retireDt === '2026-09-30');
  await tick(40);

  // ── 여러 명 붙여넣기
  window.sgBulkOpen();
  ok('붙여넣기 띠가 열리고 폼은 닫힌다', $('sgBulk').style.display === 'block' && $('sgForm').style.display === 'none');
  $('sgBulkTxt').value = [
    '이름\t사번\t직종\t직책\t부서\t입사일',                       // 머리줄 → 건너뜀
    '홍길동\tN101\t간호사\t\t간호·병동\t2026-03-02',              // 부서 이름
    '임꺽정\tN102\t조무사\t\tLAB\t2026.04.01',                   // 부서 코드 · 점 날짜(서버가 숫자만 남겨 8자리로 읽는다)
    '김간호\t\t간호사\t\t\t',                                    // 같은 이름 있음(경고만)
    '장길산\tN104\t조무사\t\t총무팀\t2026-05-01',                // 부서 없음 → 건너뜀
    '이몽룡\tN105\t간호사\t\t간호·병동\t26-05',                   // 날짜 깨짐 → 건너뜀
    ''
  ].join('\n');
  window.sgBulkParse();
  const prev = $('sgBulkPrev').querySelectorAll('tbody tr');
  ok('머리줄·빈 줄을 빼고 5줄을 미리 보여 준다', prev.length === 5 && !/^이름$/.test(prev[0].children[1].textContent));
  ok('부서는 이름(간호·병동)·코드(LAB) 어느 쪽이든 코드로 잇는다', /간호·병동/.test(prev[0].children[5].textContent) && /진단검사/.test(prev[1].children[5].textContent));
  ok('같은 이름은 경고만, 부서 없음·날짜 깨짐은 건너뜀 표시', /같은 이름 있음/.test(prev[2].children[7].textContent) && !/건너뜀/.test(prev[2].children[7].textContent) &&
     /부서 「총무팀」 없음 — 건너뜀/.test(prev[3].children[7].textContent) && /입사일 「26-05」 — 건너뜀/.test(prev[4].children[7].textContent));
  ok('건수 띠 = 5줄 · 등록할 수 있는 것 3명 · 고쳐야 하는 줄 2', /5줄/.test($('sgBulkCnt').textContent) && /3명/.test($('sgBulkCnt').textContent) && /고쳐야 하는 줄 2/.test($('sgBulkCnt').textContent));
  state.res['/qps/signerSave.do'] = (d) => d.userNm === '임꺽정' ? { result:'FAIL', message:'입사일은(는) 연월일 8자리로 적으세요.' } : { result:'OK', userId:'PNEW' + d.userNm };
  state.posts.length = 0; state.asks.length = 0; state.toasts.length = 0; state.alerts.length = 0;
  window.sgBulkSave();
  await until(() => state.posts.filter(p => p.url === '/qps/signerSave.do').length === 3);
  await tick(80);
  const bp = state.posts.filter(p => p.url === '/qps/signerSave.do').map(p => p.data);
  ok('확인창 뒤 건너뜀을 뺀 3명을 차례로 보낸다(부서 코드·차례 번호 실림)', state.asks.length === 1 && /3명/.test(state.asks[0].msg) &&
     bp[0].userNm === '홍길동' && bp[0].deptCd === 'NURSE' && bp[0].sortNo === '1' && bp[1].deptCd === 'LAB' && bp[2].userNm === '김간호' && bp[2].sortNo === '3');
  ok('한 줄이 실패해도 나머지는 들어가고 결과를 알린다(2명 등록 · 1명 실패, 실패 줄 목록)', state.toasts.some(t => /2명 등록 · 1명 실패/.test(t)) &&
     state.alerts.some(m => /임꺽정/.test(m) && /8자리/.test(m)));
  ok('끝나면 붙여넣기 칸을 비우고 띠를 닫는다', $('sgBulkTxt').value === '' && $('sgBulk').style.display === 'none');
  state.res['/qps/signerSave.do'] = (d) => ({ result:'OK', userId: d.userId || 'PNEW00000001' });
  window.sgBulkOpen(); state.alerts.length = 0; window.sgBulkSave();
  ok('붙여 넣은 것이 없으면 알리기만', state.alerts.length === 1 && /등록할 줄이 없습니다/.test(state.alerts[0]));
  window.sgBulkClose();

  // ── 면허등록에서 가져오기
  window.sgEmpOpen(); await tick(40);
  ok('면허 띠가 열리고 폼·붙여넣기 띠는 닫힌다', $('sgEmpBox').style.display === 'block' && $('sgForm').style.display === 'none' &&
     $('sgBulk').style.display === 'none');
  ok('퇴사일 지난 사람은 기본으로 빠진다(4명 중 3명)', $('sgEmpPrev').querySelectorAll('tbody tr').length === 3 &&
     !/구면허/.test($('sgEmpPrev').textContent));
  ok('이미 인사 등록에 있는 이름은 체크칸 없이 「이미 있음」', $('sgEmpPrev').querySelector('tr.have') &&
     /이미 있음/.test($('sgEmpPrev').querySelector('tr.have').textContent) &&
     !$('sgEmpPrev').querySelector('tr.have').querySelector('input'));
  ok('건수 띠 = 면허등록 3명 · 가져올 수 있는 사람 2명 · 이미 있음 1', /면허등록 3명/.test($('sgEmpCnt').textContent) &&
     /가져올 수 있는 사람 2명/.test($('sgEmpCnt').textContent) && /이미 있음 1/.test($('sgEmpCnt').textContent));
  $('sgEmpRet').checked = true; window.sgEmpPaint();
  ok('「퇴사일 지난 사람도」를 켜면 4명이 보이고 퇴사 표시', $('sgEmpPrev').querySelectorAll('tbody tr').length === 4 &&
     /구면허/.test($('sgEmpPrev').textContent) && /퇴사/.test($('sgEmpPrev').textContent));
  $('sgEmpRet').checked = false; window.sgEmpPaint();
  state.alerts.length = 0; window.sgEmpSave();
  ok('아무도 안 고르고 누르면 알리기만', state.alerts.length === 1 && /고르세요/.test(state.alerts[0]));
  $('sgEmpAll').checked = true; window.sgEmpCheckAll();
  ok('[전부 고르기]는 가져올 수 있는 사람만 켠다(2명)', $('sgEmpPrev').querySelectorAll('input.sg-empck:checked').length === 2);
  $('sgEmpDept').value = 'NURSE';
  state.posts.length = 0; state.asks.length = 0; state.toasts.length = 0;
  window.sgEmpSave();
  await until(() => state.posts.filter(p => p.url === '/qps/signerSave.do').length === 2);
  await tick(80);
  const ep = state.posts.filter(p => p.url === '/qps/signerSave.do').map(p => p.data);
  ok('확인창 뒤 2명을 이름·직종·입사일째 보낸다(부서는 고른 값·비고 「면허등록에서」)', state.asks.length === 1 && /2명/.test(state.asks[0].msg) &&
     ep[0].userNm === '정면허' && ep[0].jobNm === '간호사' && ep[0].joinDt === '20230102' && ep[0].deptCd === 'NURSE' &&
     ep[0].remark === '면허등록에서' && ep[1].userNm === '오면허' && ep[1].jobNm === '간호조무사');
  ok('★무기한 관용값(20991231)은 퇴사일로 안 가져온다 — 미리보기도 빈 칸', ep[1].retireDt === '' &&
     !/2099/.test($('sgEmpPrev') ? $('sgEmpPrev').textContent : ''));
  ok('끝나면 띠를 닫고 그 부서로 표를 맞춘다', $('sgEmpBox').style.display === 'none' && $('sgDept').value === 'NURSE' &&
     state.toasts.some(t => /2명 가져왔습니다/.test(t)));
  $('sgDept').value = ''; await window.sgLoad(); await tick();

  // ── 사인 그리기 창
  window.sgSignOpen('P1A2B3C4D5E6');
  ok('사인 창이 열리고 「아직 사인이 없습니다」', !!$('sgSignWrap') && /아직 사인이 없습니다/.test($('sgSignWrap').textContent) &&
     /박조무/.test($('sgSignWrap').querySelector('h4').textContent));
  state.alerts.length = 0; window.sgSignSave();
  ok('안 그리고 저장하면 알리고 보내지 않는다', state.alerts.length === 1 && !state.posts.some(p => p.url === '/qps/signerImgSave.do'));
  const c = $('sgSignCv');
  c.dispatchEvent(new window.MouseEvent('mousedown', { bubbles:true, clientX:10, clientY:10 }));
  c.dispatchEvent(new window.MouseEvent('mousemove', { bubbles:true, clientX:30, clientY:20 }));
  document.dispatchEvent(new window.MouseEvent('mouseup', { bubbles:true }));
  c.dispatchEvent(new window.MouseEvent('mousemove', { bubbles:true, clientX:50, clientY:20 }));
  const strokes = cv.calls.filter(k => k === 'stroke').length;
  ok('마우스로 그리면 선이 그어지고, 놓으면 멎는다', strokes === 1);
  state.posts.length = 0; window.sgSignSave();
  await until(() => state.posts.some(p => p.url === '/qps/signerImgSave.do'));
  const im = state.posts.find(p => p.url === '/qps/signerImgSave.do').data;
  ok('사인 저장 payload = userId · data URL · S · image/png', im.userId === 'P1A2B3C4D5E6' && /^data:image\/png;base64,/.test(im.signImg) &&
     im.signGb === 'S' && im.signMime === 'image/png');
  await tick(40);
  ok('저장 뒤 창이 닫히고 토스트·재조회', !$('sgSignWrap') && state.toasts.some(t => /사인을 저장/.test(t)));

  // ── 지우기·닫기
  window.sgSignOpen('nurse1');
  ok('사인이 있는 사람은 지금 그림을 보여 준다', /지금 등록된 사인/.test($('sgSignWrap').textContent));
  cv.calls.length = 0; window.sgSignClear();
  ok('[지우기]는 캔버스를 비운다', cv.calls.indexOf('clearRect') >= 0);
  window.sgSignClose();
  ok('[닫기]로 창이 사라진다', !$('sgSignWrap'));

  // ── 그림 내리기 · 삭제
  state.posts.length = 0; window.sgImgClear('nurse1');
  await until(() => state.posts.some(p => p.url === '/qps/signerDel.do'));
  ok('그림 내리기 = what:img', state.posts[0].data.userId === 'nurse1' && state.posts[0].data.what === 'img');
  await tick(40);
  state.posts.length = 0; state.asks.length = 0; window.sgDel('nurse1');
  await until(() => state.posts.some(p => p.url === '/qps/signerDel.do'));
  ok('삭제 = what:row, 「퇴사자는 퇴사일을」·계정 있는 사람이면 되살아난다는 안내', state.posts[0].data.what === 'row' &&
     /퇴사일/.test(state.asks[0].msg) && /되살아납니다/.test(state.asks[0].msg));
  await tick(40);
  state.confirmAuto = false; state.posts.length = 0; window.sgDel('lab1'); await tick();
  ok('삭제 확인을 취소하면 보내지 않는다', state.posts.length === 0);
  state.confirmAuto = true;

  // ── 서버 FAIL
  state.res['/qps/signerSave.do'] = () => ({ result:'FAIL', message:'담당자 명단은 QPS 담당자·병원관리자만 고칠 수 있습니다.' });
  window.sgFormOpen(''); $('sgNm').value = '새사람'; state.alerts.length = 0; window.sgFormSave(); await tick(40);
  ok('서버가 거절하면 그 문구로 알린다', state.alerts.some(m => /QPS 담당자/.test(m)));
  window.sgFormClose();

  // ── 보기만 되는 계정
  canEdit = 'N'; me = 'nurse1';
  await window.sgLoad(); await tick();
  ok('권한 없으면 [+ 사람 추가]·[붙여넣기]·[면허등록에서]가 숨고 문구가 「보기만」', $('sgAddBtn').style.display === 'none' &&
     $('sgBulkBtn').style.display === 'none' && $('sgEmpBtn').style.display === 'none' && /보기만/.test($('sgPermNote').textContent));
  ok('본인 줄에만 사인·내리기 단추(2개), 남의 줄엔 단추 없음', $('sgBody').querySelectorAll('button').length === 2 &&
     /sgSignOpen\('nurse1'\)/.test($('sgBody').innerHTML));

  // ── 빈 명단
  state.res['/qps/signerList.do'] = () => ({ result:'OK', canEdit:'Y', me:'admin', dept: DEPTS, users: USERS, list: [] });
  await window.sgLoad(); await tick();
  ok('명단이 비면 시작 안내(사람 추가·붙여넣기)', /아직 등록된 직원이 없습니다/.test($('sgBody').textContent) && /붙여넣기/.test($('sgBody').textContent));

  /* ★소스 — id 가 겹치면 getElementById 가 **앞엣것**을 집어 「단추를 눌러도 아무 일 없음」이 된다.
     실제로 겪었다(2026-09-09) : 사번 칸 `sgEmp` 와 면허 띠 `sgEmp` 가 겹쳐 띠가 폼 안 입력칸으로 잡혔다.
     시뮬도 `$('sgEmp').style.display` 로 보다가 그 입력칸을 보고 통과시켰다 — 그래서 **소스에서** 센다. */
  {
    const ids = {}, dup = [];
    for (const m of S.matchAll(/\sid="([A-Za-z_][\w:.-]*)"/g)) {
      if (ids[m[1]]) { if (dup.indexOf(m[1]) < 0) dup.push(m[1]); } else ids[m[1]] = 1;
    }
    ok('소스 — 화면 안에 같은 id 가 없다' + (dup.length ? (' ★겹침: ' + dup.join(',')) : ''), dup.length === 0);
  }

  console.log(`\n결과: ${pass} 통과 / ${fail} 실패`);
  process.exitCode = fail ? 1 : 0;
})().catch(e => { console.error('★시뮬 죽음:', e); process.exitCode = 2; });
