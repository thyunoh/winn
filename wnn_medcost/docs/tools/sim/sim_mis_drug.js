// 약제 청구 현황 화면 검사 (2026-10-16) — misDrug.jsp (품목코드별)
// 품목별 청구분 · 정액분 · 합계, 합계 행, 기간 기본값, 조회 요청 모양을 확인한다. $ 와 AJAX 응답은 가짜다.
// 실행: node sim_mis_drug.js   (npm i 가 먼저 되어 있어야 한다)
const fs = require('fs');
const path = require('path');
const { JSDOM } = require('jsdom');

const FILE = path.resolve(__dirname, '../../../src/main/webapp/WEB-INF/jsp/main/mismgr/misDrug.jsp');
let pass = 0, fail = 0;
function ok(name, cond, extra){ if (cond) { pass++; console.log('  OK  ' + name); } else { fail++; console.log('  FAIL ' + name + (extra ? ' :: ' + extra : '')); } }
const wait = (ms) => new Promise(r => setTimeout(r, ms));

function strip(){
  let s = fs.readFileSync(FILE, 'utf8').replace(/\r\n/g, '\n');
  s = s.replace(/<%@[\s\S]*?%>/g, '').replace(/<%--[\s\S]*?--%>/g, '');
  s = s.replace(/<c:out value='\$\{[^}]*\}'\s*\/>/g, '');
  return s;
}

const resp = {
  '/mis/directorGet.do': { result:'OK', ym:'202608', fromYm:'202603' },
  // 품목코드별: fixTotal = 정액 명세서 약제비 · fixNonclaim = 그 중 항목 L(정액분) · prodTotal = 정액이 아닌 명세서 약제비
  '/tong/t_drugItemList.do': [
    { ediCode:'642100010', ediName:'약A', fixTotal:5000000, fixNonclaim:1000000, prodTotal:4000000, claimCount:7 },
    { ediCode:'642100020', ediName:'약B', fixTotal:2000000, fixNonclaim:0, prodTotal:1000000, claimCount:3 },
    { ediCode:'642100030', ediName:'약C', fixTotal:0, fixNonclaim:0, prodTotal:0, claimCount:0 },
  ],
};

async function run(){
  const calls = [];
  const $ = function(f){ if (typeof f === 'function') setTimeout(f, 0); return { on(){ return this; } }; };
  $.ajax = function(o){ calls.push({ url:o.url, data:o.data || {} }); const r = resp[o.url]; return Promise.resolve(r === undefined ? {} : r); };
  $.when = function(){ const p = Promise.all(Array.prototype.slice.call(arguments)); return { then(f){ return p.then(v => f.apply(null, v)); } }; };
  $.extend = Object.assign;
  const dom = new JSDOM('<!doctype html><html><body>' + strip() + '</body></html>', { runScripts:'dangerously', url:'http://localhost/', beforeParse(win){ win.$ = $; win._alertBox = () => {}; } });
  await wait(120);
  const doc = dom.window.document;

  ok('기간 기본값: 시작 2026-03 · 종료 2026-08', doc.getElementById('dgFrom').value === '2026-03' && doc.getElementById('dgTo').value === '2026-08');
  const drugCalls = calls.filter(c => c.url === '/tong/t_drugItemList.do');
  ok('조회: 품목코드별 자료 1번 요청(기간 202603~202608)', drugCalls.length === 1 && drugCalls[0].data.startMonth === '202603' && drugCalls[0].data.endMonth === '202608', JSON.stringify(drugCalls));

  const trs = [...doc.querySelectorAll('#dgBody table')[0].querySelectorAll('tbody tr')];
  const cells = tr => [...tr.querySelectorAll('td')].map(td => td.textContent.trim());
  const rowA = cells(trs[0]), rowB = cells(trs[1]);
  ok('품목 약A: 품목코드·이름 표시', rowA[1] === '642100010' && rowA[2] === '약A', JSON.stringify(rowA));
  ok('품목 약A: 청구분 8,000,000 · 정액분 1,000,000 · 합계 9,000,000', rowA[3] === '8,000,000' && rowA[4] === '1,000,000' && rowA[5] === '9,000,000', JSON.stringify(rowA));
  ok('품목 약A: 명세서 7건', rowA[7] === '7');
  ok('품목 약B: 청구분 3,000,000 · 정액분 0 · 합계 3,000,000', rowB[3] === '3,000,000' && rowB[4] === '0' && rowB[5] === '3,000,000', JSON.stringify(rowB));
  ok('품목 약C(0원)는 표에서 뺀다', trs.length === 2, 'rows=' + trs.length);
  ok('합계 순 정렬: 약A가 먼저', rowA[2] === '약A');
  const tot = doc.querySelector('#dgBody tr.tot');
  const tc = tot ? cells(tot) : [];
  ok('합계 행: 청구 11,000,000 · 정액 1,000,000 · 합계 12,000,000', tc[3] === '11,000,000' && tc[4] === '1,000,000' && tc[5] === '12,000,000', JSON.stringify(tc));
  ok('합계 행: 품목 2개 표시', tc[2] === '2개 품목');
  ok('요약 줄: 품목 2개 · 합계 12,000,000원', doc.getElementById('dgInfo').textContent.indexOf('품목 2개') >= 0 && doc.getElementById('dgInfo').textContent.indexOf('12,000,000원') >= 0, doc.getElementById('dgInfo').textContent);
  ok('청구세부통계로 돌아가는 링크', !!doc.querySelector('a[href="/main/misDirector.do"]'));

  console.log('\n' + pass + ' 통과 · ' + fail + ' 실패');
  process.exit(fail ? 1 : 0);
}
run().catch(e => { console.error('검사 중 오류', e); process.exit(1); });
