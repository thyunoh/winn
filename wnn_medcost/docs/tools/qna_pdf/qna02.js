/* 질의응답 02절(환자 분류체계·일당정액수가) 은 [연번|질의|답변|비고] 표 형식이라
   -layout 추출본에서는 질의와 답변이 한 줄에 섞인다. -table 추출본에서 칼럼을 갈라 항목을 만든다. */
const fs = require('fs');

const FIRST = 206, LAST = 216;
const RAW = fs.readFileSync('qna02_raw.txt', 'utf8').split('\f');

const SIDE = /^[ⅠⅡⅢⅣⅤ요양병원관련법령수가고시등행정해석부록환자평표작성매뉴얼]$/;
const dropLine = t => !t.trim()
  || /^2022\s+요양병원 수가 실무교육자료$/.test(t.trim())
  || /요양병원 행정해석 등/.test(t.trim())
  || /건강보험심사평가원\s*$/.test(t.trim())
  || /^HEALTH INSURANCE REVIEW/.test(t.trim())
  || /^\d{1,3}\s*[�█\s]*$/.test(t.trim());

function parse() {
  const items = [];
  let cur = null;
  for (let i = 0; i < RAW.length && FIRST + i <= LAST; i++) {
    const pg = FIRST + i;
    const raw = RAW[i].split('\n');

    /* 칼럼 경계는 <헤더 글자 위치>로 잡으면 안 된다 — 표 머리글이 칸 가운데에 놓여 실제
       본문 시작 위치와 다르다. 답변 칼럼은 본문의 '○' 위치 최빈값으로, 질의 칼럼은
       연번 뒤 첫 글자 위치로 잡는다. */
    const h = {};
    raw.forEach(l => { const c = l.indexOf('○'); if (c >= 15 && c <= 60) h[c] = (h[c] || 0) + 1; });
    const ent = Object.entries(h).sort((a, b) => b[1] - a[1]);
    const aCol = ent.length ? +ent[0][0] : 33;
    const qm = raw.map(l => l.match(/^(\d{1,2})(\s+)\S/)).find(Boolean);
    const qCol = qm ? qm[1].length + qm[2].length : 4;
    const bCol = aCol + 46;                  // 그 오른쪽(비고·세로탭)은 버린다

    for (const l0 of raw) {
      if (dropLine(l0)) continue;
      if (/연\s*번/.test(l0) && /답\s*변/.test(l0)) continue;
      const l = l0.slice(0, bCol);           // 비고·세로탭 영역 제거
      const noStr = l.slice(0, qCol).trim();
      const left = l.slice(qCol, aCol).replace(/\s+/g, ' ').trim();
      const right = l.slice(aCol).replace(/\s+/g, ' ').trim();
      if (SIDE.test(left) && !right) continue;

      const m = noStr.match(/^(\d{1,2})$/);
      if (m) { cur = { no: +m[1], page: pg, q: [], a: [] }; items.push(cur); }
      if (!cur) continue;
      if (left) cur.q.push(left);
      if (right) cur.a.push(right);
    }
  }
  return items
    .map(it => ({
      page: it.page,
      title: it.q.join(' ').replace(/\s+/g, ' ').trim(),
      body: it.a.join('\n').trim(),
    }))
    .filter(x => x.title.length >= 6 && x.body.replace(/\s/g, '').length >= 15);
}

const out = parse();
/* HDR_STRIP — 칼럼을 가르고도 남은 머리말·꼬리말 문구를 마지막에 한 번 더 걷어낸다
   (표 칼럼 위치에 찍혀 줄 중간에 섞이므로 줄 단위 제거로는 안 잡힌다) */
const NOISE = [
  /\s*(2022\s*)?요양\s*병원 수가 실무교육자료\s*/g,
  /\s*HEALTH\s+INSURANCE\s+REVIEW.*?(SERVICE)?[\s�█]*\d{0,3}\s*/g,
  /\s*&?\s*ASSESSMENT\s+SERVICE[\s�█]*\d{0,3}\s*/g,
];
out.forEach(x => {
  for (const re of NOISE) { x.title = x.title.replace(re, ' '); x.body = x.body.replace(re, ' '); }
  x.title = x.title.replace(/\s{2,}/g, ' ').trim();
  x.body = x.body.replace(/[ \t]{2,}/g, ' ').replace(/^ +| +$/gm, '').trim();
});
fs.writeFileSync('qna02_items.json', JSON.stringify(out), 'utf8');
console.log('항목', out.length);
out.slice(0, 4).forEach(x => console.log('\np' + x.page + '\nQ: ' + x.title + '\nA: ' + x.body.slice(0, 200)));
