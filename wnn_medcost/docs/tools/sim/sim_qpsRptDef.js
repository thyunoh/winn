// 보고서 체크 묶음 관리 화면 — 가짜 DOM 에서 스크립트를 그대로 돌린다($.ajax 를 가짜로)
const fs = require('fs');
const { JSDOM } = require('jsdom');
const SRC = require('path').resolve(__dirname, '../../../src/main/webapp/WEB-INF/jsp/main/qpsmgr/qpsRptDef.jsp');
let html = fs.readFileSync(SRC, 'utf8')
  .replace(/<%@[^%]*%>/g, '').replace(/<%--[\s\S]*?--%>/g, '')
  .replace(/<c:url value="([^"]+)"\/>/g, '$1').replace(/<c:out value='\$\{wnnYn\}'\/>/g, 'Y').replace(/<c:out value='\$\{hospNm\}'\/>/g, '테스트병원')
  .replace(/<script src="[^"]*"><\/script>/g, '');

const TYPES = [{ codecd:'QPS_SAFERPT_GB', subcode:'PTSAFE', subcodenm:'환자안전사고', sort:1, useyn:'Y' }, { codecd:'QPS_SAFERPT_GB', subcode:'STAFF', subcodenm:'직원안전사고', sort:2, useyn:'Y' }, { codecd:'QPS_SAFERPT_GB', subcode:'EMPTY', subcodenm:'빈유형', sort:3, useyn:'Y' }];
const DEF = [
  { rptgb:'*', grpcd:'JOB', grpnm:'직종', itemnm:'의사', multiyn:'N', etcyn:'N', sort:1, useyn:'Y' },
  { rptgb:'*', grpcd:'JOB', grpnm:'직종', itemnm:'간호사', multiyn:'N', etcyn:'N', sort:2, useyn:'Y' },
  { rptgb:'*', grpcd:'RX', grpnm:'처방', itemnm:'투약', multiyn:'Y', etcyn:'N', sort:1, useyn:'Y' },
  { rptgb:'PTSAFE', grpcd:'DAMAGE', grpnm:'손상종류', itemnm:'없음', multiyn:'N', etcyn:'N', sort:1, useyn:'Y' },
  { rptgb:'PTSAFE', grpcd:'DAMAGE', grpnm:'손상종류', itemnm:'기타', multiyn:'N', etcyn:'Y', sort:99, useyn:'N' },
  { rptgb:'PTSAFE', grpcd:'ORPHAN', grpnm:'연결없음', itemnm:'a', multiyn:'Y', etcyn:'N', sort:1, useyn:'Y' },
];
const USE = [
  { rptgb:'PTSAFE', grpcd:'DAMAGE', sort:2, useyn:'Y' }, { rptgb:'PTSAFE', grpcd:'JOB', sort:1, useyn:'Y' }, { rptgb:'PTSAFE', grpcd:'GHOST', sort:3, useyn:'Y' },
  { rptgb:'STAFF', grpcd:'JOB', sort:1, useyn:'Y' },
];
const posted = [];
function fakeJq(win){
  win._alertBox = (m) => { posted.push({ alert: m }); }; win._toast = () => {};
  win.$ = function(fn){ if (typeof fn === 'function') fn(); return win.$; };
  win.$.ajax = function(o){ posted.push({ url: o.url, data: o.data }); const res = o.url.indexOf('rdefList') >= 0 ? { result:'OK', types: TYPES, def: DEF, use: USE } : { result:'OK' };
    return { then: function(f){ const r = f(res); return { catch: function(){} , then: function(g){ g(r); return { catch: function(){} }; } }; } }; };
}
const dom = new JSDOM('<!doctype html><html><body>' + html + '</body></html>', { runScripts: 'dangerously', beforeParse: fakeJq });
const w = dom.window, d = w.document;

let pass = 0, fail = 0;
const ok = (n, c) => { if (c) { pass++; console.log('  ✅', n); } else { fail++; console.log('  ❌', n); } };

ok('유형 목록 = 공유 + 3', d.querySelectorAll('#rdTypes .rd-ty').length === 4);
ok('첫 유형 자동 선택(PTSAFE)', d.getElementById('rdCode').textContent === 'PTSAFE');
const cards = [...d.querySelectorAll('#rdCards .rd-card')];
ok('PTSAFE 카드 4 = USE 순(JOB→DAMAGE→GHOST) + 연결 없는 ORPHAN', cards.map(c => c.getAttribute('data-cd')).join(',') === 'JOB,DAMAGE,GHOST,ORPHAN');
ok('공유 묶음 카드에 공유 배지·경고', cards[0].querySelector('.badge.sh') && /1개 유형/.test(cards[0].querySelector('.warn').textContent) === false && /2개 유형이 같이/.test(cards[0].querySelector('.warn').textContent));
ok('전용 묶음 카드 배지', !!cards[1].querySelector('.badge.own'));
ok('USE 만 있고 DEF 없는 GHOST 도 보인다(항목 없음)', cards[2].querySelector('[data-g="grpnm"]').value === '(항목 없음)' && /항목이 없습니다/.test(cards[2].textContent));
ok('연결 없는 전용 묶음은 경고 + 씀 꺼짐', /연결 없음/.test(cards[3].textContent) && cards[3].querySelector('[data-g="useyn"]').checked === false);
ok('DAMAGE 항목 2, 내린 항목은 off', cards[1].querySelectorAll('tbody tr').length === 2 && cards[1].querySelector('tbody tr[data-item="기타"]').classList.contains('off'));
ok('요약 줄', /4묶음 · 항목 4/.test(d.getElementById('rdSum').textContent));
ok('붙일 공유 묶음 = RX 만(JOB 은 이미 씀)', [...d.querySelectorAll('#rdAttach option')].map(o => o.value).join(',') === 'RX');

// 항목 저장 — 기타 켜고 저장
posted.length = 0;
const tr = cards[1].querySelector('tbody tr[data-item="없음"]');
tr.querySelector('[data-f="etcyn"]').checked = true; w.rdDirty(tr.querySelector('[data-f="etcyn"]'));
w.rdItemSave(tr.querySelector('button'));
const it = posted.find(p => p.url && p.url.indexOf('rdefSave') >= 0);
ok('항목 저장 요청: 유형·묶음·항목·기타 Y', it && it.data.rptGb === 'PTSAFE' && it.data.grpCd === 'DAMAGE' && it.data.itemNm === '없음' && it.data.etcYn === 'Y' && it.data.useYn === 'Y');

// 묶음 저장 — 공유 JOB 이름 바꿈 + 차례 바꿈 → GRP('*' 소유) + USE(PTSAFE)
w.rdLoad(true); posted.length = 0;
const jobCard = d.querySelector('#rdCards .rd-card[data-cd="JOB"]');
jobCard.querySelector('[data-g="grpnm"]').value = '직 종'; jobCard.querySelector('[data-g="usesort"]').value = '5';
w.rdGrpSave(jobCard.querySelector('.gh button'));
const g = posted.find(p => p.url && p.url.indexOf('rdefGrpSave') >= 0), u = posted.find(p => p.url && p.url.indexOf('rdefUseSave') >= 0);
ok('묶음 저장: DEF 는 공유(*) 소유로', g && g.data.rptGb === '*' && g.data.grpCd === 'JOB' && g.data.grpNm === '직 종');
ok('묶음 저장: USE 는 현재 유형(PTSAFE) 차례 5', u && u.data.rptGb === 'PTSAFE' && u.data.grpCd === 'JOB' && u.data.sort === '5' && u.data.useYn === 'Y');

// 새 묶음 — 항목 3개 + USE 연결, 기타 자동 ETC
w.rdLoad(true); posted.length = 0;
d.getElementById('rdNewCd').value = 'newgrp'; d.getElementById('rdNewNm').value = '새 묶음'; d.getElementById('rdNewMulti').value = 'N'; d.getElementById('rdNewItems').value = '유, 무 ,기타( )';
w.rdNewGrp();
const items = posted.filter(p => p.url && p.url.indexOf('rdefSave') >= 0), use2 = posted.find(p => p.url && p.url.indexOf('rdefUseSave') >= 0);
ok('새 묶음: 항목 3건 코드 대문자·차례 1..3·기타 ETC', items.length === 3 && items.every(p => p.data.grpCd === 'NEWGRP' && p.data.rptGb === 'PTSAFE') && items[2].data.etcYn === 'Y' && items[2].data.sort === 3 && items[0].data.multiYn === 'N');
ok('새 묶음: USE 연결 차례 = 쓰는 수 + 1 (3+1)', use2 && use2.data.rptGb === 'PTSAFE' && use2.data.grpCd === 'NEWGRP' && use2.data.sort === 4);

// 이미 있는 코드는 막는다
posted.length = 0; d.getElementById('rdNewCd').value = 'DAMAGE'; d.getElementById('rdNewNm').value = 'x'; d.getElementById('rdNewItems').value = 'a';
w.rdNewGrp();
ok('이미 있는 묶음 코드 → 경고, 요청 없음', posted.some(p => p.alert && /이미 있는/.test(p.alert)) && !posted.some(p => p.url));

// 공유 붙이기
posted.length = 0; d.getElementById('rdAttach').value = 'RX'; w.rdAttachGrp();
const at = posted.find(p => p.url && p.url.indexOf('rdefUseSave') >= 0);
ok('공유 붙이기: USE(PTSAFE, RX)', at && at.data.rptGb === 'PTSAFE' && at.data.grpCd === 'RX');

// 공유 화면
w.rdLoad(true); w.rdPick('*');
const sc = [...d.querySelectorAll('#rdCards .rd-card')];
ok('공유 화면: JOB·RX 2카드, 쓰는 유형 표시, 붙이기 숨김', sc.length === 2 && /쓰는 유형 : 환자안전사고 · 직원안전사고/.test(sc[0].textContent) && d.getElementById('rdAttachWrap').style.display === 'none');
posted.length = 0; d.getElementById('rdNewCd').value = 'SH1'; d.getElementById('rdNewNm').value = '공유새'; d.getElementById('rdNewItems').value = 'a,b'; w.rdNewGrp();
ok('공유 화면 새 묶음: 소유 * · USE 요청 없음', posted.filter(p => p.url && p.url.indexOf('rdefSave') >= 0).every(p => p.data.rptGb === '*') && !posted.some(p => p.url && p.url.indexOf('rdefUseSave') >= 0));

// 빈 유형
w.rdLoad(true); w.rdPick('EMPTY');
ok('빈 유형 안내 + 붙일 공유 2개', /쓰지 않습니다/.test(d.getElementById('rdCards').textContent) && d.querySelectorAll('#rdAttach option').length === 2);

// 검색
d.getElementById('rdFind').value = '손상'; w.rdPaintTypes();
ok('검색 「손상」 → PTSAFE 만(공유 제외)', [...d.querySelectorAll('#rdTypes .rd-ty')].length === 1 && /PTSAFE/.test(d.getElementById('rdTypes').textContent));

// 병원 계정(WNN=N) — 고치기 숨김
const html2 = html.replace('data-wnn="Y"', 'data-wnn="N"');
const dom2 = new JSDOM('<!doctype html><html><body>' + html2 + '</body></html>', { runScripts: 'dangerously', beforeParse: fakeJq });
const w2 = dom2.window, d2 = w2.document;
ok('병원 계정: 저장 단추·새 묶음 숨김, 입력 disabled', d2.getElementById('rdFoot').style.display === 'none' && d2.getElementById('rdTopBtns').style.display === 'none' && !d2.querySelector('#rdCards button') && d2.querySelector('#rdCards input[data-g="grpnm"]').disabled);

console.log('\n통과 ' + pass + ' · 실패 ' + fail);
process.exit(fail ? 1 : 0);
