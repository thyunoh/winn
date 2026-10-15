// 경영 보고서 탭 통합 검사 (2026-10-15) — 병원장 보고(misDirRepPanel.jsp) · 수입 일보(misRevenuePanel.jsp)
// 소스 JSP 에서 JSP 태그만 걷어 내고 jsdom 에서 그대로 돌린다. $ 와 AJAX 응답은 가짜다.
// 실행: node sim_mis_report_tabs.js
// 실행 전 npm i 가 먼저 되어 있어야 한다. 인코딩 회귀: 정적 include 되는 패널은 pageEncoding="UTF-8" 을 직접 가져야 한다.
const fs = require('fs');
const path = require('path');
const { JSDOM } = require('jsdom');

const BASE = path.resolve(__dirname, '../../../src/main/webapp/WEB-INF/jsp/main/mismgr');
let pass = 0, fail = 0;
function ok(name, cond, extra){ if (cond) { pass++; console.log('  OK  ' + name); } else { fail++; console.log('  FAIL ' + name + (extra ? ' :: ' + extra : '')); } }

// JSP → 브라우저 HTML (지시자·주석 제거, 자주 쓰는 EL 값만 치환)
function strip(file, vals){
  let s = fs.readFileSync(path.join(BASE, file), 'utf8').replace(/\r\n/g, '\n');
  s = s.replace(/<%--[\s\S]*?--%>/g, '');
  s = s.replace(/<c:out value='\$\{(\w+)\}'\/>/g, (m, k) => vals[k] || '');
  return s;
}

// jQuery 최소 흉내 — ajax 는 응답표에서 꺼내 Promise 로 준다. when 은 여러 Promise 를 펼쳐서 넘긴다.
function makeJq(resp, calls){
  const $ = function(){};
  $.extend = Object.assign;
  $.ajax = function(o){
    calls.push(o.url);
    calls.data = calls.data || {}; calls.data[o.url] = o.data;
    const r = resp[o.url];
    return Promise.resolve(r === undefined ? [] : (typeof r === 'function' ? r(o.data || {}) : r));
  };
  $.when = function(){
    const ps = Array.prototype.slice.call(arguments);
    const p = Promise.all(ps);
    return { then(f){ return p.then(v => f.apply(null, v)); } };
  };
  $.Deferred = function(){ return { resolve(){ return { promise(){ return Promise.resolve(); } }; } }; };
  return $;
}
const wait = (ms) => new Promise(r => setTimeout(r, ms));

async function runPage(html, jq, extraSetup){
  const alerts = [];
  const dom = new JSDOM('<!doctype html><html><body>' + html + '</body></html>', {
    runScripts: 'dangerously', url: 'http://localhost/',
    beforeParse(win){
      win.$ = jq;
      win._alertBox = (m) => alerts.push(String(m));
      win.Chart = undefined;
      win.HTMLCanvasElement.prototype.getContext = () => null;
    }
  });
  await wait(60);
  if (extraSetup) extraSetup(dom.window);
  await wait(60);
  return { dom, alerts };
}

(async () => {
  ['misDirRepPanel.jsp','misRevenuePanel.jsp'].forEach(f => {
    const raw = fs.readFileSync(path.join(BASE, f), 'utf8');
    ok(f + ': pageEncoding=UTF-8 지시자 있음', /<%@\s*page\s+pageEncoding="UTF-8"\s*%>/.test(raw));
  });

  /* ─────────── 1. 병원장 보고 ─────────── */
  console.log('[병원장 보고 — misDirRepPanel]');
  const dirHtml = strip('misDirRepPanel.jsp', { hospNm:'테스트요양병원', hospCd:'11223344', wnnYn:'N' });
  const calls1 = [];
  const resp1 = {
    '/mis/directorGet.do': { result:'OK', ym:'202608', today:'20261015',
      claim:{ totamt:142823510, admdays:300, claimamt:115349590 }, pats:65 },
    '/mis/costGet.do': {
      cfg:{ varcostday:25000, bedcnt:200 },
      cats:[ {catcd:'01', catnm:'인건비', catgb:'C', useyn:'Y'}, {catcd:'02', catnm:'임대료', catgb:'C', useyn:'Y'}, {catcd:'R1', catnm:'비급여 수익', catgb:'R', useyn:'Y'} ],
      cost:[ {catcd:'01', amt:210000000}, {catcd:'02', amt:22000000} ],
      prevCost:[ {catcd:'01', amt:200000000} ],
      trend:[ {ym:'202608', costamt:232000000, extraamt:0} ],
      trendClaim:[ {ym:'202608', totamt:142823510, admdays:300}, {ym:'202607', totamt:130000000, admdays:280} ],
      prevYm:'202607' },
    '/tong/t_tong06List.do': [],
    '/tong/t_tong05List.do': [
      { licenseNo:'12345', licenseName:'김의사', totalAmt:50000000, claimCount:40, avgAmt:1250000 },
      { licenseNo:'99', licenseName:'전체', totalAmt:115349590, claimCount:70, avgAmt:1647851 } ],
    '/tong/t_tong04List.do': [
      { diagCode:'ZZ', diagName:'기타병명', totalAmt:60644510, claimCount:42, uniqPatients:30, amtPerClaim:1443917, amtPerPatient:2021483 },
      { diagCode:'F00', diagName:'알츠하이머병', totalAmt:18502330, claimCount:10, uniqPatients:6, amtPerClaim:1850233, amtPerPatient:3083721 } ],
    '/tong/t_tong00List.do': [ { dateYm:'202608', ipAmt:115349590, totalAvgAmt:1150000 } ],
    '/tong/t_tong082List.do': [ { medDept:'00', yakAmt:4000000 } ],
    '/tong/t_tong08List.do': [ { medDept:'00', yakAmt:6000000 } ],
    '/tong/t_tong081List.do': [ { medDept:'00', yakAmt:5000000 } ],
    '/tong/t_tong083List.do': [ { medDept:'00', yakAmt:9000000 } ],
    '/tong/t_tong09List.do': [ { itemName:'전체', totalAmt:9000000 }, { codeName:'L', itemName:'요양병원 정액', totalAmt:3000000, claimCount:12 } ],
  };
  const jq1 = makeJq(resp1, calls1);
  const { dom: d1, alerts: a1 } = await runPage(dirHtml, jq1, (w) => w.misDirStart());
  const doc1 = d1.window.document;
  const root1 = doc1.getElementById('mdrRoot');
  const txt1 = root1.textContent;
  ok('병원장 보고: 페이지 두 장(.pg 2개)', root1.querySelectorAll('.pg').length === 2, 'pg=' + root1.querySelectorAll('.pg').length);
  ['청구세부통계', 'Ⅰ. 수익', 'Ⅱ. 12개월', 'Ⅲ. 비용 지출 명세', 'Ⅳ. 수익 구성', 'Ⅴ. 청구 분석', 'Ⅵ. 일당금액', 'Ⅶ. 약처방']
    .forEach(k => ok('섹션 있음: ' + k, txt1.indexOf(k) >= 0));
  ok('총진료비(청구) 142,823,510', txt1.indexOf('142,823,510') >= 0);
  ok('비용 합계 = 고정비 232,000,000 + 변동비 25,000×300일 = 239,500,000', txt1.indexOf('239,500,000') >= 0);
  ok('추정 손익 = 142,823,510 − 239,500,000 → 적자(−96,676,490)', txt1.indexOf('−96,676,490') >= 0);
  ok('질환별 ZZ 기타병명 행 + 설명', txt1.indexOf('ZZ 기타병명') >= 0 && txt1.indexOf('질병 분류표') >= 0);
  ok('의사별: 면허 12345 김의사', txt1.indexOf('김의사') >= 0);
  ok('의사별: 면허 99(전체)는 빠짐', txt1.indexOf('면허 99') < 0);
  ok('정액 비청구 항목 표시', txt1.indexOf('요양병원 정액') >= 0);
  ok('NaN·undefined 없음', txt1.indexOf('NaN') < 0 && txt1.indexOf('undefined') < 0);
  ok('경영 보고서와 같은 호출: directorGet + costGet + 청구 분석 9개', calls1.filter(u => u.indexOf('/tong/') === 0).length === 9 && calls1.indexOf('/mis/directorGet.do') >= 0 && calls1.indexOf('/mis/costGet.do') >= 0, calls1.join(','));

  // 청구월 선택 — 조회를 누르면 그 달이 자료 요청(directorGet·costGet·청구 분석)에 실린다
  {
    const n0 = calls1.length;
    doc1.getElementById('mdrFrom').value = '2025-01';
    doc1.getElementById('mdrYm').value = '2025-03';
    doc1.getElementById('mdrGo').click();
    await wait(80);
    const dd = calls1.data['/mis/directorGet.do'];
    ok('청구세부통계: 시작월 2025-01 ~ 종료월 2025-03 → directorGet fromYm=202501 toYm=202503', dd && dd.fromYm === '202501' && dd.toYm === '202503', JSON.stringify(dd));
    ok('청구세부통계: 조회 뒤 청구 분석도 그 달로 다시 요청', calls1.slice(n0).filter(u => u.indexOf('/tong/') === 0).length === 9);
  }

  // 자료 없음 — 청구월이 비면 안내만
  const jq1b = makeJq({ '/mis/directorGet.do': { result:'OK', ym:'', today:'20261015', claim:null } }, []);
  const { dom: d1b } = await runPage(dirHtml, jq1b, (w) => w.misDirStart && w.misDirStart());
  const noteTxt = d1b.window.document.getElementById('mdrNote').textContent;
  ok('청구 자료 없음 → 안내 표시', d1b.window.document.getElementById('mdrNote').hidden === false && noteTxt.length > 0 && d1b.window.document.getElementById('mdrRoot').querySelectorAll('.pg').length === 0);

  /* ─────────── 2. 수입 일보 ─────────── */
  console.log('[수입 일보 — misRevenuePanel]');
  const revHtml = strip('misRevenuePanel.jsp', { hospNm:'테스트요양병원', hospCd:'11223344', wnnYn:'N' });
  const now = new Date();
  const ym = now.getFullYear() + ('0' + (now.getMonth() + 1)).slice(-2);
  const rows = [
    { paydt: ym + '15', io:'IP', pm:'카드', cnt:2, totamt:1000000, insamt:600000, selfamt:100000, nonpayamt:300000, paidamt:300000, unpaidamt:0 },
    { paydt: ym + '15', io:'OP', pm:'현금', cnt:3, totamt:500000, insamt:300000, selfamt:50000, nonpayamt:150000, paidamt:500000, unpaidamt:0 },
    { paydt: ym + '16', io:'OP', pm:'카드', cnt:1, totamt:200000, insamt:140000, selfamt:24000, nonpayamt:36000, paidamt:60000, unpaidamt:0 }
  ];
  const calls2 = [];
  const jq2 = makeJq({ '/mis/revGet.do': (data) => ({ result:'OK', rows: rows }) }, calls2);
  const { dom: d2, alerts: a2 } = await runPage(revHtml, jq2, (w) => w.misRevStart());
  const doc2 = d2.window.document;
  const dayTxt = doc2.getElementById('rvDayBody').textContent;
  ok('수입 일보: 날짜별 표에 15일·16일', dayTxt.indexOf(ym.slice(0,4) + '-' + ym.slice(4,6) + '-15') >= 0 && dayTxt.indexOf(ym.slice(0,4) + '-' + ym.slice(4,6) + '-16') >= 0);
  ok('수입 일보: 수납방법별 카드·현금', dayTxt.indexOf('카드') >= 0 && dayTxt.indexOf('현금') >= 0);
  ok('수입 일보: 15일 수납 합계 800,000원 (300,000 + 500,000)', dayTxt.indexOf('800,000') >= 0);
  ok('수입 일보: 안쪽 탭은 일별·월별 2개뿐(경영 보고서 칸 없음)', doc2.querySelectorAll('#misRev .rv-tab').length === 2 && doc2.querySelector('#misRev [data-tab="rep"]') === null);
  // 월별 탭으로 전환 — 같은 자료를 달 단위로
  doc2.querySelector('#misRev [data-tab="mon"]').click();
  await wait(30);
  const monTxt = doc2.getElementById('rvMonBody').textContent;
  ok('수입 일보: 월별 표 합계 — 총 건수 6건 · 수납 860,000', doc2.querySelectorAll('#rvMonBody tr')[0].textContent.indexOf('') >= 0 && monTxt.indexOf('6') >= 0 && monTxt.indexOf('860,000') >= 0, monTxt.slice(0, 200));
  ok('수입 일보: 빈 달 안내 없이 표 표시', monTxt.indexOf('수납대장 자료가 아직 없습니다') < 0);

  /* ─────────── 3. 경영 보고서 탭 전환 스크립트 ─────────── */
  console.log('[탭 전환 — misReport.jsp 의 탭 스크립트만]');
  const src = fs.readFileSync(path.join(BASE, 'misReport.jsp'), 'utf8').replace(/\r\n/g, '\n');
  const m = src.match(/<script>\s*\(function\(\)\{\s*var INIT[\s\S]*?<\/script>/);
  ok('탭 스크립트 블록을 찾음', !!m);
  if (m) {
    const tabHtml = '<div id="mrTabs"><button class="mr-tab" data-tab="rep">a</button><button class="mr-tab" data-tab="dir">b</button><button class="mr-tab" data-tab="rev">c</button></div>' +
      '<div class="mr-panel" id="mrPanelRep"></div><div class="mr-panel" id="mrPanelDir" hidden></div><div class="mr-panel" id="mrPanelRev" hidden></div>';
    const script = m[0].replace('${empty initTab ? "rep" : initTab}', 'dir').replace(/<\/?script>/g, '');
    const starts = [];
    const dom = new JSDOM('<!doctype html><html><body>' + tabHtml + '</body></html>', { runScripts:'dangerously', beforeParse(w){ w.misDirStart = () => starts.push('dir'); w.misRevStart = () => starts.push('rev'); } });
    const s = dom.window.document.createElement('script'); s.textContent = script; dom.window.document.body.appendChild(s);
    await wait(20);
    const dd = dom.window.document;
    ok('초기 탭 dir → 병원장 보고 패널만 보임', dd.getElementById('mrPanelDir').hidden === false && dd.getElementById('mrPanelRep').hidden === true && dd.getElementById('mrPanelRev').hidden === true);
    ok('초기 탭 dir → 시작 함수 한 번 호출', starts.join(',') === 'dir', starts.join(','));
    dd.querySelector('[data-tab="rev"]').click();
    await wait(10);
    ok('수입 일보 탭 클릭 → 패널 전환 + 시작 호출', dd.getElementById('mrPanelRev').hidden === false && dd.getElementById('mrPanelDir').hidden === true && starts.indexOf('rev') >= 0);
    ok('탭 버튼 on 표시 이동', dd.querySelector('[data-tab="rev"]').className.indexOf('on') >= 0 && dd.querySelector('[data-tab="dir"]').className.indexOf('on') < 0);
  }

  console.log('\n' + pass + ' 통과 · ' + fail + ' 실패');
  process.exit(fail ? 1 : 0);
})().catch(e => { console.error('검사 중 오류', e); process.exit(1); });
