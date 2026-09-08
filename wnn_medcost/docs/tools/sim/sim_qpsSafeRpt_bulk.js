// safeRpt 화면 안 일괄 출력(2026-09-08) — 소스 JSP 에서 범위·기간·수집·복귀·사진 대기 논리를 꺼내 가짜 DOM 으로 돌린다
const fs = require('fs');
const { JSDOM } = require('jsdom');
const SRC = require('path').resolve(__dirname, '../../../src/main/webapp/WEB-INF/jsp/main/qpsmgr/qpsSafeRpt.jsp');
const s = fs.readFileSync(SRC, 'utf8');
function grab(re, name){ const m = s.match(re); if (!m) throw new Error('못 찾음: ' + name); return m[0]; }
const bands   = grab(/\n  var SR_BANDS = \[[\s\S]*?function srBandGbs\(band\)\{[\s\S]*?\n  \}/, 'SR_BANDS·srBandOf·srBandGbs');
const bpDef   = grab(/\n  window\.BP = \{ busy:false \};/, 'BP');
const months  = grab(/\n  function bpMonths\(\)\{[\s\S]*?\n  \}/, 'bpMonths');
const toggle  = grab(/\n  window\.srBulkPrintToggle = function\(\)\{[\s\S]*?\n  \};/, 'srBulkPrintToggle');
const inRange = grab(/\n  function bpInRange\(r, f, t\)\{[\s\S]*?\n  \}/, 'bpInRange');
const phWait  = grab(/\n  function bpPhotosWait\(\)\{[\s\S]*?\n  \}/, 'bpPhotosWait');
const go      = grab(/\n  window\.srBulkPrintGo = function\(\)\{[\s\S]*?\n  \};/, 'srBulkPrintGo');
const setPh   = grab(/\n  function setPhotos\(files\)\{[\s\S]*?\n  \}/, 'setPhotos');

const dom = new JSDOM(
  '<select id="srGb"><option value="PTSAFE">환자안전사고 보고서</option><option value="FALL">낙상 보고서</option>' +
  '<option value="DRUGRTN">의약품 반납</option><option value="EDURPT">직원 교육 결과 보고서</option></select>' +
  '<select id="srYear"><option value="2026" selected>2026</option></select>' +
  '<div id="srBulkPrintBox" style="display:none;">' +
  '<label><input type="radio" name="srBpScope" value="F" checked></label>' +
  '<label id="srBpBandWrap"><input type="radio" name="srBpScope" value="B"><span id="srBpBandNm"></span></label>' +
  '<label><input type="radio" name="srBpScope" value="A"></label>' +
  '<span id="srBpGbNm"></span><span id="srBpAllNm"></span><b id="srBpYear"></b>' +
  '<select id="srBpFrom"></select><select id="srBpTo"></select>' +
  '<button id="srBpGo"></button><span id="srBpStat"></span></div>');
const { window } = dom; const { document } = window;

const state = {
  GBS: [
    { subcode:'PTSAFE',  subcodenm:'환자안전사고 보고서', sort:'1' },
    { subcode:'FALL',    subcodenm:'낙상 보고서',        sort:'2' },
    { subcode:'DRUGRTN', subcodenm:'의약품 반납',        sort:'11' },
    { subcode:'EDURPT',  subcodenm:'직원 교육 결과 보고서', sort:'21' }],
  lists: {}, loads: [], opens: [], news: 0, failSeq: 0, photoOn: false,
  merges: [], revoked: [],
};
const ctx = {
  window, document, Option: window.Option, Promise,
  setTimeout: (f, ms) => setTimeout(f, Math.min(ms, 5)),   // 시뮬은 빨리 돈다(대기 논리만 본다)
  gel: id => document.getElementById(id),
  esc: v => String(v == null ? '' : v),
  URL: { revokeObjectURL: u => state.revoked.push(u), createObjectURL: () => 'blob:x' },
  qpsPrintMerge: (parts, title) => { state.merges.push({ n: parts.length, title }); return parts.length; },
  renderPhotos: () => {}, loadPhotoUrl: () => {}, state,
};
const code =
  'var GBS = state.GBS, LIST = [], curSeq = 0, PHOTOS = {}, HOSP_NM = "한마음병원", _phSlot = 0;' +
  '\nfunction gb(){ return gel("srGb").value || "PTSAFE"; }' +
  '\nfunction gbNm(){ for (var i=0;i<GBS.length;i++) if (GBS[i].subcode === gb()) return GBS[i].subcodenm; return "사고 보고서"; }' +
  '\nfunction photoOn(){ return state.photoOn; }' +
  '\nfunction srLoad(){ state.loads.push(gb()); return Promise.resolve().then(function(){ LIST = state.lists[gb()] || []; }); }' +
  '\nfunction srOpen(seq){ state.opens.push(Number(seq)); return Promise.resolve().then(function(){ if (state.failSeq !== Number(seq)) curSeq = Number(seq); }); }' +
  '\nfunction srNew(){ state.news++; curSeq = 0; }' +
  '\nfunction srPrint(){ if (window.QPS_BULK_CB) window.QPS_BULK_CB({ title:"t", css:"c", body:"doc" + curSeq }); }' +
  bands + bpDef +
  '\nvar BP = window.BP;' +   // 실제 페이지에선 window.BP 가 곧 전역 — Function 안에선 아니라 별칭
  months + toggle + inRange + phWait + go + setPh +
  '\nreturn { bpInRange, srBandOf, srBandGbs, bpPhotosWait, setPhotos,' +
  '\n  toggle: window.srBulkPrintToggle, go: window.srBulkPrintGo, BP: window.BP,' +
  '\n  cur: () => curSeq, setCur: v => { curSeq = v; }, photos: () => PHOTOS, setPhoto: (k, v) => { PHOTOS[k] = v; } };';
const M = new Function(...Object.keys(ctx), code)(...Object.values(ctx));

let pass = 0, fail = 0;
const ok = (n, c) => { if (c) { pass++; console.log('  ✅', n); } else { fail++; console.log('  ❌', n); } };
const until = f => new Promise(res => { (function t(){ if (f()) return res(); setTimeout(t, 5); })(); });

(async function(){
  // 1. 기간 판정 — 발생일의 월
  ok('발생일 3월 · 범위 02~09 → 담김', M.bpInRange({ occurdt:'2026-03-15' }, '02', '09') === true);
  ok('발생일 12월 · 범위 02~09 → 빠짐', M.bpInRange({ occurdt:'2026-12-01' }, '02', '09') === false);
  ok('발생일 없음 → 담김(해가 같으니)', M.bpInRange({ occurdt:'' }, '02', '09') === true);

  // 2. 계열(SORT 대역)
  const band = M.srBandOf('FALL');
  ok('FALL(sort 2) → 사고 · 안전 계열', !!band && band[2] === '사고 · 안전 보고서');
  ok('계열 구성 = PTSAFE·FALL 2종', M.srBandGbs(band).map(c => c.subcode).join(',') === 'PTSAFE,FALL');

  // 3. 조건 띠 열기
  document.getElementById('srGb').value = 'FALL';
  M.toggle();
  ok('열림 + 월 12칸 + 01~12 기본', document.getElementById('srBulkPrintBox').style.display === '' &&
     document.getElementById('srBpFrom').options.length === 12 && document.getElementById('srBpFrom').value === '01');
  ok('이름표 = 유형·계열(2종)·전체(4종)', /낙상/.test(document.getElementById('srBpGbNm').textContent) &&
     /2종/.test(document.getElementById('srBpBandNm').textContent) && /4종/.test(document.getElementById('srBpAllNm').textContent));
  M.toggle();
  ok('다시 누르면 닫힘(월은 한 번만 채움)', document.getElementById('srBulkPrintBox').style.display === 'none');

  // 4. sort 없는 옛 서버 — 계열 범위 숨김 + B 체크였으면 F 로
  state.GBS.forEach(c => { delete c.sort; });
  document.querySelector('input[name=srBpScope][value=B]').checked = true;
  M.toggle();
  ok('계열 숨김 · F 로 복귀', document.getElementById('srBpBandWrap').style.display === 'none' &&
     document.querySelector('input[name=srBpScope][value=F]').checked);
  M.toggle();
  state.GBS[0].sort = '1'; state.GBS[1].sort = '2'; state.GBS[2].sort = '11'; state.GBS[3].sort = '21';

  // 5. 이 유형만 — 기간으로 거르고, 끝나면 원래 유형·보고서로
  state.lists = { FALL: [
    { srpseq: 11, occurdt: '2026-03-01' }, { srpseq: 12, occurdt: '2026-08-15' }, { srpseq: 13, occurdt: '2026-12-31' }] };
  document.getElementById('srGb').value = 'FALL'; M.setCur(12);
  M.toggle();
  document.getElementById('srBpFrom').value = '02'; document.getElementById('srBpTo').value = '09';
  state.loads.length = 0; state.opens.length = 0; state.merges.length = 0;
  M.go();
  await until(() => !M.BP.busy);
  ok('2건만 담아 합침(12월 것 제외)', state.merges.length === 1 && state.merges[0].n === 2);
  ok('제목 = 유형_연_월범위_병원', state.merges[0].title === '낙상 보고서_2026년_2~9월_한마음병원');
  ok('끝나면 보던 보고서(12)로 복귀', document.getElementById('srGb').value === 'FALL' &&
     state.opens[state.opens.length - 1] === 12 && M.cur() === 12);
  ok('출력 단추 다시 활성', document.getElementById('srBpGo').disabled === false);

  // 6. 못 연 문서는 건너뛴다 — 이전 문서 내용이 그 자리에 찍히면 안 된다
  state.failSeq = 12; state.merges.length = 0; M.setCur(0);
  const kept = [];
  const oldCB = null;
  M.go();
  await until(() => !M.BP.busy);
  ok('실패 1건 건너뜀 → 1장만', state.merges.length === 1 && state.merges[0].n === 1);
  state.failSeq = 0;

  // 7. 전체 유형 — 유형마다 목록을 새로 받는다
  state.lists = { PTSAFE: [{ srpseq: 1, occurdt: '2026-05-05' }], FALL: [{ srpseq: 2, occurdt: '2026-06-06' }],
                  DRUGRTN: [], EDURPT: [{ srpseq: 3, occurdt: '2026-07-07' }] };
  document.querySelector('input[name=srBpScope][value=A]').checked = true;
  document.getElementById('srBpFrom').value = '01'; document.getElementById('srBpTo').value = '12';
  state.loads.length = 0; state.merges.length = 0; M.setCur(0);
  M.go();
  await until(() => !M.BP.busy);
  ok('전체 4유형 순회(복귀 포함 5회 로드) → 3장', state.merges.length === 1 && state.merges[0].n === 3 && state.loads.length === 5);
  ok('전체 제목', /^보고서 전체_2026년_한마음병원$/.test(state.merges[0].title));
  ok('빈 유형에서 새 보고서 화면으로 복귀', state.news >= 1);

  // 8. 이 계열 — 대역 안 유형만
  document.querySelector('input[name=srBpScope][value=B]').checked = true;
  document.getElementById('srGb').value = 'PTSAFE'; M.setCur(0);
  state.loads.length = 0; state.merges.length = 0;
  M.go();
  await until(() => !M.BP.busy);
  ok('계열 = PTSAFE·FALL 만 순회 → 2장', state.merges[0].n === 2 &&
     state.loads.slice(0, 2).join(',') === 'PTSAFE,FALL');
  ok('계열 제목', state.merges[0].title === '사고 · 안전 보고서_2026년_한마음병원');

  // 9. 사진 대기 — url 이 붙으면 바로, 없으면 폴링 뒤 통과
  state.photoOn = true;
  M.setPhoto(1, { url: 'blob:a' }); M.setPhoto(2, { url: '' });
  let waited = false;
  const p = M.bpPhotosWait().then(() => { waited = true; });
  await new Promise(r => setTimeout(r, 20));
  ok('사진이 덜 붙었으면 기다린다', waited === false);
  M.photos()[2].url = 'blob:b';
  await p;
  ok('다 붙으면 통과', waited === true);

  // 10. 일괄 출력 중에는 blob 을 거두지 않는다
  state.revoked.length = 0;
  M.BP.busy = true;  M.setPhotos([]);
  ok('BP.busy → revoke 0', state.revoked.length === 0);
  M.setPhoto(1, { url: 'blob:z' });
  M.BP.busy = false; M.setPhotos([]);
  ok('평소에는 revoke 한다', state.revoked.indexOf('blob:z') >= 0);

  console.log('\n통과 ' + pass + ' · 실패 ' + fail);
  process.exit(fail ? 1 : 0);
})();
