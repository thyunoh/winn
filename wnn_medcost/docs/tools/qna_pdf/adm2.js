/* 행정해석(173~200p) [연번|질의|답변] 표 → 항목 단위 질의/답변
   ★처음 시도(adm.js)가 실패한 이유: 칼럼 경계를 <표 머리글('답변') 글자 위치>로 잡았는데
     머리글은 칸 <가운데> 정렬이라 본문 시작 위치와 다르다. 질의응답 02절에서 쓴 방법대로
     본문의 '○' 위치 최빈값을 경계로 잡으면 깨끗하게 갈린다. */
const fs = require('fs');
const RAW = fs.readFileSync('adm_raw.txt', 'utf8').split('\f');   // -table 로 뽑은 173p~
const FIRST = 173, TABLE_FROM = 176;                              // 173~175 = 목록 요약(표 아님)

const SIDE = /^[ⅠⅡⅢⅣⅤ요양병원관련법령수가고시등행정해석부록환자평표작성매뉴얼]$/;
/* ★머리말·꼬리말은 <줄 어디에> 있든 지운다 — 표 칼럼 위치에 찍혀 나오는 판이라
     ^…$ 로 묶으면 안 걸리고 그대로 질의·답변 본문에 섞여 들어간다. */
const drop = t => !t.trim()
  || /요양병원 수가 실무교육자료/.test(t)
  || /요양병원 행정해석 등/.test(t)
  || /건강보험심사평가원/.test(t)
  || /HEALTH\s+INSURANCE|ASSESSMENT\s+SERVIC/.test(t)
  || /^\d{1,3}\s*[�█\s]*$/.test(t.trim());
const stripSide = l => l.replace(/\s{12,}([ⅠⅡⅢⅣⅤ가-힣])\s*$/, (m, c) => (SIDE.test(c) ? '' : m));

const items = [];
let cur = null;

for (let i = 0; i < RAW.length; i++) {
  const pg = FIRST + i;
  if (pg < TABLE_FROM) continue;
  const raw = RAW[i].split('\n').map(stripSide).filter(l => !drop(l));
  if (!raw.length) continue;

  /* 답변 칼럼 = 본문 '○'(또는 '가.','1.') 시작 위치의 최빈값 */
  const h = {};
  raw.forEach(l => { const c = l.indexOf('○'); if (c >= 15 && c <= 60) h[c] = (h[c] || 0) + 1; });
  const ent = Object.entries(h).sort((a, b) => b[1] - a[1]);
  const aCol = ent.length ? +ent[0][0] : 37;
  /* 질의 칼럼 = 연번 뒤 첫 글자 위치 */
  const qm = raw.map(l => l.match(/^(\d{1,3})(\s+)\S/)).find(Boolean);
  const qCol = qm ? qm[1].length + qm[2].length : 11;

  for (const l0 of raw) {
    if (/연\s*번/.test(l0) && /(질\s*의|답\s*변)/.test(l0)) continue;
    const l = l0;                                           // ★자르지 않는다 — 자르면 답변 끝이 잘려 나간다
    const noStr = l.slice(0, qCol).trim();
    const left = l.slice(qCol, aCol).replace(/\s+/g, ' ').trim();
    const right = l.slice(aCol).replace(/\s+/g, ' ').trim();
    if (!left && !right) continue;
    if (SIDE.test(left) && !right) continue;

    const m = noStr.match(/^(\d{1,3})$/);
    if (m) { cur = { no: +m[1], page: pg, q: [], a: [] }; items.push(cur); }
    if (!cur) continue;
    if (left) cur.q.push(left);
    if (right) cur.a.push(right);
  }
}

/* 질의 끝의 (보험급여과-000호,’00.0.0.) 은 출처로 분리 */
const SRC = /\(([^()]*(?:급여과|보험과|보험급여팀|평가실|정책과|기획부|운영부)[^()]*)\)/;
const out = items.map(it => {
  let q = it.q.join(' ').replace(/\s+/g, ' ').trim();
  const sm = q.match(SRC);
  const src = sm ? sm[1].trim() : '';
  q = q.replace(new RegExp(SRC.source, 'g'), '').replace(/\s+/g, ' ').trim();
  let a = it.a.join('\n').trim();
  if (src) a += (a ? '\n\n' : '') + '[출처] ' + src;
  return { no: it.no, page: it.page, title: q, body: a };
}).filter(x => x.title.length >= 5 && x.body.replace(/\s/g, '').length >= 20);
/* HDR_STRIP — 칼럼을 가르고도 남은 머리말 문구를 마지막에 한 번 더 걷어낸다.
   제목은 한 줄이라 공백까지 정리하고, 본문은 줄바꿈을 살려 문구만 지운다. */
out.forEach(x => {
  /* 칼럼 절단으로 '요'가 잘려 "양병원 수가 실무교육자료" 로 남기도 한다 — 앞 글자를 느슨하게 */
  x.title = x.title.replace(/\s*(2022\s*)?[요양]{0,2}\s*병?원?\s*수가 실무교육자료\s*/g, ' ').replace(/\s{2,}/g, ' ').trim();
  x.body = x.body.replace(/[ \t]*(2022[ \t]*)?[요양]{0,2}[ \t]*병?원?[ \t]*수가 실무교육자료[ \t]*/g, '').replace(/[ \t]{2,}/g, ' ').trim();
});


fs.writeFileSync('adm_items.json', JSON.stringify(out), 'utf8');
console.log('항목', out.length, '/ 페이지', TABLE_FROM + '~200');
out.slice(0, 3).concat(out.slice(-2)).forEach(x =>
  console.log('\n[' + x.no + '] p' + (x.page - 4) + '쪽\nQ: ' + x.title + '\nA: ' + x.body.slice(0, 300)));
