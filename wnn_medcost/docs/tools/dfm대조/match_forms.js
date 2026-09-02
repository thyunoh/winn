/* WinCheck+ 서식(forms.tsv) ↔ SUNWOO t_unit(유닛,코드,이름) 이름 매칭 (2026-09-02)
   정규화: 공백·괄호·구두점 제거, 전각→반각, 「<…> - 」 접두 제거, 흔한 동의어 통일 */
const fs = require('fs');
const DIR = __dirname;
const norm = s => String(s || '')
  .replace(/<[^>]*>\s*-?\s*/g, '')            // <QI 계획서> - 낙상 → 낙상
  .replace(/\([^)]*\)/g, m => m)               // 괄호 안은 남긴다(구분에 쓰임)
  .replace(/[\s　·ㆍ.,:;/\-_~()（）\[\]【】「」'"`!?※★☆■□▶▷○●]/g, '')
  .replace(/점검일지|점검기록지|점검기록부|점검표|점검대장|기록지|기록부|일지|대장|관리표|관리대장|체크리스트|점검부/g, m => ({ 점검일지: '점검', 점검기록지: '점검', 점검기록부: '점검', 점검표: '점검', 점검대장: '점검', 기록지: '기록', 기록부: '기록', 일지: '기록', 대장: '기록', 관리표: '관리', 관리대장: '관리', 체크리스트: '점검', 점검부: '점검' }[m]))
  .replace(/의약품/g, '약품').replace(/냉장고온도/g, '냉장고').replace(/온습도|온도습도/g, '온습도')
  .toLowerCase();

function bigrams(s) { const a = []; for (let i = 0; i < s.length - 1; i++) a.push(s.slice(i, i + 2)); return a; }
function dice(a, b) {
  const A = bigrams(a), B = bigrams(b); if (!A.length || !B.length) return a === b ? 1 : 0;
  const m = new Map(); A.forEach(x => m.set(x, (m.get(x) || 0) + 1));
  let hit = 0; B.forEach(x => { const c = m.get(x); if (c) { hit++; m.set(x, c - 1); } });
  return 2 * hit / (A.length + B.length);
}

const units = fs.readFileSync(DIR + '/t_unit.tsv', 'utf8').split(/\r?\n/).filter(Boolean).map(l => { const [unit, code, name] = l.split('\t'); return { unit, code, name, n: norm(name), src: 'unit' }; });
const dfm = new Map(fs.readFileSync(DIR + '/dfm_index.tsv', 'utf8').split(/\r?\n/).filter(Boolean).map(l => l.split('\t')));
// ★dfm 폼 자체의 Caption(실제 화면 제목)도 후보로 — t_unit 이름과 dfm 제목이 다른 폼이 있다(유닛을 다른 서식으로 재활용)
const { decodeDelphiStr } = require('./dfm_labels.js');
dfm.forEach((p, unit) => {
  try {
    const head = fs.readFileSync(p, 'latin1').split(/\r?\n/).slice(0, 8);
    const c = head.find(l => /^\s{2}Caption\s*=/.test(l));
    if (c) { const name = decodeDelphiStr(c.replace(/^\s*Caption\s*=\s*/, '')).trim(); if (name) units.push({ unit, code: '', name, n: norm(name), src: 'dfm' }); }
  } catch (e) {}
});
const forms = fs.readFileSync(DIR + '/forms.tsv', 'utf8').split(/\r?\n/).filter(Boolean).map(l => { const [id, nm, cate, dept, axis, prd, cnt, file] = l.split('\t'); return { id, nm, cate, dept, axis, prd, cnt: Number(cnt), file, n: norm(nm) }; });

const rows = [];
forms.forEach(f => {
  let best = null, cands = [];
  units.forEach(u => {
    if (!u.n) return;
    let sc = dice(f.n, u.n);
    if (u.n === f.n) sc = 1.0;
    else if ((u.n.indexOf(f.n) >= 0 || f.n.indexOf(u.n) >= 0) && Math.min(u.n.length, f.n.length) >= 0.6 * Math.max(u.n.length, f.n.length)) sc = Math.max(sc, 0.85);
    if (u.src === 'dfm' && sc > 0) sc = sc + 0.001;   // 같은 점수면 dfm 제목(실제 화면 제목) 쪽을 앞세운다 — t_unit 이름은 유닛 재활용으로 틀린 것이 있다
    if (sc >= 0.5) cands.push({ u, sc });
  });
  cands.sort((a, b) => b.sc - a.sc);
  // 같은 유닛이 unit/dfm 두 줄로 들어오면 하나로
  const seen = new Set(); cands = cands.filter(c => { if (seen.has(c.u.unit)) return false; seen.add(c.u.unit); return true; });
  best = cands[0] || null;
  rows.push({ f, best, cands: cands.slice(0, 10) });
});
const out = rows.map(r => [r.f.id, r.f.nm, r.f.axis, r.f.cnt, r.best ? r.best.sc.toFixed(2) : '', r.best ? r.best.u.unit : '', r.best ? r.best.u.name : '', r.best && dfm.get(r.best.u.unit) ? dfm.get(r.best.u.unit) : '', r.cands.slice(1).map(c => c.u.unit + '(' + c.sc.toFixed(2) + ')').join(' ')].join('\t'));
fs.writeFileSync(DIR + '/matches.tsv', 'FORM_ID\tFORM_NM\tAXIS\tITEMS\tSCORE\tUNIT\tUNIT_NM\tDFM\tOTHERS\n' + out.join('\n'));
const exact = rows.filter(r => r.best && r.best.sc >= 0.999).length, good = rows.filter(r => r.best && r.best.sc >= 0.8 && r.best.sc < 0.999).length, weak = rows.filter(r => r.best && r.best.sc < 0.8).length, none = rows.filter(r => !r.best).length;
console.log(`서식 ${rows.length} · 정확 ${exact} · 유사(0.8~) ${good} · 약함(0.5~0.8) ${weak} · 없음 ${none} · dfm 있음 ${rows.filter(r => r.best && dfm.get(r.best.u.unit)).length}`);
