/* pdftotext -table 출력 정제 (2026-08-04 재작업)
     ★-layout 이 아니라 -table 을 쓰는 이유:
        원문에 표가 많은데 -layout 은 <한 행의 값들을 서로 다른 줄>로 흩어 놓는다.
        (예: 질병명은 이 줄, 질병코드는 아래 줄 → 화면에서 무슨 코드인지 알 수 없다)
        -table 은 행을 붙여 준다. 대신 낱말 사이 간격이 넓어지므로 <2칸 이상 공백을 한 칸으로>
        줄여 문장을 정상화한다. 그러면 표는 "이름 코드" 한 줄로, 본문은 원래 문장으로 나온다.
     ※ [연번|질의|답변] 2단 표(질의응답 02절·행정해석)는 공백을 줄이기 <전에> 칼럼을 갈라야
        하므로 여기서 손대지 않는다 — 전용 파서(qna02.js / adm2.js)가 원본에서 직접 읽는다. */
const fs = require('fs');

const PAGES = fs.readFileSync('pdf_table.txt', 'utf8').split('\f');

/* ★머리말은 장 표시(Ⅰ·Ⅱ·Ⅲ)가 <앞에 붙기도 뒤에 붙기도> 한다 — 위치를 고정해 매칭하면
     일부 페이지에서 안 걸러지고, 그 줄이 페이지 첫 줄이 되어 <절 제목 인식이 통째로 깨진다>.
     짧은 줄에서 제목 문구만 보고 지운다. */
/* ★판별 전에 공백을 한 칸으로 접는다 — -table 출력은 낱말 사이가 여러 칸이라
     "2022  요양병원  수가  실무교육자료" 가 한 칸짜리 패턴에 안 걸려 본문에 남았다. */
const drop = t0 => {
  const t = t0.replace(/\s+/g, ' ').trim();
  return /요양\s*병원 수가 실무교육자료/.test(t) ||
    (t.length <= 44 && /요양병원 (관련 법령|수가 관련 고시 등|행정해석 등)/.test(t)) ||
    (t.length <= 44 && /요양병원 환자평가표 작성 매뉴얼/.test(t)) ||
    /건강보험심사평가원/.test(t) ||
    /HEALTH\s+INSURANCE|ASSESSMENT\s+SERVIC/.test(t) ||
    /^\d{1,3}\s*[�█\s]*$/.test(t) ||
    /* 페이지가 넘어갈 때마다 반복되는 표 머리글 — 본문 문장에 끼어들어 노이즈가 된다 */
    /^항\s*목\s*제\s*목\s*세부인정사항$/.test(t.replace(/\s/g, ' ')) ||
    /^항\s?목\s?세\s?부\s?작\s?성\s?요\s?령$/.test(t) ||
    /^연번\s*질\s*의\s*답\s*변(\s*비고)?$/.test(t);
};

/* 세로 사이드탭(장 제목을 한 글자씩 세로로 인쇄한 것) 제거
     ★글자로 판별하면 안 된다 — '수','가','등','원' 같은 흔한 글자가 본문 끝에도 온다.
       <위치>로 판별한다: 페이지 안에서 "여러 줄이 공통으로" 마지막 한 글자를 두는 칼럼을 찾아
       그 칼럼부터 잘라낸다. */
function cutSideTab(lines) {
  const col = {};
  for (const l of lines) {
    const m = l.match(/\s{2,}(\S)\s*$/);
    if (!m) continue;
    const c = l.replace(/\s+$/, '').length - 1;
    if (c >= 55) col[c] = (col[c] || 0) + 1;
  }
  const ent = Object.entries(col).sort((a, b) => b[1] - a[1]);
  if (!ent.length || ent[0][1] < 4) return lines;          // 사이드탭이 없는 페이지
  const cut = +ent[0][0];
  return lines.map(l => (l.length > cut ? l.slice(0, cut) : l).replace(/\s+$/, ''));
}

const PUA = [[//g, '▸'], [//g, '·'], [//g, ' '],
             [/[-]/g, '·'], [/�/g, '']];

function clean(txt) {
  let lines = txt.split('\n').map(l => l.replace(/\s+$/, ''));
  lines = cutSideTab(lines);
  const out = [];
  for (let l of lines) {
    for (const [re, to] of PUA) l = l.replace(re, to);
    if (!l.trim()) { out.push(''); continue; }
    if (drop(l)) continue;
    /* 들여쓰기(문단 구분)는 살리고, 낱말 사이의 넓은 간격만 한 칸으로 */
    const indent = l.match(/^\s*/)[0].length;
    const body = l.trim().replace(/\s{2,}/g, ' ');
    out.push(' '.repeat(Math.min(indent, 6)) + body);
  }
  /* -table 은 줄 사이에 빈 줄을 하나씩 끼워 넣는다 → 그대로 두면 화면에서 두 배로 성기게 보인다.
     문단 구분은 -, ·, ○, ▸, ※ 같은 머리기호가 해 주므로 빈 줄은 모두 지운다. */
  return out.join('\n').replace(/\n{2,}/g, '\n').trim();
}

const cleaned = PAGES.map(clean);
fs.writeFileSync('pdf_clean2.json', JSON.stringify(cleaned), 'utf8');
console.log('pages', cleaned.length, 'chars', cleaned.join('').length);
console.log('--- p303 (질병코드 표) ---');
console.log(cleaned[302].split('\n').slice(0, 26).join('\n'));
