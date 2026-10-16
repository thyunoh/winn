// 신규환자 고객관리 달력 화면 검사 (2026-10-12) — misLead.jsp
// 소스 JSP 에서 JSP 태그만 걷어 내고 jsdom 에서 그대로 돌린다. $ 와 AJAX 응답은 가짜다.
// 실행: node sim_mis_lead.js   (npm i 가 먼저 되어 있어야 한다)
const fs = require('fs');
const path = require('path');
const { JSDOM } = require('jsdom');

const FILE = path.resolve(__dirname, '../../../src/main/webapp/WEB-INF/jsp/main/mismgr/misLead.jsp');
let pass = 0, fail = 0;
function ok(name, cond, extra){ if (cond) { pass++; console.log('  OK  ' + name); } else { fail++; console.log('  FAIL ' + name + (extra ? ' :: ' + extra : '')); } }
const wait = (ms) => new Promise(r => setTimeout(r, ms));

function strip(){
  let s = fs.readFileSync(FILE, 'utf8').replace(/\r\n/g, '\n');
  s = s.replace(/<%@[\s\S]*?%>/g, '');
  s = s.replace(/<%--[\s\S]*?--%>/g, '');
  s = s.replace(/<c:url value="([^"]*)"\s*\/>/g, '$1');
  s = s.replace(/<c:out value='\$\{[^}]*\}'\s*\/>/g, '');
  s = s.replace(/<\/?jsp:[^>]*>/g, '');
  return s;
}

// 요청 기록 + 응답표. 응답이 함수면 요청 본문을 받아 만든다.
function makeJq(resp, calls){
  const $ = function(f){ if (typeof f === 'function') setTimeout(f, 0); return { on(){ return this; }, removeClass(){ return this; }, addClass(){ return this; }, val(){ return 'm'; } }; };
  $.ajax = function(o){
    calls.push({ url: o.url, data: o.data || {} });
    const r = resp[o.url];
    return Promise.resolve(typeof r === 'function' ? r(o.data || {}) : (r === undefined ? {} : r));
  };
  return $;
}

const TODAY = '20261015';
const LEADS = [
  { leadseq: 1, stage: '10', patnm: '김영희', birth6: '480101', gender: 'F', guardnm: '김철수', guardrel: '아들', tel: '010-1111-2222', channel: 'INTRO', contactdt: '20261012', nextdt: '20261016', nextmemo: '방문 약속', plandt: '20261020', condmemo: '뇌졸중 재활' },
  { leadseq: 2, stage: '20', patnm: '이순자', birth6: '390202', gender: 'F', channel: 'WEB', contactdt: '20261008', plandt: '20261015' },
  { leadseq: 3, stage: '40', patnm: '박종수', birth6: '550303', gender: 'M', channel: 'ADS', contactdt: '20260920', admitdt: '20261005', matchyn: 'Y', nextdt: '20261014', nextmemo: '예전 연락' },
  { leadseq: 4, stage: '50', patnm: '정명숙', birth6: '470807', gender: 'F', channel: 'TRANS', contactdt: '20260510', admitdt: '20260901', dischdt: '20260910' },
  { leadseq: 6, stage: '40', patnm: '윤미경', birth6: '620915', gender: 'F', channel: 'ADS', contactdt: '20261001' },
  { leadseq: 5, stage: '90', patnm: '최영수', birth6: '600404', gender: 'M', channel: 'WEB', contactdt: '20260801', closersn: '타 병원 입원' }
];

function fixtures(calls){
  return {
    '/mis/leadList.do': { result: 'OK', today: TODAY, leads: LEADS, stats: [{ channel: 'WEB', leads: 2, admits: 1 }], stats3: [] },
    '/mis/leadSave.do': (d) => ({ result: 'OK', leadSeq: d.leadSeq || 9 }),
    '/mis/leadStage.do': { result: 'OK' },
    '/mis/leadLog.do': { result: 'OK', logs: [] },
    '/mis/leadDel.do': { result: 'OK' },
    '/mis/followList.do': { result: 'OK', today: TODAY, days: 60, list: [] },
    '/mis/followSave.do': { result: 'OK' },
  };
}

async function run(){
  const calls = [];
  const jq = makeJq(fixtures(calls), calls);
  const html = '<!doctype html><html><body>' + strip() + '</body></html>';
  const dom = new JSDOM(html, { runScripts: 'dangerously', url: 'http://localhost/', beforeParse(win){
    win.$ = jq; win._alertBox = () => {}; win._toast = () => {}; win._confirmBox = (o) => o.onOk && o.onOk();
  } });
  await wait(80);
  const w = dom.window, doc = w.document;

  // 1. 불러오기 · 달력 (오늘 = 2026년 10월)
  const cells = doc.querySelectorAll('#mlCal .ml-cd:not(.out)');
  ok('달력: 10월 31칸', cells.length === 31, 'cells=' + cells.length);
  ok('달력: 오늘(15일)에 표시', doc.querySelector('#mlCal .ml-cd.today') && doc.querySelector('#mlCal .ml-cd.today').textContent.indexOf('15') >= 0);
  const d16 = doc.querySelectorAll('#mlCal .ml-cd:not(.out)')[15].textContent;
  ok('달력: 16일 칸에 연락 김영희', d16.indexOf('연락 김영희') >= 0, d16);
  const d20 = doc.querySelectorAll('#mlCal .ml-cd:not(.out)')[19].textContent;
  ok('달력: 20일 칸에 방문 예정 김영희', d20.indexOf('방문 김영희') >= 0, d20);
  const d17 = doc.querySelectorAll('#mlCal .ml-cd:not(.out)')[16].textContent;
  const sep17 = doc.querySelectorAll('#mlCal .ml-cd:not(.out)')[16];
  ok('달력: 10월 17일 칸에는 안부가 없음(9월 일정)', sep17.textContent.indexOf('안부') < 0);

  // 2. 오늘 일정 (선택일 = 오늘)
  const ag = doc.getElementById('mlAgenda').textContent;
  ok('오늘 일정: 이순자 방문 보임', ag.indexOf('이순자') >= 0 && ag.indexOf('방문') >= 0, ag);
  ok('오늘 일정: 다른 날 환자(김영희)는 안 보임', ag.indexOf('김영희') < 0);
  ok('입원 단계: 예전 연락 날짜(10/14)가 연락 일정으로 안 찍힘', doc.querySelectorAll('#mlCal .ml-cd:not(.out)')[13].textContent.indexOf('연락 박종수') < 0, doc.querySelectorAll('#mlCal .ml-cd:not(.out)')[13].textContent);
  ok('입원 단계: 다음 할 일 날짜(10/14)는 「할 일」로 찍힘', doc.querySelectorAll('#mlCal .ml-cd:not(.out)')[13].textContent.indexOf('할 일 박종수') >= 0);
  ok('날짜 없는 환자: 윤미경(입원, 날짜 없음)이 목록에 보임', ag.indexOf('날짜가 없는 환자') >= 0 && ag.indexOf('윤미경') >= 0, ag);
  ok('날짜 있는 환자(박종수 입원)는 날짜 없는 목록에 안 들어감', ag.split('날짜가 없는 환자')[1] !== undefined && ag.split('날짜가 없는 환자')[1].indexOf('박종수') < 0);

  // 3. 단계 칩 (종결 제외 4명)
  const chipTxt = doc.getElementById('mlChips').textContent;
  ok('단계 칩: 전체 5명(종결 제외)', chipTxt.indexOf('전체5') >= 0, chipTxt);

  // 4. 단계 필터
  w.mlFilter('40');
  const d5 = doc.querySelectorAll('#mlCal .ml-cd:not(.out)')[4].textContent;
  ok('필터 입원: 10/5 칸에 입원 박종수', d5.indexOf('입원 박종수') >= 0, d5);
  ok('필터 입원: 16일 연락(김영희, 상담 단계)은 사라짐', doc.querySelectorAll('#mlCal .ml-cd:not(.out)')[15].textContent.indexOf('김영희') < 0);
  w.mlFilter('all');
  w.mlFilter('90');
  ok('종결 칩: 종결 환자(최영수) 목록이 오른쪽에 보임', doc.getElementById('mlAgenda').textContent.indexOf('최영수') >= 0 && doc.getElementById('mlAgenda').textContent.indexOf('종결된 상담') >= 0);
  w.mlFilter('all');

  // 5. 환자 선택 → 작업 칸 (상담 단계: 접수 정보 펼침, 다음 연락·방문 칸, 비용 안내, 「방문으로 넘기기」)
  w.mlPick('1');
  const work = doc.getElementById('mlWork').textContent;
  ok('작업 칸: 김영희 · 상담 단계 표시', work.indexOf('김영희') >= 0 && work.indexOf('상담') >= 0);
  ok('작업 칸: 상담 단계는 「방문으로 넘기기」', work.indexOf('방문으로 넘기기') >= 0, work.slice(-200));
  ok('작업 칸: 이름 칸에 값이 채워짐', doc.getElementById('lfNm').value === '김영희');
  ok('작업 칸: 방문 예정일(lfPlan) 채워짐', doc.getElementById('lfPlan').value === '2026-10-20');

  // 6. 단계 넘기기: 저장(leadSave) 후 leadStage 로 20 단계
  calls.length = 0;
  w.mlMove('20');
  await wait(60);
  const saved = calls.filter(c => c.url === '/mis/leadSave.do');
  const staged = calls.filter(c => c.url === '/mis/leadStage.do');
  ok('넘기기: 먼저 leadSave(현재 단계 10)', saved.length === 1 && saved[0].data.stage === '10', JSON.stringify(saved));
  ok('단계 넘기기: 이전 단계의 다음 연락 날짜는 저장 때 비워진다', saved[0] && saved[0].data.nextDt === '', JSON.stringify(saved));
  ok('넘기기: 이어서 leadStage 20', staged.length === 1 && staged[0].data.stage === '20' && String(staged[0].data.leadSeq) === '1', JSON.stringify(staged));

  // 7. 입원 단계 환자: 이전·다음 버튼, 퇴원 칸은 숨김 (입원일은 보이고 방문일은 숨김)
  w.mlPick('3');
  const w3 = doc.getElementById('mlWork').textContent;
  ok('입원 단계: 「퇴원 후로 넘기기」', w3.indexOf('퇴원 후로 넘기기') >= 0);
  ok('입원 단계: 입원일(lfAdmit) 보임', doc.getElementById('lfAdmit').closest('[hidden]') === null);
  ok('입원 단계: 숨김 칸(lfPlan)은 hidden 안', doc.getElementById('lfPlan').closest('[hidden]') !== null);

  // 8. 퇴원 후 단계: 안부 칸과 재입원 상담, 종결 사유 선택
  w.mlPick('4');
  const w4 = doc.getElementById('mlWork').textContent;
  ok('퇴원 후: 안부 연락 칸', w4.indexOf('퇴원 후 안부 연락') >= 0);
  ok('퇴원 후: 재입원 상담 단추', w4.indexOf('재입원 상담 새로 접수') >= 0);
  ok('퇴원 후: 종결 사유 선택 있음', !!doc.getElementById('mlCloseSel'));

  // 9. 재입원 상담: 기본 정보 옮겨 새 상담(10 단계) 칸을 연다
  w.mlReadmit();
  await wait(20);
  ok('재입원: 새 상담 칸, 이름 정명숙 복사', doc.getElementById('lfNm').value === '정명숙' && doc.getElementById('mlWork').textContent.indexOf('저장하면 이 단계에 들어갑니다') >= 0);
  ok('재입원: 상태 칸에 재입원 희망 기록', doc.getElementById('lfCond').value.indexOf('재입원 희망') === 0, doc.getElementById('lfCond').value);

  // 10. 이 날짜로 상담 접수 (선택일 지정)
  w.mlNewAt('10', { contactdt: '20261020' });
  await wait(20);
  ok('날짜 접수: 상담일 2026-10-20', doc.getElementById('lfContact').value === '2026-10-20', doc.getElementById('lfContact').value);
  w.mlNewAt('40');
  ok('바로 접수(입원): 입원 단계 접수 칸과 입원일 칸이 보임', doc.getElementById('mlWork').textContent.indexOf('입원') >= 0 && !doc.getElementById('lfAdmit').closest('[hidden]') && doc.getElementById('mlWork').textContent.indexOf('저장하면 이 단계에 들어갑니다') >= 0);

  // 11. 달 이동
  w.mlMonth(-1);
  const sepCells = doc.querySelectorAll('#mlCal .ml-cd:not(.out)');
  ok('달 이동: 9월은 30칸', sepCells.length === 30, 'cells=' + sepCells.length);
  ok('달 이동: 9/17 칸에 안부 정명숙', sepCells[16].textContent.indexOf('안부 정명숙') >= 0, sepCells[16].textContent);

  // 12. 검색
  doc.getElementById('mlQ').value = '박';
  w.mlSearch();
  ok('검색: 박종수 나옴', doc.getElementById('mlAgenda').textContent.indexOf('박종수') >= 0);

  // 13. 탭 전환
  w.mlTab('stat');
  ok('탭: 유입 분석 보임', !doc.getElementById('mlPaneStat').hasAttribute('hidden') && doc.getElementById('mlPaneCal').hasAttribute('hidden'));
  w.mlTab('cal');
  ok('탭: 달력 복귀', !doc.getElementById('mlPaneCal').hasAttribute('hidden'));

  // 15. 칸별 ✕ 지우기 → 그 칸만 비우고 저장, 환자 기록 전부 지우기 버튼 이름
  w.mlPick('2');
  await wait(20);
  calls.length = 0;
  w.mlClearField('lfPlan');
  await wait(60);
  const clr = calls.filter(c => c.url === '/mis/leadSave.do');
  ok('칸 지우기: 방문일만 비우고 저장(planDt 빈 값)', clr.length >= 1 && clr[0].data.planDt === '' && clr[0].data.leadSeq == 2, JSON.stringify(clr));
  ok('칸 지우기: 다른 칸(상태·보호자)은 그대로 저장', clr.length >= 1 && clr[0].data.patNm === '이순자' && clr[0].data.guardNm === '', JSON.stringify(clr));
  w.mlPick('1');
  const foot1 = doc.getElementById('mlWork').textContent;
  ok('삭제 버튼: 「환자 기록 전부 지우기」(한 줄 삭제와 구분)', foot1.indexOf('환자 기록 전부 지우기') >= 0 && foot1.indexOf('이 상담 지우기') < 0);
  // 칸 지우기 버튼이 화면에 있음
  ok('지우기 버튼 없음 · 방문일과 다음 할 일이 한 줄(.ml-line)에 있음', doc.querySelectorAll('#mlWork button[onclick*="mlClearFields"]').length === 0 && !!doc.getElementById('lfPlan').closest('.ml-line') && doc.getElementById('lfPlan').closest('.ml-line') === doc.getElementById('lfNextDt').closest('.ml-line'));

  // 14. 도움말 열고 닫기
  ok('도움말: 처음엔 닫혀 있음', doc.getElementById('mlHelp').hasAttribute('hidden'));
  w.mlHelp();
  ok('도움말: 단추로 열림', !doc.getElementById('mlHelp').hasAttribute('hidden'));
  ok('도움말: 단계 설명 포함', doc.getElementById('mlHelp').textContent.indexOf('다음 단계로 넘기기') >= 0);
  w.mlHelp();
  ok('도움말: 다시 누르면 닫힘', doc.getElementById('mlHelp').hasAttribute('hidden'));

  console.log('\n' + pass + ' 통과 · ' + fail + ' 실패');
  process.exit(fail ? 1 : 0);
}
run().catch(e => { console.error('검사 중 오류', e); process.exit(1); });
