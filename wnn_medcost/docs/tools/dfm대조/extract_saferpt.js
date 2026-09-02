/* 1단계(safeRpt) — 보고서·서식 시드(TBL_CODE_DTL QPS_SAFERPT_GB + TBL_QPS_SAFERPT_FORM)에서 유형·글자를 뽑아
   forms_rpt.tsv / items_rpt.tsv 로 (2026-09-02). 그 뒤는 DFM_SET=rpt 로 match_forms → compare → report 를 돌린다.
   글자 = SUB_NM · SUB_COLS(쉼표) · LBL_JSON 의 라벨 값('-' 제외) · FOOT_TXT. 점검표와 달리 라벨이 일반어(발생일시·장소)라
   대조의 뜻은 「유형 이름이 dfm 에 있고, 우리가 적은 라벨이 그 폼에 실제로 있나」다. */
const fs = require('fs'), path = require('path');
const SEED = process.argv[2] || path.join(__dirname, '../../sql/qps/seed'), DDL = path.join(__dirname, '../../sql/qps/ddl'), OUT = __dirname;
const files = [].concat(
  fs.readdirSync(DDL).filter(f => /\.sql$/i.test(f)).map(f => path.join(DDL, f)),
  fs.readdirSync(SEED).filter(f => /\.sql$/i.test(f)).map(f => path.join(SEED, f))
).map(p => ({ p, d: (path.basename(p).match(/(\d{4}-\d{2}-\d{2})/) || ['', ''])[1] })).sort((a, b) => a.d < b.d ? -1 : a.d > b.d ? 1 : a.p < b.p ? -1 : 1);
function rowsOf(body) {   // VALUES (...),(...) → [[v,...],...]  (따옴표 안 쉼표·괄호 보호)
  const out = []; let i = 0, depth = 0, q = false, cur = '', row = null;
  for (; i < body.length; i++) {
    const ch = body[i];
    if (q) { if (ch === "'") { if (body[i + 1] === "'") { cur += "'"; i++; } else q = false; } else cur += ch; continue; }
    if (ch === "'") { q = true; continue; }
    if (ch === '(') { if (depth === 0) { row = []; cur = ''; } depth++; continue; }
    if (ch === ')') { depth--; if (depth === 0 && row) { row.push(cur.trim()); out.push(row); row = null; cur = ''; } continue; }
    if (ch === ',' && depth === 1) { row.push(cur.trim()); cur = ''; continue; }
    if (depth >= 1) cur += ch;
  }
  return out;
}
const names = {}, forms = {}, order = [];
files.forEach(o => {
  const s = fs.readFileSync(o.p, 'utf8').replace(/--[^\n]*/g, '');
  let m;
  const rc = /INSERT INTO TBL_CODE_DTL\s*\(([^)]*)\)\s*VALUES\s*([\s\S]*?)(?:ON DUPLICATE[\s\S]*?)?;/gi;
  while ((m = rc.exec(s))) {
    const cols = m[1].split(',').map(c => c.trim().toUpperCase());
    rowsOf(m[2]).forEach(v => { const r = {}; cols.forEach((c, k) => r[c] = v[k]); if (r.CODE_CD === 'QPS_SAFERPT_GB' && r.SUB_CODE) names[r.SUB_CODE] = r.SUB_CODE_NM || ''; });
  }
  const rf = /INSERT INTO TBL_QPS_SAFERPT_FORM\s*\(([^)]*)\)\s*VALUES\s*([\s\S]*?)(?:ON DUPLICATE[\s\S]*?)?;/gi;
  while ((m = rf.exec(s))) {
    const cols = m[1].split(',').map(c => c.trim().toUpperCase());
    rowsOf(m[2]).forEach(v => { const r = {}; cols.forEach((c, k) => r[c] = v[k]); if (!r.RPT_GB) return; if (!forms[r.RPT_GB]) order.push(r.RPT_GB); forms[r.RPT_GB] = Object.assign(forms[r.RPT_GB] || {}, r, { file: path.basename(o.p) }); });
  }
});
// 이름만 있고 FORM 설정이 없는 유형(라벨 기본값 그대로 쓰는 것)도 대조 대상 — 이름으로만 본다
Object.keys(names).forEach(k => { if (!forms[k]) { forms[k] = { RPT_GB: k, file: '(코드만)' }; order.push(k); } });
const nul = v => (v == null || /^null$/i.test(String(v)) || String(v) === '') ? '' : String(v);
const flines = [], ilines = [];
order.forEach(id => {
  const f = forms[id], nm = names[id] || ''; let items = [], n = 0;
  // 4번째 칸(GRP_NM 자리)은 비운다 — compare 가 묶음 이름도 항목으로 세기 때문. 분류(반복행·라벨·정형문구·서명란)는 5번째 칸에
  const push = (t, g, gb) => { t = nul(t).replace(/\s+/g, ' ').trim(); if (!t || t === '-') return; items.push([id, ++n, t, '', g].join('\t')); };
  push(f.SUB_NM, '반복행', 'TEXT');
  nul(f.SUB_COLS).split(',').forEach(c => push(c, '반복행 열', 'TEXT'));
  try { const j = JSON.parse(nul(f.LBL_JSON) || '{}'); Object.keys(j).forEach(k => push(j[k], '라벨', 'TEXT')); } catch (e) {}
  push(f.FOOT_TXT, '정형문구', 'TEXT');
  nul(f.SIGN_LINE).split(',').forEach(c => push(c, '서명란', 'TEXT'));
  flines.push([id, nm, 'RPT', 'RPT', 'SAFERPT', 'D', items.length, f.file].join('\t'));
  ilines.push(...items);
});
fs.writeFileSync(path.join(OUT, 'forms_rpt.tsv'), flines.join('\n'));
fs.writeFileSync(path.join(OUT, 'items_rpt.tsv'), ilines.join('\n'));
console.log('safeRpt 유형', order.length, '(이름 있음', Object.keys(names).length, '· FORM 설정 있음', order.filter(id => forms[id].file !== '(코드만)').length + ')', '· 글자', ilines.length);
