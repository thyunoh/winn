/* ============================================================
   요양병원실무업무자료.pdf → 카테고리(대·중분류) + 항목(질문) 단위 지식 데이터
     · 대분류 = 원문 장(章)  · 중분류 = 절  · 항목 = 사용자가 눌러서 물어볼 단위
   ============================================================ */
const fs = require('fs');
const P = JSON.parse(fs.readFileSync('pdf_clean2.json','utf8')); // -table 정제본 (page = i+1) — 표 행이 붙어 나온다
const QNA02 = JSON.parse(fs.readFileSync('qna02_items.json','utf8'));// 02절(2단 표) 전용 파서 결과
const ADM   = JSON.parse(fs.readFileSync('adm_items.json','utf8'));  // 행정해석(2단 표) 전용 파서 결과
const SEC02 = '02. 요양병원 환자 분류체계 및 일당정액수가 개정 관련';

const CH = [
  { key: 'PVAL', name: '환자평가표 작성',      from: 287, to: 339, ord: 1, w: 10 },
  { key: 'CLS',  name: '환자군 분류·급여기준',  from: 85,  to: 112, ord: 2, w: 9  },
  { key: 'QNA',  name: '고시 질의응답',        from: 201, to: 284, ord: 3, w: 8  },
  { key: 'SUGA', name: '수가 산정지침',        from: 15,  to: 37,  ord: 4, w: 7  },
  /* 137~157p 는 전자문서 파일 레이아웃(항목명/MODE/POSI 표)이라 질문거리가 못 된다 → 제외 */
  { key: 'CLAIM',name: '청구·명세서 작성',      from: 132, to: 170, ord: 5, w: 6, skip: [[133, 157]] },
  { key: 'ADM',  name: '행정해석(원문)',        from: 173, to: 200, ord: 6, w: 3  },
  { key: 'LAW',  name: '관련 법령',            from: 5,   to: 12,  ord: 7, w: 4  },
];

const T = s => String(s || '').replace(/\s+/g, ' ').trim();
const dense = s => String(s || '').replace(/\s/g, '').length;

/* ── 절(중분류) 제목 ── */
let qnaSecNo = 0;
function secOf(ck, t, isPageHead) {
  if (ck === 'QNA') {
    /* 절 제목(01.~13.)은 <항상 페이지 첫 줄>에 온다 — 이 조건이 없으면
       "12 '…연계 관리료Ⅰ'은 …" 같은 <질문 번호>가 절로 잘못 잡힌다. */
    if (!isPageHead) return null;
    const m = t.match(/^(0[1-9]|1[0-9])[.]?\s+(\S.{3,55})$/);
    if (!m || /[?？]$/.test(t) || +m[1] !== qnaSecNo + 1) return null;
    qnaSecNo = +m[1];
    return m[1] + '. ' + T(m[2]);
  }
  if (ck === 'PVAL') {
    let m = t.match(/^([1-4])\s+(요양병원 환자평가표|환자평가표 각 항목별 세부사항.*)$/);
    if (m) return T(m[2]);
    m = t.match(/^([A-K])\.\s*([가-힣][^.]{1,28})$/);
    if (m) return m[1] + '. ' + T(m[2]);
    return null;
  }
  if (ck === 'CLS') { const m = t.match(/^❏\s*(제\d부.{2,50})$/); return m ? T(m[1]) : null; }
  if (ck === 'SUGA') { const m = t.match(/^(제\d부\s+.{3,50})$/); return m ? T(m[1]) : null; }
  if (ck === 'CLAIM') { const m = t.match(/^([ⅠⅡⅢⅣⅤ])\.\s*(.{3,50})$/); return m ? T(m[2]) : null; }
  if (ck === 'LAW') { const m = t.match(/^([1-9])\s+(국민건강보험법.*|국민건강보험 요양급여.*|의료급여법.*)$/); return m ? T(m[2]) : null; }
  return null;
}

/* ── 항목(질문) 제목 ── */
function itemOf(ck, t) {
  if (ck === 'PVAL') {
    const m = t.match(/^([A-K])\.\s*(\d+(?:\s*[~∼]\s*\d+)?)\.\s*(\S.{1,45})$/);
    if (!m) return null;
    return { title: `${m[1]}. ${m[2]}. ${T(m[3]).replace(/\*+$/, '')}`, kind: 'ITEM' };
  }
  if (ck === 'CLS') {
    const m = t.match(/^요\s*[-­–]?\s*(\d{1,3})\s+(\S.*)$/);
    if (!m) return null;
    const rest = T(m[2]);
    let name = '';
    const g = rest.match(/^(.{2,24}?)(급여기준|산정기준|급여목록)/);
    if (g) name = T(g[1] + g[2]);
    else if (/^[가-힣A-Za-z]/.test(rest) && !/^[가-하]\.\s/.test(rest)) name = T(rest.split(/\s{2,}/)[0]).slice(0, 24);
    if (!name || name.length < 3) return null;              // 표가 이어지는 줄(요3 등)은 새 항목이 아니다
    return { title: `요${m[1]} ${name}`, kind: 'ITEM' };
  }
  if (ck === 'LAW') {
    const m = t.match(/^(제\d+조(?:의\d+)?)\s*\((.{2,30})\)/);
    return m ? { title: `${m[1]} (${T(m[2])})`, kind: 'ITEM' } : null;
  }
  if (ck === 'CLAIM') {
    const m = t.match(/^(\d{1,2})[.)]\s*(\S.{3,40})$/);
    return m && !/^\d+\)/.test(t) ? { title: T(m[2]), kind: 'ITEM' } : null;
  }
  if (ck === 'SUGA') {
    const m = t.match(/^([가-하])\.\s*(\S.{4,45})$/);
    return m ? { title: T(m[2]), kind: 'ITEM' } : null;
  }
  return null;
}

/* ── 질의응답(번호 + 물음표) ── */
function qOf(t) {
  const m = t.match(/^(\d{1,2})\s{1,3}(\S.*)$/);
  if (!m || +m[1] > 40) return null;
  return { no: +m[1], head: m[2] };
}

/* ── 글자 정리 ──────────────────────────────────────────────
     원문 PDF 는 목록 기호에 Wingdings 같은 <심볼 폰트>를 쓴다. 그 글자들은 유니코드
     사용자영역(U+E000~U+F8FF)으로 추출돼 화면에서 □(두부)로 깨져 보인다.
     읽을 수 있는 기호로 바꾸고, 깨진 글자(U+FFFD)는 지운다.                        */
const PUA = [
  [//g, '▸'],                 // Wingdings ➢
  [//g, '·'],                 // 작은 사각 불릿
  [//g, ' '],                 // 심볼 폰트의 빈칸
  [/[-]/g, '·'],       // 그 밖의 사용자영역 글자
  [/�/g, ''],                  // 변환 실패로 깨진 글자
];
function fix(s) {
  s = String(s == null ? '' : s);
  for (const [re, to] of PUA) s = s.replace(re, to);
  return s.replace(/·{2,}/g, '·').replace(/[ \t]+$/gm, '');
}

/* ── 문단 재정렬(빈 공간 채움) ─────────────────────────────
     원문은 좁은 단으로 인쇄돼 문장이 30자 안팎에서 강제로 줄바꿈돼 있다. 그대로 내보내면
     넓은 답변 화면에서 오른쪽이 텅 빈다(2026-08-04 사용자 요청 "빈 공간 채움(정렬)").
     <문장이 이어지는 줄>만 앞줄에 붙여 문단으로 만들고, 다음은 붙이지 않는다:
       · 머리기호로 시작하는 줄(○ ▸ · ※ - 번호 가.나.다. 등) = 새 항목
       · 표 행(숫자·코드 낱말이 많은 줄) = 붙이면 표가 뭉개진다
       · 앞줄이 문장 종결(다/함/음/됨/임 + 마침표 등)로 끝난 경우                    */
const MARK = /^\s*(?:[○▸·※□■☞▶\-–—]|[①-⑮]|\(?\d{1,2}[.)]\s|[가-힣]\.\s|[A-Za-z]\.\s|\(예시|\[|<|「|제\d+[조부편장]|IF|Q\d)/;
function isTableRow(t) {
  const tok = t.trim().split(/\s+/);
  if (tok.length < 4) return false;
  const numish = tok.filter(w => /^[\d,.*%~:()\-]+$|^[A-Z]{1,3}\d*$|^\d+[일원점]$/.test(w)).length;
  return numish >= Math.max(3, Math.floor(tok.length * 0.55));
}
const ENDS = /(?:[.。?？!:：”’)\]>】]|다|함|음|됨|임|것|요|함\))\s*$/;
function reflow(body) {
  const src = body.split('\n'), out = [];
  for (const line of src) {
    const t = line.trim();
    if (!t) { out.push(''); continue; }
    const prev = out.length ? out[out.length - 1] : null;
    if (prev && prev.trim() && !MARK.test(line) && !isTableRow(t) && !isTableRow(prev)
        && !ENDS.test(prev.trim()) && dense(prev) >= 18) {
      out[out.length - 1] = prev.replace(/\s+$/, '') + ' ' + t;   // 이어지는 문장 → 앞줄에 붙임
    } else {
      out.push(line);
    }
  }
  return out.join('\n');
}

const rows = [];
function push(ch, sec, title, body, page, kind) {
  title = fix(title);
  body = reflow(fix(body)).replace(/\n{3,}/g, '\n\n').trim();
  title = T(title).replace(/\s*[?？]$/, '?');
  if (!title || title.length < 4) return;
  if (dense(body) < 25) return;
  if (body.length > 6000) body = body.slice(0, 6000) + '\n…(이하 원문 참조)';
  rows.push({ ch: ch.key, chName: ch.name, chOrd: ch.ord, w: ch.w, sec: sec || '(일반)', title, body, page, kind });
}

for (const ch of CH) {
  qnaSecNo = 0;
  let sec = '', cur = null, curPage = 0, buf = [];
  const close = () => { if (cur) push(ch, cur.sec, cur.title, buf.join('\n'), curPage, cur.kind); cur = null; buf = []; };

  for (let pg = ch.from; pg <= ch.to; pg++) {
    if ((ch.skip || []).some(([a, b]) => pg >= a && pg <= b)) { close(); continue; }

    /* 질의응답 02절(206~216p)은 [연번|질의|답변] 표라 -layout 으로는 질의·답변이 섞인다.
       -table 추출본을 칼럼으로 갈라 따로 만들어 둔 결과(qna02_items.json)를 끼워 넣는다. */
    if (ch.key === 'QNA' && pg >= 206 && pg <= 216) {
      close();
      sec = SEC02; qnaSecNo = 2;
      if (pg === 206) QNA02.forEach(it => push(ch, SEC02, it.title, it.body, it.page, 'QA'));
      continue;
    }
    let headSeen = false;
    for (const raw of P[pg - 1].split('\n')) {
      const t = raw.trim();
      const isHead = !headSeen && !!t;
      if (t) headSeen = true;

      const st = secOf(ch.key, t, isHead);
      if (st) { close(); sec = st; continue; }

      if (ch.key === 'QNA') {
        const q = qOf(t);
        if (q) { close(); cur = { sec, title: q.head, kind: 'QA' }; curPage = pg; continue; }
        if (cur) buf.push(raw);
        continue;
      }

      const it = itemOf(ch.key, t);
      if (it) { close(); cur = { sec, title: it.title, kind: it.kind }; curPage = pg; buf.push(raw); continue; }

      if (cur) {
        buf.push(raw);
        if (dense(buf.join('')) > 4500) close();          // 너무 길어지면 끊는다
      } else if (ch.key === 'ADM') {
        /* 행정해석은 2단 표라 항목 분리가 불가 — 페이지 단위 원문으로 보관 */
      }
    }
    if (ch.key === 'ADM' && pg === ch.from) {
      /* 2단 표라 -layout·본문 파싱으로는 질의와 답변이 섞인다 → 전용 파서(adm2.js) 결과를 끼워 넣는다 */
      ADM.forEach(it => push(ch, '연번순', it.title, it.body, it.page, 'QA'));
    }
  }
  close();
}

/* 질의응답 제목이 다음 줄로 넘어간 경우 본문 첫 줄을 제목에 붙인다 */
rows.forEach(r => {
  if (r.kind !== 'QA' || /[?？]$/.test(r.title)) return;
  const ls = r.body.split('\n').map(x => x.trim()).filter(Boolean);
  for (let i = 0; i < Math.min(2, ls.length); i++) {
    if (/^[○※\-–]/.test(ls[i])) break;
    r.title = T(r.title + ' ' + ls[i]);
    r.body = r.body.replace(ls[i], '').trim();
    if (/[?？]$/.test(r.title)) break;
  }
  r.title = T(r.title);
});

/* 제목에 새어든 <답변 조각> 잘라내기 — 2단 표에서 답변 칼럼 글이 질의 쪽으로 넘어온 것.
     · 물음표가 제목 <중간>에 있으면 물음표까지가 질문이다.
     · 행정해석 제목에 답변 머리기호(○) 나 목록기호(가./나.)가 나오면 그 앞까지가 질문이다.
   잘라낸 나머지는 버리지 않고 본문 맨 앞에 되돌린다(답변 내용이므로). */
rows.forEach(r => {
  if (r.kind !== 'QA') return;
  let cut = -1;
  const qm = r.title.search(/[?？](?!$)/);
  if (qm >= 0) cut = qm + 1;
  else if (r.ch === 'ADM') {
    const m = r.title.search(/\s(?:○|[가-라]\.\s)/);
    if (m > 10) cut = m;
  }
  if (cut > 0 && cut < r.title.length - 1) {
    const rest = r.title.slice(cut).trim();
    r.title = T(r.title.slice(0, cut));
    if (dense(rest) > 10) r.body = (rest + '\n' + r.body).trim();
  }
});

/* ── 다듬기 ───────────────────────────────────────────────── */
/* (1) 질의응답 장의 '(일반)' = 절 표지(목록 요약) — 질문이 아니다 */
let out = rows.filter(r => !(r.ch === 'QNA' && r.sec === '(일반)'));

/* (2) 환자군 급여기준 제목은 표 칼럼이 섞여 잘리므로 확정 이름으로 교체 */
const CLS_NAME = {
  '요1': '의료최고도 급여기준', '요2': '의료고도 급여기준', '요3': '의료고도 급여기준',
  '요6': '의료경도 급여기준', '요7': '선택입원군 급여기준',
  '요51': '간호인력 확보수준에 따른 입원료 차등제', '요52': '의사인력 확보수준에 따른 입원료 차등제',
  '요53': '9인 이상 병실 입원료 감산', '요54': '요양병원 격리실 입원료',
  '요55': '요양병원 입원환자 안전관리료', '요56': '요양병원 지역사회 연계료',
};
out.forEach(r => {
  if (r.ch !== 'CLS') return;
  const k = (r.title.match(/^요\d+/) || [''])[0];
  if (CLS_NAME[k]) r.title = k + ' ' + CLS_NAME[k];
});

/* (3) 같은 절 안에서 제목이 같은 항목(페이지가 넘어가며 두 번 잡힌 것)은 본문을 합친다 */
const seen = new Map();
out = out.filter(r => {
  const k = r.ch + '|' + r.sec + '|' + r.title;
  if (seen.has(k)) { const p = seen.get(k); p.body = (p.body + '\n' + r.body).trim(); return false; }
  seen.set(k, r); return true;
});

/* (4) 제목이 너무 길면 목록에서 잘라 보여줄 짧은 제목을 따로 만든다 */
out.forEach(r => { r.short = r.title.length > 46 ? r.title.slice(0, 44) + '…' : r.title; });

/* (5) 검색 키워드 — 제목에서 조사·군더더기를 떼어낸 낱말 + 동의어 사전 */
const SYN = [
  [/욕창|피부궤양|압박성/, '욕창 피부궤양 압창 드레싱'],
  [/배뇨|실금|배뇨일지|도뇨/, '배뇨 실금 배뇨일지 도뇨 소변'],
  [/유치도뇨관|카테터|foley/i, '유치도뇨관 도뇨관 폴리 카테터 foley'],
  [/일상생활수행능력|ADL/i, 'ADL 일상생활수행능력 일상생활'],
  [/치매|인지|MMSE/i, '치매 인지기능 MMSE 인지'],
  [/의사인력|의사 인력|의사등급/, '의사인력 의사수 의사등급 차등제'],
  [/간호인력|간호사/, '간호인력 간호사 간호조무사 간호등급'],
  [/약사/, '약사 약사인력 재직일수'],
  [/격리실/, '격리실 격리 입원료'],
  [/안전관리료/, '안전관리료 환자안전 전담인력'],
  [/지역사회|퇴원지원|연계료/, '지역사회 연계료 퇴원지원 복귀'],
  [/장기입원|체감제/, '장기입원 체감제 입원기간'],
  [/환자평가표|평가표/, '환자평가표 평가표 작성'],
  [/평가구분/, '평가구분 입원평가 계속입원'],
  [/정액수가|환자군|분류체계/, '정액수가 환자군 분류체계 의료최고도 의료고도 의료중도 의료경도 선택입원군'],
  [/인증/, '인증 의료기관인증 인증조사 가산'],
  [/질 지원금|질지원금|적정성/, '적정성평가 질지원금 우수기관 향상기관'],
  [/9인 이상|병실/, '9인이상 병실 감산'],
  [/전문재활|재활치료/, '전문재활치료 재활 물리치료'],
  [/영양|경관|섭취/, '영양 경관영양 섭취 수분'],
  [/HbA1c|당화혈색소|당뇨/i, 'HbA1c 당화혈색소 당뇨'],
];
const STOP = /^(경우|여부|관련|기재|산정|방법|해당|가능|대한|따른|위한|있는|없는|하는|되는|이상|이하|미만|초과|다음|각각|모두|또는|기타)$/;
out.forEach(r => {
  const words = r.title
    .replace(/[^가-힣A-Za-z0-9]+/g, ' ')
    .split(' ')
    .map(w => w.replace(/(은|는|이|가|을|를|의|에|로|으로|와|과|도|만|까지|부터|에서|인지|한지|나요|인가요|입니까)$/, ''))
    .filter(w => w.length >= 2 && !STOP.test(w));
  const syn = SYN.filter(([re]) => re.test(r.title) || re.test(r.body.slice(0, 400))).map(([, s]) => s);
  r.kw = [...new Set(words.concat(syn.join(' ').split(' ')))].join(' ').slice(0, 480);
});

const rowsFinal = out;
fs.writeFileSync('rows.json', JSON.stringify(rowsFinal), 'utf8');
rows.length = 0; rows.push(...rowsFinal);

const stat = {};
rows.forEach(r => { stat[r.chName] = (stat[r.chName] || 0) + 1; });
console.log(stat, '총', rows.length);
console.log('\n=== 중분류/항목 수 ===');
const s2 = {};
rows.forEach(r => { const k = r.chName + ' ▸ ' + r.sec; s2[k] = (s2[k] || 0) + 1; });
Object.entries(s2).forEach(([k, v]) => console.log(String(v).padStart(4) + '  ' + k));
